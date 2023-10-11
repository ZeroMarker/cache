function initDetail(){
    var data = {
        action: "GET_CASIGNDETAIL",
        params:{
            langID: langID,
            signID: signID
        },
        product: product
    };
    $.ajax({
        type: "GET",
        dataType: "json",
        url: "../EMR.DOC.SRV.RequestCommon.cls?MWToken="+getMWToken(),
        async: false,
        cache: false,
        data: {"paramdata":JSON.stringify(data)},
        success: function (ret) {
            if("true" === ret.success){
                if (ret.errorCode){
                    $.messager.alert("提示", ret.errorMessage, "info");
                }else{
                    loadData(ret.data);
                }
            }else{
                $.messager.alert("失败", "ajaxPOSTCommon:请求失败", "error");
            }
        },
        error: function (ret) {
            $.messager.alert("发生请求错误", "ajaxPOSTCommon error:"+JSON.stringify(ret), "error");
        }
        
    });
    
}

function loadData(data){
    $('#signValue').text(data["SignValue"]);
    $('#SignTimeStamp').text(data["SignTimeStamp"]);
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