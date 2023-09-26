/// 此类主要用来处理胶片扫描相关的信息处理等
Class web.DHCRisFilmScan Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

//根据病人登记号查询病人基本信息

Query QueryInfoByPatientNo(PatientNo As %String) As %Query(ROWSPEC = "PatientNo:%String,Name:%String,Sex:%String,Age:%String,PAPMIDOB:%String")
{
}

ClassMethod QueryInfoByPatientNoExecute(ByRef qHandle As %Binary, PatientNo As %String) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisFilmScan","QueryInfoByPatientNo",1294)
 s ind=1
 Set repid=$I(^CacheTemp)
 s ( Name, Sex, Age,PAPMIDOB)=""
 b
 i $d(^PAPERi("PAPMI_PatNo",PatientNo))>0 d
 .s PAPMIDR=$o(^PAPERi("PAPMI_PatNo",PatientNo,""))
 .s Name=$p(^PAPER(PAPMIDR,"ALL"),"^",1) 
 .s SexDR=""
 .S SexDR=$p(^PAPER(PAPMIDR,"ALL"),"^",7)
 .i SexDR'="" s Sex=$P(^CT("SEX",SexDR),"^",2)
 .s PAPMIDOB=$p(^PAPER(PAPMIDR,"ALL"),"^",6)
 .i PAPMIDOB'="" s PAPMIDOB=$zd(PAPMIDOB,3)
 .S Age=##class(web.DHCRisPatientInfo).CalAge(PAPMIDOB,$zd($p($h,",",1),3))
 Do OutPatientInfo
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
OutPatientInfo
 set Data=$lb(PatientNo,Name,Sex, Age, PAPMIDOB)
 Set ^CacheTemp(repid,ind)=Data
 Set ind = ind + 1
 Quit
}

ClassMethod QueryInfoByPatientNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInfoByPatientNoExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
         // if there are no more rows, finish fetching
 Set AtEnd = 1
 Set Row = ""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryInfoByPatientNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInfoByPatientNoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
