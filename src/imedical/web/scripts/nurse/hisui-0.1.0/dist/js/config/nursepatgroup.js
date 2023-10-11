/**
 * @Author      yaojining
 * @DateTime    2021-05-6
 * @description �����б��������
 */
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ConfigTableName: 'Nur_IP_LocGroup'
};

$(initUI);

function initUI(){
	initHosp(initPage);
	listenEvents();
}

/**
 * @description ��ʼ������
 */
function initPage() {
	$HUI.combogrid("#loc", {
		url: $URL,
		queryParams:{
			ClassName: "NurMp.Common.Base.Hosp",
			QueryName: "FindHospLocs",
			HospitalID:GLOBAL.HospitalID, 
			ConfigTableName:"Nur_IP_LocGroup"
		},
		mode:'remote',
		idField: 'LocId',
		textField: 'LocDesc',
		columns: [[
			{field:'Checkbox',title:'sel',checkbox:true},
			{field:'LocDesc',title:'����',width:100},
			{field:'HospDesc',title:'Ժ��',width:100},
			{field:'LocId',title:'ID',width:40}
		]],
		multiple:true,
		singleSelect:false,
		fitColumns: true,
		panelWidth: 500,
		panelHeight: 420,
		delay:500,
		pagination : true,
		enterNullValueClear:true,
		defaultFilter: 4
	});
	$HUI.combogrid("#arcim", {
		url: $URL,
		queryParams:{
			ClassName: "NurMp.Service.Patient.LocGroup",
			QueryName: "FindArcims",
			HospitalID: GLOBAL.HospitalID
		},
		mode:'remote',
		idField: 'Id',
		textField: 'ArcimDesc',
		columns: [[
			{field:'Checkbox',title:'sel',checkbox:true},
			{field:'ArcimDesc',title:'����',width:100},
			{field:'Id',title:'ID',width:40}
		]],
		multiple:true,
		singleSelect:false,
		fitColumns: true,
		panelWidth: 500,
		panelHeight: 420,
		delay:500,
		pagination : true,
		enterNullValueClear:true,
		efaultFilter: 4
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
			{field:'Desc',title:'��������',width:250},
			{field:'HideArcim', title:'����ҽ������', width:100, formatter:function(value, row, index){
	        	return !!value ? "��" : "��";	
	        }},
			{field:'Id',title:'����ID',width:100},
			{field:'RowID',title:'RowID',width:100,hidden:true}
		]],
		toolbar:"#toolbar_Loc",
		idField:'Id',
		pagination: true,  //�Ƿ��ҳ
		rownumbers: true,
		singleSelect: true,
		pageSize: 15,
		pageList : [15,30,50],
		loadMsg : '������..', 			
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
			{field:'Desc',title:'����',width:400},
			{field:'Id',title:'ID',width:100}
		]],
		toolbar:"#toolbar_Arcim",
		idField:'Id',
		pagination: true,  //�Ƿ��ҳ
		rownumbers: true,
		singleSelect: false,
		pageSize: 15,
		pageList : [15,30,50],
		loadMsg : '������..'
	});
}
/**
 * @description ��������
 */
function addLoc() {
	var selectedLocIDs = $('#loc').combobox('getValues');
	if (selectedLocIDs.length == 0) {
		$.messager.alert("����ʾ", "��ѡ����Ҫ��ӵĽ��տ���!", 'error');
		return;
	}
	$cm({
		ClassName: 'NurMp.Service.Patient.LocGroup',
		MethodName: 'saveLocGroup',
		Param: JSON.stringify(selectedLocIDs)
	},function(result){
		if(result.status == '1'){
			$.messager.alert("����ʾ", result.msg, 'success');
			$('#loc').combogrid('clear');
			$('#loc').combogrid('grid').datagrid('options').queryParams.q = '';
			$('#loc').combogrid('grid').datagrid('reload');
			$('#locgrid').datagrid('clearSelections');
			$('#locgrid').datagrid('reload');
			$('#arcimgrid').datagrid('reload', {
				ClassName: 'NurMp.Service.Patient.LocGroup',
				QueryName: 'FindLocArcim',
				Param: ''
			});					
		}else{
			$.messager.alert("����ʾ", result.msg, 'error');		
		}
	});
}
/**
 * @description ɾ������
 */
