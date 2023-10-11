//ҳ��Gui
function InitBaseMappingWin(){
	var obj = new Object();
	var IsCheckFlag=false;
	obj.RecRowID= "";
	obj.RecRowID2= "";
	obj.layer_rd="";
	obj.layer2_rd="";
	//����������
	obj.cbokind = $HUI.combobox('#cboCat', {              
		url:$URL,
		editable: true,
		mode: 'remote',
		valueField: 'xType',
		textField: 'xType',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCHAI.MAPS.CssMappingSrv';
			param.QueryName = 'QryBMType';
			param.ResultSetType = 'array'
		},
		onLoadSuccess:function(){   
			var data=$(this).combobox('getData');
			if (data.length>0){
				//$(this).combobox('select',data[0]['xType']);
			}
		}
	}); 
    
    obj.gridBaseMapping = $HUI.datagrid("#gridBaseMapping",{
		fit: true,
		title: "����ֵ���ֵ����",
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
			{field:'Type',title:'�������',width:240,sortable:true},
			{field:'KeyVal',title:'Ψһ��ֵ',width:200}, 
			{field:'KeyText',title:'��ֵ����',width:240},
			{field:'BRDesc',title:'��׼ֵ��',width:240},
			{field:'IsActDesc',title:'�Ƿ���Ч',width:80}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridBaseMapping_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridBaseMapping_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnAddMap").linkbutton("disable");
			$("#btnNoMap").linkbutton("enable");
			$("#btnDelMap").linkbutton("disable");
		}
	});
	//�����Ŀ
	obj.gridBaseRange = $HUI.datagrid("#gridBaseRange",{
		fit: true,
		title: "��׼ֵ���ֵ�",
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
			ClassName:"DHCHAI.MAPS.CssMappingSrv",
			QueryName:"QryBaseRange",
			aType:""
		},
		columns:[[
			{field:'Type',title:'�������',width:150},
			{field:'BRCode',title:'ֵ�����',width:100},
			{field:'BRDesc',title:'ֵ������',width:150,sortable:true},
			{field:'IsActDesc',title:'�Ƿ���Ч',width:80}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridBaseRange_onDbselect(rowData);						
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
				$('#gridBaseRange').datagrid("unselectRow",rowIndex);
			}else{
				IsCheckFlag = false;
				 }
			if (rowIndex>-1) {
				obj.gridBaseRange_onSelect(rowData,rowIndex);
			}
		}
	});
	
	InitBaseMappingWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}