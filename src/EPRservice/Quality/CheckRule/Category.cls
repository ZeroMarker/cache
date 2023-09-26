/// Class Name:	 	EPRservice.Quality.CheckRule.Category
/// Description: 	判断病历内容及病历目录是否完成类
/// Author: 	 	Zuoxiang Xie
/// Create Date: 	2010-05-10
Class EPRservice.Quality.CheckRule.Category Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断病历内容是否完成(所有子目录完成即算完成);
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
///  	   			AParentStructID为病历内容RowID(对应质控结构中界面模板目录以上级别病历内容);
///  	   			ALocIDs为不需要参与判断的科室RowID字符串,注意多个以"^"分隔;
/// Output:			无
/// Return:			只要有一个子模板目录没完成即返回-1,当所有该填子模板目录都完成时返回1;
/// Others： 		w ##Class(EPRservice.Quality.CheckRule.Category).IsSaveContent0("2482807","128")
ClassMethod IsSaveContent0(AEpisodeID As %String, AParentStructID As %String, ALocIDs As %String = "") As %String
{
	s ret = "0^IsSaveContent0参数配置异常!"
	q:(AEpisodeID = "")||(AParentStructID = "") ret
	q:($d(AEpisodeID) = 0)||($d(AParentStructID) = 0) ret
	
	if (ALocIDs '= "")
	{
		// 得到患者当前所在科室
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		if (curAdmitLocID = "")
		{
			s ret = "0^患者当前不属于任何一个科室,质控项目异常退出!"
			q ret	
		}
	
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		if ($listfind(locIDs,curAdmitLocID) > 0)
		{
			s ret = "1^患者当前所在科室不采用该质控项目,正常退出!"
			q ret	
		}	
	}
	
	// 判断当前病历内容对患者是否有效
	s flag = ..IsRightCatalog(AEpisodeID,AParentStructID)
	if (flag < 1)
	{
		s parStructName = ..GetQualityStructName(AParentStructID)
		s ret = "1^病历内容【"_parStructName_"】对当前患者无效!"
		q ret
	}
	
	s ret = 1
	
	// 检索病历内容下的病历目录
	s structID = ""
	for {
		s structID = $o(^DHCEPRM.QualityStructI("IdxParentId"," "_AParentStructID,structID))
		q:(structID = "")
		
		s objStruct = $g(^DHCEPRM.QualityStructD(structID))
		continue:(objStruct = "")		
				
		s bindCategoryID = $list(objStruct,5)
		s bindCategoryParentID = $list(objStruct,6)
		if (bindCategoryID = "")||(bindCategoryID = $c(0))
		{
			//非界面模板目录级别,递归调用
			s flag = ..IsSaveContent0(AEpisodeID,structID,ALocIDs)
		}
		else
		{
			//界面模板目录级别,调用IsSaveCatalog0(AEpisodeID,AStructID,ACompareStructIDs,ALocIDs)
			s flag = ..IsSaveCatalog0(AEpisodeID,structID,"",ALocIDs)
		}
		
		if ($p(flag,"^",1) < 0)
		{
			s ret = -1
			q	
		}
	}
	
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断病历内容是否在规定的时间内完成(所有子目录完成即算完成,超时完成也算合格);
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
///  				AParentStructID为病历内容RowID(对应质控结构中界面模板目录以上级别的病历内容);
///  				ADateTime为计时起始日期时间点;
///  				AHours为规定的有效小时数;
///  				ALocIDs为不需要参与判断的科室RowID字符串,注意多个以"^"分隔;
///                 AFlag 为1时不到时限不扣分不提示（用于在、出院质控），否则提示扣分（用于提示列表） Add BY Candyxu 2012-11-29
/// Return:			只要有一个子模板目录没完成即返回-1;
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).IsSaveContent1("2482807","128","2011-07-20 15:38:00","24")
ClassMethod IsSaveContent1(AEpisodeID As %String, AParentStructID As %String, ADateTime As %String, AHours As %String, ALocIDs As %String = "", AFlag As %String = "") As %String
{
	s ret = "0^IsSaveContent0参数配置异常!", errInfo = ""
	q:(AEpisodeID = "")||(AParentStructID = "")||(ADateTime = "")||(AHours = "") ret
	q:($d(AEpisodeID) = 0)||($d(AParentStructID) = 0)||($d(ADateTime) = 0)||($d(AHours) = 0) ret
	
	if (ALocIDs '= "")
	{
		// 得到患者当前所在科室
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		if (curAdmitLocID = "")
		{
			s ret = "0^患者当前不属于任何一个科室,质控项目异常退出!"
			q ret	
		}
	
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		if ($listfind(locIDs,curAdmitLocID) > 0)
		{
			s ret = "1^患者当前所在科室不采用该质控项目,正常退出!"
			q ret	
		}	
	}
			
	// 判断当前病历内容对患者是否有效
	s flag = ..IsRightCatalog(AEpisodeID,AParentStructID)
	if (flag < 1)
	{
		s parStructName = ..GetQualityStructName(AParentStructID)
		s ret = "1^病历内容【"_parStructName_"】对当前患者无效!"
		q ret
	}
	
	s ret = 1
	
	s structID = ""
	for {
		s structID = $o(^DHCEPRM.QualityStructI("IdxParentId"," "_AParentStructID,structID))
		q:(structID = "")
		
		//中国医大医院 入院记录一致性检查 临时写死
		//wangwentao 20101029 CodeControl写死 入院记录.一般情况主诉现病史 和 入院记录.诊断
		//continue:(AParentStructID=125)&&((structID'=306)&&(structID'=320))

		s objStruct = $g(^DHCEPRM.QualityStructD(structID))
		continue:(objStruct = "")
				
		s bindCategoryID = $list(objStruct,5)
		s bindCategoryParentID = $list(objStruct,6)
		if (bindCategoryID = "")||(bindCategoryID = $c(0))
		{
			//非界面模板目录级别,递归调用
			s flag = ..IsSaveContent1(AEpisodeID,structID,ADateTime,AHours,ALocIDs,AFlag)
		}
		else
		{
			//界面模板目录级别,调用IsSaveCatalog1(AEpisodeID,AStructID,ADateTime,AHours,ACompareStructs,ALocIDs,AFlag)
			s flag = ..IsSaveCatalog1(AEpisodeID,structID,ADateTime,AHours,"",ALocIDs,AFlag)
		}
		
		if ($p(flag,"^",1) < 0)
		{
			s ret = -1
			s:($p(flag,"^",2) '= "") errInfo = errInfo_$lb($p(flag,"^",2))
			q	
		}
	}
	
	s:(ret < 0) ret = ret_"^"_##Class(EPRservice.Quality.CommonHelper).GetListToString(errInfo,",")
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断病历内容是否在规定的时间内完成(所有子目录完成即算完成,超时完成算不合格);
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
///  				AParentStructID为病历内容RowID(对应质控结构中界面模板目录以上级别病历内容);
///  				ADateTime为计时起始日期时间点;
///  				AHours为规定的有效小时数;
///  				ALocIDs为不需要参与判断的科室RowID字符串,注意多个以"^"分隔;
///                 AFlag 为1时表示不到时限不扣分（用于在、出院质控），否则扣分并提示 
///                 AAheadTime 为1时 提前填写不扣分，否则扣分提示
/// Output:			无
/// Return:			在规定的时效内完成返回1,否则返回-1;
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).IsSaveContent2("2482807","128","2011-07-20 15:38:00","24")
ClassMethod IsSaveContent2(AEpisodeID As %String, AParentStructID As %String, ADateTime As %String, AHours As %String, ALocIDs As %String = "", AFlag As %String = "", AAheadTime As %String = "") As %String
{
	s ret = 0, errInfo = ""
	q:(AEpisodeID = "")||(AParentStructID = "")||(ADateTime = "")||(AHours = "") ret
	q:($d(AEpisodeID) = 0)||($d(AParentStructID) = 0)||($d(ADateTime) = 0)||($d(AHours) = 0) ret
	
	if (ALocIDs '= "")
	{
		// 得到患者当前所在科室
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		if (curAdmitLocID = "")
		{
			s ret = "0^患者当前不属于任何一个科室,质控项目异常退出!"
			q ret	
		}
	
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		if ($listfind(locIDs,curAdmitLocID) > 0)
		{
			s ret = "1^患者当前所在科室不采用该质控项目!"
			q ret	
		}	
	}
	
	// 判断当前病历内容对患者是否有效
	s flag = ..IsRightCatalog(AEpisodeID,AParentStructID)
	if (flag < 1)
	{
		s parStructName = ..GetQualityStructName(AParentStructID)
		s ret = "1^病历内容【"_parStructName_"】对当前患者无效!"
		q ret
	}	
	
	s ret = 1
	s structID = ""
	for {
		s structID = $o(^DHCEPRM.QualityStructI("IdxParentId"," "_AParentStructID,structID))
		q:(structID = "")
		
		s objStruct = $g(^DHCEPRM.QualityStructD(structID))
		continue:(objStruct = "")	
				
		s bindCategoryID = $list(objStruct,5)
		s bindCategoryParentID = $list(objStruct,6)
		if (bindCategoryID = "")||(bindCategoryID = $c(0))
		{
			s flag = ..IsSaveContent2(AEpisodeID,structID,ADateTime,AHours,ALocIDs,AFlag,AAheadTime)
		}
		else
		{
			s flag = ..IsSaveCatalog2(AEpisodeID,structID,ADateTime,AHours,"",ALocIDs,AFlag,AAheadTime)
		}
		
		if ($p(flag,"^",1) < 0)
		{
			s ret = -1
			s:($p(flag,"^",2) '= "") errInfo = errInfo_$lb($p(flag,"^",2))
			q	
		}
	}
	
	s:(ret < 0) ret = ret_"^"_##Class(EPRservice.Quality.CommonHelper).GetListToString(errInfo,",")
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description: 	判断病历内容是否完成(只要有一个子目录完成即算完成);
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
///  	   			AParentStructIDs为病历内容RowID字符串;
///  	   			ALocIDs为不需要参与判断的科室RowID字符串,注意多个以"^"分隔;
/// Output:			无
/// Return:	 		只要有一个子目录完成即返回1;否则返回-1;
/// Others: 		w ##Class(EPRservice.Quality.CheckRule.Category).IsSaveContent3("2482807","311^312")
ClassMethod IsSaveContent3(AEpisodeID As %String, AParentStructIDs As %String, ALocIDs As %String = "") As %String
{
	s ret = "0^IsSaveContent3参数配置异常!"
	q:(AEpisodeID = "")||(AParentStructIDs = "") ret
	q:($d(AEpisodeID) = 0)||($d(AParentStructIDs) = 0) ret
	
	if (ALocIDs '= "")
	{
		// 得到患者当前所在科室
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		if (curAdmitLocID = "")
		{
			s ret = "0^患者当前不属于任何一个科室,质控项目异常退出!"
			q ret	
		}
	
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		if ($listfind(locIDs,curAdmitLocID) > 0)
		{
			s ret = "1^患者当前所在科室不采用该质控项目!"
			q ret	
		}	
	}
	
	s ret = -1
	s lstParentStructID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AParentStructIDs,"^","Y")
	for ind = 1:1:$listlength(lstParentStructID)
	{
		s parStructID = $listget(lstParentStructID,ind)
		continue:(parStructID = "")

		// Check whether <parStructID> is active for <AEpisodeID> 	
		s flag = ..IsRightCatalog(AEpisodeID,parStructID)
		continue:(flag < 1)
		
		s objParentStruct = $g(^DHCEPRM.QualityStructD(parStructID))
		
		s parBindCategoryID = $list(objParentStruct,5)
		if (parBindCategoryID = "")||(parBindCategoryID = $c(0))
		{
			// loop all child structs under parStructID
			s structID = ""
			for {
				s structID = $o(^DHCEPRM.QualityStructI("IdxParentId"," "_parStructID,structID))
				q:(structID = "")
				
				s flag = ..IsRightCatalog(AEpisodeID,structID)
				continue:(flag < 1)
				
				s objStruct = $g(^DHCEPRM.QualityStructD(structID))
				
				s bindCategoryID = $list(objStruct,5)
				if (bindCategoryID = "")||(bindCategoryID = $c(0))
				{
					s flag = ..IsSaveContent3(AEpisodeID,structID,ALocIDs)
				}
				else
				{
					s flag = ..IsSaveCatalog0(AEpisodeID,structID,"",ALocIDs)
				}
						
				if ($p(flag,"^",1) > 0)
				{
					s ret = 1
					q	
				}
			}
		}
		else
		{
			s flag = ..IsSaveCatalog0(AEpisodeID,parStructID,"",ALocIDs)
			if ($p(flag,"^",1) > 0)
			{
				s ret = 1
				q	
			}
		}
	}
	
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断指定的病历内容是否在规定的时效内完成,只要有一个完成就算合格(超时完成也算完成);
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
///  				AParentStructIDs为病历内容RowID字符串;
///  				ADateTime为计时起始日期时间点;
///  				AHours为有效小时数;
///  				ALocIDs为不需要参与判断的科室RowID字符串,注意多个以"^"分隔;
///                 AFlag 为1时不到时限不扣分不提示（用于在、出院质控），否则提示扣分（用于提示列表） Add BY Candyxu 2012-11-29
/// Return:			只要有一个子目录完成(包括超时)即返回1;否则返回-1;
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).IsSaveContent4("2482807","311^312","2010-07-01 10:34:52","24")
ClassMethod IsSaveContent4(AEpisodeID As %String, AParentStructIDs As %String, ADateTime As %String, AHours As %String, ALocIDs As %String = "", AFlag As %String = "") As %String
{
	s ret = "0^IsSaveContent4参数配置异常!"
	q:(AEpisodeID = "")||(AParentStructIDs = "")||(ADateTime = "")||(AHours = "") ret
	q:($d(AEpisodeID) = 0)||($d(AParentStructIDs) = 0)||($d(ADateTime) = 0)||($d(AHours) = 0) ret
	
	if (ALocIDs '= "")
	{
		// 得到患者当前所在科室
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		if (curAdmitLocID = "")
		{
			s ret = "0^患者当前不属于任何一个科室, 质控项目异常退出!"
			q ret	
		}
	
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		if ($listfind(locIDs,curAdmitLocID) > 0)
		{
			s ret = "1^患者当前所在科室不采用该质控项目!"
			q ret	
		}	
	}
		
	s ret = -1
	s lstParentStructID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AParentStructIDs,"^","Y")
	for ind = 1:1:$listlength(lstParentStructID)
	{
		s parStructID = $listget(lstParentStructID,ind)
		continue:(parStructID = "")
		
		// Check whether parStructID is active for <AEpisodeID> 	
		s flag = ..IsRightCatalog(AEpisodeID,parStructID)
		continue:(flag < 1)
		
		s objParentStruct = $g(^DHCEPRM.QualityStructD(parStructID))
		
		s parBindCategoryID = $list(objParentStruct,5)
		if (parBindCategoryID = "")||(parBindCategoryID = $c(0))
		{
			// loop all child structs under parStructID
			s structID = ""
			for {
				s structID = $o(^DHCEPRM.QualityStructI("IdxParentId"," "_parStructID,structID))
				q:(structID = "")
				
				s flag = ..IsRightCatalog(AEpisodeID,structID)
				continue:(flag < 1)
								
				s objStruct = $g(^DHCEPRM.QualityStructD(structID))
				
				s bindCategoryID = $list(objStruct,5)
				if (bindCategoryID = "")||(bindCategoryID = $c(0))
				{
					s flag = ..IsSaveContent4(AEpisodeID,structID,ADateTime,AHours,ALocIDs,AFlag)
				}
				else
				{
					s flag = ..IsSaveCatalog1(AEpisodeID,structID,ADateTime,AHours,"",ALocIDs,AFlag)
				}
						
				if ($p(flag,"^",1) > 0)
				{
					s ret = 1
					q	
				}
			}
		}
		else
		{
			s flag = ..IsSaveCatalog1(AEpisodeID,parStructID,ADateTime,AHours,"",ALocIDs,AFlag)
			if ($p(flag,"^",1) > 0)
			{
				s ret = 1
				q	
			}
		}
	}
	
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断指定的病历内容集合是否在规定的时效内完成,只要有一个完成就算合格(供自动任务,超时完成算不合格);
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
///  				AParentStructIDs为病历内容RowID字符串,注意多个以"^"分隔;
///  				ADateTime为计时起始日期时间点;
///  				AHours为有效小时数;
///  				ALocIDs为不需要参与判断的科室RowID字符串,注意多个以"^"分隔;
///                 AFlag 为1时表示不到时限不扣分（用于在、出院质控），否则扣分并提示 
///                 AAheadTime 为1时 提前填写不扣分，否则扣分提示
/// Output:			只要有一个子目录在规定时间内完成即返回1;否则返回-1;
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).IsSaveContent5("2482807","311^312","2010-07-01 10:34:52","24")
ClassMethod IsSaveContent5(AEpisodeID As %String, AParentStructIDs As %String, ADateTime As %String, AHours As %String, ALocIDs As %String = "", AFlag As %String = "", AAheadTime As %String = "") As %String
{
	s ret = "0^IsSaveContent5参数配置异常!"
	q:(AEpisodeID = "")||(AParentStructIDs = "")||(ADateTime = "")||(AHours = "") ret
	q:($d(AEpisodeID) = 0)||($d(AParentStructIDs) = 0)||($d(ADateTime) = 0)||($d(AHours) = 0) ret
	
	if (ALocIDs '= "")
	{
		// 得到患者当前所在科室
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		if (curAdmitLocID = "")
		{
			s ret = "0^患者当前不属于任何一个科室,质控项目异常退出!"
			q ret	
		}
	
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		if ($listfind(locIDs,curAdmitLocID) > 0)
		{
			s ret = "1^患者当前所在科室不采用该质控项目!"
			q ret	
		}	
	}
		
	s ret = -1
	s lstParentStructID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AParentStructIDs,"^","Y")
	for ind = 1:1:$listlength(lstParentStructID)
	{
		s parStructID = $listget(lstParentStructID,ind)
		continue:(parStructID = "")
		
		// Check whether parStructID is active for <AEpisodeID> 	
		s flag = ..IsRightCatalog(AEpisodeID,parStructID)
		continue:(flag < 1)
		
		s objParentStruct = $g(^DHCEPRM.QualityStructD(parStructID))
		
		s parBindCategoryID = $list(objParentStruct,5)
		if (parBindCategoryID = "")||(parBindCategoryID = $c(0))
		{
			// loop all child structs under parStructID
			s structID = ""
			for {
				s structID = $o(^DHCEPRM.QualityStructI("IdxParentId"," "_parStructID,structID))
				q:(structID = "")
				
				s flag = ..IsRightCatalog(AEpisodeID,structID)
				continue:(flag < 1)
								
				s objStruct = $g(^DHCEPRM.QualityStructD(structID))
				
				s bindCategoryID = $list(objStruct,5)
				if (bindCategoryID = "")||(bindCategoryID = $c(0))
				{
					s flag = ..IsSaveContent5(AEpisodeID,structID,ADateTime,AHours,ALocIDs,AFlag,AAheadTime)
				}
				else
				{
					s flag = ..IsSaveCatalog2(AEpisodeID,structID,ADateTime,AHours,"",ALocIDs,AFlag,AAheadTime)
				}
						
				if ($p(flag,"^",1) > 0)
				{
					s ret = 1
					q	
				}
			}
		}
		else
		{
			s flag = ..IsSaveCatalog2(AEpisodeID,parStructID,ADateTime,AHours,"",ALocIDs,AFlag,AAheadTime)
			if ($p(flag,"^",1) > 0)
			{
				s ret = 1
				q	
			}
		}
	}
	
	q ret
}

/// Creator:		Zuoxiang Xie    modify by Candyxu 2012-07-12(之前方法检查病历内容集合有误，重新改写)
///                 modify by Hanxf 2013-10-14(增加出院时间入参，24小时内出入院不写首程使用-山东海阳)
/// CreateDate:		2010-05-05
/// Description:	判断指定的病历内容集合是否在规定的时效内完成,只要有一个成就算合格,子目录只要有一个没完成算未完成(供自动任务,超时完成算合格);
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
///  				AStructIDs为病历内容RowID字符串(对应质控结构中界面模板目录以上级别,注意多个以"#"分隔);
///  				ADateTime为计时起始日期时间点;
///  				AHours为有效小时数;
///  				ALocIDs为不需要参与判断的科室RowID字符串,注意多个以"^"分隔;
///                 AFlag 为1时不到时限不扣分不提示（用于在、出院质控），否则提示扣分（用于提示列表） Add BY Candyxu 2012-11-29
///                 ADisDateTime不为空时，判断和计时起始时间在24小时内的返回1，否则返回-1;
/// Output:			只有所有质控结构在规定的时效内完成即返回1;否则返回-1;
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).IsSaveContent6("2482807","311#312","2010-07-01 10:34:52","24")
ClassMethod IsSaveContent6(AEpisodeID As %String, AStructIDs As %String, ADateTime As %String, AHours As %String, ALocIDs As %String = "", AFlag As %String = "", ADisDateTime As %String = "") As %String
{
	s ret = "0^IsSaveContent6参数配置异常!"
	q:(AEpisodeID = "")||(AStructIDs = "")||(ADateTime = "")||(AHours = "") ret
	q:($d(AEpisodeID) = 0)||($d(AStructIDs) = 0)||($d(ADateTime) = 0)||($d(AHours) = 0) ret
	
	if (ALocIDs '= "")
	{
		// 得到患者当前所在科室
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		if (curAdmitLocID = "")
		{
			s ret = "0^患者当前不属于任何一个科室, 质控项目异常退出!"
			q ret	
		}
	
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		if ($listfind(locIDs,curAdmitLocID) > 0)
		{
			s ret = "1^患者当前所在科室不采用该质控项目!"
			q ret	
		}	
	}
	if (ADisDateTime '= "")
	{
		s ADate=$p(ADateTime," ",1)
		s ATime=$p(ADateTime," ",2)
		s ADisDate=$p(ADisDateTime," ",1)
		s ADisTime=$p(ADisDateTime," ",2)
	
		s DateDevi=$zdh(ADisDate,3)-$zdh(ADate,3)
		s TimeDevi=$zth(ADisTime,3)-$zth(ATime,3)
		
		if (((DateDevi=0) && (TimeDevi>=0) && (TimeDevi<=(24*3600)))||((DateDevi=1) && (TimeDevi<=0)))
		{
			s ret = "1^患者在24小时内入出院不采用该质控项目"
			q ret
		}
		
	}
	s ret = -1
	s errInfo = ""
	s lstStructID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AStructIDs,"#","Y")
 	for ind = 1:1:$listlength(lstStructID)
	{
		s tempStructID = $listget(lstStructID,ind)
		continue:(tempStructID = "")
		s BindCategoryId = $li(^DHCEPRM.QualityStructD(tempStructID),5)
		if ((BindCategoryId = "") || (BindCategoryId = $c(0)))
		{
		    // Check whether parStructID is active for <AEpisodeID> 	
		    s flag = ..IsRightCatalog(AEpisodeID,tempStructID)
		    continue:($p(flag,"^",1) < 1)
		    s flag = ..IsSaveContent1(AEpisodeID,tempStructID,ADateTime,AHours,ALocIDs,AFlag)
		}
		else
		{
		   s flag = ..IsRightCatalog(AEpisodeID,tempStructID)
		   continue:($p(flag,"^",1) < 1)
		   s flag = ..IsSaveCatalog1(AEpisodeID,tempStructID,ADateTime,AHours,ALocIDs,AFlag)
	    }
	   if ($p(flag,"^",1)>0)
	   {
		  s ret = 1
		  q
	   }
	   else
	   {
		   s errInfo = errInfo_$p(flag,"^",2)
	   }
	}
	s:(ret = -1) ret = ret_"^"_errInfo
	q ret
}

/// Creator:		Zuoxiang Xie  modify by Candyxu 2012-07-12(之前方法检查病历内容集合有误，重新改写)
///                 modify by Hanxf 2013-10-14(增加出院时间入参，24小时内出入院不写首程使用-山东海阳)
/// CreateDate:		2010-05-05
/// Description:	判断指定的病历内容集合是否在规定的时效内完成,只要有一个完成就算合格，子目录只要有一个完成就算完成(供自动任务,超时完成算不合格);
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
///  				AStructIDs为病历内容RowID字符串(对应质控结构中界面模板目录以上级别,注意多个以"#"分隔);
///  				ADateTime为计时起始日期时间点;
///  				AHours为有效小时数;
///  				ALocIDs为不需要参与判断的科室RowID字符串,注意多个以"^"分隔;
///                 AFlag 为1时表示不到时限不扣分（用于在、出院质控），否则扣分并提示 
///                 AAheadTime 为1时 提前填写不扣分，否则扣分提示
///                 ADisDateTime不为空时，判断和计时起始时间在24小时内的返回1，否则返回-1;
/// Output:			只要有一个质控结构不在规定的时效内完成(超时完成不算)即返回-1;否则返回1;
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).IsSaveContent7("2487372","311#312","2010-07-01 10:34:52","24")
ClassMethod IsSaveContent7(AEpisodeID As %String, AStructIDs As %String, ADateTime As %String, AHours As %String, ALocIDs As %String = "", AFlag As %String = "", AAheadTime As %String = "", ADisDateTime As %String = "") As %String
{
	s ret = "0^IsSaveContent7参数配置异常!"
	q:(AEpisodeID = "")||(AStructIDs = "")||(ADateTime = "")||(AHours = "") ret
	q:($d(AEpisodeID) = 0)||($d(AStructIDs) = 0)||($d(ADateTime) = 0)||($d(AHours) = 0) ret
	if (ALocIDs '= "")
	{
		// 得到患者当前所在科室
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		if (curAdmitLocID = "")
		{
			s ret = "0^患者当前不属于任何一个科室, 质控项目异常退出!"
			q ret	
		}
	
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		if ($listfind(locIDs,curAdmitLocID) > 0)
		{
			s ret = "1^患者当前所在科室不采用该质控项目!"
			q ret	
		}	
	}
	if (ADisDateTime '= "")
	{
		s ADate=$p(ADateTime," ",1)
		s ATime=$p(ADateTime," ",2)
		s ADisDate=$p(ADisDateTime," ",1)
		s ADisTime=$p(ADisDateTime," ",2)
	
		s DateDevi=$zdh(ADisDate,3)-$zdh(ADate,3)
		s TimeDevi=$zth(ADisTime,3)-$zth(ATime,3)
		
		if (((DateDevi=0) && (TimeDevi>=0) && (TimeDevi<=(24*3600)))||((DateDevi=1) && (TimeDevi<=0)))
		{
			s ret = "1^患者在24小时内入出院不采用该质控项目"
			q ret
		}
		
	}
	s ret = -1
	s errInfo = ""
	s lstStructID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AStructIDs,"#","Y")
	for ind = 1:1:$listlength(lstStructID)
	{
		s tempStructID = $listget(lstStructID,ind)
		continue:(tempStructID = "")
		s BindCategoryId = $li(^DHCEPRM.QualityStructD(tempStructID),5)
		if ((BindCategoryId = "") || (BindCategoryId = $c(0)))
		{
		    // Check whether parStructID is active for <AEpisodeID> 	
		    s flag = ..IsRightCatalog(AEpisodeID,tempStructID)
		    continue:($p(flag,"^",1) < 1)
		    s flag = ..IsSaveContent2(AEpisodeID,tempStructID,ADateTime,AHours,ALocIDs,AFlag,AAheadTime)
		}
		else
		{
		   s flag = ..IsRightCatalog(AEpisodeID,tempStructID)
		   continue:($p(flag,"^",1) < 1)
		   s flag = ..IsSaveCatalog2(AEpisodeID,tempStructID,ADateTime,AHours,ALocIDs,AFlag,AAheadTime)
	     }
	   if ($p(flag,"^",1)>0)
	   {
		  s ret = 1
		  q
	   }
	   else
	   {
		   s errInfo = errInfo_$p(flag,"^",2)
	   }
	}
	s:(ret = -1) ret = ret_"^"_errInfo
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断质控目录结构(界面模板目录级别)是否完成;
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
/// 				AStructID为界面模板目录级别对应的质控结构RowID;
/// 				ACompareStructs为参考界面模板目录级别对应的质控结构RowID字符串,如果其中有一个完成即判断该项目已完成(注意多个结构以"#"分隔);
/// Output:			界面模板目录级别的质控结构完成或参考的质控结构中有一个完成即返回1;否则返回-1;
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).IsSaveCatalog0("2482807","311")
ClassMethod IsSaveCatalog0(AEpisodeID As %String, AStructID As %String, ACompareStructs As %String = "", ALocIDs As %String = "") As %String
{
	s ret = "0^IsSaveCatalog0参数配置异常!"
	q:(AEpisodeID = "")||(AStructID = "") ret
	q:($d(AEpisodeID) = 0)||($d(AStructID) = 0) ret
	
	s flag = ..IsRightCatalog(AEpisodeID,AStructID)
	if (flag < 1)
	{
		s structName = ..GetQualityStructName(AStructID)
		s ret = "1^质控结构【"_structName_"】对当前患者无效!"
		q ret
	}
	
	if (ALocIDs '= "")
	{
		// 得到患者当前所在科室
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		if (curAdmitLocID = "")
		{
			s ret = "0^患者当前不属于任何一个科室, 质控项目异常退出!"
			q ret	
		}
	
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		if ($listfind(locIDs,curAdmitLocID) > 0)
		{
			s ret = "1^患者当前所在科室不采用该质控项目!"
			q ret	
		}	
	}

	s ret = 1
	if (ACompareStructs '= "")
	{
		s finish = 0
		s CompareStructs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ACompareStructs,"#")
		for ind = 1:1:$listlength(CompareStructs)
		{
			s CompareStruct = $listget(CompareStructs,ind)
			continue:(CompareStruct = "")
			
			s flag = ..IsSaveCatalog0(AEpisodeID,CompareStruct,"",ALocIDs)
			if ($p(flag,"^",1) = 1)
			{
				s finish = 1
				q	
			}
		}
		q:(finish = 1) ret
	}
	
	//CatalogData = TemplateID^Status^SaveTime
	s CatalogData = ..GetCatalogData(AEpisodeID,AStructID)
	s:($p(CatalogData,"^",1) = "") ret = -1
	s:($p(CatalogData,"^",2) = "UnSave") ret = -1
	
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断患者某界面模板目录是否在规定时效内完成(超时完成也算完成);
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
/// 				AStructID为界面模板目录对应的质控结构RowID;
///  				ADateTime为计时起始日期时间;
///  				AHours为指定的小时数;
///  				ACompareStructs为参考质控结构RowID字符串(多个以"#"分隔),如果其中有一个完成即忽略此项目并认为该项目完成;
///  				ALocIDs为不需要参与判断的科室RowID字符串,注意多个以"^"分隔;
///                 AFlag 为1时不到时限不扣分不提示（用于在、出院质控），否则提示扣分（用于提示列表） Add BY Candyxu 2012-11-29
/// Output:			界面模板写过返回1;否则返回-1^提示信息;
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).IsSaveCatalog1("2482807","311","2011-07-24 10:34:52","24")
ClassMethod IsSaveCatalog1(AEpisodeID As %String, AStructID As %String, ADateTime As %String, AHours As %String, ACompareStructs As %String = "", ALocIDs As %String = "", AFlag As %String = "") As %String
{
	s ret = "0^IsSaveCatalog1参数配置异常!", errInfo = ""
	q:(AEpisodeID = "")||(AStructID = "")||(ADateTime = "")||(AHours = "") ret
	q:($d(AEpisodeID) = 0)||($d(AStructID) = 0)||($d(ADateTime) = 0)||($d(AHours) = 0) ret
	
	s CurrentTime = $zd(+$h,3)_" "_$zt($p($h,",",2),2)		// Format: 2010-06-17 09:38
	s tmpHours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(CurrentTime,ADateTime)
	q:(tmpHours < 0) ret
	s Hours = +AHours
	s Interval = tmpHours - Hours 
	//AFlag =1 为不到时间不扣分不提示
	if (AFlag = 1) { q:(Interval <=0) ret = 1 }
	//判断目录结构
	s flag = ..IsRightCatalog(AEpisodeID,AStructID)
	if (flag < 1)
	{
		s structName = ..GetQualityStructName(AStructID)
		q ret = "1^质控结构【"_structName_"】对当前患者无效!"
	}
    //判断的在科室
	if (ALocIDs '= "")
	{
		// 得到患者当前所在科室
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		if (curAdmitLocID = "") q ret = "0^患者当前不属于任何一个科室,质控项目异常退出!"
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		if ($listfind(locIDs,curAdmitLocID) > 0) q ret = "1^患者当前所在科室不采用该质控项目!"	
	}
	//判断其它结构
	s ret = 1
	if (ACompareStructs '= "")
	{
		s finish = 0
		s CompareStructs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ACompareStructs,"#")
		for Ind = 1:1:$listlength(CompareStructs)
		{
			s CompareStruct = $listget(CompareStructs,Ind)
			continue:(CompareStruct = "")
			
			s flag = ..IsSaveCatalog1(AEpisodeID,CompareStruct,ADateTime,AHours,"",ALocIDs,AFlag)
			if ($p(flag,"^",1) = 1)
			{
				s finish = 1
				q	
			}
		}
		q:(finish = 1) ret
	}
	//CatalogData = TemplateID_"^"_Status_"^"_SaveTime
	s CatalogData = ..GetCatalogData(AEpisodeID,AStructID)
	s:($p(CatalogData,"^",1) = "") ret = -1
	s:($zcvt($p(CatalogData,"^",2),"U") = "UNSAVE") ret = -1
	//设置未完成的提示信息
	s:(Interval < 0) Interval = -Interval
	s Interval = $j(Interval,3,1) 
	s:(ret < 0)&&(tmpHours < Hours) errInfo = "参考时间:"_ADateTime_",请在"_Interval_"小时内完成!"
	s:(ret < 0)&&(tmpHours >= Hours) errInfo = "参考时间:"_ADateTime_",超时"_Interval_"小时未完成!"
	s:(ret < 0) ret = ret_"^"_errInfo
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断患者某界面模板目录是否在规定时效内完成(超时完成算不合格);
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
/// 				AStructID为界面模板目录对应的质控结构RowID;
///  				ADateTime为计时起始日期时间;
///  				AHours为指定的小时数;
///  				ACompareStructs为参考质控结构RowID字符串(多个以"#"分隔),如果其中有一个完成即忽略此项目并认为该项目完成;
///  				ALocIDs为不需要参与判断的科室RowID字符串,注意多个以"^"分隔;
///                 AFlag 为1时表示不到时限不扣分（用于在、出院质控），否则扣分并提示 
///                 AAheadTime 为1时 提前填写不扣分，否则扣分提示
/// Output:			在规定时间内完成返回1;否则返回-1^提示信息;
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).IsSaveCatalog2("2482807","311","2011-07-22 10:34:52","24")
ClassMethod IsSaveCatalog2(AEpisodeID As %String, AStructID As %String, ADateTime As %String, AHours As %String, ACompareStructs As %String = "", ALocIDs As %String = "", AFlag As %String = "", AAheadTime As %String = "") As %String
{
	s ret = "0^IsSaveCatalog2参数配置异常!", errInfo = ""
	q:(AEpisodeID = "")||(AStructID = "")||(ADateTime = "")||(AHours = "") ret
	q:($d(AEpisodeID) = 0)||($d(AStructID) = 0)||($d(ADateTime) = 0)||($d(AHours) = 0) ret

	s curDateTime = $zd(+$h,3)_" "_$zt($p($h,",",2),2)		// Format: 2010-06-17 09:38
	s tmpHours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(curDateTime,ADateTime)
	q:(tmpHours < 0) ret
	s hours = +AHours
	s Interval = tmpHours - hours 
	//AFlag =1 为不到时间不扣分不提示
	if (AFlag = 1) { q:(Interval <=0) ret = 1 }


	s flag = ..IsRightCatalog(AEpisodeID,AStructID)
	if (flag < 1)
	{
		s structName = ..GetQualityStructName(AStructID)
		s ret = "1^质控结构【"_structName_"】对当前患者无效!"
		q ret
	}
	
	if (ALocIDs '= "")
	{
		// 得到患者当前所在科室
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		if (curAdmitLocID = "")
		{
			s ret = "0^患者当前不属于任何一个科室, 质控项目异常退出!"
			q ret	
		}
	
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		if ($listfind(locIDs,curAdmitLocID) > 0)
		{
			s ret = "1^患者当前所在科室不采用该质控项目!"
			q ret	
		}	
	}

	//初始化为在规定的时间内完成
	s ret = 1
	
	if (ACompareStructs '= "")
	{
		s finish = 0
		s CompareStructs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ACompareStructs,"#")
		for Ind = 1:1:$listlength(CompareStructs)
		{
			s CompareStruct = $listget(CompareStructs,Ind)
			continue:(CompareStruct = "")
			
			s flag = ..IsSaveCatalog2(AEpisodeID,CompareStruct,ADateTime,AHours,"",ALocIDs,AFlag,AAheadTime)
			if ($p(flag,"^",1) = 1)
			{
				s finish = 1
				q	
			}
		}
		q:(finish = 1) ret		
	}
	
	// 初始化界面模板已保存
	s isSavedFlag = 1
	
	s structName = ..GetQualityStructName(AStructID)
	
	//CatalogData = TemplateID_"^"_Status_"^"_SaveTime
	s CatalogData = ..GetCatalogData(AEpisodeID,AStructID)
	s:($p(CatalogData,"^",1) = "") isSavedFlag = -1
	s:($zcvt($p(CatalogData,"^",2),"U") = "UNSAVE") isSavedFlag = -1
	
	if (isSavedFlag = -1)
	{
		//还未填写
		s errInfo = "参考时间:"_ADateTime_","_structName_"截至目前"_curDateTime_"未完成!"
		s ret = "-1"_"^"_errInfo
	}
	else
	{
		s SaveTime = $p(CatalogData,"^",3)
		s:(SaveTime = "") SaveTime = curDateTime
		s tmpHours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(SaveTime,ADateTime)
		if (AAheadTime = "1")
		{
			q:(tmpHours < 0) ret
		}else
		{
		    s:(tmpHours < 0) tmpHours = -tmpHours
		}
		if (tmpHours > hours)
		{
			//完成但超时
			s flag = -1
			s interval = tmpHours - hours
			s interval = $j(interval,3,1) //保留一位有效数字
			s errInfo = "参考时间:"_ADateTime_","_structName_"超时"_interval_"小时完成!"
			s ret = "-1"_"^"_errInfo
		}
	}
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	获取质控结构对应的界面模板目录的完成情况;
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
/// 				AStructID为界面模板目录对应的质控结构RowID;
/// Output:			无
/// Return:			TemplateID_"^"_Status_"^"_SaveTime
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).GetCatalogData("65","10")
ClassMethod GetCatalogData(AEpisodeID As %String, AStructID As %String) As %String
{
	s ret = ""
	q:(AEpisodeID = "")||(AStructID = "") ret
	q:($d(AEpisodeID) = 0)||($d(AStructID) = 0) ret
	
	s objStruct = $g(^DHCEPRM.QualityStructD(AStructID))
	q:(objStruct = "") ret
	
	s isActive = $list(objStruct,8)
	q:($zcvt(isActive,"U") '= "Y") ret
	
	s BindCategoryID = $list(objStruct,5)
	s BindCategoryParentID = $list(objStruct,6)
	q:(BindCategoryID = "")||(BindCategoryParentID = "") ret
	
	//tmp=TemplateID_$c(1)_CreateDate_$c(1)_CreateTime_$c(1)_CreateUser_$c(1)_ModifyDate_$c(1)_ModifyTime_$c(1)_ModifyUser_$c(1)_InstanceStatus
	s tmp = ..GetTemplateInfoByCatID(AEpisodeID,BindCategoryParentID,BindCategoryID)
	s TemplateID = $p(tmp,$c(1),1)
	s Status = $p(tmp,$c(1),8)  //Save、UnSave
	s:(Status = "") Status = "UnSave"
	s SaveTime = $p(tmp,$c(1),2)_" "_$p(tmp,$c(1),3) 
	s:(TemplateID = "") SaveTime = ""
	s:(Status '= "Save") SaveTime = ""
	q:(TemplateID = "")||(Status = "") ret
	
	s ret = TemplateID_"^"_Status_"^"_SaveTime
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断唯一模板对应质控结构对患者是否有效;
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
/// 				AStructID为质控结构RowID;
/// Output:			无
/// Return:			1:有效;0:异常;-1:无效;
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).IsRightCatalog("201865","107")
ClassMethod IsRightCatalog(AEpisodeID As %String, AStructID As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AStructID = "") ret
	q:($d(AEpisodeID) = 0)||($d(AStructID) = 0) ret
	
	s objStruct =  ##Class(EPRmeta.Quality.QualityStruct).%OpenId(AStructID)
	q:(objStruct = "") ret
	
	s ret = -1
	s isActive = objStruct.IsActive
	q:($zcvt(isActive,"U") '= "Y") ret
	
	s chkConditionDR = objStruct.ChkConditionDR
	q:(chkConditionDR = "")||(+chkConditionDR = 0) ret 
	s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValue(AEpisodeID,chkConditionDR,AStructID)
	q:(flag '= "1") ret 

	s ret = 1
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断唯一模板对应质控结构对患者是否有效;
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
/// 				AStructID为质控结构RowID;
/// Output:			无
/// Return:			1:有效;0:异常;-1:无效;
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).IsRightCatalogNew("201865","107")
ClassMethod IsRightCatalogNew(AEpisodeID As %String, AStructID As %String) As %String
{
	
	s ret = 0
	q:(AEpisodeID = "")||(AStructID = "") ret
	q:($d(AEpisodeID) = 0)||($d(AStructID) = 0) ret

	s objStruct =  ##Class(CT.MA.QC.QualityStruct).%OpenId(AStructID)
	q:(objStruct = "") ret

	s ret = -1
	s isActive = objStruct.IsActive
	q:($zcvt(isActive,"U") '= "Y") ret
	
	s chkConditionDR = objStruct.ChkConditionDR
	q:(chkConditionDR = "")||(+chkConditionDR = 0) ret 
	
	s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValueNew(AEpisodeID,chkConditionDR,AStructID)
	q:(flag '= "1") ret 
    
	s ret = 1
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description: 	判断可重复模板对应质控结构对患者是否有效;
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
/// 				AStructID为质控结构RowID;
/// Output:			无
/// Return:			1:有效;0:异常;-1:无效;
/// Debug:			w ##Class(EPRservice.Quality.CheckRule.Category).IsRightMultiCatalog("65","")
ClassMethod IsRightMultiCatalog(AEpisodeID As %String, AStructID As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AStructID = "") ret
	q:($d(AEpisodeID) = 0)||($d(AStructID) = 0) ret
	
	s objStruct = $g(^DHCEPRM.QualityStructD(AStructID))
	q:(objStruct = "") ret
	
	s isActive = $list(objStruct,8)
	q:($zcvt(isActive,"U") '= "Y") ret
	
	s chkConditionDR = $list(objStruct,7)
	q:(chkConditionDR = "")||(+chkConditionDR = 0) ret 
	
	s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValue(AEpisodeID,chkConditionDR,AStructID)
	q:(flag '= "1") ret 

	s ret = 1
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	根据质控结构RowID获取质控结构名称;
/// 				首先获取标准名称,如果为空则读取绑定的电子病历目录名称;
/// Table:			无
/// Input:			AStructID为质控结构RowID;
/// Output:			无
/// Return:			ret = 质控结构名称;
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).GetQualityStructName("10")
ClassMethod GetQualityStructName(AStructID As %String) As %String
{
	s ret = ""
	q:($d(AStructID) = 0)||(AStructID = "") ret
	
	s objStruct = $g(^DHCEPRM.QualityStructD(AStructID))
	q:(objStruct = "") ret
	
	s StandardName = $list(objStruct,1)
	s BindEPRName = $list(objStruct,4)
	
	if (StandardName '= "") 
	{
		s ret = StandardName
	} 
	else 
	{
		s ret = BindEPRName
	}
	
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description: 	获取界面模板目录下界面模板完成信息;
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
/// 				AMountCategoryID为界面模板目录的父目录RowID;
/// 				ACategoryID为界面模板目录RowID;
/// Output:			无
/// Return:			TemplateID_$c(1)_CreateDate_$c(1)_CreateTime_$c(1)_CreateUser_$c(1)_ModifyDate_$c(1)_ModifyTime_$c(1)_ModifyUser_$c(1)_InstanceStatus
/// Others:			s ret = ##Class(EPRservice.Quality.CheckRule.Category).GetTemplateInfoByCatID("65","527","533")
ClassMethod GetTemplateInfoByCatID(AEpisodeID As %String, AMountCategoryID As %String, ACategoryID As %String) As %String
{
	s ret = ""
	q:(AEpisodeID = "")||(AMountCategoryID = "")||(ACategoryID = "") ret
	q:(($d(AEpisodeID) = 0)||($d(AMountCategoryID) = 0)||($d(ACategoryID) = 0)) ret
	
	s instanceStatus = ""
	s ECRecordID = ""
	for {
		s ECRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_AEpisodeID," "_ACategoryID,ECRecordID))
		q:(ECRecordID = "")
		
		s ChildSub = ""
		for {
			s ChildSub = $o(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID,ChildSub))
			q:(ChildSub = "")
			
			s InstanceID = ECRecordID_"||"_ChildSub
			s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(InstanceID)
			continue:(objInstance = "") 
			continue:(objInstance.Status = "UnSave") 
			
			if (objInstance.GroupItemID = ACategoryID)
			{
				s templateID = objInstance.TemplateID
				s createDate = objInstance.CreateDate
				s createTime = objInstance.CreateTime
				s createUser = objInstance.CreateUser
				s modifyDate = objInstance.ModifyDate
				s modifyTime = objInstance.ModifyTime
				s modifyUser = objInstance.ModifyUser
				s instanceStatus = objInstance.Status
				s ret = templateID_$c(1)_createDate_$c(1)_createTime_$c(1)_createUser_$c(1)_modifyDate_$c(1)_modifyTime_$c(1)_modifyUser_$c(1)_instanceStatus
				q
			}
		}
	}	
		
	// Not saved any templates under the given <ACategoryID>
	if (instanceStatus = "")||(instanceStatus = "UnSave")
	{	
		s ret = ""
	}
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断成组模板是否完成;
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
/// 				AStructID为质控结构RowID;
/// 				ATemplateGroups为多套模板组字符串,其格式为GroupNameA&TemplateA#TemplateB#TemplateC|GroupNameB&TemplateD##|GroupNameC&#TemplateE#，
/// 	 			每套模板要求有同样数量的模板,没有就放空,而且要求各套模板的顺序一致;
/// 	 			ADateTime表示计时起始时间;
/// 	 			AHour表示规定的时间限制(单位为小时);
/// 				ALocIDs表示使用该条目的科室字符串,多个科室以"^"分隔;
/// 	 			AFlag=1表示强制要求该条目在<ADateTime>发生后的<AHour>小时内完成;
/// Output:			无
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).IsGroupCategoryFinished("2482807","128","神外肿瘤&325#310#311|颅脑损伤&329#308#309|伽玛刀&413##","2008-12-01 16:51:00","8","15","1")
ClassMethod IsGroupCategoryFinished(AEpisodeID As %String, AStructID As %String, ATemplateGroups As %String, ADateTime As %String, AHour As %String, ALocIDs As %String, AFlag As %String = "0") As %String
{
	s ret = "0^质控规则表达式参数配置异常!"
	q:(AEpisodeID = "")||(AStructID = "")||(ATemplateGroups = "") ret
	
	// 强制在规定时间内完成则必须设置起始时间<ADateTime>和时间限制<AHour>
	q:(AFlag = "1")&&((ADateTime = "")||(AHour = "")) ret
	
	// 该质控条目是否与科室关联
	if (ALocIDs '= "")
	{
		// 得到患者当前所在科室
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		if (curAdmitLocID = "")
		{
			s ret = "0^患者当前不属于任何一个科室,质控项目异常退出!"
			q ret	
		}
	
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		if ($listfind(locIDs,curAdmitLocID) = 0)
		{
			s ret = "1^患者当前所在科室没有采用多套组合模板!"
			q ret	
		}
	}
		
	// 质控结构标准名称,用于提示
	s StructName = ..GetQualityStructName(AStructID)
	
	// 判断当前给定的质控结构<AStructID>对患者的当前就诊<AEpisodeID>是否有效
	s flag = ..IsRightCatalog(AEpisodeID,AStructID)
	if (flag < 1)
	{
		s ret = "1^质控结构【"_StructName_"】对当前患者无效!"
		q ret
	}
	
	s ret = "0^质控规则运行时异常退出!"
	
	// 获取多套组合模板的完成情况，返回信息如下格式：状态|已完成组合模板集合(修改过的)|已保存的模板集合
	// FinishedInfo = Y/N|GroupName&CategoryID$TemplateID#CategoryID$TemplateID^GroupName&#CategoryID$TemplateID#|CategoryID^TemplateID^SavedTime$CategoryID^TemplateID^SavedTime，|为主分隔字符
	s FinishedInfo = ..GetMultiCategoryFinishedInfo(AEpisodeID,ATemplateGroups)
	
	// 组合模板完成状态(Y/N)
	s Status = $p(FinishedInfo,"|",1)
	
	// 已完成的组合模板集合
	// FinishedGroups = GroupName&CategoryID$TemplateID#CategoryID$TemplateID#CategoryID$TemplateID^GroupName&#CategoryID$TemplateE#，^为主分隔字符
	s FinishedGroups = $p(FinishedInfo,"|",2)
	
	// 已保存的模板集合
	// SavedTemplates = CategoryID^TemplateID^SavedTime$CategoryID^TemplateID^SavedTime,$为主分隔字符
	s SavedTemplates = $p(FinishedInfo,"|",3)	
	
	s objStruct = $g(^DHCEPRM.QualityStructD(+AStructID))
	s CategoryID = $list(objStruct,5)
	if (CategoryID = "")
	{	
		// 如果配置的是模板目录级别以上质控结构，则只需要根据Status判断
		if ($zcvt(Status,"U") = "N")
		{
			// 获取最有可能写的一套组合模板进行提示
			s MostNecessaryGroup = ..FindMostNecessaryGroup(ATemplateGroups,SavedTemplates)
			s GroupName = $p(MostNecessaryGroup,"&",1)
			s ret = "-1^质控智能检测到您应该优先填写【"_GroupName_"】下的界面模板!"
		}
		else
		{
			if ($length(FinishedGroups,"^") > 1)
			{
				// 完成了多套组合模板，也是不允许的
				s ret = "-1^【"_StructName_"】完成了多套，请清空其中某一套!"
			}
			else
			{
				// 只完成了一套组合模板
				
				// 先判断已保存的模板列表里是不是只有已完成的组合模板
				s OnlyFinishedTemplates = ..ChkAllInSavedTemplates(FinishedGroups, SavedTemplates)
				if ($p(OnlyFinishedTemplates,"|",1) > 0)
				{
					// 只写了该写的模板 	
				 
					// AFlag = 1表示强制要求在规定时间内完成
					if (AFlag = 1)
					{
						// 该套模板组下的所有模板都已经完成，但是否在规定的时间内完成呢？FinishedInTime=0表示在规定的时间内完成，FinishedInTime=1表示不是在规定的时间内完成的
						s FinishedInTime = ..CheckGroupFinishedInTime(FinishedGroups,SavedTemplates,ADateTime,AHour)
						if (FinishedInTime > 0)
						{
							s ret = "-1【"_StructName_"】未在规定的时间内完成!"	 
						}
						else
						{
							s ret = "1【"_StructName_"】已在规定的时间内完成!"		
						}
					}
					else
					{
						s ret = "1^【"_StructName_"】已完成!"
					}
				}
				else
				{
					// OtherTemplates = CategoryID$TemplateID#CategoryID$TemplateID
					s OtherTemplates = $p(OnlyFinishedTemplates,"|",2)
					q:(OtherTemplates = "") ret
					
					s OtherCount = 0, Message = ""
					s lstOtherTemplate = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(OtherTemplates,"#","Y")
					for Ind = 1:1:$listlength(lstOtherTemplate)
					{
						s OtherTemplate = $listget(lstOtherTemplate, Ind)
						continue:(OtherTemplate = "")
						
						s SubCategoryID = $p(OtherTemplate,"$",1)
						s SubTemplateID = $p(OtherTemplate,"$",2)
						
						s SubStructID = $o(^DHCEPRM.QualityStructI("IdxCategoryId"," "_SubCategoryID,""))
						continue:(SubStructID = "")
						
						s SubStructName = ..GetQualityStructName(SubStructID)
						
						s NoNeedGroup = ..GetTemplateGroupByTemplateID(ATemplateGroups, SubTemplateID)
						s GroupName = $p(NoNeedGroup,"&",1)
						
						s TempMessage = "【"_GroupName_"】下的【"_SubStructName_"】目录"
						if (OtherCount > 0)
						{
							s Message = Message_"和"_TempMessage	
						}
						else
						{
							s Message = TempMessage	
						}
						s OtherCount = OtherCount + 1
					}
					s ret = "-1^"_Message
				}
			}	
		}
	}
	else
	{
		// 当前配置的是界面模板目录级别，则分情况考虑
		if ($zcvt(Status,"U") = "N")
		{
			// 智能检测该不该写这个界面模板目录
			s ChkResult = ..IntelligentCheck(CategoryID,ATemplateGroups,SavedTemplates)
			if ($p(ChkResult,"^",1) = 1)			
			{
				//这个界面模板目录有需要写的模板

				s GroupName = $p(ChkResult,"^",2)
				
				//暂时不用，因为模板名字在界面看不出来
				//s MostNecessaryTemplateID = $p(ChkResult,"^",3)	
					
				s flag = "-1^质控智能检测您应该优先填写【"_GroupName_"】下的【"_StructName_"】目录!"	
			}
			else
			{
				s flag = "1^质控智能检测您不需要填写【"_GroupName_"】下的【"_StructName_"】目录!"	
			}			
		}
		else
		{
			if ($length(FinishedGroups,"^") > 1)
			{
				// 写了多套组合模板，不知道这个界面模板目录是不是要写，提示先清空其中某一套
				
				s ParentStructID = $list($g(^DHCEPRM.QualityStructD(AStructID)),2)
				s ParentStructName = ..GetQualityStructName(ParentStructID)
				s ret = "-1^因为【"_ParentStructName_"】完成了多套，请清空其中某一套再作判断!"
			}
			else
			{
				// 只完成了一套，需要判断当前界面模板目录下只允许写了一个界面模板
				
				s Existed = 0, FinishedTemplateID = ""
				s GroupName 	= $p(FinishedGroups,"&",1)
				s CompleteGroup = $p(FinishedGroups,"&",2)
				s lstFinishedGroup = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(CompleteGroup,"#","Y")
				for Ind = 1:1:$listlength(lstFinishedGroup)
				{
					s FinishedGroup = $listget(lstFinishedGroup,Ind)
					
					s FinishedCategoryID = $p(FinishedGroup,"$",1)
					if (FinishedCategoryID = CategoryID)
					{
						s Existed = 1
						s FinishedTemplateID = $p(FinishedGroup,"$",2)
						q	
					}	
				}
				
				if (Existed = 1)
				{
					// 当前界面模板目录下只允许写一个模板
					
					s Count = 0, TemplateID = 0
					s lstSavedTemplates = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(SavedTemplates,"$","Y")
					for i = 1:1:$listlength(lstSavedTemplates)
					{
						s SavedTemplate = $listget(lstSavedTemplates,i)
						continue:(SavedTemplate = "")
						
						if ($p(SavedTemplate,"^",1) = CategoryID)
						{
							s Count = Count + 1	
							s TemplateID = $p(SavedTemplate,"^",2)
						}
					}
					if (Count > 1)
					{
						s flag = "-1^【"_StructName_"】下写了多个模板，请清空不需要的!"
					}
					else
					{
						if (AFlag = "1")
						{
							// 这里判断当前模板是否在规定的时间内完成的
							s FinishedInTime = ..CheckTemplateFinishedInTime(TemplateID,SavedTemplates,ADateTime,AHour)
							if (FinishedInTime > 0)
							{
								s flag = "-1【"_StructName_"】未在规定的时间内完成!"	 
							}
						}
						else
						{
							s flag = "1^【"_StructName_"】已完成!"	
						}
					}
				}
				else
				{
					// 不需要判断当前目录
					s flag = "1^【"_StructName_"】不需要检测，成功退出!"	
				}
			}
		}
		
		if ($p(flag,"^",1) = 1)
		{
			s ret = "1^【"_StructName_"】已完成!"
		}
		else
		{
			s ret = "-1^"_$p(flag,"^",2)
		}	
	}
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	获取给定的模板ID所在的模板组(暂时只取遇到的第一个，如果允许同一个TemplateID在不同的模板组中出现，则需要修改逻辑)
/// Table:			无
/// Input:			ATemplateGroups为配置的成组模板字符串;
/// 				ATemplateID为界面模板RowID;
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).GetTemplateGroupByTemplateID("神外肿瘤&325#310#311|颅脑损伤&329#308#309|伽玛刀&413##","310")
ClassMethod GetTemplateGroupByTemplateID(ATemplateGroups As %String, ATemplateID As %String) As %String
{
	s ret = ""
	q:(ATemplateGroups = "")||(ATemplateID = "") ret
	 
	s lstTemplateGroup = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ATemplateGroups,"|")
	for i = 1:1:$listlength(lstTemplateGroup)
	{
		s GroupInfo = $listget(lstTemplateGroup,i)
		continue:(GroupInfo = "")
		
		s TemplateGroup = $p(GroupInfo,"&",2)
		
		if ($f(TemplateGroup,ATemplateID) > 0)
		{
			s ret = GroupInfo
			q	
		}
	}
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断已完成的一组组合模板是否都在规定的时间内完成;
/// Table:			无
/// Input:			AFinishedGroup为已完成的组合模板,格式为GroupName&CategoryID$TemplateID#CategoryID$TemplateID;
/// 				ASavedTemplates为已保存的模板信息,格式为CategoryID^TemplateID^SavedTime$CategoryID^TemplateID^SavedTime;
/// 				ADateTime为监测日期时间点;
/// 				AHour为规定的有效小时数;
/// Output:			无
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).CheckGroupFinishedIntime()
ClassMethod CheckGroupFinishedInTime(AFinishedGroup As %String, ASavedTemplates As %String, ADateTime As %String, AHour As %String) As %String
{
	q:(AFinishedGroup = "")||(ASavedTemplates = "")||(ADateTime = "")||(AHour = "") "-1"
	
	// 取得已完成的组模板ID字符串
	s FinishedGroup = $p(AFinishedGroup,"&",2)
	
	s ret = 0
	s lstFinishedInfo = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(FinishedGroup,"#")
	for Ind = 1:1:$listlength(lstFinishedInfo)
	{
		s FinishedInfo = $listget(lstFinishedInfo, Ind)
		continue:(FinishedInfo = "")
		
		s FinishedTemplateID = $p(FinishedInfo,"$",2)
		continue:(FinishedTemplateID = "")
		
		s flag = ..CheckTemplateFinishedInTime(FinishedTemplateID,ASavedTemplates,ADateTime,AHour)
		if (flag = 1)
		{
			s ret = 1
			q	
		}
	}
	
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断给定的已完成模板是否在规定的时间内完成;
/// Table:			无
/// Input:			AFinishedTemplateID为已填写的界面模板RowID;
/// 				ASavedTemplates为已保存的模板信息,格式为CategoryID^TemplateID^SavedTime$CategoryID^TemplateID^SavedTime;
/// 				ADateTime为监测日期时间点;
/// 				AHour为规定的有效小时数;
/// Output:			ret=1表示未在规定的时间内完成；ret=0表示在规定的时间内完成
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).CheckTemplateFinishedInTime("","","","")
ClassMethod CheckTemplateFinishedInTime(AFinishedTemplateID As %String, ASavedTemplates As %String, ADateTime As %String, AHour As %String) As %String
{
	// 参数异常
	q:(AFinishedTemplateID = "")||(ASavedTemplates = "")||(ADateTime = "")||(AHour = "") "-2"
	
	// 取值异常
	s ret = -1			
	s flag = ..ExistInSavedTemplates(AFinishedTemplateID,ASavedTemplates)
	q:($p(flag,"^",1) <= 0) ret
	q:($p(flag,"^",1) > 0)&&($p(flag,"^",2) = "") ret
	
	s SavedTime = $p(flag,"^",2)
	s SavedTime = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(SavedTime)

	s GapHours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(SavedTime,ADateTime)
	q:(GapHours < 0) ret
	
	// ret = 0代表在规定的时间内完成
	s ret = 0	
	
	// 超时完成
	s:(GapHours > +AHour) ret = 1
	
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断已保存模板中是不是只有已完成的组合模板组；
/// Table:			无
/// Input:			AFinishedGroup已完成的组合模板组，格式为GroupName&CategoryID$TemplateID#CategoryID$TemplateID#CategoryID$TemplateID；
/// 				ASavedTemplates为给定的多套模板组合中已保存的模板信息，格式为CategoryID^TemplateID^SavedTime$CategoryID^TemplateID^SavedTime；
/// Output:			无
/// Return:			ret = Flag|OtherTemplates Flag= 1只包含已完成的组合模板；Flag = -1表示还写了多余的模板并返回CategoryID$TemplateID^CategoryID$TemplateID组合；
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).ChkAllInSavedTemplates("GroupName&1$2#3$4#5$6","1^2^12345 56754$3^4^12231 23321$5^6^12322 23132$7^8^12312 12143")
ClassMethod ChkAllInSavedTemplates(AFinishedGroup As %String, ASavedTemplates As %String) As %String
{
	s ret = 0
	q:(AFinishedGroup = "")||(ASavedTemplates = "") ret
	
	s FinishedGroup = $p(AFinishedGroup,"&",2)
	
	s lstFinishedInfo = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(FinishedGroup,"#")
	s lstSavedTemplates = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ASavedTemplates,"$")
	
	s ret = 1,OtherTemplates = ""	
	for Ind = 1:1:$listlength(lstSavedTemplates)
	{
		s SavedTemplate = $listget(lstSavedTemplates, Ind)
		continue:(SavedTemplate = "")
		
		s CategoryID = $p(SavedTemplate,"^",1)
		s TemplateID = $p(SavedTemplate,"^",2)
		
		s Composite = CategoryID_"$"_TemplateID
		if ($listfind(lstFinishedInfo,Composite) = 0)
		{
			s ret = -1
			s OtherTemplates = OtherTemplates_$lb(Composite)	
		}
	}
	
	s:(ret = -1) OtherTemplates = ##Class(EPRservice.Quality.CommonHelper).GetListToString(OtherTemplates,"#","Y")
	
	q ret_"|"_OtherTemplates
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	获取多套模板组合完成情况,只要有一套完成即可,但其他套模板不允许写,以免影响自动任务的执行;
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
/// 	  			ATemplateGroups为多套模板组字符串，其格式为GroupNameA&TemplateA#TemplateB#TemplateC|GroupNameB&TemplateD##|GroupNameC&#TemplateE#;
/// 	  			注意：每套模板要求有同样数量的模板,没有就放空,而且要求各套模板的顺序一致;
/// 	  			ACategoryNo为待判定的模板目录的次序；
/// Return:			Status(Y/N)|FinishedGroups(CategoryID$TemplateID#CategoryID$TemplateID#CategoryID$TemplateID^#CategoryID$TemplateID#)|SavedTemplates(CategoryID^TemplateID^SavedTime$CategoryID^TemplateID^SavedTime)
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).IsCategoryGroupFinished("201865","")
ClassMethod GetMultiCategoryFinishedInfo(AEpisodeID As %String, ATemplateGroups As %String) As %String
{
	s ret = "N"
	q:(AEpisodeID = "")||(ATemplateGroups = "") ret
	
	s UniqueKey = $i(^CacheTemp)
	k ^CacheTemp("DHCEPRQualityRTC",UniqueKey)
	
	s FinishedCount = 0, FinishedGroups = ""
	s lstTemplateGroup = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ATemplateGroups,"|")
	for i = 1:1:$listlength(lstTemplateGroup)
	{
		s TemplateGroup = $listget(lstTemplateGroup,i)
		continue:(TemplateGroup = "")
		
		// CurrentGroupInfo = Y(/N)|GroupName&CategoryID$TemplateID#CategoryID$TemplateID#CategoryID$TemplateID
		s CurrentGroupInfo = ..CheckOneGroupFinished(AEpisodeID,TemplateGroup,UniqueKey)
		if ($zcvt($p(CurrentGroupInfo,"|",1),"U") = "Y") 
		{
			s FinishedCount = FinishedCount + 1
			s FinishedGroups = FinishedGroups_$lb($p(CurrentGroupInfo,"|",2))
		}
	}
	
	if (FinishedCount >= 1)
	{
		s ret = "Y"
		s FinishedGroups =  ##Class(EPRservice.Quality.CommonHelper).GetListToString(FinishedGroups,"^")
	}
	
	// 取多套模板组字符串中所有已保存的模板信息
	// SavedTemplate = CategoryID^TemplateID^SavedTime$CategoryID^TemplateID^SavedTime
	s SavedTemplates = ..GetSavedTemplates(AEpisodeID,UniqueKey)
	
	s ret = ret_"|"_FinishedGroups_"|"_SavedTemplates
	
	k ^CacheTemp("DHCEPRQualityRTC",UniqueKey)
	
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断成组模板是否完成,只要有一个模板未完成,那么成组模板就算未完成并记录各模板完成状态;
/// Table:			无
/// Input:			AEpisodeID为就诊号；
/// 	  			ATemplateGroup为制定的一组模板字符串（GroupNameA&TemplateA#TemplateB#TemplateC）
/// Output:			1)组模板是否完成（Y/N）|完成的组模板字符串（CategoryID$TemplateID#CategoryID$TemplateID#CategoryID$TemplateID）；
/// 	  			2)将组模板字符串中的所有模板信息写入临时Global,^CacheTemp("DHCEPRQualityRTC",AEpisodeID,CategoryID,TemplateID)=Status_"^"_ModifyDate_"^"_ModifyTime	
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).CheckGroupFinished("201865","704#705#")
ClassMethod CheckOneGroupFinished(AEpisodeID As %String, ATemplateGroup As %String, AUniqueKey As %String) As %String
{
	s ret = "N"
	q:(AEpisodeID = "")||(ATemplateGroup = "")||(AUniqueKey = "") ret
	
	s flag = 1, GroupInfo = ""
	
	s GroupName 	= $p(ATemplateGroup,"&",1)
	s TemplateGroup = $p(ATemplateGroup,"&",2)
	
	s lstTemplates = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(TemplateGroup,"#")
	for i = 1:1:$listlength(lstTemplates)
	{
		s TemplateID = $list(lstTemplates,i)
		if (TemplateID = "")
		{
			s GroupInfo = GroupInfo_$lb("")
			continue:(TemplateID = "")	
		}
		
		s CategoryID = $list($g(^DHCEPRM.TemplateD(TemplateID)),7)
		continue:(CategoryID = "")
		
		// TemplateInfo = TemplateID_"^"_Status_"^"_ModifyDate_"^"_ModifyTime
		s TemplateInfo = ..GetAssignedTemplateInfo(AEpisodeID,CategoryID,TemplateID)
		
		s Status 	 = $p(TemplateInfo,"^",2)
		s ModifyDate = $p(TemplateInfo,"^",3)
		s ModifyTime = $p(TemplateInfo,"^",4)
		s:(Status = "") Status = "UnSave"
		s:(Status = "UnSave") flag = 0
		
		s GroupInfo = GroupInfo_$lb(CategoryID_"$"_TemplateID)
		
		s ^CacheTemp("DHCEPRQualityRTC",AUniqueKey,AEpisodeID,CategoryID,TemplateID) = Status_"^"_ModifyDate_"^"_ModifyTime
	}
	
	if (flag = 1)
	{
		s GroupInfo = ##Class(EPRservice.Quality.CommonHelper).GetListToString(GroupInfo,"#","N","Y")
		
		s FinishedInfo = GroupName_"&"_GroupInfo
				
		s ret = "Y|"_FinishedInfo	
	}
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	获取成组模板中已完成的模板信息
/// Input:			AEpisodeID为患者就诊号;
/// Output:			无
/// Return:			CategoryID^TemplateID^SavedTime$CategoryID^TemplateID^SavedTime
ClassMethod GetSavedTemplates(AEpisodeID As %String, AUniqueKey As %String) As %String
{
	s ret = ""
	q:(AEpisodeID = "")||(AUniqueKey = "") ret
	
	s CategoryID = 0
	for {
		s CategoryID = $o(^CacheTemp("DHCEPRQualityRTC",AUniqueKey,AEpisodeID,CategoryID))
		q:(CategoryID = "")
		
		s TemplateID = ""
		for {
			s TemplateID = $o(^CacheTemp("DHCEPRQualityRTC",AUniqueKey,AEpisodeID,CategoryID,TemplateID))
			q:(TemplateID = "")
			
			s TemplateInfo = $g(^CacheTemp("DHCEPRQualityRTC",AUniqueKey,AEpisodeID,CategoryID,TemplateID))
			
			s Status 	 = $p(TemplateInfo,"^",1)
			s ModifyDate = $p(TemplateInfo,"^",2)
			s ModifyTime = $p(TemplateInfo,"^",3)
			
			if ($zcvt(Status,"U") = "SAVE")
			{
				s SavedTime = ModifyDate_" "_ModifyTime
				s ret = ret_$lb(CategoryID_"^"_TemplateID_"^"_SavedTime)	
			}
		}	
	}
	
	s ret = ##Class(EPRservice.Quality.CommonHelper).GetListToString(ret,"$","Y")
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	根据AEpisodeID和界面模板ID取模板的保存状态以及保存时间;
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
/// 				ACategoryID为界面模板目录RowID;
/// 				ATemplateID为界面模板RowID;
/// Return:			TemplateID_"^"_Status_"^"_ModifyDate_"^"_ModifyTime
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).GetAssignedTemplateInfo("201865","533","704")
ClassMethod GetAssignedTemplateInfo(AEpisodeID As %String, ACategoryID As %String, ATemplateID As %String) As %String
{
	s ret = "^^^"
	q:(($d(AEpisodeID) = 0)||($d(ACategoryID) = 0)||($d(ATemplateID) = 0)) ret
	q:(AEpisodeID = "")||(ACategoryID = "")||(ATemplateID = "") ret
	
	s ECRecordID = ""
	for {
		s ECRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_AEpisodeID," "_ACategoryID,ECRecordID))
		q:(ECRecordID = "")
		
		s ChildSub = ""
		for {
			s ChildSub = $o(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID,ChildSub))
			q:(ChildSub = "")
			
			s InstanceID = ECRecordID_"||"_ChildSub
			s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(InstanceID)
			continue:(objInstance = "") 
			
			if (objInstance.GroupItemID = ACategoryID)
			{
				s TemplateID = objInstance.TemplateID
				continue:(TemplateID '= ATemplateID)
				
				s ModifyDate = objInstance.ModifyDate
				s ModifyTime = objInstance.ModifyTime
				s ModifyUser = objInstance.ModifyUser
				s Status 	 = objInstance.Status
				
				s ret = TemplateID_"^"_Status_"^"_ModifyDate_"^"_ModifyTime
				q
			}
		}
	}
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	当一套模板目录都没有写的时候需要做智能检测,算法是从先找出已写模板最多的那个目录开始做检查;
/// Table:			无
/// Input:			ACategoryID为界面模板目录RowID;
/// 				ATemplateGroups格式为GroupNameA&TemplateA#TemplateB#TemplateC|GroupNameB&TemplateD##|GroupNameC&#TemplateE#,"|"为主分隔字符;
/// 				ASavedTemplates格式为CategoryID^TemplateID^SavedTime$CategoryID^TemplateID^SavedTime,"$"为主分隔字符;
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).IntelligenteCheck("","","")	
ClassMethod IntelligentCheck(ACategoryID As %String, ATemplateGroups As %String, ASavedTemplates As %String) As %String
{
	s ret = 0
	q:(ACategoryID = "")||(ATemplateGroups = "")||(ASavedTemplates = "") ret
	
	// MostNecessaryGroup = GroupName&TemplateA#TemplateB#TemplateC
	s MostNecessaryGroup = ..FindMostNecessaryGroup(ATemplateGroups,ASavedTemplates)
	q:(MostNecessaryGroup = "") ret
	
	s Existed = 0, MostNecessaryTemplateID = 0
	s NecessaryGroup = $p(MostNecessaryGroup, "&",2)
	s lstTemplates = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(NecessaryGroup,"#","Y")
	for i = 1:1:$listlength(lstTemplates)
	{
		s TemplateID = $listget(lstTemplates, i)
		continue:(TemplateID = "")
		
		s CategoryID = $list($g(^DHCEPRM.TemplateD(+TemplateID)),7)
		continue:(CategoryID = "")
		
		if (CategoryID = ACategoryID)
		{
			s Existed = 1
			s MostNecessaryTemplateID = TemplateID
			q	
		}
	}
	
	if (Existed = 0)
	{
		s ret = -1	
	}
	else
	{
		s GroupName = $p(MostNecessaryGroup,"&",1)
		s ret = 1_"^"_GroupName_"^"_MostNecessaryTemplateID	
	}
	
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	 找到最应该写的那一套模板组合，根据已写模板所在组的比例，比例最大的最应该写。如果一个模板都没有写，则返回第一组作为改写的模板
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).FindMostNecessaryGroup("通用1&1#2#3#4|通用2&5#6#7#|通用3&#8#9#","11^1$88^2$67^3$89^5$90^6$77^7$99^8")
ClassMethod FindMostNecessaryGroup(ATemplateGroups As %String, ASavedTemplates As %String) As %String
{
	s ret = ""
	q:(ATemplateGroups = "") ret
	q:(ASavedTemplates = "") $p(ATemplateGroups,"|",1)
	
	s UniqueKey = $i(^CacheTemp)
	k ^CacheTemp("EPRQualityRTS","NecessaryGroup",UniqueKey)
		
	s lstTemplateGroup = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ATemplateGroups,"|","Y")
	for i = 1:1:$listlength(lstTemplateGroup)
	{
		s TemplateGroup = $listget(lstTemplateGroup,i)
		continue:(TemplateGroup = "")

		s ChkGroupName 	   = $p(TemplateGroup,"&",1)
		s ChkTemplateGroup = $p(TemplateGroup,"&",2)

		s lstTempaltes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ChkTemplateGroup,"#","Y")
		s Count = $listlength(lstTempaltes)
		for j = 1:1:Count
		{
			s TemplateID = $listget(lstTempaltes,j)
			continue:(TemplateID = "")
			
			s Existed = ..ExistInSavedTemplates(TemplateID,ASavedTemplates)			
			if ($p(Existed,"^",1) > 0)
			{
				s Rate = $j(1/Count,2,2)
				s ^CacheTemp("EPRQualityRTS","NecessaryGroup",UniqueKey,TemplateGroup) = +$g(^CacheTemp("EPRQualityRTS","NecessaryGroup",UniqueKey,TemplateGroup)) + Rate
			}
		}
	}

	s MaxRate = 0
	s MostNecessartGroup = ""
	for {
		s MostNecessartGroup = $o(^CacheTemp("EPRQualityRTS","NecessaryGroup",UniqueKey,MostNecessartGroup))
		q:(MostNecessartGroup = "")
				
		s Current = $g(^CacheTemp("EPRQualityRTS","NecessaryGroup",UniqueKey,MostNecessartGroup))
		if (Current > MaxRate)
		{
			s MaxRate = Current	
			s ret = MostNecessartGroup
		}
	}
	
	k ^CacheTemp("EPRQualityRTS","NecessaryGroup",UniqueKey)
	
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断给点的模板<ATemplateID>是否已经保存并返回保存时间
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).ExistInSavedTemplates(2,"88^2^61453 23456$89^5^62341 12354")
ClassMethod ExistInSavedTemplates(ATemplateID As %String, ASavedTemplates As %String) As %String
{
	s existed = -1
	q:(ATemplateID = "")||(ASavedTemplates = "") existed
	
	s savedTime = ""
	s lstSavedTemplate = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ASavedTemplates,"$","Y")
	for ind = 1:1:$listlength(lstSavedTemplate)
	{
		s savedTemplate = $listget(lstSavedTemplate,ind)
		continue:(savedTemplate = "")
		
		s categoryID = $p(savedTemplate,"^",1)
		s templateID = $p(savedTemplate,"^",2)
		s savedTime  = $p(savedTemplate,"^",3)
		
		if (templateID = ATemplateID)
		{
			s existed = 1
			q	
		}
	}
	s:(existed = 1) existed = existed_"^"_savedTime
	q existed
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	配置多套模板目录时判断是否需要填写某个界面模板目录;
/// Table:			无
/// Input:			AEpsidoeID为患者就诊号;
/// 				AStructID为质控结构RowID;
/// 				ATemplateGroups为多套模板组字符串，其格式为GroupNameA&TemplateA#TemplateB#TemplateC|GroupNameB&TemplateD##|GroupNameC&#TemplateE#，
/// 	 			每套模板要求有同样数量的模板，没有就放空，而且要求各套模板的顺序一致；
/// Output:			无
/// Return:			ret=1是要监测;否则不监测;
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).IsNeedCheckCategory("","","")
ClassMethod IsNeedCheckCategory(AEpisodeID As %String, AStructID As %String, ATemplateGroups As %String, ALocIDs As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AStructID = "")||(ATemplateGroups = "") ret
	
	// 该质控条目是否与科室关联
	if (ALocIDs '= "")
	{
		// 得到患者当前所在科室
		s currentAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)
		if (currentAdmitLocID = "")
		{
			//s ret = "0^患者当前不属于任何一个科室，质控项目异常退出!"
			s ret = 0
			q ret	
		}
	
		s lstLocIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		if ($listfind(lstLocIDs,currentAdmitLocID) = 0)
		{
			//s ret = "0^患者当前所在科室没有采用多套组合模板，所以不检查!"
			s ret = 0
			q ret	
		}
	}	
	
	//finishedInfo = Status(Y/N)|FinishedGroups(CategoryID$TemplateID#CategoryID$TemplateID#CategoryID$TemplateID^#CategoryID$TemplateID#)|SavedTemplates(CategoryID^TemplateID^SavedTime$CategoryID^TemplateID^SavedTime)
	s finishedInfo = ..GetMultiCategoryFinishedInfo(AEpisodeID,ATemplateGroups)
	
	s status 		 = $p(finishedInfo,"|",1)
	s finishedGroups = $p(finishedInfo,"|",2)
	s savedTemplates = $p(finishedInfo,"|",3)
	
	s objStruct = $g(^DHCEPRM.QualityStructD(AStructID))
	s categoryID = $list(objStruct,5)
	
	s flag = ..IntelligentCheck(categoryID,ATemplateGroups,savedTemplates)	
	
	// ret = 1说明该质控结构下的界面模板目录需要检测
	s ret = $p(flag,"^",1)
	
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断某界面模板目录是否有必要写;
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
/// 				AStructID为质控结构RowID;
/// 				APrtCatChapterIDs为EPRmeta.EPRTemplateCategory表中CategoryType为CategoryChapter的RowID字符串,多个以"#"分隔;
/// Output:			无
/// Return:			ret=1表示要写;
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).ChkTemplateCagtegoryNeedWrite(201869,92,"2#142")
ClassMethod ChkTemplateCagtegoryNeedWrite(AEpisodeID As %String, AStructID As %String, APrtCatChapterIDs As %String) As %Integer
{
	s ret = -1
	q:(AEpisodeID = "")||(AStructID = "")||(APrtCatChapterIDs = "") ret

	// 只有质控结构上为界面模板目录的节点才能关联此检查条件
	s templateCategoryID = $list($g(^DHCEPRM.QualityStructD(AStructID)),5)
	q:(templateCategoryID = "") ret
	
	// 先根据APrtCategoryIDs找到所有的打印模板集合，然后确定该写哪个打印模板
	s needPrtTemplateDocID = ""
	
	if ($l(APrtCatChapterIDs,"#") > 1)
	{
		s needPrtTemplateDocID = ..ProcessMultiChapters(AEpisodeID,APrtCatChapterIDs)
	}
	else
	{
		s needPrtTemplateDocID = ..ProcessSingleChapter(AEpisodeID,APrtCatChapterIDs)	
	}

	// 找到最该写的PrtTemplateDocID为needPrtTemplateDocID，然后确定该写这些打印模板集合下的哪个模板
	s ret = ..IsNeedWriteTemplate(AEpisodeID,templateCategoryID,needPrtTemplateDocID) 
	
	q ret
}

ClassMethod ProcessMultiChapters(AEpisodeID As %String, APrtCatChapterIDs As %String) As %String
{
	s needPrtTemplateDocID = ""
	
	s UniqueKey = $i(^CacheTemp)
	k ^CacheTemp("EPRQuality","ChkTemplateNeedWrite",UniqueKey)
	
	s lstPrtCatChapterIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(APrtCatChapterIDs,"#","Y")
	for i = 1:1:$listlength(lstPrtCatChapterIDs)
	{
		s prtCatChapterDocID = $listget(lstPrtCatChapterIDs,i)
		continue:(prtCatChapterDocID = "")
		
		s j = 0		
		s prtTemplateDocID = ""
		for {
			s prtTemplateDocID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID"," "_prtCatChapterDocID,prtTemplateDocID))
			q:(prtTemplateDocID = "")

			// 首先将第一个挂载打印模板设置为默认该写的
			s:(i = 1)&&(j = 0) needPrtTemplateDocID = prtTemplateDocID
			
			s j = j + 1
						
			s finishedInfo = ..GetFinishedProgress(AEpisodeID,prtTemplateDocID)
			s finishedCount = $p(finishedInfo,"^",1)
			s allCount = $p(finishedInfo,"^",2)
			s rate = $j(finishedCount/allCount,2,3)
			s ^CacheTemp("EPRQuality","ChkTemplateNeedWrite",UniqueKey,prtTemplateDocID) = rate
		}	
	}
	
	s maxRate = 0
	s tmpPrtTemplateDocID = ""
	for {
		s tmpPrtTemplateDocID = $o(^CacheTemp("EPRQuality","ChkTemplateNeedWrite",UniqueKey,tmpPrtTemplateDocID))
		q:(tmpPrtTemplateDocID = "")
		
		s rate = $g(^CacheTemp("EPRQuality","ChkTemplateNeedWrite",UniqueKey,tmpPrtTemplateDocID))
		if (rate > maxRate) 
		{
			s maxRate = rate
			s needPrtTemplateDocID = tmpPrtTemplateDocID
		}	
	}
	
	k ^CacheTemp("EPRQuality","ChkTemplateNeedWrite",UniqueKey)
	
	q needPrtTemplateDocID
}

ClassMethod ProcessSingleChapter(AEpisodeID As %String, APrtCatChapterIDs As %String) As %String
{
	s priActivity = ##Class(EPRservice.DocRestLogic.PrivLogic).CheckTPrivActivity()
	s curPatientInfo = ##Class(EPRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID)
	s needPrtTemplateDocID = ##Class(EPRservice.DocRestLogic.PrivLogic).GetDocIDForView(AEpisodeID, "", APrtCatChapterIDs, priActivity, curPatientInfo)
	q needPrtTemplateDocID
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断某患者某挂载打印模板下的界面模板完成情况;
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
/// 				APrtTemplateDocID为挂载打印模板ID;
/// Output:			无
/// Return:			FinishedCount_"^"_AllCount
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).GetFinishedProgress(201764,3)
ClassMethod GetFinishedProgress(AEpisodeID As %String, APrtTemplateDocID As %String) As %Integer
{
	s ret = 0
	q:(AEpisodeID = "")||(APrtTemplateDocID = "") ret
	
	s patientID = $p(^PAADM(AEpisodeID),"^",1)
	
	s empty = ""
	s (finishedCount, allCount) = 0
	s templateDocID = ""
	for {
		s templateDocID = $o(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID"," "_APrtTemplateDocID,templateDocID))
		q:(templateDocID = "")

		// 是否必填界面模板
		s isNecessaryTemplate = $list($g(^DHCEPRM.EPRTemplateD(templateDocID)),4)
		continue:(+isNecessaryTemplate = 0) 
		
		// 获取关联的界面模板ID
		s templateID = $list($g(^DHCEPRM.EPRTemplateD(templateDocID)),12)
		
		// 获取关联的界面模板规则ID
		s privRuleID = $list($g(^DHCEPRM.EPRTemplateD(templateDocID)),14)
		
		// 获取关联的界面模板目录ID
		s categoryID = $list($g(^DHCEPRM.TemplateD(templateID)),7)

		s privString = "userid^"_empty_"!admid^"_AEpisodeID_"!patientid^"_patientID_"!userloc^"_empty_"!templateid^"_templateID_"!ssgroupid^"_empty_"!categoryid^"_categoryID_"!docid^"_empty_"!isnewframework^1!eprnum^"_1
		s privRule = ##Class(EPRservice.Privilege.BOPrivRule).ParsePrivRuleByID(privRuleID,privString)
		
		// load是规则检查约定返回值变量
		continue:(privRule.GetAt("load") = "0")
		
		//必填界面模板数量		
		s allCount = allCount + 1
		
		// TemplateInfo = TemplateID_"^"_Status_"^"_ModifyDate_"^"_ModifyTime
		s templateInfo = ..GetAssignedTemplateInfo(AEpisodeID,categoryID,templateID)
		
		s status = $p(templateInfo,"^",2)
		s:(status = "") status = "UnSave"
		
		s:($zcvt(status,"U") = "SAVE") finishedCount = finishedCount + 1
	}
	
	s ret = finishedCount_"^"_allCount
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreateDate:		2010-05-05
/// Description:	判断某患者是否应该写某挂载打印模板下的某界面模板目录
/// Table:			无
/// Input:			AEpisodeID为患者就诊号;
/// 				ATemplateCategoryID为界面模板目录ID;
/// 				APrtTemplateDocID为挂载打印模板ID;
/// Output:			无
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).IsNeedWriteTemplate(201764,537,3)
ClassMethod IsNeedWriteTemplate(AEpisodeID As %String, ATemplateCategoryID As %String, APrtTemplateDocID As %String) As %Integer
{
	s ret = 0
	q:(AEpisodeID = "")||(ATemplateCategoryID = "")||(APrtTemplateDocID = "") ret
	
	s empty = ""
	s patientID = $p(^PAADM(AEpisodeID),"^",1)

	s templateDocID = ""
	for {
		s templateDocID = $o(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID"," "_APrtTemplateDocID,templateDocID))
		q:(templateDocID = "")
		
		// 获取关联的界面模板ID
		s templateID = $list($g(^DHCEPRM.EPRTemplateD(templateDocID)),12)
		
		// 根据界面模板ID获取对应的界面模板目录ID
		s categoryID = $list($g(^DHCEPRM.TemplateD(templateID)),7)
		continue:(categoryID '= $g(ATemplateCategoryID)) 
		
		// 是否必填界面模板
		s isNecessaryTemplate = $list($g(^DHCEPRM.EPRTemplateD(templateDocID)),4)
		if (+isNecessaryTemplate = 0)
		{
			s ret = -1
			q	
		} 
		
		// 获取关联的界面模板规则ID
		s privRuleID = $list($g(^DHCEPRM.EPRTemplateD(templateDocID)),14)
		if (privRuleID = "")||(privRuleID = $c(0))
		{	
			s load = 1
		}
		else
		{
			s privString = "userid^"_empty_"!admid^"_AEpisodeID_"!patientid^"_patientID_"!userloc^"_empty_"!templateid^"_templateID_"!ssgroupid^"_empty_"!categoryid^"_categoryID_"!docid^"_empty_"!isnewframework^1!eprnum^"_1
			s privRule = ##Class(EPRservice.Privilege.BOPrivRule).ParsePrivRuleByID(privRuleID,privString)
			s load = privRule.GetAt("load")
		}
		
		if (load = 1)
		{
			s ret = 1
			q	
		}
	}
	q ret
}

/// CreateDate: 	2012-05-24
/// CreateUser: 	wangwnetao ZSDXFSDSYY
/// Desc: 			唯一模板通过病历日志获取第一个操作的日期时间
/// Table:			/
/// Input:			AEpisodeID为就诊号; 
/// 					ADocID为病历展现结构DOCID; 
/// 					AEPRNum为顺序号; 
/// 					AFinalStatus为Log的状态 取值范围 { unfinished,finished(默认值),commited,attendingChecked,chiefChecked,archieved }
/// Output:			无
/// Others: w ##Class(EPRservice.Quality.CheckRule.Category).GetFirstDateTimeByEPRLog()
ClassMethod GetFirstDateTimeByEPRLog(AEpisodeID As %String, ADocID As %String, AEPRNum As %String = "1", AFinalStatus As %String = "finished") As %String
{
	s ret = ""
	
	q:(AEpisodeID = "")||(ADocID = "") ret
	
	s eprLogs = ##class(EPRinstance.EPRLogs).GetCurrLog(AEpisodeID,ADocID,AEPRNum)
	q:(eprLogs="") ret
	
	s FirstLogByFinalStatus = eprLogs.GetFirstLogByFinalStatus(AFinalStatus)
	q:(FirstLogByFinalStatus="") ret
	
	s FirstOperateDate = $ZD(FirstLogByFinalStatus.OperateDate, 3)
	s FirstOperateTime = $ZT(FirstLogByFinalStatus.OperateTime, 1)
	
	s ret = FirstOperateDate_" "_FirstOperateTime
  	
	q ret
}

/// Creator:		wangwentao
/// CreateDate:		2012-03-13
/// Description:	判断入院记录是否完成(病历展现结构是唯一CategoryChapter模式);
/// Table:			无
/// Input:			AEpisodeID; 
/// 					AStructID
/// 					ACategoryChapter
/// 					ADateTime
/// 					AHours
/// 					AForcedCtlFlag
/// 					ACompareStructs为参考质控结构RowID字符串(多个以"#"分隔),如果其中有一个等效病历已经完成，则忽略当前病历是否完成的检查。
/// 					ACheckType  取值范围{ CheckDisch,CheckAdmit,CheckPrompt } 
/// Output:			无
/// Others:			w ##Class(EPRservice.Quality.CheckRule.Category).IsCategoryChapterFinished(1629926,125,102,"2012-03-13 00:00:00",24,1)
ClassMethod IsCategoryChapterFinished(AEpisodeID As %String, AStructID As %String, ACategoryChapter As %String, ADateTime As %String, AHours As %String, ACompareStructs As %String = "", ACheckType As %String = "CheckPrompt", AForcedRefFlag As %String = "1", ATimeoutCtlFlag As %String = "0") As %String
{
	//b "s"
	
	s ret = "0^质控规则表达式参数配置异常!"
	q:(AEpisodeID = "")||(AStructID = "")||(ACategoryChapter = "") ret
	
	// 强制显示参考提示信息 起始时间<ADateTime>和时间限制<AHour>
	q:(AForcedRefFlag = "1")&&((ADateTime = "")||(AHours = "")) ret
	
	// 如果AStructID为界面模板目录级,则不适用些方法
	s BindCategoryId = $lg($g(^DHCEPRM.QualityStructD(+AStructID)),5)
	q:(BindCategoryId'="")&&(BindCategoryId'=$c(0)) ret 
	
	s ret = "1"
	
	// 质控结构标准名称,用于提示
	s StructName = ..GetQualityStructName(AStructID)
	
	// 判断当前给定的质控结构<AStructID>对患者的当前就诊<AEpisodeID>是否有效
	s flag = ..IsRightCatalog(AEpisodeID,AStructID)
	if (+flag < 1)
	{
		s ret = "1^质控结构【"_StructName_"】对当前患者无效!"
		q ret
	}
	
	
	s ret = "2"
		
	//如果等效病历已经完成，则忽略当前病历是否完成。例如24小时出院的病人，写了24小时入出院记录 则 忽略入院记录的判断
	if (ACompareStructs '= "")
	{
		s finish = 0
		s CompareStructs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ACompareStructs,"#","Y")
		for Ind = 1:1:$listlength(CompareStructs)
		{
			s CompareStruct = $listget(CompareStructs,Ind)
			continue:(CompareStruct = "")
			
			// 判断当前给定的质控结构<CompareStruct>对患者的当前就诊<AEpisodeID>是否有效
			s flag = ..IsRightCatalog(AEpisodeID,CompareStruct)
			continue:(+flag < 1)
			
			s flag = ..IsSaveContent1(AEpisodeID,CompareStruct,ADateTime,AHours)
			continue:(+flag < 1)

			s finish = 1
					
			q	
		}
		q:(finish = 1) ret
	}

	
	s ret = "3"
	
	// 获取AEpisodeID应该完成的病历的DocID,通过模板权限,关于转科问题程序已处理。
	s CurrentDocID = ..ProcessSingleChapter(AEpisodeID,ACategoryChapter)
	
	if (CurrentDocID'="")
	{
		//判断AEpisodeID挂载打印模板下的界面模板完成情况;
		//FinishedInfo Return：finishedCount_"^"_allCount
		s FinishedInfo = ..GetFinishedProgress(AEpisodeID,CurrentDocID)
		s FinishedCount = $p(FinishedInfo,"^",1)
		s AllCount = $p(FinishedInfo,"^",2)
		//s IsSavedFlag = $j(FinishedCount/AllCount,0,2)
		s IsSavedFlag = $s(AllCount'=0:$j(FinishedCount/AllCount,0,2),1:0)
	}
	else
	{
		s IsSavedFlag = 0
	}
	
	s CurrentTime = $zdt($h,3,1)		// Format: 2010-06-17 09:38

	s ret = "4"
	
	//用于提示列表
	if (ACheckType="CheckPrompt")
	{
		s ret = ##Class(EPRservice.Quality.CommonHelper).GetQualityPromptByCheckType(StructName,CurrentTime,ADateTime,AHours,IsSavedFlag,ACheckType,AForcedRefFlag,ATimeoutCtlFlag)
	}
	//用于自动任务
	elseif (ACheckType="CheckDisch")||(ACheckType="CheckAdmit")
	{
		//从操作日志获取病历完成时间 Format: 2011-11-03 17:28:34 如为空,则病历完全否写.
		s IsDocSavedDateTime = ..GetFirstDateTimeByEPRLog(AEpisodeID,CurrentDocID)
		s IsDocSavedFlag = 1
		s:(IsDocSavedDateTime = "") IsDocSavedDateTime = CurrentTime,IsDocSavedFlag = 0

		s ret = ##Class(EPRservice.Quality.CommonHelper).GetQualityPromptByCheckType(StructName,IsDocSavedDateTime,ADateTime,AHours,IsDocSavedFlag,ACheckType,AForcedRefFlag,ATimeoutCtlFlag)
	}
	

	q ret
}

}
