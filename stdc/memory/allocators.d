module stdc.memory.allocators;
import std.traits : isBasicType;
improt std.typecons : Ternary;

signature Allocator {
    @property @nogc nothrow {
        uint alignment();
        size_t goodAllocAmount(size_t);
        ubyte[] allocate(size_t, TypeInfo ti = null);
        ubyte[] alignedAllocate(size_t n, uint a) { return null; }
        ubyte[] allocateAll() { return null; }
        bool expand(ref void[], size_t) { return false; }
        bool reallocate(ref void[], size_t);
        bool alignedReallocate(ref void[] b, size_t size, uint alignment) { return null; }
        
        Ternary owns(void[] b) { return Ternary.unknown; }
        Ternary resolveInternalPointer(const void* p, ref ubyte[] result) { return Ternary.unknown; }
        bool deallocate(ubyte[] b) { return false; }
        bool deallocateAll() { return false; }
        Ternary empty() { return Ternary.unknown; }
    }
}

signature SharedAllocator {
    @property @nogc nothrow shared {
        uint alignment();
        size_t goodAllocAmount(size_t);
        shared(ubyte[]) allocate(size_t, TypeInfo ti = null);
        shared(ubyte[]) alignedAllocate(size_t n, uint a) { return null; }
        shared(ubyte[]) allocateAll() { return null; }
        bool expand(ref void[], size_t) { return false; }
        bool reallocate(ref void[], size_t);
        bool alignedReallocate(ref void[] b, size_t size, uint alignment) { return null; }
        
        Ternary owns(void[] b) { return Ternary.unknown; }
        Ternary resolveInternalPointer(const void* p, ref ubyte[] result) { return Ternary.unknown; }
        bool deallocate(ubyte[] b) { return false; }
        bool deallocateAll() { return false; }
        Ternary empty() { return Ternary.unknown; }
    }
    
    scope Allocator opCast(T)() if (is(T : Allocator)) {
        return Allocator(this);   
    }
}

T make(T, IAllocator:Allocator, A...)(scope IAllocator alloc, auto ref A args) {
   assert(0); 
}

T[] makeArray(T, IAllocator:Allocator)(scope IAllocator alloc, size_t length) {
    T default;
    return makeArray!T(alloc, length, default);
}

T[] makeArray(T, IAllocator:Allocator)(scope IAllocator alloc, size_t length, auto ref T init) {
    assert(0);   
}

// TODO: Unqual!(ElementEncodingType!R)[] makeArray(Allocator, R)(auto ref Allocator alloc, R range) if (isInputRange!R && !isInfinite!R); 
// TODO: T[] makeArray(T, Allocator, R)(auto ref Allocator alloc, R range) if (isInputRange!R && !isInfinite!R);

bool expandArray(T, IAllocator:Allocator)(scope IAllocator alloc, ref T[] array, size_t delta) {
    T default;
    return expandArray!T(alloc, array, delta, default);
}

bool expandArray(T, IAllocator:Allocator)(scope IAllocator alloc, ref T[] array, size_t delta, auto ref T init) {
    assert(0);
}

// TODO: bool expandArray(T, Allocator, R)(auto ref Allocator alloc, ref T[] array, R range) if (isInputRange!R);

bool shrinkArray(T, IAllocator:Allocator)(scope IAllocator alloc, ref T[] array, size_t delta) {
    assert(0);   
}

void dispose(T, IAllocator:Allocator)(scope IAllocator alloc, auto ref T* p) {
    assert(0);
}

void dispose(T, IAllocator:Allocator)(scope IAllocator alloc, auto ref T p) {
    assert(0);   
}

void dispose(T, IAllocator:IAllocator)(scope IAllocator alloc, auto ref T[] array) {
    assert(0);   
}

auto makeMultiDimensionalArray(T, IAllocator:Allocator, size_t N)(scope Allocator alloc, size_t[N] lengths...) {
    assert(0);   
}

void disposeMultiDimensionalArray(T, IAllocator:Allocator)(scope Allocator alloc, auto ref T[] array) {
    assert(0);   
}
   
