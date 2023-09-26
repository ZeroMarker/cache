/// 名称: DHCWL.BaseDataQuery.Interface
/// 描述: 基础数据查询程序接口
/// 编写者：王峥
/// 编写日期: 2017-03-01
Class DHCWL.BaseDataQuery.Interface Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:：   返回JSON格式的汇总查询数据，被CSP调用
/// Table：       	无
/// Input：         inParam：包含统计项，过滤项
/// 					
/// Output：        outParam：JSON对象。
/// Return：        空字符串——正确；其他——错误提示信息
/// Others：
ClassMethod GetQrySummaryItemJson(ByRef inParam, ByRef outParam) As %String
{
	k ^||TEMPDHCWL("BDQ")
	
	s ret=""
	s paramRows=$g(inParam("paramRows"))
	s paramCols=$g(inParam("paramCols"))
	s paramMeasure=$g(inParam("paramMeasure"))
	
	S ret=..GetQrySummaryItem(.inParam,.outParam)
	if ret'="" q ret
		
	//zw ^||TEMPDHCWL("BDQ","SUMGLOBAL")
	
	
	s displayCols=$g(paramRows)_","_$g(paramCols)_","_$g(paramMeasure)
	s len=$l(displayCols,",")

	s jsonPros=""
	s jsonDeli="&"

	s colInx=0
	f i=1:1:len {
		s col=$p(displayCols,",",i)
		continue:$g(col)=""
		//新建json对象用
		if jsonPros'="" s jsonPros=jsonPros_jsonDeli
		s jsonPros=jsonPros_"'"_col_"'"
	}
	
	//w !,jsonPros,!

	s json=##class(DHCWL.util.Json).Json(jsonPros,,,jsonDeli)
	s rowCnt=0
	s rowInx=0
	s dataRowCnt=0
	s rowLen=$l(paramRows,",")
	if rowLen>0 {		//说明是交叉报表
		f i=1:1:rowLen {
			s col=$p(paramRows,",",i)
			continue:$g(col)=""
			s rowCnt=rowCnt+1
		}
	}
	
	if rowCnt=0 {				//说明是行式报表
		s rowLen=$l(paramCols,",")
		f i=1:1:rowLen {
			s col=$p(paramCols,",",i)
			continue:$g(col)=""
			s rowCnt=rowCnt+1
		}	
	}
	if rowCnt=0 s rowCnt=1
	
	s nums=0
	s ignore=1
	s startInx=inParam("start")
	s endInx=inParam("end")
	i (startInx=0)&&(endInx=0) s ignore=0	
	s rowCntV=""
	s gNode=""
	f {
		
		s gNode=$o(^||TEMPDHCWL("BDQ","SUMGLOBAL",gNode))
		q:gNode=""
		
		//需要修改
		/*
		if rowCntV'=$p(gNode,jsonDeli,rowCnt)	{
			s nums=nums+1
			s rowCntV=$p(gNode,jsonDeli,rowCnt)
		}	
		*/
		s nums=nums+1
		i (ignore)&&(nums<(startInx)) continue
		i (ignore)&&((endInx)<nums) continue	
				
		s measureCol=""
		s measJ=""
		s measureLen=$l(paramMeasure,",")
		f i=1:1:measureLen {
			s measureCol=$p(paramMeasure,",",i)
			continue:measureCol=""
			s measure=^||TEMPDHCWL("BDQ","SUMGLOBAL",gNode,measureCol)
			//if measure=0  s measure=""
			s measJ=$g(measJ)_jsonDeli_"'"_measure_"'"
		}
		s jv=gNode_measJ
		d json.Insert(jv)
	}


	d:json json.SetTotalNum(nums)
	s outParam=json
	
	q ret
}

/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:：   返回JSON格式的明细查询数据，被CSP调用
/// Table：       	无
/// Input：         inParam：包含统计项，过滤项
/// 					
/// Output：        outParam：JSON对象。
/// Return：        空字符串——正确；其他——错误提示信息
/// Others：        
ClassMethod GetQryDetailItemJson(ByRef inParam, ByRef outParam) As %String
{
	s ret=""
	k outParam
	k ^||TEMPDHCWL("BDQ")
	s sqlFields=""
	s displayCols=inParam("paramCols")	//报表栏
	s len=$l(displayCols,",")	
	
	
	s jsonPros=""
	s jsonDeli="&"
	s colInx=0
	
	
	f i=1:1:len {
		s col=$p(displayCols,",",i)
		continue:$g(col)=""
		s colInx=colInx+1
		//新建json对象用
		if jsonPros'="" s jsonPros=jsonPros_jsonDeli
		s jsonPros=jsonPros_"'"_col_"'"
		//列字段类型
		s inParam("colType",col)=$p(inParam("colTypes"),",",i)
	}
	
	//得到明细查询结果
	s ret=..GetQryDetailItem(.inParam,.outParam)
	if ret'="" q ret
	//新建JSON对象
	s json=##class(DHCWL.util.Json).Json(jsonPros,,,jsonDeli)

	//向JSON对象充填数据
	s dataOrder=""
	f {
		s dataOrder=$o(^||TEMPDHCWL("BDQ","DETAILGLOBAL",dataOrder))
		q:+dataOrder=0
		s value=$o(^||TEMPDHCWL("BDQ","DETAILGLOBAL",dataOrder,""))
		d json.Insert(value)
	}
		
	
	d:json json.SetTotalNum(inParam("recCnt"))
	s outParam=json
	
	
	q ret
}

/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:：   查询明细查询数据，结果保存到global中
/// Table：       	无
/// Input：         inParam：包含统计项，过滤项
/// 					
/// Output：        outParam：预留，暂未使用。
/// Return：        空字符串——正确；其他——错误提示信息
/// Others：
ClassMethod GetQryDetailItem(ByRef inParam, ByRef outParam) As %String
{
	s ret=""
	//s $zt="SQLErr"
	k outParam

	s LIMITMAXREC=200000		//最大允许查询的记录数量
	
	s sqlTableName=$g(inParam("qryObjName"))		//基础表的表名
	s startInx=$g(inParam("start"))					//分页查询开始值
	s endInx=$g(inParam("end"))						//分页查询结束值
	s daterangeItem=$g(inParam("daterangeItem"))	//日期口径
	s daterangeStart=$g(inParam("daterangeStart"))	//查询开始日期
	s daterangeEnd=$g(inParam("daterangeEnd"))		//查询结束日期
	
	s inPamCols=$g(inParam("inPamCols"))			//统计项入参
	s inPamfilter=$g(inParam("inPamfilter"))		//过滤入参
		
	s sqlFields=""
	s displayCols=$g(inParam("paramCols"))			//统计项
	s len=$l(displayCols,",")	
	
	s jsonPros=""
	s jsonDeli="&"
	s colInx=0
	s sqlFieldPos=1
	//1、解析需要查询的表的字段
	f i=1:1:len {
		s col=$p(displayCols,",",i)
		continue:$g(col)=""
		s colInx=colInx+1
		s ^||TEMPDHCWL("BDQ","DISPLAYITEMS",colInx)=col	//返回给前台页面部分
		s ^||TEMPDHCWL("BDQ","DISPLAYINPAM",colInx)=$p(inPamCols,",",i)
		
		if $F(col,"->")>0 {
			s ^||TEMPDHCWL("BDQ","SEARCHCOLPROS",col)=""		//等号后面是取数方法

			if '$d(^||TEMPDHCWL("BDQ","SQLFieldPos",$P(col,"->",1))) {
				s ^||TEMPDHCWL("BDQ","SQLFieldPos",$P(col,"->",1))=sqlFieldPos
				s sqlFieldPos=sqlFieldPos+1
				
				s:$g(sqlFields)'="" sqlFields=sqlFields_","
				s sqlFields=sqlFields_$P(col,"->",1)
			}

		}else{

			if '$d(^||TEMPDHCWL("BDQ","SQLFieldPos",col)) {
				s ^||TEMPDHCWL("BDQ","SQLFieldPos",col)=sqlFieldPos
				s sqlFieldPos=sqlFieldPos+1
				s:$g(sqlFields)'="" sqlFields=sqlFields_","
				s sqlFields=sqlFields_col				
			}
		}
	}
	
	//2、解析需要查询的过滤条件
	s whereFileds=""
	s filterCols=$g(inParam("filterIDs"))
	s len=$l(filterCols,",")	
	f i=1:1:len {
		s col=$p(filterCols,",",i)
		continue:$g(col)=""
		
		if $F(col,"->")>0 {
			s ^||TEMPDHCWL("BDQ","SEARCHCOLPROS",col)=""		//等号后面是取数方法
			
			s opera=$p(inParam("filterOperas"),",",i)
			s fV=$p(inParam("filterValues"),",",i)
			if opera="like" {
				s opera="["	
				s fV=$REPLACE(fV,"%","")
			}
			//s ^||TEMPDHCWL("BDQ","FILTERPROS",col)=opera_$p(inParam("filterValues"),",",i)	//需要过滤的属性部分
			s ^||TEMPDHCWL("BDQ","FILTERPROS",col)=opera_fV
			s ^||TEMPDHCWL("BDQ","FILTERINPAM",col)=$p(inPamfilter,",",i)
			
			if '$d(^||TEMPDHCWL("BDQ","SQLFieldPos",$P(col,"->",1))) {
				s ^||TEMPDHCWL("BDQ","SQLFieldPos",$P(col,"->",1))=sqlFieldPos
				s sqlFieldPos=sqlFieldPos+1
				s:$g(sqlFields)'="" sqlFields=sqlFields_","
				s sqlFields=sqlFields_$P(col,"->",1)				
			}			

		}else{
			s whereFileds=whereFileds_" and "_col_" "_$p(inParam("filterOperas"),",",i)_" "_$p(inParam("filterValues"),",",i)
		}
	}


	//3、解析分组
	s colGroups=$g(inParam("colGroup"))
	s len=$l(colGroups,",")	
	if colGroups'="" {
		f i=1:1:len {
			s col=$p(colGroups,",",i)
			continue:$g(col)=""
		}
		s whereFileds=whereFileds_" GROUP BY "_colGroups
	}

	//4、解析排序
	s colOrders=$g(inParam("colOrder"))
	s orderCondition=""
	s len=$l(colOrders,",")	
	if colOrders'="" {
		f i=1:1:len {
			s col=$p(colOrders,",",i)
			continue:$g(col)=""
			s field=$p(col,"(",1)
			s AE=$p($p(col,"(",2),")",1)
			if AE="升序" s AE="ASC"
			else  s AE="DESC" 
			if orderCondition="" s orderCondition=field_" "_AE
			else  s orderCondition=orderCondition_","_field_" "_AE
		}
		s whereFileds=whereFileds_" ORDER BY "_orderCondition
	}		
	s whereCond=daterangeItem_">='"_daterangeStart_"' and "_daterangeItem_"<='"_daterangeEnd_"'"_whereFileds


	//3、本方法可以被前台页面间接调用，也可以在terminal中被间接调用，
	//当被前台页面调用时，如果查询结果的数据量太大，用户会等待比较长的时间。
	//因此，当查询结果超过一个阀值时，程序直接返回，并建议用户在terminal下去查询。
	//inParam("actFrom")="http"表示被前台页面调用
	/*	先忽略掉。add by wz.2017-12-18
	if $d(inParam("actFrom")) && (inParam("actFrom")="http") {
		s Sql="select count(*) from "_sqlTableName_" where "_whereCond
		
		s Rs=##class(%Library.ResultSet).%New()
		s Rs.RuntimeMode=1	//ODBC显示模式
		s st=Rs.Prepare(Sql) 
	
		if ($$$ISERR(st)) {
			s ret=$System.Status.GetErrorText(st)
			goto SQLErr
		}
		s st=Rs.Execute() 
		if ($$$ISERR(st)) {
			s ret=$System.Status.GetErrorText(st)
			goto SQLErr
		}
		d Rs.Next()	
		s recCount=Rs.GetData(1)
		if recCount>=LIMITMAXREC s ret="参与计算的记录数量是"_recCount_"条,记录数量太多,查询已中断.当统计的数据比较多时,推荐在termianl下执行导出功能,将查询结果导出为txt文件."
			
		d Rs.Close()
		if ret'="" q ret
		
	}
	*/

	//4、拼接查询语句
	s Sql="select "_sqlFields_" from "_sqlTableName_" where "_whereCond
	//w !,"sql="_Sql
	//5、得到维度属性执行代码
	s col=""
	f {
		s col=$o(^||TEMPDHCWL("BDQ","SEARCHCOLPROS",col))	
		q:col=""
		s itemName=$p(col,"->",1)
		s proCode=$p(col,"->",2)
		s itemID=$o(^DHCWL.BaseDataQuery.ItemI("QueryObjNameIndex",sqlTableName,itemName,""))
		s dimType=$lg(^DHCWL.BaseDataQuery.ItemD(itemID),6)
		s dimCode=$lg(^DHCWL.BaseDataQuery.ItemD(itemID),7)
		//得到维度属性执行代码
		s ^||TEMPDHCWL("BDQ","SEARCHCOLPROS",col)=..getPropertyExc(sqlTableName,dimType,dimCode,proCode)
	}
	
	//6、执行查询
	s Rs=##class(%Library.ResultSet).%New()
	s Rs.RuntimeMode=1	//ODBC显示模式
	s st=Rs.Prepare(Sql) 
	
	if ($$$ISERR(st)) {
		s ret=$System.Status.GetErrorText(st)
		goto SQLErr
	}
	s st=Rs.Execute() 
	if ($$$ISERR(st)) {
		s ret=$System.Status.GetErrorText(st)
		goto SQLErr
	}
	
	s nums=0

	s ignore=1
	i (+startInx=0)&&(+endInx=0) s ignore=0
	//7、循环过滤每条记录
	while(Rs.Next()) {
		
		continue:##CLASS(DHCWL.BaseDataQuery.Util).GetFilterResult(Rs)=0	//过滤
		s nums=nums+1
		i (ignore)&&(nums<(+startInx)) continue		//分页
		i (ignore)&&((+endInx)<nums) continue		//分页
		//8、将结果数据转换成global
		d ..TransToDetailGlobalData(jsonDeli,Rs,.inParam)	
		//w ","_nums
	}

	s inParam("recCnt")=nums
	d Rs.Close()
	
	q ret

