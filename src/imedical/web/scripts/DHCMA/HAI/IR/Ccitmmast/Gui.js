//ҳ��Gui
function InitCCItmMastWin(){
	var obj = new Object();
	obj.RecRowID = "";
	
	//�����Ŀ�б�
	obj.gridCCItmMast = $HUI.datagrid("#gridCCItmMast",{
		fit: true,
		title: "",
		headerCls:'panel-header-gray',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: false, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		sortName:'ID',
		sortOrder:'asc',
		remoteSort:false,    //�Ƿ��Ƿ���������������
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [10,20,50,100,200],
		columns:[[
			{field:'ID',title:'ID',width:50,sortable:true,sorter:Sort_int},
			{field:'Code',title:'����',width:200,sortable:true},
			{field:'Desc',title:'����',width:200}, 
			{field:'IsActive',title:'�Ƿ���Ч',width:100,
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			},
			{field:'ActDate',title:'��������ʱ��',width:200},
			{field:'ActUserDesc',title:'������',width:200}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCCItmMast_onDbselect(rowData);						
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCCItmMast_onSelect(rowData,rindex);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitCCItmMastWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}