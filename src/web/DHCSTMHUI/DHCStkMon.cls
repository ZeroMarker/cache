Import sqluser

Class web.DHCSTMHUI.DHCStkMon Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTKMONREPM";

Parameter TransTypeStr [ Final ] = "G^R^T^K^A^C^L^D^MF^MH^MP^MY^S^Z^M^X^MDP^MDY";

/// 插入或更新月报一条主表记录
/// Author:zhwh
/// Date:2012-10-31
/// Argu:
/// 	sm  - 月报主表rowid
/// 	data -月报主表信息字符串("^"分隔)
/// Return:
/// 
ClassMethod Update(sm As %String, Paramsobj As %String, UserId As %String) As RtnObj
{
	n (sm,Paramsobj,UserId)
	s RtnObj=##class(RtnObj).%New()
	s LocId=Paramsobj.%Get("LocId")	//科室rowid(必需)
	s CurMonth=Paramsobj.%Get("CurMonth")	//月份
	s FrDate=Paramsobj.%Get("CurStartDate")	//起始日期
	s FrTime=Paramsobj.%Get("CurStartTime")	//起始时间
	s ToDate=Paramsobj.%Get("CurEndDate")	//截止日期
	s ToTime=Paramsobj.%Get("CurEndTime")	//截止时间
	
	s LocDesc=$p(^CTLOC(LocId),"^",2)
	s CurMonth=..DH2L(CurMonth)
	s FrDate=..DH2L(FrDate)
	s ToDate=..DH2L(ToDate)
	i FrTime="" s FrTime="0:00:00"
	i ToTime="" s ToTime="23:59:59"
	i FrTime[":" s FrTime=..TH2L(FrTime)
	i ToTime[":" s ToTime=..TH2L(ToTime)
	
	s AppName=..#AppName
	s ret=##class(web.DHCSTMHUI.Common.AppCommon).Lock(AppName_sm)
	i ret'=0 d RtnObj.Err(-11,"",LocDesc_"加锁失败！") q RtnObj
	
	i sm="" d
	.s obj=##class(User.DHCStkMon).%New()
	.s MonNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"",LocId)
	.i MonNo="" d RtnObj.Err(-12,"",LocDesc_"生成单号失败！") q
	.s obj.DHCSMStkMonNo=MonNo
	e  d
	.s obj=##class(User.DHCStkMon).%OpenId(sm)
	.i $ISOBJECT(obj)  d obj.%Reload()
	.e  d RtnObj.Err(-13,"",LocDesc_"生成月报失败!") q
	i RtnObj.success'=0 d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(AppName_sm) q RtnObj
	
	s obj.DHCSMCreatedDate= +$h
	s obj.DHCSMCreatedTime=$p($h,",",2)
	s obj.DHCSMCreatedUserDR=##class(User.SSUser).%OpenId(UserId)
	s obj.DHCSMCTLOCDR=##class(User.CTLoc).%OpenId(LocId)
	s obj.DHCSMFromDate=FrDate
	s obj.DHCSMFromTime=FrTime
	s obj.DHCSMToDate=ToDate
	s obj.DHCSMToTime=ToTime
	s obj.DHCSMMonth=CurMonth
	s obj.DHCSMAcctVoucherStatus="D"
	s obj.DHCSMAcctVoucherStatusRec="D"
	s obj.DHCSMStkType="M"
	s ret=obj.%Save()
	i $$$ISERR(ret) d RtnObj.Err(-14,"",LocDesc_"生成月报失败!")
	
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(AppName_sm)
	q:RtnObj.success'=0 RtnObj
	
	s RtnObj.rowid=obj.%Id()
	q RtnObj
}

/// 删除月报记录
/// Author:zhwh
/// Date:2012-10-31
/// Argu:
///  sm - 月报主表rowid
/// Return
/// 0 - 可以
/// <0 - 不可以
ClassMethod Delete(sm As %String) As %String
{
  s appName=..%GetParameter("AppName")

  s RtnObj=##class(RtnObj).%New()
  i sm="" d RtnObj.Err(-1,"","月报记录不存在!","",0) q RtnObj.Json()
  //判断是否允许删除
  i ##class(web.DHCSTMHUI.Common.AppCommon).Lock(appName_sm)<0 d RtnObj.Err(-2,"","加锁失败!") q RtnObj.Json()
  i ..AllowDel(sm)<0 d ..uLock(sm) d RtnObj.Err(-3,"","非最后一期月报,不允许删除!","",0) q RtnObj.Json()
  //判断是否已提交(已提交不能删除)
  i ..CheckDone(sm)<0 d ..uLock(sm) d RtnObj.Err(-4,"","月报已提交,不允许删除!","",0) q RtnObj.Json()
  s err=0
  tstart
  //删除DHC_StkMonStat
  &sql(delete from dhc_stkmonstat where smrd_smr_dr->smr_sm_parref=:sm)
  i SQLCODE<0  d
  . d ..uLock(sm)
  . trollback
  . s err=-2
  i err<0 d RtnObj.Err(-5,"","删除DHC_StkMonStat失败,"_SQLCODE) q RtnObj.Json()
  //删除DHC_StkMonStatIn
  &sql(delete from dhc_stkmonstatIn where smrdi_smr_dr->smr_sm_parref=:sm)
  i SQLCODE<0  d
  . d ..uLock(sm)
  . trollback
  . s err=-3
  i err<0 d RtnObj.Err(-6,"","删除DHC_StkMonStatIn失败,"_SQLCODE) q RtnObj.Json()
  //删除DHC_StkMon,DHC_StkMonReport
  &sql(delete from dhc_stkmon where %id=:sm)
  i SQLCODE'=0  d
  . d ..uLock(sm)
  . trollback
  . s err=-4
  i err<0 d RtnObj.Err(-7,"","删除DHC_StkMon失败,"_SQLCODE) q RtnObj.Json()
  //删除DHC_StkMonSum_TransLoc
  &sql(delete from DHC_StkMonSum_TransLoc where SUMTL_SM_DR=:sm)
  i SQLCODE<0  d
  . d ..uLock(sm)
  . trollback
  . s err=-5
  i err<0 d RtnObj.Err(-8,"","删除DHC_StkMonSum_TransLoc失败,"_SQLCODE) q RtnObj.Json()
   //删除DHC_StkMonSumIn_CatGrp
  &sql(delete from DHC_StkMonSumIn_CatGrp where SUMCG_SM_DR=:sm)
  i SQLCODE<0  d
  . d ..uLock(sm)
  . trollback
  . s err=-6
  i err<0 d RtnObj.Err(-9,"","删除DHC_StkMonSumIn_CatGrp失败,"_SQLCODE) q RtnObj.Json()
   //删除DHC_StkMon_VoucherStatus
  ;&sql(delete from DHC_StkMon_VoucherStatus where VCH_SM_DR=:sm)
  i SQLCODE<0  d
  . d ..uLock(sm)
  . trollback
  . s err=-7
  i err<0 d RtnObj.Err(-9,"","删除DHC_StkMon_VoucherStatus失败,"_SQLCODE) q RtnObj.Json()
  tcommit
  d ..uLock(sm)
  q RtnObj.Json()
}

/// 是否允许删除
/// Author:zhwh
/// Date:2012-10-31
/// Argu:
///  sm - 月报主表rowid
/// Return
/// 0 - 可以
/// <0 - 不可以
ClassMethod AllowDel(sm As %String) As %String
{
 n (sm)
 s obj=##class(User.DHCStkMon).%OpenId(sm)
 d obj.%Reload()
 s loc=obj.DHCSMCTLOCDR.%Id()
 s lastStkMonRep=""
 &sql(select max(DHCSM_Rowid) into :lastStkMonRep from DHC_StkMon where DHCSM_CTLOC_DR=:loc and DHCSM_StkType='M')
 i lastStkMonRep'=sm  q -1 //该月报并非本科室最后一期月报
 q 0
}

/// 批量生成月报
/// Author: lihui
/// Date: 20180812
/// Input :
/// Return:
/// w ##class(web.DHCSTMHUI.DHCStkMon).CreateReports(^templxt("CreateReports1"),^templxt("CreateReports2"))
ClassMethod CreateReports(MainParams As %String, UserId As %String) As %String
{
	n (MainParams,UserId)
	s $ZT=..sssError()						;增加错误处理
	s MethodName=$CLASSNAME()_".CreateReports"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(MainParams)
	i Sc'=0 d
	.d RtnObj.Err(-1,"",MethodName_"入参解析失败!"_MainParams)
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RtnObj=..CreateStkMon(Obj,UserId)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 生成月报及明细内容
/// Argu:	Paramsobj, UserId
/// Return:	RtnObj
ClassMethod CreateStkMon(Paramsobj As %String, UserId As %String) As RtnObj
{
	n (Paramsobj,UserId)
	s RtnObj=##class(RtnObj).%New()
	s LocId=Paramsobj.%Get("LocId")
	i ((LocId="")||('$d(^CTLOC(LocId)))) d RtnObj.Err(-1,"","科室不存在!","",0) q RtnObj
	s LocDesc=$p(^CTLOC(LocId),"^",2)
	
	s CurStartDate=Paramsobj.%Get("CurStartDate")
	s CurEndDate=Paramsobj.%Get("CurEndDate")
	i ((CurStartDate="")||(CurEndDate="")) d RtnObj.Err(-5,"",LocDesc_"开始日期或者截止日期为空!","",0) q RtnObj
	
	s CurMonth=Paramsobj.%Get("CurMonth")
	i (CurMonth="") d RtnObj.Err(-1,"","当前月份为空","",0) q RtnObj
	
	s:CurMonth["-" CurMonth=CurMonth_"-1"
	s Paramsobj.CurMonth=CurMonth
	s TmpSmId=..CheckIfExist(LocId,CurMonth)	//判断当月月报是否已经生成
	i +TmpSmId>0 d RtnObj.Err(-2,"",LocDesc_"月报已经存在，不能生成该月月报!","",0) q RtnObj
	
	s StrParams=LocId_"^"_CurStartDate_"^"_CurEndDate
	s RtnObj=..CheckMonCond(StrParams)
	i RtnObj.success<0 q RtnObj
	
	s RtnObj=..Update("",Paramsobj,UserId)
	i RtnObj.success'=0 q RtnObj
	s SmId=RtnObj.rowid
	
	&sql(insert DHC_StkMon_VoucherStatus(VCH_SM_DR,VCH_SSUSR_DR,VCH_Status)values (:SmId,:UserId,'D'))
	i SQLCODE'=0 d RtnObj.Err(-3,"",LocDesc_"生成月报凭证失败！") q RtnObj
	
	// 生成月报明细
	s RtnObj=##class(web.DHCSTMHUI.DHCStkMonReport).CreateRepDetail(SmId)
	i RtnObj.success'=0 q RtnObj
	
	;本科室的所有活跃批次,不在本期月报内的(说明没有活跃的),设置Active=N
	s RtnObj=..SetInclbInActive(SmId)
	
	q RtnObj
}

/// 本期月报生成后,不存在月报中inclb,将Active状态设置为N
/// W ##class(web.DHCSTMHUI.DHCStkMon).SetInclbInActive(16)
ClassMethod SetInclbInActive(SMId) As RtnObj
{
	n (SMId)
	s RtnObj=##class(RtnObj).%New()
	s LocId=$p(^DHCSM(SMId),"^",1)
	s Inclb=""
	f  s Inclb=$o(^DHCINCLB(0,"A","Y",LocId,Inclb)) q:(Inclb="")!(RtnObj.success'=0)  d
	.q:$d(^DHCSM(0,"INCLB",Inclb,SMId))		;在月报中的,不处理
	.s Inci=$p(Inclb,"||",1),IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
	.s Qty=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",2)
	.q:+Qty'=0								;有库存的,不做处理
	.s Ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateDhcIncItmLcBt(Inclb,"N")
	.i Ret<0 d RtnObj.Err(-51,"",LocDesc_"设置科室批次活跃状态失败！"_Inclb)
	q RtnObj
}

/// 对月报主表记录解锁
/// Author:zhwh
/// Date:2012-10-31
/// Argu:
///  sm - 月报主表rowid
ClassMethod uLock(sm As %String) As %String
{
 q:sm=""
 d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(..%GetParameter("AppName")_sm)
 q
}

/// 取某科室库存项目上期月报的结余数量、金额
/// Date:2012-10-31
/// Argu:
///  mrowid - 月报主表rowid
///  mon - 月份
///  incil - 科室库存rowid(INC_ItmLoc)
/// Return:
///  结余库存数量^结余库存金额(售价)^结余库存金额(进价)^财务结存金额(进价)
ClassMethod GetLast(mrowid As %String, mon As %String, incil As %String) As %String
{
	n (mrowid,mon,incil)
	s qty=0,amount=0,costamount=0,finamount=0
	q:mrowid="" ""
	q:mon="" ""
	q:incil="" ""
	
	s ch=""
	s ch=$o(^DHCSM(0,"INCILMon",incil,mon,mrowid,ch))
	q:ch="" ""
	
	s qty=+$p(^DHCSM(mrowid,"R",ch),"^",6)
	s amount=+$p(^DHCSM(mrowid,"R",ch),"^",7)
	s costamount=+$p(^DHCSM(mrowid,"R",ch),"^",8)
	s statinrowid=$o(^SMSTATI(0,"SMR",mrowid_"||"_ch,""))
	
	i statinrowid'=""  d
	.s statinInfo=^SMSTATI(statinrowid)
	.s finamount=$p(statinInfo,"^",59)	//财务本期结存(进价)
	
	q qty_"^"_amount_"^"_costamount_"^"_finamount
}

/// 月报主记录列表
/// Author:zhwh
/// Date:2012-11-02
/// Argu:
/// loc -科室rowid
/// StartDate  -起始日期
/// EndDate - 截止日期
Query DHCStkMon(Params As %String = "") As Query(ROWSPEC = "smRowid,mon,frDate,toDate,frTime,toTime,createDate,createTime,user,userName,loc,locDesc,StkMonNo,AcctVoucherCode,AcctVoucherDate,AcctVoucherStatus,PdfFile,AcctVoucherCodeRec,AcctVoucherDateRec,AcctVoucherStatusRec,PdfFileRec")
{
}

ClassMethod DHCStkMonExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s LocId=PJObj.%Get("HistoryStkMonStatLoc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	q:LocId="" $$$OK

	s sql="select dhcsm_rowid smRowid,"
		_"dhcsm_month mon,"
		_"dhcsm_fromdate frDate,"
		_"dhcsm_todate toDate,"
		_"DHCSM_CreatedUser_dr userRowid,"
		_"dhcsm_createduser_dr->ssusr_name userName,"
		_"dhcsm_createddate createDate,"
		_"DHCSM_FromTime frTime,"
		_"DHCSM_ToTime toTime,"
		_"DHCSM_CreatedTime createTime,"
		_"dhcsm_ctloc_dr loc,"
		_"dhcsm_ctloc_dr->ctloc_desc locDesc,"
		_"DHCSM_StkMonNo StkMonNo,"
		_"DHCSM_AcctVoucherCode AcctVoucherCode,"
		_"DHCSM_AcctVoucherDate AcctVoucherDate,"
		_"DHCSM_AcctVoucherStatus AcctVoucherStatus,"
		_"DHCSM_PdfFile PdfFile,"
		_"DHCSM_AcctVoucherCode_Rec AcctVoucherCodeRec,DHCSM_AcctVoucherDate_Rec AcctVoucherDateRec,"
		_"DHCSM_pdffile_rec PdfFileRec,DHCSM_AcctVoucherStatus_Rec AcctVoucherStatusRec "
		_" from dhc_stkmon"
		_" where dhcsm_stktype='M' and dhcsm_ctloc_dr="_LocId
	i ((StartDate'="")&&(EndDate'="")) d
	.s sql=sql_" and dhcsm_month between "_StartDate_" and "_EndDate
	s sql=sql_" order by dhcsm_month DESC"
	
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s ret=xrs.Execute()
	i $$$ISERR(ret) q $$$OK
	while (xrs.Next())
	{
		s smRowid=xrs.Data("smRowid")
		s mon=xrs.Data("mon")
		s frDate=xrs.Data("frDate")
		s toDate=xrs.Data("toDate")
		s frTime=xrs.Data("frTime")
		s toTime=xrs.Data("toTime")
		s createDate=xrs.Data("createDate")
		s createTime=xrs.Data("createTime")
		s user=xrs.Data("userRowid")
		s userName=xrs.Data("userName")
		s loc=xrs.Data("loc")
		s locDesc =xrs.Data("locDesc")
		s locDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(locDesc)
		s mon=$e($zd(mon,3),1,7)
		s frDate=..DL2H(frDate)
		s toDate=..DL2H(toDate)
		s frTime=..TL2H(frTime)
		s toTime=..TL2H(toTime)
		s createDate=..DL2H(createDate)
		s createTime=..TL2H(createTime)
		s StkMonNo=xrs.Data("StkMonNo")
		s AcctVoucherCode=xrs.Data("AcctVoucherCode")
		s AcctVoucherDate=xrs.Data("AcctVoucherDate")
		s:AcctVoucherDate'="" AcctVoucherDate=..DL2H(AcctVoucherDate)
		s AcctVoucherStatus=xrs.Data("AcctVoucherStatus")
		s AcctVoucherStatus=$S(AcctVoucherStatus="D":"就绪",AcctVoucherStatus="S":"提交",AcctVoucherStatus="A":"接收",AcctVoucherStatus="P":"通过",AcctVoucherStatus="R":"退回",1:"")
		s PdfFile=xrs.Data("PdfFile")

		s AcctVoucherCodeRec=xrs.Data("AcctVoucherCodeRec")
		s AcctVoucherDateRec=xrs.Data("AcctVoucherDateRec")
		s:AcctVoucherDateRec'="" AcctVoucherDateRec=..DL2H(AcctVoucherDateRec)
		s AcctVoucherStatusRec=xrs.Data("AcctVoucherStatusRec")
		s AcctVoucherStatusRec=$S(AcctVoucherStatusRec="D":"就绪",AcctVoucherStatusRec="S":"提交",AcctVoucherStatusRec="A":"接收",AcctVoucherStatusRec="P":"通过",AcctVoucherStatusRec="R":"退回",1:"")
		s PdfFileRec=xrs.Data("PdfFileRec")

		d OutPutRow
	}

	Quit $$$OK

OutPutRow
	s Data=$lb(smRowid,mon,frDate,toDate,frTime,toTime,createDate,createTime,user,userName,loc,locDesc,StkMonNo,AcctVoucherCode,AcctVoucherDate,AcctVoucherStatus,PdfFile,AcctVoucherCodeRec,AcctVoucherDateRec,AcctVoucherStatusRec,PdfFileRec)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/*
/// 取科室库存项目的排除标志，根据该属性的定义，返回1或0(HISUI没有维护，用来排除不想进行月报的库存项目)
/// Author:zhwh
/// Date:2012-11-05
/// Argu:
///  inclb -库存批次rowid
/// Return :
///  1 - 排除
///  0 - 不排除
ClassMethod ExcludeFlag(inclb As %String) As %String
{
	n (inclb)
	s incil=$P(inclb,"||",1,2)
	s flag=""
	&sql(select incil_freestoragebin into :flag From inc_itmloc where  %id=:incil)
	i (flag="Y")!(flag="1") q 1
	q 0
}*/
/// 检查某科室某月份月报是否已经生成
/// Author:zhangdongmei
/// Date:2012-11-20
/// Argu:
///  LocId -科室rowid
///  CurMonth-当前月份
/// Return :
///  >0(月报id)：月报已经生成;0:未生成
ClassMethod CheckIfExist(LocId, CurMonth) As %String
{
	n (LocId,CurMonth)
	q:LocId="" ""
	q:CurMonth="" ""
	s CurMonth=..DH2L(CurMonth)
	s Rowid=$o(^DHCSM(0,"TML","M",CurMonth,LocId,""))
	q Rowid
}

/// 检查某科室某时间段内是否有未处理的库存转移单
/// Author:	wangjiabin
/// Date:	2014-11-27
/// Argu:	LocId^StartDate(Y-m-d)^EndDate(Y-m-d)
/// Return:	RtnObj
ClassMethod CheckMonCond(StrParam As %String) As RtnObj
{
	n (StrParam)
	s LocId=$p(StrParam,"^",1)
	s StartDate=$p(StrParam,"^",2)
	s EndDate=$p(StrParam,"^",3)
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	
	s RtnObj=##class(RtnObj).%New()
	i (LocId="")||(StartDate="")||(EndDate="") q RtnObj.Err(-1,"","CheckMonCond参数有误!","",0)

	s LocDesc=$p(^CTLOC(LocId),"^",2)
	s Str=""
	
	;判断入库单-月报周期内,不允许有未审核的入库单(且填写了发票的)
	s IngrFlag=""
	s Ingr=0
	f Date=StartDate:1:EndDate d
	.s Ingr=0
	.f  s Ingr=$o(^DHCINGR(0,"CreateDate",Date,LocId,Ingr)) q:(Ingr="")||(IngrFlag="Y")  d
	..s AuditFlag=$p(^DHCINGR(Ingr),"^",29)
	..q:AuditFlag="Y"
	..s Ch=0
	..f  s Ch=$o(^DHCINGR(Ingr,"GRI",Ch)) q:(Ch="")||(IngrFlag="Y")  d
	...s InvNo=$p(^DHCINGR(Ingr,"GRI",Ch),"^",27)
	...s InvSetDate=$p(^DHCINGR(Ingr,"GRI",Ch),"^",59)
	...q:(InvNo="")&&(InvSetDate="")
	...s IngrFlag="Y" q
	i IngrFlag="Y" d
	.s CheckIngrStr=LocDesc_"存在已录发票但未审核的入库单!"
	.i Str="" s Str=CheckIngrStr
	.e  s Str=Str_"  "_CheckIngrStr
	
	;判断月报日期之前是否有未处理的库存转移单(转出)
	s MinAckOutDate=""
	&sql(select min(INIT_AckDate) into :MinAckOutDate from dhc_inistrf
		where INIT_FrLoc_DR=:LocId and INIT_State='21' and INIT_AckDate>=:StartDate and INIT_StkType='M')
	i (+MinAckOutDate'=0)&&(MinAckOutDate<=EndDate) d
	.s CheckInitStr=LocDesc_"存在出库未接收单据!"
	.i Str="" s Str=CheckInitStr
	.e  s Str=Str_"  "_CheckInitStr
	
	i Str'="" q RtnObj.Err(-2,"",Str)
	q RtnObj
}

/// 取安全组下所有科室,显示月报时间段
/// Author: lihui
/// Date: 20180807
/// Input:  
/// Return: 安全组科室月报时间段
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCStkMon","jsGrpLocForStkMon","","",264,"")
Query jsGrpLocForStkMon(Params) As Query(ROWSPEC = "LocId,LocDesc,lastStkMonRowid,lastMonth,lastFrDate,lastFrTime,lastToDate,lastToTime,CurMonth,CurStartDate,CurStartTime,CurEndDate,CurEndTime")
{
}

ClassMethod jsGrpLocForStkMonExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pLocDesc=PJObj.%Get("LocDesc")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJObj.%Get("BDPHospital") ;选择的医院ID
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)

	s sqlStr="Select st_ctloc_dr AS RowId,st_ctloc_dr->ctloc_desc  AS Description from ss_groupstocklocations where st_parref="_gGroupId
	i pLocDesc'="" d
	.s pLocDesc=$$ALPHAUP^SSUTIL4(pLocDesc)
	.s sqlStr = sqlStr_" and %ALPHAUP(st_ctloc_dr->ctloc_desc) %STARTSWITH "_"'"_pLocDesc_"'"

	s result=##class(%ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(result.Next())
	{
		//检索每一个科室的上期(最后)月报情况 Start
		s (lastStkMonRowid,lastMonth,lastFrDate,lastFrTime,lastToDate,lastToTime)=""
		s (CurMonth,CurStartDate,CurStartTime,CurEndDate,CurEndTime)=""
		s CurEndDate=+$h-1
		s CurMonth=$p($zd(CurEndDate,3),"-",1,2)
		s CurEndTime="23:59:59"
		s LocId=result.Data("RowId")
		continue:(##class(web.DHCSTMHUI.CTLOC).LocOfHosp(LocId,pHospId)'=0)
		s LocDesc=result.Data("Description")
		s finalMonth=""
		&sql( select max(dhcsm_month) into :finalMonth  From dhc_stkmon where dhcsm_ctloc_Dr=:LocId and dhcsm_stktype='M')
		i finalMonth'="" d
		.&sql(select %id,dhcsm_month,dhcsm_fromdate,dhcsm_todate,dhcsm_fromtime,dhcsm_totime
			into :lastStkMonRowid,:lastMonth,:lastFrDate,:lastToDate,:lastFrTime,:lastToTime
			From dhc_stkmon where dhcsm_ctloc_dr=:LocId and dhcsm_month= :finalMonth and dhcsm_stktype='M')
		.i (..TL2H(lastToTime)="23:59:59") d
		..s CurStartDate=lastToDate+1
		..s CurStartTime=0
		.e  d
		..s CurStartDate=lastToDate
		..s CurStartTime=lastToTime+1
		.
		.s lastMonth=$zd(lastMonth,3)
		.s lastMonth=$p(lastMonth,"-",1,2)
		.s lastFrDate=..DL2H(lastFrDate)
		.s lastFrTime=..TL2H(lastFrTime)
		.s lastToDate=..DL2H(lastToDate)
		.s lastToTime=..TL2H(lastToTime)
		;上期月报为空时,默认开始日期为台账日期; 否则月第一天,时间00:00:00
		e  i lastStkMonRowid="" d
		.s CurStartDate=$zdh(CurMonth_"-01",3)
		.s CurStartDate=$$GetFirstIntrDate(LocId,CurStartDate)
		.s CurStartTime=0
		
		s CurStartDate=..DL2H(CurStartDate)
		s CurStartTime=..TL2H(CurStartTime)
		s CurEndDate=..DL2H(CurEndDate)
		s CurMonth=..GetCurMonth(CurStartDate,CurEndDate,lastMonth)
		d OutPutStkMonRow
	}
	Quit $$$OK

OutPutStkMonRow
	s Data=$lb(LocId,LocDesc,lastStkMonRowid,lastMonth,lastFrDate,
		lastFrTime,lastToDate,lastToTime,CurMonth,CurStartDate,
		CurStartTime,CurEndDate,CurEndTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q

/// 获取该科室有台账的第一天,否则按FirstDate返回
GetFirstIntrDate(LocId,FirstDate)
	n (LocId,FirstDate)
	s IntrType=""
	f  s IntrType=$o(^DHCINTR(0,"LOCTYPEDATE",LocId,IntrType)) q:IntrType=""  d
	.s FirstIntrDate=$o(^DHCINTR(0,"LOCTYPEDATE",LocId,IntrType,""))
	.q:FirstIntrDate=""
	.i FirstIntrDate<FirstDate s FirstDate=FirstIntrDate
	q FirstDate
}

/// w ##class(web.DHCSTMHUI.DHCStkMon).GetCurMonth("2021-12-01","2022-01-03","2021-12")
/// 1.开始年月=截至年月,默认截至日期年月
/// 2.开始年月<截至年月,如果月报在最后月份的天数 > 月报在上一月份的天数, 则月报默认为"最后月份";否则默认为"前一月份";
/// 3.如果前一月份的月报存在, 则使用截至日期年月
ClassMethod GetCurMonth(StartDate As %String, EndDate As %String, FinalMonth As %String) As %String
{
	n (StartDate,EndDate,FinalMonth)
	q:StartDate=""||EndDate="" ""
	s StYear=$p(StartDate,"-",1)
	s StMon=$p(StartDate,"-",2)
	s EdYear=$p(EndDate,"-",1)
	s EdMon=$p(EndDate,"-",2)
	s LastMonToDate=$zdh(EdYear_"-"_EdMon_"-"_"01",3)-1	;截至日期前一月份最后一天
	s LastMon=$p($zd(LastMonToDate,3),"-",1,2)			;截至日期前一月份
	s CurMonth=EdYear_"-"_EdMon
	q:$zdh(StartDate,3)-$zdh(EndDate,3)>0 CurMonth
	i (StYear=EdYear)&&(StMon=EdMon) d
	.s CurMonth=EdYear_"-"_EdMon
	e  d
	.i FinalMonth=LastMon d
	..s CurMonth=EdYear_"-"_EdMon
	.e  d
	..s EndMonDayNum=$zdh(EndDate,3)-(LastMonToDate+1)
	..i (StYear_"-"_StMon)=LastMon d
	...s LastMonDayNum=LastMonToDate-$zdh(StartDate,3)
	..e  d
	...s LastMonDayNum=LastMonToDate-$zdh(LastMon_"-01",3)
	..i (EndMonDayNum'<LastMonDayNum) d
	...s CurMonth=EdYear_"-"_EdMon
	..e  d
	...s CurMonth=LastMon
	q CurMonth
}

/// 取月报主表记录的数据信息串
/// Author:zhangxiao
/// Date:2013-09-24
/// Argu:
///  ret - 月报主表rowid
/// Return：
///  返回记录数据串
/// w ##class(web.DHCSTMHUI.DHCStkMon).GetMain(284)
ClassMethod GetMain(RowId As %String) As %String
{
	n (RowId)
	q:RowId="" ""
	s result=""
	&sql(select DHCSM_Rowid,DHCSM_Month,DHCSM_CTLOC_DR,DHCSM_FromDate,DHCSM_ToDate,
		DHCSM_CreatedDate,DHCSM_CreatedUser_DR,DHCSM_FromTime,DHCSM_ToTime,DHCSM_CreatedTime,
		DHCSM_StkMonNo,DHCSM_AcctVoucherCode,DHCSM_AcctVoucherDate,DHCSM_AcctVoucherStatus,DHCSM_PdfFile

		into DHCSMRowid,DHCSMMonth,DHCSMCTLOCDR,DHCSMFromDate,DHCSMToDate,
		DHCSMCreatedDate,DHCSMCreatedUserDR,DHCSMFromTime,DHCSMToTime,DHCSMCreatedTime,
		DHCSMStkMonNo,DHCSMAcctVoucherCode,DHCSMAcctVoucherDate,DHCSMAcctVoucherStatus,DHCSMPdfFile
		from DHC_StkMon where %ID=:RowId
	)
	q:SQLCODE ""
	s (month,LocDesc,fromdate,todate,createdate,createUsername,frTime,toTime,createTime)=""
	s:DHCSMMonth'="" month=$e($zd(DHCSMMonth,3),1,7)
	s:DHCSMCTLOCDR'="" LocDesc=$p(^CTLOC(DHCSMCTLOCDR),"^",2)
	s:DHCSMFromDate'="" fromdate=..DL2H(DHCSMFromDate)
	s:DHCSMToDate'="" todate=..DL2H(DHCSMToDate)
	s:DHCSMCreatedDate'="" createdate=..DL2H(DHCSMCreatedDate)
	s:DHCSMCreatedUserDR'="" createUsername=$p(^SSU("SSUSR",DHCSMCreatedUserDR),"^",2)
	s:DHCSMFromTime'="" frTime=..TL2H(DHCSMFromTime)
	s:DHCSMToTime'="" toTime=..TL2H(DHCSMToTime)
	s:DHCSMCreatedTime'="" createTime=..TL2H(DHCSMCreatedTime)
	s result= DHCSMRowid_"^"_DHCSMMonth_"^"_DHCSMCTLOCDR_"^"_DHCSMFromDate_"^"_DHCSMToDate
		_"^"_DHCSMCreatedDate_"^"_DHCSMCreatedUserDR_"^"_DHCSMFromTime_"^"_DHCSMToTime_"^"_DHCSMCreatedTime
		_"^"_month_"^"_LocDesc_"^"_fromdate_"^"_todate_"^"_createdate
		_"^"_createUsername_"^"_frTime_"^"_toTime_"^"_createTime
	q result
}

/// 月初自动生成上月月报(任务在每月月初[1号-5号]执行),注意参数
/// Author:	wangjiabin
/// Date:	2015-07-29
/// Argu:	需要生成月报的科室rowid字符串(^隔开)
/// Return:
/// d ##class(web.DHCSTMHUI.DHCStkMon).AutoCreateStkMon("152^153")
ClassMethod AutoCreateStkMon(LocStr)
{
	n (LocStr)
	s $ZT=..sssError()

	s LastMonDate=+$h-5						;月初五天之内执行该任务
	s LastDay=$SYSTEM.SQL.LASTDAY(LastMonDate)
	s YearMonth=$p($zd(LastDay,3),"-",1,2)
	s Mon=YearMonth_"-01"					;上月月初第一天
	s User=""
	&sql(select %id into :User from ss_user where SSUSR_Initials='demo')
	s FrDate=Mon
	s ToDate=$zd(LastDay,3)
	s FrTime="00:00:00"
	s ToTime="23:59:59"

	s LocLen=$l(LocStr,"^")
	f i=1:1:LocLen d
	.s Loc=$p(LocStr,"^",i)
	.s RtnObj=..CreateStkMon(Loc,Mon,User,FrDate,ToDate,FrTime,ToTime)

	q
}

/// 获取科室月报需显示的库存分类Str(^隔开)
/// Author:	wangjiabin
/// Date:	2016-07-22
/// Argu:	月报rowid
/// Return:
/// w ##class(web.DHCSTMHUI.DHCStkMon).GetStkMonIncscStr(425)
ClassMethod GetStkMonIncscStr(sm As %String) As %String
{
	n (sm)
	q:sm="" ""
	s LocId=$p(^DHCSM(sm),"^",1)
	q:LocId="" ""

	s ScgStr=""
	s Scg=""
	f  s Scg=$o(^DHCSLCG(0,"LOCCAT",LocId,Scg)) q:Scg=""  d
	.s LocGrpId=""
	.f  s LocGrpId=$o(^DHCSLCG(0,"LOCCAT",LocId,Scg,LocGrpId)) q:LocGrpId=""  d
	..s Monflag="Y"
	..i ($d(^DHCSLCG(LocGrpId)))  d
	...s Monflag=$p(^DHCSLCG(LocGrpId),"^",5)
	..q:Monflag'="Y"
	..i ScgStr="" s ScgStr=Scg
	..e  s ScgStr=ScgStr_"^"_Scg

	q:ScgStr="" ""
	s ScgLen=$l(ScgStr,"^")
	s IncscStr=""
	f i=1:1:ScgLen d
	.s Scg=$p(ScgStr,"^",i)
	.s ch=""
	.f  s ch=$o(^DHCSCG(Scg,"RE",ch)) q:ch=""  d
	..s Incsc=$p(^DHCSCG(Scg,"RE",ch),"^",1)
	..i IncscStr="" s IncscStr=Incsc
	..e  s IncscStr=IncscStr_"^"_Incsc

	q IncscStr
}

/// 根据月报号更新凭证号，凭证日期，凭证PDF
/// Author:	xuchao
/// Date:	2016-08-01
/// Argu:	月报号
/// Return:	成功返回0 其他返回错误
/// w ##class(web.DHCSTMHUI.DHCStkMon).UpdateAcctVoucherInfo()
ClassMethod UpdateAcctVoucherInfo(StkMonNo As %String, AcctVoucherCode As %String, AcctVoucherDate As %String, PdfFile As %String) As %String
{
	n (StkMonNo,AcctVoucherCode,AcctVoucherDate,PdfFile)
	q:StkMonNo="" -1
	s:AcctVoucherDate'="" AcctVoucherDate=$zdh(AcctVoucherDate,3)
	&sql(update DHC_StkMon set DHCSM_AcctVoucherCode=:AcctVoucherCode,DHCSM_AcctVoucherDate=:AcctVoucherDate,DHCSM_PdfFile=:PdfFile where DHCSM_StkMonNo=:StkMonNo)
	q SQLCODE
}

/// 根据月报号更新凭证号状态
/// Author:	xuchao
/// Date:	2016-08-01
/// Argu:	月报号 (A,P,R):Accepted,Passed,Returned
/// Return:	成功返回0 其他返回错误
/// w ##class(web.DHCSTMHUI.DHCStkMon).UpdateAcctVoucherStatus("QXKKFMON20160802004","A",1)
ClassMethod UpdateAcctVoucherStatus(StkMonNo As %String, AcctVoucherStatus As %String, User As %String = "") As %String
{
	n (StkMonNo,AcctVoucherStatus,User)
	s type="TK"
	q:StkMonNo="" -1
	&sql(update DHC_StkMon set DHCSM_AcctVoucherStatus=:AcctVoucherStatus,DHCSM_AcctVoucherUser_DR=:User where DHCSM_StkMonNo=:StkMonNo)
	s Sm=%ROWID
	&sql(insert DHC_StkMon_VoucherStatus(VCH_SM_DR,VCH_SSUSR_DR,VCH_Status,VCH_VoucherType)values (:Sm,:User,:AcctVoucherStatus,:type))
	q SQLCODE
}

/// 月报信息
/// Author:xuchao
/// Date:2016-08-03
/// Argu:
/// sm -月报ID
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCStkMon","DHCStkMonInfo",42)
Query DHCStkMonInfo(sm As %String) As Query(ROWSPEC = "smRowid,mon,frDate,toDate,frTime,toTime,createDate,createTime,user,userName,loc,locDesc,StkMonNo,AcctVoucherCode,AcctVoucherDate,AcctVoucherStatus,PdfFile,printDate,HospDesc") [ SqlProc ]
{
}

ClassMethod DHCStkMonInfoExecute(ByRef qHandle As %Binary, sm As %String) As %Status
{
	n (qHandle,sm)
	i sm="" q $$$OK
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s sql="select dhcsm_rowid smRowid,"
	s sql=sql_"dhcsm_month mon,"
	s sql=sql_"dhcsm_fromdate frDate,"
	s sql=sql_"dhcsm_todate toDate,"
	s sql=sql_"DHCSM_CreatedUser_dr userRowid,"
	s sql=sql_"dhcsm_createduser_dr->ssusr_name userName,"
	s sql=sql_"dhcsm_createddate createDate,"
	s sql=sql_"DHCSM_FromTime frTime,"
	s sql=sql_"DHCSM_ToTime toTime,"
	s sql=sql_"DHCSM_CreatedTime createTime,"
	s sql=sql_"dhcsm_ctloc_dr loc,"
	s sql=sql_"dhcsm_ctloc_dr->ctloc_desc locDesc,"
	s sql=sql_"DHCSM_StkMonNo StkMonNo,"
	s sql=sql_"DHCSM_AcctVoucherCode AcctVoucherCode,"
	s sql=sql_"DHCSM_AcctVoucherDate AcctVoucherDate,"
	s sql=sql_"DHCSM_AcctVoucherStatus AcctVoucherStatus,"
	s sql=sql_"DHCSM_PdfFile PdfFile"
	s sql=sql_" from dhc_stkmon"
	s sql=sql_" where dhcsm_rowid="_sm

	s xrs=##class(%Library.ResultSet).%New()
	s xrs.RuntimeMode=0
	d xrs.Prepare(sql)
	s ret=xrs.Execute()
	i $$$ISERR(ret) q $$$OK
	while (xrs.Next())
	{
		s smRowid=xrs.Data("smRowid")
		s mon=xrs.Data("mon")
		s frDate=xrs.Data("frDate")
		s toDate=xrs.Data("toDate")
		s frTime=xrs.Data("frTime")
		s toTime=xrs.Data("toTime")
		s createDate=xrs.Data("createDate")
		s createTime=xrs.Data("createTime")
		s user=xrs.Data("userRowid")
		s userName=xrs.Data("userName")
		s loc=xrs.Data("loc")
		s locDesc =xrs.Data("locDesc")
		s locDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(locDesc)
		s mon=$e(mon,1,7)
		s StkMonNo=xrs.Data("StkMonNo")
		s AcctVoucherCode=xrs.Data("AcctVoucherCode")
		s AcctVoucherDate=xrs.Data("AcctVoucherDate")
		s AcctVoucherStatus=xrs.Data("AcctVoucherStatus")
		s AcctVoucherStatus=$S(AcctVoucherStatus="D":"就绪",AcctVoucherStatus="S":"提交",AcctVoucherStatus="A":"接收",AcctVoucherStatus="P":"通过",AcctVoucherStatus="R":"退回",1:"")
		s PdfFile=xrs.Data("PdfFile")
		s:mon'="" mon=$p($zd(mon,3),"-",1,2)
		s:frDate'="" frDate=..DL2H(frDate)
		s:toDate'="" toDate=..DL2H(toDate)
		s:createDate'="" createDate=..DL2H(createDate)
		s:frTime'="" frTime=..TL2H(frTime)
		s:toTime'="" toTime=..TL2H(toTime)
		s:createTime'="" createTime=..TL2H(createTime)
		s printDate=..DL2H(+$h)_" "_..TL2H($p($h,",",2))
		s HospId=$p(^CTLOC(loc),"^",22)
		s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
		d OutPutRow2
	}

	Quit $$$OK

OutPutRow2
	s Data=$lb(smRowid,mon,frDate,toDate,frTime,toTime,createDate,createTime,user,userName,loc,locDesc,StkMonNo,AcctVoucherCode,AcctVoucherDate,AcctVoucherStatus,PdfFile,printDate,HospDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 根据月报表RowId取出凭证记录
/// Author:	lxt
/// Date:	2016-08-10
/// w ##class(web.DHCSTMHUI.DHCStkMon).VoucherStatusDetail("438")
ClassMethod VoucherStatusDetail(smRowId) As %Library.String
{
	n (smRowId)
    q:smRowId="" ""
    s count=0
    s VCHRowId=0
    Set json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
    f  s VCHRowId=$o(^DHCSMVchStatus(0,"Mon",smRowId,VCHRowId)) q:VCHRowId=""  d
    .s VCHVoucherType=$p(^DHCSMVchStatus(VCHRowId),"^",2)
    .s VCHDate=$p(^DHCSMVchStatus(VCHRowId),"^",5)
    .s VCHDate=..DL2H(VCHDate)
    .s VCHTime=$p(^DHCSMVchStatus(VCHRowId),"^",6)
    .s VCHTime=..TL2H(VCHTime)
    .s VCHSSUSRDR=$p(^DHCSMVchStatus(VCHRowId),"^",7)
    .i VCHSSUSRDR="" s VCHSSUSRDRName=""
    .e  s VCHSSUSRDRName=$p(^SSU("SSUSR",VCHSSUSRDR),"^",2)
    .s VCHStatus=$p(^DHCSMVchStatus(VCHRowId),"^",4)
    .s VCHStatus=$S(VCHStatus="D":"就绪",VCHStatus="S":"提交",VCHStatus="A":"接收",VCHStatus="P":"通过",VCHStatus="R":"退回",1:"")
    .s VCHRemark=$p(^DHCSMVchStatus(VCHRowId),"^",8)
    .s Data=VCHRowId_"^"_VCHVoucherType_"^"_VCHDate_"^"_VCHTime_"^"_VCHSSUSRDRName_"^"_VCHStatus_"^"_VCHRemark
    .s count=count+1
    .d json.InsertRowData(Data)

    s Title="VCHRowId^VCHVoucherType^VCHDate^VCHTime^VCHSSUSRDR^VCHStatus^VCHRemark"
    d json.getJsonData(Title,count)
    k json
}

/// 提交月报记录
/// Author:lxt
/// Date: 20180813
/// Input : smRowId - 月报主表rowid,userid
/// Return
/// 0 -success
/// <0 - failure
ClassMethod Submit(smRowId As %String, UserId As %String) As %String
{
  n (smRowId,UserId)
  s Status="S"
  s appName=..%GetParameter("AppName")
  s SubDate=+$h
  s SubTime=$p($h,",",2)
  s RtnObj=##class(RtnObj).%New()
  i smRowId="" d RtnObj.Err(-1,"","月报不存在!","",0)  q RtnObj.Json()

  //判断是否允许提交
  i ##class(web.DHCSTMHUI.Common.AppCommon).Lock(appName_smRowId)<0 d RtnObj.Err(-2,"","加锁失败!")  q RtnObj.Json()
  i ..CheckDone(smRowId)<0 d ..uLock(smRowId) d RtnObj.Err(-3,"","非就绪状态月报不可提交!","",0)  q RtnObj.Json()

  s err=0
  tstart
  //修改DHC_StkMon
  &sql(update DHC_StkMon set DHCSM_AcctVoucherStatus=:Status,DHCSM_AcctVoucherStatus_Rec=:Status where DHCSM_Rowid=:smRowId)
  i SQLCODE<0  d
  . d ..uLock(smRowId)
  . trollback
  . s err=-2
  i err<0  d RtnObj.Err(-4,"","修改DHC_StkMon失败!"_SQLCODE)  q RtnObj.Json()
  //插入DHC_StkMon_VoucherStatus
  &sql(INSERT INTO DHC_StkMon_VoucherStatus(VCH_SM_DR,VCH_Date,VCH_Time,VCH_SSUSR_DR,VCH_Status) VALUES(:smRowId,:SubDate,:SubTime,:UserId,:Status))
  i SQLCODE<0  d
  . d ..uLock(smRowId)
  . trollback
  . s err=-3
  i err<0  d RtnObj.Err(-5,"","插入DHC_StkMon_VoucherStatus失败!"_SQLCODE)  q RtnObj.Json()
  tcommit
  d ..uLock(smRowId)
  q RtnObj.Json()
}

/// 是否就绪状态
/// Author:lxt
/// Date:2016-08-19
/// Argu:
/// sm - 月报主表rowid
/// Return
/// 0 - 是
/// <0 - 不是
ClassMethod CheckDone(sm As %String) As %String
{
 n (sm)
 s obj=##class(User.DHCStkMon).%OpenId(sm)
 d obj.%Reload()
 s status=obj.DHCSMAcctVoucherStatus
 i status'="D" q -1
 q 0
}

/// 取消提交月报记录
/// Author:lxt
/// Date: 20180813
/// Input: smRowId - 月报主表rowid,userid
/// Return
/// 0 -success
/// <0 - failure
ClassMethod CancelSubmit(smRowId As %String, UserId As %String) As %String
{
  n (smRowId,UserId)
  s Status="D"
  s appName=..%GetParameter("AppName")
  s SubDate=+$h
  s SubTime=$p($h,",",2)
  s RtnObj=##class(RtnObj).%New()
  i smRowId="" d RtnObj.Err(-1,"","月报不存在!","",0)  q RtnObj.Json()

  //判断是否允许取消提交
  i ##class(web.DHCSTMHUI.Common.AppCommon).Lock(appName_smRowId)<0 d RtnObj.Err(-2,"","加锁失败!")  q RtnObj.Json()
  i ..CheckSubmit(smRowId)<0 d ..uLock(smRowId) d RtnObj.Err(-3,"","非提交状态月报不需要取消!","",0)  q RtnObj.Json()

  s err=0
  tstart
  //修改DHC_StkMon
  &sql(update DHC_StkMon set DHCSM_AcctVoucherStatus=:Status,DHCSM_AcctVoucherStatus_Rec=:Status where DHCSM_Rowid=:smRowId)
  i SQLCODE<0  d
  . d ..uLock(smRowId)
  . trollback
  . s err=-2
  i err<0  d RtnObj.Err(-4,"","修改DHC_StkMon失败!"_SQLCODE)  q RtnObj.Json()
  //插入DHC_StkMon_VoucherStatus
  &sql(INSERT INTO DHC_StkMon_VoucherStatus(VCH_SM_DR,VCH_Date,VCH_Time,VCH_SSUSR_DR,VCH_Status) VALUES(:smRowId,:SubDate,:SubTime,:UserId,:Status))
  i SQLCODE<0  d
  . d ..uLock(smRowId)
  . trollback
  . s err=-3
  i err<0  d RtnObj.Err(-5,"","插入DHC_StkMon_VoucherStatus失败!"_SQLCODE)  q RtnObj.Json()
  tcommit
  d ..uLock(smRowId)
  q RtnObj.Json()
}

/// 是否提交状态
/// Author:lxt
/// Date:2016-08-19
/// Argu:
/// sm - 月报主表rowid
/// Return
/// 0 - 是
/// <0 - 不是
ClassMethod CheckSubmit(sm As %String) As %String
{
 n (sm)
 s obj=##class(User.DHCStkMon).%OpenId(sm)
 d obj.%Reload()
 s status=obj.DHCSMAcctVoucherStatus
 i status'="S" q -1
 q 0
}

/// 根据月报号更新凭证号，凭证日期，凭证PDF(入库凭证)
/// Author:	xuchao
/// Date:	2017-06-12
/// Argu:	月报号
/// Return:	成功返回0 其他返回错误
/// w ##class(web.DHCSTMHUI.DHCStkMon).UpdateAcctVoucherInfoRec()
ClassMethod UpdateAcctVoucherInfoRec(StkMonNo As %String, AcctVoucherCode As %String, AcctVoucherDate As %String, PdfFile As %String) As %String
{
	n (StkMonNo,AcctVoucherCode,AcctVoucherDate,PdfFile)
	q:StkMonNo="" -1
	s:AcctVoucherDate'="" AcctVoucherDate=$zdh(AcctVoucherDate,3)
	&sql(update DHC_StkMon set DHCSM_AcctVoucherCode_Rec=:AcctVoucherCode,DHCSM_AcctVoucherDate_Rec=:AcctVoucherDate,DHCSM_PdfFile_Rec=:PdfFile where DHCSM_StkMonNo=:StkMonNo)
	q SQLCODE
}

/// 根据月报号更新凭证号状态(入库凭证)
/// Author:	lxt
/// Date:	2017-06-12
/// Argu:	月报号 (A,P,R):Accepted,Passed,Returned
/// Return:	成功返回0 其他返回错误
/// w ##class(web.DHCSTMHUI.DHCStkMon).UpdateAcctVoucherStatusRec("QXKKFMON20160802004","A",1)
ClassMethod UpdateAcctVoucherStatusRec(StkMonNo As %String, AcctVoucherStatus As %String, User As %String = "") As %String
{
	n (StkMonNo,AcctVoucherStatus,User)
	s type="RG"
	q:StkMonNo="" -1
	&sql(update DHC_StkMon set DHCSM_AcctVoucherStatus_Rec=:AcctVoucherStatus,DHCSM_AcctVoucherUser_DR_Rec=:User where DHCSM_StkMonNo=:StkMonNo)
	s Sm=%ROWID
	&sql(insert DHC_StkMon_VoucherStatus(VCH_SM_DR,VCH_SSUSR_DR,VCH_Status,VCH_VoucherType)values (:Sm,:User,:AcctVoucherStatus,:type))
	q SQLCODE
}

/// 自动生成月报
/// Author:	lxt
/// Date:	2017-08-02
/// Return:	
/// 每月初自动生成上月月报
/// w ##class(web.DHCSTMHUI.DHCStkMon).AutoCreateStkMonDemo()
ClassMethod AutoCreateStkMonDemo() As %String
{
	new
	s ToDate=$zd(+$h-$p($zd(+$h,3),"-",3),3)  ;上月末(月报截止日期)
	s FrDate=$p(ToDate,"-",1,2)_"-01"         ;上月初(月报开始日期)
	s User=""
	&sql(select %id into :User from ss_user where SSUSR_Initials='demo')
	s FrTime="00:00:00"    ;月报开始时间
	s ToTime="23:59:59"    ;月报截止时间
	s Mon=$p(FrDate,"-",1,2)           ;月报月份
	s dhclocid=0
	s ret=""
	f  s dhclocid=$o(^DHCLOC(dhclocid)) q:dhclocid=""  d
	.s Loc=$p(^DHCLOC(dhclocid),"^",1)
	.s AutoMonFlag=$p(^DHCLOC(dhclocid),"^",12)
	.q:AutoMonFlag'="Y"     ;自动月报标志过滤
	.s finalMonth=""
	.&sql( select max(dhcsm_month) into :finalMonth  From dhc_stkmon where dhcsm_ctloc_Dr=:Loc)
	.q:((finalMonth'="")&&($zd(finalMonth,3)=Mon))  ;已生成月报的过滤
	.s Paramsobj={}
	.s Paramsobj.LocId=Loc
	.s Paramsobj.CurMonth=Mon
	.s Paramsobj.CurStartDate=FrDate
	.s Paramsobj.CurEndDate=ToDate
	.s Paramsobj.CurStartTime=FrTime
	.s Paramsobj.CurEndTime=ToTime
	.d ##class(web.DHCSTMHUI.DHCStkMon).CreateStkMon(Paramsobj,User)
	.
	q 0
}

}
