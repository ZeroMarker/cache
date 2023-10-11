$(function(){
    getSpechars();
});


//获取特殊字符
function getSpechars()
{
    $.ajax({
        type: "POST",
        dataType: "json",
        url: "../EMR.DOC.SRV.RequestCommon.cls?MWToken="+getMWToken(),
        async: false,
        cache: false,
        contentType: "text/plain",
        processData: false,
        data: JSON.stringify({
            action: "GET_SPECHARS",
            params:{
                langID: langID
            },
            product: product
        }),
        success: function (ret) {
            if("true" === ret.success){
                if (ret.errorCode){
                    $.messager.alert("提示", ret.errorMessage, "info");
                }else{
                    setSpechars(ret.data);
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

//初始化特殊字符
function setSpechars(data)
{
    for (var i=0;i<data.length;i++)
    {
        var content = $('<div class="content"></div>');
        for (var j=0;j<data[i].Values.length;j++)
        {
            $(content).append('<div id="'+data[i].Values[j].Code+'" onclick="select(this)">'+data[i].Values[j].Desc+'</div>');
        }
        if (i == data.length-1)
        {
            addTab(data[i].Code,data[i].Desc,content,false,true);
        }
        else
        {
            addTab(data[i].Code,data[i].Desc,content,false,false);
        }
    }
}

//增加tab标签
function addTab(id,title,content,closable,selected)
{
    $('#spechars').tabs('add',{
        id:id, 
        title:emrTrans(title),
        content:content,
        closable:closable,
        selected:selected
    });  
}

//选择特殊字符
function select(selectSpechar){
    var values = $("#selectValue").val();
    values = values + selectSpechar.innerText;
    $("#selectValue").val(values);
    var thisValue = selectSpechar.id;
    if (thisValue.indexOf("<SUP>") > 0)
    {
        if (thisValue.substring(0,thisValue.indexOf("<SUP>"))!="" )
        {
            selectValue.push({text:thisValue.substring(0,thisValue.indexOf("<SUP>"))});
        }
        if (thisValue.substring(thisValue.indexOf("<SUP>")+5,thisValue.indexOf("</SUP>"))!="" )
        {
            selectValue.push({text:thisValue.substring(thisValue.indexOf("<SUP>")+5,thisValue.indexOf("</SUP>")),sup:"true"});
        }
        if (thisValue.substring(thisValue.indexOf("</SUP>")+6)!="" )
        {
            selectValue.push({text:thisValue.substring(thisValue.indexOf("</SUP>")+6)});
        }
    }
    else
    {
        selectValue.push({text:thisValue});
    }
}

$("#sure").click(function(){
    if (selectValue.length > 0){
        parent.EmrEditor.syncExecute({
            action:"COMMAND",
            params:{
                text:[selectValue]
            },
            product: product
        });
    }
    closeWindow();
});

$("#clear").click(function(){
    $("#selectValue").val("");
    selectValue = [];
});

$("#close").click(function(){
    closeWindow();
});

//关闭窗口
function closeWindow()
{
    parent.closeDialog("spechars");
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