Class DHCWL.DM.Core.DimQuery Extends %RegisteredObject
{

/// 单个节点的最大Bit长度 最大可设置为：262104;
Parameter MAXBITRANGE = 262104;

Property dimBase As DHCWL.DM.T.DimBase;

// ("S","I",showIndex)=propertyName

// ("S","I",showIndex,"S")=structList

// ("S","N",propertyName)=showIndex

// ("A",2,aliasExp)=preDim ;pro

// ("A",1,pro)=aliasExp

// ("A",2,aliasExp,"SI")=structIndex

// ("A",3,"P",index)=aliasExp

// ("A",3,"A",aliasExp)=index

Property resolvedDim [ MultiDimensional ];

Property proFunStruct [ MultiDimensional ];

Property FilterRootNode As DHCWL.DM.Util.FilterTree;

Property RefId As %Integer;

Property CurId As %Integer;

Property EndFlag As %Boolean;

Method %OnNew(dimPath As %String, propertiesExpression, propertiesFilter = "") As %Status [ Private, ServerOnly = 1 ]
{
	s ..dimBase=##class(DHCWL.DM.T.DimBase).GetByPath(dimPath)
	q:..dimBase="" $$$ERROR("Can't find dim with path "_dimPath)
	s status=..ParseProperties(propertiesExpression)
	i status'=$$$OK {
	  Do DisplayError^%apiOBJ(status)
	  q status
	}
	s:propertiesFilter'="" status=..ParseFilter(propertiesFilter)
	i status'=$$$OK {
	  Do DisplayError^%apiOBJ(status)
	  q status
	}
	s ..RefId=+$this
	s ..CurId=""
	s ..EndFlag=0
	
	s refId=..RefId
	k ^TEMPDHCWLDQ($j,refId)
	s status=..FilterFunctionParse(..FilterRootNode)
	q:status'=$$$OK status
	s dimId=..dimBase.%Id()
	m proFunStruct=..proFunStruct
	if ..FilterRootNode'=""{
	  d ..GetFilterTargetBit()
	  m segBitMap=..FilterRootNode.SegBitIndexMap
	  f i=0:1:$g(segBitMap,0){
	    continue:'$d(segBitMap(i))
	    s bit=segBitMap(i)
	    s j=$bitfind(bit,1,1)
	    while(j>0){
	      s id=(i*..#MAXBITRANGE)+j
	      s rowKey=##class(DHCWL.DM.T.DimDStruct).GetRowKey(dimId,id)
	      s ^TEMPDHCWLDQ($j,refId,rowKey)=""
	      s j=$bitfind(bit,1,j+1)
	    }
	  }
	}else{
	  s rowKey="" f{
	    s rowKey=$o(^DHCWL.DM.T.DimDStructD(dimId,rowKey))
	    q:rowKey=""
	    s ^TEMPDHCWLDQ($j,refId,rowKey)=""
	  }
	}
	
	q status
}

// d ##class(DHCWL.DM.Core.DimQuery).Test()

ClassMethod Test()
{
	/*s query=##class(DHCWL.DM.Core.DimQuery).%New("/Department.d","Type,Code,Name,Hospital->Code as hosCode,Hospital->Name hosName","Hospital->Name startWith('北京地坛医院') && Code startwith('产')")
	
	
	w query.Next(),!
	w $lts(query.GetProperties()),!
	w query.GetPropertyCount(),!
	w query.Data("Code"),!
	w query.DataByIndex(2),!
	d query.Reset()
	s len=query.GetPropertyCount()
	while query.Next(){
	  f i=1:1:len{
		w query.DataByIndex(i)_"  "
	  }
	  w !
	}
	d query.Close()
	*/
	s query=##class(DHCWL.DM.Core.DimQuery).%New("/Department.d","RowId,Code,Name,Type,IsWard,Hospital->Code as hosCode,Hospital->Name hosName","IsWard=('Y')")
	
	
	w query.Next(),!
	w $lts(query.GetProperties()),!
	w query.GetPropertyCount(),!
	d query.Reset()
	s len=query.GetPropertyCount()
	while query.Next(){
	  f i=1:1:len{
		w query.DataByIndex(i)_"  "
	  }
	  w !
	}
	w "Get by rowkey:22",!
	w $lts(query.Get(22)),!
	b ;1
	d query.Close()
	q
	
	s query=##class(DHCWL.DM.Core.DimQuery).%New("/Doctor.d","Code,Name")
	
	
	w query.Next(),!
	w $lts(query.GetProperties()),!
	w query.GetPropertyCount(),!
	w query.Data("Code"),!
	w query.DataByIndex(2),!
	d query.Reset()
	s len=query.GetPropertyCount()
	while query.Next(){
	  f i=1:1:len{
		w query.DataByIndex(i)_"  "
	  }
	  w !
	}
	d query.Close()
}

