var selRowSrvID = "";
var selRowIndex = "";

$(function(){
	initBTN(); 
    initSelect();
    initSignType();
    initVenderCode();
    initSrvGrid();
});

function initBTN() {
    $("#btnSave").click(function(){SaveCheck();});
    $("#btnReset").click(function(){reSet();});
    $("#btnDelSrv").click(function(){delSrv();});
    $("#btnTestSrv").click(function(){testSrv();});
    $("#btnRefresh").click(function(){refreshSrv();});
    
    $("#PatSignOption").click(function(){SetPatSignOption();});
}

//初始化是否选项
function initSelect() {
    var ret = [{"ID":"0","Text":"否"},{"ID":"1","Text":"是"}]; 
    initCombobox("QRCodeNeedUserCode",ret,false,false);
    initCombobox("EnablePinLogon",ret,false,false);
    initCombobox("EnableFaceLogon",ret,false,false);
    initCombobox("EnablePushSign",ret,false,false);
}

//初始化签名方式
function initSignType() {
    var data = ajaxDATA('String', 'CA.BL.Config', 'GetSignType');
    ajaxPOSTSync(data, function (ret) {
        if (ret != "")
        {
            var ret = $.parseJSON(ret);
            initCombobox("SignTypeCode",ret,false,false);
        }
        else
        {
            $.messager.alert("提示","获取签名方式数据错误!");
        }
    }, function (ret) {
        $.messager.alert("提示","CA.BL.Config.GetSignType Error:" + ret);
    });
}

//初始化CA厂商代码
function initVenderCode() {
    var data = ajaxDATA('String', 'CA.BL.Config', 'GetVenderCode');
    ajaxPOSTSync(data, function (ret) {
        if (ret != "")
        {
            var ret = $.parseJSON(ret);
            initCombobox("VenderCode",ret,false,false);
        }
        else
        {
            $.messager.alert("提示","获取CA厂商数据错误!");
        }
    }, function (ret) {
        $.messager.alert("提示","CA.BL.Config.GetVenderCode Error:" + ret);
    });
}

//combox初始化数据公用方法
function initCombobox(id,data,isMultiple,isEditable) {
    $('#'+id).combobox({
        data:data,
        valueField:'ID',  
        textField:'Text',
        width:160,
        panelHeight:350,
        multiple:isMultiple,
        selectOnNavigation:false,
        rowStyle:(isMultiple == true)?"checkbox":"",   //'checkbox', //显示成勾选行形式
        editable:(isEditable == true)
    });
}

//重置按钮触发
function reSet() {
    resetServiceInfo();
    refreshSrv();
}

//刷新服务列表
function refreshSrv() {
    $('#dgSrv').datagrid('load',{
        p1:{}
    });
}

//刷新详细信息填报页
function resetServiceInfo()
{
	$("#VenderCode").combobox('clear');
    $("#SignTypeCode").combobox('clear');
    $("#QRCodeType").combobox('clear');
    $("#QRCodeNeedUserCode").combobox('clear');
	$("#EnablePinLogon").combobox('clear');
	$("#EnablePushSign").combobox('clear');    
    $("#EnableFaceLogon").combobox('clear');
    
    $("#CALocation").val('');
 	$("#TSLocation").val('');
 	$("#CILocation").val('');
 	$("#VerifyLocation").val('');
 	$("#ImageLocation").val('');
 	$("#AppID").val('');
 	$("#AppKey").val('');
 	$("#ProjectID").val('');
 	$("#OrganizationCode").val('');
 	$("#CallBackUrl").val('');
 	$("#ScanQRCodeAPPName").val('');
 }

//删除按钮触发
function delSrv() {
    if (selRowSrvID == "")         
    {
        $.messager.alert("提示","请先选择一条数据");
        return;
    }
    $.messager.confirm("删除", "注意，删除后数据无法找回，是否确认删除数据？", function (r) {
        if (r) {
            var data = ajaxDATA('String', 'CA.BL.Config', 'DeleteServiceCfg', selRowSrvID);
            ajaxPOSTSync(data, function (ret) {
                var d = $.parseJSON(ret);
                $.messager.alert("提示",d.retMsg);
                reSet();
            }, function (ret) {
                $.messager.alert("提示","DeleteServiceCfg error:" + ret);
            });        
        }
    });
}

