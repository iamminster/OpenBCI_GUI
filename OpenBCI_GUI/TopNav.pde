///////////////////////////////////////////////////////////////////////////////////////
//
//  Created by Conor Russomanno, 11/3/16
//  Extracting old code Gui_Manager.pde, adding new features for GUI v2 launch
//
///////////////////////////////////////////////////////////////////////////////////////

import java.awt.Desktop;
import java.net.*;

int navBarHeight = 32;
TopNav topNav;

class TopNav {

  // PlotFontInfo fontInfo;

  Button stopButton;
  public final static String stopButton_pressToStop_txt = "Stop Data Stream";
  public final static String stopButton_pressToStart_txt = "Start Data Stream";

  Button filtBPButton;
  Button filtNotchButton;

  Button tutorialsButton;
  Button shopButton;
  Button issuesButton;


  Button layoutButton;

  LayoutSelector layoutSelector;
  TutorialSelector tutorialSelector;

  //constructor
  TopNav(){

    stopButton = new Button(3, 35, 170, 26, stopButton_pressToStart_txt, fontInfo.buttonLabel_size);
    stopButton.setFont(h3, 16);
    stopButton.setColorNotPressed(color(184, 220, 105));
    stopButton.setHelpText("Press this button to Stop/Start the data stream. Or press <SPACEBAR>");

    filtNotchButton = new Button(7 + stopButton.but_dx, 35, 70, 26, "Notch\n" + dataProcessing.getShortNotchDescription(), fontInfo.buttonLabel_size);
    filtNotchButton.setFont(p5, 12);
    filtBPButton = new Button(11 + stopButton.but_dx + 70, 35, 70, 26, "BP Filt\n" + dataProcessing.getShortFilterDescription(), fontInfo.buttonLabel_size);
    filtBPButton.setFont(p5, 12);

    tutorialsButton = new Button(width - 3 - 80, 3, 80, 26, "Tutorials", fontInfo.buttonLabel_size);
    tutorialsButton.setFont(h3, 16);
    tutorialsButton.setHelpText("Here you will find links to helpful online tutorials and getting started guides. Also, check out how to create custom widgets for the GUI!");

    layoutButton = new Button(width - 3 - 70, 35, 70, 26, "Layout", fontInfo.buttonLabel_size);
    layoutButton.setHelpText("Here you can alter the overall layout of the GUI, allowing for different container configurations with more or less widgets.");
    layoutButton.setFont(h3, 16);

    issuesButton = new Button(width - 3*2 - 70 - tutorialsButton.but_dx, 3, 70, 26, "Issues", fontInfo.buttonLabel_size);
    issuesButton.setHelpText("If you have suggestions or want to share a bug you've found, please create an issue on the GUI's Github repo!");
    issuesButton.setURL("https://github.com/OpenBCI/OpenBCI_GUI_v2.0/issues");
    issuesButton.setFont(h3, 16);

    shopButton = new Button(width - 3*3 - 70 - issuesButton.but_dx - tutorialsButton.but_dx, 3, 70, 26, "Shop", fontInfo.buttonLabel_size);
    shopButton.setHelpText("Head to our online store to purchase the latest OpenBCI hardware and accessories.");
    shopButton.setURL("http://shop.openbci.com/");
    shopButton.setFont(h3, 16);

    layoutSelector = new LayoutSelector();
    tutorialSelector = new TutorialSelector();

  }

  void update(){
    layoutSelector.update();
    tutorialSelector.update();
  }

  void draw(){
    pushStyle();
    noStroke();
    fill(229);
    rect(0, 0, width, topNav_h);
    stroke(31,69,110);
    fill(255);
    rect(-1, 0, width+2, navBarHeight);
    popStyle();

    stopButton.draw();

    filtBPButton.draw();
    filtNotchButton.draw();

    tutorialsButton.draw();
    layoutButton.draw();
    issuesButton.draw();
    shopButton.draw();

    image(logo, width/2 - (128/2) - 2, 6, 128, 22);

    layoutSelector.draw();
    tutorialSelector.draw();

  }

