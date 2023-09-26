Class DHCWL.MKPIService.KpiFilter Extends %RegisteredObject [ Not ProcedureBlock ]
{

//d ##class(DHCWL.MKPIService.KpiFilter).ResovleFilterRule("MZDocGhf:([[{RegLoc.Loc} \[ '(西院)' && {RegLoc.Loc}\[ '内科' ] ||{RegLoc.Loc}='LHH']&& {RegDoc.Doc}'='郑光荣'),MZDocZcf:([[{RegLoc.Loc} \[ '(西院)' &&{RegLoc.Loc} \[ '内科' ] ||{RegLoc.Loc}='LHH'])",.arr)

//d ##class(DHCWL.MKPIService.KpiFilter).ResovleFilterRule("MZDocGhf:([[{RegLoc.Loc}\[ 内科]&&[{RegLoc.Loc}\[西院]])",.arr)

/// Creator by lhh
/// Date 2013-08-07
ClassMethod ResovleFilterRule(filterRule As %Text, ByRef kpiFilterTree)
{
	//b
	n (filterRule,kpiFilterTree)
	q:filterRule=""
	k ^||TEMPDHCWLKPIDATA("ResolvedNodeSession",$j)
	s stack=##class(DHCWL.util.Stack).Init()
	s kpiDeli=":",kpiFilterS="(",kpiFilterE=")",kpiStartInd=1,kpiEndInd=0,kpiSDeli=",",filterStartInd=0,filterEndInd=0
	s len=$l(filterRule)
	k kpiFilterTree
	for i=1:1:len {
		s curChar=$e(filterRule,i)
		if ((curChar=kpiDeli)&&(stack.Size()=0)){
			s kpiEndInd=i-1
			s kpi=$e(filterRule,kpiStartInd,kpiEndInd)
			s kpi=##class(DHCWL.util.StringUtil).Trim(kpi)
		}elseif (curChar=kpiFilterS){
			if (stack.Size()=0) s filterStartInd=i+1
			d stack.Push(curChar)
		}elseif (curChar=kpiFilterE){
			d stack.Pop()
			if (stack.Size()=0){
				s filterEndInd=i-1
				s kpiFilterTree(kpi,"IND")=$i(kpiFilterTree(kpi,"IND"))
				s filterStr=##class(DHCWL.util.StringUtil).Trim($e(filterRule,filterStartInd,filterEndInd))
				s tree=..BuildTree(kpi,filterStr)
				s threadTree=..PostThreadingBuildTree(tree)
				;s kpiFilterTree(kpi,kpiFilterTree(kpi,"IND"))=tree
				s kpiFilterTree(kpi,kpiFilterTree(kpi,"IND"))=threadTree //..BuildTree(kpi,filterStr)
				;b ;002
			}
			
		}elseif ((curChar=kpiSDeli)&&(stack.Size()=0)){
			s kpiStartInd=i+1
		}
	}
}

/// Creator by wk
/// Date 2016-01-03
ClassMethod handleFilterParam(filterRule, dynParams)
{
	n (filterRule,dynParams)
	q:filterRule="" ""
	q:dynParams="" filterRule
	s dynParamLen=$l(dynParams,"$")
	for i=2:1:dynParamLen{
		s dynParam=$p(dynParams,"$",i)
		continue:dynParam=""
		s len=$l(dynParam)
		s sign=$Extract(dynParam,len)
		if (sign=","){
			s dynParam=$Extract(dynParam,1,len-1)
		}
		s param=$p(dynParam,"=",1)
		continue:param=""
		s param="$"_param
		s value=$p(dynParam,"=",2)
		s filterRule=##class(DHCWL.util.StringUtil).ReplaceStr(filterRule,param,value)
	}
	q filterRule
}

//s tree=##class(DHCWL.MKPIService.KpiFilter).BuildTree("kpi","[[{RegLoc.Loc} \[ '(西院)' && {RegLoc.Loc}\[ '内科' ] ||{RegLoc.Loc}='LHH']&& {RegDoc.Doc}'='郑光荣'")

//s threadTree=##class(DHCWL.MKPIService.KpiFilter).PostThreadingBuildTree(.tree)

//d ##class(DHCWL.MKPIService.KpiFilter).PostVisitThreadTree("",,,threadTree)

//d ##class(DHCWL.MKPIService.KpiFilter).VisitDG(tree)

//d ##class(DHCWL.MKPIService.KpiFilter).PostVisitTree("MZDocGhf:([[{RegLoc.Loc} \[ '(西院)' && {RegLoc.Loc}\[ '内科' ] ||{RegLoc.Loc}='LHH']&& {RegDoc.Doc}'='郑光荣'),MZDocZcf:([[{RegLoc.Loc} \[ '(西院)' &&{RegLoc.Loc} \[ '内科' ] ||{RegLoc.Loc}='LHH'])")

//根据表达式，形成具有运算优先级的语法树，形成该树后，我们只需要后序遍历语法树就可以根据优先级计算出该表达式的值

ClassMethod BuildTree(kpi, data = "") As DHCWL.util.TreeNode
{
	n (data,kpi)
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
	s leftNode=..BuildTree(kpi,left)
	s loNode.LeftChild=leftNode
	s rightNode=..BuildTree(kpi,right)
	s loNode.RightChild=rightNode
	if (leftNode'=""){
		s leftNode.Parent=loNode	
	}
	if (rightNode'=""){
		s rightNode.Parent=loNode	
	}
	q loNode
}

//d ##class(DHCWL.MKPIService.KpiFilter).PostVisitTree("dim1.pro1.filter1(aa)&&((dim1.pro2.filter2(b)||dim1.pro3.filter3(c))&&dim2.pro1.filter1(d)||(dim2.pro2.filter2(e)&&dim2.pro3.filter3(f)))")

//ByRef tree As DHCWL.util.TreeNode)

ClassMethod PostVisitTree(kpi, kpiDataRowId = "", dims = "", tree As DHCWL.util.TreeNode, onlyResovledProVal As %Boolean = 0, monId = "") As %Boolean
{
	n (kpi,kpiDataRowId,dims,tree,onlyResovledProVal,monId)
	;q ..PostVisitTreeNoThread(kpi,kpiDataRowId,dims,tree,onlyResovledProVal)
	q ##class(DHCWL.MKPIService.KpiFilter).PostVisitThreadTree(kpi,kpiDataRowId,dims,tree,onlyResovledProVal,monId)
}

//后序遍历语法树（非线索化的），并调用计算函数。为了性能考虑，不采用递归遍历

ClassMethod PostVisitTreeNoThread(kpi, kpiDataRowId = "", dims = "", tree As DHCWL.util.TreeNode, onlyResovledProVal As %Boolean = 0) As %Boolean
{
	n (kpi,kpiDataRowId,dims,tree,onlyResovledProVal)
 ;k proValDeliFilter
 ;s tree=..BuildTree(data)
 q:tree="" 0
 s stack=##class(DHCWL.util.Stack).Init()
 d stack.Push(tree)
 s pre=tree.LeftChild,parent=""
 s shortFlag=0
 while((stack.Size()>0)){
 while ((pre)&&(pre.LeftChild)){
 d stack.Push(pre)
 s parent=pre
 s pre=pre.LeftChild
 }
 if ((pre)&&(pre.RightChild)){
 s parent=pre
 d stack.Push(pre)
 s pre=pre.RightChild
 }else{
 s:pre flag= ..Visit(kpi,kpiDataRowId,dims,pre,onlyResovledProVal)
 s parent=stack.Peek()
 s:pre pre.LOResult=flag
 if ((1)&&(pre)&&(flag=0)&&(parent)&&(parent.Data="&&")){ //短路
 s parent.LOResult=0
 s pre=stack.Pop() ;parent
 s parent=stack.Peek()
 }
 if ((1)&&(pre)&&(flag=1)&&(parent)&&(parent.Data="||")){ //短路
 s parent.LOResult=1
 s pre=stack.Pop() ;parent
 s parent=stack.Peek()
 }
 while ((stack.Size()>0)&&(parent.RightChild=pre)){
 s pre=stack.Pop()
 ;w pre.Data,!
 s flag=..Visit(kpi,kpiDataRowId,dims,pre,onlyResovledProVal)
 s pre.LOResult=flag
 s parent=stack.Peek()
 if ((1)&&(flag=0)&&(parent)&&(parent.Data="&&")){ //短路
 s parent.LOResult=0
 s pre=stack.Pop() ;parent
 s parent=stack.Peek()
 }
 if ((1)&&(flag=1)&&(parent)&&(parent.Data="||")){ //短路
 s parent.LOResult=1
 s pre=stack.Pop() ;parent
 s parent=stack.Peek()
 }
 }
 if (parent) {
 s pre=parent.RightChild
 }else {
 s pre=""
 }
 }
 s shortFlag=0
 }
 q tree.LOResult
}

//added by lhh@20131121

//改进后的算法

ClassMethod PostVisitThreadTree(kpi, kpiDataRowId = "", dims = "", treeHead As DHCWL.util.TreeNode, onlyResovledProVal As %Boolean = 0, monId = "") As %Boolean
{
	n (kpi,kpiDataRowId,dims,treeHead,onlyResovledProVal,monId)
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
		s flag=..Visit(kpi,kpiDataRowId,dims,cur,onlyResovledProVal,monId)
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
		s flag=..Visit(kpi,kpiDataRowId,dims,cur,onlyResovledProVal,monId)
		s cur.LOResult=flag
		q cur.LOResult
		;w cur.Data,!
	}
	q 0
}

