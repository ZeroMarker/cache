/**
 * FileName: scripts/dhcbillconfig/dhcbill.conf.general.proModule.js
 * Author: wzh
 * Date: 2022-10-12
 * Description: 通用配置产品维护-公共方法
 */
// 初始化
$(function() {
	initData();
});

// 初始化数据
function initData(){
	if (CV.DataType == "query"){
		var _dataJson = getPersistClsObj(CV.UrlCLs, CV.ID);
		for(key in _dataJson){
	    	setValueById(key, _dataJson[key]);
	    	disableById(key);
		}
		disableById("btn-save");
		setParentData(_dataJson[CV.PDr])
	}else if (CV.DataType == "add"){
		if(CV.ParentCls != ""){
			setParentData(CV.ParentID)
		}
	}else if (CV.DataType == "update"){
		var _dataJson = getPersistClsObj(CV.UrlCLs, CV.ID);
		for(key in _dataJson){
	    	setValueById(key, _dataJson[key]);
		}
		setParentData(_dataJson[CV.PDr]);
		// 修改时代码不可修改
		disableById("PLCode");
		disableById("PMCode");
	}else if (CV.DataType == "addChild"){
		setParentData(CV.ParentID);
	}
}

function setParentData(parentID){
	if(CV.ParentCls != ""){
		var json = getPersistClsObj(CV.ParentCls, parentID);
	}else{
		return;
	}
	
	switch(CV.UrlType){
		case "Mod":
			setValueById("ProLineCode", json[CV.PCode]);
			setValueById("ProLineName", json[CV.PName]);
			break
		case "Func":
			break
		default:
	}
}
// 保存方法
function save(){
	//数据校验
	var bool = true;
	$("#data .validatebox-text").each(function(index, item) {
		if (!$(this).validatebox("isValid")) {
			$.messager.popover({msg: "<font color=red>" + $(this).parents("td:first").prev().text() + "</font>" + "验证不通过", type: "info"});
			bool = false;
			return false;
		}
	});
	if (!bool) {
		return;
	}
	//校验完毕
	
	// 获取表格所有数据
	var json = {};
	$('#dataTab').find('tbody').each(function (i) {
		$(this).find('tr').each(function (j) {
			$(this).find('td').each(function (h) {
				if ($(this).context.className !== "r-label"){
					json[$(this).context.firstElementChild.id] = getValueById($(this).context.firstElementChild.id)
					//$(this).context.firstElementChild.value;
				}
			});
		});
	});
	json.ID = CV.ID;
	json.Type = CV.UrlType;
	
	$.m({
		ClassName: "BILL.CFG.COM.GeneralPro",
		MethodName: "Save",
		jsonStr: JSON.stringify(json)
	}, function(rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] != 0) {
			$.messager.popover({msg: "保存失败：" + (myAry[1] || myAry[0]), type: "error"});
			return;
		}else{
			$.messager.popover({msg: "保存成功！", type: "info"});
			
		}
		
	});
}