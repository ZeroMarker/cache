/// Creator:李得原
/// CreatDate:2022-08-11
/// Description:数据中台访问日志接口
Class web.CDSS.MiddlePlatform.AccessLog [ Abstract ]
{

/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.MiddlePlatform.AccessLog","GetList","RecomLabExam","","","")
Query GetList(AccessGroup As %String, AccessType As %String, FromDate As %String = "", ToDate As %String = "") As %Query(ROWSPEC = "LogRowid,AccessUserName,AccessGroup,AccessIP,AccessTime,AccessTypeName,AccessTypeCn,IsError,Params,Result")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, AccessGroup As %String, AccessType As %String, FromDate As %String, ToDate As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    k ResultArray
    s KeyMap={"RecordQuality":"病历质控","RecordGender":"性别相关","SuspectedDisease":"推荐疑似疾病","RecommendDifferDiag":"鉴别诊断","OutHospital":"出院指导","OperationComplication":"手术并发症","OperationWarning":"手术预警","NursingWarning":"护理预警","RecommendNursing":"推荐护理措施","RecommendLabExam":"推荐检验检查","AssistTreat":"推荐治疗方案","RecomDocs":"推荐相关文献","RecomDiag":"推荐确诊","RecommendAssess":"推荐评估量表","LabExamWarning":"检验检查预警","DiseaseWarning":"疾病预警","DrugWarning":"药品预警","RecomAssessLog":"评估表评估记录","BloodWarning":"输血预警","AllergyWarning":"过敏预警","RecomNursingTreat":"推荐护理处置"}
	k GroupArray
	if (AccessGroup'="")
	{
		s LogRowid=""
		for
		{
			s LogRowid=$o(^WDT.CDSS.AccessLogI("GroupIndex"," "_$Zconvert(AccessGroup,"U"),LogRowid)) q:LogRowid=""
			s GroupArray(LogRowid)=""
		}
	}
	
	k TypeArray
	if (AccessType'="")
	{
		s LogRowid=""
		for
		{
			s LogRowid=$o(^WDT.CDSS.AccessLogI("TypeIndex"," "_$Zconvert(AccessType,"U"),LogRowid)) q:LogRowid=""
			s TypeArray(LogRowid)=""
		}
	}
	
	if $d(GroupArray)&($d(TypeArray))
	{
		s Rowid=""
		for
		{
			s Rowid=$o(GroupArray(Rowid)) q:Rowid=""
			if $d(TypeArray(Rowid))
			{
				s arr(Rowid)=""
			}
		}
	}
	elseif $d(GroupArray)
	{
		merge arr=GroupArray
	}
	elseif $d(TypeArray)
	{
		merge arr=TypeArray
	}
	
	if '$d(arr)
	{
		merge arr=^WDT.CDSS.AccessLogD
	}
	
	s LogRowid=""
	for
	{
		s LogRowid=$o(arr(LogRowid)) q:LogRowid=""
		s AccessUserName = $lg($g(^WDT.CDSS.AccessLogD(LogRowid)),2)
		s AccessGroupName = $lg($g(^WDT.CDSS.AccessLogD(LogRowid)),3)
		if AccessGroup'=""
		{
			continue:AccessGroupName'=AccessGroup
		}
		s AccessIP = $lg($g(^WDT.CDSS.AccessLogD(LogRowid)),4)
		s AccessTime = $lg($g(^WDT.CDSS.AccessLogD(LogRowid)),5)
		s AccessTypeName = $lg($g(^WDT.CDSS.AccessLogD(LogRowid)),6)
		if AccessType'=""
		{
			continue:AccessTypeName'=AccessType
		}
		s AccessTypeCn=KeyMap.%Get(AccessTypeName)
		s IsError = $lg($g(^WDT.CDSS.AccessLogD(LogRowid)),7)
		s Params = $lg($g(^WDT.CDSS.AccessLogD(LogRowid)),8)
		s Result = $lg($g(^WDT.CDSS.AccessLogD(LogRowid)),9)
		s AccessTime = $p(AccessTime,".",1)
		s AccessT = $zdth(AccessTime,3)
		s AccessTDate = $p(AccessT,",",1)
		s AccessTTime = $p(AccessT,",",2)
		if FromDate'=""
		{
			s FromT = $zdth(FromDate,3)
			s FromTDate = $p(FromT,",",1)
			s FromTTime = $p(FromT,",",2)
			continue:FromTDate>AccessTDate
			if (FromTDate=AccessTDate)&(FromTTime>AccessTTime)
			{
				continue
			}
		}
		if ToDate'=""
		{
			s ToT = $zdth(ToDate,3)
			s ToTDate = $p(ToT,",",1)
			s ToTTime = $p(ToT,",",2)
			continue:ToTDate<AccessTDate
			if (ToTDate=AccessTDate)&(ToTTime<AccessTTime)
			{
				continue
			}
		}
		s ResultArray(AccessTime)=$lb(LogRowid,AccessUserName,AccessGroupName,AccessIP,AccessTime,AccessTypeName,AccessTypeCn,IsError,Params,Result)
		
	}
	s Index=""
	for
	{
		s Index = $o(ResultArray(Index),-1) q:Index=""
		s LogRowid=$lg(ResultArray(Index),1)
		s AccessUserName=$lg(ResultArray(Index),2)
		s AccessGroupName=$lg(ResultArray(Index),3)
		s AccessIP=$lg(ResultArray(Index),4)
		s AccessTime=$lg(ResultArray(Index),5)
		s AccessTypeName=$lg(ResultArray(Index),6)
		s AccessTypeCn=$lg(ResultArray(Index),7)
		s IsError=$lg(ResultArray(Index),8)
		s Params=$lg(ResultArray(Index),9)
		s Result=$lg(ResultArray(Index),10)

		d OutputRow
	}
	
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(LogRowid,AccessUserName,AccessGroupName,AccessIP,AccessTime,AccessTypeName,AccessTypeCn,IsError,Params,Result)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

}
