Class DHCWL.util.TreeNode Extends %RegisteredObject
{

/// Creator by lhh
/// Date 2013-08-07
/// Desc:过滤表达式的树节点数据结构
Parameter LOType = 2;

Parameter ExpType = 1;

Property LinkFlag As %Integer;

//孩子链接标志

Property ThreadFlag As %Integer;

//线索链接标志

Property Data As %String;

//节点的数据值

Property Type As %Integer;

//节点类型标志？1表达式节点。2逻辑运算符节点。3辅助节点

Property LeftLinkType As %Integer;

//节点链接类型

Property RightLinkType As %Integer;

Property LOResult As %Boolean;

//节点的计算结果

Property LeftChild As DHCWL.util.TreeNode;

//直接右孩子节点

Property RightChild As DHCWL.util.TreeNode;

//直接左孩子节点

Property Parent As DHCWL.util.TreeNode;

//父节点，备短路使用

Property DataArray As %DataType [ MultiDimensional ];

//s node=##class(DHCWL.util.TreeNode).Init("{RegLoc}EqualIgNull",1)

ClassMethod Init(data = "", type As %Integer = 1) As DHCWL.util.TreeNode
{
	s node=##class(DHCWL.util.TreeNode).%New()
	s node.Data=data,node.Type=type
	s node.LeftChild="",node.RightChild="",node.LOResult=-1
	s node.LinkFlag=1,node.ThreadFlag=2,node.Parent=""
	s node.LeftLinkType=node.LinkFlag,node.RightLinkType=node.LinkFlag
	q node
}

//s node=##class(DHCWL.util.TreeNode).Init("{RegLoc}EqualIgNull",1)

//w node.ResovleFilterRule("MZDocGhf",.bb)

/*
 *
 * 原来的代码，先保存。add by wz.2015-1-29
Method ResovleFilterRule(kpi = "", ByRef ruleArr) As %Boolean
{
	k ruleArr
	q:kpi="" 1
	if (..Type=2){ ;%parameter("LOType")){
		s lo=..Data
		s ruleArr(kpi,"LO")=lo
		q 1
	}
	s filterStr=..Data ;"{RegLoc.Loc} = A" ;..Data
	s filterStr=##class(DHCWL.util.StringUtil).Trim(filterStr,"[")
	s filterStr=##class(DHCWL.util.StringUtil).Trim(filterStr,"]")
	s filterStr=##class(DHCWL.util.StringUtil).EscapeStr(filterStr,"[","\")
	s filterStr2=$zcvt(filterStr,"U")
	s choiceFilter="",ind=0,best=0,bestFilter=""
	f {
		s choiceFilter=$o(^DHCWL.MKPI.SysFilterFuncI("Code",choiceFilter))  ;$o(^DHCWLMKPIFilterConf("FILTER",choiceFilter))
		q:choiceFilter=""
		s choiceFilter2=##class(DHCWL.util.StringUtil).Trim(choiceFilter)
		if (($l(choiceFilter2)>best)&&($f(filterStr2,choiceFilter2)>0)){
			s best=$l(choiceFilter2),bestFilter=choiceFilter2
			s ind=$f(filterStr2,choiceFilter2)
		}
	}
	;w "bestFilter="_bestFilter,!
	q:ind=0 0
	s choiceFilter=bestFilter
	s dimPro=$e(filterStr,1,(ind-$l(choiceFilter)-1))
	s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro)
	s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro,"{")
	s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro,"}")
	s params=$e(filterStr,ind,$l(filterStr))
	s params=##class(DHCWL.util.StringUtil).Trim(params)
	if (params="") s params=""
	s dim=$p(dimPro,".",1)
	s kpiDimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpi_"||"_dim,"DHCWL.MKPI.MKPIDimensions")
	q:kpiDimId="" 0
	s kpiDimOrder=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),6,1)
	s tempKpiDimDeli=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),7,",")
	s dimId=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),5)
	q:dimId="" 0
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
	if ($l(dimPro,".")=2){	
		s pro=$p(dimPro,".",2)
		s dimProId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimId_"||"_pro,"DHCWL.MKPI.DimProperty")
		q:dimProId="" 0
		s dimProDeli=$lg(^DHCWL.MKPI.DimPropertyD(dimProId),8,"")
		s ruleArr(kpi,kpiDimOrder,dimProId,"DIMDELI")=tempKpiDimDeli
		s ruleArr(kpi,kpiDimOrder,dimProId,"FILTER")=choiceFilter
		s ruleArr(kpi,kpiDimOrder,dimProId,"PARAMS")=paraList ;params
		s ruleArr(kpi,kpiDimOrder,dimProId,"VALUEDELI")=dimProDeli
	}else{
		s ruleArr(kpi,kpiDimOrder,"NULL","DIMDELI")=tempKpiDimDeli
		s ruleArr(kpi,kpiDimOrder,"NULL","FILTER")=choiceFilter
		s ruleArr(kpi,kpiDimOrder,"NULL","PARAMS")=paraList ;params
		s ruleArr(kpi,kpiDimOrder,"NULL","VALUEDELI")=""
	}
	q 1
}
*/
Method ResovleFilterRule(kpi = "", ByRef ruleArr) As %Boolean
{
	k ruleArr
	q:kpi="" 1
	if (..Type=2){ ;%parameter("LOType")){
		s lo=..Data
		s ruleArr(kpi,"LO")=lo
		q 1
	}
	s dimType="normalDim"		//add by wz.2015-1-29
	
	s filterStr=..Data ;"{RegLoc.Loc} = A" ;..Data
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
	;w "bestFilter="_bestFilter,!
	q:ind=0 0
	s choiceFilter=bestFilter
	s dimPro=$e(filterStr,1,(ind-$l(choiceFilter)-1))
	s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro)
	s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro,"{")
	s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro,"}")
	
	if $f(dimPro,"$")=2	s dimType="secDim"
	
	
	s params=$e(filterStr,ind,$l(filterStr))
	s params=##class(DHCWL.util.StringUtil).Trim(params)
	if (params="") s params=""
	s dim=$p(dimPro,".",1)
	
	if dimType="normalDim" {
		s kpiDimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpi_"||"_dim,"DHCWL.MKPI.MKPIDimensions")
		q:kpiDimId="" 0
		s kpiDimOrder=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),6,1)
		s tempKpiDimDeli=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),7,",")
		s dimId=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),5)
	}elseif dimType="secDim"  {
		s curVer=##class(DHCWL.MKPIService.VersionPath).GetVersion()
		if +$g(curVer)>=4.2 {
			s tmpDim=$p(dim,"$",2)
			s dimId=tmpDim					//4.2版本直接保存编码
			s kpiDimOrder=1
			s tempKpiDimDeli=","	
		}else{
			s tmpDim=$p(dim,"$",2)
			s dimId=##CLASS(DHCWL.MKPI.Section).GetIdByCode(tmpDim)
			s kpiDimOrder=1
			s tempKpiDimDeli=","
		}
	}
	
	q:dimId="" 0
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
	if ($l(dimPro,".")=2){	
		s pro=$p(dimPro,".",2)
		
		//add by wz.2015-1-29
		if dimType="normalDim" {
			//add by wz.2015-12-1.过滤规则支持维度属性带参数
			s newPro=$p(pro,"\(",1)
			s dimProId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimId_"||"_newPro,"DHCWL.MKPI.DimProperty")
			//s dimProId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimId_"||"_pro,"DHCWL.MKPI.DimProperty")
		}elseif dimType="secDim" {
			s curVer=##class(DHCWL.MKPIService.VersionPath).GetVersion()
			if +$g(curVer)>=4.2 {
				s dimProId=pro			//4.2版本直接保存编码
			}else{
				s dimProId=$o(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",dimId,$SYSTEM.SQL.ALPHAUP(pro),""))
			}
		}
		
		q:dimProId="" 0
		
		if dimType="normalDim" s dimProDeli=$lg(^DHCWL.MKPI.DimPropertyD(dimProId),8,"")
		if dimType="secDim" s dimProDeli=""
		s ruleArr(kpi,kpiDimOrder,dimProId,"DIMDELI")=tempKpiDimDeli
		s ruleArr(kpi,kpiDimOrder,dimProId,"FILTER")=choiceFilter
		s ruleArr(kpi,kpiDimOrder,dimProId,"PARAMS")=paraList ;params
		s ruleArr(kpi,kpiDimOrder,dimProId,"VALUEDELI")=dimProDeli
		//add by wz.2015-1-29
		s ruleArr(kpi,kpiDimOrder,dimProId,"dimType")=dimType
		//add by wz.2015-12-1.过滤规则支持维度属性带参数
		s proParams=$p(pro,"\(",2)
		s proParams=$p(proParams,"\)",1)
		if $g(proParams)'="" s ruleArr(kpi,kpiDimOrder,dimProId,"dimProParams")=proParams
	}else{
		s ruleArr(kpi,kpiDimOrder,"NULL","DIMDELI")=tempKpiDimDeli
		s ruleArr(kpi,kpiDimOrder,"NULL","FILTER")=choiceFilter
		s ruleArr(kpi,kpiDimOrder,"NULL","PARAMS")=paraList ;params
		s ruleArr(kpi,kpiDimOrder,"NULL","VALUEDELI")=""
		//add by wz.2015-1-29
		s ruleArr(kpi,kpiDimOrder,"NULL","dimType")=dimType
	}
	q 1
}

}
