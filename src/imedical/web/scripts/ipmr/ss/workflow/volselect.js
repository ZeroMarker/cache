/**
 * volselect 根据号码选择卷
 * 
 * Copyright (c) 2018-2019 WHui. All rights reserved.
 * 
 * CREATED BY WHui 2019-11-28
 * 
 * 注解说明
 * TABLE: 
 */

var VS_ArgsObj = {
	MrTypeID		: '',
	WFItemOBJ		: '',
	Number			: '',
	HospID			: '',
	PatName			: ''
}

function InitVolSelectView(){
	var _title = "病案卷列表",_icon="icon-w-edit"
	var VolSelDialog =$HUI.dialog('#VolSelDialog',{
		title:_title,
		iconCls:_icon,
		modal:true,
		minimizable:false,
		maximizable:false,
		collapsible:false,
	    buttons:[{
			text:'添加',
			iconCls:'icon-w-add',
			handler:function(){
					btn_SVSave();
			}
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				CleanArg();
				$('#VolSelDialog').window("close");		// 关闭页面
			}	
		}]
	});
	var a = globalObj.MrTypeID;
	$('#VolSelDialog').window('open');
}

 /**
 * NUMS: V001
 * CTOR: WHui
 * DESC: 卷列表查询
 * DATE: 2019-11-15
 * NOTE: 包括一个方法：InitGridVolSel
 * TABLE: 
 */
function InitGridVolSel(HospID,MrTypeID,WFItemOBJ,Number,PatName){
	VS_ArgsObj.HospID		= HospID;
	VS_ArgsObj.MrTypeID		= MrTypeID;
	VS_ArgsObj.WFItemOBJ	= WFItemOBJ;
	VS_ArgsObj.Number		= Number;
	VS_ArgsObj.PatName		= PatName;
	var columns = [[
		{field:'gVolSel_ck',checkbox:true},
		{field:'ProblemCode',title:'问题代码',hidden:true},
		{field:'ProblemDesc',title:'病历情况',width:100,align:'left'},
		{field:'PapmiNo',title:'登记号',width:100,align:'left'},
		{field:'PatName',title:'姓名',width:80,align:'left'},
		{field:'MrNo',title:'病案号',width:80,align:'left'},
		{field:'Sex',title:'性别',width:50,align:'left'},
		{field:'Age',title:'年龄',width:50,align:'left'},
		{field:'StepDesc',title:'当前步骤',width:80,align:'left'},
		{field:'VolStatusDesc',title:'当前状态',width:100,align:'left'},
		{field:'DischLocDesc',title:'出院科室',width:150,align:'left'},
		{field:'AdmDate',title:'就诊日期',width:100,align:'left'},
		{field:'DischDate',title:'出院日期',width:100,align:'left'},
	]];
	var gridVolSel = $HUI.datagrid("#gridVolSel",{
		fit:true,
		title:"",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false,		//如果为true, 则显示一个行号列
		singleSelect:false,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
		url:$URL,
		queryParams:{
			ClassName:"MA.IPMR.SSService.OperationQry",
			QueryName:"QrySelVolList",
			aHospID:HospID,
			aMrTypeID:MrTypeID,
			aWFItemID:WFItemOBJ.WFItemID,
			aInputNo:Number,
			aCatCode:'',
			aPatName:PatName,
			rows:100
		},
		columns :columns,
		rowStyler:function(index,row){
			if(row.ProblemCode!=='1'){
				return 'background-color:#BEBEBE;color:#fff;';
			}
		},
		onLoadSuccess: function(data){
			var noProblemCount = 0;  //可操作记录条数
			for (var i = 0; i < data.rows.length; i++) {
				if (data.rows[i].ProblemCode == '1') {
					noProblemCount++
				}
			}
			if (noProblemCount==1){	// 只有一条可操作记录直接加入列表
				for (var i = 0; i < data.rows.length; i++) {
					if (data.rows[i].ProblemCode == '1') {
						SaveInWorkList(data.rows[i].RecordID,data.rows[i].VolID);
						//$('#VolSelDialog').window("close");		// 关闭页面
					}
				}
			}else{
				if (data.rows.length > 0) {
					for (var i = 0; i < data.rows.length; i++) {
						if (data.rows[i].ProblemCode !== '1') {			// 根据ProblemCode让某些行不可选
							$("#VolSelView input:checkbox[name='gVolSel_ck']")[i].disabled = true;
						}
						InitVolSelectView();		//显示卷列表
					} 
				}
				$("#VolSelView .datagrid-header-check input").change( function() {
					var status = this.checked;
					$("#VolSelView input:checkbox[name='gVolSel_ck']").each(function(index, el){
						if (data.rows[index].ProblemCode!=='1')
						{
							this.checked=false;
							$("#gridVolSel").datagrid("unselectRow",index);
						}else{
							this.checked=true;
							$("#gridVolSel").datagrid("selectRow",index);
						}
					})
				});
			}
		},
		onClickRow: function(rowIndex, rowData){
			if (rowData.ProblemCode!=='1'){
				$('#gridVolSel').datagrid('unselectRow', rowIndex)
			}
		}
	});
}

