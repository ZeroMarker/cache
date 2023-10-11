//ҳ��Gui
function InitMROBSItemCatWin(){
	var obj = new Object();
	obj.RecRowID = "";
    $.parser.parse(); // ��������ҳ�� 
    
    obj.gridMROBSItemCat = $HUI.datagrid("#gridMROBSItemCat",{
		fit: true,
		title: "",
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
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.DPS.MROBSItemCatSrv",
			QueryName:"QryMROBSItemCat"
	    },
		columns:[[
			{field:'ID',title:'ID',width:200},
			{field:'BTCode',title:'����',width:500,sortable:true},
			{field:'BTDesc',title:'����',width:500}, 
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridMROBSItemCat_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridMROBSItemCat_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitMROBSItemCatWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}