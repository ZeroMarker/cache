$(function () {
	LogonHospID=$.LOGON.HOSPID;
	LogonHospDesc=$.LOGON.HOSPDESC;
	LogonUserID=$.LOGON.USERID;
	LogonLocID=$.LOGON.LOCID;
	LogonLocDesc=$.LOGON.LOCDESC;
	//医院列表
	var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:$.LOGON.HOSPID
	},false);
	
	HospID = HospList.rows[0].ID;
	if (TypeCode==1) {
		ExpRegLoad();
	}
	if (TypeCode==2) {
		ExpRemindLoad();
	} 
	if (TypeCode==3) {
		EnviHyReportLoad();
	};
	if (TypeCode==4) {
		InfReportLoad();
	};
	if (TypeCode==5) {
		LabReportLoad();
	};
	if (TypeCode==31) {
		EnviHyMissLoad();
	};
	if (TypeCode==6) {
		AntUseLoad();
	};
	//关闭申请
	$('#closeA').on('click', function(){
		$HUI.dialog('#ApplyEdit').close();
	})
	
	//报告状态列表窗
	$('#winStatusList').dialog({
		title: '操作列表',
		iconCls:'icon-w-paper',
		closed: true,
		modal: true,
		isTopZindex:false
	});
});
// 申请、修改申请记录
$('#addA').on('click', function(){
	var ReCheckRepID="",IsReCheck="",ReportID=""
	var HospitalDr      = $("#cboAHospital").combobox('getValue');
	var MonitorLocDr    = $("#cboALoc").combobox('getValue');
	var MonitorDate   	= $("#AMonitorDate").datebox('getValue');
	var EvItemDr 		= $("#cboAEvItem").combobox('getValue');
	var EvObjectDr   	= $("#cboAEvObject").combobox('getValue');
	var EHItemObjTxt   	= $("#AEvObjectTxt").val();
	var CenterNum		= $("#txtCenterNum").val();
	var SurroundNum		= $("#txtSurroundNum").val();
	var ReferToNum		= $("#txtReferToNum").val();
	var SpecimenNum    	= parseInt(CenterNum)+parseInt(SurroundNum)+parseInt(ReferToNum);
	var IsObjNull		= $("#AEvIsObjNull").val();
	var ErrorStr = "";
	if (EvItemDr == '') {
		$.messager.alert("错误提示",'监测项目不允许为空！<br/>', 'info');
		return;
	}
	var InfEnviHyItem = $m({
		ClassName:"DHCHAI.IR.EnviHyItem",
		MethodName:"GetObjById",
		id:EvItemDr
		},false);
	var cm=JSON.parse(InfEnviHyItem); //eval('(' + InfEnviHyItem + ')');
	var EHSpecimenNum = cm.EHSpecimenNum;
	var IsObjNull=cm.EHIsObjNull;
	var EHIsSpecNum = cm.EHIsSpecNum;
	if (HospitalDr == '') {
		ErrorStr += '院区不允许为空！<br/>';	
	}
	if (MonitorLocDr == '') {
		ErrorStr += '监测科室不允许为空！<br/>';
	}
	if (MonitorDate == '') {
		ErrorStr += '监测日期不允许为空！<br/>';
	}
	if ((IsObjNull==0)&&(EvObjectDr == '')) {
		ErrorStr += '监测对象不允许为空！<br/>';
	}
	var EvObjectDesc = $("#cboAEvObject").combobox('getText');
	if ((EvObjectDesc=="手")&(EHItemObjTxt=="")){
		ErrorStr += '检测对象为手时，对象备注不允许为空！<br/>';
	}
	if (SpecimenNum == 0) {
		ErrorStr += '标本数量不允许为空！<br/>';
  
	}
	if (ErrorStr != '') {
		$.messager.alert("错误提示",ErrorStr, 'info');
		return;
	}
	var InfEnviHyItem = $m({
		ClassName:"DHCHAI.IR.EnviHyItem",
		MethodName:"GetObjById",
		id:EvItemDr
		},false);
	var cm=JSON.parse(InfEnviHyItem); //eval('(' + InfEnviHyItem + ')');
	var EHSpecimenNum = cm.EHSpecimenNum
	if ((EHIsSpecNum!="1")&&((parseInt(EHSpecimenNum))<parseInt(SpecimenNum))) {
		ErrorStr = ErrorStr + "参照点个数、中心个数、周边个数总数不允许大于标本个数!<br>";
	}
	var applyFlag  = $m({
		ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
		MethodName:"CheckIsApply",
		aLocDr:MonitorLocDr,
		aItemDr:EvItemDr,
		aDate:MonitorDate
	},false);
	if ((applyFlag=="1")&&(ReportID=="")){
		ErrorStr = ErrorStr + "科室申请的项目超过了本月申请次数!<br>";
	}
	var applyFlag= $m({
		ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
		MethodName:"CheckIsAllowApply",
		aLocDr:MonitorLocDr,
		aItemDr:EvItemDr,
		aDate:MonitorDate
	},false);
	if ((applyFlag!="1")&&(ReportID=="")){
		ErrorStr = ErrorStr + "科室申请的项目还不允许监测!<br>";
	}
	if (ErrorStr != '') {
		$.messager.alert("错误提示",ErrorStr, 'info');
		return;
	}
	
	var InputStr = ReportID;
	InputStr += "^" + EvItemDr;
	InputStr += "^" + EvObjectDr;
	InputStr += "^" + 1;
	InputStr += "^" + MonitorDate;
	InputStr += "^" + '';
	InputStr += "^" + '';
	InputStr += "^" + LogonLocID;
	InputStr += "^" + LogonUserID;
	InputStr += "^" + SpecimenNum;
	InputStr += "^" + CenterNum;
	InputStr += "^" + SurroundNum;
	InputStr += "^" + ''; 			//RepDate
	InputStr += "^" + ''; 			//RepTime
	InputStr += "^" + ''; 			//RepLocDr
	InputStr += "^" + ''; 			//RepUserDr
	InputStr += "^" + ''; 			//Standard
	InputStr += "^" + ''; 			//Resume
	InputStr += "^" + ''; 			//CollDate
	InputStr += "^" + ''; 			//CollTime
	InputStr += "^" + ''; 			//CollUserDr
	InputStr += "^" + ''; 			//RecDate
	InputStr += "^" + ''; 			//RecTime
	InputStr += "^" + ''; 			//RecUserDr
	InputStr += "^" + ''; 			//IsRstByItm
	InputStr += "^" + IsReCheck; 	//IsReCheck
	InputStr += "^" + ReCheckRepID; //ReCheckRepDr
	InputStr += "^" + EHItemObjTxt; //ItemObjTxt
	InputStr += "^" + MonitorLocDr; 			
	InputStr += "^" + ReferToNum; 			
	
	$m({
		ClassName:"DHCHAI.IR.EnviHyReport",
		MethodName:"Update",
		InStr:InputStr
	},function(retval){
		if (parseInt(retval)>0){
			// 环境卫生学监测检验标本 add by zhoubo 2020-12-04
			var retvalLog = $m({
				ClassName:"DHCHAI.IR.EnviHyReport",
				MethodName:"SaveLabBarcode",
				aReportID:retval
			});
			// 保存日志
			var LogStr = retval;
			LogStr = LogStr + '^' + LogonLocID;
			LogStr = LogStr + '^' + LogonUserID;
			LogStr = LogStr + '^' + 1;
			LogStr = LogStr + '^' + '';
			var retvalLog = $m({
				ClassName:"DHCHAI.IR.EnviHyReportLog",
				MethodName:"Update",
				aInput:LogStr
			});
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 2000});
			$HUI.dialog('#ApplyEdit').close();
			EnviHyMissLoad();
		} else {
			$.messager.alert("错误提示","保存失败:"+retval, 'info');
		}
	})
});
function ExpRegLoad(){	
	var TabDataGrid = $HUI.datagrid("#gridDetail",{
		fit: true,
		//title:'明细列表',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, 
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns :[[
			{field:'ID',title:'报告ID',width:60,align:'center'},
			{field:'RegLocDesc',title:'登记科室',width:150},
			{field:'RegTypeDesc',title:'登记类型'},
			{field:'StatusDesc',title:'状态',width:80,align:'center',
				formatter: function(value,row,index){
					var btn = '<a style="padding-left:5px;" href="#" onclick="ShowReport(\'' + row["RegTypeID"] + '\',\'' + row["ID"] + '\')">' + value + '</a>';
					return btn;
				}
			},
			{field:'link',title:'操作明细',width:90,align:'center',
				formatter: function(value,row,index){
					var btn = '<a style="padding-left:5px;" href="#" onclick="ShowOperation(\'' + row["ID"] + '\')">操作明细</a>';
					return btn;
				}
			},
			{ field: 'Name', title: '姓名', width: '100', align: 'center' },
            { field: 'RegNo', title: '工号', width: '100', align: 'center' },
            { field: 'Sex', title: '性别', width: '60', align: 'center' },
            { field: 'Age', title: '年龄', width: '60', align: 'center' },
            { field: 'TelPhone', title: '电话', width: '120', align: 'center' },
			{ field: 'ExpDate', title: '暴露日期', width: '100', align: 'center' },
			{ field: 'ExpLocDesc', title: '所在科室', width: '120', align: 'center' },
			
            { field: 'Item1', title: '工龄', width: '100', align: 'center' },
            { field: 'Item2', title: '工作类别', width: '100', align: 'center' },
            { field: 'Item3', title: '暴露地点', width: '100', align: 'center' },
            { field: 'Item4', title: '暴露程度', width: '100', align: 'center' },
            { field: 'Item5', title: '暴露部位', width: '100', align: 'center'  },
            { field: 'Item6', title: '暴露源(姓名)', width: '100', align: 'center'  },
            { field: 'Item7', title: '暴露源(HBV)', width: '100', align: 'center'  },
            { field: 'Item8', title: '暴露源(HCV)', width: '100', align: 'center'  },
            { field: 'Item9', title: '暴露源(HIV)', width: '100' , align: 'center' },
            { field: 'Item10', title: '暴露源(梅毒)', width: '100', align: 'center'  },
            { field: 'Item11', title: '结论', width: '120', align: 'center'  }
		]]
	});
	//提交
	var StatusDr = $m({
		ClassName:"DHCHAI.BT.Dictionary",
		MethodName:"GetIDByCode",		
		aTypeCode: "OERegStatus",
		aCode:1
	},false);
	//护士长签名
	var StatusDr =StatusDr+"|"+$m({
		ClassName:"DHCHAI.BT.Dictionary",
		MethodName:"GetIDByCode",		
		aTypeCode: "OERegStatus",
		aCode:6
	},false);
	//科主任签名
	var StatusDr =StatusDr+"|"+$m({
		ClassName:"DHCHAI.BT.Dictionary",
		MethodName:"GetIDByCode",		
		aTypeCode: "OERegStatus",
		aCode:7
	},false);
	var GridData =$cm({
		ClassName     : "DHCHAI.IRS.OccExpRegSrv",
		QueryName     : "QryOccExpReg",
		ResultSetType :"array",
		aHospIDs      : HospID,
		aRepType      : '',
		aDateType     : '1',
		aDateFrom     : '2016-01-01',   //使用一个较早的日期做查询开始日期
		aDateTo       : Common_GetDate(new Date()),
		aRegLoc       : '',
		aStatus       : StatusDr,
	    Pagerows:$("#gridDetail").datagrid("options").pageSize,
	    rows:999
	},false);
	
	$("#gridDetail").datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
}


