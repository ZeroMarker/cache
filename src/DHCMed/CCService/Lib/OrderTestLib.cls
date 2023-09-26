/// 医嘱操作类
/// 创建者：李阳
/// 创建日期：2010-10-08
Class DHCMed.CCService.Lib.OrderTestLib Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     李阳
/// CreatDate：   2010-10-09
/// Description:  判断病人该次就诊是否下了该医嘱
ClassMethod HasOrder(ArcimID As %String)
{
		n (ArcimID, %PAADM, %ExtraData, %ExtraDataCnt)
		s ret=0
		q:ArcimID="" ret
		//^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})
		//^OEORDi(0,"ARCIM",{OE_Order.OEORD_RowId},{OEORI_ItmMast_DR},{OEORI_SttDat},{OEORI_Childsub})
		s ArcimID=$p(ArcimID,"||",2)
		s arcimID=+ArcimID_"||1"
		s detailCnt=1
		s OrderID="" f  s OrderID=$o(^OEORD(0,"Adm",%PAADM,OrderID)) q:OrderID=""  d
		.i $d(^OEORDi(0,"ARCIM",OrderID,arcimID))  d
		..s ret=1
		.s StartDate="" f  s StartDate=$o(^OEORDi(0,"ARCIM",OrderID,arcimID,StartDate)) q:StartDate=""  d
		..s childSub="" f  s childSub=$o(^OEORDi(0,"ARCIM",OrderID,arcimID,StartDate,childSub)) q:childSub=""  d
		...s objOrderItm=##class(DHCMed.Base.OrdItem).GetObjById(OrderID_"||"_childSub)
		...i objOrderItm'=""  d
		....d objOrderItm.%Close()
		...s tmp=""
		...s tmp=objOrderItm.OEORIRowId //记录ID
		...s tmp=tmp_"^"_$zd(objOrderItm.OEORISttDat,3) //开始日期
		...s tmp=tmp_"^"_$zt(objOrderItm.OEORISttTim,1) //开始时间
		...s tmp=tmp_"^"_objOrderItm.ARCIMDesc //医嘱名称
		...s tmp=tmp_"^"_$zd(objOrderItm.OEORIDate,3) //下医嘱日期
		...s tmp=tmp_"^"_$zt(objOrderItm.OEORITime,1)  //下医嘱时间
		...s tmp=tmp_"^"_objOrderItm.OSTATDesc //医嘱状态
		...s %ExtraDataCnt=%ExtraDataCnt+1
		...s $li(%ExtraData,%ExtraDataCnt)="O"_$C(1)_tmp
		q ret
}

ClassMethod GetDetails(Str As %String) As %String
{
	n (Str)
	s ret=""
	s ret="医嘱名称:"_$p(Str,"^",4)
	s ret=ret_"  ||开始时间:"_$p(Str,"^",2)_" "_$p(Str,"^",3)
	s ret=ret_"  ||医嘱状态:"_$p(Str,"^",7)
	q ret
}

}
