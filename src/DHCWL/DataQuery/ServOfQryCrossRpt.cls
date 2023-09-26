/// 名称: DHCWL.DataQuery.ServOfQryCrossRpt
/// 描述: 交叉报表类
/// 编写者：王峥
/// 编写日期:2017-6-23
Class DHCWL.DataQuery.ServOfQryCrossRpt Extends DHCWL.DataQuery.ServOfQry
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
				s order=subObj.Order
				s exp=subObj.Express
				s desc=subObj.Descript
				
				s type=subObj.Type
				s typeOrder=$ZCONVERT(type,"U")_"ORDER"
				
				//s ^||DHCWLTEMP("RPTCFG","DIM",typeOrder,exp)=order
				//s ^||DHCWLTEMP("RPTCFG","DIM",exp,typeOrder)=order
				s ^||DHCWLTEMP("RPTCFG","DIM","ORDER",exp,typeOrder)=order
				s ^||DHCWLTEMP("RPTCFG","DIM","DESC",exp)=desc
					
			}elseif subObj.%ClassName()="RptSubMeasureCfg" {
				s order=subObj.Order
				s exp=subObj.Express
				s desc=subObj.Descript
				s showFormat=subObj.ShowFormat

				s ^||DHCWLTEMP("RPTCFG","MEASURE","ORDER",exp)=order
				s ^||DHCWLTEMP("RPTCFG","MEASURE","DESC",exp)=desc	
				s ^||DHCWLTEMP("RPTCFG","MEASURE","SHOWFORMAT",exp)=showFormat	
							
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
	s typeOrder=""
	s pos=0

	s exp=""
	f {
		s exp=$o(^||DHCWLTEMP("RPTCFG","DIM","ORDER",exp))
		q:$g(exp)=""
		
		if dimPros'="" s dimPros=dimPros_"^"_exp
		else  s dimPros=exp
		s pos=pos+1
		s ^||DHCWLTEMP("DIMPRO",exp)=pos
	}

	
	s kpiRule=""
	s kpiCode=""
	s exp=""
	f {
		s exp=$o(^||DHCWLTEMP("RPTCFG","MEASURE","ORDER",exp))
		q:$g(exp)=""
		if kpiRule'="" s kpiRule=kpiRule_","_exp_":"_dimPros
		else  s kpiRule=exp_":"_dimPros		
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
	}*/
	s searchArgs=..GetSearchArgs()
	if $g(searchArgs)'="" {
		s searchItemStr=""
		s cnt=$l(searchArgs,"separator")
		f i=1:1:cnt {
			s item=$p(searchArgs,i)
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
	f {
		s dimDesc=$o(^||DHCWLTEMP("KPIV",dimDesc))	
		q:$g(dimDesc)=""
		
		k aryOutV
		//维度值
		s dimProCode=""
		f {
			s dimProCode=$o(^||DHCWLTEMP("DIMPRO",dimProCode))
			q:$g(dimProCode)=""
			
			s pos=^||DHCWLTEMP("DIMPRO",dimProCode)
			s value=$p(dimDesc,",",pos)
			
			s typeOrder=$o(^||DHCWLTEMP("RPTCFG","DIM","ORDER",dimProCode,""))
			s order=$g(^||DHCWLTEMP("RPTCFG","DIM","ORDER",dimProCode,typeOrder))

			s aryOutV(typeOrder,order,"desc")=$g(^||DHCWLTEMP("RPTCFG","DIM","DESC",dimProCode))
			if aryOutV(typeOrder,order,"desc")="" s aryOutV(typeOrder,order,"desc")="null"
			//b:aryOutV(typeOrder,order,"desc")="null"
			if value="" {
				s value="null"
				//b:typeOrder="COLORDER"
			}
			s aryOutV(typeOrder,order,"value")=value
		}
		
		s typeOrder="MEASUREORDER"
		s kpiCode=""
		f {
			s kpiCode=$o(^||DHCWLTEMP("RPTCFG","MEASURE","ORDER",kpiCode))
			q:$g(kpiCode)=""
			
			s order=^||DHCWLTEMP("RPTCFG","MEASURE","ORDER",kpiCode)
			s desc=^||DHCWLTEMP("RPTCFG","MEASURE","DESC",kpiCode)
			s showFormat=^||DHCWLTEMP("RPTCFG","MEASURE","SHOWFORMAT",kpiCode)
			if $d(^||DHCWLTEMP("KPIV",dimDesc,kpiCode)) s value=^||DHCWLTEMP("KPIV",dimDesc,kpiCode)
			else  s value=""
			
			s aryOutV(typeOrder,order,"desc")=desc
			s aryOutV(typeOrder,order,"value")=value
			s aryOutV(typeOrder,order,"showFormat")=showFormat			
			//调用输出接口的输出方法输出数据
			d outputIF.DoOutput(.aryOutV)
			k aryOutV(typeOrder,order)	
			//k aryOutV(typeOrder,order,"desc")
			//k aryOutV(typeOrder,order,"value")
			//k aryOutV(typeOrder,order,"showFormat")		
			
		}				
	}
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
