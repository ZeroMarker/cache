//DHCPisAppConsultHXYY

var bNewPatient = 1
var tstatuscode=0
var tspecimennum=0
var tspecimeninfo=""
var ttmrowid=""
var paadmdr=""
var orditemdr=""
var tclsdr=""
var tclscode="4"
var tclinicrecord=""
var TemplatePath=""
var ordname=""


/*
var tformName=document.getElementById("TFORM").value; 
var getComponentIdByName=document.getElementById("GetComponentIdByName").value; 
var componentId; 
componentId=cspRunServerMethod(getComponentIdByName,tformName); 
*/

function BodyLoadHandler()
 {	
 	/*
    var ordItemDr=document.getElementById("OEorditemID").value
	if (ordItemDr=="") ordItemDr="241||5"
    document.getElementById("OEorditemID").value=ordItemDr
    document.getElementById("OrderDr").value=ordItemDr
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
       
    document.getElementById("OrderDr").value=orditemdr
    var POrderValue=document.getElementById("POrditemDR").value
    if(POrderValue=="") 
    {
	    var orditem=orditemdr.split("||")
	    POrderValue="*"+orditem[0]+"-"+orditem[1]+"*"
    }
    document.getElementById("POrditemDR").value=POrderValue

   	var ComName=document.getElementById("ComponentName").value
   	if (ComName=="") ComName="DHCPisConsultHXYY"
   	document.getElementById("ComponentName").value=ComName
   	
   	var AppDateObj=document.getElementById("AppDate")
    if (AppDateObj.value=="")
    	AppDateObj.value=DateDemo()

   	//-----------------all button action!Begin------------------
   	var SendAppobj=document.getElementById("SendApp")
  	 if (SendAppobj)
   	{
		SendAppobj.onclick=SendAppkey
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
   	
   	var KUAIObj=document.getElementById("bKuai")
   	if (KUAIObj)
   	{
		KUAIObj.onclick=KuaiClick
   	}
   	
   	var SLICEIObj=document.getElementById("bSlice")
   	if (SLICEIObj)
   	{
		SLICEIObj.onclick=SliceClick
   	}
   	
   	var SliceNumObj=document.getElementById("SliceNum")
		if (SliceNumObj)
		{
			SliceNumObj.onblur=SliceNumblur
		}
   	
   //-----------------all button action!End------------------
 	var GetPrescPath=document.getElementById("GetPrescPath").value
	TemplatePath=cspRunServerMethod(GetPrescPath);
	//alert(TemplatePath)
   	var GetClsdrFun=document.getElementById("ClassDr").value
 	var CLSDR=cspRunServerMethod(GetClsdrFun,tclscode)
    if (CLSDR!="")
	{	  
	  	tclsdr = CLSDR
    }
    
 	//get tmrowid
    var GetTmrowidFun=document.getElementById("GetTmRowId").value
  	var TMROWID=cspRunServerMethod(GetTmrowidFun,orditemdr)
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
		var TMROWID = cspRunServerMethod(TestmasterAddFun,tclsdr)
		if(TMROWID!="" && TMROWID!="-901")
		{
			ttmrowid = TMROWID
			document.getElementById("TMRowid").value = TMROWID
		}
		
		var appinfo="^^^^^^^^^^^^"+orditemdr
		var SetAppFun=document.getElementById("AddAppInfo").value
		var RECODE=cspRunServerMethod(SetAppFun,appinfo,ttmrowid)
		if(RECODE!="0")
		{
			alert(t['UpdateAppFailure'])
			return
		}
	}

	if(tstatuscode==1)
	{
		document.getElementById("SendApp").disabled=true
	}
	else if(tstatuscode==2)
	{
		document.getElementById("SendApp").disabled=true

		document.getElementById("CancelApp").disabled=true
	}
	else
	{
		document.getElementById("CancelApp").disabled=true
		document.getElementById("PrintApp").disabled=true
	}
	
	GetPatInfo()
	GetAppInfo()
	GetECInfo()
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
    		document.getElementById("RegisterNum").value=item[0]
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
			document.getElementById("RoomNo").value=item[9]
			document.getElementById("BedNo").value=item[10]
			var item7=item[7].split("-")
			document.getElementById("AppDep").value=item7[1]
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
    		document.getElementById("RegisterNum").value=item[9]
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

			document.getElementById("RoomNo").value=item[11]
			document.getElementById("BedNo").value=item[12]
			document.getElementById("InpoNo").value=item[10]
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
			//alert(ORDERINFO)
			document.getElementById("AppDoc").value=item[4]
			document.getElementById("AppDocDR").value=item[5]
			
			ordname = item[1]
		}
	}
	else
	{
		var GetOrdInfoFun=document.getElementById("OrderInfo").value
  		var ORDERINFO=cspRunServerMethod(GetOrdInfoFun,orditemdr)
    	if (ORDERINFO!="")
		{   
			var item=ORDERINFO.split("^")
			//alert(ORDERINFO)
			//arcimid,strOrderName,strDate,strTime,requestdoc,ssusrdr, 6
			//strAccessionNum,SGroupDesc,subCatDesc,CatDesc,ifbed,price 12
			//Num,TotalPrice,billed,$g(ItemStatusCode),$g(ServerMaterial) 17
			//RecLocdr,$g(ResultFlag),strCommon,RecLocDesc 21
			ordname = item[1]
		}

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
		
			document.getElementById("ClinicRecord").value=item[1]
		}
	}
	
	if(bNewPatient==1)
    {
		 document.getElementById("ClinicRecord").disabled=false
    }
    else
    {
		 document.getElementById("ClinicRecord").disabled=true
	}
 }
 
 
 function GetECInfo()
 {
	if(bNewPatient!=1)
	{
		var GetSCFun=document.getElementById("GetSpeClass").value
  		var SCINFO=cspRunServerMethod(GetSCFun,ttmrowid)
    	if ((SCINFO!="")&&(SCINFO!="-901")&&(SCINFO!="-911"))
    	{
	    	var item=SCINFO.split("~")
	    	if(item[1]==t['LAKUAI'])
	    	{
				document.getElementById("bKuai").checked=true
				document.getElementById("bSlice").checked=false
	    	}
	    	else
	    	{
				document.getElementById("bKuai").checked=false
				document.getElementById("bSlice").checked=true
	    	}
    	}
	
		var GetConsultInfo=document.getElementById("GetECInfo")
		//alert(GetConsultInfo.value)
      	if (GetConsultInfo)
      	{
         	var returnTumInfoVal
         	var enmeth=GetConsultInfo.value
         	var returnECInfoVal=cspRunServerMethod(enmeth,ttmrowid)
         	//alert("returnECInfoVal="+returnECInfoVal)
         	if ((returnECInfoVal!="")&&(returnECInfoVal!="-901")&&(returnECInfoVal!="-911"))
	     		{  
	        	 //sliceType,sliceNum,sliceIds,tissue,specimenObser, 5
	         	//specialNeed,reqUnitName,reqUnitAdd,reqUnitTel,reqLinkman,10
	        	 //patAdd,patTel,ecrowid 13
					
	     		var temp="";
	 	    	var item=returnECInfoVal.split("^")
	 	    	if(item[0]==1)
	 	    		item0=t['BaiPian']
	 	    	if(item[0]==2)
	 	    		item0=t['HE']
	 	    	if(item[0]==3)
	 	    		item0=t['MianYi']
	 	    	if(item[0]==4)
	 	    		item0=t['FenZi']
 					document.getElementById("SlliceType").value=item0
 					document.getElementById("SliceNum").value=item[1]
 	    		document.getElementById("SliceIds").value=item[2]
	 	   		document.getElementById("Tissue").value=item[3]
	 	    	document.getElementById("Seeing").value=item[4]
	 	    	document.getElementById("SpecialNeed").value=item[5]
	 	    
	 	    	document.getElementById("AppHosp").value=item[6]
	 	    	document.getElementById("ReqAddress").value=item[7]
		 			document.getElementById("ReqTel").value=item[8]
 	   			document.getElementById("ReqLinker").value=item[9]
	     	}
      	}
	}
      
	  if(bNewPatient==1)
      {
	      document.getElementById("bKuai").disabled=false
		  document.getElementById("bSlice").disabled=false
		  
		  document.getElementById("bKuai").checked=true
			document.getElementById("bSlice").checked=false;
		  document.getElementById("SliceNum").value="";
		  document.getElementById("SlliceType").value="";
		  document.all("SliceNum").style.visibility="hidden";
		  document.all("SlliceType").style.visibility="hidden";
		  document.all("cSliceNum").style.visibility="hidden";
		  document.all("cSlliceType").style.visibility="hidden";
	 	  document.getElementById("SliceIds").disabled=false
	 	  document.getElementById("Tissue").disabled=false
	 	  document.getElementById("Seeing").disabled=false
	 	  document.getElementById("SpecialNeed").disabled=false
	    
	 	  document.getElementById("AppHosp").disabled=false
	 	  document.getElementById("ReqAddress").disabled=false
		  document.getElementById("ReqTel").disabled=false
 	   	  document.getElementById("ReqLinker").disabled=false
      }
      else
      {
	      document.getElementById("bKuai").disabled=true
		  document.getElementById("bSlice").disabled=true
			document.getElementById("SliceNum").disabled=true;
	  	document.getElementById("SlliceType").disabled=true;
	 	  document.getElementById("SliceIds").disabled=true
	 	  document.getElementById("Tissue").disabled=true
	 	  document.getElementById("Seeing").disabled=true
	 	  document.getElementById("SpecialNeed").disabled=true
	 	    
	 	  document.getElementById("AppHosp").disabled=true
	 	  document.getElementById("ReqAddress").disabled=true
		  document.getElementById("ReqTel").disabled=true
 	   	document.getElementById("ReqLinker").disabled=true
 	   	document.getElementById("PTel").disabled=true
 	   	document.getElementById("PAddress").disabled=true
      }
 }
 
 function SendAppkey(str)
 { 
  	if(document.getElementById("SendApp").disabled==true)
 		return
 		
	var tnum=document.getElementById('SliceIds').value
	if(tnum=="")
	{
		alert(t['NOSLICES'])
		return 
	}
 	
    if (ttmrowid=="")
    {
	   alert(t['NOTNULL'])
	   return
    }
    
    SetPatInfo()
    SetAppInfo()
    SetECInfo()
    SetAppStatus()
    
    Refresh()
 }
 
 function SetPatInfo()
 {
 	if(bNewPatient==1)
	{
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
		 patinfo+=document.getElementById('RegisterNum').value+"^"
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
 }
 
 function SetAppInfo()
 {
	 if(bNewPatient==1)
	 {
		 var appinfo=""
		
		 tbingdong="0"
		 var tclinicrecord = document.getElementById('ClinicRecord').value
		 
		 appinfo+=tclinicrecord+"^^^^^"
		 appinfo+=tbingdong+"^^^"
		 appinfo+=document.getElementById('AppDep').value+"^"
		 appinfo+=document.getElementById('AppLocDR').value+"^"
		 appinfo+=document.getElementById('AppDoc').value+"^"
		 appinfo+=document.getElementById('AppDocDR').value+"^"+orditemdr
		 
	     var SetAppInfoFun=document.getElementById("AddAppInfo").value;
   	     var APPCODE=cspRunServerMethod(SetAppInfoFun,appinfo,ttmrowid)
  	   	 if (APPCODE!="0")
  	   	 {
	  	   	alert['UpdateAppFailure']
	  	   	return
  	   	 }
	 }
 }
 
 function SetECInfo()
 {
	 if(bNewPatient==1)
	 {
		 var ecinfo=""
		 ecinfo+=ttmrowid+"^"
		 var SType=document.getElementById("SlliceType").value
		 if(SType==t['HE'])
		 	var TypeCode=2
		 if(SType==t['BaiPian'])
		 	var TypeCode=1
		 if(SType==t['FenZi'])
		 	var TypeCode=4
		 if(SType==t['MianYi'])
		 	var TypeCode=3
		 ecinfo+=TypeCode+"^"
		 ecinfo+=document.getElementById("SliceNum").value+"^"
		 ecinfo+=document.getElementById("SliceIds").value+"^"
		 ecinfo+=document.getElementById("Tissue").value+"^"
		 ecinfo+=document.getElementById("Seeing").value+"^"
		 ecinfo+=document.getElementById("SpecialNeed").value+"^"
		 ecinfo+=document.getElementById("AppHosp").value+"^"
 
		 ecinfo+=document.getElementById("ReqAddress").value+"^"
		 ecinfo+=document.getElementById("ReqTel").value+"^"
		 ecinfo+=document.getElementById("ReqLinker").value+"^^"
 
		 var SetECInfo=document.getElementById("AddECInfo").value
		 var ecid=cspRunServerMethod(SetECInfo,ecinfo)		
		 if (ecid=="" || ecid=="-901" || ecid=="-911")
  	   	 {
	  	   	alert['UpdateECFailure']
	  	   	return
  	   	 }
  	   	 
  	   	 var spec=""
  	   	 if(document.getElementById("bKuai").checked)
  	   	 	spec="2"
  	   	 else
  	   	 	spec="3"
  	   	 	
  	   	 var SetSCInfo=document.getElementById("UpdateSpeClass").value
		 var vret=cspRunServerMethod(SetSCInfo,spec, ttmrowid)		
		 if (vret!=true)
  	   	 {
	  	   	alert['UpdateSCFailure']
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
		 
		 var GetRsIDFun=document.getElementById("GetRSidByCode").value

		 var vid=cspRunServerMethod(GetRsIDFun,trscode)
		 if(vid!="")
		 {
			 trsid=vid
			  
			 var SetStatusInfo=document.getElementById("UpdateRStatus").value
   	     	 var rcode=cspRunServerMethod(SetStatusInfo,trsid,ttmrowid)
  	   	 	 if (rcode!="0")
  	   	 	 {
	  	   		alert['UpdateStatusFailure']
	  	   		return
  	   	 	 }
  	   	 	 
  	   	 	 /*
  	   	 	 //ChangRISStatus
  	   	 	 var docdr=document.getElementById("AppDocDR").value
  	   	 	 alert(docdr)
  	   	 	 var ChangeStatusInfo=document.getElementById("ChangRISStatus").value;
	    	 		alert(ChangeStatusInfo)
   	     	 var rriscode=cspRunServerMethod(ChangeStatusInfo,docdr,orditemdr)
   	     	 alert("riscode:"+rriscode)
  	   	 	 if (rriscode!="0")
  	   	 	 {
	  	   		alert['UpdateStatusFailure']
	  	   		return
  	   	 	 }
  	   	 	 */
		}		 
	 } 
 }
	
 function CancelAppkey(str)
 {  
 	if(document.getElementById("CancelApp").disabled==true)
 		return
 		
 	//检查病例状态?如果已登记则不允许取消
 	var GetStatusFun=document.getElementById("GetAppStatus").value
	var VS = cspRunServerMethod(GetStatusFun,ttmrowid)
	if(VS!="")
	{
		var item=VS.split("~")
		var GetRSCodeFun=document.getElementById("RsCode").value
		var curcode=cspRunServerMethod(GetRSCodeFun,item[0])
		if(curcode!="1")
		{
			alert(t['REGISTERED'])
			Refresh()
			return
		}
	}
 		
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
	var ComponentName=document.getElementById("ComponentName").value
  var EpisodeID=document.getElementById("EpisodeID").value
  var OEorditemID=document.getElementById("OEorditemID").value
  var AppHosp=document.getElementById("AppHosp").value
  var ReqLinker=document.getElementById("ReqLinker").value
  var ReqTel=document.getElementById("ReqTel").value
  var Tissue=document.getElementById("Tissue").value
  var SliceNum=document.getElementById("SliceNum").value
  var SlliceType=document.getElementById("SlliceType").value
  var ReqAddress=document.getElementById("ReqAddress").value
  var SliceIds=document.getElementById("SliceIds").value
  var Seeing=document.getElementById("Seeing").value
  var ClinicRecord=document.getElementById("ClinicRecord").value
  var SpecialNeed=document.getElementById("SpecialNeed").value
  
  var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+ComponentName+
    				"&EpisodeID="+EpisodeID+
    				"&OEorditemID="+OEorditemID+
    				"&TMrowid="+ttmrowid+
    				"&AppHosp="+AppHosp+
    				"&ComponentName="+ComponentName+
    				"&ReqLinker="+ReqLinker+
    				"&ReqTel="+ReqTel+
    				"&Tissue="+Tissue+
    				"&SliceNum="+SliceNum+
    				"&SlliceType="+SlliceType+
    				"&ReqAddress="+ReqAddress+
    				"&SliceIds="+SliceIds+
    				"&Seeing="+Seeing+
    				"&ClinicRecord="+ClinicRecord+
    				"&SpecialNeed="+SpecialNeed+
    				"&Refresh="+""
    location.href=lnk
 }

