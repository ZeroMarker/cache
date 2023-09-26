Import SQLUser

Class web.QueryMrInfo Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      HeTong
/// CreatDate：    2018-07-06
/// Description：  病案统计报表（科室-手术情况统计）
/// Table：        DHCMRInfo
/// Input：        startDate,endDate
/// OutPut:	
/// d ##Class(%ResultSet).RunQuery("web.QueryMrInfo","GetDHMRInfoLoc","2017-07-01","2017-07-31")
Query GetDHMRInfoLoc(startDate As %String, endDate As %String, hosId As %String = "", dep As %String = "", grpCode As %String = "", diagMatch As %String = "") As %Query(ROWSPEC = "loc:%Integer,locDesc,locGrpCode,locGrpDesc,locGrpOrder:%Integer,ssrcNum:%Integer,zlxczNum:%Integer,zdxczNum:%Integer,num:%Integer,ssrsNum:%Integer,operLev,operHea,isOperSW,isOp10DaysSW,preInDays:%Integer,afterOpDays:%Integer,inDays:%Integer,fee:%Float") [ SqlProc ]
{
}

ClassMethod GetDHMRInfoLocExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", dep As %String = "", grpCode As %String = "", diagMatch As %String = "") As %Status
{
	n (qHandle,startDate,endDate,hosId,dep,grpCode,diagMatch)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    q:startDate="" $$$OK
    q:endDate="" $$$OK
    k data
    s startDate=$zdh(startDate,3)
    s endDate=$zdh(endDate,3)
    
  	f date=startDate:1:endDate d
	.s mrInfoRowid=0
    .f  s mrInfoRowid=$o(^DHCMRInfo(0,"MR_DIS_DATE",date,mrInfoRowid)) q:$g(mrInfoRowid)=""  d
    ..Q:'$D(^DHCMRInfo(mrInfoRowid))
    ..s patCYZYZD=$P(^DHCMRInfo(mrInfoRowid),"^",52) ; 出院主要诊断
    ..q:(diagMatch'="")&&(..CheckString(diagMatch,MR_CYZYZD)=0)
    ..s admId=$P(^DHCMRInfo(mrInfoRowid),"^",6) ;就诊Rowid
    ..s patLYType=$P(^DHCMRInfo(mrInfoRowid),"^",46) ;离院方式
	..s patDeptDR=$P(^DHCMRInfo(mrInfoRowid),"^",40) ;出院科别
	..s patDeptDR=$P($g(^PAADM(admId)),"^",4)
	..q:(dep'="")&&'$find(","_dep_",",","_patDeptDR_",")
	..s locDesc=..GetLocDesc(patDeptDR) 			;病人科室
	..s patDepDesc=$p($g(^CTLOC(+patDeptDR)),"^",2)
	..s hos=$P($g(^CTLOC(+patDeptDR)),"^",22)
	..q:(hosId'="")&&'$find(","_hosId_",",","_hos_",")
	..s mrBAH=$P(^DHCMRInfo(mrInfoRowid),"^",4) ;病案号
	..s mrName=$P(^DHCMRInfo(mrInfoRowid),"^",8) ;姓名
	..s patZY=$P(^DHCMRInfo(mrInfoRowid),"^",20) ;职业
	..s admDate=$P($g(^PAADM(admId)),"^",6)
	..s admDiag=$P(^DHCMRInfo(mrInfoRowid),"^",54) ;出院主要诊断入院病情
	..s mrZYZFF=$P(^DHCMRInfo(mrInfoRowid),"^",231)   ;住院总费用
	..s patCYZYZD=$P(^DHCMRInfo(mrInfoRowid),"^",52) ; 出院主要诊断
	..s patCYZYZDMC=$P(^DHCMRInfo(mrInfoRowid),"^",53) ; 出院主要诊断名称
	..s patInDays=$P(^DHCMRInfo(mrInfoRowid),"^",42) ;住院天数
	..s patOperBM=$P(^DHCMRInfo(mrInfoRowid),"^",119) ;手术编码
	..q:patOperBM=""
	..s patOperName=$P(^DHCMRInfo(mrInfoRowid),"^",122) ;手术名称
	..s patOperDate=$P(^DHCMRInfo(mrInfoRowid),"^",121) ;手术日期
	..s patRYTJ=$P(^DHCMRInfo(mrInfoRowid),"^",34) ;入院途径
	..s admDiag=$P(^DHCMRInfo(mrInfoRowid),"^",45) ;入院病情
	..s patOperHealLev=$P(^DHCMRInfo(mrInfoRowid),"^",127) ;切口愈合等级(一类切口/甲)
	..s operLev=$P(patOperHealLev,"/",1) ;切口类型
	..s operHea=$P(patOperHealLev,"/",2) ;愈合等级
	..s mrZLJG=$P(^DHCMRInfo(mrInfoRowid),"^",55)
	..s otherOper1=$P(^DHCMRInfo(mrInfoRowid),"^",119)
	..s otherOper2=$P(^DHCMRInfo(mrInfoRowid),"^",130)
	..s otherOper3=$P(^DHCMRInfo(mrInfoRowid),"^",141)
	..s otherOper4=$P(^DHCMRInfo(mrInfoRowid),"^",152)
	..s otherOper5=$P(^DHCMRInfo(mrInfoRowid),"^",163)
	..s otherOper6=$P(^DHCMRInfo(mrInfoRowid),"^",174)
	..s otherOper7=$P(^DHCMRInfo(mrInfoRowid),"^",185)
	..s otherOper8=$P(^DHCMRInfo(mrInfoRowid),"^",196)
	..s ssFlag=0
	..s ssrcNum=0  ;手术人次数
	..s zlxczNum=0,zdxczNum=0  ;治疗性操作人次数;诊断性操作人次数
	..s num=1 ;手术、操作人数
	..s ssrsNum=0 ;手术人数
	..f i=1:1:8 d
	...s Flag="otherOper"_i
	...q:@Flag=""
	...i ..GetOperICD10Map(@Flag)=""  d  ;手术人次数
	....s ssrcNum=ssrcNum+1
	....s ssFlag=1
	...i ..GetOperICD10Map(@Flag)="治疗性操作" s zlxczNum=zlxczNum+1  ;治疗性操作人次数
	...i ..GetOperICD10Map(@Flag)="诊断性操作" s zdxczNum=zdxczNum+1  ;诊断性操作人次数
	..i ssFlag=1 s ssrsNum=1 ;手术人数
	..s bsret=##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(patDeptDR,grpCode,"")
	..s locGrpCode=$P(bsret,"^",2)
	..s locGrpDesc=$P(bsret,"^",1)
	..s locGrpOrder=$P(bsret,"^",2)
	..s isOp10DaysSW=..IsOp10DaysSW(mrInfoRowid) ;术后10日死亡
	..s isOperSW=..IsOperSW(mrInfoRowid) ;手术死亡
	..s preInDays=..PreInDays(mrInfoRowid) 		;术前住院天数
	..s afterOpDays=..AfterOpDays(mrInfoRowid) 	;术后住院天数
	..d OutRowDHCWLMRInfoLoc

    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutRowDHCWLMRInfoLoc
	s Data=$lb(patDeptDR,locDesc,locGrpCode,locGrpDesc,locGrpOrder,ssrcNum,zlxczNum,zdxczNum,num,ssrsNum,operLev,operHea,isOperSW,isOp10DaysSW,preInDays,afterOpDays,patInDays,mrZYZFF)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDHMRInfoLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDHMRInfoLocExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDHMRInfoLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDHMRInfoLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      HeTong
/// CreatDate：    2018-07-06
/// Description：  病案统计报表（再入院1）
/// Table：        DHCMRInfo
/// Input：        startDate,endDate
/// OutPut:	
/// d ##Class(%ResultSet).RunQuery("web.QueryMrInfo","GetMRInfoReIns","2019-05-01","2019-05-30",,,"DiagSortCode","Diag")
Query GetMRInfoReIns(startDate As %String, endDate As %String, hosId As %String = "", dep As %String = "", diagGrp As %String = "", flag As %String = "", sameFlag As %String = "") As %Query(ROWSPEC = "ID:%Integer,mIcdCat,lyfs,reIns,num:%Integer,inDays:%Integer,fee:%Float,drugFee:%Float") [ SqlProc ]
{
}

ClassMethod GetMRInfoReInsExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", dep As %String = "", diagGrp As %String = "", flag As %String = "", sameFlag As %String = "") As %Status
{
	n (qHandle,startDate,endDate,hosId,dep,diagGrp,flag,sameFlag)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    q:startDate="" $$$OK
    q:endDate="" $$$OK
    k ^TEMPDHCWL($j)
    s startDate=$zdh(startDate,3)
    s endDate=$zdh(endDate,3)
    f date=startDate:1:endDate d
	.s mrInfoRowid=0
    .f  s mrInfoRowid=$o(^DHCMRInfo(0,"MR_DIS_DATE",date,mrInfoRowid)) q:$g(mrInfoRowid)=""  d
    ..Q:'$D(^DHCMRInfo(mrInfoRowid))
    ..s admId=$P(^DHCMRInfo(mrInfoRowid),"^",6) ;就诊Rowid
    ..s patLYType=..GetPatLYFS(mrInfoRowid)		;患者离院方式 
	..s patDeptDR=$P(^DHCMRInfo(mrInfoRowid),"^",40) ;出院科别
	..s patDeptDR=$P($g(^PAADM(admId)),"^",4)
	..q:(dep'="")&&'$find(","_dep_",",","_patDeptDR_",")
	..s hos=$P($g(^CTLOC(patDeptDR)),"^",22)
	..q:(hosId'="")&&'$find(","_hosId_",",","_hos_",")
	..s patCYZYZDMC=$P(^DHCMRInfo(mrInfoRowid),"^",53) ; 出院主要诊断名称
	..s patInDays=$P(^DHCMRInfo(mrInfoRowid),"^",42) ;住院天数
	..s mrZYZFF=$P(^DHCMRInfo(mrInfoRowid),"^",231)   ;住院总费用
	..s mrXYFee=$P(^DHCMRInfo(mrInfoRowid),"^",248)   ;西药费用
	..s mrZhCHYFee=$P(^DHCMRInfo(mrInfoRowid),"^",250)   ;中成药费用
	..s mrZhCYFee=$P(^DHCMRInfo(mrInfoRowid),"^",251)   ;中草药费用
	..s patOperBM=$P(^DHCMRInfo(mrInfoRowid),"^",119) ;手术编码
	..s patCYZYZD=$P(^DHCMRInfo(mrInfoRowid),"^",52) ; 出院主要诊断
	..s mrCate=patCYZYZD
	..i flag="Oper" s mrCate=patOperBM
    ..s diag=##Class(web.QueryMrInfo).GetMRConfigDesc(mrCate,diagGrp)
    ..q:diag=""
    ..s reIns=##Class(web.QueryMrInfo).GetReIns(mrInfoRowid,sameFlag)
    ..s dim=patLYType_","_reIns
    ..f i=1:1:$l(diag,"^") d
	...s diagoper=$P(diag,"^",i)
    ...s ^TEMPDHCWL($j,diagoper,dim,"Num")=$g(^TEMPDHCWL($j,diagoper,dim,"Num"))+1
    ...s ^TEMPDHCWL($j,diagoper,dim,"InDays")=$g(^TEMPDHCWL($j,diagoper,dim,"InDays"))+patInDays
    ...s ^TEMPDHCWL($j,diagoper,dim,"Fee")=$g(^TEMPDHCWL($j,diagoper,dim,"Fee"))+mrZYZFF
    ...s ^TEMPDHCWL($j,diagoper,dim,"DrugFee")=$g(^TEMPDHCWL($j,diagoper,dim,"DrugFee"))+mrXYFee+mrZhCHYFee
   
	s mainIcdDr=$o(^DHCMRICDCate(0,"Code",diagGrp,0))
	s ID=0 f  s ID=$o(^DHCMRICDCateDetails(0,"ICDCDr",mainIcdDr,ID)) q:ID=""  d
	.s mIcdCat=$P($g(^DHCMRICDCateDetails(ID)),"^",1)
	.i '$d(^TEMPDHCWL($j,mIcdCat)) d
	..s lyfs="",reIns="",num=0,inDays=0,fee=0,drugFee=0
	..d OutRowGetMRInfoReIns
	.e  d
	..s str="" f  s str=$o(^TEMPDHCWL($j,mIcdCat,str)) q:str=""  d
	...s lyfs=$p(str,",",1)
	...s reIns=$p(str,",",2)
	...s num=$g(^TEMPDHCWL($j,mIcdCat,str,"Num"))
	...s inDays=$g(^TEMPDHCWL($j,mIcdCat,str,"InDays"))
	...s fee=$g(^TEMPDHCWL($j,mIcdCat,str,"Fee"))
	...s drugFee=$g(^TEMPDHCWL($j,mIcdCat,str,"DrugFee"))
	...
	...d OutRowGetMRInfoReIns
	
	k ^TEMPDHCWL($j)
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutRowGetMRInfoReIns
	s Data=$lb(ID,mIcdCat,lyfs,reIns,num,inDays,fee,drugFee)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetMRInfoReInsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRInfoReInsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRInfoReInsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRInfoReInsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      HeTong
/// CreatDate：    2018-07-06
/// Description：  病案统计报表（再入院2）
/// Table：        DHCMRInfo
/// Input：        startDate,endDate
/// OutPut:	
/// d ##Class(%ResultSet).RunQuery("web.QueryMrInfo","GetMRInfoReInsSin","2019-05-01","2019-05-31",,,,"Diag")
Query GetMRInfoReInsSin(startDate As %String, endDate As %String, hosId As %String = "", dep As %String = "", diagGrp As %String = "", flag As %String = "", sameFlag As %String = "") As %Query(ROWSPEC = "ID:%String,mIcdCat,lyfs,reIns,num:%Integer,inDays:%Integer,fee:%Float,drugFee:%Float") [ SqlProc ]
{
}

ClassMethod GetMRInfoReInsSinExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", dep As %String = "", diagGrp As %String = "", flag As %String = "", sameFlag As %String = "") As %Status
{
	n (qHandle,startDate,endDate,hosId,dep,diagGrp,flag,sameFlag)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    q:startDate="" $$$OK
    q:endDate="" $$$OK
    k ^TEMPDHCWL($j)
    s startDate=$zdh(startDate,3)
    s endDate=$zdh(endDate,3)
    f date=startDate:1:endDate d
	.s mrInfoRowid=0
    .f  s mrInfoRowid=$o(^DHCMRInfo(0,"MR_DIS_DATE",date,mrInfoRowid)) q:$g(mrInfoRowid)=""  d
    ..Q:'$D(^DHCMRInfo(mrInfoRowid))
    ..s admId=$P(^DHCMRInfo(mrInfoRowid),"^",6) ;就诊Rowid
	..s patDeptDR=$P(^DHCMRInfo(mrInfoRowid),"^",40) ;出院科别
	..s patDeptDR=$P($g(^PAADM(admId)),"^",4)
	..q:(dep'="")&&'$find(","_dep_",",","_patDeptDR_",")
	..s hos=$P($g(^CTLOC(patDeptDR)),"^",22)
	..q:(hosId'="")&&'$find(","_hosId_",",","_hos_",")
	..s patCYZYZDMC=$P(^DHCMRInfo(mrInfoRowid),"^",53) ; 出院主要诊断名称
	..s patInDays=$P(^DHCMRInfo(mrInfoRowid),"^",42) ;住院天数
	..s mrZYZFF=$P(^DHCMRInfo(mrInfoRowid),"^",231)   ;住院总费用
	..s mrXYFee=$P(^DHCMRInfo(mrInfoRowid),"^",248)   ;西药费用
	..s mrZhCHYFee=$P(^DHCMRInfo(mrInfoRowid),"^",250)   ;中成药费用
	..s mrZhCYFee=$P(^DHCMRInfo(mrInfoRowid),"^",251)   ;中草药费用
	..s patOperBM=$P(^DHCMRInfo(mrInfoRowid),"^",119) ;手术编码
	..s patOperDesc=$P(^DHCMRInfo(mrInfoRowid),"^",122)
	..s patCYZYZD=$P(^DHCMRInfo(mrInfoRowid),"^",52) ; 出院主要诊断
	..s patCYZYZDMC=$P(^DHCMRInfo(mrInfoRowid),"^",53) ; 出院主要诊断名称
	..s mrCate=patDeptDR
	..s mrCateDesc=$P($g(^CTLOC(patDeptDR)),"^",2)
	..i mrCateDesc [ "-" s mrCateDesc=$P(mrCateDesc,"-",2)
	..i flag="Oper" d
	...s mrCate=patOperBM
	...s mrCateDesc=patOperDesc
	..i flag="Diag" d
	...s mrCate=patCYZYZD
	...s mrCateDesc=patCYZYZDMC
    ..q:mrCate=""
    ..s reIns=##Class(web.QueryMrInfo).GetReIns(mrInfoRowid,sameFlag)
    ..s patLYType=..GetPatLYFS(mrInfoRowid)		;患者离院方式
    ..s dim=mrCate_","_mrCateDesc_","_patLYType_","_reIns
    ..s ^TEMPDHCWL($j,dim,"Num")=$g(^TEMPDHCWL($j,dim,"Num"))+1
    ..s ^TEMPDHCWL($j,dim,"InDays")=$g(^TEMPDHCWL($j,dim,"InDays"))+patInDays
    ..s ^TEMPDHCWL($j,dim,"Fee")=$g(^TEMPDHCWL($j,dim,"Fee"))+mrZYZFF
    ..s ^TEMPDHCWL($j,dim,"DrugFee")=$g(^TEMPDHCWL($j,dim,"DrugFee"))+mrXYFee+mrZhCHYFee
   
	s str="" f  s str=$o(^TEMPDHCWL($j,str)) q:str=""  d
	.s ID=$p(str,",",1)
	.s mIcdCat=$p(str,",",2)
	.s lyfs=$p(str,",",3)
	.s reIns=$p(str,",",4)
	.s num=$g(^TEMPDHCWL($j,str,"Num"))
	.s inDays=$g(^TEMPDHCWL($j,str,"InDays"))
	.s fee=$g(^TEMPDHCWL($j,str,"Fee"))
	.s drugFee=$g(^TEMPDHCWL($j,str,"DrugFee"))
	.d OutRowGetMRInfoReInsSin
	
	k ^TEMPDHCWL($j)
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutRowGetMRInfoReInsSin
	s Data=$lb(ID,mIcdCat,lyfs,reIns,num,inDays,fee,drugFee)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetMRInfoReInsSinFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRInfoReInsSinExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRInfoReInsSinClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRInfoReInsSinExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      HeTong
/// CreatDate：    2018-08-28
/// Description：  病案统计报表（三日确诊人数 离院方式 手术人数  术后十日死亡人数 转归情况）
/// Table：        DHCMRInfo
/// Input：        startDate,endDate
/// OutPut:	
/// d ##Class(%ResultSet).RunQuery("web.QueryMrInfo","GetMRInfoDisType","2017-07-01","2017-10-30",,,"OperEmpCode18","Oper")
Query GetMRInfoDisType(startDate As %String, endDate As %String, hosId As %String = "", dep As %String = "", diagGrp As %String = "", flag As %String = "") As %Query(ROWSPEC = "ID:%Integer,mIcdCat,lyfs,is3Days,isOper,isOp10DaysSW,mrZLJG1,num:%Integer,inDays:%Integer,fee:%Float,preInDays:%Integer,qjcs:%Integer,qjcgcs:%Integer") [ SqlProc ]
{
}

ClassMethod GetMRInfoDisTypeExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", dep As %String = "", diagGrp As %String = "", flag As %String = "") As %Status
{
	n (qHandle,startDate,endDate,hosId,dep,diagGrp,flag)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    q:startDate="" $$$OK
    q:endDate="" $$$OK
    k ^TEMPDHCWL($j)
    s startDate=$zdh(startDate,3)
    s endDate=$zdh(endDate,3)
    f date=startDate:1:endDate d
	.s mrInfoRowid=0
    .f  s mrInfoRowid=$o(^DHCMRInfo(0,"MR_DIS_DATE",date,mrInfoRowid)) q:$g(mrInfoRowid)=""  d
    ..Q:'$D(^DHCMRInfo(mrInfoRowid))
    ..s admId=$P(^DHCMRInfo(mrInfoRowid),"^",6) 		;就诊Rowid
    ..s patLYType=..GetPatLYFS(mrInfoRowid) 			;离院方式
	..s patDeptDR=$P(^DHCMRInfo(mrInfoRowid),"^",40) 	;出院科别
	..s patDeptDR=$P($g(^PAADM(admId)),"^",4)
	..q:(dep'="")&&'$find(","_dep_",",","_patDeptDR_",")
	..s hos=$P($g(^CTLOC(+patDeptDR)),"^",22)
	..q:(hosId'="")&&'$find(","_hosId_",",","_hos_",")
	..s patCYZYZDMC=$P(^DHCMRInfo(mrInfoRowid),"^",53) 	; 出院主要诊断名称
	..s patInDays=$P(^DHCMRInfo(mrInfoRowid),"^",42) 	;住院天数
	..s mrZYZFF=$P(^DHCMRInfo(mrInfoRowid),"^",231)   	;住院总费用
	..s patOperBM=$P(^DHCMRInfo(mrInfoRowid),"^",119) 	;手术编码
	..s patCYZYZD=$P(^DHCMRInfo(mrInfoRowid),"^",52) 	;出院主要诊断
	..s qjcs=+$P(^DHCMRInfo(mrInfoRowid),"^",229) 		;抢救次数
	..s qjcgcs=+$P(^DHCMRInfo(mrInfoRowid),"^",230) 	;抢救成功次数
	..s mrZLJG1=$P(^DHCMRInfo(mrInfoRowid),"^",55) 		;转归
	..s harmCode=$P(^DHCMRInfo(mrInfoRowid),"^",260) 	;损伤中毒编码
	..s mrCate=patCYZYZD
	..i flag="Oper" s mrCate=patOperBM
	..i flag="Harm" s mrCate=harmCode
    ..s diag=##Class(web.QueryMrInfo).GetMRConfigDesc(mrCate,diagGrp)
    ..q:diag=""
    ..;三日确诊人数 离院方式 手术人数  术后十日死亡人数 转归情况
    ..s is3Days=..Is3Days(mrInfoRowid) ;是否三日内手术
    ..s isOper=..IsOperNum(mrInfoRowid) ;是否手术人数
    ..s isOp10DaysSW=..IsOp10DaysSW(mrInfoRowid) ;是否术后十日死亡人数
    ..s preInDays=..PreInDays(mrInfoRowid)
    ..s dim=patLYType_","_is3Days_","_isOper_","_isOp10DaysSW_","_mrZLJG1
    ..f i=1:1:$l(diag,"^") d
	...s diagoper=$P(diag,"^",i)
    ...s ^TEMPDHCWL($j,diagoper,dim,"Num")=$g(^TEMPDHCWL($j,diagoper,dim,"Num"))+1
    ...s ^TEMPDHCWL($j,diagoper,dim,"InDays")=$g(^TEMPDHCWL($j,diagoper,dim,"InDays"))+patInDays
    ...s ^TEMPDHCWL($j,diagoper,dim,"Fee")=$g(^TEMPDHCWL($j,diagoper,dim,"Fee"))+mrZYZFF
    ...s ^TEMPDHCWL($j,diagoper,dim,"PreInDays")=$g(^TEMPDHCWL($j,diagoper,dim,"PreInDays"))+preInDays
    ...s ^TEMPDHCWL($j,diagoper,dim,"QJCS")=$g(^TEMPDHCWL($j,diagoper,dim,"QJCS"))+qjcs
    ...s ^TEMPDHCWL($j,diagoper,dim,"QJCGCS")=$g(^TEMPDHCWL($j,diagoper,dim,"QJCGCS"))+qjcgcs
   
	s mainIcdDr=$o(^DHCMRICDCate(0,"Code",diagGrp,0))
	s ID=0 f  s ID=$o(^DHCMRICDCateDetails(0,"ICDCDr",mainIcdDr,ID)) q:ID=""  d
	.s mIcdCat=$P($g(^DHCMRICDCateDetails(ID)),"^",1)
	.i '$d(^TEMPDHCWL($j,mIcdCat)) d
	..s patLYType="",is3Days="",isOper="",isOp10DaysSW="",mrZLJG1=""
	..s num=0,inDays=0,fee=0,qjcs=0,qjcgcs=0,preInDays=0
	..d OutRowMRInfoDisType
	.e  d
	..s str="" f  s str=$o(^TEMPDHCWL($j,mIcdCat,str)) q:str=""  d
	...s lyfs=$p(str,",",1)
	...s is3Days=$p(str,",",2)
	...s isOper=$p(str,",",3)
	...s isOp10DaysSW=$p(str,",",4)
	...s mrZLJG1=$p(str,",",5)
	...s num=$g(^TEMPDHCWL($j,mIcdCat,str,"Num"))
	...s inDays=$g(^TEMPDHCWL($j,mIcdCat,str,"InDays"))
	...s fee=$g(^TEMPDHCWL($j,mIcdCat,str,"Fee"))
	...s preInDays=$g(^TEMPDHCWL($j,mIcdCat,str,"PreInDays"))
	...s qjcs=$g(^TEMPDHCWL($j,mIcdCat,str,"QJCS"))
	...s qjcgcs=$g(^TEMPDHCWL($j,mIcdCat,str,"QJCGCS"))
	...d OutRowMRInfoDisType
	
	k ^TEMPDHCWL($j)
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutRowMRInfoDisType
	s Data=$lb(ID,mIcdCat,lyfs,is3Days,isOper,isOp10DaysSW,mrZLJG1,num,inDays,fee,preInDays,qjcs,qjcgcs)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetMRInfoDisTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRInfoDisTypeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRInfoDisTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRInfoDisTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      HeTong
/// CreatDate：    2018-08-28
/// Description：  病案统计报表（手术人数 性别 年龄段  入院途径 离院方式）
/// Table：        DHCMRInfo
/// Input：        startDate,endDate
/// OutPut:	
/// d ##Class(%ResultSet).RunQuery("web.QueryMrInfo","GetMRInfoSexAge","2017-07-01","2017-07-30",,,"HarmPoison","Harm")
Query GetMRInfoSexAge(startDate As %String, endDate As %String, hosId As %String = "", dep As %String = "", diagGrp As %String = "", flag As %String = "") As %Query(ROWSPEC = "ID:%Integer,mIcdCat,lyfs,isOper,patSex,patAge,mrRYTJ,num:%Integer,inDays:%Integer,fee:%Float,preInDays:%Integer") [ SqlProc ]
{
}

ClassMethod GetMRInfoSexAgeExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", dep As %String = "", diagGrp As %String = "", flag As %String = "") As %Status
{
	n (qHandle,startDate,endDate,hosId,dep,diagGrp,flag)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    q:startDate="" $$$OK
    q:endDate="" $$$OK
    k ^TEMPDHCWL($j)
    s startDate=$zdh(startDate,3)
    s endDate=$zdh(endDate,3)
    f date=startDate:1:endDate d
	.s mrInfoRowid=0
    .f  s mrInfoRowid=$o(^DHCMRInfo(0,"MR_DIS_DATE",date,mrInfoRowid)) q:$g(mrInfoRowid)=""  d
    ..Q:'$D(^DHCMRInfo(mrInfoRowid))
    ..s admId=$P(^DHCMRInfo(mrInfoRowid),"^",6) 		;就诊Rowid
    ..s patLYType=..GetPatLYFS(mrInfoRowid) 			;离院方式
    ..s patSex=..GetpatSex(mrInfoRowid) 				;性别
    ..s mrRYTJ=$P(^DHCMRInfo(mrInfoRowid),"^",34) 		;入院途径
	..s patDeptDR=$P(^DHCMRInfo(mrInfoRowid),"^",40) 	;出院科别
	..s patDeptDR=$P($g(^PAADM(admId)),"^",4)
	..q:(dep'="")&&'$find(","_dep_",",","_patDeptDR_",")
	..s hos=$P($g(^CTLOC(+patDeptDR)),"^",22)
	..q:(hosId'="")&&'$find(","_hosId_",",","_hos_",")
	..s patCYZYZDMC=$P(^DHCMRInfo(mrInfoRowid),"^",53) 	;出院主要诊断名称
	..s patInDays=$P(^DHCMRInfo(mrInfoRowid),"^",42) 	;住院天数
	..s mrZYZFF=$P(^DHCMRInfo(mrInfoRowid),"^",231)   	;住院总费用
	..s patOperBM=$P(^DHCMRInfo(mrInfoRowid),"^",119) 	;手术编码
	..s patCYZYZD=$P(^DHCMRInfo(mrInfoRowid),"^",52) 	;出院主要诊断
	..s harmCode=$P(^DHCMRInfo(mrInfoRowid),"^",260) 	;损伤中毒编码
	..s mrCate=patCYZYZD
	..i flag="Oper" s mrCate=patOperBM
	..i flag="Harm" s mrCate=harmCode
    ..s diag=##Class(web.QueryMrInfo).GetMRConfigDesc(mrCate,diagGrp)
    ..q:diag=""
    ..;手术人数 性别 年龄段  入院途径 离院方式
    ..s isOper=..IsOperNum(mrInfoRowid) ;是否手术人数
    ..s patAge=..GetPatSexAge(mrInfoRowid) ;年龄段
    ..s preInDays=..PreInDays(mrInfoRowid) ;术前住院日
    ..s dim=patLYType_","_isOper_","_patSex_","_patAge_","_mrRYTJ
    ..f i=1:1:$l(diag,"^") d
	...s diagoper=$P(diag,"^",i)
    ...s ^TEMPDHCWL($j,diagoper,dim,"Num")=$g(^TEMPDHCWL($j,diagoper,dim,"Num"))+1
    ...s ^TEMPDHCWL($j,diagoper,dim,"InDays")=$g(^TEMPDHCWL($j,diagoper,dim,"InDays"))+patInDays
    ...s ^TEMPDHCWL($j,diagoper,dim,"Fee")=$g(^TEMPDHCWL($j,diagoper,dim,"Fee"))+mrZYZFF
    ...s ^TEMPDHCWL($j,diagoper,dim,"PreInDays")=$g(^TEMPDHCWL($j,diagoper,dim,"PreInDays"))+preInDays
   
	s mainIcdDr=$o(^DHCMRICDCate(0,"Code",diagGrp,0))
	s ID=0 f  s ID=$o(^DHCMRICDCateDetails(0,"ICDCDr",mainIcdDr,ID)) q:ID=""  d
	.s mIcdCat=$P($g(^DHCMRICDCateDetails(ID)),"^",1)
	.i '$d(^TEMPDHCWL($j,mIcdCat)) d
	..s lyfs="",isOper="",patSex="",patAge="",mrRYTJ=""
	..s num=0,inDays=0,fee=0,preInDays=0
	..d OutRowMRInfoSexAge
	.e  d
	..s str="" f  s str=$o(^TEMPDHCWL($j,mIcdCat,str)) q:str=""  d
	...s lyfs=$p(str,",",1)
	...s isOper=$p(str,",",2)
	...s patSex=$p(str,",",3)
	...s patAge=$p(str,",",4)
	...s mrRYTJ=$p(str,",",5)
	...s num=$g(^TEMPDHCWL($j,mIcdCat,str,"Num"))
	...s inDays=$g(^TEMPDHCWL($j,mIcdCat,str,"InDays"))
	...s fee=$g(^TEMPDHCWL($j,mIcdCat,str,"Fee"))
	...s preInDays=$g(^TEMPDHCWL($j,mIcdCat,str,"PreInDays"))
	...d OutRowMRInfoSexAge
	
	k ^TEMPDHCWL($j)
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutRowMRInfoSexAge
	s Data=$lb(ID,mIcdCat,lyfs,isOper,patSex,patAge,mrRYTJ,num,inDays,fee,preInDays)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetMRInfoSexAgeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRInfoSexAgeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRInfoSexAgeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRInfoSexAgeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      HeTong
/// CreatDate：    2018-08-28
/// Description：  病案统计报表（入院病情  24、48小时内死亡 服务半径）
/// Table：        DHCMRInfo
/// Input：        startDate,endDate
/// OutPut:	
/// d ##Class(%ResultSet).RunQuery("web.QueryMrInfo","GetMRInfoSerRad","2017-07-01","2017-07-30",,,"DiagSortCode","Diag")
Query GetMRInfoSerRad(startDate As %String, endDate As %String, hosId As %String = "", dep As %String = "", diagGrp As %String = "", flag As %String = "") As %Query(ROWSPEC = "ID:%Integer,mIcdCat,mrRYBQ,rysw,serRad,num:%Integer,inDays:%Integer,fee:%Float") [ SqlProc ]
{
}

ClassMethod GetMRInfoSerRadExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", dep As %String = "", diagGrp As %String = "", flag As %String = "") As %Status
{
	n (qHandle,startDate,endDate,hosId,dep,diagGrp,flag)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    q:startDate="" $$$OK
    q:endDate="" $$$OK
    k ^TEMPDHCWL($j)
    s startDate=$zdh(startDate,3)
    s endDate=$zdh(endDate,3)
    f date=startDate:1:endDate d
	.s mrInfoRowid=0
    .f  s mrInfoRowid=$o(^DHCMRInfo(0,"MR_DIS_DATE",date,mrInfoRowid)) q:$g(mrInfoRowid)=""  d
    ..Q:'$D(^DHCMRInfo(mrInfoRowid))
    ..s admId=$P(^DHCMRInfo(mrInfoRowid),"^",6) 		;就诊Rowid
    ..s patLYType=$P(^DHCMRInfo(mrInfoRowid),"^",46) 	;离院方式
    ..s mrRYBQ=..GetPatRYBQ(mrInfoRowid) 				;入院病情
	..s patDeptDR=$P(^DHCMRInfo(mrInfoRowid),"^",40) 	;出院科别
	..s patDeptDR=$P($g(^PAADM(admId)),"^",4)
	..q:(dep'="")&&'$find(","_dep_",",","_patDeptDR_",")
	..s hos=$P($g(^CTLOC(+patDeptDR)),"^",22)
	..q:(hosId'="")&&'$find(","_hosId_",",","_hos_",")
	..s patCYZYZDMC=$P(^DHCMRInfo(mrInfoRowid),"^",53) 	;出院主要诊断名称
	..s patInDays=$P(^DHCMRInfo(mrInfoRowid),"^",42) 	;住院天数
	..s mrZYZFF=$P(^DHCMRInfo(mrInfoRowid),"^",231)   	;住院总费用
	..s patOperBM=$P(^DHCMRInfo(mrInfoRowid),"^",119) 	;手术编码
	..s patCYZYZD=$P(^DHCMRInfo(mrInfoRowid),"^",52) 	;出院主要诊断
	..s harmCode=$P(^DHCMRInfo(mrInfoRowid),"^",260) 	;损伤中毒编码
	..s mrCate=patCYZYZD
	..i flag="Oper" s mrCate=patOperBM
	..i flag="Harm" s mrCate=harmCode
    ..s diag=##Class(web.QueryMrInfo).GetMRConfigDesc(mrCate,diagGrp)
    ..q:diag=""
    ..;入院病情  24、48小时内死亡 服务半径
    ..s rysw=..GetRYSW(mrInfoRowid) ;入院24、48小时内死亡
    ..s serRad=..GetSerRad(mrInfoRowid) ;服务半径
    ..s dim=mrRYBQ_","_rysw_","_serRad
    ..f i=1:1:$l(diag,"^") d
	...s diagoper=$P(diag,"^",i)
    ...s ^TEMPDHCWL($j,diagoper,dim,"Num")=$g(^TEMPDHCWL($j,diagoper,dim,"Num"))+1
    ...s ^TEMPDHCWL($j,diagoper,dim,"InDays")=$g(^TEMPDHCWL($j,diagoper,dim,"InDays"))+patInDays
    ...s ^TEMPDHCWL($j,diagoper,dim,"Fee")=$g(^TEMPDHCWL($j,diagoper,dim,"Fee"))+mrZYZFF
   
	s mainIcdDr=$o(^DHCMRICDCate(0,"Code",diagGrp,0))
	s ID=0 f  s ID=$o(^DHCMRICDCateDetails(0,"ICDCDr",mainIcdDr,ID)) q:ID=""  d
	.s mIcdCat=$P($g(^DHCMRICDCateDetails(ID)),"^",1)
	.i '$d(^TEMPDHCWL($j,mIcdCat)) d
	..s mrRYBQ="",rysw="",serRad="",num=0,inDays=0,fee=0
	..d OutRowMRInfoSerRad
	.e  d
	..s str="" f  s str=$o(^TEMPDHCWL($j,mIcdCat,str)) q:str=""  d
	...s mrRYBQ=$p(str,",",1)
	...s rysw=$p(str,",",2)
	...s serRad=$p(str,",",3)
	...s num=$g(^TEMPDHCWL($j,mIcdCat,str,"Num"))
	...s inDays=$g(^TEMPDHCWL($j,mIcdCat,str,"InDays"))
	...s fee=$g(^TEMPDHCWL($j,mIcdCat,str,"Fee"))
	...d OutRowMRInfoSerRad
	
	k ^TEMPDHCWL($j)
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutRowMRInfoSerRad
	s Data=$lb(ID,mIcdCat,mrRYBQ,rysw,serRad,num,inDays,fee)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetMRInfoSerRadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRInfoSerRadExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRInfoSerRadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRInfoSerRadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      HeTong
/// CreatDate：    2018-08-28
/// Description：  病案统计报表（疾病、手术-------手术人数 性别 年龄段  入院途径 离院方式）
/// Table：        DHCMRInfo
/// Input：        startDate,endDate
/// OutPut:	
/// d ##Class(%ResultSet).RunQuery("web.QueryMrInfo","GetMRInfoSexAgeSin","2018-12-29","2018-12-29")
Query GetMRInfoSexAgeSin(startDate As %String, endDate As %String, hosId As %String = "", dep As %String = "", diagGrp As %String = "", flag As %String = "") As %Query(ROWSPEC = "mrCate,mrCateOrder:%Integer,mrCateDesc,lyfs,isOper,patSex,patAge,mrRYTJ,num:%Integer,inDays:%Integer,fee:%Float,preInDays:%Integer") [ SqlProc ]
{
}

ClassMethod GetMRInfoSexAgeSinExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", dep As %String = "", diagGrp As %String = "", flag As %String = "") As %Status
{
	n (qHandle,startDate,endDate,hosId,dep,diagGrp,flag)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    q:startDate="" $$$OK
    q:endDate="" $$$OK
    k ^TEMPDHCWL($j)
    s startDate=$zdh(startDate,3)
    s endDate=$zdh(endDate,3)
    f date=startDate:1:endDate d
	.s mrInfoRowid=0
     .f  s mrInfoRowid=$o(^DHCMRInfo(0,"MR_DIS_DATE",date,mrInfoRowid)) q:$g(mrInfoRowid)=""  d
    ..Q:'$D(^DHCMRInfo(mrInfoRowid))
    ..s admId=$P(^DHCMRInfo(mrInfoRowid),"^",6) 		;就诊Rowid
    ..s patLYType=..GetPatLYFS(mrInfoRowid) 			;离院方式
    ..s patSex=..GetpatSex(mrInfoRowid) 				;性别
    ..s mrRYTJ=$P(^DHCMRInfo(mrInfoRowid),"^",34) 		;入院途径
	..s patDeptDR=$P(^DHCMRInfo(mrInfoRowid),"^",40) 	;出院科别
	..s patDeptDR=$P($g(^PAADM(admId)),"^",4)
	..q:(dep'="")&&'$find(","_dep_",",","_patDeptDR_",")
	..s hos=$P($g(^CTLOC(+patDeptDR)),"^",22)
	..q:(hosId'="")&&'$find(","_hosId_",",","_hos_",")
	..s patCYZYZD=$P(^DHCMRInfo(mrInfoRowid),"^",52) 	;出院主要诊断
	..s patCYZYZDMC=$P(^DHCMRInfo(mrInfoRowid),"^",53) 	;出院主要诊断名称
	..s patInDays=$P(^DHCMRInfo(mrInfoRowid),"^",42) 	;住院天数
	..s mrZYZFF=$P(^DHCMRInfo(mrInfoRowid),"^",231)   	;住院总费用
	..s patOperBM=$P(^DHCMRInfo(mrInfoRowid),"^",119) 	;手术编码
	..s patOperMC=$P(^DHCMRInfo(mrInfoRowid),"^",122) 	;手术名称
	..s mrCate=patCYZYZD
	..s mrCateDesc=patCYZYZDMC
	..i flag="Oper" d
	...s mrCate=patOperBM
	...s mrCateDesc=patOperMC
	..q:mrCate=""
	..s:diagGrp'="" diag=##Class(web.QueryMrInfo).GetIcdCatDesc(diagGrp,$ZCVT(mrCate,"U"))
    ..q:(diagGrp'="")&&(diag="")
    ..;手术人数 性别 年龄段  入院途径 离院方式
    ..s isOper=..IsOperNum(mrInfoRowid) ;是否手术人数
    ..s patAge=..GetPatSexAge(mrInfoRowid) ;年龄段
    ..s preInDays=..PreInDays(mrInfoRowid) ;术前住院日
    ..i diagGrp'="" d
    ...s dim=patLYType_","_isOper_","_patSex_","_patAge_","_mrRYTJ
    ...f i=1:1:$l(diag,"^") d
	....s diagoper=$P(diag,"^",i)
    ....s ^TEMPDHCWL($j,diagoper,dim,"Num")=$g(^TEMPDHCWL($j,diagoper,dim,"Num"))+1
    ....s ^TEMPDHCWL($j,diagoper,dim,"InDays")=$g(^TEMPDHCWL($j,diagoper,dim,"InDays"))+patInDays
    ....s ^TEMPDHCWL($j,diagoper,dim,"Fee")=$g(^TEMPDHCWL($j,diagoper,dim,"Fee"))+mrZYZFF
    ....s ^TEMPDHCWL($j,diagoper,dim,"PreInDays")=$g(^TEMPDHCWL($j,diagoper,dim,"PreInDays"))+preInDays
    ..e  d
    ...s dim=mrCate_","_mrCateDesc_","_patLYType_","_isOper_","_patSex_","_patAge_","_mrRYTJ
    ...s ^TEMPDHCWL($j,dim,"Num")=$g(^TEMPDHCWL($j,dim,"Num"))+1
    ...s ^TEMPDHCWL($j,dim,"InDays")=$g(^TEMPDHCWL($j,dim,"InDays"))+patInDays
    ...s ^TEMPDHCWL($j,dim,"Fee")=$g(^TEMPDHCWL($j,dim,"Fee"))+mrZYZFF
    ...s ^TEMPDHCWL($j,dim,"PreInDays")=$g(^TEMPDHCWL($j,dim,"PreInDays"))+preInDays
    
    i diagGrp'="" d
    .s mrCate=""
	.s mainIcdDr=$o(^DHCMRICDCate(0,"Code",diagGrp,0))
	.s ID=0 f  s ID=$o(^DHCMRICDCateDetails(0,"ICDCDr",mainIcdDr,ID)) q:ID=""  d
	..s mrCateDesc=$P($g(^DHCMRICDCateDetails(ID)),"^",1)
	..s mrCateOrder=$P($g(^DHCMRICDCateDetails(ID)),"^",3)
	..i '$d(^TEMPDHCWL($j,mrCateDesc)) d
	...s lyfs="",isOper="",patSex="",patAge="",mrRYTJ=""
	...s num=0,inDays=0,fee=0,preInDays=0
	...d OutRowMRInfoSexAgeSin
	..e  d
	...s str="" f  s str=$o(^TEMPDHCWL($j,mrCateDesc,str)) q:str=""  d
	....s lyfs=$p(str,",",1)
	....s isOper=$p(str,",",2)
	....s patSex=$p(str,",",3)
	....s patAge=$p(str,",",4)
	....s mrRYTJ=$p(str,",",5)
	....s num=$g(^TEMPDHCWL($j,mrCateDesc,str,"Num"))
	....s inDays=$g(^TEMPDHCWL($j,mrCateDesc,str,"InDays"))
	....s fee=$g(^TEMPDHCWL($j,mrCateDesc,str,"Fee"))
	....s preInDays=$g(^TEMPDHCWL($j,mrCateDesc,str,"PreInDays"))
	....d OutRowMRInfoSexAgeSin
    e  d
    .s mrCateOrder=0
	.s str="" f  s str=$o(^TEMPDHCWL($j,str)) q:str=""  d
	..s mrCate=$p(str,",",1)
	..s mrCateDesc=$p(str,",",2)
	..s lyfs=$p(str,",",3)
	..s isOper=$p(str,",",4)
	..s patSex=$p(str,",",5)
	..s patAge=$p(str,",",6)
	..s mrRYTJ=$p(str,",",7)
	..s num=$g(^TEMPDHCWL($j,str,"Num"))
	..s inDays=$g(^TEMPDHCWL($j,str,"InDays"))
	..s fee=$g(^TEMPDHCWL($j,str,"Fee"))
	..s preInDays=$g(^TEMPDHCWL($j,str,"PreInDays"))
	..d OutRowMRInfoSexAgeSin
	
	
	k ^TEMPDHCWL($j)
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutRowMRInfoSexAgeSin
	s Data=$lb(mrCate,mrCateOrder,mrCateDesc,lyfs,isOper,patSex,patAge,mrRYTJ,num,inDays,fee,preInDays)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetMRInfoSexAgeSinFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRInfoSexAgeSinExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRInfoSexAgeSinClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRInfoSexAgeSinExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      HeTong
/// CreatDate：    2018-08-28
/// Description：  病案统计报表（疾病、手术-------入院病情  24、48小时内死亡 服务半径  手术人数 转归情况 ）
/// Table：        DHCMRInfo
/// Input：        startDate,endDate
/// OutPut:	
/// d ##Class(%ResultSet).RunQuery("web.QueryMrInfo","GetMRInfoSerRadSin","2017-07-01","2017-07-30",,,"OperEmpCode18","Oper")
Query GetMRInfoSerRadSin(startDate As %String, endDate As %String, hosId As %String = "", dep As %String = "", diagGrp As %String = "", flag As %String = "") As %Query(ROWSPEC = "mrCate,mrCateOrder:%Integer,mrCateDesc,mrRYBQ,rysw,serRad,isOper,mrZLJG1,num:%Integer,inDays:%Integer,fee:%Float,preInDays:%Integer") [ SqlProc ]
{
}

ClassMethod GetMRInfoSerRadSinExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", dep As %String = "", diagGrp As %String = "", flag As %String = "") As %Status
{
	n (qHandle,startDate,endDate,hosId,dep,diagGrp,flag)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    q:startDate="" $$$OK
    q:endDate="" $$$OK
    k ^TEMPDHCWL($j)
    s startDate=$zdh(startDate,3)
    s endDate=$zdh(endDate,3)
    f date=startDate:1:endDate d
	.s mrInfoRowid=0
    .f  s mrInfoRowid=$o(^DHCMRInfo(0,"MR_DIS_DATE",date,mrInfoRowid)) q:$g(mrInfoRowid)=""  d
    ..Q:'$D(^DHCMRInfo(mrInfoRowid))
    ..s admId=$P(^DHCMRInfo(mrInfoRowid),"^",6) 			;就诊Rowid
    ..s patLYType=$P(^DHCMRInfo(mrInfoRowid),"^",46) 		;离院方式
    ..s mrRYBQ=..GetPatRYBQ(mrInfoRowid) 					;入院病情
	..s patDeptDR=$P(^DHCMRInfo(mrInfoRowid),"^",40) 		;出院科别
	..s patDeptDR=$P($g(^PAADM(admId)),"^",4)
	..q:(dep'="")&&'$find(","_dep_",",","_patDeptDR_",")
	..s hos=$P($g(^CTLOC(+patDeptDR)),"^",22)
	..q:(hosId'="")&&'$find(","_hosId_",",","_hos_",")
	..s mrZLJG1=$P(^DHCMRInfo(mrInfoRowid),"^",55) 			;转归
	..s patInDays=$P(^DHCMRInfo(mrInfoRowid),"^",42) 		;住院天数
	..s mrZYZFF=$P(^DHCMRInfo(mrInfoRowid),"^",231)   		;住院总费用
	..s patOperBM=$P(^DHCMRInfo(mrInfoRowid),"^",119) 		;手术编码
	..s patOperMC=$P(^DHCMRInfo(mrInfoRowid),"^",122) 		;手术名称
	..s patCYZYZD=$P(^DHCMRInfo(mrInfoRowid),"^",52) 		;出院主要诊断
	..s patCYZYZDMC=$P(^DHCMRInfo(mrInfoRowid),"^",53) 		;出院主要诊断名称
	..s mrCate=patCYZYZD
	..s mrCateDesc=patCYZYZDMC
	..i flag="Oper" d
	...s mrCate=patOperBM
	...s mrCateDesc=patOperMC
	..q:mrCate=""
	..s:diagGrp'="" diag=##Class(web.QueryMrInfo).GetIcdCatDesc(diagGrp,$ZCVT(mrCate,"U"))
    ..q:(diagGrp'="")&&(diag="")
    ..;入院病情  24、48小时内死亡 服务半径  手术人数 转归情况 
    ..s rysw=..GetRYSW(mrInfoRowid) ;入院24、48小时内死亡
    ..s serRad=..GetSerRad(mrInfoRowid) ;服务半径
    ..s isOper=..IsOperNum(mrInfoRowid) ;是否手术人数
    ..s preInDays=..PreInDays(mrInfoRowid) ;术前住院日
    ..i diagGrp'="" d
    ...s dim=mrRYBQ_","_rysw_","_serRad_","_isOper_","_mrZLJG1
    ...f i=1:1:$l(diag,"^") d
	....s diagoper=$P(diag,"^",i)
    ....s ^TEMPDHCWL($j,diagoper,dim,"Num")=$g(^TEMPDHCWL($j,diagoper,dim,"Num"))+1
    ....s ^TEMPDHCWL($j,diagoper,dim,"InDays")=$g(^TEMPDHCWL($j,diagoper,dim,"InDays"))+patInDays
    ....s ^TEMPDHCWL($j,diagoper,dim,"Fee")=$g(^TEMPDHCWL($j,diagoper,dim,"Fee"))+mrZYZFF
    ....s ^TEMPDHCWL($j,diagoper,dim,"PreInDays")=$g(^TEMPDHCWL($j,diagoper,dim,"PreInDays"))+preInDays
    ..e  d
    ...s dim=mrCate_","_mrCateDesc_","_mrRYBQ_","_rysw_","_serRad_","_isOper_","_mrZLJG1
    ...s ^TEMPDHCWL($j,dim,"Num")=$g(^TEMPDHCWL($j,dim,"Num"))+1
    ...s ^TEMPDHCWL($j,dim,"InDays")=$g(^TEMPDHCWL($j,dim,"InDays"))+patInDays
    ...s ^TEMPDHCWL($j,dim,"Fee")=$g(^TEMPDHCWL($j,dim,"Fee"))+mrZYZFF
    ...s ^TEMPDHCWL($j,dim,"PreInDays")=$g(^TEMPDHCWL($j,dim,"PreInDays"))+preInDays
    
    i diagGrp'="" d
    .s mrCate=""
	.s mainIcdDr=$o(^DHCMRICDCate(0,"Code",diagGrp,0))
	.s ID=0 f  s ID=$o(^DHCMRICDCateDetails(0,"ICDCDr",mainIcdDr,ID)) q:ID=""  d
	..s mrCateDesc=$P($g(^DHCMRICDCateDetails(ID)),"^",1)
	..s mrCateOrder=$P($g(^DHCMRICDCateDetails(ID)),"^",3)
	..i '$d(^TEMPDHCWL($j,mrCateDesc)) d
	...s mrRYBQ="",rysw="",serRad="",isOper="",mrZLJG1=""
	...s num=0,inDays=0,fee=0,preInDays=0
	...d OutRowMRInfoSerRadSin
	..e  d
	...s str="" f  s str=$o(^TEMPDHCWL($j,mrCateDesc,str)) q:str=""  d
	....s mrRYBQ=$p(str,",",1)
	....s rysw=$p(str,",",2)
	....s serRad=$p(str,",",3)
	....s isOper=$p(str,",",4)
	....s mrZLJG1=$p(str,",",5)
	....s num=$g(^TEMPDHCWL($j,mrCateDesc,str,"Num"))
	....s inDays=$g(^TEMPDHCWL($j,mrCateDesc,str,"InDays"))
	....s fee=$g(^TEMPDHCWL($j,mrCateDesc,str,"Fee"))
	....s preInDays=$g(^TEMPDHCWL($j,mrCateDesc,str,"PreInDays"))
	....d OutRowMRInfoSerRadSin
    e  d
    .s mrCateOrder=0
	.s str="" f  s str=$o(^TEMPDHCWL($j,str)) q:str=""  d
	..s mrCate=$p(str,",",1)
	..s mrCateDesc=$p(str,",",2)
	..s mrRYBQ=$p(str,",",3)
	..s rysw=$p(str,",",4)
	..s serRad=$p(str,",",5)
	..s isOper=$p(str,",",6)
	..s mrZLJG1=$p(str,",",7)
	..s num=$g(^TEMPDHCWL($j,str,"Num"))
	..s inDays=$g(^TEMPDHCWL($j,str,"InDays"))
	..s fee=$g(^TEMPDHCWL($j,str,"Fee"))
	..s preInDays=$g(^TEMPDHCWL($j,str,"PreInDays"))
	..d OutRowMRInfoSerRadSin
	
	k ^TEMPDHCWL($j)
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutRowMRInfoSerRadSin
	s Data=$lb(mrCate,mrCateOrder,mrCateDesc,mrRYBQ,rysw,serRad,isOper,mrZLJG1,num,inDays,fee,preInDays)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetMRInfoSerRadSinFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRInfoSerRadSinExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRInfoSerRadSinClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRInfoSerRadSinExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      HeTong
/// CreatDate：    2019-08-08
/// Description：  病案统计报表（患者明细）
/// Table：        DHCMRInfo
/// Input：        startDate,endDate
///  			   时间、病案号、出院科室、诊断编码、诊断名称、手术编码 手术名称 （30种疾病等）
/// OutPut:		
/// d ##Class(%ResultSet).RunQuery("web.QueryMrInfo","GetMRInfoDetail","2022-03-01","2022-04-20",,,,,,,,,,,,,,"")
Query GetMRInfoDetail(startDate As %String, endDate As %String, hosId As %String = "", dep As %Text = "", patMedicare As %String = "", diag As %String = "", diagDesc As %String = "", oper As %String = "", operDesc As %String = "", diagGrp As %String = "", rytj As %String = "", lyfs As %String = "", operLev As %String = "", zgqk As %String = "", otherDiag As %String = "", otherDiagDesc As %String = "", allDiag As %String = "", allDiagDesc As %String = "", allOper As %String = "", allOperDesc As %String = "") As %Query(ROWSPEC = "mrBAH,admId,mrName,patSex,patAge,patZY,mrXZZ,admDate,admLocDesc,disDate,disLocDesc,patRYTJ,patLYType,patCYZYZD,patCYZYZDMC,mrCYQTZD1,mrCYQTZDMC1,mrCYQTZD2,mrCYQTZDMC2,mrCYQTZD3,mrCYQTZDMC3,mrCYQTZD4,mrCYQTZDMC4,mrCYQTZD5,mrCYQTZDMC5,patOperDate,patOperBM,patOperName,patOperHealLev,operDate2,mrSSBM2,mrSSMC2,mrSSQKYHDJ2,operDate3,mrSSBM3,mrSSMC3,mrSSQKYHDJ3,operDate4,mrSSBM4,mrSSMC4,mrSSQKYHDJ4,operDate5,mrSSBM5,mrSSMC5,mrSSQKYHDJ5,patInDays:%Integer,mrZYZFF:%Float,mrXYFee:%Float,mrZCHYFee:%Float,mrZCYFee:%Float,mrGrpDesc,mrZYYS") [ SqlProc ]
{
}

ClassMethod GetMRInfoDetailExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", dep As %String = "", patMedicare As %String = "", diag As %String = "", diagDesc As %String = "", oper As %String = "", operDesc As %String = "", diagGrp As %String = "", rytj As %String = "", lyfs As %String = "", operLev As %String = "", zgqk As %String = "", otherDiag As %String = "", otherDiagDesc As %String = "", allDiag As %String = "", allDiagDesc As %String = "", allOper As %String = "", allOperDesc As %String = "") As %Status
{
	n (qHandle,startDate,endDate,hosId,dep,patMedicare,diag,diagDesc,oper,operDesc,diagGrp,rytj,lyfs,operLev,zgqk,otherDiag,otherDiagDesc,allDiag,allDiagDesc,allOper,allOperDesc)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    q:startDate="" $$$OK
    q:endDate="" $$$OK
    s startDate=$zdh(startDate,3)
    s endDate=$zdh(endDate,3)
    s diagCode="",diagType=""
    i diagGrp'="" d
    .s diagCode=$P(diagGrp,":",1)
    .s diagType=$P(diagGrp,":",2)
    s mrGrpDesc=""
    ;*********生成匹配模式表达式************
    s diagMatchStr=".E",otherDiagMatchStr=".E",allDiagMatchStr=".E",operMatchStr=".E",allOperMatchStr=".E"
    s:diagDesc'="" diagMatchStr=..GenerateMatch(diagDesc)
    s:otherDiagDesc'="" otherDiagMatchStr=..GenerateMatch(otherDiagDesc)
    s:allDiagDesc'="" allDiagMatchStr=..GenerateMatch(allDiagDesc)
    s:operDesc'="" operMatchStr=..GenerateMatch(operDesc)
    s:allOperDesc'="" allOperMatchStr=..GenerateMatch(allOperDesc)
    
    ;*****开始循环,通过出院日期检索数据********
  	f date=startDate:1:endDate d
	.s mrInfoRowid=0
    .f  s mrInfoRowid=$o(^DHCMRInfo(0,"MR_DIS_DATE",date,mrInfoRowid)) q:$g(mrInfoRowid)=""  d
    ..Q:'$D(^DHCMRInfo(mrInfoRowid))
    ..s admId=$P(^DHCMRInfo(mrInfoRowid),"^",6) 				;就诊Rowid
    ..s patLYType=$P(^DHCMRInfo(mrInfoRowid),"^",46) 			;离院方式
    ..s patLYTypei=..GetPatLyfsn(patLYType)
    ..q:(lyfs'="")&&'$find(","_lyfs_",",","_patLYTypei_",")
	
	..s patDeptDR=$P(^DHCMRInfo(mrInfoRowid),"^",40) 			;出院科别
	..;s patDeptDR=$P($g(^PAADM(admId)),"^",4)
	..q:patDeptDR=""
	..q:(dep'="")&&'$find(","_dep_",",","_patDeptDR_",")
	..s patDepDesc=$p($g(^CTLOC(patDeptDR)),"^",2)
	..s hos=$P($g(^CTLOC(patDeptDR)),"^",22)
	..q:(hosId'="")&&'$find(","_hosId_",",","_hos_",")
	..s mrZZYS=$P(^DHCMRInfo(mrInfoRowid),"^",271) 				;主治医师
	..s mrZYYS=$P(^DHCMRInfo(mrInfoRowid),"^",272) 				;住院医师
	..s patDoc=$P($g(^PAADM(admId)),"^",9)
	..;s mrZZYS=$p(^CTPCP(patDoc,1),"^",1)
	..s mrZZYS=$$GetPatDoc^DHCWLCommon(patDoc)
	..s patDocDesc=$$GetPatDoc^DHCWLCommon(patDoc)
	..s mrBAH=$P(^DHCMRInfo(mrInfoRowid),"^",4) 				;病案号
	..q:(patMedicare'="")&&(patMedicare'=mrBAH)
	..s mrName=$P(^DHCMRInfo(mrInfoRowid),"^",8) 				;姓名
	..s mrXB=$P(^DHCMRInfo(mrInfoRowid),"^",9) 					;性别
	..s patSex=..GetPatGender(mrXB)
	..s patAge=$P(^DHCMRInfo(mrInfoRowid),"^",11) 				;年龄
	..s patZY=$P(^DHCMRInfo(mrInfoRowid),"^",20) 				;职业
	..s mrXZZ=$P(^DHCMRInfo(mrInfoRowid),"^",22) 				;现住址
	..s admDate=$P(^DHCMRInfo(mrInfoRowid),"^",35) 				;入院时间
	..s admLoc=$P(^DHCMRInfo(mrInfoRowid),"^",36)  				;入院科室
	..s admLocDesc=..GetLocDesc(admLoc)
	..s disDate=$P(^DHCMRInfo(mrInfoRowid),"^",39) 				;出院时间
	..s disLoc=$P(^DHCMRInfo(mrInfoRowid),"^",40)  				;出院科室
	..s disLocDesc=..GetLocDesc(disLoc)
	..s admDiag=$P(^DHCMRInfo(mrInfoRowid),"^",54) 				;出院主要诊断入院病情
	..s diagZGQK=$P(^DHCMRInfo(mrInfoRowid),"^",55) 			;出院主要诊断转归情况
	..s diagZGQK=$Case(diagZGQK,"治愈":"1","好转":"2","未愈":"3","死亡":"4","其他":"9",:"0")
	..q:(zgqk'="")&&'$find(","_zgqk_",",","_diagZGQK_",")
	..s mrZYZFF=$P(^DHCMRInfo(mrInfoRowid),"^",231)   			;住院总费用
	..s patCYZYZD=$P(^DHCMRInfo(mrInfoRowid),"^",52) 			;出院主要诊断
	..q:(diag'="")&&(patCYZYZD'[diag)
	..s patCYZYZDMC=$P(^DHCMRInfo(mrInfoRowid),"^",53) 			;出院主要诊断名称
	..q:(diagDesc'="")&&((patCYZYZDMC?@diagMatchStr)=0)
	..s patOperBM=$P(^DHCMRInfo(mrInfoRowid),"^",119) 			;手术编码
	..s mainOperJB=$P(^DHCMRInfo(mrInfoRowid),"^",120)  		;主要手术级别
	..;w !,mainOperJB
	..s mainOperJB=$Case(mainOperJB,"一级手术":"1","二级手术":"2","三级手术":"3","四级手术":"4",:"5")
	..;s mainOperJB=$Case(mainOperJB,"一级":"1","二级":"2","三级":"3","四级":"4",:"5")
	..;i (patOperBM'="")&&(mainOperJB="5") s mainOperJB="0"
	..q:(operLev'="")&&'$find(","_operLev_",",","_mainOperJB_",")
	..s mrCYQTZD1=$P(^DHCMRInfo(mrInfoRowid),"^",56)
	..s mrCYQTZDMC1=$P(^DHCMRInfo(mrInfoRowid),"^",57)
	..s mrCYQTZD2=$P(^DHCMRInfo(mrInfoRowid),"^",60)
	..s mrCYQTZDMC2=$P(^DHCMRInfo(mrInfoRowid),"^",61)
	..s mrCYQTZD3=$P(^DHCMRInfo(mrInfoRowid),"^",64)
	..s mrCYQTZDMC3=$P(^DHCMRInfo(mrInfoRowid),"^",65)
	..s mrCYQTZD4=$P(^DHCMRInfo(mrInfoRowid),"^",68)
	..s mrCYQTZDMC4=$P(^DHCMRInfo(mrInfoRowid),"^",69)
	..s mrCYQTZD5=$P(^DHCMRInfo(mrInfoRowid),"^",72)
	..s mrCYQTZDMC5=$P(^DHCMRInfo(mrInfoRowid),"^",73)
	..s mrCYQTZD6=$P(^DHCMRInfo(mrInfoRowid),"^",76)
	..s mrCYQTZDMC6=$P(^DHCMRInfo(mrInfoRowid),"^",77)
	..s mrCYQTZD7=$P(^DHCMRInfo(mrInfoRowid),"^",80)
	..s mrCYQTZDMC7=$P(^DHCMRInfo(mrInfoRowid),"^",81)
	..s mrCYQTZD8=$P(^DHCMRInfo(mrInfoRowid),"^",84)
	..s mrCYQTZDMC8=$P(^DHCMRInfo(mrInfoRowid),"^",85)
	..s mrCYQTZD9=$P(^DHCMRInfo(mrInfoRowid),"^",88)
	..s mrCYQTZDMC9=$P(^DHCMRInfo(mrInfoRowid),"^",89)
	..s mrCYQTZD10=$P(^DHCMRInfo(mrInfoRowid),"^",92)
	..s mrCYQTZDMC10=$P(^DHCMRInfo(mrInfoRowid),"^",93)
	..s patInDays=$P(^DHCMRInfo(mrInfoRowid),"^",42) 			;住院天数
	..q:(oper'="")&&(patOperBM'[oper)
	..s patOperName=$P(^DHCMRInfo(mrInfoRowid),"^",122) 		;手术名称
	..q:(operDesc'="")&&((patOperName?@operMatchStr)=0)
	..s patOperDate=$P(^DHCMRInfo(mrInfoRowid),"^",121) 		;手术日期
	..s patOperHealLev=$P(^DHCMRInfo(mrInfoRowid),"^",127) 		;切口愈合等级
	..s mrSSBM2=$P(^DHCMRInfo(mrInfoRowid),"^",130)
	..s operDate2=$P(^DHCMRInfo(mrInfoRowid),"^",132)
	..s mrSSMC2=$P(^DHCMRInfo(mrInfoRowid),"^",133)
	..s mrSSQKYHDJ2=$P(^DHCMRInfo(mrInfoRowid),"^",138)
	..s mrSSBM3=$P(^DHCMRInfo(mrInfoRowid),"^",141)
	..s operDate3=$P(^DHCMRInfo(mrInfoRowid),"^",143)
	..s mrSSMC3=$P(^DHCMRInfo(mrInfoRowid),"^",144)
	..s mrSSQKYHDJ3=$P(^DHCMRInfo(mrInfoRowid),"^",149)
	..s mrSSBM4=$P(^DHCMRInfo(mrInfoRowid),"^",152)
	..s operDate4=$P(^DHCMRInfo(mrInfoRowid),"^",154)
	..s mrSSMC4=$P(^DHCMRInfo(mrInfoRowid),"^",155)
	..s mrSSQKYHDJ4=$P(^DHCMRInfo(mrInfoRowid),"^",160)
	..s mrSSBM5=$P(^DHCMRInfo(mrInfoRowid),"^",163)
	..s operDate5=$P(^DHCMRInfo(mrInfoRowid),"^",165)
	..s mrSSMC5=$P(^DHCMRInfo(mrInfoRowid),"^",166)
	..s mrSSQKYHDJ5=$P(^DHCMRInfo(mrInfoRowid),"^",171)
	..s patAdmDate=$P(^DHCMRInfo(mrInfoRowid),"^",35)
	..s patRYTJ=$P(^DHCMRInfo(mrInfoRowid),"^",34) 		;入院途径
	..s patRYTJ1=$Case(patRYTJ,"急诊":"1","门诊":"2","其他医疗机构转入":"3","其他":"9",:"0")
	..q:(rytj'="")&&'$find(","_rytj_",",","_patRYTJ1_",")
	..q:(otherDiag'="")&&(..GetDiagCodeInfo(mrInfoRowid,otherDiag,1)=0)
	..q:(otherDiagDesc'="")&&(..GetDiagDescInfo(mrInfoRowid,otherDiagDesc,otherDiagMatchStr,1)=0)
	..q:(allDiag'="")&&(..GetDiagCodeInfo(mrInfoRowid,allDiag,0)=0)
	..q:(allDiagDesc'="")&&(..GetDiagDescInfo(mrInfoRowid,allDiagDesc,allDiagMatchStr,0)=0)
	..q:(allOper'="")&&(..GetOperCodeInfo(mrInfoRowid,allOper,0)=0)
	..q:(allOperDesc'="")&&(..GetOperDescInfo(mrInfoRowid,allOperDesc,allOperMatchStr,0)=0)
	..s admDiag=$P(^DHCMRInfo(mrInfoRowid),"^",45) 		;入院病情
	..s mrXYFee=$P(^DHCMRInfo(mrInfoRowid),"^",248)   	;西药费
	..s mrKJYFee=$P(^DHCMRInfo(mrInfoRowid),"^",249)   	;抗菌药物费用
	..s mrZCHYFee=$P(^DHCMRInfo(mrInfoRowid),"^",250)   ;中成药费
	..s mrZCYFee=$P(^DHCMRInfo(mrInfoRowid),"^",251)   	;中草药费
	..s mrZLJG=$P(^DHCMRInfo(mrInfoRowid),"^",55)
	..s mrCode=patCYZYZD
	..i diagType="手术" s mrCode=patOperBM
	..s:diagGrp'="" mrGrpDesc=..GetIcdCatDesc(diagCode,$ZCVT(mrCode,"U"))
	..i admDate'="" s admDate=$zd(admDate,3)
	..i disDate'="" s disDate=$zd(disDate,3)
	..i patOperDate'="" s patOperDate=$zd(patOperDate,3)
	..i operDate2'="" s operDate2=$zd(operDate2,3)
	..i operDate3'="" s operDate3=$zd(operDate3,3)
	..i operDate4'="" s operDate4=$zd(operDate4,3)
	..i operDate5'="" s operDate5=$zd(operDate5,3)
    ..d OutRowMRInfoDetail
    
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutRowMRInfoDetail
	s Data=$lb(mrBAH,admId,mrName,patSex,patAge,patZY,mrXZZ,admDate,admLocDesc,disDate,disLocDesc,patRYTJ,patLYType,patCYZYZD,patCYZYZDMC,mrCYQTZD1,mrCYQTZDMC1,mrCYQTZD2,mrCYQTZDMC2,mrCYQTZD3,mrCYQTZDMC3,mrCYQTZD4,mrCYQTZDMC4,mrCYQTZD5,mrCYQTZDMC5,patOperDate,patOperBM,patOperName,patOperHealLev,operDate2,mrSSBM2,mrSSMC2,mrSSQKYHDJ2,operDate3,mrSSBM3,mrSSMC3,mrSSQKYHDJ3,operDate4,mrSSBM4,mrSSMC4,mrSSQKYHDJ4,operDate5,mrSSBM5,mrSSMC5,mrSSQKYHDJ5,patInDays,mrZYZFF,mrXYFee,mrZCHYFee,mrZCYFee,mrGrpDesc,mrZYYS)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetMRInfoDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRInfoDetailExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRInfoDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRInfoDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 手术编码
/// mFlag:0为所有手术，1为其他手术
ClassMethod GetOperCodeInfo(mrRowid As %String, code As %String, mFlag As %Integer = 0) As %Integer [ SqlProc ]
{
	n (mrRowid,code,mFlag)
	s flag=0
	f i=mFlag:1:9 q:flag=1  d
	.s node=11*i
	.s operCode=$P(^DHCMRInfo(mrRowid),"^",118+node+1) 	;手术编码
	.q:operCode=""
	.s operType=$P(^DHCMRInfo(mrRowid),"^",118+node+11) ;类型
	.i i=3 s operType=$P(^DHCMRInfo(mrRowid),"^",118+node+10)
	.;q:(operType'="1")&&(operType'="手术") 			;取手术
	.;s:(operCode[code) flag=1							;包含关系
	.s:(..CheckString(code,operCode)=1) flag=1			;模式匹配
	q flag
}

/// 手术名称
/// mFlag:0为所有手术，1为其他手术
ClassMethod GetOperDescInfo(mrRowid As %String, desc As %String, matchStr As %String = ".E", mFlag As %Integer = 0) As %Integer [ SqlProc ]
{
	n (mrRowid,desc,matchStr,matchStr,mFlag)
	s flag=0
	f i=mFlag:1:9 q:flag=1  d
	.s node=11*i
	.s operDesc=$P(^DHCMRInfo(mrRowid),"^",118+node+4)	;手术名称
	.q:operDesc=""
	.s operType=$P(^DHCMRInfo(mrRowid),"^",118+node+11)	;类型
	.i i=3 s operType=$P(^DHCMRInfo(mrRowid),"^",118+node+10)
	.;q:(operType'="1")&&(operType'="手术")				;取手术
	.s:(operDesc?@matchStr)=1 flag=1					;模式匹配
	q flag
}

/// 诊断编码
/// mFlag:0为所有诊断，1为其他诊断
/// w ##Class(web.QueryMrInfo).GetDiagCodeInfo(49484,"T01",1)
ClassMethod GetDiagCodeInfo(mrRowid As %String, code As %String, mFlag As %Integer = 0) As %Integer [ SqlProc ]
{
	n (mrRowid,code,mFlag)
	s flag=0
	f i=mFlag:1:14 q:flag=1  d
	.s node=4*i
	.s diagCode=$P(^DHCMRInfo(mrRowid),"^",51+node+1) 	;主要诊断编码
	.q:diagCode=""
	.;s:(diagCode[code) flag=1    						;包含关系
	.s:(..CheckString(code,diagCode)=1) flag=1			;模式匹配
	q flag
}

/// 诊断名称
/// mFlag:0为所有诊断，1为其他诊断
/// w ##Class(web.QueryMrInfo).GetDiagDescInfo(49484,"脑",1)
ClassMethod GetDiagDescInfo(mrRowid As %String, desc As %String, matchStr As %String = ".E", mFlag As %Integer = 0) As %Integer [ SqlProc ]
{
	n (mrRowid,desc,matchStr,mFlag)
	s flag=0
	f i=mFlag:1:14 q:flag=1  d
	.s node=4*i
	.s diagDesc=$P(^DHCMRInfo(mrRowid),"^",51+node+2)	;主要诊断名称
	.q:diagDesc=""
	.s:(diagDesc?@matchStr)=1 flag=1					;模式匹配
	q flag
}

/// 生成模式匹配表达式
/// w ##Class(web.QueryMrInfo).GenerateMatch("%消%道%")
ClassMethod GenerateMatch(pattern As %String) As %String
{
	n (pattern)
	q:pattern="" ".E"
	q:pattern'["%" ".E1"""_pattern_""".E"
	s pattern=$ZSTRIP(pattern,"<=>","%") ;去重
	s retMatch=""
	s len=$l(pattern,"%")
	f i=1:1:len d
	.s matchStr=$P(pattern,"%",i)
	.q:matchStr=""
	.s retMatch=retMatch_".E1"""_matchStr_""""
	q retMatch_".E"
}

/// 判断字符串是否满足给定规则，是返回1，否返回0
/// 规则为：区间段用"-"割开，多个并列串间用","隔开，如"T01-T05,T07"等
/// w ##Class(web.QueryMrInfoBYEFY).CheckString("A03","A03.002")
ClassMethod CheckString(codeStr As %String = "", code As %String) As %Integer [ SqlProc ]
{
 	n (codeStr,code)
 	s exist=0, strStart="", strEnd=""
 	q:codeStr="" 1
 	s strList=$LISTFROMSTRING(codeStr,",")
 	f i=1:1:$ll(strList) q:exist=1  d
 	.q:$li(strList,i)=""
 	.i $f($li(strList,i),"-")=0 d
 	..i $li(strList,i)=$e(code,1,$l($li(strList,i))) s exist=1
 	.e  d
 	..s strList1=$LISTFROMSTRING($li(strList,i),"-")
 	..q:$ll(strList1)'=2
 	..s strStart=$li(strList1,1), strEnd=$li(strList1,2)
 	..i (($e(code,1,$l(strStart))=strStart)||($e(code,1,$l(strStart))]strStart))&&(($e(code,1,$l(strEnd))=strEnd)||(strEnd]$e(code,1,$l(strEnd)))) d
 	...s exist=1
 	q exist
}

/// Creator：      HeTong
/// CreatDate：    2019-08-08
/// Description：  病案统计报表（死亡患者明细）
/// Table：        DHCMRInfo
/// Input：        startDate,endDate
/// OutPut:		
/// d ##Class(%ResultSet).RunQuery("web.QueryMrInfo","GetMRInfoDead","2019-05-01","2019-05-31")
Query GetMRInfoDead(startDate As %String, endDate As %String, hosId As %String = "", dep As %Text = "", diag As %String = "", diagDesc As %String = "", oper As %String = "", operDesc As %String = "") As %Query(ROWSPEC = "DisLoc,DisLocDesc,PatMedicare,PatName,PatSex,PatAge,PatZHY,Diag,DiagDesc,AdmDate,AdmLoc,DisDate,DeceasedDate,PatRYTJ,Oper,OperDesc,patInDays:%Integer,patLYType,mrZYZFF:%Float,diagCode1,diagDesc1,diagCode2,diagDesc2,diagCode3,diagDesc3,diagCode4,diagDesc4") [ SqlProc ]
{
}

ClassMethod GetMRInfoDeadExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", dep As %String = "", diag As %String = "", diagDesc As %String = "", oper As %String = "", operDesc As %String = "") As %Status
{
	n (qHandle,startDate,endDate,hosId,dep,diag,diagDesc,oper,operDesc)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    q:startDate="" $$$OK
    q:endDate="" $$$OK
    s startDate=$zdh(startDate,3)
    s endDate=$zdh(endDate,3)
    s matchStr=""
    
  	f date=startDate:1:endDate d
	.s mrInfoRowid=0
    .f  s mrInfoRowid=$o(^DHCMRInfo(0,"MR_DIS_DATE",date,mrInfoRowid)) q:$g(mrInfoRowid)=""  d
    ..Q:'$D(^DHCMRInfo(mrInfoRowid))
    ..s admId=$P(^DHCMRInfo(mrInfoRowid),"^",6) ;就诊Rowid
    ..s patLYType=$P(^DHCMRInfo(mrInfoRowid),"^",46) ;离院方式
    ..q:(patLYType'="5")&&(patLYType'="死亡")
	..s patDeptDR=$P(^DHCMRInfo(mrInfoRowid),"^",40) ;出院科别
	..q:(dep'="")&&'$find(","_dep_",",","_patDeptDR_",")
	..s patDepDesc=$p($g(^CTLOC(+patDeptDR)),"^",2)
	..s hos=$P($g(^CTLOC(+patDeptDR)),"^",22)
	..q:(hosId'="")&&'$find(","_hosId_",",","_hos_",")
	..s mrZZYS=$P(^DHCMRInfo(mrInfoRowid),"^",271) ;主治医师
	..s mrZYYS=$P(^DHCMRInfo(mrInfoRowid),"^",272) ;住院医师
	..s patDoc=$P($g(^PAADM(admId)),"^",9)
	..//s mrZZYS=$p(^CTPCP(patDoc,1),"^",1)
	..s mrZZYS=$$GetPatDoc^DHCWLCommon(patDoc)
	..s patDocDesc=$$GetPatDoc^DHCWLCommon(patDoc)
	..s mrBAH=$P(^DHCMRInfo(mrInfoRowid),"^",4) ;病案号
	..s mrName=$P(^DHCMRInfo(mrInfoRowid),"^",8) ;姓名
	..s mrXB=$P(^DHCMRInfo(mrInfoRowid),"^",9) ;性别
	..s patSex=..GetPatGender(mrXB)
	..s patAge=$P(^DHCMRInfo(mrInfoRowid),"^",11) ;年龄
	..s patZY=..GetOccupation(mrInfoRowid)
	..s mrXZZ=$P(^DHCMRInfo(mrInfoRowid),"^",22) ;现住址
	..s admDate=$P(^DHCMRInfo(mrInfoRowid),"^",35) ;入院时间
	..i admDate'="" s admDate=$zd(admDate,3)
	..s admLoc=$P(^DHCMRInfo(mrInfoRowid),"^",36)  ;入院科室
	..s admLocDesc=..GetLocDesc(admLoc)
	..s disDate=$P(^DHCMRInfo(mrInfoRowid),"^",39) ;出院时间
	..s disLoc=$P(^DHCMRInfo(mrInfoRowid),"^",40)  ;出院科室
	..s disLocDesc=..GetLocDesc(disLoc)
	..s admDiag=$P(^DHCMRInfo(mrInfoRowid),"^",54) ;出院主要诊断入院病情
	..s mrZYZFF=$P(^DHCMRInfo(mrInfoRowid),"^",231)   ;住院总费用
	..s patCYZYZD=$P(^DHCMRInfo(mrInfoRowid),"^",52) 	;出院主要诊断
	..q:(diag'="")&&(patCYZYZD'[diag)
	..s patCYZYZDMC=$P(^DHCMRInfo(mrInfoRowid),"^",53) 	;出院主要诊断名称
	..q:(diagDesc'="")&&((patCYZYZDMC?@..GenerateMatch(diagDesc))=0)
	..s patInDays=$P(^DHCMRInfo(mrInfoRowid),"^",42) 	;住院天数
	..s patOperBM=$P(^DHCMRInfo(mrInfoRowid),"^",119) 	;手术编码
	..q:(oper'="")&&(patOperBM'[oper)
	..s patOperName=$P(^DHCMRInfo(mrInfoRowid),"^",122) ;手术名称
	..q:(operDesc'="")&&((patOperName?@..GenerateMatch(operDesc))=0)
	..s patOperDate=$P(^DHCMRInfo(mrInfoRowid),"^",121) ;手术日期
	..s patOperHealLev=$P(^DHCMRInfo(mrInfoRowid),"^",127) ;切口愈合等级
	..s patAdmDate=$P(^DHCMRInfo(mrInfoRowid),"^",35)
	..s patRYTJ=$P(^DHCMRInfo(mrInfoRowid),"^",34) 		;入院途径
	..s admDiag=$P(^DHCMRInfo(mrInfoRowid),"^",45) 		;入院病情
	..s mrXYFee=$P(^DHCMRInfo(mrInfoRowid),"^",248)   	;西药费
	..s mrKJYFee=$P(^DHCMRInfo(mrInfoRowid),"^",249)   	;抗菌药物费用
	..s mrZCHYFee=$P(^DHCMRInfo(mrInfoRowid),"^",250)   ;中成药费
	..s mrZCYFee=$P(^DHCMRInfo(mrInfoRowid),"^",251)   	;中草药费
	..s mrZLJG=$P(^DHCMRInfo(mrInfoRowid),"^",55)
	..s deatDate=..GetDeceasedDate(admId)
	..s diagCode1=$P(^DHCMRInfo(mrInfoRowid),"^",56)   	;其他诊断编码1
	..s diagDesc1=$P(^DHCMRInfo(mrInfoRowid),"^",57)   	;其他诊断名称1
	..s diagCode2=$P(^DHCMRInfo(mrInfoRowid),"^",60)   	;其他诊断编码2
	..s diagDesc2=$P(^DHCMRInfo(mrInfoRowid),"^",61)   	;其他诊断名称2
	..s diagCode3=$P(^DHCMRInfo(mrInfoRowid),"^",64)   	;其他诊断编码3
	..s diagDesc3=$P(^DHCMRInfo(mrInfoRowid),"^",65)   	;其他诊断名称3
	..s diagCode4=$P(^DHCMRInfo(mrInfoRowid),"^",68)   	;其他诊断编码4
	..s diagDesc4=$P(^DHCMRInfo(mrInfoRowid),"^",69)   	;其他诊断名称4
    ..d OutRowMRInfoDead
    
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutRowMRInfoDead
	s Data=$lb(patDeptDR,patDepDesc,mrBAH,mrName,patSex,patAge,patZY,patCYZYZD,patCYZYZDMC,admDate,admLocDesc,$zd(date,3),deatDate,patRYTJ,patOperBM,patOperName,patInDays,patLYType,mrZYZFF,diagCode1,diagDesc1,diagCode2,diagDesc2,diagCode3,diagDesc3,diagCode4,diagDesc4)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetMRInfoDeadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRInfoDeadExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRInfoDeadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRInfoDeadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      HeTong
/// CreatDate：    2018-09-13
/// Description：  病案统计台账（手术情况统计）
/// Table：        DHCMRInfo
/// Input：        startDate,endDate
/// OutPut:		
/// d ##Class(%ResultSet).RunQuery("web.QueryMrInfo","GetMRInfoAccount","2017-07-01","2017-07-31")
Query GetMRInfoAccount(startDate As %String, endDate As %String, hosId As %String = "") As %Query(ROWSPEC = "mrDate,ssrcNum:%Integer,zlxczNum:%Integer,zdxczNum:%Integer,num:%Integer,ssrsNum:%Integer,operLev,operHea,isOperSW,isOp10DaysSW,preInDays:%Integer,afterOpDays:%Integer,inDays:%Integer,fee:%Float") [ SqlProc ]
{
}

ClassMethod GetMRInfoAccountExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "") As %Status
{
	n (qHandle,startDate,endDate,hosId)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    q:startDate="" $$$OK
    q:endDate="" $$$OK
    
    K ^||TEMPDHCWL($j,"MRInfoAccount")
    s startDate=$zdh(startDate,3)
    s endDate=$zdh(endDate,3)
    
  	f date=startDate:1:endDate d
	.s mrInfoRowid=0
    .f  s mrInfoRowid=$o(^DHCMRInfo(0,"MR_DIS_DATE",date,mrInfoRowid)) q:$g(mrInfoRowid)=""  d
    ..Q:'$D(^DHCMRInfo(mrInfoRowid))
    ..s admId=$P(^DHCMRInfo(mrInfoRowid),"^",6) ;就诊Rowid
    ..s patLYType=$P(^DHCMRInfo(mrInfoRowid),"^",46) ;离院方式
	..s patDeptDR=$P(^DHCMRInfo(mrInfoRowid),"^",40) ;出院科别
	..s patDeptDR=$P($g(^PAADM(admId)),"^",4)
	..s patDepDesc=$p($g(^CTLOC(+patDeptDR)),"^",2)
	..s hos=$P($g(^CTLOC(+patDeptDR)),"^",22)
	..q:(hosId'="")&&'$find(","_hosId_",",","_hos_",")
	..s mrBAH=$P(^DHCMRInfo(mrInfoRowid),"^",4) ;病案号
	..s mrName=$P(^DHCMRInfo(mrInfoRowid),"^",8) ;姓名
	..s patZY=$P(^DHCMRInfo(mrInfoRowid),"^",20) ;职业
	..s admDate=$P($g(^PAADM(admId)),"^",6)
	..s admDiag=$P(^DHCMRInfo(mrInfoRowid),"^",54) ;出院主要诊断入院病情
	..s mrZYZFF=$P(^DHCMRInfo(mrInfoRowid),"^",231)   ;住院总费用
	..s patCYZYZD=$P(^DHCMRInfo(mrInfoRowid),"^",52) ; 出院主要诊断
	..s patCYZYZDMC=$P(^DHCMRInfo(mrInfoRowid),"^",53) ; 出院主要诊断名称
	..s patInDays=$P(^DHCMRInfo(mrInfoRowid),"^",42) ;住院天数
	..s patOperBM=$P(^DHCMRInfo(mrInfoRowid),"^",119) ;手术编码
	..q:patOperBM=""
	..s patOperName=$P(^DHCMRInfo(mrInfoRowid),"^",122) ;手术名称
	..s patOperDate=$P(^DHCMRInfo(mrInfoRowid),"^",121) ;手术日期
	..s patRYTJ=$P(^DHCMRInfo(mrInfoRowid),"^",34) ;入院途径
	..s admDiag=$P(^DHCMRInfo(mrInfoRowid),"^",45) ;入院病情
	..s patOperHealLev=$P(^DHCMRInfo(mrInfoRowid),"^",127) ;切口愈合等级(一类切口/甲)
	..s operLev=$P(patOperHealLev,"/",1) ;切口类型
	..s operHea=$P(patOperHealLev,"/",2) ;愈合等级
	..s mrZLJG=$P(^DHCMRInfo(mrInfoRowid),"^",55)
	..s otherOper1=$P(^DHCMRInfo(mrInfoRowid),"^",119)
	..s otherOper2=$P(^DHCMRInfo(mrInfoRowid),"^",130)
	..s otherOper3=$P(^DHCMRInfo(mrInfoRowid),"^",141)
	..s otherOper4=$P(^DHCMRInfo(mrInfoRowid),"^",152)
	..s otherOper5=$P(^DHCMRInfo(mrInfoRowid),"^",163)
	..s otherOper6=$P(^DHCMRInfo(mrInfoRowid),"^",174)
	..s otherOper7=$P(^DHCMRInfo(mrInfoRowid),"^",185)
	..s otherOper8=$P(^DHCMRInfo(mrInfoRowid),"^",196)
	..s ssFlag=0
	..s ssrcNum=0  ;手术人次数
	..s zlxczNum=0,zdxczNum=0  ;治疗性操作人次数;诊断性操作人次数
	..s num=1 ;手术、操作人数
	..s ssrsNum=0 ;手术人数
	..f i=1:1:8 d
	...s Flag="otherOper"_i
	...q:@Flag=""
	...i ..GetOperICD10Map(@Flag)=""  d  ;手术人次数
	....s ssrcNum=ssrcNum+1
	....s ssFlag=1
	...i ..GetOperICD10Map(@Flag)="治疗性操作" s zlxczNum=zlxczNum+1  ;治疗性操作人次数
	...i ..GetOperICD10Map(@Flag)="诊断性操作" s zdxczNum=zdxczNum+1  ;诊断性操作人次数
	..i ssFlag=1 s ssrsNum=1 ;手术人数
	..s isOp10DaysSW=..IsOp10DaysSW(mrInfoRowid) ;术后10日死亡
	..s isOperSW=..IsOperSW(mrInfoRowid) ;手术死亡
	..s preInDays=..PreInDays(mrInfoRowid) 		;术前住院天数
	..s afterOpDays=..AfterOpDays(mrInfoRowid) 	;术后住院天数
	..s dim=..GetDateStr(date)_","_operLev_","_operHea_","_isOperSW_","_isOp10DaysSW
	..s ^||TEMPDHCWL($j,"MRInfoAccount",dim,"ssrcNum")=$g(^||TEMPDHCWL($j,"MRInfoAccount",dim,"ssrcNum"))+ssrcNum
	..s ^||TEMPDHCWL($j,"MRInfoAccount",dim,"zlxczNum")=$g(^||TEMPDHCWL($j,"MRInfoAccount",dim,"zlxczNum"))+zlxczNum
	..s ^||TEMPDHCWL($j,"MRInfoAccount",dim,"zdxczNum")=$g(^||TEMPDHCWL($j,"MRInfoAccount",dim,"zdxczNum"))+zdxczNum
	..s ^||TEMPDHCWL($j,"MRInfoAccount",dim,"Num")=$g(^||TEMPDHCWL($j,"MRInfoAccount",dim,"Num"))+num
	..s ^||TEMPDHCWL($j,"MRInfoAccount",dim,"ssrsNum")=$g(^||TEMPDHCWL($j,"MRInfoAccount",dim,"ssrsNum"))+ssrsNum
	..s ^||TEMPDHCWL($j,"MRInfoAccount",dim,"preInDays")=$g(^||TEMPDHCWL($j,"MRInfoAccount",dim,"preInDays"))+preInDays
	..s ^||TEMPDHCWL($j,"MRInfoAccount",dim,"afterOpDays")=$g(^||TEMPDHCWL($j,"MRInfoAccount",dim,"afterOpDays"))+afterOpDays
	..s ^||TEMPDHCWL($j,"MRInfoAccount",dim,"InDays")=$g(^||TEMPDHCWL($j,"MRInfoAccount",dim,"InDays"))+patInDays
	..s ^||TEMPDHCWL($j,"MRInfoAccount",dim,"Fee")=$g(^||TEMPDHCWL($j,"MRInfoAccount",dim,"Fee"))+mrZYZFF

	s dimPara="" f  s dimPara=$O(^||TEMPDHCWL($j,"MRInfoAccount",dimPara)) q:dimPara=""  d
	.s mDate=$P(dimPara,",",1)
	.s operLev=$P(dimPara,",",2)
	.s operHea=$P(dimPara,",",3)
	.s isOperSW=$P(dimPara,",",4)
	.s isOp10DaysSW=$P(dimPara,",",5)
	.s ssrcNum=$g(^||TEMPDHCWL($j,"MRInfoAccount",dimPara,"ssrcNum"))
	.s zlxczNum=$g(^||TEMPDHCWL($j,"MRInfoAccount",dimPara,"zlxczNum"))
	.s zdxczNum=$g(^||TEMPDHCWL($j,"MRInfoAccount",dimPara,"zdxczNum"))
	.s num=$g(^||TEMPDHCWL($j,"MRInfoAccount",dimPara,"Num"))
	.s ssrsNum=$g(^||TEMPDHCWL($j,"MRInfoAccount",dimPara,"ssrsNum"))
	.s preInDays=$g(^||TEMPDHCWL($j,"MRInfoAccount",dimPara,"preInDays"))
	.s afterOpDays=$g(^||TEMPDHCWL($j,"MRInfoAccount",dimPara,"afterOpDays"))
	.s patInDays=$g(^||TEMPDHCWL($j,"MRInfoAccount",dimPara,"InDays"))
	.s mrZYZFF=$g(^||TEMPDHCWL($j,"MRInfoAccount",dimPara,"Fee"))
	.d OutRowMRInfoAccount

	K ^||TEMPDHCWL($j)
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutRowMRInfoAccount
	s Data=$lb(mDate,ssrcNum,zlxczNum,zdxczNum,num,ssrsNum,operLev,operHea,isOperSW,isOp10DaysSW,preInDays,afterOpDays,patInDays,mrZYZFF)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetMRInfoAccountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRInfoAccountExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRInfoAccountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRInfoAccountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      HeTong
/// CreatDate：    2018-09-13
/// Description：  病案统计(遍历科室代码维护)
/// Table：        DHCMRInfo
/// Input：        startDate,endDate
/// OutPut:		
/// d ##Class(%ResultSet).RunQuery("web.QueryMrInfo","GetMRInfoCodeCfg")
Query GetMRInfoCodeCfg() As %Query(ROWSPEC = "bsCode,bsDesc") [ SqlProc ]
{
}

ClassMethod GetMRInfoCodeCfgExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
	s dimId=$O(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI","CTLOC",0))
    s grpId=0 f  s grpId=$O(^DHCWL.CodeCfg.GroupI("DimDr",dimId,grpId)) q:grpId=""  d
    .s bsCode=$lg(^DHCWL.CodeCfg.GroupD(grpId),2)
    .s bsDesc=$lg(^DHCWL.CodeCfg.GroupD(grpId),3)
  	.d OutRowMRInfoCodeCfg
    
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutRowMRInfoCodeCfg
	s Data=$lb(bsCode,bsDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetMRInfoCodeCfgFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRInfoCodeCfgExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRInfoCodeCfgClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRInfoCodeCfgExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/*****************************以下存储过程为病案报表所用***************************************************/
/// 用于解决用复杂SQL传参为空查询全部的问题
/// w ##Class(web.QueryMrInfo).IsEqualIgNull("18,123,45,79","")
ClassMethod IsEqualIgNull(str1 As %String = "", str2 As %String) As %Integer [ SqlProc ]
{
	n (str1,str2)
	q:str1="" 1
	q:$find(","_str1_",",","_str2_",") 1
	q 0
}

/// 通过科室过滤院区
/// w ##Class(web.QueryMrInfo).IsEqualIgHos("18,123,45,79","12")
ClassMethod IsEqualIgHos(hos As %String = "", loc As %String) As %Integer [ SqlProc ]
{
	n (hos,loc)
	q:hos="" 1
	s locHos=$P($g(^CTLOC(+loc)),"^",22)
	q:$find(","_hos_",",","_locHos_",") 1
	q 0
}

/// 用于解决用复杂SQL传参处理包含为空的情况
/// w ##Class(web.QueryMrInfo).ContainNull("q","qqqqq")
ClassMethod ContainNull(str1 As %String = "", str2 As %String) As %Integer [ SqlProc ]
{
	n (str1,str2)
	q:str1="" 1
	q:str2[str1 1
	q 0
}

/// 获取科室描述
/// w ##Class(web.QueryMrInfo).GetLocDesc("18")
ClassMethod GetLocDesc(loc As %String) As %String [ SqlProc ]
{
	n (loc)
	q:loc="" ""
	q:'$d(^CTLOC(loc)) ""
	s locDesc=$P($g(^CTLOC(loc)),"^",2)
	i locDesc [ "-" s locDesc=$P(locDesc,"-",2)
	q locDesc
}

/// 获取疾病名称
/// w ##Class(web.QueryMrInfo).GetICDDesc("36677")
ClassMethod GetICDDesc(icd As %String) As %String [ SqlProc ]
{
	n (icd)
	q:icd="" ""
	q:'$d(^MRC("ID",icd)) "" ;MRC_ICDDx
	s icdDesc=$P($g(^MRC("ID",icd)),"^",2)
	q icdDesc
}

/// 获取医生描述
/// w ##Class(web.QueryMrInfo).GetDocDesc("1")
ClassMethod GetDocDesc(ctpcp As %String) As %String [ SqlProc ]
{
	n (ctpcp)
	q:ctpcp="" ""
	q:'$d(^CTPCP(ctpcp)) ""
	s docDesc=$P($g(^CTPCP(ctpcp,1)),"^",2)
	q docDesc
}

/// 获取用户描述
/// w ##Class(web.QueryMrInfo).GetUserDesc("1")
ClassMethod GetUserDesc(user As %String) As %String [ SqlProc ]
{
	n (user)
	q:user="" ""
	q:'$d(^SSU("SSUSR",user)) ""
	s userDesc=$P($g(^SSU("SSUSR",user)),"^",2)
	q userDesc
}

/// 比较值
/// w ##Class(web.QueryMrInfo).CompValue("46042||83")
ClassMethod CompValue(sumValue As %Float, value As %String = "") As %Integer [ SqlProc ]
{
	n (sumValue,value)
	q:value="" 1
	q:+value<=sumValue 1
	q 0
}

/// 获取主管医生
/// w ##Class(web.QueryMrInfo).GetAdmType("46042||83")
ClassMethod GetPatDoc(mMRId As %String) As %String [ SqlProc ]
{
	n (mMRId)
	s admId=$P(^DHCMRInfo(mMRId),"^",6)
	s patDoc=$P($g(^PAADM(+admId)),"^",9)
	Q patDoc
}

/// 获取主管医生描述
/// w ##Class(web.QueryMrInfo).GetAdmType("46042||83")
ClassMethod GetPatDocDesc(mMRId As %String) As %String [ SqlProc ]
{
	n (mMRId)
	s admId=$P(^DHCMRInfo(mMRId),"^",6)
	s patDoc=$P($g(^PAADM(+admId)),"^",9)
	s patDocDesc=$P($g(^CTPCP(+patDoc,1)),"^",2)
	Q patDocDesc
}

/// 通过麻醉ID获取手术级别
/// w ##Class(web.QueryMrInfo).GetOPLevel("46042||83")
ClassMethod GetOPLevel(anaestDr As %String) As %String [ SqlProc ]
{
	n (anaestDr)
	q:anaestDr="" ""
	s anPaadmDr=$P(anaestDr,"||",1)
	s anSubDr=$P(anaestDr,"||",2)
	s andOPChildsubM=$o(^OR(anPaadmDr,"ANA",anSubDr,"OP",0)) ;手术表OR_Anaest_Operation中取手术信息
	q:andOPChildsubM="" ""
	s opLevel=$p($g(^OR(anPaadmDr,"ANA",anSubDr,"OP",andOPChildsubM,"DHC")),"^",1)
	s opLevelDesc=$P($g(^ORC("CATEG",opLevel)),"^",2)
	Q opLevelDesc
}

/// 获取患者年龄(调用His标准年龄接口)
/// w ##Class(web.QueryMrInfo).GetPatAge("165")
ClassMethod GetPatAge(admId As %String) As %String [ SqlProc ]
{
	n (admId)
	q:admId="" ""
	s papmi=$P($g(^PAADM(admId)),"^",1)
	s age=+##class(web.DHCBillInterface).GetPapmiAge(papmi,admId)
	Q age
}

/// 再入院患者统计
/// w ##Class(web.QueryMrInfo).GetReIns("46042||83")
ClassMethod GetReIns(mMRId As %String, flag As %String = "") As %String [ SqlProc ]
{
	n (mMRId,flag)
	q:'$d(^DHCMRInfo(mMRId)) "否"
	s patDeptDR=$P(^DHCMRInfo(mMRId),"^",40)
	s mainDiag=$P($g(^DHCMRInfo(mMRId)),"^",52)
    s reInspatFlag=$P(^DHCMRInfo(mMRId),"^",284)
    s afterAdm=$P(^DHCMRInfo(mMRId),"^",6)
    s papmi=$p($g(^PAADM(afterAdm)),"^",1)
    q:papmi="" "否"
    s afAdmDate=$P($g(^PAADM(afterAdm)),"^",6)
    s preAdm=$o(^PAPERdr(papmi,"ADM","I",afterAdm),-1)
    q:preAdm="" "否"
    s preMrRowid=$O(^DHCMRInfo(0,"MR_PAADM_DR",preAdm,0))
    s preDiag=$P($g(^DHCMRInfo(+preMrRowid)),"^",52) ; 出院主要诊断
    q:(flag="1")&&(preDiag'=mainDiag) "否"
    s preDisDate=$p(^PAADM(preAdm),"^",17)
    s day=$g(afAdmDate)-$g(preDisDate)
    q:day<0 "否"
    q:day=0 "当天"
    q:(day>1)&(day<16) "两周"
    q:(day>15)&(day<32) "当月"
    Q "否"
}

/// 入院24h、48h死亡人数
/// w ##Class(web.QueryMrInfo).GetRYSW("46042||83")
ClassMethod GetRYSW(mMRId As %String) As %String [ SqlProc ]
{
	n (mMRId)
	s flag24H=0,flag48H=0
	s admId=$P($g(^DHCMRInfo(mMRId)),"^",6)
	s papmi=+$P($g(^PAADM(admId)),"^",1)
	s mAdmdate=$P($g(^PAADM(admId)),"^",6)
	s mAdmTime=$P($g(^PAADM(admId)),"^",7)
	s deceDate=$P($g(^PAPER(papmi,"ALL")),"^",13)
	s deceTime=$P($g(^PAPER(papmi,"ALL")),"^",8)
	Q:deceDate="" "否"
	s days=$g(deceDate)-$g(mAdmdate)
	s times=$g(deceTime)-$g(mAdmTime)
	i $g(days)=0 d
	.s flag24H=1,flag48H=1
	e  i $g(days)=1 d
	.i ($g(times)'>0) s flag24H=1,flag48H=1
	.i ($g(times)>0) s flag48H=1
	e  i $g(days)=2 d
	.i ($g(times)'>0) s flag48H=1
	q:flag24H=1 "24HDNums"
	q:flag48H=1 "48HDNums"
	Q "否"
}

/// 获取患者年龄区间段
/// w ##Class(web.QueryMrInfo).GetPatSexAge("46042||83")
ClassMethod GetPatSexAge(mMRId As %String) As %String [ SqlProc ]
{
	n (mMRId)   
    s mPatSex=$P(^DHCMRInfo(mMRId),"^",9)
    s mPatDeptDR=$P(^DHCMRInfo(mMRId),"^",40)
    s mPatAge=$P(^DHCMRInfo(mMRId),"^",11)
    s admId=$P(^DHCMRInfo(mMRId),"^",6)
    ;s mPatAge=+##class(web.DHCBillInterface).GetPapmiAge(papmi,admId) ;His标准年龄接口
    s mAgeKind=""
    q:+$g(mPatAge)<5 "Un5Nums"
    q:(+$g(mPatAge)<15)&(+$g(mPatAge)>4) "Un15Nums"
    q:(+$g(mPatAge)<45)&(+$g(mPatAge)>14) "Un45Nums"
    q:(+$g(mPatAge)<60)&(+$g(mPatAge)>44) "Un60Nums"
    q:+$g(mPatAge)>59 "Up60Nums"
    Q mAgeKind
}

/// 获取服务半径（本县区，本市外县区，本省外市，外省市）
/// w ##Class(web.QueryMrInfo).GetSerRad("46042||83")
ClassMethod GetSerRad(mrRowid As %String) As %String [ SqlProc ]
{
	n (mrRowid)
	s county="大通"
	s city="西宁"
	s province="青海"
	s mrXZZ=$P(^DHCMRInfo(mrRowid),"^",22) 	;现住址
	s mrHKDZ=$P(^DHCMRInfo(mrRowid),"^",25) ;户口地址
	q:(mrXZZ[city)&(mrXZZ[county) "本县区"
	q:(mrXZZ[city)&(mrXZZ'[county) "本市外县区"
	q:(mrXZZ[province)&(mrXZZ'[city) "本省外市"
	q:(mrXZZ'[province)&(mrXZZ'[city) "外省市"
	Q "外省市"
}

/// 是否三日内确诊人数
/// w ##Class(web.QueryMrInfo).Is3Days("46042||83")
ClassMethod Is3Days(mrRowid As %String) As %String [ SqlProc ]
{
	n (mrRowid)
	s qzDate=$P($g(^DHCMRInfo(mrRowid)),"^",51) ;确诊日期
	s admDate=$P($g(^DHCMRInfo(mrRowid)),"^",35) ;入院日期
	q:(qzDate="")!(admDate="") "否"
	s days=qzDate-admDate
	q:(days<4)&&(days>0) "是"
	Q "否"
}

/// 获取患者职业
/// w ##Class(web.QueryMrInfo).GetOccupation("46042")
ClassMethod GetOccupation(mrRowid As %String) As %String [ SqlProc ]
{
	n (mrRowid)
	/*
	s patZY=$P(^DHCMRInfo(mrRowid),"^",20) ;职业
	Q:patZY="" ""
	s patZY=$ZCVT(patZY,"U")
	Q:'$D(^CT("OCC",0,"Code",patZY)) ""
	s id=$O(^CT("OCC",0,"Code",patZY,""))
	s retValue=$P($g(^CT("OCC",+id)),"^",2)
	*/
	s patZY=$P(^DHCMRInfo(mrRowid),"^",20) ;职业
	s retValue=patZY
	Q retValue
}

/// 获取患者死亡时间
/// w ##Class(web.QueryMrInfo).GetOccupation("46042")
ClassMethod GetDeceasedDate(admid As %String) As %String [ SqlProc ]
{
	n (admid)
	q:admid="" ""
	q:'$d(^PAADM(admid)) ""
	s papmi=$P($g(^PAADM(admid)),"^",1)
	s deceased=$P($g(^PAPER(papmi,"ALL")),"^",12)
	s deceasedDate=$P($g(^PAPER(papmi,"ALL")),"^",13)
	s deceasedTime=$P($g(^PAPER(papmi,"ALL")),"^",8)
	i deceasedDate'="" s deceasedDate=$ZD(deceasedDate,3)
	Q deceasedDate
}

/// 是否手术人数
/// w ##Class(web.QueryMrInfo).IsOperNum("46042||83")
ClassMethod IsOperNum(mrRowid As %String) As %String [ SqlProc ]
{
	n (mrRowid)
	s patOperCode=$P(^DHCMRInfo(mrRowid),"^",119)
	s patOperName=$P(^DHCMRInfo(mrRowid),"^",122)
	q:patOperName="" "否"
	Q "是"
}

/// 是否术后10日内死亡
/// w ##Class(web.QueryMrInfo).IsOp10DaysSW("46042||83")
ClassMethod IsOp10DaysSW(mrRowid As %String) As %String [ SqlProc ]
{
	n (mrRowid)
	s patOperCode=$P(^DHCMRInfo(mrRowid),"^",119)
	s patOperName=$P(^DHCMRInfo(mrRowid),"^",122)
	q:patOperName="" "否"
	s patOperDate=$P(^DHCMRInfo(mrRowid),"^",121)
	s patAdmDate=$P(^DHCMRInfo(mrRowid),"^",35)
	s patDisDate=$P(^DHCMRInfo(mrRowid),"^",39)
	s afOpDays=$G(patDisDate)-$G(patOperDate)
	q:afOpDays<0 "否"
	s patLYType=$P(^DHCMRInfo(mrRowid),"^",46)
	q:(afOpDays<10)&(patLYType["死亡") "是"
	Q "否"
}

/// 是否手术死亡人数
/// w ##Class(web.QueryMrInfo).IsOperSW("46042||83")
ClassMethod IsOperSW(mrRowid As %String) As %String [ SqlProc ]
{
	n (mrRowid)
	s patOperCode=$P(^DHCMRInfo(mrRowid),"^",119)
	s patOperName=$P(^DHCMRInfo(mrRowid),"^",122)
	q:patOperName="" "否"
	s patLYType=$P(^DHCMRInfo(mrRowid),"^",46)
	q:patLYType["死亡" "是"
	Q "否"
}

/// 是否3日内手术
/// w ##Class(web.QueryMrInfo).Is3DaysOper("46042||83")
ClassMethod Is3DaysOper(mrRowid As %String) As %String [ SqlProc ]
{
	n (mrRowid)
	s patOperCode=$P(^DHCMRInfo(mrRowid),"^",119)
	s patOperName=$P(^DHCMRInfo(mrRowid),"^",122)
	q:patOperName="" "否"
	s patOperDate=$P(^DHCMRInfo(mrRowid),"^",121)
	s patAdmDate=$P(^DHCMRInfo(mrRowid),"^",35)
	s patDisDate=$P(^DHCMRInfo(mrRowid),"^",39)
	s preOpDays=$G(patOperDate)-$G(patAdmDate)
	q:preOpDays<0 "否"
	q:preOpDays<3 "是"
	Q "否"
}

/// 术前住院天数
/// w ##Class(web.QueryMrInfo).PreInDays("46042||83")
ClassMethod PreInDays(mMRId As %String) As %Integer [ SqlProc ]
{
	n (mMRId)
	q:'$d(^DHCMRInfo(mMRId)) 0
	s operDate=$p(^DHCMRInfo(mMRId),"^",121)
	q:operDate="" 0
    s admId=$P(^DHCMRInfo(mMRId),"^",6)
    ;s admDate=$P($g(^PAADM(admId)),"^",6)
    s admDate=$P(^DHCMRInfo(mMRId),"^",35)						;addby zcx 2022-12-07 
    q:admDate="" 0
    s operDate=$p(^DHCMRInfo(mMRId),"^",121)
    s day=$g(operDate)-$g(admDate)
    
    															; 术前住院天数
    s patOperBM=$P(^DHCMRInfo(mMRId),"^",119)					;手术编码 ;addby zcx 2022-12-07 
	i (patOperBM'="")&&(+$g(operDate)'=0)&&(+$g(admDate)'=0) d
	.s day=operDate-admDate
	
	i patOperBM'="" d											; 手术编码不为空的手术才去算术前、术后住院天数
	.i day<1 s day=1
    
    q:day<0 0
    Q day
}

/// 术后住院天数
/// w ##Class(web.QueryMrInfo).AfterOpDays("46042||83")
ClassMethod AfterOpDays(mMRId As %String) As %Integer [ SqlProc ]
{
	n (mMRId)
	q:'$d(^DHCMRInfo(mMRId)) 0
	s operDate=$p(^DHCMRInfo(mMRId),"^",121)
	q:operDate="" 0
    s admId=$P(^DHCMRInfo(mMRId),"^",6)
    s disDate=$P(^DHCMRInfo(mMRId),"^",39)
    q:disDate="" 0
    s operDate=$p(^DHCMRInfo(mMRId),"^",121)
    s day=$g(disDate)-$g(operDate)
    q:day<0 0
    Q day
}

/// 通过麻醉ID获取手术类型：择期、急诊
/// w ##Class(web.QueryMrInfo).IsZQOper("46042||83")
ClassMethod GetEOpType(anaestDr As %String) As %String [ SqlProc ]
{
	n (anaestDr)
	s operType=""
	s admId=$P(anaestDr,"||",1)
	s anSubDr=$P(anaestDr,"||",2)
	q:'$d(^OR(+admId,"ANA",+anSubDr)) operType
	s operType=$P($g(^OR(+admId,"ANA",+anSubDr)),"^",32)  ;手术类型：E-急诊、B-择期
	Q operType
}

/// 通过就诊ID获取手术类型：择期、急诊、择期急诊、否
/// w ##Class(web.QueryMrInfo).GetOperType("46042||83")
ClassMethod GetOperType(mrRowid As %String) As %String [ SqlProc ]
{
	n (mrRowid)
	s SSMC1=$P(^DHCMRInfo(mrRowid),"^",122) ;手术名称
 	s SSBM=$P(^DHCMRInfo(mrRowid),"^",119)
 	q:SSBM="" "否"
 	s operFlag=""
 	s operFlag1="",operFlag2=""
 	s patDeptDR=$P(^DHCMRInfo(mrRowid),"^",40) ;出院科别
 	s admid=$P(^DHCMRInfo(mrRowid),"^",6) ;就诊id
 	s opArowid="" f  s opArowid=$o(^DHCANOPArrange(0,"Adm",admid,opArowid)) q:opArowid=""  d
 	.s opAStatus=$p(^DHCANOPArrange(opArowid),"^",27)
 	.q:opAStatus'="F"
 	.s anaestDr=$p(^DHCANOPArrange(opArowid),"^",2)  ;麻醉表的id
 	.q:anaestDr=""
 	.s anPaadmDr=$p(anaestDr,"||",1)
 	.s anSubDr=$p(anaestDr,"||",2)
 	.s operType=$P(^OR(anPaadmDr,"ANA",anSubDr),"^",32)  ;手术类型：E-急诊、B-择期
	.i operType="B" s operFlag1="择期"
	.i operType="E" s operFlag2="急诊"
	s operFlag=operFlag1_operFlag2
	q:operFlag="" "否"
	Q operFlag
}

/// 获取急诊手术人数（通过第一手术获取）
/// w ##Class(web.QueryMrInfo).GetEPOperRS(44350)
ClassMethod GetEPOperRS(mrRowid As %String) As %Integer [ SqlProc ]
{
	n (mrRowid)
	s flag=0
	/*
	s patRYTJ=$P(^DHCMRInfo(mrRowid),"^",34) ;入院途径
	q:patRYTJ'="急诊" flag
	s operCode=$P(^DHCMRInfo(mrRowid),"^",119) ;手术编码
	q:operCode="" flag
	s operType=$P(^DHCMRInfo(mrRowid),"^",129) ;类型
	q:operType'="1" flag
	s operLev=$P(^DHCMRInfo(mrRowid),"^",120)  ;手术级别
	*/
	s admid=$P(^DHCMRInfo(mrRowid),"^",6)
	s admOperStr=##class(MA.IPMR.IO.OutService).GetICDByAdm(admid,"O","1")
	s sfzqFlag=$p(admOperStr,$c(2),41)
	q:sfzqFlag'="急诊" flag
	q 1
}

/// 获取择期手术人数（通过第一手术获取）
/// w ##Class(web.QueryMrInfo).GetElecOperRS(44350)
ClassMethod GetElecOperRS(mrRowid As %String) As %Integer [ SqlProc ]
{
	n (mrRowid)
	s flag=0
	/*
	s patRYTJ=$P(^DHCMRInfo(mrRowid),"^",34) ;入院途径
	q:patRYTJ="急诊" flag
	s operCode=$P(^DHCMRInfo(mrRowid),"^",119) ;手术编码
	q:operCode="" flag
	s operType=$P(^DHCMRInfo(mrRowid),"^",129) ;类型
	q:operType'="1" flag
	s operLev=$P(^DHCMRInfo(mrRowid),"^",120)  ;手术级别
	*/
	s admid=$P(^DHCMRInfo(mrRowid),"^",6)
	s admOperStr=##class(MA.IPMR.IO.OutService).GetICDByAdm(admid,"O","1")
	s sfzqFlag=$p(admOperStr,$c(2),41)
	q:sfzqFlag'="择期" flag
	q 1
}

/// 获取workload费用
/// w ##Class(web.QueryMrInfo).GetWLFee("46042||83")
ClassMethod GetWLFee(admId As %String) As %String [ SqlProc ]
{
	n (admId)
	k data
	q:admId="" ""
	s wlRowid=0 f  s wlRowid=$o(^DHCWorkLoad(0,"PAADM",admId,wlRowid)) q:wlRowid=""  d
	.s wlTarECDr=$P($g(^DHCWorkLoad(wlRowid)),"^",41) 	;核算子分类
	.s wlTotalPrice=$P($g(^DHCWorkLoad(wlRowid)),"^",16) 	;费用
	.s data(wlTarECDr)=$g(data(wlTarECDr))+wlTotalPrice
	s str=""
	s tarEC=0 f  s tarEC=$o(^DHCTarC("EC",tarEC)) q:tarEC=""  d
	.s fee=$g(data(tarEC))
	.i str="" s str=fee
	.e  s str=str_"^"_fee
	k data
	Q str
}

/// 判DHCMRInfo表是否存在
/// w ##Class(web.QueryMrInfo).IsExistMR("46042||83")
ClassMethod IsExistMR(admId As %String) As %Integer [ SqlProc ]
{
	n (admId)
	q:admId="" 0
  q:'$d(^DHCMRInfo(0,"MR_PAADM_DR",admId)) 0
  Q 1
}

/// 获取疾病或手术配置组描述
/// w ##Class(web.QueryMrInfo).GetMRConfigDesc("45.7500")
ClassMethod GetMRConfigDesc(mricd, icdGrp) As %String [ SqlProc ]
{
	n (mricd,icdGrp)
	q:mricd="" ""
	s mricd=$ZCVT(mricd,"U")
	s mICDCat=$o(^DHCWLDiagICD(0,"DiagSort","Code",mricd,icdGrp,""))
	Q $g(mICDCat)
}

/// 获取疾病或手术配置组ID
ClassMethod GetMRConfigID(mricd, icdGrp) As %String [ SqlProc ]
{
	n (mricd,icdGrp)
	q:mricd="" ""
	s mricd=$ZCVT(mricd,"U")
	s mICDCat=$o(^DHCWLDiagICD(0,"DiagSort","ID",mricd,icdGrp,""))
	Q $g(mICDCat)
}

/// 获取统计子组描述
/// w ##Class(web.QueryMrInfo).GetStatGrpDesc("2","LocGrp")
ClassMethod GetStatGrpDesc(id As %String, grp As %String) As %String [ SqlProc ]
{
	n (id,grp)
	s locDesc=$$GetBSSubDesc^DHCWLBuildDimDataGetSubGrp(id_"~"_grp)
	Q locDesc
}

/// 获取统计子组代码
/// w ##Class(web.QueryMrInfo).GetStatGrpCode("46042||83")
ClassMethod GetStatGrpCode(id As %String, grp As %String) As %String [ SqlProc ]
{
	n (id,grp)
	s locDesc=$$GetBSSubCode^DHCWLBuildDimDataGetSubGrp(id_"~"_grp)
	Q locDesc
}

/// 获取统计子组顺序
/// w ##Class(web.QueryMrInfo).GetStatGrpOrder("46042||83")
ClassMethod GetStatGrpOrder(id As %String, grp As %String) As %Integer [ SqlProc ]
{
	n (id,grp)
	s locDesc=$$GetBSSubOrder^DHCWLBuildDimDataGetSubGrp(id_"~"_grp)
	Q locDesc
}

/// 获取统计子组描述、代码、顺序
/// w ##Class(web.QueryMrInfo).GetStatGrp("61","MrInfoLocGrp")
ClassMethod GetStatGrp(id As %String, grp As %String) As %String [ SqlProc ]
{
	n (id,grp)
	s typeCode=""
	s bsret=##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(id,grp,typeCode)
	Q bsret
}

/// / 疾病分类新表结构
/// w ##Class(web.QueryMrInfo).GetIcdCatDesc("DiagSortCode","A03.002")
/// w ##Class(web.QueryMrInfo).GetIcdCatDesc("18OperEmpCode","52.6x03")
/// ^DHCMRICDCate
/// ^DHCMRICDCateDetails(0,"ICDCDr",cate)
ClassMethod GetIcdCatDesc(mDiagGrp, mMainIcd)
{
	n (mDiagGrp,mMainIcd)
	s mReturn=""
	q:$g(mDiagGrp)="" $g(mReturn)
	q:'$d(^DHCMRICDCate(0,"Code",mDiagGrp)) $g(mReturn)
	s mainIcdDr=$o(^DHCMRICDCate(0,"Code",mDiagGrp,0))
	s ID=0 f  s ID=$o(^DHCMRICDCateDetails(0,"ICDCDr",mainIcdDr,ID)) q:ID=""  d
	.s mIcdCat=$P($g(^DHCMRICDCateDetails(ID)),"^",1)
	.q:..CheckICDCategory(ID,mMainIcd)=0
	.i $g(mReturn)="" d
	..s mReturn=mIcdCat
	.e  d
	..s mReturn=$g(mReturn)_"^"_$G(mIcdCat)	
	q $g(mReturn)
}

/// w ##Class(web.QueryMrInfo).GetIcdCatID("18OperEmpCode","52.6x03")
ClassMethod GetIcdCatID(mDiagGrp, mMainIcd)
{
	n (mDiagGrp,mMainIcd)
	s mReturn=""
	q:$g(mDiagGrp)="" $g(mReturn)
	q:'$d(^DHCMRICDCate(0,"Code",mMainIcd)) $g(mReturn)
	s mainIcdDr=$o(^DHCMRICDCate(0,"Code",mMainIcd,0))
	s ID=0 f  s ID=$o(^DHCMRICDCateDetails(0,"ICDCDr",mainIcdDr,ID)) q:ID=""  d
	.s mIcdCat=$P($g(^DHCMRICDCateDetails(ID)),"^",1)
	.q:..CheckICDCategory(ID,mMainIcd)=0
	.i $g(mReturn)="" d
	..s mReturn=ID
	.e  d
	..s mReturn=$g(mReturn)_"^"_$G(ID)	
	q $g(mReturn)
}

/// w ##class(web.DHCWLPatQtyFee).CheckICDRange("P10.000-P20.100","P19.345")
ClassMethod CheckICDRange(ICDRange, ICD)
{
 	;检查给定的ICD编码是否属于给定的cat类别的ICDCat病种名称
 	n (ICDRange,ICD)
 	s exist=0, ICDStart="", ICDEnd=""
 	s ICDList=..SplitString(ICDRange,",")
 	f ICDNum=1:1:$ll(ICDList) d
 	.q:exist=1
 	.i $f($li(ICDList,ICDNum),"-")=0 d
 	..i $li(ICDList,ICDNum)=$e(ICD,1,$l($li(ICDList,ICDNum))) {s exist=1}
 	.e  d
 	..s ICDList2=..SplitString($li(ICDList,ICDNum),"-")
 	..q:$ll(ICDList2)'=2
 	..s ICDStart=$li(ICDList2,1), ICDEnd=$li(ICDList2,2)
 	..i (($e(ICD,1,$l(ICDStart))=ICDStart)!($e(ICD,1,$l(ICDStart))]ICDStart))&(($e(ICD,1,$l(ICDEnd))=ICDEnd)!(ICDEnd]$e(ICD,1,$l(ICDEnd)))) d
 	...s exist=1
 	q:exist=1 1
 	q:exist=0 0
}

/// 检查给定的ICD编码是否属于给定的cat类别的ICDCat病种名称
/// d ##Class(web.QueryMrInfo).CheckICDCategory(183,"A03.002")
ClassMethod CheckICDCategory(icdCatDr, ICD)
{
 	n (icdCatDr,ICD)
 	s exist=0, ICDStart="", ICDEnd=""
 	s ICDRange=$P($g(^DHCMRICDCateDetails(icdCatDr)),"^",2)
 	s ICDRange=$ZCVT(ICDRange,"U")
 	s ICDList=..SplitString(ICDRange,",")
 	f ICDNum=1:1:$ll(ICDList) d
 	.q:exist=1
 	.i $f($li(ICDList,ICDNum),"-")=0 d
 	..i $li(ICDList,ICDNum)=$e(ICD,1,$l($li(ICDList,ICDNum))) {s exist=1}
 	.e  d
 	..s ICDList2=..SplitString($li(ICDList,ICDNum),"-")
 	..q:$ll(ICDList2)'=2
 	..s ICDStart=$li(ICDList2,1), ICDEnd=$li(ICDList2,2)
 	..i (($e(ICD,1,$l(ICDStart))=ICDStart)!($e(ICD,1,$l(ICDStart))]ICDStart))&(($e(ICD,1,$l(ICDEnd))=ICDEnd)!(ICDEnd]$e(ICD,1,$l(ICDEnd)))) d
 	...s exist=1
 	q:exist=1 1
 	q:exist=0 0
}

/// 分隔字符串string成为list, 从1开始
/// w ##Class(web.QueryMrInfo).SplitString()
ClassMethod SplitString(string, delimiter)
{
 	k resultList
 	s pos=0, length=0, count=0, a=0, newpos=1
 	s count=$l(string, delimiter)
 	q:count=0 $lb(string)
 	f delimCount=1:1:count-1 d
 	.s pos=$f(string, delimiter, pos+1)
 	.i pos>0 {s $li(resultList,delimCount)=$e(string, newpos, pos-2)}
 	.s newpos=pos
 	s $li(resultList,count)=$e(string, pos, $l(string))
 	q resultList
}

/// d ##Class(web.QueryMrInfo).GetDHCWLDiagICD()
ClassMethod GetDHCWLDiagICD()
{
	k ^DHCWLDiagICD
	;s paraCode="DiagEmpCode18,DiagCode30,DiagCode50,SingleDiag,HarmPoison,DiagSortCode,MalTumCode16"
	s paraCode="DiagEmpCode18,DiagCode30,DiagCode50,SingleDiagTest,SingleDiag,HarmPoison,DiagSortCode,MalTumCode16"
	s mID=""
	f {
		s mID=$O(^MRC("ID",mID))
		Q:mID=""
		s ICD9=$P(^MRC("ID",mID),"^",4)
		continue:ICD9=""
		s Name=$P(^MRC("ID",mID),"^",2)
		s toDate=$P(^MRC("ID",mID),"^",7)
		continue:toDate'=""
		s ICD9=$ZCVT(ICD9,"U")
		for i=1:1:$l(paraCode,","){
			;s ^DHCWLDiagICD(0,"DiagICD",ICD9,mID)=""
			s diagGrp=$P(paraCode,",",i)
			s mICDCat=..GetIcdCatDesc(diagGrp,ICD9)
			;s mICDCatDr=..GetIcdCatID(diagGrp,ICD9)
			continue:mICDCat=""
			w ICD9,!
			s ^DHCWLDiagICD(0,"DiagSort","Code",ICD9,diagGrp,mICDCat)=""
			;s ^DHCWLDiagICD(0,"DiagSort","ID",ICD9,diagGrp,mICDCatDr)=""
		}
	}
	Q
}

/// d ##Class(web.QueryMrInfo).GetDHCWLOperICD()
ClassMethod GetDHCWLOperICD()
{
	s diagGrp="OperEmpCode18"
	s mID=""
	f {
		s mID=$O(^ORC("OPER",mID))
		Q:mID=""
		s ICD9=$P(^ORC("OPER",mID),"^",14)
		continue:ICD9=""
		s Name=$P(^ORC("OPER",mID),"^",2)
		s toDate=$P(^ORC("OPER",mID),"^",6)
		continue:toDate'=""
		s ICD9=$ZCVT(ICD9,"U")
		;s ^DHCWLDiagICD(0,"OperICD",ICD9,mID)=""
		s mICDCat=..GetIcdCatDesc(diagGrp,ICD9)
		continue:mICDCat=""
		w ICD9,mICDCat,!
		s ^DHCWLDiagICD(0,"DiagSort","Code",ICD9,diagGrp,mICDCat)=""
	}
	Q
}

/// 通过手术编码获取手术操作类型(治疗性操作,诊断性操作)
/// w ##Class(web.QueryMrInfo).GetOperICD10Map("00.18002")
ClassMethod GetOperICD10Map(code) As %String [ SqlProc ]
{
	n (code)
	s operICD10Map="",operRowId=""
	q:code="" operICD10Map
	s operRowId=$O(^ORC("OPER",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
	q:operRowId="" operICD10Map
	s operICD10Map=$P($g(^ORC("OPER",operRowId)),"^",20)
	q operICD10Map
}

/// 通过手术编码获取手术操作类型(治疗性操作,诊断性操作)
/// 或者通过手术扩展表(ORC_OperationExtend) OPER_Type字段  T：治疗性操作 D：诊断性操作 N：常规性操作
/// 在his基础数据->手术/过程->手术扩展信息里维护
/// w ##Class(web.QueryMrInfo).GetOperExtType("00.18002")
ClassMethod GetOperExtType(code) As %String [ SqlProc ]
{
	n (code)
	s operType="",operRowId=""
	q:code="" operType
	s operRowId=$O(^ORC("OPER",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
	q:operRowId="" operType
	s operType=$P($g(^ORC("OPER",operRowId,"DHC")),"^",11)
	q operType
}

/// 获取服务半径（本县区，本市外县区，本省外市，外省市）---门诊部分
/// w ##Class(web.QueryMrInfo).GetSerRadOP("46042||83")
ClassMethod GetSerRadOP(admId As %String) As %String [ SqlProc ]
{
	n (admId)
	s county="榆阳"
	s city="榆林"
	s province="陕西"
	s papmi=$P($g(^PAADM(admId)),"^",1)
	s stName=$p(^PAPER(papmi,"PER","ADD",1),"^")   ;病人地址
	q:(stName[city)&(stName[county) "本县区"
	q:(stName[city)&(stName'[county) "本市外县区"
	q:(stName[province)&(stName'[city) "本省外市"
	q:(stName'[province)&(stName'[city) "外省市"
	Q "外省市"
}

/// 通过描述获取患者离院方式描述
/// w ##Class(web.QueryMrInfo).GetPatGender("1")
ClassMethod GetPatLyfsn(mDesc As %String) As %String [ SqlProc ]
{
	n (mDesc)
    q:mDesc="" 9
    q:mDesc["医嘱离院" 1
    q:mDesc["医嘱转院" 2
    q:mDesc["医嘱转社区" 3
    q:mDesc["非医嘱离院" 4
    q:mDesc["死亡" 5
    q:mDesc["其他" 9
    q:mDesc="" 9
}

/// 通过ID获取患者性别描述
/// w ##Class(web.QueryMrInfo).GetPatGender("1")
ClassMethod GetPatGender(id As %String) As %String [ SqlProc ]
{
	n (id)
	q:id="" ""
	q:'$d(^CT("SEX",id)) id
	s sexDesc=$P($g(^CT("SEX",id)),"^",2)
	Q sexDesc
}

/// 通过药学项子表ID获取管制分类
/// w ##Class(web.QueryMrInfo).GetPoisonByPhcdf("46042||83")
ClassMethod GetPoisonByPhcdf(poison As %String = "", phcdf As %String) As %Integer [ SqlProc ]
{
	n (poison,phcdf)
	q:poison="" 1
	q:phcdf="" 0
	s phcpoId=$p($G(^PHCD(+phcdf,1)),"^",4)
	q:phcpoId="" 0
	q:$find(","_poison_",",","_phcpoId_",") 1
	q 0
}

/// 根据医嘱项获取规格
ClassMethod GetSpec(arcitm As %String) As %String [ SqlProc ]
{
	n (arcitm)
	q:arcitm="" ""
	s inci=$O(^INCI(0,"ARCIM_DR",$p(arcitm,"||",1),0))
	q:inci="" ""
	s add=$o(^DHCITMINFO(0,"INCI",inci,"")) 
	q:add="" ""
	s spec=$p($G(^DHCITMINFO(add)),"^",27)
	q spec
}

/**************20181212新增************************/
/// 获取住院患者入院途径
/// w ##Class(web.QueryMrInfo).GetPatRYTJ("46042||83")
ClassMethod GetPatRYTJ(mMRId As %String) As %String [ SqlProc ]
{
	n (mMRId)
	s mrRYTJ=$P($g(^DHCMRInfo(mMRId)),"^",34) ;入院途径
	s mrRYTJ=$Case(mrRYTJ,"1":"急诊","2":"门诊","3":"其他医疗机构转入","9":"其他",:"其他")
	q mrRYTJ
}

/// 获取住院患者出院主要诊断入院病情
/// w ##Class(web.QueryMrInfo).GetPatRYBQ("46042||83")
ClassMethod GetPatRYBQ(mMRId As %String) As %String [ SqlProc ]
{
	n (mMRId)
	;s mrRYBQ=$P($g(^DHCMRInfo(mMRId)),"^",45) ;入院病情
	s mrRYBQ=$P($g(^DHCMRInfo(mMRId)),"^",54) ;入院病情
	;s mrRYBQ=$Case(mrRYBQ,"1":"有","2":"临床未确定","3":"情况不明","4":"无",:mrRYBQ)
	
	q mrRYBQ
}

/// 获取住院患者离院方式
/// w ##Class(web.QueryMrInfo).GetPatLYFS("46042||83")
ClassMethod GetPatLYFS(mMRId As %String) As %String [ SqlProc ]
{
	n (mMRId)
    s mrLYFS=$P($g(^DHCMRInfo(mMRId)),"^",46) ;离院方式
    ;s mrLYFS=$Case(mrLYFS,"1":"医嘱离院","2":"医嘱转院","3":"医嘱转社区卫生服务机构/乡镇卫生院","4":"非医嘱离院","5":"死亡","9":"其他",:"其他")
    q mrLYFS
}

/// 获取住院患者出院主要诊断诊疗结果/出院情况
/// w ##Class(web.QueryMrInfo).GetPatZLJG("46042||83")
ClassMethod GetPatZLJG(mMRId As %String) As %String [ SqlProc ]
{
	n (mMRId)
    s mrZLJG=$P($g(^DHCMRInfo(mMRId)),"^",55) ;出院主要诊断诊疗结果
    s mrZLJG=$Case(mrZLJG,"1":"治愈","2":"好转","3":"未愈","4":"死亡","9":"其他",:"其他")
    ;s mrZLJG=$Case(mrZLJG,"1":"治愈","2":"好转","3":"稳定","4":"恶化","5":"死亡","9":"其他",:"其他")
    q mrZLJG
}

/// 获取住院患者临床路径
/// w ##Class(web.QueryMrInfo).GetPatLCLJ("46042||83")
ClassMethod GetPatLCLJ(mMRId As %String) As %String [ SqlProc ]
{
	n (mMRId)
    s mrLCLJ=$P($g(^DHCMRInfo(mMRId)),"^",296) ;患者临床路径
    s mrLCLJ=$Case(mrLCLJ,"1":"完成","2":"变异","3":"出径","4":"未入经",:"其他")
    q mrLCLJ
}

/// 获取住院患者主要手术级别
/// w ##Class(web.QueryMrInfo).GetOperSort("46042||83")
ClassMethod GetOperSort(mMRId As %String) As %String [ SqlProc ]
{
	n (mMRId)
    s mrOperType=$P($g(^DHCMRInfo(mMRId)),"^",120) ;手术级别
    s mrOperType=$Case(mrOperType,"1":"一级手术","2":"二级手术","3":"三级手术","4":"四级手术","5":"操作",:"其他")
    q mrOperType
}

/// 获取住院患者主要手术切口分类
/// w ##Class(web.QueryMrInfo).GetOperLev("46042||83")
ClassMethod GetOperLev(mMRId As %String) As %String [ SqlProc ]
{
	n (mMRId)
    s mrHealLev=$P($g(^DHCMRInfo(mMRId)),"^",127) ;手术切口分类愈合等级
    s operLev=$P(mrHealLev,"/",1)
    s operLev=$Case(operLev,"I":"一类手术","II":"二类手术","III":"三类手术",:"其他")
    q operLev
}

/// 获取住院患者主要手术切口愈合等级
/// w ##Class(web.QueryMrInfo).GetOperHea("46042||83")
ClassMethod GetOperHea(mMRId As %String) As %String [ SqlProc ]
{
	n (mMRId)
    s mrHealLev=$P($g(^DHCMRInfo(mMRId)),"^",127) ;手术切口分类愈合等级
    s operHea=$P(mrHealLev,"/",2)
    s operHea=$Case(operHea,"1":"甲","2":"乙","3":"丙","9":"其他",:"其他")
    q operHea
}

/// 获取住院患者性别
/// w ##Class(web.QueryMrInfo).GetOperHea("46042||83")
ClassMethod GetpatSex(mMRId As %String) As %String [ SqlProc ]
{
	n (mMRId)
    s patSex=$P(^DHCMRInfo(mMRId),"^",9) ;性别
    ;s patSex=$Case(patSex,"1":"男","2":"女",:"其他")
    q patSex
}

/// 通过时间来判断是否正常上班时间
/// w ##Class(web.QueryMrInfo).GetTimeRange(178429)
ClassMethod GetTimeRange(regTime As %String) As %String [ SqlProc ]
{
	n (regTime)
	q:(regTime>28800)&&(regTime<43200) "班内"
	q:(regTime>52200)&&(regTime<63000) "班内"
	q "班外"
}

/// 获取ICD-10编码类目
/// w ##Class(web.QueryMrInfo).GetICDCategory("A00.001")
ClassMethod GetICDCategory(icd As %String) As %String [ SqlProc ]
{
	n (icd)
	q:icd'["." icd
	q:$e(icd,4)="*" $e(icd,1,4)
	q $P(icd,".",1)
}

/// 获取ICD-10编码亚目
/// w ##Class(web.QueryMrInfo).GetICDSuborder("A00.001")
ClassMethod GetICDSuborder(icd As %String) As %String [ SqlProc ]
{
	n (icd)
	q:icd'["." icd
	q:$e(icd,6)="*" $e(icd,1,6)
	q $e(icd,1,5)
}

/// 获取ICD-10编码细目
/// w ##Class(web.QueryMrInfo).GetICDDetailCata("A00.001")
ClassMethod GetICDDetailCata(icd As %String) As %String [ SqlProc ]
{
	n (icd)
	q:icd'["." icd
	q $e(icd,1,6)
}

/// 获取手术人次
/// w ##Class(web.QueryMrInfo).GetOperRC(15808)
ClassMethod GetOperRC(mrRowid As %String) As %Integer [ SqlProc ]
{
	n (mrRowid)
	s operNum=0
	k data
	f i=0:1:9 d
	.s node=11*i
	.s operCode=$P(^DHCMRInfo(mrRowid),"^",118+node+1) ;手术编码
	.q:operCode=""
	.s operLev=$P(^DHCMRInfo(mrRowid),"^",118+node+2)  ;手术级别
	.s operDate=$P(^DHCMRInfo(mrRowid),"^",118+node+3) ;手术日期
	.q:operDate=""
	.q:$d(data(operDate))
	.s operType=$P(^DHCMRInfo(mrRowid),"^",118+node+11) ;类型
	.i i=3 s operType=$P(^DHCMRInfo(mrRowid),"^",118+node+10)
	.q:(operType'="1")&&(operType'="手术")
	.s operNum=operNum+1
	.s data(operDate)=""
	
	q operNum
}

/// 获取手术人次（级别）
/// w ##Class(web.QueryMrInfo).GetOperRCLev(15808)
ClassMethod GetOperRCLev(mrRowid As %String) As %String [ SqlProc ]
{
	n (mrRowid)
	s operNum=0,operLevlast=0
	k data,plist
	f i=0:1:9 d
	.s node=11*i
	.s operCode=$P(^DHCMRInfo(mrRowid),"^",118+node+1) ;手术编码
	.q:operCode=""
	.s operLev=$P(^DHCMRInfo(mrRowid),"^",118+node+2)  ;手术级别
	.s operLev=$Case(operLev,"一级手术":1,"二级手术":2,"三级手术":3,"四级手术":4,:0)
	.s operDate=$P(^DHCMRInfo(mrRowid),"^",118+node+3) ;手术日期
	.q:operDate=""
	.s operType=$P(^DHCMRInfo(mrRowid),"^",118+node+11) ;类型
	.i i=3 s operType=$P(^DHCMRInfo(mrRowid),"^",118+node+10)
	.q:(operType'="1")&&(operType'="手术")
	.i '$d(plist(operDate)) s mValue=$i(data(operLev))
	.i $d(plist(operDate))&&($o(plist(operDate,""),-1)<operLev) d
	..s data($o(plist(operDate,""),-1))=$g(data($o(plist(operDate,""),-1)))-1
	..s mValue=$i(data(operLev))
	.s plist(operDate,operLev)=""
	
	q +$g(data(1))_","_+$g(data(2))_","_+$g(data(3))_","_+$g(data(4))
}

/// 获取手术例数（级别）
/// w ##Class(web.QueryMrInfo).GetOperLSLev(9612)
ClassMethod GetOperLSLev(mrRowid As %String) As %String [ SqlProc ]
{
	n (mrRowid)
	s operNum=0,operLevlast=0
	k data,plist
	f i=0:1:9 d
	.s node=11*i
	.s operCode=$P(^DHCMRInfo(mrRowid),"^",118+node+1) ;手术编码
	.q:operCode=""
	.s operLev=$P(^DHCMRInfo(mrRowid),"^",118+node+2)  ;手术级别
	.s operLev=$Case(operLev,"一级手术":1,"二级手术":2,"三级手术":3,"四级手术":4,:0)
	.s operDate=$P(^DHCMRInfo(mrRowid),"^",118+node+3) ;手术日期
	.q:operDate=""
	.s operType=$P(^DHCMRInfo(mrRowid),"^",118+node+11) ;类型
	.i i=3 s operType=$P(^DHCMRInfo(mrRowid),"^",118+node+10)
	.q:(operType'="1")&&(operType'="手术")
	.s mValue=$i(data(operLev))
	q +$g(data(1))_","_+$g(data(2))_","_+$g(data(3))_","_+$g(data(4))
}

/// 获取手术例数（码数）
/// w ##Class(web.QueryMrInfo).GetOperLS(15808)
ClassMethod GetOperLS(mrRowid As %String) As %Integer [ SqlProc ]
{
	n (mrRowid)
	s operNum=0
	f i=0:1:9 d
	.s node=11*i
	.s operCode=$P(^DHCMRInfo(mrRowid),"^",118+node+1) ;手术编码
	.q:operCode=""
	.s operLev=$P(^DHCMRInfo(mrRowid),"^",118+node+2)  ;手术级别
	.s operDate=$P(^DHCMRInfo(mrRowid),"^",118+node+3) ;手术日期
	.s operType=$P(^DHCMRInfo(mrRowid),"^",118+node+11) ;类型
	.i i=3 s operType=$P(^DHCMRInfo(mrRowid),"^",118+node+10)
	.q:(operType'="1")&&(operType'="手术")
	.s operNum=operNum+1
	q operNum
}

/// 获取操作例数（码数）
/// w ##Class(web.QueryMrInfo).GetOperCZLS(15808)
ClassMethod GetOperCZLS(mrRowid As %String) As %Integer [ SqlProc ]
{
	n (mrRowid)
	s operNum=0
	f i=0:1:9 d
	.s node=11*i
	.s operCode=$P(^DHCMRInfo(mrRowid),"^",118+node+1) ;手术编码
	.q:operCode=""
	.s operLev=$P(^DHCMRInfo(mrRowid),"^",118+node+2)  ;手术级别
	.s operDate=$P(^DHCMRInfo(mrRowid),"^",118+node+3) ;手术日期
	.s operType=$P(^DHCMRInfo(mrRowid),"^",118+node+11) ;类型
	.i i=3 s operType=$P(^DHCMRInfo(mrRowid),"^",118+node+10)
	.q:(operType'="2")&&(operType'="操作")
	.s operNum=operNum+1
	q operNum
}

/// 获取手术人数
/// w ##Class(web.QueryMrInfo).GetOperRS(15808)
ClassMethod GetOperRS(mrRowid As %String) As %Integer [ SqlProc ]
{
	n (mrRowid)
	s flag=0
	f i=0:1:9 q:flag=1  d
	.s node=11*i
	.s operCode=$P(^DHCMRInfo(mrRowid),"^",118+node+1) ;手术编码
	.q:operCode=""
	.s operType=$P(^DHCMRInfo(mrRowid),"^",118+node+11) ;类型
	.i i=3 s operType=$P(^DHCMRInfo(mrRowid),"^",118+node+10)
	.q:(operType'="1")&&(operType'="手术")
	.s flag=1
	q flag
}

/// ^DHCPB(0,"ADM",{PB_Adm_Dr},{PB_RowId})
/// ^DHCPBi(0,"ARCIM",{PBO_ARCIM_DR},{DHC_PatientBill.PB_RowId},{PBO_ChildSub})
/// 通过就诊ID判断是否为病危患者（36410||1为病重医嘱项目）
/// w ##Class(web.QueryMrInfo).IsBWByAdm(15808)
ClassMethod IsBWByAdm(admid As %String) As %String [ SqlProc ]
{
	n (admid)
	q:admid="" "否"
	q:'$d(^DHCPB(0,"ADM",admid)) "否"
	s flag=0,retValue="否"
	s pbRowid=0 f  s pbRowid=$O(^DHCPB(0,"ADM",admid,pbRowid)) q:(pbRowid="")!(flag=1)  d
	.i $d(^DHCPBi(0,"ARCIM","36410||1",pbRowid)) d
	..s flag=1
	..s retValue="是"
	q retValue
}

/// 通过就诊ID判断是否为病重患者（36409||1为病重医嘱项目）
/// w ##Class(web.QueryMrInfo).IsBZByAdm(15808)
ClassMethod IsBZByAdm(admid As %String) As %String [ SqlProc ]
{
	n (admid)
	q:admid="" "否"
	q:'$d(^DHCPB(0,"ADM",admid)) "否"
	s flag=0,retValue="否"
	s pbRowid=0 f  s pbRowid=$O(^DHCPB(0,"ADM",admid,pbRowid)) q:(pbRowid="")!(flag=1)  d
	.i $d(^DHCPBi(0,"ARCIM","36409||1",pbRowid)) d
	..s flag=1
	..s retValue="是"
	q retValue
}

/// 通过就诊ID判断是否为病危病重患者
/// w ##Class(web.QueryMrInfo).IsBWBZByAdm(15808)
ClassMethod IsBWBZByAdm(admid As %String) As %String [ SqlProc ]
{
	n (admid)
	q:admid="" "否"
	q:'$d(^DHCPB(0,"ADM",admid)) "否"
	s flag=0,retValue="否"
	s pbRowid=0 f  s pbRowid=$O(^DHCPB(0,"ADM",admid,pbRowid)) q:(pbRowid="")!(flag=1)  d
	.i $d(^DHCPBi(0,"ARCIM","36410||1",pbRowid))!$d(^DHCPBi(0,"ARCIM","36409||1",pbRowid)) d
	..s flag=1
	..s retValue="是"
	q retValue
}

/// 是否为输血患者（通过医嘱子类为-嘱托输血来判断）
/// w ##Class(web.QueryMrInfo).IsBloodTrans(15808)
ClassMethod IsBlood(admid As %String) As %String [ SqlProc ]
{
	n (admid)
	q:admid="" "否"
	q:'$d(^DHCWorkLoad(0,"PAADM",admid)) "否"
	s retValue="否",flag=0
	
	s wlRowid=0 f  s wlRowid=$O(^DHCWorkLoad(0,"PAADM",admid,wlRowid)) q:(wlRowid="")!(flag=1)  d
	.q:$P($g(^DHCWorkLoad(wlRowid)),"^",9)'="64"
	.s totalPrice=$P($g(^DHCWorkLoad(wlRowid)),"^",16)
	.s oeori=$P($g(^DHCWorkLoad(wlRowid)),"^",21)
	.s itemStat=$p($g(^OEORD(+oeori,"I",$P(oeori,"||",2),1)),"^",13)
	.q:(itemStat'="1")&&(itemStat'="6")
	.s flag=1
	.s retValue="是"
	q retValue
}

/// 是否为输血反应患者(所有诊断编码里包含T80.901的即为输血患者)
/// w ##Class(web.QueryMrInfo).IsBloodTrans(15808)
ClassMethod IsBloodTrans(mrRowid As %String) As %String [ SqlProc ]
{
	n (mrRowid)
	q:mrRowid="" "否"
	q:'$d(^DHCMRInfo(mrRowid)) "否"
	s retValue="否"
	s flag=0
	f i=0:1:14 q:flag=1  d
	.s node=4*i
	.s diagCode=$P(^DHCMRInfo(mrRowid),"^",51+node+1) ;诊断编码
	.q:diagCode=""
	.i diagCode="T80.901" d
	..s flag=1
	..s retValue="是"
	q retValue
}

/// 是否为输液患者（通过医嘱用法来判断）
/// w ##Class(web.QueryMrInfo).IsBlood(15808)
ClassMethod IsLiquid(admid As %String) As %String [ SqlProc ]
{
	n (admid)
	q:admid="" "否"
	q:'$d(^PAADM(admid)) "否"
	s retValue="否",flag=0
	
	s oeord="" f  s oeord=$o(^OEORD(0,"Adm",admid,oeord)) q:oeord=""  d
	.s childSub=0 f  s childSub=$o(^OEORD(oeord,"I",childSub)) q:(childSub="")!(flag=1)  d
	..s itemStat=$p($g(^OEORD(oeord,"I",childSub,1)),"^",13)
	..q:(itemStat'="1")&&(itemStat'="6")
	..s instr=$p($g(^OEORD(oeord,"I",childSub,2)),"^",7)
	..q:instr=""
	..s instrDesc=$p(^PHCIN(instr),"^",2)
	..i ((instrDesc["输液")||(instrDesc["静滴")||(instrDesc["滴注")) d
	...s flag=1
	...s retValue="是"

	q retValue
}

/// 是否为输液反应患者(所有诊断编码里包含T80.902的即为输液患者)
/// w ##Class(web.QueryMrInfo).IsLiquidTrans(15808)
ClassMethod IsLiquidTrans(mrRowid As %String) As %String [ SqlProc ]
{
	n (mrRowid)
	q:mrRowid="" "否"
	q:'$d(^DHCMRInfo(mrRowid)) "否"
	s retValue="否"
	s flag=0
	f i=0:1:14 q:flag=1  d
	.s node=4*i
	.s diagCode=$P(^DHCMRInfo(mrRowid),"^",51+node+1) ;诊断编码
	.q:diagCode=""
	.i diagCode="T80.902" d
	..s flag=1
	..s retValue="是"
	q retValue
}

/// 获取患者诊断
/// w ##class(web.QueryMrInfo).GetAdmDiagnosis(adm,type)
ClassMethod GetDiagByAdm(Adm As %String, Type As %String = "") As %String [ SqlProc ]
{
	n (Adm,Type)
	if $g(Adm)="" q ""
	s MRAdm=$p($g(^PAADM(Adm)),"^",61)
	q:$g(MRAdm)="" ""
	Set DiagStr="",Diag=0
	For  Set Diag=$O(^MR(MRAdm,"DIA",Diag)) Quit:(Diag="")  Do
	.Set DiagID=$P($g(^MR(MRAdm,"DIA",Diag)),"^",1)
	.s DiagTypeID=$o(^MR(MRAdm,"DIA",Diag,"TYP",0))
	.s TypeID="",TypeDesc=""
	.i DiagTypeID'="" s TypeID=$p($g(^MR(MRAdm,"DIA",Diag,"TYP",DiagTypeID)),"^",1)
	.i TypeID'="" s TypeDesc=$p($g(^MRC("DTYP",TypeID)),"^",2)
	.q:((Type="ADM")&&(TypeDesc'="入院诊断"))
	.q:((Type="DIS")&&(TypeDesc'="出院诊断"))
	.q:((Type="Main")&&(TypeDesc'="主诊断"))
	.q:((Type="PRE")&&(TypeDesc'="初步诊断"))
	.q:((Type="OP")&&(TypeDesc'="门诊诊断"))
	.if DiagID'="" Set DiagDesc=$P($g(^MRC("ID",DiagID)),"^",2)
	.else  Set DiagDesc=$g(^MR(MRAdm,"DIA",Diag,"DES",1))
	.;If DiagDesc["-" Set DiagDesc=$P(DiagDesc,"-",2)
	.If $P($g(^MR(MRAdm,"DIA",Diag,1)),"^",20)="Y" s DiagDesc=DiagDesc_"(主)"
	.If DiagStr="" Set DiagStr=DiagDesc
	.Else  Set DiagStr=DiagStr_","_DiagDesc	
	quit DiagStr
}

/// 通过就诊ID获取患者第一诊断 type='Y' 为中医诊断
/// w ##class(web.QueryMrInfo).GetFirDiagByAdm(523573)
ClassMethod GetFirDiagByAdm(admid As %String, type As %String = "") As %String [ SqlProc ]
{
	n (admid,type)
	q:admid="" ""
	s mrAdm=$p($g(^PAADM(admid)),"^",61)
	q:mrAdm="" ""
	s flag=0,diagDesc=""
	s diag=0 f  s diag=$O(^MR(mrAdm,"DIA",diag)) q:(diag="")!(flag=1)  d
	.s diagID=$P($g(^MR(mrAdm,"DIA",diag)),"^",1)
	.s mrBillFlag3=$P($g(^MRC("ID",+diagID)),"^",15)
	.q:(type="Y")&&(mrBillFlag3'="Y")
	.s diagDesc=$P($g(^MRC("ID",+diagID)),"^",2)
	.i diagDesc="" s diagDesc=$g(^MR(mrAdm,"DIA",diag,"DES",1))
	.s flag=1
	q diagDesc
}

/// 获取下诊断医生
ClassMethod GetDiagDoc(admid) As %String [ SqlProc ]
{
	n (admid)
	s mrrowid=$p(^PAADM(paadmrowid),"^",61)
	q:mrrowid="" ""
    s subRowid="",ctpcpdr=""
    f  s subRowid=$o(^MR(+mrrowid,"DIA",subRowid)) q:(subRowid="")||(ctpcpdr'="")  d
    .s ctpcpdr=$p(^MR(mrrowid,"DIA",subRowid),"^",4)
    q ctpcpdr
}

/// 获取医嘱单价
/// w ##class(web.QueryMrInfo).GetUnitPrice("30")
ClassMethod GetUnitPrice(wlRowid) As %Float [ SqlProc ]
{
	n (wlRowid)
	s unitPrice=0
	s mOrdDate=$p($g(^DHCWorkLoad(wlRowid)),"^",5)
	s itemOrd=$p($g(^DHCWorkLoad(wlRowid)),"^",2)
	s pbd=$p($g(^DHCWorkLoad(wlRowid)),"^",48)
	s pboSub=$P(pbd,"||",2)
	i $d(^DHCPB(+pbd,"O",pboSub))  d
	.s unitPrice=$P($g(^DHCPB(+pbd,"O",pboSub)),"^",7) ;医嘱单价
	e  d
	.s rValue=##class(web.UDHCJFPRICE).GetOrderPrice("","",itemOrd,mOrdDate,"","","","")
	.s unitPrice=$p(rValue,"^",1)  ;医嘱单价
	q unitPrice
}

/// 获取日期月份
/// w ##class(web.QueryMrInfo).GetDateStr("65595")
ClassMethod GetDateStr(date) As %String [ SqlProc ]
{
	n (date)
	q:date="" ""
	s date=$zd(date,3)
	s dateMon=$P(date,"-",2)
	;s dateDay=$P(date,"-",3)
	;i dateDay>26 s dateMon=dateMon+1
	;i dateMon>12 s dateMon="01"
	q +dateMon
}

}
