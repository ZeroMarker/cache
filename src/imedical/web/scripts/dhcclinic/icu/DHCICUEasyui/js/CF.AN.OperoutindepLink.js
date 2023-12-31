var editIndex;
var oldGroupId;
var selectOperIndex;

$(function(){
	InitFormItem();
	InitGroupData();
	
	$("#btnQuery").linkbutton({
        onClick:function(){
            $("#CtlocLinkList").datagrid("reload");
        }
    })
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
	       // multiple: true,
	       // rowStyle:'checkbox',
	        onBeforeLoad:function(param)
	        {
	            param.desc=param.q;
	            param.locListCodeStr="INOPDEPT";
	            param.EpisodeID="";
	        } ,
	        mode:"remote"
	     });
	    var LinkTypeData=$HUI.combobox("#LinkType",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        panelHeight:'auto',
        data:[{'typedesc':"日间手术住院科室",'typecode':"DaySurgery"},{'typedesc':"默认手术室",'typecode':"OperDept"},{'typedesc':"默认麻醉科",'typecode':"AnaDept"}]
    }) 
        
}
var tag="";
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
            ClassName:"CIS.AN.BL.OperoutindepLink",
            QueryName:"FindOutInDeptLink"
        },
        onBeforeLoad: function(param) {
	        param.deptId="";
	        param.deptDesc=$("#filterDesc").val();
	        param.linkLocDesc=$("#linkLocDesc").val()
        },
        columns:[
            [
               {field: "RowId", title: "RowId", width: 60, sortable: true },
               {field: "outLocId", title: "门诊科室Id", width: 60, sortable: true ,hidden:true},
               {field: "outLocDesc", title: "门诊科室", width: 160, sortable: true},
               {field: "inLocDesc", title: "住院科室", width: 160, sortable: true},
               {field: "inLocIdStr", title: "住院科室Id", width: 60, sortable: true,hidden:true},
               {field: "LinkTypeCode", title: "关联类型Id", width: 360, sortable: true,hidden:true},
               {field: "LinkTypeDesc", title: "关联类型", width: 100, sortable: true}
            
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
	tag="add"
	    $("#operDialog").dialog({
        title: "新增门诊与住院科室关联维护",
        iconCls: "icon-w-add"
    });
    InitOperDiag();
    $("#operDialog").dialog("open");
   
}
var rowId=""
function editLink()
{
	tag="edit"
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
        var LinkTypeId=selectRow.LinkTypeCode;
        var LinkTypeDesc=selectRow.LinkTypeDesc;
      rowId=selectRow.RowId;
    //  alert(outLocId)
        $("#OutDept").combobox('setValues',outLocId)
        $("#OutDept").combobox('setText',outLocDesc)
        $("#InDept").combobox('setValues',inLocShowId)
        $("#InDept").combobox('setText',inLocShow);
        $("#LinkType").combobox('setValues',LinkTypeId)
        $("#LinkType").combobox('setText',LinkTypeDesc);
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
	    var delRowId=selectRow.RowId;
	    //alert(delRowId)
	    var datas=$.m({
        ClassName:"CIS.AN.BL.OperoutindepLink",
        MethodName:"OutInDeptLinkDel",
        deptID:delRowId
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
	//alert(tag)
	var outlocId=$HUI.combobox("#OutDept").getValue();
    var outlocDesc=$HUI.combobox("#OutDept").getText();
    if(outlocId=="")
    {
        $.messager.alert("提示","门诊科室不能为空！","error");
        return;
    }
    var inlocId=$HUI.combobox("#InDept").getValue();
    var inlocDesc=$HUI.combobox("#InDept").getText();
    var LinkTypeId=$HUI.combobox("#LinkType").getValue();
    var LinkTypeDesc=$HUI.combobox("#LinkType").getText();
    //alert(LinkTypeId+LinkTypeDesc)
    if(inlocDesc=="")
    {
	    inlocId="";
    }
      
 // alert(1)
  if(tag=="add")
		//var res=cspRunServerMethod(modify,deptID,groupId,groupStr);
    	{
	    	var datas=$.m({
        ClassName:"CIS.AN.BL.OperoutindepLink",
        MethodName:"InserDeptLinkModify",
         outlocId:outlocId,
        inlocId:inlocId,
        LinkType:LinkTypeId
    	},false);
    	var rowdata={
	    	RowId:datas,
         outLocId:outlocId,
       outLocDesc:outlocDesc,
        inLocDesc:inlocDesc,
        inLocIdStr:inlocId
    };
    	$HUI.datagrid("#CtlocLinkList").appendRow(rowdata);
    	$.messager.alert("提示", "操作成功！", 'info');
     $("#CtlocLinkList").datagrid("reload");
	$HUI.dialog("#operDialog").close();
	}
	if(tag=="edit")
	{
		//alert(2)
		
		//alert(rowId)
	    var datas=$.m({
        ClassName:"CIS.AN.BL.OperoutindepLink",
        MethodName:"UpdateDeptLinkModify",
        RowId:rowId,
        outlocId:outlocId,
        inlocId:inlocId,
        LinkType:LinkTypeId
    	},false);
    		var rowdata={
	    	RowId:datas,
         outLocId:outlocId,
       outLocDesc:outlocDesc,
        inLocDesc:inlocDesc,
        inLocIdStr:inlocId
    };
    //alert(datas)
    	$HUI.datagrid("#CtlocLinkList").appendRow(rowdata);
    	$.messager.alert("提示", "操作成功！", 'info');
     $("#CtlocLinkList").datagrid("reload");
	$HUI.dialog("#operDialog").close();
	}
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
