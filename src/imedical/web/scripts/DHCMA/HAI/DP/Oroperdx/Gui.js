//ҳ��Gui
function InitOROperDxWin(){
	var obj = new Object();
	var IsCheckFlag=false;
	obj.RecRowID= "";
	obj.RecRowID2= "";
	obj.layer_rd=""	
	obj.layer2_rd=""
    
    obj.gridOROperDxMap = $HUI.datagrid("#gridOROperDxMap",{
		fit: true,
		title: "��������ά��",
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
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'BTOperDesc',title:'��������',width:240,sortable:true},
			{field:'BTMapOperDesc',title:'��׼����',width:240}, 
			{field:'BTMapNote',title:'��ע',width:200},
			{field:'HospGroup',title:'ҽԺ',width:240},
			{field:'BTIsActive',title:'�Ƿ���Ч',width:80,
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			},
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridOROperDxMap_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridOROperDxMap_onDbselect(rowData);
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
	//������Ŀ
	obj.gridOROperDx = $HUI.datagrid("#gridOROperDx",{
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
			ClassName:"DHCHAI.DPS.OROperDxSrv",
			QueryName:"QryOROperDx"
		},
		columns:[[
			{field:'BTOperCode',title:'��������',width:150},
			{field:'BTOperDesc',title:'��������',width:200,sortable:true},
			{field:'IncDesc',title:'�пڵȼ�',width:100,sortable:true},
			{field:'BTIsActive',title:'�Ƿ���Ч',width:80,
				formatter: function(value,row,index){
						return (value == '1' ? '��' : '��');
				}
			}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridOROperDx_onDbselect(rowData);						
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
				$('#gridOROperDx').datagrid("unselectRow",rowIndex);
			}else{
				IsCheckFlag = false;
				 }
			if (rowIndex>-1) {
				obj.gridOROperDx_onSelect(rowData,rowIndex);
			}
		}
	});
	
	//�пڵȼ�
	var TypeCode="CuteType";
	obj.cboBTOperIncDr = $HUI.combobox("#cboBTOperIncDr", {
		url:$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+TypeCode,
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'DicDesc'
	});

	InitOROperDxWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}