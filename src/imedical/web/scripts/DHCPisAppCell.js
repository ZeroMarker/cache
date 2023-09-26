//DHCPisAppCell.js

var bNewPatient = 1
var tstatuscode=0
var tspecimennum=0
var tspecimeninfo=""
var ttmrowid=""
var paadmdr=""
var orditemdr=""
var tclsdr=""
var tclscode="20"
var TemplatePath=""
var specimens=""
var ordname=""
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
    
    var POrditemDR=document.getElementById("POrditemDR")
    if(POrditemDR)
    {
	    var orditem=orditemdr.split("||")
	    POrditemDR.value="*"+orditem[0]+"-"+orditem[1]+"*"
    }
    
    var ComName=document.getElementById("ComponentName")
    if(ComName)
    {
	    ComName.value="DHCPisAppCell"
    }

    var AppDateObj=document.getElementById("AppDate");
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
	//var PrintBarObj=document.getElementById("PrintBarApp")
   	//{
	   	//PrintBarObj.onclick=PrintBarAppkey
	//}
	var PrintAppObj=document.getElementById("PrintApp")
   	{
	   	PrintAppObj.onclick=PrintAppkey
	}
  	var CancelSheetObj=document.getElementById("CancelSheet");
	if (CancelSheetObj)
	{
		CancelSheetObj.onclick=CancelSheetClick
	}
	
	var TanyeObj=document.getElementById("bTanye");
	if (TanyeObj)
	{
		TanyeObj.onclick=TanyeClick;
	}
	var XiongshuiObj=document.getElementById("bXiongshui");
	if (XiongshuiObj)
	{
		XiongshuiObj.onclick=XiongshuiClick;
	}
	var FushuiObj=document.getElementById("bFushui");
	if (FushuiObj)
	{
		FushuiObj.onclick=FushuiClick;
	}
	
	var XinbjyObj=document.getElementById("bXinbaojiye");
	if (XinbjyObj)
	{
		XinbjyObj.onclick=XinbjyClick;
	}
	var FuxcxyeObj=document.getElementById("bFuxcxye");
	if (FuxcxyeObj)
	{
		FuxcxyeObj.onclick=FuxcxyeClick;
	}
	var NaojyObj=document.getElementById("bNaojiye");
	if (NaojyObj)
	{
		NaojyObj.onclick=NaojyClick;
	}
	
	var NiaoyObj=document.getElementById("bNiaoye");
	if (NiaoyObj)
	{
		NiaoyObj.onclick=NiaoyClick;
	}
	
	var SYNiaoObj=document.getElementById("bSYNiao");
	if (SYNiaoObj)
	{
		SYNiaoObj.onclick=SYNiaoClick;
	}

	var XIZHENObj=document.getElementById("bXiZhen");
	if (XIZHENObj)
	{
		XIZHENObj.onclick=XIZHENClick;
	}
	
	var TUPIANObj=document.getElementById("bTuPian");
	if (TUPIANObj)
	{
		TUPIANObj.onclick=TUPIANClick;
	}

	var OtherObj=document.getElementById("bOther");
	if (OtherObj)
	{
		OtherObj.onclick=OtherClick;
	}
	
	var RutyyLeftObj=document.getElementById("bRutyyLeft");
	if (RutyyLeftObj)
	{
		RutyyLeftObj.onclick=RutyyLeftClick;
	}
	
	var ZhiqgspObj=document.getElementById("bShuapian");
	if (ZhiqgspObj)
	{
		ZhiqgspObj.onclick=ZhiqgspClick;
	}
	var GongjtpObj=document.getElementById("bGongjtpian");
	if (GongjtpObj)
	{
		GongjtpObj.onclick=GongjtpClick;
	}
	var RutyyRightObj=document.getElementById("bRutyyeRight");
	if (RutyyRightObj)
	{
		RutyyRightObj.onclick=RutyyRightClick;
	}
	 var SaveClinicRecordObj=document.getElementById("SaveClinicRecord")
	if (SaveClinicRecordObj)
	{
	    SaveClinicRecordObj.onclick=SaveClinicRecordkey	
	}
	var SaveOperseeObj=document.getElementById("SaveOpersee")
	if (SaveOperseeObj)
	{
	    SaveOperseeObj.onclick=SaveOperseekey	
	}
	
	var CTemplateObj=document.getElementById("CTemplate")
	if (CTemplateObj)
	{
	    CTemplateObj.onclick=ClinicTemplatekey
	}
	var OTemplateObj=document.getElementById("OTemplate")
	if (OTemplateObj)
	{
	    OTemplateObj.onclick=OperTemplatekey	
	}
	
	var CLocTemplateObj=document.getElementById("CLocTemplate")
	if (CLocTemplateObj)
	{
	    CLocTemplateObj.onclick=ClinicLocTemplatekey
	}
	var OLocTemplateObj=document.getElementById("OLocTemplate")
	if (OLocTemplateObj)
	{
	    OLocTemplateObj.onclick=OperLocTemplatekey	
	}
	var GetPrescPath=document.getElementById("GetPrescPath").value
	TemplatePath=cspRunServerMethod(GetPrescPath);

	var GetClsdrFun=document.getElementById("GetClsDRbyCode").value;
 	var CLSDR=cspRunServerMethod(GetClsdrFun,tclscode)
    if (CLSDR!="")
	{	  
	 	document.getElementById("ClsDR").value = CLSDR;
	  	tclsdr = CLSDR;
    }
 
	//get tmrowid
	//Locdr=document.getElementById("RecLocDR").value
	//alert(Locdr+"aaa"+orditemdr)
    var GetTmrowidFun=document.getElementById("GetTMrowid").value;
  	var TMROWID=cspRunServerMethod(GetTmrowidFun,Locdr,orditemdr)
    if (TMROWID!="")
	{   
		ttmrowid = TMROWID;
		document.getElementById("TMRowid").value = TMROWID;
		
		var GetStatusFun=document.getElementById("GetAppStatus").value;
		var VS = cspRunServerMethod(GetStatusFun,ttmrowid);
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
			tstatuscode=0
			bNewPatient=1
		}
	}
	else
	{
		tstatuscode=0
		bNewPatient=1
		
		var TestmasterAddFun=document.getElementById("TestmasterAdd").value;
		var TMROWID = cspRunServerMethod(TestmasterAddFun,Locdr,tclsdr);
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
		document.getElementById("PrintSheet").disabled=true
		//document.getElementById("PrintBarApp").disabled=true
		document.getElementById("PrintApp").disabled=true
	}
	
	GetPatInfo()
	GetAppInfo()
	//GetWomanTumourInfo()

	GetAllSpecimenInfo()
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
			
			document.getElementById("AppLoc").value=item[7]
        	document.getElementById("AppLocDR").value=item[11]
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
			document.getElementById("FeeType").value=titem3[1];
			document.getElementById("CharegetypeDR").value=titem3[0]

			document.getElementById("RoomNo").value=item[11];
			document.getElementById("BedNo").value=item[12];
			document.getElementById("InpoNo").value=item[10];
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
		}
	}
}

function GetAppInfo()
{
	if(bNewPatient==1)
	{
		// get patient main diagonse 
		var GetMainDiagoseFunction=document.getElementById("GetMainDiaginfo").value;
  		var value=cspRunServerMethod(GetMainDiagoseFunction,paadmdr)
    	document.getElementById("ClinicDiag").value=value
    	
    	/*for ditan hospital
    	// get patient default current status 
    	var GetCurrentStatusFunction=document.getElementById("GetCurrentStatusFunction").value;
  		var value=cspRunServerMethod(GetCurrentStatusFunction,paadmdr)
    	document.getElementById("ClinicRecord").value=value
		*/
		
		var GetOrdInfoFun=document.getElementById("GetOrditemInfo").value;
  		var ORDERINFO=cspRunServerMethod(GetOrdInfoFun,orditemdr)
    	if (ORDERINFO!="")
		{   
			var item=ORDERINFO.split("^");
			//arcimid,strOrderName,strDate,strTime,requestdoc,ssusrdr, 6
			//strAccessionNum,SGroupDesc,subCatDesc,CatDesc,ifbed,price 12
			//Num,TotalPrice,billed,$g(ItemStatusCode),$g(ServerMaterial) 17
			//RecLocdr,$g(ResultFlag),strCommon,RecLocDesc 21
 			
 			document.getElementById("AppDoc").value=item[4]
			document.getElementById("AppDocDR").value=item[5]
			
			ordname = item[1]
		}
	}
	else
	{
		var GetOrdInfoFun=document.getElementById("GetOrditemInfo").value;
  		var ORDERINFO=cspRunServerMethod(GetOrdInfoFun,orditemdr)
    	if (ORDERINFO!="")
		{   
			var item=ORDERINFO.split("^");
			ordname = item[1]
		}

		var GetAppInfoFun=document.getElementById("GetAppInfo").value;
  		var APPINFO=cspRunServerMethod(GetAppInfoFun,ttmrowid)
    	if (APPINFO!="")
		{   
		    //alert(APPINFO)
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
			
			document.getElementById("ClinicRecord").value=item[1]
			document.getElementById("ClinicDiag").value=item[5]
		}
	}
	
	if(tstatuscode!=0)
	{
		document.getElementById("ClinicRecord").disabled=true
		document.getElementById("ClinicDiag").disabled=true
	}	
}

