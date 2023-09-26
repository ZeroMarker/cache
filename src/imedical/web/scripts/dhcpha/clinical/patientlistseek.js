$(function(){
	$('#chkLoc')[0].status = false;
	InitPatientList();
	InitCTLoc();
	$("#tr").css("display","none")
});

//Desc:初始化科室
function InitCTLoc()
{
	$('#cbxLoc').combobox({  
	    url:'../EMRservice.Ajax.hisData.cls?Action=GetCTLocList',  
	    valueField:'Id',  
	    textField:'Text',
	    //支持大小写字母查询科室
	    filter: function (q, row){
	    	var opts = $(this).combobox('options');
	    	return row[opts.textField].toLowerCase().indexOf(q.toLowerCase()) == 0;
	    }
	}); 
}

//Desc:病人列表信息
function InitPatientList()
{
	$('#patientListData').datagrid({ 
    width:'100%',
    height:106, 
    pageSize:30,
    pageList:[30,60], 
    fitColumns: true,
    loadMsg:'数据装载中......',
    autoRowHeight: true,
    url:'../web.DHCCM.EMRservice.Ajax.PatientInfo.cls?action=GetAdmList', 
    singleSelect:true,
    idField:'EpisodeID', 
    rownumbers:true,
    pagination:true,
    fit:true,
	remoteSort:false,
    columns:[[  
    	{field:'PAAdmDepCodeDR',title:'病区',width:120},
    	{field:'PAADMBedNO',title:'床号',width:50},
    	{field:'PAPMINO',title:'登记号',width:80,styler:function(){return 'color:blue'}},
    	{field:'PAPMIName',title:'姓名',width:80}, 
    	{field:'PAPMISex',title:'性别',width:40},
    	{field:'PAAdmType',title:'就诊类型',width:80},
    	{field:'PAAdmDate',title:'就诊日期',width:80,sortable:true},
    	{field:'PAAdmTime',title:'就诊时间',width:80,sortable:true},
    	{field:'PAAdmWard',title:'病房',width:80,sortable:true},
    	{field:'PAAdmDocCodeDR',title:'主治医师',width:80},
    	{field:'Diagnosis',title:'诊断',width:150},
        {field:'PatientID',title:'PatientID',hidden: true,width:80},
        {field:'EpisodeID',title:'EpisodeID',hidden: true,width:80},
        {field:'PAAdmReason',title:'付费方式',width:80,hidden: true},
        {field:'mradm',title:'mradm',width:80,hidden: true}
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
	 var expectedLocId = $('#cbxLoc').combobox('getValue');
	 var chkArrivedQue = $('#chkLoc')[0].status;
	 //alert(patientNo+","+medicareNo+","+medicalInsuranceNo+","+cfCardNo+","+idCardNo+","+patientName+","+admType+","+admStatus+","+startDate+","+endDate+","+expectedLocId+","+chkArrivedQue)
	 //IE11中，利用下拉框中的“叉号”去掉下拉框内容时，实际上下拉框的值没有去掉，所以查询时需要手动根据下拉框的文本内容判断一下下拉框的值是否应该为空；
	 var expectedLocText = $('#cbxLoc').combobox('getText');
	 if (expectedLocText == "" || expectedLocText == "undefinded")
	 {
		 expectedLocId = "";
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
	 
	if (patientNo=="" && medicareNo=="" && patientName=="" && medicalInsuranceNo=="" && cFCardNo=="" && IDCardNo=="" && admType=="" && startDate=="" && endDate=="" && locId=="" && isArrivedQue=="off")
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
    	IsArrivedQue: isArrivedQue,
    	ExpectedLocID: expectedLocId	
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
	  }
	  else
	  {
		  $("#cbxLoc").combobox('enable');
	  }
});

//新增回车补全登记号方法
$('#patientNo').bind('keypress', function(event) {
	if (event.keyCode == "13") {
		setPatientNoLength();
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