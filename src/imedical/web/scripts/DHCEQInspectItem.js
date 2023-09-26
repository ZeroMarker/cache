//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	InitUserInfo();
	InitPage();
	SetBStatus();
}
function InitPage(){
	var BAobj=document.getElementById("BAdd");
	if (BAobj) BAobj.onclick=BAdd_click;
	
	var BUobj=document.getElementById("BUpdate");
	if (BUobj) BUobj.onclick=BUpdate_click;
	
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;
	
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;	

	KeyUp("InspectItem^InspectPart");
	Muilt_LookUp("InspectItem^InspectPart");
}
function BClose_Click() 
{
	window.close();
}

//�����������������,�������ƹ̶�
var SelectedRow = 0;
function SelectRowHandler()	{
	//�������Ϊ�̶�д��
	
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	
	var objtbl=document.getElementById('tDHCEQInspectItem'); //�õ����   t+�������
	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //��ǰѡ����
	//�õ�������
	var obj=document.getElementById('RowID');
	var obj1=document.getElementById('InspectDR');
	var obj2=document.getElementById('InspectPartDR');
	var obj3=document.getElementById('InspectItemDR');
	var obj4=document.getElementById('InspectPart');
	var obj5=document.getElementById('InspectItem');
	
	var obj6=document.getElementById('InspectState');
	var obj7=document.getElementById('Remark');
	//!selectrow
	if (selectrow==SelectedRow){
		obj.value='';
		obj2.value='';
		obj3.value='';
		obj4.value='';
		obj5.value='';
		obj6.value='';
		obj7.value='';
		SelectedRow=0;
		ChangeStatus(false);
		return;}
	ChangeStatus(true);
	FillData(selectrow);
	SelectedRow = selectrow;
}
function FillData(selectrow)
{
	var RowID=document.getElementById("TRowIDz"+selectrow).value;
	SetElement("RowID",RowID);
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=5;
	SetElement("InspectDR",list[0]);
	SetElement("Inspect",list[sort+0]);
	SetElement("InspectPartDR",list[1]);
	SetElement("InspectPart",list[sort+1]);
	SetElement("InspectItemDR",list[2]);
	SetElement("InspectItem",list[sort+2]);
	SetElement("InspectState",list[3]);
	SetElement("Remark",list[4]);
}
//������ť�������
function BAdd_click()
{	
	selectrow=SelectedRow;
	var InspectDR=document.getElementById('InspectDR').value;
	if (InspectDR==""){
		alertShow(t["02"]);
		return;}
	var RowID=document.getElementById('RowID').value;
	if (RowID!=""){
		alertShow(t["01"]);
		return;}
	var InspectPartDR=document.getElementById('InspectPartDR').value;
	var InspectItemDR=document.getElementById('InspectItemDR').value;
	if (CheckNull()) return;
	var InspectState=document.getElementById('InspectState').value;
	var Remark=document.getElementById('Remark').value;
	var add=document.getElementById('ins');//����insΪ��������ص�����������valueget����s val=##Class(%CSP.Page).Encrypt($lb("web.TESTDHCEQCName.InsertEQName"))
	if (add){var encmeth=add.value} else {var encmeth=""};
	var sqlco=cspRunServerMethod(encmeth,"","",InspectDR,InspectPartDR,InspectItemDR,InspectState,Remark)

	 if (sqlco!='0') {
		alertShow(t["04"]);
	return;	}
    try {		   
	    //alertShow(t["05"]);
	    window.location.reload();
		} catch(e) {};
}
//���°�ť�������
function BUpdate_click()
{
	selectrow=SelectedRow;
	var InspectDR=document.getElementById('InspectDR').value;
	if (InspectDR==""){
		alertShow(t["02"]);
		return;}
	var RowID=document.getElementById('RowID').value;
	if (RowID==""){
		alertShow(t["06"]);
		return;}
	var InspectPartDR=document.getElementById('InspectPartDR').value;
	var InspectItemDR=document.getElementById('InspectItemDR').value;
	if (CheckNull()) return;
	var InspectState=document.getElementById('InspectState').value;
	var Remark=document.getElementById('Remark').value;
	var add=document.getElementById('upd');//����insΪ��������ص�����������valueget����s val=##Class(%CSP.Page).Encrypt($lb("web.TESTDHCEQCName.InsertEQName"))
	if (add){var encmeth=add.value} else {var encmeth=""};
	var sqlco=cspRunServerMethod(encmeth,"","",RowID,InspectDR,InspectPartDR,InspectItemDR,InspectState,Remark)
	if (sqlco!='0') {
		alertShow(t["04"]);
	return;	}
    try {		   
	    //alertShow(t["05"]);
	    window.location.reload();
		} catch(e) {};
}
//ɾ����ť�������
function BDelete_click()
{
	selectrow=SelectedRow;
	var RowID=document.getElementById('RowID').value;
	if (RowID==""){
		alertShow(t["07"]);
		return}
	var truthBeTold = window.confirm(t["08"]);
	if (!truthBeTold) return;

	var del=document.getElementById('del');
	if (del){var encmeth=del.value} else {var encmeth=""};
	var sqlco=cspRunServerMethod(encmeth,"","",RowID);
	
	 if (sqlco!='0') {
		alertShow(t["10"]);
	return;	}
    try {		   
	    //alertShow(t["09"]);
	    window.location.reload();
		} catch(e) {};
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(1,"InspectPart")) return true;
	if (CheckItemNull(2,"InspectState")) return true;
	if (CheckItemNull(1,"InspectItem")) return true;
	*/
	return false;
}
 
function GetInspectPart(value) {
	var user=value.split("^");
	var obj=document.getElementById("InspectPartDR");
	obj.value=user[1];
}
function GetInspectItem(value) {
	var user=value.split("^");
	var obj=document.getElementById("InspectItemDR");
	obj.value=user[1];
}
function ChangeStatus(Value)
{
	InitPage();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BAdd",Value);
	SetBStatus();
}
function SetBStatus()
{
	var obj=document.getElementById("Status");
	var Status=obj.value;
	if (Status!="0")
		{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAdd",true);
		}
	/*else
		{
		DisableBElement("BUpdate",false)
		DisableBElement("BDelete",false)
		DisableBElement("BAdd",false)
		}*/
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;