///DHCBldRequest.js

var DOPInfo_ReadInfoType=0;

var m_Version="";

//病人信息
var tadmId=document.getElementById('admId');
var PatientID=document.getElementById('Debtor');
var PatName=document.getElementById('Name');
var PatSex=document.getElementById('Sex');
var PatType=document.getElementById('PatType');
var PatAge1=document.getElementById('Age1');
var PatAge2=document.getElementById('Age2');
var PatDep=document.getElementById('Department');
var PatBed=document.getElementById('Bed');
var PatCardID=document.getElementById('CardID');
var PatCountry=document.getElementById('Country');
var PatApanage=document.getElementById('Apanage'); 
var PatPeople=document.getElementById('People');
var PatDiagnose=document.getElementById('Diagnose');
var PatsafetyNetCardNo=document.getElementById('safetyNetCardNo');

PatientID.readOnly=true;
PatName.readOnly=true;
PatSex.readOnly=true;
PatType.readOnly=true;
PatAge1.readOnly=true;
PatAge2.readOnly=true;
PatDep.readOnly=true;
PatBed.readOnly=true;
PatCardID.readOnly=true;
PatCountry.readOnly=true;
PatApanage.readOnly=true;
PatPeople.readOnly=true;
PatDiagnose.readOnly=true;

//输血信息
var RqSXDate=document.getElementById("SXDate");
var RqxxFlagType=document.getElementById("xxFlagType");
var RqIntentSSBX=document.getElementById("IntentSSBX");
var RqIntentBZXL=document.getElementById("IntentBZXL");
var RqIntentJZPX=document.getElementById("IntentJZPX");
var RqIntentYXYZ=document.getElementById("IntentYXYZ");
var RqIntentZLYX=document.getElementById("IntentZLYX");
var RqAnamnesis=document.getElementById("Anamnesis");
var RqResponse=document.getElementById("Response");
var RqAllergic=document.getElementById("Allergic");
var RqGestation=document.getElementById("Gestation");
var RqPregnant=document.getElementById("Pregnant");
var RqRadiation=document.getElementById("Radiation");
var RqLeucocyte=document.getElementById("Leucocyte");
var RqImmunotherapy=document.getElementById("Immunotherapy");
var RqAgree=document.getElementById("Agree");
//检验信息
var labObj;
var LabBloodGroup;
var LabBloodRh;
var LabOtherBlood;
var LabRBC;
var LabHCT;
var LabHb;
var LabPLT;
var LabALT;
var LabHBeAg;
var LabHBsAg;
var LabAntiHBs;
var LabAntiHBe;
var LabAntiHBc;
var LabAntiHCV;
var LabAntiHIV;
var LabMD;

var gUser=session['LOGON.USERID']
var gUsername=session['LOGON.USERNAME']
var gUsercode=session['LOGON.USERCODE']

function BodyLoadHandler() {
	InitControl();

	var objAdmId=document.getElementById("admId");

	if ((objAdmId)&&(objAdmId.value!="")) {
		var curId="^"+objAdmId.value;
   	   SetPatientInfo(curId);
	} else {alert(t['02']);}
	

   var obj=document.getElementById("Debtor");
   if (obj) obj.onkeydown=PatientNoKeyDown;
   
   var obj=document.getElementById('getOrderItem');
   if (obj) obj.onclick=getOrderItem;

   var obj=document.getElementById('Print');
   if (obj) obj.onclick=PrintSXSQD;

   var obj=document.getElementById('HisPrint');
   if (obj) obj.onclick=FindHistroy;
  
}

function FindHistroy()	{
    var PatientID =document.getElementById("Debtor");
    if ((PatientID)&&(PatientID.value!="")) {
	   	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCBldReqHistroy&HisDebtor="+PatientID.value;
	   	//alert(lnk);
   		var NewWin=open(lnk,"DHCBldReqHistroy","scrollbars=no,resizable=no,top=200,left=150,width=530,height=460");
   	}	
}

function gettoday(){
    var d=new Date();
    var s=d.getDate()+"/";
    s+=(d.getMonth()+1)+"/";
    s+=d.getYear();
    return(s);
}

