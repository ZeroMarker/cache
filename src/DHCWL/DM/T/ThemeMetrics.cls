Class DHCWL.DM.T.ThemeMetrics Extends %Persistent
{

Property ThemeBase As ThemeBase [ Required ];

Property SrcFetchConfig As ThemeFetchConfig [ Required ];

Property SrcMeta As MetaTableBase [ Required ];

//只能由字母,数字或者下划线组成，且必须是字母开头

Property Code As %String [ Required ];

Property Name As %String;

Property Description As %String;

Property DataType As DataType [ Required ];

Property SrcField As MetaTablePro;

//Property ProExpression As %String(MAXLEN = 256);

Property UpdateDate As %Integer;

Property SerialNumber As %Integer;

Property Status As %String(DISPLAYLIST = ",Active,NoUsed", MAXLEN = 2, TRUNCATE = 1, VALUELIST = ",AC,NS");

/// Attached="TM"
/// MetricType可能的值为：LM,EM,STCPROFUN（静态函数调用）,DYNPROFUN（动态函数调用）
Property MetricType As TypeConfig;

/// 当MetricType="ED"时ProExpression保存度量的计算表达式（SQL语法）
Property ProExpression As %String(MAXLEN = 256);

Index MainI On (ThemeBase, Code) [ PrimaryKey ];

Index FetchMetaI On (ThemeBase, SrcFetchConfig, SrcMeta);

// d ##class(DHCWL.DM.T.ThemeMetrics).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.ThemeMetrics)
	k ^DHCWL.DM.T.ThemeMetricsD,^DHCWL.DM.T.ThemeMetricsI
	s base=##class(ThemeBase).GetByPath("/workload.t")
	s base2=##class(ThemeBase).GetByPath("/workload2.t")
	s base4=##class(ThemeBase).GetByPath("/WorkLoad4.t")
	s mf=##class(MetaTableBase).GetByPath("/workload.mf")
	//s wlallmf=##class(MetaTableBase).GetByPath("/WorkLoadAlll.mf")
	
	s obj=##class(ThemeMetrics).%New()
	s obj.ThemeBase=base,obj.Code="Quantity",obj.Name="数量",obj.Description="数量",obj.DataType=mf.GetProperty("WorkLoad_Quantity").DataType
	s obj.SrcField=mf.GetProperty("WorkLoad_Quantity")
	s obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeMetrics).%New()
	s obj.ThemeBase=base,obj.Code="Price",obj.Name="金额",obj.Description="金额",obj.DataType=mf.GetProperty("WorkLoad_TotalPrice").DataType
	s obj.SrcField=mf.GetProperty("WorkLoad_TotalPrice") 
	s obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeMetrics).%New()
	s obj.ThemeBase=base,obj.Code="UnitPrice",obj.Name="单价",obj.Description="单价",obj.DataType=mf.GetProperty("WorkLoad_TotalPrice").DataType
	s obj.SrcField=mf.GetProperty("WorkLoad_UnitPrice") 
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	
	
	s obj=##class(ThemeMetrics).%New()
	s obj.ThemeBase=base2,obj.Code="Quantity",obj.Name="数量",obj.Description="数量",obj.DataType=mf.GetProperty("WorkLoad_Quantity").DataType
	s obj.SrcField=mf.GetProperty("WorkLoad_Quantity")
	s obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeMetrics).%New()
	s obj.ThemeBase=base2,obj.Code="Price",obj.Name="金额",obj.Description="金额",obj.DataType=mf.GetProperty("WorkLoad_TotalPrice").DataType
	s obj.SrcField=mf.GetProperty("WorkLoad_TotalPrice") 
	s obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeMetrics).%New()
	s obj.ThemeBase=base2,obj.Code="UnitPrice",obj.Name="单价",obj.Description="单价",obj.DataType=mf.GetProperty("WorkLoad_TotalPrice").DataType
	s obj.SrcField=mf.GetProperty("WorkLoad_UnitPrice") 
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	
	s obj=##class(ThemeMetrics).%New()
	s obj.ThemeBase=base4,obj.Code="unitPrice",obj.Name="单价",obj.Description="单价",obj.DataType=mf.GetProperty("WORKLOAD_UNITPRICE").DataType
	s obj.SrcField=mf.GetProperty("WORKLOAD_UNITPRICE") 
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeMetrics).%New()
	s obj.ThemeBase=base4,obj.Code="quantity",obj.Name="数量",obj.Description="数量",obj.DataType=mf.GetProperty("WORKLOAD_QUANTITY").DataType
	s obj.SrcField=mf.GetProperty("WORKLOAD_QUANTITY") 
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeMetrics).%New()
	s obj.ThemeBase=base4,obj.Code="titalPrice",obj.Name="费用",obj.Description="费用",obj.DataType=mf.GetProperty("WORKLOAD_TOTALPRICE").DataType
	s obj.SrcField=mf.GetProperty("WORKLOAD_TOTALPRICE") 
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeMetrics).%New()
	s obj.ThemeBase=base4,obj.Code="payorPrice",obj.Name="WORKLOAD_PAYORPRICE",obj.Description="WORKLOAD_PAYORPRICE",obj.DataType=mf.GetProperty("WORKLOAD_PAYORPRICE").DataType
	s obj.SrcField=mf.GetProperty("WORKLOAD_PAYORPRICE") 
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeMetrics).%New()
	s obj.ThemeBase=base4,obj.Code="discPrice",obj.Name="WORKLOAD_DISCPRICE",obj.Description="WORKLOAD_DISCPRICE",obj.DataType=mf.GetProperty("WORKLOAD_DISCPRICE").DataType
	s obj.SrcField=mf.GetProperty("WORKLOAD_DISCPRICE") 
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeMetrics).%New()
	s obj.ThemeBase=base4,obj.Code="pasharePrice",obj.Name="WORKLOAD_PASHAREPRICE",obj.Description="WORKLOAD_PASHAREPRICE",obj.DataType=mf.GetProperty("WORKLOAD_PASHAREPRICE").DataType
	s obj.SrcField=mf.GetProperty("WORKLOAD_PASHAREPRICE") 
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	/*
	s wlall=##class(ThemeBase).GetByPath("/WorkLoadAlll.t")
	s wlallmf=##class(MetaTableBase).GetByPath("/WorkLoadAlll.mf")
	s obj=##class(ThemeMetrics).%New()
	s obj.ThemeBase=wlall,obj.Code="WL_TOTALPRICE",obj.Name="WL_TOTALPRICE",obj.Description="WL_TOTALPRICE",obj.DataType=wlallmf.GetProperty("WL_TOTALPRICE").DataType
	s obj.SrcField=wlallmf.GetProperty("WL_TOTALPRICE") 
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/WorkLoadAlll.t",1),obj.SrcMeta=wlallmf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeMetrics).%New()
	s obj.ThemeBase=wlall,obj.Code="WL_UNITPRICE",obj.Name="WL_UNITPRICE",obj.Description="WL_UNITPRICE",obj.DataType=wlallmf.GetProperty("WL_UNITPRICE").DataType
	s obj.SrcField=wlallmf.GetProperty("WL_UNITPRICE") 
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/WorkLoadAlll.t",1),obj.SrcMeta=wlallmf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeMetrics).%New()
	s obj.ThemeBase=wlall,obj.Code="WL_DISCPRICE",obj.Name="WL_DISCPRICE",obj.Description="WL_DISCPRICE",obj.DataType=wlallmf.GetProperty("WL_DISCPRICE").DataType
	s obj.SrcField=wlallmf.GetProperty("WL_DISCPRICE") 
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/WorkLoadAlll.t",1),obj.SrcMeta=wlallmf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeMetrics).%New()
	s obj.ThemeBase=wlall,obj.Code="WL_PAYORPRICE",obj.Name="WL_PAYORPRICE",obj.Description="WL_PAYORPRICE",obj.DataType=wlallmf.GetProperty("WL_PAYORPRICE").DataType
	s obj.SrcField=wlallmf.GetProperty("WL_PAYORPRICE") 
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/WorkLoadAlll.t",1),obj.SrcMeta=wlallmf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeMetrics).%New()
	s obj.ThemeBase=wlall,obj.Code="WL_QUANTITY",obj.Name="WL_QUANTITY",obj.Description="WL_QUANTITY",obj.DataType=wlallmf.GetProperty("WL_QUANTITY").DataType
	s obj.SrcField=wlallmf.GetProperty("WL_QUANTITY") 
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/WorkLoadAlll.t",1),obj.SrcMeta=wlallmf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeMetrics).%New()
	s obj.ThemeBase=wlall,obj.Code="WL_PASHAREPRICE",obj.Name="WL_PASHAREPRICE",obj.Description="WL_PASHAREPRICE",obj.DataType=wlallmf.GetProperty("WL_PASHAREPRICE").DataType
	s obj.SrcField=wlallmf.GetProperty("WL_PASHAREPRICE") 
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/WorkLoadAlll.t",1),obj.SrcMeta=wlallmf
	d obj.%Save()
	w obj.%Id(),","
	*/
}

