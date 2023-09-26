//DHCRisclinicQueryOEItem
var CurrentSel=0
var PatientID,StudyNo,OEOrdItem;
var RptParm,ImgParm;
var LocDr;
var objXMLHTTP;
var IOtherParam;
var Ticket="";
var UserID="";
var LoginLocID="";
var SaveInfo="";



function BodyLoadHandler() 
{
  //alert("load");
  var episodeDesc=document.getElementById("episodeList").value;
  if (episodeDesc=="")
  {
	  var eipsodeId=document.getElementById("EpisodeID").value;
	  var desc=tkMakeServerCall("web.DHCRisclinicQueryOEItemDo","getEpisodeDesc",eipsodeId);
	  //alert(desc);
	  document.getElementById("episodeList").value=desc;
  }
  
}
function ShowCurRecord(CurRecord)
{
	var selectrow=CurRecord;
	var SelRowObj;
	var obj;
	PatientID=document.getElementById('TRegNo'+'z'+selectrow).innerText;
	StudyNo=document.getElementById('TStudyNo'+'z'+selectrow).innerText;
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
	// 地坛医院心电科传入医嘱号
	OEOrdItem=document.getElementById('TOEOrderDr'+'z'+selectrow).innerText;
    var OEOrdItemID=OEOrdItem;
	StudyNo=document.getElementById('TStudyNo'+'z'+selectrow).innerText;
	OrdName=document.getElementById('TItemName'+'z'+selectrow).innerText;
	LocDr=document.getElementById('TreplocDr'+'z'+selectrow).innerText;
	LoginLocID=session["LOGON.CTLOCID"];
	UserID=session['LOGON.USERID'];
	

	var IsPublish=document.getElementById('TItemStatus'+'z'+selectrow).innerText;
	if(IsPublish=="未检查")
	{
		alert(IsPublish);
	}
    
    SaveInfo=LocDr+"^"+LoginLocID+"^"+PatientID+"^"+StudyNo+"^"+UserID+"^"+OEOrdItemID;

	var browsezlink='TImgBrowsez'+selectrow;
	var closezlink='TImgShutz'+selectrow;
	var reportzlink='TOpenRptz'+selectrow;
	//var Gradezlink='Gradez'+selectrow;
	
	
   	if (eSrc.id==browsezlink)
  	{
	  	var OtherParam=document.getElementById('TOtherParam'+'z'+selectrow).value;
	   	
		GetImgParm(LocDr,"");
		
		if((ImgParm!=" ")&&(ImgParm!=""))
		{
			
			    var ret=SaveRecord("I");
		        if (ret!="0")
		        {
			        alert("保存浏览图像记录error!");
			        return false;
			    }
		        var ImageItem=ImgParm.split(":");
			    if (ImageItem[0]=="http")
			    {
				    window.open(ImgParm, "newwindow", "height=700, width=900, toolbar= no, menubar=no,  location=no, status=no,top=100,left=300");
			    }
			    else
			    {
				   	var curRptObject = new ActiveXObject("wscript.shell");
					var ret=curRptObject.Exec(ImgParm);
			    }
			    
	            return false;
		}
		else
		{
				var ViewObject = new ActiveXObject("CallVPXCom.CallVpx.1");	
				ViewObject.LoadPatientStudyImages(PatientID,StudyNo); //PatientID
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
        /*var IsSaveGrade=GetGradeFlag(OEOrdItemID);
        if (IsSaveGrade!="Y")
        {
	        alert("您没有对 ["+OrdName+"] 评价图像和报告!");
	    }*/
	    
	 	LocDr=document.getElementById('TreplocDr'+'z'+selectrow).innerText;
	  	if (IsPublish!="Y")
	  	{
		  	//alert(t["NotPublish"]);
		  	//return false;
		  	
	  	}
	   	
	   	GetRptParm(LocDr);
	   
	    if((RptParm!="")&&(RptParm!=" "))
	    {
		        
		        var ret=SaveRecord("R");
		        if (ret!="0")
		        {
			        alert("保存浏览报告记录error!");
			        return false;
			    }
			    var Item=RptParm.split(":")
			    if (Item[0]=="http")
			    {
			       window.open(RptParm, "newwindow", "scrollbars=yes,resizable=yes, height=600, width=800, toolbar=no, menubar=no,location=no,status=no,top=100,left=300");
			    }
			    else 
			    {
				
				 	var curRptObject = new ActiveXObject("wscript.shell");
					//var ret=curRptObject.Exec(RptParm);
					curRptObject.run(RptParm);
		
			    }
			    
		        return false;
		}
		return false;
  	}
  	
  	//Printtest();
}
function bodyunload()
{
	//alert("unload");
}
function tttt(value){
	//alert(value);
}
function GetRptParm(cLocDr)
{
	RptParm = "";
	var Ins=document.getElementById('GetClinicSet');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	//alert('GetRptParm:'+cLocDr+"     "+encmeth);
	var Info=cspRunServerMethod(encmeth,cLocDr);
	
	//var GetClinicSetFunction=document.getElementById("GetClinicSet").value;
	//alert('GetRptParm:'+cLocDr+"     "+GetClinicSetFunction);
	//var Info=cspRunServerMethod(GetClinicSetFunction,cLocDr);
	//alert("Info");
	//window.event.cancelBubble;	

	var Infolist=Info.split("^");
	
	var ReportFullFil,RhasReg,RRegParam,RhasStudyNo,RStuyParam,RDelim,RhasOParam,ROtherParam
 	ReportFullFil=Infolist[0];
  	RhasReg=Infolist[1];
    RRegParam=Infolist[2];
	RhasStudyNo=Infolist[3];
	RStuyParam=Infolist[4];
	RDelim=Infolist[5];
	RhasOParam=Infolist[12];
	ROtherParam=Infolist[13];
	
	//UserID=session['LOGON.USERID'];
	
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
	   // web browse 
	   //RptParm="?LID="+cLocDr+"&SID="+StudyNo
	   
	   //exe browse 
	   //RptParm=""+StudyNo;
	    RptParm="&SID="+StudyNo;
	}
	
	if(RhasOParam=="Y")
	{
	   var OElist1=OEOrdItem.split("||")[0]
	   var OElist2=OEOrdItem.split("||")[1]
	   if(ROtherParam=="DHCC")
	   {
	      //RptParm="?LID="+cLocDr+"&SID="+StudyNo+"&OID="+OEOrdItem
	      RptParm="&LID="+cLocDr+"&SID="+StudyNo+"&OID="+OEOrdItem+"&USERID="+UserID;
	   }
	   else if (ROtherParam!="")
	   {
		   
		    //RptParm=ROtherParam+OEOrdItem
		    RptParm=ROtherParam+OEOrdItem+"&USERID="+UserID;
	   }
	   else
	   {
		    RptParm=OEOrdItem
	   }	   
	}
	
	RptParm = ReportFullFil + RptParm;
	
	if(ReportFullFil=="RptView.DLL")
	{
		RptParm = "RptView.DLL";
	}
	if(ReportFullFil=="PISRptView.DLL")
	{
		RptParm = "PISRptView.DLL";
	}
	
}


