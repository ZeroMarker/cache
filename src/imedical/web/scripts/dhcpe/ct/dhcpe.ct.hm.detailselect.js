/*
 * Description: 问卷基本内容选择界面
 * FileName: dhcpe.ct.hm.detailselect.js
 * Author: wangguoying
 * Date: 2021-08-13
 */

function init_tree(param){
	
	$HUI.tree("#DetailTree",{
		url:$URL+"?ClassName=web.DHCPE.CT.HM.CommonData&MethodName=GetDetailTree&SubjectId="+$("#H_CQDSubjectDR").val()+"&QSubjectId="+$("#H_CQuesSubjectDR").val()+"&Param="+encodeURI(param)+"&ResultSetType=array",
		lines:true,
		animate:true,
		checkbox:true,
		onBeforeCheck:function(node,checked){
			if( node.sysDefault == 1 ){
				if(!checked){
					$.messager.popover({type:"alert",msg:"系统数据，不允许取消"});
				}
				return checked;
			}
		},
		onBeforeSelect:function(node){
			return node.sysDefault == 0;
		},
		onSelect:function(node){
			if(node.sysDefault == 0){	//非系统选中
				var method = node.checked ? "uncheck" : "check";
				$("#DetailTree").tree(method,node.target);
			}
		},
		onBeforeLoad:function(node, param){
			$.messager.progress({title:"提示",text:"数据加载中····"});
		},
		onLoadSuccess:function(node,data){
			$.messager.progress("close");	
		}
	});
}

function search(value,name){
	init_tree(value);
}

function init(){
	init_tree("");
}

$(init);