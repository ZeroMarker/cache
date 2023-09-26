Class web.DHCENS.STBLL.DOCU.METHOD.GetReportUrl Extends (%RegisteredObject, %XML.Adaptor)
{

/// 获取文档注册接口第三方返回连接
/// w ##Class(web.DHCENS.STBLL.DOCU.METHOD.GetReportUrl).GetReportUrl("114586||15")
ClassMethod GetReportUrl(OrdId As %String) As %String
{
	set $ztrap="Exception"
	i OrdId["^" s OrdId=$p(OrdId,"^",1)
	s myOEORI=$p(OrdId,"||",1)
	s ReLoc=$p($g(^OEORD(+myOEORI,"I",+$p(OrdId,"||",2),3)),"^",6)
	i ReLoc=281 s OrdId=..GetOrdRowIDByPatRowID(OrdId) ;2019-11-11 医嘱接收科室为检验科
	q:OrdId="" ""
	set Url=""
	set RelODDocumentID=""
	for  set RelODDocumentID=$o(^Busi.ENS.EnsRelOrderDocumentI("RelODOrderItemIDIndex",OrdId,"pdf",RelODDocumentID)) q:RelODDocumentID=""  d
	.set DocumentID=$lg(^Busi.ENS.EnsRelOrderDocumentD(RelODDocumentID),2)
	.if DocumentID'=""   d
	..set HosDocumentID=""
	..set HosDocumentID=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTPKey",DocumentID,HosDocumentID))
	..set:HosDocumentID'="" Url=$lg(^Busi.ENS.EnsHOSDocumentD(HosDocumentID),19)
	q Url
Exception
	q "-1"_$ze
}

/// 获取文档注册接口报告日期
/// w ##Class(web.DHCENS.STBLL.DOCU.METHOD.GetReportUrl).GetReportDate("16465||2^16465||3^16465||4^16465||6^16465||1")
ClassMethod GetReportDate(OrdId As %String) As %String
{
	set $ztrap="Exception"
	set HOSDUpdateDate=""
	set RelODDocumentID=""
	i OrdId["^" s OrdId=$p(OrdId,"^",1)
	s OrdId=..GetOrdRowIDByPatRowID(OrdId)
	q:OrdId="" ""
	for  set RelODDocumentID=$o(^Busi.ENS.EnsRelOrderDocumentI("RelODOrderItemIDIndex",OrdId,"pdf",RelODDocumentID)) q:RelODDocumentID=""  d
	.set DocumentID=$lg(^Busi.ENS.EnsRelOrderDocumentD(RelODDocumentID),2)
	.if DocumentID'=""   d
	..set HosDocumentID=""
	..set HosDocumentID=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTPKey",DocumentID,HosDocumentID))
	..set:HosDocumentID'="" HOSDUpdateDate=$lg(^Busi.ENS.EnsHOSDocumentD(HosDocumentID),15)
	s:HOSDUpdateDate'="" HOSDUpdateDate=$zd(HOSDUpdateDate,3)
	q HOSDUpdateDate
Exception
	q "-1^"_$ze
}

/// 检验合管医嘱，界面获取不到链接，所传医嘱号应为^拼接之后的
/// 根据单条医嘱号返回第三方回传的医嘱号串
/// w ##Class(web.DHCENS.STBLL.DOCU.METHOD.GetReportUrl).GetOrdRowIDByPatRowID("16465||1")
ClassMethod GetOrdRowIDByPatRowID(ordrowid As %String) As %String
{
	s $zt="Exception"
	s ord=$p(ordrowid,"||",1)
	s sub=$p(ordrowid,"||",2)
	s RelODVisitNumber=$p(^OEORD(ord),"^",1) //就诊号
	s RelODPatientID=$P(^PAADM(RelODVisitNumber),"^",1) //基本信息表rowID
	s ordstr3=$g(^OEORD(ord,"I",sub,3))
	s RelODSpecimenID=$p(ordstr3,"^",36)  //扫码推送信息，第三方返回的条码号
	i RelODSpecimenID="" s RelODSpecimenID=##class(Nur.DHCNurLisBarPrintInfo).getLabNoByOrdId(ordrowid) ;wxl2019-10-07
	q:RelODSpecimenID="" ""

	//Index INDEXODSPECIMENID On (RelODPatientID, RelODVisitNumber, RelODSpecimenID)
	s RelODDocumentID=""
	set RelODDocumentID=$o(^Busi.ENS.EnsRelOrderDocumentI("INDEXODSPECIMENID",RelODPatientID,RelODVisitNumber,RelODSpecimenID,RelODDocumentID)) 
	q:RelODDocumentID="" ""
	set OrdRowIDStr=$lg(^Busi.ENS.EnsRelOrderDocumentD(RelODDocumentID),6) //如果合管，医嘱串
	q OrdRowIDStr
Exception
    q "-1^"_$ze
}

/// 获取当前报告相关状态
/// w ##Class(web.DHCENS.STBLL.DOCU.METHOD.GetReportUrl).GetStatusDescByOrdItem("1112||21")
ClassMethod GetStatusDescByOrdItem(Orditem As %String) As %String
{
	s $zt="Exception"
	//IndexESOrdItemID
	s id=""
	s id=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_Orditem,id),-1)
	q:id="" ""

	s statusCode=$lg(^Busi.ENS.EnsStatusLogD(id),11)
	s statusid=""
	s statusid=$o(^Code.ENS.EnsStatusCodeI("IndexESCCode",statusCode,statusid))
	q:statusid="" ""
	s statusDesc=$lg(^Code.ENS.EnsStatusCodeD(statusid),9)
	q statusDesc
	
Exception
	q "-1^"_$ze
}

}
