var PageLogicObj={
	CureRBCServiceGroupSetDataGrid:"",
	m_ReHospitalDataGrid:""
}
var PageBaseSetObj={
	GroupID:"",
	editCatRow:undefined,
	LGroupObj:{GroupID:"",GroupDesc:""}
}

$(document).ready(function(){ 
	InitEvent();
	InitHospUser();
	InitRelateTemp();
});	
function InitHospUser(){
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}	
}

function Init()
{
	var UserHospID=GetUserHospID();
	var DocCureUseBase=$.m({
		ClassName:"DHCDoc.DHCDocCure.VersionControl",
		MethodName:"UseBaseControl",
		HospitalId:UserHospID,
		dataType:"text"
	},false);
	PageLogicObj.CureRBCServiceGroupSetDataGrid=InitDataGrid(DocCureUseBase);
}

function InitEvent(){
	$('#btnSave').bind('click', function(){
		if(!SaveFormData())return false;
	});
	$('#btnRelateTemp').click(function(){
		SaveRelateTemp();
	});
	$('#insertlink').bind("click",insertlinkRow);
	$('#savelink').bind("click",savelinkRow);
	$('#deletelink').bind("click",deletelinkRow);	
}
function CheckData(){
	var DDCSGSCode=$("#DDCSGSCode").val();
	if(DDCSGSCode=="")
	{
		 $.messager.alert("提示", "代码不能为空", 'warning')
        return false;
	}
	var DDCSGSDesc=$("#DDCSGSDesc").val();
	if(DDCSGSDesc=="")
	{
		$.messager.alert('提示','描述不能为空', 'warning');   
        return false;
	}
	var DDCSGSDateFrom=$("#DDCSGSDateFrom").datebox("getValue");
	if(DDCSGSDateFrom=="")
	{
		$.messager.alert('提示','开始日期不能为空', 'warning');   
        return false;
	}
	return true;
}
///修改表格函数
function SaveFormData(){
	if(!CheckData()) return false;    
	var DDCSGSROWID=$("#DDCSGSROWID").val();
	var DDCSGSCode=$("#DDCSGSCode").val();
	var DDCSGSDesc=$("#DDCSGSDesc").val();
	var DDCSGSDateFrom=$("#DDCSGSDateFrom").datebox("getValue");
	var DDCSGSDateTo=$("#DDCSGSDateTo").datebox("getValue");
	var InputPara=DDCSGSROWID+"^"+DDCSGSCode+"^"+DDCSGSDesc+"^"+DDCSGSDateFrom+"^"+DDCSGSDateTo;
	//alert(InputPara)
	var UserHospID=GetUserHospID();
	$.m({
		ClassName:"DHCDoc.DHCDocCure.RBCServiceGroupSet",
		MethodName:"SaveCureRBCServiceGroupSet",
		'str':InputPara,
		'hisui':"1",
		HospID:UserHospID
	},function testget(value){
		if(value=="0"){
			$.messager.show({title:"提示",msg:"保存成功"});	
			$("#add-dialog").dialog( "close" );
			CureRBCServiceGroupSetDataGridLoad()
			return true;							
		}else{
			var err=""
			if (value=="100") err="必填字段不能为空";
			else if (value=="101") err="代码重复";
			else if (value=="201") err="截止日期不能小于开始日期";
			else err=value;
			$.messager.alert('提示',err,"warning");   
			return false;
		}
	});
}
///修改表格函数
function UpdateGridData(){
   var rows = PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid("getSelections"); //PageLogicObj.CureRBCServiceGroupSetDataGrid.getSelections();
    if (rows.length ==1) {
       //$("#add-dialog").dialog("open");
        $('#add-dialog').window('open').window('resize',{width:'250px',height:'450px',top: 100,left:400});
        //清空表单数据
	 	$('#add-form').form("clear")
	 	
		 $('#add-form').form("load",{
		 DDCSGSROWID:rows[0].Rowid,
		 DDCSGSCode:rows[0].Code,
		 DDCSGSDesc:rows[0].Desc,
		 DDCSGSDateFrom:rows[0].DateFrom,
		 DDCSGSDateTo:rows[0].DateTo	 
	 })
	 
      $('#updateym').val("修改")    
     }else if (rows.length>1){
	     $.messager.alert("提示","您选择了多行！",'warning')
     }else{
	     $.messager.alert("提示","请选择一行！",'warning')
     }

}

