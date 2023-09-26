/// Description：诊疗节点内容表（预警规则-合理性）
/// Table：CT.WDT.CDSS.RuleRationality
Class web.CDSS.CMKB.RuleRationality Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-01-08
/// Description:获得节点内容
/// Table: CT.WDT.CDSS.RuleRationality
/// Input:节点id NodeDR
/// Return:返回节点的节点内容列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.RuleRationality","GetList","1","")
Query GetList(NodeDR As %String, desc As %String) As %Query(ROWSPEC = "NodeDR,RationalityRowId,Sequence,WarningContent,TabooLevel,Remarks,TreatSource,RuleBasisDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, NodeDR As %String, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (NodeDR="") q ""
 	s:desc'="" desc=$ZCONVERT(desc,"U")  //转换成大写
 	s:desc'="" desc=$tr(desc," ","")     //过滤空格
	s RationalityRowId = ""
	for
	{
		s RationalityRowId = $o(^CT.WDT.CDSS.RuleRationalityI("NodeDRIndex",NodeDR,RationalityRowId),-1) q:RationalityRowId=""
		s Sequence  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),3)
		s WarningContent  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),4)
		s TabooLevel  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),5)
		s Remarks  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),6)
		s TreatSource  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),7)
		s RuleBasisDR  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),8)
		if ($ZCONVERT(WarningContent,"U")[desc)
		{
			d OutputRow
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(NodeDR,RationalityRowId,Sequence,WarningContent,TabooLevel,Remarks,TreatSource,RuleBasisDR)
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
ClassMethod FormValidate(id As %String, NodeDR As %String, WarningContent As %String) As %String
{
	if (NodeDR="")||(WarningContent="") q ""
	s flag=0
	
	if $d(^CT.WDT.CDSS.RuleRationalityI("NodeDRIndex",NodeDR))
	{
		s RationalityRowId = 0
		for
		{
			s RationalityRowId = $o(^CT.WDT.CDSS.RuleRationalityI("NodeDRIndex",NodeDR,RationalityRowId)) q:(RationalityRowId="")||(flag=1)
			s WarningContent1  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),4)
			if (WarningContent1=WarningContent)&(RationalityRowId'=id)
			{
				s flag=1
			}
		}
	}
	q flag
}

/// Creator：丁亚男
/// CreatDate: 2021-01-06
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.RuleRationality
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.RuleRationality).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.RuleRationality) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		s eobj.WarningContent=##class(web.DHCBL.BDP.FunLib).EvalJSONB(eobj.WarningContent)
		s flag=..FormValidate(eobj.RationalityRowId,eobj.NodeDR,eobj.WarningContent)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
			q result
		}
		if (eobj.RationalityRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.RuleRationality).%New()
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.RuleRationality).%OpenId(eobj.RationalityRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.RuleRationality).%New() 
			if $IsObject(obj.NodeDR)
			{
			 	s bobj.NodeDR = obj.NodeDR.%Id()
			}
			s bobj.Sequence = obj.Sequence  
			s bobj.WarningContent = obj.WarningContent 
			s bobj.TabooLevel = obj.TabooLevel 
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
		s obj.WarningContent = eobj.WarningContent 
		s obj.TabooLevel = eobj.TabooLevel 
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
			
			d:eobj.RationalityRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleRationality","CT.WDT.CDSS.RuleRationality","诊疗节点内容表(合理性预警)",id,RuleDesc_","_NodeNum_","_eobj.TabooLevel,"A",eobj)
			d:eobj.RationalityRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleRationality","CT.WDT.CDSS.RuleRationality","诊疗节点内容表(合理性预警)",eobj.RationalityRowId,RuleDesc_","_NodeNum_","_eobj.TabooLevel,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(合理性预警)","web.CDSS.CMKB.RuleRationality","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(合理性预警)","web.CDSS.CMKB.RuleRationality","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2021-01-05
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.RuleRationality
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.RuleRationality).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.RuleRationality).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.RuleRationality).%New() 
	if $IsObject(obj.NodeDR)
	{
	 	s bobj.NodeDR = obj.NodeDR.%Id()
	}
	if $IsObject(obj.RuleBasisDR)
	{
	 	s bobj.RuleBasisDR = obj.RuleBasisDR.%Id()
	}
	s bobj.Sequence = obj.Sequence  
	s bobj.WarningContent = obj.WarningContent 
	s bobj.TabooLevel = obj.TabooLevel 
	s bobj.Remarks = obj.Remarks
	s bobj.TreatSource = obj.TreatSource
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator:丁亚男
/// CreatDate:2021-01-05
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.RuleRationality
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.RuleRationality).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	Ts
	//删除关联截图数据
	s RuleBasisDR  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(id)),8)
	if (RuleBasisDR'="")&&($d(^CT.WDT.CDSS.RuleBasisD(RuleBasisDR)))
	{
		s result=##class(web.CDSS.CMKB.RuleBasis).DeleteData(RuleBasisDR)
		if (result["false")
		{
			Tro	
			s result = "{success:'false',info:'诊疗节点内容（触发条件类）删除失败'}"  //返回错误信息
		}
	}
	
	s obj=##class(CT.WDT.CDSS.RuleRationality).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.RuleRationality).%New() 
	if $IsObject(obj.NodeDR)
	{
	 	s bobj.NodeDR = obj.NodeDR.%Id()
	}
	if $IsObject(obj.RuleBasisDR)
	{
	 	s bobj.RuleBasisDR = obj.RuleBasisDR.%Id()
	}
	s bobj.Sequence = obj.Sequence  
	s bobj.WarningContent = obj.WarningContent 
	s bobj.TabooLevel = obj.TabooLevel 
	s bobj.Remarks = obj.Remarks
	s bobj.TreatSource = obj.TreatSource

	s sc=##class(CT.WDT.CDSS.RuleRationality).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		s RuleDR="",NodeNum="",RuleDesc="" 
		s:bobj.NodeDR'="" RuleDR=$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(bobj.NodeDR)),2)
		s:bobj.NodeDR'="" NodeNum="节点"_$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(bobj.NodeDR)),4)
		s:RuleDR'="" RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleRationality","CT.WDT.CDSS.RuleRationality","诊疗节点内容表(合理性预警)",id,RuleDesc_","_NodeNum_","_bobj.TabooLevel,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(合理性预警)","web.CDSS.CMKB.RuleRationality","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// Creator:石萧伟
/// CreatDate:2022-05-09
/// Input:RowId 预警内容id，SourceId 来源表id
/// Return:
/// Other:w ##class(web.CDSS.CMKB.RuleRationality).ChangeSource("44922","11")
ClassMethod ChangeSource(RowId, SourceId)
{
	s result="{success:'true'}"
	s eobj = ##class(web.CDSSEntity.CMKB.RuleRationality).%New()	 	
 	s obj=##class(CT.WDT.CDSS.RuleRationality).%OpenId(RowId)
 	s bobj = ##class(web.CDSSEntity.CMKB.RuleRationality).%New()
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
		//s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(合理性预警)","web.CDSS.CMKB.RuleRationality","ChangeSource",eobj)
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
/// Other: w ##class(web.CDSS.CMKB.RuleRationality).GetFileTypeAndSource("44969")
ClassMethod GetFileTypeAndSource(id As %String)
{
		s result = ""
		s obj=##class(CT.WDT.CDSS.RuleRationality).%OpenId(id)
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
