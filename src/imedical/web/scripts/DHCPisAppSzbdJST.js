//DHCPisAppSzbdJST

var bNewPatient=1
var tstatuscode=0
var tspecimennum=0
var tspecimeninfo=""
var ttmrowid=""
var paadmdr=""
var orditemdr=""
var tclsdr=""
var tclscode="10"
var tclinicrecord=""
var autoNumber="1"//自动生成的标本序号

var tformName=document.getElementById("TFORM").value; 
var getComponentIdByName=document.getElementById("GetComponentIdByName").value; 
var componentId; 
componentId=cspRunServerMethod(getComponentIdByName,tformName); 


function BodyLoadHandler()
 {	
    /*var ordItemDr=document.getElementById("OEorditemID").value
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
   	if (ComName=="") ComName="DHCPisAppSzbdJST"
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
    
    var ODateObj=document.getElementById("OpeDate")
    if (ODateObj.value=="")
    	ODateObj.value=DateDemo()
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
   	
   	/*var PrintBarObj=document.getElementById("PrintBarApp")
   	{
	   	PrintBarObj.onclick=PrintBarAppkey
		}*/
   	
   	var SaveObj=document.getElementById("Save")
   	if(SaveObj)
   	{
	   	SaveObj.onclick=Savekey
		}
   	
   	var MorningObj=document.getElementById("bMorning")
   	if (MorningObj)
   	{
		MorningObj.onclick=MorningKey
   	}
   	
   	var AfternoonObj=document.getElementById("bAfternoon")
   	if (AfternoonObj)
   	{
		AfternoonObj.onclick=AfternoonKey
   	}
   	
   	var OperatorObj=document.getElementById("Operator")
   	if (OperatorObj)
   	{
			OperatorObj.onkeydown=OperatorKey;
   	}
   //-----------------all button action!End------------------
   	var GetClsdrFun=document.getElementById("ClassDr").value
 	var CLSDR=cspRunServerMethod(GetClsdrFun,tclscode)
    if (CLSDR!="")
	{	  
	  	tclsdr = CLSDR
    }
    
 	//get tmrowid
    var GetTmrowidFun=document.getElementById("GetTmRowId").value
  	var TMROWID=cspRunServerMethod(GetTmrowidFun,87,orditemdr)
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
		var TMROWID = cspRunServerMethod(TestmasterAddFun,87,tclsdr)
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
       //Refresh()
   	}
	
	if(tstatuscode==1)
	{
		document.getElementById("SendApp").disabled=true
		
		document.getElementById("SpecimenAdd").disabled=true
		document.getElementById("SpecimenDel").disabled=true
	}
	else if(tstatuscode==2)
	{
		document.getElementById("SendApp").disabled=true

		document.getElementById("CancelApp").disabled=true
		
		document.getElementById("SpecimenAdd").disabled=true
		document.getElementById("SpecimenDel").disabled=true
	}
	else
	{
		document.getElementById("CancelApp").disabled=true
		document.getElementById("PrintApp").disabled=true
		//document.getElementById("PrintBarApp").disabled=true
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
			
			document.getElementById("AppDep").value=item[7]
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
		// get patient main diagonse 
		var GetMainDiagoseFunction=document.getElementById("MainDiagInfo").value
  		var value=cspRunServerMethod(GetMainDiagoseFunction,paadmdr)
    	document.getElementById("ClinicDiag").value=value
    	
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
		
			document.getElementById("AppDoc").value=item[4]
			document.getElementById("AppDocDR").value=item[5]
		}
		
		document.getElementById("bMorning").checked=true
		document.getElementById("bAfternoon").checked=false
		
		var GetAppInfoFun=document.getElementById("GetAppInfo").value
  		var APPINFO=cspRunServerMethod(GetAppInfoFun,ttmrowid)
    	if (APPINFO!="")
		{   
			var item=APPINFO.split("^")
			
			var vdate3=item[8]
			var ChangDFun=document.getElementById("DateChange3to4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("AppDate").value=vdate4
		
			//document.getElementById("ClinicDiag").value=item[5]
			document.getElementById("OperationSee").value=item[2]
			
			tclinicrecord=item[1]
			if(item[1]!="")
				SetClinicRecord()
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
			document.getElementById("OperationSee").value=item[2]
			
			tclinicrecord=item[1]
			if(item[1]!="")
				SetClinicRecord()
			else
			{
				document.getElementById("bMorning").checked=true
				document.getElementById("bAfternoon").checked=false
			}
		}
	}
	
	if(bNewPatient==1)
    {
		 document.getElementById("OperationSee").disabled=false
		 document.getElementById("CRImageInfo").disabled=false
	 	 document.getElementById("HuayanInfo").disabled=false
		 document.getElementById("OtherPathInfo").disabled=false
		 document.getElementById("YongyaoInfo").disabled=false
		 
		 document.getElementById("OpeName").disabled=false
		 document.getElementById("Operator").disabled=false
		 
		 document.getElementById("OpeDate").disabled=false
		 document.getElementById("bMorning").disabled=false
	 	 document.getElementById("bAfternoon").disabled=false
		 document.getElementById("opeHoure").disabled=false
		 document.getElementById("opeMiniute").disabled=false
	 
		 document.getElementById("songHour").disabled=false
		 document.getElementById("songMiniute").disabled=false
    }
    else
    {
		 document.getElementById("OperationSee").disabled=true
		 document.getElementById("CRImageInfo").disabled=true
	 	 document.getElementById("HuayanInfo").disabled=true
		 document.getElementById("OtherPathInfo").disabled=true
		 document.getElementById("YongyaoInfo").disabled=true
		 
		 document.getElementById("OpeName").disabled=true
		 document.getElementById("Operator").disabled=true
		 
		 document.getElementById("OpeDate").disabled=true
		 document.getElementById("bMorning").disabled=true
	 	 document.getElementById("bAfternoon").disabled=true
		 document.getElementById("opeHoure").disabled=true
		 document.getElementById("opeMiniute").disabled=true
	 
		 document.getElementById("songHour").disabled=true
		 document.getElementById("songMiniute").disabled=true
		 
		 DisableById(componentId,"Operator")
		 DisableById(componentId,"SpeFangshi")
		 DisableById(componentId,"OpeDate")
    }
 }
 
 function SetClinicRecord()
 {
	var item=tclinicrecord.split("~")

	var tshoushu=item[0]
	var timage=item[1]
	var thuayan=item[2]
	var tpathinfo=item[3]
	var tyongyao=item[4]
	var topedate=item[5]
	
	var item=tshoushu.split(";")
	var subitem=item[0].split(":")
	document.getElementById("OpeName").value=subitem[1]
	var subitem=item[1].split(":")
	document.getElementById("Operator").value=subitem[1]
	
	var subitem=timage.split(":")
	document.getElementById("CRImageInfo").value=subitem[1]
	
	var subitem=thuayan.split(":")
	document.getElementById("HuayanInfo").value=subitem[1]
	
	var subitem=tpathinfo.split(":")
	document.getElementById("OtherPathInfo").value=subitem[1]
	
	var subitem=tyongyao.split(":")
	document.getElementById("YongyaoInfo").value=subitem[1]
	
	var titem=topedate.split(";")
	var subitem=titem[0].split(":")
	var ChangDFun=document.getElementById("DateChange3to4").value
	var odate=cspRunServerMethod(ChangDFun,subitem[1])
	document.getElementById("OpeDate").value=odate
	
	
	var subitem=titem[1].split(":")
	if(subitem[1]==t['MORNING'])
		document.getElementById("bMorning").checked=true
	else
		document.getElementById("bAfternoon").checked=true
		

	document.getElementById("opeHoure").value=titem[2]
	document.getElementById("opeMiniute").value=titem[3]
	
	var subitem=titem[4].split(":")
	document.getElementById("songHour").value=subitem[1]
	document.getElementById("songMiniute").value=titem[5]
 }
 
 function GetWomanTumourInfo()
 {
	  var GetTumourInfo=document.getElementById("GetTumourInfo")
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
		 document.getElementById("TransPos").disabled=false
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
		 
		 DisableById(componentId,"TumourDate")
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
		    	
		    	if (item[1]=="Y") var endCata=1
		    	else var endCata=0
		    	document.getElementById("EndCata").checked=endCata
		    	document.getElementById("Tai").value=item[2]
		    	document.getElementById("Chan").value=item[3]
	     	}
      	}
      	
	  }
	  
	  if(bNewPatient==1 && tsexdes==t['SEXNV'])
      {
	     document.getElementById("LastCata").disabled=false
	 	 document.getElementById("EndCata").disabled=false
		 document.getElementById("Tai").disabled=false
		 document.getElementById("Chan").disabled=false
      }
      else
      {
	     document.getElementById("LastCata").disabled=true
	     
	     document.getElementById("LastCata").value=""
	 	 document.getElementById("EndCata").disabled=true
		 document.getElementById("Tai").disabled=true
		 document.getElementById("Chan").disabled=true
		 
		 DisableById(componentId,"LastCata")
      }
 }
 
 function SpeAddkey(str)
 { 
 	if(document.getElementById("SpecimenAdd").disabled==true)
 		return
 
	var SpeNum=document.getElementById("SpeNum").value
    var SpePos=document.getElementById("SpePos").value
    var SpeMemo=document.getElementById("SpeFangshi").value
    var TMrowid=document.getElementById("TMrowid").value
    if ((SpeNum=="")||(SpePos=="")||(TMrowid==""))
    {
	   alert(t['NOTNULL']);
	   return;
    }
    var SpeAddFun=document.getElementById("SpeAddFunction").value
    var ret=cspRunServerMethod(SpeAddFun,TMrowid+"^"+SpeNum+"^"+SpePos+"^"+SpeMemo+"^"+"^"+"^")
	if (ret=="-916")
    {
	   alert(t['SpeAddWrongNo'])
	}
    else if (ret.split("-")[0]=="") //Such as return -901,-915 or other SQL error,which is initial with "-".
    {
	   alert(t['SpeAddFailure'])
	}
    else
    {
	   //alert(t['SpeAddSuccess'])
	}
	AutoNumber()
	Refresh()
 }
 
 function SpeDelkey(str)
 {  
 	if(document.getElementById("SpecimenDel").disabled==true)
 		return
 		
	selectrow=SelectedRow		
    var SpeRowId=document.getElementById("SpeRowId").value
    if (SpeRowId=="")
    {
	   alert(t['NOTNULL'])
	   return
    }
    var SpeDelFun=document.getElementById("SpeDelFunction").value
    var ret=cspRunServerMethod(SpeDelFun,SpeRowId)
    if (ret.split("-")[0]=="") //Such as return -901,-915 or other SQL error,which is initial with "-".
    {
	   alert(t['SpeDelFailure'])
	}
    else
    {
	   //alert(t['SpeDelSuccess'])
	}
	
	Refresh()
		
	document.getElementById("SpecimenDel").disabled=true
	document.getElementById("SpecimenEdit").disabled=true
	document.getElementById("SpecimenAdd").disabled=false
 }
 
 function SpeEditkey(str)
 { 
 	if(document.getElementById("SpecimenEdit").disabled==true)
 		return
 		
	selectrow=SelectedRow
	var SpeNum=document.getElementById("SpeNum").value
    var SpePos=document.getElementById("SpePos").value
    var SpeMemo=document.getElementById("SpeFangshi").value
    var SpeRowId=document.getElementById("SpeRowId").value
    if ((SpeNum=="")||(SpePos==""))
    {
	   alert(t['NOTNULL'])
	   return;
    }
    if (SpeRowId=="")
    {
	   alert(t['CHOOSELINE'])
	   return;
    }
    var SpeEditFun=document.getElementById("SpeEditFunction").value
    var ret=cspRunServerMethod(SpeEditFun,SpeNum+"^"+SpePos+"^"+SpeMemo+"^"+"^"+"^",SpeRowId)
    if (ret.split("-")[0]=="") //Such as return -901,-915 or other SQL error,which is initial with "-".
    {
	   alert(t['SpeEditFailure'])
	}
    else
    {
	  // alert(t['SpeEditSuccess'])
	}
	
	Refresh()
	document.getElementById("SpecimenDel").disabled=true
	document.getElementById("SpecimenEdit").disabled=true
	document.getElementById("SpecimenAdd").disabled=false
 }
 
 function SendAppkey(str)
 { 
 	if(document.getElementById("SendApp").disabled==true)
 		return
 		
 	//validate specimens
 	var Objtbl=document.getElementById('tDHCPisAppSzbdJST')
	var Rows=Objtbl.rows.length-1
	if(Rows<1)
	{
		alert(t['NOSPECIMEN'])
		return
	}
 	
    if (ttmrowid=="")
    {
	   alert(t['NOTNULL'])
	   return
    }
    
	var operation=document.getElementById("OpeName").value
	var operator=document.getElementById("Operator").value
	if(operation="" || operator=="")
	{
		alert(t['OPERATORNOTNULL'])
		return
	}
	
    /*
    var operResult=document.getElementById("OperationSee").value
    if (operResult=="")
    {
	   alert(t['opeResultNOTNULL'])
	   return
    }
    */
    
    var todate=document.getElementById("OpeDate").value
    if(todate=="")
    {
	    alert(t['OpeDatenull'])
	    return
	    }
	    
    SetPatInfo()
    SetAppInfo()
    SetWomanTumourInfo()
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
 
 function GetClinicRecord()
 {
	tclinicrecord=""
	
	var tshoushu=t['OPERATIONNAME']+document.getElementById("OpeName").value+";"+t['OPERATOR']+document.getElementById("Operator").value
	var timage=t['IMAGEINFO']+document.getElementById("CRImageInfo").value
	var thuayan=t['HUAYANINFO']+document.getElementById("HuayanInfo").value
	var tpathinfo=t['OTHERPATHINFO']+document.getElementById("OtherPathInfo").value
	var tyongyao=t['YONGYAOINFO']+document.getElementById("YongyaoInfo").value
	
	var topeinfo="";
	
	var todate=document.getElementById('OpeDate').value
	var ChangDFun=document.getElementById("DateChange4to3").value
	var nodate=cspRunServerMethod(ChangDFun,todate)
	topeinfo=t['OPERATIONDATE']+nodate+";"

	var tmorafter=""
	if(document.getElementById("bMorning").checked)
		tmorafter=t['MORNING']
	else
		tmorafter=t['AFTERNOON']
	
	topeinfo+=t['OPESTARTTIME']+tmorafter+";"
	
	topeinfo+=document.getElementById("opeHoure").value+";"
	topeinfo+=document.getElementById("opeMiniute").value+";"
	topeinfo+=t['SONGJIANDATE']+document.getElementById("songHour").value+";"
	topeinfo+=document.getElementById("songMiniute").value+";"
	
	tclinicrecord=tshoushu+"~"+timage+"~"+thuayan+"~"+tpathinfo+"~"+tyongyao+"~"+topeinfo
 }
 
 function SetAppInfo()
 {
	 if(bNewPatient==1)
	 {
		 var appinfo=""
		 var tbingdong=""
		 
		 GetClinicRecord()
		 
		 var tbingdong="1"
		 
		 appinfo+=tclinicrecord+"^"
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
 
 function SetWomanTumourInfo()
 {
	 if(bNewPatient==1)
	 {
		var tsexdes=document.getElementById("PSex").value
		if(tsexdes==t['SEXNV'])
		{
			var jjdate=document.getElementById("LastCata").value
			if(jjdate!="" && jjdate!=DateDemo())
			{
				var twinfo=""
		
				twinfo+=ttmrowid+"^"
			
				var DateChangeFun=document.getElementById("DateChange4to3").value
				var tdate=cspRunServerMethod(DateChangeFun,jjdate)
				twinfo+=tdate+"^"
			
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
				twinfo+=tjj+"^"
			
				var ttai=document.getElementById("Tai").value
				var tchan=document.getElementById("Chan").value
			
				twinfo+=ttai+"^"+tchan+"^"
			
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
    var Eposide=document.getElementById("EpisodeID").value
    var ComponentName=document.getElementById("ComponentName").value 
    var TMrowid=document.getElementById("TMrowid").value
    var OEorditemID=document.getElementById("OEorditemID").value
    var Refresh=document.getElementById("Refresh").value
    var OpeName=document.getElementById("OpeName").value
    var YongyaoInfo=document.getElementById("YongyaoInfo").value
    var OtherPathInfo=document.getElementById("OtherPathInfo").value
    var HuayanInfo=document.getElementById("HuayanInfo").value
    var CRImageInfo=document.getElementById("CRImageInfo").value
    var OperationSee=document.getElementById("OperationSee").value
    var TumourSize=document.getElementById("TumourSize").value
    var TumourPosition=document.getElementById("TumourPosition").value
    var memo=document.getElementById("memo").value
    var TransPos=document.getElementById("TransPos").value
    var lnk="";
    lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+ComponentName;
    lnk+="&EpisodeID="+Eposide;
    lnk+="&OEorditemID="+OEorditemID;
    lnk+="&TMrowid="+TMrowid;
    lnk+="&ComponentName="+ComponentName;
    lnk+="&Refresh="+Refresh;
    lnk+="&OpeName="+OpeName;
    lnk+="&YongyaoInfo="+YongyaoInfo;
    lnk+="&OtherPathInfo="+OtherPathInfo;
    lnk+="&HuayanInfo="+HuayanInfo;
    lnk+="&CRImageInfo="+CRImageInfo;
    lnk+="&OperationSee="+OperationSee;
    lnk+="&TumourSize="+TumourSize;
    lnk+="&TumourPosition="+TumourPosition;
    lnk+="&memo="+memo;
    lnk+="&TransPos="+TransPos;
    location.href=lnk
 }
 
 function Clear()
 {
 	var ComponentName=document.getElementById("ComponentName").value  //"DHCRisApplicationBill"
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+ComponentName+"&EpisodeID="+""+"&OEorditemID="+""+"&TMrowid="+""+"&ComponentName="+ComponentName+"&Refresh="+""
    location.href=lnk
 }
 
 function SelectRowHandler()	
 {
	if(bNewPatient==1)
	{
		var eSrc=window.event.srcElement
		if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement
		var eSrcAry=eSrc.id.split("z")
		var rowObj=getRow(eSrc)
		var selectrow=rowObj.rowIndex
		if (!selectrow) 
		{
			document.getElementById('SpeNum').value=""
			document.getElementById('SpePos').value=""
			document.getElementById('SpeFangshi').value=""
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
		
		SelectedRow = selectrow
	    var objtbl=document.getElementById('tDHCPisAppCgblJST')
	
	    var obj=document.getElementById('SpeNum')
		var obj1=document.getElementById('SpePos')
		var obj3=document.getElementById('SpeFangshi')
		var obj5=document.getElementById('SpeRowId')
		var SelRowObj=document.getElementById('TSpeNumz'+selectrow)
		var SelRowObj1=document.getElementById('TSpePosz'+selectrow)
		var SelRowObj3=document.getElementById('TSpeMemoz'+selectrow)
		var SelRowObj5=document.getElementById('TSpeRowIdz'+selectrow)
	
		obj.value=SelRowObj.innerText
		obj1.value=SelRowObj1.innerText
		obj3.value=SelRowObj3.innerText
		obj5.value=SelRowObj5.value
		
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
	
		SelectedRow = selectrow
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
	if(document.getElementById("PrintApp").disabled==true)
 		return
 		
	Print()
}

function PrintBarAppkey()
{
	if(document.getElementById("PrintBarApp").disabled==true)
	     return
    PrintBar()
 }

function MorningKey()
{
	var MorningObj=document.getElementById("bMorning")
	if (MorningObj.checked)
	{
	  //document.getElementById("bMorning").checked = false;
	  document.getElementById("bAfternoon").checked=false;
	}
}

function AfternoonKey()
{
	var AfternoonObj=document.getElementById("bAfternoon")
	if (AfternoonObj.checked)
	{
	  document.getElementById("bMorning").checked = false;
	  //document.getElementById("bAfternoon").checked=false;
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
	var xlApp,xlsheet,xlBook
  var GetPrescPath=document.getElementById("GetRepPath");
	if (GetPrescPath) {var encmeth=GetPrescPath.value} 
	else {var encmeth=''};
	if (encmeth!="") 
	   {
			var TemplatePath=cspRunServerMethod(encmeth);
		}
	var Template="http://10.10.142.3/Dthealth/trak/med/Results/Template/"+"DHCPISSzbd.xls";
	xlApp = new ActiveXObject("Excel.Application")
	xlBook = xlApp.Workbooks.Add(Template);
 	xlsheet = xlBook.ActiveSheet;
 	      xlsheet.cells(2,2).value="*"+document.getElementById("TMRowid").value+"*"
	      xlsheet.cells(3,5).value=document.getElementById("TMRowid").value
	      xlsheet.cells(3,10).value=document.getElementById("RegisterNum").value
	      xlsheet.cells(3,15).value=document.getElementById("OrderDr").value
	      xlsheet.cells(3,24).value=document.getElementById("InpoNo").value
	      
	      xlsheet.cells(5,4).value=document.getElementById("PName").value
	      xlsheet.cells(5,9).value=document.getElementById("PSex").value
	  	  xlsheet.cells(5,13).value=document.getElementById("PAge").value
	      xlsheet.cells(5,18).value=document.getElementById("PBirthday").value
	    	xlsheet.cells(5,24).value=document.getElementById("PTel").value
	    	xlsheet.cells(6,4).value=document.getElementById("PType").value
	    	xlsheet.cells(6,9).value=document.getElementById("PChargeType").value
	    	xlsheet.cells(6,16).value=document.getElementById("PAddress").value
	    	
	    	xlsheet.cells(8,5).value=document.getElementById("AppDoc").value
	    	xlsheet.cells(8,11).value=document.getElementById("AppDate").value
	    	xlsheet.cells(8,17).value=document.getElementById("AppDep").value

				var GetSpecimensFunc=document.getElementById("autoNumAdd").value
				var info=cspRunServerMethod(GetSpecimensFunc,ttmrowid)
	  		xlsheet.cells(10,2).value=info
	    	xlsheet.cells(11,5).value=document.getElementById("OpeName").value
	    	xlsheet.cells(11,25).value=document.getElementById("Operator").value
	    	xlsheet.cells(12,5).value=document.getElementById("OpeDate").value
	    	var item=""
	    	if(document.getElementById("bMorning").checked==true)
	    	{
	    		var item="上午 "+document.getElementById("opeHoure").value+":"+document.getElementById("opeMiniute").value;
	    	}
	    	if(document.getElementById("bAfternoon").checked==true)
	    	{
	    		var item="下午 "+document.getElementById("opeHoure").value+":"+document.getElementById("opeMiniute").value;
	    	}
	    	xlsheet.cells(12,12).value=item
			
			xlsheet.cells(12,20).value=document.getElementById("songHour").value+":"+document.getElementById("songMiniute").value;
				
			xlsheet.cells(14,5).value=document.getElementById("TumourDate").value
	    	xlsheet.cells(14,11).value=document.getElementById("TumourPosition").value
	  	  xlsheet.cells(14,17).value=document.getElementById("TumourSize").value
	      xlsheet.cells(14,22).value=document.getElementById("memo").value
	      if(document.getElementById("Transfer").checked==true)
	      {
	      	var Transfer="是"
	      }else
	      {
	      	var Transfer=""
	      }
	    	xlsheet.cells(15,4).value=Transfer
	    	xlsheet.cells(15,8).value=document.getElementById("TransPos").value
	    	if(document.getElementById("RadioCure").checked==true)
	      {
	      	var RadioCure="是"
	      }else
	      {
	      	var RadioCure=""
	      }
	    	xlsheet.cells(15,14).value=RadioCure;
	    	if(document.getElementById("ChemicalCure").checked==true)
	      {
	      	var ChemicalCure="是"
	      }else
	      {
	      	var ChemicalCure=""
	      }
	    	xlsheet.cells(15,18).value=ChemicalCure;
	    	
	    	xlsheet.cells(17,5).value=document.getElementById("LastCata").value
	    	if(document.getElementById("EndCata").checked==true)
	      {
	      	var EndCata="是"
	      }else
	      {
	      	var EndCata=""
	      }
	    	xlsheet.cells(17,10).value=EndCata
	    	xlsheet.cells(17,13).value=document.getElementById("Tai").value
	    	xlsheet.cells(17,15).value=document.getElementById("Chan").value
	    	
	    	xlsheet.cells(20,1).value=document.getElementById("OperationSee").value
	    	xlsheet.cells(22,1).value=document.getElementById("ClinicDiag").value
	    	xlsheet.cells(24,1).value=document.getElementById("CRImageInfo").value
	    	xlsheet.cells(26,1).value=document.getElementById("HuayanInfo").value
	    	xlsheet.cells(28,1).value=document.getElementById("OtherPathInfo").value
	    	xlsheet.cells(30,1).value=document.getElementById("YongyaoInfo").value
	    	
	    	xlsheet.PrintOut 
	    	xlBook.Close (savechanges=false); 
	    	xlBook=null			
	    	xlApp.Quit();
	    	xlApp=null;
	    	xlsheet=null 
	    	window.setInterval("Cleanup();",1);
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
	var OrderDr=document.getElementById("OrderDr").value
	var GetOrderNameFunc=document.getElementById("GetOrderName").value
	var OrderName=cspRunServerMethod(GetOrderNameFunc,OrderDr)
	
    for (j=0;j<tmpList.length-1;j++)
                {
	                //alert(tmpList[j]+","+labNo);continue;
	                var specinfo=tmpList[j]
	                var item=specinfo.split("(")
                   
                    Bar.SpecNo=document.getElementById("TMRowid").value;
                    Bar.RecLoc=t['RecLoc'];
                    //Bar.SpecName=item[0];
                    Bar.PatLoc=PatLoc;
                    Bar.PatWard=RoomNo;
                    Bar.OrdName=OrderName+" "+item[0];
                    Bar.PatName=RegisterNum+" "+PName;
                    Bar.Sex=document.getElementById("PSex").value;
                    Bar.Age=document.getElementById("PAge").value;
                    Bar.BedCode=BedNo;
                    Bar.PrintOut();
                }
}

function OperatorKey()
{
	var OperatorObj=document.getElementById("Operator")
	if(OperatorObj&&(OperatorObj.value!="")&&(event.keyCode==13))
	{
		var Operator=document.getElementById("Operator").value
		var GetOperatorFunc=document.getElementById("GetOperator").value
		var Operator=cspRunServerMethod(GetOperatorFunc,Operator)
		document.getElementById("Operator").value=Operator;
	}
}

function Savekey()
{
	if(document.getElementById("Save").disabled==true)
	{
		return false;
	}

    if (ttmrowid=="")
    {
	   alert(t['NOTNULL'])
	   return
    }
      
    SetPatInfo()
    SetAppInfo()
    SetWomanTumourInfo()
    //SetAppStatus()   
    Refresh()
}

document.body.onload = BodyLoadHandler