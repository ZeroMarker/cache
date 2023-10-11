//页面Gui
function InitAssModelWin(){
	var obj = new Object();
    obj.RecRowID = '';	
  	
	$HUI.combobox("#cboSuRule",{
		url:$URL+'?ClassName=DHCHAI.IRS.CRuleSuRuleSrv&QueryName=QrySuRule&ResultSetType=Array&aIsActive=1',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		editable:false,
		valueField:'RuleID',
		textField:'RuleNote'
	});
	
	
    obj.gridAssModel = $HUI.datagrid("#AssessModel",{
		fit: true,
		title:'疑似病例筛查评估模型',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
			ClassName:'DHCHAI.AMS.AssessModelSrv',
			QueryName:'QryAssessModel'
	    },
		columns:[[
			{field:'ID',title:'ID',width:60},
			{field:'AMCode',title:'评估模型代码',width:100},
			{field:'AMDesc',title:'评估模型定义',width:240},
			{field:'AdmStatusDesc',title:'状态',width:60,align:'center'},
			{field:'ClassName',title:'类方法',width:220},
			{field:'SuRules',title:'启用规则',width:280,
				formatter: function(value,row,index){
					if (!value){
					  	return "";
				  	}else {
				  		var strList = value.split(",");
					  	var len = strList.length;	   
					    var strRet ="";
					  	for (var indx=0;indx<len;indx++){
						  	var SuRule =value.split(",")[indx];					  
					        strRet +="<span style='line-height:30px;' >"+SuRule+"</span></br>";
					  	}
					  	return strRet;
					}	
				}
			},
			{field:'Note',title:'评估说明',width:240,showTip:true},
			{field:'IsActDesc',title:'是否有效',width:80,align:'center'}, 
			{field:'SttDate',title:'开始日期',width:95,align:'center'},
			{field:'EndDate',title:'结束日期',width:95,align:'center'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridAssModel_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridAssModel_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitAssModelWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


