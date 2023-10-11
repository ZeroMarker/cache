//页面Gui
function InitCRuleTestSrvWin(){
	var obj = new Object();
	var IsCheckFlag=false;
	obj.RecRowID= "";
	obj.RecRowID1= "";
	obj.RecRowID2= "";
	obj.RecRowID3= "";
	obj.RecRowID4= "";
	//页签切换参数值
	obj.TabArgs = new Object();
	obj.TabArgs.ContentID = '';	
	
	obj.gridCRuleTsAb = $HUI.datagrid("#gridCRuleTsAb",{
		fit: true,
		title: "常规检验项目",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100,200],
		loadFilter:pagerFilter,
		columns:[[
			{field:'ID',title:'ID',width:80},
			{field:'TestSet',title:'常规检验',width:420,sortable:true},
			{field:'TestCode',title:'检验项目',width:420}, 
			{field:'IsActive',title:'是否<br>有效',width:100,
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			},
			{field:'TSPFlag',title:'比较<br>标本',width:100,
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			},
			{field:'TRFFlag',title:'比较<br>异常',width:100,
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			},
			{field:'TRFlag',title:'比较<br>结果',width:100,
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			},
			{field:'TRVMaxFlag',title:'比较<br>上限',width:100,
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			},
			{field:'MaxValM',title:'上限值(男)',width:180},
			{field:'MaxValF',title:'上限值(女)',width:180},
			{field:'TRVMinFlag',title:'比较<br>下限',width:100,
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			},
			{field:'MinValM',title:'下限值(男)',width:180},
			{field:'MinValF',title:'下限值(女)',width:180}
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
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	//送检标本
	obj.gridCRuleTSSpec = $HUI.datagrid("#gridCRuleTSSpec",{
		fit: true,
		//title: "送检标本",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100,200],
		columns:[[
			{field:'TSSpec',title:'标本名称',width:200,sortable:true},
			{field:'MapSpec',title:'标本对照',width:150,sortable:true}
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
			dispalyEasyUILoad(); //隐藏效果
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleTSSpec_onDbselect(rowData);
			}
		}
	});
	//检验项目
	obj.gridCRuleTSCode = $HUI.datagrid("#gridCRuleTSCode",{
		fit: true,
		//title: "检验项目",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100,200],
		columns:[[
			{field:'TCMCode',title:'检验项目',width:100,sortable:true},
			{field:'TCMDesc',title:'项目名称',width:240,sortable:true},
			{field:'MapRstFormat',title:'结果类型',width:100,sortable:true}
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
			dispalyEasyUILoad(); //隐藏效果
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleTSCode_onDbselect(rowData);
			}
		}
	});
	//检验结果
	obj.gridCRuleTSResult = $HUI.datagrid("#gridCRuleTSResult",{
		fit: true,
		//title: "检验结果",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100,200],
		columns:[[
			{field:'TestCode',title:'检验项目',width:240,sortable:true},
			{field:'TestResult',title:'检验结果',width:100,sortable:true},
			{field:'MapText',title:'标准值',width:100,sortable:true}
		]],
		onLoadSuccess:function(data){
			if (obj.RecRowID) {
				$("#btnAdd_three").linkbutton("enable");
				$("#btnEdit_three").linkbutton("disable");
				$("#btnDelete_three").linkbutton("disable");
			}
			dispalyEasyUILoad(); //隐藏效果
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
	//异常标志
	obj.gridCRuleTsAbRstFlag = $HUI.datagrid("#gridCRuleTsAbRstFlag",{
		fit: true,
		//title: "异常标志",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100,200],
		columns:[[
			{field:'TestCode',title:'检验项目',width:240,sortable:true},
			{field:'TSRstFlag',title:'异常标志',width:100,sortable:true},
			{field:'MapText',title:'标准值',width:100,sortable:true}
		]],
		onLoadSuccess:function(data){
			if (obj.RecRowID) {
				$("#btnAdd_four").linkbutton("enable");
				$("#btnEdit_four").linkbutton("disable");
				$("#btnDelete_four").linkbutton("disable");
			}
			dispalyEasyUILoad(); //隐藏效果
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
	//标本
	$HUI.combobox('#cboTestSpec',{
		url:$URL+'?ClassName=DHCHAI.DPS.LabSpecSrv&QueryName=QryLabSpecMap&ResultSetType=Array',
		valueField:'ID',
		textField:'SpecDesc',
		panelHeight:300,
		editable:true   		    
    })

	//检验项目
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

	//检验项目
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
				onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
					param.ClassName = 'DHCHAI.DPS.LabTCMapSrv';
					param.QueryName = 'QryMapRstByTC';
					param.aMapID = e;
					param.ResultSetType = 'array';
				}  		    
		    })
    	}   		    
    })

	//检验项目
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
				onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
					param.ClassName = 'DHCHAI.DPS.LabTCMapSrv';
					param.QueryName = 'QryMapAbByTC';
					param.aMapID = e;
					param.ResultSetType = 'array';
				}  		    
			})
    	}   		    
    })

	//常规检验
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