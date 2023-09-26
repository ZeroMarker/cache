$(function(){
	//当前为护士登录时,只能选择"本科室病人" add by niucaicai 2016-10-14
	if (CTLOCType == "W")
	{
		$('#currentUserRadio').attr('disabled',true);
		$('#currentGroupRadio').attr('disabled',true);
		$('#currentLocRadio').attr('checked',true);
		defaultRadio = "currentLoc";
	}
	InitDoctorName();
	InitOutPatientList();
	$('#seekform').find(':radio').change(function () {
		if (this.id == "currentUserRadio")
		{
			$('#userName').combobox('select',userCode);
			$('#userName').combobox('disable');
		}
		else
		{
			$('#userName').combobox('enable');
			//默认选中"全部医师"选项 add by niucaicai 2016-10-14
			$('#userName').combobox('setValue',"");
		}
	});
});
//初始化主管医师
function InitDoctorName()
{
	$('#userName').combobox({
		url:'../EMRservice.Ajax.patientInfo.cls?action=GetUserName',  
	    valueField:'UserCode',  
	    textField:'UserDesc',
	    onLoadSuccess:function(d){
	    	var data=eval(d);
	    	if ($('#currentUserRadio').attr('checked') == "checked"){
		    	$.each(data,function(idx,val){
					//若当前选中本人病人，则默认值为登录用户名，且主管医师下拉框不可选
					if (val.UserCode == userCode){
						$('#userName').combobox('select',userCode);
						$('#userName').combobox('disable');
						return
					}
				});
	    	}
	    }
    });
}
//Desc:病人列表信息
function InitOutPatientList()
{
	if (HasPatEncryptLevel == "Y")
	{
		$('#patientListData').datagrid({ 
			width:'100%',
			height:106, 
			pageSize:10,
			pageList:[10,20,30], 
			fitColumns: true,
			loadMsg:'数据装载中......',
			autoRowHeight: true,
			url:'../EMRservice.Ajax.patientInfo.cls?action=GetPatientList&PatListType=OutPat&RadioValue=' + defaultRadio + '&DateGap=6', 
			singleSelect:true,
			idField:'EpisodeID', 
			rownumbers:true,
			pagination:true,
			fit:true,
			remoteSort:false,
			columns:[[  
				{field:'PatientID',title:'PatientID',width:80,hidden: true},
				{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
				{field:'mradm',title:'mradm',width:80,hidden: true},
				{field:'SecAlias',title:'病人密级',width:80,sortable:true},
				{field:'EmployeeFunction',title:'病人级别',width:80,sortable:true},
				{field:'PAAdmDischgeDate',title:'出院日期',width:80,sortable:true},
				{field:'PAAdmDischgeTime',title:'出院时间',width:80,sortable:true},
				{field:'PAAdmBedNO',title:'出院床号',width:80,sortable:true},
				{field:'DisDiagnosDesc',title:'出院诊断',width:80,sortable:true},
				{field:'PAPMINO',title:'登记号',width:80,sortable:true},
				{field:'PAPMIName',title:'姓名',width:80,sortable:true},  
				{field:'PAPMISex',title:'性别',width:80,sortable:true},
				{field:'PAPMIAge',title:'年龄',width:80,sortable:true},
				{field:'PAPMIDOB',title:'出生日期',width:40,sortable:true},
				{field:'MedicareNo',title:'病案号',width:80,sortable:true},
				{field:'InTimes',title:'住院次数',width:80,sortable:true},
				{field:'OutDays',title:'出院天数',width:80,sortable:true},
				{field:'PAAdmDocCodeDR',title:'主管医师',width:80,sortable:true},
				{field:'HomepageURL',title:'病案首页',width:80},
				{field:'IsRecordCompleted',title:'是否提交',width:80},
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
			pageSize:10,
			pageList:[10,20,30], 
			fitColumns: true,
			loadMsg:'数据装载中......',
			autoRowHeight: true,
			url:'../EMRservice.Ajax.patientInfo.cls?action=GetPatientList&PatListType=OutPat&RadioValue=' + defaultRadio + '&DateGap=6', 
			singleSelect:true,
			idField:'EpisodeID', 
			rownumbers:true,
			pagination:true,
			fit:true,
			remoteSort:false,
			columns:[[  
				{field:'PatientID',title:'PatientID',width:80,hidden: true},
				{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
				{field:'mradm',title:'mradm',width:80,hidden: true},
				{field:'PAAdmDischgeDate',title:'出院日期',width:80,sortable:true},
				{field:'PAAdmDischgeTime',title:'出院时间',width:80,sortable:true},
				{field:'PAAdmBedNO',title:'出院床号',width:80,sortable:true},
				{field:'DisDiagnosDesc',title:'出院诊断',width:80,sortable:true},
				{field:'PAPMINO',title:'登记号',width:80,sortable:true},
				{field:'PAPMIName',title:'姓名',width:80,sortable:true},  
				{field:'PAPMISex',title:'性别',width:80,sortable:true},
				{field:'PAPMIAge',title:'年龄',width:80,sortable:true},
				{field:'PAPMIDOB',title:'出生日期',width:40,sortable:true},
				{field:'MedicareNo',title:'病案号',width:80,sortable:true},
				{field:'InTimes',title:'住院次数',width:80,sortable:true},
				{field:'OutDays',title:'出院天数',width:80,sortable:true},
				{field:'PAAdmDocCodeDR',title:'主管医师',width:80,sortable:true},
				{field:'HomepageURL',title:'病案首页',width:80},
				{field:'IsRecordCompleted',title:'是否提交',width:80},
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


//查询数据
function GetData()
{
	var patientNo = $("#patientNo").val();
	var medicareNo = $("#medicareNo").val();
	var patientName = $("#patientName").val();
	var userNameCode = $("#userName").combobox('getValue');
	//IE11中，利用下拉框中的“叉号”去掉下拉框内容时，实际上下拉框的值没有去掉，所以查询时需要手动根据下拉框的文本内容判断一下下拉框的值是否应该为空
	var userNameText = $('#userName').combobox('getText');
	if (userNameText == "" || userNameText == "undefinded")
	{
		userNameCode = "";
	}
	//获取日期间隔
	if ($('#DateGap1Radio').attr('checked') == "checked")
	{
		var DateGap = $('#DateGap1Radio').attr('value');
	}
	else if ($('#DateGap3Radio').attr('checked') == "checked")
	{
		var DateGap = $('#DateGap3Radio').attr('value');
	}
	else if ($('#DateGap7Radio').attr('checked') == "checked")
	{
		var DateGap = $('#DateGap7Radio').attr('value');
	}
	else if ($('#DateGap30Radio').attr('checked') == "checked")
	{
		var DateGap = $('#DateGap30Radio').attr('value');
	}
	else if ($('#DateGap60Radio').attr('checked') == "checked")
	{
		var DateGap = $('#DateGap60Radio').attr('value');
	}
	else if ($('#DateGap90Radio').attr('checked') == "checked")
	{
		var DateGap = $('#DateGap90Radio').attr('value');
	}
	//获取病人范围
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
		PatListType: "OutPat",
   	 	RadioValue: RadioValue,
		DateGap: DateGap,
    	PatientNo: patientNo,
    	MedicareNo: medicareNo,
    	PatientName: patientName,
    	UserCode: userNameCode
	});
}

//浏览相应的病历
function BrowserRecord(id,pluginType,chartItemType,emrDocId)
{
	//alert(id);
	//alert(pluginType);
	//alert(chartItemType);
	//alert(emrDocId);
	window.open("emr.record.browse.browsform.editor.csp?id="+id+"&pluginType="+pluginType+"&chartItemType="+chartItemType+"&emrDocId="+emrDocId,"");
}

//Desc:切换患者
function doSwitch(PatientID,EpisodeID,mradm) {
	parent.doSwitch(PatientID,EpisodeID,mradm);
}

$("#patientNo").blur( function () { 
 	  setPatientNoLength();
} );

///Desc:设置患者号长度
function setPatientNoLength(){
	var pateinetNo = $("#patientNo").val();
	if (pateinetNo != '') 
	{
		if (pateinetNo.length < PatientNoLength) 
		{
			for (var i=(PatientNoLength-pateinetNo.length-1); i>=0; i--)
			{
				pateinetNo ="0"+ pateinetNo;
			}
		}
	}
	$("#patientNo").val(pateinetNo);
}