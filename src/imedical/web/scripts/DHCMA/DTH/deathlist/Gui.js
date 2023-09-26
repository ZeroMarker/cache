//页面Gui
var objScreen = new Object();
function InitPatientAdm(){
	var obj = objScreen;		 
    $.parser.parse(); // 解析整个页面  
    
    //初始查询条件
    obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp",SSHospCode,"DTH");
	//医院科室联动
	$HUI.combobox('#cboSSHosp',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","","","",HospID);
	    }
    });
    
    obj.txtDateFrom = $('#txtDateFrom').datebox('setValue', Common_GetDate(new Date()));// 日期初始赋值
    obj.txtDateTo = $('#txtDateTo').datebox('setValue', Common_GetDate(new Date()));
    
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

    obj.gridDeathPatient = $HUI.datagrid("#gridDeathPatient",{
		fit: true,
		title:'死亡患者查询',
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMed.DTHService.ReportSrv",
			QueryName:"QryDeathPatients",
			argDateFrom: $('#txtDateFrom').datebox('getValue'), 
			argDateTo: $('#txtDateTo').datebox('getValue'), 
			arglocId: $('#cboRepLoc').combobox('getValue'),
			hospId:$('#cboSSHosp').combobox('getValue'),   
			argExamConts: obj.GetExamConditions(),
			argExamSepeare: "^"
	    },
		columns:[[
			{field:'ReportID',title:'报告',width:'45',
				formatter: function(value,row,index){
					var PatientID=row["PatientID"];
					var Paadm=row["Paadm"];
					var LocID=row["RepLocID"];
					if (LocID=="") {
						LocID=session['LOGON.CTLOCID'];
					}
					var ReportID = row["ReportID"];
					if (value) {
						var strRet = '<a href="#" class="btn_detail" onclick="objScreen.OpenDeathReport(\'' + ReportID + '\',\'' + Paadm + '\',\'' + LocID + '\')"></a>';
					} else {
						var strRet = '<a href="#" class="btn_add" onclick="objScreen.OpenDeathReport(\'' + ReportID + '\',\'' + Paadm + '\',\'' + LocID + '\')"></a>';
					}
					return strRet;
				}
			},		
			{field:'RegNo',title:'登记号',width:'100'},
			{field:'MrNo',title:'病案号',width:'100'},
			{field:'PatientName',title:'姓名',width:'120'},
			{field:'Sex',title:'性别',width:'50'},
			{field:'Age',title:'年龄',width:'50'},
			{field:'EncryptLevel',title:'密级',width:'80',hidden:(IsSecret==1 ? true:'')},
			{field:'PatLevel',title:'级别',width:'80',hidden:(IsSecret==1 ? true:'')}, 
			{field:'DecDate',title:'死亡日期',width:'100'},
			{field:'DecTime',title:'死亡时间',width:'80'},	
			{field:'DecStatus',title:'状态',width:'100'},
			{field:'AdmitDate',title:'入院日期',width:'100'},
			{field:'DisDate',title:'出院日期',width:'100'},
			{field:'DoctorName',title:'主管医生',width:'120'},
			{field:'Department',title:'科室',width:'120'},
			{field:'Ward',title:'病区',width:'150'}
		]],
		onDblClickRow:function(index, row) {
			if (index>-1) {
				obj.gridDeathPatient_click(row);
			}
		}
	});

	InitPatientAdmEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