  void screenHasBeenResized(int _x, int _y){
    tutorialsButton.but_x = width - 3 - 26;
    layoutButton.but_x = width - 3 - 70;
    issuesButton.but_x = width - 3*2 - 70 - tutorialsButton.but_dx;
    shopButton.but_x = width - 3*3 - 70 - issuesButton.but_dx - tutorialsButton.but_dx;

    layoutSelector.screenResized();     //pass screenResized along to layoutSelector
    tutorialSelector.screenResized();
  }

  void mousePressed(){
    if (stopButton.isMouseHere()) {
      stopButton.setIsActive(true);
      stopButtonWasPressed();
    }
    if (filtBPButton.isMouseHere()) {
      filtBPButton.setIsActive(true);
      incrementFilterConfiguration();
    }
    if (topNav.filtNotchButton.isMouseHere()) {
      filtNotchButton.setIsActive(true);
      incrementNotchConfiguration();
    }
    if (tutorialsButton.isMouseHere()) {
      tutorialsButton.setIsActive(true);
      //toggle help/tutorial dropdown menu
    }
    if (issuesButton.isMouseHere()) {
      issuesButton.setIsActive(true);
      //toggle help/tutorial dropdown menu
    }
    if (shopButton.isMouseHere()) {
      shopButton.setIsActive(true);
      //toggle help/tutorial dropdown menu
    }
    if (layoutButton.isMouseHere()) {
      layoutButton.setIsActive(true);
      //toggle layout window to enable the selection of your container layoutButton...
    }

    layoutSelector.mousePressed();     //pass mousePressed along to layoutSelector
    tutorialSelector.mousePressed();
  }

  void mouseReleased(){

    if(!tutorialSelector.isVisible){ //make sure that you can't open the layout selector accidentally
      if (layoutButton.isMouseHere() && layoutButton.isActive()) {
        layoutSelector.toggleVisibility();
        layoutButton.setIsActive(true);
        wm.printLayouts();
      }
    }

    if (tutorialsButton.isMouseHere() && tutorialsButton.isActive()) {
      tutorialSelector.toggleVisibility();
      tutorialsButton.setIsActive(true);
    }

    if (issuesButton.isMouseHere() && issuesButton.isActive()) {
      //go to Github issues
      issuesButton.goToURL();
    }

    if (shopButton.isMouseHere() && shopButton.isActive()) {
      //go to OpenBCI Shop
      shopButton.goToURL();
    }

    stopButton.setIsActive(false);

    filtBPButton.setIsActive(false);
    filtNotchButton.setIsActive(false);

    tutorialsButton.setIsActive(false);
    layoutButton.setIsActive(false);
    issuesButton.setIsActive(false);
    shopButton.setIsActive(false);

    layoutSelector.mouseReleased();    //pass mouseReleased along to layoutSelector
    tutorialSelector.mouseReleased();
  }

}

//=============== OLD STUFF FROM Gui_Manger.pde ===============//

void incrementFilterConfiguration() {
  dataProcessing.incrementFilterConfiguration();

  //update the button strings
  topNav.filtBPButton.but_txt = "BP Filt\n" + dataProcessing.getShortFilterDescription();
  // topNav.titleMontage.string = "EEG Data (" + dataProcessing.getFilterDescription() + ")";
}

void incrementNotchConfiguration() {
  dataProcessing.incrementNotchConfiguration();

  //update the button strings
  topNav.filtNotchButton.but_txt = "Notch\n" + dataProcessing.getShortNotchDescription();
  // topNav.titleMontage.string = "EEG Data (" + dataProcessing.getFilterDescription() + ")";
}

class LayoutSelector{

  int x, y, w, h, margin, b_w, b_h;
  boolean isVisible;

  ArrayList<Button> layoutOptions; //

  LayoutSelector(){
    w = 180;
    x = width - w - 3;
    y = (navBarHeight * 2) - 3;
    margin = 6;
    b_w = (w - 5*margin)/4;
    b_h = b_w;
    h = margin*3 + b_h*2;


    isVisible = false;

    layoutOptions = new ArrayList<Button>();
    addLayoutOptionButton();
  }

  void update(){
    if(isVisible){ //only update if visible
      //close dropdown when mouse leaves
      if((mouseX < x || mouseX > x + w || mouseY < y || mouseY > y + h) && !topNav.layoutButton.isMouseHere()){
        toggleVisibility();
      }
    }
  }

