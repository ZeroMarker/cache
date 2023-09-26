var epRowId;
var selectEPIndex;

$(function(){
	InitFormItem();
	InitGroupData();
});
function OnHidePanel(item)
{
	var valueField = $(item).combobox("options").valueField;
	var val = $(item).combobox("getValue");  //当前combobox的值
	var txt = $(item).combobox("getText");
	var allData = $(item).combobox("getData");   //获取combobox所有数据
	var result = true;      //为true说明输入的值在下拉框数据中不存在
	if (val=="") result=false;
	for (var i = 0; i < allData.length; i++) {
		if (val == allData[i][valueField]) {
	    	result = false;
	    	break;
	    }
	}
	if (result) {
		$(item).combobox("clear");	    
	    $(item).combobox("reload");
	    if ((val==undefined)&&(txt!=""))
	    {
		    $(item).combobox('setValue',"");
	    	$.messager.alert("提示","请从下拉框选择","error");
	    	return;
	    }
	}
}
function InitFormItem()
{
	//设备型号
	 var appLoc=$HUI.combobox("#bpcEPModelDr",{
        url:$URL+"?ClassName=web.DHCBPCEquipModel&QueryName=FindEModel&ResultSetType=array",
        valueField:"tID",
        textField:"tBPCEMDesc",
        onBeforeLoad:function(param)
        {
        }   
    });	
    	//设备型号
	 var appLoc=$HUI.combobox("#FbpcEPModelDr",{
        url:$URL+"?ClassName=web.DHCBPCEquipModel&QueryName=FindEModel&ResultSetType=array",
        valueField:"tID",
        textField:"tBPCEMDesc",
        onHidePanel: function () {
        	OnHidePanel("#FbpcEPModelDr");
        },   
    });	
}
function InitGroupData()
{
	    $("#equippartListData").datagrid({
        singleSelect: true,
        fitColumns:true,
        fit:true,
        rownumbers: true,
        pagination: true,
        pageSize: 20,
        pageList: [20, 50, 100],
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBPCEquipPart",
            QueryName:"FindEPart"
        },
        onBeforeLoad: function(param) {
	        param.bpcEPCode=$("#bpcEPCode").val();
	        param.bpcEPDesc=$("#bpcEPDesc").val();
	        param.BPCEPBPCEquipModelDr=$("#bpcEPModelDr").combobox('getValue');
        },
        columns:[
            [
               {field: "tBPCEPRowId", title: "编号", width: 60, sortable: true},
               {field: "tBPCEPCode", title: "代码", width: 60, sortable: true},
               {field: "tBPCEPDesc", title: "名称", width: 60, sortable: true},
               {field: "tBPCEPBPCEquipModelDr", title: "tBPCEPBPCEquipModelDr", width: 60, hidden:true},
               {field: "tBPCEPBPCEquipModel", title: "设备", width: 350, sortable: true},
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
			    text:'修改',
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
	        selectEPIndex=rowIndex;
	        epRowId=rowData.tBPCEPRowId;
	        
        }
    })
	$("#btnSearch").click(function(){
        $HUI.datagrid("#equippartListData").reload();
    });
}
function InitOperDiag()
{
	$('#FbpcEPModelDr').combobox("reload");
}
//新增
function appendRow()
{
	    $("#equippartDlg").dialog({
        title: "新增设备配件",
        iconCls: "icon-w-add"
    });
    InitOperDiag();
    $("#equippartDlg").dialog("open");

}
function editRow()
{
	var selectRow=$("#equippartListData").datagrid("getSelected");
    if(selectRow)
    {
        $("#equippartDlg").dialog({
            title: "修改设备配件",
            iconCls: "icon-w-edit"
        });         
        var epRowId=selectRow.tBPCEPRowId;
        var code=selectRow.tBPCEPCode;
        var desc=selectRow.tBPCEPDesc;
        var equipModelDr=selectRow.tBPCEPBPCEquipModelDr;
        var equipModel=selectRow.tBPCEPBPCEquipModel;
		$("#FbpcEPCode").val(code);
        $("#FbpcEPDesc").val(desc);        
        $("#FbpcEPModelDr").combobox('setValue',equipModelDr);
        
        $("#equippartDlg").window("open");
        $("#EditEquippart").val("Y");
        
    }else{
        $.messager.alert("提示", "请先选择要修改的记录！", 'error');
        return;
    }

	
}
function deleteRow()
{
var selectRow=$("#equippartListData").datagrid("getSelected");
    if(selectRow)
    {
	    var rowId=selectRow.tBPCEPRowId;
	    var datas=$.m({
        ClassName:"web.DHCBPCEquipPart",
        MethodName:"DeleteEPart",
        bpcEPId:rowId
    },false);
    if(datas==0)
    {
	    $.messager.alert("提示", "删除成功！", 'info');
	    $("#equippartListData").datagrid("reload");
    }
    }
    else
    {
	    $.messager.alert("提示", "请先选择要删除的记录！", 'error');
        return;
    }	
}
function saveEquipPart()
{
    var code=$("#FbpcEPCode").val();
    var desc=$("#FbpcEPDesc").val();
 	var epModelDr=$("#FbpcEPModelDr").combobox('getValue');
	var epModelDesc=$("#FbpcEPModelDr").combobox('getText');     
    var rowdata={
        tBPCEPCode:code,
        tBPCEPDesc:desc,
        tBPCEPBPCEquipModelDr:epModelDr,
        tBPCEPBPCEquipModel:epModelDesc,
    }           
    if( $("#EditEquippart").val()=="Y")
    {
	    if(code==""){
			$.messager.alert("提示","代码不能为空","error");
			return;
		}
		if(desc==""){
			$.messager.alert("名称","名称不能为空","error");
			return;
		}
    	var datas=$.m({
        ClassName:"web.DHCBPCEquipPart",
        MethodName:"UpdateEPart",
        bpcEPId:epRowId,
        bpcEPBPCEquipModelDr:epModelDr,
        bpcEPCode:code,
        bpcEPDesc:desc,
    	},false);
       $HUI.datagrid("#equippartListData").updateRow({index:selectEPIndex,row:rowdata});
		$.messager.alert("提示", "修改成功！", 'info');
    }
    else
    {
	    if(code==""){
			$.messager.alert("提示","代码不能为空","error");
			return;
		}
		if(desc==""){
			$.messager.alert("名称","名称不能为空","error");
			return;
		}
    	var datas=$.m({
        ClassName:"web.DHCBPCEquipPart",
        MethodName:"InsertEPart",
        bpcEPBPCEquipModelDr:epModelDr,
        bpcEPCode:code,
        bpcEPDesc:desc,
    	},false);
    	$HUI.datagrid("#equippartListData").appendRow(rowdata);
    	$.messager.alert("提示", "添加成功！", 'info');
    }
     $("#equippartListData").datagrid("reload");
	$HUI.dialog("#equippartDlg").close();
	
}
 