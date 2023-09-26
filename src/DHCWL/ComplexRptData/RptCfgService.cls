Import SQLUser

Class DHCWL.ComplexRptData.RptCfgService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// hetong
/// 2015-10-21
/// 解析过滤表达式
/// w ##class(DHCWL.ComplexRptData.RptCfgService).ResovleFilterData("[病人科室.科室描述} '= Null] && [{开单科室.科室编码} \[ 门诊2] && [{执行科室.科室子组} \[ 血管外科急诊(西院),急诊内科,急诊妇产科]")
ClassMethod ResovleFilterData(filterStr As %Text) As %String
{
	n (filterStr)
	q:filterStr="" ""
	s filterStr=##class(DHCWL.util.StringUtil).Trim(filterStr,"[")
	s filterStr=##class(DHCWL.util.StringUtil).Trim(filterStr,"]")
	s filterStr=##class(DHCWL.util.StringUtil).EscapeStr(filterStr,"[","\")
	s filterStr2=$zcvt(filterStr,"U")
	s choiceFilter="",ind=0,best=0,bestFilter=""
	f {
		s choiceFilter=$o(^DHCWL.MKPI.SysFilterFuncI("Code",choiceFilter))
		q:choiceFilter=""
		s choiceFilter2=##class(DHCWL.util.StringUtil).Trim(choiceFilter)
		if (($l(choiceFilter2)>best)&&($f(filterStr2,choiceFilter2)>0)){
			s best=$l(choiceFilter2),bestFilter=choiceFilter2
			s ind=$f(filterStr2,choiceFilter2)
		}
	}
	q:ind=0 dimArray
	s choiceFilter=bestFilter
	s dimPro=$e(filterStr,1,(ind-$l(choiceFilter)-1))
	s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro)
	s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro,"{")
	s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro,"}")
	q dimPro
	
	/**
	s LOEleS="{",LOEleE="}",LOARR("&")=2,LOARR("|")=2
	s filterStr=##class(DHCWL.util.StringUtil).Trim(filterStr)
	s len=$l(filterStr),loFlag=0,curChar="",preChar="",num=1
	f i=1:1:len {
		s preChar=curChar
		s curChar=$e(filterStr,i)
		i (preChar=LOEleS) s loFlag=1
		i (loFlag=1) s dimStr=$g(dimStr)_curChar
		i (curChar=LOEleE) s loFlag=0
		i ((loFlag=0)&&($g(dimStr)'="")){
			s dimStr=$e(dimStr,1,$l(dimStr)-1)
			d dimArray.SetAt($g(dimStr),num)
			s num=num+1,dimStr=""
		}
	}
	s i=dimArray.Next()
	while (i)
	{	
		w dimArray.GetAt(i),!
		s i=dimArray.Next(i)
	}
	**/
}

