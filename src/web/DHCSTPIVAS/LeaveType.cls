Import sqluser

/// creator: 	yunhaibao
/// createdate: 2018-06-26
/// description:请假类型维护
Class web.DHCSTPIVAS.LeaveType Extends %RegisteredObject
{

/// deccription:请假类型列表
/// table:      User.PIVALeaveType
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.LeaveType","PIVALeaveType")
Query PIVALeaveType(inputStr = "") As websys.Query(ROWSPEC = "pltId,pltDesc,pltLimitDays")
{
}

ClassMethod PIVALeaveTypeExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT * FROM PIVA_LeaveType where PLT_RowId>0"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
	    s pltId= result.Data("PLT_RowId") 
	    s pltDesc= result.Data("PLT_Desc") 
	    s pltLimitDays= result.Data("PLT_LimitDays") 
	    i pltLimitDays
	    i (pltLimitDays<1)&&($p(pltLimitDays,".",1)="") s pltLimitDays=0_pltLimitDays
        d outputPIVALeaveType
    }
    d result.Close()
	Quit $$$OK
outputPIVALeaveType
	s Data=$lb(pltId,pltDesc,pltLimitDays)
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
	s pltId=$p(inputStr,"^",1)
	s pltDesc=$p(inputStr,"^",2)
	s pltLimitDays=$p(inputStr,"^",3)
  	q:pltDesc="" "-1^请假类型不能为空"
  	q:pltLimitDays="" "-1^请假上限天数不能为空"
  	q:+pltLimitDays<=0 "-1^请假上限天数需为正数"
  	q:+pltLimitDays<1 "-1^请假上限天数需至少为1"
  	s errCode=""
  	i pltId="" d
  	.&SQL(SELECT PLT_RowId FROM PIVA_LeaveType WHERE PLT_Desc=:pltDesc)
  	.i SQLCODE=0 s errCode="-1^已存在:"_pltDesc
  	e  d 
  	.&SQL(SELECT PLT_RowId FROM PIVA_LeaveType WHERE PLT_Desc=:pltDesc and PLT_RowId!=:pltId)
  	.i SQLCODE=0 s errCode="-1^已存在:"_pltDesc
  	q:errCode'="" errCode
  	i pltId=""  d
  	.&sql(
  		insert into PIVA_LeaveType 
  		(PLT_Desc,PLT_LimitDays) 
  		values 
  		(:pltDesc,:pltLimitDays)
  	  )
  	.i SQLCODE'=0 s errCode="-1^增加失败:"_pltDesc_","_%msg
  	e   d
	.&sql(
		update PIVA_LeaveType 
		set PLT_Desc=:pltDesc,PLT_LimitDays=:pltLimitDays
		where PLT_RowId=:pltId  
	 )
	.i SQLCODE'=0 s errCode="-1^修改失败:"_pltDesc_","_$g(%msg)
	q:errCode'="" errCode
	q 0_"^保存成功"
}

/// description: 删除
ClassMethod Delete(pltId)
{
	q:pltId="" "-1^Id为空"
	&SQL(SELECT TOP 1 * FROM PIVA_Leave WHERE PL_LeaveType_Dr=:pltId)
	q:SQLCODE=0 "-1^该类型已使用,无法删除"
	&sql(delete from PIVA_LeaveType where PLT_RowId=:pltId)
	q:SQLCODE'=0 "-1^删除失败,SQLCODE:"_SQLCODE
	q 0
}

}
