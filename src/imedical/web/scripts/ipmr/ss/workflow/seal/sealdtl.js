/**
 * Sealdtl 病案封存信息
 * 
 * Copyright (c) 2018-2019 WHui. All rights reserved.
 * 
 * CREATED BY WHui 2019-11-28
 * 
 * 注解说明
 * TABLE: 
 */

var Seal_ArgsObj = {
	SubFlow		: '',
	SysOpera	: '',
	RequestID	: '',
	SealInfo	: ''
}

function InitSealView(aSubFlow,aSysOpera,aRequestID){
	$('#SealInfoDialog').css('display','block');
	var _title = "病案封存",_icon="icon-w-edit"
	var SealInfoDialog = $HUI.dialog('#SealInfoDialog',{
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
			Seal_ArgsObj.SubFlow	= aSubFlow;
			Seal_ArgsObj.SysOpera	= aSysOpera;
			Seal_ArgsObj.RequestID	= aRequestID;
			Seal_ArgsObj.SealInfo	= '';
			Common_ComboToDic("cboRelation_S","RelationType",1,'');
			Common_ComboToDic("cboCardType_S","Certificate",1,'');
			Common_ComboToDic("cboPurpose_S","SealReason",1,'');
			InitContentsTree();
		},
		buttons:[{
			text:'保存',
				iconCls:'icon-w-save',
				handler:function(){
					Seal_Save();
				}
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				closeView_seal();
			}	
		}]
	});
}

 // 初始化封存内容树
function InitContentsTree() {
	var ContentsTree_S = $HUI.treegrid("#ContentsTree_S",{
        url:$URL,
		fitColumns:true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers:true,
		autoSizeColumn:false,
		checkbox:true,
		queryParams:{
		    ClassName:"CT.IPMR.BTS.DictionarySrv",
			QueryName:"QryDicTree",
			aDicType:"SealContent",
			aIsActive:1,
			aHospID:''
	    },
        idField:'ID',
        treeField:'Desc',
        columns:[[
    		{title:'内容项',field:'Desc',width:250}
        ]]
	});
}

// 保存按钮
function Seal_Save(){
	var seal_Id				= $("#txtVolSealId").val();
	var seal_ClientName		= $("#txtClientName_S").val();					// 委托人
	var seal_Relation		= $("#cboRelation_S").combobox('getValue');		// 与患者关系
	var seal_CardType		= $("#cboCardType_S").combobox('getValue');		// 证明材料
	var seal_IDCode			= $("#txtIDCode_S").val();						// 证件号码
	
	var seal_Telephone		= $("#txtTelephone_S").val();					// 委托人电话
	var seal_Address		= $("#txtAddress_S").val();						// 委托人地址
	var seal_IsOriginal		= $("#chkIsOriginal_S").checkbox('getValue');	// 是否原件
	var seal_Purpose		= $('#cboPurpose_S').combobox('getValue');		// 封存原因
	var seal_Resume			= $("#txtResume_S").val();						// 备注
	
	var ContentsArr = $('#ContentsTree_S').treegrid('getCheckedNodes','checked');
	/*
	if (ContentsArr.length==0){
		$.messager.popover({msg: '封存内容必选！',type: 'alert',timeout: 1000});
		return
	}
	*/
	var seal_ContentIDs = '';
	for (var i=0;i<ContentsArr.length ;i++ ){
		var Contentid = ContentsArr[i].ID;
		 seal_ContentIDs = seal_ContentIDs + Contentid+ ","; 
	}
	if (seal_ContentIDs!="") { seal_ContentIDs = seal_ContentIDs.substring(0, seal_ContentIDs.length-1); }
	if (!seal_ClientName) {
		$.messager.popover({msg: '委托人必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!seal_Relation) {
		$.messager.popover({msg: '与患者关系必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!seal_CardType) {
		$.messager.popover({msg: '证明材料必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!seal_IDCode) {
		$.messager.popover({msg: '证件号码必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!seal_Telephone) {
		$.messager.popover({msg: '委托人电话必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!seal_Address) {
		$.messager.popover({msg: '委托人地址必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!seal_Purpose) {
		$.messager.popover({msg: '封存原因必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!seal_ContentIDs) {
		$.messager.popover({msg: '封存内容必选！',type: 'alert',timeout: 1000});
		return
	}
	
	//var Flag = Seal_ArgsObj.SubFlow + '|' + Seal_ArgsObj.SysOpera;
	var tmp = seal_Id + "^";				// seal_Id
		tmp += seal_ClientName + "^";		// 3. 委托人
		tmp += seal_Relation + "^";			// 4. 与患者关系
		tmp += seal_CardType + "^";			// 5. 证明材料
		tmp += seal_IDCode + "^";			// 6. 证件号码
		tmp += seal_Telephone + "^";		// 7. 委托人电话
		tmp += seal_Address + "^";			// 8. 委托人地址
		tmp += seal_IsOriginal + "^";		// 9. 是否原件
		tmp += seal_ContentIDs + "^";		// 10.封存内容
		tmp += seal_Purpose + "^";			// 11.封存原因
		tmp += seal_Resume;					// 12.备注
	
	Seal_ArgsObj.SealInfo	= tmp;
	
	SaveOpera(2);
	closeView_seal();
}

function closeView_seal(){
	$("#txtVolSealId").val('');
	$("#txtClientName_S").val('');
	$("#cboRelation_S").combobox('setValue','');
	$("#cboCardType_S").combobox('setValue','');
	$("#txtIDCode_S").val('');
	
	$("#txtTelephone_S").val('');
	$("#txtAddress_S").val('');
	$("#chkIsOriginal_S").checkbox('setValue',false);
	$("#cboPurpose_S").combobox('setValue','');
	$("#txtResume_S").val('');
	$('#SealInfoDialog').window("close");
}

// 与患者关系为本人
$HUI.combobox('#cboRelation_S',{
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
				
				$("#txtClientName_S").val(tArray[0]);
				$("#cboCardType_S").combobox('setValue',tArray[1]);
				$("#txtIDCode_S").val(tArray[3]);
				$("#txtTelephone_S").val(tArray[5]);
				$("#txtAddress_S").val(tArray[4]);
			});
		}else{
			$("#txtClientName_S").val('');
			$("#cboCardType_S").combobox('setValue','');
			$("#txtIDCode_S").val('');
			$("#txtTelephone_S").val('');
			$("#txtAddress_S").val('');
		}
	}
});

// 打印封存清单
function PrintSealList(aStatusID) {
	var templateName = 'ipmr.seal.list.xls';
	var getDataClass = 'MA.IPMR.SSService.VolumeSrv';
	var getDataMethod = 'PrintSealList' ;
	PrintDataToExcel(templateName,getDataClass,getDataMethod,aStatusID);
}