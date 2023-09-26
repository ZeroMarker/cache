/// 李欣 20180905
/// 映射管理相关业务依赖类方法
/// User.MKBMappingRely
Class web.DHCBL.MKB.MKBMappingRely Extends %RegisteredObject
{

/// 李欣 20180905
/// User.MKBMappingSortRely保存方法
/// base:MappingBase类ID value:诊断表达式 mdid:MappingDetail类ID
ClassMethod SaveData(base, value, mdid)
{
	s result=""
	if (value["-")
	{
		s termid=$P(value,"-",1)
		s exp=$P(value,"-",2)
	}
	else
	{
		s termid=value
		s exp=""	
	}
	s obj = ##class(User.MKBMappingRely).%New()
	d obj.MKBMRMBIdSetObjectId(base)
	d obj.MKBMRMDIdSetObjectId(mdid)
	d obj.MKBMRTermDrSetObjectId(termid)
	s obj.MKBMRSortValue = exp
	s sc = obj.%Save()
	if $$$ERROR(sc)
	{
		s result = ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

ClassMethod DeleteData(base, value, mdid)
{
	if (value["-")
	{
		s TermId=$P(value,"-",1)
		s Exp=$P(value,"-",2)	
	}
	else
	{
		s TermId=value
		s Exp=-100000000000000	
	}
	s MKBMRRowId = $O(^User.MKBMappingRelyI("AllIndex",base,TermId,Exp,mdid,0))	
	d ##class(User.MKBMappingRely).%DeleteId(MKBMRRowId)
}

/// d ##class(web.DHCBL.MKB.MKBMappingRely).RegenerateAll()
ClassMethod RegenerateAll()
{
	k ^User.MKBMappingRelyD
	k ^User.MKBMappingRelyI
	k ^User.MKBMappingRelyC
	s MKBKLMBRowId=0
	for
	{
		s MKBKLMBRowId=$O(^User.MKBKLMappingBaseD(MKBKLMBRowId))
		q:MKBKLMBRowId=""
		
		s MKBKLMFChild=0
		for
		{
			s MKBKLMFChild=$O(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",MKBKLMFChild))
			q:MKBKLMFChild=""
			
			s FieldConfig=$LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",MKBKLMFChild)),5)
			continue:FieldConfig'="Exp"	
			
			s RowNum=0
			for
			{
				s RowNum=$O(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowId,RowNum))
				q:RowNum=""
				
				s MKBKLMDRowId=0
				for
				{
					s MKBKLMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBKLMBRowId_"||"_MKBKLMFChild,MKBKLMDRowId))
					q:MKBKLMDRowId=""
					
					s val = $LG($G(^User.MKBKLMappingDetailD(MKBKLMDRowId)),2)
					continue:val=""
					d ##class(web.DHCBL.MKB.MKBMappingRely).SaveData(MKBKLMBRowId,val,MKBKLMDRowId)
				}
			}
		}
	}
}

}
