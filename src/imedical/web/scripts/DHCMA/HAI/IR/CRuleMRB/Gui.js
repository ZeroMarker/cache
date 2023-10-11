//ҳ��Gui
function InitDictionaryWin(){
	var obj = new Object();
	var IsCheckFlag=false;
	obj.RecRowID= "";
	obj.RecRowID1="";
	obj.RecRowID2="";
	obj.RecRowID3="";
	obj.RecRowID4="";
	
	obj.gridCRuleMRB = $HUI.datagrid("#gridCRuleMRB",{
		fit: true,
		title: "������ҩ��ά��",
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
			{field:'ID',title:'ID',width:70,hidden:true},
			{field:'BTCode',title:'����',width:60,sortable:true},
			{field:'BTDesc',title:'����',width:420,showTip:true}, 
			{field:'BTCatDesc',title:'���ͷ���',width:360,showTip:true},
			{field:'BTIsActive',title:'�Ƿ�<br>��Ч',width:70,align:'center',
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			},
			{field:'IsKeyCheck',title:'ɸ��<br>�ؼ���',width:80,align:'center',
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			},
			{field:'IsResKeyCheck',title:'��ҩ����<br>�ؼ���',width:80,align:'center',
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			},
			{field:'IsRuleCheck',title:'����<br>����ɸ��',width:100,align:'center',
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			},
			{field:'IsAntiCheck',title:'ɸ��<br>������',width:80,align:'center',
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			},
			{field:'IsIRstCheck',title:'�н��Ƿ�<br>����ҩ',width:80,align:'center',
				formatter: function(value,row,index){
					return (value == '1' ? '��' : '��');
				}
			},
			{field:'AnitCatCnt',title:'����<br>ɸ������',width:100,align:'center'},
			{field:'AnitCatCnt2',title:'����<br>ɸ������',width:100,align:'center'},
			{field:'RuleNote',title:'˵��',width:150,showTip:true}
			
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleMRB_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleMRB_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	//ϸ��
	obj.gridMRBBact = $HUI.datagrid("#gridMRBBact",{
		fit: true,
		//title: "ϸ��",
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
			{field:'BactDesc',title:'ϸ��',width:300,sortable:true}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridMRBBact_onSelect();
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
				obj.gridMRBBact_onDbselect(rowData);
			}
		}
	});
	//������
	obj.gridMRBAnti = $HUI.datagrid("#gridMRBAnti",{
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
			{field:'AntiCatDesc',title:'�����ط���',width:240,sortable:true},
			{field:'AntiDesc',title:'������',width:140,sortable:true}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridMRBAnti_onSelect();
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
				obj.gridMRBAnti_onDbselect(rowData);
			}
		}
	});
	//�ؼ���
	obj.gridMRBKeys = $HUI.datagrid("#gridMRBKeys",{
		fit: true,
		//title: "�ؼ���",
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
			{field:'KeyWord',title:'�ؼ���',width:200,sortable:true}
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
				obj.gridMRBKeys_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridMRBKeys_onDbselect(rowData);
			}
		}
	});
	//������ҩ��-����ҽ���б�
	obj.gridIsolate = $HUI.datagrid("#gridIsolate",{
		fit: true,
		//title: "����ҽ��",
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
			{field:'BTOrdDesc',title:'����ҽ��',width:200,sortable:true}
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
				obj.gridIsolate_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridIsolate_onDbselect(rowData);
			}
		}
	});
	//���ͷ���
	var TypeCode = "MRBCategory";
	$HUI.combobox('#cboMRBCat', {
		url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode='+TypeCode,
		valueField:'ID',
		textField:'DicDesc',
		panelHeight:300,
		editable:true   		    
    })
	/*obj.cboMRBCat = $HUI.combobox("#cboMRBCat", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'DicDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+TypeCode;
		   	$("#cboMRBCat").combobox('reload',url);
		}
	});*/
	//ϸ��
	$HUI.combobox('#cboBact',{
		url:$URL+'?ClassName=DHCHAI.DPS.LabBactSrv&QueryName=QryLabBacteria&ResultSetType=Array',
		valueField:'ID',
		textField:'BacDesc',
		panelHeight:300,
		editable:true   		    
    })
	/*obj.cboBact = $HUI.combobox("#cboBact", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'BacDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.DPS.LabBactSrv&QueryName=QryLabBacteria&ResultSetType=array";
		   	$("#cboBact").combobox('reload',url);
		}
	});*/
	//�����ط���
	$HUI.combobox('#cboLabAntiCat', {
		url:$URL+'?ClassName=DHCHAI.DPS.LabAntiSrv&QueryName=QryLabAntiCatSrv&ResultSetType=Array',
		valueField:'ID',
		textField:'ACDesc',
		panelHeight:300,
		editable:true   		    
    })
	/*obj.cboLabAntiCat = $HUI.combobox("#cboLabAntiCat", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'ACDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.DPS.LabAntiSrv&QueryName=QryLabAntiCatSrv&ResultSetType=array";
		   	$("#cboLabAntiCat").combobox('reload',url);
		}
	});*/
	//�����ط���
	$HUI.combobox('#cboLabAntiCat',{
		url:$URL+'?ClassName=DHCHAI.DPS.LabAntiSrv&QueryName=QryLabAntiCatSrv&ResultSetType=Array',
		valueField:'ID',
		textField:'ACDesc',
		panelHeight:300,
		editable:true,
    	onChange:function(e,value){
        	$HUI.combobox('#cboLabAnti',{
				url: $URL,
				editable: true, 
				rowStyle:'combobox',      
				defaultFilter:4,     
				valueField: 'ID',
				textField: 'AntDesc',
				onBeforeLoad: function (param) {    //�������������֮ǰ���������� false ��ȡ�����ض���
					param.ClassName = 'DHCHAI.DPS.LabAntiSrv';
					param.QueryName = 'QryAntiByCate';
					param.aCateID = e;
					param.ResultSetType = 'array';
				}  		    
		    })		    
    	}   		    
    })
	/*obj.cboLabAntiCat = $HUI.combobox("#cboLabAntiCat", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'ACDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.DPS.LabAntiSrv&QueryName=QryLabAntiCatSrv&ResultSetType=array";
		   	$("#cboLabAntiCat").combobox('reload',url);
		},
        onChange:function(e,value){
	        setTimeout(function(){
		        obj.cboLabAnti = $HUI.combobox("#cboLabAnti", {
			        url: $URL,
					editable: true, 
					rowStyle:'combobox',      
					defaultFilter:4,     
					valueField: 'ID',
					textField: 'AntDesc',
					onBeforeLoad: function (param) {    //�������������֮ǰ���������� false ��ȡ�����ض���
						param.ClassName = 'DHCHAI.DPS.LabAntiSrv';
						param.QueryName = 'QryAntiByCate';
						param.aCateID = e;
						param.ResultSetType = 'array';
					}	
				});
		    }, 200);
	    }
	});*/
	
	//����ҽ��
	var Alias = encodeURI("����");
	$HUI.combobox('#cboOEOrd', {
		url:$URL+'?ClassName=DHCHAI.DPS.OEItmMastMapSrv&QueryName=QryOEItmMastMap&ResultSetType=Array&aFlg='+"1"+'&aAlias='+Alias,
		valueField:'ID',
		textField:'BTOrdDesc',
		panelHeight:300,
		editable:true   		    
    })
	obj.cboOEOrd = $HUI.combobox("#cboOEOrd", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'BTOrdDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.DPS.OEItmMastMapSrv&QueryName=QryOEItmMastMap&ResultSetType=array&aFlg="+"1"+"&aAlias="+Alias;
		   	$("#cboOEOrd").combobox('reload',url);
		}
	});
	
	InitDictionaryWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}