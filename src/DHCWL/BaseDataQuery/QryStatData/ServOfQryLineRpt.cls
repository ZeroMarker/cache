Class DHCWL.BaseDataQuery.QryStatData.ServOfQryLineRpt Extends DHCWL.BaseDataQuery.QryStatData.ServOfQry
{

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	查询统计数据
/// Table：       	无
/// Input：         startDate:统计开始日期;endDate:统计结束日期;oupputIF:输出接口
/// Output： 
/// Return： 
/// Others：        其它说明
Method QryRptStatData(startDate As %String, endDate As %String, outputIF As ServOfOutputIF, ByRef inParam) As %String
{
	//SET $ZTRAP="OnError"
	
	//1、读取报表配置
	d ..GetRptCfgData(.inParam)

	//2、根据报表名称创建一个查询引擎对象
	s engineObj=##class(DHCWL.BaseDataQuery.QryStatData.FactoryOfEngIne).creator()
	q:'$ISOBJECT($g(engineObj)) $$$OK


	//4、取指标数据
	s ret=..QryTableData(startDate,endDate,engineObj,outputIF)
	//5、输出数据
	d ..OutputData(outputIF)
	
	q ""
OnError
	s ret="查询统计数据时发生错误:"_$ZERROR
	q ret
}

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
Method GetRptCfgData(ByRef inParam) As %String
{
	
	if inParam("loadCfgFrom")="savedCfg" {
		//从报表文件取配置
		s ret=""
		s rptName=inParam("rptName")
		s rptID=$o(^DHCWL.BaseDataQuery.ReportCfgI("InxName",rptName,""))
		s ..rptID=rptID
		s newObj=##class(DHCWL.BaseDataQuery.ReportCfg).%OpenId(..rptID)
		s ^||DHCWLTEMP("RPTCFG","BaseObjName")=newObj.BaseObjName /// 查询对象名称
		s ^||DHCWLTEMP("RPTCFG","Name")=newObj.Name /// 报表名称
		s ^||DHCWLTEMP("RPTCFG","DateItemName")=newObj.DateItemName /// 日期统计项
		s ^||DHCWLTEMP("RPTCFG","Type")=newObj.Type	/// 类型：grpRpt:网格/分组;crossRpt:交叉
		s ^||DHCWLTEMP("RPTCFG","IsAggregat")=newObj.IsAggregat /// 是否聚合
		s ^||DHCWLTEMP("RPTCFG","Remarks")=newObj.Remarks

		s item=""
		f {
			s item=$o(^DHCWL.BaseDataQuery.RptCfgSubI("InxRptNameItem",..rptID,item))
			q:$g(item)=""
			s subID=""
			f {
				s subID=$o(^DHCWL.BaseDataQuery.RptCfgSubI("InxRptNameItem",..rptID,item,subID))
				q:$g(subID)=""
			
				s subObj=##class(DHCWL.BaseDataQuery.ReportCfgSub).%OpenId(subID)	
				s fieldName=$p(subObj.Item,"->",1)
				s fieldName=$p(fieldName,"(",1)
				s proExc=""
				s proParam=""
			
				s itemID=$o(^DHCWL.BaseDataQuery.ItemI("QueryObjNameIndex",newObj.BaseObjName,fieldName,0))
				s type=$lg(^DHCWL.BaseDataQuery.ItemD(itemID),5)
				if $p(subObj.Item,"->",2)'="" {
					s ProInfo=$p(subObj.Item,"->",2)
					s ProInfo=$p(ProInfo,"^=^",1)
					s proCode=$p(ProInfo,"(",1)
					s dimCode=$lg(^DHCWL.BaseDataQuery.ItemD(itemID),7)
					s dimType=$lg(^DHCWL.BaseDataQuery.ItemD(itemID),6)

					s proExc=..getPropertyExc(newObj.BaseObjName,dimType,dimCode,proCode)
					s proParam=$p(ProInfo,"(",2)
					s proParam=$p(proParam,")",1)
				}
			
				if subObj.Type="col" {
					s ^||DHCWLTEMP("RPTItem","colItem",item,"order")=$g(^||DHCWLTEMP("RPTItem","colItem",item,"order"))+1
					s ^||DHCWLTEMP("RPTItem","colItem",item,"fieldName")=fieldName
					s ^||DHCWLTEMP("RPTItem","colItem",item,"dimProExc")=proExc	
					s ^||DHCWLTEMP("RPTItem","colItem",item,"dimproParam")=proParam	
					s ^||DHCWLTEMP("RPTItem","colItem",item,"type")=type
				} 
				if subObj.Type="filter" {
					s filterStr=$p(subObj.Item,"->",2)
					s filterV=$p(filterStr,"^",3)
					s filterOp=$p(filterStr,"^",2,2)
					s ^||DHCWLTEMP("RPTItem","filterItem",item,"filterStr")=filterOp_filterV
					s ^||DHCWLTEMP("RPTItem","filterItem",item,"fieldName")=fieldName
					s ^||DHCWLTEMP("RPTItem","filterItem",item,"dimProExc")=proExc
					s ^||DHCWLTEMP("RPTItem","filterItem",item,"dimproParam")=proParam				
				} 			
			}
		}
	}else{
		
		s ^||DHCWLTEMP("RPTCFG","BaseObjName")=$g(inParam("qryObjName")) /// 查询对象名称
		//s ^||DHCWLTEMP("RPTCFG","Name")=newObj.Name /// 报表名称
		s ^||DHCWLTEMP("RPTCFG","DateItemName")=$g(inParam("daterangeItem")) /// 日期统计项
		s ^||DHCWLTEMP("RPTCFG","Type")="grpRpt"	/// 类型：grpRpt:网格/分组;crossRpt:交叉
		s ^||DHCWLTEMP("RPTCFG","IsAggregat")=(inParam("qryType")="aggregat") /// 是否聚合
		s ^||DHCWLTEMP("RPTCFG","Remarks")=""
		
		//维度
		s colLen=$l(inParam("paramCols"),",")
		f colInx=1:1:colLen {
			s item=$p(inParam("paramCols"),",",colInx)
			s ^||DHCWLTEMP("RPTItem","colItem",item,"order")=""
			s ^||DHCWLTEMP("RPTItem","colItem",item,"fieldName")=item
		
			s itemName=$p(item,"->",1)
			s proCode=$p(item,"->",2)
			s itemID=$o(^DHCWL.BaseDataQuery.ItemI("QueryObjNameIndex",$g(inParam("qryObjName")),itemName,""))
			s dimType=$lg(^DHCWL.BaseDataQuery.ItemD(itemID),6)
			s dimCode=$lg(^DHCWL.BaseDataQuery.ItemD(itemID),7)
			//得到维度属性执行代码
			s ^||DHCWLTEMP("RPTItem","colItem",item,"dimProExc")=..getPropertyExc($g(inParam("qryObjName")),dimType,dimCode,proCode)
		
			s ^||DHCWLTEMP("RPTItem","colItem",item,"dimproParam")=$p(inParam("inPamCols"),",",colInx)	
			s ^||DHCWLTEMP("RPTItem","colItem",item,"type")="维度"
		}
		//度量
		s colLen=$l(inParam("paramMeasure"),",")
		f colInx=1:1:colLen {
			s item=$p(inParam("paramMeasure"),",",colInx)
			s ^||DHCWLTEMP("RPTItem","colItem",item,"order")=""
			s ^||DHCWLTEMP("RPTItem","colItem",item,"fieldName")=item
			//得到维度属性执行代码
			s ^||DHCWLTEMP("RPTItem","colItem",item,"dimProExc")=""
			s ^||DHCWLTEMP("RPTItem","colItem",item,"dimproParam")=""
			s ^||DHCWLTEMP("RPTItem","colItem",item,"type")="维度"
		}
		
		//过滤
		s colLen=$l(inParam("filterIDs"),",")
		f colInx=1:1:colLen {
			s item=$p(inParam("filterIDs"),",",colInx)
			s ^||DHCWLTEMP("RPTItem","filterItem",item,"filterStr")=$p(inParam("filterOperas"),",",colInx)_$p(inParam("filterValues"),",",colInx)
			s ^||DHCWLTEMP("RPTItem","colItem",item,"fieldName")=item
			//得到维度属性执行代码
			s itemID=$o(^DHCWL.BaseDataQuery.ItemI("QueryObjNameIndex",$g(inParam("qryObjName")),itemName,""))
			s dimType=$lg(^DHCWL.BaseDataQuery.ItemD(itemID),6)
			s dimCode=$lg(^DHCWL.BaseDataQuery.ItemD(itemID),7)
			//得到维度属性执行代码
			s ^||DHCWLTEMP("RPTItem","colItem",item,"dimProExc")=..getPropertyExc($g(inParam("qryObjName")),dimType,dimCode,proCode)
			s ^||DHCWLTEMP("RPTItem","colItem",item,"dimproParam")=$p(inParam("inPamCols"),",",colInx)	
			s ^||DHCWLTEMP("RPTItem","colItem",item,"type")="维度"
		}		
	}
	
	//1、显示顺序2、字段名称3、基础维度编码4、维度属性代码
	//5、过滤值
}

