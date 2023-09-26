/*
模块:		移动药房
子模块:		移动药房-公共控件封装
Creator:	hulihua
CreateDate:	2017-02-22
*/

var combooption = {
	valueField :'value',    
	textField :'text',
	panelWidth:'230'
}

$(function(){
    initPhaLoc();
	initWardLoc();
});

/// 初始化界面默认信息
/**
 * 药房科室
 */
function initPhaLoc(){
	combooption.required='true'	
	var uniturl = LINK_CSP+"?ClassName=web.DHCINPHA.MTCommon.CommonUtil&MethodName=GetPhaLocByGrp&grpdr="+gGroupId;
	var PhaLocCombobox = new ListCombobox("CombPhaloc",uniturl,'',combooption);
	PhaLocCombobox.init();
	$('#CombPhaloc').combobox('select', gLocId);
	$('#CombPhaloc').combobox('setValue', gLocDesc);
} 

/**
 * 病区科室
 */
function initWardLoc(){
	var option = {
		onSelect:function(record){
			$('#WardList').datagrid('reload',{params:record.text});
		},
		onChange: function (newValue) {  
			$('#WardList').datagrid('reload',{params:newValue});  
		},
		onBeforeLoad: function(param){
			param.combotext=param.q;
		},
		mode:"remote",
	}
	var uniturl = LINK_CSP+"?ClassName=web.DHCINPHA.MTCommon.CommonUtil&MethodName=GetWardLoc&LocType=W";
	var wardCombobox = new ListCombobox("CombWard",uniturl,'',option);
	wardCombobox.init();
}