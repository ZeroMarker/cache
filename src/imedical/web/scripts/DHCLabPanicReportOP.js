///DHCLabPanicReportOP.js

var LabEpis=document.getElementById('LabEpis');
var PhoneNo=document.getElementById('PhoneNo');
var Password=document.getElementById('Password');
var ChkUser=document.getElementById('ChkUser');
var TransRemark=document.getElementById('TransRemark');
var Finished=document.getElementById('Finished');
var LinkPerson=document.getElementById('LinkPerson');

var gUser=session['LOGON.USERID']
var gUsername=session['LOGON.USERNAME']
var gUsercode=session['LOGON.USERCODE']

function BodyLoadHandler() {
   var obj=document.getElementById('DocCode');
   if (obj) obj.onblur=GetDocName;
   var obj=document.getElementById('Save');
   if (obj) obj.onclick=SaveIPTrans;
}

function GetDocName()
{
	var getpath=document.getElementById('GetDocName');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	DocName.value=cspRunServerMethod(encmeth,'','',DocCode.value);
}
//���洦���¼
function SaveIPTrans(){
	var pwd=Password.value;
	var usr=ChkUser.value;
	if (usr=="")
	{
		alert("����������û��I");
		return;
	}
	if (pwd=="")
	{
		alert("�������������I");
		return;
	}
	var getpath=document.getElementById('CheckPwd');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	var RetValue=cspRunServerMethod(encmeth,'','',usr,pwd);
	//
	if (RetValue!="0"){
		alert("�������I");
		return;
	}
	var RowIdStr="";
	var objtbl=document.getElementById('tDHCLabPanicReportOP');
    if (objtbl.rows.length>0) {
	    var rows=objtbl.rows.length-1;
		var i;
		for(i=1;i<=rows;i++){
			//alert(document.getElementById("ReportIdz"+i).innerText);
			RowIdStr=RowIdStr+document.getElementById("ReportIdz"+i).innerText+",";
		}
    }
	//alert(RowIdStr);
    //��������
    var Status="C";
    if (Finished.checked){Status="F";}
    var TransStr="^"+LinkPerson.value+"^"+PhoneNo.value+"^"+TransRemark.value;
    var ins=document.getElementById('SaveOPTrans');
	if (ins) {var encmeth=ins.value} else {var encmeth=''};
	var rtn=cspRunServerMethod(encmeth,"","",RowIdStr,usr,TransStr,Status);
	if (rtn=="0"){
		//alert("����ɹ�!");
		alert(t['S01']);  //����ɹ�
		return;
	}
	else
	{
		//alert("����ʧ��!�������:"+ret);
		alert(t['F01']+"�������:"+rtn);  //����ʧ��
		return ;
	}
}

function BodyUnLoadHandler(){
}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;