function getnowtime(){
   var d1 = new Date();
   var s1 = d1.getHours()+":";
   s1+=d1.getMinutes()+":";
   s1+=d1.getSeconds()+":";
   return(s1);
}


function InitControl(){
    //输血日期
	var obj=document.getElementById("SXDate")
    if (obj){
	    obj.value=gettoday();
    }
    
	//输血类型
	var obj=document.getElementById("xxFlagType")
    if (obj){
	   obj.size=1;
	   obj.multiple=false;	
	   obj.options[0]=new Option(t['CGSX'],"CGSX");
	   obj.options[1]=new Option(t['CGZL'],"CGZL");
	   obj.options[2]=new Option(t['JJSX'],"JJSX");
	   obj.options[3]=new Option(t['DLSX'],"DLSX");	   
	   obj.options[4]=new Option(t['TSPX'],"TSPX");	   
	}

	//既往输血史
	var obj=document.getElementById("Anamnesis")
    if (obj){
	   obj.size=1;
	   obj.multiple=false;	
	   obj.options[0]=new Option(t['N'],"N");
	   obj.options[1]=new Option(t['Y'],"Y");
	}	
	//输血反应
	var obj=document.getElementById("Response")
    if (obj){
	   obj.size=1;
	   obj.multiple=false;	
	   obj.options[0]=new Option(t['N'],"N");
	   obj.options[1]=new Option(t['Y'],"Y");
	}	
	//药物过敏史
	var obj=document.getElementById("Allergic")
    if (obj){
	   obj.size=1;
	   obj.multiple=false;	
	   obj.options[0]=new Option(t['N'],"N");
	   obj.options[1]=new Option(t['Y'],"Y");
	}	
	//输血同意书
	var obj=document.getElementById("Agree")
    if (obj){
	   obj.size=1;
	   obj.multiple=false;	
	   obj.options[0]=new Option(t['AgreeY'],"AgreeY");
	   obj.options[1]=new Option(t['AgreeN'],"AgreeN");
	}	

}


function BodyUnLoadHandler(){

}


function PatientNoKeyDown(e)	{
	var key = websys_getKey(e);
	if ((key==13)){
  	    var PatientID =document.getElementById("Debtor");
	    if ((PatientID)&&(PatientID.value!="")) {
		   var PatNo=PatientID.value;
		   var j,z;
		   z=8-PatNo.length;
		   for(j=1;j<=z;j++){ PatNo="0"+PatNo; } 
    	   SetPatientInfo(PatNo);
    	}  
	}
}


function SetPatientInfo(PatNo)	{
	var GetPatInfo=document.getElementById('GetPatDetail');
	if (GetPatInfo) {var encmeth=GetPatInfo.value} else {var encmeth=''};
	var myExpStr="";
	var PatInfoStr=cspRunServerMethod(encmeth,'','',PatNo);
	//alert(PatInfoStr);
	if (PatInfoStr=='') {return 0;}
	var PatInfo=PatInfoStr.split("^");
	//tadmId.value=PatInfo[0];
	
	PatientID.value=PatInfo[1];
	PatDep.value=PatInfo[2];
	PatSex.value=PatInfo[4];
	PatName.value=PatInfo[5];
    PatsafetyNetCardNo.value=PatInfo[6];
	PatBed.value=PatInfo[7];
	PatAge1.value=PatInfo[8];
	PatAge2.value=PatInfo[9];
	PatCardID.value=PatInfo[13];
	PatType.value=PatInfo[14];
	PatCountry.value=PatInfo[15];
	PatPeople.value=PatInfo[16];
	PatDiagnose.value=PatInfo[17];
	PatApanage.value=PatInfo[18];
    
    //getLabInfo(PatientID.value);

    //getOrderItem();
  
}
/*
function getLabInfo(PatNo){
	if (labObj) {
		var obj=labObj.document.getElementById("GetLabInfo");
		if (obj) {var encmeth=obj.value} else {var encmeth=''};
		var myExpStr="";
		var LabInfoStr=cspRunServerMethod(encmeth,myExpStr,myExpStr,PatNo);
		var LabInfo=LabInfoStr.split("^");
		
		LabBloodGroup.value=LabInfo[0];
		LabBloodRh.value=LabInfo[1];
		//LabOtherBlood.value=LabInfo[2];
		LabRBC.value=LabInfo[2];
		LabHCT.value=LabInfo[3];
		LabHb.value=LabInfo[4];
		LabPLT.value=LabInfo[5];
		LabALT.value=LabInfo[6];
		LabHBeAg.value=LabInfo[7];
		LabHBsAg.value=LabInfo[8];
		LabAntiHBs.value=LabInfo[9];
		LabAntiHBe.value=LabInfo[10];
		LabAntiHBc.value=LabInfo[11];
		LabAntiHCV.value=LabInfo[12];
		LabAntiHIV.value=LabInfo[13];
		LabMD.value=LabInfo[14];
	}
}
*/
function getOrderItem(){
	getOrderItem_click();
}


