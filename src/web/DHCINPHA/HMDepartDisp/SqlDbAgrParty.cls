Import sqluser

/// Description:科室协定方申请以及发药表操作相关(采用面向对象的形式)
/// Creator:    hulihua
/// CreateDate: 2017-12-15
/// Table:      DHC_PhaAgrPartyReq-科室协定方申请主表、DHC_PhaAgrPartyReqItm-科室协定方申请子表
Class web.DHCINPHA.HMDepartDisp.SqlDbAgrParty Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCPHAAGRPAREQ";

/// Description:插入科室协定方申请主表
/// Creator:	hulihua
/// CreateDate:	2017-12-15
/// Table:      DHC_PhaAgrPartyReq
/// Input:		SqlStr-药房ID、病区ID、申请人ID、申请单状态
/// Output:
/// Return：    0,成功
/// 			-1,	操作表失败
/// Others: 
/// w ##class(web.DHCINPHA.HMDepartDisp.SqlDbAgrParty).InsertAgrPartyReq("4^9")
ClassMethod InsertAgrPartyReq(SqlStr)
{
	n (SqlStr)
	q:SqlStr="" -1
	s ret=0
	s ret=##class(web.DHCST.Common.AppCommon).Lock("AgrPartyReqNo")  
    q:ret'=0 -2				;加锁失败
	s AppName=..%GetParameter("AppName")
	s cellSplit="!!"
	s PhaLocId=$p(SqlStr,cellSplit,1)
	s WardLocId=$p(SqlStr,cellSplit,2)
	s AgrPartyReqNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,"",WardLocId)
    i AgrPartyReqNo="" d ##class(web.DHCST.Common.AppCommon).UnLock("AgrPartyReqNo")
    q:AgrPartyReqNo="" -3   	;生成申请单号失败
    q:$D(^DHCPHAAPRi("StatusWardLocPhLoc","R",WardLocId,PhaLocId)) -4
	s ReqUserId=$p(SqlStr,cellSplit,3)
	s RStatus=$p(SqlStr,cellSplit,4)
	s FromWardLoc=$p(SqlStr,cellSplit,5)
	s AgrReqDate=+$h
	s AgrReqTime=$p($h,",",2)
	;初始化一个对象
	s obj=##class(User.DHCPhaAgrPartyReq).%New()
	;对创建的对象的每一个属性进行赋值
	d obj.PHAAPRPHALocDRSetObjectId(PhaLocId)
	d obj.PHAAPRWardLocDRSetObjectId(WardLocId)
	d obj.PHAAPRFromWardLocDRSetObjectId(FromWardLoc)
	d obj.PHAAPRAgrReqUserDRSetObjectId(ReqUserId)
	s obj.PHAAPRAgrReqDate=AgrReqDate
	s obj.PHAAPRAgrReqTime=AgrReqTime
	s obj.PHAAPRStatus=RStatus
	s obj.PHAAPRAgrReqNo=AgrPartyReqNo
	;持久化对象
	s result=obj.%Save()
	d obj.%Close()
	s MainId=obj.%Id()
	d ##class(web.DHCST.Common.AppCommon).UnLock("AgrPartyReqNo")
	i $$$ISERR(result) d
	.s obj=""
	.s ret=-5
    s obj=""
    q:ret'=0 $SYSTEM.Status.GetErrorText(result)
	q MainId
}

/// Description:发药更新科室协定方申请主表信息
/// Creator:	hulihua
/// CreateDate:	2017-12-20
/// Table:      DHC_PhaAgrPartyReq
/// Input:		SqlStr-协定方申请主表ID^发放人ID^库存转移主表		
/// Output:		
/// Return：	大于0-成功，小于0-失败 
/// w ##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).UpdatePhaMedBroth("1","^^4^")
ClassMethod UpdateAgrPartyReq(SqlStr As %String) As %String
{
	n (SqlStr)
	s PhaAprId=$p(SqlStr,"^",1)
	q:PhaAprId="" -1
	s DispUserId=$p(SqlStr,"^",2)
	s InistrfDr=$p(SqlStr,"^",3)
	s DispDate=+$h,DispTime=$p($h,",",2)
	s Status="D"
	s ret=0
	;初始化一个对象
	s obj=##class(User.DHCPhaAgrPartyReq).%OpenId(PhaAprId)
	s obj.PHAAPRAgrDispDate=DispDate
	s obj.PHAAPRAgrDispTime=DispTime
	d obj.PHAAPRAgrDispUserDRSetObjectId(DispUserId)
	d obj.PHAAPRInIsTrfDRSetObjectId(InistrfDr)
	s obj.PHAAPRStatus=Status
	;持久化对象
	s result=obj.%Save()
	d obj.%Close()
	s obj=""
	i $$$ISERR(result) d
	.s ret=-2
    q:ret'=0 ret
	q 0
}

