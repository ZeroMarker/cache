Import SQLUser

Class web.UDHCOEORDOP Extends BILL.COM.Abstract
{

/// 主要用在退费中的此票据号码中,是否有未结算的医嘱串;
/// 获取一个票据号码下,不进行结算的同一个ADM号码下的医嘱rowid串
/// 过滤ADM下的是否有不在此票据的OrdID
/// 获取不再ADM下的是否有不在此票据的OrdID所有的
/// 考虑多张票情况下的不同退费
/// Debug: w ##class(web.UDHCOEORDOP).ReadUnINVOrdStr("7206")
ClassMethod ReadUnINVOrdStr(prtRowId As %String) As %String
{
	set unordStr=""
	quit:(+prtRowId=0) unordStr
	
	set billConInv=0
	while($o(^DHCBCI(0,"INV",prtRowId,billConInv))) {
		set billConInv=$o(^DHCBCI(0,"INV",prtRowId,billConInv))
		set conData=$g(^DHCBCI(billConInv))
		set pb=$p(conData,"^",2)
		set adm=$p(conData,"^",3)
		set ord=$o(^OEORD(0,"Adm",adm,0))
		set itm=0
		while($o(^OEORD(ord,"I",itm))) {
			set itm=$o(^OEORD(ord,"I",itm))
			continue:('$d(^OEORD(+ord,"I",itm,1)))
			set oeitm=ord_"||"_itm
			continue:($d(^DHCPBi(0,"OEORI",oeitm,pb)))
			set unordStr=$s((unordStr=""):oeitm,1:(unordStr_"^"_oeitm))
		}
	}
	
	set unordStr="^"_unordStr_"^"
	
	quit unordStr
}

/// Description: 1.更新当前医嘱的开始日期
///              2.更新当前的账单变为To Bill，让后面重新生成账单
/// Input: episodeId:PA_Adm.RowId
/// Return: 0:成功，<>0:失败
/// Debug: w ##class(web.UDHCOEORDOP).SetCurORDPrice("187123")
ClassMethod SetCurORDPrice(episodeId As %String) As %String
{
	set rtn=0
	quit:(episodeId="") 0
	
	/*
	set admDate=$p($g(^PAADM(episodeId)),"^",6)
	quit:(+admDate=0) rtn
	//quit:(+admDate=+$h) rtn	 //当天的医嘱不在更新
	*/
	
	set admType=$p($g(^PAADM(episodeId)),"^",2)
	quit:(admType="I") rtn
	
	set ord=$o(^OEORD(0,"Adm",episodeId,0))
	quit:(ord="") rtn
	
	ts
	
	set itm=0
	while($o(^OEORD(ord,"I",itm))) {
		set itm=$o(^OEORD(ord,"I",itm))
		set oeitm=ord_"||"_itm
		set billStatus=$p($g(^OEORD(+ord,"I",itm,3)),"^",5)
		continue:(" TB B "'[(" "_billStatus_" "))
		set statDR=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
		set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
		continue:(statCode="D")		//停止的医嘱不更新
		set isChged=##class(BILL.OP.COM.Method).ChkOEORIIsChged(oeitm)
		continue:(isChged=1)    //+2022-07-20 ZhYW 医嘱有对应的结算记录(包含预结算)时退出
		set rtn=$$UpdateOrdItem(oeitm)
		quit:(+rtn)
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn
	
UpdateOrdItem(oeitm)
	&SQL(
		UPDATE OE_OrdItem
		SET OEORI_Billed = 'TB', OEORI_ARPBLItem_DR = NULL,
			OEORI_BillPriceDate = CONVERT(DATE, NOW()), OEORI_BillPriceTime = CONVERT(TIME, NOW())
		WHERE %ID = :oeitm
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
 	
 	set itmDR=0
 	while($o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR))) {
	 	set itmDR=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR))
	 	set artiDR=0
	 	while($o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR,artiDR))) {
		 	set artiDR=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR,artiDR))
			set artiData=$g(^DHCAPREPTA(artiDR))
			set billStatus=$p(artiData,"^",9)   //账单状态
			continue:(" TB B "'[(" "_billStatus_" "))
			&SQL(
				UPDATE DHC_AppRepTarItm
				SET ARTI_Billed = 'TB', ARTI_PBO_Dr = NULL
				WHERE %ID = :artiDR
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		quit:(+rtn)
	}
 	
	quit rtn
}

