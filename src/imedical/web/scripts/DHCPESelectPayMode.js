 //DHCPESelectPayMode.js
 // create by zhouli
 document.body.onload=BodyLoadHandler;
document.body.onunload=BodyUnLoadHandler;
 
 var selectrow="";
 var CurrentSel=0
function BodyLoadHandler()
{	
	var obj
	
	obj=document.getElementById("BFind");
	if (obj) {obj.onclick=BFind_Click;}
	
 
   InitListInfo();
}

function InitListInfo()
{  
    var i,objtbl,obj
	var objtbl=document.getElementById('tDHCPESelectPayMode');
	if (!objtbl) return;
	var rows=objtbl.rows.length; 
	for (i=1;i<=rows;i++)
	{ 
	  var obj=document.getElementById('TPayModeIDz'+i);
	  if (obj){var PayModeID=obj.value}
	  var obj=document.getElementById("InfoBox");
      var encmeth=obj.value
      if (encmeth!=""){
      var rtn=cspRunServerMethod(encmeth,PayModeID)
      var Flag=rtn.split("^")[0]
      var CardFlag=rtn.split("^")[1]
      var RefundFlag=rtn.split("^")[2]
      if (Flag=="Y"){
	  var obj=document.getElementById('TActionz'+i);
	  if(obj){obj.checked=true;}
	  }
	  if (CardFlag=="Y"){
	  var obj=document.getElementById('TCardActionz'+i);
	  if(obj){obj.checked=true;}
	  }
	  if (RefundFlag=="Y"){
	  var obj=document.getElementById('TRefundActionz'+i);
	  if(obj){obj.checked=true;}
	  } 

	}	
	
	}

}
	
function SelectRowHandler() {
   
    var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPESelectPayMode');	
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;	    
	CurrentSel=selectrow;
	ShowCurRecord(CurrentSel);


}

function ShowCurRecord(CurrentSel)
{
	var flag="",Cardflag="",Refundflag="",String=""
	var obj=document.getElementById('TPayModeID'+'z'+CurrentSel);
	if (obj) {var PayModeID=obj.value; }
	var obj=document.getElementById('TAction'+'z'+CurrentSel);
    if(obj.checked==true){ var flag="Y" }
    else {var flag="N" }
    var obj=document.getElementById('TCardAction'+'z'+CurrentSel);
    if(obj.checked==true){ var Cardflag="Y" }
    else {var Cardflag="N" }
    var obj=document.getElementById('TRefundAction'+'z'+CurrentSel);
    if(obj.checked==true){ var Refundflag="Y" }
    else {var Refundflag="N" }

    var String=flag+"^"+Cardflag+"^"+Refundflag
    var obj=document.getElementById("Save");
    var encmeth=obj.value
    if (encmeth!=""){
    var rtn=cspRunServerMethod(encmeth,PayModeID,String)
    //window.location.reload(); 
    var Ins=window.opener.document.getElementById("GetPayModeData")	
    if (Ins) {var encmeth=Ins.value} 
	else {var encmeth=""} 
    var Str=cspRunServerMethod(encmeth)
	var obj=window.opener.document.getElementById("AllowPayMode");
	if (obj){obj.value=Str;}
  
	} 
	    
	

}
function BodyUnLoadHandler()
{
	
	//window.opener.location.reload();
}

