/// Creator: congyue
/// CreateDate: 2016-09-01
//  Descript: 不良事件维护
$(function(){
	hospComp = GenHospComp("DHC_EmPatType");  //hxy 2020-05-20 st
	query();
	hospComp.options().onSelect = function(){///选中事件
		query();
	}//ed
})

function addRow(){
	var HospDr=hospComp.getValue(); //
	commonAddRow({'datagrid':'#datagrid',value:{'PTActiveFlag':'Y','PTHospDr':HospDr,'HospDr':HospDr}}) //hxy 2019-06-20 //hxy 2020-05-20 HospDr
}
//双击编辑
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCEmPatType","SavePatType","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==-11){ //hxy 2020-05-24 st
				$.messager.alert("提示","没有开启医院级授权!"); 
				$("#datagrid").datagrid('reload') //ed
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		});	
}
function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCEmPatType","RemovePatType",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

function query(){
	var HospDr=hospComp.getValue();
	$("#datagrid").datagrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEmPatType&MethodName=ListPatType&HospDr='+HospDr
	})
}


