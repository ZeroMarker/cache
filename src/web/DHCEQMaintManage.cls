/// 已停用，启用新的维修模块 20150902 JDL After V4.0.0
Class web.DHCEQMaintManage Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

Query GetFaultCase(FaultCaseDR, FaultCase) As %Query(ROWSPEC = "TFaultCaseDR:%String,TFaultCase:%String,TDescribe:%String")
{
}

ClassMethod GetFaultCaseExecute(ByRef qHandle As %Binary, FaultCaseDR, FaultCase) As %Status
{
        new repid, index,rowid
        Set repid=$I(^CacheTemp)
        Set qHandle=$lb(0,repid,0)
        s index=1
        s rowid=0
        d BuildDataGetCase
        Quit $$$OK
BuildDataGetCase
        f  s rowid=$o(^DHCEQCCode("DHCEQCFaultCase",rowid))  quit:rowid=""  d
        .d ResetVariablesGetCase
        .s TFaultCaseDR = rowid
        .q:(FaultCaseDR'="")&&(TFaultCaseDR'=FaultCaseDR)
		.s TFaultCase = $p($g(^DHCEQCCode("DHCEQCFaultCase",rowid)),"^",2)
		.q:(FaultCase'="")&&(TFaultCase'[FaultCase)
		.s TDescribe = $p($g(^DHCEQCCode("DHCEQCFaultCase",rowid)),"^",3)
        .d OutputRowGetCase
        quit
OutputRowGetCase
        s Data=$lb(TFaultCaseDR,TFaultCase,TDescribe)
        Set ^CacheTemp(repid,index)=Data
        Set index=index+1
        quit
ResetVariablesGetCase
        s (TFaultCaseDR,TFaultCase,TDescribe)=""
        quit
}

ClassMethod GetFaultCaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFaultCaseExecute ]
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

ClassMethod GetFaultCaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFaultCaseExecute ]
{
        Set repid=$LIST(qHandle,2)
        Kill ^CacheTemp(repid)
        Quit $$$OK
}

//and MR_Status="5"

Query GetFaultReason(FaultCaseDR) As %SQLQuery(ROWSPEC = "TFaultReasonDR:%String,TFaultReason:%String,TDescribe:%String")
{
SELECT distinct MR_FaultReasonDR TFaultReasonDR,
	   MR_FaultReasonDR->FR_Desc TFaultReason,
	   MR_FaultReasonDR->FR_Remark TDescrible 	   
FROM sqluser.DHC_EQMaintRequest
where MR_FaultCaseDR=:FaultCaseDR and  MR_Status='2'
}

//MR_FaultCaseDR=:FaultCaseDR and 

Query GetDealMethod(FaultCaseDR, FaultReasonDR) As %SQLQuery(ROWSPEC = "TDealMethodDR:%String,TDealMethod:%String,TDescribe:%String")
{
SELECT distinct MR_DealMethodDR TDealMethodDR,
	   MR_DealMethodDR->DM_Desc TDealMethod,
	   MR_DealMethodDR->DM_Remark TDescrible 	   
FROM sqluser.DHC_EQMaintRequest
where MR_FaultReasonDR=:FaultReasonDR and  MR_Status='2'
}

Storage Default
{
<Data name="DHCEQMaintManageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQMaintManageD</DataLocation>
<DefaultData>DHCEQMaintManageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCEQMaintManageD</IdLocation>
<IndexLocation>^web.DHCEQMaintManageI</IndexLocation>
<StreamLocation>^web.DHCEQMaintManageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
