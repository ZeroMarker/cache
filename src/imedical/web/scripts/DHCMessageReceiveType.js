//����ȫ��jquery����
var CodeJObj ,DescJObj,ReceiveIdJObj,cls = "websys.DHCMessageReceiveTypeMgr";
var DelJObj;
var delClick = function(){
	if (ReceiveIdJObj.val()==""){
		$.messager.alert('����','����ѡ���м�¼,��ɾ��!',"warning"); return false;
	}
	$.ajaxRunServerMethod({ClassName:cls,MethodName:"Delete",Id:ReceiveIdJObj.val()},
		function(data,textStatus){
			if ("undefined" == typeof data.err){
				if (data>0){
					//$.messager.alert('�ɹ�','ɾ���������ͳɹ�!');
					$("#Clear").click();
					$("#Find").click();
				}else{
					$.messager.alert('ʧ��','ɾ����������ʧ��!<br/><br/>�������:'+data,"error");  
				}
			}else{
				$.messager.alert('ʧ��','ɾ����������ʧ��!'+data.err);  
			}
		}
	);
}
$(function(){
	//var findTableHeight=parseInt($("#PageContent>table").css('height'));
	var dheight=500;
	var dsize=15;
	if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth){
		var winHeight = document.documentElement.clientHeight;
		var winWidth = document.documentElement.clientWidth;
		dheight=winHeight-100-5;
		dsize=parseInt((dheight-35)/25)-1;
	}
	$("#tDHCMessageReceiveType").datagrid({
		height:dheight,
		pageSize:dsize,
		pageList:[dsize]
	});
	CodeJObj = $("#Code");
	DescJObj = $("#Desc");
	ReceiveIdJObj = $("#ReceiveId");
	DelJObj = $("#Del");
	DelJObj.linkbutton('disable');
	$('#Save').click(function(){
		if (CodeJObj.val()==""){
			$.messager.alert('����','���벻��Ϊ��!');return false;
		}
		if (DescJObj.val()==""){
			$.messager.alert('����','��������Ϊ��!'); return false;
		}
		$.ajaxRunServerMethod({ClassName:cls,MethodName:"Save",Code:CodeJObj.val(),Desc:DescJObj.val(),Id:ReceiveIdJObj.val()},
			function(data,textStatus){
				if ("undefined" == typeof data.err){
					if (data>0){
						//$.messager.alert('�ɹ�','����������ͳɹ�!');
						$("#Clear").click();
						$("#Find").click();
					}else{
						$.messager.alert('ʧ��','�����������ʧ��!'+data);  
					}
				}else{
					$.messager.alert('ʧ��','�����������ʧ��!'+data.err);  
				}
			}
		);
	})
	
	$("#Clear").click(function(){
		CodeJObj.val("");
		DescJObj.val("");
		ReceiveIdJObj.val("");
		DelJObj.unbind("click",delClick).linkbutton('disable');
	});
	$("#tDHCMessageReceiveType").datagrid("options").onClickRow = function(index,rowData){
		if (index>-1){
			ReceiveIdJObj.val(rowData["DHCReceiveRowId"]);
			CodeJObj.val(rowData["DHCReceiveCode"]);
			DescJObj.val(rowData["DHCReceiveDesc"]);
			DelJObj.bind("click",delClick).linkbutton('enable');
		}
	};
})
