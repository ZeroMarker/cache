var gnorowid;
var gnumber;
var gprefix;
var greginfo;
var gInfo,glen,gbodyinfo
var HL7Obj;
var printOBj;
var gLocName;


function BodyLoadHandler()
{
        //AADDDD
   
    GetLocID();
        
	var regObj=document.getElementById("Register");
	if (regObj)
	{
		regObj.onclick=Reg_click;
	}
	var DeleteObj=document.getElementById("Delete");
	if (DeleteObj)
	{
		DeleteObj.onclick=Delete_click;
	}
	var ModiObj=document.getElementById("Modi");
	 if (ModiObj)
	{
		ModiObj.onclick=Modi_click;
		
	}
	
	var oeorditemrowid=document.getElementById("orditemrowid").value;
	var GetItemNameFunction=document.getElementById("ItemName").value;
    var ItemNameInfo=cspRunServerMethod(GetItemNameFunction,oeorditemrowid);
    var ListInfo=ItemNameInfo.split("^");
    document.getElementById("ItemName").value=ListInfo[0];
    document.getElementById("TotalPrice").value=ListInfo[1];
    document.getElementById("Num").value=ListInfo[2];
    document.getElementById("Price").value=ListInfo[3];
    
    
		
	var GetAppointinfo=document.getElementById("Appointmentrowid").value;
	var paadmrowid=document.getElementById("EpisodeID").value;
	var Appointmentinfo=cspRunServerMethod(GetAppointinfo,oeorditemrowid);
	if (Appointmentinfo!="")
	{
		//alert(Appointmentinfo);
		var tem=Appointmentinfo.split("^");
		var resource=document.getElementById("BookedResource");
		var BookedDate=document.getElementById("BookedDate");
		var BookedTime=document.getElementById("BookedTime");
		resource.text=tem[0]; //appointment rowid
		resource.value=tem[2];// desc
		BookedDate.value=tem[3];
		BookedTime.value=tem[4];
		
		//get appointment equipment 
		var obj=document.getElementById('RegEQ');
		obj.value=tem[6];
		obj.text=tem[7];

	}
	var GetPatientName=document.getElementById("Name").value;
	var Info=cspRunServerMethod(GetPatientName,paadmrowid);
	var patinfo=Info.split("^");
	document.getElementById("Name").value=patinfo[0];
	document.getElementById("PatientID1").value=patinfo[2];
	document.getElementById("Sex").value=patinfo[1];
	document.getElementById("birthday").value=patinfo[3];
	document.getElementById("strAge").value=patinfo[4];
	document.getElementById("WardName").value=patinfo[5];
	document.getElementById("BedName").value=patinfo[6];
		
	var GetRegInfofunction=document.getElementById("GetRegInfo").value;
	greginfo=cspRunServerMethod(GetRegInfofunction,oeorditemrowid);	
	if (greginfo=="")
    {
	    //alert(greginfo);
		
		GetStudyNo();//获得病人的检查号
		GetNo();   //获得病人的检查病案号
		GetIndex(); //获得流水号
    }
	else
	{
		GetReginfo(greginfo);
		
	}
	
	////add by gongping 2006.10.17
	GetWeight(); //get weight 

    GetIPNO(); 
    
	//ConnectHL7Server();  //Connect HL7 Server
	
	IniPrintObj();
	
	
			
	
}
//////////////////
function GetLocID()
{
	var LocID=document.getElementById("LoginLocID");
	var GetLocSessionFunction=document.getElementById("GetLocSession").value;
	var Getlocicvalue=cspRunServerMethod(GetLocSessionFunction,"SelLocID");
	if (Getlocicvalue=="")
       LocID.value=session['LOGON.CTLOCID'];
    else 
 	   LocID.value=Getlocicvalue;
 	
 	var GetLocNameFunction=document.getElementById("FindLocName").value;
	 gLocName=cspRunServerMethod(GetLocNameFunction,LocID.value);
  	
}
function ConnectHL7Server()
{
	if (!HL7Obj)
		HL7Obj = new ActiveXObject("HL7Com.CHL7");	
	//HL7Obj.ConnectHL7Server("192.168.2.239","1041");
    HL7Obj.ConnectHL7Server1();
    
	
}
function IniPrintObj()
{
	if (!printOBj)
		printOBj=new ActiveXObject("RISPrint.CPrintExamItem")
		
}