Method ParseProperties(propertiesExp) As %Status [ Private ]
{
	s status=$$$OK
	s propertiesExp=##class(DHCWL.DM.Util.StringUtil).Trim(propertiesExp)
	s len=$l(propertiesExp)
	s dims=propertiesExp
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
		s status=..ParseDimExp(dimExp,.sl,"D",dimExpInd)
	    q:status'=$$$OK
	    s ..resolvedDim("S","I",dimExpInd)=dimExp
	    s ..resolvedDim("S","I",dimExpInd,"S")=sl
	    s ..resolvedDim("S","N",dimExp)=dimExpInd
		s dimIndS=i+1
	  }
	}
	q status
}

Method ParseDimExp(proExp, ByRef structList, type, index As %Integer = 0) As %Status [ Private ]
{
	s structList=$lb()
	s len=$l(proExp,">")
	s status=$$$OK
	s dimBase=""
	f i=1:1:len {
	  s j=(i-1)*4+1
	  s dim=##class(DHCWL.DM.Util.StringUtil).Trim( $p($p(proExp,">",i),"-",1) )
	  if ((index>0)&&(i=len)&&(type="D")) {
		s pro=dim,aliasExp="",preDim=proExp
	    s len2=$l(pro),flag=0
	    f m=len2:-1:1{
	      s char=$e(pro,m)
	      if ( ##class(DHCWL.DM.Util.StringUtil).IsSpace(char)'=0 ){
		    s aliasExp=$e(pro,m+1,len2)
		    s proei=$l(proExp)-$l(aliasExp)
		    s preDim=##class(DHCWL.DM.Util.StringUtil).Trim($e(preDim,1,proei))
		    s aliasExp=##class(DHCWL.DM.Util.StringUtil).Trim(aliasExp)
		    s pro=##class(DHCWL.DM.Util.StringUtil).Trim($e(dim,1,m-1))
		    s prolen=$l(pro)
		    if ($zcvt($e(pro,prolen-1,prolen),"U")="AS")&& (##class(DHCWL.DM.Util.StringUtil).IsSpace($e(pro,prolen-2)))  {
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
			s aliasExp="dim"_index
		  }else{
			s aliasExp=##class(DHCWL.DM.Util.StringUtil).Trim(preDim)
		  }
	    }
		if ($d(..resolvedDim("A",2,aliasExp))){
		  s status=$$$ERROR(preDim_" has same alias name "_aliasExp_" with in "_..resolvedDim("A",2,aliasExp))
		  q
		}
		s ..resolvedDim("A",2,aliasExp)=preDim ;pro
		s ..resolvedDim("A",1,pro)=aliasExp
		s ..resolvedDim("A",2,aliasExp,"SI")=j
		s ..resolvedDim("A",3,"P",index)=aliasExp
		s ..resolvedDim("A",3,"A",aliasExp)=index
		s pro=##class(DHCWL.DM.Util.StringUtil).Trim($p(pro,"(",1))
		s ..resolvedDim("A",2,aliasExp,"S")=pro
	  }
	  s dim2=dim
	  i ( (dim [ "(") && (dim [ ")") ){
		s dim=$p(dim,"(")
	  }
	  i i=1 {
		s dimBase=..dimBase
	  }
	  s dimPro=dimBase.GetProperty(dim)
	  i dimPro="" {
	    s status=$$$ERROR("Can't get property "_dim_" from "_index)
	    q
	  }
	  s sn=##class(DHCWL.DM.T.DimDStructMap).GetMapPosition(dimBase.%Id(),dimPro.%Id())
	  i sn=0 {
		s status=$$$ERROR("Can't get property "_dim_"'s map position!")
		q
	  }
	  s jdbcTypeCode=dimPro.DataType.JDBCTypeCodeNum
	  s:jdbcTypeCode="" jdbcTypeCode=12
	  s $list(structList,j)=dimBase.%Id()
	  s $list(structList,j+1)=dimPro.%Id()
	  s $list(structList,j+2)=sn
	  s $list(structList,j+3)=jdbcTypeCode
	  d resolveDimMethodGrammar()
	  i ( (dimPro.IsLinked="Y") ) {
		s dimBase=##class(DHCWL.DM.T.DimBase).GetByPath(dimPro.LinkedPath)
		if dimBase="" {
	      s status=$$$ERROR("Can't get dimBase with path"_dimPro.LinkedPath)
		  q
		}
	  }
	}
	q status
resolveDimMethodGrammar()
    i '( (dim2 [ "(") && (dim2 [ ")") ){
	  q $$$OK
    }
    if (dimPro.CreatedType="") || (dimPro.CreatedType.GetPath()'="DIM:DYNPROFUN"){
	  s status=$$$ERROR(dim2_" is not daynamic function property!")
	  q status
    }
    s dim2Len=$l(dim2)
    s dimFunStack=##class(DHCWL.DM.Util.Stack).%New()
    s (proFun,paramStr)=""
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
		s proFun=##class(DHCWL.DM.Util.StringUtil).Trim( $e(dim2,1,parasi-1) )
		s paramStr=##class(DHCWL.DM.Util.StringUtil).Trim( $e(dim2,parasi+1,dim2Ind-1) )
	  }elseif (dim2c="'") && (dimFunStack.Peek()'="'"){
		d dimFunStack.Push(dim2c)
	  }elseif (dim2c="'") && (dimFunStack.Peek()="'"){
		d dimFunStack.Pop()
	  }
    }
    q:status'=$$$OK status
    i (proFun="")||(dimPro=""){
	  s status=$$$ERROR("The grammar of "_dim2_" is invalid!")
	  q
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
    s $list(structList,j+3)=$lg(structList,j+3)_"#"
    s ..proFunStruct(type,index,i,"D")=dimBase.%Id()
    s ..proFunStruct(type,index,i,"P")=runtimeParams
    s ..proFunStruct(type,index,i,"SI")=j
    s ..proFunStruct(type,index,i,"F")=##class(DHCWL.DM.Util.FunctionCall).%New("DYCDIMPRO:"_proFun)
    
    ;s dim=proFun
    q $$$OK
}

Method ParseFilter(propertiesFilter) As %Status [ Private ]
{
	s ..FilterRootNode=..ParseFilterRecursion(propertiesFilter,"",.status)
	q status
}

Method ParseFilterRecursion(filter As %String, parent As DHCWL.DM.Util.FilterTree, ByRef status As %Status, type = "F") As DHCWL.DM.Util.FilterTree [ Private ]
{
	if filter="" {
	  s status=$$$OK
	  q ""	
	}
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
	  }elseif ( (char="(") && (stack.Size()=0) ) {
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
	  s status= ..BuildOneFilterExpTree(filter ,node,type)
	}else{
	  s nodeType=2
	  s leftEndInd=minLevelIndex-2
	  s rightStartInd=minLevelIndex+1
	  i matchLogical="!" {
		s nodeType=1
		s leftEndInd=minLevelIndex-1
		s rightStartInd=minLevelIndex+1
	  }
	  s node=##class(DHCWL.DM.Util.FilterTree).%New(nodeType)
	  d node.SetLogical(matchLogical)
	  s lsi=1,continueFlag=0,char2=""
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
	  d stack.Clear()
	  s rei=len,char2=""
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
	  
	  s right=##class(DHCWL.DM.Util.StringUtil).Trim( $e(filter,rightStartInd,rei) )
	  ;w "logical:"_matchLogical,!
	  ;w "left:"_left,!
	  ;w "right:"_right,!
	  d:left'="" node.SeLeft(..ParseFilterRecursion(left,node,.status))
	  d:right'="" node.SetRight(..ParseFilterRecursion(right,node,.status))
	}
	q node
}