function GetAllSpecimenInfo()
{
	var speid=ttmrowid+"||"+"1"
	var GetSpeInfoFun=document.getElementById("GetSpecimenInfo").value;
  	var SPEINFO=cspRunServerMethod(GetSpeInfoFun,speid)
    var speid1=ttmrowid+"||"+"2"
  	var GetSpeInfoFun=document.getElementById("GetSpecimenInfo").value;
  	var SPEINFO1=cspRunServerMethod(GetSpeInfoFun,speid1)
  	if(SPEINFO1!="" && SPEINFO1!="-911" && SPEINFO1!="-901")
  	{
	    var item=SPEINFO.split("^");
		var tsname=item[1]
		var titem=tsname.split("~")
		
	    var item1=SPEINFO1.split("^");
		var tsname1=item1[1]
		var titem1=tsname1.split("~")
	    //if(titem1[0]==t['RUTYYRIGHT'])
		//{
			document.getElementById("bRutyyLeft").checked=true
			document.getElementById("num_rtyyleft").value=titem[1]
		    document.getElementById("bRutyyeRight").checked=true
			document.getElementById("num_rtyyeright").value=titem1[1]
		//}
  	}
	else if (SPEINFO!="" && SPEINFO!="-901" && SPEINFO!="-911")
	{   
	    //speciNo,speciName,speciExplain,acceptorDr,acceptDate,acceptTime 6
		var item=SPEINFO.split("^");
		var tsname=item[1]
		var titem=tsname.split("~")
	    var item1=""
		
		if(titem[0]==t['TANYE'])
		{
			document.getElementById("bTanye").checked=true
			document.getElementById("num_tanye").value=titem[1]
		}		
		else if(titem[0]==t['XIONGSHUI'])
		{
			document.getElementById("bXiongshui").checked=true
			document.getElementById("num_xiongshui").value=titem[1]
		}		
		else if(titem[0]==t['FUSHUI'])
		{
			document.getElementById("bFushui").checked=true
			document.getElementById("num_fushui").value=titem[1]
		}	
		else if(titem[0]==t['XINBAOJIYE'])
		{
			document.getElementById("bXinbaojiye").checked=true
			document.getElementById("num_xbjye").value=titem[1]
		}		
		else if(titem[0]==t['FUQIANGCXY'])
		{
			document.getElementById("bFuxcxye").checked=true
			document.getElementById("num_fxcxye").value=titem[1]
		}		
		else if(titem[0]==t['NAOJIYE'])
		{
			document.getElementById("bNaojiye").checked=true
			document.getElementById("num_naojye").value=titem[1]
		}	
		else if(titem[0]==t['SYNIAO'])
		{
		    document.getElementById("bSYNiao").checked=true
			document.getElementById("num_syniao").value=titem[1]
		}		
		else if(titem[0]==t['NIAOYE'])
		{
			document.getElementById("bNiaoye").checked=true
			document.getElementById("num_niaoye").value=titem[1]
		}		
		else if(titem[0]==t['OTHER'])
		{
			document.getElementById("bOther").checked=true
			document.getElementById("bChuancibb").value=titem[1]
		}
		else if(titem[0]==t['XIZHENCC'])
		{
			document.getElementById("bXiZhen").checked=true
			document.getElementById("bChuancibb").value=titem[1]
		}
		else if(titem[0]==t['TUPIAN'])
		{
			document.getElementById("bTuPian").checked=true
			document.getElementById("bChuancibb").value=titem[1]
		}
		
		else if(titem[0]==t['RUTYYLEFT'])
		{
			document.getElementById("bRutyyLeft").checked=true
			document.getElementById("num_rtyyleft").value=titem[1]
		}
		else if(titem[0]==t['RUTYYRIGHT'])
		{
			document.getElementById("bRutyyeRight").checked=true
			document.getElementById("num_rtyyeright").value=titem[1]
		}
		else if(titem[0]==t['ZHIQGSPIAN'])
		{
			document.getElementById("bShuapian").checked=true
			document.getElementById("num_zqgspian").value=titem[1]
		}
		else if(titem[0]==t['GONGJTPIAN'])
		{
			document.getElementById("bGongjtpian").checked=true
			document.getElementById("num_gjtpian").value=titem[1]
		}
		else 
		;
	}

	if(bNewPatient==1)
	{
		document.getElementById("bTanye").disabled = false
	  	document.getElementById("bXiongshui").disabled=false
	  	document.getElementById("bFushui").disabled=false
     	document.getElementById("bXinbaojiye").disabled=false
    	document.getElementById("bFuxcxye").disabled = false
	  	document.getElementById("bNaojiye").disabled=false
	  	document.getElementById("bNiaoye").disabled=false
      	document.getElementById("bOther").disabled=false
      	document.getElementById("bRutyyLeft").disabled=false
	  	document.getElementById("bRutyyeRight").disabled=false
      	document.getElementById("bShuapian").disabled=false
      	document.getElementById("bTuPian").disabled=false
      	document.getElementById("bXiZhen").disabled=false
      	document.getElementById("bSYNiao").disabled=false

      	document.getElementById("bGongjtpian").disabled = false
      	document.getElementById("bChuancibb").disabled = false
      	document.getElementById("num_tanye").disabled=false
	  	document.getElementById("num_xiongshui").disabled=false
	  	document.getElementById("num_fushui").disabled=false
	  	document.getElementById("num_xbjye").disabled=false
	  	document.getElementById("num_fxcxye").disabled=false
	  	document.getElementById("num_naojye").disabled=false
	  	document.getElementById("num_niaoye").disabled=false
	  	document.getElementById("num_other").disabled=false
	  	document.getElementById("num_rtyyleft").disabled=false
 	  	document.getElementById("num_zqgspian").disabled=false
	  	document.getElementById("num_gjtpian").disabled=false
	  	document.getElementById("num_rtyyeright").disabled=false
	  	document.getElementById("num_syniao").disabled=false
	  	
	}
	else
	{
		document.getElementById("bTanye").disabled = true
	  	document.getElementById("bXiongshui").disabled=true
	  	document.getElementById("bFushui").disabled=true
     	document.getElementById("bXinbaojiye").disabled=true
    	document.getElementById("bFuxcxye").disabled = true
	  	document.getElementById("bNaojiye").disabled=true
	  	document.getElementById("bNiaoye").disabled=true
      	document.getElementById("bOther").disabled=true
      	document.getElementById("bRutyyLeft").disabled=true
	  	document.getElementById("bRutyyeRight").disabled=true
      	document.getElementById("bShuapian").disabled=true
      	document.getElementById("bTuPian").disabled=true
      	document.getElementById("bXiZhen").disabled=true
      	document.getElementById("bSYNiao").disabled=true
      	document.getElementById("bGongjtpian").disabled = true
      	document.getElementById("bChuancibb").disabled = true
      	document.getElementById("num_tanye").disabled=true
	  	document.getElementById("num_xiongshui").disabled=true
	  	document.getElementById("num_fushui").disabled=true
	  	document.getElementById("num_xbjye").disabled=true
	  	document.getElementById("num_fxcxye").disabled=true
	  	document.getElementById("num_naojye").disabled=true
	  	document.getElementById("num_niaoye").disabled=true
	  	document.getElementById("num_other").disabled=true
	  	document.getElementById("num_rtyyleft").disabled=true
 	  	document.getElementById("num_zqgspian").disabled=true
	  	document.getElementById("num_gjtpian").disabled=true
	  	document.getElementById("num_rtyyeright").disabled=true
	  	document.getElementById("num_syniao").disabled=true
	}
}

 /*
 function GetWomanTumourInfo()
 {
	  var GetTumourInfo=document.getElementById("GetTumourInfo")
      if (GetTumourInfo)
      {
         var returnTumInfoVal=""
         var enmeth=GetTumourInfo.value
         var returnTumInfoVal=cspRunServerMethod(enmeth,ttmrowid)
         if (returnTumInfoVal!="")
	     {  
	     	var temp="";
	 	    var item=returnTumInfoVal.split("^")
		    document.getElementById("TumourPosition").value=item[1]
		    document.getElementById("TumourSize").value=item[2]
		    if (item[0]!="")
		    {
			    var ChangDFun=document.getElementById("Date3To4").value
			    temp=cspRunServerMethod(ChangDFun,item[0])
		    }
		    document.getElementById("TumourDate").value=temp
		    
		    
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
		    
		    document.getElementById("TumourSudu").value=item[7]
	     }
      }
      
	  if(bNewPatient==1)
      {
		 document.getElementById("TumourPosition").disabled=false
		 document.getElementById("TumourSize").disabled=false
	 	 document.getElementById("TumourDate").disabled=false
		 //document.getElementById("RadioCure").disabled=false
		 //document.getElementById("ChemicalCure").disabled=false
	 	 document.getElementById("Transfer").disabled=false
		 document.getElementById("TransPos").disabled=false
		 document.getElementById("TumourSudu").disabled=false     
      }
      else
      {
		 document.getElementById("TumourPosition").disabled=true
		 document.getElementById("TumourSize").disabled=true
	 	 document.getElementById("TumourDate").disabled=true
		 //document.getElementById("RadioCure").disabled=true
		 //document.getElementById("ChemicalCure").disabled=true
	 	 document.getElementById("Transfer").disabled=true
		 document.getElementById("TransPos").disabled=true
		 document.getElementById("TumourSudu").disabled=true
		 
		 //DisableById(componentId,"TumourDate")
      }
		  
	  //Get patient women information
	  var tsexdes=document.getElementById("Sex").value
	  //alert (tsexdes)
	  
	  if(tsexdes==t['SEXNV'])
	  {
	  	var GetWomenInfo=document.getElementById("WomenInfo")
      	if (GetWomenInfo)
      	{
        	var returnWomInfoVal
         	var enmeth=GetWomenInfo.value
        	var returnWomInfoVal=cspRunServerMethod(enmeth,ttmrowid)
        	//returnWomInfoVal=末次月经^是否人工周期治疗^^^其他^Tw_rowid^^
        	//其他=时间?患亮浚槐瓯静杉?时间?怀醭保辉戮?量?恢芷诩俺中?时间?怀鲅?量
        	//alert("returnWomInfoVal="+returnWomInfoVal)
         	if (returnWomInfoVal!="")
	     	{   
	        	var item=returnWomInfoVal.split("^")
		    	if (item[0]!="")
		    	{
			    	var enmeth=document.getElementById("Date3To4").value
			    	item[0]=cspRunServerMethod(enmeth,item[0])
		    	}
		    	document.getElementById("LastDate").value=item[0]
		    	
		    	if (item[1]=="Y") var RGCure=1
		    	else var RGCure=0
		    	document.getElementById("bRGCure").checked=RGCure
		    	
		    	//document.getElementById("Tai").value=item[2]
		    	//document.getElementById("Chan").value=item[3]
		    	//document.getElementById("TWomenRowId").value=item[5]
		    	
		    	var subitem=item[4].split(";")
		    	//其他=时间?患亮浚槐瓯静杉?时间?怀醭保辉戮?量?恢芷诩俺中?时间?怀鲅?量
		    	if (subitem[2]!="")
		    	{
			    	var enmeth=document.getElementById("Date3To4").value
			    	subitem[2]=cspRunServerMethod(enmeth,subitem[2])
		    	}
		    	//alert
		    	//alert(subitem)
		   		document.getElementById("BBCaijiShijian").value=subitem[2]
		   		
		    	
		    	if (subitem[3]=="Y") var bFirstYJ=1
		    	else var bFirstYJ=0
		    	document.getElementById("bFirstYJ").checked=bFirstYJ
		    	
		    	document.getElementById("YJQuatity").value=subitem[4]
 		    	document.getElementById("YJZhouqi").value=subitem[5]
		    	document.getElementById("CXQuatity").value=subitem[6]
			
				if (subitem[0]!="")
		    {
			    	var enmeth=document.getElementById("Date3To4").value
			    	subitem[0]=cspRunServerMethod(enmeth,subitem[0])
			    	document.getElementById("RGDate").value=subitem[0]
		    }
        
				document.getElementById("RGJiliang").value=subitem[1]
	     	}
      	}
      	
	  }
	  
	  if(bNewPatient==1 && tsexdes==t['SEXNV'])
      {
	     
	     document.getElementById("LastDate").disabled=false
		 document.getElementById("bRGCure").disabled=false
		 document.getElementById("RGDate").disabled=false
		 document.getElementById("RGJiliang").disabled=false

		 document.getElementById("BBCaijiShijian").disabled=false
		 document.getElementById("bFirstYJ").disabled=false
		 document.getElementById("YJQuatity").disabled=false
 		 document.getElementById("YJZhouqi").disabled=false
		 document.getElementById("CXQuatity").disabled=false
      }
      else
      {
	     document.getElementById("LastDate").disabled=true
		 document.getElementById("bRGCure").disabled=true
		 document.getElementById("RGDate").disabled=true
		 document.getElementById("RGJiliang").disabled=true

		 document.getElementById("BBCaijiShijian").disabled=true
		 document.getElementById("bFirstYJ").disabled=true
		 document.getElementById("YJQuatity").disabled=true
 		 document.getElementById("YJZhouqi").disabled=true
		 document.getElementById("CXQuatity").disabled=true
      }
 }
*/

 //Cancel Click 
 function CancelSheetClick()
 {
	 if(document.getElementById("CancelSheet").disabled==true)
 		return
 	
 	//检查病例状态?如果已登记则不允许取消
 	var GetStatusFun=document.getElementById("GetAppStatus").value
	var VS = cspRunServerMethod(GetStatusFun,ttmrowid)
	if(VS!="")
	{
		var item=VS.split("~")
		var GetRSCodeFun=document.getElementById("GetRSCodeByID").value
		var curcode=cspRunServerMethod(GetRSCodeFun,item[0])
		if(curcode!="1")
		{
			alert(t['REGISTERED'])
			Refresh()
			return
		}
	}

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
	if(document.getElementById("SendSheet").disabled==true)
 		return

	GetSpecimenInfo()

	if(tspecimennum==0)
	{
		alert(t['NOSPECIMEN'])
		return 
	}
	
	var tempobj=document.getElementById('TMRowid').value;
	if (tempobj=="") 
	{
		alert(t['NOTNULL'])
		return
	}
	
	if((document.getElementById('bOther').checked)||
		(document.getElementById('bXiZhen').checked)||
		(document.getElementById('bTuPian').checked))
	{
		var tempobj=document.getElementById('bChuancibb').value
		if (tempobj=="") 
		{
			alert(t['NOSPECIMEN'])
			return
		}
	}
	
	SetPatInfo()
	SetAppInfo()
	//SetWomanTumourInfo()

	SetSpecimenInfo()
	SetAppStatus()
	
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
		 
		 appinfo+=document.getElementById('ClinicRecord').value+"^"
		 appinfo+=document.getElementById('bChuancibb').value+"^^^"
		 appinfo+=document.getElementById('ClinicDiag').value+"^"+"0"+"^^^"
		 appinfo+=document.getElementById('AppLoc').value+"^"
		 appinfo+=document.getElementById('AppLocDR').value+"^"
		 appinfo+=document.getElementById('AppDoc').value+"^"
		 appinfo+=document.getElementById('AppDocDR').value+"^"+orditemdr
	 
	     var SetAppInfoFun=document.getElementById("SetAppInfo").value;
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
	 if(bNewPatient==1 && tspecimeninfo!="")
	 {
		 var tspeinfo="" ,tspeinfo1="" , tspeinfo2="" 
		 if(tspecimeninfo== t['RUTYYLEFT']+"~"+document.getElementById("num_rtyyleft").value+t['RUTYYRIGHT']+"~"+document.getElementById("num_rtyyeright").value)
		 {
			 tspeinfo1=ttmrowid+"^"+"1"+"^"+t['RUTYYLEFT']+"~"+document.getElementById("num_rtyyleft").value+"^^^^"
			 var SetSpeInfofun=document.getElementById("SetSpecimenInfo").value;
		     var tsperowid=cspRunServerMethod(SetSpeInfofun,tspeinfo1)
			 tspeinfo2=ttmrowid+"^"+"2"+"^"+t['RUTYYRIGHT']+"~"+document.getElementById("num_rtyyeright").value+"^^^^"
			 var SetSpeInfofun=document.getElementById("SetSpecimenInfo").value;
			 var tsperowid=cspRunServerMethod(SetSpeInfofun,tspeinfo2)
			 }
		     else
		     {
			 tspeinfo+=ttmrowid+"^"+"1"+"^"+tspecimeninfo+"^^^^"

	 
	         var SetSpeInfofun=document.getElementById("SetSpecimenInfo").value;
  	         var tsperowid=cspRunServerMethod(SetSpeInfofun,tspeinfo)
		     }
  	   	 if (tsperowid=="")
  	   	 {
	  	   	alert['UpdateSpeFailure']
	  	   	return
  	   	 }
	 }
 }
 /*
  function SetWomanTumourInfo()
 {
	 if(bNewPatient==1)
	 {
		var tsexdes=document.getElementById("Sex").value
		if(tsexdes==t['SEXNV'])
		{
			var jjdate=document.getElementById("LastDate").value //末次月经
			if(jjdate!="" && jjdate!=DateDemo())
			{
				var twinfo=""
		
				twinfo+=ttmrowid+"^"
			
				var DateChangeFun=document.getElementById("Date4To3").value
				var tdate=cspRunServerMethod(DateChangeFun,jjdate)
				twinfo+=tdate+"^"
			
				RGCure=""
				var RGCureobj=document.getElementById("bRGCure") //是否人工周期
				if(RGCureobj.checked)
				{
					RGCure="Y"
				}
				else
				{
					RGCure="N"
				}
				twinfo+=RGCure+"^"
			
				var RGDate=document.getElementById("RGDate").value //时间
				if(RGDate!="")
				{
					var DateChangeFun=document.getElementById("Date4To3").value
					RGDate=cspRunServerMethod(DateChangeFun,RGDate)
				}
				var RGJiliang=document.getElementById("RGJiliang").value //剂量
				//var ttai=""
				//var tchan=""
				
				var totherinfo=""
				
				var tcjdate=document.getElementById("BBCaijiShijian").value //标本采集时间
				if(tcjdate!="")
				{
					var DateChangeFun=document.getElementById("Date4To3").value
					tcjdate=cspRunServerMethod(DateChangeFun,tcjdate)
				}
		    	
		    	var bfirst=document.getElementById("bFirstYJ").checked //初潮
		    
    			var tfirst=""
    			if (bfirst==true) 
    			{
	    			tfirst="Y"
    			}
   				else if (bfirst==false) 
    			{
	    			tfirst="N"
    			}
		    	var tqual=document.getElementById("YJQuatity").value //月经量
		    	var tzhouqi=document.getElementById("YJZhouqi").value //周期及持续时间
		    	var tchul=document.getElementById("CXQuatity").value //出血量
		    	
		   		totherinfo=RGDate+";"+RGJiliang+";"+tcjdate+";"+tfirst+";"+tqual+";"+tzhouqi+";"+tchul+";"
					//totherinfo=时间+";"+剂量+";"+标本采集时间+";"+初潮+";"+月经量+";"+周期及持续时间+";"+出血量+";"
				twinfo+="^^"+totherinfo
				//twinfo=Tm_rowid^末次月经^是否人工周期^^^其他
			    //alert("twinfo="+twinfo)
				var SetWomaninfoFun=document.getElementById("AddWomenInfo").value
				var womanid=cspRunServerMethod(SetWomaninfoFun,twinfo)		
				if (womanid=="")
  	   	 		{
	  	   			alert['UpdateWomanFailure']
	  	   			return
  	   	 		}
			}
		}
		
		//set tumour info
		var foundDate=document.getElementById("TumourDate").value
		var foundPos=document.getElementById("TumourPosition").value
   		if (foundDate!="" && foundPos!="" && foundDate!=DateDemo())
		{
			var enmeth=document.getElementById("Date4To3").value
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
    	
    		var radioc=""
    		var chemicalc=""
    		
    		var otherInfo=document.getElementById("TumourSudu").value
     
     		var UpdateTumourInfo=ttmrowid+"^"
     		UpdateTumourInfo+=foundDate+"^"+position+"^"+size+"^"+zhuanyi+"^"+transferPos+"^"+radioc+"^"+chemicalc+"^"+otherInfo
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
 */
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
    var TMrowid=document.getElementById("TMrowid").value
    var OEorditemID=document.getElementById("OEorditemID").value
    var Refresh=document.getElementById("Refresh").value
    //alert("Refresh"+Refresh)
    
    var ClinicRecord=document.getElementById("ClinicRecord").value
    var SetSpecimenInfo=document.getElementById("SetSpecimenInfo").value
    var ClinicDiag=document.getElementById("ClinicDiag").value
    //var TumourSize=document.getElementById("TumourSize").value
    //var TumourPosition=document.getElementById("TumourPosition").value
    //var TumourSudu=document.getElementById("TumourSudu").value
    //var TransPos=document.getElementById("TransPos").value
    var RecLocDR=document.getElementById("RecLocDR").value
    //var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+ComponentName+"&EpisodeID="+""+"&OEorditemID="+""+"&TMrowid="+""+"&ComponentName="+ComponentName+"&Refresh="+""
    var lnk=""
    lnk+="websys.default.csp?WEBSYS.TCOMPONENT="+ComponentName
    lnk+="&EpisodeID="+EpisodeID
    lnk+="&TMrowid="+TMrowid
    lnk+="&OEorditemID="+OEorditemID
    lnk+="&ClinicRecord="+ClinicRecord
   
    lnk+="&SetSpecimenInfo="+SetSpecimenInfo
    lnk+="&ClinicDiag="+ClinicDiag
    //lnk+="&TumourSize="+TumourSize
 
    //lnk+="&TumourPosition="+TumourPosition
    //lnk+="&TumourSudu="+TumourSudu
    //lnk+="&TransPos="+TransPos
    lnk+="&RecLocDR="+RecLocDR
    lnk+="&Refresh="+Refresh
    //alert("1"+lnk)
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
  	if(document.getElementById("PrintSheet").disabled==true)
 		return
 		
    Print()

}

