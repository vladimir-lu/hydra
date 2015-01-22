################################################################################
#  THIS FILE IS 100% GENERATED BY ZPROJECT; DO NOT EDIT EXCEPT EXPERIMENTALLY  #
#  Please refer to the README for information about making permanent changes.  #
################################################################################

module Hydra
  module FFI
    
    # Main Hydra API
    class Hydra
      class DestroyedError < RuntimeError; end
      
      # Boilerplate for self pointer, initializer, and finalizer
      class << self
        alias :__new :new
      end
      def initialize ptr, finalize=true
        @ptr = ptr
        if finalize
          @finalizer = self.class.send :create_finalizer_for, @ptr
          ObjectSpace.define_finalizer self, @finalizer
        end
      end
      def self.create_finalizer_for ptr
        Proc.new do
          ptr_ptr = ::FFI::MemoryPointer.new :pointer
          ptr_ptr.write_pointer ptr
          ::Hydra::FFI.hydra_destroy ptr_ptr
        end
      end
      # Return internal pointer
      def __ptr
        raise DestroyedError unless @ptr
        @ptr
      end
      # Nullify internal pointer and return pointer pointer
      def __ptr_give_ref
        raise DestroyedError unless @ptr
        ptr_ptr = ::FFI::MemoryPointer.new :pointer
        ptr_ptr.write_pointer @ptr
        ObjectSpace.undefine_finalizer self if @finalizer
        @finalizer = nil
        @ptr = nil
        ptr_ptr
      end
      
      # Constructor, creates a new Hydra node. Note that until you start the  
      # node it is silent and invisible to other nodes on the network. You may
      # specify the working directory, which defaults to .hydra in the current
      # working directory. Creates the working directory if necessary.        
      def self.new directory
        directory = String(directory)
        ptr = ::Hydra::FFI.hydra_new directory
        
        __new ptr
      end
      
      # Destructor, destroys a Hydra node. When you destroy a node, any posts
      # it is sending or receiving will be discarded.                        
      def destroy
        return unless @ptr
        self_p = __ptr_give_ref
        result = ::Hydra::FFI.hydra_destroy self_p
        result
      end
      
      # Set node nickname; this is saved persistently in the Hydra configuration
      # file.                                                                   
      def set_nickname nickname
        raise DestroyedError unless @ptr
        nickname = String(nickname)
        result = ::Hydra::FFI.hydra_set_nickname @ptr, nickname
        result
      end
      
      # Return our node nickname, as previously stored in hydra.cfg, or set by 
      # the hydra_set_nickname() method. Caller must free returned string using
      # zstr_free ().                                                          
      def nickname
        raise DestroyedError unless @ptr
        result = ::Hydra::FFI.hydra_nickname @ptr
        result
      end
      
      # Set the trace level to animation of main actors; this is helpful to
      # debug the Hydra protocol flow.                                     
      def set_animate
        raise DestroyedError unless @ptr
        result = ::Hydra::FFI.hydra_set_animate @ptr
        result
      end
      
      # Set the trace level to animation of all actors including those used in
      # security and discovery. Use this to collect diagnostic logs.          
      def set_verbose
        raise DestroyedError unless @ptr
        result = ::Hydra::FFI.hydra_set_verbose @ptr
        result
      end
      
      # By default, Hydra needs a network interface capable of broadcast UDP  
      # traffic, e.g. WiFi or LAN interface. To run nodes on a stand-alone PC,
      # set the local IPC option. The node will then do gossip discovery over 
      # IPC. Gossip discovery needs at exactly one node to be running in a    
      # directory called ".hydra".                                            
      def set_local_ipc
        raise DestroyedError unless @ptr
        result = ::Hydra::FFI.hydra_set_local_ipc @ptr
        result
      end
      
      # Start node. When you start a node it begins discovery and post exchange.
      # Returns 0 if OK, -1 if it wasn't possible to start the node.            
      def start
        raise DestroyedError unless @ptr
        result = ::Hydra::FFI.hydra_start @ptr
        result
      end
      
      # Return next available post, if any. Does not block. If there are no posts
      # waiting, returns NULL. The caller can read the post using the hydra_post 
      # API, and must destroy the post when done with it.                        
      def fetch
        raise DestroyedError unless @ptr
        result = ::Hydra::FFI.hydra_fetch @ptr
        result = Post.__new result, true
        result
      end
      
      # Return the Hydra version for run-time API detection
      def self.version major, minor, patch
        result = ::Hydra::FFI.hydra_version major, minor, patch
        result
      end
      
      # Self test of this class
      def self.test verbose
        verbose = !(0==verbose||!verbose) # boolean
        result = ::Hydra::FFI.hydra_test verbose
        result
      end
    end
    
  end
end

################################################################################
#  THIS FILE IS 100% GENERATED BY ZPROJECT; DO NOT EDIT EXCEPT EXPERIMENTALLY  #
#  Please refer to the README for information about making permanent changes.  #
################################################################################