function GetWeight()   //get weight 
{
	var paadmrowid=document.getElementById("EpisodeID").value;
	var GetWeight=document.getElementById("weight");
	//alert(paadmrowid);
	var strWeight=cspRunServerMethod(GetWeight.value,paadmrowid);
	//alert(strWeight);
	GetWeight.value=strWeight;
}

//get ipno  and telno
function GetIPNO()   
{
	var paadmrowid=document.getElementById("EpisodeID").value;
	var GetINIP=document.getElementById("INPNO");
	var strINIPno=cspRunServerMethod(GetINIP.value,paadmrowid);
	var item=strINIPno.split("^");
	GetINIP.value=item[0];
	var TelNo=document.getElementById("TelNo");
	TelNo.value=item[1];
	
	
}

function Delete_click()
{
	var bodypartlist=document.getElementById('BodyList'); 
	var nIndex=bodypartlist.selectedIndex;
	if (nIndex==-1) return;
	bodypartlist.options[nIndex]=null;
}

function GetNo()
{
		var paadmrowid=document.getElementById("EpisodeID").value;
		var RegLOC=document.getElementById("LoginLocID").value;
		var GetNo=document.getElementById("GetNo").value;
		//alert(GetNo);
		var strNo=cspRunServerMethod(GetNo,paadmrowid,RegLOC);
		//alert(strNo);
		var NoObj=document.getElementById("No");
	    NoObj.value=strNo;
		//GetNo.value=strNo;
		
}
function GetReginfo(Info)
{
	
	var AssiantDoc=document.getElementById('DoctorA');
	var MainDoc=document.getElementById("MainDoctor");
	var No=document.getElementById("No");
	var regEQ=document.getElementById("RegEQ");
	var StudyNo=document.getElementById("StudyNo");
	var BodyList=document.getElementById("BodyList");
	var RegDate=document.getElementById("RegDate");
	var RegTime=document.getElementById("RegTime");
	var IndexObj=document.getElementById("CurrIndex");
	var tem=Info.split("^");
	No.value=tem[0];
	StudyNo.value=tem[1];
    MainDoc.text=tem[2];
	MainDoc.value=tem[3];
	AssiantDoc.text=tem[4];
	AssiantDoc.value=tem[5];
	regEQ.text=tem[6];
	regEQ.value=tem[7];
	RegDate.value=tem[8];
	RegTime.value=tem[9];
	IndexObj.value=tem[10];
	var BodyInfo=tem[11];
	tem1=BodyInfo.split("@");
	var Nums=tem1[0];    //多少个部位
	var tem2=tem1[1].split("~");
	for (i=0;i<Nums;i++)
	{
		var Index =BodyList.options.length;
		var BodyInfo=tem2[i].split(":");
		var objSelected = new Option(BodyInfo[1],BodyInfo[0]);
		BodyList.options[Index]=objSelected;
	}
	
}

