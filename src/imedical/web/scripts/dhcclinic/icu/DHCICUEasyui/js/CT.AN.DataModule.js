/**
 * 初始化查询条件
 */
function initQueryOptions(){
    $("#filterParent,#ParentModule,#RelateModule").combobox({
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

    $("#btnQuery").linkbutton({
        onClick: function() {
            $("#dataBox").treegrid("reload")
        }
    });

    $("#EditStatus").combobox({
        valueField:"RowId",
        textField:"Description",
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.CodeQueries;
            param.QueryName="FindOperStatus";
            param.ArgCnt=0;
        },
        multiple:true,
        rowStyle:"checkbox"
    });
}

/**
 * 初始化编辑表单
 */
function initDataForm(){
    $("#MenuModule").combobox({
        valueField:"value",
        textField:"text",
        editable:false,
        data:CommonArray.WhetherOrNot
    });

    $("#Active,#Archive,#CASign").combobox({
        valueField:"value",
        textField:"text",
        editable:false,
        data:CommonArray.WhetherOrNot
    });
}

/**
 * 初始化数据表格
 */
function initDataBox(){
    var operStatusList = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.CodeQueries,
        QueryName: "FindOperStatus",
        ArgCnt: 0
    }, "json");

    $("#dataBox").treegrid({
        border:false,
        idField: "RowId",
        treeField: "Description",
        //title: "数据模块",
        columns: [
            [
                {field:'operate1',title:'删除',align:'center',width:50,
                formatter:function(value, row, index){ 
                var str = '<a href="#" id="btnremove" class="hisui-linkbutton" onClick="CancelRefusedOper(\''+dataForm+'\',\''+row.RowId+'\')" "></a>';
                return str;
                }
                },
                { field: "Description", title: "名称", width: 240 },
                { field: "Code", title: "代码", width: 120 },
                { field: "ParentModuleDesc", title: "父模块", width: 120 },
                { field: "URL", title: "链接URL", width: 240 },
                { field: "MenuModuleDesc", title: "菜单", width: 48 },
                { field: "Icon", title: "图标", width: 80 },
                { field: "ActiveDesc", title: "激活", width: 48 },
                { field: "ArchiveDesc", title: "归档", width: 48 },
                { field: "ArchiveCode", title: "归档代码", width: 120 },
                { field: "CASignDesc", title: "CA签名", width: 62 },
                //{ field: "DetailUrl", title: "浏览URL", width: 240 },
                { field: "SeqNo", title: "排序号", width: 80 },
                { field: "EditStatusDesc", title: "可编辑状态", width: 180 } ,
                { field: "RelateModuleDesc", title: "关联模块", width: 240 }
            ]
        ],
        onLoadSuccess: function(data) {
          
            $("a[id='btnremove']").linkbutton({plain:true,iconCls:'icon-cancel'}); 
        },
        onBeforeLoad:function(row,param){
            param.ClassName=ANCLS.BLL.CodeQueries;
            param.QueryName="FindDataModule";
            param.Arg1=$("#filterDesc").val();
            param.Arg2=$("#filterParent").combobox("getValue");
            param.ArgCnt=2;
        },
        
        onSelect:function(rowIndex,rowData){
            $("#dataForm").form("load",rowData);
            var EditStatus=rowData.EditStatus.split(",");
            $("#EditStatus").combobox("setValues",EditStatus);
        },
        fit: true,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        toolbar: "#dataTools",
        url: ANCSP.DataQuery,
        pageSize: 200,
        pageList: [50, 100, 200],
        headerCls: "panel-header-gray"
    });

    //$("#dataBox").treegrid("enableCellEditing");
}
/**
 * 初始化操作按钮
 */
