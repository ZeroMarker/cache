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
       // title:'������סԺ���ҹ���ά��',
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
               {field: "outLocId", title: "�������Id", width: 60, sortable: true,hidden:true },
               {field: "outLocDesc", title: "�������", width: 160, sortable: true},
               {field: "inLocDesc", title: "סԺ����", width: 360, sortable: true},
               {field: "inLocIdStr", title: "סԺ����Id", width: 60, sortable: true,hidden:true}
            ]
        ],
        toolbar:[
            {
                iconCls: 'icon-add',
			    text:'����',
			    handler: function(){
                    addLink();
				}
            },
            {
                iconCls: 'icon-write-order',
			    text:'�޸�',
			    handler: function(){
                    editLink();
                }
            },
            {
                iconCls: 'icon-cancel',
			    text:'ɾ��',
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
//����
function addLink()
{
	    $("#operDialog").dialog({
        title: "����������סԺ���ҹ���ά��",
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
            title: "�޸�������סԺ���ҹ���ά��",
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
        $.messager.alert("��ʾ", "����ѡ��Ҫ�޸ĵļ�¼��", 'warning');
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
	    $.messager.alert("��ʾ", "ɾ���ɹ���", 'info');
	    $("#CtlocLinkList").datagrid("reload");
    }
    
    }
    else
    {
	    $.messager.alert("��ʾ", "����ѡ��Ҫɾ���ļ�¼��", 'error');
        return;
    }	
}
function saveLocLink()
{
	
	var outlocId=$HUI.combobox("#OutDept").getValue();
    var outlocDesc=$HUI.combobox("#OutDept").getText();
    if(outlocId=="")
    {
        $.messager.alert("��ʾ","������Ҳ���Ϊ�գ�","error");
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
    	$.messager.alert("��ʾ", "�����ɹ���", 'info');
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
