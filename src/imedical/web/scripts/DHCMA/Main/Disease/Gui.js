//页面gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
	obj.RecRowID="";
	obj.editIndex=undefined;	
    $.parser.parse(); // 解析整个页面
	
	obj.gridDisease =$HUI.datagrid("#gridDisease",{
		fit: true,
		title: "疾病字典维护",
		headerCls:'panel-header-gray',
		iconCls:'icon-write-order',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		//rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMed.SSService.DiseaseSrv",
			QueryName:"QryDisease",
			aProductCode: ProductCode			
	    },
		columns:[[
			{field:'IDCode',title:'疾病代码',width:100},
			{field:'IDDesc',title:'疾病描述',width:200},
			{field:'expander',title:'疾病别名',width:80,align:'center',
			  	formatter: function(value,row,index){
				  	return " <a href='#' style='white-space:normal; color:blue' onclick='objScreen.openHandler(\"" + row.ID + "\");'>别名</a>";
			  	}
			},	
			{field:'ICD10',title:'疾病ICD',width:100},
			{field:'link',title:'ICD维护',width:80,align:'center',
			  	formatter: function(value,row,index){
				  	return " <a href='#' style='white-space:normal; color:blue' onclick='objScreen.openHandler_two(\"" + row.ID + "\");'>ICD</a>";
			  	}
			},	
			{field:'CateDesc',title:'疾病分类',width:200},
			{field:'ProName',title:'产品',width:150},
			{field:'IsActiveDesc',title:'是否有效',width:80,align:'center'},
			{field:'Resume',title:'备注',width:150}		
		]],
		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1) {
				obj.gridDisease_onSelect(rowData);
			}
		}
	});
	
	
	obj.gridAlias =$HUI.datagrid("#gridAlias",{
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		columns:[[
			{field:'IDAlias',title:'别名',width:480,editor:'text'},
			{field:'ID',title:'Code',hidden:true}				
		]],
		onDblClickRow:function(rindex,rowData1){
			obj.editHandler(rindex);
		}
	});
	
	obj.gridICD =$HUI.datagrid("#gridICD",{
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		columns:[[
			{field:'IDICD10',title:'ICD10',width:120,editor:'text'},
			{field:'IDICDDesc',title:'疾病名称',width:200,editor:'text'},
			{field:'IDExWords',title:'排除关键字(多值#分隔)',width:200,editor:'text'},
			{field:'ID',title:'Code',hidden:true}				
		]],
		onDblClickRow:function(rindex,rowData1){
			obj.editHandler_two(rindex);
		}
	});
		
	//产品下拉框
	obj.cboProduct = $HUI.combobox('#cboProduct', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'rowid',
		textField: 'ProName',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMed.SSService.ProductsSrv';
			param.QueryName = 'QueryProInfo';
			param.cProName = '';
			param.ResultSetType = 'array';
		},
	    onLoadSuccess:function(){  
			var ProductId = $m({     		     
				ClassName:"DHCMed.SS.Products",
				MethodName:"GetIDByCode",
				aCode :ProductCode
			},false);
			
			$('#cboProduct').combobox('select',ProductId);
		
			$('#cboProduct').combobox('disable');
		}
	});
	
	obj.objById = function(ProductId){
		var objPro = $m({      //返回ID报告状态代码            
				ClassName:"DHCMed.SS.Products",
				MethodName:"GetObjById",
				id:ProductId
			},false);
		return objPro;
	};
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);	
	return obj;
}