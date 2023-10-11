//职业暴露类型->血清学检查计划->Gui
function InitExpTypeLabWin() {
    var obj = new Object();
    obj.RecRowID = "";
    $.parser.parse(); // 解析整个页面

    //初始化标本类型下拉菜单
    obj.cboUnit = Common_ComboDicID('cboUnit', 'HandHyUnit');
    //职业暴露类型
    obj.gridExpTypeLab = $HUI.datagrid("#gridExpTypeLab", {
        fit: true,
        //title: "血清检查计划",
        iconCls: "icon-resort",
        headerCls: 'panel-header-gray',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers: false, //如果为true, 则显示一个行号列
        singleSelect: true,
        autoRowHeight: false,//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
        fitColumns: false,
        nowrap: true, fitColumns: true,
        loadMsg: '数据加载中...',
        pageSize: 20,
        pageList: [20, 50, 100],
        url: $URL,
        queryParams: {
            ClassName: "DHCHAI.IRS.OccExpTypeSrv",
            QueryName: "QryOccExpTypeLab",
            aTypeID: Parref
        },
        columns: [[
			{ field: 'ID', title: 'ID', width: '100'},
			{ field: 'BTDesc', title: '检查时机', width: '150'},
			{ field: 'BTIndNo', title: '排序码', width: '200'},
			{ field: 'BTDays', title: '时间间隔(天)', width: '100'},
			{ field: 'LabItem', title: '检验项目', width: '200'},
			{ field: 'IsActDesc', title: '是否有效', width: '220'},
		    { field: 'Resume', title: '说明', width: '200'}
        ]],
        onSelect: function (rindex, rowData) {
            if (rindex > -1) {
                obj.gridExpTypeLab_onSelect();
            }
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (rowIndex > -1) {
                obj.LayerEdit();        //打开编辑框
                obj.layer(rowData);          //初始化编辑框
            }
        },
        onLoadSuccess: function (data) {
            $("#btnAdd").linkbutton("enable");
            $("#btnEdit").linkbutton("disable");
            $("#btnDelete").linkbutton("disable");
        }
    });
    //检验项目
	obj.cboLabItem = $HUI.combobox('#cboLabItem',{
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'ID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCHAI.DPS.LabInfTestSetSrv';
			param.QueryName = 'QryByType';
			param.aType = '2';
			param.ResultSetType = 'array'
		}
	});	
		
    InitExpTypeLabWinEvent(obj);
    obj.LoadEvent(arguments);
    return obj;
}