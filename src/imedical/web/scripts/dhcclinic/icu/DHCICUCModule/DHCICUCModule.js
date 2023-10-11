/**
 * 初始化查询条件
 */
function initQueryOptions(){
    $("#filterParent,#ParentModule").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = "web.DHCICUCModule";
            param.QueryName = "FindDataModule";
            param.Arg1 = "";
            param.Arg2 = "";
            param.ArgCnt = 2;
        }
    });

    $("#btnQuery").linkbutton({
        onClick: function() {
            $("#dataBox").treegrid("reload")
            $("#filterDesc").val("");
            $("#filterParent").combobox("setValue","");
        }
    });
}

/**
 * 初始化编辑表单
 */
function initDataForm(){
    $("#Active").combobox({
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
    $("#dataBox").treegrid({
        border:false,
        idField: "RowId",
        treeField: "Description",
        //title: "数据模块",
        columns: [
            [
                {field:'operate1',title:'删除',align:'center',width:50,
                formatter:function(value, row, index){ 
                var str = '<a href="#" id="btnremove" class="hisui-linkbutton" onClick="DeleteRecord(\''+dataForm+'\',\''+row.RowId+'\')" "></a>';
                return str;
                }
                },
                { field: "Description", title: "名称", width: 240 },
                { field: "Code", title: "代码", width: 120 },
                { field: "ParentModuleDesc", title: "父模块", width: 120 },
                { field: "Url", title: "链接URL", width: 240 },
                { field: "ActiveDesc", title: "激活", width: 48 },
                { field: "SeqNo", title: "排序号", width: 80 },
                { field: "Icon", title: "图标", width: 150 },
                { field: "Params", title: "字段", width: 150 }
            ]
        ],
        onLoadSuccess: function(data) {
          
            $("a[id='btnremove']").linkbutton({plain:true,iconCls:'icon-cancel'}); 
        },
        onBeforeLoad:function(row,param){
            param.ClassName="web.DHCICUCModule";
            param.QueryName="FindDataModule";
            param.Arg1=$("#filterDesc").val();
            param.Arg2=$("#filterParent").combobox("getValue");
            param.ArgCnt=2;
        },
        
        onSelect:function(rowIndex,rowData){
            $("#dataForm").form("load",rowData);
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
                    formData.ClassName="User.DHCICUCModule";
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
                    formData.ClassName="User.DHCICUCModule";
                    let parentModule=$("#ParentModule").combobox("getValue");
                    formData.ParentModule=parentModule;
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
	
	$("#btnPrintTemplate").linkbutton({
        onClick: function() {
            if(dhccl.hasRowSelected($("#dataBox"),true)){
                var rowData = $("#dataBox").treegrid("getSelected");
                var url = "dhcicu.printtemplate.csp?moduleId=" + rowData.RowId + "&moduleCode=" + rowData.Code;
                window.open(url, "_blank")
            }
        }
    });
}
function DeleteRecord(dataForm,index) {
    $.messager.confirm("确认", "是否删除该数据记录？", function(result) {
    if (result) {
             var msg = dhccl.removeData("User.DHCICUCModule", index);
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
    $("#filterParent,#ParentModule").combobox("reload");
    $("#filterDesc").val(filterDesc);
    $("#filterParent").combobox("setValue",filterParent);
}
$(document).ready(initPage);

