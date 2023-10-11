// scripts/hisui/websys.Menu.EditUserSecurity.js
$(function(){
	$("#twebsys_Menu_EditUserSecurity").datagrid('options').onBeforeLoad = function(p){
		$.extend(p,{desc:getValueById("desc"),MenuID:getValueById("MenuID")});
	}
	$("#desc").on('keyup',function(e){
		if (e.keyCode==13){
			$('#twebsys_Menu_EditUserSecurity').datagrid('load');
		}
	})
	$("#update").off('click').click(function(){
		if (!$(this).linkbutton('options').disabled){
			var rows = $('#twebsys_Menu_EditUserSecurity').datagrid('getRows');
			var params = {};
			for (var i=0;i<rows.length;i++){
				var ed = $('#twebsys_Menu_EditUserSecurity').datagrid('getEditor', {index:i,field:'HasMenuAccess'});
				params["HIDDENz"+i]=rows[i].HIDDEN;
				if (ed.target.prop('checked')){
					params["HasMenuAccessz"+i]="on";
				}else{
					params["HasMenuAccessz"+i]="off";
				}
			}
			var obj = {
				ClassName:"BSP.SYS.BL.UserSettings",
				MethodName:"SaveMenuAccessUsers",
				MenuID:$("#MenuID").val()
			} 
			$cm($.extend({},obj,params),function(rtn){
				if(1==rtn){
					$.messager.popover({msg: '±£´æ³É¹¦',type:'success',timeout: 1000});
				}else{
					
				}
			});
		}
	});
});