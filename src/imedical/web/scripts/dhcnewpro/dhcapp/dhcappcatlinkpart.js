/// Creator: huaxiaoying
/// CreateDate: 2016-4-14
//  Descript:ҽ�������벿λ(�Ӳ�λ)����ά��
var ACCheck=getParam("cat");
$(function(){ 
	//��λ����ʼ��ʾ
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
				        	//$.messager.alert("��ʾ","����ɹ�!");
				        	$("#datagrid").datagrid('reload')
				        	///�����ˢ��tree
				        	$('#ACPart').tree('reload')   
			            }else if(data==1){
				        	$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				        	$("#datagrid").datagrid('reload') 
	 				    }else{
		 				     $.messager.alert("��ʾ","����ʧ��!");
		 				}}
	 				)
    }
	 				  	
}

function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	     var row =$("#datagrid").datagrid('getSelected');   
	       
		 runClassMethod("web.DHCAPPCatLinkPart","remove",{'ID':row.ID,'ACSubPart':row.ACSubPart},function(data){ $('#datagrid').datagrid('load');$('#ACPart').tree('reload'); })
		 ///ɾ����ˢ��tree
		 //$('#ACPart').tree('reload')
    }    
}); 
}
///���ƺ�ˢ��
function reloadTreeGrid(){
    $("#datagrid").datagrid('reload')
	$('#ACPart').tree('reload')
	}