// 卷选择页面添加按钮
function btn_SVSave(){
	var RecordIDs = '';
	var VolumeIDs = '';
	
	var data	= $("#gridVolSel").datagrid("getData");
	var selData	= $('#gridVolSel').datagrid('getSelections');
	var length	= data.total;
	var selLen	= selData.length;
	
	// 默认被勾选卷信息
	var RecordIDs = '';
	var VolumeIDs = '';
	for (var i = 0; i < selLen; i++) {
		var selRowArray = selData[i];
		RecordIDs += ',' + selRowArray.RecordID;
		VolumeIDs += ',' + selRowArray.VolID;
	}
	if (RecordIDs != '') RecordIDs = RecordIDs.substr(1,RecordIDs.length-1);
	if (VolumeIDs != '') VolumeIDs = VolumeIDs.substr(1,VolumeIDs.length-1);
	if (RecordIDs==''){
		$.messager.popover({msg: '请选择至少一条可操作的病案卷！',type: 'alert',timeout: 1000});
		return;
	}
	SaveInWorkList(RecordIDs,VolumeIDs);
	$('#VolSelDialog').window("close");		// 关闭页面
	Common_Focus('txtNumber');
}

// 将选中卷加到工作列表
function SaveInWorkList(aRecordIDs,VolumeIDs){
	var MrTypeID	= VS_ArgsObj.MrTypeID;
	var WFItemID	= VS_ArgsObj.WFItemOBJ.WFItemID;
	var RecordIDs	= aRecordIDs;
	var UserID		= Logon.UserID;
	var flg = $m({
		ClassName:"MA.IPMR.SSService.OperationWL",
		MethodName:"SetVolume",
		aMrTypeID:MrTypeID,
		aWFItemID:WFItemID,
		aRecordIDs:RecordIDs,
		aUserID:UserID,
		aCatCode:''
	},false);
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "添加失败!", 'error');
		return;
	}else{
		if (ServerObj.IsAutoBack=='1') {  // 扫码自动回收
			var ret = $m({
				ClassName:"MA.IPMR.SSService.OperationWL",
				MethodName:"AntoBack",
				aMrTypeID:MrTypeID,
				aWFItemID:WFItemID,
				aUserID:UserID,
				aRecordIDs:RecordIDs,
			},false);
			if (parseInt(ret) < 0) {
				$.messager.alert("错误提示", "自动回收失败!", 'error');
				return;
			}
		}
		CleanArg();
		ReLoadWorkList();	// 重新加载工作列表
		if (ServerObj.AutoPrintMBar=='1') {
			PrintBarCode('M',VolumeIDs)
		}
		if (ServerObj.AutoPrintVBar=='1') {
			PrintBarCode('V',VolumeIDs)
		}
		Common_Focus('txtNumber');
	}
}

// 清除数据
function CleanArg(){
	VS_ArgsObj	= {
		MrTypeID		: '',
		WFItemOBJ		: '',
		Number			: '',
		HospID			: '',
		PatName			: '',
	};
	$('#txtNumber').focus();
}