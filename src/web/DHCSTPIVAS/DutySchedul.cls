Import sqluser

/// creator: 	yunhaibao
/// createdate: 2018-06-28
/// description:岗位班次关联
Class web.DHCSTPIVAS.DutySchedul Extends %RegisteredObject
{

/// deccription:岗位班次列表
/// input:		^1:岗位Id,^2:对照类型,^3:班次Id
/// table:      User.PIVADutySchedul
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.DutySchedul","PIVADutySchedul",""2^M,ME,W,D^3"")
Query PIVADutySchedul(inputStr = "") As websys.Query(ROWSPEC = "pdsId,psId,psCode,psDesc,psStartTime,psEndTime,psScheTypeDesc,psCustFlag,psDuration,pdsType,pdsTypeDesc,pdsDays,pdsDaysHtml")
{
}

ClassMethod PIVADutySchedulExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	//s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.DutySchedul","PIVADutySchedul")=inputStr
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PDId=$p(inputStr,"^",1)
	s PDSType=$p(inputStr,"^",2)
	s PSId=$p(inputStr,"^",3)
	q:+PDId=0 $$$OK
	q:PDSType="" $$$OK
	//s $zt="ThrowPIVADutySchedul"
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT * FROM PIVA_DutySchedul where PDS_RowId>0"
    i PDId'="" s sqlStr=sqlStr_" and PDS_Duty_Dr="_"'"_PDId_"'"
    i PSId'="" s sqlStr=sqlStr_" and PDS_Schedul_Dr="_"'"_PSId_"'"
    i PDSType="N" s sqlStr=sqlStr_" and PDS_Type="_"'"_PDSType_"'"
    e  d
    .s sqlStr=sqlStr_" and PDS_Type<>"_"'N'"
    .s sqlStr=sqlStr_" ORDER BY PDS_Schedul_Dr,PDS_Type"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
	    s pdsId=result.Data("PDS_RowId") 
	    s psId= result.Data("PDS_Schedul_Dr") 
	    s pdId=result.Data("PDS_Duty_Dr") 
	    continue:(psId="")||(pdId="")
		s psObj=##class(User.PIVASchedul).%OpenId(psId,0)
	   	s psCode= psObj.PSCode
	    s psDesc= psObj.PSDesc
	    s psStartTime=psObj.PSStartTime
	    s psStartTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(psStartTime,"PIVA")
	    s psEndTime= psObj.PSEndTime
	    s psEndTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(psEndTime,"PIVA")
	    s psScheTypeDesc= psObj.PSScheTypeDr.PSTDesc
	    s psCustFlag=psObj.PSCustomFlag
	    s psDuration=psObj.PSDuration
	    s pdsType=result.Data("PDS_Type")
	    s pdsDays=result.Data("PDS_Days")
	    s daysLen=$l(pdsDays,",")
	    s pdsDaysHtml=""
	    s i=""
		f i=1:1:daysLen d
		.s tmpDay=$p(pdsDays,",",i)
		.s tmpDay=$replace(tmpDay," ","")
		.q:tmpDay=""
		.i pdsType="D" s tmpDay=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(tmpDay)
		.e  d
		..s tmpDay="第"_tmpDay_"天"
		.s pdsDaysHtml=$s(pdsDaysHtml="":tmpDay,1:pdsDaysHtml_","_tmpDay)
	    s pdsTypeDesc=$s(pdsType="M":"每月初",pdsType="ME":"每月末",pdsType="W":"每周",pdsType="D":"指定日期",1:"常规")
        d outputrow
    }
    d result.Close()
	Quit $$$OK
outputrow
	s Data=$lb(pdsId,psId,psCode,psDesc,psStartTime,psEndTime,psScheTypeDesc,psCustFlag,psDuration,pdsType,pdsTypeDesc,pdsDays,pdsDaysHtml)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
ThrowPIVADutySchedul
	q $$$OK
}

