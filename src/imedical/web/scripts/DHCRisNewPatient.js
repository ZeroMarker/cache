//DHCRisNewPatient.js
var gLocID,gGetLocID;
var allowbill="";
var Lookupstr="";
var gIndex=1;
var gPaadm="";
var gOrdItemStrInfo="",gOrdName="";
var gHztoPyobj1,gHL7Obj1;
var gPrintTemplate;
var gPaadmRowid ;

var combo_WardList;
var combo_bedList;
var combo_eqList;
var combo_orditemList;
var combo_OccuptionListstr;
var combo_maindoc;
var combo_assiantdoc;
var combo_transUnit;


var m_CardNoLength=0;
var m_SelectCardTypeDR="";



document.body.onload = BodyLoadHandler;


function BodyLoadHandler()
{	
 
   	GetLocDR();
 	
  	var BirthDayObj=document.getElementById("BirthDay");
	if (BirthDayObj.value=="")
	{
		BirthDayObj.value=DateDemo();
	}
	var NewPatObj=document.getElementById("AddNewPatient");
	if (NewPatObj)
	{
		NewPatObj.onclick=NewPatObj_click;
	}
	var DelItemObj=document.getElementById("DeleteItem");
	if (DelItemObj)
	{
		DelItemObj.onclick=DelSelItem_Click;
	}
	
	var NamePYObj=document.getElementById("NamePY");
	if (NamePYObj)
	{
		NamePYObj.onkeydown=NamePYObj_Click;
	}

	var OrdQtyObj=document.getElementById("OrdQty");
	if(OrdQtyObj)
	{
		OrdQtyObj.value="1"
	}
	
	var QPatBtnObj=document.getElementById("QPatInfo");
	if(QPatBtnObj)
	{
		QPatBtnObj.onclick=QPatBtnObj_Click;
	}
	
	var PatRegNoObj=document.getElementById("PatRegNo");
	if(PatRegNoObj)
	{
		PatRegNoObj.onkeydown=RegNo_keyDown;
		//PatRegNoObj.onblur=RegNo_LostFoucs;
	}
	
	var SelectItemObj=document.getElementById("SelectItem");
	if(SelectItemObj)
	{
		SelectItemObj.onkeydown=SelectItem_keyDown;
		//PatRegNoObj.onblur=RegNo_LostFoucs;
	}
	
	var PatNameObj=document.getElementById("Name");
	if (PatNameObj)
	{
		PatNameObj.onkeyup=Name_keyUp;
		PatNameObj.onkeydown=Name_keyDown;
		
	}
	
	var ClearObj=document.getElementById("Clear");
	if (ClearObj)
	{
		ClearObj.onclick=onClear;
		
	}
	var AgeObj=document.getElementById("strAge");
	if (AgeObj)
	{
		AgeObj.onkeydown=AgeKeyDown;
		AgeObj.onblur=Age_LostFocus;
	}
   	
   	
   	var UpdatePatientInfoObj=document.getElementById("UpdatePatientInfo");
	if (UpdatePatientInfoObj)
	{
		UpdatePatientInfoObj.onclick=UpdatePatientInfo_Click1;
	}
	
	ConnectHL7Server();
	
	IniHZtoPYObj();

	
	GetLocRegTemplate();
	//
	//*/
	GetIndex();
	
	var GroupIDOBJ=document.getElementById("GroupID");
    GroupIDOBJ.value=session["LOGON.GROUPID"];
    
    
    var PrintRegBarObj=document.getElementById("PrintRegBar");
	if (PrintRegBarObj)
	{
		PrintRegBarObj.onclick=PrintRegBarObj_click;
	}
	//add ---------------

    AgeUnitObj=document.getElementById("AgeUNIT");
    if (AgeUnitObj)
    {
	    AgeUnitObj.onchange=OnchangeUnit;

    	combo("AgeUNIT");
		var GetAgeUnitFunction=document.getElementById("GetAgeUnit").value;
		var Info=cspRunServerMethod(GetAgeUnitFunction);
    	AddItem("AgeUNIT",Info);
    	//AgeUnitObj.onkeydown=onUnitKeydown;
    }

    
    SexObj=document.getElementById("Sex");
    if (SexObj)
    {
	    SexObj.onchange=onSexchange;
    	SexObj.onkeydown =onSexkeydown;

 		combo("Sex");
		var GetSexstrFunction=document.getElementById("GetSexstr").value;
		Info1=cspRunServerMethod(GetSexstrFunction);
    	AddItem("Sex",Info1);
    }
    
    var PatTypeObj=document.getElementById("PatType");
	if (PatTypeObj)
	{
    	 PatTypeObj.onchange=ClickPatientType;
		 PatTypeObj.onkeydown=onPatientTypeDown;

    	combo("PatType");
		var GetPatTypeObj=document.getElementById("GetPatType");
		if (GetPatTypeObj)
		{
			var Info=cspRunServerMethod(GetPatTypeObj.value);
			//alert(Info);
    		AddItem("PatType",Info);
    	}

	 }

    
   
   
	var GetWardListstr=DHCC_GetElementData('GetWardListstr');
	var  WardNameObj=document.getElementById("WardName");
	if(WardNameObj)
	{
		combo_WardList=dhtmlXComboFromStr("WardName",GetWardListstr);
		combo_WardList.enableFilteringMode(true);
		combo_WardList.selectHandle=combo_WardListKeydownhandler;
		combo_WardList.keyenterHandle=combo_WardListKeyenterhandler;
		combo_WardList.attachEvent("onKeyPressed",combo_WardListKeyenterhandler)
		//WardNameObj.disabled=true;
  	}
  	
	

  
	var  BedNoObj=document.getElementById("BedNo");
	if(BedNoObj)
	{
		BedNoObj.onkeydown=OnBedkeydown;
		//BedNoObj.disabled=true;
  	}
  	
  	var GetOccuptionListstr=DHCC_GetElementData('GetOccuptionListstr');
	var  VocationObj=document.getElementById("Vocation");
	if(VocationObj)
	{
		combo_OccuptionListstr=dhtmlXComboFromStr("Vocation",GetOccuptionListstr);
		combo_OccuptionListstr.enableFilteringMode(true);
		//combo_SexList.selectHandle=combo_SexListKeydownhandler;
		//combo_DeptList.keyenterHandle=combo_DeptListKeyenterhandler;
		//combo_SexList.attachEvent("onKeyPressed",combo_SexListKeyenterhandler)
  	}
  	
  	
  	var GetTransUnitList=DHCC_GetElementData('GetTransUnitList');
	var  TransUnitObj=document.getElementById("TransUnit");
	if(TransUnitObj)
	{
		combo_transUnit=dhtmlXComboFromStr("TransUnit",GetTransUnitList);
		combo_transUnit.enableFilteringMode(true);
  	}
  	var TransPatientObj=document.getElementById("TransPatient");
   	if (TransPatientObj)
   	{
	   	TransPatientObj.onclick=onTransPatientClick;
	   	
   	}
	
	//var TransUnitObj=document.getElementById("TransUnit");
	var FeelaterObj=document.getElementById("Feelater");
	if (FeelaterObj)
	{
		FeelaterObj.onclick=onFeelaterClick;
	}
	//TransPatientObj.disabled=true;
	//TransUnitObj.disabled=true;
	//FeelaterObj.disabled=true;

 	
  	var GetEQListStr=DHCC_GetElementData('GetEQListStr');
	var  DeviceOBJ=document.getElementById("Device");
	if(DeviceOBJ)
	{
		combo_eqList=dhtmlXComboFromStr("Device",GetEQListStr);
		combo_eqList.enableFilteringMode(true);
		combo_eqList.selectHandle=combo_eqListKeydownhandler;
		combo_eqList.keyenterHandle=combo_eqListKeyenterhandler;
		combo_eqList.attachEvent("onKeyPressed",combo_eqListKeyenterhandler)
  	}

 	var GetDocListstr=DHCC_GetElementData('GetDocListstr');
	var MainDocObj=document.getElementById("MainDoc");
	if(MainDocObj)
	{
		combo_maindoc=dhtmlXComboFromStr("MainDoc",GetDocListstr);
		combo_maindoc.enableFilteringMode(true);
		
		////////////
		combo_maindoc.selectHandle=combo_maindocKeydownhandler;
		combo_maindoc.keyenterHandle=combo_maindocKeyenterhandler;
		combo_maindoc.attachEvent("onKeyPressed",combo_maindocKeyenterhandler)

  	}
  	
  	 	
  	var GetDocListstr=DHCC_GetElementData('GetDocListstr');
	var OptionDocObj=document.getElementById("OptionDoc");
	if(OptionDocObj)
	{
		combo_assiantdoc=dhtmlXComboFromStr("OptionDoc",GetDocListstr);
		combo_assiantdoc.enableFilteringMode(true);
		
		////////////
		combo_assiantdoc.selectHandle=combo_assiantdocKeydownhandler;
		combo_assiantdoc.keyenterHandle=combo_assiantdocKeyenterhandler;
		combo_assiantdoc.attachEvent("onKeyPressed",combo_assiantdocKeyenterhandler)
		
		
  	}	
  
   	var ExecutedateObj=document.getElementById("Executedate");
	if (ExecutedateObj.value=="")
	{
		ExecutedateObj.value=DateDemo();
	}
	var tommorrowObj=document.getElementById("ckTomorrow");
	if (tommorrowObj)
	{
		tommorrowObj.onclick=ClickTommorrow;
	}
	var AtommorrowObj=document.getElementById("ckAtommorrow");
	if (AtommorrowObj)
	{
		AtommorrowObj.onclick=ClickAferTommorrow;
	}
	//ckToday
	var ckTodayObj=document.getElementById("ckToday");
	if (ckTodayObj)
	{
		ckTodayObj.onclick=ClickckToday;
		ckTodayObj.checked=true;
	}
	
	var UnRegisterObj=document.getElementById("UnRegister");
	if (UnRegisterObj)
	{
		UnRegisterObj.onclick=ClickUnRegisterObj;
	}
	
		
	var IDCAliasOBJ=document.getElementById("IDCAlias");
	if (IDCAliasOBJ)
	{
		IDCAliasOBJ.onkeydown=IDCAliasOBJ_keyDown;
		
	}
	
	var ICDLISTOBJ=document.getElementById("ICDLIST");
	if (ICDLISTOBJ)
	{
		ICDLISTOBJ.ondblclick=ICDLISTOBJ_ondblclick ;
		
	}
	//ICDExterDesc
	//
	var ICDDescOBJ=document.getElementById("ICDDesc");
	if (ICDDescOBJ)
	{
		ICDDescOBJ.ondblclick=ICDDescOBJ_ondblclick ;
		
	}
	
	
	
	var addICDOBJ=document.getElementById("addICD");
	if (addICDOBJ)
	{
		addICDOBJ.onclick=addICDOBJ_onclick ;
		
	}
	var RemoveICDOBJ=document.getElementById("RemoveICD");
	if (RemoveICDOBJ)
	{
		RemoveICDOBJ.onclick=RemoveICDOBJ_onclick ;
		
	}
	
	var GetSystemParam=document.getElementById("GetSystemParam").value;
	var GetSystemParamInfo=cspRunServerMethod(GetSystemParam);
	if (GetSystemParamInfo!="")
	{
		var Item=GetSystemParamInfo.split("^");
		var DHCVersion=Item[14];   
		if (DHCVersion=="SC_HX1")
		{
		 	loadCardType();	
		 	var myobj=document.getElementById('CardTypeDefine');
			if (myobj)
			{
				myobj.onchange=CardTypeDefine_OnChange;
				myobj.size=1;
				myobj.multiple=false;
			}
		}
		
	} 
	var readcardObj=document.getElementById("ReadCard");
    if (readcardObj)
    {
	    readcardObj.onclick=FunReadCard;
	}
	
	
	/////////////////
	var ModiPinOBJ=document.getElementById("ModiPin");
    if (ModiPinOBJ)
    {
	    ModiPinOBJ.onclick=FunModiPin;
	}

}
function ClickUnRegisterObj()
{
	var StudyNo=document.getElementById("StudyNo").value;
	var userid=session['LOGON.USERID'];
	if (StudyNo!="")
	{
		var UnRegisterFuction=document.getElementById("UnRegisterFuction").value;
		var ret=cspRunServerMethod(UnRegisterFuction,StudyNo,userid);
		if (ret!=0)
		{
			alert(t['UnRegiserFailure']+ret);
		}
		else
		{
			alert(t['UnRegiserSuccess']);
		}
	}
	else
	{
		alert(t['InputStudyNo']);
	}
	
	
}
function OnBedkeydown()
{
	if (window.event.keyCode==13)
	{
		window.event.keyCode=117;
		BedNo_lookuphandler();
	}
}
function ClickckToday()
{
	var ckTodayObj=document.getElementById("ckToday");
	if (ckTodayObj)
	{
		if (ckTodayObj.checked)
		{
		
			var ckTomorrowObj=document.getElementById("ckTomorrow");
   		   	ckTomorrowObj.checked=false;
	   	   	var ckAtommorrowObj=document.getElementById("ckAtommorrow");
           	ckAtommorrowObj.checked=false;
	         	
         	var ExecutedateObj=document.getElementById("Executedate");
			ExecutedateObj.value=DateDemo();
       	}
   	}
	
}
function ClickTommorrow()
{
	var ckTomorrowObj=document.getElementById("ckTomorrow");
   	if (ckTomorrowObj)
   	{
	   	if (ckTomorrowObj.checked)
	   	{
		   	var ckAtommorrowObj=document.getElementById("ckAtommorrow");
         	if (ckAtommorrowObj)
         	{
	         	ckAtommorrowObj.checked=false;
	         	
         	}
            var ckTodayObj=document.getElementById("ckToday");
			ckTodayObj.checked=false;

	   	
         	var ExecutedateObj=document.getElementById("Executedate");
			ExecutedateObj.value=getRelaDate(1);
       	}
   	}
}
function ClickAferTommorrow()
{
	var ckAtommorrowObj=document.getElementById("ckAtommorrow");
    if (ckAtommorrowObj)
    {
	    if (ckAtommorrowObj.checked)
	    {
		    	var ckTomorrowObj=document.getElementById("ckTomorrow");
     	   		ckTomorrowObj.checked=false;
     	   		var ckTodayObj=document.getElementById("ckToday");
				ckTodayObj.checked=false;

		        var ExecutedateObj=document.getElementById("Executedate");
				ExecutedateObj.value=getRelaDate(2);

	    }
	         	
    }

}

