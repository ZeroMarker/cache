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
        data:[{'typedesc':"提示",'typecode':"A"},{'typedesc':"禁止",'typecode':"F"},{'typedesc':"无控制",'typecode':"N"}]
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
               {field: "tItemDesc", title: "项目", width: 60, sortable: true},
               {field: "tItemCode", title: "项目代码", width: 60, sortable: true},
               {field: "tCtrType", title: "控制类型", width: 60, sortable: true},
               {field: "ctrType", title: "控制类型代码", width: 60, sortable: true},
               {field: "tItemType", title: "项目种类", width: 60, sortable: true},
               {field: "tTypeCode", title: "项目种类代码", width: 60, sortable: true}
            ]
        ],
        toolbar:[
            {
                iconCls: 'icon-add',
			    text:'新增',
			    handler: function(){
                    appendRow();
				}
            },
            {
                iconCls: 'icon-write-order',
			    text:'编辑',
			    handler: function(){
                    editRow();
                }
            },
            {
                iconCls: 'icon-cancel',
			    text:'删除',
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
//新增
function appendRow()
{
	    $("#operDialog").dialog({
        title: "新增申请风险控制",
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
            title: "修改申请风险控制",
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
        $.messager.alert("提示", "请先选择要修改的记录！", 'warning');
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
	    $.messager.alert("提示", "删除成功！", 'info');
	    $("#SafeControlData").datagrid("reload");
    }
    else
    { $.messager.alert("提示", "删除失败！"+datas, 'error');}
    }
    else
    {
	    $.messager.alert("提示", "请先选择要删除的记录！", 'warning');
        return;
    }	
}
function saveSafeControl()
{
	var ItemType=$HUI.combobox("#ItemType").getValue();
    var ItemTypeDesc=$HUI.combobox("#ItemType").getText();
    if(ItemType=="")
    {
        $.messager.alert("提示","项目类型不能为空！","error");
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
	$.messager.alert("提示", "修改成功！", 'info');
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
    	$.messager.alert("提示", "修改成功！", 'info');
    }
     $("#SafeControlData").datagrid("reload");
	$HUI.dialog("#operDialog").close();

}