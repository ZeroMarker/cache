/// CTOR: QP
/// DATE: 2019-10-11
/// DESC: 申请单查询
Class DHCAnt.KSS.Extend.FindApply Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2019-10-11
/// DESC: 查询申请信息
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Extend.FindApply).GetApplyInfo("2377")
ClassMethod GetApplyInfo(aaid As %String)
{
	n (aaid)
	s isEmergency=$p(^DHCDAA("ANT",aaid,1),"^",23)
	s EmergecyReason=$p(^DHCDAA("ANT",aaid,1),"^",32)
	s mRtn=isEmergency_$C(1)_EmergecyReason
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-10-11
/// DESC: 查询会诊信息
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Extend.FindApply).GetConsultInfo("2377")
ClassMethod GetConsultInfo(AppRowid As %String)
{
	n (AppRowid)
	s Consultdep1=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",4)
	s Consultdep2=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",27)
	s Consultdep3=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",30)
	s Consultdoc1=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",5)
	s Consultdoc2=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",28)
	s Consultdoc3=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",31)
	
	q Consultdep1_"^"_Consultdep2_"^"_Consultdep3_"^"_Consultdoc1_"^"_Consultdoc2_"^"_Consultdoc3
}

/// CTOR: QP
/// DATE: 2019-10-11
/// DESC: 查询会诊备注
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Extend.FindApply).GetConsultReamrk("2377")
ClassMethod GetConsultReamrk(AppRowid As %String)
{
	n (AppRowid)
	s mRtn=$g(^DHCDAA("ANT","ExtendPara",AppRowid))
	
	q mRtn
}

}
