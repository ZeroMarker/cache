/// Created by lihaihong @170411
Class DHCWL.DM.Core.InternalResolvedParser Extends %RegisteredObject
{

Parameter LEFTPOS = 0;

Parameter RIGHTPOS = 1;

Property Parent As InternalResolvedParser;

Property Children As %ListOfObjects;

Property IsRoot As %Boolean;

Property ResultSetName As %String;

Property SegBit [ MultiDimensional ];

Property RangeRootNode As DHCWL.DM.Util.FilterTree;

Property FilterRootNode As DHCWL.DM.Util.FilterTree;

Property RefCube As %SerialObject;

Property RefTheme As %SerialObject;

Property ComputedCube As %SerialObject;

Property ComputedTheme As %SerialObject;

Property AggFormattedList As %ListOfDataTypes;

// dims ("D",dimCode)=""

// dims on window part ("P",dimCode)=""

// filter ("F",dimCode)=""

// metric ("M",metricCode)=""

Property allUsingDimMetricMap [ MultiDimensional ];

// (showIndex)=dimExpression

// (showIndex,"S")=dimStruct

// (showIndex,"T")=dimType  relation dim or not

Property dimsShowInd [ MultiDimensional ];

Property cubeDimsShowInd [ MultiDimensional ];

// (1,formatedSrcDimExpression)=aliasName

// (2,aliasName)=formatedSrcDimExpression

// (2,aliasName,"SI")=last dim property struct index from

// (3,"A",aliasName)=show index

// (3,"P",showIndex)=aliasName

Property aliasMap [ MultiDimensional ];

Property jsonExpStruct [ MultiDimensional ];

// (showIndex)=metricExpression

// (showIndex,"A")=aggExpression alias

// (showIndex,"F")=aggFunction

// (showIndex,"P",paramIndex)=param

// (showIndex,"P",paramIndex,"T")=1 if para.IsProperty=1

// (showIndex,"P",paramIndex,"S")=metricStructInCube

// (showIndex,"D",dimIndex)=dimExpression

// (showIndex,"DSN",dimIndex)=dim serial number

// (showIndex,"D",dimIndex,"S")=dimStructList

Property metricsShowInd [ MultiDimensional ];

// (type)=index

// (type,index)

Property proFunStruct [ MultiDimensional ];

Property aggFunctionCallList As %ListOfObjects;

//  ()=field num

// (1,index)=field

// (1,index,"ST")=sort type

// (1,index,"FT")=field type

// (1,index,"FI")=source field index

// (2,field)=index

// (filedType,index)=""

Property sortStructMap [ MultiDimensional ];

Property Status As %Status;

Property PartList As %List;

Property FlowExecutor As FlowExecutor;

Property RealTimeIRP As RealTimeThemeIRP;

Property InnerJoinIRP As InnerJoinIRP;

Property IsJoinRefed As %Boolean;

Property ExecutedLogs As %Integer;

Property NeedExecutedCount As %Integer;

Property parsedDimStuList As %ListOfObjects;

Property HasSortFlag As %Boolean;

Property MetricDitailInSortFlag As %Boolean;

// TODO

Property StatisticWayExpression As %String;

Method %OnNew() As %Status [ Private, ServerOnly = 1 ]
{
	s status=$$$OK
	s ..ExecutedLogs=0
	s ..Children=##class(%ListOfObjects).%New()
	s ..AggFormattedList=##class(%ListOfDataTypes).%New()
	s ..aggFunctionCallList=##class(%ListOfObjects).%New()
	s ..NeedExecutedCount=1
	s ..parsedDimStuList=##class(%ListOfObjects).%New()
	q status
}

Method GenerateCommon(parent As InternalResolvedParser = "", resultSetName, type = "QRY", from, dims = "", metrics, filter = "", sort = "", range = "", printFlag = "", ByRef jsonStruct, statisticWayExpression = "") As %Status
{
	s status=$$$OK
	if ($g(parent,"")'=""){
	  s ..Parent=parent
	  s status= ..Parent.AddChild($this)
	  s ..IsRoot=0
	}else{
	  s ..IsRoot=1
	  ;if range="" q $$$ERROR("Query from theme must give date range!")
	}
	s ..jsonExpStruct("RANGE")=range
	s ..ResultSetName=resultSetName
	s ..jsonExpStruct("TYPE")=type
	s ..jsonExpStruct("FROM")=from
	s ..jsonExpStruct("DIMS")=dims
	s ..jsonExpStruct("AGGS")=metrics
	s ..jsonExpStruct("FILTER")=filter
	s ..jsonExpStruct("SORT")=sort
	s ..jsonExpStruct("WAY")=range
	s ..jsonExpStruct("DAY")=$g(jsonStruct("DAY"),"")
	if ((printFlag'="")&&($zcvt(printFlag,"U")="TRUE")){
	  s ..jsonExpStruct("PRINT")=1
	}else{
	  s ..jsonExpStruct("PRINT")=0
	}
	if range'=""{
	  if filter=""{
		s ..jsonExpStruct("FILTER")=range
	  }else{
		s ..jsonExpStruct("FILTER")="("_filter_")&&("_range_")"
	  }
	}
	q status
}

Method GetCQLExpression() As %String
{
	q ..ResultSetName_":{from:"_$g(..jsonExpStruct("FROM"),"")_",dims:"_$g(..jsonExpStruct("DIMS"),"")_",metrics:"_$g(..jsonExpStruct("AGGS"),"")_",filter:"_$g(..jsonExpStruct("FILTER"),"")_",sort:"_$g(..jsonExpStruct("SORT"),"")_",print:"_$g(..jsonExpStruct("PRINT"),"")_"}"
}

Method Close()
{
	s ..Parent=""
	i ..Parent'=""{
	  ;d ..Parent.Close()
	  s ..Parent=""
	}
	d ..Children.Clear()
	s ..Children=""
	s ..IsRoot=""
	s ..ResultSetName=""
	k ..SegBit
	s ..RangeRootNode=""
	d ..CloseFilterRoot(..FilterRootNode)
	s ..FilterRootNode=""
	s ..RefCube=""
	s ..RefTheme=""
	s ..ComputedCube=""
	s ..ComputedTheme=""
	f i=1:1:..aggFunctionCallList.Count(){
	  s fun=..aggFunctionCallList.GetAt(i)
	  continue:fun=""
	  d fun.Close()
	}
	d ..aggFunctionCallList.Clear()
	d ..AggFormattedList.Clear()
	s ..AggFormattedList=""
	k ..allUsingDimMetricMap
	k ..dimsShowInd
	k ..cubeDimsShowInd
	k ..aliasMap
	k ..jsonExpStruct
	k ..metricsShowInd
	s type="" f{
	  s type=$o(..proFunStruct(type))
	  q:type=""
	  s dimInd="" f{
		s dimInd=$o(..proFunStruct(type,dimInd))
		q:dimInd=""
		s paraInd="" f{
		  s paraInd=$o(..proFunStruct(type,dimInd,paraInd))
		  q:paraInd=""
		  continue:'$d(..proFunStruct(type,dimInd,paraInd,"F"))
		  s fun=..proFunStruct(type,dimInd,paraInd,"F")
		  d:fun'="" fun.Close()
		}
	  }	
	}
	k ..proFunStruct
	d ..aggFunctionCallList.Clear()
	s ..aggFunctionCallList=""
	s ..PartList=""
	if ..RealTimeIRP'=""{
	  d ..RealTimeIRP.Close()
	  s ..RealTimeIRP=""
	}
	if ..IsInnerJoin(){
	  d:..InnerJoinIRP'="" ..InnerJoinIRP.Close()
	  s ..InnerJoinIRP=""
	}
	f i=1:1:..parsedDimStuList.Count(){
	  s pds=..parsedDimStuList.GetAt(i)
	  d pds.Close()	
	}
	d ..parsedDimStuList.Clear()
}

Method CloseFilterRoot(node As DHCWL.DM.Util.FilterTree) [ Private ]
{
	q:node=""
	d:node.FunCall'="" node.FunCall.Close()
	d ..CloseFilterRoot(node.Left)
	d ..CloseFilterRoot(node.Right)
}

// d ##class(DHCWL.DM.Core.InternalResolvedParser).Test()

ClassMethod Test()
{
	s irp=##class(InternalResolvedParser).%New("","rs1","/workload.t","RecDep->Code,RecDep->Hospital->Name,PatDep->Code,AdmType","sum(Price)","(a && ( b && (c || d) ))")
	d irp.ParseTest()
}

Method ParseTest() As %Status
{
	if (..IsRoot){
	  s ..RefTheme=##class(DHCWL.DM.T.ThemeBase).GetByPath(..jsonExpStruct("FROM"))
	  if ..RefTheme="" {
	    q $$$ERROR("Can't load theme with path "_..jsonExpStruct("FROM"))
	  }
	}else{
	  s ..RefTheme=..Parent.GetComputedTheme()
	  s ..RefCube=..Parent.GetComputedCube()
	}
	s status=..ParseFilter(.rootNode)
	q status
}

ClassMethod SearchDown(node As InternalResolvedParser, resultSetName) As InternalResolvedParser
{
	q:node="" ""
	if node.ResultSetName=resultSetName q node
	s len=node.Children.Count()
	s result=""
	f i=1:1:len {
	  s result=..SearchDown(node.Children.GetAt(i),resultSetName)
	  q:result'=""
	}
	q result
}

