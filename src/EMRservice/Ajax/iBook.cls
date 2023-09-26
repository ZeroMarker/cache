Class EMRservice.Ajax.iBook Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s FileStream = ##class(%GlobalBinaryStream).%New()
	s count = 1
	s varname = %request.Next("")
	s Title = $g(%request.Data("Title",1),"")
	s Author = $g(%request.Data("Author",1),"")
	s Summary = $g(%request.Data("Summary",1),"")
	s UserParam = $g(%request.Data("UserInfo",1),"")
	s Category = $g(%request.Data("Category",1),"")
	d FileStream.CopyFrom(%request.GetMimeData("file",1))
	s UserID = $p(UserParam,"^",1)
	s UserLocID = $p(UserParam,"^",2)
	s SSGroupID = $p(UserParam,"^",3)
	s IPAdress = $p(UserParam,"^",4)
	TS
	s iBookID = ##class(EMRservice.BL.BLiBook).CreateiBook(Title,Author,Category,Summary,FileStream)
	if (iBookID=""){
		TRO
		w "-100_添加失败"
		q $$$OK
	}
	s LogID = ##class(EMRservice.BL.BLiBookLogs).AddLog("ADDFILE", UserID, UserLocID, SSGroupID, IPAdress, "IB"_iBookID)
	if (LogID = 0){
		TRO
		w "0_日志创建失败"
		q $$$OK
	}
	TC
	w "100_IB"_iBookID
	Quit $$$OK
}

}
