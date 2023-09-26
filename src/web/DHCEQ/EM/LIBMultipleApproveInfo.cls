Class web.DHCEQ.EM.LIBMultipleApproveInfo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add by QW 2019-08-29
/// 描述: 保存审批人员，科室，或角色
/// 入参:val  DelIs 
/// 访问表：   DHC_EQMultipleApproveInfo
/// 返回值:无
/// d ##class(User.DHCEQMultipleApproveInfo).%BuildIndices()
ClassMethod SaveData(data, DelIs)
{
	
	s $ZT="ERRORMULTIPLE"
	k MAPLIST,RowID,ID
	
	TSTART
	if DelIs=1
	{
		s RowID=data
		&SQL(Update SQLUSER.DHC_EQMultipleApproveInfo set MA_InvalidFlag='Y' where MA_RowID = :RowID)
		s RowID=""
	}else
	{

		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s MAPLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQMultipleApproveInfo",JsonData,.MAPLIST)
		;Add by QW20191205 begin 需求号:1123977 处理重复添加问题。
		s ID=""
		&SQL(Select MA_RowID Into :ID From SQLUSER.DHC_EQMultipleApproveInfo Where  MA_InvalidFlag='N' and MA_BusID=:JsonData.MABusID and MA_SourceID=:JsonData.MASourceID)
		if ID'="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210")
		;End by QW20191205 end 需求号:1123977   处理重复添加问题。
		i JsonData.MABusID="" 
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","业务ID为空")
		}
		s RowID = JsonData.MARowID
		s MAPLIST(2)=##class(web.DHCEQApproveList).GetApproveType(JsonData.MAApproveTypeDR) ;ApproveTypeDR
		s MAPLIST(4)=##Class(web.DHCEQ.EM.CTMultipleDefine).GetMultipleDefineDRByApproveType(MAPLIST(2))
		///add by ZY0196 20191121	//联合申请时,如果没有设置审批流程的属性,控制不能保存.
		if MAPLIST(4)="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","请设置审批流程中多科室联合申请的属性")
        s MAPLIST(8)="N"
		i RowID'=""
		{
			&SQL(Update SQLUSER.DHC_EQMultipleApproveInfo Values :MAPLIST() where MA_RowID = :RowID)
		}
		else
		{
				&SQL(insert into SQLUSER.DHC_EQMultipleApproveInfo Values :MAPLIST())
				s RowID=$g(%ROWID)
		}
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
		TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORMULTIPLE
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// 返回值:0:单据可提交到下一步 1:单据不可提交到下一步
/// w ##Class(web.DHCEQ.EM.LIBMultipleApproveInfo).GetMultipleApproveInfo(20,2,1,"","",1,2,19)
ClassMethod GetMultipleApproveInfo(BusRowID, BCurRole, BStep, BOpinion, BRemark, BApproveType, BApproveSet, BAction As %String = "", BOperateType As %String = "0")
{
    new (BusRowID, BCurRole, BStep, BOpinion, BRemark, BApproveType, BApproveSet, BAction, BOperateType,%session)
	s (MARowID,val,MultipleNum,MultipleDefineDR,SourceType,SourceID,BApproveListDR,ApproveListDR)=""
	s Num=0
	s TotalNum=0
	i BusRowID="" Quit -1  ;无业务单据ID不能提交
    s val=##Class(web.DHCEQ.EM.LIBMultipleApproveInfo).GetMultipleInfo(BApproveSet, BStep, BCurRole)

	s MultipleNum=+$p(val,"^",1)
	s MultipleDefineDR=$p(val,"^",2)
	q:MultipleDefineDR="" 0  ;未设置多方审批定义正常提交
	s SourceType=$p($g(^DHCEQCCode("DHCEQCMultipleDefine",MultipleDefineDR)),"^",2)
	if SourceType =0   ;科室
	{
		s SourceID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID")) ;
	}elseif SourceType =1   ;人员
	{
		s SourceID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	}else
	{
		s SourceID=BCurRole
	}
	;i $o(^DHCEQMultipleApproveInfo(0,"SourceID",BApproveType,BusRowID,0))=""  q -1  ;未设置科室不能参与审批
	s BDate=+$H
	s BTime=$p($H,",",2)
	s BSourceID=0
	for  s BSourceID=$o(^DHCEQMultipleApproveInfo(0,"SourceID",BApproveType,BusRowID,BSourceID))  quit:BSourceID=""  d
	.s ID=0
	.f  s ID=$o(^DHCEQMultipleApproveInfo(0,"SourceID",BApproveType,BusRowID,BSourceID,ID))  quit:ID=""  d
	..s BApproveListDR=$p($g(^DHCEQMultipleApproveInfo(ID)),"^",6)
	..q:$p($g(^DHCEQMultipleApproveInfo(ID)),"^",7)="Y"
	..;q:(BAction'="")&&(BAction'=$p($g(^DHCEQMultipleApproveInfo(ID)),"^",5))
	..s TotalNum=TotalNum+1
	..
	..i BApproveListDR'=""  d 
	...s Num=Num+1
	..q:SourceID'=BSourceID
	..s MARowID=ID
	i ((MultipleNum'=0)&&((MultipleNum-Num)<0))  q 0
	i MARowID="" Quit 0
	s ApproveListDR=$p($g(^DHCEQMultipleApproveInfo(MARowID)),"^",6)
	i ApproveListDR'=""  Quit 1
	&SQL(Insert Into SQLUSER.DHC_EQApproveList(AL_ApproveTypeDR,AL_SourceID,AL_Opinion,AL_ApproveUserDR,AL_ApproveDate,AL_ApproveTime,AL_FlowStep,AL_InvalidFlag,AL_Action,AL_OperateType,AL_ApproveRoleDR) values(:BApproveType,:BusRowID,:BOpinion,:BUser,:BDate,:BTime,:BStep ,'N',:BAction,:BOperateType,:BCurRole))	
	i SQLCODE Quit SQLCODE
	s BApproveListDR=$G(%ROWID)
	&SQL(Update SQLUSER.DHC_EQMultipleApproveInfo Set MA_ApproveListDR=:BApproveListDR  where MA_RowID=:MARowID )
	i SQLCODE Quit SQLCODE
	i ((MultipleNum'=0)&&((MultipleNum-Num)=1))  q 0
	i ((MultipleNum=0)&&((TotalNum-Num)=1))  q 0
	Quit 1
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.LIBMultipleApproveInfo","MultipleApproveInfo","7","1")
Query MultipleApproveInfo(BusID As %String = "", ApproveType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceID:%String,TSource:%String")
{
}

ClassMethod MultipleApproveInfoExecute(ByRef qHandle As %Binary, BusID As %String = "", ApproveType As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s SourceID=0
	for  s SourceID=$o(^DHCEQMultipleApproveInfo(0,"SourceID",ApproveType,BusID,SourceID)) quit:SourceID=""  d
	.s rowid=0
	.for  s rowid=$o(^DHCEQMultipleApproveInfo(0,"SourceID",ApproveType,BusID,SourceID,rowid)) quit:rowid=""  d
	..d ResetVariablesGetMultipleApproveInfo
	..s TRowID=rowid
	..s TInvalidFlag=$p($g(^DHCEQMultipleApproveInfo(TRowID)),"^",7)
	..q:TInvalidFlag="Y"
	..s TMultiDefineDR=$p($g(^DHCEQMultipleApproveInfo(TRowID)),"^",3)
	..i TMultiDefineDR'="" d
	...s TSourceType=$p($g(^DHCEQCCode("DHCEQCMultipleDefine",TMultiDefineDR)),"^",2)
	...s TSourceID=$p($g(^DHCEQMultipleApproveInfo(TRowID)),"^",4)
	...i TSourceType=0 d
	....s TSource=##class(web.DHCEQCommon).GetTrakNameByID("dept",TSourceID)
	...i TSourceType=1 d
	....s TSource=##class(web.DHCEQCommon).GetTrakNameByID("user",TSourceID)
	...i TSourceType=2  d
	....s TSource=$p($g(^DHCEQCCode("DHCEQCApproveRole",TSourceID)),"^",2)
	..d OutputRowGetMultipleApproveInfo
	Quit $$$OK
OutputRowGetMultipleApproveInfo
	s Data=$lb(TRowID,TSourceID,TSource)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetMultipleApproveInfo
	s (TRowID,TInvalidFlag,TMultiDefineDR,TSourceType,TSourceID,TSource)=""
	quit
}

ClassMethod MultipleApproveInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MultipleApproveInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod MultipleApproveInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MultipleApproveInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// w ##Class(web.DHCEQ.EM.LIBMultipleApproveInfo).GetMultipleInfo("6","35","2")
ClassMethod GetMultipleInfo(ApproveSet, CurStep, CurRole)
{
	n (ApproveSet,CurStep, CurRole)
	s (AFRowID,MultipleNum,MultipleDefineDR)=""
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,CurStep,rowid))  q:((rowid="")||(AFRowID'=""))  d
	.s role=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",2)
	.q:CurRole'=role 
	.s AFRowID=rowid
	.s MultipleNum=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",17)
	.s MultipleDefineDR=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",18)
     
	q MultipleNum_"^"_MultipleDefineDR
}

/// 判断某一方是否已审核，不再推送消息或者数据。
/// 返回值 0:未审核 其他:已审核
/// w ##Class(web.DHCEQ.EM.LIBMultipleApproveInfo).ISMultipleDone(2,11,2,1,1)
ClassMethod ISMultipleDone(ApproveSet, BusID, CurRole, ApproveType, CurStep)
{
	;new (ApproveSet, BusID, CurRole,ApproveType,CurStep,%session)

	i '$D(^DHCEQMultipleApproveInfo(0,"SourceID",ApproveType,BusID)) q 0
	s val=##Class(web.DHCEQ.EM.LIBMultipleApproveInfo).GetMultipleInfo(ApproveSet, CurStep, CurRole)
	s MultipleNum=+$p(val,"^",1)
	s MultipleDefineDR=$p(val,"^",2)
	if MultipleDefineDR="" q 0  ;未设置多方审批定义正常提交
	s SourceType=$p($g(^DHCEQCCode("DHCEQCMultipleDefine",MultipleDefineDR)),"^",2)
	if SourceType =0  d ;科室
	.s SourceID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID")) ; 4
	if (SourceType=1) d ;人员
	.s SourceID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	if (SourceType=2)   d ;角色
	.s SourceID=CurRole

	s MARowID=+$o(^DHCEQMultipleApproveInfo(0,"SourceID",ApproveType,BusID,SourceID,0))
	i MARowID=0 q -1  ;
	i $p($g(^DHCEQMultipleApproveInfo(MARowID)),"^",6)="" q 0
	q -1
}

/// w ##Class(web.DHCEQ.EM.LIBMultipleApproveInfo).ClearMultipleApproveInfo(1,11)
ClassMethod ClearMultipleApproveInfo(BusRowID, ApproveType)
{
	new (BusRowID, ApproveType)
	&SQL(Select Count(*) Into :MACount From SQLUSER.DHC_EQMultipleApproveInfo Where  MA_ApproveTypeDR = :ApproveType and MA_BusID=:BusRowID)
	i MACount=0 Quit 0
	&SQL(Update SQLUSER.DHC_EQMultipleApproveInfo set MA_ApproveListDR=NULL where MA_ApproveTypeDR = :ApproveType and MA_BusID=:BusRowID)
	i SQLCODE Quit SQLCODE
	Quit 0
}

/// w ##Class(web.DHCEQ.EM.LIBMultipleApproveInfo).GetMultipleApproveLoc(19,"1") 
ClassMethod GetMultipleApproveLoc(BusRowID, ApproveType)
{
	new (BusRowID, ApproveType)
	s LocIDs=""
	s SourceID=0
	for  s SourceID=$o(^DHCEQMultipleApproveInfo(0,"SourceID",ApproveType,BusRowID,SourceID)) quit:SourceID=""  d
	.s rowid=0
	.for  s rowid=$o(^DHCEQMultipleApproveInfo(0,"SourceID",ApproveType,BusRowID,SourceID,rowid)) quit:rowid=""  d
	..s TInvalidFlag=$p($g(^DHCEQMultipleApproveInfo(rowid)),"^",7)
	..q:TInvalidFlag="Y"
	..q:$p($g(^DHCEQMultipleApproveInfo(rowid)),"^",6)'=""
	..if LocIDs'="" s LocIDs=LocIDs_","
	..s LocIDs=LocIDs_SourceID
	
	q LocIDs
}

/// w ##Class(web.DHCEQ.EM.LIBMultipleApproveInfo).GetPreApprovreInfo(19,"1",2,1,2)
ClassMethod GetPreApprovreInfo(BusRowID, ApproveType, ApproveSet, RoleStep, CurRole)
{
	new (BusRowID, ApproveType,ApproveSet, RoleStep, CurRole)
	s rowid=0
	s AFRowID=""
	f  s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,RoleStep,rowid))  q:((rowid="")||(AFRowID'=""))  d
	.s role=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",2)
	.i CurRole=role s AFRowID=rowid
	
	s Action=$p(^DHCEQCCode("DHCEQCApproveFlow",AFRowID),"^",9)
	s id=""
	s FlowDR=""
	For  Set id=$Order(^DHCEQApproveList(0,"Source",ApproveType,BusRowID,id),-1)  Quit:(id="")||(FlowDR'="")  Do
	.q:Action=$Piece($Get(^DHCEQApproveList(id)),"^",11)
	.q:$Piece($Get(^DHCEQApproveList(id)),"^",10)'="N"
	.s FlowDR=id
	s PreRole=""
	s PreStep=0
	if FlowDR'=""
	{
		s PreRole=$Piece($Get(^DHCEQApproveList(FlowDR)),"^",5)
		s PreStep=$Piece($Get(^DHCEQApproveList(FlowDR)),"^",9)
	}
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, BusRowID, PreStep, PreRole)
	q ApproveFlow_"^"_ApproveSet_"$"_PreRole
}

/// Add by QW20191213 begin 需求号:1135943  解决联合科室不显示科室数量错误
/// 获取联合科室数量。
/// 返回值 num-联合科室数量
/// w ##Class(web.DHCEQ.EM.LIBMultipleApproveInfo).UnitLocNum(1,"1")
ClassMethod UnitLocNum(BusID As %String = "", ApproveTypeDR As %String = "")
{
	if BusID="" q 0
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType(ApproveTypeDR)
	s num=0
	s SourceID=0
	for  s SourceID=$o(^DHCEQMultipleApproveInfo(0,"SourceID",ApproveType,BusID,SourceID)) quit:SourceID=""  d
	.s rowid=0
	.s flag=0
	.for  s rowid=$o(^DHCEQMultipleApproveInfo(0,"SourceID",ApproveType,BusID,SourceID,rowid)) quit:rowid=""  d
	..s TInvalidFlag=$p($g(^DHCEQMultipleApproveInfo(rowid)),"^",7)
	..q:TInvalidFlag="Y"
	..s flag=1
	.q:flag=0
	.s num=num+1
	q num
}

}
