/// 名称:	EMR.DOC.COM.ClassDefine
/// 描述:	类定义公用方法类
/// 编写者:	yejian
/// 编写日期: 	2021-2-22
/// 产品组：	电子病历产品组
Class EMR.DOC.COM.ClassDefine Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       判断后台query是否存在
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      strMethodQuery query名称：类名||query名
/// OutPut:     不存在：0,存在：1
/// debug:		w ##Class(EMR.DOC.COM.ClassDefine).CheckQueryExist("EMRservice.HISInterface.OEOrdInfo||QueryOrderItem")
ClassMethod CheckQueryExist(strMethodQuery As %String) As %String
{
	s strRes = "0"
	q:(strMethodQuery="") strRes
	s methodQuery = ##class(%Dictionary.CompiledQuery).%ExistsId(strMethodQuery)
	q:(methodQuery="0") strRes
	s strRes = "1"
	q strRes
}

/// Desc:       判断后台Method是否存在
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      strMethod 方法名称：类名||method名
/// OutPut:     不存在：0,存在：1
/// debug:		w ##Class(EMR.DOC.COM.ClassDefine).CheckQueryExist("EMRservice.HISInterface.OEOrdInfo||QueryOrderItem")
ClassMethod CheckMethodExist(strMethod As %String) As %String
{
	s strRes = "0"
	q:(strMethod="") strRes
	s method = ##class(%Dictionary.CompiledMethod).%ExistsId(strMethod)
	q:(method="0") strRes
	s strRes = "1"
	q strRes
}

}
