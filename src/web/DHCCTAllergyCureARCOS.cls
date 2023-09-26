Class web.DHCCTAllergyCureARCOS Extends %RegisteredObject
{

Query Find(desc As %String) As websys.Query(ROWSPEC = "ID:%String:序号,DHCACOSDesc:%String:描述,DHCACOSCode:%String:代码,DHCACOSARCOSDR:%String:医嘱套序号,DHCACOSARCOSDRDesc:%String:医嘱套,DHCACOSType:%String:医嘱套试验代码,DHCACOSTypeDesc:%String:医嘱套试验类型")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCTAllergyCureARCOS","Find","")
ClassMethod FindExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
		set repid = $I(^CacheTemp)
		if $g(ind) = "" set ind = 0
		s ^||RepidTemp("web.DHCCTAllergyCureARCOS","Find","CacheTemp")=repid
		s rowid=0 f  s rowid=$o(^DHCCTACARCOS(rowid)) q:rowid=""  d
		.s DHCACOSCode = $p(^DHCCTACARCOS(rowid),"^",1)
		.s DHCACOSDesc = $p(^DHCCTACARCOS(rowid),"^",2)
		.s ARCOSId	 = $p(^DHCCTACARCOS(rowid),"^",3)
		.s ARCOSDesc=""
		.i +ARCOSId'=0 d		
		..s ARCOSDesc = $p(^ARCOS(ARCOSId),"^",2)
		.s ARCOSType = $p(^DHCCTACARCOS(rowid),"^",4)
		.s ARCOSTypeDesc = ..getTypeDesc(ARCOSType)
		.s ind = ind+1
		.s ^CacheTemp(repid,ind) = $lb(rowid,DHCACOSDesc,DHCACOSCode,ARCOSId,ARCOSDesc,ARCOSType,ARCOSTypeDesc)
		set qHandle = $lb(0,repid,0)
		Q $$$OK
}

/// ##class(web.DHCCTAllergyCureARCOS).GetAllergyOrdItem(4342)
/// EpisodeID中为变态反应科的医嘱
ClassMethod GetAllergyOrdItem(EpisodeID)
{
	q:EpisodeID="" ""
	s oeorder = $o(^OEORD(0,"Adm",EpisodeID,""),-1)
	q:+oeorder=0 ""
	s rtn=""
	s sub=0 f  s sub=$o(^OEORD(oeorder,"I",sub)) q:sub=""  d
	.s arcosdr = $p(^OEORD(oeorder,"I",sub,3),"^",10) ;OEORI_ARCOS_DR
	.q:arcosdr=""
	.i $d(^DHCCTACARCOSi(0,"ARCOS",arcosdr)) d
	..i rtn="" s rtn=oeorder_"||"_sub
	..e  s rtn=rtn_"^"_oeorder_"||"_sub
	q rtn
}

/// 增加,更新
/// reqJson: 
/// 	EMParentCode=DOCSOSOrder&EMCode=DOCSOSOrderConsultation&EMText=%E4%BC%9A%E8%AF%8A%E7%94%B3%E8%AF%B7&EMHandler=consultationHandler&EMDisplayHandler=&EMCls=&EMItemIndex=&ID=14
/// W ##CLASS(web.DHCCTAllergyCureARCOS).Save(^Temp("wanghc","reqjson"))
ClassMethod Save(reqJson)
{
		s ^Temp("wanghc","reqjson")=reqJson
		s jsonObj = ##class(ext.util.JsonObject).%New()
		s jsonObj.ContainNullValue=1	//删除属性值时用到
		d jsonObj.FromObject(reqJson)
		s obj = jsonObj.Bean("User.DHCCTAllergyCureARCOS")
		s sc = obj.%Save()
		If $$$ISERR(sc) Quit "-306"
		q 0
}

/// 返回试验组描述
ClassMethod getTypeDesc(ARCOSType)
{
	q $s(ARCOSType="P":"斑贴试验组",ARCOSType="SI":"皮肤试验吸入组",ARCOSType="SF":"皮肤试验食物组",1:"")
}

/// 是斑贴试验组
ClassMethod IsPatchType(ARCOSType)
{
	q:ARCOSType="P" 1
	q 0
}

/// 是皮肤试验吸入组
ClassMethod IsSkinInhale(ARCOSType)
{
	q:ARCOSType="SI" 1
	q 0
}

/// 是皮肤试验食物组
ClassMethod IsSkinFood(ARCOSType)
{
	q:ARCOSType="SF" 1
	q 0
}

/// 删除
ClassMethod Delete(Id)
{
	q:Id="" "-100"
	s sc = ##class(User.DHCCTAllergyCureARCOS).%DeleteId(Id)
	Q:$$$ISERR(sc) "-306"
	q 0
}

/// 判断医嘱是不是变态科皮试的医嘱
/// @param: OE_OrdItem->RowId
/// @return: 0 不是 变态科皮试医嘱 
/// 			 1  是
ClassMethod IsSkinOeori(OeordItemID)
{
	q:OeordItemID="" 0
	s Oeord = +OeordItemID
	s Oeordsub = $p(OeordItemID,"||",2)	
	s ArcosID=$p(^OEORD(Oeord,"I",Oeordsub,3),"^",10)		;OEORI_ARCOS_DR
	q:ArcosID="" 0
	s AcosId = $o(^DHCCTACARCOSi(0,"ARCOS",ArcosID,"")) ;User.DHCCTAllergyCureARCOS 医嘱套与变态反应科医嘱关系ID
	q:AcosId="" 0	
	q 1
}

/// return: User.DHCCTAllergyCureARCOS - RowId
ClassMethod GetAllergyARCOS(OeordItemID)
{
	q:OeordItemID="" 0
	s Oeord = +OeordItemID
	s Oeordsub = $p(OeordItemID,"||",2)	
	s ArcosID=$p(^OEORD(Oeord,"I",Oeordsub,3),"^",10)		;OEORI_ARCOS_DR
	q:ArcosID="" 0
	s AcosId = $o(^DHCCTACARCOSi(0,"ARCOS",ArcosID,"")) ;User.DHCCTAllergyCureARCOS 医嘱套与变态反应科医嘱关系ID
	q:AcosId="" 0	
	q AcosId
}

}