Trigger AftInsertTri [ Event = INSERT, Time = AFTER ]
{
	n id
	s id={%%ID}
	n sn,themeId,date
	i id'="" d
	.s date=$p($h,",",1)
	.s themeId=$lg(^DHCWL.DM.T.ThemeMetricsD(id),2)
	.s sn=..ComputeSN(themeId)
	.&sql(update DHCWL_DM_T.ThemeMetrics set SerialNumber=:sn,UpdateDate=:date where ID=:id)
}

Method %OnBeforeSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
    s:+..SerialNumber=0 ..SerialNumber=..ComputeSN(..ThemeBase.%Id())
    s ..UpdateDate=$p($h,",",1)
    q $$$OK
}

ClassMethod GetMetricId(parentId, code) As %String
{
	s code=" "_$zcvt(code,"U")
	q:( ('$d(^DHCWL.DM.T.ThemeMetricsI("MainI",parentId))) || ('$d(^DHCWL.DM.T.ThemeMetricsI("MainI",parentId,code))) ) ""
	q $o(^DHCWL.DM.T.ThemeMetricsI("MainI",parentId,code,""))
}

ClassMethod GetMetrics(parentId) As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	q:parentId="" list
	q:'$d(^DHCWL.DM.T.ThemeMetricsI("MainI",parentId)) list
	s code="" f{
	  s code=$o(^DHCWL.DM.T.ThemeMetricsI("MainI",parentId,code))
	  q:code=""
	  s id=$o(^DHCWL.DM.T.ThemeMetricsI("MainI",parentId,code,""))
	  s obj=##class(ThemeMetrics).%OpenId(id)
	  continue:obj=""
	  d list.Insert(obj)
	}
	q list
}

