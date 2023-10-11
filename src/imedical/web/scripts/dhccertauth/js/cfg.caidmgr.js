var selCAID = "";
var selUserID = "";
var selHospID = "";

$(function(){
	initBTN(); 
	document.onkeydown = documentOnKeyDown;
	
	if (sysOption.IsOnMulityHospMgr == "1")
    {
		var hospComp = GenHospComp("CA.ConfigCAID",logonInfo.UserID+'^'+logonInfo.GroupID+'^'+logonInfo.CTLocID+'^');  
		hospComp.options().onSelect = function(){
			selHospID = hospComp.getValue()
			if (!isShow(selHospID)){
				return;
			}
			initCAIDGrid(selHospID);
			initUserGrid(selHospID);
		}
		hospComp.options().onLoadSuccess = function(){
			selHospID = hospComp.getValue()
			if (!isShow(selHospID)){
				return;
			}
			initCAIDGrid(selHospID);
			initUserGrid(selHospID);
		}
	}
	else
	{
		$("#hospDiv").hide();
		$('#hospDiv').panel('resize', {height: 0});
		$('body').layout('resize');
		selHospID = logonInfo.HospID;
		if (!isShow(selHospID)){
			return;
		}
		initCAIDGrid(selHospID);
		initUserGrid(selHospID);
	}
})

function initBTN(){
	$("#btnQueryUser").click(function(){queryUser();});
	$("#btnQueryCAID").click(function(){queryCAID();});	
	
	$("#btnAddPhoneCAID").click(function(){addCAID("PHONE");});	
	$("#btnDeleteCAID").click(function(){deleteCAID();});	
}

function isShow(selHospID) {
	var result = false;
	var errmsg = "";
    var data = ajaxDATA('String', 'CA.BL.Config', 'GetCfgCommon',selHospID);
    ajaxPOSTSync(data, function (ret) {
        if (ret != "")
        {
            var arr = $.parseJSON(ret);
            if ((arr["DefaultPHONEVenderCode"] !== "BJCA")&&(arr["DefaultPHONEVenderCode"] !== "GXCA"))
            {
	            errmsg = "当前院区配置中【默认手机厂商】为【"+arr["DefaultPHONEVenderCode"]+"】，CA标识管理页面只有【默认手机厂商】为【BJCA】或【GXCA】时可用"
	        }
		    else
		    {
				result = true;
			}
        }
        else
        {
            $.messager.alert("提示","获取通用配置数据错误!");
        }
    }, function (ret) {
        $.messager.alert("提示","CA.BL.Config.GetCfgCommon Error:" + ret);
    });

    if (!result){
		$.messager.alert("提示",errmsg);
		setEnable(false,errmsg);
	}else {
		setEnable(true);
	}
	
    return result;
}

function setEnable(enable,errmsg) {
	if (enable) {
		$("#User").show();
		$("#CAID").show();
		$("#caTip").hide();
	}else {
		$("#User").hide();
		$("#CAID").hide();
		$("#caTip").show();
		document.getElementById("caTip").innerText = errmsg;
	}
}


function queryCAID() {
	var userCode = $("#CAUserCode").val();
	var userName = $("#CAUserName").val();
	var signTypeCode = $('#SignTypeCode').combobox('getValue');
	var venderCode = $('#VenderCode').combobox('getValue');
	//var validStatus = $HUI.combobox('#CAIDStatus').getValue();
	var validStatus = "";
	
	var para = "";
	var obj = {UserName:userName,UserCode:userCode,ValidStatus:validStatus,SignTypeCode:signTypeCode,VenderCode:venderCode,HospID:selHospID};
	para = JSON.stringify(obj);
	
	$('#dgCAID').datagrid('load',{
        p1:para
    });
}

function queryUser() {
	var userCode = $("#UserCode").val();
	var userName = $("#UserName").val();
	var userStatus = $('#UserStatus').combobox('getValue');
	
	var para = "";
	var obj = {UserCode:userCode,UserName:userName,UserStatus:userStatus,HospID:selHospID};
	para = JSON.stringify(obj);
	
	$('#dgUser').datagrid('load',{
        p1:para
    });
}


function addCAID(signType) {
	selUserID = selUserID || "";
	if (selUserID == "") {
		$.messager.alert("提示","请选中要添加CA标识的用户");
		return;
	}
	
    var content = '<iframe id="addCAIDFrame" scrolling="auto" frameborder="0" src="dhc.certauth.cfg.caidreg.csp?SignTypeCode='+signType+"&UserID="+selUserID+"&MWToken="+getMWToken()+'" style="width:100%; height:100%;"></iframe>';
	createModalDialog("addCAID","添加CA标识",800,600,'addCAIDFrame',content,'','');
}

function deleteCAID() {
	selCAID = selCAID || "";
	if (selCAID == "") {
		$.messager.alert("提示","请选中要停用的CA用户标识");
		return;
	}
	
	var data = ajaxDATA('String', 'CA.BL.Config', 'DeleteCAID', selCAID);
    ajaxPOSTSyncCfg(data, function (ret) {
        var d = $.parseJSON(ret);
        $.messager.alert("提示",d.retMsg);
        queryCAID();
        queryUser();
    }, function (ret) {
        $.messager.alert("提示","DeleteCAID error:" + ret);
    });
}

function initCAIDGrid(selHospID) {
	var json = JSON.stringify({HospID:selHospID});
	var param = {p1:json};
	$('#dgCAID').datagrid({
		fit:true,
		border:false,
		fitColumns:false,
		toolbar:'#tbCAID',
		url: "../CA.Ajax.Cfg.cls?OutputType=String&Class=CA.BL.Config&Method=GetCAIDList",
		queryParams: param,
		idField:'ID',
		singleSelect:true,
		pagination:true,
		rownumbers:true,
		pageSize:50,
		pageList:[10,30,50],
		beforePageText:'第',
		afterPageText:'页, 共{pages}页',
		displayMsg:'显示 {from} 到 {to} ,共 {total} 条记录',
		columns:[[
			{field:'ID',title:'ID'},
			{field:'UserID',title:'用户ID'},
			{field:'UserCode',title:'用户工号'},
			{field:'UserName',title:'用户姓名'},
			{field:'ValidStatus',title:'是否有效'},
			{field:'VenderCode',title:'CA厂商代码'},
			{field:'SignTypeCode',title:'签名类型代码'},
			{field:'UserCertCode',title:'CA用户标识'}
		]],
		onLoadError:function() {
			$.messager.alert("提示","CA用户标识列表加载失败");
		},
		onSelect:function(rowIndex,row){
			selCAID = row.ID;
		},
		onLoadSuccess:function(data){
			$("#dgCAID").datagrid("clearSelections");
			selCAID = "";
		}
	});
}

function initUserGrid(selHospID) {
	var json = JSON.stringify({UserStatus:"NOPHONE",HospID:selHospID});
	var param = {p1:json};
	$('#dgUser').datagrid({
		fit:true,
		border:false,
		fitColumns:false,
		toolbar:'#tbUser',
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
		onSelect:function(rowIndex,row){
			selUserID = row.UserID;
		},
		onLoadSuccess:function(data){
			$("#dgUser").datagrid("clearSelections");
			selUserID = "";
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
		if ((document.activeElement.id === 'CAUserCode')||(document.activeElement.id === 'CAUserName')) {
			queryCAID();
		} 
		else if ((document.activeElement.id === 'UserCode')||(document.activeElement.id === 'UserName')) {
			queryUser();
		}
	}
	
}