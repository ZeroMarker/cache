function ajaxPOSTCommon(param) {
	var data = param.data;
	var dataType = param.dataType||"json";
	var onSuccess = param.onSuccess;
	var onSuccessRes = param.onSuccessRes;
	var onError = param.onError
	var isAsync = param.isAsync||false;
    $.ajax({
        type: "POST",
        dataType: dataType,
        url: "../EMR.DOC.SRV.RequestCommon.cls",
        async: isAsync,
        cache: false,
        contentType: "text/plain",
        processData: false,
        data: JSON.stringify(data),
        success: function (ret) {
            if("true" === ret.success){
                if (typeof onSuccess==="function") 
                {
                    if (ret.errorCode){
                        $.messager.alert("数据请求失败提示", ret.errorMessage, "info");
                        onSuccess("");
                    }else{
                        onSuccess(ret.data);
                    }
                }else if(typeof onSuccessRes==="function"){
	                onSuccessRes(ret);
	            }
                
            }else{
                $.messager.alert("失败", "ajaxPOSTCommon:请求失败", "error");
            }
        },
        error: function (ret) {
            if (!onError) {
                $.messager.alert("发生请求错误", "ajaxPOSTCommon error:"+JSON.stringify(ret), "error");
            }else {
                onError(ret);
            }
        }
    });
}

function ajaxGETCommon(param) {
	var data = param.data;
	var dataType = param.dataType||"json";
	var onSuccess = param.onSuccess;
	var onSuccessRes = param.onSuccessRes;
	var onError = param.onError
	var isAsync = param.isAsync||false;
    $.ajax({
        type: "GET",
        dataType: dataType,
        url: "../EMR.DOC.SRV.RequestCommon.cls",
        async: isAsync,
        cache: false,
        data: {"paramdata":JSON.stringify(data)},
        success: function (ret) {
            if("true" === ret.success){
                if (typeof onSuccess==="function") 
                {
                    if (ret.errorCode){
                        $.messager.alert("数据请求失败提示", ret.errorMessage, "info");
                        onSuccess("");
                    }else{
                        onSuccess(ret.data);
                    }
                }else if(typeof onSuccessRes==="function"){
	                onSuccessRes(ret);
	            }
                
            }else{
                $.messager.alert("失败", "ajaxGETCommon:请求失败", "error");
            }
        },
        error: function (ret) {
            if (!onError) {
                $.messager.alert("发生请求错误", "ajaxGETCommon error:"+JSON.stringify(ret), "error");
            }else {
                onError(ret);
            }
        }
    });
}

function judgeIsIE() { //ie?
	if (!!window.ActiveXObject || "ActiveXObject" in window)
		return true;
	else
		return false;
}
//国际化改造获取翻译
function emrTrans(value)
{
    if (typeof $g == "function") 
    {
        value = $g(value)
    }
    return value;
}
//封装基础平台websys_getMWToken()方法
function getMWToken()
{
    try{
        if (typeof(websys_getMWToken) != "undefined")
            return websys_getMWToken();
        return "";
    }catch(e) {
        return "";
    }
}

