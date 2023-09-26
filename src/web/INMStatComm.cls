/// Creator：
/// Description：Vue版护理管理统计公共类 
/// Date：
Class web.INMStatComm Extends %RegisteredObject
{

/// Creator:gzj
/// Description:查询技术能手、服务之星数据统计
/// Date:2017-08-31
/// Table: DHCINM.HR.MgTechService
/// Input:parr:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMStatComm","FindElecteStat","","S",0,0)
Query FindElecteStat(parr As %String = "", type As %String, role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindElecteStatExecute(ByRef qHandle As %Binary, parr As %String = "", type As %String, role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s ^TMP("parrstat")=parr_"&"_type
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
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s date="" f  s date=$O(^DHCINM.HR.MgTechServiceI("dep"," "_type,date)) q:date=""  d
	.s nur="" f  s nur=$O(^DHCINM.HR.MgTechServiceI("dep"," "_type,date,nur)) q:nur=""  d
	..s dep="" f  s dep=$O(^DHCINM.HR.MgTechServiceI("dep"," "_type,date,nur,dep)) q:dep=""  d
	...s rowid="" f  s rowid=$O(^DHCINM.HR.MgTechServiceI("dep"," "_type,date,nur,dep,rowid)) q:rowid=""  d
	....s obj=##class(DHCINM.HR.MgTechService).%OpenId(rowid)
	....q:(isAll=0)&&((obj.ElecteWard="")||('$d(tmpWard(obj.ElecteWard))))
	....q:obj.ElecteStatus'="Y"
	....q:((stdate'="")&&(obj.ElecteDate<stdate))
	....q:((enddate'="")&&(obj.ElecteDate>enddate))
	....q:((nurward'="")&&(obj.ElecteWard'=nurward))
	....s nurse=obj.ElecteNurse
	....s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(nurse)
	....q:'$IsObject(perObj)
	....s nurseName=perObj.PerName
	....s nurseId=perObj.PerID
	....s shortName=##class(web.INMVueComm).ToChineseSpell(nurseName)
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
	s wardstr=##class(web.INMDBComm).GetWard(id)
	s ret=$p($p(wardstr,"^",3),"|",2)
	q ret
}

ClassMethod GetNurseVal(id As %String) As %String
{
	s ret=""
	s obj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
	q:'$IsObject(obj)
	s ret=obj.PerName_"^"_obj.PerID
	q ret
}

/// creator: zhangjz
/// createdate: 2018-08-01
/// description: 工作量病区维护-病区查询
/// table: CF.DHCINM.DB.WorkLoadDepSet
/// input:
/// output:
/// return:
/// other: d ##class(%ResultSet).RunQuery("web.INMStatComm","getWorkLoadDepSet","")
Query getWorkLoadDepSet(input As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod getWorkLoadDepSetExecute(ByRef qHandle As %Binary, input As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s Ret=""
    s DepSort="" f  s DepSort=$O(^CF.DHCINM.DB.WorkLoadDepSetI("DepSort",DepSort)) q:DepSort=""  d
    .s RowID="" f  s RowID=$O(^CF.DHCINM.DB.WorkLoadDepSetI("DepSort",DepSort,RowID)) q:RowID=""  d
    ..s Obj=##class(CF.DHCINM.DB.WorkLoadDepSet).%OpenId(RowID)
    ..i $IsObject(Obj) d
    ...s WardID=Obj.DepDR
    ...s WardType=""
    ...s MgSysParamSubID="" f  s MgSysParamSubID=$O(^CT.DHCINM.Set.MgSysParamSubD(1,MgSysParamSubID)) q:MgSysParamSubID=""  d
    ....s SubCode=$lg($g(^CT.DHCINM.Set.MgSysParamSubD(1,MgSysParamSubID)),2)
    ....s SubDesc=$lg($g(^CT.DHCINM.Set.MgSysParamSubD(1,MgSysParamSubID)),3)
    ....i SubCode=Obj.Typ  s WardType=SubDesc
    ...s WardSort=Obj.DepSort
    ...s WardDesc="",WardInput=""
    ...s WardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(WardID)
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
/// Table:CF.DHCINM.DB.MgWard
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.INMStatComm","FindMgWard","")
Query FindMgWard(input As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindMgWardExecute(ByRef qHandle As %Binary, input As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s Ret=""
    s Spell="" f  s Spell=$O(^CF.DHCINM.DB.MgWardI("Spell",Spell)) q:Spell=""  d
    .s RowID="" f  s RowID=$O(^CF.DHCINM.DB.MgWardI("Spell",Spell,RowID)) q:RowID=""  d
    ..s Obj=##class(CF.DHCINM.DB.MgWard).%OpenId(RowID)
    ..q:((input'="")&&((Obj.WardSpell_Obj.WardCode_Obj.WardDesc)'[$zcvt($tr(input," ",""),"U")))
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
/// table: CF.DHCINM.DB.WorkLoadDepSet
/// input:
/// output:
/// return:
/// other:w ##class(web.INMStatComm).DeleteWorkLoadDepSet("1^2^3^4^5")
ClassMethod DeleteWorkLoadDepSet(parr As %String) As %String
{
    f i=1:1:$L(parr,"^") d
    .s id=$p(parr,"^",i)
    .q:id=""
    .s Obj=##class(CF.DHCINM.DB.WorkLoadDepSet).%OpenId(id)
    .s sort=Obj.DepSort
    .s sc=Obj.%DeleteId(id)
    .s DepSetid="" f  s DepSetid=$O(^CF.DHCINM.DB.WorkLoadDepSetI("DepSort",sort+1,DepSetid)) q:DepSetid=""  d
    ..s DepSetObj=##class(CF.DHCINM.DB.WorkLoadDepSet).%OpenId(DepSetid)
    ..s DepSetObj.DepSort=sort
    ..s sort=sort+1
    ..d DepSetObj.%Save()
    q $$$ISOK(sc)
}

/// Description:保存工作量病区
/// Date:2018-08-01
/// Creator:zhangjz
/// Table:CF.DHCINM.DB.WorkLoadDepSet
/// Input:
/// Output:
/// other:w ##class(web.INMStatComm).SaveWorkLoadDepSet("2|病区^45|")
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
        s RowID=$O(^CF.DHCINM.DB.WorkLoadDepSetI("Dep",WardId,""))
        s WardCode=WardType
        i RowID=""
        {
            s ParId=$O(^CT.DHCINM.Set.MgSysParamI("Code"," "_$zcvt("WardType","U"),""))
            i ParId="" q
            ;s Par="" f  s Par=$O(^CT.DHCINM.Set.MgSysParamSubD(Par)) q:Par=""  d
            ;.q:(parid'="")&&(parid'=par)
            s Child="" f  s Child=$O(^CT.DHCINM.Set.MgSysParamSubD(ParId,Child)) q:Child=""  d
            .s Id=ParId_"||"_Child
            .s Obj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(Id)
            .s Code=Obj.SubCode
            .s Desc=Obj.SubDesc
            .i Desc=WardType s WardCode=Code
            s DepSetObj=##class(CF.DHCINM.DB.WorkLoadDepSet).%New()
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
    s Sort=$O(^CF.DHCINM.DB.WorkLoadDepSetI("DepSort",""),-1)
    i Sort'="" s Flag=$tr(Sort," ","")+1
    q Flag
}

/// Description:工作量病区上移下移操作
/// Date:2018-08-01
/// Creator:zhangjz
/// other:w ##class(web.INMStatComm).MoveWorkLoadDepSet("up",1)
ClassMethod MoveWorkLoadDepSet(type, rowid) As %String
{
    ;s ^TMP("MoveRec")=type_"%"_rowid //up%1
    q:rowid="" ""
    s Obj=##class(CF.DHCINM.DB.WorkLoadDepSet).%OpenId(rowid)
    q:'$IsObject(Obj) ""
    s DepSort=Obj.DepSort
    i type="up"
    {
        q:DepSort=1 "已是最顶部记录了"
        //^DHCINM.DB.MgNurCheckWardI("Sort"," N",1,1)
        s upsort=DepSort-1
        s uprow=$O(^CF.DHCINM.DB.WorkLoadDepSetI("DepSort",upsort,""))
        s upobj=##class(CF.DHCINM.DB.WorkLoadDepSet).%OpenId(uprow)
        s upobj.DepSort=DepSort
        d upobj.%Save()
        s Obj.DepSort=upsort
        d Obj.%Save()
        
    }
    elseif type="down"
    {
        s sort=$O(^CF.DHCINM.DB.WorkLoadDepSetI("DepSort",""),-1)
        q:DepSort=sort "已是最底部记录了"
        s upsort=DepSort+1
        s uprow=$O(^CF.DHCINM.DB.WorkLoadDepSetI("DepSort",upsort,""))
        s upobj=##class(CF.DHCINM.DB.WorkLoadDepSet).%OpenId(uprow)
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
    d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
    s id=$g(tmp("rowid"))
    s code=$zcvt($tr($g(tmp("WorkCode"))," ",""),"U")
    s Distill=$g(tmp("WorkDistill"))
    s rw=$o(^CF.DHCINM.DB.WorkLoadItmI("Type"," "_Distill," "_code,""))
    i rw="" s flag=0
    e  i rw'=""  d
    .i id=rw s flag=0
    .e  i id'=rw s flag=1
    b ;01
    q flag
}

/// creator:zhangjz
/// date:2018-08-03
/// desc:保存工作量项目表
/// table:CF.DHCINM.DB.WorkLoadItm
/// input:
/// output:
/// other: w ##class(web.INMStatComm).SaveWorkLoadItm("WorkItm|测试^WorkCode|test^WorkDistill|W^WorkRelItm|I^WorkPercent|12^WorkMeth|^CurrFlag|Y^StartDate|2017-08-17^EndDate|^rowid|3^")
ClassMethod SaveWorkLoadItm(parr As %String) As %String
{
    s ^TMP("SaveWorkLoadItm")=parr
    //WorkItm|静脉输液^WorkCode|静脉输液^WorkDistill|WorkLoad^WorkRelItm|Instruct^WorkPercent|0.1^WorkMeth|
    //^CurrFlag|Yes^StartDate|2018-10-25^EndDate|^rowid|1^
    q:parr="" ""
    d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
    //WorkCode不允许重复
    s flag=0
	s WorkDistill="" f  s WorkDistill=$o(^CF.DHCINM.DB.WorkLoadItmI("Type",WorkDistill)) q:WorkDistill=""  d
	.s WorkCode="" f  s WorkCode=$o(^CF.DHCINM.DB.WorkLoadItmI("Type",WorkDistill,WorkCode)) q:WorkCode=""  d
    ..s id="" f  s id=$o(^CF.DHCINM.DB.WorkLoadItmI("Type",WorkDistill,WorkCode,id)) q:(id=""||flag=1)  d
	...i (($tr(WorkCode," ","")=$g(tmp("WorkCode")))&&(id'=$g(tmp("rowid")))) s flag=1
    q:flag'=0 -1
    i $g(tmp("rowid"))'="" d
    .s Obj=##class(CF.DHCINM.DB.WorkLoadItm).%OpenId(tmp("rowid"))
    e  d
    .s Obj=##class(CF.DHCINM.DB.WorkLoadItm).%New()
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
/// table: CF.DHCINM.DB.WorkLoadItm
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMStatComm","FindWorkLoadItmList","","df")
Query FindWorkLoadItmList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWorkLoadItmListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    ;s ^TMP("wardparr")=parr
    s Ret=""
    s itype="" f  s itype=$O(^CF.DHCINM.DB.WorkLoadItmI("TYP",itype)) q:itype=""  d
    .s id="" f  s id=$O(^CF.DHCINM.DB.WorkLoadItmI("TYP",itype,id)) q:id=""  d
    ..s Obj=##class(CF.DHCINM.DB.WorkLoadItm).%OpenId(id)
    ..;q:((parr'="")&&(Obj.WardLocDR'="")&&(Obj.WardLocDR.%Id()'=parr))
    ..q:((input'="")&&((Obj.WorkItm_Obj.WorkCode)'[$tr(input," ","")))
    ..;s Ret=..GetWorkLoadItm(id)
    ..s WorkItm=Obj.WorkItm
    ..s WorkCode=Obj.WorkCode
    ..s WorkDistill=##class(web.INMHISComm).GetDescForSysType("WorkDistill",Obj.WorkDistill)
    ..s WorkRelItm=##class(web.INMHISComm).GetDescForSysType("WorkRelItm",Obj.WorkRelItm)
    ..s WorkPercent=Obj.WorkPercent
    ..s WorkMeth=Obj.WorkMeth
    ..i Obj.CurrFlag="Y" s CurrFlag="Yes"
    ..e  i Obj.CurrFlag="N" s CurrFlag="No"
    ..i Obj.StartDate'="" s StartDate=##class(web.INMHISComm).DateLogicalToHtml(Obj.StartDate)
    ..e  s StartDate=""
    ..i Obj.EndDate'="" s EndDate=##class(web.INMHISComm).DateLogicalToHtml(Obj.EndDate)
    ..e  s EndDate=""
    ..s WorkItmRel=..GetWorkItmRel(id,WorkRelItm)
    ..s Ret="rowid|"_id_"^WorkItm|"_WorkItm_"^WorkCode|"_WorkCode_"^WorkDistill|"_WorkDistill_"^WorkRelItm|"_WorkRelItm_"^WorkPercent|"_WorkPercent_"^WorkMeth|"_WorkMeth_"^CurrFlag|"_CurrFlag
    ..s Ret=Ret_"^StartDate|"_StartDate_"^EndDate|"_EndDate_"^WorkItmRel|"_WorkItmRel
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

/// creator: jyc
/// date:2022-06-27
/// description: 获取工作量项目关联内容
/// table: CF.DHCINM.DB.WorkLoadItm
/// input:
/// output:
/// other: w ##class(web.INMStatComm).GetWorkItmRel(1)
ClassMethod GetWorkItmRel(id As %String, relItm As %String) As %String
{
    ;s ^TMP("GetWorkLoadItm")=id
    q:(id="")||(relItm="") ""
    s relRet=""
    i relItm="Instruct" d
    .s itmObj=##class(CF.DHCINM.DB.WorkLoadItm).%OpenId(id)
    .s subRowId="" f  s subRowId=$O(^CF.DHCINM.DB.WorkLoadItmSubI("WorkItm",id,subRowId)) q:subRowId=""  d
    ..s subObj=##class(CF.DHCINM.DB.WorkLoadItmSub).%OpenId(subRowId)
    ..q:'$IsObject(subObj)
    ..s instructId=subObj.WorkRelInstruct
    ..q:instructId=""
    ..s instructData=$g(^PHCIN(instructId))
    ..q:instructData=""
    ..s instructDes=$P(instructData,"^",2)
    ..i relRet="" s relRet=instructDes
    ..e  s relRet=relRet_","_instructDes
    e  d
    .s itmObj=##class(CF.DHCINM.DB.WorkLoadItm).%OpenId(id)
    .s subRowId="" f  s subRowId=$O(^CF.DHCINM.DB.WorkLoadItmSubI("WorkItm",id,subRowId)) q:subRowId=""  d
    ..s subObj=##class(CF.DHCINM.DB.WorkLoadItmSub).%OpenId(subRowId)
    ..q:'$IsObject(subObj)
    ..s orderItmId=subObj.WorkRelArcim
    ..q:orderItmId=""
    ..s ARCIMRowid=$P(orderItmId,"||",1)
    ..q:(ARCIMRowid="")
    ..s ARCIMSub=$P(orderItmId,"||",2) 
    ..q:ARCIMSub=""
    ..s ItmName=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name  
    ..s ItmName=$tr(ItmName,"|","-")
    ..s ItmName=$tr(ItmName,":","-")
    ..s ItmName=$tr(ItmName,"[","(")
    ..s ItmName=$tr(ItmName,"]",")")
    ..s ItmName=$tr(ItmName,"\","")
    ..s ItmName=$tr(ItmName,"'","")   //有'会报错
    ..i relRet="" s relRet=ItmName
    ..e  s relRet=relRet_","_ItmName
    
    q relRet
}

/// creator: zhangjz
/// date:2018-08-03
/// description: 删除工作量项目
/// table: CF.DHCINM.DB.WorkLoadItm
/// input:
/// output:
/// other: w ##class(web.INMStatComm).DeleteWorkLoadItm(1)
ClassMethod DeleteWorkLoadItm(id As %String) As %String
{
    q:id="" ""
    s Obj=##class(CF.DHCINM.DB.WorkLoadItm).%OpenId(id)
    i '$IsObject(Obj) q 0
    s sc=Obj.%DeleteId(id)
    s subRowId=$O(^CF.DHCINM.DB.WorkLoadItmSubI("WorkItm",id,""))
    q:subRowId="" $$$ISOK(sc)
    s subObj=##class(CF.DHCINM.DB.WorkLoadItmSub).%OpenId(subRowId)
    q:'$IsObject(subObj) $$$ISOK(sc)
    s sc=subObj.%DeleteId(subRowId)
    q $$$ISOK(sc)
}

/// creator:zhangjz
/// date:2018-08-07
/// desc:保存工作量项目关联类别"itmId|6^workRelInstruct|^workRelArcim|11548!1^"
/// table:CF.DHCINM.DB.WorkLoadItmSub
/// input:
/// output:
/// other: w ##class(web.INMStatComm).SaveWorkLoadItmSub("itmId|6^workRelInstruct|^workRelArcim|11548!1")
ClassMethod SaveWorkLoadItmSub(parr As %String) As %String
{
    ;s ^TMP("SaveWorkLoadItm")=parr
    q:parr="" ""
    d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
    s ItmObj=##class(CF.DHCINM.DB.WorkLoadItm).%OpenId(tmp("itmId"))
    ;s SubId=$O(^CF.DHCINM.DB.WorkLoadItmSubI("WorkItm",tmp("itmId"),""))
    ;i SubId="" d
    ;.s SubObj=##class(CF.DHCINM.DB.WorkLoadItmSub).%New()
    ;e  d
    ;.s SubObj=##class(CF.DHCINM.DB.WorkLoadItmSub).%OpenId(SubId)
    s SubObj=##class(CF.DHCINM.DB.WorkLoadItmSub).%New()
    s SubObj.WorkItm=ItmObj
    s SubObj.WorkRelInstruct=$g(tmp("workRelInstruct"))
    s ARCIMRowid=$p($g(tmp("workRelArcim")),"!",1)
    s ARCIMSub=$p($g(tmp("workRelArcim")),"!",2)
    s WorkRelArcim=ARCIMRowid_"||"_ARCIMSub
    s SubObj.WorkRelArcim=WorkRelArcim
    s Sc=SubObj.%Save()
    q $$$ISOK(Sc)
}

/// creator:zhangjz
/// date:2018-08-07
/// desc:保存工作量项目关联类别"itmId|6^workRelInstruct|^workRelArcim|11548!1^"
/// table:CF.DHCINM.DB.WorkLoadItmSub
/// input:
/// output:
/// other: w ##class(web.INMStatComm).SaveWorkRelArcim("itmId|3^workRelInstruct|^workRelArcim|11362!1,11363!1")
ClassMethod SaveWorkRelArcim(parr As %String) As %String
{
    s ^TMP("SaveWorkLoadItmSub")=parr
    q:parr="" ""
    s Sc=0
    d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
    f i=1:1:$L($g(tmp("workRelArcim")),",") d
    .s id=$p($g(tmp("workRelArcim")),",",i)
    .q:id=""
    .s ARCIMRowid=$p(id,"!",1)
    .s ARCIMSub=$p(id,"!",2)
    .s WorkRelArcim=ARCIMRowid_"||"_ARCIMSub
    .s SubId=$O(^CF.DHCINM.DB.WorkLoadItmSubI("ItmArcimInstr"," "_WorkRelArcim,""))
    .q:SubId'=""
    .s ItmObj=##class(CF.DHCINM.DB.WorkLoadItm).%OpenId(tmp("itmId"))
    .;s SubId=$O(^CF.DHCINM.DB.WorkLoadItmSubI("WorkItm",tmp("itmId"),""))
    .;i SubId="" d
    .;.s SubObj=##class(CF.DHCINM.DB.WorkLoadItmSub).%New()
    .;e  d
    .;.s SubObj=##class(CF.DHCINM.DB.WorkLoadItmSub).%OpenId(SubId)
    .s SubObj=##class(CF.DHCINM.DB.WorkLoadItmSub).%New()
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
/// other:  d ##class(%ResultSet).RunQuery("web.INMStatComm","FindOrdItm","","静脉输")
Query FindOrdItm(ids As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindOrdItmExecute(ByRef qHandle As %Binary, ids As %String = "", input As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s ^TMP("FindOrdItm")=ids_"&"_input
    q:"" ""
    s ids=$ZConvert(ids,"U")
    s id=ids_" "
    s ln=$L(ids)
    s im=ids
    s Flag=0
    s Ret=""
    s n=0
    k tmp
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
    ...q:$g(tmp(aa))'=""
    ...s tmp(aa)=aa
    ...;s ItmSort=##class(web.INMVueComm).ToChineseSpell(ItmName)
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
/// other:  d ##class(%ResultSet).RunQuery("web.INMStatComm","GetPhcin","")
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
/// table:CF.DHCINM.DB.WorkLoadItmSub
/// input:WorkLoadItm.RowId
/// output:
/// other: w ##class(web.INMStatComm).GetWorkLoadItmSub("3")
ClassMethod GetWorkLoadItmSub(id As %String) As %String
{
    q:id="" ""
    s itmObj=##class(CF.DHCINM.DB.WorkLoadItm).%OpenId(id)
    s subRowId=$O(^CF.DHCINM.DB.WorkLoadItmSubI("WorkItm",id,""))
    q:subRowId="" ""
    s subObj=##class(CF.DHCINM.DB.WorkLoadItmSub).%OpenId(subRowId)
    q:'$IsObject(subObj) ""
    s workRelArcim=subObj.WorkRelArcim
    s workRelInstruct=subObj.WorkRelInstruct
    s Ret="workRelArcim|"_workRelArcim_"^workRelInstruct|"_workRelInstruct_"^SubRowId|"_subRowId
    q Ret
}

/// creator:zhangjz
/// date:2018-08-10
/// desc:查询工作量项目关联的医嘱
/// table:CF.DHCINM.DB.WorkLoadItmSub
/// input:
/// output:
/// other:  d ##class(%ResultSet).RunQuery("web.INMStatComm","FindWorkLoadItmSub","2","")
Query FindWorkLoadItmSub(id As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWorkLoadItmSubExecute(ByRef qHandle As %Binary, id As %String = "", input As %String = "") As %Status
{
	s ^TMP("FindWorkLoadItmSub")=id_"$"_input
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    q:id="" ""
    s itmObj=##class(CF.DHCINM.DB.WorkLoadItm).%OpenId(id)
    s subRowId="" f  s subRowId=$O(^CF.DHCINM.DB.WorkLoadItmSubI("WorkItm",id,subRowId)) q:subRowId=""  d
    .s subObj=##class(CF.DHCINM.DB.WorkLoadItmSub).%OpenId(subRowId)
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
    s ItmSort=##class(web.INMVueComm).ToChineseSpell(ItmName)
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
/// table:CF.DHCINM.DB.WorkLoadItmSub
/// input:
/// output:
/// other:  d ##class(%ResultSet).RunQuery("web.INMStatComm","FindWorkLoadInstruct","6","")
Query FindWorkLoadInstruct(id As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWorkLoadInstructExecute(ByRef qHandle As %Binary, id As %String = "", input As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    q:id="" ""
    s itmObj=##class(CF.DHCINM.DB.WorkLoadItm).%OpenId(id)
    s subRowId="" f  s subRowId=$O(^CF.DHCINM.DB.WorkLoadItmSubI("WorkItm",id,subRowId)) q:subRowId=""  d
    .s subObj=##class(CF.DHCINM.DB.WorkLoadItmSub).%OpenId(subRowId)
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
/// table: CF.DHCINM.DB.WorkLoadItm
/// input:
/// output:
/// other: w ##class(web.INMStatComm).DeleteWorkLoadItm(1)
ClassMethod DeleteWorkLoadItmSub(ids As %String) As %String
{
    q:ids="" ""
    f i=1:1:$L(ids,",") d
    .s id=$P(ids,",",i)
    .s Obj=##class(CF.DHCINM.DB.WorkLoadItmSub).%OpenId(id)
    .i '$IsObject(Obj) q
    .s sc=Obj.%DeleteId(id)
    q $$$ISOK(sc)
}

/// creator: zhangjz
/// date:2018-08-22
/// description: 生成病房工作量日报数据任务  
/// table: DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.INMStatComm).WardDayReport("2018-04-01")
ClassMethod WardDayReport(parr As %String) As %String
{
    ;s sysdate=+$H-1
    s sysdate=$ZDH(parr,3)
    ;s sysdate="64750"
    s sysdate=$zd(sysdate,3)
    s sysdate2=sysdate
    //s ab=##class(web.INMStatComm).GenerateWardReport(sysdate,sysdate2,"3901")
    //s ab=##class(web.INMStatComm).GenerateWardReport(sysdate,sysdate2,"1")
    s ab=##class(web.INMStatComm).GenerateWardReport(parr,sysdate2,"1")
    q 0
}

/// creator: zhangjz
/// date:2018-08-22
/// description: 生成病房工作量日报数据任务  
/// table: DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: d ##class(web.INMStatComm).GenerateWardReport("2018-04-12","2018-04-12","1")
ClassMethod GenerateWardReport(StDate As %String, EndDate As %String, User = "1") As %String
{
    s StDate=$ZDH(StDate,3)
    s EndDate=$ZDH(EndDate,3)
    s Typ="W"
    f Date=StDate:1:EndDate
    {
	    k WorkLoad,NurWork,LoadItm
        s WorkLoad="",NurWork="",LoadItm=""
        s Rw=""  f  s Rw=$O(^CF.DHCINM.DB.WorkLoadItmI("TYP"," "_Typ,Rw)) q:Rw=""  d
        .s Obj=##class(CF.DHCINM.DB.WorkLoadItm).%OpenId(Rw)
        .q:'$IsObject(Obj)
        .s WkitmDesc=Obj.WorkItm
        .//计算入院人数
        .i WkitmDesc["入院" d ..GetNotOrderNum(Date,Date,.WorkLoad,Rw) q
        .s TypPhc=Obj.WorkRelItm  //项目类别
        .i TypPhc="" s TypPhc="N"
        .s Flag=Obj.CurrFlag
        .q:Flag'="Y" //不可用
        .s Styp=Obj.WorkDistill  //提取方式
        .q:Styp'="W"
        .s StringPhc=""
        .s Raw1="" f  s Raw1=$O(^CF.DHCINM.DB.WorkLoadItmSubI("WorkItm",Rw,Raw1)) q:Raw1=""  d
        ..s Rel=Raw1
        ..s ObjSub=##class(CF.DHCINM.DB.WorkLoadItmSub).%OpenId(Rel)
        ..q:'$IsObject(ObjSub)
        ..i TypPhc'="I" s Itm=ObjSub.WorkRelArcim
        ..e  i TypPhc="I"  s Itm=ObjSub.WorkRelInstruct
        ..q:Itm=""
        ..d ..GetNurWorkByExecDate(Itm,Date,Date,.NurWork,.WorkLoad,.LoadItm,Rw,Rel)
        if $D(WorkLoad) d ..DeleteWorkDayReport($ZD(Date,3))
        if $D(WorkLoad) d ..InsertWork(.NurWork,.WorkLoad,.LoadItm,Date,Date,User)
    }
    q ""
}

/// creator: zhangjz
/// date:2018-08-22
/// description: 生成病房工作量日报数据任务  
/// table: DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.INMStatComm)GetNotOrderNum()
ClassMethod GetNotOrderNum(StDate, EndDate, WorkLoad, WkItm) As %String
{
    i +StDate'=StDate s StDate=$ZDH(StDate,3)
    i +EndDate'=EndDate s EndDate=$ZDH(EndDate,3)
    s WkitmName=$listget(^CF.DHCINM.DB.WorkLoadItmD(WkItm),2)
    k MotherAdm
    f Date=StDate:1:EndDate
    {
        if WkitmName["入院"
        {
            s DepItm=##class(web.INMStatComm).GetSortDep("W")
            s Num=0
            s l=$L(DepItm,"^")
            for i=1:1:l d
            .s aa=$P(DepItm,"^",i)
            .if aa="" continue
            .s Dep=$P(aa,"|")
            .q:Dep=""
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
            .s dep=$O(^CF.DHCINM.DB.MgWardI("CTLoc",Dep,""))
            .q:dep=""
            .d CalNum23(Num,WkItm,dep)
        }
    }
    q 0
CalNum23(Num,WkItm,Dep)
    s a=^CF.DHCINM.DB.WorkLoadItmD(WkItm)
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
/// table: DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.INMStatComm).WardDayReport()
ClassMethod GetSortDep(Typ) As %String
{
    s Typ=$zcvt(Typ,"U")
    s Ret=""
    s DepDR="" f  s DepDR=$O(^CF.DHCINM.DB.MgWardD(DepDR)) q:DepDR=""  d
    .s Obj=##class(CF.DHCINM.DB.MgWard).%OpenId($tr(DepDR," ",""))
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
/// table: DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.INMStatComm).WardDayReport()
ClassMethod InsertWork(NurWork, WorkLoad, LoadItm, StDate, EndDate, User) As %String
{
     TSTART
     s Ward=""  f  s Ward=$O(WorkLoad(Ward)) q:Ward=""  d
     .s Rep=##class(DHCINM.Work.MgNurWorkReport).%New()
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
     ..s RepWard=##class(DHCINM.Work.MgNurWorkRpWard).%New()
     ..s RepWard.WardParref=Rep
     ..s RepWard.WardWorkItm=##class(CF.DHCINM.DB.WorkLoadItm).%OpenId(Itm)
     ..i $L(WorkLoad(Ward,Itm),".")>1 d
     ...s RepWard.WardWorkNum=$fn(WorkLoad(Ward,Itm),"",2)
     ..e  d
     ...s RepWard.WardWorkNum=WorkLoad(Ward,Itm)
     ..s WorkPercent=RepWard.WardWorkItm.WorkPercent
     ..s RepWard.WardWorkCount=$fn(WorkLoad(Ward,Itm)*WorkPercent,"",2)
     ..if $$$ISOK(RepWard) d
     ...d RepWard.%Save()
     ...s SubItm="" f  s subitm=$O(LoadItm(Ward,Itm,SubItm)) q:SubItm=""  d
     ....s Item=##class(DHCINM.Work.MgNurWorkRpSubItmData).%New()
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
     ...s RepSub=##class(DHCINM.Work.MgNurWorkRpSub).%New()
     ...s RepSub.WorkRpParef=Rep
     ...s RepSub.WorkRpSubItmDR=##class(CF.DHCINM.DB.WorkLoadItm).%OpenId(WorkItm)
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
/// table: DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.INMStatComm).WardDayReport()
ClassMethod GetNurWorkByExecDate(Itm, StDate, EndDate, NurWork, WorkLoad, LoadItm, WkItm, SubItm)
{
    //只统计接收科室为工作量统计维护科室
    ;s WorkLoadLocStr=..GetWorkLoadLocs("W")
    q:WkItm="" ""
    s Obj=##class(CF.DHCINM.DB.WorkLoadItm).%OpenId(WkItm)
    q:Obj="" ""
    s RelTyp=Obj.WorkRelItm
    k ^TempHourWork
    f Date=StDate:1:EndDate
    {
        ;s Oew=""  f  s Oew=$O(^OEORDi(0,"Date",Oew)) q:Oew=""  d    //576
        s ExstTime="" f  s ExstTime=$O(^OEORDi(0,"DateExec",Date,ExstTime)) q:ExstTime=""  d
        .s Oew=""  f  s Oew=$O(^OEORDi(0,"DateExec",Date,ExstTime,Oew)) q:Oew=""  d
        ..s LinkFlag=0
        ..s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"Date",Oew,Date,ExstTime,OrdSub)) q:OrdSub=""  d
        ...s OeoreSub="" f  s OeoreSub=$O(^OEORDi(0,"Date",Oew,Date,ExstTime,OrdSub,OeoreSub)) q:OeoreSub=""  d
        ....s ExecStatusId=$p($g(^OEORD(Oew,"I",OrdSub,"X",OeoreSub)),"^",16) //执行状态
        ....;zw ExecStatusId   	//1:已执行;2:停止执行;3:撤销执行;4:接收;5:拒绝执行	SELECT * FROM OEC_Order_AdminStatus
        ....q:((ExecStatusId'=1)&&(ExecStatusId'="")) //只统计已执行和补录的未执行医嘱
        ....s ArcimId=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
        ....q:ArcimId=""
        ....q:(RelTyp'="I")&&(Itm'=ArcimId)
        ....s PhcinId=$p($g(^OEORD(Oew,"I",OrdSub,2)),"^",7) ;OEORI_Instr_DR 用药途径
        ....q:(RelTyp="I")&&(PhcinId="")
        ....;s PhcinId="^"_PhcinId_"^"
        ....q:(RelTyp="I")&&(Itm'=PhcinId)     
        ....s ARCIMRowid=$p(ArcimId,"||",1)
        ....s ARCIMSub=$p(ArcimId,"||",2)
        ....s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)  //医嘱子类ID--ARc_Itemcat
        ....q:ItemCatDR=""
        ....s ItemCat=$P(^ARC("IC",ItemCatDR),"^",2)                    //子类描述
        ....q:ItemCat["材料"
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
        ....s RecDep=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",6)         //接收科室
        ....s RecDepType=$P($G(^CTLOC(RecDep)),"^",13)
        ....s Tdep="^"_RecDep_"^"
        ....//接收科室为病区且病区已维护，则工作量算在该病区
        ....;i (RecDepType="W")&&(WorkLoadLocStr[Tdep) s Dep=RecDep
        ....i (RecDepType="W") s Dep=RecDep 
        ....s UserDep=$p($g(^OEORD(Oew,"I",OrdSub,7)),"^",2)        //开嘱科室
        ....i Dep="" d
        .....s UserDep=$p($g(^OEORD(Oew,"I",OrdSub,7)),"^",2)       //开嘱科室
        .....q:UserDep=""
        .....s TUserDep="^"_UserDep_"^"
        .....s UserDepType=$P($G(^CTLOC(UserDep)),"^",13)
        .....//开单科室为病区且病区已维护，则工作量算在该病区
        .....;i (UserDepType="W")&&(WorkLoadLocStr]TUserDep) s Dep=UserDep
        .....i (UserDepType="W") s Dep=UserDep
        ....s LinkLocStr="^"
        ....s LinkLoc=""
        ....s LinkFlag=0
        ....i (Dep="") d
        .....//下医嘱时病人所在病区与开单科室有关联且已维护，则工作量算在病人所在病区
        .....s CreateDate=$p(^OEORD(Oew,"I",OrdSub,3),"^",7)  //下医嘱日期
        .....s CreateTime=$p(^OEORD(Oew,"I",OrdSub,1),"^",17)
        .....s CDateTime=##class(web.INMStatComm).GetAbsTime(CreateDate_","_CreateTime)
        .....s EpisodeID=$p(^OEORD(Oew),"^",1)
        .....s PatWardLoc=..Getpatlocbydatetime(EpisodeID,CDateTime)
        .....q:PatWardLoc=""
        .....s TPatWardLoc="^"_PatWardLoc_"^"
        .....;q:TPatWardLoc'[WorkLoadLocStr     //新老病区ID不一致，无法比较
        .....;q:WorkLoadLocStr'[TPatWardLoc     
        .....//取开单科室关联病区科室
        .....s Chl=0 f  s Chl=$O(^CTLOC(UserDep,"LINK",Chl)) q:(Chl="")!(LinkFlag=1)  d
        ......s LinkLoc=$P($g(^CTLOC(UserDep,"LINK",Chl)),"^",1)
        ......q:LinkLoc=""
        ......i PatWardLoc=LinkLoc s LinkFlag=1
        .....q:LinkLoc=""
        .....s LinkDepType=$P($G(^CTLOC(LinkLoc)),"^",13)
        .....i (LinkDepType="W") s Dep=LinkLoc
        ....i Dep'="" s Dep=$O(^CF.DHCINM.DB.MgWardI("CTLoc",Dep,""))
        ....q:Dep=""
        ....s Str=""
        ....s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",OeoreSub),"^",15)
        ....i CPTExDR'="" s CPTEx=$P(^CTPCP(CPTExDR,1),"^",2)
        ....q:CPTExDR=""
        ....//s Str=..GetNurWard1(CPTExDR,Date,Date)
        ....//取执行人在护管人员信息表rowid
        ....s PerId=..GetNurPeridByCTPCP(CPTExDR)   //护士档案表CF.DHCINM.HR.Persons未与SSuser关联ID，PerUserDR为空，测试取第一个ID
        ....q:PerId=""
        ....s DNum=1,Num=1
        ....s HNum=1
        ....d CalNum2NurWork(DNum,HNum,Num,WkItm,PerId,Dep,SubItm)
    }
    q 0
CalNum2NurWork(DNum,HNum,Num,WItm,PerId,Dep,Itm)
    s WorkLoadObj=^CF.DHCINM.DB.WorkLoadItmD(WItm)
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
    .s WorkLoad(Dep,WItm)=$G(WorkLoad(Dep,WItm))+HNum
    .i PerId'="" s NurWork(Dep,PerId,WItm)=$G(NurWork(Dep,PerId,WItm))+HNum
    .s LoadItm(Dep,WItm,Itm)=$G(LoadItm(Dep,WItm,Itm))+HNum
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
/// table: DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.INMStatComm).WardDayReport()
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
            s Sort="" f  s Sort=$O(^CF.DHCINM.DB.WorkLoadDepSetI("TypSort"," "_Typ,Sort)) q:Sort=""  d
            .s Id="" f  s Id=$O(^CF.DHCINM.DB.WorkLoadDepSetI("TypSort"," "_Typ,Sort,Id)) q:Id=""  d
            ..s Obj=##class(CF.DHCINM.DB.WorkLoadDepSet).%OpenId(Id)
            ..q:'$IsObject(Obj)
            ..s DepDR=Obj.DepDR
            ..s Obj=##class(CF.DHCINM.DB.MgWard).%OpenId(DepDR)
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
/// table: DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.INMStatComm).WardDayReport()
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
    .s StDt=##class(web.INMStatComm).GetAbsTime(StartDate_","_StartTime) //开始时间
    .q:StDt>DateTime
    .s Ret=$p(^PAWARD(WardDr),"^",5)
    q Ret
}

/// creator: zhangjz
/// date:2018-08-22
/// description: 生成病房工作量日报数据任务  -取执行人在护管人员信息表rowid
/// table: DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.INMStatComm).WardDayReport()
ClassMethod GetNurPeridByCTPCP(NurDr)
{
    q:NurDr="" ""
    s SSDr="" s SSDr=$O(^SSU("SSUSR",0,"CTPCP",NurDr,SSDr))
    q:SSDr="" ""
    s Obj=##class(User.SSUser).%OpenId(SSDr)
    s nurseid=Obj.SSUSRInitials
    s nurseid=$ZCvt(nurseid,"U")
    s PerId="" 
    ;s PerId=$O(^CF.DHCINM.HR.PersonsI("SSID"," "_SSDr,PerId))
    ;zw nurseid
    ;s PerId=$O(^CF.DHCINM.HR.PersonsI("PerID"," "_nurseid,PerId))
    s PerId=$O(^CF.DHCINM.HR.PersonsI("hisno"," "_nurseid,PerId))
    q:PerId="" ""
    q PerId
}

/// creator: zhangjz
/// date:2018-09-01
/// description: 查询日报数据 
/// table: DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMStatComm","SchWorkDayReport","2018-04-01^2018-04-30")
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
     s Rw=""  f  s Rw=$O(^DHCINM.Work.MgNurWorkReportI("StDate",Date,Rw)) q:Rw=""  d
     .;q:$D(DRP(Date)) 
     .s Obj=##class(DHCINM.Work.MgNurWorkReport).%OpenId(Rw)
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
     .s WardId=$O(^CF.DHCINM.DB.MgWardI("CTLoc",WorkDepDr,""))
     .s WardId=WorkDepDr
     .s WardDesc=""
     .i WardId'="" s WardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(WardId)),4)
     .s DRP(Date,Rw)=CreatDate_"^"_CreatTime_"^"_WorkDepDr_"^"_WorkDepDes_"^"_WardId_"^"_WardDesc
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
    ..d out2
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

  
out2
    s Ret="WorkStDate|"_Date_"^WorkCreateDate|"_CreatDate_"^WorkCreatTime|"_CreatTime_"^WorkDepDr|"_WorkDepDr_"^WorkDepDes|"_WorkDepDes_"^WardId|"_WardId_"^WardDesc|"_WardDesc
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
/// table: DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.INMStatComm).DeleteWorkDayReport("2018-04-12")
ClassMethod DeleteWorkDayReport(parr As %String) As %String
{
    q:parr="" ""
    s DelDate=$ZDH(parr,3)
    s Sc=0
    s Rw=""  f  s Rw=$O(^DHCINM.Work.MgNurWorkReportI("StDate",DelDate,Rw)) q:Rw=""  d
    .s Obj=##class(DHCINM.Work.MgNurWorkReport).%OpenId(Rw)
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
/// table: DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.INMStatComm).CreatRp("2020-11-01","2020-11-30",1,"2020-11","","WorkLoad")
ClassMethod CreatRp(StDate, EndDate, User, Mon, Mem = "", Typ) As %String
{
    s NurWork="", WorkLoad="", LoadItm=""
     s StDate=$ZDH(StDate,3)
     s EndDate=$ZDH(EndDate,3)
     f Date=StDate:1:EndDate
     {
         s Par=""  f  s Par=$O(^DHCINM.Work.MgNurWorkReportI("StDate",Date,Par)) q:Par=""  d
         .s Loc=$list(^DHCINM.Work.MgNurWorkReportD(Par),2)
         .s Rw=""  f  s Rw=$O(^DHCINM.Work.MgNurWorkReportD(Par,"ChildWard",Rw)) q:Rw=""  d
         ..s Itm=$list(^DHCINM.Work.MgNurWorkReportD(Par,"ChildWard",Rw),2)
         ..s Num=$list(^DHCINM.Work.MgNurWorkReportD(Par,"ChildWard",Rw),3)
         ..s Count=$list(^DHCINM.Work.MgNurWorkReportD(Par,"ChildWard",Rw),4)
         ..s WorkLoad(Loc,Itm)=$G(WorkLoad(Loc,Itm))+Num
         ..s Sub=""  f  s Sub=$O(^DHCINM.Work.MgNurWorkReportD(Par,"ChildWard",Rw,"ChildItmData",Sub)) q:Sub=""  d
         ...s SubItm=$List(^DHCINM.Work.MgNurWorkReportD(Par,"ChildWard",Rw,"ChildItmData",Sub),2)
         ...s SubNum=$List(^DHCINM.Work.MgNurWorkReportD(Par,"ChildWard",Rw,"ChildItmData",Sub),3)
         ...s LoadItm(Loc,Itm,SubItm)=$G(LoadItm(Loc,Itm,SubItm))+SubNum
         .s Rw=""  f  s Rw=$O(^DHCINM.Work.MgNurWorkReportD(Par,"ChildSub",Rw)) q:Rw=""  d
         ..s Itm=$list(^DHCINM.Work.MgNurWorkReportD(Par,"ChildSub",Rw),2)
         ..s Nur=$list(^DHCINM.Work.MgNurWorkReportD(Par,"ChildSub",Rw),5)
         ..s Num=$list(^DHCINM.Work.MgNurWorkReportD(Par,"ChildSub",Rw),3)
         ..s Count=$list(^DHCINM.Work.MgNurWorkReportD(Par,"ChildSub",Rw),4)
         ..s NurWork(Loc,Nur,Itm)=$G(NurWork(Loc,Nur,Itm))+Num
     }
     if $D(WorkLoad) d ..DeleteMonthReport($ZD(StDate,3))
     if $D(WorkLoad) d ..InsertMonWork(.NurWork,.WorkLoad,.LoadItm,StDate,EndDate,User,Mon,Mem,Typ)
     q 0
}

/// creator: zhangjz
/// date:2018-08-22
/// description: 生成月报
/// table: DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.INMStatComm).CreatRp()
ClassMethod InsertMonWork(NurWork, WorkLoad, LoadItm, StDate, EndDate, User, Mon, Mem, Typ) As %String
{
    s WorkRpId=##class(web.INMStatComm).SaveMonWork(StDate,EndDate,Mon,Mem,Typ,User)
    q:WorkRpId="0" 0
    TSTART
    s Ward=""  f  s Ward=$O(WorkLoad(Ward)) q:Ward=""  d
    .s Rep=##class(DHCINM.Work.MgNurWardMonRp).%New()
    .s Rep.WorkDepDr=Ward
    .s Rep.WorkStDate=StDate
    .s Rep.WorkEndDate=EndDate
    .s Rep.WorkCreateDate=+$H
    .s Rep.WorkCreatTime=$P($H,",",2)
    .s Rep.WorkRp=##class(DHCINM.Work.MgNurWorkRp).%OpenId(WorkRpId)
    .if $$$ISOK(Rep) d
    ..d Rep.%Save()
    ..d Rep.%Close()
    .e  d
    ..TROLLBACK 
    .s Itm="" f  s Itm=$O(WorkLoad(Ward,Itm)) q:Itm=""  d
    ..s RepWard=##class(DHCINM.Work.MgNurWardMonSub).%New()
    ..s RepWard.WardParref=Rep
    ..s RepWard.WardWorkItm=##class(CF.DHCINM.DB.WorkLoadItm).%OpenId(Itm)
    ..s RepWard.WardWorkNum=WorkLoad(Ward,Itm)
    ..s RepWard.WardWorkCount=WorkLoad(Ward,Itm)*RepWard.WardWorkItm.WorkPercent
    ..if $$$ISOK(RepWard) d
    ...d RepWard.%Save()
    ...s SubItm="" f  s SubItm=$O(LoadItm(Ward,Itm,SubItm)) q:SubItm=""  d
    ....s Item=##class(DHCINM.Work.MgNurWardMonSubItm).%New()
    ....s Item.WorkRpWardParref=RepWard
    ....s Item.SubItm=SubItm
    ....s Item.SubItmNum=LoadItm(Ward,Itm,SubItm)
    ....d Item.%Save()
    ...d RepWard.%Close()
    ..e  TROLLBACK
    .s PerId=""  f  s PerId=$O(NurWork(Ward,PerId)) q:PerId=""  d
    ..s WorkItm=""  f  s WorkItm=$O(NurWork(Ward,PerId,WorkItm)) q:WorkItm=""  d
    ...s RepSub=##class(DHCINM.Work.MgNurWardMonSubPer).%New()
    ...s RepSub.WorkRpParef=Rep
    ...s RepSub.WorkRpSubItmDR=##class(CF.DHCINM.DB.WorkLoadItm).%OpenId(WorkItm)
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
/// table:DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.INMStatComm).SaveMonWork("itmId|6^workRelInstruct|^workRelArcim|9962")
ClassMethod SaveMonWork(StDate, EndDate, Mon, Mem, worktyp, User) As %String
{
    s a=##class(DHCINM.Work.MgNurWorkRp).%New()
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
/// table:DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMStatComm","GetWorkMonRp","2018-04-01^2018-04-30")
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
     s Rw=""  f  s Rw=$O(^DHCINM.Work.MgNurWorkRpI("StDate",Date,Rw)) q:Rw=""  d
     .s SDate=$list(^DHCINM.Work.MgNurWorkRpD(Rw),3)
     .s SDate=$ZD(SDate,3)
     .s EDate=$list(^DHCINM.Work.MgNurWorkRpD(Rw),4)
     .s EDate=$ZD(EDate,3)
     .s CreatDate=$list(^DHCINM.Work.MgNurWorkRpD(Rw),6)
     .s CreatDate=$ZD(CreatDate,3)
     .s CreatTime=$list(^DHCINM.Work.MgNurWorkRpD(Rw),7)
     .;s CreatTime=""
     .s CreatTime=$ZT(CreatTime)
     .s User=""
     .;s Mem=$list(^DHCINM.Work.MgNurWorkRpD(Rw),8)
     .s Mem=""
     .s Title=$list(^DHCINM.Work.MgNurWorkRpD(Rw),2)
     .;s Title=""
     .s Mon=$list(^DHCINM.Work.MgNurWorkRpD(Rw),9)
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
/// table: DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.INMStatComm).DeleteMonthReport("2018-04-01")
ClassMethod DeleteMonthReport(parr As %String) As %String
{
    q:parr="" ""
    s DelDate=$ZDH(parr,3)
    s Sc=0
    s Rw=""  f  s Rw=$O(^DHCINM.Work.MgNurWorkRpI("StDate",DelDate,Rw)) q:Rw=""  d
    .s Obj=##class(DHCINM.Work.MgNurWorkRp).%OpenId(Rw)
    .i '$IsObject(Obj) q
    .s Sc=Obj.%DeleteId(Rw)
    .s SubRw=""  f  s SubRw=$O(^DHCINM.Work.MgNurWardMonRpI("WorkRp",Rw,SubRw)) q:SubRw=""  d
    ..s SubObj=##class(DHCINM.Work.MgNurWardMonRp).%OpenId(SubRw)
    ..i '$IsObject(SubObj) q
    ..s Sc=SubObj.%DeleteId(SubRw)
    q $$$ISOK(Sc)
}

/// creator: zhangjz
/// date:2018-09-01
/// description: 查询工作量，按项目，按人   
/// table: DHCINM.Work.MgNurWorkReport
/// input:
/// output:66，2，43，35
/// other: d ##class(%ResultSet).RunQuery("web.INMStatComm","GetWorkRpByDep","2018-04-01^2018-04-30^^Nurse")
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
        ;s ItmRw=""  f  s ItmRw=$O(^CF.DHCINM.DB.WorkLoadItmI("TYP"," W",ItmRw)) q:ItmRw=""  d
        f Date=StDate:1:EndDate d
        .s Rw=""  f  s Rw=$O(^DHCINM.Work.MgNurWorkReportI("StDate",Date,Rw)) q:Rw=""  d
        ..s Obj=##class(DHCINM.Work.MgNurWorkReport).%OpenId(Rw)
        ..s WorkDepDr=Obj.WorkDepDr
        ..q:$O(^CF.DHCINM.DB.WorkLoadDepSetI("Dep"," "_WorkDepDr,""))=""
        ..s WorkDepDes=""
        ..;i WorkDepDr'="" s WorkDepDes=$P($g(^CTLOC(WorkDepDr)),"^",2)
        ..;s WardId=$O(^CF.DHCINM.DB.MgWardI("CTLoc",WorkDepDr,""))
        ..s WardId=WorkDepDr
        ..i ((WardId'=ParWardId)&&(ParWardId'="")) q
        ..s WardDesc=""
        ..i WardId'="" s WardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(WardId)),4)
        ..s RpSubId=""  f  s RpSubId=$O(^DHCINM.Work.MgNurWorkReportD(Rw,"ChildSub",RpSubId)) q:RpSubId=""  d
        ...s Id=Rw_"||"_RpSubId
        ...s SubObj=##class(DHCINM.Work.MgNurWorkRpSub).%OpenId(Id)
        ...s WorkRpSubItmDR=SubObj.WorkRpSubItmDR
        ...s WorkRpSubItmId=WorkRpSubItmDR.%Id()
        ...s WorkRpSubNum=SubObj.WorkRpSubNum
        ...s WorkRpSubCount=SubObj.WorkRpSubCount
        ...s WorkItm(WorkRpSubItmId,"Num")=$G(WorkItm(WorkRpSubItmId,"Num"))+WorkRpSubNum
        ...s WorkItm(WorkRpSubItmId,"Score")=$G(WorkItm(WorkRpSubItmId,"Score"))+WorkRpSubCount
   
        s ItmId="" f  s ItmId=$O(WorkItm(ItmId)) q:ItmId=""  d
        .s WorkItmDesc=$lg($g(^CF.DHCINM.DB.WorkLoadItmD(ItmId)),2)
        .s WorkRpNum=WorkItm(ItmId,"Num")
        .s WorkRpCount=WorkItm(ItmId,"Score")
        .d out1
    }
    elseif Param="Nurse" 
    {
        ;s ItmRw=""  f  s ItmRw=$O(^CF.DHCINM.DB.WorkLoadItmI("TYP"," W",ItmRw)) q:ItmRw=""  d
        f Date=StDate:1:EndDate d
        .s Rw=""  f  s Rw=$O(^DHCINM.Work.MgNurWorkReportI("StDate",Date,Rw)) q:Rw=""  d
        ..s Obj=##class(DHCINM.Work.MgNurWorkReport).%OpenId(Rw)
        ..s WorkDepDr=Obj.WorkDepDr
        ..s WorkDepDes=""
        ..;i WorkDepDr'="" s WorkDepDes=$P($g(^CTLOC(WorkDepDr)),"^",2)
        ..;s WardId=$O(^CF.DHCINM.DB.MgWardI("CTLoc",WorkDepDr,""))
        ..s WardId=WorkDepDr
        ..i ((WardId'=ParWardId)&&(ParWardId'="")) q
        ..s WardDesc=""
        ..i WardId'="" s WardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(WardId)),4)
        ..s RpSubId=""  f  s RpSubId=$O(^DHCINM.Work.MgNurWorkReportD(Rw,"ChildSub",RpSubId)) q:RpSubId=""  d
        ...s Id=Rw_"||"_RpSubId
        ...s SubObj=##class(DHCINM.Work.MgNurWorkRpSub).%OpenId(Id)
        ...s WorkRpSubItmDR=SubObj.WorkRpSubItmDR
        ...s WorkRpSubItmId=WorkRpSubItmDR.%Id()
        ...s WorkRpSubNum=SubObj.WorkRpSubNum
        ...s WorkRpSubCount=SubObj.WorkRpSubCount
        ...s WorkRpSubExNurDr=SubObj.WorkRpSubExNurDr
        ...i WorkRpSubExNurDr="" q
        ...s WorkItm(WorkRpSubExNurDr,"Num")=$G(WorkItm(WorkRpSubExNurDr,"Num"))+WorkRpSubNum
        ...s WorkItm(WorkRpSubExNurDr,"Score")=$G(WorkItm(WorkRpSubExNurDr,"Score"))+WorkRpSubCount
   
        s PersonsId="" f  s PersonsId=$O(WorkItm(PersonsId)) q:PersonsId=""  d
        .s PerName=$lg($g(^CF.DHCINM.HR.PersonsD(PersonsId)),2)
        .s WorkRpNum=WorkItm(PersonsId,"Num")
        .s WorkRpCount=WorkItm(PersonsId,"Score")
        .d out2
    }
    elseif Param="NurItm" 
    {
        f Date=StDate:1:EndDate d
        .s Rw=""  f  s Rw=$O(^DHCINM.Work.MgNurWorkReportI("StDate",Date,Rw)) q:Rw=""  d
        ..s Obj=##class(DHCINM.Work.MgNurWorkReport).%OpenId(Rw)
        ..s WorkDepDr=Obj.WorkDepDr
        ..s WorkDepDes=""
        ..s WardId=WorkDepDr
        ..i ((WardId'=ParWardId)&&(ParWardId'="")) q
        ..s WardDesc=""
        ..i WardId'="" s WardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(WardId)),4)
        ..s RpSubId=""  f  s RpSubId=$O(^DHCINM.Work.MgNurWorkReportD(Rw,"ChildSub",RpSubId)) q:RpSubId=""  d
        ...s Id=Rw_"||"_RpSubId
        ...s SubObj=##class(DHCINM.Work.MgNurWorkRpSub).%OpenId(Id)
        ...s WorkRpSubItmDR=SubObj.WorkRpSubItmDR
        ...s WorkRpSubItmId=WorkRpSubItmDR.%Id()
        ...s WorkRpSubNum=SubObj.WorkRpSubNum
        ...s WorkRpSubCount=SubObj.WorkRpSubCount
        ...s WorkRpSubExNurDr=SubObj.WorkRpSubExNurDr
        ...i WorkRpSubExNurDr="" q
        ...s WorkItm(WorkRpSubExNurDr,WorkRpSubItmId,"Num")=$G(WorkItm(WorkRpSubExNurDr,WorkRpSubItmId,"Num"))+WorkRpSubNum
        ...s WorkItm(WorkRpSubExNurDr,WorkRpSubItmId,"Score")=$G(WorkItm(WorkRpSubExNurDr,WorkRpSubItmId,"Score"))+WorkRpSubCount
   
        s PersonsId="" f  s PersonsId=$O(WorkItm(PersonsId)) q:PersonsId=""  d
        .s PerName=$lg($g(^CF.DHCINM.HR.PersonsD(PersonsId)),2)
        .s Ret="PerName|"_PerName
        .s WorkItmId="" f  s WorkItmId=$O(WorkItm(PersonsId,WorkItmId)) q:WorkItmId=""  d
        ..s WorkItmDesc=$lg($g(^CF.DHCINM.DB.WorkLoadItmD(WorkItmId)),2)
        ..s WorkRpNum=WorkItm(PersonsId,WorkItmId,"Num")
        ..s WorkRpCount=WorkItm(PersonsId,WorkItmId,"Score")
        ..s Ret=Ret_"^WorkRpNum"_WorkItmId_"|"_WorkRpNum_"^WorkRpCount"_WorkItmId_"|"_WorkRpCount
        .d out3
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
out3
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
/// table: DHCINM.Work.MgNurWardMonRp
/// input:
/// output:66，2，43，35
/// other: d ##class(%ResultSet).RunQuery("web.INMStatComm","GetWardMonRp","66^Count^1^3,6,9")
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
	    .s WardMonRpId=""  f  s WardMonRpId=$O(^DHCINM.Work.MgNurWardMonRpI("WorkRp",WorkRpId,WardMonRpId)) q:WardMonRpId=""  d
	    ..s WorkDepDr=$list(^DHCINM.Work.MgNurWardMonRpD(WardMonRpId),2)
	    ..i ((WorkDepDr'=ParWardId)&&(WorkDepDr'="")) q
	    ..s SubPerId=""  f  s SubPerId=$O(^DHCINM.Work.MgNurWardMonRpD(WardMonRpId,"ChildRpSub",SubPerId)) q:SubPerId=""  d
	    ...s Id=WardMonRpId_"||"_SubPerId
	    ...s SubPerObj=##class(DHCINM.Work.MgNurWardMonSubPer).%OpenId(Id)
	    ...s WorkRpSubItmDR=SubPerObj.WorkRpSubItmDR
        ...s WorkItmId=WorkRpSubItmDR.%Id()
        ...i WorkItm'=WorkItmId q
        ...s WorkRpSubCount=SubPerObj.WorkRpSubCount
	    ...s WorkRpSubExNurDr=SubPerObj.WorkRpSubExNurDr
	    ...s WorkItmCount(WorkRpSubExNurDr,WorkItm)=$G(WorkItmCount(WorkRpSubExNurDr,WorkItm))+WorkRpSubCount
	    
	    
	    s PerId="" f  s PerId=$O(WorkItmCount(PerId)) q:PerId=""  d
	    .s PerName=$lg($g(^CF.DHCINM.HR.PersonsD(PerId)),2)
	    .s Ret="PerName|"_PerName
	    .s AllCount=0
	    .s WorkItmId="" f  s WorkItmId=$O(WorkItmCount(PerId,WorkItmId)) q:WorkItmId=""  d
        ..s WorkItmDesc=$lg($g(^CF.DHCINM.DB.WorkLoadItmD(WorkItmId)),2)
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
	    .s WardMonRpId=""  f  s WardMonRpId=$O(^DHCINM.Work.MgNurWardMonRpI("WorkRp",WorkRpId,WardMonRpId)) q:WardMonRpId=""  d
	    ..s WorkDepDr=$list(^DHCINM.Work.MgNurWardMonRpD(WardMonRpId),2)
	    ..i ((WorkDepDr'=ParWardId)&&(WorkDepDr'="")) q
	    ..s SubPerId=""  f  s SubPerId=$O(^DHCINM.Work.MgNurWardMonRpD(WardMonRpId,"ChildRpSub",SubPerId)) q:SubPerId=""  d
	    ...s Id=WardMonRpId_"||"_SubPerId
	    ...s SubPerObj=##class(DHCINM.Work.MgNurWardMonSubPer).%OpenId(Id)
	    ...s WorkRpSubItmDR=SubPerObj.WorkRpSubItmDR
        ...s WorkItmId=WorkRpSubItmDR.%Id()
        ...i WorkItm'=WorkItmId q
        ...s WorkRpSubNum=SubPerObj.WorkRpSubNum
	    ...s WorkRpSubExNurDr=SubPerObj.WorkRpSubExNurDr
	    ...s WorkItmNum(WorkRpSubExNurDr,WorkItm)=$G(WorkItmNum(WorkRpSubExNurDr,WorkItm))+WorkRpSubNum
	    
	    s PerId="" f  s PerId=$O(WorkItmNum(PerId)) q:PerId=""  d
	    .s PerName=$lg($g(^CF.DHCINM.HR.PersonsD(PerId)),2)
	    .s Ret="PerName|"_PerName
	    .s AllNum=0
	    .s WorkItmId="" f  s WorkItmId=$O(WorkItmNum(PerId,WorkItmId)) q:WorkItmId=""  d
        ..s WorkItmDesc=$lg($g(^CF.DHCINM.DB.WorkLoadItmD(WorkItmId)),2)
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
/// table: DHCINM.Work.MgNurWardMonRp
/// input:
/// output:66，2，43，35
/// other: d ##class(%ResultSet).RunQuery("web.INMStatComm","AnalyseWardMonRp","Count^1^3,6,9")
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
	    .s WardMonRpId=""  f  s WardMonRpId=$O(^DHCINM.Work.MgNurWardMonRpI("WorkRp",WorkRpId,WardMonRpId)) q:WardMonRpId=""  d
	    ..s WorkDepDr=$list(^DHCINM.Work.MgNurWardMonRpD(WardMonRpId),2)
	    ..s SubPerId=""  f  s SubPerId=$O(^DHCINM.Work.MgNurWardMonRpD(WardMonRpId,"ChildRpSub",SubPerId)) q:SubPerId=""  d
	    ...s Id=WardMonRpId_"||"_SubPerId
	    ...s SubPerObj=##class(DHCINM.Work.MgNurWardMonSubPer).%OpenId(Id)
	    ...s WorkRpSubItmDR=SubPerObj.WorkRpSubItmDR
        ...s WorkItmId=WorkRpSubItmDR.%Id()
        ...i WorkItm'=WorkItmId q
        ...s WorkRpSubCount=SubPerObj.WorkRpSubCount
	    ...s WorkItmCount(WorkDepDr,WorkItm)=$G(WorkItmCount(WorkDepDr,WorkItm))+WorkRpSubCount
	    
	    s DepId="" f  s DepId=$O(WorkItmCount(DepId)) q:DepId=""  d
	    .s WardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(DepId)),4)
	    .s Ret="WardDesc|"_WardDesc
	    .s AllCount=0
	    .s WorkItmId="" f  s WorkItmId=$O(WorkItmCount(DepId,WorkItmId)) q:WorkItmId=""  d
        ..s WorkItmDesc=$lg($g(^CF.DHCINM.DB.WorkLoadItmD(WorkItmId)),2)
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
	    .s WardMonRpId=""  f  s WardMonRpId=$O(^DHCINM.Work.MgNurWardMonRpI("WorkRp",WorkRpId,WardMonRpId)) q:WardMonRpId=""  d
	    ..s WorkDepDr=$list(^DHCINM.Work.MgNurWardMonRpD(WardMonRpId),2)
	    ..s SubPerId=""  f  s SubPerId=$O(^DHCINM.Work.MgNurWardMonRpD(WardMonRpId,"ChildRpSub",SubPerId)) q:SubPerId=""  d
	    ...s Id=WardMonRpId_"||"_SubPerId
	    ...s SubPerObj=##class(DHCINM.Work.MgNurWardMonSubPer).%OpenId(Id)
	    ...s WorkRpSubItmDR=SubPerObj.WorkRpSubItmDR
        ...s WorkItmId=WorkRpSubItmDR.%Id()
        ...i WorkItm'=WorkItmId q
        ...s WorkRpSubNum=SubPerObj.WorkRpSubNum
	    ...s WorkItmNum(WorkDepDr,WorkItm)=$G(WorkItmNum(WorkDepDr,WorkItm))+WorkRpSubNum
	    
	    s DepId="" f  s DepId=$O(WorkItmNum(DepId)) q:DepId=""  d
	    .s WardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(DepId)),4)
	    .s Ret="WardDesc|"_WardDesc
	    .s AllNum=0
	    .s WorkItmId="" f  s WorkItmId=$O(WorkItmNum(DepId,WorkItmId)) q:WorkItmId=""  d
        ..s WorkItmDesc=$lg($g(^CF.DHCINM.DB.WorkLoadItmD(WorkItmId)),2)
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
/// table:DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.INMStatComm).GetWorkRp("itmId|6^workRelInstruct|^workRelArcim|9962")
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
       s Obj=##class(CF.DHCINM.DB.WorkLoadItm).%OpenId(ItmId)
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
       s pa=""  f  s pa=$O(^DHCINM.Work.MgNurWardMonRpI("WorkRp",RpId,pa)) q:pa=""  d
       .s loc=$list(^DHCINM.Work.MgNurWardMonRpD(pa),2)
       .s Ret=""
       .s rw=""  f  s rw=$O(^DHCINM.Work.MgNurWardMonRpD(pa,"ChildRpWard",rw)) q:rw=""  d
       ..s itm=$list(^DHCINM.Work.MgNurWardMonRpD(pa,"ChildRpWard",rw),2)
       ..q:(WItm'="")&('$D(WorkItm(itm)))
       ..i CountFlag="Y" d
       ...s count=$list(^DHCINM.Work.MgNurWardMonRpD(pa,"ChildRpWard",rw),4)
       ..e  d
       ...s count=$list(^DHCINM.Work.MgNurWardMonRpD(pa,"ChildRpWard",rw),3)
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
    s depitm=##class(web.INMStatComm).GetSortDep("W")
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

/// creator: jyc
/// createdate: 2021-04-29
/// description: 工作量病区查询条件
/// table: CF.DHCINM.DB.WorkLoadDepSet
/// input:
/// output:
/// return:
/// other: d ##class(%ResultSet).RunQuery("web.INMStatComm","selWorkLoadDep","0","")
Query selWorkLoadDep(nurseid As %String, input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod selWorkLoadDepExecute(ByRef qHandle As %Binary, nurseid As %String, input As %String = "") As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s Ret="",tmpWard="",isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
    s DepSort="" f  s DepSort=$O(^CF.DHCINM.DB.WorkLoadDepSetI("DepSort",DepSort)) q:DepSort=""  d
    .s RowID="" f  s RowID=$O(^CF.DHCINM.DB.WorkLoadDepSetI("DepSort",DepSort,RowID)) q:RowID=""  d
    ..s Obj=##class(CF.DHCINM.DB.WorkLoadDepSet).%OpenId(RowID)
    ..i $IsObject(Obj) d
    ...s WardID=Obj.DepDR
    ...q:(isAll=0)&&('$d(tmpWard(WardID)))
    ...s WardType=""
    ...s MgSysParamSubID="" f  s MgSysParamSubID=$O(^CT.DHCINM.Set.MgSysParamSubD(1,MgSysParamSubID)) q:MgSysParamSubID=""  d
    ....s SubCode=$lg($g(^CT.DHCINM.Set.MgSysParamSubD(1,MgSysParamSubID)),2)
    ....s SubDesc=$lg($g(^CT.DHCINM.Set.MgSysParamSubD(1,MgSysParamSubID)),3)
    ....i SubCode=Obj.Typ  s WardType=SubDesc
    ...s WardSort=Obj.DepSort
    ...s WardDesc="",WardInput=""
    ...s WardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(WardID)
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

ClassMethod selWorkLoadDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = selWorkLoadDepExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod selWorkLoadDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = selWorkLoadDepExecute ]
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

/// creator: wangpf
/// date:2021-06-29
/// description: 生成pda执行率日报数据
/// other: d ##class(web.INMStatComm).GenerateWardPdaReport("2021-06-28","2021-06-28","")
ClassMethod GenerateWardPdaReport(StDate As %String = "", EndDate As %String = "", User As %String = "") As %String
{
    s:StDate["-" StDate=$ZDH(StDate,3)
    s:EndDate["-" EndDate=$ZDH(EndDate,3)
    f Date=StDate:1:EndDate{
		d ..GetNurPdaWorkByExecDate(Date,.tmpWork) 
		d ..DeletePdaWorkDayReport(Date)
        d ..InsertPdaWork(Date,User,.tmpWork)   
	}
    q ""
}

/// creator: wangpf
/// date:2021-06-29
/// description: 生成病房工作量日报Pda数据任务  
/// other: w ##class(web.INMStatComm).GetNurPdaWorkByExecDate(+$h,.tmpWork)
ClassMethod GetNurPdaWorkByExecDate(Date As %String = "", tmpWork As %String = "")
{
	k tmpWork
	s labNoList=""  //标本号数组
	s LongTmpLB=$LB("JMZSD","cqkfyd*")
    s Time=""  f  s Time=$O(^OEORDi(0,"DateExec",Date,Time)) q:Time=""  d
    .s Oew="" f  s Oew=$O(^OEORDi(0,"DateExec",Date,Time,Oew)) q:Oew=""  d
    ..s episodId=$p(^OEORD(Oew),"^",1)
    ..s admType=$p($g(^PAADM(episodId)),"^",2)
    ..q:admType'="I"
    ..s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"DateExec",Date,Time,Oew,OrdSub)) q:OrdSub=""  d
    ...q:$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",39)'=""
    ...s OeoreSub="" f  s OeoreSub=$O(^OEORDi(0,"DateExec",Date,Time,Oew,OrdSub,OeoreSub)) q:OeoreSub=""  d
    ....s PcNum=0,PdaNum=0,PdaManNum=0,NotXNum=0
    ....s PriorityId=$p(^OEORD(Oew,"I",OrdSub,1),"^",8)
	....s TPriorityCode=$p(^OECPR(PriorityId),"^",1) //医嘱类型Code
    ....q:(PriorityId'=3)&&(PriorityId'=5)&&(PriorityId'=6)&&(PriorityId'=8)&&(PriorityId'=29)&&(PriorityId'=30)&&(PriorityId'=1)
    ....s Dep=""
    ....s execDate=$P(^OEORD(Oew,"I",OrdSub,"X",OeoreSub),"^",19)
    ....s execTime=$P(^OEORD(Oew,"I",OrdSub,"X",OeoreSub),"^",20)
    ....s wardId=..getTransWardByDateTime(episodId,execDate,execTime)
    ....i wardId'="" d
    .....s ctLocId=$p($g(^PAWARD(wardId)),"^",5)
    .....q:ctLocId=""
    .....s Dep=$o(^CF.DHCINM.DB.MgWardI("CTLoc",ctLocId,""))
    ....q:Dep=""
    ....s freq=$p($g(^OEORD(Oew,"I",OrdSub,2)),"^",4) //频率
    ....s phcinID=$p($g(^OEORD(Oew,"I",OrdSub,2)),"^",7)  //用法
    ....s specCode=$p($g(^OEORD(Oew,"I",OrdSub,"SPEC",1)),"^") //标本类型
    ....s arcimID=$p($g(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	....s arcicID=$p($g(^ARCIM(+arcimID,$p(arcimID,"||",2),1)),"^",10)
	....i arcicID'="" s arcicID=+arcicID  //子类
	....s labNo=$p($g(^OEORD(Oew,"I",OrdSub,3)),"^",20) //标本号
	....q:(labNo'="")&&(labNoList[labNo)  //如果已经统计过的检验单标本号不再统计
	....s labNoList=labNoList_" "_labNo
	....;s ordflag=..CheckOrderType(phcinID,specCode,arcicID,freq)
	....s ordflag=##class(web.INMHISComm).GetCodeResultByOrdId(Oew,OrdSub,wardId)
    ....s ExecStatusId=$p($g(^OEORD(Oew,"I",OrdSub,"X",OeoreSub)),"^",16)
    ....q:ExecStatusId=2
    ....s PerId=0
    ....i ExecStatusId=1 d
    .....s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",OeoreSub),"^",15)
    .....s:CPTExDR'="" PerId=..GetNurPeridByCTPCP(CPTExDR)
    .....s:PerId="" PerId=0
    .....s flagPda=$p($g(^OEORD(Oew,"I",OrdSub,"X",OeoreSub,"NUR")),"^",26)
    .....i flagPda=2 s TypeStr="Pda"
    .....e  i flagPda=3 s TypeStr="PdaMan"
    .....e  s TypeStr="Pc"
    .....s Prioritype=""
    .....s tmpWork(Dep,PerId,"Z",TypeStr)=$g(tmpWork(Dep,PerId,"Z",TypeStr))+1
    .....i (PriorityId=3)||(PriorityId=6)||(PriorityId=30)||(PriorityId=1) d
    ......s tmpWork(Dep,PerId,"Tmp",TypeStr)=$g(tmpWork(Dep,PerId,"Tmp",TypeStr))+1
    ......s Prioritype="Tmp"
    .....e  i (PriorityId=5)||(PriorityId=8)||(PriorityId=29) d
    ......s tmpWork(Dep,PerId,"Long",TypeStr)=$g(tmpWork(Dep,PerId,"Long",TypeStr))+1
    ......s Prioritype="Long"
    .....i ordflag'=""  d
    ......f ordFlagIndex=1:1:$L(ordflag,",") d
    .......s tordFlag=$P(ordflag,",",ordFlagIndex)
    .......q:tordFlag=""
    .......s:($LF(LongTmpLB,tordFlag)>0) tordFlag=Prioritype_tordFlag
    .......s tmpWork(Dep,PerId,tordFlag,TypeStr)=$g(tmpWork(Dep,PerId,tordFlag,TypeStr))+1
    ....e  d
    .....s Prioritype=""
    .....s tmpWork(Dep,PerId,"Z","NotX")=$g(tmpWork(Dep,PerId,"Z","NotX"))+1
    .....i (PriorityId=3)||(PriorityId=6)||(PriorityId=30)||(PriorityId=1) d
    ......s tmpWork(Dep,PerId,"Tmp","NotX")=$g(tmpWork(Dep,PerId,"Tmp","NotX"))+1
    ......s Prioritype="Tmp"
    .....e  i (PriorityId=5)||(PriorityId=8)||(PriorityId=29) d
    ......s tmpWork(Dep,PerId,"Long","NotX")=$g(tmpWork(Dep,PerId,"Long","NotX"))+1
    ......s Prioritype="Long"
    .....i ordflag'="" d
    ......f ordFlagIndex=1:1:$L(ordflag,",") d
    .......s tordFlag=$P(ordflag,",",ordFlagIndex)
    .......q:tordFlag=""
    .......s:($LF(LongTmpLB,tordFlag)>0) tordFlag=Prioritype_tordFlag
    .......s tmpWork(Dep,PerId,tordFlag,"NotX")=$g(tmpWork(Dep,PerId,tordFlag,"NotX"))+1
    ;病区是否存在医嘱执行，不存在则置pc值为0
    s id="" f  s id=$o(^CF.DHCINM.DB.MgWardD(id)) q:id=""  d
    .s stDate=$lg(^CF.DHCINM.DB.MgWardD(id),11)
    .s endDate=$lg(^CF.DHCINM.DB.MgWardD(id),12)
    .q:(stDate="")||(stDate>+$h)||((endDate'="")&&(endDate<+$h))
    .q:$d(tmpWork(id))
    .s tmpWork(id,0,"Pc")=0
    q 1
}

/// creator: gyg
/// date:2019-12-25
/// description: 删除pda日报
/// table: DHCINM.Work.MgWorkPdaDay
/// input:
/// output:
/// other: w ##class(web.INMStatComm).DeletePdaWorkDayReport("2018-04-12")
ClassMethod DeletePdaWorkDayReport(date As %String = "") As %String
{
    q:date="" ""
    s:date["-" date=$ZDH(date,3)
    s Sc=0
    s Rw=""  f  s Rw=$O(^DHCINM.Work.MgWorkPdaDayI("Date",date,Rw)) q:Rw=""  d
    .s Obj=##class(DHCINM.Work.MgWorkPdaDay).%OpenId(Rw)
    .s subID="" f  s subID=$O(^DHCINM.Work.MgWorkPdaDaySubD(Rw,subID)) q:subID=""  d
    ..s subObj=##class(DHCINM.Work.MgWorkPdaDaySub).%OpenId(Rw_"||"_subID)
    ..q:$IsObject(subObj) 
    ..d subObj.%DeleteId(Rw_"||"_subID)
    .i '$IsObject(Obj) q
    .s Sc=Obj.%DeleteId(Rw)
    q $$$ISOK(Sc)
}

/// creator: wangpf
/// date:2021-06-29
/// description: 生成pda日报
/// other: w ##class(web.INMStatComm).InsertPdaWork()
ClassMethod InsertPdaWork(Date As %String = "", User As %String = "", NurPdaWork As %String = "") As %String
{
     s dep="" f  s dep=$o(NurPdaWork(dep)) q:dep=""  d
     .s perid="" f  s perid=$o(NurPdaWork(dep,perid)) q:perid=""  d
     ..s PdaObj=##class(DHCINM.Work.MgWorkPdaDay).%New()
     ..d PdaObj.WorkWardSetObjectId(dep)
     ..s PdaObj.WorkDate=Date
     ..d PdaObj.WorkNurseSetObjectId(perid)
     ..s PdaObj.WorkCreateUser=User
     ..d PdaObj.%Save()
     ..s type="" f  s type=$O(NurPdaWork(dep,perid,type)) q:type=""  d
     ...s subObj=##class(DHCINM.Work.MgWorkPdaDaySub).%New()
     ...s subObj.Paref=PdaObj
     ...s subObj.SubType=type
     ...s subObj.Pc=$g(NurPdaWork(dep,perid,type,"Pc"))
     ...s subObj.Pda=$g(NurPdaWork(dep,perid,type,"Pda"))
     ...s subObj.PdaMan=$g(NurPdaWork(dep,perid,type,"PdaMan"))
     ...s subObj.NotX=$g(NurPdaWork(dep,perid,type,"NotX"))
     ...d subObj.%Save()
     q 0
}

/// Creator:lulin
/// Description:获取pda执行率列头
/// Date:2021-12-01
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others:d ##class(web.INMStatComm).GetColumnData()
ClassMethod GetColumnData() As %String
{
#;	s KeyLB=$LB("Z","Long","CQSYD","cqkfyd","CQZSD","CQZLD","Tmp","CGJYD","JCJYD"
#;    ,"SYD","ZSD","JMZSD","cqkfyd*","JYD","JMSX","whdxin"
#;    ,"czzldx","qtypdx")
#;    s DescLB=$LB("总执行率","长期医嘱","长期输液单","长期口服药单","长期注射单","长期治疗单","临时医嘱","常规检验单","急查检验单"
#;    ,"临时输液单","临时注射单","静脉注射单","临时口服药单","检验单(只有临时的)","静脉输血","雾化单(长期+临时)"
#;    ,"处置单(长期+临时)","其他药品(长期+临时)")
    s KeyLB=$LB("Z","CQSYD","CQZSD","LongJMZSD","cqkfyd"
    ,"SYD","ZSD","TmpJMZSD","cqkfyd*","JYD","JMSX","whdxin"
    ,"qtypdx")
    s DescLB=$LB("总执行率","长期输液单","长期注射单","长期静脉注射单","长期口服药单"
    ,"临时输液单","临时注射单","临时静脉注射单","临时口服药单","检验单(只有临时的)","静脉输血","雾化单(长期+临时)"
    ,"其他药品(长期+临时)")
    w "["
    f i=1:1:$LL(KeyLB) d
    .w:i'=1 ","
    .w "{""prop"":"""_$LG(KeyLB,i)_""",""label"":"""_$LG(DescLB,i)_"""}"
    w "]"
    q ""
}

/// Creator:lulin
/// Description:获取pda执行率子列头
/// Date:2021-12-01
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others:d ##class(web.INMStatComm).GetColumnSub()
ClassMethod GetColumnSub() As %String
{
    s KeyLB=$LB("PdaTR","PdaR","PdaManR","PcR","NotXR")
    s DescLB=$LB("PDA执行率","PDA","PDA手工","PC","未执行")
    w "["
    f i=1:1:$LL(KeyLB) d
    .w:i'=1 ","
    .w "{""prop"":"""_$LG(KeyLB,i)_""",""label"":"""_$LG(DescLB,i)_"""}"
    w "]"
    q ""
}

/// creator: wangpf
/// other: d ##class(%ResultSet).RunQuery("web.INMStatComm","FindPdaWork","1^2021-06-28^2021-06-28",0)
Query FindPdaWork(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPdaWorkExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s ward=$P(parr,"^",1)
    s stDate=$P(parr,"^",2)
    s:stDate["-" stDate=$zdh(stDate,3)
    s endDate=$P(parr,"^",3)
    s:endDate["-" endDate=$zdh(endDate,3)
    s selectRadio=$P(parr,"^",4)
    i (nurseid="")||(+stDate=0)||(endDate=0) Set qHandle=$lb(0,repid,0) Quit $$$OK
    k tmpWard
    s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
    k tmp
    s columnDataKey=$LB("Z","Long","CQSYD","Longcqkfyd*","Tmpcqkfyd*","CQZSD","CQZLD","Tmp" ;,"CGJYD","JCJYD"
    ,"SYD","ZSD","LongJMZSD","TmpJMZSD","cqkfyd*","JYD","JMSX","whdxin"
    ,"czzldx","qtypdx")
    f date=stDate:1:endDate d
    .s rw=""  f  s rw=$O(^DHCINM.Work.MgWorkPdaDayI("Date",date,rw)) q:rw=""  d
    ..s PdaObj=##class(DHCINM.Work.MgWorkPdaDay).%OpenId(rw)
    ..q:'$IsObject(PdaObj)
    ..s wardId=PdaObj.WorkWard.%Id()
    ..q:(ward'="")&&(ward'=wardId)
    ..q:(isAll'=1)&&('$d(tmpWard(wardId)))
    ..s sort=$lg(^CF.DHCINM.DB.MgWardD(wardId),16)
    ..s:sort="" sort=9999
    ..s subId="" f  s subId=$O(^DHCINM.Work.MgWorkPdaDaySubD(rw,subId)) q:subId=""  d
    ...s subObj=##class(DHCINM.Work.MgWorkPdaDaySub).%OpenId(rw_"||"_subId)
    ...q:'$IsObject(subObj)
    ...s subType=subObj.SubType
    ...q:subType=""
    ...i selectRadio="Nurse" d
    ....s PerID="other"
    ....s:$IsObject(PdaObj.WorkNurse) PerID=PdaObj.WorkNurse.%Id()
    ....s tmp(sort,wardId,PerID,subType)=$g(tmp(sort,wardId,PerID,subType))+subObj.Pc+subObj.Pda+subObj.PdaMan+subObj.NotX
    ....s tmp(sort,wardId,PerID,subType,"Pc")=$g(tmp(sort,wardId,PerID,subType,"Pc"))+subObj.Pc
    ....s tmp(sort,wardId,PerID,subType,"Pda")=$g(tmp(sort,wardId,PerID,subType,"Pda"))+subObj.Pda
    ....s tmp(sort,wardId,PerID,subType,"PdaMan")=$g(tmp(sort,wardId,PerID,subType,"PdaMan"))+subObj.PdaMan
    ....s tmp(sort,wardId,PerID,subType,"NotX")=$g(tmp(sort,wardId,PerID,subType,"NotX"))+subObj.NotX
    ....s tmp(0,0,0,subType,"Pc")=$g(tmp(0,0,0,subType,"Pc"))+subObj.Pc
    ....s tmp(0,0,0,subType,"Pda")=$g(tmp(0,0,0,subType,"Pda"))+subObj.Pda
    ....s tmp(0,0,0,subType,"PdaMan")=$g(tmp(0,0,0,subType,"PdaMan"))+subObj.PdaMan
    ....s tmp(0,0,0,subType,"NotX")=$g(tmp(0,0,0,subType,"NotX"))+subObj.NotX
    ....s tmp(0,0,0,subType)=$g(tmp(0,0,0,subType))+subObj.Pc+subObj.Pda+subObj.PdaMan+subObj.NotX
    ...e  d
    ....s tmp(sort,wardId,subType)=$g(tmp(sort,wardId,subType))+subObj.Pc+subObj.Pda+subObj.PdaMan+subObj.NotX
    ....s tmp(sort,wardId,subType,"Pc")=$g(tmp(sort,wardId,subType,"Pc"))+subObj.Pc
    ....s tmp(sort,wardId,subType,"Pda")=$g(tmp(sort,wardId,subType,"Pda"))+subObj.Pda
    ....s tmp(sort,wardId,subType,"PdaMan")=$g(tmp(sort,wardId,subType,"PdaMan"))+subObj.PdaMan
    ....s tmp(sort,wardId,subType,"NotX")=$g(tmp(sort,wardId,subType,"NotX"))+subObj.NotX
    ....s tmp(0,0,subType,"Pc")=$g(tmp(0,0,subType,"Pc"))+subObj.Pc
    ....s tmp(0,0,subType,"Pda")=$g(tmp(0,0,subType,"Pda"))+subObj.Pda
    ....s tmp(0,0,subType,"PdaMan")=$g(tmp(0,0,subType,"PdaMan"))+subObj.PdaMan
    ....s tmp(0,0,subType,"NotX")=$g(tmp(0,0,subType,"NotX"))+subObj.NotX
    ....s tmp(0,0,subType)=$g(tmp(0,0,subType))+subObj.Pc+subObj.Pda+subObj.PdaMan+subObj.NotX
    s sort="" f  s sort=$o(tmp(sort)) q:sort=""  d
    .s wardId="" f  s wardId=$o(tmp(sort,wardId)) q:wardId=""  d
    ..i wardId=0 s wardDesc="总计"
    ..e  s wardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(wardId)),4)
    ..s Ret="WardId|"_wardId_"^WardDesc|"_wardDesc
    ..i selectRadio="Nurse" d
	...s PerID="" f  s PerID=$o(tmp(sort,wardId,PerID)) q:PerID=""  d
	....i PerID=0 s PerName=""
    ....e  s PerName=$lg($g(^CF.DHCINM.HR.PersonsD(wardId)),2)
    ....s Ret=Ret_"^PerName|"_PerName
    ....f i=1:1:$LL(columnDataKey) d
    .....s subType=$LG(columnDataKey,i)
    .....q:subType=""
    .....s pdaTR="无效值",pdaR=0,pcR=0,notXR=0,pdaManR=0
    .....s countNum=$g(tmp(sort,wardId,PerID,subType))
    .....s pcNum=$g(tmp(sort,wardId,PerID,subType,"Pc"))
    .....s pdaNum=$g(tmp(sort,wardId,PerID,subType,"Pda"))
    .....s pdaManNum=$g(tmp(sort,wardId,PerID,subType,"PdaMan"))
    .....s notXNum=$g(tmp(sort,wardId,PerID,subType,"NotX"))
    .....d Cal
    ....d out
    ..e  d
    ...f i=1:1:$LL(columnDataKey) d
    ....s subType=$LG(columnDataKey,i)
    ....q:subType=""
    ....s pdaTR="无效值",pdaR=0,pcR=0,notXR=0,pdaManR=0
    ....s countNum=$g(tmp(sort,wardId,subType))
    ....s pcNum=$g(tmp(sort,wardId,subType,"Pc"))
    ....s pdaNum=$g(tmp(sort,wardId,subType,"Pda"))
    ....s pdaManNum=$g(tmp(sort,wardId,subType,"PdaMan"))
    ....s notXNum=$g(tmp(sort,wardId,subType,"NotX"))
    ....d Cal
    ...d out
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
Cal 
	i countNum>0 d
    .s pdaTR=$fn((pdaNum+pdaManNum)/countNum*100,"",2)_"%"
    .s pdaR=pdaNum
    .s pdaManR=pdaManNum
    .s pcR=pcNum
    .s notXR=notXNum
    s Ret=Ret_"^"_subType_"PdaTR|"_pdaTR_"^"_subType_"PdaR|"_pdaR_"^"_subType_"PdaManR|"_pdaManR_"^"_subType_"PcR|"_pcR_"^"_subType_"NotXR|"_notXR
    q
out
    set Data=$lb(Ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindPdaWorkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPdaWorkExecute ]
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

ClassMethod FindPdaWorkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPdaWorkExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator: 		gyg
/// CreatDate: 		2020-0430
/// Description: 	判断执行医嘱属于哪种医嘱类型  1 ;输液单 2 口服单 3 检验单
/// Input：			
/// Return：		
/// Other    w ##class(web.INMStatComm).CheckOrderType("","U010","13534",43)
/// Update 
ClassMethod CheckOrderType(insturt As %String = "", specimen As %String = "", catgory As %String = "", freq As %String = "") As %String
{
	s flag="" //1 ;输液单 2 口服单 3 检验单
	;s temp="CQSYD,cqkfyd,CGJYD,CQZSD,CQZLD,JCJYD,JMZSD,SYD,ZSD,ZSD,cqkfyd*,JYD,whdxin,JMSX,czzldx,qtypdx" //三种单据类型
	s temp="CQSYD,CQZSD,JMZSD,SYD,ZSD,cqkfyd*,JYD,JMSX,whdxin,qtypdx"
	s length=$L(temp,",")
	f i=1:1:length d
	.s sheetCode=$P(temp,",",i)
	.s sheetID=$o(^Nur.NurseSheetSetI("CODE"," 0"," "_$zcvt(sheetCode,"u"),""))
	.s sheetSettingObject=##class(Nur.NurseSheetSet).%OpenId(sheetID)
	.q:'$IsObject(sheetSettingObject) 
	.s ins=sheetSettingObject.ordPhcin ///取用法
	.s spec=sheetSettingObject.specCode ///取标本类型
	.s cat=sheetSettingObject.ordCat ///取医嘱子类
	.;///长期输液单判断 口服药输液标本类型为空
	.i (spec="") d  //标本类型有可能为空
	..i (("^"_cat_"^")[("^"_catgory_"^"))&&(("^"_ins_"^")[("^"_insturt_"^")) d
	...i flag="" s flag=sheetCode
	...e  s flag=flag_","_sheetCode
	.e  d
	..i (("^"_cat_"^")[("^"_catgory_"^"))&&(("^"_spec_"^")[("^"_specimen_"^")) d
	...i flag="" s flag=sheetCode
	...e  s flag=flag_","_sheetCode
	q flag
}

ClassMethod getTransWardByDateTime(episodId, date, time) As %String
{
	  	;New (episodId,date,time)
 	Quit:(episodId="")||(date="")||(time="") ""
 	Set:date["-" date=$zdh(date,3)
 	if ((time[":")&&($L(time,":")=2)) {
 		s time=time_":00"	
 	}
 	Set:time[":" time=$zth(time)
 	Kill rtnData
 	Quit:episodId="" ""
 	Quit:$g(^PAADM(episodId))="" ""
 	Set tranWardNum=0
 	Set visitStatus=$p(^PAADM(episodId),"^",20)
 	Set lastWardid="",staDate="",staTime=""
 	Set chl="" For  Set chl=$O(^PAADM(episodId,"TRANS",chl)) Quit:chl=""  Do
 	.;Set transTypeDR=$P(^PAADM(episodId,"TRANS",chl),"^",21)
 	.;Set transTypeCode=""
 	.;If transTypeDR'="" Set transTypeCode=$P($G(^PAC("TRANSTYP",transTypeDR)),"^",1)
 	.;Quit:transTypeCode="M"
 	.Set wardId=$P(^PAADM(episodId,"TRANS",chl),"^",9)
 	.;If wardId="" Set wardId=lastWardid
 	.Quit:wardId=""
 	.Quit:$P(^PAADM(episodId,"TRANS",chl),"^",8)="" ;床为空
 	.If (lastWardid'="")&&(wardId'=lastWardid) Do
 	..Set lastWardid=wardId,tranWardNum=tranWardNum+1
 	..Set staDate=$P(^PAADM(episodId,"TRANS",chl),"^",1)
 	..Set staTime=$P(^PAADM(episodId,"TRANS",chl),"^",2)  
 	.If lastWardid="" Do
 	..Set lastWardid=wardId,tranWardNum=tranWardNum+1 
 	..Set staDate=$P(^PAADM(episodId),"^",6) //首次取就诊时间
 	..Set staTime= $P(^PAADM(episodId),"^",7)
  	.Set endDate=$P(^PAADM(episodId,"TRANS",chl),"^",3)
    .Set endTime=$P(^PAADM(episodId,"TRANS",chl),"^",4)
 	.Set rtnData(tranWardNum)=wardId_"^"_staDate_"^"_staTime_"^"_endDate_"^"_endTime
 		//出院取出院时间
 	If $g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc"))'="Y" Do
 	.Set disDate=$P($G(^PAADM(episodId,"DHC")),"^",29)
 	.Set disTime=$P($G(^PAADM(episodId,"DHC")),"^",30)
 	Else  Do
 	.Set disDate=$p(^PAADM(episodId),"^",17) 
 	.Set disTime=$p(^PAADM(episodId),"^",18) 
 	Set ret="" 
 	Set dateTime=date*86400+time
	Set staDate="",staTime="",endDate="",endTime=""
 	Set Num="" For  Set Num=$O(rtnData(Num)) Quit:(Num="")||(ret'="")  Do
 	.Set wardId=$P(rtnData(Num),"^",1)
 	.Set staDate=$P(rtnData(Num),"^",2)
 	.Set staTime=$P(rtnData(Num),"^",3)
 	.Set endDate=$P(rtnData(Num),"^",4)
 	.Set endTime=$P(rtnData(Num),"^",5)
 	.If (tranWardNum=Num)&&(visitStatus="D") Do 
 	..Set endDate=disDate
 	..Set endTime=disTime
 	.If (endDate="") Set endDate=+$h
 	.If (endTime="") Set endTime=$P($h,",",2)
 	.Set staDateTime=staDate*86400+staTime
 	.Set endDateTime=endDate*86400+endTime
 	.Quit:(dateTime<staDateTime)||(dateTime>endDateTime)
 	.Set wardDesc=$p($g(^PAWARD(wardId)),"^",2)
 	.;Set ret=wardId_"^"_wardDesc
 	.Set ret=wardId
 	Quit ret
}

/// 清工作量数据
/// d ##class(web.INMStatComm).ClearWorkData()
ClassMethod ClearWorkData() As %String
{
	k ^DHCINM.Work.MgNurWardMonRpI
	k ^DHCINM.Work.MgNurWardMonRpD
	k ^DHCINM.Work.MgNurWardMonSubI
	k ^DHCINM.Work.MgNurWardMonSubD
	k ^DHCINM.Work.MgNurWardMonSubItmI
	k ^DHCINM.Work.MgNurWardMonSubItmD
	k ^DHCINM.Work.MgNurWardMonSubPerI
	k ^DHCINM.Work.MgNurWardMonSubPerD
	k ^DHCINM.Work.MgNurWorkReportI
	k ^DHCINM.Work.MgNurWorkReportD
	k ^DHCINM.Work.MgNurWorkRpI
	k ^DHCINM.Work.MgNurWorkRpD
	k ^DHCINM.Work.MgNurWorkRpSubI
	k ^DHCINM.Work.MgNurWorkRpSubD
	k ^DHCINM.Work.MgNurWorkRpSubItmDataI
	k ^DHCINM.Work.MgNurWorkRpSubItmDataD
	k ^DHCINM.Work.MgNurWorkRpWardI
	k ^DHCINM.Work.MgNurWorkRpWardD
	q 0
}

/// creator: zhangjz
/// date:2018-08-03
/// description: 获取工作量项目列表
/// table: CF.DHCINM.DB.WorkLoadItm
/// input:
/// output:
/// other: w ##class(web.INMStatComm).GetWorkLoadItm(1)
ClassMethod GetWorkLoadItm(id As %String) As %String
{
    ;s ^TMP("GetWorkLoadItm")=id
    q:id="" ""
    s Obj=##class(CF.DHCINM.DB.WorkLoadItm).%OpenId(id)
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
    i Obj.StartDate'="" s Ret=Ret_"^StartDate|"_##class(web.INMHISComm).DateLogicalToHtml(Obj.StartDate)
    i Obj.EndDate'="" s Ret=Ret_"^EndDate|"_##class(web.INMHISComm).DateLogicalToHtml(Obj.EndDate)
    q Ret
}

}
