//ҳ��Gui
function InitCRuleOperWin(){
	var obj = new Object();
	obj.RecRowID= "";
	obj.RecRowID2= "";
	//�����б�
	obj.gridCRuleOper = $HUI.datagrid("#gridCRuleOper",{
		fit: true,
		title: "����ɸ���б�",
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
		loadFilter:pagerFilter,
		columns:[[
			{field:'ID',title:'ID',width:70},
			{field:'Type',title:'����',width:200,sortable:true,
				formatter: function(value,row,index){
					switch(value){
						case "1":
							return "ȫԺ";
							break;
						case "2":
							return "Ժ��";
							break;
						case "3":
							return "����";
							break;
						default:
							return "ȫԺ";
					}
				}
			},
			{field:'GrpDesc',title:'ҽԺ����',width:300}, 
			{field:'HospDesc',title:'Ժ��',width:200},
			{field:'LocDesc',title:'����',width:200},
			{field:'IncDesc',title:'�п�����',width:200},
			{field:'Operation',title:'��������',width:200},
			{field:'IsActive',title:'�Ƿ���Ч',width:160,
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleOper_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleOper_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	//�����ؼ���
	obj.gridCRuleOperKeys = $HUI.datagrid("#gridCRuleOperKeys",{
		fit: true,
		title: "�����ؼ���",
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
			{field:'InWord',title:'������',width:200,sortable:true},
			{field:'ExWords',title:'�ų���',width:200,sortable:true}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleOperKeys_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleOperKeys_onDbselect(rowData);
			}
		}
	});
	
	//����
	obj.cboLocation = $HUI.combobox("#cboLocation", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'LocDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.IRS.CRuleOperSrv&QueryName=QryOperLocList&ResultSetType=array";
		   	$("#cboLocation").combobox('reload',url);
		}
	});
	//�п�����
	var TypeCode="CuteType";
	obj.cboOperInc = $HUI.combobox("#cboOperInc", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'DicDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+TypeCode;
		   	$("#cboOperInc").combobox('reload',url);
		}
	});
	
	InitCRuleOperWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}