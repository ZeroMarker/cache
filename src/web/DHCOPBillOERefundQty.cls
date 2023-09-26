Import SQLUser

/// Creator: Lid
/// CreatDate: 2012-08-22
/// Description: 门诊部分退费业务逻辑
/// 		1.非药品医嘱可以部分退费
/// 		2.已申请部分退费但没有去收费处做实际退费或已部分退费的医嘱能"停止医嘱"
/// 		3.已停止的医嘱不能申请部分退费
/// 		4.部分退费后,更新实际退费标志(OERQ_Status(1:已实际退费,0:已申请但没有实际退))时，需判断，如果没有全部退完，则需要把医嘱状态改为“核实”，如果已全部退完，则不更新。
/// 		5.针对北京急诊留观的处理：
/// 		5.1.因为留观医嘱申请部分退费后，不去收费处做实际退费操作,所以在申请部分退费后，直接把实际退费标志设为1.
/// 		5.2.
Class web.DHCOPBillOERefundQty Extends BILL.COM.Abstract
{

/// Modify: 2017-06-21 ZhYW
/// ExpStr: DHC_INVPRT.RowID^实际退费标志("Y"/"N")
/// Debug:w ##class(web.DHCOPBillOERefundQty).InertApplyRefundQty("8583||3^2",3879,"")
ClassMethod InertApplyRefundQty(ApplyRefundData As %String, RefUser As %String, ExpStr As %String) As %String
{
	quit:(ApplyRefundData="") -1_"^"_"参数错误"

	ts

	set rtn=0
	for i=1:1:$l(ApplyRefundData,"!") {
		set refundData=$p(ApplyRefundData,"!",i)
		set OEORIDR=$p(refundData,"^",1)
		set ApplyRefQty=$p(refundData,"^",2)
		set rtn=..Insert(OEORIDR, ApplyRefQty, RefUser, ExpStr)
		quit:(+rtn)
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2012-08-22
/// Description: 增加医嘱退费数量
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCOPBillOERefundQty).Insert("863||1","1","5","231370")
ClassMethod Insert(OEORI As %String, RefundQty As %String, RefUser As %String, ExpStr As %String) As %String
{
	set rtn=0
	
	set OrdCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(OEORI, 1)
	quit:(OrdCateType="R") 0	          ;药品不在此部分退费
	
	//+2017-06-21 ZhYW
	set prtRowID=$p(ExpStr,"^",1)
	set actRefFlag=$p(ExpStr,"^",2)

	set OERQRowID=$o(^DHCOERefundQTY(0,"OEORI",OEORI,""),-1)
	set OERQStatus=$s((+OERQRowID'=0):$p(^DHCOERefundQTY(OERQRowID),"^",4),1:1)
	
	set RefDate=+$h, RefTime=$p($h,",",2)
	if (OERQStatus=0) {
		//0:已申请退费，但没有去收费处实际退费，此时退费数量可以修改，一条医嘱最多只能有一条0状态的记录。
		//+2017-06-23 ZhYW
		set matDispGrant=##class(web.DHCOPBillRefundRequest).CheckIsMatDispGrant(OEORI)
		set dispStat=##class(web.DHCOPBillRefundRequest).CheckMatDisp(OEORI)
		if ((matDispGrant="Y")&&(dispStat'=0)) {
			set applyRefQtyInfo=..GetRefundQTY(OEORI, prtRowID)   //原退费数量
			set myRefundQty=+$p(applyRefQtyInfo,"^",2)
			set RefundQty=$i(RefundQty, myRefundQty)
		}
		&SQL(
			UPDATE DHC_OERefundQty
			SET OERQ_RefundQty = :RefundQty, OERQ_RefUser_DR = :RefUser, OERQ_RefDate = :RefDate,
				OERQ_RefTime = :RefTime, OERQ_PRTInv_DR = :prtRowID, OERQ_ActRefFlag = :actRefFlag
			WHERE %ID = :OERQRowID
		)
		set rtn=SQLCODE
		quit:(+rtn) rtn_"^"_$g(%msg)
	}else {
		//没有退费记录或已实际退费时，如果要再退费，需要新添加一条退费记录
		set TotalQty=+$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",12)
		
		set RefuQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(OEORI,"")
		set TotalRefQty=+$p(RefuQtyInfo,"^",1)
		
		set IsAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(OEORI)
		
		quit:(((IsAppRepFlag'="Y")&&(TotalRefQty+RefundQty)>TotalQty)) 0   //退费数量不能大于总数量(新版检查申请单以部位退费，不验证)

		set StayFlag=##class(web.UDHCJFBILL).CheckStayFlag("", OEORI)	//Y:留观/特病，非Y:非留观/非特病
		set RQStatus=(StayFlag="Y")
		set Billed=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3)),"^",5)
		if (Billed="P") {
			set RQStatus=0		//OERQ_Status,如果已经结算打印发票，则把状态改为“申请退费”
		}
		&SQL(
			INSERT INTO DHC_OERefundQty (
				OERQ_RefundQty, OERQ_OEORI_DR, OERQ_TotalQty, OERQ_Status, OERQ_RefUser_DR,
				OERQ_RefDate, OERQ_RefTime, OERQ_PRTInv_DR, OERQ_ActRefFlag
			)
			VALUES (
				:RefundQty, :OEORI, :TotalQty, :RQStatus, :RefUser,
				:RefDate, :RefTime, :prtRowID, :actRefFlag
			)
		)
		set rtn=SQLCODE
		quit:(+rtn) rtn_"^"_$g(%msg)
		/*
		if (StayFlag="Y") {
			set rtn=..UpdateStatus(OEORI, RefUser, 4)	//留观部分退费时停医嘱	
		}
		*/
	}

	quit rtn
}

/// Creator: Lid
/// CreatDate: 2012-08-22
/// Description: 实际退费后更新退费记录状态
/// Input: 
/// Return: 
/// Debug:w ##class(web.DHCOPBillOERefundQty).UpdateRefStauts("","5",218425,"")
ClassMethod UpdateRefStauts(OEORIStr As %String, RefUser As %String, NewPrtRowId As %String, ExpStr As %String) As %String
{
	quit:((+OEORIStr=0)&&(NewPrtRowId="")) 0
	
	set rtn=0
	for i=1:1:$l(OEORIStr,"^") {
		set OEORI=$p(OEORIStr,"^",i)
		continue:(+OEORI=0)
		set OERQRowID=$o(^DHCOERefundQTY(0,"OEORI",OEORI,""),-1)
		continue:(OERQRowID="")	//该医嘱没有部分退费
		set OERQStatus=$p(^DHCOERefundQTY(OERQRowID),"^",4)
		if (+OERQStatus=0) {
			&SQL(
				UPDATE DHC_OERefundQty
				SET OERQ_Status = 1
				WHERE %ID = :OERQRowID
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
			
			set RefQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(OEORI, "")
			//部分退费数量=实际退费数量+申请退费数量
			set ToalRefQty=$p(RefQtyInfo,"^",1)
			//医嘱总数量
			set TotalQty=+$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",12)
			set OEORIStatus=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",13)
			
			//&js<alert("#(OEORI_"^"_TotalQty_"^"_ToalRefQty_"^"_OEORIStatus)#");>
			
			//如果总退费数量小于医嘱总数量时, 把医嘱状态再变为原来状态
			//取医嘱原来的状态
			set StopStatus=$o(^OEC("OSTAT",0,"Code","D",""))
			set OldSTStatusDR=""
			set TMPSTChildSub=""
			while($o(^OEORD(+OEORI,"I",$p(OEORI,"||",2),"ST",TMPSTChildSub),-1)) {
				set TMPSTChildSub=$o(^OEORD(+OEORI,"I",$p(OEORI,"||",2),"ST",TMPSTChildSub),-1)
				set ChildSubData=$g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),"ST",TMPSTChildSub))
				set TMPSTStatusDR=$p(ChildSubData,"^",3)
				continue:(StopStatus=TMPSTStatusDR)
				set OldSTStatusDR=TMPSTStatusDR
				quit
			}
			
			if (OldSTStatusDR="") {
				set OldSTStatusDR=$o(^OEC("OSTAT",0,"Code","V",""))
			}
			if (+ToalRefQty)<(+TotalQty) {
				set rtn=..UpdateStatus(OEORI, RefUser, OldSTStatusDR)
			}
		}
	}
	quit:(+rtn) rtn
	
	/*
	//ZhYW 2017-09-19 部分退药,将医嘱状态更新为核实后, 取退费数量有问题, 先注释, 部分退费后医嘱状态更新问题再议
	//add by wangjian 2017-08-09 判断新发票中如果有药品医嘱为停止状态更新成核实
	if (NewPrtRowId'="") {
		set Condr=""
		for  set Condr=$o(^DHCBCI(0,"INV",NewPrtRowId,Condr))  quit:((Condr="")||(+rtn))  do
		.set Bill=$p($g(^DHCBCI(Condr)),"^",2)
		.set PBO=0
		.for  set PBO=$o(^DHCPB(Bill,"O",PBO))  quit:((PBO="")||(+rtn))  do
		..set PBOData=$g(^DHCPB(Bill,"O",PBO))
		..quit:(PBOData="")
		..set OEORI=$p(PBOData,"^",4)
		..set OrderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(OEORI, 0)
		..quit:(OrderType'="R")
		..set PBOBillQty=+$p(PBOData,"^",5)
		..set PBORefundQty=+$p(PBOData,"^",6)
		..set PBOQty=PBOBillQty+PBORefundQty
		..quit:(+PBOQty=0)
		..;set PBOPatShare=+$p(PBOData,"^",11)
		..;quit:(+PBOPatShare=0)
		..set OrdStat=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",13)
		..set:(OrdStat'="") OrdStat=$p($g(^OEC("OSTAT",OrdStat)),"^",1)
		..if (OrdStat="D") do
		...set StatusRowId=$O(^OEC("OSTAT",0,"Code","V",0))
		...set rtn=..UpdateStatus(OEORI, RefUser, StatusRowId)
	}
	*/
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2012-08-22
/// Description: 根据医嘱Rowid获取医嘱退费数量
/// Input:
/// Return:总退费数量^申请退费数量^实际退费数量
/// Debug: w ##class(web.DHCOPBillOERefundQty).GetRefundQTY("2929||5", "236760")
ClassMethod GetRefundQTY(OEORI As %String, ExpStr As %String = "") As %String
{
	quit:(OEORI="") "0^0^0"
	set RefundQty1=0	//总退费数量
	set RefundQty2=0	//已申请退费数量
	set RefundQty3=0	//已实际退费数量
	//+2017-06-21 ZhYW
	set prtRowID=$p(ExpStr,"^",1)
	set matDispGrant=##class(web.DHCOPBillRefundRequest).CheckIsMatDispGrant(OEORI)
	set dispStat=##class(web.DHCOPBillRefundRequest).CheckMatDisp(OEORI)
	//
	set OERQRowID=0
	for  set OERQRowID=$o(^DHCOERefundQTY(0,"OEORI",OEORI,OERQRowID)) quit:(OERQRowID="")  do
	.set refQtyData=$g(^DHCOERefundQTY(OERQRowID))
	.set myOERQStatus=$p(refQtyData,"^",4)
	.set myOERQRefundQty=$p(refQtyData,"^",3)
	.//+2017-06-21 ZhYW 没有实际退时, 退费数量为0
	.set myPrtRowID=$p(refQtyData,"^",9)    //OERQ_PRTInv_DR
	.quit:((prtRowID'="")&&(myPrtRowID'="")&&(prtRowID'=myPrtRowID))
	.set actRefFlag=$p(refQtyData,"^",10)
	.set:((matDispGrant="Y")&&(actRefFlag'="Y")&&(dispStat'=0)) myOERQRefundQty=0    //已发放未退的物资材料,退费数量为0
	.//
	.set RefundQty1=RefundQty1+myOERQRefundQty
	.if (myOERQStatus=0) set RefundQty2=RefundQty2+myOERQRefundQty
	.if (myOERQStatus=1) set RefundQty3=RefundQty3+myOERQRefundQty
	
	quit RefundQty1_"^"_RefundQty2_"^"_RefundQty3
}

/// 0:部分退费，1：全部退费没有退费
/// Debug: w ##class(web.DHCOPBillOERefundQty).IsPartRefund("1217||6")
ClassMethod IsPartRefund(oeitm As %String)
{
	set phQtyOrd=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",12)		//OEORI_PhQtyOrd
	set refundQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(oeitm, "")
	set factRefundQty=+$p(refundQtyInfo,"^",3)		//已退费数量
	if (factRefundQty>0)&&(+phQtyOrd'=+factRefundQty) {
		set rtn=0
	}else {
		set rtn=1
	}
	
	quit rtn
}

/// 医嘱RowId, 用户RowId
/// 更新医嘱状态
ClassMethod UpdateStatus(OrdItmRowId As %String = "", UserRowId As %String = "", StatusRowId As %String = "") As %String
{
	set CurrentDate=$p($h,",",1)
	set CurrentTime=$p($h,",",2)
	
	set rtn=0
	
	ts
	
	&SQL(
		UPDATE OE_OrdItem
		SET OEORI_ItemStat_DR = :StatusRowId
		WHERE %ID = :OrdItmRowId
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	&SQL(
		INSERT INTO OE_OrdStatus (
			ST_ParRef, ST_Date, ST_Time, ST_Status_DR, ST_User_DR
		)
		VALUES (
			:OrdItmRowId, :CurrentDate, :CurrentTime, :StatusRowId, :UserRowId
		)
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2017-06-21
/// Description: 根据医嘱Rowid获取医嘱退费数量
/// Input: 
/// Return: 总退费数量^申请退费数量^实际退费数量
/// Debug: w ##class(web.DHCOPBillOERefundQty).GetApplyRefundQty("77440||3","")
ClassMethod GetApplyRefundQty(OEORI As %String, ExpStr As %String = "") As %String
{
	quit:(OEORI="") "0^0^0"
	
	set prtRowID=$p(ExpStr,"^",1)
	
	set RefundQty1=0	;总退费数量
	set RefundQty2=0	;已申请退费数量
	set RefundQty3=0	;已实际退费数量
	set OERQRowID=0
	for  set OERQRowID=$o(^DHCOERefundQTY(0,"OEORI",OEORI,OERQRowID)) quit:(OERQRowID="")  do
	.set refQtyData=$g(^DHCOERefundQTY(OERQRowID))
	.set myOERQStatus=$p(refQtyData,"^",4)           //OERQ_Status
	.set myOERQRefundQty=$p(refQtyData,"^",3)        //OERQ_RefundQty
	.set myPrtRowID=$p(refQtyData,"^",9)             //OERQ_PRTInv_DR
	.quit:((prtRowID'="")&&(prtRowID'=myPrtRowID))
	.set actRefFlag=$p(refQtyData,"^",10)
	.quit:(actRefFlag="Y")
	.set RefundQty1=RefundQty1+myOERQRefundQty
	.if (myOERQStatus=0) set RefundQty2=RefundQty2+myOERQRefundQty
	.if (myOERQStatus=1) set RefundQty3=RefundQty3+myOERQRefundQty
	
	quit RefundQty1_"^"_RefundQty2_"^"_RefundQty3
}

/// Creator: Lid
/// CreatDate: 2021-07-21
/// Description: 实际退费后更新退费申请表的退费记录状态(DHC_OERefundQty的OERQ_Status字段由申请退费改为实际退费）
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCOPBillOERefundQty).UpdatePartRefundStauts("","5",218425,"")
ClassMethod UpdatePartRefundStauts(OEORIStr As %String, RefUser As %String, ExpStr As %String) As %String
{
	set rtn=0
	quit:(+OEORIStr=0) 0

	for i=1:1:$l(OEORIStr,"^") {
		set OEORI=$p(OEORIStr,"^",i)
		continue:(+OEORI=0)
		set OERQRowID=$o(^DHCOERefundQTY(0,"OEORI",OEORI,""),-1)
		continue:(OERQRowID="")
		set OERQStatus=$p(^DHCOERefundQTY(OERQRowID),"^",4)
		if (+OERQStatus=0) {
			&SQL(
				UPDATE DHC_OERefundQty
				SET OERQ_Status = 1
				WHERE %ID = :OERQRowID
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
	}
	quit rtn
}

}
