var PatTypeRowid="";
var AdmRowid;
var SelectedRowOrder;
function BodyLoadHandler() {
	//alert("df")
	var obj=document.getElementById("Confirm");
	if (obj) obj.onclick=Update_click;
	ShowParInfo()
	var obj=document.getElementById("Quit");
	if (obj) obj.onclick=Quit_click;
	if (document.all.InsuranceNo)
	{
		document.all.InsuranceNo.style.imeMode = "disabled";
	}
	websys_setfocus('InsuranceNo');							 //���Ĭ�ϵ�ҽ������
	EmployeeNoVisit("none")
}

function Quit_click(){
	window.close();
}

function Update_click(){
	//���벡�������޸���־,add by xp,2008-05-10    
	//*********���˻�����Ϣ-���������޸���־-------�޸�ǰ�Ĳ��˻�������

	if(PatTypeRowid==""){
		alert(t["02"])
		return
  		}
	var Parobj=window.opener
	var objRegNo=Parobj.document.getElementById("RegNo")
	var CardNoObj=Parobj.document.getElementById("CardNo")
	var InsuranceNoObj=document.getElementById("InsuranceNo")
	var PatName=Parobj.document.getElementById('TabPatNamez'+Parobj.SelectedRow).innerText;
	var GetDetail=document.getElementById('GetPatOtherInfo');
    var EmployeeNoFlag=CheckEmployeeNo();
    if (!EmployeeNoFlag) return;
	var YBFlag=checkPatYBCode();
	if (!YBFlag) return;
	var Rtn=CheckMedNo(GetDetail.value);
    if (!Rtn){return;} 	
  	if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
	var PatOtherInfoOld=cspRunServerMethod(encmeth,objRegNo.value)
	//*********�޸Ĳ��˻�������
  		var GetDetail=document.getElementById('Commit');
  		if(PatTypeRowid==""){
  			alert(t["02"])
  			return
  		}
  		
  			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			if (cspRunServerMethod(encmeth,'CommitEvent','',PatTypeRowid,AdmRowid,InsuranceNoObj.value)=='0') {
		//obj.className='';
		}
	//*********���˻�����Ϣ-���������޸���־-------�޸ĺ�Ĳ��˻�������
	var Parobj=window.opener
	var objRegNo=Parobj.document.getElementById("RegNo")
	var GetDetail=document.getElementById('GetPatOtherInfo');  		
  	if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
	var PatOtherInfoNew=cspRunServerMethod(encmeth,objRegNo.value)
	var UPPuserDr=session['LOGON.USERID'];
	var ObjPatLog=document.getElementById('PatInformLog');  		
  	if (ObjPatLog) {var encmeth=ObjPatLog.value} else {var encmeth=''};
	var obj=document.getElementById('PatientID');
	if(obj) PatientID=obj.value
  	//alert(CardNoObj.value+"          "+PatName+"          "+PatOtherInfoOld+"          "+PatOtherInfoNew+"          "+UPPuserDr);
	var PatTypeLog=cspRunServerMethod(encmeth,CardNoObj.value,PatName,PatOtherInfoOld,PatOtherInfoNew,UPPuserDr,PatientID)
	if (PatTypeLog!=0) {alert("�޸Ĳ���������־ʧ��,����ϵ����Ա!");}

}

///�ж��Ƿ���Ҫ��дҽ����
function checkPatYBCode()
{
	var myobj=document.getElementById('descz'+SelectedRowOrder);
	var PatYBCode="";
	var PatYBCodeObj=document.getElementById('InsuranceNo');
	if (PatYBCodeObj) PatYBCode=PatYBCodeObj.value;
  if(myobj) {
  	var myPatType=myobj.innerText;
  }else{
  	var myPatType="";
  }
	if (myPatType=="") {
		alert("��ѡ�������ͣ�");
		return false;
	}
	var Rowid=""
	var RowidObj=document.getElementById('Rowidz'+SelectedRowOrder);
	if (RowidObj) Rowid=RowidObj.innerText;
	if (Rowid=="") {
		alert("δ��ȷ��ȡ��������Rowid��");
		return false;
	}
	var rtn=tkMakeServerCall("web.DHCBL.CARD.UCardRefInfo","GetInsurFlag",Rowid);
	if ((rtn==0)&&(PatYBCode!="")) {
		alert("��ҽ�����ˣ�ҽ�����Ų�����")
		websys_setfocus('InsuranceNo');
		return false;
	}
	if((rtn!=0)&&(PatYBCode=="")) {
		alert("ҽ�����ˣ�����д��ȷ��ҽ������")
		websys_setfocus('InsuranceNo');
		return false;
	}
	return true;
}

function PatYBCodekeydownClick()
{
	return true;
	/*
	//����Ϊ��������,��׼�治����
	//ҽ���źϷ��Ե��ж�
	PatTypeDesc=document.getElementById('descz'+SelectedRowOrder).innerText;
	var myobj=document.getElementById('InsuranceNo');
	if ((PatTypeDesc!="ҽ��")&&(PatTypeDesc!="ҽ���ز�")) {	
		var objVal=document.getElementById('InsuranceNo');
		if (objVal.value=='')  {return true;}else {	
			alert("����������ҽ���Ų���");
			return false;
		}
	}else{
		if (myobj.value=="99999999999S") return true;
		var tmp=myobj.value;
		var length=tmp.length;
		if(length!=12){	//alert(length);
			alert("ҽ����λ������?");
			return false;
		}
		var numtmp=tmp.substring(0,length-1);
		var numflag=isNumber(numtmp);
		if ((numflag!=true)||((tmp.substring(length-1,length)!="s")&&(tmp.substring(length-1,length)!="S"))){
			alert("ҽ���ַ�����?");
			return false;
		}else{
			return true;     //  	alert("aaaaaaaaaaaaaa")   //  00000000005s
		}
	}
	*/
}

