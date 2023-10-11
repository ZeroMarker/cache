$(function () {
	InitOROperCatWin();
});

//ҳ��Gui
function InitOROperCatWin() {
	var obj = new Object();
	var SelectedInd = 0;
	obj.RecRowID= "";
	obj.RecKeyID= "";

    //��������
    obj.gridOperCat= $HUI.datagrid("#gridOperCat",{
		fit: true,
		title: "��������",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: false, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
		queryParams:{
			ClassName:"DHCHAI.IRS.CRuleOperCatSrv",
			QueryName:"QryOperCat"
		},
		columns:[[
			{field:'OperCat',title:'��������',width:160,sortable:true},
			{field:'KeyTypeDesc',title:'�ؼ�������',width:100},
			{field:'IncludeKey',title:'������',width:150}, 
			{field:'ExcludeKeys',title:'�ų���',width:80},
			{field:'OperTypeDesc',title:'���',width:50}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridOperCat_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridOperCat_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			//�����н��кϲ�����
            //$(this).datagrid("autoMergeCells");
            //ָ���н��кϲ�����
            $(this).datagrid("autoMergeCells", ['OperCat']);
		}
	});
	
	obj.LoadgridOROper  = function() { 
		$HUI.datagrid("#gridOROper",{
			fit: true,
			title: "������Ϣ",
			iconCls:"icon-resort",
			headerCls:'panel-header-gray',
			pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
			rownumbers: false, //���Ϊtrue, ����ʾһ���к���
			nowrap:true,
			fitColumns: true,
			autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
			loadMsg:'���ݼ�����...',
			pageSize: 100,
			pageList : [100,200,500,1000],
			url:$URL,
			queryParams:{
				ClassName:"DHCHAI.IRS.CRuleOperCatSrv",
				QueryName:"QryOperAnaes",
				aOperCat:$('#cboOperCat').combobox('getValue'),
				aAlias:$('#searchbox').searchbox('getValue'),
				aShowAll:0
			},
			columns:[[
				{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
				{field:'OperICD',title:'��Ҫ����',width:150},
				{field:'OperDesc',title:'����',width:200,sortable:true},
				{field:'OperType',title:'���',width:100,sortable:true},
				{field:'OperCatList',title:'��������',width:300}
			]],
			onLoadSuccess:function(data){
				$("#gridOROper").datagrid('clearChecked');
				$("#btnOper").linkbutton("disable");
				$("#btnCancle").linkbutton("disable");
			},
			onSelect: function (rowIndex, rowData) {
				var rows = $("#gridOROper").datagrid('getChecked');
				var len = rows.length;
				if (len==1) {
					$("#btnOper").linkbutton("enable");
					$("#btnCancle").linkbutton("enable");
				}				
			},
			onCheck: function (rowIndex, rowData) {
				var rows = $("#gridOROper").datagrid('getChecked');
				var len = rows.length;
				if (len==1) {
					$("#btnOper").linkbutton("enable");
					$("#btnCancle").linkbutton("enable");
				}				
			},
			onCheckAll: function (rows) {
				$("#btnOper").linkbutton("enable");
				$("#btnCancle").linkbutton("enable");					
			},
			onSelectAll: function (rows) {
				$("#btnOper").linkbutton("enable");
				$("#btnCancle").linkbutton("enable");					
			},
			onUnselect: function (rowIndex, rowData) {
				var rows = $("#gridOROper").datagrid('getChecked');
				var len = rows.length;
				if (len==0) {
					$("#btnOper").linkbutton("disable");
					$("#btnCancle").linkbutton("disable");
				}				
			},
			onUncheck: function (rowIndex, rowData) {
				var rows = $("#gridOROper").datagrid('getChecked');
				var len = rows.length;
				if (len==0) {
					$("#btnOper").linkbutton("disable");
					$("#btnCancle").linkbutton("disable");
				}				
			},
			onUncheckAll: function (rows) {
				$("#btnOper").linkbutton("disable");
				$("#btnCancle").linkbutton("disable");							
			},		
			onUnselectAll: function (rows) {
				$("#btnOper").linkbutton("disable");
				$("#btnCancle").linkbutton("disable");							
			}		
		});
	}
	
	
	$HUI.combobox("#cboOperType",{
		data:[
			{value:'I',text:'����',selected:true},
			{value:'D',text:'����'}
		],
		editable: false,
		valueField:'value',
		textField:'text'
	});
	$HUI.combobox("#cboKeyType",{
		data:[
			{value:'K',text:'��������',selected:true},
			{value:'I',text:'ICD-9-CM-3'}
		],
		editable: false,
		valueField:'value',
		textField:'text'
	});
	
	$HUI.combobox("#cboOperCat",{
		allowNull: true,       //�ٴε��ȡ��ѡ��
		valueField:'ID',
		textField:'OperCat',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.IRS.CRuleOperCatSrv&QueryName=QryCRuleOperCat&ResultSetType=array&aIsActive=1";
			$("#cboOperCat").combobox('reload',url);
		}	
		,onSelect: function (rd) {
			var OperType =rd.OperType;
			$('#cboOperType').combobox('setValue',OperType);
			debugger
		}
	});

	
	$HUI.combobox("#cboOperCatMap",{
		allowNull: true,       //�ٴε��ȡ��ѡ��
		valueField:'ID',
		textField:'OperCat',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.IRS.CRuleOperCatSrv&QueryName=QryCRuleOperCat&ResultSetType=array&aIsActive=1";
			$("#cboOperCatMap").combobox('reload',url);
		}	
	});
	

	InitOROperCatWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}