var EpisodeID=document.getElementById("EpisodeID").value
var Line="--------------------------------------------"
var Objtbl=document.getElementById('tDHCDocTransFusion');
var sum=1;
var OeoriId,SeqNo,ArcimDesc,DoseQtyUnit,PhcfrCode,PhcinDesc,DisposeStatCode,Durat,Note,MyList,Rows,OeoriId,PhysicTitle,LineNo,n,Str=""
var PrintArray=new Array();
var PageCount=0;myobj="";MyPara="";MyList="";
var PrintList=new Array();
var LocArry=new Array();
var HosNameType=""
var damp=0;
function BodyLoadHandler()
{
	if (EpisodeID!=""){    
		var getRegNoFromAdm1=document.getElementById("getRegNoFromAdm").value;
		var retStr=cspRunServerMethod(getRegNoFromAdm1,EpisodeID);
		document.getElementById("regNo").value=retStr;
	}
	var GetUserGroupAccess=document.getElementById("GetUserGroupAccess").value;
	var userId=session['LOGON.USERID'];
	var usr=document.getElementById("userId");
	if (usr) usr.value=userId;
	var userGroupId=session['LOGON.GROUPID']  
	document.getElementById("userId").value=userGroupId;
    var objUserGroup=document.getElementById("userGroupId");
	if (objUserGroup) objUserGroup.value=userGroupId;
	var retStr=cspRunServerMethod(GetUserGroupAccess,userGroupId,userId);
    if (retStr!='!!'){
    	var tem=retStr.split("!");
    	var temp=tem[0].split("^");
        if (tem[1]!="")
    	{
    		var objReportType=document.getElementById("SelectType");
    		objReportType.value=temp[1];
			var obj=document.getElementById("SelectType");
			if (obj) {
				obj.size=1;
				obj.multiple=false;
				var NewIndex=obj.length;
				for (indexAdd=0;indexAdd<retStr.split("^").length;indexAdd++){
			         obj.options[indexAdd]=new Option(temp[indexAdd].split("|")[1],temp[indexAdd].split("|")[0]);
		        }
	       	}
    	}
  	}else {
	  	var obj=document.getElementById("SelectType");
  	    obj.size=1;
  	    obj.multiple=false;
  	}
	var obj=document.getElementById("Search");
	if (obj) obj.onclick=Search_click1;
	var obj=document.getElementById("PrintTransFusion");
	if (obj) obj.onclick=TransFusion_Print;
	var obj=document.getElementById("SelectType");
	if (obj) obj.onchange=SelectType_Change;
	var obj=document.getElementById("tDHCDocTransFusion");
	if (obj) obj.onclick=GroupSelect_onclick
	LineNo=1;
	DHCP_GetXMLConfig("XMLObject","DHCDocTransFusion");    
	var obj=document.getElementById("SelectLoc");
	if (obj) obj.onclick=SelectLoc_onclick;
	
	var Obj=document.getElementById("queryTypeCode");
	if (Obj.value==""){
		var ObjSelectType=document.getElementById("SelectType")
		if (ObjSelectType){Obj.value=ObjSelectType.value}
		}
	
	var HospitalRowid="";
	var TypeCode="";
	var queryTypeCodeStr=document.getElementById("queryTypeCode").value;
	if (queryTypeCodeStr.indexOf('@')!='-1'){
		var queryTypeCodearr=queryTypeCodeStr.split("@");
		HospitalRowid=queryTypeCodearr[0];
		TypeCode=queryTypeCodearr[1];
	}
	else{
		TypeCode=queryTypeCodeStr
	}
	var Obj=document.getElementById("SelectType")
	if (Obj){
		if (TypeCode!=""){
			var SelectTypelength=Obj.length;
			for (var i=0;i<SelectTypelength;i++)
			{
				var ValueSub=Obj.options[i].value;
				if (ValueSub.indexOf(TypeCode)>=0)
				{
					Obj.options[i].selected=true
				}
				else{
					Obj.options[i].selected=false
					}
			}
		}
	}
	//getLastType(); //lxz 不清楚为什么要掉用后台方法

}
function saveLastType(selIndex){
	var killRet=tkMakeServerCall('web.DHCDocTransFusion','killTemptype');
	var saveRet=tkMakeServerCall('web.DHCDocTransFusion','saveTemptype',selIndex);
}
function getLastType(){
	var Index=tkMakeServerCall('web.DHCDocTransFusion','getTemptype');
	var reSet=document.getElementById("SelectType");
	reSet.selectedIndex=Index;
	var killRet=tkMakeServerCall('web.DHCDocTransFusion','killTemptype');
}
function SelectType_Change() {
	var SelectTypeList=document.getElementById("SelectType");
	var selIndex=SelectTypeList.selectedIndex;
	if (selIndex==-1) return;
	if (SelectTypeList=="") return;
	var SelectTypeListValue=SelectTypeList.options[selIndex].value;
	document.getElementById("queryTypeCode").value=SelectTypeListValue;
	var obj=document.getElementById("EpisodeID");
	if (obj) var EpisodeID=obj.value;
	saveLastType(selIndex);
	Search_click(); 
}

function FindSelectTypeItems(EpisodeID,SelectTypeListValue) {
	
	var GetPrescItems=document.getElementById('GetPrescItems');
	if (GetPrescItems) {var encmeth=GetPrescItems.value;} else {var encmeth=''};
	if (encmeth!="") {
		if (cspRunServerMethod(encmeth,'QueryDetail',EpisodeID,PrescNo)=='0') {
			obj.className='';
			
		}
		LoopCount=1;
	}
}

function SetSelectType(text,value) {
	var obj=document.getElementById("SelectType");
	if (obj){
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option(text,value);
 	}
}

