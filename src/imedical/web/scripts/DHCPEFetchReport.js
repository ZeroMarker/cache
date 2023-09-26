
var myCombAry=new Array();
document.write("<object ID='ClsIDCode' WIDTH=0 HEIGHT=0 CLASSID='CLSID:299F3F4E-EEAA-4E8C-937A-C709111AECDC' CODEBASE='../addins/client/ReadPersonInfo.CAB#version=1,0,0,8' VIEWASTEXT>");
document.write("</object>");


document.body.onload = BodyLoadHandler;
function BodyLoadHandler(){
	var obj;   
	obj=document.getElementById("DoRegNo");
	if (obj){ obj.onkeydown=DoRegNo_keydown; }
	
	obj=document.getElementById("HPNo");
	if (obj){ obj.onkeydown=HPNo_keydown; }
	
	obj=document.getElementById("GroupName");
	if (obj){ obj.onchange=GroupName_change; }
	
	//读身份证
	var obj=document.getElementById("ReadRegInfo");
    if (obj){obj.onclick=ReadRegInfo_OnClick;}
	
	websys_setfocus("DoRegNo"); 
}

function ReadRegInfo_OnClick()
  {
	
   	var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
	var rtn=tkMakeServerCall("DHCDoc.Interface.Inside.Service","GetIECreat")
	var myHCTypeDR=rtn.split("^")[0];
	var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);
    var myary=myInfo.split("^");
 
     if (myary[0]=="0")
     { 
   
      SetPatInfoByXML(myary[1]); 
	  var myNameobj=document.getElementById("Name");
	  var myPatNameobj=document.getElementById('Name');
	  if ((myNameobj)&&(myPatNameobj)){
			myPatNameobj.value=myNameobj.value; 
			//alert(myPatNameobj.value)
			
		} 
	  var mycredobj=document.getElementById("CredNo");
	 /*
	  var myidobj=document.getElementById('IDCard');
	  
		if ((mycredobj)&&(myidobj)){
			myidobj.value=mycredobj.value;
			
		} 
		*/
		
     }
   
     
	 var RegNo=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetRegNoByIDCard",mycredobj.value);
	 if (RegNo==""){
		return false;
	}
	var obj=document.getElementById("DoRegNo");
	if (obj){
		obj.value=RegNo;
		
	}
     
  }

function SetPatInfoByXML(XMLStr)
{
	
	XMLStr ="<?xml version='1.0' encoding='gb2312'?>"+XMLStr
	
	var xmlDoc=DHCDOM_CreateXMLDOM();
	
	xmlDoc.async = false;
	xmlDoc.loadXML(XMLStr);
	if(xmlDoc.parseError.errorCode != 0) 
	{ 
		alert(xmlDoc.parseError.reason); 
		return; 
	}
    
	var nodes = xmlDoc.documentElement.childNodes;
	
	for(var i=0; i<nodes.length; i++) 
	{
		
		var myItemName=nodes(i).nodeName;
		
		var myItemValue= nodes(i).text;
		if (myCombAry[myItemName]){
			//alert(nodes(i).text)
			myCombAry[myItemName].setComboValue(myItemValue);
            
		}else{

			DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
		}
	}
	
	delete(xmlDoc);
}

function CancelFetch(e)
{
	var ID="";encmeth="",obj;
	ID=e.id;
	obj=document.getElementById("CancelFetchClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ID);
	var Arr=ret.split("^")
	if (Arr[0]==0){
		BFind_click();
	}else{
		alert(Arr[1])
	}
}
function GroupName_change()
{
	var obj=document.getElementById("GroupID");
	if (obj) obj.value="";
}
function SelectGroup(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("GroupID");
	if (obj) obj.value=Arr[1];
	var obj=document.getElementById("GroupName");
	if (obj) obj.value=Arr[0];
}
function HPNo_keydown(e)
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		var obj=document.getElementById("HPNo");
		var encmeth="",HPNo="";
		if (obj) HPNo=obj.value;
		if (HPNo=="") return false;
		var obj=document.getElementById("FetchReportByHPNoClass");
		if (obj) encmeth=obj.value;
		var ret=cspRunServerMethod(encmeth,HPNo);
		var Arr=ret.split("^");
		if (Arr[0]!=0){
			alert(Arr[1]);
			return false;
		}
		//window.location.reload();
		BFind_click();
	}
}
function DoRegNo_keydown(e)
{
	var Key=websys_getKey(e);
	var encmeth="",RegNo="";
	if ((9==Key)||(13==Key)) {
		var obj=document.getElementById("DoRegNo");
		if (obj) { 
			RegNo=obj.value;
			if (RegNo.length<8&&RegNo.length>0) { RegNo=RegNoMask(RegNo);}
	     }
	     
	   if (RegNo=="") 
	   {
		   alert("请输入登记号")
		   return false;
	   }
		
		var obj=document.getElementById("FetchReportClass");
		if (obj) encmeth=obj.value;
		var ret=cspRunServerMethod(encmeth,RegNo);
		var Arr=ret.split("^");
	
		if (Arr[0]!=0){
			alert(Arr[1]);
			return false;
		}
		//window.location.reload();
		BFind_click();
	}
}