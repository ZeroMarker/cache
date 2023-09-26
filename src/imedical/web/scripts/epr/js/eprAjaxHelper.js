function AjaxReturn(url, data, type, async) {
    var result;
    if (data == null || data.length < 1) {
        $.ajax({
            type: type,
            dataType: "json",
            url: url,
            async: async,
            success: function(response) {
                //debugger;
                result = response;
                //result = Ext.util.JSON.encode(response);
            },
            error: function(d) {
                alert("读取后台数据错误，请稍后再试。");
                alert(response.responseText);
            }
        });
    } else {
        $.ajax({
            type: type,
            dataType: "json",
            url: url,
            data: data,
            async: async,
            success: function(response) {
                //debugger;
                result = response;
                //result = Ext.util.JSON.encode(response);
            },
            error: function(d) {
                alert("读取后台数据错误，请稍后再试。");
            }
        });
    }
    return result;
}