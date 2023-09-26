Import sqluser

/// creator: 	yunhaibao
/// createdate: 2018-06-26
/// description:寒暑假维护
Class web.DHCSTPIVAS.Holiday Extends %RegisteredObject
{

/// deccription:寒暑假列表
/// table:      User.PIVAHoliday
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Holiday","PIVAHoliday")
Query PIVAHoliday(inputStr = "") As websys.Query(ROWSPEC = "phId,phYear,holidayDesc,startDate,endDate")
{
}

ClassMethod PIVAHolidayExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT * FROM PIVA_Holiday where PH_RowId>0 ORDER BY PH_Year DESC,PH_Desc asc"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
	    s phId= result.Data("PH_RowId") 
	    s holidayDesc= result.Data("PH_Desc") 
	    s phYear= result.Data("PH_Year") 
	    s startDate= result.Data("PH_StartDate") 
	    s endDate= result.Data("PH_EndDate") 
	    s startDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(startDate)
	    s endDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(endDate)
        d outputPIVAHoliday
    }
    d result.Close()
	Quit $$$OK
outputPIVAHoliday
	s Data=$lb(phId,phYear,holidayDesc,startDate,endDate)
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
	s phId=$p(inputStr,"^",1)
	s holidayDesc=$p(inputStr,"^",2)
	s phYear=$p(inputStr,"^",3)
	s startDate=$p(inputStr,"^",4)
	s endDate=$p(inputStr,"^",5)
	s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
	s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
  	q:holidayDesc="" "-1^假期类型不能为空"
  	q:phYear="" "-1^年份不能为空"
  	q:startDate="" "-1^开始日期不能为空"
  	q:endDate="" "-1^结束日期不能为空"
  	q:startDate>endDate "-1^"_holidayDesc_":开始日期不能大于结束日期"
  	s errCode=""
  	i phId="" d
  	.&SQL(SELECT PH_RowId FROM PIVA_Holiday WHERE PH_Desc=:holidayDesc and PH_Year=:phYear)
  	.i SQLCODE=0 s errCode="-1^已存在:"_phYear_"年"_holidayDesc
  	e  d 
  	.&SQL(SELECT PH_RowId FROM PIVA_Holiday WHERE PH_Desc=:holidayDesc and PH_Year=:phYear and PH_RowId!=:phId)
  	.i SQLCODE=0 s errCode="-1^已存在:"_phYear_"年"_holidayDesc
  	q:errCode'="" errCode
  	i phId=""  d
  	.&sql(
  		insert into PIVA_Holiday 
  		(PH_Desc,PH_Year,PH_StartDate,PH_EndDate) 
  		values 
  		(:holidayDesc,:phYear,:startDate,:endDate)
  	  )
  	.i SQLCODE'=0 s errCode="-1^增加失败:"_phYear_"年"_holidayDesc_","_%msg
  	e   d
	.&sql(
		update PIVA_Holiday 
		set PH_Desc=:holidayDesc,PH_Year=:phYear,PH_StartDate=:startDate,PH_EndDate=:endDate
		where PH_RowId=:phId  
	 )
	.i SQLCODE'=0 s errCode="-1^修改失败:"_phYear_"年"_holidayDesc_","_$g(%msg)
	q:errCode'="" errCode
	q 0_"^保存成功"
}

/// description: 删除
ClassMethod Delete(phId)
{
	q:phId="" "-1^Id为空"
	&sql(delete from PIVA_Holiday where PH_RowId=:phId)
	q:SQLCODE'=0 "-1^删除失败,SQLCODE:"_SQLCODE
	q 0
}

}
