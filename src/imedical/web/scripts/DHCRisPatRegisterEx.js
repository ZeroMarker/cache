//DHCRisPatRegisterEx.js
document.write("<OBJECT ID='PrnBar' CLASSID='CLSID:4996FF7D-F0BB-4BB4-B3DA-B7063234A748' CODEBASE='../addins/client/PrintRegBar.CAB#version=1,0,0,29'>");
document.write("</object>");

var gHL7Obj,gprintOBj,gHztoPyobj;
var gCommInfo,gNodr;
var gIsUpdate,gUpdateNo;
var gPrintTemplate=""; //print template 
var gBookedPrintTemplate="";
var gSelectNameHZ,gCallObj; 
var DBBookedFlag="",IsPrint="",gIsBFlag="",gIsRegBFlag="";
var gBookResource,gBookDate,gBookTime;
var MutiStudyNo="";

function BodyLoadHandler()
{

	gIsUpdate="0";
	gUpdateNo="0";
	
    var locdr=$("LocDR").value;
	var paadmdr=$("PaadmDR").value;
	

	var oeorditemrowid;
	var OeorditemIDObj=$("OeorditemID");
	if (OeorditemIDObj)
	{
		oeorditemrowid=OeorditemIDObj.value;
	}
	
	GetSchudle();
	
	gIsBFlag=HasBooked();
	
	SetSelResources();	
	
	GetSelRegInfo();
	
   	GetStudyNo(oeorditemrowid);
    
    GetNo();

    //get last select info
    GetLastSelInfo();
    
	GetLocRegTemplate();
	
	GetLocBookedPrintTemplate();

	var IndexObj=$("Index");
	if (IndexObj)
	{
	   if (IndexObj.value=="")
	   {
	  	    GetIndex();
	   }
	}
	
	var regObj=$("Register");
	if (regObj)
	{
		regObj.onclick=Reg_click;
	}
    
    var PrintObj=$("Print");
	if (PrintObj)
	{
		PrintObj.onclick=Print_click1;
	}

	var DeletePartOBJ=$("DeletePart");
	if (DeletePartOBJ)
	{
		DeletePartOBJ.onclick=Delete_click;
	}
	

	var ModiPinOBJ=$("ModiPin");
    if (ModiPinOBJ)
    {
	    ModiPinOBJ.onclick=FunModiPin;
	}
	
	var BookingObj=$("Booking");
	if (BookingObj)
	{
		BookingObj.onclick=Booking_click;
	}
	
	var BookedObj=$("BookedPrint");
	if ( BookedObj)
	{
		 BookedObj.onclick= BookedObj_click;
	}
	
	$("IsPrint").checked=true;

}


function GetLastSelInfo()
{
    var GetFunction=$("GetSession").value;
	var Info=cspRunServerMethod(GetFunction,"LastSel");
	var Item=Info.split("^");
	if (($("DeviceDR").value=="")&&(Info!=""))
	{
		if (Item[1]!="")
		{
			$("DeviceDR").value=Item[1];
			var GetEQPrintTemplateFun=$("GetPrintTemplate").value;
			var PrintTemplate=cspRunServerMethod(GetEQPrintTemplateFun,Item[1]);
			if (PrintTemplate!="") gPrintTemplate=PrintTemplate;
			$("Device").value=Item[0];
	    	$("EQGroup").value=Item[2];
	    	$("EQGroupDR").value=Item[3];
	    	$("Room").value=Item[4];
			$("RoomDR").value=Item[5];
		}
		$("MainDoc").value=Item[6];
		$("MainDocDR").value=Item[7];
		$("OptionDoc").value=Item[8];
		$("OptionDocDR").value=Item[9];
		
		var oeorditemrowid=$("OeorditemID").value;
		GetStudyNo(oeorditemrowid);

	}
}

function GetStudyNo(oeorditemrowid)
{
	   //var oeorditemrowid=$("OeorditemID").value;
       var locdr=$("LocDR").value;
       var EQGroupDesc=$("EQGroup").value;

  	   var GetStudynoFunction=$("GetStudyNoFun").value;
  	   var GetSelectDate=$("SelRegDate").value; 
  		//GetStudyNo(orditmrowid, EQGoup, LocDr)
     	var Studyinfo=cspRunServerMethod(GetStudynoFunction,oeorditemrowid,EQGroupDesc,locdr,GetSelectDate);	
     	//alert(Studyinfo);
     	var StudyItem=Studyinfo.split("^");
     	$("StudyNo").value=StudyItem[0]+StudyItem[1];
     	$("StudyNumber").value=StudyItem[1];
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
  var oeorditemrowid=$("OeorditemID").value;
  var locdr=$("LocDR").value;
  var EQGroupDesc=$("EQGroup").value;
  var GetNOFunction=$("GetNoFun").value;
  var NoInfo=cspRunServerMethod(GetNOFunction,oeorditemrowid,EQGroupDesc,locdr);
  var NOItem=NoInfo.split("^");
  $("NO").value=NOItem[0]+NOItem[1];
  $("NoNumber").value=NOItem[1];
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
	var EqDR=$("DeviceDR").value;
	var RoomDR=$("RoomDR").value;	
	var EQGroupDR=$("EQGroupDR").value;
    var locDR=$("LocDR").value;
    var OeorditemDR=$("OeorditemID").value;
    var SchudleDR=$("ResSchudleDR").value;
    var InputRegDate=$("SelRegDate").value;
     
    var Param=EqDR+"^"+EQGroupDR+"^"+RoomDR+"^"+locDR+"^"+OeorditemDR+"^"+SchudleDR+"^"+InputRegDate
    
    var GetIndexFun=document.getElementById("GetIndexFunction").value;
    var Info=cspRunServerMethod(GetIndexFun,Param);
  
    if (Info!="")
    {
	    var tmp=Info.split("^");
	    var Index=tmp[0];
	    var NoRuleCode=tmp[1];
	    var NoTypeDesc=tmp[2];
	    var NoTypeCode=tmp[3];
	    var NoTypeID=tmp[4];
	    
	    if (NoRuleCode=="L")
	    { 
	        $("GetIndex").value=Index;
		}
		else if(NoRuleCode=="Z")
		{
			$("GroupIndex").value=Index;
		}
		else if (NoRuleCode=="R")
		{
			$("RoomIndex").value=Index;
		}
		
		$("Index").value=Index;
		$("IndexCode").value=NoTypeCode;
		$("IndexType").value=NoTypeDesc;
		$("IndexTypeID").value=NoTypeID;
	    
	}
  
        
}



//get location register print template
function GetLocRegTemplate()
{
   var locdr=$("LocDR").value;
   var GetRegTempFunction=$("GetLocPrintTemp").value;
   gPrintTemplate=cspRunServerMethod(GetRegTempFunction,locdr);	
}

