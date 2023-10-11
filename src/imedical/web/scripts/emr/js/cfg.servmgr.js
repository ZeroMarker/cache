var selRowSrvID = "";
var selHospID = "";

$(function(){
    initBTN(); 
    initSelect();
    initSignType();
    initVenderCode();
    initCarPrvTp();
    
    if (parent.sysOption.IsOnMulityHospMgr == "1")
    {
		var hospComp = GenHospComp("CA.ConfigCommon",logonInfo.UserID+'^'+logonInfo.GroupID+'^'+logonInfo.CTLocID+'^');  
		hospComp.options().onSelect = function(){
			selHospID = hospComp.getValue()
			initCommon(selHospID);
		}
		hospComp.options().onLoadSuccess = function(){
			selHospID = hospComp.getValue()
			initCommon(selHospID);
		}
	}
	else
	{
		$("#_HospListLabel").hide();
		$("#_HospList").hide();
		selHospID = logonInfo.HospID;
		initCommon(selHospID);
	}
})

function initBTN() {
    $("#btnSaveCommon").click(function(){saveConfirm();});
}

//初始化是否选项
function initSelect() {
    var ret = [{"ID":"0","Text":"否"},{"ID":"1","Text":"是"}]; 
    initCombobox("IsCAOn",ret,false,false);
    initCombobox("AllCAOn",ret,false,false);
    initCombobox("LoginOnce",ret,false,false);
    initCombobox("IsLimitImageNull",ret,false,false);
    initCombobox("IsLimitImageSize",ret,false,false);
    initCombobox("PhoneImageConvertFlag",ret,false,false);
    initCombobox("IsAutoReloadImage",ret,false,false);
    initCombobox("IsHandSignCAON",ret,false,false);
    initCombobox("IsCAOnBySsgroup",ret,false,false);
    initCombobox("IsDisabledNoCert",ret,false,false);
}

//Desc:初始化配置可关闭CA的医护人员类型
function initCarPrvTp() {
    $('#DisabledCarPrvTp').combobox({
        url:"../CA.Ajax.Cfg.cls?OutputType=String&Class=CA.ConfigCTCarPrvTp&Method=GetAllType",
        valueField:'Text',  
        textField:'Text',
        width:160,
        panelHeight:350,
        multiple:true,
        selectOnNavigation:false,
        rowStyle:'checkbox', //显示成勾选行形式
        editable:false
    });
}

//初始化签名方式
function initSignType() {
    var data = ajaxDATA('String', 'CA.BL.Config', 'GetSignType');
    ajaxPOSTSync(data, function (ret) {
        if (ret != "")
        {
            var ret = $.parseJSON(ret);
            initCombobox("DefaultSignType",ret,false,true);
            initCombobox("SignTypeList",ret,true,false);
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
            initCombobox("DefaultUKEYVenderCode",ret,false,true);
            initCombobox("DefaultPHONEVenderCode",ret,false,true);
            initCombobox("DefaultFACEVenderCode",ret,false,true);
            initCombobox("DefaultHandSignVenderCode",ret,false,true);
        }
        else
        {
            $.messager.alert("提示","获取CA厂商数据错误!");
        }
    }, function (ret) {
        $.messager.alert("提示","CA.BL.Config.GetVenderCode Error:" + ret);
    });
}

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

function initCommon(selHospID) {
	selHospID = selHospID||"";
	if (selHospID == "")
	{
		$.messager.alert("提示","获取院区数据错误，无法加载对应院区配置数据!");	
		return;
	}
	
    var data = ajaxDATA('String', 'CA.BL.Config', 'GetCfgCommon',selHospID);
    ajaxPOST(data, function (ret) {
        if (ret != "")
        {
            var arr = $.parseJSON(ret);
            setCommon(arr);
			//updateTab();
        }else
        {
            $.messager.alert("提示","获取通用配置数据错误!");
        }
    }, function (ret) {
        $.messager.alert("提示","CA.BL.Config.GetCfgCommon Error:" + ret);
    });
}

function saveConfirm() {
    $.messager.confirm("提示", "是否确认修改基础配置？", function (r) {
        if (r) {
            saveCommon();
        }
    });
}