function GetInputRegInfo()
{
	var resource=document.getElementById("BookedResource");
	var AssiantDoc=document.getElementById('DoctorA');
	if (AssiantDoc.value=="") AssiantDoc.text="";
	var MainDoc=document.getElementById("MainDoctor");
	if (MainDoc.value=="") MainDoc.text="";
	var No=document.getElementById("No");
	var OeordDR=document.getElementById("orditemrowid");
	var paadr=document.getElementById("EpisodeID");
	var regEQ=document.getElementById("RegEQ");
	if (regEQ.value=="")regEQ.text=""
	var RegLOC=document.getElementById("LoginLocID")
	var SSUSERDr=document.getElementById("LoginUserID");
	var StudyNo=document.getElementById("StudyNo");
	var IndexOBJ=document.getElementById("CurrIndex");
	var weight=document.getElementById("weight");
	var INPNO=document.getElementById("INPNO");
	var TelNo=document.getElementById("TelNo");
	
	gInfo=resource.text+"^"+AssiantDoc.text+"^"+MainDoc.text+"^"+No.value+"^"+OeordDR.value+"^"+paadr.value+"^"+regEQ.text+"^"+RegLOC.value+"^"+SSUSERDr.value+"^"+StudyNo.value+"^"+IndexOBJ.value+"^"+weight.value+"^"+INPNO.value+"^"+TelNo.value;
   	var bodypartlist=document.getElementById('BodyList'); 
	glen =bodypartlist.options.length ;
	gbodyinfo="";
	for (i=0;i<glen;i++)
	{
		gbodyinfo+=bodypartlist[i].value+"^";
	}

}
function Reg_click()
{
	  
	if (greginfo!="")
	{
		alert(t['cantregister']);
		return;
	}
	var regEQ=document.getElementById("RegEQ");
	if (regEQ.value=="")
	{
		var Ans=confirm(t['HaventInput'])
		if (Ans==false) {return false;}
	
	}
	GetInputRegInfo(); //获得输入信息
	var Getsertinfo=document.getElementById("InsertInfo").value;
	var ret=cspRunServerMethod(Getsertinfo,gInfo,glen,gbodyinfo);
   
 	if (ret=="0")
	{  
		var CreateType=document.getElementById("GetCreateType").value
    	var IsAuto=cspRunServerMethod(CreateType);
    	if (IsAuto=="1")   //自动产生方式
    	{
	  		var UpdateNumber=document.getElementById("updateNumber").value;
	   		var ret=cspRunServerMethod(UpdateNumber,gnorowid,gnumber);
    	}
	   alert(t['registersuccess']);
	   
	   if (IniPrintObj)
	  {
		//alert("print");
		//session['LOGON.USERNAME']='检查登记测试';
		PatientName=document.getElementById("Name").value;
	    PatientID=document.getElementById("PatientID1").value;
	 		
		var WardName=document.getElementById("WardName").value;
		var BedName=document.getElementById("BedName").value
		var OptionDoc=session['LOGON.USERNAME'];
		var MainDoc=document.getElementById("MainDoctor").value;
		
		var TotalPrice=document.getElementById("TotalPrice").value;
		var ItemName=document.getElementById("ItemName").value;
		var Num=document.getElementById("Num").value;
		var Price=document.getElementById("Price").value;
		
	 	
	 	var printinfo1=PatientID+"^"+PatientName+"^"+WardName+"^"+BedName;
	 	var printinfo2=OptionDoc+"^"+gLocName+"^"+MainDoc+"^"+TotalPrice+"^"+ItemName+"^"+Num+"^"+Price;
     	var printinfo=printinfo1+"^"+printinfo2;
     	alert(printinfo);
     	printOBj.PrintRegInfo1(t['HOSPNAME'],printinfo);// "00002345^龚平^345-23^核磁扫描^GEHC^2006-10-09^18:00");
	  }
	   //SendMessageToHL7Server("NW");
	   
	}
	else
	   alert(t['registerFailure']);
	
	   
	var regObj=document.getElementById("Close");
	if (regObj)
	{
		regObj.click();
	}

	
}
function Modi_click()
{
	if (greginfo=="")
	{
		alert(t['canntmodi']);
		return;
	}
	GetInputRegInfo(); //获得输入信息
	
	var Getupdateinfo=document.getElementById("updateinfo").value;
	var ret=cspRunServerMethod(Getupdateinfo,gInfo,glen,gbodyinfo);
    if (ret=="0")
	{  
		var CreateType=document.getElementById("GetCreateType").value
    	var IsAuto=cspRunServerMethod(CreateType);
    	if (IsAuto=="1")   //自动产生方式
    	{
	  		var UpdateNumber=document.getElementById("updateNumber").value;
	   		var ret=cspRunServerMethod(UpdateNumber,gnorowid,gnumber);
    	}
       SendMessageToHL7Server("RU");
	   alert(t['modisuccess']);
	}
	else
	   alert(t['modiFailure']+" SQLCODE="+ret);
	   
	var regObj=document.getElementById("Close");
	if (regObj)
	{
		regObj.click();
	}

}

