//ҳ��Gui
function InitMROBSItemMapWin(){
	var obj = new Object();
	var IsCheckFlag=false;
	obj.RecRowID= "";
	obj.layer_rd=""	
    
    obj.gridMROBSItemMap = $HUI.datagrid("#gridMROBSItemMap",{
		fit: true,
		title: "������Ŀ����ά��",
		iconCls:"icon-resort",
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
			{field:'BTItemDesc',title:'������Ŀ����',width:280,sortable:true},
			{field:'MapItemDesc',title:'��׼��Ŀ����',width:280}, 
			{field:'MapNote',title:'��ע',width:200},
			{field:'HospGroup',title:'ҽԺ',width:280},
			{field:'BTIsActive',title:'�Ƿ���Ч',width:80,
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			},
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridMROBSItemMap_onDbselect(rowData);						
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridMROBSItemMap_onSelect(rowData,rindex);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	obj.gridMROBSItem = $HUI.datagrid("#gridMROBSItem",{
		fit: true,
		title: "������Ŀ",
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
			{field:'BTItemCode',title:'����',width:20},
			{field:'BTItemDesc',title:'����',width:40,sortable:true},
			{field:'BTIsActive',title:'�Ƿ���Ч',width:20,
				formatter: function(value,row,index){
						return (value == '1' ? '��' : '��');
				}
			}
		]],
		onSelect: function (rowIndex, rowData) {
			if(!IsCheckFlag){
				IsCheckFlag = true;
				rowIndexTo=rowIndex;
			}else if(rowIndexTo==rowIndex){
				IsCheckFlag = false;
				$('#gridMROBSItem').datagrid("unselectRow",rowIndex);
			}else{
				IsCheckFlag = false;
				 }
			}
	});
	
	InitMROBSItemMapWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}