/// 名称:	EMRservice.BL.BLUserTemplateDisease
/// 描述：		科室模板病种BL层
/// 编写者：	yejian
/// 编写时间：	2019-7-31
Class EMRservice.BL.BLUserTemplateDisease Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator: yejian
/// CreatDate: 2019-8-1
/// Description：获取科室模板关联的所有病种
/// Input: aSchemeCode,aItemCode
/// Return: 病种编码1^病种名称
ClassMethod GetItemDisease(aItemCode As %String) As EMRservice.entity.EUserTemplateDisease
{
	
	q:(($d(aItemCode) = 0)||(aItemCode = "")) ""
	s result = ""
	
	s disRowId = $o(^DHCEMRM.UserTemplateDiseaseI("IdxCode"," "_$zcvt(aUserTemDisease.Code,"U"),""))
	if (disRowId '= "")
	{
		s result = ##Class(EMRservice.entity.EUserTemplateDisease).%New()
		s objUserTemDisease = ##Class(EMRmeta.UserTemplateDisease).%OpenId(disRowId)
		s result.ID = disRowId
		s result.Code = objUserTemDisease.Code
		s result.DiagnosCode = objUserTemDisease.DiagnosCode
		s result.DiagnosName = objUserTemDisease.DiagnosName
	}
	
	q result
}

/// Creator: yejian
/// CreatDate: 2019-8-1
/// Description：更新指定科室模板项关联的病种
/// Input: aItemCode-科室模板编码 , aUserTemDisease 科室模板病种对象
/// Return: 1
ClassMethod ModifyDisease(aItemCode As %String, aUserTemDisease As EMRservice.entity.EUserTemplateDisease) As %String
{
	s res = "0"
	q:((aItemCode="")||(aItemCode = $c(0))) res
	q:((aUserTemDisease="")||(aUserTemDisease.DiagnosCode = "")) res
	if (aUserTemDisease'="")
	{
		s disRowId = $o(^DHCEMRM.UserTemplateDiseaseI("IdxCode"," "_$zcvt(aItemCode,"U"),""))
		if (disRowId = "")
		{
			s objUserTemDisease = ##Class(EMRmeta.UserTemplateDisease).%New()
			s objUserTemDisease.Code = aItemCode
			s objUserTemDisease.DiagnosCode = aUserTemDisease.DiagnosCode
			s objUserTemDisease.DiagnosName = aUserTemDisease.DiagnosName
			s sc = objUserTemDisease.%Save()
			if ($$$ISOK(sc))
			{
			   s res = objUserTemDisease.%Id()
			}
			else
			{
				s res = "0"	
			}
			d objUserTemDisease.%Close()
		}
		else
		{
			s objUserTemDisease = ##Class(EMRmeta.UserTemplateDisease).%OpenId(disRowId)
			s objUserTemDisease.DiagnosCode = aUserTemDisease.DiagnosCode
			s objUserTemDisease.DiagnosName = aUserTemDisease.DiagnosName
			s sc = objUserTemDisease.%Save()
			if ($$$ISOK(sc))
			{
			   s res = objUserTemDisease.%Id()
			}
			else
			{
				s res = "0"	
			}
			d objUserTemDisease.%Close()
		}
	}
	//返回
	q res
}

/// 删除一个科室关联病种
ClassMethod DeleteDiseaseByID(aItemCode As %String) As %String
{
    q:(aItemCode ="") "0"
    b
    s aDiseaseId = $o(^DHCEMRM.UserTemplateDiseaseI("IdxCode"," "_$zcvt(aItemCode,"U"),""))
	q:(aDiseaseId="") "0"
    s objUserTemDisease = ##Class(EMRmeta.UserTemplateDisease).%OpenId(aDiseaseId)
	q:(objUserTemDisease="") "0"
	s sc = ##class(EMRmeta.UserTemplateDisease).%DeleteId(aDiseaseId)
	if ($$$ISOK(sc))
	{	
	   q "0"
    }
    else
    {
		q "-1"
	}
}

}