/// hetong
/// 2015-10-21
/// 分割过滤规则表达式
/// s a=##class(DHCWL.ComplexRptData.RptCfgService).ResovleFilterRule("[{病人科室.科室描述} '= Null] && [{开单科室.科室编码} \[ 门诊2] && [{执行科室.科室子组} \[ 血管外科急诊(西院),急诊内科,急诊妇产科]")
ClassMethod ResovleFilterRule(filterStr As %Text) As %AbstractArray
{
	n (filterStr)
	s dimArray=##class(%ArrayOfDataTypes).%New()
	q:filterStr="" dimArray
	s logAnd="&&",logOr="||",ProS="{",ProE="}",indNum=1
	s filterStr=##class(DHCWL.util.StringUtil).Trim(filterStr)
	s len=$l(filterStr,logAnd)
	f i=1:1:len {
		s dataStr=$P(filterStr,logAnd,i)
		i (dataStr [ logOr){
			f j=1:1:$l(dataStr,logOr) {
				s expStr=$P(dataStr,logOr,j)
				continue:((expStr '[ ProS)||(expStr '[ ProE))
				s dimProStr=..ResovleFilterData(expStr)
				continue:('$d(^DHCWL.ComplexRpt.StatItemI("StCode"," "_$zcvt($P(dimProStr,".",1),"U"))))
				d dimArray.SetAt(dimProStr,indNum)
				s indNum=indNum+1
			}
		}else{
			continue:((dataStr '[ ProS)||(dataStr '[ ProE))
			s dimProStr=..ResovleFilterData(dataStr)
			continue:('$d(^DHCWL.ComplexRpt.StatItemI("StCode"," "_$zcvt($P(dimProStr,".",1),"U"))))
			d dimArray.SetAt(dimProStr,indNum)
			s indNum=indNum+1
		}
	}
	q dimArray
}

/// hetong
/// 2015-10-22
/// 根据报表行列条件、过滤条件生成指标维度串
/// w ##class(DHCWL.ComplexRptData.RptCfgService).StructureKpiDim("","",a)
ClassMethod StructureKpiDim(rowDim As %String, colDim As %String, filterDim As %AbstractArray) As %String
{
	n (rowDim,colDim,filterDim)
	k ^TEMPDHCWLPRT($j)
	s dimStr=""
	
	s i=filterDim.Next()
	while (i)
	{	
		s ^TEMPDHCWLPRT($j,"ReportDim",$P(filterDim.GetAt(i),".",1))=""
		s i=filterDim.Next(i)
		
	}
	s rptDimStr=rowDim_","_colDim
	s len=$l(rptDimStr,",")
	f i=1:1:len{
		s dim=$P(rptDimStr,",",i)
		continue:dim=""
		s ^TEMPDHCWLPRT($j,"ReportDim",$P(dim,".",1))=""
	}
	s dim=0
	f {
		s dim=$o(^TEMPDHCWLPRT($j,"ReportDim",dim))
		q:dim=""
		i dimStr="" s dimStr=dim
		e  s dimStr=dimStr_","_dim
	}
	
	k ^TEMPDHCWLPRT($j)
	q dimStr
}

/// hetong
/// 2015-10-22
/// 保存报表配置相关信息
/// d ##class(DHCWL.ComplexRptData.RptCfgService).SaveRptCfg("1")
ClassMethod SaveRptCfg(ByRef rptCfgArr) As %Status
{
	n (rptCfgArr)
	s rptId=$g(rptCfgArr("RptId"))
	s modeCfg=$g(rptCfgArr("Mode"))
	s contentCfg=$g(rptCfgArr("Content"))
	s rowCfg=$g(rptCfgArr("Row"))
	s colCfg=$g(rptCfgArr("Col"))
	s filterCfg=$g(rptCfgArr("Filter"))
	q:+rptId=0 1
	q:'$d(^DHCWL.ComplexRpt.RptCfgD(rptId)) 1
	s res=0
	i $d(^DHCWL.ComplexRpt.RowsColCfgI("RCRptDr",rptId)){
		&sql(update DHCWL_ComplexRpt.RowsColCfg set RC_Mode=:modeCfg,RC_Content=:contentCfg,RC_RowExp=:rowCfg,RC_ColExp=:colCfg,RC_FilterExp=:filterCfg
		 where RC_RptDr=:rptId)
		i SQLCODE'=0 s res=1
	}else{
		&sql(insert into DHCWL_ComplexRpt.RowsColCfg (RC_RptDr,RC_Mode,RC_Content,RC_RowExp,RC_ColExp,RC_FilterExp) 
				values (:rptId,:modeCfg,:contentCfg,:rowCfg,:colCfg,:filterCfg))
		i SQLCODE'=0 s res=1
	}
	q res
}

/// hetong
/// 2015-11-03
/// 根据报表ID及配置条件生成指标或使用满足条件的原有指标
/// 指标的新建包含四个内容：
///         1、保存报表配置条件
/// 		2、指标池匹配检查
/// 		3、指标和指标池子的新建，若原有指标匹配则无需新建。
/// 		4、指标与报表的重新关联
/// 返回结果：0：表示保存成功，1：表示保存失败，2：表示维度个数超过5个
/// w ##class(DHCWL.ComplexRptData.RptCfgService).CreateKpiByRptId(.dim)
ClassMethod CreateKpiByRptId(ByRef rptCfgArr) As %Integer
{
	n (rptCfgArr)
	
	TSTART
	s rs=..SaveRptCfg(.rptCfgArr)
	i rs'=0{
		TROLLBACK
		q 1
	}
	s rptId=$g(rptCfgArr("RptId")) ;报表定义表ID
	s modeCfg=$g(rptCfgArr("Mode"))
	s contentCfg=$g(rptCfgArr("Content"))
	s rowCfg=$g(rptCfgArr("Row"))
	s colCfg=$g(rptCfgArr("Col"))
	s filterCfg=$g(rptCfgArr("Filter"))
	s dimArray=..ResovleFilterRule(filterCfg)
	;生成规则指标维度串
	s dimStr=..StructureKpiDim(rowCfg,colCfg,.dimArray)
	i $l(dimStr,",")>5{
		TROLLBACK
		q 2
	}
	s len=$l(contentCfg,","),mFlag=0
	f i=1:1:len{
		s contentCode=$p(contentCfg,",",i)
		;检查指标池中是否有匹配指标
		s kpi=..GetMatchKpiPool(modeCfg,contentCode,dimStr) ;指标池ID
		i (kpi=""){
			;如果没有匹配指标，在指标系统和指标池中维护相应的数据
			s result=..SetMkpiVSRptPool(rptId,modeCfg,contentCode,dimStr)
			i (+result=0){
				s mFlag=1  q
			}
			;建立报表与指标的关联关系
			s rs1=..UpdateRptKpiLink(rptId,contentCode,result)
			i (rs1=1){
				s mFlag=1  q
			}
		}else{
			;更新报表与指标的关联关系
			s rs2=..UpdateRptKpiLink(rptId,contentCode,kpi)
			i (rs2=1){
				s mFlag=1  q
			}
		}
	}
	i (mFlag=1){
		TROLLBACK
	}else{
		TCOMMIT
	}
	
	q mFlag
}

/// hetong
/// 2015-11-03
/// 维护指标系统数据及指标池子数据
/// 成功返回指标池ID，否则返回0
/// d ##class(DHCWL.ComplexRptData.RptCfgService).SetMkpiVSRptPool("1")
ClassMethod SetMkpiVSRptPool(rptId As %String, mode As %String, content As %String, kpiDim As %String) As %String
{
	n (rptId,mode,content,kpiDim)
	q:(rptId="")!(mode="")!(content="")!(kpiDim="") 0
	s kpiRes=0,kpiDr="",flag=0
	;1、指标系统生成数据，包括：指标维护、任务维护、维度维护。
	//指标维护
	s kpiAutoStr=..GetKpiCodeVsNode()
	s mkpiCode=$P(kpiAutoStr,",",1) ;指标编码
	s mkpiNode=$P(kpiAutoStr,",",2) ;指标数据节点
	s mkpiName=$P(kpiAutoStr,",",3) ;指标名称
	;s mkpiExec=..GetModeExecCode(mode)
	s mkpiExec="GetWLData^DHCWLComplexRptData" ;指标执行代码
	s kpiSec=##class(DHCWL.MKPI.Section).GetIdByCode("D") ;指标区间
	&sql(insert into DHCWL_MKPI.DHCWLMKPI (MKPI_Code,MKPI_Name,MKPI_Desc,MKPI_User,MKPI_UpdateDate,MKPI_EXCode,MKPI_SectionFlag,MKPI_DataNod,MKPI_GlobalFlag,MKPI_GetValueType) 
		values (:mkpiCode,:mkpiName,:mkpiName,'RPT',+$h,:mkpiExec,:kpiSec,:mkpiNode,'Y','1'))
		i SQLCODE=0 {
			s kpiDr=%ROWID
		}else{
			q kpiRes
		}
		
	//维度维护
	f i=1:1:$l(kpiDim,","){
		s dimCode=$P(kpiDim,",",i) ;统计项编码
		s dimDr=##class(DHCWL.ComplexRptData.SaveData).GetDimByStatCode(dimCode) ;维度ID
		q:dimDr=""
		;s dimDes=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimDr),3) ;维度描述
		s dimDes=##class(DHCWL.ComplexRptData.SaveData).GetStatDescByCode(dimCode) ;统计项描述描述
		&sql(insert into DHCWL_MKPI.DHCWLMKPIDim (MKPIDim_Code,MKPI_Dr,MKPIDim_Des,MKPIDim_DimDr,MKPIDim_Order,MKPIDim_Deli) 
			values (:dimCode,:kpiDr,:dimDes,:dimDr,:i,','))
		i SQLCODE'=0 {
			s flag=1 q
		}
	}
	q:flag=1 kpiRes
		
	//任务维护
	s secStr="D,M,Q,Y"
	f j=1:1:$l(secStr,","){
		s secCode=$P(secStr,",",j)
		s secDr=##class(DHCWL.MKPI.Section).GetIdByCode(secCode) ;区间ID
		s excuteCode=$P(..GetKpiSecExcCode(secCode),",",1) ;区间执行代码
		&sql(insert into DHCWL_MKPI.DHCWLCreatDataTask (DTask_KPI_DR,DTask_Section_DR,DTask_ExcuteCode,DTask_ActiveFlag,DTask_MonthExcuteCode) 
			values (:kpiDr,:secDr,:excuteCode,'Y',:secCode))
		i SQLCODE'=0 {
			s flag=1 q
		}
	}
	q:flag=1 kpiRes
				
	;2、指标池中生成数据。
	&sql(insert into DHCWL_ComplexRpt.MKpi (MKpi_KpiDr,MKpi_Mode,MKpi_Content,MKpi_DimStr,MKpi_UpdateDate) 
		values (:kpiDr,:mode,:content,:kpiDim,+$h))
		i SQLCODE=0 {
			s kpiRes=%ROWID
		}
	
	;3、指标池明细数据生成。
	q:kpiRes=0 kpiRes
	f m=1:1:$l(kpiDim,","){
		s dimCode=$P(kpiDim,",",m) ;统计项编码
		&sql(insert into DHCWL_ComplexRpt.MKpiPoolDetails (kpiPD_pool,kpiPD_DimCode,kpiPD_UpdateDate)
			values (:kpiRes,:dimCode,+$h))
			i SQLCODE'=0 {
				s flag=1 q
			}
	}
	q:flag=1 0
	q kpiRes
}

