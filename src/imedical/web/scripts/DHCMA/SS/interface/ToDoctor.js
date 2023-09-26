//���ҽ����˰�ťʱ,���һ�����ô˷���
//���·����ҽ��,����ӱ���ԭ��
//���,aEpisodeID:����ID,aOrdItemList:ҽ����IDƴ�ɵĴ�(^)
function checkOrdItemToVar(aEpisodeID,aOrdItemList,callBackFun){
	//���������ͣ��������Ͳ����·����ҽ��
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
	
	if ((!aEpisodeID)||(aOrdItemList=="")) {
		callBackFun(false);
		return;
	}
	
	//��ʽ�������ҽ������ȥ������","
	var tmpArr=aOrdItemList.split(",");
	var tmpOrdItemStr="";
	for (var i=0;i<tmpArr.length;i++){
		var xOrdItem=tmpArr[i];
		if (xOrdItem!=''&xOrdItem!=null) tmpOrdItemStr=tmpOrdItemStr+","+xOrdItem;	
	}
	aOrdItemList=tmpOrdItemStr.substr(1,tmpOrdItemStr.length);
	
	//�ж��Ƿ���
	var IsAddVar=$m({ClassName:"DHCMA.CPW.CPS.InterfaceSrv",MethodName:"IsAddVar"},false);
	if(parseInt(IsAddVar)>0){
		var runQuery =$cm({
			ClassName:'DHCMA.CPW.CPS.InterfaceSrv',
			QueryName:'QryCPWVarOrder',
			aEpisodeID: aEpisodeID,
			aOEItmMastList: aOrdItemList,
			alocID: session['LOGON.CTLOCID'],
			aWardID: session['LOGON.WARDID']
		},false);
		if(runQuery){
			var dataLen = runQuery.rows.length;
			if(dataLen>0){	//��·����ҽ����������ӱ���ԭ��
				var strUrl = "./dhcma.cpw.io.var.csp?1=1" + "&EpisodeID=" + aEpisodeID + "&OEItmMastList=" + aOrdItemList;
				websys_showModal({
					url:strUrl,
					title:'����ҽ��',
					//closable:false,
					width:1000,height:500,
					onBeforeClose:function(OrdItemList){
						if(OrdItemList!=0){
							var ret=$m({ClassName:"DHCMA.CPW.CPS.InterfaceSrv",MethodName:"DeleteTmpVarOrd",aFlg:"Y"},false)
							if (websys_showModal("options").CallBackFunc) {
								websys_showModal("options").CallBackFunc(false);
							}else{
								window.returnValue = false;	//���ظ�ҽ��վ
							}
						}else{
							//�����ʱ����
							var ret=$m({ClassName:"DHCMA.CPW.CPS.InterfaceSrv",MethodName:"DeleteTmpVarOrd",aFlg:"N"},false)
							if (websys_showModal("options").CallBackFunc) {
								websys_showModal("options").CallBackFunc(true);
							}else{
								window.returnValue = true;	//���ظ�ҽ��վ
							}
						}
					},
					CallBackFunc:function(result){
						//websys_showModal("close");
						callBackFun(result)
					}
				})
			}else{
				callBackFun(true);
			}
		}
	}else{
		callBackFun(true);
	}
}

//�����ťʱ���ô˷���
//����,������ٴ�·��ҽ����ҽ��¼��ҳ��
//���,aEpisodeID:����ID��aOrderType:��ҩW/�в�ҩC��addOEORIByCPW:ҽ��վ���ҽ�������������������ֵ���ҳ��
function addOrdItemToDoc(aEpisodeID,aOrderType,addOEORIByCPW,aPAAdmType){
	if ((!aEpisodeID)||(!aOrderType)) return;
	if (typeof(addOEORIByCPW)!="function") return;
	var strUrl="",msgTitle="";
	if (aPAAdmType=='O'){
		strUrl = "./dhcma.cpw.io.oporder.csp?1=1" + "&EpisodeID=" + aEpisodeID+ "&OrderType=" + aOrderType;
		msgTitle = '��������ٴ�·��ҽ��';
	} else {
		strUrl = "./dhcma.cpw.io.order.csp?1=1" + "&EpisodeID=" + aEpisodeID + "&OrderType=" + aOrderType;
		msgTitle = '���סԺ�ٴ�·��ҽ��';
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