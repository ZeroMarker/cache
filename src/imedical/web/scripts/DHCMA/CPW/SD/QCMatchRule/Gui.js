//页面Gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = new Object();
	obj.QCEntityID=""
    $.parser.parse(); // 解析整个页面 
    $('#ItemOptions').tree({
		url:$URL+"?ClassName=DHCMA.CPW.SDS.QCEntityItemSrv&QueryName=QryQCTree&ResultSetType=array"	
		,onLoadSuccess:function(node,data)
		{
			//回调
		},
		onExpand:function(node)
			{		
			},
		lines:true
	})
 	//监听事件
	$('#ItemOptions').tree({
			onClick:function(node){	
				obj.gridQCMatchRule.load({
					ClassName:"DHCMA.CPW.SDS.QCEntityMatchRuleSrv",
					QueryName:"QryEntityMatchRule",
					aParRef:node.id		
					});
				obj.QCEntityID=node.id;
				obj.ClearForms();
				$("#btnSave").linkbutton('enable');
				$("#btnDelete").linkbutton('disable');
			}
			
	})
	obj.BTExpress=$HUI.combobox("#BTExpress",{
				url:$URL+'?ClassName=DHCMA.CPW.SDS.QCExpressSrv&QueryName=QryQCExpress&ResultSetType=Array&aExpType=QCRule',
				valueField:'BTID',
				textField:'BTDesc'
				})	
	obj.BTRuleType = $HUI.combobox("#BTRuleType",{
		valueField:'id',
		textField:'text',
		selectOnNavigation:true,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'1',text:'准入'},
			{id:'2',text:'排除'}
		]
	});

	obj.gridQCMatchRule = $HUI.datagrid("#gridQCMatchRule",{
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		fitColumns:true,
		striped:true,
		nowrap:false,
		rownumbers:true, 
		loadMsg:'数据加载中...',
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDS.QCEntityMatchRuleSrv",
			QueryName:"QryEntityMatchRule",
			aParRef:""
	    },
		columns:[[	
			{field:'RuleTypeDesc',title:'项目类型',width:'100',sortable:true},
			{field:'IsActive',title:'是否<br>有效',width:'100',sortable:true},
			{field:'RuleDesc',title:'描述',width:'250',sortable:true}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {		
				obj.gridQCMatchRule_onSelect(rowData);
			}
		},
		onDblClickRow:function(rowIndex,rowData){	
		},
		onLoadSuccess:function(data){
		}
	});

	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}

