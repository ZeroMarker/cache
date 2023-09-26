Class DHCWL.DM.T.ThemeBase Extends %Persistent
{

Property Namespace As Namespace;

// 只能由字母,数字或者下划线组成，且必须是字母开头

Property Code As %String [ Required ];

Property Name As %String;

Property Description As %String(MAXLEN = 512, TRUNCATE = 1);

Property Creator As %String;

Property CreatedDate As %Integer;

Property NeedStore As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required ];

// split by "," the field of RowIdFields must be seted;the value is MetaTablePro's Code

// 必须要设置该字段的值

Property RowKeyFields As %String;

Property UsageStatus As %String(DISPLAYLIST = ",Active,Deprecated,", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",A,D");

Index MainI On (Namespace, Code) [ PrimaryKey ];

// d ##class(DHCWL.DM.T.ThemeBase).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.ThemeBase)
	k ^DHCWL.DM.T.ThemeBaseD,^DHCWL.DM.T.ThemeBaseI
	q
	s ns=##class(Namespace).ThemeNamespace("/")
	s obj=##class(ThemeBase).%New()
	s obj.Namespace=ns,obj.Code="Workload",obj.Name="收入",obj.Description="总收入主题",obj.Creator="lhh",obj.CreatedDate=+$p($h,",",1)
	s obj.RowKeyFields="WLRowId",obj.NeedStore="N"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeBase).%New()
	s obj.Namespace=ns,obj.Code="Workload2",obj.Name="收入2",obj.Description="总收入主题2",obj.Creator="lhh",obj.CreatedDate=+$p($h,",",1)
	s obj.RowKeyFields="WLRowId",obj.NeedStore="N"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeBase).%New()
	s obj.Namespace=ns,obj.Code="Workload3",obj.Name="收入3",obj.Description="总收入主题3",obj.Creator="lhh",obj.CreatedDate=+$p($h,",",1)
	s obj.RowKeyFields="WLRowId",obj.NeedStore="N"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeBase).%New()
	s obj.Namespace=ns,obj.Code="Workload4",obj.Name="收入4",obj.Description="总收入主题4",obj.Creator="lhh",obj.CreatedDate=+$p($h,",",1)
	s obj.RowKeyFields="WLRowId",obj.NeedStore="N"
	d obj.%Save()
	w obj.%Id(),","
}