function GetSelRegInfo()
{
	var Pinyin;
	var oeorditemrowid=$("OeorditemID").value;
	//alert(oeorditemrowid);
	var paadmdr=$("PaadmDR").value;
	
	var GetSelRegInfoFunction=$("GetSelRegInfo").value;
    var RegInfo=cspRunServerMethod(GetSelRegInfoFunction,oeorditemrowid,paadmdr);
   	var tem1=RegInfo.split("^");
  	gSelectNameHZ=tem1[0];
  
    var GetHZPinFunction=$("HZtoPin").value;
    var Pin=cspRunServerMethod(GetHZPinFunction,gSelectNameHZ);
    $("Name").value=Pin;

   //$("Name").value=gHztoPyobj.topin(tem1[0]);
    $("DOB").value=tem1[1];
    $("Weight").value=tem1[2];
    $("IPNO").value=tem1[4];
	$("TELNO").value=tem1[3];
	$("RegDate").value=tem1[5];
	$("RegTime").value=tem1[6];
	$("GetIndex").value=tem1[7];
	if (tem1[7]!="")
	{
		$("Index").value=tem1[7]
	}
	if (tem1[8]!="")
	{
		$("Device").value=tem1[8];
		$("DeviceDR").value=tem1[9];
		var GetEQPrintTemplateFun=$("GetPrintTemplate").value;
		var PrintTemplate=cspRunServerMethod(GetEQPrintTemplateFun,tem1[9]);
		if (PrintTemplate!="") gPrintTemplate=PrintTemplate;
		$("Room").value=tem1[14];
		$("RoomDR").value=tem1[15];
		$("EQGroup").value=tem1[16];
		$("EQGroupDR").value=tem1[17];
	}	

	$("MainDoc").value=tem1[10];
	$("MainDocDR").value=tem1[11];
	$("OptionDoc").value=tem1[12];
	$("OptionDocDR").value=tem1[13];
	$("NO").value=tem1[18];
	
	/*if (tem1[21]=="Y")
	{
		$("ReportInfo").checked=true;
	}
	else
	{
	    $("ReportInfo").checked=false;
	}*/
	
	//Type_"^"_LocName_"^"_OPNO_"^"_BedCode
	$("PatientType").value=tem1[22];
	$("InLoc").value=tem1[23];
	$("OPNO").value=tem1[24];
	$("BedCode").value=tem1[25];
	$("PrintName").value=tem1[26];
    
   
 	var bodyinfo1=tem1[19];
 	var Nums=tem1[20];
 	var tem2=bodyinfo1.split("~");
  	var BodyList=$("BodyList"); 
	for (i=0;i<Nums;i++)
	{
		var Index=BodyList.options.length;
		var BodyInfo=tem2[i].split(":");
		var objSelected = new Option(BodyInfo[1],BodyInfo[0]);
		BodyList.options[Index]=objSelected;
	}
	
	/*if(tem1[27]!="")
	{
		$("InputRegDate").value=tem1[27];
	}*/
	$("GroupIndex").value=tem1[28];
	if (tem1[28]!="")
	{
		$("Index").value=tem1[28];
	}
    
	$("RoomIndex").value=tem1[29];
	if (tem1[29]!="")
	{
		$("Index").value=tem1[29];
	} 
	
	var UgentObj=$("Urgent");
	if (UgentObj)
	{
		if (tem1[30]=="Y")
		{
			UgentObj.checked=true;
		}
		else
		{
			UgentObj.checked=false;
			
		}
		
	}
	$("IndexType").value=tem1[31];
	
}

function SelBodyPart(Info)
{
	BodyParttem=Info.split("^");
	var bodypartlist=$("BodyList"); 
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
	var bodypartlist=$("BodyList"); 
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
   $("EQGroup").value=Item[0];
   $("EQGroupDR").value=Item[1];
}

// select room 
function GetRoom(RoomInfo)
{
  //roomrowid,roomcode,roomname
  Item=RoomInfo.split("^");
  $("Room").value=Item[2];
  $("RoomDR").value=Item[0];
}



//select report verified doctor
function GetMainDoc(Info)
{
	Item=Info.split("^");
	$("MainDoc").value=Item[0];
	$("MainDocDR").value=Item[1];
}

//select report verified doctor
function GetAssDoc(Info)
{
	Item=Info.split("^");
	$("OptionDoc").value=Item[0];
	$("OptionDocDR").value=Item[1];
 	
}



