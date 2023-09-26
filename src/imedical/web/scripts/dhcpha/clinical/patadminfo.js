var EpisodeID = "";
var AdmType = "";
var PcntItmID = "";
$(function(){

	EpisodeID=getParam("EpisodeID");  ///就诊ID
	AdmType=getParam("AdmType");      ///就诊类型
	PcntItmID=getParam("PcntItmID");  ///点评单明细ID
	InitTabs(EpisodeID,AdmType,PcntItmID);
})

/// 初始化标签内容
function InitTabs(EpisodeID,AdmType,PcntItmID){
	if(AdmType == "In"){
		$('#ptab').append('<div id="icmt" title="点评住院"></div>');
	}else{
		$('#ptab').append('<div id="ocmt" title="点评门诊"></div>');
	}
	$('#ptab').append('<div id="pal" title="过敏记录"></div>');
	$('#ptab').append('<div id="ris" title="检查记录"></div>');
	$('#ptab').append('<div id="lab" title="检验记录"></div>');
	$('#ptab').append('<div id="epl" title="病历浏览"></div>');
	$('#ptab').append('<div id="ord" title="本次医嘱"></div>');
	$('#ptab').append('<div id="opr" title="手术信息"></div>');
	if(AdmType == "In"){
		$('#ptab').append('<div id="tmp" title="体温单"></div>');
	}

	$('#ptab').tabs({    
	    border:false,
	    fit:true, 
	    onSelect:function(title){
	        var tab = $('#ptab').tabs('getSelected');  // 获取选择的面板
	        var tbId = tab.attr("id");
	        var maintab="";
	        switch(tbId){
		        case "icmt":
					maintab="dhcpha.comment.inpatadminfo.csp";  //点评界面
					break;
		        case "ocmt":
					maintab="dhcpha.comment.outpatadminfo.csp";  //点评界面
					break;
	            case "pal":
					maintab="dhcpha.comment.paallergy.csp";  //过敏记录
					break;
				case "ris":
					maintab="dhcpha.comment.risquery.csp";   //检查记录
					break;
				case "lab":
					maintab="dhcpha.comment.labquery.csp";   //检验记录
					break;
				case "epl":
					maintab="dhcpha.clinical.jhepisodebrowser.csp";  //病历浏览
					break;
				case "ord":
					maintab="dhcpha.comment.queryorditemds.csp";  //本次医嘱
					break;
				case "opr":
					maintab="dhcpha.clinical.operquery.csp";  //手术信息
					break;
				case "tmp":
					maintab="dhcnurtempature.csp";    //体温单
					break;
			}
			//iframe 定义
	        var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+maintab+'?PatientID='+''+'&EpisodeID='+EpisodeID+'&PcntItmID='+PcntItmID+'"></iframe>';
	        tab.html(iframe);
	    }
	});

	if(AdmType == "In"){
		$('#ptab').tabs('select','点评住院'); //默认选中项
	}else{
		$('#ptab').tabs('select','点评门诊'); //默认选中项
	}
	
}

/// 重新加载病人信息
function refreshTabs(EpisodeID,AdmType,PcntItmID,PatName){
	InitTabs(EpisodeID,AdmType,PcntItmID);
	window.parent.updTabsTitle(PatName);
}