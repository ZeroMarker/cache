var epRowId;
var selectEPIndex;

$(function(){
	InitFormItem();
	InitGroupData();
});
function OnHidePanel(item)
{
	var valueField = $(item).combobox("options").valueField;
	var val = $(item).combobox("getValue");  //��ǰcombobox��ֵ
	var txt = $(item).combobox("getText");
	var allData = $(item).combobox("getData");   //��ȡcombobox��������
	var result = true;      //Ϊtrue˵�������ֵ�������������в�����
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
	    	$.messager.alert("��ʾ","���������ѡ��","error");
	    	return;
	    }
	}
}
function InitFormItem()
{
	//�豸�ͺ�
	 var appLoc=$HUI.combobox("#bpcEPModelDr",{
        url:$URL+"?ClassName=web.DHCBPCEquipModel&QueryName=FindEModel&ResultSetType=array",
        valueField:"tID",
        textField:"tBPCEMDesc",
        onBeforeLoad:function(param)
        {
        }   
    });	
    	//�豸�ͺ�
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
               {field: "tBPCEPRowId", title: "���", width: 60, sortable: true},
               {field: "tBPCEPCode", title: "����", width: 60, sortable: true},
               {field: "tBPCEPDesc", title: "����", width: 60, sortable: true},
               {field: "tBPCEPBPCEquipModelDr", title: "tBPCEPBPCEquipModelDr", width: 60, hidden:true},
               {field: "tBPCEPBPCEquipModel", title: "�豸", width: 350, sortable: true},
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
			    text:'�޸�',
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
//����
function appendRow()
{
	    $("#equippartDlg").dialog({
        title: "�����豸���",
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
            title: "�޸��豸���",
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
        $.messager.alert("��ʾ", "����ѡ��Ҫ�޸ĵļ�¼��", 'error');
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
	    $.messager.alert("��ʾ", "ɾ���ɹ���", 'info');
	    $("#equippartListData").datagrid("reload");
    }
    }
    else
    {
	    $.messager.alert("��ʾ", "����ѡ��Ҫɾ���ļ�¼��", 'error');
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
			$.messager.alert("��ʾ","���벻��Ϊ��","error");
			return;
		}
		if(desc==""){
			$.messager.alert("����","���Ʋ���Ϊ��","error");
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
		$.messager.alert("��ʾ", "�޸ĳɹ���", 'info');
    }
    else
    {
	    if(code==""){
			$.messager.alert("��ʾ","���벻��Ϊ��","error");
			return;
		}
		if(desc==""){
			$.messager.alert("����","���Ʋ���Ϊ��","error");
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
    	$.messager.alert("��ʾ", "��ӳɹ���", 'info');
    }
     $("#equippartListData").datagrid("reload");
	$HUI.dialog("#equippartDlg").close();
	
}
 