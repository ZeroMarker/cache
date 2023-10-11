var selHospID = "";
var defaultParam = JSON.stringify({IsDefaultLoad:1});

$(function(){
	initBTN(); 
	initCTLoc();
	setStartData();
	document.onkeydown = documentOnKeyDown;
	
	if (parent.sysOption.IsOnMulityHospMgr == "1")
    {
		var hospComp = GenHospComp("SS_User",logonInfo.UserID+'^'+logonInfo.GroupID+'^'+logonInfo.CTLocID+'^');  
		hospComp.options().onSelect = function(){
			selHospID = hospComp.getValue()
			initLoginLogGrid(selHospID);
			resetCondition();
		}
		hospComp.options().onLoadSuccess = function(){
			selHospID = hospComp.getValue()
			initLoginLogGrid(selHospID);
			resetCondition();
		}
	}
	else
	{
		$("#hospDiv").hide();
		$('#hospDiv').panel('resize', {height: 0});
		$('body').layout('resize');
		selHospID = logonInfo.HospID;
		initLoginLogGrid(selHospID);
	}
})

function initBTN(){
	$("#btnQuery").click(function(){queryLoginLog();});
	$("#btnReset").click(function(){resetCondition();});
}

//根据结束日期，设置开始日期
function setStartData() {
	var val = $("#EndDate").datebox('getValue');
    var n = 3;
    var d = new Date(val);
    var year = d.getFullYear();
    var mon = d.getMonth() + 1;
    var day = d.getDate();
    if(day <= n) {
        if(mon > 1) {
            mon = mon - 1;
        } else {
            year = year - 1;
            mon = 12;
        }
    }
    d.setDate(d.getDate() - n);
    year = d.getFullYear();
    mon = d.getMonth() + 1;
    day = d.getDate();
    s = year + "-" + (mon < 10 ? ('0' + mon) : mon) + "-" + (day < 10 ? ('0' + day) : day);
    $("#StartDate").datebox('setValue',s);
}

function dateFormat(date){
	var fmatdate = date;
	if (date == "" || date == undefined) return fmatdate;
	if (typeof(dtformat) != "undefined")
	{
		if (dtformat == "DMY")
		{
			var tmparr = date.split("/");
			fmatdate = tmparr[2]+"-"+tmparr[1]+"-"+tmparr[0];
		}
		else if (dtformat == "MDY")
		{
			var tmparr = date.split("/");
			fmatdate = tmparr[2]+"-"+tmparr[0]+"-"+tmparr[1];
		}
	}
	return fmatdate
}

//Desc:初始化科室
function initCTLoc()
{
	$('#UserDept').combobox({
	    url:"../CA.Ajax.Cfg.cls?OutputType=String&Class=CA.BL.Config&Method=GetDictList",
	    valueField:'Id',  
	    textField:'Text',
	    width:167,
	    panelHeight:350,
		filter: function(q, row){
			return (row["Text"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		}
	}); 
}

function initLoginLogGrid(selHospID) {
	var param = {p1:defaultParam};
	$('#dgLog').datagrid({
		fit:true,
		border:false,
		fitColumns:false,
		url: "../CA.Ajax.Cfg.cls?OutputType=Stream&Class=CA.BL.Config&Method=GetLoginLog",
		queryParams: param,
		idField:'ID',
		singleSelect:true,
		pagination:true,
		rownumbers:true,
		pageSize:50,
		pageList:[2,10,30,50],
		beforePageText:'第',
		afterPageText:'页, 共{pages}页',
		displayMsg:'显示 {from} 到 {to} ,共 {total} 条记录',
		columns:[[
			{field:'ID',title:'ID'},
			{field:'LoginDateTime',title:'登录日期时间',align:'center'},
			{field:'UserCode',title:'用户工号'},
			{field:'UserName',title:'用户姓名'},
			{field:'LoginType',title:'登录类型'},
			{field:'LoginInfoUCertCode',title:'登陆信息(用户唯一标识)',align:'center'},
			{field:'LoginInfoCertNo',title:'登陆信息(证书唯一标识)',align:'center'},
			{field:'LoginInfoSignType',title:'登陆信息(签名方式)',align:'center'},
			{field:'LoginInfoVendCode',title:'登陆信息(厂商标识)',align:'center'},
			{field:'LoginInfoOther',title:'登陆信息(随机数|客户端对随机数签名值|签名证书Base64编码)',width:500,align:'center'}
		]],
		onLoadError:function() {
			$.messager.alert("提示","证书数据加载失败");
		},
		onSelect:function(rowIndex,row){
		},
		onLoadSuccess:function(data){
			$("#dgLog").datagrid("clearSelections");
		}
	});
}

function queryLoginLog() {
	debugger;
	//增加限制条件，比如工号/姓名/科室不能同时为空
	//控制查询天数
	var userCode = $("#UserCode").val();
	var userName = $("#UserName").val();
	
	var endDate = $('#EndDate').datebox('getText');
	var startDate = $('#StartDate').datebox('getText');
    
    var userDept = $("#UserDept").combobox('getValue');
	if (userDept == "undefined")
    {
        userDept = "";
    }
    
    if ((endDate == "")||(startDate == ""))
    {
	    $.messager.alert('提示','开始日期和结束日期不能为空');
	    $('#dgLog').datagrid('load',{
	        p1:defaultParam
	    });
	    return;
	}
    
    var startDate1 = startDate.replace(new RegExp(/-/g), "/");
    var endDate1 = endDate.replace(new RegExp(/-/g), "/");
    var date1 = new Date(startDate1);
    var date2 = new Date(endDate1);
    var date3 = date2.getTime()-date1.getTime();
    var days = Math.floor(date3/(24*3600*1000));
    
    if (days >= 7)
    {
		$.messager.alert('提示','查询时间范围要在7天之内');
    }
    else if ((userCode == "")&&(userCode == "")&&(userDept == ""))
    {
	    $.messager.alert('提示','工号、姓名、科室不能同时为空');
	}
	else
	{
		var para = "";
		var obj = {UserCode:userCode,UserName:userName,UserDept:userDept,StartDate:startDate,EndDate:endDate,HospID:selHospID};
		para = JSON.stringify(obj);
		
		$('#dgLog').datagrid('load',{
	        p1:para
	    });
	    return;
	}
    
    $('#dgLog').datagrid('load',{
        p1:defaultParam
    });
}

function resetCondition() {
    $("#UserCode").val('');
    $("#UserName").val('');
    $('#UserDept').combobox('setValue','');
    $("#EndDate").datebox('setValue','Today');
    setStartData();
}

function documentOnKeyDown(e) {
	if (window.event){
		var keyCode=window.event.keyCode;
	}else{
		var keyCode=e.which;
	}
	
	if (keyCode==13) {
		queryLoginLog();
	}
	
}