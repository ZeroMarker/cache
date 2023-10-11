$(function()
{
    getLogDetail();
});
///获取日志操作记录数据
function getLogDetail(){
    var data = {
        action: "GET_DETAILLOG",
        params:{
            langID: langID,
            documentID: documentID
        },
        product: product
    };
    $.ajax({
        type: "POST",
        dataType: "json",
        url: "../EMR.DOC.SRV.RequestCommon.cls?MWToken="+getMWToken(),
        async: false,
        cache: false,
        contentType: "text/plain",
        processData: false,
        data: JSON.stringify(data),
        success: function (ret) {
            if("true" === ret.success){
                if (ret.errorCode){
                    $.messager.alert("提示", ret.errorMessage, "info");
                }else{
                    showLogDetail(ret.data);
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

///日志操作记录明细
function showLogDetail(data)
{
    $("#detailGrid").datagrid({
        fitColumns:true,
        loadMsg:'数据装载中......',
        autoRowHeight:true,
        data:data,
        singleSelect:true,
        idField:'OrderID',
        columns:[[
            {field:'OrderID',title:'顺序号',width:80,sortable:true,type:'int'},
            {field:'LoginUserName',title:'登录医师',width:100,sortable:true},
            {field:'OperUserName',title:'操作医师',width:100,sortable:true},
            {field:'OperDate',title:'操作日期',width:120,sortable:true},
            {field:'OperTime',title:'操作时间',width:120,sortable:true},
            {field:'MachineIP',title:'IP地址',width:120,sortable:true},
            {field:'Action',title:'操作名称',width:120,sortable:true},
            {field:'TplName',title:'模板名称',width:120,sortable:true,resizable: true,formatter: function(value,row,index){
                if(row.CASignID != ""){
                    return "<a href='#' style='text-decoration:none;color:blue;' onclick='openSignDetail("+'"'+row.CASignID+'"'+")'>"+value+"</a>";
                }else{
                    return value;
                }
            }},
            {field:'TplCreateDate',title:'创建日期',width:120,sortable:true},
            {field:'TplCreateTime',title:'创建时间',width:120,sortable:true},
            {field:'TplHappenDate',title:'记录日期',width:120,sortable:true},
            {field:'TplHappenTime',title:'记录时间',width:120,sortable:true},
            {field:'ProductSource',title:'产品模块',width:110,sortable:true}
        ]],
        onBeforeLoad:function(param){
            console.log(param);
        },
        onLoadSuccess:function(data){
            console.log(data);
        }
    });
}
function openSignDetail(signID){
    var iframeContent = '<iframe id="showSignDetail" scrolling="auto" frameborder="0" src="emr.bs.op.signDetail.csp?SignID='+signID+"&product="+product+"&MWToken="+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>'
    createModalDialog("HisuiShowSignDetail", "签名信息", 700, 350, iframeContent);
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

/// 创建HISUI-Dialog弹窗
function createModalDialog(dialogId, dialogTitle, width, height, iframeContent){
    $("body").append("<div id='"+dialogId+"'</div>");
    $HUI.dialog('#'+dialogId,{ 
        title: emrTrans(dialogTitle),
        width: width,
        height: height,
        cache: false,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        isTopZindex: true,
        content: iframeContent,
        onClose:function(){
            $("#"+dialogId).dialog("destroy");
        }
    });
}
