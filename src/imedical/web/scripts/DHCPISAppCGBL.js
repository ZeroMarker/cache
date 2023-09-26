//DHCPISAppCGBL.js

var bNewPatient = 1
var tstatuscode=0
var tspecimennum=0
var tspecimeninfo=""
var ttmrowid=""
var paadmdr=""
var orditemdr=""
var tclsdr=""
var tclscode="10"
var ComName=""
var OEorditem=""
var autoNumber="1"//自动生成的标本序号
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
    
    document.getElementById("OrderDr").value=orditemdr
    document.getElementById("RegisterNum").value=paadmdr
    
    //通过医嘱号get 医嘱名
	var GetOEorditeminfo=document.getElementById("GetOEorditem").value
	var OEorditeminfo = cspRunServerMethod(GetOEorditeminfo,orditemdr)
	var item=OEorditeminfo.split("^")
	OEorditem=item[1]
	
    //通过医嘱名判定是否选择冰冻
    if(OEorditem==t['FROST'])
	{
		document.getElementById("Frost").checked=true;
		document.getElementById("OEorditem").value=t['FROST']
		tclscode="11"
	}
	else
	{
		document.getElementById("Frost").checked=false;
		document.getElementById("OEorditem").value=t['CGBL']
	}
    document.getElementById("Frost").disabled=true
    
    var POrderValue=document.getElementById("POrditemDR").value
    if(POrderValue=="") 
    {
	    var orditem=orditemdr.split("||")
	    POrderValue="*"+orditem[0]+"-"+orditem[1]+"*"
    }
    document.getElementById("POrditemDR").value=POrderValue

   	ComName=document.getElementById("ComponentName").value
   	if (ComName=="") ComName="DHCPISAppCGBL"
   	document.getElementById("ComponentName").value=ComName
   	
   	var AppDateObj=document.getElementById("AppDate")
    if (AppDateObj.value=="")
    	AppDateObj.value=DateDemo()
    
    /*
    var TDateObj=document.getElementById("TumourDate")
    if (TDateObj.value=="")
    	TDateObj.value=DateDemo()
    
    var WDateObj=document.getElementById("LastCata")
    if (WDateObj.value=="")
    	WDateObj.value=DateDemo()
   	 */
   	//-----------------all button action!Begin------------------
   	var SpeAddobj=document.getElementById("SpecimenAdd")
   	if (SpeAddobj)
   	{
		SpeAddobj.onclick=SpeAddkey
   	}
   
   	var SpeEditobj=document.getElementById("SpecimenEdit")
   	if (SpeEditobj)
   	{
		SpeEditobj.onclick=SpeEditkey
   	}
   
   	var SpeDelobj=document.getElementById("SpecimenDel")
   	if (SpeDelobj)
   	{
		SpeDelobj.onclick=SpeDelkey
   	}
   
   	var SendAppobj=document.getElementById("SendApp")
  	 if (SendAppobj)
   	{
		SendAppobj.onclick=SendAppkey
   	}
   	
    var BtnSaveobj=document.getElementById("BtnSave")
  	 if (BtnSaveobj)
   	{
		BtnSaveobj.onclick=BtnSavekey
   	}
   
   	var CancelAppobj=document.getElementById("CancelApp")
   	if (CancelAppobj)
   	{
		CancelAppobj.onclick=CancelAppkey
   	}
   	
   	//var PrintObj=document.getElementById("PrintSheet")
   	//if (PrintObj)
   	//{
	//	PrintObj.onclick=PrintSheetkey
   //	}
   	
   	//var PrintBarObj=document.getElementById("PrintBarApp")
   	//{
	   	//PrintBarObj.onclick=PrintBarAppkey
	//}
	var PrintAppObj=document.getElementById("PrintApp")
   	{
	   	PrintAppObj.onclick=PrintAppkey
	}
   	var EndCataObj=document.getElementById("EndCata")
   	if(EndCataObj)
   	{
	   	EndCataObj.onclick=EndCatakey
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

   //-----------------all button action!End------------------
   	var GetClsdrFun=document.getElementById("ClassDr").value
 	var CLSDR=cspRunServerMethod(GetClsdrFun,tclscode)
	
    if (CLSDR!="")
	{	  
	 	//document.getElementById("ClsDR").value = CLSDR;
	  	tclsdr = CLSDR
    }

    //get tmrowid
    var GetTmrowidFun=document.getElementById("GetTmRowId").value
  	var TMROWID=cspRunServerMethod(GetTmrowidFun,Locdr,orditemdr)
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
		var TMROWID = cspRunServerMethod(TestmasterAddFun,Locdr,tclsdr)
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
	
	var freshFlag=document.getElementById("Refresh").value
   	if (freshFlag=="")
   	{
	   freshFlag=1
	   document.getElementById("Refresh").value=freshFlag
       Refresh()
   	}

	//alert(tstatuscode)
	if(tstatuscode==1)
	{
		document.getElementById("SendApp").disabled=true
		document.getElementById("BtnSave").disabled=true
		document.getElementById("SpecimenAdd").disabled=true
		document.getElementById("SpecimenDel").disabled=true
	}
	else if(tstatuscode==2)
	{
		document.getElementById("SendApp").disabled=true
		document.getElementById("BtnSave").disabled=true
		document.getElementById("CancelApp").disabled=true
		
		document.getElementById("SpecimenAdd").disabled=true
		document.getElementById("SpecimenDel").disabled=true
	}
	else
	{
		document.getElementById("CancelApp").disabled=true
		//document.getElementById("PrintBarApp").disabled=true
		//document.getElementById("PrintSheet").disabled=true
		document.getElementById("PrintApp").disabled=true
		
	}
	document.getElementById("SpeNum").value=autoNumber
	GetPatInfo()
	GetAppInfo()
	
	GetWomanTumourInfo()
	AutoNumber()
	document.getElementById("SpecimenDel").disabled=true
	document.getElementById("SpecimenEdit").disabled=true
 }
 
 function GetPatInfo()
 {
	if(bNewPatient==1)
	{
		
		var GetPaadmInfoFun=document.getElementById("PatInfo").value;
  		var PATINFO=cspRunServerMethod(GetPaadmInfoFun,paadmdr)
    	if (PATINFO!="")
		{   
			
			var item=PATINFO.split("^");
		
			//RegNo,Name,strDOB,strAge,$g(SexDesc),patienttype,typedesc 7
			//$g(LocName),IPNO,wardname,bedname,$g(Locdr),SexDr,WardDr, 14
			//roomdesc,feetype,Docdr,DocName,Telphone,Height,Weight, 21
			//address,SEXDR,feetypedr 24
    		document.getElementById("RegisterNum").value=item[0];
			document.getElementById("PName").value=item[1];
			
			//2008-5-1-----1/5/2008 ??
			var vdate3=item[2]
			var ChangDFun=document.getElementById("DateChange3to4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("PBirthday").value=vdate4;
			
			document.getElementById("PAge").value=item[3];
			
			//sex dr??
			document.getElementById("PSex").value=item[4];
			document.getElementById("SexDr").value=item[22];
			
			document.getElementById("PTel").value=item[18];
			document.getElementById("PAddress").value=item[21];
			
			document.getElementById("PType").value=item[6];
			document.getElementById("AdmtypeDR").value=item[5];
		
			document.getElementById("PChargeType").value=item[15];
			document.getElementById("CharegetypeDR").value=item[23];

			document.getElementById("InpoNo").value=item[8];
			document.getElementById("RoomNo").value=item[9];
			document.getElementById("BedNo").value=item[10];
			document.getElementById("AppDoc").value=item[17];
			
			var item7=item[7].split("-");
			document.getElementById("AppDep").value=item7[1];
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
    		document.getElementById("RegisterNum").value=item[9]
			document.getElementById("PName").value=item[1];
			
			var vdate3=item[4]
			var ChangDFun=document.getElementById("DateChange3to4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("PBirthday").value=vdate4;
			//document.getElementById("Age").value="";
			
			var titem1=item[3].split("~")
			document.getElementById("PSex").value=titem1[1];
			document.getElementById("SexDr").value=titem1[0];
			
			document.getElementById("PTel").value=item[8];
			document.getElementById("PAddress").value=item[7];
			
			var titem2=item[5].split("~")
			document.getElementById("PType").value=titem2[1];
			document.getElementById("AdmtypeDR").value=titem2[0];
		
			var titem3=item[6].split("~")
			document.getElementById("PChargeType").value=titem3[1];
			document.getElementById("CharegetypeDR").value=titem3[0]

			document.getElementById("RoomNo").value=item[11];
			document.getElementById("BedNo").value=item[12];
			document.getElementById("InpoNo").value=item[10];
		}
		
		var GetPaadmInfoFun=document.getElementById("PatInfo").value;
  		var PATINFO=cspRunServerMethod(GetPaadmInfoFun,paadmdr)
  		
    	if (PATINFO!="")
		{   
			var item=PATINFO.split("^");
			
			//RegNo,Name,strDOB,strAge,$g(SexDesc),patienttype,typedesc 7
			//$g(LocName),IPNO,wardname,bedname,$g(Locdr),SexDr,WardDr, 14
			//roomdesc,feetype,Docdr,DocName,Telphone,Height,Weight,address 22
			document.getElementById("AppDoc").value=item[17];
			
			var item7=item[7].split("-");
			document.getElementById("AppDep").value=item7[1];
        	document.getElementById("AppLocDR").value=item[11];
			document.getElementById("PAge").value=item[3];
			document.getElementById("PChargeType").value=item[15];
		}
	}
 }
 
 function GetAppInfo()
 {		
	 if(bNewPatient==1)
	{
		
		var GetAppInfoFun=document.getElementById("GetAppInfo").value;
  		var APPINFO=cspRunServerMethod(GetAppInfoFun,ttmrowid)
         //alert ("1+"+APPINFO)
    	if (APPINFO!="")
		{   
			var item=APPINFO.split("^");
			
			if((item[1]=="")&&(item[5]=="")&&(item[2]==""))
			{
				var AppDeptDr=document.getElementById("AppLocDR").value
				var RegisterNum=document.getElementById("RegisterNum").value
				var GetLastTMIDFunction=document.getElementById("GetLastTMID").value;
  				var LastTMID=cspRunServerMethod(GetLastTMIDFunction,Locdr,RegisterNum,AppDeptDr)
  				//alert(LastTMID)
  				if(LastTMID!="")
  				{
	  				var GetAppInfoFun=document.getElementById("GetAppInfo").value;
	  				//alert(Locdr+"+"+paadmdr+"+"+AppDeptDr)
	  				var APPINFO=cspRunServerMethod(GetAppInfoFun,LastTMID)
	 			    //alert(APPINFO)
	    			if (APPINFO!="")
					{   
						var item=APPINFO.split("^");
						//alert(item[1])
						if(item[1]!='')
						{
							document.getElementById("ClinicRecord").value=item[1]
						}
						if(item[5]!='')
						{
							document.getElementById("ClinicDiag").value=item[5]
						}
						if(item[2]!='')
						{
							document.getElementById("OperationSee").value=item[2]
						}
					}
  				}
			}
			if(item[1]!='')
			{
				//alert(item[1])
				document.getElementById("ClinicRecord").value=item[1]
			}
			if(item[5]!='')
			{
				document.getElementById("ClinicDiag").value=item[5]
			}
			else
			{
				var GetMainDiagoseFunction=document.getElementById("MainDiagInfo").value;
  				var value=cspRunServerMethod(GetMainDiagoseFunction,paadmdr)

    			document.getElementById("ClinicDiag").value=value
			}
			if(item[2]!='')
			{
				document.getElementById("OperationSee").value=item[2]
			}
		}
		
		// get patient main diagonse 
		
  	    // get patient default current status 
    	//var GetCurrentStatusFunction=document.getElementById("GetCurrentStatusFunction").value;
  		//var value=cspRunServerMethod(GetCurrentStatusFunction,paadmdr)
		//alert(value)
		//if (value!='')
		//{	
    	//	document.getElementById("ClinicRecord").value=value;
		//}

    	/*
		var GetDiagInfoFun=document.getElementById("MainDiagInfo").value;
  		var DIAGINFO=cspRunServerMethod(GetDiagInfoFun,paadmdr)
    	if (DIAGINFO!="")
		{   
			var item=DIAGINFO.split("~")
			//Info_DiagDR,DiagName,
    		document.getElementById("ClinicRecord").value=item[1]
		}*/

		var GetOrdInfoFun=document.getElementById("OrderInfo").value;
  		var ORDERINFO=cspRunServerMethod(GetOrdInfoFun,orditemdr)
  		
    	if (ORDERINFO!="")
		{   
			var item=ORDERINFO.split("^");
			
			//arcimid,strOrderName,strDate,strTime,requestdoc,ssusrdr, 6
			//strAccessionNum,SGroupDesc,subCatDesc,CatDesc,ifbed,price 12
			//Num,TotalPrice,billed,$g(ItemStatusCode),$g(ServerMaterial) 17
			//RecLocdr,$g(ResultFlag),strCommon,RecLocDesc 21
    		//document.getElementById("AppDep").value=item[20];
        	//document.getElementById("AppLocDR").value=item[17];
		
			//document.getElementById("AppDoc").value=item[4];//dln 20081101 为了解决打印报??m_CPMPrintAry未定义??的问题
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
			//if(item[0]=="1")
			//	document.getElementById("Frost").checked=true
			//else
			//	document.getElementById("Frost").checked=false

    		document.getElementById("AppDep").value=item[7];
        	document.getElementById("AppLocDR").value=item[6];

			document.getElementById("AppDoc").value=item[11];
			
			document.getElementById("AppDocDR").value=item[10];
			
						
			var vdate3=item[8]
			var ChangDFun=document.getElementById("DateChange3to4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("AppDate").value=vdate4
			if(item[1]!='')
			{
				document.getElementById("ClinicRecord").value=item[1]
			}
			
			document.getElementById("ClinicDiag").value=item[5]
			document.getElementById("OperationSee").value=item[2]
		}
	}	
 }
 
 function GetWomanTumourInfo()
 {
	  //Get patient tumour information
	  var GetTumourInfo=document.getElementById("TumourInfo");
      if (GetTumourInfo)
      {
         var returnTumInfoVal;
         var enmeth=GetTumourInfo.value;
         var returnTumInfoVal=cspRunServerMethod(enmeth,ttmrowid)
         
         if (returnTumInfoVal!="")
	     {  //alert(returnTumInfoVal)
	        var item=returnTumInfoVal.split("^");
		    document.getElementById("TumourPosition").value=item[1];
		    document.getElementById("TumourSize").value=item[2];
		    if (item[0]!="")
		    {
			    enmeth=document.getElementById("DateChange3to4").value;
			    item[0]=cspRunServerMethod(enmeth,item[0]);
		    }
		    document.getElementById("TumourDate").value=item[0];
		    if (item[5]=="Y") var RadioCure=1;
		    else var RadioCure=0;
		    document.getElementById("RadioCure").checked=RadioCure;
		    if (item[6]=="Y") var ChemicalCure=1;
		    else var ChemicalCure=0;
		    document.getElementById("ChemicalCure").checked=ChemicalCure;
		    if (item[3]=="Y") var Transfer=1;
		    else var Transfer=0;
		    document.getElementById("Transfer").checked=Transfer;

		    document.getElementById("TransPos").value=item[4];
		    document.getElementById("memo").value=item[7];
		    document.getElementById("TTumourRowId").value=item[8];
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
		  	document.getElementById("TransPos").disabled=false
		  	document.getElementById("memo").disabled=false   
		  	document.getElementById("ClinicRecord").disabled=false
		  	document.getElementById("ClinicDiag").disabled=false
		  	document.getElementById("OperationSee").disabled=false
		  	document.getElementById("SpeNum").disabled=false
		  	document.getElementById("SpePos").disabled=false
		  	document.getElementById("SpeMemo").disabled=false  
		  	document.getElementById("RegisterNum").disabled=false
		  	document.getElementById("PTel").disabled=false
		  	document.getElementById("PAddress").disabled=false
		  	document.getElementById("OrderDr").disabled=false
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
		  	document.getElementById("ClinicRecord").disabled=true
		  	document.getElementById("ClinicDiag").disabled=true
		  	document.getElementById("SpeNum").disabled=true
			document.getElementById("SpePos").disabled=true
		  	document.getElementById("SpeMemo").disabled=true
		  	document.getElementById("OperationSee").disabled=true
		  	document.getElementById("RegisterNum").disabled=true
		  	document.getElementById("PTel").disabled=true
		  	document.getElementById("PAddress").disabled=true
		  	document.getElementById("OrderDr").disabled=true
		 }   
      }
		  
	  //Get patient women information
	  var tsexdes=document.getElementById("PSex").value
	  if(tsexdes==t['SEXNV'])
	  {
	  	var GetWomenInfo=document.getElementById("WomenInfo");
      	if (GetWomenInfo)
      	{	
        	var returnWomInfoVal;
         	var enmeth=GetWomenInfo.value;
        	returnWomInfoVal=cspRunServerMethod(enmeth,ttmrowid);

        	//enmeth=密文	ttmrowid=583		returnWomInfoVal=
         	if (returnWomInfoVal!="")
	     	{   
	        	var item=returnWomInfoVal.split("^");

		    	if (item[0]!="")
		    	{
			    	enmeth=document.getElementById("DateChange3to4").value;
			    	item[0]=cspRunServerMethod(enmeth,item[0]);
		    	}
		    	document.getElementById("LastCata").value=item[0];
		    	if (item[1]=="Y") var endCata=1;
		    	else var endCata=0;
		    	document.getElementById("EndCata").checked=endCata;
		    	document.getElementById("Tai").value=item[2];
		    	document.getElementById("Chan").value=item[3];
		    	document.getElementById("TWomenRowId").value=item[5];
	     	}
      	}
      	
	  }
	  
	  if(bNewPatient==1)
      {
	     document.getElementById("LastCata").disabled=false
	 	 document.getElementById("EndCata").disabled=false
		 document.getElementById("Tai").disabled=false
		 document.getElementById("Chan").disabled=false
      }
      else
      {
	     document.getElementById("LastCata").disabled=true
	 	 document.getElementById("EndCata").disabled=true
		 document.getElementById("Tai").disabled=true
		 document.getElementById("Chan").disabled=true
      }
 }
 
 function SpeAddkey(str)
 { 
	var SpeNum=document.getElementById("SpeNum").value;
    var SpePos=document.getElementById("SpePos").value;
    var SpeMemo=document.getElementById("SpeMemo").value;
    var TMrowid=document.getElementById("TMrowid").value;
    if ((SpeNum=="")||(SpePos=="")||(TMrowid==""))
    {
	   alert(t['NOTNULL']);
	   return;
    }

    if((SpePos=="宫颈")&&(SpeMemo==""))
    {
    	alert(t['GongJing'])
    	return;
    }

    var SpeAddFun=document.getElementById("SpeAddFunction").value;
    var ret=cspRunServerMethod(SpeAddFun,TMrowid+"^"+SpeNum+"^"+SpePos+"^"+SpeMemo+"^"+"^"+"^")
	if (ret=="-916")
    {
	   alert(t['SpeAddWrongNo']);
	}
    else if (ret.split("-")[0]=="") //Such as return -901,-915 or other SQL error,which is initial with "-".
    {
	   alert(t['SpeAddFailure']);
	}
    else
    {
	var tsclass="0"
	var UpdateSpecimenType=document.getElementById("UpdateSpecimenType").value;
	var sql=cspRunServerMethod(UpdateSpecimenType,tsclass,ret)
    }
	AutoNumber()
	BtnSavekey(str)
	Refresh()
 }
 
 function SpeDelkey(str)
 {  
	selectrow=SelectedRow;		
    var SpeRowId=document.getElementById("SpeRowId").value;
    if (SpeRowId=="")
    {
	   alert(t['NOTNULL']);
	   return;
    }
    var SpeDelFun=document.getElementById("SpeDelFunction").value;
    var ret=cspRunServerMethod(SpeDelFun,SpeRowId)
    if (ret.split("-")[0]=="") //Such as return -901,-915 or other SQL error,which is initial with "-".
    {
	   alert(t['SpeDelFailure']);
	}
    else
    {
	   //alert(t['SpeDelSuccess']);
	}
	BtnSavekey(str)
	Refresh()
		
	document.getElementById("SpecimenDel").disabled=true
	document.getElementById("SpecimenEdit").disabled=true
	document.getElementById("SpecimenAdd").disabled=false
 }
 
 function SpeEditkey(str)
 { 
	selectrow=SelectedRow;	
	var SpeNum=document.getElementById("SpeNum").value;
    var SpePos=document.getElementById("SpePos").value;
    var SpeMemo=document.getElementById("SpeMemo").value;
    var SpeRowId=document.getElementById("SpeRowId").value;
    if ((SpeNum=="")||(SpePos==""))
    {
	   alert(t['NOTNULL']);
	   return;
    }
    if (SpeRowId=="")
    {
	   alert(t['CHOOSELINE']);
	   return;
    }
    var SpeEditFun=document.getElementById("SpeEditFunction").value;
    var ret=cspRunServerMethod(SpeEditFun,SpeNum+"^"+SpePos+"^"+SpeMemo+"^"+"^"+"^",SpeRowId)
    if (ret.split("-")[0]=="") //Such as return -901,-915 or other SQL error,which is initial with "-".
    {
	   alert(t['SpeEditFailure']);
	}
    else
    {
	  // alert(t['SpeEditSuccess']);
	}
	BtnSavekey(str)
	Refresh()
	document.getElementById("SpecimenDel").disabled=true
	document.getElementById("SpecimenEdit").disabled=true
	document.getElementById("SpecimenAdd").disabled=false
 }
 
 function SendAppkey(str)
 { 
 	//validate specimens
 	var Objtbl=document.getElementById('tDHCPISAppCGBL')
	var Rows=Objtbl.rows.length-1
	if(Rows<1)
	{
		alert(t['NOTNULL'])
		return
	}
 	
    var TMrowid=document.getElementById("TMrowid").value;
    var operResult=document.getElementById("OperationSee").value;
    if (TMrowid=="")
    {
	   alert(t['NOTNULL']);
	   return;
    }
    if (operResult=="")
    {
	   alert(t['operResultNOTNULL']);
	   return;
    }
    
    SetPatInfo()
    SetAppInfo()
    SetWomanTumourInfo()
    SetAppStatus()
 	 // Print()
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
		 
	     var SetPatInfoFun=document.getElementById("AddPatInfo").value;
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
		 var tbingdong=""
		 
		 if(document.getElementById('Frost').checked)
		 	tbingdong="1"
		 else
		 	tbingdong="0"
		 
		 appinfo+=document.getElementById('ClinicRecord').value+"^"
		 appinfo+=document.getElementById('OperationSee').value+"^^^"
		 appinfo+=document.getElementById('ClinicDiag').value+"^"+tbingdong+"^^^"
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
 
 function SetWomanTumourInfo()//DLN 2008-09-12
 {	
	 if(bNewPatient==1)
	 {
		var tsexdes=document.getElementById("PSex").value
		if(tsexdes==t['SEXNV'])
		{	
			var jjdate=document.getElementById("LastCata").value
			var twinfo=""
			if(jjdate!="")// && jjdate!=DateDemo()) //???? DLN 2008-09-12
			{
				
				twinfo+=ttmrowid+"^"
			
				var DateChangeFun=document.getElementById("DateChange4to3").value
				var tdate=cspRunServerMethod(DateChangeFun,jjdate)
				twinfo+=tdate+"^"
			
				tjj="N" //末次月经不为空?A则肯定没有绝经
				/*
				var tjjobj=document.getElementById("EndCata")
				if(tjjobj.checked)
				{
					tjj="Y"
				}
				else
				{
					tjj="N"
				}
				*/
				twinfo+=tjj+"^"
						
			}else
			{
				 if(document.getElementById("EndCata").checked)
				 {
					twinfo+=ttmrowid+"^"+""+"^"+"Y"+"^"
					//twinfo=ttmrowid+"^"+"LastCata"+"^"+"EndCata"+"^"
							
				}else
				{

					//alert(t['WWomenInfo'])
					return	
				}
			}
			var ttai=document.getElementById("Tai").value
			var tchan=document.getElementById("Chan").value
			
			twinfo+=ttai+"^"+tchan+"^"	
			//twinfo=ttmrowid+"^"+LastCata+"^"+EndCata+"^"+Tai+"^"+Chan+"^"
				var SetWomaninfoFun=document.getElementById("AddWomenInfo").value
				var womanid=cspRunServerMethod(SetWomaninfoFun,twinfo)	
	
				if (womanid=="")
  	   	 		{
	  	   			alert(t['UpdateWomanFailure'])
	  	   			return
  	   	 		}
				
		}
		
		//set tumour info
		var foundDate=document.getElementById("TumourDate").value
		var foundPos=document.getElementById("TumourPosition").value
   		if (foundDate!="" && foundPos!="" && foundDate!=DateDemo())
		{
			enmeth=document.getElementById("DateChange4to3").value;
			foundDate=cspRunServerMethod(enmeth,foundDate);
			
   			var position=document.getElementById("TumourPosition").value;
    		var size=document.getElementById("TumourSize").value;
    		var beTransfer=document.getElementById("Transfer").checked;
    		var zhuanyi=""
    		if (beTransfer==true) 
    		{
	    		zhuanyi="Y";
    		}
   			else if (beTransfer==false) 
    		{
	    		zhuanyi="N";
    		}
    		
    		var transferPos=document.getElementById("TransPos").value;
    		var radioCure=document.getElementById("RadioCure").checked;
    		var radioc=""
    		if (radioCure==true) 
    		{
	    		radioc="Y";
    		}
    		else if (radioCure==false) 
    		{
	    		radioc="N";
   			}
   			
    		var chemicalCure=document.getElementById("ChemicalCure").checked
    		var chemicalc=""
   		 	if (chemicalCure==true) 
    		{
	    		chemicalc="Y";
   			}
    		else if (chemicalCure==false) 
    		{
	    		chemicalc="N";
    		}
    		
    		var otherInfo=document.getElementById("memo").value
     
     		var UpdateTumourInfo=ttmrowid+"^"
     		UpdateTumourInfo+=foundDate+"^"+position+"^"+size+"^"+zhuanyi+"^"+transferPos+"^"+radioc+"^"+chemicalc+"^"+otherInfo
	        var UpdateTumour=document.getElementById("AddTumourInfo").value;
      		var tumourid=cspRunServerMethod(UpdateTumour,UpdateTumourInfo)
	        if (tumourid=="") //Such as return -901,-915 or other SQL error,which is initial with "-".
     		{
	     		alert(t['SendAppFailure']);
	     		return;
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
		 
		 var GetRsIDFun=document.getElementById("GetRSidByCode").value;
		 var vid=cspRunServerMethod(GetRsIDFun,trscode)
		 if(vid!="")
		 {
			 trsid=vid
			  
			 var SetStatusInfo=document.getElementById("UpdateRStatus").value;
   	     	 var rcode=cspRunServerMethod(SetStatusInfo,trsid,ttmrowid)
  	   	 	 if (rcode!="0")
  	   	 	 {
	  	   		alert['UpdateStatusFailure']
	  	   		return
  	   	 	 }
  	   	 	 
  	   	 	 //ChangRISStatus
			var docdr=document.getElementById("AppDocDR").value
			var ChangeStatusInfo=document.getElementById("ChangRISStatus").value;

			var rriscode=cspRunServerMethod(ChangeStatusInfo,orditemdr,docdr)
			if (rriscode!="0")
			{
				alert['UpdateStatusFailure']
				return
			}
		}		 
	 } 
 }
	
 function CancelAppkey(str)
 {  
	if (document.getElementById("CancelApp").disabled==true)
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
    /*var ClinicRecord=document.getElementById('ClinicRecord').value
	var OperationSee=document.getElementById('OperationSee').value
	var ClinicDiag=document.getElementById('ClinicDiag').value*/
    var CancelAppFun=document.getElementById("CancelAppFunction").value;
    var ret=cspRunServerMethod(CancelAppFun,TMrowid)
	if (ret.split("-")[0]=="") //Such as return -901,-915 or other SQL error,which is initial with "-".
    {
	   alert(t['CancelAppFailure'])
	}
    else
    {
	  // alert(t['CancelAppSuccess'])
	}

	
	//Clear()
	
	Refresh()
 }
 //2008-9-11  DLN 
 function Refresh()
 {
   
    var Eposide=document.getElementById("EpisodeID").value;
    var ComponentName=document.getElementById("ComponentName").value;  //"DHCRisApplicationBill"
    var TMrowid=document.getElementById("TMrowid").value;
    var OEorditemID=document.getElementById("OEorditemID").value;
    
    var ClinicRecord=document.getElementById("ClinicRecord").value;
    var OperationSee=document.getElementById("OperationSee").value;
    var ClinicDiag=document.getElementById("ClinicDiag").value;
    var memo=document.getElementById("memo").value;
    var RecLocDR=document.getElementById("RecLocDR").value
    
    var Refresh=document.getElementById("Refresh").value;
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+ComponentName;
    
    lnk+="&EpisodeID="+Eposide;
    lnk+="&OEorditemID="+OEorditemID;
    lnk+="&TMrowid="+TMrowid;
    lnk+="&ComponentName="+ComponentName;
    
    lnk+="&ClinicRecord="+ClinicRecord;
    
    lnk+="&OperationSee="+OperationSee;
    lnk+="&ClinicDiag="+ClinicDiag;
    lnk+="&memo="+memo;
    lnk+="&RecLocDR="+RecLocDR
    lnk+="&Refresh="+Refresh;
    //alert(lnk)
    location.href=lnk;
    
 }
 
 function Clear()
 {
 	var ComponentName=document.getElementById("ComponentName").value;  //"DHCRisApplicationBill"
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+ComponentName+"&EpisodeID="+""+"&OEorditemID="+""+"&TMrowid="+""+"&ComponentName="+ComponentName+"&Refresh="+"";
    location.href=lnk; 
 }
 
 function SelectRowHandler()	
 {
	var eSrc=window.event.srcElement
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z")
	var rowObj=getRow(eSrc)
	var selectrow=rowObj.rowIndex
	if (!selectrow) 
	{
		document.getElementById('SpeNum').value=""
		document.getElementById('SpePos').value=""
		document.getElementById('SpeMemo').value=""
		document.getElementById('SpeRowId').value=""
		
		if(bNewPatient==1)
		{
			document.getElementById("SpecimenAdd").disabled=false
			document.getElementById("SpecimenDel").disabled=true
			document.getElementById("SpecimenEdit").disabled=true
		}
		else
		{
			document.getElementById("SpecimenAdd").disabled=true
			document.getElementById("SpecimenDel").disabled=true
			document.getElementById("SpecimenEdit").disabled=true
		}
		
		return
	}
	
	SelectedRow = selectrow;
    var objtbl=document.getElementById('tDHCPIS_cgbl');

    var obj=document.getElementById('SpeNum');
	var obj1=document.getElementById('SpePos');
	var obj3=document.getElementById('SpeMemo');
	var obj5=document.getElementById('SpeRowId');
	var SelRowObj=document.getElementById('TSpeNumz'+selectrow);
	var SelRowObj1=document.getElementById('TSpePosz'+selectrow);
	var SelRowObj3=document.getElementById('TSpeMemoz'+selectrow);
	var SelRowObj5=document.getElementById('TSpeRowIdz'+selectrow);

	obj.value=SelRowObj.innerText;
	obj1.value=SelRowObj1.innerText;
	obj3.value=SelRowObj3.innerText;
	obj5.value=SelRowObj5.value;
	
	if(obj1.value!="" && bNewPatient==1)
	{
		document.getElementById("SpecimenAdd").disabled=true
		document.getElementById("SpecimenDel").disabled=false
		document.getElementById("SpecimenEdit").disabled=false
	}
	else
	{
		document.getElementById("SpecimenAdd").disabled=true
		document.getElementById("SpecimenDel").disabled=true
		document.getElementById("SpecimenEdit").disabled=true
	}

	SelectedRow = selectrow;
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

function PrintSheetkey()
{	if(bNewPatient)
	{
		alert(t['NPrint'])
		return	
	}
	Print()
}

function EndCatakey()
{
	var EndCataObj=document.getElementById("EndCata");
   	if(EndCataObj.oncheck)
   	{
		document.getElementById("LastCata").disabled = true;
		document.getElementById("LastCata").value="";
	}else
	{
		document.getElementById("LastCata").disabled = false;
		document.getElementById("LastCata").value="";	
	}
}

//自动生成标本序号
function AutoNumber()
{
	var GetSpecimensFunc=document.getElementById("autoNumAdd").value
	var info=cspRunServerMethod(GetSpecimensFunc,ttmrowid)
	var item=info.split(";")
	autoNumber=item.length
	document.getElementById("SpeNum").value = autoNumber
}

function Print()
{ 
//alert("1")
	 var xlApp,xlsheet,xlBook,Template
     var GetPrescPath=document.getElementById("GetRepPath");
	 if (GetPrescPath) {var encmeth=GetPrescPath.value} 
	 else {var encmeth=''};
	 if (encmeth!="") 
	 {
		var TemplatePath=cspRunServerMethod(encmeth);
	 }
      if(document.getElementById("Frost").checked==true)
         {Template=TemplatePath+"DHCPisAppSzbd.xls";}
      else
      {
	     Template=TemplatePath+"DHCPisAppCgbl.xls";
      }
	    //var Template="http://10.1.1.42/trakcare/trak/med/Results/Template/DHCPisAppCgbl.xls";
	    xlApp = new ActiveXObject("Excel.Application")
			xlBook = xlApp.Workbooks.Add(Template);
			xlsheet = xlBook.ActiveSheet;
      var duihao=String.fromCharCode(8730)        
      	
	    //号码
	    xlsheet.cells(2,1)="*"+document.getElementById("TMrowid").value+"*";  //条码申请单号
	    xlsheet.cells(3,4)=document.getElementById("TMrowid").value;          //申请单号
	    xlsheet.cells(3,10)=document.getElementById("RegisterNum").value;           //登记号
	    xlsheet.cells(3,17)=document.getElementById("OrderDr").value;     //医嘱号
	    
	    //基本信息                                                            
	    xlsheet.cells(5,3)=document.getElementById("PName").value;             //病人姓名
	    xlsheet.cells(5,10)=document.getElementById("PSex").value;             //病人性别
	    xlsheet.cells(5,15)=document.getElementById("PAge").value;             //病人年龄
	    var appdate=document.getElementById("PBirthday").value;
	    var item=appdate.split("/")
	    xlsheet.cells(5,21)=item[2]+"-"+item[1]+"-"+item[0];			//出生日期
	    //xlsheet.cells(5,23)=document.getElementById("PBirthday").value;              
	    xlsheet.cells(6,4)=document.getElementById("PTel").value;            //电话号码
	    xlsheet.cells(6,11)=document.getElementById("PType").value;         //就诊类型
	    xlsheet.cells(6,17)=document.getElementById("PChargeType").value;	        //费别
	    xlsheet.cells(7,4)=document.getElementById("PAddress").value;          //现住址
	    
	    //申请信息
	    xlsheet.cells(9,4)=document.getElementById("AppDep").value;           //申请科室
	    xlsheet.cells(9,14)=document.getElementById("AppDoc").value;          //申请医生
	    var appdate=document.getElementById("AppDate").value;
	    var item=appdate.split("/")
	    xlsheet.cells(9,21)=item[2]+"-"+item[1]+"-"+item[0];         //申请日期

        var GetSpecimensFunc=document.getElementById("autoNumAdd").value
	    var info=cspRunServerMethod(GetSpecimensFunc,ttmrowid)
	    xlsheet.cells(11,1)=info                                                //标本信息
	    xlsheet.cells(13,1)=document.getElementById("ClinicRecord").value;        //临床病历
	    xlsheet.cells(17,1)=document.getElementById("OperationSee").value;      //手术所见
	    xlsheet.cells(21,1)=document.getElementById("ClinicDiag").value;      //临床诊断
	    
	    //肿瘤信息
      xlsheet.cells(25,4)=document.getElementById("TumourPosition").value;   //肿瘤部位
      xlsheet.cells(25,12)=document.getElementById("TumourSize").value;   //肿瘤大小
      var tdate=document.getElementById("TumourDate").value;
      if(tdate!="")
      {
	  	var item=tdate.split("/")
      	xlsheet.cells(25,20)=item[2]+"-"+item[1]+"-"+item[0];   //发现日期
      }
      if(document.getElementById("Transfer").checked)   //有无转移)
          xlsheet.cells(26,4)=duihao
      xlsheet.cells(26,8)=document.getElementById("TransPos").value;   //转移部位
      if(document.getElementById("RadioCure").checked)   //曾否放疗
          xlsheet.cells(26,17)=duihao
      if(document.getElementById("ChemicalCure").checked)   //曾否化疗
          xlsheet.cells(26,22)=duihao
      xlsheet.cells(27,3)=document.getElementById("memo").value;             //备注
      
      //妇科信息
      	var tdate=document.getElementById("LastCata").value;
      if(tdate!="")
      {
	  	var item=tdate.split("/")
      	xlsheet.cells(29,4)=item[2]+"-"+item[1]+"-"+item[0];   //末次月经
      }
	    if(document.getElementById("EndCata").checked)   //是否绝经
	       xlsheet.cells(29,12)=duihao
	    xlsheet.cells(29,17)=document.getElementById("Tai").value;   //胎
	    xlsheet.cells(29,20)=document.getElementById("Chan").value;   //产
	    
	    xlsheet.PrintOut 
    	xlBook.Close (savechanges=false);
    	xlBook=null
    	xlApp.Quit();
    	xlApp=null;
    	xlsheet=null 
    	//window.setInterval("Cleanup();",1); 
}

function PrintBarAppkey()
{
	if(document.getElementById("PrintBarApp").disabled==true)
	     return
    PrintBar()
 }

function PrintBar() //print lab barcode
{
    var Bar,j;
    Bar= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
    Bar.PrintName="tiaoma";//printer name
    
    
	var RegisterNum=document.getElementById("RegisterNum").value
	var PName=document.getElementById("PName").value
	var RoomNo=document.getElementById("RoomNo").value
	var RoomNo=RoomNo.split("-")
	var RoomNo=RoomNo[1]
	var BedNo=document.getElementById("BedNo").value
	var AppDep=document.getElementById("AppDep").value
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
                   
                    Bar.LabNo=document.getElementById("TMrowid").value;
                    Bar.RecLoc="病理科";
                    //Bar.SpecName=item[0];
                    Bar.PatLoc=PatLoc;
                    //Bar.PatWard=RoomNo;
                    Bar.OrdName=OrderName+"--"+item[0];
                    Bar.PatName=PName;
                    Bar.Sex=document.getElementById("PSex").value;
                    Bar.Age=document.getElementById("PAge").value;
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
	 var OrderDr=document.getElementById("OrderDr").value
	var GetOEorditemFunc=document.getElementById("GetOEorditem").value
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
//alert(Template+"="+xlsheet.cells(1,1).value)
	        xlsheet.cells(3,5).value=document.getElementById("RegisterNum").value
	        xlsheet.cells(3,2).value=document.getElementById("PName").value
	      
	  	    xlsheet.cells(3,10).value=document.getElementById("PSex").value
	        xlsheet.cells(3,7).value=document.getElementById("PAge").value
	    	//xlsheet.cells(5,3).value=document.getElementById("RoomNo").value
	    	//xlsheet.cells(5,17).value=document.getElementById("BedNo").value
	    	//xlsheet.cells(6,5).value=document.getElementById("PTel").value
	    	//xlsheet.cells(6,13).value=document.getElementById("PAddress").value
	    	xlsheet.cells(4,8).value=document.getElementById("AppDoc").value
	    	xlsheet.cells(3,12).value=document.getElementById("AppDate").value
	    	xlsheet.cells(4,4).value=document.getElementById("AppDep").value
	    	xlsheet.cells(6,7).value=RecLoc.split("-")[1] //"病理科"
	    	xlsheet.cells(6,6).value=OrderPrice
	    	xlsheet.cells(6,1).value=OrderName
	    	
	    	for (j=0;j<tmpList.length-1;j++)
                {
	                //alert(tmpList[j]+","+labNo);continue;
	                var specinfo=tmpList[j]
				//alert(specinfo)
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
	 var ContentInfo=AppLocDR+"^"+DirRowId+"^"+code+"^"+Name+"^"+ClinicRecord+"^"+docdr+"^"+Type
	 var InsertContentFun=document.getElementById("InsertContent").value;
   	 var InsertContent=cspRunServerMethod(InsertContentFun,ContentInfo)  
   	 Refresh()	
	}
	else
	{
     if (ClinicRecord=="") return
	 var code=2,Name="ClinicRecord",Type=3
	 var ContentInfo=AppLocDR+"^"+DirRowId+"^"+code+"^"+Name+"^"+ClinicRecord+"^"+docdr+"^"+Type
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
	 var ContentInfo=AppLocDR+"^"+DirRowId+"^"+code+"^"+Name+"^"+ClinicRecord+"^"+docdr+"^"+Type
	 var InsertContentFun=document.getElementById("InsertContent").value;
   	 var InsertContent=cspRunServerMethod(InsertContentFun,ContentInfo) 
   	 Refresh()	
	}
	else
	{
     if (OperationSee=="") return
	 var code=3,Name="OperationSee",Type=3
	 var ContentInfo=AppLocDR+"^"+DirRowId+"^"+code+"^"+Name+"^"+OperationSee+"^"+docdr+"^"+Type
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

 function BtnSavekey(str)
 { 
    var TMrowid=document.getElementById("TMrowid").value;
    if (TMrowid=="")
    {
	   alert(t['NOTNULL']);
	   return;
    }
 
    SetPatInfo()
    SetAppInfo()
    SetWomanTumourInfo()
    //SetAppStatus()
    Refresh()
 }

document.body.onload = BodyLoadHandler;