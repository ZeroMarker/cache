/*
 * FileName: hospitaltags.js
 * Author: yupeng
 * Date: 2021-11-02
 * Description: 知识库维护-医院标签定义
 */
var lastIndex = "";

var EditIndex = -1;

$(function(){
           
    InitHospitalTagsDataGrid();
    
    //查询
    $("#BFind").click(function() {  
        BFind_click();      
     });
        
    //新增
    $("#BAdd").click(function() {   
        BAdd_click();       
        });
        
    //修改
    $("#BUpdate").click(function() {    
        BUpdate_click();        
        });
     
    //清屏
    $("#BClear").click(function() { 
        BClear_click();     
        });
        
    //保存
     $('#BSave').click(function(){
        BSave_click();
    });
       
})


//清屏
function BClear_click()
{   
     $("#HTCode,#HTDesc,#HTHospCode,#HTHospDesc,#ID").val("");
     LoadHospitalTags();
     BFind_click();

}

//查询
function BFind_click(){
    
    $("#HospitalTagsQueryTab").datagrid('load',{
            ClassName:"HMS.BT.HospitalTags",
            QueryName:"TagsAll",
            Code:$("#HTCode").val(),
            Desc:$("#HTDesc").val(),
            HospCode:$("#HTHospCode").val(),
            HospDesc:$("#HTHospDesc").val()
            
        }); 
}

//新增
function BAdd_click()
 {
    $('#HospitalTagsQueryTab').datagrid('appendRow', {
        HTRowID: '',
        HTCode: '',
        HTDesc: '',
        HTHospCode:'',
        HTHospDesc:'',
        HTUpdateDate:'',
        HTUpdateTime:''
        
    });
    lastIndex = $('#HospitalTagsQueryTab').datagrid('getRows').length - 1;
    $('#HospitalTagsQueryTab').datagrid('selectRow', lastIndex);
    $('#HospitalTagsQueryTab').datagrid('beginEdit', lastIndex);
    EditIndex = lastIndex;
 }
 
 //修改
 function BUpdate_click()
 {
    var selected = $('#HospitalTagsQueryTab').datagrid('getSelected');
    if (selected==null){
            $.messager.alert('提示', "请选择待修改的记录", 'info');
            return;
    }
    if (selected) {
        var thisIndex = $('#HospitalTagsQueryTab').datagrid('getRowIndex', selected);
        if ((EditIndex != -1) && (EditIndex != thisIndex)) {
            $.messager.alert('提示', "一次只能修改一条记录", 'info');
            return;
        }
        $('#HospitalTagsQueryTab').datagrid('beginEdit', thisIndex);
        $('#HospitalTagsQueryTab').datagrid('selectRow', thisIndex);
        EditIndex = thisIndex;
    
    }
 }

//保存
function BSave_click()
{
    $('#HospitalTagsQueryTab').datagrid('acceptChanges');
    
    var selected = $('#HospitalTagsQueryTab').datagrid('getSelected');
     if(selected ==null){
        $.messager.alert('提示', "请选择待保存的数据", 'info');
        return;
    }
    if (selected) {
        
        if (selected.HTRowID == "") {
            if ((selected.HTCode == "undefined")||(selected.HTDesc=="undefined")||(selected.HTHospCode == "undefined")||(selected.HTHospDesc == "undefined")) {
                $.messager.alert('提示', "数据为空,不允许添加", 'info');
                LoadHospitalTags();
                return;
            }
            $.m({
                ClassName: "HM.BT.HospitalTags",
                MethodName: "Update",
                aInputStr:"^"+selected.HTCode+"^"+selected.HTDesc+"^"+selected.HTHospCode+"^"+selected.HTHospDesc,
                aDelimiter:"^"
                
            }, function (rtn) {
                var rtnArr=rtn.split("^");
                if(rtnArr[0]=="-1"){    
                    $.messager.alert('提示', '保存失败:'+ rtnArr[1], 'error');
                    
                }else{
                    $.messager.popover({msg:'保存成功',type:'success',timeout: 1000});
                }
            
                
            LoadHospitalTags()
            });
        } else {
             $('#HospitalTagsQueryTab').datagrid('selectRow', EditIndex);
             var selected = $('#HospitalTagsQueryTab').datagrid('getSelected');
             if(selected ==null){
                return;
             }
            $.messager.confirm("确认", "确定要保存数据吗？", function(r){
            if (r){
                   
                    if ((selected.HTCode == "undefined")||(selected.HTDesc=="undefined")||(selected.HTHospCode == "undefined")||(selected.HTHospDesc == "undefined")) {
                        $.messager.alert('提示', "数据为空,不允许修改", 'info');
                        LoadHospitalTags()
                        return;
                    }
                    
                    $.m({
                        ClassName: "HM.BT.HospitalTags",
                        MethodName: "Update",
                        aInputStr:selected.HTRowID+"^"+selected.HTCode+"^"+selected.HTDesc+"^"+selected.HTHospCode+"^"+selected.HTHospDesc,
                        aDelimiter:"^"
                
                    }, function (rtn) {
                        var rtnArr=rtn.split("^");
                        if(rtnArr[0]=="-1"){    
                        $.messager.alert('提示', '修改失败:'+ rtnArr[1], 'error');
                    }else{  
                         $.messager.popover({msg:'修改成功',type:'success',timeout: 1000});
                    }
            
                    LoadHospitalTags()
                });
            
            
                }
            }); 
        
            
        }
    }
}



function LoadHospitalTags()
{
     $("#HospitalTagsQueryTab").datagrid('reload');
}



function InitHospitalTagsDataGrid(){ 
    
    var HospitalTagsColumns = [[
            {
                field:'HTRowID',
                title:'HTRowID',
                hidden:true
            },{
                field:'HTCode',
                width: 150,
                title:'内部编码',
                editor: 'text',
                sortable: true,
                resizable: true,
                editor: {
                    type: 'validatebox',  
                    options: {
                        required: true
                    }
                }
             },{
                field:'HTDesc',
                width: 200,
                title:'版本名称',
                editor: 'text',
                sortable: true,
                resizable: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             },{
                field:'HTHospCode',
                width: 150,
                title:'组织机构代码',
                editor: 'text',
                sortable: true,
                resizable: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             },{
                field:'HTHospDesc',
                width: 240,
                title:'医院名称',
				hidden:true,
                editor: 'text',
                sortable: true,
                resizable: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             }, {
                field: 'HTUpdateDate',
                width: 100,
                title: '更新日期'
            }, {
                field: 'HTUpdateTime',
                width: 100,
                title: '更新时间'
            }
            
        ]];
        
    
    // 初始化DataGrid
    $('#HospitalTagsQueryTab').datagrid({
        url:$URL,
        fit : true,
        border : false,
        striped : true,
        fitColumns : false,
        autoRowHeight : false,
        rownumbers:true,
        pagination : true,
        pageSize: 20,
        pageList : [20,100,200],
        singleSelect: true,
        selectOnCheck: true,
        columns: HospitalTagsColumns,
        queryParams:{
            ClassName:"HMS.BT.HospitalTags",
            QueryName:"TagsAll",
            Code:$("#HTCode").val(),
            Desc:$("#HTDesc").val(),
            HospCode:$("#HTHospCode").val(),
            HospDesc:$("#HTHospDesc").val()
        },
        onSelect: function (rowIndex, rowData) {
                $("#ID").val(rowData.HTRowID);
        },
        onLoadSuccess: function (data) {
            EditIndex = -1;
        }
    });

        
}

