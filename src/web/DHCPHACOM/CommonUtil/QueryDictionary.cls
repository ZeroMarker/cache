/// Creator: 	hulihua
/// CreateDate: 2016-09-28
/// Descript: 	公共控件字典类
Class web.DHCPHACOM.CommonUtil.QueryDictionary Extends %Persistent [ ProcedureBlock ]
{

/// deccription:药房科室
/// table:      User.CtLoc
/// input:		inputParams^1:登录科室Id,filterText:模糊匹配字符
/// d ##class(%ResultSet).RunQuery("web.PHAHERB.Dictionary","HERBLoc","3")
Query DHCPhaLoc(inputParams = "", filterText = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod DHCPhaLocExecute(ByRef qHandle As %Binary, inputParams = "", filterText = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s locId=$p(inputParams,"^",1)
	q:locId="" $$$OK
	s hospId=$p(^CTLOC(locId),"^",22)
	s ctLoc=""
	f  s ctLoc=$o(^CTLOC(0,"LocType","D",ctLoc)) q:ctLoc=""  d
	.s ctLocDesc=$p(^CTLOC(ctLoc),"^",2)
	.q:(ctLocDesc["停")||(ctLocDesc["废")
	.s ctHospId=$p(^CTLOC(ctLoc),"^",22)
	.q:hospId'=ctHospId
	.s startDate=$p(^CTLOC(ctLoc),"^",24)
	.s endDate=$p(^CTLOC(ctLoc),"^",25)
	.q:(startDate'="")&&(startDate>+$h)
	.q:(endDate'="")&&(endDate<+$h)
	.s params="^"_ctLoc_"^^"_ctHospId
	.//q:##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTINPIVA","OnlyPIVALoc",params)'="Y"
	.d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(ctLoc,ctLocDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:配方剂型
/// table:      User.PHAHERB_PresType
/// input:		inputParams:""
/// d ##class(%ResultSet).RunQuery("web.DHCPHACOM.CommonUtil.QueryDictionary","PrescForm","")
Query PrescForm(inputParams = "", filterText = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PrescFormExecute(ByRef qHandle As %Binary, inputParams = "", filterText = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s logonLocId=$p(inputParams,"^",1)
	s hospId=+$p($g(^CTLOC(+logonLocId)),"^",22)
	s hospDr="HospDr_"_hospId
	s ind=1
	s typeId=""
	f  s typeId=$o(^DHCDocConfig(hospDr,"CMPrescTypeList",typeId)) q:(typeId="")  d
	.q:($p(^DHCDocConfig(hospDr,"CMPrescTypeList",typeId),"^",2)'="Y")		;过滤无效剂型
	.s typeDesc=$p(^DHCDocConfig(hospDr,"CMPrescTypeList",typeId),"^")
	.d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(typeId,typeDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

Storage Default
{
<Data name="QueryDictionaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPHA74EE.QueryDictioE4D2D</DataLocation>
<DefaultData>QueryDictionaryDefaultData</DefaultData>
<IdLocation>^web.DHCPHA74EE.QueryDictioE4D2D</IdLocation>
<IndexLocation>^web.DHCPHA74EE.QueryDictioE4D2I</IndexLocation>
<StreamLocation>^web.DHCPHA74EE.QueryDictioE4D2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
