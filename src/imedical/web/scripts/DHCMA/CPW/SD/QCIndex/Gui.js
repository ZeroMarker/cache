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
				obj.gridQCIndex.load({
					ClassName:"DHCMA.CPW.SDS.QCIndexSrv",
					QueryName:"QryEntityIndex",
					aParRef:node.id		
					});
				obj.QCEntityID=node.id;
				obj.ClearForms();
				$("#btnSave").linkbutton("enable");
			}
			
	})
	obj.gridQCIndex = $HUI.datagrid("#gridQCIndex",{
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		//fitColumns:true,
		striped:true,
		nowrap:false,
		rownumbers:true, 
		loadMsg:'数据加载中...',
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDS.QCIndexSrv",
			QueryName:"QryEntityIndex",
			aParRef:""
	    },
		columns:[[	
			{field:'BTCode',title:'指标代码',width:'80',sortable:true},
			{field:'BTDesc',title:'指标描述',width:'200',sortable:true},
			{field:'IndexCat',title:'指标类别',width:'100',sortable:true},
			{field:'RaqName',title:'报表名称',width:'300',sortable:true},
			{field:'IsActive',title:'有效',width:'50',sortable:true}
			
		]],
		sortName:'IndexCat',
		onSelect:function(rindex,rowData){
			if (rindex>-1) {		
				obj.gridQCIndex_onSelect(rowData);
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

