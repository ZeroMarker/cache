$(function(){
	//当前为护士登录时,只能选择"本科室病人" add by niucaicai 2016-10-14
	if (CTLOCType == "W")
	{
		$('#currentUserRadio').attr('disabled',true);
		$('#currentGroupRadio').attr('disabled',true);
		$('#currentLocRadio').attr('checked',true);
		defaultRadio = "currentLoc";
	}
	InitWardCombo();
	InitInPatientList();
});
//Desc: 初始化病区下拉框
function InitWardCombo()
{
	$('#wardcombo').combobox({
		width:245,
		url:'../EMRservice.Ajax.getLinkLocByLocID.cls?LocID=' + locID,    
		valueField:'LocID',    
		textField:'LocDesc',
		onSelect:function() {
			GetData();
		}
	});
}
//Desc:病人列表信息
function InitInPatientList()
{
	if (HasPatEncryptLevel == "Y")
	{
		$('#patientListData').datagrid({ 
			width:'100%',
			height:106, 
			pageSize:20,
			pageList:[10,20,30,50,80,100], 
			fitColumns: true,
			loadMsg:'数据装载中......',
			autoRowHeight: true,
			url:'../EMRservice.Ajax.patientInfo.cls?action=GetPatientList&PatListType=InPat&RadioValue=' + defaultRadio,
			singleSelect:true,
			idField:'EpisodeID', 
			rownumbers:true,
			pagination:true,
			fit:true,
			remoteSort:false,
			sortName:"PAAdmBedNO",
			columns:[[  
				{field:'PatientID',title:'PatientID',width:80,hidden: true},
				{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
				{field:'mradm',title:'mradm',width:80,hidden: true},
				{field:'SecAlias',title:'病人密级',width:80,sortable:true},
				{field:'EmployeeFunction',title:'病人级别',width:80,sortable:true},
				{field:'PAAdmBedNO',title:'床号',width:60,sortable:true},
				{field:'PAAdmWard',title:'病区',width:150,sortable:true},
				{field:'PAPMINO',title:'登记号',width:85,sortable:true},
				{field:'PAPMISex',title:'性别',width:40,sortable:true},
				{field:'PAPMIAge',title:'年龄',width:40,sortable:true},
				{field:'PAPMIName',title:'姓名',width:65,sortable:true},
				{field:'PAAdmDate',title:'就诊日期',width:80,sortable:true},
				{field:'PAAdmTime',title:'就诊时间',width:90,sortable:true},
				{field:'MedicareNo',title:'病案号',width:70,sortable:true},
				{field:'InTimes',title:'入院次数',width:65,sortable:true},
				{field:'ResidentDays',title:'住院天数',width:65,sortable:true},
				{field:'PAAdmDocCodeDR',title:'主管医师',width:65,sortable:true},
				{field:'HeadUniteDoc',title:'带组医师',width:65,sortable:true},
				{field:'ChiefDoc',title:'主任医师',width:65,sortable:true},
				{field:'Diagnosis',title:'诊断',width:150,sortable:true},
				{field:'PAAdmReason',title:'病人类型',width:80,sortable:true}
			]],
			onDblClickRow: function() {
				var seleRow = $('#patientListData').datagrid('getSelected');
				if (seleRow){
					doSwitch(seleRow.PatientID,seleRow.EpisodeID,seleRow.mradm); 
				}
			}
		});
	}
	else
	{
		$('#patientListData').datagrid({ 
			width:'100%',
			height:106, 
			pageSize:20,
			pageList:[10,20,30,50,80,100], 
			fitColumns: true,
			loadMsg:'数据装载中......',
			autoRowHeight: true,
			url:'../EMRservice.Ajax.patientInfo.cls?action=GetPatientList&PatListType=InPat&RadioValue=' + defaultRadio, 
			singleSelect:true,
			idField:'EpisodeID', 
			rownumbers:true,
			pagination:true,
			fit:true,
			remoteSort:false,
			sortName:"PAAdmBedNO",
			columns:[[  
				{field:'PatientID',title:'PatientID',width:80,hidden: true},
				{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
				{field:'mradm',title:'mradm',width:80,hidden: true},
				{field:'PAAdmBedNO',title:'床号',width:70,sortable:true},
				{field:'PAAdmWard',title:'病区',width:260,sortable:true},
				{field:'PAPMINO',title:'登记号',width:90,sortable:true},
				{field:'PAPMIName',title:'姓名',width:80,sortable:true},
				{field:'PAPMISex',title:'性别',width:55,sortable:true},
				{field:'PAPMIAge',title:'年龄',width:55,sortable:true},
				{field:'PAAdmDate',title:'就诊日期',width:90,sortable:true},
				{field:'PAAdmTime',title:'就诊时间',width:90,sortable:true},
				{field:'MedicareNo',title:'病案号',width:70,sortable:true},
				{field:'InTimes',title:'入院次数',width:80,sortable:true},
				{field:'ResidentDays',title:'住院天数',width:70,sortable:true},
				{field:'PAAdmDocCodeDR',title:'主管医师',width:80,sortable:true},
				{field:'HeadUniteDoc',title:'带组医师',width:80,sortable:true},
				{field:'ChiefDoc',title:'主任医师',width:75,sortable:true},
				{field:'Diagnosis',title:'诊断',width:110,sortable:true}
			]],
			onDblClickRow: function() {
			var seleRow = $('#patientListData').datagrid('getSelected');
				if (seleRow){
					doSwitch(seleRow.PatientID,seleRow.EpisodeID,seleRow.mradm); 
				}
			}
		});
	}
 }

//查询按钮点击事件
$("#PatientListQuery").click(function () {
	GetData();
});

//切换按钮
function radioCheck()
{
	GetData();
}

//查询数据
function GetData()
{
	var medicareNo = $("#medicareNo").val();
	var patientName = $("#patientName").val();
	var WardID = $('#wardcombo').combobox('getValue');
	var WardText = $('#wardcombo').combobox('getText');
	if (WardText == "" || WardText == "undefinded")
	{
		WardID = "all";
	}
	if ($('#currentUserRadio').attr('checked') == "checked")
	{
		var RadioValue = $('#currentUserRadio').attr('value');
	}
	if ($('#currentGroupRadio').attr('checked') == "checked")
	{
		var RadioValue = $('#currentGroupRadio').attr('value');
	}
	if ($('#currentLocRadio').attr('checked') == "checked")
	{
		var RadioValue = $('#currentLocRadio').attr('value');
	}
	$('#patientListData').datagrid('load', {
		action: "GetPatientList",
		PatListType: "InPat",
   	 	RadioValue: RadioValue,
   	 	WardID: WardID,
   	 	MedicareNo: medicareNo,
    		PatientName: patientName
	});
}

//Desc:切换患者
function doSwitch(PatientID,EpisodeID,mradm) {
	parent.doSwitch(PatientID,EpisodeID,mradm);
}

//新增回车补全病案号方法 add by niucaicai 2016-10-17
$('#medicareNo').bind('keypress', function(event) {
	if (event.keyCode == "13") {
		setMedicareNoLength();
	}
});

///Desc:设置病案号长度  add by niucaicai 2016-10-17
function setMedicareNoLength(){
	var medicareNo = $("#medicareNo").val();
	if (medicareNo != '') 
	{
		if (medicareNo.length < 6) 
		{
			for (var i=(6-medicareNo.length-1); i>=0; i--)
			{
				medicareNo ="0"+ medicareNo;
			}
		}
	}
	if (HospitalName == 'BJTHFCYY')  //北京太和妇产医院,病案号格式为 FC0000001
	{
		medicareNo ="FC"+ medicareNo;
	}
	$("#medicareNo").val(medicareNo);
}
