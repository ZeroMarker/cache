//页面Gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
	obj.ParrefID=""
    $.parser.parse(); // 解析整个页面 
    
    obj.gridIMPCategory =$HUI.datagrid("#gridIMPCategory",{
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		//rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false, 
		loadMsg:'数据加载中...',
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.IMP.BTS.IMPCategorySrv",
			QueryName:"QryIMPCategory"		
	    },
		columns:[[
			{field:'CateDesc',title:'重点患者分类描述',width:'150',sortable:true},
			//{field:'CateCode',title:'重点患者分类代码',width:'100',sortable:true},
			//{field:'CateFlag',title:'重点患者分类标识',width:'150',sortable:true},
			{field:'BTIsActive',title:'是否有效',width:'96',align:'center'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridIMPCategory_onSelect(rowData);
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){			
				obj.gridIMPCategory_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	obj.RuleType=$HUI.combobox("#RuleType",{
				url:$URL+'?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&ResultSetType=Array&aTypeCode=IMPRuleType',
				valueField:'BTID',
				textField:'BTDesc',
				panelHeight:'auto'
				})
		 
	obj.gridIMPRules = $HUI.datagrid("#gridIMPRules",{
		fit:true,
		title: "重点患者判断规则维护",
		iconCls:"icon-template",
		toolbar:'#custtb',
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		fitColumns:false,
		striped:true,
		rownumbers:true, 
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,50],
	    url:$URL,
	    nowrap:false,
	    queryParams:{
		    ClassName:"DHCMA.IMP.BTS.IMPCateRulesSrv",
			QueryName:"QryIMPCateRules"				
	    },
		columns:[[	
			{field:'RuleCode',title:'规则代码',width:'180',sortable:true},
			{field:'RuleDesc',title:'规则描述',width:'180',sortable:true},
			{field:'RuleExpress',title:'规则函数',width:'180',sortable:true},
			{field:'RuleTypeDesc',title:'规则类型',width:'160',sortable:true},
			//{field:'LinkedReasonDesc',title:'关联特因',width:'180',sortable:true},
			{field:'BTIsActive',title:'是否<br>有效',align:'center',width:'100',sortable:true}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridIMPRules_onDbselect(rowData);
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridIMPRules_onSelect(rowData);
			}
		},
		onLoadSuccess:function(data){
		}
	});
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


