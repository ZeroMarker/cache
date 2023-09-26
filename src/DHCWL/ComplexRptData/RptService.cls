Class DHCWL.ComplexRptData.RptService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     	hetong
/// CreatDate：    	2015-11-27
/// Description：	按照区间和报表配置条件查找值
/// Table：    		DHCWL_ComplexRpt.RptCfg,DHCWL_ComplexRpt.RowsColCfg,DHCWL_MKPI.DHCWLDeptKPIData
/// Input：       
/// Output：  		monId:%String:区间id,rptCode:%String:报表名称,kpiId:%String:指标id
/// 				rowDesc:%String:行条件,colDesc:%String:列条件,value:%String:值
/// Return：      
/// Others：d ##class(%ResultSet).RunQuery("DHCWL.ComplexRptData.RptService","QueryReportData",15,,"2012-10-01","2012-10-05",,"O")
Query QueryReportData(rpt As %String, content As %String = "", startDate, endDate, choiceType = "freeDateChoice", isRealData = "") As %Query(ROWSPEC = "monId:%String,monDesc:%String,rptCode:%String,rptName:%String,rptContent:%String,kpiId:%String,dimId:%String,rowDesc:%String,colDesc:%String,value:%Float") [ SqlProc ]
{
}

ClassMethod QueryReportDataExecute(ByRef qHandle As %Binary, rpt As %String, content As %String = "", startDate, endDate, choiceType = "freeDateChoice", isRealData = "") As %Status
{
	n (qHandle,rpt,content,startDate,endDate,choiceType,isRealData)
 	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
    s ind=1
	q:(rpt="")!(startDate="")!(endDate="") $$$OK
	
	k ContentLoop
	/// 标记行列条件，并按照规则形成标准Query的入参
	i $d(^DHCWL.ComplexRpt.RptCfgD(rpt)){
		s rptId=rpt
		s rptCode=$lg(^DHCWL.ComplexRpt.RptCfgD(rptId),2) ;报表代码
	}else{
		q:'$d(^DHCWL.ComplexRpt.RptCfgI("RptCode"," "_$zcvt(rpt,"U"))) $$$OK
		s rptCode=rpt
		s rptId=$o(^DHCWL.ComplexRpt.RptCfgI("RptCode"," "_$zcvt(rpt,"U"),""))
		q:rptId="" $$$OK
	}
	s rptName=$lg(^DHCWL.ComplexRpt.RptCfgD(rptId),3) ;报表名称
	s rptcfg=$o(^DHCWL.ComplexRpt.RowsColCfgI("RCRptDr",rptId,""))
	q:rptcfg="" $$$OK
	s rptRow=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptcfg),5) ;行条件
	s rptCol=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptcfg),6) ;列条件
	s rptFilter=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptcfg),7) ;过滤条件
	s poolDr=0,kpiFilter="",mkpiCodeStr=""
	f {
		s poolDr=$o(^DHCWL.ComplexRpt.RptLinkMkpiI("LinkRptKpi",rptId,poolDr))
		q:poolDr=""
		s rptContent=$lg(^DHCWL.ComplexRpt.MKpiD(poolDr),4) ;统计内容
		continue:(content'="")&&(rptContent'=rptContent)
		s mkpi=$lg(^DHCWL.ComplexRpt.MKpiD(poolDr),2) ;指标ID
		continue:'$d(^DHCWL.MKPI.MKPID(+mkpi))
		s ContentLoop(mkpi)=rptContent
		s mkpiCode=$lg(^DHCWL.MKPI.MKPID(mkpi),2) ;指标代码
		i mkpiCodeStr=""  s mkpiCodeStr=mkpiCode
		e  s mkpiCodeStr=mkpiCodeStr_","_mkpiCode
		///形成过滤条件
		s filter=$Case(rptFilter,"":"",:mkpiCode_":("_rptFilter_")")
		i kpiFilter=""  s kpiFilter=filter
		e  s kpiFilter=kpiFilter_$Case(filter,"":"",:","_filter)
	}
	q:mkpiCodeStr="" $$$OK
	d ..SetTransDimPos(mkpiCodeStr,rptRow,rptCol,.dim,.kpiStr)
	////调用指标标准Query
	s rs=##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate")
	s sc=rs.Execute(kpiStr,startDate,endDate,choiceType,isRealData,kpiFilter)
	While rs.Next(.sc){
		/// monId,monDesc,kpiId,kpiCode,kpiDesc,dimId,dimDesc,value
		s monId=$g(rs.Data("monId"))
		s monDesc=$g(rs.Data("monDesc"))
		s kpiId=$g(rs.Data("kpiId"))
		s statContent=$g(ContentLoop(kpiId))
		s statContentDesc=..GetContentDesc(statContent)
		s kpiCode=$g(rs.Data("kpiCode"))
		s kpiDesc=$g(rs.Data("kpiDesc"))
		s dimId=$g(rs.Data("dimId"))
		s value=$g(rs.Data("value"))
		s dimDescStr=$g(rs.Data("dimDesc"))
		s rowDimDesc=$P(dimDescStr,",",1,$l(rptRow,","))
		d ..GetTransDim(kpiCode,dimDescStr,rptCol,.dim,.colDimDesc)
		d OutPutRow
	}
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPutRow
	/// monId,monDesc,rptCode,kpiId,dimId,rowDesc,colDesc,value
	s Data=$lb(monId,monDesc,rptCode,rptName,statContentDesc,kpiId,dimId,rowDimDesc,colDimDesc,value)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod QueryReportDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportDataExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryReportDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportDataExecute ]
{
	n (AtEnd,qHandle,Row)
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

/// Creator：     	hetong
/// CreatDate：    	2015-12-18
/// Description：	根据报表Code获取报表关联的指标等信息
/// Table：    		DHCWL_ComplexRpt.RptCfg,DHCWL_ComplexRpt.RptLinkMkpi
/// Input：       
/// Output：  		rptName:%String:报表名称,kpiCode:%String:指标编码,kpiId:%String:指标ID
/// Return：      
/// Others：d ##class(%ResultSet).RunQuery("DHCWL.ComplexRptData.RptService","QueryRptlinkKpi",2)
Query QueryRptlinkKpi(rpt As %String) As %Query(ROWSPEC = "kpiId:%String,kpiCode:%String,rptName:%String") [ SqlProc ]
{
}

ClassMethod QueryRptlinkKpiExecute(ByRef qHandle As %Binary, rpt As %String) As %Status
{
	n (qHandle,rpt)
 	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
    s ind=1
	q:(rpt="") $$$OK
	
	/// 标记行列条件，并按照规则形成标准Query的入参
	i $d(^DHCWL.ComplexRpt.RptCfgI("RptCode"," "_$zcvt(rpt,"U"))){
		s rptCode=rpt
		s rptId=$o(^DHCWL.ComplexRpt.RptCfgI("RptCode"," "_$zcvt(rpt,"U"),""))
		q:rptId="" $$$OK
	}else{
		q:'$d(^DHCWL.ComplexRpt.RptCfgD(rpt)) $$$OK
		s rptId=rpt
		s rptCode=$lg(^DHCWL.ComplexRpt.RptCfgD(rptId),2) ;报表代码
	}
	s rptName=$lg(^DHCWL.ComplexRpt.RptCfgD(rptId),3) ;报表名称
	s poolDr=0
	f {
		s poolDr=$o(^DHCWL.ComplexRpt.RptLinkMkpiI("LinkRptKpi",rptId,poolDr))
		q:poolDr="" ;指标池ID为空退出
		s rptContent=$lg(^DHCWL.ComplexRpt.MKpiD(poolDr),4) ;统计内容
		s mkpi=$lg(^DHCWL.ComplexRpt.MKpiD(poolDr),2) ;指标ID
		continue:'$d(^DHCWL.MKPI.MKPID(+mkpi))
		s mkpiCode=$lg(^DHCWL.MKPI.MKPID(mkpi),2) ;指标代码
		d OutPutRowKpi
	}
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPutRowKpi
	/// monId,monDesc,rptCode,kpiId,dimId,rowDesc,colDesc,value
	s Data=$lb(mkpi,mkpiCode,rptName)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod QueryRptlinkKpiClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRptlinkKpiExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryRptlinkKpiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRptlinkKpiExecute ]
{
	n (AtEnd,qHandle,Row)
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

/// d ##class(DHCWL.ComplexRptData.RptService).SetTransDimPos("kpi","RegLoc,RegDoc,RegBoc","RegBoc,RegLoc",.dim)
ClassMethod SetTransDimPos(kpi As %String, row As %String, col As %String, ByRef dim, ByRef paraStr) As %Status
{
	n (kpi,col,row,dim,paraStr)
	
	k:$d(dim) dim
	k:$d(paraStr) paraStr
	q:row="" 1
	s outStr=row_","_col
	f m=1:1:$l(kpi,","){
		s kpiCode=$P(kpi,",",m)
		s j=0,para=""
		f i=1:1:$l(outStr,","){
			s colCode=$P(outStr,",",i)
			continue:colCode=""
			continue:$d(dim(kpiCode,colCode))
			s j=j+1
			s dim(kpiCode,colCode)=j
			s $P(para,"^",j)=colCode
		}
		s paraLoop=$Case(para,"":kpiCode,:kpiCode_":"_para)
		i $g(paraStr)="" s paraStr=paraLoop
		e  s paraStr=paraStr_","_paraLoop
	}
	q 1
}

/// d ##class(DHCWL.ComplexRptData.RptService).GetTransDim("kpi","am,No,I","RegBoc,RegLoc",.str)
ClassMethod GetTransDim(kpi As %String, dimList As %String, col As %String, ByRef dimArr, ByRef dimDescStr) As %Status
{
	n (kpi,dimList,col,dimArr,dimDescStr)
	
	k:$d(dimDescStr) dimDescStr
	q:(kpi="")!(dimList="")!(col="") 1
	s j=0
	f i=1:1:$l(col,","){
		s dimCode=$P(col,",",i)
		continue:dimCode=""
		s pos=$g(dimArr(kpi,dimCode))
		s posDesc=$P(dimList,",",pos)
		s j=j+1
		s $P(dimDescStr,",",j)=posDesc
	}
	q 1
}

/// Creator：     	hetong
/// CreatDate：    	2015-10-27
/// Description：	获取所有已维护的统计项及其对应的维度属性
/// d ##class(DHCWL.ComplexRptData.RptService).GetStatDimAndPro()
ClassMethod GetStatDimAndPro(checkStat As %String = "") As %Integer
{
	n (checkStat)
	
	w "["
	s statParentNO="root"
	s jsonDatas=""
	s statId=0 
	f {
		s numBase=1
		s statId=$o(^DHCWL.ComplexRpt.StatItemD(statId)) 
		q:statId=""
		s flag=$lg(^DHCWL.ComplexRpt.StatItemD(statId),8)
		s ststOrCon=$lg(^DHCWL.ComplexRpt.StatItemD(statId),4)
		continue:(ststOrCon="C")!(flag="N")
		s ststCode=$lg(^DHCWL.ComplexRpt.StatItemD(statId),2)
		s ststName=$lg(^DHCWL.ComplexRpt.StatItemD(statId),3)
		s kpiDimDimDr=$lg(^DHCWL.ComplexRpt.StatItemD(statId),5) ;关联维度
		continue:kpiDimDimDr=""
		s statNO=ststCode_numBase
		s numBase=numBase+1
		s jsonData="{""code"":"""_ststCode_""""_",""className"":"""_"DHCWL.ComplexRpt.StatItem"_""""
		s jsonData=jsonData_",""parentNO"":"""_statParentNO_""""_",""NO"":"""_statNO_""""	
		s jsonData=jsonData_",""text"":"""_ststName_"""}"
		i jsonDatas="" s jsonDatas=jsonData
		e  s jsonDatas=jsonDatas_","_jsonData
		;s kpiDimDimDr=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$ZCVT(ststDimCode,"U"),""))
		s dimProCode=""
		f {
			s dimProCode=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",kpiDimDimDr,dimProCode))
			q:$g(dimProCode)=""
			s dimProID=""
			f {
				s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",kpiDimDimDr,dimProCode,dimProID))
				q:$g(dimProID)=""
				s proCode=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),3)
				s proDesc=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),5)
				s proNo=proCode_numBase
				s numBase=numBase+1
				s jsonData="{""code"":"""_proCode_""""_",""className"":"""_"DHCWL.MKPI.DimProperty"_""""
				s jsonData=jsonData_",""parentNO"":"""_statNO_""""_",""NO"":"""_proNo_""""	
				s jsonData=jsonData_",""text"":"""_proDesc_"""}"
				s jsonDatas=jsonDatas_","_jsonData
			}
		}
	}
	w jsonDatas
	w "]"	
	q 1
	
ErrorDel
	k ^TEMPDHCWL($j)
	q 0
}

/// Creator：     	hetong
/// CreatDate：    	2015-12-22
/// Description：	获取所有已维护的统计项
/// d ##class(DHCWL.ComplexRptData.RptService).GetStatDim()
ClassMethod GetStatDim(checkStat As %String = "") As %Integer
{
	n (checkStat)
	
	w "["
	s statParentNO="root"
	s jsonDatas=""
	s statId=0 
	f {
		s statId=$o(^DHCWL.ComplexRpt.StatItemD(statId)) 
		q:statId=""
		s flag=$lg(^DHCWL.ComplexRpt.StatItemD(statId),8) ;有效标识
		s statOrCon=$lg(^DHCWL.ComplexRpt.StatItemD(statId),4) ;统计内容或统计项
		s statSortFlag=$lg(^DHCWL.ComplexRpt.StatItemD(statId),10) ;统计项分类
		continue:(statOrCon="C")!(flag="N")
		continue:statSortFlag'="stat" ;此处的stat为收入综合查询的统计项
		s statCode=$lg(^DHCWL.ComplexRpt.StatItemD(statId),2)
		s statName=$lg(^DHCWL.ComplexRpt.StatItemD(statId),3)
		s statDimCode=$lg(^DHCWL.ComplexRpt.StatItemD(statId),5) ;关联维度
		continue:statDimCode="" ;统计项如果没有关联维度则不显示
		s statNO=statCode
		s jsonData="{""code"":"""_statCode_""""_",""className"":"""_"DHCWL.ComplexRpt.StatItem"_""""
		s jsonData=jsonData_",""parentNO"":"""_statParentNO_""""_",""NO"":"""_statNO_""""	
		s jsonData=jsonData_",""text"":"""_statName_"""}"
		i jsonDatas="" s jsonDatas=jsonData
		e  s jsonDatas=jsonDatas_","_jsonData
	}
	w jsonDatas
	w "]"
	q 1
}

/// Creator：     	hetong
/// CreatDate：    	2015-12-24
/// Description：	获取所有已维护的统计项(树加载器使用，增加id节点)
/// d ##class(DHCWL.ComplexRptData.RptService).GetLoadStatDim()
ClassMethod GetLoadStatDim(checkStat As %String = "") As %Integer
{
	n (checkStat)
	
	w "["
	s statParentNO="root"
	s jsonDatas=""
	s statId=0 
	f {
		s statId=$o(^DHCWL.ComplexRpt.StatItemD(statId)) 
		q:statId=""
		s flag=$lg(^DHCWL.ComplexRpt.StatItemD(statId),8)
		s statOrCon=$lg(^DHCWL.ComplexRpt.StatItemD(statId),4)
		s statSortFlag=$lg(^DHCWL.ComplexRpt.StatItemD(statId),10) ;统计项分类
		continue:(statOrCon="C")!(flag="N")
		continue:statSortFlag'="stat" ;此处的stat为收入综合查询的统计项
		s statCode=$lg(^DHCWL.ComplexRpt.StatItemD(statId),2)
		s statName=$lg(^DHCWL.ComplexRpt.StatItemD(statId),3)
		s statDimCode=$lg(^DHCWL.ComplexRpt.StatItemD(statId),5) ;关联维度
		continue:statDimCode="" ;统计项如果没有关联维度则不显示
		s statNO=statCode
		s jsonData="{""code"":"""_statCode_""""_",""className"":"""_"DHCWL.ComplexRpt.StatItem"_""""
		s jsonData=jsonData_",""parentNO"":"""_statParentNO_""""_",""NO"":"""_statNO_""""_",""id"":"""_statCode_""""	
		s jsonData=jsonData_",""text"":"""_statName_"""}"
		i jsonDatas="" s jsonDatas=jsonData
		e  s jsonDatas=jsonDatas_","_jsonData
	}
	w jsonDatas
	w "]"
	q 1
}

/// Creator：     	hetong
/// CreatDate：    	2015-12-31
/// Description：	根据统计项编码获取对应的描述
/// w ##class(DHCWL.ComplexRptData.RptService).GetContentDesc("PatLoc")
ClassMethod GetContentDesc(stat As %String) As %String
{
	n (stat)
	s statDesc=""
	s statDr=##class(DHCWL.ComplexRptData.SaveData).GetStatItemidByCode(stat)
	q:statDr="" statDesc
	s statDesc=$lg(^DHCWL.ComplexRpt.StatItemD(statDr),3) ;统计项描述
	q statDesc
}

/// Creator：     	hetong
/// CreatDate：    	2015-12-21
/// Description：	通过给定统计项Code获取该统计项对应的所有维度属性的相关信息
/// d ##class(DHCWL.ComplexRptData.RptService).GetStatDimPro("PatLoc")
ClassMethod GetStatDimPro(statCode As %String = "", flag As %String) As %Integer
{
	n (statCode,flag)
	i statCode=""{
		w "[]"
		q 1
	}
	w "["
	s jsonDatas="",jsonItemGrp="",jsonItemSubGrp=""
	s statId=##class(DHCWL.ComplexRptData.SaveData).GetStatItemidByCode(statCode)
	i statId=""{
		w "]"
		q 1
	}
	s statDesc=$lg(^DHCWL.ComplexRpt.StatItemD(statId),3) ;描述
	s kpiDimDr=$lg(^DHCWL.ComplexRpt.StatItemD(statId),5) ;关联维度
	i kpiDimDr=""{
		w "]"
		q 1
	}
	;s kpiDimDr=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$ZCVT(ststDimCode,"U"),""))
	s kpiDimCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(kpiDimDr),2)
	s rs=##class(%ResultSet).%New("DHCWL.CodeCfgData.FunctionModule:GetGrpListByDimCode")
	s dimProCode="",numBase=0
	f {
		s dimProCode=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",kpiDimDr,dimProCode))
		q:$g(dimProCode)=""
		s dimProID=""
		f {
			s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",kpiDimDr,dimProCode,dimProID))
			q:$g(dimProID)="" ;维度属性ID为空退出
			s proCode=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),3)
			continue:proCode="ItemSubGrp"
			s proDesc=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),5)
			s numBase=numBase+1
			s proNo=proCode_numBase
			;统计大组和统计子组单独处理
			;flag的值为"dimProGrp"：表示为报表行列条件配置界面使用
			if flag="dimProGrp" s className="DHCWL.ComplexRpt.StatItem"
			else  s className="DHCWL.MKPI.DimProperty"
			if proCode="ItemGrp"{
				s proCodeNo=statCode_"."_proCode
				s proDesc=statDesc_"."_proDesc
				s jsonData="{""code"":"""_proCode_""""_",""className"":"""_className_""""
				s jsonData=jsonData_",""parentNO"":"""_statCode_""""_",""NO"":"""_proCodeNo_""""	
				s jsonData=jsonData_",""text"":"""_proDesc_"""}"
				i jsonDatas="" s jsonDatas=$g(jsonData)
				e  s jsonDatas=jsonDatas_","_jsonData
				;统计大组
				if (flag="dimProGrp"){
					s sc=rs.Execute(kpiDimCode,"G")
					s i=0
					While rs.Next(.sc){
						s i=i+1
						s grpDr=$g(rs.Data("id"))
						s grpCode=$g(rs.Data("Code")) 
						s grpDesc=$g(rs.Data("Desc"))
						s itemGrpNo=grpCode_i
						s jsonData="{""code"":"""_grpCode_""""_",""className"":"""_"DHCWL.MKPI.ItemGrp"_""""
						s jsonData=jsonData_",""parentNO"":"""_proCodeNo_""""_",""NO"":"""_itemGrpNo_""""	
						s jsonData=jsonData_",""text"":"""_grpDesc_"""}"
						i jsonDatas="" s jsonDatas=$g(jsonData)
						e  s jsonDatas=jsonDatas_","_jsonData
					}
				}
			}
			elseif((proCode="ItemSubGrpCode")!(proCode="ItemSubGrpDesc")!(proCode="ItemSubGrpOrder")){
				;统计子组:代码(ItemSubGrpCode)、描述(ItemSubGrpDesc)、顺序(ItemSubGrpSort)
				s proCodeNo=statCode_"."_proCode
				s proDesc=statDesc_"."_proDesc
				s jsonData="{""code"":"""_proCode_""""_",""className"":"""_className_""""
				s jsonData=jsonData_",""parentNO"":"""_statCode_""""_",""NO"":"""_proCodeNo_""""	
				s jsonData=jsonData_",""text"":"""_proDesc_"""}"
				i jsonDatas="" s jsonDatas=$g(jsonData)
				e  s jsonDatas=jsonDatas_","_jsonData
				s sc=rs.Execute(kpiDimCode,"SG")
				s i=0
				While rs.Next(.sc){
					s i=i+1
					s grpDr=$g(rs.Data("id"))
					s grpCode=$g(rs.Data("Code")) 
					s grpDesc=$g(rs.Data("Desc"))
					s itemGrpNo=grpCode_i
					s jsonData="{""code"":"""_grpCode_""""_",""className"":"""_"DHCWL.MKPI.ItemSubGrp"_""""
					s jsonData=jsonData_",""parentNO"":"""_proCodeNo_""""_",""NO"":"""_itemGrpNo_""""	
					s jsonData=jsonData_",""text"":"""_grpDesc_"""}"
					i jsonDatas="" s jsonDatas=$g(jsonData)
					e  s jsonDatas=jsonDatas_","_jsonData
				}
			}
			else{
				s jsonData="{""code"":"""_proCode_""""_",""className"":"""_"DHCWL.MKPI.DimProperty"_""""
				s jsonData=jsonData_",""parentNO"":"""_statCode_""""_",""NO"":"""_proNo_""""	
				s jsonData=jsonData_",""text"":"""_proDesc_"""}"
				i jsonDatas="" s jsonDatas=$g(jsonData)
				e  s jsonDatas=jsonDatas_","_jsonData
			}
		}
	}

	w jsonDatas
	w "]"
	q 1
}

/// Creator：     	hetong
/// CreatDate：    	2016-01-12
/// Description：	通过给定指标编码串生成指标数据
/// w ##class(DHCWL.ComplexRptData.RptService).CreateKpiData("RPTKPI0001","2012-10-01","2012-10-05",1)
ClassMethod CreateKpiData(kpis As %String, startDate As %String, endDate As %String, flag As %String) As %Status
{
	n (kpis,startDate,endDate,flag)
	q:kpis="" 0
	s kpiIds=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpis)
	s excPara=$P(kpis,",",$l(kpis,","))_":"_"kpiId="_kpiIds
	d AddKpiData^DHCWLAutoCreatMKPIData(startDate,endDate,kpis,1,excPara)
	q 1
}

/// Creator：     	hetong
/// CreatDate：    	2016-01-04
/// Description：	查找所有已配置的报表
/// Table：    		DHCWL_ComplexRpt.RptCfg,DHCWL_ComplexRpt.RowsColCfg
/// Input：       
/// Output：  		rptId:%String:报表id,rptCode:%String:报表编码,rptName:%String:报表名称
/// Return：      
/// Others：d ##class(%ResultSet).RunQuery("DHCWL.ComplexRptData.RptService","GetRptConfigured","Y")
Query GetRptConfigured(configFlag As %String = "") As %Query(ROWSPEC = "rptId:%String,rptCode:%String,rptName:%String") [ SqlProc ]
{
}

ClassMethod GetRptConfiguredExecute(ByRef qHandle As %Binary, configFlag As %String = "") As %Status
{
	n (qHandle,configFlag)
 	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
    s ind=1
	
	s rptId=0
	f {
		s rptId=$o(^DHCWL.ComplexRpt.RptCfgD(rptId))
		q:rptId=""
		continue:($ZCVT(configFlag,"U")="Y")&&('$d(^DHCWL.ComplexRpt.RowsColCfgI("RCRptDr",rptId)))
		continue:($ZCVT(configFlag,"U")="N")&&($d(^DHCWL.ComplexRpt.RowsColCfgI("RCRptDr",rptId)))
		s rptCode=$lg(^DHCWL.ComplexRpt.RptCfgD(rptId),2) ;报表代码
		s rptName=$lg(^DHCWL.ComplexRpt.RptCfgD(rptId),3) ;报表名称
		d OutPutRowRpt
	}
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPutRowRpt
	s Data=$lb(rptId,rptCode,rptName)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod GetRptConfiguredClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRptConfiguredExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRptConfiguredFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRptConfiguredExecute ]
{
	n (AtEnd,qHandle,Row)
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

/// Creator：      hetong
/// CreatDate：    2016-1-26
/// Description:： BS代码维护：根据统计子组代码取出该子组下的所有条目
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgGroup  DHCWL_CodeCfg.DHCWLCodeCfgItemGroup
/// Input：       subGrpCode:统计子组CODE
/// Output：      id,Code,Desc
/// Return：      
/// Others：d ##class(%ResultSet).RunQuery("DHCWL.ComplexRptData.RptService","GetSubGrpListByCode","IPLoc","Code")
/// 
Query GetSubGrpListByCode(subGrpCode As %String, flag As %String = "", filter As %String = "") As %Query(ROWSPEC = "dimValue:%String,dimProValue:%String") [ SqlProc ]
{
}

ClassMethod GetSubGrpListByCodeExecute(ByRef qHandle As %Binary, subGrpCode As %String, flag As %String = "", filter As %String = "") As %Status
{
	n (qHandle,subGrpCode,flag,filter)
 	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
    s ind=1
    
	q:subGrpCode="" $$$OK
	s grpId=0,subGrpStr=""
	f {
		s grpId=$o(^DHCWL.CodeCfg.GroupI("Code"," "_$zcvt(subGrpCode,"U"),grpId))
		q:grpId=""
		s subgrpId=0
		f {
			s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",grpId,subgrpId))
			q:subgrpId=""
			s value=##class(DHCWL.CodeCfg.SubGroup).%OpenId(subgrpId)
			s subgrpDesc=value.SGrpDesc
			s subgrpCode=value.SGrpCode
			s subgrpSort=value.SGrpSort
			s subGrpStr=$case(flag,"ItemSubGrpCode":subgrpCode,"ItemSubGrpDesc":subgrpDesc,"ItemSubGrpOrder":subgrpSort,:subgrpDesc)
			continue:(subGrpStr'[filter)
			d OutPutRowSubGrp
		}
	}
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPutRowSubGrp
	s Data=$lb(subgrpId,subGrpStr)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod GetSubGrpListByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSubGrpListByCodeExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSubGrpListByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSubGrpListByCodeExecute ]
{
	n (AtEnd,qHandle,Row)
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

}
