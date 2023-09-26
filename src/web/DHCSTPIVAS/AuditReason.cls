Import sqluser

/// description: 配伍审核原因维护
Class web.DHCSTPIVAS.AuditReason Extends %RegisteredObject
{

Parameter TableName [ Final ] = "DHC_PHCNTSREASON";

Parameter LogSign [ Final ] = "配液中心 - 配伍审核原因";

/// 代码在表记录中完全唯一
Parameter UniqueCode [ Final ] = {$$$YES};

/// creator: 	yunhaibao
/// createdate: 2018-03-02
/// description:审核原因树形结构列表
/// table:      User.DHCPHCNTSREASON
/// input:		$p(inputStr,"^",1)-处方点评中的点评方式
/// w ##class(web.DHCSTPIVAS.AuditReason).JsGetAuditReason("","","68^1")
ClassMethod JsGetAuditReason(rows, page, inputStr = "", hosp = "")
{
	s rows=99999
	s page=1
	s wayId=$p(inputStr,"^",1)
	q:wayId="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s reasonShow=$p(inputStr,"^",2)
	q:reasonShow="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	i '$d(^DHCPCREASON(0,"Level",wayId)) d
	.s initStr=""_"^"_"初始化数据可修改"_"^"_"初始化数据可修改"_"^"_0_"^"_wayId
	.s saveRet=##class(web.DHCSTPIVAS.AuditReason).SaveAuditReason(initStr,hosp)
	s total=0
	s detailTitle="reasonId^reasonCode^reasonDesc^_parentId"
	s level=""
	f  s level=$o(^DHCPCREASON(0,"Level",wayId,level)) q:level=""  d
	.s reasonId=""
	.f  s reasonId=$o(^DHCPCREASON(0,"Level",wayId,level,reasonId)) q:reasonId=""  d
	..q:+reasonId=0
	..q:##class(PHA.FACE.IN.Com).GetShowDataFlag(..#TableName,reasonId,hosp)="N"
	..s reasonDesc=$p(^DHCPCREASON(reasonId),"^",2)
	..s reasonCode=$p(^DHCPCREASON(reasonId),"^",1)
	..s total=total+1
	..s data=reasonId_"^"_reasonCode_"^"_reasonDesc_"^"_level
	..i total=1 d
	...w ##class(web.DHCSTJQUERYCOMMON).getJsonRowSign()
	...W ##class(web.DHCSTJQUERYCOMMON).getJsonData(detailTitle,data,"^")
	..e  d
	...W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(detailTitle,data,"^")
	q:total=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s mainTitle="reasonId^reasonCode^reasonDesc"
	s mainData="0^配伍审核原因^配伍审核原因"
	W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(mainTitle,mainData,"^")
	w "],""total"""_":"_(total+1)_"}"
	q ""
}

/// description:配液审核原因列表
/// others:		
/// input:	
/// others:		level就是parent
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.AuditReason","QueryAuditReason","68^1")
Query QueryAuditReason(inputStr = "", hosp = "") As websys.Query(ROWSPEC = "pcrRowId,pcrCode,pcrDesc,pcrLevel")
{
}

ClassMethod QueryAuditReasonExecute(ByRef qHandle As %Binary, inputStr = "", hosp) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s WayId=$p(inputStr,"^",1)
	s PcrParent=$p(inputStr,"^",2)
	q:(WayId="")||(PcrParent="") $$$OK 
	s pcrLevel=""
	f  s pcrLevel=$o(^DHCPCREASON(0,"Level",WayId,pcrLevel)) q:pcrLevel=""  d
	.s pcrRowId=""
	.f  s pcrRowId=$o(^DHCPCREASON(0,"Level",WayId,pcrLevel,pcrRowId)) q:pcrRowId=""  d
	..s pcrParent=$p(^DHCPCREASON(pcrRowId),"^",3)
	..q:pcrParent'=PcrParent
	..q:##class(PHA.FACE.IN.Com).GetShowDataFlag(..#TableName,pcrRowId,hosp)="N"
	..s pcrCode=$p(^DHCPCREASON(pcrRowId),"^",1)
	..s pcrDesc=$p(^DHCPCREASON(pcrRowId),"^",2)
	..s QueryAuditReasonData(pcrCode,pcrRowId)=pcrRowId_"^"_pcrCode_"^"_pcrDesc_"^"_pcrLevel
	s sortIndex=""
	f  s sortIndex=$o(QueryAuditReasonData(sortIndex)) q:sortIndex=""  d
	.s pcrRowId=""
	.f  s pcrRowId=$o(QueryAuditReasonData(sortIndex,pcrRowId)) q:pcrRowId=""  d
	..s ^CacheTemp(repid,ind)=$lfs(QueryAuditReasonData(sortIndex,pcrRowId),"^")   
	..s ind=ind+1
	Quit $$$OK
}