function GetImgParm(cLocDr,OtherParam)
{
	ImgParm = "";
	var GetClinicSetFunction=document.getElementById("GetClinicSet").value;
	var Info=cspRunServerMethod(GetClinicSetFunction,cLocDr);
	
	var Infolist=Info.split("^");
	
	var ImageFullFile,IhasReg,IRegParam,IhasStudyNo,IStudyNoParam,IDelim,IhasOtherParam;
 	ImageFullFile=Infolist[6];
  	IhasReg=Infolist[7];
    IRegParam=Infolist[8];
	IhasStudyNo=Infolist[9];
	IStuyParam=Infolist[10];
	IDelim=Infolist[11];
	IOtherParam=Infolist[14];
	IhasOtherParam=Infolist[15];
	
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
			if(IhasOtherParam=="Y")
	        {
		        alert(IhasOtherParam);
				if (IOtherParam=="AGFA")
				{
					ImgParm ="&SID="+StudyNo;
				}
	        }
	        else
	        {
		        ImgParm = ImgParm + IStuyParam +StudyNo;
		    }
			
		}
	}
	if(IhasOtherParam=="Y")
	{
	   var OElist1=OEOrdItem.split("||")[0]
	   var OElist2=OEOrdItem.split("||")[1]
	   if(IOtherParam=="DHCC")
	   {
	      //RptParm="?LID="+cLocDr+"&SID="+StudyNo+"&OID="+OEOrdItem
	      ImgParm="&LID="+cLocDr+"&SID="+StudyNo+"&OID="+OEOrdItem+"&USERID="+UserID;
	   }
	}
	
	ImgParm = ImageFullFile + ImgParm;
	
	
	/*if(IhasOtherParam=="Y")//西门子调阅影像
	{
		alert("1");		
		ImgParm = ImageFullFile+OtherParam;
	}*/
	
}

