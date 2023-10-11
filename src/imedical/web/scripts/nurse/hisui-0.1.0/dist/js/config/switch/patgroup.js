/**
 * @Author      yaojining
 * @DateTime    2021-05-6
 * @description 病人列表分组配置
 */
$(function() { 
	var GLOBAL = {
		HospEnvironment: true,
		HospitalID: session['LOGON.HOSPID']
	};
	function initPage(){
		initHosp();
		initUI();
		listenEvents();
	}
	/**
	 * @description 初始化医院
	 */
	function initHosp(){
		if (typeof GenHospComp == "undefined") {
			GLOBAL.HospEnvironment = false;
		}
		if(GLOBAL.HospEnvironment){
			var hospComp = GenHospComp('Nur_IP_LocGroup', session['LOGON.USERID'] + '^' + session['LOGON.GROUPID'] + '^' + session['LOGON.CTLOCID'] + '^' + session['LOGON.HOSPID']);  
			hospComp.options().onSelect = function(q, row){
				GLOBAL.HospitalID = row.HOSPRowId;
				initUI();
			}
		}else{
			$m({
				ClassName: 'NurMp.Common.Tools.Hospital', 
				MethodName: 'hospitalName', 
				HospitalID: session['LOGON.HOSPID']
			},function(hospDesc){
				$HUI.combobox("#_HospList", {
					width:350,
					valueField: 'HOSPRowId',
					textField: 'HOSPDesc',
					data: [{
						HOSPRowId: session['LOGON.HOSPID'],
						HOSPDesc: hospDesc
					}],
					value: session['LOGON.HOSPID'],
					disabled: true
				});
			});
		}
	}
	/**
	 * @description 初始化界面
	 */
	function initUI() {
		$HUI.combobox("#loc", {
			valueField: 'id',
			textField: 'desc',
			multiple:false,
			//rowStyle:'checkbox', //显示成勾选行形式
			disabled: false,
			url: $URL + "?ClassName=NurMp.Common.Tools.Utils&MethodName=conditionLocs&HospitalID=" + GLOBAL.HospitalID + "&LocType=W^E^EM^O^OP",
			defaultFilter: 4
		});
		$HUI.combobox("#arcim", {
			valueField: 'ID',
			textField: 'desc',
			multiple:true,
			rowStyle:'checkbox', //显示成勾选行形式
			disabled: false,
			url: $URL + '?ClassName=NurMp.Service.Patient.LocGroup&MethodName=getArcimDrs&Code=&HospitalID=' + GLOBAL.HospitalID,
			defaultFilter: 4
		});
		$HUI.datagrid('#locgrid',{
			url: $URL,
	        queryParams: {
	            ClassName: 'NurMp.Service.Patient.LocGroup',
	            QueryName: 'FindLocGroup',
	            HospitalID: GLOBAL.HospitalID,
	        },
			fit : true,
			columns: [[
				{field:'Desc',title:'科室名称',width:250},
				{field:'HideArcim', title:'隐藏医嘱名称', width:100, formatter:function(value, row, index){
		        	return !!value ? "是" : "否";	
		        }},
				{field:'Id',title:'科室ID',width:100},
				{field:'RowID',title:'RowID',width:100,hidden:true}
			]],
			toolbar:"#toolbar_Loc",
			idField:'Id',
			pagination: true,  //是否分页
			rownumbers: true,
			singleSelect: true,
			pageSize: 15,
			pageList : [15,30,50],
			loadMsg : '加载中..', 			
			onClickRow: function(rowIndex, rowData){ 
				$('#arcimgrid').datagrid('reload', {
					ClassName: 'NurMp.Service.Patient.LocGroup',
					QueryName: 'FindLocArcim',
					Param: rowData.RowID
				});
				$('#arcim').combobox('clear');
				$('#arcimgrid').datagrid('clearSelections');
       		}  
		});
		$HUI.datagrid('#arcimgrid',{
			url: $URL,
	        queryParams: {
	            ClassName: 'NurMp.Service.Patient.LocGroup',
	            QueryName: 'FindLocArcim',
				Param: ''
	        },
			fit : true,
			columns: [[
				{field:'ck',title:'sel',checkbox:true},
				{field:'Desc',title:'名称',width:400},
				{field:'Id',title:'ID',width:100}
			]],
			toolbar:"#toolbar_Arcim",
			idField:'Id',
			pagination: true,  //是否分页
			rownumbers: true,
			singleSelect: false,
			pageSize: 15,
			pageList : [15,30,50],
			loadMsg : '加载中..'
		});
	}
	/**
	 * @description 新增科室
	 */
	function addLoc() {
		var selectedLocIDs = $('#loc').combobox('getValues');
		$cm({
			ClassName: 'NurMp.Service.Patient.LocGroup',
			MethodName: 'saveLocGroup',
			Param: JSON.stringify(selectedLocIDs)
		},function(result){
			if(result.status == '1'){
				$.messager.alert("简单提示", result.msg, 'success');
				$('#locgrid').datagrid('clearSelections');
				$('#locgrid').datagrid('reload');
				$('#arcimgrid').datagrid('reload', {
					ClassName: 'NurMp.Service.Patient.LocGroup',
					QueryName: 'FindLocArcim',
					Param: ''
				});					
			}else{
				$.messager.alert("简单提示", result.msg, 'error');		
			}
		});
	}
	/**
	 * @description 删除科室
	 */
	function deleteLoc() {
		var records = $('#locgrid').datagrid('getSelections');
		if (records.length < 1) {
			$.messager.alert("简单提示", "请选择一条科室数据", 'error');
			return;
		}
		$cm({
			ClassName: 'NurMp.Service.Patient.LocGroup',
			MethodName: 'deleteLocGroup',
			Param: JSON.stringify(records)
		},function(result){
			if(result.status == '1'){
				$.messager.alert("简单提示", result.msg, 'success');
				$('#locgrid').datagrid('clearSelections');
				$('#locgrid').datagrid('reload');
				$('#arcimgrid').datagrid('reload', {
					ClassName: 'NurMp.Service.Patient.LocGroup',
					QueryName: 'FindLocArcim',
					Param: ''
				});							
			}else{
				$.messager.alert("简单提示", result.msg, 'error');		
			}
		});
	}
	/**
	 * @description 医嘱项名称
	 */
	function switchArcim(obj) {
		var records = $('#locgrid').datagrid('getSelections');
		if (records.length != 1) {
			$.messager.alert("简单提示", "请选择一个科室!", 'error');
			return;
		}
		var param = { ID: records[0].RowID, HideArcim: obj.data.type};
		$cm({
			ClassName: 'NurMp.Service.Patient.LocGroup',
			MethodName: 'updateLocGroup',
			Param: JSON.stringify(param)
		},function(result){
			if(result.status == '1'){
				$.messager.alert("简单提示", result.msg, 'success');
				$('#locgrid').datagrid('clearSelections');
				$('#locgrid').datagrid('reload');			
			}else{
				$.messager.alert("简单提示", result.msg, 'error');		
			}
		});
	}
	/**
	 * @description 新增医嘱项
	 */
	function addArcim() {
		var records = $('#locgrid').datagrid('getSelections');
		if (records.length != 1) {
			$.messager.alert("简单提示", "请选择一个科室!", 'error');
			return;
		}
		var selectedArcimIDs = $('#arcim').combobox('getValues');
		var param = { ID: records[0].RowID, ArcimDr: selectedArcimIDs};
		$cm({
			ClassName: 'NurMp.Service.Patient.LocGroup',
			MethodName: 'saveLocArcim',
			Param: JSON.stringify(param)
		},function(result){
			if(result.status == '1'){
				$.messager.alert("简单提示", result.msg, 'success');
				$('#arcimgrid').datagrid('clearSelections');
				$('#arcimgrid').datagrid('reload');						
			}else{
				$.messager.alert("简单提示", result.msg, 'error');		
			}
		});
	}
	/**
	 * @description 删除医嘱项
	 */
	function deleteArcim() {
		var records = $('#locgrid').datagrid('getSelections');
		if (records.length != 1) {
			$.messager.alert("简单提示", "请选择一个科室!", 'error');
			return;
		}
		var selectedArcimIDs = $('#arcimgrid').datagrid('getSelections');
		if (selectedArcimIDs.length < 1) {
			$.messager.alert("简单提示", "请选择医嘱", 'error');
			return;
		}
		var param = { ID: records[0].RowID, Arcim: selectedArcimIDs};
		$cm({
			ClassName: 'NurMp.Service.Patient.LocGroup',
			MethodName: 'deleteLocArcim',
			Param: JSON.stringify(param)
		},function(result){
			if(result.status == '1'){
				$.messager.alert("简单提示", result.msg, 'success');
				$('#arcimgrid').datagrid('clearSelections');
				$('#arcimgrid').datagrid('reload');					
			}else{
				$.messager.alert("简单提示", result.msg, 'error');		
			}
		});
	}
	/**
	 * @description 监听事件
	 */
	function listenEvents() {
		$('#btn_addLoc').bind('click',addLoc);
		$('#btn_deleteLoc').bind('click',deleteLoc);
		$('#btn_hideArcim').bind('click', {type:'H'}, switchArcim);
		$('#btn_showArcim').bind('click', {type:''}, switchArcim);
		$('#btn_addArcim').bind('click',addArcim);
		$('#btn_deleteArcim').bind('click',deleteArcim);
	}
	initPage();
});