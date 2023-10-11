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
		{ field: 'transDate',title:'ת������',width:100},
		{ field: 'transTime',title:'ת��ʱ��',width:130},
		{ field: 'transType',title:'����',width:100},
		{ field: 'transFrom',title:'��Դ',width:130},
		{ field: 'transTo',title:'ת�Ƶ�',width:130},
		{ field: 'updateDate',title:'��������',width:100},
		{ field: 'updateTime',title:'����ʱ��',width:100},
		{ field: 'transUser',title:'����Ա',width:100}
	]];
	$('#tabTransferBedRecord').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : false,
		singleSelect : false,
		fitColumns : true,
		loadMsg : '������..',  
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
// ���ػ�����Ϣ������
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
		$(".PatInfoItem").html($g("��ȡ������Ϣʧ�ܡ����顾������Ϣչʾ�����á�"));
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
