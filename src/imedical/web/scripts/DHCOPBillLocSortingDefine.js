///DHCOPBillLocSortingDefine.js
///Lid
///2012-07-12
///���ҷ��ඨ��
var m_LocSortingDR="";
var m_SelectedRow="-1";
function BodyLoadHandler(){
	InitDoc();
}
function InitDoc(){
	var obj=websys_$("Add");
	if(obj){
		obj.onclick=Add_OnClick;
	}
	var obj=websys_$("Delete");
	if(obj){
		obj.onclick=Delete_OnClick;
	}
	var obj=websys_$("Update");
	if(obj){
		obj.onclick=Update_OnClick;
	}
	var obj=websys_$("Clear");
	if(obj){
		obj.onclick=Clear_OnClick;
	}
	var cookieOrderType=DHCBILL.getCookie("DHCOPBillLocSortingDefineOrderTypeSelectIdx");
	var obj=document.getElementById("OrdType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=OrdType_OnChange;
		if(cookieOrderType!=""){
			obj.selectedIndex=cookieOrderType;
		}else{
			obj.selectedIndex=0;
		}
		//alert(obj.value+"^"+obj.options[obj.selectedIndex].text);
	}
}
function OrdType_OnChange(){
	DHCBILL.setCookie("DHCOPBillLocSortingDefineOrderTypeSelectIdx",this.selectedIndex,30);
}
function Add_OnClick(){
	var Guser=session['LOGON.USERID'];

	var PYM=websys_$V("PYM");
	if(DHCWeb_Trim(PYM)==""){
		alert("���벻��Ϊ��");
		return;
	}
	var LocSorting=websys_$V("LocSorting");
	if(DHCWeb_Trim(LocSorting)==""){
		alert("���ҷ������Ʋ���Ϊ��");
		return;
	}
	var truthBeTold = window.confirm("�Ƿ��������ҷ���?");
   	if (!truthBeTold){return;}
	var OrderType=websys_$V("OrdType");
	var myrtn=tkMakeServerCall("web.DHCOPBillLocSortingDefine","InsertLocSorting",LocSorting,PYM,Guser,OrderType);
	if(myrtn==0){
		alert(myrtn+":��ӳɹ�.");
		DHCWebD_SetObjValueB("LocSorting","");
		DHCWebD_SetObjValueB("PYM","");
		Find_click();
	}else if(myrtn=="-1001"){
		alert(myrtn+":���벻���ظ�");
	}else if(myrtn=="-1002"){
		alert(myrtn+":���ҷ������Ʋ����ظ�");
	}else{
		alert(myrtn+":���ʧ��.");
	}
}

function Delete_OnClick(){
	
	var LocSortingDR=m_LocSortingDR;
	if(LocSortingDR==""){
		alert("��ѡ��Ҫɾ���Ŀ��ҷ���");
		return;
	}
	if(m_LocSortingDR=="")return;
	var truthBeTold = window.confirm("�Ƿ�ɾ�����ҷ���?");
   	if (!truthBeTold){return;}
	
	var myrtn=tkMakeServerCall("web.DHCOPBillLocSortingDefine","DeleteLocSorting",LocSortingDR);
	if(myrtn==0){
		alert(myrtn+":ɾ���ɹ�.");
		DHCWebD_SetObjValueB("LocSorting","");
		DHCWebD_SetObjValueB("PYM","");
		Find_click();
	}else if(myrtn=="-1003"){
		alert(myrtn+":�÷�����ά������,����ɾ��.");
	}else{
		alert(myrtn+":ɾ��ʧ��.");
	}
}

function Update_OnClick(){
	var LocSortingDR=m_LocSortingDR;
	if(LocSortingDR==""){
		alert("��ѡ��Ҫɾ���Ŀ��ҷ���");
		return;
	}
	var Guser=session['LOGON.USERID'];
	var PYM=websys_$V("PYM");
	if(DHCWeb_Trim(PYM)==""){
		alert("���벻��Ϊ��");
		return;
	}
	var LocSorting=websys_$V("LocSorting");
	if(DHCWeb_Trim(LocSorting)==""){
		alert("���ҷ������Ʋ���Ϊ��");
		return;
	}

		if(m_LocSortingDR=="")return;
	var truthBeTold = window.confirm("�Ƿ��޸Ŀ��ҷ�������?");
   	if (!truthBeTold){return;}
	
	var OrderType=websys_$V("OrdType");
	var myrtn=tkMakeServerCall("web.DHCOPBillLocSortingDefine","UpdateLocSorting",LocSortingDR,LocSorting,PYM,Guser,OrderType);
	if(myrtn==0){
		alert(myrtn+":���³ɹ�.");
		DHCWebD_SetObjValueB("LocSorting","");
		DHCWebD_SetObjValueB("PYM","");
		Find_click();
	}else if(myrtn=="-1004"){
		alert(myrtn+":���벻���޸�");
	}else if(myrtn=="-1002"){
		alert(myrtn+":���ҷ������Ʋ����ظ�");
	}else{
		alert(myrtn+":����ʧ��.");
	}
}

function Clear_OnClick(){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillLocSortingDefine";
	window.location.href=lnk;
}
function SelectRowHandler()	{   
	var eSrc=window.event.srcElement;
	var rowobj=getRow(eSrc);
	Objtbl=document.getElementById('tDHCOPBillLocSortingDefine');
	var Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow!=m_SelectedRow) {
		var SelRowObj=document.getElementById('TLocSortiingDescz'+selectrow);
		var LocSortingDesc=SelRowObj.innerText;
		DHCWebD_SetObjValueB("LocSorting",LocSortingDesc);
		var SelRowObj=document.getElementById('TLocSortingCodez'+selectrow);
		var LocSortingCode=SelRowObj.innerText;
		DHCWebD_SetObjValueB("PYM",LocSortingCode);
		var SelRowObj=document.getElementById('TLocSortingDRz'+selectrow);
		m_LocSortingDR=SelRowObj.innerText; 
		//
		m_SelectedRow = selectrow;
	}else{
		
	}
}

function DHCWeb_Trim(str){   
	 return str.replace(/(^\s*)|(\s*$)/g, "");  
}  
//ɾ����ߵĿո�
function DHCWeb_LTrim(str){   
	return str.replace(/(^\s*)/g,"");  
}  
//ɾ���ұߵĿո�
function DHCWeb_RTrim(str){   
	return str.replace(/(\s*$)/g,"");  
}  
document.body.onload = BodyLoadHandler;