function Reg_click()
{
	if (gIsBFlag!="Y")
	{
	  gIsRegBFlag="Y";
	  Booking_click();
	}
	
	var OEOrdItemID ="";
  	var paadmdr="",paadmtype
  	var num=0;
  	var LastRegNo="";
  	var ReportInfo="";
  	var GroupIndex,RoomIndex;
    var HISRegNo="";
    var LastRecLocDR="";
    
	var regEQ=$("Device").value;
	if (regEQ=="")
	{
		var Ans=confirm(t["HaventInput"])
		if (Ans==true) {return false;}
	}
	
	var orddoc=parent.parent.parent.frames["DHCRisWorkBench"].document;
  	var ordtab=orddoc.getElementById("tDHCRisWorkBenchEx");
  	
  
  	if (ordtab) 
  	{
	   //can not selected many people 	
	   var GetRegNo="";
	   var GetRecLocDR=""
	   var SelCount=0;
	   var IsAppReg=true;
	   
       for (var i=1; i<ordtab.rows.length; i++)
       {
         var selectedobj=orddoc.getElementById("TSelectedz"+i);
         
         if ((selectedobj)&&(selectedobj.checked))
         {
	         GetRegNo=orddoc.getElementById("PatientIDz"+i).innerText;
	         GetRecLocDR=orddoc.getElementById("RecLocIdz"+i).value;

	         if ((LastRegNo!="")&&(LastRegNo!=GetRegNo))
	         {
		        alert(t['NotSamePatient']);
		        return false;
		     }
		     else
		     {
			     LastRegNo=GetRegNo;
		     }
		     
		     if ((LastRecLocDR!="")&&(LastRecLocDR!=GetRecLocDR))
	         {
		        alert(t['NotRegNSameRecLoc']);
		        return false;
		     }
		     else
		     {
			     LastRecLocDR=GetRecLocDR;
		     }
		     PatientStatusCode=orddoc.getElementById("OEORIItemStatusz"+i).value;
		     TotalFee=orddoc.getElementById("TotalFeez"+i).innerText;
		     TBillStatus=orddoc.getElementById("TBillStatusz"+i).innerText;
		     ARCIMDesc=orddoc.getElementById("ARCIMDescz"+i).innerText;
		     RegisterStatus=orddoc.getElementById("TStatusz"+i).innerText;
		     if((TBillStatus=="已收费")&(TotalFee==0))
		     {
			     ConFlag=confirm("医嘱"+ARCIMDesc+"已收费,但是价格为零是否继续");
			     if (ConFlag==false){return}
			 }
     	    
     	     if ((PatientStatusCode!="A")&&(PatientStatusCode!="B"))
		     {
			     IsAppReg=false;  
		     }
		     SelCount=SelCount+1;
		 }
      }
      
      if ((IsAppReg==false)&&(SelCount>=1))
      {
	      alert(t["StatusNotReg"]);
	      return  false;
      }

     
      var No=$("NO").value;
      var EQGroupDR=$("EQGroupDR").value;
	  var locdr=$("LocDR").value;
	  var paadmdr=$("PaadmDR").value;
	  var weight=$("Weight").value;
	  var RegDate=$("RegDate").value;
	  var RegTime=$("RegTime").value;
	  var GetIndex=$("GetIndex").value;
	  if ($("Device").value=="")
	  {
		 $("DeviceDR").value="";
	  }
	  var EQDR=$("DeviceDR").value;
	  if ($("Room").value=="")
	  {
		$("RoomDR").value="";
	  }
	  var RoomDR=$("RoomDR").value;
	  if ($("MainDoc").value=="")
	  {
		 $("MainDocDR").value="";
	  }
	  var MainDocDR=$("MainDocDR").value;
	  if ($("OptionDoc").value=="")
	  {
		 $("OptionDocDR").value="";
	  }
	  var AssiantDocDR=$("OptionDocDR").value;
	  var INPNO=$("IPNO").value;
	  var TelNo=$("TELNO").value;
	  var userid=session["LOGON.USERID"];
	  var StudyNo=$("StudyNo").value;
      var oeorditemrowid=$("OeorditemID").value;
      //if No Is Not Null ,Update No of people
      var Nodr=""
      if (No!="")
      {
	    var UpdateNoFunction=$("UpdateNo").value;
	    Nodr=cspRunServerMethod(UpdateNoFunction,No,paadmdr,locdr,EQGroupDR);
   	  }
     
      var SelCount=0;
      var Age; 
      var strMutiOrditemRowid="";
      var SelectIndex;    
      for (var i=1; i<ordtab.rows.length; i++)
      {
        var selectedobj=orddoc.getElementById("TSelectedz"+i);
        if ((selectedobj)&&(selectedobj.checked))
        {
	        SelectIndex=i;
	        if (strMutiOrditemRowid=="")
	        {
	        	strMutiOrditemRowid=orddoc.getElementById("OEOrdItemIDz"+i).value; 
	        }
	        else
	        {
		        strMutiOrditemRowid=strMutiOrditemRowid+"@"+orddoc.getElementById("OEOrdItemIDz"+i).value;
	        }
	        SelCount=SelCount+1
        }
      }
      
      var CreateType=IsCreateStudyNo();
      if (CreateType=="I")
      {
          GetMutiStudyNo(strMutiOrditemRowid);
      }
      else
      {
	      ResSchduleStudyNo(strMutiOrditemRowid);
	  }
 	  
	  ReportInfo=""; 
	  var bodypartlist=$("BodyList"); 
	  glen =bodypartlist.options.length ;
	  gbodyinfo="";
	  for (j=0;j<glen;j++)
	  { 
		 gbodyinfo+=bodypartlist[j].value+"^";
	  }
	  var PatientName=orddoc.getElementById("TPatientNamez"+SelectIndex).innerText;
	  var PatientID=orddoc.getElementById("PatientIDz"+SelectIndex).innerText;
	  var Sex=orddoc.getElementById("TSexz"+SelectIndex).innerText;
	  var DOB=orddoc.getElementById("TDOBz"+SelectIndex).innerText;
	  Age=orddoc.getElementById("TAgez"+SelectIndex).innerText;
	  var InputDate=$("SelRegDate").value;
      var Getsertinfo=$("InsertInfo").value;
      var GroupIndex=$("GroupIndex").value;
	  var RoomIndex=$("RoomIndex").value;
	  var SchudleRowid=$("ResSchudleDR").value;
	  var IndexCode=$("IndexCode").value;
	  var IndexTypeDR=$("IndexTypeID").value;
	  
	  
	  //是否加急 
	  var UrgentFlag=$("Urgent").checked;
      if (UrgentFlag)
	  {
	     UrgentFlag="Y";
	  }
	  else 
	  {
		 UrgentFlag="N";
	  }
	  

	  
	 gCommInfo=AssiantDocDR+"^"+MainDocDR+"^"+Nodr+"^"+strMutiOrditemRowid+"^"+paadmdr+"^"+EQDR+"^"+locdr+"^"+userid+"^"+MutiStudyNo+"^"+GetIndex+"^"+RoomDR+"^"+EQGroupDR+"^"+RegDate+"^"+RegTime+"^"+INPNO+"^"+TelNo+"^"+weight+"^"+ReportInfo+"^"+InputDate+"^"+GroupIndex+"^"+RoomIndex+"^"+UrgentFlag+"^"+SchudleRowid+"^"+IndexCode+"^"+IndexTypeDR; //+"^"+SetGetFilmDate+"^"+Enhance+"^"+Duration;;
     var ret=cspRunServerMethod(Getsertinfo,gCommInfo,glen,gbodyinfo);
     
	 if (ret=="-10001")
	 {
		alert(t['-10001']);
		document.location.reload();
		return false;
	 }
	 
	 if (ret=="-10002")
     {
		 alert(t['-10002']);
		 document.location.reload();
		 return false;
	 }
	 if (ret=="-10003")
	 {
		 alert(t['-10003']);
		 document.location.reload();
		 return false;
	 }
	 if (ret=="-10004")
	 {
		alert(t['-10004']);
		document.location.reload();
		return false;
	 }
	 if (ret=="-10005")
	 {
		 //向集成平台发送消息失败
		 alert(t['-10005']);
		 document.location.reload();
		 return false;                             
	 }
	 else if (ret!="0")
     {
		alert("SQLCODE=:"+ret);
		document.location.reload();
		return false;
     }
     else
     {
     	alert(t['registersuccess']);
     }

	
     //考虑一个申请单跨页的情况,强制一个申请单一起登记
     //var ForceRegisterPatientFunction=$("ForceRegisterPatient").value;
     //var ret=cspRunServerMethod(ForceRegisterPatientFunction,gCommInfo,glen,gbodyinfo);

     var SelectDate=$("SelRegDate").value;
     var CreateType=IsCreateStudyNo();
      
      if ((gIsUpdate=="1")&(CreateType=="I"))
      {
	       var StudyNumber=$("StudyNumber").value;
	       var UpdateNoFunction=$("UpdateStudyNo").value;
		   var ret=cspRunServerMethod(UpdateNoFunction,locdr,EQGroupDR,StudyNumber,SelectDate);
      }
      
  	}
 
  	
  	if (SelCount>0)
  	{
		var MainDoc=$("MainDoc").value;
    	var regEQ=$("Device").value;
		var StudyNo=$("StudyNo").value;
    	var ItemName=""; //$("ItemName").value;
    
    	var bodypartlist=$("BodyList"); 
    	var len =bodypartlist.options.length ;
    	var bodyinfo="";
    	for (j=0;j<len;j++)
    	{ 
			if (bodyinfo!="")
			  bodyinfo=bodyinfo+","+bodypartlist[j].text;
			else
	      	  bodyinfo=bodypartlist[j].text;
    	}
		var GetSupptWorkListFun1=$("GetSupptWorkListFun").value;
		var Support=cspRunServerMethod(GetSupptWorkListFun1,regEQ,locdr);
		var SendInfo=PatientID+"^"+PatientName+"^"+DOB+"^"+Sex+"^"+StudyNo+"^"+weight+"^"+bodyinfo+"^"+regEQ
	  	var PatientName1=$("Name").value;
	   	 
	   	//把病人的基本信息发送到CACHE 的消息队列?由服务程序实现发送
	   	var Support="Y"
	   	
	  	if (Support=="Y")
		{
			 var Item3=DOB.split("/");
			 DOB=Item3[2]+"-"+Item3[1]+"-"+Item3[0];
			 if (HISRegNo!="")
			 {
				 PatientID=HISRegNo;
			 }
			 var Info=PatientID+"^"+PatientName+"^"+PatientName1+"^"+DOB+"^"+Sex+"^"+StudyNo+"^"+weight+"^"+bodyinfo+"^"+regEQ+"^"+InputDate+"^"+Age;
			 //alert(Info);
			 var Option="NW";
			 var SendHL7ToQueueFunction=$("SendHL7ToQueue").value;
			 var Support=cspRunServerMethod(SendHL7ToQueueFunction,Info,Option);
		}
		
     	var PatientType=$("PatientType").value;
		var InLocName=$("InLoc").value;
		
		var splits = /-/i;            
     	var pos = InLocName.search(splits); 
        if (pos>0)
        {           
  	        var Item=InLocName.split("-");
		    InLocName=Item[1];
		}
		var OPNO=$("OPNO").value;
	    var BedCode=$("BedCode").value;
	    var GetPrintItemFun1=$("GetPrintItem").value;
	   	var OrdItemName=cspRunServerMethod(GetPrintItemFun1,StudyNo);
	    $("PrintName").value=OrdItemName;
	    var Room=$("Room").value;
	    var EQGroup=$("EQGroup").value;
	    
	    var DeviceDR=$("DeviceDR").value;
    	var GetEQPrintTemplateFun=$("GetPrintTemplate").value;
	    var PrintTemplate=cspRunServerMethod(GetEQPrintTemplateFun,DeviceDR);
	    if (PrintTemplate!="") gPrintTemplate=PrintTemplate;
	    ///------------------create call file
	    //createCallfile(gSelectNameHZ,StudyNo,GetIndex,Room,PatientType);
	    var Index=GetIndex+"^"+GroupIndex+"^"+RoomIndex;
	    var RegDate=$("CurrentDate").value;
	    var RegTime=$("CurrentTime").value;
	    //StoreAccessCallData(locdr,gSelectNameHZ,PatientID,"",EQGroup,Room,regEQ,Index,RegDate, RegTime,InLocName,"add")
	    
		/*if (gPrintTemplate=="LiXiang")
		{
			// use Li Xiang bar print 
		   printRegBar(StudyNo,PatientID,PatientName,Age,Sex,PatientType,GetIndex,No,INPNO,OPNO,Room,InLocName,BedCode,OrdItemName,PatientName1);
			
		}
		else if (gPrintTemplate!="")
		{
		   DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemplate);
		   var GetFilmSendDate=$("GetFilmDate").value;
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
			
		/////////////////////////////add for sg 
		//OrditemSelected(StudyNo);
		OrditemSelected(MutiStudyNo,UrgentFlag,RegDate,RegTime,"I")
	 
    	//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisWorkBenchEx"
   		//alert(lnk);
    	//parent.frames["DHCRisWorkBench"].location.href=lnk; 

    	var DeviceDesc=$("Device").value
   		var EQGroupDesc=$("EQGroup").value;
    	var RoomDesc=$("Room").value;
		var MainDocDesc=$("MainDoc").value;
		var OperateDocDesc=$("OptionDoc").value;
	
		var SetFunction=$("SetSession").value;
		var SelInfo=DeviceDesc+"^"+EQDR+"^"+EQGroupDesc+"^"+EQGroupDR+"^"+RoomDesc+"^"+RoomDR+"^"+MainDocDesc+"^"+MainDocDR+"^"+OperateDocDesc+"^"+AssiantDocDR;
		var ret=cspRunServerMethod(SetFunction,"LastSel",SelInfo); 
  	}
  	
  
}
/// function  printRegBar
/// 一个标准的条形码打印程序和打印机无关
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
    Bar.PrintRegBill();
}

function InvPrintNew(TxtInfo,ListInfo)
{
	////
	////DHCP_PrintFun(encmeth,PObj,inpara,inlist)
	var myobj=$("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
} 


//print regiter 
function Print_click1()
{
	
	var orddoc=parent.parent.parent.frames["DHCRisWorkBench"].document;
  	var ordtab=orddoc.getElementById("tDHCRisWorkBenchEx");
 	var LastRegNo="";
 	var LastRecLocDR="";
 	var MutiOrditemRowid="";
 	var MStudyNo=""
  	
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
		         GetRecLocDR=orddoc.getElementById("RecLocIdz"+i).value;
		         
		         if ((LastRegNo!="")&&(LastRegNo!=GetRegNo))
		         {
			        alert(t['NotSamePatient']);
			        return false;
			     }
			     else
			     {
				     LastRegNo=GetRegNo;
			     }
			     
			     if ((LastRecLocDR!="")&&(LastRecLocDR!=GetRecLocDR))
	             {
		            alert(t['NotRegNSameRecLoc']);
		            return false;
		         }
		         else
		         {
			        LastRecLocDR=GetRecLocDR;
		         }
		         
			     PatientStatusCode=orddoc.getElementById("OEORIItemStatusz"+i).value;
	     	     if ((PatientStatusCode=="A")||(PatientStatusCode=="B"))
			     {
				     IsAppReg=false;  
			     }
			     SelCount=SelCount+1
			     
			     if (MutiOrditemRowid=="")
	             {
	        	    MutiOrditemRowid=orddoc.getElementById("OEOrdItemIDz"+i).value; 
	             }
	             else
	             {
		            MutiOrditemRowid=MutiOrditemRowid+"@"+orddoc.getElementById("OEOrdItemIDz"+i).value;
	             }
	             
	             if (MStudyNo=="")
	             {
	        	    MStudyNo=orddoc.getElementById("TStudyNoz"+i).innerText; 
	             }
	             else
	             {
		            MStudyNo=MStudyNo+"@"+orddoc.getElementById("TStudyNoz"+i).innerText;
	             }
	        }
        }
  	 }
  	 
  	 
      
   
     if ((IsAppReg==false)&&(SelCount>1))
     {
	     alert(t["StatusNotPrint"]);
	     return  false;
     }
      
     if (SelCount>0)
     {
	   
	      var CreateRegPrintFun=$("CreateRegPrint").value;
	      var Que=cspRunServerMethod(CreateRegPrintFun,MStudyNo,MutiOrditemRowid);
	      if (Que!="")
	      {
		       var Array=Que.split("^");
		       var len=Array.length;
		  	   
	           for (i=0;i<len;i++)
	           {
                  PrintRegBill(Array[i]);
		       }
		       
		  }
	 }   
  	 else
  	 {
	  	alert(t["SelectPatient"]);
  	 }
}

function OrditemSelected(MutiStudyNo,UrgentFlag,RegDate,RegTime,Falg)
{
	//alert(MutiStudyNo);
	orddoc=parent.parent.parent.frames["DHCRisWorkBench"].document;
    var objtbl=orddoc.getElementById("tDHCRisWorkBenchEx");
    var rows=objtbl.rows.length;
    var ArrayStudyNo=MutiStudyNo.split("@");
    var n=0;

    for (i=1;i<rows;i++)
    {
	   var selectedobj=orddoc.getElementById("TSelectedz"+i);
		   
	   if (selectedobj.checked)
	   {  
		  if (Falg=="I")
		  {
			  
			  alert(ArrayStudyNo[j]);
	          orddoc.getElementById("TStatusz"+i).innerText="登记";
	          orddoc.getElementById("OEORIItemStatusz"+i).value="I";
	          orddoc.getElementById("TStudyNoz"+i).innerText=ArrayStudyNo[n];
	          orddoc.getElementById("TRegDatez"+i).innerText=RegDate;
	          orddoc.getElementById("TRegTimez"+i).innerText=RegTime;
	          orddoc.getElementById("Urgentz"+i).innerText=UrgentFlag;
	          if (UrgentFlag=="Y")
	          {
		  		objtbl.rows[i].style.backgroundColor="#00CC00";
			  }
			  n=n+1;
		  }
		  else if(Falg=="B")
		  {
			   orddoc.getElementById("TStatusz"+i).innerText="预约";
               orddoc.getElementById("OEORIItemStatusz"+i).value="B";
               orddoc.getElementById("BookedResz"+i).innerText=gBookResource;
               orddoc.getElementById("TBookedDatez"+i).innerText=gBookDate;
               orddoc.getElementById("TBookedTimez"+i).innerText=gBookTime;
		  }
          
	   }
	      
    }
}

function FunModiPin()
{
   	var NamePinYin=$("Name").value;
   	var SetPinFunction=$("SetPin").value;
   	var Ret=cspRunServerMethod(SetPinFunction,gSelectNameHZ,NamePinYin);
	if (Ret!="0")
	{
		alert(t['sucess']);
	}
}

function GetPin(NameHz)
{
	var PinYin="";
    var NameLen=NameHz.length;
    var GeNamePinF=$("GeNamePin").value;

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

//"科室代码|姓名|登记号|时间|检查组|房间|设备|科室流水号^检查组流水号^房间流水号|登记日期|登记时间|科室类型|状态
function StoreAccessCallData(LocCode,Name,RegNo,TimeDuration,Group,Room,Device,Index,RegDate, RegTime,LocType,Status)
{
	var Info;
	Info=LocCode+"|"+Name+"|"+RegNo+"|"+TimeDuration+"|"+Group+"|"+Room+"|"+Device+"|"+Index+"|"+RegDate+"|"+RegTime+"|"+LocType+"|"+Status
	if (!gCallObj)
	{
		//gCallObj=new ActiveXObject("CallInfo.AcessObject");
	}
	//gCallObj.SetAccessConnectInfo();
	//gCallObj.InsertCallInfo(Info);
}


function GetSchudle()
{
   var orddoc=parent.frames["BookedEx"].document;
   var objtbl=orddoc.getElementById("tDHCRisBookedEx");
   var rows=objtbl.rows.length;
   var SchudleRowid="";
   
   for (var j=1;j<rows;j++)
   {
	     var selectedobj=orddoc.getElementById("Selectz"+j);
	     if ((selectedobj)&&(selectedobj.checked))
	     {
	        SchudleRowid=orddoc.getElementById("ResSchudleRowidz"+j).value; 
	        $("SelRegDate").value=orddoc.getElementById("TBookDatez"+j).innerText;
	     }
   }
   
   $("ResSchudleDR").value=SchudleRowid;
   
   
   var Info=orddoc.getElementById("UpdateBookInfo").value
   if (Info!="")
   {
	   var Array=Info.split("^")
       gBookDate=Array[0];
       gBookTime=Array[1];
       gBookResource=Array[2];
   }
   
}


function SetSelResources()
{
	var SchudleRowid=document.getElementById("ResSchudleDR").value;

	if (SchudleRowid=="")
	   return;
		
    var SelResourcesFun=$("SetSelResources").value;
   
    var SelInfo=cspRunServerMethod(SelResourcesFun,SchudleRowid);
    
    if (SelInfo!="")
    {
  	    var Array=SelInfo.split("^");
   	
	   	$("Device").value=Array[3];
		$("DeviceDR").value=Array[0];
		$("Room").value=Array[4];
		$("RoomDR").value=Array[1];
		$("EQGroup").value=Array[5];
		$("EQGroupDR").value=Array[2];
  	
    }  
	   
}

//获取预约模板
//sunyi
function GetLocBookedPrintTemplate()
{
   var locdr=$("LocDR").value;
   var GetBookTempFunction=$("GetLocBookPrintTemp").value;
   gBookedPrintTemplate=cspRunServerMethod(GetBookTempFunction,locdr);	
}


//////////////////////////////////////////////////////////////////////

function GetLocAddress(locId)
{
   var GetLocAddress=$("GetLocAddress").value;
   var Address=cspRunServerMethod(GetLocAddress,locId);	
   return Address	
}


// 补打预约单
function BookedObj_click()
{
	var OrditemRowid="";
	var Status;

    var orddoc=parent.parent.parent.frames["DHCRisWorkBench"].document;
    
  	var ordtab=orddoc.getElementById("tDHCRisWorkBenchEx");
    if (ordtab) 
    {
	   for (var i=1; i<ordtab.rows.length; i++)
       {
		     var selectedobj=orddoc.getElementById("TSelectedz"+i);
	         if ((selectedobj)&&(selectedobj.checked))
	         {
		          Status=orddoc.getElementById("TStatusz"+i).innerText;
		          
		          if(Status!="预约")
                  {
	                alert("医嘱未预约或已登记不能补打");
	                return;  
	              }
	              
	              if (OrditemRowid=="")
		          {
			         OrditemRowid=orddoc.getElementById("OEOrdItemIDz"+i).value;
		          }
		          else
		          {
			         OrditemRowid=OrditemRowid+"@"+orddoc.getElementById("OEOrdItemIDz"+i).value;
		          }
		          
	         }
       }
       
       
       if (OrditemRowid=="")
       {
	      alert("请选择医嘱项目");
	      return;
       }
       
       //调用打印函数
       OnPrint(OrditemRowid);
    }          

}


function CancelBooking(BOrditemRowid)
{
	var GetCancelFunction=$("GetCancelFunction").value;
	var ret=cspRunServerMethod(GetCancelFunction,BOrditemRowid);
	var ret1=ret.split("^")[0]
	var ret2=ret.split("^")[1]  //消息平台调用返回值
	
	if(ret2!="0")
	{
	    var ErrorInfo="取消预约调用平台消息失败="+ret2
		alert(ErrorInfo);
    }
	if (ret1!="0")
	{
		var ErrorInfo="取消预约失败="+ret1
		alert(ErrorInfo);
		return;
	}
}


function SameServiceGroup(OrditemRowid)
{
   var SameServiceGroupFun=$("SameServiceGroupFun").value;
   var value=cspRunServerMethod(SameServiceGroupFun,OrditemRowid);
   return value;	
}


function OnPrint(OrditemRowid)
{
	if(OrditemRowid!="")
	{
	    var nums=OrditemRowid.split("@").length;
	       
        for (var i=0;i<nums;i++)
 	    {
		   var OrditemID=OrditemRowid.split("@")[i];
		   var GetBookedPrintFun=$("GetBookedPrintFun").value;
	       var value=cspRunServerMethod(GetBookedPrintFun,OrditemID);
	      
	       if(value=="0")
	       {
		       alert("医嘱项目数据出错不能打印");
		       return;
		   }
		   
	       if (value!="")
	       {
		       Item=value.split("^");
		       RegNo=Item[0];
		       Name=Item[1];
		       strOrderName=Item[2];
		       BookedDate=Item[3];
		       BooketTime=Item[4];
		       LocDesc=Item[5];
		       Address=Item[6];
		       ResourceDesc=Item[7];
		       EqAdress=Item[8];
		       DOB=Item[9];
		       Age=Item[10];
		       SexDesc=Item[11];
		       MedicareNo=Item[12];
		       PinYin=Item[13];
		       WardName=Item[14];
		       BedNo=Item[15];
		       AppLocName=Item[16]
		       Memo=Item[17];
		       BUserCode=Item[18];
		       OpDate=Item[19];
		       OpTime=Item[20];

		       var OEorditemID1=OrditemID.split("||")[0]+"-"+OrditemID.split("||")[1];
		       
		       DHCP_GetXMLConfig("InvPrintEncrypt",gBookedPrintTemplate);
			
			   var MyPara="PatientName"+String.fromCharCode(2)+Name;
			   MyPara=MyPara+"^OEorditemID1"+String.fromCharCode(2)+"*"+OEorditemID1+"*";
			   MyPara=MyPara+"^RegNo"+String.fromCharCode(2)+RegNo;
			   MyPara=MyPara+"^BookedDate"+String.fromCharCode(2)+BookedDate+" "+BooketTime;
			   MyPara=MyPara+"^LocDesc"+String.fromCharCode(2)+LocDesc;
			   MyPara=MyPara+"^OrderName"+String.fromCharCode(2)+strOrderName;
			   MyPara=MyPara+"^Address"+String.fromCharCode(2)+Address;
			   MyPara=MyPara+"^ResourceDesc"+String.fromCharCode(2)+ResourceDesc;
			   MyPara=MyPara+"^EqAdress"+String.fromCharCode(2)+EqAdress;
			   MyPara=MyPara+"^DOB"+String.fromCharCode(2)+DOB;
			   MyPara=MyPara+"^Age"+String.fromCharCode(2)+Age;
			   MyPara=MyPara+"^SexDesc"+String.fromCharCode(2)+SexDesc;
			   MyPara=MyPara+"^MedicareNo"+String.fromCharCode(2)+MedicareNo;
			   MyPara=MyPara+"^PinYin"+String.fromCharCode(2)+PinYin;
			   MyPara=MyPara+"^Memo"+String.fromCharCode(2)+Memo;
			   MyPara=MyPara+"^WardName"+String.fromCharCode(2)+WardName;
			   MyPara=MyPara+"^BedNo"+String.fromCharCode(2)+BedNo;
			   MyPara=MyPara+"^AppLocName"+String.fromCharCode(2)+AppLocName;
			   MyPara=MyPara+"^BUserCode"+String.fromCharCode(2)+BUserCode;
			   MyPara=MyPara+"^OpDate"+String.fromCharCode(2)+OpDate;
			   MyPara=MyPara+"^OpTime"+String.fromCharCode(2)+OpTime;
			   InvPrintNew(MyPara,"")
	       } 
		
       	
 	    }
	   
	}
	   
}


function SendMessage(BInfo)
{
	 var SendMessageFun=$("SendMessage").value;
	 var UpdateBookInfo=gBookDate+"^"+gBookTime;
	 var value=cspRunServerMethod(SendMessageFun,BInfo,UpdateBookInfo);
}

function Booking_click()
{
	// 选择预约的医嘱
	var PreRecLocId="",CurrentRecLocId="";
	var IsAllow="Y";
	var LastRegNo='';
	
	var OrditemRowid="";
	var BOrditemRowid="";
	var BookInfo="";
	
    var orddoc=parent.parent.parent.frames["DHCRisWorkBench"].document;
  	var ordtab=orddoc.getElementById("tDHCRisWorkBenchEx");
  	var USERID=session['LOGON.USERID'];
  	
    if (ordtab) 
    {
	   var GetRegNo='';
	   var SelCount=0;
	   var IsAppReg=true;
	   //var StudyNo=$("StudyNo").value;
	   
	   for (var i=1; i<ordtab.rows.length; i++)
       {
	     var selectedobj=orddoc.getElementById("TSelectedz"+i);
         if ((selectedobj)&&(selectedobj.checked))
         {
	         CurrentRecLocId=orddoc.getElementById("RecLocIdz"+i).value;
	         var PatientID=orddoc.getElementById("PatientIDz"+i).innerText;
	         PatientStatusCode=orddoc.getElementById("OEORIItemStatusz"+i).value;
	         GetRegNo=PatientID;
	         TotalFee=orddoc.getElementById("TotalFeez"+i).innerText;
		     TBillStatus=orddoc.getElementById("TBillStatusz"+i).innerText;
		     ARCIMDesc=orddoc.getElementById("ARCIMDescz"+i).innerText;
		     RegisterStatus=orddoc.getElementById("TStatusz"+i).innerText;
	         
	         if ((PreRecLocId!="")&&(PreRecLocId!=CurrentRecLocId))
	         {
		          IsAllow="N";
	         }
	         
	         if ((LastRegNo!='')&&(LastRegNo!=GetRegNo))
	         {
		        alert(t['NotSamePatient']);
		        return false;
		     }
		     else
		     {
			     LastRegNo=GetRegNo;
		     }
		     
	         if((TBillStatus=='已收费')&(TotalFee==0))
		     {
			     ConFlag=confirm('医嘱'+ARCIMDesc+'已收费,但是价格为零是否继续');
			     if (ConFlag==false){return}
			 }
     	     if ((PatientStatusCode!="A")&&(PatientStatusCode!="B"))
		     {
			     IsAppReg=false; 
		     }
		     SelCount=SelCount+1;
     
		   
		     var PatientName=orddoc.getElementById("TPatientNamez"+i).innerText;
			 var Sex=orddoc.getElementById("TSexz"+i).innerText;
			 var WardName=orddoc.getElementById("WardNamez"+i).innerText;
			 var bedNo=orddoc.getElementById("TBedCodez"+i).innerText;
			 var RecLoc=orddoc.getElementById("RecLocz"+i).innerText;
			 var strOrderName=orddoc.getElementById("ARCIMDescz"+i).innerText;
			 var BookedDate=orddoc.getElementById("TBookedDatez"+i).innerText;
			 var BookedTime=orddoc.getElementById("TBookedTimez"+i).innerText;
			 var Address=GetLocAddress(CurrentRecLocId);
			 var ItemID=orddoc.getElementById("OEOrdItemIDz"+i).value;
			 var PaadmDR=orddoc.getElementById("EpisodeIDz"+i).value;
			 
			 var BInfo=ItemID+"^"+PatientName+"^"+strOrderName
			     BInfo=BInfo+"^"+BookedDate+"^"+BookedTime+"^"+session['LOGON.USERID'];
		    
		 
		     if(PatientStatusCode=="B")
		     {
			    if (BOrditemRowid=="")
		        {
			       BOrditemRowid=orddoc.getElementById("OEOrdItemIDz"+i).value;
		        }
		        else
		        {
			       BOrditemRowid=BOrditemRowid+"@"+orddoc.getElementById("OEOrdItemIDz"+i).value;
			    }
			    
			    if(BookInfo=="")
			    {
				   BookInfo=BInfo; 
				}
				else
				{
				   BookInfo=BookInfo+"@"+BInfo;
				}    
			 }
			 
		     if (OrditemRowid=="")
		     {
			     OrditemRowid=orddoc.getElementById("OEOrdItemIDz"+i).value;
		     }
		     else
		     {
			     OrditemRowid=OrditemRowid+"@"+orddoc.getElementById("OEOrdItemIDz"+i).value;
		     }
		     PreRecLocId=CurrentRecLocId;
		     
       	  }
    	}
    }
   
    if ((OrditemRowid=="")&(BOrditemRowid==""))
    {
	    alert(t['SelectItemName']);
	    return;
    }
    if ((IsAppReg==false)&&(SelCount>=1))
    {
	      alert(t['StatusNotReg']);
	      return  false;
    }	
    if (IsAllow=="N")
    {
	    alert(t['NoRecLoc']);
	    return ;
    }
  	
  	var IsSerGroup=SameServiceGroup(OrditemRowid);
  	if(IsSerGroup=="N")
  	{
	    alert(t['NoSercive']);
	    return ;	
	}
	

    var gSchudleRowid=$("ResSchudleDR").value;
    
    //判断是否预约时间冲突
  	var BookedConflictFun=document.getElementById("BookedConflict").value;
  	var rets=cspRunServerMethod(BookedConflictFun,PaadmDR,gSchudleRowid);
  	if (rets!="")
  	{
	    ConFlag=confirm('该病人在 '+rets.split("^")[5]+rets.split("^")[2]+' 已有预约,是否继续');
	    if (ConFlag==false){return;}	
	}
	
  	//如果是转预约的医嘱先取消预约在调用预约函数
  	//sunyi 2012-01-08
  	DBBookedFlag="";
  	if(BOrditemRowid!="")
  	{
	  	ConFlag=confirm('选中的医嘱: '+'已预约,是否转预约!');
	    if (ConFlag==false){return}
  	    CancelBooking(BOrditemRowid);
  	    DBBookedFlag="Y";
  	}
   
    
  	var CreateType=IsCreateStudyNo();
  	if (CreateType=="B")
  	{
	  	GetMutiStudyNo(OrditemRowid);
	  	GetIndex(); 	
	}
  	
 
	if (gSchudleRowid!="")
	{
	    //var Info=OrditemRowid+"^"+gSchudleRowid+"^1^^"+StudyNo+"^^^^^^^"+$("PaadmDR").value;
	    var Info=OrditemRowid+"^"+gSchudleRowid+"^1^^"+MutiStudyNo+"^"+$("GetIndex").value+"^"+$("GroupIndex").value+"^"+$("RoomIndex").value+"^"+$("DeviceDR").value+"^"+$("EQGroupDR").value+"^"+$("RoomDR").value+"^"+$("PaadmDR").value+"^"+$("IndexTypeID").value+"^"+$("SelRegDate").value+"^"+USERID;
		var InsertBookInfoFunction=$("InsertBookInfo").value;
		var ret=cspRunServerMethod(InsertBookInfoFunction,Info);
		var ret1=ret.split("^")[0]
	    var ret2=ret.split("^")[1]  //消息平台调用返回值
	    if (ret1=="-1000")
	    {
		    alert("此项目不需要预约");
		    return ;
	    }
	    else if (ret1=="-999")
	    {
		    alert("此病人已欠费不能预约!");
		    return;
		}
		else if(ret1=="-10002")
		{
			alert(t['NoPaadmDR']);
			return;
		}
	    
	    if(ret2!="0")
	    {
		    var ErrorInfo="调用平台消息失败="+ret2
		    alert(ErrorInfo);
		}
		if (ret1!="0")
		{
			var ErrorInfo="预约失败SQLCODE="+ret1;
			alert(ErrorInfo);
		}
		else 
		{
			if ($("IsPrint").checked)
	            IsPrint="Y";
	         else
	            IsPrint="N";
	            
	        if ((gIsUpdate=="1")&&(CreateType=="B"))
	        {
		       var StudyNumber=$("StudyNumber").value;
		       var UpdateNoFunction=$("UpdateStudyNo").value;
		       var EQGroupDR=$("EQGroupDR").value;
			   var ret=cspRunServerMethod(UpdateNoFunction,CurrentRecLocId,EQGroupDR,StudyNumber,$("SelRegDate").value);
	        }    
	        if (gIsRegBFlag!="Y") 
	        {   
			    alert("预约成功!");
	        }
			
			///如果是转预约要给外勤发消息
			/*if (DBBookedFlag=="Y")
			{
			  SendMessage(BInfo);
			}*/
			
			if ((gBookedPrintTemplate!="")&(IsPrint=="Y"))
			{
	           OnPrint(OrditemRowid);  
			}
			
			OrditemSelected("","","","","B");
			document.location.reload();
				
		}

	}
	else
	{
		alert("请选择预约资源");
	}
	
}

