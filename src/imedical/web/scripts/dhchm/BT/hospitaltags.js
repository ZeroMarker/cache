/*
 * FileName: hospitaltags.js
 * Author: yupeng
 * Date: 2021-11-02
 * Description: ֪ʶ��ά��-ҽԺ��ǩ����
 */
var lastIndex = "";

var EditIndex = -1;

$(function(){
           
    InitHospitalTagsDataGrid();
    
    //��ѯ
    $("#BFind").click(function() {  
        BFind_click();      
     });
        
    //����
    $("#BAdd").click(function() {   
        BAdd_click();       
        });
        
    //�޸�
    $("#BUpdate").click(function() {    
        BUpdate_click();        
        });
     
    //����
    $("#BClear").click(function() { 
        BClear_click();     
        });
        
    //����
     $('#BSave').click(function(){
        BSave_click();
    });
       
})


//����
function BClear_click()
{   
     $("#HTCode,#HTDesc,#HTHospCode,#HTHospDesc,#ID").val("");
     LoadHospitalTags();
     BFind_click();

}

//��ѯ
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

//����
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
 
 //�޸�
 function BUpdate_click()
 {
    var selected = $('#HospitalTagsQueryTab').datagrid('getSelected');
    if (selected==null){
            $.messager.alert('��ʾ', "��ѡ����޸ĵļ�¼", 'info');
            return;
    }
    if (selected) {
        var thisIndex = $('#HospitalTagsQueryTab').datagrid('getRowIndex', selected);
        if ((EditIndex != -1) && (EditIndex != thisIndex)) {
            $.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
            return;
        }
        $('#HospitalTagsQueryTab').datagrid('beginEdit', thisIndex);
        $('#HospitalTagsQueryTab').datagrid('selectRow', thisIndex);
        EditIndex = thisIndex;
    
    }
 }

//����
function BSave_click()
{
    $('#HospitalTagsQueryTab').datagrid('acceptChanges');
    
    var selected = $('#HospitalTagsQueryTab').datagrid('getSelected');
     if(selected ==null){
        $.messager.alert('��ʾ', "��ѡ������������", 'info');
        return;
    }
    if (selected) {
        
        if (selected.HTRowID == "") {
            if ((selected.HTCode == "undefined")||(selected.HTDesc=="undefined")||(selected.HTHospCode == "undefined")||(selected.HTHospDesc == "undefined")) {
                $.messager.alert('��ʾ', "����Ϊ��,���������", 'info');
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
                    $.messager.alert('��ʾ', '����ʧ��:'+ rtnArr[1], 'error');
                    
                }else{
                    $.messager.popover({msg:'����ɹ�',type:'success',timeout: 1000});
                }
            
                
            LoadHospitalTags()
            });
        } else {
             $('#HospitalTagsQueryTab').datagrid('selectRow', EditIndex);
             var selected = $('#HospitalTagsQueryTab').datagrid('getSelected');
             if(selected ==null){
                return;
             }
            $.messager.confirm("ȷ��", "ȷ��Ҫ����������", function(r){
            if (r){
                   
                    if ((selected.HTCode == "undefined")||(selected.HTDesc=="undefined")||(selected.HTHospCode == "undefined")||(selected.HTHospDesc == "undefined")) {
                        $.messager.alert('��ʾ', "����Ϊ��,�������޸�", 'info');
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
                        $.messager.alert('��ʾ', '�޸�ʧ��:'+ rtnArr[1], 'error');
                    }else{  
                         $.messager.popover({msg:'�޸ĳɹ�',type:'success',timeout: 1000});
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
                title:'�ڲ�����',
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
                title:'�汾����',
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
                title:'��֯��������',
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
                title:'ҽԺ����',
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
                title: '��������'
            }, {
                field: 'HTUpdateTime',
                width: 100,
                title: '����ʱ��'
            }
            
        ]];
        
    
    // ��ʼ��DataGrid
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

