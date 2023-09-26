/**
 * 模块:     配液排批规则-主界面
 * 编写日期: 2019-02-28
 * 编写人:   yunhaibao
 */
var PIVASBATCHRULES={
	tabBatTime:"dhcpha.pivas.batchrulestime.csp",		// 时间规则
	tabBatWard:"dhcpha.pivas.batchrulesward.csp",		// 病区规则
	tabBatFreq:"dhcpha.pivas.batchrulesfreq.csp",	    // 频次规则
	tabBatOther:"dhcpha.pivas.batchrulesother.csp",	    // 其他规则
	tabBatHelp:"dhcpha.pivas.batchruleshelp.csp",	    // 规则说明
}

$(function(){
	$('#tabsBatchRules').tabs({   
		border:false,   
		onSelect:function(title){  
			LoadiFrame(); 
		}   
  	});

  	$("#tabBatTime").append('<iframe id="'+"tabBatTimeFrame"+'"></iframe>');
	$("#tabBatTimeFrame").attr("src",PIVASBATCHRULES['tabBatTime'])
})

function LoadiFrame(){
	var tabSelect=$('#tabsBatchRules').tabs('getSelected'); 
	var tabId=tabSelect.attr("id");
	var $tabId='#'+tabId;
	if (($($tabId +" iframe").length>0)&&(tabId!="tabBatTime")){
		return;
	}
	var newFrameId=tabId+'Frame'
	$($tabId).append('<iframe id="'+newFrameId+'"></iframe>');
	$("#"+newFrameId).attr("src",PIVASBATCHRULES[tabId]);
}