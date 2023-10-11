/**
 * Copydtl 病案复印明细
 * 
 * Copyright (c) 2018-2019 WHui. All rights reserved.
 * 
 * CREATED BY WHui 2019-11-28
 * 
 * 注解说明
 * TABLE: 
 */

var Copy_ArgsObj = {
	SubFlow		: '',
	SysOpera	: '',
	RequestID	: '',
	CopyInfo	: ''
}

function InitCopyView(aSubFlow,aSysOpera,aRequestID){
	$('#CopyInfoDialog').css('display','block');
	var _title = "病案复印",_icon="icon-w-edit"
	var CopyInfoDialog = $HUI.dialog('#CopyInfoDialog',{
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
			Copy_ArgsObj.SubFlow	= aSubFlow;
			Copy_ArgsObj.SysOpera	= aSysOpera;
			Copy_ArgsObj.RequestID	= aRequestID;
			Copy_ArgsObj.CopyInfo	= '';
			Common_ComboToDic("cboRelation_C","RelationType",1,'');
			Common_ComboToDic("cboCertificate_C","Certificate",1,'');
			Common_CheckboxToDicID("cbgContentIDs_C","CopyContent","4");
			Common_CheckboxToDicID("cbgPurposes_C","CopyPurpose","4");
		},
		buttons:[{
			text:'保存',
				iconCls:'icon-w-save',
				handler:function(){
					Copy_Save();
				}
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				closeView_copy();
			}	
		}]
	});
}

// 保存按钮
function Copy_Save(){
	var copy_Id				= $("#txtVolCopyId").val();
	var copy_ClientName		= $("#txtClientName_C").val();					// 委托人
	var copy_Relation		= $("#cboRelation_C").combobox('getValue');		// 与患者关系
	var copy_Certificate 	= $("#cboCertificate_C").combobox('getValue');	// 证明材料
	var copy_IDCode			= $("#txtIDCode_C").val();						// 证件号码
	
	var copy_Telephone		= $("#txtTelephone_C").val();					// 委托人电话
	var copy_Address		= $("#txtAddress_C").val();						// 委托人地址
	var copy_Number			= $("#txtNumber_C").val();						// 复印份数
	var copy_ContentIDs		= Common_CheckboxValue("cbgContentIDs_C");		// 复印内容
	var copy_Purposes		= Common_CheckboxValue("cbgPurposes_C");		// 复印目的
	var copy_Resume			= $("#txtResume_C").val();						// 备注
	
	var copy_A4paper		= $("#txtA4paper_C").val();						// A4纸张数
	var copy_A3paper		= $("#txtA3paper_C").val();						// A3纸张数
	
	if (!copy_ClientName) {
		$.messager.popover({msg: '委托人必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!copy_Relation) {
		$.messager.popover({msg: '与患者关系必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!copy_Certificate) {
		$.messager.popover({msg: '证明材料必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!copy_IDCode) {
		$.messager.popover({msg: '证件号码必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!copy_Telephone) {
		$.messager.popover({msg: '委托人电话必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!copy_Address) {
		$.messager.popover({msg: '委托人地址必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!copy_ContentIDs) {
		$.messager.popover({msg: '复印内容必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!copy_Purposes) {
		$.messager.popover({msg: '复印目的必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!copy_A4paper) {
		$.messager.popover({msg: 'A4纸张数必填！',type: 'alert',timeout: 1000});
		return
	}
	
	//var Flag = Copy_ArgsObj.SubFlow + '|' + Copy_ArgsObj.SysOpera;
	var tmp = copy_Id + "^";				// 1. copy_Id
		tmp += copy_ClientName + "^";		// 2. 委托人
		tmp += copy_Relation + "^";			// 3. 与患者关系
		tmp += copy_Certificate + "^";		// 4. 证明材料
		tmp += copy_IDCode + "^";			// 5. 证件号码
		tmp += copy_Telephone + "^";		// 6. 委托人电话
		tmp += copy_Address + "^";			// 7. 委托人地址
		tmp += copy_Number + "^";			// 8. 复印份数
		tmp += copy_ContentIDs + "^";		// 9. 复印内容
		tmp += copy_Purposes + "^";			// 10. 复印目的
		tmp += copy_Resume+ "^";			// 11. 备注
		tmp += Logon.UserID+ "^";			// 12. 创建人
		tmp += ""+ "^";						// 13. ""
		tmp += ""+ "^";						// 14. ""
		tmp += copy_A4paper+ "^";			// 15. A4纸张数
		tmp += copy_A3paper;				// 16. A3纸张数
	
	Copy_ArgsObj.CopyInfo	= tmp;
	
	SaveOpera(2);
	closeView_copy();
}

function closeView_copy(){
	$("#txtVolCopyId").val('');
	$("#txtClientName_C").val('');
	$("#cboRelation_C").combobox('setValue','');
	$("#cboCertificate_C").combobox('setValue','');
	$("#txtIDCode_C").val('');
	
	$("#txtTelephone_C").val('');
	$("#txtAddress_C").val('');
	$("#txtNumber_C").val('');
	$("#chkSelAllCon_C").checkbox('setValue',false);
	$("input[name='cbgContentIDs_C']").each(function () {
		$(this).checkbox('setValue',false);
	});
	$("input[name='cbgPurposes_C']").each(function () {
		$(this).checkbox('setValue',false);
	})
	$("#txtResume_C").val('');
	
	$("#txtA4paper_C").val('');
	$("#txtA3paper_C").val('');
	
	$('#CopyInfoDialog').window("close");
}

// 选中全部复印内容
$HUI.checkbox('#chkSelAllCon_C',{
	onChecked:function(e,value){
		$("input[name='cbgContentIDs_C']").each(function () {
			$(this).checkbox('setValue', true);
		})
	},
	onUnchecked:function(e,value){
		$("input[name='cbgContentIDs_C']").each(function () {
			$(this).checkbox('setValue', false);
		})
	}
});

// 与患者关系为本人
$HUI.combobox('#cboRelation_C',{
	onSelect:function(e,value){
		if (e.Code=='BR'){
			var RecordID	= globalObj.m_RecordIDs.split(',')[0]
			var aVolID		= RecordID.split('-')[0]
			
			$cm({
				ClassName:"MA.IPMR.SSService.VolumeSrv",
				MethodName:"GetPatInfo",
				aVolId:aVolID
			},'text'
			,function(jsonData){
				var tArray	= jsonData.responseText.split("^")
				
				$("#txtClientName_C").val(tArray[0]);
				$("#cboCertificate_C").combobox('setValue',tArray[1]);
				$("#txtIDCode_C").val(tArray[3]);
				$("#txtTelephone_C").val(tArray[5]);
				$("#txtAddress_C").val(tArray[4]);
			});
		}else{
			$("#txtClientName_C").val('');
			$("#cboCertificate_C").combobox('setValue','');
			$("#txtIDCode_C").val('');
			$("#txtTelephone_C").val('');
			$("#txtAddress_C").val('');
		}
	}
});