/// Creator: huaxiaoying
/// CreateDate: 2016-4-19
/// Descript:检查医嘱项与后处理关联
var ArcDr =getParam("itmmastid");  ///医嘱项ID
$(function(){ 
    
     //后处理 下拉选择
	$('#DispDr').combobox({
		url: LINK_CSP+"?ClassName=web.DHCAPPArcLinkDisp&MethodName=getDisp",
		valueField:'id',    
    	textField:'text'
	});
   
   //$("#datagrid").datagrid('load',{ArcRowId:ArcDr});
  
   $('#datagrid').datagrid({
		url:LINK_CSP+'?ClassName=web.DHCAPPArcLinkDisp&MethodName=list&ArcRowId='+ArcDr+'&HospID='+LgHospID
	});

});

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'ArcDr':ArcDr}}) 
}

function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCAPPArcLinkDisp","save","#datagrid",function(data){
			if(data==0){
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert('提示','不可重复保存:'+data)
				$("#datagrid").datagrid('reload')
			}else{
				$.messager.alert('提示','保存失败！'+data)
				}
		});	
		
}

///删除 
function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCAPPArcLinkDisp","remove",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}


