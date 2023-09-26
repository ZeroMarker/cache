//页面Gui
function InitHISUIWin(){
	var obj = new Object();
	
obj.btnAdd=$HUI.linkbutton("#addIcon",{
		iconCls:'icon-add',
		plain:true,
		text:'添加'
	});
	obj.btnEdit=$HUI.linkbutton("#editIcon",{
		iconCls:'icon-save',
		plain:true,
		text:'保存'
	});
	obj.btnDel=$HUI.linkbutton("#delIcon",{
		iconCls:'icon-close',
		plain:true,
		text:'删除'
	});
	
	obj.admitList = $HUI.datagrid("#admitList",{
		url:$URL,
		queryParams:{
			ClassName:"DHCMA.CPW.BTS.PathAdmitSrv",
			QueryName:"QryPathAdmit",
			aBTPathDr:""
		},
		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1){
				var p = obj.admitList.getPanel();
				p.find("#editIcon").linkbutton("enable",false);
				p.find("#delIcon").linkbutton("enable",false);
			}
		},
		onClickRow: function(rowIndex,rowData){			
			if (obj.editIndex!=rowIndex) {
				if (obj.endEditing()){
					$('#admitList').datagrid('selectRow', rowIndex)
							.datagrid('beginEdit', rowIndex);
					obj.editIndex = rowIndex;
					obj.modifyBeforeRow = $.extend({},$('#admitList').datagrid('getRows')[obj.editIndex]);
				} else {					
					$('#admitList').datagrid('selectRow', obj.editIndex);
					obj.editIndex = null;
				}
			}	
		},
		columns:[[			
			{field:'BTTypeDr',title:'类型',sortable:true,width:100
			 ,formatter:function(value,row){
					return row.BTTypeDrDesc;
			  }
			 ,editor:{
					type:'combobox',
					options:{						
						url:$URL+"?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&aTypeCode=CPWAdmDiagType&ResultSetType=array",
						valueField:'BTID',
						textField:'BTDesc',
						required:true
					}
			}},
			{field:'BTICD10',title:'准入诊断',sortable:true,width:150,editor:'text'},
			{field:'BTICDKeys',title:'诊断关键词',sortable:true,width:150,editor:'text'},			
			{field:'BTOperICD',title:'准入手术',sortable:true,width:100
			 ,editor:'text'},
			{field:'BTOperKeys',title:'手术关键词',sortable:true,width:100
			 ,editor:'text'},
			{field:'BTIsICDAcc',title:'中西诊断组合',width:100,
			editor:{type:'switchbox',options:{onClass:'primary',offClass:'gray',onText:'是',offText:'否'}}}
			,
			{field:'BTIsOperAcc',title:'诊断手术组合',width:100,
			editor:{type:'switchbox',options:{onClass:'primary',offClass:'gray',onText:'是',offText:'否'}}}
			,
			{field:'BTIsActive',title:'是否有效',width:80,
			editor:{type:'switchbox',options:{onClass:'primary',offClass:'gray',onText:'是',offText:'否'}}}
		]],		
		height:240,
		singleSelect:true,
		toolbar:'#tb'
	});	
		
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