function HasBooked()
{
	 var BookFun=$("IsBookedFun").value;
	 var value=cspRunServerMethod(BookFun,$("OeorditemID").value);
	 return value;
}

function IsCreateStudyNo()
{
	 var CreateStudyNoFun=$("IsCreateStudyNo").value;
	 var value=cspRunServerMethod(CreateStudyNoFun,$("LocDR").value);
	 return value;
}

function IsCreateIndex()
{
	 var ret="";
	 var CreateUpdateNo=$("IsUseUpdateNo").value;
	 var value=cspRunServerMethod(CreateUpdateNo,$("LocDR").value);
	 if (value!="")
	 {
		 ret=value.split("^")[0]
     }
     
	 return ret;
}

function ClearData()
{
	 $("GetIndex").value="";
	 $("GroupIndex").value="";
	 $("RoomIndex").value="";
}

function GetMutiStudyNo(strMutiOrditemRowid)
{
       var locdr=document.getElementById("LocDR").value;
       var IsMore=IsMoreStudyNo(locdr)
       
	   var EQGroupDesc=document.getElementById("EQGroup").value;
	   var GetSelectDate=$("SelRegDate").value;
	   var orditem=strMutiOrditemRowid.split("@");
	   var len=orditem.length;
		  	   
	   for (i=0;i<len;i++)
	   {
			  var GetStudynoFunction=document.getElementById("GetStudyNoFun").value;
			  var Studyinfo=cspRunServerMethod(GetStudynoFunction,orditem[i],EQGroupDesc,locdr,GetSelectDate);    	
		    
	     	  var StudyItem=Studyinfo.split("^");
	     	  document.getElementById("StudyNo").value=StudyItem[0]+StudyItem[1];
	     	  document.getElementById("StudyNumber").value=StudyItem[1];
	     	  
	     	  if (StudyItem[2]=="1")
	     	  {
		     	  gIsUpdate="1";
		      }
	     	  else
	     	  {
		     	  gIsUpdate="0";
	     	  }
	     	  if ((IsMore=="Y")&&(gIsUpdate=="1"))
	     	  {
			       var EQGroupDR=document.getElementById("EQGroupDR").value;
			       var StudyNumber=document.getElementById("StudyNumber").value;
			       var UpdateNoFunction=document.getElementById("UpdateStudyNo").value;
			       var ret=cspRunServerMethod(UpdateNoFunction,locdr,EQGroupDR,StudyNumber,GetSelectDate);
	     	  }
		   
		      if (MutiStudyNo=="")
		      {
			     MutiStudyNo=document.getElementById("StudyNo").value;
		      }
		      else
		      {
			     MutiStudyNo=MutiStudyNo+"@"+document.getElementById("StudyNo").value;  
		      } 
    
   }
      
}