function combo_BedListKeydownhandler()
{

}
function onSexchange()
{
	websys_setfocus("strAge");	
}
function onSexkeydown()
{
	if (window.event.keyCode==13)
	{
	websys_setfocus("strAge");
	}
}
function onUnitKeydown()
{
}

function ClickPatientType()
{
	var obj=document.getElementById('PatType');
	
	type=obj.options[obj.selectedIndex].value;
  
	//add by
	var TransPatientObj=document.getElementById("TransPatient");
	var TransUnitObj=document.getElementById("TransUnit");
	var FeelaterObj=document.getElementById("Feelater");

    var  WardNameObj=document.getElementById("WardName");

	if (type=="O")
	{
		TransPatientObj.disabled=false;
		TransUnitObj.disabled=false;
		FeelaterObj.disabled=false;
		//WardNameObj.disabled=true;
		
		
	}
	else
	{
		
		TransPatientObj.disabled=true;
		TransUnitObj.disabled=true;
		FeelaterObj.disabled=true;
		//WardNameObj.disabled=false;

		if (type=="I")
		{
			websys_setfocus("WardName");
		}
	}
	
}
function onPatientTypeDown()
{
	if (window.event.keyCode==13)
	{
		var obj=document.getElementById('PatType');
		type=obj.options[obj.selectedIndex].value;
 		if (type=="I")
		{
			websys_setfocus("WardName");
			//combo_WardListKeydownhandler();
		}
	
	}
	
}

