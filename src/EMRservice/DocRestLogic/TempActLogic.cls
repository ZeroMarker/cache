/// Creator: guozongtao
/// CreatDate: 2014-1-7
/// Description：新框架模板权限中 打印模板 或 挂靠界面模板的目录 的处理类
Class EMRservice.DocRestLogic.TempActLogic Extends %RegisteredObject
{

/// Creator: guozongtao
/// CreatDate: 2014-1-7
/// Description：判断某一个DocID(打印模板 或 挂靠界面模板的目录)是否适用于指定的病人
/// Table:
/// Input: parDocID--打印模板 或 挂靠界面模板的目录的ID; parPatInfo--病人信息列表（如 科室、性别等）;  parAction--操作类型，现在只有查看（这个没用）
/// Output:
/// Return: 1--适用  0--不适用
ClassMethod CanTempAct(parDocId As %String, parAction As %String, parPatInfo As %Library.List) As %Status
{
	q:(($d(parDocId)=0) || (parDocId = "")) 0
 	q:(($d(parAction)=0) || (parAction = "")) 0
 	q:(($d(parPatInfo)=0) || (parPatInfo = "")) 0
	s privResult = 0
 	//取出模板所属的规则
 	set argDocID = " "_parDocId
 	set groupID = ""
 	for 
 	{
		set groupID = $o(^DHCEMRM.DocRes.DocsInGroupI("DocIDIdx",argDocID,groupID)) //注：此处取得的 groupID 在左侧含有空格
		q:(groupID="")
		
		//遍历该模板组下的规则，校验是否有规则适合
		s restrictionId = ""
		s restrictionId = $o(^DHCEMRM.DocRes.DocRestrictionI("GroupIDIdx",groupID,restrictionId))
		WHILE (restrictionId '= "") 
		{
			s tempPrivResult = ..CheckPriv(restrictionId, parPatInfo)
			if (tempPrivResult =  1)
			{
				s privResult = 1
				q
			}
	  		s restrictionId = $o(^DHCEMRM.DocRes.DocRestrictionI("GroupIDIdx",groupID,restrictionId))
		}
		q:(privResult =  1)

 	}
 	q privResult
}

/// Creator: guozongtao
/// CreatDate: 2014-1-7
/// Description：判断当前病人是否符合某一条规则（parRestrictionId指定的规则）
/// Table:
/// Input: parRestrictionId--规则的配置串(如 PATDEPT:129^PATTYPE:19); parPatInfo--病人信息列表（如 科室、性别等）;
/// Output:
/// Return: 1--符合  0--不符合
ClassMethod CheckPriv(parRestrictionId As %String, parPatInfo As %Library.List) As %Status
{
	q:(($d(parRestrictionId)=0) || (parRestrictionId = "")) 0
 	q:(($d(parPatInfo)=0) || (parPatInfo = "")) 0
 	
 	//取出规则中的条件
 	s restrictionCondition = $lg(^DHCEMRM.DocRes.DocRestrictionD(parRestrictionId), 3)
	q:(restrictionCondition = "") 0
	
	s:(restrictionCondition'["SSLAN") restrictionCondition = restrictionCondition_"^SSLAN:CH"
	
 	//根据规则的类型组合数据去判断权限的有效性
 	s privResult = 1
 	for i=1:1:$l(restrictionCondition,"^")
 	{
		s curType = $p(restrictionCondition,"^",i)
		s curTypeColumn = $p(curType,":",1)
		
		//20110221 wangwnetao add
		s curTypeKeyword = $p(curType,":",2) ,curTypeKeywordValue=""
		i curTypeKeyword = "PRIVLINK" {
			s curTypeKeywordValue=##CLASS(EMRservice.BL.BLCustomDictionary).GetCtmDictLinkByCode("PrivLink")	
		}
		//20110221 wangwnetao end
		
		s cutTypeValue = ..GetTypeValue(curTypeColumn,parPatInfo)
		s privActivity = ..CheckPrivTypeValue(curTypeColumn,cutTypeValue,curType,curTypeKeywordValue)
		if (privActivity = 0)
		{
		  s privResult = 0
		  q
		}
	}
	
	q privResult
}

/// Creator: guozongtao
/// CreatDate: 2014-1-7
/// Description：取出病人某一个单项的数据
/// Table:
/// Input: parType--规则单项的类型(如 PATDEPT); parPatInfo--病人信息的列表
/// Output:
/// Return: 1--符合  0--不符合
ClassMethod GetTypeValue(parType As %String, parPatInfo As %Library.List) As %String
{
	q:(($d(parType)=0) || (parType = "")) ""
	
	s data = ""
	
	for j=1:1:$ll(parPatInfo) 
	{
		s PIItem=$li(parPatInfo,j)
		if ($p(PIItem,$c(2),1)=parType) 
		{
			s data=$p(PIItem,$c(2),2)
			quit
		}
	}
	
	q data
}

/// Creator: guozongtao
/// CreatDate: 2014-1-7
/// Description：判断规则串中某一个单项是否与病人的信息相符
/// Table:
/// Input: parTypeColumn--规则单项的类型(如 PATDEPT); parTypeValue--病人对应此规则单项的数据(如123)  parConditionValue--规则中对应此规则的类型与数据组合（如 PATDEPT:123）;
/// 		
/// Output:
/// Return: 1--符合  0--不符合
ClassMethod CheckPrivTypeValue(parTypeColumn As %String, parTypeValue As %String, parConditionValue As %String, parKeywordValue As %String = "") As %Status
{
 	q:(($d(parConditionValue)=0) || (parConditionValue = "")) 0
 	
 	set curType = parTypeColumn_":"_parTypeValue
 	//20110221 wangwnetao add
 	s parConditionValueLink="",parKeywordValueSub="",Result=0
 	if (parKeywordValue'="")
 	{
	 	for i=1:1:$l(parKeywordValue,"^")
	 	{
		 	s parKeywordValueSub = $p(parKeywordValue,"^",i)
		 	s parConditionValueLink = $p(parConditionValue,":",1)_":"_parKeywordValueSub
		 	if (curType = parConditionValueLink)
		 	{
			 	s Result=1
			 	q
		 	}
	 	}
 	} 	
 	else
 	{
	 	s:(curType = parConditionValue) Result=1
 	}
 	//20110221 wangwnetao end
 	
 	//q:(curType = parConditionValue) 1
 	q Result
}

}