function isNumber(objStr){
 strRef = "-1234567890.";
 for (i=0;i<objStr.length;i++) {
  tempChar= objStr.substring(i,i+1);
  if (strRef.indexOf(tempChar,0)==-1) {return false;}
 }
 return true;
}


function CheckMedNo()
{
	
	var obj=document.getElementById('PatientID');
	if(obj) var PapmiDr=obj.value;
	if (PapmiDr=="") {return false;}
	var GetDetail=document.getElementById('GetUniInfoMethod');
	if (GetDetail) {var encmeth=GetDetail.value;} else {var encmeth=''};
	
	//ҽ���ֲ��
	var obj=document.getElementById('InsuranceNo');
	if(obj) var InsuNo=obj.value
	if ((InsuNo!="")&&(InsuNo!="99999999999S")&&(InsuNo!="99999999999s")) {
		Rtn=cspRunServerMethod(encmeth,PapmiDr,"InsuNo",InsuNo)
		if(Rtn>0){	
			alert("ҽ���ֲ���ظ�")
			return false
		}
	}
	return true
}

function CommitEvent(value) {
	try {
		if (value!=0){	
			// ��������
			alert(t["03"])			
		}else{
			alert(t["04"])
			window.close()
		}
	} catch(e) {};
}	

function ShowParInfo(){
	var Parobj=window.opener
	var objRegNo=Parobj.document.getElementById("RegNo")
	var obj=document.getElementById('PatientID');
	if(obj) obj.value=Parobj.document.getElementById("PatientID").value
	var GetDetail=document.getElementById('GetPatInfo');  		
  	if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
	var retcode=cspRunServerMethod(encmeth,objRegNo.value)
	
	var Subretcode=retcode.split(",");
  	var PatBisicInfo=Subretcode[0]+"  "+Subretcode[1];
	var InsuranceNoObj=document.getElementById('InsuranceNo'); 
	var obj=document.getElementById("PatInfo");
	if(obj) obj.value=PatBisicInfo
	var InsuranceNo=Subretcode[2] ;	 //ҽ����	
	InsuranceNoObj.value=InsuranceNo;
	
	var dep=Parobj.document.getElementById('Deptz'+Parobj.SelectedRow).innerText;
	var doc=Parobj.document.getElementById('Doctorz'+Parobj.SelectedRow).innerText;
	AdmRowid=Parobj.document.getElementById('AdmIdz'+Parobj.SelectedRow).value;
	//*********ȡ����ѱ�,modified by xp,20080510
	var AdmInformObj=document.getElementById('GetAdmInfo');  		
  	if (AdmInformObj) {var encmeth=AdmInformObj.value} else {var encmeth=''};
	var AdmInformStr=cspRunServerMethod(encmeth,AdmRowid)
	var obj=document.getElementById("AdmInfo");
	if (obj) obj.value=dep + " " + doc+"   "+AdmInformStr
	//*********ȡ����ѱ�,modified by xp,20080510
}


function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCOPChgAdmreason');

	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if(SelectedRowOrder==selectrow){
		SelectedRowOrder=""
		EmployeeNoVisit("none")
	}else{
		SelectedRowOrder=selectrow;
		PatTypeRowid=document.getElementById('Rowidz'+selectrow).innerText;
		var myobj=document.getElementById('descz'+SelectedRowOrder);
	  	var myPatType=myobj.innerText;
	  	if (myPatType.indexOf('��Ժ')>=0){
		    EmployeeNoVisit("")
		}else{
		    EmployeeNoVisit("none")
		}
	}
	
		
}
function CheckEmployeeNo()
{
	var myobj=document.getElementById('descz'+SelectedRowOrder);
  	var myPatType=myobj.innerText;
  	if (myPatType.indexOf('��Ժ')>=0){
	  	var EmployeeNo=document.getElementById("EmployeeNo").value;
			if (EmployeeNo==""){
				alert(t["noEmployeeNo"]);
				websys_setfocus('EmployeeNo');
				return false;
			}
			var curPAPMIRowID=tkMakeServerCall("web.DHCBL.CARDIF.ICardPaPatMasInfo","GetPAPMIRowIDByEmployeeNo",EmployeeNo);
			var name=curPAPMIRowID.split("^")[1];
			var UserName=curPAPMIRowID.split("^")[2];
			curPAPMIRowID=curPAPMIRowID.split("^")[0];
			if (curPAPMIRowID=="0"){
				alert("���Ų���ȷ,���ʵ����");
				websys_setfocus('EmployeeNo');
				return false;
			}
			var PAPMIRowID=document.getElementById("PatientID").value;
			if ((PAPMIRowID!=curPAPMIRowID)&&(curPAPMIRowID!="")){
				alert("�˹����Ѿ���'"+name+"'����,�����Ⱥ�ʵ����");
				websys_setfocus('EmployeeNo');
				return false;
			}
			var GetPatInfo=document.getElementById("PatInfo").value
		    var Name=GetPatInfo.split("   ")[1]
			if (UserName!=Name){
				alert("�˹��Ŷ�Ӧ����Ϊ'"+UserName+"'����¼��������һ��");
				websys_setfocus('Name');
				return false;
			}
	}
	return true;
}
function EmployeeNoVisit(Flag)
{
	var obj=document.getElementById("EmployeeNo");
    if (obj) obj.style.display =Flag; 
    var obj=document.getElementById("c"+"EmployeeNo");
    if (obj) obj.style.display =Flag;
}
document.body.onload = BodyLoadHandler;