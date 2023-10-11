//页面Gui
var objScreen = new Object();
function InitHandHyConsumsWin() {
    var obj = objScreen;
    obj.SelectLocID = "";
    $.parser.parse(); // 解析整个页面
    //初始化医院
    obj.cboHospital = Common_ComboToSSHosp("cboHospital", $.LOGON.HOSPID);
    //初始化病区
	obj.cboLoction = Common_ComboToLoc("cboLoction", $.LOGON.HOSPID, "", "", ""); 
    //初始化编辑框
	obj.cboHospitalEdit = Common_ComboToSSHosp("cboHospitalEdit", $.LOGON.HOSPID);  //初始化医院
    //
	var cboProduct = $HUI.combobox("#cboProduct", {
	    url: $URL,
	    editable: true,
	    allowNull: true,
	    defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
	    valueField: 'ID',
	    textField: 'HHPDesc',
	    onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
	        param.ClassName = 'DHCHAI.IRS.HandHyProductsSrv';
	        param.QueryName = 'QryCboHHProducts';
	        param.aIsActive = '1';
	        param.ResultSetType = 'array';
	    }
	});
    
	obj.dtDateFrom = $('#dtDateFrom').datebox('setValue', Common_GetDate(new Date()));  // 初始化开始日期
	obj.dtDateTo = $('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));  // 初始化结束日期
	 
    //obj.dtDate = $('#dtDate').datebox('setValue', Common_GetDate(new Date()));  // 初始化日期
	
	
	//手卫生用品消耗登记
    obj.gridHHConsums = $HUI.datagrid("#gridHHConsums", {
		fit:true,
		title: "手卫生用品消耗登记",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		singleSelect: true,
		loadMsg: '数据加载中...',
		nowrap: true, fitColumns: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		pageSize: 20,
		pageList : [20,50,100],
		/*
		url:$URL,
		queryParams:{
		    ClassName: "DHCHAI.IRS.HandHyConsumsSrv",
		    QueryName: "QryHHConsums",
		    aHospID: "",
		    aLocID: "",
		    aDateFrom: "",
		    aDateTo: ""
		},*/
		columns:[[
			{ field: 'LocDesc', title: '科室/病区', width: 150, align: 'left' },
			{ field: 'ID', title: '报告编号', width:80, align: 'left' },
			{ field: 'ObsDate', title: '日期', width: 100, align: 'left' },
			{ field: 'ProductDesc', title: '手卫生用品', width: 180, align: 'left' },
			{ field: 'Consumption', title: '消耗量', width: 70, align: 'left' },
			{ field: 'Recipient', title: '领用人', width: 80, align: 'left' },
            { field: 'RepDate', title: '登记日期', width: 100, align: 'left' },
            { field: 'RepTime', title: '登记时间', width: 100, align: 'left' },
            { field: 'RegUserDesc', title: '登记人', width: 80, align: 'left' },
            { field: 'IsActiveDesc', title: '是否有效', width: 80, align: 'left'},
            { field: 'Resume', title: '备注', width: 100, align: 'left' }
		]],
		onSelect:function(rindex,rowData){
		    if (rindex > -1) {
		        obj.gridHHConsums_onSelect();
		    }
		},
		onDblClickRow: function (rowIndex, rowData) {
		    if (rowIndex > -1) {
		        $('#LayerEdit').show();
		        $('#cboLoctionEdit').combobox('setValue', 619);
		        obj.layer(rowData);
		    }
		},
        onLoadSuccess: function (data) {
            $("#btnEdit").linkbutton("enable");
            $("#btnDelete").linkbutton("disable");
        }
	});
	InitHandHyConsumsWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}