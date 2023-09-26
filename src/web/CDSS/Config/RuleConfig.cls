/// 名称:诊疗规则配置V2.0
/// 描述:诊疗规则配置V2.0
/// 编写者:基础数据平台组 - Xuwenhu
/// 编写日期:2022-01-12
Class web.CDSS.Config.RuleConfig Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:Xuwenhu
/// CreatDate:2022-01-12
/// Description:打开数据
/// Table:CF.WDT.CDSS.MKBConfig
/// Input:
/// Return:json
/// Others:w ##class(web.CDSS.Config.RuleConfig).OpenData()
ClassMethod OpenData() As %String
{
	s str=""
	s RedAlertLevel=..GetConfigValue("RedAlertLevel")			//红色预警
	s OrangeAlertLevel=..GetConfigValue("OrangeAlertLevel")		//橙色预警
	s BlueAlertLevel=..GetConfigValue("BlueAlertLevel")			//蓝色预警
	s AlertTimes=..GetConfigValue("AlertNumber")				//弹窗次数
	s AlertNeedReason=..GetConfigValue("AlertNeedReason")		//填写原因
	
	s str="{""RedAlertLevel"":"""_RedAlertLevel_""""_",""OrangeAlertLevel"":"""_OrangeAlertLevel_""",""BlueAlertLevel"":"""_BlueAlertLevel_""",""AlertTimes"":"""_AlertTimes_""",""AlertNeedReason"":"""_AlertNeedReason_"""}"
	
	q str
}

/// Creator:Xuwenhu
/// CreatDate:2022-01-12
/// Description:根据配置code 查询到配置的值
/// Table:User.MKBStructuredBase
/// Input:code：配置code
/// Return:配置值
/// Others:w ##class(web.CDSS.Config.RuleConfig).GetConfigValue("CDSSzrf2020091703")
ClassMethod GetConfigValue(code As %String) As %String
{
  s ConfigCode=""
  s ConfigValue=""
  s:code'="" ConfigCode=$ZCONVERT(code,"U")
  s id=$o(^CF.WDT.CDSS.MKBConfigI("ConfigCodeI"," "_ConfigCode,0))
  if (id'=""){
    s ConfigValue=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),3)
    s ConfigActive=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),6)
  }
  else{
    s ConfigValue=""
  }
  q ConfigValue
}

/// Creator:Xuwenhu
/// CreatDate:2022-01-12
/// Description:保存平台配置数据
/// Table:CF.WDT.CDSS.MKBConfig
/// Input:ConfigStr-配置信息串
/// Return:success-成功，false-失败
/// Others:w ##class(web.CDSS.Config.RuleConfig).SaveMKBConfigData(ConfigStr)
ClassMethod SaveMKBConfigData(ConfigStr) As %String
{
	q:ConfigStr="" ""
	s result=""
	for i=1:1:$l(ConfigStr,",")
	{
		s SingleConfig=$p(ConfigStr,",",i)
		s ConfigCode=$p(SingleConfig,":",1)				//配置代码
		s ConfigValue=$p(SingleConfig,":",2)			//配置值
		s ConfigID=$o(^CF.WDT.CDSS.MKBConfigI("ConfigCodeI"," "_$ZCONVERT(ConfigCode,"U"),0))
		continue:ConfigID=""
		
	  	s ConfigDesc=$listget($g(^CF.WDT.CDSS.MKBConfigD(ConfigID)),2)
		s eobj=##class(web.CDSSEntity.Config.MKBConfigAdmin).%New()
		s eobj.ID=ConfigID
		s eobj.ConfigCode=ConfigCode
		s eobj.ConfigDesc=ConfigDesc
		s eobj.ConfigValue=ConfigValue
		
		s result=##class(web.CDSS.Config.MKBConfig).SaveEntity(eobj)
		if result["true"
		{
			s result="success"
		}
		else
		{
			s result="false"	
		}
	}
	q result
}

/// Creator：Xuwenhu
/// CreatDate: 2022-01-12
/// Description：查询诊疗规则
/// Table：User.DHCDSSMedicalRule
/// Input：rowid,ruletype,ruledesc,ruletip,rulelevel
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Config.RuleConfig","GetList","","","","","")
Query GetList(rowid, ruletype, ruledesc, ruletip, rulelevel) As %Query(ROWSPEC = "RuleRowId,RuleDesc,RuleTypeDesc,WarningContent,AlertLevel")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, ruletype, ruledesc, ruletip, rulelevel) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (rowid'="") //根据rowid返回该条记录
	{
		s RuleRowId=rowid
		s NodeDR=$lg($g(^CT.WDT.CDSS.RuleRationalityD(RuleRowId)),2)			//流程图节点
		s:NodeDR'="" RuleDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),2)		//规则字典表指针
		if RuleDR'=""
		{
			s RuleDesc=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)				//规则概述
			s RuleType=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleDR)),6)				//规则流程类型（辅助诊疗规则/诊断预警规则/检验检查预警规则/手术并发症规则/输血合理性规则/手术合理性规则/过敏合理性规则/护理合理性规则）
		}	
		
		s Sequence=$lg($g(^CT.WDT.CDSS.RuleRationalityD(RuleRowId)),3)		//顺序
		s WarningContent=$lg($g(^CT.WDT.CDSS.RuleRationalityD(RuleRowId)),4)	//提醒内容
		s TabooLevel=$lg($g(^CT.WDT.CDSS.RuleRationalityD(RuleRowId)),5)		//禁忌级别（A-绝对、R-相对、M-注意事项）
		s Remarks=$lg($g(^CT.WDT.CDSS.RuleRationalityD(RuleRowId)),6)		//备注
		
		d OutputRow
	}
	else
	{
		s:ruledesc'="" ruledesc=$ZCONVERT(ruledesc,"U") //转换成大写 
		s:ruletip'="" ruletip=$ZCONVERT(ruletip,"U") //转换成大写
		s RuleRowId=""
		for
		{
			s RuleRowId=$o(^CT.WDT.CDSS.RuleRationalityD(RuleRowId))
			q:RuleRowId=""
			s NodeDR=$lg($g(^CT.WDT.CDSS.RuleRationalityD(RuleRowId)),2)			//流程图节点
			s RuleDR=""
			s:NodeDR'="" RuleDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),2)		//规则字典表指针
			s RuleDesc=""
			s RuleTypeDR=""
			s RuleTypeDesc=""
			if RuleDR'=""
			{
				s RuleDesc=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)				//规则概述
				continue:((ruledesc'="")&&($ZCONVERT(RuleDesc,"U")'[ruledesc))
				s RuleTypeDR=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleDR)),6)				//规则流程类型（辅助诊疗规则/诊断预警规则/检验检查预警规则/手术并发症规则/输血合理性规则/手术合理性规则/过敏合理性规则/护理合理性规则）
				continue:((ruletype'="")&&(RuleTypeDR'=ruletype))
				s:RuleTypeDR'="" RuleTypeDesc=$lg($g(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)	//类型描述
			}
			continue:((ruledesc'="")&&(RuleDesc=""))
			continue:((ruletype'="")&&(RuleTypeDR=""))
			s Sequence=$lg($g(^CT.WDT.CDSS.RuleRationalityD(RuleRowId)),3)		//顺序
			s WarningContent=$lg($g(^CT.WDT.CDSS.RuleRationalityD(RuleRowId)),4)	//提醒内容
			continue:((ruletip'="")&&($ZCONVERT(WarningContent,"U")'[ruletip))
			s TabooLevel=$lg($g(^CT.WDT.CDSS.RuleRationalityD(RuleRowId)),5)		//禁忌级别（A-绝对、R-相对、M-注意事项）
			s Remarks=$lg($g(^CT.WDT.CDSS.RuleRationalityD(RuleRowId)),6)		//备注
			s ConfigId=""
			s AlertLevel=""
			/*if $d(^CF.WDT.CDSS.RuleConfigI("RationalityDRIdx",RuleRowId))
			{
				s ConfigId=$o(^CF.WDT.CDSS.RuleConfigI("RationalityDRIdx",RuleRowId,0))
				s:ConfigId'="" AlertLevel=$lg($g(^CF.WDT.CDSS.RuleConfigD(ConfigId)),3)		//预警等级
				continue:((rulelevel'="")&&(AlertLevel'=rulelevel))
			}*/
			s AlertLevel=..GetRuleLevel(RuleRowId)
			continue:((rulelevel'="")&&(AlertLevel'=rulelevel))
			//continue:((rulelevel'="")&&(ConfigId=""))
			d OutputRow
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RuleRowId,RuleDesc,RuleTypeDesc,WarningContent,AlertLevel)
	set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)

	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:Xuwenhu
/// CreatDate:2022-01-12
/// Description:保存数据
/// Table:CF.WDT.CDSS.RuleConfig
/// Input:eobj
/// Return:success-成功，false-失败
/// Others:w ##class(web.CDSS.Config.RuleConfig).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Config.RuleConfig) As %String
{
	s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        if (eobj.RowId="")  //如果RowId未赋值则增加
        {
            s obj=##class(CF.WDT.CDSS.RuleConfig).%New()             
        }
        else                     //如果RowId已赋值则修改
        {
            s obj=##class(CF.WDT.CDSS.RuleConfig).%OpenId(eobj.RowId)  
            s bobj = ##class(web.CDSSEntity.Config.RuleConfig).%New()
			s bobj.RationalityDR=obj.RationalityDR.%Id()	//合理性规则id
    		s bobj.AlertLevel=obj.AlertLevel				//预警等级（阻断开立/弹窗提醒/辅助预警）
    		s bobj.RuleDr=obj.RuleDr.%Id()					// 规则id
    		s bobj.FlowChartNum=obj.FlowChartNum			// 流程图顺序号
    		s bobj.RuleType=obj.RuleType.%Id()				// 预警规则类型
    		s bobj.Remarks=obj.Remarks						// 备注
        }
        Ts
        d obj.RationalityDRSetObjectId(eobj.RationalityDR)			//合理性规则id
		s obj.AlertLevel=eobj.AlertLevel				//预警等级（阻断开立/弹窗提醒/辅助预警）
    	d obj.RuleDrSetObjectId(eobj.RuleDr)			// 规则id
    	s obj.FlowChartNum=eobj.FlowChartNum			// 流程图顺序号
    	d obj.RuleTypeSetObjectId(eobj.RuleType)		// 预警规则类型
    	s obj.Remarks=eobj.Remarks						// 备注
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            Tc
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId
            //保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CF_WDT_CDSS.RuleConfig","CF.WDT.CDSS.RuleConfig","特殊诊疗规则配置表",id,eobj.RowId,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CF_WDT_CDSS.RuleConfig","CF.WDT.CDSS.RuleConfig","特殊诊疗规则配置表",eobj.RowId,eobj.RowId,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("特殊诊疗规则配置表","web.CDSS.Config.RuleConfig","SaveData",eobj)
   	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
                 
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("特殊诊疗规则配置表","web.CDSS.Config.RuleConfig","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:xuwenhu
/// CreatDate:2022-01-12
/// Description:保存特殊规则等级
/// Table:CF.WDT.CDSS.RuleConfig
/// Input:str-RuleDr串,level-设置等级
/// Return:成功-success,失败-false
/// Others:w ##class(web.CDSS.Config.RuleConfig).SaveCheckedData("8","阻断开立")
ClassMethod SaveCheckedData(str As %String, level As %String) As %String
{
	q:str="" "未选中规则"
	for i=1:1:$l(str,",")
	{
		s RuleDR=$p(str,",",i)
		s RuleID=$o(^CF.WDT.CDSS.RuleConfigI("RationalityDRIdx",RuleDR,0))		//规则ID
		s NodeDR=$lg($g(^CT.WDT.CDSS.RuleRationalityD(RuleDR)),2)				//流程图节点
		s RuleDictID=""
		s FlowChartNum=""
		s:NodeDR'="" RuleDictID=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),2)			//规则字典表指针
		s:NodeDR'="" FlowChartNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),3)			//流程图顺序号
		s RuleTypeDR=""
		s:RuleDictID'="" RuleTypeDR=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleDictID)),6)				//规则流程类型（辅助诊疗规则/诊断预警规则/检验检查预警规则/手术并发症规则/输血合理性规则/手术合理性规则/过敏合理性规则/护理合理性规则）	
		s eobj=##class(web.CDSSEntity.Config.RuleConfig).%New()
		if (RuleID="")
		{
			s eobj.RowId=""
		}
		else
		{
			s eobj.RowId=RuleID
		}
		s eobj.RationalityDR=RuleDR
		s eobj.AlertLevel=level
		s eobj.RuleDr=RuleDictID
		s eobj.FlowChartNum=FlowChartNum
		s eobj.RuleType=RuleTypeDR
		s eobj.Remarks=""
		s result=..SaveData(eobj)
	}
	q result
}

/// Creator:xuwenhu
/// CreatDate:2022-01-12
/// Description:根据id获取规则等级
/// Table:CF.WDT.CDSS.RuleConfig
/// Input:id-RuleId
/// Return:Level
/// Others:w ##class(web.CDSS.Config.RuleConfig).GetRuleLevel("7")
ClassMethod GetRuleLevel(id As %String) As %String
{
	s AlertLevel=""			//预警等级
	s SpecialConfig=##class(web.CDSS.Config.MKBConfig).GetConfigValue("SpecialRulerConfig")
	if SpecialConfig="Y"
	{
		if $d(^CF.WDT.CDSS.RuleConfigI("RationalityDRIdx",id))
		{
			s RationId=$o(^CF.WDT.CDSS.RuleConfigI("RationalityDRIdx",id,0))
			s AlertLevel=$lg($g(^CF.WDT.CDSS.RuleConfigD(RationId)),3)		//特殊配置预警等级		
		}
		else
		{
			s TabooLevel=$lg($g(^CT.WDT.CDSS.RuleRationalityD(id)),5)		//通用配置预警等级	
			if TabooLevel="绝对"
			{
				s AlertLevel=..GetConfigValue("RedAlertLevel")
			}
			elseif TabooLevel="相对"
			{
				s AlertLevel=..GetConfigValue("OrangeAlertLevel")
			}
			elseif TabooLevel="注意事项"
			{
				s AlertLevel=..GetConfigValue("BlueAlertLevel")	
			}
			else
			{
				s AlertLevel=""
			}	
		}
	}
	q AlertLevel
}

}
