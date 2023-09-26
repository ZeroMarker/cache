//加载就诊列表
function initEpisodeList(comboName)
{
    $(comboName).combogrid({  
        panelWidth:450,  
        multiple: true,
        idField:'EpisodeID',  
        textField:'EpisodeID', 
        pagination:true, 
        url:'../EMRservice.Ajax.hisData.cls?PatientID='+ patientID +'&Action=GetEpisodeList',  
        columns:[[  
            {field:'ck',checkbox:true},
            {field:'EpisodeID',title:'就诊号',width:40},  
            {field:'EpisodeDate',title:'就诊日期',width:60},  
            {field:'DeptDesc',title:'就诊科室',width:100},  
            {field:'Diagnosis',title:'主要诊断',width:120}, 
            {field:'EpisodeType',title:'就诊类型',width:60}, 
            {field:'MainDocName',title:'就诊医生',width:80}, 
            {field:'EpisodeReason',title:'患者类型',width:60}, 
            {field:'DischargeDate',title:'出院日期',width:60}
        ]]  
    });    
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
        columns.push({field:code,title:desc,width:colwidth,hidden:hidden,sortable:sortable});
    });
    return [columns];
}

//引用Scheme
function getRefScheme(path)
{
    var refScheme = new Array();
    var showparent = $(strXml).find(path).each(function(){
        var code = $(this).find("code").text();
        var desc = $(this).find("desc").text();
        var separate = $(this).find("separate").text(); 
        if ("enter" == separate)
        {
            separate = "\n";
        }
        else if ("blackspace" == separate)
        {
            separate = " "
        }
        var check = $(this).find("check").text()=="N"?false:true; 
        refScheme.push({code:code,desc:desc,separate:separate,check:check});
    });
    return refScheme;
}