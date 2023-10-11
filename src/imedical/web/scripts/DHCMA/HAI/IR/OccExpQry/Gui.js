//页面Gui
var objScreen = new Object();
function InitOccExpQryWin() {
    var obj = objScreen;
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
    $("#custtb").append('<a class="hisui-linkbutton" text="btnExport" data-options="iconCls:\'icon-export\',plain:true"> 导出 </a>');
    $.parser.parse(); // 解析整个页面

    obj.AdminPower = '0';
    if (typeof tDHCMedMenuOper != 'undefined') {
        if (typeof tDHCMedMenuOper['Admin'] != 'undefined') {
            obj.AdminPower = tDHCMedMenuOper['Admin'];
        }
    }
    obj.SelectLocID = "";
    //初始化医院
	var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:$.LOGON.HOSPID
	},false);
	obj.HospData = HospList.rows;
	
    $HUI.combobox("#cboHospital",{
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		data:obj.HospData,
		onSelect:function(rec){
			 //初始化登记科室
    		Common_ComboToLoc("cboLocation", rec.ID, "", "", "","1");
		},
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	
    //初始化报告类型
    function Common_ComboRepType() {
	    var OccExpList = $cm ({
			ClassName:"DHCHAI.IRS.OccExpTypeSrv",
			QueryName:"QryOccExpType",
			aLogonHospID:$.LOGON.HOSPID
		},false);
		obj.OccExpData = OccExpList.rows;
	
        var cbox = $HUI.combobox("#cboRepType", {
	        valueField:'ID',
			textField:'BTDesc',
			editable:false,
			data:obj.HospData,
           	data:obj.OccExpData,
			onLoadSuccess:function(data){
				$('#cboRepType').combobox('select',data[0].ID);
			}            
        });
        return cbox;
    }

    obj.RepType = Common_ComboRepType();
    //初始化日期类型
    $HUI.combobox("#cboDateType", {
        data: [
			{ value: '1', text: '登记日期' },
			{ value: '2', text: '暴露日期', selected: true },
        ],
        valueField: 'value',
        textField: 'text'
    });
    //初始化检验状态
    $HUI.combobox("#cboLabStatus", {
        data: [
			{ value: '1', text: '已完成' },
			{ value: '2', text: '未完成' },
        ],
        valueField: 'value',
        textField: 'text'
    });
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
  
    //初始化报告状态
    obj.cboUnit = Common_Combobox('cboStatus', 'OERegStatus');
    
    function Common_Combobox() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var IsValued= arguments[2];   //是否初始赋值
	if (!IsValued) {
		var cbox = $HUI.combobox("#"+ItemCode, {
			editable: true,       
			defaultFilter:4,       
			allowNull: true,
			valueField: 'ID',
			textField: 'DicDesc', 
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+DicType+"&aActive=1";
			    $("#"+ItemCode).combobox('reload',url);
			}
		});	
	} else {
		var cbox = $HUI.combobox("#"+ItemCode, {
			url:$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+DicType+"&aActive=1",
			editable: false,       
			defaultFilter:4,
			allowNull: true,    
			valueField: 'ID',
			textField: 'DicDesc'
		});	
	}	
	return;
}

    obj.gridExpReg = $HUI.datagrid("#gridExpReg", {
		fit:true,
		title: "职业暴露报告查询",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		singleSelect: true,
		loadMsg: '数据加载中...',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		nowrap: false,   //自动换行
		pageSize: 20,
		pageList : [20,50,100],
		url:$URL,
		queryParams:{
		    ClassName: "DHCHAI.IRS.OccExpRegSrv",  
		    QueryName: "QryOccExpReg",
		    aHospIDs: "",
		    aRepType: "",
		    aDateType: "",
		    aDateFrom: "",
		    aDateTo: "",
		    aRegLoc: "",
		    aStatus: "",
		    aLabStatus:""
		},
		columns:[[
			
			{ field: 'RegTypeDesc', title: '报告类型', width: '200', align: 'center',sortable:true },
			{
			    field: 'StatusDesc', title: '状态', width: '80', align: 'center',sortable:true,
			    formatter: function (value, row, index) {
			    return "<a href='#' onclick='objScreen.OpenOccView(\"" + row.RegTypeID + "\"," + "\"" + row.ID + "\"," + "\"" + obj.AdminPower + "\");'>" + value + "</a>";
			    }
			},
			{ field: 'RegLocDesc', title: '登记科室', width: '120', align: 'center',sortable:true},
			{ field: 'RegUserDesc', title: '登记人', width: '100',align:'center',sortable:true},
            { field: 'RegDate', title: '登记日期', width: '100', align: 'center',sortable:true,sorter:Sort_int },
            {
			    field: 'link1', title: '追踪检测', width: '80', align: 'center',sortable:true,
			    formatter: function (value, row, index) {
			        return "<a href='#' onclick='objScreen.OpenOccLab(\"" + row.RegTypeID+ "\"," + "\"" + row.ID + "\");'>追踪检测</a>";
			    }
			},
			{
			    field: 'ZY', title: '操作明细', width: '80', align: 'center',sortable:true,
			    formatter: function (value, row, index) {
			        return "<a href='#' onclick='objScreen.OpenOccRepLog(\"" + row.ID + "\");'>操作明细</a>";
			    }
			},
			{
			    field: 'link', title: '打印条码', width: '80', align: 'center',
			    formatter: function (value, row, index) {
			        return "<a href='#' onclick='objScreen.OpenOccRepBarCode(\"" + row.ID + "\");'>打印条码</a>";
			    }
			},
            { field: 'Name', title: '姓名', width: '100', align: 'center',sortable:true},
            { field: 'RegNo', title: '工号', width: '100', align: 'center',sortable:true },
            { field: 'Sex', title: '性别', width: '60', align: 'center',sortable:true },
            { field: 'Age', title: '年龄', width: '60', align: 'center',sortable:true},
            { field: 'TelPhone', title: '电话', width: '120', align: 'center',sortable:true },
			{ field: 'ExpDate', title: '暴露日期', width: '100', align: 'center',sortable:true,sorter:Sort_int },
			{ field: 'ExpLocDesc', title: '员工工作科室', width: '120', align: 'center',sortable:true },	
            { field: 'Item1', title: '工龄', width: '100', align: 'center',sortable:true },
     		{ field: 'Item2', title: '本次职业暴露是', width: '130', align: 'center',sortable:true },
            { field: 'Item3', title: '工作类别', width: '100', align: 'center',sortable:true },
            { field: 'Item4', title: '暴露地点', width: '100', align: 'center',sortable:true },
    		{ field: 'Item5', title: '锐器类型', width: '100', align: 'center',sortable:true },
			{ field: 'Item6', title: '损伤和危险度', width: '130', align: 'center',sortable:true },
			{ field: 'Item7', title: '危险物来源', width: '130', align: 'center',sortable:true },
			{ field: 'Item8', title: '是否接种过乙肝疫苗', width: '150', align: 'center',sortable:true },
            { field: 'Item9', title: '暴露程度', width: '100', align: 'center',sortable:true },
            { field: 'Item10', title: '暴露部位', width: '100', align: 'center',sortable:true  },
            { field: 'Item11', title: '暴露源(姓名)', width: '100', align: 'center',sortable:true  },
    		{ field: 'Item12', title: '病案号/登记号', width: '100', align: 'center',sortable:true  },
            { field: 'Item13', title: '暴露源(HBV)', width: '100', align: 'center',sortable:true  },
            { field: 'Item14', title: '暴露源(HCV)', width: '100', align: 'center',sortable:true  },
            { field: 'Item15', title: '暴露源(HIV)', width: '100' , align: 'center',sortable:true },
            { field: 'Item16', title: '暴露源(梅毒)', width: '100', align: 'center',sortable:true  },
     		{ field: 'Item17', title: '本次职业暴露是否接受了专科医师评估', width: '250', align: 'center',sortable:true  },   
     		{ field: 'Item18', title: '本次职业暴露接受干预用药', width: '200', align: 'center',sortable:true  },
    		{ field: 'Item19', title: '本次职业暴露发生原因分析', width: '180', align: 'center',sortable:true  },
      		{ field: 'Item20', title: '结论', width: '80', align: 'center',sortable:true  },
      		{ field: 'Item21', title: '结论日期', width: '80', align: 'center',sortable:true ,sorter:Sort_int },
     		{ field: 'Item22', title: '备注', width: '100', align: 'center',sortable:true  }
		]],
		
		rowStyler: function (index, row) {
        	if ((row.Item13=="阳性"&&(row.Item14=="阳性"||row.Item15=="阳性"||row.Item16=="阳性"))||(row.Item14=="阳性"&&(row.Item15=="阳性"||row.Item16=="阳性"))||(row.Item15=="阳性"&&row.Item16=="阳性")) {
				return 'background-color:#f9c3c3;';
        	}
        },
		onSelect:function(rowIndex,rowData){
			obj.rowIndex=rowIndex;
        },
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
            $(this).datagrid('columnMoving'); //列可以拖拽改变顺序
		}
    });
    ShowUserHabit('gridExpReg');
    //职业暴露操作明细
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
            aRepID: ""
        },
        columns: [[
			{ field: 'SubID', title: '报告ID', width: '80', align: 'center' },
			{ field: 'StatusDesc', title: '操作', width: '120', align: 'center' },
			{ field: 'UpdateDate', title: '操作日期', width: '120', align: 'center' },
            { field: 'UpdateTime', title: '操作时间', width: '120', align: 'center' },
            { field: 'UpdateUserDesc', title: '操作人', width: '120', align: 'center' }
        ]]
    });
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
    InitOccExpQryWinEvent(obj);
    obj.LoadEvent();
	return obj;
}