Class web.DHCEQ.EM.BUSResearch Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified by ZY0217 2020-04-08
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSResearch","ResearchList","0","2","1",0)
/// modify by wl 2020-2-12 调整输出列,增加参数
Query ResearchList(BussType As %String, SourceType As %String = "", SourceID As %String = "", RFunProFlag As %String = "") As %Query(ROWSPEC = "RRowID:%String,RCode:%String,RDesc:%String,RType:%String,RTypeDesc:%String,RUserDR:%String,RUserDR_UName,RParticipant:%String,RLevel:%String,RBeginDate:%String,REndDate:%String,RUsedFlag:%String,RDevelopStatus:%String,RDevelopStatusDesc:%String,RInvalidFlag:%String,RUpdateUserDR_UName:%String,RUpdateDate:%String,RUpdateTime:%String,RRemark:%String,BussType:%String,SourceType:%String,SourceID:%String")
{
}

ClassMethod ResearchListExecute(ByRef qHandle As %Binary, BussType As %String, SourceType As %String = "", SourceID As %String = "", RFunProFlag As %String = "") As %Status
{
	//new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	if (SourceType="")||(SourceID="") ||(BussType="")
	{
		Do ResetVariablesResearchList
		Do OutputRowResearchList
		Quit $$$OK
	}
	else
	{
		s OutFlag=0
		///add by ZY0247 2020-12-22 效益分析处不需要默认行
		i BussType=0 s OutFlag=1
		s rowid=0
		For  Set rowid=$Order(^DHCEQResearch(0,"SourceType",BussType,SourceType,SourceID,rowid))  Quit:rowid=""  Do
		.Do ResetVariablesResearchList
		.s DataList=$Get(^DHCEQResearch(rowid))
		.s RRowID = rowid
		.s RCode=$Piece(DataList,"^",4)
		.s RDesc=$Piece(DataList,"^",5)
		.s RType=$Piece(DataList,"^",6)
		.//modified by ZY0287 20211216
		.;modified by WY 2022-08-31 2886758 RFunProFlag 0 科研项目/论文, 1 功能项目
        .;i (RType=0)||(RType=1) d
        .;.s Flag=0
        .;e  d
        .;.s Flag=1
        .q:(RFunProFlag'=RType)
		.i RType'="" s RTypeDesc=$case(RType,"0":"科研项目","1":"论文","2":"功能项目")
		.s RUserDR=$Piece(DataList,"^",7)
		.s RUser=##class(web.DHCEQCommon).GetTrakNameByID("user",RUserDR)
		.s RParticipant=$Piece(DataList,"^",8)
		.s RLevel=$Piece(DataList,"^",9)
		.s RBeginDate=$Piece(DataList,"^",10)
		.s RBeginDate=##class(web.DHCEQCommon).TransValueToPage(RBeginDate,"date")
		.s REndDate=$Piece(DataList,"^",11)
		.s REndDate=##class(web.DHCEQCommon).TransValueToPage(REndDate,"date")
		.s RUsedFlag=$Piece(DataList,"^",12)
		.s RDevelopStatus=$Piece(DataList,"^",13)
		.i RDevelopStatus'="" s RDevelopStatusDesc=$case(RDevelopStatus,"1":"原有功能","2":"可开发功能","3":"已开发功能")
		.s RInvalidFlag=$Piece(DataList,"^",14)
		.s RUpdateUserDR=$Piece(DataList,"^",15)
		.i RUpdateUserDR'="" s TUpdateUser=##class(web.DHCEQCommon).GetTrakNameByID("user",RUpdateUserDR)
		.s RUpdateDate=$Piece(DataList,"^",16)
		.s RUpdateDate=##class(web.DHCEQCommon).TransValueToPage(RUpdateDate,"date")
		.s RUpdateTime=$Piece(DataList,"^",17)
		.s RUpdateTime=##class(web.DHCEQCommon).TransValueToPage(RUpdateTime,"time")
		.s RRemark=$Piece(DataList,"^",18)
		.Do OutputRowResearchList
		.s OutFlag=1
		i OutFlag=0
		{
			Do ResetVariablesResearchList
			Do OutputRowResearchList
		}
	}
	Quit $$$OK
OutputRowResearchList
	Set TRow=index	
	Set Data=$lb(RRowID,RCode,RDesc,RType,RTypeDesc,RUserDR,RUser,RParticipant,RLevel,RBeginDate,REndDate,RUsedFlag,RDevelopStatus,RDevelopStatusDesc,RInvalidFlag,RUpdateUser,RUpdateDate,RUpdateTime,RRemark,BussType,SourceType,SourceID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesResearchList
	Set (RRowID,RCode,RDesc,RType,RTypeDesc,RUserDR,RUser,RParticipant,RLevel,RBeginDate,REndDate,RUsedFlag,RDevelopStatus,RDevelopStatusDesc,RInvalidFlag,RUpdateUser,RUpdateDate,RUpdateTime,RRemark)=""
	Quit
}

ClassMethod ResearchListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ResearchListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ResearchListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ResearchListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SaveData(val)
{
    Set $ZT="ERROR"
	TSTART
    s length=$l(val,"&")
	f i=1:1:length  d
	.s OneList=$p(val,"&",i)
	.s SQLCODE=##Class(web.DHCEQ.EM.BUSResearch).SaveDataList(OneList,0)
	.q:SQLCODE'=0
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,length)
ERROR 
	TRollBack	
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorMsg)
}

