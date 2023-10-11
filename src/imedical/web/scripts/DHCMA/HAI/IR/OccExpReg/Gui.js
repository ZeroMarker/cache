//页面Gui
var objScreen = new Object();
function InitOccExpRegWin() {
    var obj = objScreen;
    obj.zyblTitle=$g('职业暴露报告');
    //获取用户是否管理员
    obj.AdminPower = '0';
    if (typeof tDHCMedMenuOper != 'undefined') {
        if (typeof tDHCMedMenuOper['Admin'] != 'undefined') {
            obj.AdminPower = tDHCMedMenuOper['Admin'];
        }
    }
    obj.GroupDesc = session['LOGON.GROUPDESC'];
    var SupNurFlg = 0;
    var SupDocFlg = 0;
    if (obj.GroupDesc.indexOf('护士长') > -1) {
        SupNurFlg = 1;      //是否护士长
    }
    if (obj.GroupDesc.indexOf('主任') > -1) {
        SupDocFlg = 1       //是否主任·
    }
    //加载头部链接
    var OccExpTypes = $cm({
        ClassName: "DHCHAI.IRS.OccExpTypeSrv",
        QueryName: "QryOccExpType",
        aActive: 1
    }, false);
    for(var ind=0;ind<OccExpTypes.total;ind++){
        var OccExpType=OccExpTypes.rows[ind];

        var RepID=OccExpType.ID;
        var RepType=OccExpType.BTDesc;
        var RepCode=OccExpType.BTCode;
        var imgType = "";
        if ((RepType.indexOf('血液')>-1)||(RepType.indexOf('体液液')>-1)) {
            imgType = "血液体液接触";
        }
        if ((RepType.indexOf('针刺伤')>-1)||(RepType.indexOf('刺伤')>-1)) {
            imgType = "针刺伤";
        }
        if ((RepType.indexOf('锐器伤')>-1)||(RepType.indexOf('利器损伤')>-1)) {
            imgType = "锐器伤";
        }
        else {
            imgType = "血液体液接触";
        }
        $("#custtb").append('<a class="hisui-linkbutton" data-options="plain:true" text="' + RepID + '"  href="#"><img src=" ../scripts/dhchai/img/' + imgType + '.png"><span>' + RepType + '</span></a>');
    }
    
    $.parser.parse(); // 解析整个页面
    //用户ID
    if ((obj.AdminPower==1)||(SupNurFlg==1)||(SupDocFlg==1)) {
        aUserID ="";
    }else {
        aUserID = $.LOGON.USERID;
    }

    //职业暴露登记
    obj.gridExpReg = $HUI.datagrid("#gridExpReg", {
		fit: true,
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false,//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		//nowrap: true, fitColumns: true,     //自动填充整个页面
		view:scrollview,
		loadMsg:'数据加载中...',
		pageSize: 50,
		pageList : [50,100,200,500],
		url:$URL,
		queryParams:{
		    ClassName: "DHCHAI.IRS.OccExpRegSrv",
		    QueryName: "QryExpRegInfo",
		    aUserID:aUserID,
		    aRegLoc:$.LOGON.LOCID
		},
		columns:[[
			{ field: 'ID', title: '报告ID', width: 60, align: 'center' },
			{ field: 'RegLocDesc', title: '登记科室', width: 80, align: 'center' },
			{ field: 'RegTypeDesc', title: '登记类型', width: 200, align: 'center' },
            {
                field: 'StatusDesc', title: '状态', width: 60, align: 'center',
                formatter: function (value, row, index) {
                    return "<a href='#' onclick='objScreen.OpenOccView(\"" + row.RegTypeID + "\"," + "\"" + row.ID + "\"," + "\"" + obj.AdminPower+ "\"," + "\"" + obj.StatusDesc + "\");'>" + value + "</a>";
                }
            },
            {
			    field: 'ZY', title: '追踪检测', width: '80', align: 'center',sortable:true,
			    formatter: function (value, row, index) {
			        return "<a href='#' onclick='objScreen.OpenOccLab(\"" + row.RegTypeID+ "\"," + "\"" + row.ID + "\");'>"+$g("追踪检测")+"</a>";
			    }
			},
			{
			    field: 'link', title: '打印条码', width: '80', align: 'center',
			    formatter: function (value, row, index) {
			        return "<a href='#' onclick='objScreen.OpenOccRepBarCode(\"" + row.ID + "\");'>打印条码</a>";
			    }
			},
            { field: 'RegUserDesc', title: '登记人', width: 120, align: 'center' },
            { field: 'Name', title: '姓名', width: 100, align: 'center' },
			{ field: 'RegNo', title: '工号', width: 100, align: 'center' },
			{ field: 'Sex', title: '性别', width: 60, align: 'center' },
            { field: 'Age', title: '年龄', width: 80, align: 'center' },
            { field: 'TelPhone', title: '电话', width: 100, align: 'center' },
            { field: 'ExpDate', title: '暴露日期', width: 100, align: 'center' },
            { field: 'ExpTime', title: '暴露时间', width: 100, align: 'center' },
            { field: 'RegDate', title: '登记日期', width: 100, align: 'center' },
            { field: 'RegTime', title: '登记时间', width: 100, align: 'center' }
		]],
		onDblClickRow: function (rowIndex, rowData) {
			if(rowIndex>-1){
			    var aRegTypeID = rowData.RegTypeID;
			    var aReportID = rowData.ID;

			    obj.OpenOccView(aRegTypeID, aReportID, obj.AdminPower,obj.StatusDesc);   //打开职业暴露报告
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
            //$(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
            $(this).datagrid('columnMoving'); //列可以拖拽改变顺序
		}
	});
	ShowUserHabit('gridExpReg');
	
	//职业暴露检查项目
    obj.gridExpBarCode = $HUI.datagrid("#gridExpBarCode", {
        fit: true,
        iconCls: "icon-resort",
        headerCls: 'panel-header-gray',
        singleSelect: true,
        loadMsg: '数据加载中...',
        nowrap: false, //fitColumns: true, //自动填充
        pageSize: 20,
        pageList: [20, 50, 100],
        url: $URL,
        queryParams: {
            ClassName: "DHCHAI.IRS.OccExpRegSrv",
            QueryName: "QryExpLabSubByType",
            aRepID: "",
            aLabList: ""
        },
        columns: [[
			{ field: 'RepID', title: '报告ID', width: '80', align: 'center' },
			{ field: 'Desc', title: '检查时机', width: '120', align: 'center' },
			{ field: 'BTResume', title: '说明', width: '120', align: 'center' },
            { field: 'SpenBarCode', title: '条码号', width: '120', align: 'center',
			    formatter: function (value, row, index) {
			        return "O" + value;
			    }
			 },
            { field: 'LabResult', title: '检验结果', width: '120', align: 'center' },
			{
			    field: 'zy', title: '打印条码', width: '80', align: 'center',
			    formatter: function (value, row, index) {
			        return "<a href='#' onclick='objScreen.PrintBarCode(\"" + row.RepID + "\","+"\""+ row.RegTypeDesc +"\","+"\""+ row.SpenBarCode +"\","+"\""+ row.Desc +"\","+"\""+ row.BTResume +"\"" +");'>打印条码</a>";
			    }
			}
        ]]
    });
    
	InitOccExpRegWinEvent(obj);
	return obj;	
}