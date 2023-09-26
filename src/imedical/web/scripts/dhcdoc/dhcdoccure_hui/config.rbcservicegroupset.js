var PageLogicObj={
	CureRBCServiceGroupSetDataGrid:"",
	m_ReHospitalDataGrid:""
}
$(document).ready(function(){ 
	PageLogicObj.CureRBCServiceGroupSetDataGrid=Init();
	InitEvent();
	InitHospUser();
	//CureRBCServiceGroupSetDataGridLoad();
});	
function InitHospUser(){
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		CureRBCServiceGroupSetDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		CureRBCServiceGroupSetDataGridLoad();
	}	
}

function InitEvent(){
	$('#btnSave').bind('click', function(){
		if(!SaveFormData())return false;
	});
}
function CheckData(){
	var DDCSGSCode=$("#DDCSGSCode").val();
	if(DDCSGSCode=="")
	{
		 $.messager.alert("错误", "代码不能为空", 'error')
        return false;
	}
	var DDCSGSDesc=$("#DDCSGSDesc").val();
	if(DDCSGSDesc=="")
	{
		$.messager.alert('Warning','描述不能为空');   
        return false;
	}
	var DDCSGSDateFrom=$("#DDCSGSDateFrom").datebox("getValue");
	if(DDCSGSDateFrom=="")
	{
		$.messager.alert('Warning','开始日期不能为空');   
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
			$.messager.alert('提示',err);   
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
	     $.messager.alert("错误","您选择了多行！",'err')
     }else{
	     $.messager.alert("错误","请选择一行！",'err')
     }

}
function Init()
{
	var cureRBCServiceGroupSetToolBar = [
        {
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
              $("#add-dialog").dialog("open");
	 			//清空表单数据
	 		  $('#add-form').form("clear")
	 		  $('#submitdata').val("添加")  
            }
        }/*,
        {
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
                var rows = PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid("getSelections"); //PageLogicObj.CureRBCServiceGroupSetDataGrid.getSelections();
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].Rowid);
                            }
                            var ID=ids.join(',')
                            $.m({
								ClassName:"DHCDoc.DHCDocCure.RBCServiceGroupSet",
								MethodName:"DeleteCureRBCServiceGroupSet",
								'Rowid':ID
							},function(value){
								if(value=="0"){
							       //CureRBCServiceGroupSetDataGrid.load();
							       CureRBCServiceGroupSetDataGridLoad();
           					       PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid("unselectAll");
           					       $.messager.show({title:"提示",msg:"删除成功"});
						        }else{
							       $.messager.alert('提示',"删除失败:"+value);
						        }
							})	
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        }*/,{
			text: '修改',
			iconCls: 'icon-edit',
			handler: function() {
				UpdateGridData();
			}
		},{
			text: '关联医院',
			iconCls: 'icon-house',
			handler: function() {
				ReHospitalHandle();
			}
		}];
	cureRBCServiceGroupSetColumns=[[    
                    { field: 'Rowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'Code', title:'代码', width: 260, sortable: true  
					},
        			{ field: 'Desc', title: '描述', width: 300, sortable: true
					},
					{ field: 'DateFrom', title: '开始日期', width: 260, sortable: true, resizable: true
					},
					{ field: 'DateTo', title: '截止日期', width: 260, sortable: true,resizable: true
					}
    			 ]];
	var CureRBCServiceGroupSetDataGrid=$("#tabCureRBCServiceGroupSet").datagrid({ //$HUI.datagrid('#tabCureRBCServiceGroupSet',{  
		fit : true,
		//width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		//url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true, 
		rownumbers : true,
		idField:"Rowid",
		pageSize: 15,
		pageList : [15,50,100],
		columns :cureRBCServiceGroupSetColumns,
		toolbar:cureRBCServiceGroupSetToolBar,
		onClickRow:function(rowIndex, rowData){
		},
		onDblClickRow:function(rowIndex, rowData){ 
			UpdateGridData();
       }
	});
	return CureRBCServiceGroupSetDataGrid;
}

