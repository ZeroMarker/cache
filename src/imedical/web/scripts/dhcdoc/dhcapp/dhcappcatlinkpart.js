/// Creator: huaxiaoying
/// CreateDate: 2016-4-14
//  Descript:医嘱子类与部位(子部位)关联维护
var ACCheck=getParam("cat");
$(function(){ 
	//部位面板初始显示
	$('#ACPart').tree({
		url: LINK_CSP+'?ClassName=web.DHCAPPCatLinkPart&MethodName=GetTreeCombo2&CatRowId='+ACCheck+'&type='+0, 
		checkbox:true,
		multiple: true,
		lines:true,
		animate:true,   
		required: true,
		onCheck:function(node, checked){
			//alert(node.id); 
			 }
	});
	
   $("#datagrid").datagrid('load',{CatRowId:ACCheck});  
});

function radio(type){
	var ifdoFlag=type;
	//var ifdoFlag=$('input[type="radio"][name="ifdoFlag"]').val(); 
	 if(ifdoFlag==0){
	   $('#ACPart').tree({ 
		  url: LINK_CSP+"?ClassName=web.DHCAPPCatLinkPart&MethodName=GetTreeCombo2&CatRowId="+ACCheck, 
		  checkbox:true,
		  multiple: true,
		  lines:true,
		  animate:true,   
		  required: true,
		  onCheck:function(node, checked){
			//alert(node.id); 
			 }
	      });
	  }else{
		   $('#ACPart').tree({
		   url: LINK_CSP+"?ClassName=web.DHCAPPPart&MethodName=getTreeCombo", 
		   checkbox:true,
		   multiple: true,
		   lines:true,
		   animate:true,   
		   required: true,
		   onCheck:function(node, checked){
			 //alert(node.id); 
			  }
	       });}
	     
	}
	
function save(){
	var ACCheck=getParam("cat");
    var nodes = $('#ACPart').tree('getChecked');	// get checked nodes
    for(i=0;i<nodes.length;i++){
	   var ACPart=nodes[i].id;
	   //postReq("web.DHCAPPCatLinkPart","Save","saveOrUpdateForm",successHandler);	
	   runClassMethod(
	 				"web.DHCAPPCatLinkPart",
	 				"Save",
	 				{
		 				'ACCheck':ACCheck,
	 				    'ACPart':ACPart
	 				 },
	 				 function(data){ 
	 				 	if(data==0){
				        	//$.messager.alert("提示","保存成功!");
				        	$("#datagrid").datagrid('reload')
				        	///保存后刷新tree
				        	$('#ACPart').tree('reload')   
			            }else if(data==1){
				        	$.messager.alert("提示","该项已存在,不能重复保存!"); 
				        	$("#datagrid").datagrid('reload') 
	 				    }else{
		 				     $.messager.alert("提示","保存失败!");
		 				}}
	 				)
    }
	 				  	
}

function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	     var row =$("#datagrid").datagrid('getSelected');   
	       
		 runClassMethod("web.DHCAPPCatLinkPart","remove",{'ID':row.ID,'ACSubPart':row.ACSubPart},function(data){ $('#datagrid').datagrid('load');$('#ACPart').tree('reload'); })
		 ///删除后刷新tree
		 //$('#ACPart').tree('reload')
    }    
}); 
}
///复制后刷新
function reloadTreeGrid(){
    $("#datagrid").datagrid('reload')
	$('#ACPart').tree('reload')
	}


