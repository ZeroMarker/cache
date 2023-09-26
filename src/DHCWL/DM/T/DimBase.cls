Class DHCWL.DM.T.DimBase Extends %Persistent
{

Property Namespace As Namespace [ Required ];

// 只能由字母,数字或者下划线组成，且必须是字母开头

Property Code As %String [ Required ];

Property Name As %String;

Property LinkedMetaDim As MetaTableBase [ Required ];

Property Description As %String(MAXLEN = 512, TRUNCATE = 1);

Property Creator As %String;

Property CreatedDate As %Date;

// split by "," the field of RowIdFields must be seted;the value is MetaTablePro's Code

// 必须要设置该字段的值，字段名称是DimProperty的Code

Property RowKeyFields As %String;

Property UpdateDate As %Date;

Property UsageStatus As %String(DISPLAYLIST = ",Active,Deprecated,", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",A,D");

Index MainI On (Namespace, Code) [ PrimaryKey ];

// d ##class(DHCWL.DM.T.DimBase).TestData()

ClassMethod TestData(flag = "")
{
	&sql(delete DHCWL_DM_T.DimBase)
	k ^DHCWL.DM.T.DimBaseD,^DHCWL.DM.T.DimBaseI
	s ml=##class(MetaTableBase).GetByPath("/CTLOC.ml")
	s ns=##class(Namespace).GetByPath("DI:/")
	s obj=##class(DimBase).%New()
	s obj.Namespace=ns,obj.Code="Department",obj.Name="科室维度",obj.LinkedMetaDim=ml,obj.Description="科室维度测试",obj.Creator="lhh",obj.CreatedDate=+$p($h,",",1)
	s obj.RowKeyFields="RowID"
	d obj.%Save()
	w obj.%Id(),","
	
	s ml=##class(MetaTableBase).GetByPath("/CTHospital.ml")
	s ns=##class(Namespace).GetByPath("DI:/")
	s obj=##class(DimBase).%New()
	s obj.Namespace=ns,obj.Code="Hospital",obj.Name="医院维度",obj.LinkedMetaDim=ml,obj.Description="医院维度测试",obj.Creator="lhh",obj.CreatedDate=+$p($h,",",1)
	s obj.RowKeyFields="RowID"
	d obj.%Save()
	w obj.%Id(),","
	//if flag {
	s ml=##class(MetaTableBase).GetByPath("/Doctor.ml")
	s ns=##class(Namespace).GetByPath("DI:/")
	s obj=##class(DimBase).%New()
	s obj.Namespace=ns,obj.Code="Doctor",obj.Name="医生维度",obj.LinkedMetaDim=ml,obj.Description="医生维度测试",obj.Creator="lhh",obj.CreatedDate=+$p($h,",",1)
	s obj.RowKeyFields="RowID"
	d obj.%Save()
	w obj.%Id(),","
	//}
}

// s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/dept.ml","DEPT_CODE")

ClassMethod BuildDimFromMeta(metaPath As %String, rowKeyField As %String) As DimBase
{
	s meta=##class(MetaTableBase).GetByPath(metaPath)
	q:meta="" ""
	s nsPath=##class(DHCWL.DM.T.Namespace).ComputeNodePath(meta.Namespace)
	s dimBase=..GetByPath(nsPath_"/"_meta.Code_".d")
	s dimBase.RowKeyFields=rowKeyField
	if dimBase'="" {
		w dimBase.%Save()
		q dimBase
	}
	s dimNs=##class(Namespace).CreateNamespace("DI:"_nsPath)
	s dimBase=##class(DimBase).%New()
	s dimBase.Namespace=dimNs
	s dimBase.Code=meta.Code
	s dimBase.Name=meta.Name
	s dimBase.Description=meta.Description
	s dimBase.LinkedMetaDim=meta
	s dimBase.Creator=meta.Creator
	s dimBase.CreatedDate=+$h
	s dimBase.RowKeyFields=rowKeyField
	w dimBase.%Save()
	s proList=meta.GetProperties()
	s dpmp=##class(TypeConfig).GetByPath("DIM:DPMP")
	f i=1:1:proList.Count(){
	  s mpro=proList.GetAt(i)
	  s obj=##class(DimProperty).%New()
	  s obj.DimBase=dimBase
	  s obj.Code=mpro.Code,obj.Name=mpro.Name,obj.Description=mpro.Description
	  s obj.DataType=mpro.DataType
	  s obj.CreatedType=dpmp,obj.Expression=mpro.Code, obj.IsLinked="N"
	  d obj.%Save()
	}
	q dimBase
}

