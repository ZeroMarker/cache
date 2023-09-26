//页面gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
	obj.RecRowID="";
	obj.editIndex=undefined;	
	obj.DbClickIndex=-1; //双击保留索引，用于保存别名
    $.parser.parse(); // 解析整个页面
    
	obj.gridInfection =$HUI.datagrid("#gridInfection",{
		fit: true,
		title: "传染病字典维护",
		headerCls:'panel-header-gray',
		iconCls:'icon-write-order',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMed.EPDService.InfectionSrv",
			QueryName:"QryIFList"		
	    },
		columns:[[
			{field:'ICD',title:'ICD',width:100},
			{field:'MIFDisease',title:'疾病名称',width:200},
			{field:'MIFKind',title:'类别',width:200},
			{field:'link',title:'别名维护',width:80,align:'center',
			  	formatter: function(value,row,index){
				  	return " <a href='#' style='white-space:normal; color:blue' onclick='objScreen.OpenAlias(\"" + row.RowID + "\");'>别名</a>";
			  	}
			},	
			{field:'MIFRank',title:'等级',width:200},
			{field:'MIFAppendix',title:'传染病附卡',width:250},
			{field:'MIFMulti',title:'多次患病',width:80,align:'center'},
			{field:'MIFTimeLimit',title:'上报时限',width:80,align:'center'},
			{field:'MIFIsActive',title:'是否有效',width:80,align:'center'},
			{field:'MIFResume',title:'备注',width:100}
		]],
		onDblClickRow:function(rowIndex,rowData){
			obj.RecRowID=rowData.RowID;
			obj.OpenAlias(rowData.RowID);
		},
		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1) {
				obj.gridInfType_onSelect(rowData);
			}
		}
	});
		
	obj.gridAlias =$HUI.datagrid("#gridAlias",{
		rownumbers: true, //如果为true, 则显示一个行号列		
		singleSelect: true,	
		columns:[[
			{field:'Alias',title:'别名',width:320,editor:'text'},
			{field:'IsKeyWord',title:'类型',width:200,               //弹出框中类型字段下拉框
				formatter:function(value,row) {
					return row.IsKeyWordDesc;
				},
				editor:{
					type:'combobox',
					options:{
						url: $URL,
						editable: true,
						mode: 'remote',
						valueField: 'Code',
						required:true,
						textField:'Description',
						onBeforeLoad: function (param) {
							param.ClassName = 'DHCMed.SSService.DictionarySrv';
							param.QueryName = 'QryDictionary';
							param.aType = 'EpdInfAliasType';
							param.ResultSetType = 'array';
						}
					}
				}
			},
			{field:'Code',title:'Code',hidden:true}				
		]],
		onDblClickRow:function(rindex,rowData1){
			obj.editHandler(rindex);
		}
	});
	//传染病类别下拉框
	obj.cboKind = $HUI.combobox('#cboKind', {              
		url: $URL,
		editable: true,
		valueField: 'Code',
		textField: 'Description',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMed.SSService.DictionarySrv';
			param.QueryName = 'QryDictionary';
			param.aType = 'EpdemicType';
			param.aIsActive = 1;
			param.ResultSetType = 'array';
		}
	});
	//传染病级别下拉框
	obj.cboLevel = Common_ComboDicCode('cboLevel','EpidemicRank',"1");
	
	//传染病附卡下拉框
	obj.cboAppendix = $HUI.combobox('#cboAppendix', {       
		url: $URL,
		editable: true,
		valueField: 'ID',
		textField: 'Description',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMed.EPDService.AppendixCardSrv';
			param.QueryName = 'QryAppendixCard';
			param.ResultSetType = 'array';
		}
	});

	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);	
	return obj;
}