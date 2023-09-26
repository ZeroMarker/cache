$(function(){
	$('#chkLoc')[0].status = false;
	InitPatientList();
	InitCTLoc();
});

//Desc:初始化科室
function InitCTLoc()
{
	$('#cbxLoc').combobox({  
	    url:'../EMRservice.Ajax.hisData.cls?Action=GetCTLocList',  
	    valueField:'Id',  
	    textField:'Text',
	    onChange: function (n,o) {
			$('#cbxLoc').combobox('setValue',n);
		    var newText = $('#cbxLoc').combobox('getText');
			$('#cbxLoc').combobox('reload','../EMRservice.Ajax.hisData.cls?Action=GetCTLocList&LocContain='+encodeURI(newText.toUpperCase()));
		},
		onShowPanel: function(){
			var newText = $('#cbxLoc').combobox('getText');
			if (newText == "" || newText == "undefinded")
			{
				$('#cbxLoc').combobox('setValue',"");
			}
			$('#cbxLoc').combobox('reload','../EMRservice.Ajax.hisData.cls?Action=GetCTLocList&LocContain='+encodeURI(newText.toUpperCase()));
		},
	    onSelect: function(record){
	    	InitDoctorName(record.Id);
	    },
	    onLoadSuccess:function(d){
	    	var data=eval(d);
	    	$.each(data,function(idx,val){
		    	//默认值为登录科室
		    	if (val.Id == locID){
			    	$('#cbxLoc').combobox('select',locID);
			    	return;
			    }
			});
		}
	}); 
}

//Desc:初始化医生
function InitDoctorName(cbxlocID)
{
	$('#cbxUser').combobox({
		url:'../EMRservice.Ajax.patientInfo.cls?action=GetUserName&cbxLocID='+cbxlocID,  
	    valueField:'UserCode',  
	    textField:'UserDesc',
	    onLoadSuccess:function(d){
	    	var data=eval(d);
	    	$.each(data,function(idx,val){
		    	//默认值为登录医师
		    	if (val.UserCode == userCode){
			    	$('#cbxUser').combobox('select',userCode);
			    	return;
			    }
			});
		}
    });
}

//Desc:病人列表信息
function InitPatientList()
{
	$('#patientListData').datagrid({ 
    width:'100%',
    height:106, 
    pageSize:10,
    pageList:[10,20,30], 
    fitColumns: true,
    loadMsg:'数据装载中......',
    autoRowHeight: true,
    url:'../EMRservice.Ajax.patientInfo.cls?action=GetAdmList', 
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
		{field:'PAADMBedNO',title:'床号',width:80,sortable:true},
        {field:'PAPMINO',title:'登记号',width:80,sortable:true},
        {field:'MedicareNo',title:'住院号',width:80,sortable:true}, 
        {field:'PAPMIName',title:'姓名',width:80},  
        {field:'PAAdmType',title:'就诊类型',width:80},
        {field:'PAAdmDate',title:'就诊日期',width:80,sortable:true},
        {field:'PAAdmTime',title:'就诊时间',width:80,sortable:true},
        {field:'PADischgeDate',title:'出院日期',width:80,sortable:true},
        {field:'PAPMISex',title:'性别',width:80},
        {field:'PAAdmDepCodeDR',title:'就诊科室',width:80},
        {field:'PAAdmDocCodeDR',title:'医生',width:80}, 
        {field:'PAAdmWard',title:'病房',width:80,sortable:true}, 
        {field:'PAAdmReason',title:'付费方式',width:80},
        {field:'Diagnosis',title:'诊断',width:80},
        {field:'PADischgeTime',title:'出院时间',width:80}
    ]],
  onDblClickRow: function() {
	  var seleRow = $('#patientListData').datagrid('getSelected');
	  if (seleRow){
		  parent.doSwitch(seleRow.PatientID,seleRow.EpisodeID,seleRow.mradm); 
	  }} 
  }); 
}
///Desc:根据条件查询数据
function GetData()
{
	 var patientNo = $("#patientNo").val();
	 var medicareNo = $("#medicareNo").val();
	 var medicalInsuranceNo = $("#medicalInsuranceNo").val();
	 var cfCardNo =  $("#cFCardNo").val();
	 var idCardNo = $("#IDCardNo").val();
     var patientName = $("#patientName").val();
	 var admType = $('#cboAdmType').combobox('getValue');
	 var admStatus = $('#cboAdmStatus').combobox('getValue');
	 var startDate = $('#startDate').datebox('getText');
	 var endDate = $('#endDate').datebox('getText');
	 var outStartDate = $('#outStartDate').datebox('getText');
	 var outEndDate = $('#outEndDate').datebox('getText');
	 var expectedLocId = $('#cbxLoc').combobox('getValue');
	 var expectedUserCode = $("#cbxUser").combobox('getValue');
	 var chkArrivedQue = $('#chkLoc')[0].status;
	 var MRN = $("#MRN").val();
	 
	 //IE11中，利用下拉框中的“叉号”去掉下拉框内容时，实际上下拉框的值没有去掉，所以查询时需要手动根据下拉框的文本内容判断一下下拉框的值是否应该为空；
	 var expectedLocText = $('#cbxLoc').combobox('getText');
	 if (expectedLocText == "" || expectedLocText == "undefinded")
	 {
		 expectedLocId = "";
	 }
	 
	 var expectedUserText = $('#cbxUser').combobox('getText');
	 if (expectedUserText == "" || expectedUserText == "undefinded")
	 {
		 expectedUserCode = "";
	 }

	 if (chkArrivedQue)
	 {
		var isArrivedQue = "on";
		expectedLocId = ""
     }
     else
     {
	    var isArrivedQue = "off";
	 }
	 
	if (patientNo=="" && medicareNo=="" && patientName=="" && medicalInsuranceNo=="" && cFCardNo=="" && IDCardNo=="" && admType=="" && startDate=="" && endDate=="" && locId=="" && isArrivedQue=="off" && MRN=="")
	{
		alert("不能只查询全部就诊记录");
		return;
	}
	
	$('#patientListData').datagrid('load', {  
   	 	PatientNo: patientNo,  
    	MedicareNo: medicareNo,
    	MedicalInsuranceNo: medicalInsuranceNo,
    	CFCardNo: cfCardNo,
    	IDCardNo: idCardNo,
    	PatientName: patientName,
    	AdmType: admType,
    	AdmStatus: admStatus,
    	StartDate: startDate,
    	EndDate: endDate,
		OutStartDate: outStartDate,
    	OutEndDate: outEndDate,
    	IsArrivedQue: isArrivedQue,
    	ExpectedLocID: expectedLocId,
    	ExpectedUserCode: expectedUserCode,
		MRN: MRN
	}); 
}
$("#PatientListQuery").click(function () {
    GetData();
});

///Desc:本科患者
$("#chkLoc").change(function() {
      if ($('#chkLoc')[0].checked)
      {
	      $("#cbxLoc").combobox('disable');
	      InitDoctorName(locID);
	  }
	  else
	  {
		  $("#cbxLoc").combobox('enable');
	  }
});
//回车补全登记号不管用
/*
$("#patientNo").blur( function () { 
 	  setPatientNoLength();
} );
*/
//新增回车补全登记号方法
$('#patientNo').bind('keypress', function(event) {
	if (event.keyCode == "13") {
		setPatientNoLength();
	}
});
//新增回车补全病案号方法 add by niucaicai 2016-10-17
$('#medicareNo').bind('keypress', function(event) {
	if (event.keyCode == "13") {
		setMedicareNoLength();
	}
});

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