  void draw(){
    if(isVisible){ //only draw if visible
      pushStyle();

      // println("it's happening");
      stroke(31,69,110);
      // fill(229); //bg
      fill(255); //bg
      rect(x, y, w, h);

      for(int i = 0; i < layoutOptions.size(); i++){
        layoutOptions.get(i).draw();
      }

      // fill(255);
      fill(177, 184, 193);
      noStroke();
      rect(x+w-(topNav.layoutButton.but_dx-1), y, (topNav.layoutButton.but_dx-1), 1);

      popStyle();
    }
  }

  void isMouseHere(){

  }

  void mousePressed(){
    //only allow button interactivity if isVisible==true
    if(isVisible){
      for(int i = 0; i < layoutOptions.size(); i++){
        if(layoutOptions.get(i).isMouseHere()){
          layoutOptions.get(i).setIsActive(true);
        }
      }
    }
  }

  void mouseReleased(){
    //only allow button interactivity if isVisible==true
    if(isVisible){
      if((mouseX < x || mouseX > x + w || mouseY < y || mouseY > y + h) && !topNav.layoutButton.isMouseHere()){
        toggleVisibility();
      }
      for(int i = 0; i < layoutOptions.size(); i++){
        if(layoutOptions.get(i).isMouseHere() && layoutOptions.get(i).isActive()){
          int layoutSelected = i+1;
          println("Layout [" + layoutSelected + "] selected.");
          output("Layout [" + layoutSelected + "] selected.");
          layoutOptions.get(i).setIsActive(false);
          toggleVisibility(); //shut layoutSelector if something is selected
          wm.setNewContainerLayout(layoutSelected-1); //have WidgetManager update Layout and active widgets
        }
      }
    }
  }

  void screenResized(){
    //update position of outer box and buttons
    int oldX = x;
    x = width - w - 3;
    int dx = oldX - x;
    for(int i = 0; i < layoutOptions.size(); i++){
      layoutOptions.get(i).setX(layoutOptions.get(i).but_x - dx);
    }

  }

  void toggleVisibility(){
    isVisible = !isVisible;
    if(isVisible){
      //the very convoluted way of locking all controllers of a single controlP5 instance...
      for(int i = 0; i < wm.widgets.size(); i++){
        for(int j = 0; j < wm.widgets.get(i).cp5_widget.getAll().size(); j++){
          wm.widgets.get(i).cp5_widget.getController(wm.widgets.get(i).cp5_widget.getAll().get(j).getAddress()).lock();
        }
      }

    }else{
      //the very convoluted way of unlocking all controllers of a single controlP5 instance...
      for(int i = 0; i < wm.widgets.size(); i++){
        for(int j = 0; j < wm.widgets.get(i).cp5_widget.getAll().size(); j++){
          wm.widgets.get(i).cp5_widget.getController(wm.widgets.get(i).cp5_widget.getAll().get(j).getAddress()).unlock();
        }
      }
    }
  }

