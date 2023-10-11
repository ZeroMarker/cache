//临床路径4.0住院路径
function ShowIPCPW(EpisodeID) 
{
	if (EpisodeID=='') return;
	
	var CPWStr=dhccl.runServerMethodNormal("DHCMA.CPW.CPS.InterfaceSrv","GetCPWList",EpisodeID);
	if (CPWStr=="") return;	
	else{
		var strUrl = "./dhcma.cpw.io.show.csp?1=1" + "&EpisodeID=" + EpisodeID + "&CPWStr=" + encodeURI(encodeURI(CPWStr));
		var strIPCPWTitle=$g("临床路径入径提示")
		 websys_showModal({
			url:strUrl,
			title:strIPCPWTitle,
			iconCls:'icon-w-import',  
			closable:false,
			originWindow:window,
			width:900,
			height:500
		});	
	}
	
	/********HISUI引用
	$m({
		ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
		MethodName:"GetCPWList",
		aEpisodeID:EpisodeID
	},function(CPWStr){
		if(CPWStr=="") return;
		var strUrl = "./dhcma.cpw.io.show.csp?1=1" + "&EpisodeID=" + EpisodeID + "&CPWStr=" + CPWStr;
		 websys_showModal({
			url:strUrl,
			title:'临床路径入径提示',
			iconCls:'icon-w-import',  
			closable:false,
			originWindow:window,
			width:900,
			height:500
		});
	})*/
	
}


// 取消手术时，调用方法检查是否需要退出当前入径
function CheckExitCPW(EpisodeID,OperIDs){
	if (EpisodeID=='') return;
	var retData=dhccl.runServerMethodNormal("DHCMA.CPW.IO.FromCIS","CheckIsExistInCPW",EpisodeID,OperIDs);
	if (retData=="") return;
	else{
		if (parseInt(retData.split("^")[0])==1){			
			//$.messager.confirm("提示", "当前患者已进入“"+retData.split("^")[1]+"”临床路径，请评估是否进行出径操作？选择“是”将跳转到临床路径页面，“否”则继续当前操作！", function (r) {
				//if (r) {
					//跳转临床路径页面，进行出径操作
					//参考大界面中下面方法
					//switchTabByEMR("dhc.side.oe.diagrecord") 切换到代码为dhc.side.oe.oemanage的页签
					//switchTabByEMR("dhc.side.oe.diagrecord",{oneTimeValueExp:"ReportId=123456"}) 切换到代码为dhc.side.oe.oemanage的页签
					//switchTabByEMR("CategoryID=30") 切换到表达式为CategoryID=30的页签
				//} 
			//});
			
			$.messager.alert($g("提示"), $g("当前患者已进入【")+retData.split("^")[1]+$g("】临床路径，如需退出路径，请切换到临床路径页面进行出径操作！"), 'info');
			return;
		}	
	}
	
	/*********HISUI引用	
	$m({
		ClassName:"DHCMA.CPW.IO.FromCIS",
		MethodName:"CheckIsExistInCPW",
		aEpisodeID:EpisodeID
	},function(data){
		if (parseInt(data.split("^")[0])==1){
			
			//$.messager.confirm("提示", "当前患者已进入“"+data.split("^")[1]+"”临床路径，请评估是否进行出径操作？选择“是”将跳转到临床路径页面，“否”则继续当前操作！", function (r) {
				//if (r) {
					//跳转临床路径页面，进行出径操作
					//参考大界面中下面方法
					//switchTabByEMR("dhc.side.oe.diagrecord") 切换到代码为dhc.side.oe.oemanage的页签
					//switchTabByEMR("dhc.side.oe.diagrecord",{oneTimeValueExp:"ReportId=123456"}) 切换到代码为dhc.side.oe.oemanage的页签
					//switchTabByEMR("CategoryID=30") 切换到表达式为CategoryID=30的页签
				//} 
			//});
			
			$.messager.popover({msg: "当前患者已进入“"+data.split("^")[1]+"”临床路径，请评估是否需要退出路径！如需退出，请切换到临床路径页面进行操作！",type:'info',timeout: 3000,showType: 'show'});
		}
	})
	*/
	
			
}
