//页面Event
function InitLocScreeningWinEvent(obj){	
    
    obj.LoadEvent = function(args){
		$HUI.tabs("#divTabs",{
			onSelect:function(title,index){
				if (title.indexOf("疑似病例筛查")>=0){
					LinkUrl = "dhcma.hai.ir.ccscreening.csp?&LocFlag=1";
					$("#TabMain").attr("src", LinkUrl);
				}
				if (index==1){
					$("#divtab1").css('display','block');
					LinkUrl = "../scripts/DHCMA/HAI/Document/HelpWord.pdf";
					//LinkUrl = "../scripts/DHCMA/HAI/Document/HelpWord.html";
					$("#TabHelp").attr("src", LinkUrl);
					
				}	
				if (index==2){
					$("#divtab2").css('display','block');
				}
				if (index==3){
					$("#divtab3").css('display','block');
				}
				if (index==4){
					$("#divtab4").css('display','block');
				}
			}
		});
	}
}