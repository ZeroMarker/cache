var cls = "websys.DHCInterface";
var init = function(){
	$("#Update").click(function(){
		var r = $("#twebsys_DHCInterface").datagrid("getSelected");
		if (r && r["TID"]){
			var ID = r["TID"];
			websys_lu('websys.default.jquery.csp?WEBSYS.TCOMPONENT=websys.DHCInterface.Edit&ID='+ID,false,'top=20,left=300,height=800,width=900')
		}else{
			$.messager.alert("提示","请选择一行记录.");
		}
	});
	$("#Del").click(function(){
		var r = $("#twebsys_DHCInterface").datagrid("getSelected");
		if (r && r["TID"]){
			var ID = r["TID"];
			$.messager.confirm("提示","确认删除 "+r["TCaption"]+" 接口配置?",function(r){
				if (r){
					$.ajaxRunServerMethod({ClassName:cls,MethodName:"Del", ID:ID},
						function(rtn){
							if(parseInt(rtn)>0){
								$.messager.alert("提示","操作成功!");
								$("#Find").click();
							}else{
								$.messager.alert("提示",rtn.split("^")[1]);
							}
						}
					);
				}
			});
		}else{
			$.messager.alert("提示","请选择一行记录.");
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