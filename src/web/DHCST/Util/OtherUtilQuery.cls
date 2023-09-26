Import sqluser

/// creator:    yunhaibao
/// createdate: 2017-07-07
/// description:与web.DHCST.Util.OtherUtil对应,建立相应query,仅返回数据集
/// others:		ext\easyui等需要的数据格式有所区别
Class web.DHCST.Util.OtherUtilQuery Extends %RegisteredObject
{

/// deccription:不可退药原因
/// table:      User.DHCStkRefuseRetReason
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.OtherUtilQuery","GetRefRetReason")
Query GetRefRetReason() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetRefRetReasonExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "Select RefRet_ROWID As RowId,RefRet_Desc As Description From DHC_StkRefuseRetReason"    
	d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

}
