/// Description：健康问卷 问诊逻辑类
/// Creator：wangguoying
Class web.DHCPE.HM.Inquiry Extends %RegisteredObject
{

/// Description: 问诊类型Query
/// Input:
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2021-05-08
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.HM.Inquiry","QueryType","","") 
Query QueryType(Code As %Library.String = "", Desc As %Library.String = "") As websys.Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TSort:%String") [ SqlProc ]
{
}

ClassMethod QueryTypeExecute(ByRef qHandle As %Binary, Code As %Library.String = "", Desc As %Library.String = "") As %Status
{
 	s:Code'="" Code = $$ALPHAUP^SSUTIL4(Code)
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s sort = ""
 	f  s sort = $O(^User.DHCHMInquiryTypeI("SortIndex",sort))  q:sort=""  d
 	.s id = ""
 	.f  s id = $O(^User.DHCHMInquiryTypeI("SortIndex",sort,id))  q:id=""  d
 	..s code = $lg(^User.DHCHMInquiryTypeD(id),2)
 	..q:(Code'="")&&(Code'=$$ALPHAUP^SSUTIL4(code))
 	..s desc = $lg(^User.DHCHMInquiryTypeD(id),3)
 	..q:(Desc'="")&&(desc'[Desc)
	..d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRowData
    set Data=$lb(id,code,desc,sort)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Description: 问诊结果Query
/// Input:
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2021-05-08
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.HM.Inquiry","QueryResult","1","") 
Query QueryResult(ParRef As %Library.String = "", Code As %Library.String = "", Desc As %Library.String = "") As websys.Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TSort:%String,TClassName:%String,TMethodName:%String,TDetailID:%String,TIntroduce:%String,TAdvice:%String,TRemark:%String") [ SqlProc ]
{
}

ClassMethod QueryResultExecute(ByRef qHandle As %Binary, ParRef As %Library.String = "", Code As %Library.String = "", Desc As %Library.String = "") As %Status
{
 	s:Code'="" Code = $$ALPHAUP^SSUTIL4(Code)
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ParRef=""
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s sort = ""
 	f  s sort = $O(^User.DHCHMInquiryResultI("SortIndex",ParRef,sort))  q:sort=""  d
 	.s sub = ""
 	.f  s sub = $O(^User.DHCHMInquiryResultI("SortIndex",ParRef,sort,sub))  q:sub=""  d
 	..s code = $lg(^User.DHCHMInquiryTypeD(ParRef,"ITResult",sub),2)
 	..q:(Code'="")&&(Code'=$$ALPHAUP^SSUTIL4(code))
 	..s desc = $lg(^User.DHCHMInquiryTypeD(ParRef,"ITResult",sub),3)
 	..q:(Desc'="")&&(desc'[Desc)
 	..s clsName = $lg(^User.DHCHMInquiryTypeD(ParRef,"ITResult",sub),5)
 	..s methodName = $lg(^User.DHCHMInquiryTypeD(ParRef,"ITResult",sub),6)
 	..s introduce = "" , advice = "",remark="", detaiId = ""
 	..s detailSub = $O(^User.DHCHMInquiryTypeD(ParRef,"ITResult",sub,"IRDetail",""))  //目前考虑父子表一对一
 	..i detailSub'=""  d
 	...s detaiId = ParRef_"||"_sub_"||"_detailSub
 	...s detailObj = ##class(User.DHCHMInquiryResultDetail).%OpenId(detaiId)
 	...s introduce = detailObj.IRDIntroduce
 	...s stream = detailObj.IRDAdvice
 	...s:stream'="" advice = stream.Read()
 	...s remark = detailObj.IRDRemark
	..d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRowData
    set Data=$lb(ParRef_"||"_sub,code,desc,sort,clsName,methodName, detaiId, introduce,advice,remark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Description: 问诊结果与调查问卷问题关联
/// Input:
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2021-05-11
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.HM.Inquiry","QueryDetailRelate","1||1","") 
Query QueryDetailRelate(IRID As %String = "", DetailDR As %String = "") As websys.Query(ROWSPEC = "TRowID:%String,TDetailId:%String,TDetailDesc:%String,TDetailType:%String,TDetailSex:%String,TDetailUnit:%String,TDetailRemark:%String,TExpression:%String")
{
}

ClassMethod QueryDetailRelateExecute(ByRef qHandle As %Binary, IRID As %String = "", DetailDR As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	
 	i IRID=""
 	{
	 	s qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	i DetailDR'=""
 	{
	 	s id=0
	 	f  s sub=$O(^User.DHCHMInquiryQuesRelateI("ResultDetailIndex",IRID,DetailDR,id)) q:id=""  d
	 	.d BuildQDetailData
 	}else{
 		s detailId=""
 		f  s detailId=$O(^User.DHCHMInquiryQuesRelateI("ResultDetailIndex",IRID,detailId))  q:detailId=""  d
 		.s id=0
	 	.f  s id=$O(^User.DHCHMInquiryQuesRelateI("ResultDetailIndex",IRID,detailId,id)) q:id=""  d
 		..d BuildQDetailData
 	}	
 	s qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildQDetailData
	s obj=##class(User.DHCHMInquiryQuesRelate).%OpenId(id)
	s Active=obj.IQRQustionDetailDR.QDActive
	q:Active'="Y"
	s TDetailId=obj.IQRQustionDetailDR.%Id()
	s TDetailDesc=obj.IQRQustionDetailDR.QDDesc
	s TDetailType=obj.IQRQustionDetailDR.QDType
	s TDetailSex=obj.IQRQustionDetailDR.QDSex
	s TDetailUnit=obj.IQRQustionDetailDR.QDUnit
	s TDetailRemark=obj.IQRQustionDetailDR.QDRemark
	s TExpression=obj.IQRExpression
	s Data=$lb(id,TDetailId,TDetailDesc,TDetailType,TDetailSex,TDetailUnit,TDetailRemark,TExpression)
	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

/// Description: 问诊结果与调查问卷问题选项关联
/// Input:
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2021-05-11
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.HM.Inquiry","QueryQDOption","3") 
Query QueryQDOption(LinkDetailDR As %String = "") As websys.Query(ROWSPEC = "TOPTID:%String,TOptionId:%String,TOptionDesc:%String,TOptionSex:%String")
{
}

ClassMethod QueryQDOptionExecute(ByRef qHandle As %Binary, LinkDetailDR As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1	
 	i LinkDetailDR=""
 	{
	 	s qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s optionId=0
 	f  s optionId=$O(^User.DHCHMInquiryOptionRelateI("ParRefOptionIndex",LinkDetailDR,optionId))  q:optionId=""  d
 	.s sub=0
	.f  s sub=$O(^User.DHCHMInquiryOptionRelateI("ParRefOptionIndex",LinkDetailDR,optionId,sub)) q:sub=""  d
	..d BuildOptionData
 	s qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildOptionData
	s id=LinkDetailDR_"||"_sub
	s obj=##class(User.DHCHMInquiryOptionRelate).%OpenId(id)
	s Active=obj.IOROptionDR.QDOActive
	q:Active'="Y"
	s TOptionId=obj.IOROptionDR.%Id()
	s TOptionDesc=obj.IOROptionDR.QDODesc
	s TOptionSex=obj.IOROptionDR.QDOSex
	s Data=$lb(id,TOptionId,TOptionDesc,TOptionSex)
	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

/// Descript:输出问诊结果关键字列表
/// Input:
/// 				EQID： DHC_HM_OQEQuestion
/// Return: 
/// Creater:	wangguoying
/// CreateDate:	2021-05-143
/// Debug: w ##class(web.DHCPE.HM.Inquiry).OutInquiryKeys(7656,1)
ClassMethod OutInquiryKeys(RetObj As HS.Entity.SurveyConclusion, Index As %Integer)
{
	//s RetObj = ##class(HS.BL.ExamSurvey).GetSurveyConslusionObj("76||114")
	w "<div id='Keys"_Index_"'  class='hisui-keywords' data-options='{"
	w "singleSelect:true,"
	//w "labelCls:""red"","
	w "items:["
	s typeObj = RetObj.ConclusionTypes.GetAt(Index)
	s len = typeObj.Conclusions.Count()
	f num=1:1:len  d
	.s conclusionsObj = typeObj.Conclusions.GetAt(num)
	.w "{text:"""_conclusionsObj.Desc_""",id:"""_$Replace(conclusionsObj.ID,"||","_")_"""}"
	.w:num<len ","
	w "],"
    w "onClick:function(v){keywords_click(v,"_Index_");}"	
	w " }'>" 
	w "</div>"
	q ""
}

ClassMethod GetInquiryDetail(ResultID)
{
	s detailSub = $O(^User.DHCHMInquiryTypeD(+ResultID,"ITResult",$P(ResultID,"||",2),"IRDetail",""))
	q:detailSub="" ""
	s obj = ##class(User.DHCHMInquiryResultDetail).%OpenId(ResultID_"||"_detailSub)
	//s ^tmpwgy(1)=obj.IRDAdvice.Read()
	q obj.IRDIntroduce_$C(0)_obj.IRDAdvice.Read()_$C(0)_obj.IRDRemark
}

}
