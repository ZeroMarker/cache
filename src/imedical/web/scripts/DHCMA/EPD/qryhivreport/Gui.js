var objScreen = new Object();
function InitViewport(){
	var obj = objScreen;
	$.parser.parse();
	
	//初始查询条件
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp",SSHospCode,"EPD");  
	obj.txtFromDate = $('#txtFromDate').datebox("setValue",Common_GetDate(new Date())); // 日期初始赋值
	obj.txtToDate = $('#txtToDate').datebox("setValue",Common_GetDate(new Date()));
	//报告状态
	obj.chkStatusList = Common_CheckboxToDic("chkRepStatus","EPDFollowStatus");
	
	obj.gridTHIV = $HUI.datagrid("#gridTHIV",{
		fit:true,
		title:"HIV个案随访表查询",
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
					if (value=="") return "";
					var ReportID = row["ReportID"];
					var EpisodeID = row["EpisodeID"];
					var PatientID = row["PatientID"];
					if ((typeof HISUIStyleCode != 'undefined') && (HISUIStyleCode=="lite")) {
						var btn = '<a href="#" class="icon icon-paper" onclick="objScreen.OpenReport(\'' + ReportID + '\',\'' + EpisodeID + '\',\'' + PatientID + '\')"></a>';
					} else {
						var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenReport(\'' + ReportID + '\',\'' + EpisodeID + '\',\'' + PatientID + '\')"></a>';
					}
					return btn;
				}
			}, 
			{field:'EpisodeID',title:'就诊号',width:100}, 
			{field:'PatientID',title:'患者号',width:100},
			{field:'PatientName',title:'患者姓名',width:80}, 
			{field:'PatientSex',title:'性别',width:60},
			{field:'Birthday',title:'出生年月日',width:120},
			{field:'FollowStaDesc',title:'随访状态',width:100},
			{field:'FollowTimes',title:'随访次数',width:80},
			{field:'SurveyOrgan',title:'随访单位',width:150},
			{field:'SurveyName',title:'随访人',width:100},
			{field:'SurveyDate',title:'随访日期',width:120},
			{field:'Comments',title:'备注',width:100}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridTHIV_rowdblclick(rowData);
			}
		},onLoadSuccess:function(data){
			//加载成功
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	
	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
	return obj;

}

	