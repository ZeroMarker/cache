﻿$(function(){
	InitSignType(signType);
	if (signType == "Nur")
	{
		$("#loc").css("display","none");
		$("#ward").css("display","block");
		InitCTLoc("#wardcombo","W");
		$("#wardcombo").combogrid("setValue", userLocID);	
		$("#wardcombo").combogrid("setText", userlocName);

	}
	else
	{
		$("#loc").css("display","block");
		$("#ward").css("display","none");
		InitCTLoc("#cbxLoc","E");
		$("#chkUser").attr("checked",true);
		$("#chkLoc").attr("checked",true);
		
	}

	$('input[name=admStatus]').change(function () {
		if (this.id == "radioInp")
		{
			$("#oDate").css("display","none");
		}
		else
		{
			$("#oDate").css("display","block");
		}
	});
	var now = new Date();
	$('#outEndDate').datebox('setValue', Dateformatter(now));
	now.setDate(now.getDate()-3);
	$('#outStartDate').datebox('setValue', Dateformatter(now));	
	
	InitPatientList();
	GetData();
	$("#frameEditor").attr("src","emr.record.editor.sign.csp");
});

function InitSignType(signType)
{
	jQuery.ajax({
		type: "GET",
		dataType: "json",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.GroupSignType",
			"Method":"GetData",
			"p1":signType
		},
		success: function(d) {
			$('#cboSignType').combobox({  
			    valueField:'GlossaryCode',  
			    textField:'Name',
			    data:d,
			    panelHeight:'auto'
			}); 
			$('#cboSignType').combobox('select',d[0].GlossaryCode);
		},
		error : function(d) { alert("GetBrowseCategory error");}
	});		
		
}

function InitCTLoc(cobId,type)
{
	$(cobId).combogrid({  
		url: "../EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.Ajax.hisData&Method=GetLocListbyType",		
	    idField:'Id',  
	    textField:'Text',
	    fitColumns: true,
	    selectOnFocus: true, 
		changetextField: true,
	    columns:[[ 
	        {field:'Text',title:'描述',width:220}  
		 ]],
	    keyHandler:{
			up: function() {
			    //取得选中行
                var selected = $(cobId).combogrid('grid').datagrid('getSelected');
                if (selected) 
                {
                    //取得选中行的rowIndex
                    var index = $(cobId).combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) 
                    {
                        $(cobId).combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } 
                else 
                {
                    var rows = $(cobId).combogrid('grid').datagrid('getRows');
                    $(cobId).combogrid('grid').datagrid('selectRow', rows.length - 1);
                }	
			},
			down: function() {
              //取得选中行
                var selected = $(cobId).combogrid('grid').datagrid('getSelected');
                if (selected) 
                {
                    //取得选中行的rowIndex
                    var index = $(cobId).combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $(cobId).combogrid('grid').datagrid('getData').rows.length - 1) 
                    {
                        $(cobId).combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } 
                else 
                {
                    $(cobId).combogrid('grid').datagrid('selectRow', 0);
                }				
			},
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () { 

                var selected = $(cobId).combogrid('grid').datagrid('getSelected');  
			    if (selected) 
			    { 
					$(cobId).combogrid("options").value = selected.Id;
			    }
                //选中后让下拉表格消失
                $(cobId).combogrid('hidePanel');
				$(cobId).focus();

            }, 
			query: function(q) {
 	            //动态搜索
	            $(cobId).combogrid("grid").datagrid("reload", {'p1':q,'p2':type});
	        	$(cobId).combogrid("setValue", q);
	        }
	    }
	});
}


