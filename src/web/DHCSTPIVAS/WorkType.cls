Import sqluser

/// creator:	 QianHuanjuan
/// createdate:	 2018-03-02
/// description: 工作组维护
Class web.DHCSTPIVAS.WorkType Extends %RegisteredObject
{

Parameter LogSign [ Final ] = "配液中心 - 工作组";

/// description:工作组列表
/// others:		
/// input:		$p(inputStr,"^",1)-配液中心Id
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.WorkType","WorkType",248)
Query WorkType(inputStr = "") As websys.Query(ROWSPEC = "wtId,wtCode,wtDesc,locDesc,locId,prtWayDesc,wtUseFlag,wtDefault,wtOrdNum")
{
}

ClassMethod WorkTypeExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PivaLocId=$p(inputStr,"^",1)
	s HospId=$p(inputStr,"^",2)
	q:(HospId="")&&(PivaLocId="") $$$OK
	q:PivaLocId="" $$$OK
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT PIVAWT_Rowid as wtId,PIVAWT_LOC_DR->ctloc_desc as locDesc,PIVAWT_LOC_DR as locId,PIVAWT_Code as wtCode,PIVAWT_Desc as wtDesc,PIVAWT_PrtWay as prtWayDesc,PIVAWT_UseFlag as wtUseFlag,PIVAWT_Default as wtDefault,PIVAWT_OrdNum as wtOrdNum FROM PIVA_WorkType order by PIVAWT_LOC_DR->ctloc_desc,PIVAWT_OrdNum"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
	    s wtId= result.Data("wtId") 
	    s wtCode= result.Data("wtCode") 
	    s wtDesc= result.Data("wtDesc") 
	    s locId= result.Data("locId")
	    continue:(PivaLocId'="")&&(PivaLocId'=locId)
	    continue:(HospId'="")&&(HospId'=$p(^CTLOC(locId),"^",22))
	    s locDesc= result.Data("locDesc")
	    s prtWayDesc=result.Data("prtWayDesc")
	    s wtUseFlag=result.Data("wtUseFlag")
	    s wtDefault=result.Data("wtDefault")
	    s wtOrdNum=result.Data("wtOrdNum")
        d outputWorkType
    }
    d result.Close()
	Quit $$$OK
outputWorkType
	s Data=$lb(wtId,wtCode,wtDesc,locDesc,locId,prtWayDesc,wtUseFlag,wtDefault,wtOrdNum)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// description: 批量保存工作组
ClassMethod Save(inputData)
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..SaveWorkType(iData)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// description: 保存工作组信息
/// input:		 inputStr^1:id,inputStr^2:代码,inputStr^3:名称,inputStr^4:科室Id,inputStr^5:打印方式
/// return:		 +ret=0 成功
/// w ##class(web.DHCSTPIVAS.ConfigTable)SaveWorkType("^qhj^焕娟测试^101")
ClassMethod SaveWorkType(inputStr)
{
	s id=$p(inputStr,"^",1)
	s code=$p(inputStr,"^",2)
	s desc=$p(inputStr,"^",3)
	s loc=$p(inputStr,"^",4)
	s prtWay=$p(inputStr,"^",5)
	s useFlag=$p(inputStr,"^",6)
	s default=$p(inputStr,"^",7)
	s ordNum=$p(inputStr,"^",8)
  	q:code="" "-1^代码不能为空"
  	q:desc="" "-1^名称不能为空"
  	q:loc="" "-1^科室不能为空"
  	q:prtWay="" "-1^打印方式不能为空"
  	q:ordNum="" "-1^优先级不能为空"
  	s errCode=""
  	i id="" d
  	.&SQL(SELECT PIVAWT_Rowid FROM PIVA_WorkType WHERE PIVAWT_Code=:code and PIVAWT_Loc_Dr=:loc)
  	.i SQLCODE=0 s errCode="-1^该配液中心此代码已存在"
  	.q:errCode'=""
  	.&SQL(SELECT PIVAWT_Rowid FROM PIVA_WorkType WHERE PIVAWT_Desc=:desc and PIVAWT_Loc_Dr=:loc)
  	.i SQLCODE=0 s errCode="-1^该配液中心此名称已存在"
  	.q:errCode'=""
  	e  d 
  	.&SQL(SELECT PIVAWT_Rowid FROM PIVA_WorkType WHERE PIVAWT_Code=:code and PIVAWT_Loc_Dr=:loc and PIVAWT_Rowid!=:id)
  	.i SQLCODE=0 s errCode="-1^该配液中心此代码已存在"
  	.q:errCode'=""
  	.&SQL(SELECT PIVAWT_Rowid FROM PIVA_WorkType WHERE PIVAWT_Desc=:desc and PIVAWT_Loc_Dr=:loc and PIVAWT_Rowid!=:id)
  	.i SQLCODE=0 s errCode="-1^该配液中心此名称已存在"
  	.q:errCode'=""
  	q:errCode'="" errCode
  	i default="Y" s useFlag="Y"
  	i id=""  d
  	.&sql(
  		insert into PIVA_WorkType 
  		(PIVAWT_LOC_DR,PIVAWT_Code,PIVAWT_Desc,PIVAWT_PrtWay,PIVAWT_UseFlag,PIVAWT_Default,PIVAWT_OrdNum) 
  		values 
  		(:loc,:code,:desc,:prtWay,:useFlag,:default,:ordNum)
  	  )
  	.i SQLCODE'=0 s errCode="-1^增加失败"
  	e   d
    .s oldJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PIVA_WorkType", id)
	.&sql(
		update PIVA_WorkType 
		set PIVAWT_Code=:code,PIVAWT_Desc=:desc,PIVAWT_Loc_Dr=:loc,PIVAWT_PrtWay=:prtWay,
		PIVAWT_UseFlag=:useFlag,PIVAWT_Default=:default,PIVAWT_OrdNum=:ordNum
		where PIVAWT_Rowid=:id  
	 )
	.i SQLCODE'=0 s errCode="-1^修改失败"
	q:errCode'="" errCode
	s rowId=$p($g(%ROWID),$c(1))
	i default="Y" d
	.&SQL(
	 	update PIVA_WorkType 
		SET PIVAWT_Default='N'
		where PIVAWT_Rowid!=:rowId and PIVAWT_Loc_Dr=:loc 	
	 )
    s logSignDesc = ..GetWorkTypeLogSignDesc(rowId)
	s newJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PIVA_WorkType", rowId)
	s logType = $s(id = "" : "A" , 1 : "U")
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_WorkType","User.PIVAWorkType", ..#LogSign, rowId, logSignDesc, logType, newJsonStr, $g(oldJsonStr))

	q 0_"^保存成功"
}