function PrintBarAppkey()
{
	if(document.getElementById("PrintBarApp").disabled==true)
	     return
    PrintBar()
 }

function TanyeClick()
{
	var TanyeObj=document.getElementById("bTanye");
	if (TanyeObj.checked)
	{
	  //document.getElementById("bTanye").checked = false;
	  document.getElementById("bXiongshui").checked=false;
	  document.getElementById("bFushui").checked=false;
      document.getElementById("bXinbaojiye").checked=false;
      document.getElementById("bFuxcxye").checked = false;
	  document.getElementById("bNaojiye").checked=false;
	  document.getElementById("bNiaoye").checked=false;
      document.getElementById("bOther").checked=false;
      document.getElementById("bRutyyLeft").checked=false;
	  document.getElementById("bRutyyeRight").checked=false;
      document.getElementById("bShuapian").checked=false;
      document.getElementById("bSYNiao").checked=false;
      document.getElementById("bXiZhen").checked=false;
      document.getElementById("bTuPian").checked = false;
      document.getElementById("bGongjtpian").checked = false;
	  
	  document.getElementById("num_tanye").value="1";
	  document.getElementById("num_xiongshui").value="";
	  document.getElementById("num_fushui").value="";
	  document.getElementById("num_xbjye").value="";
	  document.getElementById("num_fxcxye").value="";
	  document.getElementById("num_naojye").value="";
	  document.getElementById("num_niaoye").value="";
	  document.getElementById("num_rtyyleft").value="";
 	  document.getElementById("num_zqgspian").value="";
	  document.getElementById("num_gjtpian").value="";
	  document.getElementById("num_rtyyeright").value="";
	  document.getElementById("bChuancibb").value="";
	  document.getElementById("num_syniao").value="";
	}
	else
	  document.getElementById("num_tanye").value="";
}

