var objScreen = new Object();
function InitViewport(){
	var obj = objScreen;
	$.parser.parse();
	
	//初始查询条件
    obj.cboHospital = Common_ComboToSSHosp("cboHospital",SSHospCode,"EPD");
	//医院科室联动
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","E","","",HospID);
	    }
    });
	obj.txtFromDate = $('#txtFromDate').datebox("setValue",Common_GetDate(new Date())); // 日期初始赋值
	obj.txtToDate = $('#txtToDate').datebox("setValue",Common_GetDate(new Date()));
	//报告状态
	obj.chkStatusList = Common_CheckboxToDic("chkRepStatus","ERReportStatus",3);
	obj.gridTili=$HUI.datagrid("#gridTili",{
		fit:true,
		title:"流感样病例查询",
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
			{field:'RegNo',title:'登记号',width:100},
			{field:'MrNo',title:'住院号',width:100},
			{field:'PatName',title:'患者姓名',width:80}, 		
			{field:'PatSex',title:'性别',width:40},
			{field:'PatAge',title:'年龄',width:80},
			{field:'SpecType',title:'标本类型',width:240},
			{field:'SpecClnArea',title:'标本采集地',width:200},
			{field:'SpecSource',title:'标本来源',width:240},
			{field:'Incident',title:'暴发事件名称',width:200},
			{field:'RepStatusDesc',title:'报告状态',width:80},
			{field:'DoctorName',title:'就诊医生',width:120},
			{field:'AdmLocDesc',title:'就诊科室',width:120},
			{field:'SickDate',title:'发病日期',width:100},
			{field:'AdmitDate',title:'就诊日期',width:100},
			{field:'CheckUser',title:'审核人',width:80},
			{field:'CheckDate',title:'审核日期',width:120},
			{field:'Hospital',title:'医院',width:180}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridTili_rowdblclick(rowData);
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

	