ClassMethod GetWorkTypeLogSignDesc(rowID)
{
    &SQL(
        SELECT PIVAWT_LOC_DR->CTLOC_Desc || '-' || PIVAWT_Desc INTO :ret
        FROM PIVA_WorkType 
        WHERE %ID = :rowID
    )
    q $g(ret)
}

/// description: 删除工作组信息
/// w ##class(web.DHCSTPIVAS.WorkType).DeleteWT("2")
ClassMethod DeleteWT(wtId)
{
	q:wtId="" "-1^Id为空"
  	s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_WorkType", wtId)
	s logSignDesc = ..GetWorkTypeLogSignDesc(wtId)  
	&SQL(
        DELETE
        FROM PIVA_WorkType
        WHERE PIVAWT_Rowid = :wtId
    )
    q:SQLCODE'=0 SQLCODE
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_WorkType","User.PIVAWorkType", ..#LogSign, wtId, logSignDesc, "D", delJsonStr)
	q SQLCODE
}

/// description:工作组规则列表
/// others:		
/// input:	
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.WorkType","WorkTypeItm","18")
Query WorkTypeItm(inputStr = "") As websys.Query(ROWSPEC = "wtItmId,wtId,confTabId,confTabDesc,instrId,instrDesc,wtRelation,wtLiquid,wtRelationDesc")
{
}

ClassMethod WorkTypeItmExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    q:inputStr="" $$$OK
    s wtId=$p(inputStr,"^",1)
	s wtItm=""
	f  s wtItm=$o(^PIVAWT(wtId,"I",wtItm))    q:wtItm=""  d
	.s confTabId=$p(^PIVAWT(wtId,"I",wtItm),"^",1)
	.s confTabDesc=##class(PHA.PIVAS.Data.Base).PIVAConfigTableDesc(confTabId)
	.s instrId=$p(^PIVAWT(wtId,"I",wtItm),"^",2)
	.s instrDesc=##class(PHA.PIVAS.Data.Base).InstDesc(instrId)
	.s wtRelation=$p(^PIVAWT(wtId,"I",wtItm),"^",3)
	.s wtLiquid=$p(^PIVAWT(wtId,"I",wtItm),"^",4)
	.i wtRelation=">" s wtRelationDesc=##class(PHA.FACE.IN.Com).Translate("dhcpha.pivas.worktype.csp", "大于")
	.e  i wtRelation="<" s wtRelationDesc=##class(PHA.FACE.IN.Com).Translate("dhcpha.pivas.worktype.csp", "小于")
	.e  s wtRelationDesc=""
	.s wtItmId=wtId_"||"_wtItm
	.d outputWorkTypeItm 
	Quit $$$OK
