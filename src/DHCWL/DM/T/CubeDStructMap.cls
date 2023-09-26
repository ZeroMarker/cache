Class DHCWL.DM.T.CubeDStructMap Extends %Persistent
{

Property CubeBase As CubeBase [ Required ];

Property ProType As TypeConfig [ Required ];

//CubeDims or CubeMetrics 's ID

Property ProId As %String [ Required ];

Property SerialNumber As %Integer;

Index MainI On (CubeBase, ProType, ProId As EXACT);

Trigger AftInsertTri [ Event = INSERT, Time = AFTER ]
{
	n id,sn,cubeId
	s id={%%ID}
	i id'="" d
	.s cubeId={CubeBase}
	.s sn=..ComputeSN(cubeId)
	.&sql(update DHCWL_DM_T.CubeDStructMap set SerialNumber=:sn where ID=:id)
}

Method %OnBeforeSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
    s ..SerialNumber=..ComputeSN(..CubeBase.%Id())
    q $$$OK
}

ClassMethod ComputeSN(cubeId) As %Integer
{
	q:'$d( ^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId) ) 1
	s max=0
	s type="" f  s type=$o( ^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId,type) ) q:type=""  d
	.s pro="" f  s pro=$o( ^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId,type,pro) ) q:pro=""  d
	..s id=$o( ^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId,type,pro,"") )
	..s sn=$lg(^DHCWL.DM.T.CubeDStructMapD(id),5)
	..i sn>max s max=sn
	q max+1
}

ClassMethod Add(cubeId, typeId, proId) As %Status [ Private ]
{
	s status=$$$OK
	if ( ($d(^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId))) && ($d(^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId,typeId))) && ($d(^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId,typeId,proId))) ) d
	.
	e  d
	.&sql(INSERT INTO DHCWL_DM_T.CubeDStructMap(CubeBase,ProType,ProId)VALUES(:cubeId,:typeId,:proId))
	.s:SQLCODE'=0 stuatus=$$$ERROR("SQLCODE="_SQLCODE)
	q status
}

ClassMethod AddDim(cubeId, proId) As %Status
{
	s typeId=##class(TypeConfig).GetIdByPath("CSM:DIM")
	q ..Add(cubeId,typeId,proId)
}

ClassMethod AddMetric(cubeId, proId) As %Status
{
	s typeId=##class(TypeConfig).GetIdByPath("CSM:METRIC")
	q ..Add(cubeId,typeId,proId)
}

ClassMethod Delete(cubeId, typeId, proId) As %Status [ Private ]
{
	s status=$$$OK
	if ( ($d(^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId))) && ($d(^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId,typeId))) && ($d(^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId,typeId,proId))) ) d
	.s id=$o(^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId,typeId,proId,""))
	.s status=##class(CubeDStructMap).%DeleteId(id)
	q status
}

ClassMethod DeleteDim(cubeId, proId) As %Status
{
	q ..Delete(cubeId,##class(TypeConfig).GetIdByPath("CSM:DIM"),proId)
}

ClassMethod DeleteMetric(cubeId, proId) As %Status
{
	q ..Delete(cubeId,##class(TypeConfig).GetIdByPath("CSM:METRIC"),proId)
}

ClassMethod GetDimSN(cubeId, dimId) As %Integer
{
	q:dimId="" 0
	;q:##class(CubeBase).IsSchedulerDim(cubeId,dimId) 1
	s tid=##class(TypeConfig).GetIdByPath("CSM:DIM")
	q:( ('$d(^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId))) || ('$d(^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId,tid))) || ('$d(^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId,tid,dimId))) ) 0
	s id=$o(^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId,tid,dimId,""))
	q:'$d(^DHCWL.DM.T.CubeDStructMapD(id)) 0
	q $lg(^DHCWL.DM.T.CubeDStructMapD(id),5)
}

ClassMethod GetMetricSN(cubeId, dimId) As %Integer
{
	s tid=##class(TypeConfig).GetIdByPath("CSM:METRIC")
	q:( ('$d(^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId))) || ('$d(^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId,tid))) || ('$d(^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId,tid,dimId))) ) 0
	s id=$o(^DHCWL.DM.T.CubeDStructMapI("MainI",cubeId,tid,dimId,""))
	q:'$d(^DHCWL.DM.T.CubeDStructMapD(id)) 0
	q $lg(^DHCWL.DM.T.CubeDStructMapD(id),5)
}

//w ##class(DHCWL.DM.T.CubeDStructMap).GetMaxSerialNumber(1)

ClassMethod GetMaxSerialNumber(cubeId) As %Integer
{
	s max=0
	&sql(select max(SerialNumber) into :max from DHCWL_DM_T.CubeDStructMap where CubeBase=:cubeId)
	q max
}

Storage Default
{
<Data name="CubeDStructMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CubeBase</Value>
</Value>
<Value name="3">
<Value>ProType</Value>
</Value>
<Value name="4">
<Value>ProId</Value>
</Value>
<Value name="5">
<Value>SerialNumber</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.CubeDStructMapD</DataLocation>
<DefaultData>CubeDStructMapDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.CubeDStructMapD</IdLocation>
<IndexLocation>^DHCWL.DM.T.CubeDStructMapI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.CubeDStructMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