function ExpRemindLoad(){	
	var TabDataGrid = $HUI.datagrid("#gridDetail",{
		fit: true,
		//title:'明细列表',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, 
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[	
			{field:'ID',title:'报告ID',width:60,align:'center'},
			{field:'Name',title:'姓名',width:100,align:'center'},
			{field:'Sex',title:'性别',width:60,align:'center'},
			{field:'TelPhone',title:'联系电话',width:120,align:'center'},
			{field:'RegNo',title:'工号',width:100,align:'center'},		
			{field:'WorkAge',title:'工龄',width:60,align:'center'},
			{field:'Duty',title:'职别',width:100,align:'center'},
			{field:'StatusDesc',title:'状态',width:100,align:'center',
				formatter: function(value,row,index){
					var btn = '<a style="padding-left:5px;" href="#" onclick="ShowReport(\'' + row["RegTypeID"] + '\',\'' + row["ID"] + '\')">' + value + '</a>';
					return btn;
				}
			},
			{field:'link',title:'操作',
				formatter: function(value,row,index){
				var btn = '<a style="padding-left:5px;" href="#" onclick="ShowRemind(\'' + row["ID"] + '\',\'' + row["LabTimList"] + '\')"><span class="icon icon-add-note">&nbsp;&nbsp;&nbsp;&nbsp</span>' + '提醒：'+row["RequireLsit"].replace(/#/g,'<br />') + '</a>';
					return btn;
				}
			},
			{field:'expander',title:'提醒明细',width:90,align:'center',
				formatter: function(value,row,index){
					var btn = '<a style="padding-left:5px;" href="#" onclick="ShowOperation(\'' + row["ID"] + '\',11)">提醒明细</a>';
					return btn;
				}
			},			
			{field:'RegUserDesc',title:'登记人',width:120},
			{field:'RegLocDesc',title:'登记科室',width:150},
			{field:'RegTypeDesc',title:'登记类型',width:120},
			{field:'ExpDate',title:'发生日期',width:100,sortable:true},
			{field:'ExpTime',title:'发生时间',width:80},
			{field:'RegDate',title:'登记日期',width:100,sortable:true},		
			{field:'RegTime',title:'登记时间',width:80}
		]],
		onLoadSuccess:function(data){
			//所有列进行合并操作
            //$(this).datagrid("autoMergeCells");
            //指定列进行合并操作
            $(this).datagrid("autoMergeCells", ['ID']);
		}
	});
	
	var GridData =$cm({
		ClassName     : "DHCHAI.IRS.OccExpRegSrv",
		QueryName     : "QryOccExpRemind",
		ResultSetType :"array",
		aHospIDs      : HospID,
		aRepType      : '',
		aDateType     : '1',
		aDateFrom     : Common_GetDate(new Date()),
		aDateTo       : Common_GetDate(new Date()),
		aRegLoc       : '',
	    Pagerows:$("#gridDetail").datagrid("options").pageSize,
	    rows:999
	},false);
	$("#gridDetail").datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
}


