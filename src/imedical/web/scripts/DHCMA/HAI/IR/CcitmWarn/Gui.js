//ҳ��Gui
function InitCCItmWarnWin(){
	var obj = new Object();
	obj.RecRowID = "";
	
	//�����Ŀ�б�
	obj.gridCCItmWarn = $HUI.datagrid("#gridCCItmWarn",{
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
			{field:'Desc',title:'��Ŀ����',width:200}, 
			{field:'Desc2',title:'��Ŀ����2',width:200},
			{field:'KeyWords',title:'�ؼ���',width:200,sortable:true},
			{field:'IndNo',title:'������',width:200},
			{field:'Arg1',title:'����1',width:100},
			{field:'Arg2',title:'����2',width:100},
			{field:'Arg3',title:'����3',width:300},
			{field:'Arg4',title:'����4',width:100},
			{field:'Arg5',title:'����5',width:100},
			{field:'IsActive',title:'�Ƿ���Ч',width:100,
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			},
			{field:'ActDate',title:'��������ʱ��',width:300},
			{field:'ActUserDesc',title:'������',width:200}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCCItmWarn_onDbselect(rowData);						
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCCItmWarn_onSelect(rowData,rindex);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitCCItmWarnWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}