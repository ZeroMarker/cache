Import SQLUser

/// 名称:新物流维护
/// 描述:查询医嘱项与对应的库存项信息，并维护关联收费项
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2015-7-22
Class web.DHCBL.CT.INCItmNew Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function: 医嘱项查找 SCGType只查出来材料 SCGType=""
/// CreateDate: 2015-7-23
/// Creator: 基础数据平台组 - 陈莹
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.INCItmNew","GetARCIMList","","","","","","","","","N","","","A","Y")
/// ID , arcimcode, arcimdesc,  arcimalias:YBZ, arcimbillgrp, arcimbillsub , 
/// arcimitemcat , arcimservicegroup, chargelinkflag , chargetype ,taridesc1,update,enableflag  ///;druglist:1,
Query GetARCIMList(ID As %String, arcimcode As %String, arcimdesc As %String, arcimalias As %String, arcimbillgrp As %String, arcimbillsub As %String, arcimitemcat As %String, arcimservicegroup As %String, chargelinkflag As %String, chargetype As %String, taridesc1 As %String, update As %String, enableflag) As %Query(ROWSPEC = "ARCIMRowId:%String,ARCIMCode:%String,ARCIMDesc:%String,INCIRowId:%String,TARIRowId:%String,OLTRowId:%String,INCIDesc:%String,INCICode:%String,INCICTUOMDR:%String,INCICTUOMPurchDR:%String,INFORowId:%String,INFOPbRp:%String,INFOPbVendorDR:%String,INFOPbVendorDRID:%String,INFOPbManfDR:%String,INFOPbManfDRID:%String,TARIActiveFlag:%String,TARISpecialFlag:%String,INCICTUOMDRID:%String,ARCIMUpdateDate:%String,ResultRPFactor")
{
}