ShowReport = function(RepTypeID,ReportID){
	var url = 'dhcma.hai.ir.occexpreport.csp?1=1&RegTypeID='+RepTypeID+'&ReportID='+ReportID+"&AdminPower=1&2=2"
	websys_showModal({
		url:url,
		title:'职业暴露报告',
		iconCls:'icon-w-epr',  
		width:1320,
		height:'95%',
		onBeforeClose:function(){
			if (TypeCode==1) {
				ExpRegLoad();
			}
			if (TypeCode==2) {
				ExpRemindLoad();
			} 
		} 
	});
}

ShowRemind = function(ReportID,LabTimList){
	var StatusDr = $m({
		ClassName:"DHCHAI.BT.Dictionary",
		MethodName:"GetIDByCode",		
		aTypeCode: "OERegStatus",
		aCode:11
	},false);
	var Opinion  = '已提醒'+"#"+LabTimList;
	var InputRegLog = ReportID;
	InputRegLog = InputRegLog + "^" + '';
	InputRegLog = InputRegLog + "^" + StatusDr;		//状态
	InputRegLog = InputRegLog + "^" + Opinion;
	InputRegLog = InputRegLog + "^" + '';
	InputRegLog = InputRegLog + "^" + '';
	InputRegLog = InputRegLog + "^" + $.LOGON.USERID;
	
	var retval = $m({
		ClassName:"DHCHAI.IR.OccExpRegLog",
		MethodName:"Update",		
		aInputStr: InputRegLog,
		aSeparete:"^"
	},false);
	if(parseInt(retval)>0) {
		ExpRemindLoad();
		$.messager.popover({msg: '提醒成功！',type:'success',timeout: 2000});
	}else{
		$.messager.alert("提示", "提醒失败！", "info");
	}
}

