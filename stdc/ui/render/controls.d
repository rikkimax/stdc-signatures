module stdc.ui.render.controls;

signature UIModel {
  int x, y;
  uint width, height;
  bool isDisabled;
  
  Model opCast(Model:UIModel)() {
     Model ret;
     castToImpl(Model.mangleof, ret);
     return ret;
  }
  
  void castToImpl(string toName, UIModel* location) {
    castToImpl2!(__traits(parent, castToImpl))(toName, location);
  }
}

private {
  void castToImpl2(Self)(ref Self self, string toName, UIModel* location) {
    static if (is(Self == UIModel)) {
    } else {
      alias Self = __traits(parent, castToImpl);
      if (toName == Self.mangleof) {
        Self* dest = cast(Self*)cast(void*)location;
        // this will reinitialize a new signature vtable
        *dest = self;
      } else {
        alias Parent = __traits(parent, Self);
        castToImpl2!Parent(self, toName, location);
      }
    }
  }
}

signature PushButton : UIModel {
  State state;
  
  enum State {
    Up,
    Down
  }
}
