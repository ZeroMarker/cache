//ҳ��Gui
function InitMROBSItemWin(){
	var obj = new Object();
	obj.RecRowID = "";
   
    obj.gridMROBSItem = $HUI.datagrid("#gridMROBSItem",{
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
		    ClassName:"DHCHAI.DPS.MROBSItemSrv",
			QueryName:"QryMROBSItem"
	    },
		columns:[[
			{field:'ID',title:'ID',width:70},
			{field:'BTItemCode',title:'����',width:280,sortable:true},
			{field:'BTItemDesc',title:'����',width:280}, 
			{field:'BTCatDesc',title:'����',width:280}, 
			{field:'BTIsActive',title:'�Ƿ���Ч',width:70,
				formatter: function(value,row,index){
						return (value == '1' ? '��' : '��');
				}
			}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridMROBSItem_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridMROBSItem_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	//�������
	obj.cboBTCatDr = $HUI.combobox("#cboBTCatDr", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'BTDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.DPS.MROBSItemCatSrv&QueryName=QryMROBSItemCat&ResultSetType=array";
		   	$("#cboBTCatDr").combobox('reload',url);
		}
	});
	
	InitMROBSItemWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}