function SendMessageToHL7Server(Action)
{
	var PatientName=document.getElementById("Name").value;
	var PatientID=document.getElementById("PatientID1").value;
	var Sex=document.getElementById("Sex").value;
	var DOB=document.getElementById("birthday").value;

	var MainDoc=document.getElementById("MainDoctor").value;
    var regEQ=document.getElementById("RegEQ").value;
	var StudyNo=document.getElementById("StudyNo").value;
    var ItemName=document.getElementById("ItemName").value;
	
	if ((HL7Obj)&&((regEQ=="GEHC")||(regEQ=="CT64")))
	{
		//alert("send");
		
	  HL7Obj.SendModalityInfo(PatientID,PatientName,DOB,Sex,StudyNo,"","",MainDoc,"","","",regEQ,Action);
	}
	else if (IniPrintObj)
	{
		//alert("print");
	 var printinfo=PatientID+"^"+PatientName+"^"+StudyNo+"^"+ItemName+"^"+regEQ+"^^"
     printOBj.PrintRegInfo(t['HOSPNAME'],printinfo);// "00002345^龚平^345-23^核磁扫描^GEHC^2006-10-09^18:00");
	}   
	
}

function GetProvCareInfo(str)
{
	var obj=document.getElementById('MainDoctor');
	var tem=str.split("^");
	obj.value=tem[0];
	obj.text=tem[1];
} 

function GetAProvCareInfo(str)
{
	var obj=document.getElementById('DoctorA');
	var tem=str.split("^");
	obj.value=tem[0];
	obj.text=tem[1];
	
} 

