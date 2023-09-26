Import SQLUser

/// Descritpt:	取医嘱项相关信息(转自medsrc下的同名Mac)
/// Creater：	Zhouyg
/// CreateDate:	20130301 
Class web.DHCSTCOMMARC Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	根据库存项ID取医嘱项ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	医嘱项ID
ClassMethod GetArcim(InciDr As %String) As %String
{
 N (InciDr)
 Q:InciDr="" ""
 Q:'$D(^INCI(InciDr)) ""
 S ArcimDr=$P(^INCI(InciDr,1),"^",3)
 S Arcsub=$P(ArcimDr,"||",1)
 S Arcver=$P(ArcimDr,"||",2)
 Q:Arcsub="" ""
 Q:Arcver="" ""
 Q:'$D(^ARCIM(Arcsub,Arcver)) ""
 Q Arcsub_"||"_Arcver
}

/// Descript:	根据医嘱项ID取计价单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		ArcimDr-Arcim_rowid
/// Output:		Return
/// Return：	计价单位ID^计价单位描述
ClassMethod GetArcBuom(ArcimDr As %String) As %String
{
 N (ArcimDr)
 Q:ArcimDr="" ""
 S Arcsub=$P(ArcimDr,"||",1)
 S Arcver=$P(ArcimDr,"||",2)
 Q:Arcsub="" ""
 Q:Arcver="" ""
 Q:'$D(^ARCIM(Arcsub,Arcver)) ""
 S BillUomDr=$P(^ARCIM(Arcsub,Arcver,8),"^",14)
 Q:BillUomDr="" ""
 Q:'$D(^CT("UOM",BillUomDr)) ""
 S BillUomDesc=$P(^CT("UOM",BillUomDr),"^",2)
 Q BillUomDr_"^"_BillUomDesc
}

/// Descript:	根据库存项ID取计价单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	计价单位ID^计价单位描述
ClassMethod GetArcBuomByInc(InciDr As %String) As %String
{
 N (InciDr)
 Q:InciDr="" ""
 Q:'$D(^INCI(InciDr)) ""
 S ArcimDr=..GetArcim(InciDr)
 Q ..GetArcBuom(ArcimDr)
}

/// Descript:	根据医嘱项ID取医嘱分类
/// Creater:	Zhouyg
/// CreateDate:	20120326
/// Input:		ArcimDr-Arcim_rowid
/// Output:		Return
/// Return：	医嘱大类代码^医嘱大类描述^医嘱子类代码^医嘱子类描述
ClassMethod GetArcCatStr(ArcimDr As %String) As %String
{
 N (ArcimDr)
 Q:ArcimDr="" ""
 S Arcsub=$P(ArcimDr,"||",1)
 S Arcver=$P(ArcimDr,"||",2)
 Q:Arcsub="" ""
 Q:Arcver="" ""
 Q:'$D(^ARCIM(Arcsub,Arcver)) ""
 S ArcItemCatDr=$P(^ARCIM(Arcsub,Arcver,1),"^",10)
 Q:ArcItemCatDr="" ""
 S ItemCatCode=$p(^ARC("IC",ArcItemCatDr),"^",1)
 S ItemCatDesc=$p(^ARC("IC",ArcItemCatDr),"^",2)
 S (OrdCatCode,OrdCatDesc)=""
 S OrdCatDr=$p(^ARC("IC",ArcItemCatDr),"^",8)
 I OrdCatDr'="" D
 .S OrdCatCode=$p($g(^OEC("ORCAT",OrdCatDr)),"^",1)
 .S OrdCatDesc=$p($g(^OEC("ORCAT",OrdCatDr)),"^",2)
 S RetStr=OrdCatCode_"^"_OrdCatDesc_"^"_ItemCatCode_"^"_ItemCatDesc
 Q RetStr
}

/// Descript:	根据库存项ID取医嘱分类
/// Creater:	Zhouyg
/// CreateDate:	20120326
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	医嘱大类^医嘱子类
ClassMethod GetArcCatStrByInc(InciDr As %String) As %String
{
 N (InciDr)
 Q:InciDr="" ""
 Q:'$D(^INCI(InciDr)) ""
 S ArcimDr=..GetArcim(InciDr)
 Q ..GetArcCatStr(ArcimDr)
}

/// Descript:	根据库存项ID取医嘱分类
/// Creater:	Zhouyg
/// CreateDate:	20130301
/// Input:		ArcDr-Arc_ItmMast的rowid
/// Output:		Return
/// Return：	医嘱大类^医嘱子类
ClassMethod GetArcInfo(ArcID As %String) As %String
{
 N (ArcID)
 Q:ArcID="" ""
 S Arcsub=$P(ArcID,"||",1)
 S Arcver=$P(ArcID,"||",2)
 Q:Arcsub="" ""
 Q:Arcver="" ""
 Q:'$D(^ARCIM(Arcsub,Arcver)) ""
 s ArcCode=$p(^ARCIM(Arcsub,Arcver,1),"^",1)
 s ArcStr1=ArcCode
 s ArcStr=ArcStr1
 q ArcStr
}

/// Descript:	根据药学项ID取医嘱项ID
/// Creater:	Zhouyg
/// CreateDate:	20130329
/// Input:		PhcfDr-PHC_DrgMast的rowid
/// Output:		Return
/// Return：	医嘱项ID
ClassMethod GetArcIDByPhcf(PhcfID As %String) As %String
{
 n (PhcfID)
 q:PhcfID="" ""
 s Arcsub=$o(^ARCIM(0,"PHCDF",PhcfID,""))
 q:Arcsub="" ""
 s Arcver=$o(^ARCIM(0,"PHCDF",PhcfID,Arcsub,""))
 q:Arcver="" ""
 q:'$d(^ARCIM(Arcsub,Arcver)) ""
 s ArcID=Arcsub_"||"_Arcver
 q ArcID
}

}
