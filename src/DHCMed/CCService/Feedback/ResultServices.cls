/// <H3>功能：监控结果明细查询</H3>
/// <H4>创建者：李阳</H4>
/// <H4>创建日期：2012-07-06</H4>
Class DHCMed.CCService.Feedback.ResultServices Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod BuildData(objResult As DHCMed.CC.CtlResult)
{
	New (objResult)
	
	Set $ZT="BuildDataErr"
	
	Quit:(+objResult.Score)<1 ""
	
	Set Data=$lb("")
 	Set $li(Data,1)=objResult.EpisodeID //EpisodeID:%String
 	Set $li(Data,2)=objResult.%Id() //CtlResultID:%String
 	Set ActDate=objResult.ActDate
 	Set $li(Data,3)=$zd(+ActDate,3) //ActDate:%String:日期
 	Set ActTime=objResult.ActTime
	Set $li(Data,4)=$zt(+ActTime,1)  //ActTime:%String:时间
	Set RecordDate=objResult.RecordDate
 	Set $li(Data,5)=$zd(+RecordDate,3) //RecDate:%String:记录日期
 	Set $li(Data,6)=objResult.ItemId //ItemId:%String
 	Set $li(Data,7)=objResult.Summary //Summary:%String:摘要信息
 	Set $li(Data,8)=objResult.DataValue //DataValue:%String:数据值
 	Set $li(Data,9)=objResult.ObjectID //ObjectID:%String
 	
 	//操作人员
 	Set $li(Data,10)=objResult.UserID //UserID:%String
 	Set objUser=##class(DHCMed.Base.SSUser).GetObjById(objResult.UserID)
 	If $IsObject(objUser) {
	 	Set $li(Data,11)=objUser.Name //UserName:%String
	} Else {
		Set $li(Data,11)=""
	}
 	
 	Set $li(Data,12)=objResult.SubjectID //SubjectID:%String
 	Set $li(Data,13)=objResult.Score //Score:%String:分数
 	Set $li(Data,14)=objResult.IsAbsolute //IsAbsolute:%String:是否绝对项目
 	
 	//关键字
 	Set objKeyword=##class(DHCMed.CC.KeyWord).GetObjById(objResult.KeyWord)
 	If $IsObject(objKeyword) {
	 	Set $li(Data,15)=objKeyword.Description //KeyWord:%String
	} Else {
		Set $li(Data,15)=""
	}
	
 	Set $li(Data,16)=objResult.IsSensitive //IsSensitive:%String:是否敏感项目
 	Set $li(Data,17)=objResult.IsSpecificity //IsSpecificity:%String:是否特异性项目
 	
 	Set objSubCat=$$GetSubCatBySubjectItm(objResult.ItemId)
 	Set $li(Data,18)=objSubCat.ISCDesc
 	
	Quit Data
	
BuildDataErr
	Quit ""
	
GetSubCatBySubjectItm(ItemId)
	n (ItemId)
	Set objItm=##class(DHCMed.CC.SubjectItm).GetObjById(ItemId)
	Do objItm.%Close()
	Set objItmDic=##class(DHCMed.CC.ItemDic).GetObjById(objItm.ItemDic)
	Do objItmDic.%Close()
	Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(objItmDic.IDSubCatDr)
	Do objSubCat.%Close()
	Quit objSubCat
}