function TransFusion_Print(){
	var HosNameType="";
	var queryTypeCodearr="";
	var HospitalRowid="";
	var queryTypeCode="";
	var queryTypeCodeStr=document.getElementById("queryTypeCode").value;
	if (queryTypeCodeStr.indexOf('@')!='-1'){
		queryTypeCodearr=queryTypeCodeStr.split("@");
		HospitalRowid=queryTypeCodearr[0];
		queryTypeCode=queryTypeCodearr[1];
		if (queryTypeCode=="FLDO"){ExecPrintNew();return;}
		if (queryTypeCode=="ZLDO"){ExecPrintNew();return;}
	}else{
		if (queryTypeCodeStr=="FLDO"){ExecPrintNew();return;}
		if (queryTypeCodeStr=="ZLDO"){ExecPrintNew();return;}
	}

	LineNo=1;
	var DiagnoseOffice,PrintTime,Str,CTLOCID,CTLOCName,DoctorName="";
	var RegNo,PName,Sex,Age,CaseHistoryNo,MedicareType,Address,Company=""; 
	var CTLOCID=session['LOGON.CTLOCID']
	var DoctorName=session['LOGON.USERNAME']
	var GetPatientInfoAc=document.getElementById('GetPatientInfo');
	if (GetPatientInfoAc) {var encmeth=GetPatientInfoAc.value;} else {var encmeth=''};
	if (encmeth!="") {
		PatientInfo=cspRunServerMethod(encmeth,EpisodeID,CTLOCID);
		//alert(PatientInfo)
		if (PatientInfo!=""){
			 RegNo=PatientInfo.split("^")[1];
			 PName=PatientInfo.split("^")[2];
			 Sex=PatientInfo.split("^")[3];
			 Age=PatientInfo.split("^")[4];
			 Address=PatientInfo.split("^")[10];
			 var Medcare=PatientInfo.split("^")[18];
			 MedicareType=PatientInfo.split("^")[6];
			 Company=PatientInfo.split("^")[14];
			 var MrNoE=PatientInfo.split("^")[31]
			 CTLOCName=PatientInfo.split("^")[32];
			 PrintTime=PatientInfo.split("^")[33];
			 var GovernCardNo=PatientInfo.split("^")[23];
			 var PAADMType=PatientInfo.split("^")[34];
			 var AdmReasonStr=PatientInfo.split("^")[35];
			 if (PAADMType=="O"){CaseHistoryNo=GovernCardNo}
			 else if (PAADMType=="E"){CaseHistoryNo=MrNoE}
			 else if (PAADMType=="I"){CaseHistoryNo=Medcare}
			 var CardNo=PatientInfo.split("^")[29];
			 var HospName=PatientInfo.split("^")[37];
		}
	}
	
	Objtbl=document.getElementById('tDHCDocTransFusion');
	Rows=Objtbl.rows.length;
	MyList=String.fromCharCode(2)+"";//HosNameType
	//alert(document.getElementById('queryTypeCode').value)
	
	if (queryTypeCodeStr.indexOf('@')!='-1'){
		queryTypeCodearr=queryTypeCodeStr.split("@");
		HospitalRowid=queryTypeCodearr[0];
		queryTypeCode=queryTypeCodearr[1];
		if (queryTypeCode=="SYDO"){HosNameType="输液单"};
		if (queryTypeCode=="ZSDO"){HosNameType="注射单"};
		if (queryTypeCode=="ZLDO"){HosNameType="治疗单"};
		if (queryTypeCode=="FLDO"){HosNameType="放疗收费单"};
	}else{
		if (queryTypeCodeStr=="SYDO"){HosNameType="输液单"};
		if (queryTypeCodeStr=="ZSDO"){HosNameType="注射单"};
		if (queryTypeCodeStr=="ZLDO"){HosNameType="治疗单"};
		if (queryTypeCodeStr=="FLDO"){HosNameType="放疗收费单"};
	}

	Line1="";
	Line1=Line+"第"+LineNo+"组"+Line;
	MyList=MyList+String.fromCharCode(2)+Line1;
	PageCount=PageCount+1;
	if (PageCount==18){pagination();}
	//alert(PageCount+"$"+MyList);
	
	for (n=1;n<Rows;n++){
		if (document.getElementById('GroupSelectz'+n).checked==true)
		{GetInfo(n);}
  	}                       
	var MyPara="";
    //MyPara="RegNo"+String.fromCharCode(2)+RegNo;
    MyPara="RegNo"+String.fromCharCode(2)+CardNo;
    MyPara=MyPara+"^PName"+String.fromCharCode(2)+PName;
    MyPara=MyPara+"^HosNameType"+String.fromCharCode(2)+HosNameType;
    MyPara=MyPara+"^Sex"+String.fromCharCode(2)+Sex;
    MyPara=MyPara+"^Age"+String.fromCharCode(2)+Age;
    MyPara=MyPara+"^CaseHistoryNo"+String.fromCharCode(2)+CaseHistoryNo;
    MyPara=MyPara+"^MedicareType"+String.fromCharCode(2)+MedicareType;
    MyPara=MyPara+"^Address"+String.fromCharCode(2)+Address;
    MyPara=MyPara+"^Company"+String.fromCharCode(2)+Company;
    MyPara=MyPara+"^CTLOCName"+String.fromCharCode(2)+CTLOCName;
    MyPara=MyPara+"^PrintTime"+String.fromCharCode(2)+PrintTime;
    MyPara=MyPara+"^DoctorName"+String.fromCharCode(2)+DoctorName;
    MyPara=MyPara+"^HosName"+String.fromCharCode(2)+HospName;  
    var myobj=document.getElementById("ClsBillPrint");
	PrintFun(myobj,MyPara,MyList);	
	sum=1;
	MyList="";PageCount=0;
}
	
function PrintFun(PObj,inpara,inlist){
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false;   
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}
}

function DayOfWeek(val){
    var ShowDate=new Date(val.split("-")[0],val.split("-")[1]-1,val.split("-")[2]);
    if(ShowDate.getDay()==0){ Ac="(日)"};
    if(ShowDate.getDay()==1){ Ac="(一)"};
    if(ShowDate.getDay()==2){ Ac="(二)"};
    if(ShowDate.getDay()==3){ Ac="(三)"};
    if(ShowDate.getDay()==4){ Ac="(四)"};
    if(ShowDate.getDay()==5){ Ac="(五)"};
    if(ShowDate.getDay()==6){ Ac="(六)"};
}
function GetInfo(n){
	  var OeoriId=document.getElementById('oeoriIdz'+n).value;
		var ArcimDesc=document.getElementById('arcimDescz'+n).innerText; 
		var DoseQtyUnit=document.getElementById('doseQtyUnitz'+n).innerText; 
		var PhcfrCode=document.getElementById('phcfrCodez'+n).innerText;
		var PhcinDesc=document.getElementById('phcinDescz'+n).innerText; 
		var notes=document.getElementById('notesz'+n).innerText;
		//var DisposeStatCode=document.getElementById('disposeStatCodez'+n).innerText;
		var Durat=document.getElementById('Duratz'+n).innerText;
		var PlanSumRow=document.getElementById('phOrdQtyUnitz'+n).innerText;
		var GetPlanSumAc=document.getElementById('GetPlanSum').value;
		if (ArcimDesc.indexOf('____')!='-1'){
			DoseQtyUnit="";
			PhcfrCode="";
			PhcinDesc="";
			notes="";
			Durat="";
			//GetPlanSumAc="";
		}
		
		
	    if (GetPlanSumAc) {var encmeth=GetPlanSumAc.value} else {var encmeth=''};
	    if (encmeth!="") {
	   	     var PlanSum=cspRunServerMethod(GetPlanSumAc,OeoriId);
	    };
		if (+PlanSum==0) PlanSum=+PlanSumRow.replace(/[^0-9]/ig,""); 
		var GetGroupAc=document.getElementById('GetGroup');
	    if (GetGroupAc) {var encmeth=GetGroupAc.value;} else {var encmeth=''};
        if ((n+1)<Rows) {
             var OeoriIdNext=document.getElementById('oeoriIdz'+(n+1)).value;
             GetGroupInfo=cspRunServerMethod(encmeth,OeoriIdNext);
		}
		if ((n+1)==Rows){
	         var OeoriId=document.getElementById('oeoriIdz'+n).value;
	         GetGroupInfo=cspRunServerMethod(encmeth,OeoriId);
	         if (GetGroupInfo=="0"){var GetGroupInfo="1" };
	         if (GetGroupInfo=="1"){var GetGroupInfo="0" };
			             
		}
		if (GetGroupInfo=="0"){
             Note=ArcimDesc+"/"+DoseQtyUnit+" "+PhcfrCode+" "+PhcinDesc+" "+notes+" "+PlanSum+"次";
             MyList=MyList+String.fromCharCode(2)+Note;
             PageCount=PageCount+1;
             if (PageCount==18){pagination();}
             StrSplit(OeoriId);
             LineNo=LineNo+1;
             Line1="";
             Line1=Line+"第"+LineNo+"组"+Line;
             if (n==Rows-1){Line1=""};
             for (k=n;k<Rows;k++){
             if (document.getElementById('GroupSelectz'+k).checked==false){Line1=""}};
             if (PageCount==18){pagination();};
             if (n<(Rows-1)){
             	if (document.getElementById('GroupSelectz'+(n+1)).checked==true){
 		                var GetNextGroupCount=document.getElementById('GetNextGroupCount');
 		              	if (GetNextGroupCount) {
     		              	var encmeth=GetNextGroupCount.value;
 		              	    GetNextGroupCountinfo=cspRunServerMethod(encmeth,document.getElementById('oeoriIdz'+(n+1)).value);	 
                            var execsplit=(GetNextGroupCountinfo.split("^")[1])%5;
                            if  (execsplit==0){execsplitnumber=(GetNextGroupCountinfo.split("^")[1])/5}              		              		
 		              	    if  (execsplit!=0){execsplitnumber=((GetNextGroupCountinfo.split("^")[1])-execsplit)/5+1}	
 		              	    execsplitnumber=Number(execsplitnumber)+Number((GetNextGroupCountinfo.split("^")[0]))+1;
 		              	    if ((execsplitnumber+PageCount)>=18){
 		              		    for (i=1;i<=(18-PageCount);i++){
 		              		  	   MyList=MyList+String.fromCharCode(2)+" ";
 		              		  	 
 		              		     };
 		              		     pagination();
 		              		 };
 		            	}	                 		
             	   }
             	  		                 			                 	
             }
             MyList=MyList+String.fromCharCode(2)+Line1;
             PageCount=PageCount+1;
             sum=1;
		}else{
			Note=ArcimDesc+"/"+DoseQtyUnit+" "+PhcfrCode+" "+PhcinDesc+" "+notes+" "+PlanSum+"次";
			MyList=MyList+String.fromCharCode(2)+Note;
			PageCount=PageCount+1;
			if (PageCount==18){pagination();};
			sum=1;             	    
	    }
}

