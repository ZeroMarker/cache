var patientListPage="";
$(function() {
	function initUI() {
		if (EpisodeID !== "") {
			setPatientInfo(EpisodeID)
		}
		initGrid();
	}
	function initGrid() {
		$('#skinTestGrid').datagrid('load', {
			ClassName: "Nur.SkinTestRecord",
			QueryName: "FindSkinTestRec",
			ResultSetType: 'array',
			OrderId: ParrOrderId
		});
	}
	
	function setPatientInfo(EpisodeID) {
		$.m({
			ClassName: "web.DHCDoc.OP.AjaxInterface",
			MethodName: "GetOPInfoBar",
			CONTEXT: "",
			EpisodeID: EpisodeID
		}, function(html) {
			if (html != "") {
				//$(".PatInfoItem").html(reservedToHtml(html));
				$(".patientbar").data("patinfo",html);
				if ("function"==typeof InitPatInfoHover) {InitPatInfoHover();}
				else{$(".PatInfoItem").html(reservedToHtml(html))}
				$(".PatInfoItem").find("img").eq(0).css("top",0);
			} else {
				$(".PatInfoItem").html($g("获取病人信息失败。请检查【患者信息展示】配置。"));
			}
		});
	}
	initUI();
});
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