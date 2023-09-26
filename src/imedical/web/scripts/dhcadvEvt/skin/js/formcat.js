
$(function(){ 
	document.onkeydown = function(e){ 
    var ev = document.all ? window.event : e;
    	if(ev.keyCode==13) {
			commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
     	}
	}
	
	$(":radio").click(function(){
   		commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
  	});
  	
  	$('#hospID').combobox({ //hxy 2019-07-20 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMON&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	}) //ed
});
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{hospDr:LgHospID}}) //hxy 2019-07-03 LgHospID
}

function save(){
	saveByDataGrid("web.DHCADVFormCat","save","#datagrid",function(data){
		//修改
		if(data==0){
			$.messager.alert('提示','保存成功');
			$("#datagrid").datagrid('reload'); 
		}else{
			if((data=11)||(data=12)){
				$.messager.alert('提示','保存失败:分类代码已存在!')
			}else{
				$.messager.alert('提示','保存失败:'+data)
			}
		}
		
	});	
}
function back(){
	window.location.href="dhcadv.formname.csp"
}
/// 删除
function delCat(){
	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("提示","请选择数据!");
		return;	
	}
	
	$.messager.confirm("操作提示", "确认要删除数据吗？", function (data) {  
            if (data) {  
                runClassMethod(
					"web.DHCADVFormCat",
				    "remove",
					{
		 				'id':rowsData.ID
		 			},
		 			function(data){
			 			//修改
						if(data==0){
							$.messager.alert('提示','删除成功');
							$("#datagrid").datagrid('reload'); 
						}else{
							if((data=-1)){
								$.messager.alert('提示','删除失败:分类已在表单维护中使用!')
							}else{
								$.messager.alert('提示','删除失败:'+data)
							}
						}
					},"text");
            } 
    }); 
}