function StrSplit(OeoriId){
	    
	    var Str="";
	    var Execobj=document.getElementById('GetExecPlan');
			if (Execobj==""){return;} 
			else {
				obj=cspRunServerMethod(Execobj.value,OeoriId)
				i=obj.split("#").length
				for (x=0;x<i-1;x++){
					     objDate=obj.split("#")[x];
				       DayOfWeek(objDate.split("^")[1]);
				       Str=Str+objDate.split("^")[0]+Ac+" "+"          ";
				       sum=sum+1;
				       if (sum>=6) {
					                  sum=1;
					                  MyList=MyList+String.fromCharCode(2)+Str;
					                  PageCount=PageCount+1;
					                  if (PageCount==18){pagination();};
					                  Str="";}
				                    }
				       if (Str!=""){MyList=MyList+String.fromCharCode(2)+Str;
				       	            PageCount=PageCount+1;
					                  if (PageCount==18){pagination();};
				       	            }
     	}	   
}

function changeDisplay()
{
	var queryTypeCode=document.getElementById('queryTypeCode').value;}

function Search_click1()
{
	return Search_click();
}
	
function GroupSelect_onclick()
{
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tDHCDocTransFusion');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
    var SelRowObj=document.getElementById('GroupSelectz'+selectrow).checked;
	var OeordId=document.getElementById('oeoriIdz'+selectrow).value;
	var OEORIDR=document.getElementById('OEORIDRz'+selectrow).value;
	 
	for (var i=1;i<Rows;i++)
	{
		
		if (document.getElementById('OEORIDRz'+i).value==document.getElementById('OEORIDRz'+selectrow).value)
		{
			document.getElementById('GroupSelectz'+i).checked=document.getElementById('GroupSelectz'+selectrow).checked;
			}
		
		}
		 
	
	}

function pagination(){
	  var myobj=document.getElementById("ClsBillPrint");
if (MyPara==""){
	  var DiagnoseOffice,PrintTime,Str,CTLOCID,CTLOCName,DoctorName="";
	  var RegNo,PName,Sex,Age,CaseHistoryNo,MedicareType,Address,Company=""; 
	  var CTLOCID=session['LOGON.CTLOCID']
	  var DoctorName=session['LOGON.USERNAME']
	  var GetPatientInfoAc=document.getElementById('GetPatientInfo');
	  if (GetPatientInfoAc) {var encmeth=GetPatientInfoAc.value;} else {var encmeth=''};
	  if (encmeth!="") {
		PatientInfo=cspRunServerMethod(encmeth,EpisodeID,CTLOCID);
		//alert(PatientInfo);
		if (PatientInfo!=""){
			 RegNo=PatientInfo.split("^")[1];
			 PName=PatientInfo.split("^")[2];
			 Sex=PatientInfo.split("^")[3];
			 Age=PatientInfo.split("^")[4];
			 Address=PatientInfo.split("^")[10];
			 var Medcare=PatientInfo.split("^")[18];
			 MedicareType=PatientInfo.split("^")[6];
			 Company=PatientInfo.split("^")[14];
			 var MrNoE=PatientInfo.split("^")[31]
			 CTLOCName=PatientInfo.split("^")[32];
			 PrintTime=PatientInfo.split("^")[33];
			 var GovernCardNo=PatientInfo.split("^")[23];
			 var PAADMType=PatientInfo.split("^")[34];
			 var AdmReasonStr=PatientInfo.split("^")[35];
			 if (PAADMType=="O"){CaseHistoryNo=GovernCardNo}
			 else if (PAADMType=="E"){CaseHistoryNo=MrNoE}
			 else if (PAADMType=="I"){CaseHistoryNo=Medcare}          
			                 }
	                 }
	    MyPara="RegNo"+String.fromCharCode(2)+RegNo;
	    MyPara=MyPara+"^PName"+String.fromCharCode(2)+PName;
	    MyPara=MyPara+"^HosNameType"+String.fromCharCode(2)+HosNameType;
	    MyPara=MyPara+"^Sex"+String.fromCharCode(2)+Sex;
	    MyPara=MyPara+"^Age"+String.fromCharCode(2)+Age;
	    MyPara=MyPara+"^CaseHistoryNo"+String.fromCharCode(2)+CaseHistoryNo;
	    MyPara=MyPara+"^MedicareType"+String.fromCharCode(2)+MedicareType;
	    MyPara=MyPara+"^Address"+String.fromCharCode(2)+Address;
	    MyPara=MyPara+"^Company"+String.fromCharCode(2)+Company;
	    MyPara=MyPara+"^CTLOCName"+String.fromCharCode(2)+CTLOCName;
	    MyPara=MyPara+"^PrintTime"+String.fromCharCode(2)+PrintTime;
	    MyPara=MyPara+"^DoctorName"+String.fromCharCode(2)+DoctorName;
	}
	

	PrintFun(myobj,MyPara,MyList);
	MyList="";PageCount=0;
	
	}
	
