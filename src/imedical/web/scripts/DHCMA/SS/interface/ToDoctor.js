//点击医嘱审核按钮时,最后一步调用此方法
//检查路径外医嘱,并添加变异原因
//入参,aEpisodeID:就诊ID,aOrdItemList:医嘱项ID拼成的串(^)
function checkOrdItemToVar(aEpisodeID,aOrdItemList,callBackFun){

	//检查就诊类型，门诊类型不检查路径外医嘱
	var PAAdmType =$cm({
		ClassName:"DHCMA.Util.IO.FromHisSrv",
		MethodName:"GetPAAdmType",
		aEpisodeID:aEpisodeID,
		dataType:"text"
	},false);
	if(PAAdmType=="O"){
		callBackFun(true);
		return;	
	}
	
	//格式化传入的医嘱串，去掉多余","
	var tmpArr=aOrdItemList.split(",");
	var tmpOrdItemStr="";
	for (var i=0;i<tmpArr.length;i++){
		var xOrdItem=tmpArr[i];
		if (xOrdItem!=''&xOrdItem!=null) tmpOrdItemStr=tmpOrdItemStr+","+xOrdItem;	
	}
	aOrdItemList=tmpOrdItemStr.substr(1,tmpOrdItemStr.length);
	
	if ((!aEpisodeID)||(aOrdItemList=="")) {
		callBackFun(true);
		return;
	}
	
	new Promise(function(resolve,reject){
		//判断是否检查
		var IsAddVar=$m({ClassName:"DHCMA.CPW.CPS.InterfaceSrv",MethodName:"IsAddVar",aLgnHospID:session['LOGON.HOSPID']},false);
		if(parseInt(IsAddVar)>0){
			var runQuery =$cm({ClassName:'DHCMA.CPW.CPS.InterfaceSrv',QueryName:'QryCPWVarOrder',aEpisodeID: aEpisodeID,aOEItmMastList: aOrdItemList,alocID: session['LOGON.CTLOCID'],aWardID: session['LOGON.WARDID']},false);			
			if(runQuery){
				var sendArg=-1;
				var dataLen = runQuery.rows.length;
				if(dataLen>0){	//有路径外医嘱，弹窗添加变异原因
					var strUrl = "./dhcma.cpw.io.var.csp?1=1" + "&EpisodeID=" + aEpisodeID + "&OEItmMastList=" + aOrdItemList;
					var varOrdTitle = $g('添加路径外医嘱变异')
					websys_showModal({
						url:strUrl,
						title:varOrdTitle,
						//closable:false,
						width:1000,height:500,
						onOptionFun:function(OrdItemList){						
							sendArg=parseInt(OrdItemList);						
							if(OrdItemList!=0){
								var ret=$m({ClassName:"DHCMA.CPW.CPS.InterfaceSrv",MethodName:"DeleteTmpVarOrd",aFlg:"Y"},false)
							}else{
								//清除临时数据
								var ret=$m({ClassName:"DHCMA.CPW.CPS.InterfaceSrv",MethodName:"DeleteTmpVarOrd",aFlg:"N"},false)
								resolve(true);
							}
						},
						onClose:function(){
							if (sendArg!=0){
								resolve(false);	
							}
						}
					})
				}else{
					resolve(true);	
				}				
			}else{
				resolve(true);	
			}			
		}else{
			resolve(true);	
		}		
	}).then(function(ret){
		 callBackFun(ret);
	})
}

//点击按钮时调用此方法
//弹窗,并添加临床路径医嘱到医嘱录入页面
//入参,aEpisodeID:就诊ID，aOrderType:西药W/中草药C，addOEORIByCPW:医生站添加医嘱方法，就诊类型区分调用页面
function addOrdItemToDoc(aEpisodeID,aOrderType,addOEORIByCPW,aPAAdmType){
	if ((!aEpisodeID)||(!aOrderType)) return;
	if (typeof(addOEORIByCPW)!="function") return;
	var strUrl="",msgTitle="";
	if (aPAAdmType=='O'){
		strUrl = "./dhcma.cpw.io.oporder.csp?1=1" + "&EpisodeID=" + aEpisodeID+ "&OrderType=" + aOrderType;
		msgTitle = $g('添加门诊临床路径医嘱');
	} else {
		strUrl = "./dhcma.cpw.io.order.csp?1=1" + "&EpisodeID=" + aEpisodeID + "&OrderType=" + aOrderType;
		msgTitle = $g('添加住院临床路径医嘱');
	}
	websys_showModal({
		url:strUrl,
		title:msgTitle,
		iconCls:'icon-w-import',  
		closable:true,
		originWindow:window,
		width:screen.availWidth-200,
		height:screen.availHeight-200,
		addOEORIByCPW:addOEORIByCPW
	});	
}