SQLErr
	if ret="" s ret="未知错误!"
	//s ret=Sql_":"_ret
	q ret
}

/// 
/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:：   查询明细查询数据，结果保存到global中。被GetQrySummaryItemJson调用和query调用
/// Table：       	无
/// Input：         inParam：包含统计项，过滤项
/// 					
/// Output：        outParam：预留，暂未使用。
/// Return：        空字符串——正确；其他——错误提示信息
/// Others：
ClassMethod GetQrySummaryItem(ByRef inParam, ByRef outParam) As %String
{
	s ret=""
	//s $zt="SQLErr"
	k outParam
	
	s LIMITMAXREC=200000		//最大允许查询的记录数量
	
	s sqlTableName=inParam("qryObjName")
	s daterangeItem=inParam("daterangeItem")
	s daterangeStart=inParam("daterangeStart")
	s daterangeEnd=inParam("daterangeEnd")
	
	s sqlFields=""
	
	s paramRows=$g(inParam("paramRows"))

	s paramCols=$g(inParam("paramCols"))
	s paramMeasure=$g(inParam("paramMeasure"))
	
	s inPamRows=$g(inParam("inPamRows"))
	s inPamCols=$g(inParam("inPamCols"))
	s inPamfilter=$g(inParam("inPamfilter"))
	
	s displayCols=$g(inParam("paramRows"))_","_$g(inParam("paramCols"))_","_$g(paramMeasure)
	
	s disPlayInParam=$g(inPamRows)_","_inPamCols
	s len=$l(displayCols,",")	
	
	
	s jsonPros=""
	s jsonDeli="&"
	s colInx=0
	
	f i=1:1:len {
		s col=$p(displayCols,",",i)
		continue:$g(col)=""
		s colInx=colInx+1
		s ^||TEMPDHCWL("BDQ","DISPLAYITEMS",colInx)=col	//返回给前台页面部分
		s ^||TEMPDHCWL("BDQ","DISPLAYINPAM",colInx)=$p(disPlayInParam,",",i)
		//新建json对象用
		/*
		if jsonPros'="" s jsonPros=jsonPros_jsonDeli
		s jsonPros=jsonPros_"'"_col_"'"
		*/
		
		if $F(col,"->")>0 {
			s ^||TEMPDHCWL("BDQ","SEARCHCOLPROS",col)=""		//等号后面是取数方法
			s:$g(sqlFields)'="" sqlFields=sqlFields_","
			s sqlFields=sqlFields_$P(col,"->",1)		
			
		}else{
			s:$g(sqlFields)'="" sqlFields=sqlFields_","
			s sqlFields=sqlFields_col
		}
	}
	
	s whereFileds=""
	s filterCols=$g(inParam("filterIDs"))
	s len=$l(filterCols,",")	
	f i=1:1:len {
		s col=$p(filterCols,",",i)
		continue:$g(col)=""
		
		if $F(col,"->")>0 {
			s ^||TEMPDHCWL("BDQ","SEARCHCOLPROS",col)=""		//等号后面是取数方法
			//s ^||TEMPDHCWL("BDQ","FILTERPROS",col)=$p(inParam("filterOperas"),",",i)_""""_$p(inParam("filterValues"),",",i)_""""	//需要过滤的属性部分
			//s ^||TEMPDHCWL("BDQ","FILTERPROS",col)=$p(inParam("filterOperas"),",",i)_$p(inParam("filterValues"),",",i)	//需要过滤的属性部分
			s opera=$p(inParam("filterOperas"),",",i)
			if opera="like" s opera="["		
			s ^||TEMPDHCWL("BDQ","FILTERPROS",col)=opera_$p(inParam("filterValues"),",",i)	//需要过滤的属性部分
			s ^||TEMPDHCWL("BDQ","FILTERINPAM",col)=$p(inPamfilter,",",i)
			
			s:$g(sqlFields)'="" sqlFields=sqlFields_","
			s sqlFields=sqlFields_$P(col,"->",1)
		}else{
			s whereFileds=whereFileds_" and "_col_" "_$p(inParam("filterOperas"),",",i)_" "_$p(inParam("filterValues"),",",i)
		}
	}
	
	s len=$l(paramMeasure,",")
	f i=1:1:len {
		s col=$p(paramMeasure,",",i)
		continue:$g(col)=""
		s ^||TEMPDHCWL("BDQ","MEASUREITEM",col)=""
	}
		
	s whereCond=daterangeItem_">='"_daterangeStart_"' and "_daterangeItem_"<='"_daterangeEnd_"'"_whereFileds
	/*先忽略掉这个判断。//add by wz.2017-12-18
	if $d(inParam("actFrom")) && (inParam("actFrom")="http") {
		s Sql="select count(*) from "_sqlTableName_" where "_whereCond
		
		s Rs=##class(%Library.ResultSet).%New()
		s Rs.RuntimeMode=1	//ODBC显示模式
		s st=Rs.Prepare(Sql) 
	
		if ($$$ISERR(st)) {
			s ret=$System.Status.GetErrorText(st)
			goto SQLErr
		}
		s st=Rs.Execute() 
		if ($$$ISERR(st)) {
			s ret=$System.Status.GetErrorText(st)
			goto SQLErr
		}
		d Rs.Next()	
		s recCount=Rs.GetData(1)
		if recCount>=LIMITMAXREC s ret="参与计算的记录数量是"_recCount_"条,记录数量太多,查询已中断.当统计的数据比较多时,推荐在termianl下执行导出功能,将查询结果导出为txt文件."
			
		d Rs.Close()
		if ret'="" q ret
		
	}
	*/
	
	s Sql="select "_sqlFields_" from "_sqlTableName_" where "_whereCond
	//w !,Sql
	//q 0
	s col=""
	f {
		s col=$o(^||TEMPDHCWL("BDQ","SEARCHCOLPROS",col))	
		q:$g(col)=""
		s itemName=$p(col,"->",1)
		s proCode=$p(col,"->",2)
		
		s itemID=$o(^DHCWL.BaseDataQuery.ItemI("QueryObjNameIndex",sqlTableName,itemName,""))
		s dimType=$lg(^DHCWL.BaseDataQuery.ItemD(itemID),6)
		s dimCode=$lg(^DHCWL.BaseDataQuery.ItemD(itemID),7)
		//得到维度属性执行代码
		s ^||TEMPDHCWL("BDQ","SEARCHCOLPROS",col)=..getPropertyExc(sqlTableName,dimType,dimCode,proCode)
	}

	s Rs=##class(%Library.ResultSet).%New()
	s Rs.RuntimeMode=1	//ODBC显示模式
	s st=Rs.Prepare(Sql) 
	
	if ($$$ISERR(st)) {
		s ret=$System.Status.GetErrorText(st)
		goto SQLErr
	}
	s st=Rs.Execute() 
	if ($$$ISERR(st)) {
		s ret=$System.Status.GetErrorText(st)
		goto SQLErr
	}
	
	s json=##class(DHCWL.util.Json).Json(jsonPros,,,jsonDeli)

	while(Rs.Next()) {
		
		continue:##CLASS(DHCWL.BaseDataQuery.Util).GetFilterResult(Rs)=0
		d ..TransToSumGlobalData(Rs,paramMeasure,jsonDeli)

	}

	d Rs.Close()

	q ret
SQLErr
	if ret="" s ret="未知错误!"
	q ret
}

/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:：   返回维度属性执行代码
/// Table：       	基础维度表，维度属性表
/// Input：         qryObjName：查询对象；dimType：维度类型；dimCode：维度编码；proCode：属性编码
/// 					
/// Output：        无。
/// Return：        维度执行代码
/// Others
ClassMethod getPropertyExc(qryObjName As %String, dimType As %String, dimCode As %String, proCode As %String) As %String
{
	//s num=$o(^TEMPDHCWL("WZ-getPropertyExc",""),-1)
	//s ^TEMPDHCWL("WZ-getPropertyExc",num+1)=dimType_","_dimCode_","_proCode
	s ret=""
	if dimType="标准维度" {
		s dimID=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$SYSTEM.SQL.ALPHAUP(dimCode),""))
		s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimID,$SYSTEM.SQL.ALPHAUP(proCode),""))
		s ret=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),6,"")
	}elseif dimType="对象维度" {
		s proID=$o(^DHCWL.BaseDataQuery.QryobjProI("InxQryobjCode",qryObjName,proCode,""))
		s ret=$lg(^DHCWL.BaseDataQuery.QryobjProD(proID),6,"")
	}
	q ret
}

/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:： 将明细数据保存到global中
/// Table：       	无
/// Input：         jsonDeli：JSON工具对象分割符，Rs：结果集对象
/// 					
/// Output：        无。
/// Return：        无
/// Others：
ClassMethod TransToDetailGlobalData(jsonDeli As %String, ByRef Rs, ByRef inParam)
{
	s value=""
	s colInx=0
	f {
		//s col=$o(^||TEMPDHCWL("BDQ","DISPLAYITEMS",col))
		s colInx=$o(^||TEMPDHCWL("BDQ","DISPLAYITEMS",colInx))
		q:colInx=""
		s col=^||TEMPDHCWL("BDQ","DISPLAYITEMS",colInx)
		if $F(col,"->")>0 {
			s inPam=$g(^||TEMPDHCWL("BDQ","DISPLAYINPAM",colInx))
			s colV=##CLASS(DHCWL.BaseDataQuery.Util).GetProValue(col,Rs,inPam)
		}else{
			//s colV=Rs.GetDataByName(col)
			s sqlFieldPos=^||TEMPDHCWL("BDQ","SQLFieldPos",col)
			s colV=Rs.GetData(sqlFieldPos)
		
			if $d(inParam("colType",col)) {
				if inParam("colType",col)="measure" || (inParam("colType",col)="colcustomMeasure") {
					s colV=$FN(colV,"",2)
				}
			}		
		}
		

				
		if value'="" s value=value_jsonDeli
		s value=value_"'"_colV_"'"
	}
	s dataOrder=""
	s dataOrder=$o(^||TEMPDHCWL("BDQ","DETAILGLOBAL",""),-1)
	s dataOrder=+$g(dataOrder)+1
	s ^||TEMPDHCWL("BDQ","DETAILGLOBAL",dataOrder,value)=0
}

/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:： 将汇总数据保存到global中
/// Table：       	无
/// Input：         jsonDeli：JSON工具对象分割符，Rs：结果集对象，measureName：度量名称
/// 					
/// Output：        无。
/// Return：        无
/// Others：
ClassMethod TransToSumGlobalData(ByRef Rs, measureName As %String, jsonDeli As %String)
{
	s value=""
	s colInx=0
	s measureValue=0
	s bFlag=0
	//s globalStr="s ^||TEMPDHCWL(""BDQ"",""SUMGLOBAL"""
	s globalStr=""
	f {
		//s col=$o(^||TEMPDHCWL("BDQ","DISPLAYITEMS",col))
		s colInx=$o(^||TEMPDHCWL("BDQ","DISPLAYITEMS",colInx))
		q:colInx=""
		s col=^||TEMPDHCWL("BDQ","DISPLAYITEMS",colInx)
		if $F(col,"->")>0 {
			s inPam=$g(^||TEMPDHCWL("BDQ","DISPLAYINPAM",colInx))
			s colV=##CLASS(DHCWL.BaseDataQuery.Util).GetProValue(col,Rs,inPam)
		}else{
			s colV=Rs.GetDataByName(col)
			if colV="" s colV="Null"
		}
		/*
		if $g(colV)=""{
			s bFlag=1
			q
		}*/

		
		if $d(^||TEMPDHCWL("BDQ","MEASUREITEM",col)) {
			s aryMeasure(col)=colV
			continue	
		}
		if globalStr'="" s globalStr=globalStr_jsonDeli
		s globalStr=globalStr_"'"_colV_"'"
	}
	q:bFlag=1
	// ^||TEMPDHCWL("BDQ","MEASUREITEM",col)
	if $d(aryMeasure) {
		s col=""
		f {
			s col=$o(aryMeasure(col))	
			q:$g(col)=""
			s ^||TEMPDHCWL("BDQ","SUMGLOBAL",globalStr,col)=$g(^||TEMPDHCWL("BDQ","SUMGLOBAL",globalStr,col))+aryMeasure(col)
		}
		//s ^||TEMPDHCWL("BDQ","SUMGLOBAL",globalStr)=$g(^||TEMPDHCWL("BDQ","SUMGLOBAL",globalStr))+measureValue
		
	}
}