ShowOperation = function(ReportID,Status){
	$HUI.datagrid('#RepStatusGrid',{
		fit:true,
		rownumbers:true,
		pagination:false,
		striped:true,
		singleSelect:true,
		fitColumns:false,
		url:$URL,
		queryParams:{
			ClassName:'DHCHAI.IRS.OccExpRegSrv',
			QueryName:'QryExpRepLog',
			aRepID:ReportID,
			aStatus:Status
		},
		columns:[[
			{ field:"SubID",title:"操作ID",width:60},
			{ field:"StatusDesc",title:"操作",width:80},
			{ field:"Opinion",title:"提醒项目"},
			{ field:"UpdateDate",title:"提醒日期",width:100},
			{ field:"UpdateTime",title:"提醒时间",width:80},
			{ field:"UpdateUserDesc",title:"提醒人",width:120}
		]]
	});
	$HUI.dialog('#winStatusList').open();
}


function EnviHyReportLoad(){	
    var TabDataGrid = $HUI.datagrid("#gridDetail",{
		fit: true,
		//title:'明细列表',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, 
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns :[[
			{field:'ReportID',title:'ID',align:'center',sortable:true},
			{field:"BarCode",title:"申请号",
				formatter:function(value,row,index){
					if (row.ReCheckSign == '1'){
						return '┏' + value+"&nbsp";
					} else if (row.ReCheckSign == '2'){
						return '┃' + value+"&nbsp";
					} else if (row.ReCheckSign == '3'){
						return '┗' + value+"&nbsp";
					} else {
						return value;
					}
				}
			},
			{field:'ItemObjDesc',title:'监测对象',sortable:true},
			{field:'StatusDesc',title:'&nbsp;&nbsp;状态',align:'left',sortable:true,
				formatter: function(value,row,index){
					var btn = '<a style="padding-left:5px;" href="#" onclick="ShowStatusLog(\'' + row["ReportID"] + '\')"><span class="icon icon-add-note">&nbsp;&nbsp;&nbsp;&nbsp</span>' + value + '</a>';
					return btn;
				}
			},
			{field:'MonitorDate',title:'监测日期',align:'center',sortable:true},
			{field:'MonitorLocDesc',title:'监测科室',sortable:true},
			{field:'SpecTypeDesc',title:'标本类型',align:'center',sortable:true},
			{field:'SpecimenNum',title:'标本数量',align:'center',sortable:true},
			{field:'StandardDesc',title:'是否合格',align:'center',sortable:true,
				styler: function(value,row,index){
					if (value=="不合格"){
						return 'background-color:#FF7256;';
					}else{
						return 'background-color:#AAAAAA;'
					}
				}
			},
			{field:'EnterTypeDesc',title:'录入方式',sortable:true},
			{field:'IsReCheck',title:'是否复检',sortable:true,
				formatter: function(value,row,index){
					return (value == 1 ? "是" : "否");
				}
			},
			{field:'ApplyDate',title:'申请日期',sortable:true},
			{field:'ApplyTime',title:'申请时间',sortable:true},
			{field:'ApplyLocDesc',title:'申请科室',sortable:true},
			{field:'ApplyUserDesc',title:'申请人',sortable:true},
			{field:'CollDate',title:'采集日期',sortable:true},
			{field:'CollTime',title:'采集时间',sortable:true},
			{field:'CollUserDesc',title:'采集人',sortable:true},
			{field:'RecDate',title:'接收日期',sortable:true},
			{field:'RecTime',title:'接收时间',sortable:true},
			{field:'RecUserDesc',title:'接收人',sortable:true},
			{field:'RepDate',title:'报告日期',sortable:true},
			{field:'RepTime',title:'报告时间',sortable:true},
			{field:'RepLocDesc',title:'报告科室',sortable:true},
			{field:'RepUserDesc',title:'报告人',sortable:true}
		]]
	});
	var GridData =$cm({
		ClassName     : "DHCHAI.IRS.EnviHyReportSrv",
		QueryName     : "QryReportByDate",
		ResultSetType :"array",
		aHospIDs      : HospID,
		aDateFrom     : Common_GetCalDate(-7),
		aDateTo       : Common_GetDate(new Date()),
		aMonitorLocDr : '',
		aItemDr       : '',  
		aStatusCode   : '',
		aStandardCode : 0,   
	    Pagerows:$("#gridDetail").datagrid("options").pageSize,
	    rows:999
	},false);
  
	$("#gridDetail").datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
}

