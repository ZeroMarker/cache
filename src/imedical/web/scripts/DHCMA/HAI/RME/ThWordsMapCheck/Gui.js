//页面Gui
function InitThWordsMapCheckWin(){
	var obj = new Object();
	obj.RecRowID1 = "";
    $.parser.parse(); // 解析整个页面
	
	obj.gridThemeWords = $HUI.datagrid("#gridThemeWords",{
		fit: true,
		title: "主题词库",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.RMES.ThWordsMapSrv",
			QueryName:"QryThWordsToCheck",
			aThemeTypeDr:""
	    },
		columns:[[
			{field:'ID',title:'ID',width:'50',sortable:'true'},
			{field:'KeyWord',title:'关键词',width:'100',sortable:'true'},
			{field:'WordTypeDesc',title:'分类',width:'140',sortable:'true'},
			{field:'IsActive',title:'是否有效',width:'80',sortable:'true',
				formatter: function (value) {
					return (value=="1"?'<a href="#" style="color:green" >是</a>':'<a href="#" style="color:red" >否</a>')
				}	
			},
			{field:'UnCheckCnt',title:'未审核记录数',width:'110',sortable:'true'}
		]],
		onBeforeLoad: function (param) {  
			var firstLoad = $(this).attr("firstLoad");
			if (firstLoad == "false" || typeof (firstLoad) == "undefined")
			{
				$(this).attr("firstLoad","true");
				return false;
			}
			return true;
		},
		/*onClickCell: function(rindex,field,value){  //刷新设置选中后执行两遍，换成onClickCel
			if (rindex>-1) {
				var rData = $('#gridThemeWords').datagrid('getRows')[rindex];
				$('#searchThWordsMap').searchbox('clear');		
			}
		},*/
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridThemeWords_onSelect(rowData);
			}
			$('#searchThWordsMap').searchbox('clear');
		},
		onLoadSuccess:function(data){
			$("#btnAutoMap").linkbutton("enable");
			obj.RecRowID1="";
			obj.gridThWordsMapLoad();  //加载归一词对照
		}
	});
	
	obj.gridThWordsMap = $HUI.datagrid("#gridThWordsMap",{
		fit: true,
		title: "归一词库",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		//singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
		queryParams:{
			ClassName:"DHCHAI.RMES.ThWordsMapSrv",
			QueryName:"QryThWordsMap",
			aThWordsDr:''
		},
		columns:[[
			{field:null,title:'选择',checkbox:'true',align:'center',width:40,auto:false},
			{field:'OneWord',title:'归一词',sortable:true,width:200},
			{field:'OneWordCatDesc',title:'分类',sortable:true,width:100},
			{field:'CheckStatus',title:'审核状态',sortable:true,width:80},
			{field:'CheckDate',title:'审核日期',sortable:true,width:120},
			{field:'CheckUser',title:'审核人',sortable:true,width:80},
			{field:'IsActiveDesc',title:'是否<br>有效',sortable:true,width:50},
			{field:'ActDate',title:'更新日期',sortable:true,width:120}
		]],
		onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
		},
		onUncheck:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridThWordsMap_onUnCheck();
			}
		},
		onCheck:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridThWordsMap_onCheck();
			}
		},
		onUncheckAll:function(rows){
			obj.gridThWordsMap_onUnCheck();
		},
		onCheckAll:function(rows){
			obj.gridThWordsMap_onCheck();
		},
		onLoadSuccess:function(data){
			$("#btnCheck").linkbutton("disable");
			$("#btnUnCheck").linkbutton("disable");
            $("#gridThWordsMap").datagrid('unselectAll').datagrid('uncheckAll')
		}
	});
	
	//主题分类
	obj.cboThemeType= $HUI.combobox('#cboThemeType', {
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'ID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCHAI.RMES.ThemeTypeSrv';
			param.QueryName = 'QryThemeType';
			param.ResultSetType = 'array';
			param.aVersionDr = ''
		},
		onSelect: function(rd){
			if (rd) {
				$('#searchTheme').searchbox('clear');
				$('#searchThWordsMap').searchbox('clear');			
				obj.gridThemeWordsLoad(rd['ID']);
			}
		}
	});
	
	InitThWordsMapCheckWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


