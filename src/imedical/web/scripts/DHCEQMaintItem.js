//装载页面  函数名称固定
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


	KeyUp("MaintItem^MaintPart");
	Muilt_LookUp("MaintItem^MaintPart");
}
function BClose_Click() 
{
	window.close();
}
//点击表格项填充自由项,函数名称固定
var SelectedRow = 0;
function SelectRowHandler()	{
	//下面基本为固定写法
	
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	
	var objtbl=document.getElementById('tDHCEQMaintItem'); //得到表格   t+组件名称
	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	//得到自由项
	var obj=document.getElementById('RowID');
	var obj1=document.getElementById('MaintDR');
	var obj2=document.getElementById('MaintPartDR');
	var obj3=document.getElementById('MaintItemDR');
	var obj4=document.getElementById('MaintPart');
	var obj5=document.getElementById('MaintItem');
	
	var obj6=document.getElementById('MaintState');
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
		ChangeStatus(false)
		return;}
	ChangeStatus(true)
	//得到表格项   字段名称+z+选择行
	FillData(selectrow)
	SelectedRow = selectrow;
}
function FillData(selectrow)
{
	var RowID=document.getElementById("TRowIDz"+selectrow).value
	SetElement("RowID",RowID)
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID)
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^")
	var sort=6
	SetElement("MaintDR",list[0]);
	SetElement("Maint",list[sort+0]);
	SetElement("MaintPartDR",list[1]);
	SetElement("MaintPart",list[sort+1]);
	SetElement("MaintItemDR",list[2]);
	SetElement("MaintItem",list[sort+2]);
	SetElement("MaintUserDR",list[3]);
	SetElement("MaintUser",list[sort+3]);
	SetElement("MaintState",list[4]);
	SetElement("Remark",list[5]);
}
//新增按钮点击函数
function BAdd_click()
{	
	selectrow=SelectedRow;
	var MaintDR=document.getElementById('MaintDR').value;
	if (MaintDR==""){
		alertShow(t["02"]);
		return;}
	var RowID=document.getElementById('RowID').value;
	if (RowID!=""){
		alertShow(t["01"]);
		return;}
	var MaintPartDR=document.getElementById('MaintPartDR').value;
	var MaintItemDR=document.getElementById('MaintItemDR').value;
	if (CheckNull()) return;
	var MaintState=document.getElementById('MaintState').value;
	var Remark=document.getElementById('Remark').value;
	var add=document.getElementById('ins');//其中ins为组件中隐藏的自由项且其valueget项有s val=##Class(%CSP.Page).Encrypt($lb("web.TESTDHCEQCName.InsertEQName"))
	if (add){var encmeth=add.value} else {var encmeth=""};
	var sqlco=cspRunServerMethod(encmeth,"","",MaintDR,MaintPartDR,MaintItemDR,MaintState,Remark)

	 if (sqlco!='0') {
		alertShow(t["04"]);
	return;	}
    try {		   
	    //alertShow(t["05"]);
	    window.location.reload();
		} catch(e) {};
}
//更新按钮点击函数
function BUpdate_click()
{
	selectrow=SelectedRow;
	var MaintDR=document.getElementById('MaintDR').value;
	if (MaintDR==""){
		alertShow(t["02"]);
		return;}
	var RowID=document.getElementById('RowID').value;
	if (RowID==""){
		alertShow(t["06"]);
		return;}
	var MaintPartDR=document.getElementById('MaintPartDR').value;
	var MaintItemDR=document.getElementById('MaintItemDR').value;
	if (CheckNull()) return;
	var MaintState=document.getElementById('MaintState').value;
	var Remark=document.getElementById('Remark').value;
	var add=document.getElementById('upd');//其中ins为组件中隐藏的自由项且其valueget项有s val=##Class(%CSP.Page).Encrypt($lb("web.TESTDHCEQCName.InsertEQName"))
	if (add){var encmeth=add.value} else {var encmeth=""};
	var sqlco=cspRunServerMethod(encmeth,"","",RowID,MaintDR,MaintPartDR,MaintItemDR,MaintState,Remark)
	if (sqlco!='0') {
		alertShow(t["04"]);
	return;	}
    try {		   
	    //alertShow(t["05"]);
	    window.location.reload();
		} catch(e) {};
}
//删除按钮点击函数
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
	if (CheckItemNull(1,"MaintItem")) return true;
	if (CheckItemNull(1,"MaintPart")) return true;
	if (CheckItemNull(2,"MaintState")) return true;
	*/
	return false;
} 
function GetMaintPart(value) {
	var user=value.split("^");
	var obj=document.getElementById("MaintPartDR");
	obj.value=user[1];
}
function GetMaintItem(value) {
	var user=value.split("^");
	var obj=document.getElementById("MaintItemDR");
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
//定义页面加载方法
document.body.onload = BodyLoadHandler;