/// 
/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:：   返回汇总查询数据，被被润乾调用调用
/// Table：       	无
/// Input：         qryObjName：查询对象名称
/// 					paramRows：行显示项，
/// 					inPamRows：行显示项入参，
/// 					paramCols：列显示项，
/// 					inPamCols：列显示项入参，
/// 					paramMeasure：度量项，
/// 					paramMeasureDesc：度量项描述，
/// 					daterangeItem：日期口径，
/// 					daterangeStart：统计开始日期，
/// 					daterangeEnd：统计结束日期 ， 
/// 					filterIDs：过滤项 ， 
/// 					filterOperas：过滤操作符， 
/// 					filterValues：过滤值 ， 
/// 					inPamfilter：过滤项入参				
/// Output：        row1,row2,row3,row4,row5：行1-行5
/// 					col1,col2,col3,col4,col5：列1-列5
/// 					measureDesc：度量描述
/// 					measure：度量描述
/// Return：        
/// Others：
Query QryGetSummaryItem(qryObjName As %String, paramRows As %Text, inPamRows As %Text, paramCols As %Text, inPamCols As %Text, paramMeasure As %Text, paramMeasureDesc As %Text, daterangeItem As %Text, daterangeStart As %Text, daterangeEnd As %Text, filterIDs As %Text, filterOperas As %Text, filterValues As %Text, inPamfilter As %Text) As %Query(ROWSPEC = "row1:%String,row2:%String,row3:%String,row4:%String,row5:%String,col1:%String,col2:%String,col3:%String,col4:%String,col5:%String,measureDesc:%String,measure:%Float") [ SqlProc ]
{
}

