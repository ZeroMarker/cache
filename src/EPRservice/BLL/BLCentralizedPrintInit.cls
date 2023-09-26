Class EPRservice.BLL.BLCentralizedPrintInit Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Desc:	集中打印数据初始化
/// Input：	
/// Output: 1-ok
/// 		-1-error
/// Note：	
/// 		01.	检查报告    
/// 			02.	检验报告
/// 			03.	医嘱单
/// 			04.	体温单
/// 			05.	住院证
/// 			06.	护理病历
/// 			07.	病历文书
/// 			08.	麻醉记录
/// 			09.	病理
/// 			10.	心电图
ClassMethod CentralizedPrintInit() As %String
{
	s count = ..CountItems()
	if (count = 10){
		q "1"
	}
	elseif (count = 0){
		s isOK = ..InsertAll()
		if (isOK = 0){
			q "1"
		}
		q "-1"
	}
	else{
		s isOK = ..CheckAndInsertItems()
		if (isOK = 0){
			q "1"
		}
		q "-1"		
	}
	q "-1"
}

ClassMethod InsertAll() As %Integer
{
	q:(..Insert("01", "检查报告", "1") = 0) 1
	q:(..Insert("02", "检验报告", "2") = 0) 2
	q:(..Insert("03", "医嘱单", "3") = 0) 3
	q:(..Insert("04", "体温单", "4") = 0) 4
	q:(..Insert("05", "住院证", "5") = 0) 5
	q:(..Insert("06", "护理病历", "6") = 0) 6
	q:(..Insert("07", "病历文书", "7") = 0) 7
	q:(..Insert("08", "麻醉记录", "8") = 0) 8
	q:(..Insert("09", "病理", "9") = 0) 9
	q:(..Insert("10", "心电图", "10") = 0) 10
	
	q 0
}

ClassMethod CheckAndInsertItems() As %Integer
{
	if (..CheckItemExit("01") = 0) q:(..Insert("01", "检查报告", "1") = 0) 1
	if (..CheckItemExit("02") = 0) q:(..Insert("02", "检验报告", "2") = 0) 2
	if (..CheckItemExit("03") = 0) q:(..Insert("03", "医嘱单", "3") = 0) 3
	if (..CheckItemExit("04") = 0) q:(..Insert("04", "体温单", "4") = 0) 4
	if (..CheckItemExit("05") = 0) q:(..Insert("05", "住院证", "5") = 0) 5
	if (..CheckItemExit("06") = 0) q:(..Insert("06", "护理病历", "6") = 0) 6
	if (..CheckItemExit("07") = 0) q:(..Insert("07", "病历文书", "7") = 0) 7
	if (..CheckItemExit("08") = 0) q:(..Insert("08", "麻醉记录", "8") = 0) 8
	if (..CheckItemExit("09") = 0) q:(..Insert("09", "病理", "9") = 0) 9
	if (..CheckItemExit("10") = 0) q:(..Insert("10", "心电图", "10") = 0) 10
	
	q 0
}

ClassMethod Insert(CategoryID As %String, CategoryDesc As %String, Sequence As %String) As %Integer
{
	&sql(insert into EPRmeta_CentralizedPrint.CentralizedPrintItem (CategoryID,CategoryDesc, Sequence) values (:CategoryID, :CategoryDesc, :Sequence))
	If (SQLCODE = 0) {
		q 1
	}
	else{
		q 0
	}
}

ClassMethod CountItems() As %Integer
{
	s count = 0
    &sql(SELECT COUNT(*) INTO :count 
        FROM EPRmeta_CentralizedPrint.CentralizedPrintItem)
    q count
}

ClassMethod CheckItemExit(CategoryID As %String) As %Integer
{
	s count = 0
    &sql(SELECT COUNT(*) INTO :count 
        FROM EPRmeta_CentralizedPrint.CentralizedPrintItem
        WHERE CategoryID = :CategoryID)
    q count
}

}
