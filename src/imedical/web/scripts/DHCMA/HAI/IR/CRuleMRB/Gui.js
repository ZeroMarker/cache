//页面Gui
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
		title: "多重耐药菌维护",
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
		columns:[[
			{field:'ID',title:'ID',width:70,hidden:true},
			{field:'BTCode',title:'代码',width:60,sortable:true},
			{field:'BTDesc',title:'名称',width:420,showTip:true}, 
			{field:'BTCatDesc',title:'多耐分类',width:360,showTip:true},
			{field:'BTIsActive',title:'是否<br>有效',width:70,align:'center',
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			},
			{field:'IsKeyCheck',title:'筛查<br>关键词',width:80,align:'center',
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			},
			{field:'IsResKeyCheck',title:'耐药机制<br>关键词',width:80,align:'center',
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			},
			{field:'IsRuleCheck',title:'启用<br>规则筛查',width:100,align:'center',
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			},
			{field:'IsAntiCheck',title:'筛查<br>抗生素',width:80,align:'center',
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			},
			{field:'IsIRstCheck',title:'中介是否<br>算耐药',width:80,align:'center',
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			},
			{field:'AnitCatCnt',title:'多耐<br>筛查种类',width:100,align:'center'},
			{field:'AnitCatCnt2',title:'泛耐<br>筛查种类',width:100,align:'center'},
			{field:'RuleNote',title:'说明',width:150,showTip:true}
			
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
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	//细菌
	obj.gridMRBBact = $HUI.datagrid("#gridMRBBact",{
		fit: true,
		//title: "细菌",
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
			{field:'BactDesc',title:'细菌',width:300,sortable:true}
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
			dispalyEasyUILoad(); //隐藏效果
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridMRBBact_onDbselect(rowData);
			}
		}
	});
	//抗生素
	obj.gridMRBAnti = $HUI.datagrid("#gridMRBAnti",{
		fit: true,
		//title: "抗生素",
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
			{field:'AntiCatDesc',title:'抗生素分类',width:240,sortable:true},
			{field:'AntiDesc',title:'抗生素',width:140,sortable:true}
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
			dispalyEasyUILoad(); //隐藏效果
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridMRBAnti_onDbselect(rowData);
			}
		}
	});
	//关键词
	obj.gridMRBKeys = $HUI.datagrid("#gridMRBKeys",{
		fit: true,
		//title: "关键词",
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
			{field:'KeyWord',title:'关键词',width:200,sortable:true}
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
				obj.gridMRBKeys_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridMRBKeys_onDbselect(rowData);
			}
		}
	});
	//多重耐药菌-隔离医嘱列表
	obj.gridIsolate = $HUI.datagrid("#gridIsolate",{
		fit: true,
		//title: "隔离医嘱",
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
			{field:'BTOrdDesc',title:'隔离医嘱',width:200,sortable:true}
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
				obj.gridIsolate_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridIsolate_onDbselect(rowData);
			}
		}
	});
	//多耐分类
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
	//细菌
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
	//抗生素分类
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
	//抗生素分类
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
				onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
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
					onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
						param.ClassName = 'DHCHAI.DPS.LabAntiSrv';
						param.QueryName = 'QryAntiByCate';
						param.aCateID = e;
						param.ResultSetType = 'array';
					}	
				});
		    }, 200);
	    }
	});*/
	
	//隔离医嘱
	var Alias = encodeURI("隔离");
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