function PrintSXSQD(){	

    if (PatientID.value=="") {return ;}
    
	labObj=parent.frames["DHCBldReqLabInfo"];
	LabBloodGroup=labObj.document.getElementById("BloodGroup");
	LabBloodRh=labObj.document.getElementById("BloodRh");
	LabOtherBlood=labObj.document.getElementById("OtherBlood");
	LabRBC=labObj.document.getElementById("RBC");
	LabHCT=labObj.document.getElementById("HCT");
	LabHb=labObj.document.getElementById("Hb");
	LabPLT=labObj.document.getElementById("PLT");
	LabALT=labObj.document.getElementById("ALT");
	LabHBeAg=labObj.document.getElementById("HBeAg");
	LabHBsAg=labObj.document.getElementById("HBsAg");
	LabAntiHBs=labObj.document.getElementById("AntiHBs");
	LabAntiHBe=labObj.document.getElementById("AntiHBe");
	LabAntiHBc=labObj.document.getElementById("AntiHBc");
	LabAntiHCV=labObj.document.getElementById("AntiHCV");
	LabAntiHIV=labObj.document.getElementById("AntiHIV");
	LabMD=labObj.document.getElementById("MD");
  
    SaveHistroy();

    var xlApp,obook,osheet,xlsheet,xlBook
	var patname,patno,patdw,paymode,payamt,payamtdx,temp	    	    
	var path,dep,patdep,depname,admdate,admdate1,admdate2
	var sexdesc,telph,maritaldesc,admage,address
	var cardno,workst,depcode
	var sDate,psDate;
	var i;
	var tstr,z=0;
	
	var objtbl=document.getElementById('tDHCBldRequest');
    if (objtbl.rows.length==0) {return ;}
    var rows=objtbl.rows.length-1
	for(i=1;i<=rows;i++){
		if (document.getElementById("tCheckz"+i).checked){z++;}
	}	
	if (z==0) {
		alert(t['01']);  //没有选择医嘱
		return ;
	}
	
	var getpath=document.getElementById('getpath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	path=cspRunServerMethod(encmeth,'','');
	var Template=path+"DHCBldRequest.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	 
	xlsheet.cells(3,2).value=PatType.value;
	xlsheet.cells(3,9).value=PatientID.value;
	xlsheet.cells(3,5).value=PatsafetyNetCardNo.value;
    
 	sDate=RqSXDate.value;
	psDate=sDate.split("/");
	sDate=psDate[2]+"-"+psDate[1]+"-"+psDate[0];

	xlsheet.cells(6,3).value=sDate;
	xlsheet.cells(6,7).value=t[RqxxFlagType.value];
	xlsheet.cells(9,2).value=PatName.value;
	xlsheet.cells(9,4).value=PatSex.value;
	xlsheet.cells(9,6).value=PatApanage.value;
	xlsheet.cells(10,2).value=PatDep.value;
	xlsheet.cells(10,6).value=PatBed.value;
	xlsheet.cells(11,2).value=PatAge1.value;
	xlsheet.cells(11,6).value=PatAge2.value;
	xlsheet.cells(12,2).value=PatCardID.value;
	xlsheet.cells(12,6).value=PatPeople.value;
	xlsheet.cells(13,2).value=PatDiagnose.value;
	xlsheet.cells(13,6).value=PatCountry.value;
    xlsheet.cells(14,2).value=t[RqAnamnesis.value];
    xlsheet.cells(14,4).value=RqGestation.value;
    xlsheet.cells(14,6).value=RqPregnant.value;
//    xlsheet.cells(15,2).value=t[RqResponse.value];
    //if (RqImmunotherapy.checked) {var str=t["Ok"]} else {var str=t["Concel"]};
    //xlsheet.cells(15,6).value=str;
    //xlsheet.cells(16,2).value=t[RqAllergic.value];
    
    var st="";
    if (RqIntentSSBX.checked) {st=st+t["SSBX"]+";"};
	if (RqIntentZLYX.checked) {st=st+t["ZLYX"]+";"};
	if (RqIntentYXYZ.checked) {st=st+t["YXYZ"]+";"};
	if (RqIntentBZXL.checked) {st=st+t["BZXL"]+";"};
	if (RqIntentJZPX.checked) {st=st+t["JZPX"]+";"};
    xlsheet.cells(15,2).value=st;
	
	var k=0;
	for(i=1;i<=rows;i++){
		if (document.getElementById("tCheckz"+i).checked){
			tstr="";
			tstr=document.getElementById("tOrderItemz"+i).innerText+"   ";
			tstr=tstr+document.getElementById("tVolumez"+i).value;
			tstr=tstr+document.getElementById("tUnitz"+i).innerText;
			k++;
			xlsheet.cells(16+k,2).value=tstr;
		}	
	}
	
	if (RqRadiation.checked) {xlsheet.cells(16,2).value=t["Ok"];} else {xlsheet.cells(16,2).value=t["Concel"];}
	if (RqLeucocyte.checked) {xlsheet.cells(16,6).value=t["Ok"];} else {xlsheet.cells(16,6).value=t["Concel"];}
	//xlsheet.cells(31,3).value=t[RqAgree.value];  ;患者签字
	
	//labInfo
	xlsheet.cells(11,8).value=LabBloodGroup.value;
	xlsheet.cells(13,8).value=LabBloodRh.value;
	//xlsheet.cells(15,8).value=LabOtherBlood.value;
	xlsheet.cells(15,9).value=LabRBC.value;
	xlsheet.cells(16,9).value=LabHCT.value;
	xlsheet.cells(17,9).value=LabHb.value ;
	xlsheet.cells(18,9).value=LabPLT.value ;
	xlsheet.cells(19,9).value=LabALT.value ;
	//xlsheet.cells(23,9).value=LabHBeAg.value ;
	xlsheet.cells(20,9).value=LabHBsAg.value ;
	//xlsheet.cells(25,9).value=LabAntiHBs.value ;
	//xlsheet.cells(26,9).value=LabAntiHBe.value ;
	//xlsheet.cells(27,9).value=LabAntiHBc.value ;
	xlsheet.cells(21,9).value=LabAntiHCV.value ;
	xlsheet.cells(22,9).value=LabAntiHIV.value ;
	xlsheet.cells(23,9).value=LabMD.value ;
	
	xlsheet.cells(34,2).value="";   //gUsername;
	sDate=gettoday();
	psDate=sDate.split("/");
	var sTime="";
	sTime=getnowtime();
	sDate=psDate[2]+"-"+psDate[1]+"-"+psDate[0]+" "+sTime;
	xlsheet.cells(34,8).value=sDate;

	
    xlApp.Visible=true;
    xlsheet.PrintPreview();
    xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    xlsheet=null	
}

function SaveHistroy(){
	var pList,pOrdList;
	pList= "^" + PatientID.value + "^" + "1";   //childsub
	pList = pList + "^";    //Group
	/* 预定输血日期 */
	var tDate,pDate;
	tDate=RqSXDate.value
	pDate=tDate.split("/");
	tDate=pDate[2]+"-"+pDate[1]+"-"+pDate[0]
	pList = pList + "^" + tDate;
	/* 输血类型 */
	pList = pList + "^" + RqxxFlagType.value;
	/* 其它血型 */
	pList = pList + "^" + LabOtherBlood.value;
	//属地
	var Apanage="";
	if (PatApanage.value=="本市") {Apanage = "BS";}
	if (PatApanage.value=="外阜") {Apanage = "WF";}
	pList = pList + "^" + Apanage
	//既往输血史RqAnamnesis.value
	pList = pList + "^" + RqAnamnesis.value;
	//输血反应
	pList = pList + "^" + RqResponse.value;
	//是否干细胞移植病人
	if (RqImmunotherapy.checked) {pList = pList + "^" + "Y";} else {pList = pList + "^" + "N";}
	//'药物过敏史
	pList = pList + "^" + RqAllergic.value;
	 // /* '孕'产 */
	pList = pList + "^" + RqGestation.value;   
	pList = pList + "^" + RqPregnant.value;   
	// /*'辐照血 */
	if (RqRadiation.checked) {pList = pList + "^" + "Y";} else {pList = pList + "^" + "N";}
	// /* '滤除白细胞 */
	if (RqLeucocyte.checked) {pList = pList + "^" + "Y";} else {pList = pList + "^" + "N";}
	// /* '输血同意书  */
	if (RqAgree.value=="AgreeY") {pList = pList + "^" + "Y";} else {pList = pList + "^" + "N";}
	// /*'申请用户'日期'时间 */
	pList = pList + "^" + gUser;
	pList = pList + "^";
	pList = pList + "^";
	//'输血目的
	var st="";
	if (RqIntentSSBX.checked) {st=st+",SSBX"};
	if (RqIntentZLYX.checked) {st=st+",ZLYX"};
	if (RqIntentYXYZ.checked) {st=st+",YXYZ"};
	if (RqIntentBZXL.checked) {st=st+",BZXL"};
	if (RqIntentJZPX.checked) {st=st+",JZPX"};
	pList = pList + "^" + st;
	//'检验数据
	pList = pList + "^" + LabBloodGroup.value;
	pList = pList + "^" + LabBloodRh.value;
	pList = pList + "^" + LabRBC.value;
	pList = pList + "^" + LabHCT.value;
	pList = pList + "^" + LabHb.value ;
	pList = pList + "^" + LabPLT.value ;
	pList = pList + "^" + LabALT.value ;
	pList = pList + "^" + LabHBeAg.value ;
	pList = pList + "^" + LabAntiHBs.value ;
	pList = pList + "^" + LabHBsAg.value ;
	pList = pList + "^" + LabAntiHBe.value ;
	pList = pList + "^" + LabAntiHBc.value ;
	pList = pList + "^" + LabAntiHCV.value ;
	pList = pList + "^" + LabAntiHIV.value ;
	pList = pList + "^" + LabMD.value ;
	//alert(pList);
	//备血医嘱
	pOrdList=""
	var objtbl=document.getElementById('tDHCBldRequest');
    if (objtbl.rows.length>0) {
	    var rows=objtbl.rows.length-1
		var i;
		for(i=1;i<=rows;i++){
			if (document.getElementById("tCheckz"+i).checked){
				pOrdList=pOrdList+ document.getElementById("tRowIdz"+i).value;
				pOrdList=pOrdList+ "\\" +document.getElementById("tLabnoz"+i).innerText;
				pOrdList=pOrdList+ "\\" +document.getElementById("tOrderItemz"+i).innerText;
				pOrdList=pOrdList+ "\\" +document.getElementById("tVolumez"+i).value;
				pOrdList=pOrdList + document.getElementById("tUnitz"+i).innerText+"^";
			}	
		}
    }
    
    if (pOrdList=='') {return;}
    //保存数据
    var ins=document.getElementById('HisSave');
	if (ins) {var encmeth=ins.value} else {var encmeth=''};
	var rtn=cspRunServerMethod(encmeth,"","",PatientID.value,gUser,pList,pOrdList);
    return rtn
}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;