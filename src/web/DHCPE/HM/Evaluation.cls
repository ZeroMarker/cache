/// Description：评估内容与调查问卷关联关系
/// Creator：wangguoying
Class web.DHCPE.HM.Evaluation Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HM.Evaluation","QueryQDetail",1)
Query QueryQDetail(EvaluationDR As %String = "", DetailDR As %String = "") As websys.Query(ROWSPEC = "TRowID:%String,TDetailId:%String,TDetailDesc:%String,TDetailType:%String,TDetailSex:%String,TDetailUnit:%String,TDetailRemark:%String,TScore:%String,TExpression:%String")
{
}

ClassMethod QueryQDetailExecute(ByRef qHandle As %Binary, EvaluationDR As %String = "", DetailDR As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	
 	i EvaluationDR=""
 	{
	 	s qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	i DetailDR'=""
 	{
	 	s id=0
	 	f  s id=$O(^User.DHCHMEvaluationLinkDetailI("EvaluationDetailIndex",EvaluationDR,DetailDR,id)) q:id=""  d
	 	.d BuildQDetailData
 	}else{
 		s detailId=""
 		f  s detailId=$O(^User.DHCHMEvaluationLinkDetailI("EvaluationDetailIndex",EvaluationDR,detailId))  q:detailId=""  d
 		.s id=0
	 	.f  s id=$O(^User.DHCHMEvaluationLinkDetailI("EvaluationDetailIndex",EvaluationDR,detailId,id)) q:id=""  d
 		..d BuildQDetailData
 	}	
 	s qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildQDetailData
	s obj=##class(User.DHCHMEvaluationLinkDetail).%OpenId(id)
	s Active=obj.ELDQustionDetailDR.QDActive
	q:Active'="Y"
	s TDetailId=obj.ELDQustionDetailDR.%Id()
	s TDetailDesc=obj.ELDQustionDetailDR.QDDesc
	s TDetailType=obj.ELDQustionDetailDR.QDType
	s TDetailSex=obj.ELDQustionDetailDR.QDSex
	s TDetailUnit=obj.ELDQustionDetailDR.QDUnit
	s TDetailRemark=obj.ELDQustionDetailDR.QDRemark
	s TScore=obj.ELDScore
	s TExpression=obj.ELDExpression
	s Data=$lb(id,TDetailId,TDetailDesc,TDetailType,TDetailSex,TDetailUnit,TDetailRemark,TScore,TExpression)
	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

/// Descript:更新问卷基本内容
/// Input:
/// 					ID:DHC_PE_EvaluationLinkDetail
/// 					ValueStr:ELDEvaluationDR^ELDQustionDetailDR^ELDScore^ELDExpression^ELDUpdateUserDR
/// Return: >0：成功 , -1：失败
/// Creater:	wangguoying
/// CreateDate:	2020-04-23
/// Debug: w ##class(web.DHCPE.HM.Evaluation).UpdateQDetail("","1^5^^d^11849")
ClassMethod UpdateQDetail(ID As %String = "", ValueStr As %String)
{
	s ^tmpwgy("UpdateQDetail")=$LB(ID,ValueStr)
	s nodeStr="ELDEvaluationDR^ELDQustionDetailDR^ELDScore^ELDExpression^ELDUpdateUserDR^ELDUpdateDate^ELDUpdateTime"
	s curDate=+$H
	s curTime=$P($H,",",2)
	s ValueStr=ValueStr_"^"_curDate_"^"_curTime
	s ret=##class(User.DHCHMEvaluationLinkDetail).SaveData(ID,ValueStr,nodeStr)
	q ret
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HM.Evaluation","QueryQDOption","1")
Query QueryQDOption(LinkDetailDR As %String = "") As websys.Query(ROWSPEC = "TOPTID:%String,TOptionId:%String,TOptionDesc:%String,TOptionRelevance:%String,TOptionSex:%String")
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
 	f  s optionId=$O(^User.DHCHMEvaluationLinkOptionI("ParRefOptionIndex",LinkDetailDR,optionId))  q:optionId=""  d
 	.s sub=0
	.f  s sub=$O(^User.DHCHMEvaluationLinkOptionI("ParRefOptionIndex",LinkDetailDR,optionId,sub)) q:sub=""  d
	..d BuildOptionData
 	s qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildOptionData
	s id=LinkDetailDR_"||"_sub
	s obj=##class(User.DHCHMEvaluationLinkOption).%OpenId(id)
	s Active=obj.ELOOptionDR.QDOActive
	q:Active'="Y"
	s TOptionId=obj.ELOOptionDR.%Id()
	s TOptionDesc=obj.ELOOptionDR.QDODesc
	s TOptionRelevance=obj.ELOScore
	s TOptionSex=obj.ELOOptionDR.QDOSex
	s Data=$lb(id,TOptionId,TOptionDesc,TOptionRelevance,TOptionSex)
	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod DeleteQDetail(ID)
{
	q ##class(User.DHCHMEvaluationLinkDetail).Delete(ID)
}

/// Descript:更新选项
/// Input:
/// 					ID:DHC_HM_OrdSetsQDOption
/// 					ValueStr:ELOParRef^ELOOptionDR^ELOScore^ELOUpdateUserDR
/// Return: >0：成功 , -1：失败
/// Creater:	wangguoying
/// CreateDate:	2020-04-23
/// Debug: w ##class(web.DHCPE.HM.Evaluation).UpdateQDOption("","1^5^^d^11849")
ClassMethod UpdateQDOption(ID As %String = "", ValueStr As %String)
{
	s ^tmpwgy("UpdateQDOption")=$LB(ID,ValueStr)
	s nodeStr="ELOParRef^ELOOptionDR^ELOScore^ELOUpdateUserDR^ELOUpdateDate^ELOUpdateTime"
	s curDate=+$H
	s curTime=$P($H,",",2)
	s ValueStr=ValueStr_"^"_curDate_"^"_curTime
	s ret=##class(User.DHCHMEvaluationLinkOption).SaveData(ID,ValueStr,nodeStr)
	q ret
}

/// w ##class(web.DHCPE.HM.Evaluation).DeleteQDOption("1||1")
ClassMethod DeleteQDOption(ID)
{
	q ##class(User.DHCHMEvaluationLinkOption).Delete(ID)
}

}