function deleteLoc() {
	var records = $('#locgrid').datagrid('getSelections');
	if (records.length < 1) {
		$.messager.alert("����ʾ", "��ѡ��һ����������", 'error');
		return;
	}
	$.messager.confirm("����", "ȷ��Ҫɾ����", function (r) {
		if (r) {
			$cm({
				ClassName: 'NurMp.Service.Patient.LocGroup',
				MethodName: 'deleteLocGroup',
				Param: JSON.stringify(records)
			},function(result){
				if(result.status == '1'){
					$.messager.alert("����ʾ", result.msg, 'success');
					$('#locgrid').datagrid('clearSelections');
					$('#locgrid').datagrid('reload');
					$('#arcimgrid').datagrid('reload', {
						ClassName: 'NurMp.Service.Patient.LocGroup',
						QueryName: 'FindLocArcim',
						Param: ''
					});							
				}else{
					$.messager.alert("����ʾ", result.msg, 'error');		
				}
			});
		} else {
			return;
		}
	});
}
/**
 * @description ҽ��������
 */
function switchArcim(obj) {
	var records = $('#locgrid').datagrid('getSelections');
	if (records.length != 1) {
		$.messager.alert("����ʾ", "��ѡ��һ������!", 'error');
		return;
	}
	var param = { ID: records[0].RowID, HideArcim: obj.data.type};
	$cm({
		ClassName: 'NurMp.Service.Patient.LocGroup',
		MethodName: 'updateLocGroup',
		Param: JSON.stringify(param)
	},function(result){
		if(result.status == '1'){
			$.messager.alert("����ʾ", result.msg, 'success');
			$('#locgrid').datagrid('clearSelections');
			$('#locgrid').datagrid('reload');			
		}else{
			$.messager.alert("����ʾ", result.msg, 'error');		
		}
	});
}
/**
 * @description ����ҽ����
 */
function addArcim() {
	var records = $('#locgrid').datagrid('getSelections');
	if (records.length != 1) {
		$.messager.alert("����ʾ", "��ѡ��һ������!", 'error');
		return;
	}
	var selectedArcimIDs = $('#arcim').combobox('getValues');
	if (selectedArcimIDs.length < 1) {
		$.messager.alert("����ʾ", "��ѡ��ҽ����!", 'error');
		return;
	}
	var param = { ID: records[0].RowID, ArcimDr: selectedArcimIDs};
	$cm({
		ClassName: 'NurMp.Service.Patient.LocGroup',
		MethodName: 'saveLocArcim',
		Param: JSON.stringify(param)
	},function(result){
		if(result.status == '1'){
			$.messager.alert("����ʾ", result.msg, 'success');
			$('#arcim').combogrid('clear');
			$('#arcim').combogrid('grid').datagrid('options').queryParams.q = '';
			$('#arcim').combogrid('grid').datagrid('reload');
			$('#arcimgrid').datagrid('clearSelections');
			$('#arcimgrid').datagrid('reload');					
		}else{
			$.messager.alert("����ʾ", result.msg, 'error');		
		}
	});
}
/**
 * @description ɾ��ҽ����
 */
function deleteArcim() {
	var records = $('#locgrid').datagrid('getSelections');
	if (records.length != 1) {
		$.messager.alert("����ʾ", "��ѡ��һ������!", 'error');
		return;
	}
	var selectedArcimIDs = $('#arcimgrid').datagrid('getSelections');
	if (selectedArcimIDs.length < 1) {
		$.messager.alert("����ʾ", "��ѡ��ҽ��", 'error');
		return;
	}
	$.messager.confirm("����", "ȷ��Ҫɾ����", function (r) {
		if (r) {
			var param = { ID: records[0].RowID, Arcim: selectedArcimIDs};
			$cm({
				ClassName: 'NurMp.Service.Patient.LocGroup',
				MethodName: 'deleteLocArcim',
				Param: JSON.stringify(param)
			},function(result){
				if(result.status == '1'){
					$.messager.alert("����ʾ", result.msg, 'success');
					$('#arcimgrid').datagrid('clearSelections');
					$('#arcimgrid').datagrid('reload');					
				}else{
					$.messager.alert("����ʾ", result.msg, 'error');		
				}
			});
		} else {
			return;
		}
	});
}
/**
 * @description �����¼�
 */
function listenEvents() {
	$('#btn_addLoc').bind('click',addLoc);
	$('#btn_deleteLoc').bind('click',deleteLoc);
	$('#btn_hideArcim').bind('click', {type:'H'}, switchArcim);
	$('#btn_showArcim').bind('click', {type:''}, switchArcim);
	$('#btn_addArcim').bind('click',addArcim);
	$('#btn_deleteArcim').bind('click',deleteArcim);
}