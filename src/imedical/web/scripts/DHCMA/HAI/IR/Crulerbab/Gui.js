// ҳ��Gui
function InitCRuleRBAbWin(){
	var obj = new Object();
	obj.RecRowID= "";
	obj.RecRowID2= "";
	
	obj.gridCRuleRBAb = $HUI.datagrid("#gridCRuleRBAb",{
		fit: true,
		title: "����ɸ�����",
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
			{field:'RBCode',title:'�����Ŀ',width:200,sortable:true},
			{field:'RBPos',title:'��鲿λ',width:300}, 
			{field:'RBNote',title:'˵��',width:200},
			{field:'RBCFlag',title:'ɸ���־',width:160,
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleRBAb_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleRBAb_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.RecRowID="";
			$("#btnAdd_one").linkbutton("disable");
			$('#gridCRuleRBCode').datagrid('loadData',{total:0,rows:[]});
		}
	});
	
	obj.gridCRuleRBCode = $HUI.datagrid("#gridCRuleRBCode",{
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
		pageList : [10,20,50,100,200],
		columns:[[
			{field:'RBCodeDesc',title:'�����Ŀ',width:200},
			{field:'ActDate',title:'��������',width:200,sortable:true,
				formatter: function(value,row,index){
						return value + ' ' + row["ActTime"];
					}
			},
			{field:'ActUser',title:'������',width:150,sortable:true}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleRBCode_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleRBCode_onDbselect(rowData);
			}
		}
	});
	//��Ⱦ�������
	$HUI.combobox('#cboRBCodeDr',
	    {
			url:$URL+'?ClassName=DHCHAI.DPS.RBItmMastMapSrv&QueryName=QryRBItmMastMapByInit&ResultSetType=Array',
			valueField:'ID',
			textField:'BTMRCHKItem',
			panelHeight:300,
			editable:true   		    
	    })
	/*obj.cboRBCodeDr = $HUI.combobox("#cboRBCodeDr", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'BTMRCHKItem',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.DPS.RBItmMastMapSrv&QueryName=QryRBItmMastMapByInit&ResultSetType=array";
		   	$("#cboRBCodeDr").combobox('reload',url);
		}
	});*/
	
	InitCRuleRBAbWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}