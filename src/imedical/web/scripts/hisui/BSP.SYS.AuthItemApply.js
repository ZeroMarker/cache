function getNewDescHtml(index){
	$("#grid").datagrid('selectRow',index);
	var row = $("#grid").datagrid('getSelected');
	websys_showModal({
		title:'变化详情',
		url:'bsp.sys.authitemapply.displaydata.csp?ID='+row['TID'],
		reloadMth:function(){$("#grid").datagrid('reload');},
		width:600,
		height:400
	});
}
function init(){
	var applyIf= function(object, config) {
        var property;
        if (object) {
            for (property in config) {
                if (config.hasOwnProperty(property) && object[property] === undefined) {
	                object[property] = config[property];
	            }
            }
        }
        return object;
    };
	$("#grid").mgrid({
		fitColumns:false,
		headerCls:'panel-header-gray',
		fit:true,
		title:'权力项申请列表',
		editGrid:false,
		codeField:"TID",
		className:"BSP.SYS.BL.AuthItemApply",
		queryName:"Find",
		onBeforeLoad:function(param){
			param.AuthCode = $('#AuthCode').val();
			param.order = "desc"
			param.sort = "TID";
		},
		toolbar:[{iconCls:'icon-stamp-cancel',text:'撤销申请',handler:function(){
			var row = $("#grid").datagrid('getSelected');
			$cm({ClassName :"BSP.SYS.SRV.AuthItemApply",MethodName:"Cancel",AuthId:row['TID']},function(json){
				if (json.code==200){
					$.messager.popover({msg: '撤销申请成功',type: 'success',timeout: 2000,showType: 'slide'});
					$("#grid").datagrid('reload');
				}else{
					$.messager.alert('提示',json.msg);
				}
			});
		}}],
		defaultsColumns:[[{"field":"AuthNewDesc",formatter:function(value,row,index){
				return '<a href="javascript:void(0);" onclick="getNewDescHtml('+index+');return false;">变更详情</a>';
				
			}}]]
	});
	$("#btn-find").click(function(){
		$("#grid").datagrid('reload');
	});
	$("#btn-clear").click(function(){
		$('#AuthCode').val('');
		$("#btn-find").click();
	});
	$('#AuthCode').on('keydown',function(e){
		if (e.keyCode==13){
			$("#btn-find").click();
		}
	});
}
$(init);