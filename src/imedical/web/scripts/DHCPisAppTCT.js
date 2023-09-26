//DHCPisAppTCT.js

var bNewPatient = 1
var tstatuscode=0
var tclinichistory=""
var ttmrowid=""
var paadmdr=""
var orditemdr=""
var tclsdr=""
var tclscode="23"
var Locdr=""
function BodyLoadHandler()
{	
    orditemdr=document.getElementById("OEorditemID").value
    paadmdr=document.getElementById("EpisodeID").value
    Locdr=document.getElementById("RecLocDR").value
   
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
	    ComName.value="DHCPisAppTCT"
    }

    var AppDateObj=document.getElementById("AppDate")
    if (AppDateObj.value=="")
    	AppDateObj.value=DateDemo()
        
    var SendSheetObj=document.getElementById("SendSheet")
	if (SendSheetObj)
	{
	 	SendSheetObj.onclick=SendSheetClick
	}
	
    var PrintSheetObj=document.getElementById("PrintSheet")
	if (PrintSheetObj)
	{
		PrintSheetObj.onclick=PrintSheetClick
	}
	
	//var PrintBarObj=document.getElementById("PrintBarApp")
   	//{
	   	//PrintBarObj.onclick=PrintBarAppkey
	//}
	var PrintAppObj=document.getElementById("PrintApp")
   	{
	   	PrintAppObj.onclick=PrintAppkey
	}
	
  	var CancelSheetObj=document.getElementById("CancelSheet")
	if (CancelSheetObj)
	{
		CancelSheetObj.onclick=CancelSheetClick
	}
	var JUEJINGOBJ=document.getElementById("bJuejing")
	if (JUEJINGOBJ)
	{
		JUEJINGOBJ.onclick=JuejingClick
	}
	if(document.getElementById("bOther").checked==false)
	{
		
	    document.getElementById("bSupplement").disabled=true
	}
	var OTHEROBJ=document.getElementById("bOther")
	if (OTHEROBJ)
	{
		OTHEROBJ.onclick=OtherClick
	}

	var GetClsdrFun=document.getElementById("GetClsDRbyCode").value
 	var CLSDR=cspRunServerMethod(GetClsdrFun,tclscode)
 	//alert("mlh:"+CLSDR);
    if (CLSDR!="")
	{	  
	 	document.getElementById("ClsDR").value = CLSDR
	  	tclsdr = CLSDR;
    }
	//get tmrowid
    var GetTmrowidFun=document.getElementById("GetTMrowid").value
    //alert("mlh0:"+orditemdr);
  	var TMROWID=cspRunServerMethod(GetTmrowidFun,Locdr,orditemdr)
  	//alert("mlh1:"+TMROWID);
    if (TMROWID!="")
	{   
		ttmrowid = TMROWID
		document.getElementById("TMRowid").value = TMROWID
	
		var GetStatusFun=document.getElementById("GetAppStatus").value
		var VS = cspRunServerMethod(GetStatusFun,ttmrowid)

		if(VS!="")
		{
			var item=VS.split("~")
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
			tstatuscode=0
			bNewPatient=1
		}
	}
	else
	{
		tstatuscode=0
		bNewPatient=1
		
		var TestmasterAddFun=document.getElementById("TestmasterAdd").value
		var TMROWID = cspRunServerMethod(TestmasterAddFun,Locdr,tclsdr)
		//alert("mlh7:"+tclsdr);
		//alert("mlh8:"+TMROWID);
		if(TMROWID!="" && TMROWID!="-901")
		{
			ttmrowid = TMROWID
			document.getElementById("TMRowid").value = TMROWID
		}
		
		var appinfo="^^^^^^^^^^^^"+orditemdr
		var SetAppFun=document.getElementById("SetAppInfo").value
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
		//document.getElementById("PrintBarApp").disabled=true
		document.getElementById("PrintApp").disabled=true
		document.getElementById("PrintSheet").disabled=true
	}
	
	GetPatInfo()
	if(document.getElementById("AdmType").value==t['TJBR'])
	{
	  document.getElementById("bOther").checked=true
	  document.getElementById("bSupplement").value="无"
	  document.getElementById("bSupplement").disabled=false
	
    }
	GetAppInfo()
	GetAllWomanInfo()

 }
 