/// hetong
/// 2015-11-03
/// 指标维度串的匹配，匹配成功返回1，否则返回0
/// w ##class(DHCWL.ComplexRptData.RptCfgService).MatchKpiDimString("PatLoc,RecLoc,PatDoc","RecLoc")
ClassMethod MatchKpiDimString(toDimStr As %String, fromDimStr As %String) As %Status
{
	n (toDimStr,fromDimStr)
	q:(fromDimStr="")!(toDimStr="") 0
	s fLen=$l(fromDimStr,",")
	s tLen=$l(toDimStr,",")
	q:fLen>tLen 0
	s flag=1
	f i=1:1:fLen {
		s dimCode=$P(fromDimStr,",",i)
		s:'$find(","_toDimStr_",",","_dimCode_",") flag=0
		q:flag=0
	}
	q flag
}

/// hetong
/// 2015-10-30
/// 维护报表与指标的关联关系
/// 若原来存在关联关系则更新，否则新建立关联关系
/// 入参：rptId：报表ID，content：统计内容，poolkpi：指标池表ID
/// d ##class(DHCWL.ComplexRptData.RptCfgService).UpdateRptKpiLink("1")
ClassMethod UpdateRptKpiLink(rptId As %String, content As %String, poolkpi As %String) As %Status
{
	n (rptId,content,poolkpi)
	s poolRS=0
	q:(+rptId=0)!(content="")!(poolkpi="") 1
	
	i '$d(^DHCWL.ComplexRpt.RptLinkMkpiI("LinkRptKpi",rptId,poolkpi)){
		s pKpi=0
		f {
			s pKpi=$o(^DHCWL.ComplexRpt.RptLinkMkpiI("LinkRptKpi",rptId,pKpi)) ;指标池ID
			q:pKpi=""
			s mkpi=$lg(^DHCWL.ComplexRpt.MKpiD(pKpi),2)
			continue:'$d(^DHCWL.ComplexRpt.MKpiI("ConKpiDr",content,mkpi))
			&sql(delete from DHCWL_ComplexRpt.RptLinkMkpi where RptLink_Rpt=:rptId and RptLink_Kpi=:pKpi)
			i SQLCODE'=0 {
				s poolRS=1  q
			}
		}
		q:poolRS=1 poolRS
		q:'$d(^DHCWL.ComplexRpt.MKpiD(poolkpi)) 1
		&sql(insert into DHCWL_ComplexRpt.RptLinkMkpi (RptLink_Rpt,RptLink_Kpi)
		 values (:rptId,:poolkpi))
		 i SQLCODE'=0 s poolRS=1
	}else{
		;若已存在关联关系，可以不进行操作，也可以更新关联关系
		;&sql(update DHCWL_ComplexRpt.RptLinkMkpi set RptLink_Rpt=:rptId,RptLink_Kpi=:poolkpi
		 ;where RptLink_Rpt=:rptId and RptLink_Kpi=:poolkpi)
		;i SQLCODE'=0 s poolRS=1
	}
	q poolRS
}