function XiongshuiClick()
{
	var TanyeObj=document.getElementById("bXiongshui");
	if (TanyeObj.checked)
	{
	  document.getElementById("bTanye").checked = false;
	  //document.getElementById("bXiongshui").checked=false;
	  document.getElementById("bFushui").checked=false;
      document.getElementById("bXinbaojiye").checked=false;
      document.getElementById("bFuxcxye").checked = false;
	  document.getElementById("bNaojiye").checked=false;
	  document.getElementById("bNiaoye").checked=false;
      document.getElementById("bOther").checked=false;
      document.getElementById("bRutyyLeft").checked=false;
	  document.getElementById("bRutyyeRight").checked=false;
      document.getElementById("bShuapian").checked=false;
      document.getElementById("bSYNiao").checked=false;
      document.getElementById("bXiZhen").checked=false;
      document.getElementById("bTuPian").checked = false;
      document.getElementById("bGongjtpian").checked = false;
	  
	  document.getElementById("num_tanye").value="";
	  document.getElementById("num_xiongshui").value="1";
	  document.getElementById("num_fushui").value="";
	  document.getElementById("num_xbjye").value="";
	  document.getElementById("num_fxcxye").value="";
	  document.getElementById("num_naojye").value="";
	  document.getElementById("num_niaoye").value="";
	  document.getElementById("num_rtyyleft").value="";
 	  document.getElementById("num_zqgspian").value="";
	  document.getElementById("num_gjtpian").value="";
	  document.getElementById("num_rtyyeright").value="";
	  document.getElementById("bChuancibb").value="";
	  document.getElementById("num_syniao").value="";
	}
	else
	  document.getElementById("num_xiongshui").value="";
}

function FushuiClick()
{
	var TanyeObj=document.getElementById("bFushui");
	if (TanyeObj.checked)
	{
	  document.getElementById("bTanye").checked = false;
	  document.getElementById("bXiongshui").checked=false;
	  //document.getElementById("bFushui").checked=false;
      document.getElementById("bXinbaojiye").checked=false;
      document.getElementById("bFuxcxye").checked = false;
	  document.getElementById("bNaojiye").checked=false;
	  document.getElementById("bNiaoye").checked=false;
      document.getElementById("bOther").checked=false;
      document.getElementById("bRutyyLeft").checked=false;
	  document.getElementById("bRutyyeRight").checked=false;
      document.getElementById("bShuapian").checked=false;
      document.getElementById("bSYNiao").checked=false;
      document.getElementById("bXiZhen").checked=false;
      document.getElementById("bTuPian").checked = false;
      document.getElementById("bGongjtpian").checked = false;
	  
	  document.getElementById("num_tanye").value="";
	  document.getElementById("num_xiongshui").value="";
	  document.getElementById("num_fushui").value="1";
	  document.getElementById("num_xbjye").value="";
	  document.getElementById("num_fxcxye").value="";
	  document.getElementById("num_naojye").value="";
	  document.getElementById("num_niaoye").value="";
	  document.getElementById("num_rtyyleft").value="";
 	  document.getElementById("num_zqgspian").value="";
	  document.getElementById("num_gjtpian").value="";
	  document.getElementById("num_rtyyeright").value="";
	  document.getElementById("bChuancibb").value="";
	  document.getElementById("num_syniao").value="";
	}
	else
	  document.getElementById("num_fushui").value="";
}

