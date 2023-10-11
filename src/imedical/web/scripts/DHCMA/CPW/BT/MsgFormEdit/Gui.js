//页面Gui
var obj = new Object();
function InitHISUIWin(){
	obj.PreventUnMD=0;
	obj.PreventUnOP=0;
	obj.type="Y";
	
	//表单信息
	obj.jsonForm=$cm({
		ClassName:"DHCMA.CPW.BT.PathForm",
		MethodName:"GetObjById",
		aId:PathFormID
	},false);
	//路径ID
	obj.FormPathID=obj.jsonForm.FormPathDr;
	
	
	//当前审核角色
    obj.RoleName = $m({
		ClassName:"DHCMA.CPW.BTS.ApplyExamRecDtlSrv",
		MethodName:"GetRoleName",
		aRecDtlID:RecDtlID
	},false);
		
	// 路径类型
	obj.cbokind = $HUI.combobox('#cboTypeDr', {              
		url: $URL,
		editable: true,
		defaultFilter:"4",
		//multiple:true,  //多选
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
	
	//病种路径
	obj.cboPath = $HUI.combobox('#cboEntityDr', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
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
	
	
	//病种付费
	obj.cboPay = $HUI.combobox('#cboPCEntityDr', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
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
	  			$.messager.alert("提示", "未启用单病种付费提醒功能，请开启该模块配置后再维护此数据！", 'info');
	  			$("#cboPCEntityDr").combobox({disabled:true});
	  			return false;
	  		}	
		}
	});
	
	//病种质量
	obj.cboQuality = $HUI.combobox('#cboQCEntityDr', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
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
	
	//就诊类型
	obj.cboAdmType = $HUI.combobox('#cboAdmType', {
		valueField:'id',
		textField:'text',
		selectOnNavigation:true,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'O',text:'门诊'},
			{id:'I',text:'住院'}
		]
	})
	
	//准入信息
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
			
			//面板是否展开处理
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
			{field:'BTTypeDr',title:'<span title=\"诊断类型保持一致\" class=\"hisui-tooltip\">类型</span>',sortable:true,width:100
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
			{field:'BTICD10',title:'<span title=\"下诊断时触发入径;输入准确的诊断ICD;若有多个以,分隔\" class=\"hisui-tooltip\">准入诊断</span>',sortable:true,width:140,editor:'text'},
			{field:'BTICDKeys',title:'<span title=\"下诊断时诊断名包含关键词触发入径\" class=\"hisui-tooltip\">诊断关键词</span>',sortable:true,width:150,editor:'text'},			
			{field:'BTOperICD',title:'<span title=\"输入准确的手术ICD;若有多个以,分隔\" class=\"hisui-tooltip\">准入手术</span>',sortable:true,width:100,editor:'text'},
			{field:'BTOperKeys',title:'<span title=\"手术名包含关键词触发入径\" class=\"hisui-tooltip\">手术关键词</span>',sortable:true,width:100,editor:'text'},
			{field:'BTIsICDAcc',title:'中西诊断组合',width:100,editor:{type:'switchbox',options:{onClass:'primary',offClass:'gray',onText:'是',offText:'否'}}},
			{field:'BTIsOperAcc',title:'诊断手术组合',width:100,editor:{type:'switchbox',options:{onClass:'primary',offClass:'gray',onText:'是',offText:'否'}}},
			{field:'BTIsActive',title:'是否有效',width:70,editor:{type:'switchbox',options:{onClass:'primary',offClass:'gray',onText:'是',offText:'否'}}}
		]]
	});
	
	//排除诊断ICD维护
	obj.gridSlectMDiagOrds = $HUI.datagrid("#gridSlectMDiagOrds",{
		fit:true,
		singleSelect: false,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		fitColumns:true,
		striped:true,
		rownumbers:true, 
		checkOnSelect:true, 
		selectOnCheck:true, 
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		pageSize: 30,
		pageList : [10,30,50],
		loadMsg:'数据加载中...',
	    bodyCls:'no-border',
	    idField :'BTID',
		columns:[[	
			{field:'checked',checkbox:'true',align:'center',readonly:true},
			{field:'ICD',title:'ICD代码',width:150,align:'center'},
			{field:'Desc',title:'诊断名称',width:250,align:'center'}
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
            $.each(rowData,function(idx,val){//遍历JSON
            	if(val.checked==1){
                	$('#gridSlectMDiagOrds').datagrid("selectRow", idx);//如果数据行为已选中则选中改行
              	}else{
                	$('#gridSlectMDiagOrds').datagrid("unselectRow", idx); 
             	}
            });
		}
	});
	
	//排除手术ICD维护
	obj.gridSlectOperOrds = $HUI.datagrid("#gridSlectOperOrds",{
		fit:true,
		singleSelect: false,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		fitColumns:true,
		rownumbers:true, 
		checkOnSelect:true, 
		selectOnCheck:true, 
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		pageSize: 30,
		pageList : [10,30,50],
		loadMsg:'数据加载中...',
	    bodyCls:'no-border',
	    idField :'BTID',
		columns:[[	
			{field:'checked',checkbox:'true',align:'center'},
			{field:'ICD',title:'ICD代码',width:150,align:'center'},
			{field:'Desc',title:'手术名称',width:250,align:'center'}
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
            $.each(rowData,function(idx,val){//遍历JSON
            	if(val.checked==1){
                	$('#gridSlectOperOrds').datagrid("selectRow", idx);//如果数据行为已选中则选中改行
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
