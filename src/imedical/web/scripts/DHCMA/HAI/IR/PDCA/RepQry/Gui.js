//页面Gui
var objScreen = new Object();
function InitPAQryWin() {
    var obj = objScreen;
    //获取用户是否管理员
    obj.AdminPower = '0';
    if (typeof tDHCMedMenuOper != 'undefined') {
        if (typeof tDHCMedMenuOper['Admin'] != 'undefined') {
            obj.AdminPower = tDHCMedMenuOper['Admin'];
        }
    }
    //加载头部链接
    $("#custtb").append('<div style="padding: 7px 0 9px 7px;"><input class="hisui-searchbox" id="searchbox" style="width:260px;" data-options="prompt:\'搜索\'" /></div>');	  
    $("#custtb").append('<span class="line" style="display: block;border-bottom: 1px dashed rgb(204, 204, 204);margin: 1px 0px;clear: both;/* padding-bottom: 5px; */"></span>');
    
    var ModList = $cm({
        ClassName: "DHCHAI.IRS.PDCAModSrv",
        QueryName: "QryPDCAModBase",
        aIsActive: 1
    }, false);
    for(var ind=0;ind<ModList.total;ind++){
    	var ModData=ModList.rows[ind];
    	if(ModData=="")continue;
    	
    	var ModName=ModData.ModName;
    	$("#custtb").append('<a class="hisui-linkbutton" data-options="iconCls:\'icon-add\',plain:true,stopAllEventOnDisabled:true" text="' + ModData.ModID + '"  href="#">登记'+ModName+'</a>');
    }			  
    
    	$("#custtb").append('<a class="hisui-linkbutton" text="btnExport" data-options="iconCls:\'icon-export\',plain:true">导出</a>');
    $.parser.parse("#custtb"); // 解析整个页面
    
    //初始化医院
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
    //初始化日期类型
    $HUI.combobox("#cboDateType", {
        data: [
			{ value: '1', text: '登记日期', selected: true },
			{ value: '2', text: '整改日期' },
        ],
        valueField: 'value',
        textField: 'text'
    });
    //初始化日期
	var YearList = $cm ({									//初始化年(最近十年)
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryYear"
	},false);
	$HUI.combobox("#cboYear",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:YearList.rows,
		onSelect:function(rec){
			Date_QuickSelect("cboYear","cboMonth","DateFrom","DateTo");	//更改开始-结束日期
		}
	});
	var MonthList = $cm ({									//初始化月+季度+全年
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryMonth"
	},false);
	$HUI.combobox("#cboMonth",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:MonthList.rows,
		onSelect:function(rec){
			Date_QuickSelect("cboYear","cboMonth","DateFrom","DateTo");	//更改开始-结束日期
		}
	});
	var NowDate=month_formatter(new Date());
	var NowYear=NowDate.split("-")[0];	//当前年
	var NowMonth=NowDate.split("-")[1]	//当前月
	$('#cboYear').combobox('select',NowYear);
	$('#cboMonth').combobox('select',NowMonth); 
    //初始化报告状态
    $HUI.combobox("#cboStatus", {
        data: [
        	{ value: '1', text: '待整改'},
			{ value: '2', text: '正在整改'},
			{ value: '3', text: '完成整改' },
        ],
        valueField: 'value',
        textField: 'text'
    });
    //加载表格
    obj.gridPDCAQry = $HUI.datagrid("#gridPDCAQry", {
	    fit: true,
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false,//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		ClassTableName:'DHCHAI.IR.PDCAQry',
		pageSize: 20,
		pageList : [20,50,100],
		columns:[[
			{ field: 'RepID', title: 'ID', width: 50},
			{ field: 'ItemType', title: '项目类型', width: 200},
			{ field: 'ItemDesc', title: '项目名称', width: 200},
			{ field: 'IndexDesc', title: '指标名称', width: 200},
            { field: 'RegDate', title: '登记日期', width: 120},
            { field: 'RegLocDesc', title: '登记科室', width: 120},
            { field: 'RegUserDesc', title: '登记人', width: 100},
			{ field: 'TargetVal', title: '目标值', width: 100},
            { field: 'PlanLocDesc', title: '整改科室', width: 150},
            {
                field: 'PALocStatus', title: '状态', width: 100,
                formatter: function (value, row, index) {
                    return "<a href='#' onclick='objScreen.OpenPDCARep(\"" + row.ModTypeID + "\"," + "\"" + row.RepID + "\","+ "\"" + row.SubID + "\","+ "\"" + obj.AdminPower+"\");'>" + value + "</a>";
                }
            },
			{ field: 'PlanAdminUserDesc', title: '院感科责任人', width: 120},
            { field: 'PlanLocUserDesc', title: '整改科室责任人', width: 120},
            { field: 'DoASttDate', title: '整改实际开始日期', width: 130},
            { field: 'DoPEndDate', title: '整改预计结束日期', width: 130},
            { field: 'DoUserDesc', title: '提交人', width: 120},
            { field: 'DoAEndDate', title: '整改实际结束日期', width: 130},
            { field: 'AssessDesc', title: '效果评价', width: 120,}
		]],
		onDblClickRow: function (rowIndex, rowData) {
			if(rowIndex>-1){
			    var aRegTypeID = rowData.RegTypeID;
			    var aReportID = rowData.RepID;

			    obj.OpenOccView(aRegTypeID, aReportID, obj.AdminPower,obj.StatusDesc);   //打开报告
			}
		},
        onLoadSuccess: function (data) {
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        	
	        if (data.total > 0) {
	        	dispalyEasyUILoad(); 			//隐藏效果
             	//合并单元格实现表格样式
	    	 	$(this).datagrid("autoMergeCellAndCells", ['RepID','ItemType','ItemDesc','IndexDesc','RegDate']);    	//合并行
            }
        }
    });
    ShowUserHabit('gridPDCAQry');
    
    InitPAQryWinEvent(obj);
    obj.LoadEvent();
	return obj;
}