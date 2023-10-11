//页面Gui
function InitWin(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.LinkRowID="";
	obj.LinkLocTypeCode="";
	obj.LinkHosp=""
	$HUI.combobox("#cboHospital,#cboLocHosp", {
		url: $URL,
		editable: true,
		allowNull: true, 
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.BTS.HospitalSrv';
			param.QueryName = 'QryHospital';
			param.ResultSetType = 'array';
		}
	});
	
	Common_ComboDicID("cboLocType","LocType");
	Common_ComboDicID("cboLocICUType","LocICUType");
	$HUI.combobox("#cboLocGroup", {
		url: $URL,
		editable: true,
		allowNull: true, 
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'Desc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.BTS.LocGroupSrv';
			param.QueryName = 'QryLocGroup';
			param.ResultSetType = 'array';
		}
	});
	Common_ComboDicID("cboLocCate","LocCate");
	
	obj.gridLocation = $HUI.datagrid("#gridLocation",{
		fit: true,
		//title: "科室列表",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		//idField:'ID',   //存在时选中记录不会因翻页取消选中
		nowrap:true,
		fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200,500],	   
		columns:[[
			{field:'ID',title:'ID',width:80,align:'center'},
			{field:'LocCode',title:'科室代码',width:120},
			{field:'LocDesc',title:'科室名称',width:220},
			{field:'LocTypeDesc',title:'科室类型',width:100},
			{field:'LocCateDesc',title:'就诊类型',width:100},
			{field:'GroupDesc',title:'科室分组',width:80,align:'center'},
			{field:'HospDesc',title:'医院',width:220,align:'center'},
			{field:'IsOPER',title:'手术科室',width:200},
			{field:'IsICU',title:'重症病房',width:100},
			{field:'IsNICU',title:'新生儿病房',width:100},
			{field:'ICUTpDesc',title:'ICU分类',width:100},
			{field:'IsActive',title:'是否有效',width:100},
			{field:'IndNo',title:'排序码',width:100}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLocation_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if (rowIndex>-1) {
				obj.gridLocation_onDblClickRow(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnSyn").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnVirtual").linkbutton("disable");
			$("#btnLocLink").linkbutton("disable");
		}
	});
	obj.gridLocLink = $HUI.datagrid("#gridLocLink",{
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, 		//分页工具栏
		rownumbers: false, 		//行号列
		singleSelect: true,
		autoRowHeight: false, 	//设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap:true,
		fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
	    url:$URL,
	    queryParams:{                
		    ClassName:"DHCHAI.BTS.LocationSrv",
			QueryName:"QryLocLink",
			aLocID:(typeof(obj.LinkID)=='undefined'?'':obj.LinkID)
	    },
		columns:[[
			{field:'LinkLocDesc',title:'科室',width:180}
			
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLocLink_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
		},
		onLoadSuccess:function(data){	
			$("#btnAddLink").linkbutton("enable");
			$("#btnEditLink").linkbutton("disable");
			$("#btnDeleteLink").linkbutton("disable");
		}
	});
	
	
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}
$(InitWin);

