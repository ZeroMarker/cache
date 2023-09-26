/// 名称: web.DHCCPW.Lib.EPRCheck
/// 描述: 临床路径关联项目,电子病历相关函数库
/// 编写者：zhufei
/// 编写日期: 2012-02-08
Class web.DHCCPW.Lib.EPRCheck Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCCPW.Lib.EPRCheck).Test()
ClassMethod Test()
{
	New
	
	/*
	Set %EpisodeID="77128"
	Set %StartDate=""
	Set %StartTime=""
	Set %EndDate=""
	Set %EndTime=""
	Set flg=##class(web.DHCCPW.Lib.EPRCheck).CheckEprTemplate("模板目录||55","","","")
	Set RtnCode=$list(flg,1)
	Write "RtnCode="_RtnCode,!
	If RtnCode=-999 {
		Write "ErrorCode="_$list(flg,2),!
	} Else {
		Set TitleList=$list(flg,2)
		For indTitle=1:1:$listlength(TitleList)
		{
			Set tmpTitle=$list(TitleList,indTitle)
			Write $list(tmpTitle,1)_" "_$list(tmpTitle,2)_" "_$zd($list(tmpTitle,3),3)_" "_$zt($list(tmpTitle,4),1),!
		}
	}
	
	Set flg=##class(web.DHCCPW.Lib.EPRCheck).CheckEprTemplate("模板目录||121","","","")
	Set RtnCode=$list(flg,1)
	Write "RtnCode="_RtnCode,!
	If RtnCode=-999 {
		Write "ErrorCode="_$list(flg,2),!
	} Else {
		Set TitleList=$list(flg,2)
		For indTitle=1:1:$listlength(TitleList)
		{
			Set tmpTitle=$list(TitleList,indTitle)
			Write $list(tmpTitle,1)_" "_$list(tmpTitle,2)_" "_$zd($list(tmpTitle,3),3)_" "_$zt($list(tmpTitle,4),1),!
		}
	}
	*/
	
	Set %EpisodeID="3876522"
	Set %StartDate=""
	Set %StartTime=""
	Set %EndDate=""
	Set %EndTime=""
	Set flg=##class(web.DHCCPW.Lib.EPRCheck).CheckSingleDataToV1("#{40||1-G-790-dbx49-T}","护理首页一般情况交流护士")
	Set RtnCode=$list(flg,1)
	Write "RtnCode="_RtnCode,!
	If RtnCode=-999 {
		Write "ErrorCode="_$list(flg,2),!
	} Else {
		Set TitleList=$list(flg,2)
		For indTitle=1:1:$listlength(TitleList)
		{
			Set tmpTitle=$list(TitleList,indTitle)
			Write $list(tmpTitle,1)_" "_$list(tmpTitle,2)_" "_$zd($list(tmpTitle,3),3)_" "_$zt($list(tmpTitle,4),1),!
		}
	}
	
	Quit "Test Over!"
}

