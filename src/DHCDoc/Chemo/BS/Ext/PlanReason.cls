/// CTOR: QP
/// DATE: 2020-07-16
/// DESC: 化疗变更原因
Class DHCDoc.Chemo.BS.Ext.PlanReason Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-07-01
/// DESC: 保存
/// IN  : 	
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.PlanReason).Save("")
ClassMethod Save(PRAry)
{
	s mRtn=0
	s PRNum=$o(PRAry(""),-1)
	Q:PRNum="" mRtn
	s ID=PRAry(1)
	i ID="" {
		s a=##class(User.ChemoPlanReason).%New()
	} else{
		s a=##class(User.ChemoPlanReason).%OpenId(ID)
	}
	Q:'$ISObject(a) -131
	d a.PRPGIDSetObjectId(PRAry(2))
	d a.PRPIIDSetObjectId(PRAry(3))
	s a.PRAction=PRAry(4)
	d a.PRPatientIDSetObjectId(PRAry(5))
	d a.PRAdmIDSetObjectId(PRAry(6))
	d a.PRArcimSetObjectId(PRAry(7))
	d a.PRReasonDRSetObjectId(PRAry(8))
	d a.PRUserSetObjectId(PRAry(9))
	d a.PRLocSetObjectId(PRAry(10))
	d a.PRPSIDSetObjectId(PRAry(11))
	s a.PRDate=+$H
	s a.PRTime=$p($h,",",2)
	s sc=a.%Save()
	if ($$$ISERR(sc)) {
		//d $System.Status.DisplayError(sc)
		s mRtn=-131
	} else {
		s mRtn=a.%Id()
	}
	d a.%Close()
	
	Q mRtn
}

}
