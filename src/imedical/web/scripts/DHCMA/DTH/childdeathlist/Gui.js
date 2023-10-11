//页面Gui
var objScreen = new Object();
function InitChildDeathList(){
	var obj = objScreen;		
    
    $.parser.parse(); // 解析整个页面  
    
    //初始查询条件
    obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp",SSHospCode,"DTH");
	//医院科室联动
	$HUI.combobox('#cboSSHosp',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","E|EM","","",HospID);
	    }
    });
     var nowDate = new Date();
     nowDate.setMonth(nowDate.getMonth()-1);
    obj.txtStartDate = $('#txtStartDate').datebox('setValue', Common_GetDate(nowDate));// 日期初始赋值
    obj.txtEndDate = $('#txtEndDate').datebox('setValue', Common_GetDate(new Date()));
	//报告状态
	obj.cboRepStatus = Common_ComboToDic("cboRepStatus","DTHRunningState","1");
	var DicInfo = $m({                   
		ClassName:"DHCMed.SSService.DictionarySrv",
		MethodName:"GetDicByDesc",
		argType:"DTHRunningState",
		argDesc:"待审",
		argIsActive:"1"
	},false);
	$("#cboRepStatus").combobox('setValue',DicInfo.split("^")[0])
	$("#cboRepStatus").combobox('setText',DicInfo.split("^")[2])
	//日期类型
	$('#cboDateType').combobox({      
		valueField:'Code',    
		textField:'Desc',
		data : [ {
			Code:'1', 
			Desc:'报告日期',
			"selected":true   
		},{
			Code:'2', 
			Desc:'死亡日期'
		}]
	});  
    
	obj.GetExamConditions = function(){
		var txtRegNo=$('#txtRegNo').val();
		var MrNo=$('#txtMrNo').val();
		var txtPatName=$('#txtPatName').val();
		var ExamConds=""
		if (txtRegNo){
			if (ExamConds!='') ExamConds += "^"
			ExamConds += "RegNo=" + txtRegNo;
		}
		if (MrNo){
			if (ExamConds!='') ExamConds += "^"
			ExamConds += "MrNo=" + MrNo;
		}
		if (txtPatName){
			if (ExamConds!='') ExamConds += "^"
			ExamConds += "PatName=" + txtPatName;
		}
		return ExamConds;
	}

    obj.gridChildDeathReport = $HUI.datagrid("#gridChildDeath",{
		fit: true,
		title:'儿童死亡报告查询',
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'ReportID',title:'操作',width:45,align:'center',
				formatter: function(value,row,index){
					if (value=="") return "";
					var ReportID = row["ReportID"];
					var EpisodeID = row["Paadm"];
					if ((typeof HISUIStyleCode != 'undefined') && (HISUIStyleCode=="lite")) {
						var btn = '<a href="#" class="icon icon-paper" onclick="objScreen.OpenDeathReport(\'' + EpisodeID + '\',\'' + ReportID + '\')"></a>';
					} else {
						var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenDeathReport(\'' + EpisodeID + '\',\'' + ReportID + '\')"></a>';
					}
					return btn;
				}
			}, 
			{field:'RegNo',title:'登记号',width:'100'},
			{field:'MrNo',title:'病案号',width:'100'},
			{field:'PatientName',title:'姓名',width:'120'},
			{field:'Sex',title:'性别',width:'50'},
			{field:'Age',title:'年龄',width:'50'},
			{field:'AdmType',title:'就诊类型',width:'100'},
			{field:'DecDate',title:'死亡日期',width:'100'},
			{field:'DecTime',title:'死亡时间',width:'80'},	
			{field:'RepStatus',title:'报告状态',width:'120'},
			{field:'ChRepDate',title:'报告日期',width:'100'},
			{field:'ChRepTime',title:'报告时间',width:'80'},
			{field:'ChRepUser',title:'报告人',width:'120'},
			{field:'ChRepLoc',title:'报告科室',width:'120'},				
			{field:'AdmitDate',title:'入院日期',width:'100'},
			{field:'DisDate',title:'出院日期',width:'100'},
			{field:'DoctorName',title:'主管医生',width:'120'},
			{field:'Department',title:'科室',width:'120'},
			{field:'Ward',title:'病区',width:'150'}
		]],
		onDblClickRow:function(index, row) {
			if (index>-1) {
				obj.gridChildDeathReport_click(row);
			}
		}
	});

	InitChildDeathListEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