function XinbjyClick()
{
	var TanyeObj=document.getElementById("bXinbaojiye");
	if (TanyeObj.checked)
	{
	  document.getElementById("bTanye").checked = false;
	  document.getElementById("bXiongshui").checked=false;
	  document.getElementById("bFushui").checked=false;
      //document.getElementById("bXinbaojiye").checked=false;
      document.getElementById("bFuxcxye").checked = false;
	  document.getElementById("bNaojiye").checked=false;
	  document.getElementById("bNiaoye").checked=false;
      document.getElementById("bOther").checked=false;
      document.getElementById("bRutyyLeft").checked=false;
	  document.getElementById("bRutyyeRight").checked=false;
      document.getElementById("bShuapian").checked=false;
      document.getElementById("bSYNiao").checked=false;
      document.getElementById("bXiZhen").checked=false;
      document.getElementById("bTuPian").checked = false;
      document.getElementById("bGongjtpian").checked = false;
	  
	  document.getElementById("num_tanye").value="";
	  document.getElementById("num_xiongshui").value="";
	  document.getElementById("num_fushui").value="";
	  document.getElementById("num_xbjye").value="1";
	  document.getElementById("num_fxcxye").value="";
	  document.getElementById("num_naojye").value="";
	  document.getElementById("num_niaoye").value="";
	  document.getElementById("num_rtyyleft").value="";
 	  document.getElementById("num_zqgspian").value="";
	  document.getElementById("num_gjtpian").value="";
	  document.getElementById("num_rtyyeright").value="";
	  document.getElementById("bChuancibb").value="";
	  document.getElementById("num_syniao").value="";
	}
	else
	  document.getElementById("num_xbjye").value="";
}

function FuxcxyeClick()
{
	var TanyeObj=document.getElementById("bFuxcxye");
	if (TanyeObj.checked)
	{
	  document.getElementById("bTanye").checked = false;
	  document.getElementById("bXiongshui").checked=false;
	  document.getElementById("bFushui").checked=false;
      document.getElementById("bXinbaojiye").checked=false;
      //document.getElementById("bFuxcxye").checked = false;
	  document.getElementById("bNaojiye").checked=false;
	  document.getElementById("bNiaoye").checked=false;
      document.getElementById("bOther").checked=false;
      document.getElementById("bRutyyLeft").checked=false;
	  document.getElementById("bRutyyeRight").checked=false;
      document.getElementById("bShuapian").checked=false;
      document.getElementById("bSYNiao").checked=false;
      document.getElementById("bXiZhen").checked=false;
      document.getElementById("bTuPian").checked = false;
      document.getElementById("bGongjtpian").checked = false;
	  
	  document.getElementById("num_tanye").value="";
	  document.getElementById("num_xiongshui").value="";
	  document.getElementById("num_fushui").value="";
	  document.getElementById("num_xbjye").value="";
	  document.getElementById("num_fxcxye").value="1";
	  document.getElementById("num_naojye").value="";
	  document.getElementById("num_niaoye").value="";
	  document.getElementById("num_rtyyleft").value="";
 	  document.getElementById("num_zqgspian").value="";
	  document.getElementById("num_gjtpian").value="";
	  document.getElementById("num_rtyyeright").value="";
	  document.getElementById("bChuancibb").value="";
	  document.getElementById("num_syniao").value="";
	}
	else
	  document.getElementById("num_fxcxye").value="";
}

function NaojyClick()
{
	var TanyeObj=document.getElementById("bNaojiye");
	if (TanyeObj.checked)
	{
	  document.getElementById("bTanye").checked = false;
	  document.getElementById("bXiongshui").checked=false;
	  document.getElementById("bFushui").checked=false;
      document.getElementById("bXinbaojiye").checked=false;
      document.getElementById("bFuxcxye").checked = false;
	  //document.getElementById("bNaojiye").checked=false;
	  document.getElementById("bNiaoye").checked=false;
      document.getElementById("bOther").checked=false;
      document.getElementById("bRutyyLeft").checked=false;
	  document.getElementById("bRutyyeRight").checked=false;
      document.getElementById("bShuapian").checked=false;
      document.getElementById("bSYNiao").checked=false;
      document.getElementById("bXiZhen").checked=false;
      document.getElementById("bTuPian").checked = false;
      document.getElementById("bGongjtpian").checked = false;
	  
	  document.getElementById("num_tanye").value="";
	  document.getElementById("num_xiongshui").value="";
	  document.getElementById("num_fushui").value="";
	  document.getElementById("num_xbjye").value="";
	  document.getElementById("num_fxcxye").value="";
	  document.getElementById("num_naojye").value="1";
	  document.getElementById("num_niaoye").value="";
	  document.getElementById("num_rtyyleft").value="";
 	  document.getElementById("num_zqgspian").value="";
	  document.getElementById("num_gjtpian").value="";
	  document.getElementById("num_rtyyeright").value="";
	  document.getElementById("bChuancibb").value="";
	  document.getElementById("num_syniao").value="";
	}
	else
	  document.getElementById("num_naojye").value="";
}

function NiaoyClick()
{
	var TanyeObj=document.getElementById("bNiaoye");
	if (TanyeObj.checked)
	{
	  document.getElementById("bTanye").checked = false;
	  document.getElementById("bXiongshui").checked=false;
	  document.getElementById("bFushui").checked=false;
      document.getElementById("bXinbaojiye").checked=false;
      document.getElementById("bFuxcxye").checked = false;
	  document.getElementById("bNaojiye").checked=false;
	  //document.getElementById("bNiaoye").checked=false;
      document.getElementById("bOther").checked=false;
      document.getElementById("bRutyyLeft").checked=false;
	  document.getElementById("bRutyyeRight").checked=false;
      document.getElementById("bShuapian").checked=false;
      document.getElementById("bSYNiao").checked=false;
      document.getElementById("bXiZhen").checked=false;
      document.getElementById("bTuPian").checked = false;
      document.getElementById("bGongjtpian").checked = false;
	  
	  document.getElementById("num_tanye").value="";
	  document.getElementById("num_xiongshui").value="";
	  document.getElementById("num_fushui").value="";
	  document.getElementById("num_xbjye").value="";
	  document.getElementById("num_fxcxye").value="";
	  document.getElementById("num_naojye").value="";
	  document.getElementById("num_niaoye").value="1";
	  document.getElementById("num_rtyyleft").value="";
 	  document.getElementById("num_zqgspian").value="";
	  document.getElementById("num_gjtpian").value="";
	  document.getElementById("num_rtyyeright").value="";
	  document.getElementById("bChuancibb").value="";
	  document.getElementById("num_syniao").value="";
	}
	else
	  document.getElementById("num_niaoye").value="";
}

function OtherClick()
{
	var TanyeObj=document.getElementById("bOther");
	if (TanyeObj.checked)
	{
	  document.getElementById("bTanye").checked = false;
	  document.getElementById("bXiongshui").checked=false;
	  document.getElementById("bFushui").checked=false;
      document.getElementById("bXinbaojiye").checked=false;
      document.getElementById("bFuxcxye").checked = false;
	  document.getElementById("bNaojiye").checked=false;
	  document.getElementById("bNiaoye").checked=false;
      //document.getElementById("bOther").checked=false;
      document.getElementById("bRutyyLeft").checked=false;
	  document.getElementById("bRutyyeRight").checked=false;
      document.getElementById("bShuapian").checked=false;
      document.getElementById("bSYNiao").checked=false;
      document.getElementById("bXiZhen").checked=false;
      document.getElementById("bTuPian").checked = false;
      document.getElementById("bGongjtpian").checked = false;
	  
	  document.getElementById("num_tanye").value="";
	  document.getElementById("num_xiongshui").value="";
	  document.getElementById("num_fushui").value="";
	  document.getElementById("num_xbjye").value="";
	  document.getElementById("num_fxcxye").value="";
	  document.getElementById("num_naojye").value="";
	  document.getElementById("num_niaoye").value="";
	  document.getElementById("num_rtyyleft").value="";
 	  document.getElementById("num_zqgspian").value="";
	  document.getElementById("num_gjtpian").value="";
	  document.getElementById("num_rtyyeright").value="";
	  document.getElementById("bChuancibb").value="";
	  document.getElementById("num_syniao").value="";
	}
	else
	  document.getElementById("bChuancibb").value="";
}

