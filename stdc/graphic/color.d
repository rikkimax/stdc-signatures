module stdc.graphic.color;

signature Color {
  alias ComponentType;
  enum ComponentNames;
  
  ComponentType opIndex(size_t);
  void opIndexAssign(ComponentType, size_t);
  
  AColor opCast(AColor)() const if (is(AColor:Color)) {
    assert(0);
  }
  
  // TODO: opUnary
  // TODO: opBinary
  // TODO: opOpAssign
}
