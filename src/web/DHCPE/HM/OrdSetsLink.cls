/// Description：体检套餐与调查问卷关联关系
/// Creator：wangguoying
Class web.DHCPE.HM.OrdSetsLink Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HM.OrdSetsLink","QueryLinkOrdSets")
Query QueryLinkOrdSets(OrdSetsDR As %String = "", SexDR As %String = "", MinAge As %Integer = 0, MaxAge As %Integer = 999, MaritalDR As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "TID:%String,TOrdSetsId:%String,TOrdSetsDesc:%String,TSexId:%String,TSexDesc:%String,TMinAge:%String,TMaxAge:%String,TMaritalId:%String,TMaritalDesc:%String,TOrdSetsType:%String")
{
}

ClassMethod QueryLinkOrdSetsExecute(ByRef qHandle As %Binary, OrdSetsDR As %String = "", SexDR As %String = "", MinAge As %Integer = 0, MaxAge As %Integer = 999, MaritalDR As %String = "", LocID As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	i OrdSetsDR'=""
 	{
	 	s id=$O(^User.DHCHMOrdSetsLinkI("OrdSetsIndex",OrdSetsDR,""))
	 	d BuildOrdSetsData
 	}else{
 		s setId=0
 		f  s setId=$O(^User.DHCHMOrdSetsLinkI("OrdSetsIndex",setId))  q:setId=""  d
 		.s id=$O(^User.DHCHMOrdSetsLinkI("OrdSetsIndex",setId,0))
 		.d BuildOrdSetsData
 	}	
 	s qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildOrdSetsData
	s powerFlg="Y"
	i LocID'="" s powerFlg = ##class(User.DHCHMOrdSetsLink).GetLocShowDataFlag( id , LocID)
	q:powerFlg'="Y"
	s obj=##class(User.DHCHMOrdSetsLink).%OpenId(id)
	s ordSetsId=obj.OLOrdSetsDR.%Id()
	s ordSetsDesc=obj.OLOrdSetsDR.ARCOSDesc
	s sexId="",sexDesc="",minAge="",maxAge="",maritalId="",maritalDesc=""
	i (obj.OLSexDR)
	{
		s sexId=obj.OLSexDR.%Id()
		q:(SexDR'="")&(sexId'=SexDR)
		s sexDesc=obj.OLSexDR.CTSEXDesc
	}
	s minAge=obj.OLMinAge
	s maxAge=obj.OLMaxAge
	q:((minAge'="")&&(MinAge>minAge))||((maxAge'="")&&(MaxAge<maxAge))
	i (obj.OLMaritalDR)
	{
		s maritalId=obj.OLMaritalDR.%Id()
		q:(MaritalDR'="")&(maritalId'=MaritalDR)
		s maritalDesc=obj.OLMaritalDR.CTMARDesc
	}
	s ordSetsType=obj.OLOrdSetsType
	s Data=$lb(id,ordSetsId,ordSetsDesc,sexId,sexDesc,minAge,maxAge,maritalId,maritalDesc,ordSetsType)
	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HM.OrdSetsLink","QueryQDetail",1)
Query QueryQDetail(LinkDR As %String = "", DetailDR As %String = "") As websys.Query(ROWSPEC = "TOQDID:%String,TDetailId:%String,TDetailDesc:%String,TDetailType:%String,TDetailSex:%String,TDetailUnit:%String,TDetailRemark:%String,TRelevance:%String,TExpression:%String")
{
}

ClassMethod QueryQDetailExecute(ByRef qHandle As %Binary, LinkDR As %String = "", DetailDR As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	
 	i LinkDR=""
 	{
	 	s qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	i DetailDR'=""
 	{
	 	s sub=0
	 	f  s sub=$O(^User.DHCHMOrdSetsQDetailI("ParRefDetailIndex",LinkDR,DetailDR,sub)) q:sub=""  d
	 	.d BuildQDetailData
 	}else{
 		s detailId=0
 		f  s detailId=$O(^User.DHCHMOrdSetsQDetailI("ParRefDetailIndex",LinkDR,detailId))  q:detailId=""  d
 		.s sub=0
	 	.f  s sub=$O(^User.DHCHMOrdSetsQDetailI("ParRefDetailIndex",LinkDR,detailId,sub)) q:sub=""  d
 		..d BuildQDetailData
 	}	
 	s qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildQDetailData
	s id=LinkDR_"||"_sub
	s obj=##class(User.DHCHMOrdSetsQDetail).%OpenId(id)
	s Active=obj.OQDDeatilDR.QDActive
	q:Active'="Y"
	s TDetailId=obj.OQDDeatilDR.%Id()
	s TDetailDesc=obj.OQDDeatilDR.QDDesc
	s TDetailType=obj.OQDDeatilDR.QDType
	s TDetailSex=obj.OQDDeatilDR.QDSex
	s TDetailUnit=obj.OQDDeatilDR.QDUnit
	s TDetailRemark=obj.OQDDeatilDR.QDRemark
	s TRelevance=obj.OQDRelevance
	s TExpression=obj.OQDExpression
	s Data=$lb(id,TDetailId,TDetailDesc,TDetailType,TDetailSex,TDetailUnit,TDetailRemark,TRelevance,TExpression)
	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.HM.OrdSetsLink","QueryQDOption","14||4")
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
 	f  s optionId=$O(^User.DHCHMOrdSetsQDOptionI("ParRefOptionIndex",+LinkDetailDR,$P(LinkDetailDR,"||",2),optionId))  q:optionId=""  d
 	.s sub=0
	.f  s sub=$O(^User.DHCHMOrdSetsQDOptionI("ParRefOptionIndex",+LinkDetailDR,$P(LinkDetailDR,"||",2),optionId,sub)) q:sub=""  d
	..d BuildOptionData
 	s qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildOptionData
	s id=LinkDetailDR_"||"_sub
	s obj=##class(User.DHCHMOrdSetsQDOption).%OpenId(id)
	s Active=obj.OQDOOptionDR.QDOActive
	q:Active'="Y"
	s TOptionId=obj.OQDOOptionDR.%Id()
	s TOptionDesc=obj.OQDOOptionDR.QDODesc
	s TOptionRelevance=obj.OQDORelevance
	s TOptionSex=obj.OQDOOptionDR.QDOSex
	s Data=$lb(id,TOptionId,TOptionDesc,TOptionRelevance,TOptionSex)
	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

/// Descript:更新关联套餐
/// Input:
/// 					ID:DHC_HM_OrdSetsLink
/// 					ValueStr:OLOrdSetsDR^OLSexDR^OLMinAge^OLMaxAge^OLMaritalDR^OLOrdSetsType^OLUpdateUserDR
/// Return: >0：成功 , -1：失败
/// Creater:	wangguoying
/// CreateDate:	2020-04-22
/// Debug: w ##class(web.DHCPE.HM.OrdSetsLink).UpdateLinkOrdSets("","")
ClassMethod UpdateLinkOrdSets(ID As %String = "", ValueStr As %String, LocID)
{
	s ^tmpwgy("UpdateLinkOrdSets")=$LB(ID,ValueStr,LocID)
	s nodeStr="OLOrdSetsDR^OLSexDR^OLMinAge^OLMaxAge^OLMaritalDR^OLOrdSetsType^OLUpdateUserDR^OLTUpdateDate^OLUpdateTime"
	s curDate=+$H
	s curTime=$P($H,",",2)
	s ValueStr=ValueStr_"^"_curDate_"^"_curTime
	
	s $ZT="UpdateErr"
	TS
	s ret=##class(User.DHCHMOrdSetsLink).SaveData(ID,ValueStr,nodeStr)
	i +ret<0  tro  q ret
	i ID = ""
	{
		//授权
		s UserID = $P(ValueStr,"^",7)
		s ret = ##class(User.DHCHMOrdSetsLink).SaveDataToPowerControl(+ret, LocID , UserID)
		i +ret<0  tro  q ret
	}
	TC	
	q ret
UpdateErr
	s $zt=""
	Tro
	q "-100^"_$ZE
}

ClassMethod DeleteLinkOrdSets(ID)
{
	q ##class(User.DHCHMOrdSetsLink).Delete(ID)
}

/// Descript:更新问卷基本内容
/// Input:
/// 					ID:DHC_HM_OrdSetsQDetail
/// 					ValueStr:OQDParRef^OQDDeatilDR^OQDRelevance^OQDExpression^OQDUpdateUserDR
/// Return: >0：成功 , -1：失败
/// Creater:	wangguoying
/// CreateDate:	2020-04-23
/// Debug: w ##class(web.DHCPE.HM.OrdSetsLink).UpdateQDetail("","1^5^^d^11849")
ClassMethod UpdateQDetail(ID As %String = "", ValueStr As %String)
{
	s ^tmpwgy("UpdateQDetail")=$LB(ID,ValueStr)
	s nodeStr="OQDParRef^OQDDeatilDR^OQDRelevance^OQDExpression^OQDUpdateUserDR^OQDUpdateDate^OQDUpdateTime"
	s curDate=+$H
	s curTime=$P($H,",",2)
	s ValueStr=ValueStr_"^"_curDate_"^"_curTime
	s ret=##class(User.DHCHMOrdSetsQDetail).SaveData(ID,ValueStr,nodeStr)
	q ret
}

ClassMethod DeleteQDetail(ID)
{
	q ##class(User.DHCHMOrdSetsQDetail).Delete(ID)
}

/// Descript:更新选项
/// Input:
/// 					ID:DHC_HM_OrdSetsQDOption
/// 					ValueStr:OQDOParRef^OQDOOptionDR^OQDORelevance^OQDOUpdateUserDR^OQDOUpdateDate^OQDOUpdateTime
/// Return: >0：成功 , -1：失败
/// Creater:	wangguoying
/// CreateDate:	2020-04-23
/// Debug: w ##class(web.DHCPE.HM.OrdSetsLink).UpdateQDOption("","1^5^^d^11849")
ClassMethod UpdateQDOption(ID As %String = "", ValueStr As %String)
{
	s ^tmpdhcpe("UpdateQDOption")=$LB(ID,ValueStr)
	s nodeStr="OQDOParRef^OQDOOptionDR^OQDORelevance^OQDOUpdateUserDR^OQDOUpdateDate^OQDOUpdateTime"
	s curDate=+$H
	s curTime=$P($H,",",2)
	s ValueStr=ValueStr_"^"_curDate_"^"_curTime
	S parref=$P(ValueStr,"^",1)
	S optionId=$P(ValueStr,"^",2)
	q:($d(^User.DHCHMOrdSetsQDOptionI("ParRefOptionIndex",$P(parref,"||",1),$P(parref,"||",2),optionId))) "-1^选项重复!"
	s ret=##class(User.DHCHMOrdSetsQDOption).SaveData(ID,ValueStr,nodeStr)
	q ret
}

ClassMethod DeleteQDOption(ID)
{
	q ##class(User.DHCHMOrdSetsQDOption).Delete(ID)
}

/// Descript:判断关联套餐是否存在
/// Input:
/// 					OrdSetsDR:套餐ID
/// 					ID:关联ID
/// Return: 0：不存在 , 1：存折
/// Creater:	wangguoying
/// CreateDate:	2020-04-22
/// Debug: w ##class(web.DHCPE.HM.OrdSetsLink).CheckOrdSetsExist("","")
ClassMethod CheckOrdSetsExist(OrdSetsDR, ID = "")
{
	q:OrdSetsDR="" 0
	i ID="" q $D(^User.DHCHMOrdSetsLinkI("OrdSetsIndex",OrdSetsDR))
	s CID=$O(^User.DHCHMOrdSetsLinkI("OrdSetsIndex",OrdSetsDR,0))
	i (ID=CID)||(CID="") q 0
	e  q 1
}

}
