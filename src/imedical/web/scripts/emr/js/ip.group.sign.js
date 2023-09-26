$(function(){
	InitSignType(signType);
		$HUI.radio("[name='admStatus']",{
		onChecked:function(e,value){
			if (this.id == "radioInp")
			{
				$("#oDate").css("display","none");
				$("#iDate").css("display","block");
			}
			else
			{
				$("#oDate").css("display","block");
				$("#iDate").css("display","none");
			}
		}
	});	
	if (signType == "Nur")
	{
		$("#loc").css("display","none");
		$("#ward").css("display","block");
		InitCTLoc("#wardcombo","W");
		$("#wardcombo").combogrid("setValue", userLocID);	
		$("#wardcombo").combogrid("setText", userlocName);
		$HUI.radio("#radioInp").setValue(true);
	}
	else
	{
		$("#loc").css("display","block");
		$("#ward").css("display","none");
		InitCTLoc("#cbxLoc","E");
		var groupFlag = defaultGroup.some(function(item){
			return item == userLevel
		})
		var LocFlag = defaultLoc.some(function(item){
			return item == userPost
		})
		if(groupFlag && !LocFlag){
			$HUI.checkbox("#chkGroup").setValue(true);	
			$("#cbxLoc").combobox('disable');
		}else if(LocFlag){
			$HUI.checkbox("#chkLoc").setValue(true);
			$("#cbxLoc").combobox('disable');
		}
		
	}

	var now = new Date();
	$('#outEndDate').datebox('setValue', Dateformatter(now));
	now.setDate(now.getDate()-3);
	$('#outStartDate').datebox('setValue', Dateformatter(now));	
	
	InitPatientList();
	GetData();
	$("#frameEditor").attr("src","emr.ip.group.editor.sign.csp");
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
			var data = eval(d);
			$('#cboSignType').combobox({  
			    valueField:'GlossaryCode',  
			    textField:'Name',
			    data:data,
			    panelHeight:'auto',
				onSelect: function(rec)
			    {  
			    	if (rec.Code == "qcdocCheck")
			    	{
				    	$HUI.checkbox("#chkLoc").setValue(true);
					$HUI.checkbox("#chkUser").setValue(false);
					$HUI.checkbox("#chkGroup").setValue(false);
						$("#cbxLoc").combobox('disable');
			    	}
		        },
				onLoadSuccess:function(d){
					var flag = "0";
					$.each(data,function(idx,val){
						if (val.Code == userPost){
							$('#cboSignType').combobox('select',val.GlossaryCode);
							flag = "1"
							return;
						}
					});
					if (flag == "0")
					{
						$.each(data,function(idx,val){
							if (val.Code == userLevel){
								$('#cboSignType').combobox('select',val.GlossaryCode);
							return;
							}
						});
					}
				}
			}); 
		},
		error : function(d) { alert("GetBrowseCategory error");}
	});		
		
}

function InitCTLoc(cobId,type)
{
	$(cobId).combogrid({  
		url: "../EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.Ajax.hisData&Method=GetLocListbyType&p1=&p2="+type,		
	    idField:'Id',
	    async:false, 
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
		{field:'PAADMBedNO',title:'床号',width:60,sortable:true},
        {field:'PAPMINO',title:'登记号',width:100,sortable:true},
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
			document.getElementById("frameEditor").contentWindow.pInfo = pInfo;
			document.getElementById("frameEditor").contentWindow.InitDocument(tmp);
 
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
	 	outStartDate = dateFormat($('#outStartDate').datebox('getText'));
	 	outEndDate = dateFormat($('#outEndDate').datebox('getText'));
	 }else{
		startDate = dateFormat($('#inStartDate').datebox('getText'));
	 	endDate = dateFormat($('#inEndDate').datebox('getText'));
	 	admStatus = "A";
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
		 //选本科室
		 chkArrivedQue = $('#chkLoc')[0].checked; 
		 //选本人
	     var chkArrivedQueUser = $('#chkUser')[0].checked;
	     //选本医疗组 (本医疗组和本科室，本用户没有关联关系)
	     var chkArrivedQueGroup = $('#chkGroup')[0].checked;
		 tmpUserLoc = userLocID;
		 isArrivedQue = "off";
		  if (chkArrivedQue)
		  {
			  isArrivedQue = "on";
			  expectedLocId = "";
	      }else if(!chkArrivedQue && chkArrivedQueUser)
	      {
		  	  isArrivedQue = "on";
			  tmpUserLoc=expectedLocId;   
		  }
	     
	      
	     if (chkArrivedQueUser) {tmpUserID = userID;}
	     if(chkArrivedQueGroup){
		     //本医疗组查询
		     isArrivedQue="chkGroup";
		     tmpUserID = "";
		     expectedLocId = "";
		 }
		 if (tmpUserID!=""&&expectedLocId==""&&isArrivedQue=="off"&&(admStatus==""||admStatus==undefined)){
	     	startDate=FunGetDateStr(30);
	     	endDate=FunGetDateStr(0);
	      }
	 }
	 var signStatus =  $('#cboSign').combobox('getValue');
	 var glossaryCode = $('#cboSignType').combobox('getValue');
	 
	if (patientNo=="" && medicareNo=="" && patientName=="" && medicalInsuranceNo=="" && idCardNo=="" && startDate=="" && endDate=="" && outStartDate==""&&outEndDate=="" && isArrivedQue=="off"&&expectedLocId=="")
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
//获取当前日期的前p_count天
 function FunGetDateStr(p_count) {
        var dateNow = new Date();
        dateNow.setDate(dateNow.getDate() - p_count);//获取p_count天后的日期 
        var y = dateNow.getFullYear();
        var m = dateNow.getMonth() + 1;//获取当前月份的日期 
        var d = dateNow.getDate();
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
       
    }

///Desc:本科患者
function chkLocchange(value)
{
	if (value)
	{
		$HUI.checkbox("#chkGroup").setValue(false);	
		$("#cbxLoc").combobox('disable');
		$("#cbxLoc").combogrid('setValue',userlocName);
	}
	else
	{
		 $("#cbxLoc").combobox('enable');
		 $("#cbxLoc").combogrid('setValue',"");
	}
}

function chkUserChange(value)
{
	if (value)
	{
		$HUI.checkbox("#chkLoc").setValue(true);
		$("#cbxLoc").combogrid('setValue',userlocName);
		$HUI.checkbox("#chkGroup").setValue(false);
		$("#cbxLoc").combobox('disable');
	}
}

function chkGroupChange(value)
{
	if (value)
	{
		$HUI.checkbox("#chkLoc").setValue(false);
		$HUI.checkbox("#chkUser").setValue(false);
		$("#cbxLoc").combogrid('setValue',"");
		$("#cbxLoc").combobox('disable');
	}
	else
    {
	    $("#cbxLoc").combobox('enable');
    }
}

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
