/// Created by lhh
/// Date 2016-01-21
Class DHCWL.MKPIService.Base.Filter Extends %RegisteredObject
{

Property UDC2KBDC As %DataType [ MultiDimensional ];

Property resolvedTree As DHCWL.util.TreeNode;

Property RSTNMap As %DataType [ MultiDimensional ];

Property dimResolver As DHCWL.MKPIService.Base.DimRuleResolver;

//d ##class(DHCWL.MKPIService.Base.Filter).Test()

ClassMethod Test()
{
	s filter=##class(DHCWL.MKPIService.Base.Filter).%New()
	s map("PatLoc")="CTLOC"
	s map("PatDoc")="CTPCP"
	d filter.ResovleFilterRule("[{PatLoc}=1 || {PatLoc.LocDesc}\[ 心内 ] && [ {PatDoc}=2 || {PatDoc.DocName}\[李 ]",.map)
	s dims("PatLoc")=1
	s dims("PatDoc")=3
	s flag=filter.FilterValues(.dims)
	if (flag){
		//满足过滤条件，保留数据
	}
	w "flag="_flag,!
	s dims("PatLoc")=1
	s dims("PatDoc")=2
	s flag=filter.FilterValues(.dims)
	w "flag="_flag,!
	s dims("PatLoc")=1
	s dims("PatDoc")=3
	s flag=filter.FilterValues(.dims)
	w "flag="_flag,!
}

ClassMethod VisitDG(node As DHCWL.util.TreeNode)
{
	q:node=""
	d ..VisitDG(node.LeftChild)
	d ..VisitDG(node.RightChild)
	w node.Data,!
}

/*
ResovleFilterRule方法说明：

filterRule表示过滤表达式，和指标过滤表达式一样，但是没有指标定义信息。即将指标过滤表达式中的KPICode()去掉.

userDimToKpiBaseDimMap提供过来表达式中所有的用到的用户自定义维度到指标基础维度的映射关系。数据格式如下：
userDimToKpiBaseDimMap("UserDefinedDimCode1")="kpiBaseDimCode1"
userDimToKpiBaseDimMap("UserDefinedDimCode2")="kpiBaseDimCode2"
...
userDimToKpiBaseDimMap("UserDefinedDimCodeN")="kpiBaseDimCodeM"
*/
Method ResovleFilterRule(filterRule As %Text, ByRef userDimToKpiBaseDimMap)
{
	k ..UDC2KBDC
	m ..UDC2KBDC=userDimToKpiBaseDimMap
	s tree=..BuildTree(filterRule)
	//d ..VisitDG(tree)
	s ..resolvedTree=..PostThreadingBuildTree(tree)
	s ..dimResolver=##class(DHCWL.MKPIService.Base.DimRuleResolver).%New()
	d ..dimResolver.setCache(1)
}

/**
FilterValues方法说明：

dimValues表示要过滤的数据值，其格式如下：
dimValues("UserDefinedDimCode1")=dim1Value
dimValues("UserDefinedDimCode2")=dim2Value
...
dimValues("UserDefinedDimCodeN")=dimNValue

*/
Method FilterValues(ByRef dimValues) As %Boolean
{
	q ..PostVisitThreadTree(..resolvedTree,.dimValues)
}

ClassMethod BuildTree(data = "") As DHCWL.util.TreeNode
{
	s LOARR("&")=2,LOARR("|")=2 ,LOARR("!")=1
	s LOEleS="[",LOEleE="]",ProS="{",ProE="}"
	q:data="" ""
	s data=##class(DHCWL.util.StringUtil).Trim(data)
	s stack=##class(DHCWL.util.Stack).Init()
	s len=$l(data),curChar="",preChar="",minBracket=9999999999,minBracketInd=1,loFlag=1
	s preLOIndex=0
	f i=1:1:len {
		s preChar=curChar
		s curChar=$e(data,i)
		if ((preChar'="\")&&(curChar=LOEleS)){
			d stack.Push(curChar)
		}elseif ((preChar'="\")&&(curChar=LOEleE)){
			d stack.Pop()
		}elseif ((curChar="!")||((preChar=curChar)&&($d(LOARR(preChar)))&&($d(LOARR(curChar))))){
			s realLOFlag=0
			s preLOIndex=i+1
			f j=i+1:1:len {
				s preChar2=$g(curChar2)
				s curChar2=$e(data,j)
				if ((curChar2="!")||((preChar2=curChar2)&&($d(LOARR(preChar2)))&&($d(LOARR(curChar2))))){
					s preLOIndex=j+1
					s endJIndex=j
					if curChar2="!" s endJIndex=endJIndex-1
					else  s endJIndex=endJIndex-2
					s canFindNotLO=$e(data,i+1,endJIndex)
					if ((canFindNotLO [ "{")&&(canFindNotLO [ "}")) s realLOFlag=1
					q
				}
			}
			if j=len {
				s canFindNotLO=$e(data,preLOIndex,len)
				if ((canFindNotLO [ "{")&&(canFindNotLO [ "}")) s realLOFlag=1
			}
			if ((realLOFlag=1)&&(minBracket>stack.Size())){
				s minBracket=stack.Size(),minBracketInd=i
				s loFlag=0
			}
		}
	}
	s preLOIndex=0
	if (loFlag) s minBracketInd=0,minBracket=0
	q:stack.Size()'=0 ""
	s left="",right="",lo=""
	f i=1:1:len {
		s preChar=curChar
		s curChar=$e(data,i)
		if ((preChar'="\")&&(curChar=LOEleS)){
			d stack.Push(curChar)
		}elseif ((preChar'="\")&&(curChar=LOEleE)){
			d stack.Pop()
		}elseif ((curChar="!")||((preChar=curChar)&&($d(LOARR(preChar)))&&($d(LOARR(curChar))))){
			s realLOFlag=0
			s preLOIndex=i+1
			f j=i+1:1:len {
				s preChar2=$g(curChar2)
				s curChar2=$e(data,j)
				if ((curChar2="!")||((preChar2=curChar2)&&($d(LOARR(preChar2)))&&($d(LOARR(curChar2))))){
					s preLOIndex=j+1
					s endJIndex=j
					if curChar2="!" s endJIndex=endJIndex-1
					else  s endJIndex=endJIndex-2
					s canFindNotLO=$e(data,i+1,endJIndex)
					if ((canFindNotLO [ "{")&&(canFindNotLO [ "}")) s realLOFlag=1
					q
				}
			}
			if j=len {
				s canFindNotLO=$e(data,preLOIndex,len)
				if ((canFindNotLO [ "{")&&(canFindNotLO [ "}")) s realLOFlag=1
			}
			if ((realLOFlag=1)&&(minBracketInd=i)){
				if (LOARR(curChar)=2){
					s left=$e(data,minBracket+1,i-2)
					s lo=curChar_curChar
				}else{
					s left=""
					s lo=curChar
				}
				s right=$e(data,i+1,len-minBracket)
				;b ;003
				q
			}
		}
	}
	if (lo=""){
		s data=##class(DHCWL.util.StringUtil).Trim(data)
		s node= ##class(DHCWL.util.TreeNode).Init(data,1)
		q node
	}
	s loNode=##class(DHCWL.util.TreeNode).Init(lo,2)
	s leftNode=..BuildTree(left)
	s loNode.LeftChild=leftNode
	s rightNode=..BuildTree(right)
	s loNode.RightChild=rightNode
	if (leftNode'=""){
		s leftNode.Parent=loNode	
	}
	if (rightNode'=""){
		s rightNode.Parent=loNode	
	}
	q loNode
}

ClassMethod PostThreadingBuildTree(ByRef tree As DHCWL.util.TreeNode) As DHCWL.util.TreeNode
{
	q:tree=""
	s treeHead=##class(DHCWL.util.TreeNode).Init("",3)
	s treeHead.LeftLinkType=treeHead.ThreadFlag,treeHead.RightLinkType=treeHead.ThreadFlag
	s cur=tree
	while((cur.LeftChild'="")||(cur.RightChild)){
		while(cur.LeftChild'=""){
			s cur=cur.LeftChild
		}
		if (cur.RightChild'="") s cur=cur.RightChild
	}
	s treeHead.LeftChild=tree   //设置虚拟节点
	s treeHead.RightChild=cur
	d ..PostThreadingPri(tree)  //线索化
	q treeHead
}

//added by lhh@20131121

/// [Previously private]
ClassMethod PostThreadingPri(tree As DHCWL.util.TreeNode)
{
	q:tree="" 0
	s stack=##class(DHCWL.util.Stack).Init()
	d stack.Push(tree)
	s linkFlag=tree.LinkFlag,threadFlag=tree.ThreadFlag
	s cur=tree.LeftChild,parent=""
	s previous=""
	while((stack.Size()>0)){
		while ((cur)&&(cur.LeftChild)){
			d stack.Push(cur)
			s parent=cur
			s cur=cur.LeftChild
		}
		;if ((cur)&&(cur.RightChild="")) s previous=cur
		if ((cur)&&(cur.RightChild)){
			s parent=cur
			d stack.Push(cur)
			s cur=cur.RightChild
		}else{
			;w cur.Data,!
			if ((cur)&&(cur.LeftChild="")){
				s cur.LeftLinkType=threadFlag
				s cur.LeftChild=previous
			}
			if ((previous'="")&&(previous.RightChild="")){
				s previous.RightLinkType=threadFlag
				s previous.RightChild=cur	
			}
			s previous=cur
			s parent=stack.Peek()
			while ((stack.Size()>0)&&(parent.RightChild=cur)){
				;s previous=cur
				s cur=stack.Pop()
				;w cur.Data,!
				if (cur.LeftChild=""){
					s cur.LeftLinkType=threadFlag
					s cur.LeftChild=previous
				}
				if ((previous'="")&&(previous.RightChild="")){
					s previous.RightLinkType=threadFlag
					s previous.RightChild=cur	
				}
				s previous=cur
				s parent=stack.Peek()
			}
			if (parent) {
				s cur=parent.RightChild
			}else {
				s cur=""
			}
		}
	}
}

//d ##class(DHCWL.MKPIService.Base.Filter).ResovleFilterRule("a:({CTLOC}=1|| {CTLOC.LocDesc}\[ 心内 )",.tree) 

//d ##class(DHCWL.MKPIService.Base.Filter).PostVisitTree("a","1",",",tree("a",1))

Method PostVisitThreadTree(treeHead As DHCWL.util.TreeNode, ByRef dimValueMap) As %Boolean
{
	q:treeHead="" 0
	q:((treeHead.LeftChild="")||(treeHead.RightChild="")) 0
	s linkFlag=treeHead.LinkFlag,threadFlag=treeHead.ThreadFlag
	s cur=treeHead
	s end=treeHead.LeftChild
	s parent="",cur=treeHead.RightChild
	s parent=cur.Parent
	do{
		q:cur=""
		s parent=cur.Parent
		s flag=..Visit(cur,.dimValueMap)
		s cur.LOResult=flag
		;w cur.Data,!
		//此时还可以进一步优化---短路
		if ((1)&&(flag=0)&&(parent)&&(parent.Data="&&")){ //短路
			s parent.LOResult=0
			s cur=parent
			s parent=cur.Parent
		}
		if ((1)&&(flag=1)&&(parent)&&(parent.Data="||")){ //短路
			s parent.LOResult=1
			s cur=parent
			s parent=cur.Parent
		}
		q:cur=""
		if ((cur.RightLinkType=threadFlag)){
			s cur=cur.RightChild
		}elseif ((cur.RightLinkType=linkFlag)&&(parent'="")&&(parent.RightChild=cur)){
			s cur=parent
		}elseif ((parent'="")&&(parent.LeftLinkType=linkFlag)&&(parent.RightLinkType=linkFlag)){
			s cur=parent.RightChild
			while((cur'="")&&(cur.LeftLinkType=linkFlag)||(cur.RightChild=linkFlag)){
				while((cur'="")&&(cur.LeftLinkType=linkFlag)){
					s cur=cur.LeftChild
				}
				if ((cur'="")&&(cur.RightLinkType=linkFlag)) s cur=cur.RightChild
			}
		}
	}while((cur'="")&&(cur.Parent'=""))
	if (cur'=""){
		s flag=..Visit(cur,.dimValueMap)
		s cur.LOResult=flag
		q cur.LOResult
		;w cur.Data,!
	}
	q 0
}

Method Visit(node As DHCWL.util.TreeNode, ByRef dimValueMap) As %Boolean
{
	;k proValDeliFilter
	s LOARR("&&")=2,LOARR("||")=2 ,LOARR("!")=1
	if ( $d( ..RSTNMap(node) ) ){
	}else{
		s flag=..ResovleBaseFilterRule(node)
		q:flag=0 0
	}
	m nodeRSTNMap=..RSTNMap(node)
	
	if (node.Type=2){
		s l=node.LeftChild
		s r=node.RightChild
		s lo=nodeRSTNMap("LO")
		s loR=0,lResult=0,rResult=0
		if (l){
			s lResult=l.LOResult
		}
		if (r){
			s rResult=r.LOResult
		}
		if (LOARR(lo)=1){
			if (lo="!") s lo="'"
			s excStr="s c="_lo_"a"
		}else{
			if (lo="!") s lo="'"
			s excStr="s c=a"_lo_"b"
		}
		s excStr="(a,b,c)  "_excStr
		x (excStr,lResult,rResult,.loR)
		q loR
	}else{
		s loR=0
		q:loR=1
		
		/**
		s ruleArr("U2B",dim,"$OBFlag$")=0
		s ruleArr("U2B",dim,pro,"FILTER")=choiceFilter
		s ruleArr("U2B",dim,pro,"PARAMS")=paraList
		*/
		s udc="" //user dim code
		s udc=$o(nodeRSTNMap("U2B",udc))
		s bdc=nodeRSTNMap("U2B",udc)  // kpi base dim code
		s ff=nodeRSTNMap("U2B",udc,"FILTER") //filter function
		s ffp=nodeRSTNMap("U2B",udc,"PARAMS") //filter function parameters
		s fft=nodeRSTNMap("U2B",udc,"FILTERTYPE")  //filter function type
		if (nodeRSTNMap("U2B",udc,"$OBFlag$")){
			s proVal=dimValueMap(udc)
		}else{
			s pro=nodeRSTNMap("U2B",udc,"PROCODE")
			s proVal=..dimResolver.GetPropertyValue(bdc_"."_pro,dimValueMap(udc))
		}
		s paramLen=$ll(ffp)
		s loR2=0
		s provalueDeliFlag=0
		if paramLen>1 s provalueDeliFlag=1
		f i=1:1:paramLen {
			s parValue=$lg(ffp,i)
			if (fft="INTERNAL") {
				s filterExcStr="s c=(a"_ff_"b)"
			}else {
				s filterExcStr="s c=("_ff_"(a,b))"
			}
			s filterExcStr="(a,b,c)  "_filterExcStr
			;w filterExcStr,!
			x (filterExcStr,proVal,parValue,.loR)
			if (provalueDeliFlag=1){
				s:((loR)&&(loR2=0)) loR2=1
				s loR=0
			}
			s:loR2=1 loR=1
			q:loR=1
		}
		
	}
	q loR
}

Method ResovleBaseFilterRule(ByRef treeNode As DHCWL.util.TreeNode) As %Boolean
{
	k ruleArr
	q:treeNode="" 0
	if (treeNode.Type=2){
		s lo=treeNode.Data
		s ruleArr("LO")=lo
		m ..RSTNMap(treeNode)=ruleArr
		q 1
	}
	
	s filterStr=treeNode.Data
	s filterStr=##class(DHCWL.util.StringUtil).Trim(filterStr,"[")
	s filterStr=##class(DHCWL.util.StringUtil).Trim(filterStr,"]")
	s filterStr=##class(DHCWL.util.StringUtil).EscapeStr(filterStr,"[","\")
	s filterStr2=$zcvt(filterStr,"U")
	s choiceFilter="",ind=0,best=0,bestFilter=""
	s filterStrLen=$L(filterStr2),filterFunStrInd=1
	f i=1:1:filterStrLen {
		if $e(filterStr2,i)="}" {
			s filterFunStrInd=i+1
			q
		}
	}
	s filterStr3=$e(filterStr2,filterFunStrInd,filterStrLen)
	f {
		s choiceFilter=$o(^DHCWL.MKPI.SysFilterFuncI("Code",choiceFilter))  ;$o(^DHCWLMKPIFilterConf("FILTER",choiceFilter))
		q:choiceFilter=""
		s choiceFilter2=##class(DHCWL.util.StringUtil).Trim(choiceFilter)
		if (($l(choiceFilter2)>best)&&($f(filterStr3,choiceFilter2)>0)){
			s best=$l(choiceFilter2),bestFilter=choiceFilter2
			s ind=$f(filterStr3,choiceFilter2)+filterFunStrInd-1
		}
	}
	q:ind=0 0
	s choiceFilter=bestFilter
	s filterId=$o(^DHCWL.MKPI.SysFilterFuncI("Code"," "_choiceFilter,""))
	q:filterId="" 0
	s filterType=$lg(^DHCWL.MKPI.SysFilterFuncD(filterId),3,"")
	s dimPro=$e(filterStr,1,(ind-$l(choiceFilter)-1))
	s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro)
	s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro,"{")
	s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro,"}")
	
	if $f(dimPro,"$")=2	s dimType="secDim"
	
	s params=$e(filterStr,ind,$l(filterStr))
	s params=##class(DHCWL.util.StringUtil).Trim(params)
	if (params="") s params=""
	s dim=$p(dimPro,".",1)
	
	s ruleArr("U2B",dim)=..UDC2KBDC(dim)
	
	s params=##class(DHCWL.util.StringUtil).Trim(params)
	s paraList=$lb()
	s paramLen=$l(params)
	
	s escapteDeli=","
	if ($e(params,paramLen)=")"){	
		f i=paramLen:-1:1 {
			if ($e(params,i)="("){
				while($e(params,i-1)=" "){
					s i=i-1
				}
				if ((i>3)&&($e(params,i-2,i-1)="ES")){	
					s escapteDeli=$e(params,i+1,paramLen-1)
					s params=$e(params,1,i-3)
					q
				}
				q
			}
		}
	}
	s paramLen=$l(params,escapteDeli)
	f i=1:1:paramLen {
		s $li(paraList,i)=$p(params,escapteDeli,i)
	}
	s ruleArr("U2B",dim,"$OBFlag$")=1 //only base dim flag whitch no property given
	s ruleArr("U2B",dim,"FILTER")=choiceFilter
	s ruleArr("U2B",dim,"PARAMS")=paraList
	s ruleArr("U2B",dim,"FILTERTYPE")=filterType
	if ($l(dimPro,".")=2){
		s pro=$p(dimPro,".",2)
		s ruleArr("U2B",dim,"$OBFlag$")=0
		//add by wz.2015-12-1.过滤规则支持维度属性带参数
		s proParams=$p(pro,"\(",2)
		s proParams=$p(proParams,"\)",1)
		if $g(proParams)'="" s ruleArr("U2B",dim,"dimProParams")=proParams
		s ruleArr("U2B",dim,"PROCODE")=pro
	}
	m ..RSTNMap(treeNode)=ruleArr
	q 1
}

}
