Import sqluser

/// creator:    yunhaibao
/// createdate: 2018-05-09
/// description:处方点评核心数据,每天任务执行,之后抽取由处方点评数据表中获取
/// task:		d ##class(web.DHCSTCNTS.Basic).Task()
/// tables:		DHC_PHCNTSORDER(主表)
/// 			DHC_PHCNTSORDERITM(子表)
Class web.DHCSTCNTS.Basic Extends %RegisteredObject
{

/// creator:    yunhaibao
/// createdate: 2018-05-09
/// description:任务生成处方点评基础数据
/// w ##class(web.DHCSTCNTS.Basic).Task()
ClassMethod Task()
{
	d ..Build(+$h-1)
	q 0
}

/// creator:    yunhaibao
/// createdate: 2018-05-09
/// description:生成数据,主索引可优化
ClassMethod Build(ordDate = "")
{
	k BuildArr
	i ordDate="" s ordDate=+$h
	s ordId=""
	f  s ordId=$o(^OEORDi(0,"ItemDate",ordDate,ordId)) q:ordId=""  d
	.q:+ordId=0
	.s admId=$p(^OEORD(ordId),"^",1)
	.s admType=$p(^PAADM(admId),"^",2)
	.i admType="I" s buildType="MOEORI"	
	.e  s buildType="PRESCNO"
	.s ordItm=""
	.f  s ordItm=$o(^OEORDi(0,"ItemDate",ordDate,ordId,ordItm)) q:ordItm=""  d
	..q:+ordItm=0
	..s oeori=ordId_"||"_ordItm
	..// 过滤-非药品医嘱
	..q:'$d(^DHCOEDISQTY(0,"OEORI",oeori))
	..s arcItm=$p(^OEORD(ordId,"I",ordItm,1),"^",2) 
	..s arcVer=$p(arcItm,"||",1),arcSub=$p(arcItm,"||",2)
	..// 过滤-不存在库存项
	..s incId=$o(^INCI(0,"ARCIM_DR",arcVer,"")) 
	..q:incId="" 
 	..s arcItmCatId=$p($g(^ARCIM(arcVer,arcSub,1)),"^",10)
 	..q:$p($g(^ARC("IC",+arcItmCatId)),"^",7)'="R"
	..s mOeori=..GetMainOeori(oeori)
	..q:mOeori=""
	..s prescNo=$p($g(^OEORD(ordId,"I",ordItm,1)),"^",14)
	..// 过滤-已处理医嘱组
	..q:(buildType="MOEORI")&&(mOeori'="")&&($d(BuildArr("mOeori",mOeori)))
	..// 过滤-已处理处方
	..q:(buildType="PRESCNO")&&(prescNo'="")&&($d(BuildArr("prescNo",prescNo)))
	..q:(buildType="PRESCNO")&&(prescNo="")
	..d ..BuildData(mOeori,prescNo,buildType)
	..s BuildArr("mOeori",mOeori)=""
	..i prescNo'="" s BuildArr("prescNo",prescNo)=""
	q ""
}

/// creator:    yunhaibao
/// createdate: 2018-05-09
/// description:生成数据
ClassMethod BuildData(mOeori, prescNo, buildType)
{
	q:(mOeori="")&&(prescNo="") ""
	s mainId=""
	i buildType="MOEORI" d
	.d ..DeleteExist(mOeori, "")
	.s mainId=..InsertMain(mOeori)
	.i $p(mainId,"^",1)<0 q
	.s detailId=..InsertDetail(mainId,mOeori)
	.s ordItm=""
	.f  s ordItm=$o(^OEORDi(0,"OEORI",+mOeori,mOeori,ordItm)) q:ordItm=""  d
	..q:+ordItm=0
	..s detailId=..InsertDetail(mainId,+mOeori_"||"_ordItm)
	i buildType="PRESCNO" d
	.d ..DeleteExist("", prescNo)
	.s ordId=""
	.f  s ordId=$o(^OEORD(0,"PrescNo",prescNo,ordId)) q:ordId=""  d
	..s ordItm=""
	..f  s ordItm=$o(^OEORD(0,"PrescNo",prescNo,ordId,ordItm)) q:ordItm=""  d
	...s oeori=ordId_"||"_ordItm
	...i mainId="" s mainId=..InsertMain(oeori)
	...i $p(mainId,"^",1)<0 q
	...s detailId=..InsertDetail(mainId,oeori)
	q 0
}

/// description: 删除已存在的数据,避免重生数据时数据重复
ClassMethod DeleteExist(mOeori, prescNo)
{
	q:(mOeori="")&&(prescNo="") ""
	i mOeori'="" d
	.s oeori=mOeori
	.d DeletePHCNTSORDER
	.s ordItm=""
	.f  s ordItm=$o(^OEORDi(0,"OEORI",+mOeori,mOeori,ordItm)) q:ordItm=""  d
	..q:+ordItm=0
	..s oeori=+mOeori_"||"_ordItm
	..d DeletePHCNTSORDER	
	e  d
	.s ordId=""
	.f  s ordId=$o(^OEORD(0,"PrescNo",prescNo,ordId)) q:ordId=""  d
	..s ordItm=""
	..f  s ordItm=$o(^OEORD(0,"PrescNo",prescNo,ordId,ordItm)) q:ordItm=""  d
	...s oeori=ordId_"||"_ordItm
	...d DeletePHCNTSORDER	
	q ""
DeletePHCNTSORDER
	s phcoId=$o(^DHCPHCNTSORDER(0,"Oeori",oeori,""))
	i phcoId'="" d
	.&SQL(DELETE FROM DHC_PHCNTSORDER WHERE PHCO_RowId=:phcoId)
	q
}

/// creator:    yunhaibao
/// createdate: 2018-05-09
/// description:插入主数据
/// modal:		医生(i)/医生科室(i)/医嘱日期(i)/就诊类型(i)/处方类型(中西药)/药房(i)/费别(i)/处方金额(i)/年龄(数字)(i)/疗程(i)
/// input:		成组中任一医嘱Id
ClassMethod InsertMain(oeori)
{
	s errCode=""
	s ordId=+oeori
	s ordItm=$p(oeori,"||",2)
	s errCode=""
	s doctorId=$p($g(^OEORD(ordId,"I",ordItm,7)),"^",1) 				// ss_user
	//i docCpId'="" s doctorId=$o(^SSU("SSUSR",0,"CTPCP",docCpId,""))	// ss_user
	s docLocId=$p($g(^OEORD(ordId,"I",ordItm,1)),"^",3)					// ct_loc
	q:docLocId="" "-1^开单科室为空"
	s admId=$p(^OEORD(ordId),"^",1)
	s admType=$p(^PAADM(admId),"^",2)
	s patId=$p(^PAADM(admId),"^",1)									
	s recLocId=$p(^OEORD(ordId,"I",ordItm,3),"^",6)				// 接收科室
	s duration=""												// 疗程
	s ageYear=##class(web.DHCSTCNTSCOMMON).GetAgeYear(patId)	// 年龄(数字)
	s oeoriDate=$p(^OEORD(ordId,"I",ordItm,3),"^",7)		 	// 开单日期
	s admReasonId=$p($g(^OEORD(ordId,"I",ordItm,11)),"^",18)	// 费别
	s hospId=$p($g(^CTLOC(+docLocId)),"^",22)					// 院区
	s spAmt=0
	s arcItm=$p(^OEORD(ordId,"I",ordItm,1),"^",2) 
	s arcVer=$p(arcItm,"||",1),arcSub=$p(arcItm,"||",2)			// 金额-插入子表后更新
	s arcItmCatId=+$p(^ARCIM(arcVer,arcSub,1),"^",10)
	s ordCatId=$p($g(^ARC("IC",arcItmCatId)),"^",8)				// 医嘱大类
	&SQL(
		INSERT INTO DHC_PHCNTSORDER
		(
			PHCO_OrdDate,PHCO_Doctor_Dr,PHCO_DocLoc_Dr,PHCO_AdmType,PHCO_RecDep_Dr,
			PHCO_Hosp_Dr,PHCO_AdmReason_Dr,PHCO_Age,PHCO_SpAmt,PHCO_Dura_Dr,
			PHCO_OrdCat_Dr,PHCO_Adm_Dr
		)
		VALUES
		(
			:oeoriDate,:doctorId,:docLocId,:admType,:recLocId,
			:hospId,:admReasonId,:ageYear,:spAmt,:duration,
			:ordCatId,:admId
		)
	)
	i SQLCODE'=0 d
	.s errCode="-2^"_SQLCODE_":"_%msg 
	.s errMsgInfo="##class(web.DHCSTCNTS.Basic).InsertMain"
	.d ErrorRecord^DHCSTERROR("DHCSTCNTS",errMsgInfo,SQLCODE_":"_%msg)
	q:errCode'="" errCode
	q %ROWID
}

/// creator:    yunhaibao
/// createdate: 2018-05-09
/// description:插入子数据
/// input:		明细医嘱Id
ClassMethod InsertDetail(mainId, oeori)
{
	s errCode=""
	s ordId=+oeori
	s ordItm=$p(oeori,"||",2)
	s arcItm=$p(^OEORD(ordId,"I",ordItm,1),"^",2) 
	s arcVer=$p(arcItm,"||",1),arcSub=$p(arcItm,"||",2)
	s incId=$o(^INCI(0,"ARCIM_DR",arcVer,""))
	q:incId="" ""
 	s arcItmCatId=$p($g(^ARCIM(arcVer,arcSub,1)),"^",10)
 	// 过滤-非药品
 	q:$p($g(^ARC("IC",+arcItmCatId)),"^",7)'="R" ""
 	s phcdfId=$p(^ARCIM(arcVer,arcSub,1),"^",12)
 	s phcdId=+phcdfId
 	s phcdSub=+$p(phcdfId,"||",2)
	s poisonId=$p($g(^PHCD(phcdId,1)),"^",4)					// 管制分类
	s phcCatId=""		//$P($g(^PHCD(phcdId,"DF",phcdSub,"DHC")),"^",20) 	// 新药学分类
	s phcgeDr=$p($g(^PHCD(phcdId,4)),"^",1)		//MaYuqiang 20181218 医嘱结构改造后修改取药学分类方法
	s phcmId=$s(+phcgeDr'=0:$p($g(^PHCGE("GE",phcgeDr,"DHC")),"^",3),1:"")
	s:phcmId'="" phcCatId=$p(^DHCPHCM(phcmId),"^",3)
	s formId=$p($g(^PHCD(phcdId,"DF",phcdSub,1)),"^",1)			// 剂型
	s itmAdd=$o(^DHCITMINFO(0,"INCI",incId,""))
	s basicFlag=##class(web.DHCST.Common.DrugInfoCommon).GetBasicByPhcdf(phcdfId)		// 基本药物
	s oeoriDate=$p(^OEORD(ordId,"I",ordItm,3),"^",7)
	s docLocId=$p($g(^OEORD(ordId,"I",ordItm,1)),"^",3)			// 医生科室
	s hospId=$p($g(^CTLOC(+docLocId)),"^",22)					// 院区
	s admType=$p(^DHCPHCNTSORDER(mainId),"^",4)
	s spAmt=..GetOeoriSpAmt(oeori)
	s maxSub=$o(^DHCPHCNTSORDER(mainId,"I",""),-1)+1
	&SQL(
		INSERT INTO DHC_PHCNTSORDERITM 
		(	
			PHCOI_PHCO_PARREF,PHCOI_ChildSub,PHCOI_OrdDate,PHCOI_Arcim_Dr,PHCOI_Poison_Dr,
			PHCOI_PhcCat_Dr,PHCOI_Form_Dr,PHCOI_BasicFlag,PHCOI_Oeori_Dr,PHCOI_Hosp_Dr,
			PHCOI_AdmType,PHCOI_SpAmt
		)
		VALUES
		(
			:mainId,:maxSub,:oeoriDate,:arcItm,:poisonId,
			:phcCatId,:formId,:basicFlag,:oeori,:hospId,
			:admType,:spAmt
		)
	)
	i SQLCODE'=0 d
	.s errCode="-2^"_SQLCODE_":"_%msg 
	.s errMsgInfo="##class(web.DHCSTCNTS.Basic).InsertDetail"
	.d ErrorRecord^DHCSTERROR("DHCSTCNTS",errMsgInfo,SQLCODE_":"_%msg)
	q:errCode'="" errCode
	q %ROWID
}

/// description: 取主医嘱Rowid
ClassMethod GetMainOeori(oeori As %String) As %String
{
	q:oeori="" ""
 	s ord=$p(oeori,"||",1) q:ord="" ""
 	s chl=$p(oeori,"||",2) q:chl="" ""
 	q:'$d(^OEORD(ord,"I",chl,1)) ""
 	q:'$d(^OEORD(ord,"I",chl,11)) ""
 	s lnkOeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	q:lnkOeori'="" lnkOeori
 	q oeori
}

/// description: 获取医嘱金额,考虑医嘱改造
/// w ##class(web.DHCSTCNTS.Basic).GetOeoriSpAmt()
ClassMethod GetOeoriSpAmt(oeori)
{
	s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	q:dspId=0 0
	s spAmt=0
 	i $d(^DHCOEDISQTY(dspId,"I")) d	// 医嘱结构改造
	.s dspSub=0
	.f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
	..s dspSubData=^DHCOEDISQTY(dspId,"I",dspSub)
	..s dspIncId=$p(dspSubData,"^",5)	// 肯定有
	..s dspInclb=$p(dspSubData,"^",1)	// 批次价有
	..s dspIncQty=$p(dspSubData,"^",2)
	..s dspIncSp=$p(dspSubData,"^",4)
	..s dspSpAmt=dspIncSp*dspIncQty
	..s spAmt=spAmt+dspSpAmt
	e  d // 原始
	.s oeoriDate=$p(^OEORD(+oeori,"I",+$p(oeori,"||",2),3),"^",7)	// 以开单日期为准吧
	.i oeoriDate="" s oeoriDate=+$h-1
	.s arcItmId=$p(^OEORD(+oeori,"I",+$p(oeori,"||",2),1),"^",2) 
	.s incId=$o(^INCI(0,"ARCIM_DR",+arcItmId,""))
	.q:incId=""
	.s bUomId=$p(^INCI(incId,1),"^",10)
	.s recLocId=$p(^OEORD(+oeori,"I",+$p(oeori,"||",2),3),"^",6) 
	.q:+recLocId=0
	.s hospId=$p(^CTLOC(+recLocId),"^",22)
	.s sp=##class(web.DHCSTPRICE).GetSp(+incId,oeoriDate,bUomId,hospId,"","")
	.s qty=$p(^DHCOEDISQTY(dspId),"^",5)
	.s dspSpAmt=sp*qty
	.s spAmt=spAmt+dspSpAmt
	q spAmt
}

/// description: 新旧版本日期问题
ClassMethod DateHtmlToLogical(d As %String) As %String
{
	s $ZT="ErrFormat"
	Q:d="" ""
	Q:d?1n.n d
	S format = ..DateFormat()
	if d["-" Set format = 3
	if d["/" Set format = 4
	Q $zdh(d,format)
ErrFormat
	q d
}

ClassMethod DateFormat()
{
	s dateformat=$lg(^websys.ConfigurationD(1),10)
	s datesper=$lg(^websys.ConfigurationD(1),4)
	i (dateformat="DMY")&&(datesper="/") Quit 4
	i (dateformat="YMD")&&(datesper="-") Quit 3
	i (dateformat="MDY")&&(datesper="/") Quit 1
	Quit 4
}

/**********************初始化 Start**********************/
/// description: 按日期生成数据
/// input:		 stDate(开始日期),edDate(结束日期)
/// w ##class(web.DHCSTCNTS.Basic).InitData("2018-09-01","2018-10-15")
ClassMethod InitData(stDate, edDate)
{
	s stDate=$zdh(stDate,3)
	s edDate=$zdh(edDate,3)
	s calcuDate=""
	f calcuDate=stDate:1:edDate d
	.w $zd(calcuDate,3),!
	.d ..Build(calcuDate)
	q 0
}

/**********************初始化 End**********************/
}
