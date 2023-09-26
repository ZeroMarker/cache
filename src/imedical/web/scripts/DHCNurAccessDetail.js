var lstItems=document.getElementById("Item");
var transType;
var selectedValue = "newSheet"

var CONST_HOSPID=""; 

function getHospID(){	
    var HospitalRowId="";
	var objHospitalRowId=document.getElementById("HospitalRowId");
    if (objHospitalRowId) HospitalRowId=objHospitalRowId.value;
	return HospitalRowId;
}
function GetHospital1(str)
{
	var obj=document.getElementById('HospitalRowId');
	var tem=str.split("^");
	obj.value=tem[1];
	var obj=document.getElementById('HospitalName');
	obj.value=tem[0];
	CONST_HOSPID=getHospID();
	var ssgrp=document.getElementById("SSGRP").value;
	var setWayCode = document.getElementById("setWay").value;
	location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurAccessDetail&ssgrp="+ssgrp+"&setWay="+setWayCode+"&HospitalRowId="+tem[1]+"&HospitalName="+tem[0];
	//refreshList(selectedValue);	
	//listSet();
}
function BodyLoadHandler()
{
    /*transType = document.getElementById("sheetType");
    if(transType)
    {
		transType=dhtmlXComboFromSelect("sheetType","newSheet$c(2)住院$c(1)oldSheet$c(2)门诊");
		transType.selectHandle=function(){
			var selectedValue = transType.getActualValue();
			quertAllType(selectedValue);			
			refreshList(selectedValue);	
		}
		
		
    }*/
    var setWayCode = document.getElementById("setWay").value;
    if(setWayCode=="byLoc"){refreshList("");}
	var obj=document.getElementById('moveout');
	if (obj) obj.onclick =moveout_Click; 
	var obj=document.getElementById('movein');
	if (obj) obj.onclick =movein_Click;
    obj=document.getElementById('SaveSet');
	if (obj) obj.onclick =Save_Click;
    obj=document.getElementById('searchBtn');
	if (obj) obj.onclick =search_Click;
	var obj=document.getElementById('Up');
	if (obj) obj.onclick=UpClickHandler;
	var obj=document.getElementById('Down');
	if (obj) obj.onclick=DownClickHandler;
	CONST_HOSPID=getHospID();
	quertAllType(selectedValue);			
	refreshList(selectedValue);	


}
function quertAllType(type)
{
	var allTypeList = document.getElementById("ItemAll");
	allTypeList.options.length=0;
	var allTypeStr = tkMakeServerCall("web.DHCCLNURSET","getAllType",type,CONST_HOSPID);
	var optionArray = allTypeStr.split("^");
	for(var i=0;i<optionArray.length;i++)
	{
		option= optionArray[i].split("|");
		var optionObj = new Option(option[0], option[1]); 	
	    allTypeList.options[allTypeList.options.length]=optionObj;
	}	
}
function refreshList(type)
{
	
	var ssgrp=document.getElementById("SSGRP").value;
	var GetUserGroupAccess=document.getElementById("GetUserGroupAccess").value;
	if (ssgrp!="")
	{
		var setWayCode = document.getElementById("setWay").value;
		var ret=cspRunServerMethod(GetUserGroupAccess,ssgrp,"",type,setWayCode,"",CONST_HOSPID);
		var selobj=document.getElementById("Item");
		var excheck=document.getElementById("ExeYN");
		var tem=ret.split("!");
		addlistoption(selobj,tem[0],"^");
		if (tem[1]!="")
		{
		var tem1=tem[1].split("|");
		ifselected(tem1[0],selobj);
		}
		if (tem[2]==1)
		{
			excheck.checked="on";
		}
		
	}
}
function addlistoption(selobj,resStr,del)
{
    var resList=new Array();
    var tmpList=new Array();
    selobj.options.length=0;
    resList=resStr.split(del);
   // alert (selobj.length);
    for (i=0;i<resList.length;i++)
    {
	    tmpList=resList[i].split("|")
	    selobj.add(new Option(tmpList[1],tmpList[0]));
	}
}
function ifselected(val,list)
{
	for (var i=0;i<list.options.length;i++){
		if (list.options[i].value==val)
		{
			list.options[i].selected=true;
		}
		//alert(i);
	  
	}
	return false;
}	
function moveout_Click()
{
  var surlist=document.getElementById("Item");
  var dlist=document.getElementById("ItemAll");
  moveout1(surlist,dlist);
 // savevar(surlist);
}
function movein_Click()
{
  var surlist=document.getElementById("ItemAll");
  var dlist=document.getElementById("Item");
  movein(surlist,dlist);
 // savevar(dlist);
	
}
function Save_Click(dlist)
{
	
  var ssgrid = document.getElementById("SSGRP").value;
  var setWayCode = document.getElementById("setWay").value;
  //alert(ssgrid);
  if (parent.frames[0].document.getElementById("selrow")) {
  	var selrow = parent.frames[0].document.getElementById("selrow").value;
  	if (selrow == "") {
  		alert(t['alert:selrow']); //please select one line of search type first
  		return false;
  	}
	ssgrid=parent.frames[0].document.getElementById("SSGRPIDz"+selrow).innerText;
	setWayCode=parent.frames[0].document.getElementById("SetWayz"+selrow).value;
  }
   var seltyp;
  var dlist=document.getElementById("Item");
  //var tmpStr=selitem(dlist);
  var tmpStr=selitemNew(dlist);
  if (dlist.selectedIndex!=-1)
  {
	  var ind=dlist.selectedIndex;
	  //seltyp=dlist[ind].value+"|"+dlist[ind].text;
	  seltyp=dlist[ind].value;
  }
  else
  {
	   seltyp="";
  }
  var check=document.getElementById("ExeYN");  //能否撤销执行
  var exyn=check.checked;
  var SaveUserGroupAccess=document.getElementById("SaveUserGroupAccess").value;
  
  //transType.getActualValue()
  var type = transType?transType.getActualValue():"newSheet";
  if(setWayCode=="byLoc"){type=setWayCode}
  CONST_HOSPID=getHospID();
  var resStr=cspRunServerMethod(SaveUserGroupAccess,ssgrid,tmpStr,seltyp,exyn,type,CONST_HOSPID);
  
  alert(resStr);
  return;
}
function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		//alert(wobj.name);
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}
document.body.onload = BodyLoadHandler;
function movein(surlist,dlist)
{
    if (surlist.selectedIndex==-1){
	   return;
	}
	var i;
	var objSelected ;// new Option(surlist[nIndex].text, surlist[nIndex].value);
	for (i=0;i<surlist.options.length;i++)
	{
		if (surlist.options[i].selected)
		{
		    if (ifexist(surlist[i].value,dlist)==false)
		    {		    
		    	var objSelected = new Option(surlist[i].text, surlist[i].value);
	        	
	        	dlist.options[dlist.options.length]=objSelected;
	       		// surlist.options[i]=null;
	        	i=i-1;
		 	}
       	}
	}
	return;
	}
