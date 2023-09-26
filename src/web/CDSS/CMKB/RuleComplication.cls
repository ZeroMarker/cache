/// Description：诊疗节点内容表（预警规则-并发症）
/// Table：CT.WDT.CDSS.RuleComplication
Class web.CDSS.CMKB.RuleComplication Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-01-08
/// Description:获得节点内容
/// Table: CT.WDT.CDSS.RuleComplication
/// Input:节点id NodeDR
/// Return:返回节点的节点内容列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.RuleComplication","GetList","1","")
Query GetList(NodeDR As %String, desc As %String) As %Query(ROWSPEC = "NodeDR,ComplicationRowId,Sequence,ComplicationDR,ComplicationDRDesc,MainPoints,Remarks,TreatSource,RuleBasisDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, NodeDR As %String, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (NodeDR="") q ""
 	s:desc'="" desc=$ZCONVERT(desc,"U")  //转换成大写
 	s:desc'="" desc=$tr(desc," ","")     //过滤空格
	s ComplicationRowId = ""
	for
	{
		s ComplicationRowId = $o(^CT.WDT.CDSS.RuleComplicationI("NodeDRIndex",NodeDR,ComplicationRowId),-1) q:ComplicationRowId=""
		s Sequence  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),3)
		s ComplicationDR  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),4)
		s ComplicationDRDesc=""
		s:ComplicationDR'="" ComplicationDRDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(ComplicationDR)),3)
		s MainPoints  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),5)
		s Remarks  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),6)
		s TreatSource  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),7)
		s RuleBasisDR  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),8)
		if ($ZCONVERT(ComplicationDRDesc,"U")[desc)
		{
			d OutputRow
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(NodeDR,ComplicationRowId,Sequence,ComplicationDR,ComplicationDRDesc,MainPoints,Remarks,TreatSource,RuleBasisDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 丁亚男
/// CreateDate:2021-06-224   
/// w ##class(web.CDSS.CMKB.RuleComplication).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, NodeDR As %String, ComplicationDR As %String) As %String
{
	if (NodeDR="")||(ComplicationDR="") q ""
	s flag="",flagc=""
	s flagc=$d(^CT.WDT.CDSS.RuleComplicationI("NodeCompDRIndex",NodeDR,ComplicationDR))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s idc=$o(^CT.WDT.CDSS.RuleComplicationI("NodeCompDRIndex",NodeDR,ComplicationDR,0))
		if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Creator：丁亚男
/// CreatDate: 2021-01-06
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.RuleComplication
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.RuleComplication).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.RuleComplication) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		s flag=..FormValidate(eobj.ComplicationRowId,eobj.NodeDR,eobj.ComplicationDR)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
			q result
		}
		
		if (eobj.ComplicationRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.RuleComplication).%New()
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.RuleComplication).%OpenId(eobj.ComplicationRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.RuleComplication).%New() 
			if $IsObject(obj.NodeDR)
			{
			 	s bobj.NodeDR = obj.NodeDR.%Id()
			}
			s bobj.Sequence = obj.Sequence  
			if $IsObject(obj.ComplicationDR)
			{
			 	s bobj.ComplicationDR = obj.ComplicationDR.%Id()
			}
			s bobj.MainPoints = obj.MainPoints 
			s bobj.Remarks = obj.Remarks
			s bobj.TreatSource = obj.TreatSource
			if $IsObject(obj.RuleBasisDR)
			{
			 	s bobj.RuleBasisDR = obj.RuleBasisDR.%Id()
			}
		}
		d:eobj.NodeDR'="" obj.NodeDRSetObjectId(eobj.NodeDR)
		d:eobj.RuleBasisDR'="" obj.RuleBasisDRSetObjectId(eobj.RuleBasisDR)
		s obj.Sequence = eobj.Sequence  
		d:eobj.ComplicationDR'="" obj.ComplicationDRSetObjectId(eobj.ComplicationDR)
		s obj.MainPoints = eobj.MainPoints 
		s obj.Remarks = eobj.Remarks
		s obj.TreatSource = eobj.TreatSource
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			s RuleDR="",NodeNum="",RuleDesc="" 
			s:eobj.NodeDR'="" RuleDR=$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(eobj.NodeDR)),2)
			s:eobj.NodeDR'="" NodeNum="节点"_$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(eobj.NodeDR)),4)
			s:RuleDR'="" RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
			s ComplicationDRDesc=""
			s:eobj.ComplicationDR'="" ComplicationDRDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(eobj.ComplicationDR)),3)
			
			d:eobj.ComplicationRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleComplication","CT.WDT.CDSS.RuleComplication","诊疗节点内容表(并发症预警)",id,RuleDesc_","_NodeNum_","_ComplicationDRDesc,"A",eobj)
			d:eobj.ComplicationRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleComplication","CT.WDT.CDSS.RuleComplication","诊疗节点内容表(并发症预警)",eobj.ComplicationRowId,RuleDesc_","_NodeNum_","_ComplicationDRDesc,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(并发症预警)","web.CDSS.CMKB.RuleComplication","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(并发症预警)","web.CDSS.CMKB.RuleComplication","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2021-01-05
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.RuleComplication
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.RuleComplication).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.RuleComplication).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.RuleComplication).%New() 
	if $IsObject(obj.NodeDR)
	{
	 	s bobj.NodeDR = obj.NodeDR.%Id()
	}
	s bobj.Sequence = obj.Sequence  
	if $IsObject(obj.ComplicationDR)
	{
	 	s bobj.ComplicationDR = obj.ComplicationDR.%Id()
	}
	s bobj.MainPoints = obj.MainPoints 
	s bobj.Remarks = obj.Remarks
	if $IsObject(obj.RuleBasisDR)
	{
	 	s bobj.RuleBasisDR = obj.RuleBasisDR.%Id()
	}
	s bobj.TreatSource = obj.TreatSource
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator:丁亚男
/// CreatDate:2021-01-05
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.RuleComplication
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.RuleComplication).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	Ts
	//删除关联截图数据
	s RuleBasisDR  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(id)),8)
	if (RuleBasisDR'="")&&($d(^CT.WDT.CDSS.RuleBasisD(RuleBasisDR)))
	{
		s result=##class(web.CDSS.CMKB.RuleBasis).DeleteData(RuleBasisDR)
		if (result["false")
		{
			Tro	
			s result = "{success:'false',info:'诊疗节点内容（触发条件类）删除失败'}"  //返回错误信息
		}
	}
	
	s obj=##class(CT.WDT.CDSS.RuleComplication).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.RuleComplication).%New() 
	if $IsObject(obj.NodeDR)
	{
	 	s bobj.NodeDR = obj.NodeDR.%Id()
	}
	s bobj.Sequence = obj.Sequence  
	if $IsObject(obj.ComplicationDR)
	{
	 	s bobj.ComplicationDR = obj.ComplicationDR.%Id()
	}
	s bobj.MainPoints = obj.MainPoints 
	s bobj.Remarks = obj.Remarks
	if $IsObject(obj.RuleBasisDR)
	{
	 	s bobj.RuleBasisDR = obj.RuleBasisDR.%Id()
	}
	s bobj.TreatSource = obj.TreatSource
	s sc=##class(CT.WDT.CDSS.RuleComplication).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		s RuleDR="",NodeNum="",RuleDesc="" 
		s:bobj.NodeDR'="" RuleDR=$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(bobj.NodeDR)),2)
		s:bobj.NodeDR'="" NodeNum="节点"_$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(bobj.NodeDR)),4)
		s:RuleDR'="" RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
		s ComplicationDRDesc=""
		s:bobj.ComplicationDR'="" ComplicationDRDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(bobj.ComplicationDR)),3)
			
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleComplication","CT.WDT.CDSS.RuleComplication","诊疗节点内容表(并发症预警)",id,RuleDesc_","_NodeNum_","_ComplicationDRDesc,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(并发症预警)","web.CDSS.CMKB.RuleComplication","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// Creator:石萧伟
/// CreatDate:2022-05-09
/// Input:RowId 并发症id，SourceId 来源表id
/// Return:
/// Other:w ##class(web.CDSS.CMKB.RuleComplication).ChangeSource("722","59")
ClassMethod ChangeSource(RowId, SourceId)
{
	s result="{success:'true'}"
	s eobj = ##class(web.CDSSEntity.CMKB.RuleComplication).%New()	 	
 	s obj=##class(CT.WDT.CDSS.RuleComplication).%OpenId(RowId)
 	s bobj = ##class(web.CDSSEntity.CMKB.RuleComplication).%New()
 	s eobj.RuleBasisDR = SourceId
	if $IsObject(obj.RuleBasisDR)
	{
	 	s bobj.RuleBasisDR = obj.RuleBasisDR.%Id()
	}
	d:eobj.RuleBasisDR'="" obj.RuleBasisDRSetObjectId(eobj.RuleBasisDR)
 	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		//保存日志 描述拼接操作，在日志中读取显示
		//d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleRationality","CT.WDT.CDSS.RuleRationality","诊疗节点内容表(合理性预警)",RowId,obj.WarningContent,"U",eobj,bobj)  
		
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(合理性预警)","web.CDSS.CMKB.CT_WDT_CDSS.RuleRationality","ChangeSource",eobj)
   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator：石萧伟
/// CreatDate: 2022-04-07
/// Description：获取来源类型及路径
/// Table：CT.WDT.CDSS.RuleResult
/// Input：id
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.RuleComplication).GetFileTypeAndSource("731")
ClassMethod GetFileTypeAndSource(id As %String)
{
		s result = ""
		s obj=##class(CT.WDT.CDSS.RuleComplication).%OpenId(id)
        s RuleBasisDR = ""
        if $IsObject(obj.RuleBasisDR)
		{
		 	s RuleBasisDR = obj.RuleBasisDR.%Id()
		}
		s docName = obj.TreatSource
       	/*if ((SourceImg="")&(RuleBasisDR="")){
	       	s docName = obj.TreatSource
	    	s result = "{type:'doc',source:'"_docName_".pdf'}" 
	    }elseif(SourceImg'=""){
			s result = "{type:'img',source:'"_SourceImg_"'}" 
		}else{
			
		}*/
		
		s isExistDoc = ##class(web.DHCBL.BDP.BDPUploadFile).IsExistsFile("scripts\\bdp\\MKB\\Doc\\Doc\\"_docName_".pdf")
		s docSource = ""
		if (isExistDoc=1){
			s docSource = docName_".pdf"
		}
		s htmlSource = ""
		if (RuleBasisDR'=""){
			s htmlSource = ##class(web.CDSS.CMKB.RuleBasis).getRuleSource(RuleBasisDR)
		}
		s result = "[{type:'doc',source:'"_docSource_"'},{type:'html',source:'"_htmlSource_"'}]"
		d obj.%Close()	
		k obj	
		q result
}

}
