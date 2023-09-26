//DHCANOPStatisticsSch.JS
var tformName=document.getElementById("TFORM").value;
var getComponentIdByName=document.getElementById("GetComponentIdByName").value;
var componentId;
componentId=cspRunServerMethod(getComponentIdByName,tformName);  
function BodyLoadHandler()
{
    var obj=document.getElementById("btnSearch");
    if (obj) {obj.onclick=SchClick;}
    var obj=document.getElementById("WardDocSch");
    if (obj) {obj.onclick=WardDocSch_Click;}
   	var obj=document.getElementById("AnDocSch");
    if (obj) {obj.onclick=AnDocSch_Click;}
    var obj=document.getElementById("OpNurSch");
    if (obj) {obj.onclick=OpNurSch_Click;}
    var obj=document.getElementById("WardLocSch");
    if (obj) {obj.onclick=WardLocSch_Click;} 
    var obj=document.getElementById("AnLocSch");
    if (obj) {obj.onclick=AnLocSch_Click;}
    WardDocSch_Click(); 
}
function WardDocSch_Click()
{	
	var obj=document.getElementById("WardDocSch");
    if ((obj)&&(obj.checked==true)){
   		var obj=document.getElementById("AnDocSch");
    	if (obj) obj.checked=false;
    	var obj=document.getElementById("OpNurSch");
    	if (obj) obj.checked=false;
    	var obj=document.getElementById("WardLocSch");
    	if (obj) obj.checked=false;
   		var obj=document.getElementById("AnLocSch");
    	if (obj) obj.checked=false;
		ChangeDisabledById(componentId,"OpLoc",true);
		ChangeDisabledById(componentId,"WardLoc",false);
  		var obj=document.getElementById("OpLocId");
		if (obj) obj.value="";
  		var obj=document.getElementById("WardLocId");
		if (obj) obj.value="";
    	var obj=document.getElementById("WardDocId");
  		if (obj) obj.value="";
  		var obj=document.getElementById("cOpLoc");
		if (obj) obj.innerText=t['val:oploc'];
    	var obj=document.getElementById("cWardDoc");
		if (obj) obj.innerText=t['val:warddoc'];
		ChangeVisibilityById(componentId,"WardDoc","visible");
		var obj=document.getElementById("locType");
		if (obj) obj.value="Null";
    	parent.frames['anopbottom'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPStatisticsWardDoc"; 
    }	
}
function AnDocSch_Click()
{	
	var obj=document.getElementById("AnDocSch");
    if ((obj)&&(obj.checked==true)){
   		var obj=document.getElementById("WardDocSch");
    	if (obj) obj.checked=false;
    	var obj=document.getElementById("OpNurSch");
    	if (obj) obj.checked=false;
    	var obj=document.getElementById("WardLocSch");
    	if (obj) obj.checked=false;
    	var obj=document.getElementById("AnLocSch");
    	if (obj) obj.checked=false;
		ChangeDisabledById(componentId,"OpLoc",false);
		ChangeDisabledById(componentId,"WardLoc",true);
  		var obj=document.getElementById("OpLocId");
		if (obj) obj.value="";
  		var obj=document.getElementById("WardLocId");
		if (obj) obj.value="";
    	var obj=document.getElementById("WardDocId");
  		if (obj) obj.value="";
    	var obj=document.getElementById("cOpLoc");
		if (obj) obj.innerText=t['val:anloc'];
    	var obj=document.getElementById("cWardDoc");
		if (obj) obj.innerText=t['val:andoc'];
		ChangeVisibilityById(componentId,"WardDoc","visible");
		var obj=document.getElementById("locType");
		if (obj) obj.value="AN";
    	parent.frames['anopbottom'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPStatisticsAnDoc"; 
    }	
}
function OpNurSch_Click()
{	
	var obj=document.getElementById("OpNurSch");
    if ((obj)&&(obj.checked==true)){
   		var obj=document.getElementById("WardDocSch");
    	if (obj) obj.checked=false;
    	var obj=document.getElementById("AnDocSch");
    	if (obj) obj.checked=false;
    	var obj=document.getElementById("WardLocSch");
    	if (obj) obj.checked=false;
    	var obj=document.getElementById("AnLocSch");
    	if (obj) obj.checked=false;
    	ChangeDisabledById(componentId,"OpLoc",false);
		ChangeDisabledById(componentId,"WardLoc",true);
		var obj=document.getElementById("OpLocId");
		if (obj) obj.value="";
  		var obj=document.getElementById("WardLocId");
		if (obj) obj.value="";
    	var obj=document.getElementById("WardDocId");
  		if (obj) obj.value="";
    	var obj=document.getElementById("cOpLoc");
		if (obj) obj.innerText=t['val:oploc'];
    	var obj=document.getElementById("cWardDoc");
		if (obj) obj.innerText=t['val:opnur'];
		ChangeVisibilityById(componentId,"WardDoc","visible");
		var obj=document.getElementById("locType");
		if (obj) obj.value="OP";
    	parent.frames['anopbottom'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPStatisticsOpNur"; 
    }	
}
function WardLocSch_Click()
{	
	var obj=document.getElementById("WardLocSch");
    if ((obj)&&(obj.checked==true)){
   		var obj=document.getElementById("WardDocSch");
    	if (obj) obj.checked=false;
    	var obj=document.getElementById("AnDocSch");
    	if (obj) obj.checked=false;
    	var obj=document.getElementById("OpNurSch");
    	if (obj) obj.checked=false;
    	var obj=document.getElementById("AnLocSch");
    	if (obj) obj.checked=false;
    	ChangeDisabledById(componentId,"OpLoc",false);
		ChangeDisabledById(componentId,"WardLoc",false);
		var obj=document.getElementById("OpLocId");
		if (obj) obj.value="";
  		var obj=document.getElementById("WardLocId");
		if (obj) obj.value="";
    	var obj=document.getElementById("WardDocId");
  		if (obj) obj.value="";
		var obj=document.getElementById("cOpLoc");
		if (obj) obj.innerText=t['val:oploc'];
    	var obj=document.getElementById("cWardLoc");
		if (obj) obj.innerText=t['val:wardloc'];
		ChangeVisibilityById(componentId,"WardDoc","hidden");
		var obj=document.getElementById("locType");
		if (obj) obj.value="AN^OP";
		parent.frames['anopbottom'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPStatisticsWardLoc"; 
    }	
}

function SchClick()
{
	var StartDate=document.getElementById("StartDate").value;
	var EndDate=document.getElementById("EndDate").value;
	var objOpLoc=document.getElementById("OpLoc");
	var OpLocId=document.getElementById("OpLocId").value;
	if ((objOpLoc)&&(objOpLoc.value=="")) OpLocId="";
	var objWardLoc=document.getElementById("WardLoc");
	var WardLocId=document.getElementById("WardLocId").value;
	if ((objWardLoc)&&(objWardLoc.value=="")) WardLocId="";
	var objWardDoc=document.getElementById("WardDoc");
	var WardDocId=document.getElementById("WardDocId").value;
	if ((objWardDoc)&&(objWardDoc.value=="")) WardDocId="";		
	//alert(StartDate+" "+EndDate+" "+" "+OpLocId+" "+WardLocId+" "+WardDocId)
	var objWardDocSch=document.getElementById("WardDocSch");
	if ((objWardDocSch)&&(objWardDocSch.checked==true)){	
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPStatisticsWardDoc&StartDate="+StartDate+"&EndDate="+EndDate+"&WardLoc="+WardLocId+"&WardDoc="+WardDocId;
		parent.frames['anopbottom'].location.href=lnk; 	
	}
	var objAnDocSch=document.getElementById("AnDocSch");
	if ((objAnDocSch)&&(objAnDocSch.checked==true)){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPStatisticsAnDoc&StartDate="+StartDate+"&EndDate="+EndDate+"&AnLocId="+OpLocId+"&AnDocId="+WardDocId;
		parent.frames['anopbottom'].location.href=lnk; 	
	}
	var objOpNurSch=document.getElementById("OpNurSch");
	if ((objOpNurSch)&&(objOpNurSch.checked==true)){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPStatisticsOpNur&StartDate="+StartDate+"&EndDate="+EndDate+"&OpLocId="+OpLocId+"&OpNurId="+WardDocId;
		parent.frames['anopbottom'].location.href=lnk; 	
	}
	var objWardLocSch=document.getElementById("WardLocSch");
	if ((objWardLocSch)&&(objWardLocSch.checked==true)){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPStatisticsWardLoc&StartDate="+StartDate+"&EndDate="+EndDate+"&WardLocId="+WardLocId+"&OpLocId="+OpLocId;
		parent.frames['anopbottom'].location.href=lnk; 
	}
	var objAnDocSch=document.getElementById("AnLocSch");
	if ((objAnDocSch)&&(objAnDocSch.checked==true)){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPStatisticsAnLoc&StartDate="+StartDate+"&EndDate="+EndDate+"&AnLocId="+OpLocId+"&AnDocId="+WardDocId;
		parent.frames['anopbottom'].location.href=lnk; 	
	}
}
function getWardLoc(str)
{
	var tmpStr=str.split("^");
	var obj=document.getElementById("WardLoc");
	if (obj) obj.value=tmpStr[1];
	var obj=document.getElementById("WardLocId");
	if (obj) obj.value=tmpStr[0];
}
function getWardDoc(str)
{
	var tmpStr=str.split("^");
	var obj=document.getElementById("WardDoc");
	if (obj) obj.value=tmpStr[0];
	var obj=document.getElementById("WardDocId");
	if (obj) obj.value=tmpStr[1];
}
function getAnLoc(str)
{
	var tmpStr=str.split("^");
	var obj=document.getElementById("AnLoc");
	if (obj) obj.value=tmpStr[1];
	var obj=document.getElementById("AnLocId");
	if (obj) obj.value=tmpStr[0];
	var obj=document.getElementById("OpLocId");
	if (obj) obj.value=tmpStr[0];
}
function getAnDoc(str)
{
	var tmpStr=str.split("^");
	var obj=document.getElementById("AnDoc");
	if (obj) obj.value=tmpStr[0];
	var obj=document.getElementById("AnDocId");
	if (obj) obj.value=tmpStr[1];
}
function getOpLoc(str)
{
	var tmpStr=str.split("^");
	var obj=document.getElementById("OpLoc");
	if (obj) obj.value=tmpStr[1];
	var obj=document.getElementById("OpLocId");
	if (obj) obj.value=tmpStr[0];
}
function getOpNur(str)
{
	var tmpStr=str.split("^");
	var obj=document.getElementById("OpNur");
	if (obj) obj.value=tmpStr[0];
	var obj=document.getElementById("OpNurId");
	if (obj) obj.value=tmpStr[1];
}

function ChangeVisibilityById(componentId,id,visibilityStyle)
{
	//'visible','hidden'
	var obj=document.getElementById(id);
	if (obj) {
		obj.value="";
		obj.style.visibility=visibilityStyle;
	}
	var obj=document.getElementById("c"+id);
	if (obj) obj.style.visibility=visibilityStyle;
	if (componentId>0)
	{
		obj=document.getElementById("ld"+componentId+"i"+id);
		if (obj) obj.style.visibility=visibilityStyle;
	}	
}
function ChangeDisabledById(componentId,id,disabledStyle)
{
	//'true','false'
	var obj=document.getElementById(id);
	if (obj){
		obj.value="";		
		if (disabledStyle==false) obj.className="";
		if (disabledStyle==true) obj.className="disabledField";
		obj.disabled=disabledStyle;
	}
	if (componentId>0)
	{
		obj=document.getElementById("ld"+componentId+"i"+id);
		if (obj) obj.disabled=disabledStyle;
	}	
}
function AnLocSch_Click()
{	
	var obj=document.getElementById("AnLocSch");
    if ((obj)&&(obj.checked==true)){
   		var obj=document.getElementById("WardDocSch");
    	if (obj) obj.checked=false;
    	var obj=document.getElementById("AnDocSch");
    	if (obj) obj.checked=false;
    	var obj=document.getElementById("OpNurSch");
    	if (obj) obj.checked=false;
    	var obj=document.getElementById("WardLocSch");
    	if (obj) obj.checked=false;
		ChangeDisabledById(componentId,"OpLoc",false);
		ChangeDisabledById(componentId,"WardLoc",true);
  		var obj=document.getElementById("OpLocId");
		if (obj) obj.value="";
  		var obj=document.getElementById("WardLocId");
		if (obj) obj.value="";
    	var obj=document.getElementById("WardDocId");
  		if (obj) obj.value="";
    	var obj=document.getElementById("cOpLoc");
		if (obj) obj.innerText=t['val:anloc'];
    	var obj=document.getElementById("cWardDoc");
		if (obj) obj.innerText=t['val:andoc'];
		ChangeVisibilityById(componentId,"WardDoc","hidden");
		var obj=document.getElementById("locType");
		if (obj) obj.value="AN";
    	parent.frames['anopbottom'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPStatisticsAnLoc"; 
    }	
}

document.body.onload = BodyLoadHandler;
