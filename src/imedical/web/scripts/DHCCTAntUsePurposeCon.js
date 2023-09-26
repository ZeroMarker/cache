function BodyLoadHandler() {
$('BtnAdd').onclick=BtuAdd_Click;
$('BtnDelete').onclick = BtnDelete_Click;
$('BtnClear').onclick=BtnClear_Click
$('BtnUpdate').onclick=BtnUpdate_Click
}
function LookUpAUR(str)
{
	var AUR=str.split("^");
	var obj=document.getElementById("DTAUPAURID");
	obj.value=AUR[1];	
	document.getElementById("DTAUPItemID").value=""
	document.getElementById("DTAUPItem").value=""
}
//�������Ŵ�
function LookUpPurpse(str)
{
	var Item=str.split("^");
	var obj=document.getElementById("DTAUPItemID");
	obj.value=Item[1];
}
function BtuAdd_Click(){
	var rtn=CheckNull();
    if (!rtn){
	    return false;
    } 
	var DTAUPCode=DHCC_GetElementData("DTAUPCode")
	var DTAUPDesc=DHCC_GetElementData("DTAUPDesc")
	var DTAUPAURID=DHCC_GetElementData("DTAUPAURID")
	var DTAUPFlag=DHCC_GetElementData("DTAUPActiveFlag")
	var DTAUPReqStr=DHCC_GetElementData("DTAUPReqStr")
	var DTAUPNote=DHCC_GetElementData("DTAUPNote")
	var DTAUPItemID=DHCC_GetElementData("DTAUPItemID")
	if(DTAUPFlag==true){var Flag="Y"}
	else  {var Flag="N"}
		if ((DTAUPNote!="")&&(DTAUPNote.length>30)){
		alert("��ע�ַ����ɳ���30���ַ�");
		return;
		}
	var ParseInfo=DTAUPCode+"^"+DTAUPDesc+"^"+DTAUPAURID+"^"+Flag+"^"+DTAUPReqStr+"^"+DTAUPNote+"^"+DTAUPItemID
   var BtnAddClass=$('BtnAddClass');
   if (BtnAddClass) {var encmeth=BtnAddClass.value} else {var encmeth=''};
   var returnvalue=cspRunServerMethod(encmeth,ParseInfo);
   if(returnvalue==100)alert("�����ظ�");
   else if(returnvalue==0) alert("��ӳɹ�");
   else alert("���ʧ��")
   var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCCTAntUsePurposeCon";
   location.href=lnk
	
}
function BtnDelete_Click()
{
	var ID=DHCC_GetElementData("DTAUPID")
	if (ID=="") 
	{
		alert("δѡ������")
		return false
	}
	
	var BtnDeleteclass=$('BtnDeleteClass');
if (BtnDeleteclass) {var encmeth=BtnDeleteclass.value} else {var encmeth=''};
var returnvalue=cspRunServerMethod(encmeth,ID);
 if(returnvalue==0) alert("ɾ���ɹ�");
 else(alert("ɾ��ʧ��"))
var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCCTAntUsePurposeCon";
   location.href=lnk
}
function BtnUpdate_Click(){
    var obj=document.getElementById('DTAUPID')
	if(obj) DTAUPID=obj.value;
	if(DTAUPID=="")
	{
		alert('��ѡ��һ��') 
		return;
	}
	if(!CheckNull()) return false ; //add by qp 2014-04-24
	var DTAUPCode=DHCC_GetElementData("DTAUPCode")
	var DTAUPDesc=DHCC_GetElementData("DTAUPDesc")
	var DTAUPAURID=DHCC_GetElementData("DTAUPAURID")
	var DTAUPActiveFlag=DHCC_GetElementData("DTAUPActiveFlag")
	var DTAUPReqStr=DHCC_GetElementData("DTAUPReqStr")
	var DTAUPNote=DHCC_GetElementData("DTAUPNote")
	var DTAUPItemID=DHCC_GetElementData("DTAUPItemID")
	if(DTAUPActiveFlag==true){var Flag="Y"}
	else  {var Flag="N"}
		if ((DTAUPNote!="")&&(DTAUPNote.length>30)){
			alert("��ע�ַ����ɳ���30���ַ�");
			return;
		}
	var ParseInfo=DTAUPID+"^"+DTAUPCode+"^"+DTAUPDesc+"^"+DTAUPAURID+"^"+Flag+"^"+DTAUPReqStr+"^"+DTAUPNote+"^"+DTAUPItemID
   var BtnAddClass=$('BtnUpdateClass');
   if (BtnAddClass) {var encmeth=BtnAddClass.value} else {var encmeth=''};
   var returnvalue=cspRunServerMethod(encmeth,ParseInfo);
    if(returnvalue==0) alert("���³ɹ�");
   else alert("����ʧ��")
   var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCCTAntUsePurposeCon";
   location.href=lnk
	
}
function BtnClear_Click()
{
  $('DTAUPID').value = '';
  $('DTAUPCode').value = '';
  $('DTAUPDesc').value = '';
  $('DTAUPAUR').value = '';
  $('DTAUPAURID').value = '';
  $('DTAUPActiveFlag').checked = false;
  $('DTAUPReqStr').value = '';
  $('DTAUPNote').value = '';
  $('DTAUPItemID').value='';
  $('DTAUPItem').value='';
}
var SelectedRow = 0;
function SelectRowHandler()
{
	BtnClear_Click()
	var eSrc=window.event.srcElement;
	var objtbl=$('tDHCCTAntUsePurposeCon');
	if(!objtbl)
	{
	   objtbl=$('tDHCCTAntUsePurposeCon0');
	}
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;	
	if (!selectrow) return;
	
   var DTAUPID=$('DTAUPID');
   var DTAUPCode=$('DTAUPCode');
   var DTAUPDesc=$('DTAUPDesc');
   var DTAUPAUR=$('DTAUPAUR');
   var DTAUPAURID=$('DTAUPAURID');
   var DTAUPActiveFlag=$('DTAUPActiveFlag');
   var DTAUPReqStr=$('DTAUPReqStr');
   var DTAUPNote=$('DTAUPNote');
   var DTAUPItemID=$('DTAUPItemID');
   var DTAUPItem=$('DTAUPItem');
		
var Sel_DDTAUPID=$('DDTAUPIDz'+selectrow);

var Sel_DDTAUPCode=$('DDTAUPCodez'+selectrow);

var Sel_DDTAUPDesc=$('DDTAUPDescz'+selectrow);
var Sel_DDTAUPAURID=$('DDTAUPAURIDz'+selectrow);
var Sel_DDTAUPAUR=$('DDTAUPAURz'+selectrow);
var Sel_DDTAUPActiveFlag=$('DDTAUPActiveFlagz'+selectrow);
var Sel_DDTAUPReqStr=$('DDTAUPReqStrz'+selectrow);
var Sel_DDTAUPNote=$('DDTAUPNotez'+selectrow);
var Sel_DDTAUPItemID=$('DDTAUPItemIDz'+selectrow);
var Sel_DDTAUPItem=$('DDTAUPItemz'+selectrow);
	if (rowObj.className != 'clsRowSelected')
	{
	//$('BtnUpdate').disabled=true;	
	//$('BtnClear').disabled=true;	
		SelectedRow = 0;
     BtnClear_Click()

	}
	else
	{
	//$('BtnUpdate').disabled=false;	
	//$('BtnClear').disabled=false;	
DTAUPID.value = Sel_DDTAUPID.value;
DTAUPAURID.value=Sel_DDTAUPAURID.value;
DTAUPCode.value = Sel_DDTAUPCode.innerText;
if (Sel_DDTAUPDesc.innerText.indexOf("-")>=0){
	DescArr=Sel_DDTAUPDesc.innerText.split("-")
	DTAUPDesc.value =DescArr[2];
	}else{
		DTAUPDesc.value=Sel_DDTAUPDesc.innerText
		}
DTAUPAUR.value=Sel_DDTAUPAUR.innerText;
if(Sel_DDTAUPActiveFlag.innerText=="Y") DTAUPActiveFlag.checked=true
else DTAUPActiveFlag.checked=false
DTAUPReqStr.value=Sel_DDTAUPReqStr.innerText;
DTAUPNote.value=Sel_DDTAUPNote.innerText;	
DTAUPItemID.value=Sel_DDTAUPItemID.value;
DTAUPItem.value=Sel_DDTAUPItem.innerText;
	SelectedRow = selectrow;
	}


}
//��֤�����ֶ�
function CheckNull(){

if ($('DTAUPCode').value=="")
{
	alert("�����������");
	$('DTAUPCode').focus();
	return false;
}	

if ($('DTAUPDesc').value=="")
{
	alert("������������");
	$('DTAUPDesc').focus();
	return false;
}	
if ($('DTAUPAUR').value=="")
{
	alert("ʹ��Ŀ�Ĵ����������");
	$('DTAUPAUR').focus();
	return false;
}	
if($('DTAUPItem').value=="")
{
	alert("ʹ��Ŀ�������������");
	$('DTAUPItem').focus();
	return false;
}
	return true;
}
document.body.onload = BodyLoadHandler;