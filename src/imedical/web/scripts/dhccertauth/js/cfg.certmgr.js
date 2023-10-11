var selectedUsrSignInfoID = "";
var selHospID = "";

$(function(){
	initBTN(); 
	
    //查看证书时页面隐藏部分布局及部分按钮
	if (caInfo.ViewCertUserCode != "") {
		$("#btnStop").hide();
        $("#btnUpdateLis").hide();

        if (sysOption.IsOnMulityHospMgr == "1")
        {
            $("#queryCriteriaDetail").hide();
            $('#queryCriteria').panel('resize', {height: 52});
            $('body').layout('resize');
            
            var hospComp = GenHospComp("CA.UsrSignatureInfo",logonInfo.UserID+'^'+logonInfo.GroupID+'^'+logonInfo.CTLocID+'^');  
            hospComp.options().onSelect = function(){
                selHospID = hospComp.getValue()
                initCertGrid(selHospID);
            }
            hospComp.options().onLoadSuccess = function(){
                selHospID = hospComp.getValue()
                initCertGrid(selHospID);
            }
        }
        else
        {
            $("#queryCriteria").hide();
            $('#queryCriteria').panel('resize', {height: 0});
            $('body').layout('resize');
            selHospID = logonInfo.HospID;
            initCertGrid(selHospID);
        }
        return;
	}
	
	initVenderCode();
	initCTLoc();
	document.onkeydown = documentOnKeyDown;
	
	if (sysOption.IsOnMulityHospMgr == "1")
    {
		var hospComp = GenHospComp("CA.UsrSignatureInfo",logonInfo.UserID+'^'+logonInfo.GroupID+'^'+logonInfo.CTLocID+'^');  
		hospComp.options().onSelect = function(){
			selHospID = hospComp.getValue()
			initCertGrid(selHospID);
		}
		hospComp.options().onLoadSuccess = function(){
			selHospID = hospComp.getValue()
			initCertGrid(selHospID);
		}
	}
	else
	{
		$("#hospDiv").hide();
		$('#hospDiv').panel('resize', {height: 0});
		$('body').layout('resize');
		selHospID = logonInfo.HospID;
		initCertGrid(selHospID);
	}
})

function initBTN(){
	$("#btnQuery").click(function(){queryCert();});
	$("#btnReset").click(function(){resetCondition();});
	
	$("#btnStop").click(function(){stopCert();});
	$("#btnReload").click(function(){btnReload();});
    $("#btnUpdateLis").click(function(){btnUpdateLIS();});
    $("#btnViewCertInfo").click(function(){btnViewCertInfo();});
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
			return (row["Text"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		}
	}); 
}

