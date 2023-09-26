Class DHCWL.DM.T.DimDStructMap Extends %Persistent
{

Property DimBase As DimBase [ Required ];

Property DimProperty As DimProperty [ Required ];

Property MapPosition As %Integer;

Index MainI On (DimBase, DimProperty) [ PrimaryKey ];

// d ##class(DHCWL.DM.T.DimDStructMap).TestData()

/*
ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.DimDStructMap)
	k ^DHCWL.DM.T.DimDStructMapD,^DHCWL.DM.T.DimDStructMapI
	s base=##class(DimBase).GetByPath("/Department.d")
	s obj=##class(DimDStructMap).%New()
	s obj.DimBase=base,obj.DimProperty=base.GetProperty("Code")
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(DimDStructMap).%New()
	s obj.DimBase=base,obj.DimProperty=base.GetProperty("Name")
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(DimDStructMap).%New()
	s obj.DimBase=base,obj.DimProperty=base.GetProperty("LPYM")
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(DimDStructMap).%New()
	s obj.DimBase=base,obj.DimProperty=base.GetProperty("PYLen")
	d obj.%Save()
	w obj.%Id(),","
}
*/
Trigger AftInsertTri [ Event = INSERT, Time = AFTER ]
{
	n id
	s id={%%ID}
	n sn,dimId
	i id'="" d
	.s dimId=$lg(^DHCWL.DM.T.DimDStructMapD(id),2)
	.s sn=..ComputeSN(dimId)
	.&sql(update DHCWL_DM_T.DimDStructMap set MapPosition=:sn where ID=:id)
}

Method %OnBeforeSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
    s ..MapPosition=..ComputeSN(..DimBase.%Id())
    q $$$OK
}

ClassMethod ComputeSN(dimId) As %Integer
{
	q:'$d( ^DHCWL.DM.T.DimDStructMapI("MainI",dimId) ) 1
	s max=0
	s dp="" f  s dp=$o( ^DHCWL.DM.T.DimDStructMapI("MainI",dimId,dp) ) q:dp=""  d
	.s id=$o( ^DHCWL.DM.T.DimDStructMapI("MainI",dimId,dp,"") )
	.s sn=$lg(^DHCWL.DM.T.DimDStructMapD(id),4)
	.i sn>max s max=sn
	q max+1
}

// s list= ##class(DHCWL.DM.T.DimDStructMap).GetDimStruct("/Department.d")

