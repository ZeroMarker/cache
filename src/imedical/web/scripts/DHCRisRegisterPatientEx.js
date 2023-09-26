//DHCRisRegisterPatientEx.js
document.write("<OBJECT ID='PrnBar' CLASSID='CLSID:4996FF7D-F0BB-4BB4-B3DA-B7063234A748' CODEBASE='../addins/client/PrintRegBar.CAB#version=1,0,0,29'>");
document.write("</object>");

var gHL7Obj;
var gprintOBj;
var gHztoPyobj;
var gCommInfo;
var gNodr;
var gIsUpdate,gUpdateNo;
var gPrintTemplate=""; //print template 
var gSelectNameHZ;
var gCallObj; 
var MutiStudyNo="";
var gLocDR="";

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
	
	var oeorditemrowid;
	var OeorditemIDObj=document.getElementById("OeorditemID");
	if (OeorditemIDObj)
	{
		oeorditemrowid=OeorditemIDObj.value;
	}
	
 	var locdr=document.getElementById("LocDR").value;
 	gLocDR=locdr
	var paadmdr=document.getElementById("PaadmDR").value;
	
	var InputRegDateObj=document.getElementById("InputRegDate");
	if (InputRegDateObj)
	{
	  //InputRegDateObj.value=DateDemo();
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
	 
	 GetBookedInfo();
   
     GetSelRegInfo();
     
     //前台只显示检查号
   	 //GetStudyNo(oeorditemrowid);
   
     GetNo();
     
     //get last select info
     GetLastSelInfo();


	 var IndexObj=document.getElementById("GetIndex");
	 if (IndexObj)
	 {
	 	if (IndexObj.value=="")
	 	{	
	 		//GetIndex();
	 	}
	 }
	 var GroupIndexObj=document.getElementById("GroupIndex");
	 if (GroupIndexObj)
	 {
	 	if (GroupIndexObj.value=="")
	 	{
			 //GetGroupIndex();
		}
	 }
	 
	 var RoomIndexObj=document.getElementById("RoomIndex");
	 if (RoomIndexObj)
	 {
	 	if (RoomIndexObj.value=="")
	 	{
			//GetRoomIndex();
	 	}
	 }

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
 	 //GetStudyNo(oeorditemrowid);
 	//InitIndex(); 
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
			//InitIndex();
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
			//InitIndex();
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
				//InitIndex();
	    }
	         	
    }

}



function GetLastSelInfo()
{
	var locdr=document.getElementById("LocDR").value;
    var GetFunction=document.getElementById("GetSession").value;
	//var Info=cspRunServerMethod(GetFunction,"LastSel");
	var Info=cspRunServerMethod(GetFunction,locdr);
	var Item=Info.split("^");
	if ((document.getElementById("DeviceDR").value=="")&&(Info!=""))
	{
		if (Item[1]!="")
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
		}
		document.getElementById("MainDoc").value=Item[6];
		document.getElementById("MainDocDR").value=Item[7];
		document.getElementById("OptionDoc").value=Item[8];
		document.getElementById("OptionDocDR").value=Item[9];
		
		var oeorditemrowid=document.getElementById("OeorditemID").value;
		//GetStudyNo(oeorditemrowid);

	}
}

function GetStudyNo(oeorditemrowid)
{
	   //var oeorditemrowid=document.getElementById("OeorditemID").value;
       var locdr=document.getElementById("LocDR").value;

       var EQGroupDesc=document.getElementById("EQGroup").value;

  	   var GetStudynoFunction=document.getElementById("GetStudyNoFun").value;
  	   var GetSelectDate=document.getElementById("InputRegDate").value;
  	       GetSelectDate=FormatDate(GetSelectDate);
  	
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
   var InputDate=document.getElementById("InputRegDate").value;
   var GetIndexFunction=document.getElementById("GetIndexFunction").value;
   var Index=cspRunServerMethod(GetIndexFunction,locdr,InputDate);	
   document.getElementById("GetIndex").value=Index;
}