function InitDataGrid(DocCureUseBase){
	var ServiceGroupSetToolBar = [
        {
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
              $("#add-dialog").dialog("open");
	 			//清空表单数据
	 		  $('#add-form').form("clear")
	 		  $('#submitdata').val("添加")  
            }
        },{
			text: '修改',
			iconCls: 'icon-edit',
			handler: function() {
				UpdateGridData();
			}
		},"-",{
			text: '关联医院',
			iconCls: 'icon-house',
			handler: function() {
				ReHospitalHandle();
			}
		},{
			text: '关联模板',
			iconCls: 'icon-save-tmpl',
			handler: function() {
				RelateTempHandle();
			}
		}];
	if(DocCureUseBase==0){
		ServiceGroupSetToolBar.push({
			text: '关联服务组',
			iconCls: 'icon-ref',
			handler: function() {
				LinkServiceGroupHandle();
			}
		})
	}
	var ServiceGroupSetColumns=[[    
			{ field: 'Rowid', title: 'ID', width: 1, align: 'center',hidden:true
			}, 
			{ field: 'Code', title:'代码', width: 100
			},
			{ field: 'Desc', title: '描述', width: 250
			},
			{ field: 'RelateAssTempDesc', title: '关联评估模板', width: 300
			},
			{ field: 'RelateAssTemp', title: '关联评估模板ID', width: 30, hidden: true
			},
			{ field: 'RelateRecordTempDesc', title: '关联记录模板', width: 200
			},
			{ field: 'RelateRecordTemp', title: '关联记录模板ID', width: 30, hidden: true
			},
			{ field: 'DateFrom', title: '开始日期', width: 260, resizable: true
			},
			{ field: 'DateTo', title: '截止日期', width: 260,resizable: true
			}
		]];
	var CureRBCServiceGroupSetDataGrid=$("#tabCureRBCServiceGroupSet").datagrid({ //$HUI.datagrid('#tabCureRBCServiceGroupSet',{  
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.RBCServiceGroupSet&QueryName=QueryServiceGroup&rows=99999",
		loadMsg : '加载中..',
		pagination : true, 
		rownumbers : true,
		idField:"Rowid",
		pageSize: 20,
		pageList : [20,50],
		columns :ServiceGroupSetColumns,
		toolbar:ServiceGroupSetToolBar,
		onDblClickRow:function(rowIndex, rowData){ 
			UpdateGridData();
       	},onBeforeLoad:function(param){
	       	$(this).datagrid("unselectAll");   	
			var UserHospID=GetUserHospID();
			$.extend(param,{config:"1",HospID:UserHospID});
	    }
	});
	return CureRBCServiceGroupSetDataGrid;
}

function CureRBCServiceGroupSetDataGridLoad()
{
	PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid("reload");
};
function GetUserHospID(){
	var UserHospID=$HUI.combogrid('#_HospUserList').getValue();
	return UserHospID
}

function ReHospitalHandle(){
	var row=PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！","warning")
		return false
	}
	var GenHospObj=GenHospWin("DHC_DocCureRBCServiceGroupSet",row["Rowid"])
}

function InitRelateTemp(){
	$HUI.combobox("#RelateAssTemp",{
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		url:$URL+"?ClassName=web.DHCDocAPPBL&QueryName=FindBLType&MapType=CA&ResultSetType=array",
		valueField:'RowID',
		textField:'BLTypeDesc'
	});	
	$HUI.combobox("#RelateRecordTemp",{
		multiple:false,
		selectOnNavigation:false,
		url:$URL+"?ClassName=web.DHCDocAPPBL&QueryName=FindBLType&MapType=CR&ResultSetType=array",
		valueField:'RowID',
		textField:'BLTypeDesc'
	});	
}

function RelateTempHandle(){
	var row=PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！","warning")
		return false
	}
	$("#RelateTemp-dialog").dialog("open");
	var RelateAssTemp=row.RelateAssTemp;
	var RelateAssTempArr=[];
	if(RelateAssTemp!=""){
		RelateAssTempArr=RelateAssTemp.split(",");
	}
	$('#RelateAssTemp').combobox('setValues',RelateAssTempArr);
	var RelateRecordTemp=row.RelateRecordTemp;
	$('#RelateRecordTemp').combobox('setValue',RelateRecordTemp);	
	return
	/*
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.RBCServiceGroupSet",
		MethodName:"GetGroupRelateAssTemp",
		DDCSGSRowid:row["Rowid"],
		dataType:"text"
	},function(str){
		$("#RelateAssTemp").combobox('select',str.split("^")[0]);
		$("#RelateAssTemp").next('span').find('input').focus();
	})*/
}

