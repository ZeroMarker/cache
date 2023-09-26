var SelectedRow=0;
var SubRowID=""
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
}

function AddClickHandler(e){
	var DefineRowID=DHCC_GetElementData("DefineRowID")
	//alert("DefineRowID"+DefineRowID)
	if(DefineRowID==""){
		alert("未选中有效代码,不得编辑代码数据!")
		return
	}
	var SubCode=DHCC_GetElementData("SubCode");
	var SubDesc=DHCC_GetElementData("SubDesc")
	var SubStDate=DHCC_GetElementData("SubStDate")
	var SubEndDate=DHCC_GetElementData("SubEndDate")
	if(SubCode==""){
		alert("代码不得为空！")
		return
	}
	if(SubDesc==""){
		alert("描述不得为空！")
		return
	}
	var ReturnCompare=CompareDate(SubStDate,SubEndDate)
	if (!ReturnCompare){alert("请重新选择有效的日期");return;}

	var rtn=tkMakeServerCall("web.DHCDocCTCommon","InsertDHCDocCTDefineData",DefineRowID,SubCode,SubDesc,SubStDate,SubEndDate)
	if(rtn!=0){
		alert("插入数据失败!SQLCODE:"+rtn)
	}
	else{
		window.location.reload();
	}	
}

function DelClickHandler(e){
	var DefineRowID=DHCC_GetElementData("DefineRowID")
	if((DefineRowID=="")||(SubRowID=="")){
		alert("未选中有效代码,不得删除代码数据!")
		return
	}
	
	var rtn=tkMakeServerCall("web.DHCDocCTCommon","DelDHCDocCTDefineData",DefineRowID,SubRowID)
	if(rtn!=0){
		alert("删除数据失败!SQLCODE:"+rtn)
	}
	else{
		window.location.reload();
	}	
}

function UpdateClickHandler(e){
	var DefineRowID=DHCC_GetElementData("DefineRowID")
	if((DefineRowID=="")||(SubRowID=="")){
		alert("未选中有效代码,不得更新代码数据!")
		return
	}
	var SubCode=DHCC_GetElementData("SubCode");
	var SubDesc=DHCC_GetElementData("SubDesc")
	var SubStDate=DHCC_GetElementData("SubStDate")
	var SubEndDate=DHCC_GetElementData("SubEndDate")
	if(SubCode==""){
		alert("代码不得为空！")
		return
	}
	if(SubDesc==""){
		alert("描述不得为空！")
		return
	}
	var ReturnCompare=CompareDate(SubStDate,SubEndDate)
	if (!ReturnCompare){alert("请重新选择有效的日期");return;}
	var rtn=tkMakeServerCall("web.DHCDocCTCommon","UpdateDHCDocCTDefineData",DefineRowID,SubRowID,SubCode,SubDesc,SubStDate,SubEndDate)
	if(rtn!=0){
		alert("更新数据失败!SQLCODE:"+rtn)
	}
	else{
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
		var TSubRowID=DHCC_GetColumnData("TSubRowID",selectrow)
		var TSubCode=DHCC_GetColumnData("TSubCode",selectrow)
		var TSubDesc=DHCC_GetColumnData("TSubDesc",selectrow)
		var TSubStDate=DHCC_GetColumnData("TSubStDate",selectrow)
		var TSubEndDate=DHCC_GetColumnData("TSubEndDate",selectrow)
		var TSubStDate=Trim(TSubStDate)
		var TSubEndDate=Trim(TSubEndDate)
		//alert("TSubStDate++"+TSubStDate+"++")
		DHCC_SetElementData("SubCode",TSubCode)
		DHCC_SetElementData("SubDesc",TSubDesc)
		DHCC_SetElementData("SubStDate",TSubStDate)
		DHCC_SetElementData("SubEndDate",TSubEndDate)
		SelectedRow = selectrow;
		SubRowID=TSubRowID
	}else{
		SelectedRow=0;
		SubRowID=""
		ClearValue();
		//ResetButton(0)
	}
}

function ClearValue(){
	DHCC_SetElementData("SubCode","")
	DHCC_SetElementData("SubDesc","")
	DHCC_SetElementData("SubStDate","")
	DHCC_SetElementData("SubEndDate","")
}