// s list=##class(DHCWL.DM.T.DimBase).GetAll()

ClassMethod GetAll(usageStatus As %String = "A") As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	s ns="" f  s ns=$o( ^DHCWL.DM.T.DimBaseI("MainI",ns) ) q:ns=""  d
	.s code="" f  s code=$o( ^DHCWL.DM.T.DimBaseI("MainI",ns,code) ) q:code=""  d
	..s id=$o( ^DHCWL.DM.T.DimBaseI("MainI",ns,code,"") )
	..s obj=##class(DimBase).%OpenId(id)
	..q:obj=""
	..q:((obj.UsageStatus'="")&&(obj.UsageStatus'=usageStatus))
	..d list.Insert(obj)
	q list
}

ClassMethod GetIdByPath(path)
{
	q:path="" ""
	d ##class(Util).ResolvePath(path,.nspath,.name,.type)
	q:( (type="") || ($zcvt(type,"U")'="D") || (name="") ) ""
	s nsid=##class(Namespace).GetIdByPath("DI:"_nspath)
	s name=" "_$zcvt(name,"U")
	q:( (nsid="") || ( '$d(^DHCWL.DM.T.DimBaseI("MainI",nsid)) ) || ( '$d(^DHCWL.DM.T.DimBaseI("MainI",nsid,name)) ) ) ""
	q $o(^DHCWL.DM.T.DimBaseI("MainI",nsid,name,""))
}

// s obj=##class(DHCWL.DM.T.DimBase).GetByPath("/Department.d")

ClassMethod GetByPath(path) As DimBase
{
	q:path="" ""
	s id=..GetIdByPath(path)
	q:id="" ""
	q ##class(DimBase).%OpenId(id)
}

Method GetProperties() As %ListOfObjects
{
	q ##class(DimProperty).GetProperties(..%Id())
}

Method GetProperty(code) As DimProperty
{
	q ##class(DimProperty).GetProperty(..%Id(),code)
}

Method CheckPropertyValid(proCode) As %Status
{
  s pro=..GetProperty(proCode)
  q pro.CheckInvalid()
}

Method GetStructMap() As %ListOfObjects
{
	q ##class(DimDStructMap).GetDimStructByDimId(..%Id())
}

Method GetProStruct() As %List
{
	q ##class(DimDStructMap).GetDimProStruct(..%Id())
}

Method GetMaxSN() As %Integer
{
	q ##class(DimDStructMap).GetMaxSN(..%Id())
}

Method GetPath() As %String
{
	q ..Namespace.GetPath()_..Code_".d"
}

Method GetSQLRef() As %String
{
	i ..Namespace.IsRoot() {
		q ""_..Code
	}else{
		s path=..Namespace.GetPath()
		s path=$e(path,2,$l(path)-1)
		s l=$l(path)
		s sn=""
		f i=1:1:l {
			i $e(path,i)="/" {
				s sn=sn_"_"
			}else{
				s sn=sn_$e(path,i)
			}
		}
		q ""_sn_"_"_..Code
	}
}

Method GetFetchSQL() As %String
{
	q "SELECT "_##class(DimProperty).GetFetchSelect(..%Id())_" FROM "_..LinkedMetaDim.GetSQLRef()
}

Method GetMetaSQL() As %String
{
	q "SELECT "_##class(DimProperty).GetFetchSelect(..%Id())_" FROM "_..LinkedMetaDim.GetSQLRef()_" WHERE 1=0"
}

Storage Default
{
<Data name="DimBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Namespace</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>LinkedMetaDim</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
<Value name="7">
<Value>Creator</Value>
</Value>
<Value name="8">
<Value>CreatedDate</Value>
</Value>
<Value name="9">
<Value>RowKeyFields</Value>
</Value>
<Value name="10">
<Value>UpdateDate</Value>
</Value>
<Value name="11">
<Value>UsageStatus</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.DimBaseD</DataLocation>
<DefaultData>DimBaseDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.DimBaseD</IdLocation>
<IndexLocation>^DHCWL.DM.T.DimBaseI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.DimBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