ClassMethod BuildThemeFromMeta(metaPath, sheduleField, dimList As %List, metricList As %List) As ThemeBase
{
	s meta=##class(MetaTableBase).GetByPath(metaPath)
	s themePath=meta.Namespace.GetPath()_meta.Code_".t"
	s theme=##class(ThemeBase).GetByPath(themePath)
	if theme=""{
	  s theme=##class(ThemeBase).%New()
	}
	s theme.Namespace=##class(Namespace).ThemeNamespace(meta.Namespace.GetPath()) ,theme.Code=meta.Code
	s theme.Name=meta.Name,theme.Description=meta.Description,theme.Creator=meta.Creator,theme.CreatedDate=+$p($h,",",1)
	s theme.NeedStore="N"
	s status=  theme.%Save()
	w:status'=$$$OK status,!
	s fetchConfig=##class(ThemeFetchConfig).GetAt(themePath,1)
	if fetchConfig=""{
		s fetchConfig=##class(ThemeFetchConfig).%New()
	}
	s fetchConfig.ThemeBase=theme,fetchConfig.FactMetaTable=meta,fetchConfig.LinkPosition=1
	s status= fetchConfig.%Save()
	w:status'=$$$OK status,!
	s filter=##class(ThemeFetchFilter).GetAt(fetchConfig.%Id(),1)
	if filter=""{
		s filter=##class(ThemeFetchFilter).%New()
	}
	s filter.FetchBase=fetchConfig,filter.FilterField=meta.GetProperty(sheduleField)
	s filter.FilterFunction="=",filter.FilterParam="@scheduleDate"
	s filter.ExecuteOrder=1,filter.JoinLogicalForAfter="",filter.HasNotLogical="N"
	s status= filter.%Save()
	w:status'=$$$OK status,!
	f i=1:1:$ll(dimList){
    s dimCode=$lg(dimList,i,"")
    continue:dimCode=""
    s pro=meta.GetProperty(dimCode)
    continue:pro=""
    s dim=theme.GetDim(dimCode)
    if dim=""{
	    s dim=##class(ThemeDims).%New()
    }
	  s dim.ThemeBase=theme,dim.Code=pro.Code,dim.Name=pro.Name ,dim.DataType=pro.DataType,dim.Description=pro.Description
	  s dim.DimType=##class(TypeConfig).GetByPath("TD:LD"),dim.SrcField=pro,dim.UpdateDate=+$p($h,",",1)
	  s dim.SrcFetchConfig=fetchConfig,dim.SrcMeta=meta
	  s status= dim.%Save()
	  If $$$ISERR(status) {
		  w "error with code:"_dimCode,!
			Do DecomposeStatus^%apiOBJ(status,.err,"-d")
			For i=1:1:err Write err(i),! 
			q
	  }
	}
	f i=1:1:$ll(metricList){
	  s metricCode=$lg(metricList,i,"")
	  continue:metricCode=""
	  s pro=meta.GetProperty(metricCode)
	  continue:pro=""
	  s metric=theme.GetMetric(metricCode)
	  if (metric=""){
		  s metric=##class(ThemeMetrics).%New()
	  }
	  s metric.Code=pro.Code,metric.Name=pro.Name,metric.DataType=pro.DataType,metric.Description=pro.Description
	  s metric.SrcFetchConfig=fetchConfig,metric.SrcField=pro,metric.UpdateDate=+$h
	  s metric.SrcMeta=meta,metric.ThemeBase=theme
	  s status= metric.%Save()
	  If $$$ISERR(status) {
		  w "error with code:"_metricCode,!
			Do DecomposeStatus^%apiOBJ(status,.err,"-d")
			For i=1:1:err Write err(i),! 
			q
	  }
	}
	
	q theme
}

// s list= ##class(DHCWL.DM.T.ThemeBase).GetAll()

ClassMethod GetAll(usageStatus As %String = "A") As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	s nsid="" f  s nsid=$o(^DHCWL.DM.T.ThemeBaseI("MainI",nsid)) q:nsid=""  d
	.s name="" f  s name=$o(^DHCWL.DM.T.ThemeBaseI("MainI",nsid,name)) q:name=""  d
	..s id=$o(^DHCWL.DM.T.ThemeBaseI("MainI",nsid,name,""))
	..q:'$d(^DHCWL.DM.T.ThemeBaseD(id))
	..s obj=##class(ThemeBase).%OpenId(id)
	..q:((obj.UsageStatus'="")&&(obj.UsageStatus'=usageStatus))
	..d list.Insert(obj)
	q list
}

ClassMethod GetIdByPath(path)
{
	if $d(^DHCWL.DM.T.ThemeBaseD(path)){
	  q path
	}
	d ##class(Util).ResolvePath(path,.nspath,.name,.type)
	q:$zcvt(type,"U")'="T" ""
	s nsid=##class(Namespace).GetIdByPath("TH:"_nspath)
	s name=" "_$zcvt(name,"U")
	q:( ('$d(^DHCWL.DM.T.ThemeBaseI("MainI",nsid))) ||('$d(^DHCWL.DM.T.ThemeBaseI("MainI",nsid,name))) ) ""
	q $o(^DHCWL.DM.T.ThemeBaseI("MainI",nsid,name,""))
}

// s obj=##class(DHCWL.DM.T.ThemeBase).GetByPath("/DHCWorkLoad.t")

ClassMethod GetByPath(path) As ThemeBase
{
	q ##class(ThemeBase).%OpenId(##class(ThemeBase).GetIdByPath(path))
}

