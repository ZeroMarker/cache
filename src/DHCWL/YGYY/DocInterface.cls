/// 用来提供医生当前科室抗菌药物使用情况
/// 默认取上个月数据
/// 方法返回使用率，使用强度，耐药率
Class DHCWL.YGYY.DocInterface Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     zyb
/// CreatDate：   2014-04-18
/// Description： 返回门急诊科室上个月抗菌药物的使用率，耐药率 
/// Table：       
/// Input：       startDate：开始日期, endDate：结束日期, dept：医生当前登陆科室
/// Output：      
/// Return：      ret：使用率，耐药率
/// Others： 	  startDate,endDate为空时默认取上个月数据
/// w ##class(DHCWL.YGYY.DocInterface).GetOutDeptAntiData("2012-11-01","2013-11-03","6")   
ClassMethod GetOutDeptAntiData(startDate As %String = "", endDate As %String = "", dept As %String) As %String
{
	n (startDate,endDate,dept)
	
	s ret=""
	s isRealData=""
	s choiceType="freeDateChoice"
	i (startDate="")||(endDate="") s choiceType="lastMonth"
	s filterRule= "KP1234:({patLoc}="_dept_"),KP1232:({patLoc}="_dept_"),KP1304:({ctloc}="_dept_")"
    s kpi="KP1234:patLoc,KP1232:patLoc,KP1304:ctloc^sen"
	set rs=##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate")
	set sc=rs.Execute(kpi,startDate,endDate,choiceType,isRealData,filterRule)
	s mjzrc="",mjzkjrc="",xjNums="",nyNums=""

	While rs.Next(.sc) { 
	    s kpiCode=$g(rs.Data("kpiCode"))
	    s dimId=$g(rs.Data("dimId"))
		s value=$g(rs.Data("value"))
	    i kpiCode="KP1234" d
	    .s mjzrc=$g(mjzrc)+value  
	    i kpiCode="KP1232" d
	    .s mjzkjrc=$g(mjzkjrc)+value
	    i (kpiCode="KP1304") d
	    .s xjNums=$g(xjNums)+value
	    .s flag=$p($g(dimId),",",4)
	    .i flag="R" s nyNums=$g(nyNums)+value
    }
    
    s usepercent=$$GetPercent^DHCWLCommon($g(mjzkjrc),$g(mjzrc)) ;抗菌使用率
    s nypercent=$$GetPercent^DHCWLCommon($g(nyNums,0),$g(xjNums,0)) ;细菌耐药率
    s ret=$g(usepercent)_","_$g(nypercent,0)
    q ret
}

/// Creator：     zyb
/// CreatDate：   2014-04-18
/// Description： 返回住院科室上个月抗菌药物的使用率，使用强度，耐药率 
/// Table：       
/// Input：       startDate：开始日期, endDate：结束日期, dept：医生当前登陆科室
/// Output：      
/// Return：      ret：使用率，使用强度，耐药率
/// Others： 	  startDate,endDate为空时默认取上个月数据
/// KP1261：出院人次  KP1259：出院使用抗菌药人次  KP1247：出院病人抗菌药物DDD数  KP1248：出院病人住院天数  KP1304：细菌耐药
/// w ##class(DHCWL.YGYY.DocInterface).GetInDeptAntiData("2014-01-11","2014-01-11","")   
ClassMethod GetInDeptAntiData(startDate As %String = "", endDate As %String = "", dept As %String) As %String
{
	n (startDate,endDate,dept)
    
	s ret=""
	s choiceType="freeDateChoice"
	i (startDate="")||(endDate="") s choiceType="lastMonth"
	s isRealData=""
	s filterRule="KP1261:({disLoc}="_dept_"),KP1259:({disLoc}="_dept_"),KP1247:({disLoc}="_dept_"),KP1248:({disLoc}="_dept_"),KP1304:({ctloc}="_dept_")"
    s kpi="KP1261:patLoc,KP1259:patLoc,KP1247:disLoc,KP1248:disLoc,KP1304:ctloc^sen"
	set rs=##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate")
	set sc=rs.Execute(kpi,startDate,endDate,choiceType,isRealData,filterRule)
	s cyrs="",cykjrs="",cykjDDD="",zyts="",xjNums="",nyNums=""
	
	While rs.Next(.sc) { 
	    s kpiCode=$g(rs.Data("kpiCode"))
	    s dimId=$g(rs.Data("dimId"))
		s value=$g(rs.Data("value"))
	    i kpiCode="KP1261" d
	    .s cyrs=$g(cyrs)+value  
	    i kpiCode="KP1259" d
	    .s cykjrs=$g(cykjrs)+value  
	    i kpiCode="KP1247" d
	    .s cykjDDD=$g(cykjDDD)+value  
	    i kpiCode="KP1248" d
	    .s zyts=$g(zyts)+value	    
	    i (kpiCode="KP1304") d
	    .s xjNums=$g(xjNums)+value
	    .s flag=$p($g(dimId),",",4)
	    .i flag="R" s nyNums=$g(nyNums)+value

    }
    // GetPercent
    s usepercent=$$GetPercent^DHCWLCommon($g(mjzkjrc,0),$g(mjzrc,0)) ;抗菌使用率
    s useqd=$$GetPercent^DHCWLCommon(($g(cykjDDD,0)*100),($g(cyrs,0)*$g(zyts,0))) ;抗菌使用强度
    s nypercent=$$GetPercent^DHCWLCommon($g(nyNums,0),$g(xjNums,0)) ;细菌耐药率
    s ret=usepercent_","_useqd_","_nypercent   
    q ret
}

}