function SaveRelateTemp(){
	var row=PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！","warning")
		return false;
	}
	var ID=row["Rowid"];
	var RelateAssTempDR="",RelateRecordTempDR="";
	
	var RelateAssTempDR=$('#RelateAssTemp').combobox('getValues');
	if(!RelateAssTempDR){
		RelateAssTempDR="";
	}else{
		RelateAssTempDR=RelateAssTempDR.join(",");		
	}
	RelateRecordTempDR=$('#RelateRecordTemp').combobox('getValue');	
	$.m({
		ClassName:"DHCDoc.DHCDocCure.RBCServiceGroupSet",
		MethodName:"SaveGroupRelateAssTemp",
		DDCSGSRowid:ID,
		RelateAssTempDR:RelateAssTempDR,
		RelateRecordTempDR:RelateRecordTempDR
	},function testget(value){
		if(value=="0"){
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			$("#RelateTemp-dialog").dialog("close");
			CureRBCServiceGroupSetDataGridLoad();
			return true;							
		}else{
			$.messager.alert('提示',"保存失败,错误代码:"+value,"warning");   
			return false;
		}
	});
}
function LinkServiceGroupHandle(){
	var row=PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}else{
		PageBaseSetObj.GroupID=row.Rowid;
	}
	initLinkGrouplist();
	$("#link-dialog").dialog("open");
}


/// 初始化关联服务组
function initLinkGrouplist(){
	var UserHospID=GetUserHospID();
	var Cateditor={
		type: 'combobox',
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=DHCDoc.DHCDocCure.RBCServiceGroupSet&MethodName=InitServiceGroup&Config=&CuGroupID="+PageBaseSetObj.GroupID+"&HospID="+UserHospID,
			panelHeight:"280",
			filter: function(q, row){
				q=q.toUpperCase();
				return (row["SpellAlias"].indexOf(q) >= 0);
			},
			onSelect:function(option){
				var rows=$("#servicegrouplist").datagrid("selectRow",PageBaseSetObj.editCatRow).datagrid("getSelected");
	            PageBaseSetObj.LGroupObj.LGroupID=option.value;
	            PageBaseSetObj.LGroupObj.LGroupDesc=option.text;
			},
			onChange:function(newValue, oldValue){
				if (newValue==""){
					var rows=$("#servicegrouplist").datagrid("selectRow",PageBaseSetObj.editCatRow).datagrid("getSelected");
                    PageBaseSetObj.LGroupObj.LGroupID="";
                    PageBaseSetObj.LGroupObj.LGroupDesc="";
				}
			},
			onHidePanel:function(){
				var rows=$("#servicegrouplist").datagrid("selectRow",PageBaseSetObj.editCatRow).datagrid("getSelected");
				if (!$.isNumeric($(this).combobox('getValue'))) return;
				PageBaseSetObj.LGroupObj.LGroupID=$(this).combobox('getValue');
			}
		}
	}
	var columns=[[
		{field:"LGroupDesc",title:'服务组',width:300,editor:Cateditor},
		{field:"LGroupID",title:'服务组ID',width:150,align:'center',hidden:'true'},
		{field:"GroupLinkID",title:'LinkID',width:150,align:'center',hidden:'true'}
	]];
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {
            if (PageBaseSetObj.editCatRow != undefined) { 
                $("#servicegrouplist").datagrid('endEdit', PageBaseSetObj.editCatRow); 
            } 
            $("#servicegrouplist").datagrid('beginEdit', rowIndex); 
            PageBaseSetObj.editCatRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
			if(PageBaseSetObj.editCatRow!=undefined){
				$("#servicegrouplist").datagrid('endEdit', PageBaseSetObj.editCatRow);
				PageBaseSetObj.editCatRow=undefined;
			}
			PageBaseSetObj.LGroupObj={LGroupID:rowData.LGroupID,LGroupDesc:rowData.LGroupDesc}
			PageBaseSetObj.editCatRow = rowIndex; 
	    },
	    onAfterEdit:function(rowIndex, rowData, changes){
		    $(this).datagrid('updateRow',{
				index:rowIndex,
				row:PageBaseSetObj.LGroupObj
			});
			PageBaseSetObj.LGroupObj={LGroupID:"",LGroupDesc:""}
		    PageBaseSetObj.editCatRow=undefined;
	    },
	    onLoadSuccess:function(data){
		    $("#servicegrouplist").datagrid('unselectAll');
		    PageBaseSetObj.editCatRow=undefined;
		}
	};
	var UserHospID=GetUserHospID();
	var uniturl = LINK_CSP+"?ClassName=DHCDoc.DHCDocCure.RBCServiceGroupSet&MethodName=InitLinkServiceGroup&CuGroupId="+PageBaseSetObj.GroupID+"&HospID="+UserHospID;
	new ListComponent('servicegrouplist', columns, uniturl, option).Init();
}
function insertlinkRow()
{
	if (PageBaseSetObj.GroupID == ""){
		$.messager.alert("提示","请选择一个服务组!","info"); 
		return;	
	}	
	if(PageBaseSetObj.editCatRow!=undefined){
		$("#servicegrouplist").datagrid('endEdit',PageBaseSetObj.editCatRow);
	}
	$("#servicegrouplist").datagrid('clearSelections');
	$("#servicegrouplist").datagrid('insertRow', {
		index: 0, 
		row: {LGroupID: '',LGroupDesc:'',GroupLinkID: ''}
	});
	$("#servicegrouplist").datagrid('beginEdit', 0);	
	PageBaseSetObj.editCatRow=0;
	PageBaseSetObj.LGroupObj={LGroupID:"",LGroupDesc:""}
}

