Class web.DHCENS.STBLL.Method.SystemStatusConfig Extends (%RegisteredObject, %XML.Adaptor)
{

/// -------------------------------------------------------------------------数据插入方法--------------------------------------------------------------
/// User.EnsStatus
/// Input:医嘱号^检查号（检验条码号、病理条码号^检查部位描述（仅对于检查来说)^操作员工号^操作员描述^操作日期时间^操作时间^当前状态代码^系统代码^是否正流程^有效标志
ClassMethod EnsStatusInsert(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set UserObj=##class(User.EnsStatus).%New()
	set UserObj.ESOrdItemID=$p(Input,"^",1)
	set UserObj.ESExamID=$p(Input,"^",2)
	set UserObj.ESExamPart=$p(Input,"^",3)
	set UserObj.ESOperatorID=$p(Input,"^",4)
	set UserObj.ESOperatorName=$p(Input,"^",5)
	set UserObj.ESOperateDate=+$h
	set UserObj.ESOperateTime=$p($h,",",2)
	set ESStatusCode=$p(Input,"^",8)
	set ESSystemCode=$p(Input,"^",9)
	///panduan shifou guan lian
	set linkId=""
	set linkId=$d(^User.EnsSystemLinkStatusI("IndexSysStatus",ESSSystemCode,ESStatusCode)) 
	q:linkId="0" "系统代码和状态代码未建关联关系"
	set UserObj.ESStatusCode=ESStatusCode
	set UserObj.ESSystemCode=ESSSystemCode
	set UserObj.ESProcess=$p(Input,"^",10)
	set UserObj.ESEffectiveFlag=$p(Input,"^",11)
	set tSC= UserObj.%Save()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	do stream.Write(retJson)
	
 	q stream
	
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"插入失败"_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// User.EnsStatusLog
/// Input:医嘱号^检查号（检验条码号、病理条码号^检查部位描述（仅对于检查来说^操作员工号^操作员描述^操作日期时间^操作时间^操作代码^系统代码^变更后状态^变更前状态
ClassMethod EnsStatusLogInsert(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set UserObj=##class(User.EnsStatusLog).%New()
	set UserObj.ESOrdItemID=$p(Input,"^",1)
	set UserObj.ESExamID=$p(Input,"^",2)
	set UserObj.ESExamPart=$p(Input,"^",3)
	set UserObj.ESOperatorID=$p(Input,"^",4)
	set UserObj.ESOperatorName=$p(Input,"^",5)
	set UserObj.ESOperateDate=+$h
	set UserObj.ESOperateTime=$p($h,",",2)
	set ESOperateCode=$p(Input,"^",8)
	set ESSystemCode=$p(Input,"^",9)
	///panduan shifou guan lian
	set linkId=""
	set linkId=$d(^User.EnsSystemLinkStatusI("IndexSysStatus",ESSSystemCode,ESStatusCode)) 
	q:linkId="0" "系统代码和状态代码未建关联关系"
	set UserObj.ESOperateCode=ESStatusCode
	set UserObj.ESSystemCode=ESSSystemCode
	set ESStatusCode=$p(Input,"^",10)
	set ESPreStatusCode=$p(Input,"^",11)
	set linkId2=$d(^User.EnsSystemLinkStatusI("IndexSysStatus",ESSSystemCode,ESStatusCode))
	q:linkId2="0" "变更后的代码和系统代码未建立关联关系"
	set tSC= UserObj.%Save()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	do stream.Write(retJson)
	
 	q stream
	
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"插入失败"_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// User.EnsStatusCode
/// W ##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsStatusCodeInsert("SCCode=&ESCDesc=&ESCNote=")
/// Input:医嘱号^检查号（检验条码号、病理条码号^检查部位描述（仅对于检查来说^操作员工号^操作员描述^操作日期时间^操作时间^操作代码^系统代码^变更后状态^变更前状态
ClassMethod EnsStatusCodeInsert(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set searchInfo=$zcvt(Input,"I","URL")
	set tSC="0"	
	set stream=##class(%GlobalCharacterStream).%New()
	set ESCCode=$zcvt($P($p(Input,"&",2),"=",2),"I","URL")
	set ESCDesc=$zcvt($P($p(Input,"&",3),"=",2),"I","URL")
	set ESCEffectiveFlag=$zcvt($P($p(Input,"&",5),"=",2),"I","URL")
	set ESCNote=$zcvt($P($p(Input,"&",4),"=",2),"I","URL")
	;set ESCStartDate=$zcvt($P($p(Input,"&",5),"=",2),"I","URL")
	;set ESCEndDate=$zcvt($P($p(Input,"&",6),"=",2),"I","URL")
	;set:ESCStartDate'="" ESCStartDate=$zd(ESCStartDate,3)
	;set:ESCEndDate'="" ESCEndDate=$zd(ESCEndDate,3)
	;set:ESCStartDate="" ESCStartDate=+$h+7
	;if (ESCEndDate'="")&&(ESCEndDate<ESCStartDate){
	;		set TimeError=##class(%GlobalCharacterStream).%New()
	;		set TimeErrorJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"开始日期大于结束日期"_$c(34)_"}"	
	;	d TimeError.Write(TimeErrorJson)
	;}
	;q:TimeError.Size'="0" TimeError
	set rowId=$d(^Code.ENS.EnsStatusCodeI("IndexESCCode",Input))
	if rowId="0"{
	set UserObj=##class(User.EnsStatusCode).%New()
	set UserObj.ESCCode=$ZCVT(ESCCode,"U")
	set UserObj.ESCDesc=ESCDesc
	set UserObj.ESCEffectiveFlag=ESCEffectiveFlag
	set UserObj.ESCStartDate=+$h
	set UserObj.ESCEndDate=""
	set UserObj.ESCNote=ESCNote
	set tSC= UserObj.%Save()
	if tSC="1"{
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	}else{
		set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"插入失败"_$c(34)_"}"
	}
	}
	do stream.Write(retJson)
	
 	q stream
	
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"插入失败"_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// User.EnsSystem
/// Input:医嘱号^检查号（检验条码号、病理条码号^检查部位描述（仅对于检查来说^操作员工号^操作员描述^操作日期时间^操作时间^操作代码^系统代码^变更后状态^变更前状态
ClassMethod EnsSystemInsert(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set tSC="0"
	set stream=##class(%GlobalCharacterStream).%New()
	set ESysCode=$zcvt($P($p(Input,"&",2),"=",2),"I","URL")
	set ESysDesc=$zcvt($P($p(Input,"&",3),"=",2),"I","URL")
	set ESysEffectiveFlag=$zcvt($P($p(Input,"&",5),"=",2),"I","URL")
	set ESysTypeCode=$zcvt($P($p(Input,"&",4),"=",2),"I","URL")

	set rowId=$d(^Config.ENS.EnsSystemI("IndexESysCode",ESysCode))
	if rowId="0"{
	set UserObj=##class(User.EnsSystem).%New()
	set UserObj.ESysCode=ESysCode
	set UserObj.ESysDesc=ESysDesc
	set UserObj.ESysEffectiveFlag=ESysEffectiveFlag
	set UserObj.ESysTypeCode=ESysTypeCode
	set tSC= UserObj.%Save()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	}else{
		set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"主键已经存在"_$c(34)_"}"	
	}
	do stream.Write(retJson)
	
 	q stream
	
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"插入失败"_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// User.EnsSystemType
/// Input:医嘱号^检查号（检验条码号、病理条码号^检查部位描述（仅对于检查来说^操作员工号^操作员描述^操作日期时间^操作时间^操作代码^系统代码^变更后状态^变更前状态
ClassMethod EnsSystemTypeInsert(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set tSC="0"
	set stream=##class(%GlobalCharacterStream).%New()
	set ESTCode=$zcvt($P($p(Input,"&",2),"=",2),"I","URL")
	set ESTDesc=$zcvt($P($p(Input,"&",3),"=",2),"I","URL")
	set ESTEffectiveFlag=$zcvt($P($p(Input,"&",4),"=",2),"I","URL")

	set rowId=$d(^Code.ENS.EnsSystemTypeI("IndexESTCode",ESTCode)) 
	if rowId="0"{
	set UserObj=##class(User.EnsSystemType).%New()
	set UserObj.ESTCode=ESTCode
	set UserObj.ESTDesc=ESTDesc
	set UserObj.ESTEffectiveFlag=ESTEffectiveFlag
	set tSC= UserObj.%Save()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	}else{
		set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"主键已经存在"_$c(34)_"}"
	}
	do stream.Write(retJson)
	
 	q stream
	
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"插入失败"_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// User.EnsSystemLinkStatus
/// Input:医嘱号^检查号（检验条码号、病理条码号^检查部位描述（仅对于检查来说^操作员工号^操作员描述^操作日期时间^操作时间^操作代码^系统代码^变更后状态^变更前状态
ClassMethod EnsSystemLinkStatusInsert(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set tSC="0"
	set stream=##class(%GlobalCharacterStream).%New()
	set ESSStatusCode=$zcvt($P($p(Input,"&",3),"=",2),"I","URL")
	set ESSSystemCode=$zcvt($P($p(Input,"&",2),"=",2),"I","URL")
	set ESSEffectiveFlag=$zcvt($P($p(Input,"&",5),"=",2),"I","URL")
	set ESSSequence=$zcvt($P($p(Input,"&",4),"=",2),"I","URL")
	set rowId=$d(^Config.ENS.EnsSystemLinkStatusI("IndexSysStatus",ESSSystemCode,ESSStatusCode))
	if rowId="0"{
	set UserObj=##class(User.EnsSystemLinkStatus).%New()
	set UserObj.ESSStatusCode=ESSStatusCode
	set UserObj.ESSSystemCode=ESSSystemCode
	set UserObj.ESSEffectiveFlag=ESSEffectiveFlag
	set UserObj.ESSSequence=ESSSequence
	set tSC= UserObj.%Save()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	}else{
		set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"主键已经存在"_$c(34)_"}"	
		
	}
	do stream.Write(retJson)
	
 	q stream
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"插入失败"_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// -------------------------------------------------------------------------数据删除方法--------------------------------------------------------------
ClassMethod EnsStatusDelete(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set tSC="0"
	set rowId=""
	set stream=##class(%GlobalCharacterStream).%New()
	set rowId=$o(^User.EnsStatusI("IndexESOrdItemID",Input,""))
	q:rowId=""
	set obj=##class(User.EnsStatus).%OpenId(rowId)
	set tSC=obj.%DeleteId(rowId)
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	do stream.Write(retJson)
	
 	q stream
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_$ze_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// W ##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsStatusCodeDelete("AP")
ClassMethod EnsStatusCodeDelete(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set rowId=""
	set tSC="0"
		set stream=##class(%GlobalCharacterStream).%New()
	set rowId=$o(^Code.ENS.EnsStatusCodeI("IndexESCCode",Input,""))
	q:rowId=""
	set obj=##class(User.EnsStatusCode).%OpenId(rowId)
	set tSC=obj.%DeleteId(rowId)
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	do stream.Write(retJson)
	
 	q stream
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_$ze_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

ClassMethod EnsStatusLogDelete(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set tSC="0"
	set rowId=""
		set stream=##class(%GlobalCharacterStream).%New()
	set rowId=$o(^User.EnsStatusLogI("IndexESOrdItemID",Input,""))
	q:rowId=""
	set obj=##class(User.EnsStatusLog).%OpenId(Input)
	set tSC=obj.%DeleteId(rowId)
 	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	do stream.Write(retJson)
	
 	q stream
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_$ze_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

ClassMethod EnsSystemLinkStatusDelete(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set tSC="0"
		set stream=##class(%GlobalCharacterStream).%New()
	set StatusCode=$p(Input,"^",1)
	set systemCode=$p(Input,"^",2)
	set rowId=""
	set rowId=$o(^Config.ENS.EnsSystemLinkStatusI("IndexSysStatus",systemCode,StatusCode,""))
	q:rowId=""
	set obj=##class(User.EnsSystemLinkStatus).%OpenId(rowId)
	set tSC=obj.%DeleteId(rowId)
 	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	do stream.Write(retJson)
	
 	q stream
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_$ze_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

ClassMethod EnsSystemTypeDelete(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set tSC="0"
	set rowId=""
		set stream=##class(%GlobalCharacterStream).%New()
	set rowId=$o(^Code.ENS.EnsSystemTypeI("IndexESTCode",Input,""))
	q:rowId=""
	set obj=##class(User.EnsSystemType).%OpenId(rowId)
	set tSC=obj.%DeleteId(rowId)
 	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	do stream.Write(retJson)
	
 	q stream
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_$ze_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

ClassMethod EnsSystemDelete(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set tSC="0"
	set rowId=""
		set stream=##class(%GlobalCharacterStream).%New()
	set rowId=$o(^Config.ENS.EnsSystemI("IndexESysCode",Input,""))
	q:rowId=""
	set obj=##class(User.EnsSystem).%OpenId(rowId)
	set tSC=obj.%DeleteId(rowId)
 	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	do stream.Write(retJson)
	
 	q stream
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_$ze_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// -------------------------------------------------------------------------数据更新方法--------------------------------------------------------------
ClassMethod EnsStatusUpdate(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set rowId=""
	set rowId=$o(^User.EnsStatusI("IndexESOrdItemID",Input,""))
	q:rowId=""
	set obj=##class(User.EnsStatus).%OpenId(rowId)
	set tSC=obj.%Save()
 	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	do stream.Write(retJson)
	
 	q stream
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_$ze_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// w ##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsStatusCodeUpdate("ESCCode=CBK&ESCDesc=取消预约&ESCNote=43567"_$c(13,10)_"&ESCEffectiveFlag=Y")
ClassMethod EnsStatusCodeUpdate(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set ESCCode=$zcvt($P($p(Input,"&",2),"=",2),"I","URL")
	set ESCDesc=$zcvt($P($p(Input,"&",3),"=",2),"I","URL")
	set ESCEffectiveFlag=$zcvt($P($p(Input,"&",5),"=",2),"I","URL")
	set ESCNote=$zcvt($P($p(Input,"&",4),"=",2),"I","URL")
	set Errorstream=##class(%GlobalCharacterStream).%New()
	set Sueccessstream=##class(%GlobalCharacterStream).%New()
	//判断关联表是否存在该关联关系
	SET Flag="",syscode="",FlagList="",FlagId=""
	for  set syscode=$o(^Config.ENS.EnsSystemLinkStatusI("IndexStatusSys",ESCCode,syscode)) q:syscode=""  d
	.set FlagId=$o(^Config.ENS.EnsSystemLinkStatusI("IndexStatusSys",ESCCode,syscode,""))
	.q:FlagId=""
	.set Flag=$lg(^Config.ENS.EnsSystemLinkStatusD(FlagId),4)
	.i FlagList="" d
	..set FlagList=Flag
	.e  d
	..set FlagList=FlagList_Flag
	i FlagList["Y" set Json="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"关联关系启用"_$c(34)_"}"
	i FlagList["Y" d Errorstream.Write(Json)
	q:((FlagList["Y")&&(ESCEffectiveFlag="N")) Errorstream
	set rowId=""
	set rowId=$o(^Code.ENS.EnsStatusCodeI("IndexESCCode",ESCCode,""))
	q:rowId=""
	set obj=##class(User.EnsStatusCode).%OpenId(rowId)
	set obj.ESCCode=$zcvt(ESCCode,"U")
	set obj.ESCDesc=ESCDesc
	set obj.ESCEffectiveFlag=ESCEffectiveFlag
	set:obj.ESCEffectiveFlag="N" obj.ESCEndDate=+$h
	set:obj.ESCEffectiveFlag="Y" obj.ESCEndDate=""
	;set obj.ESCStartDate=+$h
	set obj.ESCNote=ESCNote
	set tSC=obj.%Save()
 	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	do Sueccessstream.Write(retJson)
 	q Sueccessstream
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"更新失败"_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

ClassMethod EnsStatusLogUpdate(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set rowId=""
	set rowId=$o(^User.EnsStatusLogI("IndexESOrdItemID",Input,""))
	q:rowId=""
	set obj=##class(User.EnsStatusLog).%OpenId(Input)
	set tSC=obj.%Save()
 	Q tSC
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"更新失败"_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

ClassMethod EnsSystemLinkStatusUpdate(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set StatusCode=$zcvt($P($p(Input,"&",3),"=",2),"I","URL")
	set systemCode=$zcvt($P($p(Input,"&",2),"=",2),"I","URL")
	set ESSSequence=$zcvt($P($p(Input,"&",4),"=",2),"I","URL")
	set ESSEffectiveFlag=$zcvt($P($p(Input,"&",5),"=",2),"I","URL")
	set stream=##class(%GlobalCharacterStream).%New()

	set rowId=""
	set rowId=$o(^Config.ENS.EnsSystemLinkStatusI("IndexSysStatus",systemCode,StatusCode,""))
	i rowId="" set Json="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"未找到关联关系"_$c(34)_"}"
	i rowId="" d stream.Write(Json)
	q:rowId="" stream
	set obj=##class(User.EnsSystemLinkStatus).%OpenId(rowId)
	set obj.ESSStatusCode=StatusCode
	set obj.ESSSystemCode=systemCode
	set obj.ESSSequence=ESSSequence
	set obj.ESSEffectiveFlag=ESSEffectiveFlag
	set tSC=obj.%Save()
 	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	do stream.Write(retJson)
	
 	q stream
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"更新失败"_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// w ##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsSystemTypeUpdate("ESCCode=LIS&ESCDesc=检验22&ESCEffectiveFlag=Y")
ClassMethod EnsSystemTypeUpdate(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set ESTCode=$zcvt($P($p(Input,"&",2),"=",2),"I","URL")
	set ESTDesc=$zcvt($P($p(Input,"&",3),"=",2),"I","URL")
	set ESTEffectiveFlag=$zcvt($P($p(Input,"&",4),"=",2),"I","URL")
	set rowId=""
	//判断关联表是否存在该关联关系
	set Errorstream=##class(%GlobalCharacterStream).%New()
	set Sueccessstream=##class(%GlobalCharacterStream).%New()
	SET FlagId="",Flag="",sysCode="",FlagList=""

	for  set sysCode=$o(^Config.ENS.EnsSystemI("IndexSysTypeESysCode",ESTCode,sysCode)) q:sysCode=""  d
	.set FlagId=$o(^Config.ENS.EnsSystemI("IndexSysTypeESysCode",ESTCode,sysCode,""))
	.q:FlagId=""
	.set Flag=$lg(^Config.ENS.EnsSystemD(FlagId),4)
	.i FlagList="" d
	..set FlagList=Flag
	.e  d
	..set FlagList=FlagList_"^"_Flag
	i FlagList["Y" set Json="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"关联关系启用"_$c(34)_"}"
	i FlagList["Y" d Errorstream.Write(Json)
	q:((FlagList["Y")&&(ESTEffectiveFlag="N")) Errorstream
	set rowId=$o(^Code.ENS.EnsSystemTypeI("IndexESTCode",ESTCode,""))
	q:rowId=""
	set obj=##class(User.EnsSystemType).%OpenId(rowId)
	set obj.ESTCode=ESTCode
	set obj.ESTDesc=ESTDesc
	set obj.ESTEffectiveFlag=ESTEffectiveFlag
	set tSC=obj.%Save()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	do Sueccessstream.Write(retJson)
	
 	q Sueccessstream
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"更新失败"_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// w ##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsSystemUpdate("ESCCode=PIS&ESCDesc=病理&ESCEffectiveFlag=N")
ClassMethod EnsSystemUpdate(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set ESysCode=$zcvt($P($p(Input,"&",2),"=",2),"I","URL")
	set ESysDesc=$zcvt($P($p(Input,"&",3),"=",2),"I","URL")
	set ESysEffectiveFlag=$zcvt($P($p(Input,"&",5),"=",2),"I","URL")
	set ESysTypeCode=$zcvt($P($p(Input,"&",4),"=",2),"I","URL")
	set rowId=""
	//判断关联表是否存在该关联关系
	set Errorstream=##class(%GlobalCharacterStream).%New()
	set Sueccessstream=##class(%GlobalCharacterStream).%New()
	SET FlagId="",Flag="",statusCode="",FlagList=""
	for  set statusCode=$o(^Config.ENS.EnsSystemLinkStatusI("IndexSysStatus",ESysCode,statusCode)) q:statusCode=""  d
	.set FlagId=$o(^Config.ENS.EnsSystemLinkStatusI("IndexSysStatus",ESysCode,statusCode,""))
	.q:FlagId=""
	.set Flag=$lg(^Config.ENS.EnsSystemLinkStatusD(FlagId),4)
	.i FlagList="" d
	..set FlagList=Flag
	.e  d
	..set FlagList=FlagList_"^"_Flag
	i FlagList["Y" set Json="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"关联关系启用"_$c(34)_"}"
	i FlagList["Y" d Errorstream.Write(Json)
	q:((FlagList["Y")&&(ESysEffectiveFlag="N")) Errorstream
	set rowId=$o(^Config.ENS.EnsSystemI("IndexESysCode",ESysCode,""))
	q:rowId=""
	set obj=##class(User.EnsSystem).%OpenId(rowId)
	set obj.ESysCode=ESysCode
	set obj.ESysDesc=ESysDesc
	set obj.ESysEffectiveFlag=ESysEffectiveFlag
	set obj.ESysTypeCode=ESysTypeCode
	set tSC=obj.%Save()
 	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	do Sueccessstream.Write(retJson)
	
 	q Sueccessstream
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"更新失败"_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// -------------------------------------------------------------------------数据查询方法--------------------------------------------------------------
/// W ##class(web.DHCENS.STBLL.Method.SystemStatusConfig).GetEnsStatusCode("","","0","10")
ClassMethod GetEnsStatusCode(SearchStr As %String = "", Flag As %String = "Y", page As %String = "", rows As %String = "") As %String
{
	set $zt="ErrorMsgs"
	set rowId="",pid="0",rowData="",tmpData="",ESCNote=""
	set:page="" page="1"
	set:page="0" page="1"
	set:rows="" rows="2000"
	set startNum=(page-1)*rows
	set EndNum=page*rows
	s result= "{"_$c(34)_"rows"_$c(34)_":["
	set stream=##class(%GlobalCharacterStream).%New()
	set (ESCDesc,ESCEffectiveFlag,ESCStartDate)=""
	if (SearchStr'=""){
		set Code=$ZCVT(SearchStr,"U"),ESCCode=""
		for  set ESCCode=$o(^Code.ENS.EnsStatusCodeI("IndexESCCode",ESCCode)) q:ESCCode=""  d
		.set rowId=$o(^Code.ENS.EnsStatusCodeI("IndexESCCode",ESCCode,""))
		.set ESCCode1=$lg(^Code.ENS.EnsStatusCodeD(rowId),8)
		.set ESCDesc=$lg(^Code.ENS.EnsStatusCodeD(rowId),9)
		.set ESCEffectiveFlag=$lg(^Code.ENS.EnsStatusCodeD(rowId),10)
		.set queryFlag="0"
		.i (Flag="N")&&(ESCEffectiveFlag="N") set queryFlag="1"
		.q:queryFlag="1"
		.set ESCStartDate=$lg(^Code.ENS.EnsStatusCodeD(rowId),11)
		.set:ESCStartDate'="" ESCStartDate=$zd(ESCStartDate,3)
		.set ESCEndDate=$lg(^Code.ENS.EnsStatusCodeD(rowId),12)
		.set:ESCEndDate'="" ESCEndDate=$zd(ESCEndDate,3)
		.set ESCNote=$lg(^Code.ENS.EnsStatusCodeD(rowId),13)
		.set ESCNote=..RepalceStringToJson(ESCNote)
		.set ESCCode1U=$zcvt(ESCCode1,"U"),ESCDescU=$zcvt(ESCDesc,"U")
		.if (ESCCode1U[Code)||(ESCDescU[Code) d
		..set pid=pid+1
		..q:(pid<=startNum)
		..q:pid>EndNum
		..set tmpData="{"_$c(34)_"pid"_$c(34)_":"_pid_","_$c(34)_"ESCCode"_$c(34)_":"_$c(34)_ESCCode1_$c(34)_","_$c(34)_"ESCDesc"_$c(34)_":"_$c(34)_ESCDesc_$c(34)_","_$c(34)_"ESCEffectiveFlag"_$c(34)_":"_$c(34)_ESCEffectiveFlag_$c(34)_","_$c(34)_"ESCStartDate"_$c(34)_":"_$c(34)_ESCStartDate_$c(34)_","_$c(34)_"ESCEndDate"_$c(34)_":"_$c(34)_ESCEndDate_$c(34)_","_$c(34)_"ESCNote"_$c(34)_":"_$c(34)_ESCNote_$c(34)_"}"
		..i rowData="" d
		...set rowData=tmpData
		..e  d
		...set rowData=rowData_","_tmpData
	}
	else
	{
		set ESCCode=""
		for  set ESCCode=$o(^Code.ENS.EnsStatusCodeI("IndexESCCode",ESCCode)) q:ESCCode=""  d
		.set rowId=$o(^Code.ENS.EnsStatusCodeI("IndexESCCode",ESCCode,""))
		.set ESCCode1=$lg(^Code.ENS.EnsStatusCodeD(rowId),8)
		.set ESCDesc=$lg(^Code.ENS.EnsStatusCodeD(rowId),9)
		.set ESCEffectiveFlag=$lg(^Code.ENS.EnsStatusCodeD(rowId),10)
		.set queryFlag="0"
		.i (Flag="N")&&(ESCEffectiveFlag="N") set queryFlag="1"
		.q:queryFlag="1"
		.set ESCStartDate=$lg(^Code.ENS.EnsStatusCodeD(rowId),11)
		.set:ESCStartDate'="" ESCStartDate=$zd(ESCStartDate,3)
		.set ESCEndDate=$lg(^Code.ENS.EnsStatusCodeD(rowId),12)
		.set:ESCEndDate'="" ESCEndDate=$zd(ESCEndDate,3)
		.set ESCNote=$lg(^Code.ENS.EnsStatusCodeD(rowId),13)
		.set ESCNote=..RepalceStringToJson(ESCNote)
		.set pid=pid+1
		.q:(pid<=startNum)
		.q:pid>EndNum
		.set tmpData="{"_$c(34)_"pid"_$c(34)_":"_pid_","_$c(34)_"ESCCode"_$c(34)_":"_$c(34)_ESCCode1_$c(34)_","_$c(34)_"ESCDesc"_$c(34)_":"_$c(34)_ESCDesc_$c(34)_","_$c(34)_"ESCEffectiveFlag"_$c(34)_":"_$c(34)_ESCEffectiveFlag_$c(34)_","_$c(34)_"ESCStartDate"_$c(34)_":"_$c(34)_ESCStartDate_$c(34)_","_$c(34)_"ESCEndDate"_$c(34)_":"_$c(34)_ESCEndDate_$c(34)_","_$c(34)_"ESCNote"_$c(34)_":"_$c(34)_ESCNote_$c(34)_"}"
		.i rowData="" d
		..set rowData=tmpData
		.e  d
		..set rowData=rowData_","_tmpData	
	}
	s result=result_rowData_"]"_","_$c(34)_"total"_$c(34)_":"_$c(34)_pid_$c(34)_"}"
	do stream.Write(result)
 	q stream 
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_$ze_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// / W ##class(web.DHCENS.STBLL.Method.SystemStatusConfig).GetEnsSystemType("","","0","10")
ClassMethod GetEnsSystemType(Input As %String = "", Flag As %String, page As %String, rows As %String) As %String
{
	set $zt="ErrorMsgs"
	set rowId="",pid="0",rowData=""
	set:page="" page="1"
	set:page="0" page="1"
	set:rows="" rows="2000"
	set startNum=(page-1)*rows
	set EndNum=page*rows
	
	set stream=##class(%GlobalCharacterStream).%New()
	s result= "{"_$c(34)_"rows"_$c(34)_":["
	
	if (Input'=""){
		set Code=$ZCVT(Input,"U"),ESTCode=""
		for  set ESTCode=$o(^Code.ENS.EnsSystemTypeI("IndexESTCode",ESTCode)) q:ESTCode=""  d
		.set rowId=$o(^Code.ENS.EnsSystemTypeI("IndexESTCode",ESTCode,""))
		.set ESTCode1=$lg(^Code.ENS.EnsSystemTypeD(rowId),2)
		.set ESTDesc=$lg(^Code.ENS.EnsSystemTypeD(rowId),3)
		.set ESTEffectiveFlag=$lg(^Code.ENS.EnsSystemTypeD(rowId),4)
		.set ESTCode1U=$zcvt(ESTCode1,"U"),ESTDescU=$zcvt(ESTDesc,"U")
		.set queryFlag="0"
		.i (Flag="N")&&(ESTEffectiveFlag="N") set queryFlag="1"
		.q:queryFlag="1"
		.if (ESTCode1U[Code)||(ESTDescU[Code)  d
		..set pid=pid+1
		..q:(pid<=startNum)
		..q:pid>EndNum
		..set tmpData="{"_$c(34)_"pid"_$c(34)_":"_pid_","_$c(34)_"ESCCode"_$c(34)_":"_$c(34)_ESTCode1_$c(34)_","_$c(34)_"ESCDesc"_$c(34)_":"_$c(34)_ESTDesc_$c(34)_","_$c(34)_"ESCEffectiveFlag"_$c(34)_":"_$c(34)_ESTEffectiveFlag_$c(34)_"}"
		..i rowData="" d
		...set rowData=tmpData
		..e  d
		...set rowData=rowData_","_tmpData
	}
	else
	{
		set ESTCode=""
		for  set ESTCode=$o(^Code.ENS.EnsSystemTypeI("IndexESTCode",ESTCode)) q:ESTCode=""  d
		.set rowId=$o(^Code.ENS.EnsSystemTypeI("IndexESTCode",ESTCode,""))
		.set ESTCode1=$lg(^Code.ENS.EnsSystemTypeD(rowId),2)
		.set ESTDesc=$lg(^Code.ENS.EnsSystemTypeD(rowId),3)
		.set ESTEffectiveFlag=$lg(^Code.ENS.EnsSystemTypeD(rowId),4)
		.set queryFlag="0"
		.i (Flag="N")&&(ESTEffectiveFlag="N") set queryFlag="1"
		.q:queryFlag="1"
		.set pid=pid+1
		.q:(pid<=startNum)
		.q:pid>EndNum
		.set tmpData="{"_$c(34)_"pid"_$c(34)_":"_pid_","_$c(34)_"ESCCode"_$c(34)_":"_$c(34)_ESTCode1_$c(34)_","_$c(34)_"ESCDesc"_$c(34)_":"_$c(34)_ESTDesc_$c(34)_","_$c(34)_"ESCEffectiveFlag"_$c(34)_":"_$c(34)_ESTEffectiveFlag_$c(34)_"}"
		.i rowData="" d
		..set rowData=tmpData
		.e  d
		..set rowData=rowData_","_tmpData
	}
		
	
	s result=result_rowData_"]"_","_$c(34)_"total"_$c(34)_":"_$c(34)_pid_$c(34)_"}"
	do stream.Write(result)
	q stream 
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_$ze_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// W ##class(web.DHCENS.STBLL.Method.SystemStatusConfig).GetEnsSystem("","","","")
ClassMethod GetEnsSystem(SearchStr As %String = "", Flag As %String, page As %String, rows As %String) As %String
{
	set $zt="ErrorMsgs"
	set rowId="",pid="0",rowData=""
	set:page="" page="1"
	set:page="0" page="1"
	set:rows="" rows="2000"
	set startNum=(page-1)*rows
	set EndNum=page*rows
	set stream=##class(%GlobalCharacterStream).%New()
	s result= "{"_$c(34)_"rows"_$c(34)_":["
	if (SearchStr'=""){
		set Code=$ZCVT(SearchStr,"U"),ESysCode=""
		for  set ESysCode=$o(^Config.ENS.EnsSystemI("IndexESysCode",ESysCode)) q:ESysCode=""  d
		.set rowId=$o(^Config.ENS.EnsSystemI("IndexESysCode",ESysCode,""))
		.set ESysCode1=$lg(^Config.ENS.EnsSystemD(rowId),2)
		.set ESysDesc=$lg(^Config.ENS.EnsSystemD(rowId),3)
		.set ESCEffectiveFlag=$lg(^Config.ENS.EnsSystemD(rowId),4)
		.set queryFlag="0"
		.i (Flag="N")&&(ESCEffectiveFlag="N") set queryFlag="1"
		.q:queryFlag="1"
		.set ESysTypeCode=$lg(^Config.ENS.EnsSystemD(rowId),5)
		.set ESysCode1U=$zcvt(ESysCode1,"U"),ESysDescU=$zcvt(ESysDesc,"U")
 		.if (ESysCode1U[Code)||(ESysDescU[Code)  d
  		..set pid=pid+1
 		..q:(pid<=startNum)
		..q:pid>EndNum
		..set tmpData="{"_$c(34)_"pid"_$c(34)_":"_pid_","_$c(34)_"ESCCode"_$c(34)_":"_$c(34)_ESysCode1_$c(34)_","_$c(34)_"ESCDesc"_$c(34)_":"_$c(34)_ESysDesc_$c(34)_","_$c(34)_"ESCEffectiveFlag"_$c(34)_":"_$c(34)_ESCEffectiveFlag_$c(34)_","_$c(34)_"ESysTypeCode"_$c(34)_":"_$c(34)_ESysTypeCode_$c(34)_"}"
		..i rowData="" d
		...set rowData=tmpData
		..e  d
		...set rowData=rowData_","_tmpData
	}
	else
	{
		set ESysCode=""
		for  set ESysCode=$o(^Config.ENS.EnsSystemI("IndexESysCode",ESysCode)) q:ESysCode=""  d
		.set rowId=$o(^Config.ENS.EnsSystemI("IndexESysCode",ESysCode,""))
		.set ESysCode1=$lg(^Config.ENS.EnsSystemD(rowId),2)
		.set ESysDesc=$lg(^Config.ENS.EnsSystemD(rowId),3)
		.set ESCEffectiveFlag=$lg(^Config.ENS.EnsSystemD(rowId),4)
		.set queryFlag="0"
		.i (Flag="N")&&(ESCEffectiveFlag="N") set queryFlag="1"
		.q:queryFlag="1"
		.set ESysTypeCode=$lg(^Config.ENS.EnsSystemD(rowId),5)
 		.set pid=pid+1
 		.q:(pid<=startNum)
		.q:pid>EndNum
		.set tmpData="{"_$c(34)_"pid"_$c(34)_":"_pid_","_$c(34)_"ESCCode"_$c(34)_":"_$c(34)_ESysCode1_$c(34)_","_$c(34)_"ESCDesc"_$c(34)_":"_$c(34)_ESysDesc_$c(34)_","_$c(34)_"ESCEffectiveFlag"_$c(34)_":"_$c(34)_ESCEffectiveFlag_$c(34)_","_$c(34)_"ESysTypeCode"_$c(34)_":"_$c(34)_ESysTypeCode_$c(34)_"}"
		.i rowData="" d
		..set rowData=tmpData
		.e  d
		..set rowData=rowData_","_tmpData	
	}
	s result=result_rowData_"]"_","_$c(34)_"total"_$c(34)_":"_$c(34)_pid_$c(34)_"}"
	do stream.Write(result)
 	q stream 
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_$ze_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// W ##class(web.DHCENS.STBLL.Method.SystemStatusConfig).GetEnsSystemLinkStatus("",1,10,"")
ClassMethod GetEnsSystemLinkStatus(SearchStr As %String = "", Flag As %String, page As %String, rows As %String) As %String
{
	set $zt="ErrorMsgs"
	set rowId="",pid="0",rowData=""
	set:page="" page="1"
	set:page="0" page="1"
	set:rows="" rows="2000"
	set startNum=(page-1)*rows
	set EndNum=page*rows
	set stream=##class(%GlobalCharacterStream).%New()
	s result= "{"_$c(34)_"rows"_$c(34)_":["
	if (SearchStr'=""){
		set Code=$ZCVT(SearchStr,"U"),ESSSystemCode=""
		for  set ESSSystemCode=$o(^Config.ENS.EnsSystemLinkStatusI("IndexSysStatus",ESSSystemCode)) q:ESSSystemCode=""  d
		.set ESSStatusCode=""
		.for  set ESSStatusCode=$o(^Config.ENS.EnsSystemLinkStatusI("IndexSysStatus",ESSSystemCode,ESSStatusCode)) q:ESSStatusCode=""  d
		..set rowId=$o(^Config.ENS.EnsSystemLinkStatusI("IndexSysStatus",ESSSystemCode,ESSStatusCode,""))
		..set ESSSystemCode1=$lg(^Config.ENS.EnsSystemLinkStatusD(rowId),2)
		..set ESSStatusCode1=$lg(^Config.ENS.EnsSystemLinkStatusD(rowId),3)
		..set ESSEffectiveFlag=$lg(^Config.ENS.EnsSystemLinkStatusD(rowId),4)
		..set queryFlag="0"
		..i (Flag="N")&&(ESSEffectiveFlag="N") set queryFlag="1"
		..q:queryFlag="1"
		..set ESSSequence=$lg(^Config.ENS.EnsSystemLinkStatusD(rowId),5)
		..set ESSSystemCode1U=$zcvt(ESSSystemCode1,"U"),ESSStatusCode1U=$zcvt(ESSStatusCode1,"U")
		..if (ESSSystemCode1U[Code)||(ESSStatusCode1U[Code)  d
		...set pid=pid+1
		...q:(pid<=startNum)
		...q:pid>EndNum
		...set tmpData="{"_$c(34)_"pid"_$c(34)_":"_pid_","_$c(34)_"ESSSystemCode"_$c(34)_":"_$c(34)_ESSSystemCode1_$c(34)_","_$c(34)_"ESSStatusCode"_$c(34)_":"_$c(34)_ESSStatusCode1_$c(34)_","_$c(34)_"ESCEffectiveFlag"_$c(34)_":"_$c(34)_ESSEffectiveFlag_$c(34)_","_$c(34)_"ESSSequence"_$c(34)_":"_$c(34)_ESSSequence_$c(34)_"}"
		...i rowData="" d
		....set rowData=tmpData
		...e  d
		....set rowData=rowData_","_tmpData
	}
	else
	{
		set ESSSystemCode=""
		for  set ESSSystemCode=$o(^Config.ENS.EnsSystemLinkStatusI("IndexSysStatus",ESSSystemCode)) q:ESSSystemCode=""  d
		.set ESSStatusCode=""
		.for  set ESSStatusCode=$o(^Config.ENS.EnsSystemLinkStatusI("IndexSysStatus",ESSSystemCode,ESSStatusCode)) q:ESSStatusCode=""  d
		..set rowId=$o(^Config.ENS.EnsSystemLinkStatusI("IndexSysStatus",ESSSystemCode,ESSStatusCode,""))
		..set ESSSystemCode1=$lg(^Config.ENS.EnsSystemLinkStatusD(rowId),2)
		..set ESSStatusCode1=$lg(^Config.ENS.EnsSystemLinkStatusD(rowId),3)
		..set ESSEffectiveFlag=$lg(^Config.ENS.EnsSystemLinkStatusD(rowId),4)
		..set queryFlag="0"
		..i (Flag="N")&&(ESSEffectiveFlag="N") set queryFlag="1"
		..q:queryFlag="1"
		..set ESSSequence=$lg(^Config.ENS.EnsSystemLinkStatusD(rowId),5)
		..set pid=pid+1
		..q:(pid<=startNum)
		..q:pid>EndNum
		..set tmpData="{"_$c(34)_"pid"_$c(34)_":"_pid_","_$c(34)_"ESSSystemCode"_$c(34)_":"_$c(34)_ESSSystemCode1_$c(34)_","_$c(34)_"ESSStatusCode"_$c(34)_":"_$c(34)_ESSStatusCode1_$c(34)_","_$c(34)_"ESCEffectiveFlag"_$c(34)_":"_$c(34)_ESSEffectiveFlag_$c(34)_","_$c(34)_"ESSSequence"_$c(34)_":"_$c(34)_ESSSequence_$c(34)_"}"
		..i rowData="" d
		...set rowData=tmpData
		..e  d
		...set rowData=rowData_","_tmpData	
	}
	s result=result_rowData_"]"_","_$c(34)_"total"_$c(34)_":"_$c(34)_pid_$c(34)_"}"
	do stream.Write(result)
 	q stream 
 	q tSC 
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_$ze_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// w ##class(web.DHCENS.STBLL.Method.SystemStatusConfigMvc).InputStr("[{""name"":""ESCCode"",""value"":""AC""},{""name"":""ESCDesc"",""value"":""测试""},{""name"":""ESCNote"",""value"":""测试""},{""name"":""ESCEffectiveFlag"",""value"":""N""}]")
ClassMethod ReInputStr(InputStr As %String) As %String
{
	s result=##class(%DynamicAbstractObject).%FromJSON(InputStr)

	set InputStrList=""
	s aa= result.%GetIterator()

	while aa.%GetNext(.key, .value) { 
		set nameture=value.name
		set valueture=value.value
		set Input=nameture_"="_valueture
	
		i InputStrList=""{
			set InputStrList=Input
			}else{
			set InputStrList=InputStrList_"&"_Input	
			}
	
		
	}
	Q InputStrList
}

/// w ##class(web.DHCENS.STBLL.Method.SystemStatusConfig).RepalceStringToJson($c(34)_"qweqwtt")
ClassMethod RepalceStringToJson(InputStr As %String) As %String
{
	set InputStr=$replace(InputStr,"\","")
	set InputStr=$replace(InputStr,$C(13,10),"")

	set InputStr=$replace(InputStr,$C(34),"")
	set InputStr=$replace(InputStr,$C(39),"")
	set InputStr=$replace(InputStr,"<","")
	set InputStr=$replace(InputStr,">","")
	set InputStr=$replace(InputStr,":","")
	set InputStr=$replace(InputStr,"/","")
	Q InputStr
}

}
