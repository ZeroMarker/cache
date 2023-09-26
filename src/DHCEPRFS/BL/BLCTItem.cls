Class DHCEPRFS.BL.BLCTItem Extends %RegisteredObject [ ProcedureBlock ]
{

/// debug: w ##Class(DHCEPRFS.BL.BLCTItem).GetCTItemByCode("CG01")
ClassMethod GetCTItemByCode(ATypeCode As %String) As %String
{
	s:(ATypeCode =$c(0)) ATypeCode=""
	q:(ATypeCode="") "0"
	//去除前两个字符（CG），并兼容两位数以上
	//s typeCode = $Extract(ATypeCode,3,4)
	s typeCode = $e(ATypeCode,3,$l(ATypeCode))
	s rowID = ""
	s rowID = $o(^DHCEPRFS.META.CTItemTypeI("IdxMain"," "_typeCode,rowID))
	q:(rowID ="") "0"
	s obj = ##class(DHCEPRFS.META.CTItemType).%OpenId(rowID)
	s url = obj.TypeURL
	s method = obj.TypeMethod
	s class = obj.TypeClass
	s ftpConfig = obj.TypeFTPConfig
	s note = obj.TypeNote
	s flag = obj.TypeFlag
	
	q url_"|"_class_"|"_method_"|"_ftpConfig_"|"_note_"|"_flag
}

/// debug: w ##Class(DHCEPRFS.BL.BLCTItem).GetCreateTypeByCode("CG01")
ClassMethod GetCreateTypeByCode(ATypeCode As %String) As %String
{
	s:(ATypeCode =$c(0)) ATypeCode=""
	q:(ATypeCode="") "0"
	//去除前两个字符（CG），并兼容两位数以上
	//s typeCode = $Extract(ATypeCode,3,4)
	s typeCode = $e(ATypeCode,3,$l(ATypeCode))
	s rowID = ""
	s rowID = $o(^DHCEPRFS.META.CTItemTypeI("IdxMain"," "_typeCode,rowID))
	q:(rowID ="") "0"
	s obj = ##class(DHCEPRFS.META.CTItemType).%OpenId(rowID)
	s createType = obj.CreateType

	q createType
}

/// debug: w ##Class(DHCEPRFS.BL.BLCTItem).GetCreateTypeSubByCode("CG01")
ClassMethod GetCreateTypeSubByCode(ATypeCode As %String) As %String
{
	s:(ATypeCode =$c(0)) ATypeCode=""
	q:(ATypeCode="") "0"
	//去除前两个字符（CG），并兼容两位数以上
	//s typeCode = $Extract(ATypeCode,3,4)
	s typeCode = $e(ATypeCode,3,$l(ATypeCode))
	s rowID = ""
	s rowID = $o(^DHCEPRFS.META.CTItemTypeI("IdxMain"," "_typeCode,rowID))
	q:(rowID ="") "0"
	s obj = ##class(DHCEPRFS.META.CTItemType).%OpenId(rowID)
	s createTypeSub = obj.CreateTypeSub

	q createTypeSub
}

/// Desc: 查询CTItem表内容
/// Creator: yangpeng
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLCTItem","GetAllCTItem")
Query GetAllCTItem() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,TypeCode:%String,TypeName : %String,TypeDesc : %String,CSPPath : %String,Company : %String,ProductTeam : %String,CreateType : %String,TypeURL : %String,TypeClass : %String,TypeMethod : %String,TypeFTPConfig : %String,CreateTypeSub : %String")
{
	SELECT ID,TypeCode,TypeName,TypeDesc,CSPPath,Company,ProductTeam,CreateType,TypeURL,TypeClass,TypeMethod,TypeFTPConfig,CreateTypeSub
	FROM dhceprfs_meta.ctitemtype
}

/// Desc: 通过生成方案编码查询CTItem表内容
/// Creator: yangpeng
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLCTItem","GetCTItemBySchemeID","1")
Query GetCTItemBySchemeID(ASchemeID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,TypeCode : %String,TypeName : %String,TypeDesc : %String,CSPPath : %String,Company : %String,ProductTeam : %String,CreateType : %String,TypeURL : %String,TypeClass : %String,TypeMethod : %String,TypeFTPConfig : %String,CreateTypeSub : %String")
{
	SELECT ID,TypeCode,TypeName,TypeDesc,CSPPath,Company,ProductTeam,CreateType,TypeURL,TypeClass,TypeMethod,TypeFTPConfig,CreateTypeSub
	FROM dhceprfs_meta.ctitemtype
	WHERE TypeCode IN (
		SELECT Type FROM dhceprfs_meta.mritem 
		WHERE 
		(SELECT SchemeItems
			FROM dhceprfs_meta.printscheme WHERE id = :ASchemeID)||'^'
			LIKE '%#'||ID||'^%')
}

/// Desc: 查询所有的CTItemInvokeType
/// Creator: yangpeng
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLCTItem","GetAllCTItemInvokeType")
Query GetAllCTItemInvokeType() As %SQLQuery(CONTAINID = 1, ROWSPEC = "InvokeTypeCode:%String,InvokeTypeName: %String")
{
	SELECT InvokeTypeCode,InvokeTypeName FROM DHCEPRFS_META.CTItemInvokeType
}

/// Desc: 增加CTItem
/// Creator: yangpeng
/// debug: w ##Class(DHCEPRFS.BL.BLCTItem).AddCTItem()
ClassMethod AddCTItemType(entityCTItem As DHCEPRFS.Entity.ECTItemType) As %String
{
	s objCTItemType=##class(DHCEPRFS.META.CTItemType).%New()
	
	s objCTItemType.TypeCode = entityCTItem.TypeCode
	s objCTItemType.TypeName = entityCTItem.TypeName
	s objCTItemType.TypeDesc = entityCTItem.TypeDesc
	s objCTItemType.CSPPath = entityCTItem.CSPPath
	s objCTItemType.Sequence = entityCTItem.Sequence
	s objCTItemType.ProductSource = entityCTItem.ProductSource
	s objCTItemType.InvokeType = entityCTItem.InvokeType
	s objCTItemType.TypeURL  = entityCTItem.TypeURL
	s objCTItemType.TypeClass = entityCTItem.TypeClass
	s objCTItemType.TypeMethod = entityCTItem.TypeMethod
	s objCTItemType.TypeFTPConfig = entityCTItem.TypeFTPConfig
	s objCTItemType.TypeNote = entityCTItem.TypeNote
	s objCTItemType.TypeFlag = entityCTItem.TypeFlag
	s objCTItemType.CreateType = entityCTItem.CreateType
	s objCTItemType.Company = entityCTItem.Company
	s objCTItemType.ProductTeam = entityCTItem.ProductTeam
	s objCTItemType.CreateTypeSub = entityCTItem.CreateTypeSub
	
	s sc = objCTItemType.%Save()
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// Desc: 增加CTItem
/// Creator: yangpeng
/// debug: w ##Class(DHCEPRFS.BL.BLCTItem).UpdateCTItemType()
ClassMethod UpdateCTItemType(entityCTItem As DHCEPRFS.Entity.ECTItemType) As %String
{
	s objCTItemType=##class(DHCEPRFS.META.CTItemType).%OpenId(entityCTItem.ID)
	
	s objCTItemType.TypeCode = entityCTItem.TypeCode
	s objCTItemType.TypeName = entityCTItem.TypeName
	s objCTItemType.TypeDesc = entityCTItem.TypeDesc
	s objCTItemType.CSPPath = entityCTItem.CSPPath
	s objCTItemType.Sequence = entityCTItem.Sequence
	s objCTItemType.ProductSource = entityCTItem.ProductSource
	s objCTItemType.InvokeType = entityCTItem.InvokeType
	s objCTItemType.TypeURL  = entityCTItem.TypeURL
	s objCTItemType.TypeClass = entityCTItem.TypeClass
	s objCTItemType.TypeMethod = entityCTItem.TypeMethod
	s objCTItemType.TypeFTPConfig = entityCTItem.TypeFTPConfig
	s objCTItemType.TypeNote = entityCTItem.TypeNote
	s objCTItemType.TypeFlag = entityCTItem.TypeFlag
	s objCTItemType.CreateType = entityCTItem.CreateType
	s objCTItemType.Company = entityCTItem.Company
	s objCTItemType.ProductTeam = entityCTItem.ProductTeam
	s objCTItemType.CreateTypeSub = entityCTItem.CreateTypeSub
	
	s sc = objCTItemType.%Save()
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// Create: yangshun
/// Desc: 通过code获取csp的完整路径
ClassMethod GetCSPPathByCode(ACode As %String) As %String
{
	s:(ACode=$c(0)) ACode = ""
	q:(ACode="") "0"
	s typeCode = $E(ACode,3,$l(ACode))
	s rowID = ""
	s rowID = $o(^DHCEPRFS.META.CTItemTypeI("IdxMain"," "_typeCode,rowID))
	q:(rowID="") "0"
	s obj = ##class(DHCEPRFS.META.CTItemType).%OpenId(rowID)
	s cspPath = obj.CSPPath
	q cspPath
}

}
