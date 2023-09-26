/// Descript: 病理申请单状态对照维护
/// Creator : qunianpeng
/// Date    : 2017-11-16
var currEditRow="";

/// JQuery 初始化页面
$(function(){ 

	initPageDefault(); 
})

/// 页面初始化函数
function initPageDefault(){		
	
	//同时给代码和描述绑定回车事件
    $('#pisStatCode,#pisStatDesc').bind('keypress',function(event){
	    
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}) //调用查询
        }
    });
	
}

function addRow(){
	commonAddRow({'datagrid':'#datagrid'})
}

function onClickRow(index,row){
	currEditRow=row;
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCAPPStatContrast","SaveUpdStatus","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("提示","PIS代码已存在,不能重复保存!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==2){
				$.messager.alert("提示","PIS描述已存在,不能重复保存!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==3){
				$.messager.alert("提示","HIS描述,已经被对照，不能重复对照!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('提示','保存失败:'+data);				
			}
			$("#datagrid").datagrid('reload')
		});	
}

//删除
function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
	    if (r){
		    var row =$("#datagrid").datagrid('getSelected');     
			 runClassMethod("web.DHCAPPStatContrast","RemoveStat",{'id':row.contrastId},function(data){ $('#datagrid').datagrid('load'); })
	    }    
	}); 
}

///调用取值函数
function fillValue(rowIndex, rowData){
			
/*  ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'StatCode'});
	$(ed.target).val(rowData.statusDesc)
	ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'StatusId'});
	$(ed.target).val(rowData.statusId) */
	
}