//sunyi
function GetGroupIndex()
{
   var groupdr=document.getElementById("EQGroupDR").value;
   var InputDate=document.getElementById("InputRegDate").value;
   var GroupIndexFunction=document.getElementById("GetGroupIndex").value;
   var Index=cspRunServerMethod(GroupIndexFunction,groupdr,InputDate);
   document.getElementById("GroupIndex").value=Index;
}

//GET ROOM INDEX 
function GetRoomIndex()
{
   var RoomDR=document.getElementById("RoomDR").value;
   var InputDate=document.getElementById("InputRegDate").value;
   var GetRoomIndexFunction=document.getElementById("GetRoomIndex").value;
   var Index=cspRunServerMethod(GetRoomIndexFunction,RoomDR,InputDate);
   document.getElementById("RoomIndex").value=Index;
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
  	gSelectNameHZ=tem1[0];
  
    var GetHZPinFunction=document.getElementById("HZtoPin").value;
    var Pin=cspRunServerMethod(GetHZPinFunction,gSelectNameHZ);
    document.getElementById("Name").value=Pin;

   //document.getElementById("Name").value=gHztoPyobj.topin(tem1[0]);
    document.getElementById("DOB").value=tem1[1];
    document.getElementById("Weight").value=tem1[2];
    document.getElementById("IPNO").value=tem1[4];
	document.getElementById("TELNO").value=tem1[3];
	;document.getElementById("RegDate").value=tem1[5];
	;document.getElementById("RegTime").value=tem1[6];
	document.getElementById("GetIndex").value=tem1[7];
	
	if (tem1[8]!="")
	{
		document.getElementById("Device").value=tem1[8];
		document.getElementById("DeviceDR").value=tem1[9];
		var GetEQPrintTemplateFun=document.getElementById("GetPrintTemplate").value;
		var PrintTemplate=cspRunServerMethod(GetEQPrintTemplateFun,tem1[9]);
		if (PrintTemplate!="") gPrintTemplate=PrintTemplate;
		document.getElementById("Room").value=tem1[14];
		document.getElementById("RoomDR").value=tem1[15];
		document.getElementById("EQGroup").value=tem1[16];
		document.getElementById("EQGroupDR").value=tem1[17];
	}	

	document.getElementById("MainDoc").value=tem1[10];
	document.getElementById("MainDocDR").value=tem1[11];
	document.getElementById("OptionDoc").value=tem1[12];
	document.getElementById("OptionDocDR").value=tem1[13];
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
  	/*var BodyList=document.getElementById('BodyList'); 
	for (i=0;i<Nums;i++)
	{
		var Index=BodyList.options.length;
		var BodyInfo=tem2[i].split(":");
		var objSelected = new Option(BodyInfo[1],BodyInfo[0]);
		BodyList.options[Index]=objSelected;
	}*/
	if(tem1[27]!="")
	{
		document.getElementById("InputRegDate").value=tem1[27];
	}
	document.getElementById("GroupIndex").value=tem1[28];

	document.getElementById("RoomIndex").value=tem1[29];
	
	var UgentObj=document.getElementById("Urgent");
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
	
	document.getElementById("StudyNo").value=tem1[31];
	
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

	var GetFunction=document.getElementById("GetGroupRoom").value;
	var Info=cspRunServerMethod(GetFunction,Item[2],locdr);
	var Item1=Info.split("^");
	document.getElementById("EQGroup").value=Item1[0];
    document.getElementById("EQGroupDR").value=Item1[1];
    document.getElementById("Room").value=Item1[2];
	document.getElementById("RoomDR").value=Item1[3];
	
	var oeorditemrowid=document.getElementById("OeorditemID").value;

	//GetStudyNo(oeorditemrowid);
    GetNo();
    //GetRoomIndex();
    //GetGroupIndex();

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
	var OEOrdItemID ="";
  	var paadmdr="",paadmtype
  	var num=0;
  	var LastRegNo="";
  	var ReportInfo="";
  	var GroupIndex,RoomIndex;
    var HISRegNo="";
    var LastRecLocDR="";

	var regEQ=document.getElementById("Device").value;
	if (regEQ=="")
	{
		var Ans=confirm(t['HaventInput'])
		if (Ans==true) {return false;}
	}
	var orddoc=parent.parent.frames["DHCRisWorkBench"].document;
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
		     var InOrdtemRoiwd=orddoc.getElementById("OEOrdItemIDz"+i).value;
		     if((TBillStatus=='已收费')&(TotalFee==0))
		     {
			     ConFlag=confirm('医嘱'+ARCIMDesc+'已收费,但是价格为零是否继续');
			     if (ConFlag==false){return}
			 }
			 
			 var IsReg=AllowRegister(InOrdtemRoiwd);
			 if (IsReg=="N")
             {
	              alert("此病人已开始编辑报告不能登记!");
	              return false;
             }
     	    
     	     if ((PatientStatusCode!="A")&&(PatientStatusCode!="B")&&(PatientStatusCode!="I"))
		     {
			     IsAppReg=false;  
		     }
		     if (PatientStatusCode=="I")
		     {
			     alert("患者已经登记，将再次登记")			    		     
			  }
		     SelCount=SelCount+1;
		 }
      }
      
      if (SelCount==0)
      {
	      alert(t['NoSelRegItem']);
	      return  false;
	  }
      if ((IsAppReg==false)&&(SelCount>=1))
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
      
      //不重前台获取检查号，从后台获检查号
      //GetMutiStudyNo(strMutiOrditemRowid);

 	  var WrieReport=document.getElementById("ReportInfo").checked;
	  ReportInfo="";
	  if (WrieReport)
	  {
	     ReportInfo="Y";
	  }
	  /*var bodypartlist=document.getElementById('BodyList'); 
	  glen =bodypartlist.options.length ;
	  gbodyinfo="";
	  for (j=0;j<glen;j++)
	  { 
		 gbodyinfo+=bodypartlist[j].value+"^";
	  }*/
	  var PatientName=orddoc.getElementById("TPatientNamez"+SelectIndex).innerText;
	  var PatientID=orddoc.getElementById("PatientIDz"+SelectIndex).innerText;
	  var Sex=orddoc.getElementById("TSexz"+SelectIndex).innerText;
	  var DOB=orddoc.getElementById("TDOBz"+SelectIndex).innerText;
	  Age=orddoc.getElementById("TAgez"+SelectIndex).innerText;
	  var InputDate=document.getElementById("InputRegDate").value;
      var Getsertinfo=document.getElementById("InsertInfo").value;
      GroupIndex=document.getElementById("GroupIndex").value;
	  RoomIndex =document.getElementById("RoomIndex").value;
	  
	  //是否加急 
	  var UrgentFlag=document.getElementById("Urgent").checked;
      if (UrgentFlag)
	  {
	     UrgentFlag="Y";
	  }
	  else 
	  {
		 UrgentFlag="N";
	  }
	  
	  //杜绝前台输入检查号
	  MutiStudyNo="";
	  gCommInfo=AssiantDocDR+"^"+MainDocDR+"^"+Nodr+"^"+strMutiOrditemRowid+"^"+paadmdr+"^"+EQDR+"^"+locdr+"^"+userid+"^"+MutiStudyNo+"^"+GetIndex+"^"+RoomDR+"^"+EQGroupDR+"^"+RegDate+"^"+RegTime+"^"+INPNO+"^"+TelNo+"^"+weight+"^"+ReportInfo+"^"+InputDate+"^"+GroupIndex+"^"+RoomIndex+"^"+UrgentFlag; //+"^"+SetGetFilmDate+"^"+Enhance+"^"+Duration;;
	  var glen="";
	  var gbodyinfo="";
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
	 if (ret=="-10006")
	 {
		 //向集成平台发送消息失败
		 alert("选中项目存在停止医嘱不能登记!");
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

	 // 更新检查号的生成规则在后台执行
     //考虑一个申请单跨页的情况,强制一个申请单一起登记
     //var ForceRegisterPatientFunction=document.getElementById("ForceRegisterPatient").value;
     //var ret=cspRunServerMethod(ForceRegisterPatientFunction,gCommInfo,glen,gbodyinfo);

      /*var SelectDate=document.getElementById("InputRegDate").value;
      
      if (gIsUpdate=="1")
      {
	       var StudyNumber=document.getElementById("StudyNumber").value;
	       var UpdateNoFunction=document.getElementById("UpdateStudyNo").value;
		   var ret=cspRunServerMethod(UpdateNoFunction,locdr,EQGroupDR,StudyNumber,SelectDate);
      }
      
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
    
    	/*var bodypartlist=document.getElementById('BodyList'); 
    	var len =bodypartlist.options.length ;
    	var bodyinfo="";
    	for (j=0;j<len;j++)
    	{ 
			if (bodyinfo!="")
			  bodyinfo=bodyinfo+","+bodypartlist[j].text;
			else
	      	  bodyinfo=bodypartlist[j].text;
    	}*/
    	var bodyinfo="";
		var GetSupptWorkListFun1=document.getElementById("GetSupptWorkListFun").value;
		var Support=cspRunServerMethod(GetSupptWorkListFun1,regEQ,locdr);
		var SendInfo=PatientID+"^"+PatientName+"^"+DOB+"^"+Sex+"^"+StudyNo+"^"+weight+"^"+bodyinfo+"^"+regEQ
	  	var PatientName1=document.getElementById("Name").value;
	   	 
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
			 var SendHL7ToQueueFunction=document.getElementById("SendHL7ToQueue").value;
			 var Support=cspRunServerMethod(SendHL7ToQueueFunction,Info,Option);
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
	    var EQGroup=document.getElementById("EQGroup").value;
	    
	    var DeviceDR=document.getElementById("DeviceDR").value;
    	var GetEQPrintTemplateFun=document.getElementById("GetPrintTemplate").value;
	    var PrintTemplate=cspRunServerMethod(GetEQPrintTemplateFun,DeviceDR);
	    if (PrintTemplate!="") gPrintTemplate=PrintTemplate;
	    ///------------------create call file
	    //createCallfile(gSelectNameHZ,StudyNo,GetIndex,Room,PatientType);
	    var Index=GetIndex+"^"+GroupIndex+"^"+RoomIndex;
	    var RegDate=document.getElementById("CurrentDate").value;
	    var RegTime=document.getElementById("CurrentTime").value;
	    //StoreAccessCallData(locdr,gSelectNameHZ,PatientID,"",EQGroup,Room,regEQ,Index,RegDate, RegTime,InLocName,"add")
	    
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
			
		/////////////////////////////add for sg 
		//OrditemSelected(StudyNo);
		OrditemSelected(UrgentFlag,RegDate,RegTime,strMutiOrditemRowid)
	 
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
		//var ret=cspRunServerMethod(SetFunction,"LastSel",SelInfo); //locdr
		var ret=cspRunServerMethod(SetFunction,gLocDR,SelInfo);
  	}
  	
  
}
/// function  printRegBar
/// 一个标准的条形码打印程序?和打印机无关
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
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
} 


