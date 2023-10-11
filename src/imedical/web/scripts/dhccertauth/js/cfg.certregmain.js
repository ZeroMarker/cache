var selectUserCode = "";
var selHospID = "";
var caInfo = {};

$(function(){
	initBTN(); 
	initCTLoc();
	document.onkeydown = documentOnKeyDown;
	
	if (sysOption.IsOnMulityHospMgr == "1")
    {
		var hospComp = GenHospComp("CA.UsrSignatureInfo",logonInfo.UserID+'^'+logonInfo.GroupID+'^'+logonInfo.CTLocID+'^');  
		hospComp.options().onSelect = function(){
			selHospID = hospComp.getValue()
			initCertGrid(selHospID);
			getCaInfo(selHospID);
		}
		hospComp.options().onLoadSuccess = function(){
			selHospID = hospComp.getValue()
			initCertGrid(selHospID);
			getCaInfo(selHospID);
		}
	}
	else
	{
		$("#hospDiv").hide();
		$('#hospDiv').panel('resize', {height: 0});
		$('body').layout('resize');
		selHospID = logonInfo.HospID;
		initCertGrid(selHospID);
		getCaInfo(selHospID);
	}
})

function initBTN(){
	$("#btnQuery").click(function(){queryCert();});
	$("#btnReset").click(function(){resetCondition();});
	
	$("#btnKeyCert").click(function(){bindKeyCert();});
	$("#btnPhoneCert").click(function(){bindPhoneCert();});
    $("#btnFaceCert").click(function(){btnFaceCert();});
}

