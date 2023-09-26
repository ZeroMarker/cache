/// Creator：gzj
/// Description：Vue版护理管理统计公共类 
/// Date：2017-08-31
Class web.NurMgStatComm Extends %RegisteredObject
{

/// Creator:gzj
/// Description:查询技术能手、服务之星数据统计
/// Date:2017-08-31
/// Table: DHCNMG.HR.MgTechService
/// Input:parr:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindElecteStat","")
Query FindElecteStat(parr As %String = "", type As %String, role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindElecteStatExecute(ByRef qHandle As %Binary, parr As %String = "", type As %String, role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s stmonth=$p(parr,"^",1)
	i stmonth'="" s stdate=$zdh(stmonth,3)
	e  s stdate=""
	s endmonth=$p(parr,"^",2)
	i endmonth'="" s enddate=$zdh(endmonth,3)
	e  s enddate=""
	s nurward=$p(parr,"^",3)
	s input=$zcvt($tr($p(parr,"^",4)," ",""),"U")
	s tmp=""
	k tmpWard
	s tmpWard="",isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s date="" f  s date=$O(^DHCNMG.HR.MgTechServiceI("dep"," "_type,date)) q:date=""  d
	.s nur="" f  s nur=$O(^DHCNMG.HR.MgTechServiceI("dep"," "_type,date,nur)) q:nur=""  d
	..s dep="" f  s dep=$O(^DHCNMG.HR.MgTechServiceI("dep"," "_type,date,nur,dep)) q:dep=""  d
	...s rowid="" f  s rowid=$O(^DHCNMG.HR.MgTechServiceI("dep"," "_type,date,nur,dep,rowid)) q:rowid=""  d
	....s obj=##class(DHCNMG.HR.MgTechService).%OpenId(rowid)
	....q:(isAll=0)&&((obj.ElecteWard="")||('$d(tmpWard(obj.ElecteWard))))
	....q:obj.ElecteStatus'="Y"
	....q:((stdate'="")&&(obj.ElecteDate<stdate))
	....q:((enddate'="")&&(obj.ElecteDate>enddate))
	....q:((nurward'="")&&(obj.ElecteWard'=nurward))
	....s nurse=obj.ElecteNurse
	....s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurse)
	....q:'$IsObject(perObj)
	....s nurseName=perObj.PerName
	....s nurseId=perObj.PerID
	....s shortName=##class(web.NurMgVueComm).ToChineseSpell(nurseName)
	....q:(input'="")&&(nurseName'[input)&&(nurseId'[input)&&(shortName'[input)
	....s ward=obj.ElecteWard
	....s month=$E($zd(obj.ElecteDate,8),1,6)
	....s tmp(ward,nurse,month)=+$g(tmp(ward,nurse,month))+1
	s Indep="" f  s Indep=$O(tmp(Indep)) q:Indep=""  d
	.s Innurse="" f  s Innurse=$O(tmp(Indep,Innurse)) q:Innurse=""  d
	..s n=0,NurseDep="",NurseID="",NurseMonth="",flag=0
	..s Inmonth="" f  s Inmonth=$O(tmp(Indep,Innurse,Inmonth)) q:Inmonth=""  d
	...s n=n+tmp(Indep,Innurse,Inmonth)
	...s NurseDep=Indep,NurseID=Innurse
	...i NurseMonth="" s NurseMonth=$E(Inmonth,1,4)_"-"_$E(Inmonth,5,6)
	...e  s NurseMonth=NurseMonth_"/"_$E(Inmonth,1,4)_"-"_$E(Inmonth,5,6)
	..s ret="electeWard|"_..GetWardVal(NurseDep)_"^elNurseName|"_$p(..GetNurseVal(NurseID),"^",1)_"^elNurseID|"_$p(..GetNurseVal(NurseID),"^",2)_"^electeDate|"_NurseMonth_"^electeCount|"_n
	..do OutputStatData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputStatData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindElecteStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindElecteStatExecute ]
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

ClassMethod FindElecteStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindElecteStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetWardVal(id As %String) As %String
{
	s ret=""
	s wardstr=##class(web.NurMgDBComm).GetWard(id)
	s ret=$p($p(wardstr,"^",3),"|",2)
	q ret
}

ClassMethod GetNurseVal(id As %String) As %String
{
	s ret=""
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	q:'$IsObject(obj)
	s ret=obj.PerName_"^"_obj.PerID
	q ret
}

/// creator: zhangjz
/// createdate: 2018-08-01
/// description: 工作量病区维护-病区查询
/// table: DHCNMG.DB.MgNurWorkLoadDepSet
/// input:
/// output:
/// return:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgStatComm","getWorkLoadDepSet","")
Query getWorkLoadDepSet(input As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod getWorkLoadDepSetExecute(ByRef qHandle As %Binary, input As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s Ret=""
    s DepSort="" f  s DepSort=$O(^DHCNMG.DB.MgNurWorkLoadDepSetI("DepSort",DepSort)) q:DepSort=""  d
    .s RowID="" f  s RowID=$O(^DHCNMG.DB.MgNurWorkLoadDepSetI("DepSort",DepSort,RowID)) q:RowID=""  d
    ..s Obj=##class(DHCNMG.DB.MgNurWorkLoadDepSet).%OpenId(RowID)
    ..i $IsObject(Obj) d
    ...s WardID=Obj.DepDR
    ...s WardType=""
    ...s MgSysParamSubID="" f  s MgSysParamSubID=$O(^DHCNMG.Set.MgSysParamSubD(1,MgSysParamSubID)) q:MgSysParamSubID=""  d
    ....s SubCode=$lg($g(^DHCNMG.Set.MgSysParamSubD(1,MgSysParamSubID)),2)
    ....s SubDesc=$lg($g(^DHCNMG.Set.MgSysParamSubD(1,MgSysParamSubID)),3)
    ....i SubCode=Obj.Typ  s WardType=SubDesc
    ...s WardSort=Obj.DepSort
    ...s WardDesc="",WardInput=""
    ...s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(WardID)
    ...i $IsObject(WardObj) d
    ....s WardDesc=WardObj.WardDesc
    ....s WardInput=WardDesc_WardObj.WardSpell
    ...q:((input'="")&&(WardInput'="")&&(WardInput'[$zcvt($tr(input," ",""),"U")))
    ...s Ret="WardID|"_WardID_"^WardDesc|"_WardDesc_"^RowID|"_RowID_"^WardType|"_WardType_"^WardSort|"_WardSort
    ...d OutCheckWardList
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    
OutCheckWardList
    set Data=$lb(Ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod getWorkLoadDepSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getWorkLoadDepSetExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod getWorkLoadDepSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getWorkLoadDepSetExecute ]
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

/// Description：病区查询
/// Date:2018-08-01
/// Creator:zhangjz
/// Table:DHCNMG.DB.MgWard
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.NurMgStatComm","FindMgWard","")
Query FindMgWard(input As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindMgWardExecute(ByRef qHandle As %Binary, input As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s Ret=""
    s Spell="" f  s Spell=$O(^DHCNMG.DB.MgWardI("Spell",Spell)) q:Spell=""  d
    .s RowID="" f  s RowID=$O(^DHCNMG.DB.MgWardI("Spell",Spell,RowID)) q:RowID=""  d
    ..s Obj=##class(DHCNMG.DB.MgWard).%OpenId(RowID)
    ..q:((input'="")&&((Obj.WardSpell_Obj.WardCode)'[$zcvt($tr(input," ",""),"U")))
    ..s warddesc=Obj.WardDesc
    ..s wardType=""
    ..s WardTypeDR=Obj.WardTypeDR
    ..i $IsObject(WardTypeDR) d
    ...s wardType=WardTypeDR.SubDesc
    ..s Ret="warddesc|"_warddesc_"^wardid|"_RowID_"^wardType|"_wardType
    ..d OutCheckWardSet
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutCheckWardSet
    set Data=$lb(Ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod FindMgWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMgWardExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod FindMgWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMgWardExecute ]
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

/// creator: zhangjz
/// createdate: 2018-08-01
/// description: 删除工作量病区
/// table: DHCNMG.DB.MgNurWorkLoadDepSet
/// input:
/// output:
/// return:
/// other:w ##class(web.NurMgStatComm).DeleteWorkLoadDepSet("1^2^3^4^5")
ClassMethod DeleteWorkLoadDepSet(parr As %String) As %String
{
    f i=1:1:$L(parr,"^") d
    .s id=$p(parr,"^",i)
    .q:id=""
    .s Obj=##class(DHCNMG.DB.MgNurWorkLoadDepSet).%OpenId(id)
    .s sort=Obj.DepSort
    .s sc=Obj.%DeleteId(id)
    .s DepSetid="" f  s DepSetid=$O(^DHCNMG.DB.MgNurWorkLoadDepSetI("DepSort",sort+1,DepSetid)) q:DepSetid=""  d
    ..s DepSetObj=##class(DHCNMG.DB.MgNurWorkLoadDepSet).%OpenId(DepSetid)
    ..s DepSetObj.DepSort=sort
    ..s sort=sort+1
    ..d DepSetObj.%Save()
    q $$$ISOK(sc)
}

/// Description:保存工作量病区
/// Date:2018-08-01
/// Creator:zhangjz
/// Table:DHCNMG.DB.MgNurWorkLoadDepSet
/// Input:
/// Output:
/// other:w ##class(web.NurMgStatComm).SaveWorkLoadDepSet("2|病区^45|")
ClassMethod SaveWorkLoadDepSet(parr As %String) As %String
{
    s Flag=1
    s Len=$l(parr,"^")
    f i=1:1:Len
    {
        s Itm=$p(parr,"^",i)
        i Itm="" continue
        s WardId=$p(Itm,"|",1)
        s WardType=$p(Itm,"|",2)
        s RowID=$O(^DHCNMG.DB.MgNurWorkLoadDepSetI("Dep",WardId,""))
        s WardCode=WardType
        i RowID=""
        {
            s ParId=$O(^DHCNMG.Set.MgSysParamI("Code"," "_$zcvt("WardType","U"),""))
            i ParId="" q
            ;s Par="" f  s Par=$O(^DHCNMG.Set.MgSysParamSubD(Par)) q:Par=""  d
            ;.q:(parid'="")&&(parid'=par)
            s Child="" f  s Child=$O(^DHCNMG.Set.MgSysParamSubD(ParId,Child)) q:Child=""  d
            .s Id=ParId_"||"_Child
            .s Obj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(Id)
            .s Code=Obj.SubCode
            .s Desc=Obj.SubDesc
            .i Desc=WardType s WardCode=Code
            s DepSetObj=##class(DHCNMG.DB.MgNurWorkLoadDepSet).%New()
            s DepSetObj.DepDR=WardId
            s DepSetObj.Typ=WardCode
            s DepSetObj.DepSort=..GetWardSort()
            s sc=DepSetObj.%Save()
            s Flag=Flag&&$$$ISOK(sc)
        }
    }
    q Flag
}

ClassMethod GetWardSort() As %String
{
    s Flag=1
    s Sort=$O(^DHCNMG.DB.MgNurWorkLoadDepSetI("DepSort",""),-1)
    i Sort'="" s Flag=$tr(Sort," ","")+1
    q Flag
}

/// Description:工作量病区上移下移操作
/// Date:2018-08-01
/// Creator:zhangjz
/// other:w ##class(web.NurMgStatComm).MoveWorkLoadDepSet("up",1)
ClassMethod MoveWorkLoadDepSet(type, rowid) As %String
{
    q:rowid="" ""
    s Obj=##class(DHCNMG.DB.MgNurWorkLoadDepSet).%OpenId(rowid)
    q:'$IsObject(Obj) ""
    s DepSort=Obj.DepSort
    i type="up"
    {
        q:DepSort=1 "已是最顶部记录了"
        //^DHCNMG.DB.MgNurCheckWardI("Sort"," N",1,1)
        s upsort=DepSort-1
        s uprow=$O(^DHCNMG.DB.MgNurWorkLoadDepSetI("DepSort",upsort,""))
        s upobj=##class(DHCNMG.DB.MgNurWorkLoadDepSet).%OpenId(uprow)
        s upobj.DepSort=DepSort
        d upobj.%Save()
        s Obj.DepSort=upsort
        d Obj.%Save()
        
    }
    elseif type="down"
    {
        s sort=$O(^DHCNMG.DB.MgNurWorkLoadDepSetI("DepSort",""),-1)
        q:DepSort=sort "已是最底部记录了"
        s upsort=DepSort+1
        s uprow=$O(^DHCNMG.DB.MgNurWorkLoadDepSetI("DepSort",upsort,""))
        s upobj=##class(DHCNMG.DB.MgNurWorkLoadDepSet).%OpenId(uprow)
        s upobj.DepSort=DepSort
        d upobj.%Save()
        s Obj.DepSort=upsort
        d Obj.%Save()
        
    }
    q 0
}

ClassMethod IsExistCode(parr As %String) As %String
{
	//WorkItm|静脉输液^WorkCode|静脉输液^WorkDistill|WorkLoad^WorkRelItm|Instruct^WorkPercent|0.1^WorkMeth|
    //^CurrFlag|Yes^StartDate|2018-10-25^EndDate|^rowid|1^
    s tmp=""
    s flag=0
    d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
    s id=$g(tmp("rowid"))
    s code=$zcvt($tr($g(tmp("WorkCode"))," ",""),"U")
    s Distill=$g(tmp("WorkDistill"))
    s rw=$o(^DHCNMG.DB.MgNurWorkLoadItmI("Type"," "_Distill," "_code,""))
    i rw="" s flag=0
    e  i rw'=""  d
    .i id=rw s flag=0
    .e  i id'=rw s flag=1
    q flag
}

/// creator:zhangjz
/// date:2018-08-03
/// desc:保存工作量项目表
/// table:DHCNMG.DB.MgNurWorkLoadItm
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).SaveWorkLoadItm("WorkItm|测试^WorkCode|test^WorkDistill|W^WorkRelItm|I^WorkPercent|12^WorkMeth|^CurrFlag|Y^StartDate|2017-08-17^EndDate|^rowid|3^")
ClassMethod SaveWorkLoadItm(parr As %String) As %String
{
    q:parr="" ""
    d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
    //WorkCode不允许重复
    s flag=0
	s WorkDistill="" f  s WorkDistill=$o(^DHCNMG.DB.MgNurWorkLoadItmI("Type",WorkDistill)) q:WorkDistill=""  d
	.s WorkCode="" f  s WorkCode=$o(^DHCNMG.DB.MgNurWorkLoadItmI("Type",WorkDistill,WorkCode)) q:WorkCode=""  d
    ..s id="" f  s id=$o(^DHCNMG.DB.MgNurWorkLoadItmI("Type",WorkDistill,WorkCode,id)) q:(id=""||flag=1)  d
	...i (($tr(WorkCode," ","")=$zcvt($g(tmp("WorkCode")),"U"))&&(id'=$g(tmp("rowid")))) s flag=1
    q:flag'=0 -1
    i $g(tmp("rowid"))'="" d
    .s Obj=##class(DHCNMG.DB.MgNurWorkLoadItm).%OpenId(tmp("rowid"))
    e  d
    .s Obj=##class(DHCNMG.DB.MgNurWorkLoadItm).%New()
    s Obj.WorkItm=$g(tmp("WorkItm"))
    s Obj.WorkCode=$g(tmp("WorkCode"))
    s Obj.WorkDistill=$g(tmp("WorkDistill"))
    s Obj.WorkRelItm=$g(tmp("WorkRelItm"))
    s Obj.WorkPercent=$g(tmp("WorkPercent"))
    s Obj.WorkMeth=$g(tmp("WorkMeth"))
    s CurrFlag=""
    i $g(tmp("CurrFlag"))="Yes" s CurrFlag="Y"
    i $g(tmp("CurrFlag"))="No" s CurrFlag="N"
    i CurrFlag'="" s Obj.CurrFlag=CurrFlag
    i $g(tmp("StartDate"))'="" s Obj.StartDate=$zdh(tmp("StartDate"),3)
    e  s Obj.StartDate=""
    i $g(tmp("EndDate"))'="" s Obj.EndDate=$zdh(tmp("EndDate"),3)
    e  s Obj.EndDate=""
    s sc=Obj.%Save()
    q $$$ISOK(sc)
}

/// creator: zhangjz
/// date:2018-08-03
/// description: 获取工作量项目列表
/// table: DHCNMG.DB.MgNurWorkLoadItm
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgStatComm","FindWorkLoadItmList","","df")
Query FindWorkLoadItmList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWorkLoadItmListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s Ret=""
    s itype="" f  s itype=$O(^DHCNMG.DB.MgNurWorkLoadItmI("TYP",itype)) q:itype=""  d
    .s id="" f  s id=$O(^DHCNMG.DB.MgNurWorkLoadItmI("TYP",itype,id)) q:id=""  d
    ..s Obj=##class(DHCNMG.DB.MgNurWorkLoadItm).%OpenId(id)
    ..;q:((parr'="")&&(Obj.WardLocDR'="")&&(Obj.WardLocDR.%Id()'=parr))
    ..q:((input'="")&&((Obj.WorkItm_Obj.WorkCode)'[$tr(input," ","")))
    ..;s Ret=..GetWorkLoadItm(id)
    ..s WorkItm=Obj.WorkItm
    ..s WorkCode=Obj.WorkCode
    ..s WorkDistill=##class(web.NurMgHISComm).GetDescForSysType("WorkDistill",Obj.WorkDistill)
    ..s WorkRelItm=##class(web.NurMgHISComm).GetDescForSysType("WorkRelItm",Obj.WorkRelItm)
    ..s WorkPercent=Obj.WorkPercent
    ..s WorkMeth=Obj.WorkMeth
    ..i Obj.CurrFlag="Y" s CurrFlag="Yes"
    ..e  i Obj.CurrFlag="N" s CurrFlag="No"
    ..i Obj.StartDate'="" s StartDate=##class(web.NurMgHISComm).DateLogicalToHtml(Obj.StartDate)
    ..e  s StartDate=""
    ..i Obj.EndDate'="" s EndDate=##class(web.NurMgHISComm).DateLogicalToHtml(Obj.EndDate)
    ..e  s EndDate=""
    ..s Ret="rowid|"_id_"^WorkItm|"_WorkItm_"^WorkCode|"_WorkCode_"^WorkDistill|"_WorkDistill_"^WorkRelItm|"_WorkRelItm_"^WorkPercent|"_WorkPercent_"^WorkMeth|"_WorkMeth_"^CurrFlag|"_CurrFlag_"^StartDate|"_StartDate_"^EndDate|"_EndDate
    ..d OutWard
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutWard
    set Data=$lb(Ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod FindWorkLoadItmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkLoadItmListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod FindWorkLoadItmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkLoadItmListExecute ]
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

/// creator: zhangjz
/// date:2018-08-03
/// description: 获取工作量项目列表
/// table: DHCNMG.DB.MgNurWorkLoadItm
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).GetWorkLoadItm(1)
ClassMethod GetWorkLoadItm(id As %String) As %String
{
    q:id="" ""
    s Obj=##class(DHCNMG.DB.MgNurWorkLoadItm).%OpenId(id)
    s Ret="rowid|"_id
    s Ret=Ret_"^WorkItm|"_Obj.WorkItm
    s Ret=Ret_"^WorkCode|"_Obj.WorkCode
    s WorkDistill=Obj.WorkDistill
    s Ret=Ret_"^WorkDistill|"_WorkDistill
    s WorkRelItm=Obj.WorkRelItm
    s Ret=Ret_"^WorkRelItm|"_WorkRelItm
    s Ret=Ret_"^WorkPercent|"_Obj.WorkPercent
    s Ret=Ret_"^WorkMeth|"_Obj.WorkMeth
    s CurrFlag=""
    i Obj.CurrFlag="Y" s CurrFlag="Yes"
    i Obj.CurrFlag="N" s CurrFlag="No"
    s Ret=Ret_"^CurrFlag|"_CurrFlag
    i Obj.StartDate'="" s Ret=Ret_"^StartDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(Obj.StartDate)
    i Obj.EndDate'="" s Ret=Ret_"^EndDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(Obj.EndDate)
    q Ret
}

/// creator: zhangjz
/// date:2018-08-03
/// description: 删除工作量项目
/// table: DHCNMG.DB.MgNurWorkLoadItm
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).DeleteWorkLoadItm(1)
ClassMethod DeleteWorkLoadItm(id As %String) As %String
{
    q:id="" ""
    s Obj=##class(DHCNMG.DB.MgNurWorkLoadItm).%OpenId(id)
    i '$IsObject(Obj) q 0
    s sc=Obj.%DeleteId(id)
    s subRowId=$O(^DHCNMG.DB.MgNurWorkLoadItmSubI("WorkItm",id,""))
    q:subRowId="" $$$ISOK(sc)
    s subObj=##class(DHCNMG.DB.MgNurWorkLoadItmSub).%OpenId(subRowId)
    q:'$IsObject(subObj) $$$ISOK(sc)
    s sc=subObj.%DeleteId(subRowId)
    q $$$ISOK(sc)
}

/// creator:zhangjz
/// date:2018-08-07
/// desc:保存工作量项目关联类别"itmId|6^workRelInstruct|^workRelArcim|11548!1^"
/// table:DHCNMG.DB.MgNurWorkLoadItmSub
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).SaveWorkLoadItmSub("itmId|6^workRelInstruct|^workRelArcim|11548!1")
ClassMethod SaveWorkLoadItmSub(parr As %String) As %String
{
    q:parr="" ""
    d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
    s ItmObj=##class(DHCNMG.DB.MgNurWorkLoadItm).%OpenId(tmp("itmId"))
    ;s SubId=$O(^DHCNMG.DB.MgNurWorkLoadItmSubI("WorkItm",tmp("itmId"),""))
    ;i SubId="" d
    ;.s SubObj=##class(DHCNMG.DB.MgNurWorkLoadItmSub).%New()
    ;e  d
    ;.s SubObj=##class(DHCNMG.DB.MgNurWorkLoadItmSub).%OpenId(SubId)
    s SubObj=##class(DHCNMG.DB.MgNurWorkLoadItmSub).%New()
    s SubObj.WorkItm=ItmObj
    s SubObj.WorkRelInstruct=$g(tmp("workRelInstruct"))
    s ARCIMRowid=$p($g(tmp("workRelArcim")),"!",1)
    s ARCIMSub=$p($g(tmp("workRelArcim")),"!",2)
    s WorkRelArcim=ARCIMRowid_"||"_ARCIMSub
    s SubObj.WorkRelArcim=WorkRelArcim
    s Sc=SubObj.%Save()
    q $$$ISOK(Sc)
}

ClassMethod IsExistRecArcim(parr As %String) As %String
{
	q:parr="" -1
}

/// creator:zhangjz
/// date:2018-08-07
/// desc:保存工作量项目关联类别"itmId|6^workRelInstruct|^workRelArcim|11548!1^"
/// table:DHCNMG.DB.MgNurWorkLoadItmSub
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).SaveWorkRelArcim("itmId|3^workRelInstruct|^workRelArcim|11362!1,11363!1")
ClassMethod SaveWorkRelArcim(parr As %String) As %String
{
    q:parr="" ""
    s Sc=0
    d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
    f i=1:1:$L($g(tmp("workRelArcim")),",") d
    .s id=$p($g(tmp("workRelArcim")),",",i)
    .q:id=""
    .s ARCIMRowid=$p(id,"!",1)
    .s ARCIMSub=$p(id,"!",2)
    .s WorkRelArcim=ARCIMRowid_"||"_ARCIMSub
    .s SubId=$O(^DHCNMG.DB.MgNurWorkLoadItmSubI("ItmArcimInstr"," "_WorkRelArcim,""))
    .q:SubId'=""
    .s ItmObj=##class(DHCNMG.DB.MgNurWorkLoadItm).%OpenId(tmp("itmId"))
    .;s SubId=$O(^DHCNMG.DB.MgNurWorkLoadItmSubI("WorkItm",tmp("itmId"),""))
    .;i SubId="" d
    .;.s SubObj=##class(DHCNMG.DB.MgNurWorkLoadItmSub).%New()
    .;e  d
    .;.s SubObj=##class(DHCNMG.DB.MgNurWorkLoadItmSub).%OpenId(SubId)
    .s SubObj=##class(DHCNMG.DB.MgNurWorkLoadItmSub).%New()
    .s SubObj.WorkItm=ItmObj
    .s SubObj.WorkRelInstruct=$g(tmp("workRelInstruct"))    
    .s SubObj.WorkRelArcim=WorkRelArcim
    .s Sc=SubObj.%Save()
    q $$$ISOK(Sc)
}

/// creator:zhangjz
/// date:2018-08-08
/// desc:查询所有医嘱
/// table:
/// input:
/// output:
/// other:  d ##class(%ResultSet).RunQuery("web.NurMgStatComm","FindOrdItm","","静脉输")
Query FindOrdItm(ids As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindOrdItmExecute(ByRef qHandle As %Binary, ids As %String = "", input As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    q:"" ""
    s ids=$ZConvert(ids,"U")
    s id=ids_" "
    s ln=$L(ids)
    s im=ids
    s Flag=0
    s Ret=""
    s n=0
    
    f  s id=$O(^ARC("ALIAS",0,"Desc",id)) q:((id="")!(Flag=1))  d
    .q:id="0 "
    .if $E($TR(id," ",""),0,ln)'=im s Flag=1
    .s ItmName=""
    .s des="" f  s des=$O(^ARC("ALIAS",0,"Desc",id,des)) q:((des="")!(Flag=1))  d
    ..s rw=""  f  s rw=$O(^ARC("ALIAS",0,"Desc",id,des,rw)) q:((rw="")!(Flag=1))  d
    ...s typ=$P(^ARC("ALIAS",0,"Desc",id,des,rw,1),"^",2)
    ...q:typ'="ARCIM"
    ...s arcimrow=$P(^ARC("ALIAS",0,"Desc",id,des,rw,1),"^",1)
    ...s ARCIMRowid=$P(arcimrow,"||",1)
    ...s ARCIMSub=$P(arcimrow,"||",2) 
    ...s ItmName=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2) 
    ...s ItmName=$tr(ItmName,"|","-")
    ...s ItmName=$tr(ItmName,":","-")
    ...s ItmName=$tr(ItmName,"[","(")
    ...s ItmName=$tr(ItmName,"]",")")
    ...s ItmName=$tr(ItmName,"\","")
    ...s ItmName=$tr(ItmName,"'","")
    ...s aa=ARCIMRowid_"!"_ARCIMSub
    ...;s ItmSort=##class(web.NurMgVueComm).ToChineseSpell(ItmName)
    ...;q:((input'="")&((id_ItmName)'[$tr(input," ",""))&((id_ItmSort)'[$tr($ZConvert(input,"U")," ","")))
    ...q:((input'="")&((id_ItmName)'[$zcvt($tr(input," ",""),"U")))
    ...s Ret="OrdId|"_aa_"^OrdItm|"_id_"-"_ItmName
    ...d OutputRow
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    
    set Data=$lb(Ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindOrdItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrdItmExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
    }
    Else {      
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindOrdItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrdItmExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// creator:zhangjz
/// date:2018-08-08
/// desc:下拉框查询用药途径
/// table:
/// input:
/// output:
/// other:  d ##class(%ResultSet).RunQuery("web.NurMgStatComm","GetPhcin","")
Query GetPhcin(typ As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod GetPhcinExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s typ=$zcvt(typ,"U")
    s Chl=0  f  s Chl=$O(^PHCIN(Chl) )  q:Chl=""  d
    .s des=$P(^PHCIN(Chl) ,"^",2)
    .q:(typ'="")&&(des'[typ)
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
  
OutRowtyp
    s Ret="PhcinId|"_Chl_"^PhcinDesc|"_des
    set Data=$lb(Ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetPhcinFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPhcinExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetPhcinClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPhcinExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// creator: zhangjz
/// date:2018-08-08
/// desc:获取工作量项目关联类别--未使用
/// table:DHCNMG.DB.MgNurWorkLoadItmSub
/// input:MgNurWorkLoadItm.RowId
/// output:
/// other: w ##class(web.NurMgStatComm).GetWorkLoadItmSub("3")
ClassMethod GetWorkLoadItmSub(id As %String) As %String
{
    q:id="" ""
    s itmObj=##class(DHCNMG.DB.MgNurWorkLoadItm).%OpenId(id)
    s subRowId=$O(^DHCNMG.DB.MgNurWorkLoadItmSubI("WorkItm",id,""))
    q:subRowId="" ""
    s subObj=##class(DHCNMG.DB.MgNurWorkLoadItmSub).%OpenId(subRowId)
    q:'$IsObject(subObj) ""
    s workRelArcim=subObj.WorkRelArcim
    s workRelInstruct=subObj.WorkRelInstruct
    s Ret="workRelArcim|"_workRelArcim_"^workRelInstruct|"_workRelInstruct_"^SubRowId|"_subRowId
    q Ret
}

/// creator:zhangjz
/// date:2018-08-10
/// desc:查询工作量项目关联的医嘱
/// table:DHCNMG.DB.MgNurWorkLoadItmSub
/// input:
/// output:
/// other:  d ##class(%ResultSet).RunQuery("web.NurMgStatComm","FindWorkLoadItmSub","2","")
Query FindWorkLoadItmSub(id As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWorkLoadItmSubExecute(ByRef qHandle As %Binary, id As %String = "", input As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    q:id="" ""
    s itmObj=##class(DHCNMG.DB.MgNurWorkLoadItm).%OpenId(id)
    s subRowId="" f  s subRowId=$O(^DHCNMG.DB.MgNurWorkLoadItmSubI("WorkItm",id,subRowId)) q:subRowId=""  d
    .s subObj=##class(DHCNMG.DB.MgNurWorkLoadItmSub).%OpenId(subRowId)
    .q:'$IsObject(subObj)
    .s orderItmId=subObj.WorkRelArcim
    .q:orderItmId=""
    .d OutputRow
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    
    
OutputRow
    ;s des=$O(^ARC("ALIAS",0,"Desc",orderItmId,""))
    ;s Ret="OrdId|"_orderItmId_"^OrdItm|"_des_"^SubRowId|"_subRowId
    s ARCIMRowid=$P(orderItmId,"||",1)
    q:(ARCIMRowid="")
    s ARCIMSub=$P(orderItmId,"||",2) 
    q:ARCIMSub=""
    s ItmName=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name  
    s ItmName=$tr(ItmName,"|","-")
    s ItmName=$tr(ItmName,":","-")
    s ItmName=$tr(ItmName,"[","(")
    s ItmName=$tr(ItmName,"]",")")
    s ItmName=$tr(ItmName,"\","")
    s ItmName=$tr(ItmName,"'","")   //有'会报错
    ;s ItmName=$tr(ItmName,"[","(")
    ;s ItmName=$tr(ItmName,"]",")")
    s ItmSort=##class(web.NurMgVueComm).ToChineseSpell(ItmName)
    q:((input'="")&(ItmName'[$tr(input," ",""))&(ItmSort'[$tr($ZConvert(input,"U")," ","")))
    ;s Ret=Ret_aa_"|"_id_"-"_ItmName_"^"        OrdId,OrdItm
    s Ret="OrdId|"_orderItmId_"^OrdItm|"_ItmName_"^SubRowId|"_subRowId
    set Data=$lb(Ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindWorkLoadItmSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkLoadItmSubExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
    }
    Else {      
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindWorkLoadItmSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkLoadItmSubExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// creator:zhangjz
/// date:2018-08-10
/// desc:查询工作量项目关联的用法
/// table:DHCNMG.DB.MgNurWorkLoadItmSub
/// input:
/// output:
/// other:  d ##class(%ResultSet).RunQuery("web.NurMgStatComm","FindWorkLoadInstruct","6","")
Query FindWorkLoadInstruct(id As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWorkLoadInstructExecute(ByRef qHandle As %Binary, id As %String = "", input As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    q:id="" ""
    s itmObj=##class(DHCNMG.DB.MgNurWorkLoadItm).%OpenId(id)
    s subRowId="" f  s subRowId=$O(^DHCNMG.DB.MgNurWorkLoadItmSubI("WorkItm",id,subRowId)) q:subRowId=""  d
    .s subObj=##class(DHCNMG.DB.MgNurWorkLoadItmSub).%OpenId(subRowId)
    .q:'$IsObject(subObj)
    .s instructId=subObj.WorkRelInstruct
    .q:instructId=""
    .s instructData=$g(^PHCIN(instructId))
    .q:instructData=""
    .d OutputRow
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    
OutputRow
    s instructDes=$P(instructData,"^",2)
    s Ret="InstructId|"_instructId_"^InstructDes|"_instructDes_"^SubRowId|"_subRowId
    set Data=$lb(Ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindWorkLoadInstructFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkLoadInstructExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
    }
    Else {      
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindWorkLoadInstructClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkLoadInstructExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// creator: zhangjz
/// date:2018-08-15
/// description: 删除工作量项目关联类别
/// table: DHCNMG.DB.MgNurWorkLoadItm
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).DeleteWorkLoadItm(1)
ClassMethod DeleteWorkLoadItmSub(ids As %String) As %String
{
    q:ids="" ""
    f i=1:1:$L(ids,",") d
    .s id=$P(ids,",",i)
    .s Obj=##class(DHCNMG.DB.MgNurWorkLoadItmSub).%OpenId(id)
    .i '$IsObject(Obj) q
    .s sc=Obj.%DeleteId(id)
    q $$$ISOK(sc)
}

/// creator: zhangjz
/// date:2018-08-22
/// description: 生成病房工作量日报数据任务  
/// table: DHCNMG.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).WardDayReport("2018-04-01")
ClassMethod WardDayReport(parr As %String) As %String
{
    ;s sysdate=+$H-1
    s sysdate=$ZDH(parr,3)
    ;s sysdate="64750"
    s sysdate=$zd(sysdate,3)
    s sysdate2=sysdate
    //s ab=##class(web.NurMgStatComm).GenerateWardReport(sysdate,sysdate2,"3901")
    //s ab=##class(web.NurMgStatComm).GenerateWardReport(sysdate,sysdate2,"1")
    s ab=##class(web.NurMgStatComm).GenerateWardReport(parr,sysdate2,"1")
    q 0
}

/// creator: zhangjz
/// date:2018-08-22
/// description: 生成病房工作量日报数据任务  
/// table: DHCNMG.Work.MgNurWorkReport
/// input:
/// output:
/// other: d ##class(web.NurMgStatComm).GenerateWardReport("2018-04-12","2018-04-12","1")
ClassMethod GenerateWardReport(StDate As %String, EndDate As %String, User = "1") As %String
{
    s StDate=$ZDH(StDate,3)
    s EndDate=$ZDH(EndDate,3)
    s Typ="W"
	b ;210
    s WorkLoad="",NurWork="",LoadItm=""
    s Rw=""  f  s Rw=$O(^DHCNMG.DB.MgNurWorkLoadItmI("TYP"," "_Typ,Rw)) q:Rw=""  d
    .s Obj=##class(DHCNMG.DB.MgNurWorkLoadItm).%OpenId(Rw)
    .q:'$IsObject(Obj)
    .s WkitmDesc=Obj.WorkItm
    .//计算入院人数
    .i WkitmDesc["入院" d ..GetNotOrderNum(StDate,StDate,.WorkLoad,Rw) q
    .s TypPhc=Obj.WorkRelItm  //项目类别
    .i TypPhc="" s TypPhc="N"
    .s Flag=Obj.CurrFlag
    .q:Flag'="Y" //不可用
    .s Styp=Obj.WorkDistill  //提取方式
    .q:Styp'="W"
    .s StringPhc=""
    .s Raw1="" f  s Raw1=$O(^DHCNMG.DB.MgNurWorkLoadItmSubI("WorkItm",Rw,Raw1)) q:Raw1=""  d
    ..s Rel=Raw1
    ..s ObjSub=##class(DHCNMG.DB.MgNurWorkLoadItmSub).%OpenId(Rel)
    ..q:'$IsObject(ObjSub)
    ..i TypPhc'="I" s Itm=ObjSub.WorkRelArcim
    ..e  i TypPhc="I"  s Itm=ObjSub.WorkRelInstruct
    ..q:Itm=""
    ..d ..GetNurWorkByExecDate(Itm,StDate,StDate,.NurWork,.WorkLoad,.LoadItm,Rw,Rel)
    if $D(WorkLoad) d ..DeleteWorkDayReport($ZD(StDate,3))
    if $D(WorkLoad) d ..InsertWork(.NurWork,.WorkLoad,.LoadItm,StDate,StDate,User)
    q ""
}

/// creator: zhangjz
/// date:2018-08-22
/// description: 生成病房工作量日报数据任务  
/// table: DHCNMG.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm)GetNotOrderNum()
ClassMethod GetNotOrderNum(StDate, EndDate, WorkLoad, WkItm) As %String
{
    i +StDate'=StDate s StDate=$ZDH(StDate,3)
    i +EndDate'=EndDate s EndDate=$ZDH(EndDate,3)
    s WkitmName=$listget(^DHCNMG.DB.MgNurWorkLoadItmD(WkItm),2)
    k MotherAdm
    f Date=StDate:1:EndDate
    {
        if WkitmName["入院"
        {
            s DepItm=##class(web.NurMgStatComm).GetSortDep("W")
            s Num=0
            s l=$L(DepItm,"^")
            for i=1:1:l d
            .s aa=$P(DepItm,"^",i)
            .if aa="" continue
            .s Dep=$P(aa,"|")
            .s Loc=Dep
            .//产科新生儿不计入院数
            .//i (Loc=27)!(Loc=28)!(Loc=29)!(Loc=30)!(Loc=150)!(Loc=152) s BabyFlag="1"
            .//else  s BabyFlag="0"
            .s CurDate=$zd(Date,3)
            .s Pacward=$O(^PAWARD(0,"WARD_LocationDR",Dep,""))
            .q:Pacward=""
            .s Num=0
            .s AdmId="" f  s AdmId=$o(^PAADMi("PAADM_AdmDate",Date,AdmId)) q:AdmId=""  d
            ..s PAADMType=$P($g(^PAADM(AdmId)),"^",2)
            ..q:PAADMType'="I"
            ..//s MotherAdm=$p($g(^PAADM(RowId2)),"^",75)
            ..s MotherAdm=$p($g(^PAADM(AdmId)),"^",75)
            ..//q:(MotherAdm'="")&&(BabyFlag="1")
            ..s Flag=0
            ..s TRANSChild="" f  s TRANSChild=$o(^PAADM(AdmId,"TRANS",TRANSChild)) q:(TRANSChild="")!(Flag=1)  d
            ...q:Flag=1
            ...s TRANSWard=$p($g(^PAADM(AdmId,"TRANS",TRANSChild)),"^",9)
            ...s TRANSStartDate=$p($g(^PAADM(AdmId,"TRANS",TRANSChild)),"^",1)
            ...i (TRANSWard=Pacward)&(Date=TRANSStartDate) d
            ....s Num=Num+1
            ....s Flag=1
            .i Num="" s Num=0
            .d CalNum23(Num,WkItm,Dep)
        }
    }
    q 0
CalNum23(Num,WkItm,Dep)
    s a=^DHCNMG.DB.MgNurWorkLoadItmD(WkItm)
    s Styp=$List(a,4)
    q:Styp'="W" //
    s Flag=$List(a,8)
    q:Flag="N"  //不可用
    s WorkLoad(Dep,WkItm)=$G(WorkLoad(Dep,WkItm))+Num
    q
}

/// creator: zhangjz
/// date:2018-08-22
/// description: 生成病房工作量日报数据任务-获取科室
/// table: DHCNMG.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).WardDayReport()
ClassMethod GetSortDep(Typ) As %String
{
    s Typ=$zcvt(Typ,"U")
    s Ret=""
    s DepDR="" f  s DepDR=$O(^DHCNMG.DB.MgWardD(DepDR)) q:DepDR=""  d
    .s Obj=##class(DHCNMG.DB.MgWard).%OpenId($tr(DepDR," ",""))
    .q:'$IsObject(Obj)
    .q:'$IsObject(Obj.CTLocDR)
    .s CTLocDR=Obj.CTLocDR.%Id()
    .q:CTLocDR=""
    .s Dep=$Tr(CTLocDR," ","")
    .s Des=$P($g(^CTLOC(Dep)),"^",2)
    .s Ret=Ret_Dep_"|"_Des_"^"
    q Ret
}

/// creator: zhangjz
/// date:2018-08-22
/// description: 生成病房工作量日报数据任务  
/// table: DHCNMG.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).WardDayReport()
ClassMethod InsertWork(NurWork, WorkLoad, LoadItm, StDate, EndDate, User) As %String
{
     TSTART
     s Ward=""  f  s Ward=$O(WorkLoad(Ward)) q:Ward=""  d
     .s Rep=##class(DHCNMG.Work.MgNurWorkReport).%New()
     .s Rep.WorkDepDr=Ward
     .s Rep.WorkStDate=StDate
     .s Rep.WorkEndDate=EndDate
     .s Rep.WorkCreateDate=+$H
     .s Rep.WorkCreatTime=$P($H,",",2)
     .if $$$ISOK(Rep) d
     ..d Rep.%Save()
     ..d Rep.%Close()
     .e  d
     ..TROLLBACK
     .s Itm="" f  s Itm=$O(WorkLoad(Ward,Itm)) q:Itm=""  d
     ..s RepWard=##class(DHCNMG.Work.MgNurWorkRpWard).%New()
     ..s RepWard.WardParref=Rep
     ..s RepWard.WardWorkItm=##class(DHCNMG.DB.MgNurWorkLoadItm).%OpenId(Itm)
     ..i $L(WorkLoad(Ward,Itm),".")>1 d
     ...s RepWard.WardWorkNum=$fn(WorkLoad(Ward,Itm),"",2)
     ..e  d
     ...s RepWard.WardWorkNum=WorkLoad(Ward,Itm)
     ..s WorkPercent=RepWard.WardWorkItm.WorkPercent
     ..s RepWard.WardWorkCount=$fn(WorkLoad(Ward,Itm)*WorkPercent,"",2)
     ..if $$$ISOK(RepWard) d
     ...d RepWard.%Save()
     ...s SubItm="" f  s subitm=$O(LoadItm(Ward,Itm,SubItm)) q:SubItm=""  d
     ....s Item=##class(DHCNMG.Work.MgNurWorkRpSubItmData).%New()
     ....s Item.WorkRpWardParref=RepWard
     ....s Item.SubItm=SubItm
     ....i $L(LoadItm(Ward,Itm,SubItm),".")>1 d
     .....s Item.SubItmNum=$fn(LoadItm(Ward,Itm,SubItm),"",2)
     ....e  d
     .....s Item.SubItmNum=LoadItm(Ward,Itm,SubItm)
     ....d Item.%Save()
     ...d RepWard.%Close()
     ..e  TROLLBACK
     .s PerId=""  f  s PerId=$O(NurWork(Ward,PerId)) q:PerId=""  d
     ..s WorkItm=""  f  s WorkItm=$O(NurWork(Ward,PerId,WorkItm)) q:WorkItm=""  d
     ...s RepSub=##class(DHCNMG.Work.MgNurWorkRpSub).%New()
     ...s RepSub.WorkRpParef=Rep
     ...s RepSub.WorkRpSubItmDR=##class(DHCNMG.DB.MgNurWorkLoadItm).%OpenId(WorkItm)
     ...i $L(NurWork(Ward,PerId,WorkItm),".")>1 d
     ....s RepSub.WorkRpSubNum=$fn(NurWork(Ward,PerId,WorkItm),"",2)
     ...e  d
     ....s RepSub.WorkRpSubNum=NurWork(Ward,PerId,WorkItm)
     ...s WorkPercent=RepSub.WorkRpSubItmDR.WorkPercent
     ...s RepSub.WorkRpSubCount=$fn(NurWork(Ward,PerId,WorkItm)*WorkPercent,"",2)
     ...s RepSub.WorkRpSubExNurDr=PerId
     ...if $$$ISOK(RepSub) d
     ....d RepSub.%Save()
     ....d RepSub.%Close() 
     ...e  TROLLBACK
     TCOMMIT
     q 0
}

/// creator: zhangjz
/// date:2018-08-22
/// description: 生成病房工作量日报数据任务  
/// table: DHCNMG.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).WardDayReport()
ClassMethod GetNurWorkByExecDate(Itm, StDate, EndDate, NurWork, WorkLoad, LoadItm, WkItm, SubItm)
{
    //只统计接收科室为工作量统计维护科室
    s WorkLoadLocStr=..GetWorkLoadLocs("W")
    q:WkItm="" ""
    s Obj=##class(DHCNMG.DB.MgNurWorkLoadItm).%OpenId(WkItm)
    q:Obj="" ""
    s RelTyp=Obj.WorkRelItm
    k ^TempHourWork
    f Date=StDate:1:EndDate
    {
        s Oew=""  f  s Oew=$O(^OEORDi(0,"Date",Oew)) q:Oew=""  d    //576
        .s ExstTime=""  f  s ExstTime=$O(^OEORDi(0,"Date",Oew,Date,ExstTime)) q:ExstTime=""  d
        ..s LinkFlag=0
        ..s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"Date",Oew,Date,ExstTime,OrdSub)) q:OrdSub=""  d
        ...s OeoreSub="" f  s OeoreSub=$O(^OEORDi(0,"Date",Oew,Date,ExstTime,OrdSub,OeoreSub)) q:OeoreSub=""  d
        ....s ExecStatusId=$p($g(^OEORD(Oew,"I",OrdSub,"X",OeoreSub)),"^",16) //执行状态
        ....;zw ExecStatusId   	//1:已执行;2:停止执行;3:撤销执行;4:接收;5:拒绝执行	SELECT * FROM OEC_Order_AdminStatus
        ....q:(ExecStatusId'=1) //只统计已执行
        ....;q:((ExecStatusId'=1)&&(ExecStatusId'="")) //只统计已执行和补录的未执行医嘱
        ....s ArcimId=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
        ....q:ArcimId=""
        ....q:(RelTyp'="I")&&(Itm'=ArcimId)
        ....s PhcinId=$p($g(^OEORD(Oew,"I",OrdSub,2)),"^",7) ;OEORI_Instr_DR 用药途径
        ....q:(RelTyp="I")&&(PhcinId="")
        ....;s PhcinId="^"_PhcinId_"^"
        ....q:(RelTyp="I")&&(Itm'=PhcinId)     
        ....s ARCIMRowid=$p(ArcimId,"||",1)
        ....s ARCIMSub=$p(ArcimId,"||",2)
        ....;s OerNum=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)	//医嘱执行数量
        ....;s:OerNum="" OerNum=0
        ....;s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)  //医嘱子类ID--ARc_Itemcat
        ....;q:ItemCatDR=""
        ....;s ItemCat=$P(^ARC("IC",ItemCatDR),"^",2)                    //子类描述
        ....;q:ItemCat["材料"
        ....s BillingUOMId=$P($G(^ARCIM(+ArcimId,+$p(ArcimId,"||",2),8)),"^",14)
        ....i BillingUOMId'="" s BillingUOMDesc=$P($G(^CT("UOM",BillingUOMId)),"^",2)
        ....e  s BillingUOMDesc=""
        ....//小时医嘱或按天统计同一医嘱项无论有几条执行记录都只算一次工作量，否则应维护类别为N
        ....q:((RelTyp="H")!(RelTyp="D"))&&($D(^TempHourWork(Oew,ArcimId)))
        ....i (RelTyp="H")&&('$D(^TempHourWork(Oew_"||"_OrdSub))) d
        .....s ^TempHourWork(Oew,ArcimId)=1
        ....i (RelTyp="D")&&('$D(^TempHourWork(Oew_"||"_OrdSub))) d
        .....s ^TempHourWork(Oew,ArcimId)=1
        ....s Dep=""
        ....s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",OeoreSub),"^",15)
        ....i CPTExDR'="" s CPTEx=$P(^CTPCP(CPTExDR,1),"^",2)
        ....q:CPTExDR=""
        ....//s Str=..GetNurWard1(CPTExDR,Date,Date)
        ....//取执行人在护管人员信息表rowid
        ....s PerId=..GetNurPeridByCTPCP(CPTExDR)   //护士档案表DHCNMG.HR.MgPersons未与SSuser关联ID，PerUserDR为空，测试取第一个ID
        ....q:PerId=""   //包钢医院注释掉 统计已执行和补录的未执行医嘱 未执行无执行人
        ....s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(PerId)
		....q:'$IsObject(perObj)
		....b ;110
		....s Dep=perObj.PerDepDR
        ....i PerId="" s PerId=0
        ....s DNum=1,Num=1
        ....;s:OerNum'=0 Num=+OerNum,DNum=+OerNum
        ....s HNum=1
        ....d CalNum2NurWork(DNum,HNum,Num,WkItm,PerId,Dep,SubItm)
    }
    q 0
CalNum2NurWork(DNum,HNum,Num,WItm,PerId,Dep,Itm)
    s WorkLoadObj=^DHCNMG.DB.MgNurWorkLoadItmD(WItm)
    s Styp=$List(WorkLoadObj,4)
    s RelTyp=$List(WorkLoadObj,5)
    s Percent=$ListGet(WorkLoadObj,6)
    s Flag=$List(WorkLoadObj,8)
    q:Flag="N"  //不可用
    q:Styp'="W"
    if RelTyp="D" d
    .s WorkLoad(Dep,WItm)=$G(WorkLoad(Dep,WItm))+DNum
    .i PerId'="" s NurWork(Dep,PerId,WItm)=$G(NurWork(Dep,PerId,WItm))+DNum
    .s LoadItm(Dep,WItm,Itm)=$G(LoadItm(Dep,WItm,Itm))+DNum
    if RelTyp="H" d
    .;小时医嘱统计方式修改
    .;s WorkLoad(Dep,WItm)=$G(WorkLoad(Dep,WItm))+HNum
    .;i PerId'="" s NurWork(Dep,PerId,WItm)=$G(NurWork(Dep,PerId,WItm))+HNum
    .;s LoadItm(Dep,WItm,Itm)=$G(LoadItm(Dep,WItm,Itm))+HNum
    .s stDate=$p(^OEORD(Oew,"I",OrdSub,"X",OeoreSub),"^",1)
    .s stTime=$p(^OEORD(Oew,"I",OrdSub,"X",OeoreSub),"^",2)
    .s endDate=$p(^OEORD(Oew,"I",OrdSub,"X",OeoreSub),"^",35)
    .s endTime=$p(^OEORD(Oew,"I",OrdSub,"X",OeoreSub),"^",36)
    .i (stDate="")||(stTime="")||(endDate="")||(endTime="") d
    ..s result=HNum
    .e  d
    ..s diff=$SYSTEM.SQL.DATEDIFF("s",stDate_","_stTime,endDate_","_endTime)
    ..s result=$fn(diff/3600,"",0)
    .s WorkLoad(Dep,WItm)=$G(WorkLoad(Dep,WItm))+result
    .i PerId'="" s NurWork(Dep,PerId,WItm)=$G(NurWork(Dep,PerId,WItm))+result
    .s LoadItm(Dep,WItm,Itm)=$G(LoadItm(Dep,WItm,Itm))+result
    if RelTyp="N" d
    .s WorkLoad(Dep,WItm)=$G(WorkLoad(Dep,WItm))+Num
    .i PerId'="" s NurWork(Dep,PerId,WItm)=$G(NurWork(Dep,PerId,WItm))+Num
    .s LoadItm(Dep,WItm,Itm)=$G(LoadItm(Dep,WItm,Itm))+Num
    if RelTyp="I" d
    .s WorkLoad(Dep,WItm)=$G(WorkLoad(Dep,WItm))+Num
    .i PerId'="" s NurWork(Dep,PerId,WItm)=$G(NurWork(Dep,PerId,WItm))+Num
    .s LoadItm(Dep,WItm,Itm)=$G(LoadItm(Dep,WItm,Itm))+Num
  q
}

/// creator: zhangjz
/// date:2018-08-22
/// description: 生成病房工作量日报数据任务  
/// table: DHCNMG.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).WardDayReport()
ClassMethod GetWorkLoadLocs(Types As %String) As %String
{
    i Types="" s Types="W"
    s Ret="^"
    s Len=$L(Types,"^")
    f i=1:1:Len
    {
        s Typ=$P(Types,"^",i)
        i Typ'=""
        {
            s Typ=$ZConvert(Typ,"U")
            s Sort="" f  s Sort=$O(^DHCNMG.DB.MgNurWorkLoadDepSetI("TypSort"," "_Typ,Sort)) q:Sort=""  d
            .s Id="" f  s Id=$O(^DHCNMG.DB.MgNurWorkLoadDepSetI("TypSort"," "_Typ,Sort,Id)) q:Id=""  d
            ..s Obj=##class(DHCNMG.DB.MgNurWorkLoadDepSet).%OpenId(Id)
            ..q:'$IsObject(Obj)
            ..s DepDR=Obj.DepDR
            ..s Obj=##class(DHCNMG.DB.MgWard).%OpenId(DepDR)
            ..q:'$IsObject(Obj)
            ..s CTLocDR=Obj.CTLocDR
            ..;s Des=$P($g(^CTLOC(Dep)),"^",2)
            ..;s Ret=Ret_Dep_"|"_Des_"^"
            ..q:CTLocDR=""
            ..s LocId=CTLocDR.%Id()
            ..q:LocId=""
            ..s Ret=Ret_LocId_"^"   
        }   
    }
    q Ret
}

/// creator: zhangjz
/// date:2018-08-22
/// description: 生成病房工作量日报数据任务  
/// table: DHCNMG.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).WardDayReport()
ClassMethod GetAbsTime(Dt As %String) As %String
{
 //将日期时间转换成秒
  //n (dt)
  s Dat=$P(Dt,",",1),Tim=$P(Dt,",",2)
  q ((Dat*86400)+Tim)
}

ClassMethod Getpatlocbydatetime(Adm, DateTime) As %String
{
    //w ##class(web.DHCMgNurOldWorkDayReport).getpatlocbydatetime("116142","5547259800")
    s Ret=""
    s ChildSub=0
    f  s ChildSub=$o(^PAADM(Adm,"TRANS",ChildSub)) q:(ChildSub="")!(Ret'="")  d
    .s WardDr=$p(^PAADM(Adm,"TRANS",ChildSub),"^",9)
    .q:WardDr=""
    .q:Ret'=""
    .s StartDate=$p(^PAADM(Adm,"TRANS",ChildSub),"^",1)
    .s StartTime=$p(^PAADM(Adm,"TRANS",ChildSub),"^",2)
    .s StDt=##class(web.NurMgStatComm).GetAbsTime(StartDate_","_StartTime) //开始时间
    .q:StDt>DateTime
    .s Ret=$p(^PAWARD(WardDr),"^",5)
    q Ret
}

/// creator: zhangjz
/// date:2018-08-22
/// description: 生成病房工作量日报数据任务  -取执行人在护管人员信息表rowid
/// table: DHCNMG.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).WardDayReport()
ClassMethod GetNurPeridByCTPCP(NurDr)
{
    q:NurDr="" ""
    s SSDr="" s SSDr=$O(^SSU("SSUSR",0,"CTPCP",NurDr,SSDr))
    q:SSDr="" ""
    s Obj=##class(User.SSUser).%OpenId(SSDr)
    s nurseid=Obj.SSUSRInitials
    s nurseid=$ZCvt(nurseid,"U")
    s PerId="" 
    ;s PerId=$O(^DHCNMG.HR.MgPersonsI("SSID"," "_SSDr,PerId))
    ;zw nurseid
    s PerId=$O(^DHCNMG.HR.MgPersonsI("PerID"," "_nurseid,PerId))
    q:PerId="" ""
    q PerId
}

/// creator: zhangjz
/// date:2018-09-01
/// description: 查询日报数据 
/// table: DHCNMG.Work.MgNurWorkReport
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgStatComm","SchWorkDayReport","2018-04-01^2018-04-30")
Query SchWorkDayReport(parr As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod SchWorkDayReportExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
    s ^TEMP("g0618001")=parr
    Set repid=$I(^CacheTemp)
    s ind=1
    s StDate=$P(parr,"^",1)
    s EndDate=$P(parr,"^",2)
    s StDate=$ZDH(StDate,3)
    s EndDate=$ZDH(EndDate,3)
    k DRP
    f Date=StDate:1:EndDate
    {
     s Rw=""  f  s Rw=$O(^DHCNMG.Work.MgNurWorkReportI("StDate",Date,Rw)) q:Rw=""  d
     .;q:$D(DRP(Date)) 
     .s Obj=##class(DHCNMG.Work.MgNurWorkReport).%OpenId(Rw)
     .s SDate=Obj.WorkStDate
     .s SDate=$ZD(SDate,3)
     .s EDate=Obj.WorkEndDate
     .s EDate=$ZD(EDate,3)
     .s CreatDate=Obj.WorkCreateDate
     .s CreatDate=$ZD(CreatDate,3)
     .s CreatTime=Obj.WorkCreatTime
     .s CreatTime=$ZT(CreatTime)
     .s WorkDepDr=Obj.WorkDepDr
     .s WorkDepDes=""
     .i WorkDepDr'="" s WorkDepDes=$P($g(^CTLOC(WorkDepDr)),"^",2)
     .s WardId=$O(^DHCNMG.DB.MgWardI("CTLoc",WorkDepDr,""))
     .s WardId=WorkDepDr
     .s WardDesc=""
     .i WardId'="" s WardDesc=$lg($g(^DHCNMG.DB.MgWardD(WardId)),4)
     .s RpSubId=$O(^DHCNMG.Work.MgNurWorkReportD(Rw,"ChildSub","")) 
     .q:RpSubId=""
     .s Id=Rw_"||"_RpSubId
     .s SubObj=##class(DHCNMG.Work.MgNurWorkRpSub).%OpenId(Id)
     .s WorkRpSubItmDR=SubObj.WorkRpSubItmDR
     .s WorkItmDesc=WorkRpSubItmDR.WorkItm
     .s WorkItmCode=WorkRpSubItmDR.WorkCode
     .s WorkRpSubNum=SubObj.WorkRpSubNum
     .s WorkRpSubCount=SubObj.WorkRpSubCount
     .s WorkRpSubExNurDr=SubObj.WorkRpSubExNurDr
     .s PerName=$lg($g(^DHCNMG.HR.MgPersonsD(WorkRpSubExNurDr)),2)
     .s DRP(Date,Rw)=CreatDate_"^"_CreatTime_"^"_WorkDepDr_"^"_WorkDepDes_"^"_WardId_"^"_WardDesc_"^"_WorkItmCode_"^"_WorkItmDesc_"^"_WorkRpSubNum_"^"_WorkRpSubCount_"^"_WorkRpSubExNurDr_"^"_PerName
    }
    s d="" f  s d=$O(DRP(d)) q:d=""  d
    .s Rw="" f  s Rw=$O(DRP(d,Rw)) q:Rw=""  d
    ..s Date=$ZD(d,3)
    ..s CreatDate=$P(DRP(d,Rw),"^",1)
    ..s CreatTime=$P(DRP(d,Rw),"^",2)
    ..s WorkDepDr=$P(DRP(d,Rw),"^",3)
    ..s WorkDepDes=$P(DRP(d,Rw),"^",4)
    ..s WardId=$P(DRP(d,Rw),"^",5)
    ..s WardDesc=$P(DRP(d,Rw),"^",6)
    ..s WorkItmCode=$P(DRP(d,Rw),"^",7)
    ..s WorkItmDesc=$P(DRP(d,Rw),"^",8)
    ..s WorkRpSubNum=$P(DRP(d,Rw),"^",9)
    ..s WorkRpSubCount=$P(DRP(d,Rw),"^",10)
    ..s WorkRpSubExNurDr=$P(DRP(d,Rw),"^",11)
    ..s PerName=$P(DRP(d,Rw),"^",12)
    ..d out2
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

  
out2
    s Ret="WorkStDate|"_Date_"^WorkCreateDate|"_CreatDate_"^WorkCreatTime|"_CreatTime_"^WorkDepDr|"_WorkDepDr_"^WorkDepDes|"_WorkDepDes_"^WardId|"_WardId_"^WardDesc|"_WardDesc_"^WorkItmCode|"_WorkItmCode_"^WorkItmDesc|"_WorkItmDesc_"^WorkRpSubNum|"_WorkRpSubNum_"^WorkRpSubCount|"_WorkRpSubCount_"^WorkRpSubExNurDr|"_WorkRpSubExNurDr_"^PerName|"_PerName
    set Data=$lb(Ret)
    ;set Data=$lb(Date,CreatDate,CreatTime)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SchWorkDayReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SchWorkDayReportExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod SchWorkDayReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SchWorkDayReportExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// creator: zhangjz
/// date:2018-08-03
/// description: 删除日报
/// table: DHCNMG.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).DeleteWorkDayReport("2018-04-12")
ClassMethod DeleteWorkDayReport(parr As %String) As %String
{
    q:parr="" ""
    s DelDate=$ZDH(parr,3)
    s Sc=0
    s Rw=""  f  s Rw=$O(^DHCNMG.Work.MgNurWorkReportI("StDate",DelDate,Rw)) q:Rw=""  d
    .s Obj=##class(DHCNMG.Work.MgNurWorkReport).%OpenId(Rw)
    .i '$IsObject(Obj) q
    .s Sc=Obj.%DeleteId(Rw)
    q $$$ISOK(Sc)
}

/// creator: zhangjz
/// date:2018-08-03
/// description: 自动生成月报
ClassMethod AutoGenerateMonthRp() As %String
{
    s date=+$H
    ;s date=$ZDH("2015-07-01",3)
    s tmpdate=$ZD(date,3)
    s year=$P(tmpdate,"-",1)
    s month=$P(tmpdate,"-",2)
    s day=$P(tmpdate,"-",3)
    i day="01" d
    .s excutedate=$ZD(date-1,3)
    .s excuteyear=$P(excutedate,"-",1)
    .s excutemonth=$P(excutedate,"-",2)
    .i excutemonth="01" s mon="Jan"
    .e  i excutemonth="02" s mon="Feb"
    .e  i excutemonth="03" s mon="Mar"
    .e  i excutemonth="04" s mon="Apr"
    .e  i excutemonth="05" s mon="May"
    .e  i excutemonth="06" s mon="Jun"
    .e  i excutemonth="07" s mon="Jul"
    .e  i excutemonth="08" s mon="Aug"
    .e  i excutemonth="09" s mon="Sep"
    .e  i excutemonth="10" s mon="Oct"
    .e  i excutemonth="11" s mon="Nov"
    .e  i excutemonth="12" s mon="Dec"
    .s excuteday=$P(excutedate,"-",3)
    .s stdate=excuteyear_"-"_excutemonth_"-"_"01"
    .s enddate=excutedate
    .d ##class(web.DHCMgWorkLoadSchComm).CreatRp(stdate,enddate,"",mon,"","")
}

/// creator: zhangjz
/// date:2018-08-22
/// description: 生成月报
/// table: DHCNMG.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).CreatRp("2018-04-01","2018-04-30",1,"2018-04","","WorkLoad")
ClassMethod CreatRp(StDate, EndDate, User, Mon, Mem = "", Typ) As %String
{
    s NurWork="", WorkLoad="", LoadItm=""
     s StDate=$ZDH(StDate,3)
     s EndDate=$ZDH(EndDate,3)
     f Date=StDate:1:EndDate
     {
         s Par=""  f  s Par=$O(^DHCNMG.Work.MgNurWorkReportI("StDate",Date,Par)) q:Par=""  d
         .s Loc=$list(^DHCNMG.Work.MgNurWorkReportD(Par),2)
         .s Rw=""  f  s Rw=$O(^DHCNMG.Work.MgNurWorkReportD(Par,"ChildWard",Rw)) q:Rw=""  d
         ..s Itm=$list(^DHCNMG.Work.MgNurWorkReportD(Par,"ChildWard",Rw),2)
         ..s Num=$list(^DHCNMG.Work.MgNurWorkReportD(Par,"ChildWard",Rw),3)
         ..s Count=$list(^DHCNMG.Work.MgNurWorkReportD(Par,"ChildWard",Rw),4)
         ..s WorkLoad(Loc,Itm)=$G(WorkLoad(Loc,Itm))+Num
         ..s Sub=""  f  s Sub=$O(^DHCNMG.Work.MgNurWorkReportD(Par,"ChildWard",Rw,"ChildItmData",Sub)) q:Sub=""  d
         ...s SubItm=$List(^DHCNMG.Work.MgNurWorkReportD(Par,"ChildWard",Rw,"ChildItmData",Sub),2)
         ...s SubNum=$List(^DHCNMG.Work.MgNurWorkReportD(Par,"ChildWard",Rw,"ChildItmData",Sub),3)
         ...s LoadItm(Loc,Itm,SubItm)=$G(LoadItm(Loc,Itm,SubItm))+SubNum
         .s Rw=""  f  s Rw=$O(^DHCNMG.Work.MgNurWorkReportD(Par,"ChildSub",Rw)) q:Rw=""  d
         ..s Itm=$list(^DHCNMG.Work.MgNurWorkReportD(Par,"ChildSub",Rw),2)
         ..s Nur=$list(^DHCNMG.Work.MgNurWorkReportD(Par,"ChildSub",Rw),5)
         ..s Num=$list(^DHCNMG.Work.MgNurWorkReportD(Par,"ChildSub",Rw),3)
         ..s Count=$list(^DHCNMG.Work.MgNurWorkReportD(Par,"ChildSub",Rw),4)
         ..s NurWork(Loc,Nur,Itm)=$G(NurWork(Loc,Nur,Itm))+Num
     }
     if $D(WorkLoad) d ..DeleteMonthReport($ZD(StDate,3))
     if $D(WorkLoad) d ..InsertMonWork(.NurWork,.WorkLoad,.LoadItm,StDate,EndDate,User,Mon,Mem,Typ)
    q 0
}

/// creator: zhangjz
/// date:2018-08-22
/// description: 生成月报
/// table: DHCNMG.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).CreatRp()
ClassMethod InsertMonWork(NurWork, WorkLoad, LoadItm, StDate, EndDate, User, Mon, Mem, Typ) As %String
{
    s WorkRpId=##class(web.NurMgStatComm).SaveMonWork(StDate,EndDate,Mon,Mem,Typ,User)
    q:WorkRpId="0" 0
    TSTART
    s Ward=""  f  s Ward=$O(WorkLoad(Ward)) q:Ward=""  d
    .s Rep=##class(DHCNMG.Work.MgNurWardMonRp).%New()
    .s Rep.WorkDepDr=Ward
    .s Rep.WorkStDate=StDate
    .s Rep.WorkEndDate=EndDate
    .s Rep.WorkCreateDate=+$H
    .s Rep.WorkCreatTime=$P($H,",",2)
    .s Rep.WorkRp=##class(DHCNMG.Work.MgNurWorkRp).%OpenId(WorkRpId)
    .if $$$ISOK(Rep) d
    ..d Rep.%Save()
    ..d Rep.%Close()
    .e  d
    ..TROLLBACK 
    .s Itm="" f  s Itm=$O(WorkLoad(Ward,Itm)) q:Itm=""  d
    ..s RepWard=##class(DHCNMG.Work.MgNurWardMonSub).%New()
    ..s RepWard.WardParref=Rep
    ..s RepWard.WardWorkItm=##class(DHCNMG.DB.MgNurWorkLoadItm).%OpenId(Itm)
    ..s RepWard.WardWorkNum=WorkLoad(Ward,Itm)
    ..s RepWard.WardWorkCount=WorkLoad(Ward,Itm)*RepWard.WardWorkItm.WorkPercent
    ..if $$$ISOK(RepWard) d
    ...d RepWard.%Save()
    ...s SubItm="" f  s SubItm=$O(LoadItm(Ward,Itm,SubItm)) q:SubItm=""  d
    ....s Item=##class(DHCNMG.Work.MgNurWardMonSubItm).%New()
    ....s Item.WorkRpWardParref=RepWard
    ....s Item.SubItm=SubItm
    ....s Item.SubItmNum=LoadItm(Ward,Itm,SubItm)
    ....d Item.%Save()
    ...d RepWard.%Close()
    ..e  TROLLBACK
    .s PerId=""  f  s PerId=$O(NurWork(Ward,PerId)) q:PerId=""  d
    ..s WorkItm=""  f  s WorkItm=$O(NurWork(Ward,PerId,WorkItm)) q:WorkItm=""  d
    ...s RepSub=##class(DHCNMG.Work.MgNurWardMonSubPer).%New()
    ...s RepSub.WorkRpParef=Rep
    ...s RepSub.WorkRpSubItmDR=##class(DHCNMG.DB.MgNurWorkLoadItm).%OpenId(WorkItm)
    ...s RepSub.WorkRpSubNum=NurWork(Ward,PerId,WorkItm)
    ...s RepSub.WorkRpSubCount=NurWork(Ward,PerId,WorkItm)*RepSub.WorkRpSubItmDR.WorkPercent
    ...s RepSub.WorkRpSubExNurDr=PerId
    ...if $$$ISOK(RepSub) d
    ....d RepSub.%Save()
    ....d RepSub.%Close()
    ...e  TROLLBACK
    TCOMMIT
    q 0
}

/// creator:zhangjz
/// date:2018-08-24
/// desc:保存月报表
/// table:DHCNMG.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).SaveMonWork("itmId|6^workRelInstruct|^workRelArcim|9962")
ClassMethod SaveMonWork(StDate, EndDate, Mon, Mem, worktyp, User) As %String
{
    s a=##class(DHCNMG.Work.MgNurWorkRp).%New()
    s a.WorkTitle=worktyp
    s a.WorkStDate=StDate
    s a.WorkEndDate=EndDate
    if User'="" s a.WorkCreateUser=User
    s a.WorkCreateDate=+$H
    s a.WorkCreatTime=$P($H,",",2)
    s a.WorkRpMon=Mon
    s a.WorkMem=Mem
    s Sc=a.%Save()
    s Res=""
    i $$$ISOK(Sc)="1" s Res=a.%Id()
    e  s Res=$$$ISOK(Sc)
    q Res
}

/// creator:zhangjz
/// date:2018-08-24
/// desc:查询月报数据
/// table:DHCNMG.Work.MgNurWorkReport
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgStatComm","GetWorkMonRp","2018-04-01^2018-04-30")
Query GetWorkMonRp(parr As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod GetWorkMonRpExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s StDate=$P(parr,"^",1)
    s EndDate=$P(parr,"^",2)
    s StDate=$ZDH(StDate,3)
    s EndDate=$ZDH(EndDate,3)
    s Ret=""
    f Date=StDate:1:EndDate
    { 
     s Rw=""  f  s Rw=$O(^DHCNMG.Work.MgNurWorkRpI("StDate",Date,Rw)) q:Rw=""  d
     .s SDate=$list(^DHCNMG.Work.MgNurWorkRpD(Rw),3)
     .s SDate=$ZD(SDate,3)
     .s EDate=$list(^DHCNMG.Work.MgNurWorkRpD(Rw),4)
     .s EDate=$ZD(EDate,3)
     .s CreatDate=$list(^DHCNMG.Work.MgNurWorkRpD(Rw),6)
     .s CreatDate=$ZD(CreatDate,3)
     .s CreatTime=$list(^DHCNMG.Work.MgNurWorkRpD(Rw),7)
     .;s CreatTime=""
     .s CreatTime=$ZT(CreatTime)
     .s User=""
     .;s Mem=$list(^DHCNMG.Work.MgNurWorkRpD(Rw),8)
     .s Mem=""
     .s Title=$list(^DHCNMG.Work.MgNurWorkRpD(Rw),2)
     .;s Title=""
     .s Mon=$list(^DHCNMG.Work.MgNurWorkRpD(Rw),9)
     .i Mon="Jan" s Mon="一月"
     .i Mon="Feb" s Mon="二月"
     .i Mon="Mar" s Mon="三月"
     .i Mon="Apr" s Mon="四月"
     .i Mon="May" s Mon="五月"
     .i Mon="Jun" s Mon="六月"
     .i Mon="Jul" s Mon="七月"
     .i Mon="Aug" s Mon="八月"
     .i Mon="Sep" s Mon="九月"
     .i Mon="Oct" s Mon="十月"
     .i Mon="Nov" s Mon="十一月"
     .i Mon="Dec" s Mon="十二月"
     .i Mon="" s Mon=""
     .d out
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
out
    s Ret="StDate|"_SDate_"^EndDate|"_EDate_"^CreatDate|"_CreatDate_"^CreatTime|"_CreatTime_"^Mem|"_Mem_"^Title|"_Title_"^RowId|"_Rw_"^Mon|"_Mon
    ;set Data=$lb(SDate,EDate,CreatDate,CreatTime,Mem,Title,Rw,Mon)
    set Data=$lb(Ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetWorkMonRpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWorkMonRpExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetWorkMonRpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWorkMonRpExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// creator: zhangjz
/// date:2018-09-03
/// description: 删除月报
/// table: DHCNMG.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).DeleteMonthReport("2018-04-01")
ClassMethod DeleteMonthReport(parr As %String) As %String
{
    q:parr="" ""
    s DelDate=$ZDH(parr,3)
    s Sc=0
    s Rw=""  f  s Rw=$O(^DHCNMG.Work.MgNurWorkRpI("StDate",DelDate,Rw)) q:Rw=""  d
    .s Obj=##class(DHCNMG.Work.MgNurWorkRp).%OpenId(Rw)
    .i '$IsObject(Obj) q
    .s Sc=Obj.%DeleteId(Rw)
    .s SubRw=""  f  s SubRw=$O(^DHCNMG.Work.MgNurWardMonRpI("WorkRp",Rw,SubRw)) q:SubRw=""  d
    ..s SubObj=##class(DHCNMG.Work.MgNurWardMonRp).%OpenId(SubRw)
    ..i '$IsObject(SubObj) q
    ..s Sc=SubObj.%DeleteId(SubRw)
    q $$$ISOK(Sc)
}

/// creator: zhangjz
/// date:2018-09-01
/// description: 查询工作量，按项目，按人   
/// table: DHCNMG.Work.MgNurWorkReport
/// input:
/// output:66，2，43，35
/// other: d ##class(%ResultSet).RunQuery("web.NurMgStatComm","GetWorkRpByDep","2018-04-01^2018-04-30^^Nurse")
Query GetWorkRpByDep(parr As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod GetWorkRpByDepExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
    s ^TEMP("g0618001")=parr
    Set repid=$I(^CacheTemp)
    s ind=1
    s StDate=$P(parr,"^",1)
    s EndDate=$P(parr,"^",2)
    s ParWardId=$P(parr,"^",3)
    s Param=$P(parr,"^",4)
    s StDate=$ZDH(StDate,3)
    s EndDate=$ZDH(EndDate,3)
    s WorkItm=""

    i Param="Itm" 
    {
        ;s ItmRw=""  f  s ItmRw=$O(^DHCNMG.DB.MgNurWorkLoadItmI("TYP"," W",ItmRw)) q:ItmRw=""  d
        f Date=StDate:1:EndDate d
        .s Rw=""  f  s Rw=$O(^DHCNMG.Work.MgNurWorkReportI("StDate",Date,Rw)) q:Rw=""  d
        ..s Obj=##class(DHCNMG.Work.MgNurWorkReport).%OpenId(Rw)
        ..s WorkDepDr=Obj.WorkDepDr
        ..s WorkDepDes=""
        ..;i WorkDepDr'="" s WorkDepDes=$P($g(^CTLOC(WorkDepDr)),"^",2)
        ..;s WardId=$O(^DHCNMG.DB.MgWardI("CTLoc",WorkDepDr,""))
        ..s WardId=WorkDepDr
        ..i ((WardId'=ParWardId)&&(ParWardId'="")) q
        ..s WardDesc=""
        ..i WardId'="" s WardDesc=$lg($g(^DHCNMG.DB.MgWardD(WardId)),4)
        ..s RpSubId=""  f  s RpSubId=$O(^DHCNMG.Work.MgNurWorkReportD(Rw,"ChildSub",RpSubId)) q:RpSubId=""  d
        ...s Id=Rw_"||"_RpSubId
        ...s SubObj=##class(DHCNMG.Work.MgNurWorkRpSub).%OpenId(Id)
        ...s WorkRpSubItmDR=SubObj.WorkRpSubItmDR
        ...s WorkRpSubItmId=WorkRpSubItmDR.%Id()
        ...s WorkRpSubNum=SubObj.WorkRpSubNum
        ...s WorkRpSubCount=SubObj.WorkRpSubCount
        ...s WorkRpSubExNurDr=SubObj.WorkRpSubExNurDr
        ...i WorkRpSubExNurDr="" q
        ...s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(WorkRpSubExNurDr)
		...q:'$IsObject(perObj)
		...q:((perObj.PerDepDR'=ParWardId)&&(ParWardId'=""))
        ...s WorkItm(WorkRpSubItmId,"Num")=$G(WorkItm(WorkRpSubItmId,"Num"))+WorkRpSubNum
        ...s WorkItm(WorkRpSubItmId,"Score")=$G(WorkItm(WorkRpSubItmId,"Score"))+WorkRpSubCount
   
        s ItmId="" f  s ItmId=$O(WorkItm(ItmId)) q:ItmId=""  d
        .s WorkItmDesc=$lg($g(^DHCNMG.DB.MgNurWorkLoadItmD(ItmId)),2)
        .s WorkRpNum=WorkItm(ItmId,"Num")
        .s WorkRpCount=WorkItm(ItmId,"Score")
        .d out1
    }
    elseif Param="Nurse" 
    {
        ;s ItmRw=""  f  s ItmRw=$O(^DHCNMG.DB.MgNurWorkLoadItmI("TYP"," W",ItmRw)) q:ItmRw=""  d
        f Date=StDate:1:EndDate d
        .s Rw=""  f  s Rw=$O(^DHCNMG.Work.MgNurWorkReportI("StDate",Date,Rw)) q:Rw=""  d
        ..s Obj=##class(DHCNMG.Work.MgNurWorkReport).%OpenId(Rw)
        ..s WorkDepDr=Obj.WorkDepDr
        ..s WorkDepDes=""
        ..;i WorkDepDr'="" s WorkDepDes=$P($g(^CTLOC(WorkDepDr)),"^",2)
        ..;s WardId=$O(^DHCNMG.DB.MgWardI("CTLoc",WorkDepDr,""))
        ..s WardId=WorkDepDr
        ..i ((WardId'=ParWardId)&&(ParWardId'="")) q
        ..s WardDesc=""
        ..i WardId'="" s WardDesc=$lg($g(^DHCNMG.DB.MgWardD(WardId)),4)
        ..s RpSubId=""  f  s RpSubId=$O(^DHCNMG.Work.MgNurWorkReportD(Rw,"ChildSub",RpSubId)) q:RpSubId=""  d
        ...s Id=Rw_"||"_RpSubId
        ...s SubObj=##class(DHCNMG.Work.MgNurWorkRpSub).%OpenId(Id)
        ...s WorkRpSubItmDR=SubObj.WorkRpSubItmDR
        ...s WorkRpSubItmId=WorkRpSubItmDR.%Id()
        ...s WorkRpSubNum=SubObj.WorkRpSubNum
        ...s WorkRpSubCount=SubObj.WorkRpSubCount
        ...s WorkRpSubExNurDr=SubObj.WorkRpSubExNurDr
        ...i WorkRpSubExNurDr="" q
        ...s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(WorkRpSubExNurDr)
		...q:'$IsObject(perObj)
		...q:((perObj.PerDepDR'=ParWardId)&&(ParWardId'=""))
        ...s WorkItm(WorkRpSubExNurDr,"Num")=$G(WorkItm(WorkRpSubExNurDr,"Num"))+WorkRpSubNum
        ...s WorkItm(WorkRpSubExNurDr,"Score")=$G(WorkItm(WorkRpSubExNurDr,"Score"))+WorkRpSubCount
   
        s PersonsId="" f  s PersonsId=$O(WorkItm(PersonsId)) q:PersonsId=""  d
        .s PerName=$lg($g(^DHCNMG.HR.MgPersonsD(PersonsId)),2)
        .s WorkRpNum=WorkItm(PersonsId,"Num")
        .s WorkRpCount=WorkItm(PersonsId,"Score")
        .d out2
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

out1
    s Ret="WorkItmDesc|"_WorkItmDesc_"^WorkRpNum|"_WorkRpNum_"^WorkRpCount|"_WorkRpCount
    set Data=$lb(Ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
  
out2
    s Ret="PerName|"_PerName_"^WorkRpNum|"_WorkRpNum_"^WorkRpCount|"_WorkRpCount
    set Data=$lb(Ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetWorkRpByDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWorkRpByDepExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetWorkRpByDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWorkRpByDepExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// creator: zhangjz
/// date:2018-09-01
/// description: 工作量月报查询   
/// table: DHCNMG.Work.MgNurWardMonRp
/// input:
/// output:66，2，43，35
/// other: d ##class(%ResultSet).RunQuery("web.NurMgStatComm","GetWardMonRp","66^Count^1^3,6,9")
Query GetWardMonRp(parr As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod GetWardMonRpExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s ParWardId=$P(parr,"^",1)
    s Param=$P(parr,"^",2)
    s WorkRpId=$P(parr,"^",3)
    s ItmId=$P(parr,"^",4)
    s l=$L(ItmId,",")
    s WorkItmCount="",WorkItmNum=""
    i Param="Count" 
    {
	    for i=1:1:l d
	    .s WorkItm=$P(ItmId,",",i)
	    .s WardMonRpId=""  f  s WardMonRpId=$O(^DHCNMG.Work.MgNurWardMonRpI("WorkRp",WorkRpId,WardMonRpId)) q:WardMonRpId=""  d
	    ..s WorkDepDr=$list(^DHCNMG.Work.MgNurWardMonRpD(WardMonRpId),2)
	    ..i ((WorkDepDr'=ParWardId)&&(WorkDepDr'="")) q
	    ..s SubPerId=""  f  s SubPerId=$O(^DHCNMG.Work.MgNurWardMonRpD(WardMonRpId,"ChildRpSub",SubPerId)) q:SubPerId=""  d
	    ...s Id=WardMonRpId_"||"_SubPerId
	    ...s SubPerObj=##class(DHCNMG.Work.MgNurWardMonSubPer).%OpenId(Id)
	    ...s WorkRpSubItmDR=SubPerObj.WorkRpSubItmDR
        ...s WorkItmId=WorkRpSubItmDR.%Id()
        ...i WorkItm'=WorkItmId q
        ...s WorkRpSubCount=SubPerObj.WorkRpSubCount
	    ...s WorkRpSubExNurDr=SubPerObj.WorkRpSubExNurDr
	    ...s WorkItmCount(WorkRpSubExNurDr,WorkItm)=$G(WorkItmCount(WorkRpSubExNurDr,WorkItm))+WorkRpSubCount
	    
	    
	    s PerId="" f  s PerId=$O(WorkItmCount(PerId)) q:PerId=""  d
	    .s PerName=$lg($g(^DHCNMG.HR.MgPersonsD(PerId)),2)
	    .s Ret="PerName|"_PerName
	    .s AllCount=0
	    .s WorkItmId="" f  s WorkItmId=$O(WorkItmCount(PerId,WorkItmId)) q:WorkItmId=""  d
        ..s WorkItmDesc=$lg($g(^DHCNMG.DB.MgNurWorkLoadItmD(WorkItmId)),2)
        ..s WorkRpCount=WorkItmCount(PerId,WorkItmId)
        ..s AllCount=AllCount+WorkRpCount
        ..s Ret=Ret_"^"_WorkItmDesc_"|"_WorkRpCount
        .s Ret=Ret_"^AllCount|"_AllCount
        .d out
    }
    elseif Param="Num" 
    {
        for i=1:1:l d
	    .s WorkItm=$P(ItmId,",",i)
	    .s WardMonRpId=""  f  s WardMonRpId=$O(^DHCNMG.Work.MgNurWardMonRpI("WorkRp",WorkRpId,WardMonRpId)) q:WardMonRpId=""  d
	    ..s WorkDepDr=$list(^DHCNMG.Work.MgNurWardMonRpD(WardMonRpId),2)
	    ..i ((WorkDepDr'=ParWardId)&&(WorkDepDr'="")) q
	    ..s SubPerId=""  f  s SubPerId=$O(^DHCNMG.Work.MgNurWardMonRpD(WardMonRpId,"ChildRpSub",SubPerId)) q:SubPerId=""  d
	    ...s Id=WardMonRpId_"||"_SubPerId
	    ...s SubPerObj=##class(DHCNMG.Work.MgNurWardMonSubPer).%OpenId(Id)
	    ...s WorkRpSubItmDR=SubPerObj.WorkRpSubItmDR
        ...s WorkItmId=WorkRpSubItmDR.%Id()
        ...i WorkItm'=WorkItmId q
        ...s WorkRpSubNum=SubPerObj.WorkRpSubNum
	    ...s WorkRpSubExNurDr=SubPerObj.WorkRpSubExNurDr
	    ...s WorkItmNum(WorkRpSubExNurDr,WorkItm)=$G(WorkItmNum(WorkRpSubExNurDr,WorkItm))+WorkRpSubNum
	    
	    s PerId="" f  s PerId=$O(WorkItmNum(PerId)) q:PerId=""  d
	    .s PerName=$lg($g(^DHCNMG.HR.MgPersonsD(PerId)),2)
	    .s Ret="PerName|"_PerName
	    .s AllNum=0
	    .s WorkItmId="" f  s WorkItmId=$O(WorkItmNum(PerId,WorkItmId)) q:WorkItmId=""  d
        ..s WorkItmDesc=$lg($g(^DHCNMG.DB.MgNurWorkLoadItmD(WorkItmId)),2)
        ..s WorkRpNum=WorkItmNum(PerId,WorkItmId)
        ..s AllNum=AllNum+WorkRpNum
        ..s Ret=Ret_"^"_WorkItmDesc_"|"_WorkRpNum
        .s Ret=Ret_"^AllNum|"_AllNum
        .d out
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
out
    set Data=$lb(Ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetWardMonRpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardMonRpExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetWardMonRpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardMonRpExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// creator: zhangjz
/// date:2018-09-01
/// description: 工作量月报分析  
/// table: DHCNMG.Work.MgNurWardMonRp
/// input:
/// output:66，2，43，35
/// other: d ##class(%ResultSet).RunQuery("web.NurMgStatComm","AnalyseWardMonRp","Count^1^3,6,9")
Query AnalyseWardMonRp(parr As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod AnalyseWardMonRpExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    ;s ParWardId=$P(parr,"^",1)
    s Param=$P(parr,"^",1)
    s WorkRpId=$P(parr,"^",2)
    s ItmId=$P(parr,"^",3)
    s l=$L(ItmId,",")
    s WorkItmCount="",WorkItmNum=""
    i Param="Count" 
    {
	    for i=1:1:l d
	    .s WorkItm=$P(ItmId,",",i)
	    .s WardMonRpId=""  f  s WardMonRpId=$O(^DHCNMG.Work.MgNurWardMonRpI("WorkRp",WorkRpId,WardMonRpId)) q:WardMonRpId=""  d
	    ..s WorkDepDr=$list(^DHCNMG.Work.MgNurWardMonRpD(WardMonRpId),2)
	    ..s SubPerId=""  f  s SubPerId=$O(^DHCNMG.Work.MgNurWardMonRpD(WardMonRpId,"ChildRpSub",SubPerId)) q:SubPerId=""  d
	    ...s Id=WardMonRpId_"||"_SubPerId
	    ...s SubPerObj=##class(DHCNMG.Work.MgNurWardMonSubPer).%OpenId(Id)
	    ...s WorkRpSubItmDR=SubPerObj.WorkRpSubItmDR
        ...s WorkItmId=WorkRpSubItmDR.%Id()
        ...i WorkItm'=WorkItmId q
        ...s WorkRpSubCount=SubPerObj.WorkRpSubCount
	    ...s WorkItmCount(WorkDepDr,WorkItm)=$G(WorkItmCount(WorkDepDr,WorkItm))+WorkRpSubCount
	    
	    s DepId="" f  s DepId=$O(WorkItmCount(DepId)) q:DepId=""  d
	    .s WardDesc=$lg($g(^DHCNMG.DB.MgWardD(DepId)),4)
	    .s Ret="WardDesc|"_WardDesc
	    .s AllCount=0
	    .s WorkItmId="" f  s WorkItmId=$O(WorkItmCount(DepId,WorkItmId)) q:WorkItmId=""  d
        ..s WorkItmDesc=$lg($g(^DHCNMG.DB.MgNurWorkLoadItmD(WorkItmId)),2)
        ..s WorkRpCount=WorkItmCount(DepId,WorkItmId)
        ..s AllCount=AllCount+WorkRpCount
        ..s Ret=Ret_"^"_WorkItmDesc_"|"_WorkRpCount
        .s Ret=Ret_"^AllCount|"_AllCount
        .d out
    }
    elseif Param="Num" 
    {
        for i=1:1:l d
	    .s WorkItm=$P(ItmId,",",i)
	    .s WardMonRpId=""  f  s WardMonRpId=$O(^DHCNMG.Work.MgNurWardMonRpI("WorkRp",WorkRpId,WardMonRpId)) q:WardMonRpId=""  d
	    ..s WorkDepDr=$list(^DHCNMG.Work.MgNurWardMonRpD(WardMonRpId),2)
	    ..s SubPerId=""  f  s SubPerId=$O(^DHCNMG.Work.MgNurWardMonRpD(WardMonRpId,"ChildRpSub",SubPerId)) q:SubPerId=""  d
	    ...s Id=WardMonRpId_"||"_SubPerId
	    ...s SubPerObj=##class(DHCNMG.Work.MgNurWardMonSubPer).%OpenId(Id)
	    ...s WorkRpSubItmDR=SubPerObj.WorkRpSubItmDR
        ...s WorkItmId=WorkRpSubItmDR.%Id()
        ...i WorkItm'=WorkItmId q
        ...s WorkRpSubNum=SubPerObj.WorkRpSubNum
	    ...s WorkItmNum(WorkDepDr,WorkItm)=$G(WorkItmNum(WorkDepDr,WorkItm))+WorkRpSubNum
	    
	    s DepId="" f  s DepId=$O(WorkItmNum(DepId)) q:DepId=""  d
	    .s WardDesc=$lg($g(^DHCNMG.DB.MgWardD(DepId)),4)
	    .s Ret="WardDesc|"_WardDesc
	    .s AllNum=0
	    .s WorkItmId="" f  s WorkItmId=$O(WorkItmNum(DepId,WorkItmId)) q:WorkItmId=""  d
        ..s WorkItmDesc=$lg($g(^DHCNMG.DB.MgNurWorkLoadItmD(WorkItmId)),2)
        ..s WorkRpNum=WorkItmNum(DepId,WorkItmId)
        ..s AllNum=AllNum+WorkRpNum
        ..s Ret=Ret_"^"_WorkItmDesc_"|"_WorkRpNum
        .s Ret=Ret_"^AllNum|"_AllNum
        .d out
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

out
    set Data=$lb(Ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod AnalyseWardMonRpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AnalyseWardMonRpExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod AnalyseWardMonRpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AnalyseWardMonRpExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// creator:zhangjz
/// date:2018-08-24
/// desc:统计明细
/// table:DHCNMG.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.NurMgStatComm).GetWorkRp("itmId|6^workRelInstruct|^workRelArcim|9962")
Query GetWorkRp(par As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod GetWorkRpExecute(ByRef qHandle As %Binary, par As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    ;s ^TEMP("g2015000003")=par
    s WItm=$P(par,"@",2)
    s RpIdSr=$P(par,"@",1)
    s DepCheck=$P(par,"@",3)
    s CountFlag=$P(par,"@",4)
    k WorkItm
    s l=$L(WItm,"|")
    s Ret=""
    ;s Ret="序号|40|SeqNo|^科  室|200|Dep|^分数|100|DepWorkCount|^"
    i CountFlag="Y" d
    .;s Ret="序号|40|SeqNo|^科  室|200|Dep|^分数|100|DepWorkCount|^"
    e  d
    .;s Ret="序号|40|SeqNo|^科  室|200|Dep|^数量|100|DepWorkCount|^"
    for i=1:1:l
    {
       s ItmId=$P(WItm,"|",i)
       if ItmId="" continue
       s Obj=##class(DHCNMG.DB.MgNurWorkLoadItm).%OpenId(ItmId)
       s ItmName=Obj.WorkItm
       s ItmCode=Obj.WorkCode
       s WorkItm(ItmId)=ItmCode
       ;s Ret=Ret_ItmName_"|100|itm"_i_"|System.Double^"
       s Ret=Ret_ItmCode_"^"
       ;s Ret=Ret_"itm"_ItmId_"^"
    }
    s SchItm=Ret
    s SumWardWorkCount=""
    k Work,SumWork,WardWorkCount
    s l=$L(RpIdSr,"|")
    for i=1:1:l
    {
       s RpId=$P(RpIdSr,"|",i)  ///添加汇总
       if RpId="" continue
       s pa=""  f  s pa=$O(^DHCNMG.Work.MgNurWardMonRpI("WorkRp",RpId,pa)) q:pa=""  d
       .s loc=$list(^DHCNMG.Work.MgNurWardMonRpD(pa),2)
       .s Ret=""
       .s rw=""  f  s rw=$O(^DHCNMG.Work.MgNurWardMonRpD(pa,"ChildRpWard",rw)) q:rw=""  d
       ..s itm=$list(^DHCNMG.Work.MgNurWardMonRpD(pa,"ChildRpWard",rw),2)
       ..q:(WItm'="")&('$D(WorkItm(itm)))
       ..i CountFlag="Y" d
       ...s count=$list(^DHCNMG.Work.MgNurWardMonRpD(pa,"ChildRpWard",rw),4)
       ..e  d
       ...s count=$list(^DHCNMG.Work.MgNurWardMonRpD(pa,"ChildRpWard",rw),3)
       ..s WardWorkCount(loc)=$G(WardWorkCount(loc))+count
       ..s SumWardWorkCount=$G(SumWardWorkCount)+count
       ..s Work(loc,itm)=$G(Work(loc,itm))+count
       ..s SumWork(itm)=$G(SumWork(itm))+count
       .s Ret=""
    }
    s loc=""  f  s loc=$O(Work(loc)) q:loc=""  d
    .s Ret=""
    .s tt="" f  s tt=$O(WorkItm(tt)) q:tt=""  d
    ..if $D(Work(loc,tt)) s Ret=Ret_WorkItm(tt)_"|"_Work(loc,tt)_"^"
    ..;if $D(Work(loc,tt)) s Ret=Ret_"itm"_tt_"|"_Work(loc,tt)_"^"
    ..e  s Ret=Ret_WorkItm(tt)_"|"_"^"
    .s WardWork(loc)=Ret
    s sumret=""
    s tt="" f  s tt=$O(WorkItm(tt)) q:tt=""  d
    .if $D(SumWork(tt)) s sumret=sumret_SumWork(tt)_"^"
    .e  s sumret=sumret_"^"
    //s depitm=##class(web.DHCMGPERSON).GetSortDep("D") //按开单科室显示NUR//20120914 暂时注释掉
    ;s depitm=##class(web.DHCMGPERSON).GetSortDep("N") //按开单科室显示NUR
    s depitm=##class(web.NurMgStatComm).GetSortDep("W")
    s l=$L(depitm,"^")
    s workstr=SchItm
    ;d out3
    ///按科室选项暂不用DepCheck="Y" 
    if (DepCheck="Y1")
    {
        k DepWorkCount,DepWork,DepartmentWork
        s loc=""  f  s loc=$O(WardWorkCount(loc)) q:loc=""  d
        .s loctyp=$P($G(^CTLOC(loc)),"^",13)
        .q:loctyp'="W"
        .s linkSub=0 f  s linkSub=$o(^CTLOC(loc,"LINK",linkSub)) q:linkSub=""  d
        ..s linkDep=$G(^CTLOC(loc,"LINK",linkSub))
        ..s DepWorkCount(linkDep)=$G(DepWorkCount(linkDep))+$G(WardWorkCount(loc))
        ..s item="" f  s item=$O(Work(loc,item)) q:item=""  d
        ...s DepWork(linkDep,item)=$G(DepWork(linkDep,item))+$G(Work(loc,item))
        s dep=""  f  s dep=$O(DepWork(dep)) q:dep=""  d
        .s Ret=""
        .s tt="" f  s tt=$O(WorkItm(tt)) q:tt=""  d
        ..if $D(DepWork(dep,tt)) s Ret=Ret_DepWork(dep,tt)_"^"
        ..e  s Ret=Ret_"^"
        .s DepartmentWork(dep)=Ret
        s ii=0
        s loc=""  f  s loc=$O(DepWorkCount(loc)) q:loc=""  d
        .s locDesc=$P(^CTLOC(loc),"^",2)
        .i $L(locDesc,"-")>1 s locDesc=$P(locDesc,"-",2)
        .s locDesc=locDesc_"["_loc_"]"    //20121126
        .s ii=ii+1
        .;s workstr="sort|"_ii_"^locdesc|"_locDesc_"^score|"_DepWorkCount(loc)_"^WardWork|"_DepartmentWork(loc)
        .s workstr="locdesc|"_locDesc_"^score|"_DepWorkCount(loc)_"^WardWork|"_DepartmentWork(loc)
        .d out3
    }
    else {
        s ii=0
        for i=1:1:l
        {
            s aa=$P(depitm,"^",i)
            if aa="" continue
            s dep=$P(aa,"|"),depdes=$P(aa,"|",2)
            i $L(depdes,"-")>1 s depdes=$P(depdes,"-",2)
            if '$D(WardWork(dep)) continue
            s depdes=depdes_"["_dep_"]"
            s ii=ii+1
            ;s workstr="sort|"_ii_"^locdesc|"_depdes_"^score|"_WardWorkCount(dep)_"^WardWork|"_WardWork(dep)
            i CountFlag="Y" s workstr="locdesc|"_depdes_"^score|"_WardWorkCount(dep)_"^"_WardWork(dep)
            e  i CountFlag="N" s workstr="locdesc|"_depdes_"^num|"_WardWorkCount(dep)_"^"_WardWork(dep)
            d out3
        }   
    }
     //s workstr=" ^汇总^"_SumWardWorkCount_"^"_sumret
     //d out3
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
  
out3
    set Data=$lb(workstr)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetWorkRpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWorkRpExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetWorkRpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWorkRpExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
