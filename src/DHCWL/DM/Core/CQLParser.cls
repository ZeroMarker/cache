Class DHCWL.DM.Core.CQLParser Extends %RegisteredObject
{

// (resultSetName,"ThemePath")=themePath

// (resultSetName,"ThemeBase")=themeBase

// (resultSetName,"FilterRootNode")=treeOfFilterRoot

// (resultSetName,"Cube")=queryChoicedCubeBase

// Property rsQueryMap [ MultiDimensional ];

// (resultSetName,showIndex)=dimExpression

// (resultSetName,showIndex,"S")=dimStruct

// Property dimsShowInd [ MultiDimensional ];

// (rsultSetName,"D",dimCode)=""

// (rsultSetName,"F",dimCode)=""

// Property allUsingDimMetricMap [ MultiDimensional ];

Property JsonCQLExpression As %String(MAXLEN = 60840);

// (resultSetName)=InternalResolvedParser

Property RSN2IRPStruct [ MultiDimensional ];

Property ParserForest As %ListOfObjects;

Property Status As %Status;

Method %OnNew() As %Status [ Private, ServerOnly = 1 ]
{
	s ..ParserForest=##class(%ListOfObjects).%New()
	;s ..JsonCQLExpression=$g(CQLExpression,"")
	;s status= ..Parse(CQLExpression)
	/*s status= ..Parse(CQLExpression)
	i status'=$$$OK{
	  d DecomposeStatus^%apiOBJ(status,.err,"-d") 
	  s errStr="" ,oneErr="" f {
	    s oneErr=$o(err(oneErr))
	    q:oneErr=""
	    s errStr=errStr_"  "_err(oneErr)
	  }
	  w errStr,!
	}
	q status*/
	q $$$OK
}

// d ##class(DHCWL.DM.Core.CQLParser).Test()

ClassMethod Test()
{
	s cql="rs1:{"_
            "from: /workload2.t,"_
            "dims : RecDep,RecDep->Hospital hosDr,RecDep->Hospital->Name as hospitalName,PatDep->Code patCode,AdmType,PatDoc->Name,"_
            "metrics: sum(Price) price,sum(Price) ON (AdmType) As AdmSumPrice,count() ON (AdmType),"_
            "filter: OrdDate DateRange('2013-01-01','2013-01-02') && (AdmType = ('E') || AdmType = ('O'))"_
            "print:true,"_
          "};"_
          "rs2:{"_
            "from: /workload2.t,"_
            "way: OrdDate DateRange('2013-01-01','2013-01-02'),"_
            "dims : RecDep,RecDep->Hospital hosDr,RecDep->Hospital->Name as hospitalName,PatDep->Code patCode,AdmType,PatDoc->Name,"_
            "metrics: sum(Price) price,sum(Price) ON (AdmType) As AdmSumPrice,count() ON (AdmType),"_
            "filter: OrdDate DateRange('2013-01-03','2013-01-04')&&(AdmType = ('E') || AdmType = ('O'))"_
          "};"_
          "rs3:{"_
            "type:IJ,"_
            "from:rs1=rs2,"_
            "metrics:rs1.price,rs2.AdmSumPrice"_
          "}"
    ;w cql,!
	s parser=##class(CQLParser).%New()
	s status= parser.Parse(cql)
	w status,!
}

/*
rs1:{
  from: /workload.t,
  way: OrdDate DateRange('2013-01-01','2013-01-02'),
  dims : RecDep,RecDep->Hospital hosDr,RecDep->Hospital->Name as hospitalName,PatDep->Code patCode,AdmType,PatDoc->Name,
  metrics: sum(Price) price,sum(Price) ON (AdmType) As AdmSumPrice,count() ON (AdmType),
  filter: AdmType = ('E') || AdmType = ('O')
};
rs2:{
  from: rs1,
  dims: hosDr->Name as hospitalName,
  metrics: sum(price) totalPrice,
  filter: AdmType = ('E')
}

*/
Method GetStatus() As %Status [ CodeMode = expression ]
{
..Status
}

/// add param statisticWayExpression @20181022 by lihaihong for index cube part
Method Parse(cqlExpression As %String(MAXLEN=60840), statisticWayExpression = "") As %Status
{
    s ..Status= ..ParseCQLS(cqlExpression,.girp,"C",statisticWayExpression)
    s girp=""
    q ..Status
}

Method ParseFlow(flowMetaDefined, ByRef girp As InternalResolvedParser) As %Status
{
	s ..Status= ..ParseCQLS(flowMetaDefined,.girp,"F")
	q ..Status
}

Method ParseCQLS(CQLExpression As %String(MAXLEN=60840), ByRef girp As InternalResolvedParser = "", type = "C", statisticWayExpression = "") As %Status [ Private ]
{
    //max 60K
    s status=$$$OK
    k SWResult,CQLJSONMAP
	s len=$l(CQLExpression)
	s stack=##class(DHCWL.DM.Util.Stack).%New()
	s rsE=0,braceS="{",braceE="}",str1="'",str2="""",proVS=":"
	s resultSetName="",from="",dims="",metrics="",way="",filter=""
	s prePro="",preProV="",preProSI=0
	f i=1:1:len {
	  s char=$e(CQLExpression,i)
	  if ((char=proVS) && (stack.Size()=0)){
		d searchWord(i-1)
		s resultSetName=SWResult("NAME")
	  }elseif ((char=braceS) && ((stack.Size()=0))){
		k CQLJSONMAP
		d stack.Push(char)
	  }elseif ((char=braceE) && (stack.Peek()=braceS)){
		d stack.Pop()
		if stack.Size()'=0 {
		  continue
		}
		if ((prePro'="") && (preProV="")){
		  f j=i-1:-1:preProSI{
			s char2=$e(CQLExpression,j)
			if (##class(DHCWL.DM.Util.StringUtil).IsSpace(char2))||(char2=","){
			}else{
			  q	
			}
		  }
		  s preProV=##class(DHCWL.DM.Util.StringUtil).Trim($e(CQLExpression,preProSI,j))
		  s CQLJSONMAP(prePro)=preProV
		}
		;w "resultSetName:"_resultSetName,!
		;zw CQLJSONMAP
		;b ;0
		if type="C"{
		  s cqlType=$g(CQLJSONMAP("TYPE"),"QRY")
		  s cqlType=$zcvt(cqlType,"U")
		  if (cqlType="RTQ"){
			s rtqRSName="0_"_resultSetName_"_0"
			s status= ..ParseOneCQL(rtqRSName,$g(CQLJSONMAP("TYPE"),""),$g(CQLJSONMAP("FROM"),""),$g(CQLJSONMAP("DIMS"),""),$g(CQLJSONMAP("METRICS"),""),$g(CQLJSONMAP("FILTER"),""),$g(CQLJSONMAP("SORT"),""),$g(CQLJSONMAP("WAY"),""),$g(CQLJSONMAP("PRINT"),""),.CQLJSONMAP,.girp,statisticWayExpression)
			s rtirp=girp.GetRealTimeIRP()
			s girp.ComputedTheme=rtirp.FetchTheme
			s girp.ComputedCube=rtirp.FetchCube
			s status= ..ParseOneCQL(resultSetName,"",rtqRSName,$g(CQLJSONMAP("DIMS"),""),$g(CQLJSONMAP("METRICS"),""),$g(CQLJSONMAP("FILTER"),""),$g(CQLJSONMAP("SORT"),""),$g(CQLJSONMAP("WAY"),""),$g(CQLJSONMAP("PRINT"),""),.CQLJSONMAP,.girp)
		  }elseif (cqlType="QRY"){
			s status= ..ParseOneCQL(resultSetName,$g(CQLJSONMAP("TYPE"),""),$g(CQLJSONMAP("FROM"),""),$g(CQLJSONMAP("DIMS"),""),$g(CQLJSONMAP("METRICS"),""),$g(CQLJSONMAP("FILTER"),""),$g(CQLJSONMAP("SORT"),""),$g(CQLJSONMAP("WAY"),""),$g(CQLJSONMAP("PRINT"),""),.CQLJSONMAP,.girp,statisticWayExpression)
		  }elseif ((cqlType="JOIN")||(cqlType="INNERJOIN")||(cqlType="IJ")){
			s status=..ParseInnerJoin(resultSetName,.CQLJSONMAP,.girp)
		  }
		}elseif type="F" {
		  s status=..ParseFlowMeta(resultSetName,$g(CQLJSONMAP("FROM"),""),$g(CQLJSONMAP("DIMS"),""),$g(CQLJSONMAP("METRICS"),""),.CQLJSONMAP,.girp)
		}
		q:status'=$$$OK
		s resultSetName="",from="",dims="",metrics="",way="",filter=""
		s prePro="",preProV="",preProSI=0
		k CQLJSONMAP
	  }elseif ( (char=proVS) && (stack.Size()=1) && (stack.Peek()=braceS)){
		d searchWord(i-1)
		s pro=$zcvt(SWResult("NAME"),"U")
		if prePro=""{
		  s prePro=pro,preProSI=i+1
		}else{
		  f j=SWResult("NS")-1:-1:preProSI{
			s char2=$e(CQLExpression,j)
			if (##class(DHCWL.DM.Util.StringUtil).IsSpace(char2))||(char2=","){
			}else{
			  q	
			}
		  }
		  s preProV=##class(DHCWL.DM.Util.StringUtil).Trim( $e(CQLExpression,preProSI,j) )
		  s CQLJSONMAP(prePro)=preProV
		  
		  s prePro=pro,preProSI=i+1,preProV=""
		}
		
	  }elseif ((char=str1) && (stack.Peek()'=str1)){
		 d stack.Push(char) 
	  }elseif ((char=str1) && (stack.Peek()=str1)){
		 d stack.Pop()
	  }
	}
	q:status'=$$$OK status
	if stack.Size()'=0{
	  s status=$$$ERROR("The grammar is invalid:"_CQLExpression)
	}
	q status
searchWord(we)
    s j=we,initSearch=1
    f j=we:-1:1{
	  s char2=$e(CQLExpression,j)
	  if '##class(DHCWL.DM.Util.StringUtil).IsSpace(char2) q
    }
    s we=j
    f j=we:-1:1{
	  s char2=$e(CQLExpression,j)
	  if ##class(DHCWL.DM.Util.StringUtil).IsLetter(char2){
		  
	  }else{
		s j=j+1
		q  
	  }
    }
    s SWResult("NAME")=$e(CQLExpression,j,we)
    s SWResult("NS")=j
    s SWResult("NE")=we
    q
}

Method ParseOneCQL(resultSetName, type = "", from, dims, metrics, filter, sort, range, print, ByRef jsonStruct, ByRef girp As InternalResolvedParser = "", statisticWayExpression = "") As %Status [ Private ]
{
	;b ;ParseOneCQL
	s len=..ParserForest.Count()
	s irp=""
	f i=1:1:len {
	  s irp=##class(InternalResolvedParser).SearchDown(..ParserForest.GetAt(i),from)
	  q:irp'=""
	}
	if irp="" {
	  s themBase=##class(DHCWL.DM.T.ThemeBase).GetByPath(from)
	  if themBase=""{
		q $$$ERROR("Can't load theme with path "_from)
	  }
	  s irp=##class(InternalResolvedParser).%New() ;"",resultSetName,from,dims,metrics,filter,range,print)
	  s status=irp.GenerateCommon("",resultSetName,type,from,dims,metrics,filter,sort,range,print,.jsonStruct,statisticWayExpression)
	  d ..ParserForest.Insert(irp)
	  s status=irp.Parse2()
	}else{
	  s subirp=##class(InternalResolvedParser).%New() ;irp,resultSetName,from,dims,metrics,filter,range,print)
	  s status=subirp.GenerateCommon(irp,resultSetName,type,from,dims,metrics,filter,sort,range,print,.jsonStruct,statisticWayExpression)
	  s irp=subirp
	  s status=subirp.Parse2()
	}
	q:status'=$$$OK status
	s girp=irp
	s ..RSN2IRPStruct(resultSetName)=irp
	q status
}

Method ParseFlowMeta(flowName, from, dims, metrics, ByRef jsonStruct, ByRef girp As InternalResolvedParser) As %Status [ Private ]
{
	s status=$$$OK
	s len=..ParserForest.Count()
	s irp=""
	f i=1:1:len {
	  s irp=##class(InternalResolvedParser).SearchDown(..ParserForest.GetAt(i),from)
	  q:irp'=""
	}
	if irp=""{
	  s status=$$$ERROR("Can't get """_from_""" from current context!")
	  q status
	}
	s subirp=##class(InternalResolvedParser).%New()
	s status=subirp.GenerateFlow(irp,flowName,from,dims,metrics,.jsonStruct)
	q:status'=$$$OK status
	s status=subirp.ParseFlow()
	q:status'=$$$OK status
	s ..RSN2IRPStruct(flowName)=subirp
	s girp=subirp
	q status
}

Method ParseInnerJoin(resultSetName, ByRef jsonStruct, ByRef girp As InternalResolvedParser) As %Status
{
	s status=$$$OK
	s from=$g(jsonStruct("FROM"),"")
	q:((from="")) $$$ERROR("The from can't null of "_resultSetName_" inner join query")
	s left= ##class(DHCWL.DM.Util.StringUtil).Trim( $p(from,"=",1) )
	s right=##class(DHCWL.DM.Util.StringUtil).Trim( $p(from,"=",2) )
	q:((left="")||(right="")) $$$ERROR("The from is invalid :"_from)
	s ljrs=##class(DHCWL.DM.Util.StringUtil).Trim( $p(left,"(",1) )
	s ljdims=##class(DHCWL.DM.Util.StringUtil).Trim( $p($p(left,"(",2),")",1) )
	q:((ljrs="")) $$$ERROR("The from is invalid :"_from)
	s rjrs=##class(DHCWL.DM.Util.StringUtil).Trim( $p(right,"(",1) )
	s rjdims=##class(DHCWL.DM.Util.StringUtil).Trim( $p($p(right,"(",2),")",1) )
	q:((rjrs="")) $$$ERROR("The from is invalid :"_from)
	q:(($e(ljrs,1)="/")&&($zcvt($e(ljrs,$l(ljrs)-1,$l(ljrs)),"U")=".T"))||(($e(rjrs,1)="/")&&($zcvt($e(rjrs,$l(rjrs)-1,$l(rjrs)),"U")=".T")) $$$ERROR(ljrs_" or "_rjrs_" can't from souce themePath")
	s dims=$g(jsonStruct("DIMS"),"")
	/*q:dims="" $$$ERROR("dims can't null")
	s dimsLen=$l(dims)
	s stack=##class(DHCWL.DM.Util.Stack).%New()
	s rsnsi=1,rsdimsi=1
	k rsdimMap
	f i=1:1:dimsLen{
	  s char=$e(dims,i)
	  if char="("{
		d stack.Push(char)
		s rsName= ##class(DHCWL.DM.Util.StringUtil).Trim( $e(dims,rsnsi,i-1) )
		if ((rsName'=ljrs)&&(rsName'=rjrs)){
		  s status=$$$ERROR(dims_"'s resultSetName must be "_ljrs_" or "_rjrs)
		}
		s rsdimsi=i+1
	  }elseif (char=")"){
		d stack.Pop()
		if stack.Size()'=0{
		  s status=$$$ERROR("The grammar is invalid:"_dims)
		  q
		}
		s rsdims= ##class(DHCWL.DM.Util.StringUtil).Trim( $e(dims,rsdimsi,i-1) )
		s rsdimsal=$l(rsdims,",")
		f j=1:1:rsdimsal{
		  s dim=$p(rsdims,",",j)
		  if dim=""{
			s status=$$$ERROR(rsdims_ " can't contain null dim!")
			q  
		  }
		  s mapInd=$i(rsdimMap)
		  s rsdimMap(rsName,mapInd)=dim
		}
		q:status'=$$$OK
		f j=i+1:1:dimsLen{
		  s char2=$e(dims,j)
		  if ((##class(DHCWL.DM.Util.StringUtil).IsSpace(char2))||(char2=",")){
		  }else{
			s rsnsi=j
			q
		  }
		}
	  }
	}
	q:stack.Size()'=0 $$$ERROR("The grammar is invalid:"_dims)
	
	s metrics=$g(jsonStruct("METRICS"),"")
	s metricsLen=$l(metrics)
	s rsnsi=1,rsmetricsi=1
	k rsmetricsMap
	f i=1:1:metricsLen{
	  s char=$e(metrics,i)
	  if char="("{
		d stack.Push(char)
		s rsName= ##class(DHCWL.DM.Util.StringUtil).Trim( $e(metrics,rsnsi,i-1) )
		if ((rsName'=ljrs)&&(rsName'=rjrs)){
		  s status=$$$ERROR(metrics_"'s resultSetName must be "_ljrs_" or "_rjrs)
		}
		s rsmetricsi=i+1
	  }elseif (char=")"){
		d stack.Pop()
		if stack.Size()'=0{
		  s status=$$$ERROR("The grammar is invalid:"_metrics)
		  q
		}
		s rsmetrics= ##class(DHCWL.DM.Util.StringUtil).Trim( $e(metrics,rsmetricsi,i-1) )
		s rsmetricsal=$l(rsmetrics,",")
		f j=1:1:rsmetricsal{
		  s metric=$p(rsmetrics,",",j)
		  if metric=""{
			s status=$$$ERROR(rsmetrics_ " can't contain null dim!")
			q  
		  }
		  s mapInd=$i(rsmetricsMap)
		  s rsmetricsMap(rsName,mapInd)=metric
		}
		q:status'=$$$OK
		f j=i+1:1:metricsLen{
		  s char2=$e(metrics,j)
		  if ((##class(DHCWL.DM.Util.StringUtil).IsSpace(char2))||(char2=",")){
		  }else{
			s rsnsi=j
			q
		  }
		}
	  }
	}
	*/
	s stack=##class(DHCWL.DM.Util.Stack).%New()
	s metrics=$g(jsonStruct("METRICS"),"")
	s metricsLen=$l(metrics),mapInd=1
	if $e(metrics,metricsLen)'=","{
	  s metrics=metrics_","
	  s metricsLen=metricsLen+1
	}
	s rsnsi=1
	k rsmetricsMap
	f i=1:1:metricsLen{
	  s char=$e(metrics,i)
	  if char="("{
		d stack.Push(char)
	  }elseif (char=")") && (stack.Peek()="("){
		d stack.Pop()
	  }elseif (char="'") && (stack.Peek()'="'"){
		d stack.Push(char)
	  }elseif (char="'") && (stack.Peek()="'"){
		d stack.Pop()
	  }elseif (char=",") && (stack.Size()=0){
		s rsmetric=$e(metrics,rsnsi,i-1)
		s rs=##class(DHCWL.DM.Util.StringUtil).Trim($p(rsmetric,".",1))
		s metric=##class(DHCWL.DM.Util.StringUtil).Trim($p(rsmetric,".",2))
		s rsLen=$l(rs)
		f j=rsLen:-1:1{
		  s char2=$e(rs,j)
		  if '##class(DHCWL.DM.Util.StringUtil).IsLetter(char2){
			s rs=$e(rs,j+1,rsLen)
			q
		  }
		}
		if (rs="")||(metric=""){
		  s status=$$$ERROR(rsmetric_" is invalid!")
		  q
		}
		s rsmetricsMap(rs,mapInd)=metric
		s mapInd=mapInd+1
		s rsnsi=i+1
	  }
	}
	q:status'=$$$OK status
	;w "metrics:"_metrics,!
	;zw rsdimMap
	;zw rsmetricsMap
	s len=..ParserForest.Count()
	s lirp="",rirp=""
	f i=1:1:len {
	  s lirp=##class(InternalResolvedParser).SearchDown(..ParserForest.GetAt(i),ljrs)
	  q:lirp'=""
	}
	q:lirp="" $$$ERROR("Can't get resultSetName:"_ljrs)
	f i=1:1:len {
	  s rirp=##class(InternalResolvedParser).SearchDown(..ParserForest.GetAt(i),rjrs)
	  q:rirp'=""
	}
	q:rirp="" $$$ERROR("Can't get resultSetName:"_rjrs)
	s irpDimLen=$o(lirp.aliasMap(3,"P",""),-1)
	if ljdims=""{
	  m map=lirp.aliasMap
	  s count=1
	  s i="" f{
		s i=$o(map(3,"P",i))
		q:i=""
		s:count>1 ljdims=ljdims_","
		s ljdims=ljdims_map(3,"P",i)
		s count=count+1
	  }
	}
	if rjdims=""{
	  m map=rirp.aliasMap
	  s count=1
	  s i="" f{
		s i=$o(map(3,"P",i))
		q:i=""
		s:count>1 rjdims=rjdims_","
		s rjdims=rjdims_map(3,"P",i)
		s count=count+1
	  }
	}
	s lJoinDimList=$lb(),rJoinDimList=$lb(),jdli=0
	f i=1:1:$l(ljdims,","){
	  s jd=$p(ljdims,",",i)
	  if jd=""{
		s status=$$$ERROR(left_" can't contian null dim")
		q
	  }
	  s jdli=jdli+1
	  s $list(lJoinDimList,jdli)=jd
	}
	q:status'=$$$OK status
	s jdli=0
	f i=1:1:$l(rjdims,","){
	  s jd=$p(rjdims,",",i)
	  if jd=""{
		s status=$$$ERROR(right_" can't contian null dim")
		q
	  }
	  s jdli=jdli+1
	  s $list(rJoinDimList,jdli)=jd
	}
	q:status'=$$$OK status
	q:$ll(lJoinDimList)'=$ll(rJoinDimList) $$$ERROR("The length must be equal between "_$lts(lJoinDimList,",")_" and "_$lts(rJoinDimList,","))
	q:irpDimLen'=$ll(lJoinDimList) $$$ERROR("Must use all dims of "_ljrs_" or "_rjrs)
	if dims=""{
	  s dims=ljdims
	}
	s dimList=$lb()
	f i=1:1:$l(dims,","){
	  s $list(dimList,i)=$p(dims,",",i)_" AS "_$p(ljdims,",",i)
	}
	q:$ll(dimList)'=$ll(lJoinDimList) $$$ERROR("The length must be equal between "_dims_" and "_$lts(lJoinDimList,","))
	s jsonStruct("FROM")=ljrs_"("_ljdims_")="_rjrs_"("_rjdims_")"
	s jsonStruct("DIMS")=dims
	s subirp=##class(InternalResolvedParser).%New()
	s status=subirp.GenerateIJ(resultSetName,.jsonStruct)
	q:status'=$$$OK status
	s status=subirp.ParseIJ(lirp,rirp,dimList,.rsmetricsMap,lJoinDimList,rJoinDimList)
	s ..RSN2IRPStruct(resultSetName)=subirp
	s girp=subirp
	q status
}

Method GetIRParser(resultSetName) As InternalResolvedParser
{
	q ..RSN2IRPStruct(resultSetName)
}

Method GetRSList() As %List
{
	s lb=$lb(),lbc=0
	s rsn="" f{
	  s rsn=$o(..RSN2IRPStruct(rsn))
	  q:rsn=""
	  s lbc=lbc+1
	  s $list(lb,lbc)=rsn
	}
	q lb
}

Method GetPrintRSList() As %List
{
	s lb=$lb(),irp="",lbc=0
	s rsn="" f{
	  s rsn=$o(..RSN2IRPStruct(rsn))
	  q:rsn=""
	  s irp=..RSN2IRPStruct(rsn)
	  if irp.IsPrint(){
		s lbc=lbc+1
		s $list(lb,lbc)=rsn
	  }
	}
	q lb
}

Method DimsMeta(resultSetName As %String) As %List
{
	s irp=..GetIRParser(resultSetName)
	s lb=irp.GetMetaDims()
	s irp=""
	q lb
}

Method MetricsMeta(resultSetName As %String) As %List
{
	s irp=..GetIRParser(resultSetName)
	s lb=irp.GetMetaMetrics()
	s irp=""
	q lb
}

Method GetDimPath(resultSetName, dimName As %String) As %String
{
	s irp=..GetIRParser(resultSetName)
	s path=irp.GetDimPath(dimName)
	s irp=""
	q path
}

Method Close()
{
	s rsn="" f{
	  s rsn=$o(..RSN2IRPStruct(rsn))
	  q:rsn=""
	  s irp=..RSN2IRPStruct(rsn)
	  continue:irp=""
	  d irp.Close()
	}
	s ..JsonCQLExpression=""
	d ..ParserForest.Clear()
	s ..ParserForest=""
	k ..RSN2IRPStruct
}

/*Method ParseOneCQL1(resultSetName, from, dims, metrics, filter) As %Status
{
	s themeBase=""
	if '$d(..rsQueryMap(from)) d
	.s themeBase=##class(DHCWL.DM.T.ThemeBase).GetByPath(from)
	.s ..rsQueryMap(resultSetName,"ThemePath")=from
	e  d
	.s themeBase=..rsQueryMap(from,"ThemeBase")
	.s ..rsQueryMap(resultSetName,"ThemePath")=..rsQueryMap(from,"ThemePath")
	s ..rsQueryMap(resultSetName,"ThemeBase")=themeBase
	q:themeBase="" $$$ERROR("Can't get theme of "_from_" with query expression "_resultSetName)
	s status=..ParseDims(resultSetName,themeBase,dims)
	q:status'=$$$OK status
	s status=..ParseFilter(resultSetName,themeBase,filter,.rootNode)
	s ..rsQueryMap(resultSetName,"FilterRootNode")=rootNode
	s dimList=$lb(),i=0
	i $d(..allUsingDimMetricMap(resultSetName,"D")) d
	.s code="" f  s code=$o(..allUsingDimMetricMap(resultSetName,"D",code)) q:code=""  d
	..s i=i+1
	..s $list(dimList,i)=code
	s metricList=$lb(),i=0
	s status=..ParseFilter(resultSetName,themeBase,filter,.rootNode)
	q:status'=$$$OK status
	s filtDimList=$lb(),i=0
	i $d(..allUsingDimMetricMap(resultSetName,"F")) d
	.s code="" f  s code=$o(..allUsingDimMetricMap(resultSetName,"F",code)) q:code=""  d
	..s i=i+1
	..s $list(filtDimList,i)=code
	s status=..ParseMetrics(resultSetName,metrics,.metricList)
	q:status'=$$$OK status
	s dimls=$lts(dimList,";"),len=$ll(filtDimList)
	s bestCube=""
	f i=1:1:len d
	.s sd=$lg(filtDimList,i)
	.s $list(filtDimList,i)=""
	.s tryDimList=$lfs(dimls,";")
	.d choiceCopyList(tryDimList,filtDimList)
	.s cube=##class(DHCWL.DM.T.CubeBase).Get(..rsQueryMap(resultSetName,"ThemePath"),sd,tryDimList,metricList)
	.i ( (cube'="") && ((bestCube="") || (bestCube.DimNum>cube.DimNum)) ) d
	..s bestCube=cube
	.s $list(filtDimList,i)=sd
	i bestCube="" d
	.s status=$$$ERROR("Can't find cube for query :"_resultSetName)
	q:status'=$$$OK status
	s ..rsQueryMap(resultSetName,"Cube")=bestCube
	d ..FilterFunctionParse(resultSetName,rootNode)
	q status
choiceCopyList(a,b)
	s blen=$ll(b),alen=$ll(a)
	f bi=1:1:blen d
	.q:$lg(b,bi,"")=""
	.s alen=alen+1
	.s $list(a,alen)=$lg(b,bi)
	q
}

Method ParseDims(resultSetName, theme As DHCWL.DM.T.ThemeBase, dims) As %Status [ Private ]
{
	s status=$$$OK
	q:dims="" status
	s len=$l(dims,",")
	f i=1:1:len d
	.s dimExp=$p(dims,",",i)
	.s ..dimsShowInd(resultSetName,i)=dimExp
	.s sl=$lb()
	.s status=..ParseDimExp(resultSetName,theme,dimExp,.sl,"D")
	.i status'=$$$OK d
	..s i=len+1
	..q
	.s ..dimsShowInd(resultSetName,i,"S")=sl
	q status
}

Method ParseDimExp(resultSetName, theme As DHCWL.DM.T.ThemeBase, dimExpression, ByRef structList As %List, type As %String = "D") As %Status [ Private ]
{
	s structList=$lb()
	s len=$l(dimExpression,">")
	s status=$$$OK
	s breakFlag=0
	i len=1 d
	.s dimCode=##class(DHCWL.DM.Util.StringUtil).Trim(dimExpression)
	.s themeDims=theme.GetDim(dimCode)
	.i themeDims="" d
	..s status=$$$ERROR("Can't get dim of "_dimExpression_" from "_theme.GetPath())
	.e  d
	..s ..allUsingDimMetricMap(resultSetName,type,dimCode)=""
	..s $list(structList,1)=themeDims.%Id()
	.s breakFlag=1
	q:breakFlag=1 status
	f i=1:1:len-1 d
	.s j=(i-1)*4+1
	.s pro=##class(DHCWL.DM.Util.StringUtil).Trim( $p( $p(dimExpression,">",i+1),"-",1) )
	.i i=1 d
	..s dimCode=##class(DHCWL.DM.Util.StringUtil).Trim( $p($p(dimExpression,">",i),"-",1) )
	..s themeDims=theme.GetDim(dimCode)
	..s dimBase= themeDims.GetLinkDim()
	..s ..allUsingDimMetricMap(resultSetName,type,dimCode)=""
	.i dimBase="" d
	..s status=$$$ERROR("Can't get dim of "_dimCode)
	..s i=len+1
	..s breakFlag=1
	.q:breakFlag=1
	.s dimPro=dimBase.GetProperty(pro)
	.i dimPro="" d
	..s status=$$$ERROR("Can't get property "_pro_" from "_dimExpression)
	..s i=len
	..s breakFlag=1
	.q:breakFlag=1
	.s sn=##class(DHCWL.DM.T.DimDStructMap).GetMapPosition(dimBase.%Id(),dimPro.%Id())
	.i sn=0 d
	..s i=len+1
	..s status=$$$ERROR("Can't get property "_pro_"'s map position!")
	..s breakFlag=1
	.q:breakFlag=1
	.s jdbcTypeCode=dimPro.DataType.JDBCTypeCodeNum
	.s $list(structList,j)=dimBase.%Id()
	.s $list(structList,j+1)=dimPro.%Id()
	.s $list(structList,j+2)=sn
	.s $list(structList,j+3)=jdbcTypeCode
	.i ( (dimPro.IsLinked="Y") ) d
	..s dimBase=##class(DHCWL.DM.T.DimBase).GetByPath(dimPro.LinkedPath) 
	
	q status
}

Method ParseFilter(resultSetName, theme As DHCWL.DM.T.ThemeBase, filter, ByRef rootNode As DHCWL.DM.Util.FilterTree) As %Status
{
	s status=$$$OK
	s rootNode=..ParseFilterRecursion(resultSetName,theme,filter,.status)
	d ..VisitDG(rootNode)
	q status
}

Method ParseFilterRecursion(resultSetName, theme As DHCWL.DM.T.ThemeBase, filter, ByRef status As %Status) As DHCWL.DM.Util.FilterTree
{
	s node=""
	s len=$l(filter),LO("&")=2,LO("|")=2,LO("!")=1
	s stack=##class(DHCWL.DM.Util.Stack).%New()
	s char="",preChar="",hasLogicalFlag=0,minLevel=999999,minLevelIndex=1,matchLogical=""
	f i=1:1:len d
	.s preChar=char
	.s char=$e(filter,i)
	.i ( ($d(LO(char))) && (stack.Peek()'="'")  ) d
	..if ( (LO(char)=2) && (char=preChar) ) d
	...i stack.Size()<minLevel d
	....s minLevel=stack.Size()
	....s minLevelIndex=i
	....s matchLogical=char
	...s hasLogicalFlag=1
	
	..else  if LO(char)=1 d
	...i stack.Size()<minLevel d
	....s minLevel=stack.Size()
	....s minLevelIndex=i
	....s matchLogical=char
	...s hasLogicalFlag=1
	.e  i ( (char="'") && (stack.Peek()'="'")) d
	..d stack.Push(char)
	.e  i ( (char="'") && (stack.Peek()="'") && (preChar'="\")) d
	..d stack.Pop()
	.e  i ( (char="(") && (stack.Peek()'="'") ) d
	..d stack.Push(i)
	..d stack.Push(char)
	.e  i ( (char=")") && (stack.Peek()'="'") && (stack.Peek()="(") ) d
	..d stack.Pop()
	..d stack.Pop()
	i stack.Size()'=0 d
	.s status=$$$ERROR("The grammer of "_filter_" is invalid")
	q:stack.Size()'=0 status
	i hasLogicalFlag=0 d
	.s node=##class(DHCWL.DM.Util.FilterTree).%New(0)
	.d ..BuildOneFilterExpTree(resultSetName,theme,##class(DHCWL.DM.Util.StringUtil).Trim( filter) ,.node)
	e  d
	.s nodeType=2
	.s:matchLogical="!" nodeType=1
	.s node=##class(DHCWL.DM.Util.FilterTree).%New(nodeType)
	.d node.SetLogical(matchLogical)
	.s lsi=1
	.f j=minLevelIndex-2:-1:1 d
	..s char2=$e(filter,j)
	..i ( (char2="'") && (stack.Peek()'="'")) d
	...d stack.Push(char2)
	..e  i ( (char2="'") && (stack.Peek()="'") && (preChar'="\")) d
	...d stack.Pop()
	..e  i ( (char2=")") && (stack.Peek()'="'") ) d
	...d stack.Push(char2)
	..e  i ( (char2="(") && (stack.Peek()'="'") && (stack.Peek()=")") ) d
	...d stack.Pop()
	...i (  (stack.Size()=0) ) d
	....s lsi=j
	..e  i ( (char2="(") && (stack.Size()=0) ) d
	...s lsi=j+1
	...;s j=0
	.f j=lsi-1:-1:1 d
	..s char=$e(filter,j)
	..i (  (char=")") || (char="(") ) d
	...s j=0
	..e  d
	...s lsi=lsi-1
	.s left=##class(DHCWL.DM.Util.StringUtil).Trim( $e(filter,lsi,minLevelIndex-2) )
	.d stack.Clear()
	.s rei=len
	.f j=minLevelIndex+1:1:len d
	..s char2=$e(filter,j)
	..i ( (char2="'") && (stack.Peek()'="'")) d
	...d stack.Push(char2)
	..e  i ( (char2="'") && (stack.Peek()="'") && (preChar'="\")) d
	...d stack.Pop()
	..e  i ( (char2="(") && (stack.Peek()'="'") ) d
	...d stack.Push(char2)
	..e  i ( (char2=")") && (stack.Peek()'="'") && (stack.Peek()="(") ) d
	...d stack.Pop()
	...i stack.Size()=0 d
	....s rei=j
	....;s j=len+1
	.f j=rei+1:1:len d
	..s char=$e(filter,j)
	..i (  (char="(") || (char=")") ) d
	...s j=len+1
	..e  d
	...s rei=rei+1
	.s right=##class(DHCWL.DM.Util.StringUtil).Trim( $e(filter,minLevelIndex+1,rei) )
	.;w "left:"_left,!
	.;w "right:"_right,!
	.s lnode=..ParseFilterRecursion(resultSetName,theme,left,.status)
	.d lnode.SetParent(node)
	.d node.SeLeft(lnode)
	.s rnode=..ParseFilterRecursion(resultSetName,theme,right,.status)
	.d rnode.SetParent(node)
	.d node.SetRight(rnode)
	q node
}

Method BuildOneFilterExpTree(resultSetName, theme As DHCWL.DM.T.ThemeBase, filterExp, ByRef node As DHCWL.DM.Util.FilterTree) As %Status
{
	s status=$$$OK
	d node.SetExpression(filterExp)
	q
	s dimPro="",fun="",para=""
	s len=$l(filterExp)
	s i=0,j=0 f  s i=$f(filterExp,">",i+1) q:i=0  d
	.s j=i
	i j>0 d
	.f i=j:1:len d
	..s char=$e(filterExp,i)
	..i ##class(DHCWL.DM.Util.StringUtil).IsSpace(char)=1 d
	...s j=i+1 
	..e  d
	...s i=len+1
	e  d
	.s j=1
	f i=j:1:len d
	.s char=$e(filterExp,i)
	.i ##class(DHCWL.DM.Util.StringUtil).IsSpace(char)=1 d
	..s dimPro=$e(filterExp,1,i)
	..s funPar=##class(DHCWL.DM.Util.StringUtil).Trim($e(filterExp,i+1,len))
	..s fun=##class(DHCWL.DM.Util.StringUtil).Trim($p(funPar,"(",1))
	..s para=##class(DHCWL.DM.Util.StringUtil).Trim($p($p(funPar,"(",2),")",1))
	..s i=len+1
	..;s len=$l(funPar)
	..;f j=1:1:len d
	..;.s char=$e(funPar,j)
	..;.i '(##class(DHCWL.DM.Util.StringUtil).IsLetter(char)=1) d
	..;..s fun=##class(DHCWL.DM.Util.StringUtil).Trim($e(funPar,1,j-1))
	..;..s para=##class(DHCWL.DM.Util.StringUtil).Trim($e(funPar,j,len))
	..;..s para=##class(DHCWL.DM.Util.StringUtil).Trim(para,"(")
	..;..s para=##class(DHCWL.DM.Util.StringUtil).Trim(para,")")
	..;..s j=len+1
	
	
	;w filterExp,!
	;w "dimPro:"_dimPro,!
	;w "fun:"_fun,!
	;w "para:"_para,!
	;q
	
	if ( (dimPro'="") && (fun'="") && (para'="") ) d
	.s paramList=$lb(),paramLen=0
	.s para2=para_","
	.s stack=##class(DHCWL.DM.Util.Stack).%New()
	.s len=$l(para2),parasi=1
	.f i=1:1:len d
	..s char=$e(para2,i)
	..i ( (char="'") && (stack.Peek()'="'") ) d
	...d stack.Push(char)
	..e  i ( (char="'") && (stack.Peek()="'") ) d
	...d stack.Pop()
	..e  i ((char=",") && (stack.Peek()'="'") ) d
	...s pv=$e(para2,parasi,i-1)
	...s pv=##class(DHCWL.DM.Util.StringUtil).Trim(pv,"'")
	...s parasi=i+1
	...s paramLen=paramLen+1
	...s $list(paramList,paramLen)=pv
	.i stack.Size()'=0 d
	..s status=$$$ERROR(para_" is invalide!")
	.q:stack.Size()'=0
	.i node.NodeType=0 d
	..s dimStruct=$lb()
	..d ..ParseDimExp(resultSetName,theme,dimPro,.dimStruct,"F")
	..s node.Params=paramList
	..s node.FilterFunction=fun
	..s node.DimStruct=dimStruct
	e  d
	.s status=$$$ERROR("The grammer of "_filterExp_" is invalid!")
}

Method FilterFunctionParse(resultSetName, node As DHCWL.DM.Util.FilterTree) As %Status
{
	q:node="" $$$OK
	s status=$$$OK
	d ..FilterFunctionParse(resultSetName,node.Left)
	d ..FilterFunctionParse(resultSetName,node.Right)
	if node.NodeType=0 d
	.s cubeId=..rsQueryMap(resultSetName,"Cube").%Id()
	.s funCall=##class(DHCWL.DM.Util.FunctionCall).%New(node.FilterFunction,node.Params)
	.i $ll(node.DimStruct)>4 d
	..s dimId=$lg(node.DimStruct,1,"")
	..s cubeDimId=##class(DHCWL.DM.T.CubeDims).Get(cubeId,dimId)
	..s:cubeDimId'="" cubeDimId=cubeDimId.%Id()
	..i cubeDimId="" d
	...s status=$$$ERROR("Can't get cubeDim where theme dim is "_dimId_" from CubeDStructMap")
	..s sn=##class(DHCWL.DM.T.CubeDStructMap).GetDimSN(cubeId,cubeDimId)
	..i sn<1 d
	...s status=$$$ERROR("Can't get dim serial number of "_cubeId)
	..q:(status'=$$$OK)
	..s status=##class(DHCWL.DM.T.DimDataIndex).BacksteppingFromeFilter(node,funCall,.paraList)
	.else  d
	..s dimId=$lg(node.DimStruct,1,"")
	..s cubeDimId=##class(DHCWL.DM.T.CubeDims).Get(cubeId,dimId)
	..s:((cubeDimId'="") ) cubeDimId=cubeDimId.%Id()
	..s sn=##class(DHCWL.DM.T.CubeDStructMap).GetDimSN(cubeId,cubeDimId)
	..i sn<1 d
	...s status=$$$ERROR("Can't get dim serial number of "_cubeId)
	..q:status'=$$$OK
	..s node.DimStruct=$lb(cubeDimId,,sn)
	..s paraList=##class(DHCWL.DM.T.CubeDStruct).BacksteppingDimsFromeFilter(cubeId,node,funCall)
	.q:status'=$$$OK
	.k segBitIndex
	.d ##class(DHCWL.DM.T.CubeDStruct).FetchBitIndexFromDims(cubeId,$lb(cubeDimId,,sn),paraList,.segBitIndex)
	.s node.SegBitIndexMap=segBitIndex
	q status
}

Method ComputeIdFromFilterStruct(resultSetName, node As DHCWL.DM.Util.FilterTree) As %Status
{
	q:node="" $$$OK
	s status=$$$OK
	d ..FilterFunctionParse(resultSetName,node.Left)
	d ..FilterFunctionParse(resultSetName,node.Right)
	if node.NodeType=0 d
	.s cubeId=..rsQueryMap(resultSetName,"Cube").%Id()
	.s funCall=##class(DHCWL.DM.Util.FunctionCall).%New(node.FilterFunction,node.Params)
	.i $ll(node.DimStruct)>4 d
	..s dimId=$lg(node.DimStruct,1,"")
	..s cubeDimId=##class(DHCWL.DM.T.CubeDims).Get(cubeId,dimId)
	..s:cubeDimId'="" cubeDimId=cubeDimId.%Id()
	..i cubeDimId="" d
	...s status=$$$ERROR("Can't get cubeDim where theme dim is "_dimId_" from CubeDStructMap")
	..s sn=##class(DHCWL.DM.T.CubeDStructMap).GetDimSN(cubeId,cubeDimId)
	..i sn<1 d
	...s status=$$$ERROR("Can't get dim serial number of "_cubeId)
	..q:(status'=$$$OK)
	..s status=##class(DHCWL.DM.T.DimDataIndex).BacksteppingFromeFilter(node,funCall,.paraList)
	.else  d
	..s dimId=$lg(node.DimStruct,1,"")
	..s cubeDimId=##class(DHCWL.DM.T.CubeDims).Get(cubeId,dimId)
	..s:((cubeDimId'="") ) cubeDimId=cubeDimId.%Id()
	..s sn=##class(DHCWL.DM.T.CubeDStructMap).GetDimSN(cubeId,cubeDimId)
	..i sn<1 d
	...s status=$$$ERROR("Can't get dim serial number of "_cubeId)
	..q:status'=$$$OK
	..s node.DimStruct=$lb(cubeDimId,,sn)
	..s paraList=##class(DHCWL.DM.T.CubeDStruct).BacksteppingDimsFromeFilter(cubeId,node,funCall)
	.q:status'=$$$OK
	.k segBitIndex
	.d ##class(DHCWL.DM.T.CubeDStruct).FetchBitIndexFromDims(cubeId,$lb(cubeDimId,,sn),paraList,.segBitIndex)
	.s node.SegBitIndexMap=segBitIndex
	q status
}

ClassMethod VisitDG(node As DHCWL.DM.Util.FilterTree)
{
	q:node=""
	w:node.LogicalOperator'="" "Logical:"_node.LogicalOperator,!
	d ..VisitDG(node.Left)
	d ..VisitDG(node.Right)
	w:node.Expression'="" node.Expression,!
}

Method ParseMetrics(resultSetName, metrics As %String, ByRef metricList As %List) As %Status
{
	s metrics=metrics_","
	s len=$l(metrics)
	s stack=##class(DHCWL.DM.Util.Stack).%New()
	s metricsi=1,count=0
	s metricList=$lb()
	f i=1:1:len d
	.s char=$e(metrics,i)
	.i ( (char="'") && (stack.Peek()'="'") ) d
	..d stack.Push(char)
	.e  i ( (char="'") && (stack.Peek()="'") ) d
	..d stack.Pop()
	.e  i ( (char="(") && (stack.Peek()'="'") ) d
	..d stack.Push(char)
	.e  i ( (char=")") && (stack.Peek()="(") ) d
	..d stack.Pop()
	.e  i ( (char=",") && (stack.Peek()'="'") && (stack.Peek()'="(") ) d
	..s metric=$e(metrics,metricsi,i-1)
	..s metricsi=i+1
	..s count=count+1
	..s $list(metricList,count)=metric
	q:stack.Size()'=0 $$$ERROR("The grammer is invalid of "_metrics)
	q $$$OK
}*/
}
