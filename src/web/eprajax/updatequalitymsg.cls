Class web.eprajax.updatequalitymsg Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s ARecipientID = $Get(%request.Data("ARecipientID",1),"-1")
	s AReadUserID = $Get(%request.Data("AReadUserID",1),"-1")
	s Action = $Get(%request.Data("Action",1),"-1")
	
	if (Action = "exe")
	{
		s Ret = ##class(EPRservice.Quality.DataAccess.BOQualityMessage).UpdateMessageDone(ARecipientID,AReadUserID)
		w Ret
	}
	else
	{
		s Ret = ##class(EPRservice.Quality.DataAccess.BOQualityMessage).UpdateMessageRecipient(ARecipientID,AReadUserID)
		w Ret
	}
	q $$$OK
}

}
