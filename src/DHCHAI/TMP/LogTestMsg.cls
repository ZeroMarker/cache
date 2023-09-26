/// 名称: DHCHAI.TMP.LogTestMsg
/// 描述: 存储错误日志
/// 编写者：liuzhenhe
/// 编写日期: 2022-08-04
/// 产品组：DHCHAI
Class DHCHAI.TMP.LogTestMsg Extends (%Persistent, DHCHAI.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Property OID As %String;

Property EventSimple As %String;

Property EventComplex As %String;

Property AddDate As %Date;

Property AddTime As %Time;

Index OIDIndex On OID As Exact;

/// Creator： liuzhenhe
/// CreatDate： 2022-08-04
/// Description:：添加日志
/// Table： DHCHAI_TMP.LogTestMsg
/// Input：aInputStr(1 OID )
/// Output： 对输出参数的说明
/// Return： 函数返回值的说明
/// Others：  d ##class(DHCHAI.TMP.LogTestMsg).Add(1,2,3)
ClassMethod Add(aInputStr...)
{
        new (aInputStr)
        Set return=""
        
        Set OID=$g(aInputStr(1),"")
        Set EventSimple=$g(aInputStr(2),"")
        Set EventComplex=$g(aInputStr(3),"")
        Quit:OID=""
        Set obj=##class(DHCHAI.TMP.LogTestMsg).%New()
        Set obj.OID=OID
        Set obj.EventSimple=EventSimple
        Set obj.EventComplex=EventComplex
        Set obj.AddDate=+$H
        Set obj.AddTime=$p($h,",",2)
        Set sc= obj.%Save()
        
        If $$$ISERR(sc) {
            Do $System.Status.DisplayError(sc)
            Quit return
        }
        quit return
}

/// Creator： liuzhenhe
/// CreatDate： 2022-08-04
/// Description:：添加日志
/// Table： DHCHAI_TMP.LogTestMsg
/// Input： OID
/// Output： ID,OID,EventSimple,EventComplex,AddDate,AddTime
/// Return： 
/// Others： do ##class(%ResultSet).RunQuery("DHCHAI.TMP.LogTestMsg","QueryLog","")
/// 
Query QueryLog(OID As %String) As %Query(ROWSPEC = "ID,OID,EventSimple,EventComplex,AddDate,AddTime") [ SqlProc ]
{
}

ClassMethod QueryLogExecute(ByRef qHandle As %Binary, OID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind = 1 , xId = ""
    if (OID=""){
        
        for 
        {
            Set xId=$o(^MA.HAI.TMP.LogTestMsgD(xId))
            Quit:xId=""
            do BuildData
        
        }
    }else{
        Set xId=^MA.HAI.TMP.LogTestMsgI("OIDIndex",OID,"")
        do BuildData
    }
    Quit $$$OK
BuildData
    Set LogInfo=$g(^MA.HAI.TMP.LogTestMsgD(xId))
    Set OID=$lg(LogInfo,2)
    Set EventSimple=$lg(LogInfo,3)
    Set EventComplex=$lg(LogInfo,4)
    Set AddDate=$zd(+$lg(LogInfo,5),3)
    Set AddTime=$zt(+$lg(LogInfo,6))
    Set Data=$lb(xId,OID,EventSimple,EventComplex,AddDate,AddTime)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
}

ClassMethod QueryLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLogExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLogExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

Storage Default
{
<Data name="LogTestMsgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OID</Value>
</Value>
<Value name="3">
<Value>EventSimple</Value>
</Value>
<Value name="4">
<Value>EventComplex</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
</Data>
<DataLocation>^MA.HAI.TMP.LogTestMsgD</DataLocation>
<DefaultData>LogTestMsgDefaultData</DefaultData>
<IdLocation>^MA.HAI.TMP.LogTestMsgD</IdLocation>
<IndexLocation>^MA.HAI.TMP.LogTestMsgI</IndexLocation>
<StreamLocation>^MA.HAI.TMP.LogTestMsgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