  void addLayoutOptionButton(){

    //FIRST ROW

    //setup button 1 -- full screen
    Button tempLayoutButton = new Button(x + margin, y + margin, b_w, b_h, "N/A");
    PImage tempBackgroundImage = loadImage("layout_buttons/layout_1.png");
    tempLayoutButton.setBackgroundImage(tempBackgroundImage);
    layoutOptions.add(tempLayoutButton);

    //setup button 2 -- 2x2
    tempLayoutButton = new Button(x + 2*margin + b_w*1, y + margin, b_w, b_h, "N/A");
    tempBackgroundImage = loadImage("layout_buttons/layout_2.png");
    tempLayoutButton.setBackgroundImage(tempBackgroundImage);
    layoutOptions.add(tempLayoutButton);

    //setup button 3 -- 2x1
    tempLayoutButton = new Button(x + 3*margin + b_w*2, y + margin, b_w, b_h, "N/A");
    tempBackgroundImage = loadImage("layout_buttons/layout_3.png");
    tempLayoutButton.setBackgroundImage(tempBackgroundImage);
    layoutOptions.add(tempLayoutButton);

    //setup button 4 -- 1x2
    tempLayoutButton = new Button(x + 4*margin + b_w*3, y + margin, b_w, b_h, "N/A");
    tempBackgroundImage = loadImage("layout_buttons/layout_4.png");
    tempLayoutButton.setBackgroundImage(tempBackgroundImage);
    layoutOptions.add(tempLayoutButton);

    //SECOND ROW

    //setup button 5
    tempLayoutButton = new Button(x + margin, y + 2*margin + 1*b_h, b_w, b_h, "N/A");
    tempBackgroundImage = loadImage("layout_buttons/layout_5.png");
    tempLayoutButton.setBackgroundImage(tempBackgroundImage);
    layoutOptions.add(tempLayoutButton);

    //setup button 6
    tempLayoutButton = new Button(x + 2*margin + b_w*1, y + 2*margin + 1*b_h, b_w, b_h, "N/A");
    tempBackgroundImage = loadImage("layout_buttons/layout_6.png");
    tempLayoutButton.setBackgroundImage(tempBackgroundImage);
    layoutOptions.add(tempLayoutButton);

    //setup button 7
    tempLayoutButton = new Button(x + 3*margin + b_w*2, y + 2*margin + 1*b_h, b_w, b_h, "N/A");
    tempBackgroundImage = loadImage("layout_buttons/layout_7.png");
    tempLayoutButton.setBackgroundImage(tempBackgroundImage);
    layoutOptions.add(tempLayoutButton);

    //setup button 8
    tempLayoutButton = new Button(x + 4*margin + b_w*3, y + 2*margin + 1*b_h, b_w, b_h, "N/A");
    tempBackgroundImage = loadImage("layout_buttons/layout_8.png");
    tempLayoutButton.setBackgroundImage(tempBackgroundImage);
    layoutOptions.add(tempLayoutButton);

    //THIRD ROW -- commented until more widgets are added

    h = margin*4 + b_h*3;
    //setup button 9
    tempLayoutButton = new Button(x + margin, y + 3*margin + 2*b_h, b_w, b_h, "N/A");
    tempBackgroundImage = loadImage("layout_buttons/layout_9.png");
    tempLayoutButton.setBackgroundImage(tempBackgroundImage);
    layoutOptions.add(tempLayoutButton);

    //setup button 10
    tempLayoutButton = new Button(x + 2*margin + b_w*1, y + 3*margin + 2*b_h, b_w, b_h, "N/A");
    tempBackgroundImage = loadImage("layout_buttons/layout_10.png");
    tempLayoutButton.setBackgroundImage(tempBackgroundImage);
    layoutOptions.add(tempLayoutButton);

    //setup button 11
    tempLayoutButton = new Button(x + 3*margin + b_w*2, y + 3*margin + 2*b_h, b_w, b_h, "N/A");
    tempBackgroundImage = loadImage("layout_buttons/layout_11.png");
    tempLayoutButton.setBackgroundImage(tempBackgroundImage);
    layoutOptions.add(tempLayoutButton);

    //setup button 12
    tempLayoutButton = new Button(x + 4*margin + b_w*3, y + 3*margin + 2*b_h, b_w, b_h, "N/A");
    tempBackgroundImage = loadImage("layout_buttons/layout_12.png");
    tempLayoutButton.setBackgroundImage(tempBackgroundImage);
    layoutOptions.add(tempLayoutButton);

  }

  void updateLayoutOptionButtons(){

  }

}

class TutorialSelector{

  int x, y, w, h, margin, b_w, b_h;
  boolean isVisible;

  ArrayList<Button> tutorialOptions; //

  TutorialSelector(){
    w = 180;
    x = width - w - 3;
    y = (navBarHeight) - 3;
    margin = 6;
    b_w = w - margin*2;
    b_h = 22;
    h = margin*3 + b_h*2;


    isVisible = false;

    tutorialOptions = new ArrayList<Button>();
    addTutorialButtons();
  }

  void update(){
    if(isVisible){ //only update if visible
      //close dropdown when mouse leaves
      if((mouseX < x || mouseX > x + w || mouseY < y || mouseY > y + h) && !topNav.tutorialsButton.isMouseHere()){
        toggleVisibility();
      }
    }
  }

