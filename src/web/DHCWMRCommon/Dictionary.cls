Import SQLUser

Class web.DHCWMRCommon.Dictionary Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 29;

ClassMethod QueryDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryDicExecute(ByRef qHandle As %Binary, Desc As %String, Type As %String, IsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:Type="" $$$OK
	;^DHCWMRDIC({Rowid})
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s:IsActive'="" IsActive=$s(IsActive["Y":"Y",1:"N")
	s Rowid=0
	f  s Rowid=$o(^DHCWMRDIC(Rowid)) q:Rowid=""  d
	.s tmpDic=$g(^DHCWMRDIC(+Rowid))
	.q:tmpDic=""
    .s DicType=$p(tmpDic,"^",1)
    .s DicCode=$p(tmpDic,"^",2)
    .s DicDesc=$p(tmpDic,"^",3)
    .s DicActive=$p(tmpDic,"^",10)
    .q:(Desc'="")&&(($$ALPHAUP^SSUTIL4(DicDesc)'[Desc)&&($$ALPHAUP^SSUTIL4(DicCode)'[Desc))
    .q:(Type'="")&&(DicType'=Type)    //判断字典类型
    .q:(IsActive'="")&&(DicActive'=IsActive)  //判断是否有效
    .s Data=$lb(Rowid,DicCode,DicDesc)
    .s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDicExecute ]
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

/// 查询科室列表
/// Desc--字典名称  Type--字典类型
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRCommon.Dictionary","QueryDic","","ErrorType","Y")
Query QueryDic(Desc As %String, Type As %String, IsActive As %String) As %Query(ROWSPEC = "DicId:%String,DicCode:%String,DicDesc:%String")
{
}

/// 取病案基础字典项目  ID^代码^描述
/// w ##Class(web.DHCWMRCommon.Dictionary).GetDicById(DicId)
ClassMethod GetDicById(DicId)
{
	n (DicId)
	s ret=""
	s tmpDic=$g(^DHCWMRDIC(+DicId))
	q:tmpDic="" ret
	s ret=(+DicId)_"^"_$p(tmpDic,"^",2)_"^"_$p(tmpDic,"^",3)
	q ret
}

/// 添加病历内容字典
/// w ##Class(web.DHCWMRCommon.Dictionary).INSERTDHCWMRDIC()
ClassMethod INSERTDHCWMRDIC()
{
	n 
	s ret=-1
	s CurrID=+$o(^DHCWMRDIC(""),-1)
	s ^mdata("DHCWMRDICTIONARY")=CurrID
	
	s InPut=""
	s InPut=InPut_$lb("^SYS^QualityEPRContent^质控病历内容^^^^^^^Y^")
	s InPut=InPut_$lb("^QualityEPRContent^1^病案首页^^^^^^^Y^")
	for Ind=1:1:$listlength(InPut)
	{
		s tmpInPut=$list(InPut,Ind)
		s DicName=$p(tmpInPut,"^",2)
		s Code=$p(tmpInPut,"^",3)
		q:(Code="")||(DicName="")
		s Rowid=$o(^DHCWMRDIC(0,"DicNameCode",DicName,Code,""),-1)
		s:Rowid'="" $p(tmpInPut,"^",1)=Rowid
		s ret=##class(web.DHCWMRDictionaryCtl).Update(tmpInPut)
		w "ret="_ret,!
	}
	q ret
}

}
