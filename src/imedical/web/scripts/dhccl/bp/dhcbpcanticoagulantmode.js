var editIndex;
$(function(){
	InitForm();
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
var InitForm=function(){
	    var ifSelectDrugBox = $HUI.combobox("#ifSelectDrug",{
		    valueField:"ifSelectDrug",
		    textField:'ifSelectDrugDesc',
		    panelHeight:'auto',
			data:[
			{ifSelectDrug:"Y",ifSelectDrugDesc:"是"},
			{ifSelectDrug:"N",ifSelectDrugDesc:"否"}
			],
			onHidePanel: function () {
        		OnHidePanel("#ifSelectDrug");
        	},
	    });
		var ifActiveBox = $HUI.combobox("#ifActive",{
		    valueField:"ifActive",
		    textField:'ifActiveDesc',
		    panelHeight:'auto',
			data:[
			{ifActive:"Y",ifActiveDesc:"是"},
			{ifActive:"N",ifActiveDesc:"否"}
			],
			onHidePanel: function () {
        		OnHidePanel("#ifActive");
        	},
	    });
		var tBPCAMSubTypeBox = $HUI.combobox("#bpcAMSubType",{
		    valueField:"bpcAMSubType",
		    textField:'tBPCAMSubTypeDesc',
		    panelHeight:'auto',
			data:[
			{bpcAMSubType:"H",tBPCAMSubTypeDesc:"血透"},
			{bpcAMSubType:"P",tBPCAMSubTypeDesc:"腹透"}
			],
			onHidePanel: function () {
        		OnHidePanel("#bpcAMSubType");
        	},
	    });
}		
var oldRowId=""
function InitGroupData()
{
	    $("#anticoagulant").datagrid({
        singleSelect: true,
        fitColumns:true,
        fit:true,
        iconCls:'icon-paper',
        rownumbers: true,
        headerCls:'panel-header-gray',
        pagination: true,
        pageSize: 20,
        pageList: [20, 50, 100],
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBPCAnticoagulantMode",
            QueryName:"FindAntMode"
        },
        onBeforeLoad: function(param) {
	        param.deptID=session['LOGON.CTLOCID'];
        },
        columns:[
            [
			{ field: "tBPCAMRowId", title: "编号", width: 120, sortable: true  },
            { field: "tBPCAMCode", title: "代码", width: 120, sortable: true  },
            { field: "tBPCAMDesc", title: "描述", width: 180, sortable: true  },
            { field: "ifSelectDrug", title: "是否药品", width: 90, sortable: true ,hidden:true },
            { field: "ifSelectDrugDesc", title: "是否药品", width: 90, sortable: true  },			
            { field: "ifActive", title: "是否使用", width: 120, sortable: true ,hidden:true},
            { field: "ifActiveDesc", title: "是否使用", width: 120, sortable: true  },
			{ field: "tBPCAMSubType", title: "所属应用", width: 120, sortable: true ,hidden:true },
			{ field: "tBPCAMSubTypeDesc", title: "所属应用", width: 120, sortable: true  }
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
	        selectBpIndex=rowIndex;
	        oldRowId=rowData.tBPCAMRowId;
	        
        }
    })
}
function InitOperDiag()
{
	//$('#bpcAMCode').combobox("reload");
	//$('#bpcAMDesc').combobox("reload");
	$('#ifSelectDrug').combobox("reload");
	$('#ifActive').combobox("reload");
	$('#bpcAMSubType').combobox("reload");
	//$('#tBPCAMRowId').combobox("reload");
	//$('#tBPCAMCode').combobox("reload");
	//$('#tBPCAMDesc').combobox("reload");
	//$("#ifSelectDrug").combobox("setValue",selectRow.ifSelectDrug);
	//$("#ifActive").combobox("setValue",selectRow.ifActive);
	//$("#bpcAMSubType").combobox("setValue",selectRow.tBPCAMSubType);
	//$('#ifSelectDrugDesc').combobox("reload");
	//$('#ifActiveDesc').combobox("reload");
	//$('#tBPCAMSubTypeDesc').combobox("reload");
}
//新增
function appendRow()
{
	    $("#anticoagulantDlg").dialog({
        title: "新增抗凝方式",
        iconCls: "icon-w-add"
    });
    InitOperDiag();
    $("#anticoagulantDlg").dialog("open");

}

var selectBpIndex="";
function editRow()
{
	var selectRow=$("#anticoagulant").datagrid("getSelected");
    if(selectRow)
    {
        $("#anticoagulantDlg").dialog({
            title: "修改抗凝方式",
            iconCls: "icon-w-edit"
        });        
		$("#bpcAMId").val(selectRow.tBPCAMRowId);
		$("#bpcAMCode").val(selectRow.tBPCAMCode);
		$("#bpcAMDesc").val(selectRow.tBPCAMDesc);
		$("#ifSelectDrug").combobox("setValue",selectRow.ifSelectDrug);
		$("#ifActive").combobox("setValue",selectRow.ifActive);
		$("#bpcAMSubType").combobox("setValue",selectRow.tBPCAMSubType);
		
        $("#anticoagulantDlg").window("open");
        $("#isEdit").val("Y");
        
    }else{
        $.messager.alert("提示", "请先选择要修改的记录！", 'error');
        return;
    }

	
}
function deleteRow()
{
var selectRow=$("#anticoagulant").datagrid("getSelected");
    if(selectRow)
    {
	    var tBPCAMRowId=selectRow.tBPCAMRowId;
	    var datas=$.m({
        ClassName:"web.DHCBPCAnticoagulantMode",
        MethodName:"DeleteAntMode",
        bpcAMId:tBPCAMRowId
    },false);
    if(datas==0)
    {
	    $.messager.alert("提示", "删除成功！", 'info');
	    $("#anticoagulant").datagrid("reload");
    }
    
    }
    else
    {
	    $.messager.alert("提示", "请先选择要删除的记录！", 'error');
        return;
    }	
}
function saveDocGroup()
{	
	var ifSelectDrugId=$HUI.combobox("#ifSelectDrug").getValue();
	var ifSelectDrugDesc=$HUI.combobox("#ifSelectDrug").getText();
    if(ifSelectDrugId=="")
    {
        $.messager.alert("提示","是否药品不能为空！","error");
        return;
    }
	var ifActiveId=$HUI.combobox("#ifActive").getValue();
	var ifActiveDesc=$HUI.combobox("#ifActive").getText();
    if(ifActiveId=="")
    {
        $.messager.alert("提示","是否使用不能为空！","error");
        return;
    }    
	var bpcAMSubTypeId=$HUI.combobox("#bpcAMSubType").getValue();
	var bpcAMSubTypeDesc=$HUI.combobox("#bpcAMSubType").getText();
    if(ifActiveId=="")
    {
        $.messager.alert("提示","所属应用不能为空！","error");
        return;
    }
    var bpcAMCode=$("#bpcAMCode").val();    
    var bpcAMDesc=$("#bpcAMDesc").val();  
    var rowdata={
	    tBPCAMRowId:oldRowId,
        tBPCAMCode:bpcAMCode,
       	tBPCAMDesc:bpcAMDesc,
        ifSelectDrug:ifSelectDrugId,
        ifSelectDrugDesc:ifSelectDrugDesc,
        ifActive:ifActiveId,
        ifActiveDesc:ifActiveDesc,
        tBPCAMSubType:bpcAMSubTypeId,
        tBPCAMSubTypeDesc:bpcAMSubTypeDesc
    }
    if( $("#isEdit").val()=="Y")
    {
	//var res=cspRunServerMethod(modify,deptID,groupId,groupStr);
    var datas=$.m({
        ClassName:"web.DHCBPCAnticoagulantMode",
        MethodName:"UpdateAntMode",
		bpcAMId:oldRowId,
		bpcAMCode:bpcAMCode,
		bpcAMDesc:bpcAMDesc,
		ifSelectDrug:ifSelectDrugId,
		ifActive:ifActiveId,
		bpcAMSubType:bpcAMSubTypeId,
    },false);
       $HUI.datagrid("#anticoagulant").updateRow({index:selectBpIndex,row:rowdata});
	$.messager.alert("提示", "修改成功！", 'info');
    }
    else
    {
	    
		//var res=cspRunServerMethod(modify,deptID,groupId,groupStr);
    var datas=$.m({
        ClassName:"web.DHCBPCAnticoagulantMode",
        MethodName:"InsertAntMode",
		bpcAMCode:bpcAMCode,
		bpcAMDesc:bpcAMDesc,
		ifSelectDrug:ifSelectDrugId,
		ifActive:ifActiveId,
		bpcAMSubType:bpcAMSubTypeId
    	},false);
    	$HUI.datagrid("#anticoagulant").appendRow(rowdata);
    	$.messager.alert("提示", "添加成功！", 'info');
    }
     $("#anticoagulant").datagrid("reload");
	$HUI.dialog("#anticoagulantDlg").close();
	
}
