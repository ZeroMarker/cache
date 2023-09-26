/// CTOR: QP
/// DATE: 2020-09-009
/// DESC: 翻译指标值
Class DHCDoc.GCPSW.CFG.Translate Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 性别
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Translate).Sex(1)
ClassMethod Sex(id As %String)
{
	s mRtn=""
	Q:id="" mRtn
	s mRtn=$p(^CT("SEX",id),"^",2)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 诊断
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Translate).Diagnosis(1)
ClassMethod Diagnosis(ids As %String)
{
	s mRtn=""
	Q:ids="" mRtn
	f i=1:1:$l(ids,",") {
		s cid=$p(ids,",",i)	
		i '$d(^MRC("ID",cid)) {
			i mRtn="" s mRtn=cid
			e  s mRtn=mRtn_","_cid
		} else {
			s desc=$p(^MRC("ID",cid),"^",2)
			i mRtn="" s mRtn=desc
			e  s mRtn=mRtn_","_desc
		}
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-10
/// DESC: 诊断信息
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Translate).DiagnosisInfo("15888,16625,16396,kk,哈哈")
ClassMethod DiagnosisInfo(ids As %String)
{
	s mRtn=""
	Q:ids="" mRtn
	f i=1:1:$l(ids,",") {
		s cid=$p(ids,",",i)	
		i '$d(^MRC("ID",cid)) {
			s record=cid_"^NOICD"
			i mRtn="" s mRtn=record
			e  s mRtn=mRtn_"!"_record
		} else {
			s desc=$p(^MRC("ID",cid),"^",2)
			s record=desc_"^"_cid
			i mRtn="" s mRtn=record
			e  s mRtn=mRtn_"!"_record
		}
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-10
/// DESC: 入选检验/排查检验
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Translate).Lis("5||2,5||3,5||4,5||5,5||1")
ClassMethod Lis(ids As %String)
{
	s mRtn=""
	Q:ids="" mRtn
	f i=1:1:$l(ids,",") {
		s cid=$p(ids,",",i)	
		s KTID=+cid
		s SUB=$P(cid,"||",2)
		s desc=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",SUB),"^",2)
		i mRtn="" s mRtn=desc
		e  s mRtn=mRtn_","_desc
	}
	Q mRtn
}

}