//Desc:病人列表信息
function InitPatientList()
{
	$('#patientListData').datagrid({ 
    height:'100%', 
    pageSize:10,
    pageList:[10,20,30], 
    loadMsg:'数据装载中......',
    autoRowHeight: true,
    url:'../EMRservice.Ajax.patientInfo.cls?action=GetAdmRecordList', 
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
		 var pInfo = {
			 "patientID":seleRow.PatientID,
			 "episodeID":seleRow.EpisodeID,
			 "userCode":userCode,
			 "userID":userID,
			 "userName":userName,
			 "ssgroupID":ssgroupID,
			 "userLocID":userLocID,
			 "diseaseID":"",
			 "sessionID":sessionID,
      		 "episodeType":seleRow.PAAdmType,
      		 "ipAddress":ipAddress
		 }
		 
		  var tmp={
				"actionType":"LOAD",
				"chartItemType":seleRow.chartItemType,
				"characteristic":"0",
				"emrDocId":docId,
				"id":seleRow.InstanceID,
				"isLeadframe":"0",
				"isMutex":"1",
				"pluginType":seleRow.pluginType,
				"status":"NORMAL",
				"templateId":seleRow.templateID,
				"text":seleRow.Title		
			};
			window.frames["frameEditor"].pInfo = pInfo;
			window.frames["frameEditor"].InitDocument(tmp); 
 
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
	 var admStatus = $('input[name=admStatus]:checked').attr("value");
	 var startDate = "";
	 var endDate = "";
	 var outStartDate = "";
	 var outEndDate = ""
	 if (admStatus == "D") 
	 {
	 	outStartDate = $('#outStartDate').datebox('getText')
	 	outEndDate = $('#outEndDate').datebox('getText');
	 }
	 var expectedLocId = "";
	 var chkArrivedQue = "";
	 var wardId = "";
	 var isArrivedQue = "";
	 var tmpUserLoc = "";
	 var tmpUserID = "";
	 if (signType == "Nur")
	 {
		wardId = $('#wardcombo').combogrid("getValue"); 
	 }
	 else
	 {
		 var selexpLoc = $('#cbxLoc').combogrid('grid').datagrid('getSelected');
		 if (selexpLoc != null) expectedLocId = selexpLoc.Id;
		 chkArrivedQue = $('#chkLoc')[0].status;
		 tmpUserLoc = userLocID;
		 isArrivedQue = "off";
		  if (chkArrivedQue)
		  {
			  isArrivedQue = "on";
			  expectedLocId = ""
	      }
	      if ($('#chkUser')[0].status) tmpUserID = userID;
	 }
	 var signStatus =  $('#cboSign').combobox('getValue');
	 var glossaryCode = $('#cboSignType').combobox('getValue');
	 
	if (patientNo=="" && medicareNo=="" && patientName=="" && medicalInsuranceNo=="" && IDCardNo=="" && startDate=="" && endDate=="" && locId=="" && isArrivedQue=="off")
	{
		alert("不能只查询全部就诊记录");
		return;
	}
	
	$('#patientListData').datagrid('load', {  
		DocID:docId,
		GlossaryCode:glossaryCode,
		SignStatus:signStatus,
		LocID:tmpUserLoc,
   	 	PatientNo: patientNo,  
    	MedicareNo: medicareNo,
    	MedicalInsuranceNo: medicalInsuranceNo,
    	CFCardNo: "",
    	IDCardNo: idCardNo,
    	PatientName: patientName,
   		AdmType: "I",  	
    	AdmStatus: admStatus,
    	StartDate: startDate,
    	EndDate: endDate,
		OutStartDate: outStartDate,
    	OutEndDate: outEndDate,
    	IsArrivedQue: isArrivedQue,
    	ExpectedLocID: expectedLocId,
    	WardID:wardId,
    	UserID:tmpUserID	
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

$("#chkUser").change(function() {
	if ($('#chkUser')[0].checked) 
	{
		$("#chkLoc").attr("checked",true);
		$("#cbxLoc").combobox('disable');
	}
});

//新增回车补全登记号方法
$('#patientNo').bind('keypress', function(event) {
	if (event.keyCode == "13") {
		setPatientNoLength();
	}
});
//新增回车补全病案号方法
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
		if (pateinetNo.length < patientNoLength) 
		{
			for (var i=(patientNoLength-pateinetNo.length-1); i>=0; i--)
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
	if (hospitalName == 'BJTHFCYY')  //北京太和妇产医院,病案号格式为 FC0000001
	{
		medicareNo ="FC"+ medicareNo;
	}
	$("#medicareNo").val(medicareNo);
}
