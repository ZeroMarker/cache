Class DHCWL.DM.T.DimProperty Extends %Persistent
{

Property DimBase As DimBase [ Required ];

// 只能由字母,数字或者下划线组成，且必须是字母开头

Property Code As %String [ Required ];

Property Name As %String;

Property Description As %String(MAXLEN = 512, TRUNCATE = 1);

Property DataType As DataType;

// Attached="DIM"

/// 当DIM:STCPROFUN类型的时候需要调用DimBase的CheckPropertyValid方法检验配置是否正确
/// 当DIM:STCPROFUN和DIM:DYNPROFUN时Expression是FunctionConfig中的Name
/// 当DIM:DYNPROFUN类型时不支持定义linkedPath
Property CreatedType As TypeConfig [ Required ];

Property Expression As %String(MAXLEN = 512);

Property IsLinked As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required ];

// only IsLinked="Y"时有效

Property LinkedPath As %String;

Property Status As %String(DISPLAYLIST = ",Active,NoUsed", MAXLEN = 2, TRUNCATE = 1, VALUELIST = ",AC,NS");

Index MainI On (DimBase, Code) [ PrimaryKey ];

Trigger AftInsertTri [ Event = INSERT, Time = AFTER ]
{
	n id,dimId,tid,exp,status
	s id={%%ID}
	i id'="" {
	  s dimId={DimBase} ;$lg(^DHCWL.DM.T.DimPropertyD(id),2)
	  s tid={DataType}
	  s exp={Expression}
	  ;s status=..CheckInvalid(tid,exp)
	  d ##class(DimDStructMap).Add(dimId,id)
	}
}

Trigger AftDeleteTri [ Event = DELETE, Time = AFTER ]
{
	n id,dimId
	s id={%%ID}
	i id'="" d
	.s dimId={DimBase} ;$lg(^DHCWL.DM.T.DimPropertyD(id),2)
	.d ##class(DimDStructMap).Delete(dimId,id)
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
    ;s status=..CheckInvalid(..CreatedType.%Id(),..Expression)
    d ##class(DimDStructMap).Add(..DimBase.%Id(),..%Id())
    q $$$OK
}

/// 定义好一个维度属性后要调用该方法检验。
Method CheckInvalid() As %Status
{
	q:..CreatedType="" $$$OK
	s tp=..CreatedType.Code
	q:(tp'="STCPROFUN")||(tp'="DYNPROFUN") $$$OK
	s fun=##class(FunctionConfig).GetByPath("DIMPRO:"_..Expression)
	q:fun="" $$$OK
	s params=fun.Parameters()
	s pl=params.Count()
	s status=$$$OK
	f i=1:1:pl{
	  s param=params.GetAt(i)
	  s pt=param.ParamType
	  continue:pt=""
	  s ptp=pt.Code
	  if tp="STCPROFUN"{
		i ((ptp="EVALPASSBYPOS")||(ptp="CONSTANTEVALPASS")){
		  s status=$$$ERROR("Property Function's params type can't EVALPASSBYPOS or CONSTANTEVALPASS")
		  q
	    }
	  }
	  
	}
	q status
}

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{
    s obj=##class(DimProperty).%Open(oid)
    s id=obj.%Id()
    s dimId=obj.DimBase.%Id()
    q ##class(DimDStructMap).Delete(dimId,id)
}

// d ##class(DHCWL.DM.T.DimProperty).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.DimProperty)
	k ^DHCWL.DM.T.DimPropertyD,^DHCWL.DM.T.DimPropertyI
	&sql(delete DHCWL_DM_T.DimDStructMap)
	k ^DHCWL.DM.T.DimDStructMapD,^DHCWL.DM.T.DimDStructMapI
	s base=##class(DimBase).GetByPath("/Department.d")
	s dpmp=##class(TypeConfig).GetByPath("DIM:DPMP")
	s bsed=##class(TypeConfig).GetByPath("DIM:BSED")
	
	s obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="RowID",obj.Name="科室RowID",obj.Description="科室RowID" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="CTLOC_RowID", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="Code",obj.Name="科室编码",obj.Description="科室名称汉语拼音首字母编码" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="CTLOC_Code", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="Name",obj.Name="科室名称",obj.Description="科室名称" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="CTLOC_Desc", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="LPYM",obj.Name="首字母",obj.Description="名称拼音首字母小写" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=bsed,obj.Expression="LOWER(CTLOC_ContactName)", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="PYLen",obj.Name="字母长度",obj.Description="名称首字母长度" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=bsed,obj.Expression="CHAR_LENGTH(CTLOC_ContactName)", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="Hospital",obj.Name="院区",obj.Description="科室所属院区" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="CTLOC_Hospital_DR", obj.IsLinked="Y",obj.LinkedPath="/Hospital.d"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="StaticProFunTest",obj.Name="静态属性函数数据测试",obj.Description="调用函数生成数据测试" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=##class(TypeConfig).GetByPath("DIM:STCPROFUN"),obj.Expression="Test2", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="DynamicProFunTest",obj.Name="动态属性函数数据测试",obj.Description="属性函数测试" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=##class(TypeConfig).GetByPath("DIM:DYNPROFUN"),obj.Expression="Test", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="Type",obj.Name="科室类型",obj.Description="科室类型" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="CTLOC_Type", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="IsWard",obj.Name="是否为病区",obj.Description="是否为病区" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="	CTLOC_WardFlag", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	
	
	
	s base=##class(DimBase).GetByPath("/Hospital.d")
	s obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="RowID",obj.Name="RowID",obj.Description="医院RowID" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="HOSP_RowId", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="Code",obj.Name="名称首字母",obj.Description="医院名称首字母" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="HOSP_Code", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="Name",obj.Name="名称",obj.Description="医院名称" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="HOSP_Desc", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	
	
	///*
	s base=##class(DimBase).GetByPath("/Doctor.d")
	s obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="RowID",obj.Name="RowID",obj.Description="医生RowID" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="CTPCP_RowId", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	
	s base=##class(DimBase).GetByPath("/Doctor.d")
	s obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="Code",obj.Name="编号",obj.Description="医生编号" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="CTPCP_Code", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	
	s base=##class(DimBase).GetByPath("/Doctor.d")
	s obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="Name",obj.Name="姓名",obj.Description="医生姓名" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="CTPCP_Desc", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	//*/
}

