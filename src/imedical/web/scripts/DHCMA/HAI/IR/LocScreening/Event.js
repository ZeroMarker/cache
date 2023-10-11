//页面Event
function InitLocScreeningWinEvent(obj){	
    
    obj.LoadEvent = function(args){
		$HUI.tabs("#divTabs",{
			onSelect:function(title,index){
				if (title.indexOf("疑似病例筛查")>=0){
					LinkUrl = "dhcma.hai.ir.ccscreening.csp?&LocFlag=1";
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#TabMain").attr("src", LinkUrl);
				}
				if (index==1){			//帮助文档
					$("#divtab1").css('display','block');
					LinkUrl = "../scripts/DHCMA/HAI/Document/HelpWord.pdf";
					/* 非csp不需要加
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					*/
					//LinkUrl = "../scripts/DHCMA/HAI/Document/HelpWord.html";
					$("#TabHelp").attr("src", LinkUrl);
					
				}	
				if (index==2){			//ICU日志
					$("#divtab2").css('display','block');
					LinkUrl = "dhcma.hai.ir.icu.survery.csp?&LocFlag=1";
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#TabICUSurvery").attr("src", LinkUrl);
				}
				if (index==3){			//ICU插拔管评估
					$("#divtab3").css('display','block');
					LinkUrl = "dhcma.hai.ir.icu.grade.csp?&LocFlag=1";
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#TabICUGrade").attr("src", LinkUrl);
				}	
				if (index==4){			//ICU危险登记表	
					$("#divtab4").css('display','block');
					LinkUrl = "dhcma.hai.ir.icu.iexa.csp?&LocFlag=1";
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#TabICUIexa").attr("src", LinkUrl);
				}
				if (index==5){			//NICU日志
					$("#divtab5").css('display','block');
					LinkUrl = "dhcma.hai.ir.nicu.survery.csp?&LocFlag=1";
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#TabNICUSurvery").attr("src", LinkUrl);
				}
				if (index==6){			//感染报告查询
					$("#divtab6").css('display','block');
					LinkUrl = "dhcma.hai.ir.inf.repqry.csp?";
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#TabReportQry").attr("src", LinkUrl);
				}
				if (index==7){			//多重耐药菌查询
					$("#divtab7").css('display','block');
					LinkUrl = "dhcma.hai.ir.mrb.ctlresult.csp?";
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#TabCtlResult").attr("src", LinkUrl);
				}
				if (index==8){			//多重耐药菌报告查询
					$("#divtab8").css('display','block');
					LinkUrl = "dhcma.hai.ir.mrb.infmrbqry.csp?";
					if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#TabInfMRBQry").attr("src", LinkUrl);
				}
                if (title.indexOf("院感学习平台")>=0){
                    $("#divtab10").css('display','block');
                    var LinkUrl = $m({
                        ClassName: "DHCHAI.BT.Config",
                        MethodName: "GetValByCode",
                        aCode:"EducationURL",
                        aHospDr:"",
                    }, false);
					LinkUrl=LinkUrl+"/noDelUp"+"?LocID="+encodeURI(session["LOGON.CTLOCID"])+"&LocDesc="+encodeURI(session['LOGON.CTLOCDESC'])+"&UserID="+encodeURI(session["LOGON.CTLOCID"])+"&UserDesc="+encodeURI(session["LOGON.USERNAME"])
                    
                    if ("undefined" !==typeof websys_getMWToken) {
						LinkUrl  += "&MWToken="+websys_getMWToken();
					}
					$("#TabStudy").attr("src", LinkUrl);
					//项目上使用许根据实际公告环境部署
					//LinkUrl = "dhcma.hai.eval.csp?";
					//$("#TabStudy").attr("src", LinkUrl);
				}
			}
		});
	}
}