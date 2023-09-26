Import sqluser

/// Descript:单号生成规则维护
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-06
/// wangjiabin 2013-09-06 将web.DHCST.DHCStkSysCounter改为公用
Class web.DHCST.Common.DHCStkSysCounter Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter TableName [ Final ] = "DHC_StkSysCounter";

/// Descript:   保存/更新单号生成规则
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-06
/// Table:DHC_StkSysCounter
/// Input:数据串:rowid^应用程序id^医院标志^科室标志^类组标志^单号前缀^年^月^日^序号长度,
/// rowid^应用程序id^医院标志^科室标志^类组标志^单号前缀^年^月^日^序号长度
/// Output:     
/// Return："" – 成功，
/// 非空：失败
ClassMethod Save(ListData As %String, Hosp) As %Library.String
{
    n (ListData,Hosp)
    ;s ^zdm("web.DHCST.DHCStkSysCounter.Save")=ListData
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s Len=$l(ListData,rowDelim)
    s Msg=0
    s Err=""
    f i=1:1:Len  d
    .s Data=$p(ListData,rowDelim,i)
    .s Rowid=$p(Data,"^",1)
    .s AppId=$p(Data,"^",2)
    .q:AppId=""
    .s AppDesc=$p(^DHCSSA(AppId),"^",2)
	.i Rowid="" s Rowid=..GetSSC(AppId,Hosp)
    .s DataStr=$p(Data,"^",3,$l(Data,"^"))
    .;b ;1
    .i Rowid'=""  d
    ..s ret=..Update(Rowid,DataStr)
    ..s:ret'=0 Err=Err_","_AppDesc
    .e  d
    ..s ret=..Insert(AppId,DataStr)
	..i +ret>0 s Rowid=ret
    ..i +ret>0 
    ..s:ret="" Err=Err_","_AppDesc
    .d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#TableName, Rowid, Hosp)
    .;b ;2
    q Err
}

/// Descript:   增加单号生成规则
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-06
/// Table:DHC_StkSysCounter
/// Input:应用程序id,医院标志^科室标志^类组标志^单号前缀^年^月^日^序号长度
/// Output:     
/// Return：rowid
ClassMethod Insert(AppParref As %String, ListData As %String) As %Library.String [ Private ]
{
    n (AppParref,ListData)
    ;
    ;不能为空项
    q:AppParref="" ""
    q:ListData="" ""
    s Hosp=$p(ListData,"^",1)
    s Loc=$p(ListData,"^",2)
    s CatGrp=$p(ListData,"^",3)
    s Prefix=$p(ListData,"^",4)
    s Year=$p(ListData,"^",5)
    s Month=$p(ListData,"^",6)
    s Day=$p(ListData,"^",7)
    s NoLength=$p(ListData,"^",8)
    ;
    s Chl=$o(^DHCSSA(AppParref,"SSC",""),-1)+1
    &sql(Insert into DHC_StkSysCounter(SSC_SSA_Parref,SSC_ChildSub,SSC_Hosp,SSC_Loc,
    SSC_CatGrp,SSC_Prefix,SSC_Year,SSC_Month,SSC_Day,SSC_NoLength)
    values(:AppParref,:Chl,:Hosp,:Loc,:CatGrp,:Prefix,:Year,:Month,:Day,:NoLength))
    s Err=0
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_StkSysCounter",AppParref,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 ""
    q $p(%ROWID,$c(1))
}

