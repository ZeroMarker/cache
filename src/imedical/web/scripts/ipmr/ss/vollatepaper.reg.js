/**
 * vollatepaper.reg 滞归登记
 * 
 * Copyright (c) 2018-2019 LIYI. All rights reserved.
 * 
 * CREATED BY LIYI 2021-05-11
 * 
 * 注解说明
 * TABLE: 
 */

//页面全局变量对象
var globalObj = {
	m_gridLatePaper : '',
	m_eidtRegId:'',
	m_fiestCatid:'',
	m_fiestCatCode:'',
	m_gridLatePaper_selectid:''		//数据行选择id
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	var tdateFrom	= Common_GetDate(0,"");
	var tdateTo		= Common_GetDate(0,"");	
	$('#dfDateFrom').datebox('setValue', tdateFrom);		// 给日期框赋值
	$('#dfDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	$('#btnModify').hide();
	Common_ComboToHosp("cboHosp",'',Logon.HospID);
	Common_ComboToMrType("cboMrType",ServerObj.MrClass);
	InitcboAdmList(0);
	Common_ComboToDic('cboLateCat','PaperLateCat',1,'');
	$('#cboLateCat').combobox({
		onLoadSuccess:function(data){   //初始加载赋值
			if (data.length>0){
				$('#cboLateCat').combobox('setValue', data[0].ID);
				InitgridLateSubCat(data[0].Code);
				globalObj.m_fiestCatid=data[0].ID;
				globalObj.m_fiestCatCode=data[0].Code;
			}
		}
	});
	Common_ComboToHosp("cboqHosp",'',Logon.HospID);
	Common_ComboToMrType("cboqMrType",ServerObj.MrClass);
	Common_ComboToDic('cboLateType','PaperLateType',1,'');
	Common_ComboToDicCode('cboDateType','LateRegDateType',1,'');
	Common_ComboGridToUser("cboRegUser","");
	globalObj.m_gridLatePaper = InitgridLatePaper();
	// 打开页面加载数据
	setTimeout(function(){
		$('#cboDateType').combobox('select',3);
		$('#gridLatePaper').datagrid('reload',  {
			ClassName:"MA.IPMR.SSService.VolLatePaperSrv",
			QueryName:"QryLatePaper",
			aHospID:$('#cboqHosp').combobox('getValue'),
			aMrTypeID:$('#cboqMrType').combobox('getValue'),
			aLatePaperType:'',
			aDateType:3,
			aDateFrom:$('#dfDateFrom').datebox('getValue'),
			aDateTo:$('#dfDateTo').datebox('getValue'),
			aDisLocID:'',
			aDisWardID:'',
			aRegUserID:'',
			aNumber:'',
			aIsRetrieve:'',
			rows:10000
		});
	},300)
	
}

function InitEvent(){
	$HUI.combobox('#cboqHosp',{
		onSelect:function(rows){
			Common_ComboToLoc("cboDiscLoc","","E",rows["HospID"],'I','');			// 科室
			Common_ComboToLoc("cboDiscWard","","W",rows["HospID"],'','');			// 病区
		}
	});
	// 科室、病区联动
	$('#cboDiscLoc').combobox({
	    onSelect:function(rows){
	    	var Hosp = $("#cboqHosp").combobox('getValue');
			Common_ComboToLoc("cboDiscWard","","W",Hosp,'','',rows["ID"]);			// 病区
	    },
	    onChange:function(rows){
	    	var Hosp = $("#cboqHosp").combobox('getValue');
	    	var LocID = $("#cboDiscLoc").combobox('getValue');
			Common_ComboToLoc("cboDiscWard","","W",Hosp,'','',LocID);			// 病区
	    }
	})
	
	$('#cboLateCat').combobox({
		onSelect: function(record){
			InitgridLateSubCat(record.Code)
		}
	});

	// 病案号|登记号|条码
	$('#txtNumber').bind('keyup', function(event) {					
	　　if (event.keyCode == "13") {
			InitcboAdmList(1);
	　　}
	});

	// 不完整登记
	$('#btnReg1').click(function(){
		SaveLatePaper(1);
	});	
		
	// 后滞单页登记
	$('#btnReg2').click(function(){
		SaveLatePaper(2);
	});
	// 修改
	$('#btnModify').click(function(){
		SaveLatePaper('');
	});

	
	// 查询按钮
	$('#btnQry').click(function(){
		var RegUserID=""
		var objRegUser = $('#cboRegUser').combogrid('grid').datagrid('getSelected');
		if (objRegUser!==null){
			RegUserID = objRegUser.ID;
		}
		$('#gridLatePaper').datagrid('reload',  {
			 ClassName:"MA.IPMR.SSService.VolLatePaperSrv",
			QueryName:"QryLatePaper",
			aHospID:$('#cboqHosp').combobox('getValue'),
			aMrTypeID:$('#cboqMrType').combobox('getValue'),
			aLatePaperType:$('#cboLateType').combobox('getValue'),
			aDateType:$('#cboDateType').combobox('getValue'),
			aDateFrom:$('#dfDateFrom').datebox('getValue'),
			aDateTo:$('#dfDateTo').datebox('getValue'),
			aDisLocID:$('#cboDiscLoc').combobox('getValue'),
			aDisWardID:$('#cboDiscWard').combobox('getValue'),
			aRegUserID:RegUserID,
			aNumber:$('#txtqNumber').val(),
			aIsRetrieve:'',
			rows:10000
		});
		$('#gridLatePaper').datagrid('unselectAll');
	});

	// 病案号|登记号|条码
	$('#txtqNumber').bind('keyup', function(event) {					
	　　if (event.keyCode == "13") {
			$('#gridLatePaper').datagrid('reload',  {
				ClassName:"MA.IPMR.SSService.VolLatePaperSrv",
				QueryName:"QryLatePaper",
				aHospID:$('#cboqHosp').combobox('getValue'),
				aMrTypeID:$('#cboqMrType').combobox('getValue'),
				aLatePaperType:'',
				aDateType:'',
				aDateFrom:'',
				aDateTo:'',
				aDisLocID:'',
				aDisWardID:'',
				aRegUserID:'',
				aNumber:$('#txtqNumber').val(),
				aIsRetrieve:'',
				rows:10000
			});
			$('#gridLatePaper').datagrid('unselectAll');
			$('#txtqNumber').val('');
	　　}
	});
	
	// 撤销
	$('#btnCancel').click(function(){
		var selectData	= $('#gridLatePaper').datagrid('getSelections');
		if (selectData.length==0){
			$.messager.popover({msg: '请选择需作废的记录！',type: 'alert',timeout: 1000});
			return false;
		}
		$.messager.prompt("提示", "输入作废原因:", function (r) {
			if (r) {
				var flg = $m({
					ClassName:"MA.IPMR.SS.VolLatePaper",
					MethodName:"CancelLatePaper",
					aLatePaperID:selectData[0].LatePaperID,
					aCancelUserID:Logon.UserID,
					aCancelReason:r
				},false);
				if (parseInt(flg) <= 0) {
					$.messager.alert("错误", "作废失败!" + '<br>' + flg, 'error');
				} else {
					//表单清空
					globalObj.m_gridLatePaper_selectid='';
					clearInput ();
					$('#gridLatePaper').datagrid('reload');
					$('#gridLatePaper').datagrid('unselectAll');
					$("#gridLatePaper").datagrid("clearSelections");
				}
			} else {
				if (r=='') {
					$.messager.popover({msg: '输入信息为空，未做任何操作！',type: 'alert',timeout: 1000});
				}
			}
		});
	});
	
	// 发送需求
	$('#btnSend').click(function(){
		var selectData	= $('#gridLatePaper').datagrid('getSelections');
		if (selectData.length==0){
			$.messager.popover({msg: '请选择需发送消息的记录！',type: 'alert',timeout: 1000});
			return false;
		}
		var LatePaperID=selectData[0].LatePaperID;
		var flg = $m({
			ClassName:"MA.IPMR.SS.VolLatePaper",
			MethodName:"SendUrgeMessage",
			aLatePaperIDs:LatePaperID,
			aUserID:Logon.UserID
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)==-1){
				$.messager.alert("错误", '保存信息失败！', 'error');
			}
			if (parseInt(flg)==-2){
				$.messager.alert("提示", '请在参数配置页面维护病案系统HIS端消息代码！', 'info');
			}else{
				$.messager.alert("错误", '消息发送失败！', 'error');
			}
		} else {
			$.messager.popover({msg: '消息发送成功！',type: 'success',timeout: 1000});
		}
	});
}
 /**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 登记模块
 * DATE: 2021-05-11
 * NOTE: 包括方法：
 * TABLE: 
 */
 function InitcboAdmList(isShowPanel) {
	var cbox = $HUI.combogrid("#cboAdmList", {
		url: $URL,
		panelWidth:600,
		panelHeight:200,
		editable: true,
		defaultFilter:4, 
		idField: 'VolID',
		textField: 'amdinfo',
		method:'Post',
		mode:'remote',
		multiple: false,
		enterNullValueClear:false,
		fitColumns:true,
		delay:500,
		columns:[[
		    {field:'MrNo',title:'病案号',width:120},
		    {field:'PatName',title:'姓名',width:120}, 
		    {field:'AdmDate',title:'入院日期',width:120},
		    {field:'DischDate',title:'出院日期',width:120},
		    {field:'DischLocDesc',title:'出院科室',width:200}
		   ]],
		onLoadSuccess:function(data){
			if (isShowPanel==1){
				if (data.total==1){
					$('#cboAdmList').combogrid('setValue', data.rows[0].VolID);
				}else{
					$('#cboAdmList').combo('showPanel');	
				}
			}
		},
		queryParams:{
			ClassName:'MA.IPMR.SSService.VolumeSrv',
			QueryName:'QryVolListByNo',
			aHospID:$('#cboHosp').combobox('getValue'),
			aMrTypeID:$('#cboMrType').combobox('getValue'),
			aInputNo:$('#txtNumber').val(),
			aDischFlg:1,
			rows:1000
		}
	});
	return  cbox;
 }
 // 初始化明细表格
