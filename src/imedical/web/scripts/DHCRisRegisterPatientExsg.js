//DHCRisRegisterPatientEx.js
var gHL7Obj;
var gprintOBj;
var gHztoPyobj;
var gCommInfo;
var gNodr;
var gIsUpdate,gUpdateNo;
var gPrintTemplate=""; //print template 
var gSelectNameHZ;

document.body.onload = BodyLoadHandler;


function BodyLoadHandler()
{
	gIsUpdate="0";
	gUpdateNo="0";
     
	var regObj=document.getElementById("Register");
	if (regObj)
	{
		regObj.onclick=Reg_click;
	}
    
    var PrintObj=document.getElementById("Print");
	if (PrintObj)
	{
		PrintObj.onclick=Print_click1;
	}

	
	var DeletePartOBJ=document.getElementById("DeletePart");
	if (DeletePartOBJ)
	{
		DeletePartOBJ.onclick=Delete_click;
	}
	
 	var oeorditemrowid=document.getElementById("OeorditemID").value;
 	var locdr=document.getElementById("LocDR").value;
	var paadmdr=document.getElementById("PaadmDR").value;
	
	var InputRegDateObj=document.getElementById("InputRegDate");
	if (InputRegDateObj)
	{
	  InputRegDateObj.value=DateDemo();
	  InputRegDateObj.onchange=SelectDate;
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
		ckTodayObj.checked=false;
	}
 	ConnectHL7Server();

	
	 IniHZtoPYObj();
     
     GetSelRegInfo();
	 GetStudyNo(oeorditemrowid);
   
     GetNo();
		
	 GetIndex();

    //get last select info
    GetLastSelInfo();
	
	//alert("aa");
	//////IniPrintObj();
  
	
	GetLocRegTemplate();
	
	var ModiPinOBJ=document.getElementById("ModiPin");
    if (ModiPinOBJ)
    {
	    ModiPinOBJ.onclick=FunModiPin;
	}

	
	
	
}
function SelectDate()
{
	var oeorditemrowid=document.getElementById("OeorditemID").value;
 	 GetStudyNo(oeorditemrowid);
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
	         	
         	var ExecutedateObj=document.getElementById("InputRegDate");
			ExecutedateObj.value=DateDemo();
			SelectDate();
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

	   	
         	var ExecutedateObj=document.getElementById("InputRegDate");
			ExecutedateObj.value=getRelaDate(1);
			SelectDate();
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

		        var ExecutedateObj=document.getElementById("InputRegDate");
				ExecutedateObj.value=getRelaDate(2);
				SelectDate();
	    }
	         	
    }

}



function GetLastSelInfo()
{
    var GetFunction=document.getElementById("GetSession").value;
	var Info=cspRunServerMethod(GetFunction,"LastSel");
	var Item=Info.split("^");
	if ((document.getElementById("DeviceDR").value=="")&&(Info!=""))
	{
		document.getElementById("DeviceDR").value=Item[1];
		var GetEQPrintTemplateFun=document.getElementById("GetPrintTemplate").value;
		var PrintTemplate=cspRunServerMethod(GetEQPrintTemplateFun,Item[1]);
		if (PrintTemplate!="") gPrintTemplate=PrintTemplate;
		
		document.getElementById("Device").value=Item[0];
    	document.getElementById("EQGroup").value=Item[2];
    	document.getElementById("EQGroupDR").value=Item[3];
    	document.getElementById("Room").value=Item[4];
		document.getElementById("RoomDR").value=Item[5];
		//document.getElementById("MainDoc").value=Item[6];
		//document.getElementById("MainDocDR").value=Item[7];
	//	document.getElementById("OptionDoc").value=Item[8];
	//	document.getElementById("OptionDocDR").value=Item[9];
		
		var oeorditemrowid=document.getElementById("OeorditemID").value;
		GetStudyNo(oeorditemrowid);

	}
}