Method Parse() As %Status
{
	if (..IsRoot){
	  s ..RefTheme=##class(DHCWL.DM.T.ThemeBase).GetByPath(..jsonExpStruct("FROM"))
	  if ..RefTheme="" {
	    q $$$ERROR("Can't load theme with path "_..jsonExpStruct("FROM"))
	  }
	  s status=..ParseRange(.rangeRoot)
	  q:status'=$$$OK status
	  s ..RangeRootNode=rangeRoot
	}else{
	  s ..RefTheme=..Parent.GetComputedTheme()
	  s ..RefCube=..Parent.GetComputedCube()
	}
	
	s status=..ParseDims()
	s ..Status=status
	q:status'=$$$OK status
	;m tmp=..allUsingDimMetricMap
	;zw tmp
	s status=..ParseFilter(.rootNode)
	s ..Status=status
	q:status'=$$$OK status
	s ..FilterRootNode=rootNode
	s status=..ParseAggExps()
	s ..Status=status
	q:status'=$$$OK status
	if ..IsRoot {
	  s dimList=$lb(),i=0
	  k dimMap
	  i $d(..allUsingDimMetricMap("D")) {
	    s code="" f {
		  s code=$o(..allUsingDimMetricMap("D",code)) 
		  q:code=""
		  s dimMap(code)=""
	    }
	  }
	  i $d(..allUsingDimMetricMap("P")) {
	    s code="" f {
		  s code=$o(..allUsingDimMetricMap("P",code)) 
		  q:code=""
		  s dimMap(code)=""
	    }
	  }
	  i $d(..allUsingDimMetricMap("F")) {
	    s code="" f {
		  s code=$o(..allUsingDimMetricMap("F",code)) 
		  q:code=""
		  s dimMap(code)=""
	    }
	  }
	  s code="" f {
		s code=$o(dimMap(code))
		q:code=""
		s i=i+1
		s $list(dimList,i)=code  
	  }
	  s rangeDimList=$lb(),i=0
	  i $d(..allUsingDimMetricMap("R")) {
	    s code="" f {
		  s code=$o(..allUsingDimMetricMap("R",code)) 
		  q:code=""
	      s i=i+1
	      s $list(rangeDimList,i)=code
	    }
	  }
	  s dimls=$lts(dimList,";"),len=$ll(rangeDimList)
	  s bestCube=""
	  s afl=$lb(),afllen=..AggFormattedList.Count(),afli=0
	  k aflMap
	  f i=1:1:afllen{
		s af=..AggFormattedList.GetAt(i)
		continue:((af="")||($d(aflMap(af))))
		s aflMap(af)=""
		s afli=afli+1
		s $list(afl,afli)=af
	  }
	  ;w $lts(afl),!
	  f i=1:1:len {
	    s sd=$lg(rangeDimList,i)
	    s $list(rangeDimList,i)=""
	    s tryDimList=$lfs(dimls,";")
	    d choiceCopyList(tryDimList,rangeDimList)
	    s cube=##class(DHCWL.DM.T.CubeBase).Get(..RefTheme.GetPath(),sd,tryDimList,afl)
	    i ( (cube'="") && ((bestCube="") || (bestCube.DimNum>cube.DimNum)) ) s bestCube=cube
	    s $list(rangeDimList,i)=sd
	  }
	  q:bestCube="" $$$ERROR("Can't find cube for query "_..GetCQLExpression()_" ")
	  s ..RefCube=bestCube
	  ;b ;GetRangePartList
	  s status=..GetRangePartList(..RangeRootNode,.partList)
	  q:status'=$$$OK status
	  s ..PartList=$g(partList,$lb())
	}else{
      s ..PartList=$lb(0)
	}
	
	;s status= ..FilterFunctionParse(..FilterRootNode)
	;q:status'=$$$OK status
	d ..ResolveAggMetricPara()
	d ..BuildComputedTheme()
	d ..BuildComputedCube()
	s status= ..ParseCubeDimExpStruct()
	s ..Status=status
	;m temp=..aliasMap
	;zw temp
	q status
choiceCopyList(a,b)
	s blen=$ll(b),alen=$ll(a)
	f bi=1:1:blen {
	  continue:$lg(b,bi,"")=""
	  s alen=alen+1
	  s $list(a,alen)=$lg(b,bi)
	}
	q
}

Method Parse2() As %Status
{
	if (..IsRoot){
	  s ..RefTheme=##class(DHCWL.DM.T.ThemeBase).GetByPath(..jsonExpStruct("FROM"))
	  if ..RefTheme="" {
	    q $$$ERROR("Can't load theme with path "_..jsonExpStruct("FROM"))
	  }
	  ;s status=..ParseRange(.rangeRoot)
	  ;q:status'=$$$OK status
	  ;s ..RangeRootNode=rangeRoot
	}else{
	  s ..RefTheme=..Parent.GetComputedTheme()
	  s ..RefCube=..Parent.GetComputedCube()
	}
	
	s status=..ParseDims()
	s ..Status=status
	q:status'=$$$OK status
	;m tmp=..allUsingDimMetricMap
	;zw tmp
	s status=..ParseFilter(.rootNode)
	s ..Status=status
	q:status'=$$$OK status
	s ..FilterRootNode=rootNode
	s status=..ParseAggExps()
	s ..Status=status
	q:status'=$$$OK status
	s status=..ParseSort(..jsonExpStruct("SORT"))
	s ..Status=status
	q:status'=$$$OK status
	if ..IsRoot {
	  s dimList=$lb(),i=0
	  k dimMap
	  i $d(..allUsingDimMetricMap("D")) {
	    s code="" f {
		  s code=$o(..allUsingDimMetricMap("D",code)) 
		  q:code=""
		  s dimMap(code)=""
	    }
	  }
	  i $d(..allUsingDimMetricMap("P")) {
	    s code="" f {
		  s code=$o(..allUsingDimMetricMap("P",code)) 
		  q:code=""
		  s dimMap(code)=""
	    }
	  }
	  i $d(..allUsingDimMetricMap("F")) {
	    s code="" f {
		  s code=$o(..allUsingDimMetricMap("F",code)) 
		  q:code=""
		  s dimMap(code)=""
	    }
	  }
	  i $d(..allUsingDimMetricMap("R")) {
	    s code="" f {
		  s code=$o(..allUsingDimMetricMap("R",code)) 
		  q:code=""
	      s dimMap(code)=""
	    }
	  }
	  s code="" f {
		s code=$o(dimMap(code))
		q:code=""
		s i=i+1
		s $list(dimList,i)=code  
	  }
	  s bestCube=""
	  s afl=$lb(),afllen=..AggFormattedList.Count(),afli=0
	  k aflMap
	  f i=1:1:afllen{
		s af=..AggFormattedList.GetAt(i)
		continue:((af="")||($d(aflMap(af))))
		s aflMap(af)=""
		s afli=afli+1
		s $list(afl,afli)=af
	  }
	  ;w $lts(afl),!
	  s bestCube=##class(DHCWL.DM.T.CubeBase).Get2(..RefTheme.GetPath(),dimList,afl)
	  
	  q:bestCube="" $$$ERROR("Can't find cube for query "_..GetCQLExpression()_" ")
	  s ..RefCube=bestCube
	  ;b ;GetRangePartList
	  ;s status=..GetRangePartList(..RangeRootNode,.partList)
	  ;q:status'=$$$OK status
	  ;s ..PartList=$g(partList,$lb())
	  s ..PartList=##class(DHCWL.DM.T.CubeDBDPPart).GetPartitions(bestCube.Mask())
	}else{
      s ..PartList=$lb(0)
	}
	;s status= ..FilterFunctionParse(..FilterRootNode)
	;q:status'=$$$OK status
	d ..ResolveAggMetricPara()
	d ..BuildComputedTheme()
	d ..BuildComputedCube()
	s status= ..ParseCubeDimExpStruct()
	s ..Status=status
	m sortStruct=..sortStructMap
	s hasMetricDetailSort=0
	s hasSortFlag=0
	s sindex="" f{
		s sindex=$o(sortStruct(1,sindex))
		q:sindex=""
		s hasSortFlag=1
		s ft=sortStruct(1,sindex,"FT")
		s fi=sortStruct(1,sindex,"FI")
		if ft="MD"{
			k metricDetailMap(fi)
			s hasMetricDetailSort=1
		}
	}
	s ..HasSortFlag=hasSortFlag
	s ..MetricDitailInSortFlag=hasMetricDetailSort
	;m temp=..aliasMap
	;zw temp
	q status
choiceCopyList2(a,b)
	s blen=$ll(b),alen=$ll(a)
	f bi=1:1:blen {
	  continue:$lg(b,bi,"")=""
	  s alen=alen+1
	  s $list(a,alen)=$lg(b,bi)
	}
	q
}

Method ParseDims() As %Status
{
	s status=$$$OK
	s dims=..jsonExpStruct("DIMS")
	if (dims=""){
	  s ..dimsShowInd=0
	  q status
	}
	s len=$l(dims)
	if $e(dims,len)'=","{
	  s dims=dims_","
	  s len=len+1
	}
	s stack=##class(DHCWL.DM.Util.Stack).%New()
	s dimIndS=1,dimExpInd=0
	f i=1:1:len{
	  s char=$e(dims,i)
	  if (char="(") && (stack.Peek()'="'"){
		d stack.Push(char)
	  }elseif (char=")" && (stack.Peek()'="'")){
		d stack.Pop()
	  }elseif (char="'") && (stack.Peek()'="'"){
		d stack.Push(char)
	  }elseif (char="'") && (stack.Peek()="'"){
		d stack.Pop()  
	  }elseif (char=",") && (stack.Size()=0){
			s dimExp=$e(dims,dimIndS,i-1)
	    s dimExpInd=dimExpInd+1
			s status=..ParseDimExp(..RefTheme,dimExp,.sl,"D",dimExpInd,.parsedDimStu)
	    q:status'=$$$OK
	    s ..dimsShowInd(dimExpInd,"S")=sl
	    s ..dimsShowInd(dimExpInd,"E")=dimExp
		s dimIndS=i+1
		d ..parsedDimStuList.InsertAt(parsedDimStu,dimExpInd)
	  }
	}
	q:status'=$$$OK status
	s ..dimsShowInd=1
	;m dimsShowInd=..dimsShowInd
	;zw dimsShowInd
	q status
}

Method ParseDimExp(theme As %SerialObject, dimExpression, ByRef structList As %List, type As %String = "D", dimExpIndex As %Integer = 0, ByRef parsedDimStructLink As ParsedDimStruct) As %Status [ Private ]
{
	s structList=$lb()
	s len=$l(dimExpression,"->")
	s status=$$$OK
	s dimBase=""
	s (preDimStruct,curDimStruct)=""
	f i=1:1:len {
	  s j=(i-1)*4+1
	  s callFunType=1
	  s dim=##class(DHCWL.DM.Util.StringUtil).Trim( $p(dimExpression,"->",i) )
	  if ((dimExpIndex>0)&&(i=len)&&(type="D")) {
		s pro=dim,aliasExp="",preDim=dimExpression
	    s len2=$l(pro),flag=0
	    f m=len2:-1:1{
	      s char=$e(pro,m)
	      if ( ##class(DHCWL.DM.Util.StringUtil).IsSpace(char)'=0 ){
		    s aliasExp=$e(pro,m+1,len2)
		    s proei=$l(dimExpression)-$l(aliasExp)
		    s preDim=##class(DHCWL.DM.Util.StringUtil).Trim($e(preDim,1,proei))
		    s aliasExp=##class(DHCWL.DM.Util.StringUtil).Trim(aliasExp)
		    s pro=##class(DHCWL.DM.Util.StringUtil).Trim($e(dim,1,m-1))
		    s prolen=$l(pro)
		    if ($zcvt($e(pro,prolen-1,prolen),"U")="AS") && (##class(DHCWL.DM.Util.StringUtil).IsSpace($e(pro,prolen-2)))  {
			  s pro=##class(DHCWL.DM.Util.StringUtil).Trim($e(pro,1,prolen-2))
			  s preDimLen=$l(preDim)
			  s preDim=##class(DHCWL.DM.Util.StringUtil).Trim($e(preDim,1,preDimLen-2))
		    }
		    s dim=pro,flag=1
		    q
	      }
	    }
	    if ((aliasExp="")){
		  if len>1{
			s aliasExp="dim"_dimExpIndex
		  }else{
			s aliasExp=##class(DHCWL.DM.Util.StringUtil).Trim(preDim)
		  }
	    }
		if ($d(..aliasMap(2,aliasExp))){
		  s status=$$$ERROR(preDim_" has same alias name "_aliasExp_" with in "_..aliasMap(2,aliasExp))
		  q
		}
		s ..aliasMap(2,aliasExp)=preDim ;pro
		s ..aliasMap(1,pro)=aliasExp
		s ..aliasMap(2,aliasExp,"SI")=j
		s ..aliasMap(3,"P",dimExpIndex)=aliasExp
		s ..aliasMap(3,"A",aliasExp)=dimExpIndex
		s pro=##class(DHCWL.DM.Util.StringUtil).Trim($p(pro,"(",1))
		s ..aliasMap(2,aliasExp,"S")=pro
	  }
	  s dim2=dim
	  i ( (dim [ "(") && (dim [ ")") ){
		s dim=$p(dim,"(")
	  }
	  i i=1 {
			s curDimStruct=##class(ParsedDimStruct).%New()
			s curDimStruct.level=1
			s curDimStruct.type=2
			s rootDim=dim
	    s themeDims=theme.GetDim(dim)
	    if themeDims=""{
			  s status=$$$ERROR("Can't get dimBase with code "_$g(dim,"null")_" from theme path "_theme.ToString())
			  q
	    }
	    s curDimStruct.linkBase=theme
	    s curDimStruct.linkBaseRowKey=""
	    s curDimStruct.visit=themeDims
	    s dimPro=themeDims
	    if (len>1){
			  s dimBase= themeDims.GetLinkDim()
			  if (dimBase=""){
			    s status=$$$ERROR("The dimCode "_$g(dim,"null")_" from theme path "_theme.ToString()_" is not linked dim type!")
			    q
	      }
	      s curDimStruct.returnBase=dimBase
	      if (themeDims.DimType.GetPath()="TD:R"){
			    s curDimStruct.type=38
			    s curDimStruct.isVisitRelationDim=1
			    if (dimBase'=""){
					  s curDimStruct.queryParams=themeDims.GetLinkParams()
					  d ##class(DHCWL.DM.Util.StringUtil).ParseURLQueryParams(curDimStruct.queryParams,.queryMap)
					  s curDimStruct.returnBaseRowKey=dimBase.getDim(queryMap("RowKey"))
			    }
			    
	      }else{
			    s curDimStruct.type=32
			    s curDimStruct.returnBaseRowKey=""
	      }
	      if (themeDims.CreateType'=""){
			    s ctpath=themeDims.CreateType.GetPath()
			    if (ctpath="TD:DYNPROFUN"){
					  if (curDimStruct.type=38){
							s curDimStruct.type=46
					  }else{
							s curDimStruct.type=30
					  }
					  s callFunType=2
			      d parseFunction
			    }
	      }
	    }else{
			  s dimBase= themeDims.GetLinkDim()
			  if (themeDims.DimType.GetPath()="TD:R"){
			    s curDimStruct.isVisitRelationDim=1
			  }
			  if (dimBase'=""){
			    s curDimStruct.returnBase=dimBase
			    s curDimStruct.queryParams=themeDims.GetLinkParams()
			    if (curDimStruct.queryParams'=""){
					  d ##class(DHCWL.DM.Util.StringUtil).ParseURLQueryParams(curDimStruct.queryParams,.queryMap)
					  s:$d(queryMap("RowKey")) curDimStruct.returnBaseRowKey=dimBase.getDim(queryMap("RowKey"))
			    }
	      }
			  if (themeDims.CreateType'=""){
			    s ctpath=themeDims.CreateType.GetPath()
			    if (ctpath="TD:DYNPROFUN")||(ctpath="TD:DYNPROFUNRD"){
					  s curDimStruct.type=10
					  s curDimStruct.isVisitRelationDim=1
					  s callFunType=2
			      d parseFunction
			    }
	      }
	    }
	    
	    s sn=themeDims.SerialNumber
	    s ..allUsingDimMetricMap(type,dim)=""
	    s $list(structList,j)=themeDims.Mask()
	    s $list(structList,j+1)=""
	    s:dimBase'="" $list(structList,j+1)=dimBase.%Id()
	    s $list(structList,j+2)=sn
	    s dt=themeDims.DataType.JDBCTypeCodeNum
	    s:dt="" dt=12
	    if $lg(structList,j+3,"")=""{
		    s $list(structList,j+3)=dt
	    }else{
		    s $list(structList,j+3)=dt_$list(structList,j+3)
	    }
	    //TODO 将Theme的SN转换成Cube的SN  20180826
	    s curDimStruct.SN=sn
	    s curDimStruct.jdbcType=dt
	    s preDimStruct=curDimStruct
	    s parsedDimStructLink=curDimStruct
	    //d resolveDimMethodGrammar
	    q:(status'=$$$OK)
	  }else{
		s curDimStruct=##class(ParsedDimStruct).%New()
		s curDimStruct.type=1
		s curDimStruct.level=i
		s curDimStruct.linkBase=preDimStruct.returnBase
		s curDimStruct.linkBaseRowKey=preDimStruct.returnBaseRowKey
		
		if (preDimStruct.type=38)||(preDimStruct.type=46){
		  s curDimStruct.type=2
		  s dimPro=preDimStruct.returnBase.GetDim(dim)
		  i dimPro="" {
	        s status=$$$ERROR("Can't get dim "_dim_" from "_dimExpression_" with themBase:"_preDimStruct.linkBase.GetPath())
	        q
	      }
		  s sn=dimPro.SerialNumber
		  s themeDims=dimPro
		  s curDimStruct.visit=dimPro
		  if (i<len){
			s curDimStruct.type=32
		    s dimBase= themeDims.GetLinkDim()
		    if (dimBase=""){
		      s status=$$$ERROR("The dimCode "_$g(dim,"null")_" from theme path "_theme.ToString()_" is not linked dim type!")
		      q
	        }
	        s curDimStruct.returnBase=dimBase
	        if (themeDims.DimType.GetPath()="TD:R"){
		      s curDimStruct.type=38
		      s curDimStruct.isVisitRelationDim=1
		      s curDimStruct.queryParams=themeDims.GetLinkParams()
	          d ##class(DHCWL.DM.Util.StringUtil).ParseURLQueryParams(curDimStruct.queryParams,.queryMap)
	          s curDimStruct.returnBaseRowKey=dimBase.getDim(queryMap("RowKey"))
	        }else{
		      s curDimStruct.returnBaseRowKey=""
	        }
	        if (themeDims.CreateType'=""){
		      s callFunType=2
		      s ctpath=themeDims.CreateType.GetPath()
		      if (ctpath="TD:DYNPROFUN"){
			    if (curDimStruct.type=38){
				  s curDimStruct.type=46
			    }else{
				  s curDimStruct.type=30
			    }
			    d parseFunction
		      }
	        }
	      }elseif (themeDims.CreateType'=""){
		    s dimBase= themeDims.GetLinkDim()
		    if (themeDims.DimType.GetPath()="TD:R"){
		      s curDimStruct.type=2
		      s curDimStruct.isVisitRelationDim=1
		    }
		    if (dimBase'=""){
		      s curDimStruct.returnBase=dimBase
		      s curDimStruct.queryParams=themeDims.GetLinkParams()
	          d ##class(DHCWL.DM.Util.StringUtil).ParseURLQueryParams(curDimStruct.queryParams,.queryMap)
	          s curDimStruct.returnBaseRowKey=dimBase.getDim(queryMap("RowKey"))
	        }
		    s ctpath=themeDims.CreateType.GetPath()
		    s curDimStruct.type=10
		    s callFunType=2
		    d parseFunction
	      }
		}else{
		  s curDimStruct.type=1
		  s dimPro=preDimStruct.returnBase.GetProperty(dim)
		  s sn=##class(DHCWL.DM.T.DimDStructMap).GetMapPosition(dimBase.%Id(),dimPro.%Id())
		  s pctpath=dimPro.CreatedType.GetPath()
		  s callFunType=1
		  if (i<len){
			s curDimStruct.type=21
			i (dimPro.IsLinked'="Y") {
			  s status=$$$ERROR("The dim property of "_dim _" is not link!")
			  q
			}
			s dimBase=##class(DHCWL.DM.T.DimBase).GetByPath(dimPro.LinkedPath)
			if (dimBase="") {
			  s status=$$$ERROR("Can't get dimBase with path"_dimPro.LinkedPath)
			  q
		    }
		    s curDimStruct.returnBase=dimBase
		    if (pctpath="DIM:DYNPROFUN") ||(pctpath="DIM:DYCDIMPRO"){
			  s curDimStruct.type=29
			  d parseFunction
		    }
		  }else{
			if (pctpath="DIM:DYNPROFUN") ||(pctpath="DIM:DYCDIMPRO"){
			  s curDimStruct.type=9
			  d parseFunction
		    }
		  }
		}
	    i sn=0 {
		  s status=$$$ERROR("Can't get property "_dim_"'s map position!")
		  q
	    }
	    
	    s jdbcTypeCode=dimPro.DataType.JDBCTypeCodeNum
	    s:jdbcTypeCode="" jdbcTypeCode=12
	    s $list(structList,j)=dimBase.%Id()
	    s $list(structList,j+1)=dimPro.%Id()
	    s $list(structList,j+2)=sn
	    if $lg(structList,j+3,"")=""{
		    s $list(structList,j+3)=jdbcTypeCode
	    }else{
		    s $list(structList,j+3)=jdbcTypeCode_$list(structList,j+3)
	    }
	    
        s curDimStruct.SN=sn
        s curDimStruct.jdbcType=jdbcTypeCode
        s preDimStruct.next=curDimStruct
        s preDimStruct=curDimStruct
	    if (i=len){
		  s parsedDimStructLink.previous=curDimStruct
	    }
	    //d resolveDimMethodGrammar
	    q:(status'=$$$OK)
	  }
	}
	q status
resolveDimMethodGrammar
    i '( (dim2 [ "(") && (dim2 [ ")") ){
	  q $$$OK
    }
    if (dimPro="") q $$$OK
    if (dimPro.CreatedType="") || (dimPro.CreatedType.GetPath()'="DIM:DYNPROFUN"){
	  i '( (dim2 [ "(") && (dim2 [ ")") ){
	    s status=$$$ERROR(dim2_" is not daynamic function property!")
	    q status
	  }
	  q $$$OK
    }
    s dim2Len=$l(dim2)
    s dimFunStack=##class(DHCWL.DM.Util.Stack).%New()
    s (proFun,paramStr)=""
    s bracketsFlag=0
    f dim2Ind=1:1:dim2Len{
	  s dim2c=$char(dim2Ind)
	  if (dim2c="(") && (dimFunStack.Peek()'="'"){
	    d dimFunStack.Push(dim2Ind)
	  }elseif (dim2c=")") && (dimFunStack.Peek()'="'") {
		s parasi=dimFunStack.Pop()
		if parasi="'"{
		  s status=$$$ERROR("The grammar of "_dim2_" is invalid!")
		  q
		}
		s bracketsFlag=1
		s proFun=##class(DHCWL.DM.Util.StringUtil).Trim( $e(dim2,1,parasi-1) )
		s paramStr=##class(DHCWL.DM.Util.StringUtil).Trim( $e(dim2,parasi+1,dim2Ind-1) )
	  }elseif (dim2c="'") && (dimFunStack.Peek()'="'"){
		d dimFunStack.Push(dim2c)
	  }elseif (dim2c="'") && (dimFunStack.Peek()="'"){
		d dimFunStack.Pop()
	  }
    }
    q:status'=$$$OK status
    i (bracketsFlag=1)&&((proFun="")){
	  s status=$$$ERROR("The grammar of "_dim2_" is invalid!")
	  q status
    }elseif (bracketsFlag=0){
	  s proFun=##class(DHCWL.DM.Util.StringUtil).Trim(dim2)
    }
    ;s proFun=$p(dim2,"(",1)
    ;s paramStr=##class(DHCWL.DM.Util.StringUtil).Trim( $p($p(dim2,"(",2),")",1) )
    s paramStrLen=$l(paramStr)
    i $e(paramStr,paramStrLen)'=","{
	  s paramStr=paramStr_","
	  s paramStrLen=paramStrLen+1
    }
    s proFun=dimPro.Expression
    s proFunStack=##class(DHCWL.DM.Util.Stack).%New()
    s paramIndS=1
    s paramList=$lb()
    s paramListCount=0
    f m=1:1:paramStrLen{
	  s char=$e(paramStr,m)
	  i (char=",")&&(proFunStack.Size()=0){
	    s theParam=##class(DHCWL.DM.Util.StringUtil).Trim($e(paramStr,paramIndS,m-1))
	    s theParam=##class(DHCWL.DM.Util.StringUtil).Trim(theParam,"'")
	    s paramListCount=paramListCount+1
	    s $list(paramList,paramListCount)=theParam
	    s paramIndS=m+1
	  }elseif ((char="'")&&(proFunStack.Peek()'="'")){
		d proFunStack.Push(char)
	  }elseif ((char="'")&&(proFunStack.Peek()="'")){
		d proFunStack.Pop()
	  }
    }
    s funCofnig=##class(DHCWL.DM.T.FunctionConfig).GetByPath("DYCDIMPRO:"_proFun)
    s defParams=dimPro.GetUsingParameters(funCofnig)  //funCofnig.Parameters()
    s defParamLen=defParams.Count(),paramListCount=0
    ;b ;resolveDimMethodGrammar
    s runtimeParams=$lb()
    f defParamInd=1:1:defParamLen{
	  s defParam=defParams.GetAt(defParamInd)
	  if defParam.ParamType.Code="EVALPASSBYVAR"{
		s pvar= defParam.Name
		s psn=##class(DHCWL.DM.T.DimDStructMap).GetMapPosition(dimBase.%Id(),dimBase.GetProperty(pvar).%Id())
		s ..proFunStruct(type,dimExpIndex,i,"DP",defParamInd)=psn
	  }elseif defParam.ParamType.Code="EVALPASSBYPOS"{
		s ..proFunStruct(type,dimExpIndex,i,"SP",defParamInd)=""
	  }elseif defParam.ParamType.Code="CONSTANTEVALPASS"{
		;s ..dimsShowInd(dimExpIndex,"PF",i,"SP",defParamInd)=""
		s paramListCount=paramListCount+1
		s $list(runtimeParams,defParam.ParaIndex)=$lg(paramList,paramListCount)
	  }
    }
    d defParams.Clear()
    s funCofnig=""
    
    s $list(structList,j+3)=$lg(structList,j+3)_"#"
    s ..proFunStruct(type,dimExpIndex,i,"D")=dimBase.%Id()
    s ..proFunStruct(type,dimExpIndex,i,"P")=runtimeParams
    s ..proFunStruct(type,dimExpIndex,i,"SI")=j
    s ..proFunStruct(type,dimExpIndex,i,"F")=##class(DHCWL.DM.Util.FunctionCall).%New("DYCDIMPRO:"_proFun)
    
    s funCallStruct=##class(ParsedFunctionCallStruct).%New()
    s funCallStruct.params=runtimeParams
    s funCallStruct.funCall=##class(DHCWL.DM.Util.FunctionCall).%New("DYCDIMPRO:"_proFun)
    s curDimStruct.isFunCall=1
    s curDimStruct.funCallStruct=funCallStruct
    ;s dim=proFun
    q $$$OK
parseFunction
    s dim2Len=$l(dim2)
    s dimFunStack=##class(DHCWL.DM.Util.Stack).%New()
    s (proFun,paramStr)=""
    s bracketsFlag=0
    f dim2Ind=1:1:dim2Len{
		  s dim2c=$e(dim2,dim2Ind)
		  if (dim2c="(") && (dimFunStack.Peek()'="'"){
		    d dimFunStack.Push(dim2Ind)
		  }elseif (dim2c=")") && (dimFunStack.Peek()'="'") {
				s parasi=dimFunStack.Pop()
				if parasi="'"{
				  s status=$$$ERROR("The grammar of "_dim2_" is invalid!")
				  q
				}
				s bracketsFlag=1
				s proFun=##class(DHCWL.DM.Util.StringUtil).Trim( $e(dim2,1,parasi-1) )
				s paramStr=##class(DHCWL.DM.Util.StringUtil).Trim( $e(dim2,parasi+1,dim2Ind-1) )
		  }elseif (dim2c="'") && (dimFunStack.Peek()'="'"){
				d dimFunStack.Push(dim2c)
		  }elseif (dim2c="'") && (dimFunStack.Peek()="'"){
				d dimFunStack.Pop()
		  }
    }
    q:status'=$$$OK status
    i (bracketsFlag=1)&&((proFun="")){
		  s status=$$$ERROR("The grammar of "_dim2_" is invalid!")
		  q status
    }elseif (bracketsFlag=0){
		  s proFun=##class(DHCWL.DM.Util.StringUtil).Trim(dim2)
    }
    b ;1
    k ..allUsingDimMetricMap(type,proFun)
    ;s proFun=$p(dim2,"(",1)
    ;s paramStr=##class(DHCWL.DM.Util.StringUtil).Trim( $p($p(dim2,"(",2),")",1) )
    s paramStrLen=$l(paramStr)
    i $e(paramStr,paramStrLen)'=","{
		  s paramStr=paramStr_","
		  s paramStrLen=paramStrLen+1
    }
    s proFunStack=##class(DHCWL.DM.Util.Stack).%New()
    s paramIndS=1
    s paramList=$lb()
    s paramListCount=0
    f m=1:1:paramStrLen{
		  s char=$e(paramStr,m)
		  i (char=",")&&(proFunStack.Size()=0){
		    s theParam=##class(DHCWL.DM.Util.StringUtil).Trim($e(paramStr,paramIndS,m-1))
		    s theParam=##class(DHCWL.DM.Util.StringUtil).Trim(theParam,"'")
		    s paramListCount=paramListCount+1
		    s $list(paramList,paramListCount)=theParam
		    s paramIndS=m+1
		  }elseif ((char="'")&&(proFunStack.Peek()'="'")){
				d proFunStack.Push(char)
		  }elseif ((char="'")&&(proFunStack.Peek()="'")){
				d proFunStack.Pop()
		  }
    }
    if (callFunType=1){
		  s proFun=dimPro.Expression
		  s funCall=##class(DHCWL.DM.Util.FunctionCall).%New("DYCDIMPRO:"_proFun)
		  s funCofnig=funCall.FunctionConfig
		  s defParams=themeDims.GetUsingParameters(funCofnig)
    }elseif (callFunType=2){
		  s dimFun=themeDims.ProExpression
		  s funCall=##class(DHCWL.DM.Util.FunctionCall).%New("TDYNFUN:"_dimFun)
		  if (funCall=""){
		    s status=$$$ERROR("Can't get function of "_dim2_"")
		  }
		  s funCofnig=funCall.FunctionConfig
		  s defParams=themeDims.GetUsingParameters(funCofnig)
    }
    s defParamLen=defParams.Count(),paramListCount=0
    s runtimeParams=$lb(),paramSNs=$lb()
    s linkBase=curDimStruct.linkBase
    f defParamInd=1:1:defParamLen{
		  s $list(paramSNs,defParamInd)=0
		  s defParam=defParams.GetAt(defParamInd)
		  s paraPos=defParam.ParaIndex
		  if defParam.ParamType.Code="EVALPASSBYVAR"{
				s pvar= defParam.Name
				if (callFunType=1){
				  s psn=##class(DHCWL.DM.T.DimDStructMap).GetMapPosition(linkBase.%Id(),linkBase.GetProperty(pvar).%Id())
				}else{
				  s pdim=linkBase.GetDim(pvar)
				  s psn=pdim.SerialNumber
				  if (pdim.DimType.GetPath()="TD:R"){
					s psn=psn_"#R"
				  }
				}
				s ..proFunStruct(type,dimExpIndex,i,"DP",paraPos)=psn
				
				s $list(paramSNs,paraPos)=psn
				s $list(runtimeParams,paraPos)=""
		  }elseif defParam.ParamType.Code="EVALPASSBYPOS"{
				s ..proFunStruct(type,dimExpIndex,i,"SP",paraPos)=""
				if (callFunType=1){
				  s $list(paramSNs,paraPos)=sn
				}else{
			      s $list(paramSNs,paraPos)=sn_"#R"
				}
				s $list(runtimeParams,paraPos)=""
		  }elseif defParam.ParamType.Code="CONSTANTEVALPASS"{
				s paramListCount=paramListCount+1
				s $list(runtimeParams,paraPos)=$lg(paramList,paraPos)
		  }else{
				s $list(runtimeParams,paraPos)=defParam.DefaultValue
		  }
    }
    s $list(structList,j+3)=$lg(structList,j+3)_"#"
    s ..proFunStruct(type,dimExpIndex,i,"D")=linkBase.%Id()
    s ..proFunStruct(type,dimExpIndex,i,"P")=runtimeParams
    s ..proFunStruct(type,dimExpIndex,i,"SI")=j
    s ..proFunStruct(type,dimExpIndex,i,"F")=##class(DHCWL.DM.Util.FunctionCall).%New("DYCDIMPRO:"_proFun)
    s funCallStruct=##class(ParsedFunctionCallStruct).%New()
    s funCallStruct.paramValues=runtimeParams
    s funCallStruct.paramSNs=paramSNs
    s funCallStruct.funCall=funCall
    s curDimStruct.funCallStruct=funCallStruct
    d defParams.Clear()
    s funCofnig=""
    s funCall=""
    q $$$OK
}

// d ##class(DHCWL.DM.Core.InternalResolvedParser).ParseAlias("count() ON (AdmType)",.map)

ClassMethod ParseAlias(expression, ByRef aliasResult)
{
	k aliasResult
	s expression=##class(DHCWL.DM.Util.StringUtil).Trim(expression)
	s len=$l(expression)
	s aliasResult("S")=expression
	f i=len:-1:1{
	  s char=$e(expression,i)
	  if ( ##class(DHCWL.DM.Util.StringUtil).IsSpace(char)'=0 ){
	    s aliasResult("A")=##class(DHCWL.DM.Util.StringUtil).Trim( $e(expression,i+1,len) )
	    s pre=##class(DHCWL.DM.Util.StringUtil).Trim( $e(expression,1,i) )
	    s len2=$l(pre)
		if $zcvt($e(pre,len2-1,len2),"U")="AS" {
		  s pre=##class(DHCWL.DM.Util.StringUtil).Trim($e(expression,1,len2-2))
		}
		s aliasResult("S")=pre
		q
	  }elseif char=")"{
		q
	  }
	}
}

Method ParseCubeDimExpStruct() As %Status [ Private ]
{
	s status=$$$OK
	m themeDimStru=..dimsShowInd
	m ..cubeDimsShowInd=themeDimStru
	s i="" f {
	  s i=$o(themeDimStru(i))
	  q:i=""
	  s dimStructObj=..parsedDimStuList.GetAt(i)
	  s ts=themeDimStru(i,"S")
	  s tdid=$lg(ts,1,"")
	  s dimStu=..parsedDimStuList.GetAt(i)
	  if (dimStu.IsFunctionCall()){
			continue
	  }
	  i tdid=""{
			s status=$$$ERROR("theme dim id can't null with:"_$lts(ts))
			q
	  }
	  s cdid=..RefCube.GetCubeDimId(tdid)
	  if cdid=""{
			s status=$$$ERROR("Can't get cubeDim with theme dim id:"_tdid)
			q  
	  }
	  s csn=..RefCube.GetDimSN(tdid)
	  s $list(..cubeDimsShowInd(i,"S"),1)=cdid
	  s $list(..cubeDimsShowInd(i,"S"),3)=csn
	  s dimStructObj.SN=csn
	}
	q status
}

Method ParseFilter(ByRef rootNode As DHCWL.DM.Util.FilterTree) As %Status
{
	s status=$$$OK
	s rootNode=..ParseFilterRecursion(..RefTheme,..jsonExpStruct("FILTER"),"",.status)
	;d ..VisitDG(rootNode)
	q status
}

Method ParseFilterRecursion(theme As %SerialObject, filter As %String, parent As DHCWL.DM.Util.FilterTree, ByRef status As %Status, type = "F") As DHCWL.DM.Util.FilterTree
{
	q:filter="" ""
	q:status'=$$$OK ""
	s filter=##class(DHCWL.DM.Util.StringUtil).Trim(filter)
	s len=$l(filter),LO("&")=2,LO("|")=2,LO("!")=1
	s node=""
	s stack=##class(DHCWL.DM.Util.Stack).%New()
	s char="",preChar="",hasLogicalFlag=0,minLevel=999999,minLevelIndex=1,matchLogical=""
	f i=1:1:len {
	  s preChar=char
	  s char=$e(filter,i)
	  i ( ($d(LO(char))) && (stack.Peek()'="'")  ) {
	    if ( ((LO(char)=2) && (char=preChar)) || (LO(char)=1) ) {
	      i stack.Size()<minLevel {
	        s minLevel=stack.Size()
	        s minLevelIndex=i
	        s matchLogical=char
	      }
	      s hasLogicalFlag=1
	    }
	  }elseif ( (char="'") && (stack.Peek()'="'")) {
	    d stack.Push(char)
	  }elseif ( (char="'") && (stack.Peek()="'") && (preChar'="\")) {
	    d stack.Pop()
	  }elseif ( (char="(") && (stack.Peek()'="'") ) {
	    d stack.Push(i)
	    d stack.Push(char)
	  }elseif ( (char=")") && (stack.Peek()'="'") && (stack.Peek()="(") ) {
	    d stack.Pop()
	    d stack.Pop()
	  }
	}
	if stack.Size()'=0 {
	  s status=$$$ERROR("The grammar of "_filter_" is invalid")
	  q node
	}
	i hasLogicalFlag=0 {
	  s node=##class(DHCWL.DM.Util.FilterTree).%New(0)
	  d node.SetParent(parent)
	  while ( ($e(filter,1)="(") &&($e(filter,len)=")")){
	    s filter=$e(filter,2,len-1)
	    s filter=##class(DHCWL.DM.Util.StringUtil).Trim(filter)
	    s len=$l(filter)
	  }
	  s status= ..BuildOneFilterExpTree(theme,filter ,node,type)
	}else{
	  s nodeType=2
	  s leftEndInd=minLevelIndex-2
	  s rightStartInd=minLevelIndex+1
	  i matchLogical="!" {
			s nodeType=1
			s leftEndInd=minLevelIndex-1
			s rightStartInd=minLevelIndex+1
			s status=$$$ERROR("Not supported logical operator !")
			q ""
	  }
	  s node=##class(DHCWL.DM.Util.FilterTree).%New(nodeType)
	  d node.SetLogical(matchLogical)
	  s lsi=1,continueFlag=0,preChar="",char2=""
	  for j=leftEndInd:-1:1 {
		s preChar=char2
	    s char2=$e(filter,j)
	    if ( (char2="'") && (stack.Peek()'="'")) {
	      d stack.Push(char2)
	    }elseif ( (char2="'") && (stack.Peek()="'") && (preChar'="\")) {
	      d stack.Pop()
	    }elseif ( (char2=")") && (stack.Peek()'="'") ) {
	      d stack.Push(char2)
	    }elseif ( (char2="(") && (stack.Peek()'="'") && (stack.Peek()=")") ) {
	      d stack.Pop()
	    }elseif ( (char2="(") || (char2=")") ) {
		  s continueFlag=1
	      continue
	    }elseif ((continueFlag=1)&&(##class(DHCWL.DM.Util.StringUtil).IsSpace(char2))){
		  continue
	    }
	    s lsi=j
	    s continueFlag=0
	  }
	  s left=##class(DHCWL.DM.Util.StringUtil).Trim( $e(filter,lsi,leftEndInd) )
	  if (left="")&& (nodeType=2){
		  s status=$$$ERROR("The grammar of "_filter _" is invalid!")
		  q ""
	  }
	  d stack.Clear()
	  s rei=len,preChar="",char2=""
	  f j=rightStartInd:1:len {
		s preChar=char2
	    s char2=$e(filter,j)
	    i ( (char2="'") && (stack.Peek()'="'")){
	      d stack.Push(char2)
	    }elseif ( (char2="'") && (stack.Peek()="'") && (preChar'="\")) {
	      d stack.Pop()
	    }elseif ( (char2="(") && (stack.Peek()'="'") ) {
	      d stack.Push(char2)
	    }elseif( (char2=")") && (stack.Peek()'="'") && (stack.Peek()="(") ) {
	      d stack.Pop()
	      s:(stack.Size()=0) rei=j
	    }elseif ( (char2="(") || (char2=")") ) {
		  s continueFlag=1
	      continue
	    }elseif ((continueFlag=1)&&(##class(DHCWL.DM.Util.StringUtil).IsSpace(char2))){
		  continue
	    }
	    s continueFlag=0
	    s rei=j
	  }
	  /*f j=rei+1:1:len {
	    s char=$e(filter,j)
	    if (  (char="(") || (char=")") ) {
		  q  
	    }else{
		  s rei=rei+1
	    }
	  }*/
	  s right=##class(DHCWL.DM.Util.StringUtil).Trim( $e(filter,rightStartInd,rei) )
	  if (right="")&& (nodeType=2){
		  s status=$$$ERROR("The grammar of "_filter _" is invalid!")
		  q ""
	  }
	  ;w "logical:"_matchLogical,!
	  ;w "left:"_left,!
	  ;w "right:"_right,!
	  d:left'="" node.SeLeft(..ParseFilterRecursion(theme,left,node,.status))
	  d:right'="" node.SetRight(..ParseFilterRecursion(theme,right,node,.status))
	}
	q node
}

Method BuildOneFilterExpTree(theme As %SerialObject, filterExp, node As DHCWL.DM.Util.FilterTree, type = "F") As %Status [ Private ]
{
	s status=$$$OK
	d node.SetExpression(filterExp)
	;q status
	s dimPro="",fun="",para="",char="",preChar=""
	s len=$l(filterExp)
	s stack=##class(DHCWL.DM.Util.Stack).%New()
	//b:(filterExp [ "isnull")
	f i=len:-1:1{
	  s preChar=char
	  s char=$e(filterExp,i)
	  if ((char=")")&&(stack.Peek()'="'")){
			d stack.Push(i)
	  }elseif ((char="(")&&(stack.Peek()'="'")){
			s pe= stack.Pop()
			if stack.Size()=0{
			  s para=##class(DHCWL.DM.Util.StringUtil).Trim($e(filterExp,i+1,pe-1))
			  s filterExp2=##class(DHCWL.DM.Util.StringUtil).Trim($e(filterExp,1,i-1))
			  s len2=$l(filterExp2)
			  f j=len2:-1:1{
					s char2=$e(filterExp2,j)
					if ##class(DHCWL.DM.Util.StringUtil).IsSpace(char2){
					  s fun=##class(DHCWL.DM.Util.StringUtil).Trim($e(filterExp2,j+1,len2))
					  s dimPro=##class(DHCWL.DM.Util.StringUtil).Trim($e(filterExp2,1,j-1))
					  q
					}
			  }
			  q
			}
	  }elseif ((char="'") && (preChar'="\") && (stack.Peek()'="'")){
			d stack.Push(char)
	  }elseif ((char="'") && (preChar'="\") && (stack.Peek()="'") ){
			d stack.Pop()
	  }
	}
	q:stack.Size()'=0 $$$ERROR("The grammar of "_filterExp_" is invalid!")
	/*s i=0,j=0 f{
	  s i=$f(filterExp,">",i+1)
	  q:i=0
	  s j=i
	}
	if j>0 {
	  f i=j:1:len {
	    s char=$e(filterExp,i)
	    if ##class(DHCWL.DM.Util.StringUtil).IsSpace(char)=1{
		  s j=i+1
	    } else {
		  q
	    }
	  }
	}else{
	  s j=1
	}
	f i=j:1:len {
	  s char=$e(filterExp,i)
	  i ##class(DHCWL.DM.Util.StringUtil).IsSpace(char)=1 {
	    s dimPro=$e(filterExp,1,i)
	    s funPar=##class(DHCWL.DM.Util.StringUtil).Trim($e(filterExp,i+1,len))
	    s fun=##class(DHCWL.DM.Util.StringUtil).Trim($p(funPar,"(",1))
	    s para=##class(DHCWL.DM.Util.StringUtil).Trim($p($p(funPar,"(",2),")",1))
	    q
	  }
	}*/
	;b ;BuildOneFilterExpTree
	if ( (dimPro'="") && (fun'="") ) {
	  s paramList=$lb(),paramLen=0
	  s para2=para_","
	  s len=$l(para2),parasi=1
	  f i=1:1:len {
	    s char=$e(para2,i)
	    if ( (char="[") && (stack.Peek()'="'") ){
			  ;d stack.Push(char)
			  s lb=$lb(),lbc=0,lbsi=i+1
			  f j=i+1:1:len{
					s char2=$e(para2,j)
					if ( (char2="'") && (stack.Peek()'="'") ) {
					  d stack.Push(char2)
					}elseif( (char2="'") && (stack.Peek()="'") ) {
						d stack.Pop()
					}elseif((char2=",") && (stack.Peek()'="'") ) {
						s pv=$e(para2,lbsi,j-1)
						s pv=##class(DHCWL.DM.Util.StringUtil).Trim(pv,"'")
						s lbsi=j+1
						s lbc=lbc+1
						s:pv="" pv=$c(0)
						s $list(lb,lbc)=pv
					}elseif( (char2="]") && (stack.Peek()'="'") ){
						s pv=$e(para2,lbsi,j-1)
						s pv=##class(DHCWL.DM.Util.StringUtil).Trim(pv,"'")
						s lbc=lbc+1
						s:pv="" pv=$c(0)
						s $list(lb,lbc)=pv
						s paramLen=paramLen+1
						s $list(paramList,paramLen)=lb
						f m=j+1:1:len{
							s char2=$e(para2,m)
							if char2=","{
								s i=m
								q
							}
						}
						q
					}
			  }
	    }elseif( (char="'") && (stack.Peek()'="'") ) {
	      d stack.Push(char)
	    }elseif( (char="'") && (stack.Peek()="'") ) {
	      d stack.Pop()
	    }elseif((char=",") && (stack.Peek()'="'") ) {
	      s pv=$e(para2,parasi,i-1)
	      s pv=##class(DHCWL.DM.Util.StringUtil).Trim(pv,"'")
	      s:pv="" pv=$c(0)
	      s parasi=i+1
	      s paramLen=paramLen+1
	      s $list(paramList,paramLen)=pv
	    }
	  }
	  q:stack.Size()'=0 $$$ERROR(para_" is invalide!")
	  i node.NodeType=0 {
	    s dimStruct=$lb()
	    s funind=$i(..proFunStruct(type))
	    ;if dimPro ["PAADM" b ;BuildOneFilterExpTree->ParseDimExp
	    s status= ..ParseDimExp(theme,dimPro,.dimStruct,type,funind,.parsedDimStu)
	    q:status'=$$$OK status
	    s node.Params=paramList
	    s node.FilterFunction=fun
	    s node.DimStruct=dimStruct
	    s node.proFunStructIndex=funind
	    s funCall=##class(DHCWL.DM.Util.FunctionCall).%New("FILTER:"_fun,paramList)
	    s node.FunCall=funCall
	    s node.parsedDimStruct=parsedDimStu
	  }
	}else{
	  s status=$$$ERROR("The grammar of "_filterExp_" is invalid!")
	}
	q status
}

Method FilterParse() As %Status
{
	q ..FilterFunctionParse(..FilterRootNode)
}

Method FilterParse2(isUpdateFilter As %Boolean = 0) As %Status
{
	q ..FilterFunctionParse2(..FilterRootNode,isUpdateFilter)
}

Method FilterFunctionParse(node As DHCWL.DM.Util.FilterTree) As %Status [ Private ]
{
	q:node="" $$$OK
	s status=$$$OK
	d ..FilterFunctionParse(node.Left)
	d ..FilterFunctionParse(node.Right)
	if node.NodeType=0 {
	  ;w "struct:"_$lts(node.DimStruct),!
	  s cubeId=..RefCube.Mask()
	  s funCall=##class(DHCWL.DM.Util.FunctionCall).%New("FILTER:"_node.FilterFunction,node.Params)
	  s dimId=$lg(node.DimStruct,1,"")
	  s sn=..RefCube.GetDimSN(dimId)
	  q:sn<1 $$$ERROR("Can't get dim serial number from cube path "_..RefCube.GetPath())
	  i $ll(node.DimStruct)>4{
			s status=##class(DHCWL.DM.T.DimDataIndex).BacksteppingFromeFilter(node,funCall,.paraList)
	  }else{
			b ;0
			if ..IsRoot{
		      s paraList=##class(DHCWL.DM.T.CubeDStruct).BacksteppingDimsFromeFilter(cubeId,..PartList,$lb(dimId,,sn),node,funCall)
			}else{
			  //s cubeId=..Parent.RefCube.Mask()
			  ;b ;00
			  s dimMask=..Parent.dimsShowInd
			  s paraList=##class(DHCWL.DM.T.CubeDStruct).BacksteppingCCDimsFromeFilter(cubeId,..PartList,dimMask,$lb(dimId,,sn),node,funCall)
			}
	    
	  }
	  k segBitIndex
	  ;b ;1
	  if (..IsRoot){
		s segBitIndex=""
		d ##class(DHCWL.DM.T.CubeDStruct).FetchBitIndexFromDims(cubeId,..PartList,$lb(dimId,,sn),paraList,.segBitIndex)
	    m node.SegBitIndexMap=segBitIndex
	    ;zw segBitIndex
	  }else{
		s dimMask=..Parent.dimsShowInd
		s segBitIndex=""
		d ##class(DHCWL.DM.T.CubeDStruct).FetchCCBitIndexFromDims(cubeId,..PartList,dimMask,$lb(dimId,,sn),paraList,.segBitIndex)
	    m node.SegBitIndexMap=segBitIndex
	    ;zw segBitIndex
	  }
	  
	}
	q status
}

Method FilterFunctionParse2(node As DHCWL.DM.Util.FilterTree, isUpdateFilter As %Boolean = 0) As %Status [ Private ]
{
	q:node="" $$$OK
	s status=$$$OK
	d ..FilterFunctionParse2(node.Left,isUpdateFilter)
	d ..FilterFunctionParse2(node.Right,isUpdateFilter)
	if node.NodeType=0 {
	  ;w "struct:"_$lts(node.DimStruct),!
	  s cubeId=..RefCube.Mask()
	  s funCall=node.FunCall
	  s dimId=$lg(node.DimStruct,1,"")
	  s sn=..RefCube.GetDimSN(dimId)
	  q:sn<1 $$$ERROR("Can't get dim serial number from cube path "_..RefCube.GetPath())
	  i $ll(node.DimStruct)>4{
			;b ;(DHCWL.DM.T.DimDataIndex).BacksteppingFromeFilter
			m tmpProFunStruct=..proFunStruct
			s status=##class(DHCWL.DM.T.DimDataIndex).BacksteppingFromeFilter(node,funCall,.paraList,.tmpProFunStruct)
	  }else{
			if ..IsRoot{
	      s paraList=##class(DHCWL.DM.T.CubeDStruct).BacksteppingDimsFromeFilter1(cubeId,..PartList,$lb(dimId,,sn),node,funCall)
			}else{
		  	//s cubeId=..Parent.RefCube.Mask()
		  	;b ;00
		  	s dimMask=..Parent.dimsShowInd
		  	s paraList=##class(DHCWL.DM.T.CubeDStruct).BacksteppingCCDimsFromeFilter2(cubeId,..PartList,dimMask,$lb(dimId,,sn),node,funCall)
			}
	  }
	  k segBitIndex
	  if (..IsRoot){
			;s segBitIndex=""
			d ##class(DHCWL.DM.T.CubeDStruct).FetchBitIndexFromDims2(cubeId,..PartList,$lb(dimId,,sn),node,paraList,isUpdateFilter)
	    ;m node.SegBitIndexMap=segBitIndex
	    ;zw segBitIndex
	  }else{
			s dimMask=..Parent.dimsShowInd
			s segBitIndex=""
			d ##class(DHCWL.DM.T.CubeDStruct).FetchCCBitIndexFromDims2(cubeId,..PartList,dimMask,$lb(dimId,,sn),paraList,.segBitIndex)
	    m node.SegBitIndexMap=segBitIndex
	    ;zw segBitIndex
	  }
	  
	}
	q status
}

Method FilterFunctionParse3(node As DHCWL.DM.Util.FilterTree) As %Status [ Private ]
{
	q:node="" $$$OK
	s status=$$$OK
	d ..FilterFunctionParse2(node.Left)
	d ..FilterFunctionParse2(node.Right)
	if node.NodeType=0 {
	  ;w "struct:"_$lts(node.DimStruct),!
	  s cubeId=..RefCube.Mask()
	  s funCall=node.FunCall
	  s parsedStu=node.parsedDimStruct
	  s dimStu=parsedStu.Tail()
	  s visitCount=1
	  k inputIdMap,outputIdMap
	  while(dimStu'=""){
		if (dimStu.IsVisitTheme()){
		  d ##class(DHCWL.DM.T.CubeDStruct).BacksteppingThemeFromFilter(cubeId,..PartList,dimStu,node,visitCount,.inputIdMap,.outputIdMap)
		  k inputIdMap
		}else{
			
		}
		
		k inputIdMap
		m inputIdMap=outputIdMap
		k outputIdMap
		s visitCount=visitCount+1
		s dimStu=dimStu.GetPrevious()
	  }
	  
	  k segBitIndex
	  ;b ;1
	  if (..IsRoot){
		s segBitIndex=""
		d ##class(DHCWL.DM.T.CubeDStruct).FetchBitIndexFromDims2(cubeId,..PartList,$lb(dimId,,sn),paraList,.segBitIndex)
	    m node.SegBitIndexMap=segBitIndex
	    ;zw segBitIndex
	  }else{
		s dimMask=..Parent.dimsShowInd
		s segBitIndex=""
		d ##class(DHCWL.DM.T.CubeDStruct).FetchCCBitIndexFromDims2(cubeId,..PartList,dimMask,$lb(dimId,,sn),paraList,.segBitIndex)
	    m node.SegBitIndexMap=segBitIndex
	    ;zw segBitIndex
	  }
	  
	}
	q status
}

Method GetFilterTargetBit()
{
	d ..GetFilterTargetBitHelper(..FilterRootNode)
}

Method GetFilterTargetBitHelper(node As DHCWL.DM.Util.FilterTree) [ Private ]
{
	q:((node="")||(node.NodeType=0))
	if ((node.NodeType=1) && (node.LogicalOperator="!")){
	  d ..GetFilterTargetBitHelper(node.Right)
	  m rightBitMap=node.Right.SegBitIndexMap
	  f j=1:1:$ll(..PartList){
			s partInd=$lg(..PartList,j)
			continue:(partInd="")
			if '$d(rightBitMap(partInd)){
				s tmpbitval=""
				s $bit(tmpbitval,1)=0
				s node.SegBitIndexMap(partInd)=0
				s node.SegBitIndexMap(partInd,0)=tmpbitval
				continue
			}
	    f i=0:1:rightBitMap(partInd){
	      continue:'$d(rightBitMap(partInd,i))
			  s bit=rightBitMap(partInd,i)
			  s node.SegBitIndexMap(partInd)=i
			  s node.SegBitIndexMap(partInd,i)=$bitlogic(~ bit)
	    }
	  }
	}elseif ((node.NodeType=2) && (node.LogicalOperator="&")){
		d ..GetFilterTargetBitHelper(node.Left)
		d ..GetFilterTargetBitHelper(node.Right)
		s leftBitMap="",rightBitMap=""
		m leftBitMap=node.Left.SegBitIndexMap,rightBitMap=node.Right.SegBitIndexMap
		k resultBitMap
		f j=1:1:$ll(..PartList){
		  s partInd=$lg(..PartList,j)
		  continue:partInd=""
		  s:('$d(leftBitMap(partInd)))||(leftBitMap(partInd)="") leftBitMap(partInd)=0
		  s:('$d(rightBitMap(partInd)))||(rightBitMap(partInd)="") rightBitMap(partInd)=0
		  s maxI=leftBitMap(partInd)
		  s:maxI<rightBitMap(partInd) maxI=rightBitMap(partInd)
		  s resultBitMap(partInd)=maxI
		  f i=0:1:maxI {
				s bit1=$g(leftBitMap(partInd,i),"")
				s bit2=$g(rightBitMap(partInd,i),"")
				s resultBitMap(partInd,i)=$bitlogic(bit1 & bit2)
		  }
		}
		m node.SegBitIndexMap=resultBitMap
		if ($d(node.Left.RMBitIMap))&&($d(node.Right.RMBitIMap)){
			k resultBitMap,leftBitMap,rightBitMap
			m leftBitMap=node.Left.RMBitIMap,rightBitMap=node.Right.RMBitIMap
			f j=1:1:$ll(..PartList){
			  s partInd=$lg(..PartList,j)
			  continue:partInd=""
			  continue:'$d(leftBitMap(partInd))
			  s rowid="" f{
					s rowid=$o(leftBitMap(partInd,rowid))
					q:rowid=""
					s msn="" f{
						s msn=$o(leftBitMap(partInd,rowid,msn))
						q:msn=""
						s mseg="" f{
							s mseg=$o(leftBitMap(partInd,rowid,msn,mseg))
							q:mseg=""
							s leftbit=leftBitMap(partInd,rowid,msn,mseg)
							if $d(rightBitMap(partInd,rowid,msn,mseg)){
								s rightbit=rightBitMap(partInd,rowid,msn,mseg)
								s resultBitMap(partInd,rowid,msn,mseg)=$bitlogic(leftbit & rightbit)
								//s $bit(resultBitMap(partInd,rowid,msn,mseg),1)=0
							}
						}
					} 
			  }
			}
			m node.RMBitIMap=resultBitMap
		}elseif $d(node.Left.RMBitIMap){
			m node.RMBitIMap=node.Left.RMBitIMap
		}elseif $d(node.Right.RMBitIMap){
			m node.RMBitIMap=node.Right.RMBitIMap
		}
	}elseif ((node.NodeType=2) && (node.LogicalOperator="|")){
		d ..GetFilterTargetBitHelper(node.Left)
		d ..GetFilterTargetBitHelper(node.Right)
		s leftBitMap="",rightBitMap=""
		m leftBitMap=node.Left.SegBitIndexMap,rightBitMap=node.Right.SegBitIndexMap
		k resultBitMap
		f j=1:1:$ll(..PartList){
		  s partInd=$lg(..PartList,j)
		  continue:partInd=""
		  s:('$d(leftBitMap(partInd)))||(leftBitMap(partInd)="") leftBitMap(partInd)=0
		  s:('$d(rightBitMap(partInd)))||(rightBitMap(partInd)="") rightBitMap(partInd)=0
		  s maxI=leftBitMap(partInd)
		  s:maxI<rightBitMap(partInd) maxI=rightBitMap(partInd)
		  s resultBitMap(partInd)=maxI
		  f i=0:1:maxI {
			s bit1=$g(leftBitMap(partInd,i),"")
			s bit2=$g(rightBitMap(partInd,i),"")
			s resultBitMap(partInd,i)=$bitlogic(bit1 | bit2)
		  }
		}
		m node.SegBitIndexMap=resultBitMap
		if ($d(node.Left.RMBitIMap))&&($d(node.Right.RMBitIMap)){
			k resultBitMap,leftBitMap,rightBitMap
			m leftBitMap=node.Left.RMBitIMap,rightBitMap=node.Right.RMBitIMap
			f j=1:1:$ll(..PartList){
			  s partInd=$lg(..PartList,j)
			  continue:partInd=""
			  continue:'$d(leftBitMap(partInd))
			  s rowid="" f{
					s rowid=$o(leftBitMap(partInd,rowid))
					q:rowid=""
					s msn="" f{
						s msn=$o(leftBitMap(partInd,rowid,msn))
						q:msn=""
						s mseg="" f{
							s mseg=$o(leftBitMap(partInd,rowid,msn,mseg))
							q:mseg=""
							s leftbit=leftBitMap(partInd,rowid,msn,mseg)
							if $d(rightBitMap(partInd,rowid,msn,mseg)){
								s rightbit=leftBitMap(partInd,rowid,msn,mseg)
								s resultBitMap(partInd,rowid,msn,mseg)=$bitlogic(leftbit | rightbit)
							}
						}
					} 
			  }
			}
			f j=1:1:$ll(..PartList){
			  s partInd=$lg(..PartList,j)
			  continue:partInd=""
			  continue:'$d(rightBitMap(partInd))
			  s rowid="" f{
					s rowid=$o(rightBitMap(partInd,rowid))
					q:rowid=""
					s msn="" f{
						s msn=$o(rightBitMap(partInd,rowid,msn))
						q:msn=""
						s mseg="" f{
							s mseg=$o(rightBitMap(partInd,rowid,msn,mseg))
							q:mseg=""
							s rightbit=rightBitMap(partInd,rowid,msn,mseg)
							s resultbit=$g(resultBitMap(partInd,rowid,msn,mseg))
							s resultBitMap(partInd,rowid,msn,mseg)=$bitlogic(resultbit | rightbit)
						}
					} 
			  }
			}
			m node.RMBitIMap=resultBitMap
		}elseif $d(node.Left.RMBitIMap){
			m node.RMBitIMap=node.Left.RMBitIMap
		}elseif $d(node.Right.RMBitIMap){
			m node.RMBitIMap=node.Right.RMBitIMap
		}
	}
}

Method ParseRange(ByRef rangeRootNode As DHCWL.DM.Util.FilterTree) As %Status [ Private ]
{
	s status=$$$OK
	s rangeRootNode=..ParseFilterRecursion(..RefTheme,..jsonExpStruct("RANGE"),"",.status,"R")
	;d ..VisitDG(rangeRootNode)
	q status
}

Method GetRangePartList(node As DHCWL.DM.Util.FilterTree = "", ByRef partList As %List) As %Status [ Private ]
{
	if '..IsRoot{
	  s cubeDPList=##class(DHCWL.DM.T.CubeDSPart).Get(..RefCube.Mask())
	  s len=cubeDPList.Count()
	  f i=1:1:len{
		s $list(partList,i)=cubeDPList.GetAt(i).PartIndex
	  }
	  q
	}
	q:node="" $$$OK
	s status=$$$OK
	d ..FilterFunctionParse(node.Left)
	d ..FilterFunctionParse(node.Right)
	if node.NodeType=0 {
	  s cubeId=..RefCube.Mask()
	  s funCall=##class(DHCWL.DM.Util.FunctionCall).%New("FILTER:"_node.FilterFunction,node.Params)
	  s rs= funCall.Call()
	  if $lv(rs){
		k map
		s rsLen=$ll(rs)
		f i=1:1:rsLen{
		  s v=$lg(rs,i,"")
		  continue:v=""
		  s cubeDPList=##class(DHCWL.DM.T.CubeDSPart).Get(cubeId,v)
		  s len=cubeDPList.Count()
	      f j=1:1:len{
		    s map(cubeDPList.GetAt(j).PartIndex)=""
	      }
		}
		s partInd="",lbCount=0 f{
		  s partInd=$o(map(partInd))
		  q:partInd=""
		  s lbCount=lbCount+1
		  s $list(partList,lbCount)=partInd
		}
	  }elseif rs'=""{
		s cubeDPList=##class(DHCWL.DM.T.CubeDSPart).Get(cubeId,rs)
		s len=cubeDPList.Count()
	    f i=1:1:len{
		  s $list(partList,i)=cubeDPList.GetAt(i).PartIndex
	    }
	  }
	}
	q status
}

Method VisitDG(node As DHCWL.DM.Util.FilterTree) [ Private ]
{
	q:node=""
	w:node.LogicalOperator'="" "Logical:"_node.LogicalOperator,!
	w:node.Expression'="" node.Expression,!
	d ..VisitDG(node.Left)
	d ..VisitDG(node.Right)
}

Method ParseAggExps() As %Status [ Private ]
{
	s status=$$$OK
	s metrics=..jsonExpStruct("AGGS")
	q:metrics="" $$$OK
	s metrics=metrics_","
	s len=$l(metrics)
	s stack=##class(DHCWL.DM.Util.Stack).%New()
	s metricsi=1,count=0
	f i=1:1:len {
	  s char=$e(metrics,i)
	  i ( (char="'") && (stack.Peek()'="'") ) {
	    d stack.Push(char)
	  }elseif ( (char="'") && (stack.Peek()="'") ){
	    d stack.Pop()
	  }elseif( (char="(") && (stack.Peek()'="'") ){
	    d stack.Push(char)
	  }elseif( (char=")") && (stack.Peek()="(") ){
	    d stack.Pop()
	  }elseif( (char=",") && (stack.Peek()'="'") && (stack.Peek()'="(") ){
	    s metric=$e(metrics,metricsi,i-1)
	    s metricsi=i+1
	    s count=count+1
	    s status= ..ParseOneAggExp(..RefTheme,metric,count)
	    q:status'=$$$OK
	  }
	}
	q:status'=$$$OK status
	q:stack.Size()'=0 $$$ERROR("The grammer is invalid of "_metrics)
	q status
}

Method ParseOneAggExp(themeBase As %SerialObject, aggExp, showIndex As %Integer) As %Status [ Private ]
{
	s status=$$$OK
	s aggExp=##class(DHCWL.DM.Util.StringUtil).Trim(aggExp)
	q:aggExp="" status
	//TODO resolve alias
	s len=$l(aggExp)
	s alias=""
	d ..ParseAlias(aggExp,.aliasMap)
	s alias=$g(aliasMap("A"),"")
	s aggExp=aliasMap("S")
	if (alias=""){
	  if (aggExp [ ")"){
		s alias="agg"_showIndex
	  }else{
		s alias=aggExp
	  }
	  
	}
	s ..metricsShowInd(showIndex,"A")=alias
	s len=$l(aggExp),preChar="",char=""
	s stack=##class(DHCWL.DM.Util.Stack).%New()
	s aggFlag=0
	for i=len:-1:1 {
	  s preChar=char
	  s char=$e(aggExp,i)
	  if char=")"{
		d stack.Push(char)
		s aggFlag=1  
	  }elseif char="("{
		d stack.Pop()  
	  }elseif ( (aggFlag=1)&& (stack.Size()=0)&& ($zcvt(char,"U")="O") && ($zcvt(preChar,"U")="N") ){
		s partDims=##class(DHCWL.DM.Util.StringUtil).Trim($e(aggExp,i+2,len))
		if '(($e(partDims,1)="(")&&($e(partDims,$l(partDims))=")")){
		  s status=$$$ERROR("The grammer: "_aggExp_"'s windiow function of partition is invalid!")
		  q
		}
		s partDims=##class(DHCWL.DM.Util.StringUtil).Trim(partDims,"(")
		s partDims=##class(DHCWL.DM.Util.StringUtil).Trim(partDims,")")
		s aggExp=##class(DHCWL.DM.Util.StringUtil).Trim($e(aggExp,1,i-1))
		s partArrLen=$l(partDims,",")
		if partArrLen>0{
		  s ..metricsShowInd(showIndex,"D")=showIndex+100
		}
		f i=1:1:partArrLen{
		  s dim=$p(partDims,",",i)
		  s dim=##class(DHCWL.DM.Util.StringUtil).Trim(dim)
		  if $zcvt(dim,"U")="NULL"{
				s ..metricsShowInd(showIndex,"D",i)=0
		    s ..metricsShowInd(showIndex,"DSN",i)=0
		    continue
		  }
		  if '$d(..aliasMap(3,"A",dim)){
				s status=$$$ERROR(dim_" must be in dims list:"_..jsonExpStruct("DIMS"))
				q
		  }
		  s ..metricsShowInd(showIndex,"D",i)=dim
		  s ..metricsShowInd(showIndex,"DSN",i)=..aliasMap(3,"A",dim)
		  /*s status=..ParseDimExp(themeBase,dim,.dimStruct,"P")
		  if status'=$$$OK{
			s status=$$$ERROR("Can't resolve dim:"_dim_" in "_aggExp_" ON ("_partDims_")")
			q
		  }
		  s ..metricsShowInd(showIndex,"D",i,"S")=dimStruct*/
		}
		q
	  }
	}
	//b ;ParseOneAggExp
	q:status'=$$$OK status
	if (aggFlag=0){
	  s matricObj=themeBase.GetMetric(aggExp)
	  s ..metricsShowInd(showIndex,"M")=matricObj.SerialNumber
	  d ..aggFunctionCallList.InsertAt("",showIndex)
	}
	k funMapConfig
	d ##class(DHCWL.DM.T.CubeMetrics).ResolveExpression(aggExp,.funMapConfig)
	s fun=""
	f {
	  s fun=$o(funMapConfig(fun))
	  q:fun=""
	  s funConfig=##class(DHCWL.DM.T.FunctionConfig).GetByPath("AGG:"_fun)
	  q:funConfig.Type.GetPath()'="FUNCTION:AGG"
	  s funParasDef=funConfig.Parameters()
	  s ..metricsShowInd(showIndex,"F")=fun
	  m ..metricsShowInd(showIndex,"P")=funMapConfig(fun,"P")
	  s params=$lb()
	  if ($d(funMapConfig(fun,"P"))){
		s paraInd="",flag=0
		f{
		  s paraInd=$o(funMapConfig(fun,"P",paraInd))
		  q:paraInd=""
		  s paraDef=funParasDef.GetAt(paraInd)
		  if ((paraDef'="")&&paraDef.IsProperty'=0){
			s metricPro=funMapConfig(fun,"P",paraInd)
			;b ;if themeBase.GetMetric(metricPro)'=""{
			if themeBase.GetMetric(metricPro)'=""{
			  s ..metricsShowInd(showIndex,"P",paraInd,"T")="1"
			  ;s ..metricsShowInd(showIndex,"P",paraInd,"S")=themeBase.GetMetricStructMap(metricPro)
			  d ..AggFormattedList.Insert(metricPro)
			}else{
			  s status=$$$ERROR("Can't get metric property:"_metricPro_" from themeBase:"_themeBase.GetPath())
			  q
			}
		  }else{
			s $list(params,paraInd)=funMapConfig(fun,"P",paraInd)
		  }
		}
		q:status'=$$$OK
	  }
	  s funCall=##class(DHCWL.DM.Util.FunctionCall).%New("AGG:"_fun,params)
	  d ..aggFunctionCallList.InsertAt(funCall,showIndex)
	}
	q:status'=$$$OK status
	;m tmp=..metricsShowInd
	;zw tmp
	
	q status
}

Method ResolveAggMetricPara() [ Private ]
{
	;b ;ResolveAggMetricPara
	s i="" f{
	  s i=$o(..metricsShowInd(i))
	  q:i=""
	  if $d(..metricsShowInd(i,"P")){
		s j="" f{
		  s j=$o(..metricsShowInd(i,"P",j))
		  q:j=""
		  if $d(..metricsShowInd(i,"P",j,"T")){
			 s metric=..metricsShowInd(i,"P",j)
			 s ..metricsShowInd(i,"P",j,"S")=..RefCube.GetMetricStructMap(metric)
		  }
		}
	  }
	}
}

Method ParseSort(sortExp = "") As %Status
{
	s status=$$$OK
	q:sortExp="" status
	s len=$l(sortExp,","),count=0
	f i=1:1:len{
	  s sort=$p(sortExp,",",i)
	  continue:sort=""
	  s count=count+1
	  s status=..ParseOneSortExp(sort,count)
	  q:status'=$$$OK
	}
	i status=$$$OK{
	  s ..sortStructMap=$g(..sortStructMap,0)_"S"
	}
	q status
}

Method ParseOneSortExp(sort, index As %Integer) As %Status
{
	s sort=##class(DHCWL.DM.Util.StringUtil).Trim(sort)
	q:sort="" $$$OK
	s len=$l(sort),field=sort,type=""
	f i=1:1:len{
	  s char=$e(sort,i)
	  if ##class(DHCWL.DM.Util.StringUtil).IsSpace(char){
		s field=$e(sort,1,i-1)
		s type=##class(DHCWL.DM.Util.StringUtil).Trim($e(sort,i+1,len))
		s tlen=$l(type)
		f j=1:1:tlen{
		  s char=$e(type,j)
		  if ##class(DHCWL.DM.Util.StringUtil).IsSpace(char){
			s type=##class(DHCWL.DM.Util.StringUtil).Trim($e(type,j+1,tlen))
			s type=$zcvt(type,"U")
			if $e(type,1)="A"{
			  s type="A"
			}elseif $e(type,1)="D" {
			  s type="D"
			}else{
			  s type="A"
			}
			q
		  }
		}
		q
	  }
	}
	s type=$g(type,"A")
	s type=$zcvt(type,"U")
	if $e(type,1)="D"{
	  s type=-1
	}else {
	  s type=1
	}
	s ft="",fi=0
	if $d(..aliasMap(2,field)){
	  s ft="D"	
	  s fi=..aliasMap(3,"A",field)
	}else{
	  s i="" f{
	    s i=$o(..metricsShowInd(i))
	    q:i=""
	    if ..metricsShowInd(i,"A")=field{
		  s ft="M"
		  s fi=i
		  q
	    }
	  }	
	}
	q:((ft="")||(fi="")) $$$ERROR(sort_" of "_field_" is not dims or metrics, or filed index is null")
	q:(ft="M")&&(('$d(..metricsShowInd(fi,"F")))&&('$d(..metricsShowInd(fi,"M")))) $$$ERROR("metric sort must doing agg operation")
	if (ft="M")&&($d(..metricsShowInd(fi,"M"))){
		s ft="MD" //metric detail
	}
	s ..sortStructMap(1,index)=field
	s ..sortStructMap(1,index,"ST")=type
	s ..sortStructMap(1,index,"FT")=ft
	s ..sortStructMap(1,index,"FI")=fi
	s ..sortStructMap(2,field)=index
	s ..sortStructMap(ft,index)=""
	s ..sortStructMap=$g(..sortStructMap,0)+1
	q $$$OK
}

Method BuildComputedTheme() As %Status [ Private ]
{
	s ctheme= ##class(DHCWL.DM.R.ComputedThemeBase).%New(..ResultSetName)
	;m aliasMap=..aliasMap
	;zw aliasMap
	;b ;1
	s si="" f {
	  s si=$o(..aliasMap(3,"P",si))
	  q:si=""
	  s alias=..aliasMap(3,"P",si)
	  s dimStructList=..dimsShowInd(si,"S")
	  s dsll=$ll(dimStructList)
	  s dimId=2
	  s:dsll>4 dimId=1
	  ;b ;2
	  ;if $g(alias,"")="hosDr" b ;hosDr
	  d ctheme.AddDim(alias,$list(dimStructList,dsll-3,dsll),dimId)
	}
	s si="" f{
	  s si=$o(..metricsShowInd(si))
	  q:si=""
	  s metric=..metricsShowInd(si,"A")
	  d ctheme.AddMetric(metric,$lb(metric))
	}
	s ctheme.ResultSetName=..ResultSetName
	if ..IsInnerJoin(){
	  s ctheme.FromThemPath=..jsonExpStruct("FROM")
	}else{
	  s ctheme.FromThemPath=..RefTheme.GetPath()
	}
	
	s ..ComputedTheme=ctheme
	s ctheme=""
}

Method BuildComputedCube() As %Status [ Private ]
{
	s ..ComputedCube=##class(DHCWL.DM.R.ComputedCubeBase).%New(..ComputedTheme)
}

Method GetComputedTheme() As DHCWL.DM.R.ComputedThemeBase
{
	q ..ComputedTheme
}

Method GetComputedCube() As DHCWL.DM.R.ComputedCubeBase
{
	q ..ComputedCube
}

Method AddChild(node As InternalResolvedParser) As %Status
{
	s node.Parent=$this
	d ..Children.Insert(node)
	q $$$OK
}

Method GetMetaDims() As %List
{
	s lb=$lb()
	s i="" f{
	  s i=$o(..aliasMap(3,"P",i))
	  q:i=""
	  s st=..dimsShowInd(i,"S")
	  s $list(lb,i)=$lb(..aliasMap(3,"P",i),$lg(st,$ll(st)))
	}
	q lb
}

Method GetDimPath(dimName As %String) As %String
{
	if '$d(..aliasMap(3,"A",dimName)) q ""
	s ind=..aliasMap(3,"A",dimName)
	q:ind="" ""
	s stru=..dimsShowInd(ind,"S")
	s dimId="",path=""
	if $ll(stru)>4{
	  s dimId=$lg(stru,$ll(stru)-3)
	  s dimObj=##class(DHCWL.DM.T.DimBase).%OpenId(dimId)
	  s proObj=##class(DHCWL.DM.T.DimProperty).%OpenId($lg(stru,$ll(stru)-2))
	  if dimObj'=""{
		  s path=dimObj.GetPath()
		  s:proObj'="" path=path_"?"_proObj.Code
	  }
	  s dimObj="",proObj=""
	}else{
	  s cur=$this
	  if (..IsRoot){
	    s dimId=$lg(stru,2)
	    s dimObj=##class(DHCWL.DM.T.DimBase).%OpenId(dimId)
	    if dimObj'=""{
		  s path=dimObj.GetPath()
		  s dimObj=""
	    }
	  }elseif (..IsInnerJoin()){
		s pdim=..aliasMap(2,dimName,"S")
		s path=..InnerJoinIRP.Left.GetDimPath(pdim)
		q:path'="" path
		s path=..InnerJoinIRP.Right.GetDimPath(pdim)
	  }else{
		s pdim=..aliasMap(2,dimName,"S")
		s path=..Parent.GetDimPath(pdim)
	  }
	}
	q path
}

Method GetMetaMetrics() As %List
{
	s lb=$lb()
	s i="" f{
	  s i=$o(..metricsShowInd(i))
	  q:i=""
	  s $list(lb,i)=..metricsShowInd(i,"A")
	}
	q lb
}

Method IsPrint() As %Boolean
{
	q $g(..jsonExpStruct("PRINT"),0)
}

/// Flow Meta Parse
Method GenerateFlow(parent As InternalResolvedParser, flowName, from, dims, metrics, ByRef jsonStruct) As %Status
{
	s status=$$$OK
	s ..Parent=parent
	s status= ..Parent.AddChild($this)
	s ..IsRoot=0
	s ..ResultSetName=flowName
	s ..jsonExpStruct("FROM")=from
	s ..jsonExpStruct("DIMS")=dims
	s ..jsonExpStruct("AGGS")=metrics
	s ..jsonExpStruct("TYPE")="FLW"
	q status
}

Method ParseFlow() As %Status
{
	s status=$$$OK
	s ..RefTheme=..Parent.GetComputedTheme()
	s ..RefCube=..Parent.GetComputedCube()
	s status=..ParseFlowDims(..jsonExpStruct("DIMS"))
	s ..Status=status
	q:status'=$$$OK status
	s status=..ParseFlowMetrics(..jsonExpStruct("AGGS"))
	d ..BuildComputedTheme()
	d ..BuildComputedCube()
	s ..Status=status
	q status
}

Method ParseFlowDims(dims) As %Status
{
	s status=$$$OK
	s len=$l(dims,",")
	f i=1:1:len {
	  s dim=$p(dims,",",i)
	  s dimLen=$l(dim)
	  s preChar="",preCharI=0,postCharI=0,flag=0
	  f j=1:1:dimLen{
		s char=$e(dim,j)
		if ##class(DHCWL.DM.Util.StringUtil).IsSpace(char){
		  continue
		}elseif char="-"{
		  s preChar=char
		  s preCharI=j
		}elseif char=">"{
		  if preChar="-"{
		    s postCharI=j
		    s flag=1
		    q
		  }
		}
	  }
	  if flag{
		s fdim=##class(DHCWL.DM.Util.StringUtil).Trim($e(dim,1,preCharI-1))
		s rdim=##class(DHCWL.DM.Util.StringUtil).Trim($e(dim,postCharI+1,dimLen))
		s rdimLen=$l(rdim)
		if $zcvt($e(rdim,rdimLen-2,rdimLen),"U")=".D"{
			
		}else{
		  if ..Parent.GetComputedTheme().GetDim(rdim)=""{
		    s status=$$$ERROR("Can't get "_rdim_" from "_..Parent.GetComputedTheme().ToString())
		    q
		  }
		}
		
	  }else{
		s fdim=##class(DHCWL.DM.Util.StringUtil).Trim(dim)
		if ..Parent.GetComputedTheme().GetDim(rdim)=""{
		  s rdim=""
		}else{
		  s rdim=fdim
		}
	  }
	  d ..ParseOneFlowDim(fdim,rdim,i,.sl)
	  s ..dimsShowInd(i,"S")=sl
	}
	s ..dimsShowInd=1
	q status
}

Method ParseOneFlowDim(fdim, rdim, index As %Integer, ByRef struct As %List) As %Status
{
	if ((rdim'="")){
	  if (..Parent.GetComputedTheme().GetDim(rdim)'=""){
		s rdimInd=..Parent.aliasMap(3,"A",rdim)
		s struct=..Parent.dimsShowInd(rdimInd,"S")
	  }else{
		s dim=##class(DHCWL.DM.T.DimBase).GetByPath(rdim)
		s struct=$lb("",dim.%Id(),index,12)
	  }
	  s ..aliasMap(1,rdim)=fdim
	}else{
	  s struct=$lb("","",index,12)
	}
	s ..aliasMap(2,fdim)=rdim
	s ..aliasMap(2,fdim,"SI")=1
	s ..aliasMap(3,"P",index)=fdim
	s ..aliasMap(3,"A",fdim)=index
	q $$$OK
}

Method ParseFlowMetrics(metrics) As %Status
{
	s len=$l(metrics,",")
	f i=1:1:len{
	  s metric=$p(metrics,",",i)
	  s ..metricsShowInd(i,"A")=metric
	}
	q $$$OK
}

Method IsFlow() As %Boolean [ CodeMode = expression ]
{
($d(..jsonExpStruct("TYPE")))&&($zcvt(..jsonExpStruct("TYPE"),"U")="FLW")
}

/// realtime parse
Method GetRealTimeIRP() As RealTimeThemeIRP
{
	if (..IsRealTimeData()){
	  if (..RealTimeIRP=""){
		s ..RealTimeIRP=##class(RealTimeThemeIRP).%New($this)
	  }
	  q ..RealTimeIRP
	}
	q ""
}

Method IsRealTimeData() As %Boolean [ CodeMode = expression ]
{
($d(..jsonExpStruct("TYPE")))&&($zcvt(..jsonExpStruct("TYPE"),"U")="RTQ")
}

/// inner join parse
Method GenerateIJ(resultSetName, ByRef jsonStruct) As %Status
{
	s status=$$$OK
	s ..IsRoot=0
	s ..ResultSetName=resultSetName
	s ..jsonExpStruct("TYPE")="IJ"
	s ..jsonExpStruct("FROM")=jsonStruct("FROM")
	s ..jsonExpStruct("DIMS")=jsonStruct("DIMS")
	s ..jsonExpStruct("AGGS")=jsonStruct("METRICS")
	s printFlag=$g(jsonStruct("PRINT"),"")
	if ((printFlag'="")&&($zcvt(printFlag,"U")="TRUE")){
	  s ..jsonExpStruct("PRINT")=1
	}else{
	  s ..jsonExpStruct("PRINT")=0
	}
	s ..NeedExecutedCount=2
	q status
}

Method ParseIJ(leftRefIRP As InternalResolvedParser, rightRefIRP As InternalResolvedParser, dimList As %List, ByRef metricMap, leftJoinDim As %List, rightJoinDim As %List) As %Status
{
	s status=$$$OK
	s lrsn=leftRefIRP.ResultSetName
	s rrsn=rightRefIRP.ResultSetName
	s dimCount=0,metricCount=0
	k refDimCfgMap,refMetricCfgMap
	f i=1:1:$ll(leftJoinDim){
      s jd=$lg(leftJoinDim,i)
      if '$d(leftRefIRP.aliasMap(2,jd)){
		s status=$$$ERROR("Can't get dim "_jd_" from "_lrsn)
		q
	  }
	}
	q:status'=$$$OK status
	f i=1:1:$ll(rightJoinDim){
      s jd=$lg(rightJoinDim,i)
      if '$d(rightRefIRP.aliasMap(2,jd)){
		s status=$$$ERROR("Can't get dim "_jd_" from "_rrsn)
		q
	  }
	}
	q:status'=$$$OK status
	s dimListLen=$ll(dimList)
	f i=1:1:dimListLen{
	  s dim=$lg(dimList,i)
	  s dimCount=dimCount+1
	  s status=..ParseDimExp(leftRefIRP.GetComputedTheme(),dim,.sl,"D",dimCount)
	  q:status'=$$$OK
	  s ..dimsShowInd(dimCount,"S")=sl
	  d ..ParseAlias(dim,.aliasMap)
	  s sdim=aliasMap("S")
	  if '$d(leftRefIRP.aliasMap(2,sdim)){
	    s status=$$$ERROR("Can't get dim "_sdim_" from "_lrsn)
		q
	  }
	  s ijrdim=..aliasMap(3,"P",dimCount)
	  s refDimCfgMap(1,ijrdim)=..#LEFTPOS
	  s refDimCfgMap(1,ijrdim,"SN")=dimCount
	  s refDimCfgMap(1,ijrdim,"PSN")=leftRefIRP.aliasMap(3,"A",ijrdim)
	  s refDimCfgMap(2,..#LEFTPOS,ijrdim)=""
	}
	s ..dimsShowInd=1
	q:status'=$$$OK status
	m pMetricMap=leftRefIRP.metricsShowInd
	if $d(metricMap(lrsn)){
	  s ind="" f{
	    s ind=$o(metricMap(lrsn,ind))
	    q:ind=""
	    s metric=metricMap(lrsn,ind)
	    s metricCount=metricCount+1
	    s status=..ParseOneAggExp(leftRefIRP.GetComputedTheme(),metric,metricCount)
	    q:status'=$$$OK
	    d ..ParseAlias(metric,.aliasMap)
	    s smetric=aliasMap("S")
	    s flag=0,findMind=0
	    s mind="" f{
		  s mind=$o(pMetricMap(mind))
		  q:((mind="")||(flag=1))
		  if pMetricMap(mind,"A")=smetric{
			s flag=1,findMind=mind
			q
		  }
	    }
	    if flag=0{
		  s status=$$$ERROR("Can't get metric "_smetric_" from "_lrsn)
		  q
	    }
	    q:status'=$$$OK
	    s ijrmetric=..metricsShowInd(metricCount,"A")
	    s refMetricCfgMap(1,ijrmetric)=..#LEFTPOS
	    s refMetricCfgMap(1,ijrmetric,"SN")=metricCount
	    s refMetricCfgMap(1,ijrmetric,"PSN")=findMind
	    s refMetricCfgMap(2,..#LEFTPOS,ijrmetric)=""
	  }
	}
	q:status'=$$$OK status
	m pMetricMap=rightRefIRP.metricsShowInd
	if $d(metricMap(rrsn)){
	  s ind="" f{
	    s ind=$o(metricMap(rrsn,ind))
	    q:ind=""
	    s metric=metricMap(rrsn,ind)
	    s metricCount=metricCount+1
	    s status=..ParseOneAggExp(rightRefIRP.GetComputedTheme(),metric,metricCount)
	    q:status'=$$$OK
	    d ..ParseAlias(metric,.aliasMap)
	    s smetric=aliasMap("S")
	    s flag=0,findMind=0
	    s mind="" f{
		  s mind=$o(pMetricMap(mind))
		  q:((mind="")||(flag=1))
		  if pMetricMap(mind,"A")=smetric{
			s flag=1,findMind=mind
			q
		  }
	    }
	    if flag=0{
		  s status=$$$ERROR("Can't get metric "_smetric_" from "_rrsn)
		  q
	    }
	    q:status'=$$$OK
	    s ijrmetric=..metricsShowInd(metricCount,"A")
	    s refMetricCfgMap(1,ijrmetric)=..#RIGHTPOS
	    s refMetricCfgMap(1,ijrmetric,"SN")=metricCount
	    s refMetricCfgMap(1,ijrmetric,"PSN")=findMind
	    s refMetricCfgMap(2,..#RIGHTPOS,ijrmetric)=""
	  }
	}
	;m tmp=..metricsShowInd
	;zw metricMap
	;zw tmp
	q:status'=$$$OK status
	s ..dimsShowInd=1
	s ..InnerJoinIRP=##class(InnerJoinIRP).%New(leftRefIRP,rightRefIRP,$this,leftJoinDim,rightJoinDim,.refDimCfgMap,.refMetricCfgMap)
	d leftRefIRP.AddChild($this)
	d rightRefIRP.AddChild($this)
	d ..BuildComputedTheme()
	d ..BuildComputedCube()
	s ..Status=status
	q status
}

Method GetInnerJoinIRP() As InnerJoinIRP
{
	if ..IsInnerJoin(){
	  q ..InnerJoinIRP
	}
	q ""
}

Method IsInnerJoin() As %Boolean [ CodeMode = expression ]
{
($d(..jsonExpStruct("TYPE")))&&(..jsonExpStruct("TYPE")="IJ")
}

Method GetInnerJoinChildren() As %ListOfObjects
{
	s list=""
	s len=..Children.Count()
	f i=1:1:len{
	  s child=..Children.GetAt(i)
	  continue:child=""
	  if child.IsInnerJoin(){
		if list=""{
		  s list=##class(%ListOfObjects).%New()
		}
		d list.Insert(child)
	  }
	}
	q list
}

Method CanExecute() As %Boolean
{
  q:..ExecutedLogs<..NeedExecutedCount 1
  q 0
}

}
