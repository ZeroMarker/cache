Class web.DHCARCOSItem Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod ARCOSInfoAll(bPAADMRowID As %String, bARCIMRID As %String, bPatType As %String, bInsType As %String, bOEPrice As %String, bARCType As %String, bPackQty As %String, LocRowID As %String, HospID As %String = "") As %String
{
	;ARC_OrdSets  List Information;
	;获取医嘱套中的医嘱详细信息?
	;1?其他信息?
	;2?执行科室列表?
	;3?对于药物医嘱的默认科室进行库存判断?
	;1?其他信息?
	;OEItmInfo
	n (bPAADMRowID, bARCIMRID, bPatType, bInsType, bOEPrice, bARCType,bPackQty,LocRowID,HospID)
	s ARCOSInfo=""
	s RecLocrid=""
	
	s bARCInfo=$$selectarcim(bARCIMRID)
	s bOrdType=$p(bARCInfo,"^",4)
	Set rset = ##class(%ResultSet).%New("web.DHCOPItemMast:OEItmInfo")
 Set columns = rset.GetColumnCount()
 ;//bPAAdmRowID as %String, bItmMastRowid as %String, bPatType as %String, bInsType as %String
 ;//bOEPrice as %Float,bARCType as %String
 ;qPAAdmRowID , qItmMastRowid , qPatType, qInsType , qOEPrice , qARCType ARCIM
 Set rs = rset.Execute(bPAADMRowID, bARCIMRID,bPatType,bInsType,bOEPrice,bARCType,HospID)
	b
	;oPrice:%Float,oDiscPrice:%Float,oInsPrice:%Float,oPatPrice:%Float
 s (myPrice,myDiscPrice,myInsPrice,myPatPrice)=""
 While (rset.Next()) {
		s myPrice=$fn(rset.Data("oPrice"),"",6)		;4--->6
		s myDiscPrice=$fn(rset.Data("oDiscPrice"),"",6)		;4--->6
		s myInsPrice=$fn(rset.Data("oInsPrice"),"",6)		;4--->6
		s myPatPrice=$fn(rset.Data("oPatPrice"),"",6)		;4--->6
 }
 s bARCInfo=bARCInfo_"^"_myPrice_"^"_myDiscPrice_"^"_myInsPrice_"^"_myPatPrice
	i bPackQty="" d  s bPackQty=1
	s PatPaySum=$fn(bPackQty*myPatPrice,"",2)
	b  ;bARCInfo
	;执行科室列表?
	;Query AIMRecLoc(PAADMRowID As %String, ARCIMRID As %String) As %Query(ROWSPEC = "RecLocDesc:%String,RecLocRID:%String,DefRecFlag:%String")
	Set rset = ##class(%ResultSet).%New("web.DHCOPItemMast:AIMRecLoc")
 Set columns = rset.GetColumnCount()
 ;//bPAAdmRowID as %String, bItmMastRowid as %String, bPatType as %String, bInsType as %String
 ;//bOEPrice as %Float,bARCType as %String
 Set rs = rset.Execute(bPAADMRowID, bARCIMRID,LocRowID)
 s myIdx=0
 s myRecLocStr=""
 While (rset.Next()) {
	 	s myRowVal=""
	 	s defflag=0
	 	i rset.Data("DefRecFlag")="Y" d
	 	.s defflag=1
	 	i myIdx=0 d
	 	.s RecLocrid=rset.Data("RecLocRID")
	 	e  d
	 	.i rset.Data("DefRecFlag")="Y" d
	 	..s RecLocrid=rset.Data("RecLocRID")
	 	
	 	s myRowVal=$g(rset.Data("RecLocRID"))_$c(2)_defflag
	 	s mydes=rset.Data("RecLocDesc")
	 	i $l(rset.Data("RecLocDesc"),"-")>1 d
	 		.s mydes=$p($p(rset.Data("RecLocDesc"),"'"),"-",2)
	 	s myRowVal=mydes_$c(2)_myRowVal
	 	i myRecLocStr="" d
	 	.s myRecLocStr=myRowVal
	 	e  d
	 	.s myRecLocStr=myRecLocStr_$c(1)_myRowVal
		s myIdx=myIdx+1
 }
	;b
 s SelDisable=0
 ;判断医嘱是否有接收科室?
 i RecLocrid="" d
 .s SelDisable=1

 ;对于药物医嘱的默认科室进行库存判断
 ;web.DHCOPCashier.CheckStockEnough(arcimrid,PackQty,RecLocrid)  
 i (bOrdType="R") d
 .s cflag=##class(web.DHCOPCashier).CheckStockEnough(bARCIMRID,bPackQty,RecLocrid)
 .i cflag=1 d
 ..;enough
 ..
 .e  d
 ..;not enough
 ..s SelDisable=1
	;s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")_"');"
	;&javascript<#(rtnval)#>
	s ARCOSInfo=bARCInfo_"^"_myRecLocStr_"^"_SelDisable_"^"_PatPaySum
	
	quit ARCOSInfo
	
selectarcim(RowID)	k PLIST
	s myArcInfo=""
	&SQL(SELECT ARCIM_RowId,ARCIM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef,ARCIM_PHCDF_DR->PHCDF_PHCF_DR->PHCF_Desc,ARCIM_PHCDF_DR,
			ARCIM_RiceType_DR,ARCIM_RiceType_DR->RIC_Desc,ARCIM_ConsultDept,ARCIM_ConsultDept->CTLOC_Desc,
			ARCIM_ItemCat_DR,ARCIM_ItemCat_DR->ARCIC_OrdCat_DR,ARCIM_MealType_DR,ARCIM_MealType_DR->MEALT_Desc,
			ARCIM_PriceCostOnOrdering,ARCIM_InsSubCat_DR,ARCIM_DefPriority_DR,ARCIM_DefPriority_DR->OECPR_Desc,ARCIM_Code,
			ARCIM_PHCDF_DR->PHCDF_PHCFR_DR->PHCFR_Code,ARCIM_ItemCat_DR->ARCIC_OrderType,ARCIM_ItemCat_DR->ARCIC_OrdCat_DR,
			ARCIM_OEMessage,ARCIM_RangeFrom,ARCIM_RangeTo,ARCIM_BillingUOM_DR->CTUOM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCDU_DR,
			ARCIM_PHCDF_DR->PHCDF_GenRtForm_DR,ARCIM_ItemCat_DR->ARCIC_Desc 
	   INTO :rowid,:desc,:code,:code1,:code2,:rice,:ricedes,:cons,:consdes,
	        :subcat,:categ,:mealt,:mealtdes,:cost,:inssubcat,:prior,:priordesc,
	        :arcimcode,:phfreqcode,:subcatordtype,:ordcatid,
	        :oemessage,:rangefrom,:rangeto,:phuomdesc,:phdurrowid,
	        :generic,:subcatdesc
	   FROM Sqluser.ARC_ItmMast  WHERE ARCIM_RowId=:RowID)
	i 'SQLCODE d
	.i oemessage'="" s oemessage=^ARCIM(+bARCIMRID,$P(bARCIMRID,"||",2),"OEM",1)  //p8中用sql查询出来是乱码,报undefined add by wanghc
	.s myArcInfo=desc_"^"_rowid_"^"_subcatdesc_"^"_subcatordtype_"^"_phuomdesc_"^"_$p(phfreqcode,$c(1))_"^"_$p(ordcatid,$C(1))_"^"_oemessage_"^"_rangefrom_"^"_rangeto_"^"_$p(phdurrowid,$C(1))_"^"_generic
	e  d
	.s myArcInfo="^^^^^^^^^^^"
	q myArcInfo
}

}
