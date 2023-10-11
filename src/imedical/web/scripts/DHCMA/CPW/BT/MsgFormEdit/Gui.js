//ҳ��Gui
var obj = new Object();
function InitHISUIWin(){
	obj.PreventUnMD=0;
	obj.PreventUnOP=0;
	obj.type="Y";
	
	//����Ϣ
	obj.jsonForm=$cm({
		ClassName:"DHCMA.CPW.BT.PathForm",
		MethodName:"GetObjById",
		aId:PathFormID
	},false);
	//·��ID
	obj.FormPathID=obj.jsonForm.FormPathDr;
	
	
	//��ǰ��˽�ɫ
    obj.RoleName = $m({
		ClassName:"DHCMA.CPW.BTS.ApplyExamRecDtlSrv",
		MethodName:"GetRoleName",
		aRecDtlID:RecDtlID
	},false);
		
	// ·������
	obj.cbokind = $HUI.combobox('#cboTypeDr', {              
		url: $URL,
		editable: true,
		defaultFilter:"4",
		//multiple:true,  //��ѡ
		//mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		selectOnNavigation:false,
		enterNullValueClear:false,
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathTypeSrv';
			param.QueryName = 'QryPathType';
			param.ResultSetType = 'array'
		}
	});
	
	//����·��
	obj.cboPath = $HUI.combobox('#cboEntityDr', {              
		url: $URL,
		editable: true,
		//multiple:true,  //��ѡ
		//mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		defaultFilter:"4",
		selectOnNavigation:false,
		enterNullValueClear:false,
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathEntitySrv';
			param.QueryName = 'QryPathEntity';
			param.aIsActive = '1';
			param.ResultSetType = 'array'
		}
	});
	
	
	//���ָ���
	obj.cboPay = $HUI.combobox('#cboPCEntityDr', {              
		url: $URL,
		editable: true,
		//multiple:true,  //��ѡ
		//mode: 'remote',
		valueField: 'RowID',
		textField: 'Desc',
		defaultFilter:"4",
		selectOnNavigation:false,
		enterNullValueClear:false,
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.SDS.PCEntitySrv';
			param.QueryName = 'QryPCEntity';
			param.aIsActive = '1';
			param.ResultSetType = 'array'
		},
		onSelect:function(rec){
			var ret = $m({
				ClassName:"DHCMA.Util.BT.Config",
				MethodName:"GetValueByCode",
				aCode:"SDIsOpenPCModBaseCPW"
			},false);
	  		if(parseInt(ret)!=1) {
	  			$.messager.alert("��ʾ", "δ���õ����ָ������ѹ��ܣ��뿪����ģ�����ú���ά�������ݣ�", 'info');
	  			$("#cboPCEntityDr").combobox({disabled:true});
	  			return false;
	  		}	
		}
	});
	
	//��������
	obj.cboQuality = $HUI.combobox('#cboQCEntityDr', {              
		url: $URL,
		editable: true,
		//multiple:true,  //��ѡ
		//mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		defaultFilter:"4",
		selectOnNavigation:false,
		enterNullValueClear:false,
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.SDS.QCEntitySrv';
			param.QueryName = 'QryQCEntity';
			param.ResultSetType = 'array'
		}
	});
	
	//��������
	obj.cboAdmType = $HUI.combobox('#cboAdmType', {
		valueField:'id',
		textField:'text',
		selectOnNavigation:true,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'O',text:'����'},
			{id:'I',text:'סԺ'}
		]
	})
	
	//׼����Ϣ
	obj.gridPathAdmit = $HUI.datagrid("#gridPathAdmit",{
		url:$URL,
		singleSelect:true,
		toolbar:'#tbMrg',
		fit:true,
		queryParams:{
			ClassName:"DHCMA.CPW.BTS.PathAdmitSrv",
			QueryName:"QryPathAdmit",
			aBTPathDr:obj.FormPathID
		},
		onSelect:function(rowIndex,rowData){
			if (rowIndex<0) return;
			if (obj.gridPathAdmitEditIndex>-1){
				if (rowIndex != obj.gridPathAdmitEditIndex){
					$('#gridPathAdmit').datagrid("cancelEdit", obj.gridPathAdmitEditIndex);
				}
			}
			obj.gridPathAdmitRecRowID  = rowData["ID"];
			
			//����Ƿ�չ������
			var e_width=$("#cc").layout("panel", "east")[0].clientWidth;
			if (e_width==0) $('#cc').layout('expand','east');
			$("#btnMDFin").trigger('click');
			$("#btnOpFin").trigger('click');
		},
		onDblClickRow: function(rowIndex,rowData){
			if (rowIndex<0) return;
			if (obj.gridPathAdmitEditIndex>-1){
				if (rowIndex != obj.gridPathAdmitEditIndex){
					$('#gridPathAdmit').datagrid("cancelEdit", obj.gridPathAdmitEditIndex);
				}
			}
			$('#gridPathAdmit').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
		},
		onBeforeEdit: function(rowIndex, rowData, changes) {
			obj.gridPathAdmitEditIndex = rowIndex;
			obj.gridPathAdmitRecRowID  = rowData["ID"];
		},
		onAfterEdit: function(rowIndex, rowData, changes) {
			obj.gridPathAdmitEditIndex = -1;
			obj.gridPathAdmitRecRowID  = "";
		},
		onCancelEdit: function(rowIndex, rowData, changes) {
			obj.gridPathAdmitEditIndex = -1;
			obj.gridPathAdmitRecRowID  = "";
		},
		onLoadSuccess: function() {
			obj.gridPathAdmitEditIndex = -1;
			obj.gridPathAdmitRecRowID  = "";
			$('#gridPathAdmit').datagrid('clearSelections');
		},
		columns:[[
			{field:'BTTypeDr',title:'<span title=\"������ͱ���һ��\" class=\"hisui-tooltip\">����</span>',sortable:true,width:100
				,formatter:function(value,row){
					return row.BTTypeDrDesc;
				}
				,editor:{
					type:'combobox',
					options:{
						url:$URL+"?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&aTypeCode=CPWAdmDiagType&aIsActive=1&ResultSetType=array",
						valueField:'BTID',
						textField:'BTDesc',
						required:true
					}
				}
			},	
			{field:'BTICD10',title:'<span title=\"�����ʱ�����뾶;����׼ȷ�����ICD;���ж����,�ָ�\" class=\"hisui-tooltip\">׼�����</span>',sortable:true,width:140,editor:'text'},
			{field:'BTICDKeys',title:'<span title=\"�����ʱ����������ؼ��ʴ����뾶\" class=\"hisui-tooltip\">��Ϲؼ���</span>',sortable:true,width:150,editor:'text'},			
			{field:'BTOperICD',title:'<span title=\"����׼ȷ������ICD;���ж����,�ָ�\" class=\"hisui-tooltip\">׼������</span>',sortable:true,width:100,editor:'text'},
			{field:'BTOperKeys',title:'<span title=\"�����������ؼ��ʴ����뾶\" class=\"hisui-tooltip\">�����ؼ���</span>',sortable:true,width:100,editor:'text'},
			{field:'BTIsICDAcc',title:'����������',width:100,editor:{type:'switchbox',options:{onClass:'primary',offClass:'gray',onText:'��',offText:'��'}}},
			{field:'BTIsOperAcc',title:'����������',width:100,editor:{type:'switchbox',options:{onClass:'primary',offClass:'gray',onText:'��',offText:'��'}}},
			{field:'BTIsActive',title:'�Ƿ���Ч',width:70,editor:{type:'switchbox',options:{onClass:'primary',offClass:'gray',onText:'��',offText:'��'}}}
		]]
	});
	
	//�ų����ICDά��
	obj.gridSlectMDiagOrds = $HUI.datagrid("#gridSlectMDiagOrds",{
		fit:true,
		singleSelect: false,
		//�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		autoRowHeight: false,
		fitColumns:true,
		striped:true,
		rownumbers:true, 
		checkOnSelect:true, 
		selectOnCheck:true, 
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		pageSize: 30,
		pageList : [10,30,50],
		loadMsg:'���ݼ�����...',
	    bodyCls:'no-border',
	    idField :'BTID',
		columns:[[	
			{field:'checked',checkbox:'true',align:'center',readonly:true},
			{field:'ICD',title:'ICD����',width:150,align:'center'},
			{field:'Desc',title:'�������',width:250,align:'center'}
		]],
		onCheck:function(rindex,rowData){
			if (rowData.checked!=1) obj.btnMDiagMatch_click();
		},
		onCheckAll:function(rindex,rowData){
			obj.btnMDiagMatch_click();
		},
		onUncheck:function(rindex,rowData){
			if (rowData.checked==1) 
			{
				obj.btnMDiagMatch_click();
			}
		},
		onUncheckAll:function(rindex,rowData){
			if (obj.PreventUnMD==0){
				obj.btnMDiagMatch_click();
			}else{
				obj.PreventUnMD=0;
			}
		},
		onLoadSuccess:function(data){
			var rowData = data.rows;
            $.each(rowData,function(idx,val){//����JSON
            	if(val.checked==1){
                	$('#gridSlectMDiagOrds').datagrid("selectRow", idx);//���������Ϊ��ѡ����ѡ�и���
              	}else{
                	$('#gridSlectMDiagOrds').datagrid("unselectRow", idx); 
             	}
            });
		}
	});
	
	//�ų�����ICDά��
	obj.gridSlectOperOrds = $HUI.datagrid("#gridSlectOperOrds",{
		fit:true,
		singleSelect: false,
		//�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		autoRowHeight: false,
		fitColumns:true,
		rownumbers:true, 
		checkOnSelect:true, 
		selectOnCheck:true, 
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		pageSize: 30,
		pageList : [10,30,50],
		loadMsg:'���ݼ�����...',
	    bodyCls:'no-border',
	    idField :'BTID',
		columns:[[	
			{field:'checked',checkbox:'true',align:'center'},
			{field:'ICD',title:'ICD����',width:150,align:'center'},
			{field:'Desc',title:'��������',width:250,align:'center'}
		]],
		onCheck:function(rindex,rowData){
			if (rowData.checked!=1) obj.btnOperMatch_click();
		},
		onCheckAll:function(rindex,rowData){
			obj.btnOperMatch_click();
		},
		onUncheck:function(rindex,rowData){
			if (rowData.checked==1) 
			{
				obj.btnOperMatch_click();
			}
		},
		onUncheckAll:function(rindex,rowData){
			if (obj.PreventUnOP==0){
				obj.btnOperMatch_click();
			}else{
				obj.PreventUnOP=0;
			}
		},
		onLoadSuccess:function(data){
			var rowData = data.rows;
            $.each(rowData,function(idx,val){//����JSON
            	if(val.checked==1){
                	$('#gridSlectOperOrds').datagrid("selectRow", idx);//���������Ϊ��ѡ����ѡ�и���
                }else{
	            	$('#gridSlectOperOrds').datagrid("unselectRow", idx); 
	            }
            });
		}
	});

	$.parser.parse();
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	
	
	return obj;
}