/// description: 批量保存岗位班次对照
/// w ##class(web.DHCSTPIVAS.DutySchedul).SaveMulti("^2^3^M^1,2,3,25!!^2^3^ME^1,2!!^2^3^W^!!^2^3^D^2018-06-01, 2018-06-02")
ClassMethod SaveMulti(inputData)
{
	s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.DutySchedul","SaveMulti")=inputData
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
	s pdsId=$p(inputStr,"^",1)		// 岗位班次对照Id
	s pdId=$p(inputStr,"^",2)		// 岗位Id
	s psId=$p(inputStr,"^",3)		// 班次Id
	s pdsType=$p(inputStr,"^",4)	// 对照方式
	s pdsDays=$p(inputStr,"^",5)	// 对照方式日期规则
  	q:pdId="" "-1^岗位不能为空"
  	q:psId="" "-1^班次不能为空"
  	q:pdsType="" "-1^对照方式不能为空"
  	s pdDesc=##class(User.PIVADuty).%OpenId(pdId,0).PDDesc
  	s psDesc=##class(User.PIVASchedul).%OpenId(psId,0).PSDesc
  	s pdsDays=..ChangeDays(pdsType,pdsDays)
  	q:(pdsType'="N")&&(pdsDays="") 0
  	s errCode=""
  	i pdsId="" d
  	.&SQL(SELECT PDS_RowId FROM PIVA_DutySchedul WHERE PDS_Schedul_Dr=:psId and PDS_Duty_Dr=:pdId and PDS_Type=:pdsType)
  	.i SQLCODE=0 s errCode="-1^对照关系已存在:"_pdDesc_"-"_psDesc q
  	e  d 
  	.&SQL(SELECT PDS_RowId FROM PIVA_DutySchedul WHERE PDS_Schedul_Dr=:psId and PDS_Duty_Dr=:pdId and PDS_Type=:pdsType and PDS_RowId!=:pdsId)
  	.i SQLCODE=0 s errCode="-1^对照关系已存在:"_pdDesc_"-"_psDesc q
  	q:errCode'="" errCode
  	i pdsId=""  d
  	.&sql(
  		insert into PIVA_DutySchedul
  		(PDS_Duty_Dr,PDS_Schedul_Dr,PDS_Type,PDS_Days) 
  		values 
  		(:pdId,:psId,:pdsType,:pdsDays)
  	  )
  	.i SQLCODE'=0 s errCode="-1^增加失败:"_pdDesc_"-"_psDesc_","_%msg
  	e   d
	.&sql(
		update PIVA_DutySchedul 
		set PDS_Duty_Dr=:pdId,PDS_Schedul_Dr=:psId,PDS_Type=:pdsType,PDS_Days=:pdsDays
		where PDS_RowId=:pdsId  
	 )
	.i SQLCODE'=0 s errCode="-1^修改失败:"_pdDesc_"-"_psDesc_","_$g(%msg)
	q:errCode'="" errCode
	q 0_"^保存成功"
}

/// description: 删除
ClassMethod Delete(pdsId)
{
	q:pdsId="" "-1^Id为空"
	&sql(delete from PIVA_DutySchedul where PDS_RowId=:pdsId)
	q:SQLCODE'=0 "-1^删除失败,SQLCODE:"_SQLCODE
	q 0
}

/// description: 转换格式
/// w ##class(web.DHCSTPIVAS.DutySchedul).ChangeDays("D","2018-01-02,2018-01-01")
ClassMethod ChangeDays(pdsType, pdsDays)
{
	q:pdsDays="" ""
	s origDays=pdsDays
	s chDays=""
	s daysLen=$l(origDays,",")
	s i=""
	f i=1:1:daysLen d
	.s tmpDay=$p(origDays,",",i)
	.s tmpDay=$replace(tmpDay," ","")
	.q:tmpDay=""
	.i pdsType="D" d
	..s tmpDay=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(tmpDay)
	.q:tmpDay=""
	.s ChangeDaysData(tmpDay)=""
	s tmpDay=""
	f  s tmpDay=$o(ChangeDaysData(tmpDay)) q:tmpDay=""  d
	.s chDays=$s(chDays="":tmpDay,1:chDays_","_tmpDay)
	q chDays
}

}