function RutyyLeftClick()
{
	var TanyeObj=document.getElementById("bRutyyLeft");
	if (TanyeObj.checked)
	{
	  document.getElementById("bTanye").checked = false;
	  document.getElementById("bXiongshui").checked=false;
	  document.getElementById("bFushui").checked=false;
      document.getElementById("bXinbaojiye").checked=false;
      document.getElementById("bFuxcxye").checked = false;
	  document.getElementById("bNaojiye").checked=false;
	  document.getElementById("bNiaoye").checked=false;
      document.getElementById("bOther").checked=false;
      //document.getElementById("bRutyyLeft").checked=false;
	  //document.getElementById("bRutyyeRight").checked=false;
      document.getElementById("bShuapian").checked=false;
      document.getElementById("bSYNiao").checked=false;
      document.getElementById("bXiZhen").checked=false;
      document.getElementById("bTuPian").checked = false;
      document.getElementById("bGongjtpian").checked = false;
	  
	  document.getElementById("num_tanye").value="";
	  document.getElementById("num_xiongshui").value="";
	  document.getElementById("num_fushui").value="";
	  document.getElementById("num_xbjye").value="";
	  document.getElementById("num_fxcxye").value="";
	  document.getElementById("num_naojye").value="";
	  document.getElementById("num_niaoye").value="";
	  document.getElementById("num_rtyyleft").value="1";
 	  document.getElementById("num_zqgspian").value="";
	  document.getElementById("num_gjtpian").value="";
	  //document.getElementById("num_rtyyeright").value="";
	  document.getElementById("bChuancibb").value="";
	  document.getElementById("num_syniao").value="";
	}
	else
	  document.getElementById("num_rtyyleft").value="";
}

function ZhiqgspClick()
{
	var TanyeObj=document.getElementById("bShuapian");
	if (TanyeObj.checked)
	{
	  document.getElementById("bTanye").checked = false;
	  document.getElementById("bXiongshui").checked=false;
	  document.getElementById("bFushui").checked=false;
      document.getElementById("bXinbaojiye").checked=false;
      document.getElementById("bFuxcxye").checked = false;
	  document.getElementById("bNaojiye").checked=false;
	  document.getElementById("bNiaoye").checked=false;
      document.getElementById("bOther").checked=false;
      document.getElementById("bRutyyLeft").checked=false;
	  document.getElementById("bRutyyeRight").checked=false;
      //document.getElementById("bShuapian").checked=false;
      document.getElementById("bSYNiao").checked=false;
      document.getElementById("bXiZhen").checked=false;
      document.getElementById("bTuPian").checked = false;

      document.getElementById("bGongjtpian").checked = false;
	  
	  document.getElementById("num_tanye").value="";
	  document.getElementById("num_xiongshui").value="";
	  document.getElementById("num_fushui").value="";
	  document.getElementById("num_xbjye").value="";
	  document.getElementById("num_fxcxye").value="";
	  document.getElementById("num_naojye").value="";
	  document.getElementById("num_niaoye").value="";
	  document.getElementById("num_other").value="";
	  document.getElementById("num_rtyyleft").value="";
 	  document.getElementById("num_zqgspian").value="1";
	  document.getElementById("num_gjtpian").value="";
	  document.getElementById("num_rtyyeright").value="";
	  document.getElementById("bChuancibb").value="";
	  document.getElementById("num_syniao").value="";
	}
	else
	  document.getElementById("num_zqgspian").value="";
}

function GongjtpClick()
{
	var TanyeObj=document.getElementById("bGongjtpian");
	if (TanyeObj.checked)
	{
	  document.getElementById("bTanye").checked = false;
	  document.getElementById("bXiongshui").checked=false;
	  document.getElementById("bFushui").checked=false;
      document.getElementById("bXinbaojiye").checked=false;
      document.getElementById("bFuxcxye").checked = false;
	  document.getElementById("bNaojiye").checked=false;
	  document.getElementById("bNiaoye").checked=false;
      document.getElementById("bOther").checked=false;
      document.getElementById("bRutyyLeft").checked=false;
	  document.getElementById("bRutyyeRight").checked=false;
      document.getElementById("bShuapian").checked=false;
      document.getElementById("bSYNiao").checked=false;
      document.getElementById("bXiZhen").checked=false;
      document.getElementById("bTuPian").checked = false;
      //document.getElementById("bGongjtpian").checked = false;
	  
	  document.getElementById("num_tanye").value="";
	  document.getElementById("num_xiongshui").value="";
	  document.getElementById("num_fushui").value="";
	  document.getElementById("num_xbjye").value="";
	  document.getElementById("num_fxcxye").value="";
	  document.getElementById("num_naojye").value="";
	  document.getElementById("num_niaoye").value="";
	  document.getElementById("num_rtyyleft").value="";
 	  document.getElementById("num_zqgspian").value="";
	  document.getElementById("num_gjtpian").value="1";
	  document.getElementById("num_rtyyeright").value="";
	  document.getElementById("bChuancibb").value="";
	  document.getElementById("num_syniao").value="";
	}
	else
	  document.getElementById("num_gjtpian").value="";
}

function RutyyRightClick()
{
	var TanyeObj=document.getElementById("bRutyyeRight");
	if (TanyeObj.checked)
	{
	  document.getElementById("bTanye").checked = false;
	  document.getElementById("bXiongshui").checked=false;
	  document.getElementById("bFushui").checked=false;
      document.getElementById("bXinbaojiye").checked=false;
      document.getElementById("bFuxcxye").checked = false;
	  document.getElementById("bNaojiye").checked=false;
	  document.getElementById("bNiaoye").checked=false;
      document.getElementById("bOther").checked=false;
      //document.getElementById("bRutyyLeft").checked=false;
	  //document.getElementById("bRutyyeRight").checked=false;
      document.getElementById("bShuapian").checked=false;
      document.getElementById("bSYNiao").checked=false;
      document.getElementById("bXiZhen").checked=false;
      document.getElementById("bTuPian").checked = false;
      document.getElementById("bGongjtpian").checked = false;
	  
	  document.getElementById("num_tanye").value="";
	  document.getElementById("num_xiongshui").value="";
	  document.getElementById("num_fushui").value="";
	  document.getElementById("num_xbjye").value="";
	  document.getElementById("num_fxcxye").value="";
	  document.getElementById("num_naojye").value="";
	  document.getElementById("num_niaoye").value="";
	  //document.getElementById("num_rtyyleft").value="";
 	  document.getElementById("num_zqgspian").value="";
	  document.getElementById("num_gjtpian").value="";
	  document.getElementById("num_rtyyeright").value="1";
	  document.getElementById("num_syniao").value="";
	  document.getElementById("bChuancibb").value="";
	}
	else
	  document.getElementById("num_rtyyeright").value="";
}

function SYNiaoClick()
{
	var TanyeObj=document.getElementById("bSYNiao");
	if (TanyeObj.checked)
	{
	  document.getElementById("bTanye").checked = false;
	  document.getElementById("bXiongshui").checked=false;
	  document.getElementById("bFushui").checked=false;
      document.getElementById("bXinbaojiye").checked=false;
      document.getElementById("bFuxcxye").checked = false;
	  document.getElementById("bNaojiye").checked=false;
	  document.getElementById("bNiaoye").checked=false;
      document.getElementById("bOther").checked=false;
      document.getElementById("bRutyyLeft").checked=false;
      document.getElementById("bShuapian").checked=false;
      //document.getElementById("bSYNiao").checked=false;
      document.getElementById("bXiZhen").checked=false;
      document.getElementById("bTuPian").checked = false;
      document.getElementById("bGongjtpian").checked = false;
	  
	  document.getElementById("num_tanye").value="";
	  document.getElementById("num_xiongshui").value="";
	  document.getElementById("num_fushui").value="";
	  document.getElementById("num_xbjye").value="";
	  document.getElementById("num_fxcxye").value="";
	  document.getElementById("num_naojye").value="";
	  document.getElementById("num_niaoye").value="";
	  document.getElementById("num_other").value="";
	  document.getElementById("num_rtyyleft").value="";
 	  document.getElementById("num_zqgspian").value="";
	  document.getElementById("num_gjtpian").value="";
	  document.getElementById("num_rtyyeright").value="";
	  document.getElementById("num_syniao").value="1";
	  document.getElementById("bChuancibb").value="";
	}
	else
	  document.getElementById("num_syniao").value="";
}


function XIZHENClick()
{
	var TanyeObj=document.getElementById("bXiZhen");
	if (TanyeObj.checked)
	{
	  document.getElementById("bTanye").checked = false;
	  document.getElementById("bXiongshui").checked=false;
	  document.getElementById("bFushui").checked=false;
      document.getElementById("bXinbaojiye").checked=false;
      document.getElementById("bFuxcxye").checked = false;
	  document.getElementById("bNaojiye").checked=false;
	  document.getElementById("bNiaoye").checked=false;
      document.getElementById("bOther").checked=false;
      document.getElementById("bRutyyLeft").checked=false;
	  document.getElementById("bRutyyeRight").checked=false;
      document.getElementById("bShuapian").checked=false;
      document.getElementById("bSYNiao").checked=false;
      //document.getElementById("bXiZhen").checked=false;
      document.getElementById("bTuPian").checked = false;
      document.getElementById("bGongjtpian").checked = false;
	  
	  document.getElementById("num_tanye").value="";
	  document.getElementById("num_xiongshui").value="";
	  document.getElementById("num_fushui").value="";
	  document.getElementById("num_xbjye").value="";
	  document.getElementById("num_fxcxye").value="";
	  document.getElementById("num_naojye").value="";
	  document.getElementById("num_niaoye").value="";
	  document.getElementById("num_rtyyleft").value="";
 	  document.getElementById("num_zqgspian").value="";
	  document.getElementById("num_gjtpian").value="";
	  document.getElementById("num_rtyyeright").value="";
	  document.getElementById("bChuancibb").value="";
	}
	else
	  document.getElementById("bChuancibb").value="";
}


