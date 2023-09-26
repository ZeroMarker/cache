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
        title:'手术医师组维护',
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
               {field: "groupID", title: "组号", width: 60, sortable: true },
               {field: "opDoctor", title: "主刀", width: 60, sortable: true},
               {field: "frtAst", title: "一助", width: 60, sortable: true},
               {field: "secAst", title: "二助", width: 60, sortable: true},
               {field: "trdAst", title: "三助", width: 60, sortable: true},
               {field: "opDoctorId", title: "主刀id", width: 60, sortable: true},
               {field: "frtAstId", title: "一助id", width: 60, sortable: true},
               {field: "secAstId", title: "二助id", width: 60, sortable: true},
               {field: "trdAstId", title: "三助id", width: 60, sortable: true}
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
//新增
function appendRow()
{
	    $("#operDialog").dialog({
        title: "新增手术医师组",
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
            title: "修改手术医师组",
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
        $.messager.alert("提示", "请先选择要修改的记录！", 'warning');
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
	    $.messager.alert("提示", "删除成功！", 'info');
	    $("#DocGroupData").datagrid("reload");
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
	
	var surgeonId=$HUI.combobox("#Surgeon").getValue();
    var surgeonDesc=$HUI.combobox("#Surgeon").getText();
    if(surgeonId=="")
    {
        $.messager.alert("提示","手术医生不能为空！","error");
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
	     $.messager.alert("提示","组号不能为空！","error");
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
	$.messager.alert("提示", "修改成功！", 'info');
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
    	$.messager.alert("提示", "添加成功！", 'info');
    }
     $("#DocGroupData").datagrid("reload");
	$HUI.dialog("#operDialog").close();
	
}