function ExecPrint()
{
	var MyPara,MyList='';
	
	var HosNameType="";
	var queryTypeCodearr="";
	var HospitalRowid="";
	var queryTypeCode="";
	var queryTypeCodeStr=document.getElementById("queryTypeCode").value;
	if (queryTypeCodeStr.indexOf('@')!='-1'){
		queryTypeCodearr=queryTypeCodeStr.split("@");
		HospitalRowid=queryTypeCodearr[0];
		queryTypeCode=queryTypeCodearr[1];
		if (queryTypeCode=="FLDO"){DHCP_GetXMLConfig("XMLObject","DHCDocRT");}
		if (queryTypeCode=="ZLDO"){DHCP_GetXMLConfig("XMLObject","DHCDocExec");}
	}else{
		if (queryTypeCodeStr=="FLDO"){DHCP_GetXMLConfig("XMLObject","DHCDocRT");}
		if (queryTypeCodeStr=="ZLDO"){DHCP_GetXMLConfig("XMLObject","DHCDocExec");}
	}
	

	var DiagnoseOffice,PrintTime,Str,CTLOCID,CTLOCName,DoctorName="";
	var RegNo,PName,Sex,Age,CaseHistoryNo,MedicareType,Address,Company=""; 
	var CTLOCID=session['LOGON.CTLOCID']
	var DoctorName=session['LOGON.USERNAME']
	var GetPatientInfoAc=document.getElementById('GetPatientInfo');
	if (GetPatientInfoAc) {var encmeth=GetPatientInfoAc.value;} else {var encmeth=''};
	if (encmeth!="") {
		  PatientInfo=cspRunServerMethod(encmeth,EpisodeID,CTLOCID);
		if (PatientInfo!=""){
			 RegNo=PatientInfo.split("^")[1];
			 PName=PatientInfo.split("^")[2];
			 Sex=PatientInfo.split("^")[3];
			 Age=PatientInfo.split("^")[4];
			 Address=PatientInfo.split("^")[10];
			 var Medcare=PatientInfo.split("^")[18];
			 MedicareType=PatientInfo.split("^")[6];
			 Company=PatientInfo.split("^")[14];
			 var MrNoE=PatientInfo.split("^")[31]
			 CTLOCName=PatientInfo.split("^")[32];
			 PrintTime=PatientInfo.split("^")[33];
			 var GovernCardNo=PatientInfo.split("^")[23];
			 var PAADMType=PatientInfo.split("^")[34];
			 var AdmReasonStr=PatientInfo.split("^")[35];
			 if (PAADMType=="O"){CaseHistoryNo=GovernCardNo}
			 else if (PAADMType=="E"){CaseHistoryNo=MrNoE}
			 else if (PAADMType=="I"){CaseHistoryNo=Medcare}
			 PrintTime=PrintTime.split(":")[0]+':'+PrintTime.split(":")[1];
			                 }
	    }
	if (document.getElementById('queryTypeCode').value=="ZLDO"){HosNameType="治疗单";damp=18;};
	if (document.getElementById('queryTypeCode').value=="FLDO"){HosNameType="放疗收费单";damp=11;};
	    MyPara="RegNo"+String.fromCharCode(2)+RegNo;
	    MyPara=MyPara+"^PName"+String.fromCharCode(2)+PName;
	    MyPara=MyPara+"^HosNameType"+String.fromCharCode(2)+HosNameType;
	    MyPara=MyPara+"^Sex"+String.fromCharCode(2)+Sex;
	    MyPara=MyPara+"^Age"+String.fromCharCode(2)+Age;
	    MyPara=MyPara+"^CaseHistoryNo"+String.fromCharCode(2)+CaseHistoryNo;
	    MyPara=MyPara+"^MedicareType"+String.fromCharCode(2)+MedicareType;
	    MyPara=MyPara+"^Address"+String.fromCharCode(2)+Address;
	    MyPara=MyPara+"^Company"+String.fromCharCode(2)+Company;
	    MyPara=MyPara+"^CTLOCName"+String.fromCharCode(2)+CTLOCName;
	    MyPara=MyPara+"^PrintTime"+String.fromCharCode(2)+PrintTime;
	    MyPara=MyPara+"^DoctorName"+String.fromCharCode(2)+DoctorName;
        Objtbl=document.getElementById('tDHCDocTransFusion');
	Rows=Objtbl.rows.length;
	MyList=String.fromCharCode(2)+"";
	var SumFee=0;   //PrintList


	for (n=1;n<Rows;n++)
  {
		if ((document.getElementById('GroupSelectz'+n).checked==true)&(n<damp+1)){
			var ArcimDesc=document.getElementById('arcimDescz'+n).innerText; 
	 	    var doseQtyUnit=document.getElementById('doseQtyUnitz'+n).innerText; 
		    var price=document.getElementById('pricez'+n).innerText;
		    var phOrdQtyUnit=document.getElementById('phOrdQtyUnitz'+n).innerText;
		    var totalAmount=document.getElementById('totalAmountz'+n).innerText;
		    if ((n+damp)<Rows){ 
                 var ArcimDesc1=document.getElementById('arcimDescz'+(n+damp)).innerText; 
                 var doseQtyUnit1=document.getElementById('doseQtyUnitz'+(n+damp)).innerText; 
                 var price1=document.getElementById('pricez'+(n+damp)).innerText;
                 var phOrdQtyUnit1=document.getElementById('phOrdQtyUnitz'+(n+damp)).innerText;
                 var totalAmount=document.getElementById('totalAmountz'+(n+damp)).innerText;
                 var doseQtyUnit1=parseFloat(doseQtyUnit1).toFixed(2)
                 var price1=parseFloat(price1).toFixed(2)
                // var SumFee=SumFee+(price1*doseQtyUnit1);
                 var SumFee=SumFee+(parseFloat(totalAmount));
		    }else{
			    ArcimDesc1="";doseQtyUnit1="";price1="";phOrdQtyUnit1=""
			}
		    //SumFee=SumFee+(parseFloat(price)*parseFloat(doseQtyUnit));
		    SumFee=SumFee+(parseFloat(totalAmount));
		     MyList=MyList+String.fromCharCode(2)+"^"+ArcimDesc+'^'+parseFloat(doseQtyUnit).toFixed(2)+'^'+phOrdQtyUnit+'^'+parseFloat(price).toFixed(2)+"^"+ArcimDesc1+'^'+doseQtyUnit1+'^'+phOrdQtyUnit1+'^'+price1;
	    }
   }  
	    MyPara=MyPara+"^SumFee"+String.fromCharCode(2)+SumFee.toFixed(2)+"元";
	    var myobj=document.getElementById("ClsBillPrint");
	    PrintFun(myobj,MyPara,MyList);
	
	
	}
	
