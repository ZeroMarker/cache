//BSP.SYS.BL.Param.js
var SuccessCallback = function(data){
	if(1==data){
		$("#Dlg").dialog('close');
		$("#tBSP_SYS_Param").datagrid("load");;
	}else{
		$.messager.alert("��ʾ",data);
	}
}
var init = function(){
	$("#addLink").click(function(){
		saveHandler("","","");
	});
	$("#editLink").click(function(){
		var thirdPartysListObj = $HUI.datagrid("#tBSP_SYS_Param");
		var row = thirdPartysListObj.getSelected();
		if (row){
			saveHandler(row.TID,row.PCode,row.PDesc);
		}
	});
	$("#delLink").click(function(){
		var dg = $HUI.datagrid("#tBSP_SYS_Param");
		var row = dg.getSelected();
		if (row){
			$.messager.confirm("ȷ��","ȷ��ɾ��?",function(r){
				if(r){
					$.cm({ClassName:"BSP.SYS.BL.Param",MethodName:"Delete","Id":row.TID},SuccessCallback);
				}
			});
		}
	});
	var saveHandler = function(id,pCode,pDesc){
		var jobj = $("#Dlg");
		if (jobj.length==0){
			jobj = $('<div id="Dlg" style="padding:10px;"></div>').appendTo('body');
		}
		jobj.dialog({
			iconCls:'icon-w-save',resizable:false,modal:true,
			width:260,height:250,title:"����ά��",
			content:'<table><tr><td></td><td><input type="hidden" id="paramId" value="'+(id||"")+'"></td></tr>'
			+'<tr><td class="r-label"><label >����</label></td><td><input class="textbox" id="paramDesc" value="'+pDesc+'"></td></tr>'
			+'<tr><td class="r-label"><label>����</label></td><td><input class="textbox" id="paramCode" value="'+pCode+'"></td></tr></table>',
			buttons:[{
				text:'����',
				handler:function(){
					$.cm({ClassName:"BSP.SYS.BL.Param",MethodName:"Save",
							"PDesc":$("#paramDesc").val(),
							"PCode":$("#paramCode").val(),
							"Id":$("#paramId").val()||""
						},SuccessCallback);
				}
			},{
				text:'�ر�',
				handler:function(){
					$("#Dlg").dialog('close');
				}
			}]
		});	
	};
};
$(init);