ClassMethod GetMetric(parentId, code) As ThemeMetrics
{
	s code=" "_$zcvt(code,"U")
	q:( ('$d(^DHCWL.DM.T.ThemeMetricsI("MainI",parentId))) || ('$d(^DHCWL.DM.T.ThemeMetricsI("MainI",parentId,code))) ) ""
	s id=$o(^DHCWL.DM.T.ThemeMetricsI("MainI",parentId,code,""))
	q ##class(ThemeMetrics).%OpenId(id)
}

ClassMethod ComputeSN(themeId) As %Integer
{
	q:'$d( ^DHCWL.DM.T.ThemeMetricsI("MainI",themeId) ) 1
	s max=0
	s code="" f  s code=$o( ^DHCWL.DM.T.ThemeMetricsI("MainI",themeId,code) ) q:code=""  d
	.s id=$o( ^DHCWL.DM.T.ThemeMetricsI("MainI",themeId,code,"") )
	.s sn=$lg(^DHCWL.DM.T.ThemeMetricsD(id),12)
	.i sn>max s max=sn
	q max+1
}

ClassMethod GetMaxSN(themeId) As %Integer
{
	q:'$d( ^DHCWL.DM.T.ThemeMetricsI("MainI",themeId) ) 1
	s max=0
	s code="" f  s code=$o( ^DHCWL.DM.T.ThemeMetricsI("MainI",themeId,code) ) q:code=""  d
	.s id=$o( ^DHCWL.DM.T.ThemeMetricsI("MainI",themeId,code,"") )
	.s sn=$lg(^DHCWL.DM.T.ThemeMetricsD(id),12)
	.i sn>max s max=sn
	q max
}

// s list=##class(DHCWL.DM.T.ThemeMetrics).GetMetricStruct(1)

ClassMethod GetMetricStruct(themeId, metricId = "") As %List
{
	if (metricId'=""){
	  s obj=##class(ThemeMetrics).%OpenId(metricId)
	  q:obj="" $lb()
	  s dt=8
	  if obj.DataType'="" s dt=obj.DataType.JDBCTypeCodeNum
	  s list= $lb(obj.Code,obj.SerialNumber,metricId,dt)	
	  s obj=""
	  q list
	}
	s list=$lb(),i=0
	q:'$d(^DHCWL.DM.T.ThemeMetricsI("MainI",themeId)) list
	s code="" f  s code=$o(^DHCWL.DM.T.ThemeMetricsI("MainI",themeId,code)) q:code=""  d
	.s id=$o( ^DHCWL.DM.T.ThemeMetricsI("MainI",themeId,code,"") )
	.s obj=##class(ThemeMetrics).%OpenId(id)
	.q:obj=""
	.s i=i+1
	.s $list(list,i)=obj.Code
	.s i=i+1
	.s $list(list,i)=obj.SerialNumber
	.s i=i+1
	.s $list(list,i)=id
	.s i=i+1
	.s dt=8
	.i obj.DataType'="" d
	..s dt=obj.DataType.JDBCTypeCodeNum
	.s $list(list,i)=dt
	q list
}

// w ##class(DHCWL.DM.T.ThemeMetrics).GetMetricsString(1)

