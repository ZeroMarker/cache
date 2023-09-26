//DHCPisAppQjblZLYY.js

var bNewPatient = 1
var tstatuscode=0
var tspecimennum=0
var tspecimeninfo=""
var ttmrowid=""
var paadmdr=""
var orditemdr=""
var tclsdr=""
var tclscode="10"
var tclinicrecord=""
var ChuanRanBingShi=""
var autoNumber=1
var strOrderName=""
var recLocDr=""
var feibieDr=""
var duihao=String.fromCharCode(8730)
var code1=String.fromCharCode(12300)   //"「"
var code2=String.fromCharCode(12301)   //"」"
var code3=String.fromCharCode(65089)   //"??
var code4=String.fromCharCode(65090)   //"??

var appitmcode=""
var inivalue=""
var arcitemdr1=""
var cgnum=""
var arcitemdr2=""
var bdnum=""
var arcimid=""
var bdflag=""
var arcitemdr3=""
var SQDZPrice=""

var tformName=document.getElementById("TFORM").value; 
var getComponentIdByName=document.getElementById("GetComponentIdByName").value; 
var componentId; 
componentId=cspRunServerMethod(getComponentIdByName,tformName);

function BodyLoadHandler()
 {	
    document.getElementById("FHOHistory").style.display = "none"
	 	document.getElementById("GuoMinYaoWu").style.display = "none"
    orditemdr=document.getElementById("OEorditemID").value
    paadmdr=document.getElementById("EpisodeID").value
    if(orditemdr=="" || paadmdr=="")
    {
	    return
    }  
       
   	var GetOrdInfoFun=document.getElementById("OrderInfo").value
  	var ORDERINFO=cspRunServerMethod(GetOrdInfoFun,orditemdr)
    if (ORDERINFO!="")
		{   
				var item=ORDERINFO.split("^")
				//arcimid,strOrderName,strDate,strTime,requestdoc,ssusrdr, 6
				//strAccessionNum,SGroupDesc,subCatDesc,CatDesc,ifbed,price 12
				//Num,TotalPrice,billed,$g(ItemStatusCode),$g(ServerMaterial) 17
				//RecLocdr,$g(ResultFlag),strCommon,RecLocDesc,strOrderCode(24) 
        strOrderName=item[1]
        if (strOrderName=='骨髓穿刺活检病理诊断')
        {
          document.getElementById("Frost").disabled=true;
        }
				recLocDr=item[17]
				appitmcode=item[23]	
        //alert(appitmcode)
				var GetBillInfoFun=document.getElementById("BillInfo").value
  				var BILLINFO=cspRunServerMethod(GetBillInfoFun,recLocDr,appitmcode)
    			if (BILLINFO!="")
    			{
	    			//locdr_"^"_tcode_"^"_tname_"^"_tvalue_"^"_tbak_"^"_RowId
	    			var item=BILLINFO.split("^")
	    			inivalue=item[3];
	    			if(inivalue!="")
	    			{
		    			var item=inivalue.split(";")
		    			bdflag=item[0];
		    			arcitemdr1=item[1];
		    			arcitemdr2=item[2];	
		    			if (appitmcode=="DBLK000003")
		    			{
		    			   arcitemdr3=item[3];
		    			}
	    			}
	    			var GetarcimidFun=document.getElementById("GetArcimID").value
  		            var arcimidinfo=cspRunServerMethod(GetarcimidFun,arcitemdr1)
  		            if (arcimidinfo!="")
	                 {	  
	  	                arcimid = arcimidinfo
                     }
                    	
	    			if(bdflag=="0")
	    			{
		    			 document.getElementById("Frost").disabled=true;
		    			}		
    			}
					
		}
   	
   	var AppDateObj=document.getElementById("SendDate")
    if (AppDateObj.value=="")
    	AppDateObj.value=DateDemo()
    //document.getElementById("Frost").disabled=true
   /*   	
    var WDateObj=document.getElementById("LastDate")
    if (WDateObj.value=="")
    	WDateObj.value=DateDemo()
    */
         //20081205 dln
     //通过判断关联的文本框是否为空来设定该复选框是否被选中
   	if(isNull("TransPos")==false)
	{
		document.getElementById("Transfer").checked=true		
	}else
	{
		document.getElementById("Transfer").checked=false
	}
 
   if(isNull("ChuanRanBingShi")==false)
	{
		document.getElementById("othercrbs").checked=true		
	}else
	{
		document.getElementById("othercrbs").checked=false
	}
  
    /*
    var TDateObj=document.getElementById("TumourDate")
    if (TDateObj.value=="")
    	TDateObj.value=DateDemo()
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
   
    var PirntTMKeyObj=document.getElementById("PirntTM")
   	if (PirntTMKeyObj)
   	{
		PirntTMKeyObj.onclick=PirntTMKey
   	}
   
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
   	
   	var TumourDateObj=document.getElementById("TumourDate")
   	if (TumourDateObj)
   	{
		TumourDateObj.onblur=TumourDateblur
   	}
   	
   	var LastDateObj=document.getElementById("LastDate")
   	if (LastDateObj)
   	{
		LastDateObj.onblur=LastDateblur
   	}
  /*  
    var QiTaObj=document.getElementById("othercrbs");
   	if(QiTaObj)
   	{
		  QiTaObj.onclick=QiTaKey; 	
	}
   */	
   	var TransferObj=document.getElementById("Transfer")
   	if(TransferObj)
   	{
		  TransferObj.onclick=TransferKey 	
	}
	
	var EndDateObj=document.getElementById("EndDate")
   	if(EndDateObj)
   	{
		  EndDateObj.onclick=EndDateKey 	
	}
  
  var Zu=document.getElementById("Zu")
   	if (Zu)
   	{
		Zu.onclick=ZuKey
   	}
   
   	var Kuai=document.getElementById("Kuai")
   	if (Kuai)
   	{
		Kuai.onclick=KuaiKey
   	}
   
   	var Tiao=document.getElementById("Tiao")
   	if (Tiao)
   	{
		Tiao.onclick=TiaoKey
   	}
   
    var Dui=document.getElementById("Dui")
   	if (Dui)
   	{
		Dui.onclick=DuiKey
   	} 
   	
   	var Dian=document.getElementById("Dian")
   	if (Dian)
   	{
		Dian.onclick=DianKey
   	}
   	
   	var SPEMEMO=document.getElementById("SPEMEMO")
   	if(SPEMEMO)
   	{
   		SPEMEMO.onblur=SPEMEMOKey
   	}	
   	
    var HBsAg=document.getElementById("HBsAg")
   	if (HBsAg)
   	{
		HBsAg.onclick=HBsAgKey
   	}
    
    var HCV=document.getElementById("HCV")
   	if (HCV)
   	{
		HCV.onclick=HCVKey
   	}
    
    var HIV=document.getElementById("HIV")
   	if (HIV)
   	{
		HIV.onclick=HIVKey
   	}
    
    var othercrbs=document.getElementById("othercrbs")
   	if (othercrbs)
   	{
		othercrbs.onclick=othercrbsKey
   	}
    
    var wucrbs=document.getElementById("wucrbs")
   	if (wucrbs)
   	{
		wucrbs.onclick=wucrbsKey
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
		if(RECODE!="0")
		{
			alert(t['UpdateAppFailure'])
			return
		}
	}
if ((appitmcode=="DBLK000032")&&(bNewPatient=="1"))
    {
	    var VSpeNumjiag="1"
	    var VSpePosjiag="宫颈锥切标本"
	    var VSpeMemojiag="12"
	    var danweijiag="点"
	    var SpeAddFunjiag=document.getElementById("SpeAddFunction").value
        var retjiag=cspRunServerMethod(SpeAddFunjiag,ttmrowid+"^"+VSpeNumjiag+"^"+VSpePosjiag+"^"+VSpeMemojiag+"~"+danweijiag+"^"+"^"+"^")
      } 
	  if ((appitmcode=="DBLK000034")&&(bNewPatient=="1"))
    {
	    var VSpeNumjiaq="1"
	    var VSpePosjiaq="前列腺穿刺标本"
	    var VSpeMemojiaq="11"                                                                              
	    var danweijiaq="点"
	    var SpeAddFunjiaq=document.getElementById("SpeAddFunction").value
        var retjiaq=cspRunServerMethod(SpeAddFunjiaq,ttmrowid+"^"+VSpeNumjiaq+"^"+VSpePosjiaq+"^"+VSpeMemojiaq+"~"+danweijiaq+"^"+"^"+"^")
      }	
      
	var freshFlag=document.getElementById("Refresh").value
   	if (freshFlag=="")
   	{
	   freshFlag=1
	   document.getElementById("Refresh").value=freshFlag
       Refresh()
   	}
	if(tstatuscode==1) //已发送
	{   
		document.getElementById("SendApp").disabled=true
		document.getElementById("SaveApp").disabled=true
    //document.getElementById("CancelApp").disabled=false     
		//document.getElementById("SpecimenAdd").disabled=true
		 document.getElementById("ClinicDiag").disabled=true
     document.getElementById("HBsAg").disabled=true
     document.getElementById("HCV").disabled=true
     document.getElementById("HIV").disabled=true
     document.getElementById("othercrbs").disabled=true
     document.getElementById("wucrbs").disabled=true
     document.getElementById("ChuanRanBingShi").disabled=true
     
    	
		document.getElementById("SpecimenAdd").style.visibility="hidden" //Update by lff 2008-12-19
		document.getElementById("SpecimenDel").style.visibility="hidden"
	    document.getElementById("SpecimenEdit").style.visibility="hidden"
	    document.getElementById("SpeNum").style.visibility="hidden"
	    document.getElementById("SpePos").style.visibility="hidden"
	    document.getElementById("SPEMEMO").style.visibility="hidden"

	    /*
	    if (isNull("TumourDate")==true)
	    {
	    document.all("TumourDate").style.display = "none"
	    }
	    */
	}
	else if(tstatuscode==2) //已登记
	{
		document.getElementById("SendApp").disabled=true
        document.getElementById("SaveApp").disabled=true
		document.getElementById("CancelApp").disabled=true
	
		document.getElementById("SpecimenAdd").style.visibility="hidden" //Update by lff 2008-12-19
		document.getElementById("SpecimenDel").style.visibility="hidden"
	    document.getElementById("SpecimenEdit").style.visibility="hidden"
	    document.getElementById("SpeNum").style.visibility="hidden"
	    document.getElementById("SpePos").style.visibility="hidden"
	    document.getElementById("SPEMEMO").style.visibility="hidden"
	    
	}
	else //未申请
	{
		document.getElementById("CancelApp").disabled=true
		document.getElementById("PrintApp").disabled=true  
     //document.getElementById("SpeNum").style.display=""
     //document.getElementById("SpePos").style.display=""
     //document.getElementById("SPEMEMO").style.display=""
	}
	var ksgudingDate = DateDemo() 
	var litiDate = DateDemo()
	document.getElementById("GuDingDate").value=ksgudingDate
	document.getElementById("BiaoBenLiTiDate").value=litiDate    
	GetPatInfo()	
	GetAppInfo()
  //GetSpecimenInfo()
	AutoNumber() 
	GetWomanTumourInfo()
	//document.getElementById("ChuanRanBingShi").value="无"
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
			//address,SEXDR,feetypedr,admreasonDr 25
    		document.getElementById("RegNo").value=item[0]
			document.getElementById("PName").value=item[1]
			
			//2008-5-1-----1/5/2008 ??
			var vdate3=item[2]
			var vdate4=""
			if(vdate3!="")
			{
				var ChangDFun=document.getElementById("DateChange3to4").value
				vdate4=cspRunServerMethod(ChangDFun,vdate3)
			}
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
			feibieDr=item[24]
			document.getElementById("InpoNo").value=item[8]
			var item9=""
			if(item[9]!="")
				item9=item[9].split("-")[1]
			document.getElementById("RoomNo").value=item9
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
    		document.getElementById("RegNo").value=item[9]
			document.getElementById("PName").value=item[1]
			
			var vdate3=item[4]
			var vdate4=""
			if(vdate3!="")
			{
			var ChangDFun=document.getElementById("DateChange3to4").value
			vdate4=cspRunServerMethod(ChangDFun,vdate3)
			}
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
			feibieDr=item[24]
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
    
    	var GetCSTATUSFunction=document.getElementById("GetCurrentStatusAll").value
  		var value1=cspRunServerMethod(GetCSTATUSFunction,paadmdr)
  		var ClinicRec=document.getElementById("ClinicRec1").value
      //alert(ClinicRec)
  		if (ClinicRec=="")
    	   document.getElementById("ClinicRec1").value=value1
//添加标本来源后临床诊断及体征信息
		 var GetOrdInfoFun=document.getElementById("OrderInfo").value
  		var ORDERINFO=cspRunServerMethod(GetOrdInfoFun,orditemdr)
    	if (ORDERINFO!="")
			{   
				var item=ORDERINFO.split("^")
				//arcimid,strOrderName,strDate,strTime,requestdoc,ssusrdr, 6
				//strAccessionNum,SGroupDesc,subCatDesc,CatDesc,ifbed,price 12
				//Num,TotalPrice,billed,$g(ItemStatusCode),$g(ServerMaterial) 17
				//RecLocdr,$g(ResultFlag),strCommon,RecLocDesc 21
			  /*document.getElementById("GetOEorditemName").value=item[1]
				if(item[1]==t['CG'])
				   document.getElementById("Frost").checked=false
				if(item[1]==t['BD'])
				   document.getElementById("Frost").checked=true
				   */
				document.getElementById("Price").value=item[13]
				document.getElementById("AppDoc").value=item[4]
				document.getElementById("AppDocDR").value=item[5]
				document.getElementById("AppDate").value=item[2]
			}
		var GetAppInfoFun=document.getElementById("GetAppInfo").value
  	    var APPINFO=cspRunServerMethod(GetAppInfoFun,ttmrowid)
    	if (APPINFO!="")
		{      
			var item=APPINFO.split("^")
			//frost,clinicRecord,operResult,tumourInfo,womenInfo,relClinic, 6
			//appDeptDr,appDept,appDate,appTime,appDocDr,appDoc,orderDr 13
			if (item[0]=="1")
			{
				document.getElementById("Frost").checked=true
				} 
		   if (item[0]=="0")
			{
				document.getElementById("Frost").checked=false
				}  
			if(item[5]!="")			
			document.getElementById("ClinicDiag").value=item[5]
			if(item[2]!="")	
			document.getElementById("OperationSee").value=item[2]
			if(item[1]!="")
			{
				 tclinicrecord=item[1]
				 if(item[1]!="")
						SetClinicRecord()
			}
			
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
            if (item[0]=="1")
			{
				document.getElementById("Frost").checked=true
				} 
				else
				{
					document.getElementById("Frost").checked=false
					}
    		document.getElementById("AppDep").value=item[7]
        	document.getElementById("AppLocDR").value=item[6]
		
			document.getElementById("AppDoc").value=item[11]
			document.getElementById("AppDocDR").value=item[10]
						
			var vdate3=item[8]
			var vdate4=""
			if(vdate3!="")
			{
				var ChangDFun=document.getElementById("DateChange3to4").value
				vdate4=cspRunServerMethod(ChangDFun,vdate3)
			}
			document.getElementById("AppDate").value=vdate4
			
			document.getElementById("ClinicDiag").value=item[5]
			document.getElementById("OperationSee").value=item[2]
			
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
			document.getElementById("Price").value=item[13]
			document.getElementById("GetOEorditemName").value=item[1]
		}
	}
	/*if(bdflag==1&&bNewPatient==1)
	{
		//document.getElementById("Frost").disabled=false
		document.getElementById("Frost").checked=false
		}
		else
		{
		 // document.getElementById("Frost").disabled=true
	      document.getElementById("Frost").checked=true
	   }
	   */
	  
	if(bNewPatient==1)
    {
	    document.getElementById("TMrowid").disabled=true
	     document.getElementById("ClinicRec1").disabled=false
		 document.getElementById("OperationSee").disabled=false
		 document.getElementById("FHOHistory").disabled=false
	 	 document.getElementById("JWHistory").disabled=false
	 	 document.getElementById("Kuai").checked=true
	 	 document.getElementById("SpeNum").disabled=false
	 	 //document.getElementById("Frost").disabled=false
	 	 //if(isNull("TransPos")==true)
	 	 	//document.all("TransPos").style.display = "none"
    }
    else
    {
	   document.getElementById("TMrowid").disabled=true
	   document.getElementById("Frost").disabled=true
	   document.getElementById("ClinicRec1").disabled=true
		 document.getElementById("OperationSee").disabled=true
		 document.getElementById("FHOHistory").disabled=true
	 	 document.getElementById("JWHistory").disabled=true
	 	 document.getElementById("SpeNum").disabled=true
	 	 document.getElementById("Kuai").checked=false
	 	 document.getElementById("Zu").checked=false
	 	 document.getElementById("Dui").checked=false
	 	 document.getElementById("Tiao").checked=false
	 	 document.getElementById("Dian").checked=false
	 	 document.getElementById("Kuai").disabled=true
	 	 document.getElementById("Zu").disabled=true
	 	 document.getElementById("Dui").disabled=true
	 	 document.getElementById("Tiao").disabled=true
	 	 document.getElementById("Dian").disabled=true
	 	 document.getElementById("Kuai").style.display = "none"
	 	 document.getElementById("Zu").style.display = "none"
	 	 document.getElementById("Dui").style.display = "none"
	 	 document.getElementById("Tiao").style.display = "none"
	 	 document.getElementById("Dian").style.display = "none"
	 	 document.getElementById("cKuai").style.display = "none"
	 	 document.getElementById("cZu").style.display = "none"
	 	 document.getElementById("cDui").style.display = "none"
	 	 document.getElementById("cTiao").style.display = "none"
	 	 document.getElementById("cDian").style.display = "none"
    }
 }
 
 /*
 function GetSpecimenInfo()
{ 
	var GetSpecimensFunc=document.getElementById("SpecimenXS").value
	var info=cspRunServerMethod(GetSpecimensFunc,ttmrowid)
	var item=info.split(":")
  document.getElementById("SpeNum").value=item[0]
  alert(document.getElementById("SpeNum").value)
  document.getElementById("SpePos").value=item[1]
  alert(document.getElementById("SpePos").value)
  document.getElementById("SPEMEMO").value=item[2]
  alert(document.getElementById("SPEMEMO").value)
 }
function GetSpecimenInfo1()
{ 
	var GetSpecimensFunc=document.getElementById("autoNumAdd").value
	var info=cspRunServerMethod(GetSpecimensFunc,ttmrowid)
	var item1=info.split(":")
  var info2=item1[1]
  var item2=info2.split("(")
  var info3=item2[1]
  var item3=info3.split("~")
  var item4=item3[0]
  var info4=item3[1]
  var item5=info4.split(");")
  var item6=item5[0]
  var item7=item4+item6
  document.getElementById("SpeNum").value=item1[0]
  alert(document.getElementById("SpeNum").value)
  document.getElementById("SpePos").value=item2[0]
  alert(document.getElementById("SpePos").value)
  document.getElementById("SPEMEMO").value=item7
  alert(document.getElementById("SPEMEMO").value)
 }
 */
 
 function SetClinicRecord()
 {
	var item=tclinicrecord.split(code1)

	document.getElementById("FHOHistory").value=item[0]                //放化疗
	document.getElementById("JWHistory").value=item[1]                //既往病理检查
	document.getElementById("ClinicRec1").value=item[2]             //临床体征
	document.getElementById("GuoMinYaoWu").value=item[4]  //过敏药物
	document.getElementById("QuCaiLoc").value=item[5]  //取材科室
	document.getElementById("QuCaiDoc").value=item[6]
	//document.getElementById("ChuanRanBingShi").value=item[3]  //传染病史
  if(item[3]==t['wunocrbs']) 
  {
   var wubiaozhi=1
   document.getElementById("wucrbs").checked=wubiaozhi
  }
  if(item[3]!=t['wunocrbs']) 
  {
  var crbsinfo=item[3].split(duihao)
  var yginfo=crbsinfo[0].split("(")
  if (yginfo[0]=="HBsAg") var ygbiaozhi=1
   else var ygbiaozhi=0
  {
   document.getElementById("HBsAg").checked=ygbiaozhi
  }
   var bginfo=crbsinfo[1].split("(")
   if (bginfo[0]=="HCV") var bgbiaozhi=1
   else var bgbiaozhi=0
  {
   document.getElementById("HCV").checked=bgbiaozhi
  }
  var azinfo=crbsinfo[2].split("(")
  if (azinfo[0]=="HIV") var azbiaozhi=1
   else var azbiaozhi=0
  {
   document.getElementById("HIV").checked=azbiaozhi
  }
  if (crbsinfo[3]!="") var qtbiaozhi=1
  else var qtbiaozhi=0
  {  
   document.getElementById("othercrbs").checked=qtbiaozhi
   document.getElementById("ChuanRanBingShi").value=crbsinfo[3] 
  }
  document.getElementById("wucrbs").checked=false
  }
 
	var enmeth=document.getElementById("DateChange3to4").value
	var GetOtherDateObj=document.getElementById("GetSpecimenOtherDate").value
	var GetSpecimenOtherDate=cspRunServerMethod(GetOtherDateObj,ttmrowid)
	if(GetSpecimenOtherDate!="")
	{
		var item1=GetSpecimenOtherDate.split("^")
		var item11=""
		if(item1[0]!="")
		{
			item11=cspRunServerMethod(enmeth,item1[0])	
		}
		document.getElementById("BiaoBenLiTiDate").value=item11
		document.getElementById("BiaoBenLiTiTime").value=item1[1]
		var item12=""
		if(item1[2]!="")
		{
			item12=cspRunServerMethod(enmeth,item1[2])	
		}
		document.getElementById("GuDingDate").value=item12
		document.getElementById("GuDingShiJian").value=item1[3]
		var item14=""
		if(item1[4]!="")
		{
			item14=cspRunServerMethod(enmeth,item1[4])	
		}
		document.getElementById("SendDate").value=item14
	}
	
 }
 
 function GetWomanTumourInfo()
 {
	  var GetTumourInfo=document.getElementById("GetTumourInfo")
		
      if (GetTumourInfo!="")
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
		    document.getElementById("TumourMemo").value=item[7]
		    
		    //document.getElementById("TTumourRowId").value=item[8]
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
		 document.getElementById("TumourMemo").disabled=false
		 //有无转移
		  if(isNull("TransPos")==true)
		 	document.all("TransPos").style.display = "none" 
		  //if(isNull("LastDate")==true)
		 	//document.getElementById("EndDate").checked = true 
      //document.getElementById("ChuanRanBingShi").disabled=false
       //if(isNull("ChuanRanBingShi")==true)
	    //document.all("ChuanRanBingShi").style.display = "none"
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
		 document.getElementById("TumourMemo").disabled=true
     //document.getElementById("ChuanRanBingShi").disabled=true
		 
		 document.getElementById("BiaoBenLiTiTime").disabled=true
		 document.getElementById("BiaoBenLiTiDate").disabled=true		 
	 	 document.getElementById("GuoMinYaoWu").disabled=true
	 	 document.getElementById("QuCaiDoc").disabled=true
		 document.getElementById("QuCaiLoc").disabled=true
		 document.getElementById("LastMenstrual").disabled=true
		 document.getElementById("SendDate").disabled=true
	 	 document.getElementById("GuDingShiJian").disabled=true
	 	 document.getElementById("GuDingDate").disabled=true
	 	 
	 	 DisableById(componentId,"TumourDate")
    DisableById(componentId,"LastDate")
     DisableById(componentId,"LastMenstrual")
    DisableById(componentId,"SendDate")
	 	DisableById(componentId,"BiaoBenLiTiDate")
	 	DisableById(componentId,"GuDingDate")
	 	DisableById(componentId,"QuCaiLoc")
	 	DisableById(componentId,"QuCaiDoc")
      }
		
	  //Get patient women information
	  var tsexdes=document.getElementById("PSex").value
	  
	  if(tsexdes==t['SEXNV'])
	  { 
	  	var GetWomenInfo=document.getElementById("WomenInfo")
      	if (GetWomenInfo)
      	{
        	var returnWomInfoVal
         	var enmeth=document.getElementById("WomenInfo").value
        	var returnWomInfoVal=cspRunServerMethod(enmeth,ttmrowid)
        	if (returnWomInfoVal)
	     	{   
	        	var item=returnWomInfoVal.split("^")

	        if (item[0]!="")
		    	{
			    	var enmeth=document.getElementById("DateChange3to4").value
			    	item[0]=cspRunServerMethod(enmeth,item[0])
		    	}
	        document.getElementById("LastMenstrual").value=item[0]
		    	if (item[1]!="")
		    	{
			    	var enmeth=document.getElementById("DateChange3to4").value
			    	item[1]=cspRunServerMethod(enmeth,item[1])
			    	document.getElementById("LastDate").value=item[1]
		    	}
		    	
		    	if (item[2]=="Y")
		    	{
			    	document.getElementById("EndDate").checked=true
		    	}
		    	else
		    	{			    	
		    		document.getElementById("EndDate").checked=false
		    	}
		    	
		    	document.getElementById("Tai").value=item[3]
		    	document.getElementById("Chan").value=item[4]
		    	//document.getElementById("TWomenRowId").value=item[5]
	     	}
      	}
      	
	  }
	  
	  if(bNewPatient==1 && tsexdes==t['SEXNV'])
      {
	     document.getElementById("LastDate").disabled=false
	 	 document.getElementById("EndDate").disabled=false
		 document.getElementById("Tai").disabled=false
		 document.getElementById("Chan").disabled=false
		 document.getElementById("LastMenstrual").disabled=false
//		 if (document.getElementById("LastDate").value=="")
//	     	document.all("LastDate").style.display = "none"
//	   if (document.getElementById("LastMenstrual").value=="")
//	     	document.all("LastMenstrual").style.display = "none"
      }
      else
      {
	     document.getElementById("LastDate").disabled=true
    	 //if (document.getElementById("LastDate").value=="")
	     	//document.all("LastDate").style.display = "none"
	 	 document.getElementById("EndDate").disabled=true
		 document.getElementById("Tai").disabled=true
		 document.getElementById("Chan").disabled=true
		 DisableById(componentId,"LastDate")
		 document.getElementById("LastMenstrual").disabled=true
    	 //if (document.getElementById("LastMenstrual").value=="")
	     	//document.all("LastMenstrual").style.display = "none"
     DisableById(componentId,"LastMenstrual")
      }
 }
 
 function SpeAddkey()
 { 
	var VSpeNum=document.getElementById("SpeNum").value
	var VSpeNum=Trim(VSpeNum)  
	if (!isDigit(VSpeNum))
	{
		alert(t['NotNumber']);
		return;
	}
	var danwei=""
	if(document.getElementById("Kuai").checked)
	{
		danwei=t['Kuai']
	}
	if(document.getElementById("Zu").checked)
	{
		danwei=t['Zu']
	}
	if(document.getElementById("Dui").checked)
	{
		danwei=t['Dui']
	}
	if(document.getElementById("Tiao").checked)
	{
		danwei=t['Tiao']
	}
	if(document.getElementById("Dian").checked)
	{
		danwei=t['Dian']
	}
    var VSpePos=document.getElementById("SpePos").value
    var VSpePos=Trim(VSpePos)
    var VSpeMemo=document.getElementById("SPEMEMO").value
    var VSpeMemo=Trim(VSpeMemo)
    var TMrowid=ttmrowid
    if ((VSpeNum=="")||(VSpePos=="")||(TMrowid=="")||(VSpeMemo=="")||(danwei==""))
    {
	   alert(t['NOTNULL']);
	   return;
    }
    
    var SpeAddFun=document.getElementById("SpeAddFunction").value
    var ret=cspRunServerMethod(SpeAddFun,TMrowid+"^"+VSpeNum+"^"+VSpePos+"^"+VSpeMemo+"~"+danwei+"^"+"^"+"^")
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
	Refresh() 
 }
 
 function SpeDelkey()
 {  
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
 
 function SpeEditkey()
 { 
	selectrow=SelectedRow
  var VSpeMemojiag="12"
  var VSpeMemojiaq="11"
  var danweig="点"
	var SpeNum=document.getElementById("SpeNum").value
    var SpePos=document.getElementById("SpePos").value
    var SpePos=Trim(SpePos)
    var SpeMemo=document.getElementById("SPEMEMO").value
    var SpeRowId=document.getElementById("SpeRowId").value
    //alert(SpeMemo+SpeRowId)
    var danwei=""
	if(document.getElementById("Kuai").checked)
	{
		danwei=t['Kuai']
	}
	if(document.getElementById("Zu").checked)
	{
		danwei=t['Zu']
	}
	if(document.getElementById("Dui").checked)
	{
		danwei=t['Dui']
	}
	if(document.getElementById("Tiao").checked)
	{
		danwei=t['Tiao']
	}
	if(document.getElementById("Dian").checked)
	{
		danwei=t['Dian']
	}
    if ((SpeNum=="")||(SpePos=="")||(SpeMemo=="")||(danwei==""))
    {
	   alert(t['NOTNULL'])
	   return;
    }
    if (SpeRowId=="")
    {
	   alert(t['CHOOSELINE'])
	   return;
    }
   
     if (appitmcode=="DBLK000032")
     {
	      if ((SpeNum=="1")&&(SpeMemo<12))
	      {
	       alert(t['INVALIDSpeNumjiag'])
	       var SpeEditFung=document.getElementById("SpeEditFunction").value
	       //alert(VSpeMemojiag)
          var retg=cspRunServerMethod(SpeEditFung,SpeNum+"^"+SpePos+"^"+VSpeMemojiag+"~"+danweig+"^"+"^"+"^",SpeRowId)
	      //alert(retg)
	      }
	       else
	      {
          var SpeEditFun=document.getElementById("SpeEditFunction").value
          var ret=cspRunServerMethod(SpeEditFun,SpeNum+"^"+SpePos+"^"+SpeMemo+"~"+danweig+"^"+"^"+"^",SpeRowId)
	      }
	   }
	   if ((SpeNum=="1")&&(appitmcode=="DBLK000034")&&(SpeMemo<1))
	    {
		       alert(t['INVALIDSpeNumjiaq']) 
	    } 
	    if (appitmcode!="DBLK000032")
	    {
		     var SpeEditFun=document.getElementById("SpeEditFunction").value
              var ret=cspRunServerMethod(SpeEditFun,SpeNum+"^"+SpePos+"^"+SpeMemo+"~"+danwei+"^"+"^"+"^",SpeRowId)
	       }
	   /*
	   if ((SpeNum=="1")&&(appitmcode=="DBLK000034"))
	    {
		    if (SpeMemo<11)
		    {
		       alert(t['INVALIDSpeNumjiaq'])
	         var SpeEditFunq=document.getElementById("SpeEditFunction").value
           var retq=cspRunServerMethod(SpeEditFunq,SpeNum+"^"+SpePos+"^"+VSpeMemojiaq+danweig+"^"+"^"+"^",SpeRowId)
		    }
		     else
	       {
          var SpeEditFun=document.getElementById("SpeEditFunction").value
          var ret=cspRunServerMethod(SpeEditFun,SpeNum+"^"+SpePos+"^"+SpeMemo+danweig+"^"+"^"+"^",SpeRowId)
	       }
	    } 
	    */
	   
    /*
    if (ret.split("-")[0]=="") //Such as return -901,-915 or other SQL error,which is initial with "-".
    {
	   alert(t['SpeEditFailure'])
	  }
    else
    {
	  // alert(t['SpeEditSuccess'])
	}
	 */
	Refresh()
	document.getElementById("SpecimenDel").disabled=true
	document.getElementById("SpecimenEdit").disabled=true
	document.getElementById("SpecimenAdd").disabled=false
 }
 
 function SendAppkey()
 { 
      if (ttmrowid=="")
    {
	   alert(t['NOTNULL'])
	   return
    }
    var GetAppInfoFun=document.getElementById("GetAppInfo").value
  	    var APPINFO=cspRunServerMethod(GetAppInfoFun,ttmrowid)
    	if (APPINFO!="")
		{      
			var item=APPINFO.split("^")
      if((item[0]=="")||(item[1]=="")||(item[2]==""))
      {
        alert(t['QXBCSQD'])
	     return
       }
      }   
    SetPatInfo()
    SetAppInfo()
    //SetFronstInfo()
    SetWomanTumourInfo()
    UpdateSpeOtherDate()
    StopOrder()
    if (appitmcode!="DBLK000033")
     {
       InsertOrder()                   
       } 
	 var typezm=document.getElementById("PType").value
     var orditemrowid=document.getElementById("OEorditemID").value
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
    Refresh2() 
 }
 
  function SaveAppkey()
 {  
	 if (ttmrowid=="")
    {
	   alert(t['NOTNULL'])
	   return
    }
    var Objtbl=document.getElementById('t'+tformName)
		var Rows=Objtbl.rows.length-1
		if(Rows<1)
		{
			alert(t['NOSPECIMEN'])
			return
		}
    var operResult=document.getElementById("OperationSee").value
    var JWHistory=document.getElementById("JWHistory").value
    //var ChuanRanBingShi=document.getElementById("ChuanRanBingShi").value
    var ClinicDiag=document.getElementById("ClinicDiag").value
    var ClinicRec1=document.getElementById("ClinicRec1").value
    var len=strlen(ClinicRec1)
      if(len<20)
      {
	      alert("临床症状及体征最少输入10个汉字!");
	      return;
      } 
    //var FHOHistory=document.getElementById("FHOHistory").value
    var BiaoBenLiTiTime=document.getElementById("BiaoBenLiTiTime").value
		var BiaoBenLiTiDate= document.getElementById("BiaoBenLiTiDate").value
		var QuCaiLoc= document.getElementById("QuCaiLoc").value
		var SendDate= document.getElementById("SendDate").value
		var GuDingShiJian= document.getElementById("GuDingShiJian").value
		var GuDingDate= document.getElementById("GuDingDate").value
		//alert(GuDingDate)
    var operResult=Trim(operResult)
    var JWHistory=Trim(JWHistory)
    //var ChuanRanBingShi=Trim(ChuanRanBingShi)
    var ClinicDiag=Trim(ClinicDiag)
    var ClinicRec1=Trim(ClinicRec1)
    //var FHOHistory=Trim(FHOHistory)
    var QuCaiLoc=Trim(QuCaiLoc)
    
    if (operResult==""||JWHistory==""||BiaoBenLiTiTime==""||BiaoBenLiTiDate==""||QuCaiLoc==""||SendDate==""||ClinicDiag==""||ClinicRec1==""||GuDingShiJian==""||GuDingDate=="")
    {
	   alert(t['opeResultNOTNULL'])
	   return
    }
		var apploc=document.getElementById("AppDep").value
		if(apploc.indexOf(t['FuKe'])!="-1" || apploc.indexOf(t['ChanKe'])!="-1")
		{
	  	if((document.getElementById("PSex").value==t['SEXNV'])&&(document.getElementById("PAge").value>"14"))
	  	{
	  		var LastMenstrual=document.getElementById("LastMenstrual").value
	    	var MCDate=document.getElementById("LastDate").value
	    	var JDInfo=document.getElementById("EndDate").checked
	    	if(((LastMenstrual=="")&&(JDInfo==false))||((JDInfo==true)&&(MCDate=="")))
	    	{
	    		alert(t['INVALIDWOMANINFO'])
	    		return 
	    	}
		  }
		}	  
    SetPatInfo()
    SetAppInfo()
    //SetFronstInfo()
    SetWomanTumourInfo()
    UpdateSpeOtherDate()
    /*
    StopOrder()
    if (appitmcode!="DBLK000033")
     {
       InsertOrder()                   
       }
       */ 
    Refresh2()
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
 }
 
 function GetChuanRanBingS()
 {
  ChuanRanBingShi=""
  var yiganfo=""
  var bingganfo=""
  var aizifo=""
  var qitacrbsfo=""
	if(document.getElementById("HBsAg").checked==true)
  {
    var yigan=t['HBsAgyg'] 
    //yiganfo+=yigan
    yiganfo=yiganfo+yigan
    
  }
  if(document.getElementById("HCV").checked==true)
  {
    var binggan=t['HCVbg']
    bingganfo+=binggan
  }
  if(document.getElementById("HIV").checked==true)
  {
    var aizi=t['HIVaz']
    aizifo+=aizi
  }
  if(document.getElementById("othercrbs").checked==true)
  {
    var qitacrbs=document.getElementById("ChuanRanBingShi").value
     qitacrbs=Trim(qitacrbs)
     qitacrbsfo+=qitacrbs
  }  
     //alert("yiganfo="+yiganfo)
  ChuanRanBingShi=yiganfo+duihao+bingganfo+duihao+aizifo+duihao+qitacrbsfo
  //alert(ChuanRanBingShi)                                                   
  if(document.getElementById("wucrbs").checked==true)
  {
    var nocrbs=t['wunocrbs']
    ChuanRanBingShi=nocrbs
    //alert(ChuanRanBingShi)
  }          
 } 
 
 function GetClinicRecord()
 {
  tclinicrecord=""
	var timage=document.getElementById("FHOHistory").value                //放化疗
	var thuayan=document.getElementById("JWHistory").value                //既往病理检查
	var linchuang=document.getElementById("ClinicRec1").value             //临床体征
	Trim(linchuang)
	//var ChuanRanBingShi=document.getElementById("ChuanRanBingShi").value  //传染病史
	var GuoMinYaoWu=document.getElementById("GuoMinYaoWu").value  //过敏药物
	var QuCaiLoc=document.getElementById("QuCaiLoc").value  //取材科室
	var QuCaiDoc=document.getElementById("QuCaiDoc").value
  GetChuanRanBingS()
	tclinicrecord=timage+code1+thuayan+code1+linchuang+code1+ChuanRanBingShi+code1+GuoMinYaoWu+code1+QuCaiLoc+code1+QuCaiDoc
  //alert(tclinicrecord)
 }
 
 function SetAppInfo()
 {
	 if(bNewPatient==1)
	 {
		 var appinfo=""
		 var tbingdong=""
		 
		 GetClinicRecord()
		 
 		 var tbingdong=""
		 
		 if(document.getElementById('Frost').checked)
		 	tbingdong="1"
		 else
		 	tbingdong="0"
		 appinfo+=tclinicrecord+"^"
     //alert("tclinicrecord")
		 appinfo+=document.getElementById('OperationSee').value+"^^^"
		 appinfo+=document.getElementById('ClinicDiag').value+"^"+tbingdong+"^^^"
		 appinfo+=document.getElementById('AppDep').value+"^"
		 appinfo+=document.getElementById('AppLocDR').value+"^"
		 appinfo+=document.getElementById('AppDoc').value+"^"
		 appinfo+=document.getElementById('AppDocDR').value+"^"+orditemdr
	   //alert(appinfo)
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
			var ldate=""
			var lastdate=document.getElementById("LastMenstrual").value
			if(lastdate!="")
			{
				 var DateChangeFun=document.getElementById("DateChange4to3").value
				 ldate=cspRunServerMethod(DateChangeFun,lastdate)
			}
			
			var twinfo=""		
				
			var tjj=""
			var tjjobj=document.getElementById("EndDate")
			  if(tjjobj.checked)
				{
					tjj="Y"
				}
				else
				{
					tjj="N"
				}
			var tdate=""
			var jjdate=document.getElementById("LastDate").value
				if(jjdate!="")
				{
					var DateChangeFun=document.getElementById("DateChange4to3").value
					tdate=cspRunServerMethod(DateChangeFun,jjdate)
				}
			
			var ttai=document.getElementById("Tai").value
			var tchan=document.getElementById("Chan").value
			
			twinfo=ttmrowid+"^"+ldate+"^"+tdate+"^"+tjj+"^"+ttai+"^"+tchan+"^"
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
		var foundDate=Trim(foundDate)
		var foundPos=document.getElementById("TumourPosition").value
		var foundPos=Trim(foundPos)

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
    		
    		var otherInfo=document.getElementById("TumourMemo").value
     		var UpdateTumourInfo=ttmrowid+"^"
     		UpdateTumourInfo+=foundDate+"^"+position+"^"+size+"^"+zhuanyi+"^"+transferPos+"^"+radioc+"^"+chemicalc+"^"+otherInfo
	        var UpdateTumour=document.getElementById("AddTumourInfo").value
      		var tumourid=cspRunServerMethod(UpdateTumour,UpdateTumourInfo)
	        if (tumourid=="") //Such as return -901,-915 or other SQL error,which is initial with "-".
     		{
	     		alert(t['SendAppFailure'])
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

function UpdateSpeOtherDate()
{
	//修改离体时间，固定时间，送检时间。
  var enmeth=document.getElementById("DateChange4to3").value
	var BiaoBenLiTiDate=document.getElementById("BiaoBenLiTiDate").value
	if(BiaoBenLiTiDate!="")
	{
		BiaoBenLiTiDate=cspRunServerMethod(enmeth,BiaoBenLiTiDate)
	}
	var BiaoBenLiTiTime=document.getElementById("BiaoBenLiTiTime").value
			
			var GuDingDate=document.getElementById("GuDingDate").value
			if(GuDingDate!="")
			{
				GuDingDate=cspRunServerMethod(enmeth,GuDingDate)
			}
			
			var GuDingShiJian=document.getElementById("GuDingShiJian").value
			
			var SendDate=document.getElementById("SendDate").value
			if(SendDate!="")
			{
				SendDate=cspRunServerMethod(enmeth,SendDate)
			}
	var UpdateSpecimenOtherDate=document.getElementById("UpdateSpecimenOtherDate").value;
			var code1=cspRunServerMethod(UpdateSpecimenOtherDate,BiaoBenLiTiDate+"^"+BiaoBenLiTiTime+"^"+GuDingDate+"^"+GuDingShiJian+"^"+SendDate+"^",ttmrowid)
			if (code1!="0")
			{
				alert['UpdateDateFailure']
				return
			}
}

 function CancelAppkey()
 {  
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
     StopOrder()
     //his取消申请单不删除医嘱相对应数据?
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
	//Refresh()
  Refresh2()
 }
 
 function Refresh()
 {
    var EposideA=document.getElementById("EpisodeID").value
    var TMrowidA=document.getElementById("TMrowid").value
    var OEorditemIDA=document.getElementById("OEorditemID").value
    var RefreshA=document.getElementById("Refresh").value
    
    var OperationSeeA=document.getElementById("OperationSee").value
    var JWHistoryA=document.getElementById("JWHistory").value
    var ClinicRec1A=document.getElementById("ClinicRec1").value
    var ClinicDiagA=document.getElementById("ClinicDiag").value
    
    //var OperationSeeA=document.getElementById("Frost").value
    //var Frost=document.getElementById("Frost").value
    var TransPos=document.getElementById("TransPos").value //转移部位
    var TumourDate=document.getElementById("TumourDate").value
    var TumourMemo=document.getElementById("TumourMemo").value
    var TumourPosition=document.getElementById("TumourPosition").value
    var TumourSize=document.getElementById("TumourSize").value 
     
    var LastDate=document.getElementById("LastDate").value 
	var Tai=document.getElementById("Tai").value 
	var Chan=document.getElementById("Chan").value 
	
	var LastMenstrual=document.getElementById("LastMenstrual").value
	var GuoMinYaoWu=document.getElementById("GuoMinYaoWu").value
    var BiaoBenLiTiTime=document.getElementById("BiaoBenLiTiTime").value
    var ChuanRanBingShi=document.getElementById("ChuanRanBingShi").value
    var QuCaiDoc=document.getElementById("QuCaiDoc").value
	var QuCaiLoc=document.getElementById("QuCaiLoc").value
  var GuDingShiJian=document.getElementById("GuDingShiJian").value  
	var PreSelectrow=document.getElementById("PreSelectrow").value //Add by lff 2008-12-18
	
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+tformName
    lnk+="&EpisodeID="+EposideA
    lnk+="&OEorditemID="+OEorditemIDA
    lnk+="&TMrowid="+TMrowidA
    lnk+="&OperationSee="+OperationSeeA
    lnk+="&ClinicDiagA="+ClinicDiagA
    ///缓存肿瘤信息YCX20081205
    lnk+="&TransPos="+TransPos
    lnk+="&TumourDate="+TumourDate
    lnk+="&TumourMemo="+TumourMemo
    lnk+="&TumourPosition="+TumourPosition
    lnk+="&TumourSize="+TumourSize

     //lnk+="&Frost="+Frost

		lnk+="&LastMenstrual="+LastMenstrual
	lnk+="&LastDate="+LastDate
	lnk+="&Tai="+Tai
	lnk+="&Chan="+Chan
	
	  lnk+="&GuoMinYaoWu="+GuoMinYaoWu
	lnk+="&BiaoBenLiTiTime="+BiaoBenLiTiTime
	lnk+="&ChuanRanBingShi="+ChuanRanBingShi
	lnk+="&QuCaiLoc="+QuCaiLoc
	lnk+="&QuCaiDoc="+QuCaiDoc
	  lnk+="&GuDingShiJian="+GuDingShiJian
    lnk+="&JWHistory="+JWHistoryA
    lnk+="&ClinicRec1="+ClinicRec1A

    lnk+="&Refresh="+RefreshA
    lnk+="&PreSelectrow="+PreSelectrow //Add by lff 2008-12-1 记录前一次所选行
    location.href=lnk
    AutoNumber()
 }
 //刷新左菜单YCX20081205
  function Refresh2()
 {  
    var EposideA=document.getElementById("EpisodeID").value
    
    var TMrowidA=document.getElementById("TMrowid").value
    var OEorditemIDA=document.getElementById("OEorditemID").value
    var RefreshA=document.getElementById("Refresh").value
    var OperationSeeA=document.getElementById("OperationSee").value
    var JWHistoryA=document.getElementById("JWHistory").value
    //var ClinicRec1A=document.getElementById("ClinicRec1").value
    //var FHOHistoryA=document.getElementById("FHOHistory").value    

	var PreSelectrow=document.getElementById("PreSelectrow").value //Add by lff 2008-12-18

    var lnk=""
     lnk= "dhcrisappbill.csp?WEBSYS.TCOMPONENT="+tformName
    
    lnk+="&EpisodeID="+EposideA
    lnk+="&OEorditemID="+OEorditemIDA
    lnk+="&TMrowid="+TMrowidA
    lnk+="&OperationSee="+OperationSeeA
    //lnk+="&FHOHistory="+FHOHistoryA
    lnk+="&JWHistory="+JWHistoryA
    
    lnk+="&Refresh="+RefreshA
    lnk+="&PreSelectrow="+PreSelectrow 
    parent.location.href=lnk; 
    AutoNumber()
 
 }
 
 
 function Clear()
 {

    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+tformName+"&EpisodeID="+""+"&OEorditemID="+""+"&TMrowid="+""+"&Refresh="+""
    location.href=lnk
 }
 
 function SelectRowHandler()	
 {
	var eSrc=window.event.srcElement
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement
	var eSrcAry=eSrc.id.split("z")
	var rowObj=getRow(eSrc)
	var selectrow=rowObj.rowIndex
	
	var PreSelectrow=document.getElementById("PreSelectrow").value //Add by lff 2008-12-18
	
	if (!selectrow) 
	{
		document.getElementById('SpeNum').value=""
		document.getElementById('SpePos').value=""
		document.getElementById('SPEMEMO').value=""
		document.getElementById('SpeRowId').value=""
		
		
		if(bNewPatient==1)
		{
			if((PreSelectrow==selectrow)&&(document.getElementById("SpecimenAdd").disabled==true)) //Add by lff 2008-12-18
			{
				document.getElementById("SpecimenAdd").disabled=false
				obj.value=""
			    obj1.value=""
			    obj3.value=""
			    obj5.value=""
			    AutoNumber()  //Update by lff 2008-12-26
			}
			else
			{
				document.getElementById("SpecimenAdd").disabled=true
			}
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
    var objtbl=document.getElementById('t'+tformName)

    var obj=document.getElementById('SpeNum')
	var obj1=document.getElementById('SpePos')
	var obj3=document.getElementById('SPEMEMO')
	var obj5=document.getElementById('SpeRowId')
	var SelRowObj=document.getElementById('TSpeNumz'+selectrow)
	var SelRowObj1=document.getElementById('TSpePosz'+selectrow)
	var SelRowObj3=document.getElementById('TSpeMemoz'+selectrow)
	var SelRowObj5=document.getElementById('TSpeRowIdz'+selectrow)

	obj.value=SelRowObj.innerText
	obj1.value=SelRowObj1.innerText
	var str=GetStringLastOne(SelRowObj3.innerText)
	var item=str.split("^")
	
	obj3.value=item[0]
	if(item[1]==t['Zu'])
	{
		document.getElementById("Zu").checked=true
		ZuKey()
	}
	if(item[1]==t['Kuai'])
	{
		document.getElementById("Kuai").checked=true
		KuaiKey()
	}
	if(item[1]==t['Dui'])
	{
		document.getElementById("Dui").checked=true
		DuiKey()
	}
	if(item[1]==t['Tiao'])
	{
		document.getElementById("Tiao").checked=true
		TiaoKey()
	}
	if(item[1]==t['Dian'])
	{
		document.getElementById("Dian").checked=true
		DianKey()
	}
	obj5.value=SelRowObj5.value
	
	if(obj1.value!="" && bNewPatient==1)
	{
		//document.getElementById("SpecimenAdd").disabled=true
        if((PreSelectrow==selectrow)&&(document.getElementById("SpecimenAdd").disabled==true)) //Add by lff 2008-12-18
		{
			document.getElementById("SpecimenAdd").disabled=false
			obj.value=""
			obj1.value=""
			obj3.value=""
			obj5.value=""
			AutoNumber()  //Update by lff 2008-12-26
		}
		else
		{
			document.getElementById("SpecimenAdd").disabled=true
		}		
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
	if((document.getElementById("SpeNum").value=="1")&&(appitmcode=="DBLK000032"))
	     {
	       document.getElementById("SpecimenDel").disabled=true
	     }
	if((document.getElementById("SpeNum").value=="1")&&(appitmcode=="DBLK000034"))
	     {
	       document.getElementById("SpecimenDel").disabled=true
	     }
	document.getElementById("PreSelectrow").value=selectrow  
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
   //s = sYear + "-" + sMonth + "-" + sDay 
   s = sDay + "/" + sMonth + "/" + sYear
   return(s)
}

function PrintAppkey()
{
	if(document.getElementById("PrintApp").disabled==true)
 		return
	PrintApp()
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
	var LDate=document.getElementById("LastDate")
	if(BJDate(LDate.value))
	{
		alert(t['DateError'])
		document.getElementById("LastDate").value=""
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
/*
function QiTaKey()
{
alert(567876567);
var QiTaObj=document.getElementById("othercrbs");
  alert(456789)
	if (QiTaObj.checked)
	{
  alert(798754)
	  document.getElementById("ChuanRanBingShi").disabled = false;
	  document.all("ChuanRanBingShi").style.display = ""
	  document.getElementById("ChuanRanBingShi").value ="";
	}
	else
	{
  alert(66666)
	  document.getElementById("ChuanRanBingShi").disabled = true;
	  document.all("ChuanRanBingShi").style.display = "none"
	  document.getElementById("ChuanRanBingShi").value="";
	} 
}
 */
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

function EndDateKey()
{
	/*
	var EndDateObj=document.getElementById("EndDate");
	if (EndDateObj.checked)
	{
	  document.getElementById("LastDate").disabled = true;
	  document.all("LastDate").style.display = "none"
	  document.getElementById("LastDate").value ="";
	}
	else
	{
	  document.getElementById("LastDate").disabled = false;
	  document.all("LastDate").style.display = ""
	  document.getElementById("LastDate").value="";
	} 
	*/
	var EndDateObj=document.getElementById("EndDate");
	if (EndDateObj.checked)
	{
	  document.getElementById("LastDate").disabled = false;
	  document.all("LastDate").style.display = ""
	  document.getElementById("LastDate").value ="";
	  
	  document.getElementById("LastMenstrual").disabled = true;
	  document.all("LastMenstrual").style.display = "none"
	  document.getElementById("LastMenstrual").value ="";
	}
	else
	{
	  document.getElementById("LastDate").disabled = true;
	  document.all("LastDate").style.display = "none"
	  document.getElementById("LastDate").value="";
	  
	  document.getElementById("LastMenstrual").disabled = false;
	  document.all("LastMenstrual").style.display = ""
	  document.getElementById("LastMenstrual").value ="";
	} 
}

//送检标本的序号自动加一
function AutoNumber()
 {  
	var GetSpecimensFunc=document.getElementById("autoNumAdd").value
	var info=cspRunServerMethod(GetSpecimensFunc,ttmrowid)
	var item=info.split(";")
	autoNumber=item.length
	document.getElementById("SpeNum").value = autoNumber
 }
 
//屏蔽放大镜
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
function isNull(Item)
{
	var ft=true
	var isNull=	document.getElementById(Item).value
	if(isNull=="")
		ft = true;	
	else
		ft = false;
	return ft;
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

//是否全为数字
function isDigit(s)
{
    var patrn=/^[0-9]{1,20}$/;
    if (!patrn.exec(s)) return false
    return true
}
/*
function PirntTMKey()
{
    var Bar,j;
    Bar= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
    Bar.PrintName="tiaoma";//printer name
       
    var RegisterNum=document.getElementById("RegNo").value
    var PName=document.getElementById("PName").value
    var RoomNo=document.getElementById("RoomNo").value
    //alert(RoomNo)
    var RoomNo=RoomNo.split("-")                             
    var RoomNo=RoomNo[1]
    var BedNo=document.getElementById("BedNo").value
    var PatLoc=document.getElementById("AppDep").value

    var OrderName=document.getElementById("GetOEorditemName").value

    		var GetSpecimensFunc=document.getElementById("autoNumAdd").value
      	var info=cspRunServerMethod(GetSpecimensFunc,ttmrowid)
      	var items=info.split(";")
        //alert(items)
      	var lenth=items.length-2
      	//alert("lenth="+lenth)
      	//alert(info) 1:dd(1);2:ss(2);
      	for (var i=0;i<=lenth;i++)
    	  {   
            Bar.LabNo=document.getElementById("TMRowid").value; 
            Bar.RecLoc=t['RecLoc'];
            Bar.PatLoc=PatLoc;
            Bar.OrdName=OrderName;
            Bar.PatName=RegisterNum+" "+PName;
            Bar.Sex=document.getElementById("PSex").value;
            Bar.Age=document.getElementById("PAge").value;
            Bar.BedCode=BedNo+t['chuang'];        
            Bar.LabelDesc=items[i].split("~").join(""); 
            //alert(Bar.LabNo+"="+Bar.RecLoc+"="+Bar.PatLoc+"="+Bar.OrdName+"="+Bar.PatName+"="+Bar.Sex+"="+Bar.Age+"="+Bar.BedCode+"="+Bar.LabelDesc)   
            Bar.PrintOut(1);
        }
}
*/
function PirntTMKey()
{
    var Bar,j;
    Bar= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
    Bar.PrintName="tiaoma";//printer name
       
    var RegisterNum=document.getElementById("RegNo").value
    var PName=document.getElementById("PName").value
    var RoomNo=document.getElementById("RoomNo").value
    //alert(RoomNo)
    var RoomNo=RoomNo.split("-")                             
    var RoomNo=RoomNo[1]
    var BedNo=document.getElementById("BedNo").value
    var PatLoc=document.getElementById("AppDep").value

    var OrderName=document.getElementById("GetOEorditemName").value

    		var GetSpecimensFunc=document.getElementById("autoNumAdd").value
      	var info=cspRunServerMethod(GetSpecimensFunc,ttmrowid)
      	var items=info.split(";")
        //alert(items)
      	var lenth=items.length-2
      	//alert("lenth="+lenth)
      	//alert(info) 1:dd(1);2:ss(2);
      	for (var i=0;i<=lenth;i++)
    	  {   
            var n=i+1;
            Bar.LabNo=ttmrowid+"-"+n 
            Bar.RecLoc=t['RecLoc'];
            Bar.PatLoc=PatLoc;
            Bar.OrdName=OrderName;
            Bar.PatName=RegisterNum+" "+PName;
            Bar.Sex=document.getElementById("PSex").value;
            Bar.Age=document.getElementById("PAge").value;
            Bar.BedCode=BedNo;        
            Bar.LabelDesc=items[i].split("~").join(""); 
            //alert(Bar.LabNo+"="+Bar.RecLoc+"="+Bar.PatLoc+"="+Bar.OrdName+"="+Bar.PatName+"="+Bar.Sex+"="+Bar.Age+"="+Bar.BedCode+"="+Bar.LabelDesc)   
            Bar.PrintOut(1);
        }
}

function KuaiKey()
{
	if(document.getElementById("Kuai").checked)
	{
		//document.getElementById("Kuai").checked=false
		document.getElementById("Zu").checked=false
		document.getElementById("Dui").checked=false
		document.getElementById("Tiao").checked=false
		document.getElementById("Dian").checked=false
	}
}

function ZuKey()
{
	if(document.getElementById("Zu").checked)
	{
		document.getElementById("Kuai").checked=false
		//document.getElementById("Zu").checked=false
		document.getElementById("Dui").checked=false
		document.getElementById("Tiao").checked=false
		document.getElementById("Dian").checked=false
	}
}

function DuiKey()
{
	if(document.getElementById("Dui").checked)
	{
		document.getElementById("Kuai").checked=false
		document.getElementById("Zu").checked=false
		//document.getElementById("Dui").checked=false
		document.getElementById("Tiao").checked=false
		document.getElementById("Dian").checked=false
	}
}

function TiaoKey()
{
	if(document.getElementById("Tiao").checked)
	{
		document.getElementById("Kuai").checked=false
		document.getElementById("Zu").checked=false
		document.getElementById("Dui").checked=false
		//document.getElementById("Tiao").checked=false
		document.getElementById("Dian").checked=false
	}
}

function DianKey()
{
	if(document.getElementById("Dian").checked)
	{
		document.getElementById("Kuai").checked=false
		document.getElementById("Zu").checked=false
		document.getElementById("Dui").checked=false
		document.getElementById("Tiao").checked=false
		//document.getElementById("Dian").checked=false
	}
}

function SPEMEMOKey()
{
	var SpeNum1=document.getElementById("SPEMEMO")
	var SpeNum2=SpeNum1.value
	var SpePos=document.getElementById("SpePos").value
	
	if((SpePos!="")&&(isNaN(SpeNum2)||(SpeNum2.match(/^[0-9]+$/)==null)||(SpeNum2<="0")))
	{
		alert(t['IsNaN'])
		SpeNum1.value=""
		SpeNum1.focus()
	}	
}

function HBsAgKey()
{
	if(document.getElementById("HBsAg").checked)
	{
		document.getElementById("wucrbs").checked=false
	}
}

function HCVKey()
{
	if(document.getElementById("HCV").checked)
	{
		document.getElementById("wucrbs").checked=false
	}
}

function HIVKey()
{
	if(document.getElementById("HIV").checked)
	{
		document.getElementById("wucrbs").checked=false
	}
}

function othercrbsKey()
{
	if(document.getElementById("othercrbs").checked)
	{
		document.getElementById("wucrbs").checked=false
	}
}

function wucrbsKey()
{
	if(document.getElementById("wucrbs").checked)
	{
		document.getElementById("HBsAg").checked=false
		document.getElementById("HCV").checked=false
		document.getElementById("HIV").checked=false
		document.getElementById("othercrbs").checked=false
	}
}

//提取字符串最后一个字符
function GetStringLastOne(sInputString)
{
	var leng = sInputString.length-1
	last = sInputString.substr(leng,1)
	fast = sInputString.substr(0,leng)
	//alert(fast+"^"+last)
	return fast+"^"+last
}
function PrintApp()
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
	    Template=TemplatePath+"DHCPisCGBL.xls";
      
	    xlApp = new ActiveXObject("Excel.Application")
			xlBook = xlApp.Workbooks.Add(Template);
			xlsheet = xlBook.ActiveSheet;
      var duihao=String.fromCharCode(8730)      
       
    //号码
    //xlsheet.cells(2,1)="*"+document.getElementById("TMrowid").value+"*";  //条码申请单号
    var OEorditemID=document.getElementById("OEorditemID").value; 
      var ordinfo=OEorditemID.split("||");
      var ordinfotm=ordinfo[0]+"-"+ordinfo[1];
      xlsheet.cells(2,1)="*"+ordinfotm+"*";  //条码医嘱号
    //xlsheet.cells(3,5)=document.getElementById("TMrowid").value;          //申请单号
    xlsheet.cells(3,5)=document.getElementById("RegNo").value;           //登记号/病人ID
    xlsheet.cells(3,26)=document.getElementById("OEorditemID").value;     //医嘱号
    
    //基本信息                                                            
    xlsheet.cells(5,4)=document.getElementById("PName").value;             //病人姓名
    xlsheet.cells(5,11)=document.getElementById("PSex").value;             //病人性别
    xlsheet.cells(5,18)=document.getElementById("PAge").value;             //病人年龄
    var appdate=document.getElementById("PBirthday").value;
    var item=appdate.split("/")
    xlsheet.cells(5,25)=item[2]+"-"+item[1]+"-"+item[0]; //出生日期
    //xlsheet.cells(5,23)=document.getElementById("PBirthday").value;              
    xlsheet.cells(7,11)=document.getElementById("PTel").value;            //电话号码
    xlsheet.cells(6,25)=document.getElementById("PType").value;         //就诊类型
    xlsheet.cells(7,4)=document.getElementById("PChargeType").value;         //费别
    xlsheet.cells(7,22)=document.getElementById("PAddress").value;          //现住址
    xlsheet.cells(6,11)=document.getElementById("RoomNo").value;         //病房
    xlsheet.cells(6,18)=document.getElementById("BedNo").value;          //床号
    xlsheet.cells(6,4)=document.getElementById("InpoNo").value;          //住院号 InpoNo
    
    
    //申请信息
    xlsheet.cells(9,4)=document.getElementById("AppDep").value;           //申请科室
    xlsheet.cells(9,15)=document.getElementById("AppDoc").value;          //申请医生
    var appdate=document.getElementById("AppDate").value;
    var item=appdate.split("/")
    xlsheet.cells(9,25)=item[2]+"-"+item[1]+"-"+item[0];         //申请日期
    
     if(document.getElementById('Frost').checked)
     {
      xlsheet.cells(9,32)=duihao;   //冰冻信息
      //xlsheet.cells(2,1)="术中冰冻检查申请单";
     }
		
    //alert(item[2]+"-"+item[1]+"-"+item[0]+"="+xlsheet.cells(9,25))
    var GetSpecimensFunc=document.getElementById("autoNumAdd").value
    var info=cspRunServerMethod(GetSpecimensFunc,ttmrowid)
    xlsheet.cells(11,1)=info                                                //标本信息
    
    var appdate=document.getElementById("BiaoBenLiTiDate").value;
    var item=appdate.split("/")
    //alert(appdate+"="+item)
    xlsheet.cells(12,6)=item[2]+"-"+item[1]+"-"+item[0]+" "+document.getElementById("BiaoBenLiTiTime").value //标本离体时间
    
    var appdate=document.getElementById("GuDingDate").value;
    var item=appdate.split("/")
    xlsheet.cells(13,6)=item[2]+"-"+item[1]+"-"+item[0]+" "+document.getElementById("GuDingShiJian").value //开始固定时间
    
    xlsheet.cells(12,15)=document.getElementById("QuCaiLoc").value //取材科室
    xlsheet.cells(12,25)=document.getElementById("QuCaiDoc").value //取材医生
    var appdate=document.getElementById("SendDate").value;
    var item=appdate.split("/")
    xlsheet.cells(13,15)=item[2]+"-"+item[1]+"-"+item[0] //送检日期
    //xlsheet.cells(13,25)=document.getElementById("sdfsd").value  //送检人
    
    xlsheet.cells(15,1)=document.getElementById("ClinicRec1").value;        //临床病历
    xlsheet.cells(17,1)=document.getElementById("JWHistory").value;        //既往病理诊断
    xlsheet.cells(19,1)=document.getElementById("OperationSee").value;      //手术所见
    xlsheet.cells(21,1)=document.getElementById("ClinicDiag").value;      //临床诊断
    //xlsheet.cells(23,13)=document.getElementById("ChuanRanBingShi").value;      //其他传染病史
    var crbs1=""
    var crbs2=""
    var crbs3=""
    var crbs4=""
    var crbs5=""
     if(document.getElementById("HBsAg").checked)
     {   
      crbs1=t['HBsAgyg'] 
     }
     if(document.getElementById("HCV").checked)
     {   
       crbs2=t['HCVbg']
     }
     if(document.getElementById("HIV").checked)
     {   
       crbs3=t['HIVaz']
     }
      if(document.getElementById("othercrbs").checked)
     {   
       crbs4=document.getElementById("ChuanRanBingShi").value
     }
      if(document.getElementById("wucrbs").checked)
     {   
       crbs5=t['wunocrbs']
     }
     xlsheet.cells(23,1)=crbs1+" "+crbs2+" "+crbs3+" "+crbs4+" "+crbs5
    //肿瘤信息
      xlsheet.cells(25,13)=document.getElementById("TumourPosition").value;   //肿瘤部位
      xlsheet.cells(25,21)=document.getElementById("TumourSize").value;   //肿瘤大小
      var tdate=document.getElementById("TumourDate").value;
      if(tdate!="")
      {
      var item=tdate.split("/")
       xlsheet.cells(25,4)=item[2]+"-"+item[1]+"-"+item[0];   //发现日期
      }
      if(document.getElementById("Transfer").checked)   //有无转移)
          xlsheet.cells(25,28)=duihao
      xlsheet.cells(26,4)=document.getElementById("TransPos").value;   //转移部位
      if(document.getElementById("RadioCure").checked)   //曾否放疗
          xlsheet.cells(26,11)=duihao
      if(document.getElementById("ChemicalCure").checked)   //曾否化疗
          xlsheet.cells(26,17)=duihao
      xlsheet.cells(26,23)=document.getElementById("TumourMemo").value;             //备注
      
      //妇科信息
      var tdate=document.getElementById("LastMenstrual").value;
      if(tdate!="")
      {
   var item=tdate.split("/")
       xlsheet.cells(28,4)=item[2]+"-"+item[1]+"-"+item[0];   //上次月经
      }
      var tdate=document.getElementById("LastDate").value;
      if(tdate!="")
      {
   var item=tdate.split("/")
       xlsheet.cells(28,11)=item[2]+"-"+item[1]+"-"+item[0];   //末次月经
      }
    if(document.getElementById("EndDate").checked)   //是否绝经
       xlsheet.cells(28,18)=duihao
    xlsheet.cells(28,24)=document.getElementById("Tai").value;   //胎
    xlsheet.cells(28,27)=document.getElementById("Chan").value;   //产
    
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

function InsertOrder()
{
	var SpeNum=0
	var Objtbl=document.getElementById('t'+tformName)
	var Rows=Objtbl.rows.length
	for(var i=1;i<Rows;i++)
	{
		var SelRowObj3=document.getElementById('TSpeMemoz'+i).innerText
		SelRowObj3=GetStringLastOne(SelRowObj3)
		var SpeNo=SelRowObj3.split("^")[0]
		SpeNum=Number(SpeNum)+Number(SpeNo)	
	}
    var valueObj=0
    var valuegObj=0
    var valuetbObj=0
    var valuepbObj=0
//alert(SpeNum)	
if((SpeNum>="3"))
		{
			var SpeNumtb=3
			var SpeNumg=SpeNum-2  //如果数量少于等于2需要弹出窗口提示还未做
		}
		else
		{
			SpeNumtb=SpeNum
      }
	if((SpeNum!=0)&&(SpeNum!=1))
	{
		SpeNum=SpeNum-1
		//alert(SpeNum+"="+paadmdr+"="+orditemdr+"="+document.getElementById("AppDocDR").value+"="+document.getElementById("AppLocDR").value+"="+recLocDr+"="+SpeNum+"="+document.getElementById("CharegetypeDR").value)
		if (appitmcode!="DBLK000003")
		{ 
		  var InsertBLOrdItemObj=document.getElementById("InsertBLOrdItem").value
		  var valueObj=cspRunServerMethod(InsertBLOrdItemObj,paadmdr,orditemdr,arcimid,document.getElementById("AppDocDR").value,document.getElementById("AppLocDR").value,recLocDr,SpeNum,feibieDr)
      if((valueObj=="-901")||(valueObj=="-902")||(valueObj=="-903")||(valueObj=="-999")||(valueObj=="0"))
		{
				alert(t['OrderFalse'])
		}
    }
    
		if ((appitmcode=="DBLK000003")&&(SpeNum>="2"))
		{  
			var InsertBLOrdItemgObj=document.getElementById("InsertBLOrdItem").value
      //alert(SpeNumg)
		    var valuegObj=cspRunServerMethod(InsertBLOrdItemgObj,paadmdr,orditemdr,arcimid,document.getElementById("AppDocDR").value,document.getElementById("AppLocDR").value,recLocDr,SpeNumg,feibieDr)
       if((valuegObj=="-901")||(valuegObj=="-902")||(valuegObj=="-903")||(valuegObj=="-999")||(valuegObj=="0"))
	   {
				alert(t['OrderFalse'])
		  }
    }
		//alert(ttmrowid+"="+UserId+"="+LocDr+"="+recLocDr+"="+SpeNum+"="+valueObj)
		if (document.getElementById("Frost").checked==true)
		{
			var Getarcimidfo=document.getElementById("GetArcimID").value
  		    var arcimidfo=cspRunServerMethod(Getarcimidfo,arcitemdr2)
  		    var arcimidfogjtx=cspRunServerMethod(Getarcimidfo,arcitemdr3)
  		    if (arcimidfo!="")
	                 {	  
	  	                var arcimidb = arcimidfo
                     }
            if (arcimidfogjtx!="")
	                 {	  
	  	                var arcimidbgjtx = arcimidfogjtx
                     }  
			//if ((arcitemdr2=="DBLK000004")&&(arcitemdr3==""))
			if (arcitemdr2=="DBLK000005")
			{
				var InsertBLOrdItemtbObj=document.getElementById("InsertBLOrdItem").value
		    var valuetbObj=cspRunServerMethod(InsertBLOrdItemtbObj,paadmdr,orditemdr,arcimidb,document.getElementById("AppDocDR").value,document.getElementById("AppLocDR").value,recLocDr,SpeNumtb,feibieDr)	
        }
    var GetPatTypeFun=document.getElementById("GetPatSubType").value
	 	var paadmepistype=cspRunServerMethod(GetPatTypeFun,paadmdr)
	 	if ((arcitemdr2=="DBLK000004")&&(paadmepistype!="8")&&(paadmepistype!="10"))
			{
				var SpeNumpb=1
				var InsertBLOrdItempbObj=document.getElementById("InsertBLOrdItem").value
		        var valuepbObj=cspRunServerMethod(InsertBLOrdItempbObj,paadmdr,orditemdr,arcimidb,document.getElementById("AppDocDR").value,document.getElementById("AppLocDR").value,recLocDr,SpeNumpb,feibieDr)	
        if((valuepbObj=="-901")||(valuepbObj=="-902")||(valuepbObj=="-903")||(valuepbObj=="-999")||(valuepbObj=="0"))
		     {
				alert(t['OrderFalse'])
				return;
		     }
				}                
       if (((arcitemdr2=="DBLK000004")&&(appitmcode!="DBLK000003")&&((paadmepistype=="8")||(paadmepistype=="10"))))
			{
				var InsertBLOrdItemtbObj=document.getElementById("InsertBLOrdItem").value
		    var valuetbObj=cspRunServerMethod(InsertBLOrdItemtbObj,paadmdr,orditemdr,arcimidb,document.getElementById("AppDocDR").value,document.getElementById("AppLocDR").value,recLocDr,SpeNumtb,feibieDr)	
        }	
			if (((appitmcode=="DBLK000003")&&((paadmepistype=="8")||(paadmepistype=="10"))))
			{
				var InsertBLOrdItemtbObj=document.getElementById("InsertBLOrdItem").value
		    var valuetbObj=cspRunServerMethod(InsertBLOrdItemtbObj,paadmdr,orditemdr,arcimidbgjtx,document.getElementById("AppDocDR").value,document.getElementById("AppLocDR").value,recLocDr,SpeNumtb,feibieDr)	
        }			
			}
	}
    var SQDPriceFun=document.getElementById("SQDPrice").value
    var SQDPrice=cspRunServerMethod(SQDPriceFun,orditemdr)
    var SQDZPrice=parseFloat(SQDPrice)+parseFloat(valueObj)+parseFloat(valuegObj)+parseFloat(valuetbObj)+parseFloat(valuepbObj)
    var TotalPriceInfo=document.getElementById("UpdateTotalPrice").value
    var TotalPrice=cspRunServerMethod(TotalPriceInfo,SQDZPrice,ttmrowid)
}

function StopOrder()
{
	var StopBLOrdItem=document.getElementById("StopBLOrdItem").value
	var valueObj=cspRunServerMethod(StopBLOrdItem,orditemdr,document.getElementById("AppDocDR").value)
	//alert(orditemdr+"="+document.getElementById("AppDocDR").value+"="+valueObj)
	if(valueObj!="0" && valueObj!="")
	{
		alert(t['StopBLOrdItem'])
	}
}

function strlen(str) 
{   
    var len = 0;   
    for (var i = 0; i < str.length; i++) 
    {   
        if (str.charCodeAt(i) > 255) 
        {
	        len += 2;
        }
    }   
    return len;   
}          
document.body.onload = BodyLoadHandler