function GetStudyNo(oeorditemrowid)
{
	   //var oeorditemrowid=document.getElementById("OeorditemID").value;
       var locdr=document.getElementById("LocDR").value;

       var EQGroupDesc=document.getElementById("EQGroup").value;

  	   var GetStudynoFunction=document.getElementById("GetStudyNoFun").value;
  	   var GetSelectDate=document.getElementById("InputRegDate").value;
  		//GetStudyNo(orditmrowid, EQGoup, LocDr)
     	var Studyinfo=cspRunServerMethod(GetStudynoFunction,oeorditemrowid,EQGroupDesc,locdr,GetSelectDate);	
     	//alert(Studyinfo);
     	var StudyItem=Studyinfo.split("^");
     	document.getElementById("StudyNo").value=StudyItem[0]+StudyItem[1];
     	document.getElementById("StudyNumber").value=StudyItem[1];
     	//alert(StudyItem[1]);
     	if (StudyItem[2]=="1")
     	{
	     	gIsUpdate="1";
	    }
     	else
     	{
	     	gIsUpdate="0";
     	}
     	
}

function GetNo()
{
  var oeorditemrowid=document.getElementById("OeorditemID").value;
  var locdr=document.getElementById("LocDR").value;
  var EQGroupDesc=document.getElementById("EQGroup").value;
  var GetNOFunction=document.getElementById("GetNoFun").value;
  var NoInfo=cspRunServerMethod(GetNOFunction,oeorditemrowid,EQGroupDesc,locdr);
  var NOItem=NoInfo.split("^");
  document.getElementById("NO").value=NOItem[0]+NOItem[1];
  document.getElementById("NoNumber").value=NOItem[1];
  if (NOItem[2]=="1")
  {
   	gUpdateNo="1";
  }
  else
  {
   	gUpdateNo="0";
  }
}

function GetIndex()
{
   var locdr=document.getElementById("LocDR").value;
   var GetIndexFunction=document.getElementById("GetIndexFunction").value;
   var Index=cspRunServerMethod(GetIndexFunction,locdr);	
   document.getElementById("GetIndex").value=Index;
}

//get location register print template
function GetLocRegTemplate()
{
   var locdr=document.getElementById("LocDR").value;
   var GetRegTempFunction=document.getElementById("GetLocPrintTemp").value;
   gPrintTemplate=cspRunServerMethod(GetRegTempFunction,locdr);	
}

function GetSelRegInfo()
{
	var Pinyin;
	var oeorditemrowid=document.getElementById("OeorditemID").value;
	var paadmdr=document.getElementById("PaadmDR").value;
	var GetSelRegInfoFunction=document.getElementById("GetSelRegInfo").value;
    var RegInfo=cspRunServerMethod(GetSelRegInfoFunction,oeorditemrowid,paadmdr);
  	var tem1=RegInfo.split("^");
    //document.getElementById("Name").value=gHztoPyobj.topin(tem1[0]);
    gSelectNameHZ=tem1[0];
    document.getElementById("Name").value=GetPin(tem1[0]);
    document.getElementById("DOB").value=tem1[1];
    document.getElementById("Weight").value=tem1[2];
    document.getElementById("IPNO").value=tem1[4];
	document.getElementById("TELNO").value=tem1[3];
	;document.getElementById("RegDate").value=tem1[5];
	;document.getElementById("RegTime").value=tem1[6];
	document.getElementById("GetIndex").value=tem1[7];
	document.getElementById("Device").value=tem1[8];
	document.getElementById("DeviceDR").value=tem1[9];

	var GetEQPrintTemplateFun=document.getElementById("GetPrintTemplate").value;
	var PrintTemplate=cspRunServerMethod(GetEQPrintTemplateFun,tem1[9]);
	if (PrintTemplate!="") gPrintTemplate=PrintTemplate;
	

	document.getElementById("MainDoc").value=tem1[10];
	document.getElementById("MainDocDR").value=tem1[11];
	document.getElementById("OptionDoc").value=tem1[12];
	document.getElementById("OptionDocDR").value=tem1[13];
	document.getElementById("Room").value=tem1[14];
	document.getElementById("RoomDR").value=tem1[15];
	document.getElementById("EQGroup").value=tem1[16];
	document.getElementById("EQGroupDR").value=tem1[17];
	document.getElementById("NO").value=tem1[18];
	if (tem1[21]=="Y")
	{
		document.getElementById("ReportInfo").checked=true;
	}
	else
	{
	     document.getElementById("ReportInfo").checked=false;
	}
	//Type_"^"_LocName_"^"_OPNO_"^"_BedCode
	document.getElementById("PatientType").value=tem1[22];
	document.getElementById("InLoc").value=tem1[23];
	document.getElementById("OPNO").value=tem1[24];
	document.getElementById("BedCode").value=tem1[25];
	document.getElementById("PrintName").value=tem1[26];

 	var bodyinfo1=tem1[19];
 	var Nums=tem1[20];
 	var tem2=bodyinfo1.split("~");
  	var BodyList=document.getElementById('BodyList'); 
	for (i=0;i<Nums;i++)
	{
		var Index=BodyList.options.length;
		var BodyInfo=tem2[i].split(":");
		var objSelected = new Option(BodyInfo[1],BodyInfo[0]);
		BodyList.options[Index]=objSelected;
	}
	if(tem1[27]!="")
	{
		document.getElementById("InputRegDate").value=tem1[27];
	}
	
	
}
function SelBodyPart(Info)
{
	BodyParttem=Info.split("^");
	var bodypartlist=document.getElementById('BodyList'); 
	var Index =bodypartlist.options.length ;
	
	for (i=0;i<Index;i++)
	{
		if (bodypartlist[i].text==BodyParttem[0]) return;
	}
	var objSelected = new Option(BodyParttem[0], BodyParttem[1]);
	bodypartlist.options[Index]=objSelected;
		
	
}