//检查目的listitem 是否有该值?
function ifexist(val,list)
{
	for (var i=0;i<list.options.length;i++){
		if (list.options[i].value==val)
		{
			return true;
		}
		//alert(i);
	  
	}
	return false;
}	
function moveout(surlist,dlist)
	{
   if (surlist.selectedIndex==-1){
	   return;
	   }
	var nIndex=surlist.selectedIndex;
	//alert (surlist.options[nIndex].text);
	var Index =dlist.options.length ;
	if (ifexist(surlist[nIndex].value,dlist)==false)
	{
	var objSelected = new Option(surlist[nIndex].text, surlist[nIndex].value);
	dlist.options[Index]=objSelected;
	}
	surlist.options[nIndex]=null;
	//form1.dismeth.options[2].selected=true;
	return;
	}
function moveout1(surlist,dlist)
{
    if (surlist.selectedIndex==-1){
	   return;
	   }
	var i;
	var objSelected ;// new Option(surlist[nIndex].text, surlist[nIndex].value);
	for (i=0;i<surlist.options.length;i++)
	{
		if (surlist.options[i].selected)
		{

		  //if (ifexist(surlist[i].value,dlist)==false)
		  //{
		    
		   // var objSelected = new Option(surlist[i].text, surlist[i].value);
	        //dlist.options[dlist.options.length]=objSelected;
	        surlist.options[i]=null;
	        i=i-1;
		 // }
       	}
	}
	return;
	}

