//DHCPisAppAutopsy.js ��̳ʬ������

var bNewPatient = 1
var tstatuscode=0
var ttmrowid=""
var paadmdr=""
var orditemdr=""
var tclsdr=""
var tclscode="4"

var tformName=document.getElementById("TFORM").value; 
var getComponentIdByName=document.getElementById("GetComponentIdByName").value; 
var componentId; 
componentId=cspRunServerMethod(getComponentIdByName,tformName);

function BodyLoadHandler()
 {
	 /*
	//for debug
    var ordItemDr=document.getElementById("OEorditemID").value
	if (ordItemDr=="") ordItemDr="241||14"
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
    
    /*
    var POrditemDR=document.getElementById("POrditemDR")
    if(POrditemDR)
    {
	    var orditem=orditemdr.split("||")
	    POrditemDR.value="*"+orditem[0]+"-"+orditem[1]+"*"
    }
    */
    
    var ComName=document.getElementById("ComponentName")
    if(ComName)
    {
	    ComName.value="DHCPisAppAutopsy"
    }

    var AppDateObj=document.getElementById("AppDate")
    if (AppDateObj.value=="")
    	AppDateObj.value=DateDemo()
        
    var SendSheetObj=document.getElementById("SendApp")
	if (SendSheetObj)
	{
	 	SendSheetObj.onclick=SendAppClick
	}
	
    var PrintSheetObj=document.getElementById("PrintApp")
	if (PrintSheetObj)
	{
		PrintSheetObj.onclick=PrintAppClick
	}
	
  	var CancelSheetObj=document.getElementById("CancelApp")
	if (CancelSheetObj)
	{
		CancelSheetObj.onclick=CancelAppClick
	}

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
		ttmrowid = TMROWID;
		document.getElementById("TMRowid").value = TMROWID

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
	GetAutopsyInfo()
 }
 
 function GetPatInfo()
 {
	if(bNewPatient==1)
	{
		var GetPaadmInfoFun=document.getElementById("PatInfo").value
  		var PATINFO=cspRunServerMethod(GetPaadmInfoFun,paadmdr)
    	if (PATINFO!="")
		{   
			
			var item=PATINFO.split("^")
			//RegNo,Name,strDOB,strAge,$g(SexDesc),patienttype,typedesc 7
			//$g(LocName),IPNO,wardname,bedname,$g(Locdr),SexDr,WardDr, 14
			//roomdesc,feetype,Docdr,DocName,Telphone,Height,Weight, 21
			//address,SEXDR,feetypedr 24
			//alert(item[23])
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
			
			//document.getElementById("PType").value=item[6]
			document.getElementById("AdmtypeDR").value=item[5]
			
			//document.getElementById("PChargeType").value=item[15]
			//document.getElementById("CharegetypeDR").value=item[23]
			
			document.getElementById("InpoNo").value=item[8]
			document.getElementById("RoomNo").value=item[9]
			document.getElementById("BedNo").value=item[10]
			var item7=item[7].split("-")
			document.getElementById("AppLoc").value=item7[1]
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
			var ChangDFun=document.getElementById("DateChange3to4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("PBirthday").value=vdate4
			//document.getElementById("Age").value=""
			
			var titem1=item[3].split("~")
			document.getElementById("PSex").value=titem1[1]
			document.getElementById("SexDr").value=titem1[0]
			
			//document.getElementById("PTel").value=item[8]
			document.getElementById("PAddress").value=item[7]
			
			var titem2=item[5].split("~")
			//document.getElementById("PType").value=titem2[1]
			document.getElementById("AdmtypeDR").value=titem2[0]
			
			//var titem3=item[6].split("~")
			//document.getElementById("PChargeType").value=titem3[1]
			//document.getElementById("CharegetypeDR").value=titem3[0]
			
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
  		//alert(value)
    	document.getElementById("LastClinicRecord").value=value//����ٴ����
  		
		var GetOrdInfoFun=document.getElementById("OrderInfo").value
  		var ORDERINFO=cspRunServerMethod(GetOrdInfoFun,orditemdr)
  		//alert(ORDERINFO)
    	if (ORDERINFO!="")
		{   
			var item=ORDERINFO.split("^")
			//arcimid,strOrderName,strDate,strTime,requestdoc,ssusrdr, 6
			//strAccessionNum,SGroupDesc,subCatDesc,CatDesc,ifbed,price 12
			//Num,TotalPrice,billed,$g(ItemStatusCode),$g(ServerMaterial) 17
			//RecLocdr,$g(ResultFlag),strCommon,RecLocDesc 21
			document.getElementById("GetOEorditemName").value=item[1]
			//alert(document.getElementById("GetOEorditemName").value)
			document.getElementById("AppDoc").value=item[4]
			document.getElementById("AppDocDR").value=item[5]
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
			
    		document.getElementById("ClinicRecord").value=item[1]//�ٴ�����鼰������
    		document.getElementById("OldDiagnosis").value=item[2]//��ʷ�����ƹ���
    		document.getElementById("LastClinicRecord").value=item[5]//����ٴ����
    		document.getElementById("AppLoc").value=item[7]
        	document.getElementById("AppLocDR").value=item[6]
		
			document.getElementById("AppDoc").value=item[11]
			document.getElementById("AppDocDR").value=item[10]
			
			var vdate3=item[8]
			var ChangDFun=document.getElementById("DateChange3to4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("AppDate").value=vdate4
		}
	}
 }
 
 function GetAutopsyInfo()
 {
     //Get patient consult information
	 var GetAshInfo=document.getElementById("AshesInfo")
     if (GetAshInfo)
     {
         var returnAshInfoVal=""
         var enmeth=GetAshInfo.value
         var returnAshInfoVal=cspRunServerMethod(enmeth,ttmrowid)
         //alert(cspRunServerMethod(enmeth,619))
         if (returnAshInfoVal!="")
	     {  
	     	var item=returnAshInfoVal.split("^")
	     	var vdate3=item[0]//;alert(item[7]+"="+item[8]+"="+item[9]+"="+ttmrowid)
			var ChangDFun=document.getElementById("DateChange3to4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("HospitalizeDate").value=vdate4//סԺ����
	     	document.getElementById("HospitalizeTime").value=item[1]//סԺʱ��
	     	var vdate3=item[4]
	     	var ChangDFun=document.getElementById("DateChange3to4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("DeathDate").value=vdate4//��������
			document.getElementById("DeathTime").value=item[5]//����ʱ��
			item6=item[6].split("~")
			document.getElementById("STDispose").value=item6[0]//���ʺ���
			document.getElementById("AllOrPart").value=item6[1]//���ʷ�Χ ��λ?ȫ��?
			var vdate3=item[10]
			var ChangDFun=document.getElementById("DateChange3to4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("SignatureDate").value=vdate4//ǩ������
			document.getElementById("PTel").value=item[11]//�绰����
			document.getElementById("Relation").value=item[8]//ί���������߹�ϵ
			document.getElementById("FimalyAddress").value=item[9]//ί������ϸ��ַ
			document.getElementById("FimalyName").value=item[7]//ί��������
	     }   
    }
     
    if(bNewPatient==1)
    {
		document.getElementById("LastClinicRecord").disabled=false
		document.getElementById("Relation").disabled=false
		document.getElementById("FimalyName").disabled=false
		document.getElementById("FimalyAddress").disabled=false
		document.getElementById("DeathTime").disabled=false
		document.getElementById("DeathDate").disabled=false
		document.getElementById("AllOrPart").disabled=false
		document.getElementById("HospitalizeTime").disabled=false
		document.getElementById("HospitalizeDate").disabled=false
		document.getElementById("SignatureDate").disabled=false
		document.getElementById("ClinicRecord").disabled=false
		document.getElementById("PTel").disabled=false
		document.getElementById("STDispose").disabled=false
		document.getElementById("PAddress").disabled=false
		document.getElementById("OldDiagnosis").disabled=false
    }
    else
    {
		document.getElementById("LastClinicRecord").disabled=true
		document.getElementById("Relation").disabled=true
		document.getElementById("FimalyName").disabled=true
		document.getElementById("FimalyAddress").disabled=true
		document.getElementById("DeathTime").disabled=true
		document.getElementById("DeathDate").disabled=true
		document.getElementById("AllOrPart").disabled=true
		document.getElementById("HospitalizeTime").disabled=true
		document.getElementById("HospitalizeDate").disabled=true
		document.getElementById("SignatureDate").disabled=true
		document.getElementById("ClinicRecord").disabled=true
		document.getElementById("PTel").disabled=true
		document.getElementById("STDispose").disabled=true
		document.getElementById("PAddress").disabled=true
		document.getElementById("OldDiagnosis").disabled=true
    }
 }

 function SendAppClick()
 { 
    if (ttmrowid=="")
    {
	   alert(t['NOTNULL'])
	   return
    }

    SetPatInfo()
    SetAppInfo()
    SetAutopsyInfo()
    SetAppStatus()
    Refresh()
   // CommonPrint(t['PRINTSHAPE'])

 }
 
 //��Ӳ�����Ϣ��master��
 function SetPatInfo()
 {
 	if(bNewPatient==1)
	{
		 var patinfo=""
		 
		 var ndob=document.getElementById('PBirthday').value
		 var ChangDFun=document.getElementById("DateChange4to3").value
		 var vdate3=cspRunServerMethod(ChangDFun,ndob)

		 patinfo+=paadmdr+"^^"
		 //patinfo+=document.getElementById('AdmtypeDR').value+"^"//��������?סԺ?��Ժ?����?���?
		 patinfo+=document.getElementById('PName').value+"^^^"//�����������ĺ���ƴ��
		 //patinfo+=document.getElementById('CharegetypeDR').value+"^"//�ѱ�
		 patinfo+=document.getElementById('SexDr').value+"^"//�Ա�DR
		 patinfo+=vdate3+"^"//��������
		 patinfo+=document.getElementById('PAddress').value+"^"//סַ
		 patinfo+=document.getElementById('RegNo').value+"^"//�ǼǺ�
		 patinfo+=document.getElementById('InpoNo').value+"^"//סԺ��
		 patinfo+=document.getElementById('RoomNo').value+"^"//������
		 patinfo+=document.getElementById('BedNo').value+"^"//����
		 patinfo+=document.getElementById('PTel').value+"^"//�绰����
		 
	     var SetPatInfoFun=document.getElementById("AddPatInfo").value
   	     var PATCODE=cspRunServerMethod(SetPatInfoFun,patinfo,ttmrowid)
  	   	 if (PATCODE!="0")
  	   	 {
	  	   	alert['UpdatePatFailure']
	  	   	return
  	   	 }
	 }	 
 }
 
 //���������Ϣ��master��
 function SetAppInfo()
 {
	 if(bNewPatient==1)
	 {
		 var appinfo=""
		 var tbingdong="0"
		 
		 appinfo+=document.getElementById('ClinicRecord').value+"^"//��ʷ�����ƹ���
		 appinfo+=document.getElementById('OldDiagnosis').value+"^^^"//�ٴ���켰������
		 appinfo+=document.getElementById('LastClinicRecord').value+"^"//����ٴ����
		 appinfo+=tbingdong+"^^^"
		 appinfo+=document.getElementById('AppLoc').value+"^"
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
 
 //ʬ��������Ϣ DHCPIS_TEST_ASHES
 function SetAutopsyInfo()
 {
	 if(bNewPatient==1)
	 {
		var ihdate=document.getElementById("HospitalizeDate").value//סԺ����
		var ihtime=document.getElementById("HospitalizeTime").value//סԺʱ��
		var deathdate=document.getElementById("DeathDate").value//��������
		var deathtime=document.getElementById("DeathTime").value//����ʱ��
		var jiepouhouchuli=document.getElementById("STDispose").value//���ʺ���
		var jiepoufanwei=document.getElementById("AllOrPart").value//���ʷ�Χ ��λ?ȫ��?
		var jiepou=jiepouhouchuli+"~"+jiepoufanwei//���һ���ֶδ���ta_sib_notion�ֶ�
		var qianzidate=document.getElementById("SignatureDate").value//ǩ������
		var tel=document.getElementById("PTel").value//�绰����
		var guanxi=document.getElementById("Relation").value//ί���������߹�ϵ
		var xiangxidizhi=document.getElementById("FimalyAddress").value//ί������ϸ��ַ
		var fimalyname=document.getElementById("FimalyName").value//ί��������
		var ChangDFun=document.getElementById("DateChange4to3").value
		ihdate=cspRunServerMethod(ChangDFun,ihdate)
		deathdate=cspRunServerMethod(ChangDFun,deathdate)
		qianzidate=cspRunServerMethod(ChangDFun,qianzidate)
	   	var AddAshesInfo=ihdate+"^"+ihtime+"^^^"+deathdate+"^"+
		      deathtime+"^"+jiepou+"^"+fimalyname+"^"+guanxi+"^"+
		      xiangxidizhi+"^"+qianzidate+"^"+tel
       	//alert(AddAshesInfo)	
       	var GetAddAshesInfo=document.getElementById("AddAshesInfo")
       	if (GetAddAshesInfo)
       	{  
          	var reAddAshesInfo=""
          	var enmeth=GetAddAshesInfo.value;
          	var reAddAshesInfo=cspRunServerMethod(enmeth,ttmrowid)
          	if (reAddAshesInfo.split("-")[0]=="") //Such as return -901,-915 or other SQL error,which is initial with "-".
          	{
 	        	alert(t['UpdateECFailure'])
 	        	return;
 	      	}	
 	      	document.getElementById("ASHESRowId").value=reAddAshesInfo
 	      		
 	      	var ecrowid=reAddAshesInfo
	       	var GetUpAshInfo=document.getElementById("UpdateAshesInfo")
       		if (GetUpAshInfo)
       		{ 
          		var reUpAppshInfo=""
          		var enmeth=GetUpAshInfo.value
          		var RESSQLCODE=cspRunServerMethod(enmeth,AddAshesInfo,ecrowid)
         		if (RESSQLCODE!="0") 
          		{
 	        		alert(t['UpdateECFailure'])
 	        		return;
 	      		}
       		}
       	}		        	
	 }
	DisableById(componentId,"STDispose")
  	DisableById(componentId,"AllOrPart")
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
 function CancelAppClick()
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
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+ComponentName
    lnk+="&EpisodeID="+Eposide
    lnk+="&OEorditemID="+OEorditemID
    lnk+="&TMrowid="+TMrowid
    lnk+="&ComponentName="+ComponentName;
    location.href=lnk
 }
 
 function Clear()
 {
 	//alert("clear");
 	var ComponentName=document.getElementById("ComponentName").value;  //"DHCRisApplicationBill"
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+ComponentName+"&EpisodeID="+""+"&OEorditemID="+""+"&TMrowid="+""+"&ComponentName="+ComponentName;
    location.href=lnk; 
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

function PrintAppClick()
{   if(document.getElementById("PrintApp").disabled==true)
 		return
	CommonPrint(t['PRINTSHAPE'])
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

document.body.onload = BodyLoadHandler;