function combo_WardListKeydownhandler()
{
	//alert("cc");
  var obj=combo_WardList;
  var WardRowId=obj.getActualValue();
  DHCC_SetElementData('WardRowid',WardRowId);

 websys_setfocus("BedNo");
		
  /*var WardDesc=obj.getSelectedText();
  
  var bedListobj=combo_bedList;
  
  var Bedobj=DHCC_GetElementData("GetBedListstr");

	if(Bedobj)
	{
		var bedliststr=cspRunServerMethod(Bedobj,WardRowId);
		
		//bedliststr="aa"+String.fromCharCode(1)+"bb-1";
		//alert(bedliststr);
		bedListobj.addOptionStr(bedliststr)
	}
	*/
	
}
function combo_WardListKeyenterhandler()
{
	//alert("cc");
}
function combo_eqListKeydownhandler()
{
	
  var obj=combo_eqList;
  var DeviceDR=obj.getActualValue();
  var Device=obj.getSelectedText();

  document.getElementById("DeviceDR").value=DeviceDR;
  document.getElementById("Device").value=Device;
   var locdr=document.getElementById("LocDR").value;
	
	var GetEQPrintTemplateFun=document.getElementById("GetPrintTemplate").value;
	var PrintTemplate=cspRunServerMethod(GetEQPrintTemplateFun,DeviceDR);
	if (PrintTemplate!="") gPrintTemplate=PrintTemplate;
		
	var GetFunction=document.getElementById("GetGroupRoom").value;
	var Info=cspRunServerMethod(GetFunction,Device,locdr);
	var Item1=Info.split("^");
	document.getElementById("EQGroup").value=Item1[0];
    document.getElementById("EQGroupDR").value=Item1[1];
    document.getElementById("Room").value=Item1[2];
	document.getElementById("RoomDR").value=Item1[3];
}
function combo_eqListKeyenterhandler()
{
	 websys_setfocus("SelectItem");
		
}

function onTransPatientClick()
{
	var TransPatientObj=document.getElementById("TransPatient");
   	if (TransPatientObj)
   	{
	   	if (TransPatientObj.checked)
	   	{
		   	var FeelaterObj=document.getElementById("Feelater");
         	if (FeelaterObj)
         	{
	         	FeelaterObj.checked=false;
	         	
         	}
         	var TransUnitObj=document.getElementById("TransUnit");
         	TransUnitObj.disabled=false;
		   	
	   	}
   	}
	
}
function onFeelaterClick()
{
	var FeelaterObj=document.getElementById("Feelater");
    if (FeelaterObj)
    {
	   if (FeelaterObj.checked)
	   {
		  var TransPatientObj=document.getElementById("TransPatient");
   		  if (TransPatientObj)
   		  {
	         TransPatientObj.checked=false;
	   	  }
	   	  var TransUnitObj=document.getElementById("TransUnit");
          TransUnitObj.disabled=true;
	
		   	
	   	}
   	}
	
}
//get location register print template
function GetLocRegTemplate()
{
   var locdr=document.getElementById("LocDR").value;
   
   var GetRegTempFunction=document.getElementById("GetLocPrintTemp").value;
   gPrintTemplate=cspRunServerMethod(GetRegTempFunction,locdr);	
}

function GetIndex()
{
   var locdr=document.getElementById("LocDR").value;
   var GetIndexFunction=document.getElementById("GetIndexFunction").value;
   var Index=cspRunServerMethod(GetIndexFunction,locdr);	
   document.getElementById("Index").value=Index;
}



function AgeKeyDown()
{	
	UnitObj=document.getElementById("AgeUNIT");
	var SelectIndex=UnitObj.selectedIndex;
	Unit=UnitObj.options[SelectIndex].value;
	var Age=document.getElementById("strAge").value;

	if (window.event.keyCode==13)
	{
		if ((Unit=="Years")&&(Age!=""))
		{
			document.getElementById("BirthDay").value=DateDemo();
		 	var strDOB=document.getElementById("BirthDay").value;
	  	 	var item1=strDOB.split("/");
	  	 	years=item1[2]-Age;
	     	DOB=item1[0]+"/"+item1[1]+"/"+years;
	     	document.getElementById("BirthDay").value=DOB;
		}
		else if (((Unit=="Months")||(Unit=="Days"))&&(Age!=""))
		{
			var GetDOBFunction=document.getElementById("GetDOB").value;
			var BirthDayOBJ=document.getElementById("BirthDay");
			
   			var strDOB=cspRunServerMethod(GetDOBFunction,Age,Unit);	
   			BirthDayOBJ.value=strDOB
		}
	websys_setfocus("PatType");		
	}
}
function OnchangeUnit()
{
	var Age=document.getElementById("strAge").value;
	if (Age!="")
	{
		UnitObj=document.getElementById("AgeUNIT");
		var SelectIndex=UnitObj.selectedIndex;
		Unit=UnitObj.options[SelectIndex].value;

		if (Unit=="Years")
		{
			document.getElementById("BirthDay").value=DateDemo();
		 	var strDOB=document.getElementById("BirthDay").value;
	  	 	var item1=strDOB.split("/");
	  	 	years=item1[2]-Age;
	     	DOB=item1[0]+"/"+item1[1]+"/"+years;
	     	document.getElementById("BirthDay").value=DOB;
		}
		else if (((Unit=="Months")||(Unit=="Days")))
		{
			var GetDOBFunction=document.getElementById("GetDOB").value;
			var BirthDayOBJ=document.getElementById("BirthDay");
			
   			var strDOB=cspRunServerMethod(GetDOBFunction,Age,Unit);	
   			BirthDayOBJ.value=strDOB
		}
	websys_setfocus("PatType");		
	}
}
function Age_LostFocus()
{
	Unit=document.getElementById("AgeUNIT").value;
	var Age=document.getElementById("strAge").value;
	if ((Unit=="Years")&&(Age!=""))
	{
			document.getElementById("BirthDay").value=DateDemo();
		 	var strDOB=document.getElementById("BirthDay").value;
	  	 	var item1=strDOB.split("/");
	  	 	years=item1[2]-Age;
	     	DOB=item1[0]+"/"+item1[1]+"/"+years;
	     	document.getElementById("BirthDay").value=DOB;
	}
	else if (((Unit=="Months")||(Unit=="Days"))&&(Age!=""))
	{
			var GetDOBFunction=document.getElementById("GetDOB").value;
			var BirthDayOBJ=document.getElementById("BirthDay");
			
   			var strDOB=cspRunServerMethod(GetDOBFunction,Age,Unit);	
   			BirthDayOBJ.value=strDOB;
	}
}

