//DHCPisLiver.js

var bNewPatient = 1;
var tstatuscode=0;
var tclinichistory=""
var ttmrowid="";
var paadmdr="";
var orditemdr="";
var tclsdr="";
var tclscode="11";

function BodyLoadHandler()
{	
    /*
    var ordItemDr=document.getElementById("OEorditemID").value
	if (ordItemDr=="") ordItemDr="336||146"
    document.getElementById("OEorditemID").value=ordItemDr
    orditemdr=ordItemDr
    
    var admDR=document.getElementById("EpisodeID").value
	if (admDR=="") admDR="417"
    document.getElementById("EpisodeID").value=admDR
    paadmdr=admDR
    */
    
    orditemdr=document.getElementById("OEorditemID").value
    paadmdr=document.getElementById("EpisodeID").value
    if(orditemdr=="" || paadmdr=="")
    {
	    return
    }
    
    var POrderValue=document.getElementById("POrditemDR").value
    if(POrderValue=="") 
    {
	    var orditem=orditemdr.split("||")
	    POrderValue="*"+orditem[0]+"-"+orditem[1]+"*"
    }
    document.getElementById("POrditemDR").value=POrderValue
    
    var ComName=document.getElementById("ComponentName")
    if(ComName)
    {
	    ComName.value="DHCPisLiver"
    }

    var AppDateObj=document.getElementById("AppDate")
    if (AppDateObj.value=="")
    	AppDateObj.value=DateDemo()
        
    var SendSheetObj=document.getElementById("SendSheet");
	if (SendSheetObj)
	{
	 	SendSheetObj.onclick=SendSheetClick
	}
	
    var PrintSheetObj=document.getElementById("PrintSheet");
	if (PrintSheetObj)
	{
		PrintSheetObj.onclick=PrintSheetClick
	}
	
  	var CancelSheetObj=document.getElementById("CancelSheet");
	if (CancelSheetObj)
	{
		CancelSheetObj.onclick=CancelSheetClick
	}
	
	var NORMALObj=document.getElementById("bNormal")
	if (NORMALObj)
	{
		NORMALObj.onclick=NORMALClick
		NORMALObj.checked=true
	}
	var UPObj=document.getElementById("bUp")
	if (UPObj)
	{
		UPObj.onclick=UPClick
	}
	var DOWNObj=document.getElementById("bDown")
	if (DOWNObj)
	{
		DOWNObj.onclick=DOWNClick
	}
	
	var SMALLObj=document.getElementById("bSmall")
	if (SMALLObj)
	{
		SMALLObj.onclick=SMALLClick
		SMALLObj.checked=true
	}
	var LARGEObj=document.getElementById("bLarge")
	if (LARGEObj)
	{
		LARGEObj.onclick=LARGEClick
	}
	var TUANKUAIObj=document.getElementById("bTuanKuai")
	if (TUANKUAIObj)
	{
		TUANKUAIObj.onclick=TUANKUAIClick
	}
	
	var JUNYUNObj=document.getElementById("bJunyun")
	if (JUNYUNObj)
	{
		JUNYUNObj.onclick=JUNYUNClick
		JUNYUNObj.checked=true
	}
	var BUJUNYUNObj=document.getElementById("bBujunyun")
	if (BUJUNYUNObj)
	{
		BUJUNYUNObj.onclick=BUJUNYUNClick;
	}
	
	var GetClsdrFun=document.getElementById("GetClsDRbyCode").value;
 	var CLSDR=cspRunServerMethod(GetClsdrFun,tclscode)
    if (CLSDR!="")
	{	  
	 	document.getElementById("ClsDR").value = CLSDR;
	  	tclsdr = CLSDR;
    }

	//get tmrowid
    var GetTmrowidFun=document.getElementById("GetTMrowid").value;
  	var TMROWID=cspRunServerMethod(GetTmrowidFun,orditemdr)
    if (TMROWID!="")
	{   
		ttmrowid = TMROWID;
		document.getElementById("TMRowid").value = TMROWID;
		
		var GetStatusFun=document.getElementById("GetAppStatus").value
		var VS = cspRunServerMethod(GetStatusFun,ttmrowid)
		if(VS!="")
		{
			var item=VS.split("~");
			var GetRSCodeFun=document.getElementById("GetRSCodeByID").value
			var curcode=cspRunServerMethod(GetRSCodeFun,item[0])
			if(curcode=="1")
			{
				tstatuscode=1
				bNewPatient=0
			}
			else
			{
				tstatuscode=2
				bNewPatient=0
			}
		}
		else
		{
			tstatuscode=0;
			bNewPatient=1;
		}
	}
	else
	{
		tstatuscode=0;
		bNewPatient=1;
		
		var TestmasterAddFun=document.getElementById("TestmasterAdd").value
		var TMROWID = cspRunServerMethod(TestmasterAddFun,tclsdr)
		if(TMROWID!="" && TMROWID!="-901")
		{
			ttmrowid = TMROWID;
			document.getElementById("TMRowid").value = TMROWID;
		}
		
		var appinfo="^^^^^^^^^^^^"+orditemdr
		var SetAppFun=document.getElementById("SetAppInfo").value;
		var RECODE=cspRunServerMethod(SetAppFun,appinfo,ttmrowid)
		if(RECODE!="0")
		{
			alert(t['UpdateAppFailure'])
			return
		}
	}
	
	if(tstatuscode==1)
	{
		document.getElementById("SendSheet").disabled=true
	}
	else if(tstatuscode==2)
	{
		document.getElementById("SendSheet").disabled=true
		document.getElementById("CancelSheet").disabled=true
	}
	else
	{
		document.getElementById("CancelSheet").disabled=true
	}
	
	GetPatInfo()
	GetAppInfo()
	SetysDisable()
 }
