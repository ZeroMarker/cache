//ҳ��Gui
function InitRBItmMastWin(){
	var obj = new Object();
	var IsCheckFlag=false;
	obj.RecRowID= "";
	obj.RecRowID2= "";
	obj.layer_rd=""	
	obj.layer2_rd="" 
    
    obj.gridRBItmMastMap = $HUI.datagrid("#gridRBItmMastMap",{
		fit: true,
		title: "�����Ŀ����",
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
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'BTMRCHKItem',title:'�������',width:240,sortable:true},
			{field:'MapItemDesc',title:'��׼����',width:240}, 
			{field:'BTMapNote',title:'��׼��ע',width:200},
			{field:'HospGroup',title:'ҽԺ',width:220},
			{field:'BTIsActive',title:'�Ƿ���Ч',width:80,
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridRBItmMastMap_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridRBItmMastMap_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
			$("#btnAll").linkbutton("enable");
			$("#btnPend").linkbutton("enable");
			$("#btnFin").linkbutton("enable");
			$("#btnSyn").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnAdd").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	//�����Ŀ
	obj.gridRBItmMast = $HUI.datagrid("#gridRBItmMast",{
		fit: true,
		title: "�����Ŀ",
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
			ClassName:"DHCHAI.DPS.RBItmMastSrv",
			QueryName:"QryRBItmMast"
		},
		columns:[[
			{field:'BTCode',title:'������',width:150},
			{field:'BTCName',title:'�������',width:150,sortable:true},
			{field:'BTIsActive',title:'�Ƿ���Ч',width:80,
				formatter: function(value,row,index){
						return (value == '1' ? '��' : '��');
				}
			}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridRBItmMast_onDbselect(rowData);						
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
		},
		onSelect: function (rowIndex, rowData) {
			if(!IsCheckFlag){
				IsCheckFlag = true;
				rowIndexTo=rowIndex;
			}else if(rowIndexTo==rowIndex){
				IsCheckFlag = false;
				$('#gridRBItmMast').datagrid("unselectRow",rowIndex);
			}else{
				IsCheckFlag = false;
				 }
			if (rowIndex>-1) {
				obj.gridRBItmMast_onSelect(rowData,rowIndex);
			}
		}
	});
	
	InitRBItmMastWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}