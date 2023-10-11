//页面Gui
var objScreen = new Object();
function InitOccExpQryWin() {
    var obj = objScreen;
   
    $.parser.parse(); // 解析整个页面

    obj.AdminPower = '0';
    if (typeof tDHCMedMenuOper != 'undefined') {
        if (typeof tDHCMedMenuOper['Admin'] != 'undefined') {
            obj.AdminPower = tDHCMedMenuOper['Admin'];
        }
    }
    obj.SelectLocID = "";
    //初始化医院
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onSelect:function(rec){
			 //初始化登记科室
   			 obj.cboLoction = Common_ComboToLoc("cboLocation", rec.ID, "", "", "","1");
		},
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
    //初始化报告类型
    function Common_ComboRepType() {
        var cbox = $HUI.combobox("#cboRepType", {
            url: $URL,
            editable: true,
            allowNull: true,
            defaultFilter: 4,
            valueField: 'ID',
            textField: 'BTDesc',
            onBeforeLoad: function (param) {    
                param.ClassName = 'DHCHAI.IRS.OccExpTypeSrv';
                param.QueryName = 'QryOccExpType';
                param.ResultSetType = 'array';
            }
        });
        return cbox;
    }
    obj.RepType = Common_ComboRepType();
    //初始化日期类型
    $HUI.combobox("#cboDateType", {
        data: [
			{ value: '1', text: '待提醒', selected: true },
			{ value: '2', text: '已提醒' }
        ],
        valueField: 'value',
        textField: 'text'
    }); 
	
	var DateFrom=new Date(new Date().getTime()-7*24*3600*1000);
    //初始化报告状态
    obj.cboUnit = Common_ComboDicID('cboStatus', 'OERegStatus');
	// 日期赋初始值
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

	//职业暴露
    obj.gridExpReg = $HUI.datagrid("#gridExpReg", {
		fit:true,
		title: "职业暴露报告提醒查询",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		singleSelect: true,
		loadMsg: '数据加载中...',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		nowrap: true, 
		fitColumns: true,
		pageSize: 20,
		pageList : [20,50,100],
		sortOrder:'asc',
		remoteSort:false,
		url:$URL,
		queryParams:{
		    ClassName: "DHCHAI.IRS.OccExpRegSrv",
		    QueryName: "QryOccExpRemind",
		    aHospIDs: "",
		    aRepType: "",
		    aDateType: "",
		    aDateFrom: "",
		    aDateTo: "",
		    aRegLoc: ""
		},
		columns:[[
			{ field: 'ID', title: 'ID', width: '60', sortable: true, align: 'center',sortable:true },
            { field: 'Name', title: '姓名', width: '100', align: 'center',sortable:true },
            { field: 'RegNo', title: '工号', width: '100', align: 'center',sortable:true },
            { field: 'Sex', title: '性别', width: '60', align: 'center',sortable:true },
            { field: 'Age', title: '年龄', width: '60', align: 'center',sortable:true },
            { field: 'TelPhone', title: '电话', width: '120', align: 'center',sortable:true },
           	{ field: 'ExpDate', title: '暴露日期', width: '120', align: 'center',sortable:true,sorter:Sort_int },
            { field: 'RegDate', title: '登记日期', width: '120', align: 'center',sortable:true,sorter:Sort_int },
            {
                field: 'Oper', title: '操作', width: '300', align: 'center',sortable:true,
                formatter: function (value, row, index) {
	                //日期类型(未提醒/已提醒)
	                var DateType = $('#cboDateType').combobox('getValue');
	                if(DateType==1){
		            	if (row.IsRequire == '1') {
                            return "<a href='#' onclick='objScreen.OpenOccRemind(\"" + index + "\");'>" + "提醒:" + row.RequireLsit.replace(/#/g, '<br />') + "</a>";
                        }
		            }
		            else{
		            	 if (row.IsRemind == '1') {
                            return '已提醒' + '(' + row.RemindDate+ ')';
                        }
		            }
                }
            },
			{
			    field: 'Detil', title: '明细', width: '80', align: 'center',sortable:true,
			    formatter: function (value, row, index) {
				    //日期类型(未提醒/已提醒)
	                var DateType = $('#cboDateType').combobox('getValue');
	                if(DateType==1){
		            	if (row.IsRequire == '1') {
			                return "<a href='#' onclick='objScreen.OpenOccRepLog(\"" + row.ID + "\");'>提醒明细</a>";
			            } else {
			                return '';
			            }
		            }
		            else{
		            	 return "<a href='#' onclick='objScreen.OpenOccRepLog(\"" + row.ID + "\");'>提醒明细</a>";
		            }
			    }
			}
		]]
    });
    //职业暴露操作
    obj.gridExpRepLog = $HUI.datagrid("#gridExpRepLog", {
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
            QueryName: "QryExpRepLog",
            aRepID: "",
            aStatus:""
        },
        columns: [[
			{ field: 'SubID', title: '报告ID', width: '80', align: 'center' },
			{ field: 'StatusDesc', title: '操作', width: '120', align: 'center' },
			{ field: 'Opinion', title: '操作意见', width: '200', align: 'center' },
			{ field: 'UpdateDate', title: '操作日期', width: '120', align: 'center' },
            { field: 'UpdateTime', title: '操作时间', width: '120', align: 'center' },
             { field: 'UpdateUserDesc', title: '操作人', width: '120', align: 'center' }
        ]]
    });
    InitOccExpQryWinEvent(obj);
	return obj;
}