//设定元素可用不可用的函数 
function SetysDisable()
{
if(bNewPatient==1)
	     {
		    document.getElementById("address").disabled=false
		    document.getElementById("RegNo").disabled=false
	 	  	document.getElementById("ATLInfo").disabled=false
		  	document.getElementById("LiverH").disabled=false
		  	document.getElementById("LiquidH").disabled=false
		  	document.getElementById("Jiliang").disabled=false
	 	  	document.getElementById("OperationH").disabled=false
		  	document.getElementById("ImportH").disabled=false
		  	document.getElementById("YaoH").disabled=false   
		  	document.getElementById("HomeH").disabled=false
		  	//document.getElementById("IllnessH").disabled=false
		  	//document.getElementById("HuayanH").disabled=false
		  	document.getElementById("ASTInfo").disabled=false
		  	document.getElementById("TBilInfo").disabled=false
		  	document.getElementById("DBilInfo").disabled=false  
		  	document.getElementById("PTAInfo").disabled=false
		  	document.getElementById("AKPInfo").disabled=false
		  	document.getElementById("VGTInfo").disabled=false
		  	document.getElementById("AInfo").disabled=false
		  	
		  	document.getElementById("GInfo").disabled=false
		    document.getElementById("SelfishInfo").disabled=false
	 	  	document.getElementById("HYOtherInfo").disabled=false
		  	//document.getElementById("BYXJCInfo").disabled=false
		  	document.getElementById("HBsAgInfo").disabled=false
		  	document.getElementById("HBsAbInfo").disabled=false
	 	  	document.getElementById("HBeAgInfo").disabled=false
		  	document.getElementById("HBeAbInfo").disabled=false
		  	document.getElementById("KHBcIgMInfo").disabled=false   
		  	document.getElementById("HBVDNAInfo").disabled=false
		  	document.getElementById("KHAVIgMInfo").disabled=false
		  	document.getElementById("KHCVInfo").disabled=false
		  	document.getElementById("HCVRNAInfo").disabled=false
		  	document.getElementById("KHEVInfo").disabled=false
		  	document.getElementById("KHDVInfo").disabled=false  
		  	document.getElementById("KHGVInfo").disabled=false
		  	//document.getElementById("BICHAOINFO").disabled=false
		  	document.getElementById("LeftLiveHou").disabled=false
		  	document.getElementById("LeftLiverChang").disabled=false
		  	
		  	document.getElementById("RightLiverXie").disabled=false
		    //document.getElementById("BackInfo").disabled=false
	 	  	document.getElementById("bNormal").disabled=false
		  	document.getElementById("bUp").disabled=false
		  	document.getElementById("bDown").disabled=false
		  	//document.getElementById("LightInfo").disabled=false
	 	  	document.getElementById("bSmall").disabled=false
		  	document.getElementById("bLarge").disabled=false
		  	document.getElementById("bTuanKuai").disabled=false   
		  	//document.getElementById("SparseInfo").disabled=false
		  	document.getElementById("bJunyun").disabled=false
		  	document.getElementById("bBujunyun").disabled=false
		  	document.getElementById("MJMNJInfo").disabled=false
		  	document.getElementById("PJMNJInfo").disabled=false
		  	document.getElementById("PZHInfo").disabled=false  
		  	document.getElementById("ClinicDiag").disabled=false
		  	document.getElementById("JCOther").disabled=false
		  	document.getElementById("HBcAbInfo").disabled=false
	     }
         else
	     {
		    document.getElementById("address").disabled=true
		    document.getElementById("RegNo").disabled=true
	 	  	document.getElementById("ATLInfo").disabled=true
		  	document.getElementById("LiverH").disabled=true
		  	document.getElementById("LiquidH").disabled=true
		  	document.getElementById("Jiliang").disabled=true
	 	  	document.getElementById("OperationH").disabled=true
		  	document.getElementById("ImportH").disabled=true
		  	document.getElementById("YaoH").disabled=true   
		  	document.getElementById("HomeH").disabled=true
		  	//document.getElementById("IllnessH").disabled=true
		  	//document.getElementById("HuayanH").disabled=true
		  	document.getElementById("ASTInfo").disabled=true
		  	document.getElementById("TBilInfo").disabled=true
		  	document.getElementById("DBilInfo").disabled=true  
		  	document.getElementById("PTAInfo").disabled=true
		  	document.getElementById("AKPInfo").disabled=true
		  	document.getElementById("VGTInfo").disabled=true
		  	document.getElementById("AInfo").disabled=true
		  	
		  	document.getElementById("GInfo").disabled=true
		    document.getElementById("SelfishInfo").disabled=true
	 	  	document.getElementById("HYOtherInfo").disabled=true
		  	//document.getElementById("BYXJCInfo").disabled=true
		  	document.getElementById("HBsAgInfo").disabled=true
		  	document.getElementById("HBsAbInfo").disabled=true
	 	  	document.getElementById("HBeAgInfo").disabled=true
		  	document.getElementById("HBeAbInfo").disabled=true
		  	document.getElementById("KHBcIgMInfo").disabled=true   
		  	document.getElementById("HBVDNAInfo").disabled=true
		  	document.getElementById("KHAVIgMInfo").disabled=true
		  	document.getElementById("KHCVInfo").disabled=true
		  	document.getElementById("HCVRNAInfo").disabled=true
		  	document.getElementById("KHEVInfo").disabled=true
		  	document.getElementById("KHDVInfo").disabled=true  
		  	document.getElementById("KHGVInfo").disabled=true
		  	//document.getElementById("BICHAOINFO").disabled=true
		  	document.getElementById("LeftLiveHou").disabled=true
		  	document.getElementById("LeftLiverChang").disabled=true
		  	
		  	document.getElementById("RightLiverXie").disabled=true
		    //document.getElementById("BackInfo").disabled=true
	 	  	document.getElementById("bNormal").disabled=true
		  	document.getElementById("bUp").disabled=true
		  	document.getElementById("bDown").disabled=true
		  	//document.getElementById("LightInfo").disabled=true
	 	  	document.getElementById("bSmall").disabled=true
		  	document.getElementById("bLarge").disabled=true
		  	document.getElementById("bTuanKuai").disabled=true   
		  	//document.getElementById("SparseInfo").disabled=false
		  	document.getElementById("bJunyun").disabled=true
		  	document.getElementById("bBujunyun").disabled=true
		  	document.getElementById("MJMNJInfo").disabled=true
		  	document.getElementById("PJMNJInfo").disabled=true
		  	document.getElementById("PZHInfo").disabled=true  
		  	document.getElementById("ClinicDiag").disabled=true
		  	document.getElementById("JCOther").disabled=true
		  	document.getElementById("HBcAbInfo").disabled=true
		 }   	
}
 
