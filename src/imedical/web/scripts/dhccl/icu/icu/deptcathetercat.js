$(function(){
	initCombobox();
	initDatagrid();
	initButton();
})
///初始化下来框控件
function initCombobox()
{
	/*var Loc = $HUI.combobox("#Loc",{	///科室
		valueField:'id',
		textField:'text',
        panelHeight:'auto',
		data:[
			{id:'210',text:'ICU二区'}
			,{id:'234',text:'ICU三区'}
			,{id:'60',text:'SCBU'}
			,{id:'61',text:'NICU'}
			,{id:'236',text:'CCU'}
			,{id:'558',text:'PICU'}	
		]
	})*/
	var Loc = $HUI.combobox("#Loc",{	///科室
		url:$URL+"?ClassName=Clinic.ICU.Catheter&QueryName=FindICULoc&ResultSetType=array",
		valueField:'ctlocId',
		textField:'ctlocDesc',
        //panelHeight:'auto',
        panelHeight:400,
        editable:true,
		onBeforeLoad:function(param){
			//param.desc=param.q,
            //param.locListCodeStr="",
            //param.EpisodeID=""
		}
	})
	
	$("#CategoryIn").combobox({	///分类
		url:$URL+"?ClassName=Clinic.ICU.Catheter&QueryName=FindCatheterCategory&ResultSetType=array",
        valueField:"RowId",
        textField:"Description",
        //panelHeight:'auto',
        panelHeight:400,
        editable:true,
        onBeforeLoad:function(param){}
	})

}
function initDatagrid()
{
	var catheterDatagrid=$("#deptcathetercat_datagrid").datagrid({	///列表数据
		fit: true,
        fitColumns:true,
        singleSelect: true,
        nowrap: false,
        rownumbers: true,
        pagination: true,
        title:"科室关联导管分类",
        pageSize: 20,
        pageList: [20, 50, 100],
		border:false,			 
        url:$URL,
        queryParams:{
            ClassName:"Clinic.ICU.Catheter",
            QueryName:"FindDeptCatheterCat"
        },
        onBeforeLoad:function(param){
	    },
        columns:[[
        	{ field: "RowId", title: "ID", width: 100, sortable: true },
        	{ field: "DeptID", title: "科室ID", width: 100, sortable: true },
        	{ field: "DeptDesc", title: "科室名称", width: 150, sortable: true },
        	{ field: "CatId", title: "分类ID", width: 100, sortable: true },
        	{ field: "CatDesc", title: "分类", width: 150, sortable: true }
       	]],
		onClickRow:function(){
            var row=$("#deptcathetercat_datagrid").datagrid('getSelected');
			$("#Loc").combobox('setValue',row.DeptID);
			$("#Loc").combobox('setText',row.DeptDesc);
			$("#CategoryIn").combobox('setValue',row.CatId);
			$("#CategoryIn").combobox('setText',row.CatDesc);
		}
	});
}
function initButton()
{
	$("#btnSearch").click(function(){	///查询
		$("#deptcathetercat_datagrid").datagrid('reload');
	})
	$HUI.linkbutton("#btnRefresh",{	///重置
		onClick: function(){
			//$("#deptcathetercat_datagrid").datagrid('reload');
			$("#Loc").combobox('setValue',"");
			$("#Loc").combobox('setText',"");
			$("#CategoryIn").combobox('setValue',"");
			$("#CategoryIn").combobox('setText',"");
        }
	})
	$("#btnAdd").click(function(){	///增加
		AddData();
	})
	$("#btnModify").click(function(){	///修改
		ModifyData();
	})
	$("#btnDelete").click(function(){	///删除
		DeleteData();
	})
}
function AddData(){	///增加
	var loc=$("#Loc").combobox('getValue');
	var cat=$("#CategoryIn").combobox('getValue');
	var result=$.m({
		ClassName:"Clinic.ICU.Catheter",
		MethodName:"SaveDeptCatheterCat",
		Location:loc,
		Category:cat
		
	},false);
	if(result==0)
	{
		$.messager.alert('成功',"添加成功！"+result,'warning');
		$("#deptcathetercat_datagrid").datagrid('reload');
	}
	else
	{
		$.messager.alert('失败',"删除失败:"+result,'warning');
		return;
	}
}
function ModifyData(){	///修改
	var objRow=$("#deptcathetercat_datagrid").datagrid('getSelected');
	if (!objRow)
	{
		$.messager.alert('提示','请选择一条信息！','warning');
		return;
	}
	var rowId=objRow.RowId
	var loc=$("#Loc").combobox('getValue');
	var cat=$("#CategoryIn").combobox('getValue');

	var result=$.m({
		ClassName:"Clinic.ICU.Catheter",
		MethodName:"ModifyDeptCatheterCat",
		rowId:rowId,
		Location:loc, 
		Category:cat
		
	},false);
	if(result==0)
	{
		$.messager.alert('成功',"修改成功！"+result,'warning');
		$("#deptcathetercat_datagrid").datagrid('reload');
	}
	else
	{
		$.messager.alert('失败',"修改失败！"+result,'warning');
		return;
	}
}
function DeleteData(){
	var objRow=$("#deptcathetercat_datagrid").datagrid('getSelected');
	if (!objRow)
	{
		$.messager.alert('提示','请选择一条信息！','warning');
		return;
	}
	var rowId=objRow.RowId
	
	var result=$.m({
		ClassName:"Clinic.ICU.Catheter",
		MethodName:"RemoveDeptCatheterCat",
		rowId:rowId
		
	},false);
	if(result==0)
	{
		$.messager.alert('成功',"删除成功！",'warning');
		$("#deptcathetercat_datagrid").datagrid('reload');
	}
	else
	{
		$.messager.alert('失败',"删除失败！",'warning');
		return;
	}
}
 