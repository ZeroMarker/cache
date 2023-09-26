/// CTOR: QP
/// DATE: 2020-06-28
/// DESC: 化疗单
Class DHCDoc.Chemo.BS.AdmLink Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-06-28
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.AdmLink).Save("")
ClassMethod Save(PLID, AdmID)
{
	s mRtn=0
	s hasAdm=..HasAdm(PLID, AdmID)
	q:hasAdm=1 mRtn
	s a=##class(User.ChemoPlanAdmLink).%New()
	d a.PAAdmIDSetObjectId(AdmID)
	d a.PAPLIDSetObjectId(PLID)
	s sc=a.%Save()
	if ($$$ISERR(sc)) {
		s mRtn=-127
	} else {
		s mRtn=a.%Id()
	}
	d a.%Close()
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-06-28
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.AdmLink).Save("")
ClassMethod HasAdm(PLID, AdmID)
{
	s mRtn=0
	
	i $d(^BS.DOC.Chemo.PlanAdmLinkI("PLIDAdmID",PLID,AdmID)) s mRtn=1
	
	Q mRtn
}

}