//added by lhh@20131121

//构建线索，返回构建结果

ClassMethod PostThreadingBuildTree(ByRef tree As DHCWL.util.TreeNode = "") As DHCWL.util.TreeNode
{
	n (tree)
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
ClassMethod PostThreadingPri(tree As DHCWL.util.TreeNode = "")
{
	n (tree)
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

//d ##class(DHCWL.MKPIService.KpiFilter).Test()

ClassMethod Test()
{
	s tree=##class(DHCWL.MKPIService.KpiFilter).BuildTree("kpi","{RecLocSubGrp}=14||63&&{AdmReason}=3&&{Loc}=13||15&&16")  //"[[{RegLoc.Loc} \[ '(西院)' && {RegLoc.Loc}\[ '内科' ] ||{RegLoc.Loc}='LHH']&& {RegDoc.Doc}'='郑光荣'")
	w "digui",!
	d ..VisitDG(tree)
	q
	w "fie digui",!
	d ##class(DHCWL.MKPIService.KpiFilter).PostVisitTreeNoThread("",,,threadTree)
	w "thread",!
	s threadTree=##class(DHCWL.MKPIService.KpiFilter).PostThreadingBuildTree(.tree)
	
	;b ;00
	;d ##class(DHCWL.MKPIService.KpiFilter).PostVisitThreadTree("",,,threadTree)
}

ClassMethod VisitDG(node As DHCWL.util.TreeNode)
{
	q:node=""
	d ..VisitDG(node.LeftChild)
	d ..VisitDG(node.RightChild)
	w node.Data,!
}

ClassMethod Visit(kpi, kpiDataRowId = "", dims = "", node As DHCWL.util.TreeNode, onlyResovledProVal As %Boolean = 0, monId = "") As %Boolean
{
	n (kpi,kpiDataRowId,dims,node,onlyResovledProVal,monId)
	;k proValDeliFilter
	s LOARR("&&")=2,LOARR("||")=2 ,LOARR("!")=1
	if (($d(^||TEMPDHCWLKPIDATA("ResolvedNodeSession",$j,node)))){
		m dimProArr=^||TEMPDHCWLKPIDATA("ResolvedNodeSession",$j,node_"")
	}else{
		s flag=node.ResovleFilterRule(kpi,.dimProArr)
		if flag=0 q 1
		m ^||TEMPDHCWLKPIDATA("ResolvedNodeSession",$j,node)=dimProArr
	}
	if (node.Type=2){
		s l=node.LeftChild
		s r=node.RightChild
		s lo=dimProArr(kpi,"LO")
		s loR=0,lResult=0,rResult=0
		if (l){
			s lResult=l.LOResult
		}
		if (r){
			s rResult=r.LOResult
		}
		if (LOARR(lo)=1){
			if (lo="!") s lo="'"
			s excStr="s loR="_lo_"rResult" ;_rResult
		}else{
			if (lo="!") s lo="'"
			s excStr="s loR=lResult"_lo_"rResult" ;"s loR="_lResult_" "_lo_" "_rResult
		}
		x excStr
		q loR
	}else{
		k paramArr
		if ((kpiDataRowId)&&(onlyResovledProVal'=1)){ //历史数据
			s dimsId=$lg(^DHCWL.MKPI.DeptKPIData(kpiDataRowId),2,"")
		}else{	//实时数据直接传入维度串
			s dimsId=dims
		}
		s loR=0
		s order="" 
		f {
			s order=$o(dimProArr(kpi,order))
			q:((order=""))  ;||((onlyResovledProVal)&&(loR)))
			q:loR=1
			s proId="" 
			f {
				s proId=$o(dimProArr(kpi,order,proId))
				q:((proId=""))  ;||((onlyResovledProVal)&&(loR)))
				q:loR=1
				s deli=dimProArr(kpi,order,proId,"DIMDELI")
				s filter=dimProArr(kpi,order,proId,"FILTER")
				
				s dimType=dimProArr(kpi,order,proId,"dimType")	//add by wz 2015-1-29
				
				;s filter=^DHCWLMKPIFilterConf("FILTER",filter,filterType)
				s filterId=$o(^DHCWL.MKPI.SysFilterFuncI("Code"," "_filter,""))
				continue:'$d(^DHCWL.MKPI.SysFilterFuncD(filterId))
				s filter=$lg(^DHCWL.MKPI.SysFilterFuncD(filterId),4,"")
				s filterType=$lg(^DHCWL.MKPI.SysFilterFuncD(filterId),3,"")
				s paramList=dimProArr(kpi,order,proId,"PARAMS")
				s paramLen=$ll(paramList)
				k paramArr
				if ((paramLen="")||(paramLen=0)){
					s paramArr(1)=""
				}else{
					f i=1:1:paramLen {
						s paramArr(i)=$lg(paramList,i)
					}
				}
				
				if dimType="normalDim" {
					s dimId=$p(dimsId,deli,order),needResolveProFlag=0
					if ((onlyResovledProVal)&&(dimId="")){
						s dimId=$p(kpiDataRowId,deli,order),needResolveProFlag=1
					}
					s dimDes="",loR=""
					if (((needResolveProFlag=1)||('onlyResovledProVal))&&(proId'="NULL")) {
						s proExc=$lg(^DHCWL.MKPI.DimPropertyD(proId),6,"")
						if (proExc=""){
							s dimDes=""
						}else{
							s excStr="s dimDes=$$"_proExc_"(dimId)"
							//add by wz 2015-12-1.过滤规则支持维度属性带参数
							if $d(dimProArr(kpi,order,proId,"dimProParams")) {
								s proParams=dimProArr(kpi,order,proId,"dimProParams")
								s proE=dimId_"~"_proParams
								s excStr="s dimDes=$$"_proExc_"(proE)"
								
							}
							x excStr
						}
					}else{
						s dimDes=dimId
					}
				}elseif dimType="secDim" {	//moidfy by wz.2015-1-29
					//s dimId=$p(dimsId,deli,order),needResolveProFlag=0
					//if ((onlyResovledProVal)&&(dimId="")){
					//	s dimId=$p(kpiDataRowId,deli,order),needResolveProFlag=1
					//}
					s dimDes="",loR=""
					if (('onlyResovledProVal) &&(proId'="NULL")) {
						s curVer=##class(DHCWL.MKPIService.VersionPath).GetVersion()
						if +$g(curVer)>=4.2 {
							s proCode=proId
							s secID=$lg(^DHCWL.MKPI.MonthsD(monId),11)
							s secProID=$o(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",secID,$SYSTEM.SQL.ALPHAUP(proCode),""))
							s proExc=$lg(^DHCWL.MKPI.SectionPropertyD(secProID),5,"")
							if (proExc=""){
								s dimDes=""
							}else{
								s excStr="s dimDes=$$"_proExc_"(monId)"
								x excStr
							}
						}else{
							s proExc=$lg(^DHCWL.MKPI.SectionPropertyD(proId),5,"")
							if (proExc=""){
								s dimDes=""
							}else{
								s excStr="s dimDes=$$"_proExc_"(monId)"
								x excStr
							}
						}
					}else{
						s dimDes=monId
					}
				}
				
				
				
				if ((onlyResovledProVal=1)&&(proId="NULL")) {
					s loR=1
					q
				}
				s proValueDeli=dimProArr(kpi,order,proId,"VALUEDELI")
				k proValueArr
				s provalueDeliFlag=0
				if ((proValueDeli'="")&&(proValueDeli'=$c(0))){
					f proValueInd=$l(dimDes,proValueDeli):-1:1 {
						s proValueArr(proValueInd)=$p(dimDes,proValueDeli,proValueInd),provalueDeliFlag=1
					}
				}else{
					s proValueArr(1)=dimDes
				}
				s loR2=0,proValueInd=""
				f {
					s proValueInd=$o(proValueArr(proValueInd))
					q:((proValueInd=""))
					q:loR=1
					s paraInd=""
					f {
						s paraInd=$o(paramArr(paraInd))
						q:((paraInd="")) ;||(loR=1))
						if (filterType="INTERNAL") {
							s filterExcStr="s loR=(proValueArr(proValueInd)"_filter_"paramArr(paraInd))" ;"s loR="""_proValueArr(proValueInd)_""" "_filter_" "_paramArr(paraInd)
						}elseif (filterType="CUSTOM"){
							s filterExcStr="s loR=("_filter_"(proValueArr(proValueInd),paramArr(paraInd)))"  ;"s loR="_filter_"("""_proValueArr(proValueInd)_""","_paramArr(paraInd)_")"
						}
						;w "proValueArr(proValueInd)="_proValueArr(proValueInd),!
						;w "paramArr(paraInd)="_paramArr(paraInd),!
						;if +proValueArr(proValueInd)=137 b ;001
						x filterExcStr
						if (provalueDeliFlag=1){
							;s theProValue=proValueArr(proValueInd)
							;s:theProValue="" theProValue="NULL"
							s:((loR)&&(loR2=0)) loR2=1
							s loR=0
						}
						s:loR2=1 loR=1
						q:loR=1
					}
				}
			}
		}
	}
	q loR
}

}
