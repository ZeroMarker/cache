Import SQLUser

/// creator:    yunhaibao
/// createdate: 2018-02-27
/// description:配液拒绝原因维护
Class web.DHCSTPIVAS.OperReason Extends %RegisteredObject
{

Parameter TableName [ Final ] = "PIVA_OperReason";

Parameter LogSign [ Final ] = "配液中心 - 配液拒绝原因";

/// 代码在表记录中完全唯一
Parameter UniqueCode [ Final ] = {$$$YES};

/// description: 配液拒绝原因
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.OperReason","GetOperReason","")
Query GetOperReason(inputStr = "", hosp = "") As websys.Query(ROWSPEC = "reasonId:%String,reasonCode:%String,reasonDesc:%String,reasonType:%String,reasonTypeDesc:%String,reasonUse:%String")
{
}

ClassMethod GetOperReasonExecute(ByRef qHandle As %Binary, inputStr = "", hosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s ReasonUse=$p(inputStr,"^",1)
	s reasonId=0
    f  s reasonId=$o(^PIVAOR(reasonId)) q:reasonId=""  d
    .q:##class(PHA.FACE.IN.Com).GetShowDataFlag(..#TableName,reasonId,hosp)="N"
    .s reasonCode=$p(^PIVAOR(reasonId),"^",1)
    .s reasonDesc=$p(^PIVAOR(reasonId),"^",2)
    .s reasonType=$p(^PIVAOR(reasonId),"^",3)
    .s reasonTypeDesc=""
    .//i reasonType="C" s reasonTypeDesc="取消"
    .i reasonType="R" s reasonTypeDesc="配液拒绝"
    .//i reasonType="P" s reasonTypeDesc="审核拒绝"
    .//i reasonType="UNP" s reasonTypeDesc="非正常打包"
    .s reasonUse=$p(^PIVAOR(reasonId),"^",4)
    .q:(ReasonUse'="")&&(ReasonUse'=reasonUse)
	.d OutPutRow
	Quit $$$OK
	
OutPutRow
	set Data=$lb(reasonId,reasonCode,reasonDesc,reasonType,reasonTypeDesc,reasonUse)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	q
}

/// description: 批量保存
ClassMethod Save(inputData, hosp)
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..SaveOperReason(iData,hosp)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// description: 保存
ClassMethod SaveOperReason(inputStr, hosp)
{
	s reasonId=$p(inputStr,"^",1)
	s reasonCode=$p(inputStr,"^",2)
	s reasonDesc=$p(inputStr,"^",3)
	s reasonType=$p(inputStr,"^",4)
	s reasonUse=$p(inputStr,"^",5)
	q:reasonCode="" "-1^代码为空"
	q:reasonDesc="" "-1^内容为空"
	s errInfo=""
	s chkSave=..CheckSave(reasonId,reasonCode,reasonDesc,reasonType,hosp)
	q:chkSave'="" chkSave

	i reasonId="" d
	.&SQL(insert into PIVA_OperReason (POR_Code,POR_Desc,POR_Type,POR_Flag)values (:reasonCode,:reasonDesc,:reasonType,:reasonUse))
	.i SQLCODE'=0 s errInfo="-1^插入失败,代码:"_reasonCode_",内容:"_reasonDesc
	.e  d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#TableName, $p(%ROWID,$c(1)), hosp)
	e  d 
    .s oldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#TableName, reasonId)
	.&SQL(update PIVA_OperReason set POR_Code=:reasonCode,POR_Desc=:reasonDesc,POR_Type=:reasonType,POR_Flag=:reasonUse where POR_RowId=:reasonId)
	.i SQLCODE'=0 s errInfo="-1^更新失败,代码:"_reasonCode_",内容:"_reasonDesc
    #; 日志
    s rowID = $g(%ROWID) 
	s logSignDesc=..GetDataLogSignDesc(rowID)
	s newJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#TableName, rowID)
	s logType = $s(reasonId = "" : "A" , 1 : "U")
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(..#TableName,"User.PIVAOperReason", ..#LogSign, %ROWID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))
	q errInfo
}

/// description: 删除
ClassMethod Delete(reasonId, hosp) As %String
{
	q:reasonId="" "-1^Id为空"
    s logSignDesc=..GetDataLogSignDesc(reasonId)
    s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#TableName, reasonId)
	&sql(delete  from  PIVA_OperReason where POR_RowId=:reasonId)
	q:SQLCODE'=0 "-1^删除失败"
	d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#TableName,reasonId,hosp)
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(..#TableName, "User.PIVAOperReason", ..#LogSign, reasonId, logSignDesc, "D", delJsonStr)
	q 0
}

ClassMethod CheckSave(id, code, desc, type, hosp) As %String
{
	s sqlStr = "SELECT POR_RowId AS rowID FROM PIVA_OperReason WHERE POR_Type='"_type_"'" 
	if (id '= "") {
        s sqlStr = sqlStr _ " AND POR_RowID != '" _ id _ "'"
    }
	s newSqlStr = sqlStr _ " AND POR_Code = '"_code_"'"
    if (..#UniqueCode = $$$YES){
        s existID = ##class(PHA.COM.Method).IsSQLDataExist(newSqlStr, "", "")
    }else{
	    s existID = ##class(PHA.COM.Method).IsSQLDataExist(newSqlStr, ..#TableName, hosp)
    }
  	q:(existID '= "") "-1^已存在该类型代码:" _ code
  	
  	s newSqlStr = sqlStr _ " AND POR_Desc = '" _ desc _ "'"
	s existID = ##class(PHA.COM.Method).IsSQLDataExist(newSqlStr, ..#TableName, hosp)
  	q:(existID '= "") "-1^已存在该类型名称:" _ desc	
  	q ""
}

ClassMethod GetDataLogSignDesc(rowID)
{
	&SQL(
		SELECT POR_Desc INTO :ret
		FROM SQLUSER.PIVA_OperReason  
		WHERE %ID = :rowID
	)
	q $g(ret)
}

}
