Class web.DHCEQCPurposeType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 8;

Parameter SQLCODE = "PT_Code";

Parameter SQLDATEFROM;

Parameter SQLFILTER = "(PT_InvalidFlag = 'N')";

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "PT_Desc";

Parameter SQLROWID = "PT_RowID";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String:设备用途,HIDDEN:%String,Code:%String:编码")
{
SELECT PT_Desc,
	   PT_RowID,
	   PT_Code
FROM sqluser.DHC_EQCPurposeType
where PT_InvalidFlag = 'N' and PT_Desc like nvl(:para,'')||'%'
}

/// add by czf 2022-10-31
/// 入参：设备用途
/// d ##class(%ResultSet).RunQuery("web.DHCEQCPurposeType","PurposeType","","")
Query PurposeType(vDesc As %String = "", StatCatDR As %String = "") As %SQLQuery(ROWSPEC = "Description:%String:设备用途,HIDDEN:%String,Code:%String:编码")
{
}

ClassMethod PurposeTypeExecute(ByRef qHandle As %Binary, vDesc As %String = "", StatCatDR As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    s vDesc=$ZCONVERT(vDesc,"U")  
    s LandFlag=##class(web.DHCEQCommon).GetSysInfo("401002")
    s BuildingFlag=##class(web.DHCEQCommon).GetSysInfo("401003")
    s VerhicleFlag=##class(web.DHCEQCommon).GetSysInfo("401005")
    
    s FilterFlag=0
    i (","_LandFlag_",")[(","_StatCatDR_",") s FilterFlag=1
    i (","_BuildingFlag_",")[(","_StatCatDR_",") s FilterFlag=1
    i (","_VerhicleFlag_",")[(","_StatCatDR_",") s FilterFlag=1
    
    s rowid=0
    f  s rowid=$o(^DHCEQCCode("DHCEQCPurposeType",rowid))  quit:rowid=""  d
    .q:$p($g(^DHCEQCCode("DHCEQCPurposeType",rowid)),"^",4)="Y"
    .s Desc=$p($g(^DHCEQCCode("DHCEQCPurposeType",rowid)),"^",2)
    .s Code=$p($g(^DHCEQCCode("DHCEQCPurposeType",rowid)),"^",1)
    .q:(vDesc'="")&&($ZCONVERT(Desc,"U")'[vDesc)&&($ZCONVERT(Code,"U")'[vDesc)
    .s TStatCatDR=$p($g(^DHCEQCCode("DHCEQCPurposeType",rowid)),"^",5)
	.q:(FilterFlag=1)&&((","_TStatCatDR_",")'[(","_StatCatDR_","))
	.q:(FilterFlag=0)&&(TStatCatDR'="")
    .d OutputRowPurposeType
    Quit $$$OK
OutputRowPurposeType
    s Data=$lb(Desc,rowid,Code)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod PurposeTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PurposeTypeExecute ]
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

ClassMethod PurposeTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PurposeTypeExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Storage Default
{
<Data name="DHCEQCPurposeTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQCPurposeTypeD</DataLocation>
<DefaultData>DHCEQCPurposeTypeDefaultData</DefaultData>
<IdLocation>^web.DHCEQCPurposeTypeD</IdLocation>
<IndexLocation>^web.DHCEQCPurposeTypeI</IndexLocation>
<StreamLocation>^web.DHCEQCPurposeTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