Method QryTableData(startDate As %String, endDate As %String, engineObj As ServOfEngIne, outputIF As ServOfOutputIF) As %String
{
	d engineObj.LoadInxData()
	d engineObj.Prepare(startDate,endDate)
	
	s delimiter=outputIF.GetAryOutCfgArgs("delimiter")
	s rowInx=1
	While(engineObj.Next()) {
		s filterRes=1
		//存在过滤条件
		if $d(^||DHCWLTEMP("RPTItem","filterItem")) {
			s item=""
			f {
				s item=$o(^||DHCWLTEMP("RPTItem","filterItem",item))
				q:item=""
				s fieldName=^||DHCWLTEMP("RPTItem","filterItem",item,"fieldName")
				s dimProExc=^||DHCWLTEMP("RPTItem","filterItem",item,"dimProExc")
				s fieldV=engineObj.FieldData(fieldName)
				s itemV=""
				if dimProExc'="" {
					s dimproParam=^||DHCWLTEMP("RPTItem","filterItem",item,"dimproParam")
					//s ^||DHCWLTEMP("sqlTabData","fieldName")=engineObj.FieldData(fieldName)
					s itemV=..GetProValue(dimProExc,fieldV,dimproParam)
				}else{
					s itemV=fieldV
				}
				s filterStr=^||DHCWLTEMP("RPTItem","filterItem",item,"filterStr")
				s itemV=""""_itemV_""""
				s excStr="("_itemV_filterStr_")"
				s filterRes=..GetExcResult(excStr)
				q:filterRes<=0 
				
			}
		}
		continue:filterRes<=0 
		
		if ^||DHCWLTEMP("RPTCFG","IsAggregat")=0 d GetDetail
		else  d GetAggregat
	}
	q ""
	
	