/// description: 保存配伍审核原因
/// 同级别不允许重复,跨级别允许
/// w ##class(web.DHCSTPIVAS.AuditReason).SaveAuditReason("^123^d^0^68")
ClassMethod SaveAuditReason(inputStr, hosp)
{
	s PcrId=$p(inputStr,"^",1)
	s PcrCode=$p(inputStr,"^",2)
	s PcrDesc=$p(inputStr,"^",3)
	s PcrLevel=$p(inputStr,"^",4)
	s WayId=$p(inputStr,"^",5)
	q:PcrCode="" "-1^原因代码为空"
	q:PcrDesc="" "-1^原因内容为空"
	q:WayId="" "-1^审核原因类型为空"
	q:PcrLevel="" "-1^父级别为空"
	s errCode=""
	s chkRet=..CheckSave(PcrId, WayId,PcrLevel,PcrCode, PcrDesc, hosp)
	q:chkRet'="" chkRet
	i PcrId="" d
	.&SQL(
		INSERT INTO DHC_PHCNTSREASON
		(PCR_Code,PCR_Desc,PCR_Level,PCR_Way_Dr)
		VALUES
		(:PcrCode,:PcrDesc,:PcrLevel,:WayId)
	 )
	.i SQLCODE'=0 s errCode="-2^插入失败,"_%msg
	.e  d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#TableName, $p(%ROWID,$c(1)), hosp)
	e  d
	.s oldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#TableName, PcrId)
	.&SQL(
		UPDATE DHC_PHCNTSREASON
		SET PCR_Code=:PcrCode,PCR_Desc=:PcrDesc,PCR_Level=:PcrLevel,PCR_Way_Dr=:WayId
		WHERE PCR_RowID=:PcrId
	 )
	 .i SQLCODE'=0 s errCode="-2^更新失败,"_%msg
	q:errCode'="" errCode
    #; 日志
    s rowID = $g(%ROWID) 
	s logSignDesc=..GetDataLogSignDesc(rowID)
	s newJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#TableName, rowID)
	s logType = $s(PcrId = "" : "A" , 1 : "U")
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(..#TableName,"User.DHCPHCNTSREASON", ..#LogSign, %ROWID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))

	q "0^保存成功"
}

/// description: 批量保存原因
ClassMethod Save(inputData, hosp)
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"|@|")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"|@|",inputI)
	.q:iData=""
	.s saveRet=..SaveAuditReason(iData,hosp)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// description: 删除配伍审核原因
/// others:      仅删除原因关联关系，不删除原因数据
ClassMethod DeleteAuditReason(wayId, reasonId, reasonLevel, hosp = "") As %String
{
	q:((wayId="")||(reasonId="")||(reasonLevel="")) "-1^数据为空"
	s reasonCnt=0
    s logSignDesc=..GetDataLogSignDesc(reasonId)
    s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#TableName, reasonId)
	&SQL(SELECT count(*) into :reasonCnt FROM DHC_PHCNTSREASON WHERE PCR_Way_Dr=:wayId)
	q:reasonCnt<=1 "-1^此为最后一条数据,不能删除,可修改"
    k ^DHCPCREASON(0,"Level",wayId,reasonLevel,reasonId)
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(..#TableName, "User.DHCPHCNTSREASON", ..#LogSign, reasonId, logSignDesc, "D", delJsonStr)
    q 0
}

ClassMethod CheckSave(id, wayID, level, code, desc, hosp) As %String
{
	s sqlStr="SELECT PCR_RowID AS rowID FROM DHC_PHCNTSREASON WHERE PCR_Way_Dr='"_wayID_"'" _
			 " AND PCR_Level='"_level_"'"
	i id'="" s sqlStr=sqlStr_" AND PCR_RowID!='"_id_"'"
	
	s newSqlStr=sqlStr_" AND PCR_Code='"_code_"'"
    if (..#UniqueCode = $$$YES){
        s existID = ##class(PHA.COM.Method).IsSQLDataExist(newSqlStr, "", "")
    }else{
	    s existID = ##class(PHA.COM.Method).IsSQLDataExist(newSqlStr, ..#TableName, hosp)
    }
  	q:existID'="" "-1^该层级已存在此原因代码"
  	
  	s newSqlStr=sqlStr_" AND PCR_Desc='"_desc_"'"
	s existID=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	q:existID'="" "-1^该层级已存在此原因名称"	
  	
  	q ""
}

ClassMethod InitDictByHosp(wayID, hosp)
{
    s code = "初始化数据" _ $p(^CTLOC(hosp), "^", 2)
	s initStr=""_"^"_code_"^"_"初始化数据可修改"_"^"_0_"^"_wayID
	s saveRet=##class(web.DHCSTPIVAS.AuditReason).SaveAuditReason(initStr,hosp)
	q ""
}

ClassMethod GetDataLogSignDesc(rowID)
{
	&SQL(
		SELECT PCR_Desc INTO :ret
		FROM SQLUSER.DHC_PHCNTSREASON  
		WHERE %ID = :rowID
	)
	q $g(ret)
}

}
