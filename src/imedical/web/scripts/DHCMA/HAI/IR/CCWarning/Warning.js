$(function () {
	InitCCWarnWin();
});

function InitCCWarnWin(){
	//初始tab页签
	var tab = $('#divTabs').tabs('getSelected');
	var index = $('#divTabs').tabs('getTabIndex',tab);
	if (index==0) {
		LinkUrl = "dhcma.hai.ir.ccwarningmain.csp?";
		if ("undefined" !==typeof websys_getMWToken) {
			LinkUrl  += "&MWToken="+websys_getMWToken();
		}
		$("#TabMain").attr("src", LinkUrl);
	}
	$HUI.tabs("#divTabs",{
		onSelect:function(title,index){
			if (index==0){
				LinkUrl = "dhcma.hai.ir.ccwarningmain.csp?";
				if ("undefined" !==typeof websys_getMWToken) {
					LinkUrl  += "&MWToken="+websys_getMWToken();
				}
				$("#TabMain").attr("src", LinkUrl);
			}
			if (index==1){
				$("#divtab1").css('display','block');
				LinkUrl = "dhcma.hai.ir.ccwarningact.csp?";
				if ("undefined" !==typeof websys_getMWToken) {
					LinkUrl  += "&MWToken="+websys_getMWToken();
				}
				$("#TabAct").attr("src", LinkUrl);
				
			}	
			if (index==2){
				$("#divtab2").css('display','block');
				LinkUrl = "dhcma.hai.ir.ccwarningqry.csp?";
				if ("undefined" !==typeof websys_getMWToken) {
					LinkUrl  += "&MWToken="+websys_getMWToken();
				}
				$("#TabQry").attr("src", LinkUrl);
			}
		}
	});
}