GetDetail
	s item=""
	s recData=""
	f {
		s item=$o(^||DHCWLTEMP("RPTItem","colItem",item))
		q:item=""
		s fieldName=^||DHCWLTEMP("RPTItem","colItem",item,"fieldName")
		s dimProExc=^||DHCWLTEMP("RPTItem","colItem",item,"dimProExc")
		s fieldV=engineObj.FieldData(fieldName)
		s itemV=""
		if dimProExc'="" {
			s dimproParam=^||DHCWLTEMP("RPTItem","colItem",item,"dimproParam")
			//s ^||DHCWLTEMP("sqlTabData","fieldName")=engineObj.FieldData(fieldName)
			s itemV=..GetProValue(dimProExc,fieldV,dimproParam)
		}else{
			s itemV=fieldV
		}
		
		if recData'="" s recData=recData_delimiter
		s recData=recData_"'"_itemV_"'"
		//s order=^||DHCWLTEMP("RPTItem","colItem",item,"order")
		//s $p(recData,"^",order)=itemV
	}
	
	s rowInx=rowInx+1
	s ^||DHCWLTEMP("resultSet",rowInx)=recData

	q
GetAggregat
	s item=""
	s dimsV=""
	f {
		s item=$o(^||DHCWLTEMP("RPTItem","colItem",item))
		q:item=""
		s fieldName=^||DHCWLTEMP("RPTItem","colItem",item,"fieldName")
		s dimProExc=^||DHCWLTEMP("RPTItem","colItem",item,"dimProExc")
		s fieldV=engineObj.FieldData(fieldName)
		s itemV=""
		if dimProExc'="" {
			s dimproParam=^||DHCWLTEMP("RPTItem","colItem",item,"dimproParam")
			//s ^||DHCWLTEMP("sqlTabData","fieldName")=engineObj.FieldData(fieldName)
			s itemV=..GetProValue(dimProExc,fieldV,dimproParam)
		}else{
			s itemV=fieldV
		}
		if itemV="" s itemV="NULL"
		
		s type=^||DHCWLTEMP("RPTItem","colItem",item,"type")
		if type="度量" {
			s measure(item)=itemV
			continue
		}
		
		if dimsV'="" s dimsV=dimsV_delimiter
		s dimsV=dimsV_itemV
	}
	
	s item=""
	f {
		s item=$o(measure(item))
		q:item=""
		s ^||DHCWLTEMP("measureV",dimsV,item)=$g(^||DHCWLTEMP("measureV",dimsV,item))+measure(item)
	}
	
	q
}

Method OutputData(outputIF As ServOfOutIFJson) As %String
{
	d outputIF.DoOutput()
}

}
