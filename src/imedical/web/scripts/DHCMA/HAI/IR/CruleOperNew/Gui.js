
//ҳ��Gui
function InitWin(){
	var obj = new Object();
	obj.RecRowID = "";
	$HUI.combobox("#txtDataSource", {
		valueField:'DicCode',
		defaultFilter:4,
		textField:'DicDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode="+"OperDataSource"+"&aActive="+"1";
			$("#txtDataSource").combobox('reload',url);
		}
	});
	obj.gridDicType = $HUI.datagrid("#gridDicType",{
		fit: true,
		//title: "�ֵ�����",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: false, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		nowrap:true,
		fitColumns: true,
		loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [20,50,100,200],
	   
		columns:[[
			{field:'ID',title:'ID',width:80,align:'center'},
			{field:'Code',title:'���Դ���',width:380},
			{field:'Desc',title:'��������',width:380},
			{field:'DataSource',title:'����Դ',width:380}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridDicType_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridDicType_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	
	
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}
$(InitWin);
