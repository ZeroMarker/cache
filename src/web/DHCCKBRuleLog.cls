/// 规则生命周期
Class web.DHCCKBRuleLog Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// 保存规则日志
/// baseHosp 20210916增加标库的医院描述，用于更新规则后，区分标库和项目的规则,便于多次更新
/// ##class(web.DHCCKBRuleLog).SaveLog()
ClassMethod SaveLog(ruleId, LgUserId, loginInfo, baseHosp = "", Type = "")
{
	n (ruleId,LgUserId,loginInfo,baseHosp,Type)
	s hospital=$p(loginInfo,"^",5)
	s hospital=$p($g(^CT("HOSP",+hospital)),"^",2)
	s logId=+$o(^CKB.PDSS.RuleLogI("Rule",ruleId,""),-1)
	s logObj=##class(CKB.PDSS.RuleLog).%New()
	s logObj.RLName=$lg($g(^CT.CKB.PDSS.RuleD(ruleId)),3)
	s logObj.RLRemark=$lg($g(^CT.CKB.PDSS.RuleD(ruleId)),2)
	d logObj.RLRuleSetObjectId(ruleId)
	i Type'=""  d
	s logObj.RLType=Type
	e  d
	.s logObj.RLType=$lg($g(^CT.CKB.PDSS.RuleD(ruleId)),4)
	s logObj.RLLastLog=logId
	s logObj.RLHospital=$case(baseHosp="",1:hospital,:baseHosp)	// 增加医院描述  qunianpeng 2020/3/30 
	i +LgUserId'=0 d logObj.RLUserSetObjectId(LgUserId)
	s sc=logObj.%Save()
	q:$SYSTEM.Status.IsError(sc) -11_"^"_$SYSTEM.Status.GetErrorText(sc)
	q logObj.%Id()
}

/// 保存规则明细日志
/// ##class(web.DHCCKBRuleLog).SaveDataLog()
ClassMethod SaveDataLog(ruleData, lastRuleData = 0, ruleId)
{
	n (ruleData, lastRuleData,ruleId)
	
	s log=+$o(^CKB.PDSS.RuleLogI("Rule",ruleId,""),-1)
	s opType="Unchanged"
	s lastLog=+$o(^CKB.PDSS.RuleDataLogI("RuleData",lastRuleData,""),-1)
	
	s:lastLog=0 opType="Add"  //新增的情况

	s leftDic=+$lg($g(^CT.CKB.PDSS.RuleDataD(ruleData)),4)
	s rightDic=+$lg($g(^CT.CKB.PDSS.RuleDataD(ruleData)),8)
	
	s obj=##class(CKB.PDSS.RuleDataLog).%New()
	s obj.RDLType=opType              //日志类型
	d obj.RDLRuleDataSetObjectId(ruleData)
	d obj.RDLRuleSetObjectId(ruleId)
	d obj.RDLLogSetObjectId(log)
	i lastLog'=0 s obj.RDLLastDataLog=lastLog         
	s obj.RDLOp=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleData)),7)		                                
	s obj.RDLCondition=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleData)),3)                         
	//left
	s obj.RDLLeftType=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleData)),6)                          
	s obj.RDLLeftValue=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleData)),5) 
    i leftDic'=0 d obj.RDLLeftDicSetObjectId(leftDic)          
	//right
   	s obj.RDLRightType=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleData)),10) 
   	i rightDic'=0 d obj.RDLRightDicSetObjectId(rightDic)  
   	s obj.RDLRightValue=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleData)),9)
   	s obj.RDLRightExt=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleData)),11)
   	s obj.RDLRightLimit=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleData)),12)
  
	
	s sc=obj.%Save()
	q:$SYSTEM.Status.IsError(sc) -21
	
	//change Flag
	i lastLog'=0 d
	.s oldHtml=##class(web.DHCCKBRuleLog).GetLogRuleDataHtml(lastLog)
	.s newHtml=##class(web.DHCCKBRuleLog).GetLogRuleDataHtml(obj.%Id())
	.i oldHtml'=newHtml d
	..s obj.RDLType="Edit"
	..s sc=obj.%Save()
	
	q:$SYSTEM.Status.IsError(sc) -21
	q obj.%Id()
}