function initOperActions(){
    $("#btnAdd").linkbutton({
        onClick: function() {
            if ($("#dataForm").form("validate")){
                let formData=$("#dataForm").serializeJson();
                if(formData){
                    formData.RowId="";
                    formData.ClassName=ANCLS.Code.DataModule;
                    let formDatas=[formData];
                    let formDataStr=dhccl.formatObjects(formDatas);
                    dhccl.saveDatas(ANCSP.DataListService,{
                        jsonData:formDataStr
                    },function(data){
                        if(data.indexOf("S^")===0){
                            $("#dataBox").treegrid("reload");
                            reloadQueryOptions();
                        }else{
                            $.messager.alert("提示","新增失败，原因："+data);
                        }
                    });
                }
            }
        }
    });

    $("#btnEdit").linkbutton({
        onClick: function() {
            if(dhccl.hasRowSelected($("#dataBox"),true) && $("#dataForm").form("validate")){
                let formData=$("#dataForm").serializeJson();
                if(formData){
                    var EditStatus=$("#EditStatus").combobox("getValues");
                    formData.EditStatus=EditStatus.join(",");
                    formData.ClassName=ANCLS.Code.DataModule;
                    let parentModule=$("#ParentModule").combobox("getValue");
                    formData.ParentModule=parentModule;
                    let RelateModule=$("#RelateModule").combobox("getValue");
                    formData.RelateModule=RelateModule;
                    let formDatas=[formData];
                    let formDataStr=dhccl.formatObjects(formDatas);
                    dhccl.saveDatas(ANCSP.DataListService,{
                        jsonData:formDataStr
                    },function(data){
                        if(data.indexOf("S^")===0){
                            $("#dataBox").treegrid("reload");
                            reloadQueryOptions();
                        }else{
                            $.messager.alert("提示","修改失败，原因："+data);
                        }
                    });
                }
            }
        }
    });

    $("#btnDel").linkbutton({
        onClick: function() {
            if(dhccl.hasRowSelected($("#dataBox"),true)){
                let formData=$("#dataForm").serializeJson();
                let ret=dhccl.removeData(ANCLS.Code.DataModule,formData.RowId);
                if(ret.indexOf("S^")===0){
                    $("#dataBox").treegrid("reload");
                    reloadQueryOptions();
                }else{
                    $.messager.alert("提示","删除失败，原因："+data);
                }
            }
        }
    });

    $("#btnPrintTemplate").linkbutton({
        onClick:function(){
            if(dhccl.hasRowSelected($("#dataBox"),true)){
                let rowData=$("#dataBox").treegrid("getSelected");
                let url="CF.AN.PrintTemplate.csp?moduleId="+rowData.RowId+"&moduleCode="+rowData.Code+"&archiveCode="+rowData.ArchiveCode;
                //let href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
                //$("#prtTemplateDialog").dialog({
                //    content:href,
                //    title:"打印模板设计器-"+rowData.Description
                //});
                //$("#prtTemplateDialog").dialog("open");
                window.open(url, "_blank");
            }
        }
    });
    $("#btnOpAction").linkbutton({
        onClick:function(){
            if(dhccl.hasRowSelected($("#dataBox"),true)){
                let rowData=$("#dataBox").treegrid("getSelected");
                let url="CT.AN.OperAction.csp?moduleId="+rowData.RowId;
                 let href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
                $("#OperActionDialog").dialog({
                    content:href
                });
                $("#OperActionDialog").dialog("open");
            }
        }
    });
}
function CancelRefusedOper(dataForm,index) {
    $.messager.confirm("确认", "是否删除该数据记录？", function(result) {
    if (result) {
        ////alert(dataForm.datamodel.type);
             var msg = dhccl.removeData(ANCLS.Code.DataModule, index);
          dhccl.showMessage(msg, "删除", null, null, function() {
            $("#dataBox").treegrid('reload');
            });
      }
    });
 }
function initPage(){
    initQueryOptions();
    initDataBox();
    initDataForm();
    initOperActions();
}

function reloadQueryOptions() {
    let filterDesc=$("#filterDesc").val();
    let filterParent=$("#filterParent").combobox("getValue");
    
    $("#dataForm").form("clear");
    $("#filterParent,#ParentModule,#RelateModule").combobox("reload");
    $("#filterDesc").val(filterDesc);
    $("#filterParent").combobox("setValue",filterParent);
}
$(document).ready(initPage);