function SelectItem_keyDown()
{
	if (window.event.keyCode==13)
	{
		window.event.keyCode=117;
		SelectItem_lookuphandler();
	}
}
function NamePYObj_Click()
{
	if (window.event.keyCode==13)
	{
		  websys_setfocus('Sex');
		
	}
	
}
function onClear()
{
     document.location.reload();
     
}
function GetSelectName(Info)
{
	 var item=Info.split("^")
	 document.getElementById("Name").value=item[1];
     document.getElementById("NamePY").value=gHztoPyobj1.topin(item[1]);
     document.getElementById("PatRegNo").value=item[0];
     document.getElementById("BirthDay").value=item[2];
     var SexObj=document.getElementById("Sex");
     SexObj.options[SexObj.selectedIndex].text=item[3];
     SexObj.options[SexObj.selectedIndex].value=item[7];
     document.getElementById("InMedicare").value=item[4];
     document.getElementById("TelNo").value=item[5];
     document.getElementById("Address").value=item[6];
     document.getElementById("No").value=item[8];
     var strAge=item[9];
     var len=strAge.length;
     var AgeUnit=strAge.substr(len-1,1);
     var intAge=strAge.substr(0,len-1);
     var AgeUNITObj=document.getElementById("AgeUNIT");
     
	 document.getElementById("strAge").value=intAge;
	 if ((AgeUnit==t["days"]))
     {
	      AgeUNITObj.options[AgeUNITObj.selectedIndex].value="days";
	      AgeUNITObj.options[AgeUNITObj.selectedIndex].text=t["days"];
	     
	      //document.getElementById("AgeUNIT").value="Days";
     }
     else if (AgeUnit==t["months"])
     {
	      AgeUNITObj.options[AgeUNITObj.selectedIndex].value="Months";
	      AgeUNITObj.options[AgeUNITObj.selectedIndex].text=t["months"];
	 
	      //document.getElementById("AgeUNIT").value="Months";
	 }
	 else
	 {
		  AgeUNITObj.options[AgeUNITObj.selectedIndex].value="years";
	      AgeUNITObj.options[AgeUNITObj.selectedIndex].text=t["years"];
	 	  //document.getElementById("AgeUNIT").value="Years";
	 }
     
     document.getElementById("Company").value=item[10];
     document.getElementById("IDCardNo").value=item[11];
     
     document.getElementById("Vocation").value=item[13];
     document.getElementById("Vocation").text=item[12];
     
     document.getElementById("OPMedicare").value=item[14];
     
     gGetLocID="";
     
     websys_setfocus('PatType');
     
       
     

}

	
function ConnectHL7Server()
{
	if (!gHL7Obj1)
		gHL7Obj1 = new ActiveXObject("HL7Com.CHL7");	
	//HL7Obj.ConnectHL7Server("192.168.2.239","1041");
    gHL7Obj1.ConnectHL7Server1();
    
	
}

function IniHZtoPYObj()
{
	if (!gHztoPyobj1)
	{
		gHztoPyobj1=new ActiveXObject("Phztopin.CHZtoPin");
		
	}
}


function Name_keyDown()
{
    //var LocID=session["LOGON.CTLOCID"];

	//var Name=document.getElementById("Name").value;
	//document.getElementById("NamePY").value=gHztoPyobj1.topin(Name);
	  
	
	if (window.event.keyCode==13)
	{
		var Name=document.getElementById("Name").value;
		var GetPatientCountFun=document.getElementById("GetPatientCount").value;
		var count=cspRunServerMethod(GetPatientCountFun,Name,gLocID);
        if (count>0)
		{
			//alert(count);
			window.event.keyCode=117;
			Name_lookuphandler();
		}
		else
		{
			websys_setfocus('Sex');
			
		}
	}
}
function Name_keyUp()
{
	GetPin();
}
function GetLocDR()
{
	var LocID=document.getElementById("LocDR");
    if (LocID.value=="")
    {
	      var GetLocSessionFunction=document.getElementById("GetLocSession").value;
	     var Getlocicvalue=cspRunServerMethod(GetLocSessionFunction,"SelLocID");
	     if (Getlocicvalue=="")
           LocID.value=session['LOGON.CTLOCID'];
         else 
 		   LocID.value=Getlocicvalue;
	}
	gLocID=LocID.value;

}


function RegNo_keyDown()
{
 	if (window.event.keyCode==13)
	{
		window.event.keyCode=117;
		PatRegNo_lookuphandler();
	}
	
}

//PAR:OrdName As %String, OrdPrice As %String, OrdQty As %String, OrdItemRowID As %String
//Ret:desc,rowid,subcatdesc,ItemPrice
function GetOEItem(str)
{      
	var obj=document.getElementById('SelectItem');
	var tem=str.split("^");
	obj.value=tem[0];
	obj.text=tem[1];
	var OrdQtyObj=document.getElementById("OrdQty");
	
	if (tem[0]!="")
	{
		var ObjName=document.getElementById("TOrdName"+"z"+gIndex)
		var ObjPrice=document.getElementById("TOrdPrice"+"z"+gIndex)
		var ObjOrdQty=document.getElementById("TOrdQty"+"z"+gIndex)
		var ObjRowID=document.getElementById("TOrdItemRowID"+"z"+gIndex)
		if (ObjName==null)
		{
			alert(t["ItemNameNull"]);
			return;
		}
		else
		{
			ObjName.innerText=tem[0];
			ObjPrice.innerText=tem[3];
			ObjOrdQty.innerText=OrdQtyObj.value;
			ObjRowID.innerText=tem[1];
			//
			try
			{
				var tablistobj=document.getElementById("t" + "DHCRisNewPatient");
				//tablistobj.insertRow(0);
				DHCWebD_AddTabRow(tablistobj);
				var SelectItemObj=document.getElementById("SelectItem");
				if(SelectItemObj)
				{
					SelectItemObj.value="";
				}
				
	    	}
	    	catch(e)
	    	{
		    	alert("Errow when insertRow");
		    	return false;
		    }
		    
		    gIndex=gIndex+1;
		}
		OrdQtyObj.value=1;
	}
}


function DHCWebD_AddTabRow(objtbl)
{
	DHCWebD_ResetRowItems(objtbl);
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=websys_getParentElement(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	var oldrowitems=objlastrow.all;	//IE only
	
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	if (!oldrowitems) oldrowitems=objlastrow.getElementsByTagName("*"); //N6
	
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=row;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			rowitems[j].value="";
			////
			if (arrId[0]=="OPOrdNo"){
				///alert(arrId[0]+"|||"+row-2);
				oldrowitems[j].innerText=row-1;
			}
			///alert(rowitems[j].name);
		}
	}
	
	///alert(row-1);	
	objnewrow=objtbl.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}	
}


function DelSelItem_Click()
{ 
  var ordtab=document.getElementById("tDHCRisNewPatient");
  var num=0;
  if (ordtab) 
  {
     for (var i=1; i<ordtab.rows.length; i++)
     {
        var selectedobj=document.getElementById("TSelOEItem"+"z"+i);

        if ((selectedobj)&&(selectedobj.checked))
        {
	       num=num+1;
	       ClearSelItem(i);
	      // selectedobj.value="";
	    }
	  } 
    }
   
}


function ClearSelItem(nIndex)
{
	var ObjName=document.getElementById("TOrdName"+"z"+nIndex)
	var ObjPrice=document.getElementById("TOrdPrice"+"z"+nIndex)
	var ObjOrdQty=document.getElementById("TOrdQty"+"z"+nIndex)
	var ObjRowID=document.getElementById("TOrdItemRowID"+"z"+nIndex)
	if (ObjName==null)
	{
		alert("ObjName is Null");
		return;
	}
	else
	{
		try{
		var tablistobj=document.getElementById("t" + "DHCRisNewPatient");
		tablistobj.deleteRow(nIndex);
		DHCWebD_ResetRowItems(tablistobj);
	    }
	    catch(e)
	    {return false;}
	  	    
		gIndex=gIndex-1;
		
	}
	
}
function DHCWebD_ResetRowItems(objtbl) {
	//alert(objtbl.rows.length);
	//check the header by z; zhaocz;
	var firstrow=objtbl.rows[0];
	var firstitems=firstrow.all;
	if (!firstitems) firstitems=objrow.getElementsByTagName("*"); //N6
	var myaryid=firstitems[1].id.split("z");
	if (myaryid.length==2){
		//no header
			fIdx=0
		}else{
			fIdx=1
		}
	for (var i=fIdx;i<objtbl.rows.length; i++) {
		var objrow=objtbl.rows[i];
		{if ((i+1)%2==0) {objrow.className="RowEven";} else {objrow.className="RowOdd";}}
		var rowitems=objrow.all; //IE only
		if (!rowitems) rowitems=objrow.getElementsByTagName("*"); //N6
		for (var j=0;j<rowitems.length;j++) {
			//alert(i+":"+j+":"+rowitems[j].type);
			if (rowitems[j].id) {
				var arrId=rowitems[j].id.split("z");
				arrId[arrId.length-1]=i;
				rowitems[j].id=arrId.join("z");
				rowitems[j].name=arrId.join("z");
			}
		}
	}
}



