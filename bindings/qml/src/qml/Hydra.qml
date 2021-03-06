
import QtQml 2.1

import QmlHydra 1.0


QtObject {
  id: root
  
  // Properties of the C hydra class
  property var nickname: undefined
  property string directory: "/tmp/hydra"
  property bool useLocalIPC: false
  property bool verbose: false
  property bool animate: false
  
  // Properties of the QML wrapper
  property int fetchInterval: 500 // how often to check for new messages (in ms)
  
  // This signal is emitted whenever a new post is fetched.
  // The post object is a static object containing the post's properties.
  signal fetched(var post)
  
  // Enter the given post object into hydra storage for sharing.
  signal store(var post)
  onStore: priv.store(post)
  
  // Creat and destroy the service along with this object
  Component.onCompleted: priv.createHydra()
  Component.onDestruction: priv.destroyHydra()
  
  // Allow QtObjects to be nested freely within (to no effect)
  property list<QtObject> children
  default property alias _children: root.children // Workaround; QTBUG-15127
  
  // Private implementation details
  property QtObject _priv: QtObject {
    id: priv
    
    // The underlying QmlHydra instance
    property QmlHydra hydra
    
    // Create a new QmlHydra instance with the current properties set
    function createHydra() {
      hydra = QmlHydra.construct(root.directory)
      
      if (!hydra.isNULL) {
        if (root.verbose)     hydra.setVerbose()
        if (root.animate)     hydra.setAnimate()
        if (root.useLocalIPC) hydra.setLocalIpc()
        if (root.nickname)    hydra.setNickname(root.nickname)
        
        hydra.start()            // Start the underlying hydra actors
        fetchInitialFromLedger() // Grab existing posts from our node
        fetcher.start()          // Start fetching posts from other nodes
      }
      else
        console.error("ERROR: hydra_new failed in directory:", root.directory)
    }
    
    function fetchInitialFromLedger() {
      var ledger = QmlHydraLedger.construct()
      ledger.load()
      var post
      var i = 0
      while (!((post = ledger.fetch(i++)).isNULL))
        handleFetched(post)
      
      QmlHydraLedger.destruct(ledger)
    }
    
    function store(post) {
      post.subject  = post.subject  || ""
      post.parentId = post.parentId || ""
      post.mimeType = post.mimeType || ""
      post.content  = post.content  || ""
      post.location = post.location || ""
      
      if (post.location.length > 0)
        hydra.storeFile(
          post.subject, post.parentId, post.mimeType, post.location)
      else
        hydra.storeString(
          post.subject, post.parentId, post.mimeType, post.content)
      
      echoStored(post) // Echo back to self to simulate fetch for viewing
    }
    
    function echoStored(post) {
      var echo = QmlHydraPost.construct(post.subject)
      echo.setParentId(post.parentId)
      echo.setMimeType(post.mimeType)
      
      if (post.location.length > 0)
        echo.setFile(post.location)
      else
        echo.setContent(post.content)
      
      handleFetched(echo)
    }
    
    function handleFetched(post) {
      root.fetched ({
        parentId:    post.parentId(),
        ident:       post.ident(),
        timestamp:   post.timestamp(),
        subject:     post.subject(),
        mimeType:    post.mimeType(),
        content:     post.content(),
        location:    post.location(),
        // TODO: copy other properties
      })
      QmlHydraPost.destruct(post)
    }
    
    // Destroy the current QmlHydra instance
    function destroyHydra() {
      fetcher.stop()
      QmlHydra.destruct(hydra)
    }
    
    // The Timer for periodically checking for new messages
    property Timer fetcher: Timer {
      interval: root.fetchInterval
      repeat: true
      triggeredOnStart: true
      
      // On each tick, fetch as many posts as are available from the service,
      // converting them to javascript objects and destroying the originals.
      onTriggered: {
        if (priv.hydra.isNULL) return
        var post
        while (!((post = priv.hydra.fetch()).isNULL))
          priv.handleFetched(post)
      }
    }
  }
}