function IsMoreStudyNo(LocDR)
{
	var IsCreateMoreStudyNoFun=document.getElementById("IsCreateMoreStudyNo").value;
	var ret=cspRunServerMethod(IsCreateMoreStudyNoFun,LocDR);
	return ret;
}

function ResSchduleStudyNo(strMutiOrditemRowid)
{
	var RequestStudyNoFun=document.getElementById("RequestStudyNo").value;
	MutiStudyNo=cspRunServerMethod(RequestStudyNoFun,strMutiOrditemRowid);
}

function PrintRegBill(MutiOrditemRowid)
{ 
	 var RegBillDataFun=document.getElementById("RegBillData").value;
     PrintData=cspRunServerMethod(RegBillDataFun,MutiOrditemRowid);
     
     if (PrintData!="")
     {
	  
         var Item=PrintData.split("^");
         var StudyNo=Item[0];
         var PatientID=Item[1];
         var PatientName=Item[2];
         var Sex=Item[3];
         var Age=Item[4];
         var RecLoc=Item[5];
         var OrdItemName=Item[6];
         var IndexType=Item[7];
         var GetIndex=Item[8];
         var EQDesc=Item[9];
         var Room=Item[10];
         var GroupDesc=Item[11];
         var Patienttype=Item[12];
         var INPNO=Item[13];
         var OPNO=Item[14];
         var InLocName=Item[15];
         var BedCode=Item[16];
         var DeviceDR=Item[17];
         var No=Item[18];
         var RegDate=Item[19];
         var RegTime=Item[20];
         
         if (DeviceDR!="")
         {
	         var GetEQPrintTemplateFun=$("GetPrintTemplate").value;
	         var PrintTemplate=cspRunServerMethod(GetEQPrintTemplateFun,DeviceDR);
	         if (PrintTemplate!="") gPrintTemplate=PrintTemplate;
	     }
         
         if (gPrintTemplate=="tiaoma")
		 {
			// use Li Xiang bar print 
		    printRegBar(StudyNo,PatientID,PatientName,Age,Sex,PatientType,GetIndex,No,INPNO,OPNO,Room,InLocName,BedCode,OrdItemName,PatientName);
			
		 }
		 else if (gPrintTemplate!="")
		 {
		 
		   DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemplate);

    	   var LStudyNo="*"+StudyNo+"*";
		   var MyPara="PatientName"+String.fromCharCode(2)+PatientName;
		   MyPara=MyPara+"^RegNo"+String.fromCharCode(2)+PatientID;
		   MyPara=MyPara+"^Sex"+String.fromCharCode(2)+Sex;
		   MyPara=MyPara+"^Age"+String.fromCharCode(2)+Age;
		   MyPara=MyPara+"^MRI"+String.fromCharCode(2)+No;
		   MyPara=MyPara+"^Date"+String.fromCharCode(2)+RegDate;
		   MyPara=MyPara+"^StuyNo"+String.fromCharCode(2)+StudyNo;
           MyPara=MyPara+"^Time"+String.fromCharCode(2)+RegTime;
           
           MyPara=MyPara+"^RecLoc"+String.fromCharCode(2)+RecLoc;
           MyPara=MyPara+"^ItemName"+String.fromCharCode(2)+OrdItemName;
           MyPara=MyPara+"^Room"+String.fromCharCode(2)+Room;
           MyPara=MyPara+"^GetIndex"+String.fromCharCode(2)+GetIndex;
           MyPara=MyPara+"^LStudyNo"+String.fromCharCode(2)+LStudyNo;
 
		   InvPrintNew(MyPara,"");
		}
	 }

}

document.body.onload = BodyLoadHandler;