function NewPatObj_click()
{
     
   var Namepar=document.getElementById("Name");
   if (Namepar.value=="")
   {
	   alert(t['InputName']);
	   return;
   }
   var NamePY=document.getElementById("NamePY").value;
   if (NamePY=="")
   {
	   alert(t['InputNamePY']);
	   return;
   }
   
   var SexparOBj=document.getElementById("Sex");
   var Sex=SexparOBj.options[SexparOBj.selectedIndex].text;
   if (Sex=="")
   {
	   alert(t['InputSex']);
	   return;
   }
   
   var PatTypeOBJ=document.getElementById("PatType");
   var txtPatType=PatTypeOBJ.options[PatTypeOBJ.selectedIndex].text;
   var PatTypevalue=PatTypeOBJ.options[PatTypeOBJ.selectedIndex].value;
   if (txtPatType=="")
   {
	   alert(t['InputType']);
	   return;
   }

   var Flag="";
   
   if (PatTypevalue=="O")
   {
	 var TransPatientObj=document.getElementById("TransPatient");
	 var TransUnitObj=document.getElementById("TransUnit");
  	 var FeelaterObj=document.getElementById("Feelater");
	 if (FeelaterObj.checked)
	 {
		Flag="laterFee";
	 }
	 else if (TransPatientObj.checked)
	 {
		TransUnit=TransUnitObj.value;
		Flag="O:"+TransUnit
     }
   }

   var WardNameRowid=document.getElementById("WardRowid").value;
   var BedNoRowid=document.getElementById("BedRowid").value;
   
   if ((PatTypevalue=="O")&&(WardNameRowid!=""))
   {
	   alert(t['NOTInputWard']);
	  return ;
   }
   if ((PatTypevalue=="O")&&(BedNoRowid!=""))
   {
	   alert(t['NOTInputBed']);
	   return ;
   }
   
   var RegNopar=document.getElementById("PatRegNo");
   var Birthpar=document.getElementById("BirthDay");
   var TelNopar=document.getElementById("TelNo");
   var OpMedicare=document.getElementById("OPMedicare");
   var InMedicare=document.getElementById("InMedicare");
    var IDCardNo1=document.getElementById("IDCardNo");
   //var Vocation=document.getElementById("Vocation");
   var obj=combo_OccuptionListstr;
   var VocationDR=obj.getActualValue();
   //var Device=obj.getSelectedText();
   
   
   var Company=document.getElementById("Company");
   var Address=document.getElementById("Address");
   var AdmDep=document.getElementById("AdmDep");
   var AdmDoc=document.getElementById("AdmDoc");
   var AgeObj=document.getElementById("strAge");
   var UNITObj=document.getElementById("AgeUNIT");
    //var RecLocID=session['LOGON.CTLOCID'];
   var CreateUser=session['LOGON.USERID'];
   var StudyNo=document.getElementById("StudyNo").value;  // modi
   var RegDate=document.getElementById("Executedate").value;
   
   var AppLocDR=document.getElementById("AppLocID").value;
   if (AppLocDR=="")
   {
	   //alert(t['InputAppLoc']);
	   //return;
   }
   var AppDocID=document.getElementById("AppDocID").value;
   if (AppDocID=="")
   {
	   //alert(t['InputAppDoc']);
	   //return ;
   }
   
   var Info=RegNopar.value+"^"+Namepar.value+"^"+Sex+"^"+Birthpar.value+"^"+TelNopar.value+"^"+OpMedicare.value+"^"+InMedicare.value+"^"+PatTypevalue+"^"+IDCardNo1.value+"^"+VocationDR+"^"+Company.value+"^"+Address.value+"^"+AppLocDR+"^"+AppDocID+"^"+AgeObj.value+"^"+UNITObj.value+"^"+WardNameRowid+"^"+BedNoRowid+"^"+StudyNo+"^"+NamePY; //AdmDoc.text;
   var DeviceDR=document.getElementById("DeviceDR").value;
   if (DeviceDR=="")
   {
	   alert(t['InputDevice']);
	   return;
   }
   var RegEQDesc=document.getElementById("Device").value; 
   var RoomDR=document.getElementById("RoomDR").value;
   var Room=document.getElementById("Room").value;
   var EQGroupDR=document.getElementById("EQGroupDR").value;
   var WardName=document.getElementById("WardName").value;
   var BedCode=document.getElementById("BedNo").value;
   var No=document.getElementById("No").value;
   var Weight=document.getElementById("Weight").value;
   var Index=document.getElementById("Index").value;
   
      
   var MainDocDR=document.getElementById("MainDocDR").value;
   var OptionDocDR=document.getElementById("OptionDocDR").value;

   
   var ExamInfo=DeviceDR+"^"+RoomDR+"^"+EQGroupDR+"^"+gLocID+"^"+""+"^"+No+"^"+Weight+"^"+Index+"^"+Flag+"^"+RegDate;
   var ExamInfo=DeviceDR+"^"+RoomDR+"^"+EQGroupDR+"^"+gLocID+"^"+MainDocDR+"^"+OptionDocDR+"^"+No+"^"+Weight+"^"+Index+"^"+Flag+"^"+RegDate;

   
   GetOrdItemStrS();

   
   if(gOrdItemStrInfo=="")
   {
	   alert(t["InputOrder"]);
	   return;
   }
   var ICDExterDesc=document.getElementById("ICDExterDesc").value;
   var ICDCodeDR=GetICDListInfo("ICDDesc");
      
   var NewPaFunction=document.getElementById("GetAddPat").value;
   var ExamInfo1=cspRunServerMethod(NewPaFunction,Info,gOrdItemStrInfo,CreateUser,gLocID,ExamInfo,ICDExterDesc,ICDCodeDR);
   if (ExamInfo1=="^")
   {
	   alert("Register Fail!");
	   document.location.reload();
	   return ;
   }
   //var Item=ExamInfo1.split("^");
   var Info=ExamInfo1.split(String.fromCharCode(1))
   if (Info[1]!="")
   {
			var Info1=Info[1].split("^");
			var Number=Info1[1];
			var IsCreate=Info1[2];
			if (IsCreate=="1")
			{
				//var StudyNumber=document.getElementById("StudyNumber").value;
	       		//var UpdateNoFunction=document.getElementById("UpdateStudyNo").value;
		   		//var ret=cspRunServerMethod(UpdateNoFunction,gLocID,EQGroupDR,Number,RegDate);

			}
	}
	
   if(Info[0]!="")
   {
	   
	   var Item=Info[0].split("^");
	   var StudyNo=Item[1];
	   var PatientID=Item[0];
	   var PatientName=Namepar.value;
	   //var Sex=Sexpar.value;
	   var strDOB=Birthpar.value;
	   var strAge=document.getElementById("strAge").value;
	   
	   var item1=strDOB.split("/");
	   DOB=item1[2]+"-"+item1[1]+"-"+item1[0];
	   document.getElementById("StudyNo").value=Item[1];
	   document.getElementById("PatRegNo").value=Item[0];
	   
	   //send HL7 to Link pro
	   var GetSupptWorkListFun1=document.getElementById("GetSupptWorkListFun").value;
	   var Support=cspRunServerMethod(GetSupptWorkListFun1,RegEQDesc,gLocID);
	   var SendInfo=PatientID+"^"+NamePY+"^"+DOB+"^"+Sex+"^"+StudyNo+"^"+Weight+"^"+""+"^"+RegEQDesc
	   //alert(SendInfo);
	   if ((gHL7Obj1)&&(Support=="Y"))
	   {
		   // alert("dob:"+DOB);
		   //var PatientName1=document.getElementById("Name").value;
	   	   gHL7Obj1.SendModalityInfo(PatientID,NamePY,DOB,Sex,StudyNo,"","","","",Weight,"",RegEQDesc,"NW");
		  //print register info
	   }
	   /*if (gPrintTemplate=="LiXiang")
	  {
			// use Li Xiang bar print 
			//alert(gPrintTemplate);
			var No=document.getElementById("No").value;
			var type=document.getElementById('PatType').text;
			var StudyNo=document.getElementById("StudyNo").value;
	        var PatientID=document.getElementById("PatRegNo").value;
	        //var INPNO=,OPNO,Room,InLocName,BedCode,OrdItemName
	        
			//printRegBar(StudyNo,PatientID,PatientName,strAge,Sex,type,Index,No);
			printRegBar(StudyNo,PatientID,PatientName,strAge,Sex,type,Index,No,InMedicare.value,OpMedicare.value,Room,WardName,BedCode,gOrdName,NamePY);
			//printRegBar(StudyNo,PatientNo,PatientName,Age,Sex,type,Index,NoInfo,IpNo,OpNo,Room,PatLoc,BedCode,OrdName,PatNamePY)
			
	   }
	   else if (gPrintTemplate!="")
	   {
		       //alert(
			   DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemplate);
			   var MyPara="PatientName"+String.fromCharCode(2)+PatientName;
			   MyPara=MyPara+"^RegNo"+String.fromCharCode(2)+PatientID;
			   MyPara=MyPara+"^Sex"+String.fromCharCode(2)+Sex;
			   MyPara=MyPara+"^Age"+String.fromCharCode(2)+strAge;
			   MyPara=MyPara+"^Date"+String.fromCharCode(2)+DateDemo();
			   MyPara=MyPara+"^StudyNo"+String.fromCharCode(2)+StudyNo;
			   InvPrintNew(MyPara,"");
		}
		*/
		alert(t["Sucessfully"]);
		
		createCallfile(PatientName,StudyNo,Index,Room,PatTypevalue);
		
		//update studyno ceate 
	  document.location.reload();
   }
   else
   {
	   alert(t["Error"]);
	   document.location.reload();
   }
   
}