ClassMethod DeleteByPath(path) As %Status
{
	s id=..GetIdByPath(path)
	q:id="" $$$ERROR("The path "_path_" is not exists!")
	s status=##class(CubeBase).DeleteByThemePath(path)
	q:status'=$$$OK status
	&sql(delete DHCWL_DM_T.ThemeDims where ThemeBase=:id)
	q:((SQLCODE'=0)&&(SQLCODE'=100)) $$$ERROR("SQLCODE="_SQLCODE)
	&sql(delete DHCWL_DM_T.ThemeMetrics where ThemeBase=:id)
	q:((SQLCODE'=0)&&(SQLCODE'=100)) $$$ERROR("SQLCODE="_SQLCODE)
	&sql(delete DHCWL_DM_T.ThemeBase where ID=:id)
	q:((SQLCODE'=0)&&(SQLCODE'=100)) $$$ERROR("SQLCODE="_SQLCODE)
	q $$$OK
}

Method GetDims() As %ListOfObjects
{
	q ##class(ThemeDims).GetDims(..%Id())
}

Method GetDim(code) As ThemeDims
{
	q ##class(ThemeDims).GetDim(..%Id(),code)
}

Method GetMetrics(code) As %ListOfObjects
{
	q ##class(ThemeMetrics).GetMetrics(..%Id())
}

Method GetMetric(code) As ThemeMetrics
{
	q ##class(ThemeMetrics).GetMetric(..%Id(),code)
}

Method GetDimStruct(themeDimCode = "") As %List
{
	if themeDimCode'=""{
	  q ##class(ThemeDims).GetDimStruct(..%Id(),##class(ThemeDims).GetDimId(..%Id(),themeDimCode))
	}
	q ##class(ThemeDims).GetDimStruct(..%Id())
}

Method GetMetricStruct(themeMetricCode = "") As %List
{
	if themeMetricCode'=""{
	  q ##class(ThemeMetrics).GetMetricStruct(..%Id(),##class(ThemeMetrics).GetMetricId(..%Id(),themeMetricCode))
	}
	q ##class(ThemeMetrics).GetMetricStruct(..%Id())
}

Method GetDimMaxSN() As %Integer
{
	q ##class(ThemeDims).GetMaxSN(..%Id())
}

Method GetMetricMaxSN() As %Integer
{
	q ##class(ThemeMetrics).GetMaxSN(..%Id())
}

Method GetPath() As %String
{
	q ..Namespace.GetPath()_..Code_".t"
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
	s list=##class(ThemeFetchConfig).Get( ..%Id() )
	s first=list.GetAt(1)
	s s1=##class(ThemeDims).GetDimSelect(..%Id())
	s s2=##class(ThemeMetrics).GetMetricSelect(..%Id())
	i ( (s1'="") && (s2'="") ) d
	.s select=s1_","_s2
	e  i s1'="" d
	.s select=s1
	e  i s2'="" d
	.s select=s2
	e  d
	.s select="*"
	q "SELECT "_select_" FROM  "_..GetJoinExp( first.GetSQL(), 2, .list, list.Count())_" "
}

Method GetMetaSQL() As %String
{
	s list=##class(ThemeFetchConfig).Get( ..%Id() )
	q:list.Count()=0 ""
	s first=list.GetAt(1)
	s s1=##class(ThemeDims).GetDimSelect(..%Id())
	s s2=##class(ThemeMetrics).GetMetricSelect(..%Id())
	i ( (s1'="") && (s2'="") ) d
	.s select=s1_","_s2
	e  i s1'="" d
	.s select=s1
	e  i s2'="" d
	.s select=s2
	e  d
	.s select="*"
	q "SELECT "_select_" FROM  "_..GetMetaJoinExp( first.GetMetaSQL(), 2, .list, list.Count())_" "
}

// d ##class(DHCWL.DM.T.ThemeBase).TestGetFetchSQL()

ClassMethod TestGetFetchSQL()
{
	s obj=##class(DHCWL.DM.T.ThemeBase).GetByPath("/WorkLoad.t")
	s sql=obj.GetFetchSQL()
	w sql
}