function InitgridLateSubCat(CatCode) {
	var LateSubCatIDs = arguments[1];
	if (typeof(LateSubCatIDs)=='undefined') LateSubCatIDs='';
	var columns = [[
		{field:'workList_ck',title:'sel',checkbox:true},
		{field:'Desc',title:'明细项',width:250,align:'left'}
	]];
	var gridLateSubCat =$HUI.datagrid("#gridLateSubCat",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 50,
		fitColumns:false,
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
	    url:$URL,
	    queryParams:{
		    ClassName:"CT.IPMR.BTS.DictionarySrv",
			QueryName:"QryDictionary",
			aDicType:CatCode,
			aIsActive:1,
			aHospID:''
	    },
		columns:columns,
		onLoadSuccess: function (data) {
			if (data) {
				var arrLateSubCat = LateSubCatIDs.split(',');
				$.each(data.rows, function (index, item) {
					for (var i=0;i<=arrLateSubCat.length ;i++ ){
						if (arrLateSubCat[i]==item.ID)
						{
							$('#gridLateSubCat').datagrid('checkRow', index);
						}
					}
				});
			}
		}

			
	});
	return gridLateSubCat;
}

// 登记保存操作
function SaveLatePaper(LateTypeCode) {
	var VolID=""
	var objAdm = $('#cboAdmList').combogrid('grid').datagrid('getSelected');
	if (objAdm!==null){
		VolID = objAdm.VolID;
	}
	if (VolID==''){
		$.messager.popover({msg: '请选择就诊记录！',type: 'alert',timeout: 1000});
		return
	}
	var LateCatID = $("#cboLateCat").combobox('getValue');
	if (LateCatID==''){
		$.messager.popover({msg: '请选择项目大类！',type: 'alert',timeout: 1000});
		return
	}
	var selectSubCats	= $('#gridLateSubCat').datagrid('getSelections');
	if (selectSubCats.length==0){
		$.messager.popover({msg: '请勾选项目明细！',type: 'alert',timeout: 1000});
		return
	}
	var LateSubCatIDs = '';
	for (var i = 0; i < selectSubCats.length; i++) {
		var selRowArray = selectSubCats[i];
		LateSubCatIDs += ',' + selRowArray.ID;
	}
	if (LateSubCatIDs != '') LateSubCatIDs = LateSubCatIDs.substr(1,LateSubCatIDs.length-1);
	var LatePaperNum = $("#txtLatePaperNum").val();
	var Resume = $("#txtResume").val();
	
	if (LateTypeCode=='') // 修改操作
	{	var inputStr = globalObj.m_eidtRegId;
		inputStr += '^' + LateCatID;
		inputStr += '^' + LateSubCatIDs;
		inputStr += '^' + LatePaperNum;
		inputStr += '^' + Resume;

		var flg = $m({
			ClassName:"MA.IPMR.SS.VolLatePaper",
			MethodName:"ModifyLatePaper",
			aInputStr:inputStr,
			aSeparate:"^"
		},false);
	}else{
		var inputStr = '';
		inputStr += '^' + VolID;
		inputStr += '^' + LateTypeCode;
		inputStr += '^' + LateCatID;
		inputStr += '^' + LateSubCatIDs;
		inputStr += '^' + LatePaperNum;
		inputStr += '^' + '';
		inputStr += '^' + '';
		inputStr += '^' + Logon.UserID;
		inputStr += '^' + '1';
		inputStr += '^' + '';
		inputStr += '^' + '';
		inputStr += '^' + '';
		inputStr += '^' + '';
		inputStr += '^' + '0';
		inputStr += '^' + Resume;

		var flg = $m({
			ClassName:"MA.IPMR.SS.VolLatePaper",
			MethodName:"RegLatePaper",
			aInputStr:inputStr,
			aSeparate:"^"
		},false);
	}
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "保存失败!", 'error');
		return;
	}
	clearInput();
	$("#gridLatePaper").datagrid("reload");
}

