function InitDictionaryListWin(){
	var obj=new Object();
	obj.CurrDicType = "";//获取字典表类型
	obj.CurrNode = null;//获取选定节点
	obj.ProductId= "";//每次点父节点就更新,用于显示“所属产品” 
	$.parser.parse();
	
	obj.GetStrDic=function(RowId){
		var strDic=$m({
			ClassName :'DHCMed.SS.Dictionary',
			MethodName : 'GetStringById',
			id :RowId,
			separete:'^'
		},false)
		return strDic
	}
	
	//树
	$('#treeType').tree({
		url:$URL+"?ClassName=DHCMed.SSService.TreeService&QueryName=QryDictionaryTree&aType=root-"+ProductCode+"&ResultSetType=array"	
		,onLoadSuccess:function(node,data)
		{
		},
		onClick:function(node){					
			//obj.treeClick(node);
			//obj.isAdded=0;
		},
		onSelect:function(node){
			obj.treeClick(node);
			var idVal = node.id;
			var  valArr =idVal.split("-");
			obj.CurrDicType=valArr[1];	
			obj.CurrNode=node;	
			/*obj.isAdded=0; */
		}
		,onExpand:function(node)
		{
			obj.refreshNode(node);			
		}
		,onContextMenu: function(e, node){
			e.preventDefault();	
			// select the node
			$('#treeType').tree('select', node.target);
			// display context menu
			if(node.id.indexOf("product-")>-1)
			{	 
				$("#btnAddType").linkbutton('enable');
				$("#btnAddItem").linkbutton('disable');
				$("#btnEditType").linkbutton('disable');
				obj.ProductId=node.id.split("-")[1];
			}
			if(node.id.indexOf("dicType-")>-1) {
				$("#btnAddType").linkbutton('disable');
				$("#btnAddItem").linkbutton('enable');
				$("#btnEditType").linkbutton('enable');
			}
			$('#mm').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
	});
	obj.refreshNode = function(node,desc)
	{
		//加载子节点数据				
		var subNodes = [];
		obj.ProductId=node.id.split("-")[1];
		$(node.target).next().children().children("div.tree-node").each(function(){   
			var tmp = $('#treeType').tree('getNode',this);
			subNodes.push(tmp);
		});
		console.log(subNodes);
		for(var i=0;i<subNodes.length;i++)
		{
			$('#treeType').tree('remove',subNodes[i].target);
		}
		
		$cm({
			ClassName:"DHCMed.SSService.TreeService",
			QueryName:"QryDictionaryTree",
			aType:node.id,
			aDesc:desc,
			ResultSetType:"array", 
			page:1,    
			rows:9999
		},function(rs){   		
			$('#treeType').tree('append', {
				parent: node.target,
				data: rs
			});
		});	
	};
	obj.treeClick = function(node)
	{
		var type=""
		var idVal = node.id;
		var  valArr =idVal.split("-");
		obj.CurrDicType=valArr[1];	
		obj.CurrNode=node;
		 if(idVal.indexOf("dicType-")>-1) {
			//第二层 项目
			type=valArr[1]
		}
		obj.gridItems.load({
			ClassName:"DHCMed.SSService.DictionarySrv",
			QueryName:"QryDictionary",
			aType:type,
			aIsActive:''
		})
		$('#treeType').tree('toggle', node.target);	
	};
		
	//表
	obj.gridItems=$HUI.datagrid("#gridItems",{			
		fit: true,
		//title: "",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100,200],
		url:$URL,
		queryParams:{		 
			ClassName:"DHCMed.SSService.DictionarySrv",
			QueryName:"QryDictionary",
			aType:'',//'EpdemicType',//objNode.id.split("-")[1]
			aIsActive:''
		},
		columns:[[
			{field:'Code',title:'代码',width:'150'},
			{field:'Description',title:'描述',width:'280'}, 
			{field:'Active',title:'是否有效',width:'80',
				formatter: function(value,row,index){
					if (row.Active=="Yes"){
						return "是";
					} else {
						return "否";
					}
				}
			},
			{field:'HispsDescs',title:'医院',width:'280'},
			{field:'InNo',title:'排序码',width:'120'}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridItems_onDbselect(rowData);
			}
		}
	});
	//加载医院和产品下拉框
	var ComboHosp = $HUI.combobox("#cboHosp", {
		url: $URL,
		editable: true,
		allowNull: true,
		valueField: 'rowid',
		textField: 'hosName',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCMed.Base.Hospital';
			param.QueryName = 'QueryHosInfo';
			param.ResultSetType = 'array';
		}
	});
	var ComboToSSHosp = $HUI.combobox("#cboPro", {
		url: $URL,
		editable: true,
		valueField: 'ProCode',
		textField: 'ProName',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCMed.SSService.ProductsSrv';
			param.QueryName = 'FindProInfo';
			param.ResultSetType = 'array';
		}
	});
	
	InitDictWinEvent(obj);
	obj.LoadEvent(arguments);	
	return obj;
}