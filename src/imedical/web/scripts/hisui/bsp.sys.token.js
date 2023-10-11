function showDataInfo(token){
	$('<div id="dataInfoDiv"></div>').appendTo("body").dialog({
		title:"扩展数据列表",
		modal:true,isTopZindex:true,width:460,height:500,maximizable:true,resizable:true,
		content: '<table id="_pgrid"></table>',
		onBeforeClose:function(){$("#_pgrid").datagrid('getPanel').panel('destroy');},
	}).show();
	$("#_pgrid").propertygrid({
		border:false,url:$URL,
		queryParams:{ClassName:"BSP.SYS.SRV.Token",QueryName:"FindData",Token:token},
		//data:getTransData(),
		fit:true});
}

$(function () {
	$("#groupdesc").lookup({
		url:$URL+"?ClassName=web.SSGroup&QueryName=LookUp",className: "web.SSGroup", queryName: "LookUp", mode: "remote",
		id: "HIDDEN", textField: "Description", pagination: true, panelWidth: 420, onBeforeLoad(para) {
			para.desc = $("#groupdesc").val();
		}
	});
	$("#locdesc").lookup({
		url: $URL + "?ClassName=web.CTLoc&QueryName=LookUp", className: "web.CTLoc", queryName: "LookUp", mode: "remote",
		id: "HIDDEN", textField: "Description", pagination: true, panelWidth: 420, onBeforeLoad(para) {
			para.desc = $("#locdesc").val();
		}
	});
	$("#Find").click(function(){
		$("#tokenList").datagrid('load',{
			username:getValueById("username"),ipaddr:getValueById("ipaddr"),
			groupdesc: getValueById("groupdesc"),locdesc: getValueById("locdesc")
		});
	});
	$("#username,#ipaddr").on('keydown',function(evt){
		if (13==evt.keyCode) {
			$("#Find").click();
		}
	});
	$("#tokenList").datagrid({
		className:"BSP.SYS.SRV.Token",
		queryName:"Find",
		url:$URL+"?ClassName=BSP.SYS.SRV.Token&QueryName=Find",
		fit:true,
		border: false,
		pagination: true,
		rownumbers:true,
		onColumnsLoad:function(cm){
			for (var i=0;i<cm.length;i++){
				if (cm[i].field=='SessionId'){
					cm[i].formatter = function(val,row,index){
						return '<a href="#" onclick="showDataInfo(\''+val+'\');">'+val+'</a>';
					}
				}
			}
		},
		onBeforeLoad:function(p){
			p.IPAddr = $("#IPAddr").val();
			p.MacAddr = $("#MacAddr").val();
			p.Note = $("#Note").val();
		},
	});
});