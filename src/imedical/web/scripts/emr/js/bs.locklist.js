$(function () {
    $("#type").combobox("setValue",product);
    setDataGrid();
});

//将病历锁数据加入列表
function setDataGrid()
{
    var param = getParam();
    $('#lockList').datagrid({
        fitColumns: true,
        loadMsg:'数据装载中......',
        autoRowHeight: true,
        singleSelect:true,
        idField:'ID',
        headerCls:'panel-header-gray', 
        url:'../EMR.DOC.SRV.RequestCommon.cls?PAGING=Y&MWToken='+getMWToken(),
        queryParams: param,
        rownumbers:true,
        pageSize:20,
        pageList:[10,20,30], 
        pagination:true,
        fit:true,
        columns:[[  
            {field:'ID',title:'ID',width:80,hidden: true},
            {field:'documentID',title:'documentID',width:80,hidden: true},
            {field:'UserID',title:'用户ID',width:80,hidden: true},
            {field:'UserCode',title:'用户代码',width:80,hidden: true},
            {field:'UserName',title:'用户名称',width:80},
            {field:'Computer',title:'计算机IP',width:80},
            {field:'LockDateTime',title:'锁定时间',width:100},
            {field:'EpisodeID',title:'就诊号',width:60,hidden: true},
            {field:'DOCCategoryCode',title:'业务活动记录分类编码',width:80,hidden: true},
            {field:'DOCCode',title:'业务活动记录编码',width:80,hidden: true},
            {field:'DocName',title:'病历标题',width:80},
            {field:'TemplateID',title:'模板ID',width:80,hidden: true},
            {field:'unLock',title:'操作', width: 70, formatter:formatOper}
        ]]
    });
}

//本用户添加解锁按钮
function formatOper(val,row,index)
{
    return '<a href="#" onclick="unLock('+"'"+row.documentID+"','"+index+"'"+')">'+emrTrans("解锁")+'</a>';  
}

//解锁
function unLock(lockedDocumentID,index)
{
    var rowIndex = index;
    var text = emrTrans("真的要解锁吗?");
    $.messager.confirm("操作提示", text, function (data) {
        if (!data){
           return;
        }else {
            var data = {
                action: "UN_LOCK",
                params: {
                    documentID: lockedDocumentID,
                    sessionID: ""
                },
                product: product
            };
            ajaxGETCommon(data, function(ret){
                if (ret == "1"){
                    $('#lockList').datagrid('deleteRow',rowIndex); 
                }else{
                    $.messager.alert("简单提示", "解锁失败！", "error");
                }
            }, function (error) {
                $.messager.alert("发生错误", "unLock error:"+error, "error");
            }, false);
        }
    });
}

//查询数据
function queryData(){
    var type = $("#type").combobox("getValue");
    /*if (type === ""){
        $.messager.alert("提示信息", "请选择类型后再查询！", 'info');
        return;
    }*/
    //product = type;
    var param = getParam();
    if (param){
        $.messager.progress({
            title: '提示',
            msg: '数据查询中，请稍候……',
            text: '查询中……'
        });
        $('#lockList').datagrid('load',param);
        $.messager.progress('close');
    }
}

//获取查询参数
function getParam()
{
    var param = {
        paramdata: JSON.stringify({
            action: "GET_LOCKLIST",
            params: {
                langID: langID,
                userName: $("#userName").val(),
                ipAddress: $("#ipAddress").val(),
                docName: $("#docName").val(),
                type: $("#type").combobox("getValue")
            },
            product: product
        })
    };
    return param;
}

function ajaxGETCommon(data, onSuccess, onError, isAsync) {
    isAsync = isAsync || false;
    if ("undefined" != typeof data.params){
        data.params.langID = langID;
    }else{
        data.params = {
            langID: langID
        };
    }
    $.ajax({
        type: "GET",
        dataType: "json",
        url: "../EMR.DOC.SRV.RequestCommon.cls?MWToken="+getMWToken(),
        async: isAsync,
        cache: false,
        data: {"paramdata":JSON.stringify(data)},
        success: function (ret) {
            if("true" === ret.success){
                if (!onSuccess) {}
                else {
                    if (ret.errorCode){
                        $.messager.alert("数据请求失败提示", ret.errorMessage, "info");
                        onSuccess("");
                    }else{
                        onSuccess(ret.data);
                    }
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

