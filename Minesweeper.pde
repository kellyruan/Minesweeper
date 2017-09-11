import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = 30;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

public void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r=0; r<NUM_ROWS; r++) {
        for (int c=0; c<NUM_COLS; c++) {
            buttons[r][c] = new MSButton(r,c);
        }
    }
    setBombs();
}
public void setBombs()
{
    for (int q=0; q<NUM_BOMBS; q++) {
        int randomR = (int)(Math.random()*NUM_ROWS);
        int randomC = (int)(Math.random()*NUM_COLS);
        if(!bombs.contains(buttons[randomR][randomC]))
            bombs.add(buttons[randomR][randomC]);
    }
}
public void draw ()
{
    background(0);
    if(isWon())
    {
        displayWinningMessage();
    }
} 
public boolean isWon()
{
    for (int r=0; r<NUM_ROWS; r++)
    {
      for (int c=0; c<NUM_COLS; c++)
      {
        if (!buttons[r][c].isClicked() && !bombs.contains(buttons[r][c]))
          return false;
      }
    }
    return true;
}
public void displayLosingMessage()
{
    for (int r=0; r<NUM_ROWS; r++)
    {
      for (int c=0; c<NUM_COLS; c++)
      {
        if (bombs.contains(buttons[r][c])&& !buttons[r][c].isClicked())
        {
          buttons[r][c].marked=false;
          buttons[r][c].clicked=true;
        }
      }
    }
    buttons[9][6].setLabel("G");
    buttons[9][7].setLabel("a");
    buttons[9][8].setLabel("m");
    buttons[9][9].setLabel("e");
    buttons[9][11].setLabel("O");
    buttons[9][12].setLabel("v");
    buttons[9][13].setLabel("e");
    buttons[9][14].setLabel("r");
    noLoop();
}
public void displayWinningMessage()
{
      buttons[9][7].setLabel("Y");
      buttons[9][8].setLabel("o");
      buttons[9][9].setLabel("u");
      buttons[9][11].setLabel("W");
      buttons[9][12].setLabel("o");
      buttons[9][13].setLabel("n");
      noLoop();
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked, flagged;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        flagged = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT)
        {
          clicked = false;
          flagged = !flagged;
        }
        else if(keyPressed==true)
        {
            if(marked == false)
            {
                clicked = false;
                marked=true;
            }
            if(marked == true)
            {
                marked = false;
                if(isValid(r,c-1) && buttons[r][c-1].isMarked())
                    buttons[r][c-1].mousePressed();
                if(isValid(r,c+1) && buttons[r][c+1].isMarked())
                    buttons[r][c+1].mousePressed();
                if(isValid(r-1,c) && buttons[r-1][c].isMarked())
                    buttons[r-1][c].mousePressed();
                if(isValid(r+1,c) && buttons[r+1][c].isMarked())
                    buttons[r+1][c].mousePressed();
            }
        }
        else if (bombs.contains(this))
            displayLosingMessage();
        else if (countBombs(r,c)>0)
            setLabel(""+countBombs(r,c));
        else
        {
            if (isValid(r+1,c) && buttons[r+1][c].clicked==false)
                buttons[r+1][c].mousePressed();
            if (isValid(r,c+1) && buttons[r][c+1].clicked==false)
                buttons[r][c+1].mousePressed();
            if (isValid(r+1,c+1) && buttons[r+1][c+1].clicked==false)
                buttons[r+1][c+1].mousePressed();
            if (isValid(r-1,c) && buttons[r-1][c].clicked==false)
                buttons[r-1][c].mousePressed();
            if (isValid(r,c-1) && buttons[r][c-1].clicked==false)
                buttons[r][c-1].mousePressed();
            if (isValid(r-1,c-1) && buttons[r-1][c-1].clicked==false)
                buttons[r-1][c-1].mousePressed();
            if (isValid(r+1,c-1) && buttons[r+1][c-1].clicked==false)
                buttons[r+1][c-1].mousePressed();
            if (isValid(r-1,c+1) && buttons[r-1][c+1].clicked==false)
                buttons[r-1][c+1].mousePressed();
        }
    }
    public void draw () 
    {    
        if(flagged)
            fill(0,255,0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if(r<20&&r>=0&&c<20&&c>=0)
            return true;
        else
            return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        if (isValid(row+1,col) && bombs.contains(buttons[row+1][col]))
            numBombs+=1;
        if (isValid(row,col+1) && bombs.contains(buttons[row][col+1]))
            numBombs+=1;
        if (isValid(row+1,col+1) && bombs.contains(buttons[row+1][col+1]))
            numBombs+=1;
        if (isValid(row-1,col) && bombs.contains(buttons[row-1][col]))
            numBombs+=1;
        if (isValid(row,col-1) && bombs.contains(buttons[row][col-1]))
            numBombs+=1;
        if (isValid(row-1,col-1) && bombs.contains(buttons[row-1][col-1]))
            numBombs+=1;
        if (isValid(row+1,col-1) && bombs.contains(buttons[row+1][col-1]))
            numBombs+=1;
        if (isValid(row-1,col+1) && bombs.contains(buttons[row-1][col+1]))
            numBombs+=1;
        return numBombs;
   }
}
