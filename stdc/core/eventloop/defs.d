module stdc.core.eventloop.defs;
import stdc.memory.allocators;
import core.time : Duration;

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
  
}
