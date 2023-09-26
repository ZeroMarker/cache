/// 名称: DHCWL.DataQuery.ServOfQryLineRpt
/// 描述: 行式报表类
/// 编写者：王峥
/// 编写日期:2017-6-23
/// 
Class DHCWL.DataQuery.ServOfQryLineRpt Extends DHCWL.DataQuery.ServOfQry
{

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	得到报表的配置数据，保存到进程global中
/// Table：       	DHCWL.DataQuery.ReportSubCfg
/// Input：         无
/// Output： 		无
/// Return： 		无
/// Others：        其它说明
/// 				
/// 				^||DHCWLTEMP("RPTCFG","DIMCOLORDER",exp)=order
/// 				维度列数据：^||DHCWLTEMP("RPTCFG","DIMCOLORDER",维度.属性)=列序号
/// 				^||DHCWLTEMP("RPTCFG","DIMDESC",exp)=desc
/// 				维度列数据：^||DHCWLTEMP("RPTCFG","DIMDESC",维度.属性)=描述
/// 				^||DHCWLTEMP("RPTCFG","MEASURECOLORDER",exp)=order
/// 				度量列数据：^||DHCWLTEMP("RPTCFG","MEASURECOLORDER",指标编码)=列序号
/// 				^||DHCWLTEMP("RPTCFG","MEASUREAGGREGATE",exp)=isAgg
/// 				度量列数据：^||DHCWLTEMP("RPTCFG","MEASUREAGGREGATE",指标编码)=是否及时合计
/// 				^||DHCWLTEMP("RPTCFG","MEASUREDESC",exp)=desc	
/// 				度量列数据：^||DHCWLTEMP("RPTCFG","MEASUREDESC",指标编码)=描述
/// 				^||DHCWLTEMP("RPTCFG","SEARCHITEM",exp)=value
/// 				查询项数据：^||DHCWLTEMP("RPTCFG","SEARCHITEM",维度.属性)=查询值
Method GetRptCfgData() As %String
{
	s rptCode=..rptCode
	s ret=""
	s rptID=$o(^DHCWL.DataQuery.ReportCfgI("InxCode",rptCode,0))
	q:$g(rptID)=0 "报表: "_rptCode_" 不存在！"
	s newObj=##class(DHCWL.DataQuery.ReportCfg).%OpenId(rptID)
	s ^||DHCWLTEMP("RPTCFG","RPTDESC")=newObj.Descript
	
	s subCode=""
	f {
		s subCode=$o(^DHCWL.DataQuery.ReportSubCfgI("InxRptCodeAndSubCode",rptCode,subCode))
		q:$g(subCode)=""
		s itemID=""
		f {
			s itemID=$o(^DHCWL.DataQuery.ReportSubCfgI("InxRptCodeAndSubCode",rptCode,subCode,itemID))
			q:$g(itemID)=""
			
			s subObj=##class(DHCWL.DataQuery.ReportSubCfg).%OpenId(itemID)
			if subObj.%ClassName()="RptSubDimCfg" {
				s code=subObj.Code
				s order=subObj.Order
				s exp=subObj.Express
				s desc=subObj.Descript
				s ^||DHCWLTEMP("RPTCFG","DIMCOLORDER",exp)=order
				s ^||DHCWLTEMP("RPTCFG","DIMDESC",exp)=desc	
			}elseif subObj.%ClassName()="RptSubMeasureCfg" {
				s code=subObj.Code
				s order=subObj.Order
				s exp=subObj.Express
				s isAgg=subObj.IsAggregate
				s desc=subObj.Descript
				s showFormat=subObj.ShowFormat
				s ^||DHCWLTEMP("RPTCFG","MEASURECOLORDER",exp)=order
				s ^||DHCWLTEMP("RPTCFG","MEASUREAGGREGATE",exp)=isAgg
				s ^||DHCWLTEMP("RPTCFG","MEASUREDESC",exp)=desc	
				s ^||DHCWLTEMP("RPTCFG","MEASURESHOWFORMAT",exp)=showFormat	
							
			}elseif subObj.%ClassName()="RptSubFilterCfg" {
				s exp=subObj.Express
				s ^||DHCWLTEMP("RPTCFG","FILTER")=exp
			}elseif subObj.%ClassName()="RptSubSItemCfg" {
				s exp=subObj.Express
				s value=subObj.Value
				s ^||DHCWLTEMP("RPTCFG","SEARCHITEM",exp)=value
			}
		}
	}
	q ret
}

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	1、记录取数规则中维度属性编码与位置的映射关系
/// 					2、根据配置生成指标取数规则
/// Table：       	
/// Input：         无
/// Output： 		无
/// Return： 		无
/// Others：        其它说明
/// 					^||DHCWLTEMP("DIMPRO",dimCode)=pos
/// 					^||DHCWLTEMP("DIMPRO",维度.属性)=在指标取数规则中的位置				
Method CreateKpiRule() As %String
{
	//^||DHCWLTEMP("RPTCFG","FILTER")=exp
	
	s dimPros=""
	s dimCode=""
	s pos=0
	f {
		s dimCode=$o(^||DHCWLTEMP("RPTCFG","DIMCOLORDER",dimCode))
		q:$g(dimCode)=""
		if dimPros'="" s dimPros=dimPros_"^"_dimCode
		else  s dimPros=dimCode
		s pos=pos+1
		s ^||DHCWLTEMP("DIMPRO",dimCode)=pos
	}	

	
	
	s kpiRule=""
	s kpiCode=""
	f {
		s kpiCode=$o(^||DHCWLTEMP("RPTCFG","MEASURECOLORDER",kpiCode))	
		q:$g(kpiCode)=""
		if kpiRule'="" s kpiRule=kpiRule_","_kpiCode_":"_dimPros
		else  s kpiRule=kpiCode_":"_dimPros
	}
	
	q kpiRule
}

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	查询指标数据
/// Table：       	无
/// Input：         kpiRule：取数规则；startDate, endDate：开始日期，结束日期；filterRule：过滤规则
/// Output： 		无
/// Return： 		无
/// Others：        其它说明
/// 					^||DHCWLTEMP("KPIV",dimDesc,kpiCode)
/// 					^||DHCWLTEMP("KPIV",维度描述,指标编码)=指标值	
Method QryKpiData(kpiRule As %Text, startDate, endDate, choiceType = "freeDateChoice", isRealData = "", filterRule As %Text = "") As %String
{
	s ret=""
	s rs=##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:NewQueryKpiWithContract")
	s dynParam="$startDate="_startDate_",$endDate="_endDate
	
	s startDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(startDate)
	s startDate=$zd(startDate,3)
	s endDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(endDate)
	s endDate=$zd(endDate,3)	

	//d rs.Execute("K0004:CTLOC.LocDesc,K0005:CTLOC.LocDesc,K0008:CTLOC.LocDesc,K0010:CTLOC.LocDesc","2015-03-11","2015-03-31","freeDateChoice",,"K0010:([{$D.DateDesc} =$endDate]),K0004:([{$D.DateDesc} =$startDate])","$startDate=11/03/2015,$endDate=30/03/2015")	
	d rs.Execute(kpiRule,startDate,endDate,choiceType,isRealData,,filterRule,dynParam)
	While(rs.Next()){
		s kpiCode=rs.Data("kpiCode")
		s dimDesc=rs.Data("dimDesc")
		if $g(dimDesc)="" s dimDesc="null"
		s value=rs.Data("value")	
		s ^||DHCWLTEMP("KPIV",dimDesc,kpiCode)=$g(^||DHCWLTEMP("KPIV",dimDesc,kpiCode))+value
	}	
			
	d rs.Close()
	q ret
}

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	根据报表配置，创建过滤规则；过滤规则由用户配置的过滤规则+查询项合并而成
/// Table：       	
/// Input：         无
/// Output： 		无
/// Return： 		指标过滤规则
/// Others：        其它说明
Method CreateFilterRule() As %String
{
	s filterStr=""
	s searchItemStr=""
	s dimPro=""
	/*
	if $d(^||DHCWLTEMP("RPTCFG","SEARCHITEM")) {
		s searchItemStr=""
		
		//根据查询项生成过滤规则
		f {
			s dimPro=$o(^||DHCWLTEMP("RPTCFG","SEARCHITEM",dimPro))
			q:$g(dimPro)=""
			s value=$g(^||DHCWLTEMP("RPTCFG","SEARCHITEM",dimPro))
			continue:value=""
			if searchItemStr="" s searchItemStr="[{"_dimPro_"}="_value_"]"
			else  s searchItemStr=searchItemStr_ " && "_"[{"_dimPro_"}="_value_"]"
		}
	}
	*/
	s searchArgs=..GetSearchArgs()
	if $g(searchArgs)'="" {
		s searchItemStr=""
		s cnt=$l(searchArgs,"separator")
		f i=1:1:cnt {
			s item=$p(searchArgs,"separator",i)
			s dimPro=$p(item,"equal",1)
			s value=$p(item,"equal",2)
			continue:value=""
			if searchItemStr="" s searchItemStr="[{"_dimPro_"}="_value_"]"
			else  s searchItemStr=searchItemStr_ " && "_"[{"_dimPro_"}="_value_"]"
		}
	}	
	
	if searchItemStr'="" {
		
		//将报表的过滤规则按KPI分类，保存到global中
		if $d(^||DHCWLTEMP("RPTCFG","FILTER")) {
			s filterStr=^||DHCWLTEMP("RPTCFG","FILTER")
			s filterStr=$TR(filterStr,"),",")#")
			s len=$l(filterStr,"#")
			f i=1:1:len {
				s kpiF=$p(filterStr,"#",i)
				s kpi=$p(kpiF,":",1)
				s rule=$p(kpiF,":",2)
				s ^||DHCWLTEMP("RPTCFG","KPI:FILTER",kpi)=rule
			}
		}
		
		//遍历每个指标，把报表过滤规则和统计项生成的规则合并成新的过滤规则
		s newKpiRule=""
		s kpiCode=""
		f {
			s kpiCode=$o(^||DHCWLTEMP("RPTCFG","MEASURECOLORDER",kpiCode))
			q:$g(kpiCode)=""
			
			s rule=""
			if $d(^||DHCWLTEMP("RPTCFG","KPI:FILTER",kpiCode)) {
				s rule=^||DHCWLTEMP("RPTCFG","KPI:FILTER",kpiCode)
				s rule=$p(rule,"(",2)
				s rule=$p(rule,")",1)
				s rule="(["_rule_"]"_" && "_ searchItemStr_")"
			}else{
				s rule=	"("_ searchItemStr_")"
			}
			s kRule=kpiCode_":"_rule
			if newKpiRule="" s newKpiRule=kRule
			else  s newKpiRule=newKpiRule_","_kRule
		}
		s filterStr=newKpiRule
	}else{
		if $d(^||DHCWLTEMP("RPTCFG","FILTER")) s filterStr=^||DHCWLTEMP("RPTCFG","FILTER")
	}
	

	q filterStr
}

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	输出数据
/// Table：       	
/// Input：         outputIF：输出接口
/// Output： 		无
/// Return： 		无
/// Others：        其它说明
Method OutputData(outputIF As ServOfOutputIF)
{
	s dimDesc=""
	s rowInx=0
	k sumV
	
	f {
		s dimDesc=$o(^||DHCWLTEMP("KPIV",dimDesc))	
		q:$g(dimDesc)=""
		
		s rowInx=rowInx+1
		
		//维度值
		s dimProCode=""
		f {
			s dimProCode=$o(^||DHCWLTEMP("DIMPRO",dimProCode))
			q:$g(dimProCode)=""
			
			s pos=^||DHCWLTEMP("DIMPRO",dimProCode)
			s cellValue=$p(dimDesc,",",pos)
			s cellDesc=^||DHCWLTEMP("RPTCFG","DIMDESC",dimProCode)
			s colOrder=^||DHCWLTEMP("RPTCFG","DIMCOLORDER",dimProCode)

			k aryOutV
			s aryOutV("rowInx")=rowInx
			s aryOutV("cellDesc")=cellDesc
			s aryOutV("cellOrder")=colOrder
			if cellValue="" s cellValue="null"
			s aryOutV("cellValue")=cellValue
			s aryOutV("cellValueType")="string"
			s aryOutV("colType")="dim"
			//调用输出接口的输出方法输出数据
			d outputIF.DoOutput(.aryOutV)	
		
		}
		
	
		s kpiCode=""
		f {
			s kpiCode=$o(^||DHCWLTEMP("RPTCFG","MEASURECOLORDER",kpiCode))
			q:$g(kpiCode)=""
			
			s cellDesc=^||DHCWLTEMP("RPTCFG","MEASUREDESC",kpiCode)
			s colOrder=^||DHCWLTEMP("RPTCFG","MEASURECOLORDER",kpiCode)
			s IsAggregate=^||DHCWLTEMP("RPTCFG","MEASUREAGGREGATE",kpiCode)
			s showFormat=^||DHCWLTEMP("RPTCFG","MEASURESHOWFORMAT",kpiCode)
			if $d(^||DHCWLTEMP("KPIV",dimDesc,kpiCode)) s cellValue=^||DHCWLTEMP("KPIV",dimDesc,kpiCode)
			else  s cellValue=""
			
			k aryOutV
			s aryOutV("rowInx")=rowInx
			s aryOutV("cellDesc")=cellDesc
			s aryOutV("cellOrder")=colOrder
			s aryOutV("cellValue")=cellValue
			s aryOutV("cellValueType")="number"
			s aryOutV("colIsAggregate")=IsAggregate
			s aryOutV("colType")="measure"
			s aryOutV("showFormat")=showFormat
			//调用输出接口的输出方法输出数据
			d outputIF.DoOutput(.aryOutV)	
			
			
			//合计数据
			/*
			if IsAggregate="是" {
				s sumV("cellValue",cellDesc)=$g(sumV("cellValue",cellDesc))+cellValue
				s sumV("showFormat",cellDesc)=showFormat
				s sumV("cellOrder",cellDesc)=colOrder
				s sumV("colIsAggregate",cellDesc)=IsAggregate
				s sumV("colType",cellDesc)="measure"
				//w !
				//zw sumV
			}
			*/
		
		}				
	}
	
	
	//输出合计
	/*
	if $d(sumV) {
		s cellDesc=""
		f {
			s cellDesc=$o(sumV("cellValue",cellDesc))
			q:cellDesc=""
			k aryOutV
			
			s aryOutV("rowInx")="合计"
			s aryOutV("cellDesc")=cellDesc
			s aryOutV("cellOrder")=sumV("cellOrder",cellDesc)
			s aryOutV("cellValue")=sumV("cellValue",cellDesc)
			s aryOutV("cellValueType")="number"
			s aryOutV("showFormat")=sumV("showFormat",cellDesc)
			s aryOutV("colIsAggregate")=sumV("colIsAggregate",cellDesc)
			s aryOutV("colType")="measure"
						
			d outputIF.DoOutput(.aryOutV)
		}
	}
	*/
	q
}

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	查询统计数据
/// Table：       	无
/// Input：         startDate:统计开始日期;endDate:统计结束日期;oupputIF:输出接口
/// Output： 
/// Return： 
/// Others：        其它说明
Method QryRptStatData(startDate As %String, endDate As %String, outputIF As ServOfOutputIF) As %String
{
	SET $ZTRAP="OnError"
	//1、根据报表编码读取报表配置
	d ..GetRptCfgData()
	//2、生成kpirule,filterrule
	s kpiRule=..CreateKpiRule()
	//3、生成过滤规则filterRule
	s kpiFilter=..CreateFilterRule()
	//4、取指标数据
	s ret=..QryKpiData(kpiRule,startDate,endDate,,,kpiFilter)
	//5、输出数据
	d ..OutputData(outputIF)
	
	q ""
OnError
	s ret="查询统计数据时发生错误:"_$ZERROR
	q ret
}

}