//
function NewPatObj_click2()
{
   
   GetOrdItemStrS();
   var CreateUser=session['LOGON.USERID'];
   var RecLocID=session['LOGON.CTLOCID'];
   alert(gOrdItemStrInfo+"~"+CreateUser+"~"+RecLocID);
  
}

function GetOrdItemStrS()
{
  var ordtab=document.getElementById("tDHCRisNewPatient");
  var ObjName,ObjPrice,ObjOrdQty,ObjRowID;
  var OEItemStr,OEItemStrS;
  //var RecLocID=session['LOGON.CTLOCID'];
  gOrdItemStrInfo="";
  var num=0;
  if (ordtab) 
  {
     for (var i=1; i<ordtab.rows.length-2; i++)
     {
	    OEItemStr="";
	    var OrdName=document.getElementById("TOrdNamez"+i).innerText;
	    var OrdRowID=document.getElementById("TOrdItemRowIDz"+i).innerText;
	    var OrdQty=document.getElementById("TOrdQtyz"+i).innerText;
	    var OrdPrice=document.getElementById("TOrdPricez"+i).innerText;
	    
	    //OrdItemRowID^OrdQty^ItemRecLocRID^OrdPrice^^OrdInsRowId
        if ((OrdName!=""))
        {
	        
	      OEItemStr= OrdRowID+"^"+OrdQty+"^"+gLocID+"^"+OrdPrice+"^"+"^" ;  
	      //OEItemStr= OrdRowID+"^"+OrdQty+"^"+RecLocID+"^"+""+"^"+"^" ;    
	      gOrdItemStrInfo=gOrdItemStrInfo+OEItemStr+";";
	      
	      var splits = /-/i;            // 创建正则表达式模式?
   		  var pos = OrdName.search(splits); 
   		  //alert(pos);  
          if (pos>0)
          {           
	      	 var ItemInfo=OrdName.split("-");
	      	 gOrdName=gOrdName+" "+ItemInfo[1];
          }
          else
          {
	          gOrdName=gOrdName+" "+OrdName;
	          
          }
          
        }
	  } 
    }
    
	
}

function InvPrintNew(TxtInfo,ListInfo)
{
	////
	////DHCP_PrintFun(encmeth,PObj,inpara,inlist)
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
} 
function printRegBar(StudyNo,PatientNo,PatientName,Age,Sex,type,Index,NoInfo,IpNo,OpNo,Room,PatLoc,BedCode,OrdName,PatNamePY)
{
	var Info=StudyNo+"^"+PatientNo+"^"+PatientName+"^"+Age+"^"+Sex+"^"+type+"^"+Index+"^"+NoInfo+"^"+IpNo+"^"+OpNo+"^"+Room+"^"+PatLoc+"^"+BedCode+"^"+OrdName+"^"+PatNamePY
	//alert(PatNamePY);
    
	  var Bar,i,j;  
    Bar= new ActiveXObject("PrintRegBar.PrnBar");//TestAx.CLSMAIN
   	Bar.PrintName="tiaoma";//printer name
    Bar.StudyNo=StudyNo;
    Bar.RegNo=PatientNo;
    Bar.PatName=PatientName;
    Bar.Sex=Sex;
    Bar.Age=Age;
    Bar.strType=type;
    Bar.strIndex=Index;
    Bar.strNo=NoInfo;
    Bar.OPNo=OpNo;
    Bar.IPNo=IpNo;
    Bar.PatLoc=PatLoc;
    Bar.BedCode=BedCode;
    Bar.OrdName=OrdName;
    Bar.Room=Room;
    Bar.PatNamePY=PatNamePY;
    Bar.PrintOutRegBill();
}


function GetSelectPaadmInfo(Info)
{
	GetSelectName(Info);
}

