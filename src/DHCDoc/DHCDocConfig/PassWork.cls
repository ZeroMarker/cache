/// CTOR: QP
/// DATE: 2019-02-13
/// DESC: 医生站交班本配置
Class DHCDoc.DHCDocConfig.PassWork Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2019-01-09
/// DESC: 保存/更新交班本配置HUI
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.PassWork).DBSave(1)
ClassMethod DBSave(inPara As %String) As %String
{
	n (inPara)
	s ^TEMP("DHC",111)=inPara
	s ID = 			$p(inPara,"^",1)
	s code = 		$zcvt($p(inPara,"^",2),"U")
	s name = 		$p(inPara,"^",3)
	s stime = 		$p(inPara,"^",4)
	s etime = 		$p(inPara,"^",5)
	s nextday = 	$p(inPara,"^",6)
	s active = 		$p(inPara,"^",7)
	s note = 		$p(inPara,"^",8)
	s seqno = 		$p(inPara,"^",9)
	i stime'="" s stime = ..%ZTH(stime,2)
	i etime'="" s etime = ..%ZTH(etime,2)
	i ID = "" s PWOBJ = ##class(User.DHCDocPassWorkBcs).%New()
	e  s PWOBJ = ##class(User.DHCDocPassWorkBcs).%OpenId(ID)
	s PWOBJ.BCCode = code
	s PWOBJ.BCName = name
	s PWOBJ.BCSTime = stime
	s PWOBJ.BCETime = etime
	s PWOBJ.BCIsNextDay = nextday
	s PWOBJ.BCActive = active
	s PWOBJ.BCNote = note
	s PWOBJ.BCSeqno= seqno
	s sc = PWOBJ.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		TRollback
		Quit "-100"
	}
		
	q PWOBJ.%Id()
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 判断班次代码是否存在
/// IN  : 
/// OUT : 0:不存在/1:存在
/// EXEC: w ##class(DHCDoc.DHCDocConfig.PassWork).HasBCCode("","D")
ClassMethod HasBCCode(id, code)
{
	n (id,code)
	s mRtn = 0
	q:code="" mRtn
	s code=$zcvt(code,"U")
	q:'$d(^CF.Doc.PWBCI("BCCode",code)) mRtn
	s rowid=$o(^CF.Doc.PWBCI("BCCode",code,""))
	i rowid'=id s mRtn=1
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 保存规则
/// IN  : 
/// OUT : 0
/// EXEC: w ##class(DHCDoc.DHCDocConfig.PassWork).SaveRule("","D")
ClassMethod SaveRule(code, desc, value, action)
{
	n (code,desc,value,action)
	q:(action="add")&&($d(^CF.OPDoc.PW("GZ",code))) "-1"
	s ^CF.OPDoc.PW("GZ",code)=value_$C(1)_desc
	q 0
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 保存类型
/// IN  : 
/// OUT : 0
/// EXEC: w ##class(DHCDoc.DHCDocConfig.PassWork).SavePat("","D")
ClassMethod SavePat(code, desc, isDisplay, disNo, url, wh, action)
{
	n (code,desc,isDisplay,disNo,url,wh, action)
	q:(action="add")&&($d(^CF.OPDoc.PW("WKType",code))) "-1"
	S ^CF.OPDoc.PW("WKType",code)=desc_"^"_isDisplay_"^"_disNo_"^"_url_"^"_wh
	q 0
}

/// CTOR: QP
/// DATE: 2018-09-28
/// DESC: 初始化基础数据
/// IN  : 
/// OUT : 0
/// EXEC: w ##class(DHCDoc.DHCDocConfig.PassWork).InitBaseData()
ClassMethod InitBaseData()
{
	n
	i ('$d(^CF.OPDoc.PW("BC","D")))||('$d(^CF.OPDoc.PW("WKType")))||('$d(^CF.OPDoc.PW("GZ"))) d
	.d ##class(web.DHCDocPassWork).InitPassWorkData()
	
	q 0
}

/// CTOR: QP
/// DATE: 2019-02-13
/// DESC: 查询交班本配置
/// IN  : 
/// OUT : 
/// TABL: DHC_DocPassWorkBcs
/// INDE: ^CF.Doc.PWBCI("BCCode",{BC_Code},{BC_RowId})
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PassWork","QryPWConfig")
Query QryPWConfig() As %Library.Query(ROWSPEC = "rowid,code,name,sTime,eTime,nextDay,note,active,seqno")
{
}

ClassMethod QryPWConfigExecute(ByRef qHandle As %Library.Binary) As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^CF.Doc.PWBC(rowid)) q:rowid=""  d
	.s code=$p(^CF.Doc.PWBC(rowid),"^",1)
	.s name=$p(^CF.Doc.PWBC(rowid),"^",2)
	.s sTime=$p(^CF.Doc.PWBC(rowid),"^",3)
	.s eTime=$p(^CF.Doc.PWBC(rowid),"^",4)
	.i sTime'="" s sTime=..%ZT(sTime,2)
	.i eTime'="" s eTime=..%ZT(eTime,2)
	.s nextDay=$p(^CF.Doc.PWBC(rowid),"^",5)
	.s note=$p(^CF.Doc.PWBC(rowid),"^",6)
	.s active=$p(^CF.Doc.PWBC(rowid),"^",7)
	.s seqno=$p(^CF.Doc.PWBC(rowid),"^",8)
	.d OuputRow1
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	set Data=$lb(rowid,code,name,sTime,eTime,nextDay,note,active,seqno)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryPWConfigFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryPWConfigExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QryPWConfigClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryPWConfigFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-02-13
/// DESC: 查询规则配置
/// IN  : 
/// OUT : 
/// TABL: DHC_DocPassWorkBcs
/// INDE: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PassWork","QryRule")
Query QryRule() As %Library.Query(ROWSPEC = "code,value,desc")
{
}

ClassMethod QryRuleExecute(ByRef qHandle As %Library.Binary) As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s code=""
	f  s code=$o(^CF.OPDoc.PW("GZ",code)) q:code=""  d
	.q:(code="BZCode")||(code="BWCode")
	.s value=$p(^CF.OPDoc.PW("GZ",code),$C(1),1)
	.s desc=$p(^CF.OPDoc.PW("GZ",code),$C(1),2)
	.d OuputRow2
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow2
	set Data=$lb(code,value,desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryRuleFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryRuleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QryRuleClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryRuleFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-02-13
/// DESC: 查询病人类型
/// IN  : 
/// OUT : 
/// TABL: DHC_DocPassWorkBcs
/// INDE: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PassWork","QryPat")
Query QryPat() As %Library.Query(ROWSPEC = "code,desc,isDisplay,disNo,tplURL,wh")
{
}

ClassMethod QryPatExecute(ByRef qHandle As %Library.Binary) As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TEMP("DHCDoc.DHCDocConfig.PassWork",$j)
	s code=""
	f  s code=$o(^CF.OPDoc.PW("WKType",code)) q:code=""  d
	.s desc=$p(^CF.OPDoc.PW("WKType",code),"^",1)
	.s isDisplay=$p(^CF.OPDoc.PW("WKType",code),"^",2)
	.s disNo=$p(^CF.OPDoc.PW("WKType",code),"^",3)
	.i disNo="" s disNo="999"
	.s tplURL=$p(^CF.OPDoc.PW("WKType",code),"^",4)
	.s wh=$p(^CF.OPDoc.PW("WKType",code),"^",5)
	.s ^TEMP("DHCDoc.DHCDocConfig.PassWork",$j,disNo,code)=$lb(code,desc,isDisplay,disNo,tplURL,wh)
	
	s disNo=""
	f  s disNo=$o(^TEMP("DHCDoc.DHCDocConfig.PassWork",$j,disNo)) q:disNo=""  d
	.s code=""
	.f  s code=$o(^TEMP("DHCDoc.DHCDocConfig.PassWork",$j,disNo,code)) q:code=""  d
	..s outdata=^TEMP("DHCDoc.DHCDocConfig.PassWork",$j,disNo,code)
	..d OuputRow3
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow3
	set Data=outdata	//$lb(code,desc,isDisplay,disNo)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryPatFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryPatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QryPatClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryPatFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
