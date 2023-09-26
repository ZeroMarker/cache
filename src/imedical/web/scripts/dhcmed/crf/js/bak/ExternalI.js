//外部数据接口实体类（传递数据用）
var ExternalObj = function () {
    this.ID = "DHC" + $("#selDEItem").find("[value='" + $("#selDEItem").val() + "']").attr("pid") + "DHC" + $("#selDEItmProp").find("[value='" + $("#selDEItmProp").val() + "']").attr("pid") + "DHC" + $("#selDECategory").val(); // 唯一标识
    this.CatID = $("#selDECategory").val();                                                               //查询范围ID
    this.ClassName = $("#selDECategory").find("[value='" + this.CatID + "']").attr("CSName");             //查询类
    this.ItemCode = $("#selDEItem").val();                                                                //查询项代码
    this.ItemProp = $("#selDEItmProp").val();                                                             //查询项属性
}

//还原外部数据接口
function InitExternalDataInterface() {
    var obj = fcpubdata.obj[0];
    var exObjStr = $(obj).attr("ExternalDataInterfaceConfig");
    if (exObjStr != null && exObjStr != "") {
        var curConfig = eval("(" + exObjStr + ")");
        if (curConfig != null) {
            $("#selDECategory").val(curConfig.CatID);

            $("#selDECategory").change();
            $("#selDEItem").val(curConfig.ItemCode);
            $("#selDEItmProp").val(curConfig.ItemProp);
            $("#selDEItmProp").change();
        }
    }

}

function InitExConfig() {
    //初始化查询范围
    AjaxInvoke(fcpubdata.path + "/DECategory.do/GetAll", null, "POST", function (ret) {
        if (ret.Result) {
            var innerStr = "<option value='' CSName=''></option>";
            $(ret.DataObject).each(function (i, d) {
                innerStr += "<option value='" + d.ID + "' CSName='" + d.ClassName + "'>" + d.Name + "</option>";
            });
            $("#selDECategory").html(innerStr);
        }
    }, false);

    //查询范围改变事件->查询查询范围对应的查询项和项属性
    $("#selDECategory").change(function () {
        var curId = $("#selDECategory").val();
        if (curId == "") {
            $("#selDEItem").html("");
            $("#selDEItmProp").html("");
            return;
        }
        AjaxInvoke(fcpubdata.path + "/DEItem.do/GetForSelectByCategoryID", { CatID: curId }, "POST", function (ret) {
            if (ret.Result) {
                var innerStr = "<option value=''></option>";
                $(ret.DataObject).each(function (i, d) {
                    innerStr += "<option title='" + d.Name + "' value='" + d.Code + "' pid='" + d.ID + "'>" + d.Name + "</option>";
                });
                $("#selDEItem").html(innerStr);
            }
        }, false);
        AjaxInvoke(fcpubdata.path + "/DEItmProp.do/GetByCategoryID", { CID: curId }, "POST", function (ret) {
            if (ret.Result) {
                var innerStr = "<option value=''></option>";
                $(ret.DataObject).each(function (i, d) {
                    innerStr += "<option title='" + d.Name + "' value='" + d.Code + "' pid='" + d.ID + "'>" + d.Name + "</option>";
                });
                $("#selDEItmProp").html(innerStr);
            }
        }, false);
    });
    //不为空时设置外部接口对象
    $("#selDEItmProp,#selDEItem").change(function () {
        if ($("#selDECategory").val() == null || $("#selDEItem").val() == null || $("#selDEItmProp").val() == null) {
            return;
        }
        if ($("#selDECategory").val() == "" || $("#selDEItem").val() == "" || $("#selDEItmProp").val() == "") {
            return;
        }
        $("#ExternalDataConfig").val($.toJSON(new ExternalObj()));
    });

}