Method BuildOneFilterExpTree(filterExp, node As DHCWL.DM.Util.FilterTree, type = "F") As %Status [ Private ]
{
	s status=$$$OK
	d node.SetExpression(filterExp)
	;q status
	s dimPro="",fun="",para=""
	s len=$l(filterExp)
	s stack=##class(DHCWL.DM.Util.Stack).%New()
	s char=""
	f i=len:-1:1{
	  s preChar=char
	  s char=$e(filterExp,i)
	  if ((char=")")&&(stack.Size()=0)){
		d stack.Push(i)
	  }elseif ((char="(")&&(stack.Peek()'="'")){
		s pe= stack.Pop()
		if stack.Size()=0{
		  s para=##class(DHCWL.DM.Util.StringUtil).Trim($e(filterExp,i+1,pe-1))
		  s filterExp2=##class(DHCWL.DM.Util.StringUtil).Trim($e(filterExp,1,i-1))
		  f len2=$l(filterExp2)
		  f j=1:1:len2{
			s char2=$e(filterExp2,j)
			if '##class(DHCWL.DM.Util.StringUtil).IsLetter(char2){
			  s fun=##class(DHCWL.DM.Util.StringUtil).Trim($e(filterExp2,j,len2))
			  s dimPro=##class(DHCWL.DM.Util.StringUtil).Trim($e(filterExp2,1,j-1))
			  q
			}
		  }
		  q
		}
	  }elseif ((char="'") && (preChar'="\") && (stack.Peek()'="'")){
		d stack.Push(char)
	  }elseif ((char="'") && (preChar'="\") ){
		d stack.Pop()
	  }
	}
	q:stack.Size()'=0 $$$ERROR("The grammar of "_filterExp_" is invalid!")
	
	;b ;BuildOneFilterExpTree
	if ( (dimPro'="") && (fun'="") && (para'="") ) {
	  s paramList=$lb(),paramLen=0
	  s para2=para_","
	  s len=$l(para2),parasi=1
	  f i=1:1:len {
	    s char=$e(para2,i)
	    i ( (char="'") && (stack.Peek()'="'") ) {
	      d stack.Push(char)
	    }elseif( (char="'") && (stack.Peek()="'") ) {
	      d stack.Pop()
	    }elseif((char=",") && (stack.Peek()'="'") ) {
	      s pv=$e(para2,parasi,i-1)
	      s pv=##class(DHCWL.DM.Util.StringUtil).Trim(pv,"'")
	      s parasi=i+1
	      s paramLen=paramLen+1
	      s $list(paramList,paramLen)=pv
	    }
	  }
	  q:stack.Size()'=0 $$$ERROR(para_" is invalide!")
	  i node.NodeType=0 {
	    s dimStruct=$lb()
	    s funind=$i(..proFunStruct(type))
	    ;b ;BuildOneFilterExpTree->ParseDimExp
	    d ..ParseDimExp(dimPro,.dimStruct,"F",funind)
	    s node.Params=paramList
	    s node.FilterFunction=fun
	    s node.DimStruct=dimStruct
	    s node.proFunStructIndex=funind
	  }
	}else{
	  b  ;1
	  s status=$$$ERROR("The grammar of "_filterExp_" is invalid!")
	}
	q status
}

Method Execute() As %Status [ Private ]
{
	s refId=..RefId
	k ^TEMPDHCWLDQ($j,refId)
	s status=..FilterFunctionParse(..FilterRootNode)
	q:status'=$$$OK status
	s dimId=..dimBase.%Id()
	m proFunStruct=..proFunStruct
	if ..FilterRootNode'=""{
	  d ..GetFilterTargetBit()
	  m segBitMap=..FilterRootNode.SegBitIndexMap
	  f i=0:1:$g(segBitMap,0){
	    continue:'$d(segBitMap(i))
	    s bit=segBitMap(i)
	    s j=$bitfind(bit,1,1)
	    while(j>0){
	      s id=(i*..#MAXBITRANGE)+j
	      s rowKey=##class(DHCWL.DM.T.DimDStruct).GetRowKey(dimId,id)
	      d BuildRow
	      s j=$bitfind(bit,1,j+1)
	    }
	  }
	}else{
	  s rowKey="" f{
	    s rowKey=$o(^DHCWL.DM.T.DimDStructD(dimId,rowKey))
	    q:rowKey=""
	    d BuildRow
	  }
	}
	q status
BuildRow
    s rowList=$lb()
	s proShowInd="" f{
      s proShowInd=$o(..resolvedDim("S","I",proShowInd))
	  q:proShowInd=""
	  s proStruct=..resolvedDim("S","I",proShowInd,"S")
	  s pv=##class(DHCWL.DM.T.DimDStruct).GetValue(rowKey,proStruct,proShowInd,.proFunStruct,"DQ")
	  s $list(rowList,proShowInd)=pv
	}
	s tid=$i(^TEMPDHCWLDQ($j,refId))
    s ^TEMPDHCWLDQ($j,refId,tid)=rowList
    q
}

Method Get(rowKey As %String) As %List
{
  q:( (rowKey="") || ('$d(^TEMPDHCWLDQ($j,..RefId,rowKey))) ) ""
  if (^TEMPDHCWLDQ($j,..RefId,rowKey)=""){
	s rowList=$lb()
	s proShowInd="" f{
      s proShowInd=$o(..resolvedDim("S","I",proShowInd))
	  q:proShowInd=""
	  s proStruct=..resolvedDim("S","I",proShowInd,"S")
	  s pv=##class(DHCWL.DM.T.DimDStruct).GetValue(rowKey,proStruct,proShowInd,.proFunStruct,"DQ")
	  s $list(rowList,proShowInd)=pv
	}
    s ^TEMPDHCWLDQ($j,..RefId,rowKey)=rowList
  }
  q ^TEMPDHCWLDQ($j,..RefId,rowKey)
}

Method Next() As %Boolean
{
	q:..EndFlag=1 0
	s rowKey=$o(^TEMPDHCWLDQ($j,..RefId,..CurId))
	i rowKey="" {
	  s ..EndFlag=1
	  q 0
	}
	s ..CurId=rowKey
	if (^TEMPDHCWLDQ($j,..RefId,rowKey)=""){
	  s rowList=$lb()
	  s proShowInd="" f{
        s proShowInd=$o(..resolvedDim("S","I",proShowInd))
	    q:proShowInd=""
	    s proStruct=..resolvedDim("S","I",proShowInd,"S")
	    s pv=##class(DHCWL.DM.T.DimDStruct).GetValue(rowKey,proStruct,proShowInd,.proFunStruct,"DQ")
	    s $list(rowList,proShowInd)=pv
	  }
      s ^TEMPDHCWLDQ($j,..RefId,rowKey)=rowList
	}
	
	q 1
}

Method Reset() As %Boolean
{
	s ..CurId=""
	s ..EndFlag=0
	q 1
}

Method Data(property) As %String
{
	q:property="" ""
	s ind=$g(..resolvedDim("A",3,"A",property),0)
	q:ind=0 ""
	q $lg(^TEMPDHCWLDQ($j,..RefId,..CurId),ind,"")
}

Method DataByIndex(index As %Integer) As %String
{
	q $lg(^TEMPDHCWLDQ($j,..RefId,..CurId),index,"")
}

Method GetProperties() As %List
{
	s lb=$lb()
	s ind="" f{
      s ind=$o(..resolvedDim("A",3,"P",ind))
      q:ind=""
      s $list(lb,ind)=..resolvedDim("A",3,"P",ind)
	}
	q lb
}

Method GetPropertyCount() As %Integer
{
	q $o(..resolvedDim("A",3,"P",""),-1)
}

Method Close() As %Status
{
    k ^TEMPDHCWLDQ($j,..RefId)
    s ..dimBase=""
    s ..FilterRootNode=""
    q $$$OK
}

Method FilterFunctionParse(node As DHCWL.DM.Util.FilterTree) As %Status [ Private ]
{
	q:node="" $$$OK
	s status=$$$OK
	d ..FilterFunctionParse(node.Left)
	d ..FilterFunctionParse(node.Right)
	if node.NodeType=0 {
	  s funCall=##class(DHCWL.DM.Util.FunctionCall).%New("FILTER:"_node.FilterFunction,node.Params)
	  s dimId=$lg(node.DimStruct,1,"")
	  m tmpProFunStruct=..proFunStruct
	  s status=##class(DHCWL.DM.T.DimDataIndex).BacksteppingFromeFilter(node,funCall,.paraList,.tmpProFunStruct,1)
	  s len=$ll(paraList)
	  s bitSeg=0,maxBitSeg=1
	  k dimBitMap
	  f i=1:1:len{
		s rowKey=$lg(paraList,i,"")
		continue:rowKey=""
		s id=##class(DHCWL.DM.T.DimDStruct).GetRowKeyId(dimId,rowKey)
		continue:id=0
		if id > ..#MAXBITRANGE{
		  s bitSeg=id \ ..#MAXBITRANGE
		  s id= id # ..#MAXBITRANGE
		  s:bitSeg>maxBitSeg maxBitSeg=bitSeg+1
		}
		s $bit(dimBitMap(bitSeg),id)=1
	  }
	  s node.SegBitIndexMap=maxBitSeg
	  m node.SegBitIndexMap=dimBitMap
	}
	q status
}

Method GetFilterTargetBit() [ Private ]
{
	d ..GetFilterTargetBitHelper(..FilterRootNode)
}

Method GetFilterTargetBitHelper(node As DHCWL.DM.Util.FilterTree) [ Private ]
{
	q:((node="")||(node.NodeType=0))
	if ((node.NodeType=2) && (node.LogicalOperator="&")){
		d ..GetFilterTargetBitHelper(node.Left)
		d ..GetFilterTargetBitHelper(node.Right)
		s leftBitMap="",rightBitMap=""
		m leftBitMap=node.Left.SegBitIndexMap,rightBitMap=node.Right.SegBitIndexMap
		k resultBitMap
		s maxI=leftBitMap
		s:maxI<rightBitMap maxI=rightBitMap
		s resultBitMap=maxI
		f i=0:1:maxI {
		  s bit1=$g(leftBitMap(i),"")
		  s bit2=$g(rightBitMap(i),"")
		  s resultBitMap(i)=$bitlogic(bit1 & bit2)
		}
		m node.SegBitIndexMap=resultBitMap
	}elseif ((node.NodeType=2) && (node.LogicalOperator="|")){
		d ..GetFilterTargetBitHelper(node.Left)
		d ..GetFilterTargetBitHelper(node.Right)
		s leftBitMap="",rightBitMap=""
		m leftBitMap=node.Left.SegBitIndexMap,rightBitMap=node.Right.SegBitIndexMap
		k resultBitMap
		s maxI=leftBitMap
		s:maxI<rightBitMap maxI=rightBitMap
		s resultBitMap=maxI
		f i=0:1:maxI {
		  s bit1=$g(leftBitMap(i),"")
		  s bit2=$g(rightBitMap(i),"")
		  s resultBitMap(i)=$bitlogic(bit1 | bit2)
		}
		m node.SegBitIndexMap=resultBitMap
	}
}

}
