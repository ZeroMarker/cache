/**
 * ģ��:     ��Һ��������-������
 * ��д����: 2019-02-28
 * ��д��:   yunhaibao
 */
var PIVASBATCHRULES={
	tabBatTime:"dhcpha.pivas.batchrulestime.csp",		// ʱ�����
	tabBatWard:"dhcpha.pivas.batchrulesward.csp",		// ��������
	tabBatFreq:"dhcpha.pivas.batchrulesfreq.csp",	    // Ƶ�ι���
	tabBatOther:"dhcpha.pivas.batchrulesother.csp",	    // ��������
	tabBatHelp:"dhcpha.pivas.batchruleshelp.csp",	    // ����˵��
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