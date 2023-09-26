/// Desc:诊断列表及录入接口类
/// Creator:李欣
Class web.DHCBL.MKB.MKBSDSInterface Extends %RegisteredObject
{

/// Creator:李欣
/// CreateDate:20180709
/// Desc:判断当前科室常用诊断列表内是否存在此诊断,存在：Y	不存在：N
/// Other:w ##class(web.DHCBL.MKB.MKBSDSInterface).IsLocTermExist(15,14870)
ClassMethod IsLocTermExist(LocId, TermId)
{
	
	q:(TermId="")||(LocId="") ""
	s ProId = $O(^User.MKBTermPropertyI("DescIndex",TermId," 相关科室",0))
	if (ProId="")
	{
		q "N"	
	}
	else
	{
		s DetailId = 0
		for
		{
			s DetailId = $O(^User.MKBTermProDetailI("ProIdx",ProId,DetailId))
			q:DetailId=""
			
			s DetailDesc = $LG($G(^User.MKBTermProDetailD(DetailId)),3)
			s a(DetailDesc)=""	
		}
	}
	s Flag="N"  //是否有该科室属性
	s DepId = 0
	for
	{
		s DepId = $O(^User.MKBLocContrastI("LocIndex",LocId,DepId))
		q:DepId=""
		
		if ($D(a(DepId))'=0)
		{
			s Flag="Y"	
		}	
	}
	if (Flag="Y")
	{
		q "Y"	
	}
	q "N"
}

/// Creator:李欣
/// CreateDate:20180718
/// Desc:把血液内科的诊断放在临时global里
/// Other:w ##class(web.DHCBL.MKB.MKBSDSInterface).SetXYNKDiaGlobal()
ClassMethod SetXYNKDiaGlobal()
{
	s baseId=##class(web.DHCBL.MKB.MKBTermProDetail).GetBaseIDByFlag("Diagnose")
	q:baseId="" 0
	
	s MKBTRowId = 0	
	for
	{
		s MKBTRowId = $O(^User.MKBTermI("BaseIndex",baseId,MKBTRowId))
		q:MKBTRowId=""
		

		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 相关科室",0))

		continue:MKBTPRowId=""
		
		s result = ""
		s MKBTPDRowId = 0
		for
		{
			s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
			q:MKBTPDRowId=""
			
			s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
			s:MKBTPDDesc'="" MKBTPDDesc = $LG($G(^User.MKBTermD(MKBTPDDesc)),3)
			if (MKBTPDDesc="血液内科")
			{
				s result="Y"
				q
			}	
		}	
		if (result="Y")
		{
			
			s ^TMP("MKB","XYNKDIA",MKBTRowId)=""	
		}
	}
	q 1
}

}
