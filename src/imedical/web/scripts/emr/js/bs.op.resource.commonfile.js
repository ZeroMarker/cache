//加载就诊列表
function initEpisodeList(comboName)
{
    $(comboName).combogrid({  
        panelWidth:510,
        panelHeight:222,
        multiple: true,
        idField:'EpisodeID',  
        textField:'EpisodeID', 
        pagination:true, 
        url:'../EMR.DOC.SRV.RequestCommon.cls?PAGING=Y&MWToken='+getMWToken(),
        queryParams: {
            paramdata: JSON.stringify({
                action: "GET_EPISODE_LIST",
                params: {
                    langID: langID,
                    patientID: patientID
                },
                product: product
            })
        },
        columns:[[
            {field:'ck',checkbox:true},
            {field:'EpisodeID',title:'就诊号',width:60},  
            {field:'EpisodeDate',title:'就诊日期',width:100},  
            {field:'EpisodeDeptDesc',title:'就诊科室',width:100},  
            {field:'Diagnosis',title:'诊断',width:120}, 
            {field:'EpisodeType',title:'就诊类型',width:70}, 
            {field:'MainDocName',title:'就诊医生',width:80}, 
            {field:'EpisodeReason',title:'患者类型',width:70}, 
            {field:'DischargeDate',title:'出院日期',width:100}
        ]],
        onLoadSuccess:function(data)
        {
            //alert($('#allEpisode')[0].checked);
            /*
            if ($('#allEpisode')[0].checked)
            {
                $.each(data.rows,function(idx,val){
                if (idx < 5){
                    if (pageConfig == "Y")
                    {
                        $(comboName).combogrid('grid').datagrid('checkAll');
                    }
                        $(comboName).combogrid('grid').datagrid('checkRow',idx);
                    }
                });
                //alert("选择就诊");
            }
            */
        },
        onHidePanel:function()
        {
            onHidePanel();
        }
    });
    var panelObj = $(comboName).combogrid('panel').panel();
    panelObj.css("borderColor","#95B8E7");
}

///字符串传xml
function convertToXml(xmlString)
{ 
    var xmlDoc=null;
    //判断浏览器的类型
    //支持IE浏览器 
    if(!window.DOMParser && window.ActiveXObject){   //window.DOMParser 判断是否是非ie浏览器
        var xmlDomVersions = ['MSXML.2.DOMDocument.6.0','MSXML.2.DOMDocument.3.0','Microsoft.XMLDOM'];
        for(var i=0;i<xmlDomVersions.length;i++)
        {
            try
            {
                xmlDoc = new ActiveXObject(xmlDomVersions[i]);
                xmlDoc.async = false;
                xmlDoc.loadXML(xmlString); //loadXML方法载入xml字符串
                break;
            }catch(e){ }
        }
    }
    //支持Mozilla浏览器
    else if(window.DOMParser && document.implementation && document.implementation.createDocument)
    {
        try{
            /* DOMParser 对象解析 XML 文本并返回一个 XML Document 对象。
             * 要使用 DOMParser，使用不带参数的构造函数来实例化它，然后调用其 parseFromString() 方法
             * parseFromString(text, contentType) 参数text:要解析的 XML 标记 参数contentType文本的内容类型
             * 可能是 "text/xml" 、"application/xml" 或 "application/xhtml+xml" 中的一个。注意，不支持 "text/html"。
             */
            domParser = new  DOMParser();
            xmlDoc = domParser.parseFromString(xmlString, 'text/xml');
        }catch(e){}
    }
    else
    {
        return null;
    }

    return xmlDoc;
}

//表字段Scheme
function getColumnScheme(path)
{
    var columns = new Array();
    columns.push({field:'ck',checkbox:true})
    var showparent = $(strXml).find(path).each(function(){
        var code = $(this).find("code").text();
        var desc = $(this).find("desc").text();
        var sortable = $(this).find("sortable").text()=="Y"?true:false;
        var hidden = $(this).find("hidden").text()=="Y"?true:false; 
        var colwidth = $(this).find("width").text();
            colwidth = (colwidth=="")?85:colwidth;
        var check = $(this).find("check").text()=="N"?false:true; 
        if (sortable){
            columns.push({field:code,title:desc,width:colwidth,hidden:hidden,sortable:sortable,sorter:Sort,check:check});
        }else{
            columns.push({field:code,title:desc,width:colwidth,hidden:hidden,sortable:sortable,check:check});
        }
    });
    return [columns];
}

//排序
function Sort(a,b){
    a = a.split('/');
    b = b.split('/');
    if (a[2] == b[2]){
        if (a[0] == b[0]){
            return (a[1]>b[1]?1:-1);
        } else {
            return (a[0]>b[0]?1:-1);
        }
    } else {
        return (a[2]>b[2]?1:-1);
    }
}