//Desc:初始化厂商
function initVenderCode()
{
	$('#VenderCode').combobox({
	    url:'../CA.Ajax.Cfg.cls?OutputType=String&Class=CA.BL.Config&Method=GetVenderCode',  
	    valueField:'ID',  
	    textField:'Text',
	    width:167,
	    panelHeight:350,
		filter: function(q, row){
			return (row["Text"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		}
	}); 
}

///更新选中证书图片数据
function btnReload() {
	selectedUsrSignInfoID = selectedUsrSignInfoID || "";
	if (selectedUsrSignInfoID == "") {
		$.messager.alert("提示","请选中要更新图片的证书数据");
        return;
	}
	
	var data = ajaxDATA('String', 'CA.BL.Config', 'ReloadImage', selectedUsrSignInfoID,selHospID);
    ajaxPOSTSync(data, function (ret) {
        var d = $.parseJSON(ret);
        $.messager.alert("提示",d.retMsg);
        queryCert();
    }, function (ret) {
        $.messager.alert("提示","ReloadImage error:" + ret);
    });
}

//查看证书详细信息
function btnViewCertInfo() {
	selectedUsrSignInfoID = selectedUsrSignInfoID || "";
	if (selectedUsrSignInfoID == "") {
		$.messager.alert("提示","请选中要查看详细信息的证书数据");
        return;
	}
	
	var content = '<iframe id="ViewCertInfoFrame" scrolling="auto" frameborder="0" src="dhc.certauth.cfg.certreg.csp?ViewCertID='+selectedUsrSignInfoID+'&MWToken='+getMWToken()+'" style="width:100%; height:100%;"></iframe>';
	createModalDialog("ViewCertInfo","查看证书详细信息",880,620,'ViewCertInfoFrame',content,'','');
}

///调用LIS接口同步图片数据
function btnUpdateLIS() {
	var data = ajaxDATA('String', 'CA.BL.Config', 'SyncImageData',selHospID);
    ajaxPOSTSync(data, function (ret) {
        $.messager.alert("提示",ret);
    }, function (ret) {
        $.messager.alert("提示","UpdateLIS error:" + ret);
    });
}

function initCertGrid(selHospID) {
	if (caInfo.ViewCertUserCode != "") {
        var json = JSON.stringify({HospID:selHospID,UserCode:caInfo.ViewCertUserCode});
    } else {
        var json = JSON.stringify({HospID:selHospID,IsDefaultLoad:1});
    }
	var param = {p1:json};
	$('#dgCert').datagrid({
		fit:true,
		border:false,
		fitColumns:false,
		toolbar:'#tbCert',
		url: "../CA.Ajax.Cfg.cls?OutputType=String&Class=CA.BL.Config&Method=GetCertList",
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
			{field:'UserCode',title:'用户工号'},
			{field:'UserName',title:'用户姓名'},
			{field:'CAVenderCode',title:'CA厂商代码',align:'center',editor:'text'},
			{field:'CASignTypeCode',title:'CA签名类型代码',align:'center',editor:'text'},
			{field:'UsrCertCode',title:'CA用户唯一标识',width:450,align:'center',editor:'text'},
			{field:'CertNo',title:'CA证书唯一标识',width:450,align:'center',editor:'text'},
			{field:'CertName',title:'CA证书名',width:100,align:'center',editor:'text'}
		]],
		onLoadError:function() {
			$.messager.alert("提示","证书数据加载失败");
		},
		onSelect:function(rowIndex,row){
			selectedUsrSignInfoID = row.ID;
		},
		onLoadSuccess:function(data){
			$("#dgCert").datagrid("clearSelections");
			selectedUsrSignInfoID = "";
		}
	});
}

function queryCert() {
	var userCode = $("#UserCode").val();
	var userName = $("#UserName").val();
	var userCertCode = $("#UserCertCode").val();
	var certNo = $("#CertNo").val();
    
    var venderCode = $('#VenderCode').combobox('getValue');
    if (venderCode == "undefined")
    {
        venderCode = "";
    }
    var userDept = $("#UserDept").combobox('getValue');
	if (userDept == "undefined")
    {
        userDept = "";
    }
    
	var para = "";
	//if ((userCode != "")||(userName != "")||(userDept != "")||(userCertCode != "")||(certNo != "")||(venderCode != "")) {
	var obj = {UserCode:userCode,UserName:userName,UserDept:userDept,UserCertCode:userCertCode,CertNo:certNo,VenderCode:venderCode,HospID:selHospID};
	para = JSON.stringify(obj);
	//}
	
	$('#dgCert').datagrid('load',{
        p1:para
    });
}

function resetCondition() {
    $("#UserCode").val('');
    $("#UserName").val('');
    $("#UserCertCode").val('');
    $("#CertNo").val('');
    $('#UserDept').combobox('setValue','');
    $('#VenderCode').combobox('setValue','');
}

function stopCert() {
	selectedUsrSignInfoID = selectedUsrSignInfoID || "";
	if (selectedUsrSignInfoID == "") {
		$.messager.alert("提示","请选中要停用的证书");
        return;
	}
	
	var data = ajaxDATA('String', 'CA.BL.Config', 'StopCert', selectedUsrSignInfoID);
    ajaxPOSTSync(data, function (ret) {
        var d = $.parseJSON(ret);
        $.messager.alert("提示",d.retMsg);
        queryCert();
    }, function (ret) {
        $.messager.alert("提示","StopCert error:" + ret);
    });
}

function documentOnKeyDown(e) {
	if (window.event){
		var keyCode=window.event.keyCode;
	}else{
		var keyCode=e.which;
	}
	
	if (keyCode==13) {
		queryCert();
	}
	
}