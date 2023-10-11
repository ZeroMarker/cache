$(function(){
    initCombobox();
});

function initCombobox()
{
    var data = ajaxDATA('String', 'EMRservice.BL.BLEMRTemplateGroup', 'GetEMRTemplateGroup', userLocID);
    ajaxPOSTSync(data, function (ret) {
        if(ret != "") setEMRTemplateGroup($.parseJSON("["+ret+"]"));
    }, function (ret) {
        alert('GetTemplateSet error:' + ret);
    });
}

function setEMRTemplateGroup(data)
{
    $('#templateRecord').combobox({
        valueField:'TemplateGroupCode',
        textField:'TemplateGroupName',
        width:200,
        height:22,
        panelHeight:'auto',
        data:data,
        onLoadSuccess:function()
        {
            if ($('#templateRecord').combobox('getValue') === "")
            {
                $('#templateRecord').combobox('select',data[0]["TemplateGroupCode"]);
            }
        },
        onSelect:function(record)
        {
            temparam = [];
            getTemplateData(record.TemplateGroupCode);
        }
    });
}

//获得模板
function getTemplateData(groupCode)
{
    var data = ajaxDATA('Stream', 'EMRservice.BL.BLEMRTemplateGroup', 'GetTempCateJsonByGroupCode', episodeID, groupCode);
    ajaxPOSTSync(data, function (ret) {
        if(ret != "") {
            setListTemplate($.parseJSON("["+ret+"]"));
        }
    }, function (ret) {
        alert('GetTempCateJsonByGroupCode error:' + ret);
    });
}

//加载列表模板数据
function setListTemplate(data)
{
    $('#listtemplate').datagrid({
        fitColumns:true, 
        loadMsg:'数据装载中......',
        autoRowHeight:true,
        data:data,
        singleSelect:true,
        idField:'id',
        sortName:'text',
        sortOrder:'desc',
        remoteSort:false,
        nowrap:true,
        striped:true,
        fit:true,
        overflow:'auto',
        columns:[[
            {field:'id',title:'id',hidden:true},
            {field:'text',title:'名称',width:200,sortable:true},
            {field:'quotation',hidden:true},
            {field:'documentType',hidden:true},{field:'chartItemType',hidden:true},
            {field:'categoryId',hidden:true},{field:'templateId',hidden:true},
            {field:'isLeadframe',hidden:true},{field:'isMutex',hidden:true},
            {field:'JaneSpell',hidden:true},{field:'FullFight',hidden:true},
            {field:'groupCode',hidden:true}
        ]],
        onLoadSuccess:function(data){
            setTemparam(data.rows);
        }
    });
}

function setTemparam(data)
{
    $.each(data,function(idx,val){
        temparam[idx] ={
            "id":"",
            "text":val.text,
            "pluginType":val.documentType,
            "chartItemType":val.chartItemType,
            "emrDocId":val.id,
            "templateId":val.templateId,
            "isLeadframe":val.isLeadframe,
            "isMutex":val.isMutex,
            "categoryId":val.categoryId,
            "actionType":"CREATE",
            "status":"NORMAL",
            "closable":true,
            "flag":"List",
            "args":{
                "spreading":{"action":"GroupCreation","groupCode":val.groupCode}
            }
        };
    });
}

//从模板组新建
function createTemplateGroup()
{
    if ($('#templateRecord').combobox('getValue') === "") {
        alert("请配置模板组数据！");
        return;
    }
    if (temparam.length == 0) {
        setTemparam($('#listtemplate').datagrid('getData').rows);
    }
    if (temparam.length == 0) {
        alert("请检查当前科室是否配置了相关模板组数据！");
        return;
    }
    //批量创建病历
    parent.CreateGroupTemplate(temparam);
    //CreateGroupDocumentLog(temparam,"EMR.Nav.RecordNav.CreateGroup");
}

//刷新
function refresh()
{
    window.location.reload();
}
