/*
 * Description: �ʾ��������ѡ�����
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
					$.messager.popover({type:"alert",msg:"ϵͳ���ݣ�������ȡ��"});
				}
				return checked;
			}
		},
		onBeforeSelect:function(node){
			return node.sysDefault == 0;
		},
		onSelect:function(node){
			if(node.sysDefault == 0){	//��ϵͳѡ��
				var method = node.checked ? "uncheck" : "check";
				$("#DetailTree").tree(method,node.target);
			}
		},
		onBeforeLoad:function(node, param){
			$.messager.progress({title:"��ʾ",text:"���ݼ����С�������"});
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