function GetPatInfo()
{
	if(bNewPatient==1)
	{
		var GetPaadmInfoFun=document.getElementById("GetAdmInfo").value;
  		var PATINFO=cspRunServerMethod(GetPaadmInfoFun,paadmdr)
    	if (PATINFO!="")
		{   
			var item=PATINFO.split("^");
			//RegNo,Name,strDOB,strAge,$g(SexDesc),patienttype,typedesc 7
			//$g(LocName),IPNO,wardname,bedname,$g(Locdr),SexDr,WardDr, 14
			//roomdesc,feetype,Docdr,DocName,Telphone,Height,Weight, 21
			//address,SEXDR,feetypedr 24
    		document.getElementById("RegNo").value=item[0];
			document.getElementById("Name").value=item[1];

			//2008-5-1-----1/5/2008 ??
			var vdate3=item[2]
			var ChangDFun=document.getElementById("Date3To4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("DOB").value=vdate4;
			
			document.getElementById("Age").value=item[3];
			
			//sex dr??
			document.getElementById("Sex").value=item[4];
			document.getElementById("SexDr").value=item[22];
			
			document.getElementById("TelNo").value=item[18];
			document.getElementById("address").value=item[21];
			
			document.getElementById("Admtype").value=item[6];
			document.getElementById("AdmtypeDR").value=item[5];
		
			document.getElementById("FeeType").value=item[15];
			document.getElementById("CharegetypeDR").value=item[23];
			
			document.getElementById("InpoNo").value=item[8];
			document.getElementById("RoomNo").value=item[9];
			document.getElementById("BedNo").value=item[10];
			
    	document.getElementById("AppLoc").value=item[7];
		  document.getElementById("AppLocDR").value=item[11];
		}
	}
	else
	{	
		var GetPatInfoFun=document.getElementById("GetPatInfo").value;
  		var PATINFO=cspRunServerMethod(GetPatInfoFun,ttmrowid)
    	if (PATINFO!="")
		{   
			var item=PATINFO.split("^");
			//paadmDr,name,nameP,sexDr,birthDate,admType,chargeType 7
			//,address,tel,IPNo,AdmNo,room,bedNo 13
    		document.getElementById("RegNo").value=item[9];
			document.getElementById("Name").value=item[1];
			
			var vdate3=item[4]
			var ChangDFun=document.getElementById("Date3To4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("DOB").value=vdate4;
			//document.getElementById("Age").value="";
			
			var titem1=item[3].split("~")
			document.getElementById("Sex").value=titem1[1];
			document.getElementById("SexDr").value=titem1[0];
			
			document.getElementById("TelNo").value=item[8];
			document.getElementById("address").value=item[7];
			
			var titem2=item[5].split("~")
			document.getElementById("Admtype").value=titem2[1];
			document.getElementById("AdmtypeDR").value=titem2[0];
		
			var titem3=item[6].split("~")
			//document.getElementById("FeeType").value=titem3[1];//20080926发现发送后带不回来费别 dln 修改
			document.getElementById("CharegetypeDR").value=titem3[0]
			
			document.getElementById("RoomNo").value=item[11];
			document.getElementById("BedNo").value=item[12];
			document.getElementById("InpoNo").value=item[10];
		}
		var sex=document.getElementById("Sex").value
		if(sex!=t['SEXNV'])
		{
			alert(t['SEXWRONG'])
			return		
		}
		var GetPaadmInfoFun=document.getElementById("GetAdmInfo").value;
  		var PATINFO=cspRunServerMethod(GetPaadmInfoFun,paadmdr)
    	if (PATINFO!="")
		{   
			var item=PATINFO.split("^");
			//RegNo,Name,strDOB,strAge,$g(SexDesc),patienttype,typedesc 7
			//$g(LocName),IPNO,wardname,bedname,$g(Locdr),SexDr,WardDr, 14
			//roomdesc,feetype,Docdr,DocName,Telphone,Height,Weight,address 22
			document.getElementById("Age").value=item[3];
			document.getElementById("FeeType").value=item[15]//把发送后的费别带回
		}
	}
}

function GetAppInfo()
{
	if(bNewPatient==1)
	{
		var GetDiagInfoFun=document.getElementById("GetMainDiaginfo").value
		
  		var DIAGINFO=cspRunServerMethod(GetDiagInfoFun,paadmdr)
    	//if (DIAGINFO!="")   delete by lff 2008-09-10
		//{   
		//	var item=DIAGINFO.split("~")
		//	alert(item[0])
		//	//Info_DiagDR,DiagName,
    	//	document.getElementById("bSupplement").value=item[1]
		//}
        
		var GetOrdInfoFun=document.getElementById("GetOrditemInfo").value;
  		var ORDERINFO=cspRunServerMethod(GetOrdInfoFun,orditemdr)
  		//alert("1"+ORDERINFO)
    	if (ORDERINFO!="")
		{   
		    
			var item=ORDERINFO.split("^");
			//arcimid,strOrderName,strDate,strTime,requestdoc,ssusrdr, 6
			//strAccessionNum,SGroupDesc,subCatDesc,CatDesc,ifbed,price 12
			//Num,TotalPrice,billed,$g(ItemStatusCode),$g(ServerMaterial) 17
			//RecLocdr,$g(ResultFlag),strCommon,RecLocDesc 21
			//
			
			//document.getElementById("AppDoc").value=item[4];//dln 20081101 为了解决打印报?m_CPMPrintAry未定义?的问题
			if((item[4]).match(/.+\s+/)==null)
				document.getElementById("AppDoc").value=item[4]
			else
			{
				var item4=item[4].split("\s")
				document.getElementById("AppDoc").value=item4[0]
			}
			document.getElementById("AppDocDR").value=item[5];
		}
		
		
		
	}
	else
	{
		var GetAppInfoFun=document.getElementById("GetAppInfo").value;
  		var APPINFO=cspRunServerMethod(GetAppInfoFun,ttmrowid)
  		
    	if (APPINFO!="")
		{   
			var item=APPINFO.split("^");
			//frost,clinicRecord,operResult,tumourInfo,womenInfo,relClinic, 6
			//appDeptDr,appDept,appDate,appTime,appDocDr,appDoc,orderDr 13

    		document.getElementById("AppLoc").value=item[7];
        	document.getElementById("AppLocDR").value=item[6];
			
			document.getElementById("AppDoc").value=item[11];
			document.getElementById("AppDocDR").value=item[10];
			
						
			var vdate3=item[8]
			var ChangDFun=document.getElementById("Date3To4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("AppDate").value=vdate4
			
			document.getElementById("bSupplement").value=item[5]
			
			tclinichistory = item[1]
			SplitClinicHistroy()
		}
	}	
}

function GetAllWomanInfo()
{
	var tsexdes=document.getElementById("Sex").value
	if(tsexdes==t['SEXNV'])
	{
		var GetWomanInfoFun=document.getElementById("GetWomanInfo").value;
  		var WOMANINFO=cspRunServerMethod(GetWomanInfoFun,ttmrowid)
    	if (WOMANINFO!=""&& WOMANINFO!="-901" && WOMANINFO!="-911")
		{   
			var item=WOMANINFO.split("^");
			//finalDate,periodCure,pregnancyTimes,lyingTimes,otherInfo,rowid
			
			var vdate4=""
			if (item[0]!="")
			{
			var ChangDFun=document.getElementById("Date3To4").value
			var vdate4=cspRunServerMethod(ChangDFun,item[0])
			}
			
			document.getElementById("MociYJ").value=vdate4
			if(item[1]=="Y")
			{
			 	document.getElementById("bJuejing").checked=true
			}
			else
			{
				document.getElementById("bJuejing").checked=false
			}
			
			document.getElementById("num_TAI").value=item[2]
			document.getElementById("num_CHAN").value=item[3]
		}
	}
	else
	{
		document.getElementById("MociYJ").disabled=true
	 	document.getElementById("bJuejing").disabled=true
		document.getElementById("num_TAI").disabled=true
		document.getElementById("num_CHAN").disabled=true
	}
	if(bNewPatient!= 1)
	{
		document.getElementById("address").disabled=true
		document.getElementById("MociYJ").disabled=true
		document.getElementById("bJuejing").disabled=true
		document.getElementById("TelNo").disabled=true
		document.getElementById("num_CHAN").disabled=true
		document.getElementById("num_TAI").disabled=true
		document.getElementById("bBuruqi").disabled=true
		document.getElementById("bBuzc").disabled=true
		document.getElementById("bChanh").disabled=true
		document.getElementById("bGongjy").disabled=true
		document.getElementById("bHuaiyun").disabled=true
		document.getElementById("bKoufu").disabled=true
		document.getElementById("bRutlbd").disabled=true
		document.getElementById("bYindy").disabled=true
		document.getElementById("bZgh").disabled=true
		document.getElementById("bZgqc").disabled=true	
	    document.getElementById("bShuhou").disabled=true
	    document.getElementById("bOther").disabled=true 	
		
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
	
	
	var tempobj=document.getElementById('TMRowid').value
	if (tempobj=="") 
	{
		
		alert(t['NOTNULL'])
		return
	}
	
	if ((document.getElementById("bOther").checked==true)&&(document.getElementById("bSupplement").value==""))
	{
		alert(t['OTHERANDSUP'])
		return
	}
	
	var tjjobj=document.getElementById("bJuejing")
	var jjdate=document.getElementById("MociYJ").value
    if(document.getElementById("AdmType").value!=t['TJBR'])
    {  
		if ((tjjobj.checked==false)&&(jjdate==""))
		{
			alert(t['WNOTNULL'])
			return
		}
		if(tclinichistory=="")
		{	
			alert("病人病历"+t['NOTNULL'])
			return
		}
    }
	if ((tjjobj.checked==true)&&(jjdate!=""))
	{
		alert(t['WALLFULL'])
		return
	}

	SetAllPatInfo()
	SetAllAppInfo()
	SetAllSpecimenInfo()
	SetAllWomanInfo()

	SetAppStatus()
	
	//CommonPrint(t['PRINTSHAPE'])
	Refresh()
	
 }
 
 function SetAllPatInfo()
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
 
 function SetAllAppInfo()
 {
	 if(bNewPatient==1)
	 {
		 var appinfo=""
		 
		 if (document.getElementById("bOther").checked==false)
		 {
			var tdiag="" 
		 }
		 else {
		    var tdiag=document.getElementById("bSupplement").value
		 }
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
 
 function SetAllSpecimenInfo()
 {
	 if(bNewPatient==1)
	 {
		 var tspeinfo=""
		 tspeinfo+=ttmrowid+"^"+"1"+"^"+t['TCTSPECIMEN']+"^^^^"
	 
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
	var TMrowid=document.getElementById("TMRowid").value
	var RecLocDR=document.getElementById("RecLocDR").value
	var Refresh=document.getElementById("Refresh").value
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+ComponentName+"&EpisodeID="+EpisodeID+"&OEorditemID="+OEorditemID+"&TMrowid="+TMrowid+"&RecLocDR="+RecLocDR+"&ComponentName="+ComponentName+"&Refresh="+Refresh
    location.href=lnk
}
 
 function SetAllWomanInfo()
 {
	var tsexdes=document.getElementById("Sex").value
	if(tsexdes==t['SEXNV'])
	{
		tjj=""
		var tjjobj=document.getElementById("bJuejing")
		if(tjjobj.checked)
			{
				tjj="Y"
			}
			else
			{
				tjj="N"
			}
		var jjdate=document.getElementById("MociYJ").value
		
		if((jjdate!="" && jjdate!=DateDemo())&&(tjj=="N"))
		{
			var twinfo=""
			twinfo+=ttmrowid+"^"
			
			var DateChangeFun=document.getElementById("Date4To3").value
			var tdate=cspRunServerMethod(DateChangeFun,jjdate)
			twinfo+=tdate+"^"
			
			twinfo+=tjj+"^"
			
			var ttai=document.getElementById("num_TAI").value
			var tchan=document.getElementById("num_CHAN").value
			
			twinfo+=ttai+"^"+tchan+"^"
			
			var SetWomaninfoFun=document.getElementById("SetWomanInfo").value
			var womanid=cspRunServerMethod(SetWomaninfoFun,twinfo)		
			if (womanid=="")
  	   	 	{
	  	   		alert['UpdateWomanFailure']
	  	   		return
  	   	 	}
		}
		
		else if((tjj=="Y")&&(jjdate==""))
		{
			var twinfo=""
		    
			twinfo+=ttmrowid+"^"
			
			//var tdate=""
			twinfo+=jjdate+"^"
			
			twinfo+=tjj+"^"
			
			var ttai=document.getElementById("num_TAI").value
			var tchan=document.getElementById("num_CHAN").value
			
			twinfo+=ttai+"^"+tchan+"^"
			var SetWomaninfoFun=document.getElementById("SetWomanInfo").value
			var womanid=cspRunServerMethod(SetWomaninfoFun,twinfo)		
			if (womanid=="")
  	   	 	{
	  	   		alert['UpdateWomanFailure']
	  	   		return
  	   	 	}
		}
		/*
		var jjdate=document.getElementById("MociYJ").value
		if(jjdate!="" && jjdate!=DateDemo())
		{
			var twinfo=""
		
			twinfo+=ttmrowid+"^"
			
			var DateChangeFun=document.getElementById("Date4To3").value
			var tdate=cspRunServerMethod(DateChangeFun,jjdate)
			twinfo+=tdate+"^"
			
			tjj=""
			var tjjobj=document.getElementById("bJuejing")
			if(tjjobj.checked)
			{
				tjj="Y"
			}
			else
			{
				tjj="N"
			}
			twinfo+=tjj+"^"
			
			var ttai=document.getElementById("num_TAI").value
			var tchan=document.getElementById("num_CHAN").value
			
			twinfo+=ttai+"^"+tchan+"^"
			
			var SetWomaninfoFun=document.getElementById("SetWomanInfo").value
			var womanid=cspRunServerMethod(SetWomaninfoFun,twinfo)		
			if (womanid=="")
  	   	 	{
	  	   		alert['UpdateWomanFailure']
	  	   		return
  	   	 	}
		}
		*/
	}
 
 }
 
function DateDemo()
{
   var d, s="";          
   d = new Date(); 
   var sDay="",sMonth="",sYear="",tYear="";
   sDay = d.getDate();			
   if(sDay < 10)
   sDay = "0"+sDay;
    
   sMonth = d.getMonth()+1;	
   if(sMonth < 10)
   sMonth = "0"+sMonth;
   
   sYear  = d.getYear()
   s = sDay + "/" + sMonth + "/" + sYear 
   return(s); 
}

function PrintSheetClick()
{
	if(bNewPatient)
	{
		alert(t['NPrint'])
		return	
	}
	print();
	//CommonPrint(t['PRINTSHAPE'])
	//save useful info to tempGLOBAL
	//start print
	//delete tempGLOBAL	
}

function GetClinicHistory()
{
	tclinichistory=""

	var tempobj1=document.getElementById("bKoufu")
	if (tempobj1.checked)
	{
	  tclinichistory += t['KOUFU']+","
	}
	
	var tempobj2=document.getElementById("bZgh")
	if (tempobj2.checked)
	{
	  tclinichistory += t['ZIGONGHUAN']+","
	}
	
	var tempobj3=document.getElementById("bHuaiyun")
	if (tempobj3.checked)
	{
	  tclinichistory += t['HUAIYUN']+","
	}
	
	var tempobj4=document.getElementById("bChanh")
	if (tempobj4.checked)
	{
	  tclinichistory += t['CHANHOU']+","
	}
	
	var tempobj5=document.getElementById("bZgqc")
	if (tempobj5.checked)
	{
	  tclinichistory += t['ZIGONGQIECHU']+","
	}
	
	var tempobj6=document.getElementById("bShuhou")
	if (tempobj6.checked)
	{
	  tclinichistory += t['SHOUSHUHOU']+","
	}
	
	var tempobj7=document.getElementById("bBuzc")
	if (tempobj7.checked)
	{
	  tclinichistory += t['BUZHENGCHANG']+","
	}
	
  	var tempobj8=document.getElementById("bRutlbd")
	if (tempobj8.checked)
	{
	  tclinichistory += t['RUTOU']+","
	}
	var tempobj10=document.getElementById("bGongjy")
	if (tempobj10.checked)
	{
	  tclinichistory += t['GONGJINGYAN']+","
	}
	var tempobj11=document.getElementById("bYindy")
	if (tempobj11.checked)
	{
	  tclinichistory += t['YINDAOYAN']+","
	}
	var tempobj12=document.getElementById("bBuruqi")
	if (tempobj12.checked)
	{
	  tclinichistory += t['BURUQI']+","
	}
	
  	var tempobj9=document.getElementById("bOther")
	if (tempobj9.checked)
	{
	  tclinichistory += t['OTHER']+","+document.getElementById("bSupplement").value+","
	  //tclinichistory += t['OTHER']+","
	}
}

function SplitClinicHistroy()
{
	var item=tclinichistory.split(",")
	for(var i=0;i<item.length;i++)
	{
		var tstr=item[i]
		if(tstr==t['KOUFU'])
			document.getElementById("bKoufu").checked=true
		else if(tstr==t['ZIGONGHUAN'])
			document.getElementById("bZgh").checked=true
		else if(tstr==t['HUAIYUN'])
			document.getElementById("bHuaiyun").checked=true
		else if(tstr==t['CHANHOU'])
			document.getElementById("bChanh").checked=true
		else if(tstr==t['ZIGONGQIECHU'])
			document.getElementById("bZgqc").checked=true
		else if(tstr==t['SHOUSHUHOU'])
			document.getElementById("bShuhou").checked=true
		else if(tstr==t['BUZHENGCHANG'])
			document.getElementById("bBuzc").checked=true
		else if(tstr==t['RUTOU'])
			document.getElementById("bRutlbd").checked=true
		else if(tstr==t['BURUQI'])
			document.getElementById("bBuruqi").checked=true
		else if(tstr==t['YINDAOYAN'])
			document.getElementById("bYindy").checked=true
		else if(tstr==t['GONGJINGYAN'])
			document.getElementById("bGongjy").checked=true
		else if(tstr==t['OTHER'])
			document.getElementById("bOther").checked=true
		else
		 ;
	}
}

/*
function KOUFUClick()
{
}

function ZGHClick()
{
}

function HYUNClick()
{
}

function CHANHOUClick()
{
}

function ZGQCClick()
{
}

function ShuhouClick()
{
}

function BuzcClick()
{
}


*/
function JuejingClick()
{
	if(document.getElementById("bJuejing").checked==true)
	{
	    document.getElementById("MociYJ").value=""
	    document.getElementById("MociYJ").disabled=true
	    document.getElementById("MociYJ").style.display="none"
	}
	if(document.getElementById("bJuejing").checked==false)
	{
	    document.getElementById("MociYJ").disabled=false
	    document.getElementById("MociYJ").style.display=""
	}
}

function OtherClick()
{
	if(document.getElementById("bOther").checked==false)
	{
	    document.getElementById("bSupplement").disabled=true
	}
	if(document.getElementById("bOther").checked==true)
	{
	    document.getElementById("bSupplement").disabled=false
	}
}

function print()
{
				var xlApp,xlsheet,xlBook
			    var GetPrescPath=document.getElementById("GetRepPath");
				if (GetPrescPath) {var encmeth=GetPrescPath.value} 
				else {var encmeth=''};
				if (encmeth!="") 
				{
						var TemplatePath=cspRunServerMethod(encmeth);
				}
				//alert(TemplatePath)
				var Template=TemplatePath+"DHCPisAppTCT.xls";
				//alert(Template)
				xlApp = new ActiveXObject("Excel.Application")
				xlBook = xlApp.Workbooks.Add(Template);
			 	xlsheet = xlBook.ActiveSheet;	
 	      xlsheet.cells(2,1).value="*"+document.getElementById("TMRowid").value+"*"
		    xlsheet.cells(4,5).value=document.getElementById("TMRowid").value
	      //xlsheet.cells(4,11).value=document.getElementById("RegNo").value
	      //xlsheet.cells(4,18).value=document.getElementById("OEorditemID").value
	      
	      xlsheet.cells(6,4).value=document.getElementById("Name").value
	  	  xlsheet.cells(6,14).value=document.getElementById("Age").value
	      xlsheet.cells(6,10).value=document.getElementById("Sex").value
	      xlsheet.cells(6,18).value=document.getElementById("DOB").value
	      xlsheet.cells(7,5).value=document.getElementById("TelNo").value
	      xlsheet.cells(7,12).value=document.getElementById("AdmType").value
	      xlsheet.cells(7,18).value=document.getElementById("FeeType").value
	      xlsheet.cells(8,4).value=document.getElementById("address").value
	      xlsheet.cells(9,5).value=document.getElementById("MociYJ").value
	      if(document.getElementById("bJuejing").checked==true)
	    		{xlsheet.cells(9,12).value="是"}
	    	else
	    	{
	    	   xlsheet.cells(9,12).value="否"
				}
	    	xlsheet.cells(9,17).value=document.getElementById("num_TAI").value
	    	xlsheet.cells(9,19).value=document.getElementById("num_CHAN").value
	    	
	    	xlsheet.cells(11,5).value=document.getElementById("AppLoc").value
	    	xlsheet.cells(11,12).value=document.getElementById("AppDoc").value
	    	var ChangDFun=document.getElementById("Date4To3").value
			  var vdate4=cspRunServerMethod(ChangDFun,document.getElementById("AppDate").value)
			  xlsheet.cells(11,18).value=vdate4
	    	//xlsheet.cells(11,18).value=document.getElementById("AppDate").value	
				//alert(document.getElementById("AppDate").value)    	
				
				
	    	
	    	if(document.getElementById("bKoufu").checked==true)
	    		xlsheet.cells(13,1).value="*"
	    	if(document.getElementById("bZgh").checked==true)
		    	xlsheet.cells(13,8).value="*"
		    if(document.getElementById("bBuruqi").checked==true)
		    	xlsheet.cells(13,13).value="*"
		    if(document.getElementById("bHuaiyun").checked==true)
		    	xlsheet.cells(13,18).value="*"
		    
		    if(document.getElementById("bChanh").checked==true)
		    	xlsheet.cells(14,1).value="*"
		    if(document.getElementById("bZgqc").checked==true)
		    	xlsheet.cells(14,8).value="*"
		    if(document.getElementById("bGongjy").checked==true)
		    	xlsheet.cells(14,13).value="*"
		    if(document.getElementById("bShuhou").checked==true)
		    	xlsheet.cells(14,18).value="*"  
		    	
		    if(document.getElementById("bBuzc").checked==true)
		    	xlsheet.cells(15,1).value="*"
		    if(document.getElementById("bRutlbd").checked==true)
		    	xlsheet.cells(15,8).value="*"
		    if(document.getElementById("bYindy").checked==true)
		    	xlsheet.cells(15,13).value="*"
		    if(document.getElementById("bOther").checked==true)
		    	xlsheet.cells(15,18).value="*"
	
	    	
	    	//xlsheet.cells(19,2).value=document.getElementById("bClinicDiag").value
	    	xlsheet.cells(17,1).value=document.getElementById("bSupplement").value
	    	
	    	xlsheet.PrintOut 
	    	xlBook.Close (savechanges=false); 
	    	xlBook=null			
	    	xlApp.Quit();
	    	xlApp=null;
	    	xlsheet=null 
	    	//window.setInterval("Cleanup();",1);
}
function PrintBar() //print lab barcode
{
    var Bar,j;
    Bar= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
    Bar.PrintName="tiaoma";//printer name
    
    
	var RegisterNum=document.getElementById("RegNo").value
	var PName=document.getElementById("Name").value
	var RoomNo=document.getElementById("RoomNo").value
	var RoomNo=RoomNo.split("-")
	var RoomNo=RoomNo[1]
	var BedNo=document.getElementById("BedNo").value
	var AppDep=document.getElementById("AppLoc").value
	var PatLoc=AppDep.split("-")
	var PatLoc=PatLoc[1]
	var GetSpecimensFunc=document.getElementById("autoNumAdd").value
	var info=cspRunServerMethod(GetSpecimensFunc,ttmrowid)
	var tmpList=info.split(";")
	var OrderDr=document.getElementById("OEorditemID").value
	var GetOrderNameFunc=document.getElementById("GetOrderName").value
	var OrderName=cspRunServerMethod(GetOrderNameFunc,OrderDr)
	
    for (j=0;j<tmpList.length-1;j++)
                {
	                //alert(tmpList[j]+","+labNo);continue;
	                var specinfo=tmpList[j]
	                var item=specinfo.split("(")
                   
                    Bar.LabNo=document.getElementById("TMRowid").value;
                    Bar.RecLoc="病理科";
                    //Bar.SpecName=item[0];
                    Bar.PatLoc=PatLoc;
                    //Bar.PatWard=RoomNo;
                    Bar.OrdName=OrderName+"--"+item[0];
                    Bar.PatName=RegisterNum+" "+PName;
                    Bar.Sex=document.getElementById("Sex").value;
                    Bar.Age=document.getElementById("Age").value;
                    Bar.BedCode=BedNo;
                    Bar.PrintOut();
                }
    
    
}
function PrintBarAppkey()
{
	if(document.getElementById("PrintBarApp").disabled==true)
	     return
    PrintBar()
 }
 function PrintAppkey()
{
	if(document.getElementById("PrintApp").disabled==true)
	     return
    PrintApp()
 }
 
 function PrintApp()
{
	  var OrderDr=document.getElementById("OEorditemID").value
	var GetOEorditemFunc=document.getElementById("GetOrditemInfo").value
	var OEorditeminfo=cspRunServerMethod(GetOEorditemFunc,OrderDr)
	var item=OEorditeminfo.split("^")
	var OrderName=item[1]
	var OrderPrice=item[11]
	
	var GetSpecimensFunc=document.getElementById("autoNumAdd").value
	var info=cspRunServerMethod(GetSpecimensFunc,ttmrowid)
	var tmpList=info.split(";")
	
	var xlApp,xlsheet,xlBook
    var GetPrescPath=document.getElementById("GetRepPath");
	if (GetPrescPath) {var encmeth=GetPrescPath.value} 
	else {var encmeth=''};
	if (encmeth!="") 
	   {
			var TemplatePath=cspRunServerMethod(encmeth);
		}
	var Template=TemplatePath+"DHCPISApp.xls";
	xlApp = new ActiveXObject("Excel.Application")
	xlBook = xlApp.Workbooks.Add(Template);
 	xlsheet = xlBook.ActiveSheet;
 	        xlsheet.cells(1,1).value="*"+document.getElementById("TMRowid").value+"*"
	        xlsheet.cells(3,5).value=document.getElementById("RegNo").value
	        xlsheet.cells(3,2).value=document.getElementById("Name").value
	      
	  	    xlsheet.cells(3,10).value=document.getElementById("Sex").value
	        xlsheet.cells(3,7).value=document.getElementById("Age").value
	    	//xlsheet.cells(5,3).value=document.getElementById("RoomNo").value
	    	//xlsheet.cells(5,17).value=document.getElementById("BedNo").value
	    	//xlsheet.cells(6,5).value=document.getElementById("PTel").value
	    	//xlsheet.cells(6,13).value=document.getElementById("PAddress").value
	    	xlsheet.cells(4,8).value=document.getElementById("AppDoc").value
	    	xlsheet.cells(3,12).value=document.getElementById("AppDate").value
	    	xlsheet.cells(4,4).value=document.getElementById("AppLoc").value
	    	xlsheet.cells(6,7).value="病理科"
	    	xlsheet.cells(6,6).value=OrderPrice
	    	xlsheet.cells(6,1).value=OrderName
	    	
	    	for (j=0;j<tmpList.length-1;j++)
                {
	                //alert(tmpList[j]+","+labNo);continue;
	                var specinfo=tmpList[j]
	                //var item=specinfo.split("(")
	                xlsheet.cells(6+j,9).value=specinfo
                }
	    	
	    	
	    	xlsheet.PrintOut 
	    	xlBook.Close (savechanges=false); 
	    	xlBook=null			
	    	xlApp.Quit();
	    	xlApp=null;
	    	xlsheet=null 
	    	//window.setInterval("Cleanup();",1);
}
function PrintAppkey()
{
	if(document.getElementById("PrintApp").disabled==true)
 		return
    PrintApp()

}


document.body.onload = BodyLoadHandler;