/// hetong
/// 2015-11-04
/// 返回自动生成指标所需的指标代码、数据节点、指标描述等,返回结果用逗号隔开:
/// 		1、指标代码以RPTKPI开头，例如：RPTKPI0001
/// 		2、数据节点以NODERPT开头，例如：NODERPT0001
/// 		3、指标描述以"报表配置指标"开头，例如：报表配置指标1等
/// w ##class(DHCWL.ComplexRptData.RptCfgService).GetKpiCodeVsNode()
ClassMethod GetKpiCodeVsNode() As %String
{
	
	s poolDr="",result="RPTKPI0001"_","_"NODERPT0001"_","_"报表配置指标"
	s str="0000",strLen=$l(str)
	f {
		s poolDr=$o(^DHCWL.ComplexRpt.MKpiD(poolDr),-1)
		q:poolDr=""
		s lastKpi=$lg(^DHCWL.ComplexRpt.MKpiD(poolDr),2) ;指标系统指标ID
		q:$d(^DHCWL.MKPI.MKPID(lastKpi))
	}
	q:poolDr="" result
	s lastKpiCode=$lg(^DHCWL.MKPI.MKPID(lastKpi),2)
	s lastKpiName=$lg(^DHCWL.MKPI.MKPID(lastKpi),3)
	s lastKpiNode=$lg(^DHCWL.MKPI.MKPID(lastKpi),12)
	s kpiNum=+$P(lastKpiCode,"RPTKPI",2)+1
	s newKpiCode="RPTKPI"_$e(str,1,(strLen-$l(kpiNum)))_kpiNum
	s newKpiNode="NODERPT"_$e(str,1,(strLen-$l(kpiNum)))_kpiNum
	s newKpiName="报表配置指标"_kpiNum
	s result=newKpiCode_","_newKpiNode_","_newKpiName
	q result
}