function SelectLoc_onclick1()
{
	var Relocsum=0;
	var LocArray="";
	
	
	var HosNameType="";
	var queryTypeCodearr="";
	var HospitalRowid="";
	var queryTypeCode="";
	var queryTypeCodeStr=document.getElementById("queryTypeCode").value;
	if (queryTypeCodeStr.indexOf('@')!='-1'){
		queryTypeCodearr=queryTypeCodeStr.split("@");
		HospitalRowid=queryTypeCodearr[0];
		queryTypeCode=queryTypeCodearr[1];
		if (queryTypeCode=="FLDO"){
			HosNameType="放疗收费单";damp=11;
			DHCP_GetXMLConfig("XMLObject","DHCDocRT");
		}
		if (queryTypeCode=="ZLDO"){
			HosNameType="治疗单";damp=18;
			DHCP_GetXMLConfig("XMLObject","DHCDocExec");
		}
	}else{
		if (queryTypeCodeStr=="FLDO"){
			HosNameType="放疗收费单";damp=11;
			DHCP_GetXMLConfig("XMLObject","DHCDocRT");
		}
		if (queryTypeCodeStr=="ZLDO"){
			HosNameType="治疗单";damp=18;
			DHCP_GetXMLConfig("XMLObject","DHCDocExec");
		}
	}
	

    var objtbl=document.getElementById('tDHCDocTransFusion');
		var rows=objtbl.rows.length;
	  for (var j=1;j<rows;j++) {
	  	   var reloc=document.getElementById('Relocz'+j).innerText;
	       if (LocArray=="")  { LocArray=reloc
	                          }else{  var LocFlag="N";
	                          	      for (j1=0;j1<LocArray.split("^").length;j1++){
	                          	      	                 if (reloc==LocArray.split("^")[j1]){LocFlag="Y"}
	                          	      	                 }
	                          	      if (LocFlag=="N"){LocArray=LocArray+"^"+reloc;}
	          	                             	                	                  
	          	                   }
	          	      
	          	               } 	
for(y=0;y<LocArray.split("^").length;y++){
  var MyPara,MyList='';
	var DiagnoseOffice,PrintTime,Str,CTLOCID,CTLOCName,DoctorName="";
	var RegNo,PName,Sex,Age,CaseHistoryNo,MedicareType,Address,Company=""; 
	var CTLOCID=session['LOGON.CTLOCID']
	var DoctorName=session['LOGON.USERNAME']
	var GetPatientInfoAc=document.getElementById('GetPatientInfo');
	if (GetPatientInfoAc) {var encmeth=GetPatientInfoAc.value;} else {var encmeth=''};
	if (encmeth!="") {
		  PatientInfo=cspRunServerMethod(encmeth,EpisodeID,CTLOCID);
		if (PatientInfo!=""){
			 RegNo=PatientInfo.split("^")[1];
			 PName=PatientInfo.split("^")[2];
			 Sex=PatientInfo.split("^")[3];
			 Age=PatientInfo.split("^")[4];
			 Address=PatientInfo.split("^")[10];
			 var Medcare=PatientInfo.split("^")[18];
			 MedicareType=PatientInfo.split("^")[6];
			 Company=PatientInfo.split("^")[14];
			 var MrNoE=PatientInfo.split("^")[31]
			 CTLOCName=PatientInfo.split("^")[32];
			 PrintTime=PatientInfo.split("^")[33];
			 var GovernCardNo=PatientInfo.split("^")[23];
			 var PAADMType=PatientInfo.split("^")[34];
			 var AdmReasonStr=PatientInfo.split("^")[35];
			 if (PAADMType=="O"){CaseHistoryNo=GovernCardNo}
			 else if (PAADMType=="E"){CaseHistoryNo=MrNoE}
			 else if (PAADMType=="I"){CaseHistoryNo=Medcare}
			  PrintTime=PrintTime.split(":")[0]+':'+PrintTime.split(":")[1];
			                 }
	    }
	
	    MyPara="RegNo"+String.fromCharCode(2)+RegNo;
	    MyPara=MyPara+"^PName"+String.fromCharCode(2)+PName;
	    MyPara=MyPara+"^HosNameType"+String.fromCharCode(2)+HosNameType;
	    MyPara=MyPara+"^Sex"+String.fromCharCode(2)+Sex;
	    MyPara=MyPara+"^Age"+String.fromCharCode(2)+Age;
	    MyPara=MyPara+"^CaseHistoryNo"+String.fromCharCode(2)+CaseHistoryNo;
	    MyPara=MyPara+"^MedicareType"+String.fromCharCode(2)+MedicareType;
	    MyPara=MyPara+"^Address"+String.fromCharCode(2)+Address;
	    MyPara=MyPara+"^Company"+String.fromCharCode(2)+Company;
	    MyPara=MyPara+"^CTLOCName"+String.fromCharCode(2)+CTLOCName;
	    MyPara=MyPara+"^PrintTime"+String.fromCharCode(2)+PrintTime;
	    MyPara=MyPara+"^DoctorName"+String.fromCharCode(2)+DoctorName;
	    MyPara=MyPara+"^Reloc"+String.fromCharCode(2)+"["+LocArray.split("^")[y]+"]";
  Objtbl=document.getElementById('tDHCDocTransFusion');
	Rows=Objtbl.rows.length;
	MyList=String.fromCharCode(2)+"";
	var SumFee=0;
	for (n=1;n<Rows;n++)
  {
		var ArcimDesc1="";doseQtyUnit1="";price1="";phOrdQtyUnit1=""
		if ((document.getElementById('Relocz'+n).innerText==LocArray.split("^")[y])&(n<damp+1))
		{
			var ArcimDesc=document.getElementById('arcimDescz'+n).innerText; 
	 	  var doseQtyUnit=document.getElementById('doseQtyUnitz'+n).innerText; 
		  var price=document.getElementById('pricez'+n).innerText;
		  var phOrdQtyUnit=document.getElementById('phOrdQtyUnitz'+n).innerText;
		  var totalAmount=document.getElementById('totalAmountz'+n).innerText;
     if ((n+damp)<Rows){ 
     	        if(document.getElementById('Relocz'+(n+damp)).innerText==LocArray.split("^")[y]){
     	    	  var ArcimDesc1=document.getElementById('arcimDescz'+(n+damp)).innerText;
              var doseQtyUnit1=document.getElementById('doseQtyUnitz'+(n+damp)).innerText;
              var price1=document.getElementById('pricez'+(n+damp)).innerText;
              var phOrdQtyUnit1=document.getElementById('phOrdQtyUnitz'+(n+damp)).innerText;
              var totalAmount=document.getElementById('totalAmountz'+(n+damp)).innerText;
              var doseQtyUnit1=parseFloat(doseQtyUnit1).toFixed(2);
              var price1=parseFloat(price1).toFixed(2);
              //var SumFee=SumFee+(price1*doseQtyUnit1);
              var SumFee=SumFee+(parseFloat(totalAmount));
                             }
		     }else{ArcimDesc1="";doseQtyUnit1="";price1="";phOrdQtyUnit1=""}
		      //SumFee=SumFee+(parseFloat(price)*parseFloat(doseQtyUnit));
		      SumFee=SumFee+(parseFloat(totalAmount));
		  MyList=MyList+String.fromCharCode(2)+"^"+ArcimDesc+'^'+parseFloat(doseQtyUnit).toFixed(2)+'^'+phOrdQtyUnit+'^'+parseFloat(price).toFixed(2)+"^"+ArcimDesc1+'^'+doseQtyUnit1+'^'+phOrdQtyUnit1+'^'+price1;
			 }
   }  
	    MyPara=MyPara+"^SumFee"+String.fromCharCode(2)+SumFee.toFixed(2)+"元";
	    var myobj=document.getElementById("ClsBillPrint");
	    PrintFun(myobj,MyPara,MyList); 

 }
}	

