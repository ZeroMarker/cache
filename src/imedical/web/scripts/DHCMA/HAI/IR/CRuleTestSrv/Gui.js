//ҳ��Gui
function InitCRuleTestSrvWin(){
	var obj = new Object();
	var IsCheckFlag=false;
	obj.RecRowID= "";
	obj.RecRowID1= "";
	obj.RecRowID2= "";
	obj.RecRowID3= "";
	obj.RecRowID4= "";
	//ҳǩ�л�����ֵ
	obj.TabArgs = new Object();
	obj.TabArgs.ContentID = '';	
	
	obj.gridCRuleTsAb = $HUI.datagrid("#gridCRuleTsAb",{
		fit: true,
		title: "���������Ŀ",
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
			{field:'ID',title:'ID',width:80},
			{field:'TestSet',title:'�������',width:420,sortable:true},
			{field:'TestCode',title:'������Ŀ',width:420}, 
			{field:'IsActive',title:'�Ƿ�<br>��Ч',width:100,
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			},
			{field:'TSPFlag',title:'�Ƚ�<br>�걾',width:100,
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			},
			{field:'TRFFlag',title:'�Ƚ�<br>�쳣',width:100,
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			},
			{field:'TRFlag',title:'�Ƚ�<br>���',width:100,
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			},
			{field:'TRVMaxFlag',title:'�Ƚ�<br>����',width:100,
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			},
			{field:'MaxValM',title:'����ֵ(��)',width:180},
			{field:'MaxValF',title:'����ֵ(Ů)',width:180},
			{field:'TRVMinFlag',title:'�Ƚ�<br>����',width:100,
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			},
			{field:'MinValM',title:'����ֵ(��)',width:180},
			{field:'MinValF',title:'����ֵ(Ů)',width:180}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleTsAb_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleTsAb_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	//�ͼ�걾
	obj.gridCRuleTSSpec = $HUI.datagrid("#gridCRuleTSSpec",{
		fit: true,
		//title: "�ͼ�걾",
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
			{field:'TSSpec',title:'�걾����',width:200,sortable:true},
			{field:'MapSpec',title:'�걾����',width:150,sortable:true}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleTSSpec_onSelect();
			}
		},
		onLoadSuccess:function(data){		
			if (obj.RecRowID) {
				$("#btnAdd_one").linkbutton("enable");
				$("#btnEdit_one").linkbutton("disable");
				$("#btnDelete_one").linkbutton("disable");
			}
			dispalyEasyUILoad(); //����Ч��
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleTSSpec_onDbselect(rowData);
			}
		}
	});
	//������Ŀ
	obj.gridCRuleTSCode = $HUI.datagrid("#gridCRuleTSCode",{
		fit: true,
		//title: "������Ŀ",
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
			{field:'TCMCode',title:'������Ŀ',width:100,sortable:true},
			{field:'TCMDesc',title:'��Ŀ����',width:240,sortable:true},
			{field:'MapRstFormat',title:'�������',width:100,sortable:true}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleTSCode_onSelect();
			}
		},
		onLoadSuccess:function(data){
			if (obj.RecRowID) {
				$("#btnAdd_two").linkbutton("enable");
				$("#btnEdit_two").linkbutton("disable");
				$("#btnDelete_two").linkbutton("disable");
			}
			dispalyEasyUILoad(); //����Ч��
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleTSCode_onDbselect(rowData);
			}
		}
	});
	//������
	obj.gridCRuleTSResult = $HUI.datagrid("#gridCRuleTSResult",{
		fit: true,
		//title: "������",
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
			{field:'TestCode',title:'������Ŀ',width:240,sortable:true},
			{field:'TestResult',title:'������',width:100,sortable:true},
			{field:'MapText',title:'��׼ֵ',width:100,sortable:true}
		]],
		onLoadSuccess:function(data){
			if (obj.RecRowID) {
				$("#btnAdd_three").linkbutton("enable");
				$("#btnEdit_three").linkbutton("disable");
				$("#btnDelete_three").linkbutton("disable");
			}
			dispalyEasyUILoad(); //����Ч��
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleTSResult_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleTSResult_onDbselect(rowData);
			}
		}
	});
	//�쳣��־
	obj.gridCRuleTsAbRstFlag = $HUI.datagrid("#gridCRuleTsAbRstFlag",{
		fit: true,
		//title: "�쳣��־",
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
			{field:'TestCode',title:'������Ŀ',width:240,sortable:true},
			{field:'TSRstFlag',title:'�쳣��־',width:100,sortable:true},
			{field:'MapText',title:'��׼ֵ',width:100,sortable:true}
		]],
		onLoadSuccess:function(data){
			if (obj.RecRowID) {
				$("#btnAdd_four").linkbutton("enable");
				$("#btnEdit_four").linkbutton("disable");
				$("#btnDelete_four").linkbutton("disable");
			}
			dispalyEasyUILoad(); //����Ч��
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleTsAbRstFlag_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleTsAbRstFlag_onDbselect(rowData);
			}
		}
	});
	//�걾
	$HUI.combobox('#cboTestSpec',{
		url:$URL+'?ClassName=DHCHAI.DPS.LabSpecSrv&QueryName=QryLabSpecMap&ResultSetType=Array',
		valueField:'ID',
		textField:'SpecDesc',
		panelHeight:300,
		editable:true   		    
    })

	//������Ŀ
	$HUI.combobox('#cboTestCode', {
		url:$URL+'?ClassName=DHCHAI.DPS.LabTCMapSrv&QueryName=QryLabTCMapToCombo&ResultSetType=Array',
		valueField:'ID',
		textField:'FieldDesc',
		panelHeight:300,
		editable:true,
		filter: function(q, row){
            var opts = $(this).combobox('options');
            return row[opts.textField].indexOf(q) > -1;
        }		    
    })

	//������Ŀ
	$HUI.combobox('#cboTestCode1',{
		//url:$URL+'?ClassName=DHCHAI.DPS.LabTCMapSrv&QueryName=QryLabTCMapToCombo&ResultSetType=Array',
		valueField:'TCMID',
		textField:'TCMCode',
		panelHeight:300,
		editable:true,
		data: [],
    	onChange:function(e,value){
        	$HUI.combobox('#cboTestResult',{
				url: $URL,
				editable: true, 
				rowStyle:'combobox',      
				defaultFilter:4,     
				valueField: 'ID',
				textField: 'TestRes',
				onBeforeLoad: function (param) {    //�������������֮ǰ���������� false ��ȡ�����ض���
					param.ClassName = 'DHCHAI.DPS.LabTCMapSrv';
					param.QueryName = 'QryMapRstByTC';
					param.aMapID = e;
					param.ResultSetType = 'array';
				}  		    
		    })
    	}   		    
    })

	//������Ŀ
	$HUI.combobox('#cboTestCode2',{
		//url:$URL+'?ClassName=DHCHAI.DPS.LabTCMapSrv&QueryName=QryLabTCMapToCombo&ResultSetType=Array',
		valueField:'TCMID',
		textField:'TCMCode',
		panelHeight:300,
		editable:true,
    	onChange:function(e,value){
        	$HUI.combobox('#cboRstFlag', {
				url: $URL,
				editable: true, 
				rowStyle:'combobox',      
				defaultFilter:4,     
				valueField: 'ID',
				textField: 'AbFlag',
				onBeforeLoad: function (param) {    //�������������֮ǰ���������� false ��ȡ�����ض���
					param.ClassName = 'DHCHAI.DPS.LabTCMapSrv';
					param.QueryName = 'QryMapAbByTC';
					param.aMapID = e;
					param.ResultSetType = 'array';
				}  		    
			})
    	}   		    
    })

	//�������
	$HUI.combobox('#cboTestSet',{		
		url:$URL+'?ClassName=DHCHAI.DPS.LabTestSetSrv&QueryName=QryRuleTestSet&ResultSetType=Array&aActive = 1',
		valueField:'TestSet',
		textField:'TestSet',
		allowNull: true, 
		editable:false   
    })
    
	
	$('#ulTableNav').tabs({
    	onSelect:function(title,index){
        	var tab = $('#ulTableNav').tabs('getSelected');
    	}
	});
	$('#ulTableNav').tabs('select', 0);
	
	InitCRuleTestSrvWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}