/// hetong
/// 2015-11-05
/// 通过区间编码返回区间执行代码，多个用逗号隔开
/// w ##class(DHCWL.ComplexRptData.RptCfgService).GetKpiSecExcCode("D")
ClassMethod GetKpiSecExcCode(secCode As %String) As %Text
{
	n (secCode)
	s execDr=0,execStr=""
	f {
		s execDr=$o(^DHCWL.MKPI.ExecuteCodeI("TypeSubType"," TAS"," "_secCode,execDr))
		q:execDr=""
		s execCode=$lg(^DHCWL.MKPI.ExecuteCodeD(execDr),3)
		i execStr="" s execStr=execCode
		e  s execStr=execStr_","_execCode
	}
	q execStr
}

/// hetong
/// 2015-11-05
/// 通过统计模式Code返回统计模式的执行代码
/// w ##class(DHCWL.ComplexRptData.RptCfgService).GetModeExecCode("OrdDate")
ClassMethod GetModeExecCode(modeCode As %String) As %String
{
	n (modeCode)
	s modeExecStr=""
	q:modeCode="" modeExecStr
	s modeDr=$o(^DHCWL.ComplexRpt.StatModeI("StModeCode"," "_$zcvt(modeCode,"U"),""))
	q:modeDr="" modeExecStr
	s modeExecStr=$lg(^DHCWL.ComplexRpt.StatModeD(modeDr),4)
	q modeExecStr
}

/// 测试数据
/// d ##class(DHCWL.ComplexRptData.RptCfgService).Test()
ClassMethod Test() As %Status
{
	
	s dim("RptId")="5"
	s dim("Mode")="OrdDate"
	s dim("Content")="TotalPrice,Quantity"
	s dim("Row")="PatLoc,PatDoc"
	s dim("Col")="PatLoc"
	s dim("Filter")=""
	d ..CreateKpiByRptId(.dim)
	
	q
}

