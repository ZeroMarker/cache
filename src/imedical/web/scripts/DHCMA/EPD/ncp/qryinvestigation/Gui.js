//页面Gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;		
  
    //初始查询条件
    obj.cboHospital = Common_ComboToSSHosp("cboHospital",SSHospCode,"EPD");
	//医院科室联动
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboReportLoc = Common_ComboToLoc("cboReportLoc","E|EM","","",HospID);
	    }
    });
    obj.dtStaDate = $('#dtStaDate').datebox('setValue', Common_GetCalDate(-30));// 日期初始赋值
    obj.dtEndDate = $('#dtEndDate').datebox('setValue', Common_GetDate(new Date()));
	
	$('#cboDateType').combobox({      
		valueField:'Code',    
		textField:'Desc',
		data : [ {
			Code:'IndexReportDate', 
			Desc:'报告日期',
			"selected":true   
		},{
			Code:'IndexCheckDate', 
			Desc:'审核日期'
		}]
	});  
	
   obj.gridInvQuery = $HUI.datagrid("#InvQuery",{
		fit: true,
		title:'新冠肺炎个案调查表查询',
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		//singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'expander',title:'操作',width:45,align:'center',
				formatter: function(value,row,index){
					var ReportID = row["ReportID"];
					var EpisodeID = row["EpisodeID"];					
					var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenNCPReport(\'' + ReportID + '\',\'' + EpisodeID + '\')"></a>';
					return btn;
				}
			}, 
			{field:'CardNo',title:'报告编号',width:120},
			{field:'StatusDesc',title:'报告状态',width:80,
				 styler: function(value,row,index){
					var retStr = "", tmpStatusCode = row["StatusCode"];
					if (tmpStatusCode==1) {
						retStr =  'color:red;';
					} else if (tmpStatusCode==2) {
						retStr = 'color:green;';
					}else if (tmpStatusCode==3) {
						retStr = 'color:black;';
					} else if (tmpStatusCode==4) {
						retStr = 'color:blue;';
					} else if (tmpStatusCode==5) {
						retStr = 'color:gray;';
					} else {
						retStr = 'color:black;';
					} 
					return retStr;
				}
			}, 
			{field:'PapmiNo',title:'登记号',width:100},
			{field:'PatientName',title:'姓名',width:80},
			{field:'PatientSex',title:'性别',width:50},
			{field:'PatientAge',title:'年龄',width:50},
			{field:'Identity',title:'身份证号',width:180},
			{field:'SeverityDesc',title:'临床严重程度',width:100},
			{field:'DiagDegreeDesc',title:'病例分类',width:100},
			{field:'RepNo',title:'关联传染病编号',width:130},
			{field:'SickDate',title:'发病日期',width:100},
			{field:'SymPtomList',title:'症状体征',width:200},
			{field:'ComplicationList',title:'并发症',width:200},
			{field:'PreAnamnesisList',title:'既往病史',width:200},
			{field:'IsIsolatedDesc',title:'是否隔离',width:80},
			{field:'IsolatedDate',title:'隔离日期',width:100},
			{field:'IsInHospDesc',title:'是否入院',width:80},
			{field:'InHospDate',title:'入院日期',width:100},
			{field:'IsInICUDesc',title:'是否入住ICU',width:100},
			{field:'InICUDate',title:'入住ICU日期',width:100},
			{field:'OccupationDesc',title:'患者职业',width:150},
			{field:'GatherDesc',title:'是否有聚集性发病',width:130},
			{field:'TravelLiveDesc',title:'武汉旅居史',width:100},
			{field:'IsContactFeverDesc',title:'是否接触过发热病人',width:140},
			{field:'IsContactDiagDesc',title:'是否确诊接触史',width:120},
			{field:'ReportDate',title:'报告日期',width:100},
			{field:'ReportTime',title:'报告时间',width:80}	
		]],
		onDblClickRow:function(index, row) {
			if (index>-1) {				
				obj.gridReport_rowdbclick(row);
			}
		},onLoadSuccess:function(data){
			//加载成功
			dispalyEasyUILoad(); //隐藏效果
		}
	});

	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