/// Creator：     zhufei
/// CreatDate：   2012-02-16
/// Description:  判断电子病历模板是否保存
/// Table：       
/// Input：       aCategID       : "模板目录||"_模板目录ID
///               aDTFlag        : 做筛选条件的日期时间标识，Create表示创建时间，Happen表示发生时间，空值表示不使用日期时间做筛选条件
///               aTitleList     : 可重复模板需要通过标题过滤
///               aTitleSeparate :多个标题之间的分隔符,默认"^"
/// Return：      返回String
/// w ##class(web.DHCCPW.Lib.EPRCheck).CheckEprTemplate("模板目录||12","","","")
ClassMethod CheckEprTemplate(aCategID As %String, aDTFlag As %String = "", aTitleList As %String = "", aTitleSeparate As %String = "^") As %List
{
	New (aCategID,aDTFlag,aTitleList,aTitleSeparate,%EpisodeID,%StartDate,%StartTime,%EndDate,%EndTime)
	Set return=$lb(0,"")
	Set $ZT="CheckSingleTempErr"
	
	Set LnkItemList="",Count=0
	Set AEpisodeID=%EpisodeID
	Set ACategoryID=$p(aCategID,"||",2)
	Set ADTFlag=aDTFlag
	If ADTFlag=""
	{
		Set AStartDate=""
		Set AStartTime=""
		Set AEndDate=""
		Set AEndTime=""
	} Else {
		Set AStartDate=%StartDate
		Set AStartTime=%StartTime
		Set AEndDate=%EndDate
		Set AEndTime=%EndTime
	}
	
	Set TitleList=""
	If aTitleList'=""
	{
		Set:aTitleSeparate="" aTitleSeparate="^"
		For indTitle=1:1:$l(aTitleList,aTitleSeparate)
		{
			Set Title=$p(aTitleList,aTitleSeparate,indTitle)
			Set TitleList=TitleList_$lb(Title)
		}
	}
	
	Set ItemList = ##class(%Library.ResultSet).%New("EPRservice.BIL.BIToWMR:GetInstanceInfo")
    Do ItemList.Execute(AEpisodeID, ACategoryID, ADTFlag, AStartDate, AStartTime, AEndDate, AEndTime)
    While ItemList.Next() {
        Set Title=ItemList.Get("Title")
        Continue:(TitleList'="")&&($listfind(TitleList,Title)<1)
        Set CreateDate=ItemList.Get("CreateDate")
        Set CreateTime=ItemList.Get("CreateTime")
        Set HappenDate=ItemList.Get("HappenDate")
        Set HappenTime=ItemList.Get("HappenTime")
        Set InstanceID=ItemList.Get("InstanceDataID")
        Set Count=Count+1
        If Count<10 {
	        If aDTFlag="Happen"
	        {
	        	Set LnkItemList=LnkItemList_$lb($lb("InstanceID:"_InstanceID,Title,HappenDate,HappenTime))
	        } Else {
		    	Set LnkItemList=LnkItemList_$lb($lb("InstanceID:"_InstanceID,Title,CreateDate,CreateTime))
			}
        }
    }
    Do ItemList.%Close()
    
    Set return=$lb(Count,LnkItemList)
	Quit return
    
CheckSingleTempErr
	Set return=$lb(-999,$ZE)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-10-11
/// Description:  通过模板单元值判断是否完成病历填写
///               此方法只适用电子病历V1.0
/// Table：       
/// Input：       Input: "唯一模板单元","霍乱"
/// Return：      ret=-1：Error，ret=0：不包含，ret=1：包含
/// w ##class(web.DHCCPW.Lib.EPRCheck).CheckSingleDataToV1(单元Code)
ClassMethod CheckSingleDataToV1(argElCode As %String, argTitle As %String) As %List
{
	New (argElCode,argTitle,%EpisodeID,%StartDate,%StartTime,%EndDate,%EndTime)
	Set return=$lb(0,"")
	Quit:(argElCode="") return
	
	Set $ZT="CheckSingleDataToV1Err"
	ZN "EPR"
	Set EPRData=##class(DHC.EPR.FPInterface.ExportTable).GetItemDataValueV1ForStat(%EpisodeID,argElCode,0)
	ZN "WEBSOURCE"
	Set EPRData=$tr(EPRData,$c(13),"")
	Set EPRData=$tr(EPRData,$c(10),"")
	Set EPRData=$tr(EPRData,"/","")
	Set EPRData=$tr(EPRData,",","")
	Set EPRData=$tr(EPRData,"\","")
	Set EPRData=$tr(EPRData," ","")
	Quit:EPRData="" return
	
    Set return=$lb(1,$lb($lb("ElCode:"_argElCode,argTitle,+$h,$p($h,",",2))))
	Quit return
    
CheckSingleDataToV1Err
	Set return=$lb(-999,$ZE)
	Quit return
}

}
