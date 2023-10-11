/**
 * copyqry 病案复印查询
 * 
 * Copyright (c) 2018-2019 WHui. All rights reserved.
 * 
 * CREATED BY WHui 2020-06-30
 * 
 * 注解说明
 * TABLE: 
 */
//页面全局变量对象


var globalObj = {

}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();

})

function Init(){
	var tdateFrom	= Common_GetDate("","FIRST");
	var tdateTo		= Common_GetDate("","LAST");	
	$('#aDateFrom').datebox('setValue', tdateFrom);		// 给日期框赋值
	$('#aDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
	Common_ComboToMrType("cboMrType",ServerObj.MrClass);
	
	InitgridCopyVol();
}

function InitEvent(){
	$('#btnQry').click(function(){
		QueryCopyVol();
	});					

	// 导出
	$('#btnExportVol').click(function(){
		var data = $('#gridCopyVol').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
			return;
		}
		$('#gridCopyVol').datagrid('Export', {
			filename: '复印统计',
			extension:'xls'
		});
	});		

}

/**
* NUMS: C001
* CTOR: WHui
* DESC: 病案复印查询
* DATE: 2020-06-30
* NOTE: 包括方法：InitgridCopyVol
* TABLE: 
*/
function InitgridCopyVol(){
	var columns = [[
		{field:'PapmiNo',title:'登记号',width:100,align:'left'},
		{field:'MrNo',title:'病案号',width:100,align:'left'},
		{field:'PatName',title:'姓名',width:80,align:'left'},
		{field:'ClientName',title:'委托人',width:80,align:'left'},
		{field:'ClientIDNum',title:'委托人证件号',width:100,align:'left'},
		{field:'ClientTel',title:'委托人电话',width:100,align:'left'},
		{field:'CopyContent',title:'复印内容',width:150,align:'left'},
		{field:'CopyPurpose',title:'复印目的',width:150,align:'left'},
		{field:'Resume',title:'备注',width:100,align:'left'},
		{field:'Detail',title:'详情',width:30,align:'left',
			formatter:function(value,row,index) {
				var CopyID = row.CopyID;
			   	return '<a href="#" class="grid-td-text-gray" onclick = showCopyDtl(' + CopyID + ')>' + $g('详情') + '</a>';            
			}
		}
	]];
	
	var gridCopyVol = $HUI.datagrid("#gridCopyVol",{
		fit:true,
		//title:"复印明细",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true,		//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		nowrap:false,
		url:$URL,
		queryParams:{
		    ClassName:"MA.IPMR.SSService.VolCopyQry",
		    QueryName:"QryCopyVol",
		    aHospital:'',
			aMrType:'',
			aDateFrom:'',
			aDateTo:'',
		    rows:10000
		},
		columns :columns,
		rowStyler:function(index,row){
				if(row.BackDate==""){
					//return 'background-color:#ff0000;';		
			}
		},
	});
}

/**
* NUMS: C002
* CTOR: WHui
* DESC: 复印查询
* DATE: 2020-06-30
* NOTE: 包括方法：QueryCopyVol
* TABLE: 
*/
function QueryCopyVol(){
	var HospID		= $('#cboHospital').combobox('getValue');
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	var DateFrom	= $('#aDateFrom').datebox('getValue');
	var DateTo		= $('#aDateTo').datebox('getValue');
	
	$('#gridCopyVol').datagrid('reload',  {
		ClassName:"MA.IPMR.SSService.VolCopyQry",
		QueryName:"QryCopyVol",
		aHospital:HospID,
		aMrType:MrTypeID,
		aDateFrom:DateFrom,
		aDateTo:DateTo,
		rows:10000
	});
	$('#gridCopyVol').datagrid('unselectAll');
}

/**
* NUMS: C003
* CTOR: WHui
* DESC: 查看复印信息
* DATE: 2020-06-30
* NOTE: 包括方法：showCopyDtl
* TABLE: 
*/
function showCopyDtl(aCopyID){
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
			Common_ComboToDic("cboRelation_C","RelationType",1,'');
			Common_ComboToDic("cboCertificate_C","Certificate",1,'');
			Common_CheckboxToDicID("cbgContentIDs_C","CopyContent","4");
			Common_CheckboxToDicID("cbgPurposes_C","CopyPurpose","4");
		},
		onOpen:function(){
			var copyInfo = $m({
				ClassName:"MA.IPMR.SSService.VolCopyQry",
				MethodName:"GetCopyInfo",
				aCopyID:aCopyID
			},false);
			var copyInfoArray		= copyInfo.split("#");
			var ClientName			= copyInfoArray[0];
			var ClientRelationDr	= copyInfoArray[1];
			var CertificateDr		= copyInfoArray[2];
			var IdentityCode		= copyInfoArray[3];
			var Telephone			= copyInfoArray[4];
			var Address				= copyInfoArray[5];
			var Number				= copyInfoArray[6];
			var ContentIDArr		= copyInfoArray[7].split(",");
			var PurposeIDArr		= copyInfoArray[8].split(",");
			var Resume				= copyInfoArray[9];
			
			$("#txtClientName_C").val(ClientName);
			$("#cboRelation_C").combobox('setValue',ClientRelationDr);
			$("#cboCertificate_C").combobox('setValue',CertificateDr);
			$("#txtIDCode_C").val(IdentityCode);
			$("#txtTelephone_C").val(Telephone);
			$("#txtAddress_C").val(Address);
			$("#txtNumber_C").val(Number);
			$("#txtResume_C").val(Resume);
			
			$("input[name='cbgContentIDs_C']").each(function () {
				$(this).radio('disable');	// 禁止编辑
				var tValue	= $(this).context.defaultValue;
				
				if (ContentIDArr.indexOf(tValue)>-1) {
					$(this).checkbox('setValue',true);
				}else{
					$(this).checkbox('setValue',false);
				}
			});
			
			$("input[name='cbgPurposes_C']").each(function () {
				$(this).radio('disable');	// 禁止编辑
				var tValue	= $(this).context.defaultValue;
				
				if (PurposeIDArr.indexOf(tValue)>-1) {
					$(this).checkbox('setValue',true);
				}else{
					$(this).checkbox('setValue',false);
				}
			})
			// 禁止编辑
			$('#txtClientName_C').attr("disabled", true);
			$('#cboRelation_C').combobox('disable');
			$('#cboCertificate_C').combobox('disable');
			$('#txtIDCode_C').attr("disabled", true);
			$('#txtTelephone_C').attr("disabled", true);
			$('#txtAddress_C').attr("disabled", true);
			$('#txtNumber_C').attr("disabled", true);
			$('#txtResume_C').attr("disabled", true);
		},
		buttons:[/*{
			text:'保存',
				iconCls:'icon-w-save',
				handler:function(){
					Copy_Save();
				}
		},*/{
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
	
}

// 关闭按钮
function closeView_copy(){
	$("#txtVolCopyId").val('');
	$("#txtClientName_C").val('');
	$("#cboRelation_C").combobox('setValue','');
	$("#cboCertificate_C").combobox('setValue','');
	$("#txtIDCode_C").val('');
	
	$("#txtTelephone_C").val('');
	$("#txtAddress_C").val('');
	$("#txtNumber_C").val('');
	$("input[name='cbgContentIDs_C']").each(function () {
		$(this).checkbox('setValue',false);
	});
	$("input[name='cbgPurposes_C']").each(function () {
		$(this).checkbox('setValue',false);
	})
	$("#txtResume_C").val('');
	
	$('#CopyInfoDialog').window("close");
}