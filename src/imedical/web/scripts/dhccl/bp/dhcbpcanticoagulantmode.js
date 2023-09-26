var editIndex;
$(function(){
	InitForm();
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
var InitForm=function(){
	    var ifSelectDrugBox = $HUI.combobox("#ifSelectDrug",{
		    valueField:"ifSelectDrug",
		    textField:'ifSelectDrugDesc',
		    panelHeight:'auto',
			data:[
			{ifSelectDrug:"Y",ifSelectDrugDesc:"��"},
			{ifSelectDrug:"N",ifSelectDrugDesc:"��"}
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
			{ifActive:"Y",ifActiveDesc:"��"},
			{ifActive:"N",ifActiveDesc:"��"}
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
			{bpcAMSubType:"H",tBPCAMSubTypeDesc:"Ѫ͸"},
			{bpcAMSubType:"P",tBPCAMSubTypeDesc:"��͸"}
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
			{ field: "tBPCAMRowId", title: "���", width: 120, sortable: true  },
            { field: "tBPCAMCode", title: "����", width: 120, sortable: true  },
            { field: "tBPCAMDesc", title: "����", width: 180, sortable: true  },
            { field: "ifSelectDrug", title: "�Ƿ�ҩƷ", width: 90, sortable: true ,hidden:true },
            { field: "ifSelectDrugDesc", title: "�Ƿ�ҩƷ", width: 90, sortable: true  },			
            { field: "ifActive", title: "�Ƿ�ʹ��", width: 120, sortable: true ,hidden:true},
            { field: "ifActiveDesc", title: "�Ƿ�ʹ��", width: 120, sortable: true  },
			{ field: "tBPCAMSubType", title: "����Ӧ��", width: 120, sortable: true ,hidden:true },
			{ field: "tBPCAMSubTypeDesc", title: "����Ӧ��", width: 120, sortable: true  }
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
//����
function appendRow()
{
	    $("#anticoagulantDlg").dialog({
        title: "����������ʽ",
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
            title: "�޸Ŀ�����ʽ",
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
        $.messager.alert("��ʾ", "����ѡ��Ҫ�޸ĵļ�¼��", 'error');
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
	    $.messager.alert("��ʾ", "ɾ���ɹ���", 'info');
	    $("#anticoagulant").datagrid("reload");
    }
    
    }
    else
    {
	    $.messager.alert("��ʾ", "����ѡ��Ҫɾ���ļ�¼��", 'error');
        return;
    }	
}
function saveDocGroup()
{	
	var ifSelectDrugId=$HUI.combobox("#ifSelectDrug").getValue();
	var ifSelectDrugDesc=$HUI.combobox("#ifSelectDrug").getText();
    if(ifSelectDrugId=="")
    {
        $.messager.alert("��ʾ","�Ƿ�ҩƷ����Ϊ�գ�","error");
        return;
    }
	var ifActiveId=$HUI.combobox("#ifActive").getValue();
	var ifActiveDesc=$HUI.combobox("#ifActive").getText();
    if(ifActiveId=="")
    {
        $.messager.alert("��ʾ","�Ƿ�ʹ�ò���Ϊ�գ�","error");
        return;
    }    
	var bpcAMSubTypeId=$HUI.combobox("#bpcAMSubType").getValue();
	var bpcAMSubTypeDesc=$HUI.combobox("#bpcAMSubType").getText();
    if(ifActiveId=="")
    {
        $.messager.alert("��ʾ","����Ӧ�ò���Ϊ�գ�","error");
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
	$.messager.alert("��ʾ", "�޸ĳɹ���", 'info');
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
    	$.messager.alert("��ʾ", "��ӳɹ���", 'info');
    }
     $("#anticoagulant").datagrid("reload");
	$HUI.dialog("#anticoagulantDlg").close();
	
}
