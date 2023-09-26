/// Creator:
/// Desctiptions:
/// Date:2017-07-29
Class web.NurMgDBComm Extends %RegisteredObject
{

/// Creator:
/// CreateDate:2017-07-29
/// Description:保存公共代码父项
/// Table:
/// Input:
/// Output:
/// return: 
/// Others:^SetCode|ssss^SetDesc|rrr^SetRemark|^RowID|
ClassMethod SaveSetCode(parr As %String) As %String
{
	;s ^tmp("parr")=parr
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s flag=..IsExist($zcvt($tr(tmp("SetCode")," ",""),"U"))
	i ((flag=2)&&(id="")) q "此记录已经存在"
	i id="" s obj=##class(DHCNMG.DB.MgSetCode).%New()
	e  s obj=##class(DHCNMG.DB.MgSetCode).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.DB.MgSetCode","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..s $ZOBJPROPERTY(obj,p)=$zcvt($tr(tmp(p)," ",""),"U")
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod IsExist(code As %String) As %String
{
	s flag=0
	s rid=$O(^DHCNMG.DB.MgSetCodeI("Code"," "_$zcvt($tr(code," ",""),"U"),""))
	i rid'="" d
	.s flag=2
	q flag
}

ClassMethod GetSetCode(id As %String) As %String
{
	s obj=##class(DHCNMG.DB.MgSetCode).%OpenId(id)
	s ret="",tmp=""
	s p="" f  s p=$O(^oddCOM("DHCNMG.DB.MgSetCode","a",p)) q:p=""  d
	.q:p["%"
	.s tmp(p)=$ZOBJPROPERTY(obj,p)
	s k="" 
	f {
		s k=$O(tmp(k))
		q:k=""
		s ret=ret_k_"|"_tmp(k)_"^"	
	}
	s ret=ret_"setid|"_id
	q ret
}

/// Creator:
/// Description:查询公共代码
/// Date:2017-07-29
/// Table:DHCNMG.DB.MgSetCode
/// Input:
/// Output：
/// Return:
/// Others:
Query FindSetCodes(setstr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindSetCodesExecute(ByRef qHandle As %Binary, setstr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("setstr")=setstr
	s ret=""
	s code="" f  s code=$O(^DHCNMG.DB.MgSetCodeI("Code",code)) q:code=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.DB.MgSetCodeI("Code",code,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.DB.MgSetCode).%OpenId(rowid)
	..q:'$IsObject(obj)
	..s SetCode=obj.SetCode
	..s SetDesc=obj.SetDesc
	..q:((setstr'="")&&(SetDesc'[$zcvt($tr(setstr," ",""),"U")))
	..s SetRemark=obj.SetRemark
	..s ret="SetCode|"_SetCode_"^SetDesc|"_SetDesc_"^SetRemark|"_SetRemark_"^setrw|"_rowid
	..do OutputSetData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSetData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSetCodesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSetCodesExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindSetCodesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSetCodesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:
/// Description:查询公共代码子项列表
/// Date:2017-08-01
/// Table:DHCNMG.DB.MgSetCodeSub
/// Input:
/// Output：
/// Return:
/// Others:
Query FindSetSubCode(substr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindSetSubCodeExecute(ByRef qHandle As %Binary, substr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	;s ^TMP("substr")=substr
	s sort="" f  s sort=$O(^DHCNMG.DB.MgSetCodeSubI("Sort",substr,sort)) q:sort=""  d
	.s raw="" f  s raw=$O(^DHCNMG.DB.MgSetCodeSubI("Sort",substr,sort,raw)) q:raw=""  d
	..s obj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(substr_"||"_raw)
	..s SubCode=obj.SubCode
	..s SubDesc=obj.SubDesc
	..q:((input'="")&&(SubDesc'[$tr(input," ","")))
	..s SubRemark=obj.SubRemark
	..i obj.SubStDate'="" s SubStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubStDate)
	..e  s SubStDate=""
	..i obj.SubEndDate'="" s SubEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubEndDate)
	..e  s SubEndDate=""
	..s SubSymbol=obj.SubSymbol
	..s ret="SubCode|"_SubCode_"^SubDesc|"_SubDesc_"^SubRemark|"_SubRemark_"^SubStDate|"_SubStDate_"^SubEndDate|"_SubEndDate_"^par|"_substr_"^raw|"_raw_"^SubSymbol|"_SubSymbol
	..do OutputSubData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSubData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSetSubCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSetSubCodeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindSetSubCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSetSubCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:
/// Description:保存公共代码子项
/// Date:2017-08-02
/// Table:DHCNMG.DB.MgSetCodeSub
/// Input:
/// Output：
/// Return:
/// Others://subCode|藏族^subDesc|藏族^subRemark|2^subStDate|2017-08-02^subEndDate|^subSymbol|^Par|1^raw|
ClassMethod SaveSubCode(parr As %String) As %String
{
	s ^TMP("parr0802")=parr
	s SubCode=$P(parr,"^",1)
	s SubDesc=$P(parr,"^",2)
	s SubRemark=$P(parr,"^",3)
	s SubStDate=$P(parr,"^",4)
	s SubEndDate=$P(parr,"^",5)
	s SubSymbol=$P(parr,"^",6)
	s Par=$P(parr,"^",7)
	s raw=$P(parr,"^",8)
	s SubSort=$p(parr,"^",9)
	s flag=..IsSubExist($P(Par,"|",2),$P(SubCode,"|",2))
	q:((flag=2)&&($P(raw,"|",2)="")) flag
	
	i $P(raw,"|",2)="" d
	.s obj=##class(DHCNMG.DB.MgSetCodeSub).%New()
	.s obj.Parref=##class(DHCNMG.DB.MgSetCode).%OpenId($P(Par,"|",2))
	e  d
	.s obj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId($P(Par,"|",2)_"||"_$P(raw,"|",2))
	s obj.SubCode=$zcvt($tr($P(SubCode,"|",2)," ",""),"U")
	s obj.SubDesc=$zcvt($tr($P(SubDesc,"|",2)," ",""),"U")
	s obj.SubRemark=$zcvt($tr($P(SubRemark,"|",2)," ",""),"U")
	i $P(SubStDate,"|",2)'="" s obj.SubStDate=$zdh($P(SubStDate,"|",2),3)
	e  s obj.SubStDate=""
	i $P(SubEndDate,"|",2)'="" s obj.SubEndDate=$zdh($P(SubEndDate,"|",2),3)
	e  s obj.SubEndDate=""
	s obj.SubSymbol=$zcvt($tr($P(SubSymbol,"|",2)," ",""),"U")
	s obj.SubSort=$tr($P(SubSort,"|",2)," ","")
	s sc=obj.%Save()
	q sc
}

/// Creator:guozj
/// Description:获取公共代码子项序号
/// Date:2017-11-27
/// Table:DHCNMG.DB.MgSetCodeSub
/// Input:
/// Output：
/// Return:
ClassMethod ComCodeSubSort(par As %String) As %String
{
	s n=1
	s sort="" f  s sort=$O(^DHCNMG.DB.MgSetCodeSubI("Sort",par,sort)) q:sort=""  d
	.s rw="" f  s rw=$O(^DHCNMG.DB.MgSetCodeSubI("Sort",par,sort,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(par_"||"_rw)
	..i obj.SubSort'="" s n=n+1
	q n
}

/// Creator:guozj
/// Description:设置公共代码子项序号
/// Date:2017-11-27
/// Table:DHCNMG.DB.MgSetCodeSub
/// Input:
/// Output：
/// Return:
ClassMethod SetCodeSubSort(rowid As %String, type As %String) As %String
{
	;s ^TMP("subsort")=rowid_"%"_type
	q:rowid="" ""
	s ret=0
	s par=$p(rowid,"||",1)
	s rw=$p(rowid,"||",2)
	s obj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(rowid)
	s sort=obj.SubSort
	i type="up"
	{
		i sort="1" s ret=0
		e  d
		.s ret=sort-1
		.s obj.SubSort=sort-1
		.s row=$O(^DHCNMG.DB.MgSetCodeSubI("Sort",par,sort-1,""))
		.s bobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(par_"||"_row)
		.s bobj.SubSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	}
	elseif type="down"
	{
		s maxSort=$O(^DHCNMG.DB.MgSetCodeSubI("Sort",par,""),-1)
		i sort=maxSort s ret=1
		e  d
		.s ret=sort+1
		.s obj.SubSort=sort+1
		.s row=$O(^DHCNMG.DB.MgSetCodeSubI("Sort",par,sort+1,""))
		.s bobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(par_"||"_row)
		.s bobj.SubSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	} 
	q ret
}

ClassMethod IsSubExist(par As %String, code As %String) As %String
{
	s flag=0
	s id=$O(^DHCNMG.DB.MgSetCodeSubI("Code",par," "_$zcvt($tr(code," ",""),"U"),""))
	i id'="" s flag=2
	q flag
}

/// Creator:
/// Description:获取公共代码子项
/// Date:2017-08-03
/// Table:DHCNMG.DB.MgSetCodeSub
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod GetSubItem(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(id)
	s subCode=obj.SubCode
	s subDesc=obj.SubDesc
	s subRemark=obj.SubRemark
	i obj.SubStDate'="" s subStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubStDate)
	e  s subStDate=""
	i obj.SubEndDate'="" s subEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubEndDate)
	e  s subEndDate=""
	s subSymbol=obj.SubSymbol
	s subSort=obj.SubSort
	s ret="subCode|"_subCode_"^subDesc|"_subDesc_"^subRemark|"_subRemark_"^subStDate|"_subStDate_"^subEndDate|"_subEndDate_"^subSymbol|"_subSymbol_"^raw|"_$P(id,"||",2)_"^subSort|"_subSort
	q ret
}

/// creator:xbl
/// date:20170810
/// desc:保存病区维护
/// table:DHCNMG.DB.MgWard
/// input:
/// output:
/// other: d ##class(web.NurMgDBComm).SaveWard("CTLocDR|31^WardTypeDR|1__1^WardCode|中西医结合二科护理单元^WardDesc|中西医结合二科护理单元^WardSpell|ZXYJHEKHLDY^WardAreaDR|^WardLimits|2__1,2__2^WardLocDR|^WardStDate|2017-08-17^WardEndDate|^rw|^WardShort|^")
ClassMethod SaveWard(parr As %String) As %String
{
	s ^TMP("saveward")=parr
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	b ;001
	s flag=0
	s id=$o(^DHCNMG.DB.MgWardI("Code"," "_$tr(tmp("WardCode")," ",""),""))
	i $g(tmp("rw"))="" d
	.i id'="" s flag=-2
	.;e  s flag=0
	e  d
	.i ((id'="")&&($g(tmp("rw"))'=id)) s flag=-2
	q:flag=-2 -2
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.DB.MgWard).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.DB.MgWard).%New()
	i ($g(tmp("CTLocDR"))'="")&&($d(^CTLOC(tmp("CTLocDR")))) d
	.s obj.CTLocDR=##class(User.CTLoc).%OpenId(tmp("CTLocDR"))
	.i obj.CTLocDR.CTLOCHospitalDR'="" d
	..s obj.CTHospitalDR=obj.CTLocDR.CTLOCHospitalDR
	e  s obj.CTLocDR=""
	i $g(tmp("WardTypeDR"))'="" d
	.s obj.WardTypeDR=##class(DHCNMG.Set.MgSysParamSub).%OpenId($tr(tmp("WardTypeDR"),"__","||"))
	e  s obj.WardTypeDR=""
	s obj.WardCode=$g(tmp("WardCode"))
	s obj.WardDesc=$g(tmp("WardDesc"))
	i $g(tmp("WardDesc"))'="" d
	.s obj.WardSpell=##class(web.NurMgVueComm).ToChineseSpell(tmp("WardDesc"))
	s obj.WardShort=$g(tmp("WardShort"))
	d obj.WardLimits.Clear()
	f i=1:1:$L(tmp("WardLimits")) d
	.s itm=$P(tmp("WardLimits"),",",i)
	.q:itm=""
	.d obj.WardLimits.Insert($tr(itm,"__","||"))
	i $g(tmp("WardStDate"))'="" s obj.WardStDate=$zdh(tmp("WardStDate"),3)
	e  s obj.WardStDate=""
	i $g(tmp("WardEndDate"))'="" s obj.WardEndDate=$zdh(tmp("WardEndDate"),3)
	e  s obj.WardEndDate=""
	s obj.WardSort=$g(tmp("WardSort"))
	i $g(tmp("WardAreaDR"))'="" d
	.s WardAreaObj=##class(DHCNMG.DB.MgWardArea).%OpenId($g(tmp("WardAreaDR")))
	.i $IsObject(WardAreaObj) s obj.WardAreaDR=WardAreaObj
	s obj.WardRemark=$g(tmp("WardRemark"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator:xbl
/// date:20170810
/// desc:获取病区
/// table:DHCNMG.DB.MgWard
/// input:
/// output:
/// other: w ##class(web.NurMgDBComm).GetWard(1)
ClassMethod GetWard(id As %String) As %String
{
	;s ^TMP("getward")=id
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgWard).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^WardCode|"_obj.WardCode
	s ret=ret_"^WardDesc|"_obj.WardDesc
	i obj.WardTypeDR'="" d
	.s ret=ret_"^WardTypeDR|"_$tr(obj.WardTypeDR.%Id(),"|","_")
	.s ret=ret_"^WardTypeDesc|"_obj.WardTypeDR.SubDesc
	s wardlimits="",limitdesc=""
	f i=1:1:obj.WardLimits.Count() d
	.s itmObj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(obj.WardLimits.GetAt(i))
	.i wardlimits="" d
	..s wardlimits=obj.WardLimits.GetAt(i),limitdesc=itmObj.SubDesc
	.e  d
	..s wardlimits=wardlimits_","_obj.WardLimits.GetAt(i),limitdesc=limitdesc_","_itmObj.SubDesc
	s ret=ret_"^WardLimits|"_$tr(wardlimits,"|","_")_"^LimitDesc|"_limitdesc
	i obj.CTLocDR'="" d
	.s ret=ret_"^CTLocDR|"_obj.CTLocDR.%Id()
	.i obj.CTLocDR.CTLOCDesc["-" s ret=ret_"^CTLocDesc|"_$P(obj.CTLocDR.CTLOCDesc,"-",2)
	.e  s ret=ret_"^CTLocDesc|"_obj.CTLocDR.CTLOCDesc
	i obj.CTHospitalDR'="" d
	.s ret=ret_"^CTHospitalDR|"_obj.CTHospitalDR.%Id()
	.s ret=ret_"^CTHospitalDesc|"_obj.CTHospitalDR.HOSPDesc
	s ret=ret_"^WardSpell|"_obj.WardSpell
	s ret=ret_"^WardShort|"_obj.WardShort
	i obj.WardAreaDR'="" d
	.s ret=ret_"^WardAreaDR|"_obj.WardAreaDR.%Id()
	.s ret=ret_"^WardAreaDesc|"_obj.WardAreaDR.AreaDesc
	i obj.WardLocDR'="" d
	.s ret=ret_"^WardLocDR|"_obj.WardLocDR.%Id()
	.s ret=ret_"^WardLocDesc|"_obj.WardLocDR.LocDesc
	i obj.WardStDate'="" s ret=ret_"^WardStDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.WardStDate)
	i obj.WardEndDate'="" s ret=ret_"^WardEndDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.WardEndDate)
	i obj.WardSort'="" s ret=ret_"^WardSort|"_obj.WardSort
	i obj.WardRemark'="" s ret=ret_"^WardRemark|"_obj.WardRemark
	q ret
}

/// creator:dhh
/// date:20190905
/// desc:获取病区
/// table:DHCNMG.DB.MgWard
/// input:
/// output:
/// other: w ##class(web.NurMgDBComm).GetInuseWard(1)
ClassMethod GetInuseWard(id As %String) As %String
{
	;s ^TMP("getward")=id
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgWard).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^WardCode|"_obj.WardCode
	s ret=ret_"^WardDesc|"_obj.WardDesc
	i obj.WardTypeDR'="" d
	.s ret=ret_"^WardTypeDR|"_$tr(obj.WardTypeDR.%Id(),"|","_")
	.s ret=ret_"^WardTypeDesc|"_obj.WardTypeDR.SubDesc
	s wardlimits="",limitdesc=""
	f i=1:1:obj.WardLimits.Count() d
	.s itmObj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(obj.WardLimits.GetAt(i))
	.i wardlimits="" d
	..s wardlimits=obj.WardLimits.GetAt(i),limitdesc=itmObj.SubDesc
	.e  d
	..s wardlimits=wardlimits_","_obj.WardLimits.GetAt(i),limitdesc=limitdesc_","_itmObj.SubDesc
	s ret=ret_"^WardLimits|"_$tr(wardlimits,"|","_")_"^LimitDesc|"_limitdesc
	i obj.CTLocDR'="" d
	.s ret=ret_"^CTLocDR|"_obj.CTLocDR.%Id()
	.i obj.CTLocDR.CTLOCDesc["-" s ret=ret_"^CTLocDesc|"_$P(obj.CTLocDR.CTLOCDesc,"-",2)
	.e  s ret=ret_"^CTLocDesc|"_obj.CTLocDR.CTLOCDesc
	i obj.CTHospitalDR'="" d
	.s ret=ret_"^CTHospitalDR|"_obj.CTHospitalDR.%Id()
	.s ret=ret_"^CTHospitalDesc|"_obj.CTHospitalDR.HOSPDesc
	s ret=ret_"^WardSpell|"_obj.WardSpell
	s ret=ret_"^WardShort|"_obj.WardShort
	i obj.WardAreaDR'="" d
	.s ret=ret_"^WardAreaDR|"_obj.WardAreaDR.%Id()
	.s ret=ret_"^WardAreaDesc|"_obj.WardAreaDR.AreaDesc
	i obj.WardLocDR'="" d
	.s ret=ret_"^WardLocDR|"_obj.WardLocDR.%Id()
	.s ret=ret_"^WardLocDesc|"_obj.WardLocDR.LocDesc
	i obj.WardStDate'="" s ret=ret_"^WardStDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.WardStDate)
	i obj.WardEndDate'="" s ret=ret_"^WardEndDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.WardEndDate)
	i obj.WardSort'="" s ret=ret_"^WardSort|"_obj.WardSort
	i obj.WardRemark'="" s ret=ret_"^WardRemark|"_obj.WardRemark
	s nowDate = +$h
	s endDate = obj.WardEndDate
	i (obj.WardEndDate'="") && (endDate<nowDate)
	{
		q ""
	} 
	else
	{
		q ret
	}
}

ClassMethod DeleteWard(id As %String) As %String
{
	q:id="" 0
	s sort=0 //127
	s obj=##class(DHCNMG.DB.MgWard).%OpenId(id)
	q:'$IsObject(obj) 0
	
	s sort=obj.WardSort
	TS
	s sc=obj.%DeleteId(id)
	if $$$ISERR(sc) {
		TRO
		q 0	
	}
	s flag=1
	s wardid="" f  s wardid=$O(^DHCNMG.DB.MgWardI("Sort",sort+1,wardid)) q:(wardid="")||(flag=0)  d
	.s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardid)
	.s WardObj.WardSort=sort
	.s sort=sort+1
	.s flag=((flag)&&($$$ISOK(WardObj.%Save())))
	s locId="" f  s locId=$O(^DHCNMG.DB.MgWardLocUnitI("Ward",id,locId)) q:(locId="")||(flag=0)  d
	.s unitId="" f  s unitId=$O(^DHCNMG.DB.MgWardLocUnitI("Ward",id,locId,unitId)) q:(unitId="")||(flag=0)  d
	..b ;333
	..s unitObj=##class(DHCNMG.DB.MgWardLocUnit).%OpenId(unitId)
	..q:'$IsObject(unitObj)
	..s flag=flag&&unitObj.%DeleteId(unitId)
	i flag=1{
		TC
		q 1	
	}else{
		TRO
		q 0	
	}
}

/// creator:xbl
/// date:20170810
/// desc:病区重复检查
/// table:DHCNMG.DB.MgWard
/// input:
/// output:
/// other:
ClassMethod CheckWard(locid As %String, code As %String) As %String
{
	q:(locid="")&(code="") 0
	s id=""
	i locid'="" d
	.s id=$O(^DHCNMG.DB.MgWardI("CTLoc",locid,""))
	q:id'="" 1
	i code'="" d
	.s id=$O(^DHCNMG.DB.MgWardI("Code"," "_$zcvt(code,"U"),""))
	q:id'="" 1
	q 0
}

/// creator: xbl
/// createDate: 20170817
/// description: 获取病区列表
/// table: DHCNMG.DB.MgWard
/// input:
/// output:
/// other: w ##class(%ResultSet).RunQuery("web.NurMgDBComm","FindWardList","")
Query FindWardList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmpLocWard=""
	i parr'="" d
	.s wardid="" f  s wardid=$O(^DHCNMG.DB.MgWardLocUnit("Loc",$tr(parr," ",""),wardid)) q:wardid=""  d
	..q:wardid=""
	..s tmp(wardid)=wardid
	;s ^TMP("wardparr")=parr
	s sort="" f  s sort=$O(^DHCNMG.DB.MgWardI("Sort",sort)) q:sort=""  d
	.;s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	.;s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
	.s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Sort",sort,id)) q:id=""  d
	..s obj=##class(DHCNMG.DB.MgWard).%OpenId(id)
	..;s isExist=0
	..q:((parr'="")&&('$d(tmpLocWard(id)))) 
	..;q:((parr'="")&&(obj.WardLocDR'="")&&(obj.WardLocDR.%Id()'=parr))
	..q:((input'="")&&((obj.WardSpell_obj.WardDesc)'[$zcvt($tr(input," ",""),"U")))
	..s ret=..GetWard(id)
	..d OutWard
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: dhh
/// createDate: 20190905
/// description: 获取未停用病区列表
/// table: DHCNMG.DB.MgWard
/// input:
/// output:
/// other: w ##class(%ResultSet).RunQuery("web.NurMgDBComm","FindInuseWardList","")
Query FindInuseWardList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindInuseWardListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmpLocWard=""
	i parr'="" d
	.s wardid="" f  s wardid=$O(^DHCNMG.DB.MgWardLocUnit("Loc",$tr(parr," ",""),wardid)) q:wardid=""  d
	..q:wardid=""
	..s tmp(wardid)=wardid
	;s ^TMP("wardparr")=parr
	s sort="" f  s sort=$O(^DHCNMG.DB.MgWardI("Sort",sort)) q:sort=""  d
	.;s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	.;s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
	.s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Sort",sort,id)) q:id=""  d
	..s obj=##class(DHCNMG.DB.MgWard).%OpenId(id)
	..;s isExist=0
	..q:((parr'="")&&('$d(tmpLocWard(id)))) 
	..;q:((parr'="")&&(obj.WardLocDR'="")&&(obj.WardLocDR.%Id()'=parr))
	..q:((input'="")&&((obj.WardSpell_obj.WardDesc)'[$zcvt($tr(input," ",""),"U")))
	..i (..GetInuseWard(id)'="") d
	...s ret=..GetInuseWard(id)
	...d OutWard
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInuseWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInuseWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindInuseWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: xbl
/// createDate: 20170817
/// description: 保存片区
/// table:DHCNMG.DB.MgWardArea
/// input:
/// output:
/// other:
ClassMethod SaveWardArea(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=..IsExistArea(parr)
	q:flag=-1 "此记录已经存在，保存失败"
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.DB.MgWardArea).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.DB.MgWardArea).%New()
	s obj.AreaCode=$g(tmp("AreaCode"))
	s obj.AreaDesc=$g(tmp("AreaDesc"))
	i $g(tmp("AreaNurHeadDR"))'="" d
	.s obj.AreaNurHeadDR=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("AreaNurHeadDR"))
	e  s obj.AreaNurHeadDR=""
	i $g(tmp("AreaStDate"))'="" s obj.AreaStDate=$zdh(tmp("AreaStDate"),3)
	e  s obj.AreaStDate=""
	i $g(tmp("AreaEndDate"))'="" s obj.AreaEndDate=$zdh(tmp("AreaEndDate"),3)
	e  s obj.AreaEndDate=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:gzj
/// Date:2020-02-05
/// Description:判断片区记录是否存在
/// Table:
/// Input:
/// Output:
/// Return:
ClassMethod IsExistArea(parr As %String) As %String
{
	q:parr="" 0
	s flag=0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	s id=$o(^DHCNMG.DB.MgWardAreaI("Code"," "_$zcvt($tr($g(tmp("AreaCode"))," ",""),"U"),""))
	i rw="" d
	.i id'="" s flag=-1
	e  d
	.i ((id'="")&&(rw'=id)) s flag=-1
	q flag
}

/// creator: xbl
/// createDate: 20170817
/// description: 获取片区记录
/// table: DHCNMG.DB.MgWardArea
/// input: 
/// output:
/// other:
ClassMethod GetWardArea(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgWardArea).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^AreaCode|"_obj.AreaCode
	s ret=ret_"^AreaDesc|"_obj.AreaDesc
	i obj.AreaNurHeadDR'="" d
	.s ret=ret_"^AreaNurHeadDR|"_obj.AreaNurHeadDR.%Id()
	.s ret=ret_"^NurHeadName|"_obj.AreaNurHeadDR.PerName
	i obj.AreaStDate'="" d
	.s ret=ret_"^AreaStDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.AreaStDate)
	i obj.AreaEndDate'="" d
	.s ret=ret_"^AreaEndDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.AreaEndDate)
	q ret
}

/// creator: xbl
/// createDate: 20170817
/// description: 删除片区
/// table: DHCNMG.DB.MgWardArea
/// input:
/// output:
/// other:
ClassMethod DeleteWardArea(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgWardArea).%OpenId(id)
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator: xbl
/// createDate: 20170817
/// description: 获取片区列表
/// table: DHCNMG.DB.MgWardArea
/// input: 
/// output:
/// other:
Query FindWardAreaList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardAreaListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s code="" f  s code=$O(^DHCNMG.DB.MgWardAreaI("Code",code)) q:code=""  d
	.s id="" f  s id=$O(^DHCNMG.DB.MgWardAreaI("Code",code,id)) q:id=""  d
	..s obj=##class(DHCNMG.DB.MgWardArea).%OpenId(id)
	..q:'$IsObject(obj)
	..s ret=..GetWardArea(id)
	..d OutWardArea
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardArea
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardAreaListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardAreaListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardAreaListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardAreaListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: xbl
/// createDate: 20170817
/// description: 保存科室
/// table:DHCNMG.DB.MgWardLoc
/// input:
/// output:
/// other: d ##class(web.NurMgDBComm).SaveWardLoc("LocCode|ZXYJHYK^LocDesc|中西医结合一科^CTLocDR|6^LocNurHeadDR|^LocStDate|2017-08-17^LocEndDate|^rw|^")
ClassMethod SaveWardLoc(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.DB.MgWardLoc).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.DB.MgWardLoc).%New()
	s obj.LocCode=$g(tmp("LocCode"))
	s obj.LocDesc=$g(tmp("LocDesc"))
	i $g(tmp("CTLocDR"))'="" d
	.s obj.CTLocDR=##class(User.CTLoc).%OpenId(tmp("CTLocDR"))
	e  s obj.CTLocDR=""
	i $g(tmp("LocNurHeadDR"))'="" d
	.s obj.LocNurHeadDR=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("LocNurHeadDR"))
	e  s obj.LocNurHeadDR=""
	i $g(tmp("LocStDate"))'="" s obj.LocStDate=$zdh(tmp("LocStDate"),3)
	e  s obj.LocStDate=""
	i $g(tmp("LocEndDate"))'="" s obj.LocEndDate=$zdh(tmp("LocEndDate"),3)
	e  s obj.LocEndDate=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator: xbl
/// createDate: 20170817
/// description: 获取科室记录
/// table: DHCNMG.DB.MgWardLoc
/// input: 
/// output:
/// other:
ClassMethod GetWardLoc(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgWardLoc).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^LocCode|"_obj.LocCode
	s ret=ret_"^LocDesc|"_obj.LocDesc
	i obj.CTLocDR'="" d
	.s ret=ret_"^CTLocDR|"_obj.CTLocDR.%Id()
	.i obj.CTLocDR.CTLOCDesc["-" s ret=ret_"^CTLocDesc|"_$P(obj.CTLocDR.CTLOCDesc,"-",2)
	.e  s ret=ret_"^CTLocDesc|"_obj.CTLocDR.CTLOCDesc
	i obj.LocNurHeadDR'="" d
	.s ret=ret_"^LocNurHeadDR|"_obj.LocNurHeadDR.%Id()
	.s ret=ret_"^NurHeadName|"_obj.LocNurHeadDR.PerName
	i obj.LocStDate'="" d
	.s ret=ret_"^LocStDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.LocStDate)
	i obj.LocEndDate'="" d
	.s ret=ret_"^LocEndDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.LocEndDate)
	q ret
}

/// creator: xbl
/// createDate: 20170817
/// description: 删除科室
/// table: DHCNMG.DB.MgWardLoc
/// input:
/// output:
/// other:
ClassMethod DeleteWardLoc(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgWardLoc).%OpenId(id)
	TS
	s sc=obj.%DeleteId(id)
	i $$$ISERR(sc){
		TRO
		q 0	
	}
	s flag=1
	s wardId="" f  s wardId=$O(^DHCNMG.DB.MgWardLocUnitI("Loc",id,wardId)) q:(wardId="")||(flag=0)  d
	.s unitId="" f  s unitId=$O(^DHCNMG.DB.MgWardLocUnitI("Loc",id,wardId,unitId)) q:(unitId="")||(flag=0)  d
	..s unitObj=##class(DHCNMG.DB.MgWardLocUnit).%OpenId(unitId)
	..q:'$IsObject(unitObj)
	..s flag=flag&&unitObj.%DeleteId(unitId)
	b ;1
	i flag=1{
		TC
		q 1	
	}else{
		TRO
		q 0	
	}
}

/// creator: xbl
/// createDate: 20170817
/// description: 获取科室列表
/// table: DHCNMG.DB.MgWardArea
/// input: 
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgDBComm","FindWardLocList","")
Query FindWardLocList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardLocListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	;s ^TMP("parr")=parr
	s code="" f  s code=$O(^DHCNMG.DB.MgWardLocI("Code",code)) q:code=""  d
	.s id="" f  s id=$O(^DHCNMG.DB.MgWardLocI("Code",code,id)) q:id=""  d
	..s obj=##class(DHCNMG.DB.MgWardLoc).%OpenId(id)
	..s locShell=##class(web.NurMgVueComm).ToChineseSpell(obj.LocDesc)
	..q:((input'="")&&((locShell_obj.LocDesc)'[$zcvt($tr(input," ",""),"U")))
	..s ret=..GetWardLoc(id)
	..d OutWardLoc
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardLoc
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardLocListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:
/// Description:查询公共代码明细
/// Date:2017-08-17
/// Table:DHCNMG.DB.MgSetCodeSub
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgDBComm","FindPubCode","")
Query FindPubCode(type As %String = "") As %Query(ROWSPEC = "SubCode,SubDesc,SubValue")
{
}

ClassMethod FindPubCodeExecute(ByRef qHandle As %Binary, type As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	;s ^TMP("type")=type
	s ind=1
	s par="" f  s par=$O(^DHCNMG.DB.MgSetCodeI("Code"," "_$zcvt($tr(type," ",""),"U"),par)) q:par=""  d
	.s sort="" f  s sort=$O(^DHCNMG.DB.MgSetCodeSubI("Sort",par,sort)) q:sort=""  d
	..s raw="" f  s raw=$O(^DHCNMG.DB.MgSetCodeSubI("Sort",par,sort,raw)) q:raw=""  d
	...s obj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(par_"||"_raw)
	...s date=+$H
	...s SubStDate=obj.SubStDate
	...s SubEndDate=obj.SubEndDate
	...q:(SubStDate'="")&&(date<SubStDate)
	...q:((SubEndDate'="")&&(date>SubEndDate))
	...s SubCode=obj.SubCode
	...s SubDesc=obj.SubDesc
	...do OutputPub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPub
	set Data=$lb(SubCode,SubDesc,par_"||"_raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPubCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPubCodeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPubCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPubCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// creator: xbl
/// createdate: 20170823
/// description: 保存排班班次
/// table: DHCNMG.DB.MgArgPost
/// input:
/// output:
/// other: w ##class(web.NurMgDBComm).SaveArgPost("PostDesc|A1^PostType|P^HolidayTime|^PostStTime1|00:00^PostEndTime1|08:00^PostStTime2|^PostEndTime2|^PostMinutes|8时0分^PostDayMinutes|8时0分^PostNextMinutes|^PostUseType|H^PostUseLimit|^PostFontColor|#FF0000^PostBgColor|^PostRemark|测试^PostStatus|Y^PostCrtDate|2017-11-15^PostCrtTime|21:32:03^PostCrtUser|^rw|1^")
ClassMethod SaveArgPost(parr As %String, crtUser As %String) As %String
{
	s ^TMP("SaveArgPost")=crtUser
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s Flag=1
	s PostDesc=$TR($G(tmp("PostDesc"))," ","")
	s isExistName=0
	s tRw="" f  s tRw=$O(^DHCNMG.DB.MgArgPostI("Desc"," "_$ZCVT(PostDesc,"U"),tRw)) q:(tRw="")||(isExistName=1)  d
	.s tRwObj=##class(DHCNMG.DB.MgArgPost).%OpenId(tRw)
	.q:'$IsObject(tRwObj)
	.q:tRw=$g(tmp("rw"))
	.i tRwObj.PostDesc=PostDesc s isExistName=1
	q:isExistName=1 "名称重复"
	TS
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.DB.MgArgPost).%OpenId(tmp("rw"))
	.;【南通中医需求，更改全局排班自动更改病区排班时间】
	.;i (($d(^DHCNMG.DB.MgArgWardPostI("Post",tmp("rw"))))) d
	.;粤北需要全局的名称作为代码，病区岗位名称可维护，去掉修改全局班次同事修改
	.i (obj.PostDesc'=$g(tmp("PostDesc")))&&($d(^DHCNMG.DB.MgArgWardPostI("Post",tmp("rw")))) d
	..s wardPostId="" f  s wardPostId=$O(^DHCNMG.DB.MgArgWardPostI("Post",tmp("rw"),wardPostId)) q:(wardPostId="")||(Flag=0)  d
	...s wardPostObj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(wardPostId)
	...s wardPostObj.PostDesc=$g(tmp("PostDesc"))
	...;【南通中医需求，更改全局排班自动更改病区排班时间】
	...;s wardPostObj.PostStTime1=$g(tmp("PostStTime1"))
	...;s wardPostObj.PostEndTime1=$g(tmp("PostEndTime1"))
	...;s wardPostObj.PostStTime2=$g(tmp("PostStTime2"))
	...;s wardPostObj.PostEndTime2=$g(tmp("PostEndTime2"))
	...;s wardPostObj.PostStTime3=$g(tmp("PostStTime3"))
	...;s wardPostObj.PostEndTime3=$g(tmp("PostEndTime3"))
	...;s wardPostObj.PostMinutes=$g(tmp("PostMinutes"))
	...;s wardPostObj.PostDayMinutes=$g(tmp("PostDayMinutes"))
	...;s wardPostObj.PostNextMinutes=$g(tmp("PostNextMinutes"))
	...s sc=wardPostObj.%Save()
	...i $$$ISERR(sc) s Flag=0
	e  d
	.s obj=##class(DHCNMG.DB.MgArgPost).%New()
	.s obj.PostCode=$zd(+$h,8)_$tr($zt($P($h,",",2),1),":","")
	.s obj.PostCrtDate=+$h
	.s obj.PostCrtTime=$P($h,",",2)
	.s obj.PostCrtUser=crtUser
	.;i $g(tmp("PostCrtUser"))'="" s obj.PostCrtUser=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("PostCrtUser"))
	q:Flag=0 0
	s obj.PostDesc=$g(tmp("PostDesc"))
	s obj.PostType=$g(tmp("PostType"))
	s obj.HolidayTime=$g(tmp("HolidayTime"))
	s obj.PostStTime1=$g(tmp("PostStTime1"))
	s obj.PostEndTime1=$g(tmp("PostEndTime1"))
	s obj.PostStTime2=$g(tmp("PostStTime2"))
	s obj.PostEndTime2=$g(tmp("PostEndTime2"))
	s obj.PostStTime3=$g(tmp("PostStTime3"))
	s obj.PostEndTime3=$g(tmp("PostEndTime3"))
	s obj.PostMinutes=$g(tmp("PostMinutes"))
	s obj.PostDayMinutes=$g(tmp("PostDayMinutes"))
	s obj.PostNextMinutes=$g(tmp("PostNextMinutes"))
	s obj.PostUseType=$g(tmp("PostUseType"))
	s obj.PostUseLimit=$g(tmp("PostUseLimit"))
	s obj.PostFontColor=$g(tmp("PostFontColor"))
	s obj.PostBgColor=$g(tmp("PostBgColor"))
	s obj.PostRemark=$g(tmp("PostRemark"))
	s obj.PostStatus=$g(tmp("PostStatus"))
	s obj.PostCategory=$g(tmp("PostCategory"))
	s obj.PostLevel=$g(tmp("PostLevel"))
	s obj.PostSort=$g(tmp("PostSort"))
	
	s sc=obj.%Save()
	if $$$ISOK(sc) {
		TC
		q 1
	}else{
		TRO
		d $System.Status.DisplayError(sc)
		q 0	
	}
}

/// creator: xbl
/// createdate: 20170823
/// description: 获取排班班次
/// table: DHCNMG.DB.MgArgPost
/// input:
/// output:
/// other: w ##class(web.NurMgDBComm).GetArgPost(1)
ClassMethod GetArgPost(id As %String) As %String
{
	;s ^TMP("getargpost")=id
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgArgPost).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^PostCode|"_obj.PostCode
	s ret=ret_"^PostDesc|"_obj.PostDesc
	s ret=ret_"^PostType|"_obj.PostType
	s ret=ret_"^TypeDesc|"_$case(obj.PostType,"P":"值班","H":"休假","S":"特殊",:"")
	s ret=ret_"^HolidayTime|"_obj.HolidayTime
	s ret=ret_"^TimeDesc|"_$case(obj.HolidayTime,"A":"全天","H":"半天","L":"哺乳期",:"")
	s ret=ret_"^PostStTime1|"_obj.PostStTime1
	s ret=ret_"^PostEndTime1|"_obj.PostEndTime1
	s ret=ret_"^PostStTime2|"_obj.PostStTime2
	s ret=ret_"^PostEndTime2|"_obj.PostEndTime2
	s ret=ret_"^PostStTime3|"_obj.PostStTime3
	s ret=ret_"^PostEndTime3|"_obj.PostEndTime3
	s ret=ret_"^PostMinutes|"_obj.PostMinutes
	s ret=ret_"^PostDayMinutes|"_obj.PostDayMinutes
	s ret=ret_"^PostNextMinutes|"_obj.PostNextMinutes
	s ret=ret_"^PostUseType|"_obj.PostUseType
	s ret=ret_"^UseTypeDesc|"_$case(obj.PostUseType,"H":"全院通用","A":"指定片区","L":"指定科室","W":"指定病区",:"")
	s ret=ret_"^PostUseLimit|"_obj.PostUseLimit
	s ret=ret_"^PostSort|"_obj.PostSort
	s limitdesc=""
	f i=1:1:$L(obj.PostUseLimit,",") d
	.s limitid=$P(obj.PostUseLimit,",",i)
	.q:limitid=""
	.i obj.PostUseType="A" d
	..s limit=##class(DHCNMG.DB.MgWardArea).%OpenId(limitid)
	..s limitdesc=limitdesc_limit.AreaDesc_","
	.i obj.PostUseType="L" d
	..s limit=##class(DHCNMG.DB.MgWardLoc).%OpenId(limitid)
	..s limitdesc=limitdesc_limit.LocDesc_","
	.i obj.PostUseType="W" d
	..s limit=##class(DHCNMG.DB.MgWard).%OpenId(limitid)
	..s limitdesc=limitdesc_limit.WardDesc_","
	i limitdesc'="" d
	.s ret=ret_"^UseLimitDesc|"_$E(limitdesc,1,$L(limitdesc)-1)
	s ret=ret_"^PostFontColor|"_obj.PostFontColor
	s ret=ret_"^PostBgColor|"_obj.PostBgColor
	s ret=ret_"^PostStatus|"_obj.PostStatus
	s ret=ret_"^StatusDesc|"_$Case(obj.PostStatus,"Y":"启用","N":"停用",:"")
	s ret=ret_"^PostRemark|"_obj.PostRemark
	i obj.PostCrtDate'="" s ret=ret_"^PostCrtDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.PostCrtDate)
	i obj.PostCrtTime'="" s ret=ret_"^PostCrtTime|"_$zt(obj.PostCrtTime,1)
	i obj.PostCrtUser'="" d
	.i obj.PostCrtUser=0 s ret=ret_"^PostCrtUser|0"_"^CrtUserName|管理员"
	.e  d
	..s PostCrtUser="",CrtUserName=""
	..s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.PostCrtUser)
	..q:'$IsObject(PerObj)
	..s PostCrtUser=obj.PostCrtUser
	..s CrtUserName=PerObj.PerName
	..s ret=ret_"^PostCrtUser|"_PostCrtUser
	..s ret=ret_"^CrtUserName|"_CrtUserName
	s CategoryDesc=..GetSystemParamId(obj.PostCategory,"POSTTYPE")
	s PostCategory=obj.PostCategory
	s PostLevel=obj.PostLevel
	s ret=ret_"^CategoryDesc|"_CategoryDesc_"^PostCategory|"_PostCategory_"^PostLevel|"_PostLevel
	q ret
}

ClassMethod GetSystemParamId(code, para)
{
	s desc=""
	s ParRow=$O(^DHCNMG.Set.MgSysParamI("Code"," "_$zcvt($tr(para," ",""),"U"),""))
	q:ParRow="" ""
	s RowID=$O(^DHCNMG.Set.MgSysParamSubI("Code"," "_$tr(code," ",""),ParRow,""))
	q:RowID="" ""
	s obj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(ParRow_"||"_RowID)
	q:'$IsObject(obj) ""
	s desc=obj.SubDesc
	q desc
}

/// creator: xbl
/// createdate: 20170823
/// description: 删除排班班次
/// table: DHCNMG.DB.MgArgPost
/// input:
/// output:
/// other:
ClassMethod DeleteArgPost(id As %String) As %String
{
	q:id="" ""
	q:$d(^DHCNMG.DB.MgArgWardPostI("Post",id)) "已关联病区排班,不能删除！"
	s sort=0
	s obj=##class(DHCNMG.DB.MgArgPost).%OpenId(id)
	s sort=obj.PostSort
	s sc=obj.%DeleteId(id)
	s postid="" f  s postid=$O(^DHCNMG.DB.MgArgPostI("Sort",sort+1,postid)) q:postid=""  d
	.s PostObj=##class(DHCNMG.DB.MgArgPost).%OpenId(postid)
	.s PostObj.PostSort=sort
	.s sort=sort+1
	.d PostObj.%Save()
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate:20170824
/// description:获取排班班次列表
/// table:DHCNMG.DB.MgArgPost
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgDBComm","FindArgPostList","","")
Query FindArgPostList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArgPostListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s type=$P(parr,"^",1)
	s id="" f  s id=$O(^DHCNMG.DB.MgArgPostD(id)) q:id=""  d
	s sort="" f  s sort=$O(^DHCNMG.DB.MgArgPostI("Sort",sort)) q:sort=""  d
	.s id="" f  s id=$O(^DHCNMG.DB.MgArgPostI("Sort",sort,id)) q:id=""  d
	..s obj=##class(DHCNMG.DB.MgArgPost).%OpenId(id)
	..s code=obj.PostCode
	..s desc=obj.PostDesc
	..q:(type'="")&&(obj.PostType'=type)
	..q:(input'="")&&($zcvt(desc,"U")'[$zcvt(input,"U"))
	..s ret=..GetArgPost(id)
	..d OutArgPost
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutArgPost
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArgPostListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArgPostListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArgPostListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArgPostListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator: gzj
/// Date:2018-07-02
/// Description:病区获取排班班次列表
/// Table:DHCNMG.DB.MgArgPost
/// Input:
/// Output:
/// Other: w ##class(%ResultSet).RunQuery("web.NurMgDBComm","FindPostForWard","","")
Query FindPostForWard(ward As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPostForWardExecute(ByRef qHandle As %Binary, ward As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindPostForWard")=ward
#;	s Type="" f  s Type=$O(^DHCNMG.DB.MgArgPostI("Type",Type)) q:Type=""  d
	s sort="" f  s sort=$O(^DHCNMG.DB.MgArgPostI("Sort",sort)) q:sort=""  d
	.s Row="" f  s Row=$O(^DHCNMG.DB.MgArgPostI("Sort",sort,Row)) q:Row=""  d
	..s obj=##class(DHCNMG.DB.MgArgPost).%OpenId(Row)
	..q:obj.PostStatus'="Y"
	..s usetype=obj.PostUseType
	..s uselimit=obj.PostUseLimit
	..s len=$l(uselimit,",")
	..s flag=0
	..f i=1:1:len d
	...s itm=$p(uselimit,",",i)
	...q:itm=""
	...i ((ward'="")&&(itm=ward)) s flag=1
	..q:((usetype="W")&&(flag=0))
	..s ret=..GetArgPost(Row)
	..d OutPostForWard
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPostForWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPostForWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPostForWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPostForWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPostForWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: xbl
/// createdate: 20170824
/// description: 保存病区岗位
/// table: DHCNMG.DB.MgArgWardPost
/// input:
/// output:
/// other: w ##class(web.NurMgDBComm).SaveWardPost(^TmpXBl("WardPost"))
ClassMethod SaveWardPost(parr As %String) As %String
{
	s ^TMP("SaveWardPost")=parr
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:($g(tmp("WardDR"))="")!($g(tmp("PostDR"))="") ""
	s isExistName=0
	s tRw="" f  s tRw=$O(^DHCNMG.DB.MgArgWardPostI("WardPost",$g(tmp("WardDR")),$g(tmp("PostDR")),tRw)) q:(tRw="")||(isExistName=1)  d
	.s tRwObj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(tRw)
	.q:'$IsObject(tRwObj)
	.q:tRw=$g(tmp("rw"))
	.i tRwObj.PostDesc=$g(tmp("PostDesc")) s isExistName=1
	q:isExistName=1 "名称重复"
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.DB.MgArgWardPost).%New()
	.s obj.PostCrtDate=+$h
	.s obj.PostCrtTime=$P($h,",",2)
	.i $g(tmp("PostCrtUser"))'="" s obj.PostCrtUser=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("PostCrtUser"))
	s obj.PostDesc=$g(tmp("PostDesc"))
	i $g(tmp("PostDR"))'="" s obj.PostDR=##class(DHCNMG.DB.MgArgPost).%OpenId(tmp("PostDR"))
	e  s obj.PostDR=""
	i $g(tmp("WardDR"))'="" s obj.WardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("WardDR"))
	e  s obj.WardDR=""
	s obj.PostClass=$g(tmp("PostClass"))
	s obj.PostStTime1=$g(tmp("PostStTime1"))
	s obj.PostEndTime1=$g(tmp("PostEndTime1"))
	s obj.PostStTime2=$g(tmp("PostStTime2"))
	s obj.PostEndTime2=$g(tmp("PostEndTime2"))
	s obj.PostStTime3=$g(tmp("PostStTime3"))
	s obj.PostEndTime3=$g(tmp("PostEndTime3"))
	s obj.PostMinutes=$g(tmp("PostMinutes"))
	s obj.PostDayMinutes=$g(tmp("PostDayMinutes"))
	s obj.PostNextMinutes=$g(tmp("PostNextMinutes"))
	s obj.PostRemark=$g(tmp("PostRemark"))
	i $g(tmp("PostSort"))'="" s obj.PostSort=$g(tmp("PostSort"))
	e  i $g(tmp("WardDR"))'="" s obj.PostSort=..GetWardPostSort(tmp("WardDR"))
	s obj.PostCategory=$g(tmp("PostCategory"))
	s obj.PostFactor=$g(tmp("PostFactor"))
	s sc=obj.%Save()
	d $System.Status.DisplayError(sc)
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20170825
/// description: 获取病区排班班次
/// table: DHCNMG.DB.MgArgWardPost
/// input:
/// output:
/// other: w ##class(web.NurMgDBComm).GetWardPost(1)
ClassMethod GetWardPost(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^PostDesc|"_obj.PostDesc
	i obj.WardDR'="" d
	.s ret=ret_"^WardDR|"_obj.WardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.WardDR.WardDesc
	i obj.PostDR'="" d
	.s ret=ret_"^PostDR|"_obj.PostDR.%Id()
	.s ret=ret_"^PostDesc2|"_obj.PostDR.PostDesc
	.s ret=ret_"^PostType|"_obj.PostDR.PostType
	.s ret=ret_"^TypeDesc|"_$case(obj.PostDR.PostType,"P":"值班","H":"休假","S":"特殊",:"")
	.s ret=ret_"^HolidayTime|"_obj.PostDR.HolidayTime
	.s ret=ret_"^TimeDesc|"_$case(obj.PostDR.HolidayTime,"A":"全天","H":"半天","L":"哺乳期",:"")
	s ret=ret_"^PostClass|"_obj.PostClass
	s ret=ret_"^PostStTime1|"_obj.PostStTime1
	s ret=ret_"^PostEndTime1|"_obj.PostEndTime1
	s ret=ret_"^PostStTime2|"_obj.PostStTime2
	s ret=ret_"^PostEndTime2|"_obj.PostEndTime2
	s ret=ret_"^PostStTime3|"_obj.PostStTime3
	s ret=ret_"^PostEndTime3|"_obj.PostEndTime3
	s ret=ret_"^PostMinutes|"_obj.PostMinutes
	s ret=ret_"^PostDayMinutes|"_obj.PostDayMinutes
	s ret=ret_"^PostNextMinutes|"_obj.PostNextMinutes
	s ret=ret_"^PostRemark|"_obj.PostRemark
	s ret=ret_"^PostSort|"_obj.PostSort
	i obj.PostCrtDate'="" s ret=ret_"^PostCrtDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.PostCrtDate)
	i obj.PostCrtTime'="" s ret=ret_"^PostCrtTime|"_$zt(obj.PostCrtTime,1)
	i obj.PostCrtUser'="" d
	.s ret=ret_"^PostCrtUser|"_obj.PostCrtUser.%Id()
	.s ret=ret_"^CrtUserName|"_obj.PostCrtUser.PerName
	s PostLevel=""
	i obj.PostDR'="" d
	.s postobj=##class(DHCNMG.DB.MgArgPost).%OpenId(obj.PostDR.%Id())
	.b ;01
	.q:'$IsObject(postobj)
	.s PostLevel=postobj.PostLevel
	s ret=ret_"^PostLevel|"_PostLevel
	s PostFactor=obj.PostFactor
	s ret=ret_"^PostFactor|"_PostFactor
	q ret
}

ClassMethod GetWardPost2(ward As %String, post As %String) As %String
{
	q:(ward="")!(post="") ""
	s id=$O(^DHCNMG.DB.MgArgWardPostI("WardPost",ward,post,""))
	q:id="" ""
	s ret=..GetWardPost(id)
	q ret
}

/// creator: xbl
/// createdate: 20170825
/// description: 删除病区排班班次
/// table: DHCNMG.DB.MgArgWardPost
/// input:
/// output:
/// other:
ClassMethod DeleteWardPost(id As %String) As %String
{
	q:id="" ""
	q:$d(^DHCNMG.Arg.MgArrangeSubI("Post",id)) "已被使用不可删除"
	s obj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(id)
	s ward=obj.WardDR.%Id()
	s sc=obj.%DeleteId(id)
	d ..GetWardPostSort(ward)
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20170825
/// description: 删除病区排班班次
/// table: DHCNMG.DB.MgArgWardPost
/// input:
/// output:
/// other:
ClassMethod DeleteWardPost2(parr As %String) As %String
{
	q:parr="" ""
	s ward=$P(parr,"^",1)
	s post=$P(parr,"^",2)
	q:(ward="")||(post="") ""
	s id=$O(^DHCNMG.DB.MgArgWardPostI("WardPost",ward,post,""))
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(id)
	s ward=obj.WardDR.%Id()
	s sc=obj.%DeleteId(id)
	d ..GetWardPostSort(ward)
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20170825
/// description: 移动病区排班班次
/// table: DHCNMG.DB.MgArgWardPost
/// input:
/// output:
/// other: w ##class(web.NurMgDBComm).SortWardPost("2","1")
ClassMethod SortWardPost(id1 As %String, id2 As %String) As %String
{
	;s ^tmpXbl("SortWardPost")=id1_"^"_id2
	q:(id1="")!(id2="") 0
	s obj1=##class(DHCNMG.DB.MgArgWardPost).%OpenId(id1)
	s obj2=##class(DHCNMG.DB.MgArgWardPost).%OpenId(id2)
	s order=obj1.PostSort
	s obj1.PostSort=obj2.PostSort
	s obj2.PostSort=order
	s sc1=obj1.%Save()
	s sc2=obj2.%Save()
	q $$$ISOK(sc1)&&$$$ISOK(sc2)
}

/// creator: xbl
/// createdate: 20170825
/// description: 获取病区排班班次最大序号
/// table: DHCNMG.DB.MgArgWardPost
/// input:
/// output:
/// other: w ##class(web.NurMgDBComm).GetWardPostSort(1)
ClassMethod GetWardPostSort(warddr As %String) As %String
{
	q:warddr="" 0
	s order=1
	s sort="" f  s sort=$O(^DHCNMG.DB.MgArgWardPostI("WardSort",warddr,sort)) q:sort=""  d
	.s id="" f  s id=$O(^DHCNMG.DB.MgArgWardPostI("WardSort",warddr,sort,id)) q:id=""  d
	..s tmp(order)=id
	..s order=order+1
	s num="" f  s num=$O(tmp(num)) q:num=""  d
	.s id=tmp(num)
	.s obj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(id)
	.s obj.PostSort=num
	.d obj.%Save()
	q order
}

/// creator: xbl
/// createdate: 20170825
/// description: 查询病区排班班次列表
/// table: DHCNMG.MgArgWardPost
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgDBComm","FindWardPostList","^1^H")
Query FindWardPostList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardPostListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("postward")=parr_"%"_input //^1^H%
	s postdr=$P(parr,"^",1)
	s warddr=$P(parr,"^",2)
	s type=$P(parr,"^",3)
	i (postdr="")&&(warddr="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	i postdr'="" d
	.s id="" f  s id=$O(^DHCNMG.DB.MgArgWardPostI("Post",postdr,id)) q:id=""  d
	..s obj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(id)
	..q:(warddr'="")&&(obj.WardDR'="")&&(warddr'=obj.WardDR.%Id())
	..q:obj.PostDR.PostStatus'="Y"
	..s ret=..GetWardPost(id)
	..d OutWardPost
	e  d
	.s sort="" f  s sort=$O(^DHCNMG.DB.MgArgWardPostI("WardSort",warddr,sort)) q:sort=""  d
	..s id="" f  s id=$O(^DHCNMG.DB.MgArgWardPostI("WardSort",warddr,sort,id)) q:id=""  d
	...s obj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(id)
	...q:obj.PostDR.PostStatus'="Y"
	...s posttype=obj.PostDR.PostType
	...q:(type'="")&&(type'=posttype)
	...s ret=..GetWardPost(id)
	...d OutWardPost
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardPost
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardPostListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardPostListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardPostListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardPostListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: xbl
/// createdate: 20170825
/// description: 楼层设置
/// table: DHCNMG.DB.MgFloor
/// input:
/// output:
/// other:
ClassMethod SaveFloor(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=..IsExistFloor(parr)
	q:flag=1 "此代码已存在！"
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.DB.MgFloor).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.DB.MgFloor).%New()
	s obj.FloorCode=$g(tmp("FloorCode"))
	s obj.FloorDesc=$g(tmp("FloorDesc"))
	s obj.FloorShort=$g(tmp("FloorShort"))
	s obj.FloorRemark=$g(tmp("FloorRemark"))
	s obj.FloorStatus=$g(tmp("FloorStatus"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:gzj
/// CreateDate:2019-02-22
/// Description:判断记录是否存在
/// Table:
/// Input:
/// Output:
/// Return:0 不存在 1 存在
/// Other:
ClassMethod IsExistFloor(parr As %String) As %String
{
	s ^TMP("IsExistFloor")=parr
	q:parr="" ""
	s flag=0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	s FloorCode=$zcvt($tr($g(tmp("FloorCode"))," ",""),"U")
	s id=$o(^DHCNMG.DB.MgFloorI("Code"," "_FloorCode,""))
	i id="" d
	.s flag=0
	e  i id'="" d
	.i rw="" s flag=1
	.e  i rw'="" d
	..i rw'=id s flag=1
	..e  s flag=0
	q flag
}

/// creator: xbl
/// createdate: 20170825
/// description: 楼层设置
/// table: DHCNMG.DB.MgFloor
/// input:
/// output:
/// other:
ClassMethod GetFloor(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgFloor).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^FloorCode|"_obj.FloorCode
	s ret=ret_"^FloorDesc|"_obj.FloorDesc
	s ret=ret_"^FloorShort|"_obj.FloorShort
	s ret=ret_"^FloorRemark|"_obj.FloorRemark
	s ret=ret_"^FloorStatus|"_obj.FloorStatus
	s ret=ret_"^StatusDesc|"_$case(obj.FloorStatus,"Y":"启用","N":"停用",:"")
	s wards="",warddescs=""
	f i=1:1:obj.FloorWards.Count() d
	.s ward=obj.FloorWards.GetAt(i)
	.q:ward=""
	.s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	.q:'$IsObject(wardobj)
	.i wards="" s wards=ward,warddescs=wardobj.WardDesc
	.e  s wards=wards_","_ward,warddescs=warddescs_","_wardobj.WardDesc
	s ret=ret_"^FloorWards|"_wards
	s ret=ret_"^WardDescs|"_warddescs
	q ret
}

/// 获取楼层病区
ClassMethod GetFloorWards(floors As %String) As %String
{
	q:floors="" ""
	s ret=""
	f i=1:1:$L(floors,",") d
	.s id=$P(floors,",",i)
	.q:id=""
	.s obj=##class(DHCNMG.DB.MgFloor).%OpenId(id)
	.f j=1:1:obj.FloorWards.Count() d
	..s ward=obj.FloorWards.GetAt(j)
	..q:(ward="")||($g(tmp(ward))'="")
	..s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	..s tmp(ward)=wardobj.WardDesc
	..i ret="" s ret=ward_"|"_wardobj.WardDesc
	..e  s ret=ret_"^"_ward_"|"_wardobj.WardDesc
	q ret
}

/// creator: xbl
/// createdate: 20170825
/// description: 楼层设置
/// table: DHCNMG.DB.MgFloor
/// input:
/// output:
/// other:
ClassMethod DeleteFloor(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgFloor).%OpenId(id)
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20170825
/// description: 获取楼层
/// table: DHCNMG.DB.MgFloor
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgDBComm","FindFloorList","","")
Query FindFloorList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindFloorListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s id="" f  s id=$O(^DHCNMG.DB.MgFloorD(id)) q:id=""  d
	.s obj=##class(DHCNMG.DB.MgFloor).%OpenId(id)
	.s code=obj.FloorCode
	.s desc=obj.FloorDesc
	.q:(input'="")&&($zcvt(code_desc,"U")'[$zcvt(input,"U"))
	.s ret=..GetFloor(id)
	.d OutFloor
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutFloor
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindFloorListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFloorListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindFloorListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFloorListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 保存楼层关联病区
ClassMethod SaveFloorWard(id As %String, wards As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.DB.MgFloor).%OpenId(id)
	d obj.FloorWards.Clear()
	f i=1:1:$L(wards,",") d
	.s ward=$P(wards,",",i)
	.q:ward=""
	.d obj.FloorWards.Insert(ward)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator:xbl
/// createdate:20170831
/// description:保存病区岗位分组
/// table: DHCNMG.DB.MgWardPostGroup
/// input:
/// output:
/// other:
ClassMethod SavePostGroup(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.DB.MgWardPostGroup).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.DB.MgWardPostGroup).%New()
	.s obj.GroupStatus="Y"
	s obj.GroupCode=$g(tmp("GroupCode"))
	s obj.GroupDesc=$g(tmp("GroupDesc"))
	i $g(tmp("WardDR"))'="" d
	.s obj.WardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("WardDR"))
	e  s obj.WardDR=""
	d obj.GroupPosts.Clear()
	f i=1:1:$L(tmp("GroupPosts")) d
	.s postdr=$P(tmp("GroupPosts"),",",i)
	.q:postdr=""
	.d obj.GroupPosts.Insert(postdr)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20170831
/// description: 获取排版分组
/// table:DHCNMG.DB.MgWardPostGroup
/// input:
/// output:
/// other:
ClassMethod GetPostGroup(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgWardPostGroup).%OpenId(id)
	s ret="rw|"_id
	i obj.WardDR'="" d
	.s ret=ret_"^WardDR|"_obj.WardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.WardDR.WardDesc
	s ret=ret_"^GroupCode|"_obj.GroupCode
	s ret=ret_"^GroupDesc|"_obj.GroupDesc
	s grpposts="",postdesc=""
	f i=1:1:obj.GroupPosts.Count() d
	.s postdr=obj.GroupPosts.GetAt(i)
	.q:postdr=""
	.s postobj=##class(DHCNMG.DB.MgArgPost).%OpenId(postdr)
	.i grpposts="" s grpposts=postdr,postdesc=postobj.PostDesc
	.e  s grpposts=grpposts_","_postdr,postdesc=postdesc_","_postobj.PostDesc
	s ret=ret_"^GroupPosts|"_grpposts
	s ret=ret_"^PostDesc|"_postdesc
	q ret
}

/// creator: xbl
/// createdate: 20170831
/// description: 删除班次分组
/// table: DHCNMG.DB.MgWardPostGroup
/// input:
/// output:
/// other:
ClassMethod DeletePostGroup(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgWardPostGroup).%OpenId(id)
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

///  creator: xbl
///  createdate: 20170831
///  description: 获取班次分组列表
///  table: DHCNMG.DB.MgWardPostGroup
///  input:
///  output:
///  other:
Query FindPostGroupList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPostGroupListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$p(parr,"^",1)
	i ward="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s id="" f  s id=$O(^DHCNMG.DB.MgWardPostGroupI("Ward",ward,id)) q:id=""  d
	.s obj=##class(DHCNMG.DB.MgWardPostGroup).%OpenId(id)
	.s code=obj.GroupCode
	.s desc=obj.GroupDesc
	.q:(input'="")&&($zcvt(code_desc,"U")'[$zcvt(input,"U"))
	.s ret=..GetPostGroup(id)
	.d OutPostGroup
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPostGroup
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPostGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPostGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPostGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPostGroupListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: xbl
/// createdate: 20170914
/// description: 保存科室所辖病区
/// table:DHCNMG.DB.MgWard
/// input:
/// output:
/// other:
ClassMethod SaveLocWard(locs As %String, wards As %String) As %String
{
	;q:(locid="")!(wards="") 0
	q:(locs="")!(wards="") 0
	s insertId=locs,finds=wards
	s:$L(locs,",")>1 finds=locs,insertId=wards
	f i=1:1:$L(finds,",") d
	.s id=$p(finds,",",i)
	.q:id=""
	.s obj=##class(DHCNMG.DB.MgWardLocUnit).%New()
	.i $L(locs,",")>1 d
	..s obj.UnitLocDR=id
	..s obj.UnitWardDR=insertId
	.e  d
	..s obj.UnitLocDR=insertId
	..s obj.UnitWardDR=id
	.s obj.UnitDesc=""
	.s sc=obj.%Save()
	
#;	s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Loc",locid,id)) q:id=""  d
#;	.q:(","_wards_",")[(","_id_",")
#;	.s obj=##class(DHCNMG.DB.MgWard).%OpenId(id)
#;	.s obj.WardLocDR=""
#;	.d obj.%Save()
#;	f i=1:1:$L(wards,",") d
#;	.s ward=$P(wards,",",i)
#;	.q:ward=""
#;	.s obj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
#;	.s obj.WardLocDR=locObj
#;	.d obj.%Save()
	
	q 1
}

/// creator: llin
/// createdate: 2018-08-06
/// description: 删除科室所辖病区
/// table:DHCNMG.DB.MgWardLocUnit
/// input:
/// output:
/// other:
ClassMethod DeleteLocWard(parr As %String) As %String
{
	;q:(locid="")!(wards="") 0
	q:(parr="") 0
	f i=1:1:$l(parr,",") d
	.s obj=##class(DHCNMG.DB.MgWardLocUnit).%OpenId($p(parr,",",i))
	.q:'$IsObject(obj)
	.s sc=obj.%DeleteId(obj.%Id())
	q 1
}

/// creator: xbl
/// createdate: 20170914
/// description: 获取科室所辖病区id
/// table: DHCNMG.DB.MgWard
/// input: 
/// output:
/// other:
ClassMethod GetLocWard(locid As %String) As %String
{
	q:locid="" 0
	s ret=""
	s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Loc",locid,id)) q:id=""  d
	.i ret="" s ret=id
	.e  s ret=ret_","_id
	q ret
}

///  Creator: llin
///  Createdate: 2018-08-06
///  Description: 获取科室病区关联列表
///  Table: DHCNMG.DB.MgWardLocUnit,DHCNMG.DB.MgWard,DHCNMG.Db.MgWardLoc
///  Input:
///  Output:
///  Other:
Query FindWardLockUnitList(locid As %String = "", wardid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardLockUnitListExecute(ByRef qHandle As %Binary, locid As %String = "", wardid As %String = "") As %Status
{
	s ^TMPLL("WardLockUnitList")=locid_"%"_wardid
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	i (locid="")&&(wardid=""){
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
	s typ="Loc",findId=locid
	s:wardid'="" typ="Ward",findId=wardid
	b ;22
	s nextId=""  f  s nextId=$O(^DHCNMG.DB.MgWardLocUnitI(typ,findId,nextId)) q:nextId=""  d
	.s id=""  f  s id=$O(^DHCNMG.DB.MgWardLocUnitI(typ,findId,nextId,id)) q:id=""  d
	..s obj=##class(DHCNMG.DB.MgWardLocUnit).%OpenId(id)
	..s locObj=##class(DHCNMG.DB.MgWardLoc).%OpenId(obj.UnitLocDR)
	..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.UnitWardDR)
	..q:('$IsObject(locObj))||('$IsObject(wardObj))
	..s ret="wardDesc|"_wardObj.WardDesc_"^locDesc|"_locObj.LocDesc_"^wardDR|"_obj.UnitWardDR_"^locDR|"_obj.UnitLocDR_"^rw|"_id
	..d OutWardLockUnitData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardLockUnitData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardLockUnitListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardLockUnitListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardLockUnitListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardLockUnitListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: xbl
/// createdate: 20170925
/// description: 保存调查项目
/// table: DHCNMG.DB.MgSurveyItem
/// input:
/// output:
/// return:
/// other: w ##class(web.NurMgDBComm).SaveSurveyItem(^TmpXbl("SurveyItem"))
ClassMethod SaveSurveyItem(parr As %String) As %String
{
	s ^TMP("SaveSurveyItem")=parr
	//ItemCode|护士满意度调查^ItemDesc|护士满意度调查^ItemTypeDR|9__2^ItemUseType|H
	//^ItemUseDR|^ItemStDate|2020-02-04^ItemEndDate|^ItemRemark|^rw|6^ItemResultType|^
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=..IsExistSurvey(parr)
	q:flag=-1 "记录已经存在，保存失败"
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.DB.MgSurveyItem).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.DB.MgSurveyItem).%New()
	s obj.ItemCode=$g(tmp("ItemCode"))
	s obj.ItemDesc=$g(tmp("ItemDesc"))
	i $g(tmp("ItemTypeDR"))'="" d
	.s obj.ItemTypeDR=##Class(DHCNMG.Set.MgSysParamSub).%OpenId(tmp("ItemTypeDR"))
	e  s obj.ItemTypeDR=""
	s obj.ItemUseType=$g(tmp("ItemUseType"))
	s obj.ItemUseDR=$g(tmp("ItemUseDR"))
	s obj.ItemRemark=$g(tmp("ItemRemark"))
	i $g(tmp("ItemStDate"))'="" s obj.ItemStDate=$zdh(tmp("ItemStDate"),3)
	e  s obj.ItemStDate=""
	i $g(tmp("ItemEndDate"))'="" s obj.ItemEndDate=$zdh(tmp("ItemEndDate"),3)
	e  s obj.ItemEndDate=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod IsExistSurvey(parr As %String) As %String
{
	q:parr="" 0
	s flag=0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	s id=$o(^DHCNMG.DB.MgSurveyItemI("Code"," "_$zcvt($tr($g(tmp("ItemCode"))," ",""),"U"),""))
	i rw="" d
	.i id'="" s flag=-1
	e  d
	.i ((id'="")&&(id'=rw)) s flag=-1
	q flag
}

/// creator: xbl
/// createdate: 20170925
/// description: 获取调查项目
/// table: DHCNMG.DB.MgSurveyItem
/// input:
/// output:
/// return:
/// other: w ##class(web.NurMgDBComm).GetSurveyItem(1)
ClassMethod GetSurveyItem(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgSurveyItem).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^ItemCode|"_obj.ItemCode
	s ret=ret_"^ItemDesc|"_obj.ItemDesc
	i obj.ItemTypeDR'="" d
	.s ret=ret_"^ItemTypeDR|"_$tr(obj.ItemTypeDR.%Id(),"||","__")
	.s ret=ret_"^TypeDesc|"_obj.ItemTypeDR.SubDesc
	s ret=ret_"^ItemUseType|"_obj.ItemUseType
	s ret=ret_"^UseTypeDesc|"_$case(obj.ItemUseType,"H":"全院通用","A":"指定片区","L":"指定科室","W":"指定病区",:"")
	i obj.ItemUseDR'="" d
	.q:obj.ItemUseType="H"
	.s ret=ret_"^ItemUseDR|"_obj.ItemUseDR
	.s usedesc=""
	.f i=1:1:$L(obj.ItemUseDR,",") d
	..s usedr=$P(obj.ItemUseDR,",",i)
	..q:usedr=""
	..i obj.ItemUseType="A" d
	...s useobj=##class(DHCNMG.DB.MgWardArea).%OpenId(usedr)
	...q:'$IsObject(useobj)
	...i usedesc="" s usedesc=useobj.AreaDesc
	...e  s usedesc=usedesc_","_useobj.AreaDesc
	..i obj.ItemUseType="L" d
	...s useobj=##class(DHCNMG.DB.MgWardLoc).%OpenId(usedr)
	...q:'$IsObject(useobj)
	...i usedesc="" s usedesc=useobj.LocDesc
	...e  s usedesc=usedesc_","_useobj.LocDesc
	..i obj.ItemUseType="W" d
	...s useobj=##class(DHCNMG.DB.MgWard).%OpenId(usedr)
	...q:'$IsObject(useobj)
	...i usedesc="" s usedesc=useobj.WardDesc
	...e  s usedesc=usedesc_","_useobj.WardDesc
	.s ret=ret_"^UseDesc|"_$g(usedesc)
	s ret=ret_"^ItemRemark|"_obj.ItemRemark
	i obj.ItemStDate'="" s ret=ret_"^ItemStDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.ItemStDate)
	i obj.ItemEndDate'="" s ret=ret_"^ItemEndDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.ItemEndDate)
	q ret
}

/// creator: xbl
/// createdate: 20170925
/// description: 删除调查项目
/// table: DHCNMG.DB.MgSurveyItem
/// input:
/// output:
/// return:
/// other: 
ClassMethod DeleteSurveyItem(id As %String) As %String
{
	q:id="" 0
	s sc=##class(DHCNMG.DB.MgSurveyItem).%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20170925
/// description: 获取调查项目列表
/// table: DHCNMG.DB.MgSurveyItem
/// input:
/// output:
/// return:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgDBComm","FindSurveyItem","")
Query FindSurveyItem(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSurveyItemExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s typdr=$tr($p(parr,"^",1),"__","||")
	s id="" f  s id=$O(^DHCNMG.DB.MgSurveyItemD(id)) q:id=""  d
	.s obj=##class(DHCNMG.DB.MgSurveyItem).%OpenId(id)
	.q:(typdr'="")&&(obj.ItemTypeDR'="")&&(typdr'=obj.ItemTypeDR.%Id())
	.s ret=..GetSurveyItem(id)
	.d OutSurveyItem
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSurveyItem
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSurveyItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSurveyItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSurveyItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSurveyItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: xbl
/// createdate: 20170925
/// description: 保存调查项目明细
/// table: DHCNMG.DB.MgSurveyItemSub
/// input:
/// output:
/// return:
/// other: 
ClassMethod SaveSurveyItmSub(parr As %String) As %String
{
	;s ^TmpXbl("SurveyItem")=parr
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:($g(tmp("Parref"))="") 0
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.DB.MgSurveyItemSub).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.DB.MgSurveyItemSub).%New()
	.s obj.Parref=##class(DHCNMG.DB.MgSurveyItem).%OpenId(tmp("Parref"))
	s obj.ItemCode=$g(tmp("ItemCode"))
	s obj.ItemDesc=$g(tmp("ItemDesc"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20170925
/// description: 获取调查项目明细
/// table: DHCNMG.DB.MgSurveyItemSub
/// input:
/// output:
/// return:
/// other:
ClassMethod GetSurveyItmSub(id As %String) As %String
{
	q:id="" ""
	s id=$tr(id,"__","||")
	s obj=##class(DHCNMG.DB.MgSurveyItemSub).%OpenId(id)
	s ret="rw|"_$tr(id,"||","__")
	s ret=ret_"^Parref|"_$tr(obj.Parref.%Id(),"||","__")
	s ret=ret_"^ItemCode|"_obj.ItemCode
	s ret=ret_"^ItemDesc|"_obj.ItemDesc
	q ret
}

/// creator: xbl
/// createdate: 20170925
/// description: 删除调查项目明细
/// table: DHCNMG.DB.MgSurveyItemSub
/// input:
/// output:
/// return:
/// other:
ClassMethod DeleteSurveyItmSub(id As %String) As %String
{
	q:id="" 0
	s id=$tr(id,"__","||")
	s sc=##Class(DHCNMG.DB.MgSurveyItemSub).%DeleteId(id)
	q $$$ISOK(sc)
}

///  creator: xbl
///  createdate: 20170925
///  description: 获取调查项目明细列表
///  table: DHCNMG.DB.MgSurveyItemSub
///  input:
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgDBComm","FindSurveyItmSub","1")
Query FindSurveyItmSub(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSurveyItmSubExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s parid=$p(parr,"^",1)
	s id="" f  s id=$O(^DHCNMG.DB.MgSurveyItemSubD(parid,id)) q:id=""  d
	.s obj=##class(DHCNMG.DB.MgSurveyItemSub).%OpenId(id)
	.s ret=..GetSurveyItmSub(parid_"||"_id)
	.d OutSurveyItemSub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSurveyItemSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSurveyItmSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSurveyItmSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSurveyItmSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSurveyItmSubExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: xbl
/// createdate: 20171010
/// description: 保存调查评分标准
/// table: DHCNMG.DB.MgSurveyStandard
/// input:
/// output:
/// return:
/// other:
ClassMethod SaveSurveyStandard(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.DB.MgSurveyStandard).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.DB.MgSurveyStandard).%New()
	.s obj.Parref=##class(DHCNMG.DB.MgSurveyItem).%OpenId($g(tmp("Parref")))
	s obj.StandardDesc=$g(tmp("StandardDesc"))
	s obj.StandardScore=$g(tmp("StandardScore"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20171010
/// description: 获取调查评分标准
/// table: DHCNMG.DB.MgSurveyStandard
/// input:
/// output:
/// return:
/// other:
ClassMethod GetSurveyStandard(id As %String) As %String
{
	q:id="" 0
	s id=$tr(id,"_","|")
	s obj=##class(DHCNMG.DB.MgSurveyStandard).%OpenId(id)
	s ret="rw|"_$tr(id,"|","_")
	s ret=ret_"^Parref|"_obj.Parref.%Id()
	s ret=ret_"^StandardDesc|"_obj.StandardDesc
	s ret=ret_"^StandardScore|"_obj.StandardScore
	q ret
}

/// creator: xbl
/// createdate: 20171010
/// description: 删除调查评分标准
/// table: DHCNMG.DB.MgSurveyStandard
/// input:
/// output:
/// return:
/// other:
ClassMethod DeleteSurveyStandard(id As %String) As %String
{
	q:id="" 0
	s id=$tr(id,"_","|")
	s sc=##class(DHCNMG.DB.MgSurveyStandard).%DeleteId(id)
	q $$$ISOK(sc)
}

///  creator: xbl
///  createdate: 20171010
///  description: 获取调查评分标准列表
///  table: DHCNMG.DB.MgSurveyStandard
///  input:
///  output:
///  return:
///  other:
Query FindSurveyStandard(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSurveyStandardExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s parid=$p(parr,"^",1)
	s id="" f  s id=$O(^DHCNMG.DB.MgSurveyStandardD(parid,id)) q:id=""  d
	.s obj=##class(DHCNMG.DB.MgSurveyStandard).%OpenId(id)
	.s ret=..GetSurveyStandard(parid_"||"_id)
	.d OutSurveyStandard
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSurveyStandard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSurveyStandardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSurveyStandardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSurveyStandardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSurveyStandardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: 
/// createdate: 2017-11-20
/// description: 获取片区所辖科室id
/// table: DHCNMG.DB.MgWardLoc
/// input: 
/// output:
/// other:
ClassMethod GetAreaLoc(areaid As %String) As %String
{
	q:areaid="" 0
	s ret=""
	s id="" f  s id=$O(^DHCNMG.DB.MgWardLocI("Area",areaid,id)) q:id=""  d
	.i ret="" s ret=id
	.e  s ret=ret_","_id
	q ret
}

/// creator: guozj
/// createdate: 2017-11-20
/// description: 保存片区所辖科室
/// table:DHCNMG.DB.MgWardLoc
/// input:
/// output:
/// other:
ClassMethod SaveAreaLoc(areaid As %String, locs As %String) As %String
{
	;s ^TMP("savearealoc")=areaid_"&&"_locs
	;q:(areaid="")!(locs="") 0
	q:areaid="" 0
	s areaObj=##class(DHCNMG.DB.MgWardArea).%OpenId(areaid)
	
	s id="" f  s id=$O(^DHCNMG.DB.MgWardLocI("Area",areaid,id)) q:id=""  d
	.q:(","_locs_",")[(","_id_",")
	.s obj=##class(DHCNMG.DB.MgWardLoc).%OpenId(id)
	.s obj.LocAreaDR=""
	.d obj.%Save()
	f i=1:1:$L(locs,",") d
	.s loc=$P(locs,",",i)
	.q:loc=""
	.s obj=##class(DHCNMG.DB.MgWardLoc).%OpenId(loc)
	.s obj.LocAreaDR=areaObj
	.d obj.%Save()
	q 1
}

/// Creator: lulin
/// CreatDate: 2017-12-13
/// Description: 保存量化评分配置
/// Table：DHCNMG.DB.MgInternScore
/// Input：
/// Return： 
ClassMethod SaveInternScore(parr As %String) As %String
{
	s ^TMP("SaveInternScore")=parr
	//SubCode|^SubDesc|^SubScore|^ScoreStDate|2017-12-20^ScoreEndDate|^SubPerDR|^parref|^rw|1^ScoreCode|态度^ScoreDesc|态度^
	q:parr="" ""
	
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=..IsExistInternScore(parr)
	q:flag=-1 "记录已经存在，保存失败"
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.DB.MgInternScore).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.DB.MgInternScore).%New()
	s obj.ScoreCode=tmp("ScoreCode")
	s obj.ScoreDesc=tmp("ScoreDesc")
	i $g(tmp("ScorePerDR"))'="" d
	.s obj.ScorePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("ScorePerDR"))
	e  s obj.ScorePerDR=""
	i $g(tmp("ScoreStDate"))'="" s obj.ScoreStDate=$zdh(tmp("ScoreStDate"),3)
	e  s obj.ScoreStDate=""
	i $g(tmp("ScoreEndDate"))'="" s obj.ScoreEndDate=$zdh(tmp("ScoreEndDate"),3)
	e  s obj.ScoreEndDate=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod IsExistInternScore(parr As %String) As %String
{
	q:parr="" 0
	s flag=0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	s id=$o(^DHCNMG.DB.MgInternScoreI("flag"," "_$zcvt($tr($g(tmp("ScoreCode"))," ",""),"U"),""))
	i rw="" d
	.i id'="" s flag=-1
	e  d
	.i ((id'="")&&(rw'=id)) s flag=-1
	q flag
}

///  creator: lulin
///  createdate: 2017年12月13日 11:34:27
///  description: 根据id获取量化评分配置
///  table: DHCNMG.DB.MgInternScore
///  input:
///  output:
///  return:
///  other: d ##class(web.NurMgDBComm).InternScoreGetValue("")
ClassMethod GetInternScore(id) As %String
{
	q:id="" 0
	s ret=""
	s obj=##class(DHCNMG.DB.MgInternScore).%OpenId(id)
	s ScoreCode=obj.ScoreCode
	s ScoreDesc=obj.ScoreDesc
	i obj.ScoreStDate'="" s ScoreStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ScoreStDate)
	e  s ScoreStDate=""
	i obj.ScoreEndDate'="" s ScoreEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ScoreEndDate)
	e  s ScoreEndDate=""
	
	i obj.ScorePerDR'="" s ScorePerDR=obj.ScorePerDR.%Id(),ScorePerName=obj.ScorePerDR.PerName
	e  s ScorePerDR="",ScorePerName=""
	s ret="ScoreCode|"_ScoreCode_"^ScoreDesc|"_ScoreDesc_"^ScoreStDate|"_ScoreStDate_"^ScoreEndDate|"_ScoreEndDate_"^ScorePerDR|"_ScorePerDR_"^ScorePerName|"_ScorePerName_"^rw|"_id
	q ret
}

///  creator: lulin
///  createdate: 2017年12月13日 10:50:32
///  description: 获取量化评分配置
///  table: DHCNMG.DB.MgInternScore
///  input:
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgDBComm","FindInternScore")
Query FindInternScore() As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindInternScoreExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s id=0 f  s id=$O(^DHCNMG.DB.MgInternScoreD(id)) q:id=""  d
	.s ret=..GetInternScore(id)
	.d OutInternScore
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutInternScore
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInternScoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInternScoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindInternScoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInternScoreExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator: lulin
/// CreatDate: 2017年12月13日 14:35:00
/// Description: 保存量化评分明细表
/// Table：DHCNMG.DB.MgInternScore
/// Input：
/// Return： 
ClassMethod SaveInternScoreSub(parr As %String) As %String
{
	q:parr="" ""
	s ^TMP("SaveInternScoreSub")=parr
	//SubCode|诚信^SubDesc|诚信^SubScore|10^ScoreStDate|2020-02-01^ScoreEndDate|^SubPerDR|^parref|1^rw|1__1^
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.DB.MgInternScoreSub).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.DB.MgInternScoreSub).%New()
	.s obj.Parref=##class(DHCNMG.DB.MgInternScore).%OpenId(tmp("parref"))
	s obj.SubCode=tmp("SubCode")
	s obj.SubDesc=tmp("SubDesc")
	s obj.SubScore=tmp("SubScore")
	i $g(tmp("SubPerDR"))'="" d
	.s obj.SubPerDR=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("SubPerDR"))
	e  s obj.SubPerDR=""
	i $g(tmp("SubStDate"))'="" s obj.SubStDate=$zdh(tmp("SubStDate"),3)
	e  s obj.SubStDate=""
	i $g(tmp("SubEndDate"))'="" s obj.SubEndDate=$zdh(tmp("SubEndDate"),3)
	e  s obj.SubEndDate=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

///  creator: lulin
///  createdate: 2017年12月13日 14:42:36
///  description: 根据id获取量化评分明细配置
///  table: DHCNMG.DB.MgInternScoreSub
///  input:
///  output:
///  return:
///  other: d ##class(web.NurMgDBComm).GetInternScoreSub("1||1")
ClassMethod GetInternScoreSub(id) As %String
{
	s ^TMP("GetInternScoreSub")=id
	q:id="" 0
	s ret=""
	s obj=##class(DHCNMG.DB.MgInternScoreSub).%OpenId(id)
	s SubCode=obj.SubCode
	s SubDesc=obj.SubDesc
	s SubScore=obj.SubScore
	s parref=obj.Parref.%Id()
	i obj.SubStDate'="" s SubStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubStDate)
	e  s SubStDate=""
	i obj.SubEndDate'="" s SubEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubEndDate)
	e  s SubEndDate=""
	i obj.SubPerDR'="" s SubPerDR=obj.SubPerDR.%Id(),SubPerName=obj.SubPerDR.PerName
	e  s SubPerDR="",SubPerName=""
	s ret="SubCode|"_SubCode_"^SubDesc|"_SubDesc_"^SubScore|"_SubScore_"^SubStDate|"_SubStDate_"^SubEndDate|"_SubEndDate_"^SubPerDR"_SubPerDR_"^SubPerName"_SubPerName_"^parref|"_parref_"^rw|"_$p(id,"||",2)
	q ret
}

///  creator: lulin
///  createdate: 2017年12月13日 10:50:32
///  description: 获取量化评分配置
///  table: DHCNMG.DB.MgInternScore
///  input:
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgDBComm","FindInternScoreSub","1")
Query FindInternScoreSub(parr As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindInternScoreSubExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindInternScoreSub")=parr
	i parr="" Set qHandle=$lb(0,repid,0) q $$$OK
	s id=0 f  s id=$O(^DHCNMG.DB.MgInternScoreSubD(parr,id)) q:id=""  d
	.s ret=..GetInternScoreSub(parr_"||"_id)
	.d OutInternScore
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutInternScore
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInternScoreSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInternScoreSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindInternScoreSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInternScoreSubExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取公共代码子表信息的sort信息
ClassMethod GetSortSetCode(RowID As %String) As %String
{
	q:RowID="" "0"
	s sort=0
	s obj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(RowID)
	q:'$IsObject(obj) "0"
	s sort=obj.SubSort
	q sort
}

/// creator: lulin
/// createdate: 2018-06-28
/// description: 查询病区排班班次名称列表
/// table: DHCNMG.MgArgWardPost
/// input:病区
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgDBComm","FindWardPostNameList","1")
Query FindWardPostNameList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardPostNameListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp=""
	s warddr="" f  s warddr=$O(^DHCNMG.DB.MgArgWardPostI("WardSort",warddr)) q:warddr=""  d
	.q:(parr'="")&&(parr'=warddr)
	.s sort="" f  s sort=$O(^DHCNMG.DB.MgArgWardPostI("WardSort",warddr,sort)) q:sort=""  d
	..s id="" f  s id=$O(^DHCNMG.DB.MgArgWardPostI("WardSort",warddr,sort,id)) q:id=""  d
	...s obj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(id)
	...s posttype=obj.PostDR.PostType
	...q:posttype'="P"
	...s ret=obj.PostDesc
	...q:$d(tmp(ret))
	...s tmp(ret)=ret
	...q:ret=""
	...d FindWardPostNameList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindWardPostNameList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardPostNameListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardPostNameListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardPostNameListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardPostNameListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod MovePostSort(rowid As %String, type As %String) As %String
{
	s ^TMP("MovePostSort")=rowid_"%"_type
	q:rowid="" ""
	s ret=0
	s obj=##class(DHCNMG.DB.MgArgPost).%OpenId(rowid)
	q:'$IsObject(obj) ""
	s sort=obj.PostSort
	i type="up"
	{
		i sort="1" s ret=0
		e  d
		.s ret=sort-1
		.s obj.PostSort=sort-1
		.s row=$O(^DHCNMG.DB.MgArgPostI("Sort",sort-1,""))
		.s bobj=##class(DHCNMG.DB.MgArgPost).%OpenId(row)
		.s bobj.PostSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	}
	elseif type="down"
	{
		s maxSort=$O(^DHCNMG.DB.MgArgPostI("Sort",""),-1)
		i sort=maxSort s ret=-1
		e  d
		.s ret=sort+1
		.s obj.PostSort=sort+1
		.s row=$O(^DHCNMG.DB.MgArgPostI("Sort",sort+1,""))
		.s bobj=##class(DHCNMG.DB.MgArgPost).%OpenId(row)
		.s bobj.PostSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	} 
	q ret
}

/// Creator:guozj
/// Description:获取全局岗位代码序号
/// Date:2018-07-14
/// Table:DHCNMG.DB.MgArgPost
/// Input:
/// Output：
/// Return:
ClassMethod ComArgPostSort() As %String
{
	s n=1
	s sort="" f  s sort=$O(^DHCNMG.DB.MgArgPostI("Sort",sort)) q:sort=""  d
	.s rw="" f  s rw=$O(^DHCNMG.DB.MgArgPostI("Sort",sort,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgArgPost).%OpenId(rw)
	..i obj.PostSort'="" s n=obj.PostSort+1
	q n
}

/// 
/// 关联排班类型
/// 
ClassMethod SaveWardArgPost(parr As %String, ward As %String, user As %String) As %String
{
	s ^TMP("SaveWardArgPost")=parr_"%"_ward //1^2^3
	q:parr="" ""
	s len=$L(parr,"^")
	f i=1:1:len
	{
		s itm=$p(parr,"^",i)
		i itm="" continue
		s ArgObj=##class(DHCNMG.DB.MgArgPost).%OpenId(itm)
		q:'$IsObject(ArgObj)
		s RowID=""
		//粤北人民可以可引入多个，注释下一行
		s RowID=$O(^DHCNMG.DB.MgArgWardPostI("WardPost",ward,itm,""))
		i RowID="" s WardArgObj=##class(DHCNMG.DB.MgArgWardPost).%New()
		e  s WardArgObj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(RowID)
		s WardArgObj.PostDesc=ArgObj.PostDesc
		s WardArgObj.WardDR=##class(DHCNMG.DB.MgWard).%OpenId(ward)
		s WardArgObj.PostDR=##class(DHCNMG.DB.MgArgPost).%OpenId(itm)
		s WardArgObj.PostStTime1=ArgObj.PostStTime1
		s WardArgObj.PostEndTime1=ArgObj.PostEndTime1
		s WardArgObj.PostStTime2=ArgObj.PostStTime2
		s WardArgObj.PostEndTime2=ArgObj.PostEndTime2
		s WardArgObj.PostStTime3=ArgObj.PostStTime3
		s WardArgObj.PostEndTime3=ArgObj.PostEndTime3
		s WardArgObj.PostMinutes=ArgObj.PostMinutes
		s WardArgObj.PostDayMinutes=ArgObj.PostDayMinutes
		s WardArgObj.PostNextMinutes=ArgObj.PostNextMinutes
		i WardArgObj.PostSort="" s WardArgObj.PostSort=..GetWardArgPostSort(ward)
		s WardArgObj.PostCrtDate=+$H
		s WardArgObj.PostCrtTime=$p($h,",",2)
		s WardArgObj.PostCategory=ArgObj.PostCategory
		i user'=0 s WardArgObj.PostCrtUser=##class(DHCNMG.HR.MgPersons).%OpenId(user)
		s WardArgObj.PostRemark=ArgObj.PostRemark
		s sc=WardArgObj.%Save()
		
	}
	q 1
}

/// 获取病区岗位的顺序号
ClassMethod GetWardArgPostSort(ward As %String) As %String
{
	s flag=1
	s sort=$O(^DHCNMG.DB.MgArgWardPostI("WardSort",ward,""),-1)
	i sort="" s flag=1
	e  s flag=sort+1
	q flag
}

/// 获取病区的顺序号
ClassMethod GetWardSort() As %String
{
	s n=1
	s sort="" f  s sort=$O(^DHCNMG.DB.MgWardI("Sort",sort)) q:sort=""  d
	.s rw="" f  s rw=$O(^DHCNMG.DB.MgWardI("Sort",sort,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgWard).%OpenId(rw)
	..i obj.WardSort'="" s n=n+1
	q n
}

ClassMethod MoveWardSort(rowid As %String, type As %String) As %String
{
	s ^TMP("MoveWardSort")=rowid_"%"_type
	q:rowid="" ""
	s ret=0
	s obj=##class(DHCNMG.DB.MgWard).%OpenId(rowid)
	s sort=obj.WardSort
	i type="up"
	{
		i sort="1" s ret=0
		e  d
		.s ret=sort-1
		.s obj.WardSort=sort-1
		.s row=$O(^DHCNMG.DB.MgWardI("Sort",sort-1,""))
		.s bobj=##class(DHCNMG.DB.MgWard).%OpenId(row)
		.s bobj.WardSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	}
	elseif type="down"
	{
		s maxSort=$O(^DHCNMG.DB.MgWardI("Sort",""),-1)
		i sort=maxSort s ret=1
		e  d
		.s ret=sort+1
		.s obj.WardSort=sort+1
		.s row=$O(^DHCNMG.DB.MgWardI("Sort",sort+1,""))
		.s bobj=##class(DHCNMG.DB.MgWard).%OpenId(row)
		.s bobj.WardSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	} 
	q ret
}

/// Creator:lulin
/// Description:更新某个时间【南通中医，白班、夜班更新时间】
/// Date:2018-12-01
/// Table:DHCNMG.DB.MgArgPost
/// Input:
/// Output：
/// Return:
ClassMethod UpdatePostTime(parr) As %String
{
	s ^TMP("UpdatePostTime")=parr
	q:parr="" 0
	s fromTime=$P(parr,"^")
	s toTime=$P(parr,"^",2)
	s flag=1
	TS
	s id="" f  s id=$O(^DHCNMG.DB.MgArgPostD(id)) q:(id="")||(flag'=1)  d
	.s obj=##class(DHCNMG.DB.MgArgPost).%OpenId(id)
	.q:'$IsObject(obj)
	.q:(obj.PostCategory'="W")&&(obj.PostCategory'="N")
	.i obj.PostStTime1=fromTime  s obj.PostStTime1=toTime
	.e  i obj.PostStTime2=fromTime  s obj.PostStTime2=toTime
	.e  i obj.PostStTime3=fromTime  s obj.PostStTime3=toTime
	.e  i obj.PostEndTime1=fromTime  s obj.PostEndTime1=toTime
	.e  i obj.PostEndTime2=fromTime  s obj.PostEndTime2=toTime
	.e  i obj.PostEndTime3=fromTime  s obj.PostEndTime3=toTime
	.s minutes=..caculateMinute(obj.PostStTime1,obj.PostEndTime1,obj.PostStTime2,obj.PostEndTime2,obj.PostStTime3,obj.PostEndTime3)
	.s obj.PostMinutes=$P(minutes,"^")
	.s obj.PostDayMinutes=$P(minutes,"^",2)
	.s obj.PostNextMinutes=$P(minutes,"^",3)
	.s flag=flag&&obj.%Save()
	.q:flag'=1
	.s subid=""  f  s subid=$O(^DHCNMG.DB.MgArgWardPostI("Post",id,subid)) q:(subid="")||(flag'=1)  d
	..s wardObj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(subid)
	..q:'$IsObject(wardObj)
	..i wardObj.PostStTime1=fromTime  s wardObj.PostStTime1=toTime
	..e  i wardObj.PostStTime2=fromTime  s wardObj.PostStTime2=toTime
	..e  i wardObj.PostStTime3=fromTime  s wardObj.PostStTime3=toTime
	..e  i wardObj.PostEndTime1=fromTime  s wardObj.PostEndTime1=toTime
	..e  i wardObj.PostEndTime2=fromTime  s wardObj.PostEndTime2=toTime
	..e  i wardObj.PostEndTime3=fromTime  s wardObj.PostEndTime3=toTime
	..s wardminutes=..caculateMinute(wardObj.PostStTime1,wardObj.PostEndTime1,wardObj.PostStTime2,wardObj.PostEndTime2,wardObj.PostStTime3,wardObj.PostEndTime3)
	..s wardObj.PostMinutes=$P(wardminutes,"^")
	..s wardObj.PostDayMinutes=$P(wardminutes,"^",2)
	..s wardObj.PostNextMinutes=$P(wardminutes,"^",3)
	..s flag=flag&&wardObj.%Save()
	b ;1
	if flag=1{
		TC
		q 1	
	}else{
		TRO
		q 0	
	}
}

ClassMethod caculateMinute(sttime1, endtime1, sttime2, endtime2, sttime3, endtime3) As %String
{
      s time=0,daytime=0,nexttime=0,daylength=24*60
      if (sttime1'="")&&(endtime1'="") {
        if (sttime1["次日") {
          s sttime1=(24+$E($p(sttime1,":"),3,4))*60+$p(sttime1,":",1)
        }else{
          s sttime1=($p(sttime1,":"))*60+$p(sttime1,":",1)
        }
        if (endtime1["次日") {
          s endtime1=(24+$E($p(endtime1,":"),3,4))*60+$p(endtime1,":",1)
        }else{
          s endtime1=($p(endtime1,":"))*60+$p(endtime1,":",1)
        }
        s time=time+endtime1-sttime1
        if (sttime1<daylength){
          if (endtime1>daylength){
            s daytime=daytime+daylength-sttime1
          }else{
            s daytime=daytime+endtime1-sttime1
          }
        }
        if (endtime1>daylength){
          if (sttime1<daylength){
            s nexttime=nexttime+(endtime1-daylength)
          }
          else{
            s nexttime=nexttime+(endtime1-sttime1)
          }
        }
      }
      if (sttime2'="")&&(endtime2'="") {
        if (sttime2["次日") {
          s sttime2=(24+$E($p(sttime2,":"),3,4))*60+$p(sttime2,":",1)
        }else{
          s sttime2=($p(sttime2,":"))*60+$p(sttime2,":",1)
        }
        if (endtime2["次日") {
          s endtime2=(24+$E($p(endtime2,":"),3,4))*60+$p(endtime2,":",1)
        }else{
          s endtime2=($p(endtime2,":"))*60+$p(endtime2,":",1)
        }
        s time=time+endtime2-sttime2
        if (sttime2<daylength){
          if (endtime2>daylength){
            s daytime=daytime+daylength-sttime2
          }else{
            s daytime=daytime+endtime2-sttime2
          }
        }
        if (endtime2>daylength){
          if (sttime2<daylength){
            s nexttime=nexttime+(endtime2-daylength)
          }
          else{
            s nexttime=nexttime+(endtime2-sttime2)
          }
        }
      }
      if (sttime3'="")&&(endtime3'="") {
        if (sttime3["次日") {
          s sttime3=(24+$E($p(sttime3,":"),3,4))*60+$p(sttime3,":",1)
        }else{
          s sttime3=($p(sttime3,":"))*60+$p(sttime3,":",1)
        }
        if (endtime3["次日") {
          s endtime3=(24+$E($p(endtime3,":"),3,4))*60+$p(endtime3,":",1)
        }else{
          s endtime3=($p(endtime3,":"))*60+$p(endtime3,":",1)
        }
        s time=time+endtime3-sttime3
        if (sttime3<daylength){
          if (endtime3>daylength){
            s daytime=daytime+daylength-sttime3
          }else{
            s daytime=daytime+endtime3-sttime3
          }
        }
        if (endtime3>daylength){
          if (sttime3<daylength){
            s nexttime=nexttime+(endtime3-daylength)
          }
          else{
            s nexttime=nexttime+(endtime3-sttime3)
          }
        }
      }
      s PostMinutes=(time\60)_"时"_(time#60)_"分"
      s PostDayMinutes=(daytime\60)_"时"_(daytime#60)_"分"
      s PostNextMinutes=(nexttime\60)_"时"_(nexttime#60)_"分"
      q PostDayMinutes_"^"_PostDayMinutes_"^"_PostNextMinutes
}

/// Creator:lulin
/// Description:根据类型获取公共代码名称
/// Date:2018-12-07
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod GetCodeDescByCode(type, code) As %String
{
	q:(type="")!(code="") ""
	s par=$O(^DHCNMG.DB.MgSetCodeI("Code"," "_$zcvt($tr(type," ",""),"U"),""))
	q:par="" ""
	s id=$O(^DHCNMG.DB.MgSetCodeSubI("Code",par," "_$zcvt($tr(code," ",""),"U"),""))
	s obj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(par_"||"_id)
	s desc=""
	s:$IsObject(obj) desc=obj.SubDesc
	q desc
}

/// Creator:lulin
/// Description:根据病区id获取关联科室名称
/// Date:2019-02-18
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod GetWardRelateLocDesc(id) As %String
{
	q:id="" ""
	s retDesc=""
	s locid="" f  s locid=$O(^DHCNMG.DB.MgWardLocUnitI("Ward",id,locid)) q:locid=""  d
	.s locObj=##class(DHCNMG.DB.MgWardLoc).%OpenId(locid)
	.q:'$IsObject(locObj)
	.i retDesc="" s retDesc=locObj.LocDesc
	.e  s retDesc=retDesc_","_locObj.LocDesc
	q retDesc
}

/// Creator:王聪聪
/// Description:根据科室id获取病区列表
/// Date:2019-08-25
Query GetWardListByLocId(id) As websys.Query(ROWSPEC = "aa")
{
}

// 执行query

ClassMethod GetWardListByLocIdExecute(ByRef qhandle As %Binary, id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i id="" s qhandle=$lb(0,repid,0) q $$$OK
	s WardID="" f  s WardID=$o(^DHCNMG.DB.MgWardLocUnitI("Loc",id,WardID)) q:WardID=""  d
	.s obj=##class(DHCNMG.DB.MgWard).%OpenId(WardID)
	.q:'$IsObject(obj)
	.s ret="rw|"_obj.%Id()_"^WardDesc|"_obj.WardDesc		
	.d WardOutputRow
	s qhandle=$lb(0,repid,0)
	q $$$OK
WardOutputRow
	s Data=$lb(ret)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:王聪聪
/// Description:根据病区id获取病区工作人员列表
/// Date:2019-08-25
Query GetPersonListByWardId(id As %String) As websys.Query(ROWSPEC = "aa")
{
}

// 执行query

ClassMethod GetPersonListByWardIdExecute(ByRef qhandle As %Binary, id As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s rid="" f  s rid=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_id,rid)) q:rid=""  d
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rid)
	.q:'$IsObject(obj)
	.if (obj.PerDepDR'="")&&(id=obj.PerDepDR) d
	..s ret="RowID|"_obj.%Id()_"^nurseName|"_obj.PerName
	..d PerOutputRow
	s qhandle=$lb(0,repid,0)
	q $$$OK
PerOutputRow
	s Data=$lb(ret)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
