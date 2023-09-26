var editIndex;
var oldSelId,oldStr,selId;
var selectOperIndex;

$(function(){
	InitFormItem();
	InitSafeControlData();
});
function InitFormItem()
{
    var ItemType=$HUI.combobox("#ItemType",{
        url:$URL+"?ClassName=web.DHCANCOPItemCheck&QueryName=FindCheckItemType&ResultSetType=array",
        valueField:"typeCode",
        textField:"typeDesc",
         editable:false,
        panelHeight:'auto'
    })
	
    var ControlType=$HUI.combobox("#ControlType",{
        valueField:"typecode",
        textField:"typedesc",
         editable:false,
        panelHeight:'auto',
        data:[{'typedesc':"��ʾ",'typecode':"A"},{'typedesc':"��ֹ",'typecode':"F"},{'typedesc':"�޿���",'typecode':"N"}]
    })

}
function InitSafeControlData()
{
	    $("#SafeControlData").datagrid({
        singleSelect: true,
        fitColumns:true,
        fit:true,
        rownumbers: true,
        headerCls:'panel-header-gray',
        pagination: true,
        pageSize: 20,
        pageList: [20, 50, 100],
        url:$URL,
        queryParams:{
            ClassName:"web.DHCANCOPItemCheck",
            QueryName:"FindChkItem"
        },
        onBeforeLoad: function(param) {
        },
        columns:[
            [
               {field: "tId", title: "ID", width: 60, sortable: true,hidden:true },
               {field: "tItemDesc", title: "��Ŀ", width: 60, sortable: true},
               {field: "tItemCode", title: "��Ŀ����", width: 60, sortable: true},
               {field: "tCtrType", title: "��������", width: 60, sortable: true},
               {field: "ctrType", title: "�������ʹ���", width: 60, sortable: true},
               {field: "tItemType", title: "��Ŀ����", width: 60, sortable: true},
               {field: "tTypeCode", title: "��Ŀ�������", width: 60, sortable: true}
            ]
        ],
        toolbar:[
            {
                iconCls: 'icon-add',
			    text:'����',
			    handler: function(){
                    appendRow();
				}
            },
            {
                iconCls: 'icon-write-order',
			    text:'�༭',
			    handler: function(){
                    editRow();
                }
            },
            {
                iconCls: 'icon-cancel',
			    text:'ɾ��',
			    handler: function(){
                    deleteRow();
                }
            }
        ],
        onSelect:function(rowIndex, rowData){
	        selectOperIndex=rowIndex;
	        oldSelId=rowData.tId;
	        var oldCode=rowData.tItemCode;
	        var oldDesc=rowData.tItemDesc;
	        var oldCtroType=rowData.ctrType;
	        var oldType=rowData.tTypeCode;
	        oldStr=oldCode+"^"+oldDesc+"^"+oldCtroType+"^"+oldType
        }
    })

}

function InitOperDiag()
{
}
//����
function appendRow()
{
	    $("#operDialog").dialog({
        title: "����������տ���",
        iconCls: "icon-w-add"
    });
    InitOperDiag();
    $("#operDialog").dialog("open");

}
function editRow()
{
	var selectRow=$("#SafeControlData").datagrid("getSelected");
    if(selectRow)
    {
        $("#operDialog").dialog({
            title: "�޸�������տ���",
            iconCls: "icon-w-edit"
        });
        
        selId=selectRow.tId;
        var ItemTypeId=selectRow.tTypeCode;
        var ControlTypeId=selectRow.ctrType;
        var ItemDesc=selectRow.tItemDesc;
        var ItemCode=selectRow.tItemCode;
       
        $("#ItemType").combobox('setValue',ItemTypeId)
        $("#ControlType").combobox('setValue',ControlTypeId)
        $("#ItemDesc").val(ItemDesc);
        $("#ItemCode").val(ItemCode);
        $("#operDialog").window("open");
        $("#EditOperation").val("Y");
        
    }else{
        $.messager.alert("��ʾ", "����ѡ��Ҫ�޸ĵļ�¼��", 'warning');
        return;
    }

	
}
function deleteRow()
{
var selectRow=$("#SafeControlData").datagrid("getSelected");
    if(selectRow)
    {
	    var itemType=selectRow.tTypeCode;		
	    var selId=selectRow.tId;
	    var datas=$.m({
        ClassName:"web.DHCANCOPItemCheck",
        MethodName:"DeleteItemCheck",
        itemType:itemType,
        rowId:selId
    },false);
    if(datas==1)
    {
	    $.messager.alert("��ʾ", "ɾ���ɹ���", 'info');
	    $("#SafeControlData").datagrid("reload");
    }
    else
    { $.messager.alert("��ʾ", "ɾ��ʧ�ܣ�"+datas, 'error');}
    }
    else
    {
	    $.messager.alert("��ʾ", "����ѡ��Ҫɾ���ļ�¼��", 'warning');
        return;
    }	
}
function saveSafeControl()
{
	var ItemType=$HUI.combobox("#ItemType").getValue();
    var ItemTypeDesc=$HUI.combobox("#ItemType").getText();
    if(ItemType=="")
    {
        $.messager.alert("��ʾ","��Ŀ���Ͳ���Ϊ�գ�","error");
        return;
    }
    var ControlType=$HUI.combobox("#ControlType").getValue();
    var ControlTypeDesc=$HUI.combobox("#ControlType").getText();
    if(ControlTypeDesc=="")
    {
	    ControlType="";
    }
    var ItemDesc=$("#ItemDesc").val();
 	var ItemCode=$("#ItemCode").val();

 	var rowdata={
       tItemDesc:ItemDesc,
        tItemCode:ItemCode,
        tCtrType:ControlTypeDesc,
        ctrType:ControlType,
        tItemType:ItemType,
        tTypeCode:ItemTypeDesc
    }
 	
     if( $("#EditOperation").val()=="Y")
    {
        	var datas=$.m({
        ClassName:"web.DHCANCOPItemCheck",
        MethodName:"UpdateItemCheck",
        itemCode:ItemCode,
        itemDesc:ItemDesc,
        ctrType:ControlType,
        itemType:ItemType,
        rowId:selId,
        oldStr:oldStr
    	},false);

       $HUI.datagrid("#SafeControlData").updateRow({index:selectOperIndex,row:rowdata});
	$.messager.alert("��ʾ", "�޸ĳɹ���", 'info');
    }
    else
    {
	    var datas=$.m({
        ClassName:"web.DHCANCOPItemCheck",
        MethodName:"InsertItemCheck",
        itemCode:ItemCode,
        itemDesc:ItemDesc,
        ctrType:ControlType,
        itemType:ItemType
    },false);
	    //alert(datas)
    	$HUI.datagrid("#SafeControlData").appendRow(rowdata);
    	$.messager.alert("��ʾ", "�޸ĳɹ���", 'info');
    }
     $("#SafeControlData").datagrid("reload");
	$HUI.dialog("#operDialog").close();

}