// d ##class(DHCWL.DM.T.ThemeBase).TestGetMetaSQL()

ClassMethod TestGetMetaSQL()
{
	s obj=##class(DHCWL.DM.T.ThemeBase).GetByPath("/WorkLoadAll.t")
	s sql=obj.GetMetaSQL()
	w sql
}

Method GetJoinExp(left As %String, rightIndex As %Integer, ByRef list As %ListOfObjects, stopIndex As %Integer) As %String [ Private ]
{
	q:rightIndex>stopIndex left
	s rightConfig=list.GetAt(rightIndex)
	s rightSelect=rightConfig.GetSQL()
	i rightIndex>2 d
	.s join=" "_left_"  LEFT JOIN "_rightSelect_"  ON "_##class(ThemeFetchConfig).GetJoin(..%Id(),rightIndex)
	e  d
	.s join=" "_left_"  LEFT JOIN "_rightSelect_"  ON "_##class(ThemeFetchConfig).GetJoin(..%Id(),rightIndex)
	q ..GetJoinExp(join,rightIndex+1,.list,stopIndex)
}

Method GetMetaJoinExp(left As %String, rightIndex As %Integer, ByRef list As %ListOfObjects, stopIndex As %Integer) As %String [ Private ]
{
	q:rightIndex>stopIndex left
	s rightConfig=list.GetAt(rightIndex)
	s rightSelect=rightConfig.GetMetaSQL()
	i rightIndex>2 d
	.s join=" "_left_"  LEFT JOIN "_rightSelect_"  ON "_##class(ThemeFetchConfig).GetJoin(..%Id(),rightIndex)
	e  d
	.s join=" "_left_"  LEFT JOIN "_rightSelect_"  ON "_##class(ThemeFetchConfig).GetJoin(..%Id(),rightIndex)
	q ..GetMetaJoinExp(join,rightIndex+1,.list,stopIndex)
}

Method BuildCube(dimNameList As %List, metricExpressionList As %List) As CubeBase
{
	s len=$ll(dimNameList)
	s dimList=##class(%ListOfObjects).%New()
	f i=1:1:len d
	.q:$lg(dimNameList,i,"")=""
	.s pro=..GetDim($lg(dimNameList,i))
	.d dimList.Insert(pro)
	d ##class(CubeBase).NewCube(..%Id(),dimList)
}

Method GetCubes() As %ListOfObjects
{
	q ##class(CubeBase).GetCubes(..%Id())
}

