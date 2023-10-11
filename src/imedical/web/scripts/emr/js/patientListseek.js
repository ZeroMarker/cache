var cbxLocflag = "Y";
$(function(){
	$('#chkLoc')[0].status = false;
	InitPatientList();
	InitCTLoc();
	InitDefaultDate();
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
			if (selectDefaultLoc != "N")
			{
		    	var data=eval(d);
		    	$.each(data,function(idx,val){
			    	//第一次打开页面时设置默认值为登录科室
			    	if ((val.Id == locID)&&(cbxLocflag == "Y")){
				    	$('#cbxLoc').combobox('select',locID);
				    	cbxLocflag = "N";
	                    return;
				    }
				    if ((expectlocID != "")&&(val.Id == expectlocID)&&(cbxLocflag == "Y")){
				    	$('#cbxLoc').combobox('select',expectlocID);
				    	cbxLocflag = "N";
	                    return;
				    }
				});
			}
	    }
	}); 
}

//Desc:初始化医生
function InitDoctorName(cbxlocID)
{
	$('#cbxUser').combobox({
		url:'../EMRservice.Ajax.patientInfo.cls?action=GetUserName&cbxLocID='+cbxlocID,  
	    valueField:'UserID',  
	    textField:'UserDesc',
	    onLoadSuccess:function(d){
	    	var data=eval(d);
	    	$.each(data,function(idx,val){
		    	//默认值为登录医师
		    	if (val.UserID == userID){
			    	$('#cbxUser').combobox('select',userID);
			    	return;
			    }
			});
			//GetData();
		}
    });
}

//Desc:病人列表信息
function InitPatientList()
{
	$('#patientListData').datagrid({ 
    width:'100%',
    height:106, 
    pageSize:25,
    pageList:[10,20,25,30], 
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
//获取当前日期的前p_count天
 function FunGetDateStr(p_count) {
        var dateNow = new Date();
        dateNow.setDate(dateNow.getDate() - p_count);//获取p_count天后的日期 
        var y = dateNow.getFullYear();
        var m = dateNow.getMonth() + 1;//获取当前月份的日期 
        var d = dateNow.getDate();
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
       
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
	 var chkArrivedQue = $('#chkLoc')[0].status;
	 var MRN = $("#MRN").val();
         var queryItem = $("#diagnosDesc").val();
	 
	 //IE11中，利用下拉框中的“叉号”去掉下拉框内容时，实际上下拉框的值没有去掉，所以查询时需要手动根据下拉框的文本内容判断一下下拉框的值是否应该为空；
	 var expectedLocText = $('#cbxLoc').combobox('getText');
	 if (expectedLocText == "" || expectedLocText == "undefinded")
	 {
		 expectedLocId = "";
	 }
	 
	 if (expectedLocId != "")
	 {
		 var expectedUserId = $("#cbxUser").combobox('getValue');
		 var expectedUserText = $('#cbxUser').combobox('getText');
	 }
	 if (typeof(expectedUserText) == "undefined" || expectedUserText == "")
	 {
		 expectedUserId = "";
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
    	ExpectedUserID: expectedUserId,
		MRN: MRN,
		QueryItem: (queryItem == "请输入诊断内容")? "":queryItem
	}); 
}

function InitDefaultDate()
{
	 var startDate = FunGetDateStr(dateConfig-1);
	 $('#startDate').datebox('setValue',startDate);
	 var endDate = FunGetDateStr(0);
	 $('#endDate').datebox('setValue',endDate);
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

//点击控件事件
function my_click(obj, myid)
{
	if (document.getElementById(myid).value == document.getElementById(myid).defaultValue)
	{
		document.getElementById(myid).value = '';
		obj.style.color='#000';
	}
}
//离开控件事件
function my_blur(obj, myid)
{
	if (document.getElementById(myid).value == '')
	{
		document.getElementById(myid).value = document.getElementById(myid).defaultValue;
		obj.style.color='#999'
	}
}