function GetPatInfo()
{
	if(bNewPatient==1)
	{
		var GetPaadmInfoFun=document.getElementById("GetAdmInfo").value;
  		var PATINFO=cspRunServerMethod(GetPaadmInfoFun,paadmdr)
    	if (PATINFO!="")
		{   
			var item=PATINFO.split("^")
			
			//RegNo,Name,strDOB,strAge,$g(SexDesc),patienttype,typedesc 7
			//$g(LocName),IPNO,wardname,bedname,$g(Locdr),SexDr,WardDr, 14
			//roomdesc,feetype,Docdr,DocName,Telphone,Height,Weight, 21
			//address,SEXDR,feetypedr 24
    		document.getElementById("RegNo").value=item[0]
			document.getElementById("Name").value=item[1]
			
			//2008-5-1-----1/5/2008 ??
			var vdate3=item[2]
			var ChangDFun=document.getElementById("Date3To4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("DOB").value=vdate4

			document.getElementById("Age").value=item[3]
			
			//sex dr??
			document.getElementById("Sex").value=item[4]
			document.getElementById("SexDr").value=item[22]

			document.getElementById("TelNo").value=item[18]
			document.getElementById("address").value=item[21]

			document.getElementById("Admtype").value=item[6]
			document.getElementById("AdmtypeDR").value=item[5]

			document.getElementById("FeeType").value=item[15]
			document.getElementById("CharegetypeDR").value=item[23]

			document.getElementById("InpoNo").value=item[8]
			document.getElementById("RoomNo").value=item[9]
			document.getElementById("BedNo").value=item[10]
			
			document.getElementById("AppLoc").value=item[7]
        	document.getElementById("AppLocDR").value=item[11]
		}
	}
	else
	{
		var GetPatInfoFun=document.getElementById("GetPatInfo").value
  		var PATINFO=cspRunServerMethod(GetPatInfoFun,ttmrowid)
    	if (PATINFO!="")
		{   
			var item=PATINFO.split("^")
			//paadmDr,name,nameP,sexDr,birthDate,admType,chargeType 7
			//,address,tel,IPNo,AdmNo,room,bedNo 13
    		document.getElementById("RegNo").value=item[9]
			document.getElementById("Name").value=item[1]
			
			var vdate3=item[4]
			var ChangDFun=document.getElementById("Date3To4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("DOB").value=vdate4
			//document.getElementById("Age").value="";
			
			var titem1=item[3].split("~")
			document.getElementById("Sex").value=titem1[1]
			document.getElementById("SexDr").value=titem1[0]
			
			document.getElementById("TelNo").value=item[8]
			document.getElementById("address").value=item[7]
			
			var titem2=item[5].split("~")
			document.getElementById("Admtype").value=titem2[1]
			document.getElementById("AdmtypeDR").value=titem2[0]
		
			var titem3=item[6].split("~")
			document.getElementById("FeeType").value=titem3[1]
			document.getElementById("CharegetypeDR").value=titem3[0]

			document.getElementById("RoomNo").value=item[11]
			document.getElementById("BedNo").value=item[12]
			document.getElementById("InpoNo").value=item[10]
		}
		
		var GetPaadmInfoFun=document.getElementById("GetAdmInfo").value
  		var PATINFO=cspRunServerMethod(GetPaadmInfoFun,paadmdr)
    	if (PATINFO!="")
		{   
			var item=PATINFO.split("^");
			//RegNo,Name,strDOB,strAge,$g(SexDesc),patienttype,typedesc 7
			//$g(LocName),IPNO,wardname,bedname,$g(Locdr),SexDr,WardDr, 14
			//roomdesc,feetype,Docdr,DocName,Telphone,Height,Weight,address 22
			document.getElementById("Age").value=item[3]
		}
	}
}

function GetAppInfo()
{
	if(bNewPatient==1)
	{
		var GetDiagInfoFun=document.getElementById("GetMainDiaginfo").value
  		var DIAGINFO=cspRunServerMethod(GetDiagInfoFun,paadmdr)
    	if (DIAGINFO!="")
		{   
			var item=DIAGINFO.split("~")
			//Info_DiagDR,DiagName,
    		document.getElementById("ClinicDiag").value=DIAGINFO
		}
		
		var GetOrdInfoFun=document.getElementById("GetOrditemInfo").value
  		var ORDERINFO=cspRunServerMethod(GetOrdInfoFun,orditemdr)
    	if (ORDERINFO!="")
		{   
			var item=ORDERINFO.split("^");
			//arcimid,strOrderName,strDate,strTime,requestdoc,ssusrdr, 6
			//strAccessionNum,SGroupDesc,subCatDesc,CatDesc,ifbed,price 12
			//Num,TotalPrice,billed,$g(ItemStatusCode),$g(ServerMaterial) 17
			//RecLocdr,$g(ResultFlag),strCommon,RecLocDesc 21
    		//document.getElementById("AppLoc").value=item[20]
        	//document.getElementById("AppLocDR").value=item[17]
			
			//document.getElementById("AppDoc").value=item[4];//dln 20081101 为了解决打印报¨m_CPMPrintAry未定义〃的问题
			if((item[4]).match(/.+\s+/)==null)
				document.getElementById("AppDoc").value=item[4]
			else
			{
				var item4=item[4].split("\s")
				document.getElementById("AppDoc").value=item4[0]
			}
			document.getElementById("AppDocDR").value=item[5]
		}
	}
	else
	{
		var GetAppInfoFun=document.getElementById("GetAppInfo").value
  		var APPINFO=cspRunServerMethod(GetAppInfoFun,ttmrowid)
    	if (APPINFO!="")
		{   
			var item=APPINFO.split("^");
			//frost,clinicRecord,operResult,tumourInfo,womenInfo,relClinic, 6
			//appDeptDr,appDept,appDate,appTime,appDocDr,appDoc,orderDr 13
    		item7=item[7].split("-")
    		document.getElementById("AppLoc").value=item7[1]
        	document.getElementById("AppLocDR").value=item[6]
		
			document.getElementById("AppDoc").value=item[11]
			document.getElementById("AppDocDR").value=item[10]
			
						
			var vdate3=item[8]
			var ChangDFun=document.getElementById("Date3To4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("AppDate").value=vdate4
			
			document.getElementById("ClinicDiag").value=item[5]
			
			tclinichistory = item[1]
			SplitClinicHistroy()
		}
	}	
}

 //Cancel Click 
 function CancelSheetClick()
 {
	 if (document.getElementById("CancelSheet").disabled==true)
	 return
	 var Ans=confirm(t['DeleteSend'])
	 if (Ans==false)
	 {
		 return
     }
     
     var CancelSendFunction=document.getElementById("TestmasterDelete").value
     var CANCODE=cspRunServerMethod(CancelSendFunction,ttmrowid)
     if (CANCODE!="0")
     {
	     alert(t['DELETEFAILURE'])
	     return 
	 }

     Refresh()
 }
 
 function SendSheetClick()
 {
	GetClinicHistory()
	
	if(tclinichistory=="")
	{
		alert(t['NOTNULL'])
		return
	}
	
	var tempobj=document.getElementById('TMRowid').value;
	if (tempobj=="") 
	{
		alert(t['NOTNULL'])
		return
	}
	
	SetPatInfo()
	SetAppInfo()
	SetSpecimenInfo()
	SetAppStatus()
	CommonPrint(t['PRINTSHAPE'])
	Refresh()
 }
 
 function SetPatInfo()
 {
	 if(bNewPatient==1)
	 {
		 var patinfo=""
		 
		 var ndob=document.getElementById('DOB').value
		 var ChangDFun=document.getElementById("Date4To3").value
		 var vdate3=cspRunServerMethod(ChangDFun,ndob)

		 patinfo+=paadmdr+"^"
		 patinfo+=document.getElementById('AdmtypeDR').value+"^"
		 patinfo+=document.getElementById('Name').value+"^^"
		 patinfo+=document.getElementById('CharegetypeDR').value+"^"
		 patinfo+=document.getElementById('SexDr').value+"^"
		 patinfo+=vdate3+"^"
		 patinfo+=document.getElementById('address').value+"^"
		 patinfo+=document.getElementById('RegNo').value+"^"
		 patinfo+=document.getElementById('InpoNo').value+"^"
		 patinfo+=document.getElementById('RoomNo').value+"^"
		 patinfo+=document.getElementById('BedNo').value+"^"
		 patinfo+=document.getElementById('TelNo').value+"^"
		 
	     var SetPatInfoFun=document.getElementById("SetPatInfo").value;
   	     var PATCODE=cspRunServerMethod(SetPatInfoFun,patinfo,ttmrowid)
  	   	 if (PATCODE!="0")
  	   	 {
	  	   	alert['UpdatePatFailure']
	  	   	return
  	   	 }
	 }
 }
 
 function SetAppInfo()
 {
	 if(bNewPatient==1)
	 {
		 var appinfo=""
		 var tdiag=document.getElementById("ClinicDiag").value
		 
		 appinfo+=tclinichistory+"^^^^"
		 appinfo+=tdiag+"^"+"0"+"^^^"
		 appinfo+=document.getElementById('AppLoc').value+"^"
		 appinfo+=document.getElementById('AppLocDR').value+"^"
		 appinfo+=document.getElementById('AppDoc').value+"^"
		 appinfo+=document.getElementById('AppDocDR').value+"^"+orditemdr
	 
	     var SetAppInfoFun=document.getElementById("SetAppInfo").value
   	     var APPCODE=cspRunServerMethod(SetAppInfoFun,appinfo,ttmrowid)
  	   	 if (APPCODE!="0")
  	   	 {
	  	   	alert['UpdateAppFailure']
	  	   	return
  	   	 }
	 }
 }
 
 function SetSpecimenInfo()
 {
	 if(bNewPatient==1)
	 {
		 var tspeinfo=""
		 tspeinfo+=ttmrowid+"^"+"1"+"^"+t['LIVERSPECIMEN']+"^^^^"
	 
	     var SetSpeInfofun=document.getElementById("SetSpecimenInfo").value
 	     var tsperowid=cspRunServerMethod(SetSpeInfofun,tspeinfo)
  	   	 if (tsperowid=="")
  	   	 {
	  	   	alert['UpdateSpeFailure']
	  	   	return
  	   	 }
	 }
 }
 
 function SetAppStatus()
 {
	 if(bNewPatient==1)
	 {
		 var trscode="1"
		 var trsid=""
		 
		 var GetRsIDFun=document.getElementById("GetRSidByCode").value;
		 var vid=cspRunServerMethod(GetRsIDFun,trscode)
		 if(vid!="")
		 {
			 trsid=vid
			  
			 var SetStatusInfo=document.getElementById("SetStatusInfo").value;
   	     	 var rcode=cspRunServerMethod(SetStatusInfo,trsid,ttmrowid)
  	   	 	 if (rcode!="0")
  	   	 	 {
	  	   		alert['UpdateStatusFailure']
	  	   		return
  	   	 	 }
  	   	 	 
  	   	 	 //ChangRISStatus
			var docdr=document.getElementById("AppDocDR").value
			var ChangeStatusInfo=document.getElementById("ChangeRISStatus").value;

			var rriscode=cspRunServerMethod(ChangeStatusInfo,orditemdr,docdr)
			if (rriscode!="0")
			{
				alert['UpdateStatusFailure']
				return
			}

		}		 
	 }
 }
 
 //clear windows
 function Refresh()
 {
	var ComponentName=document.getElementById("ComponentName").value
	var EpisodeID=document.getElementById("EpisodeID").value
	var OEorditemID=document.getElementById("OEorditemID").value
	var TMrowid=document.getElementById("TMrowid").value
	var Refresh=document.getElementById("Refresh").value
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+ComponentName+"&EpisodeID="+EpisodeID+"&OEorditemID="+OEorditemID+"&TMrowid="+TMrowid+"&ComponentName="+ComponentName+"&Refresh="+Refresh
    location.href=lnk
}

function DateDemo()
{
   var d, s="";          
   d = new Date(); 
   var sDay="",sMonth="",sYear="";
   sDay = d.getDate();			
   if(sDay < 10)
   sDay = "0"+sDay;
    
   sMonth = d.getMonth()+1;	
   if(sMonth < 10)
   sMonth = "0"+sMonth;
   
   sYear  = d.getYear()
   s = sDay + "/" + sMonth + "/" + sYear;   
   return(s); 
}

function PrintSheetClick()
{
	//save useful info to tempGLOBAL
	//start print
	//delete tempGLOBAL	
	//document.getElementById("bFuxcxye").value = 1;
	//CommonPrint("DHCPisAppCell");
	if(bNewPatient==1)
	{
		alert(t['NPrint'])
		return	
	}
	CommonPrint(t['PRINTSHAPE'])
}

function NORMALClick()
{
	var TEMPObj=document.getElementById("bNormal");
	if (TEMPObj.checked)
	{
	  //document.getElementById("bNormal").checked = false;
	  document.getElementById("bUp").checked=false;
	  document.getElementById("bDown").checked=false;
	}
}

function UPClick()
{
	var TEMPObj=document.getElementById("bUp");
	if (TEMPObj.checked)
	{
	  document.getElementById("bNormal").checked = false;
	  //document.getElementById("bUp").checked=false;
	  document.getElementById("bDown").checked=false;
	}
}

function DOWNClick()
{
	var TEMPObj=document.getElementById("bDown");
	if (TEMPObj.checked)
	{
	  document.getElementById("bNormal").checked = false;
	  document.getElementById("bUp").checked=false;
	  //document.getElementById("bDown").checked=false;
	}

}

function SMALLClick()
{
	var TEMPObj=document.getElementById("bSmall");
	if (TEMPObj.checked)
	{
	  //document.getElementById("bSmall").checked = false;
	  document.getElementById("bLarge").checked=false;
	  document.getElementById("bTuanKuai").checked=false;
	}
}
		
function LARGEClick()
{
	var TEMPObj=document.getElementById("bLarge");
	if (TEMPObj.checked)
	{
	  document.getElementById("bSmall").checked = false;
	  //document.getElementById("bLarge").checked=false;
	  document.getElementById("bTuanKuai").checked=false;
	}
}

function TUANKUAIClick()
{
	var TEMPObj=document.getElementById("bTuanKuai");
	if (TEMPObj.checked)
	{
	  document.getElementById("bSmall").checked = false;
	  document.getElementById("bLarge").checked=false;
	  //document.getElementById("bTuanKuai").checked=false;
	}
}

function JUNYUNClick()
{
	var TEMPObj=document.getElementById("bJunyun");
	if (TEMPObj.checked)
	{
	  //document.getElementById("bJunyun").checked = false;
	  document.getElementById("bBujunyun").checked=false;
	}
}

function BUJUNYUNClick()
{
	var TEMPObj=document.getElementById("bBujunyun");
	if (TEMPObj.checked)
	{
	  document.getElementById("bJunyun").checked = false;
	  //document.getElementById("bBujunyun").checked=false;
	}
}

//;;;;;;~;;;;;;;;;;~;;;;;;;;;;;;;~;;;;;;;;	
function GetClinicHistory()
{
	tclinichistory=""
	var thistory=""
	var thuayan=""
	var tjance=""
	var tbchao=""
	
	var tempobj=document.getElementById("LiverH")
	if(tempobj.value!="")
	{
		thistory+=tempobj.value
	}
	thistory+=";"
	
	var tempobj=document.getElementById("LiquidH")
	if(tempobj.value!="")
	{
		thistory+=tempobj.value
	}
	thistory+=";"
	
	var tempobj=document.getElementById("Jiliang")
	if(tempobj.value!="")
	{
		thistory+=tempobj.value
	}
	thistory+=";"
	
	var tempobj=document.getElementById("OperationH")
	if(tempobj.value!="")
	{
		thistory+=tempobj.value
	}
	thistory+=";"
	
	var tempobj=document.getElementById("ImportH")
	if(tempobj.value!="")
	{
		thistory+=tempobj.value
	}
	thistory+=";"
	
	var tempobj=document.getElementById("YaoH")
	if(tempobj.value!="")
	{
		thistory+=tempobj.value
	}
	thistory+=";"
	
	var tempobj=document.getElementById("HomeH")
	if(tempobj.value!="")
	{
		thistory+=tempobj.value
	}
	thistory+=";"
	
	//
	var tempobj=document.getElementById("ATLInfo")
	if(tempobj.value!="")
	{
		thuayan+=tempobj.value
	}
	thuayan+=";"

	var tempobj=document.getElementById("ASTInfo")
	if(tempobj.value!="")
	{
		thuayan+=tempobj.value
	}
	thuayan+=";"
	
	var tempobj=document.getElementById("TBilInfo")
	if(tempobj.value!="")
	{
		thuayan+=tempobj.value
	}
	thuayan+=";"
	
	var tempobj=document.getElementById("DBilInfo")
	if(tempobj.value!="")
	{
		thuayan+=tempobj.value
	}
	thuayan+=";"
	
	var tempobj=document.getElementById("PTAInfo")
	if(tempobj.value!="")
	{
		thuayan+=tempobj.value
	}
	thuayan+=";"
	
	var tempobj=document.getElementById("AKPInfo")
	if(tempobj.value!="")
	{
		thuayan+=tempobj.value
	}
	thuayan+=";"

	var tempobj=document.getElementById("VGTInfo")
	if(tempobj.value!="")
	{
		thuayan+=tempobj.value
	}
	thuayan+=";"
	
	var tempobj=document.getElementById("AInfo")
	if(tempobj.value!="")
	{
		thuayan+=tempobj.value
	}
	thuayan+=";"
	
	var tempobj=document.getElementById("GInfo")
	if(tempobj.value!="")
	{
		thuayan+=tempobj.value
	}
	thuayan+=";"
	
	var tempobj=document.getElementById("SelfishInfo")
	if(tempobj.value!="")
	{
		thuayan+=tempobj.value
	}
	thuayan+=";"
	
	var tempobj=document.getElementById("HYOtherInfo")
	if(tempobj.value!="")
	{
		thuayan+=tempobj.value
	}
	thuayan+=";"
	
	//tjance=""
	var tempobj=document.getElementById("HBsAgInfo")
	if(tempobj.value!="")
	{
		tjance+=tempobj.value
	}
	tjance+=";"
	
	var tempobj=document.getElementById("HBsAbInfo")
	if(tempobj.value!="")
	{
		tjance+=tempobj.value
	}
	tjance+=";"
	
	var tempobj=document.getElementById("HBeAgInfo")
	if(tempobj.value!="")
	{
		tjance+=tempobj.value
	}
	tjance+=";"
	
	var tempobj=document.getElementById("HBeAbInfo")
	if(tempobj.value!="")
	{
		tjance+=tempobj.value
	}
	tjance+=";"

	var tempobj=document.getElementById("HBcAbInfo")
	if(tempobj.value!="")
	{
		tjance+=tempobj.value
	}
	tjance+=";"
	
	var tempobj=document.getElementById("KHBcIgMInfo")
	if(tempobj.value!="")
	{
		tjance+=tempobj.value
	}
	tjance+=";"

	var tempobj=document.getElementById("HBVDNAInfo")
	if(tempobj.value!="")
	{
		tjance+=tempobj.value
	}
	tjance+=";"
	
	var tempobj=document.getElementById("KHAVIgMInfo")
	if(tempobj.value!="")
	{
		tjance+=tempobj.value
	}
	tjance+=";"

	var tempobj=document.getElementById("KHCVInfo")
	if(tempobj.value!="")
	{
		tjance+=tempobj.value
	}
	tjance+=";"
	
	var tempobj=document.getElementById("HCVRNAInfo")
	if(tempobj.value!="")
	{
		tjance+=tempobj.value
	}
	tjance+=";"
	
	var tempobj=document.getElementById("KHEVInfo")
	if(tempobj.value!="")
	{
		tjance+=tempobj.value
	}
	tjance+=";"
	
	var tempobj=document.getElementById("KHDVInfo")
	if(tempobj.value!="")
	{
		tjance+=tempobj.value
	}
	tjance+=";"
	
	var tempobj=document.getElementById("KHGVInfo")
	if(tempobj.value!="")
	{
		tjance+=tempobj.value
	}
	tjance+=";"
	
	var tempobj=document.getElementById("JCOther")
	if(tempobj.value!="")
	{
		tjance+=tempobj.value
	}
	tjance+=";"
		
	//tbchao
	var tempobj=document.getElementById("LeftLiveHou")
	if(tempobj.value!="")
	{
		tbchao+=tempobj.value
	}
	tbchao+=";"
	
	var tempobj=document.getElementById("LeftLiverChang")
	if(tempobj.value!="")
	{
		tbchao+=tempobj.value
	}
	tbchao+=";"
	
	var tempobj=document.getElementById("RightLiverXie")
	if(tempobj.value!="")
	{
		tbchao+=tempobj.value
	}
	tbchao+=";"
	
	var thuisheng=""
	var tempobj=document.getElementById("bNormal")
	if (tempobj.checked)
	{
	  thuisheng = t['ZHENGCHANG']
	}
	
	var tempobj=document.getElementById("bUp")
	if (tempobj.checked)
	{
	  thuisheng = t['ZENGQIANG']
	}

	var tempobj=document.getElementById("bDown")
	if (tempobj.checked)
	{
	  thuisheng = t['SHUAIJIAN']
	}
	tbchao+=thuisheng+";"
	
	var tguangdian=""
	var tempobj=document.getElementById("bSmall")
	if (tempobj.checked)
	{
	  tguangdian = t['XIXIAO']
	}
	
	var tempobj=document.getElementById("bLarge")
	if (tempobj.checked)
	{
	  tguangdian = t['ZENGCU']
	}

	var tempobj=document.getElementById("bTuanKuai")
	if (tempobj.checked)
	{
	  tguangdian = t['TUANKUAIZHUANG']
	}
	tbchao+=tguangdian+";"
	
	var tfenbu=""
	var tempobj=document.getElementById("bJunyun")
	if (tempobj.checked)
	{
	  tfenbu = t['JUNYUN']
	}

	var tempobj=document.getElementById("bBujunyun")
	if (tempobj.checked)
	{
	  tfenbu = t['BUJUNYUN']
	}
	tbchao+=tfenbu+";"
	
	var tempobj=document.getElementById("MJMNJInfo")
	if (tempobj.value!="")
	{
	  tbchao += tempobj.value
	}
	tbchao+=";"

	var tempobj=document.getElementById("PJMNJInfo")
	if (tempobj.value!="")
	{
	  tbchao += tempobj.value
	}
	tbchao+=";"
	
	var tempobj=document.getElementById("PZHInfo")
	if (tempobj.value!="")
	{
	  tbchao += tempobj.value
	}
	tbchao+=";"
	
	tclinichistory=thistory+"~"+thuayan+"~"+tjance+"~"+tbchao
}

function SplitClinicHistroy()
{
	var item=tclinichistory.split("~")
	var thistory=item[0]
	var thuayan=item[1]
	var tjance=item[2]
	var tbchao=item[3]
	
	//
	var item=thistory.split(";")
	document.getElementById("LiverH").value=item[0]
	document.getElementById("LiquidH").value=item[1]
	document.getElementById("Jiliang").value=item[2]
	document.getElementById("OperationH").value=item[3]
	document.getElementById("ImportH").value=item[4]
	document.getElementById("YaoH").value=item[5]
	document.getElementById("HomeH").value=item[6]
	
	var item=thuayan.split(";")
	document.getElementById("ATLInfo").value=item[0]
	document.getElementById("ASTInfo").value=item[1]
	document.getElementById("TBilInfo").value=item[2]
	document.getElementById("DBilInfo").value=item[3]
	document.getElementById("PTAInfo").value=item[4]
	document.getElementById("AKPInfo").value=item[5]	
	document.getElementById("VGTInfo").value=item[6]
	document.getElementById("AInfo").value=item[7]
	document.getElementById("GInfo").value=item[8]
	document.getElementById("SelfishInfo").value=item[9]
	document.getElementById("HYOtherInfo").value=item[10]
	
	var item=tjance.split(";")
	document.getElementById("HBsAgInfo").value=item[0]
	document.getElementById("HBsAbInfo").value=item[1]
	document.getElementById("HBeAgInfo").value=item[2]
	document.getElementById("HBeAbInfo").value=item[3]
	document.getElementById("HBcAbInfo").value=item[4]
	document.getElementById("KHBcIgMInfo").value=item[5]
	document.getElementById("HBVDNAInfo").value=item[6]
	document.getElementById("KHAVIgMInfo").value=item[7]
	document.getElementById("KHCVInfo").value=item[8]
	document.getElementById("HCVRNAInfo").value=item[9]
	document.getElementById("KHEVInfo").value=item[10]
	document.getElementById("KHDVInfo").value=item[11]
	document.getElementById("KHGVInfo").value=item[12]
	document.getElementById("JCOther").value=item[13]
	
	var item=tbchao.split(";")
	document.getElementById("LeftLiveHou").value=item[0]
	document.getElementById("LeftLiverChang").value=item[1]
	document.getElementById("RightLiverXie").value=item[2]
	
	document.getElementById("bNormal").checked=false
	document.getElementById("bUp").checked=false
	document.getElementById("bDown").checked=false
	var thuisheng=item[3]
	if(thuisheng==t['ZHENGCHANG'])
	{
		document.getElementById("bNormal").checked=true
	}
	else if(thuisheng=t['ZENGQIANG'])
	{
		document.getElementById("bUp").checked=true
	}
	else
	{
		document.getElementById("bDown").checked=true
	}
	
	document.getElementById("bSmall").checked=false
	document.getElementById("bLarge").checked=false
	document.getElementById("bTuanKuai").checked=false
	var tguangdian=item[4]
	if(tguangdian==t['XIXIAO'])
	{
		document.getElementById("bSmall").checked=true
	}
	else if(tguangdian==t['ZENGCU'])
	{
		document.getElementById("bLarge").checked=true
	}
	else
	{
		document.getElementById("bTuanKuai").checked=true
	}
	
	document.getElementById("bJunyun").checked=false
	document.getElementById("bBujunyun").checked=false
	var tfenbu=item[5]
	if(tfenbu==t['JUNYUN'])
	{
		document.getElementById("bJunyun").checked=true
	}
	else
	{
		document.getElementById("bBujunyun").checked=true
	}

	document.getElementById("MJMNJInfo").value=item[6]
	document.getElementById("PJMNJInfo").value=item[7]
	document.getElementById("PZHInfo").value=item[8]
}

document.body.onload = BodyLoadHandler;