Class web.DHCENS.STBLL.RIS.METHOD.Common Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2019—11-14
/// Description：获取系统类型,通过新产品组检查分类维护界面维护
/// Table：DHC_AppArcCat
/// Input： 医嘱rowid
/// w ##Class(web.DHCENS.STBLL.RIS.METHOD.Common).GetSystemType("96||48")
ClassMethod GetSystemType(GstOEORowid As %String) As %String
{
	s (itmArcCatDesc,HospitalDR)=""
	s GstOrderID=$p(GstOEORowid,"||",1)
	s GstOrdItemChildSub=$p(GstOEORowid,"||",2)
	s arcimid=$p(^OEORD(GstOrderID,"I",GstOrdItemChildSub,1),"^",2)
	s ExecLocID=$p(^OEORD(GstOrderID,"I",GstOrdItemChildSub,3),"^",6)   // 获得执行科室
	s HospitalDR=$p(^CTLOC(ExecLocID),"^",22)   // 医院指针
	// 通过配置获取
	q:arcimid="" ""
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s itemCatID=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)   ///医嘱子类
	s itmArcCatID="" f  s itmArcCatID=$o(^DHCAPARCCA(0,"O",itemCatID,itmArcCatID)) q:(itmArcCatID="")  d
	.q:(HospitalDR'="")&($p(^DHCAPARCCA(itmArcCatID),"^",4)'=HospitalDR)
	.//s itmArcCatCode=$p(^DHCAPARCCA(itmArcCatID),"^",1)  	/// 检查分类代码
	.s itmArcCatDesc=$p(^DHCAPARCCA(itmArcCatID),"^",2)  	/// 检查分类描述
	
	q:itmArcCatDesc="" ""
	q:(itmArcCatDesc="超声")!(itmArcCatDesc["超")!(itmArcCatDesc["多普勒") "US"
	q:(itmArcCatDesc="内镜")!(itmArcCatDesc["镜") "ES"
	q:(itmArcCatDesc="心脑电") "EKG"
	q:(itmArcCatDesc="病理")!(itmArcCatDesc="细胞申请")!(itmArcCatDesc="TCT申请")!(itmArcCatDesc="HPV申请")!(itmArcCatDesc="HPV申请")!(itmArcCatDesc["外院申请")!(itmArcCatDesc="分子病理")!(itmArcCatDesc="尸检申请")!(itmArcCatDesc["活体申请") "PIS"
	q "PACS"
}

}