function EnviHyMissLoad(){	
    var TabDataGrid = $HUI.datagrid("#gridDetail",{
		fit: true,
		//title:'明细列表',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, 
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		//是否是服务器对数据排序
		sortOrder:'asc',
		remoteSort:false,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		//remoteSort:false,
		columns :[[
			{field:'ID',title:'ID',align:'center',sortable:true,width:60},
			{field:'LocDesc',title:'监测科室',sortable:true,width:130},
			{field:'EHItemDesc',title:'监测项目',sortable:true,width:220},
			{field:'DateUnitDesc',title:'监测计划',sortable:true,width:120},
			{field:'EHItemMax',title:'计划监测数量',sortable:true,width:120,sorter:Sort_int},
			{field:'MonitSum',title:'已监测数量',sortable:true,width:120,sorter:Sort_int},
			{field:'NotMonitSum',title:'待监测数量',sortable:true,width:120,sorter:Sort_int},
			{ field:"LocID",title:"操作",width:100,align:'center',
				formatter:function(value,row,index){
					return '<a href="#"  onclick=CreatAplly(\''+row.LocID+'\',\''+row.EHItemDr+'\',\''+row.DateUnitDesc+'\')>'+"申请"+'</a>';
				}
			},
			{field:'MessageInfo',title:'提醒临床内容',sortable:true,width:220},
			
			{field:'EHActDate',title:'提醒临床日期',sortable:true,width:120},
			{field:'ToUser',title:'提醒临床医生',sortable:true,width:120}
		]]
	});
	var GridData =$cm({
		ClassName     : "DHCHAI.IRS.EnviHyLocItemsSrv",
		QueryName     : "QryLocMissItems",
		ResultSetType :"array",
		aDateFrom     : Common_GetDate(new Date()),
		aDateTo       : Common_GetDate(new Date()),
	    Pagerows:$("#gridDetail").datagrid("options").pageSize,
	    rows:999
	},false);
  
	$("#gridDetail").datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
}
CreatAplly = function(LocID,EHItemDr,DateUnitDesc){
	cboAHospital = Common_ComboToSSHosp("cboAHospital",$.LOGON.HOSPID);
	cboALoc = Common_ComboToLoc('cboALoc',$.LOGON.HOSPID);
	var AMonitorDate=Common_GetDate(new Date());
	$('#AMonitorDate').datebox('setValue',AMonitorDate);
	
	$HUI.combobox("#cboAEvItem",{
		url:$URL+'?ClassName=DHCHAI.IRS.EnviHyLocItemsSrv&QueryName=QryLocItems&ResultSetType=Array&aLocID='+LocID,
		valueField:'ID',
		textField:'ItemDesc',
		allowNull: true, 
		onSelect:function(row){
			var IsObjNull = row.IsObjNull;	//获取对象是否允许为空
			$('#AEvIsObjNull',IsObjNull);
			LoadEvObjectSpen(row.ID);
		},onChange:function(newvalue,oldvalue){
			LoadEvObjectSpen(newvalue);
		}
	});
	$HUI.combobox("#cboaddAEvObject",{
			url:$URL+'?ClassName=DHCHAI.IRS.EnviHyObjectSrv&QueryName=QryEvObjectByLoc&ResultSetType=Array&aLocDr='+LocID,
			valueField:'ID',
			textField:'ObjectDesc',
			allowNull: true
		});		
		// add by zhoubo	
		$HUI.combobox("#cboALoc",{
			onChange:function(newvalue,oldvalue){
				$HUI.combobox("#cboAEvItem",{
					url:$URL+'?ClassName=DHCHAI.IRS.EnviHyLocItemsSrv&QueryName=QryLocItems&ResultSetType=Array&aLocID='+LocID,
					valueField:'ID',
					textField:'ItemDesc',
					allowNull: true, 
					onSelect:function(row){
						var IsObjNull = row.IsObjNull;	//获取对象是否允许为空
						$('#AEvIsObjNull',IsObjNull);
						LoadEvObjectSpen(row.ID);
					},onChange:function(newvalue,oldvalue){
						LoadEvObjectSpen(newvalue);
					},onLoadSuccess:function(){
						//LoadEvObjectSpen();
					}
				});
				$HUI.combobox("#cboaddAEvObject",{
					url:$URL+'?ClassName=DHCHAI.IRS.EnviHyObjectSrv&QueryName=QryEvObjectByLoc&ResultSetType=Array&aLocDr='+$('#cboALoc').combobox('getValue'),
					valueField:'ID',
					textField:'ObjectDesc',
					allowNull: true
				});
			}
	});
	
	$('#cboALoc').combobox('setValue',LocID);
	$('#cboAEvItem').combobox('setValue',EHItemDr);
	//申请单编辑modal
	$('#ApplyEdit').dialog({
		title: '监测申请单',
		iconCls:"icon-w-paper",
		headerCls:'panel-header-gray',
		modal: true
	});
	$HUI.dialog('#ApplyEdit').open();
}
LoadEvObjectSpen = function(EvItemID){
	var EvObjectdata=$cm({
		ClassName:'DHCHAI.IRS.EnviHyItemSrv',
		QueryName:'QryEvObjsByItem',
		ResultSetType:'array',
		aParRef:EvItemID,
		aLocID:$('#cboALoc').combobox('getValue')	
	},false);

	$HUI.combobox("#cboAEvObject",{
		data:EvObjectdata,
		valueField:'ObjID',
		textField:'ObjDesc',
		editable:true,
		onLoadSuccess:function(data){
			//只有一条记录默认加载
			if (data.length==1) {
				$('#cboAEvObject').combobox('select',data[0]['ObjID']);
			}
		}
	});

	var SpenNum = $m({
		ClassName:'DHCHAI.IR.EnviHyItem',
		MethodName:'GetSpenNumById',
		Id:EvItemID
	},false)
	var SpenNumArr=SpenNum.split("^");
	var CenterNum=SpenNumArr[1];
	var SurroundNum=SpenNumArr[2];
	var ReferToNum=SpenNumArr[3];
	var EHIsSpecNum=SpenNumArr[4];
	$('#txtCenterNum').val(CenterNum);
	$('#txtSurroundNum').val(SurroundNum);
	$('#txtReferToNum').val(ReferToNum);	

	if (EHIsSpecNum==0) { //如果不允许调整标本数量，则禁用录入框
		websys_disable('txtCenterNum');
		websys_disable('txtSurroundNum');
		websys_disable('txtReferToNum');
	}					

}
	
	
	