ClassMethod GetARCIMListExecute(ByRef qHandle As %Binary, ID As %String, arcimcode As %String, arcimdesc As %String, arcimalias As %String, arcimbillgrp As %String, arcimbillsub As %String, arcimitemcat As %String, arcimservicegroup As %String, chargelinkflag As %String, chargetype As %String, taridesc1 As %String, update As %String, enableflag) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 s strResult=""
 if (ID'="") 
 {
	s ARCIMSubscript=$p(ID,"||",1)
	s ARCIMVersion=$p(ID,"||",2)
	s ARCIMRowId=ID                                                           ; 医嘱ARCIMRowId
	s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)          ; 医嘱代码
	s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)           ; 医嘱名称
	s ARCIMCode = $p(ARCIMCode,$c(13,10),1)
  	S ARCIMDesc = $p(ARCIMDesc,$c(13,10),1)  //去掉回车换行符
  	s ARCIMUpdateDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",1) 
  	; 库存项信息
	s INCIRowId=$o(^INCI(0,"ARCIM_DR",ARCIMSubscript,0))   //库存项ID
	; 库存项信息
	s (INCIDesc,INCICode,INCICTUOMDR,INCICTUOMPurchDR,INFORowId,INFOPbRp,INFOPbVendorDR,INFOPbManfDR,INFOPbVendorDRID,INFOPbManfDRID,INCICTUOMDRID)=""
	s:INCIRowId'="" INCIDesc=$p($g(^INCI(INCIRowId,1)),"^",2)
	s:INCIRowId'="" INCICode=$p($g(^INCI(INCIRowId,1)),"^",1)
	s:INCIRowId'="" INCICTUOMDR=$p($g(^INCI(INCIRowId,1)),"^",10) //基本单位
	S INCICTUOMDRID=INCICTUOMDR
	s:INCICTUOMDR'="" INCICTUOMDR=$p($g(^CT("UOM",INCICTUOMDR)),"^",2)
	s:INCIRowId'="" INCICTUOMPurchDR=$p($g(^INCI(INCIRowId,3)),"^",6)  //入库单位
	s:INCICTUOMPurchDR'="" INCICTUOMPurchDR=$p($g(^CT("UOM",INCICTUOMPurchDR)),"^",2)
	s:INCIRowId'="" INFORowId=$o(^DHCITMINFO(0,"INCI",INCIRowId,0)) //DHC_ItmAddionInfo 库存项附加表
	s:INFORowId'="" INFOPbRp=$P($G(^DHCITMINFO(INFORowId)),"^",22)  //招标进价
	s:INFORowId'="" INFOPbVendorDR=$P($G(^DHCITMINFO(INFORowId)),"^",24)  //招标供应商  User.APCVendor
	s:INFORowId'="" INFOPbManfDR=$P($G(^DHCITMINFO(INFORowId)),"^",25)  //招标生产厂商  User.PHManufacturer
	s INFOPbVendorDRID=INFOPbVendorDR
	s INFOPbManfDRID=INFOPbManfDR
	s:INFOPbVendorDR'="" INFOPbVendorDR=$p($g(^APC("APCVM",INFOPbVendorDR)),"^",3)
	s:INFOPbManfDR'="" INFOPbManfDR=$p($g(^PHMNF(INFOPbManfDR)),"^",2)
	
	///进货价是IN_AdjSalePrice中的INASP_ResultRP*转换系数(基本单位和入库单位)	2016-10-17
	s ResultRPFactor=""
	/*s INCICTUOMPurchDRID=""
	s:INCIRowId'="" INCICTUOMPurchDRID=$p($g(^INCI(INCIRowId,3)),"^",6)
	s HOSPtalID=$g(%session.Data("LOGON.HOSPID"))
	s ResultRPFactor=##class(web.DHCSTM.Common.PriceCommon).GetInciBasicRp(INCIRowId,+$h,INCICTUOMPurchDRID,HOSPtalID) 
	*/
	
	
	s TARIRowId=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,0))   //关联收费项ID
	s TARIActiveFlag="N",TARISpecialFlag="N"
	;checkbox
	s:TARIRowId'="" TARIActiveFlag=$p($g(^DHCTARI(TARIRowId)),"^",7)
	s:TARIRowId'="" TARISpecialFlag=$p($g(^DHCTARI(TARIRowId)),"^",17)
	
	;收费项和医嘱项关联表ID
	s OLTStartDate="",OLTRowId=""
	s:TARIRowId'="" OLTStartDate=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,TARIRowId,0))
	s:OLTStartDate'="" OLTRowId=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,TARIRowId,OLTStartDate,0))
	
	;只取材料M, 过滤掉药品G 其他收费项目x 2015-7-29 陈莹
	S (INCIINCSCDR,SCGRowid,SCGType)=""
	s:INFORowId'="" INCIINCSCDR=$P($g(^INCI(INCIRowId,2)),"^",2)  //INCItm里字段INCIINCSCDR->INC_StkCat
	s:INCIINCSCDR'="" SCGRowid=$O(^DHCSCG("STKCAT",INCIINCSCDR,""))  //子表DHC_StkCatGrpRelations里字段SCGRStkCatDR->INC_StkCat
	s:SCGRowid'="" SCGType=$P($g(^DHCSCG(SCGRowid)),"^",3)  //父表DHC_StkCatGroup里字段SCG_Type  "M"  "G"
	
  	d OutputRowA
 }
 else
 {
	s IDStr="",IDS="",count=0
	if update="" s update="A"
	if (arcimitemcat'="") //医嘱子类通过索引
	{
		S ARCIMSubscript=0
		for
		{
			s ARCIMSubscript=$o(^ARCIM(0,"ARCIC_DR",arcimitemcat,ARCIMSubscript)) q:ARCIMSubscript=""
			s ARCIMVersion=0
			for 
			{
				s ARCIMVersion=$o(^ARCIM(0,"ARCIC_DR",arcimitemcat,ARCIMSubscript,ARCIMVersion)) q:ARCIMVersion=""
				s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
   				s ARCIMRowId=##class(web.DHCBL.CT.INCItmNew).GetARCIMByParam(ARCIMRowId,arcimcode, arcimdesc,  arcimalias, arcimbillgrp, arcimbillsub, arcimitemcat, arcimservicegroup, chargelinkflag, chargetype,taridesc1,update,enableflag) 
   				continue:ARCIMRowId=""
				s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)          ; 医嘱代码
				s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)           ; 医嘱名称
				s ARCIMCode = $p(ARCIMCode,$c(13,10),1)
  				S ARCIMDesc = $p(ARCIMDesc,$c(13,10),1)
  				s ARCIMUpdateDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",1)
  				; 库存项信息
				s INCIRowId=$o(^INCI(0,"ARCIM_DR",ARCIMSubscript,0))   //库存项ID
				; 库存项信息
				s (INCIDesc,INCICode,INCICTUOMDR,INCICTUOMPurchDR,INFORowId,INFOPbRp,INFOPbVendorDR,INFOPbManfDR,INFOPbVendorDRID,INFOPbManfDRID)=""
				s:INCIRowId'="" INCIDesc=$p($g(^INCI(INCIRowId,1)),"^",2)
				s:INCIRowId'="" INCICode=$p($g(^INCI(INCIRowId,1)),"^",1)
				s:INCIRowId'="" INCICTUOMDR=$p($g(^INCI(INCIRowId,1)),"^",10) //基本单位
				S INCICTUOMDRID=INCICTUOMDR
				s:INCICTUOMDR'="" INCICTUOMDR=$p($g(^CT("UOM",INCICTUOMDR)),"^",2)
				s:INCIRowId'="" INCICTUOMPurchDR=$p($g(^INCI(INCIRowId,3)),"^",6)  //入库单位
				s:INCICTUOMPurchDR'="" INCICTUOMPurchDR=$p($g(^CT("UOM",INCICTUOMPurchDR)),"^",2)
				s:INCIRowId'="" INFORowId=$o(^DHCITMINFO(0,"INCI",INCIRowId,0)) //DHC_ItmAddionInfo 库存项附加表
				s:INFORowId'="" INFOPbRp=$P($G(^DHCITMINFO(INFORowId)),"^",22)  //招标进价
				s:INFORowId'="" INFOPbVendorDR=$P($G(^DHCITMINFO(INFORowId)),"^",24)  //招标供应商  User.APCVendor
				s:INFORowId'="" INFOPbManfDR=$P($G(^DHCITMINFO(INFORowId)),"^",25)  //招标生产厂商  User.PHManufacturer
				s INFOPbVendorDRID=INFOPbVendorDR
				s INFOPbManfDRID=INFOPbManfDR
				s:INFOPbVendorDR'="" INFOPbVendorDR=$p($g(^APC("APCVM",INFOPbVendorDR)),"^",3)
				s:INFOPbManfDR'="" INFOPbManfDR=$p($g(^PHMNF(INFOPbManfDR)),"^",2)
				
				///进货价是IN_AdjSalePrice中的INASP_ResultRP*转换系数(基本单位和入库单位)	2016-10-17
				s ResultRPFactor=""
				/*s INCICTUOMPurchDRID=""
				s:INCIRowId'="" INCICTUOMPurchDRID=$p($g(^INCI(INCIRowId,3)),"^",6)
				s HOSPtalID=$g(%session.Data("LOGON.HOSPID"))
				s ResultRPFactor=##class(web.DHCSTM.Common.PriceCommon).GetInciBasicRp(INCIRowId,+$h,INCICTUOMPurchDRID,HOSPtalID) 
				*/	
	
				s TARIRowId=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,0))   //关联收费项ID
				;checkbox
				s:TARIRowId'="" TARIActiveFlag=$p($g(^DHCTARI(TARIRowId)),"^",7)
				s:TARIRowId'="" TARISpecialFlag=$p($g(^DHCTARI(TARIRowId)),"^",17)
				;收费项和医嘱项关联表ID
				s OLTStartDate="",OLTRowId=""
				s:TARIRowId'="" OLTStartDate=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,TARIRowId,0))
				s:OLTStartDate'="" OLTRowId=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,TARIRowId,OLTStartDate,0))
  				d OutputRowA
			}
 
		}
 
	}
	elseif (arcimservicegroup'="") 
	{ //服务资源组
		
		S ARCIMSubscript=0
		for
		{
			s ARCIMSubscript=$o(^ARCIM(0,"SERGRP",arcimservicegroup,ARCIMSubscript)) q:ARCIMSubscript=""
			s ARCIMVersion=0
			for 
			{
				s ARCIMVersion=$o(^ARCIM(0,"SERGRP",arcimservicegroup,ARCIMSubscript,ARCIMVersion)) q:ARCIMVersion=""
				s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
   				s ARCIMRowId=##class(web.DHCBL.CT.INCItmNew).GetARCIMByParam(ARCIMRowId,arcimcode, arcimdesc, arcimalias, arcimbillgrp, arcimbillsub, arcimitemcat, arcimservicegroup, chargelinkflag, chargetype,taridesc1,update,enableflag) 
   				continue:ARCIMRowId=""
				s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)          ; 医嘱代码
				s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)           ; 医嘱名称
				s ARCIMCode = $p(ARCIMCode,$c(13,10),1)
  				S ARCIMDesc = $p(ARCIMDesc,$c(13,10),1)
  				s ARCIMUpdateDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",1)
  				; 库存项信息
				s INCIRowId=$o(^INCI(0,"ARCIM_DR",ARCIMSubscript,0))   //库存项ID
				; 库存项信息
				s (INCIDesc,INCICode,INCICTUOMDR,INCICTUOMPurchDR,INFORowId,INFOPbRp,INFOPbVendorDR,INFOPbManfDR,INFOPbVendorDRID,INFOPbManfDRID)=""
				s:INCIRowId'="" INCIDesc=$p($g(^INCI(INCIRowId,1)),"^",2)
				s:INCIRowId'="" INCICode=$p($g(^INCI(INCIRowId,1)),"^",1)
				s:INCIRowId'="" INCICTUOMDR=$p($g(^INCI(INCIRowId,1)),"^",10) //基本单位
				S INCICTUOMDRID=INCICTUOMDR
				s:INCICTUOMDR'="" INCICTUOMDR=$p($g(^CT("UOM",INCICTUOMDR)),"^",2)
				s:INCIRowId'="" INCICTUOMPurchDR=$p($g(^INCI(INCIRowId,3)),"^",6)  //入库单位
				s:INCICTUOMPurchDR'="" INCICTUOMPurchDR=$p($g(^CT("UOM",INCICTUOMPurchDR)),"^",2)
				s:INCIRowId'="" INFORowId=$o(^DHCITMINFO(0,"INCI",INCIRowId,0)) //DHC_ItmAddionInfo 库存项附加表
				s:INFORowId'="" INFOPbRp=$P($G(^DHCITMINFO(INFORowId)),"^",22)  //招标进价
				s:INFORowId'="" INFOPbVendorDR=$P($G(^DHCITMINFO(INFORowId)),"^",24)  //招标供应商  User.APCVendor
				s:INFORowId'="" INFOPbManfDR=$P($G(^DHCITMINFO(INFORowId)),"^",25)  //招标生产厂商  User.PHManufacturer
				s INFOPbVendorDRID=INFOPbVendorDR
				s INFOPbManfDRID=INFOPbManfDR
				s:INFOPbVendorDR'="" INFOPbVendorDR=$p($g(^APC("APCVM",INFOPbVendorDR)),"^",3)
				s:INFOPbManfDR'="" INFOPbManfDR=$p($g(^PHMNF(INFOPbManfDR)),"^",2)
				///进货价是IN_AdjSalePrice中的INASP_ResultRP*转换系数(基本单位和入库单位)	2016-10-17
				s ResultRPFactor=""
				/*s INCICTUOMPurchDRID=""
				s:INCIRowId'="" INCICTUOMPurchDRID=$p($g(^INCI(INCIRowId,3)),"^",6)
				s HOSPtalID=$g(%session.Data("LOGON.HOSPID"))
				s ResultRPFactor=##class(web.DHCSTM.Common.PriceCommon).GetInciBasicRp(INCIRowId,+$h,INCICTUOMPurchDRID,HOSPtalID) 
				*/	
				s TARIRowId=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,0))   //关联收费项ID
				;checkbox
				s:TARIRowId'="" TARIActiveFlag=$p($g(^DHCTARI(TARIRowId)),"^",7)
				s:TARIRowId'="" TARISpecialFlag=$p($g(^DHCTARI(TARIRowId)),"^",17)
				;收费项和医嘱项关联表ID
				s OLTStartDate="",OLTRowId=""
				s:TARIRowId'="" OLTStartDate=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,TARIRowId,0))
				s:OLTStartDate'="" OLTRowId=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,TARIRowId,OLTStartDate,0))
  				d OutputRowA
			}
  
		}
	}
	elseif (arcimbillsub'="")
    {
		S ARCIMSubscript=0
		for
		{
			s ARCIMSubscript=$o(^ARCIM(0,"ARCSG_DR",arcimbillsub,ARCIMSubscript)) q:ARCIMSubscript=""
			s ARCIMVersion=0
			for 
			{
				s ARCIMVersion=$o(^ARCIM(0,"ARCSG_DR",arcimbillsub,ARCIMSubscript,ARCIMVersion)) q:ARCIMVersion=""
				s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
   				s ARCIMRowId=##class(web.DHCBL.CT.INCItmNew).GetARCIMByParam(ARCIMRowId,arcimcode, arcimdesc,  arcimalias, arcimbillgrp, arcimbillsub, arcimitemcat, arcimservicegroup, chargelinkflag, chargetype,taridesc1,update,enableflag) 
   				continue:ARCIMRowId=""
				s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)          ; 医嘱代码
				s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)           ; 医嘱名称
				s ARCIMCode = $p(ARCIMCode,$c(13,10),1)
  				S ARCIMDesc = $p(ARCIMDesc,$c(13,10),1)
  				s ARCIMUpdateDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",1)
  				; 库存项信息
				s INCIRowId=$o(^INCI(0,"ARCIM_DR",ARCIMSubscript,0))   //库存项ID
				; 库存项信息
				s (INCIDesc,INCICode,INCICTUOMDR,INCICTUOMPurchDR,INFORowId,INFOPbRp,INFOPbVendorDR,INFOPbManfDR,INFOPbVendorDRID,INFOPbManfDRID)=""
				s:INCIRowId'="" INCIDesc=$p($g(^INCI(INCIRowId,1)),"^",2)
				s:INCIRowId'="" INCICode=$p($g(^INCI(INCIRowId,1)),"^",1)
				s:INCIRowId'="" INCICTUOMDR=$p($g(^INCI(INCIRowId,1)),"^",10) //基本单位
				S INCICTUOMDRID=INCICTUOMDR
				s:INCICTUOMDR'="" INCICTUOMDR=$p($g(^CT("UOM",INCICTUOMDR)),"^",2)
				s:INCIRowId'="" INCICTUOMPurchDR=$p($g(^INCI(INCIRowId,3)),"^",6)  //入库单位
				s:INCICTUOMPurchDR'="" INCICTUOMPurchDR=$p($g(^CT("UOM",INCICTUOMPurchDR)),"^",2)
				s:INCIRowId'="" INFORowId=$o(^DHCITMINFO(0,"INCI",INCIRowId,0)) //DHC_ItmAddionInfo 库存项附加表
				s:INFORowId'="" INFOPbRp=$P($G(^DHCITMINFO(INFORowId)),"^",22)  //招标进价
				s:INFORowId'="" INFOPbVendorDR=$P($G(^DHCITMINFO(INFORowId)),"^",24)  //招标供应商  User.APCVendor
				s:INFORowId'="" INFOPbManfDR=$P($G(^DHCITMINFO(INFORowId)),"^",25)  //招标生产厂商  User.PHManufacturer
				s INFOPbVendorDRID=INFOPbVendorDR
				s INFOPbManfDRID=INFOPbManfDR
				s:INFOPbVendorDR'="" INFOPbVendorDR=$p($g(^APC("APCVM",INFOPbVendorDR)),"^",3)
				s:INFOPbManfDR'="" INFOPbManfDR=$p($g(^PHMNF(INFOPbManfDR)),"^",2)
				///进货价是IN_AdjSalePrice中的INASP_ResultRP*转换系数(基本单位和入库单位)	2016-10-17
				s ResultRPFactor=""
				/*s INCICTUOMPurchDRID=""
				s:INCIRowId'="" INCICTUOMPurchDRID=$p($g(^INCI(INCIRowId,3)),"^",6)
				s HOSPtalID=$g(%session.Data("LOGON.HOSPID"))
				s ResultRPFactor=##class(web.DHCSTM.Common.PriceCommon).GetInciBasicRp(INCIRowId,+$h,INCICTUOMPurchDRID,HOSPtalID) 
				*/
	
				s TARIRowId=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,0))   //关联收费项ID
				;checkbox
				s:TARIRowId'="" TARIActiveFlag=$p($g(^DHCTARI(TARIRowId)),"^",7)
				s:TARIRowId'="" TARISpecialFlag=$p($g(^DHCTARI(TARIRowId)),"^",17)
				;收费项和医嘱项关联表ID
				s OLTStartDate="",OLTRowId=""
				s:TARIRowId'="" OLTStartDate=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,TARIRowId,0))
				s:OLTStartDate'="" OLTRowId=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,TARIRowId,OLTStartDate,0))
				d OutputRowA
			}
  
		}
	}
    elseif (arcimbillgrp'="")&&(arcimbillsub="")
    {
	    s BillSub=0
	    for 
	    {
			s BillSub=$o(^ARCIM(0,"ARCSG_DR",BillSub)) q:BillSub=""
	    	if $p(BillSub,"||",1)=arcimbillgrp
	    	{
	    		s ARCIMSubscript=0
				for
				{
					s ARCIMSubscript=$o(^ARCIM(0,"ARCSG_DR",BillSub,ARCIMSubscript)) q:ARCIMSubscript=""
					s ARCIMVersion=0
					for 
					{
						s ARCIMVersion=$o(^ARCIM(0,"ARCSG_DR",BillSub,ARCIMSubscript,ARCIMVersion)) q:ARCIMVersion=""
						s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
   						s ARCIMRowId=##class(web.DHCBL.CT.INCItmNew).GetARCIMByParam(ARCIMRowId,arcimcode, arcimdesc,  arcimalias, arcimbillgrp, arcimbillsub, arcimitemcat, arcimservicegroup, chargelinkflag, chargetype,taridesc1,update,enableflag) 
   						continue:ARCIMRowId=""
						s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)          ; 医嘱代码
						s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)           ; 医嘱名称
						s ARCIMCode = $p(ARCIMCode,$c(13,10),1)
  						S ARCIMDesc = $p(ARCIMDesc,$c(13,10),1)
  						s ARCIMUpdateDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",1)
  						; 库存项信息
						s INCIRowId=$o(^INCI(0,"ARCIM_DR",ARCIMSubscript,0))   //库存项ID
						; 库存项信息
						s (INCIDesc,INCICode,INCICTUOMDR,INCICTUOMPurchDR,INFORowId,INFOPbRp,INFOPbVendorDR,INFOPbManfDR,INFOPbVendorDRID,INFOPbManfDRID)=""
						s:INCIRowId'="" INCIDesc=$p($g(^INCI(INCIRowId,1)),"^",2)
						s:INCIRowId'="" INCICode=$p($g(^INCI(INCIRowId,1)),"^",1)
						s:INCIRowId'="" INCICTUOMDR=$p($g(^INCI(INCIRowId,1)),"^",10) //基本单位
						S INCICTUOMDRID=INCICTUOMDR
						s:INCICTUOMDR'="" INCICTUOMDR=$p($g(^CT("UOM",INCICTUOMDR)),"^",2)
						s:INCIRowId'="" INCICTUOMPurchDR=$p($g(^INCI(INCIRowId,3)),"^",6)  //入库单位
						s:INCICTUOMPurchDR'="" INCICTUOMPurchDR=$p($g(^CT("UOM",INCICTUOMPurchDR)),"^",2)
						s:INCIRowId'="" INFORowId=$o(^DHCITMINFO(0,"INCI",INCIRowId,0)) //DHC_ItmAddionInfo 库存项附加表
						s:INFORowId'="" INFOPbRp=$P($G(^DHCITMINFO(INFORowId)),"^",22)  //招标进价
						s:INFORowId'="" INFOPbVendorDR=$P($G(^DHCITMINFO(INFORowId)),"^",24)  //招标供应商  User.APCVendor
						s:INFORowId'="" INFOPbManfDR=$P($G(^DHCITMINFO(INFORowId)),"^",25)  //招标生产厂商  User.PHManufacturer
						s INFOPbVendorDRID=INFOPbVendorDR
						s INFOPbManfDRID=INFOPbManfDR
						s:INFOPbVendorDR'="" INFOPbVendorDR=$p($g(^APC("APCVM",INFOPbVendorDR)),"^",3)
						s:INFOPbManfDR'="" INFOPbManfDR=$p($g(^PHMNF(INFOPbManfDR)),"^",2)
						///进货价是IN_AdjSalePrice中的INASP_ResultRP*转换系数(基本单位和入库单位)	2016-10-17
						s ResultRPFactor=""
						/*s INCICTUOMPurchDRID=""
						s:INCIRowId'="" INCICTUOMPurchDRID=$p($g(^INCI(INCIRowId,3)),"^",6)
						s HOSPtalID=$g(%session.Data("LOGON.HOSPID"))
						s ResultRPFactor=##class(web.DHCSTM.Common.PriceCommon).GetInciBasicRp(INCIRowId,+$h,INCICTUOMPurchDRID,HOSPtalID) 
						*/
	
						s TARIRowId=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,0))   //关联的收费项ID
						;收费项和医嘱项关联表ID
						s OLTStartDate="",OLTRowId=""
						s:TARIRowId'="" OLTStartDate=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,TARIRowId,0))
						s:OLTStartDate'="" OLTRowId=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,TARIRowId,OLTStartDate,0))
	
						d OutputRowA
					}
				}
	    	}
		}
    }
    else
    {
	    s ARCIMSubscript=0
	    for
		{
			s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:ARCIMSubscript=""
			s ARCIMVersion=0
			for 
			{
				s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) q:ARCIMVersion=""
				s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion   ; 医嘱ARCIMRowId
  				s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)          ; 医嘱代码
  				s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)           ; 医嘱名称
  				s ARCIMCode = $p(ARCIMCode,$c(13,10),1)
  				s ARCIMDesc = $p(ARCIMDesc,$c(13,10),1)
  				s ARCIMUpdateDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",1)
  	
  				s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10) ; 医嘱子分类

  				s ARCIMBillSubDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)     ;账单子组
  				s:ARCIMBillSubDR="" billGrp=""
  				s:ARCIMBillSubDR'="" billGrp=$p(ARCIMBillSubDR,"||",1)                   ; 账单组DR
 
  				s ARCIMServiceGroupDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",7) ;服务资源组
  
  				; 与库存项关联
   				s INCIRowId=$o(^INCI(0,"ARCIM_DR",ARCIMSubscript,0))   //库存项ID
 				; 库存项信息
				s (INCIDesc,INCICode,INCICTUOMDR,INCICTUOMPurchDR,INFORowId,INFOPbRp,INFOPbVendorDR,INFOPbManfDR,INFOPbVendorDRID,INFOPbManfDRID)=""
				s:INCIRowId'="" INCIDesc=$p($g(^INCI(INCIRowId,1)),"^",2)
				s:INCIRowId'="" INCICode=$p($g(^INCI(INCIRowId,1)),"^",1)
				s:INCIRowId'="" INCICTUOMDR=$p($g(^INCI(INCIRowId,1)),"^",10) //基本单位
				S INCICTUOMDRID=INCICTUOMDR
				s:INCICTUOMDR'="" INCICTUOMDR=$p($g(^CT("UOM",INCICTUOMDR)),"^",2)
				s:INCIRowId'="" INCICTUOMPurchDR=$p($g(^INCI(INCIRowId,3)),"^",6)  //入库单位
				s:INCICTUOMPurchDR'="" INCICTUOMPurchDR=$p($g(^CT("UOM",INCICTUOMPurchDR)),"^",2)
				s:INCIRowId'="" INFORowId=$o(^DHCITMINFO(0,"INCI",INCIRowId,0)) //DHC_ItmAddionInfo 库存项附加表
				s:INFORowId'="" INFOPbRp=$P($G(^DHCITMINFO(INFORowId)),"^",22)  //招标进价
				s:INFORowId'="" INFOPbVendorDR=$P($G(^DHCITMINFO(INFORowId)),"^",24)  //招标供应商  User.APCVendor
				s:INFORowId'="" INFOPbManfDR=$P($G(^DHCITMINFO(INFORowId)),"^",25)  //招标生产厂商  User.PHManufacturer
				s INFOPbVendorDRID=INFOPbVendorDR
				s INFOPbManfDRID=INFOPbManfDR
				s:INFOPbVendorDR'="" INFOPbVendorDR=$p($g(^APC("APCVM",INFOPbVendorDR)),"^",3)
				s:INFOPbManfDR'="" INFOPbManfDR=$p($g(^PHMNF(INFOPbManfDR)),"^",2)
 				
 				s INFOChargeType=""
 				s:INFORowId'="" INFOChargeType=$p($g(^DHCITMINFO(INFORowId)),"^",82)   ;收费类型
 				
 				;只取材料M, 过滤掉药品G 其他收费项目x
				s (INCIINCSCDR,SCGRowid,SCGType)=""
				s:INFORowId'="" INCIINCSCDR=$P($g(^INCI(INCIRowId,2)),"^",2)  //INCItm里字段INCIINCSCDR->INC_StkCat
				s:INCIINCSCDR'="" SCGRowid=$O(^DHCSCG("STKCAT",INCIINCSCDR,""))  //子表DHC_StkCatGrpRelations里字段SCGRStkCatDR->INC_StkCat
				s:SCGRowid'="" SCGType=$P($g(^DHCSCG(SCGRowid)),"^",3)  //父表DHC_StkCatGroup里字段SCG_Type  "M"  "G"
				CONTINUE:(SCGType'="M")
				///进货价是IN_AdjSalePrice中的INASP_ResultRP*转换系数(基本单位和入库单位)	2016-10-17
				s ResultRPFactor=""
				/*s INCICTUOMPurchDRID=""
				s:INCIRowId'="" INCICTUOMPurchDRID=$p($g(^INCI(INCIRowId,3)),"^",6)
				s HOSPtalID=$g(%session.Data("LOGON.HOSPID"))
				s ResultRPFactor=##class(web.DHCSTM.Common.PriceCommon).GetInciBasicRp(INCIRowId,+$h,INCICTUOMPurchDRID,HOSPtalID) 
				*/
	
 				;是否与收费项关联
 				s TARIRowId=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,0))   //关联收费项ID
 				;checkbox
				s:TARIRowId'="" TARIActiveFlag=$p($g(^DHCTARI(TARIRowId)),"^",7)
				s:TARIRowId'="" TARISpecialFlag=$p($g(^DHCTARI(TARIRowId)),"^",17)
 				;收费项和医嘱项关联表ID
				s OLTStartDate="",OLTRowId=""
				s:TARIRowId'="" OLTStartDate=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,TARIRowId,0))
				s:OLTStartDate'="" OLTRowId=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,TARIRowId,OLTStartDate,0))
 				;暂不考虑关联了多个收费项的情况
 				S ChargeLink="N",TARIDesc=""
 				S:TARIRowId'="" ChargeLink="Y"
 				S:TARIRowId="" ChargeLink="N"
 				S:ChargeLink="Y" TARIDesc=$p($g(^DHCTARI(TARIRowId)),"^",2)
				;别名
				s ALIASRowId=0,ALIASText1=""
				for
				{
					s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowId,ALIASRowId))
					q:ALIASRowId=""
					s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
					; 查询出对应rowid下的所有别名，用"^"进行连接
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
 				s Enable="N"
 				s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)               ;医嘱项开始日期
				s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
				s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
				s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)              ;医嘱项结束日期
 				if ((ARCIMEffDate'="")&(ARCIMEffDate<=+$h))&((ARCIMEffDateTo="")||((ARCIMEffDateTo'="")&(ARCIMEffDateTo>=+$h))) s Enable="Y"
		
				if ($ZCONVERT(ARCIMCode,"U")[$ZCONVERT(arcimcode,"U"))&($ZCONVERT(ARCIMDesc,"U")[$ZCONVERT(arcimdesc,"U")&(ALIASText1[$zcvt(arcimalias,"U")))&((billGrp=arcimbillgrp)||(arcimbillgrp=""))&((ARCIMBillSubDR=arcimbillsub)||(arcimbillsub=""))&((ARCIMItemCatDR=arcimitemcat)||(arcimitemcat=""))&((ARCIMServiceGroupDR=arcimservicegroup)||(arcimservicegroup=""))&(((ChargeLink="N")&(chargelinkflag="N"))||((ChargeLink="Y")&(chargelinkflag="Y")&(($ZCVT(TARIDesc,"U")[$ZCVT(taridesc1,"U"))||(taridesc1=""))))&((INFOChargeType=chargetype)||(chargetype=""))&(SCGType="M")&&(((Enable="Y")&&(enableflag="Y"))||(enableflag="N"))
				{
					if (update="A")
	  				{
	  					d OutputRowA
	  					
	  				}
	  				elseif (update="T")
	  				{		  
					  	IF (ARCIMUpdateDate=+$h) d OutputRowA
	  				}
	  				elseif (update="Y")
	  				{
					  	IF (ARCIMUpdateDate=(+$h-1)) d OutputRowA	
	  				}
	  				elseif (update="M")
	  				{
					  	IF (ARCIMUpdateDate>(+$h-30)) d OutputRowA
	  				}
	  				elseif (update="W")
	  				{
					  	IF (ARCIMUpdateDate>(+$h-7)) d OutputRowA
	  				}
				}    
			}
		}
    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowA
    set Data=$lb(ARCIMRowId,ARCIMCode,ARCIMDesc,INCIRowId,TARIRowId,OLTRowId,INCIDesc,INCICode,INCICTUOMDR,INCICTUOMPurchDR,INFORowId,INFOPbRp,INFOPbVendorDR,INFOPbVendorDRID,INFOPbManfDR,INFOPbManfDRID,TARIActiveFlag,TARISpecialFlag,INCICTUOMDRID,ARCIMUpdateDate,ResultRPFactor)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetARCIMListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetARCIMListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetARCIMListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetARCIMListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Function: 判断传入的医嘱项ID 是否符合查询条件， 符合条件返回ID  不符合返回""
/// CreateDate: 2015-7-23
/// Creator: 基础数据平台组 - 陈莹
/// w ##class(web.DHCBL.CT.INCItmNew).GetARCIMByParam("1||1","","","","","","","","Y","","","A","Y")
ClassMethod GetARCIMByParam(ID, arcimcode, arcimdesc, arcimalias, arcimbillgrp, arcimbillsub, arcimitemcat, arcimservicegroup, chargelinkflag, chargetype, taridesc1, update, enableflag) As %String
{
	q:ID="" ""
	S RID=""
	s ARCIMRowId=ID
	s ARCIMSubscript=$p(ID,"||",1)
  	s ARCIMVersion=$p(ID,"||",2)            ; 医嘱ARCIMRowId
  	s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)          ; 医嘱代码
  	s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)           ; 医嘱名称
  	
  	s ARCIMUpdateDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",1)  //更新时间
  	s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10) ; 医嘱子分类

  	s ARCIMBillSubDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)     ;账单子组
  	s:ARCIMBillSubDR="" billGrp=""
  	s:ARCIMBillSubDR'="" billGrp=$p(ARCIMBillSubDR,"||",1)                   ; 账单组DR
 
  	s ARCIMServiceGroupDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",7) ;服务资源组
  
  	; 与库存项关联
  	s INCIRowId=$o(^INCI(0,"ARCIM_DR",ARCIMSubscript,0))   //库存项ID
 	s:INCIRowId'="" INFORowId=$o(^DHCITMINFO(0,"INCI",INCIRowId,0))
 	s:INCIRowId'="" INFOChargeType=$p($g(^DHCITMINFO(INFORowId)),"^",82)
 	s:INCIRowId="" INFORowId=""
 	s:INCIRowId="" INFOChargeType=""  ;收费类型
 	
 	;只取材料M, 过滤掉药品G 其他收费项目x 2015-7-29 陈莹
	S (INCIINCSCDR,SCGRowid,SCGType)=""
	s:INFORowId'="" INCIINCSCDR=$P($g(^INCI(INCIRowId,2)),"^",2)  //INCItm里字段INCIINCSCDR->INC_StkCat
	s:INCIINCSCDR'="" SCGRowid=$O(^DHCSCG("STKCAT",INCIINCSCDR,""))  //子表DHC_StkCatGrpRelations里字段SCGRStkCatDR->INC_StkCat
	s:SCGRowid'="" SCGType=$P($g(^DHCSCG(SCGRowid)),"^",3)  //父表DHC_StkCatGroup里字段SCG_Type  "M"  "G"
	
 	
 	;是否与收费项关联
 	s ChargeLink="N",TARIDesc=""
 	s TARIRowId=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,0))   //关联收费项ID
 	S:TARIRowId'="" ChargeLink="Y"
 	S:TARIRowId="" ChargeLink="N"
 	S:ChargeLink="Y" TARIDesc=$p($g(^DHCTARI(TARIRowId)),"^",2)
 	
 	;别名
 	s ALIASRowId=0,ALIASText1=""
   for
   {
	  s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowId,ALIASRowId))
      q:ALIASRowId=""
      s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
     ; 查询出对应rowid下的所有别名，用"^"进行连接
     s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
  	}
 	s Enable="N"
	s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)               ;医嘱项开始日期
	s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
	s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
	s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)              ;医嘱项结束日期
	if ((ARCIMEffDate'="")&(ARCIMEffDate<=+$h))&((ARCIMEffDateTo="")||((ARCIMEffDateTo'="")&(ARCIMEffDateTo>=+$h))) s Enable="Y"
		
 	if ($ZCONVERT(ARCIMCode,"U")[$ZCONVERT(arcimcode,"U"))&($ZCONVERT(ARCIMDesc,"U")[$ZCONVERT(arcimdesc,"U")&(ALIASText1[$zcvt(arcimalias,"U")))&((billGrp=arcimbillgrp)||(arcimbillgrp=""))&((ARCIMBillSubDR=arcimbillsub)||(arcimbillsub=""))&((ARCIMItemCatDR=arcimitemcat)||(arcimitemcat=""))&((ARCIMServiceGroupDR=arcimservicegroup)||(arcimservicegroup=""))&(((ChargeLink="N")&(chargelinkflag="N"))||((ChargeLink="Y")&(chargelinkflag="Y")&(($zcvt(TARIDesc,"U")[$zcvt(taridesc1,"U"))||(taridesc1=""))))&((INFOChargeType=chargetype)||(chargetype=""))&(SCGType="M")&&(((Enable="Y")&&(enableflag="Y"))||(enableflag="N"))
  	{
	  	if (update="A")
	  	{
	  		S RID=ID
	  	}
	  	elseif (update="T")
	  	{		  
		  	IF (ARCIMUpdateDate=+$h) S RID=ID
	  	}
	  	elseif (update="Y")
	  	{
		  	IF (ARCIMUpdateDate=(+$h-1)) S RID=ID 	
	  	}
	  	elseif (update="M")
	  	{
		  	IF (ARCIMUpdateDate>(+$h-30)) S RID=ID	
	  	}
	  	elseif (update="W")
	  	{
		  	IF (ARCIMUpdateDate>(+$h-7)) S RID=ID
	  	}
  	}
  	else
  	{
	  S RID=""
  	}
  	Q RID
}

/// Creator：陈莹
/// CreatDate: 2015-07-23
/// Description：查询收费类型的数据
/// Table：User.DHCItmChargeType
/// Input：rowid,code,desc
/// Return：ICTRowId,ICTCode,ICTDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.INCItmNew","GetDataForChgType","","","")
Query GetDataForChgType(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ICTRowId:%String,ICTCode:%String,ICTDesc:%String")
{
}

ClassMethod GetDataForChgTypeExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
 
 
	if (rowid'="") //根据rowid返回该条记录
	{
		s ICTRowId=rowid
		s ICTCode=$p($g(^DHCItmChgType(ICTRowId)),"^",1)
		s ICTDesc=$p($g(^DHCItmChgType(ICTRowId)),"^",2)
		d OutputRowChgType
	}
	else
	{
		s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
		s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
		s ICTRowId=0
		for {
			s ICTRowId=$o(^DHCItmChgType(ICTRowId)) q:ICTRowId=""
  			s ICTCode=$p($g(^DHCItmChgType(ICTRowId)),"^",1)
			s ICTDesc=$p($g(^DHCItmChgType(ICTRowId)),"^",2)
		
    
			if ($$ALPHAUP^SSUTIL4(ICTCode)[code)&(($$ALPHAUP^SSUTIL4(ICTDesc)[desc))
			{
				d OutputRowChgType
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowChgType
    set Data=$lb(ICTRowId,ICTCode,ICTDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForChgTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForChgTypeExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetDataForChgTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForChgTypeExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2015-7-29
/// Description:根据"加成收费"描述获取该数据在收费类型表里的RowId
/// Table:User.DHCItmChargeType
/// Input:chgtdesc   "加成收费"
/// Return:id
/// Other:w ##class(web.DHCBL.CT.INCItmNew).GetChgTypeID("加成收费")
ClassMethod GetChgTypeID(chgtdesc) As %String
{
	s id=""
	if (chgtdesc'="")
	{
		s chgtdesc=$$ALPHAUP^SSUTIL4(chgtdesc)
		s ICTRowId=0
		for {
			s ICTRowId=$o(^DHCItmChgType(ICTRowId)) q:ICTRowId=""
			s ICTDesc=$p($g(^DHCItmChgType(ICTRowId)),"^",2)
			s:$$ALPHAUP^SSUTIL4(chgtdesc)=$$ALPHAUP^SSUTIL4(ICTDesc) id=ICTRowId
		}
	}
	q id
}

/// Creator:陈莹
/// CreatDate:2015-7-30
/// Description:获取配置新增收费项时费用子类的默认值
/// w ##class(web.DHCBL.CT.INCItmNew).GetDefaultCate()
ClassMethod GetDefaultCate() As %String
{
	s str=""
	s str="{DVTARISubCate:"""_$p($g(^BDPLOGISTICS("CONFIG")),"^",1)_""",DVTARIAcctCate:"""_$p($g(^BDPLOGISTICS("CONFIG")),"^",2)_""",DVTARIInpatCate:"""_$p($g(^BDPLOGISTICS("CONFIG")),"^",3)_""",DVTARIOutpatCate:"""_$p($g(^BDPLOGISTICS("CONFIG")),"^",4)_""",DVTARIEMCCate:"""_$p($g(^BDPLOGISTICS("CONFIG")),"^",5)_""",DVTARIMCNew:"""_$p($g(^BDPLOGISTICS("CONFIG")),"^",6)_"""}"
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2015-7-30
/// Description:保存配置新增收费项时费用子类的默认值
/// w ##class(web.DHCBL.CT.INCItmNew).SaveDefaultCate()
ClassMethod SaveDefaultCate(DVTARISubCate As %String, DVTARIAcctCate As %String, DVTARIInpatCate As %String, DVTARIOutpatCate As %String, DVTARIEMCCate As %String, DVTARIMCNew As %String) As %String
{
	k ^BDPLOGISTICS("CONFIG")
	s ^BDPLOGISTICS("CONFIG")=DVTARISubCate_"^"_DVTARIAcctCate_"^"_DVTARIInpatCate_"^"_DVTARIOutpatCate_"^"_DVTARIEMCCate_"^"_DVTARIMCNew
	q "{success:'true'}"
}

/// Function: 药物查找
/// CreateDate: 2013-8-22 
/// Creator:  sunfengchao
/// Debug:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.INCItmNew","GetDrugList","","")
Query GetDrugList(rowid As %String, desc As %String) As %Query(ROWSPEC = "PHCDRowId:%String,PHCDCodePHCDName:%String")
{
}

ClassMethod GetDrugListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") 
 {
   s PHCDRowId=rowid
   s PHCDCode=$p($g(^PHCD(PHCDRowId,1)),"^",1)
   s PHCDName=$p($g(^PHCD(PHCDRowId,1)),"^",2)
   s PHCDCodePHCDName=PHCDCode_"-"_PHCDName
   d OutputRowDL
 }
 else
 {
   s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
   s PHCDRowId=0
   for
   {
      s PHCDRowId=$o(^PHCD(PHCDRowId))
      q:(PHCDRowId="")||(PHCDRowId="DF_Form")
      s PHCDCode=$p($g(^PHCD(PHCDRowId,1)),"^",1)
      s PHCDName=$p($g(^PHCD(PHCDRowId,1)),"^",2)
      continue:(PHCDCode="")||(PHCDName="") //屏蔽垃圾数据
      s PHCDCodePHCDName=PHCDCode_"-"_PHCDName
      if ($ZCONVERT(PHCDCodePHCDName,"U")[desc)
      {
        d OutputRowDL
      }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowDL
    set Data=$lb(PHCDRowId,PHCDCodePHCDName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDrugListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDrugListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetDrugListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDrugListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2015-7-25
/// Description:点击医嘱项获取关联的收费项
/// Table:User.DHCTarItem
/// Input:ARCIMRowId
/// Return:Json格式的字符串str={list:[CTCITCode,CTCITDesc,CTCITProvinceDR,CTCITDateFrom,CTCITDateTo,CTCITRowId]}
/// Other:w ##class(web.DHCBL.CT.INCItmNew).OpenData("1870||1")
ClassMethod OpenData(ARCIMRowId As %String) As %String
{
	s str=""
	s TARIRowId=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,0))  //收费项ID 按只有一条处理
	q:TARIRowId="" ""
	s pobj = ##class(User.DHCTarItem).%OpenId(TARIRowId)
	s eobj = ##class(web.Entity.CT.DHCTarItem1).%New()
	s eobj.ARCIMRowId=ARCIMRowId
	s eobj.TARIRowId = TARIRowId
	s eobj.TARICode = pobj.TARICode
	s eobj.TARIDesc = pobj.TARIDesc
	s eobj.TARIInsuName = pobj.TARIInsuName //医保名称
	s eobj.TARIExternalCode = pobj.TARIExternalCode
	s eobj.TARIChargeBasis = pobj.TARIChargeBasis  //收费依据
	s eobj.TARIEngName = pobj.TARIEngName  //收费说明
	if $IsObject(pobj.TARIUOM){
		s eobj.TARIUOM = pobj.TARIUOM.%Id() 
		}

	if $IsObject(pobj.TARISubCate){
		s eobj.TARISubCate = pobj.TARISubCate.%Id() 
		}
	if $IsObject(pobj.TARIAcctCate){
		s eobj.TARIAcctCate = pobj.TARIAcctCate.%Id() 
		}
	if $IsObject(pobj.TARIOutpatCate){
		s eobj.TARIOutpatCate = pobj.TARIOutpatCate.%Id() 
		}
	
	if $IsObject(pobj.TARIEMCCate){
		s eobj.TARIEMCCate = pobj.TARIEMCCate.%Id() 
		}
	
	if $IsObject(pobj.TARIInpatCate){
		s eobj.TARIInpatCate = pobj.TARIInpatCate.%Id() 
		}
	s eobj.TARIMCNew=$p($g(^DHCTARI(TARIRowId)),"^",30)   ;pobj.TARIMCNew   ;新病案首页 有些项目是没有字段的
	s:pobj.TARISpecialFlag="Y" eobj.TARISpecialFlag="true" //checkbox
	s:pobj.TARIActiveFlag="Y" eobj.TARIActiveFlag="true"
	
	s:pobj.TARIStartDate'="" eobj.TARIStartDate =$zd(pobj.TARIStartDate,1)
	s:pobj.TARIEndDate'="" eobj.TARIEndDate = $zd(pobj.TARIEndDate,1)
	
	
	s eobj.OLTStartDate=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,TARIRowId,0))
	q:eobj.OLTStartDate="" ""
	s OLTRowId=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,TARIRowId,eobj.OLTStartDate,0))
	q:OLTRowId="" ""  ///医嘱项与收费项关联ID
	s eobj.OLTRowId=OLTRowId
	s:eobj.OLTStartDate'="" eobj.OLTStartDate = $zd(eobj.OLTStartDate,1)
	s eobj.OLTEndDate=$p($G(^DHCOLT(OLTRowId)),"^",5)
	s:eobj.OLTEndDate'="" eobj.OLTEndDate = $zd(eobj.OLTEndDate,1)
	s eobj.OLTQty=$p($G(^DHCOLT(OLTRowId)),"^",3)
	S eobj.OLTInstDR=$p($G(^DHCOLT(OLTRowId)),"^",6)
	S eobj.OLTPriorityDR=$p($G(^DHCOLT(OLTRowId)),"^",7)
	S eobj.OLTARCIMDR=ARCIMRowId
	S eobj.OLTTariffDR=TARIRowId

	;打印名称 同仁医院使用
	s eobj.TariExpPrintName=""
	s TariExpRowID=$o(^DHCTARIEXPINFO(0,"TARI",TARIRowId,0))
	s:TariExpRowID'="" eobj.TariExpPrintName=$p($g(^DHCTARIEXPINFO(TariExpRowID)),"^",28)  //User.DHCTaritemExpInfo
	
	
	;收费项价格
	s (eobj.TPRowId,eobj.TPPatInsType,eobj.TPAlterPrice1,eobj.TPStartDate,eobj.TPAlterPrice2,eobj.TPPrice,eobj.MRMargin,MRMargin)=""
	
	s TPChildSub=$o(^DHCTARI(TARIRowId,"P",""),-1) //判断是否已经有价格
	; 与库存项关联
	s INCIRowId=$o(^INCI(0,"ARCIM_DR",$p(ARCIMRowId,"||",1),0))   //库存项ID
	; 库存项信息
	s (INFORowId,INFOPbRp)=""
	s:INCIRowId'="" INFORowId=$o(^DHCITMINFO(0,"INCI",INCIRowId,0)) //DHC_ItmAddionInfo 库存项附加表
	s:INFORowId'="" INFOPbRp=$P($G(^DHCITMINFO(INFORowId)),"^",22)  //招标进价
	s eobj.INFOPbRp=INFOPbRp
	if ((TPChildSub'=0)&&(TPChildSub'=""))  //已经有价格,取存的价格
	{ 
		s eobj.TPRowId=TARIRowId_"||"_TPChildSub
		s eobj.TPStartDate=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",3)
		s eobj.TPEndDate=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",4)
		s:eobj.TPStartDate'="" eobj.TPStartDate =$zd(eobj.TPStartDate,1)
		s:eobj.TPEndDate'="" eobj.TPEndDate = $zd(eobj.TPEndDate,1)
		s eobj.TPPatInsType=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",13)  //PACAdmReason	
		s eobj.TPPrice=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",5)
		s eobj.TPAlterPrice1=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",14)
		s eobj.TPAlterPrice2=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",15)
	
		if $e(eobj.TPPrice,1)="." s eobj.TPPrice="0"_eobj.TPPrice
		if $e(eobj.TPAlterPrice1,1)="." s eobj.TPAlterPrice1="0"_eobj.TPAlterPrice1
		if $e(eobj.TPAlterPrice2,1)="." s eobj.TPAlterPrice2="0"_eobj.TPAlterPrice2
		if (INFOPbRp'="")&&(INFOPbRp'=0) s MRMargin=eobj.TPPrice/INFOPbRp
		if MRMargin'="" s eobj.MRMargin=$j(MRMargin,0,2) //保留两位小数点
	}
	
	

	d pobj.%Close()
	k pobj
	
	s str = eobj.JsonS()
	s str=$tr(str,$c(0),"") //北京老年医院有TARIEngName为$c(0)的数据
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2015-7-25
/// Description:点击医嘱项 新增收费项 获取设置的默认值信息
/// Table:User.DHCTarItem
/// Input:ARCIMRowId
/// Return:Json格式的字符串str={list:[CTCITCode,CTCITDesc,CTCITProvinceDR,CTCITDateFrom,CTCITDateTo,CTCITRowId]}
/// Other:w ##class(web.DHCBL.CT.INCItmNew).AddOpenData("858||1","7")
ClassMethod AddOpenData(ARCIMRowId As %String, INCICTUOMDRID As %String) As %String
{
	s str=""
	q:ARCIMRowId="" ""
	s eobj = ##class(web.Entity.CT.DHCTarItem1).%New()
	s eobj.ARCIMRowId=ARCIMRowId
	s eobj.TARIRowId =""  //收费项ID
	s eobj.TARICode =""
	s eobj.TARIDesc = ""
	s eobj.TARIInsuName =""
	s eobj.TARIExternalCode = ""
	s eobj.TARIChargeBasis = ""  //收费依据
	s eobj.TARIEngName = ""  //收费说明
	s eobj.TARIUOM = INCICTUOMDRID
	s eobj.TARISubCate =  $p($g(^BDPLOGISTICS("CONFIG")),"^",1)
	s eobj.TARIAcctCate =  $p($g(^BDPLOGISTICS("CONFIG")),"^",2)
	s eobj.TARIInpatCate = $p($g(^BDPLOGISTICS("CONFIG")),"^",3)
	s eobj.TARIOutpatCate =  $p($g(^BDPLOGISTICS("CONFIG")),"^",4)	
	s eobj.TARIEMCCate = $p($g(^BDPLOGISTICS("CONFIG")),"^",5)
	s eobj.TARIMCNew=$p($g(^BDPLOGISTICS("CONFIG")),"^",6) //string
	s eobj.TARISpecialFlag="false"
	s eobj.TARIActiveFlag="true"
	s eobj.TARIStartDate =""
	s eobj.TARIEndDate =""
	
	s OrFlag= ##class(web.DHCBL.CT.INCItmNew).GetOrderLinkFlag(ARCIMRowId)
	if OrFlag="Y" s eobj.OLTStartDate=$zd(+$h+1,1)
	else  s eobj.OLTStartDate=$zd(+$h,1)
	s eobj.OLTRowId=""
	s eobj.OLTEndDate=""
	s eobj.OLTQty="1"
	s eobj.OLTInstDR=""
	s eobj.OLTPriorityDR=""
	s eobj.OLTARCIMDR=ARCIMRowId
	s eobj.OLTTariffDR=""
	
	;打印名称 同仁医院使用
	s eobj.TariExpPrintName=""
	
	
	;收费项价格
	s (eobj.TPRowId,eobj.TPPatInsType,eobj.TPAlterPrice1,eobj.TPStartDate,eobj.TPAlterPrice2,eobj.TPPrice,eobj.MRMargin,MRMargin)=""

	s eobj.TPPatInsType=""  
	////同仁医院  默认为自费
	s REARowId=0
	for 
	{
		s REARowId=$o(^PAC("ADMREA",REARowId))
		q:((REARowId="")||(eobj.TPPatInsType'=""))
		s READesc=$p($g(^PAC("ADMREA",REARowId)),"^",2)
		if READesc["自费"
		{	
			s eobj.TPPatInsType=REARowId				
		}
	}
	
	s eobj.TPAlterPrice1=""
	s eobj.TPStartDate=$zd(+$h,1)
	s eobj.TPAlterPrice2=""
	s eobj.TPPrice="" //根据加成率自动计算价格
	s eobj.TPRowId=""
	
	; 与库存项关联
	s INCIRowId=$o(^INCI(0,"ARCIM_DR",$p(ARCIMRowId,"||",1),0))   //库存项ID
	; 库存项信息
	s (INFORowId,INFOPbRp)=""
	s:INCIRowId'="" INFORowId=$o(^DHCITMINFO(0,"INCI",INCIRowId,0)) //DHC_ItmAddionInfo 库存项附加表
	s:INFORowId'="" INFOPbRp=$P($G(^DHCITMINFO(INFORowId)),"^",22)  //招标进价
	s eobj.INFOPbRp=INFOPbRp
	 //没有价格,取 招标进价*对应加成率
	if (INFOPbRp'="")&&(INFOPbRp'=0)
	{		
		s MRRowId=0
		for 
		{	
			s MRRowId=$o(^DHCINMR(MRRowId))  q:MRRowId=""
			s MRCode=$p($g(^DHCINMR(MRRowId)),"^",1)
			if MRCode["物资定价" //库存项没有对应字段，暂时先这么写//后期再定?
			{	
				s MRMinRp=$p($g(^DHCINMR(MRRowId)),"^",3)
				s MRMaxRp=$p($g(^DHCINMR(MRRowId)),"^",4)
				s MRMargin=$p($g(^DHCINMR(MRRowId)),"^",5)
				if (INFOPbRp>MRMinRp)&&(INFOPbRp<MRMaxRp)&&(MRMargin'="")&&(MRMargin'=0)
				{
					s eobj.TPPrice=INFOPbRp*MRMargin	  ///""*4->0
					s eobj.MRMargin=MRMargin
				}					
			}				
		}	
	}
	
	s str = eobj.JsonS()
	s str=$tr(str,$c(0),"")
	s str = "{list:["_str_"]}"
	q str
}

/// Function: 获取收费项别名
/// CreateDate: 2015-7-25
/// Creator:  陈莹
/// Table:User.DHCTarItemAlias
/// Debug:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.INCItmNew","GetAlias","","")
Query GetAlias(TARIRowId As %String, rowid As %String) As %Query(ROWSPEC = "TIARowId:%String,TIATARIDR:%String,TIADesc:%String,TIAAlias:%String")
{
}

ClassMethod GetAliasExecute(ByRef qHandle As %Binary, TARIRowId As %String, rowid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") 
	{	
		s TIARowId=rowid
		s TIATARIDR=$p($g(^DHCTARAL(rowid)),"^",1)
		s TIAAlias=$p($g(^DHCTARAL(rowid)),"^",3)
		s TIADesc=$p($g(^DHCTARAL(rowid)),"^",2)
		d OutputRowALIAS
	}
	elseif (TARIRowId'="") 
	{
		s TIARowId=0
		for
		{
			s TIARowId=$o(^DHCTARAL("A",TARIRowId,TIARowId))  q:TIARowId=""
			s TIATARIDR=$p($g(^DHCTARAL(TIARowId)),"^",1)
			s TIAAlias=$p($g(^DHCTARAL(TIARowId)),"^",3)
			s TIADesc=$p($g(^DHCTARAL(TIARowId)),"^",2)
			d OutputRowALIAS
		}
	}

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowALIAS
    set Data=$lb(TIARowId,TIATARIDR,TIADesc,TIAAlias)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAliasExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAliasExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Function: 获取收费项价格
/// CreateDate: 2015-7-25
/// Creator:  陈莹
/// Debug:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.INCItmNew","FindTarPrice","")
Query FindTarPrice(TARIRowId As %String) As %Query(ROWSPEC = "TPRowId:%String, TPTARIParRef:%String,TPStartDate:%String, TPEndDate:%String, TPPrice:%String, TPUpdateUser:%String, TPUpdateDate:%String, TPUpdateTime:%String,  TPPatInsType:%String, TPAlterPrice1:%String, TPAlterPrice2:%String, TPHospitalDR:%String")
{
}

ClassMethod FindTarPriceExecute(ByRef qHandle As %Binary, TARIRowId As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
 
 if (TARIRowId'="") 
 {
	s TPTARIParRef=TARIRowId
	s TPChildSub=""
	;倒序查询
   for
   {
		s TPChildSub=$o(^DHCTARI(TARIRowId,"P",TPChildSub),-1)  q:(TPChildSub=0)||(TPChildSub="")
		s TPRowId=TARIRowId_"||"_TPChildSub
		s TPStartDate=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",3)
		s TPEndDate=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",4)
		s TPPatInsType=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",13)  //PACAdmReason
		s:TPPatInsType'="" TPPatInsType=$p($g(^PAC("ADMREA",TPPatInsType)),"^",2)
		
		s TPPrice=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",5)
		s TPAlterPrice1=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",14)
		s TPAlterPrice2=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",15)
		
		if $e(TPPrice,1)="." s TPPrice="0"_TPPrice
		if $e(TPAlterPrice1,1)="." s TPAlterPrice1="0"_TPAlterPrice1
		if $e(TPAlterPrice2,1)="." s TPAlterPrice2="0"_TPAlterPrice2
		s TPUpdateUser=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",8)
		s:TPUpdateUser'="" TPUpdateUser=$p($g(^SSU("SSUSR",TPUpdateUser)),"^",2)
		
		s TPUpdateDate=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",9)
		s TPUpdateTime=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",10)
		s TPHospitalDR=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",16)
		s:TPHospitalDR=0 TPHospitalDR=""
		s:TPHospitalDR'="" TPHospitalDR=$p($g(^CT("HOSP",TPHospitalDR)),"^",2)
		
		s:TPUpdateTime'="" TPUpdateTime=$zt(TPUpdateTime,1)
		s:TPUpdateDate'="" TPUpdateDate=$zd(TPUpdateDate,3)
		s:TPStartDate'="" TPStartDate=$zd(TPStartDate,3)
		s:TPEndDate'="" TPEndDate=$zd(TPEndDate,3)
		d OutputRowPrice
   }
 }

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowPrice
    set Data=$lb(TPRowId,TPTARIParRef,TPStartDate,TPEndDate,TPPrice, TPUpdateUser, TPUpdateDate, TPUpdateTime,  TPPatInsType, TPAlterPrice1, TPAlterPrice2, TPHospitalDR)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindTarPriceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTarPriceExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTarPriceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTarPriceExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##class(web.DHCBL.CT.INCItmNew).test()
ClassMethod test() As %String
{
	s result=""
	s eobj=##Class(web.Entity.CT.DHCTarItem1).%New()
	s eobj.TARIRowId=""
	s eobj.OLTRowId=""
	s eobj.TARICode="CESHITIANJIA5"
	s eobj.TARIInsuName="424"
	s eobj.TARIUOM="5"
	s eobj.TARISubCate="7"
	s eobj.TARIInpatCate="6"
	s eobj.TARIEMCCate="7"
	s eobj.TARIMCNew="1"
	s eobj.TARIChargeBasis="TW4"
	s eobj.TARIStartDate="2015/07/07"
	s eobj.ARCIMRowId="11856||1"
	s eobj.OLTARCIMDR="11856||1"
	s eobj.TARIDesc="CESHITIANJIA5"
	s eobj.TARIActiveFlag="Y"
	s eobj.TARIExternalCode="3333"
	;s eobj.TARIAlterPrice1=".58"
	;s eobj.TARIAlterPrice2=".58"
	;s eobj.TARIPrice=".58"
	s eobj.TARIAcctCate="7"
	s eobj.TARIOutpatCate="6"
	s eobj.TARIMRCate="7"
	s eobj.TARISpecialFlag="Y"
	s eobj.TARIEngName="2E342"
	s eobj.TARIEndDate="2015/07/24"
	s eobj.OLTQty="2"
	s eobj.OLTPriorityDR="1"
	s eobj.OLTStartDate="2015/07/13"
	s eobj.OLTInstDR="10"
	s eobj.OLTEndDate="2015/07/31"
	s eobj.OLTTariffDR=""
	s eobj.TariExpPrintName="SF"
	s result= ..SaveTariEntity(eobj)
	q result
}

/// w ##class(web.DHCBL.CT.INCItmNew).GetTariPriceRowID()
/// $$GetTariPriceRowID^DHCJFTITMP(TarRowid,HopID)
ClassMethod GetTariPriceRowID(TariRowID, HopID) As %String
{
	q:TariRowID="" ""
  s sub=$o(^DHCTARI(TariRowID,"P",0))
  q:sub="" ""
  s oeordrowid="",usernum=""
  f  s oeordrowid=$o(^OEORDi(0,"ItemDate",+$h,oeordrowid)) q:oeordrowid=""  d
  .q:oeordrowid=0
  .s oeordsub=""
  .f  s oeordsub=$o(^OEORDi(0,"ItemDate",+$h,oeordrowid,oeordsub)) q:oeordsub=""  d
  ..q:oeordsub=0
  ..s ArcItem=$p(^OEORD(oeordrowid,"I",oeordsub,1),"^",2)
  ..q:ArcItem=""
  ..s oltdate=""
  ..f  s oltdate=$o(^DHCOLT(0,"ARCIM",ArcItem,"Z",oltdate)) q:oltdate=""  d
  ...q:oltdate=0
  ...s oltrowid=""
  ...f  s oltrowid=$o(^DHCOLT(0,"ARCIM",ArcItem,"Z",oltdate,oltrowid)) q:oltrowid=""  d
  ....q:oltrowid=0
  ....s olttarrowid=$p(^DHCOLT(oltrowid),"^",2)
  ....q:(olttarrowid'=TariRowID)
  ....s usernum=+$g(usernum)+1
  
  i usernum'="" d	; 说明当天有用到该收费项，所以不允许当天生效
  .s sub=usernum
  e  d
  .i HopID'="" d
  ..i $d(^DHCJFHOSPRICEDATECONFIG("DHCBILL",HopID)) s sub=""	;说明当天没有用到该收费项，且维护配置,所以允许当天生效
  ..e  s sub=1	;说明当天没有用到该收费项，但是没有维护配置，所以不允许当天生效
  .e  s sub=""	;说明当天没有用到该收费项，医院为空，允许当天生效
  q sub
}

/// 判断医嘱项是否已经有开出医嘱 
/// Return:Y:是，N:否
/// w ##class(web.DHCBL.CT.INCItmNew).GetOrderLinkFlag("1||1")
ClassMethod GetOrderLinkFlag(OLTARCIMDR) As %String
{
	q:OLTARCIMDR="" "N"
	s OrderFlag="Y"
 	i $d(^DHCPBi(0,"ARCIM",OLTARCIMDR)) s OrderFlag="Y"
 	e  s OrderFlag="N"
 	q OrderFlag
}

/// 保存收费项子表 收费项价格
/// User.DHCTarItemPrice
ClassMethod SaveTarItemPriceEntity(preobj As web.Entity.CT.DHCTarItemPrice) As %String
{
	s result2=""
	
	s:preobj.TPStartDate'="" preobj.TPStartDate=$zdh(preobj.TPStartDate,15)  //转换日期
	//增加
	if (preobj.TPRowId="")&(preobj.TPTARIParRef'="")    
	{
		s ppobj=##class(User.DHCTarItemPrice).%New(preobj.TPTARIParRef)
		s ppobj.TPStartDate = preobj.TPStartDate 
		
		s myHospitalID=$g(%session.Data("LOGON.HOSPID"))
		s PriceConfig=..GetTariPriceRowID(preobj.TPTARIParRef,myHospitalID)
		Quit:((PriceConfig'="")&(preobj.TPStartDate <=+$h)) "{success:'false',errorinfo:'已有价格,调价开始日期不允许早于或等于当前日期'}"

		if ($e(preobj.TPPrice,1,2)="0.") s preobj.TPPrice=$e(preobj.TPPrice,2,*)
		if ($e(preobj.TPAlterPrice1,1,2)="0.") s preobj.TPAlterPrice1=$e(preobj.TPAlterPrice1,2,*)
		if ($e(preobj.TPAlterPrice2,1,2)="0.") s preobj.TPAlterPrice2=$e(preobj.TPAlterPrice2,2,*)
		s ppobj.TPPrice = preobj.TPPrice
		s ppobj.TPAlterPrice1 = preobj.TPAlterPrice1
		s ppobj.TPAlterPrice2 = preobj.TPAlterPrice2
		d ppobj.TPTARIParRefSetObjectId(preobj.TPTARIParRef)  //preobj.TPTARIParRef不能为空
		d ppobj.TPPatInsTypeSetObjectId(preobj.TPPatInsType)  //TPPatInsType不能为空
		s TARIDesc=$p($g(^DHCTARI(preobj.TPTARIParRef)),"^",2)
		s READesc=$p(^PAC("ADMREA",preobj.TPPatInsType),"^",2)
		s ppobj.TPUpdateDate=+$h
		s ppobj.TPUpdateTime=$p($h,",",2)
		d:myHospitalID'="" ppobj.TPHospitalDRSetObjectId(myHospitalID)
		d:myHospitalID="" ppobj.TPHospitalDRSetObjectId("")
		d ppobj.TPUpdateUserSetObjectId($Get(%session.Data("LOGON.USERID")))  ////$g(%session.Get("LOGON.USERID"))
		
		Tstart
		s scc=ppobj.%Save()
		do ppobj.%Close()
		if $$$ISOK(scc){
			Tcommit
			s tpid = ppobj.%Id()
			s result2 = tpid
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarItemPrice","User.DHCTarItemPrice","收费项价格",tpid,TARIDesc_"-"_READesc,"A",preobj)		
		}else{
			Trollback
			s result2 = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}				
	}
	else
	{
		s result2 = "{success:'false',errorinfo:'ParRef为空！'}"
	}
			
	
	q result2
}

/// 保存收费项，与医嘱项关联，并保存收费项价格，收费项对应的打印名称
ClassMethod SaveTariEntity(eobj As web.Entity.CT.DHCTarItem1) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.TARIStartDate'="" eobj.TARIStartDate=$zdh(eobj.TARIStartDate,15)  //转换日期
		s:eobj.TARIEndDate'="" eobj.TARIEndDate=$zdh(eobj.TARIEndDate,15)      //转换日期
		s:eobj.TARISpecialFlag="" eobj.TARISpecialFlag="N" //checkbox
		s:eobj.TARIActiveFlag="" eobj.TARIActiveFlag="N"
		
		s eobj.TARIMRCate=eobj.TARIMCNew  ///默认取新病案首页的值
		
		//增加
		if (eobj.TARIRowId="")       
		{
			s obj=##class(User.DHCTarItem).%New()
			
			s TempUCode=$$ALPHAUP^SSUTIL4(eobj.TARICode)  //$ZCONVERT(eobj.TARICode,"U")
			s TempCode=$d(^DHCTARI(0,"Code",TempUCode))	
			if (TempCode=0)  //判断Code是否重复
			{
				s TempUDesc=$ZCONVERT(eobj.TARIDesc,"U") 
				s TempDesc=$d(^DHCTARI(0,"Desc",TempUDesc))	
				if (TempDesc=0) //判断Desc是否重复
				{
					s obj.TARICode = eobj.TARICode                      //修改代码
					s obj.TARIDesc= eobj.TARIDesc                      //修改描述
					s obj.TARIInsuName= eobj.TARIInsuName 
					s obj.TARIExternalCode= eobj.TARIExternalCode 
				
					s obj.TARIEngName= eobj.TARIEngName 
					s obj.TARIChargeBasis= eobj.TARIChargeBasis
					s obj.TARIStartDate = eobj.TARIStartDate 
					s obj.TARIEndDate=eobj.TARIEndDate
					s obj.TARISpecialFlag=eobj.TARISpecialFlag
					s obj.TARIActiveFlag=eobj.TARIActiveFlag
					d:eobj.TARIUOM'="" obj.TARIUOMSetObjectId(eobj.TARIUOM)
					d:eobj.TARIUOM="" obj.TARIUOMSetObjectId("")
				
					d:eobj.TARISubCate'="" obj.TARISubCateSetObjectId(eobj.TARISubCate)
					d:eobj.TARISubCate="" obj.TARISubCateSetObjectId("")
					d:eobj.TARIInpatCate'="" obj.TARIInpatCateSetObjectId(eobj.TARIInpatCate)
					d:eobj.TARIInpatCate="" obj.TARIInpatCateSetObjectId("")
					d:eobj.TARIAcctCate'="" obj.TARIAcctCateSetObjectId(eobj.TARIAcctCate)
					d:eobj.TARIAcctCate="" obj.TARIAcctCateSetObjectId("")
					d:eobj.TARIOutpatCate'="" obj.TARIOutpatCateSetObjectId(eobj.TARIOutpatCate)
					d:eobj.TARIOutpatCate="" obj.TARIOutpatCateSetObjectId("")
					
					d:eobj.TARIEMCCate'="" obj.TARIEMCCateSetObjectId(eobj.TARIEMCCate)
					d:eobj.TARIEMCCate="" obj.TARIEMCCateSetObjectId("")
					
					
					d:eobj.TARIMRCate'="" obj.TARIMRCateSetObjectId(eobj.TARIMRCate)
					d:eobj.TARIMRCate="" obj.TARIMRCateSetObjectId("")
					
					Tstart
					s sc=obj.%Save()
					do obj.%Close()
					if $$$ISOK(sc){
						Tcommit
						s id = obj.%Id()
						s $p(^DHCTARI(id),"^",30)=eobj.TARIMCNew      ;;新病案首页 有些项目是没有字段的  string类型
						s result = "{success:'true',TARIRowId:'"_id_"',OLTRowId:''}"
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarItem","User.DHCTarItem","收费项",id,eobj.TARIDesc,"A",eobj)
						
						
						///新增时自动保存别名2016-8-9 chenying
						s aliaseobj=##class(web.Entity.CT.DHCTarItemAlias).%New()
						s aliaseobj.TIAAlias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.TARIDesc)
						s aliaseobj.TIATARIDR=id
						s aliaseobj.TIADesc =eobj.TARIDesc
						d ##class(web.DHCBL.CT.DHCTarItemAlias).SaveEntity(aliaseobj)
						
						
						
						;打印名称 同仁医院使用
						s TariExpRowID=$o(^DHCTARIEXPINFO(0,"TARI",id,0))
						if (TariExpRowID="")
						{
							s TariExpRowID=$o(^DHCTARIEXPINFO(""),-1)+1
							s $p(^DHCTARIEXPINFO(TariExpRowID),"^",1)=id
							s $p(^DHCTARIEXPINFO(TariExpRowID),"^",28)=eobj.TariExpPrintName
							s ^DHCTARIEXPINFO(0,"TARI",id,TariExpRowID)=""
						}
						elseif(TariExpRowID'="")
						{
							s $p(^DHCTARIEXPINFO(TariExpRowID),"^",1)=id
							s $p(^DHCTARIEXPINFO(TariExpRowID),"^",28)=eobj.TariExpPrintName
							s ^DHCTARIEXPINFO(0,"TARI",id,TariExpRowID)=""
						}	
						
						s eobj.TARIRowId=id
						s eobj.OLTTariffDR=id
						
						;保存医嘱项与收费项关联
						s result =..SaveOrderLinkTarEntity(eobj)
						if result["false" q result
						
						;保存收费项价格
						s probj=##class(web.Entity.CT.DHCTarItemPrice).%New()
						s probj.TPTARIParRef=id
						s probj.TPPrice = eobj.TPPrice
						s probj.TPAlterPrice1 = eobj.TPAlterPrice1
						s probj.TPAlterPrice2 = eobj.TPAlterPrice2
						s probj.TPPatInsType=eobj.TPPatInsType
						s probj.TPStartDate = eobj.TPStartDate 
						s probj.TPEndDate = eobj.TPEndDate
						s result2= ..SaveTarItemPriceEntity(probj)
						if result2["false" q result2
						else  s result =$e(result,1,*-1)_",TPRowId:'"_result2_"'}" 
						
					}else{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
					}	
				}
				else  //如果Desc重复
				{
					s result="{success:'false',errorinfo:'该描述已经存在，请重新填写！'}"
				}
			}
			else //如果Code重复
			{
				s result="{success:'false',errorinfo:'该代码已经存在，请重新填写！'}"
			}
		
		}
		//如果RowId已赋值则修改
		else                           
		{
			
			s obj=##class(User.DHCTarItem).%OpenId(eobj.TARIRowId)
			s bobj=##class(web.Entity.CT.DHCTarItem1).%New()
			
			s bobj.TARIRowId=eobj.TARIRowId
			s bobj.TARICode = obj.TARICode                     
			s bobj.TARIDesc= obj.TARIDesc          
			s bobj.TARIInsuName= obj.TARIInsuName 
			s bobj.TARIExternalCode= obj.TARIExternalCode 
			;s bobj.TARIPrice = obj.TARIPrice
			;s bobj.TARIAlterPrice1 = obj.TARIAlterPrice1
			;s bobj.TARIAlterPrice2 = obj.TARIAlterPrice2
			s bobj.TARIEngName= $tr(obj.TARIEngName ,$c(0),"")
			s bobj.TARIChargeBasis= obj.TARIChargeBasis
			s bobj.TARIStartDate = obj.TARIStartDate 
			s bobj.TARIEndDate=obj.TARIEndDate
			s bobj.TARISpecialFlag=obj.TARISpecialFlag
			s bobj.TARIActiveFlag=obj.TARIActiveFlag
			if $IsObject(obj.TARIUOM){
				s bobj.TARIUOM = obj.TARIUOM.%Id() 
			}
			if $IsObject(obj.TARISubCate){
				s bobj.TARISubCate = obj.TARISubCate.%Id() 
			}
			if $IsObject(obj.TARIInpatCate){
				s bobj.TARIInpatCate = obj.TARIInpatCate.%Id() 
			}
			if $IsObject(obj.TARIEMCCate){
				s bobj.TARIEMCCate = obj.TARIEMCCate.%Id() 
			}
			if $IsObject(obj.TARIAcctCate){
				s bobj.TARIAcctCate = obj.TARIAcctCate.%Id() 
			}
			if $IsObject(obj.TARIOutpatCate){
				s bobj.TARIOutpatCate = obj.TARIOutpatCate.%Id() 
			}
			if $IsObject(obj.TARIMRCate){
				s bobj.TARIMRCate = obj.TARIMRCate.%Id() 
			}
			s bobj.TARIMCNew =$p($g(^DHCTARI(eobj.TARIRowId)),"^",30)
			
			s TempUCode=$$ALPHAUP^SSUTIL4(eobj.TARICode)
			s TempCode=$d(^DHCTARI("TARI",0,"Code",TempUCode))	
			s TempRowId1=$o(^DHCTARI("TARI",0,"Code",TempUCode,0))
			if (TempCode=0)||((TempCode'=0)&(eobj.TARIRowId=TempRowId1)) //判断Code是否重复
			{
				s TempUDesc=$$ALPHAUP^SSUTIL4(eobj.TARIDesc)
				s TempDesc=$d(^DHCTARI(0,"Desc",TempUDesc))	
				s TempRowId2=$o(^DHCTARI(0,"Desc",TempUDesc,0))
				if (TempDesc=0)||((TempDesc'=0)&(eobj.TARIRowId=TempRowId2)) //判断Desc是否重复
				{
					s obj.TARICode = eobj.TARICode                      //修改代码
					s obj.TARIDesc= eobj.TARIDesc                      //修改描述
					s obj.TARIInsuName= eobj.TARIInsuName 
					s obj.TARIExternalCode= eobj.TARIExternalCode 
					;if ($e(TPPrice,1,2)="0.") s TPPrice=$e(TPPrice,2,*)
					;if ($e(TARIAlterPrice1,1,2)="0.") s TARIAlterPrice1=$e(TARIAlterPrice1,2,*)
					;if ($e(TARIAlterPrice2,1,2)="0.") s TARIAlterPrice2=$e(TARIAlterPrice2,2,*)
						
					;s obj.TARIPrice = eobj.TARIPrice
					;s obj.TARIAlterPrice1 = eobj.TARIAlterPrice1
					;s obj.TARIAlterPrice2 = eobj.TARIAlterPrice2
					s obj.TARIEngName= eobj.TARIEngName 
					s obj.TARIChargeBasis= eobj.TARIChargeBasis
					s obj.TARIStartDate = eobj.TARIStartDate 
					s obj.TARIEndDate=eobj.TARIEndDate
					s obj.TARISpecialFlag=eobj.TARISpecialFlag
					s obj.TARIActiveFlag=eobj.TARIActiveFlag
					
					d:eobj.TARIUOM'="" obj.TARIUOMSetObjectId(eobj.TARIUOM)
					d:eobj.TARIUOM="" obj.TARIUOMSetObjectId("")
					
					d:eobj.TARISubCate'="" obj.TARISubCateSetObjectId(eobj.TARISubCate)
					d:eobj.TARISubCate="" obj.TARISubCateSetObjectId("")
					d:eobj.TARIInpatCate'="" obj.TARIInpatCateSetObjectId(eobj.TARIInpatCate)
					d:eobj.TARIInpatCate="" obj.TARIInpatCateSetObjectId("")
					d:eobj.TARIAcctCate'="" obj.TARIAcctCateSetObjectId(eobj.TARIAcctCate)
					d:eobj.TARIAcctCate="" obj.TARIAcctCateSetObjectId("")
					d:eobj.TARIOutpatCate'="" obj.TARIOutpatCateSetObjectId(eobj.TARIOutpatCate)
					d:eobj.TARIOutpatCate="" obj.TARIOutpatCateSetObjectId("")
					d:eobj.TARIEMCCate'="" obj.TARIEMCCateSetObjectId(eobj.TARIEMCCate)
					d:eobj.TARIEMCCate="" obj.TARIEMCCateSetObjectId("")
					
					d:eobj.TARIMRCate'="" obj.TARIMRCateSetObjectId(eobj.TARIMRCate)
					d:eobj.TARIMRCate="" obj.TARIMRCateSetObjectId("")
										
					Tstart
					s sc=obj.%Save()
					if $$$ISOK(sc){
						Tcommit
						s id = obj.%Id()
						s $p(^DHCTARI(id),"^",30)=eobj.TARIMCNew      ;;新病案首页 有些项目是没有字段的  string类型
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarItem","User.DHCTarItem","收费项",eobj.TARIRowId,eobj.TARIDesc,"U",eobj,bobj)
						s result = "{success:'true',TARIRowId:'"_id_"',OLTRowId:''}"         //保存数据后,通过RowId返回到这条数据
						
						
						
						///修改描述时自动保存别名2016-8-9 chenying
						if (eobj.TARIDesc'=bobj.TARIDesc)
						{
							s aliaseobj=##class(web.Entity.CT.DHCTarItemAlias).%New()
							s aliaseobj.TIAAlias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.TARIDesc)
							s aliaseobj.TIATARIDR=id
							s aliaseobj.TIADesc =eobj.TARIDesc
							d ##class(web.DHCBL.CT.DHCTarItemAlias).SaveEntity(aliaseobj)	
						}
						
						;打印名称 同仁医院使用
						s TariExpRowID=$o(^DHCTARIEXPINFO(0,"TARI",id,0))
						if (TariExpRowID="")
						{
							s TariExpRowID=$o(^DHCTARIEXPINFO(""),-1)+1
							s ^DHCTARIEXPINFO(TariExpRowID)=id_"^^^^^^^^^^^^^^^^^^^^^^^^^^^"_eobj.TariExpPrintName
							s ^DHCTARIEXPINFO(0,"TARI",id,TariExpRowID)=""
						}
						elseif(TariExpRowID'="")
						{
							s ^DHCTARIEXPINFO(TariExpRowID)=id_"^^^^^^^^^^^^^^^^^^^^^^^^^^^"_eobj.TariExpPrintName
							s ^DHCTARIEXPINFO(0,"TARI",id,TariExpRowID)=""
						}	
						
						
						
						;保存医嘱项与收费项关联
						s result=..SaveOrderLinkTarEntity(eobj)
						
						
					}else{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
					}	
				}
				else //如果Desc重复
				{
					s result="{success:'false',errorinfo:'该描述已经存在，请重新填写！'}"
				}
			}
			else //如果Code重复
			{
				s result="{success:'false',errorinfo:'该代码已经存在，请重新填写！'}"
			}	
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

ClassMethod SaveLogForOther(TableName As %String, ClassName As %String, ClassNameDesc As %String, ObjectReference As %String, ObjectDesc As %String, OperateType As %String, NewValue As %String, OldValue As %String = "")
{
	Set NewValue=..WriteEXTJson(NewValue)
	Set OldValue=..WriteEXTJson(OldValue)
	Do ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(TableName, ClassName, ClassNameDesc, ObjectReference, ObjectDesc, OperateType, NewValue, OldValue)
	Quit
}

ClassMethod WriteEXTJson(JsonStr)
{
	Quit:JsonStr="" JsonStr
	Set JsonStr=$tr(JsonStr,":",":""")
	Set JsonStr=$tr(JsonStr,",",""",")
	Set JsonStr=$tr(JsonStr,"}","""}")
	Quit JsonStr
}

ClassMethod SaveOrderLinkTarEntity(eobj As web.Entity.CT.DHCTarItem1) As %String
{
	n (%session,eobj)
	s result1 =""
	
		//增加
		if (eobj.OLTRowId="")       
		{
			s lobj=##class(User.DHCOrderLinkTar).%New() 
			d lobj.OLTARCIMDRSetObjectId(eobj.OLTARCIMDR)
			d lobj.OLTTariffDRSetObjectId(eobj.OLTTariffDR)
			s lobj.OLTQty=eobj.OLTQty
			s:eobj.OLTStartDate'="" eobj.OLTStartDate=$zdh(eobj.OLTStartDate,15)  //转换日期
			s:eobj.OLTEndDate'="" eobj.OLTEndDate=$zdh(eobj.OLTEndDate,15)      //转换日期
			s lobj.OLTStartDate=eobj.OLTStartDate
			s lobj.OLTEndDate=eobj.OLTEndDate
			d:eobj.OLTPriorityDR'="" lobj.OLTPriorityDRSetObjectId(eobj.OLTPriorityDR)
			d:eobj.OLTPriorityDR="" lobj.OLTPriorityDRSetObjectId("")
			d:eobj.OLTInstDR'="" lobj.OLTInstDRSetObjectId(eobj.OLTInstDR)
			d:eobj.OLTInstDR="" lobj.OLTInstDRSetObjectId("")
			
			;医嘱项已使用标志
			Set CurDate=+$h
			s OrderFlag="Y"
 			i $d(^DHCPBi(0,"ARCIM",eobj.OLTARCIMDR)) s OrderFlag="Y"
 			e  s OrderFlag="N"
			Quit:(eobj.OLTStartDate'="")&((OrderFlag="Y")&(eobj.OLTStartDate<=CurDate)) "{success:'false',errorinfo:'开始日期要晚于当天'}"

			Ts
			s lsc=lobj.%Save()
			if $$$ISOK(lsc){
				Tc
				s oltid = lobj.%Id()
				s result1 = "{success:'true',TARIRowId:'"_eobj.TARIRowId_"',OLTRowId:'"_oltid_"'}"         //保存数据后,通过RowId返回到这条数据
				;日志
				Set JsonStr="{OLTRowId:"_oltid_",OLTARCIMDR:"_eobj.OLTARCIMDR_",OLTTariffDR:"_eobj.OLTTariffDR_",OLTQty:"_eobj.OLTQty_",OLTStartDate:"_eobj.OLTStartDate_",OLTEndDate:"_eobj.OLTEndDate_",OLTInstDR:"_eobj.OLTInstDR_",OLTPriorityDR:"_eobj.OLTPriorityDR_"}" 
				Do ..SaveLogForOther("DHC_OrderLinkTar","User.DHCOrderLinkTar","医嘱项关联收费项表",oltid ,"新增","A",JsonStr)
				
				//同步更新医嘱项描述  eobj.TARIDesc
				;日志
				s arcimrowid1=eobj.OLTARCIMDR
				s ARCIMSubscript1=$p(eobj.OLTARCIMDR,"||",1)
				s ARCIMVersion1=$p(eobj.OLTARCIMDR,"||",2)
				s oldARCIMDesc=$p($g(^ARCIM(ARCIMSubscript1,ARCIMVersion1,1)),"^",2)
				if oldARCIMDesc'=eobj.TARIDesc 
				{
					s $p(^ARCIM(ARCIMSubscript1,ARCIMVersion1,1),"^",2)=eobj.TARIDesc
					Set JsonStr="{ARCIMDesc:"_eobj.TARIDesc_",ARCIMRowId:"_arcimrowid1_"}" 
					Set JsonStrOld="{ARCIMDesc:"_oldARCIMDesc_",ARCIMRowId:"_arcimrowid1_"}" 
					Do ..SaveLogForOther("ARC_ItmMast","User.ARCItmMast","新物流物价维护-医嘱项描述",arcimrowid1,eobj.TARIDesc,"U",JsonStr,JsonStrOld)
					
					///更新收费项目描述时，同步更新医嘱项名称时再新增个医嘱项别名2016-8-9
					s ALIASText=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.TARIDesc)
				    s SaveDataStr=arcimrowid1_"^"_ALIASText_"^^"
				   	D ##class(web.DHCBL.CT.ARCAlias).AddOrderAlias(SaveDataStr)
				
				
				}
			}else{
				
				Tro
				s result1 = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(lsc)_"'}"    //返回错误信息
			}
							
		}
		else
		{
			s:eobj.OLTStartDate'="" eobj.OLTStartDate=$zdh(eobj.OLTStartDate,15)  //转换日期
			s:eobj.OLTEndDate'="" eobj.OLTEndDate=$zdh(eobj.OLTEndDate,15)      //转换日期	
 			
 			;医嘱项已使用,数量不能修改
 			s OldQty=$p($g(^DHCOLT(eobj.OLTRowId)),"^",3)
 			s OrderFlag="Y"
 			i $d(^DHCPBi(0,"ARCIM",eobj.OLTARCIMDR)) s OrderFlag="Y"
 			e  s OrderFlag="N"
			Quit:((OrderFlag="Y")&(eobj.OLTQty'=OldQty)) "{success:'false',errorinfo:'医嘱项已使用,数量不能修改'}"
			
			;结束日期不能早于当天
			Set CurDate=+$h
			Quit:(eobj.OLTEndDate'="")&((eobj.OLTEndDate<CurDate)&(OrderFlag="Y")) "{success:'false',errorinfo:'结束日期不能早于当天'}"
			
			Set JsonStrOld="{OLTRowId:"_eobj.OLTRowId_",OLTARCIMDR:"_$P($G(^DHCOLT(eobj.OLTRowId)),"^",1)_",OLTTariffDR:"_$P($G(^DHCOLT(eobj.OLTRowId)),"^",2)_",OLTQty:"_$P($G(^DHCOLT(eobj.OLTRowId)),"^",3)_",OLTStartDate:"_$P($G(^DHCOLT(eobj.OLTRowId)),"^",4)_",OLTEndDate:"_$P($G(^DHCOLT(eobj.OLTRowId)),"^",5)_",OLTInstDR:"_$P($G(^DHCOLT(eobj.OLTRowId)),"^",6)_",OLTPriorityDR:"_$P($G(^DHCOLT(eobj.OLTRowId)),"^",7)_"}" 
				
			Ts
			&sql(update DHC_OrderLinkTar(OLT_Qty,OLT_StartDate,OLT_EndDate,OLT_Priority_DR,OLT_Inst_DR) values (:eobj.OLTQty,:eobj.OLTStartDate,:eobj.OLTEndDate,:eobj.OLTPriorityDR,:eobj.OLTInstDR) where OLT_RowId=:eobj.OLTRowId )
			if 'SQLCODE
			{
				Tc
				s result1 = "{success:'true',TARIRowId:'"_eobj.TARIRowId_"',OLTRowId:'"_eobj.OLTRowId_"'}"
				//  $SYSTEM.SQL.GetROWID()
				;日志
				
				s ARCIMDesc=$p($g(^ARCIM($P(eobj.OLTARCIMDR,"||",1),$P(eobj.OLTARCIMDR,"||",2),1)),"^",2)
				s TARIDesc=$p($g(^DHCTARI(eobj.OLTTariffDR)),"^",2)
				Set JsonStr="{OLTRowId:"_eobj.OLTRowId_",OLTARCIMDR:"_eobj.OLTARCIMDR_",OLTTariffDR:"_eobj.OLTTariffDR_",OLTQty:"_eobj.OLTQty_",OLTStartDate:"_eobj.OLTStartDate_",OLTEndDate:"_eobj.OLTEndDate_",OLTInstDR:"_eobj.OLTInstDR_",OLTPriorityDR:"_eobj.OLTPriorityDR_"}" 
				Do ..SaveLogForOther("DHC_OrderLinkTar","User.DHCOrderLinkTar","医嘱项关联收费项表",eobj.OLTRowId,ARCIMDesc_"-"_TARIDesc,"U",JsonStr,JsonStrOld)
				
				
				//同步更新医嘱项描述  eobj.TARIDesc
				;日志
				s arcimrowid1=eobj.OLTARCIMDR
				s ARCIMSubscript1=$p(eobj.OLTARCIMDR,"||",1)
				s ARCIMVersion1=$p(eobj.OLTARCIMDR,"||",2)
				s oldARCIMDesc=$p($g(^ARCIM(ARCIMSubscript1,ARCIMVersion1,1)),"^",2)
				if oldARCIMDesc'=eobj.TARIDesc 
				{
					s $p(^ARCIM(ARCIMSubscript1,ARCIMVersion1,1),"^",2)=eobj.TARIDesc
					Set JsonStr="{ARCIMDesc:"_eobj.TARIDesc_",ARCIMRowId:"_arcimrowid1_"}" 
					Set JsonStrOld="{ARCIMDesc:"_oldARCIMDesc_",ARCIMRowId:"_arcimrowid1_"}" 
					Do ..SaveLogForOther("ARC_ItmMast","User.ARCItmMast","新物流物价维护-医嘱项描述",arcimrowid1,eobj.TARIDesc,"U",JsonStr,JsonStrOld)
					
					///更新收费项目描述时，同步更新医嘱项名称时再新增个医嘱项别名2016-8-9
					s ALIASText=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.TARIDesc)
				    s SaveDataStr=arcimrowid1_"^"_ALIASText_"^^"
				    d ##class(web.DHCBL.CT.ARCAlias).AddOrderAlias(SaveDataStr)
				}
			}
			else
			{
				Tro
				s result1 = "{success:'false',errorinfo:'"_$SYSTEM.SQL.SQLCODE(SQLCODE)_"'}"
			}
			
			
			
			/*
			s lobj=##class(User.DHCOrderLinkTar).%OpenId(eobj.OLTRowId)
			s lobj.OLTRowId=eobj.OLTRowId  //?提示没有lobj.OLTRowId
			d lobj.OLTARCIMDRSetObjectId(eobj.OLTARCIMDR)
			d lobj.OLTTariffDRSetObjectId(eobj.OLTTariffDR)
			s lobj.OLTQty=eobj.OLTQty
			s:eobj.OLTStartDate'="" eobj.OLTStartDate=$zdh(eobj.OLTStartDate,15)  //转换日期
			s:eobj.OLTEndDate'="" eobj.OLTEndDate=$zdh(eobj.OLTEndDate,15)      //转换日期
			s lobj.OLTStartDate=eobj.OLTStartDate
			s lobj.OLTEndDate=eobj.OLTEndDate
			
			d:eobj.OLTPriorityDR'="" lobj.OLTPriorityDRSetObjectId(eobj.OLTPriorityDR)
			d:eobj.OLTPriorityDR="" lobj.OLTPriorityDRSetObjectId("")
			d:eobj.OLTInstDR'="" lobj.OLTInstDRSetObjectId(eobj.OLTInstDR)
			d:eobj.OLTInstDR="" lobj.OLTInstDRSetObjectId("")
			
			s lsc=obj.%Save()
			if $$$ISOK(lsc){
				s OLTRowId = lobj.%Id()
				s result = "{success:'true',OLTRowId:'"_OLTRowId_"'}"         //保存数据后,通过RowId返回到这条数据
			
			}else{
				
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(lsc)_"'}"    //返回错误信息
			}
			*/			
		}						
							
		
	q result1
}

ClassMethod SaveTaritemUpdInfo(TARIRowId, UpItmCodeDr, UpOldInfo, UpNewInfo, UpUserId) As %String
{
	s upobj=##class(User.DHCTaritemUpdInfo).%New()
	s UpTariRowid=TARIRowId
	if $IsObject(TARIRowId){
		s upobj.UpdInfoTaritemDr = TARIRowId.%Id() 
		}
	s upobj.UpdInfoItemCodeDr=$g(UpItmCodeDr)
	s upobj.UpdInfoOldInfo=UpOldInfo
	s upobj.UpdInfoNewInfo=UpNewInfo
	s upobj.UpdInfoUpdDate=+$h
	s upobj.UpdInfoUpdTime=$p($h,",",2)
	if $IsObject(UpUserId){
		s upobj.UpdInfoUpdUser = UpUserId.%Id() 
	}
	Tstart
	s usc=upobj.%Save()
	do upobj.%Close()
	if $$$ISOK(usc){
		Tcommit
		s err = ""        //保存数据后,通过RowId返回到这条数据
	}else{
		Trollback
		s err =##class(web.DHCBL.BDP.FunLib).GetErrorInfo(usc)    //返回错误信息
	}
 	q err
}

ClassMethod SaveTaritemAliasEntity(eobj As web.Entity.CT.DHCTarItemAlias) As %String
{
	s result=""
	if $IsObject(eobj)
	{		
		//增加
		if (eobj.TIARowId="")       
		{
			s obj=##class(User.DHCTarItemAlias).%New()
			s tempr=$d(^DHCTARAL("A",0,"Desc",$$ALPHAUP^SSUTIL4(eobj.TIAAlias),eobj.TIATARIDR))
			if (tempr=0)  //判断Code是否重复
			{			
				s obj.TIADesc = eobj.TIADesc
				s obj.TIAAlias= eobj.TIAAlias
				d:eobj.TIATARIDR'="" obj.TIATARIDRSetObjectId(eobj.TIATARIDR)
				d:eobj.TIATARIDR="" obj.TIATARIDRSetObjectId("")
				
				Tstart
				s sc=obj.%Save()
				do obj.%Close()
				if $$$ISOK(sc){
					Tcommit
					s id = obj.%Id()
					s result = "{success:'true',id:'"_id_"'}"
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarItemAlias","User.DHCTarItemAlias","收费项别名",id,eobj.TIAAlias,"A",eobj)		
				}else{
					Trollback
					s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
				}		
			}
			else
			{
				s result="{success:'false',errorinfo:'该别名已经存在，请重新填写！'}"
			}
			
		}
		//修改
		else                           
		{		
			/*s obj=##class(User.DHCTarItemAlias).%OpenId(eobj.TIARowId)
			s bobj=##class(web.Entity.CT.DHCTarItemAlias).%New()
			s bobj.TIADesc = obj.TIADesc
			s bobj.TIAAlias= obj.TIAAlias
			d bobj.TIATARIDRSetObjectId(obj.TIATARIDR)
			*/
			s tempr=$d(^DHCTARAL("A",0,"Desc",$$ALPHAUP^SSUTIL4(eobj.TIAAlias),eobj.TIATARIDR))
			s tempr1=$o(^DHCTARAL("A",0,"Desc",$$ALPHAUP^SSUTIL4(eobj.TIAAlias),eobj.TIATARIDR,0))
			if (tempr=0)||((tempr'=0)&(eobj.TIARowId=tempr1)) //判断Alias是否重复
			{	
				/*s obj.TIADesc = eobj.TIADesc
				s obj.TIAAlias= eobj.TIAAlias
				s obj.TIATARIDR= eobj.TIATARIDR 
				d obj.TIATARIDRSetObjectId(eobj.TIATARIDR)					
				
				Tstart
				s sc=obj.%Save()
				if $$$ISOK(sc){
					Tcommit
					s id = obj.%Id()
					s result = "{success:'true',id:'"_id_"'}"
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarItemAlias","User.DHCTarItemAlias","收费项别名",id,eobj.TIAAlias,"U",eobj,bobj)
				}else{
					Trollback
					s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
				}*/
				Set JsonStrOld="{TIADesc:"_$p($g(^DHCTARAL(eobj.TIARowId)),"^",2)_",TIAAlias:"_$p($g(^DHCTARAL(eobj.TIARowId)),"^",2)_",TIATARIDR:"_$p($g(^DHCTARAL(eobj.TIARowId)),"^",2)_"}" 
				
			Ts
			&sql(update DHC_TarItemAlias(TIA_Desc,TIA_Alias) values (:eobj.TIADesc,:eobj.TIAAlias) where TIA_RowId=:eobj.TIARowId )
			if 'SQLCODE
			{
				Tc
				s result = "{success:'true',id:'"_eobj.TIARowId_"'}"
				//  $SYSTEM.SQL.GetROWID()
				;日志
				Set JsonStr="{TIADesc:"_eobj.TIADesc_",TIAAlias:"_eobj.TIAAlias_",TIARowId:"_eobj.TIARowId_",TIATARIDR:"_eobj.TIATARIDR_"}" 
				Do ..SaveLogForOther("DHC_TarItemAlias","User.DHCTarItemAlias","收费项别名",eobj.TIARowId,eobj.TIAAlias,"U",JsonStr,JsonStrOld)
	
			}
			else
			{
				Tro
				s result1 = "{success:'false',errorinfo:'"_$SYSTEM.SQL.SQLCODE(SQLCODE)_"'}"
			}		
			}
			else
			{
				s result="{success:'false',errorinfo:'该别名已经存在，请重新填写！'}"
			}	
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

ClassMethod DeleteTarAlias(id) As %String
{
	s result=""
	
	s eobj = ##class(web.Entity.CT.DHCTarItemAlias).%New()
	s eobj.TIARowId = id
	s eobj.TIATARIDR = $p($g(^DHCTARAL(id)),"^",1)
	s eobj.TIAAlias =$p($g(^DHCTARAL(id)),"^",3)
	s eobj.TIADesc = $p($g(^DHCTARAL(id)),"^",2)
	
	Tstart
	s sc=##class(User.DHCTarItemAlias).%DeleteId(id)
	if $$$ISOK(sc){
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarItemAlias","User.DHCTarItemAlias","收费项别名",id,eobj.TIAAlias,"D",eobj)
	}
	else{
		Trollback
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	
	q result
}

/// 2013-01-12
/// tangtao
/// 处理数据的不可见字符，ASCii表中前33位是不可见字符
/// Ext 前台在处理含不可见字符的jason数据时处理不了，查询不会显示数据，不会报错。
ClassMethod TR(Info)
{
	Quit:Info="" ""
	For i=0:1:32 Do
	.Set Info=$tr(Info,$c(i),"")
	.For j=0:1:32 Do
	..Set Info=$tr(Info,$c(i,j),"")
	
	Quit Info
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	n SQLCODE
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

ClassMethod EvalJSON(instr As %String) As %String
{
	;w ##class(DHCBILLConfig.DHCBILLFIND).EvalJSON("")
	s mystr = instr
	
	q:(mystr="") mystr
	s mystr = ..Replace(mystr,"\", "\\")
	s mystr = ..Replace(mystr,"'", "\'")
	s mystr = ..Replace(mystr,$c(13), "")
	s mystr = ..Replace(mystr,$c(10), "")
	q mystr
}

/// 要求被替换的内容不能=""
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	;
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
	
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

///                      DHCBILLConfig.DHCBILLFIND

}
