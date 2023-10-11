//ҳ��Gui
var obj = new Object();
function InitLocRelevWin(){
	obj.ClickLocID="";
	obj.RecRowID="";
	obj.relevCount=0;
	
	obj.gridLocRelev = $HUI.datagrid("#gridLocRelev",{
		fit: true,
		title: "���������ά��",
		headerCls:'panel-header-gray',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: false, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		nowrap:true,
		fitColumns:true,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'Name',title:'����',width:240,sortable:true},
			{field:'LocDescList',title:'�����б�',width:240}, 
			{field:'IsActive',title:'�Ƿ���Ч',width:150,
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			},
			{field:'ActUser',title:'������',width:240},
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLocRelev_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridLocRelev_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	//�����Ŀ
	obj.gridLoc = $HUI.datagrid("#gridLoc",{
		fit: true,
		title: "�����Ŀ",
		headerCls:'panel-header-gray',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: false, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'LocCode',title:'����',width:150},
			{field:'LocDesc2',title:'����',width:150,sortable:true},
			{field:'null',title:'����',width:150,
				formatter: function(value,row,index){
					if(row.IsRelev=='1'){
						obj.relevCount+=1;
						return '<a href="#"><span class="icon-cancel-ref" data-options="plain:true" onclick=obj.Relev_Click('+row['ID']+','+row['IsRelev']+ ')>&nbsp;&nbsp;&nbsp;&nbsp;</span> ȡ������ </a>';
					}else if(row.IsRelev=='0'){
						return '<a href="#"><span class="icon-ref" data-options="plain:true" onclick=obj.Relev_Click('+row['ID']+','+row['IsRelev']+ ')>&nbsp;&nbsp;&nbsp;&nbsp;</span> ���� </a>';
					}else{
						return '';
					}
				}
			}
		]],
		onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				obj.gridLoc_onSelect();
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
		}
	});
	
	//����������
 	var CatList = $cm ({
		ClassName:"DHCHAI.BTS.DictionarySrv",
		QueryName:"QryDic",
		aTypeCode:"LocRelevant",
		aActive:"1"
	},false);
	obj.CatData = CatList.rows;
	obj.cboCat = $HUI.combobox("#cboCat", {
		editable: false,     
		valueField: 'ID',
		textField: 'DicDesc',
		selected:true,
		data:obj.CatData,
		onLoadSuccess:function(data){
			$('#cboCat').combobox('select',data[0].ID);
		}
	});
	
	InitLocRelevWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}