//ҳ��Gui
function InitCRuleDefWin(){
	var obj = new Object();
	obj.RecRowID= "";
	obj.RecRowID2= "";
	
	obj.gridCRuleDef = $HUI.datagrid("#gridCRuleDef",{
		fit: true,
		title: "��Ⱦ��ϱ�׼����",
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
			{field:'ID',title:'ID',width:70},
			{field:'InfPosCode',title:'��Ⱦ��ϴ���',width:200,sortable:true},
			{field:'InfPosDesc',title:'��Ⱦ�������',width:300}, 
			{field:'Title',title:'��׼����',width:200},
			{field:'Note',title:'��׼���',width:200},
			{field:'IndNo',title:'������',width:200},
			{field:'IsActive',title:'�Ƿ���Ч',width:160,
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			},
			{field:'MaxAge',title:'�������',width:200},
			{field:'MinAge',title:'����С��',width:200}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleDef_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleDef_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridCRuleDefExtLoad("");
		}
	});
	
	obj.gridCRuleDefExt = $HUI.datagrid("#gridCRuleDefExt",{
		fit: true,
		title: "��Ⱦ��ϱ�׼",
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
			{field:'ID',title:'ID',width:70},
			{field:'Title',title:'��׼����',width:120,sortable:true},
			{field:'Note',title:'��׼���',width:120,sortable:true},
			{field:'TypeDesc',title:'�������',width:120,sortable:true},
			{field:'IndNo',title:'������',width:100,sortable:true},
			{field:'IsActive',title:'�Ƿ���Ч',width:80,
				formatter: function(value,row,index){
						return (value == '1' ? '��' : '��');
				}
			}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
			var rowData = obj.gridCRuleDef.getSelected();
			if (rowData) {
				$("#btnAdd_one").linkbutton("enable");
				$("#btnEdit_one").linkbutton("disable");
				$("#btnDelete_one").linkbutton("disable");
			}else {
				$("#btnAdd_one").linkbutton("disable");
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleDefExt_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleDefExt_onDbselect(rowData);
			}
		}
	});
	
	//��Ⱦ�������
	/*obj.cboInfPos = $HUI.combobox("#cboInfPos", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'Desc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.InfPosSrv&QueryName=QryInfPosToSelect&ResultSetType=array";
		   	$("#cboInfPos").combobox('reload',url);
		}
	});*/
	$HUI.combobox('#cboInfPos',
	    {
			url:$URL+'?ClassName=DHCHAI.BTS.InfPosSrv&QueryName=QryInfPosToSelect&ResultSetType=Array',
			valueField:'ID',
			textField:'Desc',
			panelHeight:300,
			editable:true   		    
	    })
	
	//�������
	var TypeCode="DiagType";
	/*obj.cboDiagType = $HUI.combobox("#cboDiagType", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'DicDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+TypeCode;
		   	$("#cboDiagType").combobox('reload',url);
		}
	});*/
	$HUI.combobox('#cboDiagType',
	    {
			url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode='+TypeCode,
			valueField:'ID',
			textField:'DicDesc',
			panelHeight:300,
			editable:true   		    
	    })
	
	InitCRuleDefWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}