  void draw(){
    if(isVisible){ //only draw if visible
      pushStyle();

      // println("it's happening");
      stroke(31,69,110);
      // fill(229); //bg
      fill(255); //bg
      rect(x, y, w, h);

      for(int i = 0; i < tutorialOptions.size(); i++){
        tutorialOptions.get(i).draw();
      }

      // fill(255);
      fill(177, 184, 193);
      noStroke();
      rect(x+w-(topNav.tutorialsButton.but_dx-1), y, (topNav.tutorialsButton.but_dx-1) , 1);

      popStyle();
    }
  }

  void isMouseHere(){

  }

  void mousePressed(){
    //only allow button interactivity if isVisible==true
    if(isVisible){
      for(int i = 0; i < tutorialOptions.size(); i++){
        if(tutorialOptions.get(i).isMouseHere()){
          tutorialOptions.get(i).setIsActive(true);
        }
      }
    }
  }

  void mouseReleased(){
    //only allow button interactivity if isVisible==true
    if(isVisible){
      if((mouseX < x || mouseX > x + w || mouseY < y || mouseY > y + h) && !topNav.tutorialsButton.isMouseHere()){
        toggleVisibility();
      }
      for(int i = 0; i < tutorialOptions.size(); i++){
        if(tutorialOptions.get(i).isMouseHere() && tutorialOptions.get(i).isActive()){
          int tutorialSelected = i+1;
          tutorialOptions.get(i).setIsActive(false);
          tutorialOptions.get(i).goToURL();
          println("Attempting to use your default web browser to open " + tutorialOptions.get(i).myURL);
          output("Layout [" + tutorialSelected + "] selected.");
          toggleVisibility(); //shut layoutSelector if something is selected
          //open corresponding link
        }
      }
    }
  }

  void screenResized(){
    //update position of outer box and buttons
    int oldX = x;
    x = width - w - 3;
    int dx = oldX - x;
    for(int i = 0; i < tutorialOptions.size(); i++){
      tutorialOptions.get(i).setX(tutorialOptions.get(i).but_x - dx);
    }

  }

  void toggleVisibility(){
    isVisible = !isVisible;
    if(isVisible) {
      //the very convoluted way of locking all controllers of a single controlP5 instance...
      for(int i = 0; i < wm.widgets.size(); i++){
        for(int j = 0; j < wm.widgets.get(i).cp5_widget.getAll().size(); j++){
          wm.widgets.get(i).cp5_widget.getController(wm.widgets.get(i).cp5_widget.getAll().get(j).getAddress()).lock();
        }
      }

    } else {
      //the very convoluted way of unlocking all controllers of a single controlP5 instance...
      for(int i = 0; i < wm.widgets.size(); i++) {
        for(int j = 0; j < wm.widgets.get(i).cp5_widget.getAll().size(); j++) {
          wm.widgets.get(i).cp5_widget.getController(wm.widgets.get(i).cp5_widget.getAll().get(j).getAddress()).unlock();
        }
      }
    }
  }

  void addTutorialButtons(){

    //FIRST ROW

    //setup button 1 -- full screen
    int buttonNumber = 0;
    Button tempTutorialButton = new Button(x + margin, y + margin*(buttonNumber+1) + b_h*(buttonNumber), b_w, b_h, "Getting Started");
    tempTutorialButton.setFont(p5, 12);
    tempTutorialButton.setURL("http://docs.openbci.com/");
    tutorialOptions.add(tempTutorialButton);

    buttonNumber = 1;
    h = margin*(buttonNumber+2) + b_h*(buttonNumber+1);
    tempTutorialButton = new Button(x + margin, y + margin*(buttonNumber+1) + b_h*(buttonNumber), b_w, b_h, "Building Widgets");
    tempTutorialButton.setFont(p5, 12);
    tempTutorialButton.setURL("http://docs.openbci.com/software/01-OpenBCI_SDK");
    tutorialOptions.add(tempTutorialButton);

    buttonNumber = 2;
    h = margin*(buttonNumber+2) + b_h*(buttonNumber+1);
    tempTutorialButton = new Button(x + margin, y + margin*(buttonNumber+1) + b_h*(buttonNumber), b_w, b_h, "Testing Impedance");
    tempTutorialButton.setFont(p5, 12);
    tempTutorialButton.setURL("http://docs.openbci.com/hardware/01-OpenBCI_Hardware");
    tutorialOptions.add(tempTutorialButton);

  }

  void updateLayoutOptionButtons(){

  }

}