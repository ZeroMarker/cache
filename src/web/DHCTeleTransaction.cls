Class web.DHCTeleTransaction Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 增加一条交易流水记录
ClassMethod Insert(TransactionId As %String, TransactionType As %String, RequestMsg As %String, ResponseMsg As %String, Status As %Integer, RecordType As %String, ErrorMsg As %String) As %String
{
	;d ##class(web.DHCTeleTransaction).Insert("","cancel","sendmsg","reqmsg",1,"request","ErrorMsg")

		//如果有改交易记录，返回该记录ID
		if (TransactionId'=""){
			s testTrans=..GetRowId(TransactionId)
			if (testTrans'=""){
				Quit testTrans
			}else{
			}
		}
		//...
		//...
		//...
		Set tId = TransactionId
		if (tId = "")
		{
			Set tId = ..GetTransactionId()
		}

		Set transaction = ##class(User.DHCTeleTransaction).%New()	
		Set transaction.TransactionId = tId
		Set transaction.TransactionType = TransactionType
		Set transaction.RecordType = RecordType
		If (RequestMsg '= "")
		{
			Do transaction.RequestMsg.Write(RequestMsg)
		}
		If (ResponseMsg '= "")
		{
			Do transaction.ResponseMsg.Write(ResponseMsg)
		}
		Set transaction.ErrorMsg = ErrorMsg
		Set transaction.TransactionDate = +$h
		Set transaction.TransactionStatus = Status		
		
		
		
		Set sc = transaction.%Save()
		if ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)	
			Quit ""
		}
		Quit tId
}

/// 更新交易流水记录
ClassMethod Update(TransactionId As %String, RequestMsg As %String, ResponseMsg As %String, Status As %Integer, ErrorMsg As %String) As %String
{
	;d ##class(web.DHCTeleTransaction).Update("0000000001","sendmsg","reqmsg",1,"ErrorMsg")
		Set rowId = ""
		Set rowId = ..GetRowId(TransactionId)
		if (rowId = "") Quit ""		
		
		Set transaction = ##class(User.DHCTeleTransaction).%OpenId(rowId)
		if (transaction) 
		{
			Set transaction.TransactionId = TransactionId
			//Set transaction.TransactionType = TransactionType
			If (RequestMsg '="")
			{
				Do transaction.RequestMsg.Clear()
				Do transaction.RequestMsg.Write(RequestMsg)
			}
			
			if (ResponseMsg '= "")
			{
				Do transaction.ResponseMsg.Clear()
				Do transaction.ResponseMsg.Write(ResponseMsg)
			}
						
			Set transaction.TransactionStatus = Status		
			Set transaction.ErrorMsg = ErrorMsg
						
			Set sc = transaction.%Save()
			if ($System.Status.IsError(sc))
			{
				Do $System.Status.DisplayError(sc)	
				Quit ""
			}
		}
		Quit TransactionId
}

/// 获取唯一流水号
ClassMethod GetTransactionId() As %String
{
		Set tId = ""
		Set rowId = +$i(^User.DHCTeleTransactionD.Unique("0"))
		for i=1:1:10-$length(rowId)
		{
			Set tId = tId_"0"	
		}
		Set tId = tId_rowId
		Quit tId
}

ClassMethod GetRowId(TransactionId As %String)
{
	if (TransactionId = "") Quit ""
	
	Quit $Order(^User.DHCTeleTransactionI("TransactionIndex"," "_TransactionId,0))
}

/// 取得指定交易类型的统计信息
ClassMethod GetTransInfoByType(TransactionType As %String, StartDate As %Date, EndDate As %Date) As %String
{
	;w ##class(web.DHCTeleTransaction).GetTransInfoByType("confirmRegistration")
	;cancelRegistration   取消预约
	;confirmRegistration  预约
	;SendOverdueInfo      违约
	;notifyGetNumber      取号
	;
	s n=0
	s TransactionIdStr=""
	&SQL(DECLARE OrdCursor CURSOR FOR
	 Select TT_TransactionId INTO :TransactionId From SQLUser.DHC_TeleTransaction
	 WHERE TT_TransactionDate>=:StartDate and TT_TransactionDate<=:EndDate and
	       TT_TransactionType=:TransactionType)
	 &SQL(OPEN OrdCursor)
	 For  &SQL(FETCH OrdCursor) QUIT:SQLCODE  do
	 .s n=n+1
	 .i TransactionIdStr="" s TransactionIdStr=TransactionId
	 .e  s TransactionIdStr=TransactionIdStr_","_TransactionId
	 &SQL(CLOSE OrdCursor)
	 Q n_"^"_TransactionIdStr
}

}
