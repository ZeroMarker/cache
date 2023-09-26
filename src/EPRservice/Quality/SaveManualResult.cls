/// Class Name:		EPRservice.Quality.SaveManualResult
/// Description:	与前台交互的服务
/// Creator:	    YHY
/// Create Date:	2016-12-28
Class EPRservice.Quality.SaveManualResult Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s ChangeData = $Get(%request.Data("ChangeData",1),"")
	s DelData = $Get(%request.Data("DelData",1),"")
	s SendDatas = $Get(%request.Data("SendDatas",1),"")
	s Action =  $Get(%request.Data("Action",1),"")
	if ChangeData '= ""
	{
		s ret = ..SaveResult(ChangeData)
	}
	if DelData '= ""
	{
		s ret = ..DelResult(DelData)
	}
	if SendDatas '= ""
	{
		
		s ret = ..SendResult(SendDatas,Action)
	}
	w ret
	Quit $$$OK
}

/// Creator:	    YHY
/// Create Date:	2016-12-28
/// Description:	保存手工评分条目
/// Return:         0：保存失败  1：保存成功
/// Debug:  d ##class(EPRservice.Quality.entryGrid).GetGridJson("1","297","323806",388,2738)
ClassMethod SaveResult(AChangeData As %String)
{
	q:AChangeData="" 0
	for count = 1:1:$l(AChangeData,"&")
	{
		s changedata = $p(AChangeData,"&",count)
		s ret = ##class(EPRservice.Quality.DataAccess.BOQualityResult).SaveManualResult(changedata)
	}
	q ret
}

/// Creator:	    YHY
/// Create Date:	2016-12-28
/// Description:	删除手工评分条目
/// Return:         0：删除失败  1：删除成功
/// Debug:  d ##class(EPRservice.Quality.entryGrid).GetGridJson("1","297","323806",388,2738)
ClassMethod DelResult(ADelData As %String)
{
	q:ADelData="" 0
	for count = 1:1:$l(ADelData,"&")
	{
		s deldata = $p(ADelData,"&",count)
		s ret = ##class(EPRservice.Quality.DataAccess.BOQualityResult).DeleteManualResult(deldata)
	}
	q ret
}

/// Creator:	    YHY
/// Create Date:	2016-12-28
/// Description:	发送消息
/// Return:         0：发送失败  1：发送成功
/// Debug:  w ##class(EPRservice.Quality.SaveManualResult).SendResult("主诉--主诉与现病史时间不一致^1^1^^9^2||1^^1^1^735^^undefined^S002","A")
ClassMethod SendResult(ASendDatas As %String, AAction As %String)
{
	s ret=0
	q:ASendDatas="" ret
	
	s SendData = ASendDatas
	for count = 1:1:$l(SendData,"&")
	{
	
		s senddata = $p(SendData,"&",count)
		//s senddata = senddata_"||"_Text
		s ResultDetailID = $p(senddata,"^",12)	
		s:(ResultDetailID="undefined") ResultDetailID=""
		s flag=0,MessageFlag=0
		
		if (ResultDetailID'="")
		{	
		    s MessageFlag=$d(^DHCEPRQ.EPRSingleMessageI("IdxResultDetailID"," "_ResultDetailID))
		    if (MessageFlag=10)
		    {
			   
			    s MessageID=""
				s MessageID=$o(^DHCEPRQ.EPRSingleMessageI("IdxResultDetailID"," "_ResultDetailID,MessageID),-1)
				s objMessage=##class(EPRinstance.EPRSingleMessage).%OpenId(MessageID)
				s flag=0
				
			    s:(objMessage.EffectiveFlag'="T") flag=1
				
		    }
		   
		    
		}
	
		continue:((MessageFlag=10)&&(flag=1))
		
		s ret = ##class(EPRservice.Quality.DataAccess.BOQualityMessage).CreateQualityMessagesToDoc(senddata,AAction)
	}
	q ret
}

}
