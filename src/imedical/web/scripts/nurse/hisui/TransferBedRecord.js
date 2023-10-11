$(window).resize(function(){
	ResetDomSize();
})
$(function(){ 
	SetPatientBarInfo();
	InitTransferBedRecordDataGrid();
});
$(window).load(function() {
	$("#loading").hide();
})
function InitTransferBedRecordDataGrid(){
	var Columns=[[ 
		{ field: 'transDate',title:'转移日期',width:100},
		{ field: 'transTime',title:'转移时间',width:130},
		{ field: 'transType',title:'类型',width:100},
		{ field: 'transFrom',title:'来源',width:130},
		{ field: 'transTo',title:'转移到',width:130},
		{ field: 'updateDate',title:'操作日期',width:100},
		{ field: 'updateTime',title:'操作时间',width:100},
		{ field: 'transUser',title:'操作员',width:100}
	]];
	$('#tabTransferBedRecord').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : false,
		singleSelect : false,
		fitColumns : true,
		loadMsg : '加载中..',  
		pagination : false, 
		rownumbers : true,
		idField:"transID",
		columns :Columns,
		autoRowHeight:true,
		toolbar: [],
		url : $URL+"?ClassName=Nur.NIS.Service.Base.Patient&MethodName=GetTransRecord&EpisodeID="+ServerObj.EpisodeID,
		onBeforeLoad:function(param){
			$('#tabTransferBedRecord').datagrid("unselectAll"); 
		}
	})
}
// 加载患者信息条数据
var patientListPage="";
function SetPatientBarInfo() {
	InitPatInfoBanner(ServerObj.EpisodeID);
	/*var html=$m({
		ClassName: "web.DHCDoc.OP.AjaxInterface",
		MethodName: "GetOPInfoBar",
		CONTEXT: "",
		EpisodeID: ServerObj.EpisodeID
	},false);
	if (html != "") {
		$(".patientbar").data("patinfo",html);
		if ("function"==typeof InitPatInfoHover) {InitPatInfoHover();}
		else{$(".PatInfoItem").html(reservedToHtml(html))}
		$(".PatInfoItem").find("img").eq(0).css("top",0);
		
	} else {
		$(".PatInfoItem").html($g("获取病人信息失败。请检查【患者信息展示】配置。"));
	}*/
}
function reservedToHtml(str) {
	var replacements = {
		"&lt;": "<",
		"&#60;": "<",
		"&gt;": ">",
		"&#62;": ">",
		"&quot;": "\"",
		"&#34;": "\"",
		"&apos;": "'",
		"&#39;": "'",
		"&amp;": "&",
		"&#38;": "&"
	};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g, function(v) {
		return replacements[v];
	});
}