/// Descript:   更新单号生成规则
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-06
/// Table:DHC_StkSysCounter
/// Input:rowid,医院标志^科室标志^类组标志^单号前缀^年^月^日^序号长度
/// Output:     
/// Return：0:成功;非0：失败
ClassMethod Update(Rowid As %String, ListData As %String) As %Library.String [ Private ]
{
    n (Rowid,ListData)
    ;
    ;不能为空项
    q:Rowid="" ""
    s Hosp=$p(ListData,"^",1)
    s Loc=$p(ListData,"^",2)
    s CatGrp=$p(ListData,"^",3)
    s Prefix=$p(ListData,"^",4)
    s Year=$p(ListData,"^",5)
    s Month=$p(ListData,"^",6)
    s Day=$p(ListData,"^",7)
    s NoLength=$p(ListData,"^",8)
    ;
    s Err=0
    &sql(Update DHC_StkSysCounter set SSC_Hosp=:Hosp,SSC_Loc=:Loc,
    SSC_CatGrp=:CatGrp,SSC_Prefix=:Prefix,SSC_Year=:Year,SSC_Month=:Month,SSC_Day=:Day,
    SSC_NoLength=:NoLength where SSC_Rowid=:Rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_StkSysCounter",Rowid,SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

/// Descript:   删除单号生成规则
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-06
/// Table:DHC_StkSysCounter
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String, hosp) As %Library.String
{
    n (rowid,hosp)
    ;
    ;不能为空项
    q:rowid="" ""
    ;
    s Err=0
    &sql(Delete from DHC_StkSysCounter where SSC_Rowid=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_StkSysCounter",rowid,SQLCODE_":"_%msg)
    .s Err=-1
    e  d
    .d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#TableName,rowid,hosp)
    q Err
}

/// Descript:   查询单号规则信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-06
/// Table:DHC_StkSysCounter
/// Input:库存类型(G,M,O)
/// Output:     
/// Return：RowId^应用程序id^应用程序代码^应用程序描述^医院^科室^类组^
/// 单号前缀^年^月^日^单号长度
/// w ##class(web.DHCST.Common.DHCStkSysCounter).SelectAll("G",2)
ClassMethod SelectAll(StkType As %String = "G", HospID)
{
	n (StkType,HospID)
	q:StkType="" ""
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    s AppId=0
    f  s AppId=$o(^DHCSSA(0,"AGTYPE",StkType,AppId)) q:AppId=""  d
    .s AppCode=$p(^DHCSSA(AppId),"^",1)
    .s AppDesc=$p(^DHCSSA(AppId),"^",2)
    .s Rowid=""
    .s Hosp="N"
    .s Loc="N"
    .s CatGrp="N"
    .s Prefix=""
    .s Year="N"
    .s Month="N"
    .s Day="N"
    .s NoLength=""
	.s Rowid=..GetSSC(AppId,HospID)
    .i Rowid'="" d
	..s Chl=$p(Rowid,"||",2)
	..s Hosp=$p(^DHCSSA(AppId,"SSC",Chl),"^",1) 
    ..s Loc=$p(^DHCSSA(AppId,"SSC",Chl),"^",2)
    ..s CatGrp=$p(^DHCSSA(AppId,"SSC",Chl),"^",3)
    ..s Prefix=$p(^DHCSSA(AppId,"SSC",Chl),"^",4)
    ..s Year=$p(^DHCSSA(AppId,"SSC",Chl),"^",5)
    ..s Month=$p(^DHCSSA(AppId,"SSC",Chl),"^",6)
    ..s Day=$p(^DHCSSA(AppId,"SSC",Chl),"^",7)
    ..s NoLength=$p(^DHCSSA(AppId,"SSC",Chl),"^",8)
    ..
    .s Data1=$g(Rowid)_"^"_AppId_"^"_AppCode_"^"_AppDesc_"^"_$g(Hosp)_"^"_$g(Loc)
    .s Data2=$g(CatGrp)_"^"_$g(Prefix)_"^"_$g(Year)_"^"_$g(Month)_"^"_$g(Day)_"^"_$g(NoLength)
    .s Data=Data1_"^"_Data2
    .s count = count+1  
    .   
    .d json.InsertRowData(Data)
    .
    s resultString = json.getJsonData("RowId^AppId^AppCode^AppDesc^Hosp^Loc^CatGrp^Prefix^Year^Month^Day^NoLength",count)
    k json
    Q resultString
}

/// Description: 更新当前单号
/// Creater:    ZhangDongmei
/// CreateDate: 2012-07-30
/// Input:rowid,当前年份,当前月份,当前日期,当前序号
/// Output:
/// Return:0:成功
ClassMethod UpdateCounterNo(AppName As %String, CurrentYear As %String, CurrentMon As %String, CurrentDay As %String, CurrentNo As %String, Hosp)
{
    N (AppName,CurrentYear,CurrentMon,CurrentDay,CurrentNo,Hosp)
    Q:AppName="" -2
    S AppName=$$ALPHAUP^SSUTIL4(AppName)
    S AppId=$O(^DHCSSA(0,"ACODE",AppName,""))
    Q:AppId="" -2
 	s Rowid=..GetSSC(AppId,Hosp)
    s Err=0
    &sql(Update DHC_StkSysCounter set SSC_CurrentYear=:CurrentYear,SSC_CurrentMonth=:CurrentMon,
    SSC_CurrentDay=:CurrentDay,SSC_CurrentNo=:CurrentNo where SSC_Rowid=:Rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("UpdateCounterNo:DHC_StkSysCounter",Rowid,SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

/// 插入科室数据DHC_StkSysCounterLoc
/// Author:zhwh
/// Date:2014-10-15
/// Arg:
///    SSC - RowId of DHC_StkSysCounter
///    LocId -科室RowId
/// Return:
///   0 - success
///   <0 - 失败
ClassMethod InsertCounterLoc(SSC As %String, LocId As %String) As %String
{
  n (SSC,LocId)
  s d=$zd(+$h,3)
  s currentYear=+$p(d,"-",1)
  s currentMonth=+$p(d,"-",2)
  s crrrentDay=+$p(d,"-",3)
  &sql(insert into dhc_stksyscounterLoc(sscloc_ssc_parref,sscloc_ctloc_dr,sscloc_currentyear,
    sscloc_currentmonth,sscloc_currentday)  values (:SSC,:LocId,:currentYear,:currentMonth,:crrrentDay) )
   q SQLCODE
}

/// 更新DHC_StkSysCounterLoc
/// Author:zhwh
/// Date:2014-10-15
/// Arg:
///    SSC - RowId of DHC_StkSysCounter
///    LocId -科室RowId
/// Return:
///    当前序号
ClassMethod GetCounterByLoc(SSC As %String, LocId As %String)
{
  n (SSC,LocId)
  s PreNo=""
  &sql(select sscloc_ssc_parref->ssc_ssa_parref->ssa_code,
   sscloc_currentyear,sscloc_currentmonth,sscloc_currentday,sscloc_currentno
    into :AppName,:CurrentYear,:CurrentMon,:CurrentDay,:CurrentNo 
    from dhc_stksyscounterloc where sscloc_ssc_parref=:SSC and sscloc_ctloc_dr=:LocId)

 S AppName=$$ALPHAUP^SSUTIL4(AppName)
 S ssa=$O(^DHCSSA(0,"ACODE",AppName,""))
 Q:ssa="" ""
 S sscsub=$O(^DHCSSA(ssa,"SSC","0"))
 Q:sscsub="" ""
 S coustr=^DHCSSA(ssa,"SSC",sscsub)
 ;
 s YearFlag=$P(coustr,"^",5)
 s MonthFlag=$P(coustr,"^",6)
 s DayFlag=$P(coustr,"^",7)
 S NoLen=+$P(coustr,"^",8)
 s Today=$zd(+$h,3)
 s Year=$p(Today,"-",1)
 s Month=+$p(Today,"-",2)
 s Day=+$p(Today,"-",3)
 ;b ;1
 ;flag=1,表示CurrentNo即为前一个单号
 ;flag=0,表示目前没有相应的单号记录，新单号需要从1开始记
 s Flag=1   
 i (YearFlag="Y")&(CurrentYear'=Year)  d
 .s Flag=0
 i (MonthFlag="Y")&(CurrentMon'=Month)  d
 .s Flag=0
 i (DayFlag="Y")&(CurrentDay'=Day)  d
 .s Flag=0
 ;
 i Flag=1  d
 .s PreNo=1+CurrentNo
 e  d
 .s PreNo=1
 .
 q PreNo
}

/// 按科室取单号
/// Author:zhwh
/// Date:2014-10-15
/// Arg:
///   AppName - 应用代码
///   LocId - 科室RowId
/// Return:
///    单号字符串
ClassMethod GetAppNoByLoc(AppName As %String, LocId As %String) As %String
{
 n (AppName,LocId)
 s ret=##class(web.DHCST.Common.AppCommon).Lock(AppName_"NO")  
 //&sql(select ssc_rowid,ssc_nolength into :SSC,:noLen from dhc_stksyscounter where  ssc_ssa_parref->ssa_code=:AppName)
 s hosp=$p($g(^CTLOC(+LocId)),"^",22)
 s SSC=..GetSSCByAppCode(AppName,hosp)
 i SSC="" d ulk q ""
 s noLen=$p($g(^DHCSSA(+SSC, "SSC", +$p(SSC,"||",2))),"^",8)
 ;b ;11
 &sql(select %id into :rowid from sqluser.dhc_stksyscounterloc 
   where sscloc_ssc_parref=:SSC and sscloc_ctloc_dr=:LocId)	
 s rowid= $G(rowid)
 ;b ;12
 s ret=0
 i rowid="" d
 .s ret=..InsertCounterLoc(SSC,LocId)
 i ret'=0 d ulk q ""
 
 s newNo=..GetCounterByLoc(SSC,LocId)
 i newNo="" d ulk q ""
 ;b ;123
 ///记录新的单号
 s Today=$zd(+$h,3)
 s Year=$p(Today,"-",1)
 s Month=+$p(Today,"-",2)
 s Day=+$p(Today,"-",3)
 &sql(update dhc_stksyscounterloc set sscloc_currentyear=:Year,sscloc_currentmonth=:Month,sscloc_currentday=:Day,
   sscloc_currentno=:newNo where sscloc_ssc_parref=:SSC  and sscloc_ctloc_dr=:LocId) 
 i SQLCODE'=0 d ulk q "" 
 d ulk
 s newNo=$tr($j(newNo,noLen)," ","0")
 q newNo
ulk
 d ##class(web.DHCST.Common.AppCommon).UnLock(AppName_"NO")
 q
}

ClassMethod GetSSCByAppCode(appCode, hosp)
{
	n (appCode, hosp)
	s ssa = $o(^DHCSSA(0, "ACODE", $$ALPHAUP^SSUTIL4(appCode), ""))
	q:ssa="" ""
	q ..GetSSC(ssa,hosp)
}

ClassMethod GetSSC(ssa, hosp)
{
	n (ssa, hosp)
	s ssc = ""
	s chl = 0
	f  s chl = $o(^DHCSSA(ssa, "SSC", chl)) q:((chl="")||(ssc '= ""))  d 
	.q:##class(PHA.FACE.IN.Com).GetShowDataFlag(..#TableName,ssa _ "||" _ chl, hosp)="N"
	.s ssc = ssa _ "||" _ chl
	q ssc
}

}
