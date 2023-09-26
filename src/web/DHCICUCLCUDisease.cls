Import SQLUSER

/// creator:liyinuo
/// creat date:2014-09-22
/// description:实现重症疾病诊断表维护：查询，新增，修改，删除
/// table:DHC_CLC_UnderlyingDisease
Class web.DHCICUCLCUDisease Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 参数传递: DisCode^DisDesc^Ctlocid^udSeqNo 
/// CLCUnderlyingDisInfo详细信息
/// table:DHC_CLC_UnderlyingDisease
/// return:SQL 执行结果
/// w ##class(web.DHCICUCLCUDisease).InsertCLCUnderlyingDis("GXB^冠心病^28^1") 
ClassMethod InsertCLCUnderlyingDis(CLCUnderlyingDisInfo As %String) As %String
{
    q:CLCUnderlyingDisInfo="" "输入信息为空，请重新输入"
    s DisCode=$p(CLCUnderlyingDisInfo,"^",1)
    q:DisCode="" "疾病编码不能为空"
    s DisCode=$$ALPHAUP^SSUTIL4(DisCode)
    s DisDesc=$p(CLCUnderlyingDisInfo,"^",2)
    q:DisDesc="" "疾病名称不能为空"
    s CtlocDr=$p(CLCUnderlyingDisInfo,"^",3)
    q:CtlocDr="" "科室不能为空"
    s SeqNo=$p(CLCUnderlyingDisInfo,"^",4)
    q:SeqNo="" "科室不能为空"
    s UDRowid=$o(^DHCCLC("UnderlyingDisease",0,"Code",DisCode,CtlocDr,""))
    q:UDRowid'="" "该信息已经存在，请重新输入"
    &sql(insert into SQLUser.DHC_CLC_UnderlyingDisease (CLCUD_Code,CLCUD_Desc,CLCUD_Ctloc_Dr,CLCUD_SeqNo) values(:DisCode,:DisDesc,:CtlocDr,:SeqNo))
	i SQLCODE'="0" q "插入失败!"
	q "0"
}

/// 参数传递： CLCUDRowid^DisCode^DisDesc^Ctlocid^udSeqNo 
/// CLCUnderlyingDisInfo详细信息 
/// table:DHC_CLC_UnderlyingDisease
/// return:SQL 执行结果
/// w ##class(web.DHCICUCLCUDisease).UpdateCLCUnderlyingDis("1^GXB^冠心病^28^1")
ClassMethod UpdateCLCUnderlyingDis(CLCUnderlyingDisInfo As %String) As %String
{
	
    q:CLCUnderlyingDisInfo="" "请选择要修改的信息"
    //q:CLCUnderlyingDisInfo
    s CLCUDRowid=$p(CLCUnderlyingDisInfo,"^",1)
    q:CLCUDRowid="" "请选中一行要修改的信息"
    s DisCode=$p(CLCUnderlyingDisInfo,"^",2)
    q:DisCode="" "疾病编码不能为空"
    s DisCode=$$ALPHAUP^SSUTIL4(DisCode)
    s DisDesc=$p(CLCUnderlyingDisInfo,"^",3)
    q:DisDesc="" "疾病名称不能为空"
    s CtlocDr=$p(CLCUnderlyingDisInfo,"^",4)
    q:CtlocDr="" "科室不能为空"
    s SeqNo=$p(CLCUnderlyingDisInfo,"^",5)
    q:SeqNo="" "科室不能为空"
	&sql(update SQLUser.DHC_CLC_UnderlyingDisease set CLCUD_Code=:DisCode,CLCUD_Desc=:DisDesc,CLCUD_Ctloc_Dr=:CtlocDr,CLCUD_SeqNo=:SeqNo where CLCUD_RowId=:CLCUDRowid)
	i SQLCODE'="0" q "更新失败!"
	q "0"
}

ClassMethod DeleteCLCUnderlyingDis(clcUDRowId As %String)
{
	q:clcUDRowId="" "clcpRowId不能为空!，请选中要删除的数据"
	
	&sql(delete from SQLUser.DHC_CLC_UnderlyingDisease where CLCUD_RowId=:clcUDRowId)
	
	i SQLCODE'="0" q "删除失败!"
	q "0"
}

/// creatdate 20140918
/// 根据条件查询重症疾病；查询条件有多个
/// 检索条件：DisCode-疾病code；DisDesc-疾病描述；Ctloc-科室；SeqNo-序列号
/// return :疾病Code，疾病描述，科室，序列号
/// d ##class(%ResultSet).RunQuery("web.DHCICUCLCUDisease","FindCLCUDTabInfo","","","","")
Query FindCLCUDTabInfo(DisCode As %String = "", DisDesc As %String = "", ctlocId As %String = "", SeqNo As %String = "") As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,CtlocDesc:%String,CtlocIdDr:%String,SeqNo:%String")
{
}

ClassMethod FindCLCUDTabInfoExecute(ByRef qHandle As %Binary, DisCode As %String = "", DisDesc As %String = "", ctlocId As %String = "", SeqNo As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s CLCUDRowid=0
	f  s CLCUDRowid=$o(^DHCCLC("UnderlyingDisease",CLCUDRowid)) q:CLCUDRowid=""  d
	.s Code=$li(^DHCCLC("UnderlyingDisease",CLCUDRowid),1)
	.q:(DisCode'="")&&($$ALPHAUP^SSUTIL4(DisCode)'=Code)
	.s Desc=$li(^DHCCLC("UnderlyingDisease",CLCUDRowid),2)
	.q:(DisDesc'="")&&(DisDesc'=Desc)
	.s ctlocCode=$li(^DHCCLC("UnderlyingDisease",CLCUDRowid),3)
	.q:(ctlocId'="")&&(ctlocId'=ctlocCode)
	.s CtlocDesc=$p($g(^CTLOC(ctlocCode)),"^",2) // 取得科室
	.s udSeqNo=$li(^DHCCLC("UnderlyingDisease",CLCUDRowid),4)
	.q:(SeqNo'="")&&(SeqNo'=udSeqNo)
	.d OutputRow6
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK 
    
OutputRow6
	set Data=$lb(CLCUDRowid,Code,Desc,CtlocDesc,ctlocCode,udSeqNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCLCUDTabInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCLCUDTabInfoExecute ]
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

ClassMethod FindCLCUDTabInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCLCUDTabInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 20140909
/// 查找科室
/// CreatDate: 2014-09-18
/// Description: 根据科室列表取科室  
/// Table：CT_Loc
/// Input：desc:手术科室描述
/// Return：返回所查询科室ID:ctlocId,科室名:ctlocDesc,科室代码:ctlocCode,
/// d ##class(%ResultSet).RunQuery("web.DHCCLCom","FindLocList","","")
Query FindLocList(desc As %String) As %Query(ROWSPEC = "ctlocId:%String,ctlocDesc:%String,ctlocCode:%String")
{
}

ClassMethod FindLocListExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s ctlocRowId=0,CTRowId=""
	for  s ctlocRowId=$o(^CTLOC(ctlocRowId)) q:ctlocRowId=""  d
	.s CTRowId=ctlocRowId
	.s ctlocCode=$p(^CTLOC(ctlocRowId),"^",1)
	.s CTDesc=$p($g(^CTLOC(ctlocRowId)),"^",2)
	.s CTDescTemp=$$ALPHAUP^SSUTIL4(CTDesc)
	.q:(desc'="")&&(CTDescTemp'[desc)
	.d OutputRow61
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow61
	set Data=$lb(CTRowId,CTDesc,ctlocCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocListExecute ]
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

ClassMethod FindLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