function TUPIANClick()
{
	var TanyeObj=document.getElementById("bTuPian");
	if (TanyeObj.checked)
	{
	  document.getElementById("bTanye").checked = false;
	  document.getElementById("bXiongshui").checked=false;
	  document.getElementById("bFushui").checked=false;
      document.getElementById("bXinbaojiye").checked=false;
      document.getElementById("bFuxcxye").checked = false;
	  document.getElementById("bNaojiye").checked=false;
	  document.getElementById("bNiaoye").checked=false;
      document.getElementById("bOther").checked=false;
      document.getElementById("bRutyyLeft").checked=false;
	  document.getElementById("bRutyyeRight").checked=false;
      document.getElementById("bShuapian").checked=false;
      document.getElementById("bSYNiao").checked=false;
      document.getElementById("bXiZhen").checked=false;
      //document.getElementById("bTuPian").checked = false;
      document.getElementById("bGongjtpian").checked = false;
	  
	  document.getElementById("num_tanye").value="";
	  document.getElementById("num_xiongshui").value="";
	  document.getElementById("num_fushui").value="";
	  document.getElementById("num_xbjye").value="";
	  document.getElementById("num_fxcxye").value="";
	  document.getElementById("num_naojye").value="";
	  document.getElementById("num_niaoye").value="";
	  document.getElementById("num_rtyyleft").value="";
 	  document.getElementById("num_zqgspian").value="";
	  document.getElementById("num_gjtpian").value="";
	  document.getElementById("num_rtyyeright").value="";
	  document.getElementById("bChuancibb").value="";
	  document.getElementById("num_syniao").value="";
	}
	else
	  document.getElementById("bChuancibb").value="";
}


function GetSpecimenInfo()
{
	var tnum=""
	tspecimennum = 0;
	tspecimeninfo="";
	
	var tempobj=document.getElementById("bTanye");
	if (tempobj.checked)
	{
	  tnum=document.getElementById("num_tanye").value
	  if(tnum=="")
	  {
		  return
	  }
	  
	  tspecimennum += 1;
	  tspecimeninfo += t['TANYE']+"~"+document.getElementById("num_tanye").value;
	}
	
	tempobj=document.getElementById("bXiongshui");
	if (tempobj.checked)
	{
	  tnum=document.getElementById("num_xiongshui").value
	  if(tnum=="")
	  {
		  return
	  }
	  
	  tspecimennum += 1;
	  tspecimeninfo += t['XIONGSHUI']+"~"+document.getElementById("num_xiongshui").value;
	}
	
	tempobj=document.getElementById("bFushui");
	if (tempobj.checked)
	{
	  tnum=document.getElementById("num_fushui").value
	  if(tnum=="")
	  {
		  return
	  }
	  
	  tspecimennum += 1;
	  tspecimeninfo += t['FUSHUI']+"~"+document.getElementById("num_fushui").value;
	}
	
	tempobj=document.getElementById("bXinbaojiye");
	if (tempobj.checked)
	{
	  tnum=document.getElementById("num_xbjye").value
	  if(tnum=="")
	  {
		  return
	  }
	  
	  tspecimennum += 1;
	  tspecimeninfo += t['XINBAOJIYE']+"~"+document.getElementById("num_xbjye").value;
	}
	
	tempobj=document.getElementById("bFuxcxye");
	if (tempobj.checked)
	{
	  tnum=document.getElementById("num_fxcxye").value
	  if(tnum=="")
	  {
		  return
	  }
	  
	  tspecimennum += 1;
	  tspecimeninfo += t['FUQIANGCXY']+"~"+document.getElementById("num_fxcxye").value;
	}
	
	tempobj=document.getElementById("bNaojiye");
	if (tempobj.checked)
	{
	  tnum=document.getElementById("num_naojye").value
	  if(tnum=="")
	  {
		  return
	  }
	  
	  tspecimennum += 1;
	  tspecimeninfo += t['NAOJIYE']+"~"+document.getElementById("num_naojye").value;
	}
	
	tempobj=document.getElementById("bNiaoye");
	if (tempobj.checked)
	{
	  tnum=document.getElementById("num_niaoye").value
	  if(tnum=="")
	  {
		  return
	  }
	  
	  tspecimennum += 1;
	  tspecimeninfo += t['NIAOYE']+"~"+document.getElementById("num_niaoye").value;
	}
	
	tempobj=document.getElementById("bSYNiao");
	if (tempobj.checked)
	{
	  tnum=document.getElementById("num_syniao").value
	  if(tnum=="")
	  {
		  return
	  }
	  
	  tspecimennum += 1;
	  tspecimeninfo += t['SYNIAO']+"~"+document.getElementById("num_syniao").value;
	}

	
  	tempobj=document.getElementById("bOther");
	if (tempobj.checked)
	{
	  tspecimennum += 1;
	  tspecimeninfo += t['OTHER']+"~"+document.getElementById("bChuancibb").value;
	}
	
	tempobj=document.getElementById("bXiZhen");
	if (tempobj.checked)
	{
	  tspecimennum += 1;
	  tspecimeninfo += t['XIZHENCC']+"~"+document.getElementById("bChuancibb").value;
	}

  	tempobj=document.getElementById("bTuPian");
	if (tempobj.checked)
	{
	  tspecimennum += 1;
	  tspecimeninfo += t['TUPIAN']+"~"+document.getElementById("bChuancibb").value;
	}

  	tempobj=document.getElementById("bRutyyLeft");
	if (tempobj.checked)
	{
	  tnum=document.getElementById("num_rtyyleft").value
	  if(tnum=="")
	  {
		  return
	  }
	  
	  tspecimennum += 1;
	  tspecimeninfo += t['RUTYYLEFT']+"~"+document.getElementById("num_rtyyleft").value;
	}
	
	tempobj=document.getElementById("bRutyyeright");
	if (tempobj.checked)
	{
	  tnum=document.getElementById("num_rtyyeright").value
	  if(tnum=="")
	  {
		  return
	  }
	  
	  tspecimennum += 1;
	  tspecimeninfo += t['RUTYYRIGHT']+"~"+document.getElementById("num_rtyyeright").value;
	}
	
	tempobj=document.getElementById("bShuapian");
	if (tempobj.checked)
	{
	  tnum=document.getElementById("num_zqgspian").value
	  if(tnum=="")
	  {
		  return
	  }
	  
	  tspecimennum += 1;
	  tspecimeninfo += t['ZHIQGSPIAN']+"~"+document.getElementById("num_zqgspian").value;
	}

	tempobj=document.getElementById("bGongjtpian");
	if (tempobj.checked)
	{
	  tnum=document.getElementById("num_gjtpian").value
	  if(tnum=="")
	  {
		  return
	  }
	  
	  tspecimennum += 1;
	  tspecimeninfo += t['GONGJTPIAN']+"~"+document.getElementById("num_gjtpian").value;
	}
	
	//alert(tspecimeninfo)

}

