/**
 * lendoutdtl 病案借阅明细
 * 
 * Copyright (c) 2018-2019 WHui. All rights reserved.
 * 
 * CREATED BY WHui 2019-11-28
 * 
 * 注解说明
 * TABLE: 
 */

var Lend_ArgsObj = {
	SubFlow		: '',
	SysOpera	: '',
	RequestID	: '',
	LendInfo	: ''
}

function InitLendView(aSubFlow,aSysOpera,aRequestID){
	$('#LendInfoDialog').css('display','block');
	Common_ComboGridToUser("cboLendUser","");
	
	var _title = "病案借阅",_icon="icon-w-edit"
	var LendInfoDialog = $HUI.dialog('#LendInfoDialog',{
		title: _title,
		iconCls: _icon,
		closable: true,
		// width:470,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onBeforeOpen: function(){
			Lend_ArgsObj.SubFlow	= aSubFlow;
			Lend_ArgsObj.SysOpera	= aSysOpera;
			Lend_ArgsObj.RequestID	= aRequestID;
			Lend_ArgsObj.LendInfo	= '';
			Common_ComboToLoc("cboLendLoc","","E",Logon.HospID,'I','');			// 科室
			$HUI.combobox('#cboLendLoc',{
				onSelect:function(rows){
				}
			});
			Common_CheckboxToDicID("cbgPurposeIDs","LendPurpose","4");
			// var ExpBackDate = Common_GetDate("3","");
			//$('#ExpBackDate').datebox('setValue', "2020-01-01");		// 给日期框赋值
		},
		buttons:[{
			text:'保存',
				iconCls:'icon-w-save',
				handler:function(){
					lend_Save();
				}
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				closeView_lend();
			}	
		}]
	});
	$('#LendInfoDialog').window('open');
}

// 保存按钮
function lend_Save(){
	var lend_Id			= $("#txtVolLendId").val();
	var lend_Loc		= $("#cboLendLoc").combobox('getValue');
	var lend_LocTel		= $("#txtLendLocTel").val();
	var objLendUser = $('#cboLendUser').combogrid('grid').datagrid('getSelected');
	var lend_User ='';
	if (objLendUser!==null){
		lend_User = objLendUser.ID;
	}
	var lend_UserTel	= $("#txtLendUserTel").val();
	
	var cbgPurposeIDs	= Common_CheckboxValue("cbgPurposeIDs");
	var ExpBackDate		= $('#ExpBackDate').datebox('getValue');
	var lend_Resume		= $("#txtResume").val();
	
	if (!lend_Loc) {
		$.messager.popover({msg: '借阅科室必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!lend_LocTel) {
		$.messager.popover({msg: '科室电话必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!lend_User) {
		$.messager.popover({msg: '借阅人员必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!lend_UserTel) {
		$.messager.popover({msg: '借阅人电话必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!cbgPurposeIDs) {
		$.messager.popover({msg: '借阅目的必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!ExpBackDate) {
		$.messager.popover({msg: '预计归还日期必填！',type: 'alert',timeout: 1000});
		return
	}
	
	//var Flag = Lend_ArgsObj.SubFlow + '|' + Lend_ArgsObj.SysOpera;
	var tmp = lend_Id + "^";
		tmp += lend_Loc + "^";
		tmp += lend_LocTel + "^";
		tmp += lend_User + "^";
		tmp += lend_UserTel + "^";
		tmp += cbgPurposeIDs + "^";
		tmp += ExpBackDate + "^";
		tmp += lend_Resume;
	
	Lend_ArgsObj.LendInfo	= tmp;
	
	SaveOpera(2);
	closeView_lend();
}

function closeView_lend(){
	$("#txtVolLendId").val('');
	$("#cboLendLoc").combobox('setValue','');
	$("#txtLendLocTel").val('');
	$("#cboLendUser").combobox('setValue','');
	$("#txtLendUserTel").val('');
	$("input[name='cbgPurposeIDs']").each(function () {
		$(this).checkbox('setValue',false);
	});
	$("#ExpBackDate").datebox('setValue','');
	$("#txtResume").val('');
	
	$('#LendInfoDialog').window("close");
}