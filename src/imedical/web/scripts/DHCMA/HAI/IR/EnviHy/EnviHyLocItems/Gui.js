//页面Gui
var objScreen = new Object();
function InitEnviHyLocItemsWin(){
	var obj = objScreen;
	obj.RecRowID1 = "";
	obj.RecRowID2 = "";
	obj.RecRowID3 = "";
	obj.TabArgsID = "EHLoc";
	$.parser.parse(); // 解析整个页面
	
	//申请科室
	obj.gridEHLocation = $HUI.datagrid("#gridEHLocation", {
		fit:true,
		//title:'申请科室维护',
		//iconCls:"icon-resort",
		//headerCls:'panel-header-gray',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		//rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: true,
		loadMsg:'数据加载中...',
		//pageSize: 10,
		//pageList : [10,20,50,100],
		url:$URL,
		queryParams:{
		    ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
			QueryName:"QryLoc",
			aHospIDs : $.LOGON.HOSPID,
			aLocCate : "",
			aLocType : "",
			aIsActive: 1,
			locDesc:"",
			page:1,
			rows:9999
	    },
	    columns:[[
	    	{field:'ID',title:'ID',width:60},
			{field:'LocDesc2',title:'科室',width:245}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1){
				obj.gridEHLocation_onSelect();
			}
		},
		onLoadSuccess:function(data){
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
		}
	});
	
	obj.cboLocation2  = $HUI.combobox("#cboLocation2", {
		url: $URL,
		editable: true,
		allowNull: true, 
		multiple:true,
		rowStyle:'checkbox',
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'LocDesc2',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.BTS.LocationSrv';
			param.QueryName = 'QryLoc';
			param.aHospIDs = $.LOGON.HOSPID;
			param.aAlias = "";
			param.aLocCate = "";
			param.aLocType = "";
			param.aIsActive = 1;
			param.ResultSetType = 'array';
		}
	});
			
	//监测项目
	obj.gridEHItem = $HUI.datagrid("#gridEHItem", {
		fit:true,
		//title:'监测项目维护',
		//iconCls:"icon-resort",
		//headerCls:'panel-header-gray',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		//rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: true,
		loadMsg:'数据加载中...',
		//pageSize: 10,
		//pageList : [10,20,50,100],
		url:$URL,
		queryParams:{
		    ClassName:"DHCHAI.IRS.EnviHyItemSrv",
			QueryName:"QryEvItem",
			aIsActive: 1,
			page:1,
			rows:9999
	    },
	    columns:[[
	    	{field:'ID',title:'ID',width:60},
			{field:'ItemDesc',title:'监测项目',width:245}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1){
				obj.gridEHItem_onSelect();
			}
		},
		onLoadSuccess:function(data){
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
		}
	});	
	//科室申请计划列表
	obj.gridEvLocItems = $HUI.datagrid("#gridEvLocItems", {
		fit:true,
		title: "环境卫生学科室监测项目计划",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		nowrap:false,
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100],
		url:$URL,
		queryParams:{
			ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
			QueryName:"QryEnviHyLocItems",
			locId:obj.RecRowID1
		},
		columns:[[
			{field:'LoID',title:'ID',width:'50',sortable:true},
			{field:'EvItemDesc',title:'监测项目',width:'200',sortable:true},
			{field:'ApplyLocDesc',title:'监测科室',width:'200',sortable:true},
			{field:'EHItemMax',title:'计划监测数量',width:'120',sortable:true},
			{field:'IsActiveDesc',title:'是否有效',width:'80',sortable:true},
			{field:'DescList',title:'监测计划',width:'500',sortable:true},
			{field:'EHNote',title:'备注说明',width:'120',sortable:true}
			
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
		onSelect:function(rindex,rowData){
			if (rindex>-1){
				obj.gridEvLocItems_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridEvLocItems_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			if ((obj.RecRowID1)||(obj.RecRowID3)){
				$("#btnSubAdd").linkbutton("enable");
			}else{
				$("#btnSubAdd").linkbutton("disable");
			}
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
		}
	});
	
	//监测项目
	obj.Item = $HUI.combobox('#cboItem',{
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'ID',
		textField: 'ItemDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCHAI.IRS.EnviHyItemSrv';
			param.QueryName = 'QryEvItem';
			param.aIsActive="1";
			param.ResultSetType = 'array'
		}
	});
		
	//监测单位	
	obj.DateItem  = $HUI.combobox("#cboDateItem", {
		url: $URL,
		editable: true,
		allowNull: true, 
		multiple:true,
		rowStyle:'checkbox',
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.BTS.DictionarySrv';
			param.QueryName = 'QryDic';
			param.aTypeCode = "EHPlanDateItem";
			param.aActive = 1;
			param.ResultSetType = 'array';
		}
	});
	//监测单位	
	obj.DateItem2  = $HUI.combobox("#cboDateItem2", {
		url: $URL,
		editable: true,
		allowNull: true, 
		multiple:true,
		rowStyle:'checkbox',
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.BTS.DictionarySrv';
			param.QueryName = 'QryDic';
			param.aTypeCode = "EHPlanDateItem";
			param.aActive = 1;
			param.ResultSetType = 'array';
		}
	});
	InitEnviHyLocItemsWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}