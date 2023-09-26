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
        url:'../EMRservice.Ajax.hisData.cls?PatientID='+ patientID +'&Action=GetEpisodeList',
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
            colwidth = (colwidth=="")?80:colwidth;
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
            separate = " "
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
    jQuery.ajax({
        type: "Post",
        dataType: "text",
        url: "../EMRservice.Ajax.hisData.cls",
        data: {
            "PatientID":patientID,
            "Action":"GetAllEpisodeIdByPatientId"
        },
        async: false,
        success: function(data) {
             $.each(eval(data),function(idx,val){
                 epsodeIds = (idx==0)?"":epsodeIds + ",";
                 epsodeIds = epsodeIds + val.EpisodeID;
            });
        },
        error : function(d) { 
            alert("GetViewDisplayData error");
        }
    });
    return epsodeIds;
}

//获取资源区页签的查询按钮设置
function getResourceConfig()
{
    var returnValue = "";
    jQuery.ajax({
        type: "Post",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLUserPageConfig",
            "Method":"GetResourceConfig",
            "p1":userID,
            "p2":userLocID
        },
        success: function(d) {
            if(d != "") returnValue = eval("["+d+"]")[0];
        },
        error : function(d) {
            alert("GetResourceConfig error");
        }
    });
    return returnValue;
}

//保存资源区页签的查询按钮设置
function saveResourceConfig(tabId)
{
    jQuery.ajax({
        type: "Post",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLUserPageConfig",
            "Method":"SaveResourceConfig",
            "p1":userID,
            "p2":userLocID,
            "p3":tabId,
            "p4":JSON.stringify(resourceConfig).replace(/\"/g,'""')
        },
        success: function(d) {
            if(d == "0")
            {
                alert("UnSaveResourceConfig");
            }
        },
        error : function(d) { 
            alert("SaveResourceConfig error");
        }
    });
}
