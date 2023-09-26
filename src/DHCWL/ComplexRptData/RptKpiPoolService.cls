Import SQLUser

Class DHCWL.ComplexRptData.RptKpiPoolService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// hetong
/// 2015-11-17
/// 返回维度串描述
/// w ##class(DHCWL.ComplexRptData.RptKpiPoolService).GetKpiDimDescStr("AdmType,PatDoc,PatLoc,ResLoc")
ClassMethod GetKpiDimDescStr(dimstr As %Text) As %Text
{
	n (dimstr)
	s dimDescStr=""
	q:dimstr="" dimDescStr
	s len=$l(dimstr,",")
	f i=1:1:len{
		s dimCode=$P(dimstr,",",i)
		s id=$o(^DHCWL.ComplexRpt.StatItemI("StCode"," "_$zcvt(dimCode,"U"),""))
		s desc=$lg(^DHCWL.ComplexRpt.StatItemD(id),3)
		i dimDescStr="" s dimDescStr=desc
		e  s dimDescStr=dimDescStr_","_desc	
	}
	q dimDescStr
}

/// hetong
/// 2015-11-17
/// 根据报表code返回指标池中所有满足条件的指标
/// w ##class(DHCWL.ComplexRptData.RptKpiPoolService).GetKpiByRptCode("CWK05")
ClassMethod GetKpiByRptCode(rptCode As %String) As %Text
{
	n (rptCode)
	w "["
	s statParentNO="root"
	s jsonDatas=""
	i rptCode=""{
		w "]"  q 1
	}
	s rptId=$o(^DHCWL.ComplexRpt.RptCfgI("RptCode"," "_$zcvt(rptCode,"U"),""))
	i rptId=""{
		w "]"  q 1
	}
	s rptCfgId=$o(^DHCWL.ComplexRpt.RowsColCfgI("RCRptDr",rptId,""))
	i rptCfgId=""{
		w "]"  q 1
	}
	s rptMode=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptCfgId),3)
	s rptContent=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptCfgId),4)
	s rptRow=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptCfgId),5)
	s rptCol=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptCfgId),6)
	s rptFilter=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptCfgId),7)
	s dimArray=##class(DHCWL.ComplexRptData.RptCfgService).ResovleFilterRule(rptFilter)
	;生成规则指标维度串
	s dimStr=##class(DHCWL.ComplexRptData.RptCfgService).StructureKpiDim(rptRow,rptCol,.dimArray)
	s len=$l(rptContent,",")
	f i=1:1:len{
		s contentCode=$P(rptContent,",",i)
		s numBase=1
		&sql(SELECT St_Desc INTO :pCont FROM DHCWL_ComplexRpt.StatItem WHERE St_Code=:contentCode)
		s statNO=contentCode_numBase
		s numBase=numBase+1
		s jsonData="{""code"":"""_contentCode_""""_",""className"":"""_"DHCWL.ComplexRpt.StatItem"_""""
		s jsonData=jsonData_",""parentNO"":"""_statParentNO_""""_",""NO"":"""_contentCode_""""_",""id"":"""_contentCode_""""
		s jsonData=jsonData_",""text"":"""_pCont_"""}"
		i jsonDatas="" s jsonDatas=jsonData
		e  s jsonDatas=jsonDatas_","_jsonData
		s comRptKpiDr=0
		f {
			s comRptKpiDr=$o(^DHCWL.ComplexRpt.MKpiI("ModeConKpi",rptMode,contentCode,comRptKpiDr))
			q:comRptKpiDr=""
			;s rptLinkDr=$o(^DHCWL.ComplexRpt.RptLinkMkpiI("LinkRptKpi",rptId,comRptKpiDr,"")) ;报表关联指标表的ID
			s mkpi=$lg(^DHCWL.ComplexRpt.MKpiD(comRptKpiDr),2) ;指标
			continue:'$d(^DHCWL.MKPI.MKPID(+mkpi)) ;过滤掉指标池存在但是指标系统不存在的指标
			s kpiDesc=$lg(^DHCWL.MKPI.MKPID(mkpi),3) ;指标描述
			s kpiCode=$lg(^DHCWL.MKPI.MKPID(mkpi),2) ;指标代码
			s comDimStr=$lg(^DHCWL.ComplexRpt.MKpiD(comRptKpiDr),5) ;维度串
			s rs=##class(DHCWL.ComplexRptData.RptCfgService).MatchKpiDimString(comDimStr,dimStr)
			continue:rs'=1
			s proNo="RPTKPI"_numBase
			s numBase=numBase+1
			s jsonData="{""code"":"""_comDimStr_""""_",""className"":"""_"DHCWL.ComplexRpt.MKpi"_""""
			s jsonData=jsonData_",""parentNO"":"""_contentCode_""""_",""NO"":"""_comRptKpiDr_""""_",""id"":"""_kpiCode_""""
			s jsonData=jsonData_",""text"":"""_kpiDesc_"""}"
			s jsonDatas=jsonDatas_","_jsonData
		}
	}
	w jsonDatas
	w "]"	
	q 1
}

/// Creator:		hetong
/// CreatDate:		2016-01-12
/// Description:	返回指标已生成数据的时间区间。
/// Table:			DHCWL_MKPI.DHCWLMKPIData
/// Input:			kpi:指标的Code或者Id
/// Output:			
/// Return:			数据区间。
/// Other:		 w ##class(DHCWL.ComplexRptData.RptKpiPoolService).GetKpiDataSec("1")	
ClassMethod GetKpiDataSec(kpi As %String, sec As %String) As %String
{
	n (kpi,sec)
	s kpi=""
	s mKpiData=0
	f {
		s mKpiData=$o(^DHCWL.MKPI.MKPIDataI("MKDKPIdr",kpi,mKpiData))
		q:mKpiData=""
		s monthDr=$lg(^DHCWL.MKPI.MKPIDataD(mKpiData),2)
		
	}
}

}