function Print()
{	
	var xlApp,xlsheet,xlBook
    var GetPrescPath=document.getElementById("GetRepPath");
	if (GetPrescPath) {var encmeth=GetPrescPath.value} 
	else {var encmeth=''};
	if (encmeth!="") 
	{
			var TemplatePath=cspRunServerMethod(encmeth);
	}
	var Template=TemplatePath+"DHCPisAppCell.xls";
	xlApp = new ActiveXObject("Excel.Application")
	xlBook = xlApp.Workbooks.Add(Template);
 	xlsheet = xlBook.ActiveSheet;	
 	      xlsheet.cells(2,1).value="*"+document.getElementById("TMRowid").value+"*"
		    xlsheet.cells(3,4).value=document.getElementById("TMRowid").value
	      xlsheet.cells(3,10).value=document.getElementById("RegNo").value
	      //alert(document.getElementById("OEorditemID").value)
	      xlsheet.cells(3,17).value=document.getElementById("OEorditemID").value
	      //alert(xlsheet.cells(3,17).value)
	      
	      xlsheet.cells(5,3).value=document.getElementById("Name").value
	  	  xlsheet.cells(5,10).value=document.getElementById("Sex").value
	      xlsheet.cells(5,15).value=document.getElementById("Age").value
	      xlsheet.cells(5,21).value=document.getElementById("DOB").value
	      xlsheet.cells(7,4).value=document.getElementById("TelNo").value
	      xlsheet.cells(7,11).value=document.getElementById("AdmType").value
	      //alert(document.getElementById("FeeType").value)
	      xlsheet.cells(7,17).value=document.getElementById("FeeType").value
	      xlsheet.cells(8,4).value=document.getElementById("Address").value
	      //alert(document.getElementById("InpoNo").value)
	      xlsheet.cells(6,4).value=document.getElementById("InpoNo").value
	      xlsheet.cells(6,11).value=document.getElementById("RoomNo").value
	    	xlsheet.cells(6,21).value=document.getElementById("BedNo").value
	    	
	    	xlsheet.cells(10,14).value=document.getElementById("AppDoc").value
	    	xlsheet.cells(10,21).value=document.getElementById("AppDate").value
	    	xlsheet.cells(10,4).value=document.getElementById("AppLoc").value	    	
	    	
	    	var GetSpecimensFunc=document.getElementById("autoNumAdd").value
			var info=cspRunServerMethod(GetSpecimensFunc,ttmrowid)
	    	xlsheet.cells(12,1).value=info
	    	/*
	    	xlsheet.cells(14,4).value=document.getElementById("TumourDate").value
	    	xlsheet.cells(14,11).value=document.getElementById("TumourPosition").value
	    	xlsheet.cells(14,21).value=document.getElementById("TumourSize").value
	    	if(document.getElementById("Transfer").checked==true)
	    	{
	    		var Transfer="是"
	    	}else
	    	{
	    		var Transfer="否"
	    	}
	    	xlsheet.cells(15,4).value=Transfer
	    	xlsheet.cells(15,10).value=document.getElementById("TransPos").value
	    	xlsheet.cells(15,21).value=document.getElementById("TumourSudu").value
	    	
	    	xlsheet.cells(16,6).value=document.getElementById("BBCaijiShijian").value
	    	var YJHistory=""
	    	if(document.getElementById("bFirstYJ").checked==true)
	    	{
	    		YJHistory="初潮"
	    	}
	    	xlsheet.cells(16,14).value=YJHistory
	    	xlsheet.cells(16,21).value=document.getElementById("YJQuatity").value
	    	xlsheet.cells(17,4).value=document.getElementById("YJZhouqi").value
	    	xlsheet.cells(17,11).value=document.getElementById("LastDate").value
	    	xlsheet.cells(17,21).value=document.getElementById("CXQuatity").value
	    	if(document.getElementById("bRGCure").checked==true)
	    	{
	    		var bRGCure="是"
	    	}else
	    	{
	    		var bRGCure="否"
	    	}
	    	xlsheet.cells(18,7).value=bRGCure
	    	xlsheet.cells(18,11).value=document.getElementById("RGDate").value
	    	xlsheet.cells(18,21).value=document.getElementById("RGJiliang").value
	    	*/
	    	
	    	xlsheet.cells(20,1).value=document.getElementById("ClinicRecord").value
	    	xlsheet.cells(24,1).value=document.getElementById("ClinicDiag").value
	    	
	    	xlsheet.PrintOut 
	    	xlBook.Close (savechanges=false); 
	    	xlBook=null			
	    	xlApp.Quit();
	    	xlApp=null;
	    	xlsheet=null 
	    	//window.setInterval("Cleanup();",1);
}


function Cleanup() 
{   
    window.clearInterval("");   
    CollectGarbage();   
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
                    Bar.PatName=PName;
                    Bar.Sex=document.getElementById("Sex").value;
                    Bar.Age=document.getElementById("Age").value;
                    Bar.BedCode=BedNo;
                    Bar.PrintOut();
                }
    
    
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
	var RecLoc=item[20]
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
	    	xlsheet.cells(6,7).value=RecLoc.split("-")[1] //"病理科"
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

function SaveClinicRecordkey()
{
  	var ClinicRecord=document.getElementById("ClinicRecord").value
  	var docdr=document.getElementById("AppDocDR").value
  	var docname=document.getElementById("AppDoc").value
  	var AppLocDR=document.getElementById('AppLocDR').value
	var GetDirRowIdbyTypeFun=document.getElementById("GetDirRowIdbyType").value;
  	var DirRowId=cspRunServerMethod(GetDirRowIdbyTypeFun,3,docdr,"")
  	if (DirRowId=="")
  	{
	 var GetDirRowIdbyTypeFun=document.getElementById("GetDirRowIdbyType").value;
  	 var dirRowId=cspRunServerMethod(GetDirRowIdbyTypeFun,3,"",0)
  	 
  	 var DIRInfo=AppLocDR+"^"+2+"^"+2+"^"+docname+"^"+dirRowId+"^"+"Y"+"^"+3+"^"+docdr	
     
	 var InsertDirFun=document.getElementById("InsertDir").value;
   	 var DirRowId=cspRunServerMethod(InsertDirFun,DIRInfo)
   	 if (ClinicRecord=="") return
	 var code=2,Name="ClinicRecord",Type=3
	 var ContentInfo=AppLocDR+"^"+DirRowId+"^"+code+"^"+Name+"^"+ClinicRecord+"^"+""+"^"+Type
	 var InsertContentFun=document.getElementById("InsertContent").value;
   	 var InsertContent=cspRunServerMethod(InsertContentFun,ContentInfo)  
   	 Refresh()	
	}
	else
	{
     if (ClinicRecord=="") return
	 var code=2,Name="ClinicRecord",Type=3
	 var ContentInfo=AppLocDR+"^"+DirRowId+"^"+code+"^"+Name+"^"+ClinicRecord+"^"+""+"^"+Type
	 var InsertContentFun=document.getElementById("InsertContent").value;
   	 var InsertContent=cspRunServerMethod(InsertContentFun,ContentInfo) 
	 Refresh()
	} 
}

function SaveOperseekey()
{
	//alert("1")
  	var OperationSee=document.getElementById("OperationSee").value
  	var docdr=document.getElementById("AppDocDR").value
  	var docname=document.getElementById("AppDoc").value
  	var AppLocDR=document.getElementById('AppLocDR').value
	var GetDirRowIdbyTypeFun=document.getElementById("GetDirRowIdbyType").value;
  	var DirRowId=cspRunServerMethod(GetDirRowIdbyTypeFun,3,docdr,"")
  	if (DirRowId=="")
  	{
	 var GetDirRowIdbyTypeFun=document.getElementById("GetDirRowIdbyType").value;
  	 var dirRowId=cspRunServerMethod(GetDirRowIdbyTypeFun,3,"",0)
  	 
  	 var DIRInfo=AppLocDR+"^"+2+"^"+2+"^"+docname+"^"+dirRowId+"^"+"Y"+"^"+3+"^"+docdr	
     
	 var InsertDirFun=document.getElementById("InsertDir").value;
   	 var DirRowId=cspRunServerMethod(InsertDirFun,DIRInfo)
   	 if (ClinicRecord=="") return
	 var code=2,Name="ClinicRecord",Type=3
	 var ContentInfo=AppLocDR+"^"+DirRowId+"^"+code+"^"+Name+"^"+ClinicRecord+"^"+""+"^"+Type
	 var InsertContentFun=document.getElementById("InsertContent").value;
   	 var InsertContent=cspRunServerMethod(InsertContentFun,ContentInfo) 
   	 Refresh()	
	}
	else
	{
     if (OperationSee=="") return
	 var code=3,Name="OperationSee",Type=3
	 var ContentInfo=AppLocDR+"^"+DirRowId+"^"+code+"^"+Name+"^"+OperationSee+"^"+""+"^"+Type
	 var InsertContentFun=document.getElementById("InsertContent").value;
   	 var InsertContent=cspRunServerMethod(InsertContentFun,ContentInfo) 
	 Refresh()
	} 
}		
function ClinicTemplatekey()
{
    
  	var docdr=document.getElementById("AppDocDR").value

	var GetDirRowIdbyTypeFun=document.getElementById("GetDirRowIdbyType").value;
  	var DirDR=cspRunServerMethod(GetDirRowIdbyTypeFun,3,docdr,"")
    var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCPisAppTemplList"+"&DirDR="+DirDR+"&UserID="+docdr+"&Code="+2;    
    var mynewlink=open(link,"DHCPisAppTemplList","scrollbars=yes,resizable=yes,top=50,left=200,width=500,height=600");

}

function OperTemplatekey()
{
	
  	var docdr=document.getElementById("AppDocDR").value
  	
	var GetDirRowIdbyTypeFun=document.getElementById("GetDirRowIdbyType").value;
  	var DirDR=cspRunServerMethod(GetDirRowIdbyTypeFun,3,docdr,"")
    
    var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCPisAppTemplList"+"&DirDR="+DirDR+"&UserID="+docdr+"&Code="+3;    
    var mynewlink=open(link,"DHCPisAppTemplList","scrollbars=yes,resizable=yes,top=50,left=200,width=500,height=600");

	
}

function ClinicLocTemplatekey()
{
    
  	var LocDr=document.getElementById('AppLocDR').value

    var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCPisAppLocTemplList"+"&LocDr="+LocDr+"&Code="+2;    
    var mynewlink=open(link,"DHCPisAppTemplList","scrollbars=yes,resizable=yes,top=50,left=200,width=500,height=600");

}

function OperLocTemplatekey()
{
	
  	var LocDr=document.getElementById('AppLocDR').value
    
    var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCPisAppLocTemplList"+"&LocDr="+LocDr+"&Code="+3;    
    var mynewlink=open(link,"DHCPisAppTemplList","scrollbars=yes,resizable=yes,top=50,left=200,width=500,height=600");

	
}

document.body.onload = BodyLoadHandler;