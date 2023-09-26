var editIndex;
var oldGroupId;
var selectOperIndex;

$(function(){
	InitFormItem();
	InitGroupData();
});
function InitFormItem()
{
	     var appLocobj=$HUI.combobox("#OutDept",{
	        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
	        valueField:"ctlocId",
	        textField:"ctlocDesc",
	        onBeforeLoad:function(param)
	        {
	            param.desc=param.q;
	            param.locListCodeStr="OUTOPDEPT";
	            param.EpisodeID="";
	        } ,
	        mode:"remote"
	     });
	var inLocobj=$HUI.combobox("#InDept",{
	        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
	        valueField:"ctlocId",
	        textField:"ctlocDesc",
	        multiple: true,
	        rowStyle:'checkbox',
	        onBeforeLoad:function(param)
	        {
	            param.desc=param.q;
	            param.locListCodeStr="INOPDEPT";
	            param.EpisodeID="";
	        } ,
	        mode:"remote"
	     });
        
}
function InitGroupData()
{
	    $("#CtlocLinkList").datagrid({
        singleSelect: true,
        fitColumns:true,
        fit:true,
       // title:'门诊与住院科室关联维护',
        iconCls:'icon-paper',
        rownumbers: true,
        headerCls:'panel-header-gray',
        pagination: true,
        pageSize: 20,
        pageList: [20, 50, 100],
        url:$URL,
        queryParams:{
            ClassName:"web.DHCANOPOutInDeptLink",
            QueryName:"FindOutInDeptLink"
        },
        onBeforeLoad: function(param) {
	        param.deptId="";
        },
        columns:[
            [
               {field: "outLocId", title: "门诊科室Id", width: 60, sortable: true,hidden:true },
               {field: "outLocDesc", title: "门诊科室", width: 160, sortable: true},
               {field: "inLocDesc", title: "住院科室", width: 360, sortable: true},
               {field: "inLocIdStr", title: "住院科室Id", width: 60, sortable: true,hidden:true}
            ]
        ],
        toolbar:[
            {
                iconCls: 'icon-add',
			    text:'新增',
			    handler: function(){
                    addLink();
				}
            },
            {
                iconCls: 'icon-write-order',
			    text:'修改',
			    handler: function(){
                    editLink();
                }
            },
            {
                iconCls: 'icon-cancel',
			    text:'删除',
			    handler: function(){
                    deleteLink();
                }
            }
        ],
        onSelect:function(rowIndex, rowData){
	        selectOperIndex=rowIndex;
	        oldGroupId=rowData.outLocId;
	        
        }
    })

}

function InitOperDiag()
{
	$('#OutDept').combobox("reload");
	$('#InDept').combobox("reload");
}
//新增
function addLink()
{
	    $("#operDialog").dialog({
        title: "新增门诊与住院科室关联维护",
        iconCls: "icon-w-add"
    });
    InitOperDiag();
    $("#operDialog").dialog("open");

}
function editLink()
{
	var selectRow=$("#CtlocLinkList").datagrid("getSelected");
    if(selectRow)
    {
        $("#operDialog").dialog({
            title: "修改门诊与住院科室关联维护",
            iconCls: "icon-w-edit"
        });
        
        var outLocId=selectRow.outLocId;
        var outLocDesc=selectRow.outLocDesc;
        var inLocDesc=selectRow.inLocDesc;
        var inLocId=selectRow.inLocIdStr;
        var inLocShow=getDescStr(inLocDesc);
       var inLocShowId=getIdStr(inLocId);
        $("#OutDept").combobox('setValue',outLocId)
        $("#InDept").combobox('setValues',inLocShowId)
        $("#InDept").combobox('setText',inLocShow);
        $("#operDialog").window("open");
        $("#EditOperation").val("Y");
        
    }else{
        $.messager.alert("提示", "请先选择要修改的记录！", 'warning');
        return;
    }

	
}
function deleteLink()
{
var selectRow=$("#CtlocLinkList").datagrid("getSelected");
    if(selectRow)
    {
	    var outLocId=selectRow.outLocId;
	    var datas=$.m({
        ClassName:"web.DHCANOPOutInDeptLink",
        MethodName:"OutInDeptLinkDel",
        deptID:outLocId
    },false);
    if(datas==0)
    {
	    $.messager.alert("提示", "删除成功！", 'info');
	    $("#CtlocLinkList").datagrid("reload");
    }
    
    }
    else
    {
	    $.messager.alert("提示", "请先选择要删除的记录！", 'error');
        return;
    }	
}
function saveLocLink()
{
	
	var outlocId=$HUI.combobox("#OutDept").getValue();
    var outlocDesc=$HUI.combobox("#OutDept").getText();
    if(outlocId=="")
    {
        $.messager.alert("提示","门诊科室不能为空！","error");
        return;
    }
    var inlocId=getInDept();
    var inlocDesc=$HUI.combobox("#InDept").getText();
    if(inlocDesc=="")
    {
	    inlocId="";
    }
      var rowdata={
         outLocId:outlocId,
       outLocDesc:outlocDesc,
        inLocDesc:inlocDesc,
        inLocIdStr:inlocId
    }
  
		//var res=cspRunServerMethod(modify,deptID,groupId,groupStr);
    	var datas=$.m({
        ClassName:"web.DHCANOPOutInDeptLink",
        MethodName:"OutInDeptLinkModify",
         outlocId:outlocId,
        inlocId:inlocId
    	},false);
    	$HUI.datagrid("#CtlocLinkList").appendRow(rowdata);
    	$.messager.alert("提示", "操作成功！", 'info');
     $("#CtlocLinkList").datagrid("reload");
	$HUI.dialog("#operDialog").close();
	
}
function getIdStr(str)
{
    var idStr=[];
    var strList=str.split(",");
    if(strList.length>0)
    {
        for(var i=0;i<strList.length;i++)
        {
            var id=strList[i];
            idStr.push(id);
        }
    }
    return idStr;
}
function getDescStr(str)
{
    var descStr=[];
    var strList=str.split(",");
    if(strList.length>0)
    {
        for(var i=0;i<strList.length;i++)
        {
            var desc=strList[i];
            descStr.push(desc);
        }
    }
    return descStr;
}
function getInDept(){
    var inDeptArray = $("#InDept").combobox("getValues"),
        inDeptId="";
    if(inDeptArray&&inDeptArray.length>0)
    {
        inDeptId= inDeptArray.join(",");
    }
    return inDeptId;
}
