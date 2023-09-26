/// Description：表结构登记导入
/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年9月14日
Class web.BDPExt.BDPTableListBLL Extends %RegisteredObject
{

/// Description：表结构登记导入保存方法
/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年9月14日
/// Table: User.BDPTableList, User.BDPTableField
/// Input: 
ClassMethod SaveEntity(Ceobj As web.BDPExt.BDPTableListEntity) As %String
{
	s result=""
	s resL=""
	s resF=""
	s Leobj=##class(web.Entity.BDP.BDPTableList).%New()
	s Leobj.TableName=Ceobj.TableName
	s Leobj.ClassName=Ceobj.ClassName
	s Leobj.TableDesc=Ceobj.TableDesc
	s Leobj.Attribute=Ceobj.Attribute
	s Leobj.DataType=Ceobj.DataType
	s Leobj.MappingHospFlag=Ceobj.MappingHospFlag
	s Leobj.Type=Ceobj.Type
	s Leobj.VersionFlag=Ceobj.VersionFlag
	s Leobj.Sources=Ceobj.Sources
	s Leobj.TableGlobal=Ceobj.TableGlobal
	s Leobj.DescPropertyName=Ceobj.DescPropertyName
	s Leobj.CodePropertyName=Ceobj.CodePropertyName
	s Leobj.StandardDataType=Ceobj.StandardDataType
	s Leobj.StandardDataVersion=Ceobj.StandardDataVersion
	s resL=##class(web.DHCBL.BDP.BDPTableList).SaveEntity(Leobj)		//保存父表
	s ID=$o(^User.BDPTableListI("UqIndex"," "_$ZCONVERT(Leobj.TableName,"U"),0))
	if (Ceobj.FieldName'="")&&(ID'="")
	{
		s Feobj=##class(web.Entity.BDP.BDPTableField).%New()
		s Feobj.ParRef=ID
		s Feobj.FieldName=Ceobj.FieldName
		s Feobj.FieldDesc=Ceobj.FieldDesc
		s Feobj.FieldType=Ceobj.FieldType
		s Feobj.FieldTabCode=Ceobj.FieldTabCode
		s Feobj.FieldTranslation=Ceobj.FieldTranslation
		s resF=##class(web.DHCBL.BDP.BDPTableField).SaveEntity(Feobj)		//保存子表
	}
	s:(resL["success:'true'") result=resL
	s:(resF["success:'true'") result=result_resF
	q result
}

}