function GetGradeFlag(OEOrdItemID)
{
	var IsGradeFun=document.getElementById("IsGrade").value;
	var value=cspRunServerMethod(IsGradeFun,OEOrdItemID);
	return value;
}



function CreateXMLHttpRequest()  
{  
    if (window.XMLHttpRequest)
    {
       var objXMLHTTP = new XMLHttpRequest();
    } 
    else if(window.ActiveXObject) 
    {
       var MSXML = new Array('MSXML2.XMLHTTP.5.0', 'MSXML2.XMLHTTP.4.0', 'MSXML2.XMLHTTP.3.0', 'MSXML2.XMLHTTP', 'Microsoft.XMLHTTP');
       for(var n = 0; n < MSXML.length; n ++)
       {
             try 
             {
               var objXMLHTTP = new ActiveXObject(MSXML[n]);
               break;
             } 
             catch(e) 
             {
             }
       }
    }
    
    return objXMLHTTP
}  


function StartRequsest(URL,Param)
{
	var user;
    var password;
    
	var UserInfo=Param.split("^");
	if (UserInfo!="")
	{
		user=UserInfo[0];
		password=UserInfo[1];
	}
	
	objXMLHTTP=CreateXMLHttpRequest();
	objXMLHTTP.onreadystatechange=handleStateChange;
	objXMLHTTP.open("POST",URL, "false",user,password);

    //指定发送的编码
    objXMLHTTP.setRequestHeader("content-Type","text/html;charset=uft-8"); 
    //设置请求头信息
    objXMLHTTP.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    objXMLHTTP.setRequestHeader("Connection", "Keep-Alive");
    //设置为发送给服务器数据
    objXMLHTTP.send(URL+"&user="+user+"&password="+password);

}

function handleStateChange()
{
	if (objXMLHTTP.readyState==4)
	{
		 alert(objXMLHTTP.responseText);
		 alert(objXMLHTTP.status);
		 if (objXMLHTTP.status==200)
		 {
			 //处理报文
			alert(objXMLHTTP.responseText);
			Ticket=objXMLHTTP.responseText;
		 }
	}
}

function SendHttpPost()
{
	var URL="https://172.26.202.201/ticket";
	var Param="agfa\\ticketer^Gr4n73r";
	StartRequsest(URL,Param);
	
	if (Ticket!="")
	{
		objXMLHTTP.open("POST","https://172.26.201.201/?patientID="+PatientID+ "&accessionNumber="+StudyNo+"&ticket="+Ticket+"&theme=epr",true);
	}
	else
	{
		alert("未授权用户不能浏览");
	}
	
}

function SaveRecord(Code)
{
	var ClinicRecordSetFunction=document.getElementById("ClinicRecordSet").value;
	var ret=cspRunServerMethod(ClinicRecordSetFunction,SaveInfo,Code);
	return ret
}

function getEpisode(item)
{
	//alert(item.split("^")[1]);
	document.getElementById("EpisodeID").value=item.split("^")[1];
}

document.body.onload = BodyLoadHandler;
document.body.onunload= bodyunload;
