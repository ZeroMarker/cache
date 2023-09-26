// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var tbl=document.getElementById('tPACWard_BookedBedList_Summary')
function BodyLoadHandler()
{
 //alert("start");
 var numRows=tbl.rows.length;
 var admdep,selectfield

   for (i=1;i<numRows;i++)
  {
   admdept=document.getElementById("admtypez"+i);
   selectfield=document.getElementById("Selectz"+i);
   
  

   if ((admdept)&&(admdept.value=="E"))
   {
     
     if (selectfield) DisableField(selectfield);
   }
  
  }

}

document.body.onload=BodyLoadHandler;

function BookedBedListSum_ChangeStatusHandler(e) {
	//var tbl=getTableName(window.event.srcElement);
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
	if (aryfound.length==0) {alert(t['NOITEMSSELECTED']);return false;}
	var Ary=new Array()
	var BedAry=new Array();
	for (var i=0;i<aryfound.length;i++) {
		Ary[i]=f.elements["TransIDz"+aryfound[i]].value;
		BedAry[i]=f.elements["BedIDz"+aryfound[i]].value;
	}
	websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=PAAdmTransaction.ChangeStatus&TransIDs='+Ary.join("^")+"&BedIDs="+BedAry.join("^"),'Prompt','top=250,left=300,width=300,height=200');
}
function DisableField(fld) {
	var lbl = ('c'+fld);
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}