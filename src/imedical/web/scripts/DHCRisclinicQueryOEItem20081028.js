//DHCRisclinicQueryOEItem
var CurrentSel=0
var PatientID,StudyNo,OEOrdItem;
var RptParm,ImgParm;
var IsPublish;
//TRegNo^TStudyNo^TItemName^TItemDate^TItemStatus^TOEOrderDr^TIsIll^TLocName^TreplocDr^TIshasImg^TMediumName^TImgBrowse^TImgShut^TOpenRpt
function BodyLoadHandler() 
{
  //alert("load");
}
function ShowCurRecord(CurRecord)
{
	var selectrow=CurRecord;
	var SelRowObj;
	var obj;
	PatientID=document.getElementById('TRegNo'+'z'+selectrow).innerText;
	StudyNo=document.getElementById('TStudyNo'+'z'+selectrow).innerText;
	
	//alert(StudyNo);
	//var file= "ftp://" + "pacs" + ":" + "pacs" + "@" + "172.16.1.53" + SelRowObj;
	//window.open(file,'report','height=600, width=800,scrollbars=yes location=NO');
	


}
function SelectRowHandler()
{
   var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisclinicQueryOEItem');
	if (objtbl) { var rows=objtbl.rows.length; }
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	
	CurrentSel=selectrow;
	
	PatientID=document.getElementById('TRegNo'+'z'+selectrow).innerText;
	StudyNo=document.getElementById('TStudyNo'+'z'+selectrow).innerText;
	// 地坛医院心电科传入医嘱号
	OEOrdItem=document.getElementById('TOEOrderDr'+'z'+selectrow).innerText;
	
	IsPublish=document.getElementById('TItemStatus'+'z'+selectrow).innerText;
	
	//TImgBrowse^TImgShut^TOpenRpt
	var browsezlink='TImgBrowsez'+selectrow;
	var closezlink='TImgShutz'+selectrow;
	var reportzlink='TOpenRptz'+selectrow;
	
	var LocDr=document.getElementById('TreplocDr'+'z'+selectrow).innerText;
	
   	if (eSrc.id==browsezlink)
  	{
	  	var LocDr=document.getElementById('TreplocDr'+'z'+selectrow).innerText;
		GetImgParm(LocDr);
		if(ImgParm!=" ")
		{
			var curRptObject = new ActiveXObject("wscript.shell");
	   		curRptObject.run(ImgParm);
			return false;
		}
		else
		{
			//var ViewObject = new ActiveXObject("CallVPXCom.CallVpx.1");	
			//ViewObject.LoadPatientStudyImages(PatientID,StudyNo); //PatientID
			var file="http://10.1.1.10/pacs/Main.asp? PID="+PatientID;
      window.open(file,'report','height=600, width=800,scrollbars=yes location=NO');
			return false;			
		}
		
		

  	}
  	else if (eSrc.id==closezlink)
  	{
	    var ViewObject = new ActiveXObject("CallVPXCom.CallVpx.1");	

		ViewObject.ExitVPX();
		return false;
	  
	}
  	else if (eSrc.id==reportzlink)
  	{	
  		//alert(eSrc.id) ; 	
	  	var LocDr=document.getElementById('TreplocDr'+'z'+selectrow).innerText;
		
	  	if (IsPublish!="Y")
	  	{
		  	alert(t["NotPublish"]);
		  	return false;
		  	
	  	}
	   	
	  GetRptParm(LocDr);
	  
	  	var curRptObject = new ActiveXObject("wscript.shell");
	   	//alert(RptParm);
		//window.open(RptParm,'report','height=600, width=800,scrollbars=yes location=NO');
		
		var myary=RptParm.split(":");
		var rtn=myary[0];
		
		if (rtn=="http")
		{
			
			window.open(RptParm,'report','height=600, width=800,scrollbars=yes location=NO');
			return false;
		}
		else
		{
			curRptObject.run(RptParm);
		}
		
		return false;
  	}
  	else
  	{
	
	}
}
function bodyunload()
{
	//alert("unload");
}
function tttt(value){
	alert(value);
}
function GetRptParm(cLocDr)
{
	RptParm = "";
	var Ins=document.getElementById('GetClinicSet');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };

	var Info=cspRunServerMethod(encmeth,cLocDr);

	
	//var GetClinicSetFunction=document.getElementById("GetClinicSet").value;
	//alert('GetRptParm:'+cLocDr+"     "+GetClinicSetFunction);
	//var Info=cspRunServerMethod(GetClinicSetFunction,cLocDr);
	
	//alert(Info);

	//window.event.cancelBubble;	

	var Infolist=Info.split("^");
	
	var ReportFullFil,RhasReg,RRegParam,RhasStudyNo,RStuyParam,RDelim;
 	ReportFullFil=Infolist[0];
  	RhasReg=Infolist[1];
    RRegParam=Infolist[2];
	RhasStudyNo=Infolist[3];
	RStuyParam=Infolist[4];
	RDelim=Infolist[5];
	
	if (RhasReg=="Y")
	{
		
		RptParm = RRegParam+PatientID;
		
	}
	if (RDelim!="")
	{
		RptParm = RptParm + RDelim;
	}
	if (RhasStudyNo=="Y")
	{
		
		if(StudyNo==" ")
		{
			
			RptParm = RptParm + RStuyParam + OEOrdItem;
			
		}
		else
		{
			
			RptParm = RptParm + RStuyParam + StudyNo;

		}
		
	}
	RptParm = ReportFullFil+ RptParm;

	
}
function GetImgParm(cLocDr)
{
	ImgParm = "";
	var GetClinicSetFunction=document.getElementById("GetClinicSet").value;
	var Info=cspRunServerMethod(GetClinicSetFunction,cLocDr);
	
	var Infolist=Info.split("^");
	var ImageFullFile,IhasReg,IRegParam,IhasStudyNo,IStudyNoParam,IDelim;
 	ImageFullFile=Infolist[6];
  	IhasReg=Infolist[7];
    IRegParam=Infolist[8];
	IhasStudyNo=Infolist[9];
	IStuyParam=Infolist[10];
	//alert(IStuyParam);
	IDelim=Infolist[11];
	if (IhasReg=="Y")
	{
		ImgParm = IRegParam+PatientID;
	}
	if (IDelim!="")
	{
		ImgParm = ImgParm + IDelim;
	}
	if (IhasStudyNo=="Y")
	{
		if(StudyNo==" ")
		{
			ImgParm = ImgParm + IStuyParam +OEOrdItem;	
		}
		else
		{
			ImgParm = ImgParm + IStuyParam +StudyNo;
			
		}
	}
	ImgParm = ImageFullFile + " " + ImgParm;
	
}
document.body.onload = BodyLoadHandler;
document.body.onunload= bodyunload;
