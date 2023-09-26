Class web.DHCHM.CQDOLinkDetail Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCHM.CQDOLinkDetail).Update("1||1","","")
ClassMethod Update(ParRef, ID, LinkDetailID)
{
	i ID="" d
	.s obj=##class(User.DHCHMCQDOLinkDetail).%New()
	.d obj.QDOLParRefSetObjectId(ParRef)
	e  d
	..s obj=##class(User.DHCHMCQDOLinkDetail).%OpenId(ID)
	d obj.QDOLCSDLinkIDSetObjectId(LinkDetailID)
	s sc=obj.%Save()
	s ret="0^更新成功"
	s:$$$ISERR(sc) ret="-100^"_$System.Status.GetErrorText(sc)
	q ret
}

ClassMethod Detele(ID)
{
	&SQL(Delete From Sqluser.DHCHMCQDOLinkDetail where ID=:ID)
	q SQLCODE
}

ClassMethod GetParRefDesc(ParRefID)
{
	s obj=##class(User.DHCHMCQDOptions).%OpenId(ParRefID)
	s Desc=obj.QDODesc
	s ParDesc=obj.QDOParRef.QDDesc
	q ParDesc_"^"_Desc
}

/// d ##class(%ResultSet).RunQuery("web.DHCHM.CQDOLinkDetail","LinkDetail")
Query LinkDetail(DetailDesc As %String = "") As %SQLQuery(ROWSPEC = "QDesc:%String,QSDesc:%String,QDDesc:%String,DOLID:%String")
{
	
	SELECT SDLParRef->QSParRef->Q_Desc,SDLParRef->QS_Desc,SDLQuestionsDetailDR->QD_Desc,ID FROM Sqluser.DHC_HM_CSDLink where SDLQuestionsDetailDR->QD_Desc like '%'_:DetailDesc_'%' Or :DetailDesc IS null
}

Query CQDOLinkDetail(ParRef As %String = "") As %SQLQuery(ROWSPEC = "TID:%String,TLinkDetailID:%String,TQuestionName:%String,TDetailDesc:%String")
{
SELECT ID,QDOL_CSDLinkID,QDOL_CSDLinkID->SDLParRef->QSParRef->Q_Desc,QDOL_CSDLinkID->SDLQuestionsDetailDR->QD_Desc FROM Sqluser.DHCHMCQDOLinkDetail where QDOLParRef = :ParRef
}

}
