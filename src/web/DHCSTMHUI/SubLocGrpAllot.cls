Import sqluser

/// Descript:	根据发放台帐记录,生成专业组分配单
/// Creator:    wangjiabin
/// CreateDate: 2014-02-14
Class web.DHCSTMHUI.SubLocGrpAllot Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTSLGALLOTM";

/// Descript:   插入分配主表信息
/// Creator:    wangjiabin
/// CreateDate: 2014-02-14
/// Table:		DHC_SubLocGrpAllot
/// Input:		科室id^专业组id^制单人^完成标志^类组
/// Output:     
/// Return：成功:0
/// -1:信息为空
/// -3   ;保存失败
ClassMethod Insert(MainInfo) As %Library.String
{
    n (MainInfo)
    
    s LocId=$p(MainInfo,"^",1)
    s GrpId=$P(MainInfo,"^",2)
    s CreateUser=$p(MainInfo,"^",3)
    s CreateDate=+$h
    s CreateTime=$p($h,",",2)
    s Complete=$p(MainInfo,"^",4)
    s StkGrpId=$p(MainInfo,"^",5)
    s AllotMon=$p(MainInfo,"^",6)
    s AllotMon=$zdh(AllotMon,3)
    ;&sql(select LAST_DAY(:AllotMon) into :AllotMon)
    ;2017-06-30 分配月份是当前月的,按+$h记录,否则分配月份的最后一天记录
    i $p($zd(AllotMon,3),"-",1,2)=$p($zd(+$h,3),"-",1,2) d
    .s AllotMon=+$h
    e  d
    .s AllotMon=..sssLASTDAY(AllotMon)		;月份最后一天
    s AuditFlag="N"
    s StkType=..sssCode()
    ;
    s AppName=..%GetParameter("AppName")
    ;生成单号需加锁
    s ret=##class(web.DHCSTMHUI.Common.AppCommon).Lock("DHCSTMGrpAllotNo")  
    q:ret'=0 -99  ;加锁失败
    ;
    s AllotNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,StkGrpId,LocId)
    i AllotNo="" d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock("DHCSTMGrpAllotNo")
    q:AllotNo="" -2   ;生成单号失败
    ;
    s Err=0
    &sql(insert into DHC_SubLocGrpAllot(SLGA_No,SLGA_Date,SLGA_Time,SLGA_SSUSR_DR,
    	SLGA_CTLOC_DR,SLGA_UserGrp_DR,SLGA_Completed,SLGA_SCG_DR,SLGA_StkType,SLGA_Month) 
         values (:AllotNo,:CreateDate,:CreateTime,:CreateUser,
         :LocId,:GrpId,:Complete,:StkGrpId,:StkType,:AllotMon))
    i SQLCODE'=0  d
    .s Err=-3
    .
    d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock("DHCSTMGrpAllotNo")
    q:Err'=0 -3    ;保存分配单失败
    ;
    q $p($g(%ROWID),$c(1))
}

/// 设置(或取消)分配单完成
/// Author:wangjiabin
/// Date:2014-02-20
/// Argu:
///  slga - 分配单主表 rowid
///  completed - 完成标志(Y,N)
/// Return:
/// 0 - success
/// <0 - failure
ClassMethod SetComplete(slga As %String, completed As %String) As %String
{
	n (slga,completed)
	q:slga="" -100
	q:completed="" -100
	q:'$d(^DHCSLGA(slga)) -100
	//加锁
	s lockName=..%GetParameter("AppName")_slga
	i ..sssLock(lockName)<0 -99
	s slgaScale=0
	&sql(select sum(nvl(SLGAS_ScaleValue,0)) into :slgaScale from DHC_SubLocGrpAllotScale where SLGAS_SLGA_Parref=:slga)
	i +slgaScale=0 d ..sssLock(lockName) q -1	//权重之和为零时,不可完成
    s CompFlag=$p(^DHCSLGA(slga),"^",10)
    s AuditFlag=$p(^DHCSLGA(slga),"^",11)
	s Err=0
	i (completed="Y")&(CompFlag="Y") d ..sssLock(lockName) q -2	//已经完成
	i (completed="N")&(AuditFlag="Y") d ..sssLock(lockName) q -3	//已经审核,不许取消完成
	q:Err'=0 Err
	
	&sql(update DHC_SubLocGrpAllot set SLGA_Completed=:completed where %id=:slga)
	i SQLCODE'=0  d ..sssLock(lockName) q -4
	d ..sssLock(lockName)
	q 0
}