ClassMethod GetProperties(parentId) As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	q:'$d(^DHCWL.DM.T.DimPropertyI("MainI",parentId)) list
	s code="" f{
	  s code=$o(^DHCWL.DM.T.DimPropertyI("MainI",parentId,code))
	  q:code=""
	  s id=$o(^DHCWL.DM.T.DimPropertyI("MainI",parentId,code,""))
	  s obj=##class(DimProperty).%OpenId(id)
	  q:obj=""
	  d list.Insert(obj)
	}
	
	q list
}

ClassMethod GetProperty(parentId, code) As DimProperty
{
	q ##class(DimProperty).%OpenId(..GetPropertyId(parentId,code))
}

ClassMethod GetPropertyId(parentId, code)
{
	s code=" "_$zcvt(code,"U")
	q:( ('$d(^DHCWL.DM.T.DimPropertyI("MainI",parentId))) || ('$d(^DHCWL.DM.T.DimPropertyI("MainI",parentId,code))) ) ""
	q $o(^DHCWL.DM.T.DimPropertyI("MainI",parentId,code,""))
}

ClassMethod GetMetaSelect(parentId) As %ListOfDataTypes
{
	s list=##class(%ListOfDataTypes).%New()
	q list
	q:( (parentId="") || ('$d(^DHCWL.DM.T.DimPropertyI("MainI",parentId))) ) list
	s sel="",num=0
	s c="" f  s c=$o( ^DHCWL.DM.T.DimPropertyI("MainI",parentId,c) ) q:c=""  d
	.s id=$o( ^DHCWL.DM.T.DimPropertyI("MainI",parentId,c,"") )
	.s obj=##class(DimProperty).%OpenId(id)
	.s dimType=obj.CreatedType.Code
	.i ((dimType="STCPROFUN")||(dimType="DYNPROFUN")) d
	..d list.Insert(obj.Code)
	q list
}

ClassMethod GetFetchSelect(parentId) As %String
{
	q:( (parentId="") || ('$d(^DHCWL.DM.T.DimPropertyI("MainI",parentId))) ) ""
	s sel="",num=0
	s c="" f  s c=$o( ^DHCWL.DM.T.DimPropertyI("MainI",parentId,c) ) q:c=""  d
	.s id=$o( ^DHCWL.DM.T.DimPropertyI("MainI",parentId,c,"") )
	.s obj=##class(DimProperty).%OpenId(id)
	.s dimType=obj.CreatedType.Code
	.q:((dimType="STCPROFUN")||(dimType="DYNPROFUN")||(dimType="DYCDIMPRO"))
	.s num=num+1
	.s:num>1 sel=sel_", "
	.s sel=sel_obj.Expression_" AS "_obj.Code
	q sel
}

Method GetUsingParameters(funConfig As FunctionConfig) As %ListOfObjects
{
	s master="DHCWL.DM.T.DimProperty:"_..%Id()
	s list=funConfig.Parameters()
	f i=1:1:list.Count(){
	  s obj=list.GetAt(i)
	  s pi=obj.%Id()
	  s pu=##class(FunParaUsing).GetInstance(master,pi)
	  continue:pu=""
	  s obj.Name=pu.ParaValue
	}
	q list
}

Storage Default
{
<Data name="DimPropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DimBase</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>DataType</Value>
</Value>
<Value name="7">
<Value>CreatedType</Value>
</Value>
<Value name="8">
<Value>Expression</Value>
</Value>
<Value name="9">
<Value>IsLinked</Value>
</Value>
<Value name="10">
<Value>LinkedPath</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.DimPropertyD</DataLocation>
<DefaultData>DimPropertyDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.DimPropertyD</IdLocation>
<IndexLocation>^DHCWL.DM.T.DimPropertyI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.DimPropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
