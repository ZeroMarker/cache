//ҳ��Gui
function InitCCItmScreenWin(){
	var obj = new Object();
	obj.RecRowID = "";
	
	//�����Ŀ�б�
	obj.gridCCItmScreen = $HUI.datagrid("#gridCCItmScreen",{
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
			{field:'ID',title:'ID',width:70,sortable:true,sorter:Sort_int},
			{field:'Desc',title:'��Ŀ����',width:200}, 
			{field:'Desc2',title:'��Ŀ����2',width:200},
			{field:'KeyWords',title:'�ؼ���',width:110,sortable:true},
			{field:'Arg1',title:'����1',width:70},
			{field:'Arg2',title:'����2',width:70},
			{field:'Arg3',title:'����3',width:70},
			{field:'Arg4',title:'����4',width:70},
			{field:'Arg5',title:'����5',width:70},
			{field:'Arg6',title:'����6',width:70},
			{field:'Arg7',title:'����7',width:70},
			{field:'Arg8',title:'����8',width:70},
			{field:'Arg9',title:'����9',width:70},
			{field:'Arg10',title:'����10',width:70},
			{field:'IsActive',title:'�Ƿ���Ч',width:80,
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCCItmScreen_onDbselect(rowData);						
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCCItmScreen_onSelect(rowData,rindex);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitCCItmScreenWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
	
}