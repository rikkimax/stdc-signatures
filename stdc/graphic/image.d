module stdc.graphic.image;
import stdccolor = stdc.graphic.color;
import std.traits : isIntegral;
import std.math : floor;

signature ImageBase {
    alias Color;
    alias IndexType=size_t;
    
    static assert(is(Color : stdccolor.Color), "An image Color must match the stdc.graphic.color Color definition.");
    static assert(isIntegral!IndexType, "An image IndexType must be an integer");

    @property @nogc nothrow @safe {
        IndexType width();
        IndexType height() { return 1; }
    }
}

signature SharedImageBase {
    alias Color;
    alias IndexType;
    
    static assert(is(Color : stdccolor.Color), "An image Color must match the stdc.graphic.color Color definition.");
    static assert(isIntegral!IndexType, "An image IndexType must be an integer");

    @property @nogc nothrow @safe shared {
        IndexType width();
        IndexType height() { return 1; }
    }
}

signature UniformImage : ImageBase {
    static if (is(typeof(this):IndexedImage)) {
        Color opIndex(IndexType i) @nogc @safe {
            // !__traits(compiles, {typeof(this) t; Color c = t.opIndex(IndexType.init);})
            return IndexedImage(this)[cast(IndexType)(i % width), cast(IndexType)floor(i / width)];
        }
        
        void opIndexAssign(Color v, IndexType i) @nogc @safe {
            // !__traits(compiles, {typeof(this) t; t.opIndexAssign(Color.init, IndexType.init);})
            IndexedImage(this)[cast(IndexType)(i % width), cast(IndexType)floor(i / width)] = v;
        }
        
        void resize(IndexType newLength) @safe {
            IndexedImage(this).resize(cast(IndexType)(newLength % width), cast(IndexType)floor(newLength / width));
        }
    } else {
        Color opIndex(IndexType i) @nogc @safe;
        void opIndexAssign(Color v, IndexType i) @nogc @safe;
        void resize(IndexType newLength) @safe;
    }
}

signature SharedUniformImage : SharedImageBase {
    static if (is(typeof(this):SharedIndexedImage)) {
        Color opIndex(IndexType i) @nogc @safe shared {
            // !__traits(compiles, {typeof(this) t; Color c = t.opIndex(IndexType.init);})
            return SharedIndexedImage(this)[cast(IndexType)(i % width), cast(IndexType)floor(i / width)];
        }
        
        void opIndexAssign(Color v, IndexType i) @nogc @safe shared {
            // !__traits(compiles, {typeof(this) t; t.opIndexAssign(Color.init, IndexType.init);})
            SharedIndexedImage(this)[cast(IndexType)(i % width), cast(IndexType)floor(i / width)] = v;
        }
        
        void resize(IndexType newLength) @safe shared {
            SharedIndexedImage(this).resize(cast(IndexType)(newLength % width), cast(IndexType)floor(newLength / width));
        }
    } else {
        Color opIndex(IndexType i) @nogc @safe shared;
        void opIndexAssign(Color v, IndexType i) @nogc @safe shared;
        void resize(IndexType newLength) @safe shared;
    }
}

signature IndexedImage : ImageBase {
    static if (is(typeof(this):UniformImage)) {
        Color opIndex(IndexType x, IndexType y) @nogc @safe {
            // !__traits(compiles, {typeof(this) t; Color c = t.opIndex(IndexType.init, IndexType.init);})
            return UniformImage(this)[y*width+x];
        }

        void opIndexAssign(Color v, IndexType x, IndexType y) @nogc @safe {
            // !__traits(compiles, {typeof(this) t; t.opIndexAssign(Color.init, IndexType.init, IndexType.init);})
            UniformImage(this)[y*width+x] = v;
        }
        
        void resize(IndexType newWidth, IndexType newHeight) @safe {
            UniformImage(this).resize(newHeight*width+newWidth);
        }
    } else {
        Color opIndex(IndexType x, IndexType y) @nogc @safe;
        void opIndexAssign(Color v, IndexType x, IndexType y) @nogc @safe;
        void resize(IndexType newWidth, IndexType newHeight) @safe;
    }
}