/// Description:插入科室协定方申请子表
/// Creator:	hulihua
/// CreateDate:	2017-12-25
/// Table:      DHC_PhaAgrPartyReqItm
/// Input:		PhaAprId-申请主表ID、DetSqlStr-科室协定方医嘱项ID^积累数量^申请数量		
/// Output:		
/// Return：	0-成功，非0-失败 
/// Others: 
/// w ##class(web.DHCINPHA.HMDepartDisp.SqlDbAgrParty).InsertAgrPartyReqItm("1||1")
ClassMethod InsertAgrPartyReqItm(PhaAprId As %String, DetSqlSt As %String) As %String
{
	n (PhaAprId,DetSqlSt)
	q:PhaAprId="" -6
	s ArcimDr=$p(DetSqlSt,"^",1)
	q:ArcimDr="" -7
	s DspQty=+$p(DetSqlSt,"^",2)
	s ReqQty=+$p(DetSqlSt,"^",3)
	q:ReqQty>DspQty -8
	s err=0
	;保存对象
    s obj=##class(User.DHCPhaAgrPartyReqItm).%New(PhaAprId)
    d obj.PHAAPRIPHAAPRParRefSetObjectId(PhaAprId)
	d obj.PHAAPRIARCIMDRSetObjectId(ArcimDr)
	s obj.PHAAPRIAccQty=DspQty
	s obj.PHAAPRIReqQty=ReqQty
	;持久化对象
	s result=obj.%Save()
	d obj.%Close()
	s obj=""
	i $$$ISERR(result) d
	.s err=-9
    q:err<0 $SYSTEM.Status.GetErrorText(result)
	q err
}

/// Description:发药更新科室协定方申请子表信息
/// Creator:	hulihua
/// CreateDate:	2017-12-20
/// Table:      DHC_PhaAgrPartyReqItm
/// Input:		SqlStr-协定方申请子表ID^实发数量		
/// Output:		
/// Return：	大于0-成功，小于0-失败 
/// w ##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).UpdateAgrPartyReqItm("1","^^4^")
ClassMethod UpdateAgrPartyReqItm(SqlStr As %String, SqlType As %String = "") As %String
{
	n (SqlStr,SqlType)
	s PhaApriId=$p(SqlStr,"^",1)
	q:PhaApriId="" -1
	s DispQty=$p(SqlStr,"^",2)
	s ReqQty=$p(SqlStr,"^",3)
	s UpReqIUserId=$p(SqlStr,"^",4)
	s ret=0
	;初始化一个对象
	s obj=##class(User.DHCPhaAgrPartyReqItm).%OpenId(PhaApriId)
	i SqlType="" d
	.s obj.PHAAPRIDispQty=DispQty
	e  d
	.s obj.PHAAPRIReqQty=ReqQty
	.s obj.PHAAPRIUpReqDetDate=+$h
	.s obj.PHAAPRIUpReqDetTime=$p($h,",",2)
	.d obj.PHAAPRIUpReqDetUserDRSetObjectId(UpReqIUserId)
	;持久化对象
	s result=obj.%Save()
	d obj.%Close()
	s obj=""
	i $$$ISERR(result) d
	.s ret=-2
    q:ret'=0 ret
	q 0
}

/// Description:科室协定方发药处理打包表和在途数
/// Creator:	hulihua
/// CreateDate:	2017-12-16
/// Table:      DHC_OEDispensing、DHC_OEDispBatch、DHC_IncReservedQtyDetail
/// Input:		dspId-打包表ID、user-发药人ID、RecLocID-发药科室ID	
/// Output:		
/// Return：	0-成功，非0-失败
/// Others: 
/// w ##class(web.DHCINPHA.HMDepartDisp.SqlDbAgrParty).UpdStatusForDODISS("90","1","96")
ClassMethod UpdStatusForDODISS(dspId As %String, userId As %String, RecLocID As %String) As %String
{
	n (dspId,userId,RecLocID)
	s err=0
	q:dspId="" err
	s HospID=$p(^CTLOC(RecLocID),"^",22)
	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//价格规则
	s dd=+$h,tt=$p($h,",",2),type="P",code="C" 
	s $ZT="Error^DHCSTERROR"
	ts ;开启事务
	;更新打包主表
	&SQL(Update DHC_OEDispensing Set DSP_Status=:code,DSP_Date=:dd,DSP_Time=:tt,
	DSP_Type=:type,DSP_User=:userId Where DSP_RowId=:dspId)
	i SQLCODE'=0  d
	.s err=-1
	i err'=0 tro
    q:err'=0 err
	;更新打包子表
	;s dspCh=$o(^DHCOEDISQTY(dspId,"I",""),-1)
	;i dspCh'="" d
    ;.&SQL(Update DHC_OEDispBatch Set DSPB_Status=:code Where DSPB_DSP_ParRef=:dspId)
	;.i SQLCODE'=0  d
	;..s err=-2
	;.
	;清在途数
	i RuleFlag'=3 d
	.s dspCh=0
	.f  s dspCh=$o(^DHCOEDISQTY(dspId,"I",dspCh)) q:(dspCh="")||(err'=0)  d
	..q:'$d(^DHCOEDISQTY(dspId,"I",dspCh))
	..s dspQty=-$p($g(^DHCOEDISQTY(dspId,"I",dspCh)),"^",2)
	..s inci=$p($g(^DHCOEDISQTY(dspId,"I",dspCh)),"^",5)
	..s inciCh=$o(^INCI("IL_LOC",RecLocID,inci,""))
	..s incil=inci_"||"_inciCh
	..d ##class(web.DHCST01).UPDINVRESQTY(inci,RecLocID,dspQty)
	..s SqlStr=incil_"^"_3_"^"_dspQty_"^"_""_"^"_dspId_"^"_RecLocID
	..s Ret=##Class(User.DHCIncReservedQtyDetail).Insert(SqlStr)
	.
	e  d
	.s minusret=##class(web.DHCST01).MinusResQtyByDspBatch(dspId)
	.s:minusret'=0 err=-3
 	i err'=0 tro
    q:err'=0 err
	tc	
	q err
}

}