/// modify by wl 2020-1-21 增加用户更新信息
/// w ##class(web.DHCEQ.EM.BUSResearch).SaveDataList("11^1^3^奥地利佩施卡国际公司^2^奥地利佩施卡国际公司^2^描述02^2^白云山企业^2^xxx^12345^12345^Y^1^^12^9^xx^^^^^^^^^^14^^^^",0)
ClassMethod SaveDataList(val As %Library.String = "", OperateType As %Library.String = "")
{
	/// modified by ZY0217 2020-04-08
	new RowID,JsonData,SQLCODE
	Kill PLIST,RowID
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(val)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQResearch",JsonData,.PLIST)
	s RowID = JsonData.RRowID
	If (+OperateType=1)
	{
	 	&SQL(delete from sqluser.DHC_EQResearch where R_RowID=:val)
	 	Quit SQLCODE
 	}
 	If (+OperateType=0) //新增,更新
 	{
	 	s PLIST(16) = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	 	s PLIST(17) =+$HOROLOG
	 	s PLIST(18) = $PIECE($HOROLOG,",",2)
		if RowID'=""
		{
			
			&SQL(Update SQLUSER.DHC_EQResearch Values :PLIST() where R_RowID = :RowID)
		}
		else
		{
			&SQL(insert into SQLUSER.DHC_EQResearch Values :PLIST())
		}
 	}
 	i SQLCODE=100 s SQLCODE=0
 	Quit SQLCODE
}

/// Creator：      汪亮
/// CreatDate：    2019-02-03
/// Description:   论证方式
/// Table：        DHC_EQCResearchType
/// Input：        Desc:论证方式的描述
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSResearch","GetResearchType")
Query GetResearchType() As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetResearchTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	s rowid=0
	s Code="01"
	s Desc="科研项目"
	d OutputRowGetResearchType
	s rowid=1
	s Code="02"
	s Desc="论文"
	d OutputRowGetResearchType
	Quit $$$OK
OutputRowGetResearchType
	Set Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetResearchTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResearchTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetResearchTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResearchTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      汪亮
/// CreatDate：    2019-02-12
/// Description:   功能项目类型
/// Table：        DHC_EQCResearchType
/// Input：        Desc:论证方式的描述
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSResearch","GetFuncProjType")
Query GetFuncProjType() As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetFuncProjTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	s rowid=1
	s Code="01"
	s Desc="原有功能" 
	d OutputRowGetFuncProjType
	s rowid=2
	s Code="02"
	s Desc="可开发功能"
	d OutputRowGetFuncProjType
	s rowid=3
	s Code="03"
	s Desc="已开发功能"
	d OutputRowGetFuncProjType
	Quit $$$OK
OutputRowGetFuncProjType
	Set Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetFuncProjTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFuncProjTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetFuncProjTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFuncProjTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// modified by ZY20230105 bug:3187233
/// modified by ZY0226 2020-04-24
/// 增加参数RFunProFlag，区分科研教学和功能项目
/// modified by ZY0222 2020-04-16
/// w ##class(web.DHCEQ.EM.BUSResearch).GetListNum(1,2)
ClassMethod GetListNum(BussType, SourceType, SourceID, RFunProFlag As %Library.String = "")
{
	new count,firstID,objInfo
	s count=0
	s firstID=""
	i $Data(^DHCEQResearch(0,"SourceType",BussType,SourceType,SourceID))
	{
		s rowid=0
		For  Set rowid=$Order(^DHCEQResearch(0,"SourceType",BussType,SourceType,SourceID,rowid))  Quit:rowid=""  Do
		.s RType=$Piece($Get(^DHCEQResearch(rowid)),"^",6)
        .;q:(RFunProFlag="1")&&(RType'="2")
        .;q:(RFunProFlag="0")&&(RType="2")
        .q:(RFunProFlag'=RType)  //modified by WY 2022-9-27 2970015
        .s count=count+1
        .i count=1 s firstID=rowid
    }
    
    s objInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
    d objInfo.%Set("count",count)
    d objInfo.%Set("firstID",firstID)
    
    i firstID'=""
    {
        s RDesc=$Piece($Get(^DHCEQResearch(firstID)),"^",5)
    }
    else
    {
        s RDesc=""
    }
    d objInfo.%Set("RDesc",RDesc)
    
    q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,objInfo)
}

}