function CureRBCServiceGroupSetDataGridLoad()
{
	var UserHospID=GetUserHospID();
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.RBCServiceGroupSet",
		QueryName:"QueryServiceGroup",
		'config':1,
		HospID:UserHospID,
		Pagerows:PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData); 
	})

};
function GetUserHospID(){
	var UserHospID=$HUI.combogrid('#_HospUserList').getValue();
	return UserHospID
}

function ReHospitalHandle(){
	var row=PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	var GenHospObj=GenHospWin("DHC_DocCureRBCServiceGroupSet",row["Rowid"])
	return;
	//采用基础平台插件
	$("#ReHospital-dialog").dialog("open");
	$.cm({
			ClassName:"DHCDoc.DHCDocConfig.InstrArcim",
			QueryName:"GetHos",
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#Hosp", {
				editable:false,
				valueField: 'HOSPRowId',
				textField: 'HOSPDesc', 
				data: GridData["rows"],
				onLoadSuccess:function(){
					$("#Hosp").combobox('select','');
				}
			 });
	});
	PageLogicObj.m_ReHospitalDataGrid=ReHospitalDataGrid();
	LoadReHospitalDataGrid();
}
function ReHospitalDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {ReHospitaladdClickHandle();}
    }, {
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() {ReHospitaldelectClickHandle();}
    }];
	var Columns=[[ 
		{field:'Rowid',hidden:true,title:'Rowid'},
		{field:'HospID',hidden:true,title:'HospID'},
		{field:'HospDesc',title:'医院',width:100}
    ]]
	var ReHospitalDataGrid=$("#ReHospitalTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,50,100],
		idField:'Rowid',
		columns :Columns,
		toolbar:toobar
	}); 
	return ReHospitalDataGrid;
}
function LoadReHospitalDataGrid(){
	var row=PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	var ID=row["Rowid"]
	$.q({
	    ClassName : "web.DHCOPRegConfig",
	    QueryName : "FindHopital",
	    BDPMPHTableName:"DHC_DocCureRBCServiceGroupSet",
	    BDPMPHDataReference:ID,
	    Pagerows:PageLogicObj.m_ReHospitalDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ReHospitalDataGrid.datagrid("unselectAll");
		PageLogicObj.m_ReHospitalDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
	}
function ReHospitaladdClickHandle(){
	var HospID=$("#Hosp").combobox("getValue")
	if (HospID==""){
		$.messager.alert("提示","请选择医院","info");
		return false;
	}
	var row=PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	var ID=row["Rowid"]
	$.cm({
		ClassName:"web.DHCBL.BDP.BDPMappingHOSP",
		MethodName:"SaveHOSP",
		BDPMPHTableName:"DHC_DocCureRBCServiceGroupSet",
		BDPMPHDataReference:ID,
		BDPMPHHospital:HospID,
		dataType:"text",
	},function(data){
		if (data=="1"){
			$.messager.alert("提示","增加重复","info");
		}else{
			$.messager.popover({msg: data.split("^")[1],type:'success',timeout: 1000});
			LoadReHospitalDataGrid();
		}
	})
}
function ReHospitaldelectClickHandle(){
	var SelectedRow = PageLogicObj.m_ReHospitalDataGrid.datagrid('getSelected');
	if (!SelectedRow){
		$.messager.alert("提示","请选择一行","info");
		return false;
	}
	var row=PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	var ID=row["Rowid"]
	$.cm({
		ClassName:"web.DHCBL.BDP.BDPMappingHOSP",
		MethodName:"DeleteHospital",
		BDPMPHTableName:"DHC_DocCureRBCServiceGroupSet",
		BDPMPHDataReference:ID,
		BDPMPHHospital:SelectedRow.HospID,
		dataType:"text",
	},function(data){
		$.messager.popover({msg: '删除成功!',type:'success',timeout: 1000});
		LoadReHospitalDataGrid();
	})
	
}