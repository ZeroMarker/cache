/// 名称:EMRservice.BL.BLiBook
/// 描述:联机文献功能文档业务
/// 编写者：Liuzhongwan
/// 编写日期: 2016-10-12
Class EMRservice.BL.BLiBook Extends %RegisteredObject
{

/// Desc:       添加文档
/// Creator:    Liuzhongwan	
/// CreateDate: 2016-10-12
/// Input:      ATitle 文档标题
/// 				AAuthor 文档作者
/// 				ACategory 文档所在目录ID
/// 				ASummary 文档摘要
/// 				AHtml Stream类型，文档的html代码流
/// Output:		若添加成功：新加记录的ID
/// 				添加失败：  0
/// Debug: w ##class(EMRservice.BL.BLiBook).CreateiBook("一篇文档","DHCC",1,"你瞅啥","")
ClassMethod CreateiBook(ATitle, AAuthor, ACategory, ASummary, AHtml As %GlobalCharacterStream) As %String
{
	s:(ACategory '= 0) ParentOBJ = ##class(EMRmeta.Repository.iBookCategory).%OpenId(ACategory)
	s ParentOBJ.ResChildCount = ParentOBJ.ResChildCount+1
	s iBOBJ = ##class(EMRmeta.Repository.iBook).%New()
	s iBOBJ.CategoryID = ACategory
	s iBOBJ.DocumentType = "EMR"
	s iBOBJ.Name = ATitle
	s iBOBJ.Author = AAuthor
	s iBOBJ.Summary = ASummary
	d iBOBJ.Document.CopyFrom(AHtml)
	s iBOBJ.CreateDate = $p($h,",",1)
	s iBOBJ.CreateTime = $p($h,",",2)
	s sc=iBOBJ.%Save()
	q:$$$ISERR(sc) 0
	s sc=ParentOBJ.%Save()
	q:$$$ISERR(sc) 0
	q iBOBJ.%Id()
}

/// Desc:       删除文档
/// Creator:    Liuzhongwan	
/// CreateDate: 2016-10-12
/// Input:      AiBookID 文档ID
/// Output:		若删除成功：1
/// 				删除失败：  0
/// Debug: w ##class(EMRservice.BL.BLiBook).DeleteiBook(1)
ClassMethod DeleteiBook(AiBookID) As %String
{
	q:(AiBookID = "") "0"
	s iBOBJ = ##class(EMRmeta.Repository.iBook).%OpenId(AiBookID)
	q:(iBOBJ = "") "0"
	s parentID = iBOBJ.CategoryID
	if (parentID = "0"){
		s sc=##class(EMRmeta.Repository.iBook).%DeleteId(AiBookID)
		q:$$$ISERR(sc) 0
	}else{
		s ParentOBJ = ##class(EMRmeta.Repository.iBookCategory).%OpenId(parentID)
		s ParentOBJ.ResChildCount = ParentOBJ.ResChildCount - 1
		s sc=ParentOBJ.%Save()
		q:$$$ISERR(sc) 0
		s sc=##class(EMRmeta.Repository.iBook).%DeleteId(AiBookID)
		q:$$$ISERR(sc) 0
	}
	q "1"
}

/// Desc:       获取文件内容
/// Creator:    Liuzhongwan	
/// CreateDate: 2016-10-12
/// Input:      AiBookID 文档ID
/// Output:		指定ID文档的内容流
/// Debug: w ##class(EMRservice.BL.BLiBook).GetContentsByID(10)
ClassMethod GetContentsByID(AiBookID)
{
	s iBOBJ = ##class(EMRmeta.Repository.iBook).%OpenId(AiBookID)
	while 'iBOBJ.Document.AtEnd{
		s value =  iBOBJ.Document.Read(2100)
		s value = $zcvt(value,"I","UTF8")
		w value
	}
}

ClassMethod OutPutContentsByID(AiBookID) As %GlobalBinaryStream
{
	s iBOBJ = ##class(EMRmeta.Repository.iBook).%OpenId(AiBookID)
	q iBOBJ.Document
}

/// Desc:       获取文件标题
/// Creator:    Liuzhongwan	
/// CreateDate: 2016-10-12
/// Input:      AiBookIDs 文档ID表
/// Output:		指定ID的标题，多个ID的情况下以^隔开
/// Debug: w ##class(EMRservice.BL.BLiBook).GetItemTitles("36,38,39")
ClassMethod GetItemTitles(AiBookIDs) As %String
{
	s titles = ""
	q:(AiBookIDs = "") titles
	s i=1
	s length = $l(AiBookIDs,",")
	while(i<=length)
	{
		s iBookID = $p(AiBookIDs,",",i)
		s title = $lg(^DHCEMRM.iBookD(iBookID),4)
		s:(titles'="") titles = titles_"^"
		s titles = titles_title
		s i = i+1
	}
	q titles
}

/// Desc:       添加文档主逻辑
/// Creator:    Liuzhongwan	
/// CreateDate: 2016-10-12
/// Input:      AiBookID 文档ID
/// Output:		指定ID文档的内容流
/// Debug: w ##class(EMRservice.BL.BLiBook).AddiBook("第一篇文档","DHCC",7,"你瞅啥","<html><head></head><body>你瞅啥</body></html>","359^6^29^192.168.1.63")
ClassMethod AddiBook(ATitle, AAuthor, ACategory, ASummary, AHtml, AUserParam)
{
	s UserID = $p(AUserParam,"^",1)
	s UserLocID = $p(AUserParam,"^",2)
	s SSGroupID = $p(AUserParam,"^",3)
	s IPAdress = $p(AUserParam,"^",4)
	s htmlStream = ##class(%GlobalCharacterStream).%New()
	d htmlStream.Write(AHtml)
	TS
	//添加文档
	s iBookID = ..CreateiBook(ATitle, AAuthor, ACategory, ASummary, htmlStream)
	TRO:(iBookID="")
	q:(iBookID="") ""
	//操作日志
	s LogID = ##class(EMRservice.BL.BLiBookLogs).AddLog("ADDFILE", UserID, UserLocID, SSGroupID, IPAdress, "IB"_iBookID)
	TRO:(LogID = 0)
	q:(LogID = 0) ""
	TC
	q "100_IB"_iBookID
}

/// 删除文档主逻辑
/// w ##class(EMRservice.BL.BLiBook).RemoveiBook(1,"359^6^29^192.168.1.63")
ClassMethod RemoveiBook(AiBookID, AUserParam)
{
	s UserID = $p(AUserParam,"^",1)
	s UserLocID = $p(AUserParam,"^",2)
	s SSGroupID = $p(AUserParam,"^",3)
	s IPAdress = $p(AUserParam,"^",4)
	TS
	//移除关联项目
	//s linkresult = ##class(EMRservice.BL.BLiBookLink).DeleteiBkBLink(AiBookID, "",-1)
	s linkresult = ##class(EMRservice.BL.BLiBookLink).DeleteiBLink(AiBookID, "",-1)
	TRO:(linkresult = 0)
	q:(linkresult = 0) ""
	//删除文档
	s deleteresult = ..DeleteiBook(AiBookID)
	TRO:(deleteresult = 0)
	q:(deleteresult = 0) ""
	//操作日志
	s LogID = ##class(EMRservice.BL.BLiBookLogs).AddLog("DELFILE", UserID, UserLocID, SSGroupID, IPAdress, "IB"_AiBookID) 
	TRO:(LogID = 0)
	q:(LogID = 0) ""
	TC
	q 1
}

/// w ##class(EMRservice.BL.BLiBook).GetiBooks(1)
ClassMethod GetiBooks(ACategoryID) As %String
{
	s json = ""
	q:(ACategoryID = "") json
	s iBookID = ""
	for
	{
		s iBookID = $o(^DHCEMRM.iBookI("IdxCategoryID", " "_ACategoryID, iBookID))
		q:(iBookID = "")
		s:(json'="") json = json_","
		s json = json_..GetiBookInfoByID(iBookID)
	}
	q json
}

ClassMethod GetiBookInfoByID(AiBookID)
{
	s iBookJson = ""
	q:(AiBookID = "") iBookJson
	s iBOBJ = ##class(EMRmeta.Repository.iBook).%OpenId(AiBookID)
	q:(iBOBJ = "") iBookJson
	s iBookJson = iBookJson_"{""id"":"_"""IB"_AiBookID_""""
	s iBookJson = iBookJson_",""text"":"_""""_iBOBJ.Name_""""
	s iBookJson = iBookJson_",""attributes"":{""author"":"_""""_iBOBJ.Author_""""
	s iBookJson = iBookJson_",""summary"":"_""""_iBOBJ.Summary_"""}}"
	q iBookJson
}

/// Desc:       获取关联指定节点的文献ID
/// Creator:    Liuzhongwan	
/// CreateDate: 2016-10-12
/// Input:      AItemID 关联节点ID
///             AType 关联节点类型
/// Output:		该知识库绑定的所有文献ID
/// Debug:      w ##class(EMRservice.BL.BLiBook).GetiBookIDByLinkID(7,"KBNode")
ClassMethod GetiBookIDByLinkID(AItemID, AType) As %String
{
		s result = ""
		q:(AItemID = "") result
		s AType = $zcvt(AType,"u")
		s iBookID = ""
		s LinkID = ""
		for
		{
			s LinkID = $o(^DHCEMRM.iBookItemLinkI("IdxLinkItemID", " "_AType, " "_AItemID, LinkID))
			q:(LinkID = "")
			s LinkOBJ = ##class(EMRmeta.Repository.iBookItemLink).%OpenId(LinkID)
			q:(LinkOBJ = "")
			s iBookID = LinkOBJ.iBookID
			s:(result '= "") result = result_","
			s result = result_iBookID
		}
		q result
}

/// d ##class(EMRservice.BL.BLiBook).demo("C:\Users\ztnioqE\Desktop\手册.html")
ClassMethod demo(argFile As %String) As %String
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	/*s count = 1
	while 'Stream.AtEnd {
		s ^liuzhongwan(count) = Stream.Read(32767)
		s count = count+1
	}
	s ^liuzhongwan = Stream.SizeGet()*/
	//s htmlStream = ##class(%GlobalCharacterStream).%New()
	w ..CreateiBook("手册","DHCC",1,"传进去",Stream)
	quit
}

}