function Delete_click()
{
	var bodypartlist=document.getElementById('BodyList'); 
	var nIndex=bodypartlist.selectedIndex;
	if (nIndex==-1) return;
	bodypartlist.options[nIndex]=null;
}

function ConnectHL7Server()
{
	if (!gHL7Obj)
		gHL7Obj = new ActiveXObject("HL7Com.CHL7");	
	//HL7Obj.ConnectHL7Server("192.168.2.239","1041");
    gHL7Obj.ConnectHL7Server1();
	
	//gHL7Obj.HZConvertPin(str);

    
	
}
function IniPrintObj()
{
	if (!gprintOBj)
		gprintOBj=new ActiveXObject("RISPrint.CPrintExamItem")
		
}

function IniHZtoPYObj()
{
	if (!gHztoPyobj)
	{
		//alert("sucess");
		gHztoPyobj=new ActiveXObject("Phztopin.CHZtoPin");
		
		
	}
}

// select equipment group (jian cha shi )
function GetEQGroup(EQGroupInfo)
{
  var Item=EQGroupInfo.split("^");
  document.getElementById("EQGroup").value=Item[0];
  document.getElementById("EQGroupDR").value=Item[1];
}

// select room 
function GetRoom(RoomInfo)
{
  //roomrowid,roomcode,roomname
  Item=RoomInfo.split("^");
  document.getElementById("Room").value=Item[2];
  document.getElementById("RoomDR").value=Item[0];
}


// select register equipment 
function GetRegEQInfo(Info)
{
	var Item=Info.split("^");
    document.getElementById("DeviceDR").value=Item[0];
	document.getElementById("Device").value=Item[2];
	var locdr=document.getElementById("LocDR").value;
	var GetEQPrintTemplateFun=document.getElementById("GetPrintTemplate").value;
	var PrintTemplate=cspRunServerMethod(GetEQPrintTemplateFun,Item[0]);
	if (PrintTemplate!="") gPrintTemplate=PrintTemplate;
	//alert("gPrintTemplate"+gPrintTemplate);
	
	var GetFunction=document.getElementById("GetGroupRoom").value;
	var Info=cspRunServerMethod(GetFunction,Item[2],locdr);
	var Item1=Info.split("^");
	document.getElementById("EQGroup").value=Item1[0];
    document.getElementById("EQGroupDR").value=Item1[1];
    document.getElementById("Room").value=Item1[2];
	document.getElementById("RoomDR").value=Item1[3];
	
	var oeorditemrowid=document.getElementById("OeorditemID").value;

	GetStudyNo(oeorditemrowid);
    GetNo();

	//she zhi Session 
	 
   	//EQDR,EQCode,EQDesc
}

//select report verified doctor
function GetMainDoc(Info)
{
	Item=Info.split("^");
	document.getElementById("MainDoc").value=Item[0];
	document.getElementById("MainDocDR").value=Item[1];
}

//select report verified doctor
function GetAssDoc(Info)
{
	Item=Info.split("^");
	document.getElementById("OptionDoc").value=Item[0];
	document.getElementById("OptionDocDR").value=Item[1];
 	
}



