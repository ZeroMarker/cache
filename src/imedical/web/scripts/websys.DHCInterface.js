var cls = "websys.DHCInterface";
var init = function(){
	$("#Update").click(function(){
		var r = $("#twebsys_DHCInterface").datagrid("getSelected");
		if (r && r["TID"]){
			var ID = r["TID"];
			websys_lu('websys.default.jquery.csp?WEBSYS.TCOMPONENT=websys.DHCInterface.Edit&ID='+ID,false,'top=20,left=300,height=800,width=900')
		}else{
			$.messager.alert("��ʾ","��ѡ��һ�м�¼.");
		}
	});
	$("#Del").click(function(){
		var r = $("#twebsys_DHCInterface").datagrid("getSelected");
		if (r && r["TID"]){
			var ID = r["TID"];
			$.messager.confirm("��ʾ","ȷ��ɾ�� "+r["TCaption"]+" �ӿ�����?",function(r){
				if (r){
					$.ajaxRunServerMethod({ClassName:cls,MethodName:"Del", ID:ID},
						function(rtn){
							if(parseInt(rtn)>0){
								$.messager.alert("��ʾ","�����ɹ�!");
								$("#Find").click();
							}else{
								$.messager.alert("��ʾ",rtn.split("^")[1]);
							}
						}
					);
				}
			});
		}else{
			$.messager.alert("��ʾ","��ѡ��һ�м�¼.");
		}
	});
	$("#Code,#Caption").on("keydown",function(e){
		var k = e.keyCode;
		if (k==13){
			$("#Find").click();
		}
	});
}
$(init);