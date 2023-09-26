Import sqluser

/// creator: 	yunhaibao
/// createdate: 2018-06-27
/// description:班次维护
Class web.DHCSTPIVAS.Schedul Extends %RegisteredObject
{

/// deccription:班次列表
/// table:      User.PIVASchedulType
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Schedul","PIVASchedul",219)
Query PIVASchedul(inputStr = "") As websys.Query(ROWSPEC = "psId,psLocId,psLocDesc,psCode,psDesc,psShortDesc,psStartTime,psEndTime,psScheTypeId,psScheTypeDesc,psCustFlag,psDuration,psDays,psInterval,linkSchStr")
{
}

ClassMethod PIVASchedulExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PivaLocId=$p(inputStr,"^",1)
	q:+PivaLocId=0 $$$OK
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT * FROM PIVA_Schedul where PS_RowId>0"
    i PivaLocId'="" s sqlStr=sqlStr_" and PS_Loc_Dr="_"'"_PivaLocId_"'"
    s sqlStr=sqlStr_" order by PS_Code"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
	    s psId= result.Data("PS_RowId") 
	    s psLocId= result.Data("PS_Loc_Dr") 
	    s locObj=##class(User.CTLoc).%OpenId(psLocId,0)
	    s psLocDesc=locObj.CTLOCDesc
	   	s psCode= result.Data("PS_Code") 
	    s psDesc= result.Data("PS_Desc")
	    s psShortDesc= result.Data("PS_ShortDesc") 
	    s psStartTime= result.Data("PS_StartTime")
	    s psStartTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(psStartTime,"PIVA")
	    s psEndTime= result.Data("PS_EndTime")
	    s psEndTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(psEndTime,"PIVA")
	    s psScheTypeId= result.Data("PS_ScheType_Dr")
	    s scheTypeObj=##class(User.PIVASchedulType).%OpenId(psScheTypeId,0)
	    s psScheTypeDesc=scheTypeObj.PSTDesc
	    s psCustFlag=result.Data("PS_CustomFlag")
	    s psDuration=result.Data("PS_Duration")
	    s psDaysLog=result.Data("PS_Days")
	    s psDays=..GetScheDateHtmlById(psId)
	    s psInterval=result.Data("PS_Interval")
	    s LinkSchedul=result.Data("PS_LinkSchedul")
	    s linkSchList=$lfs(LinkSchedul,",")
	    s linkSchLen=$ll(linkSchList)
	    s linkSchStr=""
	    f len=1:1:linkSchLen d
	    .s linkName=$p(^Code.PIVA.Schedul($list(linkSchList,len)),"^",3)
	    .i linkSchStr="" s linkSchStr=linkName
	    .e  s linkSchStr=linkSchStr_","_linkName
        d outputPIVASchedul
    }
    d result.Close()
	Quit $$$OK
outputPIVASchedul
	s Data=$lb(psId,psLocId,psLocDesc,psCode,psDesc,psShortDesc,psStartTime,psEndTime,psScheTypeId,psScheTypeDesc,psCustFlag,psDuration,psDays,psInterval,linkSchStr)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// description: 批量保存
