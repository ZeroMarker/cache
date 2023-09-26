/// Description：诊疗流程图表
/// Table：CT.WDT.CDSS.RuleChart
Class web.CDSS.CMKB.RuleChart Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2021-01-06
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.RuleChart
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.RuleChart).SaveEntity()
ClassMethod SaveData(ChartRowId, RuleDR, ChartJson, Remarks, RuleTypeDR) As %String
{
	s $zt="ERROR"
	//s ^TMPDYN("DYN")=ChartJson
	s result=""
	//保存日志
	s eobj = ##class(web.CDSSEntity.CMKB.RuleChart).%New()
	s eobj.ChartRowId = ChartRowId 
	s eobj.RuleDR = RuleDR
	s eobj.FlowChartJson = ChartJson
	s eobj.Remarks = Remarks
	s eobj.RuleTypeDR = RuleTypeDR
	
	if (ChartRowId="")  //如果RowId未赋值则增加
	{ 
		s obj=##class(CT.WDT.CDSS.RuleChart).%New()
	}
	else   //如果RowId已赋值则修改
	{
		s obj=##class(CT.WDT.CDSS.RuleChart).%OpenId(ChartRowId)
		s bobj = ##class(web.CDSSEntity.CMKB.RuleChart).%New() 
		if $IsObject(obj.RuleDR)
		{
		 	s bobj.RuleDR = obj.RuleDR.%Id()
		}
		s bobj.FlowChartJson = obj.FlowChartJson
		s bobj.Remarks = obj.Remarks
		if $IsObject(obj.RuleTypeDR)
		{
		 	s bobj.RuleTypeDR = obj.RuleTypeDR.%Id()
		}
	}
	
	d:RuleDR'="" obj.RuleDRSetObjectId(RuleDR)
	d:RuleDR="" obj.RuleDRSetObjectId("")
	//判断是否是流对象
	if ($isobject(ChartJson))
	{
		s obj.FlowChartJson=ChartJson
	}
	else
	{			
		s ChartStream=##class(%Stream.GlobalCharacter).%New()
    	d ChartStream.Write(ChartJson)
    	s obj.FlowChartJson=ChartStream
	}
	
	//s obj.FlowChartJson = eobj.FlowChartJson
	s obj.Remarks = Remarks
	d:RuleTypeDR'="" obj.RuleTypeDRSetObjectId(RuleTypeDR)
	d:RuleTypeDR="" obj.RuleTypeDRSetObjectId("")
	
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" 
		//保存日志
		s RuleDesc=""
		s:RuleDR'="" RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
		d:ChartRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleChart","CT.WDT.CDSS.RuleChart","诊疗流程图表",id,RuleDesc,"A",eobj)
		d:ChartRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleChart","CT.WDT.CDSS.RuleChart","诊疗流程图表",ChartRowId,RuleDesc,"U",eobj,bobj)
		
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗流程图表","web.CDSS.CMKB.RuleChart","SaveData",eobj)
   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗流程图表","web.CDSS.CMKB.RuleChart","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2021-01-05
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.RuleChart
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.RuleChart).OpenData("3")
ClassMethod OpenData(RuleDR As %String, RuleTypeDR) As %String
{
	s str=""
	s:RuleTypeDR="" RuleTypeDR=-100000000000000
	s id=$O(^CT.WDT.CDSS.RuleChartI("RuleTypeDRIndex",RuleDR,RuleTypeDR,""))
	if (id'="")
	{
		s obj=##class(CT.WDT.CDSS.RuleChart).%OpenId(id)
		s bobj = ##class(web.CDSSEntity.CMKB.RuleChart).%New() 
		s bobj.ChartRowId=id
		if $IsObject(obj.RuleDR)
		{
		 	s bobj.RuleDR = obj.RuleDR.%Id()
		}
		//s bobj.FlowChartJson = obj.FlowChartJson
		//读取流
		s Stream=obj.FlowChartJson
        s len=Stream.SizeGet()
        d Stream.Rewind()
        s bobj.FlowChartJson=Stream.Read(len)
        
		s bobj.Remarks = obj.Remarks
		if $IsObject(obj.RuleTypeDR)
		{
		 	s bobj.RuleTypeDR = obj.RuleTypeDR.%Id()
		}
		d obj.%Close()	
		k obj
		s str = bobj.JsonS()	
	}
	q str
}

/// Creator:丁亚男
/// CreatDate:2021-01-05
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.RuleChart
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.RuleChart).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	Ts
	s obj=##class(CT.WDT.CDSS.RuleChart).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.RuleChart).%New() 
	if $IsObject(obj.RuleDR)
	{
	 	s bobj.RuleDR = obj.RuleDR.%Id()
	}
	s bobj.FlowChartJson = obj.FlowChartJson
	s bobj.Remarks = obj.Remarks
	if $IsObject(obj.RuleTypeDR)
	{
	 	s bobj.RuleTypeDR = obj.RuleTypeDR.%Id()
	}
	s sc=##class(CT.WDT.CDSS.RuleChart).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		s RuleDesc=""
		s:bobj.RuleDR'="" RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(bobj.RuleDR)),3)
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleChart","CT.WDT.CDSS.RuleChart","诊疗流程图表",id,RuleDesc,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗流程图表","web.CDSS.CMKB.RuleChart","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// others:w ##class(web.CDSS.CMKB.RuleChart).UpdateRuleChart()
ClassMethod UpdateRuleChart()
{
	//k ^TMPRCHART
	M ^TMPRCHART("D")=^CT.WDT.CDSS.RuleChartD
	M ^TMPRCHART("I")=^CT.WDT.CDSS.RuleChartI
	k ^CT.WDT.CDSS.RuleChartD
	k ^CT.WDT.CDSS.RuleChartI
	
	s count=0,fcount=0
	s RowId=0
    for 
    {
    	s RowId=$O(^TMPRCHART("D",RowId)) q:RowId=""
    	//s eobj = ##class(web.CDSSEntity.CMKB.RuleChart).%New() 
		s RuleDR = $lg($g(^TMPRCHART("D",RowId)),2)
		
		s ChartJson =$lg($g(^TMPRCHART("D",RowId)),3)
		s Remarks = $lg($g(^TMPRCHART("D",RowId)),4)
		s RuleTypeDR = $lg($g(^TMPRCHART("D",RowId)),5)
		
		s obj=##class(CT.WDT.CDSS.RuleChart).%New()
		d:RuleDR'="" obj.RuleDRSetObjectId(RuleDR)
		d:RuleDR="" obj.RuleDRSetObjectId("")
		//判断是否是流对象
		if ($isobject(ChartJson))
		{
			s obj.FlowChartJson=ChartJson
		}
		else
		{			
			s ChartStream=##class(%Stream.GlobalCharacter).%New()
	    	d ChartStream.Write(ChartJson)
	    	s obj.FlowChartJson=ChartStream
		}
		s obj.Remarks = Remarks
		d:RuleTypeDR'="" obj.RuleTypeDRSetObjectId(RuleTypeDR)
		d:RuleTypeDR="" obj.RuleTypeDRSetObjectId("")
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s count=count+1
			
		}
		else
		{
			Trollback
			s fcount=fcount+1
		}	
	}
	q count
}

}
