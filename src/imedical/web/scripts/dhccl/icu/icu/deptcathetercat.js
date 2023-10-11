$(function(){
	initCombobox();
	initDatagrid();
	initButton();
})
///��ʼ��������ؼ�
function initCombobox()
{
	/*var Loc = $HUI.combobox("#Loc",{	///����
		valueField:'id',
		textField:'text',
        panelHeight:'auto',
		data:[
			{id:'210',text:'ICU����'}
			,{id:'234',text:'ICU����'}
			,{id:'60',text:'SCBU'}
			,{id:'61',text:'NICU'}
			,{id:'236',text:'CCU'}
			,{id:'558',text:'PICU'}	
		]
	})*/
	var Loc = $HUI.combobox("#Loc",{	///����
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
	
	$("#CategoryIn").combobox({	///����
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
	var catheterDatagrid=$("#deptcathetercat_datagrid").datagrid({	///�б�����
		fit: true,
        fitColumns:true,
        singleSelect: true,
        nowrap: false,
        rownumbers: true,
        pagination: true,
        title:"���ҹ������ܷ���",
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
        	{ field: "DeptID", title: "����ID", width: 100, sortable: true },
        	{ field: "DeptDesc", title: "��������", width: 150, sortable: true },
        	{ field: "CatId", title: "����ID", width: 100, sortable: true },
        	{ field: "CatDesc", title: "����", width: 150, sortable: true }
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
	$("#btnSearch").click(function(){	///��ѯ
		$("#deptcathetercat_datagrid").datagrid('reload');
	})
	$HUI.linkbutton("#btnRefresh",{	///����
		onClick: function(){
			//$("#deptcathetercat_datagrid").datagrid('reload');
			$("#Loc").combobox('setValue',"");
			$("#Loc").combobox('setText',"");
			$("#CategoryIn").combobox('setValue',"");
			$("#CategoryIn").combobox('setText',"");
        }
	})
	$("#btnAdd").click(function(){	///����
		AddData();
	})
	$("#btnModify").click(function(){	///�޸�
		ModifyData();
	})
	$("#btnDelete").click(function(){	///ɾ��
		DeleteData();
	})
}
function AddData(){	///����
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
		$.messager.alert('�ɹ�',"��ӳɹ���"+result,'warning');
		$("#deptcathetercat_datagrid").datagrid('reload');
	}
	else
	{
		$.messager.alert('ʧ��',"ɾ��ʧ��:"+result,'warning');
		return;
	}
}
function ModifyData(){	///�޸�
	var objRow=$("#deptcathetercat_datagrid").datagrid('getSelected');
	if (!objRow)
	{
		$.messager.alert('��ʾ','��ѡ��һ����Ϣ��','warning');
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
		$.messager.alert('�ɹ�',"�޸ĳɹ���"+result,'warning');
		$("#deptcathetercat_datagrid").datagrid('reload');
	}
	else
	{
		$.messager.alert('ʧ��',"�޸�ʧ�ܣ�"+result,'warning');
		return;
	}
}
function DeleteData(){
	var objRow=$("#deptcathetercat_datagrid").datagrid('getSelected');
	if (!objRow)
	{
		$.messager.alert('��ʾ','��ѡ��һ����Ϣ��','warning');
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
		$.messager.alert('�ɹ�',"ɾ���ɹ���",'warning');
		$("#deptcathetercat_datagrid").datagrid('reload');
	}
	else
	{
		$.messager.alert('ʧ��',"ɾ��ʧ�ܣ�",'warning');
		return;
	}
}
 