signature SharedIndexedImage : SharedImageBase {
    static if (is(typeof(this):SharedUniformImage)) {
        Color opIndex(IndexType x, IndexType y) @nogc @safe shared {
            // !__traits(compiles, {typeof(this) t; Color c = t.opIndex(IndexType.init, IndexType.init);})
            return SharedUniformImage(this)[y*width+x];
        }

        void opIndexAssign(Color v, IndexType x, IndexType y) @nogc @safe shared {
            // !__traits(compiles, {typeof(this) t; t.opIndexAssign(Color.init, IndexType.init, IndexType.init);})
            SharedUniformImage(this)[y*width+x] = v;
        }
        
        void resize(IndexType newWidth, IndexType newHeight) @safe shared {
            SharedUniformImage(this).resize(newHeight*width+newWidth);
        }
    } else {
        Color opIndex(IndexType x, IndexType y) @nogc @safe shared;
        void opIndexAssign(Color v, IndexType x, IndexType y) @nogc @safe shared;
        void resize(IndexType newWidth, IndexType newHeight) @safe shared;
    }
}

signature Image : UniformImage, IndexedImage {}
signature SharedImage : SharedUniformImage, SharedIndexedImage {}

struct SwapableImage(NewColor, IImage:Image) {
    alias Color = NewColor;
    static assert(is(NewColor : stdccolor.Color), "A SwapableImage Color must match the stdc.graphic.color Color definition.");
    
    IImage source;
    
    @property @nogc nothrow @safe {
        IndexType width() { return source.width; }
        IndexType height() { return source.height; }
    }
    
    static if (is(IImage : IndexedImage)) {
        Color opIndex(IndexType x, IndexType y) @nogc @safe {
            return cast(Color)source[x, y];
        }
        
        void opIndexAssign(Color v, IndexType x, IndexType y) @nogc @safe {
            source[x, y] = cast(IImage.Color)stdccolor.Color(v);
        }
        
        void resize(IndexType newWidth, IndexType newHeight) @safe {
            source.resize(newWidth, newHeight);
        }
    }
    
    static if (is(IImage : UniformImage)) {
        Color opIndex(IndexType i) @nogc @safe {
            return cast(Color)source[i];
        }
        
        void opIndexAssign(Color v, IndexType i) @nogc @safe {
            source[i] = cast(IImage.Color)stdccolor.Color(v);
        }
        
        void resize(IndexType newLength) @safe {
            source.resize(newLength);
        }
    }
}

struct SharedSwapableImage(NewColor, IImage:SharedImage) {
    alias Color = NewColor;
    static assert(is(NewColor : stdccolor.Color), "A SwapableImage Color must match the stdc.graphic.color Color definition.");
    
    shared(IImage) source;
    
    @property @nogc nothrow @safe shared {
        IndexType width() { return source.width; }
        IndexType height() { return source.height; }
    }
    
    static if (is(IImage : SharedIndexedImage)) {
        Color opIndex(IndexType x, IndexType y) @nogc @safe shared {
            return cast(Color)source[x, y];
        }
        
        void opIndexAssign(Color v, IndexType x, IndexType y) @nogc @safe shared {
            source[x, y] = cast(IImage.Color)stdccolor.Color(v);
        }
        
        void resize(IndexType newWidth, IndexType newHeight) @safe shared {
            source.resize(newWidth, newHeight);
        }
    }
    
    static if (is(IImage : SharedUniformImage)) {
        Color opIndex(IndexType i) @nogc @safe shared {
            return cast(Color)source[i];
        }
        
        void opIndexAssign(Color v, IndexType i) @nogc @safe shared {
            source[i] = cast(IImage.Color)stdccolor.Color(v);
        }
        
        void resize(IndexType newLength) @safe shared {
            source.resize(newLength);
        }
    }
}