ShowStatusLog = function(ReportID){
	$HUI.datagrid('#RepStatusGrid',{
		fit:true,
		rownumbers:true,
		pagination:false,
		striped:true,
		singleSelect:true,
		fitColumns:false,
		url:$URL,
		queryParams:{
			ClassName:'DHCHAI.IRS.EnviHyReportSrv',
			QueryName:'QryRepStatus',
			aReportID:ReportID
		},
		columns:[[
			{ field:"UpdateStatus",title:"状态",width:'100'},
			{ field:"UpdateLocDesc",title:"操作科室",width:'100'},
			{ field:"UpdateUser",title:"操作人",width:'120'},
			{ field:"UpdateDate",title:"操作日期",width:'100'},
			{ field:"UpdateTime",title:"操作时间",width:'80'},
			{ field:"BatchNumber",title:"批次号",width:'160'}
		]]
	});
	$HUI.dialog('#winStatusList').open();
}


function InfReportLoad(){	
	var TabDataGrid = $HUI.datagrid("#gridDetail",{
		fit: true,
		//title:'明细列表',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, 
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns :[[
	        { field:"PatMrNo",title:"病案号",width:100,align:'center'},
			{ field:"ReportID",title:"报告编号",width:70,align:'center',
				formatter:function(value,row,index){
					 return '<a href="#"  onclick=ShowResutlDtl(\''+row.ReportID+'\')>'+row.ReportID+'</a>';
				}
			},
			{ field:"PatName",title:"姓名",width:120,align:'center'},
			{ field:"PatSex",title:"性别",width:50,align:'center'},
			{ field:"PatAge",title:"年龄",width:70,align:'center'},
			{ field:"ReportStatusDesc",title:"报告状态",width:70,align:'center'},
			{ field:"ReportLocDesc",title:"报告科室",width:120,align:'center'},
			{ field:"ReportDate",title:"报告日期",width:100,align:'center'},
			{ field:"InfLocDesc",title:"感染科室",width:120,align:'center'},
			{ field:"IRInfDate",title:"感染日期",width:100,align:'center'},
			{ field:"InfPos",title:"感染诊断",width:220,align:'center',
				formatter: function (value,row,index) {
					var rs = row["ReportStatusDesc"];
					var InfPos = row["InfPos"];
					var DiasID = row["DiasID"];
					var InfPosArray = InfPos.split(",");
					var DiasIDArray = DiasID.split(",");
					var InfPosHtml = "";
					for (var i=0; i<InfPosArray.length; i++) {
						if ((rs == "审核")||(rs == "作废")||(rs == "删除")||(rs == "退回")) {
							InfPosHtml += InfPosArray[i];
							if (i !== InfPosArray.length-1) InfPosHtml += '<br>';
						} else {
							InfPosHtml += '<a href="#" onclick=OpenInfPosDialog(\''+row.EpisodeID+'\',\''+DiasIDArray[i]+'\',\''+row.AdmitDate+'\',\''+row.DischDate+'\')>'+InfPosArray[i]+'</a>';
							if (i !== InfPosArray.length-1) InfPosHtml += '<br>';
							}
						}
						return InfPosHtml;
					}
			},
			{ field:"ZY",title:"摘要",align:'center',width:70,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=OpenView(\''+row.EpisodeID+'\')>摘要</a>';
				}
			},
			{ field:"link",title:"电子病历",width:100,align:'center',
				formatter:function(value,row,index){
					 return '<a href="#" onclick=btnEmrRecord_Click(\''+row.EpisodeID+'\')>电子病历</a>';
				}
			},
			{ field:"expander",title:"沟通记录",width:100,align:'center',
				formatter:function(value,row,index){
					 return '<a href="#" onclick=btnMsgSend_Click(\''+row.PatName+'\',\''+row.EpisodeID+'\')>沟通记录</a>';
				}
			},
			{ field:"ReportUserDesc",title:"报告人",width:150,align:'center'},
			//{ field:"ReturnReason",title:"退回原因",width:100,align:'center'}
        ]]
	});
	
	var StatusDr = $m({
		ClassName:"DHCHAI.BT.Dictionary",
		MethodName:"GetIDByCode",		
		aTypeCode: "InfReportStatus",
		aCode:2
	},false);
	
	var GridData =$cm({
		ClassName:'DHCHAI.IRS.INFDiagnosSrv',
	    QueryName:'QryRepInfoByDateLoc',
	    aHospIDs: HospID,
	    aDateType:"1",
        aDateFrom:Common_GetCalDate(-Days),
        aDateTo:Common_GetDate(new Date()),
        aRepStatus:StatusDr,
        aRepType:'1|2',
	    Pagerows:$("#gridDetail").datagrid("options").pageSize,
	    rows:9999
	},false);
	
	$("#gridDetail").datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
}