function UpdatePatientInfo_Click1()
{
    if (gGetLocID==gLocID)
   {
     var WardNameRowid=document.getElementById("WardRowid").value;
     var BedNoRowid=document.getElementById("BedRowid").value;
     //alert(WardNameRowid+"^"+BedNoRowid);
   	 var Sexpar=document.getElementById("Sex");
     var PatType=document.getElementById("PatType");
     var Namepar=document.getElementById("Name");
     var RegNopar=document.getElementById("PatRegNo");
     var Birthpar=document.getElementById("BirthDay");
     var TelNopar=document.getElementById("TelNo");
     var OpMedicare=document.getElementById("OPMedicare");
     var InMedicare=document.getElementById("InMedicare");
     var IDCardNo1=document.getElementById("IDCardNo");
     var Vocation=document.getElementById("Vocation");
     var Company=document.getElementById("Company");
     var Address=document.getElementById("Address");
     var AdmDep=document.getElementById("AdmDep");
     var AdmDoc=document.getElementById("AdmDoc");
     var AgeObj=document.getElementById("strAge");
     var UNITObj=document.getElementById("AgeUNIT");
     //var RecLocID=session['LOGON.CTLOCID'];
     var Info=RegNopar.value+"^"+Namepar.value+"^"+Sexpar.value+"^"+Birthpar.value+"^"+TelNopar.value+"^"+OpMedicare.value+"^"+InMedicare.value+"^"+PatType.text+"^"+IDCardNo1.value+"^"+Vocation.text+"^"+Company.value+"^"+Address.value+"^"+AgeObj.value+"^"+UNITObj.value
     var UpdateInfoFunction=document.getElementById("UpdateInfo").value;
     var ret=cspRunServerMethod(UpdateInfoFunction,Info);
     if (ret=="0")
     {
	   alert(t["UpdateSuccessFul"]);
     }
     else 
     {
	   alert(t["UpdateFailure"]+"SQLCODE= "+ret);
     }
   }
   else
   {
	   alert(t["CantUpdate"]);
	   
   }
   
}
function PrintRegBarObj_click()
{
  	
    var Namepar=document.getElementById("Name");
   if (Namepar.value=="")
   {
	   alert(t['InputName']);
	   return;
   }
   var NamePY=document.getElementById("NamePY").value;
   if (NamePY=="")
   {
	   alert(t['InputNamePY']);
	   return;
   }
   
   var SexparOBj=document.getElementById("Sex");
   var Sex=SexparOBj.options[SexparOBj.selectedIndex].text;
   if (Sex=="")
   {
	   alert(t['InputSex']);
	   return;
   }
   var strAge=document.getElementById("strAge").value;
   
   var PatTypeOBJ=document.getElementById("PatType");
   var txtPatType=PatTypeOBJ.options[PatTypeOBJ.selectedIndex].text;
   var PatTypevalue=PatTypeOBJ.options[PatTypeOBJ.selectedIndex].value;
   if (txtPatType=="")
   {
	   alert(t['InputType']);
	   return;
   }

   var Flag="";
   
   if (PatTypevalue=="O")
   {
	 var TransPatientObj=document.getElementById("TransPatient");
	 var TransUnitObj=document.getElementById("TransUnit");
  	 var FeelaterObj=document.getElementById("Feelater");
	 if (FeelaterObj.checked)
	 {
		Flag="laterFee";
	 }
	 else if (TransPatientObj.checked)
	 {
		TransUnit=TransUnitObj.value;
		Flag="O:"+TransUnit
     }
   }

   var WardNameRowid=document.getElementById("WardRowid").value;
   var BedNoRowid=document.getElementById("BedRowid").value;
   
   if ((PatTypevalue=="I")&&((WardNameRowid=="")||(WardNameRowid=="undefined")))
   {
	   alert(t['InputWard']);
	   return ;
   }
   if ((PatTypevalue=="I")&&((BedNoRowid=="")||(BedNoRowid=="undefined")))
   {
	   //alert(t['InputBed']);
	   //return ;
   }
   
   var RegNopar=document.getElementById("PatRegNo");
   var Birthpar=document.getElementById("BirthDay");
   var TelNopar=document.getElementById("TelNo");
   var OpMedicare=document.getElementById("OPMedicare");
   var InMedicare=document.getElementById("InMedicare");
    var IDCardNo1=document.getElementById("IDCardNo");
   //var Vocation=document.getElementById("Vocation");
   var obj=combo_OccuptionListstr;
   var VocationDR=obj.getActualValue();
   //var Device=obj.getSelectedText();
   
   
   var Company=document.getElementById("Company");
   var Address=document.getElementById("Address");
   var AdmDep=document.getElementById("AdmDep");
   var AdmDoc=document.getElementById("AdmDoc");
   var AgeObj=document.getElementById("strAge");
   var UNITObj=document.getElementById("AgeUNIT");
    //var RecLocID=session['LOGON.CTLOCID'];
   var CreateUser=session['LOGON.USERID'];
   var StudyNo=document.getElementById("StudyNo").value;  // modi
   
   
   var Info=RegNopar.value+"^"+Namepar.value+"^"+Sex+"^"+Birthpar.value+"^"+TelNopar.value+"^"+OpMedicare.value+"^"+InMedicare.value+"^"+PatTypevalue+"^"+IDCardNo1.value+"^"+VocationDR+"^"+Company.value+"^"+Address.value+"^"+gLocID+"^"+CreateUser+"^"+AgeObj.value+"^"+UNITObj.value+"^"+WardNameRowid+"^"+BedNoRowid+"^"+StudyNo; //AdmDoc.text;
   var DeviceDR=document.getElementById("DeviceDR").value;
   if (DeviceDR=="")
   {
	   alert(t['InputDevice']);
	   return;
   }
   var RegEQDesc=document.getElementById("Device").value; 
   var RoomDR=document.getElementById("RoomDR").value;
   var Room=document.getElementById("Room").value;
   var EQGroupDR=document.getElementById("EQGroupDR").value;
   

   
  
   var obj=combo_maindoc;
   var MainDocDR=obj.getActualValue();

   
   var obj=combo_assiantdoc;
   OptionDocDR=obj.getActualValue();

   
   var WardName=document.getElementById("WardName").value;
   var BedCode=document.getElementById("BedNo").value;
   
   var No=document.getElementById("No").value;
   var Weight=document.getElementById("Weight").value;
   
   var Index=document.getElementById("Index").value;
   
   var ExamInfo=DeviceDR+"^"+RoomDR+"^"+EQGroupDR+"^"+MainDocDR+"^"+OptionDocDR+"^"+No+"^"+Weight+"^"+Index+"^"+Flag;
   
   GetOrdItemStrS();

 
   
   if(gOrdItemStrInfo=="")
   {
	   alert(t["InputOrder"]);
	   return;
   }
   
   //alert(gPrintTemplate);
   if (gPrintTemplate=="LiXiang")
   {
	 var No=document.getElementById("No").value;
	 var type=PatTypevalue;//document.getElementById('PatType').text;
	 var StudyNo=document.getElementById("StudyNo").value;
	 var PatientID=document.getElementById("PatRegNo").value;
	 //var Info=StudyNo+"^"+PatientID+"^"+Namepar.value+"^"+strAge+"^"+Sex+"^"+txtPatType+"^"+Index+"^"+No+"^"+InMedicare.value+"^"+OpMedicare.value+"^"+Room+"^"+WardName+"^"+BedCode+"^"+gOrdName+"^"+NamePY;
	 printRegBar(StudyNo,PatientID,Namepar.value,strAge,Sex,type,Index,No,InMedicare.value,OpMedicare.value,Room,WardName,BedCode,gOrdName,NamePY);
   }
   else if (gPrintTemplate!="")
   {
	  DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemplate);
	   var MyPara="PatientName"+String.fromCharCode(2)+Namepar.value;
	   MyPara=MyPara+"^RegNo"+String.fromCharCode(2)+PatientID;
	   MyPara=MyPara+"^Sex"+String.fromCharCode(2)+Sex;
	   MyPara=MyPara+"^Age"+String.fromCharCode(2)+strAge;
	   MyPara=MyPara+"^Date"+String.fromCharCode(2)+DateDemo();
	   MyPara=MyPara+"^StudyNo"+String.fromCharCode(2)+StudyNo;
	   InvPrintNew(MyPara,"");
	}
 	
}
function combo(cmstr)
{
	var obj=document.getElementById(cmstr);
	obj.size=1; 
	obj.multiple=false;
}

function AddItem(ObjName, Info)
{
	var Obj=document.getElementById(ObjName);
    if (Obj.options.length>0)
 	{
		for (var i=Obj.options.length-1; i>=0; i--) Obj.options[i] = null;
	}
	
    var ItemInfo=Info.split("^");
 	for (var i=0;i<ItemInfo.length;i++)
 	{
	 	perInfo=ItemInfo[i].split(String.fromCharCode(1))
	 	var sel=new Option(perInfo[1],perInfo[0]);
		Obj.options[Obj.options.length]=sel;
		
	} 
}
function GetICDListInfo(ObjName)
{
	var  Info=""
	var Obj=document.getElementById(ObjName);
  	for (var i=0;i<Obj.length;i++)
  	{
	  	ICDDR=Obj.options[i].value;
	  	if (Info=="")
	  	{
		  Info=ICDDR;	
	  	}
	  	else
	  	{
		  	Info=Info+"^"+ICDDR;
	  	}

  	}
  	return Info;
 
	
}


