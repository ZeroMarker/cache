/// 名称: web.DHCIPBillPATCostInquriy.cls
/// 描述: 患者科室费用查询
/// 产品组：计费医保组
Class web.DHCIPBillPATCostInquriy Extends BILL.COM.Abstract
{

/// Description: 获取患者转科记录
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillPATCostInquriy","QryAdmTransLoc","","6204")
Query QryAdmTransLoc(adm As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String:ID,text:%String:科室")
{
}

ClassMethod QryAdmTransLocExecute(ByRef qHandle As %Binary, adm As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    if (adm="") quit $$$OK
    
    if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
  	kill deptAry
  	
  	set chl=0
  	while($o(^PAADM(adm,"TRANS",chl))) {
	  	set chl=$o(^PAADM(adm,"TRANS",chl))
		set deptDR=$p(^PAADM(adm,"TRANS",chl),"^",6)
	    continue:(deptDR="")
	    continue:($d(deptAry(deptDR)))   //去重
	    set deptAry(deptDR)=""
	    set deptDesc=$p(^CTLOC(deptDR),"^",2)
	    set deptDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", deptDesc, langId)
	    do OutputTransLoc
	}
	
	//+2023-03-09 ZhYW
	set oeitm=""
	while($o(^DHCOPIPADMCON(0,"IPADM",adm,"OEORI",oeitm))'="") {
		set oeitm=$o(^DHCOPIPADMCON(0,"IPADM",adm,"OEORI",oeitm))
		set is2IP=0   //是否转入住院标识
		set ociId=0
		while($o(^DHCOPIPADMCON(0,"IPADM",adm,"OEORI",oeitm,ociId))) {
			set ociId=$o(^DHCOPIPADMCON(0,"IPADM",adm,"OEORI",oeitm,ociId))
			set data=$g(^DHCOPIPADMCON(ociId))
			set status=$p(data,"^",7)
			continue:(status'="N")
			set is2IP=1
			quit
		}
		continue:(is2IP=0)
		set deptDR=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",3)      //OEORI_OrdDept_DR 开医嘱时患者所在科室
		continue:(deptDR="")
		continue:($d(deptAry(deptDR)))   //去重
		set deptDesc=$p(^CTLOC(deptDR),"^",2)
	    set deptDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", deptDesc, langId)
	    do OutputTransLoc
	}
	
	quit $$$OK
OutputTransLoc
 	set Data=$lb(deptDR,deptDesc)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: zhuangna
/// CreatDate: 2015-08-12
/// Description: 查询就诊下的医嘱大类金额信息
/// Input: ordDeptId:下医嘱就诊科室Id
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillPATCostInquriy","FindBillCateFee","","","","1.110","86")
Query FindBillCateFee(billId As %String, stDate As %String, endDate As %String, ordDeptId As %String, episodeId As %String, userDeptId As %String, recDeptId As %String, langId As %String = "") As websys.Query(ROWSPEC = "TCateDesc:%String:医嘱大类,TCateAmt:%Float:金额,TCateId:%String:医嘱大类ID")
{
}

ClassMethod FindBillCateFeeExecute(ByRef qHandle As %Binary, billId As %String, stDate As %String, endDate As %String, ordDeptId As %String, episodeId As %String, userDeptId As %String, recDeptId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindBillCateFee")=$lb(billId, stDate, endDate, ordDeptId, episodeId, userDeptId, recDeptId, langId)
	if ((billId="")&&(episodeId=""))  quit $$$OK
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
	kill ^||TMP($j)
	
	if (+billId=0) {
		set pb=0
		while($o(^DHCPB(0,"ADM",episodeId,pb))) {
			set pb=$o(^DHCPB(0,"ADM",episodeId,pb))
			do ..SetPBOrderDetail(pb, stDate, endDate, ordDeptId, userDeptId, recDeptId)
		}
	}else {
		do ..SetPBOrderDetail(billId, stDate, endDate, ordDeptId, userDeptId, recDeptId)
	}
	
  	set totalAmt=0
	set cateId=0
	while($o(^||TMP($j,"Cate",cateId))) {
		set cateId=$o(^||TMP($j,"Cate",cateId))
		set cateAmt=$lg(^||TMP($j,"Cate",cateId),1)
		set cateAmt=$fn(cateAmt,"",2)
		set cateDesc=$p(^OEC("ORCAT",cateId),"^",2)
		set cateDesc=##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc", cateDesc, langId)
		set totalAmt=$i(totalAmt, cateAmt)
		do OutputBillCateFee
	}
  
	set cateDesc=##class(websys.Translation).Get("", "合计", langId)
	set cateAmt=$fn(totalAmt,"",2)
	set cateId=""
	do OutputBillCateFee
	
	kill ^||TMP($j)
	
  	quit $$$OK
  
OutputBillCateFee
  	set Data=$lb(cateDesc,cateAmt,cateId)
  	set ^CacheTemp(repid,ind)=Data
  	set ind=$i(ind)
  	quit
}

ClassMethod SetPBOrderDetail(pb As %String, stDate As %String, endDate As %String, ordDeptId As %String, userDeptId As %String, recDeptId As %String, itemCateId As %String = "")
{
	set pbAdm=$p(^DHCPB(pb),"^",1)
	
	do ##class(web.UDHCJFBILL).BILLN(pbAdm, 1)
	
	set pbo=0
	while($o(^DHCPB(pb,"O",pbo))) {
		set pbo=$o(^DHCPB(pb,"O",pbo))
		set pboData=$g(^DHCPB(pb,"O",pbo))
		continue:(pboData="")
		set oeitm=$p(pboData,"^",4)
		set ord=+oeitm, itm=$p(oeitm,"||",2)
		set sttDate=$p($g(^OEORD(ord,"I",itm,1)),"^",9)         //OEORI_SttDat
		continue:((stDate'="")&&(sttDate<stDate))
	  	continue:((endDate'="")&&(sttDate>endDate))
		set arcim=$p(pboData,"^",3)
		continue:(+arcim=0)
		set itmSubCatDR=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
		set itmCatDR=$p(^ARC("IC",itmSubCatDR),"^",8)          //ARC_ItemCat.ARCIC_OrdCat_DR
		continue:((+itemCateId'=0)&&(itemCateId'=itmCatDR))
		set recDeptDR=$p(^OEORD(ord,"I",itm,3),"^",6)
		continue:((recDeptId'="")&&(recDeptId'=recDeptDR))
		set userDeptDR=$p($g(^OEORD(ord,"I",itm,7)),"^",2)     //OEORI_UserDepartment_DR 开单科室
		continue:((userDeptId'="")&&(userDeptId'=userDeptDR))
		set ordDeptDR=$p($g(^OEORD(ord,"I",itm,1)),"^",3)      //+2023-03-09 OEORI_OrdDept_DR 开医嘱时患者所在科室
		continue:((ordDeptId'="")&&(ordDeptId'=ordDeptDR))
		do ..GetOrder(pb, pbo, arcim, itmCatDR, pbAdm)
	}
	
	quit 0
}

ClassMethod GetOrder(pb As %String, pbo As %String, arcim As %String, itemCat As %String, adm As %String) As %String
{
	set pboData=$g(^DHCPB(pb,"O",pbo))
	set oeitm=$p(pboData,"^",4)
	set qtyPrice=##class(BILL.IP.BL.NurseFee).GetOrderQtyPrice(pb, pbo)		//+WangXQ 20230424 获取医嘱已计费数量和单价
	set ordQty=$lg(qtyPrice,1)
	set ordPrice=$lg(qtyPrice,2)
	set ordPrice=$fn(ordPrice,"",4)
	set ordTotalAmt=$p(pboData,"^",8)
	set ordTotalAmt=$fn(ordTotalAmt,"",2)

	set uomDesc=##class(web.DHCBillCommon).GetBaseUom(arcim, oeitm)
	set $li(^||TMP($j,"Cate",itemCat),1)=$lg($g(^||TMP($j,"Cate",itemCat)),1)+ordTotalAmt
	
	set $li(^||TMP($j,"Adm",adm,itemCat,arcim,ordPrice),1)=$lg($g(^||TMP($j,"Adm",adm,itemCat,arcim,ordPrice)),1)+ordQty
	set $li(^||TMP($j,"Adm",adm,itemCat,arcim,ordPrice),2)=$lg($g(^||TMP($j,"Adm",adm,itemCat,arcim,ordPrice)),2)+ordTotalAmt
	set $li(^||TMP($j,"Adm",adm,itemCat,arcim,ordPrice),3)=uomDesc
	
	if ((","_$lg($g(^||TMP($j,"Adm",adm,itemCat,arcim,ordPrice)),4)_",")'[(","_oeitm_",")) {
		if ($lg($g(^||TMP($j,"Adm",adm,itemCat,arcim,ordPrice)),4)="") {
			set $li(^||TMP($j,"Adm",adm,itemCat,arcim,ordPrice),4)=oeitm
		}else {
			set $li(^||TMP($j,"Adm",adm,itemCat,arcim,ordPrice),4)=$lg($g(^||TMP($j,"Adm",adm,itemCat,arcim,ordPrice)),4)_","_oeitm
		}
	}
	
  	quit 0
}

/// Creator: zhuangna
/// CreatDate: 2015-08-12
/// Description: 查询就诊下的医嘱明细
/// Input: billId(账单号)、stDate(开始日期)、endDate(结束日期)、ordDeptId(下医嘱就诊科室Id)、episodeId(就诊号)、itemCateId(医嘱大类)、 userDeptId(开单科室)、recDeptId(接收科室)
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillPATCostInquriy","FindOrderDetail","","","","1.110","86","1")
Query FindOrderDetail(billId As %String, stDate As %String, endDate As %String, ordDeptId As %String, episodeId As %String, itemCateId As %String, userDeptId As %String, recDeptId As %String, langId As %String = "") As websys.Query(ROWSPEC = "TCateDesc:%String:医嘱大类,TArcimDesc:%String:医嘱名称,TUom:%String:单位,TPrice:%Float:单价,TQty:%String:数量,TAmt:%Float:金额,TARCIM:%String:医嘱项ID,TOEORI:%String:医嘱ID")
{
}

ClassMethod FindOrderDetailExecute(ByRef qHandle As %Binary, billId As %String, stDate As %String, endDate As %String, ordDeptId As %String, episodeId As %String, itemCateId As %String, userDeptId As %String, recDeptId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
  	set ind=1
	if ((billId="")&&(episodeId=""))  quit $$$OK
  	set ^TMP("FindOrderDetail")=$lb(billId, stDate, endDate, ordDeptId, episodeId, itemCateId, langId)
  	
  	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
  	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
  	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
  	
	kill ^||TMP($j)
	
	if (+billId=0) {
		set pb=0
		while($o(^DHCPB(0,"ADM",episodeId,pb))) {
			set pb=$o(^DHCPB(0,"ADM",episodeId,pb))
			do ..SetPBOrderDetail(pb, stDate, endDate, ordDeptId, userDeptId, recDeptId, itemCateId)
		}
	}else {
		do ..SetPBOrderDetail(billId, stDate, endDate, ordDeptId, userDeptId, recDeptId, itemCateId)
	}
	
	set adm=0
	while($o(^||TMP($j,"Adm",adm))) {
		set adm=$o(^||TMP($j,"Adm",adm))
		set cateDR=0
		while($o(^||TMP($j,"Adm",adm,cateDR))) {          //分类Id
			set cateDR=$o(^||TMP($j,"Adm",adm,cateDR))
			set cateDesc=$p(^OEC("ORCAT",cateDR),"^",2)
			set cateDesc=##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc", cateDesc, langId)
			set arcim=""
			while($o(^||TMP($j,"Adm",adm,cateDR,arcim))'="") {       //项目ID
				set arcim=$o(^||TMP($j,"Adm",adm,cateDR,arcim))
				set arcimDesc=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)
				set arcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", arcimDesc, langId)
				set price=""
				while($o(^||TMP($j,"Adm",adm,cateDR,arcim,price))'="") {     //金额
					set price=$o(^||TMP($j,"Adm",adm,cateDR,arcim,price))
					set data=$g(^||TMP($j,"Adm",adm,cateDR,arcim,price))
					set qty=$lg(data,1)
					set qty=$fn(qty,"N")
					set sum=$lg(data,2)
					set sum=$fn(sum,"",2)
					set uomDesc=$lg(data,3)  //单位
					set uomDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", uomDesc, langId)
					set oeitm=$lg(data,4)
					do OutputOrderDetail
				}
			}
		}
	}
	
	kill ^||TMP($j)

  	quit $$$OK
  	
OutputOrderDetail
	set Data=$lb(cateDesc,arcimDesc,uomDesc,price,qty,sum,arcim,oeitm)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Description: 根据医嘱查询执行记录
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillPATCostInquriy","FindOrdExecInfo","2520||1","283666")
Query FindOrdExecInfo(ordItmStr As %Text, billId As %String, langId As %String = "") As websys.Query(ROWSPEC = "TPriorDesc:%String:医嘱优先级,TExecDate:%String:执行日期,TExecTime:%String:执行时间,TOrderStatus:%String:执行状态,TCareProvDesc:%String:处理人,TUserDeptDesc:%String:开单科室,TExStDate:%String:要求执行日期,TExStTime:%String:要求执行时间,TPatAmt:%Float:金额,TPBORowID:%String:账单医嘱ID,TBillFlag:%String:账单状态,TCollectQty:%String:发药数量,TRefundQty:%String:退药数量,TOrdExcRowID:%String:执行记录ID,TConfFlag:%String:审核标识,TUserAddDesc:%String:开医嘱人,TBillQty:%String:计费数量")
{
}

ClassMethod FindOrdExecInfoExecute(ByRef qHandle As %Binary, ordItmStr As %Text, billId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    set ^TMP("FindOrdExecInfo")=$lb(ordItmStr, billId)
	if ((ordItmStr="")&&(billId=""))  quit $$$OK
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	kill ^||TMP($j)
    set count=$l(ordItmStr,",")
    for i=1:1:count {
	    set oeitm=$p(ordItmStr,",",i)
	    continue:(oeitm="")
	    set ord=+oeitm, itm=$p(oeitm,"||",2)
		set exec=0
		while($o(^OEORD(ord,"I",itm,"X",exec))) {
			set exec=$o(^OEORD(ord,"I",itm,"X",exec))
			set execData=$g(^OEORD(ord,"I",itm,"X",exec))
			continue:(execData="")
			set oeore=ord_"||"_itm_"||"_exec
			set exStDate=$p(execData,"^",1)              //OEORE_ExStDate 要求执行时间
			set exStTime=$p(execData,"^",2)              //OEORE_ExStTime
			set ^||TMP($j,exStDate,exStTime,oeore)=""
		}
    }
    
	set BilledSum=0
	set exStDate=""
	while($o(^||TMP($j,exStDate))'="") {
		set exStDate=$o(^||TMP($j,exStDate))
		set exStTime=""
		while($o(^||TMP($j,exStDate,exStTime))'="") {
			set exStTime=$o(^||TMP($j,exStDate,exStTime))
			set oeore=""
			while($o(^||TMP($j,exStDate,exStTime,oeore))) {
				set oeore=$o(^||TMP($j,exStDate,exStTime,oeore))
				set ord=+oeore, itm=$p(oeore,"||",2), exec=$p(oeore,"||",3)
				set execData=$g(^OEORD(ord,"I",itm,"X",exec))
				continue:(execData="")
				set PriorityDR=$p($g(^OEORD(ord,"I",itm,1)),"^",8)
				set PriorityDesc=$s((+PriorityDR'=0):$p($g(^OECPR(PriorityDR)),"^",2),1:"")
				set PriorityDesc=##class(User.OECPriority).GetTranByDesc("OECPRDesc", PriorityDesc, langId)
				set UserAddDR=$p($g(^OEORD(ord,"I",itm,7)),"^",1)    //OEORI_UserAdd 开医嘱人
				set UserAddDesc=$s((+UserAddDR'=0):$p($g(^SSU("SSUSR",UserAddDR)),"^",2),1:"")
				set UserAddDesc=##class(User.SSUser).GetTranByDesc("SSUSRName", UserAddDesc, langId)
				set UserDeptDR=$p($g(^OEORD(ord,"I",itm,7)),"^",2)	//OEORI_UserDepartment_DR 开单科室
				set UserDeptDesc=$s((+UserDeptDR'=0):$p($g(^CTLOC(UserDeptDR)),"^",2),1:"")
				set UserDeptDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", UserDeptDesc, langId)
				set pboRowId=$$GetPBORowID()
				continue:(pboRowId="")
				set pb=+pboRowId, pbo=+$p(pboRowId,"||",2)
				set pboData=$g(^DHCPB(pb,"O",pbo))
				continue:(pboRowId="")
				set pboBillQty=$p(pboData,"^",5)
				set pboRefQty=$p(pboData,"^",6)
				set billQty=pboBillQty+pboRefQty
				set billQty=$fn(billQty,"N")
				set billTotalAmt=$p(pboData,"^",8)
				set billTotalAmt=$fn(billTotalAmt,"",2)
				set CareProvDR=$p(execData,"^",15)        //OEORE_CTPCP_DR
				set CareProvDesc=$s((CareProvDR'=""):$p($g(^CTPCP(CareProvDR,1)),"^",2),1:"")     //执行人
				set CareProvDesc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", CareProvDesc, langId)
				set OrderStatusDR=$p(execData,"^",16)    //OEORE_Order_Status_DR
				set OrderStatus=$s((+OrderStatusDR'=0):$p(^OEC("STAT",OrderStatusDR),"^",2),1:"")  //执行状态
				set OrderStatus=##class(User.OECOrderAdminStatus).GetTranByDesc("STATDesc", OrderStatus, langId)
				set ExStDate=$p(execData,"^",1)              //OEORE_ExStDate 要求执行时间
				set ExStTime=$p(execData,"^",2)              //OEORE_ExStTime
				set ExStDate=##class(websys.Conversions).DateLogicalToHtml(ExStDate)
				set ExStTime=##class(websys.Conversions).TimeLogicalToHtml(ExStTime, 1)
				set ExecDate=$p(execData,"^",19)
				set ExecTime=$p(execData,"^",20)
				set ExecDate=##class(websys.Conversions).DateLogicalToHtml(ExecDate)
				set ExecTime=##class(websys.Conversions).TimeLogicalToHtml(ExecTime, 1)  //执行时间
				set dsp=0, ColQty=0, RefQty=0
				while($o(^DHCOEDISQTY(0,"OEORE",oeore,dsp))) {
					set dsp=$o(^DHCOEDISQTY(0,"OEORE",oeore,dsp))
					set dspData=$g(^DHCOEDISQTY(dsp))
					continue:(dspData="")
					set dspStatus=$p(dspData,"^",7)
					set dspQty=$p(dspData,"^",11)
					if (dspStatus="C") {
						set ColQty=$i(ColQty,dspQty)
					}
					if (dspStatus="R") {
						set RefQty=$i(RefQty,dspQty)
					}
				}
				set BilledInfo=##class(web.DHCBillInterface).IGetOrdItmBilled(oeore)
				set BillFlag=$p(BilledInfo,"^",2)
				set freeChargeFlag=$p($g(^OEORD(ord,"I",itm,"X",exec,"BILL")),"^",18)   //OEORE_FreeChargeFlag
				if (freeChargeFlag="Y") {
					set BillFlag="免费"
				}
				set BillFlag=##class(websys.Translation).Get("", BillFlag, langId)
				set confFlag=""
				if (pboRowId'="") {
					set confDR=$o(^DHCIPBillPatFeeConfirmi(0,"PBO",pboRowId,""),-1)
					set conSub=$s((+confDR'=0):$o(^DHCIPBillPatFeeConfirmi(0,"PBO",pboRowId,confDR,""),-1),1:"")
					set confFlag=$s((+conSub'=0):$p(^DHCIPBillPatFeeConfirm(confDR,"O",conSub),"^",3),1:"")
					set confFlag=$case(confFlag,"R":"撤销审核","C":"审核","D":"拒绝",:"")
					set confFlag=##class(websys.Translation).Get("", confFlag, langId)
				}
				set BilledSum=BilledSum+billTotalAmt
				do OutputExecInfo
			}
		}
	}
	
	set (PriorityDesc,ExecDate,ExecTime,OrderStatus,CareProvDesc,UserDeptDesc,ExStDate,ExStTime,Patamt,pboRowId,BillFlag,ColQty,RefQty,oeore,confFlag,UserAddDesc,billQty)=""
	set PriorityDesc=##class(websys.Translation).Get("", "合计", langId)
	set billTotalAmt=$fn(BilledSum,"",2)
	do OutputExecInfo

	kill ^||TMP($j)
	quit $$$OK
	
GetPBORowID()
	if (+billId'=0) {
		set pbo=$o(^DHCPB(0,"OEEXC",oeore,billId,""))
		set pboRowId=billId_"||"_pbo
	}else {
		set pboRowId=$p($g(^OEORD(ord,"I",itm,"X",exec,"BILL")),"^",2)
	}
	quit pboRowId
	
OutputExecInfo
	set Data=$lb(PriorityDesc,ExecDate,ExecTime,OrderStatus,CareProvDesc,UserDeptDesc,ExStDate,ExStTime,billTotalAmt,pboRowId,BillFlag,ColQty,RefQty,oeore,confFlag,UserAddDesc,billQty)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

}