/// 保存删除规则记录
/// d ##class(web.DHCCKBRuleLog).SaveRemoveDataLog()
ClassMethod SaveRemoveDataLog(log, type = "")
{
	n (log,type)
	s lastLog=+$lg(^CKB.PDSS.RuleLogD(log),9)
	q:lastLog=0 0
	s ret=0
	s lastLogItm="" f  s lastLogItm=$o(^CKB.PDSS.RuleDataLogI("Parent",lastLog,lastLogItm)) q:lastLogItm=""  d
	.q:ret'=0
	.q:$lg(^CKB.PDSS.RuleDataLogD(lastLogItm),17)="Remove"
	.s flag=0
	.s logItm="" f  s logItm=$o(^CKB.PDSS.RuleDataLogI("Parent",log,logItm)) q:(logItm="")||(flag'=0)  d 
	..s tmpLast=$lg(^CKB.PDSS.RuleDataLogD(logItm),18)
	..s:tmpLast=lastLogItm flag=1
	.q:flag=1
	.q:type'=""
	.s ret=##class(web.DHCCKBRuleLog).SaveDataLogByLast(lastLogItm,log)
	q ret
}

/// 保存规则明细日志
/// ##class(web.DHCCKBRuleLog).SaveDataLog()
ClassMethod SaveDataLogByLast(lastLog, log)
{
	n (lastLog,log)
	
	s logData = $g(^CKB.PDSS.RuleDataLogD(lastLog))
	s leftDic=+$lg(logData,4)
	s rightDic=$lg(logData,8) 
	
	s obj=##class(CKB.PDSS.RuleDataLog).%New()
	s obj.RDLType="Remove"         
	d obj.RDLLogSetObjectId(log)
	d obj.RDLLastDataLogSetObjectId(lastLog)
	       
	s obj.RDLOp=$lg(logData,7)                                 
	s obj.RDLCondition=$lg(logData,3)	       
	s obj.RDLAction=$lg(logData,15) 	       
	//left
	s obj.RDLLeftType= $lg(logData,5)                                 
	s obj.RDLLeftValue=$lg(logData,4)	        
    i leftDic'=0 d obj.RDLLeftDicSetObjectId(leftDic)          
	//right
   	s obj.RDLRightType=$lg(logData,10)	       
   	i rightDic'=0 d obj.RDLRightDicSetObjectId(rightDic)  
   	s obj.RDLRightValue=$lg(logData,9)	       
   	s obj.RDLRightExt=$lg(logData,13)	       
   	s obj.RDLRightLimit=$lg(logData,14) 
   	
	s sc=obj.%Save()
	q:$SYSTEM.Status.IsError(sc) -21
	q 0
}

/// 获取日志显示html
///  w ##class(web.DHCCKBRuleLog).GetLogRuleDataHtml(176030) 69856  69855 69854
/// w ##class(web.DHCCKBRuleLog).GetLogRuleDataHtml(1)
ClassMethod GetLogRuleDataHtml(logRuleData)
{
	n (logRuleData)
	
	q:+logRuleData=0 ""
	s logData = $g(^CKB.PDSS.RuleDataLogD(logRuleData))
	s Op= $lg(logData,7)                                
	s Condition= $lg(logData,3)                          
	s Action= $lg(logData,15)
	//left
	s LeftType= $lg(logData,6)                        
	s LeftValue= $lg(logData,5)
	s LeftDic= $lg(logData,4)       
	//right
   	s RightType= $lg(logData,10)  
   	s RightDic= $lg(logData,8)
   	s RightValue= $lg(logData,9) 
   	s RightExt= $lg(logData,13)
   	s RightLimit= $lg(logData,14)
   	s:+RightExt'=0 RightExt=$lg($g(^CT.CKB.PDSS.CommonDictionD(RightExt)),3)
   	s left="",right=""
	

   	s:+LeftValue='0 left=$lg($g(^CT.CKB.PDSS.CommonDictionD(+LeftValue)),3)
   	
   	i +LeftDic'=0 d
   	.i left="" d
   	..s left=$lg($g(^CT.CKB.PDSS.CommonDictionD(LeftDic)),3)
   	.e  d
   	..s left=left_"的"_$lg($g(^CT.CKB.PDSS.CommonDictionD(LeftDic)),3)
   	
   	
   	s right=""
   	i RightType="Constant" d
   	.s right=$lg($g(^CT.CKB.PDSS.CommonDictionD(+RightDic)),3)
    
    i RightType="Input" d
   	.s right=RightValue
   	
   	i RightType="InputUom" d
   	.s right=RightValue_" "_RightExt
   	
   	i RightType="InputLimit" d
   	.s right="("_RightValue_"-"_RightLimit_") "_RightExt
   	
   	s Condition=$case(Condition,"and":"并且","or":"或者",:"")
   	
   	s Op=$case(Op,"Equals":"等于",
   				  "GreaterThen":"大于",
   				  "LessThen":"小于",
   				  "GreaterThenEquals":"大于等于",
   				  "LessThenEquals":"小于等于",
   				  "Between":"在",:"")
   	
   	s html="<span>"_Condition_"</span><span style='margin:0px 15px 0px 15px;'>"_left_"</span>"_Op_"<span style='margin:0px 15px 0px 15px;'>"_right_"</span>"
   	s:Op="在" html=html_"之间"
   	q html
}

/// d ##class(web.DHCCKBRuleLog).ClearData()
ClassMethod ClearData()
{
	k ^DHCCKBRULEDATALOG
	k ^DHCCKBRULELOG
}

}
