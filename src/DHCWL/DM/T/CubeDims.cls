Class DHCWL.DM.T.CubeDims Extends %Persistent
{

Property CubeBase As CubeBase [ Required ];

Property DimPro As ThemeDims;

Property SerialNumber As %Integer;

Index MainI On (CubeBase, DimPro);

// Index SNCI ON (DimPro.);

ClassMethod Get(cubeId, themeDimId) As CubeDims
{
	s obj=""
	i ( ($d(^DHCWL.DM.T.CubeDimsI("MainI",cubeId))) && ($d(^DHCWL.DM.T.CubeDimsI("MainI",cubeId,themeDimId))) ) d
	.s id=$o(^DHCWL.DM.T.CubeDimsI("MainI",cubeId,themeDimId,""))
	.s obj=##class(CubeDims).%OpenId(id)
	q obj
}

ClassMethod GetDims(cubeId) As %ListOfObjects
{
	s obj=""
	s list =##class(%ListOfObjects).%New()
	s dimId="" f  s dimId=$o(^DHCWL.DM.T.CubeDimsI("MainI",cubeId,dimId)) q:dimId=""  d
	.s id=$o(^DHCWL.DM.T.CubeDimsI("MainI",cubeId,dimId,""))
	.s obj=##class(CubeDims).%OpenId(id)
	.q:obj=""
	.d list.Insert(obj)
	q list
}

ClassMethod GetId(cubeId, themeDimId) As CubeDims
{
	s obj=""
	i ( ($d(^DHCWL.DM.T.CubeDimsI("MainI",cubeId))) && ($d(^DHCWL.DM.T.CubeDimsI("MainI",cubeId,themeDimId))) ) {
	  q $o(^DHCWL.DM.T.CubeDimsI("MainI",cubeId,themeDimId,""))
	}
	q ""
}

ClassMethod Add(ci, themeDimId)
{
	i ( ($d(^DHCWL.DM.T.CubeDimsI("MainI",ci))) && ($d(^DHCWL.DM.T.CubeDimsI("MainI",ci,themeDimId))) ) q $$$OK
	&sql(INSERT INTO DHCWL_DM_T.CubeDims(CubeBase,DimPro)values(:ci,:themeDimId))
	i SQLCODE=0 q $$$OK
	q $$$ERROR("SQLCODE="_SQLCODE)
}

Trigger AftInsertTri [ Event = INSERT, Time = AFTER ]
{
	n id,sn,cubeId
	s id={%%ID}
	i id'="" d
	.s cubeId={CubeBase}
	.s sn=..ComputeSN(cubeId)
	.&sql(update DHCWL_DM_T.CubeDims set SerialNumber=:sn where ID=:id)
	.;d ##class(CubeDStructMap).AddDim(cubeId,id)
}

Trigger AftDeleteTri [ Event = DELETE, Time = AFTER ]
{
	n id,cubeId
	s id={%%ID}
	i id'="" d
	.s cubeId={CubeBase}
	.;d ##class(CubeDStructMap).DeleteDim(cubeId,id)
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
    s ..SerialNumber=..ComputeSN(..CubeBase.%Id())
    ;d ##class(CubeDStructMap).AddDim(..CubeBase.%Id(),..%Id())
    q $$$OK
}

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{
    ;s obj=##class(CubeDims).%Open(oid)
    ;q ##class(CubeDStructMap).DeleteDim(obj.CubeBase.%Id(),obj.%Id())
    q $$$OK
}

ClassMethod ComputeSN(cubeId, dimPro) As %Integer
{
	q:'$d( ^DHCWL.DM.T.CubeDimsI("MainI",cubeId) ) 1
	;s dimId=$lg(^DHCWL.DM.T.CubeDimsD(cubeId),3)
	/*q:dimId="" 1
	s dimObj=##class(ThemeDims).%OpenId(dimId)
	s typeCode=dimObj.DimType.Code
	s:typeCode'="R" typeCode="O"
	q $i(^DHCWL.DM.T.CubeDimsI("SNCI",typeCode))*/
	s max=0
	s dp="" f  s dp=$o( ^DHCWL.DM.T.CubeDimsI("MainI",cubeId,dp) ) q:dp=""  d
	.s id=$o( ^DHCWL.DM.T.CubeDimsI("MainI",cubeId,dp,"") )
	.s sn=+$lg(^DHCWL.DM.T.CubeDimsD(id),4,0)
	.i sn>max s max=sn
	q max+1
}

// w ##class(DHCWL.DM.T.CubeDims).GetFetchSelect(1)

ClassMethod GetFetchSelect(cubeId) As %String
{
	q:'$d(^DHCWL.DM.T.CubeDimsI("MainI",cubeId)) ""
	s sql="",num=0
	s proId="" f  s proId=$o(^DHCWL.DM.T.CubeDimsI("MainI",cubeId,proId)) q:proId=""  d
	.s id=$o( ^DHCWL.DM.T.CubeDimsI("MainI",cubeId,proId,"") )
	.s obj=##class(CubeDims).%OpenId(id)
	.q:obj=""
	.s num=num+1
	.s:num>1 sql=sql_","
	.s sql=sql_obj.DimPro.Code
	q sql
}

// w ##class(DHCWL.DM.T.CubeDims).GetFetchGroupby(1)

ClassMethod GetFetchGroupby(cubeId) As %String
{
	q:'$d(^DHCWL.DM.T.CubeDimsI("MainI",cubeId)) " GROUP BY()"
	s sql=" GROUP BY(",num=0
	s proId="" f  s proId=$o(^DHCWL.DM.T.CubeDimsI("MainI",cubeId,proId)) q:proId=""  d
	.s id=$o( ^DHCWL.DM.T.CubeDimsI("MainI",cubeId,proId,"") )
	.s obj=##class(CubeDims).%OpenId(id)
	.q:obj=""
	.s num=num+1
	.s:num>1 sql=sql_","
	.s sql=sql_obj.DimPro.Code
	q sql_")"
}

ClassMethod GetSelectColName(cubeId, dimId = "", isRelaDim As %Boolean = 0) As %List
{
	if (dimId'=""){
	  s dim=##class(CubeDims).%OpenId(dimId)
	  q:dim="" $lb()
	  q:(isRelaDim)&&(dim.DimPro.DimType.Code'="R") $lb()
	  q:('isRelaDim)&&(dim.DimPro.DimType.Code="R") $lb()
	  s dt=12
	  if dim.DimPro.DataType'="" s dt=dim.DimPro.DataType.JDBCTypeCodeNum
	  s list= $lb(dim.DimPro.Code,dim.SerialNumber,dimId,dt)	
	  s dim=""
	  q list
	}
	s list=$lb(),i=0
	q:'$d(^DHCWL.DM.T.CubeDimsI("MainI",cubeId)) list
	k snOrderMap
	s proId="" f  s proId=$o(^DHCWL.DM.T.CubeDimsI("MainI",cubeId,proId)) q:proId=""  d
	.s id=$o( ^DHCWL.DM.T.CubeDimsI("MainI",cubeId,proId,"") )
	.s obj=##class(CubeDims).%OpenId(id)
	.q:obj=""
	.q:(isRelaDim)&&(obj.DimPro.DimType.Code'="R")
	.q:('isRelaDim)&&(obj.DimPro.DimType.Code="R")
	.s sn=obj.SerialNumber
	.s snOrderMap(sn)=id
	.s obj=""
	s i=0
	s sn="" f  s sn=$o(snOrderMap(sn)) q:sn=""  d
	.s id=snOrderMap(sn)
	.s obj=##class(CubeDims).%OpenId(id)
	.s i=i+1
	.s $list(list,i)=obj.DimPro.Code
	.s i=i+1
	.s $list(list,i)=obj.SerialNumber
	.s i=i+1
	.s $list(list,i)=id
	.s i=i+1
	.s dt=12
	.i obj.DimPro.DataType'="" d
	..s dt=obj.DimPro.DataType.JDBCTypeCodeNum
	.s $list(list,i)=dt
	q list
}

ClassMethod GetMaxSN(cubeId) As %Integer
{
	s maxSN=0
	s proId="" f  s proId=$o(^DHCWL.DM.T.CubeDimsI("MainI",cubeId,proId)) q:proId=""  d
	.s id=$o( ^DHCWL.DM.T.CubeDimsI("MainI",cubeId,proId,"") )
	.q:'$d(^DHCWL.DM.T.CubeDimsD(id))
	.s sn=$lg(^DHCWL.DM.T.CubeDimsD(id),4)
	.i maxSN<sn d
	..s maxSN=sn
	q maxSN
}

ClassMethod ToString(cubeId) As %String
{
	q:'$d(^DHCWL.DM.T.CubeDimsI("MainI",cubeId)) "[]"
	s str=""
	s proId="" f  s proId=$o(^DHCWL.DM.T.CubeDimsI("MainI",cubeId,proId)) q:proId=""  d
	.s id=$o( ^DHCWL.DM.T.CubeDimsI("MainI",cubeId,proId,"") )
	.s obj=##class(CubeDims).%OpenId(id)
	.q:obj=""
	.s num=num+1
	.s:num>1 str=str_","
	.s str=str_"{""code"":"""_obj.DimPro.Code_""",""sn"":"_obj.SerialNumber_"}"
	q "["_str_"]"
}

Method GetDimTypeCode() As %String [ CodeMode = expression ]
{
..DimPro.DimType.Code
}

Storage Default
{
<Data name="CubeDimsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CubeBase</Value>
</Value>
<Value name="3">
<Value>DimPro</Value>
</Value>
<Value name="4">
<Value>SerialNumber</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.CubeDimsD</DataLocation>
<DefaultData>CubeDimsDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.CubeDimsD</IdLocation>
<IndexLocation>^DHCWL.DM.T.CubeDimsI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.CubeDimsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