//print regiter 
/*function Print_click1()
{
	
	var orddoc=parent.parent.frames["DHCRisWorkBench"].document;
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
	  var HISRegNo=""
	  var SelCount=0;
	  var IsAppReg=true;
      for (var i=1; i<ordtab.rows.length; i++)
      {
        var selectedobj=orddoc.getElementById("TSelectedz"+i);
        if ((selectedobj)&&(selectedobj.checked))
        {
	         GetRegNo=orddoc.getElementById("PatientIDz"+i).innerText;
	         var RegDate=orddoc.getElementById("TRegDatez"+i).innerText;
	         var RegTime=orddoc.getElementById("TRegTimez"+i).innerText;
	         //HISRegNo=orddoc.getElementById("THISPatientIDz"+i).innerText;
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
	  //var RegDate=document.getElementById("RegDate").value;
	  //var RegTime=document.getElementById("RegTime").value;
	  var GetIndex=document.getElementById("GetIndex").value;
	  var RoomIndex =document.getElementById("RoomIndex").value;
	  
	  
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
      //var RoomDesc=document.getElementById("Room").value;
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
	       var RecLoc=orddoc.getElementById("RecLocz"+i).innerText;
	       var ARCIMDesc=orddoc.getElementById("ARCIMDescz"+i).innerText;
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
		if (gPrintTemplate=="tiaoma")
		{
			// use Li Xiang bar print 
		    printRegBar(StudyNo,PatientID,PatientName,Age,Sex,PatientType,GetIndex,No,INPNO,OPNO,Room,InLocName,BedCode,OrdItemName,PatientName1);
			
		}
		else if (gPrintTemplate!="")
		{
		 
		   DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemplate);
  		   
  		   /*var SetGetFilmDateObj=document.getElementById("SetGetFilmDate");
		   var SendFilmDate=SetGetFilmDateObj.value;
		   
		   var ConvertDateFormatFun=document.getElementById("ConvertDateFormat").value;
    	   SendFilmDate=cspRunServerMethod(ConvertDateFormatFun,SendFilmDate);*/
    	 
 
    	   //var SendTime=document.getElementById("Time").value;
    	   
    	
    	   /*var LStudyNo="*"+StudyNo+"*";
		   var MyPara="PatientName"+String.fromCharCode(2)+PatientName;
		   MyPara=MyPara+"^RegNo"+String.fromCharCode(2)+PatientID;
		   MyPara=MyPara+"^Sex"+String.fromCharCode(2)+Sex;
		   MyPara=MyPara+"^Age"+String.fromCharCode(2)+Age;
		   MyPara=MyPara+"^MRI"+String.fromCharCode(2)+No;
		   MyPara=MyPara+"^Date"+String.fromCharCode(2)+RegDate;
		   MyPara=MyPara+"^StuyNo"+String.fromCharCode(2)+StudyNo;
           MyPara=MyPara+"^Time"+String.fromCharCode(2)+RegTime;
           
           MyPara=MyPara+"^RecLoc"+String.fromCharCode(2)+RecLoc;
           MyPara=MyPara+"^ItemName"+String.fromCharCode(2)+ARCIMDesc;
           MyPara=MyPara+"^Room"+String.fromCharCode(2)+Room;
           MyPara=MyPara+"^RoomIndex"+String.fromCharCode(2)+RoomIndex;
           MyPara=MyPara+"^LStudyNo"+String.fromCharCode(2)+LStudyNo;*/

           //alert(MyPara);
	
		  /* InvPrintNew(MyPara,"");
		}
	}
  	else
  	{
	  	alert(t['SelectPatient']);
  	}
}*/

