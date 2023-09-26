var SelectedRow=0;
var ModuleID=""
document.body.onload = BodyLoadHandler;
function BodyLoadHandler() {
	//alert("1")
	var obj=document.getElementById("Update")
	if(obj){
		obj.onclick=UpdateClickHandler;
	}
	
	var obj=document.getElementById("Del")
	if(obj){
		obj.onclick=DelClickHandler;
	}
	
	var obj=document.getElementById("Add")
	if(obj){
		obj.onclick=AddClickHandler;
	}
	document.onkeydown = Doc_OnKeyDown;
}
function Doc_OnKeyDown(e){
	var obj = websys_getSrcElement(e);
	var keycode = websys_getKey(e);
	if (keycode == 13) {
        if (obj.id == "ModuleDesc") {
	        return false;
	    }
	}
}
function AddClickHandler(e){
	//var ModuleCode=DHCC_GetElementData("ModuleCode")
	var ModuleDesc=DHCC_GetElementData("ModuleDesc")
	//if(ModuleCode==""){
		//alert("ģ����벻��Ϊ�գ�")
		//return
	//}
	if(ModuleDesc==""){
		alert("ģ�����Ʋ���Ϊ�գ�")
		return
	}
	var rtn=tkMakeServerCall("web.DHCDocCTCommon","InsertDHCDocCTModule",ModuleDesc)
	if(rtn!=0){
		alert("��������ʧ��")
	}else{
		//alert("�������ݳɹ�")
		window.location.reload();
	}
	//opener.location.reload();
	//window.parent.bottom.location.reload()
	
	
}

function UpdateClickHandler(e){
	if(ModuleID==0){
		alert("δѡ�м�¼")
		return
	}
	//var ModuleCode=DHCC_GetElementData("ModuleCode")
	var ModuleDesc=DHCC_GetElementData("ModuleDesc")
	//if(ModuleCode==""){
		//alert("ģ����벻��Ϊ�գ�")
		//return
	//}
	if(ModuleDesc==""){
		alert("ģ�����Ʋ���Ϊ�գ�")
		return
	}
	var rtn=tkMakeServerCall("web.DHCDocCTCommon","UpdateDHCDocCTModule",ModuleID,ModuleDesc)
	if(rtn!=0){
		alert("��������ʧ��")
	}else{
		//alert("�������ݳɹ�")
	}
	window.location.reload();
}

function DelClickHandler(e){
	if(ModuleID==0){
		alert("δѡ�м�¼")
		return
	}
	var rtn=tkMakeServerCall("web.DHCDocCTCommon","DelDHCDocCTModule",ModuleID)
	if(rtn!=0){
		alert("ɾ������ʧ��")
	}else{
		//alert("ɾ�����ݳɹ�")
	}
	window.location.reload();

}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	//alert("selectrow:"+selectrow +" SelectedRow:"+SelectedRow);
	if (selectrow!=SelectedRow){
		//var ModuleCode=DHCC_GetColumnData("TModuleCode",selectrow)
		var ModuleDesc=DHCC_GetColumnData("TModuleDesc",selectrow)
		var RowID=DHCC_GetColumnData("TRowID",selectrow)
		//DHCC_SetElementData("ModuleCode",ModuleCode)
		DHCC_SetElementData("ModuleDesc",ModuleDesc)
		SelectedRow = selectrow;
		ModuleID=RowID
	}else{
		SelectedRow=0;
		ModuleID=""
		ClearValue();
		//ResetButton(0)
	}
}

function ClearValue(){
	//DHCC_SetElementData("ModuleCode","")
	DHCC_SetElementData("ModuleDesc","")
}

