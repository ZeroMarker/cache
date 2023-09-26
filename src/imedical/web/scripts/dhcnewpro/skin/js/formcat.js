
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
});
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{}})
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