//print regiter 
function Print_click1()
{
	
	var orddoc=parent.parent.frames["DHCRisWorkBench"].document;
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
  	 
  	 
     if ((IsAppReg==false)&&(SelCount>=1))
     {
	     alert(t["StatusNotPrint"]);
	     return  false;
     }
      
     if (SelCount>0)
     {
	      var CreateRegPrintFun=document.getElementById("CreateRegPrint").value;
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
	         var GetEQPrintTemplateFun=document.getElementById("GetPrintTemplate").value;
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
           MyPara=MyPara+"^RoomIndex"+String.fromCharCode(2)+GetIndex;
           MyPara=MyPara+"^LStudyNo"+String.fromCharCode(2)+LStudyNo;
 
		   InvPrintNew(MyPara,"");
		}
	 }

}


function OrditemSelected(UrgentFlag,RegDate,RegTime,strMutiOrditemRowid)
{
	orddoc=parent.parent.frames["DHCRisWorkBench"].document;
    var objtbl=orddoc.getElementById('tDHCRisWorkBenchEx');
    var rows=objtbl.rows.length;
    var n=0;
    
    var InitRegFunction=document.getElementById("InitRegParam").value;
   	var Info=cspRunServerMethod(InitRegFunction,strMutiOrditemRowid);
   	if (Info!="")
   	{
   	   var Item=Info.split("^");
   	   MutiStudyNo=Item[0]; 
   	   document.getElementById("StudyNo").value=MutiStudyNo.split("@")[0];
   	   document.getElementById("GetIndex").value=Item[1];
       document.getElementById("GroupIndex").value=Item[2];
	   document.getElementById("RoomIndex").value=Item[3];
   	}
   	
   	var ArrayStudyNo=MutiStudyNo.split("@");
    
    for (i=1;i<rows;i++)
    {
	   var selectedobj=orddoc.getElementById("TSelectedz"+i);
	   if (selectedobj.checked)
	   {
          orddoc.getElementById("TStatusz"+i).innerText=t["RegStatus"];
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

//'科室代码|姓名|登记号|时间|检查组|房间|设备|科室流水号^检查组流水号^房间流水号|登记日期|登记时间|科室类型|状态
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

function GetBookedInfo()
{
	var oeorditemrowid=document.getElementById("OeorditemID").value;
	if (oeorditemrowid=="")
		return;
		
	var GetBookedInfoFunction=document.getElementById("GetBookedInfo").value;
    var RegInfo=cspRunServerMethod(GetBookedInfoFunction,oeorditemrowid);
  	var tem1=RegInfo.split("^");
   	if (tem1[13]!="")
  	{
   	document.getElementById("Device").value=tem1[6];
	document.getElementById("DeviceDR").value=tem1[13];
	document.getElementById("Room").value=tem1[12];
	document.getElementById("RoomDR").value=tem1[11];
	document.getElementById("EQGroup").value=tem1[10];
	document.getElementById("EQGroupDR").value=tem1[9];
  	}
}

function GetMutiStudyNo(strMutiOrditemRowid)
{
       var locdr=document.getElementById("LocDR").value;
       var EQGroupDesc=document.getElementById("EQGroup").value;
	   var strOeorditemID=document.getElementById("OeorditemID").value
       var IsMore=IsMoreStudyNo(locdr,strOeorditemID,EQGroupDesc)
       
	   var EQGroupDesc=document.getElementById("EQGroup").value;
	   var GetSelectDate=document.getElementById("InputRegDate").value;
	       GetSelectDate=FormatDate(GetSelectDate);
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
	     	  if (IsMore=="Y")
	     	  {
		          if (gIsUpdate=="1")
		          {
			         var EQGroupDR=document.getElementById("EQGroupDR").value;
			         var StudyNumber=document.getElementById("StudyNumber").value;
			         var UpdateNoFunction=document.getElementById("UpdateStudyNo").value;
			         var ret=cspRunServerMethod(UpdateNoFunction,locdr,EQGroupDR,StudyNumber,GetSelectDate);
			      } 
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


function IsMoreStudyNo(locdr,strOeorditemID,EQGroupDesc)
{
	var IsCreateMoreStudyNoFun=document.getElementById("IsCreateMoreStudyNo").value;
	var ret=cspRunServerMethod(IsCreateMoreStudyNoFun,locdr,strOeorditemID,EQGroupDesc);
	return ret;
}

function InitIndex()
{
	var IndexObj=document.getElementById("GetIndex");
	if (IndexObj)
	{
        GetIndex();
	}
	var GroupIndexObj=document.getElementById("GroupIndex");
	if (GroupIndexObj)
	{
		GetGroupIndex();
	}

	var RoomIndexObj=document.getElementById("RoomIndex");
	if (RoomIndexObj)
	{
		GetRoomIndex();
	}
}

function FormatDate()
{
	var GetSelectDate=document.getElementById("InputRegDate").value;
	var Array=GetSelectDate.split("/");
	var Date=Array[2]+"-"+Array[1]+"-"+Array[0];
	return Date
}

function AllowRegister(OrditemRowid)
{
	var IsCanReg=document.getElementById("IsCanRegFun").value;
	var ret=cspRunServerMethod(IsCanReg,OrditemRowid);
	return ret;
}