function ExecPrintNew()
{
	var MyPara,MyList='';
	var HosNameType="";
	var queryTypeCodearr="";
	var HospitalRowid="";
	var queryTypeCode="";
	var queryTypeCodeStr=document.getElementById("queryTypeCode").value;
	if (queryTypeCodeStr.indexOf('@')!='-1'){
		queryTypeCodearr=queryTypeCodeStr.split("@");
		HospitalRowid=queryTypeCodearr[0];
		queryTypeCode=queryTypeCodearr[1];
		if (queryTypeCode=="FLDO"){ExecPrintNew();return;DHCP_GetXMLConfig("XMLObject","DHCDocRT");}
		if (queryTypeCode=="ZLDO"){DHCP_GetXMLConfig("XMLObject","DHCDocExec");}
	}else{
		if (queryTypeCodeStr=="FLDO"){DHCP_GetXMLConfig("XMLObject","DHCDocRT");}
		if (queryTypeCodeStr=="ZLDO"){DHCP_GetXMLConfig("XMLObject","DHCDocExec");}
	}
	var DiagnoseOffice,PrintTime,Str,CTLOCID,CTLOCName,DoctorName="";
	var RegNo,PName,Sex,Age,CaseHistoryNo,MedicareType,Address,Company=""; 
	var CTLOCID=session['LOGON.CTLOCID']
	var DoctorName=session['LOGON.USERNAME']
	var GetPatientInfoAc=document.getElementById('GetPatientInfo');
	if (GetPatientInfoAc) {var encmeth=GetPatientInfoAc.value;} else {var encmeth=''};
	if (encmeth!="") {
		PatientInfo=cspRunServerMethod(encmeth,EpisodeID,CTLOCID);
		if (PatientInfo!=""){
			 RegNo=PatientInfo.split("^")[1];
			 PName=PatientInfo.split("^")[2];
			 Sex=PatientInfo.split("^")[3];
			 Age=PatientInfo.split("^")[4];
			 Address=PatientInfo.split("^")[10];
			 var Medcare=PatientInfo.split("^")[18];
			 MedicareType=PatientInfo.split("^")[6];
			 Company=PatientInfo.split("^")[14];
			 var MrNoE=PatientInfo.split("^")[31]
			 CTLOCName=PatientInfo.split("^")[32];
			 PrintTime=PatientInfo.split("^")[33];
			 var GovernCardNo=PatientInfo.split("^")[23];
			 var PAADMType=PatientInfo.split("^")[34];
			 var AdmReasonStr=PatientInfo.split("^")[35];
			 if (PAADMType=="O"){CaseHistoryNo=GovernCardNo}
			 else if (PAADMType=="E"){CaseHistoryNo=MrNoE}
			 else if (PAADMType=="I"){CaseHistoryNo=Medcare}
			 //alert(PatientInfo.split("^")[25]+"^"+PatientInfo.split("^")[26]+"^"+PatientInfo.split("^")[27])
			 PrintTime=PrintTime.split(":")[0]+':'+PrintTime.split(":")[1];
			 var CardNo=PatientInfo.split("^")[29];
			 var HospName=PatientInfo.split("^")[37];
		}
	 }
	//if (document.getElementById('queryTypeCode').value=="ZLDO"){HosNameType="治疗单";damp=18;};
	//if (document.getElementById('queryTypeCode').value=="FLDO"){HosNameType="放疗收费单";damp=11;};
	if (queryTypeCode=="ZLDO"){HosNameType="治疗单";damp=18;};
	if (queryTypeCode=="FLDO"){HosNameType="放疗收费单";damp=11;};
	if (queryTypeCode=="ZSDO"){HosNameType="注射单";damp=13;};
	if (queryTypeCode=="SYDO"){HosNameType="输液单";damp=13;};
	
	    //MyPara="RegNo"+String.fromCharCode(2)+RegNo;
	    MyPara="RegNo"+String.fromCharCode(2)+CardNo;
	    MyPara=MyPara+"^PName"+String.fromCharCode(2)+PName;
	    MyPara=MyPara+"^HosNameType"+String.fromCharCode(2)+HosNameType;
	    MyPara=MyPara+"^Sex"+String.fromCharCode(2)+Sex;
	    MyPara=MyPara+"^Age"+String.fromCharCode(2)+Age;
	    MyPara=MyPara+"^CaseHistoryNo"+String.fromCharCode(2)+CaseHistoryNo;
	    MyPara=MyPara+"^MedicareType"+String.fromCharCode(2)+MedicareType;
	    MyPara=MyPara+"^Address"+String.fromCharCode(2)+Address;
	    MyPara=MyPara+"^Company"+String.fromCharCode(2)+Company;
	    MyPara=MyPara+"^CTLOCName"+String.fromCharCode(2)+CTLOCName;
	    MyPara=MyPara+"^PrintTime"+String.fromCharCode(2)+PrintTime;
	    MyPara=MyPara+"^DoctorName"+String.fromCharCode(2)+DoctorName;
	    MyPara=MyPara+"^HosName"+String.fromCharCode(2)+HospName;
        Objtbl=document.getElementById('tDHCDocTransFusion');
	    Rows=Objtbl.rows.length;
	    MyList=String.fromCharCode(2)+"";
	    var SumFee=0;   //PrintList
	    var PrintList=new Array();
        CheckFlag=0
        for (n=1;n<Rows;n++){
	        if (document.getElementById('GroupSelectz'+n).checked==true){
	        PrintList[CheckFlag]=n;
	   	    CheckFlag=CheckFlag+1;
	   	}
     }
    if (PrintList.length<damp){
	      for (i=0;i<PrintList.length;i++){
	           ArcimDesc1="";doseQtyUnit1="";price1="";phOrdQtyUnit1=""
		       var ArcimDesc=document.getElementById('arcimDescz'+PrintList[i]).innerText; 
		 	   var doseQtyUnit=document.getElementById('doseQtyUnitz'+PrintList[i]).innerText; 
			   var price=document.getElementById('pricez'+PrintList[i]).innerText;
			   var phOrdQtyUnit=document.getElementById('phOrdQtyUnitz'+PrintList[i]).innerText;
			   var totalAmount=document.getElementById('totalAmountz'+PrintList[i]).innerText;
	           //SumFee=SumFee+(parseFloat(price)*parseFloat(doseQtyUnit));
	           SumFee=SumFee+(parseFloat(totalAmount))
			   //MyList=MyList+String.fromCharCode(2)+"^"+ArcimDesc+'^'+parseFloat(doseQtyUnit).toFixed(2)+'^'+phOrdQtyUnit+'^'+parseFloat(price).toFixed(2)+"^"+ArcimDesc1+'^'+doseQtyUnit1+'^'+phOrdQtyUnit1+'^'+price1;
			   MyList=MyList+String.fromCharCode(2)+"^"+ArcimDesc+'^'+phOrdQtyUnit+'^'+doseQtyUnit+'^'+parseFloat(price).toFixed(2)+"^"+ArcimDesc1+'^'+phOrdQtyUnit1+'^'+doseQtyUnit1+'^'+price1;
		 }
	}else{
       	 for (i=0;i<damp;i++){
       		  //alert(PrintList[i])
       		  var ArcimDesc=document.getElementById('arcimDescz'+PrintList[i]).innerText; 
	 	      var doseQtyUnit=document.getElementById('doseQtyUnitz'+PrintList[i]).innerText; 
		      var price=document.getElementById('pricez'+PrintList[i]).innerText;
		      var phOrdQtyUnit=document.getElementById('phOrdQtyUnitz'+PrintList[i]).innerText;
		      var totalAmount=document.getElementById('totalAmountz'+PrintList[i]).innerText;
		      if ((i+damp)<PrintList.length){
			      	//alert(PrintList[i+damp])
			      	var ArcimDesc1=document.getElementById('arcimDescz'+PrintList[i+damp]).innerText; 
		 	        var doseQtyUnit1=document.getElementById('doseQtyUnitz'+PrintList[i+damp]).innerText; 
			        var price1=document.getElementById('pricez'+PrintList[i+damp]).innerText;
			        var phOrdQtyUnit1=document.getElementById('phOrdQtyUnitz'+PrintList[i+damp]).innerText;
			      	var doseQtyUnit1=parseFloat(doseQtyUnit1).toFixed(2);
			        var price1=parseFloat(price1).toFixed(2);
			        var totalAmount=document.getElementById('totalAmountz'+PrintList[i+damp]).innerText;
			        //var SumFee=SumFee+(price1*doseQtyUnit1);
			        var SumFee=SumFee+(parseFloat(totalAmount));
		      	}else{
			      	ArcimDesc1="";doseQtyUnit1="";price1="";phOrdQtyUnit1=""
			    }
       		    //SumFee=SumFee+(parseFloat(price)*parseFloat(doseQtyUnit));
       		    SumFee=SumFee+(parseFloat(totalAmount));
		        //MyList=MyList+String.fromCharCode(2)+"^"+ArcimDesc+'^'+parseFloat(doseQtyUnit).toFixed(2)+'^'+phOrdQtyUnit+'^'+parseFloat(price).toFixed(2)+"^"+ArcimDesc1+'^'+doseQtyUnit1+'^'+phOrdQtyUnit1+'^'+price1;
		        MyList=MyList+String.fromCharCode(2)+"^"+ArcimDesc+'^'+phOrdQtyUnit+'^'+doseQtyUnit+'^'+parseFloat(price).toFixed(2)+"^"+ArcimDesc1+'^'+phOrdQtyUnit1+'^'+doseQtyUnit1+'^'+price1;
       	}
     }
    MyPara=MyPara+"^SumFee"+String.fromCharCode(2)+SumFee.toFixed(2)+"元";
    var myobj=document.getElementById("ClsBillPrint");
    PrintFun(myobj,MyPara,MyList);
	
	
	}

