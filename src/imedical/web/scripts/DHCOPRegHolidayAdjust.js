//DHCOPDro.js
var SelectedRow = 0;

function BodyLoadHandler() {
	var obj=document.getElementById('Adjust');
	if (obj) obj.onclick=Adjust_Click;
	var obj=document.getElementById('Delete');
	if (obj) obj.onclick=Delete_Click;
	//���ڳ�ʼ��
	var DOWStr="";
	var encmeth=DHCC_GetElementData('GetDOWMethod');
	if (encmeth!=''){DOWStr=cspRunServerMethod(encmeth);}
	//ComboDOW=dhtmlXComboFromStr("AdjustWeek",DOWStr);
	//ComboDOW.enableFilteringMode(true);
	//ComboDOW.selectHandle=ComboDOWselectHandle;	
	//DHCC_SetListStyle("PutDOW",false);
	//DHCC_AddItemToListByStr("PutDOW",DOWStr)
	
}
function ComboDOWselectHandle(e){
	DHCC_Nextfoucs();
	
}
function Delete_Click()
{
	if(SelectedRow==0){
		alert("��ѡ����Ҫɾ������")
        return false;
	}
	var Holiday=document.getElementById('THolidayz'+SelectedRow).innerText;
	var obj=document.getElementById('DelAdjustE');
	var encmeth=obj.value;
	if(encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,Holiday);
		if(rtn=="0")alert("ɾ���ɹ�!");
		else alert("ɾ��ʧ��!");
	}
	window.location.reload();
}
var SelectedRow = 0;
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCOPRegHolidayAdjust');
	if(!objtbl)
	{
	   objtbl=document.getElementById('tDHCOPRegHolidayAdjust0');
	}
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if(SelectedRow!=selectrow){
		SelectedRow = selectrow;
	}else{
		SelectedRow=0
	}
	
}
function Adjust_Click()
{
	var userid=session['LOGON.USERID'];	
	var groupid=session['LOGON.GROUPID'];	
	var ctlocid=session['LOGON.CTLOCID'];
	//var DOWRowId=ComboDOW.getActualValue();
	var obj=document.getElementById('Holiday');
	if(obj){
		var Holiday=obj.value;
		if (Holiday=="") {
			alert("��ѡ��ڼ���");
			return;
		}
		
	}
	var obj=document.getElementById('AdjustDate');
	if(obj)var AdjustDate=obj.value;
	if(obj){
		var AdjustDate=obj.value;
		if (AdjustDate=="") {
			alert("��ѡ�����������");
			return;
		}
	}
	var obj=document.getElementById('AdjustE');
	var encmeth=obj.value;
	if(encmeth!=""){
		//var rtn=cspRunServerMethod(encmeth,Holiday,DOWRowId,userid);
		var rtn=cspRunServerMethod(encmeth,Holiday,AdjustDate);
		if(rtn=="0")alert("�����ɹ�!");
		else alert("����ʧ��!");
	}
	window.location.reload();
}
document.body.onload = BodyLoadHandler;