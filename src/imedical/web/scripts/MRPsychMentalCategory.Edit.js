// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 28.01.05


// update to reload in the parent frame
if ((parent)&&(parent.frames)&&(parent.frames["MRPsychMentalCategory_List"])) {
    var frame=document.getElementById("TFRAME");
    if (frame) frame.value=window.parent.name;
}

//function DocumentLoadHandler() {

//}


//document.body.onload=DocumentLoadHandler;