function Reg_click()
{
	var regEQ=document.getElementById("Device").value;
	if (regEQ=="")
	{
		var Ans=confirm(t['HaventInput'])
		if (Ans==true) {return false;}
	}
	var orddoc=parent.frames["DHCRisWorkBench"].document;
  	var ordtab=orddoc.getElementById("tDHCRisWorkBenchEx");
  	var OEOrdItemID ="";
  	var paadmdr="",paadmtype
  	var num=0;
  	var LastRegNo="";
  	var ReportInfo="";
 	
  	if (ordtab) 
  	{
	  //can not selected many people 	
	  var GetRegNo="";
	  var SelCount=0;
	  var IsAppReg=true;
      for (var i=1; i<ordtab.rows.length; i++)
      {
        var selectedobj=orddoc.getElementById("TSelectedz"+i);
        if ((selectedobj)&&(selectedobj.checked))
        {
	         GetRegNo=orddoc.getElementById("PatientIDz"+i).innerText;
	         if ((LastRegNo!="")&&(LastRegNo!=GetRegNo))
	         {
		        alert(t['NotSamePatient']);
		        return false;
		     }
		     else
		     {
			     LastRegNo=GetRegNo;
		     }
		     PatientStatusCode=orddoc.getElementById("OEORIItemStatusz"+i).value;
     	     if ((PatientStatusCode!="A")&&(PatientStatusCode!="B")&&(PatientStatusCode!="I"))
		     {
			     IsAppReg=false;  
		     }
		     SelCount=SelCount+1
        }
      }
      //
      if ((IsAppReg==false)&&(SelCount>1))
      {
	      alert(t['StatusNotReg']);
	      return  false;
      }
      
      var No=document.getElementById("NO").value;
      var EQGroupDR=document.getElementById("EQGroupDR").value;
	  var locdr=document.getElementById("LocDR").value;
	  var paadmdr=document.getElementById("PaadmDR").value;
	  var weight=document.getElementById("Weight").value;
	  var RegDate=""; //document.getElementById("RegDate").value;
	  var RegTime=""; //document.getElementById("RegTime").value;
	  var GetIndex=document.getElementById("GetIndex").value;
	  if (document.getElementById("Device").value=="")
	  {
		  document.getElementById("DeviceDR").value="";
	  }
	  var EQDR=document.getElementById("DeviceDR").value;
	  if (document.getElementById("Room").value=="")
	  {
		 document.getElementById("RoomDR").value="";
	  }
	  var RoomDR=document.getElementById("RoomDR").value;
	  if (document.getElementById("MainDoc").value=="")
	  {
		  document.getElementById("MainDocDR").value="";
	  }
	  var MainDocDR=document.getElementById("MainDocDR").value;
	  if (document.getElementById("OptionDoc").value=="")
	  {
		  document.getElementById("OptionDocDR").value="";
	  }
	  var AssiantDocDR=document.getElementById("OptionDocDR").value;
	  var INPNO=document.getElementById("IPNO").value;
	  var TelNo=document.getElementById("TELNO").value;
	  var userid=session['LOGON.USERID'];
	  var StudyNo=document.getElementById("StudyNo").value;
      var oeorditemrowid=document.getElementById("OeorditemID").value;
      //if No Is Not Null ,Update No of people
      var Nodr=""
      if (No!="")
      {
	    var UpdateNoFunction=document.getElementById("UpdateNo").value;
	    Nodr=cspRunServerMethod(UpdateNoFunction,No,paadmdr,locdr,EQGroupDR);
   	  }

      var SelCount=0;
      var Age;      
      for (var i=1; i<ordtab.rows.length; i++)
      {
        var selectedobj=orddoc.getElementById("TSelectedz"+i);
        if ((selectedobj)&&(selectedobj.checked))
        {
	       var WrieReport=document.getElementById("ReportInfo").checked;
	       ReportInfo="";
	       if (WrieReport)
	       {
		      ReportInfo="Y";
	       }
	       var bodypartlist=document.getElementById('BodyList'); 
		   glen =bodypartlist.options.length ;
		   gbodyinfo="";
		   for (j=0;j<glen;j++)
		   { 
		   	  gbodyinfo+=bodypartlist[j].value+"^";
		   }
		   var oeorditemrowid=orddoc.getElementById("OEOrdItemIDz"+i).value; 
		   var PatientName=orddoc.getElementById("TPatientNamez"+i).innerText;
	       var PatientID=orddoc.getElementById("PatientIDz"+i).innerText;
	       var Sex=orddoc.getElementById("TSexz"+i).innerText;
	       var DOB=orddoc.getElementById("TDOBz"+i).innerText;
	       Age=orddoc.getElementById("TAgez"+i).innerText;
	       var InputDate=document.getElementById("InputRegDate").value;
       	   var Getsertinfo=document.getElementById("InsertInfo").value;
       	   gCommInfo=AssiantDocDR+"^"+MainDocDR+"^"+Nodr+"^"+oeorditemrowid+"^"+paadmdr+"^"+EQDR+"^"+locdr+"^"+userid+"^"+StudyNo+"^"+GetIndex+"^"+RoomDR+"^"+EQGroupDR+"^"+RegDate+"^"+RegTime+"^"+INPNO+"^"+TelNo+"^"+weight+"^"+ReportInfo+"^"+InputDate;
	       var ret=cspRunServerMethod(Getsertinfo,gCommInfo,glen,gbodyinfo);
	       //alert(ret);
	       if (ret=="-2000")
		   {
			   alert(t['CheckFeeNotEnough']);
			   document.location.reload();
			   return false;
		   }
		   if (ret=="-10001")
		   {
			   alert(t['CantReg']);
			   document.location.reload();
			   return false;
	       }
	   	   if (ret!="0")
		   {
			   alert(t['regFailure']);
			   document.location.reload();
			   return false;
		   }
		   SelCount=SelCount+1;
       }
      }
      
     var SelectDate=document.getElementById("InputRegDate").value;
      
      if (gIsUpdate=="1")
      {
	       var StudyNumber=document.getElementById("StudyNumber").value;
	       var UpdateNoFunction=document.getElementById("UpdateStudyNo").value;
		   var ret=cspRunServerMethod(UpdateNoFunction,locdr,EQGroupDR,StudyNumber,SelectDate);
      }
      /*
       else if (gUpdateNo=="1")
      {
	       var StudyNumber=document.getElementById("NoNumber").value;
	       var UpdateNoFunction=document.getElementById("UpdateStudyNo").value;
	       var ret=cspRunServerMethod(UpdateNoFunction,locdr,EQGroupDR,StudyNumber,SelectDate);
	  }
	  */
  	}
 
  	
  	if (SelCount>0)
  	{
		var MainDoc=document.getElementById("MainDoc").value;
    	var regEQ=document.getElementById("Device").value;
		var StudyNo=document.getElementById("StudyNo").value;
    	var ItemName=""; //document.getElementById("ItemName").value;
    
    	var bodypartlist=document.getElementById('BodyList'); 
    	var len =bodypartlist.options.length ;
    	var bodyinfo="";
    	for (j=0;j<len;j++)
    	{ 
			if (bodyinfo!="")
			  bodyinfo=bodyinfo+","+bodypartlist[j].text;
			else
	      	  bodyinfo=bodypartlist[j].text;
    	}
		var GetSupptWorkListFun1=document.getElementById("GetSupptWorkListFun").value;
		var Support=cspRunServerMethod(GetSupptWorkListFun1,regEQ,locdr);
		var SendInfo=PatientID+"^"+PatientName+"^"+DOB+"^"+Sex+"^"+StudyNo+"^"+weight+"^"+bodyinfo+"^"+regEQ
	  	var PatientName1=document.getElementById("Name").value;
	   	 
	  	if ((gHL7Obj)&&(Support=="Y"))
		{
			 var Item3=DOB.split("/");
			 DOB=Item3[2]+"-"+Item3[1]+"-"+Item3[0]
       		 gHL7Obj.SendModalityInfo(PatientID,PatientName1,DOB,Sex,StudyNo,"","","","",weight,bodyinfo,regEQ,"NW");
			//print register info
		}
     	var PatientType=document.getElementById("PatientType").value;
		var InLocName=document.getElementById("InLoc").value;
		
		var splits = /-/i;            
     	var pos = InLocName.search(splits); 
        if (pos>0)
        {           
  	        var Item=InLocName.split("-");
		    InLocName=Item[1];
		}
		var OPNO=document.getElementById("OPNO").value;
	    var BedCode=document.getElementById("BedCode").value;
	    var GetPrintItemFun1=document.getElementById("GetPrintItem").value;
	   	var OrdItemName=cspRunServerMethod(GetPrintItemFun1,StudyNo);
	    document.getElementById("PrintName").value=OrdItemName;
	    var Room=document.getElementById("Room").value;
	    
	    var DeviceDR=document.getElementById("DeviceDR").value;
    	var GetEQPrintTemplateFun=document.getElementById("GetPrintTemplate").value;
	    var PrintTemplate=cspRunServerMethod(GetEQPrintTemplateFun,DeviceDR);
	    if (PrintTemplate!="") gPrintTemplate=PrintTemplate;

	    
		/*if (gPrintTemplate=="LiXiang")
		{
			// use Li Xiang bar print 
		   printRegBar(StudyNo,PatientID,PatientName,Age,Sex,PatientType,GetIndex,No,INPNO,OPNO,Room,InLocName,BedCode,OrdItemName,PatientName1);
			
		}
		else if (gPrintTemplate!="")
		{
		   DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemplate);
		   var GetFilmSendDate=document.getElementById("GetFilmDate").value;
		   var SendFilmDate=cspRunServerMethod(GetFilmSendDate);
		   var MyPara="PatientName"+String.fromCharCode(2)+PatientName;
		   MyPara=MyPara+"^RegNo"+String.fromCharCode(2)+PatientID;
		   MyPara=MyPara+"^Sex"+String.fromCharCode(2)+Sex;
		   MyPara=MyPara+"^Age"+String.fromCharCode(2)+Age;
		   MyPara=MyPara+"^MRI"+String.fromCharCode(2)+No;
		   MyPara=MyPara+"^Date"+String.fromCharCode(2)+SendFilmDate;
		   MyPara=MyPara+"^StuyNo"+String.fromCharCode(2)+StudyNo;
		   InvPrintNew(MyPara,"");
		}
		*/
		alert(t['registersuccess']);
		
		/////////////////////////////add for sg 
		OrditemSelected(StudyNo);
	 
    	//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisWorkBenchEx"
   		//alert(lnk);
    	//parent.frames['DHCRisWorkBench'].location.href=lnk; 

    	var DeviceDesc=document.getElementById("Device").value
   		var EQGroupDesc=document.getElementById("EQGroup").value;
    	var RoomDesc=document.getElementById("Room").value;
		var MainDocDesc=document.getElementById("MainDoc").value;
		var OperateDocDesc=document.getElementById("OptionDoc").value;
	
		var SetFunction=document.getElementById("SetSession").value;
		var SelInfo=DeviceDesc+"^"+EQDR+"^"+EQGroupDesc+"^"+EQGroupDR+"^"+RoomDesc+"^"+RoomDR+"^"+MainDocDesc+"^"+MainDocDR+"^"+OperateDocDesc+"^"+AssiantDocDR;
		var ret=cspRunServerMethod(SetFunction,"LastSel",SelInfo); 
  	}
  	else
  	{
	  	alert(t['SelectPatient']);
  	}
}
function printRegBar(StudyNo,PatientNo,PatientName,Age,Sex,type,Index,NoInfo,IpNo,OpNo,Room,PatLoc,BedCode,OrdName,PatNamePY)
{
	var Info=StudyNo+"^"+PatientNo+"^"+PatientName+"^"+Age+"^"+Sex+"^"+type+"^"+Index+"^"+NoInfo+"^"+IpNo+"^"+OpNo+"^"+Room+"^"+PatLoc+"^"+BedCode+"^"+OrdName+"^"+PatNamePY
	//alert(Info);
	
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
    //alert(PatNamePY);
    
    Bar.PrintOutRegBill();
}