ClassMethod SaveMulti(inputData)
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..Save(iData)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// description: 保存
ClassMethod Save(inputStr)
{
	s psId=$p(inputStr,"^",1)
	s psLocId=$p(inputStr,"^",2)
	s psCode=$p(inputStr,"^",3)
	s psDesc=$p(inputStr,"^",4)
	s psShortDesc=$p(inputStr,"^",5)
	s psStartTime=$p(inputStr,"^",6)
	s psEndTime=$p(inputStr,"^",7)
	s psScheTypeId=$p(inputStr,"^",8)
	s psCustFlag=$p(inputStr,"^",9)
	s psDuration=$p(inputStr,"^",10)
	s psInterval=$p(inputStr,"^",11)
	s psStartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(psStartTime)
	s psEndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(psEndTime)
  	q:psLocId="" "-1^配液中心不能为空"
  	q:psCode="" "-1^班次代码不能为空"
  	q:psDesc="" "-1^班次名称不能为空"
  	q:psShortDesc="" "-1^班次简称不能为空"
  	q:psScheTypeId="" "-1^班次类型不能为空"
  	s errCode=""
  	i psId="" d
  	.//&SQL(SELECT PS_RowId FROM PIVA_Schedul WHERE PS_Code=:psCode and PS_Loc_Dr=:psLocId)
  	.//i SQLCODE=0 s errCode="-1^代码已存在:"_psCode q
  	.&SQL(SELECT PS_RowId FROM PIVA_Schedul WHERE PS_Desc=:psDesc and PS_Loc_Dr=:psLocId)
  	.i SQLCODE=0 s errCode="-1^名称已存在:"_psDesc q
  	e  d 
  	.//&SQL(SELECT PS_RowId FROM PIVA_Schedul WHERE PS_Code=:psCode and PS_Loc_Dr=:psLocId and PS_RowId!=:psId)
  	.//i SQLCODE=0 s errCode="-1^代码已存在:"_psCode q
  	.&SQL(SELECT PS_RowId FROM PIVA_Schedul WHERE PS_Desc=:psDesc and PS_Loc_Dr=:psLocId and PS_RowId!=:psId)
  	.i SQLCODE=0 s errCode="-1^名称已存在:"_psDesc q
  	q:errCode'="" errCode
  	i psId=""  d
  	.&sql(
  		insert into PIVA_Schedul
  		(PS_Loc_Dr,PS_Code,PS_Desc,PS_ShortDesc,PS_StartTime,PS_EndTime,PS_ScheType_Dr,PS_CustomFlag,PS_Duration,PS_Interval) 
  		values 
  		(:psLocId,:psCode,:psDesc,:psShortDesc,:psStartTime,:psEndTime,:psScheTypeId,:psCustFlag,:psDuration,:psInterval)
  	  )
  	.i SQLCODE'=0 s errCode="-1^增加失败:"_psDesc_","_%msg
  	e   d
	.&sql(
		update PIVA_Schedul 
		set PS_Loc_Dr=:psLocId,PS_Code=:psCode,PS_Desc=:psDesc,PS_ShortDesc=:psShortDesc,PS_StartTime=:psStartTime,
		PS_EndTime=:psEndTime,PS_ScheType_Dr=:psScheTypeId,PS_CustomFlag=:psCustFlag,PS_Duration=:psDuration,PS_Interval=:psInterval
		where PS_RowId=:psId  
	 )
	.i SQLCODE'=0 s errCode="-1^修改失败:"_psDesc_","_$g(%msg)
	q:errCode'="" errCode
	q 0_"^保存成功"
}

/// description: 删除
ClassMethod Delete(psId)
{
	q:psId="" "-1^Id为空"
	&SQL(SELECT * FROM PIVA_UserSchedul WHERE PUS_Schedul_Dr=:psId)
	q:SQLCODE=0 "-1^该班次已关联人员,不能删除"
	&SQL(SELECT * FROM PIVA_ScheArrangeItm WHERE PSAI_Schedul_Dr=:psId)
	q:SQLCODE=0 "-1^已生成排班数据包含该班次,不能删除"
	
	&sql(delete from PIVA_Schedul where PS_RowId=:psId)
	q:SQLCODE'=0 "-1^删除失败,SQLCODE:"_SQLCODE
	q 0
}

/// description: 根据班次Id获取日期信息
/// w ##class(web.DHCSTPIVAS.Schedul).GetScheDateById(1)
ClassMethod GetScheDateById(PsId)
{
	s retStr=""
	q:PsId="" ""
	s psData=$g(^Code.PIVA.Schedul(PsId))
	q:psData="" ""
	s psDaysData=$p(psData,"^",10)
	s daysDataLen=$l(psDaysData,"!!")
	s daysDataI=""
	f daysDataI=1:1:daysDataLen d
	.s daysData=$p(psDaysData,"!!",daysDataI)
	.q:daysData=""
	.s daysType=$p(daysData,":",1)
	.s days=$p(daysData,":",2)
	.q:(daysType="")||(days="")
	.s daysLen=$l(days,",")
	.s psDays=""
    .s i=""
	.f i=1:1:daysLen d
	..s tmpDay=$p(days,",",i)
	..s tmpDay=$replace(tmpDay," ","")
	..q:tmpDay=""
	..i daysType="D" s tmpDay=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(tmpDay)
	..e  d
	...s tmpDay=tmpDay
	..i psDays="" s psDays=tmpDay
	..e  s psDays=psDays_","_tmpDay
	.q:psDays=""
	.s daysStr=daysType_":"_psDays
	.i retStr="" s retStr=daysStr
	.e  s retStr=retStr_"!!"_daysStr
	q retStr
}

