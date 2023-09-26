var objScreen = new Object();
function InitViewport(){
	var obj = objScreen;
	$.parser.parse();
	
	//初始查询条件
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp",SSHospCode,"EPD");  
	obj.txtFromDate = $('#txtFromDate').datebox("setValue",Common_GetDate(new Date())); // 日期初始赋值
	obj.txtToDate = $('#txtToDate').datebox("setValue",Common_GetDate(new Date()));
	//报告状态
	obj.chkStatusList = Common_CheckboxToDic("chkRepStatus","EPDReferralStatus",3);
	
	obj.gridTili=$HUI.datagrid("#gridTili",{
		fit:true,
		title:"肺结核转诊单查询",
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination:true, 			//分页工具栏
		rownumbers:true,            // 行号
		singleSelect:false,
		autoRowHeight:false,        //行高是否自动扩展
		loadMsg:"数据加载中...",
		pageSize:20,
		pageList:[10,20,50,100],
		columns:[[
			{title:'操作',width:45,field:'expander',align:'center',
				formatter: function(value,row,index){
					var ReportID = row["ReportID"];
					var EpisodeID = row["EpisodeID"];
					var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenReport(\'' + ReportID + '\',\'' + EpisodeID + '\')"></a>';
					return btn;
				}
			}, 
			{field:'EpisodeID',title:'就诊号',width:100},
			{field:'PatMrNo',title:'住院号',width:100,sortable:true},
			{field:'PatName',title:'患者姓名',width:80}, 
			{field:'PatSex',title:'性别',width:40},
			{field:'PatAge',title:'年龄',width:80},
			{field:'PatPhoneNo',title:'患者电话',width:150},  
			{field:'PatAddress',title:'现住址',width:300},
			{field:'FamilyName',title:'家属姓名',width:80},
			{field:'WorkAddress',title:'工作单位',width:100},
			{field:'ReferralReason',title:'转诊原因',width:150},
			{field:'ReferralHosp',title:'转诊单位',width:100},
			{field:'ReferralDoc',title:'转诊医生',width:80},
			{field:'ReferralDate',title:'转诊日期',width:100},
			{field:'ReferralAdd',title:'转诊地址',width:150},
			{field:'ReferralPhone',title:'转诊电话',width:150},
			{field:'RepStatusDesc',title:'报告状态',width:80},
			{field:'ReportUser',title:'报告人',width:100},
			{field:'ReportDate',title:'报告日期',width:100},
			{field:'ReportTime',title:'报告时间',width:80}
		]],onLoadSuccess:function(data){
			//加载成功
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	
	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
	return obj;

}

	