Import User

Class DHCBP.ArrangeExtend Extends %RegisteredObject
{

// w ##class(DHCBP.ArrangeExtend).Save(17150,"NurAssessmentDeepVeinSituation","导管拔出","",830)

ClassMethod Save(arrangeId, code, value, note, userId)
{
	s id=$$Find(arrangeId)
	if (id=""){
		s obj=##class(User.DHCBPArrangeExtend).%New()
		s obj.BPAEBPADr=arrangeId
	}
	else{
		s obj=##class(User.DHCBPArrangeExtend).%OpenId(id)
	}
	s obj.BPAENote=note
	s obj.BPAEValue=value
	s obj.BPAEUpdateDate=+$h
	s obj.BPAEUpdateTime=$p($h,",",2)
	s obj.BPAEUserDr=userId
	s obj.BPAEBPCAECode=code
	d obj.%Save()
	q obj.%Id()
	
Find(arrangeId)
   s id=""
   s id=$o(^DHCBPArrangeExtend(0,"BPACode",arrangeId,code,""))
   //&sql(select ID into:id 
   //from DHC_BP_ArrangeExtend
   //where BPAE_BPA_Dr=:arrangeId and BPAE_BPCAECode=:code)
   q id
}

// w ##class(DHCBP.ArrangeExtend).Get(17157,"NurAssessmentWoundAppearanceAbnormal")

ClassMethod Get(arrangeId, code)
{
	s ^tempby("DHCBP.NursingAssessment1")=arrangeId_"^"_code
	q:code="" "1"
	q:arrangeId="" "2"
	s res=""
	s rowId=$O(^DHCBPArrangeExtend(0,"BPACode",arrangeId,code,""))
	
	q:rowId="" ""
	s extend=##class(User.DHCBPArrangeExtend).%OpenId(rowId)
	if (extend.BPAEValue'=""){
		s res=extend.BPAEValue
	}
	else {
		s res=extend.BPAENote
	}
	q res
}

}