/// Description: 在退费过程中，停止医嘱
/// Input: stopOrderStr: 停止医嘱字符串
///        prtRowId:DHC_INVPRT.RowId, userId:SS_User.RowwId
/// Return: 
/// Debug: w ##class(web.UDHCOEORDOP).UpdateOrderStat("179||13","227782","1")
ClassMethod UpdateOrderStat(stopOrderStr As %String, prtRowId As %String, userId As %String) As %String
{
	set $zt="ERROR"
	set rtn=0
	quit:(stopOrderStr="") rtn    //无退费医嘱时，不需要停止医嘱
		
	//停医嘱
	set rtn=..StopOrdList(stopOrderStr, prtRowId, userId)
	quit:(+rtn) rtn
	
	set hasDrugItm=0   //退费医嘱中是否包含药品医嘱(0:否，<>0:是)
	for idx=1:1:$l(stopOrderStr,"^") {
		set stopOrdItm=$p(stopOrderStr,"^",idx)
		continue:(stopOrdItm="")
		continue:(##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI(stopOrdItm)=1)  //过滤急诊转入住院的医嘱
		set orderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(stopOrdItm)
		continue:(orderType'="R")
		set hasDrugItm=1
		quit
	}
	//2019-10-12 ZhYW 若没有药品医嘱退费，删除退药申请单信息
	if (hasDrugItm=0) {
		set phaParams="^"_prtRowId
		set rtnValue=##class(PHA.FACE.OUT.Com).DelOutPhReq(phaParams)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) {
			set rtn=rtn_"^"_"药房组接口[PHA.FACE.OUT.Com||DelOutPhReq("_$lts($lb(phaParams))_")]失败:"_rtnValue
			quit rtn
		}
	}
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Stop Multiple Order
ClassMethod StopOrdList(stopOrdList As %String, prtRowId As %String, userId As %String) As %String
{
	set rtn=0
	
	for idx=1:1:$l(stopOrdList,"^") {
		set stopOrdItm=$p(stopOrdList,"^",idx)
		continue:(stopOrdItm="")
		continue:(##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI(stopOrdItm)=1)  //2019-07-25 ZhYW 转入住院的医嘱退费不停医嘱
		set isStopOrd=1    //是否停医嘱标识(1:是, 0:否)
		set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(stopOrdItm)
		if (isAppRep="Y") {
			set isPartRef=##class(web.DHCOPBillRefund).IsAllRefundRepPart(stopOrdItm)
			if (isPartRef=1) set isStopOrd=0    //多部位检查申请单部分退时不停医嘱
		}else {
			set isOPIVAS=$p($g(^OEORD(+stopOrdItm,"I",$p(stopOrdItm,"||",2),"DHC")),"^",16)
			if (isOPIVAS="Y") {
				//静脉配液 2023-05-30 ZhYW 静脉配液医嘱需要停医嘱，否则部分退费重收时，重收的打包批次表数量计算有误
				set isStopOrd=1
			}else {
				set isPartRef=##class(BILL.OP.COM.Method).IsPartRefund(stopOrdItm, 1)   //1:部分退费，0:没有退药或全部退药
				if (isPartRef=1) set isStopOrd=0
			}
		}
		if (isStopOrd=1) {
			//全部退费
			set rtn=..StopOrd(stopOrdItm, userId)   //停医嘱
			quit:(+rtn)
		}else {
			//部分退费
			set rtn=..StopOrdPart(stopOrdItm, prtRowId, userId)
			quit:(+rtn)
		}
		if (isAppRep="Y") {
			//调用多部位检查申请单接口，修改中间表数据
			set rtnValue=##class(web.DHCAPPInterface).retInvExaReqNo(stopOrdItm, userId)
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) {
				set rtn=rtn_"^"_"医生站组接口[web.DHCAPPInterface||retInvExaReqNo("_$lts($lb(stopOrdItm, userId))_")]失败:"_rtnValue
				quit
			}
		}
		if (isStopOrd=0) {
			//+2021-07-20 Lid 要把医嘱表账单状态改为TB，不能改为I，改为I时，有时不能正确计费，因为账单程序中，I状态判断了账单数量，如果账单数量为0了，就不账单;
			//则医嘱的账单状态也不变，还是I，这样在收费界面就不能收费了
			&SQL(
				UPDATE OE_OrdItem
				SET OEORI_Billed = 'TB', OEORI_ARPBLItem_DR = NULL
				WHERE %ID = :stopOrdItm
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
			if (isAppRep="Y") {
				//+2023-03-31 ZhYW 门诊全退再收费界面重收模式时，计费状态不能是I，先改为R，如果有需要，再改ARTI_PBO_Dr为负发票对应的账单医嘱表Id
				&SQL(
					UPDATE DHC_AppRepTarItm
					SET ARTI_Billed = 'R'
					WHERE ARTI_OrdItem = :stopOrdItm
					AND ARTI_Billed = 'I'
				)
				set rtn=SQLCODE
				if (+rtn) {
					set rtn=rtn_"^"_$g(%msg)
					quit
				}
			}
		}
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-07-29
/// Description: 调用医生站停医嘱接口
/// Input: oeitm: OE_OrdItem.RowId, userId:SS_User.RowId
/// Return: 0:成功，<>0:失败
/// Debug: w ##class(web.UDHCOEORDOP).StopOrd()
ClassMethod StopOrd(oeitm As %String, userId As %String) As %String
{
	set rtn=0
	
	set isStopChild=0	  //停主医嘱是否停子医嘱标识(1:是, 0:否)
	
	set rtnValue=##class(web.DHCOEOrdItem).Stop(oeitm, userId, isStopChild)   //调用医生站组接口实现停医嘱
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtn_"^"_"医生站组接口[web.DHCOEOrdItem||Stop("_$lts($lb(oeitm, userId, isStopChild))_")]失败:"_rtnValue
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-07-29
/// Description: 对处理医嘱的部分退费
/// Input: oeitm: OE_OrdItem.RowId, prtRowId：DHC_INVPRT.RowId, userId:SS_User.RowId
/// Return: 0:成功，<>0:失败
/// Debug: w ##class(web.UDHCOEORDOP).StopOrdPart()
ClassMethod StopOrdPart(oeitm As %String, prtRowId As %String, userId As %String) As %String
{
	set rtn=0
	
	//+2022-07-15 ZhYW 治疗工作站医嘱，如果是部分退费不停医嘱，
	//则单独调用治疗工作站接口对治疗医嘱部分退费时的执行记录进行处理，防止退费的数量仍可按原数量进行执行
	set isCureOrd=##class(BILL.Interface.Inside.Invoke).IsCureOrd(oeitm)
	if (isCureOrd=1) {
		set rtnValue=##class(DHCDoc.DHCDocCure.Service).CancelCureApplyByStopOrd(oeitm, userId, .errMsg)
		set rtn=$p(rtnValue,"^",1)
		quit:(+rtn) rtn_"^"_"医生站组接口[DHCDoc.DHCDocCure.Service||CancelCureApplyByStopOrd("_$lts($lb(oeitm, userId))_")]失败:"_$g(errMsg)
	}
	
	set expStr=prtRowId
	set appRefInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(oeitm, expStr)
	set applyQty=+$p(appRefInfo,"^",2)    //申请数量
	
	//+2022-07-28 ZhYW 调用物资组接口退材料库存
	set materialBarCode=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"DHC")),"^",14)   //OEORI_MaterialNo
	set paramStr=applyQty_"^"_prtRowId
	set rtnValue=##class(web.DHCSTMHUI.PCHCOLLSM).Return(oeitm, materialBarCode, paramStr)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtn_"^"_"物资组接口[web.DHCSTMHUI.PCHCOLLSM||Return("_$lts($lb(oeitm, materialBarCode, paramStr))_")]失败:"_rtnValue
	
	quit rtn
}

}