// 清空登记区域表单
function clearInput () {
	$("#txtNumber").val('');
	$('#cboAdmList').combogrid('setValue', '');
	//$('#cboLateCat').combobox('setValue', '');
	//$('#cboLateCat').combobox('setValue', globalObj.m_fiestCatid);
	$('#gridLateSubCat').datagrid('unselectAll');
	$("#txtLatePaperNum").val('');
	$("#txtResume").val('');
	$('#gridLatePaper').datagrid('unselectAll');
	$('#btnModify').hide();
	$('#btnReg1').show();
	$('#btnReg2').show();
	globalObj.m_eidtRegId = '';
}

/**
 * NUMS: D002
 * CTOR: LIYI
 * DESC: 登记记录模块
 * DATE: 2021-05-11
 * NOTE: 包括方法：
 * TABLE: 
 */
 // 初始化登记记录表格
function InitgridLatePaper(){
	var columns = [[
		{field:'MrNo',title:'病案号',width:80,align:'left'},
		{field:'PatName',title:'姓名',width:80,align:'left'},
		{field:'DischLocDesc',title:'出院科室',width:150,align:'left'},
		{field:'DischDate',title:'出院日期',width:100,align:'left'},
		{field:'LateTypeDesc',title:'滞归类型',width:100,align:'left'},
		{field:'LateCatDesc',title:'项目大类',width:120,align:'left'},
		{field:'LateSubCatDesc',title:'缺项明细',width:150,align:'left'},
		{field:'VolStausDesc',title:'当前状态',width:100,align:'left'},
		{field:'LatePaperNum',title:'单页张数',width:80,align:'left'},
		{field:'DocName',title:'主治医师',width:80,align:'left'},
		{field:'Resume',title:'备注',width:100,align:'left'},
		{field:'BackDate',title:'回收日期',width:100,align:'left'},
		{field:'RetrieveDate',title:'回归日期',width:100,align:'left'},
		{field:'RetrieveUser',title:'回归操作员',width:100,align:'left'}
	
	]];
	var gridLatePaper =$HUI.datagrid("#gridLatePaper",{
		fit: true,
		title: "滞归记录",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:false,
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"MA.IPMR.SSService.VolLatePaperSrv",
			QueryName:"QryLatePaper",
			aHospID: '',
			aMrTypeID:'',
			aLatePaperType:'',
			aDateType:'',
			aDateFrom:'',
			aDateTo:'',
			aDisLocID:'',
			aDisWardID:'',
			aRegUserID:'',
			aNumber:'',
			aIsRetrieve:''
	    },
		columns:columns
		,onSelect:function(rowIndex,rowData) {
			if (globalObj.m_gridLatePaper_selectid!==rowIndex){
				//表单赋值
				$("#txtNumber").val(rowData.MrNo);
				InitcboAdmList(0)
				$('#cboAdmList').combogrid('setValue', rowData.VolID);
				$('#cboLateCat').combobox('setValue', rowData.LateCatID);
				InitgridLateSubCat(rowData.LateCatCode,rowData.LateSubCatIDs);
				$("#txtLatePaperNum").val(rowData.LatePaperNum);
				$("#txtResume").val(rowData.Resume);
				globalObj.m_gridLatePaper_selectid=rowIndex;
				globalObj.m_eidtRegId = rowData.LatePaperID;
				$('#btnModify').show();
				$('#btnReg1').hide();
				$('#btnReg2').hide();
			}else{
				//表单清空
				globalObj.m_gridLatePaper_selectid='';
				clearInput ();
			}
		}
	});
	return gridLatePaper;
}