//保存按钮触发
function SaveCheck() {
	var VenderCode = $("#VenderCode").combobox('getValue');
	var SignTypeCode = $("#SignTypeCode").combobox('getValue');
	var CALocation = $("#CALocation").val();
	
	if (VenderCode == ""){
		$.messager.alert("提示","厂商代码必填");
		return;
	}
	
	if (SignTypeCode == ""){
		$.messager.alert("提示","签名方式必填");
		return;
	}
	
	if (CALocation == ""){
		$.messager.alert("提示","签名服务地址必填");
		return;
	}
	
	if (selRowSrvID != "")
	{
		$.messager.confirm("提示", "保存后会覆盖之前的配置数据，是否确认保存？", function (r) {
			if (r) {
				ReSaveConfirm(VenderCode,SignTypeCode);
			}
		});
	}
	else
	{
		ReSaveConfirm(VenderCode,SignTypeCode);
	}
}

//同一厂商同一签名方式校验
function ReSaveConfirm(VenderCode,SignTypeCode) {
	var data = ajaxDATA('String', 'CA.ConfigService', 'GetIDByCode', VenderCode, SignTypeCode);
    ajaxPOST(data, function (ret) {
        if (ret != "")
        {
			$.messager.confirm("提示", "已存在同厂商同签名类型的配置数据，再次保存会覆盖之前的配置数据，是否继续保存？", function (r) {
				if (r) {
					Save();
				}
			});
        }
        else
        {
            Save();
        }
    }, function (ret) {
        $.messager.alert("提示","CA.ConfigService.GetIDByCode Error:" + ret);
    });
}