ClassMethod QryGetSummaryItemExecute(ByRef qHandle As %Binary, qryObjName As %String, paramRows As %Text, inPamRows As %Text, paramCols As %Text, inPamCols As %Text, paramMeasure As %Text, paramMeasureDesc As %Text, daterangeItem As %Text, daterangeStart As %Text, daterangeEnd As %Text, filterIDs As %Text, filterOperas As %Text, filterValues As %Text, inPamfilter As %Text) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//k inParam
	k ^||TEMPDHCWL("BDQ")
	
	s inParam("actFrom")="http"
	
	s inParam("paramRows")=paramRows
	s inParam("paramCols")=paramCols
	s inParam("paramMeasure")=paramMeasure
	s inParam("qryObjName")=qryObjName
	
	//s ^TEMPDHCWL("WZ-getPropertyExc","paramRows")=paramRows
	//s ^TEMPDHCWL("WZ-getPropertyExc","inPamRows")=inPamRows
	
	s inParam("inPamRows")=inPamRows
	s inParam("inPamCols")=inPamCols
	s inParam("inPamfilter")=inPamfilter
	
	s inParam("daterangeItem")=daterangeItem
	s inParam("daterangeStart")=daterangeStart
	s inParam("daterangeEnd")=daterangeEnd

	
	s inParam("filterIDs")=filterIDs
	s inParam("filterOperas")=filterOperas
	s inParam("filterValues")=filterValues

	s paramRows=$g(inParam("paramRows"))
	s paramCols=$g(inParam("paramCols"))
	s paramMeasure=$g(inParam("paramMeasure"))
	
	s ret=..GetQrySummaryItem(.inParam,.outParam)
	
	if daterangeItem'="" && (ret'="") {
		s Data=$lb(ret,row2,row3,row4,row5,col1,col2,col3,col4,col5,valueDesc,value)
		d OuputRow1		
	}else{
		s len=$l(paramRows,",")
		s rowCnt=..GetStrNotNullCnt(paramRows,",")
		s colCnt=..GetStrNotNullCnt(paramCols,",")
		s measureCnt=..GetStrNotNullCnt(paramMeasure,",")

		s jsonDeli="&"


		s meaCnt=$l(paramMeasureDesc,",")
		f inx=1:1:meaCnt {
			s measure=$p(paramMeasure,",",inx)
			continue:$g(measure)=""
			s desc=$p(paramMeasureDesc,",",inx)
			s ^||TEMPDHCWL("BDQ","MAPMEASUREDESC",measure)=desc
		}
	
	
	
		s rowCntV=""
		s gNode=""
		f {
		
			s gNode=$o(^||TEMPDHCWL("BDQ","SUMGLOBAL",gNode))
			q:gNode=""
		
			s measureCol=""
			f {
				s measureCol=$o(^||TEMPDHCWL("BDQ","SUMGLOBAL",gNode,measureCol))
				q:$g(measureCol)=""
			
			
				s row1="",row2="",row3="",row4="",row5="",col1="",col2="",col3="",col4="",col5=""
				//$TRANSLATE

				if rowCnt>=1 && ($p(gNode,"&",1)'="") s row1=$TRANSLATE($p(gNode,"&",1),"'","")
				if rowCnt>=2 && ($p(gNode,"&",2)'="") s row2=$TRANSLATE($p(gNode,"&",2),"'","")
				if rowCnt>=3 && ($p(gNode,"&",3)'="") s row3=$TRANSLATE($p(gNode,"&",3),"'","")
				if rowCnt>=4 && ($p(gNode,"&",4)'="") s row4=$TRANSLATE($p(gNode,"&",4),"'","")
				if rowCnt>=5 && ($p(gNode,"&",5)'="") s row5=$TRANSLATE($p(gNode,"&",5),"'","")
			

				if colCnt>=1 && ($p(gNode,"&",rowCnt+1)'="") s col1=$TRANSLATE($p(gNode,"&",rowCnt+1),"'","")
				if colCnt>=2 && ($p(gNode,"&",rowCnt+2)'="") s col2=$TRANSLATE($p(gNode,"&",rowCnt+2),"'","")
				if colCnt>=3 && ($p(gNode,"&",rowCnt+3)'="") s col3=$TRANSLATE($p(gNode,"&",rowCnt+3),"'","")
				if colCnt>=4 && ($p(gNode,"&",rowCnt+4)'="") s col4=$TRANSLATE($p(gNode,"&",rowCnt+4),"'","")
				if colCnt>=5 && ($p(gNode,"&",rowCnt+5)'="") s col5=$TRANSLATE($p(gNode,"&",rowCnt+5)	,"'","")		
				s value=+$g(^||TEMPDHCWL("BDQ","SUMGLOBAL",gNode,measureCol))
				s valueDesc=^||TEMPDHCWL("BDQ","MAPMEASUREDESC",measureCol)
				s Data=$lb(row1,row2,row3,row4,row5,col1,col2,col3,col4,col5,valueDesc,value)
				d OuputRow1
			}
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryGetSummaryItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGetSummaryItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryGetSummaryItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGetSummaryItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetStrNotNullCnt(strData As %String, strDiv As %String) As %Integer
{
	s len=$l(strData,strDiv)
	s Cnt=0
	f i=1:1:len {
		s col=$p(strData,",",i)
		continue:$g(col)=""
		s Cnt=Cnt+1
	}
	q Cnt
}

/// 
/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:：   返回汇总查询数据，被被润乾调用调用
/// Table：       	无
/// Input：         qryObjName：查询对象名称
/// 					paramRows：行显示项，
/// 					inPamRows：行显示项入参，
/// 					paramCols：列显示项，
/// 					inPamCols：列显示项入参，
/// 					paramMeasure：度量项，
/// 					paramMeasureDesc：度量项描述，
/// 					daterangeItem：日期口径，
/// 					daterangeStart：统计开始日期，
/// 					daterangeEnd：统计结束日期 ， 
/// 					filterIDs：过滤项 ， 
/// 					filterOperas：过滤操作符， 
/// 					filterValues：过滤值 ， 
/// 					inPamfilter：过滤项入参				
/// Output：        row1,row2,row3,row4,row5：行1-行5
/// 					col1,col2,col3,col4,col5：列1-列5
/// 					measureDesc：度量描述
/// 					measure：度量描述
/// Return：        
/// Others：
Query QryGetSummaryItem2(rptID As %String, daterangeStart As %Text, daterangeEnd As %Text) As %Query(ROWSPEC = "row1:%String,row2:%String,row3:%String,row4:%String,row5:%String,col1:%String,col2:%String,col3:%String,col4:%String,col5:%String,measureDesc:%String,measure:%String") [ SqlProc ]
{
}

ClassMethod QryGetSummaryItem2Execute(ByRef qHandle As %Binary, rptID As %String, daterangeStart As %Text, daterangeEnd As %Text) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//k inParam
	k ^||TEMPDHCWL("BDQ")
	
	d ..GetRptCfgDataByID(rptID,.inParam)	
	
	s inParam("actFrom")="http"
	s inParam("daterangeStart")=daterangeStart
	s inParam("daterangeEnd")=daterangeEnd

	s paramRows=$g(inParam("paramRows"))
	s paramCols=$g(inParam("paramCols"))
	s paramMeasure=$g(inParam("paramMeasure"))
	s daterangeItem=$g(inParam("daterangeItem"))
	
	s ret=..GetQrySummaryItem(.inParam,.outParam)
	
	s measureCnt=..GetStrNotNullCnt(paramMeasure,",")
	s meaCnt=$l(paramMeasure,",")
	f inx=1:1:meaCnt {
		s measure=$p(paramMeasure,",",inx)
		continue:$g(measure)=""
		s descript=##CLASS(DHCWL.BaseDataQuery.Util).GetBDQRptItemDesc(inParam("qryObjName"),measure)
		s ^||TEMPDHCWL("BDQ","MAPMEASUREDESC",measure)=descript
	}	
	
	if daterangeItem'="" && (ret'="") {
		s Data=$lb(ret,row2,row3,row4,row5,col1,col2,col3,col4,col5,valueDesc,value)
		d OuputRow1		
	}else{
		s len=$l(paramRows,",")
		s rowCnt=..GetStrNotNullCnt(paramRows,",")
		s colCnt=..GetStrNotNullCnt(paramCols,",")

		s rowCntV=""
		s meaCnt=$l(paramMeasure,",")

		s gNode=""
		f {
		
			s gNode=$o(^||TEMPDHCWL("BDQ","SUMGLOBAL",gNode))
			q:gNode=""
		
		
			f inx=1:1:meaCnt {
				s measureCol=$p(paramMeasure,",",inx)
				continue:$g(measureCol)=""
		
			/*
			s measureCol=""
			f {
				s measureCol=$o(^||TEMPDHCWL("BDQ","SUMGLOBAL",gNode,measureCol))
				q:$g(measureCol)=""
			*/
			
				s row1="",row2="",row3="",row4="",row5="",col1="",col2="",col3="",col4="",col5=""
				//$TRANSLATE

				if rowCnt>=1 && ($p(gNode,"&",1)'="") s row1=$TRANSLATE($p(gNode,"&",1),"'","")
				if rowCnt>=2 && ($p(gNode,"&",2)'="") s row2=$TRANSLATE($p(gNode,"&",2),"'","")
				if rowCnt>=3 && ($p(gNode,"&",3)'="") s row3=$TRANSLATE($p(gNode,"&",3),"'","")
				if rowCnt>=4 && ($p(gNode,"&",4)'="") s row4=$TRANSLATE($p(gNode,"&",4),"'","")
				if rowCnt>=5 && ($p(gNode,"&",5)'="") s row5=$TRANSLATE($p(gNode,"&",5),"'","")
			

				if colCnt>=1 && ($p(gNode,"&",rowCnt+1)'="") s col1=$TRANSLATE($p(gNode,"&",rowCnt+1),"'","")
				if colCnt>=2 && ($p(gNode,"&",rowCnt+2)'="") s col2=$TRANSLATE($p(gNode,"&",rowCnt+2),"'","")
				if colCnt>=3 && ($p(gNode,"&",rowCnt+3)'="") s col3=$TRANSLATE($p(gNode,"&",rowCnt+3),"'","")
				if colCnt>=4 && ($p(gNode,"&",rowCnt+4)'="") s col4=$TRANSLATE($p(gNode,"&",rowCnt+4),"'","")
				if colCnt>=5 && ($p(gNode,"&",rowCnt+5)'="") s col5=$TRANSLATE($p(gNode,"&",rowCnt+5)	,"'","")		
				s value=+$g(^||TEMPDHCWL("BDQ","SUMGLOBAL",gNode,measureCol))
				s valueDesc=^||TEMPDHCWL("BDQ","MAPMEASUREDESC",measureCol)

				s Data=$lb(row1,row2,row3,row4,row5,col1,col2,col3,col4,col5,valueDesc,value_","_inx)
				d OuputRow1
			}
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryGetSummaryItem2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGetSummaryItem2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryGetSummaryItem2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGetSummaryItem2Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 
/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:：   返回行式查询数据，被被润乾调用调用
/// Table：       	无
/// Input：         qryObjName：查询对象名称
/// 					paramRows：行显示项，
/// 					inPamRows：行显示项入参，
/// 					paramCols：列显示项，
/// 					inPamCols：列显示项入参，
/// 					paramMeasure：度量项，
/// 					paramMeasureDesc：度量项描述，
/// 					daterangeItem：日期口径，
/// 					daterangeStart：统计开始日期，
/// 					daterangeEnd：统计结束日期 ， 
/// 					filterIDs：过滤项 ， 
/// 					filterOperas：过滤操作符， 
/// 					filterValues：过滤值 ， 
/// 					inPamfilter：过滤项入参				
/// Output：        row1,row2,row3,row4,row5：行1-行5
/// 					col1,col2,col3,col4,col5：列1-列5
/// 					measureDesc：度量描述
/// 					measure：度量描述
/// Return：        
/// Others：
Query QryGetDetailItem(qryObjName As %String, paramCols As %Text, inPamCols As %Text, daterangeItem As %Text, daterangeStart As %Text, daterangeEnd As %Text, filterIDs As %Text, filterOperas As %Text, filterValues As %Text, inPamfilter As %Text, qryType As %String) As %Query(ROWSPEC = "rowData:%String,colData:%String,value:%String") [ SqlProc ]
{
}

ClassMethod QryGetDetailItemExecute(ByRef qHandle As %Binary, qryObjName As %String, paramCols As %Text, inPamCols As %Text, daterangeItem As %Text, daterangeStart As %Text, daterangeEnd As %Text, filterIDs As %Text, filterOperas As %Text, filterValues As %Text, inPamfilter As %Text, qryType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//k inParam
	k ^||TEMPDHCWL("BDQ")
	
	s inParam("actFrom")="http"
	
	s inParam("qryType")=qryType
	s inParam("paramCols")=paramCols
	s inParam("qryObjName")=qryObjName
	
	s inParam("inPamCols")=inPamCols
	s inParam("inPamfilter")=inPamfilter
	
	s inParam("daterangeItem")=daterangeItem
	s inParam("daterangeStart")=daterangeStart
	s inParam("daterangeEnd")=daterangeEnd

	
	s inParam("filterIDs")=filterIDs
	s inParam("filterOperas")=filterOperas
	s inParam("filterValues")=filterValues


		s ^DHCWLTEMP("previewDetailData","filterIDs")=inParam("filterIDs")
		s ^DHCWLTEMP("previewDetailData","filterOperas")=inParam("filterOperas")
		s ^DHCWLTEMP("previewDetailData","filterValues")=inParam("filterValues")
		
	s len=$l(paramCols,",")
	
	//建立表头描述
	for i=1:1:len {
		s col=$p(paramCols,",",i)
		continue:$g(col)=""
		s descript=##CLASS(DHCWL.BaseDataQuery.Util).GetBDQRptItemDesc(qryObjName,col)
		s ^||TEMPDHCWL("BDQ","HEADDESC",col)=descript
	}	
	
	if $g(inParam("qryType"))="aggregat" {
		s rptHead=$g(inParam("paramCols"))
		//保存表头顺序
		s headLen=$l(rptHead,",")
		for i=1:1:headLen {
			s col=$p(rptHead,",",i)
			s ^||TEMPDHCWL("BDQ","HEADORDER",col)=i		
		}
	
		d ##CLASS(DHCWL.BaseDataQuery.Util).GetQryDetailMeasureParam(.inParam)
		
		s Cols=inParam("paramCols")
		s dimCol=""
		f i=1:1:len {
			s col=$p(Cols,",",i)
			continue:$g(col)=""
			if dimCol="" s dimCol=col
			else  s dimCol=dimCol_","_col
		}
		
				
		s inParam("actFrom")="http"
		s paramMeasure=$g(inParam("paramMeasure"))
		S ret=..GetQrySummaryItem(.inParam,.outParam)
		if ret'="" q ret
	
		s dimColLen=$l(dimCol,",")
		s rowData=1
		s gNode=""
		f {
		
			s gNode=$o(^||TEMPDHCWL("BDQ","SUMGLOBAL",gNode))
			q:gNode=""
				
			f i=1:1:dimColLen {
				s col=$p(dimCol,",",i)
				s colInx=^||TEMPDHCWL("BDQ","HEADORDER",col)
				s colDesc=^||TEMPDHCWL("BDQ","HEADDESC",col)
				s cellV=$p(gNode,"&",i)
				s cellV=$TRANSLATE(cellV,"'")

				s colData=colDesc_","_colInx
				
				s Data=$lb(rowData,colData,cellV)
				d OuputRow1				
			}
					
			s measureCol=""
			s measJ=""
			s measureLen=$l(paramMeasure,",")
			f i=1:1:measureLen {
				s measureCol=$p(paramMeasure,",",i)
				continue:measureCol=""
				
				
				s measure=^||TEMPDHCWL("BDQ","SUMGLOBAL",gNode,measureCol)
				s colInx=^||TEMPDHCWL("BDQ","HEADORDER",measureCol)
				s colDesc=^||TEMPDHCWL("BDQ","HEADDESC",measureCol)
				s cellV=$TRANSLATE(measure,"'")
				s colData=colDesc_","_colInx
				s Data=$lb(rowData,colData,cellV)
				d OuputRow1	
			}
			s rowData=rowData+1
		}	
	}
	if $g(inParam("qryType"))="detail" {
		//s inParam("actFrom")="http"
		//s ret=##CLASS(DHCWL.BaseDataQuery.Interface).GetQryDetailItemJson(.inParam,.json)
		//得到明细查询结果
		s ret=..GetQryDetailItem(.inParam,.outParam)
		if ret'="" q ret
		//向JSON对象充填数据
		s dataOrder=""
		s rowData=1
		s displayCols=inParam("paramCols")	//报表栏
		s len=$l(displayCols,",")
		
		
		f {
			s dataOrder=$o(^||TEMPDHCWL("BDQ","DETAILGLOBAL",dataOrder))
			q:+dataOrder=0
			s value=$o(^||TEMPDHCWL("BDQ","DETAILGLOBAL",dataOrder,""))
	
			for i=1:1:len {
				s col=$p(displayCols,",",i)
				continue:$g(col)=""
				s colDesc=^||TEMPDHCWL("BDQ","HEADDESC",col)
				s cellV=$p(value,"&",i)
				s cellV=$TRANSLATE(cellV,"'")

				s colData=colDesc_","_i
				
				s Data=$lb(rowData,colData,cellV)
				d OuputRow1
			}
			s rowData=rowData+1
		}	
	}	

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryGetDetailItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGetDetailItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryGetDetailItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGetDetailItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/*
Query QryGetDetailItemByRpt(rptID As %String, daterangeStart As %Text, daterangeEnd As %Text) As %Query(ROWSPEC = "rowData:%String,colData:%String,value:%String") [ SqlProc ]
{
}

ClassMethod QryGetDetailItemByRptExecute(ByRef qHandle As %Binary, rptID As %String, daterangeStart As %Text, daterangeEnd As %Text) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//k inParam
	
	k ^||TEMPDHCWL("BDQ")
	
	if rptID="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	d ..GetRptCfgDataByID(rptID,.inParam)	
	s inParam("actFrom")="http"
	s inParam("daterangeStart")=daterangeStart
	s inParam("daterangeEnd")=daterangeEnd
	s inParam("rptID")=rptID
	
	s inParam("qryType")="detail"	//重写是否汇总字段。固定为detail
	s ^DHCWLTEMP("previewDetailData","filterIDs")=inParam("filterIDs")
	s ^DHCWLTEMP("previewDetailData","filterOperas")=inParam("filterOperas")
	s ^DHCWLTEMP("previewDetailData","filterValues")=inParam("filterValues")
		
	s len=$l(inParam("paramCols"),",")
	
	//建立表头描述
	for i=1:1:len {
		s col=$p(inParam("paramCols"),",",i)
		continue:$g(col)=""
		//s descript=##CLASS(DHCWL.BaseDataQuery.Util).GetBDQRptItemDesc(inParam("qryObjName"),col)
		//s descript=##CLASS(DHCWL.BaseDataQuery.Util).GetBDQRptColDesc(inParam("qryObjName"),col,inParam("col-type",col))
		s descript=##CLASS(DHCWL.BaseDataQuery.Util).GetBDQRptColDesc(.inParam,col)

		
		s ^||TEMPDHCWL("BDQ","HEADDESC",col)=descript
	}	
	
	if $g(inParam("qryType"))="aggregat" {
		s rptHead=$g(inParam("paramCols"))
		//保存表头顺序
		s headLen=$l(rptHead,",")
		for i=1:1:headLen {
			s col=$p(rptHead,",",i)
			s ^||TEMPDHCWL("BDQ","HEADORDER",col)=i		
		}
	
		d ##CLASS(DHCWL.BaseDataQuery.Util).GetQryDetailMeasureParam(.inParam)
		
		s Cols=inParam("paramCols")
		s dimCol=""
		f i=1:1:len {
			s col=$p(Cols,",",i)
			continue:$g(col)=""
			if dimCol="" s dimCol=col
			else  s dimCol=dimCol_","_col
		}
		
				
		s inParam("actFrom")="http"
		s paramMeasure=$g(inParam("paramMeasure"))
		S ret=..GetQrySummaryItem(.inParam,.outParam)
		if ret'="" q ret
	
		s dimColLen=$l(dimCol,",")
		s rowData=1
		s gNode=""
		f {
		
			s gNode=$o(^||TEMPDHCWL("BDQ","SUMGLOBAL",gNode))
			q:gNode=""
				
			f i=1:1:dimColLen {
				s col=$p(dimCol,",",i)
				s colInx=^||TEMPDHCWL("BDQ","HEADORDER",col)
				s colDesc=^||TEMPDHCWL("BDQ","HEADDESC",col)
				s cellV=$p(gNode,"&",i)
				s cellV=$TRANSLATE(cellV,"'")

				s colData=colDesc_","_colInx
				
				s Data=$lb(rowData,colData,cellV)
				d OuputRow1				
			}
					
			s measureCol=""
			s measJ=""
			s measureLen=$l(paramMeasure,",")
			f i=1:1:measureLen {
				s measureCol=$p(paramMeasure,",",i)
				continue:measureCol=""
				
				
				s measure=^||TEMPDHCWL("BDQ","SUMGLOBAL",gNode,measureCol)
				s colInx=^||TEMPDHCWL("BDQ","HEADORDER",measureCol)
				s colDesc=^||TEMPDHCWL("BDQ","HEADDESC",measureCol)
				s cellV=$TRANSLATE(measure,"'")
				s colData=colDesc_","_colInx
				s Data=$lb(rowData,colData,cellV)
				d OuputRow1	
			}
			s rowData=rowData+1
		}	
	}
	if $g(inParam("qryType"))="detail" {
		//s inParam("actFrom")="http"
		//s ret=##CLASS(DHCWL.BaseDataQuery.Interface).GetQryDetailItemJson(.inParam,.json)
		//得到明细查询结果
		s ret=..GetQryDetailItem(.inParam,.outParam)
		if ret'="" q ret
		//向JSON对象充填数据
		s dataOrder=""
		s rowData=1
		s displayCols=inParam("paramCols")	//报表栏
		s len=$l(displayCols,",")
		
		
		f {
			s dataOrder=$o(^||TEMPDHCWL("BDQ","DETAILGLOBAL",dataOrder))
			q:+dataOrder=0
			s value=$o(^||TEMPDHCWL("BDQ","DETAILGLOBAL",dataOrder,""))
	
			for i=1:1:len {
				s col=$p(displayCols,",",i)
				continue:$g(col)=""
				s colDesc=^||TEMPDHCWL("BDQ","HEADDESC",col)
				s cellV=$p(value,"&",i)
				s cellV=$TRANSLATE(cellV,"'")

				s colData=colDesc_","_i
				
				s Data=$lb(rowData,colData,cellV)
				d OuputRow1
			}
			s rowData=rowData+1
		}	
	}	

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryGetDetailItemByRptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGetDetailItemByRptExecute ]
{
	Quit $$$OK
}

ClassMethod QryGetDetailItemByRptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGetDetailItemByRptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}
*/
/// 
/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:：   返回行式查询数据，被被润乾调用调用
/// Table：       	无
/// Input：         qryObjName：查询对象名称
/// 					paramRows：行显示项，
/// 					inPamRows：行显示项入参，
/// 					paramCols：列显示项，
/// 					inPamCols：列显示项入参，
/// 					paramMeasure：度量项，
/// 					paramMeasureDesc：度量项描述，
/// 					daterangeItem：日期口径，
/// 					daterangeStart：统计开始日期，
/// 					daterangeEnd：统计结束日期 ， 
/// 					filterIDs：过滤项 ， 
/// 					filterOperas：过滤操作符， 
/// 					filterValues：过滤值 ， 
/// 					inPamfilter：过滤项入参				
/// Output：        row1,row2,row3,row4,row5：行1-行5
/// 					col1,col2,col3,col4,col5：列1-列5
/// 					measureDesc：度量描述
/// 					measure：度量描述
/// Return：        
/// Others：
Query QryGetDetailItemByRpt(rptID As %String, daterangeStart As %Text, daterangeEnd As %Text) As %Query(ROWSPEC = "rowData:%String,colData:%String,value:%String") [ SqlProc ]
{
}

ClassMethod QryGetDetailItemByRptExecute(ByRef qHandle As %Binary, rptID As %String, daterangeStart As %Text, daterangeEnd As %Text) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	k aryCfgData
	if rptID="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	//读取报表配置数据
	d ..GetDetailRptCfgByID(rptID,.aryCfgData)	
	//映射维度项，度量项与显示列的位置关系
	d ..MapColPos(.aryCfgData)
	d ..MapAlias(.aryCfgData)

	//根据配置数据，生成CQL语言
	s PCFormStr=..GetPCFormStr(.aryCfgData)			//得到cql中的from
	s PCDimsStr=..GetPCDimsStr(.aryCfgData)			//dims
	s PCMetricsStr=..GetPCMetricsStr(.aryCfgData)	//metrics
	s PCFilterStr=..GetPCFilterStr(.aryCfgData,daterangeStart,daterangeEnd)		//filter
	s PCSortStr=..GetPCSortTxtStr(.aryCfgData)		//sort
		
	s cql="rs1:{"_
            "from: "_PCFormStr_","_
            "dims : "_PCDimsStr_","_ //
            "metrics: "_PCMetricsStr_","_
            "filter: "_PCFilterStr_"," 
            _"sort:"_PCSortStr_","_
            "print:true,"_
            "};"
    
	
    //w !,cql
	s parser=##class(DHCWL.DM.Core.CQLParser).%New()
	s sc=parser.Parse(cql)
	If $$$ISERR(sc) {
		//s ret="Insert 'ReportCfgSub'对象失败:"_$System.Status.GetErrorText(sc)
			s colData="查询没有成功执行：解析失败！,1"
			s Data=$lb(1,colData,sc)
			d OuputRow1
			Set qHandle=$lb(0,repid,0)
			Quit $$$OK
	} 		
	s executor=##class(DHCWL.DM.Core.PhysicalExecutor).%New(parser)
	s sc=executor.Execute()
	If $$$ISERR(sc) {
			s colData="查询没有成功执行：执行失败！,1"
			s Data=$lb(1,colData,sc)
			d OuputRow1
			Set qHandle=$lb(0,repid,0)
			Quit $$$OK
	}	
	s it=executor.GetIterator("rs1")
	s rowData=1
	while (it.HasNext()){
		//输出维度
		if PCDimsStr'="" {
			s dims=$lts(it.CurDims(),"^")
			s dimsCnt=$l(dims,"^")

			f inx=1:1:dimsCnt {
				s cellV=$p(dims,"^",inx)
				s cellV=$TRANSLATE(cellV,"'")
				s subID=aryCfgData("sub","dimColOrder",inx)
				s colPos=aryCfgData("sub","showColOrder",subID)
				s colDesc=aryCfgData("sub","showColDesc",subID)
				s colData=colDesc_","_colPos

				s Data=$lb(rowData,colData,cellV)
				d OuputRow1
			}
		}
		
		//输出度量
		if PCMetricsStr'="" {
			s metrics=$lts(it.CurMetrics(),"^")
			s cnt=$l(metrics,"^")
			f inx=1:1:cnt {
				s cellV=$p(metrics,"^",inx)
				s cellV=$TRANSLATE(cellV,"'")
				s cellV=$FNUMBER(cellV,"",2)
				s subID=aryCfgData("sub","metricsColOrder",inx)
				s colPos=aryCfgData("sub","showColOrder",subID)
				s colDesc=aryCfgData("sub","showColDesc",subID)
				s colData=colDesc_","_colPos

				s Data=$lb(rowData,colData,cellV)
				d OuputRow1
			}		
		}
		s rowData=rowData+1
	  
	}
	d executor.Close()
	s executor=""


	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryGetDetailItemByRptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGetDetailItemByRptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryGetDetailItemByRptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGetDetailItemByRptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// ##CLASS(DHCWL.BaseDataQuery.Interface).GetRptCfgDataByID(52)
ClassMethod GetDetailRptCfgByID(rptID As %String, ByRef aryCfgData) As %String
{
	//1、得到报表配置项
	s rptObj=##class(DHCWL.BaseDataQuery.ReportCfg).%OpenId(rptID)
	s baseObjName=rptObj.BaseObjName
	s rptType=rptObj.Type
	
	s qryObj=##class(DHCWL.BaseDataQuery.QueryObj).GetByName(baseObjName)
	s themePath=qryObj.ThemeBaseID
	s aryCfgData("qry","themePath")=themePath		//主题路径
	s aryCfgData("rpt","baseObjName")=baseObjName	//查询对象名称
	s aryCfgData("rpt","rptType")=rptType			//报表类型
	s aryCfgData("rpt","ID")=rptID			//报表类型
	s aryCfgData("rpt","dateItem")=rptObj.DateItemName			//日期字段
	//2、得到统计项配置项
	s lstSubObj=##class(DHCWL.BaseDataQuery.ReportCfgSub).GetSubs(rptID)
	s lstSubCnt=lstSubObj.Count()
	s showColOrder=1		//列显示顺序
	f inx=1:1:lstSubCnt {
		s subObj=lstSubObj.GetAt(inx)
		s item=subObj.Item
		s type=subObj.Type
		s subID=subObj.%Id()
		if type="measure" || (type="col") || (type="colcustomMeasure") {
			s aryCfgData("sub","showColOrder",subID)=showColOrder	//显示列的顺序
			s desc=..GetBDQRptColDesc2(.aryCfgData,item,type)
			s aryCfgData("sub","showColDesc",subID)=desc			//显示列的描述
			s showColOrder=showColOrder+1
			
		}
		s aryCfgData("sub","type",type,subID)=item					//报表统计项内容
	}
	q ""
}

ClassMethod GetBDQRptColDesc2(ByRef aryCfgData, rptItem, type) As %String
{
	s baseObjName=aryCfgData("rpt","baseObjName")
	if (type="colcustomMeasure") {
		s rptId=aryCfgData("rpt","ID")
		s itemDesc=""
		&sql(SELECT Name into:itemDesc FROM DHCWL_BaseDataQuery.ReportCfgSub WHERE RptID =:rptId AND Item=:rptItem)
		q itemDesc
	}else{
		if (type="filter") {
			s rptItem=$p(rptItem,"^",2)
		}
		if (type="colOrder") {
			s rptItem=$p(rptItem,"^",1)
		}
		
		s rptItem=$p(rptItem,"(",1)
		s itemName=$p(rptItem,"->",1)
		s pro=$p(rptItem,"->",2)
		
	
		s itemDesc=""
		s linkDimCode=""
		&sql(SELECT ifnull(Descript,Name,Descript),LinkDimCode into :itemDesc,:linkDimCode FROM DHCWL_BaseDataQuery.Item WHERE QueryObjName= :baseObjName and Name=:itemName)
		if SQLCODE'=0 q "-无数据-"
		if linkDimCode="" || (pro="") q itemDesc
		s prodesc=""
		/*
		if linkDimCode="对象属性" {
			&sql(SELECT proDesc into :prodesc FROM DHCWL_BaseDataQuery.QryobjPro where proCode= :pro and BaseObjName= :baseObjName)
			q itemDesc_"->"_prodesc
		}else{
			&SQL(SELECT DimPro_Desc into :prodesc FROM DHCWL_MKPI.DHCWLDimProperty WHERE DimPro_Code=:pro AND dimpro_dimdr->KDT_CODE=:linkDimCode )
			q itemDesc_"->"_prodesc
		}*/
		//从powerCube里面取数属性
		s baseDimobj=##class(DHCWL.DM.T.DimBase).GetByPath(linkDimCode)
		s proObj=baseDimobj.GetProperty(pro)
		s prodesc=proObj.Name
		q itemDesc_"->"_prodesc
	}
}

// 得到cql中的from

ClassMethod GetPCFormStr(ByRef aryCfgData) As %String
{
	q aryCfgData("qry","themePath")
}

ClassMethod GetPCDimsStr(ByRef aryCfgData) As %String
{
	//s aryCfgData("sub","type",type,subID)=item
	s baseObjName=aryCfgData("rpt","baseObjName")
	s dims=""
	s subID=""
	f {
		s subID=$o(aryCfgData("sub","type","col",subID))
		q:subID=""
		s item=	aryCfgData("sub","type","col",subID)
		s item=$p(item,"(",1)
		s proPos=$FIND(item,"->")
		if proPos<=0 {		
			s itemObj=##class(DHCWL.BaseDataQuery.Item).GetItem(baseObjName,item)
			s itemType=itemObj.Type
			continue:itemType'="维度"
			if itemObj.SubType="custom" {
				s funP=itemObj.FunPara
				s themeDimCode=$p(funP,"|",1)
				s paras=$p(funP,"|",2)
				s item=themeDimCode_"("_paras_")"	
			}
		}elseif $d(aryCfgData("sub","alias",item)) {
			s alias=aryCfgData("sub","alias",item)
			s item=item_" As "_alias
		}
			
		

		i dims'="" s dims=dims_","
		s dims=dims_item
	}
	q dims
}

ClassMethod GetPCMetricsStr(ByRef aryCfgData) As %String
{
	//aryCfgData("sub","showColOrder",subID)
	//s aryCfgData("sub","type",type,subID)=item
	s baseObjName=aryCfgData("rpt","baseObjName")
	s metrics=""
	s subID=""
	f {
		s subID=$o(aryCfgData("sub","showColOrder",subID))
		q:subID=""
		s M=""
		if $d(aryCfgData("sub","type","col",subID)) {
			s item=	aryCfgData("sub","type","col",subID)
			s item=$p(item,"(",1)
			s proPos=$FIND(item,"->")
			if proPos<=0 {		
				s itemObj=##class(DHCWL.BaseDataQuery.Item).GetItem(baseObjName,item)
				s itemType=itemObj.Type
				if itemType="度量" {
					s M=item
				}
			}			
		}elseif $d(aryCfgData("sub","type","colcustomMeasure",subID)) {
			s M=aryCfgData("sub","type","colcustomMeasure",subID)
		}
		continue:M=""
		if $d(aryCfgData("sub","alias",M)) {
			s alias=aryCfgData("sub","alias",M)
			s M=M_" As "_alias
		}
		i metrics'="" s metrics=metrics_","
		s metrics=metrics_M
	}
	q metrics
}

ClassMethod GetPCFilterStr(ByRef aryCfgData, daterangeStart, daterangeEnd) As %String
{
	//q ""
	s ret=""
	s dateItem=aryCfgData("rpt","dateItem")
	s ret=""
	s dateRange=dateItem_" DateRange("_daterangeStart_","_daterangeEnd_")" 
	s subID=""
	f {
		s subID=$o(aryCfgData("sub","type","filter",subID))
		q:subID=""
		s item=	aryCfgData("sub","type","filter",subID)
		//^WorkLoad_ARPBL_DR^in^"1,2,3"^^
		
		s relOperator=$p(item,"^",1)	//关系运算符
		s operatorData=$p(item,"^",2)	//操作数
		s logicalOperator=$p(item,"^",3)	//逻辑运算符
		s filterV1=$p(item,"^",4)		//过滤值1
		s filterV2=$p(item,"^",5)		//过滤值2
		s arg=$p(item,"^",6)			//参数
			
		if relOperator="AND" {
			s relOperator="&&"
		}elseif relOperator="AND (" {
			s relOperator="&& ("
		}elseif relOperator="OR" {
			s relOperator="||"
		}elseif relOperator="OR (" {
			s relOperator="|| ("
		}
		
		if logicalOperator="between" {
			//s fStr=	relOperator_" "_operatorData_" between"_" "_filterV1_" and"_" "_filterV2
			s fStr=	relOperator_" "_operatorData_" between ( "_filterV1_","_filterV2_" )"
		}elseif logicalOperator="in" {
			s fStr=	relOperator_" "_operatorData_" contain(["_filterV1_"])"
		}elseif logicalOperator="is null" {
			s fStr=	relOperator_" "_operatorData_" isnull()"
		}elseif logicalOperator="is not null" {
			s fStr=	relOperator_" "_operatorData_" notnull()"
		}elseif logicalOperator="<>" {
			s fStr=	relOperator_" "_operatorData_" NE( "_filterV1_" )"
		}elseif relOperator=")" {
			s fStr=	relOperator
		}else{
			s fStr=	relOperator_" "_operatorData_" "_logicalOperator_" ("_filterV1_") "
		}
			
		s ret=ret_fStr
	}
	if ret="" s ret=dateRange
	else  s ret=dateRange_" && ("_ret_")"
	q ret
}

ClassMethod GetPCSortTxtStr(ByRef aryCfgData) As %String
{
	s sorts=""
	s subID=""
	f {
		s subID=$o(aryCfgData("sub","type","colOrder",subID))
		q:subID=""
		s item=	aryCfgData("sub","type","colOrder",subID)
		s orderItem=$p(item,"^",1)
		
		if $d(aryCfgData("sub","alias",orderItem)) {
			s alias=aryCfgData("sub","alias",orderItem)
			s orderItem=alias
		}
		
		
		s direction=$p(item,"^",2)
		if sorts'="" s sorts=sorts_","
		if direction="降序" {
			s sorts=sorts_orderItem_" as DESC"		
		}else {
			s sorts=sorts_orderItem_" as ASC"
		}
	}
	q sorts
}

ClassMethod GetPCGroupStr(ByRef aryCfgData) As %String
{
	//s aryCfgData("sub","type",type,subID)=item
	q ..GetPCDimsStr(aryCfgData)
}

ClassMethod MapColPos(ByRef aryCfgData) As %String
{
	/*
	s aryCfgData("qry","themePath")=themePath		//主题路径
	s aryCfgData("rpt","baseObjName")=baseObjName	//查询对象名称
	s aryCfgData("rpt","rptType")=rptType			//报表类型
	s aryCfgData("rpt","ID")=rptID			//报表类型
	s aryCfgData("rpt","dateItem")=qryObj.DateItemName			//日期字段
	
	s aryCfgData("sub","showColOrder",subID)=showColOrder	//显示列的顺序
	s aryCfgData("sub","showColDesc",subID)=desc			//显示列的描述
	s aryCfgData("sub","type",type,subID)=item					//报表统计项内容
	s aryCfgData("sub","dimColOrder",dimColOrder)=subID			//维度位置与统计项ID映射
	s aryCfgData("sub","metricsColOrder",metricsColOrder)=subID	//属性位置与统计项ID映射	
	*/
	s baseObjName=aryCfgData("rpt","baseObjName")
	s dimOrder=1
	s metricsOrder=1
	s metrics=""
	s subID=""
	f {
		s subID=$o(aryCfgData("sub","showColOrder",subID))
		q:subID=""
		if $d(aryCfgData("sub","type","col",subID)) {
			s item=	aryCfgData("sub","type","col",subID)
			s item=$p(item,"(",1)
			s proPos=$FIND(item,"->")
			if proPos<=0 {		
				s itemObj=##class(DHCWL.BaseDataQuery.Item).GetItem(baseObjName,item)
				s itemType=itemObj.Type
				if itemType="度量" {
					s aryCfgData("sub","metricsColOrder",metricsOrder)=subID
					s metricsOrder=metricsOrder+1
				}else{
					s aryCfgData("sub","dimColOrder",dimOrder)=subID
					s dimOrder=dimOrder+1							
				}
			}else{
				s aryCfgData("sub","dimColOrder",dimOrder)=subID
				s dimOrder=dimOrder+1													
			}			
		}elseif $d(aryCfgData("sub","type","colcustomMeasure",subID)) {
				s aryCfgData("sub","metricsColOrder",metricsOrder)=subID
				s metricsOrder=metricsOrder+1
		}
	}
}

ClassMethod MapAlias(ByRef aryCfgData) As %String
{
	//aryCfgData("sub","showColOrder",subID)
	//s aryCfgData("sub","type",type,subID)=item
	s baseObjName=aryCfgData("rpt","baseObjName")
	s subID=""
	f {
		s subID=$o(aryCfgData("sub","showColOrder",subID))
		q:subID=""
		s M=""
		if $d(aryCfgData("sub","type","colcustomMeasure",subID)) {
			s M=aryCfgData("sub","type","colcustomMeasure",subID)
			//continue:M=""
			s aryCfgData("sub","alias",M)="myAs"_subID
		}elseif $d(aryCfgData("sub","type","col",subID)) {
			s item=	aryCfgData("sub","type","col",subID)
			s item=$p(item,"(",1)
			s proPos=$FIND(item,"->")
			if proPos>0 {
				s aryCfgData("sub","alias",item)="myAs"_subID
			}
		}
	}
}

/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:： 将查询对象的查询结果导出到%ListOfObjects
/// Table：       	DHCWL_BaseDataQuery.ReportCfg
/// Input：         rptName：报表名称，startDate：开始日期，endDate：结束日期
/// 					
/// Output：        无。
/// Return：        %ListOfObjects
/// Others：
ClassMethod ExtBDQDataToList(rptName As %String, startDate As %String, endDate As %String) As %ListOfObjects
{
	s dataList=##class(%Library.ListOfObjects).%New()
	if '$d(^DHCWL.BaseDataQuery.ReportCfgI("InxName",rptName)) q dataList

	s rptID=""
	s baseObjName=""
	s dateItemName=""
	s Name=""
	s IsAggregat=""
	s rptTypt=""
	s jsonDeli="&"

	s item=""
	s type=""
	s itemID=""
	
	k ^||TEMPDHCWL("BDQ")
	
	&sql(SELECT BaseObjName, DateItemName, IsAggregat,ID,Type into :baseObjName,:dateItemName,:IsAggregat,:rptID,:rptType FROM DHCWL_BaseDataQuery.ReportCfg WHERE Name = :rptName)

	if SQLCODE'=0 {
		q dataList
	}
	
	s inParam("qryObjName")=baseObjName
	s inParam("qryType")=IsAggregat
	s inParam("daterangeItem")=dateItemName
	s inParam("daterangeStart")=startDate
	s inParam("daterangeEnd")=endDate
	s inParam("limit")=0
	s inParam("end")=0
	s inParam("start")=0	

	&sql(
		DECLARE C1 CURSOR FOR
		SELECT %ID,Item, Type 
		into :rptID,:item,:type 
		FROM DHCWL_BaseDataQuery.ReportCfgSub
		WHERE RptID = :rptID
	)

	&sql(OPEN C1)
	&sql(FETCH C1)
	s colInx=0
	
	While (SQLCODE = 0) {
		
		s paramItem = $p(item,"(",1)
		s inP=$p($p(item,"(",2),")",1)

		s filterOpera=""
		s filterValue=""
		s colInx=colInx+1
		if $F(item,"^")>0 {
			s filterOpera=$p(item,"^",2)
			s filterValue=$p(item,"^",3)
		}
		
		if type="row" {
			//暂时无需处理
		}elseif type="col" {
			if $g(inParam("paramCols"))'="" {
				s inParam("paramCols")=inParam("paramCols")_","
				s inParam("inPamCols")=inParam("inPamCols")_","
				
			}
			s inParam("paramCols")=$g(inParam("paramCols"))_paramItem
			s inParam("inPamCols")=$g(inParam("inPamCols"))_inP	
			s ^||TEMPDHCWL("BDQ","DISPLAYORDERCOL",paramItem) =colInx 					
		}elseif type="filter" {
			if $g(inParam("filterIDs"))'="" {
				s inParam("filterIDs")=inParam("filterIDs")_","
				s inParam("inPamfilter")=inParam("inPamfilter")_","
				s inParam("filterOperas")=inParam("filterOperas")_","
				s inParam("filterValues")=inParam("filterValues")_","
			}
			s inParam("filterIDs")=$g(inParam("filterIDs"))_paramItem
			s inParam("inPamfilter")=$g(inParam("inPamfilter"))_inP
			
			s inParam("filterOperas")=$g(inParam("filterOperas"))_filterOpera
			s inParam("filterValues")=$g(inParam("filterValues"))_filterValue

		}elseif type="measure" {
			//暂时无需处理
		}
		&sql(FETCH C1)
	}

	&sql(CLOSE C1)
	
	
	
	if rptType'="grpRpt" q dataList
	//分组查询
	if IsAggregat=1 {	
		d ##CLASS(DHCWL.BaseDataQuery.Util).GetQryDetailMeasureParam(.inParam)
		s paramRows=$g(inParam("paramRows"))
		s paramCols=$g(inParam("paramCols"))
		s paramMeasure=$g(inParam("paramMeasure"))
	
		d ..GetQrySummaryItem(.inParam,.outParam)	
		s displayCols=$g(paramRows)_","_$g(paramCols)_","_$g(paramMeasure)
		s len=$l(displayCols,",")
		s jsonDeli="&"

		s colInx=0
		f i=1:1:len {
			s col=$p(displayCols,",",i)
			continue:$g(col)=""
			s colInx=colInx+1
			s ^||TEMPDHCWL("BDQ","DATAORDERCOL",colInx) = col	
		}

		s gNode=""
		f {
			s gNode=$o(^||TEMPDHCWL("BDQ","SUMGLOBAL",gNode))
			q:gNode=""
			
			s strRec=""
			s recList=##class(%Library.ListOfDataTypes).%New()
			s nodeLen=$l(gNode,jsonDeli)
			f inx=1:1:nodeLen {
				s v=$p(gNode,jsonDeli,inx)
				s col=^||TEMPDHCWL("BDQ","DATAORDERCOL",inx)
				s displayInx=^||TEMPDHCWL("BDQ","DISPLAYORDERCOL",col)
					
				s $p(strRec,"^",displayInx)=v
			}
			
			s measureCol=""
			s measJ=""
			s measureLen=$l(paramMeasure,jsonDeli)
			f i=1:1:measureLen {
				s measureCol=$p(paramMeasure,jsonDeli,i)
				continue:measureCol=""
				s v=+$g(^||TEMPDHCWL("BDQ","SUMGLOBAL",gNode,measureCol))
				s displayInx=^||TEMPDHCWL("BDQ","DISPLAYORDERCOL",measureCol)
				s $p(strRec,"^",displayInx)=v
			}	
			
			s strRec=$TRANSLATE(strRec,"'","")
			f i=1:1:$l(strRec,"^") {
				s element = $p(strRec,"^",i)
				d recList.Insert(element)		
			}
			d dataList.Insert(recList)	
		}

	//网格查询			
	}else {
		
		d ..GetQryDetailItem(.inParam,.outParam)
		s dataOrder=""
		f {
			s dataOrder=$o(^||TEMPDHCWL("BDQ","DETAILGLOBAL",dataOrder))
			q:+dataOrder=0
			s recList=##class(%Library.ListOfDataTypes).%New()
			s value=$o(^||TEMPDHCWL("BDQ","DETAILGLOBAL",dataOrder,""))
			s value=$TRANSLATE(value	,"'","")
			
			f i=1:1:$l(value,jsonDeli) {
				s element=$p(value,jsonDeli,i)
				d recList.Insert(element)
			}
			
			d dataList.Insert(recList)
		}		
	}
	
	q dataList
}

/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:： 将查询对象的查询结果导出到global
/// Table：       	DHCWL_BaseDataQuery.ReportCfg
/// Input：         rptName：报表名称，startDate：开始日期，endDate：结束日期
/// 					
/// Output：        无。
/// Return：        无。
/// Others：
ClassMethod ExtBDQDataToGlobal(rptName As %String, startDate As %String, endDate As %String)
{
	if '$d(^DHCWL.BaseDataQuery.ReportCfgI("InxName",rptName)) q dataList

	s rptID=""
	s baseObjName=""
	s dateItemName=""
	s Name=""
	s IsAggregat=""
	s rptTypt=""
	s jsonDeli="&"

	s item=""
	s type=""
	s itemID=""
	
	k ^||TEMPDHCWL("BDQ")
	
	&sql(SELECT BaseObjName, DateItemName, IsAggregat,ID,Type into :baseObjName,:dateItemName,:IsAggregat,:rptID,:rptType FROM DHCWL_BaseDataQuery.ReportCfg WHERE Name = :rptName)

	if SQLCODE'=0 {
		q dataList
	}
	
	s inParam("qryObjName")=baseObjName
	s inParam("qryType")=IsAggregat
	s inParam("daterangeItem")=dateItemName
	s inParam("daterangeStart")=startDate
	s inParam("daterangeEnd")=endDate
	s inParam("limit")=0
	s inParam("end")=0
	s inParam("start")=0	

	&sql(
		DECLARE C2 CURSOR FOR
		SELECT %ID,Item, Type 
		into :rptID,:item,:type 
		FROM DHCWL_BaseDataQuery.ReportCfgSub
		WHERE RptID = :rptID
	)

	&sql(OPEN C2)
	&sql(FETCH C2)
	s colInx=0
	
	While (SQLCODE = 0) {
		
		s paramItem = $p(item,"(",1)
		s inP=$p($p(item,"(",2),")",1)

		s filterOpera=""
		s filterValue=""
		s colInx=colInx+1
		if $F(item,"^")>0 {
			s filterOpera=$p(item,"^",2)
			s filterValue=$p(item,"^",3)
		}
		
		if type="row" {
			//暂时无需处理
		}elseif type="col" {
			if $g(inParam("paramCols"))'="" {
				s inParam("paramCols")=inParam("paramCols")_","
				s inParam("inPamCols")=inParam("inPamCols")_","
				
			}
			s inParam("paramCols")=$g(inParam("paramCols"))_paramItem
			s inParam("inPamCols")=$g(inParam("inPamCols"))_inP	
			s ^||TEMPDHCWL("BDQ","DISPLAYORDERCOL",paramItem) =colInx 					
		}elseif type="filter" {
			if $g(inParam("filterIDs"))'="" {
				s inParam("filterIDs")=inParam("filterIDs")_","
				s inParam("inPamfilter")=inParam("inPamfilter")_","
				s inParam("filterOperas")=inParam("filterOperas")_","
				s inParam("filterValues")=inParam("filterValues")_","
			}
			s inParam("filterIDs")=$g(inParam("filterIDs"))_paramItem
			s inParam("inPamfilter")=$g(inParam("inPamfilter"))_inP
			
			s inParam("filterOperas")=$g(inParam("filterOperas"))_filterOpera
			s inParam("filterValues")=$g(inParam("filterValues"))_filterValue

		}elseif type="measure" {
			//暂时无需处理
		}
		&sql(FETCH C2)
	}

	&sql(CLOSE C2)
	
	
	
	if rptType'="grpRpt" {
		w !,"网格，分组报表可以导出；交叉报表不支持导出！"
		
		q dataList
	}
	//分组查询
	if IsAggregat=1 {	
		d ##CLASS(DHCWL.BaseDataQuery.Util).GetQryDetailMeasureParam(.inParam)
		s paramRows=$g(inParam("paramRows"))
		s paramCols=$g(inParam("paramCols"))
		s paramMeasure=$g(inParam("paramMeasure"))
	
		d ..GetQrySummaryItem(.inParam,.outParam)	
		s displayCols=$g(paramRows)_","_$g(paramCols)_","_$g(paramMeasure)
		s len=$l(displayCols,",")
		s jsonDeli="&"

		s colInx=0
		f i=1:1:len {
			s col=$p(displayCols,",",i)
			continue:$g(col)=""
			s colInx=colInx+1
			s ^||TEMPDHCWL("BDQ","DATAORDERCOL",colInx) = col	
		}

		s gNode=""
		s extRecCnt=0
		f {
			s gNode=$o(^||TEMPDHCWL("BDQ","SUMGLOBAL",gNode))
			q:gNode=""
			
			s strRec=""
			s recList=##class(%Library.ListOfDataTypes).%New()
			s nodeLen=$l(gNode,jsonDeli)
			f inx=1:1:nodeLen {
				s v=$p(gNode,jsonDeli,inx)
				s col=^||TEMPDHCWL("BDQ","DATAORDERCOL",inx)
				s displayInx=^||TEMPDHCWL("BDQ","DISPLAYORDERCOL",col)
					
				//s $p(strRec,"^",displayInx)=v
				s $p(strRec,jsonDeli,displayInx)=v
			}
			
			s measureCol=""
			s measJ=""
			//s measureLen=$l(paramMeasure,jsonDeli)
			s measureLen=$l(paramMeasure,",")
			f i=1:1:measureLen {
				s measureCol=$p(paramMeasure,",",i)
				continue:measureCol=""
				s v=+$g(^||TEMPDHCWL("BDQ","SUMGLOBAL",gNode,measureCol))
				s displayInx=^||TEMPDHCWL("BDQ","DISPLAYORDERCOL",measureCol)
				//s $p(strRec,"^",displayInx)=v
				s $p(strRec,jsonDeli,displayInx)=v
			}	
			
			s strRec=$TRANSLATE(strRec,"'","")
			s extRecCnt=extRecCnt+1
			s ^||TEMPDHCWL("BDQ","EXTSUMGLOBAL",extRecCnt)=strRec

		}

	//网格查询			
	}else {
		s extRecCnt=0
		d ..GetQryDetailItem(.inParam,.outParam)
		s dataOrder=""
		f {
			s dataOrder=$o(^||TEMPDHCWL("BDQ","DETAILGLOBAL",dataOrder))
			q:+dataOrder=0
			//s recList=##class(%Library.ListOfDataTypes).%New()
			s value=$o(^||TEMPDHCWL("BDQ","DETAILGLOBAL",dataOrder,""))
			s value=$TRANSLATE(value	,"'","")
			
			s extRecCnt=extRecCnt+1
			s ^||TEMPDHCWL("BDQ","EXTSUMGLOBAL",extRecCnt)=value
			

		}		
	}
	
	//q dataList
}

/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:： 将查询对象的查询结果导出到txt文件
/// Table：       	DHCWL_BaseDataQuery.ReportCfg
/// Input：         rptName：报表名称，startDate：开始日期，endDate：结束日期，filePath：文件路径，fieldDeli：字段分隔符
/// 					
/// Output：        无。
/// Return：        无。
/// Others：
ClassMethod ExtBDQDataToTxtFile(rptName As %String, startDate As %String, endDate As %String, filePath As %String, fieldDeli As %String = ":") As %String
{
	s $zt="fileErr"
	If ##class(%File).Exists(filePath) {
		Write "The file EXISTS! Export file is not complete! ",!
		q ""
	}
	
	/*
	s datalist=##CLASS(DHCWL.BaseDataQuery.Interface).ExtBDQDataToList(rptName,startDate,endDate)
	w !,"开始写文件..."
	s cnt=0
	For i=1:1:datalist.Count() {
		s lineData=""
		s rec=datalist.GetAt(i)
		for j=1:1:rec.Count() {
			if lineData'="" s lineData=lineData_fieldDeli
			s lineData=lineData_rec.GetAt(j)
		}
		
		Do file.WriteLine(lineData)
		s cnt=cnt+1
	}
	*/

	d ..ExtBDQDataToGlobal(rptName,startDate,endDate)
	Set file=##class(%File).%New(filePath)
	Do file.Open("WSN")
	s jsonDeli="&"
	s extRecInx=""
	f {
		s extRecInx=$o(^||TEMPDHCWL("BDQ","EXTSUMGLOBAL",extRecInx))
		q:$g(extRecInx)=""
		s lineData=^||TEMPDHCWL("BDQ","EXTSUMGLOBAL",extRecInx)
		s lineData=$tr(lineData,jsonDeli,fieldDeli)
		Do file.WriteLine(lineData)
		//Do file.WriteLine($C(10))
		Do file.WriteLine($C(13))	//在unix上导出时，需额外输出一个回车符
		
	}
	
	
	do file.Close()
	w !,"写文件完成，共生成"_+$o(^||TEMPDHCWL("BDQ","EXTSUMGLOBAL",""),-1)_"行数据！"
	q ""

fileErr
	w !,"写文件失败："_$ZERROR

	q $ZERROR
}

/*
	导出到global
	^TEMPDHCWL("DHCWLBaseqry")
	*/

// d ##class(DHCWL.BaseDataQuery.Interface).ExpQryObj2Global()

/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:： 将查询对象转换为global
/// Table：       	DHCWL_BaseDataQuery.ReportCfg
/// Input：         	
/// Output：        无。
/// Return：        无。
/// Others
ClassMethod ExpQryObj2Global() As %String
{
	k ^DHCWL.BaseDataQuery.Exp("DHCWLBaseqry")
	//导出查询对象DHCWL_BaseDataQuery.QueryObj
	s qryObjID=""
	s inx=0
	f {
		s qryObjID=$o(^DHCWL.BaseDataQuery.QueryObjD(qryObjID))
		q:$g(qryObjID)=""
		s qryObj=##class(DHCWL.BaseDataQuery.QueryObj).%OpenId(qryObjID)
		s inx=inx+1
	 	s ^DHCWL.BaseDataQuery.Exp("DHCWLBaseqry","QueryObj",inx)=qryObj.BaseObjName_"^"_qryObj.BaseObjDesc
	 	d qryObj.%Close()
	}
	//导出查询对象DHCWL.BaseDataQuery.Item
	s itemID=""
	s inx=0
	f {
		s itemID=$o(^DHCWL.BaseDataQuery.ItemD(itemID))
		q:$g(itemID)=""
		s itemObj=##class(DHCWL.BaseDataQuery.Item).%OpenId(itemID)
		s inx=inx+1
	 	s ^DHCWL.BaseDataQuery.Exp("DHCWLBaseqry","Item",inx)=itemObj.QueryObjName_"^"_itemObj.Descript_"^"_itemObj.Name_"^"_itemObj.Type_"^"_itemObj.LinkDimType_"^"_itemObj.LinkDimCode_"^"_itemObj.PiecePos_"^"_itemObj.ColType
	 	d qryObj.%Close()
	}
	
	//导出查询对象DHCWL.BaseDataQuery.QryobjPro
	s proID=""
	s inx=0
	f {
		s proID=$o(^DHCWL.BaseDataQuery.QryobjProD(proID))
		q:$g(proID)=""
		s proObj=##class(DHCWL.BaseDataQuery.QryobjPro).%OpenId(proID)
		s inx=inx+1
	 	s ^DHCWL.BaseDataQuery.Exp("DHCWLBaseqry","Pro",inx)=proObj.BaseObjName_"^"_proObj.proCode_"^"_proObj.proName_"^"_proObj.proDesc_"^"_proObj.proExeCode
	 	d qryObj.%Close()
	}
}

/// Creator：      王峥
/// CreatDate：    2017-12-25
/// Description:： 将配置好的表转换为global
/// Table：       	DHCWL_BaseDataQuery.ReportCfg
/// Input：         	
/// Output：        无。
/// Return：        无。
/// Others：d ##class(DHCWL.BaseDataQuery.Interface).ExpRpt2Global()
ClassMethod ExpRpt2Global() As %String
{
	k ^DHCWL.BaseDataQuery.Exp2("DHCWLBaseqry")
	//导出报表对象DHCWL_BaseDataQuery.QueryObj
	s rptID=""
	s inx=0
	f {
		s rptID=$o(^DHCWL.BaseDataQuery.ReportCfgD(rptID))
		q:$g(rptID)=""
		s rptObj=##class(DHCWL.BaseDataQuery.ReportCfg).%OpenId(rptID)
		s inx=inx+1
	 	s ^DHCWL.BaseDataQuery.Exp2("DHCWLBaseqry","Rpt",inx)=rptObj.BaseObjName_"^"_rptObj.Name_"^"_rptObj.DateItemName_"^"_rptObj.Type_"^"_rptObj.IsAggregat_"^"_rptObj.userID_"^"_rptObj.Remarks
	 	s subInx=0
	 	s item=""
	 	f {
		 	s item=$o(^DHCWL.BaseDat9E76.ReportCfgSubI("InxRptNameItem",rptID,item))
		 	q:item=""
		 	continue:'$d(^DHCWL.BaseDataQuery.ItemI("QueryObjNameIndex",rptObj.BaseObjName,$p(item,"(",1)))
		 	
		 	s subID=$o(^DHCWL.BaseDat9E76.ReportCfgSubI("InxRptNameItem",rptID,item,""))
		 	s subObj=##class(DHCWL.BaseDataQuery.ReportCfgSub).%OpenId(subID)
		 	s subInx=subInx+1
		 	//导出报表明细对象DHCWL.BaseDataQuery.ReportCfgSub
		 	s ^DHCWL.BaseDataQuery.Exp2("DHCWLBaseqry","Rpt",inx,subInx)=subObj.Item_"^"_subObj.Type
		 	d subObj.%Close()
	 	}
	 	
	 	d rptObj.%Close()
	}
}

/*
	从global导入
	参数：
		A-添加。如果QueryObj或Item或QryobjPro表没有记录，则导入新记录。导入的数据从global：^DHCWL.BaseDataQuery.Exp("DHCWLBaseqry")中读取
		U-更新。如果QueryObj或Item或QryobjPro表有记录，则更新这些记录。更新的数据从global：^DHCWL.BaseDataQuery.Exp("DHCWLBaseqry")中读取
	*/

// d ##class(DHCWL.BaseDataQuery.Interface).ImpGlobal2QryObj("AU")

/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:： 把数据从global导入转换成查询对象
/// Table：       	DHCWL_BaseDataQuery.ReportCfg
/// Input：         	
/// Output：        无。
/// Return：        空字符串——成功执行；其他字符串——错误提示
/// Others
ClassMethod ImpGlobal2QryObj(type As %String) As %String
{
	s $zt="SQLErr"
	s ret=""
	TSTART
	s addAct=($F(type,"A")>0)
	s updateAct=($F(type,"U")>0)
	k ^||TEMPDHCWL("DHCWLBaseqry","NewQueryObj")
	//导入查询对象DHCWL_BaseDataQuery.QueryObj
	s inx=0
	f {
		s inx=$o(^DHCWL.BaseDataQuery.Exp("DHCWLBaseqry","QueryObj",inx))
		q:$g(inx)=""
		s data=^DHCWL.BaseDataQuery.Exp("DHCWLBaseqry","QueryObj",inx)
		//BaseObjNameIndex
		s BaseObjName=$p(data,"^",1)
		s BaseObjDesc=$p(data,"^",2)
		s rowid=$o(^DHCWL.BaseDataQuery.QueryObjI("BaseObjNameIndex",BaseObjName,""))

		if $g(rowid)="" {
			if (addAct=1) {
				
				Set Rs = ##class(%ResultSet).%New()
				s Sql="SELECT TOP 1* FROM "_BaseObjName
				s st=Rs.Prepare(Sql) 
				Set columns = Rs.GetColumnCount()
				Do Rs.Close()	
				continue:columns<=0			
				
				s newObj=##class(DHCWL.BaseDataQuery.QueryObj).%New()
				s newObj.BaseObjName=BaseObjName
				s newObj.BaseObjDesc=BaseObjDesc
				
				s sc=newObj.%Save()
				If $$$ISERR(sc) {
					s ret="新建查询对象失败:"_$System.Status.GetErrorText(sc)
			 	}
			 	
				d newObj.%Close()	
				s ^||TEMPDHCWL("DHCWLBaseqry","NewQueryObj",BaseObjName)=""			
			}		
		}else {
			if (updateAct=1) {
				s newObj=##class(DHCWL.BaseDataQuery.QueryObj).%OpenId(rowid)
				s newObj.BaseObjName=BaseObjName
				s newObj.BaseObjDesc=BaseObjDesc
				
				s sc=newObj.%Save()
				If $$$ISERR(sc) {
					s ret="更新查询对象失败:"_$System.Status.GetErrorText(sc)
			 	}
				d newObj.%Close()					
			}
		}
	}
	
	//得到新的统计项
	k ^||TEMPDHCWL("DHCWLBaseqry","NewItem")
	s objName=""
	f {
		s objName=$o(^||TEMPDHCWL("DHCWLBaseqry","NewQueryObj",objName))
		q:$g(objName)=""
		Set Rs = ##class(%ResultSet).%New()
		s Sql="SELECT TOP 1* FROM "_objName
		s st=Rs.Prepare(Sql) 

		Set columns = Rs.GetColumnCount()
		For col = 1:1:columns {
			s colName= Rs.GetColumnName(col)
			s ^||TEMPDHCWL("DHCWLBaseqry","NewItem",objName,colName)=""
		}
		Do Rs.Close()		
	}
	
	
	//导入查询对象DHCWL.BaseDataQuery.Item
	s inx=0
	f {
		s inx=$o(^DHCWL.BaseDataQuery.Exp("DHCWLBaseqry","Item",inx))
		q:$g(inx)=""
		s data=^DHCWL.BaseDataQuery.Exp("DHCWLBaseqry","Item",inx)
		s QueryObjName=$p(data,"^",1)
		s Name=$p(data,"^",3)
		s rowid=$o(^DHCWL.BaseDataQuery.ItemI("QueryObjNameIndex",QueryObjName,Name,""))

		k newObj
		if $g(rowid)="" {
			if (addAct=1) {
				if $d(^||TEMPDHCWL("DHCWLBaseqry","NewItem",QueryObjName,Name)) {
					s newObj=##class(DHCWL.BaseDataQuery.Item).%New()
				}
			}		
		}else {
			if (updateAct=1) {
				s newObj=##class(DHCWL.BaseDataQuery.Item).%OpenId(rowid)
			}
		}
		
		if ($d(newObj) && $ISOBJECT(newObj)) {
			s newObj.QueryObjName=$p(data,"^",1)
			s newObj.Descript=$p(data,"^",2)
			s newObj.Name=$p(data,"^",3)
			s newObj.Type=$p(data,"^",4)
			s newObj.LinkDimType=$p(data,"^",5)
			s newObj.LinkDimCode=$p(data,"^",6)
			s newObj.PiecePos=$p(data,"^",7)
			s newObj.ColType=$p(data,"^",8)
			
			s sc=newObj.%Save()
			If $$$ISERR(sc) {
				s ret="新建统计项失败:"_$System.Status.GetErrorText(sc)
				q
		 	}
		 	d newObj.%Close()			
		}
	}
	
	//导入查询对象DHCWL.BaseDataQuery.QryobjPro
	s inx=0
	f {
		s inx=$o(^DHCWL.BaseDataQuery.Exp("DHCWLBaseqry","Pro",inx))
		q:$g(inx)=""
		s data=^DHCWL.BaseDataQuery.Exp("DHCWLBaseqry","Pro",inx)
		s BaseObjName=$p(data,"^",1)
		s proCode=$p(data,"^",2)
		s rowid=$o(^DHCWL.BaseDataQuery.QryobjProI("InxQryobjCode",BaseObjName,proCode,""))

		k newObj
		if $g(rowid)="" {
			if (addAct=1) {
				s newObj=##class(DHCWL.BaseDataQuery.QryobjPro).%New()
			}		
		}else {
			if (updateAct=1) {
				s newObj=##class(DHCWL.BaseDataQuery.QryobjPro).%OpenId(rowid)
			}
		}
		
		if ($d(newObj) && $ISOBJECT(newObj)) {
			s newObj.BaseObjName=$p(data,"^",1)
			s newObj.proCode=$p(data,"^",2)
			s newObj.proName=$p(data,"^",3)
			s newObj.proDesc=$p(data,"^",4)
			s newObj.proExeCode=$p(data,"^",5)			
			s sc=newObj.%Save()
			If $$$ISERR(sc) {
				s ret="新建属性项失败:"_$System.Status.GetErrorText(sc)
				q
		 	}
		 	d newObj.%Close()			
		}
	}
	
	k ^DHCWL.BaseDataQuery.Exp("DHCWLBaseqry")
	TCOMMIT
	q ret

SQLErr
	
	//q ret
	Trollback
	q ret
}

/// Creator：      王峥
/// CreatDate：    2017-12-25
/// Description:： 把数据从global导入转换成报表对象
/// Table：       	DHCWL_BaseDataQuery.ReportCfg
/// Input：         	
/// Output：        无。
/// Return：        空字符串——成功执行；其他字符串——错误提示
/// Others d ##class(DHCWL.BaseDataQuery.Interface).ImpGlobal2RptObj()
ClassMethod ImpGlobal2RptObj() As %String
{
	s $zt="SQLErr"
	s ret=""
	s userID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$SYSTEM.SQL.ALPHAUP("stat"),""))
	TSTART
	//导入报表对象DHCWL_BaseDataQuery.QueryObj
	s inx=0
	f {
		s inx=$o(^DHCWL.BaseDataQuery.Exp2("DHCWLBaseqry","Rpt",inx))
		q:$g(inx)=""
		s data=^DHCWL.BaseDataQuery.Exp2("DHCWLBaseqry","Rpt",inx)
		
		s inParam("qryObjName")=$p(data,"^",1)
		s inParam("rptName")=$p(data,"^",2)
		s inParam("daterangeItem")=$p(data,"^",3)
		s inParam("rptType")=$p(data,"^",4)
		s inParam("IsAggregat")=$p(data,"^",5)
		s inParam("userID")=userID
		s inParam("Remarks")=$p(data,"^",7)
		continue:'$d(^DHCWL.BaseDataQuery.QueryObjI("BaseObjNameIndex",inParam("qryObjName")))
		s ret=##class(DHCWL.BaseDataQuery.ReportCfg).Insert(.inParam,.outParam)
		if ret'="" {
			TROLLBACK
			q
		}
		s subInx=""
		s rptID=inParam("RptID")
		k inParam
		f {
			s subInx=$o(^DHCWL.BaseDataQuery.Exp2("DHCWLBaseqry","Rpt",inx,subInx))
			q:subInx=""
			s data=^DHCWL.BaseDataQuery.Exp2("DHCWLBaseqry","Rpt",inx,subInx)		
			s newObj=##class(DHCWL.BaseDataQuery.ReportCfgSub).%New()
			s newObj.RptID=rptID
			s newObj.Item=$p(data,"^",1)
			s newObj.Type=$p(data,"^",2)
			s sc=newObj.%Save()
			If $$$ISERR(sc) {
				s ret="Insert 'ReportCfgSub'对象失败:"_$System.Status.GetErrorText(sc)
				TROLLBACK
	 		}
	 		d newObj.%Close()	
	 		q:ret'=""		
		}
	}

	
	if ret="" {
		TCOMMIT
		k ^DHCWL.BaseDataQuery.Exp2("DHCWLBaseqry")
	}
	q ret

SQLErr
	
	//q ret
	Trollback
	q ret
}

/// ##CLASS(DHCWL.BaseDataQuery.Interface).GetRptCfgDataByID(52)
ClassMethod GetRptCfgDataByID(rptID As %String, ByRef inParam) As %String
{
	n (rptID)
	k inParam

	s baseObjName=""
	s dateItemName=""
	s Name=""
	s IsAggregat=""
	s rptType=""
	s item=""
	s type=""
	s itemID=""
	
	&sql(SELECT BaseObjName, DateItemName, IsAggregat ,Type into :baseObjName,:dateItemName,:IsAggregat,:rptType FROM DHCWL_BaseDataQuery.ReportCfg WHERE ID = :rptID)
	if SQLCODE'=0 {
		w "{success:true,tip:'ok',MSG:'FAIL'}"
		q
	}	
	
	if IsAggregat=0 s inParam("qryType")="detail"
	else  s inParam("qryType")="aggregat"
	s inParam("qryObjName")=baseObjName
	s inParam("daterangeItem")=dateItemName
	
	&sql(
		DECLARE C3 CURSOR FOR
		SELECT %ID,Item, Type 
		into :rptID,:item,:type 
		FROM DHCWL_BaseDataQuery.ReportCfgSub
		WHERE RptID = :rptID
	)


	&sql(OPEN C3)
	&sql(FETCH C3)
	s rptsub=""
	
	s inParam("filterIDs")=""
	s inParam("filterOperas")=""
	s inParam("filterValues")=""
	s inParam("inPamfilter")=""
	//s inParam("colcustomMeasure")=""
	s inParam("colGroup")=""
	s inParam("colOrder")=""
	s inParam("colType")=""
	While (SQLCODE = 0) {
		if type="col" || (type="colcustomMeasure") {
			
			if type="col" {
				s col=$p(item,"(",1)
				s inPamCol=$p($p(item,"(",2),")",1)
			}elseif type="colcustomMeasure" {
				s col=item
				s inPamCol=""
			}
			if $g(inParam("paramCols"))="" {
				s inParam("paramCols")=col
				s inParam("inPamCols")=inPamCol
			}else{
				s inParam("paramCols")=inParam("paramCols")_","_col
				s inParam("inPamCols")=inParam("inPamCols")_","_inPamCol
			}
			s inParam("colType",col)=type
			
		}elseif  type="row" {
			s row=$p(item,"(",1)
			s inPamRow=$p($p(item,"(",2),")",1)
			
			if $g(inParam("paramRows"))="" {
				s inParam("paramRows")=row
				s inParam("inPamRows")=inPamRow
			}else{
				s inParam("paramRows")=inParam("paramRows")_","_row
				s inParam("inPamRows")=inParam("inPamRows")_","_inPamRow
			}
		}elseif  type="filter" {
			s fID=$p(item,"(",1)
			s inPamF=$p($p(item,"(",2),")",1)
			s opera=$p(item,"^",2)
			s value=$p(item,"^",3)
			
			if $g(inParam("filterIDs"))="" {
				s inParam("filterIDs")=fID
				s inParam("filterOperas")=opera
				s inParam("filterValues")=value
				s inParam("inPamfilter")=inPamF
			}else{
				//s inParam("paramCols")=inParam("paramCols")_","_fID
				s inParam("filterIDs")=inParam("filterIDs")_","_fID
				s inParam("filterOperas")=inParam("filterOperas")_","_opera
				s inParam("filterValues")=inParam("filterValues")_","_value
				s inParam("inPamfilter")=inParam("inPamfilter")_","_inPamF
			}		
		}elseif  type="measure" {
			if $g(inParam("paramMeasure"))="" {
				s inParam("paramMeasure")=item
			}else{
				s inParam("paramMeasure")=inParam("paramMeasure")_","_item
			}	
			s inParam("colType",item)=type		
		}elseif  type="colGroup" {
			if $g(inParam("colGroup"))="" {
				s inParam("colGroup")=item
			}else{
				s inParam("colGroup")=inParam("colGroup")_","_item
			}			
		}elseif  type="colOrder" {
			if $g(inParam("colOrder"))="" {
				s inParam("colOrder")=item
			}else{
				s inParam("colOrder")=inParam("colOrder")_","_item
			}			
		}
		&sql(FETCH C3)
	}

	&sql(CLOSE C3)
}

/// 
/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:：   返回汇总查询数据，被被润乾调用调用
/// Table：       	无
/// Input：         qryObjName：查询对象名称
/// 					paramRows：行显示项，
/// 					inPamRows：行显示项入参，
/// 					paramCols：列显示项，
/// 					inPamCols：列显示项入参，
/// 					paramMeasure：度量项，
/// 					paramMeasureDesc：度量项描述，
/// 					daterangeItem：日期口径，
/// 					daterangeStart：统计开始日期，
/// 					daterangeEnd：统计结束日期 ， 
/// 					filterIDs：过滤项 ， 
/// 					filterOperas：过滤操作符， 
/// 					filterValues：过滤值 ， 
/// 					inPamfilter：过滤项入参				
/// Output：        row1,row2,row3,row4,row5：行1-行5
/// 					col1,col2,col3,col4,col5：列1-列5
/// 					measureDesc：度量描述
/// 					measure：度量描述
/// Return：        
/// Others：
Query QryGetRptTitle(rptID As %String) As %Query(ROWSPEC = "rptTitle:%String") [ SqlProc ]
{
}

ClassMethod QryGetRptTitleExecute(ByRef qHandle As %Binary, rptID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if rptID'="" {
		s title=$lg(^DHCWL.BaseDataQuery.ReportCfgD(rptID),3)
		if title="tempSysRpt" s title="临时预览"
		s Data=$lb(title)
		d OuputRow1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryGetRptTitleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGetRptTitleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryGetRptTitleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGetRptTitleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// s a= ##class(DHCWL.BaseDataQuery.Interface)BelongToStatGrp(981)
ClassMethod BelongToStatGrp(UserID As %String) As %String
{
	s ssgrpDesc=""
	&sql(SELECT ssgrpDesc into :ssgrpDesc FROM (SELECT ssusr_group->SSGRP_Desc AS ssgrpDesc FROM SQLUser.SS_User WHERE ssusr_rowid=:UserID UNION SELECT OTHLL_UserGroup_DR->SSGRP_Desc AS ssgrpDesc FROM SQLUser.SS_UserOtherLogonLoc WHERE OTHLL_ParRef=:UserID) WHERE ssgrpDesc='Statistic')
	if ssgrpDesc'="" q 1
	else  q 0
}

}