function AddBodyParts(info)
{
	
	BodyParttem=info.split("^");
	var bodypartlist=document.getElementById('BodyList'); 
	var Index =bodypartlist.options.length ;
	
	for (i=0;i<Index;i++)
	{
		if (bodypartlist[i].text==BodyParttem[0]) return;
	}
	var objSelected = new Option(BodyParttem[0], BodyParttem[1]);
	bodypartlist.options[Index]=objSelected;
	

}
function GetEQInfo(info)
{
    var obj=document.getElementById('RegEQ');
	var tem=info.split("^");
	obj.value=tem[0];
	obj.text=tem[1];
	var LocDr=document.getElementById("LoginLocID").value;
	var EQDR=document.getElementById("RegEQ").text;
	var GetStudyNo=document.getElementById("GetStudyNo").value;
	var strStudyNo=cspRunServerMethod(GetStudyNo,EQDR,LocDr);
    if (strStudyNo!="")
    {
	  var tem=strStudyNo.split("^");
	  gnorowid=tem[0];
	  gprefix=tem[1];
	  gnumber=tem[2];
	  var StudyNo=document.getElementById("StudyNo");
	  StudyNo.value=gprefix+gnumber;
    }
	
	
}
function GetIndex()
{
	var GetIndexFunction=document.getElementById("CurrIndex").value
	var LocDr=document.getElementById("LoginLocID").value;
	var Index=cspRunServerMethod(GetIndexFunction,LocDr);
	document.getElementById("CurrIndex").value=Index
 
}
function GetStudyNo()
{
	var CreateType=document.getElementById("GetCreateType").value
    var IsAuto=cspRunServerMethod(CreateType);
    if (IsAuto=="1")   //自动产生方式
    {
	    var LocDr=document.getElementById("LoginLocID").value;
	    var EQDR=document.getElementById("RegEQ").text;
	    var GetStudyNo=document.getElementById("GetStudyNo").value;
	    if (LocDr)
	    	LocDr=LocDr;
	    else
	        LocDr="";
	    if (EQDR)
	    	EQDR=EQDR;
	    else
	    	EQDR="";
		var strStudyNo=cspRunServerMethod(GetStudyNo,EQDR,LocDr);
		
		if (strStudyNo=="")
		{			
			var oeorditemrowid=document.getElementById("orditemrowid").value;
			var GetAcessionNumber=document.getElementById("StudyNo").value;
			var Acessioninfo=cspRunServerMethod(GetAcessionNumber,oeorditemrowid);
			var StudyNo=document.getElementById("StudyNo");
			StudyNo.value=Acessioninfo;
	    	
		}
		else
		{
			var tem=strStudyNo.split("^");
	    	gnorowid=tem[0];
	    	gprefix=tem[1];
			gnumber=tem[2];
			var StudyNo=document.getElementById("StudyNo");
			StudyNo.value=gprefix+gnumber;
			
		}
	
	
	}
    else   //手工Acession number  做为默认的检查号
    {
	   	var oeorditemrowid=document.getElementById("orditemrowid").value;
		var GetAcessionNumber=document.getElementById("StudyNo").value;
		var Acessioninfo=cspRunServerMethod(GetAcessionNumber,oeorditemrowid);
		var StudyNo=document.getElementById("StudyNo");
		StudyNo.value=Acessioninfo;
    }
}
function printreginfo()
{
	/*var DT=GetDateTime();  //临时取本机日期时间作打印时间
	tblobj=document.getElementById("tDHCRisAppointment");
    var oXL = new ActiveXObject("Excel.Application"); 
        var oWB = oXL.Workbooks.Add(); 
        var oSheet = oWB.ActiveSheet; 
        oSheet.PageSetup.LeftHeader = ""
        oSheet.PageSetup.CenterHeader = ""
        oSheet.PageSetup.RightHeader = ""
        oSheet.PageSetup.LeftFooter = ""
        oSheet.PageSetup.CenterFooter = ""
        oSheet.PageSetup.RightFooter = ""
        oSheet.PageSetup.LeftMargin = oXL.InchesToPoints(0)
        oSheet.PageSetup.RightMargin = oXL.InchesToPoints(0)
        oSheet.PageSetup.TopMargin = oXL.InchesToPoints(0)
        oSheet.PageSetup.BottomMargin = oXL.InchesToPoints(0)
        oSheet.PageSetup.HeaderMargin = oXL.InchesToPoints(0)
        oSheet.PageSetup.FooterMargin = oXL.InchesToPoints(0)


   		oXL.Cells.Select; 
		oXL.Selection.Font.Name = t['font']; 
		oXL.Selection.Font.Size = 12;
		oXL.Columns("A:A").ColumnWidth = 100;
		var printinfo2=printinfo.split("^")
		oXL.Cells(1,1).Select;
		oXL.Selection.Font.Size = 14;
		oSheet.cells(1,1).value=t['Title']; 
		oSheet.cells(2,1).value=t['regNo']+printinfo2[0];
		oSheet.cells(3,1).value=t['Name']+printinfo2[1];
		oSheet.cells(4,1).value=t['ItemName']+printinfo2[2];
		oSheet.cells(5,1).value=t['EQ']+printinfo2[3];
		oSheet.cells(6,1).value=t['AppDate']+printinfo2[4];
		oSheet.cells(7,1).value=t['AppTime']+ printinfo2[5];
		oSheet.cells(8,1).value=t['printTime']+ DT;
		oXL.Visible = false; //true; lgl 0609+ 
		oSheet.printout;
	 	oWB.Close(savechanges=false);
	 	oXL=null;
	 	oSheet=null;
	 //		curPrintObject.PrintBookedItem(Title,printinfo);
	 */
}
document.body.onload = BodyLoadHandler;