//引用Scheme
function getRefScheme(path)
{
    var refScheme = new Array();
    var showparent = $(strXml).find(path).each(function(){
        var code = $(this).find("code").text();
        var desc = $(this).find("desc").text();
        var separate = $(this).find("separate").text(); 
        if (separate == "enter")
        {
            separate = "\n";
        }
        else if (separate == "blackspace")
        {
            separate = "\u00a0";
        }
        var check = $(this).find("check").text()=="N"?false:true; 
        refScheme.push({code:code,desc:desc,separate:separate,check:check});
    });
    return refScheme;
}

//获取就诊列表的所有就诊ID
function getAllEpisodeIdByPatientId()
{
    var epsodeIds = "";
    var data = {
        action: "GET_ALLEPISODEIDBYPATIENTID",
        params:{
            patientID: patientID
        },
        product: product
    };
    ajaxPOSTCommon(data, function(ret){
        if (ret){
            epsodeIds = ret;
        }
    }, function (error) {
        $.messager.alert("发生错误", "getAllEpisodeIdByPatientId error:"+error, "error");
    }, false);
    return epsodeIds;
}

//获取资源区页签的查询按钮设置
function getResourceConfig(configType)
{
    var returnValue = "";
    var data = {
        action: "GET_USER_CONFIG",
        params:{
            userID: userID,
            userLocID: userLocID,
            configType: configType
        },
        product: product
    };
    ajaxGETCommon(data, function(ret){
        if (ret){
            returnValue = ret;
        }
    }, function (error) {
        $.messager.alert("发生错误", "getResourceConfig error:"+error, "error");
    }, false);
    return returnValue;
}

//保存资源区页签的查询按钮设置
function saveResourceConfig(configType,configData)
{
    var data = {
        action: "SET_USER_CONFIG",
        params:{
            userID: userID,
            userLocID: userLocID,
            configType: configType,
            configData: configData
        },
        product: envVar.product
    };
    ajaxPOSTCommon(data, function(ret){
        if (!ret){
            console.log("保存用户配置数据失败！");
        }
    }, function (error) {
        $.messager.alert("发生错误", "saveResourceConfig error:"+error, "error");
    }, false);
}

//将HISUI系统日期或时间配置转为YYYY-MM-DD或HH:MM:SS格式
function getHISDateTimeFormate(type,value){
    var retvalue = "";
    
    var data = {
        action: "GET_STANDARD_DATE",
        params:{
            type: type,
            value: value
        },
        product: product
    };
    ajaxGETCommon(data, function(ret){
        if (ret){
            retvalue = ret;
        }
    }, function (error) {
        $.messager.alert("发生错误", "getHISDateTimeFormate error:"+error, "error");
    }, false);
    return retvalue; 
}

///日期比较
function compareDateTime(startDate, endDate)
{   
    var startDateTemp = startDate.split(" ");
    var endDateTemp = endDate.split(" ");

    var arrStartDate = startDateTemp[0].split("-");
    var arrEndDate = endDateTemp[0].split("-");

    var arrStartTime = startDateTemp[1].split(":");
    if (arrStartTime.length <3)
    {
        var len = 3- arrStartTime.length;
        for (i=0;i<len;i++)
        {
            arrStartTime.push(0);
        }
    }
    var arrEndTime = endDateTemp[1].split(":"); 
    if (arrEndTime.length <3)
    {
        var len = 3- arrEndTime.length;
        for (i=0;i<len;i++)
        {
            arrEndTime.push(0);
        }
    }

    var allStartDate = new Date(arrStartDate[0], arrStartDate[1], arrStartDate[2], arrStartTime[0], arrStartTime[1], arrStartTime[2]);   
    var allEndDate = new Date(arrEndDate[0], arrEndDate[1], arrEndDate[2], arrEndTime[0], arrEndTime[1], arrEndTime[2]);

    if (allStartDate.getTime() > allEndDate.getTime()) 
    {
        return false;
    }
    else
    {
        return true;
    }
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

function ajaxPOSTCommon(data, onSuccess, onError, isAsync) {
    isAsync = isAsync || false;
    if ("undefined" != typeof data.params){
        data.params.langID = langID;
    }else{
        data.params = {
            langID: langID
        };
    }
    $.ajax({
        type: "POST",
        dataType: "json",
        url: "../EMR.DOC.SRV.RequestCommon.cls?MWToken="+getMWToken(),
        async: isAsync,
        cache: false,
        contentType: "text/plain",
        processData: false,
        data: JSON.stringify(data),
        success: function (ret) {
            if("true" === ret.success){
                if (!onSuccess) {}
                else {
                    if (ret.errorCode){
                        $.messager.alert("提示", ret.errorMessage, "info");
                        onSuccess("");
                    }else{
                        onSuccess(ret.data);
                    }
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
                        $.messager.alert("提示", ret.errorMessage, "info");
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
