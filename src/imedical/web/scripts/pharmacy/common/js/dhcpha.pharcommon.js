/*
ģ��:		�ƶ�ҩ��
��ģ��:		�ƶ�ҩ��-�����ؼ���װ
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

/// ��ʼ������Ĭ����Ϣ
/**
 * ҩ������
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
 * ��������
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