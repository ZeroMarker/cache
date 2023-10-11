//页面Event
function InitPatViewWinEvent(obj){	
    
    obj.LoadEvent = function(args){
		$HUI.tabs("#divTabs",{
			onSelect:function(title,index){				
				if (index==0){			//摘要
					$("#divtab0").css('display','block');
					LinkUrl = "dhcma.ir.view.summary.csp?EpisodeID="+EpisodeID+"&PaadmID="+PaadmID+"&1=1";
					//if($("#Tab0").attr("src")=="")
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#Tab0").attr("src", LinkUrl);	
								
				}	
				if (index==1){			//疑似筛查
					$("#divtab1").css('display','block');
					LinkUrl = "dhcma.hai.ir.patscreening.csp?EpisodeDr="+PaadmID+"&Paadm="+EpisodeID+"&LocFlag="+LocFlag+"&1=1";
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#Tab1").attr("src", LinkUrl);					
				}
				if (index==2){			//检验报告
					$("#divtab2").css('display','block');
					LinkUrl = "dhcma.hai.ir.view.lisreport.csp?EpisodeID="+EpisodeID+"&PaadmID="+PaadmID+"&1=1";
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#Tab2").attr("src", LinkUrl);					
				}
				if (index==3){			//抗菌用药
					$("#divtab3").css('display','block');
					LinkUrl = "dhcma.hai.ir.view.oeantlist.csp?EpisodeID="+EpisodeID+"&PaadmID="+PaadmID+"&1=1";
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#Tab3").attr("src", LinkUrl);					
				}
				if (index==4){			//器械相关治疗
					$("#divtab4").css('display','block');
					LinkUrl = "dhcma.hai.ir.view.oedrtlist.csp?EpisodeID="+EpisodeID+"&PaadmID="+PaadmID+"&1=1";
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#Tab4").attr("src", LinkUrl);					
				}
				if (index==5){			//手术
					$("#divtab5").css('display','block');
					LinkUrl = "dhcma.hai.ir.view.oeoperat.csp?EpisodeID="+EpisodeID+"&PaadmID="+PaadmID+"&1=1";
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#Tab5").attr("src", LinkUrl);					
				} 
				if (index==6){			//体温单
					$("#divtab6").css('display','block');
					LinkUrl = TemperatureCSP+"?EpisodeID="+EpisodeID+"&PaadmID="+PaadmID+"&1=1";
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#Tab6").attr("src", LinkUrl);					
				} 
				if (index==7){			//病程
					$("#divtab7").css('display','block');
					LinkUrl = "dhcma.hai.ir.view.emrinfoh.csp?EpisodeID="+EpisodeID+"&PaadmID="+PaadmID+"&1=1";
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#Tab7").attr("src", LinkUrl);					
				} 
				if (index==8){			//影像报告
					$("#divtab8").css('display','block');
					LinkUrl = "dhchai.ir.view.risreport.csp?EpisodeID="+EpisodeID+"&PaadmID="+PaadmID+"&1=1";
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#Tab8").attr("src", LinkUrl);					
				} 	
				if (index==9){			//就诊信息
					$("#divtab9").css('display','block');
					LinkUrl = "dhcma.hai.ir.view.admhistory.csp?EpisodeID="+EpisodeID+"&PaadmID="+PaadmID+"&1=1";
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#Tab9").attr("src", LinkUrl);					
				} 
				if (index==10){			//病历浏览
					$("#divtab10").css('display','block');
					LinkUrl = cspUrl+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&DefaultOrderPriorType=ALL&1=1";
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#Tab10").attr("src", LinkUrl);					
				} 		
			}
		});
		//设置了跳转页签
		setTimeout("obj.changeState()", 300);
		
	}
	obj.changeState=function(args){		
		if(index!="0")
		{
			$('#divTabs').tabs('select',parseInt(index));
		}		
	}
}

///iframe自适应屏幕高度
function iFrameHeight(id){
	var ifm = document.getElementById(id);
	if (ifm != null) {
		try {
			var bHeight = ifm.contentWindow.document.body.scrollHeight;
			var dHeight = ifm.contentWindow.document.documentElement.scrollHeight;
			var innerHeight = Math.min(bHeight, dHeight);
			if (PageType == 'WinOpen') {
				var outerHeight = $(window).height()-100 ;
			}else {
				var outerHeight = $(window).height()-80 ;
			}
			ifm.height = outerHeight;
		} catch (e) {
			console.error(e);
			ifm.height = 560;
		}
	}
}