/// description: 根据班次Id获取关联班次
/// w ##class(web.DHCSTPIVAS.Schedul).GetLinkScheById(1)
ClassMethod GetLinkScheById(PsId)
{
	s retStr=""
	q:PsId="" ""
	s psData=$g(^Code.PIVA.Schedul(PsId))
	q:psData="" ""
	s psDaysData=$p(psData,"^",12)
	
	q psDaysData
}

/// description: 保存固定日期
ClassMethod SaveLinkSche(srtParam)
{
	q:srtParam="" "-1^班次Id为空"
	s PsId=$p(srtParam,"^",1)
	s psLinkId=$p(srtParam,"^",2)
	q:PsId="" "-1^班次Id为空"
	s psList=$lfs(psLinkId,",")
	s linkStr=""
	f len=1:1:$ll(psList) d
	.s link=$list(psList,len)
	.q:link=""
	.i linkStr="" s linkStr=link
	.e  s linkStr=linkStr_","_link
	&sql(
		update PIVA_Schedul 
		set PS_LinkSchedul=:linkStr
		where PS_RowId=:PsId  
	 )
	q:SQLCODE'=0 "-1^"_$g(%msg)_",SQLCODE:"_SQLCODE
	q 0
}

/// description: 根据班次Id获取日期输出用
/// w ##class(web.DHCSTPIVAS.Schedul).GetScheDateHtmlById(1)
ClassMethod GetScheDateHtmlById(PsId)
{
	s retStr=""
	q:PsId="" ""
	s psData=$g(^Code.PIVA.Schedul(PsId))
	q:psData="" ""
	s psDaysData=$p(psData,"^",10)
	s daysDataLen=$l(psDaysData,"!!")
	s daysDataI=""
	f daysDataI=1:1:daysDataLen d
	.s daysData=$p(psDaysData,"!!",daysDataI)
	.q:daysData=""
	.s daysType=$p(daysData,":",1)
	.s days=$p(daysData,":",2)
	.q:(daysType="")||(days="")
	.s daysLen=$l(days,",")
	.s psDays=""
    .s i=""
	.f i=1:1:daysLen d
	..s tmpDay=$p(days,",",i)
	..s tmpDay=$replace(tmpDay," ","")
	..q:tmpDay=""
	..i daysType="D" s tmpDay=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(tmpDay)
	..e  d
	...s tmpDay=tmpDay
	..
	..i psDays="" s psDays=tmpDay
	..e  s psDays=psDays_","_tmpDay
	.q:psDays=""
	.s daysTypeDesc=""
	.i daysType="M" s daysTypeDesc="月初"
	.e  i daysType="ME" s daysTypeDesc="月末"
	.e  i daysType="W" s daysTypeDesc="每周"
	.e  i daysType="D" s daysTypeDesc="日期"
	.q:daysTypeDesc=""
	.s daysStr=daysTypeDesc_":"_psDays
	.i retStr="" s retStr=daysStr
	.e  s retStr=retStr_"</br>"_daysStr
	q retStr
}

/// description: 保存固定日期
ClassMethod SaveDays(PsId, DaysDataHtml)
{
	q:PsId="" "-1^班次Id为空"
	s days=""
	s daysDataLen=$l(DaysDataHtml,"!!")
	s daysDataI=""
	f daysDataI=1:1:daysDataLen d
	.s daysData=$p(DaysDataHtml,"!!",daysDataI)
	.q:daysData=""
	.s daysType=$p(daysData,":",1)
	.s daysHtml=$p(daysData,":",2)
	.q:(daysType="")||(daysHtml="")
	.s daysLen=$l(daysHtml,",")
    .s i=""
	.f i=1:1:daysLen d
	..s iDay=$p(daysHtml,",",i)
	..s iDay=$replace(iDay," ","")
	..q:iDay=""
	..i daysType="D" s tmpDay=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(iDay)
	..e  s tmpDay=iDay
	..i tmpDay'=iDay s DaysDataHtml=$replace(DaysDataHtml,iDay,tmpDay)
	&sql(
		update PIVA_Schedul 
		set PS_Days=:DaysDataHtml
		where PS_RowId=:PsId  
	 )
	q:SQLCODE'=0 "-1^"_$g(%msg)_",SQLCODE:"_SQLCODE
	q 0
}

}
