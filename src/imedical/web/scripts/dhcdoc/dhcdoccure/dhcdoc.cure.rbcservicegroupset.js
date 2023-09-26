var cureRBCServiceGroupSetDataGrid;
$(function(){ 
  InitCureRBCServiceGroupSet();
  $('#btnSave').bind('click', function(){
	  	if(!SaveFormData())return false;
   });
   LoadCureRBCServiceGroupSetDataGrid();
});	
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
		 $.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCServiceGroupSet","SaveCureRBCServiceGroupSet","false",function testget(value){
		if(value=="0"){
			$.messager.show({title:"提示",msg:"保存成功"});	
			$("#add-dialog").dialog( "close" );
			LoadCureRBCServiceGroupSetDataGrid()
			return true;							
		}else{
			var err=""
			if (value=="100") err="必填字段不能为空";
			else if (value=="101") err="代码重复";
			else err=value;
			$.messager.alert('Warning',err);
			return false;
		}
	   },"","",InputPara);
}
///修改表格函数
function UpdateGridData(){
   var rows = cureRBCServiceGroupSetDataGrid.datagrid('getSelections');
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
function InitCureRBCServiceGroupSet()
{
	var cureRBCServiceGroupSetToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
              $("#add-dialog").dialog("open");
	 			//清空表单数据
	 		  $('#add-form').form("clear")
	 		  $('#submitdata').val("添加")  
            }
        },
        '-', {
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
                var rows = cureRBCServiceGroupSetDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].Rowid);
                            }
                            var ID=ids.join(',')
							$.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCServiceGroupSet","DeleteCureRBCServiceGroupSet","false",function testget(value){
						        if(value=="0"){
							       cureRBCServiceGroupSetDataGrid.datagrid('load');
           					       cureRBCServiceGroupSetDataGrid.datagrid('unselectAll');
           					       $.messager.show({title:"提示",msg:"删除成功"});
						        }else{
							       $.messager.alert('提示',"删除失败:"+value);
						        }
						  
						   },"","",ID);
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },'-',{
			text: '修改',
			iconCls: 'icon-edit',
			handler: function() {
			  UpdateGridData();
			}
		}];
	cureRBCServiceGroupSetColumns=[[    
                    { field: 'Rowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'Code', title:'代码', width: 10, align: 'center', sortable: true  
					},
        			{ field: 'Desc', title: '描述', width: 20, align: 'center', sortable: true
					},
					{ field: 'DateFrom', title: '开始日期', width: 20, align: 'center', sortable: true, resizable: true
					},
					{ field: 'DateTo', title: '截止日期', width: 20, align: 'center', sortable: true,resizable: true
					}
    			 ]];
	cureRBCServiceGroupSetDataGrid=$('#tabCureRBCServiceGroupSet').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"PTRowid",
		pageList : [15,50,100,200],
		columns :cureRBCServiceGroupSetColumns,
		toolbar:cureRBCServiceGroupSetToolBar,
		onClickRow:function(rowIndex, rowData){
			PTRowid=rowData.PTRowid
		},
		onDblClickRow:function(rowIndex, rowData){ 
		 UpdateGridData();
			
       }
	});
}
function LoadCureRBCServiceGroupSetDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.RBCServiceGroupSet';
	queryParams.QueryName ='QueryServiceGroup';
	queryParams.ArgCnt =0;
	var opts = cureRBCServiceGroupSetDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	cureRBCServiceGroupSetDataGrid.datagrid('load', queryParams);
	cureRBCServiceGroupSetDataGrid.datagrid("unselectAll")
};
