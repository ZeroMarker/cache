Import SQLUser

Class web.DHCWMRWorkItemCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 55;

ClassMethod Update(InString)
{
	//***************************************
	//功能说明：添加或修改病案操作项目(添加数据时WMRRowid设空值)
	//入参：WMRRowid^ItemType_Dr^Description^IsActive^Resume
	//出参：WMRRowid
	//调试：w ##class(web.DHCWMRWorkItemCtl).Update("入参")
	//***************************************
	
	n (InString)
    s WMRRowid=$p(InString,"^",1)
    s:$p(InString,"^",2)'="" PLIST(2)=+$p(InString,"^",2)     ;操作项目类别
    q:PLIST(2)="" -1
    s PLIST(3)=$p(InString,"^",3)                             ;描述
    q:PLIST(3)="" -1
    s PLIST(4)=$s($p(InString,"^",4)["Y":"Y",1:"N")           ;是否有效
    s PLIST(5)=$p(InString,"^",5)                             ;备注
    s PLIST(6)=+$p(InString,"^",6)                            ;特殊操作
    s PLIST(7)=$s($p(InString,"^",7)["Y":"Y",1:"N")           ;是否需要校验接收人
    s PLIST(8)=$s($p(InString,"^",8)["Y":"Y",1:"N")           ;是否需要申请
    i WMRRowid="" d
    .&sql(Insert into DHC_WMR_WorkItem values :PLIST())
    e  d
    .&sql(Update DHC_WMR_WorkItem values :PLIST() where Rowid=:WMRRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod GetDataById(WMRRowid)
{
	//***************************************
	//功能说明：根据WMRRowid获取病案操作项目记录
	//入参：WMRRowid
	//出参：WMRRowid^ItemType_Dr^Description^IsActive^Resume
	//调试：w ##class(web.DHCWMRWorkItemCtl).GetDataById("入参")
	//***************************************
	n (WMRRowid)
    q:WMRRowid="" ""
    q:'$d(^DHCWMRWITM(WMRRowid)) ""
    s s=$g(^DHCWMRWITM(WMRRowid))
    s:+$p(s,"^",5)=0 $p(s,"^",5)=""
    s s=WMRRowid_"^"_s
    q s
}

ClassMethod QueryByTypeFlagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByTypeFlagExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryByTypeFlagExecute(ByRef qHandle As %Binary, Type As %String, Flag As %String) As %Status
{
	//****************************************
	//功能说明：查询病案操作项目记录集
	//入参：ItemType_Dr,IsActive
	//出参：WMRRowid,ItemType_Dr,Description,IsActive,Resume
	//调试：d ##class(%ResultSet).RunQuery("web.DHCWMRWorkItemCtl","QueryByTypeFlag","入参",...)
	//****************************************	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
    s iCount=..QueryByTypeFlag(Type,Flag)
    s JIndex=$p(iCount,"^",2),iCount=+iCount
	q:iCount<0 $$$OK
	f i=0:1:iCount d
	.s s=$g(^CacheTemp("WIQueryByTypeFlag",JIndex,i))
	.d BuildData

	Quit $$$OK
BuildData
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryByTypeFlag(Type, Flag)
{
    n (Type,Flag)
    k ^CacheTemp("WIQueryByTypeFlag",$j)
    
    s n=0
    s:Type'="" Type=+Type
    s:Flag'="" Flag=$s(Flag["Y":"Y",1:"N")
    s WMRRowid=""
    f  s WMRRowid=$o(^DHCWMRWITM(WMRRowid)) q:WMRRowid=""  d
    .q:((Type'="")&&(Type'=$p(^DHCWMRWITM(WMRRowid),"^",1)))
    .q:((Flag'="")&&(Flag'=$p(^DHCWMRWITM(WMRRowid),"^",3)))
    .s ^CacheTemp("WIQueryByTypeFlag",$j,n)=..GetDataById(WMRRowid)
    .s n=n+1
    q n-1_"^"_$j
}

ClassMethod QueryByTypeFlagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByTypeFlagExecute ]
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

Query QueryByTypeFlag(Type As %String, Flag As %String) As %Query(ROWSPEC = "Rowid:%String,ItemType_Dr:%String,Description:%String,IsActive:%String,Resume:%String,SysOperDr:%String")
{
}

ClassMethod QueryByTypeFlagLIST(Type, Flag)
{
	//***************************************
	//功能说明：查询病案操作项目记录集
	//          记录之间"$c(1)"分割,字段之间"^"分割
	//入参：ItemType_Dr,IsActive
	//出参：WMRRowid^ItemType_Dr^Description^IsActive^Resume
	//调试：w ##class(web.DHCWMRWorkItemCtl).QueryByTypeFlagLIST("入参")
	//***************************************
	n (Type,Flag)
	
	s iCount=..QueryByTypeFlag(Type,Flag)
    s JIndex=$p(iCount,"^",2),iCount=+iCount
	q:iCount<0 $$$OK
	f i=0:1:iCount d
	.s j=i+1
	.s $p(s,$c(1),j)=$g(^CacheTemp("WIQueryByTypeFlag",JIndex,i))
	q s
}

ClassMethod QueryListByTypeFlagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryListByTypeFlagExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryListByTypeFlagExecute(ByRef qHandle As %Binary, Type As %String, Code As %String, Flag As %String) As %Status
{
	//****************************************
	//功能说明：查询病案操作项目记录List
	//入参：ItemType_Dr,Code,IsActive
	//出参：WMRRowid,Description
	//调试：d ##class(%ResultSet).RunQuery("web.DHCWMRWorkItemCtl","QueryListByTypeFlag","ItemType_Dr","IsActive")
	//****************************************	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

    i (Type'="")&&(Code'="") d
    .s Type=$o(^DHCWMRDIC(0,"DicNameCode",Type,Code,0))
    e  d
    .s:+Type=4 Type="4"
    .s:+Type=3 Type="3"
    .s:+Type=0 Type=""
    s:Flag'="" Flag=$s(Flag["Y":"Y",1:"N")

	s WMRRowid=0
	f  s WMRRowid=$o(^DHCWMRWITM(WMRRowid)) q:WMRRowid=""  d
	.q:'$d(^DHCWMRWITM(WMRRowid))
	.q:((Type'="")&&(Type'=$p(^DHCWMRWITM(WMRRowid),"^",1)))
	.q:((Flag'="")&&(Flag'=$p(^DHCWMRWITM(WMRRowid),"^",3)))
	.s s=WMRRowid_"^"_$p(^DHCWMRWITM(WMRRowid),"^",2)
	.d LTBuildData


	Quit $$$OK
LTBuildData
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryListByTypeFlagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryListByTypeFlagExecute ]
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

Query QueryListByTypeFlag(Type As %String, Code As %String, Flag As %String) As %Query(ROWSPEC = "Rowid:%String,Description:%String")
{
}

//病案操作项目评价列表

ClassMethod SRUpdate(InString)
{
	//***************************************
	//功能说明：添加或修改病案病案操作项目评价(添加数据时SubID为空值)
	//入参：ParID^SubID^Description^IsActive^Resume
	//出参：WMRRowid/SQLCODE/-2/-1
	//调试：w ##class(web.DHCWMRWorkItemCtl).SRUpdate("入参")
	//***************************************
	n (InString)
    s ParID=$p(InString,"^",1)
    s SubID=$p(InString,"^",2)
    s WMRRowid=ParID_"||"_SubID
    
    s PLIST(0)=ParID
    q:ParID="" -1
    s PLIST(3)=$p(InString,"^",3)      ;描述
    q:PLIST(3)="" -1
    s PLIST(4)=$s($p(InString,"^",4)["Y":"Y",1:"N") ;是否有效
    s PLIST(5)=$p(InString,"^",5)      ;备注
    q:($d(^DHCWMRWITM(ParID,"L",0,"DetailCode",PLIST(3))))&(SubID="") -1
    i SubID="" d
    .&sql(Insert into DHC_WMR_WorkItemRule values :PLIST())
    e  d
    .&sql(Update DHC_WMR_WorkItemRule values :PLIST() where Rowid=:WMRRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod SRGetDataById(WMRRowid)
{
	//***************************************
	//功能说明：根据WMRRowid获取病案操作项目评价列表记录
	//入参：WMRRowid
	//出参：WMRRowid^Description^IsActive^Resume
	//调试：w ##class(web.DHCWMRWorkItemCtl).SRGetDataById("入参")
	//***************************************
    n (WMRRowid)
    s ParID=$p(WMRRowid,"||",1)
    s SubID=$p(WMRRowid,"||",2)
    
    q:'$d(^DHCWMRWITM(ParID,"R",SubID)) ""
    s s=$g(^DHCWMRWITM(ParID,"R",SubID))
    s s=WMRRowid_"^"_s
    q s
}

ClassMethod SRQueryDataByParFlagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SRQueryDataByParFlagExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod SRQueryDataByParFlagExecute(ByRef qHandle As %Binary, ParID As %String, Flag As %String) As %Status
{
	//****************************************
	//功能说明：病案操作项目评价列表记录集
	//入参：Parref,IsActive
	//出参：WMRRowid,Description,IsActive,Resume
	//调试：d ##class(%ResultSet).RunQuery("web.DHCWMRWorkItemCtl","SRQueryDataByParFlag","入参",...)
	//****************************************	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
    s iCount=..SRQueryDataByParFlag(ParID,Flag)
    s JIndex=$p(iCount,"^",2),iCount=+iCount
	q:iCount<0 $$$OK
	f i=0:1:iCount d
	.s s=$g(^CacheTemp("SRQueryDataByParFlag",JIndex,i))
	.d SRBuildData

	Quit $$$OK
SRBuildData
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SRQueryDataByParFlag(ParID, Flag)
{
    n (ParID,Flag)
    k ^CacheTemp("SRQueryDataByParFlag",$j)
    
    s n=0
    s:ParID'="" ParID=+ParID
    s:Flag'="" Flag=$s(Flag["Y":"Y",1:"N")
    q:ParID="" -1
    q:'$d(^DHCWMRWITM(ParID,"R")) -100
    s SubID=0
    f  s SubID=$o(^DHCWMRWITM(ParID,"R",SubID)) q:SubID=""  d
    .q:'$d(^DHCWMRWITM(ParID,"R",SubID))
    .q:((Flag'="")&&(Flag'=$p(^DHCWMRWITM(ParID,"R",SubID),"^",2)))
    .s WMRRowid=ParID_"||"_SubID
    .s ^CacheTemp("SRQueryDataByParFlag",$j,n)=..SRGetDataById(WMRRowid)
    .s n=n+1
    q n-1_"^"_$j
}

ClassMethod SRQueryDataByParFlagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SRQueryDataByParFlagExecute ]
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

Query SRQueryDataByParFlag(ParID As %String, Flag As %String) As %Query(ROWSPEC = "Rowid:%String,Description:%String,IsActive:%String,Resume:%String")
{
}

ClassMethod SRQueryDataByParFlagLIST(ParID, Flag)
{
	//***************************************
	//功能说明：查询病案操作项目评价列表记录集字串
	//          记录之间"$c(1)"分割,字段之间"^"分割
	//入参：Parref,IsActive
	//出参：WMRRowid^Description^IsActive^Resume
	//调试：w ##class(web.DHCWMRWorkItemCtl).SRQueryDataByParFlagLIST("入参")
	//***************************************
	n (ParID,Flag)
	
	s iCount=..SRQueryDataByParFlag(ParID,Flag)
    s JIndex=$p(iCount,"^",2),iCount=+iCount
	q:iCount<0 $$$OK
	f i=0:1:iCount d
	.s j=i+1
	.s $p(s,$c(1),j)=$g(^CacheTemp("SRQueryDataByParFlag",JIndex,i))
	q s
}

//突发项目明细列表

ClassMethod SLUpdate(InString)
{
	//***************************************
	//功能说明：添加或修改突发项目明细列表(添加数据时SubID为空值)
	//入参：ParID^SubID^Detail_Dr^ListIndex^IsActive^IsNeed^Resume^DefaultValue
	//出参：WMRRowid
	//调试：w ##class(web.DHCWMRWorkItemCtl).SLUpdate("ParID^SubID^Detail_Dr^ListIndex^IsActive^IsNeed^Resume")
	//***************************************
	n (InString)
    s ParID=$p(InString,"^",1)
    s SubID=$p(InString,"^",2)
    s WMRRowid=ParID_"||"_SubID
    
    s PLIST(0)=ParID
    q:ParID="" -1
    s PLIST(3)=+$p(InString,"^",3)     ;突发项目明细
    q:PLIST(3)=0 -1
    s PLIST(4)=$p(InString,"^",4)      ;显示顺序
    s PLIST(5)=$s($p(InString,"^",5)["Y":"Y",1:"N") ;是否有效
    s PLIST(6)=$s($p(InString,"^",6)["Y":"Y",1:"N") ;是否必须项
    s PLIST(7)=$p(InString,"^",7)      ;备注
    s PLIST(8)=$p(InString,"^",8)      ;默认值
    q:($d(^DHCWMRWITM(ParID,"L",0,"DetailDr",PLIST(3)))&(SubID="")) -100
    i SubID="" d
    .&sql(Insert into DHC_WMR_WorkItemList values :PLIST())
    e  d
    .&sql(Update DHC_WMR_WorkItemList values :PLIST() where Rowid=:WMRRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod SLGetDataById(WMRRowid)
{
	//***************************************
	//功能说明：根据WMRRowid获取突发项目明细列表记录
	//入参：WMRRowid
	//出参：Rowid^Detail_Dr^ListIndex^IsActive^IsNeed^Resume^DefaultValue
	//调试：w ##class(web.DHCWMRWorkItemCtl).SLGetDataById("WMRRowid")
	//***************************************
	n (WMRRowid)
    s ParID=$p(WMRRowid,"||",1)
    s SubID=$p(WMRRowid,"||",2)
    
    q:'$d(^DHCWMRWITM(ParID,"L",SubID)) ""
    s s=$g(^DHCWMRWITM(ParID,"L",SubID))
    s s=WMRRowid_"^"_s
    q s
}

ClassMethod SLQueryDataByParFlagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SLQueryDataByParFlagExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod SLQueryDataByParFlagExecute(ByRef qHandle As %Binary, ParID As %String, Flag As %String) As %Status
{
	//****************************************
	//功能说明：突发项目明细列表记录集
	//入参：Parref,IsActive
	//出参：WMRRowid,Detail_Dr,ListIndex,IsActive,IsNeed,Resume,DefaultValue
	//调试：d ##class(%ResultSet).RunQuery("web.DHCWMRWorkItemCtl","SLQueryDataByParFlag","Parref","IsActive")
	//****************************************	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
    s iCount=..SLQueryDataByParFlagM(ParID,Flag)
    s JIndex=$p(iCount,"^",2),iCount=+iCount
	q:iCount<0 $$$OK
	f i=0:1:iCount d
	.s s=$g(^CacheTemp("SLQueryDataByParFlag",JIndex,i))
	.d SLBuildData

	Quit $$$OK
SLBuildData
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SLQueryDataByParFlagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SLQueryDataByParFlagExecute ]
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

Query SLQueryDataByParFlag(ParID As %String, Flag As %String) As %Query(ROWSPEC = "Rowid:%String,Detail_Dr:%String,ListIndex:%String,IsActive:%String,IsNeed:%String,Resume:%String,DefaultValue:%String")
{
}

ClassMethod SLQueryDataByParFlagLIST(ParID, Flag)
{
	//***************************************
	//功能说明：查询突发项目明细列表记录集字串
	//          记录之间"$c(1)"分割,字段之间"^"分割
	//入参：Parref,IsActive
	//出参：WMRRowid^Detail_Dr^ListIndex^IsActive^IsNeed^Resume^DefaultValue
	//调试：w ##class(web.DHCWMRWorkItemCtl).SLQueryDataByParFlagLIST("Parref","IsActive")
	//***************************************
	n (ParID,Flag)
	s iCount=..SLQueryDataByParFlagM(ParID,Flag)
    s JIndex=$p(iCount,"^",2),iCount=+iCount
	q:iCount<0 $$$OK
	f i=0:1:iCount d
	.s j=i+1
	.s $p(s,$c(1),j)=$g(^CacheTemp("SLQueryDataByParFlag",JIndex,i))
	q s
}

ClassMethod SLQueryDataByParFlagM(ParID, Flag)
{
    n (ParID,Flag)
    k ^CacheTemp("SLQueryDataByParFlag",$j)
    
    s n=0
    s:ParID'="" ParID=+ParID
    s:Flag'="" Flag=$s(Flag["Y":"Y",1:"N")
    q:ParID="" -1
    q:'$d(^DHCWMRWITM(ParID,"L")) -100
    s SubID=0
    f  s SubID=$o(^DHCWMRWITM(ParID,"L",SubID)) q:SubID=""  d
    .q:'$d(^DHCWMRWITM(ParID,"L",SubID))
    .q:((Flag'="")&&(Flag'=$p(^DHCWMRWITM(ParID,"L",SubID),"^",3)))
    .s WMRRowid=ParID_"||"_SubID
    .s ^CacheTemp("SLQueryDataByParFlag",$j,n)=..SLGetDataById(WMRRowid)
    .s n=n+1
    q n-1_"^"_$j
}

ClassMethod QueryStatusDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStatusDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryStatusDtlExecute(ByRef qHandle As %Binary, ParID As %String, Flag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:((ParID="")||(Flag="")) $$$OK
	s id=0
	f  s id=$o(^DHCWMRWITM(ParID,"L",id)) q:id=""  d
	.q:'$d(^DHCWMRWITM(ParID,"L",id))
	.s WorkItem=$g(^DHCWMRWITM(ParID,"L",id))
	.s DtlId=$p(WorkItem,"^",1)
	.s DtlActive=$p(WorkItem,"^",3)
	.q:(Flag'="")&&(Flag'=DtlActive)
	.s DtlInfo=$g(^DHCWMRWDTL(DtlId))
	.s DtlDesc=$p(DtlInfo,"^",2)
	.s s=DtlId_"^"_DtlDesc
	.d SDtlBuildData

	Quit $$$OK
SDtlBuildData
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryStatusDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStatusDtlExecute ]
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

Query QueryStatusDtl(ParID As %String, Flag As %String) As %Query(ROWSPEC = "DtlRowid:%String,DtlDesc:%String")
{
}

ClassMethod GetStatusDtl(ItmStatusId, Flag)
{
	n (ItmStatusId,Flag)
	
	s ret=""
	q:((ItmStatusId="")||(Flag="")) ret
	s id=0
	f  s id=$o(^DHCWMRWITM(ItmStatusId,"L",id)) q:id=""  d
	.q:'$d(^DHCWMRWITM(ItmStatusId,"L",id))
	.s WorkItem=$g(^DHCWMRWITM(ItmStatusId,"L",id))
	.s DtlId=$p(WorkItem,"^",1)
	.s DtlActive=$p(WorkItem,"^",3)
	.q:(Flag'="")&&(Flag'=DtlActive)
	.s DtlInfo=$g(^DHCWMRWDTL(DtlId))
	.s DtlDesc=$p(DtlInfo,"^",2)
	.s ret=ret_$c(1)_DtlId_"^"_DtlDesc
	q ret
}

ClassMethod LookUpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LookUpExecute(ByRef qHandle As %Binary, sBeRequest As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s RowId=""
	f  s RowId=$o(^DHCWMRWITM(RowId)) q:RowId=""  d
	.s s=$g(^DHCWMRWITM(RowId))
	.s ItemType=$p(s,"^",1)
	.s Description=$p(s,"^",2)
	.s IsActive=$p(s,"^",3)
	.s BeRequest=$p(s,"^",7)
	.q:IsActive'="Y"
	.q:(sBeRequest'=BeRequest)&(sBeRequest'="")
	.d BuildLookUp
	Quit $$$OK
BuildLookUp
	set Data=$lb(+RowId,Description)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod LookUpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpExecute ]
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

/// by wuqk 2008-2-26
/// for LookUp workItem must be request
Query LookUp(sBeRequest As %String) As %Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

}
