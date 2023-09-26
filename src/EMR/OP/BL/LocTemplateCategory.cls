/// 名称:	EMR.OP.BL.LocTemplateCategory
/// 描述:	门诊病历 科室模板目录业务类
/// 编写者：yejian
/// 编写日期: 2022-6-27
/// 产品组：电子病历产品组
Class EMR.OP.BL.LocTemplateCategory Extends EMR.OP.COM.ActionBase
{

/// Desc:       根据模板ID获取科室模板ID集合
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoItem 病历导航入参对象
/// 			arrTemIds 模板JSON数组
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.LocTemplateCategory).GetTemIDByRecordID("YS01","TEMPLATE",.argOutData)
ClassMethod GetLocTemIDByRecordID(dtoItem As EMR.OP.DTO.DocCategory, arrTemIds As %DynamicArray) As %DynamicArray
{
	s jsonLocTemp = ##class(%DynamicArray).%New()
	
	set iter = arrTemIds.%GetIterator()
	s parentid = -100000000000000
	while iter.%GetNext(.key , .item ) {
        s jsonTem = item
        continue:(jsonTem = "")||(jsonTem.templateID="")
		s objTem = ##Class(CF.EMR.DOC.Template).%OpenId(jsonTem.templateID)
	    continue:(objTem="")
	    s strRes = ##class(EMR.OP.BL.LocTemplateCategory).GetJsonCategroyByID(jsonTem.templateID,"",jsonTem,"",.jsonLocTemp)
		s strRes = ##Class(EMR.OP.BL.LocTemplate).GetJsonLocTempalteByCID(jsonTem.templateID,-100000000000000,jsonTem,"",.jsonLocTemp)
	    
	}
	
	q jsonLocTemp
}

/// Desc:       递归获取模板目录数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aTemplateId 模板ID
/// 				aParentId 目录ID
///             aProduct 项目标识
///             aPids 目录id串1^2^3
/// Output:    成功 1，失败 -1 
/// 	Debug:	q ##Class(EMR.OP.BL.LocTemplateCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByID(aTemplateId As %String, aParentId As %String, jsonTem As %DynamicAbstractObject, ByRef aPids As %String, ByRef jsonLocTemp As %DynamicAbstractObject) As %String
{
	s res = "1"
	s arrCategory = ##CLASS(%DynamicArray).%New()

	s strSeq= ""	
	for {
		s strSeq = $o(^CF.EMR.DOC.LocTemplateCatI("IdxPidSeq",aTemplateId," "_aParentId,strSeq))
		q:(strSeq = "")	
		s strCId = $o(^CF.EMR.DOC.LocTemplateCatI("IdxPidSeq",aTemplateId," "_aParentId,strSeq,""))
		q:(strCId = "")		
		s objLocTemCat = ##Class(CF.EMR.DOC.LocTemplateCategory).%OpenId(strCId)
	    continue:(objLocTemCat="")
	    
		s aPids = $case(aPids,"":strCId,:(aPids_"^"_strCId))
		s result = ##Class(EMR.OP.BL.LocTemplateCategory).GetJsonCategroyByID(aTemplateId,strCId,jsonTem,aPids,.jsonLocTemp)
		s result = ##Class(EMR.OP.BL.LocTemplate).GetJsonLocTempalteByCID(aTemplateId,strCId,jsonTem,aPids,.jsonLocTemp)
		
	}
	q res
}

}