/// 把Select表达式中用到的维度，维度属性全部提取出来按照维度归并在一起。
/// 可能含有维度或者维度属性的地方包括：dim 、dim->pro、dim alias、dim as alias、fun(dim,...)、 dim operator dim 
Method parseESQLSelect(selectExp As %String, ByRef refDimProMap) As %Status
{
	s stack=##class(DHCWL.DM.Util.Stack).%New()
	s selectExp=selectExp_","
	s len=$l(selectExp)
	s expSplit=",",strS="'",strE="'",funParaS="(",funParaE=")",oneExpS=1
	k expMap
	f i=1:1:len d
	.s char=$e(selectExp,i)
	.i ( (char=expSplit) && (stack.Peek()'=strS) && (stack.Peek()'=funParaS)) d
	..s exp=$e(selectExp,oneExpS,i-1)
	..s oneExpS=i+1
	..s exp=##class(DHCWL.DM.Util.StringUtil).Trim(exp)
	..s expMap(exp)=""
	.else  if ( (char=strS) && (stack.Peek()'=strS) ) d
	..d stack.Push(char)
	.else  if ( (char=strE) && (stack.Peek()=strS) ) d
	..d stack.Pop()
	.else  if ( (char=funParaS) && (stack.Peek()'=strS) ) d
	..d stack.Push(char)
	.else  if ( (char=funParaE) && (stack.Peek()'=strS) && (stack.Peek()=funParaS) ) d
	..d stack.Pop()
	q:stack.Size()'=0 $$$ERROR(selectExp_" is invalid!")
	s exp="" f  s exp=$o(expMap(exp)) q:exp=""  d
}

Method ToString() As %String
{
  q "{""path"":"""_..GetPath()_""",""dims"":["_##class(ThemeDims).GetDimsString(..%Id())_"],""metrics"":["_##class(ThemeMetrics).GetMetricsString(..%Id())_"]}"
}

ClassMethod BuildExpTree(expression)
{
	s operatorMap("")=1
	s expression=expression_" "
	s len=$l(expression),preChar=""
	s stack=##class(DHCWL.DM.Util.Stack).%New()
	f i=1:1:len d
	.s char=$e(expression,i)
	.i ( (char="'") && (stack.Peek()'="'") ) d
	..d stack.Push(char)
	.e  i ( (char="'") && (stack.Peek()="'") ) d
	..d stack.Pop()
	.e  i ( ($$isSpace(char)) && stack.Peek()'="'" ) d 
	..s lastStr=##class(DHCWL.DM.Util.StringUtil).Trim($e(i+1,len))
	..if ( ($zcvt($e(lastStr,1,2),"U")="AS") || ($$isWord(lastStr))) d //as alias
	...
	.e  i ( (char="(") && (stack.Peek()'="'") ) d
	..s funE=i-1
	..f j=i-1:-1:1 d
	...i $$isSpace($e(expression,j)) d
	....s funE=j
	...e  d
	....s j=0
	..s funS=funE+1
	..f j=funE:-1:1 d
	...i '$$isLetter($e(expression,j)) d
	....s funS=j+1
	....s j=0
	..s funName=$e(expression,funS,funE)
	..i funName'="" d
	...
	..e  d
	...
	.e  i ($d(operatorMap(char))) d
	..
	
	q
	
isSpace(char)
	s ascii=$ascii(char)
	i ((ascii=20) || (ascii=9) || (ascii=10) && (ascii'=11) || (ascii=12) || (ascii=13)) q 1
	q 0
isWord(str)
	s flag=1
	s strL=$l(str)
	f strI=1:1:strL d
	.if $$isSpace($e(str,strI)) d
	..s flag=0,strI=strL+1
	q flag
isLetter(char)
	s ascii=$ascii(char)
	if ( ((ascii>=48)&&(ascii<=57)) && ((ascii>=65)&&(ascii<=90)) && ((ascii>=97)&&(ascii<=122)) ) q 1
	q 0
}

Method ChangeDimType(dimList As %List, dimType)
{
    s type=##class(TypeConfig).GetByPath("TD:"_dimType)
    q:type=""
    f i=1:1:$ll(dimList){
	  s dimCode=$lg(dimList,i,"")
	  continue:dimCode=""
	  s dim=..GetDim(dimCode)
	  continue:dim=""
	  s dim.DimType=type
	  w dim.%Save()   
    }
}

Method SetLinkPath(dimCode As %String, linkPath As %String, dimTypeCode = "RD")
{
	s dim=..GetDim(dimCode)
	q:dim="" 0
	s:dimTypeCode'="" dim.DimType=##class(TypeConfig).GetByPath("TD:"_dimTypeCode)
	s dim.LinkPath=linkPath
	q dim.%Save()
}

Storage Default
{
<Data name="ThemeBaseDefaultData">
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
<Value>Description</Value>
</Value>
<Value name="6">
<Value>Creator</Value>
</Value>
<Value name="7">
<Value>CreatedDate</Value>
</Value>
<Value name="8">
<Value>RowKeyFields</Value>
</Value>
<Value name="9">
<Value>NeedStore</Value>
</Value>
<Value name="10">
<Value>UsageStatus</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.ThemeBaseD</DataLocation>
<DefaultData>ThemeBaseDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.ThemeBaseD</IdLocation>
<IndexLocation>^DHCWL.DM.T.ThemeBaseI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.ThemeBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
