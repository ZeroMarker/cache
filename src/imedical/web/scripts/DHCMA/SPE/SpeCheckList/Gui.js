//页面Gui
var objScreen = new Object();
function InitSpeCheckListWin(){
	 var obj = objScreen;	
	
     $.parser.parse(); // 解析整个页面 
     
    //初始查询条件
    obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp",SSHospCode,"SPE");
    //医院科室联动
	$HUI.combobox('#cboSSHosp',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboLoc = Common_ComboToLoc("cboLoc","E","","",HospID);
	    }
    });
    obj.DateFrom = $('#DateFrom').datebox('setValue', Common_GetDate(new Date()));    // 日期初始赋值
	obj.DateTo = $('#DateTo').datebox('setValue', Common_GetDate(new Date()));
	obj.cboQryStatus = Common_ComboToDicCode("cboQryStatus","SPECheckStatus","^","");
	obj.cboPatType = $HUI.combobox('#cboPatType', {
		url: $URL,
		editable: true,
		//multiple:true,  //多选
		//mode: 'remote',
		valueField: 'PTSID',
		textField: 'PTSDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMed.SPEService.PatTypeSub';
			param.QueryName = 'QryAllPatTypeSub';
			param.ResultSetType = 'array';
		}
	});
  
   obj.gridSpeCheckList =$HUI.datagrid("#SpeCheckList",{
	    fit: true,
		title:'特殊患者审核',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper-stamp',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMed.SPEService.PatientsQry",
			QueryName:"QrySpeCheckList",		
			aQryStatus: $('#cboQryStatus').combobox('getValue'),
			aOperTpCode: OperTpCode,
			aHospID: $('#cboSSHosp').combobox('getValue'), 
			aDateFrom: $('#DateFrom').datebox('getValue'), 
			aDateTo: $('#DateTo').datebox('getValue'), 
			aPatType: $('#cboPatType').combobox('getValue'), 
			aLocID: $('#cboLoc').combobox('getValue'), 
			aRegNo:$('#txtRegNo').val(),
			aPatName:$('#txtPatName').val()
	    },
		columns:[[
			{field:'RegNo',title:'登记号',width:'100'},
			{field:'PatName',title:'患者姓名',width:'80'},
			{field:'Sex',title:'性别',width:'50'},
			{field:'PatientAge',title:'年龄',width:'50'},
			{field:'AdmDate',title:'入院日期',width:'100'},
			{field:'PatTypeDesc',title:'患者类型',width:'120',align:'center',
				formatter: function(value,row,index){
					if (value=="") return "";
					var SpeID = row["SpeID"];
					var EpisodeID =row["EpisodeID"];
					var strRet = "";
					var strRet = '<a ref="#" style="white-space:normal; color:blue" onclick="objScreen.DisplaySpeCheckWin(\'' + SpeID + '\',\'' + EpisodeID + '\')">'+value+'</a>';
					return strRet;
				}
			}, 
			{field:'StatusDesc',title:'状态',width:'50'},
			{field:'ReadStatus',title:'消息',width:'80',align:'center',
				formatter: function(value,row,index){
					if (value=="") return "";
					var SpeID = row["SpeID"];
					var EpisodeID =row["EpisodeID"];
					var strRet = "";
					var strRet = '<a ref="#" style="white-space:normal; color:blue" onclick="objScreen.OpenSpeNewsWin(\'' + SpeID + '\',\'' + EpisodeID + '\')">'+value+'</a>';
					return strRet;
				}			
			}, 
			{field:'Note',title:'情况说明',width:'150'},
			{field:'MarkDate',title:'标记日期',width:'100'},
			{field:'CheckOpinion',title:'审核意见',width:'150'},
			{field:'CheckDate',title:'审核日期',width:'80'},
			{field:'DutyDeptDesc',title:'责任科室',width:'120'},
			{field:'LocDesc',title:'就诊科室',width:'120'},
			{field:'WardDesc',title:'病区',width:'120'},
			{field:'Bed',title:'床号',width:'60'},
			{field:'DoctorName',title:'医生',width:'80'},
			{field:'EpisodeID',title:'就诊号',width:'50'}		
		]]
	});

	InitSpeCheckListWinEvent(obj);
	obj.LoadEvent(arguments);	
	return obj;
}


