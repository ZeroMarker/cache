Import sqluser

/// creator:dws
/// 2017-02-08
/// Descript:陪送、陪送评价功能的各个后台方法
Class web.DHCDISAppraise Extends %Persistent
{

/// creator:dws
/// 2017-02-08
/// Descript:获取评价模块描述名称
/// w ##Class(web.DHCDISAppraise).getSignModuleDesc()
ClassMethod getSignModuleDesc()
{
	s AIRowId=""
	s AIDesc=""
	s AIScore=""
	s jsonStr=""
	s count=0
	f  s AIRowId=$o(^DHCDISAI(AIRowId)) q:AIRowId=""  d
	.q:AIRowId=0
	.s AIDesc=$p(^DHCDISAI(AIRowId),"^",2)
	.s AIScore=$p(^DHCDISAI(AIRowId),"^",5)
	.s count=count+1
	.s jsonStr = jsonStr_"{"
	.s jsonStr = jsonStr_"""AIRowId"":"""_AIRowId_""""
	.s jsonStr = jsonStr_",""AIDesc"":"""_AIDesc_""""
	.s jsonStr = jsonStr_",""AIScore"":"""_AIScore_""""
	.s jsonStr = jsonStr_"},"
	s jsonStr=$e(jsonStr,1,$l(jsonStr)-1)
	q "{""total"":"_count_",""rows"":["_jsonStr_"]}"
}

/// creator:dws
/// 2017-02-08
/// Descript:获取相应评分下的评价模块
/// w ##Class(web.DHCDISAppraise).getScoreModuleDesc(20,40)
ClassMethod getScoreModuleDesc(startScore, endScore)
{
	s Code=""
	s RowId=""
	s count=0
	s jsonStr=""
	f Score=startScore:1:endScore  d
	.f  s Code=$o(^DHCDISAI(0,"Code",Score,Code)) q:Code=""  d
	..f  s RowId=$o(^DHCDISAI(0,"Code",Score,Code,RowId)) q:RowId=""  d
	...s AIDesc=$p(^DHCDISAI(RowId),"^",2)
	...s AIScore=$p(^DHCDISAI(RowId),"^",5)
	...s count=count+1
	...s jsonStr = jsonStr_"{"
	...s jsonStr = jsonStr_"""AIRowId"":"""_RowId_""""
	...s jsonStr = jsonStr_",""AIDesc"":"""_AIDesc_""""
	...s jsonStr = jsonStr_",""AIScore"":"""_AIScore_""""
	...s jsonStr = jsonStr_"},"
	s jsonStr=$e(jsonStr,1,$l(jsonStr)-1)
	q "{""total"":"_count_",""rows"":["_jsonStr_"]}"
}

/// creator:dws
/// 2017-02-11
/// Descript:保存评价
/// w ##Class(web.DHCDISAppraise).saveDisappraise("18","132","2","aa","2017-05-26","10:23:29","575","","19","1")
ClassMethod saveDisappraise(RaReqType, mainRowID, RaNubmer, RaRemarks, appDate, appTime, createUser, RaItemDr, StatusCode, FaileReason)
{
	q:$d(^DHCDISRA(0,"TypePointer",RaReqType,mainRowID)) 0
	s LastRaRowId="" //父表里面最后的id
	Ts //开始事务
	i appDate'="" s appDate=$zdh(appDate,3) //日期格式转换
	i appTime'="" s appTime=$zth(appTime,1) //时间格式转换
	s appTb=##class(User.DHCDisRequestAsse).%New() //实例化评价表
	s appTb.RAReqType=RaReqType //pei送类型
	s appTb.RAPointer=mainRowID //申请id
	s appTb.RANubmer=RaNubmer //评价得分
	s appTb.RARemarks=RaRemarks //评价内容
	s appTb.RACreateDate=appDate //申请单日期
	s appTb.RACreateTime=appTime //申请单时间
	s appTb.RACreateUser=createUser //申请用户
	s sc1=appTb.%Save()
	if ($$$ISERR(sc1)){ ////评价表插入失败
		Tro 
		q 0
	}

	s LastRaRowId=$o(^DHCDISRA(LastRaRowId),-1) //父表里面最后的id
	s appTbItm=##class(User.DHCDisRequestAsseI).%New(LastRaRowId) //实例化明细表（子表必须带上父表的rowid）
	d appTbItm.ParrefSetObjectId(LastRaRowId)
	s appTbItm.RAItemDr=RaItemDr
	s sc2=appTbItm.%Save()
	i $$$ISERR(sc2) Tro  q 0   //回滚
	;e  Tc  q 1        //提交事务
	
	s ret=..SaveStatus(mainRowID, RaReqType, StatusCode, createUser, "Y", FaileReason)
	i ret'=1 TRO  q 0

	TC
	
	q 1
}

ClassMethod SaveStatus(pointer, type, statuscode, lgUser, EmFlag, FaileReason)
{
	//获取状态ID
	s status=##class(web.DHCDISRequestCom).GetStatusID(statuscode,type)
	q:status=""
	//保存操作流水表
	s ret=##class(web.DHCDISRequestCom).saveRequestSta(pointer,type,status,lgUser,FaileReason)
	q:ret'=0
	//更新申请主表状态
	s ret=##class(web.DHCDISRequestCom).updateRequestStatus(pointer,type,status)
	q:ret'=0
	//更新人员状态
	s ret=##class(web.DHCDISRequestCom).updatePeopleStatus(pointer,type,status)
	q:ret'=0
	
	q 1
}

/// creator:dws
/// 2017-02-22
/// Descript:判断该用户是否已经评价过该申请单
/// w ##Class(web.DHCDISAppraise).orNotAppraise("23",4)
/// D ##class(User.DHCDisRequestAsse).%BuildIndices()
ClassMethod orNotAppraise(mainRowID, LgUserID, repType)
{
	s appNum=""
	&sql(select count(*) into appNum from DHC_DisRequestAsse where RA_Pointer=:mainRowID and RA_CreateUser=:LgUserID and RA_ReqType=:repType)
	q appNum
}

/// creator:dws
/// 2017-02-22
/// Descript:获取已经评价过的申请单相关信息
/// w ##Class(web.DHCDISAppraise).getPraiseInfo("132","18")
ClassMethod getPraiseInfo(mainRowID, repType)
{
	s count=0
	s jsonStr=""
	s RaRowId=""
	s RaChildSub=""
	f  s RaRowId=$o(^DHCDISRA(0,"TypePointer",repType,mainRowID,RaRowId)) q:RaRowId=""  d
	.f  s RaChildSub=$o(^DHCDISRAi(RaRowId,"A",RaChildSub)) q:RaChildSub=""  d
	..s RaItemDr= $p(^DHCDISRAi(RaRowId,"A",RaChildSub),"^",3) //评价模块项目
	..i RaItemDr'="" s RaItemDr=..getSignName(RaItemDr)
	..e  s RaItemDr=""
	..s RaNubmer=$p(^DHCDISRA(RaRowId),"^",3) //评价得分
	..s RaRemarks=$p(^DHCDISRA(RaRowId),"^",4) //评价内容
	..
	..s TypeDesc="",CurStatusID="",AffirmType=""  //获取申请单状态
	..s:repType'="" TypeDesc=$p(^DHCDISTA(repType),"^",1)
	..s:TypeDesc="陪送" CurStatusID=$p(^DHCDISRE(mainRowID),"^",16)
	..s:TypeDesc'="陪送" CurStatusID=$p(^DHCDISGRE(mainRowID),"^",10)
	..s CurStatusCode=$p(^DHCDISSA(CurStatusID),"^",1)
	..s:CurStatusCode=19 AffirmType=0
	..
	..s ReqStaID="",ReasonDr=""    //获取空趟原因
	..s ReqStaID=$o(^DHCDISRS(0,"TypePointer",repType,mainRowID,ReqStaID),-1)
	..s ReasonID=$p(^DHCDISRS(ReqStaID),"^",7)
	..s:ReasonID'="" ReasonDr=ReasonID
	..
	..s count=count+1
	..s jsonStr = jsonStr_"{"
	..s jsonStr = jsonStr_"""RaNubmer"":"""_RaNubmer_""""
	..s jsonStr = jsonStr_",""RaRemarks"":"""_RaRemarks_""""
	..i RaItemDr'="" s jsonStr = jsonStr_",""RaItemDr"":"_RaItemDr_""  
	..e  s jsonStr = jsonStr_",""RaItemDr"":"""_RaItemDr_""""
	..s jsonStr = jsonStr_",""AffirmType"":"""_AffirmType_""""
	..s jsonStr = jsonStr_",""ReasonDr"":"""_ReasonDr_""""
	..s jsonStr = jsonStr_"},"
	s jsonStr=$e(jsonStr,1,$l(jsonStr)-1)
	q "{""total"":"_count_",""rows"":["_jsonStr_"]}"
}

/// creator:dws
/// 2017-02-22
/// Descript:获取已经评价过的申请单标签信息
/// w ##Class(web.DHCDISAppraise).getPraiseInfo("5-8-10")
ClassMethod getSignName(RaItemDr)
{
	s jsonStr=""
	f id=1:1:($l(RaItemDr)+1)/2  d
	.s signId=$p(RaItemDr,"-",id)
	.q:signId=""
	.s signName=$p(^DHCDISAI(signId),"^",2)
	.s jsonStr = jsonStr_"{"
	.s jsonStr = jsonStr_"""signName"":"""_signName_""""
	.s jsonStr = jsonStr_"},"
	s jsonStr=$e(jsonStr,1,$l(jsonStr)-1)
	q "["_jsonStr_"]"
}

/// creator:dws
/// 2017-02-23
/// Descript:获取陪送创建人
/// w ##Class(web.DHCDISAppraise).getAffPeo("23")
ClassMethod getAffPeo(mainRowId)
{
	s affPeo=$p(^DHCDISRE(mainRowId),"^",15)
	q affPeo
}

/// creator:dws
/// 2017-02-23
/// Descript:获取配送创建人
/// w ##Class(web.DHCDISAppraise).getAccPeo("23")
ClassMethod getAccPeo(mainRowId)
{
	s accPeo=$p(^DHCDISGRE(mainRowId),"^",9)
	q accPeo
}

Storage Default
{
<Data name="DHCDISAppraiseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCDISAppraiseD</DataLocation>
<DefaultData>DHCDISAppraiseDefaultData</DefaultData>
<IdLocation>^web.DHCDISAppraiseD</IdLocation>
<IndexLocation>^web.DHCDISAppraiseI</IndexLocation>
<StreamLocation>^web.DHCDISAppraiseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
