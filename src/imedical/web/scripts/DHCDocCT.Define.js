var SelectedRow=0;
var DefineRowID="";
document.body.onload = BodyLoadHandler;
function BodyLoadHandler() {
	var obj=document.getElementById("Add")
	if(obj){
		obj.onclick=AddClickHandler;
	}
	var obj=document.getElementById("Del")
	if(obj){
		obj.onclick=DelClickHandler;
	}
	var obj=document.getElementById("Update")
	if(obj){
		obj.onclick=UpdateClickHandler;
	}
	//初始化代码表模块下拉列表
	var MethodStr=tkMakeServerCall("web.DHCDocCTCommon","GetMethodStr")
	//alert("MethodStr"+MethodStr)
	var obj=document.getElementById("ModuleDesc");
	if (obj) {
		obj.size=1;
		obj.multiple=false;
		if (MethodStr!=""){ 
			var ArrData=MethodStr.split("^");
			for (var i=0;i<ArrData.length;i++) {
				var ArrData1=ArrData[i].split(String.fromCharCode(1));
				obj.options[obj.length] = new Option(ArrData1[1],ArrData1[0]);
			}
			obj.selectedIndex=-1;
		}
	}	
}

function AddClickHandler(e){
	var DefineCode=DHCC_GetElementData("DefineCode")
	var DefineDesc=DHCC_GetElementData("DefineDesc")
	var ModuleCode=DHCC_GetElementData("ModuleDesc")
	if(DefineCode==""){
		alert("代码表代码不得为空！")
		return
	}
	if(DefineDesc==""){
		alert("代码表名称不得为空！")
		return
	}
	if(ModuleCode==""){
		alert("模块不得为空！")
		return
	}
	//alert(DefineCode+"^"+DefineDesc+"^"+ModuleCode)
	var rtn=tkMakeServerCall("web.DHCDocCTCommon","InsertDHCDocCTDefine",DefineCode,DefineDesc,ModuleCode)
	if(rtn!=0){
		alert("插入数据失败"+rtn)
	}
	window.location.reload();
}

function DelClickHandler(e){
	if(DefineRowID==0){
		alert("未选中记录")
		return
	}
	var rtn=tkMakeServerCall("web.DHCDocCTCommon","DelDHCDocCTDefine",DefineRowID)
	if(rtn!=0){
		alert("删除数据失败")
	}else{
		//alert("删除数据成功")
	}
	window.location.reload();
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCDocCT.DefineData&DefineRowID="+"";
	parent.frames['RPbottom'].document.location.href=lnk;
}

function UpdateClickHandler(e){
	if(DefineRowID==0){
		alert("未选中记录")
		return
	}
	var DefineCode=DHCC_GetElementData("DefineCode")
	var DefineDesc=DHCC_GetElementData("DefineDesc")
	var ModuleCode=DHCC_GetElementData("ModuleDesc")
	if(DefineCode==""){
		alert("代码表代码不得为空！")
		return
	}
	if(DefineDesc==""){
		alert("代码表名称不得为空！")
		return
	}
	if(ModuleCode==""){
		alert("模块不得为空！")
		return
	}
	var rtn=tkMakeServerCall("web.DHCDocCTCommon","UpdateDHCDocCTDefine",DefineRowID,DefineCode,DefineDesc,ModuleCode)
	if(rtn!=0){
		alert("更新数据失败")
	}else{
		//alert("删除数据成功")
		window.location.reload();
	}
	
	
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow){
		SelectedRow=0;
		ClearValue()
		return;
	}
	//alert("selectrow:"+selectrow +" SelectedRow:"+SelectedRow);
	if (selectrow!=SelectedRow){
		var TDefineRowID=DHCC_GetColumnData("TDefineRowID",selectrow)
		var TDefineCode=DHCC_GetColumnData("TDefineCode",selectrow)
		var TDefineDesc=DHCC_GetColumnData("TDefineDesc",selectrow)
		var TModuleDR=DHCC_GetColumnData("TModuleDR",selectrow)
		var TModuleDesc=DHCC_GetColumnData("TModuleDesc",selectrow)
		
		DHCC_SetElementData("DefineCode",TDefineCode)
		DHCC_SetElementData("DefineDesc",TDefineDesc)
		DHCC_SetElementData("ModuleDesc",TModuleDR)
		
		
		SelectedRow = selectrow;
		DefineRowID=TDefineRowID
	}else{
		//alert("2")
		SelectedRow=0;
		DefineRowID=""
		ClearValue();
		//ResetButton(0)
	}
	RowChanged();
}

function ClearValue(){
	//alert("1")
	DHCC_SetElementData("DefineCode","")
	DHCC_SetElementData("DefineDesc","")
	DHCC_SetElementData("ModuleDesc","")

}

function RowChanged(){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCDocCT.DefineData&DefineRowID="+DefineRowID;
	parent.frames['RPbottom'].document.location.href=lnk;
}

