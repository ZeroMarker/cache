/// Desc: 		新版电子病历完整性检查
/// Author:		Candy
/// CreateDate: 2014-09-11
Class EPRservice.Quality.EmrCheckRule.IntegrityCheck Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:		病历结构下病历是否完成
/// Creator:	Candy
/// CreateDate:	2014-9-26
/// Input:		AEpisodeID 就诊号
/// 			AStructID 质控结构ID
/// 			AActiongType 质控类型
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsDoneContent(4065871,365,"")
ClassMethod IsDoneContent(AEpisodeID As %String, AStructID As %String, AActionType As %String) As %String
{
	s result = "0^配置错误"
	q:(AEpisodeID = "")||(AStructID = "") result	
	s objStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(AStructID)
	q:(objStruct = "") result

	s flag = ##Class(EPRservice.Quality.CheckRule.Category).IsRightCatalog(AEpisodeID,AStructID)
	q:(flag '= "1") "1^不需要检查"
	s TemplateCategoryID = ""
	if ((objStruct.BindCategoryId = "")||(objStruct.BindCategoryId = $c(0)))
	{
		s UniqueKey = $i(^CacheTemp)
		k ^tempStructIdList(UniqueKey)
		s ^tempStructIdList(UniqueKey,AStructID) = ""
		s ParentID = ""
		for
		{
			s ParentID = $o(^tempStructIdList(UniqueKey,ParentID))
			q:((ParentID = "")||(TemplateCategoryID '= ""))
			s StructID = ""
			for
			{
				s StructID = $o(^DHCEPRM.QualityStructI("IdxParentId"," "_ParentID,StructID))	
				q:(StructID = "")
				s objStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(StructID)
				continue:(objStruct = "")
				continue:(objStruct.IsActive '= "Y")
				continue:((objStruct.BindCategoryId = "")||(objStruct.BindCategoryId = $c(0)))
				continue:(objStruct.Type '= "EMR")
				s TemplateCategoryID = objStruct.BindCategoryId
				q
			}
		}
	}
	else
	{
		s TemplateCategoryID = objStruct.BindCategoryId
		q:(objStruct.Type '= "EMR") result 
	}
	s result = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetSingleTempalteInfo(AEpisodeID,TemplateCategoryID,AActionType)
	q result
}

/// Desc:		病历结构下病历是否完成
/// Creator:	Candy
/// CreateDate:	2014-9-26
/// Input:		AEpisodeID 就诊号
/// 			AStructID 质控结构ID
/// 			AActiongType 质控类型
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsDoneContentNew(69,365,"")
ClassMethod IsDoneContentNew(AEpisodeID As %String, AStructID As %String, AActionType As %String) As %String
{
	s result = "0^配置错误"
	q:(AEpisodeID = "")||(AStructID = "") result
		
	s objStruct = ##Class(CT.MA.QC.QualityStruct).%OpenId(AStructID)

	q:(objStruct = "") result

	s flag = ##Class(EPRservice.Quality.CheckRule.Category).IsRightCatalogNew(AEpisodeID,AStructID)
	q:(flag '= "1") "1^不需要检查"
	s TemplateCategoryID = ""
	if ((objStruct.BindCategoryId = "")||(objStruct.BindCategoryId = $c(0)))
	{
		s UniqueKey = $i(^CacheTemp)
		k ^tempStructIdList(UniqueKey)
		s ^tempStructIdList(UniqueKey,AStructID) = ""
		s ParentID = ""
		for
		{
			s ParentID = $o(^tempStructIdList(UniqueKey,ParentID))
			q:((ParentID = "")||(TemplateCategoryID '= ""))
			s StructID = ""
			for
			{
				s StructID = $o(^CT.MA.QC.QualityStructI("IdxParentId"," "_ParentID,StructID))	
				q:(StructID = "")
				s objStruct = ##Class(CT.MA.QC.QualityStruct).%OpenId(StructID)
				continue:(objStruct = "")
				continue:(objStruct.IsActive '= "Y")
				continue:((objStruct.BindCategoryId = "")||(objStruct.BindCategoryId = $c(0)))
				s TemplateCategoryID = objStruct.BindCategoryId
				q
			}
		}
	}
	else
	{
		
		s TemplateCategoryID = objStruct.BindCategoryId
		 
	}
	
	s result = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetSingleTempalteInfo(AEpisodeID,TemplateCategoryID,AActionType)
	
	q result
}

/// Desc: 		病历是否完成(只要有一个完成算完成)
/// Creator:	Candy
/// CreateDate:	2014-9-26
/// InPut:		AEpisodeID 就诊号
/// 			AStructID 结构IDs多个以"^"分隔
/// 			AActionType 质控类型
/// 			ALocIDs 质控科室 多个以"^"分隔
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsDoneContent0(76,13,"")
ClassMethod IsDoneContent0(AEpisodeID As %String, AStructIDs As %String, AActionType As %String, ALocIDs As %String = "") As %String
{
	q:(AEpisodeID = "")||(AStructIDs = "") "0^参数异常!"
	if (ALocIDs '= "")
	{
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		q:(curAdmitLocID = "") "0^患者当前不属于任何一个科室,质控项目异常退出!"
		
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		q:($listfind(locIDs,curAdmitLocID) > 0) "1^患者当前所在科室不采用该质控项目,正常退出!"
	
	}
	s result = "-1"
	s count = $l(AStructIDs,"^")
	for I=1:1:count
	{
		s StructID = $p(AStructIDs,"^",I)
		s result = ..IsDoneContent(AEpisodeID,StructID,AActionType)
		q:($p(result,"^",1) '= "1")
	}
	q result
}

/// Desc: 		病历是否完成(只要有一个完成算完成)
/// Creator:	Candy
/// CreateDate:	2014-9-26
/// InPut:		AEpisodeID 就诊号
/// 			AStructID 结构IDs多个以"^"分隔
/// 			AActionType 质控类型
/// 			ALocIDs 质控科室 多个以"^"分隔
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsDoneContent1(76,13,"")
ClassMethod IsDoneContent1(AEpisodeID As %String, AStructIDs As %String, AActionType As %String, ALocIDs As %String = "") As %String
{
	q:(AEpisodeID = "")||(AStructIDs = "") "0^参数异常!"
	if (ALocIDs '= "")
	{
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		q:(curAdmitLocID = "") "0^患者当前不属于任何一个科室,质控项目异常退出!"
		
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		q:($listfind(locIDs,curAdmitLocID) > 0) "1^患者当前所在科室不采用该质控项目,正常退出!"
	
	}
	s result = "1"
	s count = $l(AStructIDs,"^")
	for I=1:1:count
	{
		s StructID = $p(AStructIDs,"^",I)
		s result = ..IsDoneContent(AEpisodeID,StructID,AActionType)
		q:($p(result,"^",1) = "1")
	}
	q result
}

/// Desc: 		病历是否按时完成(超时完成算未完成)
/// Creator:	Candy
/// CreateDate:	2014-9-26
/// Input:		AEpisodeID 就诊号
/// 			AStructID 结构ID
/// 			ADateTime 质控开始时间点
/// 			ADisDateTime 质控结束时间点
/// 			AHours	指定的小时数
/// 			AActionType 质控操作类型
/// 			ARuleType 检查类型(B为提示,提前预防)
/// 			ALocIDs 质控科室 多个以"^"分隔
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件
ClassMethod IsDoneOnTime(AEpisodeID As %String, AStructID As %String, ADateTime As %String, ADisDateTime As %String, AHours As %String, AActionType As %String, ARuleType As %String, ALocIDs As %String = "") As %String
{
	s result = "0^配置错误"
	q:((AEpisodeID = "")||(AStructID = "")||(ADateTime = "")||(AHours = "")) result
	s DisDateTime = $case(ADisDateTime,"":$zd(+$h,3)_" "_$zt($p($h,",",2),2),:ADisDateTime)
	s tmpHours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DisDateTime,ADateTime)
	q:(tmpHours < 0) result
	s result = 1
	s AHours = +AHours
	q:((AHours > tmpHours) && ($zcvt(ARuleType,"U") '= "B")) result
	if (ALocIDs '= "") 
	{
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4) 
		q:(curAdmitLocID = "") "0^患者当前不属于任何一个科室,质控项目异常退出!"
		
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		q:($listfind(locIDs,curAdmitLocID) > 0) "1^患者当前所在科室不采用该质控项目!"	
	}
	s resultInfo = ..IsDoneContent(AEpisodeID,AStructID,AActionType)
	s flag = $p(resultInfo,"^",1)
	if (flag = 1)
	{
		s operDate = $zd($p($p(resultInfo,"^",2),$c(1),2),3)
		s operTime = $zt($p($p(resultInfo,"^",2),$c(1),3))
		s operDateTime = operDate_" "_operTime
		s tmpHours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(operDateTime,ADateTime)
		if (tmpHours > AHours)
		{
			s Interval = $j(tmpHours - AHours,1,1) 
			s result = "-1^超"_Interval_"小时完成!"
		}
	}
	elseif (flag = "-1")
	{
		s Interval = $j(tmpHours - AHours,1,1)
		s:(tmpHours > AHours) result = "-1^超"_Interval_"小时未完成!"
		s:(AHours > tmpHours) result = "-1^请在"_-Interval_"小时内完成病历!"
	}
	else
	{
		s result = resultInfo
	}
 	q result
}

/// Desc: 		病历是否按时完成(所有目录完成算完成，超时完成算未完成)
/// Creator:	Candy
/// CreateDate:	2014-9-26
/// Input:		AEpisodeID 就诊号
/// 			AStructIDs 结构ID 多个以"^"分隔
/// 			ADateTime 质控开始时间点
/// 			ADisDateTime 质控结束时间点
/// 			AHours	指定的小时数
/// 			AActionType 质控操作类型
/// 			ARuleType 检查类型(B为提示,提前预防)
/// 			ALocIDs 质控科室 多个以"^"分隔
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件
ClassMethod IsDoneOnTime0(AEpisodeID As %String, AStructIDs As %String, ADateTime As %String, ADisDateTime As %String, AHours As %String, AActionType As %String, ARuleType As %String, ALocIDs As %String = "") As %String
{
	q:((AEpisodeID = "")||(AStructIDs = "")||(ADateTime = "")||(AHours = "")) "0^参数异常!"
	if (ALocIDs '= "")
	{
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		q:(curAdmitLocID = "") "0^患者当前不属于任何一个科室,质控项目异常退出!"
		
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		q:($listfind(locIDs,curAdmitLocID) > 0) "1^患者当前所在科室不采用该质控项目,正常退出!"
	}
	s result = "-1"
	s count = $l(AStructIDs,"^")
	for I=1:1:count
	{
		s StructID = $p(AStructIDs,"^",I)
		s result = ..IsDoneOnTime(AEpisodeID,StructID,ADateTime,ADisDateTime,AHours,AActionType,ARuleType)
		q:($p(result,"^",1) '= "1")
	}
	q result
}

/// Desc: 		病历是否按时完成(只要有一个子目录完成算完成，超时完成算未完成)
/// Creator:	Candy
/// CreateDate:	2014-9-26
/// Input:		AEpisodeID 就诊号
/// 			AStructIDs 结构ID 多个以"^"分隔
/// 			ADateTime 质控开始时间点
/// 			ADisDateTime 质控结束时间点
/// 			AHours	指定的小时数
/// 			AActionType 质控操作类型
/// 			ARuleType 检查类型(B为提示,提前预防)
/// 			ALocIDs 质控科室 多个以"^"分隔
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件
ClassMethod IsDoneOnTime1(AEpisodeID As %String, AStructIDs As %String, ADateTime As %String, ADisDateTime As %String, AHours As %String, AActionType As %String, ARuleType As %String, ALocIDs As %String = "") As %String
{
	q:((AEpisodeID = "")||(AStructIDs = "")||(ADateTime = "")||(AHours = "")) "0^参数异常!"
	if (ALocIDs '= "")
	{
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		q:(curAdmitLocID = "") "0^患者当前不属于任何一个科室,质控项目异常退出!"
		
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		q:($listfind(locIDs,curAdmitLocID) > 0) "1^患者当前所在科室不采用该质控项目,正常退出!"
	}
	s result = "1"
	s count = $l(AStructIDs,"^")
	for I=1:1:count
	{
		s StructID = $p(AStructIDs,"^",I)
		s result = ..IsDoneOnTime(AEpisodeID,StructID,ADateTime,ADisDateTime,AHours,AActionType,ARuleType)
		q:($p(result,"^",1) = "1")
	}
	q result
}

/// Desc: 		病历是否完成(超时完成算完成)
/// Creator:	Candy
/// CreateDate:	2014-9-26
/// Input:		AEpisodeID 就诊号
/// 			AStructID 结构ID
/// 			ADateTime 质控时间点
/// 			AHours	指定的小时数
/// 			AActionType 质控操作类型
/// 			ARuleType 检查类型(B为提示,提前预防)
/// 			ALocIDs 质控科室 多个以"^"分隔
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件
/// Debug: w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsDoneInTime(4065958,365,"2014-10-11 15:36:00","",24,"","","")
ClassMethod IsDoneInTime(AEpisodeID As %String, AStructID As %String, ADateTime As %String, ADisDateTime As %String, AHours As %String, AActionType As %String, ARuleType As %String, ALocIDs As %String = "") As %String
{
    
    s result = "0^配置错误"
    q:((AEpisodeID = "")||(AStructID = "")||(ADateTime = "")||(AHours = "")) result
    s DisDateTime = $case(ADisDateTime,"":$zd(+$h,3)_" "_$zt($p($h,",",2),2),:ADisDateTime)
	s tmpHours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DisDateTime,ADateTime)
	q:(tmpHours < 0) result
	s result = 1
	s AHours = +AHours
	q:((AHours > tmpHours) && ($zcvt(ARuleType,"U") '= "B")) result
	if (ALocIDs '= "") 
	{
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4) 
		q:(curAdmitLocID = "") "0^患者当前不属于任何一个科室,质控项目异常退出!"
		
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		q:($listfind(locIDs,curAdmitLocID) > 0) "1^患者当前所在科室不采用该质控项目!"	
	}
	
	s resultInfo = ..IsDoneContent(AEpisodeID,AStructID,AActionType)
	s flag = $p(resultInfo,"^",1)
	q:(flag = "1") result
	if (flag = "-1")
	{
		s Interval = $j(tmpHours - AHours,1,1)
		s:(tmpHours > AHours) result = "-1^超"_Interval_"小时未完成!"
		s:(AHours > tmpHours) result = "-1^请在"_-Interval_"小时内完成病历!"
	}
	else
	{
		s result = resultInfo
	}
 	q result
}

/// Desc: 		病历是否按时完成(所有目录完成算完成，超时完成算完成)
/// Creator:	Candy
/// CreateDate:	2014-9-26
/// Input:		AEpisodeID 就诊号
/// 			AStructIDs 结构ID 多个以"^"分隔
/// 			ADateTime 质控开始时间点
/// 			ADisDateTime 质控结束时间点
/// 			AHours	指定的小时数
/// 			AActionType 质控操作类型
/// 			ARuleType 检查类型(B为提示,提前预防)
/// 			ALocIDs 质控科室 多个以"^"分隔
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件
ClassMethod IsDoneInTime0(AEpisodeID As %String, AStructIDs As %String, ADateTime As %String, ADisDateTime As %String, AHours As %String, AActionType As %String, ARuleType As %String, ALocIDs As %String = "") As %String
{
	q:((AEpisodeID = "")||(AStructIDs = "")||(ADateTime = "")||(AHours = "")) "0^参数异常!"
	if (ALocIDs '= "")
	{
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		q:(curAdmitLocID = "") "0^患者当前不属于任何一个科室,质控项目异常退出!"
		
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		q:($listfind(locIDs,curAdmitLocID) > 0) "1^患者当前所在科室不采用该质控项目,正常退出!"
	}
	s result = "-1"
	s count = $l(AStructIDs,"^")
	for I=1:1:count
	{
		s StructID = $p(AStructIDs,"^",I)
		s result = ..IsDoneInTime(AEpisodeID,StructID,ADateTime,ADisDateTime,AHours,AActionType,ARuleType)
		q:($p(result,"^",1) '= "1")
	}
	q result
}

/// Desc: 		病历是否按时完成(只要有一个子目录完成算完成，超时完成算完成)
/// Creator:	Candy
/// CreateDate:	2014-9-26
/// Input:		AEpisodeID 就诊号
/// 			AStructIDs 结构ID 多个以"^"分隔
/// 			ADateTime 质控开始时间点
/// 			ADisDateTime 质控结束时间点
/// 			AHours	指定的小时数
/// 			AActionType 质控操作类型
/// 			ARuleType 检查类型(B为提示,提前预防)
/// 			ALocIDs 质控科室 多个以"^"分隔
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件
ClassMethod IsDoneInTime1(AEpisodeID As %String, AStructIDs As %String, ADateTime As %String, ADisDateTime As %String, AHours As %String, AActionType As %String, ARuleType As %String, ALocIDs As %String = "") As %String
{
 
	
	q:((AEpisodeID = "")||(AStructIDs = "")||(ADateTime = "")||(AHours = "")) "0^参数异常!"
	if (ALocIDs '= "")
	{
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		q:(curAdmitLocID = "") "0^患者当前不属于任何一个科室,质控项目异常退出!"
		
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		q:($listfind(locIDs,curAdmitLocID) > 0) "1^患者当前所在科室不采用该质控项目,正常退出!"
	}
	
	s result = "1"
	s count = $l(AStructIDs,"^")
	for I=1:1:count
	{
		s StructID = $p(AStructIDs,"^",I)
	
		s result = ..IsDoneInTime(AEpisodeID,StructID,ADateTime,ADisDateTime,AHours,AActionType,ARuleType)
		q:($p(result,"^",1) = "1")
	}
	q result
}

/// 可重复模板完整性质控方法********************************************************************************************************
/// Desc:		可重复模板记录是否在规定的时间内完成(不到时限出院不质控)
///      		如：入院48小时无上级医师查房记录
/// Creator:	Candyu
/// Createdate:	2013-03-21
/// Input：		AEpisodeID:就诊号
///       		ATitles:StructID|可重复模板标题\可重复模板标题(StructID:结构ID)	
///        		ARegDateTime:开始日期
/// 		   		ADisDateTime:结束日期
/// 		   		AHours:多少小时内完成
/// 	   		AActionType:操作类型("",完成,提交,打印)
///        		ARuleType 质控类型(B：提示)
/// OutPut：	result<0 不一致
/// Debug：		w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsDoneRecord0(76,"348|116|住院医师查房记录","2013-03-22 14:46:34","",2,"提交","b")
ClassMethod IsDoneRecord1(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, ADisDateTime As %String, AHours As %String, AActionType As %String, ARuleType As %String = "", ATitleCongruent As %String = "C") As %String
{
	s result = "0^配置错误"
	q:((AEpisodeID = "")||(ATitles = "")||(ARegDateTime = "")||(AHours = "")) result
	s StructID = $p(ATitles,"|",1)
	q:(StructID = "") result 
	s titles = $p(ATitles,"|",2)
	s objStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(StructID)
	q:(objStruct = "") result
	q:(objStruct.IsActive '= "Y") result
	q:((objStruct.BindCategoryId = "")||(objStruct.BindCategoryId = $c(0))) result
	s result = 1
	s AHours = +AHours
	s checkDateTime = $g(ADisDateTime)
	s:(checkDateTime = "") checkDateTime = $tr($h,","," ")
	s tmpTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,ARegDateTime)
	//如果不是提示标准,不到时间不质控
	q:((AHours > tmpTimeGap)&&($zcvt(ARuleType,"U") '= "B"))   
	
	s results = ##Class(%ScrollableResultSet).%New("EPRservice.Quality.EmrCheckRule.Template:GetMultiTempalteInfo")
	d results.Execute(AEpisodeID,objStruct.BindCategoryId,"","","","",titles,ATitleCongruent,AActionType)
	s count = results.Count()
	//没有完成
	if ((count <1)&&(AHours > tmpTimeGap)) {s result = "-1^请在"_ $j(AHours - tmpTimeGap,1,1)_"小时内完成"_titles  q result}
	if ((count <1)&&(AHours < tmpTimeGap)) {s result = "-1^超"_ $j(tmpTimeGap - AHours,1,1) _"小时未完成"_titles q result}		
	s times = $p($g(result),"|",2)
	//超时完成
	s timeList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(times,"\")
	while (results.Next())
	{
		s tempDate = results.Data("HappenDate")
		s tempTime = results.Data("HappenTime")
		s dateTime = $zd(tempDate,3)_" "_$zt(tempTime)
		s timeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(dateTime,ARegDateTime)
		q 
	}
	s:((AHours < timeGap)) result = "-1^超"_ $j(timeGap - AHours,1,1)_"小时完成"_titles
	q result
}

/// Desc:		可重复模板记录是否在规定的时间内完成
///      		如:判断抢救记录是否在抢救后6小时内完成 
/// Creator:	Candy
/// Createdate:	2013-03-29
/// Input：		AEpisodeID:就诊号
///        		ATitles:StructID|可重复模板标题\可重复模板标题(StructID:结构ID)	 
///        		ADateTimes:用"\"分隔的日期串
/// 		   		AHours:多少小时内完成
/// 	  		AAction:操作类型(完成,提交,打印)
///        		ARuleType 质控类型(B：提示)
/// OutPut：	result<0 不一致
/// Debug：		w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsDoneRecord2(69,"348|116|住院医师查房记录","2013-03-22 14:46:34",2,"提交","b")
ClassMethod IsDoneRecord2(AEpisodeID As %String, ATitles As %String, ADateTimes As %String, AHours As %String, AActionType As %String, ARuleType As %String = "", ATitleCongruent As %String = "C") As %String
{

	s result = "0^配置错误",errInfo = "",count = 0
	q:((AEpisodeID = "")||(ATitles = "")||(AHours = "")||(ADateTimes = "")) result
	s StructID = $p(ATitles,"|",1)
	q:(StructID = "") result 
	s objStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(StructID)
	q:(objStruct = "") result
	q:(objStruct.IsActive '= "Y") result
	q:((objStruct.BindCategoryId = "")||(objStruct.BindCategoryId = $c(0))) result

	s titles = $p(ATitles,"|",2)
	
	s result = 1
	s AHours = +AHours
	s checkDateTime = $tr($h,","," ")
	
	s timeList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ADateTimes,"\")
	s addDate = (+AHours * 3600)\86400
	s addTime = (+AHours * 3600)#86400
	for ind = 1:1:$listlength(timeList)
	{
		s tempDateTime = $listget(timeList,ind)
		s tempDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(tempDateTime)
		s tempDate = $p(tempDateTime," ",1)
		continue:(tempDate ="")
		s tempTime = $p(tempDateTime," ",2)
		//是否到质控时间
		s tempGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,tempDate_" "_tempTime)
		continue:((+tempGap < AHours) && ($zcvt(ARuleType,"U") '= "B")) //如果不是提示标准,不到时间不质控

		s results = ##Class(%ScrollableResultSet).%New("EPRservice.Quality.EmrCheckRule.Template:GetMultiTempalteInfo")

		d results.Execute(AEpisodeID,objStruct.BindCategoryId,tempDate,tempTime,tempDate+addDate,tempTime+addTime,titles,ATitleCongruent,AActionType)
		continue:(results.Count()>0)

	    if (+tempGap < AHours)
	    {
	        s errInfo = errInfo_" "_titles_"需要在"_$zd(tempDate+addDate,3)_" "_$zt(tempTime+addTime)_"前完成！" 
	    }else
	    {
		    s errInfo = errInfo_" "_titles_"未在"_$zd(tempDate+addDate,3)_" "_$zt(tempTime+addTime)_"前完成！"
		}
	    s count = count + 1
	} 
	s:(count > 0 ) result = -1
	q result_"^"_errInfo_"^"_count
}

/// Desc:	判断患者当前就诊病历中的某个模板单元是否填写;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElementID为模板单元RowID;
/// 		AInstanceID为实例数据RowID(可重复模板单元时用);
/// Output:	ret=-1没填写; ret=1已填写; ret=0参数错误或无效;
/// Debug: ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsSaveElement(4065867,10462,"")
ClassMethod IsSaveElement(AEpisodeID As %String, AElementID As %String, AInstanceID As %String) As %String
{
	
	s ret = 0
	q:(AEpisodeID = "")||(AElementID = "") ret
	q:($d(AEpisodeID) = 0)||($d(AElementID) = 0) ret
	s objElement = ##Class(EPRmeta.Quality.QualityTemplate).%OpenId(AElementID)
	q:(objElement = "") ret
	//模板单元所属模板的RowId
	q:(objElement.TemplateId = "") ret				
	//单元Code
	q:(objElement.ElementCode = "") ret			
	//为"N"表示不允许为空
	q:($zcvt(objElement.IsNull,"U") = "Y") ret
	//单元无效为N							
	q:($zcvt(objElement.IsActive,"U") '= "Y") ret
	//模板对象
	s objTemplate = ##Class(EMRmeta.Template).%OpenId(objElement.TemplateId)
	q:(objTemplate = "") ret
	//模板对应目录
	q:(objTemplate.TemplateCategoryID = "") ret	
	q:(objTemplate.ChartItemType = "") ret
	q:(objTemplate.ChartItemType = "Multiple")&&(AInstanceID = "") ret
	s ret = -1
	s elementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,AInstanceID)
	s:(elementData '= "") ret = 1
	q ret
}

/// Desc:	当前病历中的某一个(或多个)模板单元必填且不可为"-\—";
/// Input:	AEpisodeID为患者就诊号;AElementIDs 为模板单元RowID(多个用"\"分隔);ANoValues 除空以外不允许填写的值(如"-",多个用"\"分隔);AInstanceID为实例数据RowID(可重复模板单元时用);
/// Output:	ret=-1没填写; ret=1已填写; ret=0参数错误或无效;
/// Debug: ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsSaveElement01(EpisodeID,"","-\—","")
ClassMethod IsSaveElement01(AEpisodeID As %String, AElementIDs As %String, ANoValues As %String, AInstanceID As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="") ret
	
	s ret=1
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s ElementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,AInstanceID)
		s:(ANoValues'="") ElementData=$tr(ElementData,ANoValues,"")
		s:(ElementData="") ret=-1
		q:(ret=-1)
	}
	q ret
}

/// Desc:	判断患者当前就诊病历中的某个模板单元是否填写(有时限);
///         (如：入院记录.主诉应在患者入院24小时内完成)
/// Input:	AEpisodeID为患者就诊号;
/// 		AElementID为模板单元RowID;
/// 		AInstanceID为实例数据RowID(可重复模板单元时用);
/// Output:	ret=-1没填写; ret=1已填写; ret=0参数错误或无效;
/// Debug: ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsSaveElement(4065867,10462,"")
ClassMethod IsSaveElementOnTime(AEpisodeID As %String, AElementID As %String, AInstanceID As %String, AadmDateTime As %String, AHour As %String) As %String
{
	
	s ret = 0
	q:(AEpisodeID = "")||(AElementID = "") ret
	q:($d(AEpisodeID) = 0)||($d(AElementID) = 0) ret
	s objElement = ##Class(EPRmeta.Quality.QualityTemplate).%OpenId(AElementID)
	q:(objElement = "") ret
	//模板单元所属模板的RowId
	q:(objElement.TemplateId = "") ret				
	//单元Code
	q:(objElement.ElementCode = "") ret			
	//为"N"表示不允许为空
	q:($zcvt(objElement.IsNull,"U") = "Y") ret
	//单元无效为N							
	q:($zcvt(objElement.IsActive,"U") '= "Y") ret
	//模板对象
	s objTemplate = ##Class(EMRmeta.Template).%OpenId(objElement.TemplateId)
	q:(objTemplate = "") ret
	//模板对应目录
	q:(objTemplate.TemplateCategoryID = "") ret	
	q:(objTemplate.ChartItemType = "") ret
	q:(objTemplate.ChartItemType = "Multiple")&&(AInstanceID = "") ret
	s ret = -1
	s elementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,AInstanceID)
	s:(elementData '= "") ret = 0
	s dateTime= $zd(+$h,3)_" "_$zt($p($h,",",2),2)
	s timeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(dateTime,AadmDateTime)
	q:(timeGap<24) ret
	q:(timeGap>=24)&&(elementData="") ret
	q ret
}

/// Desc:   检查缺少几天一次的可重复模板记录（按创建时间质控）,并显示是否补充(多次评分)
/// 先检查是否创建记录如果有则返回真，否则再检查是否补填记录，如果有则提示已补，否则返回缺记录时间       
/// Demander：北京协和
/// Creator:HKY
/// CreateDate:2014-12-22
/// Input:AEpisodeID 就诊号，ATitles 标题，ARegDateTime 入院时间，ADisDateTime 出院时间，ADays 几天一次
///       ATitleCongruent:标题包含还是等于值域（E 等于，C 包含）
///       ATimeType:按时间取数据（创建 C，发生 H，修改 M）
///       AACtionType:操作类型（"",完成，提交，打印）
/// OutPut:ret -1 触犯^提示信息^触犯次数
/// Debug: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsDailyRecordOnTime(4054959,"369|日常病程记录","2014-04-01 14:05:29","",3)
/// ************************************************************************************************************************
ClassMethod IsDailyRecordOnTime(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, ADisDateTime As %String, ADays As %String, ATitleCongruent As %String = "C", AActionType As %String = "") As %String
{
	s ret = 1, errInfo = "",count = 0
	q:((AEpisodeID = "")||(ATitles = "")||(ARegDateTime = "")||(ADays = "")) ret
    
	s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s disDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	
	s checkDate = $p(disDateTime," ",1)
	s:(checkDate = "") checkDate = $p($h,",",1)
	s checkTime = $p(disDateTime," ",2)
	s:(checkTime = "") checkTime = $p($h,",",2)
	
	s fromDate = $p(regDateTime," ",1)
	s fromTime = $p(regDateTime," ",2)
	s:(fromTime = "") fromTime = 0
	s toDate = +checkDate
	f tmpDate = fromDate:$g(ADays):toDate 
	{
	  
	  s result = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,fromTime,tmpDate+ADays,checkTime,ATitleCongruent,"C",AActionType)	
	  q:($e(result,1,2) = "0^")
	  s Tempcount = +$e(result,3,$l(result))
	  continue:(Tempcount > 0)     
	  s result = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,fromTime,tmpDate+ADays,checkTime,ATitleCongruent,"H",AActionType) 
	  q:($e(result,1,2) = "0^")
	  s Tempcount = +$e(result,3,$l(result))
	  if (Tempcount > 0) 
	  {
	     s errInfo = errInfo_" 缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+ADays-1,3)_"的记录,已补!"
	  }else
	  {
		 s errInfo = errInfo_" 缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+ADays-1,3)_"的一次记录!"
	  }
	  s count = count + 1
	}
	s:(count > 0 ) ret = -1
	q ret_"^"_errInfo_"^"_count
}

/// ****************************************************************
/// 说明: 交班病人接班记录数与接班记录数不一致
///     : 转科病人转科记录数与接收记录数不一致
///     : 会诊病人请会诊记录数与会诊记录数不一致
///     : 入参AHours，用于判定多少小时内不需要检查相应记录的一致性问题，默认为空
/// 结论: ret<0 不一致
/// Added By HKY
/// 调试: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).CompareTitleCount(4054959,"369|交班记录","369|接班记录","2014-04-01 14:05:00")
/// ****************************************************************
ClassMethod CompareTitleCount(AEpisodeID As %String, ATitles1 As %String, ATitles2 As %String, ARegDateTime As %String, ADisDateTime As %String = "", AHours As %String = "", ATitleCongruent As %String = "C", ATimeType As %String = "H") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(ATitles1 = "")||(ATitles2 = "") ret
	
    s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s checkDateTime = $g(ADisDateTime) //出院时间
	s:(checkDateTime = "") checkDateTime = $tr($h,","," ") //出院时间为空取当前时间
	s tmpTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,ARegDateTime) 
	//q:tmpTimeGap<=48 
	s startDate = $p(regDateTime," ",1), startTime = $p(regDateTime," ",2)
	s endDate = $p(checkDateTime," ",1), endTime = $p(checkDateTime," ",2)
	
	//20100716 wangwt update 
	s:(AHours '= "") tmpEndDate = AHours/24
	s:(AHours '= "") startDate = startDate + tmpEndDate, startTime = startTime
	s result1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles1,startDate,startTime,endDate,endTime,ATitleCongruent,ATimeType)	
	q:($e(result1,1,2) = "0^") ret
	s count1 = +$e(result1,3,$l(result1))
	
	s result2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles2,startDate,startTime,endDate,endTime,ATitleCongruent,ATimeType)
	q:($e(result2,1,2) = "0^") ret
	s count2 = +$e(result2,3,$l(result2))

	s ret = 1
	s:(count1 '= count2) ret = -1
	
	q ret
}

/// Desc:	交班记录后24小时内未完成接班记录
///     	转科记录后24小时内未完成接收记录
///     	请会诊记录后24小时未完成会诊记录
/// Creator:HKY
/// Input:	AEpisodeID为患者就诊号;
/// 		ATitles1为前导标题字符串;
/// 		ATitles2为后置标题字符串;
/// 		AHours为参考小时数(默认为24);
/// Output:	ret<0 不一致
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).DoubleRecordWtOnTime(AEpisodeID,ATitles1,ATitles2,AHours)
ClassMethod DoubleRecordWtOnTime(AEpisodeID As %String, ATitles1 As %String, ATitles2 As %String, AHours As %String = 24) As %String
{
	s ret = 0, errInfo = ""
	q:(AEpisodeID = "")||(ATitles1 = "")||(ATitles2 = "") ret
	
	s checkDateTime = $tr($h,","," ")
	
	s result1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiTemHaDateTime(AEpisodeID,ATitles1,"","","","")
	q:($e(result1,1,2) = "0^") ret
	s dateTimes1 = $e(result1,3,$l(result1))
	
	s result2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiTemHaDateTime(AEpisodeID,ATitles2,"","","","")
	q:($e(result2,1,2) = "0^") ret
	s dateTimes2 = $e(result2,3,$l(result2))
	
	s dateTimes1 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(dateTimes1,"\")

	s:(dateTimes2 = "") dateTimes2Initial = dateTimes2, dateTimes2 = $tr($h,","," ")
	s:(dateTimes2 '= "") dateTimes2Initial = "NULL"
	//wwt end
	s dateTimes2 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(dateTimes2,"\")

	s ret = 1
	f ind1 = 1:1:$listlength(dateTimes1) q:(+ret = -1)  d
	.s dateTime1 = $listget(dateTimes1,ind1)
	.q:(dateTime1 = "")
	.s checkTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,dateTime1)
	.//wwt update 20100716 首次交班
	.s:(dateTimes2Initial = "")&&(checkTimeGap <= AHours)&&($p(ATitles1,"|",2) = "交班记录") errInfo = "^ 提示:"_$zd($p(dateTime1," ",1),3)_"交班记录对应的接班记录书写时限还剩"_$j(checkTimeGap,1,1)_"小时!" ,ret = -1, ret = ret_errInfo
	.s:(dateTimes2Initial = "")&&(checkTimeGap <= AHours)&&($p(ATitles1,"|",2) = "转出记录") errInfo = "^ 提示:"_$zd($p(dateTime1," ",1),3)_"转出记录对应的转入记录书写时限还剩"_$j(checkTimeGap,1,1)_"小时!" ,ret = -1, ret = ret_errInfo
	.//wwt end
	.q:(checkTimeGap <= 24)
	.s flag = 0
	.f ind2 = 1:1:$listlength(dateTimes2) q:(flag = 1)  d
	..s dateTime2 = $listget(dateTimes2,ind2)
	..q:(dateTime2 = "")
	..s tmpTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(dateTime2,dateTime1)
	..q:(tmpTimeGap < 0)
	..q:(tmpTimeGap > AHours)
	..s flag = 1
	.q:(flag = 1)
	.s ret = -1
	.//wwt update 20100716 历次交班
	.s:($p(ATitles1,"|",2) = "交班记录") errInfo = "^ 提示:未发现"_$zd($p(dateTime1," ",1),3)_"交班记录对应的接班记录!"
	.s:($p(ATitles1,"|",2) = "转出记录") errInfo = "^ 提示:未发现"_$zd($p(dateTime1," ",1),3)_"转出记录对应的转入记录!"
	.s ret = ret_errInfo
	.//wwt end
	
	q ret
}

/// Desc:	缺少每天至少一次的病程记录
///     	缺少7天一次的主任医师查房记录
///     	缺少30天一次的阶段小结
/// Creator:HKY
/// Output:	ret<0 不一致
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsRecordSavDurRightDay(AEpisodeID,ATitles,ARegDateTime,ADisDateTime,ADays,AConditions)
/// 			w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsRecordSavDurRightDay(4065871,"371|阶段小结","2014-09-19 09:39:00","")ADays,AConditions)
ClassMethod IsRecordSavDurRightDay(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, ADisDateTime As %String, ADays As %String, AConditions As %String = "") As %String
{
	s ret = 0, errInfo = ""
	q:(AEpisodeID = "")||(ATitles = "")||(ARegDateTime = "")||(ADays = "") ret

	s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s disDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	
	s checkDate = $p(disDateTime," ",1)
	s:(checkDate = "") checkDate = +$h
	
	s fromDate = $p(regDateTime," ",1)
	s toDate = +checkDate
	
	s ret = 1
	f tmpDate = fromDate:$g(ADays):toDate d
	.q:(checkDate <= (tmpDate + ADays))
	.//wwt update 20100716
	.q:(ret = -1)
	.//wwt and
	.s result = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,0,tmpDate+ADays,0)
	.q:($e(result,1,2) = "0^")
	.s count = +$e(result,3,$l(result))
	.q:(count > 0)
	.s ret=-1
	.//wwt update 20100716
	.s errInfo=errInfo_" 提示:缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+ADays-1,3)_"的一次记录!"
	.s ret = ret_"^"_errInfo
	
	//b "s"  //Add , Conditions As %String =""
	if (AConditions '= "")&&(+ret = -1)
	{
		.s result = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,0,tmpDate+ADays,0)
		q:($e(conResult,1,2) = "0^") ret
		s count = +$e(conResult,3,$l(conResult))
		s:(count > 0) ret = 1
	}
	//wwt and
	
	q ret
}

/// Desc:判断是否写输血记录(无论当天输血了多少次或者输的什么，一天只要有一次记录就可以)
///      判断会诊执行记录需在会诊完成后24小时完成:只要在会诊结束后24小时内有会诊记录即可
///      当检验检查结果有危急值时，要求在24小时内记录危急值记录
/// Creator:HKY
/// Input:AEpisodeID 就诊号，AOrdItemsTime 下医嘱时间(使用公共函数)，ATitles structID|标题,ADays 几天一次，可以是24小时的倍数
/// OutPut:ret_"^"_errInfo_"^"_count  状态_"^"_错误信息_"^"_触犯次数
ClassMethod IsRecordWtOnOrdTime(AEpisodeID As %String, AOrdItemsTime As %String, ATitles As %String, ADays As %String = "1")
{
	s ret = 1,errInfo = "",count = 0
	q:((AEpisodeID = "")||(AOrdItemsTime = "")||(ATitles = "")) ret
    s ADays = +ADays
	s DateTimes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AOrdItemsTime,"\")
	q:(DateTimes = "") ret
	s TempDate = "" 
	for i = 1:1:$listlength(DateTimes)
	{
		continue:(TempDate = $p($ListGet(DateTimes,i)," ",1))
		s TempDate = $p($ListGet(DateTimes,i)," ",1)
		s TempTime = $p($ListGet(DateTimes,i)," ",2)
		s result = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,TempDate,TempTime,TempDate + ADays,TempTime)
		s:($p(result,"^",2) <= 0) errInfo = errInfo_" 缺少"_TempDate_"的一次记录",ret = -1,count = count + 1
	}
    q ret_"^"_errInfo_"^"_count
}

/// 说明: 手术记录未在术后24小时内完成（手术申请单结束时间）
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsOperaRecFinOnTime(AEpisodeID,AHISDateTimes,ATitles,AHours)
/// ****************************************************************
ClassMethod IsOperaRecFinOnTime(AEpisodeID As %String, AHISDateTimes As %String, ATitles As %String, AHours As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AHISDateTimes = "")||(ATitles = "") ret
	
	s checkDateTime = $tr($h,","," ")
	s hours = 24
	s:($g(AHours) '= "") hours = +$g(AHours)
	
	s result =##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiTemHaDateTime(AEpisodeID,ATitles,"","","","")
	q:($e(result,1,2) = "0^") ret
	s dateTimes = $e(result,3,$l(result))
	
	s dateTimes2 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(dateTimes,"\")
	s dateTimes2 = dateTimes2_$lb($tr($h,","," "))
	s dateTimes1 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AHISDateTimes,"\")

	s ret = 1
	f ind1 = 1:1:$listlength(dateTimes1) q:(ret = -1)  d
	.s dateTime1=$listget(dateTimes1,ind1)
	.q:(dateTime1 = "")
	.s dateTime1 = $p(dateTime1," ",3)_" "_$p(dateTime1," ",4)
	.q:(dateTime1 = " ")
	.s checkTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,dateTime1)
	.q:(checkTimeGap <= 24)
	.s flag = 0
	.f ind2 = 1:1:$listlength(dateTimes2) q:(flag = 1)  d
	..s dateTime2=$listget(dateTimes2,ind2)
	..q:(dateTime2 = "")
	..s tmpTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(dateTime2,dateTime1)
	..q:(tmpTimeGap < 0)
	..q:(tmpTimeGap > hours)
	..s flag = 1
	.q:(flag = 1)
	.s ret = -1

	q ret
}

/// ****************************************************************
/// 说明: 术前小结记录未在术前*小时内完成（手术申请单开始时间）
///     ：无手术前术者查看病人的病程记录（手术申请单开始时间）
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify206(AEpisodeID,AHISDateTimes,ATitles)
ClassMethod IsFinishBeforOperOnHour(AEpisodeID As %String, AHISDateTimes As %String, ATitles As %String, AHours As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AHISDateTimes = "")||(ATitles = "") ret
	
	s result = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiTemHaDateTime(AEpisodeID,ATitles,"","","","")
	q:($e(result,1,2) = "0^") ret
	s dateTimes = $e(result,3,$l(result))
	
	s dateTimes1 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AHISDateTimes,"\")
	s dateTimes2 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(dateTimes,"\")
	
	s ret = 1
	f ind1 = 1:1:$listlength(dateTimes1) q:(ret = -1)  d
	.s dateTime1 = $listget(dateTimes1,ind1)
	.q:(dateTime1 = "")
	.s dateTime1 = $p(dateTime1," ",1)_" "_$p(dateTime1," ",2)
	.q:(dateTime1 = " ")
	.s flag = 0
	.f ind2 = 1:1:$listlength(dateTimes2) q:(flag = 1)  d
	..s dateTime2 = $listget(dateTimes2,ind2)
	..q:(dateTime2 = "")
	..s tmpTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(dateTime1,dateTime2)
	..q:(tmpTimeGap < 0)
	..s flag = 1
	.q:(flag = 1)
	.s ret = -1
	
	q ret
}

/// 说明: 缺少术后当天术后病程记录（手术申请单结束时间）
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsRecordFinByOperaOnDay(EpisodeID,Titles,DateTimes,DischDateTime)
/// ****************************************************************
ClassMethod IsRecordFinByOperaOnDay(AEpisodeID As %String, ATitles As %String, AHISDateTimes As %String, ADischDateTime As %String, ATitleCongruent As %String = "C", ATimeType As %String = "H", AActionType As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(ATitles = "")||(ADateTimes = "") ret
	
	s checkDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADischDateTime)
	s checkDate = $p(checkDateTime," ",1)
	s:(checkDate = "") checkDate = +$h
	
	s dateTimes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AHISDateTimes,"\")
	
	s ret=1
	f Ind=1:1:$listlength(dateTimes) q:ret=-1  d
	.s dateTime=$listget(dateTimes,Ind)
	.q:dateTime=""
	.s dateTime=$p(dateTime," ",3)_" "_$p(dateTime," ",4)
	.s dateTime=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(dateTime)
	.q:dateTime=""
	.s fromDate=$p(dateTime," ",1),fromTime=$p(dateTime," ",2)
	.s toDate=fromDate+1,toTime=fromTime
	.q:(checkDate<=toDate)
	.s result=##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,fromDate,fromTime,toDate,toTime,ATitleCongruent,ATitleCongruent,AActionType)
	.q:$e(result,1,2)="0^"
	.s count=+$e(result,3,$l(result))
	.q:count>0
	.s ret=-1
	
	q ret
}

/// 说明: 缺少术后三天连续病程记录（手术申请单结束时间）
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsRecordFinByOpera(AEpisodeID,ATitles,ADateTimes,ADischDateTime,ADays)
/// ****************************************************************
ClassMethod IsRecordFinByOpera(AEpisodeID As %String, ATitles As %String, AHISDateTimes As %String, ADischDateTime As %String, ADays As %String = "3", ATitleCongruent As %String = "C", ATimeType As %String = "H", AActionType As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID="")||(ATitles="")||(AHISDateTimes="") ret
	
	s dischDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADischDateTime)
	s checkDate = $p(dischDateTime," ",1)
	s:(checkDate = "") checkDate = +$h
	
	s dateTimes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AHISDateTimes,"\")
	
	s ret = 1
	f Ind=1:1:$listlength(dateTimes) q:ret=-1  d
	.s dateTime=$listget(dateTimes,Ind)
	.s dateTime=$p(dateTime," ",1)_" "_$p(dateTime," ",2)
	.s dateTime=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(dateTime)
	.q:dateTime=""
	.s fromDate=$p(dateTime," ",1),fromTime=$p(dateTime," ",2),toTime=fromTime
	.f Ind1=1:1:$g(ADays) d
	..s fromDate=fromDate+1
	..s toDate=fromDate+1
	..q:checkDate<toDate
	..s result=##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,fromDate,fromTime,toDate,toTime,ATitleCongruent,ATitleCongruent,AActionType)
	..q:$e(result,1,2)="0^"
	..s count=+$e(result,3,$l(result))
	..q:count>0
	..s ret=-1
	
	q ret
}

/// Desc:病危、病重患者可重复模板数据判断(几天写一次)
///      下了护理医嘱的患者可重复模板数据判断（几天一次）
/// Creator: HKY
/// Createdate:2018-04-09
/// Input:AEpisodeID 就诊号，AOrdItems 医嘱项，ATitles structID|标题,ADays 天数
ClassMethod IsRecordFinByOrderOnDay(AEpisodeID As %String, AOrdItems As %String, ATitles As %String, ADays As %String, ATitleCongruent As %String = "C", ATimeType As %String = "H", AActionType As %String = "")
{
	s ret = 0,errInfo = "",count = 0
	q:(AEpisodeID = "")||(AOrdItems = "")||(ADays = "") ret
	//查询是否下指定医嘱
	s dsOrder = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.OrderInfo:QueryOrderItem")
	d dsOrder.Execute(AEpisodeID,AOrdItems,"","Y")
	while(dsOrder.Next())
	{
		s OrderIDate = dsOrder.Data("IDate")   //开医嘱日期
		s OrderITime = dsOrder.Data("ITime")   //开医嘱时间
		s OrderDDate = dsOrder.Data("DDate")   //停止日期
		s:(OrderDDate = "") OrderDDate = $p($h,",",1)
		s OrderDTime = dsOrder.Data("DTime")   //停止时间
		s:(OrderDTime = "") OrderDTime = $p($h,",",2)
		
	    f tmpDate = OrderIDate:$g(ADays):OrderDDate 
	    {
	       s result = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,OrderITime,tmpDate+ADays,OrderDTime,ATitleCongruent,ATitleCongruent,AActionType)	
	       q:($p(result,"^",1) = "0")
	       s Tempcount = +$p(result,"^",2)
	       continue:(Tempcount > 0) 
	       s count = count + 1
	       s errInfo = errInfo_" 缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+ADays-1,3)_"的一次记录!"
	    }	
	}
	if (count > 0) {s ret = -1}else{s ret =1}
	q ret_"^"_errInfo_"^"_count
}

/// 说明: 转科患者缺少转科后连续三天病程记录（转科时间）
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsRecordFinByTransfer(AEpisodeID,ATitles,ADateTimes,ADischDateTime,ADays)
/// ****************************************************************
ClassMethod IsRecordFinByTransfer(AEpisodeID As %String, ATitles As %String, AHISDateTimes As %String, ADischDateTime As %String, ADays As %String = "3", ATitleCongruent As %String = "C", ATimeType As %String = "H", AActionType As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID="")||(ATitles="")||(AHISDateTimes="") ret
	
	s dischDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADischDateTime)
	s checkDate = $p(dischDateTime," ",1)
	s:(checkDate = "") checkDate = +$h
	
	s dateTimes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AHISDateTimes,"\")
	
	s ret = 1
	f Ind=1:1:$listlength(dateTimes) q:ret=-1  d
	.s dateTime=$listget(dateTimes,Ind)
	.s dateTime=$p(dateTime," ",3)_" "_$p(dateTime," ",4)
	.s dateTime=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(dateTime)
	.q:dateTime=""
	.s fromDate=$p(dateTime," ",1),fromTime=$p(dateTime," ",2),toTime=fromTime
	.f Ind1=1:1:$g(ADays) d
	..s fromDate=fromDate+1
	..s toDate=fromDate+1
	..q:checkDate<toDate
	..s result=##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,fromDate,fromTime,toDate,toTime,ATitleCongruent,ATitleCongruent,AActionType)
	..q:$e(result,1,2)="0^"
	..s count=+$e(result,3,$l(result))
	..q:count>0
	..s ret=-1
	
	q ret
}

/// 病案首页:当主要诊断或其他诊断【出院情况】为"4死亡"时,则【离院方式】必须为死亡
/// Creator:YHY
/// Desc: 当AElement1等于（不等于）某一值时，限制AElement2必须等于（不等于）某一个值
/// Input:AEpisodeID:就诊号
///       AElement1
///       isnt1（"="或者"<>"）
///       AValue1,条件单元的值
///       AElement2 
///       isnt2（"="或者"<>"）
///       AValue2，限定结果单元的值
/// OutPut:-1触犯，1检查通过
/// Debug: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0001(632,10524,"≠","0",10122,"≠","")
ClassMethod IsUnify0001(AEpisodeID As %String, AElement1 As %String, isnt1 As %String, AValue1 As %String = "", AElement2 As %String, isnt2 As %String, AValue2 As %String = "") As %String
{
	s ret = 0
	q:((AEpisodeID = "")||(AElement1 = "")) ret
	s ret = 1
    s Elementdata1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
    s:(AValue1="") Elementdata1=$tr(Elementdata1,"-\—\ ","")
    //q:Elementdata1="" ret
    s Elementdata2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
    s:(AValue2="") Elementdata2=$tr(Elementdata2,"-\—\ ","")
    //q:Elementdata2="" ret
    
    if isnt1="="
    {
    	q:Elementdata1'=AValue1 ret
	    if (isnt2="=")
	    {
	    	Q:Elementdata2=AValue2 ret
	    	Q:Elementdata2'=AValue2 ret=-1
	    }
	    if (isnt2="<>")
	    {
	    	Q:Elementdata2'=AValue2 ret
	    	Q:Elementdata2=AValue2 ret=-1
	    }
    }
	elseif isnt1="<>"
	{
		q:Elementdata1=AValue1 ret
		if (isnt2="=")
		{
			
	    	Q:Elementdata2=AValue2 ret
	    	Q:Elementdata2'=AValue2 ret=-1
		}
	    if (isnt2="<>")
	    {
	    	Q:Elementdata2'=AValue2 ret
	    	Q:Elementdata2=AValue2 ret=-1
		}
    }
    s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// Creator:YHY
/// 说明: 同一模板中多元素一致性判断，当Element1为Values1中任意各值，Elements2中各元素有任何一个为Value2时触发
/// 		Element1，Value2为单值；， Values1和Elements2为多值
/// 结论: ret<0 
/// 调试: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0002(EpisodeID,Element1,Elements2,Values1,Value2)
ClassMethod IsUnify0002(EpisodeID As %String, Element1 As %String, Elements2 As %String, Values1 As %String, Value2 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Elements2="") ret
	
	s ret=1 
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,Element1,"")
	s ElementData1=$tr(ElementData1,"-\—\ ","")
	q:(ElementData1 = "") ret
	 
	s ElementsData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,Elements2,"")
	s ElementData2=$tr(ElementData2,"-\—\ ","")
	q:(ElementsData2="") ret
	
	for i=1:1:$l(ElementsData2,"\") {
		s ElementData2=$p(ElementsData2,"\",i)
		for j=1:1:$l(Values1,"\") {
			s Value1=$p(Values1,"\",j)		//循环Values1中包含的每一个值
			if ElementData1=Value1 
			{
				s:(ElementData2=Value2) ret=-1
			}
		}
	}

	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(Element1_"\"_Elements2)
	q ret_"@"_ElementCode
}

/// Creator:YHY
/// Desc: 当AElement不符合要求事触发（复兴：社保卡号必须为12位，并且最后一位为S）
/// Input:AEpisodeID:就诊号
///       AElement：模板单元rouid
/// OutPut:-1触犯，1检查通过
/// Debug: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0003()
ClassMethod IsUnify0003(AEpisodeID As %String, AElement As %String) As %String
{
	s ret = 0
	q:((AEpisodeID = "")||(AElement = "")) ret
	//返回不为空的者是医保患者，非医保患者不判断，参数Hospital可以为空
	s InsuranceNo=""
	s InsuranceNo =##Class(EMRservice.HISInterface.PatientInfoAssist).InsuranceNo(AEpisodeID,"")
	q:($g(InsuranceNo)="") ret

	s ret =1
    s Elementdata=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
    q:($tr(Elementdata,"-\—","")="") ret
    
    s:($L(Elementdata)'=12)||($E(Elementdata,12)'="S") ret=-1
    
    s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement)
	q ret_"@"_ElementCode
}

/// Creator:YHY
/// Desc: 当指定条件的患者AElement的值不符合要求事触发（复兴：产科患者的主要诊断必须为"单胎活产"）
/// Input:AEpisodeID:就诊号
///       AElement：模板单元rouid
///       AValue: 要求的单元对应的值
/// OutPut:-1触犯，1检查通过
/// Debug: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0004()
ClassMethod IsUnify0004(AEpisodeID As %String, AElement As %String, AValue As %String) As %String
{
	s ret = 0
	q:((AEpisodeID = "")||(AElement = "")) ret
	s ret = 1
    s Elementdata=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
    q:($tr(Elementdata,"-\—","")="") ret
    s:(Elementdata '= AValue) ret=-1
    
    s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement)
	q ret_"@"_ElementCode
}

/// Creator:YHY
/// Desc: 判断病案首页'离院方式'和'尸检'是否一致
///       离院方式等于'死亡'时，尸检不能为空
///       离院方式不等于'死亡'时，尸检必须为空
/// Input:AEpisodeID:就诊号
///       AElement1 离院方式模板rowid
///       AElement2 尸检模板rowid
/// OutPut:-1触犯，1检查通过
/// Debug: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0005()
ClassMethod IsUnify0005(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret = 0
	q:((AEpisodeID = "")||(AElement1 = "")) ret
	s ret = 1
    s Elementdata1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
    q:Elementdata1="" ret
    s Elementdata2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
    s:(Elementdata1="死亡")&&($tr(Elementdata2,"-\—","")="") ret=-1
    s:(Elementdata1'="死亡")&&($tr(Elementdata2,"-\—","")'="") ret=-1
    
    s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// Add:    YHY
/// Desc:	判断日期单元是否超出入出院时间(比如病案首页中确诊日期、手术日期等，为空则不判断);
/// modify: Hanxf;--<出院时间AElement2可以取医生填写的日期时间>
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为指定模板单元RowID;
/// 		ARegDate为患者入院日期;
/// 		ADischDate为患者出院日期;
///         AElement2为指定模板日期单元RowID;
/// Return：ret<0:不一致; ret=1一致;  --<Modi Guozt 有歧义 更改返回值>
///         ret<0:传入日期比入院日期早，或者 传入日期比出院日期晚
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0006()
ClassMethod IsUnify0006(AEpisodeID As %String, AElement1 As %String, ARegDate As %String, ADischDate As %String, AElement2 As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(ARegDate = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:($tr(ElementData1,"-\—","")="") ret
	
	//Add by Liaowp 2010-06-22
	//首页中当日确诊,确诊日期没有时间,默认为00:00:00,此条不通过
	s DateTime1 = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ElementData1)
	s DateTime2 = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ARegDate)
	s Date1 = $p(DateTime1," ",1),Time1 = $p(DateTime1," ",2)
	s Date2 = $p(DateTime2," ",1),Time2 = $p(DateTime2," ",2)
	s:((Date1 = Date2)&&(Time1 = "00:00:00")&&(Time2 '= "00:00:00")) DateTime1 = DateTime2
	//End Add
	
	s ret = 1
	s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DateTime1,ARegDate)
	s:(flag < 0) ret = -1
	s:(ADischDate = "") ADischDate = $zd(+$h,3)_" "_$zt($p($h,",",2),1)
	s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ADischDate,DateTime1)
	s:(flag < 0) ret = -1
	
	//Add Hanxf
	if (AElement2 '= "")
	{
	  s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	  q:($tr(ElementData2,"-\—","") = "") ret	
	  s Element2DateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ElementData2)
	  s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(Element2DateTime,DateTime1)
	  s:(flag < 0) ret = -1
	}
	//end add
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// Creator:YHY
/// Desc: 当AElement不符合要求事触发（复兴：邮编为六位或'100000'）
/// Input:AEpisodeID:就诊号
///       AElement：模板单元rouid
/// OutPut:-1触犯，1检查通过
/// Debug: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0007()
ClassMethod IsUnify0007(AEpisodeID As %String, AElement As %String) As %String
{
	s ret = 0
	q:((AEpisodeID = "")||(AElement = "")) ret
	s ret =1
    s Elementdata=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
    q:($tr(Elementdata,"-\—","")="") ret
    
    for i=1:1:$l(Elementdata) {
		
		s IDCardnum=$E(Elementdata,i)
		s numACode=$a(IDCardnum)
		s:(numACode<48)||(numACode>57) ret=-1
		s:($l(Elementdata)'=6) ret=-1
		q:(ret=-1)
	}
    
    s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement)
	q ret_"@"_ElementCode
}

/// Creator:YHY
/// Desc :病案首页.年龄大于等于一岁时必须填写年龄,不能新生儿年龄”；小于一周岁时必须写新生称年龄，不能填写年龄。
/// Input:AEpisodeID:就诊号
///       AElement1 年龄模板rowid
///       AElement2 新生儿年龄模板rowid
/// OutPut:-1触犯，1检查通过
/// Debug: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0008()
ClassMethod IsUnify0008(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret = 0
	q:((AEpisodeID = "")||(AElement1 = "")) ret
	s ret = 1,argPapmiDR="",Birthday="",AdmDate="",Age=""
	s argPapmiDR=##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s Birthday = ##class(EMRservice.HISInterface.PatientInfoAssist).Birthday(argPapmiDR)
	q:Birthday="" ret
	
	s AdmDate = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID)
	q:AdmDate="" ret
	
	s Age = ##class(EMRservice.HISInterface.PatientInfoAssist).Age(AEpisodeID,Birthday,AdmDate,1)
	q:Age="" ret
	
    s Elementdata1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
    s Elementdata1=$tr(Elementdata1,"-\—","")
    s Elementdata2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
    s Elementdata2=$tr(Elementdata2,"-\—","")
    
    s:(((Age["岁")&&(Elementdata1=""))||((Age["岁")&&(Elementdata2'=""))) ret=-1
    s:(((Age'["岁")&&(Elementdata2=""))||((Age'["岁")&&(Elementdata1'=""))) ret=-1
    
    s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// Desc:	判断病案首页【抢救次数】与【成功次数】是否一致（抢救次数必须>=成功次数）
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为抢救次数模板单元RowID; 
/// 		AElement2为成功次数模板单元RowID;
///         AElement3为出院情况/离院方式模板单元RowID; 
/// modify: 根据是否为死亡，增加抢救与成功次数的关系判断
/// Creator:YHY
/// Return:	ret<0 不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0009("","","")
ClassMethod IsUnify0009(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	
	s elementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	s elementData1=$tr(elementData1,"-\—","")
	//q:(elementData1 = "") ret
	
	s elementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	s elementData2=$tr(elementData2,"-\—","")
	//q:(elementData2 = "") ret
	
	s elementData3 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement3,"")
	//q:(elementData3 = "") ret
	
	q:(elementData1 = "")&&(elementData2 = "") ret
	
	s elementData1 = $tr(elementData1,"零","0")
	s elementData2 = $tr(elementData2,"零","0")
	
	s ret = 1
	s:(+elementData1 < +elementData2) ret = -1
	
	if (elementData3'="")
	{
	  s:((elementData3 '= "死亡")&&(+elementData1 '= +elementData2)) ret=-1
	  s:((elementData3 = "死亡")&&(+elementData1 '= (+elementData2+1))) ret=-1	
	}
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
	q ret_"@"_ElementCode
}

/// Creator:YHY
/// 说明: 病案首页'其他出院诊断'中有一个位'单胎活产'或'多胎活产'时，要求新生儿身长必填
/// 说明: 同一模板中多元素一致性判断，当Elements1为Values1中任意各值，Element2为Value2时触发
/// 		Element2，Value2为单值；， Values1和Elements1为多值
/// 结论: ret<0 
/// 调试: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0010(EpisodeID,Elements1,Elements2,Values1,Value2)
ClassMethod IsUnify0010(AEpisodeID As %String, AElements1 As %String, AElement2 As %String, Values1 As %String, Value2 As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElements1="")||(AElement2="") ret
	
	s ret=1
	for i=1:1:$l(AElements1,"\")
	{
		s Element1 = $p(AElements1,"\",i)
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element1,"")
		continue:($tr(ElementData1,"-\—","") = "")
	 	
		s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
		for j=1:1:$l(Values1,"\") {
			s Value1=$p(Values1,"\",j)		//循环Values1中包含的每一个值
			if ElementData1=Value1 
			{
				s:(ElementData2=Value2) ret=-1
			}
		}
	}
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElements1_"\"_AElement2_"\"_AElement3)
	q ret_"@"_ElementCode
}

/// Creator:YHY  二次修改原因：第二个参数不支持多值
/// Desc :手术费用不为空时，要求手术名称或操作必填
/// Input:AEpisodeID:就诊号
///       AElements1 手术名称和操作rowid
/// OutPut:-1触犯，1检查通过
/// Debug: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0011(AEpisodeID,"")
ClassMethod IsUnify0011(AEpisodeID As %String, AElements1 As %String) As %String
{
	s ret = 0
	q:((AEpisodeID = "")||(AElements1 = "")) ret
	s ret = 1
	
	s result = "",HisFee="",HisOpsFee=""
	///取his手术治疗费//手术治疗费^321.00
	s result = ##class(EPRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareNew(AEpisodeID,"")
	q:(result="") ret
	//s HisFee = $p(result,"!",11)  //修改这一行
	s HisFee = $p(result,"!",10)
	s HisOpsFee = $p(HisFee,"^",3)
	q:HisOpsFee="" ret
	//修改方法IsUnify0011，修改原因：第二个参数不支持多值
	s (ElementData1,ElementData2,Element1)=""
	for i=1:1:$l(AElements1,"\")
	{
		s Element1 = $p(AElements1,"\",i)
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element1,"")
		//只要一个不为空就可以
		s ElementData2=ElementData2_""_ElementData1
		
	}
    //s Elementdata1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
    s:((HisOpsFee'="0.00")&&(ElementData2="")) ret=-1
    
    s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElements1)
	q ret_"@"_ElementCode
}

/// Creator:YHY
/// Modify By HKY 20171102
/// Desc:	判断病案首页{手术信息:手术名称1,手术日期,术者,1助等}是否一致;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为一条手术信息模板单元RowID字符串,多个以"\"分隔; 
/// 		ASites指手术名称在模板单元RowID字符串中的位置，默认为第一个;
/// Return:	ret<0:不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0013("","")
ClassMethod IsUnify0013(AEpisodeID As %String, AElements As %String, ASites As %String = 1) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElements = "") ret
	
	s OperName = $p(AElements,"\",ASites)     //手术名称模板rowid
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,OperName,"")
	q:($tr(ElementData,"-\—","")="") ret
	
	s ElementName="",ElementDataNew=""
	s num=$l(AElements,"\")
	for Ind = 1:1:num 
	{
		s ElementName = $p(AElements,"\",Ind)
		s ElementDataNew = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementName,"")
		s:($tr(ElementDataNew,"-\—","")="") ret=-1
		q:(ret=-1)
	}
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElements)
	q ret_"@"_ElementCode
}

/// Creator:HKY
/// Desc: 病案首页必填项单元不允许只填写空格
/// Input:AEpisodeID:就诊号
///       AElement:必填项模板单元RowID
///       ANoValue ：单元不允许对应的值
/// OutPut:-1触犯，1检查通过
/// Debug: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0014()
ClassMethod IsUnify0014(AEpisodeID As %String, AElement As %String, ANoValue As %String) As %String
{
	s ret = 0
	q:((AEpisodeID = "")||(AElement = "")) ret
	s ret = 1
    s Elementdata=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
    //q:Elementdata=""
    s Elementdata=$tr(Elementdata,ANoValue,"")
    s len=$l(Elementdata)
    s:(len= 0) ret=-1
    
    s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement)
	q ret_"@"_ElementCode
}

/// ****************************************************************
/// 说明: 同一模板中两元素一致性判断，当Element1*包含*Values1中值时，Element2元素为空或不包含Values2中值时触发(前肯后非)
/// 		如： "主要诊断"的编码为"s"、"t"打头时，"损伤中毒"不能为"无",取编码时，Element1以"EC"开头
/// 		注：Element1,Element2为单值；Values1,Values2为多值,以"/"作为分隔符
/// lxf
/// 结论: ret<0 
/// 调试: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0015(EpisodeID,Element1,Element2,Values1,Values2)
/// ****************************************************************
ClassMethod IsUnify0015(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AValues1 As %String, AValues2 As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="") ret
	
	s ret=1
	s Elementdata=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:($tr(ElementData1,"-\—\ ","")="") ret
	
	//s ElementData1=$e(ElementData1,3,$l(ElementData1))
	//s ElementData1=$tr(ElementData1," ","")
	//q:ElementData1="" ret   //Element1为空时不检查，非空由完整性规则去判断
	s flag1=""
	f j=1:1:$l(AValues1,"\") d
	.s Value1=$p(AValues1,"\",j)
	.s Value1=$tr(Value1," ","")
	.s:ElementData1[Value1 flag1=1
	q:flag1="" ret
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	q:($tr(ElementData1,"-\—\ ","")="") ret
	
	//s ElementData2=$e(ElementData2,3,$l(ElementData2))
	//s ElementData2=$tr(ElementData2," ","")
	//s:(ElementData2="")||(ElementData2="--") ret=-1
	
	s flag2=""			 
	i (flag1=1)&&(AValues2'="") d
	.f j=1:1:$l(AValues2,"\") d
	..s Valque2=$p(Values2,"\",j)
	..s Value2=$tr(Value2," ","")
	..s:ElementData2[Value2 flag2=1
    s:(flag2="") ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// Creator:HKY
/// 说明: 同一模板中多元素一致性判断，当Element1为Values1中任意各值，Elements2为Value2中任意值时触发
/// 		AElement1，AElement2为单值；， AValues1和AValues2为多值
/// 结论: ret<0 
/// 当血型选择"A"、“B"、”O“的时候，RH不能选择”未查“，当血型选择选择”未查“的时候，RH不能选择”阴“或”阳“
/// 病案首页.【国籍】为中国时，【民族】不允许为“99-其他”
/// 调试: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0016(EpisodeID,Element1,Element2,Values1,Values2)
ClassMethod IsUnify0016(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AValues1 As %String, AValues2 As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AValues1="")||(AValues2="") ret
	
	s ret=1 
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	//q:(ElementData1 = "") ret
	s:(AValues1="") ElementData1=$tr(ElementData1,"-\—\ ")
 
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	s:(AValues2="") ElementData2=$tr(ElementData2,"-\—\ ")
	//q:(ElementData2="") ret
	
	s flag1=0,flag2=0 
	for i=1:1:$l(AValues1,"\") {
		   s Value1=$p(AValues1,"\",i)
			s:(ElementData1=Value1) flag1=1
    }
    
    for j=1:1:$l(AValues2,"\") {
		 s Value2=$p(AValues2,"\",j)
			s:(ElementData2[Value2) flag2=1
    }
   
    s:((flag1=1)&&(flag2=1)) ret=-1
    
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// 身份证验证
/// add by HKY 20171102
/// 通过身份证规则验证身份证是否合理  
/// 身份证进行验证默认18位
/// Input:ArgExtValues:身份证特殊值，ArgLengthNums：身份证位数，配置为“18\15”
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0017()
ClassMethod IsUnify0017(ArgEpisodeID As %String, ArgElement1 As %String, ArgExtValues As %String = "", ArgLengthNums As %String = "18") As %String
{

	s ret=0
	q:(ArgEpisodeID="")||(ArgElement1="")
	
	//患者入院登记身份类型非身份证，则不判断
	s PatCardType=""
	s PatCardType = ##Class(EPRservice.Quality.DataGather.AdmInfo).GetPatCardType(ArgEpisodeID)
	q:(PatCardType'="身份证") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement1,"")
	
	//验证特殊值
	s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
	s ExtInd=1
	for 
	{
		s ExtValue=$listget(ExtValuels,ExtInd)
		q:ExtValue=""
		
		s:(ElementData1=ExtValue) ret=1
		s ExtInd=ExtInd+1	
	}
	q:(ret=1) ret
	
	//长度验证
	s flag=0
	s IDCardLength=$l(ElementData1),LengthInd=1
	s LengthNumls = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgLengthNums,"\")
	for
	{
		s LengthNum=$listget(LengthNumls,LengthInd)
		q:LengthNum=""
		
		s:(IDCardLength = LengthNum) flag=1
		s LengthInd=LengthInd+1
	}
	s:(flag=0) ret=-1
	q:(ret=-1) ret
	
	s ret=1
	
	/// 9位，第一位为字母为H/M/R其余8位数字
	if (IDCardLength=9)
	{
		s FirstCardCode="H/M/R"
		s:(FirstCardCode'[$E(ElementData1,1,1)) ret=-1
		q:(ret=-1) ret
		
		for i=2:1:8 
		{
			s IDCardnum=$E(ElementData1,i)
			s numACode=$a(IDCardnum)
			s:(numACode<48)||(numACode>57) ret=-1
			q:(ret=-1)
		}
	}
	
	/// 10位，第一位为字母最后一位为括号; 或第一位为字母其余9位数字; 或第一位是数字，最后一位是括号
	if (IDCardLength=10)
	{
		s TypeFlag=0
		s FirstCardCode = $E(ElementData1,1,1)
		s TypeFlag = $match(FirstCardCode,"[A-Z]")  ///大写字母
		s:(TypeFlag=0)&&(($a(FirstCardCode)>=48)&&($a(FirstCardCode)<=57)) TypeFlag=2  //数字
		s:(TypeFlag=0) ret=-1  ///首字母不能小写
		q:(ret=-1)
		
		s flag=1
		if (TypeFlag=1)  ///字母
		{
			s:($E(ElementData1,8,8)'="(")||($E(ElementData1,10,10)'=")")||(($a($E(ElementData1,9))<48)||($a($E(ElementData1,9))>57)) flag=0  ///第一位为字母最后一位为括号，如(8)
			q:(flag=1) ret

                                                s flag=1
			for i=2:1:9   ///第一位为字母其余9位数字
			{
				s IDCardnum=$E(ElementData1,i)
				s numACode=$a(IDCardnum)
				s:(numACode<48)||(numACode>57) flag=0  
			}
			s:(flag=0) ret=-1
		}
		elseif (TypeFlag=2) ///数字
		{
			s:($E(ElementData1,8,8)'="(")||($E(ElementData1,10,10)'=")")||(($a($E(ElementData1,9))<48)||($a($E(ElementData1,9))>57)) flag=0  ///第一位是数字，最后一位是括号，如(8)
			s:(flag=0) ret=-1
		}
	}
	
		
	//验证 15为 身份证是否合理
	//仅验证身份证是否为15位纯数字
	if (IDCardLength=15)
	{
		for i=1:1:15 
		{
			s IDCardnum=$E(ElementData1,i)
			
			s numACode=$a(IDCardnum)
			s:(numACode<48)||(numACode>57) ret=-1
		}
	}
	
	//验证 18位 身份证是否合理
	//校验规则是：
	//（1）十七位数字本体码加权求和公式 
	//S = Sum(Ai * Wi), i = 0, ... , 16 ，先对前17位数字的权求和 
	//Ai:表示第i位置上的身份证号码数字值 
	//Wi:表示第i位置上的加权因子 
	//Wi: 7 9 10 5 8 4 2 1 6 3 7 9 10 5 8 4 2 
	//（2）计算模 
	//Y = mod(S, 11) 
	//（3）通过模得到对应的校验码 
	//Y: 0 1 2 3 4 5 6 7 8 9 10 
	//校验码: 1 0 X 9 8 7 6 5 4 3 2
	
	if (IDCardLength=18)
	{
		//初始化验证
		s WList=$lb("7","9","10","5","8","4","2","1","6","3","7","9","10","5","8","4","2")
		s YList=$lb("1","0","X","9","8","7","6","5","4","3","2")
		s Sum=0
		s i=1
		//求权和
		f i=1:1:17 
		{
			s IDCardnum=$e(ElementData1,i)
			s Wnum=$listget(WList,i)
			s Sum=IDCardnum*Wnum+Sum
		}
		//取验证码
		s CardNum18=$listget(YList,Sum#11+1)
		//验证
		i CardNum18'=$e(ElementData1,18) s ret=-1
	}
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ArgElement1)
	q ret_"@"_ElementCode
}

/// 身份证验证
/// add by HKY 20171102
/// 验证身份证与出生日期是否一致
/// Input:ArgElement1:身份证单元，ArgElement2：出生日期单元，ArgExtValues:身份证特殊值，
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0018()
ClassMethod IsUnify0018(ArgEpisodeID As %String, ArgElement1 As %String, ArgElement2 As %String, ArgExtValues As %String = "") As %String
{
	s ret=0

	q:(ArgEpisodeID="")||(ArgElement1="")||(ArgElement2="") ret
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement1,"")
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement2,"")
	q:($tr(ElementData2,"-\—\ ","")="") ret
	s ElementData2=$tr(ElementData2,"年\月","-")
	s ElementData2=$tr(ElementData2,"日","")
	
	//身份证验证特殊值
	s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
	s ExtInd=1
	for {	
			s ExtValue=$listget(ExtValuels,ExtInd)
			q:ExtValue=""
			s:(ElementData1=ExtValue) ret=1
			s ExtInd=ExtInd+1	
	}
	
	q:(ret=1) ret
	
	s ret=1,birthday="",csrq=""
	s IDCardLength=$l(ElementData1)
	s:(IDCardLength=15) birthday=$e(ElementData1,7,12)
	s:(IDCardLength=15) csrq=$e($p(ElementData2,"-",1),3,4)_$p(ElementData2,"-",2)_$p(ElementData2,"-",3)
	s:(IDCardLength=18) birthday=$e(ElementData1,7,14)
	s:(IDCardLength=18) csrq=$p(ElementData2,"-",1)_$p(ElementData2,"-",2)_$p(ElementData2,"-",3)
	s:(birthday'=csrq) ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ArgElement1_"\"_ArgElement2)
	q ret_"@"_ElementCode
}

/// 电子病历首页出院诊断不能出现“V01-V98”区段的编码，
/// 损伤、中毒的外部原因编码中只能出现“V01-V98”区段的编码，
/// 病理诊断中只能出现“M”编码
/// isnt1（"="或者"<>"）
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0019(EpisodeID,10332,"V","=")
ClassMethod IsUnify0019(ArgEpisodeID As %String, ArgElement As %String, AValues As %String, Aisnt As %String, ArgExtValues As %String = "", AHisDeathDateTime As %String = "") As %String
{
	s ret=0
   
	q:(ArgEpisodeID="")||(ArgElement="")||(Aisnt="") ret
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement,"")
	q:($tr(ElementData,"-\—\ ","")="") ret
    s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
	s ExtInd=1
	for {	
			s ExtValue=$listget(ExtValuels,ExtInd)
			q:ExtValue=""
			s:(ElementData1[ExtValue) ret=1
			s ExtInd=ExtInd+1	
	}
	
	q:(ret=1) ret
	s ret=1
	s flag=0
	if (Aisnt="<>")
	{
	 for j=1:1:$l(AValues,"\") {
		 s Value=$p(AValues,"\",j)
			s:(ElementData[Value) flag=1
    }
	}
	elseif (Aisnt="=")
	{
		
		for j=1:1:$l(AValues,"\") {
		 s Value=$p(AValues,"\",j)
				s:(ElementData'[Value) flag=1
		}			
	}
	s:(flag=1) ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ArgElement)
	q ret_"@"_ElementCode
}

/// (入院日期-出生日期)与换算年龄不符
/// (入院日期-出生日期)<365天时，年龄（岁）只能为0
/// (入院日期-出生日期)<365天时，必须按年龄不足一周岁的格式填写
/// ArgElement1:入院日期，ArgElement2：出生日期，ArgElement3：年龄，ArgElement4：年龄（月）,ArgElement5:年龄(天)
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0020()
ClassMethod IsUnify0020(ArgEpisodeID As %String, ArgElement1 As %String, ArgElement2 As %String, ArgElement3 As %String, ArgElement4 As %String = "", ArgElement5 As %String = "") As %String
{
	s ret=0
   
	q:(ArgEpisodeID="")||(ArgElement1="")||(ArgElement2="")||(ArgElement2="") ret
	
	//入院日期
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement1,"")
	q:($tr(ElementData1,"-\—\ ","")="") ret
	s ElementData1=$p(ElementData1," ",1)
	
	//出生日期
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement2,"")
	q:($tr(ElementData2,"-\—\ ","")="") ret
	
	//年龄
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement3,"")
	q:($tr(ElementData3,"-\—\ ","")="") ret
	
	s age=""
	s age=+$e(ElementData3,1,$l(ElementData3)-1)
	
	s ret=1,temdate=""
	s ryrq=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData1)
	s csrq=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData2)
	s temdate=ryrq-csrq
	//(入院日期-出生日期)<365天时，年龄（岁）只能为0
	s:(temdate<365)&&(age'=0) ret=-1
	//(入院日期-出生日期)<365天时，必须按年龄不足一周岁的格式填写
	
	//年龄(月)
	if (ArgElement4'="")
	{
		s ElementData4=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement4,"")
		s:(temdate<365)&&($tr(ElementData4,"-\—","")="") ret=-1
	}
	
	//年龄（天）
	if (ArgElement5'="")
	{
		s ElementData5=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement5,"")
		s:(temdate<365)&&($tr(ElementData5,"-\—","")="") ret=-1
	}
	q:(ret=-1) ret
	
	s tmpage=""
	s:(temdate>365) tmpage=$e(temdate/365,1,$l(ElementData3)-1)
	q:(tmpage="") ret
	
	//(入院日期-出生日期)与换算年龄不符
	s:(tmpage'=age)&&(age'=(tmpage+1)) ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ArgElement1_"\"_ArgElement2_"\"_ArgElement3_"\"_ArgElement4_"\"_ArgElement5)
	q ret_"@"_ElementCode
}

/// 患者年龄不足28天必须填写新生儿入院体重及出生体重
/// Input:ArgElement1:年龄，ArgElement2：新生儿入院体重，ArgElement3：新生儿出院体重,ArgElement4:年龄(天) （注：没有此单元不需要配置）
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0021(EpisodeID,10313,10317,10318)
ClassMethod IsUnify0021(ArgEpisodeID As %String, ArgElement1 As %String, ArgRegDate As %String, ArgElement2 As %String, ArgElement3 As %String, ArgElement4 As %String = "")
{
	s ret=0,flag1=0,flag2=0
	//年龄天数=(入院日期-出生日期)
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement1,"")  //出生日期
	q:($tr(ElementData1,"-\—\ ","")="") ret
	
	s RegDate=""
	s RegDate=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgRegDate,"")  //入院日期
	q:($tr(RegDate,"-\—\ ","")="") ret
	
	s Birthday=""
	s Birthday=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData1)
	s Birthday=$p(Birthday," ",1)
	
	s RegDate=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(RegDate)
	s RegDate=$p(RegDate," ",1)
	q:((RegDate-Birthday)>=28) ret  //大于28天不质控此规则
	
	s flag1=1
	//新生儿入院体重
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement2,"")
	//新生儿出院体重
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement3,"")
	s ret=1

	s:(flag1=1)&&($tr(ElementData2,"-\—\ ","")="") ret=-1
	s:(flag1=1)&&($tr(ElementData3,"-\—\ ","")="") ret=-1
	
	if (ArgElement4'="")
	{
		s ElementData4=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement4,"")
		s:(ElementData4<28) flag2=1
	}
	s:(flag2=1)&&($tr(ElementData2,"-\—\ ","")="") ret=-1
	s:(flag2=1)&&($tr(ElementData3,"-\—\ ","")="") ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ArgElement1_"\"_ArgElement2_"\"_ArgElement3_"\"_ArgElement4)
	q ret_"@"_ElementCode
}

/// 主要诊断编码包含Z37的，必须填写新生儿出生体重
/// Input:ArgElement1:主要诊断，AValue:包含的值，ArgElement2：新生儿出院体重
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0022(EpisodeID,10313,"Z37",10317)
ClassMethod IsUnify0022(ArgEpisodeID As %String, ArgElement1 As %String, AValue As %String, ArgElement2 As %String)
{
	s ret=0
	//主要诊断
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement1,"")
	q:($tr(ElementData1,"-\—\ ","")="") ret
	
	//新生儿出院体重
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement2,"")
	
	s ret=1
	s:(ElementData1[AValue)&&(($tr(ElementData1,"-\—\ ","")="")) ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ArgElement1_"\"_ArgElement2)
	q ret_"@"_ElementCode
}

/// 病案首页.患者年龄不足14周岁婚姻不可以为已婚、离婚或丧偶
/// 病案首页.【年龄】小于14岁时，【联系人关系】不允许为夫妻、子女、孙子女
/// 病案首页.12岁及以下儿童【出院诊断】不允许为C50-C63(乳房、女性及男性生殖器恶性肿瘤)
/// Input:AElement1:年龄，AElement2:婚姻
/// 当Element1小于指定的AValues1年纪，Elements2为Value2中任意值时触发
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0023()
ClassMethod IsUnify0023(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AValues1 As %String, ANoValues2 As %String) As %String
{
	s ret=0
	s flag1=0,flag2=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AValues1="") ret
	
	s ret=1 , age=""
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	if (ElementData1["岁")
	{
		s age=+ElementData1
		s:(age>AValues1) flag1=0
	}
	else
	{
		s flag1 = 1
	}
	q:(flag1=0) ret  ///年龄大于14岁
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	q:($tr(ElementData2,"-\—\ ","")="") ret

	for j=1:1:$l(ANoValues2,"\") 
	{
		s Value2=$p(ANoValues2,"\",j)
		s:(ElementData2[Value2) flag2=1
		q:(flag2=1)
    }
    s:(flag2=1) ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3_"\"_AElement4)
	q ret_"@"_ElementCode
}

/// 病案首页.电话长度必须为11位或7位
/// InPut:AElement:电话单元编码，AValues：指定的位数（可以为多个用“\”分隔）
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0024(EpisodeID,10024,"11\7")
ClassMethod IsUnify0024(AEpisodeID As %String, AElement As %String, AValues As %String)
{
	
	s ret=0
	q:(AEpisodeID="")||(AElement="") ret
	s ret=1 
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
	q:($tr(ElementData,"-\—\ ","")="") ret
	
	s length=$l(ElementData)
	s flag=0
	for i=1:1:$l(AValues,"\")
	 {
		s Value=$p(AValues,"\",i)
	    s:(length=Value) flag=1
    }
    s:(flag=0) ret=-1
    
    s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement)
	q ret_"@"_ElementCode
}

/// 出院日期应大于等于入院日期
/// 质控日期应大于等于出院时间，且在出院后五天内
/// AElement1:两日期比较中较大的日期单元,AElement2:两日期中比较小的日期单元，ArgExtValues：在出院后多少天
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0025(EpisodeID,10313,10316,5)
ClassMethod IsUnify0025(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, ArgExtValues As %String = "0")
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="") ret

	//出院日期或质控日期
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:($tr(ElementData1,"-\—\ ","")="") ret
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	q:($tr(ElementData2,"-\—\ ","")="") ret
	
	s ret=1,Date1="",Date2=""
	s Date1=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData1)
	s Date1=$p(Date1," ",1)
	s Date2=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData2)
	s Date2=$p(Date2," ",1)
	
	s:(Date1<Date2) ret=-1
	if (ArgExtValues'="")
	{
		s:(Date1>(Date2+ArgExtValues)) ret=-1
	}
    
    s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// 病案首页.【手术操作时间】应介于【入院时间】与【出院时间】之间
/// 病案首页.入院【确诊日期】应大于【入院日期】，小于【出院日期】
/// AElement1:入院日期，AElement2：出院日期，AElement3：手术操作日期/确诊日期
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0026(EpisodeID,10313,10316,10317)
ClassMethod IsUnify0026(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String)
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="") ret
	s ret=1 
	//入院日期
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:($tr(ElementData1,"-\—\ ","")="") ret
	s ElementData1=$p(ElementData1," ",1)
	
	//出院日期
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	q:($tr(ElementData2,"-\—\ ","")="") ret
	s ElementData2=$p(ElementData2," ",1)
	
	//手术操作日期
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement3,"")
	q:($tr(ElementData3,"-\—\ ","")="") ret
	s ElementData3=$p(ElementData3," ",1)
	
	s Date1="",Date2="",Date3=""
	s Date1=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData1)
	s Date2=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData2)
	s Date3=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData3)
	s:(Date3<Date1)||(Date3>Date2) ret=-1
	
    s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
	q ret_"@"_ElementCode
}

/// 出院诊断各项填写不完整（有填写诊断，其疾病编码和入院病情不为空）
/// AElement1:出院诊断,AElement2：疾病编码，AElement3：入院病情
ClassMethod IsUnify0027(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String)
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AElement3="") ret
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:($tr(ElementData1,"-\—\ ","")="") ret
	
	s ret=1
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement3,"")
	s:($tr(ElementData2,"-\—\ ","")="")||($tr(ElementData3,"-\—\ ","")="") ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
	q ret_"@"_ElementCode
}

/// 年龄大于28天，主要诊断和次要诊断编码中不能出现P00—P96
/// Input:AElement1：年龄,AElement2:年龄(天)，AElement3：诊断,AValues：指定的不能出现的诊断编码，ArgExtValues：诊断例外
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck)IsUnify0028(EpisodeID,10472,10473,10332,"P","P97\P98\P99")
ClassMethod IsUnify0028(ArgEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, ANoValues As %String, ArgExtValues As %String)
{
	s ret=0,flag1=0
   
	q:(ArgEpisodeID="")||(AElement1="")||(AElement3="")||(ANoValues="") ret
	
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,AElement3,"")
    q:($tr(ElementData3,"-\—\ ","")="") ret
    
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,AElement1,"")
	s:(AElement2'="") ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,AElement2,"")
    q:(AElement2'="")&&(+ElementData2<28) ret
	
	if (ElementData1["天") 
	{
		s age=$e(ElementData1,1,$l(ElementData1)-1)
	    s:(age<28) flag1=1
	}
	s:(ElementData1["小时") flag1=1
	q:(flag1=1) ret
	
    s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
	s ExtInd=1
	for {	
			s ExtValue=$listget(ExtValuels,ExtInd)
			q:ExtValue=""
			s:(ElementData3[ExtValue) ret=1
			s ExtInd=ExtInd+1	
	}
	q:(ret=1) ret
	
	s ret=1
	s:(ElementData3[ANoValues) ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
	q ret_"@"_ElementCode
}

/// 病案首页.性别为男，门急诊诊断、主要诊断和其他诊断中不应出现女性化疾病诊断名称(C51-C58,N70-N77,N80-N98,O00-O99)
/// 病案首页.性别为女，门急诊诊断、主要诊断和其他诊断中不应出现男性化疾病诊断名称（C60-C63,N40-N51）
/// Input:AGender：指定的性别，AElement1：性别单元编码，AElement2门急诊诊断编码，AElement3主要诊断编码,AElement4诊断其他编码,ANoValues：指定的不能出现的诊断编码，ArgExtValues：诊断例外
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0029(EpisodeID,"女","10319","C60\C61\C62\C63\N4\N51","")
ClassMethod IsUnify0029(ArgEpisodeID As %String, AGender As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, AElement4 As %String, ANoValues As %String, ArgExtValues As %String)
{
	s ret=0,flag1=0,flag2=0,flag3=0,ElementCode=""
   
	q:(ArgEpisodeID="")||(AElement1="")||(AElement2="")||(AElement3="")||(AElement4="")||(ANoValues="") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,AElement1,"")
	q:($tr(ElementData1,"-\—\ ","")="") ret
	q:(ElementData1'=AGender) ret
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,AElement2,"")
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,AElement3,"")
	s ElementData4=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,AElement4,"")
	
    s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
	s ExtInd=1
	for {	
			s ExtValue=$listget(ExtValuels,ExtInd)
			q:ExtValue=""
			s:(ElementData2[ExtValue) flag1=1
			s:(ElementData3[ExtValue) flag2=1
			s:(ElementData4[ExtValue) flag3=1
			s ExtInd=ExtInd+1	
	}
	s:((flag1=1)&&(flag2=1)&&(flag3=1)) ret=1
	q:(ret=1) ret
	
	s ret=1
	s NoValues=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ANoValues,"\")
	s Ind=1
	for {	
			s NoValue=$listget(NoValues,Ind)
			q:NoValue=""
			if ($tr(ElementData2,"-\—\ ","")'="")&&(ElementData2[NoValue)&&(flag1'=1) 
			{
				s ret=-1
				s ElementCode=AElement2
			}
			if ($tr(ElementData3,"-\—\ ","")'="")&&(ElementData3[NoValue)&&(flag2'=1) 
			{
				s ret=-1
				s:(ElementCode'="") ElementCode=ElementCode_"\"_AElement3
				s:(ElementCode="") ElementCode=AElement3
			}
			if ($tr(ElementData4,"-\—\ ","")'="")&&(ElementData4[NoValue)&&(flag3'=1) 
			{
				s ret=-1
				s:(ElementCode'="") ElementCode=ElementCode_"\"_AElement4
				s:(ElementCode="") ElementCode=AElement4
			}
			s Ind=Ind+1	
	}
	
	
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3_"\"_AElement4)
	q ret_"@"_ElementCode
}

/// 病案首页.出院诊断编码包含有S00—S99、T00—T98的患者，“损伤、中毒的外部原因”必填
/// 病案首页.【主要诊断编码】是C开头的诊断，【临床分期】不允许为空。
/// Input:AElement1:诊断编码单元，AElement2：损伤、中毒的外部原因单元，AValues；编码中指定包含的值，ArgExtValues：诊断例外
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0030(EpisodeID,10332,"10111","C","")
ClassMethod IsUnify0030(ArgEpisodeID As %String, AElement1 As %String, AElement2 As %String, AValues As %String, ArgExtValues As %String)
{
	s ret=0
	
	q:(ArgEpisodeID="")||(AElement1="")||(AElement2="")||(AValues="") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,AElement1,"")
	q:($tr(ElementData1,"-\—\ ","")="") ret
	
	s Values=##Class(EPRservice.Quality.CommonHelper).GetListFromString(AValues,"\")
	s flag=0
	s Ind=1
	for {	
			s Value=$listget(Values,Ind)
			q:Value=""
			s:(ElementData1[Value) flag=1
			s Ind=Ind+1	
	}
	q:(flag=0) ret

	s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
	s ExtInd=1
	for {	
			s ExtValue=$listget(ExtValuels,ExtInd)
			q:ExtValue=""
			
			s:(ElementData1[ExtValue) ret=1
			s ExtInd=ExtInd+1	
	}
	q:(ret=1) ret
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,AElement2,"")
	s:($tr(ElementData2,"-\—\ ","")="") ret=-1

	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// 说明: 病案首页.新生儿出生体重应精确到10g
///  AElements为多个用"^"分割
/// 结论: ret<0 
/// 调试: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0032(EpisodeID,"10320")
/// AElement1 以"^"分割
ClassMethod IsUnify0032(AEpisodeID As %String, AElement As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement="") ret
	
	s ret=1
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
	q:($tr(ElementData,"-\—\ ","")="") ret
	
	s:((ElementData/10)[".") ret=-1

	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement)
	q ret_"@"_ElementCode
}

/// 病案首页.出院【主要诊断编码】包含有C00—C97、D00—D48并且做了手术的患者，【病理诊断】不允许为空
/// Input:AIsOperPat：公共函数中HIS手术申请单时间接口（不为空：手术患者，为空：非手术患者），AElement1:主要诊断编码单元，AElement2：病理诊断单元，AValues；编码中指定包含的值，ArgExtValues：诊断例外
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0034()
ClassMethod IsUnify0033(AEpisodeID As %String, AHISPatOPArranges As %String, AElement1 As %String, AElement2 As %String, AValues As %String, ArgExtValues As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AHISPatOPArranges="")||(AElement1="")||(AElement2="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:($tr(ElementData1,"-\—\ ","")="") ret
	
	s Values=##Class(EPRservice.Quality.CommonHelper).GetListFromString(AValues,"\")
	s flag=0
	s Ind=1
	for {	
			s Value=$listget(Values,Ind)
			q:Value=""
			s:(ElementData1[Value) flag=1
			s Ind=Ind+1	
	}
	q:(flag=0) ret

	s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
	s ExtInd=1
	for {	
			s ExtValue=$listget(ExtValuels,ExtInd)
			q:ExtValue=""
			
			s:(ElementData1[ExtValue) ret=1
			s ExtInd=ExtInd+1	
	}
	q:(ret=1) ret
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	s:($tr(ElementData2,"-\—\ ","")="") ret=-1

	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// 病案首页.【入院科室】为产科且【出院诊断编码】包含'z37.001'、'z37.002’、'z37.201—'z37.203’、'z37.301’、'z37.501’、'z37.502’、'z37.601’、'z37.901—z37.904’则【新生儿出生体重】不允许为空
/// Input:AElement1:入院科室，AElement2：出院诊断编码，AElement3：新生儿出生体重，AElement4：新生儿入院体重，AValue1s：指定的入院科室，AValue2s；编码中指定包含的值，ArgExtValues：诊断例外
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0034(EpisodeID,10314,10332,10573,"产科","Z37.001\Z37.002\Z37.201\Z37.202\Z37.203\Z37.301\Z37.501\Z37.502\Z37.601\Z37.901\Z37.902\Z37.903\Z37.904","")
ClassMethod IsUnify0034(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, AElement4 As %String, AValue1s As %String, AValue2s As %String, ArgExtValues As %String = "") As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1=0)||(AElement2="")||(AElement3="") ret
	
	s AValue2s="Z37.000\Z37.001\Z37.002\Z37.201\Z37.202\Z37.203\Z37.301\Z37.501\Z37.502\Z37.601\Z37.901\Z37.902\Z37.903\Z37.904"

	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:($tr(ElementData1,"-\—\ ","")="") ret
	
	s Value1s=##Class(EPRservice.Quality.CommonHelper).GetListFromString(AValue1s,"\")
	s flag1=0
	s Ind1=1
	for {	
			s Value1=$listget(Value1s,Ind1)
			q:Value1=""
			s:(ElementData1[Value1) flag1=1
			s Ind1=Ind1+1	
	}
	q:(flag1=0) ret
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	q:($tr(ElementData2,"-\—\ ","")="") ret
	
	s Value2s=##Class(EPRservice.Quality.CommonHelper).GetListFromString(AValue2s,"\")
	s flag2=0
	s Ind2=1
	for {	
			s Value2=$listget(Value2s,Ind2)
			q:Value2=""
			s:(ElementData2[Value2) flag2=1
			s Ind2=Ind2+1	
	}
	q:(flag2=0) ret
    
	s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
	s ExtInd=1
	for {	
			s ExtValue=$listget(ExtValuels,ExtInd)
			q:ExtValue=""
			
			s:(ElementData2[ExtValue) ret=1
			s ExtInd=ExtInd+1	
	}
	q:(ret=1) ret
	
	s ret=1
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement3,"")
	s:($tr(ElementData3,"-\—\ ","")="") ret=-1
    s ElementData4=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement4,"")
	s:($tr(ElementData4,"-\—\ ","")="") ret=-1

	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3_"\"_AElement4)
	q ret_"@"_ElementCode
}

/// 病案首页.【（不足一周岁）年龄】小于28天新生儿，疾病请用新生儿诊断（新生儿诊断编码应为P开头）
/// Input:AElement1：年龄,AElement2:年龄(天)，AElement3：诊断,AValues：指定必须包含的诊断编码，ArgExtValues：诊断例外
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0035(EpisodeID,10472,10473,10332,"P","")
ClassMethod IsUnify0035(ArgEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, AValues As %String, ArgExtValues As %String)
{
	s ret=0,flag1=0
   
	q:(ArgEpisodeID="")||(AElement1="")||(AElement3="")||(AValues="") ret
	
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,AElement3,"")
    q:($tr(ElementData3,"-\—\ ","")="") ret
    
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,AElement1,"")
	if (ElementData1["天") 
	{
		s age=$e(ElementData1,1,$l(ElementData1)-1)
	    s:(age<28) flag1=1
	}
	s:(ElementData1["小时") flag1=1
	q:(flag1=0) ret
	
	s ElementData2=""
	s:(AElement2'="") ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,AElement2,"")
	q:((AElement2'="")&&(ElementData2>28)) ret
	
    s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
	s ExtInd=1
	for {	
			s ExtValue=$listget(ExtValuels,ExtInd)
			q:ExtValue=""
			s:(ElementData3[ExtValue) ret=1
			s ExtInd=ExtInd+1	
	}
	q:(ret=1) ret
	
	s ret=1
	s:(ElementData3'[AValues) ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
	q ret_"@"_ElementCode
}

/// 病案首页.【主要诊断】和【其他诊断】不允许重复
/// Input:AElements:诊断单元（可将出院诊断单元全部维护进去，用"\"分隔）
/// w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0036(6112,"10472\10473\10474")
ClassMethod IsUnify0036(ArgEpisodeID As %String, AElements As %String)
{
	s ret=0
   
	q:(ArgEpisodeID="")||(AElements="") ret
	
	s diagEleList=$lfs(AElements,"\")
	SET ptr=0,count=0,diagValueList=""
	s ret=1
	WHILE $LISTNEXT(diagEleList,ptr,eleCode) 
	{
		s count=count+1
		//逐项取值,不一向依据代码取值
		s diagNoseValue=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,eleCode,"") 
		if '$listfind(diagValueList,diagNoseValue)
		{
			s diagValueList=diagValueList_$lb(diagNoseValue)
		}
		elseif ($listfind(diagValueList,diagNoseValue)&&(diagNoseValue'=""))
		{
			s ret=-1
			q
		}
	}
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(eleCode)
	q ret_"@"_ElementCode
}

/// 病案首页.护士未做最终结算，则不允许打印首页
/// AHisInterface:HIS最终结算时间（不为空：做完最终结算，为空：未做最终结算）
ClassMethod IsUnify0037(ArgEpisodeID As %String, AHISDischTime2 As %String)
{
	s ret=0
   
	q:(ArgEpisodeID="") ret
	
	s ret=1
	s:(AHISDischTime2="") ret=-1
	
	q ret
}

/// 病案首页.首页费用没有同步，则不允许打印首页。
/// Input:AElementID1:总费用单元编码，AElementID2：自付金额单元编码
/// 调试: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0038(AEpisodeID,AElementID1,AElementID2)
ClassMethod IsUnify0038(ArgEpisodeID As %String, AElementID1 As %String, AElementID2 As %String) As %String
{
	s ret = 0 , FeeData=""
	q:(ArgEpisodeID = "")||(AElementID1="")||(AElementID2="") ret
	
    s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,AElementID1,"")
	s ElementData1=$tr(ElementData1,"-\—\ ","")
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,AElementID2,"")
	s ElementData2=$tr(ElementData2,"-\—\ ","")
	q:(ElementData1="")||(ElementData2="") ret
	
	s ElementData=ElementData1_","_ElementData2
	
	s FeeData=""
	// 患者费用(病案费用子类)
	s InPatFee="" , CheckTotal=""
	s InPatFee=##class(EMRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareSubNew(ArgEpisodeID,"DtHealth")
	//取总费用
	s CheckTotal=$p($p(InPatFee,"!",1),"^",3)
	//取自付费用
	s zffy=##class(web.DHCBillInterface).IGetIPCashPaySumByAdm(ArgEpisodeID)
	s FeeData=CheckTotal_","_zffy
	s:(ElementData'=FeeData) ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2)
	q ret_"@"_ElementCode
}

/// 病案首页附页未填写，则不允许打印病案首页
/// Input:ATemplateDocID:病案首页附页展现结构DocumentID(三版，条纹方块层ID),ATemplateID:首页附页模板ID
ClassMethod IsUnify0039(AEpisodeID As %String, ATemplateDocID As %String, ATemplateID As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(ATemplateDocID="")||(ATemplateID="") ret
	s ret=1
	s ECRecordID=""
	s ECRecordID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_ATemplateDocID,ECRecordID))
	s:(ECRecordID="") ret="-1"
	q:(ret=-1) ret
	
	s IsFinishDocument=""
	s IsFinishDocument=$d(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ECRecordID," "_ATemplateID," SAVE"))
	s:(IsFinishDocument'="10") ret="-1"
	
	q ret
}

/// 病案首页.请同时填写【联系人姓名】、【关系】、【住址】和【电话】，否则请删除内容
/// Input:AElementIDs:病历单元，其中任意一个值不为空，则必须全部填写(维护格式："10801\10802\10803\10804")
/// w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0040(6112,"10713\10714\10715\10716")
ClassMethod IsUnify0040(AEpisodeID As %String, AElementIDs As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="") ret
	s ret=1
	
    s ElementIDs=##Class(EPRservice.Quality.CommonHelper).GetListFromString(AElementIDs,"\")
	s flag=0
	s Ind=1
	for {	
			s ElementID=$listget(ElementIDs,Ind)
			q:ElementID=""
			s ElementValue=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
			s Ind=Ind+1	
			s:($tr(ElementValue,"-\—\ ","")'="") flag=flag+1
			s:((flag'=0)&&(flag'=(Ind-1))) ret=-1
	}
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementIDs)
	q ret_"@"_ElementCode
}

/// 病案首页.【入/出院科室】不一致，【转科科室】不允许为空，请检查。
/// Input: AEpisodeID:就诊号,AElementID1:入院科室,AElementID2:出院科室,AElementID3:转科科室
ClassMethod IsUnify0041(AEpisodeID As %String, AElementID1 As %String, AElementID2 As %String, AElementID3 As %String) As %String
{
	s ret="0^"
	q:(AElementID1="")||(AElementID2="")||(AElementID3="") ret
	
	s AdmLoc="",DischLoc=""
	s AdmLoc=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	s DischLoc=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID2,"")
	q:(AdmLoc=DischLoc) ret
	
	s ret=1
	s TransLoc=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID3,"")
	q:($tr(TransLoc,"-\—\ ","")'="") ret
	
	s ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2_"\"_AElementID3)
	q ret_"@"_ElementCode
}

/// 病案首页:【病理诊断费】大于0时，【病理号】不可为空，请检查。
/// Input: AEpisodeID:就诊号,AElementID1:病理诊断费,AElementID2:病理号
ClassMethod IsUnify0042(AEpisodeID As %String, AElementID1 As %String, AElementID2 As %String) As %String
{
	s ret="0^"
	q:(AElementID1="")||(AElementID2="") ret
	
	s ret="1^"
	s PhFee=""
	s PhFee=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	q:(+PhFee=0) ret
	
	s PhNo=""
	s PhNo=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID2,"")
	q:(PhNo'="") ret
	
	s ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2)
	q ret_"@"_ElementCode
}

/// 病案首页:【医疗付费方式】为职工医保时,【工作单位】和【工作单位电话】以及【工作邮编】不能为空，请检查。
/// Input: AEpisodeID:就诊号,AElementID1:离院方式,AElementIDs:病历单元，其中任意一个值不为空，则必须全部填写(多个用"\"分隔)。
ClassMethod IsUnify0043(AEpisodeID As %String, AElementID1 As %String, AElementIDs As %String) As %String
{
	s ret="0^"
	q:(AEpisodeID="")||(AElementID1="")||(AElementIDs="") ret
	
	s DischWay=""
	s DischWay=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	q:(DischWay'="城镇职工基本医疗保险") ret
	
	s elemIDList=$lfs(AElementIDs,"\")
	SET ptr=0,count=0,eleValueList=""
	WHILE $LISTNEXT(elemIDList,ptr,eleID) {
	
		//逐项取值,不一向依据代码取值
		s eleValue=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,eleID,"")  
		continue:(eleValue'="")
		s ret=-1
		q 
	}
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementIDs)
	q ret_"@"_ElementCode
}

/// 病案首页.【入院科别】为重症医学科时，【重症监护室名称】不得填写"6109.未入重症监护室"，请检查。
/// Input: AEpisodeID:就诊号,AElementID1:入院科室,AElementID2:重症监护室名称
ClassMethod IsUnify0044(AEpisodeID As %String, AElementID1 As %String, AElementID2 As %String) As %String
{
	s ret="0^"
	q:(AEpisodeID="")||(AElementID1="")||(AElementID2="") ret
	
	s AdmLoc=""
	s AdmLoc=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	q:(AdmLoc'="重症医学科") ret
	
	s ICUName=""
	s ICUName=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID2,"")  
	q:((ICUName'="未入重症监护室")&&($tr(ICUName,"-\—\ ","")'="")) ret
	
	//s ret="-1^病案首页.【入院科别】为重症医学科时，【重症监护室名称】不得填写6109.未入重症监护室，请检查。"
	s ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2)
	q ret_"@"_ElementCode
}

/// 病案首页.【重症监护室名称】不为"未入重症监护室"时，【进入时间2】和【退出时间2】必须填写，请检查。
/// Input: AEpisodeID:就诊号,AElementID1:重症监护室名称,AElementID2:进入时间,AElementID3:退出时间
ClassMethod IsUnify0045(AEpisodeID As %String, AElementID1 As %String, AElementID2 As %String, AElementID3 As %String) As %String
{
	s ret="0^"
	q:(AEpisodeID="")||(AElementID1="")||(AElementIDs="") ret
	
	s ICUName=""
	s ICUName=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	q:((ICUName'="未入重症监护室")&&($tr(ICUName,"-\—\ ","")'="")) ret
	
	s ICUInDateTime="",ICUOutDateTime=""
	s ICUInDateTime=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID2,"")  
	s ICUOutDateTime=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID3,"")  
	q:(($tr(ICUInDateTime,"-\—\ ","")'="")&&($tr(ICUInDateTime,"-\—\ ","")'="")) ret
	
	//s ret="-1^病案首页.【重症监护室名称】不为未入重症监护室时,【进入时间2】和【退出时间2】必须填写,请检查"
	s ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2_"\"_AElementID3)
	q ret_"@"_ElementCode
}

/// 病案首页.【质控日期】应大于【出院时间】，且在出院后三天内，请检查。
/// AElement1:质控日期，AElement2：出院时间，ADays：出院后几天内
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0026(EpisodeID,10313,{ADischDate},3)
ClassMethod IsUnify0046(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, ADays As %String = 3) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="") ret
	s ret=1 
	
	//质控日期
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:($tr(ElementData1,"-\—\ ","")="") ret
	
	//出院日期
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	q:($tr(ElementData2,"-\—\ ","")="") ret
  
	s Date1=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData1)
	s Date2=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData2)
	s Date1=$p(Date1," ",1)
	s Date2=$p(Date2," ",1)
	
	s:(Date1<Date2)||(Date1>(Date2+ADays)) ret=-1
	
    s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// 病案首页.入院【抢救次数】不得小于【抢救成功次数】，请检查。
/// AElement1:抢救次数，
/// AElement2:抢救成功次数
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0026(EpisodeID,10313,10314)
ClassMethod IsUnify0047(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="") ret
	s ret=1 
	//抢救次数，
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:($tr(ElementData1,"-\—\ ","")="") ret
	//抢救成功次数
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	q:($tr(ElementData2,"-\—\ ","")="") ret
	
	q:(+ElementData1=+ElementData2)||(+ElementData1=(+ElementData2+1)) ret
	
	//s ret="-1^"_"病案首页.入院【抢救次数】不得小于【抢救成功次数】，请检查。"
	s ret=-1
	
    s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// 病案首页.当【病理号】、【病理诊断】、【分化程度】或【肿瘤分期】不为空时，【临床与病理符合情况】不得填写"4-未做",请检查。
/// AEpisodeID:就诊号,ElementIDs:病历单元，其中任意一个值不为空，则必须全部填写(维护格式：10801\10802\10803\10804)
ClassMethod IsUnify0048(AEpisodeID As %String, AElementIDs As %String, AElementID1 As %String) As %String
{
	s elemIDList=$lfs(AElementIDs,"\")

	SET ptr=0,count=0,eleValueList="",flag=1
	WHILE $LISTNEXT(elemIDList,ptr,eleID) {
	
		//逐项取值,不一向依据代码取值
		s eleValue=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,eleID,"")  
		continue:(eleValue="")
		s flag=-1
		q 
	}
	q:(flag=1) ret
	
	//临床与病理符合情况
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	q:(ElementData1'="未做") ret
	
	//s ret="-1^"_"病案首页.当【病理号】、【病理诊断】、【分化程度】或【肿瘤分期】不为空时，【临床与病理符合情况】不得填写4-未做,请检查"
	s ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementIDs)
	q ret_"@"_ElementCode
}

/// 病案首页.死亡患者【主要诊断】不允许为Z51、Z49的诊断
/// Input:AHisDeathDateTime:公共函数中维护的患者死亡时间接口，ArgElement：主要诊断编码单元，AValues ：不允许出现的诊断编码值，ArgExtValues：例外的诊断编码
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0049(EpisodeID,{HisDeathTime},10332,"Z51\Z49","")
ClassMethod IsUnify0049(ArgEpisodeID As %String, AHisDeathDateTime As %String, ArgElement As %String, AValues As %String, ArgExtValues As %String = "") As %String
{
	s ret=0
   
	q:(ArgEpisodeID="")||(ArgElement="")||(AHisDeathDateTime="") ret
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement,"")
	q:($tr(ElementData,"-\—\ ","")="") ret
	
    s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
	s ExtInd=1
	for {	
			s ExtValue=$listget(ExtValuels,ExtInd)
			q:ExtValue=""
			s:(ElementData[ExtValue) ret=1
			s ExtInd=ExtInd+1	
	}
	q:(ret=1) ret
	
	s ret=1
	s flag=0
	for i=1:1:$l(AValues,"\") {
		s Value=$p(AValues,"\",i)
		s:(ElementData[Value) flag=1
		}
	s:(flag=1) ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ArgElement)
	q ret_"@"_ElementCode
}

/// 病案首页.【入院时间】应小于【首次病程记录记录时间】。
/// Input：AEpisodeID:就诊号,AElement1:病案首页入院时间,ATemplateDocID:首次病程记录展现结构DocumentID(三版，条纹方块层ID),ATemplateID:首页附页模板ID
/// w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0050()
ClassMethod IsUnify0050(AEpisodeID As %String, AElement1 As %String, ATemplateDocID As %String, ATemplateID As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(ATemplateDocID="")||(ATemplateID="")||(AElement1="") ret
	
	
	//入院时间
	s FPAdmDateTime=""
	s FPAdmDateTime=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:(FPAdmDateTime="") ret

	s ECRecordID=""
	s ECRecordID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_ATemplateDocID,ECRecordID))
	q:(ECRecordID="") ret
	
	s IsFinishDocument=""
	s IsFinishDocument=$d(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ECRecordID," "_ATemplateID," SAVE"))
	q:(IsFinishDocument'="10") ret
	
	s DocumentSubID=""
	s DocumentSubID=$o(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ECRecordID," "_ATemplateID," SAVE",""))
	q:(DocumentSubID="") ret
	
	s InstanceObj=##class(EMRinstance.InstanceData).%OpenId(ECRecordID_"||"_DocumentSubID)
	s IntHappenDate=$zd(InstanceObj.HappenDate,3)
	s IntHappenTime=$zt(InstanceObj.HappenTime,1)
	q:(IntHappenDate="")||(IntHappenTime="") ret
	
	s ret=1
	s tmpTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(IntHappenDate_" "_IntHappenTime,FPAdmDateTime)
	q:(tmpTimeGap>0) ret
	
	s ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1)
	q ret_"@"_ElementCode
}

/// 病案首页.【主要诊断编码】中包含C00—D48且为首次入院，【病理诊断】不允许为空。
/// Input:AElement1:主要诊断编码单元，AElement2：病理诊断单元，AElement3:入院次数单元编码，AValues；编码中指定包含的值，ArgExtValues：诊断例外
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0051(EpisodeID,10751,10800,10681,"C\D1\D2\D4\D4","D49")
ClassMethod IsUnify0051(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, AValues As %String, ArgExtValues As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="") ret
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement3,"")
	q:(ElementData3>1)&&(ElementData3'="")&&(ElementData3'="—") ret
	
	
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:(ElementData1="")||(ElementData1="—") ret

	s Values=##Class(EPRservice.Quality.CommonHelper).GetListFromString(AValues,"\")
	s flag=0
	s Ind=1
	for {	
			s Value=$listget(Values,Ind)
			q:Value=""
			s:(ElementData1[Value) flag=1
			s Ind=Ind+1	
	}
	
	q:(flag=0) ret


	s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
	s ExtInd=1
	for {	
			s ExtValue=$listget(ExtValuels,ExtInd)
			q:ExtValue=""
			
			s:(ElementData1[ExtValue) ret=1
			s ExtInd=ExtInd+1	
	}
	
	q:(ret=1) ret
	s ret=1
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	s:(ElementData2="")||(ElementData2="—") ret=-1
   
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
	q ret_"@"_ElementCode
}

/// 病案首页.【新生儿出生体重】填写范围须在"100-9999"之间(单位:克)。
/// Input:AElementIDs:新生儿出生体重单元ID(多个用"\"分隔)，AMin：单元填写范围最小值，AMax：单元填写范围最大值, ADataType 数据类型(为"I"表示必须整数，默认为"")
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0052(EpisodeID,"体重1单元ID\体重2单元ID","100","9999")
ClassMethod IsUnify0052(AEpisodeID As %String, AElementIDs As %String, AMin As %String, AMax As %String, ADataType As %String = "") As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="") ret
	
	s ret=1
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		continue:(ElementData="")||(ElementData="-")||(ElementData="—")
		s:(ADataType="I")&&(ElementData[".") ret=-1
		q:(ret=-1)
		s:(AMin'="")&&(+ElementData<AMin) ret=-1
		s:(AMax'="")&&(+ElementData>AMax) ret=-1
		q:(ret=-1)
	}
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementIDs)
	q ret_"@"_ElementCode
}

/// 病案首页.【诊断编码】包含"Z37...",【新生儿出生体重】需填写*个(用","隔开)。
/// Input:AElementIDs:诊断单元ID(多个用"\"分隔)，AValues 诊断单元条件值，AElementID：新生儿出生体重单元ID，AFlag 条件符号(=表示只能填*个，>=表示至少天*个)，ANum：体重单元须填写数量
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0052(EpisodeID,"诊断编码1ID\诊断编码2ID","Z37...","体重单元ID","1")
ClassMethod IsUnify0053(AEpisodeID As %String, AElementIDs As %String, AValues As %String, AElementID As %String, AFlag As %String, ANum As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="")||(AValues="")||(AElementID="")||(AFlag="")||(ANum="") ret
	
	s flag=0   ///标记诊断编码是否符合质控条件
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		continue:(ElementData="")||(ElementData="-")||(ElementData="—")
		for J=1:1:$l(AValues,"\")
		{
			s Value=$p(AValues,"\",J)
			s:(ElementData[Value) flag=1
			q:(flag=1)
		}
		q:(flag=1)
	}
	q:(flag=0) ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
	s ElementData1=$tr(ElementData1,"，",",")
	s:(AFlag="=")&&($l(ElementData1,",")'=ANum) ret=-1
	s:(AFlag=">=")&&($l(ElementData1,",")<ANum) ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementIDs_"\"_AElementID)
	q ret_"@"_ElementCode
}

/// Desc:	病案首页.【**费用】应等于(或小于)【总费用】(或各分项费用合计)。
/// Input:	AEpisodeID：就诊号;   AElement1：**费用   AElement2：总费用(或各个费用,用"^"隔开);AFlag:判断标志("="或"<")
/// Return：ret<0:不一致; ret=1一致; 
/// Debug:w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0054(EpisodeID,"**费用code","总费用code","=")
ClassMethod IsUnify0054(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AFlag As %String = "=") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "")||(AFlag="") ret
	
	s ret = 1
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") // 总费用
	q:($tr(ElementData1,"-\—\ ","")="") ret
	
	//分项费用合计
	s AllPrice = 0
	for I=1:1:$l(AElement2,"^")
	{
		s Element2 = $p(AElement2,"^",I)
		s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
		continue:(+ElementData2=0)
		s AllPrice = AllPrice + ElementData2
	}
	s:(AFlag="=")&&($num(ElementData1)'=$num(AllPrice)) ret=-1
	s:(AFlag="<")&&($num(ElementData1)>=$num(AllPrice)) ret=-1
	s:(AFlag=">=")&&($num(ElementData1)<$num(AllPrice)) ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// 说明：病案首页.【治疗类别】为"中医\中西医"，【主病】必填。
/// InPut: AElement1  条件单元-治疗类别,AValues 条件单元符合值(多个用"\"分隔)，AElement2 判断单元-主病
/// Output: 0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件
/// Debug: ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0055(EpisodeID,"治疗类别code","中医\中西医","主病code")
ClassMethod IsUnify0055(AEpisodeID As %String, AElement1 As %String, AValues As %String, AElement2 As %String) As %String
{
		s ret=0
		q:(AElement1="")||(AElement1="")||(AElement2="") ret
		
		s ret=1
		s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
		q:(AValues[ElementData1) ret
		
		for I=1:1:$l(AElement2,"\")
		{
			s Element2=$P(AElement2,"\",I)
			s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
			s:($tr(ElementData2,"-\—","")="") ret=-1
			q:(ret=-1)
		}
		
        s ElementCode=""
        s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
        q ret_"@"_ElementCode
}

/// 病案首页.【是否因同一病种再入院】选择"是"，【与上次出院日期间隔天数】应大于"0"，否则应为空。
/// Input:AElementID1:是否因同一病种再入院ID，AElementID2：与上次出院日期间隔天数
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0056(EpisodeID,"是否因同一病种再入院","是","与上次出院日期间隔天数")
ClassMethod IsUnify0056(AEpisodeID As %String, AElementID1 As %String, AValue As %String, AElementID2 As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID1="")||(AElementID2="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID2,"")
	s:(ElementData1=AValue)&&((+ElementData2)<=0) ret=-1
	s:(ElementData1'=AValue)&&($tr(ElementData2,"-\—","")'="") ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2)
    q ret_"@"_ElementCode
}

/// 病案首页.【主病\门急诊诊断(中医诊断)】只能为"B"开头的中医编码。
/// Input:AElementIDs:主病ID，ADiagCode：允许编码开头字母
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0057(EpisodeID,"诊断","B")
ClassMethod IsUnify0057(AEpisodeID As %String, AElementIDs As %String, ADiagCode As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="")||(ADiagCode="") ret
	
	s ret=1
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		continue:($tr(ElementData,"-\—","")="")
		s DiagCode=$e(ElementData,1,1)
		;b ;
		s:(DiagCode'=ADiagCode) ret=-1
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementIDs)
    q ret_"@"_ElementCode
}

/// 说明: 诊断(中医/西医)请按顺序填写。(如：填写【主证】前，请先填写【主病】。）
/// Input: AEpisodeID为患者就诊号 , AElements:诊断编码 (用"\"分隔)
/// OutPut: 0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件 
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0058(EpisodeID,"主病code\主证code")
ClassMethod IsUnify0058(AEpisodeID As %String, AElements As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElements="") ret
	
	s ret=1
	for I=2:1:$l(AElements,"\")
	{
		s Element1=$p(AElements,"\",I-1)
		s Element2=$p(AElements,"\",I)
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element1,"")
		s ElementData1=$tr(ElementData1,"-\—","")
		s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
		s ElementData2=$tr(ElementData2,"-\—","")
		s:(ElementData1="")&&(ElementData2'="") ret=-1
		q:(ret=-1)
	}  
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElements)
    q ret_"@"_ElementCode
}

/// 说明: 单元只能填写数值，不能字符
/// Input: AEpisodeID为患者就诊号 , AElements:颅脑损伤时间编码 (用"\"分隔),AChars 可填写的特殊字符
/// OutPut: 0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件 
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0059(EpisodeID,"颅脑损伤天code\小时code")
ClassMethod IsUnify0059(AEpisodeID As %String, AElements As %String, AChars As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElements="") ret
	
	s ret=1
	for I=2:1:$l(AElements,"\")
	{
		s Element=$p(AElements,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
		s ElementData=$tr(ElementData,AChars,"")
		continue:(ElementData="")
		s:($num(ElementData)="") ret=-1
		q:(ret=-1)
	}  
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElements)
    q ret_"@"_ElementCode
}

/// Desc:	病案首页.【住院天数】大于"1"时,【**费用(或多项费用合计)】应大于"0"。
/// Input:	AEpisodeID：就诊号;   AElement1：住院天数; AElement2：**费用(或多项费用合计);AElement3:总费用(默认为空,不为空时须判断小于总费用)
/// Return：ret<0:不一致; ret=1一致; 
/// Debug:w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0060(EpisodeID,"住院天数code","**费用code","")
ClassMethod IsUnify0060(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	
	s ret = 1
	///住院天数
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") // 总费用
	q:(+$num(ElementData1)<="1") ret
	
	//分项费用合计
	s AllPrice = 0
	for I=1:1:$l(AElement2,"^")
	{
		s Element2 = $p(AElement2,"^",I)
		s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
		continue:(+ElementData2=0)
		s AllPrice = AllPrice + ElementData2
	}
	s:(AElement3="")&&($num(AllPrice)<=0) ret=-1
	if (AElement3'="")
	{
		s ElementData3= ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement3,"")
		q:(+ElementData3=0) ret
		s:($num(AllPrice)>=$num(ElementData3)) ret=-1
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
    q ret_"@"_ElementCode
}

/// Desc:	病案首页.【使用医疗机构中药制剂】为"是"时,【医疗机构中药制剂费】必填，且应大于"0"。
/// Input:	AEpisodeID：就诊号;   AElement1：使用医疗机构中药制剂; AValue 条件符合值; AElement2：**费用
/// Return：ret<0:不一致; ret=1一致; 
/// Debug:w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0061(EpisodeID,"使用医疗机构中药制剂code","是","医疗机构中药制剂费code")
ClassMethod IsUnify0061(AEpisodeID As %String, AElement1 As %String, AValue As %String, AElement2 As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AValue="")||(AElement2 = "") ret
	
	s ret = 1
	///使用医疗机构中药制剂
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") // 总费用
	q:(ElementData1'=AValue) ret
	
	//分项费用合计
	for I=1:1:$l(AElement2,"^")
	{
		s Element2 = $p(AElement2,"^",I)
		s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
		s:(+$num(ElementData2)<=0) ret=-1
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
    q ret_"@"_ElementCode
}

/// Desc:	病案首页.【治疗类别】为"中医/中西医",且【住院天数】大于"1"时,【**费用】应大于"0"。
/// Input:	AEpisodeID：就诊号;   AElement1：治疗类别; AElement2：住院天数; AElement3：**费用(多个用"^"分隔);
/// Return：ret<0:不一致; ret=1一致; 
/// Debug: ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0062(EpisodeID,"治疗类别code","住院天数code","**费用code")
ClassMethod IsUnify0062(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2="")||(AElement3 = "") ret
	
	s ret = 1
	///治疗类别
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") // 总费用
	q:(ElementData1'="中医")&&((ElementData1'="中西医")) ret
	
	///住院天数
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") // 总费用
	q:(ElementData1<="1") ret
	
	//分项费用合计
	s AllPrice = 0
	for I=1:1:$l(AElement3,"^")
	{
		s Element3 = $p(AElement3,"^",I)
		s ElementData3 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element3,"")
		continue:(+ElementData3=0)
		s AllPrice = AllPrice + ElementData3
	}
	s:(AllPrice<=0) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
    q ret_"@"_ElementCode
}

/// 病案首页.手术类别(如手术或介入治疗)控制手术相关信息填写
/// Input:		AElementID：手术编码; AOPType 手术类别要求(N 手术、I 介入治疗); AElementIDs：手术相关信息(如:手术日期,手术级别,手术者,I助,II助等...);AValues 空以外不能填写的值(如"-\—")
/// Output:     0 不用检查或配置错误, -1 触犯条目, 1 符合条件
/// w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0063(EpisodeID,"11647","","11648\11649","")
ClassMethod IsUnify0063(AEpisodeID As %String, AElementID As %String, AOPType As %String, AElementIDs As %String, AValues As %String = "") As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID="")||(AElementIDs="") ret
	
	s ret=1
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
    q:(ElementData="") ret
    
	s flag=1
	if (AOPType'="")
	{
		s OPERType="",OPERRowId=""
		s OperDesc=$$ALPHAUP^SSUTIL4(ElementData)
		s OPERRowId=$O(^ORC("OPER",0,"Desc",OperDesc,OPERRowId)) 
		q:(OPERRowId="") ret
		s OPERType=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",11)
		s:(AOPType'[OPERType) flag=0
	}
	q:(flag=0) ret
	
	for I=1:1:$l(AElementIDs,"\")
		{
			s ElementID=$p(AElementIDs,"\",I)
			s tmpElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
			s:(AValues'="") tmpElementData=$tr(tmpElementData,AValues,"")
			continue:(tmpElementData'="")
			s ret=-1
			q
		}
		
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID_"\"_AElementIDs)
    q ret_"@"_ElementCode
}

/// Desc: 		  出院诊断编码与病理诊断编码关系判断
/// CreateDate:	  2020-04-02
/// Input:		  AEpisodeID 就诊号,AElements1 条件单元代码(多个用"\"分隔),ACode 条件包含字母字符(如:"D"),ANum 条件字符范围(如:"10^36"),AElements2 判断单元, AValue2 判断值（如果是多个，以"#"隔开） ,AChars 要过滤的字符
/// Output:       0 不用检查或配置错误  -1 触犯条目  1  符合条件
/// Debug:        ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0064(EpisodeID,"出院诊断编码code","D","10^36","病理诊断编码code,"0/")
ClassMethod IsUnify0064(AEpisodeID As %String, AElements1 As %String, ACode As %String, ANum As %String, AElement2 As %String, AValue2 As %String, AChars As %String)
{
   s ret=0,flag=0
   q:(AEpisodeID="")||(AElements1="")||(ANum="")||(ACode="")||(AElement2="") ret 
   
   s ret=1
   s NumMin=$p(ANum,"^",1)
   s NumMax=$p(ANum,"^",2)
   s:($l(ANum,"^")=1) NumMin=ANum,NumMax=ANum
   for i=1:1:$l(AElements1,"\")
   {
	   s Element1=$p(AElements1,"\",i)
	   q:(Element1="")
	   s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element1,"")
	   s ElementData1=$tr(ElementData1,AChars,"")	   
	   continue:(ElementData1="")||($e(ElementData1,1,1)'=ACode)
	   s:($e(ElementData1,2,3)>=NumMin)&&($e(ElementData1,2,3)<=NumMax) flag=1
	   q:(flag=1)
	}
	q:flag=0 ret
	
	s ret = -1
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	//s:(ElementData2'[AValue2) ret=-1
	for j=1:1:$l(AValue2,"#")
	{
		s CurrValue = $p(AValue2,"#",j)
		s:(ElementData2[CurrValue) ret=1
		q:(ret=1)
	}
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElements1_"\"_AElement2)
    q ret_"@"_ElementCode
}

/// 病案首页：【血费】>0时，【血型】及【RH】不能是"未查\不详"。
/// Input:AElement1:血费 ，AElement2:血型，AElement3：RH, AValues 判断符合值(未查\不详)
/// ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0065(EpisodeID,11957,12491,12490,"未查\不详")
ClassMethod IsUnify0065(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, AValues As %String)
{
	s ret=0
   
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AValues="") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") 
	q:(+ElementData1<=0) ret
	
	s ret=1
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"") 
	s ElementData3=""
	s:(AElement3'="") ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement3,"")
	
	s:(AValues[ElementData2) ret=-1
	s:(ElementData3'="")&&(AValues[ElementData3) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
    q ret_"@"_ElementCode
}

/// 病案首页:【麻醉费】大于0时，【麻醉方式】一般不可为空，请检查。
/// Input:AElement1:麻醉费 ，AElement2:麻醉方式(多个有"\"分隔)
/// ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0066(EpisodeID,11957,12491)
ClassMethod IsUnify0066(AEpisodeID As %String, AElement1 As %String, AElement2 As %String)
{
	s ret=0
   
	q:(AEpisodeID="")||(AElement1="")||(AElement2="") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") 
	q:(+ElementData1<=0) ret
	
	s ret=-1
	for I=1:1:$l(AElement2,"\")
	{
		s Element2=$p(AElement2,"\",I)
		s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"") 
		s:($tr(ElementData2,"-\—\ ","")'="") ret=1
		q:(ret=1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
    q ret_"@"_ElementCode
}

/// 病案首页:填了【麻醉方式】【麻醉医生】，【麻醉费】必须大于0，请检查是否漏收麻醉费。
/// Input:AElement1:麻醉费 ，AElement2:麻醉方式，AElement3：麻醉医生
/// ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0067(EpisodeID,11957,12491,12490)
ClassMethod IsUnify0067(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String)
{
	s ret=0
   
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AElement3="") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") 
	q:(+ElementData1>0) ret
	
	s ret=-1
	for I=1:1:$l(AElement2,"\")
	{
		s Element2=$p(AElement2,"\",I)
		s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"") 
		s:($tr(ElementData2,"-\—\ ","")'="") ret=1
		q:(ret=1)
	}
	q:(ret=1) ret
	
	for J=1:1:$l(AElement3,"\")
	{
		s Element3=$p(AElement3,"\",J)
		s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element3,"") 
		s:($tr(ElementData3,"-\—\ ","")'="") ret=1
		q:(ret=1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
    q ret_"@"_ElementCode
}

/// 自付金额<总费用且自付金额大于0，付费方式不应为自费（两费用误差小于1元除外）
/// Input:AElement1:付费方式单元 ， AElement2:总费用单元，AElement3:自付费用单元
/// ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0068(EpisodeID,"付费方式code","总费用code","自付费用code")
ClassMethod IsUnify0068(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String)
{
	s ret=0
   
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AElement3="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") 
	q:(ElementData1'="自费") ret
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"") 
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement3,"")
	q:(ElementData2="")||(ElementData3="") ret
	q:(+ElementData2<=(+ElementData3)+1) ret
	s:(+ElementData2>+ElementData3)&&(+ElementData3>0) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
    q ret_"@"_ElementCode
}

/// 病案首页.【医疗机构中药制剂费】>0时，【使用医疗机构中药制剂】应为"是"。
/// Input:AElement1:医疗机构中药制剂费 ， AElement2:使用医疗机构中药制剂
/// ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0069(EpisodeID,"医疗机构中药制剂费code","使用医疗机构中药制剂code")
ClassMethod IsUnify0069(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AValue As %String)
{
	s ret=0
   
	q:(AEpisodeID="")||(AElement1="")||(AElement2="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") 
	q:(+ElementData1<=0) ret
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"") 
	s:(ElementData2'=AValue) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
    q ret_"@"_ElementCode
}

/// 病案首页.【主诉】不能超过20个字。
/// Input:AElement1:主诉 ， ANums:字数限制
/// ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0070(EpisodeID,"主诉code","<=","20")
ClassMethod IsUnify0070(AEpisodeID As %String, AElement1 As %String, AFlag As %String, ANums As %String)
{
	s ret=0
   
	q:(AEpisodeID="")||(AElement1="")||(ANums="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") 
	s ElementData1=$tr(ElementData1,"-\—\ ","")
	s ElementData1=$tr(ElementData1,"，。”.“,""、","")  //去除主诉内容中的标点符号  wxh  220621
	q:(ElementData1="") ret
	
	s:(AFlag="<=")&&($l(ElementData1)>ANums) ret=-1
	s:(AFlag=">=")&&($l(ElementData1)<ANums) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1)
    q ret_"@"_ElementCode
}

/// 说明: 病案首页.女性患者年龄小于20岁婚姻只能填未婚，男性患者年龄小于22岁婚姻只能填未婚
/// Input: AElement1:年龄，AElement2:婚姻，AElement3:性别，AValue:条件值
/// OutPut: 0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件
/// Debug: ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0071(EpisodeID,"年龄code","婚姻code","性别code","未婚")
ClassMethod IsUnify0071(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, AValue As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AElement3="")||(AValue="") ret
	
	s ret=1 
	//年龄
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:(ElementData1 = "")||(ElementData1="—")||(ElementData1="-") ret
	s lengthage=$l(ElementData1)
	s age=$e(ElementData1,1,lengthage-1)
	
	//婚姻
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	q:(ElementData2="") ret
	
	//性别
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement3,"")
	q:(ElementData3="") ret
    
    s:(ElementData3="男")&&(age<22)&&(ElementData2'=AValue) ret=-1
    s:(ElementData3="女")&&(age<20)&&(ElementData2'=AValue) ret=-1
    
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
    q ret_"@"_ElementCode
}

/// 说明: 【血型】与【RH】填写规则。
/// Input: AEpisodeID为患者就诊号 , AElement1:血型编码 , AElement2:RH编码
/// OutPut: 0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件 
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0072(EpisodeID,"血型code","RHcode")
ClassMethod IsUnify0072(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="") ret
	
	s ret=1
	///取血型编码
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") 
	q:($tr(ElementData1,"-\—","")="") ret
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	s:($tr(ElementData2,"-\—","")="") ret=-1    ///血型填写诶,RH必填，不能为空
	s:($tr(ElementData1,"A\B\O\AB","")="")&&($tr(ElementData2,"阴\阳","")'="") ret=-1   ///血型为"A\B\O\AB",RH只能填写"阴\阳"
	s:($tr(ElementData1,"不祥","")="")&&($tr(ElementData2,"不祥","")'="") ret=-1     ///血型为"不祥",RH只能填写"不祥"
	s:($tr(ElementData1,"未查","")="")&&($tr(ElementData2,"未查","")'="") ret=-1     ///血型为"未查",RH只能填写"未查"
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
    q ret_"@"_ElementCode
}

/// 说明: 病理诊断中只能出现“M”编码
/// Input: AEpisodeID为患者就诊号 , AElements:病理诊断编码 , AValues:条件值
/// OutPut: 0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件 
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0073(EpisodeID,"病理诊断code")
ClassMethod IsUnify0073(AEpisodeID As %String, AElement As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement="") ret
	
	s ret=1
	///取病理诊断编码
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"") 
	s ElementData=$tr(ElementData,"-","")
	q:(ElementData="") ret
	s:($e(ElementData,1,1)'="M")||(ElementData'["/") ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement)
    q ret_"@"_ElementCode
}

/// 说明：性别为女，门急诊诊断、主要诊断和其他诊断中不应出现如下编码：B26.0；C60-C63；D07.4-D07.6；D17.6；D29；D40；E29；E89.5；F52.4；I86.1；L29.1；N40-N51；Q53-Q55；R86；S31.2-S31.3；Z12.5
/// Input:	AEpisodeID  患者就诊号; AElement1 性别; AElement2 诊断1code\诊断2code
/// OutPut: 0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件 
/// Debug:	##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0074(EpisodeID,"性别code","诊断1code\诊断2code")
ClassMethod IsUnify0074(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2="") ret
    s:(AElement2="疾病编码") AElement2="10075\10076\10077\10078\10079\10080\10081\10082\10083\10084\10085\10086\10087\10088\10089\10090\10091\10092\10093\10094\10095\10096\10097"

	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:(ElementData1="男") ret
	
	s ElementData2Str = ""
	for P=1:1:$l(AElement2,"\")
	{
		s Element2=$p(AElement2,"\",P)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
		s:(ElementData2Str'="") ElementData2Str=ElementData2Str_"\"_ElementData
		s:(ElementData2Str="") ElementData2Str=ElementData
	}
	
	s:(ElementData1="女")&&((ElementData2Str["B26.0")||(ElementData2Str["D17.6")) ret = "-1"
	s:(ElementData1="女")&&((ElementData2Str["D29")||(ElementData2Str["D40")) ret = "-1"
	s:(ElementData1="女")&&((ElementData2Str["E29")||(ElementData2Str["E89.5")) ret = "-1"
	s:(ElementData1="女")&&((ElementData2Str["F52.4")||(ElementData2Str["I86.1")) ret = "-1"
	s:(ElementData1="女")&&((ElementData2Str["L29.1")||(ElementData2Str["R86")) ret = "-1"
	s:(ElementData1="女")&&((ElementData2Str["S31.2")||(ElementData2Str["S31.3")) ret = "-1"
	s:(ElementData1="女")&&(ElementData2Str["Z12.5") ret = "-1"
	
	s eleCode=""
	s ElementData2lengrh = $L(ElementData2Str,"^")
	for i=1:1:ElementData2lengrh
	{
	s ElementData2 = ""
	s ElementData2 = $P(ElementData2Str,"^",i)
	
	s:(ElementData1="女")&&(($E(ElementData2,1,1)="C")&&(($E(ElementData2,2,3)>="60")&&($E(ElementData2,2,3)<="63"))) ret = "-1"
	s:(ElementData1="女")&&(($E(ElementData2,1,1)="D")&&(($E(ElementData2,2,5)>="07.4")&&($E(ElementData2,2,5)<="07.6"))) ret = "-1"
	s:(ElementData1="女")&&(($E(ElementData2,1,1)="N")&&(($E(ElementData2,2,3)>="40")&&($E(ElementData2,2,3)<="51"))) ret = "-1"
	s:(ElementData1="女")&&(($E(ElementData2,1,1)="Q")&&(($E(ElementData2,2,3)>="53")&&($E(ElementData2,2,3)<="55"))) ret = "-1"
	s:(ret=-1)&&(eleCode'="") eleCode=eleCode_"\"_$p(AElement2,"\",i)
	s:(ret=-1)&&(eleCode="") eleCode=$p(AElement2,"\",i)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(eleCode)
    q ret_"@"_ElementCode
}

/// 说明：性别为男，门急诊诊断、主要诊断和其他诊断中不应出现如下编码：A34；B37.3；C51-C58；C79.6；D06；D07.0-D07.3；D25-D28；D39；E28；E89.4；F52.5；F53；I86.3；L29.2；M80.0-M80.1；M81.0-M81.1；M83.0；N70-N98；N99.2-N99.3；O00-O99；P54.6；Q50-Q52；R87；S31.4；S37.4-S37.6；T19.2-T19.3；T83.3；Z01.4；Z12.4；Z30.1；Z30.3；Z30.5；Z31.1-Z31.2；Z32- Z37；Z39；Z87.5；Z97.5
/// Input:	AEpisodeID  患者就诊号; AElement1 性别; AElement2 诊断1code\诊断2code 
/// OutPut: 0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件 
/// Debug:	##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0075(EpisodeID,"性别code","诊断1code\诊断2code")
ClassMethod IsUnify0075(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2="") ret
	s:(AElement2="疾病编码") AElement2="10075\10076\10077\10078\10079\10080\10081\10082\10083\10084\10085\10086\10087\10088\10089\10090\10091\10092\10093\10094\10095\10096\10097"

	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:(ElementData1="女") ret
	
	s ElementData2Str = ""
	for P=1:1:$l(AElement2,"\")
	{
		s Element2=$p(AElement2,"\",P)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
		CONTINUE:(ElementData="")
		s:(ElementData2Str'="") ElementData2Str=ElementData2Str_"\"_ElementData
		s:(ElementData2Str="") ElementData2Str=ElementData
	}
	
	//C51-C58,N70-N77,N80-N98,O00-O99
	/*
	s:(ElementData1="男")&&((ElementData2Str["A34")||(ElementData2Str["B37.3")) ret = "-1"
	s:(ElementData1="男")&&((ElementData2Str["C79.6")||(ElementData2Str["D06")) ret = "-1"
	s:(ElementData1="男")&&((ElementData2Str["D39")||(ElementData2Str["E28")) ret = "-1"
	s:(ElementData1="男")&&((ElementData2Str["E89.4")||(ElementData2Str["F52.5")) ret = "-1"
	s:(ElementData1="男")&&((ElementData2Str["F53")||(ElementData2Str["I86.3")) ret = "-1"
	s:(ElementData1="男")&&((ElementData2Str["L29.2")||(ElementData2Str["M83.0")) ret = "-1"
	s:(ElementData1="男")&&((ElementData2Str["P54.6")||(ElementData2Str["R87")) ret = "-1"
	s:(ElementData1="男")&&((ElementData2Str["S31.4")||(ElementData2Str["T83.3")) ret = "-1"
	s:(ElementData1="男")&&((ElementData2Str["Z01.4")||(ElementData2Str["Z12.4")) ret = "-1"
	s:(ElementData1="男")&&((ElementData2Str["Z30.1")||(ElementData2Str["Z30.3")) ret = "-1"
	s:(ElementData1="男")&&((ElementData2Str["Z30.5")||(ElementData2Str["Z39")) ret = "-1"
	s:(ElementData1="男")&&((ElementData2Str["Z87.5")||(ElementData2Str["Z97.5")) ret = "-1"
	*/
	
	s eleCode=""
	s ElementData2lengrh = $L(ElementData2Str,"\")
	for i=1:1:ElementData2lengrh
	{
	s ElementData2 = ""
	s ElementData2 = $P(ElementData2Str,"\",i)
	CONTINUE:(ElementData2="")
	s:(ElementData1="男")&&(($E(ElementData2,1,1)="C")&&(($E(ElementData2,2,3)>="51")&&($E(ElementData2,2,3)<="58"))) ret = "-1"
	;s:(ElementData1="男")&&(($E(ElementData2,1,1)="D")&&(($E(ElementData2,2,5)>="07.0")&&($E(ElementData2,2,5)<="07.3"))) ret = "-1"
	;s:(ElementData1="男")&&(($E(ElementData2,1,1)="D")&&(($E(ElementData2,2,3)>="25")&&($E(ElementData2,2,3)<="28"))) ret = "-1"
	;s:(ElementData1="男")&&(($E(ElementData2,1,1)="M")&&(($E(ElementData2,2,5)>="80.0")&&($E(ElementData2,2,5)<="80.1"))) ret = "-1"
	;s:(ElementData1="男")&&(($E(ElementData2,1,1)="M")&&(($E(ElementData2,2,5)>="81.0")&&($E(ElementData2,2,5)<="81.1"))) ret = "-1"
	s:(ElementData1="男")&&(($E(ElementData2,1,1)="N")&&(($E(ElementData2,2,3)>="70")&&($E(ElementData2,2,3)<="77"))) ret = "-1"
	s:(ElementData1="男")&&(($E(ElementData2,1,1)="N")&&(($E(ElementData2,2,3)>="80")&&($E(ElementData2,2,3)<="98"))) ret = "-1"
	s:(ElementData1="男")&&(($E(ElementData2,1,1)="O")&&(($E(ElementData2,2,3)>="00")&&($E(ElementData2,2,3)<="99"))) ret = "-1"
	;s:(ElementData1="男")&&(($E(ElementData2,1,1)="Q")&&(($E(ElementData2,2,3)>="50")&&($E(ElementData2,2,3)<="52"))) ret = "-1"
    ;s:(ElementData1="男")&&(($E(ElementData2,1,1)="T")&&(($E(ElementData2,2,5)>="19.2")&&($E(ElementData2,2,5)<="19.3"))) ret = "-1"
	;s:(ElementData1="男")&&(($E(ElementData2,1,1)="Z")&&(($E(ElementData2,2,5)>="31.1")&&($E(ElementData2,2,5)<="31.2"))) ret = "-1"
	;s:(ElementData1="男")&&(($E(ElementData2,1,1)="S")&&(($E(ElementData2,2,5)>="37.4")&&($E(ElementData2,2,5)<="37.6"))) ret = "-1"
	;s:(ElementData1="男")&&(($E(ElementData2,1,1)="Z")&&(($E(ElementData2,2,3)>="32")&&($E(ElementData2,2,3)<="37"))) ret = "-1"
	s:(ret=-1)&&(eleCode'="") eleCode=eleCode_"\"_$p(AElement2,"\",i)
	s:(ret=-1)&&(eleCode="") eleCode=$p(AElement2,"\",i)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(eleCode)
    q ret_"@"_ElementCode
}

/// 说明：病案首页.12岁及以下儿童【出院诊断】不允许为C50-C63(乳房、女性及男性生殖器恶性肿瘤)
/// Input: AElement1:年龄, AElement2:诊断1code\诊断2code, AValues1:控制年龄值, ANoValues2:触发质控条件值, AElement3:年龄(月), AElement4:年龄(天)
/// OutPut: 0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件 
/// Debug:	##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0076(EpisodeID,"年龄code","诊断1code\诊断2code","12","C5\C61\C62\C63")
ClassMethod IsUnify0076(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AValues1 As %String, ANoValues2 As %String, AElement3 As %String = "", AElement4 As %String = "") As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AValues1="")||(ANoValues2="") ret
    s:(AElement2="疾病编码") AElement2="10075\10076\10077\10078\10079\10080\10081\10082\10083\10084\10085\10086\10087\10088\10089\10090\10091\10092\10093\10094\10095\10096\10097"

	s ret=1 
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	
	q:(ElementData1 = "")||(ElementData1="-")||(ElementData1="—") ret
	q:((ElementData1["岁")&&($p(ElementData1,"岁",1)>AValues1))||((ElementData1'["岁")&&(ElementData1'["月")&&(ElementData1'["天")&&(ElementData1>AValues1)) ret
	
	///取需判断单元
	for num=1:1:$l(AElement2,"\")
	{
		s Element2=$p(AElement2,"\",num)
		s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
		s:(ElementData2'="") ElementData2str=ElementData2str_"\"_ElementData2
		s:(ElementData2="") ElementData2str=ElementData2
	}
	s eleCode=""
    for i=1:1:$l(ElementData2str,"\")
    {
	    s ElementData2=$p(ElementData2str,"\",i)
        for j=1:1:$l(ANoValues2,"\") {
		      s Value2=$p(ANoValues2,"\",j)
			  s:(ElementData2[Value2) ret=-1
			  s:(ret=-1)&&(eleCode'="") eleCode=eleCode_"\"_$p(AElement2,"\",i)
			  s:(ret=-1)&&(eleCode="") eleCode=$p(AElement2,"\",i)
			  q:(ret=-1)
          }
        q:(ret=-1)
    }
    
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(eleCode)
    q ret_"@"_ElementCode
}

/// 病案首页.主要诊断编码是"R"或者"Z"开头时提示
/// Input:AElement：主要诊断编码单元，AValues ：不允许出现的诊断编码值，ArgExtValues：例外的诊断编码
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0077(EpisodeID,"",10332,"R\Z","")
ClassMethod IsUnify0077(AEpisodeID As %String, AElements As %String, AValues As %String, AExtValues As %String = "") As %String
{
	s ret=0
   
	q:(AEpisodeID="")||(AElements="")||(AValues="") ret
	
	s ElementDatastr=""
	for I=1:1:$l(AElements,"\")
	{
		s Element=$p(AElements,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
		continue:($tr(ElementData,"-\—\ ","")="")
		s:(ElementDatastr'="") ElementDatastr=ElementDatastr_"\"_ElementData
		s:(ElementDatastr="") ElementDatastr=ElementData
	}
	q:(ElementDatastr="") ret
	
	for J=1:1:$l(ElementDatastr,"\")
	{
		s ElementData=$p(ElementDatastr,"\",J)
		
		s flag=0,eleCode=""
		for K=1:1:$l(AValues,"\")
		{
			s Value=$p(AValues,"\",K)
			s:($e(ElementData,1,$l(Value))=Value) flag=1
			continue:(flag=0)
			
			for P=1:1:$l(AExtValues,"\") 
			{
				s ExtValue=$p(AExtValues,"\",P)
				q:ExtValue=""
				s:($e(ElementData,1,$l(ExtValue))=ExtValue) flag=0
				q:(flag=0)
			}
			s:(flag=1) ret=-1
			s:(ret=-1)&&(eleCode'="") eleCode=eleCode_"\"_$p(AElements,"\",i)
			s:(ret=-1)&&(eleCode="") eleCode=$p(AElements,"\",i)
			q:(ret=-1)
		}
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(eleCode)
    q ret_"@"_ElementCode
}

/// 病案首页.【主要诊断】或【其他诊断】编码出现"O80-O84"，【其他诊断编码】必须有分娩结局编码Z37。
/// Input:AElement1：出院诊断,AValues：指定出现的诊断编码，AValue2：指定的另一个诊断编码
/// ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0078(EpisodeID,"诊断1\诊断2","O80\O81\O82\O83\O84","Z37")
ClassMethod IsUnify0078(ArgEpisodeID As %String, AElements As %String, AValue1s As %String, AValue2 As %String)
{
	s ret=0
	q:(ArgEpisodeID="")||(AElements="")||(AValue1s="")||(AValue2="") ret
	
	///取首页诊断编码
	s ElementDatastr="",eleCode=""
	for I=1:1:$l(AElements,"\")
	{
		s Element=$p(AElements,"\",I)
		s ElementData=##Class(EMRservice.BL.BLScatterData).GetScatterData(ArgEpisodeID,Element,"") 
		s ElementData=$tr(ElementData,"-\—","")
		continue:(ElementData="")
		s:(eleCode'="") eleCode=eleCode_"\"_Element
		s:(eleCode="") eleCode=Element
		s:(ElementDatastr'="") ElementDatastr=ElementDatastr_"\"_ElementData
		s:(ElementDatastr="") ElementDatastr=ElementData
	}
	
	s flag=0
    for J=1:1:$l(AValue1s,"\")
    {
	    s Value1=$p(AValue1s,"\",J)
	    s:(ElementDatastr[Value1) flag=1
	    q:(flag=1)
	}
	q:(flag=0) ret
	
	s ret=1
	s:(ElementDatastr'[AValue2) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(eleCode)
    q ret_"@"_ElementCode
}

/// 病案首页.【麻醉方式】不为空，且非局麻时，【麻醉费】不能为"0"，请检查。
/// Input:AElementIDs：麻醉方式, AElementID：麻醉费
/// ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0079(EpisodeID,"麻醉方式1\麻醉方式2","局","麻醉费code")
ClassMethod IsUnify0079(AEpisodeID As %String, AElementIDs As %String, ANoValue As %String, AElementID As %String)
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="")||(ANoValue="")||(AElementID="") ret
	
	s flag=0,eleCode=""
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID1=$p(AElementIDs,"\",I)
		s ElementData1=##Class(EMRservice.BL.BLScatterData).GetScatterData(AEpisodeID,ElementID1,"")
		continue:($tr(ElementData1,"-\—\ ","")="") 
		s:(ElementData1'[ANoValue) flag=1
		s eleCode=ElementID1
		q:(flag=1)
	}
	q:(flag=0)
	
	s ElementData=##Class(EMRservice.BL.BLScatterData).GetScatterData(AEpisodeID,AElementID,"")
	s:(+ElementData<=0) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(eleCode_"\"_AElementID)
    q ret_"@"_ElementCode
}

/// 病案首页.有【血费】时【血型】不允许填写"不详和未查"，请检查。
/// Input:AElement1：血费,AElement2：血型，AValues：不允许填写的值
/// ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0080(EpisodeID,"血费","血型","不详\未查")
ClassMethod IsUnify0080(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, ANoValues As %String)
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(ANoValues="") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:(+ElementData1=0) ret
	
	s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	s:(ANoValues[ElementData2) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
    q ret_"@"_ElementCode
}

/// 病案首页.【住院天数】与【入院日期】和【出院日期】不符，请检查。
/// Input:AElement1：入院日期,AElement2：出院日期，AElement3：住院天数
/// ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0081(EpisodeID,"入院日期code","出院日期code","住院天数code")
ClassMethod IsUnify0081(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String)
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AElement3="") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:($tr(ElementData1,"-\—\ ","")="") ret
	s ElementData1 = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData1)
	
	s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	q:($tr(ElementData2,"-\—\ ","")="") ret
	s ElementData2 = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData2)
	
	s DayGap = $p(ElementData2," ",1)-$p(ElementData1," ",1)
	
	s ElementData3 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement3,"")
	s:(DayGap=0)&&(ElementData3'="1") ret=-1
	s:(DayGap>0)&&(ElementData3'=DayGap) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
    q ret_"@"_ElementCode
}

/// 病案首页.【离院方式】为"死亡",请完成<死亡记录>，否则请完成<出院记录>。
/// Input:AElement：离院方式,AValue：填写符合值，AStructID：质控结构ID,AStartDate 开始日期, AEndDate 结束日期
/// ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0082(EpisodeID,"离院方式code","出院","21",{HISDischTime2},"")
ClassMethod IsUnify0082(AEpisodeID As %String, AElement As %String, AValue As %String, AStructID As %String, AStartDate As %String, AEndDate As %String)
{
	s ret=0
	q:(AEpisodeID="")||(AElement="")||(AValue="")||(AStructID="")||(AStartDate="") ret
	
	s ret=1
	s ElementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
	q:($tr(ElementData,"-\—\ ","")'=AValue) ret
	
	s IsRecord=##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHSingleIsWrite(AEpisodeID,AStructID,AStartDate,AEndDate)
	s ret=IsRecord
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement)
    q ret_"@"_ElementCode
}

/// 母亲首页有Z37.0/Z37.2/Z37.3/Z37.5/Z37.6 的诊断，孩子必须书写生理新生儿情况记录病历
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0083(EpisodeID,{HISDiagCodes},"Z37.0/Z37.2/Z37.3/Z37.5/Z37.6","21|生理新生儿情况记录",{HISRegTime1},{HISDischTime2})
ClassMethod IsUnify0083(AEpisodeID As %String, AElements As %String, AValues As %String, ATitle As %String, AStartDate As %String, AEndDate As %String) As %String
{
	s ret=0
   
	q:(AEpisodeID="")||(AElements="")||(AValues="")||(AStartDate="") ret
	
	s flag=0,ret=1
	for I=1:1:$l(AElements,"\")
	{
		s Element=$p(AElements,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
		s ElementData=$tr(ElementData,"-\—\ ","")
		continue:(ElementData="")
		for J=1:1:$l(AValues,"\")
		{
			s Value=$p(AValues,"\",J)
			s:($e(ElementData,"1",$l(Value))=Value) flag=1
			q:(flag=1)
		}
		q:(flag=1)
	}
	q:(flag=0)
	
	s ChildAdm=""
	&sql(select PAADM_RowID into :ChildAdm from SQLUser.PA_Adm where PAADM_MotherAdm_DR = :AEpisodeID)
	q:(ChildAdm="") ret
	
	s IsRecord=##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHMultiIsWrite(ChildAdm,ATitle,AStartDate,AEndDate)
	s ret=IsDeathRecord
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElements)
    q ret_"@"_ElementCode
}

/// 病案首页.【**费用】> 0 时，【使用**技术】必须选则"AValue1",否则选择"AValue2"。
/// Input:AElement1：**费用,AElement2：使用**技术,AValue1 符合条件的结果单元值, AValue2 不符合条件的结果单元值
/// ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0084(EpisodeID,"**费用code","使用**技术code","1","2")
ClassMethod IsUnify0084(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AValue1 As %String, AValue2 As %String)
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AValue1="")||(AValue2="") ret
	
	s ret=1
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	s ElementData1=$tr(ElementData1,"-\—\ ","")
	s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	s ElementData2=$tr(ElementData2,"-\—\ ","")
	
	s:(+ElementData1>0)&&(ElementData2'=AValue1) ret=-1
	s:(+ElementData1<=0)&&(ElementData2'=AValue2) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
    q ret_"@"_ElementCode
}

/// 病案首页.【费用A】【费用B】【费用C】都为 "0" 时，【治疗类别】只能选"AValue1",有一项为"0",则不能选"AValue1"。
/// Input:AElement1：**费用,AElement2：使用**技术,AValue1 符合条件的结果单元值, AValue2 不符合条件的结果单元值
/// ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0082(EpisodeID,"费用Acode\费用Bcode\费用Ccode","治疗类别code","1")
ClassMethod IsUnify0085(AEpisodeID As %String, AElements As %String, AElement As %String, AValue1 As %String)
{
	s ret=0
	q:(AEpisodeID="")||(AElements="")||(AElement="")||(AValue1="") ret
	
	s ret=1 , flag=0
	for I=1:1:$l(AElements,"\")
	{
		s Element=$p(AElements,"\",I)
		s ElementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
		s ElementData=$tr(ElementData,"-\—\ ","")
		continue:(+ElementData=0)
		s flag=1
		q
	}
	
	s tmpElementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
	s:(flag=0)&&(ElementData2'=AValue1) ret=-1
	s:(flag=1)&&(ElementData2=AValue1) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElements_"\"_AElement)
    q ret_"@"_ElementCode
}

/// 病案首页.当【麻醉费】>0时，至少有一条手术信息，且【麻醉方式】和【麻醉医生】必填。
/// Creator:	whb
/// CreateDate:	2020-06-23
/// Input:		AEpisodeID 就诊号
/// 			AElement1: 麻醉费code
///             AElement2: 麻醉方式code\麻醉方式code(多个用"\"分隔)
/// 			AElement3: 麻醉医生code\麻醉医生code(多个用"\"分隔)                     
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0086(EpisodeID,"10988",{OperMafang},{OperMayi})                           
ClassMethod IsUnify0086(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String) As %String
{
 s ret=0
 q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AElement3="") ret
 
 s ret=1
 s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID, AElement1,"")
 q:(ElementData1="")||(ElementData1="-")||(ElementData1="—")||(+ElementData1=0)||(ElementData1="0.00")||(+ElementData1<0) ret
 s ret=-1,ElementData=""
 
 for I=1:1:$l(AElement2)
 {
	 s element2=$p(AElement2,"\",I)
	 s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID, element2,"")
	 s ElementData2=$tr(ElementData2,"-","")
	 s ElementData2=$tr(ElementData2,"—","")
	 
	 s element3=$p(AElement3,"\",I)
	 s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID, element3,"")
	 s ElementData3=$tr(ElementData3,"-","")
	 s ElementData3=$tr(ElementData3,"—","")
	 
	 continue:((ElementData2="")&&(ElementData3=""))
	 continue:((ElementData2'="")&&(ElementData3=""))
	 continue:((ElementData2="")&&(ElementData3'=""))
	 
	 s ret=1
	 q:(ret=1)
 }
 s ElementCode=""
 s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
 q ret_"@"_ElementCode
}

/// 有未处理的质控消息，不能送病案室：
/// Creator:	GY
/// CreateDate:	2022-04-22
/// Input:		AEpisodeID 就诊号                    
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件  
/// Debug: 
/// Input: AEpisodeID 就诊号
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0087(EpisodeID,63)
ClassMethod IsUnify0087(AEpisodeID As %String) As %String
{
	s ret=0,retInfo=""
	q:(AEpisodeID="") ret
	s Result = ##Class(EPRservice.Quality.DataGather.AdmInfo).GetMessageFlagByEpisodeID(AEpisodeID)
	q:($p(Result,"^",1)'="-1") ret
	
	s ret=-1
	s retInfo=$p(Result,"^",2)
	q ret_"^"_retInfo
}

/// 未开死亡医嘱的患者【出院情况】不能选择死亡
/// 未开死亡医嘱的患者【离院方式】不能选择死亡
/// 质控条件前提：下死亡医嘱时间不为空
/// AEpisodeID 就诊号		AElements	出院情况或离院方式章节ID，如果是多个以"\"隔开
/// w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0088(198311,10191)
ClassMethod IsUnify0088(AEpisodeID As %String, AElements As %String)
{
	s ret = 0
	q:(AElements="")||(AEpisodeID="") ret
	s ret = 1
	
	for i=1:1:$l(AElements,"\")
	{
		s CurrElement = $p(AElements,"\",i)
		s CurrElementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,CurrElement,"")
		s:(CurrElementData["死亡") ret = -1
		q:(ret=-1)	
	}
	q ret
}

/// 首页质控:主要诊断编码、其他诊断编码中存在Z51.1，化疗卡应填写完整（包括：化疗方式、方法、日期、药名及剂量、疗程、疗效）
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0089(EpisodeID,{HISDiagCodes},"Z51.1","")
ClassMethod IsUnify0089(AEpisodeID As %String, AElements As %String, AValues As %String, AQElements2 As %String) As %String
{
	s ret=0
   
	q:(AEpisodeID="")||(AElements="")||(AValues="")||(AQElements2="") ret
	
	s flag=0
	for I=1:1:$l(AElements,"\")
	{
		s Element=$p(AElements,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
		s ElementData=$tr(ElementData,"-\—\ ","")
		continue:(ElementData="")
		for J=1:1:$l(AValues,"\")
		{
			s Value=$p(AValues,"\",J)
			s:($e(ElementData,"1",$l(Value))=Value) flag=1
			q:(flag=1)
		}
		q:(flag=1)
	}
	q:(flag=0) ret
	s ret=1,flag2=0
	for K=1:1:$l(AQElements2,"\")
	{
		s Element2=$p(AQElements2,"\",K)
		s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
		s ElementData2=$tr(ElementData2,"-\—\ ","")
		s:(ElementData2="") flag2=1
		q:(flag2=1)
	}
	s:(flag2="1") ret="-1"
	q ret
}

/// 首页质控，患者诊断存在低风险病种诊断（如附件）时，且离院方式为5时，提示医生该病例为低风险组死亡病例
/// 首页质控，该病种为低风险病种，请根据主要诊断选择原则确定主诊
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0090(EpisodeID,{HISDiagCodes},"","5")
ClassMethod IsUnify0090(AEpisodeID As %String, AElements As %String, AElement2 As %String, AValue2 As %String) As %String
{
	s ret=0
   
	q:(AEpisodeID="")||(AElements="")||(AElement2="")||(AValue2="") ret
	
	s flag=0,ret=1
	for I=1:1:$l(AElements,"\")
	{
		s Element=$p(AElements,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
		s ElementData=$tr(ElementData,"-\—\ ","")
		continue:(ElementData="")
		s DictionaryID=""
		for
		{
			s DictionaryID=$o(^DHCEPRM.QualityDicI("IdxCode","LowRisk",DictionaryID))
			q:DictionaryID=""
			s OrderInfoID=""
			for
			{
				s OrderInfoID=$o(^DHCEPRM.QualityOrderI("IdxDictionaryID",DictionaryID,OrderInfoID))
				q:(OrderInfoID="")
				s objOrderInfo=##class(EPRmeta.Quality.QualityOrderInfo).%OpenId(OrderInfoID)
				continue:(objOrderInfo="")
				s OrderID=objOrderInfo.OrderID
				s:($e(ElementData,"1",$l(OrderID))=OrderID) flag=1
				q:(flag=1)
			}
		}
		q:(flag=1)
		
	}
	q:(flag=0) ret
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	s ElementData2=$tr(ElementData2,"-\—\ ","")
	q:(ElementData2'=AValue2) ret 
	s ret="-1"
	q ret
}

/// 首页质控，病案首页主诊断为低风险组病种 “出院情况”“医嘱离院方式”不能填死亡
/// 低风险病种诊断存在了表EPRmeta.Quality.LowRiskDiseases 中
/// Input:AElements (出院诊断，多个用"\"分隔)
///       AElements1 出院情况  AValue1（出院情况不允许的值）
///       AElement2  医嘱离院方式 AValue2 （医嘱离院方式不允许为的值）     
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0091(EpisodeID,{HISDiagCodes},{HISDiagCYQK},"187","死亡","死亡")
/// ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(1118240,236,"")
/// w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0091(1110812,"236","238\242\246\250\254\258\262\266\282\286\290\294\298\302\306\310",187,"死亡","死亡")
ClassMethod IsUnify0091(AEpisodeID As %String, AElements As %String, AElements1 As %String, AElement2 As %String, AValue1 As %String, AValue2 As %String) As %String
{
	s ret=0
   
	q:(AEpisodeID="")||(AElements="")||(AElements1="")||(AElement2="")||((AValue1=""))||(AValue2="") ret
	
	s flag=0,ret=1
	for I=1:1:$l(AElements,"\")
	{
		s Element=$p(AElements,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
		s ElementData=$tr(ElementData,"-\—\ ","")
		continue:(ElementData="")
		s DictionaryID=""
		for
		{
			s DictionaryID=$o(^DHCEPRM.QualityDicI("IdxCode","LowRisk",DictionaryID))
			q:DictionaryID=""
			s OrderInfoID=""
			for
			{
				s OrderInfoID=$o(^DHCEPRM.QualityOrderI("IdxDictionaryID",DictionaryID,OrderInfoID))
				q:(OrderInfoID="")
				s objOrderInfo=##class(EPRmeta.Quality.QualityOrderInfo).%OpenId(OrderInfoID)
				continue:(objOrderInfo="")
				s OrderID=objOrderInfo.OrderID
			
				s:($e(ElementData,"1",$l(OrderID))=OrderID) flag=1
				q:(flag=1)
			}
		}
		q:(flag=1)
		
	}
	
	
	
	q:(flag=0) ret
	
	s ElementFlag=0
	for J=1:1:$l(AElements1,"\")
	{
		s Elements1=$p(AElements1,"\",J)
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Elements1,"")
		s ElementData1=$tr(ElementData1,"-\—\ ","")
		continue:(ElementData1="")
	
		s:(ElementData1=AValue1) ret="-1"
		q:(ret="-1")
	}
	
	q:(ret="-1") ret	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	s ElementData2=$tr(ElementData2,"-\—\ ","")

	s:(ElementData2=AValue2) ret="-1" 
    q ret
}

/// 联系人地址不能为同上，可以为-，其余必须得大于10个字
/// AEpisodeID 就诊号  AElement联系人地址章节ID  AValue1 可以允许的字符，多个以"\"隔开 	AValue2 内容长度
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件  
/// Debug w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0092(EpisodeID,10037,"-\—",10)
ClassMethod IsUnify0092(AEpisodeID As %String, AElement As %String, AValue1 As %String, ALen As %String)
{
	s ret = 0
	q:(AElement="")||(AEpisodeID="") ret
	s ret = 1
	s ElementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
	q:(ElementData="") ret	
	s:(ElementData["同上") ret=-1
	q:(ret=-1) ret
	s ValueList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AValue1,"\")
	s flag = 0
	s flag = $lf(ValueList,ElementData)
	s:(flag=0)&&($l(ElementData)<=+ALen) ret=-1
	q ret
}

/// Desc 单位电话不能与其他电话相同
/// Input AEpisodeID 就诊号   AElement1 单位电话章节ID	AElements2 其他电话章节ID,以"\"隔开
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件  
/// Debug w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0093(EpisodeID,10033,"10026\10038")
ClassMethod IsUnify0093(AEpisodeID As %String, AElement1 As %String, AElements2 As %String)
{
	s ret = 0
	q:(AElement1="")||(AElements2="")||(AEpisodeID="") ret
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")	
	q:(ElementData1="") ret
	s ret = 1
	for i=1:1:$l(AElements2,"\")
	{
		s CurElement = $p(AElements2,"\",i)
		s CurElementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,CurElement,"")
		s:(CurElementData=ElementData1) ret=-1
		q:ret=-1	
	}
	
	q ret
}

/// 电子病历首页出院诊断和其他诊断不能出现D63、D77等开头的编码，
/// isnt1（"="或者"<>"）
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0094(EpisodeID,10332,"V","=")
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0094(2504703,"10074\10075\10076\10077\10078\10079\10080\10081\10082\10742\10743\10744\10745\10746\10747\10748\10749\10750\10751\10752\10753\10754\10755\10756\10757","D63\D77\E35\E90\FO0\F02\G01\G02\G05\G07","<>")
ClassMethod IsUnify0094(ArgEpisodeID As %String, ArgElements As %String, AValues As %String, Aisnt As %String, ArgExtValues As %String = "", AHisDeathDateTime As %String = "") As %String
{
	s ret=0
   
	q:(ArgEpisodeID="")||(ArgElements="")||(Aisnt="") ret
	s flag=0,ret=1
	for I=1:1:$l(ArgElements,"\")
	{
		s Element=$p(ArgElements,"\",I)
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,Element,"")
		s ElementData1=$tr(ElementData1,"-\—\ ","")
		continue:(ElementData1="")
		s ExtFlag=0
    	s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
		s ExtInd=1
		for {	
			s ExtValue=$listget(ExtValuels,ExtInd)
			q:ExtValue=""
			s:(ElementData1[ExtValue) ExtFlag=1
			s ExtInd=ExtInd+1	
			}
	
		continue:(ExtFlag=1) 
	
	
		if (Aisnt="<>")
		{
			 for j=1:1:$l(AValues,"\") 
			 {
				 s Value=$p(AValues,"\",j)
				
				 s:($e(ElementData1,"1",$l(Value))=Value) flag=1		
		     }
		}
		elseif (Aisnt="=")
		{
			
			for j=1:1:$l(AValues,"\")
			{
				s Value=$p(AValues,"\",j)
			    s:($e(ElementData1,"1",$l(Value))=Value) flag=1
			}			
		}
		
	}
	s:(flag=1) ret=-1
	
	q ret
}

/// 首页质控，编码为XXX的诊断为手术后并发症，请据实填写(诊断编码是指定编码，手术是择期手术、入院病情为“4（无）”的是手术并发症)
/// 手术并发真诊断存在了表EPRmeta_Quality.QualityOrderInfo 中,分类是"SSBFZ"
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0095(EpisodeID,{HISDiagCodes},择期手术Code,入院病情Code,"是","4")
ClassMethod IsUnify0095(AEpisodeID As %String, AElements As %String, AElement1 As %String, AElement2 As %String, AValue1 As %String, AValue2 As %String) As %String
{
	s ret=0
   
	q:(AEpisodeID="")||(AElements="")||(AElement1="")||(AElement2="")||(AValue1="")||(AValue2="") ret
	s SSBFZDicID=$o(^DHCEPRM.QualityDicI("IdxCode","SSBFZ",""))
	q:(SSBFZDicID="") ret
	s flag=0,ret=1
	for I=1:1:$l(AElements,"\")
	{
		s Element=$p(AElements,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
		s ElementData=$tr(ElementData,"-\—\ ","")
		continue:(ElementData="")
		s QualityOrderID=""
		for
		{
			s QualityOrderID=$o(^DHCEPRM.QualityOrderI("IdxDictionaryID"," "_SSBFZDicID,QualityOrderID))
			q:(QualityOrderID="")
			s objQualityOrder=##class(EPRmeta.Quality.QualityOrderInfo).%OpenId(QualityOrderID)
			continue:(objQualityOrder="")
			s IsActive=objQualityOrder.IsActive
			continue:(IsActive'="Y")
			s OrderID=objQualityOrder.OrderID
			s:($e(ElementData,"1",$l(OrderID))=LowRiskDiseases) flag=1
			q:(flag=1)
		}
		
	}
	q:(flag=0) ret
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	s ElementData1=$tr(ElementData1,"-\—\ ","")
	q:(ElementData1'=AValue1) ret
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	s ElementData2=$tr(ElementData2,"-\—\ ","")
	q:(ElementData2'=AValue2) ret 
	s ret="-1"
	q ret
}

/// 病案首页“切口愈合等级”处添加提示弹窗 ，如果选丙级，保存提示内容为：“丙级愈合：切口化脓，是否确认丙级愈合”。
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0095(EpisodeID,切口愈合等级Code1\切口愈合等级Code2\切口愈合等级Code3,"丙级")
ClassMethod IsUnify0096(AEpisodeID As %String, AElements As %String, AValue As %String) As %String
{
	s ret=0
   
	q:(AEpisodeID="")||(AElements="")||(AValue="") ret
	s flag=0,ret=1
	for I=1:1:$l(AElements,"\")
	{
		s Element=$p(AElements,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
		s ElementData=$tr(ElementData,"-\—\ ","")
		continue:(ElementData="")
		s:(ElementData=AValue) flag=1
	}
	q:(flag=0) ret 
	s ret="-1"
	q ret
}

/// 病案首页所有的地址信息增加质控，必须包含省、市
/// Debug: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0097(EpisodeID,"现住址code","省\市")
/// w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0097(1532979,10710,"省\市")
ClassMethod IsUnify0097(AEpisodeID As %String, AElement As %String, AValues As %String) As %String
{
	s ret = 0
	q:((AEpisodeID = "")||(AElement = "")||(AValues="")) ret

    s Elementdata=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
	s Elementdata=$tr(Elementdata,"—\-\ ","")

	q:Elementdata="" ret
	s flag=0
	s ret=1
	for i=1:1:$l(AValues,"\")
    {
	    s AValue=$p(AValues,"\",i)
	    q:AValue=""
	    s:(Elementdata[AValue) flag=flag+1
    }
    s:(flag'=$l(AValues,"\")) ret="-1"
	    

	q ret
}

/// //////////////////////////////  病案首页附页质控  /////////////////////////////////////////
/// 说明：病案首页附页.【抗菌药使用情况】只能选一个，不能选多个。
/// InPut: AEpisodeID 就诊号; AElement1  抗菌药使用情况单元rowid(这是一个多选单元)
/// Output: 0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件
/// Debug: ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnifyFY0001(EpisodeID,"")
ClassMethod IsUnifyFY0001(AEpisodeID As %String, AElement1 As %String) As %String
{
		s ret=0
		q:(AElement1="")||(AElement1="") ret
		
		s ret=1
		s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
		s:($l(ElementData1,",")>1) ret=-1  
		
        s ElementCode=""
        s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1)
        q ret_"@"_ElementCode
}

/// Desc: 当AElement1等于(或不等)某值时，限制AElement2必须等于(或不等)某值
///       (如:病案首页附页."医院感染情况"为有,"医院感染是否与手术相关"不能为空或"-")
/// InPut: AEpisodeID:就诊号,AElement1:条件单元,isnt1("="或"<>"),AValue1:条件值,AElement2:结果单元,isnt2("="或"<>"),AValue2:限定结果值
/// Output: 0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件
/// Debug: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnifyFY0002(EpisodeID,"条件单元code","=","条件值","结果单元","<>","结果值")
ClassMethod IsUnifyFY0002(AEpisodeID As %String, AElement1 As %String, isnt1 As %String, AValue1 As %String, AElement2 As %String, isnt2 As %String, AValue2 As %String) As %String
{
	s ret = 0
	q:((AEpisodeID = "")||(AElement1 = "")||(AElement2="")) ret
	
    s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
    s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	s:(isnt1="<>")&&(AValue1="") ElementData1=$tr(ElementData1,"-\—","")
	s:(isnt2="<>")&&(AValue2="") ElementData2=$tr(ElementData2,"-\—","")
	
	s ret=1
    if (isnt1="=")
    {
    	q:(ElementData1'=AValue1) ret
	    s:(isnt2="=")&&(ElementData2'=AValue2) ret=-1
	    s:(isnt2="<>")&&(ElementData2=AValue2) ret=-1
    }
	elseif (isnt1="<>")
	{
		q:(ElementData1=AValue1) ret
		s:(isnt2="=")&&(ElementData2'=AValue2) ret=-1
	    s:(isnt2="<>")&&(ElementData2=AValue2) ret=-1
    }
	
    s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
    q ret_"@"_ElementCode
}

/// 患者有"呼吸机医嘱"，则须完成<首页附页>
/// Input:	AEpisodeID为患者就诊号 ,AOrderInfo 呼吸机医嘱信息(不为空时质控), ADocID 附页展现结果模板ID ,ATemplateID 附页模板ID
/// Output:	ret=-1没填写; ret=1已填写; ret=0参数错误或无效;
/// Debug: ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnifyFY0003(39873534,{HISORDInfo},"376","185")
ClassMethod IsUnifyFY0003(AEpisodeID As %String, AOrderInfo As %String, ADocID As %String, ATemplateID As %String) As %String
{
	
	s ret = 0
	q:(AEpisodeID = "")||(AOrderInfo="")||(ADocID="")||(ATemplateID="") ret
	
	s ret = 1
	
	///是否完成附页
	s ECRecordID=""
	s ECRecordID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_ADocID,ECRecordID))
	q:(ECRecordID="") "-1"
	
	s IsFinishDocument=$d(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ECRecordID," "_ATemplateID," SAVE"))
	s:(IsFinishDocument'="10") ret=-1
	
	q ret
}

/// 患者有"呼吸机医嘱"，则必须填写【呼吸机使用时间】
/// Input:	AEpisodeID为患者就诊号, AOrderInfo 呼吸机医嘱信息(不为空时质控), AElementIDs 呼吸机时间
/// Output:	ret=-1没填写; ret=1已填写; ret=0参数错误或无效;
/// Debug: ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnifyFY0004(39873534,{HISORDInfo},"10382")
ClassMethod IsUnifyFY0004(AEpisodeID As %String, AOrderInfo As %String, AElementIDs As %String) As %String
{
	
	s ret = 0
	q:(AEpisodeID = "")||(AOrderInfo="")||(AElementIDs="") ret
	
	s ret = 1
	
	///呼吸机时间
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		s ElementData=$tr(ElementData,"-\—","")
		s:(ElementData="") ret="-1"
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementIDs)
    q ret_"@"_ElementCode
}

/// Desc: 		病历是否完成(全部完成算完成)
/// Creator:	Candy
/// CreateDate:	2014-9-26
/// InPut:		AEpisodeID 就诊号
/// 			AStructID 结构IDs多个以"#"分隔
/// 			AActionType 质控类型
/// 			ALocIDs 质控科室 多个以"^"分隔
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsDoneContent2(76,13,"")
ClassMethod IsDoneContent2(AEpisodeID As %String, AStructIDs As %String, AActionType As %String, ALocIDs As %String = "") As %String
{
	q:(AEpisodeID = "")||(AStructIDs = "") "0^参数异常!"
	if (ALocIDs '= "")
	{
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		q:(curAdmitLocID = "") "0^患者当前不属于任何一个科室,质控项目异常退出!"
		
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		q:($listfind(locIDs,curAdmitLocID) > 0) "1^患者当前所在科室不采用该质控项目,正常退出!"
	
	}
	s result = "1",ret=""
	s count = $l(AStructIDs,"#")
	for I=1:1:count
	{
		s StructID = $p(AStructIDs,"#",I) 
		
		s result = ..IsDoneContent1(AEpisodeID,StructID,AActionType)
		if ($p(result,"^",1) = "-1")
		{
			s StructIDdr=$p(StructID,"^",1)
			s StructName = ##Class(EPRmeta.Quality.QualityPool).GetStructByStructID(StructIDdr)
			s StructName=$p(StructName,".",2)
			s ret=ret_StructName_" "
		}
		
	}
	if (ret'=""){
		s ret="-1^"_ret
	} else{
		 s ret="1"
		}
	q ret
}

/// Desc: 		病历是否完成(超时完成算完成)
/// Creator:	Candy
/// CreateDate:	2014-9-26
/// Input:		AEpisodeID 就诊号
/// 			AStructID 结构ID
/// 			ADateTime 质控时间点
/// 			AHours	指定的小时数
/// 			AActionType 质控操作类型
/// 			ARuleType 检查类型(B为提示,提前预防)
/// 			ALocIDs 质控科室 多个以"^"分隔
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件
/// Debug: w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsDoneInTime2(4065958,365,"2014-10-11 15:36:00","",24,"","","")
ClassMethod IsDoneInTime2(AEpisodeID As %String, AStructID As %String, ADateTime As %String, ADisDateTime As %String, AHours As %String, AActionType As %String, ARuleType As %String, ALocIDs As %String = "") As %String
{
    
    s result = "0^配置错误"
    q:((AEpisodeID = "")||(AStructID = "")||(ADateTime = "")||(AHours = "")) result
    //s DisDateTime = $case(ADisDateTime,"":$zd(+$h,3)_" "_$zt($p($h,",",2),2),:ADisDateTime)
    s AHours = +AHours
    
    //计算结束日期
    s ADateTimes=##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ADateTime)
    s hours=AHours/24
    s DisDate=$p(ADateTimes," ",1)
    s DisTime=$p(ADateTimes," ",2)
    s hDay=$p(hours,".",1)
    s hTime=hours-hDay
    s DisTime=$zth(DisTime,3)+(hTime*24*3600)
    if (DisTime>"86398"){
	    s DisTime=DisTime-86399
	    s hDay=hDay+1
	    }
    s DisDate=$zdh(DisDate,3)+hDay
    s DisDate=$zd(DisDate,3)
    s DisTime=$zt(DisTime,1)
    s DisDateTime=DisDate_" "_DisTime
    
    s NowDateTime = $case("","":$zd(+$h,3)_" "_$zt($p($h,",",2),2),:"")
    
    
	s result = 1
	//q:((AHours > tmpHours) && ($zcvt(ARuleType,"U") '= "B")) result
	if (ALocIDs '= "") 
	{
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4) 
		q:(curAdmitLocID = "") "0^患者当前不属于任何一个科室,质控项目异常退出!"
		
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		q:($listfind(locIDs,curAdmitLocID) > 0) "1^患者当前所在科室不采用该质控项目!"	
	}
	s StructName = ##Class(EPRservice.Quality.GetStructResult).GetStructByStructID(AStructID)
	s StructName=$p(StructName,".",2)
	s resultInfo = ..IsDoneContent(AEpisodeID,AStructID,AActionType)
	s flag = $p(resultInfo,"^",1)
	/*if (flag = "1")
	{	
		s accomp=$zd($p(resultInfo,"^",3),3)_" "_$zt($p(resultInfo,"^",4),1)
		s Hours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DisDateTime,accomp)
		if (Hours<0)
		{
			s result="-1"_"^"_StructName_"^"_ADateTime_"^"_DisDateTime_"^"_Hours_"^"_accomp
		}
		else
		{
			s result=flag_"^"_StructName_"^"_ADateTime_"^"_DisDateTime_"^"_Hours_"^"_accomp
		}

	} */
	if (flag = "-1")
	{
		/*s Interval = $j(tmpHours - AHours,1,1)
		s:(tmpHours > AHours) result = "-1^超"_Interval_"小时未完成!"
		s:(AHours > tmpHours) result = "-1^请在"_-Interval_"小时内完成病历!"
		*/
		s Hours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DisDateTime,NowDateTime)
		s result=flag_"^"_StructName_"^"_ADateTime_"^"_DisDateTime_"^"_Hours_"^"_""
	}
	else
	{
		//s result = resultInfo
		s accomp=$zd($p(resultInfo,"^",3),3)_" "_$zt($p(resultInfo,"^",4),1)
		s Hours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DisDateTime,accomp)
		if (Hours<0)
		{
			s result="-1"_"^"_StructName_"^"_ADateTime_"^"_DisDateTime_"^"_Hours_"^"_accomp
		}
		else
		{
			s result="-1"_"^"_StructName_"^"_ADateTime_"^"_DisDateTime_"^"_""_"^"_accomp
		}
	}
 	q result
}

/// Desc:		可重复模板记录是否在规定的时间内完成
///      		如:判断抢救记录是否在抢救后6小时内完成 
/// Creator:	yhy
/// Createdate:	2017-03-29
/// Input：		AEpisodeID:就诊号
///        		ATitles:StructID|可重复模板标题\可重复模板标题(StructID:结构ID)	 
///        		ADateTimes:用"\"分隔的日期串
/// 		   		AHours:多少小时内完成
/// 	  		AAction:操作类型(完成,提交,打印)
///        		ARuleType 质控类型(B：提示)
/// OutPut：	result<0 不一致
/// Debug：		w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsDoneRecord2(69,"348|116|住院医师查房记录","2013-03-22 14:46:34",2,"提交","b")
ClassMethod IsDoneRecord3(AEpisodeID As %String, ATitles As %String, ADateTimes As %String, AHours As %String, AActionType As %String, ARuleType As %String = "", ATitleCongruent As %String = "C") As %String
{

	s result = "0^配置错误",errInfo = "",count = 0,CreateDate=""
	q:((AEpisodeID = "")||(ATitles = "")||(AHours = "")||(ADateTimes = "")) result
	for i = 1:1:$l(ATitles,"\")
	{
		s Titles = $p(ATitles,"\",i)
		s StructID = $p(Titles,"|",1)
		continue:(StructID = "") 
		s objStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(StructID)
		continue:(objStruct = "") 
		continue:(objStruct.IsActive '= "Y") 
		continue:((objStruct.BindCategoryId = "")||(objStruct.BindCategoryId = $c(0))) 

		s ADateTime=##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ADateTimes)
	    s hours=AHours/24
	    s DisDate=$p(ADateTime," ",1)
	    s DisTime=$p(ADateTime," ",2)
	    s hDay=$p(hours,".",1)
	    s hTime=hours-hDay
	    s DisTime=$zth(DisTime,3)+(hTime*24*3600)
	    if (DisTime>"86398"){
		    s DisTime=DisTime-86399
		    s hDay=hDay+1
		    }
	    s DisDate=$zdh(DisDate,3)+hDay
	    s DisDate=$zd(DisDate,3)
	    s DisTime=$zt(DisTime,1)
	    s DisDateTime=DisDate_" "_DisTime
		s titles = $p(Titles,"|",2)
	
		s result = 1
		s AHours = +AHours
		s checkDateTime = $tr($h,","," ")
		s NowDateTime = $case("","":$zd(+$h,3)_" "_$zt($p($h,",",2),2),:"")
		s timeList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ADateTimes,"\")
		s addDate = (+AHours * 3600)\86400
		s addTime = (+AHours * 3600)#86400
		for ind = 1:1:$listlength(timeList)
		{
			s tempDateTime = $listget(timeList,ind)
			s tempDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(tempDateTime)
			s tempDate = $p(tempDateTime," ",1)
			continue:(tempDate ="")
			s tempTime = $p(tempDateTime," ",2)
			//是否到质控时间
			s tempGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,tempDate_" "_tempTime)
			continue:((+tempGap < AHours) && ($zcvt(ARuleType,"U") '= "B")) //如果不是提示标准,不到时间不质控
		
			s results = ##Class(%ScrollableResultSet).%New("EPRservice.Quality.EmrCheckRule.Template:GetMultiTempalteInfo")
		
			d results.Execute(AEpisodeID,objStruct.BindCategoryId,"","","","",titles,ATitleCongruent,AActionType)
			while results.Next() {
		
				//continue:(results.Count()>0)
				s CreateDate = results.Data("HappenDate")
				s CreateTime = results.Data("HappenTime")
			}
			if (CreateDate'="")
			{
			
				s CreateDate=$zd(CreateDate,3)
	   			s CreateTime=$zt(CreateTime,1)
	    		s CreatDateTime=CreateDate_" "_CreateTime
			}
			else
			{
				s CreatDateTime=""
			}
		
		   // s Hours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap($zd(tempDate+addDate,3)_" "_$zt(tempTime+addTime),NowDateTime)
		    if (CreatDateTime="")
		    {
			    s Hours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DisDateTime,NowDateTime)
		    }
		    else
		    {
			    s Hours=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DisDateTime,CreatDateTime)
			    s:(Hours>0) Hours=""
			}
		    //s errInfo = titles_"^"_ADateTimes_"^"_$zd(tempDate+addDate,3)_" "_$zt(tempTime+addTime)_"^"_Hours_"^"_CreatDateTime
		    s errInfo = titles_"^"_ADateTimes_"^"_DisDateTime_"^"_Hours_"^"_CreatDateTime
		  	//s result = errInfo
		    //s count = count + 1
		    s:CreatDateTime'="" count = count + 1
		} 
		q:count>0
	}
	s:(count > 0 ) result = -1
	q -1_"^"_errInfo
}

/// Desc:	缺少每天至少一次的病程记录
///     	缺少7天一次的主任医师查房记录
///     	缺少30天一次的阶段小结
/// Creator:HKY
/// Output:	ret<0 不一致
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsRecordSavDurRightDay(AEpisodeID,ATitles,ARegDateTime,ADisDateTime,ADays,AConditions)
/// 		w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsRecordSavDurRightDay(4065871,"371|阶段小结","2014-09-19 09:39:00","")ADays,AConditions)
ClassMethod IsRecordSavDurRightDay1(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, ADisDateTime As %String, ADays As %String, AConditions As %String = "") As %String
{
	s ret = 0, errInfo = ""
	q:(AEpisodeID = "")||(ATitles = "")||(ARegDateTime = "")||(ADays = "") ret

	s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s disDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	
	s checkDate = $p(disDateTime," ",1)
	s:(checkDate = "") checkDate = +$h
	
	s fromDate = $p(regDateTime," ",1)
	s toDate = +checkDate
	
	s ret = 1
	s Title=$p(ATitles,"|",2)
	if (Title'="")
	{
		s StructName=Title
	}
	else
	{
		s StructNo=$p(ATitles,"|",1)
		s StructName = ##Class(EPRmeta.Quality.QualityPool).GetStructByStructID(StructNo)
		s StructName=$p(StructName,".",2)	
	}
	s errInfo=""	
	for tmpDate = fromDate:$g(ADays):toDate
	{ 
		q:(checkDate <= (tmpDate + ADays))
		s result = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,0,tmpDate+ADays,0)
		q:($e(result,1,2) = "0^")
		s count = +$e(result,3,$l(result))
		q:(count > 0)
		s:(errInfo'="") errInfo=errInfo_";"_-1_"^"_StructName_"^"_$zd(tmpDate,3)_"^"_$zd(tmpDate+ADays-1,3)_"^"_""

		s:(errInfo="") errInfo=-1_"^"_StructName_"^"_$zd(tmpDate,3)_"^"_$zd(tmpDate+ADays-1,3)_"^"_""
		s ret = errInfo
	}
	//b "s"  //Add , Conditions As %String =""
	if (AConditions '= "")&&(+ret = -1)
	{
		s result = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,0,tmpDate+ADays,0)
		q:($e(conResult,1,2) = "0^") ret
		s count = +$e(conResult,3,$l(conResult))
		s:(count > 0) ret = 1
	}
	//wwt and
	
	q ret
}

/// 判定几天一次病程记录(按照上次书写记录时间算起)
/// w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck)IsRecordFinOnTimeByInsData(EpisodeID,ATitles,{HISRegTime},{HISDischTime},3)
ClassMethod IsRecordFinOnTimeByInsData(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, ADisDateTime As %String, ADays As %String, ATitleCongruent As %String = "C", ATimeType As %String = "H", AActionType As %String = "") As %String
{
	s ret = 0, errInfo = "",count = 0
	q:((AEpisodeID = "")||(ATitles = "")||(ARegDateTime = "")||(ADays = "")) ret
    
	s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s disDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	
	s checkDate = $p(disDateTime," ",1)
	s:(checkDate = "") checkDate = $p($h,",",1)
	s checkTime = $p(disDateTime," ",2)
	s:(checkTime = "") checkTime = $p($h,",",2)
	
	s fromDate = $p(regDateTime," ",1)
	s fromTime = $p(regDateTime," ",2)
	s:(fromTime = "") fromTime = 0
	s toDate = +checkDate
	s toTime=+checkTime
	q:((toDate-fromDate)<=ADays) ret
    s result = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiTemHaDateTime(AEpisodeID,ATitles,"","","","",ATitleCongruent,ATimeType,AActionType)
	q:($e(result,1,2) = "0^") ret
	s dateTimes= $e(result,3,$l(result))
	
	s dateTimes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(dateTimes,"\")

	s:(dateTimes = "") ret=-1
	q:(ret=-1) ret
	s dateTimes=$lb(fromDate_" "_fromTime)_dateTimes_$lb(toDate_" "_toTime)
	s ret = 1
	s AHours=ADays*24
	f ind = 1:1:$listlength(dateTimes) 
	{
	  s dateTime1= $listget(dateTimes,ind)
	  q:(dateTime1 = "")
	  s dateTime2 = $listget(dateTimes,ind+1)
	  q:(dateTime2="")
	  s checkTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(dateTime2,dateTime1)
	  s:(checkTimeGap>AHours) errInfo=errInfo_" 缺少"_$zd(dateTime1,3)_"至"_$zd(dateTime1+ADays)_"的一次记录!"
	  s:(checkTimeGap>AHours) count = count + 1
	}
	s:(count > 0 ) ret = -1
	q ret_"^"_errInfo_"^"_count
}

/// 病程记录.患者出院当天必须有一次病程记录
/// Creator:	HKY
/// CreateDate:	2018-11-14
/// Input:		AEpisodeID 就诊号
/// 			ATitles：格式(质控结构ID|模板标题\模板标题#质控结构ID|模板标题\模板标题)
///             ADisDateTime 出院时间
/// 			ATitleCongruent 标题包含还是等于值域:(E 等于,C 包含)
/// 			AActionType 操作类型(保存、打印、签名)
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsWriteRecordOnDisDate(EpisodeID,"365|记录\阶段小结",{HISDischTime})                           
ClassMethod IsWriteRecordOnDisDate(AEpisodeID As %String, ATitles As %String, ADisDateTime As %String, ATitleCongruent As %String = "C", ATimeType As %String = "H", AActionType As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID="")||(ATitles="")||(ADisDateTime="") ret
	s dischDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	s checkDate = $p(disDateTime," ",1)
	s Title=$p(ATitles,"|",2)
	if (Title'="")
	{
		s StructName=Title
	}
	else
	{
		s StructNo=$p(ATitles,"|",1)
		s StructName = ##Class(EPRmeta.Quality.QualityPool).GetStructByStructID(StructNo)
		s StructName=$p(StructName,".",2)	
	} 
	s result=##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,checkDate,0,checkDate,86399,ATitleCongruent,ATitleCongruent,AActionType)
	q:($e(result,1,2)="0^") ret
	s ret = 1
	s count=+$e(result,3,$l(result))
	q:(count>0) ret
	
	s ret=-1
	q ret
}

/// 病程记录.患者输血(或其他操作)当天需完成一次病程记录
/// Creator:	Guanyu
/// CreateDate:	2020-02-10
/// Input:		AEpisodeID 就诊号
/// 			ATitles：格式(质控结构ID|模板标题\模板标题#质控结构ID|模板标题\模板标题)
///             AOperDates 输血(或其他操作)日期(多个用"\"分隔)
/// 			ATitleCongruent 标题包含还是等于值域:(E 等于,C 包含)
///             ATimeType 取时间类型(H 发生时间,C 创建时间)
/// 			AActionType 操作类型(保存、打印、签名)
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsWriteRecordOnOPDate(EpisodeID,"366|记录\阶段小结",{HISOPDates})                           
ClassMethod IsWriteRecordOnOPDate(AEpisodeID As %String, ATitles As %String, AOperDates As %String, ATitleCongruent As %String = "C", ATimeType As %String = "H", AActionType As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID="")||(ATitles="")||(AOperDates="") ret
	
	s Title=$p(ATitles,"|",2)
	if (Title'="")
	{
		s StructName=Title
	}
	else
	{
		s StructNo=$p(ATitles,"|",1)
		s StructName = ##Class(EPRservice.Quality.GetStructResult).GetStructByStructID(StructNo)
		s StructName=$p(StructName,".",2)	
	} 
	
	s ret = 1,errInfo=""
	for I=1:1:$l(AOperDates,"\")
	{
		s OperDate=$p(AOperDates,"\",I)
		s OperDate = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(OperDate)
		s checkDate = $p(OperDate," ",1)
		
		s result=##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,checkDate,0,checkDate,86399,ATitleCongruent,ATitleCongruent,AActionType)
		s count=+$e(result,3,$l(result))
		continue:(count>0)
		
		s ret=-1
		s:(errInfo'="") errInfo=errInfo_"/"_$zd(checkDate,3)
		s:(errInfo="") errInfo=$zd(checkDate,3)
	}
	s:(errInfo'="") ret=ret_"^"_"缺少"_errInfo_"的记录."
	q ret
}

/// 病程记录.患者手术(或其他操作)前*天/*小时需完成一次病程记录
/// Creator:	Guanyu
/// CreateDate:	2020-02-10
/// Input:		AEpisodeID 就诊号
/// 			ATitles：格式(质控结构ID|模板标题\模板标题#质控结构ID|模板标题\模板标题)
///             AOperDates 手术(或其他操作)日期(多个用"\"分隔)
///             AHours 手术(或其他操作)前小时数
/// 			ATitleCongruent 标题包含还是等于值域:(E 等于,C 包含)
///             ATimeType 取时间类型(H 发生时间,C 创建时间)
/// 			AActionType 操作类型(保存、打印、签名)
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsWriteRecordBefOPDate(EpisodeID,"366|记录\阶段小结",{HISOPDates},24)                           
ClassMethod IsWriteRecordBefOPDate(AEpisodeID As %String, ATitles As %String, AOperDates As %String, AHours As %String, ATitleCongruent As %String = "C", ATimeType As %String = "H", AActionType As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID="")||(ATitles="")||(AOperDates="") ret
	
	s Title=$p(ATitles,"|",2)
	if (Title'="")
	{
		s StructName=Title
	}
	else
	{
		s StructNo=$p(ATitles,"|",1)
		s StructName = ##Class(EPRservice.Quality.GetStructResult).GetStructByStructID(StructNo)
		s StructName=$p(StructName,".",2)	
	} 
	
	s ret = 1,errInfo=""
	s Days=AHours/24
	s:(Days<1) Days=1
	for I=1:1:$l(AOperDates,"\")
	{
		s OperDate=$p(AOperDates,"\",I)
		s OperDate = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(OperDate)
		s checkDate = $p(OperDate," ",1)
		
		s result=##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,checkDate-Days,0,checkDate,86399,ATitleCongruent,ATitleCongruent,AActionType)
		s count=+$e(result,3,$l(result))
		continue:(count>0)
		
		s ret=-1
		s:(errInfo'="") errInfo=errInfo_"/"_$zd(checkDate-Days,3)_"至"_$zd(checkDate,3)
		s:(errInfo="") errInfo=$zd(checkDate-Days,3)_"至"_$zd(checkDate,3)
	}
	s:(errInfo'="") ret=ret_"^"_"缺少"_errInfo_"的记录."
	q ret
}

/// 患者有某特殊医嘱时，检查是否缺少某可重复模板
/// Creator:	Guanyu
/// CreateDate:	2020-02-11
/// Input:		AEpisodeID 就诊号
/// 			ATitles：格式(质控结构ID|模板标题\模板标题)
///             AOrdDateTime:特殊医嘱时间
///             ADisDateTime 出院/死亡时间
/// 			ATitleCongruent 标题包含还是等于值域:(E 等于,C 包含)
///             ATimeType 取时间类型(H 发生时间,C 创建时间)
/// 			AActionType 操作类型(保存、打印、签名)
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsMultiWrite(EpisodeID,"365|记录\阶段小结",{ORDDateTimes},{HISDischTime})                           
ClassMethod IsMultiWrite(AEpisodeID As %String, ATitles As %String, AOrdDateTime As %String, ADisDateTime As %String, ATitleCongruent As %String = "C", ATimeType As %String = "H", AActionType As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID="")||(ATitles="")||(AOrdDateTime="") ret
	
	s Title=$p(ATitles,"|",2)
	if (Title'="")
	{
		s StructName=Title
	}
	else
	{
		s StructNo=$p(ATitles,"|",1)
		s StructName = ##Class(EPRservice.Quality.GetStructResult).GetStructByStructID(StructNo)
		s StructName=$p(StructName,".",2)
	}
	
	s ret = 1,errInfo=""
	for I=1:1:$l(AOrdDateTime,"\")
	{
		s StOrdDateTime=$p(AOrdDateTime,"\",I)
		s EndOrdDateTime=$p(AOrdDateTime,"\",I+1)
		s StDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StOrdDateTime)
		s:(EndOrdDateTime'="") EndOrdDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndOrdDateTime)
		s:(EndOrdDateTime="") EndOrdDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
		s:(EndOrdDateTime="") EndOrdDateTime=$tr($h,","," ")
		
		s StartDate=$p(StOrdDateTime," ",1)
		s StartTime=$p(StOrdDateTime," ",2)
		s EndDate=$p(EndOrdDateTime," ",1)
		s EndTime=$p(EndOrdDateTime," ",2)
		
		///s result=##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,StartDate,StartTime,EndDate,EndTime,ATitleCongruent,ATimeType,AActionType)
		s result=##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,StartDate,0,EndDate,86399,ATitleCongruent,ATimeType,AActionType)
		s count=+$e(result,3,$l(result))
		continue:(count>0)
		s ret=-1
		s:(errInfo'="") errInfo=errInfo_"/"_$zd(StartDate,3)_" "_$zt(StartTime)_"至"_$zd(EndDate,3)_" "_$zt(EndTime)
		s:(errInfo="") errInfo=$zd(StartDate,3)_" "_$zt(StartTime)_"至"_$zd(EndDate,3)_" "_$zt(EndTime)
	}
	s:(errInfo'="") ret=ret_"^"_"缺少"_errInfo_"的记录."
	q ret
}

/// 病程记录.患者转科(或其他操作)前需完成转出(或其他操作)记录
/// Creator:	Guanyu
/// CreateDate:	2020-02-11
/// Input:		AEpisodeID 就诊号
/// 			ATitles：格式(质控结构ID|模板标题\模板标题#质控结构ID|模板标题\模板标题)
///             ARegDateTime 患者入院时间(一般取安床时间)
///             AOrdItems 转科(或其他操作)医嘱项ID(多个用"\"分隔)
/// 			ATitleCongruent 标题包含还是等于值域:(E 等于,C 包含)
///             ATimeType 取时间类型(H 发生时间,C 创建时间)
/// 			AActionType 操作类型(保存、打印、签名)
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsWriteBefOrder(EpisodeID,"366|转科记录",{HISRegTime1},{HISORDTimes})                          
ClassMethod IsWriteBefOrder(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, AOrdDateTimes As %String, ATitleCongruent As %String = "C", ATimeType As %String = "H", AActionType As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID="")||(ATitles="")||(ARegDateTime="")||(AOrdDateTimes="") ret
	
	s Title=$p(ATitles,"|",2)
	if (Title'="")
	{
		s StructName=Title
	}
	else
	{
		s StructNo=$p(ATitles,"|",1)
		s StructName = ##Class(EPRservice.Quality.GetStructResult).GetStructByStructID(StructNo)
		s StructName=$p(StructName,".",2)	
	} 
	
	s OrderDatestr=""
	s StDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s OrderDatestr=StDateTime_"\"_AOrdDateTimes
	
	s ret=1,errInfo=""
	for I=1:1:$l(OrderDatestr,"\")
	{
		s StartDate=$p($p(OrderDatestr,"\",I)," ",1)
		s StartTime=$p($p(OrderDatestr,"\",I)," ",2)
		s EndDate=$p($p(OrderDatestr,"\",I+1)," ",1)
		s EndTime=$p($p(OrderDatestr,"\",I+1)," ",2)
		q:(EndDate="")
		
		s result=##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,StartDate,0,EndDate,86399,ATitleCongruent,ATimeType,AActionType)
		s count=+$e(result,3,$l(result))
		continue:(count>0)
		
		s ret=-1
		s:(errInfo'="") errInfo=errInfo_"/"_$zd(StartDate,3)_" "_$zt(StartTime)_"至"_$zd(EndDate,3)_" "_$zt(EndTime)
		s:(errInfo="") errInfo=$zd(StartDate,3)_" "_$zt(StartTime)_"至"_$zd(EndDate,3)_" "_$zt(EndTime)
	}
	s:(errInfo'="") ret=ret_"^"_"缺少"_errInfo_"的记录."
	
	q ret
}

/// /////////////////////////////////////////////////////////////////////////////////////////////////
/// Desc: 		唯一模板病历是否在指定时间内完成
/// Creator:	HKY
/// CreateDate:	2018-11-12
/// Input:		AEpisodeID 就诊号
/// 			AStructIDs 结构ID字符串
/// 			ADateTime 质控起始时间
/// 			AHours	指定的小时数
///             ADisDateTime 质控结束时间
/// 			AActionType 质控操作类型(保存、打印、签名)
/// 			ARuleType 检查类型(B为提示,提前预防)
///             AOutTimeWritePrompt(Y 超时补写提示,N 超时补写不提示)
/// 			ALocIDs 质控科室 多个以"^"分隔
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件
/// Debug: w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHSingleIsDoneInTime(185,"362^363^364","2018-03-27 15:08:00","",24,"","","N")
ClassMethod RHSingleIsDoneInTime(AEpisodeID As %String, AStructIDs As %String, ADateTime As %String, ADisDateTime As %String, AHours As %String, AActionType As %String, ARuleType As %String, AOutTimeWritePrompt As %String = "N", ALocIDs As %String = "") As %String
{
	s result = "0^配置错误"
	   
    q:((AEpisodeID = "")||(AStructIDs = "")||(ADateTime = "")||(AHours = "")||(AOutTimeWritePrompt="")) result
   
	if (ALocIDs '= "")
	{
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		q:(curAdmitLocID = "") "0^患者当前不属于任何一个科室,质控项目异常退出!"
		
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		q:($listfind(locIDs,curAdmitLocID) > 0) "1^患者当前所在科室不采用该质控项目,正常退出!"
	}
	
	s result = "1"
	s count = $l(AStructIDs,"^")
	for I=1:1:count
	{
		s StructID = $p(AStructIDs,"^",I)
	
		s result = ..RHIsDoneInTime(AEpisodeID,StructID,ADateTime,ADisDateTime,AHours,AActionType,ARuleType,AOutTimeWritePrompt)
	
		q:($p(result,"^",1) = "1")||((AOutTimeWritePrompt="Y")&&($p(result,"^",6)'=""))
	}
	q result
}

ClassMethod RHIsDoneInTime(AEpisodeID As %String, AStructID As %String, ADateTime As %String, ADisDateTime As %String, AHours As %String, AActionType As %String, ARuleType As %String, AOutTimeWritePrompt As %String = "N") As %String
{
    s result = "0^配置错误"
    q:((AEpisodeID = "")||(AStructID = "")||(ADateTime = "")||(AHours = "")||(AOutTimeWritePrompt="")) result
    s DisDateTime = $case(ADisDateTime,"":$zd($p($h,",",1),3)_" "_$zt($p($h,",",2)),:ADisDateTime)
    s AHours = +AHours
    s tmpHours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DisDateTime,ADateTime)
	q:(tmpHours < 0) result
	s result = 1
	q:((AHours > tmpHours) && ($zcvt(ARuleType,"U") '= "B")) result
    //计算要求的完成日期时间
    s ADateTimes=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADateTime)
    s addDate = (+AHours * 3600)\86400
	s addTime = (+AHours * 3600)#86400
	
    s QualityDate=$p(ADateTimes," ",1)+addDate
    s QualityTime=$p(ADateTimes," ",2)+addTime
    s:(QualityTime>86399) QualityDate=QualityDate+1
    s:(QualityTime>86399) QualityTime=QualityTime-86399
    s QualityDateTime=$zd(QualityDate,3)_" "_$zt(QualityTime,1)
    
    s NowDateTime = $case("","":$zd(+$h,3)_" "_$zt($p($h,",",2),2),:"")
    
    
	s result = 1
	
	s StructName = ##Class(EPRservice.Quality.GetStructResult).GetStructByStructID(AStructID)
	s StructName=$p(StructName,".",2)
	s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()  //BS版本质控维护程序是否启用
	if (IsBSQualityEnable="Y")
	{
		s resultInfo = ..IsDoneContentNew(AEpisodeID,AStructID,AActionType)
	}
	else
	{
		s resultInfo = ..IsDoneContent(AEpisodeID,AStructID,AActionType)
	}
	
	s flag = $p(resultInfo,"^",1)

	if (flag = "-1")
	{
		
		s Hours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(QualityDateTime,NowDateTime)
		s result=flag_"^"_StructName_"^"_ADateTime_"^"_QualityDateTime_"^"_Hours_"^"_""
	}
	else
	{
		//取模板完成时间
		//s accomp=$zd($p(resultInfo,"^",3),3)_" "_$zt($p(resultInfo,"^",4),1)
		s accomp=$zd($p($p(resultInfo,"^",2),$c(1),2),3)_" "_$zt($p($p(resultInfo,"^",2),$c(1),3),1)
		s Hours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(QualityDateTime,accomp)
		
		if (Hours<0)&&(AOutTimeWritePrompt="Y")
		{
			s result="-1"_"^"_StructName_"^"_ADateTime_"^"_QualityDateTime_"^"_Hours_"^"_accomp
		}
		elseif ((Hours<0)&&(AOutTimeWritePrompt="N"))
		{
		  s result="1"_"^"_StructName_"^"_ADateTime_"^"_QualityDateTime_"^"_Hours_"^"_accomp	
		}
		/*else
		{
			s result="-1"_"^"_StructName_"^"_ADateTime_"^"_QualityDateTime_"^"_""_"^"_accomp
		}*/
	}

 	q result
}

/// Desc: 		可重复模板病历是否在指定时间内完成
///             (首次病程记录必须在入院8小时完成
///              上级医师首次查房记录必须在入院48小时内完成）
/// Creator:	HKY
/// CreateDate:	2018-11-12
/// Input:		AEpisodeID 就诊号
/// 			AStructIDs 结构ID字符串
/// 			ADateTime 质控起始时间
/// 			AHours	指定的小时数
///             ADisDateTime 质控结束时间
/// 			AActionType 质控操作类型(保存、打印、签名)
/// 			ARuleType 检查类型(B为提示,提前预防)
///             AOutTimeWritePrompt(Y 超时补写提示,N 超时补写不提示)
/// 			ALocIDs 质控科室 多个以"^"分隔
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件
/// Debug: w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHMultiIsDoneInTime1(185,"365|首次病程记录","2018-03-27 15:08:00","",8,"","","Y")
ClassMethod RHMultiIsDoneInTime1(AEpisodeID As %String, ATitles As %String, ADateTime As %String, ADisDateTime As %String, AHours As %String, AActionType As %String, ARuleType As %String = "", AOutTimeWritePrompt As %String = "N", ATitleCongruent As %String = "C") As %String
{
	s result = "0^配置错误",errInfo = "",count = 0,CreatDateTime=""
	q:((AEpisodeID = "")||(ATitles = "")||(AHours = "")||(ADateTime = "")) result
	s ADateTimes=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADateTime)
	s:(ADisDateTime'="") ADisDateTime=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	s checkDateTime = $case(ADisDateTime,"":$p(+$h,",",1)_" "_$p($h,",",2),:ADisDateTime)
	s AHours = +AHours
	s addDate = (+AHours * 3600)\86400
    s addTime = (+AHours * 3600)#86400
    
    s QualityDate=$p(ADateTimes," ",1)+addDate
    s QualityTime=$p(ADateTimes," ",2)+addTime
    s:(QualityTime>86399) QualityDate=QualityDate+1
    s:(QualityTime>86399) QualityTime=QualityTime-86399
    
    s QualityDateTime=$zd(QualityDate,3)_" "_$zt(QualityTime,1)
    s NowDateTime = $case("","":$zd(+$h,3)_" "_$zt($p($h,",",2),2),:"")
    //是否到质控时间
	s tempGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,ADateTime)
	q:((+tempGap < AHours) && ($zcvt(ARuleType,"U") '= "B")) result //如果不是提示标准,不到时间不质控
	
	for i = 1:1:$l(ATitles,"\")
	{
		s Titles = $p(ATitles,"\",i)
		s StructID = $p(Titles,"|",1)
		s Title=$p(Titles,"|",2)
		continue:(StructID = "") 
		s objStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(StructID)
		continue:(objStruct = "") 
		continue:(objStruct.IsActive '= "Y") 
		continue:((objStruct.BindCategoryId = "")||(objStruct.BindCategoryId = $c(0))) 
		
		s results = ##Class(%ScrollableResultSet).%New("EPRservice.Quality.EmrCheckRule.Template:GetMultiTempalteInfo")
		d results.Execute(AEpisodeID,objStruct.BindCategoryId,"","","","",Title,ATitleCongruent,AActionType)
		s count = results.Count()
		
		//未书写提示标准
		if ((count <1)) 
		{   s Hours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(QualityDateTime,NowDateTime)
			s errInfo = Title_"^"_ADateTime_"^"_QualityDateTime_"^"_Hours_"^"_CreatDateTime
			s result="-1"_"^"_errInfo
		}
	    //已书写提示标准
		else
		{
		
	      while (results.Next())
	     {
		    s CreateDate = results.Data("HappenDate")
		    s CreateTime = results.Data("HappenTime")
		    s CreatDateTime=$zd(CreateDate,3)_" "_$zt(CreateTime,1)
		   
			 s Hours=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(QualityDateTime,CreatDateTime)
			 s:(Hours>0) Hours="",result=1
			 
			 s:(AOutTimeWritePrompt="N")&&(Hours<0) result=1
			 q:(result=1)
			 s errInfo = Title_"^"_ADateTime_"^"_QualityDateTime_"^"_Hours_"^"_CreatDateTime
			 s:(Hours<0)&&(AOutTimeWritePrompt="Y") result="-1"_"^"_errInfo
		   }
		}
	}	
	   q result
}

/// Desc: 		可重复模板病历是否在指定时间内完成
///             (抢救病人抢救医嘱6小时后必须写抢救记录
///              手术病人术后24小时内必须写手术记录）
/// Creator:	HKY
/// CreateDate:	2018-11-12
/// Input:		AEpisodeID 就诊号
/// 			AStructIDs 结构ID字符串
/// 			ADateTime 质控起始时间
/// 			AHours	指定的小时数
///             ADisDateTime 质控结束时间
/// 			AActionType 质控操作类型(保存、打印、签名)
/// 			ARuleType 检查类型(B为提示,提前预防)
///             AOutTimeWritePrompt(Y 超时补写提示,N 超时补写不提示)
/// 			ALocIDs 质控科室 多个以"^"分隔
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件
/// Debug: w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHMultiIsDoneInTime2(185,"365|抢救记录","64994 29567","",6,"","","C","Y")
ClassMethod RHMultiIsDoneInTime2(AEpisodeID As %String, ATitles As %String, ADateTimes As %String, ADisDateTime As %String, AHours As %String, AActionType As %String, ARuleType As %String = "", ATitleCongruent As %String = "C", AOutTimeWritePrompt = "N") As %String
{
	s result = "0^配置错误",errInfo = "",count = 0,CreateDate="",CreatDateTime=""
	q:((AEpisodeID = "")||(ATitles = "")||(AHours = "")||(ADateTimes = "")) result
	s:(ADisDateTime'="") ADisDateTime=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	s checkDateTime = $case(ADisDateTime,"":$p(+$h,1)_" "_$p($h,",",2),:ADisDateTime)
	s NowDateTime = $case("","":$zd(+$h,3)_" "_$zt($p($h,",",2),2),:"")
	s addDate = (+AHours * 3600)\86400
	s addTime = (+AHours * 3600)#86400
	s timeList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ADateTimes,"\")
	s ConditionCount=$listlength(timeList)
    s result = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiTemHaDateTime(AEpisodeID,ATitles,"","","","",ATitleCongruent,AActionType)
	q:($e(result,1,2) = "0^") result
	s dateTimes= $e(result,3,$l(result))
	s RecorddateTimes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(dateTimes,"\")
	s RecordCount=$listlength(RecorddateTimes)
	s result=1
	for i = 1:1:$l(ATitles,"\")
	{
		s Titles = $p(ATitles,"\",i)
		s StructID = $p(Titles,"|",1)
		s Title=$p(Titles,"|",2)
		continue:(StructID = "")
	}	
		 
	    if (dateTimes="")
	    {
		  for ind = 1:1:$listlength(timeList)
	      {    
		   s tempDateTime = $listget(timeList,ind)
		   s tempDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(tempDateTime)
		   s tempDate = $p(tempDateTime," ",1)
		   continue:(tempDate ="")
		   s tempTime = $p(tempDateTime," ",2)
		   s QualityDate=tempDate+addDate
		   s QualityTime=tempTime+addTime
		   s QualityDateTime=QualityDate_" "_QualityTime
		   //是否到质控时间
		   s tempGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,tempDate_" "_tempTime)
		   continue:((+tempGap < AHours) && ($zcvt(ARuleType,"U") '= "B")) //如果不是提示标准,不到时间不质控
		   s Hours=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(QualityDateTime,NowDateTime)
		   s tempDateTime=##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(tempDateTime)
		   s QualityDateTime=##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(QualityDateTime)
		   s:(errInfo'="") errInfo=errInfo_";"_-1_"^"_Title_"^"_tempDateTime_"^"_QualityDateTime_"^"_Hours_"^"_""
		   s:(errInfo="") errInfo=-1_"^"_Title_"^"_tempDateTime_"^"_QualityDateTime_"^"_Hours_"^"_""
	      }
		
	   }
	   else
	   {
		if (RecordCount>=ConditionCount)
		{
			
			for ind = 1:1:$listlength(timeList)
	     { 
		   s tempDateTime = $listget(timeList,ind)
		   s tempDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(tempDateTime)
		   s tempDate=$p(tempDateTime," ",1)
		   s tempTime=$p(tempDateTime," ",2)
		   s RecordDateTime=$listget(RecorddateTimes,ind)
		   s tempGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(RecordDateTime,tempDateTime)
		   continue:(+tempGap<=AHours)
		   continue:(+tempGap>AHours)&&(AOutTimeWritePrompt="N")
		   s QualityDate=tempDate+addDate
		   s QualityTime=tempTime+addTime
		   s QualityDateTime=QualityDate_" "_QualityTime
		   s CreatDateTime=RecordDateTime
		   s Hours=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(QualityDateTime,CreatDateTime)
		   s tempDateTime=##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(tempDateTime)
		   s QualityDateTime=##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(QualityDateTime)
		   s:(CreatDateTime="") CreatDateTime=##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(CreatDateTime)
		   s:(errInfo'="") errInfo=errInfo_";"_-1_"^"_Title_"^"_tempDateTime_"^"_QualityDateTime_"^"_Hours_"^"_CreatDateTime
		   s:(errInfo="") errInfo=-1_"^"_Title_"^"_tempDateTime_"^"_QualityDateTime_"^"_Hours_"^"_CreatDateTime
	     }
		}
		
		else
		{
			for ind = 1:1:$listlength(timeList)
	     {
		   s tempDateTime = $listget(timeList,ind)
		   s tempDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(tempDateTime)
		   s tempDate=$p(tempDateTime," ",1)
		   s tempTime=$p(tempDateTime," ",2)
		   s flag=0
		   for ind2=1:1:$listlength(RecorddateTimes)
		   {
		    s RecordDateTime=$listget(RecorddateTimes,ind2)
		    s tempGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(RecordDateTime,tempDateTime)
		    s:(tempGap>0)&&(tempGap<AHours) flag=1
		   }
		   continue:(flag=1)
		   s QualityDate=tempDate+addDate
		   s QualityTime=tempTime+addTime
		   s QualityDateTime=QualityDate_" "_QualityTime
		  
		   s Hours=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(QualityDateTime,NowDateTime)
		   s tempDateTime=##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(tempDateTime)
		   s QualityDateTime=##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(QualityDateTime)
		   s:(errInfo'="") errInfo=errInfo_";"_-1_"^"_titles_"^"_tempDateTime_"^"_QualityDateTime_"^"_Hours_"^"_""
		   s:(errInfo="") errInfo=-1_"^"_titles_"^"_tempDateTime_"^"_QualityDateTime_"^"_Hours_"^"_""
	     }
		}
	}
	
	
	s:(errInfo'="") result=errInfo
	q result
}

/// 判定几天一次病程记录(按照上次书写记录时间算起)
/// Creator:	HKY
/// CreateDate:	2018-11-14
/// Input:		AEpisodeID 就诊号
/// 			ATitles：格式(质控结构ID|模板标题\模板标题#质控结构ID|模板标题\模板标题)
/// 			ADateTime 质控起始时间
///             ADisDateTime 质控结束时间
/// 			ADays	指定的天数
/// 			ATitleCongruent 标题包含还是等于值域:(E 等于,C 包含)
/// 			AActionType 操作类型(保存、打印、签名)
/// 			ACounts 判定单位时间内需要写几次模板(默认1次)
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件
/// w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHMultiIsRecordFinOnDay(185,"365|记录","2018-03-27 15:08:00","",3)
ClassMethod RHMultiIsRecordFinOnDay(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, ADisDateTime As %String, ADays As %String, ATitleCongruent As %String = "C", AActionType As %String = "", ACounts As %String = "1") As %String
{
	s ret = 0, errInfo = "",count = 0
	q:((AEpisodeID = "")||(ATitles = "")||(ARegDateTime = "")||(ADays = "")) ret
    
	s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s disDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	
	s checkDate = $p(disDateTime," ",1)
	s:(checkDate = "") checkDate = $p($h,",",1)
	s checkTime = $p(disDateTime," ",2)
	s:(checkTime = "") checkTime = $p($h,",",2)
	
	s fromDate = $p(regDateTime," ",1)
	s fromTime = $p(regDateTime," ",2)
	s:(fromTime = "") fromTime = 0
	s toDate = +checkDate
	s toTime=+checkTime
	q:((toDate-fromDate)<=ADays) ret
	s ret = 1
	s Title=$p(ATitles,"|",2)
	if (Title'="")
	{
		s StructName=Title
	}
	else
	{
		s StructNo=$p(ATitles,"|",1)
		s StructName = ##Class(EPRmeta.Quality.QualityPool).GetStructByStructID(StructNo)
		s StructName=$p(StructName,".",2)	
	}
	s errInfo=""	
    s result = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiTemHaDateTime(AEpisodeID,ATitles,"","","","",ATitleCongruent,AActionType)
	q:($e(result,1,2) = "0^") ret
	s dateTimes= $e(result,3,$l(result))

	s dateTimes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(dateTimes,"\")
    if (dateTimes = "")
    {
	    for tmpDate = fromDate:$g(ADays):toDate
	   { 
		 q:(checkDate <= (tmpDate + ADays))
		 s result = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,0,tmpDate+ADays,86399)
		 q:($e(result,1,2) = "0^")
		 s count = +$e(result,3,$l(result))
		 //q:(count > 0)
		 q:((count>0)&&((+ACounts)=1))
		 q:((count>(+ACounts-1))&&((+ACounts)'=1)) //增加判断要求没几天多次的情况(即:ACounts>1情况)
		 
		 s:(errInfo'="") errInfo=errInfo_";"_-1_"^"_StructName_"^"_$zd(tmpDate,3)_"^"_$zd(tmpDate+ADays-1,3)_"^"_""

		 s:(errInfo="") errInfo=-1_"^"_StructName_"^"_$zd(tmpDate,3)_"^"_$zd(tmpDate+ADays-1,3)_"^"_""
		 s listerrInfo=##Class(EPRservice.Quality.CommonHelper).GetListFromString(errInfo,";")
		 q:($listlength(listerrInfo)>10)
	   }
	}
	
	else
	{
		
	   s dateTimes=$lb(fromDate_" "_fromTime)_dateTimes_$lb(toDate_" "_toTime)
	  
	   s ret = 1
	   s AHours=ADays*24
	   f ind = 1:1:$listlength(dateTimes) 
	   {
		  
	     s dateTime1= $listget(dateTimes,ind)
	     q:(dateTime1 = "")
	      continue:(toDate <= ($p(dateTime1," ",1) + ADays))
	     //s dateTime2 = $listget(dateTimes,ind+1)
	     s dateTime2 = $listget(dateTimes,ind+ACounts) //增加判断要求没几天多次的情况(即:ACounts>1情况)
	     q:(dateTime2="")
	     s checkTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(dateTime2,dateTime1)
	     if (checkTimeGap>AHours)
	     {
		    for tmpdate=$p(dateTime1," ",1):ADays:$p(dateTime2," ",1)
		    {
			    q:(tmpdate+ADays)>=$p(dateTime2," ",1)
			    s:(errInfo'="") errInfo=errInfo_";"_-1_"^"_StructName_"^"_$zd(tmpdate,3)_"^"_$zd(tmpdate+ADays,3)_"^"_""
			    s:(errInfo="") errInfo=-1_"^"_StructName_"^"_$zd(tmpdate,3)_"^"_$zd(tmpdate+ADays,3)_"^"_""
			    s listerrInfo=##Class(EPRservice.Quality.CommonHelper).GetListFromString(errInfo,";")
		        q:($listlength(listerrInfo)>10)
			}
		 }
	  
	     
	     
	   }
	}
	s:(errInfo'="") ret = errInfo
	q ret
}

/// Desc:病危、病重患者可重复模板数据判断(几天写一次)
///      下了护理医嘱的患者可重复模板数据判断（几天一次）
/// Creator: HKY
/// Createdate:2018-11-15
/// Input:		AEpisodeID 就诊号
///             AOrdItems 质控医嘱项
/// 			ATitles 格式(质控结构ID|模板标题\模板标题#质控结构ID|模板标题\模板标题)
/// 			ADays	指定的天数
/// 			ATitleCongruent 标题包含还是等于值域:(E 等于,C 包含)
///             ATimeType     : 按时间取数据（创建时间 C  发生时间 H  修改时间 M）
/// 			AActionType 操作类型(保存、打印、签名)
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件
/// w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHMultiIsRecordFinByOrderOnDay(185,"11162||1","365|记录\阶段小结",2)
ClassMethod RHMultiIsRecordFinByOrderOnDay(AEpisodeID As %String, AOrdItems As %String, ATitles As %String, ADays As %String, ATitleCongruent As %String = "C", ATimeType As %String = "H", AActionType As %String = "")
{
	s ret = 0,errInfo = "",count = 0
	q:(AEpisodeID = "")||(AOrdItems = "")||(ADays = "") ret
	s Title=$p(ATitles,"|",2)
	if (Title'="")
	{
		s StructName=Title
	}
	else
	{
		s StructNo=$p(ATitles,"|",1)
		s StructName = ##Class(EPRmeta.Quality.QualityPool).GetStructByStructID(StructNo)
		s StructName=$p(StructName,".",2)	
	}
	s ret=1
	//查询是否下指定医嘱
	s dsOrder = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.OrderInfo:QueryOrderItem")
	d dsOrder.Execute(AEpisodeID,AOrdItems,"","Y")
	while(dsOrder.Next())
	{
		s OrderIDate = dsOrder.Data("IDate")   //开医嘱日期
		s OrderITime = dsOrder.Data("ITime")   //开医嘱时间
		s OrderDDate = dsOrder.Data("DDate")   //停止日期
		s:(OrderDDate = "") OrderDDate = $p($h,",",1)
		s OrderDTime = dsOrder.Data("DTime")   //停止时间
		s:(OrderDTime = "") OrderDTime = $p($h,",",2)
		
	    f tmpDate = OrderIDate:$g(ADays):OrderDDate 
	    {
		   q:(tmpDate>OrderDDate)
	       s result = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,0,tmpDate+ADays-1,86399,ATitleCongruent,ATimeType,AActionType)	
	       q:($p(result,"^",1) = "0")
	       s Tempcount = +$p(result,"^",2)
	       continue:(Tempcount > 0) 
	       s count = count + 1
	       s:(errInfo'="") errInfo=errInfo_";"_-1_"^"_StructName_"^"_$zd(tmpDate,3)_"^"_$zd(tmpDate+ADays-1,3)_"^"_""

		   s:(errInfo="") errInfo=-1_"^"_StructName_"^"_$zd(tmpDate,3)_"^"_$zd(tmpDate+ADays-1,3)_"^"_""
		   s ret = errInfo
		   s listerrInfo=##Class(EPRservice.Quality.CommonHelper).GetListFromString(errInfo,";")
		   q:($listlength(listerrInfo)>10)
	      
	    }	
	}
	
	q ret
}

/// Desc:	  交班记录后24小时内未完成接班记录
///     	  转科记录后24小时内未完成接收记录
///     	  请会诊记录后24小时未完成会诊记录
/// Creator:  HKY
/// Input:	  AEpisodeID为患者就诊号;
/// 		  ATitles1为前导标题字符串;
/// 		  ATitles2为后置标题字符串;
/// 		  AHours为参考小时数(默认为24);
///           ADisDateTime 质控结束时间;
/// 		  ARuleType 检查类型(B为提示,提前预防);
/// 		  ATitleCongruent 标题包含还是等于值域:(E 等于,C 包含)
/// 		  AActionType 操作类型(保存、打印、签名)
/// Output:   0 不用检查或配置错误
///           -1 触犯条目
/// 		  1  符合条件
/// Output:	ret<0 不一致
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHMultiDoubleRecordWtOnTime(185,"365|交班记录","365|接班记录",24)
ClassMethod RHMultiDoubleRecordWtOnTime(AEpisodeID As %String, ATitles1 As %String, ATitles2 As %String, AHours As %String = 24, ADisDateTime As %String = "", ARuleType As %String = "", ATitleCongruent As %String = "C", AActionType As %String = "") As %String
{
	s ret = 0,errInfo ="",CreatDateTime=""
	q:(AEpisodeID = "")||(ATitles1 = "")||(ATitles2 = "") ret
	
	s:($p(ATitles1,"|",2) = "交班记录") titles="接班记录"
	s:($p(ATitles1,"|",2) = "转出记录") titles="转入记录"
	s:($p(ATitles1,"|",2) = "会诊记录") titles="会诊记录"
	s:(ADisDateTime'="") ADisDateTime=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	s checkDateTime = $case(ADisDateTime,"":$p(+$h,1)_" "_$p($h,",",2),:ADisDateTime)
	s NowDateTime = $case("","":$zd(+$h,3)_" "_$zt($p($h,",",2),2),:"")
	s addDate = (+AHours * 3600)\86400
	s addTime = (+AHours * 3600)#86400
	
	s result1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiTemHaDateTime(AEpisodeID,ATitles1,"","","","",ATitleCongruent, AActionType)
	q:($e(result1,1,2) = "0^") ret
	s dateTimes1 = $e(result1,3,$l(result1))
	
	s result2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiTemHaDateTime(AEpisodeID,ATitles2,"","","","",ATitleCongruent, AActionType)
	q:($e(result2,1,2) = "0^") ret
	s dateTimes2 = $e(result2,3,$l(result2))

	s dateTimes1 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(dateTimes1,"\")
    
	s:(dateTimes2 = "") dateTimes2Initial = dateTimes2, dateTimes2 = $tr($h,","," ")
	s:(dateTimes2 '= "") dateTimes2Initial = "NULL"
	//wwt end
	s dateTimes2 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(dateTimes2,"\")

	s ret = 1
	for ind1 = 1:1:$listlength(dateTimes1)
	{
	 s dateTime1 = $listget(dateTimes1,ind1)
	 q:(dateTime1 = "")
	 s checkTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,dateTime1)
	 continue:((+checkTimeGap <=AHours) && ($zcvt(ARuleType,"U") '= "B")) //如果不是提示标准,不到时间不质控
	 s tmpdateTime1=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(dateTime1)
	 s QualityDate=$p(tmpdateTime1," ",1)+addDate
	 s QualityTime=$p(tmpdateTime1," ",2)+addTime
	 s QualityDateTime=QualityDate_" "_QualityTime
	 if (dateTimes2Initial = "")
	 {
	  s Hours=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(QualityDateTime,NowDateTime)
	  s dateTime1=##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(dateTime1)
	  s QualityDateTime=##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(QualityDateTime)
	  s:(errInfo'="") errInfo=errInfo_";"_-1_"^"_titles_"^"_dateTime1_"^"_QualityDateTime_"^"_Hours_"^"_""
	  s:(errInfo="") errInfo=-1_"^"_titles_"^"_dateTime1_"^"_QualityDateTime_"^"_Hours_"^"_""
	 }
	 else
	 {
	  s flag = 0
	  for ind2 = 1:1:$listlength(dateTimes2)
	  {
	    s dateTime2 = $listget(dateTimes2,ind2)
	    q:(dateTime2 = "")
	    s tmpTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(dateTime2,dateTime1)
	    continue:(tmpTimeGap < 0)
	    continue:(tmpTimeGap > AHours)
	    s flag = 1
	  }
	q:(flag = 1) 
	s CreatDateTime=dateTime2
	s Hours=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(QualityDateTime,dateTime2)
	s dateTime1=##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(dateTime1)
	s QualityDateTime=##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(QualityDateTime)
	s CreatDateTime=##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(CreatDateTime)
    s:(errInfo'="") errInfo=errInfo_";"_-1_"^"_titles_"^"_dateTime1_"^"_QualityDateTime_"^"_Hours_"^"_CreatDateTime
    s:(errInfo="") errInfo=-1_"^"_titles_"^"_dateTime1_"^"_QualityDateTime_"^"_Hours_"^"_CreatDateTime
   }
  }   	
	
	s:(errInfo'="") ret = errInfo
	q ret
}

/// 病程记录.三级手术缺少术后连续三天病程记录
/// 病程记录.转科患者缺少转科后连续三天病程记录
/// Creator:	HKY
/// CreateDate:	2018-11-14
/// Input:		AEpisodeID 就诊号
/// 			ATitles：格式(质控结构ID|模板标题\模板标题#质控结构ID|模板标题\模板标题)
/// 			AHISDateTimes (三级手术手术结束时间或转科患者转科时间 格式：64994 29567，多次手术或转科时间用"\"分隔:64994 29567\64995 29569)
///             ADisDateTime 质控结束时间
/// 			ADays	指定的天数
/// 			ATitleCongruent 标题包含还是等于值域:(E 等于,C 包含)
/// 			AActionType 操作类型(保存、打印、签名)
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件  
/// Debug:       ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHMultiIsRecordLXOnDay(EpisodeID,"365|记录",{HISOperFinishDateTime},{HISDischTime},3)                            
ClassMethod RHMultiIsRecordLXOnDay(AEpisodeID As %String, ATitles As %String, AHISDateTimes As %String, ADisDateTime As %String, ADays As %String = "3", ATitleCongruent As %String = "C", ATimeType As %String = "H", AActionType As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID="")||(ATitles="")||(AHISDateTimes="")||(ADays="") ret
	
	s disDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	s checkDate = $p(disDateTime," ",1)
	s:(checkDate = "") checkDate = $p($h,",",1)
	s checkTime = $p(disDateTime," ",2)
	s:(checkTime = "") checkTime = $p($h,",",2)
	s Title=$p(ATitles,"|",2)
	if (Title'="")
	{
		s StructName=Title
	}
	else
	{
		s StructNo=$p(ATitles,"|",1)
		s StructName = ##Class(EPRmeta.Quality.QualityPool).GetStructByStructID(StructNo)
		s StructName=$p(StructName,".",2)	
	} 
	
	s ret = 1,errInfo=""
	s dateTimes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AHISDateTimes,"\")
	for Ind=1:1:$listlength(dateTimes) 
	{
	  s dateTime=$listget(dateTimes,Ind)
	  //注：手术结束时间或转科时间，取值可根据接口返回值格式不同进行修改
	  s dateTime=$p(dateTime," ",1)_" "_$p(dateTime," ",2)
	  s dateTime=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(dateTime)
	  continue:dateTime=""
	  s fromDate=$p(dateTime," ",1),fromTime=$p(dateTime," ",2),toTime=fromTime,toDate=fromDate
	  //手术结束当天算作第一天，Ind=1时，传入fromTime(如果手术结束的第二天算作第一天，代码需要做出调整)
	  for Ind1=1:1:$g(ADays) 
	  {
	    s:(Ind1>1) fromDate=fromDate+1,toDate=toDate+1
	    q:toDate>=checkDate  
	    s:(Ind1=1) result=##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,fromDate,fromTime,toDate,86399,ATitleCongruent,ATitleCongruent,AActionType)
	    s:(Ind1>1) result=##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,fromDate,0,toDate,86399,ATitleCongruent,ATitleCongruent,AActionType)
	    continue:$e(result,1,2)="0^"
	    s count=+$e(result,3,$l(result))
	    continue:count>0
	    s:(errInfo'="") errInfo=errInfo_";"_-1_"^"_StructName_"^"_$zd(fromDate,3)_"^"_$zd(toDate,3)_"^"_""

		s:(errInfo="") errInfo=-1_"^"_StructName_"^"_$zd(fromDate,3)_"^"_$zd(toDate,3)_"^"_""
		s listerrInfo=##Class(EPRservice.Quality.CommonHelper).GetListFromString(errInfo,";")
		s ret=errInfo
		q:($listlength(listerrInfo)>10)   
	 }
	}
	
	q ret
}

/// /////////////////////////////////////////////////////////////////////////////////////////////////
/// 患者是否缺少某唯一模板
/// Creator:	Guanyu
/// CreateDate:	2020-03-12
/// Input:		AEpisodeID 就诊号
/// 			ATitles：格式(质控结构ID|模板标题\模板标题)
///             ADateTime:判定起始时间(入院/出院/死亡时间)
/// 			ATitleCongruent 标题包含还是等于值域:(E 等于,C 包含)
///             ATimeType 取时间类型(H 发生时间,C 创建时间)
/// 			AActionType 操作类型(保存、打印、签名)
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHSingleIsWrite(EpisodeID,"22^23^24",{HISRegTime1},{HISDischTime2})                           
ClassMethod RHSingleIsWrite(AEpisodeID As %String, AStuctIDs As %String, ADisDateTime As %String, ARegDateTime As %String, AActionType As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID="")||(AStuctIDs="")||(ARegDateTime="") ret
	
	s StartDate=$p(ARegDateTime," ",1)
	s StartTime=$p(ARegDateTime," ",2)
	s EndDate=$p(ADisDateTime," ",1)
	s EndTime=$p(ADisDateTime," ",2)
	s:(EndDate="") EndDate=$p($h,",",1)
	s:(EndTime="") EndTime=$p($h,",",2)
		
	s ret = -1
	for I=1:1:$l(AStuctIDs,"^")
	{
		s StuctID=$p(AStuctIDs,"^",I)
		s StructName = ##Class(EPRmeta.Quality.QualityPool).GetStructByStructID(StuctID)
		s StructName=$p(StructName,".",2)
		s objStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(StructID)
		continue:(objStruct = "")||(objStruct.IsActive '= "Y")||(objStruct.Type '= "EMR")
		s TemplateCategoryID = objStruct.BindCategoryId
		s resultInfo=##Class(EPRservice.Quality.EmrCheckRule.Template).GetSingleTempalteInfo(AEpisodeID,TemplateCategoryID,AActionType)
		continue:($p(resultInfo,"^",1)="-1")
		s ret=1
		q
	}
	q:(ret=1) ret
	
	s ret="-1"_"^"_StructName_"^"_StartDate_" "_StartTime_"^"_EndDate_" "_EndTime_"^"_""_"^"_""
	
	q ret
}

/// 病程记录.患者出院当天必须有一次病程记录
/// Creator:	HKY
/// CreateDate:	2018-11-14
/// Input:		AEpisodeID 就诊号
/// 			ATitles：格式(质控结构ID|模板标题\模板标题#质控结构ID|模板标题\模板标题)
///             ADisDateTime 出院时间
/// 			ATitleCongruent 标题包含还是等于值域:(E 等于,C 包含)
/// 			AActionType 操作类型(保存、打印、签名)
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHMultiIsWriteRecordOnDisDate(EpisodeID,"365|记录\阶段小结",{HISDischTime})                           
ClassMethod RHMultiIsWriteRecordOnDisDate(AEpisodeID As %String, ATitles As %String, ADisDateTime As %String, ATitleCongruent As %String = "C", ATimeType As %String = "H", AActionType As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID="")||(ATitles="")||(ADisDateTime="") ret
	s disDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	s checkDate = $p(disDateTime," ",1)
	s Title=$p(ATitles,"|",2)
	if (Title'="")
	{
		s StructName=Title
	}
	else
	{
		s StructNo=$p(ATitles,"|",1)
		s StructName = ##Class(EPRmeta.Quality.QualityPool).GetStructByStructID(StructNo)
		s StructName=$p(StructName,".",2)	
	} 
	s result=##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,checkDate,0,checkDate,86399,ATitleCongruent,ATitleCongruent,AActionType)
	q:($e(result,1,2)="0^") ret
	s ret = 1,errInfo=""
	s count=+$e(result,3,$l(result))
	q:(count>0) ret
	s:(errInfo="") errInfo=-1_"^"_StructName_"^"_$zd(checkDate,3)_"^"_$zd(checkDate,3)_"^"_""
	s ret=errInfo
	q ret
}

/// 病程记录.患者输血(或其他操作)当天需完成一次病程记录
/// Creator:	Guanyu
/// CreateDate:	2020-02-10
/// Input:		AEpisodeID 就诊号
/// 			ATitles：格式(质控结构ID|模板标题\模板标题#质控结构ID|模板标题\模板标题)
///             AOperDates 输血(或其他操作)日期(多个用"\"分隔)
/// 			ATitleCongruent 标题包含还是等于值域:(E 等于,C 包含)
///             ATimeType 取时间类型(H 发生时间,C 创建时间)
/// 			AActionType 操作类型(保存、打印、签名)
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHMultiIsWriteRecordOnOPDate(EpisodeID,"366|记录\阶段小结",{HISOPDates})                           
ClassMethod RHMultiIsWriteRecordOnOPDate(AEpisodeID As %String, ATitles As %String, AOperDates As %String, ATitleCongruent As %String = "C", ATimeType As %String = "H", AActionType As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID="")||(ATitles="")||(AOperDates="") ret
	
	s Title=$p(ATitles,"|",2)
	if (Title'="")
	{
		s StructName=Title
	}
	else
	{
		s StructNo=$p(ATitles,"|",1)
		s StructName = ##Class(EPRservice.Quality.GetStructResult).GetStructByStructID(StructNo)
		s StructName=$p(StructName,".",2)	
	} 
	
	s ret = 1,errInfo=""
	for I=1:1:$l(AOperDates,"\")
	{
		continue:(OperDate = $p($p(AOperDates,"\",I)," ",1))
		s OperDate=$p(AOperDates,"\",I)
		s OperDate = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(OperDate)
		s checkDate = $p(OperDate," ",1)
		
		s result=##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,checkDate,0,checkDate,86399,ATitleCongruent,ATitleCongruent,AActionType)
		s count=+$e(result,3,$l(result))
		continue:(count>0)
		
		s:(errInfo'="") errInfo=errInfo_";"_-1_"^"_StructName_"^"_$zd(checkDate,3)_"^"_$zd(checkDate,3)_"^"_""
		s:(errInfo="") errInfo=-1_"^"_StructName_"^"_$zd(checkDate,3)_"^"_$zd(checkDate,3)_"^"_""
	}
	s:(errInfo'="") ret=errInfo
	q ret
}

/// 病程记录.患者手术(或其他操作)前*天/*小时需完成一次病程记录
/// Creator:	GY
/// CreateDate:	2020-02-10
/// Input:		AEpisodeID 就诊号
/// 			ATitles：格式(质控结构ID|模板标题\模板标题#质控结构ID|模板标题\模板标题)
///             AOperDates 手术(或其他操作)日期(多个用"\"分隔)
///             AHours 手术(或其他操作)前小时数
/// 			ATitleCongruent 标题包含还是等于值域:(E 等于,C 包含)
///             ATimeType 取时间类型(H 发生时间,C 创建时间)
/// 			AActionType 操作类型(保存、打印、签名)
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHMultiIsWriteRecordBefOPDate(EpisodeID,"366|记录\阶段小结",{HISOPDates})                           
ClassMethod RHMultiIsWriteRecordBefOPDate(AEpisodeID As %String, ATitles As %String, AOperDates As %String, AHours As %String, ATitleCongruent As %String = "C", ATimeType As %String = "H", AActionType As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID="")||(ATitles="")||(AOperDates="") ret
	
	s Title=$p(ATitles,"|",2)
	if (Title'="")
	{
		s StructName=Title
	}
	else
	{
		s StructNo=$p(ATitles,"|",1)
		s StructName = ##Class(EPRservice.Quality.GetStructResult).GetStructByStructID(StructNo)
		s StructName=$p(StructName,".",2)	
	} 
	
	s ret = 1,errInfo=""
	s Days=AHours/24
	s:(Days<1) Days=1
	for I=1:1:$l(AOperDates,"\")
	{
		s OperDate=$p(AOperDates,"\",I)
		s OperDate = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(OperDate)
		s checkDate = $p(OperDate," ",1)
		s checkTime = $p(OperDate," ",2)
		s result=##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,checkDate-Days,0,checkDate,checkTime,ATitleCongruent,ATitleCongruent,AActionType)
		s count=+$e(result,3,$l(result))
		continue:(count>0)
		
		s hours=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDate_" "_checkTime,$tr($h,","," "))
		s:(errInfo'="") errInfo=errInfo_";"_-1_"^"_StructName_"^"_$zd(checkDate-Days,3)_"^"_$zd(checkDate,3)_"^"_hours_"^"_""
		s:(errInfo="") errInfo=-1_"^"_StructName_"^"_$zd(checkDate-Days,3)_"^"_$zd(checkDate,3)_"^"_hours_"^"_""
	}
	s:(errInfo'="") ret=errInfo
	q ret
}

/// 患者有某特殊医嘱时，检查是否缺少某可重复模板
/// Creator:	Guanyu
/// CreateDate:	2020-02-11
/// Input:		AEpisodeID 就诊号
/// 			ATitles：格式(质控结构ID|模板标题\模板标题)
///             AOrdDateTime:特殊医嘱时间
///             ADisDateTime 出院/死亡时间
/// 			ATitleCongruent 标题包含还是等于值域:(E 等于,C 包含)
///             ATimeType 取时间类型(H 发生时间,C 创建时间)
/// 			AActionType 操作类型(保存、打印、签名)
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHMultiIsWrite(EpisodeID,"365|记录\阶段小结",{ORDDateTimes},{HISDischTime})                           
ClassMethod RHMultiIsWrite(AEpisodeID As %String, ATitles As %String, AOrdDateTime As %String, ADisDateTime As %String, ATitleCongruent As %String = "C", ATimeType As %String = "H", AActionType As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID="")||(ATitles="")||(AOrdDateTime="") ret
	
	s Title=$p(ATitles,"|",2)
	if (Title'="")
	{
		s StructName=Title
	}
	else
	{
		s StructNo=$p(ATitles,"|",1)
		s StructName = ##Class(EPRservice.Quality.GetStructResult).GetStructByStructID(StructNo)
		s StructName=$p(StructName,".",2)
	}
	
	s ret = 1,errInfo=""
	for I=1:1:$l(AOrdDateTime,"\")
	{
		s StOrdDateTime=$p(AOrdDateTime,"\",I)
		s EndOrdDateTime=$p(AOrdDateTime,"\",I+1)
		s StOrdDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StOrdDateTime)
		s:(EndOrdDateTime'="") EndOrdDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndOrdDateTime)
		s:(EndOrdDateTime="") EndOrdDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
		s:(EndOrdDateTime="") EndOrdDateTime=$tr($h,","," ")
		
		s StartDate=$p(StOrdDateTime," ",1)
		s StartTime=$p(StOrdDateTime," ",2)
		s EndDate=$p(EndOrdDateTime," ",1)
		s EndTime=$p(EndOrdDateTime," ",2)
		
		///s result=##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,StartDate,StartTime,EndDate,EndTime,ATitleCongruent,ATimeType,AActionType)
		s result=##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,StartDate,0,EndDate,86399,ATitleCongruent,ATimeType,AActionType)
		s count=+$e(result,3,$l(result))
		continue:(count>0)
		s ret=-1
		s hours=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(EndDate_" "_EndTime,StartDate_" "_StartTime)
		s:(errInfo'="") errInfo=errInfo_";"_"-1"_"^"_StructName_"^"_$zd(StartDate,3)_" "_$zt(StartTime)_"^"_$zd(EndDate,3)_" "_$zt(EndTime)_"^"_hours_"^"_""
		s:(errInfo="") errInfo="-1"_"^"_StructName_"^"_$zd(StartDate,3)_" "_$zt(StartTime)_"^"_$zd(EndDate,3)_" "_$zt(EndTime)_"^"_hours_"^"_""
	}
	s:(errInfo'="") ret=errInfo
	q ret
}

/// 病程记录.患者转科(或其他操作)前需完成转出(或其他操作)记录
/// Creator:	Guanyu
/// CreateDate:	2020-02-11
/// Input:		AEpisodeID 就诊号
/// 			ATitles：格式(质控结构ID|模板标题\模板标题#质控结构ID|模板标题\模板标题)
///             ARegDateTime 患者入院时间(一般取安床时间)
///             AOrdItems 转科(或其他操作)医嘱项ID(多个用"\"分隔)
/// 			ATitleCongruent 标题包含还是等于值域:(E 等于,C 包含)
///             ATimeType 取时间类型(H 发生时间,C 创建时间)
/// 			AActionType 操作类型(保存、打印、签名)
/// Output:     0 不用检查或配置错误
///             -1 触犯条目
/// 			1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHMultiIsWriteBefOrder(EpisodeID,"366|转科记录",{HISRegTime1},{HISORDTimes})                          
ClassMethod RHMultiIsWriteBefOrder(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, AOrdDateTimes As %String, ATitleCongruent As %String = "C", ATimeType As %String = "H", AActionType As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID="")||(ATitles="")||(ARegDateTime="")||(AOrdDateTimes="") ret
	
	s Title=$p(ATitles,"|",2)
	if (Title'="")
	{
		s StructName=Title
	}
	else
	{
		s StructNo=$p(ATitles,"|",1)
		s StructName = ##Class(EPRservice.Quality.GetStructResult).GetStructByStructID(StructNo)
		s StructName=$p(StructName,".",2)	
	} 
	
	s OrderDatestr=""
	s StDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s OrderDatestr=StDateTime_"\"_AOrdDateTimes
	
	s ret=1,errInfo=""
	for I=1:1:$l(OrderDatestr,"\")
	{
		s StartDate=$p($p(OrderDatestr,"\",I)," ",1)
		s StartTime=$p($p(OrderDatestr,"\",I)," ",2)
		s EndDate=$p($p(OrderDatestr,"\",I+1)," ",1)
		s EndTime=$p($p(OrderDatestr,"\",I+1)," ",2)
		q:(EndDate="")
		
		s result=##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiRecordByTimeType(AEpisodeID,ATitles,StartDate,0,EndDate,86399,ATitleCongruent,ATimeType,AActionType)
		s count=+$e(result,3,$l(result))
		continue:(count>0)
		
		s hours=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(EndDate_" "_EndTime,StartDate_" "_StartTime)
		s:(errInfo'="") errInfo=errInfo_";"_"-1"_"^"_StructName_"^"_$zd(StartDate,3)_" "_$zt(StartTime)_"^"_$zd(EndDate,3)_" "_$zt(EndTime)_"^"_hours_"^"_""
		s:(errInfo="") errInfo="-1"_"^"_StructName_"^"_$zd(StartDate,3)_" "_$zt(StartTime)_"^"_$zd(EndDate,3)_" "_$zt(EndTime)_"^"_hours_"^"_""
	}
	s:(errInfo'="") ret=errInfo
	
	q ret
}

/// Desc：判断已保存的病历是否已签名
/// Creator：Guanyu
/// CreatDate:2020-3-12
/// Input:AEpisodeID 就诊号, AParentCategoryIDs 展现结构白色文件上一级的黄色文件夹属性ID, 
///       ActionIDs 可通过的签名动作,可查表EMRmeta.EMRAction (如:participantCheck^residentCheck^attendingCheck^viceChiefCheck^chiefCheck^chairmanCheck)
/// OutPut:ret 0 不检查参数有误，-1^"未签名病历标题" 触发质控，1 检查通过
/// Debuge:w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsRecordOnSign(EpisodeID,"1\2\3\4\5\6","participantCheck^residentCheck^attendingCheck^viceChiefCheck^chiefCheck^chairmanCheck")
ClassMethod IsRecordOnSign(AEpisodeID As %String, AParentCategoryIDs As %String, ActionIDs As %String) As %String
{
    s ret = 0
    q:((AEpisodeID = "")||(AParentCategoryIDs = "")) ret
    
    s ADocIDs=##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).GetDocumentID(AParentCategoryIDs)
    q:(ADocIDs="") ret
    
    s ret = 1
    s errorInfo = ""
    
    s idCount=$l(ADocIDs, "#")
	f i=1:1:idCount 
	{
		s docID = $p(ADocIDs, "#", i)
		s ECRecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_docID,""))
		continue:(ECRecordID = "")
		s happenDate = ""
		for
		{
			s happenDate = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",happenDate))
			q:(happenDate = "")
			s happenTime = ""
			for
			{
				s happenTime = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",happenDate,happenTime))
				q:(happenTime = "")
				s listNo = ""
				for
				{
					s listNo = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",happenDate,happenTime,listNo))
					q:(listNo = "")
					
					s instanceID = ECRecordID_"||"_listNo
					s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(instanceID)
					q:(objInstance = "")
					
					s LogID = $o(^DHCEMRI.EMRLogsI("IdxMain"," "_AEpisodeID," "_objInstance.TheECRecord.ChartItemID,listNo,""))
					continue:(LogID = "")
					
					s ret=-1
					for j=1:1:$l(ActionIDs,"^")
					{
						s ActionID=$p(ActionIDs,"^",j)
						s IsSignStatus=$d(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",LogID," "_$ZCVT(ActionID,"U")))
						s:(IsSignStatus=10) ret=1
						q:(ret=1)
					}
					
					s:(ret=-1)&&(errorInfo'="") errorInfo=errorInfo_"/"_objInstance.Title
					s:(ret=-1)&&(errorInfo="") errorInfo=-1_"^"_objInstance.Title
				}
			}
		}
	}
	s:(errorInfo'="") ret=errorInfo
    q ret
}

/// Desc：取病历展现结构黄色文件夹下 挂靠的所有模板DocumentID(展现结构条纹层属性ID),用"#"分隔
/// Creator：Guanyu
/// CreatDate:2020-3-12
/// Input:AParentCategoryIDs 展现结构白色文件上一级的黄色文件夹属性ID 
/// OutPut: 病历展现结构黄色文件夹下 挂靠的所有模板DocumentID(展现结构条纹层属性ID),用"#"分隔
/// Debuge:w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).GetDocumentID("1\2\3\4\5\6\8\9\10\11")
ClassMethod GetDocumentID(AParentCategoryIDs As %String) As %String
{
	s ret="",DocumentIDs=""
	q:(AParentCategoryIDs="") ret
	
	for I=1:1:$l(AParentCategoryIDs,"\")
	{
		s ParentCategoryID=$p(AParentCategoryIDs,"\",I)
		s tmpCategoryID1=""
		
		for 
		{
			s tmpCategoryID1=$o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID"," "_ParentCategoryID,tmpCategoryID1))
			q:(tmpCategoryID1="")
			
			s tmpCategoryID2=""
			for
			{
				s tmpCategoryID2=$o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID"," "_tmpCategoryID1,tmpCategoryID2))
				q:(tmpCategoryID2="")
				
				s ObjCategory=##Class(EMRmeta.EMRTemplateCategory).%OpenId(tmpCategoryID2)
				s CategoryType=ObjCategory.CategoryType
				continue:(CategoryType'="TempCate")
				
				s:(DocumentIDs'="") DocumentIDs=DocumentIDs_"#"_tmpCategoryID2
				s:(DocumentIDs="") DocumentIDs=tmpCategoryID2
			}
		}
	}
	s:(DocumentIDs'="") ret=DocumentIDs		
	q ret
}

/// Desc：判断病历是否签名
/// Creator：ZXY
/// CreatDate:2022-07-14
/// Input:DocIDs 展现结构白色文件下一级的三条纹属性ID ，AElementID 模板签名单元 ，ATemPlateId 模板的templateid ,ATitles :模板的Title ，ATitleCongruent：标题是包含还是等于 C 包含 ；E 等于
/// OutPut: -1 存在未签名 
/// Debug: ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsRecordSign(EpisodeID,AElementID,DocIDs,ATemPlateId,ATitles,ATitleCongruent)
ClassMethod IsRecordSign(AEpisodeID As %String, AElementID As %String, DocIDs As %String, ATemPlateId As %String = "", ATitles As %String = "", ATitleCongruent As %String = "C") As %String
{
    
     s ret = 0
    s AInstanceID="" ,HappDateTimes="",HappDateTime=""
    q:(AEpisodeID = "")||(AElementID = "") ret
    q:($d(AEpisodeID) = 0)||($d(AElementID) = 0) ret
    s Resultinstanceid=##Class(EPRservice.Quality.EmrCheckRule.Template).GetInstanceIDByDocID(AEpisodeID,DocIDs,ATemPlateId,ATitles,ATitleCongruent)
    s AInstanceID=Resultinstanceid
    q:AInstanceID="" ret
    s ret=1,m=0,SignCount=0
    for i=1:1:$l(AInstanceID,"\")
    {
       s InstanceID=$p(AInstanceID,"\",i)
       q:InstanceID=""
       s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
	   continue:(objInstance = "")
	   S TemPlate=objInstance.TemplateID
       s flag=0
       for o=1:1:$l(AElementID,"\")
       {
           s ElementID=$p(AElementID,"\",o)
           q:ElementID=""
           s objElment=##Class(EPRmeta.Quality.QualityTemplate).%OpenId(ElementID)
           continue:objElment=""
           continue:objElment.TemplateId'=TemPlate
           s elementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,InstanceID)
           continue:elementData'=""
           s:(elementData = "") m=m+1
           s:(elementData = "") flag=1
           q:flag=1
       }
           if (flag=1)
           {
           s HappDate=$zd($list($g(^DHCEMRI.ECRecordD($p(InstanceID,"||",1),"Instances",$p(InstanceID,"||",2))),7),3)
           s HappTime=$zt($list($g(^DHCEMRI.ECRecordD($p(InstanceID,"||",1),"Instances",$p(InstanceID,"||",2))),8),1)
           s Title=$list($g(^DHCEMRI.ECRecordD($p(InstanceID,"||",1),"Instances",$p(InstanceID,"||",2))),17)
           s HappDateTime=Title_"："_HappDate_" "_HappTime
           s:HappDateTimes'="" HappDateTimes=HappDateTimes_"；"_HappDateTime
           s:HappDateTimes="" HappDateTimes=HappDateTime
           }
    }
    s:m>0 ret="-1^"_HappDateTimes
    q ret
}

/// 病案首页手术名称含有动脉瘤、颈动脉等字样，必须填写入院出院评分模板
/// InPut:AElements 手术名称单元，多个用"\"分隔
///      AValues 指定含有的字符，多个用"\"分隔
///      ADocID  模板展现结构ID
///      ATitle  模板名称
///      ALocIDs  需要质控的科室，多个用"\"分隔
/// DeBug: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsDocFinishOnElement(EpisodeID,"10866\10867\10868\10869\10870\10871\10872\10873","颈动脉\颈内动脉","997","颈内动脉狭窄入院评分","364\353\359\361\354\357\1360\491")
ClassMethod IsDocFinishOnElement(AEpisodeID As %String, AElements As %String, AValues As %String, ADocID As %String, ATitle As %String, ALocIDs As %String = "") As %String
{
	s ret=0
	q:((AEpisodeID="")||(AElements="")||(AValues="")||(ADocID="")||(ATitle="")) ret
	s LocFlag=1
	if (ALocIDs'="")
	{
		s objPaAdm = $g(^PAADM(+AEpisodeID))
		s DisLocID = $p(objPaAdm,"^",4)
		s:(("\"_ALocIDs_"\")'[("\"_DisLocID_"\")) LocFlag=0
	}
	q:(LocFlag=0) ret
	s DescFlag=0
	for i=1:1:$l(AElements,"\")
    {
	   s Element=$p(AElements,"\",i)
	   q:(Element="")
	   s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
	   s ElementData=$tr(ElementData," ","")	   
	   continue:(ElementData="")
	   for j=1:1:$l(AValues,"\")
	   {
		   s Value=$p(AValues,"\",j)
	       q:(Value="")
	       s:(ElementData[Value) DescFlag=1
	       q:(DescFlag=1)
	   }
	}
	q:(DescFlag=0) ret
	s ret=1
	s Result=##Class(EPRservice.Quality.EmrCheckRule.Template).GetInstanceIDByDocID(AEpisodeID,ADocID,ATitle)
	s:(Result="") ret=-1
	q ret
}

/// 说明: 病案首页.死亡患者主诊断不能为该诊断
/// Input: AEpisodeID为患者就诊号 , DeathDate:死亡患者死亡日期 , AElement1:主诊断编码模板元素ID , Desc:不能出现的诊断编码
/// OutPut: 0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件 
ClassMethod IsUnify202207121(AEpisodeID As %String, DeathDate As %String, AElement1 As %String, Desc As %String)
{
	q:(DeathDate="") 1
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	s flag=1
	for i=1:1:$l(Desc,"/")
	{
		s ADesc=$p(Desc,"/",i)
		s:(ADesc=$e(ElementData,1,$l(ADesc))) flag=-1
		q:(flag=-1)
	}
	q flag
}

/// Add: 	WXH
/// Desc:	手术记录不应该为四级手术，请检查！
/// Input:	AEpisodeID为患者就诊号; 
/// 		AElement1为手术编码  
/// 		AElement2为手术级别
/// 		AValue为四级手术级别
/// Return:	ret<0 不一致 
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IVOperation(EpisodeID,"10720","10837","22")
ClassMethod IVOperation(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AValue As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "")||(AValue = "") ret
	
	
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	
	if (ElementData2 '="IV")&&(ElementData2 '="Ⅳ")
	{
	  s ret = 1
	  q ret
	}
	s ret = 1
	s OperCode=##class(web.DHCFYRM).GetOprLevelByOprcode(ElementData1)
	if (OperCode '= AValue)
	{
	  s ret = -1	
	}
	
	q ret
}

/// 治疗费用没有中药类、中医类,治疗类别应为4西医
/// freeElements 中药类,中医类费用元素id,多个用“\”隔开，typeElement 治疗类别元素id
ClassMethod IsUnify202207251(EpisodeID As %String, freeElements As %String, typeElement As %String)
{
	s free=0
	for i=1:1:$l(freeElements,"\")
	{
		s free=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,$p(freeElements,"\",i),"")
		q:(free>0)
	}
	q:(free>0) 1
	s type=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,typeElement,"")
	q:(type="西医") 1
	q -1
}

/// Desc:当患者的诊断中出现I63以及I69.300×003 时要填写美国国立卫生研究院卒中量表（NIHSS）、ESSEN卒中风险评估量表 、改良RANKIN量表、吞咽功能评估（洼田饮水试验）
/// Input:EpisodeID 就诊号,Titles 标题以及DocID(病历展现结构下拉条纹属性ID)信息
/// Output:ret=-1 触犯、ret=0 参数缺失、ret=1 通过
/// Creator:WZL 2022年6月27日10:16:03
/// Debug:w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsRecordFinish(EpisodeID,"")
ClassMethod IsRecordFinish(EpisodeID, Titles)
{
	s ret=0
	
	q:(EpisodeID="")||(Titles="") ret
	
	s ret=1
	
	for i=1:1:$l(Titles,"\")
	{
		s Title1=$p(Titles,"\",i)
		s DocID=$p(Title1,"|",1)
		s Title=$p(Title1,"|",2)
		s InstanceID=##Class(EPRservice.Quality.EmrCheckRule.Template).GetInstanceIDByDocID(EpisodeID,DocID,Title)
		s:(InstanceID="") ret=-1
	}
	
	q ret
}

/// Desc:患者首页诊断中(包括主要和次要诊断)是否存在某个值
/// Input:EpisodeID 就诊号,DiagnoseIDs 诊断 Values 值范围
/// Output:ret=1 存在、ret=0 参数缺失、ret=-1 不存在
/// Creator:WZL 2022年6月27日10:26:21
/// Debug:w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsExistDiagnose(EpisodeID,Diagnose,"I63\I69.300×003")
ClassMethod IsExistDiagnose(EpisodeID, DiagnoseIDs, Values)
{
	s ret=0
	
	q:(EpisodeID="")||(DiagnoseIDs="")||(Values="") ret
	
	s ret=-1
	
	for i=1:1:$l(DiagnoseIDs,"\")
	{
		s ElementID=$P(DiagnoseIDs,"\",i)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,ElementID,"")
		s match=0
		for j=1:1:$l(Values,"\")
		{
			s value=$p(Values,"\",j)
			s:(ElementData[value) match=1
			q:(match=1)
		}
		
		q:(match=1)
	}
	
	s:(match=1) ret=1
	
	q ret
}

/// 首页费用（13+14+16+17）/（9+10+13+14+15+16+17+18+19+20+21+22+24+25）>=60%才能选中医治疗类别1.1-中医
/// AElement1s(中医治疗\中医其他\中成药\中草药)，AElement2s(非手术治疗项目\手术治疗\中医治疗\中医其他\西药\中成药\中草药\血费\白蛋白类制品\球蛋白类制品\凝血因子类制品费\细胞因子类制品费\治疗用一次性医用材料费\手术用一次性医用材料费)，AElement3（治疗类别）
ClassMethod IsUnify08011(AEpisodeID As %String, AElement1s As %String, AElement2s As %String, AElement3 As %String)
{
	s free1=0,free2=0
	for i=1:1:$l(AElement2s,"\")
	{
		s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(AElement2s,"\",i),"")
		s free2=free2+ElementData2
	}
	q:(free2=0) 1
	for i=1:1:$l(AElement1s,"\")
	{
		s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(AElement1s,"\",i),"")
		s free1=free1+ElementData1
	}
	q:((free1/free2)>=0.6) 1
	s ElementData3 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement3,"")
	q:(ElementData3="中医") -1
	q 1
}

/// 说明：病案首页.【护理天数总和】-【住院天数】需小于等于1天
/// Input:AElement1:住院天数，AElement2:一级护理天数，AElement3:2级护理天数，AElement4：3级护理天数，AElement:5：特级护理
/// OutPut: 0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件 
/// Debug:  ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnifyAdd0043(EpisodeID,"住院总天数","一级护理天数\二级护理天数\三级护理天数\特级护理天数")
ClassMethod IsUnifyAdd0043(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, AElement4 As %String, AElement5 As %String)
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AElement3="")||(AElement4="")||(AElement5="") ret
    
    //获取住院天数、一级、二级、三级、特级护理天数
    s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
    s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
    s ElementData3 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement3,"")
    s ElementData4 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement4,"")
	s ElementData5 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement5,"") // 特级护理天数
	if ($p(ElementData5," ",2)="")
	{
		s ElementData5=1
	}else
	{
		s ElementData5=$p(ElementData5," ",1)+1
	}
	s hldays=(ElementData2+ElementData3+ElementData4+ElementData5)
	
	if (hldays-ElementData1<=1) 
	{
		s ret = 1	
	}else{
		s ret = -1
	}
    q ret
}

/// 病案首页.地址栏不允许出现除中文、数字、英文的其他字符
/// AElements(地址栏信息，多个用“\”隔开)
ClassMethod IsUnify202208011(AEpisodeID As %String, AElements As %String)
{
	s flag=1
	for i=1:1:$l(AElements,"\")
	{
		 s ElementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(AElements,"\",i),"")
		 for j=1:1:$l(ElementData)
		 {
			continue:($match($e(ElementData,j),"[0-9]"))||($match($e(ElementData,j),"[A-z]"))||($match($e(ElementData,j),"[\u4e00-\u9fa5]"))
			s flag=-1
			q:(flag=-1)
		 }
		 q:(flag=-1)
	}
	q flag
}

/// 输血费用大于0，输血不良反应、HBsAg、Hcv_Ab、HIv_Ab、输血反应不能为空
/// ElementID 血费，ElementIDs（输血不良反应、HBsAg、Hcv_Ab、HIv_Ab、输血反应，“\”做分隔）
ClassMethod IsUnify202207261(AEpisodeID As %String, ElementID As %String, ElementIDs As %String)
{
	s free=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
	if (free>0)
	{
		s flag=1
		for i=1:1:$l(ElementIDs,"\")
		{
			s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(ElementIDs,"\",i),"")
			s:(ElementData="") flag=-1
			q:(flag=-1)
		}
		q flag
	}
	else
	{
		q 1
	}
}

/// AElement（就诊科室），AElements1（诊断描述，多个用“\”隔开），AElements2（诊断编码，多个用“\”隔开）
ClassMethod IsUnify202208081(AEpisodeID As %String, AElement As %String, AElements1 As %String, AElements2 As %String)
{
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
	q:(ElementData["中医") 1
	s ElementList=""
	for i=1:1:$l(AElements1,"\")
	{
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(AElements1,"\",i),"")
		s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(AElements2,"\",i),"")
		continue:(ElementData1="")||(ElementData2="")
		s IsFlag=..IsZYZD(ElementData1,ElementData2)
		s:(IsFlag=-1)&&(ElementList'="") ElementList=ElementList_"\"_$p(AElements1,"\",i)_"\"_$p(AElements2,"\",i)
		s:(IsFlag=-1)&&(ElementList="") ElementList=$p(AElements1,"\",i)_"\"_$p(AElements2,"\",i)
	}
	q:(ElementList="") 1
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q "-1@"_ElementCode
}

ClassMethod IsZYZD(ElementData1 As %String, ElementData2 As %String)
{
	s flag=1
	&sql(declare c1 cursor for
	SELECT MRCID_Code,MRCID_ICD9CM_Code into :Code1,:Code2 FROM SQLUser.MRC_ICDDx
	WHERE MRCID_Desc=:ElementData1)
	&sql(open c1)
	&sql(fetch c1)
	while (SQLCODE = 0)
	{
		s:($e(Code1,1,4)="MZZY")&&(Code2=ElementData2) flag=-1
		q:(flag=-1)
		&sql(fetch c1)
	}
	&sql(close c1)
	q flag
}

/// AElement1：中医诊断费用，AElement2：中医治疗费用，AElement3：中医其他费用，AElement4：使用中医诊疗技术
ClassMethod IsUnify2208151(AEpisdoeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, AElement4 As %String)
{
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisdoeID,AElement1,"")
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisdoeID,AElement2,"")
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisdoeID,AElement3,"")
	q:((ElementData1+ElementData2+ElementData3)>0) 1
	s ElementData4=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisdoeID,AElement4,"")
	q:(ElementData4="是") -1
	q 1
}

/// Time（住院时常），AElements（是否日间手术，多个用“\”隔开）
ClassMethod IsUnify202208171(AEpisodeID As %String, Time As %String, AElements As %String)
{
	if (Time>48)
	{
		s flag=1
		for i=1:1:$l(AElements,"\")
		{
			s Elementdata=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(AElements,"\",i),"")
			s:(Elementdata="是") flag=-1
			q:(flag=-1)
		}
		q flag
	}
	else
	{
		q 1
	}
}

/// Desc 判断章节内容里是否有连续相同的长度为ALen的内容
/// w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify090501(EpisodeID,10325,4)
ClassMethod IsUnify090501(AEpisodeID As %String, AElement As %String, ALen As %String)
{
    s ret = 0
    q:(AElement="")||(AEpisodeID="") ret
    s ret = 1
    s ElementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
    q:($l(ElementData)<(ALen)) ret
    
    for i=1:1:($l(ElementData)-ALen+1)
    {
        s CurValuei = $e(ElementData,i)
        s str=CurValuei
        for j=i+1:1:(i+ALen-1)
        {
            s CurValuej = $e(ElementData,j)
            s str = CurValuej_str
            s str=$tr(str,CurValuei,"")
            s:str'="" i=j-1
            q:str'=""
            s:(j=(i+ALen-1)) ret=-1
        }
        q:ret=-1
    }   
    q ret
}

/// Desc 每相邻的三个字符不能相同
/// Input AEpisodeID 就诊号  AElement 章节ID     ARepeatLen 重复字符的长度
/// Output 0 入参错误   1 符合规范  -1 触犯条目
/// Debug w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify090502(EpisodeID,10325,3)
ClassMethod IsUnify090502(AEpisodeID As %String, AElement As %String, ARepeatLen As %String)
{
   	 s ret = 0
	q:(AElement="")||(AEpisodeID="")||(ARepeatLen="") ret
	s ret = 1
	s ElementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
	q:($l(ElementData)<(ARepeatLen*2)) ret
	for i=1:1:($l(ElementData)-(ARepeatLen*2-1))
	{
		s CurValuei = $e(ElementData,i,i+ARepeatLen-1)
		s CurValuej = $e(ElementData,i+ARepeatLen,i+(ARepeatLen*2-1))
		s:(CurValuei=CurValuej) ret=-1
		q:ret=-1
	}
	q ret
}

/// 病案首页.增加质控【出院诊断编码】不出现"S06"开头的编码，则【颅脑损失患者昏迷时间】只能填0。
/// Element1s：【出院诊断编码】的codes(多个以“\”分隔)，Element2s：【颅脑损失患者昏迷时间】的codes(多个以“\”分隔)
ClassMethod IsUnify202209281(EpisodeID As %String, Element1s As %String, Element2s As %String)
{
	s flag=0
	for i=1:1:$l(Element1s,"\")
	{
		s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,$p(Element1s,"\",i),"")
		s:($e(ElementData1,1,3)="S06") flag=1
		q:(flag=1)
	}
	q:(flag=1) 1
	s flag=1
	for i=1:1:$l(Element2s,"\")
	{
		s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,$p(Element2s,"\",i),"")
		s ElementData2=$tr(ElementData2," ")
		s:(ElementData2'="") flag=-1
		q:(flag=-1)
	}
	q flag
}

/// Desc:病案首页切口愈合等级需要和手术记录的切口类型相符合
/// Input:EpisodeID 就诊号 Element1s 病案首页切口愈合等级,Element2s 手术名称 Element3s 手术日期, Element4s 手术记录切口类型 DocID 手术记录DocID
/// Output:ret=1 通过,ret=-1 不通过 ret=0 参数缺失
/// Creator:wzl 2022年12月9日
/// Debug:w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).CheckWoundHealing(35077763,"15319\15320\15321\15322\15323\15365","15266\15236\15244\15252\15260\15361","15162\15235\15243\15251\15259\15360","352",23559,25707,23556)
ClassMethod CheckWoundHealing(EpisodeID, Element1s, Element2s, Element3s, DocID, Element4, Element5, Element6)
{
	s ret=0
	
	q:(EpisodeID="")||(Element1s="")||(Element2s="")||(Element3s="")||(Element4="")||(DocID="")||(Element5="")||(Element6="") ret
	
	s ret=1
	for i=1:1:$l(Element1s,"\")
	{
		s el1=$p(Element1s,"\",i)  //愈合等级code
		
		s el2=$p(Element2s,"\",i)  //手术名称code
		
		s el3=$p(Element3s,"\",i)  //手术日期code
		
	
		
		s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,el2,"")
		
		continue:(ElementData2="")||(ElementData2="-") //如果手术名称为空则不检测
		s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,el1,"")  //切口愈合等级
		s ElementData3 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,el3,"")  //手术日期
		
		s flag=..RecordInfoCompare(EpisodeID,DocID,Element4,Element5,Element6,ElementData3,ElementData2,ElementData1)
		
		//获取模板元素名
		s ElementName=$list(^DHCEPRM.QualityTemplateD(el2),3)
		s:(ElementName'="") ElementName=$p(ElementName,".",1)
		
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(el2)
		
		s:(flag=0) ret=-1_"^"_ElementName_"@"_ElementCode
		
		q:(ret["-1")
	}
	
	q ret
}

/// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator:  wzl 2022年12月9日
/// Desc:     判断手术切口愈合等级是否和手术记录上的切口类型相符,(如果存在多台手术、手术名称和手术日期、就诊号确定书写的手术记录)
/// Input:    就诊号Adm、病历展现结构的DocID、Element1 手术记录手术日期Code、Element2 手术记录手术名称Code、Element3 手术记录切口愈合等级Code Value1 首页手术日期 Value2 首页手术名称,Value3 首页切口愈合等级
/// OutPut:   ret=1 相符 ret=0 不相符
/// Debug:    w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).GetValidInstanceIDList(35077763,"352","")
ClassMethod RecordInfoCompare(Adm As %String, DocIDList As %String, Element1 As %String, Element2 As %String, Element3 As %String, Value1 As %String, Value2 As %String, Value3 As %String) As %String
{
	
	s ret=0
	
    q:(($d(Adm)=0)||(Adm="")||($TR(DocIDList,"^","")="")||(DocIDList="")) ret
    
    for iDocID=1:1:$Length(DocIDList,"^")
    {
        s DocID = $P(DocIDList,"^",iDocID)
        continue:(DocID="")
        s TheECRecord = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_Adm," "_DocID,""))
        continue:(TheECRecord="")
        
        s LisNo = ""
        For
        {
            s InstanceID = ""
            s LisNo = $O(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",TheECRecord,LisNo))
            q:(LisNo="")
            s InstanceID = TheECRecord_"||"_LisNo
            s InstanceID = $TR(InstanceID," ","")
            s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
            continue:($IsObject(objInstance)=0)   // add by wep 20191202
            s status = objInstance.Status
            continue:(status'="Save")
                
            
            //获取手术记录上的手术日期、手术名称、
            s RecordDate = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(Adm,Element1,InstanceID)
            s RecordDate=$p(RecordDate," ",1)
            s:(RecordDate'="") RecordDate=$tr(RecordDate,"年","-")
            s:(RecordDate'="") RecordDate=$tr(RecordDate,"月","-")
            s:(RecordDate'="") RecordDate=$tr(RecordDate,"日","")
            s RecordName=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(Adm,Element2,InstanceID)
            
            continue:(RecordDate'=Value1)||(RecordName'=Value2)  //多个手术记录情况下，如果手术日期或者手术名称不等于首页手术日期和首页手术名称,则检测下一份手术记录
            
            s CutType=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(Adm,Element3,InstanceID)
            s CutType=$tr(CutType,"I","Ⅰ")
            s CutType=$tr(CutType,"II","Ⅱ")
            s CutType=$tr(CutType,"III","Ⅲ")
            
            s Value3=$tr(Value3,"I","Ⅰ")
            s Value3=$tr(Value3,"II","Ⅱ")
            s Value3=$tr(Value3,"III","Ⅲ")
            
            s:Value3[CutType ret=1
            
            
            do objInstance.%Close()     // add by wep 2020/01/03
            
            q:(ret=1)
        }
    }
    
    q ret
}

}
