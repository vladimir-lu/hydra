/*
################################################################################
#  THIS FILE IS 100% GENERATED BY ZPROJECT; DO NOT EDIT EXCEPT EXPERIMENTALLY  #
#  Please refer to the README for information about making permanent changes.  #
################################################################################
*/

#ifndef QML_HYDRA_H
#define QML_HYDRA_H

#include <QtQml>

#include <hydra.h>
#include "qml_hydra_plugin.h"


class QmlHydra : public QObject
{
    Q_OBJECT
    
public:
    hydra_t *self;
    
    QmlHydra() { self = NULL; } // TODO: prevent declarative use - could lead to SEGV
    
    static QObject* qmlAttachedProperties(QObject* object); // defined in QmlHydra.cpp
    
public slots:
    //  Set node nickname; this is saved persistently in the Hydra configuration
    //  file.                                                                   
    void setNickname (const QString &nickname);

    //  Return our node nickname, as previously stored in hydra.cfg, or set by 
    //  the hydra_set_nickname() method. Caller must free returned string using
    //  zstr_free ().                                                          
    const QString nickname ();

    //  Set the trace level to animation of main actors; this is helpful to
    //  debug the Hydra protocol flow.                                     
    void setAnimate ();

    //  Set the trace level to animation of all actors including those used in
    //  security and discovery. Use this to collect diagnostic logs.          
    void setVerbose ();

    //  By default, Hydra needs a network interface capable of broadcast UDP  
    //  traffic, e.g. WiFi or LAN interface. To run nodes on a stand-alone PC,
    //  set the local IPC option. The node will then do gossip discovery over 
    //  IPC. Gossip discovery needs at exactly one node to be running in a    
    //  directory called ".hydra".                                            
    void setLocalIpc ();

    //  Start node. When you start a node it begins discovery and post exchange.
    //  Returns 0 if OK, -1 if it wasn't possible to start the node.            
    int start ();

    //  Return next available post, if any. Does not block. If there are no posts
    //  waiting, returns NULL. The caller can read the post using the hydra_post 
    //  API, and must destroy the post when done with it.                        
    QmlHydraPost *fetch ();
};

class QmlHydraAttached : public QObject
{
    Q_OBJECT
    QObject* m_attached;
    
public:
    QmlHydraAttached (QObject* attached) {
        Q_UNUSED (attached);
    };
    
public slots:
    //  Return the Hydra version for run-time API detection
    void version (int *major, int *minor, int *patch);

    //  Self test of this class
    void test (bool verbose);

    //  Constructor, creates a new Hydra node. Note that until you start the  
    //  node it is silent and invisible to other nodes on the network. You may
    //  specify the working directory, which defaults to .hydra in the current
    //  working directory. Creates the working directory if necessary.        
    QmlHydra *construct (const QString &directory);

    //  Destructor, destroys a Hydra node. When you destroy a node, any posts
    //  it is sending or receiving will be discarded.                        
    void destruct (QmlHydra *qmlSelf);
};


QML_DECLARE_TYPEINFO(QmlHydra, QML_HAS_ATTACHED_PROPERTIES)

#endif
/*
################################################################################
#  THIS FILE IS 100% GENERATED BY ZPROJECT; DO NOT EDIT EXCEPT EXPERIMENTALLY  #
#  Please refer to the README for information about making permanent changes.  #
################################################################################
*/
