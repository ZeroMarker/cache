Import SQLUser

/// Class Name:web.ACCTCreateVouch
/// Description:生成凭证
/// Creator:zdm
/// CreatDate:2010-07-01
Class web.ACCTCreateVouch Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:zdm
/// CreatDate:2010-07-01
/// Description:生成凭证
/// Table:ACCT_Vouch
/// Input:
/// Output:
/// Return:凭证号,success;"",false
/// Others：w ##Class(web.ACCTCreateVouch).CreateVouch("1","1","GG20100618R001","demo")
ClassMethod CreateVouch(yearPeriodId As %String, busiTypeId As %String, strBusino As %String, operator As %String) As %String
{
	n (yearPeriodId,busiTypeId,strBusino,operator)
	q:yearPeriodId="" ""
	q:busiTypeId="" ""
	q:strBusino="" ""
	q:operator="" ""	
	
	;k ^tmpwyy($j)
	s ^TMPWYY2(1)=yearPeriodId_"^"_busiTypeId_"^"_strBusino_"^"_operator
	
	s whileSql=##class(web.ACCTCommon).GetWhileSqlForBusiType(busiTypeId)
	s type=$p(whileSql,",",1)								;业务类型
	q:type="" ""
	s modCode=##class(web.ACCTCommon).GetModCodeByBusiType(busiTypeId)		;模块号
	i modCode=""  d ErrorRecord(-1,"模块号没定义")
	q:modCode="" ""
	s objYearPeriod=##class(User.ACCTYearPeriod).%OpenId(yearPeriodId)
	i objYearPeriod="" d ErrorRecord(-2,"取会计年度出错")
	q:objYearPeriod="" ""
	s objYear=objYearPeriod.AcctYearDr					;会计年度
	s acctYearId=objYear.%Id()
	i acctYearId="" d ErrorRecord(-3,"会计年度没有定义")
	q:acctYearId="" ""
	
	;加锁
	s ret=$$AddLock()
	i ret'=0  d UnLock
	i ret'=0 d ErrorRecord(-4,"加锁失败")
	q:ret'=0 ""						
	;
	;生成凭证号	
	s vouchNo=..CreateVouchNo(modCode)
	i vouchNo=""  d UnLock
	i vouchNo="" d ErrorRecord(-5,"生成凭证号失败")
	q:vouchNo="" ""	
	s billNum=$l(strBusino,",")					
	tstart
	s $ZT="Error"
	;保存凭证主记录
	s listData=yearPeriodId_"^"_"03"_"^"_modCode_"^"_busiTypeId_"^"_vouchNo_"^"_billNum_"^"_operator
	s vouchId=..SaveVouchRecord(listData)
	i vouchId=""  d UnLock
	i vouchId="" d ErrorRecord(-6,"保存凭证主记录失败")
	q:vouchId="" "" 							
	;生成凭证明细
	s ret=0
	s busiDetailId=""
	s marginSubjId=""								;是否进销差额科目，是的话需要最后保存
	s totalRpAmt=0								;进价金额总和
	s totalSpAmt=0								;售价金额总和
	s i=0
	f  s busiDetailId=$o(^User.ACCTBusiDetailI("PKAcctyearBusitype",acctYearId,busiTypeId,busiDetailId)) q:(busiDetailId="")!(ret'=0)  d
	.s objBusiDetail=##class(User.ACCTBusiDetail).%OpenId(busiDetailId)
	.i objBusiDetail="" d ErrorRecord(-7,"打开凭证模板失败:"_busiDetailId)
	.s:objBusiDetail="" ret=-7
	.q:objBusiDetail=""
	.
	.s objSubj=objBusiDetail.AcctSubjDr
	.i objSubj="" d ErrorRecord(-8,"科目字典不能为空:"_objSubj)
	.s:objSubj="" ret=-8
	.q:objSubj=""
	.s subjId=objSubj.%Id()
	.s isLast=objSubj.IsLast
	.q:isLast'=1						;不是末级科目不需保存
	.
	.s moneyField=objBusiDetail.MoneyField
	.s direction=+objBusiDetail.Direction
	.s amtCredit=0
	.s amtDebit=0
	.s amt=0
	.s tmpAmt=0
	.
	.i moneyField'="M"  d                    ;进销差额不需要计算金额
	..s amt=..CalculateAmtForSubj(modCode,subjId,strBusino,whileSql)
	.b
	.s rpAmt=+$p(amt,"^",1)
	.s spAmt=+$p(amt,"^",2)
	.s summary=$p(amt,"^",3)
	.
	.q:(moneyField'="M")&(summary="")
	.i moneyField="P"  d
	..s tmpAmt=rpAmt
	..s totalRpAmt=totalRpAmt+rpAmt
	.e  i moneyField="S"  d
	..s tmpAmt=spAmt
	..s totalSpAmt=totalSpAmt+spAmt
	.
	.i moneyField="M"  d
	..s marginSubjId=subjId
	..s marginDirection=direction
	.q:moneyField="M"
	.;进销差额最后保存
	.s:direction=1 amtCredit=tmpAmt
	.s:direction=0 amtDebit=tmpAmt        
	.;保存凭证明细
	.b
	.s i=i+1
	.s detailId=..SaveVouchDetail(vouchId,subjId,i,amtDebit,amtCredit,summary)
	.s:detailId="" ret=-6							
	.q:ret'=0
	.
	i ret'=0 d UnLock  trollback
	q:ret'=0 ""
	b
	;保存进销差额
	i marginSubjId'=""  d
	.s amtCredit=0
	.s amtDebit=0
	.s:marginDirection=1 amtCredit=totalSpAmt-totalRpAmt
	.s:marginDirection=0 amtDebit=totalSpAmt-totalRpAmt        
	.s i=i+1
	.s detailId=..SaveVouchDetail(vouchId,marginSubjId,i,amtDebit,amtCredit,"进销差额")
	.s:detailId="" ret=-6							
	.q:ret'=0
	i ret'=0 d UnLock  trollback
	q:ret'=0 ""
	i i<1  d UnLock  trollback
	q:i<1 ""						;没有明细
	;保存业务数据和凭证的对应结果
	s ret=..SaveVouchBuss(vouchId,strBusino)
	i ret'=0 d UnLock  trollback
	q:ret'=0 ""
	.
	tcommit
	d UnLock
	q vouchNo

Error
	s errmsg=$ZE
	s err=$$AppError^DHCSTERROR(errmsg)
	d UnLock
	q err
	
AddLock()	
	s rett=##class(web.ACCTCommon).AddLock("code","CreateVouchNo")		;对生成凭证号代码段加锁
	q rett
UnLock
	s rett=##class(web.ACCTCommon).RemoveLock("code","CreateVouchNo")												
	q
ErrorRecord(errCode,errDesc)
	s err=$$ErrorRecord^DHCSTERROR("ACCT","CreateVouch",errCode,errDesc)
}

/// Creator:zdm
/// CreatDate:2010-06-23
/// Description:生成凭证号
/// Table:ACCT_Vouch
/// Input:
/// Output:
/// Return:凭证号
/// Others：
ClassMethod CreateVouchNo(modCode As %String) As %String
{
	n (modCode)
	q:modCode="" ""
	s date=$zd(+$h,8)
	s pre=modCode_$e(date,1,6)
	&sql(Select Max(vouch_no) into :maxNo From ACCT_Vouch 
	     WHERE vouch_no %STARTSWITH :pre)
	i SQLCODE'=0  d
	.s ret=$$SqlErrorRecord^DHCSTERROR("web.ACCTCreateVouch.CreateVouchNo","pre:"_pre,SQLCODE)
	q:SQLCODE'=0 ""
	s vouchNo=+$e(maxNo,$l(maxNo)-3,$l(maxNo))
	s vouchNo=vouchNo+1
	s vouchNo=$tr($j(vouchNo,4),$c(32),"0")
	s vouchNo=pre_vouchNo
	q vouchNo
}

/// Creator:zdm
/// CreatDate:2010-07-01
/// Description:保存凭证记录
/// Table:ACCT_Vouch
/// Input:
/// Output:
/// Return:Rowid
/// Others：
ClassMethod SaveVouchRecord(listData As %String) As %String
{
	n (listData)
	s yearPeriod=$p(listData,"^",1)
	s vouchType=$p(listData,"^",2)
	s vouchSource=$p(listData,"^",3)
	s busiType=$p(listData,"^",4)
	s vouchNo=$p(listData,"^",5)
	s billNum=$p(listData,"^",6)
	s operator=$p(listData,"^",7)
	s date=+$h
	&sql(Insert into ACCT_Vouch(ACCT_YearPeriod_Dr,ACCT_VouchType_Dr,vouch_source,
	     ACCT_BusiType_Dr,vouch_no,vouch_no_use,vouch_date,vouch_bill_num,operator) 
	     Values(:yearPeriod,:vouchType,:vouchSource,:busiType,:vouchNo,:vouchNo,
	     :date,:billNum,:operator))
	i SQLCODE'=0  d
	.s ret=$$SqlErrorRecord^DHCSTERROR("web.ACCTCreateVouch.SaveVouchRecord","vouchno:"_vouchNo,SQLCODE)
	q:SQLCODE'=0 ""
	q $p(%ROWID,$c(1))
}

/// Creator:zdm
/// CreatDate:2010-07-02
/// Description:保存凭证明细
/// Table:ACCT_VouchDetail
/// Input:
/// Output:
/// Return:Rowid
/// Others：
ClassMethod SaveVouchDetail(parref As %String, subjId As %String, serialNo As %Integer, amtDebit As %Numeric, amtCredit As %Numeric, summary As %String) As %String
{
   
	&sql(Insert into ACCT_VouchDetail(ACCT_VouchParref,ACCT_Subj_Dr,vouch_page,
	     vouch_row,amt_debit,amt_credit,summary) 
	     Values(:parref,:subjId,1,:serialNo,:amtDebit,:amtCredit,:summary))
	i SQLCODE'=0  d
	.s ret=$$SqlErrorRecord^DHCSTERROR("web.ACCTCreateVouch.SaveVouchDetail","parref:"_parref,SQLCODE)
	q:SQLCODE'=0 ""
	q $p(%ROWID,$c(1))
}

/// Creator:zdm
/// CreatDate:2010-07-02
/// Description:保存凭证明细
/// Table:ACCT_VouchBuss
/// Input:
/// Output:
/// Return:0,success;
/// Others：
ClassMethod SaveVouchBuss(vouchId As %String, strBusiNo As %String) As %String
{
	s len=$l(strBusiNo,",")
	s ret=0
	tstart
	s $ZT="Error^DHCSTERROR"
	f i=1:1:len  q:ret'=0  d
	.s busiNo=$p(strBusiNo,",",i)
	.q:busiNo=""
	.&sql(Insert into ACCT_VouchBuss(Acct_Vouch_Dr,buss_no) 
	     Values(:vouchId,:busiNo))
	.i SQLCODE'=0  d
	..s ret=$$SqlErrorRecord^DHCSTERROR("web.ACCTCreateVouch.SaveVouchBuss","vouchId:"_vouchId,SQLCODE)
	.s:SQLCODE'=0 ret=-1
	.q:SQLCODE'=0
	.
	i ret'=0 trollback
	q:ret'=0 ret
	tcommit
	q 0
}

/// Creator:zdm
/// CreatDate:2010-06-23
/// Description:生成凭证时，计算某科目的数量和金额
/// Table:
/// Input:科目id，业务单据号1^业务单据号2
/// Output:
/// Return:数量^金额
/// Others：
ClassMethod CalculateAmtForSubj(modCode As %String, subjId As %String, strBusiNo As %String, whileSql As %String) As %String
{
	n (modCode,subjId,strBusiNo,whileSql)
	q:modCode="" ""
	q:subjId="" ""
	q:strBusiNo="" ""
	s remark=""
	s type=$p(whileSql,",",1)
	s strLocCat=##class(web.ACCTCommon).GetSubjMap(modCode,subjId)
	s strLoc=$p(strLocCat,",",1)
	s strCat=$p(strLocCat,",",2)
	s totalRpAmt=0
	s totalSpAmt=0
	s len=$l(strBusiNo,",")
	
	f i=1:1:len  d
	.s busiNo=$p(strBusiNo,",",i)
	.q:busiNo=""
	.s trid=""
	.f  s trid=$o(^DHCINTR(0,"TypeNo",type,busiNo,trid)) q:trid=""  d
	..s pointer=$p(^DHCINTR(trid),"^",9)
	..s inclb=$p(^DHCINTR(trid),"^",7)
	..q:inclb=""
	..s inci=+inclb
	..
	..s stkcat=$p($g(^INCI(inci,2)),"^",2)			;库存分类
	..s il=$p(inclb,"||",2)
	..s locDr=$p($g(^INCI(inci,"IL",il)),"^",1)
	..b
	..q:(strLoc'="")&($$CheckLoc(strLoc,locDr)=0)						;当前科室不在科目定义的科室范围
	..q:(strCat'="")&($$CheckStkCat(strCat,stkcat)=0)						;当前类别不属于科目定义的类别范围
	..b
	..q:##class(web.ACCTCommon).CheckIfSpecBusiType(trid,whileSql)=0      ;不符合指定的业务类别
	..b
	..s amt=$$GetAmt(type,pointer,trid)
	..b
	..s rpamt=+$p(amt,"^",1)
	..s spamt=+$p(amt,"^",2)
	..s tmpremark=$p(amt,"^",3)
	..s totalRpAmt=totalRpAmt+rpamt
	..s totalSpAmt=totalSpAmt+spamt
	..i '$f(remark,tmpremark) d
	...i remark'="" d
	....s remark=remark_","_tmpremark
	...e  d
	....s remark=tmpremark
	.
	q totalRpAmt_"^"_totalSpAmt_"^"_remark 	

CheckStkCat(strStkCat,stkcat)
 n (strStkCat,stkcat)
 s l=$l(strStkCat,"^")
 s exist=0
 f k=1:1:l  q:exist=1  d
 .s tmpcat=$p(strStkCat,"^",k)
 .q:tmpcat'=stkcat
 .s exist=1
 .
 q exist

CheckLoc(strLoc,loc)
 n (strLoc,loc)
 s l=$l(strLoc,"^")
 s exist=0
 f k=1:1:l  q:exist=1  d
 .s tmploc=$p(strLoc,"^",k)
 .q:loc'=tmploc
 .s exist=1
 .
 q exist	
 	
GetAmt(type,pointer,trid)
 n (type,pointer,dhcintr) 
 s summary=""
 q:pointer="" "^^" 
 i type="G" {
    s INGR=+pointer
    s CH=$p(pointer,"||",2)
    s sp=$p(^DHCINGR(INGR,"GRI",CH),"^",32)
    s qty=$p(^DHCINGR(INGR,"GRI",CH),"^",4)
    s spamt=sp*qty
    s aaaaaa="aaaaaaaaaaaaaaaaaaaaa"
    b
    s rpamt=$p(^DHCINGR(INGR,"GRI",CH),"^",31)
    s summary="入库"
 }
 elseif type="R" {
 s INGRT=+pointer
    s CH=$p(pointer,"||",2)
    s rpamt=$p(^INGRT(INGRT,"DHCGRR",CH),"^",4)
    s spamt=$p(^INGRT(INGRT,"DHCGRR",CH),"^",9)
    ;s oldspamt=(-1)*$p(^INGRT(INGRT,"DHCGRR",CH),"^",16) 
    s summary="退货"   
 }
 elseif type="T" {
    s INIT=+pointer
    s CH=$p(pointer,"||",2)
    s rpamt=$p(^DHCINIT(INIT,"ITI",CH),"^",16)
    s spamt=$p(^DHCINIT(INIT,"ITI",CH),"^",18)
    s summary="转移出库"
 }
 elseif type="K" {
    s INIT=+pointer
    s CH=$p(pointer,"||",2)
    s rpamt=$p(^DHCINIT(INIT,"ITI",CH),"^",16)
    s spamt=$p(^DHCINIT(INIT,"ITI",CH),"^",18)
    s summary="转移入库"
 }
 elseif type="P" {
    s rpamt=$$RpAmt(dhcintr)
    s spamt=$p(^DHCINTR(dhcintr),"^",8) 
    s summary="摆药"     
 }
 elseif type="Y" {
    s rpamt=$$RpAmt(dhcintr)
    s spamt=$p(^DHCINTR(dhcintr),"^",8)
    s summary="退药"      
 }
 elseif type="F" {
    s rpamt=$$RpAmt(dhcintr)
    s spamt=$p(^DHCINTR(dhcintr),"^",8)  
    s summary="发放"    
 } 
 elseif type="H" {
    s rpamt=$$RpAmt(dhcintr)
    s spamt=$p(^DHCINTR(dhcintr),"^",8)   
    s summary="病人退回"   
 }
 elseif type="S" {
    s rpamt=$$RpAmt(dhcintr)
    s spamt=$p(^DHCINTR(dhcintr),"^",8) 
    s summary="门诊非正常发药"     
 }
 elseif type="Z" {
    s rpamt=$$RpAmt(dhcintr)
    s spamt=$p(^DHCINTR(dhcintr),"^",8)
    s summary="门诊非正常退药"
 }
 elseif type="A" {
    s rpamt=$$RpAmt(dhcintr)
    s spamt=$p(^DHCINTR(dhcintr),"^",8)
    s summary="库存调整"
 }
 elseif type="D" {
    s rpamt=$$RpAmt(dhcintr)
    s spamt=$p(^DHCINTR(dhcintr),"^",8)
    s summary="库存报损"
 }
 elseif type="C" {
    s rpamt=$$RpAmt(dhcintr)
    s spamt=$p(^DHCINTR(dhcintr),"^",8)
    s summary="消耗"
 }
 else { }
 q $g(rpamt)_"^"_$g(spamt)_"^"_summary

RpAmt(dhcintr)
 n (dhcintr)
 s qty=$p(^DHCINTR(dhcintr),"^",6)
 s inclb=$p(^DHCINTR(dhcintr),"^",7)
 s uom=$p(^DHCINTR(dhcintr),"^",10)
 s rp=##class(web.ACCTCommon).GetRp(inclb,uom)
 s rpamt=rp*qty
 q rpamt
}

}