/// hetong
/// 2015-12-07
/// 判断指标池中是否有匹配指标，入参为统计模式、统计内容、指标维度串
/// 有匹配的返回指标ID(返回第一个匹配的指标ID)，否则返回空
/// w ##class(DHCWL.ComplexRptData.RptCfgService).GetMatchKpiPool("OrdDate","TotalPrice","PatLoc,ResLoc")
ClassMethod GetMatchKpiPool(poolMode As %String, poolContent As %String, dimString As %String) As %String
{
	n (poolMode,poolContent,dimString)
	q:((poolMode="")!(poolContent="")!(dimString="")) ""
	s mKpiPoolId=0,poolMkpi="",lenflag=0,flag=0
	s dimCode=$P(dimString,",",1)
	s dimCode2=$P(dimString,",",2)
	s dimCode3=$P(dimString,",",3)
	s dimCode4=$P(dimString,",",4)
	s dimCode5=$P(dimString,",",5)
	f{
		s mKpiPoolId=$o(^DHCWL.ComplexRpt.PoolDetailsI("PoolDimCode",dimCode,mKpiPoolId))
		q:mKpiPoolId=""
		s mode=$lg(^DHCWL.ComplexRpt.MKpiD(mKpiPoolId),3) ;统计模式
		s content=$lg(^DHCWL.ComplexRpt.MKpiD(mKpiPoolId),4) ;统计内容
		continue:mode'=poolMode
		continue:content'=poolContent
		continue:(dimCode2'="")&&('$d(^DHCWL.ComplexRpt.PoolDetailsI("PoolDimCode",dimCode2,mKpiPoolId)))
		continue:(dimCode3'="")&&('$d(^DHCWL.ComplexRpt.PoolDetailsI("PoolDimCode",dimCode3,mKpiPoolId)))
		continue:(dimCode4'="")&&('$d(^DHCWL.ComplexRpt.PoolDetailsI("PoolDimCode",dimCode4,mKpiPoolId)))
		continue:(dimCode5'="")&&('$d(^DHCWL.ComplexRpt.PoolDetailsI("PoolDimCode",dimCode5,mKpiPoolId)))
		s poolDimStr=$lg(^DHCWL.ComplexRpt.MKpiD(mKpiPoolId),5) ;指标维度串
		s fLen=$l(dimString,",")
		s tLen=$l(poolDimStr,",")
		i fLen=tLen {
			s poolMkpi=mKpiPoolId  q
		}
		i flag=0{
			s lenflag=tLen
			s poolMkpi=mKpiPoolId
			s flag=1
			continue
		}
		i lenflag>tLen {
			s lenflag=tLen
			s poolMkpi=mKpiPoolId
			continue
		}
		s lenflag=tLen
	}
	;增加指标系统与指标池是否同步判断。
	q:poolMkpi="" ""
	s mkpi=$lg(^DHCWL.ComplexRpt.MKpiD(poolMkpi),2) ;指标ID
	q:'$d(^DHCWL.MKPI.MKPID(mkpi)) ""
	q poolMkpi
}

/// hetong
/// 2015-10-22(算法改进前的检索指标方法)
/// 判断指标池中是否有匹配指标，入参为统计模式、统计内容、指标维度串
/// 有匹配的返回指标ID(返回第一个匹配的指标ID)，否则返回空
/// d ##class(DHCWL.ComplexRptData.RptCfgService).CreateKpiByRptId("1")
ClassMethod MatchKpiPool(poolMode As %String, poolContent As %String, dimString As %String) As %String
{
	n (poolMode,poolContent,dimString)
	q:((poolMode="")!(poolContent="")!(dimString="")) ""
	s mKpiPoolId=0,poolMkpi="",flag=0
	f{
		s mKpiPoolId=$o(^DHCWL.ComplexRpt.MKpiI("ModeConKpi",poolMode,poolContent,mKpiPoolId))
		q:mKpiPoolId=""
		s poolDimStr=$lg(^DHCWL.ComplexRpt.MKpiD(mKpiPoolId),5) ;指标维度串
		s fLen=$l(dimString,",")
		s tLen=$l(poolDimStr,",")
		continue:fLen>tLen
		if (..MatchKpiDimString(poolDimStr,dimString)=1){
			;s poolMkpi=$lg(^DHCWL.ComplexRpt.MKpiD(mKpiPoolId),2)
			s poolMkpi=mKpiPoolId
			s flag=1
		}
		q:flag=1
	}
	q poolMkpi
}

}
