// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 14.05.02 - disable inactive position textboxes 24474

var tbl=document.getElementById("tPACBed_List");

function BodyLoadHandler()
{
 
 var numRows=tbl.rows.length;
 var currentRow,currLeft,currTop,currWidth,currHeight,currActive,currUnavail;

   for (i=1;i<numRows;i++)
  {
   currLeft=document.getElementById("PositionLeftz"+i);
   currTop=document.getElementById("PositionTopz"+i);
   currWidth=document.getElementById("PositionWidthz"+i);
   currHeight=document.getElementById("PositionHeightz"+i);
   currActive=document.getElementById("ActiveFlagz"+i);
   currUnavail=document.getElementById("UnavailReasonz"+i);
  

   if ((currActive)&&(currUnavail)&&(currActive.innerText=="N")&&(currUnavail.value==""))
   {
     
     if (currLeft) DisableField(currLeft);
     if (currTop) DisableField(currTop);
     if (currWidth) DisableField(currWidth);
     if (currHeight) DisableField(currHeight);
   }
  
  }

}

document.body.onload=BodyLoadHandler;

function DisableField(fld) {
	var lbl = ('c'+fld);
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}
