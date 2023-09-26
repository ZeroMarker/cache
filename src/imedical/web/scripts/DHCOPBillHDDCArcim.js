///DHCOPBillHDDCArcim.js
///Lid
///2012-07-12
///������Ŀ�Ĳ�Ѫ�ص�ά��
var m_HDDCSRowID="";
var m_SelectedRow=-1;
function BodyLoadHandler() {
	//websys_$j=$.noConflict();	//�ͷ�jQuery��$��ʹ��Ȩ�������¶����µı���.
	InitDoc();
}
function InitDoc(){
	var ADDobj=document.getElementById('Add');
	if (ADDobj) ADDobj.onclick = ADD_Click
	var Modfiyobj=document.getElementById('Update');
	if (Modfiyobj) Modfiyobj.onclick = Modfiy_Click;
	var deleteobj=document.getElementById('Delete');
	if (deleteobj) deleteobj.onclick = Delete_Click;
	var deleteobj=document.getElementById('Clear');
	if (deleteobj) deleteobj.onclick = Clear_Click;
	var deleteobj=document.getElementById('Find');
	if (deleteobj) deleteobj.onclick = Find_OnClick;
}
function SelArcimHandler(value)	{
	var val=value.split("^");
	var obj=document.getElementById('ArcimDR');
	obj.value=val[1];
}
function Find_OnClick(){
	var LocSorting=websys_$V("LocSorting");
	if(DHCWeb_Trim(LocSorting)==""){
		DHCWebD_SetObjValueB("LocSortingDR","");
	}
	var Arcim=websys_$V("Arcim");
	if(DHCWeb_Trim(Arcim)==""){
		DHCWebD_SetObjValueB("ArcimDR","");
	}
	DHCWebD_SetObjValueB("HDDCRowID","");
	Find_click();
}
function ADD_Click(){
	var Guser=session['LOGON.USERID'];
	var HDDCRowID=websys_$V("HDDCRowID");
    var LocSortingDR=websys_$V('LocSortingDR');
	if((DHCWeb_Trim(HDDCRowID)=="")||(DHCWeb_Trim(HDDCRowID)=="")){
		return;
	}
    var Position=websys_$V('Position');
	if((DHCWeb_Trim(Position)=="")){
		alert("��Ѫ�ص����");
		return;
	}
	var Arcim=websys_$V("Arcim");
	var ArcimDR=websys_$V("ArcimDR");
	if((DHCWeb_Trim(Arcim)=="")||(DHCWeb_Trim(ArcimDR)=="")){
		alert("��Ŀ����");
		return;
	}
	var truthBeTold = window.confirm("�Ƿ�ȷ�����?");
   	if (!truthBeTold){return;}
    var myrtn=tkMakeServerCall("web.DHCOPBillHDDCArcim","AddHDDCArcim",HDDCRowID,ArcimDR,Position,Guser);
    var rtn=myrtn.split("^")[0];
	if(rtn==0){
		websys_$("ArcimDR").value="";
		websys_$("Arcim").value="";
		websys_$("Position").value="";
		//websys_$("LocSortingDR").value="";
		//websys_$("LocSorting").value="";
		Find_click();
		alert("��ӳɹ�");
	}else if(rtn=="-1006"){
		alert("����Ŀ��ά����Ѫ�ص�.");
		return;
	}else{
		alert("���ʧ��");
		return;
	}
}
function Modfiy_Click(){
	var Guser=session['LOGON.USERID'];
	if(m_HDDCSRowID==""){
		alert("��ѡ��Ҫ�޸ĵļ�¼.");
		return;
	}
	var HDDCSRowID=m_HDDCSRowID;
    var Position=websys_$V('Position');
	if((DHCWeb_Trim(Position)=="")){
		//alert("��Ѫ�ص����");
		//return;
	}
	var Arcim=websys_$V("Arcim");
	var ArcimDR=websys_$V("ArcimDR");
	if((DHCWeb_Trim(Arcim)=="")||(DHCWeb_Trim(ArcimDR)=="")){
		alert("��Ŀ����");
		return;
	}
	var truthBeTold = window.confirm("�Ƿ�ȷ���޸�?");
   	if (!truthBeTold){return;}
    var rtn=tkMakeServerCall("web.DHCOPBillHDDCArcim","UpdateHDDCArcim",HDDCSRowID,Position,Guser);
    if(rtn==0){
		//websys_$("ArcimDR").value="";
		//websys_$("Arcim").value="";
		//websys_$("Position").value="";
		websys_$("LocSortingDR").value="";
		websys_$("LocSorting").value="";
		Find_click();
		alert("�޸ĳɹ�");
	}else if(rtn=="-1006"){
		alert("����Ŀ��ά����Ѫ�ص�.");
		return;
	}else{
		alert("�޸�ʧ��");
		return;
	}
}
function Delete_Click(){
	var Guser=session['LOGON.USERID'];
	var HDDCSRowID=m_HDDCSRowID;
	if(HDDCSRowID==""){
		alert("��ѡ��Ҫɾ���ļ�¼.");
		return;
	}
	var truthBeTold = window.confirm("�Ƿ�ȷ��ɾ��?");
   	if (!truthBeTold){return;}
    var rtn=tkMakeServerCall("web.DHCOPBillHDDCArcim","DeleteHDDCArcim",HDDCSRowID,Guser);
    if(rtn==0){
		websys_$("ArcimDR").value="";
		websys_$("Arcim").value="";
		websys_$("Position").value="";
		Find_click();
		alert("ɾ���ɹ�");
	}else{
		alert("ɾ��ʧ��");
		return;
	}
}
function Clear_Click(){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillHDDCArcim";
	window.location.href=lnk;
}
function LocSortingSelHandler(value){
	var obj=document.getElementById('LocSortingDR');
	obj.value=value.split("^")[2];
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var rowobj=getRow(eSrc);
	Objtbl=document.getElementById('tDHCOPBillHDDCArcim');
	var Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow!=m_SelectedRow) {
		var SelRowObj=document.getElementById('THDDCSRowIDz'+selectrow);
		//alert(SelRowObj.value);
		m_HDDCSRowID=SelRowObj.value;
		var SelRowObj=document.getElementById('THDDCSArcimDRz'+selectrow);
		var HDDCSArcimDR=SelRowObj.value;
		DHCWebD_SetObjValueB("ArcimDR",HDDCSArcimDR);
		var SelRowObj=document.getElementById('THDDCSArcimDescz'+selectrow);
		var HDDCSArcimDesc=SelRowObj.innerText;
		DHCWebD_SetObjValueB("Arcim",HDDCSArcimDesc);
		var SelRowObj=document.getElementById('THDDCSArcimPlacez'+selectrow);
		var HDDCSArcimPlace=SelRowObj.innerText; 
		DHCWebD_SetObjValueB("Position",HDDCSArcimPlace);
		
		var SelRowObj=document.getElementById('TLocSortingDRz'+selectrow);
		var LocSortingDR=SelRowObj.value;
		DHCWebD_SetObjValueB("LocSortingDR",LocSortingDR);
		var SelRowObj=document.getElementById('TLocSortingDescz'+selectrow);
		var LocSortingDesc=SelRowObj.innerText; 
		DHCWebD_SetObjValueB("LocSorting",LocSortingDesc);
		
		//
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