function InvPrintNew(TxtInfo,ListInfo)
{
	////
	////DHCP_PrintFun(encmeth,PObj,inpara,inlist)
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
} 


//print regiter 
function Print_click1()
{
	
	var orddoc=parent.frames["DHCRisWorkBench"].document;
  	var ordtab=orddoc.getElementById("tDHCRisWorkBenchEx");
  	var OEOrdItemID ="";
  	var paadmdr="",paadmtype
  	var num=0;
  	var LastRegNo="";
  	var ReportInfo="";
 	
  	if (ordtab) 
  	{
	  //can not selected many people 	
	  var GetRegNo="";
	  var SelCount=0;
	  var IsAppReg=true;
      for (var i=1; i<ordtab.rows.length; i++)
      {
        var selectedobj=orddoc.getElementById("TSelectedz"+i);
        if ((selectedobj)&&(selectedobj.checked))
        {
	         GetRegNo=orddoc.getElementById("PatientIDz"+i).innerText;
	         if ((LastRegNo!="")&&(LastRegNo!=GetRegNo))
	         {
		        alert(t['NotSamePatient']);
		        return false;
		     }
		     else
		     {
			     LastRegNo=GetRegNo;
		     }
		     PatientStatusCode=orddoc.getElementById("OEORIItemStatusz"+i).value;
     	     if ((PatientStatusCode=="A")||(PatientStatusCode=="B"))
		     {
			     IsAppReg=false;  
		     }
		     SelCount=SelCount+1
        }
      }
      //
      if ((IsAppReg==false)&&(SelCount>1))
      {
	      alert(t['StatusNotPrint']);
	      return  false;
      }
      
      var No=document.getElementById("NO").value;
      var EQGroupDR=document.getElementById("EQGroupDR").value;
	  var locdr=document.getElementById("LocDR").value;
	  var paadmdr=document.getElementById("PaadmDR").value;
	  var weight=document.getElementById("Weight").value;
	  var RegDate=document.getElementById("RegDate").value;
	  var RegTime=document.getElementById("RegTime").value;
	  var GetIndex=document.getElementById("GetIndex").value;
	  if (document.getElementById("Device").value=="")
	  {
		  document.getElementById("DeviceDR").value="";
	  }
	  var EQDR=document.getElementById("DeviceDR").value;
	  if (document.getElementById("Room").value=="")
	  {
		 document.getElementById("RoomDR").value="";
	  }
	  var RoomDR=document.getElementById("RoomDR").value;
	  if (document.getElementById("MainDoc").value=="")
	  {
		  document.getElementById("MainDocDR").value="";
	  }
	  var MainDocDR=document.getElementById("MainDocDR").value;
	  if (document.getElementById("OptionDoc").value=="")
	  {
		  document.getElementById("OptionDocDR").value="";
	  }
	  var AssiantDocDR=document.getElementById("OptionDocDR").value;
	  var INPNO=document.getElementById("IPNO").value;
	  var TelNo=document.getElementById("TELNO").value;
	  var userid=session['LOGON.USERID'];
	  var StudyNo=document.getElementById("StudyNo").value;
      var oeorditemrowid=document.getElementById("OeorditemID").value;
      //if No Is Not Null ,Update No of people
    

      var SelCount=0;
      var Age;      
      for (var i=1; i<ordtab.rows.length; i++)
      {
        var selectedobj=orddoc.getElementById("TSelectedz"+i);
        if ((selectedobj)&&(selectedobj.checked))
        {
	       var WrieReport=document.getElementById("ReportInfo").checked;
	       ReportInfo="";
	       if (WrieReport)
	       {
		      ReportInfo="Y";
	       }
	       
	       var oeorditemrowid=orddoc.getElementById("OEOrdItemIDz"+i).value; 
		   var PatientName=orddoc.getElementById("TPatientNamez"+i).innerText;
	       var PatientID=orddoc.getElementById("PatientIDz"+i).innerText;
	       var Sex=orddoc.getElementById("TSexz"+i).innerText;
	       var DOB=orddoc.getElementById("TDOBz"+i).innerText;
	       Age=orddoc.getElementById("TAgez"+i).innerText;
           SelCount=SelCount+1;
       }
      }
    }
  	
  	if (SelCount>0)
  	{
		var MainDoc=document.getElementById("MainDoc").value;
    	var regEQ=document.getElementById("Device").value;
		var StudyNo=document.getElementById("StudyNo").value;
    	var ItemName=""; //document.getElementById("ItemName").value;
    
    	var bodypartlist=document.getElementById('BodyList'); 
    	var len =bodypartlist.options.length ;
    	var bodyinfo="";
    	for (j=0;j<len;j++)
    	{ 
			if (bodyinfo!="")
			  bodyinfo=bodyinfo+","+bodypartlist[j].text;
			else
	      	  bodyinfo=bodypartlist[j].text;
    	}
	
	 	var PatientType=document.getElementById("PatientType").value;
		var InLocName=document.getElementById("InLoc").value;
		
		var splits = /-/i;            
     	var pos = InLocName.search(splits); 
        if (pos>0)
        {           
  	        var Item=InLocName.split("-");
		    InLocName=Item[1];
		}
		var OPNO=document.getElementById("OPNO").value;
	    var BedCode=document.getElementById("BedCode").value;
	    var GetPrintItemFun1=document.getElementById("GetPrintItem").value;
	   	var OrdItemName=cspRunServerMethod(GetPrintItemFun1,StudyNo);
	    document.getElementById("PrintName").value=OrdItemName;
	    var Room=document.getElementById("Room").value;
	    
	    var DeviceDR=document.getElementById("DeviceDR").value;
    	var GetEQPrintTemplateFun=document.getElementById("GetPrintTemplate").value;
	    var PrintTemplate=cspRunServerMethod(GetEQPrintTemplateFun,DeviceDR);
	    if (PrintTemplate!="") gPrintTemplate=PrintTemplate;
	   	var PatientName1=document.getElementById("Name").value;
	  

	    //alert(gPrintTemplate);
	    //var Info=StudyNo+PatientID+PatientName+Age+Sex+PatientType+GetIndex+No+INPNO+OPNO+Room+InLocName+BedCode+OrdItemName+PatientName1;
		//alert(Info);

		if (gPrintTemplate=="LiXiang")
		{
			// use Li Xiang bar print 
		    printRegBar(StudyNo,PatientID,PatientName,Age,Sex,PatientType,GetIndex,No,INPNO,OPNO,Room,InLocName,BedCode,OrdItemName,PatientName1);
			
		}
		else if (gPrintTemplate!="")
		{
		 
		   DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemplate);
		   var GetFilmSendDate=document.getElementById("GetFilmDate").value;
		   var SendFilmDate=cspRunServerMethod(GetFilmSendDate);
		   var MyPara="PatientName"+String.fromCharCode(2)+PatientName;
		   MyPara=MyPara+"^RegNo"+String.fromCharCode(2)+PatientID;
		   MyPara=MyPara+"^Sex"+String.fromCharCode(2)+Sex;
		   MyPara=MyPara+"^Age"+String.fromCharCode(2)+Age;
		   MyPara=MyPara+"^MRI"+String.fromCharCode(2)+No;
		   MyPara=MyPara+"^Date"+String.fromCharCode(2)+SendFilmDate;
		   MyPara=MyPara+"^StuyNo"+String.fromCharCode(2)+StudyNo;
		   InvPrintNew(MyPara,"");
		}
	}
  	else
  	{
	  	alert(t['SelectPatient']);
  	}
}
function OrditemSelected(StudyNo)
{
	orddoc=parent.frames["DHCRisWorkBench"].document;
    var objtbl=orddoc.getElementById('tDHCRisWorkBenchEx');
    var rows=objtbl.rows.length;
    for (i=1;i<rows;i++)
    {
	   var selectedobj=orddoc.getElementById("TSelectedz"+i);
	   if (selectedobj.checked)
	   {
          orddoc.getElementById("TStatusz"+i).innerText=t["RegStatus"];
          orddoc.getElementById("OEORIItemStatusz"+i).value="I";
          orddoc.getElementById("TStudyNoz"+i).innerText=StudyNo;
	   }
    }
}


function FunModiPin()
{
   	var NamePinYin=document.getElementById("Name").value;
   	var SetPinFunction=document.getElementById("SetPin").value;
  	var Ret=cspRunServerMethod(SetPinFunction,gSelectNameHZ,NamePinYin);
	if (Ret!="0")
	{
		alert(t["sucess"]);
	}
}

function GetPin(NameHz)
{
	var PinYin="";
    var NameLen=NameHz.length;
    var GeNamePinF=document.getElementById("GeNamePin").value;

    for (i=0;i<NameLen;i++)
    {
	    perChar=NameHz.charAt(i);
	    var perPinyin=cspRunServerMethod(GeNamePinF,perChar);
	    if (perPinyin=="")
	    {
		    perPinyin=gHztoPyobj.topin(perChar);
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
	return PinYin;
}