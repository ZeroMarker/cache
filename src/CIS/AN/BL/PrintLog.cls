Class CIS.AN.BL.PrintLog Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2018-12-18
/// Description： 	是否已打印
/// Table：        	CIS.AN.RecordSheet
/// Input:			opsId:手术安排ID
/// Return：       	Y,N
/// w ##class(CIS.AN.BL.PrintLog).GetPrintCount(152,"ChargeRecord")
ClassMethod GetPrintCount(recordSheetId, type) As %String
{
	set count=0
	&sql(select count(RowId) into :count
		from CIS_AN.PrintLog
		where RecordSheet=:recordSheetId
		and Type=:type
	)
	
	quit count
}

}