outputWorkTypeItm
	s Data=$lb(wtItmId,wtId,confTabId,confTabDesc,instrId,instrDesc,wtRelation,wtLiquid,wtRelationDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// description: 批量保存工作组规则
ClassMethod SaveItm(inputData)
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..SaveWorkTypeItm(iData)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// description: 保存工作组规则
/// input:	     inputStr^1:工作组规则Id,inputStr^2:工作组Id,inputStr^3:配置台Id,inputStr^4:用法,inputStr^5:关系,inputStr^6:液体量
/// w ##class(web.DHCSTPIVAS.WorkType).SaveWorkTypeItm("^5^7^2^^")
ClassMethod SaveWorkTypeItm(inputStr)
{
	s chkInfo=..CheckSaveWorkTypeItm(inputStr)
	q:chkInfo'="" chkInfo
	s wtItmId=$p(inputStr,"^",1)
	s wtId=$p(inputStr,"^",2)
	s confTabId=$p(inputStr,"^",3)
	s instrId=$p(inputStr,"^",4)
	s wtRelation=$p(inputStr,"^",5)
	s wtLiquid=$p(inputStr,"^",6)
	i wtLiquid="" s wtRelation=""
	s errCode=""
	i wtItmId'=""  d 
    .s oldJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PIVA_WorkTypeItm", wtItmId)
	.&SQL(  
		Update PIVA_WorkTypeItm
		set PIVAWTI_ConfTab_Dr=:confTabId,PIVAWTI_Inst_Dr=:instrId,PIVAWTI_Relation=:wtRelation,PIVAWTI_Liquid=:wtLiquid
		where PIVAWTI_Rowid=:wtItmId
		)
	.i SQLCODE'=0 s errCode="-1^更新失败" 
	e  d
	.q:errCode'=""
	.s maxSub=$o(^PIVAWT(wtId,"I",""),-1)+1
	.&SQL(
		insert into PIVA_WorkTypeItm
		(PIVAWTI_Parref,PIVAWTI_ChildSub,PIVAWTI_ConfTab_Dr,PIVAWTI_Inst_Dr,PIVAWTI_Relation,PIVAWTI_Liquid)
		values
		(:wtId,:maxSub,:confTabId,:instrId,:wtRelation,:wtLiquid)
		)
	.i SQLCODE'=0 s errCode="-1^插入失败" 
	q:errCode'="" errCode
    s rowID = %ROWID
 	s logSignDesc = "工作组规则: " _  ..GetWorkTypeLogSignDesc(+rowID)
	s newJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PIVA_WorkTypeItm", rowID)
	s logType = $s(wtItmId = "" : "A" , 1 : "U")
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_WorkTypeItm","User.PIVAWorkTypeItm", ..#LogSign, rowID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))
	q 0_"^保存成功"
}

/// description: 删除工作组规则
ClassMethod Delete(wtItmId)
{
	q:wtItmId="" "-1^Id为空"
    s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_WorkTypeItm", wtItmId)
	s logSignDesc = "工作组规则: " _ ..GetWorkTypeLogSignDesc(+wtItmId)
	&SQL(
        DELETE
        FROM PIVA_WorkTypeItm
        WHERE PIVAWTI_Rowid = :wtItmId
    )
	q:SQLCODE'=0 "-2^删除失败"
    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_WorkTypeItm","User.PIVAWorkTypeItm", ..#LogSign, wtItmId, logSignDesc, "D", delJsonStr)

	q SQLCODE
}

/// Description: 获取数据
/// w ##class(web.DHCSTPIVAS.WorkType).SelectWorkType(15)
ClassMethod SelectWorkType(WTId)
{
	s WTId=+WTId
	q:WTId=0 {}.%ToJSON
	s json={}
	s PIVAWT=$g(^PIVAWT(WTId))
	q:PIVAWT="" json.%ToJSON
	s json.wtCode=$p(PIVAWT,"^",2)
	s json.wtDesc=$p(PIVAWT,"^",3)
	s json.wtPrtWay=$p(PIVAWT,"^",4)
	s json.wtUse=$p(PIVAWT,"^",5)
	s json.wtDefault=$p(PIVAWT,"^",6)
	s json.wtOrdNum=$p(PIVAWT,"^",7)
	q json.%ToJSON()
}

/// Description: 明细保存前验证
/// w ##class(web.DHCSTPIVAS.WorkType).CheckSaveWorkTypeItm("20||1^20^21^1^>^244")
ClassMethod CheckSaveWorkTypeItm(InputStr)
{
	s WTItmId=$p(InputStr,"^",1)
	s WTId=$p(InputStr,"^",2)
	s ConfTabId=$p(InputStr,"^",3)
	s InstrId=$p(InputStr,"^",4)
	s WTRelation=$p(InputStr,"^",5)
	s WTLiquid=$p(InputStr,"^",6)
	i WTLiquid="" s WTRelation=""
	q:ConfTabId="" "-1^配置台为空"
	q:WTId="" "-1^工作组为空"
	s chkInfo=""
	s wtItm=0
	f  s wtItm=$o(^PIVAWT(WTId,"I",wtItm))  q:(wtItm="")||(chkInfo'="")  d
	.s PIVAWTI=$g(^PIVAWT(WTId,"I",wtItm))
	.q:PIVAWTI=""
	.q:WTItmId=(WTId_"||"_wtItm)
	.s confTabId=$p(PIVAWTI,"^",1)
	.s instrId=$p(PIVAWTI,"^",2)
	.s wtRelation=$p(PIVAWTI,"^",3)
	.s wtLiquid=$p(PIVAWTI,"^",4)
	.i (ConfTabId=confTabId)&&(InstrId=instrId)&&(WTRelation=wtRelation) d
	..s chkInfo="-1^已存在相同规则数据"
	q chkInfo
}

}
