//手术切口调查查询->Gui
var objScreen = new Object();
function InitINFOPSQryWin() {
    var obj = objScreen;
    
    var cboEvItemFLList = $cm ({
			ClassName:"DHCHAI.BTS.DictionarySrv",
			QueryName:"QryDic",
			aTypeCode:"OperSurvStatus"
			},false);
	obj.EvItemFL = cboEvItemFLList.rows;
	$HUI.combobox("#cboSurvStatus",{
			valueField:'DicDesc',
			textField:'DicDesc',
			allowNull: true,
			editable:true,
			data:obj.EvItemFL,
			onSelect:function(rec){
				
			},onLoadSuccess:function(data){

			}
		});
    //初始化医院
    obj.cboHospital = Common_ComboToSSHosp("cboHospital", $.LOGON.HOSPID);
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
			Date_QuickSelect("cboYear","cboMonth","dtDateFrom","dtDateTo");	//更改开始-结束日期
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
			Date_QuickSelect("cboYear","cboMonth","dtDateFrom","dtDateTo");	//更改开始-结束日期
		}
	});
	var NowDate=month_formatter(new Date());
	var NowYear=NowDate.split("-")[0];	//当前年
	var NowMonth=NowDate.split("-")[1]	//当前月
	$('#cboYear').combobox('select',NowYear);
	$('#cboMonth').combobox('select',NowMonth);
    //初始化手术科室 
    obj.RefreshOPRLoc = function (aHospID) {
    	var cbox = $HUI.combobox("#cboLoction", {
	    	url: $URL,
	       	editable: true,
	        allowNull: true,
	        defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
	        valueField: 'ID',
	        textField: 'LocDesc',
	        onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
	        	param.ClassName = 'DHCHAI.IRS.CRuleOperSrv';
	         	param.QueryName = 'QryOperLocList';
	         	param.aHospIDs = $('#cboHospital').combobox('getValue');		//院区
	         	param.ResultSetType = 'array';
	   		}
	   	});
    }
   	//默认日期类型
    $HUI.combobox("#cboDateType",{
		data:[
			{value:'1',text:'手术日期'},
			{value:'2',text:'填报日期',selected:true},
			{value:'3',text:'回访日期'},
			{value:'4',text:'入院日期'},
			{value:'5',text:'出院日期'}
		],
		valueField:'value',
		textField:'text'
	})
    //切口等级
    obj.cboIncision = Common_ComboDicID('cboIncision', 'CuteType');
    //手术类型
    obj.cboOperType = Common_ComboDicID('cboOperType', 'HAIOperType');
    //手术部位
    obj.cboInfPos=$HUI.combobox("#cboInfPos", {
    	url: $URL,
     	editable: true,
      	allowNull: true,
     	defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
      	valueField: 'ID',
     	textField: 'Desc',
    	onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
    		param.ClassName = 'DHCHAI.BTS.InfPosSrv';
    		param.QueryName = 'QryInfPosByCode';   //手术部位
    		param.aPosCode='07';
     		/*
     			//感染诊断/部位
     			param.QueryName = 'QryInfPos';
       			param.aPosFlg = "s#2";

		],
		valueField:'value',
		textField:'text'
       		*/
       		param.ResultSetType = 'array';
 		}
	});
	//愈合等级
    //obj.cboHealStat = Common_CheckboxToDic("cboHealStat", "CuteHealing");
    $HUI.combobox("#cboHealStat",{
		url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&aTypeCode=CuteHealing&ResultSetType=Array&aIsActive=1',
		allowNull: true,       //再次点击取消选中
		editable: true,
		multiple:true,        //全选/取消全选
		rowStyle:'checkbox',  //显示成勾选行形式
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField:'DicDesc',
		textField:'DicDesc'
	});
    // 回访结果
    obj.cboVisitResult=Common_ComboDicID('cboVisitRst', 'VisitResult');
   
    //手术调查报告列表(后台加载)
    obj.gridINFOPSQry = $HUI.datagrid("#gridINFOPSQry", {
		fit:true,
		title: "手术切口调查查询",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		//singleSelect: true,
		nowrap: false,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		loadMsg:'数据加载中...',
		loading:true,
		//是否是服务器对数据排序
		sortOrder:'asc',
		remoteSort:false,
		pageSize: 50,
		pageList : [50,100,200,1000,10000],
		columns:[[
			{field:'checkOrd',checkbox:'true',width:30,auto:false},
			{ field: 'RepStatus', title: '报告状态', width: 100,sortable:true,
			    formatter: function (value, row, index) {
			        if (value=="保存") {
			            return "<div style='padding:0px;background-color:#f8fff3;margin:0 -10px 0 -10px;padding:8px 0 8px 10px;'> <a href='#' style='white-space:normal;color:#229A06' onclick='objScreen.OpenReport(\"" + index + "\");'>" + value + "</a></div>";
			        }else if (value=="提交"){
			            return "<div style='padding:0px;background-color:#E9ffe3;margin:0 -10px 0 -10px;padding:8px 0 8px 10px;'> <a href='#' style='white-space:normal; color:#58cf00' onclick='objScreen.OpenReport(\"" + index + "\");'>" + value + "</a></div>";
                    }else if (value=="审核"){
			            return "<div style='padding:0px;background-color:#ffeddf;margin:0 -10px 0 -10px;padding:8px 0 8px 10px;'> <a href='#' style='white-space:normal; color:#ffa200' onclick='objScreen.OpenReport(\"" + index + "\");'>" + value + "</a></div>";
                    }else{
	                	return "<div style='padding:0px;background-color:#dffcff;margin:0 -10px 0 -10px;padding:8px 0 8px 10px;'> <a href='#' style='white-space:normal; color:#00d5ee' onclick='objScreen.OpenReport(\"" + index + "\");'>新建</a>";
	                }
			    }
			},
			{ field: 'MrNo', title: '病案号', width: 100,sortable:true,sorter:Sort_int},
			{ field: 'PapmiNo', title: '登记号', width: 100,sortable:true,sorter:Sort_int},
			{ field: 'PatName', title: '姓名', width: 100,sortable:true},
			{ field: 'Sex', title: '性别', width: 60,sortable:true},
			{ field:"PAAdmDoc",title:"主管医生",width:90,sortable:true},
            { field: 'Age', title: '年龄', width: 80,sortable:true,sorter:Sort_int},
            { field: 'OperName', title: '手术名称', width: 200,sortable:true},
            { field: 'HealDesc', title: '愈合情况', width: 80,sortable:true},
			{ field: 'OperCatLists', title: '分类', width: 200,showTip:true,sortable:true},
            { field: 'OperDate', title: '手术开始时间',width:150,align: 'center',sortable:true,sorter:Sort_int,
				formatter: function(value,row,index){
					return row.OperDate+" "+row.SttTime;	
				}
			},
            { field: 'EndDate', title:'手术结束时间',width:150,align: 'center',sortable:true,sorter:Sort_int,
				formatter: function(value,row,index){
					return row.EndDate+" "+row.EndTime;	
				}
			},
			{ field: 'OperHour', title: '手术时长(h)', width: 90,sortable:true,sorter:Sort_int},
            { field: 'OperLocDesc', title: '手术病区', width: 160,sortable:true},
            { field: 'AdmBed', title: '床号', width: 60,sortable:true,sorter:Sort_int},
            { field: 'AdmDate', title: '入院日期', width: 100,sortable:true,sorter:Sort_int},
            { field: 'DischDate', title: '出院日期', width: 100,sortable:true,sorter:Sort_int},
            { field: 'RepUser', title: '填报人', width: 100,sortable:true},
            { field: 'RepDate', title: '填报日期', width: 100,sortable:true,sorter:Sort_int},
            { field: 'VisitName', title: '回访人', width: 100,sortable:true},
            { field: 'IRPatTem', title: '患者联系电话', width: 140,sortable:true},     
            { field: 'VistDate', title: '回访日期', width: 100,sortable:true,sorter:Sort_int},
            { field: 'VisitRstDesc', title: '回访结果', width: 100,sortable:true},
            { field: 'VisitResume', title: '回访备注', width: 180,sortable:true}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#gridINFOPSQry").datagrid('clearChecked');
			$("#btnCheck").linkbutton("disable");
			//$("#btnCancle").linkbutton("disable");
		},
		onSelect: function (rowIndex, rowData) {
			var rows = $("#gridINFOPSQry").datagrid('getChecked');
			var len = rows.length;
			if (len==1) {
				$("#btnCheck").linkbutton("enable");
				//$("#btnCancle").linkbutton("enable");
			}				
		},
		onCheck: function (rowIndex, rowData) {
			var rows = $("#gridINFOPSQry").datagrid('getChecked');
			var len = rows.length;
			if (len==1) {
				$("#btnCheck").linkbutton("enable");
				//$("#btnCancle").linkbutton("enable");
			}				
		},
		onCheckAll: function (rows) {
			$("#btnCheck").linkbutton("enable");
			//$("#btnCancle").linkbutton("enable");					
		},
		onSelectAll: function (rows) {
			$("#btnCheck").linkbutton("enable");
			//$("#btnCancle").linkbutton("enable");					
		},
		onUnselect: function (rowIndex, rowData) {
			var rows = $("#gridINFOPSQry").datagrid('getChecked');
			var len = rows.length;
			if (len==0) {
				$("#btnCheck").linkbutton("disable");
				//$("#btnCancle").linkbutton("disable");
			}				
		},
		onUncheck: function (rowIndex, rowData) {
			var rows = $("#gridINFOPSQry").datagrid('getChecked');
			var len = rows.length;
			if (len==0) {
				$("#btnCheck").linkbutton("disable");
				//$("#btnCancle").linkbutton("disable");
			}				
		},
		onUncheckAll: function (rows) {
			$("#btnCheck").linkbutton("disable");
									
		},		
		onUnselectAll: function (rows) {
			$("#btnCheck").linkbutton("disable");
			//$("#btnCancle").linkbutton("disable");							
		}	
    });

	$HUI.combobox("#cboOperCat",{
		url:$URL+'?ClassName=DHCHAI.IRS.CRuleOperCatSrv&QueryName=QryCRuleOperCat&ResultSetType=Array&aIsActive=1',
		allowNull: true,       //再次点击取消选中
		editable: true,
		multiple:true,        //全选/取消全选
		rowStyle:'checkbox',  //显示成勾选行形式
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField:'ID',
		textField:'OperCat'
	});
    InitINFOPSQryWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
