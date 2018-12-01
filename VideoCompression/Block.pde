public class Block{
  public color[][] c;
  
  public Block(color[][] c){
    this.c=c;
  }
  
  public float compareBlock(Block b){
    float d=0;
    for(int x=0;x<c.length;x++){
      for(int y=0;y<c[0].length;y++){
        d+=dist(red(c[x][y]),green(c[x][y]),blue(c[x][y]),red(b.c[x][y]),green(b.c[x][y]),blue(b.c[x][y]));
      }
    }
    return d/c.length;
  }
}