//Desc:初始化科室
function initCTLoc() {
	$('#cbxLoc').combobox({
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

//获取对应院区配置基础服务
function getCaInfo(selHospID) {	
	var data = ajaxDATA('String', 'CA.BL.Config', 'GetCfgCommon',selHospID);
    ajaxPOST(data, function (ret) {
        if (ret != "")
        {
            var arr = $.parseJSON(ret);
            caInfo = arr;
            initBtn();
        }else
        {
            $.messager.alert("提示","获取通用配置数据错误!");
        }
    }, function (ret) {
        $.messager.alert("提示","CA.BL.Config.GetCfgCommon Error:" + ret);
    });
}

//根据院区配置服务信息初始化关联按钮
function initBtn()
{
	//手机厂商为BJCA/GXCA或未上线手机签名时隐藏关联手机证书按钮
	if ((caInfo.DefaultPHONEVenderCode == "BJCA")||(caInfo.DefaultPHONEVenderCode == "")||(caInfo.DefaultPHONEVenderCode == "GXCA")){
		$("#btnPhoneCert").hide();
	}else{
		$("#btnPhoneCert").show();
	}

    //未上线Ukey签名时隐藏关联Ukey证书按钮
	if (caInfo.DefaultUKEYVenderCode == ""){
		$("#btnKeyCert").hide();
	}else{
		$("#btnKeyCert").show();
	}
	
    //未上线人脸签名时隐藏关联人脸证书按钮
	if (caInfo.DefaultFACEVenderCode == ""){
		$("#btnFaceCert").hide();
	}else{
		$("#btnFaceCert").show();
	}
}

function initCertGrid(selHospID) {
	var json = JSON.stringify({HospID:selHospID,IsDefaultLoad:1});
	var param = {p1:json};
	$('#dgCert').datagrid({
		fit:true,
		border:false,
		fitColumns:false,
		toolbar:'#tbCert',
		url: "../CA.Ajax.Cfg.cls?OutputType=String&Class=CA.BL.Config&Method=QueryUserList",
		queryParams: param,
		idField:'UserID',
		singleSelect:true,
		pagination:true,
		rownumbers:true,
		pageSize:50,
		pageList:[2,10,30,50],
		beforePageText:'第',
		afterPageText:'页, 共{pages}页',
		displayMsg:'显示 {from} 到 {to} ,共 {total} 条记录',
		columns:[[
            {field:'UserID',title:'用户ID'},
			{field:'UserCode',title:'用户工号'},
			{field:'UserName',title:'用户姓名'},
            {
                field: 'IsCACert',
                title: '是否关联证书',
                align: 'center',
                width: 260,
                formatter: function(value,row,index) {
                    if (value == "已关联证书") {
                        //return "<span style='color:green'>已关联证书</span>"; 
	                    var str = '<a class="hisui-linkbutton l-btn l-btn-small l-btn-plain" style="width: 190px;" href="#" onclick="viewCertList('+row.UserID+')" group=""><span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">点击查看用户证书列表</span><span class="l-btn-icon icon-green-line-eye">&nbsp;</span></span></a>'
	                    return str;
                    } else {
                        return "<span style='color:red'>未关联证书</span>"; 
                    }
                }
            }
		]],
		onLoadError:function() {
			$.messager.alert("提示","用户列表数据加载失败");
		},
		onSelect:function(rowIndex,row){
			selectUserCode = row.UserCode;
		},
		onLoadSuccess:function(data){
			$("#dgCert").datagrid("clearSelections");
			selectUserCode = "";
		}
	});
}

function queryCert() {
	var userCode = $("#UserCode").val();
	var userName = $("#UserName").val();
    var userStatus = $('#UserStatus').combobox('getValue');
    var locID = $('#cbxLoc').combobox('getValue');
    if (locID == "undefined")
    {
        locID = "";
    }
	
	var para = "";
	//if ((userCode != "")||(userName != "")||(userStatus != "")||(locID != "")) {
	var obj = {UserCode:userCode,UserName:userName,UserStatus:userStatus,LocID:locID,HospID:selHospID};
	para = JSON.stringify(obj);
	//}
	
	$('#dgCert').datagrid('load',{
        p1:para
    });
}

function resetCondition() {
    $("#UserCode").val('');
    $("#UserName").val('');
    $('#cbxLoc').combobox('setValue','');
    $('#UserStatus').combobox('setValue','ALL');
}

function bindKeyCert() {
    var content = '<iframe id="bindKeyCertFrame" scrolling="auto" frameborder="0" src="dhc.certauth.cfg.certreg.csp?SignTypeCode=UKEY&VenderCode='+caInfo.DefaultUKEYVenderCode+'&UserCode='+selectUserCode+'&HospID='+selHospID+'&MWToken=' + getMWToken()+'" style="width:100%; height:100%;"></iframe>';
	createModalDialog("bindKeyCert","关联Ukey证书",880,620,'bindKeyCertFrame',content,'','');
}

function bindPhoneCert() {
    var content = '<iframe id="bindPhoneCertFrame" scrolling="auto" frameborder="0" src="dhc.certauth.cfg.certreg.csp?SignTypeCode=PHONE&VenderCode='+caInfo.DefaultPHONEVenderCode+'&UserCode='+selectUserCode+'&HospID='+selHospID+'&MWToken=' + getMWToken()+'" style="width:100%; height:100%;"></iframe>';
	createModalDialog("bindPhoneCert","关联手机证书",880,620,'bindPhoneCertFrame',content,'','');
}

function btnFaceCert() {
	var content = '<iframe id="bindFaceCertFrame" scrolling="auto" frameborder="0" src="dhc.certauth.cfg.certreg.csp?SignTypeCode=FACE&VenderCode='+caInfo.DefaultFACEVenderCode+'&UserCode='+selectUserCode+'&HospID='+selHospID+'&MWToken=' + getMWToken()+'" style="width:100%; height:100%;"></iframe>';
    createModalDialog("bindFaceCert","关联手机证书",880,620,'bindFaceCertFrame',content,'','');
}

function viewCertList(uerID) {
    var xpwidth=window.screen.width-400;
	var xpheight=window.screen.height-300;
	var content = '<iframe id="viewUserCertListFrame" scrolling="auto" frameborder="0" src="dhc.certauth.cfg.certmgr.csp?ViewCertUserID='+uerID+'&MWToken=' + getMWToken()+'" style="width:99%; height:99%;"></iframe>';
    createModalDialog("viewUserCertList","用户证书列表",xpwidth,xpheight,'viewUserCertListFrame',content,'','',true);
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