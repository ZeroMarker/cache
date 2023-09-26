Class DHCDoc.DHCDocConfig.InstrConfig Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->用法设置 
Query FindTypeInstr(value As %String, HospId As %String = "", PassCMInstr As %String = "") As %Query(ROWSPEC = "InstrRowID:%String,InstrDesc:%String,selected:%Boolean,InstrActive:%String")
{
}

ClassMethod FindTypeInstrExecute(ByRef qHandle As %Binary, value As %String, HospId As %String = "", PassCMInstr As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrConfig","FindTypeInstr","")
	Set repid=$I(^CacheTemp)
    Set ind=1
    
    s InstrRowID=0
 	f  s InstrRowID=$o(^PHCIN(InstrRowID)) q:InstrRowID=""  d
 	.s str=$g(^PHCIN(InstrRowID))
 	.s InstrDesc=$p(str,"^",2)
 	.s PHCINDesc2=$p(str,"^",3)
 	.s InstrActive=$p(str,"^",4)
 	.Q:(PassCMInstr="Y")&&(PHCINDesc2="饮片")
	.s selected=0
	.i value'="" d
	..s:("^"_..%GetConfig(value,HospId)_"^")[("^"_InstrRowID_"^") selected=1 //$g(^DHCDocConfig(value))
	.Do OutputRowFindTypeInstr
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindTypeInstr
	set Data=$lb($g(InstrRowID),$g(InstrDesc),$g(selected),$G(InstrActive))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindTypeInstrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTypeInstrExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTypeInstrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTypeInstrExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindInstrConfigList(InstrRowId As %String = "", HospId As %String) As websys.Query(ROWSPEC = "id:%String,text:%String,InstrHasConfigFlag:%String")
{
}

/// 获取特殊用法配置项列表
ClassMethod FindInstrConfigListExecute(ByRef qHandle As %Binary, InstrRowId As %String = "", HospId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrConfig","FindInstrConfigList")
	Set repid=$I(^CacheTemp)
    Set ind=1
	k ConfigCongeriesArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(..GetInstrConfigJson(),.ConfigCongeriesArr)
    s count=0
    for {
	    s count=$o(ConfigCongeriesArr(count)) Q:count=""
	    s id=$G(ConfigCongeriesArr(count,"id"))
	    s text=$G(ConfigCongeriesArr(count,"text"))
	    s InstrHasConfigFlag="N"
	    if (InstrRowId'="") {
		    ;但查询子类已配置的项目时过滤医嘱重分类
		    s CatListStr=..%GetConfig(id,HospId)
		    if ("^"_CatListStr_"^")[("^"_InstrRowId_"^") s InstrHasConfigFlag="Y"
		}
	    d OutputRow1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb($g(id),$g(text),$g(InstrHasConfigFlag))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetInstrConfigJson() As %String
{
	s JsonObj=[]
    s JsonData={} do JsonData.%Set("id","WYInstr") do JsonData.%Set("text","外用用法") do JsonObj.%Push(JsonData,"")
    s JsonData={} do JsonData.%Set("id","NotFollowInstr") do JsonData.%Set("text","不随主医嘱变化的用法") do JsonObj.%Push(JsonData,"")
    s JsonData={} do JsonData.%Set("id","SkinTestInstr") do JsonData.%Set("text","皮试用法") do JsonObj.%Push(JsonData,"")
    s JsonData={} do JsonData.%Set("id","IPDosingInstr") do JsonData.%Set("text","住院需配液用法") do JsonObj.%Push(JsonData,"")
    s JsonData={} do JsonData.%Set("id","OPInfusionInstr") do JsonData.%Set("text","门诊输液用法") do JsonObj.%Push(JsonData,"")
    s JsonData={} do JsonData.%Set("id","DrippingSpeedInstr") do JsonData.%Set("text","滴速用法") do JsonObj.%Push(JsonData,"")
    s JsonInfo=""
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	While 'obj.AtEnd { 
		s JsonInfo=JsonInfo_obj.ReadLine(,.sc,.eol)
	}
	Q JsonInfo
}

/// 批量修改某个用法的特殊用法配置项
/// w ##class(DHCDoc.DHCDocConfig.InstrConfig).SaveInstrConfigByInstrId("MedItemCat^AllowEntryDecimalItemCat^NotAlertRepeatItemCat",1,2)
ClassMethod SaveInstrConfigByInstrId(ConfigIdStr As %String, InstrRowId As %String = "", HospId As %String) As %String
{
	s Coninfo=""
	k ConfigCongeriesArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(..GetInstrConfigJson(),.ConfigCongeriesArr)
    s count=0
    for {
	    s count=$o(ConfigCongeriesArr(count)) Q:count=""
	    s id=$G(ConfigCongeriesArr(count,"id"))
	    s text=$G(ConfigCongeriesArr(count,"text"))
	    s OldInstrListStr=..%GetConfig(id,HospId)
	    i OldInstrListStr=0 s OldInstrListStr=""
	    s NewInstrListStr=""
	    if ("^"_ConfigIdStr_"^")[("^"_id_"^") {
		    // 添加某个用法的某个配置项维护,若配置项旧数据中包含传入的用法则继续循环下一条数据
			if ("^"_OldInstrListStr_"^")[("^"_InstrRowId_"^") continue
			if OldInstrListStr="" s NewInstrListStr=InstrRowId
			else  s NewInstrListStr=OldInstrListStr_"^"_InstrRowId
		}else{
			// 去掉某个用法的某个配置项维护,若配置项旧数据中不包含传入的用法则继续循环下一条数据
			if ("^"_OldInstrListStr_"^")'[("^"_InstrRowId_"^") continue
			for i=1:1:$l(OldInstrListStr,"^") {
				s oneInstrRowId=$p(OldInstrListStr,"^",i)
				continue:oneInstrRowId=InstrRowId
				i NewInstrListStr="" s NewInstrListStr=oneInstrRowId
				else  s NewInstrListStr=NewInstrListStr_"^"_oneInstrRowId
			}
		}
		i Coninfo="" s Coninfo=id_$C(1)_NewInstrListStr
		else  s Coninfo=Coninfo_$C(2)_id_$C(1)_NewInstrListStr
	}
	Q:Coninfo="" 0
	Q ##class(web.DHCDocConfig).SaveConfig(Coninfo,HospId)
}

}