function KuaiClick()
{
	var TanyeObj=document.getElementById("bKuai");
	if (TanyeObj.checked)
	{
	
	  //document.getElementById("bKuai").checked = false;
	  document.getElementById("bSlice").checked=false;
	  document.getElementById("SliceNum").value="";
	  document.getElementById("SlliceType").value="";
	  document.all("SliceNum").style.visibility="hidden";
	  document.all("SlliceType").style.visibility="hidden";
	  document.all("cSliceNum").style.visibility="hidden";
	  document.all("cSlliceType").style.visibility="hidden";
	}else
	{
		document.getElementById("bSlice").checked=true;
		document.getElementById("SliceNum").value="";
	  document.getElementById("SlliceType").value="";
	  document.all("SliceNum").style.visibility="visible";
	  document.all("SlliceType").style.visibility="visible";
	  document.all("cSliceNum").style.visibility="visible";
	  document.all("cSlliceType").style.visibility="visible";
	}
}

function SliceClick()
{
	var TanyeObj=document.getElementById("bSlice");
	if (TanyeObj.checked)
	{
	  document.getElementById("bKuai").checked = false;
	  //document.getElementById("bSlice").checked=false;
	  document.getElementById("SliceNum").value="";
	  document.getElementById("SlliceType").value="";
	  document.all("SliceNum").style.visibility="visible";
	  document.all("SlliceType").style.visibility="visible";
	  document.all("cSliceNum").style.visibility="visible";
	  document.all("cSlliceType").style.visibility="visible";
	}else
	{
		//document.getElementById("bKuai").checked = false;
	  document.getElementById("bSlice").checked=false;
	  document.getElementById("SliceNum").value="";
	  document.getElementById("SlliceType").value="";
	  document.all("SliceNum").style.visibility="hidden";
	  document.all("SlliceType").style.visibility="hidden";
	  document.all("cSliceNum").style.visibility="hidden";
	  document.all("cSlliceType").style.visibility="hidden";
	}
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

function PrintAppkey()
{
	if((document.getElementById("PrintApp").disabled==true) || (ttmrowid==""))
 		return
 	
 	try {
	 		var xlApp,xlsheet,xlBook
	    var Template="http://10.10.142.3/Dthealth/trak/med/Results/Template/"+"DHCPisAppConsultHXYY.xls";
	    xlApp = new ActiveXObject("Excel.Application")
			xlBook = xlApp.Workbooks.Add(Template);
			xlsheet = xlBook.ActiveSheet;	
	    //号码
	    xlsheet.cells(2,2)="*"+document.getElementById("TMrowid").value+"*";
	    xlsheet.cells(3,5)=document.getElementById("TMrowid").value;
	    xlsheet.cells(3,13)=document.getElementById("RegisterNum").value;
	    xlsheet.cells(3,21)=document.getElementById("InpoNo").value;
	    //基本信息
	    xlsheet.cells(5,4)=document.getElementById("PName").value;
	    xlsheet.cells(5,11)=document.getElementById("PSex").value;
	    xlsheet.cells(5,15)=document.getElementById("PAge").value;
	    xlsheet.cells(5,19)=document.getElementById("PType").value;
	    xlsheet.cells(6,4)=document.getElementById("PChargeType").value;
	    xlsheet.cells(6,13)=document.getElementById("PBirthday").value;
	    xlsheet.cells(6,20)=document.getElementById("PTel").value;
	    xlsheet.cells(7,5)=document.getElementById("PAddress").value;
	    //申请信息
	    xlsheet.cells(9,5)=document.getElementById("AppDoc").value;
	    xlsheet.cells(9,12)=document.getElementById("AppDate").value;
	    xlsheet.cells(9,19)=document.getElementById("AppDep").value;
	    //送检医院信息
	    xlsheet.cells(11,5)=document.getElementById("AppHosp").value;
	    xlsheet.cells(11,22)=document.getElementById("ReqLinker").value;
	    xlsheet.cells(12,5)=document.getElementById("ReqTel").value;
	    xlsheet.cells(12,12)=document.getElementById("ReqAddress").value;
	    //送检标本信息
	    if(document.getElementById("bSlice").checked=true)
	    	var biaobenleixing=t['QIEPIAN']
	    else
	    	var biaobenleixing=t['LAKUAI']
	    xlsheet.cells(14,5)=biaobenleixing;
	    xlsheet.cells(14,10)=document.getElementById("Tissue").value;
	    xlsheet.cells(14,19)=document.getElementById("SliceNum").value;
	    xlsheet.cells(14,23)=document.getElementById("SlliceType").value;
	    //原病理号
	    xlsheet.cells(16,2)=document.getElementById("SliceIds").value;
	    //大体标本检查所见:																								
	    xlsheet.cells(18,2)=document.getElementById("Seeing").value;
	    //病历摘要
	    xlsheet.cells(20,2)=document.getElementById("ClinicRecord").value;
	    //会诊要求
	    xlsheet.cells(22,2)=document.getElementById("SpecialNeed").value;
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} catch(e) {};
 		
}

function SliceNumblur()
{
	var SliceNum=document.getElementById("SliceNum")
	if(isNaN(SliceNum.value)||((SliceNum.value).match(/^[0-9]+$/)==null))
	{
		SliceNum.focus()
		alert(t['SNisNaN'])		
	}
	
}

/*
function DisableById(componentId,id)
{
	var obj=document.getElementById(id);
	if (obj) obj.disabled=true;
	if (componentId>0)
	{
		obj=document.getElementById("ld"+componentId+"i"+id);
		if (obj) obj.style.display ="none";
	}
	
}*/

document.body.onload = BodyLoadHandler