function SelectLoc_onclick()
{
	var LocArray="",reloc=""
	var MyPara,MyList='';
	
	var HosNameType="";
	var queryTypeCodearr="";
	var HospitalRowid="";
	var queryTypeCode="";
	var queryTypeCodeStr=document.getElementById("queryTypeCode").value;
	if (queryTypeCodeStr.indexOf('@')!='-1'){
		queryTypeCodearr=queryTypeCodeStr.split("@");
		HospitalRowid=queryTypeCodearr[0];
		queryTypeCode=queryTypeCodearr[1];
		//if (queryTypeCode=="SYDO"){TransFusion_Print();return;}
		//if (queryTypeCode=="ZSDO"){TransFusion_Print();return;}
		if (queryTypeCode=="FLDO"){DHCP_GetXMLConfig("XMLObject","DHCDocRT");}
		if (queryTypeCode=="ZLDO"){DHCP_GetXMLConfig("XMLObject","DHCDocExec");}
	}else{
		//if (queryTypeCode=="SYDO"){TransFusion_Print();return;}
		//if (queryTypeCode=="ZSDO"){TransFusion_Print();return;}
		if (queryTypeCodeStr=="FLDO"){DHCP_GetXMLConfig("XMLObject","DHCDocRT");}
		if (queryTypeCodeStr=="ZLDO"){DHCP_GetXMLConfig("XMLObject","DHCDocExec");}
	}
	if (queryTypeCode=="ZLDO"){HosNameType="治疗单";damp=18;};
	if (queryTypeCode=="FLDO"){HosNameType="放疗收费单";damp=11;};
	if (queryTypeCode=="ZSDO"){HosNameType="注射单";damp=13;};
	if (queryTypeCode=="SYDO"){HosNameType="输液单";damp=13;};
	
	var DiagnoseOffice,PrintTime,Str,CTLOCID,CTLOCName,DoctorName="";
	var RegNo,PName,Sex,Age,CaseHistoryNo,MedicareType,Address,Company=""; 
	var CTLOCID=session['LOGON.CTLOCID']
	var DoctorName=session['LOGON.USERNAME']
	var GetPatientInfoAc=document.getElementById('GetPatientInfo');
	if (GetPatientInfoAc) {var encmeth=GetPatientInfoAc.value;} else {var encmeth=''};
	if (encmeth!="") {
		PatientInfo=cspRunServerMethod(encmeth,EpisodeID,CTLOCID);
		if (PatientInfo!=""){
			 RegNo=PatientInfo.split("^")[1];
			 PName=PatientInfo.split("^")[2];
			 Sex=PatientInfo.split("^")[3];
			 Age=PatientInfo.split("^")[4];
			 Address=PatientInfo.split("^")[10];
			 var Medcare=PatientInfo.split("^")[18];
			 MedicareType=PatientInfo.split("^")[6];
			 Company=PatientInfo.split("^")[14];
			 var MrNoE=PatientInfo.split("^")[31]
			 CTLOCName=PatientInfo.split("^")[32];
			 PrintTime=PatientInfo.split("^")[33];
			 var GovernCardNo=PatientInfo.split("^")[23];
			 var PAADMType=PatientInfo.split("^")[34];
			 var AdmReasonStr=PatientInfo.split("^")[35];
			 if (PAADMType=="O"){CaseHistoryNo=GovernCardNo}
			 else if (PAADMType=="E"){CaseHistoryNo=MrNoE}
			 else if (PAADMType=="I"){CaseHistoryNo=Medcare}
			  PrintTime=PrintTime.split(":")[0]+':'+PrintTime.split(":")[1];
			  var CardNo=PatientInfo.split("^")[29];
			 var HospName=PatientInfo.split("^")[37];
		}
	}
	
	    MyPara="RegNo"+String.fromCharCode(2)+CardNo;
	    MyPara=MyPara+"^PName"+String.fromCharCode(2)+PName;
	    MyPara=MyPara+"^HosNameType"+String.fromCharCode(2)+HosNameType;
	    MyPara=MyPara+"^Sex"+String.fromCharCode(2)+Sex;
	    MyPara=MyPara+"^Age"+String.fromCharCode(2)+Age;
	    MyPara=MyPara+"^CaseHistoryNo"+String.fromCharCode(2)+CaseHistoryNo;
	    //MyPara=MyPara+"^MedicareType"+String.fromCharCode(2)+MedicareType;
	    MyPara=MyPara+"^Address"+String.fromCharCode(2)+Address;
	    MyPara=MyPara+"^Company"+String.fromCharCode(2)+Company;
	    MyPara=MyPara+"^CTLOCName"+String.fromCharCode(2)+CTLOCName;
	    MyPara=MyPara+"^PrintTime"+String.fromCharCode(2)+PrintTime;
	    MyPara=MyPara+"^DoctorName"+String.fromCharCode(2)+DoctorName;
	    MyPara=MyPara+"^HosName"+String.fromCharCode(2)+HospName;
	    MyPara1=MyPara;
  	Objtbl=document.getElementById('tDHCDocTransFusion');
	Rows=Objtbl.rows.length;
	////定义接受科室数组长度
	for (var j=1;j<Rows;j++) {
	  	var reloc=document.getElementById('Relocz'+j).innerText;
	  	var SelectFlag=document.getElementById('GroupSelectz'+j).checked;
	  	if (SelectFlag==true){
		    if (LocArray==""){LocArray=reloc}
		    else{  
		    	var LocFlag="N";
		        for (j1=0;j1<LocArray.split("^").length;j1++){
		            if (reloc==LocArray.split("^")[j1]){LocFlag="Y"}
		        }
		        if (LocFlag=="N"){LocArray=LocArray+"^"+reloc;}
	          	                    	                	                  
		    }	          	      
	    } 	
	}
  	MyList="";LineNo=1;
	Line1=Line+"第"+LineNo+"组"+Line;
	//MyList=MyList+String.fromCharCode(2)+" "+Line1+"       ";
	MyList=MyList+String.fromCharCode(2)+"^"+Line1+"^^^^^^^";
	//alert(LocArray)
	
	//定义二维数组
	var PrintList=new Array();
	for (j=0;j<LocArray.split('^').length;j++){
		var SumFee=0;   
	 	PrintList[j]=new Array()
  		CheckFlag=0;
		for (n=1;n<Rows;n++){
			if ((document.getElementById('GroupSelectz'+n).checked==true)&&(document.getElementById('Relocz'+n).innerText==LocArray.split("^")[j])){
			    PrintList[j][CheckFlag]=n;
			   	CheckFlag=CheckFlag+1;
			}
		}
 	}
	//alert(PrintList.length);
 	//alert(PrintList[0].length);
	for(j=0;j<PrintList.length;j++){
		MyList="";
	    SumFee=0;
     	if(j>0){
	     	LineNo=LineNo+j;
		    Line1="";
		    Line1=Line+"第"+LineNo+"组"+Line;
		    //MyList=MyList+String.fromCharCode(2)+"^"+Line1+"^^^^^^^"
		    //MyList=MyList+String.fromCharCode(2)+" "+Line1+"       ";
     	}
	    //alert(PrintList[j].length+"damp="+damp)
		if (PrintList[j].length<damp){
	     	for (i=0;i<PrintList[j].length;i++){
       			var ArcimDesc1="";doseQtyUnit1="";price1="";phOrdQtyUnit1="";
	     		var ArcimDesc=document.getElementById('arcimDescz'+PrintList[j][i]).innerText; 
	 	   		var doseQtyUnit=document.getElementById('doseQtyUnitz'+PrintList[j][i]).innerText; 
		   		var price=document.getElementById('pricez'+PrintList[j][i]).innerText;
		   		var reloc=document.getElementById('Relocz'+PrintList[j][i]).innerText;
		   		var phOrdQtyUnit=document.getElementById('phOrdQtyUnitz'+PrintList[j][i]).innerText;
		   		var totalAmount=document.getElementById('totalAmountz'+PrintList[j][i]).innerText;
      			SumFee=SumFee+(parseFloat(totalAmount));
      			
      			var PhcfrCode=document.getElementById('phcfrCodez'+PrintList[j][i]).innerText;
		   		var PhcinDesc=document.getElementById('phcinDescz'+PrintList[j][i]).innerText; 
		   		var notes=document.getElementById('notesz'+PrintList[j][i]).innerText;
      			var OeoriId=document.getElementById('oeoriIdz'+PrintList[j][i]).value;
      			var GetPlanSumAc=document.getElementById('GetPlanSum').value;
      			if (GetPlanSumAc) {var encmeth=GetPlanSumAc.value} else {var encmeth=''};
			    if (encmeth!="") {
			   	     var PlanSum=cspRunServerMethod(GetPlanSumAc,OeoriId);
			    };
			    var PlanSumRow=document.getElementById('phOrdQtyUnitz'+PrintList[j][i]).innerText;
				if (+PlanSum==0) PlanSum=+PlanSumRow.replace(/[^0-9]/ig,""); 
      			if ((queryTypeCode=="SYDO")||(queryTypeCode=="ZSDO")){
             		MyList=MyList+String.fromCharCode(2)+ArcimDesc+"/"+doseQtyUnit+" "+PhcfrCode+" "+PhcinDesc+" "+notes+" "+PlanSum+"次";
	      		}else{
		      		MyList=MyList+String.fromCharCode(2)+"^"+ArcimDesc+'^'+phOrdQtyUnit+'^'+doseQtyUnit+'^'+parseFloat(price).toFixed(2)+"^"+ArcimDesc1+'^'+phOrdQtyUnit1+'^'+doseQtyUnit1+'^'+price1;
		      	}
		 	}
       	}else{
       		for (i=0;i<damp;i++){
       			//alert(PrintList[i])
       			var ArcimDesc=document.getElementById('arcimDescz'+PrintList[j][i]).innerText; 
	 	      	var doseQtyUnit=document.getElementById('doseQtyUnitz'+PrintList[j][i]).innerText; 
		     	var price=document.getElementById('pricez'+PrintList[j][i]).innerText;
		      	var phOrdQtyUnit=document.getElementById('phOrdQtyUnitz'+PrintList[j][i]).innerText;
		      	var totalAmount=document.getElementById('totalAmountz'+PrintList[j][i]).innerText;
		      	if ((i+damp)<PrintList[j].length){
		      	
		      	var ArcimDesc1=document.getElementById('arcimDescz'+PrintList[j][i+damp]).innerText; 
	 	        var doseQtyUnit1=document.getElementById('doseQtyUnitz'+PrintList[j][i+damp]).innerText; 
		        var price1=document.getElementById('pricez'+PrintList[j][i+damp]).innerText;
		        var phOrdQtyUnit1=document.getElementById('phOrdQtyUnitz'+PrintList[j][i+damp]).innerText;
		        var totalAmount=document.getElementById('totalAmountz'+PrintList[j][i+damp]).innerText;
		      	var doseQtyUnit1=parseFloat(doseQtyUnit1).toFixed(2);
		        var price1=parseFloat(price1).toFixed(2);
		        //var SumFee=SumFee+(price1*doseQtyUnit1);
		        var SumFee=SumFee+parseFloat(totalAmount)
		      	}else{ArcimDesc1="";doseQtyUnit1="";price1="";phOrdQtyUnit1=""}
       			 //SumFee=SumFee+(parseFloat(price)*parseFloat(doseQtyUnit));
       			 SumFee=SumFee+parseFloat(totalAmount)
		      	//MyList=MyList+String.fromCharCode(2)+"^"+ArcimDesc+'^'+parseFloat(doseQtyUnit).toFixed(2)+'^'+phOrdQtyUnit+'^'+parseFloat(price).toFixed(2)+"^"+ArcimDesc1+'^'+doseQtyUnit1+'^'+phOrdQtyUnit1+'^'+price1;
       			//MyList=MyList+String.fromCharCode(2)+ArcimDesc+"/"+doseQtyUnit+" "+phOrdQtyUnit+" "+parseFloat(price).toFixed(2)+" "+ArcimDesc1+" "+doseQtyUnit1+" "+phOrdQtyUnit1+" "+price1;
       		    //MyList=MyList+String.fromCharCode(2)+"^"+ArcimDesc+'^'+phOrdQtyUnit+'^'+doseQtyUnit+'^'+parseFloat(price).toFixed(2)+"^"+ArcimDesc1+'^'+phOrdQtyUnit1+'^'+doseQtyUnit1+'^'+price1;
       		    //MyList=MyList+String.fromCharCode(2)+" "+ArcimDesc+' '+phOrdQtyUnit+' '+doseQtyUnit+' '+parseFloat(price).toFixed(2)+" "+ArcimDesc1+' '+phOrdQtyUnit1+' '+doseQtyUnit1+' '+price1;
       			var PhcfrCode=document.getElementById('phcfrCodez'+PrintList[j][i]).innerText;
		   		var PhcinDesc=document.getElementById('phcinDescz'+PrintList[j][i]).innerText; 
		   		var notes=document.getElementById('notesz'+PrintList[j][i]).innerText;
      			var OeoriId=document.getElementById('oeoriIdz'+PrintList[j][i]).value;
      			var GetPlanSumAc=document.getElementById('GetPlanSum').value;
      			if (GetPlanSumAc) {var encmeth=GetPlanSumAc.value} else {var encmeth=''};
			    if (encmeth!="") {
			   	     var PlanSum=cspRunServerMethod(GetPlanSumAc,OeoriId);
			    };
			    var PlanSumRow=document.getElementById('phOrdQtyUnitz'+PrintList[j][i]).innerText;
				if (+PlanSum==0) PlanSum=+PlanSumRow.replace(/[^0-9]/ig,""); 
      			if ((queryTypeCode=="SYDO")||(queryTypeCode=="ZSDO")){
             		MyList=MyList+String.fromCharCode(2)+ArcimDesc+"/"+doseQtyUnit+" "+PhcfrCode+" "+PhcinDesc+" "+notes+" "+PlanSum+"次";
             		MyList=MyList+String.fromCharCode(2)+ArcimDesc1;
	      		}else{
		      		MyList=MyList+String.fromCharCode(2)+"^"+ArcimDesc+'^'+phOrdQtyUnit+'^'+doseQtyUnit+'^'+parseFloat(price).toFixed(2)+"^"+ArcimDesc1+'^'+phOrdQtyUnit1+'^'+doseQtyUnit1+'^'+price1;
		      	    
		      	}
       		}
     	}
     	if ((queryTypeCode=="SYDO")||(queryTypeCode=="ZSDO")){
	     	MyList=Line1+String.fromCharCode(2)+MyList;
	    }else{
		    MyList="^"+Line1+"^^^^^^^"+String.fromCharCode(2)+MyList
		}
	    MyPara=MyPara1+"^SumFee"+String.fromCharCode(2)+SumFee.toFixed(2)+"元";
	    MyPara=MyPara+"^RecLoc"+String.fromCharCode(2)+reloc;
	    var myobj=document.getElementById("ClsBillPrint");
	    PrintFun(myobj,MyPara,MyList);
	   
	 
	}
}

document.body.onload = BodyLoadHandler;
