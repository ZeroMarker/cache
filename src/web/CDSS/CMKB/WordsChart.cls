/// Description：识别词流程图表
/// Table：CT.WDT.CDSS.WordsChart
Class web.CDSS.CMKB.WordsChart Extends %RegisteredObject
{

/*
/// Creator：丁亚男
/// CreatDate: 2021-01-06
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.WordsChart
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.WordsChart).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.WordsChart) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		
		if (eobj.ChartRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.WordsChart).%New()
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.WordsChart).%OpenId(eobj.ChartRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.WordsChart).%New() 
			if $IsObject(obj.WordsDR)
			{
			 	s bobj.WordsDR = obj.WordsDR.%Id()
			}
			s bobj.FlowChartJson = obj.FlowChartJson
			s bobj.Remarks = obj.Remarks
		}
		d:eobj.WordsDR'="" obj.WordsDRSetObjectId(eobj.WordsDR)
		//s obj.FlowChartJson = eobj.FlowChartJson
		//s ^TMP("SXW")=eobj.FlowChartJson
		//保存流
		s ChartStream=##class(%Stream.GlobalCharacter).%New()
    	d ChartStream.Write(eobj.FlowChartJson)
    	s obj.FlowChartJson=ChartStream
    	
		s obj.Remarks = eobj.Remarks
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.ChartRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.WordsChart","CT.WDT.CDSS.WordsChart","识别词流程图表",id,eobj.WordsDR,"A",eobj)
			d:eobj.ChartRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.WordsChart","CT.WDT.CDSS.WordsChart","识别词流程图表",eobj.ChartRowId,eobj.WordsDR,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词流程图表","web.CDSS.CMKB.WordsChart","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词流程图表","web.CDSS.CMKB.WordsChart","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}
*/
/// Creator：丁亚男
/// CreatDate: 2021-01-06
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.WordsChart
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.WordsChart).SaveEntity()
ClassMethod SaveData(ChartRowId, WordsDR, ChartJson, Remarks) As %String
{
	s $zt="ERROR"
	s result=""
	//保存日志
	s eobj = ##class(web.CDSSEntity.CMKB.WordsChart).%New()
	s eobj.ChartRowId = ChartRowId 
	s eobj.WordsDR = WordsDR
	s eobj.FlowChartJson = ChartJson
	s eobj.Remarks = Remarks
	
	
	if $IsObject(eobj)
	{ 
		
		if (eobj.ChartRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.WordsChart).%New()
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.WordsChart).%OpenId(eobj.ChartRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.WordsChart).%New() 
			if $IsObject(obj.WordsDR)
			{
			 	s bobj.WordsDR = obj.WordsDR.%Id()
			}
			s bobj.FlowChartJson = obj.FlowChartJson
			s bobj.Remarks = obj.Remarks
		}
		
		d:WordsDR'="" obj.WordsDRSetObjectId(WordsDR)
		d:WordsDR="" obj.WordsDRSetObjectId("")
	
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
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			s WordsDesc=""
			if (eobj.WordsDR'="")
			{
				s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(eobj.WordsDR)),3)
			}
			d:eobj.ChartRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.WordsChart","CT.WDT.CDSS.WordsChart","识别词流程图表",id,WordsDesc,"A",eobj)
			d:eobj.ChartRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.WordsChart","CT.WDT.CDSS.WordsChart","识别词流程图表",eobj.ChartRowId,WordsDesc,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词流程图表","web.CDSS.CMKB.WordsChart","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词流程图表","web.CDSS.CMKB.WordsChart","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2021-01-05
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.WordsChart
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.WordsChart).OpenData("3")
ClassMethod OpenData(WordsDR As %String) As %String
{
	s str=""
	s id=$O(^CT.WDT.CDSS.WordsChartI("WordsDRIndex",WordsDR,""))
	if (id'="")
	{
		s obj=##class(CT.WDT.CDSS.WordsChart).%OpenId(id)
		s bobj = ##class(web.CDSSEntity.CMKB.WordsChart).%New() 
		s bobj.ChartRowId=id
		if $IsObject(obj.WordsDR)
		{
		 	s bobj.WordsDR = obj.WordsDR.%Id()
		}
		//s bobj.FlowChartJson = obj.FlowChartJson
		//读取流
		s Stream=obj.FlowChartJson
        s len=Stream.SizeGet()
        d Stream.Rewind()
        s bobj.FlowChartJson=Stream.Read(len)
        
		s bobj.Remarks = obj.Remarks
		d obj.%Close()	
		k obj
		s str = bobj.JsonS()	
	}
	q str
}

/// Creator:丁亚男
/// CreatDate:2021-01-05
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.WordsChart
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.WordsChart).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	Ts
	s obj=##class(CT.WDT.CDSS.WordsChart).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.WordsChart).%New() 
	if $IsObject(obj.WordsDR)
	{
	 	s bobj.WordsDR = obj.WordsDR.%Id()
	}
	s bobj.FlowChartJson = obj.FlowChartJson
	s bobj.Remarks = obj.Remarks
	
	s sc=##class(CT.WDT.CDSS.WordsChart).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		s WordsDesc=""
		if (bobj.WordsDR'="")
		{
			s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(bobj.WordsDR)),3)
		}
			
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.WordsChart","CT.WDT.CDSS.WordsChart","识别词流程图表",id,WordsDesc,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词流程图表","web.CDSS.CMKB.WordsChart","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// others:w ##class(web.CDSS.CMKB.WordsChart).UpdateRuleChart()
ClassMethod UpdateRuleChart()
{
	//k ^TMPWCHART
	M ^TMPWCHART("D")=^CT.WDT.CDSS.WordsChartD
	M ^TMPWCHART("I")=^CT.WDT.CDSS.WordsChartI
	k ^CT.WDT.CDSS.WordsChartD
	k ^CT.WDT.CDSS.WordsChartI
	
	s count=0
	s RowId=0
    for 
    {
    	s RowId=$O(^TMPWCHART("D",RowId)) q:RowId=""
    	
		s WordsDR = $lg($g(^TMPWCHART("D",RowId)),2)
		
		s ChartJson =$lg($g(^TMPWCHART("D",RowId)),3)
		s Remarks = $lg($g(^TMPWCHART("D",RowId)),4)
		
		s obj=##class(CT.WDT.CDSS.WordsChart).%New()
		d:WordsDR'="" obj.WordsDRSetObjectId(WordsDR)
		d:WordsDR="" obj.WordsDRSetObjectId("")
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
