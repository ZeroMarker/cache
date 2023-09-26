Import SQLUser

Class web.INSUDiagnosis Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

// 保存诊断对照

// w ##class(web.INSUDiagnosis).SaveCont("^7670^E25.001^11β-羟化酶缺陷症^7233^E25.001^11β-羟化酶缺陷症^00A^2023-01-29^1^^^^^^^^^^^ZDLCB2.0^ZDYBB2.0") 

ClassMethod SaveCont(Args As %String) As %String
{
	s RtnStr=""
	q:$p(Args,"^",21)="" "-1!院内版本号为空"	//医保诊断对照版本号必填控制	+20230518 HanZH 
	q:$p(Args,"^",22)="" "-1!医保版本号为空"	//医保诊断对照版本号必填控制	+20230518 HanZH 
	s:($p(Args,"^",20)="")&&($g(%session)'="") $p(Args,"^",20)=$g(%session.Data("DHCBILLINSUCloud.Hospital")) // tangzf 2019-8-2
	s RtnStr=$$SaveCont^DHCINSUICDContrast(Args)
	b ;//+20230215 HanZH 推送对照信息到病案
	i (+RtnStr>0)&($l(Args,"^")>20) {
		s $p(Args,"^",1) = +RtnStr
 		s sendRtn=##class(web.DHCINSUPortUse).SendICDMapInfo(Args,"diag")
		q:+sendRtn<0 sendRtn
	}
	q RtnStr
}

// w ##class(web.INSUDiagnosis).GetInfoById("3")  

ClassMethod GetInfoById(ID As %String) As %String
{
	s RtnStr=""
	s RtnStr=$$GetInfoById^DHCINSUDiagnosis(ID)
	q RtnStr
}

ClassMethod AutoCon(Args As %String) As %String
{
	s RtnStr=""
	s:($p(Args,"^",3)="")&&($g(%session)'="") $p(Args,"^",3)=$g(%session.Data("DHCBILLINSUCloud.Hospital")) // tangzf 2019-8-2
	q:$p(Args,"^",3)="" "-1^院区为空不允许自动对照" //自动对照只允许自动对照本院区数据 并且必须传入最小院区(未分组的)
	s RtnStr=$$AutoCon^DHCINSUICDContrast(Args)
	q RtnStr
}

// w ##class(web.INSUDiagnosis).DelCont("28721") 

ClassMethod DelCont(Args As %String) As %String
{
	s RtnStr=""
	q:+Args<1 "-1"
	//st 删除对照前先推送同步到病案 +20230206 HanZH
	s ICDConStr=..GetICDConInfoById(Args)
	if (+ICDConStr>0) {
 		s sendRtn=##class(web.DHCINSUPortUse).SendICDMapInfo(ICDConStr,"diag","0")
		q:+RtnStr<0 RtnStr
	}
	//ed
	// 
	s RtnStr=$$Delete^DHCINSUICDContrast(Args)
	
	//st 删除对照后需要把当前生效的对照关系推送到病案 +20230206 HanZH
	if (+RtnStr>=0) {
		s HisDr=$p(ICDConStr,"^",2)
		s InsuType=$p(ICDConStr,"^",8)
		s HospDr=$p(ICDConStr,"^",20)
		s ActDate=+$h
		s ConString=$$CheckCon^DHCINSUICDContrast(HisDr,InsuType,ActDate,HospDr)
		s ConId=$p(ConString,"!",2)
		q:ConId="" RtnStr_"!删除诊断对照成功,同步病案系统成功"
		s ICDConStrNew=..GetICDConInfoById(ConId)
 		s sendRtn=##class(web.DHCINSUPortUse).SendICDMapInfo(ICDConStrNew,"diag")
		q:+RtnStr<0 RtnStr
		s:+RtnStr>0 RtnStr=+RtnStr_"!删除诊断对照成功,同步病案系统成功"
	}
	//ed
	q RtnStr
}

ClassMethod SaveInsuDiagnosis(Args As %String) As %String
{
	s RtnStr=""
	s:($p(Args,"^",26)="")&&($g(%session)'="") $p(Args,"^",26)=$g(%session.Data("DHCBILLINSUCloud.Hospital")) // tangzf 2019-8-2
	s RtnStr=$$Save^DHCINSUDiagnosis(Args)
	q RtnStr
}

ClassMethod QueryDiagnosisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDiagnosisExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.INSUDiagnosis","QueryDiagnosis","00A","2@E25.001","2")
ClassMethod QueryDiagnosisExecute(ByRef qHandle As %Binary, QType As %String, QKWords As %String, HospDr = "", QHisVer As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	;q:QKWords="" $$$OK
	s qclass="",QWords=""
	i $l(QKWords,"@")>1 d
	.s qclass=$p(QKWords,"@",1)
	.s QWords=$p(QKWords,"@",2)
	s:(HospDr="")&&(%session'="") HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital")) 
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_Diagnosis",HospDr)
	s ^TMPZMC(21)=$lb(QType, QKWords, HospDr)
	s aliQWord=$$ALPHAUP^SSUTIL4(QWords) 
	i qclass="1"
	{
		s INDISbzmc=""
		f  s INDISbzmc=$o(^DHCINDiagnos("0","Alias",INDISbzmc))	q:INDISbzmc=""  d
		.q:(INDISbzmc'[aliQWord)&(aliQWord'="")
		.s INDISRowid=""
		.f  s INDISRowid=$o(^DHCINDiagnos("0","Alias",INDISbzmc,INDISRowid))  q:INDISRowid=""  d
		..s INDISInfo=$g(^DHCINDiagnos(INDISRowid))
		..s bztype=$p(INDISInfo,"^",1)
		..q:(QType'="")&(QType'=bztype)
		..s bzbm=$p(INDISInfo,"^",2)
		..s bzmc=$p(INDISInfo,"^",3)
		..d Build
	}
	i qclass="2"
	{
		//"CODE"
		i aliQWord'="" d
		.q:$d(^DHCINDiagnos("0","CODE",aliQWord))=0
		.s INDISRowid=""
		.f  s INDISRowid=$o(^DHCINDiagnos("0","CODE",aliQWord,INDISRowid))	q:INDISRowid=""  d
		..s INDISInfo=$g(^DHCINDiagnos(INDISRowid))
		..s bztype=$p(INDISInfo,"^",1)
		..q:(QType'="")&(QType'=bztype)
		..s bzbm=$p(INDISInfo,"^",2)
		..s bzmc=$p(INDISInfo,"^",3)
		..d Build
		e  d
		.f  s aliQWord=$o(^DHCINDiagnos("0","CODE",aliQWord)) q:aliQWord=""  d
		..s INDISRowid=""
		..f  s INDISRowid=$o(^DHCINDiagnos("0","CODE",aliQWord,INDISRowid)) q:INDISRowid=""  d
		...s INDISInfo=$g(^DHCINDiagnos(INDISRowid))
		...s bztype=$p(INDISInfo,"^",1)
		...q:(QType'="")&(QType'=bztype)
		...s bzbm=$p(INDISInfo,"^",2)
		...s bzmc=$p(INDISInfo,"^",3)
		...d Build
	}
	i qclass="3"
	{
		s INDISbzmc=""
		f  s INDISbzmc=$o(^DHCINDiagnos("0","DESC",INDISbzmc))	q:INDISbzmc=""  d
		.q:(INDISbzmc'[QWords)&(QWords'="")
		.s INDISRowid=""
		.f  s INDISRowid=$o(^DHCINDiagnos("0","DESC",INDISbzmc,INDISRowid))  q:INDISRowid=""  d
		..s INDISInfo=$g(^DHCINDiagnos(INDISRowid))
		..s bztype=$p(INDISInfo,"^",1)
		..q:(QType'="")&(QType'=bztype)
		..s bzbm=$p(INDISInfo,"^",2)
		..s bzmc=$p(INDISInfo,"^",3)
		..d Build
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build
	;+20230209 HanZH 医保类型描述新增用于诊断修改弹窗显示
	s HiType=bztype

	;+2019-7-30 tangzf 医院授权判断 start
	s TmpHospital=$p(INDISInfo,"^",25)
	q:(GroupHospDr'=TmpHospital) ; 该院区无权查看该数据
	;+201Ver9-7-30 tangzf 医院授权判断 end
	s HisVerDesc=""
    s HisVer=$p(INDISInfo,"^",23) 
	q:(QHisVer'="")&(QHisVer'=HisVer)	;版本号过滤 +HanZH 20230208
	i HisVer'=""  d
	.s DictStr=##class(web.DHCINSUPortUse).GetDictInfoByCode(HisVer) 
	.s HisVerDesc=$p(DictStr,"^",4)	  ;版本号描述
	
	s srrj=$p(INDISInfo,"^",4)
	s srrj2=$p(INDISInfo,"^",5)
	s jcbzbz=$p(INDISInfo,"^",6)
	s Cate=$p(INDISInfo,"^",7)
	s SubCate=$p(INDISInfo,"^",8)
	s Date=$p(INDISInfo,"^",9)
	;s:Date'="" Date=$zd(Date,3)
	s:Date'="" Date=##class(websys.Conversions).DateLogicalToHtml(Date)	;Zhan 20170313
	s Time=$p(INDISInfo,"^",10)
	;s:Time'="" Time=$zt(Time,1)
	s:Time'="" Time=##class(websys.Conversions).TimeLogicalToHtml(Time)
	s UserDr=$p(INDISInfo,"^",11)
	i UserDr'="" d
	.s:$d(^SSU("SSUSR",UserDr)) UserDr=$p(^SSU("SSUSR",UserDr),"^",2)
	s ADDIP=$p(INDISInfo,"^",12)
	s ActiveDate=$p(INDISInfo,"^",13)
	;s:ActiveDate'="" ActiveDate=$zd(ActiveDate,3)
	s:ActiveDate'="" ActiveDate=##class(websys.Conversions).DateLogicalToHtml(ActiveDate)
	s Unique=$p(INDISInfo,"^",14)
	s XString01=$p(INDISInfo,"^",15)
	s XString02=$p(INDISInfo,"^",16)
	s XString03=$p(INDISInfo,"^",17)
	s XString04=$p(INDISInfo,"^",18)
	s XString05=$p(INDISInfo,"^",19)
	s XString06=$p(INDISInfo,"^",20)
	s XString07=$p(INDISInfo,"^",21)
	s XString08=$p(INDISInfo,"^",22)
	
	//s XString10=$p(INDISInfo,"^",24)
	s ExpiryDate=$p(INDISInfo,"^",24)	;upt 20221019 HanZH
	s:ExpiryDate'="" ExpiryDate=##class(websys.Conversions).DateLogicalToHtml(ExpiryDate)
	s:bztype'="" bztype=##class(web.INSUDicDataCom).GetDicByCodeAndInd("TariType",bztype,4,HospDr)
	//set Data=$lb(INDISRowid,bztype,bzbm,bzmc,srrj,srrj2,jcbzbz,Cate,SubCate,Date,Time,UserDr,ADDIP,ActiveDate,Unique,XString01,XString02,XString03,XString04,XString05,XString06,XString07,XString08,XString09,XString10)
	set Data=$lb(INDISRowid,bztype,bzbm,bzmc,srrj,srrj2,jcbzbz,Cate,SubCate,Date,Time,UserDr,ADDIP,ActiveDate,Unique,XString01,XString02,XString03,XString04,XString05,XString06,XString07,XString08,HisVer,ExpiryDate,HospDr,HiType,HisVerDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryDiagnosisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDiagnosisExecute ]
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

Query QueryDiagnosis(QType As %String, QKWords As %String, HospDr = "", QHisVer As %String = "") As %Query(ROWSPEC = "INDISRowid:%String,bztype:%String,bzbm:%String,bzmc:%String,srrj:%String,srrjwb:%String,jcbzbz:%String,Cate:%String,SubCate:%String,Date:%String,Time:%String,UserDr:%String,ADDIP:%String,ActiveDate:%String,Unique:%String,XString01:%String,XString02:%String,XString03:%String,XString04:%String,XString05:%String,XString06:%String,XString07:%String,XString08:%String,HisVer:%String,ExpiryDate:%String,HospDr:%String,HiType:%String,HisVerDesc:%String")
{
}

Query QueryDiagnosInfo(ExpStr) As websys.Query(ROWSPEC = "Rowid,HisdigCode,HisICDCode,HisICDDesc,HisNote,ConId,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser,AutoConFlag,ReCheckFlag,ReCheckUser,ReCheckDate,HisVer,InsuVer,tHisVerDesc,tInsuVerDesc")
{
}

/// d ##class(%ResultSet).RunQuery("web.INSUDiagnosis","QueryDiagnosInfo","00A@@1@A@2@@@")
/// 查询诊断数据 Query
ClassMethod QueryDiagnosInfoExecute(ByRef qHandle As %Binary, ExpStr As %String) As %Status
{
	s (Rowid,HisdigCode,HisICDCode,HisICDDesc,HisNote,ConId,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser,AutoConFlag,ReCheckFlag,ReCheckUser,ReCheckDate,tHisVer,tInsuVer)=""
	s ^temp("QueryDiagnosInfo20230209")=ExpStr
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s ^TMPZMC(454)=ExpStr
	s insutype=$p(ExpStr,"@",1)
	s sKeyWord=$p(ExpStr,"@",2)
	s qClass=$p(ExpStr,"@",3)
	s ConType=$p(ExpStr,"@",4)    //根据对照类型查询
	s HospDr=$p(ExpStr,"@",5)     // tangzf 2020-5-27 add 最小院区(未分组)
	s Valid=$p(ExpStr,"@",6)       // 有效 无效标识 (Y\N) DingSH 20210727
	s DateAct=$p(ExpStr,"@",7)    //  有效日期 DingSH 20210727
	s HisVer=$p(ExpStr,"@",8)     //院内版本号  HanZH 20230209
	s:(HospDr="")&&(%session'="") HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital")) 
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_Diagnosis",HospDr)
	s:qClass="" qClass=1
	s DateAct=##class(websys.Conversions).DateHtmlToLogical(DateAct)
	s:DateAct="" DateAct=+$H
	//$$ALPHAUP^SSUTIL4
	//s:sKeyWord'="" sKeyWord=$ZCVT(sKeyWord,"U")
	s KeyWord=""
	s:sKeyWord'="" KeyWord=$$ALPHAUP^SSUTIL4(sKeyWord)
	s INSUDIid="0"
	i sKeyWord="" d
	.f  s INSUDIid=$o(^MRC("ID",INSUDIid)) q:INSUDIid=""  d
	..d BuildgQuery
	e  d
	.i qClass=1 d
	..s tmpdesc=$e(KeyWord,1,$l(KeyWord)-1)
	..f  s tmpdesc=$o(^MRC("ID",0,"ALIAS",tmpdesc)) q:tmpdesc=""  d
	...q:tmpdesc'[KeyWord
	...s INSUDIid=0
	...f  s INSUDIid=$o(^MRC("ID",0,"ALIAS",tmpdesc,INSUDIid)) q:INSUDIid=""  d
	....d BuildgQuery
	.i qClass=2 d
	..s tmpdesc=$e(sKeyWord,1,$l(sKeyWord)-1) 
	..f  s tmpdesc=$o(^MRC("ID",0,"ICD",tmpdesc)) q:tmpdesc=""  d
	...q:tmpdesc'[sKeyWord
	...s INSUDIid=0
	...f  s INSUDIid=$o(^MRC("ID",0,"ICD",tmpdesc,INSUDIid)) q:INSUDIid=""  d
	....d BuildgQuery
	.i qClass=3 d
	..s tmpdesc=$e(KeyWord,1,$l(KeyWord)-1)
	..f  s tmpdesc=$o(^MRC("ID",0,"Desc",tmpdesc)) q:tmpdesc=""  d
	...q:tmpdesc'[KeyWord
	...s INSUDIid=0
	...f  s INSUDIid=$o(^MRC("ID",0,"Desc",tmpdesc,INSUDIid)) q:INSUDIid=""  d
	....d BuildgQuery
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
BuildgQuery
	;12644^CZZG^E89.4^操作后卵巢功能衰竭^CZHLCGNSJ^^^^^2013-01-27^16:42:10^^^2013-01-27^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	s Downinfo=$g(^MRC("ID",INSUDIid))
	;+2019-7-30 tangzf 医院授权判断 start
	s CheckHosipitalSession=##class(web.DHCBILLINSUCloudCommon).CheckDataSession("MRC_ICDDx",INSUDIid,HospDr,"","Y")
	q:(CheckHosipitalSession'="Y") ; 该院区无权查看该数据
	
	s tValid=$P(Downinfo,"^",27)
	q:(Valid'="")&&(tValid'=Valid)

	;+院内版本号过滤 20230209 HanZH
	s tHisVerDr=$P(Downinfo,"^",56)
	s tHisVer=$p(##class(web.DHCINSUPortUse).GetDictInfoByRowId(tHisVerDr),"^",2) 
	b ;000
	q:(HisVer'="")&(tHisVer'=HisVer)	//院内版本号过滤
	
	s tHisVerDesc=""
	i tHisVer'="" d
	.s DictStr=##class(web.DHCINSUPortUse).GetDictInfoByCode(tHisVer)
	.s tHisVerDesc=$p(DictStr,"^",4)			 //院内版本号名称

	s tDateActFrom=$P(Downinfo,"^",6)
	s tDateActTo=$P(Downinfo,"^",7)
	q:((DateAct<tDateActFrom)||((tDateActTo'="")&&(DateAct>tDateActTo)))
	b ;002
	;+2019-7-30 tangzf 医院授权判断 end
	s Rowid=INSUDIid	//Rowid
	s HisdigCode=$p(Downinfo,"^",1)	//HIS诊断代码
	s HisICDCode=$p(Downinfo,"^",4)	//HISICD诊断代码
	s HisICDDesc=$p(Downinfo,"^",2)	//HISICD诊断名称
	s HisNote=$p(Downinfo,"^",36)	//备注
	s (ConId,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser)=""
	s ConString=$$CheckCon^DHCINSUICDContrast(INSUDIid,insutype,+$H,HospDr)
	s ^TMPZMC(555)=INSUDIid_"_"_insutype_"_"_ConString
	s ConId=$p(ConString,"!",2)	//对照ID
	b ;003
	q:(ConType="Y")&(ConId="")   //查询已对照的诊断
	b ;004
	q:(ConType="N")&(ConId'="")	//查询未对照的诊断
	b ;005
	s (AutoConFlag,ReCheckFlag,ReCheckUser,ReCheckDate)=""
	i ConId'="" d
	.s conStr=$g(^DHCINICT(ConId))
	.s INSUdigDr=$p(conStr,"^",4)
	.i INSUdigDr'="" d 
	..s ConUserDr=+$p(conStr,"^",9)
	..s UserStr="^^^^^^^^^^^^"
	..s:$d(^SSU("SSUSR",ConUserDr)) UserStr=^SSU("SSUSR",ConUserDr)	;Zhan 20160505
	..s OutStr=$$GetInfoById^DHCINSUDiagnosis(INSUdigDr)
	..i $l(OutStr,"^")>4 d
	...s:ConUserDr'="" UserStr=$$GetUserStr^DHCINSUBase(ConUserDr)
	...s INSUDigCode=$p(OutStr,"^",3)		//医保ICD
	...s INSUDigDesc=$p(OutStr,"^",4)	//医保ICD名称
	...s tInsuVer=$p(OutStr,"^",24)     //医保版本号 20230209 HanZH
	...s tInsuVerDesc=""
	...i tInsuVer'="" d
	....s DictStr=##class(web.DHCINSUPortUse).GetDictInfoByCode(tInsuVer)
	....s tInsuVerDesc=$p(DictStr,"^",4)			 //医保版本号名称
	
	...s ConActDate=$p(conStr,"^",8)	//生效日期
	...;s:ConActDate'="" ConActDate=$zd(ConActDate,3)
	...s:ConActDate'="" ConActDate=##class(websys.Conversions).DateLogicalToHtml(ConActDate)
	...s ConExpDate=""	;$zd(+$h+3650,3)	//失效日期
	...s ConUser=$p(UserStr,"^",2)	//操作员,Zhan 20160505,11->2
	...s AutoConFlag=$p(conStr,"^",15)	//add xubaobao 2018 01 31
	...s:AutoConFlag="1" AutoConFlag="是"
	...s ReCheckFlag=+$p(conStr,"^",16)	
	...s:ReCheckFlag="1" ReCheckFlag="审核通过"
	...s:ReCheckFlag="2" ReCheckFlag="审核拒绝"
	...s:ReCheckFlag="0" ReCheckFlag=""
	...s ReCheckUser=""
	...s ReCheckUserDr=$p(conStr,"^",17)
	...s:ReCheckUserDr'="" ReCheckUser=$p($$GetUserStr^DHCINSUBase(ReCheckUserDr),"^",2)	
	...s ReCheckDate=$p(conStr,"^",18)
	
	...;s:ReCheckDate'="" ReCheckDate=$zd(ReCheckDate,3)
	d BuildGaQuery
	q
	
BuildGaQuery
	i ReCheckDate'="" d
 	.s ReCheckDate=##class(websys.Conversions).DateLogicalToHtml(ReCheckDate)
 	.i $l(ReCheckDate)>11 d
 	..s tmpReCheckDate=$p(ReCheckDate," ",1)
 	..s tmpReCheckDate=##class(websys.Conversions).DateHtmlToLogical(tmpReCheckDate)
 	..s tmpReChecktime=$p(ReCheckDate," ",2)
 	..s tmpReChecktime=##class(websys.Conversions).TimeHtmlToLogical(tmpReChecktime)
 	..s ReCheckDate=##class(websys.Conversions).DateLogicalToHtml(tmpReCheckDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(tmpReChecktime)
	
	set Data=$lb(Rowid,HisdigCode,HisICDCode,HisICDDesc,HisNote,ConId,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser,AutoConFlag,ReCheckFlag,ReCheckUser,ReCheckDate,tHisVer,tInsuVer,tHisVerDesc,tInsuVerDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 查询诊断数据 classmethod
ClassMethod DiagnosInfoQuery(ROOTID As %String, ExpStr As %String) As %Library.String
{
	s (Rowid,HisdigCode,HisICDCode,HisICDDesc,HisNote,ConId,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser,AutoConFlag,ReCheckFlag,ReCheckUser,ReCheckDate)=""
	s j=0
	k ^CacheTemp("INSUINFO",ROOTID)
	s ^TMPZMC(454)=ExpStr
	s insutype=$p(ExpStr,"^",1)
	s sKeyWord=$p(ExpStr,"^",2)
	s qClass=$p(ExpStr,"^",3)
	s ConType=$p(ExpStr,"^",4)   //根据对照类型查询
	s HospDr=$p(ExpStr,"^",5) // tangzf 2020-5-27 add 最小院区(未分组)
	s:(HospDr="")&&(%session'="") HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital")) 
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_Diagnosis",HospDr)
	s:qClass="" qClass=1
	//$$ALPHAUP^SSUTIL4
	//s:sKeyWord'="" sKeyWord=$ZCVT(sKeyWord,"U")
	s:sKeyWord'="" sKeyWord=$$ALPHAUP^SSUTIL4(sKeyWord)
	s INSUDIid="0"
	i sKeyWord="" d
	.f  s INSUDIid=$o(^MRC("ID",INSUDIid)) q:INSUDIid=""  d
	..d Buildg
	e  d
	.i qClass=1 d
	..s tmpdesc=$e(sKeyWord,1,$l(sKeyWord)-1)
	..f  s tmpdesc=$o(^MRC("ID",0,"ALIAS",tmpdesc)) q:tmpdesc=""  d
	...q:tmpdesc'[sKeyWord
	...s INSUDIid=0
	...f  s INSUDIid=$o(^MRC("ID",0,"ALIAS",tmpdesc,INSUDIid)) q:INSUDIid=""  d
	....d Buildg
	.i qClass=2 d
	..s tmpdesc=$e(sKeyWord,1,$l(sKeyWord)-1)
	..f  s tmpdesc=$o(^MRC("ID",0,"Code",tmpdesc)) q:tmpdesc=""  d
	...q:tmpdesc'[sKeyWord
	...s INSUDIid=0
	...f  s INSUDIid=$o(^MRC("ID",0,"Code",tmpdesc,INSUDIid)) q:INSUDIid=""  d
	....d Buildg
	.i qClass=3 d
	..s tmpdesc=$e(sKeyWord,1,$l(sKeyWord)-1)
	..f  s tmpdesc=$o(^MRC("ID",0,"Desc",tmpdesc)) q:tmpdesc=""  d
	...q:tmpdesc'[sKeyWord
	...s INSUDIid=0
	...f  s INSUDIid=$o(^MRC("ID",0,"Desc",tmpdesc,INSUDIid)) q:INSUDIid=""  d
	....d Buildg
	q j
	
Buildg
	;12644^CZZG^E89.4^操作后卵巢功能衰竭^CZHLCGNSJ^^^^^2013-01-27^16:42:10^^^2013-01-27^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	s Downinfo=^MRC("ID",INSUDIid)
	;+2019-7-30 tangzf 医院授权判断 start
	s CheckHosipitalSession=##class(web.DHCBILLINSUCloudCommon).CheckDataSession("MRC_ICDDx",INSUDIid,HospDr,"","Y")
	q:(CheckHosipitalSession'="Y") ; 该院区无权查看该数据
	;+2019-7-30 tangzf 医院授权判断 end
	s Rowid=INSUDIid	//Rowid
	s HisdigCode=$p(Downinfo,"^",1)	//HIS诊断代码
	s HisICDCode=$p(Downinfo,"^",4)	//HISICD诊断代码
	s HisICDDesc=$p(Downinfo,"^",2)	//HISICD诊断名称
	s HisNote=$p(Downinfo,"^",36)	//备注
	s (ConId,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser)=""
	s ConString=$$CheckCon^DHCINSUICDContrast(INSUDIid,insutype,"",HospDr)
	s ^TMPZMC(555)=INSUDIid_"_"_insutype_"_"_ConString
	s ConId=$p(ConString,"!",2)	//对照ID
	q:(ConType="Y")&(ConId="")   //查询已对照的诊断
	q:(ConType="N")&(ConId'="")	//查询未对照的诊断
	s (AutoConFlag,ReCheckFlag,ReCheckUser,ReCheckDate)=""
	i ConId'="" d
	.s conStr=$g(^DHCINICT(ConId))
	.s INSUdigDr=$p(conStr,"^",4)
	.i INSUdigDr'="" d 
	..s ConUserDr=+$p(conStr,"^",9)
	..s UserStr="^^^^^^^^^^^^"
	..s:$d(^SSU("SSUSR",ConUserDr)) UserStr=^SSU("SSUSR",ConUserDr)	;Zhan 20160505
	..s OutStr=$$GetInfoById^DHCINSUDiagnosis(INSUdigDr)
	..i $l(OutStr,"^")>4 d
	...s:ConUserDr'="" UserStr=$$GetUserStr^DHCINSUBase(ConUserDr)
	...s INSUDigCode=$p(OutStr,"^",3)		//医保ICD
	...s INSUDigDesc=$p(OutStr,"^",4)	//医保ICD名称
	...s ConActDate=$p(conStr,"^",8)	//生效日期
	...;s:ConActDate'="" ConActDate=$zd(ConActDate,3)
	...s:ConActDate'="" ConActDate=##class(websys.Conversions).DateLogicalToHtml(ConActDate)
	...s ConExpDate=""	;$zd(+$h+3650,3)	//失效日期
	...s ConUser=$p(UserStr,"^",2)	//操作员,Zhan 20160505,11->2
	...s AutoConFlag=$p(conStr,"^",15)	//add xubaobao 2018 01 31
	...s:AutoConFlag="1" AutoConFlag="是"
	...s ReCheckFlag=+$p(conStr,"^",16)	
	...s:ReCheckFlag="1" ReCheckFlag="审核通过"
	...s:ReCheckFlag="2" ReCheckFlag="审核拒绝"
	...s:ReCheckFlag="0" ReCheckFlag=""
	...s ReCheckUser=""
	...s ReCheckUserDr=$p(conStr,"^",17)
	...s:ReCheckUserDr'="" ReCheckUser=$p($$GetUserStr^DHCINSUBase(ReCheckUserDr),"^",2)	
	...s ReCheckDate=$p(conStr,"^",18)
	
	...;s:ReCheckDate'="" ReCheckDate=$zd(ReCheckDate,3)
	d BuildGa
	q
	
BuildGa

	i j=0 d
	.s ^CacheTemp("INSUINFOTitle",ROOTID)="Rowid^HisdigCode^HisICDCode^HisICDDesc^HisNote^ConID^INSUdigDr^INSUDigCode^INSUDigDesc^ConActDate^ConExpDate^ConUser^AutoConFlag^ReCheckFlag^ReCheckUser^ReCheckDate"
 	i ReCheckDate'="" d
 	.s ReCheckDate=##class(websys.Conversions).DateLogicalToHtml(ReCheckDate)
 	.i $l(ReCheckDate)>11 d
 	..s tmpReCheckDate=$p(ReCheckDate," ",1)
 	..s tmpReCheckDate=##class(websys.Conversions).DateHtmlToLogical(tmpReCheckDate)
 	..s tmpReChecktime=$p(ReCheckDate," ",2)
 	..s tmpReChecktime=##class(websys.Conversions).TimeHtmlToLogical(tmpReChecktime)
 	..s ReCheckDate=##class(websys.Conversions).DateLogicalToHtml(tmpReCheckDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(tmpReChecktime)
 	s tmpdata=Rowid_"^"_HisdigCode_"^"_HisICDCode_"^"_HisICDDesc_"^"_HisNote_"^"_ConId_"^"_INSUdigDr_"^"_INSUDigCode_"^"_INSUDigDesc_"^"_ConActDate_"^"_ConExpDate_"^"_ConUser_"^"_AutoConFlag_"^"_ReCheckFlag_"^"_ReCheckUser_"^"_ReCheckDate    //add xubaobao 2018 02 02
 	s ^CacheTemp("INSUINFO",ROOTID,j)=tmpdata
 	s j=j+1
 	q
}

Query QueryDiagnosCon(ExpStr As %String, HospDr = "", HisVer = "") As websys.Query(ROWSPEC = "Rowid,HisdigCode,HisICDCode,HisICDDesc,HisNote,ConId,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser,tHisVer,tInsuVer,tHisVerDesc,tInsuVerDesc")
{
}

/// 查询诊断对照数据 Query
/// d ##class(%ResultSet).RunQuery("web.INSUDiagnosis","QueryDiagnosCon","ZZB@10@",2)
ClassMethod QueryDiagnosConExecute(ByRef qHandle As %Binary, ExpStr As %String, HospDr = "", HisVer = "") As %Status
{
	s (Rowid,HisdigCode,HisICDCode,HisICDDesc,HisNote,ConId,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser)=""
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s insutype=$p($G(ExpStr),"@",1)
	s INSUDIid=$p($G(ExpStr),"@",2)
	s ActDate=$p($G(ExpStr),"@",3)
	s:ActDate'="" ActDate=##class(websys.Conversions).DateHtmlToLogical(ActDate)	
	s:ActDate="" ActDate=+$h
	if INSUDIid="" Set qHandle=$lb(0,repid,0) quit $$$OK
	s:(HospDr="")&&(%session'="") HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital")) 
	s ^CacheTemp("DiagnosConQuery")=$lb( ExpStr , HospDr)
	s ConString=$$CheckCon^DHCINSUICDContrast(INSUDIid,insutype,ActDate,HospDr)
	b ;000
	f index=2:1:$l(ConString,"!") d
	.s ConId=$p(ConString,"!",index)	//对照ID
	.s (Rowid,HisdigCode,HisICDCode,HisICDDesc,HisNote,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser)=""
	.i ConId'="" d
	..s conStr=$g(^DHCINICT(ConId))
	
	..s hisdigdr=$p(conStr,"^",1)
	..s Downinfo=^MRC("ID",hisdigdr)
	..s Rowid=INSUDIid	//Rowid
	..s HisdigCode=$p(Downinfo,"^",1)	//HIS诊断代码
	..s HisICDCode=$p(Downinfo,"^",4)	//HISICD诊断代码
	..s HisICDDesc=$p(Downinfo,"^",2)	//HISICD诊断名称

	..;院内版本号过滤	+20230210 HanZH
	..s tHisVer=$p(Downinfo,"^",56)
	..s tHisVer=$p(##class(web.DHCINSUPortUse).GetDictInfoByRowId(tHisVer),"^",2)
	..q:(HisVer'="")&(HisVer'=tHisVer)	
	..s tHisVerDesc=""
	..i tHisVer'="" d
	...s DictStr=##class(web.DHCINSUPortUse).GetDictInfoByCode(tHisVer)
	...s tHisVerDesc=$p(DictStr,"^",4)			 //院内版本号名称

	..s HisNote=$p(conStr,"^",14)	//备注 修改 DingSH 20170303
	..s INSUdigDr=$p(conStr,"^",4)
	..i INSUdigDr'="" d 
	...s ConUserDr=$p(conStr,"^",9)
	...s UserStr="^^^^^^^^^^^^"
	...s OutStr=$$GetInfoById^DHCINSUDiagnosis(INSUdigDr)
	...i $l(OutStr,"^")>4 d
	....s:ConUserDr'="" UserStr=$$GetUserStr^DHCINSUBase(ConUserDr)
	....s INSUDigCode=$p(OutStr,"^",3)		//医保ICD
	....s INSUDigDesc=$p(OutStr,"^",4)	//医保ICD名称
	....s tInsuVer=$p(OutStr,"^",24)	//医保诊断院内版本号 +20230210 HanZH
	....s tInsuVerDesc=""
	....i tInsuVer'="" d
	.....s DictStr=##class(web.DHCINSUPortUse).GetDictInfoByCode(tInsuVer)
	.....s tInsuVerDesc=$p(DictStr,"^",4)			 //院内版本号名称
	....s ConActDate=$p(conStr,"^",8)	//生效日期
	....;s:ConActDate'="" ConActDate=$zd(ConActDate,3)
	....s:ConActDate'="" ConActDate=##class(websys.Conversions).DateLogicalToHtml(ConActDate)
	....s ConExpDate=""	;$zd(+$h+3650,3)	//失效日期
	....s ConUser=$p(UserStr,"^",2)	//操作员
	.d BuildconQuery
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
BuildconQuery
 	set Data=$lb(Rowid,HisdigCode,HisICDCode,HisICDDesc,HisNote,ConId,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser,tHisVer,tInsuVer,tHisVerDesc,tInsuVerDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 查询诊断对照数据 classmethod
ClassMethod DiagnosConQuery(ROOTID As %String, ExpStr As %String, HospDr = "") As %Library.String
{
	
	s (Rowid,HisdigCode,HisICDCode,HisICDDesc,HisNote,ConId,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser)=""
	s j=0
	k ^CacheTemp("INSUINFO",ROOTID)
	s insutype=$p(ExpStr,"^",1)
	s INSUDIid=$p(ExpStr,"^",2)
	s:(HospDr="")&&(%session'="") HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital")) 
	s ^CacheTemp("DiagnosConQuery")=$lb(ROOTID, ExpStr , HospDr)
	s ConString=$$CheckCon^DHCINSUICDContrast(INSUDIid,insutype,"",HospDr)
	f ind=2:1:$l(ConString,"!") d
	.s ConId=$p(ConString,"!",ind)	//对照ID
	.s (Rowid,HisdigCode,HisICDCode,HisICDDesc,HisNote,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser)=""
	.i ConId'="" d
	..s conStr=$g(^DHCINICT(ConId))
	
	..s hisdigdr=$p(conStr,"^",1)
	..s Downinfo=^MRC("ID",hisdigdr)
	..s Rowid=INSUDIid	//Rowid
	..s HisdigCode=$p(Downinfo,"^",1)	//HIS诊断代码
	..s HisICDCode=$p(Downinfo,"^",4)	//HISICD诊断代码
	..s HisICDDesc=$p(Downinfo,"^",2)	//HISICD诊断名称
	..s HisNote=$p(conStr,"^",14)	//备注 修改 DingSH 20170303
	..s INSUdigDr=$p(conStr,"^",4)
	..i INSUdigDr'="" d 
	...s ConUserDr=$p(conStr,"^",9)
	...s UserStr="^^^^^^^^^^^^"
	...s OutStr=$$GetInfoById^DHCINSUDiagnosis(INSUdigDr)
	...i $l(OutStr,"^")>4 d
	....s:ConUserDr'="" UserStr=$$GetUserStr^DHCINSUBase(ConUserDr)
	....s INSUDigCode=$p(OutStr,"^",3)		//医保ICD
	....s INSUDigDesc=$p(OutStr,"^",4)	//医保ICD名称
	....s ConActDate=$p(conStr,"^",8)	//生效日期
	....;s:ConActDate'="" ConActDate=$zd(ConActDate,3)
	....s:ConActDate'="" ConActDate=##class(websys.Conversions).DateLogicalToHtml(ConActDate)
	....s ConExpDate=""	;$zd(+$h+3650,3)	//失效日期
	....s ConUser=$p(UserStr,"^",2)	//操作员
	.d Buildcon
	q j
	
Buildcon
	i j=0 d
	.s ^CacheTemp("INSUINFOTitle",ROOTID)="Rowidcon^HisdigCodecon^HisICDCodecon^HisICDDesccon^HisNotecon^ConIDcon^INSUdigDrcon^INSUDigCodecon^INSUDigDesccon^begindatecon^Expdatecon^ConUsercon"
	s tmpdata=Rowid_"^"_HisdigCode_"^"_HisICDCode_"^"_HisICDDesc_"^"_HisNote_"^"_ConId_"^"_INSUdigDr_"^"_INSUDigCode_"^"_INSUDigDesc_"^"_ConActDate_"^"_ConExpDate_"^"_ConUser
 	s ^CacheTemp("INSUINFO",ROOTID,j)=tmpdata
 	s j=j+1
 	q
}

/// 医保诊断第26位=院区Id tangzf 2020-3-19
/// w ##class(web.INSUDiagnosis).SaveDiag("33326^00A^A00.000^霍乱，由于O1群霍乱弧菌，霍乱生物型所致^HL，YYO1QHLHJ，HLSWXSZ^^^测试1^^^^1^192.168.1.62^2022-04-06^^^^^^^^^^8.5^^2") 
/// w ##class(web.INSUDiagnosis).SaveDiag("^00A^D43.000x006^大脑交界性肿瘤^DNJJXZL^^^^^^^1^192.168.1.69^2023-05-09^^^^^^^^^^ZDYBB2.0^^") 
/// 33326^00A^A00.000^霍乱，由于O1群霍乱弧菌，霍乱生物型所致^HL，YYO1QHLHJ，HLSWXSZ^^^测试^^^^1^192.168.1.62^2022-04-06^^^^^^^^^^8.5^^2 
///    1^国家医保^A00.000^霍乱，由于O1群霍乱弧菌，霍乱生物型所致^HL，YYO1QHLHJ，HLSWXSZ^^^测试^^^^1^192.168.1.62^2022-04-06^^^^^^^^^^8.5^^2
ClassMethod SaveDiag(Args As %String) As %String
{
	s ^temp("SaveDiag20230524")=Args
	s RtnStr=""
	s:($p(Args,"^",26)="")&&($g(%session)'="") $p(Args,"^",26)=$g(%session.Data("DHCBILLINSUCloud.Hospital")) // tangzf 2019-8-2
	q:$p(Args,"^",24)="" "-1!院内版本号为空" 	//医保诊断导入版本号必填为控制处理	+20230518 HanZH 
	s RtnStr=$$Save^DHCINSUDiagnosis(Args)

	//+20230117 HanZH 同步推送编码字典信息到病案
	if (+RtnStr>0) {
		s Args=..GetDiagnosisById(+RtnStr)
 		s sendRtn=##class(web.DHCINSUPortUse).SendICDInfo(Args,"diag")
		q:+sendRtn<0 sendRtn
	}
	q +RtnStr
}

/// w ##class(web.INSUDiagnosis).GetICDConInfo("7090","","00A","2","","")
ClassMethod GetICDConInfo(ICDID As %String, ICDCode As %String, INSUType As %String, HospDr As %String = "", ActDate As %String = "", langId As %String = "") As %String
{
	n (ICDID, ICDCode, INSUType, HospDr, ActDate, langId)
	s RtnStr=""
	
	i ((ICDID="")&&(ICDCode'="")) d
	.q:$d(^MRC("ID",0,"Code",ICDCode))=0
	.s id=""
	.f  s id=$o(^MRC("ID",0,"Code",ICDCode,id))  q:(id="")   d
	..;s mCorrRec=$g(^MRC("ID",id))
	..s ICDID=id
	s:(HospDr="")&&($d(%session)) HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital")) 
	q:ICDID="" RtnStr
	s ConString=$$CheckCon^DHCINSUICDContrast(ICDID,INSUType,ActDate,HospDr)
	b ;01
	q:ConString RtnStr
	b ;02
	s ConId=$p(ConString,"!",2)
	q:ConId="" RtnStr
	s conStr=$g(^DHCINICT(ConId))
	s InsuDr=$p(conStr,"^",4)
	q:InsuDr="" RtnStr
	s RtnStr=$$GetInfoById^DHCINSUDiagnosis(InsuDr,langId)
	q RtnStr
}

/// add xubaobao 2016 11 08
/// 通过医保类型、HIS诊断id获取医保诊断自动对照标识
/// 入参：HisDiagDr   HIS诊断id
///       InsuType    医保类型
/// 出参："-1"：失败     
/// w ##class(web.INSUDiagnosis).GetDiagAutoConFlagByDr("71564","XAA")
ClassMethod GetDiagAutoConFlagByDr(ICDConID As %String) As %String
{
	n (ICDConID)
	//^DHCINICT("0","MRCICDID",HisDiagDr,ID)
	s AutoConFlag=""
	q:(ICDConID="") "-1"
	s AutoConFlag=$p(^DHCINICT(ICDConID),"^",15)   //自动对照标识
	q AutoConFlag
}

/// add xubaobao 2016 11 08
/// 通过诊断对照表ID更新审核状态，审核人，审核时间
/// 入参：ICDConID   诊断对照表ID
///       CheckUserDr    审核人
///       CheckFlag      审核标识 
/// w ##class(web.INSUDiagnosis).GetDiagAutoConFlagByDr("71564","XAA")
ClassMethod UpDateCheckUser(ICDConID As %String, CheckUserDr As %String, CheckFlag As %String) As %Library.String
{
	n (ICDConID,CheckUserDr,CheckFlag)	
	//s Date=$zd(+$h,3)
	s Date=$zd($p($h,",",1),3)
	s Time=$zt($p($h,",",2),1)
	s Update=Date_" "_Time
	&sql(update INSU_ICDContrast set INICT_XString03=:CheckFlag, INICT_XString04 =:CheckUserDr,INICT_XString05=:Update where INICT_Rowid=:ICDConID)
	q SQLCODE
}

/// 导入医保诊断对照
/// add Hanzh 2021-10-14
/// w ##class(web.INSUDiagnosis).SaveInContNew("^^J06.900x003^上呼吸道感染^^J06.900^急性上呼吸道感染^BHA^2021-10-14^1^^^^^^^^^^2") 
/// w ##class(web.INSUDiagnosis).SaveInContNew("^^A00.000^霍乱，由于O1群霍乱弧菌，霍乱生物型所致^^A00.000^霍乱，由于O1群霍乱弧菌，霍乱生物型所致^00A^2021-11-01^1^^^^^^^^^^2")
ClassMethod SaveInContNew(Args As %String) As %String
{
	s ^Temp("Args")=Args
	s RtnStr=""
	q:$p(Args,"^",21)="" "-1!院内版本号为空"	//医保诊断对照版本号必填控制	+20230518 HanZH 
	q:$p(Args,"^",22)="" "-1!医保版本号为空"	//医保诊断对照版本号必填控制	+20230518 HanZH 
	s RtnStr=$$SaveInContNew^DHCINSUICDContrast(Args)
	//+20230215 HanZH 推送对照信息到病案
	i (+RtnStr>0)&($l(Args,"^")>20) {
		s $p(Args,"^",1) = +RtnStr
 		s sendRtn=##class(web.DHCINSUPortUse).SendICDMapInfo(Args,"diag")
		q:+sendRtn<0 sendRtn
	}
	q RtnStr
}

/// w ##class(web.INSUDiagnosis).GetDiagnosisForNet("00ASYDBZ","ZG","","",2)
ClassMethod GetDiagnosisForNet(QType As %String, QKWords As %String, Cate As %String, SubCate As %String, HospDr As %String) As %String
{
	q:(QKWords="")!(QType="")!(HospDr="") "0!-1"
	Set repid=$I(^CacheTemp(0,"InsuDiag"))
	k ^CacheTemp(0,"InsuDiag",repid)
	s ^TEMP("DingSH")=QType_","_QKWords_","_HospDr
	
	
	
	s:(HospDr="")&&($g(%session)'="") HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital")) 
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_Diagnosis",HospDr)
	
	s ind=1
	;s aliQWord=##class(web.DHCINSUPort).GetCNCODE(QKWords,4,"")
	s aliQWord=$$ALPHAUP^SSUTIL4(QKWords)
	b ;0
	s INDISbzmc=""
	f  s INDISbzmc=$o(^DHCINDiagnos("0","Alias",INDISbzmc))	q:INDISbzmc=""  d
	.q:(INDISbzmc'[aliQWord)&(aliQWord'="")
	.s INDISRowid=""
	.f  s INDISRowid=$o(^DHCINDiagnos("0","Alias",INDISbzmc,INDISRowid))  q:INDISRowid=""  d
	..s INDISInfo=$g(^DHCINDiagnos(INDISRowid))
	..s tHospDr=$p(INDISInfo,"^",25)
	..q:GroupHospDr'=tHospDr
	..s bzxmbm=$p(INDISInfo,"^",1)
	..q:QType'=bzxmbm
	..s tCate=$p(INDISInfo,"^",7)
	..q:(Cate'="")&&(tCate'=Cate)
	..s tSubCate=$p(INDISInfo,"^",8)
	..q:(SubCate'="")&&(tSubCate'=SubCate)
	..s bzbm=$p(INDISInfo,"^",2)
	..s bzmc=$p(INDISInfo,"^",3)
	..d BuildForNet
    
	q (ind-1)_"!"_repid
	
BuildForNet
	s srrj=$p(INDISInfo,"^",4)
	s srrj2=$p(INDISInfo,"^",5)
	s jcbzbz=$p(INDISInfo,"^",6)
	s Cate=$p(INDISInfo,"^",7)
	s SubCate=$p(INDISInfo,"^",8)
	s Date=$p(INDISInfo,"^",9)
	s:Date'="" Date=$zd(Date,3)
	s Time=$p(INDISInfo,"^",10)
	s:Time'="" Time=$zt(Time,1)
	s UserDr=$p(INDISInfo,"^",11)
	i UserDr'="" d
	.s:$d(^SSU("SSUSR",UserDr)) UserDr=$p(^SSU("SSUSR",UserDr),"^",2)
	s ADDIP=$p(INDISInfo,"^",12)
	s ActiveDate=$p(INDISInfo,"^",13)
	s:ActiveDate'="" ActiveDate=$zd(ActiveDate,3)
	s Unique=$p(INDISInfo,"^",14)
	s XString01=$p(INDISInfo,"^",15)
	s XString02=$p(INDISInfo,"^",16)
	s XString03=$p(INDISInfo,"^",17)
	s XString04=$p(INDISInfo,"^",18)
	s XString05=$p(INDISInfo,"^",19)
	s XString06=$p(INDISInfo,"^",20)
	s XString07=$p(INDISInfo,"^",21)
	s XString08=$p(INDISInfo,"^",22)
	s XString09=$p(INDISInfo,"^",23)
	s XString10=$p(INDISInfo,"^",24)
	s THospDr=$p(INDISInfo,"^",25)
 	Set ^CacheTemp(0,"InsuDiag",repid,ind)=bzxmbm_"^"_bzbm_"^"_bzmc_"^"_srrj_"^"_srrj2_"^"_jcbzbz_"^"_Cate_"^"_SubCate_"^"_Date_"^"_Time_"^"_UserDr_"^"_ActiveDate_"^"_ADDIP_"^"_XString01_"^"_XString02_"^"_XString03_"^"_XString04_"^"_XString05_"^"_XString06_"^"_XString07_"^"_XString08_"^"_XString09_"^"_XString10_"^"_THospDr
 	Set ind=ind+1
 	q
}

/// w ##class(web.INSUDiagnosis).GetDiagnosisFromCacheTmp("2",1)
ClassMethod GetDiagnosisFromCacheTmp(ID As %String, index As %String) As %String
{
	 n (ID,index)
     s mCurrRowCacheTemp=""
     s outstr=""
     s mCurrRowCacheTemp=$g(^CacheTemp(0,"InsuDiag",ID ,index))
     s outstr=mCurrRowCacheTemp
     i $o(^CacheTemp(0,"InsuDiag",ID,""),-1)=index d
  	 .k ^CacheTemp(0,"InsuDiag",ID)			
     q outstr
}

/// 按照操作人ID查询名称
/// w ##class(web.INSUDiagnosis).GetMessByOpterId("9")
ClassMethod GetMessByOpterId(OpterId As %String) As %String
{
	 q:OpterId=""
	 s rtn=$p($g(^SSU("SSUSR",OpterId)),"^",2)
	 q rtn
}

/// 根据Rowid获取医保诊断
/// HanZH 2023-02-08 
/// 入参：RowId   医保诊断ID
/// 出参：
/// 	医保诊断信息串
/// w ##class(web.INSUDiagnosis).Ge
/// w ##class(web.INSUDiagnosis).GetDiagnosisById(1)
ClassMethod GetDiagnosisById(RowId) As %String
{
	new SQLCODE
	&sql(Select %ID,* INTO:PLIST() FROM INSU_Diagnosis where INDIS_Rowid=:RowId) 
	if (SQLCODE<0){q "-1^SQLCODE错误"_%msg}
	elseif(SQLCODE=100){q "-1^查询没结果"}
	s ind=1,rtn=""
	while ind'=""
	{
			i rtn="" {
			s rtn=PLIST(ind)
			}
		else{
				s rtn=rtn_"^"_PLIST(ind)
				}
			s ind = $O(PLIST(ind))
	}
	i $P(rtn,"^",10)'="" d
	.s $P(rtn,"^",10)=$zd($P(rtn,"^",10),3)   //更新日期 
	i $P(rtn,"^",11)'="" d
	.s $P(rtn,"^",11)=$zt($P(rtn,"^",11))     //更新时间
	i $P(rtn,"^",14)'="" d
	.s $P(rtn,"^",14)=$zd($P(rtn,"^",14),3)   //生效日期
	i $P(rtn,"^",25)'="" d
	.s $P(rtn,"^",25)=$zd($P(rtn,"^",25),3)   //失效日期
	s UserInfo=""
	s:$P(rtn,"^",12)'="" UserInfo=##class(web.INSUBase).GetUserStr($P(rtn,"^",12))          ////Hanzh 20220110 
	s:+UserInfo>=0 $P(rtn,"^",12)=$P($g(UserInfo),"^",2)
	q rtn
}

/// 根据Rowid获取诊断对照信息串
/// HanZH 2023-02-16 
/// 入参：ICDConID   诊断对照ID
/// 出参：
/// 	诊断对照信息串
/// w ##class(web.INSUDiagnosis).GetICDConInfoById(28740)
ClassMethod GetICDConInfoById(ICDConID) As %String
{
	new SQLCODE
	s ICDConInfo = $g(^DHCINICT(ICDConID))
	//"7670^E25.001^11β-羟化酶缺陷症^7233^E25.001^11β-羟化酶缺陷症^00A^66503^1^66521^37497^^^^^^^^"
	//   1      2      3              4     5          6          7   8    9   10    11 			19
	q:ICDConInfo="" "查询没结果"

	s MRCID=$P(ICDConInfo,"^",1)
	s MRCICDInfo=$g(^MRC("ID",MRCID))
	s HisVerId=$p(MRCICDInfo,"^",56)
	s DictStr1=##class(web.DHCINSUPortUse).GetDictInfoByRowId(HisVerId)	;平台组接口取版本号数据
	s HisVer=$p(DictStr1,"^",2)
	s InsuDiagID=$P(ICDConInfo,"^",4)
	s InsuDiagInfo=$g(^DHCINDiagnos(InsuDiagID))
	s InsuVer=$p(InsuDiagInfo,"^",23)

	i $P(ICDConInfo,"^",8)'="" d
	.s $P(ICDConInfo,"^",8)=$zd($P(ICDConInfo,"^",8),3)			//生效日期 
	i $P(ICDConInfo,"^",10)'="" d
	.s $P(ICDConInfo,"^",10)=$zd($P(ICDConInfo,"^",10),3)		//更新日期
	i $P(ICDConInfo,"^",11)'="" d
	.s $P(ICDConInfo,"^",11)=$zt($P(ICDConInfo,"^",11))			//更新时间

	q ICDConID_"^"_ICDConInfo_"^"_HisVer_"^"_InsuVer
}

}
