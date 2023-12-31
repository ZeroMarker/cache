function initPage(){
    initTemplateBox();
    initTemlateItemBox();
}

function initTemplateBox(){
    var columns=[[
        {title:"代码",field:"Code",width:120},
        {title:"名称",field:"Description",width:160},
        {title:"数据模块",field:"DataModuleDesc",width:120},
        {title:"元素ID",field:"ElementID",width:80}
    ]];

    $("#templateBox").datagrid({
        columns:columns,
        fit:true,
        title:"文本模板",
        iconCls:"icon-paper",
        headerCls:"panel-header-gray",
        toolbar:"#templateTools",
        pagination:false,
        rownumbers:true,
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.ConfigQueries;
            param.QueryName="FindTextTemplate";
            param.Arg1=$("#filterModule").combobox("getValue");
            param.ArgCnt=1;
        },
        onSelect:function(rowIndex,rowData){
            $("#templateForm").form("load",rowData);
            loadTextTemplateItems();
        }
    });

    $("#btnQuery").linkbutton({
        onClick:loadTextTemplates
    });

    $("#filterModule,#DataModule").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataModule";
            param.Arg1 = "";
            param.Arg2 = "";
            param.ArgCnt = 2;
        }
    });

    $("#btnAddTextTemplate").linkbutton({
        onClick:addTextTemplate
    });

    $("#btnEditTextTemplate").linkbutton({
        onClick:editTextTemplate
    });

    $("#btnDelTextTemplate").linkbutton({
        onClick:delTextTemplate
    });
}

function initTemlateItemBox(){
    var columns=[[
        {title:"模板描述",field:"Description",width:400}
    ]];

    $("#templateItemBox").datagrid({
        columns:columns,
        fit:true,
        title:"文本模板项",
        iconCls:"icon-paper",
        headerCls:"panel-header-gray",
        pagination:false,
        toolbar:"#templateItemTools",
        rownumbers:true,
        fitColumns:true,
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            var selectedTemplate=$("#templateBox").datagrid("getSelected");
            if(!selectedTemplate) return false;
            param.ClassName=ANCLS.BLL.ConfigQueries;
            param.QueryName="FindTextTemplateItem";
            param.Arg1="";
            param.Arg2=selectedTemplate.DataModule;
            param.ArgCnt=2;
        },
        onSelect:function(rowIndex,rowData){
            $("#templateItemForm").form("load",rowData);
            //loadTextTemplateItems();
        }
    })

    $("#btnAddTextTemplateItem").linkbutton({
        onClick:addTextTemplateItem
    });

    $("#btnEditTextTemplateItem").linkbutton({
        onClick:editTextTemplateItem
    });

    $("#btnDelTextTemplateItem").linkbutton({
        onClick:delTextTemplateItem
    });
}

function loadTextTemplates(){
    $("#templateBox").datagrid("reload");
}

function loadTextTemplateItems(){
    $("#templateItemBox").datagrid("reload");
}

function addTextTemplate(){
    var formData=$("#templateForm").serializeJson();
    formData.RowId="";
    formData.ClassName=ANCLS.Config.TextTemplate;
	if(!formData.Code || !formData.Description){
		$.messager.alert("提示","代码或名称不能为空","info");
		return;
	}
    var formDatas=[formData];
    var formDataStr=dhccl.formatObjects(formDatas);
    dhccl.saveDatas(ANCSP.DataListService,{
        jsonData:formDataStr
    },function(data){
        if(data.indexOf("S^")===0){
            loadTextTemplates();
            $("#templateForm").form("clear");
        }else{
            $.messager.alert("提示","新增文本模板失败，原因："+data,"error");
        }
    });
}