/// Descript:   删除分配单
/// Creator:    wangjiabin
/// CreateDate: 2014-02-18
/// Input:      
/// Output:     
/// Return：0:成功 
///  -1     ;分配单已经完成，不能删除
///  -2     ;分配单已经审核，不能删除
///  -3		;删除失败
ClassMethod Delete(slga) As %Library.String
{
    n (slga)
    ;
    q:slga="" ""
    q:'$d(^DHCSLGA(slga)) 0   ;已经删除
    s CompFlag=$p(^DHCSLGA(slga),"^",10)
    s AuditFlag=$p(^DHCSLGA(slga),"^",11)
    q:CompFlag="Y" -1       ;分配单已经完成，不能删除
    q:AuditFlag="Y" -2      ;分配单已经审核，不能删除
    ;
    s $ZT=..sssError()
    s Err=0
    &sql(Delete from DHC_SubLocGrpAllot where %id=:slga) 
    i SQLCODE'=0 tro  d
    .s Err=-3
    .
    q:Err'=0 -3   ;删除分配单失败
    ;
    q 0
}

/// Descript:   审核分配单
/// Creator:    wangjiabin
/// CreateDate: 2014-02-23
/// Input:      
/// Output:     
/// Return：0:成功 
///  <0 审核失败
ClassMethod Audit(slga, UserId) As %Library.String
{
	n (slga,UserId)
    i slga="" q -101
    q:'$d(^DHCSLGA(slga)) -101       ;分配单不存在
    ;
    s lockName=..%GetParameter("AppName")_slga
    s ret=..sssLock(lockName)  
    q:ret'=0 -99  ;加锁失败
    ;
    s complete=$p(^DHCSLGA(slga),"^",10)
    i complete'="Y" d ..sssUnLock(lockName)
    q:complete'="Y" -102	;分配单尚未完成，不能审核
    s AuditFlag=$p(^DHCSLGA(slga),"^",11)
    i AuditFlag="Y" d ..sssUnLock(lockName)
    q:AuditFlag="Y" 0       ;已经审核
    ;
    ts
    s $ZT=..sssError()		;增加错误处理
    s AuditFlag="Y",auditDate=+$h,auditTime=$p($h,",",2)
    &sql(update DHC_SubLocGrpAllot set SLGA_AuditFlag=:AuditFlag,SLGA_AuditDate=:auditDate,
    	SLGA_AuditTime=:auditTime,SLGA_SSUSR_Audit_DR=:UserId where %id=:slga)
    i SQLCODE d ..sssUnLock(lockName) tro  q -105
    s slgaRpAmt=0,slgaSpAmt=0,slgaScale=0
	&sql(select sum(SLGAI_RpAmt),sum(SLGAI_SpAmt) into :slgaRpAmt,:slgaSpAmt
		from DHC_SubLocGrpAllotItm where SLGAI_SLGA_Parref=:slga)
	s slgaScale=0
	&sql(select sum(nvl(SLGAS_ScaleValue,0)) into :slgaScale from DHC_SubLocGrpAllotScale where SLGAS_SLGA_Parref=:slga)
	i slgaScale=0 d ..sssUnLock(lockName) tro  q -103
    s ret=0
    s ch=0
    s Err=0
    f  s ch=$o(^DHCSLGA(slga,"S",ch)) q:(ch="")!(Err'=0)  d
    .s scale=$p(^DHCSLGA(slga,"S",ch),"^",2)
    .s slgasRpAmt=scale/slgaScale*slgaRpAmt
    .s slgasRpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(slgasRpAmt,"")
    .s slgasSpAmt=scale/slgaScale*slgaSpAmt
    .s slgasSpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(slgasSpAmt,"")
    .s slgas=slga_"||"_ch
    .&sql(update DHC_SubLocGrpAllotScale set SLGAS_ScaleRpAmt=:slgasRpAmt,SLGAS_ScaleSpAmt=:slgasSpAmt where %id=:slgas)
	.i SQLCODE d
	..d  tro
	..s Err=-104
	q:Err<0 Err
	tc
	
	q 0
}

/// 取专业组对应人员
/// Author:wangjiabin
/// Date:2014-02-20
/// Argu:
///  userGrp - 专业组rowid
/// Return:
///  
ClassMethod GetGroupUser(userGrp As %String) As %String
{
	n (userGrp)
	q:userGrp="" ""
	
	s count=0
	s TitleStr="UserId^UserName"
	w "{rows:["
	s ch=0
	f  s ch=$o(^DHCLUG(userGrp,"I",ch)) q:ch=""  d
	.s UserId=$p(^DHCLUG(userGrp,"I",ch),"^",1)
	.s DateFrom=$p(^DHCLUG(userGrp,"I",ch),"^",2)
	.s DateTo=$p(^DHCLUG(userGrp,"I",ch),"^",3)
	.q:(DateFrom'="")&&(DateFrom>+$h)
	.q:(DateTo'="")&&(DateTo<+$h)
	.s count=count+1
	.s UserName=$p(^SSU("SSUSR",UserId),"^",2)
	.
	.s DataStr=UserId_"^"_UserName
	.i count=1 d
	..w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	.e  d
	..w ","_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	w "],results:"_count_"}"
}

/// 返回分配单主表信息
/// Author:wangjiabin
/// Date:2014-02-20
/// Argu:
///  slga - 分配单主表rowid
/// Return:
/// 
ClassMethod Select(slga As %String) As %String
{
	n (slga)
	q:slga="" ""
	s slgaInfo=^DHCSLGA(slga)
	s slgaNo=$p(slgaInfo,"^",1)
	s createDate=$p(slgaInfo,"^",2)
	s:createDate'="" createDate=..DL2H(createDate)
	s createTime=$p(slgaInfo,"^",3)
	s:createTime'="" createTime=..TL2H(createTime)
	s createUser=$p(slgaInfo,"^",4)
	s (createUserName,LocDesc,LugDesc)=""
	s:createUser'="" createUserName=$p(^SSU("SSUSR",createUser),"^",2)
	s locId=$p(slgaInfo,"^",5)
	s:locId'="" LocDesc=$p(^CTLOC(locId),"^",2)
	s Lug=$p(slgaInfo,"^",6)
	s:Lug'="" LugDesc=$p(^DHCLUG(Lug),"^",2)
	
	s auditDate=$p(slgaInfo,"^",7)
	s:auditDate'="" auditDate=..DL2H(auditDate)
	s auditTime=$p(slgaInfo,"^",8)
	s:auditTime'="" auditTime=..TL2H(auditDate)
	s auditUser=$p(slgaInfo,"^",9)
	s (auditUserName,scgDesc)=""
	s:auditUser'="" auditUserName=$p(^SSU("SSUSR",auditUser),"^",2)
	s compFlag=$p(slgaInfo,"^",10)
	s:compFlag="" compFlag="N"
	s auditFlag=$p(slgaInfo,"^",11)
	s:auditFlag="" auditFlag="N"
	s scg=$p(slgaInfo,"^",12)
	s:scg'="" scgDesc=$p(^DHCSCG(scg),"^",2)
	s AllotMon=$p(slgaInfo,"^",14)
	s:AllotMon'="" AllotMon=$p($zd(AllotMon,3),"-",1,2)
	
	s Data1=slga_"^"_slgaNo_"^"_createDate_"^"_createTime_"^"_createUser_"^"_createUserName_"^"_locId_"^"_locDesc_"^"_Lug_"^"_LugDesc
	s Data2=auditDate_"^"_auditTime_"^"_auditUser_"^"_auditUserName_"^"_compFlag_"^"_auditFlag_"^"_scg_"^"_scgDesc_"^"_AllotMon
	s MainData=Data1_"^"_Data2
	q MainData
}

/// 查询分配单
/// Author:	wangjiabin
/// Date:	2014-02-19
/// Argu: 
/// 	Start,Limit,Sort,Dir,StrParam:开始日期^结束日期^科室id^专业组id^完成标志^审核标志
/// Return:
///    数据串(json格式)
ClassMethod Query(Start As %String, Limit As %String, Sort As %String, Dir As %String, StrParam As %String) As %String
{
 	n (Start,Limit,Sort,Dir,StrParam)
 	
 	s sd=$p(StrParam,"^",1)
 	s ed=$p(StrParam,"^",2)
 	s loc=$p(StrParam,"^",3)
 	s userGrp=$p(StrParam,"^",4)
 	s comp=$p(StrParam,"^",5)
 	s audit=$p(StrParam,"^",6)
 	s stkGrp=$p(StrParam,"^",7)
 	s dateFlag=$p(StrParam,"^",8)	;按审核日期查询
 	q:sd="" $$$OK
 	q:ed="" $$$OK
 	
 	s sd=$zdh(sd,3)
 	s ed=$zdh(ed,3)
	s StrSql="select SLGA_Rowid Rowid,SLGA_No slgaNo,SLGA_Date CreateDate,SLGA_Time CreateTime,SLGA_SSUSR_DR UserId,SLGA_SSUSR_DR->SSUSR_Name UserName,"
	_"SLGA_CTLOC_DR LocId,SLGA_CTLOC_DR->CTLOC_Desc LocDesc,SLGA_UserGrp_DR LUGId,SLGA_UserGrp_DR->LUG_GroupDesc LUGDesc,nvl(SLGA_Completed,'N') CompFlag,"
	_"SLGA_AuditDate AuditDate,SLGA_AuditTime AuditTime,SLGA_SSUSR_Audit_DR AuditUser,SLGA_SSUSR_Audit_DR->SSUSR_Name AuditUserName,"
	_"nvl(SLGA_AuditFlag,'N') AuditFlag, SLGA_SCG_DR SCG,SLGA_SCG_DR->SCG_Desc ScgDesc, SLGA_StkType StkType,SLGA_Month AllotMon"
	_" From DHC_SubLocGrpAllot"
	i dateFlag="Y" d
	.s StrSql=StrSql_" where SLGA_AuditDate between "_sd_" and "_ed
	e  d
	.s StrSql=StrSql_" where SLGA_Date between "_sd_" and "_ed
    
	s OrderField=""
    s:Sort="slgaNo" OrderField="slgaNo"
    s:Sort="CreateDate" OrderField="CreateDate"
    s:Sort="UserName" OrderField="UserName"
    s:Sort="AuditUserName" OrderField="AuditUserName"
    s:Sort="ScgDesc" OrderField="ScgDesc"
    ;
    s:Dir'="" Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="ASC"
    i OrderField'=""  d
    .s StrSql=StrSql_" order by "_OrderField_" "_Dir
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	;
	If err  q ""
	s end = Start+Limit
	s TitleStr="slga^slgaNo^LocId^LocDesc^LUGId^LUGDesc^CreateDate^CreateTime^UserName^CompFlag"
	s TitleStr=TitleStr_"^AuditFlag^AuditDate^AuditTime^AuditUserName^ScgDesc^AllotMon"
	s count = 0
	w "{rows:["
	While(result.Next())
	{
		s StkType = result.Data("StkType")
		continue:StkType'=..sssCode()
		s CompFlag = result.Data("CompFlag")
		continue:(comp'="")&&(comp'=CompFlag)
		s AuditFlag = result.Data("AuditFlag")
		continue:(audit'="")&&(audit'=AuditFlag)
		
		s slga = result.Data("Rowid")
		s slgaNo = result.Data("slgaNo")
		s CreateDate = result.Data("CreateDate")
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s CreateTime = result.Data("CreateTime")
		s:CreateTime'="" CreateTime=..TL2H(CreateTime)
		s UserId = result.Data("UserId")
		s UserName = result.Data("UserName")
		s LocId = result.Data("LocId")
		continue:(loc'="")&&(loc'=LocId)
		s LocDesc = result.Data("LocDesc")
		s LocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(LocDesc)
		s LUGId = result.Data("LUGId")
		continue:(userGrp'="")&&(userGrp'=LUGId)
		s LUGDesc = result.Data("LUGDesc")

		s AuditDate = result.Data("AuditDate")
		s:AuditDate'="" AuditDate=..DL2H(AuditDate)
		s AuditTime = result.Data("AuditTime")
		s:AuditTime'="" AuditTime=..TL2H(AuditTime)
		s AuditUser = result.Data("AuditUser")
		s AuditUserName = result.Data("AuditUserName")
		
		s SCG = result.Data("SCG")
		continue:(stkGrp'="")&&(stkGrp'=SCG)
		s SCGDesc = result.Data("ScgDesc")
		s AllotMon = result.Data("AllotMon")
		s:AllotMon'="" AllotMon=$p($zd(AllotMon,3),"-",1,2)
		
		s count = count+1
		continue:count<(Start+1)
		continue:count>end
		
		s DataStr=slga_"^"_slgaNo_"^"_LocId_"^"_LocDesc_"^"_LUGId_"^"_LUGDesc_"^"_CreateDate_"^"_CreateTime_"^"_UserName_"^"_CompFlag
		s DataStr=DataStr_"^"_AuditFlag_"^"_AuditDate_"^"_AuditTime_"^"_AuditUserName_"^"_SCGDesc_"^"_AllotMon
		
		i count=(Start+1) d
		.w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
		e  d
		.w ","_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	}
	w "],results:"_count_"}"
}

}