ClassMethod GetDimStruct(dimPath, onlyNomal As %Boolean = 1) As %ListOfObjects
{
	q ..GetDimStructByDimId(##class(DimBase).GetIdByPath(dimPath),onlyNomal)
}

ClassMethod GetDimStructByDimId(parentId, onlyNomal As %Boolean = 1) As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	q:( (parentId="") ||('$d(^DHCWL.DM.T.DimDStructMapI("MainI",parentId)) ) ) list
	s pro="" f {
	  s pro=$o( ^DHCWL.DM.T.DimDStructMapI("MainI",parentId,pro) )
	  q:pro=""
	  s id=$o( ^DHCWL.DM.T.DimDStructMapI("MainI",parentId,pro,"") )
	  s obj=##class(DimDStructMap).%OpenId(id)
	  continue:obj=""
	  i onlyNomal {
		s proType=obj.DimProperty.CreatedType.Code
		continue:((proType="STCPROFUN")||(proType="DYNPROFUN"))
	  }
	  d list.Insert(obj)
	}
	q list
}

ClassMethod GetDimProStruct(dimBaseId) As %List
{
	s list=$lb()
	s i=0
	q:( (dimBaseId="") ||('$d(^DHCWL.DM.T.DimDStructMapI("MainI",dimBaseId)) ) ) list
	s pro="" f {
	  s pro=$o( ^DHCWL.DM.T.DimDStructMapI("MainI",dimBaseId,pro) )
	  q:pro=""
	  s id=$o( ^DHCWL.DM.T.DimDStructMapI("MainI",dimBaseId,pro,"") )
	  s obj=##class(DimDStructMap).%OpenId(id)
	  continue:obj=""
	  s i=i+1
	  s $list(list,i)=obj.DimProperty.%Id()
	  s i=i+1
	  s $list(list,i)=obj.DimProperty.Code
	  s i=i+1
	  s $list(list,i)=obj.DimProperty.CreatedType.GetPath()
	  s i=i+1
	  s $list(list,i)=obj.MapPosition
	}
	q list
}

// s list=##class(DHCWL.DM.T.DimDStructMap).GetDimProStruct2("/CT_DIMDAY.d")

ClassMethod GetDimProStruct2(dimBaseId) As %List
{
	s list=$lb()
	s i=0
	q:( (dimBaseId="") ||('$d(^DHCWL.DM.T.DimDStructMapI("MainI",dimBaseId)) ) ) list
	s pro="" f {
	  s pro=$o( ^DHCWL.DM.T.DimDStructMapI("MainI",dimBaseId,pro) )
	  q:pro=""
	  s id=$o( ^DHCWL.DM.T.DimDStructMapI("MainI",dimBaseId,pro,"") )
	  s obj=##class(DimDStructMap).%OpenId(id)
	  continue:obj=""
	  s i=i+1
	  s $list(list,i)=obj.DimProperty.%Id()
	  s i=i+1
	  s $list(list,i)=obj.DimProperty.Code
	  s i=i+1
	  s $list(list,i)=obj.DimProperty.CreatedType.GetPath()
	  s i=i+1
	  s $list(list,i)=obj.MapPosition
	  s i=i+1
	  s $list(list,i)=""
	  s:obj.DimProperty.DataType'="" $list(list,i)=obj.DimProperty.DataType.JDBCTypeCodeNum
	}
	q list
}

ClassMethod GetKeyStruct(dimBaseId) As %List
{
	s list=$lb()
	s i=0
	q:( (dimBaseId="") ||('$d(^DHCWL.DM.T.DimDStructMapI("MainI",dimBaseId)) ) ) list
	s dimBaseObj=##class(DimBase).%OpenId(dimBaseId)
	q:dimBaseObj="" list
	s rowkey=dimBaseObj.RowKeyFields
	f j=1:1:$l(rowkey,","){
	  s row=$p(rowkey,",",j)
	  s pro=##class(DimProperty).GetPropertyId(dimBaseId,row)
	  continue:'$d( ^DHCWL.DM.T.DimDStructMapI("MainI",dimBaseId,pro) )
	  s id=$o( ^DHCWL.DM.T.DimDStructMapI("MainI",dimBaseId,pro,"") )
	  s obj=##class(DimDStructMap).%OpenId(id)
	  continue:obj=""
	  s i=i+1
	  s $list(list,i)=obj.DimProperty.%Id()
	  s i=i+1
	  s $list(list,i)=obj.DimProperty.Code
	  s i=i+1
	  s $list(list,i)=obj.DimProperty.CreatedType.GetPath()
	  s i=i+1
	  s $list(list,i)=j
	  s i=i+1
	  s $list(list,i)=""
	  s:obj.DimProperty.DataType'="" $list(list,i)=obj.DimProperty.DataType.JDBCTypeCodeNum
	}
	q list
}

ClassMethod Add(dimId, proId) As DimDStructMap
{
	s obj=""
	if ( ($d(^DHCWL.DM.T.DimDStructMapI("MainI",dimId))) && ($d(^DHCWL.DM.T.DimDStructMapI("MainI",dimId,proId))) ) d
	.s id=$o(^DHCWL.DM.T.DimDStructMapI("MainI",dimId,proId,""))
	.s obj=##class(DimDStructMap).%OpenId(id)
	e  d
	.&sql(INSERT INTO DHCWL_DM_T.DimDStructMap(DimBase,DimProperty) values(:dimId,:proId))
	.s id=%ROWID
	.s obj=##class(DimDStructMap).%OpenId(id)
	q obj
}

ClassMethod Delete(dimId, proId) As %Status
{
	if ( ($d(^DHCWL.DM.T.DimDStructMapI("MainI",dimId))) && ($d(^DHCWL.DM.T.DimDStructMapI("MainI",dimId,proId))) ) d
	.s id=$o(^DHCWL.DM.T.DimDStructMapI("MainI",dimId,proId,""))
	.d ##class(DimDStructMap).%DeleteId(id)
	q $$$OK
}

ClassMethod GetMapPosition(dimId, proId) As %Integer
{
	s sn=0
	if ( ($d(^DHCWL.DM.T.DimDStructMapI("MainI",dimId))) && ($d(^DHCWL.DM.T.DimDStructMapI("MainI",dimId,proId))) ) d
	.s id=$o(^DHCWL.DM.T.DimDStructMapI("MainI",dimId,proId,""))
	.s sn=$lg(^DHCWL.DM.T.DimDStructMapD(id),4,0)
	q sn
}

ClassMethod GetMaxSN(dimId) As %Integer
{
	q:'$d( ^DHCWL.DM.T.DimDStructMapI("MainI",dimId) ) 1
	s max=0
	s dp="" f  s dp=$o( ^DHCWL.DM.T.DimDStructMapI("MainI",dimId,dp) ) q:dp=""  d
	.s id=$o( ^DHCWL.DM.T.DimDStructMapI("MainI",dimId,dp,"") )
	.s sn=$lg(^DHCWL.DM.T.DimDStructMapD(id),4)
	.i sn>max s max=sn
	q max
}

Storage Default
{
<Data name="DimDStructMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DimBase</Value>
</Value>
<Value name="3">
<Value>DimProperty</Value>
</Value>
<Value name="4">
<Value>MapPosition</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.DimDStructMapD</DataLocation>
<DefaultData>DimDStructMapDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.DimDStructMapD</IdLocation>
<IndexLocation>^DHCWL.DM.T.DimDStructMapI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.DimDStructMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