function saveCommon() {
	if ((selHospID == "")&&(parent.sysOption.IsOnMulityHospMgr == "1"))
	{
		$.messager.alert("提示","未选择院区，无法保存对应院区配置数据!");	
		return;
	}
	
    var Arr = [];
    pushArr(Arr,"IsCAOn","是否开启数字签名",$("#IsCAOn").combobox('getValue'));
    pushArr(Arr,"AllCAOn","是否全院开启数字签名",$("#AllCAOn").combobox('getValue'));
    pushArr(Arr,"LoginOnce","是否支持免密签名",$("#LoginOnce").combobox('getValue'));
    pushArr(Arr,"IsHandSignCAON","是否开启患者签名(手写板)",$("#IsHandSignCAON").combobox('getValue'));
    
    pushArr(Arr,"DefaultUKEYVenderCode","UKEY默认数字签名厂商代码",$("#DefaultUKEYVenderCode").combobox('getValue'));
    pushArr(Arr,"DefaultPHONEVenderCode","PHONE默认数字签名厂商代码",$("#DefaultPHONEVenderCode").combobox('getValue'));
    pushArr(Arr,"DefaultFACEVenderCode","FACE默认数字签名厂商代码",$("#DefaultFACEVenderCode").combobox('getValue'));
    pushArr(Arr,"DefaultHandSignVenderCode","患者签名厂商代码",$("#DefaultHandSignVenderCode").combobox('getValue'));
    
    pushArr(Arr,"DefaultSignType","默认数字签名方式代码",$("#DefaultSignType").combobox('getValue'));
    pushArr(Arr,"SignTypeList","可用签名方式代码列表",$("#SignTypeList").combobox('getText').replace(/,/g, '^'));
    pushArr(Arr,"IsLimitImageSize","是否限制图片大小",$("#IsLimitImageSize").combobox('getValue'));
    pushArr(Arr,"IsLimitImageNull","是否限制图片不能为空",$("#IsLimitImageNull").combobox('getValue')); ///$("#IsLimitImageNull").val());
    
    pushArr(Arr,"IsAutoReloadImage","是否自动更新签名图",$("#IsAutoReloadImage").combobox('getValue'));
    pushArr(Arr,"DisabledCarPrvTp","不开启CA的人员类型",$("#DisabledCarPrvTp").combobox('getText'));  //cbox.getText();
    pushArr(Arr,"PhoneImageConvertFlag","是否转换签名图格式",$("#PhoneImageConvertFlag").combobox('getValue'));
    pushArr(Arr,"IsCAOnBySsgroup","是否开启安全组管理",$("#IsCAOnBySsgroup").combobox('getValue'));
    
    pushArr(Arr,"IsDisabledNoCert","未关联证书的用户不启用CA",$("#IsDisabledNoCert").combobox('getValue'));
    
    var data = ajaxDATA('String', 'CA.BL.Config', 'SaveCfgCommon', JSON.stringify(Arr).replace(/\"/g,"'"),selHospID);
    ajaxPOSTSync(data, function (ret) {
        var d = $.parseJSON(ret);
        $.messager.alert("提示",d.retMsg);
    }, function (ret) {
        $.messager.alert("提示","SaveCfgCommon error:" + ret);
    });
}

function pushArr(Arr,ID,Desc,Value) {
    var obj = {
        "ID":ID,
        "Desc":Desc,
        "Value":Value
    }
    Arr.push(obj);  
}

function setCommon(data) {
	$("#SignTypeList").combobox('clear');
	$("#DisabledCarPrvTp").combobox('clear');
	
    $("#IsCAOn").combobox('select',data["IsCAOn"]);
    $("#AllCAOn").combobox('select',data["AllCAOn"]);
    $("#LoginOnce").combobox('select',data["LoginOnce"]);
    $("#IsHandSignCAON").combobox('select',data["IsHandSignCAON"]);

    $("#DefaultUKEYVenderCode").combobox('select',data["DefaultUKEYVenderCode"]);
    $("#DefaultPHONEVenderCode").combobox('select',data["DefaultPHONEVenderCode"]);
    $("#DefaultFACEVenderCode").combobox('select',data["DefaultFACEVenderCode"]);
    $("#DefaultHandSignVenderCode").combobox('select',data["DefaultHandSignVenderCode"]);
    
    $("#DefaultSignType").combobox('select',data["DefaultSignType"]);
    $("#IsLimitImageSize").combobox('select',data["IsLimitImageSize"]);
    $("#IsLimitImageNull").combobox('select',data["IsLimitImageNull"]);
    
    $("#PhoneImageConvertFlag").combobox('select',data["PhoneImageConvertFlag"]);
    $("#IsAutoReloadImage").combobox('select',data["IsAutoReloadImage"]);
    $("#IsCAOnBySsgroup").combobox('select',data["IsCAOnBySsgroup"]);
    $("#IsDisabledNoCert").combobox('select',data["IsDisabledNoCert"]);
    
    //$("#SignTypeList").combobox('select',data["SignTypeList"]);
    if (data["SignTypeList"] != ""){
        var signTypeListarr = data["SignTypeList"].split("^");
        for (var i=0;i<signTypeListarr.length;i++){
            $("#SignTypeList").combobox('select',signTypeListarr[i]);
        }
    }
    
    if (data["DisabledCarPrvTp"] != ""){
        var carPrvTparr = data["DisabledCarPrvTp"].split(",");
        for (var i=0;i<carPrvTparr.length;i++){
            $("#DisabledCarPrvTp").combobox('select',carPrvTparr[i]);
        }
    }
    //cbox.setValues([data["DisabledCarPrvTp"]]);
}