function selitem(selbox)
{
      var tmpList=new Array();
        for ( var i=0;i<selbox.options.length;i++)
		{   
			//if (selbox.options[i].selected)
			//{   //alert(tmpList.length+" //"+tmpList)
			    tmpList[tmpList.length]=selbox.options[i].value+"|"+selbox.options[i].text
			//}
		}
		if (tmpList[0]=="") tmpList=tmpList.slice(1)
		var Str=tmpList.join("^");
  return Str
}
function selitemNew(selbox)
{
      var tmpList=new Array();
        for ( var i=0;i<selbox.options.length;i++)
		{   
			tmpList[tmpList.length]=selbox.options[i].value;
		}
		if (tmpList[0]=="") tmpList=tmpList.slice(1)
		var Str=tmpList.join("^");
  return Str
}
function Swap(a,b) {
	//Swap position and style of two options
	//We used to just remove then add - but this didn't work in NS6
	var opta=lstItems[a];
	var optb=lstItems[b];
	lstItems[a]= new Option(optb.text,optb.value);
	lstItems[a].style.color=optb.style.color;
	lstItems[a].style.backgroundColor=optb.style.backgroundColor;
	lstItems[b]= new Option(opta.text,opta.value);
	lstItems[b].style.color=opta.style.color;
	lstItems[b].style.backgroundColor=opta.style.backgroundColor;
	lstItems.selectedIndex=b;
}
function UpClickHandler() {
	var i=lstItems.selectedIndex;
	var len=lstItems.length;
	if ((len>1)&&(i>0)) {
		Swap(i,i-1)
	}
 	//savevar(lstItems);
	return false;
}
function DownClickHandler() {
	var i=lstItems.selectedIndex;
	var len=lstItems.length;
	if ((len>1)&&(i<(len-1))) {
		Swap(i,i+1)
	}
  	//savevar(lstItems)
	return false;
}

function search_Click()
{
	var HospitalName,HospitalRowId;
    var objHospitalRowId=document.getElementById("HospitalRowId");
    if (objHospitalRowId) HospitalRowId=objHospitalRowId.value;
    else HospitalRowId="";
    var objHospitalName=document.getElementById("HospitalName");
    if (objHospitalName) HospitalName=objHospitalName.value;
    else HospitalName="";
    if (HospitalName=="")
    {
	    HospitalRowId="";
	}
	var type = transType?transType.getActualValue():"";
	var allTypeList = document.getElementById("ItemAll");
	allTypeList.options.length=0;
	var allTypeStr = tkMakeServerCall("web.DHCCLNURSET","getAllType",type,HospitalRowId);
	var optionArray = allTypeStr.split("^");
	for(var i=0;i<optionArray.length;i++)
	{
		option= optionArray[i].split("|");
		var optionObj = new Option(option[0], option[1]); 	
	    allTypeList.options[allTypeList.options.length]=optionObj;
	}				
   
	//alert("HospitalName="+HospitalName+" "+"HospitalRowId="+HospitalRowId)
	/*var objGetSelHospTyp=document.getElementById("GetSelHospTyp").value;
	var res=cspRunServerMethod(objGetSelHospTyp,HospitalRowId)
	//alert(res);
	var selobj=document.getElementById("ItemAll")
	addlistoption(selobj,res,"^");*/
}
function GetHospital(str)
{
	var obj=document.getElementById('HospitalRowId');
	var tem=str.split("^");
	obj.value=tem[1];
	var obj=document.getElementById('HospitalName');
	obj.value=tem[0];
}
function addlistoption(selobj,resStr,del)
{
    var resList=new Array();
    var tmpList=new Array();
    selobj.options.length=0;
    resList=resStr.split(del);
   // alert (selobj.length);
    for (i=0;i<resList.length;i++)
    {
	    tmpList=resList[i].split("|")
	    selobj.add(new Option(tmpList[1],tmpList[0]));
	}
}