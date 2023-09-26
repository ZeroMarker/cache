var interfaceID=0;
function searchMethod(){
	$('#methodlist').datagrid('load',{
		ClassName:"websys.DHCInterface",
		QueryName:"Find",
		Code:"",
		Caption:$("#captionInput").val(),
		Type:"E"
	})
}

function openAddWin(){
	$('#AddWin').window('open');
	$('#interfaceEdit').attr("src","websys.default.jquery.csp?WEBSYS.TCOMPONENT=websys.DHCInterface.Edit&ID=");
}
function openEditWin(id){
	if(!(id>0)) {
		return false;
	}
	$('#AddWin').window('open');
	$('#interfaceEdit').attr("src","websys.default.jquery.csp?WEBSYS.TCOMPONENT=websys.DHCInterface.Edit&ID="+id);
}
function editInterface(){
	var id=interfaceID;
	openEditWin(id);
}
$(function(){
	$('#methodlist').datagrid({
		rownumbers: false,
		pagination: false,
		striped:true,
		toolbar:"#tb",
		singleSelect:true,
		fit:true,
		fitColumns:true,
		queryParams: { 
			ClassName:"websys.DHCInterface",
			QueryName:"Find",
			Code:"",
			Caption:"",
			Type:"E"
		},
		onClickRow:function(rindex,rowData){
			var rtn=tkMakeServerCall( "websys.ComponentUtil", "CreateCompByInterfaceId",rowData.TID,0);
			var cmpname='Gen.'+rowData.TCls+'.'+rowData.TMth;
			var link='websys.default.csp?WEBSYS.TCOMPONENT='+cmpname+"&Page="+cmpname;
			//var panel=$('#lo').layout('panel','center').panel('refresh',link);
			document.getElementById('cmpiframe').src=link;
		},
		onRowContextMenu:function(e, rowIndex, rowData){
			//禁止浏览器的菜单打开
			e.preventDefault();
			$('#mm').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
			interfaceID=rowData.TID;
		},
		url:'jquery.easyui.querydatatrans.csp?page=1&rows=999',
		columns:[[
			{field:'TID',title:'TID',hidden:true},
			{field:'TCaption',title:'描述'},
			{field:'TSource',title:'来源组'},
			{field:'TCls',title:'类名'},
			{field:'TMth',title:'方法名'}
		]]
	}); 
})