ClassMethod GetMetricsString(themeId) As %String
{
	q:'$d( ^DHCWL.DM.T.ThemeMetricsI("MainI",themeId) ) ""
	s sel="",num=0
	s code="" f  s code=$o( ^DHCWL.DM.T.ThemeMetricsI("MainI",themeId,code) ) q:code=""  d
	.s id=$o( ^DHCWL.DM.T.ThemeMetricsI("MainI",themeId,code,"") )
	.q:'$d(^DHCWL.DM.T.ThemeMetricsD(id))
	.s code2=$lg(^DHCWL.DM.T.ThemeMetricsD(id),5)
	.s num=num+1
	.s:num>1 sel=sel_","
	.s sel=sel_"{""code"":"""_code2_"""}"
	q sel
}

ClassMethod GetMetricSelect(themeId) As %String
{
	q:'$d( ^DHCWL.DM.T.ThemeMetricsI("MainI",themeId) ) ""
	s sel="",num=0
	s code="" f  s code=$o( ^DHCWL.DM.T.ThemeMetricsI("MainI",themeId,code) ) q:code=""  d
	.s id=$o( ^DHCWL.DM.T.ThemeMetricsI("MainI",themeId,code,"") )
	.q:'$d(^DHCWL.DM.T.ThemeMetricsD(id))
	.s obj=##class(ThemeMetrics).%OpenId(id)
	.q:obj=""
	.s exp="t"_obj.SrcFetchConfig.%Id()_"."_obj.Code
	.;s c2=$lg(^DHCWL.DM.T.ThemeMetricsD(id),5)
	.s num=num+1
	.s:num>1 sel=sel_", "
	.s sel=sel_exp
	q sel
}

// w ##class(DHCWL.DM.T.ThemeMetrics).GetSrcMetaSelect(1,1)

ClassMethod GetFetchSelect(themeId, fetchConfigId) As %String
{
	q:( ( '$d( ^DHCWL.DM.T.ThemeMetricsI("FetchMetaI",themeId) ) ) || ( '$d( ^DHCWL.DM.T.ThemeMetricsI("FetchMetaI",themeId,fetchConfigId) ) )) ""
	s select=""
	s num=0
	s srcMeta=""
	s srcMetaId=$o( ^DHCWL.DM.T.ThemeMetricsI("FetchMetaI",themeId,fetchConfigId,"") )
	s id="" f  s id=$o( ^DHCWL.DM.T.ThemeMetricsI("FetchMetaI",themeId,fetchConfigId,srcMetaId,id) ) q:id=""  d
	.s obj=##class(ThemeMetrics).%OpenId(id)
	.q:obj=""
	.s mtpath=""
	.i obj.MetricType'="" d
	..s mtpath=obj.MetricType.GetPath()
	.i mtpath="TD:STCPROFUN" d
	..q
	.e  i mtpath="TD:STCPROFUN" d 
	..q
	.e  i mtpath="TD:ED" d
	..s exp=obj.ProExpression_" AS "_obj.Code
	.e  d
	..s exp=obj.SrcField.Code_" AS "_obj.Code
	..d BuildExp
	q select ;"SELECT "_select_" FROM "_srcMeta.GetSQLRef
BuildExp
    s num=num+1
    s:num>1 select=select_", "
    s select=select_exp
    q
}

Method GetUsingParameters(funConfig As FunctionConfig) As %ListOfObjects
{
	s master="DHCWL.DM.T.ThemeMetrics:"_..%Id()
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

Method GetJDBCTypeCodeNum() As %Integer [ CodeMode = expression ]
{
..DataType.JDBCTypeCodeNum
}

Storage Default
{
<Data name="ThemeMetricsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ThemeBase</Value>
</Value>
<Value name="3">
<Value>SrcFetchConfig</Value>
</Value>
<Value name="4">
<Value>SrcMeta</Value>
</Value>
<Value name="5">
<Value>Code</Value>
</Value>
<Value name="6">
<Value>Name</Value>
</Value>
<Value name="7">
<Value>Description</Value>
</Value>
<Value name="8">
<Value>DataType</Value>
</Value>
<Value name="9">
<Value>SrcField</Value>
</Value>
<Value name="10">
<Value>ProExpression</Value>
</Value>
<Value name="11">
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>SerialNumber</Value>
</Value>
<Value name="13">
<Value>Status</Value>
</Value>
<Value name="14">
<Value>MetricType</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.ThemeMetricsD</DataLocation>
<DefaultData>ThemeMetricsDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.ThemeMetricsD</IdLocation>
<IndexLocation>^DHCWL.DM.T.ThemeMetricsI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.ThemeMetricsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