function savelinkRow(){
	if (PageBaseSetObj.GroupID == ""){
		$.messager.alert("提示","请选择一个服务组!","info"); 
		return;	
	}	
	if (PageBaseSetObj.editCatRow!=undefined){
		$("#servicegrouplist").datagrid('endEdit', PageBaseSetObj.editCatRow);
	}	
	var findindex=undefined;
	var DataList = [];
	var rowsData = $("#servicegrouplist").datagrid('getChanges');  
	if (rowsData.length<=0){
		$("#servicegrouplist").datagrid("rejectChanges").datagrid("unselectAll");
		$.messager.alert("提示","没有待保存数据!","info");
		return;
	}
	for(var i=0;i<rowsData.length;i++){
		var rowIndex=$("#servicegrouplist").datagrid("getRowIndex",rowsData[i]);
		if ((!rowsData[i].LGroupID)||(!rowsData[i].LGroupDesc))
		{
			$.messager.alert("提示","第"+(rowIndex+1)+"行服务组为空!","info");
			findindex=rowIndex;
			break;
		}
		
		var tmp=rowsData[i].GroupLinkID +"^"+ PageBaseSetObj.GroupID +"^"+ rowsData[i].LGroupID;
		DataList.push(tmp);
	} 
	if(findindex!=undefined){
		$("#servicegrouplist").datagrid('beginEdit', findindex);
		PageBaseSetObj.editCatRow=findindex;
		return false;	
	}
	var params=DataList.join("&&");
	var UserHospID=GetUserHospID();
	//保存数据
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.RBCServiceGroupSet",
		MethodName:"SaveLinkServiceGroup",
		LinkGroupStr:params,
		HospID:UserHospID,
		dataType:"text"
	},function(val){
		var Success=val.split("^")[0];
		var ErrMsg=val.split("^")[1];
		if (Success == "0"){
			$.messager.popover({msg:"保存成功.",type:"success",timeout:3000});
			LinkGroupReload();
		}else{			
			$.messager.alert('提示','保存失败：'+ErrMsg,"warning");
		}	
	})
}

/// 删除
function deletelinkRow(){
	var rowsData = $("#servicegrouplist").datagrid('getSelected');
	if((rowsData != null)&&(rowsData.GroupLinkID!="")){
		$.messager.confirm("提示", "您确定要删除选择的数据吗？", function (res) {
			if (res) {
				$.cm({
					ClassName:"DHCDoc.DHCDocCure.RBCServiceGroupSet",
					MethodName:"DeleteLinkServiceGroup",
					RowID:rowsData.GroupLinkID,
					dataType:"text"
				},function(val){
					var Success=val.split("^")[0];
					var ErrMsg=val.split("^")[1];
					if (Success == "0"){
						$.messager.popover({msg:"删除成功.",type:"success",timeout:3000});
						LinkGroupReload();
					}else{			
						$.messager.alert('提示','删除失败：'+ErrMsg,"warning");
					}	
				})
			}
		});
	}else{
		 if(PageBaseSetObj.editCatRow!=undefined){
			$("#servicegrouplist").datagrid('deleteRow', PageBaseSetObj.editCatRow);
			PageBaseSetObj.editCatRow=undefined;
		}else{
			$.messager.alert("提示","请选择需要删除的关联数据!","info");
			return;	
		}
	}
}
function LinkGroupReload(){
	$('#servicegrouplist').datagrid('reload');
	PageBaseSetObj.editCatRow=undefined;
	PageBaseSetObj.LGroupObj.GroupID="";
    PageBaseSetObj.LGroupObj.GroupDesc="";
    $("#servicegrouplist").datagrid('clearSelections');	
}

function translateClick(){
	var SelectedRow =  PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid("getSelected");
	if (!SelectedRow){
		$.messager.alert("提示","请选择需要翻译的行!","info");
		return false;
	}
	CreatTranLate("User.DHCDocCureRBCServiceGroupSet","DDCSGSDesc",SelectedRow["Desc"])
}