//报告编号
function ShowResutlDtl(aReportID) {
	if (!aReportID) return;
	var url="./dhcma.hai.ir.inf.report.csp?1=1&ReportID="+aReportID+'&AdminPower=1'+"&2=2";
	websys_showModal({
		url:url,
		title:'医院感染报告',
		iconCls:'icon-w-epr',
		closable:false,
		width:1322,
		height:'95%',
		onBeforeClose:function(){
			InfReportLoad();
		}
	});
}


//感染诊断
function OpenInfPosDialog (aEpisodeID,aDiasID,aAdmitDate,aDischDate){		
	var strUrl = "../csp/dhcma.hai.ir.infdiagnos.csp?EpisodeID=" + aEpisodeID + "&DiagID=" + aDiasID +"&AdmitDate=" + aAdmitDate +"&DischDate=" + aDischDate;
	websys_showModal({
		url:strUrl,
		title:'感染诊断-编辑',
		iconCls:'icon-w-paper',  
		width:'1010',
		height:'560',
		onBeforeClose:function(){
			InfReportLoad();
		} 
	});
}
    
//摘要
function OpenView(EpisodeID) {	
	var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen';
    websys_showModal({
		url:url,
		title:'医院感染集成视图',
		iconCls:'icon-w-epr',
		closable:true,
		width:'95%',
		height:'95%'
	});
};
//电子病历
function btnEmrRecord_Click(EpisodeID) {		
	var rst = $m({
		ClassName:"DHCHAI.DPS.PAAdmSrv",
		MethodName:"GetPaAdmHISx",
		aEpisodeID:EpisodeID
	},false);
	if(rst=="")return;
	var EpisodeID = rst.split("^")[0];
	var PatientID = rst.split("^")[1];
	var url = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&DefaultOrderPriorType=ALL&2=2';	
	websys_showModal({
		url:url,
		title:'病历浏览',
		iconCls:'icon-w-epr',
		closable:true,
		width:'95%',
		height:'95%'
	});
};
//沟通记录
function btnMsgSend_Click(PatName,EpisodeID){		
	var url = "../csp/dhcma.hai.ir.ccmessage.csp?EpisodeDr=" + EpisodeID + "&PageType=layerOpen&MsgType=1";
	websys_showModal({
		url:url,
		title:"病人姓名： "+PatName,
		iconCls:'icon-w-epr',
		originWindow:window,
		width:800,
		height:500
	});
};


function LabReportLoad(){	
	var TabDataGrid = $HUI.datagrid("#gridDetail",{
		fit: true,
		//title:'明细列表',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, 
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns :[[
			{ field:"PapmiNo",title:"登记号",width:100,align:'center'},
	        { field:"MrNo",title:"病案号",width:100,align:'center'},
			{ field:"PatName",title:"姓名",width:100,align:'center'},
			{ field:"Sex",title:"性别",width:50,align:'center'},
			{ field:"Age",title:"年龄",width:80,align:'center'},
			{ field:"Specimen",title:"标本",width:100,align:'center'},
			{ field:"Bacteria",title:"病原体",width:150,align:'center'},
			{ field:"ActDate",title:"送检日期",width:100,align:'center'},
			{ field:"MRBDesc",title:"多耐标记",width:200,align:'center',showTip:true}, 
			{ field:"INFMBRID",title:"报告编号",width:100,align:'center',
				formatter:function(value,row,index){
					var txt = "新建";
					var ReportID = row["INFMBRID"];				 
					var EpisodeID=row["AdmID"];
					var LabRepID=row["LabRepID"];
					var LabResID =row["ResultID"];  //检验结果ID		
					if((ReportID!="")&&(ReportID!=undefined)){
						txt = ReportID;
					}
					return '<a href="#" onclick="OpenReport(\'' + ReportID + '\',\'' + EpisodeID + '\',\'' + LabRepID + '\',\'' + LabResID + '\')">'+txt+'</a>';
				}
			},
			{ field:"link",title:"发送消息",width:100,align:'center',
				formatter:function(value,row,index){				
				 	var AdmID 		= row["AdmID"];
				 	var ResultID 	= row["ID"];
				 	var MRBDesc 	= row["MRBDesc"];
				 	var Bacteria 	= row["Bacteria"];
				 	return '<a href="#" onclick="SendMessage(\'' + ResultID + '\',\'' + AdmID + '\',\'' + MRBDesc + '\',\'' + Bacteria + '\')">发送消息</a>';					
				}
			},
			{ field:"link1",title:"药敏结果",width:100,align:'center',
			formatter:function(value,row,index){
					 var ResultID=row["ResultID"];
					 
					return '<a href="#" onclick="OpenReslut(\'' + ResultID + '\')">药敏结果</a>';
				}
			},
			{ field:"link2",title:"摘要",width:80,align:'center',
				formatter:function(value,row,index){
					 var EpisodeID = row["AdmID"];
					 return '<a href="#" onclick="OpenView(\'' + EpisodeID + '\')">摘要</a>';
				}
			},	
			{ field:"RepDate",title:"检验报告日期",width:100,align:'center'},
			{ field:"LocDesc",title:"送检科室",width:120,align:'center'},
			{ field:"AdmDate",title:"入院日期",width:100,align:'center'},
			{ field:"DischDate",title:"出院日期",width:100,align:'center'}
		]]
	});
//加载药敏结果表格
	OpenReslut = function(ResultID){
	$HUI.datagrid('#gridIRDrugSen',{
		fit:true,
		rownumbers:true,
		pagination:false,
		striped:true,
		singleSelect:true,
		fitColumns:false,
		url:$URL,
		queryParams:{
			ClassName:'DHCHAI.IRS.CtlMRBSrv',
			QueryName:'QryResultSen',
			ResultSetType:"array",
			aResultID:ResultID,
			page:1,
			rows:200
		},
		 columns:[[
	        { field:"AntDesc",title:"抗生素",width:400,align:'center'},
			{ field:"Sensitivity",title:"药敏结果",width:320,
				formatter: function(value,row,index){
					if (row.IsInt==1) {
						return value +'<div style="display:inline;margin-left:3px;background-color:red;color:#fff;border-radius:3px;font-size:10px;padding:3px;width:20px;height:20px;font-weight: 600;">天</div>';
					}else {
						return value;
					}						
				}		
			}
		]],
	});
	$HUI.dialog('#winProEdit').open();
}

	var GridData =$cm({
		ClassName:"DHCHAI.STAS.WelcomeSrv",
		QueryName:"QryMRBResult",
		ResultSetType:"array",
		aHospIDs: $.LOGON.HOSPID,
		aDateType:'2',
	    Pagerows:$("#gridDetail").datagrid("options").pageSize,
	    rows:999
	},false);

	$("#gridDetail").datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
}


