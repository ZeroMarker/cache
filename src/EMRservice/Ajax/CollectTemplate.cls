Class EMRservice.Ajax.CollectTemplate Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"")
	s userID =  $Get(%request.Data("userID",1),"")
	s Id = $Get(%request.Data("Id",1),"")
	if (action = "AddCollect"){
		w ..AddCollect(userID,Id)
	}
	if (action = "removeCollect"){
	    w ..removeCollect(userID,Id)
	}
	Quit $$$OK
}

ClassMethod AddCollect(AuserID As %String, AID As %String) As %String
{
	q:(AuserID = ""||AID = "") -1
	s flag = ##class(EMRservice.BL.BLCollectTemplate).AddUserCollect(AuserID,AID)
	q flag
}

// 

ClassMethod removeCollect(AuserID As %String, AID As %String) As %String
{
	q:(AuserID = ""||AID = "") -1
	s flag = ##class(EMRservice.BL.BLCollectTemplate).removeUserCollect(AuserID,AID)
	q flag
}

}
