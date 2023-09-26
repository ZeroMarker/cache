var editIndex;
var oldGroupId;
var selectOperIndex;

$(function(){
	InitFormItem();
	InitGroupData();
});
function InitFormItem()
{
	var surgeon=$HUI.combobox("#Surgeon",{
        url:$URL+"?ClassName=web.DHCANCODGroup&QueryName=FindOPDoctor&ResultSetType=array",
        valueField:"docID",
        textField:"docName",
        editable:false,
        mode:"remote"
    })
    var surgeonass1=$HUI.combobox("#SurgonAss1",{
        url:$URL+"?ClassName=web.DHCANCODGroup&QueryName=FindOPDoctor&ResultSetType=array",
        valueField:"docID",
        textField:"docName",
        editable:false,
        mode:"remote"
    })
        var surgeonass2=$HUI.combobox("#SurgonAss2",{
        url:$URL+"?ClassName=web.DHCANCODGroup&QueryName=FindOPDoctor&ResultSetType=array",
        valueField:"docID",
        textField:"docName",
        editable:false,
        mode:"remote"
    })

    var surgeonass3=$HUI.combobox("#SurgonAss3",{
        url:$URL+"?ClassName=web.DHCANCODGroup&QueryName=FindOPDoctor&ResultSetType=array",
        valueField:"docID",
        textField:"docName",
        editable:false,
        mode:"remote"
    })
}
function InitGroupData()
{
	    $("#DocGroupData").datagrid({
        singleSelect: true,
        fitColumns:true,
        fit:true,
        title:'����ҽʦ��ά��',
        iconCls:'icon-paper',
        rownumbers: true,
        headerCls:'panel-header-gray',
        pagination: true,
        pageSize: 20,
        pageList: [20, 50, 100],
        url:$URL,
        queryParams:{
            ClassName:"web.DHCANCODGroup",
            QueryName:"FindODGroup"
        },
        onBeforeLoad: function(param) {
	        param.deptID=session['LOGON.CTLOCID'];
        },
        columns:[
            [
               {field: "groupID", title: "���", width: 60, sortable: true },
               {field: "opDoctor", title: "����", width: 60, sortable: true},
               {field: "frtAst", title: "һ��", width: 60, sortable: true},
               {field: "secAst", title: "����", width: 60, sortable: true},
               {field: "trdAst", title: "����", width: 60, sortable: true},
               {field: "opDoctorId", title: "����id", width: 60, sortable: true},
               {field: "frtAstId", title: "һ��id", width: 60, sortable: true},
               {field: "secAstId", title: "����id", width: 60, sortable: true},
               {field: "trdAstId", title: "����id", width: 60, sortable: true}
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
	        oldGroupId=rowData.groupID;
	        
        }
    })

}

function InitOperDiag()
{
	$('#Surgeon').combobox("reload");
	$('#SurgonAss1').combobox("reload");
	$('#SurgonAss2').combobox("reload");
	$('#SurgonAss3').combobox("reload");
}
//����
function appendRow()
{
	    $("#operDialog").dialog({
        title: "��������ҽʦ��",
        iconCls: "icon-w-add"
    });
    InitOperDiag();
    $("#operDialog").dialog("open");

}
function editRow()
{
	var selectRow=$("#DocGroupData").datagrid("getSelected");
    if(selectRow)
    {
        $("#operDialog").dialog({
            title: "�޸�����ҽʦ��",
            iconCls: "icon-w-edit"
        });
        
        var groupId=selectRow.groupID;
        var surgeonId=selectRow.opDoctorId;
        var surgeonDesc=selectRow.opDoctor;
        var surgonAss1Id=selectRow.frtAstId;
        var surgonAss1Desc=selectRow.frtAst;
        var surgonAss2Id=selectRow.secAstId;
        var surgonAss2Desc=selectRow.secAst;
        var surgonAss3Id=selectRow.trdAstId;
        var surgonAss3Desc=selectRow.trdAst;
       
        $("#Surgeon").combobox('setValue',surgeonId)
        $("#SurgonAss1").combobox('setValue',surgonAss1Id)
        $("#SurgonAss2").combobox('setValue',surgonAss2Id)
        $("#SurgonAss3").combobox('setValue',surgonAss3Id)
       
        $("#groupDesc").val(groupId);
        //$("#SurgonAsso").combobox('setText',sSurgonAssoDesc)
        $("#operDialog").window("open");
        $("#EditOperation").val("Y");
        
    }else{
        $.messager.alert("��ʾ", "����ѡ��Ҫ�޸ĵļ�¼��", 'warning');
        return;
    }

	
}
function deleteRow()
{
var selectRow=$("#DocGroupData").datagrid("getSelected");
    if(selectRow)
    {
	    var groupId=selectRow.groupID;
	    var deptID=session['LOGON.CTLOCID'];
	    var datas=$.m({
        ClassName:"web.DHCANCODGroup",
        MethodName:"ODGroupDel",
        deptID:deptID,
        groupID:groupId
    },false);
    if(datas==0)
    {
	    $.messager.alert("��ʾ", "ɾ���ɹ���", 'info');
	    $("#DocGroupData").datagrid("reload");
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
	
	var surgeonId=$HUI.combobox("#Surgeon").getValue();
    var surgeonDesc=$HUI.combobox("#Surgeon").getText();
    if(surgeonId=="")
    {
        $.messager.alert("��ʾ","����ҽ������Ϊ�գ�","error");
        return;
    }
    var surgonAss1Id=$HUI.combobox("#SurgonAss1").getValue();
    var surgonAss1Desc=$HUI.combobox("#SurgonAss1").getText();
    if(surgonAss1Desc=="")
    {
	    surgonAss1Id="";
    }
    
    var surgonAss2Id=$HUI.combobox("#SurgonAss2").getValue();
    var surgonAss2Desc=$HUI.combobox("#SurgonAss2").getText();
    if(surgonAss2Desc=="")
    {
	    surgonAss2Id="";
    }
    
    var surgonAss3Id=$HUI.combobox("#SurgonAss3").getValue();
    var surgonAss3Desc=$HUI.combobox("#SurgonAss3").getText();
    if(surgonAss3Desc=="")
    {
	    surgonAss3Id="";
    }
    var groupId=""
    var groupId=$("#groupDesc").val();
    if(groupId=="")
    {
	     $.messager.alert("��ʾ","��Ų���Ϊ�գ�","error");
        return;
    }
      var rowdata={
         groupID:groupId,
       opDoctorId:surgeonId,
        opDoctor:surgeonDesc,
        frtAstId:surgonAss1Id,
        frtAst:surgonAss1Desc,
        secAstId:surgonAss2Id,
        secAst:surgonAss2Desc,
        trdAstId:surgonAss3Id,
        trdAst:surgonAss3Desc
    }
    var deptID=session['LOGON.CTLOCID'];
    var groupStr=surgeonId+"^"+surgonAss1Id+"^"+surgonAss2Id+"^"+surgonAss3Id;
     if( $("#EditOperation").val()=="Y")
    {
	//var res=cspRunServerMethod(modify,deptID,groupId,groupStr);
    var datas=$.m({
        ClassName:"web.DHCANCODGroup",
        MethodName:"ODGroupModify",
        deptID:deptID,
        groupID:groupId,
        oldGroupID:oldGroupId,
        groupStr:groupStr
    },false);
       $HUI.datagrid("#DocGroupData").updateRow({index:selectOperIndex,row:rowdata});
	$.messager.alert("��ʾ", "�޸ĳɹ���", 'info');
    }
    else
    {
	    
		//var res=cspRunServerMethod(modify,deptID,groupId,groupStr);
    	var datas=$.m({
        ClassName:"web.DHCANCODGroup",
        MethodName:"ODGroupAdd",
        deptID:deptID,
        groupID:groupId,
        groupStr:groupStr
    	},false);
    	$HUI.datagrid("#DocGroupData").appendRow(rowdata);
    	$.messager.alert("��ʾ", "��ӳɹ���", 'info');
    }
     $("#DocGroupData").datagrid("reload");
	$HUI.dialog("#operDialog").close();
	
}