function Save() {
	var obj = {
		CAServiceID: selRowSrvID,
		VenderCode: $("#VenderCode").combobox('getValue'),
		SignTypeCode: $("#SignTypeCode").combobox('getValue'),
		CALocation: $("#CALocation").val(),
		TSLocation: $("#TSLocation").val(),
		CILocation: $("#CILocation").val(), 
		VerifyLocation : $("#VerifyLocation").val(),
		ImageLocation : $("#ImageLocation").val(),
		AppID: $("#AppID").val(), 
		AppKey: $("#AppKey").val(), 
		ProjectID: $("#ProjectID").val(), 
		OrganizationCode: $("#OrganizationCode").val(),
		QRCodeType: $("#QRCodeType").combobox('getValue'),
		QRCodeNeedUserCode: $("#QRCodeNeedUserCode").combobox('getValue'),
		EnablePinLogon: $("#EnablePinLogon").combobox('getValue'), 
		EnablePushSign: $("#EnablePushSign").combobox('getValue'),
		CallBackUrl:$("#CallBackUrl").val(),
		EnableFaceLogon: $("#EnableFaceLogon").combobox('getValue'),
		ScanQRCodeAPPName: $("#ScanQRCodeAPPName").val(),
		PatSignOption:$("#PatSignOption").text()
	};

	var data = ajaxDATA('String', 'CA.BL.Config', 'SaveServiceCfg', JSON.stringify(obj).replace(/\"/g,"'"));
    ajaxPOSTSync(data, function (ret) {
    	var d = $.parseJSON(ret);
        $.messager.alert("提示",d.retMsg);
        reSet();
    }, function (ret) {
        $.messager.alert("提示","SaveServiceCfg error:" + ret);
    });
}

//加载已维护厂商信息
function initSrvGrid() {
    var param = {};
    $('#dgSrv').datagrid({
        fit:true,
        border:false,
        fitColumns:false,
        toolbar:'#tbSrv',
        url: "../CA.Ajax.Cfg.cls?OutputType=String&Class=CA.BL.Config&Method=GetCfgSrv",
        queryParams: param,
        singleSelect:true,
        columns:[[
            {field:'ID',title:'ID'},
            {field:'VenderCode',title:'CA服务厂商代码',align:'center',editor:'text'},
            {field:'SignTypeCode',title:'签名类型代码',align:'center',editor:'text'},
            {field:'CALocation',title:'签名服务地址',width:300,align:'center',editor:'text'},
            {field:'TSLocation',title:'时间戳服务地址',width:300,align:'center',editor:'text'},
            {field:'CILocation',title:'证书信息服务地址',width:280,align:'center',editor:'text'},
            {field:'VFLocation',title:'签名验证服务地址',width:300,align:'center',editor:'text'},
            {field:'IMLocation',title:'签章服务地址',width:280,align:'center',editor:'text'} //,
            /*{field:'AppID',title:'应用ID',hidden:true},
            {field:'AppKey',title:'应用秘钥',hidden:true},
            {field:'OrganizationCode',title:'组织机构代码',hidden:true},
            {field:'ProjectID',title:'项目ID',hidden:true},
            {field:'QRCodeType',title:'二维码类型',hidden:true},
            {field:'QRCodeNeedUserCode',title:'二维码是否指定用户工号',hidden:true},
            {field:'EnablePinLogon',title:'是否支持Pin码登录',hidden:true},
            {field:'EnablePushSign',title:'是否支持推送签名',hidden:true},
            {field:'CallBackUrl',title:'开放给CA的回调方法Url地址',hidden:true},
            {field:'EnableFaceLogon',title:'是否支持人脸识别登录',hidden:true},
            {field:'ScanQRCodeAPPName',title:'扫码APP名称或描述',hidden:true},*/
        ]],        
        onDblClickRow:function(rowIndex,row){
        },
        onSelect:function(rowIndex,row){
            if (selRowIndex === rowIndex)
	        {
		        $("#dgSrv").datagrid("unselectRow",rowIndex);
		        selRowSrvID = "";
				selRowIndex = "";
		        resetServiceInfo();
	        }
	        else
	        {
		        selRowIndex = rowIndex; 
		        selRowSrvID = row.ID;
	            setSrvInfo(row);
	        }
        },
        onLoadSuccess:function(data){
			$("#dgSrv").datagrid("clearSelections");
			selRowSrvID = "";
			selRowIndex = "";
		}
    });
}

//填充内容
function setSrvInfo(data) {
	$("#VenderCode").combobox('select',data["VenderCode"]);
	$("#SignTypeCode").combobox('select',data["SignTypeCode"]);
	
	$("#CALocation").val(data["CALocation"]);
	$("#TSLocation").val(data["TSLocation"]);
	$("#CILocation").val(data["CILocation"]);
	$("#VerifyLocation").val(data["VFLocation"]);	
	$("#ImageLocation").val(data["IMLocation"]);
	
	$("#AppID").val(data["AppID"]);
	$("#AppKey").val(data["AppKey"]);
	$("#ProjectID").val(data["ProjectID"]);
	$("#OrganizationCode").val(data["OrganizationCode"]);
	
	$("#QRCodeType").combobox('select',data["QRCodeType"]);
	$("#QRCodeNeedUserCode").combobox('select',data["QRCodeNeedUserCode"]);
	$("#EnablePinLogon").combobox('select',data["EnablePinLogon"]);
	$("#EnableFaceLogon").combobox('select',data["EnableFaceLogon"]);
	$("#EnablePushSign").combobox('select',data["EnablePushSign"]);
	$("#CallBackUrl").val(data["CallBackUrl"]);
	$("#ScanQRCodeAPPName").val(data["ScanQRCodeAPPName"]);
	
	if (data["HandSignOption"] == "") {
		$("#PatSignOption").html("{\"supportSignType\":\"\",\"positionType\":\"\",\"enableGroupKeyWord\":\"0\"}");
	} else {
		$("#PatSignOption").html(data["HandSignOption"]);
	}
}

//测试按钮触发
function testSrv() {
	if (selRowSrvID == "")         
    {
        $.messager.alert("提示","请先选择一条数据");
        return;
    }
   
	var VenderCode = $("#VenderCode").combobox('getValue');
	var SignTypeCode = $("#SignTypeCode").combobox('getValue');
	if (SignTypeCode == "UKEY")
	{
		var url = "dhc.certauth.cfg.testukey2.csp?venderCode="+VenderCode+"&MWToken="+getMWToken();
	}
	else if (SignTypeCode = "PHONE")
	{
		var url = "dhc.certauth.cfg.testphone.csp?venderCode="+VenderCode+"&MWToken="+getMWToken();
	}
	else
	{
		$.messager.alert("提示","所选数据为未知签名方式:"+SignTypeCode);
        return;
	}
	
	var xpwidth=window.screen.width-400;
	var xpheight=window.screen.height-300;
	var content = '<iframe id="testSrvFrame" scrolling="auto" frameborder="0" src="'+url+'" style="width:99%; height:99%;"></iframe>';
    createModalDialog("testSrv","测试CA服务",xpwidth,xpheight,'testSrvFrame',content,'','');
}

function SetPatSignOption() {
	if (selRowSrvID == "")         
    {
        $.messager.alert("提示","请先选择一条数据");
        return;
    }
    
    var callback = function (ret,arr)
    {
		if (ret != "")
		$("#PatSignOption").html(ret);    
	}
    
    var patSignOption = $("#PatSignOption").text();
    var url = "dhc.certauth.cfg.servreg.patsignoption.csp?patSignOption="+base64encode(utf16to8(escape(patSignOption)))+"&MWToken="+getMWToken();
    var content = '<iframe id="setPatSignOptionFrame" scrolling="auto" frameborder="0" src="'+url+'" style="width:99%; height:99%;"></iframe>';
    createModalDialog("setPatSignOption","配置患者签名详细参数",1000,420,'setPatSignOptionFrame',content,callback,'',false,false);
	
}