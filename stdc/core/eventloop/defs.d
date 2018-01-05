module stdc.core.eventloop.defs;
import stdc.memory.allocators;
import core.time : Duration, seconds;
import core.thread;

// description, not actually used as a type.
signature Event {
  string source;
  string type;
  
  union {
    void* wellData1Ptr;
    size_t wellData1Value;
  }
  
  union {
    void* wellData2Ptr;
    size_t wellData2Value;
  }
}

signature LoopIThing {
  @property {
    bool onMainThread() shared;
    bool onAdditionalThreads() shared;
    string description() shared;
  }
}

signature LoopSource(EventT) : LoopIThing if (is(EventT:Event)) {
  @property {
    string identifier() shared;
  }
  
  shared(LoopSourceRetriever) nextEventRetriever(shared(SharedAllocator) allocator) shared;
}

signature LoopSourceRetriever(EventT) : LoopIThing if (is(EventT:Event)) {
  bool nextEvent(ref EventT event) shared;
  void handledEvent(ref EventT event) shared;
  void unhandledEvent(ref EventT event) shared;
  void handledErrorEvent(ref EventT event) shared;
  void hintTimeout(Duration timeout) shared;
}

signature LoopConsumer(EventT) : LoopIThing if (is(EventT:Event)) {
  @property {
    string pairOnlyWithSource() shared;
    string pairOnlyWithEvents() shared;
    byte priority() shared;
  }
  
  bool processEvent(ref EventT event) shared;
}

signature LoopManager(EventT) if (is(EventT:Event)) {
  void addConsumers(shared(LoopConsumer!EventT)[]...) shared;
  void addSources(shared(LoopSource!EventT)[]...) shared;
  void clearConsumers() shared;
  void clearSources() shared;
  void addIdleCallback(void function()) shared;
  void clearIdleCallbacks() shared;
  bool isRunningOnMainThread() shared;
  bool isRunningOnAuxillaryThreads() shared;
  uint countRunningOnAuxillaryThreads() shared;
  bool runningOnThreadFor(ThreadID id = Thread.getThis().id) shared;
  void stopMainThread() shared;
  void stopAuxillaryThreads() shared;
  
  void stopAllThreads() shared {
    stopAuxillaryThreads();
    stopMainThread();
  }
  
  bool runningOnCurrentThread() shared {
   return runningOnThreadFor(); 
  }
  
  void stopCurrentThread() shared {
   stopThreadFor(); 
  }
  
  void stopThreadFor(ThreadID id = Thread.getThis().id) shared;
  void setSourceTimeout(Duration duration = 0.seconds) shared;
  void notifyOfThread(ThreadID id = Thread.getThis().id) shared;
  string describeRules() shared;
  string describeRulesFor(ThreadID id = Thread.getThis().id) shared;
  void execute() shared;
  
  void setOnErrorCallback(void function(ThreadID, Exceptione) shared) shared;
}
