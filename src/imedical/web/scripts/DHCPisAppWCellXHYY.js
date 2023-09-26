//DHCPisAppWCellZLYY.js

var bNewPatient = 1
var tstatuscode=0
var tspecimennum=0
var tspecimeninfo=""
var ttmrowid=""
var paadmdr=""
var orditemdr=""
var tclsdr=""
var tclscode="23"
var tclinicrecord=""
var boolvalue=false
var recLocDr=""
//新加变量boolvalue是为了判断末次月经日期和肿瘤发现日期是否是在当前日期
//之后用的
var duihao=String.fromCharCode(8730)
var code1=String.fromCharCode(12300)   //"「"
var code2=String.fromCharCode(12301)   //"」"
var code3=String.fromCharCode(65089)   //"??
var code4=String.fromCharCode(65090)   //"??

var tformName=document.getElementById("TFORM").value; 
var getComponentIdByName=document.getElementById("GetComponentIdByName").value; 
var componentId; 
componentId=cspRunServerMethod(getComponentIdByName,tformName); 

function BodyLoadHandler()
 {	
	 /*
    var ordItemDr=document.getElementById("OEorditemID").value
	if (ordItemDr=="") ordItemDr="241||5"
    document.getElementById("OEorditemID").value=ordItemDr
    orditemdr=ordItemDr
    
    var admDR=document.getElementById("EpisodeID").value
	if (admDR=="") admDR="241"
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

   	document.getElementById("ComponentName").value=tformName
   	
   	var GetOrdInfoFun=document.getElementById("OrderInfo").value
  	var ORDERINFO=cspRunServerMethod(GetOrdInfoFun,orditemdr)
    if (ORDERINFO!="")
		{   
			var item=ORDERINFO.split("^")
			//arcimid,strOrderName,strDate,strTime,requestdoc,ssusrdr, 6
			//strAccessionNum,SGroupDesc,subCatDesc,CatDesc,ifbed,price 12
			//Num,TotalPrice,billed,$g(ItemStatusCode),$g(ServerMaterial) 17
			//RecLocdr,$g(ResultFlag),strCommon,RecLocDesc 21
			recLocDr=item[17]
		}
   	
   	/*
   	var AppDateObj=document.getElementById("AppDate")
    if (AppDateObj.value=="")
    	AppDateObj.value=DateDemo()
    
    	
    var TDateObj=document.getElementById("TumourDate")
    if (TDateObj.value=="")
    	TDateObj.value=DateDemo()
    	
    var WDateObj=document.getElementById("LastCata")
    if (WDateObj.value=="")
    	WDateObj.value=DateDemo()
    */
   	document.getElementById("TransPos").disabled = true;
   	var SendAppobj=document.getElementById("SendApp")
  	 if (SendAppobj)
   	{
		SendAppobj.onclick=SendAppkey
   	}
   
    var SaveAppobj=document.getElementById("SaveApp")
  	 if (SaveAppobj)
   	{
		SaveAppobj.onclick=SaveAppkey
   	}
   	
   	var CancelAppobj=document.getElementById("CancelApp")
   	if (CancelAppobj)
   	{
		CancelAppobj.onclick=CancelAppkey
   	}
   	
   	var PrintObj=document.getElementById("PrintApp")
   	if (PrintObj)
   	{
		PrintObj.onclick=PrintAppkey
   	}
   	
   	var PirntTMKeyObj=document.getElementById("PirntTM")
   	if (PirntTMKeyObj)
   	{
		PirntTMKeyObj.onclick=PirntTMKey
   	}
   	
   	var LiuObj=document.getElementById("bLiuCell")
   	if (LiuObj)
   	{
		LiuObj.onclick=LiuKey
   	}
   	
   	var OtherObj=document.getElementById("bOther")
   	if (OtherObj)
   	{
		OtherObj.onclick=OtherKey
   	}
   	
   	var TumourDateObj=document.getElementById("TumourDate")
   	if (TumourDateObj)
   	{
		TumourDateObj.onblur=TumourDateblur
   	}
   	
   	var SpeNumObj=document.getElementById("SpeNum");
   	if (SpeNumObj)
   	{
		SpeNumObj.onblur=SpeNumblur
   	}
   	
   	var LastDateObj=document.getElementById("LastCata")
   	if (LastDateObj)
   	{
		LastDateObj.onblur=LastDateblur
   	}
   	
   
   	var TransferObj=document.getElementById("Transfer")
   	if(TransferObj)
   	{
		  TransferObj.onclick=TransferKey 	
	}
	
	var EndCataObj=document.getElementById("EndCata")
   	if(EndCataObj)
   	{
		  EndCataObj.onclick=EndCataKey 	
	}
	
	var gjObj=document.getElementById("sGJing")
	if(gjObj)
	{
		 gjObj.onclick=GJClick
	}
		 var gnmObj=document.getElementById("sGGGuan")
		 if(gnmObj)
	{
		 gnmObj.onclick=GNMClick
	}
		 var ydObj=document.getElementById("sYDao")
		 if(ydObj)
	{
		 ydObj.onclick=YDClick
	}
		 var cdObj=document.getElementById("sYDCDuan")
		 if(cdObj)
	{
		 cdObj.onclick=YDCDClick
	}
		 var qlObj=document.getElementById("sQLong")
		 if(qlObj)
	{
		 qlObj.onclick=QLClick
	}
		 var soObj=document.getElementById("sOther")
		 if(soObj)
	{
		 soObj.onclick=SOClick
	}
		 
	
   	var GetClsdrFun=document.getElementById("ClassDr").value
 	var CLSDR=cspRunServerMethod(GetClsdrFun,tclscode)
    if (CLSDR!="")
	{	  
	  	tclsdr=CLSDR
    }
    
 	//get tmrowid
    var GetTmrowidFun=document.getElementById("GetTmRowId").value
  	var TMROWID=cspRunServerMethod(GetTmrowidFun,recLocDr,orditemdr)
    if (TMROWID!="")
	{   
		ttmrowid = TMROWID
		document.getElementById("TMrowid").value = TMROWID
		
		var GetStatusFun=document.getElementById("GetAppStatus").value
		var VS = cspRunServerMethod(GetStatusFun,ttmrowid)
		if(VS!="")
		{
			var item=VS.split("~")
			var GetRSCodeFun=document.getElementById("RsCode").value
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
		
		var TestmasterAddFun=document.getElementById("AddTmInfo").value
		var TMROWID = cspRunServerMethod(TestmasterAddFun,recLocDr,tclsdr)
		if(TMROWID!="" && TMROWID!="-901")
		{
			ttmrowid = TMROWID
			document.getElementById("TMRowid").value = TMROWID
		}
		
		var appinfo="^^^^^^^^^^^^"+orditemdr
		var SetAppFun=document.getElementById("AddAppInfo").value
		var RECODE=cspRunServerMethod(SetAppFun,appinfo,ttmrowid)
		//alert(RECODE+"="+appinfo+"="+ttmrowid)
		if(RECODE!="0")
		{
			alert(t['UpdateAppFailure'])
			return
		}
	}
	
	if(tstatuscode==1)
	{
		document.getElementById("SendApp").disabled=true
		document.getElementById("SaveApp").disabled=true
	}
	else if(tstatuscode==2)
	{
		document.getElementById("SendApp").disabled=true
		document.getElementById("SaveApp").disabled=true
		document.getElementById("CancelApp").disabled=true
	}
	else
	{
		document.getElementById("CancelApp").disabled=true
		document.getElementById("PrintApp").disabled=true
	}
	
	GetPatInfo()
	
	GetAppInfo()
	GetAllSpecimenInfo()
	GetWomanTumourInfo()
	
	ItemDisAble()
 }
 
 function ItemDisAble()
 {
	//修改,针对齐鑫提出来的有了提示还可以填写发送而修改
    	if (document.getElementById("PSex").value!=t['SEXNV'])
		{
			alert(t['IsMen'])
			document.getElementById("TumourPosition").disabled=true
		 	document.getElementById("TumourSize").disabled=true
	 	 	document.getElementById("TumourDate").disabled=true
		 	document.getElementById("RadioCure").disabled=true
		 	document.getElementById("ChemicalCure").disabled=true
		 	document.getElementById("TumourSize").disabled=true
	 	 	document.getElementById("Transfer").disabled=true
		 	document.getElementById("TransPos").disabled=true
		 	document.getElementById("memo").disabled=true
		 	document.getElementById("sGJing").disabled = true
	  	document.getElementById("sGGGuan").disabled=true
	  	document.getElementById("sYDao").disabled=true
     	document.getElementById("sYDCDuan").disabled=true
    	document.getElementById("sQLong").disabled = true
	  	document.getElementById("sOther").disabled=true
	  	document.getElementById("TMrowid").disabled=true
	  	document.getElementById("sOtherInfo").disabled=true	
	  	document.getElementById("bKouFu").disabled=true
		 document.getElementById("bZGHuan").disabled=true
	 	 document.getElementById("bAbnormal").disabled=true
	 	 document.getElementById("bChanHou").disabled=true
	 	 document.getElementById("bHuaiYun").disabled=true
	 	 
	 	 document.getElementById("bBRQi").disabled=true
		 document.getElementById("bRRTLBDu").disabled=true
	 	 document.getElementById("bZGQCShu").disabled=true
	 	 document.getElementById("bLCQCShu").disabled=true
	 	 document.getElementById("bGJZQShu").disabled=true
	 	 
	 	 document.getElementById("bOtherSShu").disabled=true
		 document.getElementById("OtherSShuInfo").disabled=true
		 document.getElementById("ClinicRec1").disabled=true
		 document.getElementById("SaveApp").disabled=true
	 	 document.getElementById("bLiuCell").disabled=true
	 	 document.getElementById("bOther").disabled=true
	 	 document.getElementById("OtherInfo").disabled=true
	 	 document.getElementById("SendApp").disabled=true
		document.getElementById("CancelApp").disabled=true
		document.getElementById("PrintApp").disabled=true
		DisableById(componentId,"LastCata")
    DisableById(componentId,"TumourDate")
		return
		}	 
}
 
 function GetAllSpecimenInfo()
{
	//for (var i=1;i<=6;i++)
	//{
		var speid=ttmrowid+"||"+1
		
		var GetSpeInfoFun=document.getElementById("GetSpecimenInfo").value;
  	var SPEINFO=cspRunServerMethod(GetSpeInfoFun,speid)
  	//alert(SPEINFO)
    	if (SPEINFO=="" || SPEINFO=="-901" || SPEINFO=="-911")
    	{
					//break;
			}
    	else
		{   
	   		//speciNo,speciName,speciExplain,acceptorDr,acceptDate,acceptTime 6
			var item=SPEINFO.split("^");
			var tsname=item[1]
		  
			if(tsname==t['GONGJING'])
			{
				document.getElementById("sGJing").checked=true
			}
			else if(tsname==t['GONGJINGGUAN'])
			{
				document.getElementById("sGGGuan").checked=true
			}		
			else if(tsname==t['YINDAO'])
			{
				document.getElementById("sYDao").checked=true
			}	
			else if(tsname==t['YDCANDUAN'])
			{
				document.getElementById("sYDCDuan").checked=true
			}		
			else if(tsname==t['QIONGLONG'])
			{
				document.getElementById("sQLong").checked=true
			}		
			else 
			{
				document.getElementById("sOther").checked=true
				document.getElementById("sOtherInfo").value=tsname
			}
			document.getElementById("SpeNum").value=item[2].split("~")[0]
      //alert(document.getElementById("SpeNum").value)		
		}
	//}

	if(bNewPatient==1)
	{
		document.getElementById("TMrowid").disabled=true
		document.getElementById("sGJing").disabled = false
	  	document.getElementById("sGGGuan").disabled=false
	  	document.getElementById("sYDao").disabled=false
     	document.getElementById("sYDCDuan").disabled=false
    	document.getElementById("sQLong").disabled = false
	  	document.getElementById("sOther").disabled=false
	  	document.all("TransPos").style.display="none"//???
	  	document.getElementById("sOtherInfo").disabled=false
	}
	else
	{
		document.getElementById("sGJing").disabled = true
	  	document.getElementById("sGGGuan").disabled=true
	  	document.getElementById("sYDao").disabled=true
     	document.getElementById("sYDCDuan").disabled=true
    	document.getElementById("sQLong").disabled = true
	  	document.getElementById("sOther").disabled=true
	  	document.getElementById("TMrowid").disabled=true
	  	document.getElementById("sOtherInfo").disabled=true
	  	DisableById(componentId,"LastCata")
    	DisableById(componentId,"TumourDate")
	}
}

 
 function GetPatInfo()
 {
	if(bNewPatient==1)
	{	
		var GetPaadmInfoFun=document.getElementById("PatInfo").value
  		var PATINFO=cspRunServerMethod(GetPaadmInfoFun,paadmdr)
    	if (PATINFO!="")
		{   
			var item=PATINFO.split("^");
			
			//RegNo,Name,strDOB,strAge,$g(SexDesc),patienttype,typedesc 7
			//$g(LocName),IPNO,wardname,bedname,$g(Locdr),SexDr,WardDr, 14
			//roomdesc,feetype,Docdr,DocName,Telphone,Height,Weight, 21
			//address,SEXDR,feetypedr 24
    		document.getElementById("RegNo").value=item[0]
			document.getElementById("PName").value=item[1]
			
			
			//2008-5-1-----1/5/2008 ??
			var vdate3=item[2]
			var ChangDFun=document.getElementById("DateChange3to4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("PBirthday").value=vdate4
						
			document.getElementById("PAge").value=item[3]
			
			//sex dr??
			document.getElementById("PSex").value=item[4]
			document.getElementById("SexDr").value=item[22]
			
			document.getElementById("PTel").value=item[18]
			document.getElementById("PAddress").value=item[21]
			
			document.getElementById("PType").value=item[6]
			document.getElementById("AdmtypeDR").value=item[5]
		
			document.getElementById("PChargeType").value=item[15]
			document.getElementById("CharegetypeDR").value=item[23]
			
			document.getElementById("InpoNo").value=item[8]
			var item9=""
      if(item[9])
        item9=item[9].split("-")[1]
			document.getElementById("RoomNo").value=item9
			document.getElementById("BedNo").value=item[10]
			var item7=item[7].split("-")
			document.getElementById("AppDep").value=item7[1]
        	document.getElementById("AppLocDR").value=item[11]
        	document.getElementById("RoomBedNo").value=item[10]
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
			document.getElementById("PName").value=item[1]
			
			var vdate3=item[4]
			var ChangDFun=document.getElementById("DateChange3to4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("PBirthday").value=vdate4
			//document.getElementById("Age").value=""
			
			var titem1=item[3].split("~")
			document.getElementById("PSex").value=titem1[1]
			document.getElementById("SexDr").value=titem1[0]
			
			document.getElementById("PTel").value=item[8]
			document.getElementById("PAddress").value=item[7]
			
			var titem2=item[5].split("~")
			document.getElementById("PType").value=titem2[1]
			document.getElementById("AdmtypeDR").value=titem2[0]
		
			var titem3=item[6].split("~")
			document.getElementById("PChargeType").value=titem3[1]
			document.getElementById("CharegetypeDR").value=titem3[0]
			//alert(item[11])
			document.getElementById("RoomNo").value=item[11]
			document.getElementById("BedNo").value=item[12]
			//alert(item[10])
			document.getElementById("InpoNo").value=item[10]
			document.getElementById("RoomBedNo").value=item[11]+" "+item[12]
		}
		
		var GetPaadmInfoFun=document.getElementById("PatInfo").value
  		var PATINFO=cspRunServerMethod(GetPaadmInfoFun,paadmdr)
    	if (PATINFO!="")
		{   
			var item=PATINFO.split("^")
			//RegNo,Name,strDOB,strAge,$g(SexDesc),patienttype,typedesc 7
			//$g(LocName),IPNO,wardname,bedname,$g(Locdr),SexDr,WardDr, 14
			//roomdesc,feetype,Docdr,DocName,Telphone,Height,Weight,address 22
			document.getElementById("PAge").value=item[3]
		}
	}
 }
 
 function GetAppInfo()
 {
	 if(bNewPatient==1)
	{
		// get patient main diagonse 
		var GetMainDiagoseFunction=document.getElementById("MainDiagInfo").value
  		var value=cspRunServerMethod(GetMainDiagoseFunction,paadmdr)
  		//alert(value)
    	document.getElementById("ClinicDiag").value=value//临床诊断
    	 /*
    	var GetCSTATUSFunction=document.getElementById("GetCurrentStatusAll").value
  		var value=cspRunServerMethod(GetCSTATUSFunction,paadmdr)
  		//alert(value)
    	document.getElementById("ClinicRec1").value=value//临床症状及体征
    	 */
    	/*
    	// get patient default current status 
    	var GetCurrentStatusFunction=document.getElementById("GetCurrentStatusFunction").value;
  		var value=cspRunServerMethod(GetCurrentStatusFunction,paadmdr)
    	document.getElementById("ClinicRecord").value=value
		*/
		
		var GetOrdInfoFun=document.getElementById("OrderInfo").value
  		var ORDERINFO=cspRunServerMethod(GetOrdInfoFun,orditemdr)
    	if (ORDERINFO!="")
		{   
			var item=ORDERINFO.split("^")
			//arcimid,strOrderName,strDate,strTime,requestdoc,ssusrdr, 6
			//strAccessionNum,SGroupDesc,subCatDesc,CatDesc,ifbed,price 12
			//Num,TotalPrice,billed,$g(ItemStatusCode),$g(ServerMaterial) 17
			//RecLocdr,$g(ResultFlag),strCommon,RecLocDesc 21
			document.getElementById("GetOEorditemName").value=item[1]
			document.getElementById("Price").value=item[13]
			document.getElementById("AppDoc").value=item[4]
			document.getElementById("AppDocDR").value=item[5]
			document.getElementById("AppDate").value=item[2]
		}
		
		document.getElementById("bLiuCell").checked=true
		document.getElementById("bOther").checked=false
		document.getElementById("OtherInfo").disabled=true
		document.getElementById("OtherInfo").value=""
		
		var GetAppInfoFun=document.getElementById("GetAppInfo").value
  		var APPINFO=cspRunServerMethod(GetAppInfoFun,ttmrowid)
    	if (APPINFO!="")
		{   
			var item=APPINFO.split("^")
			//frost,clinicRecord,operResult,tumourInfo,womenInfo,relClinic, 6
			//appDeptDr,appDept,appDate,appTime,appDocDr,appDoc,orderDr 13
			if(item[5]!="")
			document.getElementById("ClinicDiag").value=item[5]
			//document.getElementById("OperationSee").value=item[2]
			if(item[1]!="")
			{
			  tclinicrecord=item[1]
				if(item[1]!="")
					SetClinicRecord()
			}
			//GetAllSpecimenInfo()
		}
		
	}
	else
	{
		var GetAppInfoFun=document.getElementById("GetAppInfo").value
  		var APPINFO=cspRunServerMethod(GetAppInfoFun,ttmrowid)
    	if (APPINFO!="")
		{   
			var item=APPINFO.split("^")
			//frost,clinicRecord,operResult,tumourInfo,womenInfo,relClinic, 6
			//appDeptDr,appDept,appDate,appTime,appDocDr,appDoc,orderDr 13

    		document.getElementById("AppDep").value=item[7]
        	document.getElementById("AppLocDR").value=item[6]
		
			document.getElementById("AppDoc").value=item[11]
			document.getElementById("AppDocDR").value=item[10]
			
						
			var vdate3=item[8]
			var ChangDFun=document.getElementById("DateChange3to4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("AppDate").value=vdate4
			
			document.getElementById("ClinicDiag").value=item[5]
			//document.getElementById("OperationSee").value=item[2]
			
			tclinicrecord=item[1]
			if(item[1]!="")
				SetClinicRecord()
		}
		var GetOrdInfoFun=document.getElementById("OrderInfo").value
  		var ORDERINFO=cspRunServerMethod(GetOrdInfoFun,orditemdr)
    	if (ORDERINFO!="")
		{   
			var item=ORDERINFO.split("^")
			//arcimid,strOrderName,strDate,strTime,requestdoc,ssusrdr, 6
			//strAccessionNum,SGroupDesc,subCatDesc,CatDesc,ifbed,price 12
			//Num,TotalPrice,billed,$g(ItemStatusCode),$g(ServerMaterial) 17
			//RecLocdr,$g(ResultFlag),strCommon,RecLocDesc 21
			document.getElementById("GetOEorditemName").value=item[1]
			document.getElementById("Price").value=item[13]
		}
	}
	
	if(bNewPatient==1)
    {
		 document.getElementById("ClinicRec1").disabled=false
		 //document.getElementById("ClinicRec2").disabled=false
	 	 document.getElementById("bLiuCell").disabled=false
	 	 document.getElementById("bOther").disabled=false
	 	 document.getElementById("OtherInfo").disabled=false
    }
    else
    {
		 document.getElementById("ClinicRec1").disabled=true
		 //document.getElementById("ClinicRec2").disabled=true
	 	 document.getElementById("bLiuCell").disabled=true
	 	 document.getElementById("bOther").disabled=true
	 	 document.getElementById("OtherInfo").disabled=true
	 }
 }
 
 function SetClinicRecord()
 {
	var item=tclinicrecord.split(code1)

	var trec1=item[0]
	var trec2=item[1]
	var trec3=item[2]
	var trec4=item[3]
	
	document.getElementById("ClinicRec1").value=trec1
	document.getElementById("JWClinicRec").value=trec2

	if(trec3==t['LIUCELL'])
	{
		document.getElementById("bLiuCell").checked=true
		document.getElementById("bOther").checked=false
		document.getElementById("OtherInfo").value=""
	}
	else
	{
		document.getElementById("bLiuCell").checked=false
		document.getElementById("bOther").checked=true
		document.getElementById("OtherInfo").value=trec3
	}
	
	var subitem=trec4.split(code2)
	for(var i=0;i<subitem.length;i++)
	{
		var tstr=subitem[i]
		if(tstr=="")
			continue
			
		if(tstr==t['KOUFU'])
			document.getElementById("bKouFu").checked=true
		else if(tstr==t['ZGHUAN'])
			document.getElementById("bZGHuan").checked=true
		else if(tstr==t['ABNORMAL'])
			document.getElementById("bAbnormal").checked=true
		else if(tstr==t['CHSGYUE'])
			document.getElementById("bChanHou").checked=true
		else if(tstr==t['HUAIYUN'])
			document.getElementById("bHuaiYun").checked=true
		else if(tstr==t['BURUQI'])
			document.getElementById("bBRQi").checked=true
		else if(tstr==t['RRTLBDU'])
			document.getElementById("bRRTLBDu").checked=true
		else if(tstr==t['ZGQCSHU'])
			document.getElementById("bZGQCShu").checked=true
		else if(tstr==t['LCQCSHU'])
			document.getElementById("bLCQCShu").checked=true
		else if(tstr==t['GJZQSHU'])
			document.getElementById("bGJZQShu").checked=true
		else
		{
			document.getElementById("bOtherSShu").checked=true
			document.getElementById("OtherSShuInfo").value=tstr
		}
	}
	
	if(bNewPatient==1)
    {
		 document.getElementById("bKouFu").disabled=false
		 document.getElementById("bZGHuan").disabled=false
	 	 document.getElementById("bAbnormal").disabled=false
	 	 document.getElementById("bChanHou").disabled=false
	 	 document.getElementById("bHuaiYun").disabled=false
	 	 
	 	 document.getElementById("bBRQi").disabled=false
		 document.getElementById("bRRTLBDu").disabled=false
	 	 document.getElementById("bZGQCShu").disabled=false
	 	 document.getElementById("bLCQCShu").disabled=false
	 	 document.getElementById("bGJZQShu").disabled=false
	 	 
	 	 document.getElementById("bOtherSShu").disabled=false
		 document.getElementById("OtherSShuInfo").disabled=false
    }
    else
    {
		 document.getElementById("bKouFu").disabled=true
		 document.getElementById("bZGHuan").disabled=true
	 	 document.getElementById("bAbnormal").disabled=true
	 	 document.getElementById("bChanHou").disabled=true
	 	 document.getElementById("bHuaiYun").disabled=true
	 	 
	 	 document.getElementById("bBRQi").disabled=true
		 document.getElementById("bRRTLBDu").disabled=true
	 	 document.getElementById("bZGQCShu").disabled=true
	 	 document.getElementById("bLCQCShu").disabled=true
	 	 document.getElementById("bGJZQShu").disabled=true
	 	 
	 	 document.getElementById("bOtherSShu").disabled=true
		 document.getElementById("OtherSShuInfo").disabled=true
		 
		 document.getElementById("JWClinicRec").disabled=true
		 document.getElementById("SpeNum").disabled=true
	 }
 }
 
 function GetWomanTumourInfo()
 {
	  var GetTumourInfo=document.getElementById("TumourInfo")
      if (GetTumourInfo)
      {
         var returnTumInfoVal
         var enmeth=GetTumourInfo.value
         var returnTumInfoVal=cspRunServerMethod(enmeth,ttmrowid)
         if (returnTumInfoVal!="")
	     {  
	 	    var item=returnTumInfoVal.split("^")
		    document.getElementById("TumourPosition").value=item[1]
		    document.getElementById("TumourSize").value=item[2]
		    if (item[0]!="")
		    {
			    var ChangDFun=document.getElementById("DateChange3to4").value
			    item[0]=cspRunServerMethod(ChangDFun,item[0])
		    }
		    document.getElementById("TumourDate").value=item[0]
		    
		    if (item[5]=="Y") var RadioCure=1
		    else var RadioCure=0
		    document.getElementById("RadioCure").checked=RadioCure
		    if (item[6]=="Y") var ChemicalCure=1
		    else var ChemicalCure=0
		    document.getElementById("ChemicalCure").checked=ChemicalCure
		    if (item[3]=="Y") var Transfer=1
		    else var Transfer=0
		    document.getElementById("Transfer").checked=Transfer
		    document.getElementById("TransPos").value=item[4]
		    if(item[4]!="")
		    {
					 document.all("TransPos").style.display=""
					 document.getElementById("TransPos").disabled=false
				}
		    	 
		    document.getElementById("memo").value=item[7]
	     }
      }
      
	  if(bNewPatient==1)
      {
		 document.getElementById("TumourPosition").disabled=false
		 document.getElementById("TumourSize").disabled=false
	 	 document.getElementById("TumourDate").disabled=false
		 document.getElementById("RadioCure").disabled=false
		 document.getElementById("ChemicalCure").disabled=false
		 document.getElementById("TumourSize").disabled=false
	 	 document.getElementById("Transfer").disabled=false
		 //document.getElementById("TransPos").disabled=false
		 document.getElementById("memo").disabled=false     
      }
      else
      {
		 document.getElementById("TumourPosition").disabled=true
		 document.getElementById("TumourSize").disabled=true
	 	 document.getElementById("TumourDate").disabled=true
		 document.getElementById("RadioCure").disabled=true
		 document.getElementById("ChemicalCure").disabled=true
		 document.getElementById("TumourSize").disabled=true
	 	 document.getElementById("Transfer").disabled=true
		 document.getElementById("TransPos").disabled=true
		 document.getElementById("memo").disabled=true
		 
		 //DisableById(componentId,"TumourDate")
      }
		  
	  //Get patient women information
	  var tsexdes=document.getElementById("PSex").value
	  if(tsexdes==t['SEXNV'])
	  {
	  	var GetWomenInfo=document.getElementById("WomenInfo")
      	if (GetWomenInfo)
      	{
        	var returnWomInfoVal
         	var enmeth=GetWomenInfo.value
        	var returnWomInfoVal=cspRunServerMethod(enmeth,ttmrowid)
         	if (returnWomInfoVal!="")
	     	{   
	        	var item=returnWomInfoVal.split("^")
		    	if (item[0]!="")
		    	{
			    	var enmeth=document.getElementById("DateChange3to4").value
			    	item[0]=cspRunServerMethod(enmeth,item[0])
		    	}
		    	document.getElementById("LastCata").value=item[0]
		    	
		    	if (item[1]=="Y") 
		    	{
			    	var endCata=1
			    }
		    	else 
		    	{
			    	var endCata=0
		    	}
		    	document.getElementById("EndCata").checked=endCata //Update by lff 2008-12-19
		    	
	     	}
      	}
      	 
      	
	  }
	
	  if(bNewPatient==1 && tsexdes==t['SEXNV'])
      {
	     document.getElementById("LastCata").disabled=false
	 	 document.getElementById("EndCata").disabled=false

	 	
      }
      else
      {
	     document.getElementById("LastCata").disabled=true
	 	 document.getElementById("EndCata").disabled=true
	 	 if (endCata==1)
	      document.all("LastCata").style.display = "none"
	      //document.getElementById("LastCata").style.visibility="hidden"
	 	 //DisableById(componentId,"LastCata")
      }
 }
 
function GetSpecimenInfo()
{
	tspecimennum = document.getElementById("SpeNum").value;
	
	tspecimeninfo="";
	
	var tempobj=document.getElementById("sGJing");
	if (tempobj.checked)
	{
	  tspecimeninfo = t['GONGJING'];
	}
	
	tempobj=document.getElementById("sGGGuan");
	if (tempobj.checked)
	{
	  tspecimeninfo = t['GONGJINGGUAN'];
	}
	
	tempobj=document.getElementById("sYDao");
	if (tempobj.checked)
	{
	  tspecimeninfo = t['YINDAO'];
	}

	tempobj=document.getElementById("sYDCDuan");
	if (tempobj.checked)
	{
	  tspecimeninfo = t['YDCANDUAN'];
	}

	tempobj=document.getElementById("sQLong");
	if (tempobj.checked)
	{
	  tspecimeninfo = t['QIONGLONG'];
	}

	tempobj=document.getElementById("sOther");
	if (tempobj.checked)
	{
	  tspecimeninfo = document.getElementById("sOtherInfo").value;
	}
}
 
 function SendAppkey()
 { 
 	//if(document.getElementById("SendApp").disabled==true)
 		//return
	if (ttmrowid=="")
    {
	   alert(t['NOTNULL'])
	   return
    }
 	var jjdate=document.getElementById("LastCata").value
 	var tjjobj=document.getElementById("EndCata")
 	if((jjdate==""&& !tjjobj.checked) || (jjdate!=""&&tjjobj.checked))
 	{
	 	alert(t['WRONGINFO'])
	 	return
 	}
	
 	//specimen not null
 	var tempobj=document.getElementById("sOther")
 	var tempvalue=document.getElementById("sOtherInfo").value
	if (tempobj.checked && tempvalue=="")
	{	
		alert(t['NOSPECIMEN'])
		return
	}
	
	GetSpecimenInfo()
	if(tspecimennum==0)
	{
		alert(t['NOSPECIMEN'])
		return
	}
 	
    
  	//修改
    var MorObj=document.getElementById("bLiuCell") 
    var AfterObj=document.getElementById("bOther")
    if(MorObj.checked==false && AfterObj.checked==false)
    {
		alert(t['SJMDNull'])
		return    
	}
	var JWClinicRec=document.getElementById("JWClinicRec").value
	var ClinicRec1=document.getElementById("ClinicRec1").value
	if((Trim(JWClinicRec)=="")||(Trim(ClinicRec1)==""))
	{
		alert(t['RecNotNull'])	
		return
	}
    SetPatInfo()
    SetAppInfo()
    SetWomanTumourInfo()
    SetSpecimenInfo()
    
    var SQDPriceFun=document.getElementById("SQDPrice").value
    var SQDPrice=cspRunServerMethod(SQDPriceFun,orditemdr)
    var TotalPriceInfo=document.getElementById("UpdateTotalPrice").value
    var TotalPrice=cspRunServerMethod(TotalPriceInfo,SQDPrice,ttmrowid)
    
     var typezm=document.getElementById("PType").value
     var orditemrowid=document.getElementById("OEorditemID").value
     //alert(typezm+"++"+orditemrowid)
	 var jifeibiaozhiFun=document.getElementById("jifeibiaozhi").value
	 var biaozhi=cspRunServerMethod(jifeibiaozhiFun,orditemrowid)
	 if ((typezm=="门诊病人")&&(biaozhi!="P"))
	 {
	   alert(t['ISNOTJIFEI'])
	   return
	 }
	 else
	 {
		 SetAppStatus()
		 }
    //SetAppStatus()
    
    //send and print application sheet.Add by lff 2008-08-19
    //CommonPrint("DHCPisAppWCellZLYY")
    
    Refresh()   
 }
 
  function SaveAppkey()
 { 
 	//alert("aa")
 	//if(document.getElementById("SaveApp").disabled==true)
 		//return
	/*/保存时不做提示
 	var jjdate=document.getElementById("LastCata").value
 	var tjjobj=document.getElementById("EndCata")
 	if((jjdate==""&& !tjjobj.checked) || (jjdate!=""&&tjjobj.checked))
 	{
	 	alert(t['WRONGINFO'])
	 	return
 	}
 	//specimen not null
 	var tempobj=document.getElementById("sOther")
 	var tempvalue=document.getElementById("sOtherInfo").value
	if (tempobj.checked && tempvalue=="")
	{	
		alert(t['NOSPECIMEN'])
		return
	}
	
	GetSpecimenInfo()
	if(tspecimennum==0)
	{
		alert(t['NOSPECIMEN'])
		return
	}*/
 	
    if (ttmrowid=="")
    {
	   alert(t['NOTNULL'])
	   return
    }
    GetSpecimenInfo()
  	//修改
    var MorObj=document.getElementById("bLiuCell") 
    var AfterObj=document.getElementById("bOther")
    if(MorObj.checked==false && AfterObj.checked==false)
    {
		alert(t['SJMDNull'])
		return    
	}
	

    SetPatInfo()
    SetAppInfo()
    SetWomanTumourInfo()
    SetSpecimenInfo()
    //SetAppStatus()
    
    //send and print application sheet.Add by lff 2008-08-19
    //CommonPrint("DHCPisAppWCellZLYY")
    
    Refresh()
    DisableById(componentId,"LastCata")
    DisableById(componentId,"TumourDate")
    
 }

  function SetSpecimenInfo()
 {
	// alert(tspecimeninfo)
	 if(bNewPatient==1 && tspecimeninfo!="")
	 {
		 //var item=tspecimeninfo.split("~")
		 //for(var i=0; i<item.length;i++)
		 //{  
			//if(item[i]=="")
			//	continue;
				
		 	var tspeinfo=""
		 	//var sno=i+1
			tspeinfo=ttmrowid+"^1^"+tspecimeninfo+"^"+tspecimennum+"~"+t['fens']+"^^^^^"
	      
	    	var SetSpeInfofun=document.getElementById("SetSpecimenInfo").value;
  	    var tsperowid=cspRunServerMethod(SetSpeInfofun,tspeinfo)
  	     	if(tsperowid=="-916")
  	     	{
						 tspeinfo="1^"+tspecimeninfo+"^"+tspecimennum+"~"+t['fens']+"^^^^^"
	      
				    	var SetSpeInfofun=document.getElementById("UpdateSpecimenInfo").value;
			  	    var tsperowid=cspRunServerMethod(SetSpeInfofun,tspeinfo,ttmrowid+"||1")
			  	    //alert(tspeinfo+"="+ttmrowid+"||1"+"="+tsperowid)
					}
  	   	 	if (tsperowid=="")
  	   	 	{
	  	   		alert['UpdateSpeFailure']
	  	   		return
  	   	 	} 	   	 
		 //}
		
	 }
 }

 
 function SetPatInfo()
 {
 	if(bNewPatient==1)
	
		 var patinfo=""
		 
		 var ndob=document.getElementById('PBirthday').value
		 var ChangDFun=document.getElementById("DateChange4to3").value
		 var vdate3=cspRunServerMethod(ChangDFun,ndob)

		 patinfo+=paadmdr+"^"
		 patinfo+=document.getElementById('AdmtypeDR').value+"^"
		 patinfo+=document.getElementById('PName').value+"^^"
		 patinfo+=document.getElementById('CharegetypeDR').value+"^"
		 patinfo+=document.getElementById('SexDr').value+"^"
		 patinfo+=vdate3+"^"
		 patinfo+=document.getElementById('PAddress').value+"^"
		 patinfo+=document.getElementById('RegNo').value+"^"
		 patinfo+=document.getElementById('InpoNo').value+"^"
		 patinfo+=document.getElementById('RoomNo').value+"^"
		 patinfo+=document.getElementById('BedNo').value+"^"
		 patinfo+=document.getElementById('PTel').value+"^"
		 
	     var SetPatInfoFun=document.getElementById("AddPatInfo").value
   	     var PATCODE=cspRunServerMethod(SetPatInfoFun,patinfo,ttmrowid)
  	   	 if (PATCODE!="0")
  	   	 {
	  	   	alert['UpdatePatFailure']
	  	   	return
  	   	 }
 }	 
 
 function GetClinicRecord()
 {
	tclinicrecord=""
	
	var trec1=document.getElementById("ClinicRec1").value
	var trec2="" //for test
	var trec2=document.getElementById("JWClinicRec").value
	
	var trec3=""
	if(document.getElementById("bLiuCell").checked==true)
	{
		trec3=t['LIUCELL']
	}
	else
	{
		trec3=document.getElementById("OtherInfo").value
	}
	
	var trec4=""
	if(document.getElementById("bKouFu").checked)
		trec4+=t['KOUFU']+code2
		
	if(document.getElementById("bZGHuan").checked)
		trec4+=t['ZGHUAN']+code2
		
	if(document.getElementById("bAbnormal").checked)
		trec4+=t['ABNORMAL']+code2
	
	if(document.getElementById("bChanHou").checked)
		trec4+=t['CHSGYUE']+code2
		
	if(document.getElementById("bHuaiYun").checked)
		trec4+=t['HUAIYUN']+code2
		
	if(document.getElementById("bBRQi").checked)
		trec4+=t['BURUQI']+code2
		
	if(document.getElementById("bRRTLBDu").checked)
		trec4+=t['RRTLBDU']+code2
		
	if(document.getElementById("bZGQCShu").checked)
		trec4+=t['ZGQCSHU']+code2
		
	if(document.getElementById("bLCQCShu").checked)
		trec4+=t['LCQCSHU']+code2
		
	if(document.getElementById("bGJZQShu").checked)
		trec4+=t['GJZQSHU']+code2
		
	if(document.getElementById("bOtherSShu").checked)
		trec4+=document.getElementById("OtherSShuInfo").value+code2
	
	tclinicrecord=trec1+code1+trec2+code1+trec3+code1+trec4
 }
 
 function SetAppInfo()
 {
	 if(bNewPatient==1)
	 {
		 var appinfo=""
		 var tbingdong=""
		 
		 GetClinicRecord()
		 
 		 var tbingdong="0"

		 appinfo+=tclinicrecord+"^^^^"
		 appinfo+=document.getElementById('ClinicDiag').value+"^"+tbingdong+"^^^"
		 appinfo+=document.getElementById('AppDep').value+"^"
		 appinfo+=document.getElementById('AppLocDR').value+"^"
		 appinfo+=document.getElementById('AppDoc').value+"^"
		 appinfo+=document.getElementById('AppDocDR').value+"^"+orditemdr
	     //alert("appinfo"+appinfo)
	     var SetAppInfoFun=document.getElementById("AddAppInfo").value
   	     var APPCODE=cspRunServerMethod(SetAppInfoFun,appinfo,ttmrowid)
  	   	 if (APPCODE!="0")
  	   	 {
	  	   	alert['UpdateAppFailure']
	  	   	return
  	   	 }
	 }
 }
 
 function SetWomanTumourInfo()
 {
	 if(bNewPatient==1)
	 {
		var tsexdes=document.getElementById("PSex").value
		if(tsexdes==t['SEXNV'])
		{
			var jjdate=document.getElementById("LastCata").value
			var twinfo=""
			    twinfo=ttmrowid+"^"				
			var tjj=""
			var tjjobj=document.getElementById("EndCata")
				if(tjjobj.checked)
				{
					tjj="Y"
				}
				else
				{
					tjj="N"
				}
			 var tdate=""
			if((jjdate!="")&&(tjj="N"))
			{
				var DateChangeFun=document.getElementById("DateChange4to3").value
				    tdate=cspRunServerMethod(DateChangeFun,jjdate)
			}
				twinfo+=tdate+"^"
				twinfo+=tjj+"^"
				twinfo+="^^"
			    //alert("newWomen"+twinfo)
				var SetWomaninfoFun=document.getElementById("AddWomenInfo").value
				var womanid=cspRunServerMethod(SetWomaninfoFun,twinfo)		
				if (womanid=="")
  	   	 		{
	  	   			alert['UpdateWomanFailure']
	  	   			return
  	   	 		}		   
		}
		//set tumour info//修改
		var foundDate=document.getElementById("TumourDate").value
		var foundPos=document.getElementById("TumourPosition").value
   		if (foundDate!="" && foundPos!="" && foundDate!=DateDemo())
		{	
		
			var enmeth=document.getElementById("DateChange4to3").value
			foundDate=cspRunServerMethod(enmeth,foundDate)
			
   			var position=document.getElementById("TumourPosition").value
    		var size=document.getElementById("TumourSize").value
    		var beTransfer=document.getElementById("Transfer").checked
    		var zhuanyi=""
    		if (beTransfer==true) 
    		{
	    		zhuanyi="Y"
    		}
   			else if (beTransfer==false) 
    		{
	    		zhuanyi="N"
    		}
    		
    		var transferPos=document.getElementById("TransPos").value
    		var radioCure=document.getElementById("RadioCure").checked
    		var radioc=""
    		if (radioCure==true) 
    		{
	    		radioc="Y"
    		}
    		else if (radioCure==false) 
    		{
	    		radioc="N"
   			}
   			
    		var chemicalCure=document.getElementById("ChemicalCure").checked
    		var chemicalc=""
   		 	if (chemicalCure==true) 
    		{
	    		chemicalc="Y"
   			}
    		else if (chemicalCure==false) 
    		{
	    		chemicalc="N"
    		}
    		
    		var otherInfo=document.getElementById("memo").value
     
     		var UpdateTumourInfo=ttmrowid+"^"
     		UpdateTumourInfo+=foundDate+"^"+position+"^"+size+"^"+zhuanyi+"^"+transferPos+"^"+radioc+"^"+chemicalc+"^"+otherInfo
	        //alert("TumourInfo"+UpdateTumourInfo)
	        var UpdateTumour=document.getElementById("AddTumourInfo").value;
      		var tumourid=cspRunServerMethod(UpdateTumour,UpdateTumourInfo)
	        if (tumourid=="") //Such as return -901,-915 or other SQL error,which is initial with "-".
     		{
	     		alert(t['SendAppFailure'])
	     		return
	 		 }
		}
	 }
 }
  
 function SetAppStatus()
 {  
	 if(bNewPatient==1)
	 {
		 var trscode="1"
		 var trsid=""
		 
		 var GetRsIDFun=document.getElementById("GetRSidByCode").value

		 var vid=cspRunServerMethod(GetRsIDFun,trscode)
		 if(vid!="")
		 {
			 trsid=vid
			  
			 var SetStatusInfo=document.getElementById("UpdateRStatus").value
   	     	 var rcode=cspRunServerMethod(SetStatusInfo,trsid,ttmrowid)
  	   	 	 if (rcode!="0")
  	   	 	 {
	  	   		alert(t['UpdateStatusFailure'])
	  	   		return
  	   	 	 }
  	   	 	 
  	   	 	 //ChangRISStatus
  	   	 	 var docdr=document.getElementById("AppDocDR").value
  	   	 	 var ChangeStatusInfo=document.getElementById("ChangRISStatus").value;
   	     	 var rriscode=cspRunServerMethod(ChangeStatusInfo,orditemdr,docdr)
           if (rriscode=="0")
			     {
				   alert(t['sendsuccess'])
				   return
		    	 }
  	   	 	 if (rriscode!="0")
  	   	 	 {
	  	   		alert(t['UpdateStatusFailure'])
	  	   		return
  	   	 	 }
		}		 
	 } 
 }
 function SetCancelAppToENS()
 {
	var docdrc=document.getElementById("AppDocDR").value
	var CalcelAppInfo=document.getElementById("CalcelAppInfoToENS").value;
	var rriscode=cspRunServerMethod(CalcelAppInfo,orditemdr,docdrc) 		
 } 	
 function CancelAppkey()
 {  
 	if(document.getElementById("CancelApp").disabled==true)
 		return

	var TMrowid=document.getElementById("TMrowid").value
    if (TMrowid=="")
    {
	   alert(t['NOTNULL'])
	   return
    } 	
    
     var Ans=confirm(t['DeleteSend'])
	 if (Ans==false)
	 {
		 return
     }
    //SetCancelAppToENS() 
    var CancelAppFun=document.getElementById("CancelAppFunction").value
    var ret=cspRunServerMethod(CancelAppFun,TMrowid)
	if (ret.split("-")[0]=="") //Such as return -901,-915 or other SQL error,which is initial with "-".
    {
	   alert(t['CancelAppFailure'])
	}
    else
    {
	  // alert(t['CancelAppSuccess'])
	}
	
	Refresh()
 }
 
 function Refresh()
 {
 	var Eposide=document.getElementById("EpisodeID").value
    var ComponentName=document.getElementById("ComponentName").value 
    var TMrowid=document.getElementById("TMrowid").value
    var OEorditemID=document.getElementById("OEorditemID").value
    //var Price=document.getElementById("Price").value
    //20081205YCX 缓存价格
   // var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+ComponentName+"&EpisodeID="+Eposide+"&OEorditemID="+OEorditemID+"&TMrowid="+TMrowid+"&ComponentName="+ComponentName+"&Price="+Price+"&Refresh="+""
    //var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+ComponentName+"&EpisodeID="+Eposide+"&OEorditemID="+OEorditemID+"&TMrowid="+TMrowid+"&ComponentName="+ComponentName+"&Refresh="+""
    //刷新左菜单
    //var lnk= "dhcrisappbill.csp?WEBSYS.TCOMPONENT="+ComponentName+"&EpisodeID="+Eposide+"&OEorditemID="+OEorditemID+"&TMrowid="+TMrowid+"&ComponentName="+ComponentName+"&Price="+Price+"&Refresh="+""
    var lnk= "dhcrisappbill.csp?WEBSYS.TCOMPONENT="+ComponentName+"&EpisodeID="+Eposide+"&OEorditemID="+OEorditemID+"&TMrowid="+TMrowid+"&ComponentName="+ComponentName+"&Refresh="+""  
    parent.location.href=lnk;
    //location.href=lnk
 }
 
function DateDemo()
{
   var d, s=""        
   d = new Date()
   var sDay="",sMonth="",sYear="",tYear=""
   sDay = d.getDate()			
   if(sDay < 10)
   sDay = "0"+sDay
    
   sMonth = d.getMonth()+1	
   if(sMonth < 10)
   sMonth = "0"+sMonth
   
   sYear  = d.getYear()
   s = sDay + "/" + sMonth + "/" + sYear 
   return(s)
}
/*
function PrintAppkey()
{
	if(document.getElementById("PrintApp").disabled==true)
 		return
    
	CommonPrint("DHCPisAppWCellZLYY")
}
 */
function LiuKey()
{
	var MorningObj=document.getElementById("bLiuCell")
	if (MorningObj.checked)
	{
	  document.getElementById("bOther").checked=false
	  document.getElementById("OtherInfo").disabled=true
	  document.getElementById("OtherInfo").value=""
	}
}

function OtherKey()
{
	var AfternoonObj=document.getElementById("bOther")
	if (AfternoonObj.checked)
	{
	  document.getElementById("bLiuCell").checked = false
	  document.getElementById("OtherInfo").disabled=false
	  document.getElementById("OtherInfo").value=""
	}
}


function DisableById(componentId,id)
{
	var obj=document.getElementById(id);
	if (obj) obj.disabled=true;
	if (componentId>0)
	{
		obj=document.getElementById("ld"+componentId+"i"+id);
		if (obj) obj.style.display ="none";
	}
}

function TumourDateblur()
{
	var TDate=document.getElementById("TumourDate")
	
	if(BJDate(TDate.value))
	{
		alert(t['DateError'])
		document.getElementById("TumourDate").value=""
		TDate.focus()
	}
}

function LastDateblur()
{	
	var LDate=document.getElementById("LastCata")
	if(BJDate(LDate.value))
	{
		alert(t['DateError'])
		document.getElementById("LastCata").value=""
		LDate.focus()
	}
}

function BJDate(date)
{
	var today=DateDemo();
	var dDate=date.split("/")
	var tDate=today.split("/")
	if(dDate[2]>tDate[2])
	{
		boolvalue=true;
	}else if(dDate[2]==tDate[2])
	{
		if(dDate[1]>tDate[1])
		{
		boolvalue=true;	
		}else if(dDate[1]==tDate[1])
		{
			if(dDate[0]>tDate[0])
			{
				boolvalue=true;	
			}else
			{
				boolvalue=false;	
			}	
		}else
		{
			boolvalue=false;
		}
	}else
	{
		boolvalue=false;
	}
	return boolvalue;
}

function TransferKey()
{
	var TransferObj=document.getElementById("Transfer");
	if (TransferObj.checked)
	{
	  document.getElementById("TransPos").disabled = false;
	  document.all("TransPos").style.display = ""
	  document.getElementById("TransPos").value ="";
	}
	else
	{
	  document.getElementById("TransPos").disabled = true;
	  document.all("TransPos").style.display = "none"
	  document.getElementById("TransPos").value="";
	} 
}

function EndCataKey()
{   //alert("aa")
	var EndCataObj=document.getElementById("EndCata");
	if (EndCataObj.checked)
	{
	  //document.getElementById("LastCata").style.visibility="hidden"
	  document.getElementById("LastCata").value ="";
	  document.getElementById("LastCata").disabled = true;
	  document.all("LastCata").style.display = "none"
	}
	else
	{
	  document.getElementById("LastCata").disabled = false;
	  document.all("LastCata").style.display = ""
	  document.getElementById("LastCata").value="";
	} 
}

function PrintAppkey()
{
	if(document.getElementById("PrintApp").disabled==true)
 		return
    
    var xlApp,xlsheet,xlBook,Template
     var GetPrescPath=document.getElementById("GetRepPath");
	 if (GetPrescPath) {var encmeth=GetPrescPath.value} 
	 else {var encmeth=''};
	 if (encmeth!="") 
	 {
		var TemplatePath=cspRunServerMethod(encmeth);
	 }
       //alert(TemplatePath)
	    Template=TemplatePath+"DHCPisAppWCellXHYY.xls";
      
	    xlApp = new ActiveXObject("Excel.Application")
			xlBook = xlApp.Workbooks.Add(Template);
			xlsheet = xlBook.ActiveSheet;
      var duihao=String.fromCharCode(8730) 
    
	    //号码
	    //xlsheet.cells(2,1)="*"+document.getElementById("TMrowid").value+"*";  //条码申请单号
       var OEorditemID=document.getElementById("OEorditemID").value; 
      var ordinfo=OEorditemID.split("||")
      var ordinfotm=ordinfo[0]+"-"+ordinfo[1]
      xlsheet.cells(2,1)="*"+ordinfotm+"*";  //条码医嘱号
      xlsheet.cells(3,5)=document.getElementById("RegNo").value;          // 登记号/病人ID
	    //xlsheet.cells(3,5)=document.getElementById("TMrowid").value;          //申请单号
	    //xlsheet.cells(3,14)=document.getElementById("RegNo").value;           //登记号
	    xlsheet.cells(3,18)=document.getElementById("OEorditemID").value;     //医嘱号
	    xlsheet.cells(3,30)=document.getElementById("InpoNo").value;         //病案号
	    //基本信息                                                            
	    xlsheet.cells(5,4)=document.getElementById("PName").value;             //病人姓名
	    xlsheet.cells(5,11)=document.getElementById("PSex").value;             //病人性别
	    xlsheet.cells(5,18)=document.getElementById("PAge").value;             //病人年龄
	    //xlsheet.cells(5,25)=document.getElementById("PTel").value;            //联系电话
	    //alert(document.getElementById("PTel").value)
	     //xlsheet.cells(6,4)=document.getElementById("RoomNo1").value;         //科别
	     xlsheet.cells(6,18)=document.getElementById("BedNo").value;         //病床号
	     //xlsheet.cells(6,25)=document.getElementById("PType").value;         //就诊类型
	    xlsheet.cells(6,4)=document.getElementById("RoomNo").value;	        //病区
	    //xlsheet.cells(7,4)=document.getElementById("PAddress").value;          //通讯地址
	    
	    //申请信息
	    xlsheet.cells(24,4)=document.getElementById("AppDep").value;           //申请科室
	    xlsheet.cells(24,15)=document.getElementById("AppDoc").value;          //申请医生
	    var appdate=document.getElementById("AppDate").value;
	    var item=appdate.split("/")
	    xlsheet.cells(24,25)=item[2]+"-"+item[1]+"-"+item[0];         //申请日期

	    xlsheet.cells(8,1)=document.getElementById("ClinicRec1").value;   //临床症状及体征
	    xlsheet.cells(10,1)=document.getElementById("ClinicDiag").value;    //临床诊断
	    xlsheet.cells(12,1)=document.getElementById("JWClinicRec").value;    //既往病理诊断及病理号(外院)
	    
	    //肿瘤信息
      xlsheet.cells(18,12)=document.getElementById("TumourPosition").value; //肿瘤部位
      xlsheet.cells(18,21)=document.getElementById("TumourSize").value;   //肿瘤大小
      var tdate=document.getElementById("TumourDate").value;
      if(tdate!="")
      {
	  	var item=tdate.split("/")
      	xlsheet.cells(18,4)=item[2]+"-"+item[1]+"-"+item[0];   //发现日期
      }
      if(document.getElementById("Transfer").checked)   //有无转移
          xlsheet.cells(18,28)=duihao
      xlsheet.cells(19,4)=document.getElementById("TransPos").value;   //转移部位
      if(document.getElementById("RadioCure").checked)   //曾否放疗
          xlsheet.cells(19,11)=duihao
      if(document.getElementById("ChemicalCure").checked)   //曾否化疗
          xlsheet.cells(19,17)=duihao
      xlsheet.cells(19,23)=document.getElementById("memo").value;   //备注
      
      //妇科信息
      //新修改2011-10-29
	    var Tfkxx=""
	    if(document.getElementById("EndCata").checked)   //是否绝经
	    {
	    	 Tfkxx+=t['SFjj']+duihao+"   "
	    }
	     var tdate=document.getElementById("LastCata").value;
       if(tdate!="")   //是否绝经
	    {
	    	 var item=tdate.split("/")
	    	 Tfkxx+=t['Mcyj']+" "+item[2]+"-"+item[1]+"-"+item[0]+"   "  //末次月经
	    }
     if(document.getElementById("bZGHuan").checked)   //子宫环 
	    {
	    	 Tfkxx+=t['ZGHUAN']+duihao+"   "
	    }
      if(document.getElementById("bKouFu").checked)   //口服避孕药 
	    {
	    	 Tfkxx+=t['KOUFU']+duihao+"   "
	    }
	    if(document.getElementById("bHuaiYun").checked)    //怀孕
	    {
	    	 Tfkxx+=t['HUAIYUN']+duihao+"   "
	    }
	    if(document.getElementById("bBRQi").checked)   //哺乳期 
	    {
	    	 Tfkxx+=t['BURUQI']+duihao+"   "
	    }
      if(document.getElementById("bChanHou").checked)   //产后四个月
	    {
	    	 Tfkxx+=t['CHSGYUE']+duihao+"   "
	    }
      /*
	    if(document.getElementById("bKouFu").checked)   //激素替代疗法 
	    {
	    	 Tfkxx+=t['KOUFU1']+duihao+"   "
	    }
	    if(document.getElementById("bCGJXBXJC").checked)   //曾否宫颈细胞学检查 
	    {
	    	 Tfkxx+=t['bCGJXBXJC1']+duihao+"   "
	    }
      */
	    if(document.getElementById("bAbnormal").checked)    //不正常流血 
	    {
	    	 Tfkxx+=t['ABNORMAL']+duihao+"   "
	    }
	    //var hou="后"
	    if(document.getElementById("bZGQCShu").checked)    //子宫切除术 
	    {
	    	 Tfkxx+=t['ZGQCSHU']+duihao+"   "
	    }
	    if(document.getElementById("bGJZQShu").checked)    //宫颈锥切术或LEEP术
	    {
	    	 //Tfkxx+=t['GJZQSHU']+hou+duihao+"   "
         Tfkxx+=t['GJZQSHU']+duihao+"   "
	    }
	    if(document.getElementById("bRRTLBDu").checked)     //人乳头瘤病毒HPV
	    {
	    	 Tfkxx+=t['RRTLBDU']+duihao+"   "
	    }
	    if(document.getElementById("bLCQCShu").checked)    //卵巢切除术  
	    {
	    	 Tfkxx+=t['LCQCSHU']+duihao+"   "
	    }
      if(document.getElementById("bOtherSShu").checked)    //其他  
	    {
	    	 Tfkxx+=t['OTHERSSHU']+":"+document.getElementById("OtherSShuInfo").value;   //其他
	    }
	     xlsheet.cells(14,1)=Trim(Tfkxx);
	    //var GetSpecimensFunc=document.getElementById("autoNumAdd").value
	    //var info=cspRunServerMethod(GetSpecimensFunc,ttmrowid)
	    //xlsheet.cells(28,1)=info                                         //标本信息
	   //新修改2011-11-8
	    var Tfkxbxbb=""
	    if(document.getElementById("sGJing").checked)   //宫颈
	    {
	    	 Tfkxbxbb=t['GONGJING']
	    }
      /*
	    if(document.getElementById("GongJingGuan").checked)   //子宫颈管
	    {
	    	 Tfkxbxbb=t['GongJingGuan1']
	    }
      */
	    if(document.getElementById("sGGGuan").checked)   //宫内膜  
	    {
	    	 Tfkxbxbb=t['GONGJINGGUAN']
	    }
	    if(document.getElementById("sYDao").checked)   //阴道
	    {
	    	 Tfkxbxbb=t['YINDAO']
	    }
	    if(document.getElementById("sYDCDuan").checked)   //阴道残端
	    {
	    	 Tfkxbxbb=t['YDCANDUAN']
	    }
	    if(document.getElementById("sQLong").checked)   //后穹隆 
	    {
	    	 Tfkxbxbb=t['QIONGLONG']
	    }
      /*
	    if(document.getElementById("WaiYin").checked)   //外阴
	    {
	    	 Tfkxbxbb=t['WaiYin']
	    }
      */
	    if(document.getElementById("sOther").checked)   //其他
	    {
	    	 Tfkxbxbb=t['sOther']+":"+document.getElementById("sOtherInfo").value;
	    }
      //alert(Tfkxbxbb)
	     xlsheet.cells(21,1)=Tfkxbxbb;
	       if(document.getElementById("bLiuCell").checked)   //查瘤细胞
	       xlsheet.cells(23,5)=duihao
	       if(document.getElementById("bOther").checked)   //其他
	       xlsheet.cells(23,9)=duihao
	       xlsheet.cells(23,10)=document.getElementById("OtherInfo").value;   //其他
	    
	    xlsheet.PrintOut 
    	xlBook.Close (savechanges=false);
    	xlBook=null
    	xlApp.Quit();
    	xlApp=null;
    	xlsheet=null 
    	//window.setInterval("Cleanup();",1); 
    
    
}

function PirntTMKey()
{
    var Bar,j;
    Bar= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
    Bar.PrintName="tiaoma";//printer name
       
    var RegisterNum=document.getElementById("RegNo").value
    var PName=document.getElementById("PName").value
    var RoomNo=document.getElementById("RoomNo").value
    var RoomNo=RoomNo.split("-")
    var RoomNo=RoomNo[1]
    var BedNo=document.getElementById("BedNo").value
    var PatLoc=document.getElementById("AppDep").value

    var OrderName=document.getElementById("GetOEorditemName").value
    var speid=ttmrowid+"||"+1	
		var GetSpeInfoFun=document.getElementById("GetSpecimenInfo").value;
  	var SPEINFO=cspRunServerMethod(GetSpeInfoFun,speid)

    if (SPEINFO!="" || SPEINFO!="-901" || SPEINFO!="-911")	
		{   
	   		//speciNo,speciName,speciExplain,acceptorDr,acceptDate,acceptTime 6
			var items=SPEINFO.split("^");
      var itemsbb=items[2]
      var itemsn=itemsbb.split("~");
      var itemsnbb=itemsn[0]+itemsn[1]
            for (var i=1;i<=itemsn[0];i++)
    	  {   
            //Bar.LabNo=document.getElementById("TMRowid").value; 
            Bar.LabNo=ttmrowid+"-"+i
            Bar.RecLoc=t['RecLoc'];
            Bar.PatLoc=PatLoc;
            Bar.OrdName=OrderName;
            Bar.PatName=RegisterNum+" "+PName;
            Bar.Sex=document.getElementById("PSex").value;
            Bar.Age=document.getElementById("PAge").value;
            Bar.BedCode=BedNo;         
            Bar.LabelDesc=i+":"+items[1]+"("+itemsnbb+")"; 
            //alert(Bar.LabNo+"="+Bar.RecLoc+"="+Bar.PatLoc+"="+Bar.OrdName+"="+Bar.PatName+"="+Bar.Sex+"="+Bar.Age+"="+Bar.BedCode+"="+Bar.LabelDesc)   
            Bar.PrintOut(1);
        }
  }
}

function SpeNumblur()
{
	var specimennum=document.getElementById("SpeNum").value
	if(isNaN(specimennum.replace(/[ ]/g,""))||(specimennum.replace(/[ ]/g,"")==0))
	{
		alert(t['SpeNum'])
		document.getElementById("SpeNum").focus();
		document.getElementById("SpeNum").select()
	}
}

function GJClick()
{
		 //document.getElementById("sGJing").checked=false;
		 document.getElementById("sGGGuan").checked=false;
		 document.getElementById("sYDao").checked=false;
		 document.getElementById("sYDCDuan").checked=false;
		 document.getElementById("sQLong").checked=false;
		 document.getElementById("sOther").checked=false;
		 document.getElementById("sOtherInfo").value="";
		 document.getElementById("sOtherInfo").disabled=true;
}

function GNMClick()
{
		 document.getElementById("sGJing").checked=false;
		 //document.getElementById("sGGGuan").checked=false;
		 document.getElementById("sYDao").checked=false;
		 document.getElementById("sYDCDuan").checked=false;
		 document.getElementById("sQLong").checked=false;
		 document.getElementById("sOther").checked=false;
		 document.getElementById("sOtherInfo").value="";
		 document.getElementById("sOtherInfo").disabled=true;
}

function QLClick()
{
		 document.getElementById("sGJing").checked=false;
		 document.getElementById("sGGGuan").checked=false;
		 document.getElementById("sYDao").checked=false;
		 document.getElementById("sYDCDuan").checked=false;
		 //document.getElementById("sQLong").checked=false;
		 document.getElementById("sOther").checked=false;
		 document.getElementById("sOtherInfo").value="";
		 document.getElementById("sOtherInfo").disabled=true;
}

function YDClick()
{
		 document.getElementById("sGJing").checked=false;
		 document.getElementById("sGGGuan").checked=false;
		 //document.getElementById("sYDao").checked=false;
		 document.getElementById("sYDCDuan").checked=false;
		 document.getElementById("sQLong").checked=false;
		 document.getElementById("sOther").checked=false;
		 document.getElementById("sOtherInfo").value="";
		 document.getElementById("sOtherInfo").disabled=true;
}

function YDCDClick()
{
		 document.getElementById("sGJing").checked=false;
		 document.getElementById("sGGGuan").checked=false;
		 document.getElementById("sYDao").checked=false;
		 //document.getElementById("sYDCDuan").checked=false;
		 document.getElementById("sQLong").checked=false;
		 document.getElementById("sOther").checked=false;
		 document.getElementById("sOtherInfo").value="";
		 document.getElementById("sOtherInfo").disabled=true;
}

function SOClick()
{
		 document.getElementById("sGJing").checked=false;
		 document.getElementById("sGGGuan").checked=false;
		 document.getElementById("sYDao").checked=false;
		 document.getElementById("sYDCDuan").checked=false;
		 document.getElementById("sQLong").checked=false;
		 if(document.getElementById("sOther").checked)
		 {
		    document.getElementById("sOtherInfo").value="";
		 		document.getElementById("sOtherInfo").disabled=false;
		 }else
		 {
		    document.getElementById("sOtherInfo").value="";
		 		document.getElementById("sOtherInfo").disabled=true;
		 }
		 
}

//去除字符串首尾空格Trim
function Trim(sInputString)
{
var sTmpStr = ' '
var i = -1
//------去除左空格--------
while(sTmpStr == ' ')
{
++i
sTmpStr = sInputString.substr(i,1)
}
sInputString = sInputString.substring(i)
//------去除左空格--------
//---------去除右空格----
sTmpStr = ' '
i = sInputString.length
while(sTmpStr == ' ')
{
--i
sTmpStr = sInputString.substr(i,1)
}
sInputString = sInputString.substring(0,i+1)
//---------去除右空格----
return sInputString
}

document.body.onload = BodyLoadHandler