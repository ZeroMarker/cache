/// 名称: DHCWL.CSPService.calService
/// 描述: 计算指标服务类，供kpicalrelatcfg.csp调用
/// 编写者：王峥
/// 编写日期:2015-02-26
Class DHCWL.CSPService.calService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      王峥
/// CreatDate：    2015-2-26
/// Description:：   检查用户前台页面配置的运算关系，汇总维度是否合法
/// Table：       	DHCWL_MKPI.DHCWLMKPIDim
/// Input：          kpiID：计算指标的ID
/// 					sumDim:汇总维护
/// 					calExp:运算关系
/// 					retTip:返回给前台页面的提示信息。
/// Output：         
/// Return：         1：合法；0：非法
/// Others：        w ##class(DHCWL.CSPService.calService).CheckSumDim(3951,"K0694,K0693","<K0694>+<K0693>")
ClassMethod CheckSumDim(kpiID As %String, sumDim As %String, calExp As %String, ByRef retTip) As %Integer
{
	n (kpiID, sumDim,calExp,retTip)
	s ret=1
	s retTip="ok"
	s mkpiDimInx=1
	s order=""
	//1、得到计算指标的基础维度
	f {
		s order=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",kpiID,order))
		q:order=""
		s mkpiDimID=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",kpiID,order,""))
		q:mkpiDimID=""
		s mkpiDimDimDr = $lg(^DHCWL.MKPI.MKPIDimensionsD(mkpiDimID),5)
		if $d(mkpiDimDimDr)="" {
			s retTip="打开ID为："_mkpiDimID_"的DHCWL.MKPI.MKPIDimensions对象错误！"
			s ret=0
			q
		}else{
			s aryMkpiDim(mkpiDimInx)=mkpiDimDimDr
			s mkpiDimInx=mkpiDimInx+1
		}
	}
	
	q:ret=0 ret
	
	if (mkpiDimInx=1){
		if (($g(sumDim)'="")||($g(calExp)'="")){
			s retTip="该指标没有维护维度,计算规则表达式保存失败"
			s ret=0
			q ret
		}
	}
	
	//2、检查汇总维度的设置是否与计算指标的基础维度对应
	s mkpiDimCnt=mkpiDimInx-1
	if (mkpiDimCnt>0){
		if ($l($g(sumDim))=0){
			s retTip="当前计算维度没有配置,请先维护维度"
			s ret=0
			q ret
		}
	}
	if ($g(sumDim)=""){
		s kpiNum=0
	}else{
		s kpiNum=$l(sumDim,",")	
	}
	f i=1:1:kpiNum {
		s sDim=$p(sumDim,",",i)
		s relKpiCode=$p(sDim,":",1)
		s arySumKpi(relKpiCode)=""
		s kpiID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(relKpiCode,"DHCWL.MKPI.MKPI")
		if $g(kpiID)="" {
			s retTip="指标："_relKpiCode_"配置的汇总维度的格式错误！"
			s ret=0
			q			
		}
		
		s dims=$p(sDim,":",2)
		if ($g(dims)=""){
			s retTip="指标："_relKpiCode_"没有配置可计算的维度"
			s ret=0
			q
		}
		s dimLen=$l(dims,"^")
		
		if mkpiDimCnt'=dimLen {
			s retTip="指标："_relKpiCode_"配置的汇总维度的个数与计算指标维度的个数不一致！"
			s ret=0
			q			
		}
		
		f j=1:1:dimLen {
			s dim=$p(dims,"^",j)
			s alpDimCode=$SYSTEM.SQL.ALPHAUP(dim)
			s kpiDimID=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiID,alpDimCode,""))	
			i $g(kpiDimID)="" {
				s retTip="在："_sDim_"中，维度："_dim_"不存在！"
				s ret=0
				q			
			}
			s dimDimDr=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimID),5)
			if aryMkpiDim(j)'=dimDimDr {
				s retTip="在："_sDim_"中，第"_j_"个维度的基础维度与计算指标的基础维度不一致！"
				s ret=0
				q			
			}
		}
		
		q:ret=0
	}
	
	q:ret=0 ret
	//3、检查运算关系中的指标是否设置了汇总维度
	s tCalExp=calExp
	s lstExp=$LFS(tCalExp,">")
	s lstExpLen=$ll(lstExp)
	f lstInx=1:1:lstExpLen {
		s relKpiCode=$lg(lstExp,lstInx,"")
		s relKpiCode=$p(relKpiCode,"<",2)
		q:relKpiCode=""
		if '$d(arySumKpi(relKpiCode)) {
			s retTip="指标："_relKpiCode_"未配置汇总维度！"
			s ret=0
			q			
			
		}
	}
	q ret
}

ClassMethod getCalPrtor(ByRef calPrtor)
{
	k calPrtor
	k aryPrtor
	s kpiCode=""
	f {
		s kpiCode=$o(^DHCWL.MKPI.CalExpDefI("KPICODE",kpiCode))
		q:kpiCode=""
		s ID=$o(^DHCWL.MKPI.CalExpDefI("KPICODE",kpiCode,""))
		continue:ID=""
		s calExp=$lg(^DHCWL.MKPI.CalExpDefD(ID),2)
		continue:calExp=""
		
		k str
		f i=1:1:$l(calExp,">") {
			s mStr=$p(calExp,">",i)
			q:$g(mStr)=""
			s str(i)=mStr
		}
		q:'$d(str) 

		s j=0 
		f  {
			s j=$o(str(j))
			q:j=""  
			s code=$p($g(str(j)),"<",2)
			i $g(code)'="" {
				s aryPrtor(code,kpiCode)=0
			}

		}
	
	}
	
	s code=""
	f {
		s code=$o(aryPrtor(code))
		q:code=""
		s kpiCode=""
		f {
			s kpiCode=$o(aryPrtor(code,kpiCode))
			q:kpiCode=""
			if $d(calPrtor(code)) s calPrtor(code)=calPrtor(code)_","
			s calPrtor(code)=$g(calPrtor(code))_kpiCode
		}	
		
	}
}

}