/// <H3>功能：通过监控日期查询监控明细</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>FromDate</B>：自动监控的开始日期</LI>
/// <LI><B>ToDate</B>：自动监控的结束日期</LI>
/// <LI><B>EpisodeID</B>：就诊ID，PAADM</LI>
/// <LI><B>SubjectID</B>：监控主题ID</LI>
/// <LI><B>IsSensitive</B>：是否敏感性指标，1-是 0-否  空-查所有</LI>
/// <LI><B>IsSpecificity</B>：是否特异性指标，1-是 0-否  空-查所有</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <OL>
/// <LI>EpisodeID:%String</LI>
/// <LI>CtlResultID:%String</LI>
/// <LI>ActDate:%String:日期</LI>
/// <LI>ActTime:%String:时间</LI>
/// <LI>RecDate:%String:记录日期</LI>
/// <LI>ItemId:%String</LI>
/// <LI>Summary:%String:摘要信息</LI>
/// <LI>DataValue:%String:数据值</LI>
/// <LI>ObjectID:%String</LI>
/// <LI>UserID:%String</LI>
/// <LI>UserName:%String</LI>
/// <LI>SubjectID:%String</LI>
/// <LI>Score:%Float:分数</LI>
/// <LI>IsAbsolute:%String:是否绝对项目</LI>
/// </OL>
/// <H4>实例</H4>
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.ResultService","qryCtlResult","2012-09-15","2012-09-17",4403342,1,"",1,"")
Query qryCtlResult(FromDate As %String, ToDate As %String, EpisodeID As %String, SubjectID As %String, IsSensitive As %String, IsSpecificity As %String, MinScore As %String = 0, LnkFeedBackIDs As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,CtlResultID:%String,ActDate:%String:日期,ActTime:%String:时间,RecDate:%String:记录日期,ItemId:%String,Summary:%String:摘要信息,DataValue:%String:数据值,ObjectID:%String,UserID:%String,UserName:%String,SubjectID:%String,Score:%Float:分数,IsAbsolute:%String:是否绝对项目,KeyWord:%String,IsSensitive:%String:是否敏感项目,IsSpecificity:%String:是否特异性项目,SubCatTitle:%String:子类名称")
{
}

ClassMethod qryCtlResultExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, EpisodeID As %String, SubjectID As %String, IsSensitive As %String, IsSpecificity As %String, MinScore As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set IsSensitive=$g(IsSensitive)
	Set IsSpecificity=$g(IsSpecificity)
	Set MinScore=+$g(MinScore)
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Quit:(FromDate="")||(ToDate="") $$$OK
	
	For tmpDate=FromDate:1:ToDate {
		Set ResultID=""
		For {
			Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",tmpDate,EpisodeID,SubjectID,ResultID))
			Quit:ResultID=""
			
			Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
			Continue:'$IsObject(objResult)
			Continue:((objResult.IsSensitive'=IsSensitive)&&(IsSensitive'=""))
			Continue:((objResult.IsSpecificity'=IsSpecificity)&&(IsSpecificity'=""))
			Continue:((objResult.Score<=MinScore))
			
			Set Data=..BuildData(objResult)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod qryCtlResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = qryCtlResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod qryCtlResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = qryCtlResultExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// <H3>功能：通过监控日期查询监控明细</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>FromDate</B>：自动监控的开始日期</LI>
/// <LI><B>ToDate</B>：自动监控的结束日期</LI>
/// <LI><B>EpisodeID</B>：就诊ID，PAADM</LI>
/// <LI><B>SubjectID</B>：监控主题ID</LI>
/// <LI><B>IsSensitive</B>：是否敏感性指标，1-是 0-否  空-查所有</LI>
/// <LI><B>IsSpecificity</B>：是否特异性指标，1-是 0-否  空-查所有</LI>
/// <LI><B>MinScore</B>:每个项目最低多少分，默认值是0，也就是说要隐藏0分（0分的项目通常用于统计）的项目</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <OL>
/// <LI>EpisodeID:%String</LI>
/// <LI>CtlResultID:%String</LI>
/// <LI>ActDate:%String:日期</LI>
/// <LI>ActTime:%String:时间</LI>
/// <LI>RecDate:%String:记录日期</LI>
/// <LI>ItemId:%String</LI>
/// <LI>Summary:%String:摘要信息</LI>
/// <LI>DataValue:%String:数据值</LI>
/// <LI>ObjectID:%String</LI>
/// <LI>UserID:%String</LI>
/// <LI>UserName:%String</LI>
/// <LI>SubjectID:%String</LI>
/// <LI>Score:%Float:分数</LI>
/// <LI>IsAbsolute:%String:是否绝对项目</LI>
/// </OL>
/// <H4>实例</H4>
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.ResultService","qryCtlResultByEpisodeID",18897640,11,"","","","/121/")
Query qryCtlResultByEpisodeID(EpisodeID As %String, SubjectID As %String, IsSensitive As %String, IsSpecificity As %String, MinScore As %String, ItemIDs As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,CtlResultID:%String,ActDate:%String:日期,ActTime:%String:时间,RecDate:%String:记录日期,ItemId:%String,Summary:%String:摘要信息,DataValue:%String:数据值,ObjectID:%String,UserID:%String,UserName:%String,SubjectID:%String,Score:%Float:分数,IsAbsolute:%String:是否绝对项目,KeyWord:%String,IsSensitive:%String:是否敏感项目,IsSpecificity:%String:是否特异性项目,ActFlag:%String")
{
}

ClassMethod qryCtlResultByEpisodeIDExecute(ByRef qHandle As %Binary, EpisodeID As %String, SubjectID As %String, IsSensitive As %String, IsSpecificity As %String, MinScore As %String, ItemIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set IsSensitive=$g(IsSensitive)
	Set IsSpecificity=$g(IsSpecificity)
	Set MinScore=$g(MinScore)
	Set ItemIDs=$g(ItemIDs)
	Set ItemIDs="/"_ItemIDs_"/"
	
	Set ResultID=""
	For {
		Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexEpisodeSubject",EpisodeID,SubjectID,ResultID))
		Quit:ResultID=""
		
		Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
		Continue:'$IsObject(objResult)
		Set ItemId=objResult.ItemId
		Set xItemId="/"_ItemId_"/"
		Continue:(ItemIDs'="")&&(ItemIDs'[xItemId)
		Continue:((objResult.IsSensitive'=IsSensitive)&&(IsSensitive'=""))
		Continue:((objResult.IsSpecificity'=IsSpecificity)&&(IsSpecificity'=""))
		Continue:(objResult.Score'>MinScore) //过滤分数
		Set ActDate=objResult.ActDate
		Continue:ActDate=""
		Set ActFlag=(ActDate>=(+$h))
		
		Set Data=..BuildData(objResult)
		Continue:Data=""
		Set ^CacheTemp(repid,ind)=Data_$lb(ActFlag)
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod qryCtlResultByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = qryCtlResultByEpisodeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod qryCtlResultByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = qryCtlResultByEpisodeIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// <H3>功能:按关键字汇总监控结果</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>EpisodeID</B>:就诊号，Paadm</LI>
/// <LI><B>SubjectID</B>：监控主题ID</LI>
/// <LI><B>KeywordCode</B>：关键字代码,DHCMed.CC.KeyWord的Code字段</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <P>如果程序运行成功，返回结果字符串</P>
/// <P>格式：</P>
/// {数量}^{得分}
/// <H4>实例</H4>
/// w ##class(DHCMed.CCService.Feedback.ResultService).GetCtlResultSubTotalKeyWord(4,2,"InHospital")
ClassMethod GetCtlResultSubTotalKeyWord(EpisodeID As %String, SubjectID As %String, KeywordCode As %String) As %String
{
	New (EpisodeID,SubjectID,KeywordCode)
	Set return=""
	Quit:(EpisodeID="")||(SubjectID="")||(KeywordCode="") return
	
	Set KeywordCode=$ZConvert(KeywordCode,"U")
	Set KeywordID=$o(^DHCMed.CCi("Keyword","IndexCode"," "_KeywordCode,""))
	Quit:KeywordID="" return
	
	Set RowID=""
	For {
		Set RowID=$o(^DHCMed.CC.CtlResultI("Detail","IndexEpisodeKeyword",EpisodeID,SubjectID,KeywordID,RowID))
		Quit:RowID=""
		
		Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(RowID)
		Continue:'$IsObject(objResult)
		Set $p(return,"^",1)=$p(return,"^",1)+1
		Set $p(return,"^",2)=$p(return,"^",2)+objResult.Score
	}
	Quit return
}

/// <H3>功能:查询触发明细</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>EpisodeID</B>:就诊号，Paadm</LI>
/// <LI><B>SubjectID</B>：监控主题ID</LI>
/// <LI><B>ActDate</B>：记录日期，即监控日期。要求是Cache日期格式</LI>
/// <LI><B>IsSensitive</B>：是否敏感性指标，1-是 0-否  空-查所有</LI>
/// <LI><B>IsSpecificity</B>：是否特异性指标，1-是 0-否  空-查所有</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <P>如果程序运行成功，返回结果字符串</P>
/// <P>格式：</P>
/// {项目名称}^{触发用户}^{触发日期}^{触发时间}^{摘要}_$c(1){项目名称2}^{触发用户2}^{触发日期2}^{触发时间2}^{摘要2}
/// <H4>实例</H4>
/// w ##class(DHCMed.CCService.Feedback.ResultService).GetCtlResultSubTotal(4,2,"","",1)
ClassMethod GetCtlResultSubTotal(EpisodeID, SubjectID, ActDate, IsSensitive, IsSpecificity)
{
	New (EpisodeID,SubjectID,ActDate,IsSensitive,IsSpecificity)
	Set return=""
	
	Set:ActDate["-" ActDate=$zdh(ActDate,3)
	Set:ActDate["/" ActDate=$zdh(ActDate,4)
	
	Set RowID=""
	For {
		Set RowID=$o(^DHCMed.CC.CtlResultI("Detail","IndexEpisodeSubject",EpisodeID,SubjectID,RowID))
		Quit:RowID=""
		
		Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(RowID)
		Continue:'$IsObject(objResult)
		Continue:((objResult.IsSensitive'=IsSensitive)&&(IsSensitive'="")) //敏感性指标过滤
		Continue:((objResult.IsSpecificity'=IsSpecificity)&&(IsSpecificity'="")) //特异性指标过滤
		Continue:((objResult.ActDate'=ActDate)&&(ActDate'="")) //触发日期过滤
		
		Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(objResult.ItemId)
		Continue:'$IsObject(objItem)
		Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(objItem.ItemDic)
		Continue:'$IsObject(objItemDic)
		
		Set UserName=""
		Set objUser=##class(DHCMed.Base.SSUser).GetObjById(objResult.UserID)
		If $IsObject(objUser) {
			Set UserName=objUser.Name
		}
		
		Set tmp=objItemDic.IDDesc
		Set tmp=tmp_"^"_UserName
		Set tmp=tmp_"^"_$zd(objResult.ActDate,3)
		Set tmp=tmp_"^"_$zt(objResult.ActTime,1)
		Set tmp=tmp_"^"_objResult.Summary
		
		Set return=return_$c(1)_tmp
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
}

/// <H3>功能：查询监控结果汇总信息</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>EpisodeID</B>：就诊号，Paadm，必输项</LI>
/// <LI><B>SubjectID</B>：监控主题ID, DHCMed.CC.Subject的RowID，必输项</LI>
/// <LI><B>SubjectCode</B>：监控项目的代码，必输项</LI>
/// <LI><B>ActDateFrom</B>：触发日期开始，如果输入空字符串，则查询所有前三个条件的匹配项</LI>
/// <LI><B>ActDateTo</B>：触发日期结束，如果输入空字符串，则查询所有前三个条件的匹配项</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 字符串：格式：  触发数量^累计分数
/// <H4>备注</H4>
/// <OL>
/// <LI>各日期字段允许的格式包括：（1）Cache的日期格式</LI>
/// </OL>
ClassMethod GetCtlResultSummary(EpisodeID As %String, SubjectID As %Integer, SubjectCode As %String, ActDateFrom As %String, ActDateTo As %String) As %String
{
	New (EpisodeID,SubjectID,SubjectCode,ActDateFrom,ActDateTo)
	Set return=""
	Quit:(EpisodeID="")||(SubjectID="")||(SubjectCode="") return
	
	Set SubjectCode=" "_SubjectCode
	Set SubjectItemID=$o(^DHCMed.CCi("SItem",0,"SubjectCodeIndex",SubjectID,SubjectCode,""))
	Quit:SubjectItemID="" return
	
	Set ItmCnt=0 //触发数量
	Set ItmScore=0 //分数
	Set CtlResultRowID=""
	For {
		Set CtlResultRowID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectItemID",EpisodeID,SubjectItemID,CtlResultRowID))	
		Quit:CtlResultRowID=""
		
		Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(CtlResultRowID)
		Continue:'$IsObject(objResult)
		Continue:((objResult.ActDate<ActDateFrom)&&(ActDateFrom'=""))
		Continue:((objResult.ActDate>ActDateTo)&&(ActDateTo'=""))
		Set ItmCnt=ItmCnt+1
		Set ItmScore=ItmScore+objResult.Score
	}
	Set return=ItmCnt_"^"_ItmScore
	
	Quit return
}

/// s a=##class(DHCMed.CCService.Feedback.ResultService).GetCtlResultList(169,2,"","","")
ClassMethod GetCtlResultList(EpisodeID As %String, SubjectID As %Integer, SubjectItemIDList As %String, ActDateFrom As %String, ActDateTo As %String) As %ListOfObjects
{
	n (EpisodeID,SubjectID,SubjectItemIDList,SubjectCodeList,ActDateFrom,ActDateTo)
	Set objArry=##class(%ListOfObjects).%New()
	Do objArry.%Close()
	Quit:EpisodeID="" objArry
	
	Set SubjectItemIDList="/"_SubjectItemIDList_"/"
	Set CtlResultRowID=""
	For {
		Set CtlResultRowID=$o(^DHCMed.CC.CtlResultI("Detail","IndexEpisodeSubject",EpisodeID,SubjectID,CtlResultRowID))	
		Quit:CtlResultRowID=""
		
		Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(CtlResultRowID)
		Continue:'$IsObject(objResult)
		Continue:((objResult.ActDate<ActDateFrom)&&(ActDateFrom'=""))
		Continue:((objResult.ActDate>ActDateTo)&&(ActDateTo'=""))
		Continue:((objResult.SubjectID'=SubjectID)&&(SubjectID'="")) //主题不符
		Set tmpItemID="/"_objResult.ItemId_"/"
		Continue:((SubjectItemIDList'[tmpItemID)&&(SubjectItemIDList'="")) //监控项目ID不符
		Do objArry.Insert(objResult)
	}
	
	Quit objArry
}

/// 
/// <H3>通过关键字获取监控结果列表</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>EpisodeID</B>:就诊号，Paadm</LI>
/// <LI><B>SubjectID</B>：监控主题ID</LI>
/// <LI><B>KeywordCode</B>：关键字代码，可以参见DHCMed.CC.KeyWord类的代码</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <P>如果程序运行成功，返回结果集</P>
/// <P>内容类型：DHCMed.CC.CtlResult类的实例</P>
ClassMethod GetCtlResultListByKeyword(EpisodeID As %String, SubjectID As %Integer, KeywordCode As %String) As %ListOfObjects
{
	New (EpisodeID,SubjectID,KeywordCode)
	Set objArry=##class(%ListOfObjects).%New()
	Do objArry.%Close()
	Quit:EpisodeID="" objArry
	Quit:SubjectID="" objArry
	Quit:KeywordCode="" objArry
	
	Set KeywordCode=$ZConvert(KeywordCode,"U")
	Set KeywordID=$o(^DHCMed.CCi("Keyword","IndexCode"," "_KeywordCode,""))
	Quit:KeywordID="" objArry
	
	Set RowID=""
	For {
		Set RowID=$o(^DHCMed.CC.CtlResultI("Detail","IndexEpisodeKeyword",EpisodeID,SubjectID,KeywordID,RowID))
		Quit:RowID=""
		
		Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(RowID)
		Continue:'$IsObject(objResult)
		Do objArry.Insert(objResult)
	}
	Quit objArry
}

/// <H3>通过触发日期、关键字获取监控结果列表</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>SubjectID</B>：监控主题ID</LI>
/// <LI><B>KeywordCode</B>：关键字代码，可以参见DHCMed.CC.KeyWord类的代码</LI>
/// <LI><B>FromDate</B>：触发开始日期，Cache日期格式</LI>
/// <LI><B>ToDate</B>：触发结束日期，Cache日期格式</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <P>如果程序运行成功，返回结果集</P>
/// <P>内容类型：DHCMed.CC.CtlResult类的实例</P>
ClassMethod GetCtlResultByKeywordActDate(SubjectID As %String, KeywordCode As %String, FromDate As %Date, ToDate As %Date) As %ListOfObjects
{
	New (SubjectID,KeywordCode,FromDate,ToDate)
	Set objArry=##class(%ListOfObjects).%New()
	Do objArry.%Close()
	Quit:SubjectID="" objArry
	Quit:KeywordCode="" objArry
	
	Set KeywordCode=$ZConvert(KeywordCode,"U")
	Set KeywordID=$o(^DHCMed.CCi("Keyword","IndexCode"," "_KeywordCode,""))
	Quit:KeywordID="" objArry
	
	Set RowID=""
	For tmpDate=FromDate:1:ToDate {
		For {
			Set RowID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectKeyword",SubjectID,KeywordID,tmpDate,RowID))
			Quit:RowID=""
			
			Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(RowID)
			Continue:'$IsObject(objResult)
			Do objArry.Insert(objResult)
		}
	}
	Quit objArry
}

/// <H3>通过触发日期、关键字获取监控汇总</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>SubjectID</B>：监控主题ID</LI>
/// <LI><B>KeywordCode</B>：关键字代码，可以参见DHCMed.CC.KeyWord类的代码</LI>
/// <LI><B>FromDate</B>：触发开始日期，Cache日期格式</LI>
/// <LI><B>ToDate</B>：触发结束日期，Cache日期格式</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <P>如果程序运行成功，返回字符串</P>
/// <P>格式：{数量}^{分数}</P>
ClassMethod GetCtlSummaryByKeywordActDate(SubjectID As %String, KeywordCode As %String, FromDate As %Date, ToDate As %Date) As %String
{
	New (SubjectID,KeywordCode,FromDate,ToDate)
	Set return=""
	Quit:(SubjectID="")||(KeywordCode="") return
	
	Set KeywordCode=$ZConvert(KeywordCode,"U")
	Set KeywordID=$o(^DHCMed.CCi("Keyword","IndexCode"," "_KeywordCode,""))
	Quit:KeywordID="" return
	
	Set RowID=""
	For tmpDate=FromDate:1:ToDate {
		For {
			Set RowID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectKeyword",SubjectID,KeywordID,tmpDate,RowID))
			Quit:RowID=""
			
			Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(RowID)
			Continue:'$IsObject(objResult)
			Set $p(return,"^",1)=$p(return,"^",1)+1
			Set $p(return,"^",2)=$p(return,"^",2)+objResult.Score
		}
	}
	Quit return
}

/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.ResultService","QryCtlResultDtl","","")
Query QryCtlResultDtl(SummaryIDs As %String, FeedBackIDs As %String) As %Query(ROWSPEC = "EpisodeID:%String,CtlResultID:%String,ActDate:%String:日期,ActTime:%String:时间,RecDate:%String:记录日期,ItemId:%String,Summary:%String:摘要信息,DataValue:%String:数据值,ObjectID:%String,UserID:%String,UserName:%String,SubjectID:%String,Score:%Float:分数,IsAbsolute:%String:是否绝对项目,KeyWord:%String,IsSensitive:%String:是否敏感项目,IsSpecificity:%String:是否特异性项目,SubCatTitle:%String:子类名称,ActFlag:%String")
{
}

ClassMethod QryCtlResultDtlExecute(ByRef qHandle As %Binary, SummaryIDs As %String, FeedBackIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(SummaryIDs="")&&(FeedBackIDs="") $$$OK
	
	Set SummaryList=""
	
	If SummaryIDs'="" {
		For indSmy=1:1:$l(SummaryIDs,",") {
			Set SummaryID=$p(SummaryIDs,",",indSmy)
			Continue:SummaryID=""
			Set SummaryList=SummaryList_$lb(SummaryID)
		}
	}
	If FeedBackIDs'="" {
		For indFb=1:1:$l(FeedBackIDs,",") {
			Set FeedBackID=$p(FeedBackIDs,",",indFb)
			Continue:FeedBackID=""
			Set objFeedBack=##class(DHCMed.CC.CtlFeedback).GetObjById(FeedBackID)
			Continue:'$IsObject(objFeedBack)
			Set SummaryID=objFeedBack.CtlSummaryID
			Set SummaryList=SummaryList_$lb(SummaryID)
		}
	}
	Quit:SummaryList="" $$$OK
	Set SummaryID=$list(SummaryList,1)
	Quit:SummaryID="" $$$OK
	Set objSummary=##class(DHCMed.CC.CtlSummary).GetObjById(SummaryID)
	Quit:'$IsObject(objSummary) $$$OK
	Set EpisodeID=objSummary.EpisodeID
	Set SubjectID=objSummary.SubjectID
	
	Set ActDateList=""
	Set SummaryID=0
	For {
		Set SummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubject",EpisodeID,SubjectID,SummaryID))
		Quit:SummaryID=""
		Set objSummary=##class(DHCMed.CC.CtlSummary).GetObjById(SummaryID)
		Continue:'$IsObject(objSummary)
		Set ActDate=objSummary.ActDate
		Continue:ActDate=""
		Set LnkSummaryID=objSummary.LnkSummaryID
		If ($listfind(SummaryList,LnkSummaryID)>0)||($listfind(SummaryList,SummaryID)>0) {
			Set ActDateList=ActDateList_$lb(ActDate)
		}
	}
	
	Set ResultID=""
	For {
		Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexEpisodeSubject",EpisodeID,SubjectID,ResultID))
		Quit:ResultID=""
		
		Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
		Continue:'$IsObject(objResult)
		Set ActDate=objResult.ActDate
		Continue:ActDate=""
		Set ActFlag=($listfind(ActDateList,ActDate)>0)
		
		Set Data=..BuildData(objResult)
		Continue:Data=""
		Set ^CacheTemp(repid,ind)=Data_$lb(ActFlag)
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryCtlResultDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCtlResultDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCtlResultDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCtlResultDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##class(DHCMed.CCService.Feedback.ResultService).GetLabItemCat("L")
ClassMethod GetLabItemCat(LabOrderType As %String, UserID As %String) As %String
{
	New (LabOrderType,UserID)
	;^ARC("IC",0,"OrderType",{ARCIC_OrderType},{ARCIC_RowId})
	Set return=""
	Quit:LabOrderType="" return
	Quit:'$d(^ARC("IC",0,"OrderType",LabOrderType)) return
	
	Set LastQryType=$g(^DHCMedLabQry("LAB",UserID))	//取感染综合检查检验报告 用户最后一次查询条件
	
	Set rowid=""
	For {
		Set rowid=$o(^ARC("IC",0,"OrderType",LabOrderType,rowid))
		Quit:rowid=""
		
		Set flag=0
		Set ARCICDesc=$p($g(^ARC("IC",rowid)),"^",2)
		Set:(LastQryType'="")&&(LastQryType'="*")&&(LastQryType[("*"_rowid_"*")) flag=1
		Set:return'="" return=return_$c(1)_	rowid_$c(2)_ARCICDesc_$c(2)_flag
		Set:return="" return=rowid_$c(2)_ARCICDesc_$c(2)_flag
	}	
	
	Quit return
}

}
