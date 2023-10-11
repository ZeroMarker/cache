var selClosedUserID = "";
var selOpenedUserID = "";
var selHospID = "";

$(function(){
	initBTN(); 
	document.onkeydown = documentOnKeyDown;
	
	if (sysOption.IsOnMulityHospMgr == "1")
    {
		var hospComp = GenHospComp("CA.UsrInUseInfo",logonInfo.UserID+'^'+logonInfo.GroupID+'^'+logonInfo.CTLocID+'^');  
		hospComp.options().onSelect = function(){
			selHospID = hospComp.getValue()
			initOffUserGrid(selHospID);
			initOnUserGrid(selHospID);
		}
		hospComp.options().onLoadSuccess = function(){
			selHospID = hospComp.getValue()
			initOffUserGrid(selHospID);
			initOnUserGrid(selHospID);
		}
	}
	else
	{
		$("#hospDiv").hide();
		$('#hospDiv').panel('resize', {height: 0});
		$('body').layout('resize');
		selHospID = logonInfo.HospID;
		initOffUserGrid(selHospID);
		initOnUserGrid(selHospID);
	}
})

function initBTN(){
	$("#btnQueryOnUser").click(function(){queryOnUser();});
	$("#btnQueryOffUser").click(function(){queryOffUser();});	
	
	$("#btnOffUserCA").click(function(){ offUserCA(); });	
	$("#btnOnUserCA").click(function(){ onUserCA(); });	
}

function queryOffUser() {
	var userCode = $("#OffUserCode").val();
	var userName = $("#OffUserName").val();
	var offType = $('#OffType').combobox('getValue');
	
	var para = "";
	var obj = {UserName:userName,UserCode:userCode,OffType:offType,HospID:selHospID};
	para = JSON.stringify(obj);
	
	$('#OffUser').datagrid('load',{
        p1:para
    });
}

function queryOnUser() {
	var userCode = $("#UserCode").val();
	var userName = $("#UserName").val();
	var userStatus = "NOOFF";
	
	var para = "";
	var obj = {UserCode:userCode,UserName:userName,UserStatus:userStatus,HospID:selHospID};
	para = JSON.stringify(obj);
	
	$('#OnUser').datagrid('load',{
        p1:para
    });
}


function offUserCA() {
	selOpenedUserID = selOpenedUserID || "";
	if (selOpenedUserID == "") {
		$.messager.alert("提示","请选中要临时关闭的用户");
		return;
	}
	var EndDate = $('#EndDate').datebox('getText');
	var ReMarkOff = $("#ReMarkOff").val();

	var data = ajaxDATA('String', 'CA.UsrInUseInfo', 'CAUsrOff', selOpenedUserID,logonInfo.UserID,EndDate,ReMarkOff);
    ajaxPOSTSync(data, function (ret) {
        if (ret !== ""){
        	$.messager.alert("提示",ret);
        }else {
	        $.messager.alert("提示","停用成功");
	    }
    }, function (ret) {
        $.messager.alert("提示","CAUsrOff error:" + ret);
    });
}

function onUserCA() {
	selClosedUserID = selClosedUserID || "";
	if (selClosedUserID == "") {
		$.messager.alert("提示","请选中要开启CA的用户");
	}
	
	var ReMarkOn = $("#ReMarkOn").val();
	var data = ajaxDATA('String', 'CA.UsrInUseInfo', 'CAUsrOn', selClosedUserID,logonInfo.UserID,ReMarkOn);
    ajaxPOSTSync(data, function (ret) {
        if (ret !== ""){
        	$.messager.alert("提示",ret);
        }else {
	        $.messager.alert("提示","开启成功");
	    }
    }, function (ret) {
        $.messager.alert("提示","CAUsrOn error:" + ret);
    });
}

function initOffUserGrid(selHospID) {
	var json = JSON.stringify({OffType:"ALLOff",HospID:selHospID});
	var param = {p1:json};
	$('#OffUser').datagrid({
		fit:true,
		border:false,
		fitColumns:false,
		toolbar:'#tbOffUser',
		url: "../CA.Ajax.Cfg.cls?OutputType=String&Class=CA.BL.Config&Method=GetOffUserList",
		queryParams: param,
		idField:'UserID',
		singleSelect:true,
		pagination:true,
		rownumbers:true,
		pageSize:50,
		pageList:[10,30,50],
		beforePageText:'第',
		afterPageText:'页, 共{pages}页',
		displayMsg:'显示 {from} 到 {to} ,共 {total} 条记录',
		columns:[[
			{field:'UserID',title:'用户ID'},
			{field:'UserCode',title:'用户工号'},
			{field:'UserName',title:'用户姓名'},
			{field:'OffInfo',title:'关闭时效'},
			{field:'OffUserCode',title:'操作人工号'},
			{field:'OffUserName',title:'操作人姓名'},
			{field:'OffDateTime',title:'操作日期时间'},
			{field:'OffMark',title:'备注'}
		]],
		onLoadError:function() {
			$.messager.alert("提示","CA用户标识列表加载失败");
		},
		onDblClickRow:function(rowIndex,row){
			selClosedUserID = row.UserID;
		},
		onSelect:function(rowIndex,row){
			selClosedUserID = row.UserID;
		}
	});
}

function initOnUserGrid(selHospID) {
	var json = JSON.stringify({UserStatus:"NOOFF",HospID:selHospID});
	var param = {p1:json};
	$('#OnUser').datagrid({
		fit:true,
		border:false,
		fitColumns:false,
		toolbar:'#tbOnUser',
		url: "../CA.Ajax.Cfg.cls?OutputType=String&Class=CA.BL.Config&Method=GetUserList",
		queryParams: param,
		idField:'UserID',
		singleSelect:true,
		pagination:true,
		rownumbers:true,
		pageSize:50,
		pageList:[10,30,50],
		beforePageText:'第',
		afterPageText:'页, 共{pages}页',
		displayMsg:'显示 {from} 到 {to} ,共 {total} 条记录',
		columns:[[
			{field:'UserID',title:'用户ID'},
			{field:'UserCode',title:'用户工号'},
			{field:'UserName',title:'用户姓名'}
		]],
		onLoadError:function() {
			$.messager.alert("提示","用户列表加载失败");
		},
		onDblClickRow:function(rowIndex,row){
			selOpenedUserID = row.UserID;
		},
		onSelect:function(rowIndex,row){
			selOpenedUserID = row.UserID;
		}
	});
}

function documentOnKeyDown(e) {
	if (window.event){
		var keyCode=window.event.keyCode;
	}else{
		var keyCode=e.which;
	}
	
	if (keyCode==13) {
		if ((document.activeElement.id === 'OffUserCode')||(document.activeElement.id === 'OffUserName')) {
			queryOffUser();
		} 
		else if ((document.activeElement.id === 'UserCode')||(document.activeElement.id === 'UserName')) {
			queryOnUser();
		}
	}
	
}