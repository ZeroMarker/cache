Class CHSSWeb.AfficheManageService Extends %RegisteredObject
{

ClassMethod List(Start, Limit)
{
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set end = start+limit
	
	s count = 0
	s flag=0
	s SetRowId=""
	s resultString =""
	Set json = ##class(Code.JsonObj).%New()
	
	
	s groupVsstr = "select * from CHSS.AfficheManage a "
	
	s tempGroupVs = ##class(%Library.ResultSet).%New()
	d tempGroupVs.Prepare(groupVsstr)
	d tempGroupVs.Execute()
	while(tempGroupVs.Next())
	{
		
		s AfficheRowId = tempGroupVs.Data("AfficheRowId")
		s Title = tempGroupVs.Data("Title")
		s Content = tempGroupVs.Data("Content")	
		s Accessory=tempGroupVs.Data("Accessory")
	    s DateOfUpdate=tempGroupVs.Data("DateOfUpdate")
		s ClickNum=tempGroupVs.Data("ClickNum")
		s UpMan=tempGroupVs.Data("UpMan")
		s Status=tempGroupVs.Data("Status")
		s CommunityCode=tempGroupVs.Data("CommunityCode")
		s Type=tempGroupVs.Data("Type")
		s tmp=AfficheRowId_"^"_Title_"^"_Content_"^"_Accessory_"^"_DateOfUpdate_"^"_ClickNum_"^"_UpMan_"^"_Status_"^"_CommunityCode
		;w tmp,!
		s count=count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		
	}
	d tempGroupVs.Close()
	s resultString=json.getJsonData("AfficheRowId^Title^Content^Accessory^DateOfUpdate^ClickNum^UpMan^Status^CommunityCode",count)
	k json 
	Quit resultString
}

ClassMethod insert(AfficheRowId, Title, Content, DateOfUpdate, ClickNum, UpMan, Status, CommunityCode)
{
	s count=0
	
	i AfficheRowId'="" d
	.s tempSet=##class(CHSS.AfficheManage).%OpenId(AfficheRowId)
	e  d
	.s tempSet=##class(CHSS.AfficheManage).%New()

	s tempSet.Title = Title
	s tempSet.Content = Content
	i DateOfUpdate '= "" d
	.s DateOfUpdate=$zd(DateOfUpdate,3)
	.s tempSet.DateOfUpdate = DateOfUpdate
	.
	s tempSet.ClickNum = ClickNum
	s tempSet.UpMan = UpMan
	s tempSet.Status = Status
	s tempSet.CommunityCode = CommunityCode
	
	s result=""
	s result=tempSet.%Save()
	
	s resultString=""
	i result="1" d
	.s resultString="{""success"":""true"",""info"":""数据保存成功！""}"
	e  d
	.s resultString="{""success"":""false"",""info"":""数据保存出错！""}"
	q resultString
}

ClassMethod delete(AfficheRowId)
{
	&sql(delete from CHSS.AfficheManage where %ID=:AfficheRowId)
	q SQLCODE
}

}
