var cbxLocflag = "Y";
var cbxWardFlag= "Y";
$(function(){
	$('#chkLoc')[0].status = false;
	initPatientList();
	InitIllness();
});
//Desc:初始化病区  不选中
function initPACWard(){
		$('#wardcombo').combobox({  
	    url:'../EMRservice.Ajax.hisData.cls?Action=GetDicList&DicCode=S10&PageType=all&LoadType=combobox',  
	    valueField:'Id',  
	    textField:'Text',
	    width:167,
		filter: function(q, row){
			return ((row["Text"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0));
		},
	    onSelect: function(record){
		    //加载病区
		    
	    	InitDoctorName(record.Id,"S10");
	    },
	    onLoadSuccess:function(d){
	    	if(userIsNur=="1"){
				$('#wardcombo').combobox('select',wardID);
                    return;
		    }
		}
	}); 
}  
//Desc:初始化科室
function initCombox()
{
	$('#cbxLoc').combobox({  
	    url:'../EMRservice.Ajax.hisData.cls?Action=GetDicList&DicCode=s07&PageType=all&LoadType=combobox',  
	    valueField:'Id',  
	    textField:'Text',
	    width:167,
	    panelHeight:350,
		filter: function(q, row){
			return ((row["Text"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0));
		},
	    onSelect: function(record){
	    	InitDoctorName(record.Id,"S07");
	    },
	    onLoadSuccess:function(d){
	    	var data=eval(d);
	    	if(cbxLocflag == "N") return
	    	$.each(data,function(idx,val){
		    	//第一次打开页面时设置默认值为登录科室
		    	if ((val.Id == locID)&&(cbxLocflag == "Y")&&(expectlocID=="")){
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
			cbxLocflag = "N";
		}
	}); 
	
	$('#cboAdmType').combobox({
		width: 167,
		panelHeight:'auto',
		valueField:'id',  
	    textField:'text',
	    data: [{id:'',text: emrTrans('全部')},{id: 'O',text: emrTrans('门诊')},{id: 'E',text: emrTrans('急诊')},{id: 'I',text: emrTrans('住院')}],
		onLoadSuccess:function()
		{
			$('#cboAdmType').combobox('setValue','');
		}
	});
	
	$('#cboAdmStatus').combobox({
		width: 167,
		panelHeight:'auto',
		valueField:'id',  
	    textField:'text',
	    data: [{"id":"all","text":emrTrans("全部")},{"id":"A","text":emrTrans("在院")},{"id":"D","text":emrTrans("出院")}],
		onLoadSuccess:function()
		{
			$('#cboAdmStatus').combobox('setValue', 'A');
		}	
	});
	
}

//Desc:初始化医生
function InitDoctorName(cbxlocID,dictcode)
{
	$('#cbxUser').combobox({
		width:167,
		url:'../EMRservice.Ajax.patientInfo.cls?action=GetUserName&cbxLocID='+cbxlocID+'&DictCode='+dictcode,  
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
			if(cbxWardFlag=="Y"&&userIsNur=="1"){
				cbxWardFlag="N"	
			}else{
				GetData();
			}
		}
    });
}

//Desc:病人列表信息
function initPatientList()
{
	$('#patientListData').datagrid({ 
    headerCls:'panel-header-gray',
    height:106, 
    pageSize:10,
    pageList:[10,20,30], 
    fitColumns: true,
    loadMsg:'数据装载中......',
    autoRowHeight: true,
    //url:'../EMRservice.Ajax.patientInfo.cls?action=GetAdmList',  
    data:[], 
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
        {field:'PAAdmAdmDate',title:'入院日期',width:80,sortable:true},
        {field:'PAAdmAdmTime',title:'入院时间',width:80,sortable:true},
        {field:'PADischgeDate',title:'出院日期',width:80,sortable:true},
        {field:'PAPMISex',title:'性别',width:80},
        {field:'PAAdmDepCodeDR',title:'就诊科室',width:80},
        {field:'PatIllness',title:'病情',width:80},
        {field:'PAAdmDocCodeDR',title:'医生',width:80}, 
        {field:'PAAdmWard',title:'病房',width:80,sortable:true}, 
        {field:'PAAdmReason',title:'付费方式',width:80},
        {field:'Diagnosis',title:'诊断',width:80},
        {field:'PADischgeTime',title:'出院时间',width:80}
    ]],
  onDblClickRow: function() {
	  var seleRow = $('#patientListData').datagrid('getSelected');
	  if (seleRow){
			var PatientID = seleRow.PatientID;
			var EpisodeID = seleRow.EpisodeID;
			var mradm = seleRow.mradm;
			//判断是否同源，若不同则只取parent层方法
			var flag = false;
			try{
				flag = Boolean(top.frames[0].switchPatient);
				}catch(e){
					flag = false;
					}
			if (flag&&top.frames[0] && top.frames[0].switchPatient)
			{
				// 刷新门诊病历上方患者信息栏
				if('function' === typeof top.frames[0].switchPatient) top.frames[0].switchPatient(PatientID,EpisodeID,mradm);
				if('function' === typeof top.frames[0].hidePatListWin) top.frames[0].hidePatListWin();
				if('function' === typeof top.frames[0].queryData) top.frames[0].queryData();
				// 刷新病历浏览上方患者信息栏
				if('function' === typeof parent.switchPatient) parent.switchPatient(PatientID,EpisodeID,mradm);
				if('function' === typeof parent.hidePatListWin) parent.hidePatListWin();
				if('function' === typeof parent.queryData) parent.queryData();
			}
			else
			{
				parent.switchPatient(PatientID,EpisodeID,mradm);
				parent.hidePatListWin();
				parent.queryData();
			}
	  }},
	  onLoadSuccess:function(){
		if(cbxLocflag=="Y"){
		initCombox();
		initPACWard();	  
	  }
	}
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
	 var wardId = $('#wardcombo').combobox('getValue');
	 var chkArrivedQue = $('#chkLoc')[0].status;
	 var MRN = $("#MRN").val();
	 var queryItem = $("#diagnosDesc").val();
	 
	 //IE11中，利用下拉框中的“叉号”去掉下拉框内容时，实际上下拉框的值没有去掉，所以查询时需要手动根据下拉框的文本内容判断一下下拉框的值是否应该为空；
	 var expectedLocText = $('#cbxLoc').combobox('getText');
	 if (expectedLocText == "" || expectedLocText == "undefinded")
	 {
		 expectedLocId = "";
	 }
	 var expectedUserId = $("#cbxUser").combobox('getValue');
	 var expectedUserText = $('#cbxUser').combobox('getText');
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
	 
	if (patientNo=="" && medicareNo=="" && patientName=="" && medicalInsuranceNo=="" && cfCardNo=="" && idCardNo=="" && startDate=="" && endDate=="" && MRN=="" && outStartDate=="" && outEndDate=="")
	{
		if (admStatus == "all")
		{
			$.messager.alert("提示","就诊状态为 全部，必须配合登记号、病案号、姓名等患者唯一标识信息，或者入院、出院起止日期进行查询！");
			return;
		}
		/*else if (admStatus == "C")
		{
			$.messager.alert("提示","就诊状态为 退院，必须配合登记号、病案号、姓名等患者唯一标识信息，或者入院起止日期进行查询！");
			return;
		}*/
		else if (admStatus == "D")
		{
			$.messager.alert("提示","就诊状态为 出院，必须配合登记号、病案号、姓名等患者唯一标识信息，或者出院起止日期进行查询！");
			return;
		}
	}
	$('#patientListData').datagrid("options").url  = '../EMRservice.Ajax.patientInfo.cls?action=GetAdmList';
	
	var IllnessArry=$("#Illness").combobox("getValues");
	var Illness = IllnessArry.join("|");
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
		QueryItem: (queryItem == "请输入诊断内容")? "":queryItem,
		WardId:wardId,
		Illness:Illness
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
		GetData();
	}
});
//新增回车补全病案号方法 add by niucaicai 2016-10-17
$('#medicareNo').bind('keypress', function(event) {
	if (event.keyCode == "13") {
		setMedicareNoLength();
		GetData();
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
function InitIllness() {
	$("#Illness").combobox({
		textField:"val",
		valueField:"key",
		data:[{key:"C",val:"病危"},{key:"S",val:"病重"},{key:"D",val:"死亡"}],
		eaditable:false,
		multiple:true,		
		rowStyle:'checkbox', //显示成勾选行形式	
	});
}