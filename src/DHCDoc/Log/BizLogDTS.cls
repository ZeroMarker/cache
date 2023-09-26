Class DHCDoc.Log.BizLogDTS Extends DHCDoc.Util.RegisteredObject
{

/// 前端插入
/// w ##class(DHCDoc.Log.BizLogDTS).JSBizLogDTSInsert(^tempqujian("JSBizLogDTSInsert"))
ClassMethod JSBizLogDTSInsert(BizLogDTSJson)
{
	s ^tempqujian("JSBizLogDTSInsert")=BizLogDTSJson
	k JSBizLogDTSArr
    d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(BizLogDTSJson,.JSBizLogDTSArr)
    s i=""
    for {
        s i=$O(JSBizLogDTSArr(i))
        q:(i="")
		s BizCode=$G(JSBizLogDTSArr(i,"BizCode"))
		s BizMainId=$G(JSBizLogDTSArr(i,"BizMainId"))
		s BizId=$G(JSBizLogDTSArr(i,"BizId"))
		s BizJson=$G(JSBizLogDTSArr(i,"BizJson"))
		s UserCode=$G(JSBizLogDTSArr(i,"UserCode"))
		s BizDate=$G(JSBizLogDTSArr(i,"BizDate"))
		s BizTime=$G(JSBizLogDTSArr(i,"BizTime"))
		s rtn=##class(BSP.SYS.SRV.BizLog4DTS).Insert(BizCode, BizMainId, BizId , BizJson , UserCode , BizDate , BizTime)
    }
    q 0
}

/// 后端插入
ClassMethod BizLogDTSInsert(BizCode, BizMainId, BizId, BizJson, UserCode, BizDate, BizTime)
{
	s rtn=##class(BSP.SYS.SRV.BizLog4DTS).Insert(BizCode, BizMainId, BizId , BizJson , UserCode , BizDate , BizTime)
	q 0
}

}
