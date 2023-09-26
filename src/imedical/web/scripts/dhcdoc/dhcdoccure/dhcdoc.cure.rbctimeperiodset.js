var cureRBCTimePeriodSetDataGrid;
$(function(){ 
  InitCureRBCTimePeriodSet();
  $('#btnSave').bind('click', function(){
	  	if(!SaveFormData())return false;
   });
   LoadCureRBCTimePeriodSetDataGrid();
});	
function CheckData(){
	var DDCTSCode=$("#DDCTSCode").val();
	if(DDCTSCode=="")
	{
		 $.messager.alert("错误", "代码不能为空", 'error')
        return false;
	}
	var DDCTSDesc=$("#DDCTSDesc").val();
	if(DDCTSDesc=="")
	{
		$.messager.alert('Warning','时间段描述不能为空');   
        return false;
	}
	var DDCTSStartTime=$("#DDCTSStartTime").val();
	if(DDCTSStartTime=="")
	{
		$.messager.alert('Warning','开始时间不能为空');   
        return false;
	}
	var DDCTSEndTime=$("#DDCTSEndTime").val();
	if(DDCTSEndTime=="")
	{
		$.messager.alert('Warning','结束时间不能为空');   
        return false;
	}
	return true;
}
///修改表格函数
function SaveFormData(){
   		if(!CheckData()) return false;    
	    var DDCTSROWID=$("#DDCTSROWID").val();
	    var DDCTSCode=$("#DDCTSCode").val();
	    var DDCTSDesc=$("#DDCTSDesc").val();
	    var DDCTSStartTime=$("#DDCTSStartTime").val();
	    var DDCTSEndTime=$("#DDCTSEndTime").val();
	    var DDCTSEndChargeTime=$("#DDCTSEndChargeTime").val();
	    var DDCTSNotAvailFlag="";
	    if ($("#DDCTSNotAvailFlag").is(":checked")) {
		         DDCTSNotAvailFlag="Y";
	           }
	    var InputPara=DDCTSROWID+"^"+DDCTSCode+"^"+DDCTSDesc+"^"+DDCTSStartTime+"^"+DDCTSEndTime+"^"+DDCTSEndChargeTime+"^"+DDCTSNotAvailFlag;
		 //alert(InputPara)
		 $.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCTimePeriodSet","SaveCureRBCTimePeriodSet","false",function testget(value){
		if(value=="0"){
			$.messager.show({title:"提示",msg:"保存成功"});	
			$("#add-dialog").dialog( "close" );
			LoadCureRBCTimePeriodSetDataGrid()
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
   var rows = cureRBCTimePeriodSetDataGrid.datagrid('getSelections');
    if (rows.length ==1) {
       //$("#add-dialog").dialog("open");
        $('#add-dialog').window('open').window('resize',{width:'250px',height:'450px',top: 100,left:400});
        //清空表单数据
	 	$('#add-form').form("clear")
	 	if(rows[0].NotAvailFlag=="Y")
	 	{
	 	    var NotAvailFlag=true
	 	}else{
			var NotAvailFlag=false
		}
		$("#DDCTSNotAvailFlag").attr('checked',NotAvailFlag);
		 $('#add-form').form("load",{
		 DDCTSROWID:rows[0].Rowid,
		 DDCTSCode:rows[0].Code,
		 DDCTSDesc:rows[0].Desc,
		 DDCTSStartTime:rows[0].StartTime,
		 DDCTSEndTime:rows[0].EndTime,
		 DDCTSEndChargeTime:rows[0].EndChargeTime	 
	 })
	 
      $('#updateym').val("修改")    
     }else if (rows.length>1){
	     $.messager.alert("错误","您选择了多行！",'err')
     }else{
	     $.messager.alert("错误","请选择一行！",'err')
     }

}
function InitCureRBCTimePeriodSet()
{
	var cureRBCTimePeriodSetToolBar = [{
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
                var rows = cureRBCTimePeriodSetDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].Rowid);
                            }
                            var ID=ids.join(',')
							$.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCTimePeriodSet","DeleteCureRBCTimePeriodSet","false",function testget(value){
						        if(value=="0"){
							       cureRBCTimePeriodSetDataGrid.datagrid('load');
           					       cureRBCTimePeriodSetDataGrid.datagrid('unselectAll');
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
	cureRBCTimePeriodSetColumns=[[    
                    { field: 'Rowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'Code', title:'代码', width: 10, align: 'center', sortable: true  
					},
        			{ field: 'Desc', title: '时间段描述', width: 20, align: 'center', sortable: true
					},
					{ field: 'StartTime', title: '开始时间', width: 20, align: 'center', sortable: true, resizable: true
					},
					{ field: 'EndTime', title: '结束时间', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'EndChargeTime', title: '截止收费日期', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'NotAvailFlag', title: '不可用标记', width: 20, align: 'center', sortable: true,resizable: true
					}
					
    			 ]];
	cureRBCTimePeriodSetDataGrid=$('#tabCureRBCTimePeriodSet').datagrid({  
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
		columns :cureRBCTimePeriodSetColumns,
		toolbar:cureRBCTimePeriodSetToolBar,
		onClickRow:function(rowIndex, rowData){
			PTRowid=rowData.PTRowid
		},
		onDblClickRow:function(rowIndex, rowData){ 
		 UpdateGridData();
			
       }
	});
}
function LoadCureRBCTimePeriodSetDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.RBCTimePeriodSet';
	queryParams.QueryName ='QueryBookTime';
	queryParams.ArgCnt =0;
	var opts = cureRBCTimePeriodSetDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	cureRBCTimePeriodSetDataGrid.datagrid('load', queryParams);
	cureRBCTimePeriodSetDataGrid.datagrid("unselectAll")
};