function GetBedInfo(Info)
{	var item=Info.split("^");
	document.getElementById("BedRowid").value=item[1];
	websys_setfocus("Device");
	//alert(item[1]);
}
// get appliaction location
function GetAppLocInfo(Info)
{
	var item=Info.split("^");
	document.getElementById("AppLocID").value=item[1];
}

//get Application of doctor
function GetAppDocInfo(Info)
{
	var item=Info.split("^");
	document.getElementById("AppDocID").value=item[1];
}
function IDCAliasOBJ_keyDown()
{
	if (window.event.keyCode==13)
	{
		ICDAlias=document.getElementById("IDCAlias").value;
		GetICDFunction=document.getElementById("GetICD10Desc").value;
		var Info=cspRunServerMethod(GetICDFunction,ICDAlias);
		var ICDList=document.getElementById("ICDLIST");
		//DHCC_ClearList("ICDLIST");
		AddItem("ICDLIST",Info);
	}
	
}
function ICDLISTOBJ_ondblclick()
{
	
	var ICDobj=document.getElementById('ICDLIST');
	var SelICDobj=document.getElementById('ICDDesc');

	var val=ICDobj.options[ICDobj.selectedIndex].value;
	var text=ICDobj.options[ICDobj.selectedIndex].text;

    
    var sel=new Option(text,val);
	SelICDobj.options[SelICDobj.options.length]=sel;
}

function ICDDescOBJ_ondblclick()
{
	var SelICDobj=document.getElementById('ICDDesc');
    if  (SelICDobj.selectedIndex>=0)
    {
	   SelICDobj.remove(SelICDobj.selectedIndex); 
    }
}
function addICDOBJ_onclick()
{
	ICDLISTOBJ_ondblclick();
	
}
function RemoveICDOBJ_onclick()
{
	ICDDescOBJ_ondblclick();
}

function loadCardType()
{
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
}

function CardTypeDefine_OnChange()
{
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	
	var myary=myoptval.split("^");
	
	var myCardTypeDR=myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR=="")
	{
		return;
	}
	///Read Card Mode
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadCard");
	}
	else
	{
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = true;
		}
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=ReadHFMagCard_Click;
		}
	}
	
	//Set Focus
	if (myary[16]=="Handle"){
		DHCWeb_setfocus("CardNo");
	}else{
		DHCWeb_setfocus("ReadCard");
	}
	
	m_CardNoLength=myary[17];
	
}

function SetCardNOLength()
{
	m_CardNoLength=GetCardNoLength();
	var obj=document.getElementById('CardNo');
	var objValue=obj.value;
	objValue=objValue.replace(/(^\s*)|(\s*$)/g,"");
	if (objValue!='')
	{
	  if ((objValue.length<m_CardNoLength)&&(m_CardNoLength!=0))
	  {
		for (var i=(m_CardNoLength-objValue.length-1); i>=0; i--)
		{
				objValue="0"+objValue
		}
	   }
	   var myCardobj=document.getElementById('CardNo');
	   if (myCardobj)
	   {
		   myCardobj.value=objValue;
	   }
     }

}
function GetCardNoLength(){
	return 15;
}

function FunReadCard()
{
    var myobj=document.getElementById("HXSpecialCard");
	if (myobj)
	{
	    var myrtn =ReadCard(myobj,23);
	    //alert(myrtn);
		myrtns=myrtn.split("^");
		if (myrtns[0]=="0")
		{
			var CardNoObj=document.getElementById("CardNo")
		    if (CardNoObj){
				CardNoObj.value=myrtns[1];
		 		SetCardNoLength();
		 		var obj=document.getElementById('CardNo');
		 		//alert(obj.value);
		 		var tkClass='web.DHCRisWorkBenchDoEx';
		        var tkMethod='GetCardInfo'
		        var RegNo=tkMakeServerCall(tkClass,tkMethod,obj.value,"");
		        //alert(RegNo);
		        var obj=document.getElementById("RegNo");
			    obj.value=RegNo;
		        GetPatientInfo();
		        FindClickHandler();
			}
	
		}
	}
	/*
	//alert("FunReadCard");
	allowbill="";
	gPaadm="";
    ////var myrtn=DHCACC_GetAccInfo();
    var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR);
    //alert(myrtn);
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn)
	{
		case "0":
			///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			var obj=document.getElementById("RegNo");
			obj.value=myary[5];
			var obj=document.getElementById("CardNo");
			obj.value=myary[1];
			
			var obj=document.getElementById("PAPATMASDR");
			obj.value=myary[4];
		    GetPatientInfo();
		
			//if (myary[5]!=""){
			//	ReLoadOPFoot("Bill");
			//}
			//alert("read");				
		    FindClickHandler();		
			break;
		case "-200":
			alert(t["cardinvalid"]);
			break;
		case "-201":
			alert(t["cardvaliderr"])
		default:
	}
	*/			
}

function combo_maindocKeydownhandler()
{
	
}
function combo_maindocKeyenterhandler()
{
  var obj=combo_maindoc;
  var MainDocDR=obj.getActualValue();
  document.getElementById("MainDocDR").value=MainDocDR;
}
function combo_assiantdocKeyenterhandler()
{
	
}
function combo_assiantdocKeydownhandler()
{
  var obj=combo_assiantdoc;
  var OptionDocDR=obj.getActualValue();
  document.getElementById("OptionDocDR").value=OptionDocDR;
}

function FunModiPin()
{
	var NameHz=document.getElementById("Name").value;
   	var NamePinYin=document.getElementById("NamePY").value;
   	var SetPinFunction=document.getElementById("SetPin").value;
  	var Ret=cspRunServerMethod(SetPinFunction,NameHz,NamePinYin);
	if (Ret!="0")
	{
		alert(t["sucess"]);
	}
	

	
}

function GetPin()
{
	var PinYin="";
    var NameHz=document.getElementById("Name").value;
    var NameLen=NameHz.length;
    var GeNamePinF=document.getElementById("GeNamePin").value;

    for (i=0;i<NameLen;i++)
    {
	    perChar=NameHz.charAt(i);
	    var perPinyin=cspRunServerMethod(GeNamePinF,perChar);
	    if (perPinyin=="")
	    {
		    perPinyin=gHztoPyobj1.topin(perChar);
		}
		if (PinYin=="")
		{
          PinYin=perPinyin;
		}
		else
		{
		   PinYin=PinYin+" "+perPinyin;
		}
    }
	document.getElementById("NamePY").value=PinYin;
}


function  createCallfile(PatientName,StudyNo,GetIndex,Room,Type)
{
	//标志,检查号,排队号,姓名,诊室,号别
	var fso, tf,CallInfo,TypeDesc;
	var strCallFilePath="C:\\";
	var strCallFilePath = strCallFilePath+StudyNo+".txt";
	fso = new ActiveXObject("Scripting.FileSystemObject");
	tf = fso.CreateTextFile(strCallFilePath, true);
	if (Type=="E")
	{
		TypeDesc="急诊";
		
	}
	else if(Type=="I")
	{
		TypeDesc="住院";
	}
	else
	{
		TypeDesc="门诊";
	}
	CallInfo="0,"+StudyNo+","+GetIndex+","+PatientName+","+Room+","+TypeDesc;
	alert(CallInfo);
	tf.Write(CallInfo);
	tf.Close();
}