//打开多耐细菌报告链接
function OpenReport(ReportID,EpisodeID,LabRepID,LabResID) {
	var strUrl = './dhcma.hai.ir.mrb.ctlreport.csp?&ReportID='+ReportID+'&EpisodeID='+EpisodeID+'&LabRepID='+LabRepID+'&LabResID='+LabResID+'&1=1';
	websys_showModal({
		url:strUrl,
		title:'多耐细菌报告',
		iconCls:'icon-w-epr',  
        originWindow:window,
        closable:true,
		width:1320,
		height:'95%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
		onBeforeClose:function(){
			LabReportLoad();
		} 
	});
}
	
function SendMessage(ResultID,AdmID,MRBDesc,Bacteria) {
	var MsgType="MBRMsgCode";
	var Msg = "多耐分类:"+MRBDesc+",检出病原体:"+Bacteria
	var InputStr = AdmID +"^"+ MsgType +"^"+ $.LOGON.USERID + "^" + Msg+"^"+ResultID;
	var retval = $m ({
		ClassName:"DHCHAI.IRS.CtlMRBSrv",
		MethodName:"SendHISMRBMsg",
		ResultSetType:"array",
		aInputStr:InputStr
	})
	if(parseInt(retval)== '-1') {
        $.messager.alert("提示","发送消息的患者不存在！", 'info');
		return;
    }else if (parseInt(retval)== '-2') {
        $.messager.alert("提示","HIS多耐消息代码:MBRMsgCode未配置!", 'info');
		return;  
    }else if (parseInt(retval)== '-3') {
        $.messager.alert("提示","发送消息用户不存在!", 'info');
		return;   
    }else if(parseInt(retval)<1) {
       $.messager.alert("提示","发送消息失败！", 'info');
		return;    
    }
	$.messager.alert("提示","成功向临床医生发送消息！", 'info');
	return;
}


function AntUseLoad(){	
	var TabDataGrid = $HUI.datagrid("#gridDetail",{
		fit: true,
		showGroup: true,
		groupField:'EpisodeID',
		checkOnSelect:false,
		view: groupview,
		groupFormatter:function(value, rows){
			if(value==undefined) return;		
			return '病案号:'+rows[0].MrNo +'    登记号:'+rows[0].PapmiNo +'    姓名:'+ rows[0].PatName+'    性别:'+ rows[0].Sex +'    床位:'+ rows[0].CurrBed+"    "+'<a class="tabbtn" href="#" onclick="OpenView('+rows[0].EpisodeID+')">摘要</a>'+ '  , 共( ' + rows.length + ' )条抗菌药物记录';
		},
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, 
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns :[[
			
			{ field:"OrdDesc",title:"医嘱名称",width:320},	
			{ field:"SttDate",title:"开始时间",width:160,align:'center',
				formatter: function (value,row,index) {
					return row.SttDate + ' ' + row.OrdTime;
				}
			},
			{ field:"EndDate",title:"停止时间",width:160,align:'center',
				formatter: function (value,row,index) {
					return row.EndDate + ' ' + row.EndTime;
				}
			},
			{ field:"Generic",title:"通用名",width:200},
			{ field:"AntUsePurpose",title:"用药目的",width:100,align:'center'},
			//{ field:"OEFreqDesc",title:"频次",width:100,align:'center'},
			//{ field:"OEInstruc",title:"用法",width:100,align:'center'},
			//{ field:"OEDoseQty",title:"用量",width:100,align:'center'},
			{ field:"Priority",title:"医嘱类型",width:80,align:'center'},
			{ field:"OrdDate",title:"开医嘱时间",width:160,align:'center',
				formatter: function (value,row,index) {
					return row.OrdDate + ' ' + row.SttTime;
				}
			},
			{ field:"OrdLoc",title:"开医嘱科室",width:140},
			{ field:"DocName",title:"开医嘱医生",width:90}
        ]]
	});
	
	
	var GridData =$cm({
		ClassName:'DHCHAI.DPS.OEOrdItemSrv',
	    QueryName:'QryAntOverDaysInfo',
	    aDays: Days,
	    aDate:'',
	    rows:9999
	},false);
	
	$("#gridDetail").datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
}
