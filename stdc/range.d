module range;

signature InputRange {
    alias Type=typeof(this.front());
    
    Type moveFront();
    
    @property {
        Type front();
        bool empty();
    }
    
    void popFront();
    
    int opApply(scope int delegate(Type));
    int opApply(scope int delegate(size_t, Type));
}

signature InputAssignable : InputRange {
    @property {
        void front(Type newVal);
    }
}

signature ForwardRange : InputRange {
    @property {
        ForwardRange save();
    }
}

signature ForwardAssignable : InputAssignable, ForwardRange {
    @property {
        ForwardAssignable save();
    }
}

signature BidirectionalRange : ForwardRange {
    @property {
        BidirectionalRange save();
        Type back();
    }
    
    Type moveBack();
    void popBack();
}

signature BidirectionalAssignable : ForwardAssignable, BidirectionalRange {
    @property {
        BidirectionalAssignable save();
        void back(Type newVal);
    }
}

siganture RandomAccessFinite : BidirectionalRange {
    @property {
        RandomAccessFinite save();
        size_t length();
    }
    
    alias opDollar = length;
    
    Type opIndex(size_t);
    Type moveAt(size_t);
    RandomAccessFinite opSlice(size_t, size_t);
}

signature RandomAccessAssignable : ForwardAssignable, BidirectionalRange {
    @property {
        RandomAccessAssignable save();
        void back(Type newVal);
    }
}

signature RandomAccessInfinite : ForwardRange {
    @property {    
        RandomAccessInfinite save();
    }
    
    Type moveAt(size_t);
    Type opIndex(size_t);
}

signature OutputRange {
    alias Type=typeof(this.front());
    
    void opOpAssign(string op)(Type[] values...) if (op == "~=") {
        static if (__traits(compiles, { this ~= values; })) {
            this ~= values;
        } else {
            foreach(v; values) {
                put(v);
            }
        }
    }
    
    void put(Type);
}

signature InfiniteInputRange : InputRange {
    enum bool empty;
    static assert(!empty);
}
