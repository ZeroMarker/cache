//页面Gui
var objScreen = new Object();
function InitEnviHyLocItemsWin(){
	var obj = objScreen;
	obj.RecRowID1 = "";
	obj.RecRowID2 = "";
	$.parser.parse(); // 解析整个页面

	//申请科室
	obj.gridEHLocation = $HUI.datagrid("#gridEHLocation", {
		fit:true,
		title:'申请科室维护',
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		//rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: true,
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100],
		url:$URL,
		queryParams:{
		    ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
			QueryName:"QryLoc",
			aHospIDs : $.LOGON.HOSPID,
			aLocCate : "",
			aLocType : "",
			aIsActive: 1,
			locDesc:""
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
			{field:'EHItemMax',title:'限定数量（上限）',width:'120',sortable:true},
			{field:'EHItemMin',title:'限定数量（下限）',width:'120',sortable:true},
			{field:'EHItemUnitDesc',title:'限定单位',width:'100',sortable:true},
			{field:'EHPlanDate',title:'计划安排日期',width:'110',sortable:true},
			{field:'IsActiveDesc',title:'是否有效',width:'80',sortable:true},
			{field:'EHNote',title:'备注说明',width:'215',sortable:true}
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
			if(obj.RecRowID1){
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
			param.ResultSetType = 'array'
		}
	});
		
	//限定单位
	obj.ItemUnit = Common_ComboDicID('cboItemUnit','EHItemUnit');		

	InitEnviHyLocItemsWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}