function editTextTemplate(){
    var selectedTemplate=$("#templateBox").datagrid("getSelected");
    if(!selectedTemplate){
        $.messager.alert("提示","请先选择一条文本模板，再进行修改。","warning");
        return;
    }
    var formData=$("#templateForm").serializeJson();
    formData.ClassName=ANCLS.Config.TextTemplate;
    var formDatas=[formData];
    var formDataStr=dhccl.formatObjects(formDatas);
    dhccl.saveDatas(ANCSP.DataListService,{
        jsonData:formDataStr
    },function(data){
        if(data.indexOf("S^")===0){
            loadTextTemplates();
            $("#templateForm").form("clear");
        }else{
            $.messager.alert("提示","修改文本模板失败，原因："+data,"error");
        }
    });
}

function delTextTemplate(){
    var selectedTemplate=$("#templateBox").datagrid("getSelected");
    if(!selectedTemplate){
        $.messager.alert("提示","请先选择一条文本模板，再进行删除。","warning");
        return;
    }
    $.messager.confirm("提示","是否要删除当前选择的文本模板？",function(r){
        if(r){
            var delRet=dhccl.removeData(ANCLS.Config.TextTemplate,selectedTemplate.RowId);
            if(delRet.indexOf("S^")===0){
                loadTextTemplates();
                $("#templateForm").form("clear");ß
            }else{
                $.messager.alert("提示","删除文本模板失败，原因："+data,"error");
            }
        }
    });
    
}

function addTextTemplateItem(){
    var selectedTemplate=$("#templateBox").datagrid("getSelected");
    if(!selectedTemplate){
        $.messager.alert("提示","请先选择一条文本模板，再进行添加。","warning");
        return;
    }
    var formData=$("#templateItemForm").serializeJson();
    formData.RowId="";
    formData.ClassName=ANCLS.Config.TextTemplateItem;
    formData.TextTemplate=selectedTemplate.RowId;
    formData.CreateUser=session.UserID;
    formData.UpdateUser=session.UserID;

    var formDatas=[formData];
    var formDataStr=dhccl.formatObjects(formDatas);
    dhccl.saveDatas(ANCSP.DataListService,{
        jsonData:formDataStr
    },function(data){
        if(data.indexOf("S^")===0){
            loadTextTemplateItems();
            $("#templateItemForm").form("clear");
        }else{
            $.messager.alert("提示","新增文本模板项失败，原因："+data,"error");
        }
    });
}

function editTextTemplateItem(){
    var selectedTemplate=$("#templateBox").datagrid("getSelected");
    if(!selectedTemplate){
        $.messager.alert("提示","请先选择一条文本模板，再进行修改。","warning");
        return;
    }
    var formData=$("#templateItemForm").serializeJson();
    formData.ClassName=ANCLS.Config.TextTemplateItem;
    formData.TextTemplate=selectedTemplate.RowId;
    formData.UpdateUser=session.UserID;
    var formDatas=[formData];
    var formDataStr=dhccl.formatObjects(formDatas);
    dhccl.saveDatas(ANCSP.DataListService,{
        jsonData:formDataStr
    },function(data){
        if(data.indexOf("S^")===0){
            loadTextTemplateItems();
            $("#templateItemForm").form("clear");
        }else{
            $.messager.alert("提示","修改文本模板项失败，原因："+data,"error");
        }
    });
}

function delTextTemplateItem(){
    var selectedTemplate=$("#templateItemBox").datagrid("getSelected");
    if(!selectedTemplate){
        $.messager.alert("提示","请先选择一条文本模板项，再进行删除。","warning");
        return;
    }
    $.messager.confirm("提示","是否要删除当前选择的文本模板项？",function(r){
        if(r){
            var delRet=dhccl.removeData(ANCLS.Config.TextTemplateItem,selectedTemplate.RowId);
            if(delRet.indexOf("S^")===0){
                loadTextTemplateItems();
                $("#templateItemForm").form("clear");
            }else{
                $.messager.alert("提示","删除文本模板项失败，原因："+data,"error");
            }
        }
    });
}

$(document).ready(initPage);

