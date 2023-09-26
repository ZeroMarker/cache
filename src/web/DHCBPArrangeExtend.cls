Class web.DHCBPArrangeExtend Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// w ##class(web.DHCBPArrangeExtend).SaveArrangeExtend(554,"","")
ClassMethod SaveArrangeExtend(arrangeId, paraStr, userId) As %String
{
	//s ^TMPzt("ArrangeExtend")=paraStr_"/"_userId_"/"_arrangeId
    //s paraStr=$p(^TMPzt("ArrangeExtend"),"/",1)
    //s userId=$p(^TMPzt("ArrangeExtend"),"/",2)
	q:arrangeId="" "-1^arrangeId is null"
	q:userId="" "-2^userId is null"	
	s result=""
	TSTART
	f i=1:1:$l(paraStr,"^") q:+result<0  d
	.s para=$p(paraStr,"^",i)
	.q:para=""
	.s code=$p(para,$c(3),1)
	.s value=$p(para,$c(3),2)
	.s note=$p(para,$c(3),3)
	.i code'="" d
	..s rowId=$o(^DHCBPC("BusinessFieldExtend",0,"Code",code,""))
	..i rowId'="" d
	...s result=..SaveSingleArrangeExtend(arrangeId,code,value,note,userId)
	..e  s result="-5 "_code_"属性不存在"
	b ;2
	i +result<0 TROLLBACK  q result 	
	TCOMMIT
	q 1
}

ClassMethod SaveSingleArrangeExtend(arrangeId, code, value, note, userId)
{
	q:arrangeId="" "-1^arrangeId is null"
	q:userId="" "-2^userId is null"
	q:code="" "-3^code is null"

	s date=+$h,time=$p($h,",",2)
	s preValue=""
	s extendRowId=$o(^DHCBPArrangeExtend(0,"BPACode",arrangeId,code,"")) 
	i extendRowId="" s obj=##class(User.DHCBPArrangeExtend).%New()
	e  d
	.s obj=##class(User.DHCBPArrangeExtend).%OpenId(extendRowId)
	.s preValue=obj.BPAEValue
	
	q:preValue=value extendRowId  //值不改变的 不保存
	
	s obj.BPAEBPCAECode=code
	s obj.BPAEBPADr=arrangeId
	s obj.BPAEValue=value
	s obj.BPAENote=note
	s obj.BPAEUserDr=userId
	s obj.BPAEUpdateDate=date
	s obj.BPAEUpdateTime=time
	s obj.BPAEPreValue=preValue
	
	s saveStatus=obj.%Save()
	q:(+saveStatus=0) "-4^数据保存失败!"_code
	s rowId=obj.%Id()
	d obj.%Close()
	q rowId
}

ClassMethod GetArrangeExtendValue(arrangeId, code) As %String
{
	q:arrangeId="" ""
	q:code="" ""
	s retStr=""
	s extendId=$o(^DHCBPArrangeExtend(0,"BPACode",arrangeId,code,""))
	q:extendId="" ""
	s userId=$li(^DHCBPArrangeExtend(extendId),2)
	s userDesc=##class(web.DHCClinicCom).GetUserTypeName(userId)
	s userDesc=$p(userDesc,"^",2)
	s date=$li(^DHCBPArrangeExtend(extendId),3)
	s time=$li(^DHCBPArrangeExtend(extendId),4)
	s value=$li(^DHCBPArrangeExtend(extendId),6)
	s prevalue=$li(^DHCBPArrangeExtend(extendId),7)
	s note=$li(^DHCBPArrangeExtend(extendId),8)
	
	s date=##class(web.DHCClinicCom).ConvertToDateH(date,$H)
	s time=##class(web.DHCClinicCom).ConvertToTimeH(time,$H)
		
	s retStr=value_$c(3)_prevalue_$c(3)_userId_$c(3)_date_$c(3)_time_$c(3)_note_$c(3)_userDesc
	q retStr
}

}
