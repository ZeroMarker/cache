Import SQLUser

/// 名称: BILL.CFG.COM.CfgRelaQuery.cls
/// 描述: 计费通用配置-基本配置业务类
/// 编写者: ZhYW
/// 编写日期: 2022-03-01
/// 产品组：计费医保组
Class BILL.CFG.COM.CfgRelaQuery Extends BILL.COM.Abstract
{

/// 数据最大行数限制
Parameter DataLineLimit = 1000;

/// Creator: wzh
/// CreatDate: 2022.12.07
/// Description: 数据源通用方法
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData","QryPayMListe","",2)
Query QryData(methodName As %String, key As %String, hospId As %String) As websys.Query(ROWSPEC = "id:%String,code:%String:代码,text:%String:描述")
{
}

ClassMethod QryDataExecute(ByRef qHandle As %Binary, methodName As %String, key As %String = "", hospId As %String = "") As %Status
{
	s methodTypeRtn = ##class(%Dictionary.MethodDefinition).%ExistsId("BILL.CFG.COM.CfgRelaQuery||"_methodName)
	// 方法保护
	quit:(methodTypeRtn="0") $$$OK // 方法不存在
	
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	
	set key = """"_key_""""
	set hospId = """"_hospId_""""
	
	s excStr = ".."_methodName_"("_repid_","_key_","_hospId_")"
	d @excStr
	
	quit $$$OK
}

/// Creator: wzh
/// CreatDate: 2022.09.14
/// Description: query通用输出方法
/// Input: 	data(1):id
/// 		data(2):code
/// 		data(3):desc
/// Output: 
ClassMethod OutPutInfo(repid, tableName As %String, data, key As %String, hospId As %String)
{
	if (tableName '= ""){
		set flag = ##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(tableName, data(1), hospId)
		quit:(flag = "N")
	}
	set id = $g(data(1))
	set code = $g(data(2))
	set text = $g(data(3))
	// remote 类型的搜索框过滤
	if (key '= ""){
		quit:((code '[key)&&(text'[key))
	}
	set Data = $lb(id, code, text)
	set ^CacheTemp(repid,($o(^CacheTemp(repid,""),-1) + 1))=Data
}

/// Creator: wzh
/// CreatDate: 2022.12.11
/// Description: 检查输出行数
/// Input: 	repid
/// Output: 1:可继续执行，0：不可继续执行
/// w ##class(BILL.CFG.COM.CfgRelaQuery).CheckLine()
ClassMethod CheckLine(repid) As %String
{
	set lineNum = $o(^CacheTemp(repid,""),-1)
	if (lineNum = ..#DataLineLimit){
		quit 0
	}else{
		quit 1
	}
}

/// Creator: ZhYW
/// CreatDate: 2022-02-28
/// Description: 查询科室(SQLUser.CT_Loc)
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData","QryDeptList","",2)
ClassMethod QryDeptList(repid, key As %String, hospId As %String)
{
	&SQL(
		DECLARE cur CURSOR FOR 
		SELECT %ID, CTLOC_Code,CTLOC_Desc
		FROM CT_Loc
		WHERE CTLOC_Hospital_DR = :hospId
			AND ( CTLOC_DateActiveFrom IS NULL OR CTLOC_DateActiveFrom <= CONVERT(DATE, now()) )
			AND ( CTLOC_DateActiveTo IS NULL OR CTLOC_DateActiveTo >= CONVERT(DATE, now()) )
	)
	&SQL(OPEN cur)
	for {
		&SQL(FETCH cur INTO :data())
		quit:SQLCODE
		quit:('..CheckLine(repid))
		do ..OutPutInfo(repid,"CT_Loc",.data,key,hospId)
	}
	&SQL(CLOSE cur)
}

/// Creator: xiongwang
/// CreatDate: 2022-03-30
/// Description: 查询用户(SQLUser.SS_User)
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData","QrySSUserList","",2)
ClassMethod QrySSUserList(repid, key As %String, hospId As %String = "")
{
	&SQL(
		DECLARE cur CURSOR FOR 
		SELECT %ID, SSUSR_Initials,SSUSR_Name
		FROM SS_User
		WHERE SSUSR_Active ='Y'
	)
	&SQL(OPEN cur)
	for {
		&SQL(FETCH cur INTO :data())
		quit:SQLCODE
		quit:('..CheckLine(repid))
		do ..OutPutInfo(repid,"SS_User",.data,key,hospId)
	}
	&SQL(CLOSE cur)
}

/// Creator: xiongwang
/// CreatDate: 2022-03-30
/// Description: 查询安全组(SQLUser.SS_Group)
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData","QrySSGroupList","",2)
ClassMethod QrySSGroupList(repid, key As %String = "", hospId As %String = "")
{
	set rowId = 0
	for {
		set rowId = $o(^SSU("SSGRP",rowId))
		quit:(rowId = "")
		set active = $p(^SSU("SSGRP",rowId),"^",151)
		continue:(active = "N")
		kill data
		set data(1) = rowId
		set data(2) = $p(^SSU("SSGRP",rowId),"^",152)
		set data(3) = $p(^SSU("SSGRP",rowId),"^",1)
		quit:('..CheckLine(repid))
		do ..OutPutInfo(repid,"SS_Group",.data,key,hospId)
	}
}

/// Creator: xiongwang
/// CreatDate: 2022-03-29
/// Description: 查询诊断
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData","QryDiagList"," ",2)
ClassMethod QryDiagList(repid, key As %String = "", hospId As %String = "")
{
	quit:(key="")
	
	set rset=##class(%ResultSet).%New("web.DHCDocDiagnosEntryV8:LookUpWithAlias")
	set rs=rset.Execute(key , "" , "" , "" , "" , "" , "" , "" , "")
	while (rset.Next()) {
		k data
		set data(1)=$g(rset.Data("HIDDEN"))
		set data(2)=$g(rset.Data("code"))
		set data(3)=$g(rset.Data("desc"))
		quit:('..CheckLine(repid))
		do ..OutPutInfo(repid,"",.data,key,hospId)
	}
}

/// Creator: xiongwang
/// CreatDate: 2022-03-24
/// Description: 查询医嘱大类
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData","QryOrderCategoryList","",2)
ClassMethod QryOrderCategoryList(repid, key As %String = "", hospId As %String = "")
{
	&SQL(
		DECLARE cur CURSOR FOR 
		SELECT %ID, ORCAT_Code ,ORCAT_Desc
		FROM OEC_OrderCategory
	)
	&SQL(OPEN cur)
	for {
		kill data
		&SQL(FETCH cur INTO :data())
		quit:SQLCODE
		quit:('..CheckLine(repid))
		do ..OutPutInfo(repid,"OEC_OrderCategory",.data,key,hospId)
	}
	&SQL(CLOSE cur)
}

/// Creator: xiongwang
/// CreatDate: 2022-03-24
/// Description: 查询医嘱子类
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData","QryOrderItemCatList","",2)
ClassMethod QryOrderItemCatList(repid, key As %String = "", hospId As %String = "")
{
	&SQL(
		DECLARE cur CURSOR FOR 
		SELECT %ID, ARCIC_Code,ARCIC_Desc
		FROM ARC_ItemCat
	)
	&SQL(OPEN cur)
	for {
		kill data
		&SQL(FETCH cur INTO :data())
		quit:SQLCODE
		quit:('..CheckLine(repid))
		do ..OutPutInfo(repid,"ARC_ItemCat",.data,key,hospId)
	}
	&SQL(CLOSE cur)
}

/// Creator: xiongwang
/// CreatDate: 2022-03-24
/// Description: 查询医嘱项目
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData","QryARCItmMastList","amxl",2)
ClassMethod QryARCItmMastList(repid, key As %String, hospId As %String)
{
	quit:(key="")
	set rset=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.ArcItemConfig:FindAllItem")
	set rs=rset.Execute(key , "" , "" , "" , "" , "" , "" , hospId)
	while (rset.Next()) {
	 	k data
		set data(1)=$g(rset.Data("ArcimRowID"))
		continue:(data(1)="")
		set data(2)=$p($g(^ARCIM(+data(1),+$p(data(1),"||",2),1)),"^",1)
		set data(3)=$g(rset.Data("ArcimDesc"))
		quit:('..CheckLine(repid))
		do ..OutPutInfo(repid,"",.data,key,hospId)
	}
}

/// Creator: xiongwang
/// CreatDate: 2022-03-30
/// Description: 查询收费项大类(SQLUser.DHC_TarCate)
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData","QryTarCateList","",2)
ClassMethod QryTarCateList(repid, key As %String = "", hospId As %String = "")
{
	&SQL(
		DECLARE cur CURSOR FOR 
		SELECT %ID, TARC_Code ,TARC_Desc
		FROM DHC_TarCate
	)
	&SQL(OPEN cur)
	for {
		kill data
		&SQL(FETCH cur INTO :data())
		quit:SQLCODE
		quit:('..CheckLine(repid))
		do ..OutPutInfo(repid,"DHC_TarCate",.data,key,hospId)
	}
	&SQL(CLOSE cur)
}

/// Creator: xiongwang
/// CreatDate: 2022-03-30
/// Description: 查询收费项子类(SQLUser.DHC_TarSubCate)
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData","QryTarSubCateList","",2)
ClassMethod QryTarSubCateList(repid, key As %String = "", hospId As %String = "")
{
	&SQL(
		DECLARE cur CURSOR FOR 
		SELECT %ID, TARSC_Code ,TARSC_Desc
		FROM DHC_TarSubCate
	)
	&SQL(OPEN cur)
	for {
		kill data
		&SQL(FETCH cur INTO :data())
		quit:SQLCODE
		quit:('..CheckLine(repid))
		do ..OutPutInfo(repid,"DHC_TarSubCate",.data,key,hospId)
	}
	&SQL(CLOSE cur)
}

/// Creator: xiongwang
/// CreatDate: 2022-03-30
/// Description: 查询收费项目(SQLUser.DHC_TarItem)
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData","QryTarItemList","ycx",2)
ClassMethod QryTarItemList(repid, key As %String, hospId As %String)
{
	quit:(key="")
	
	set rset=##class(%ResultSet).%New("DHCBILLConfig.DHCBILLFIND:FindTarItem")
	set rs=rset.Execute(key , "" , hospId)
	while (rset.Next()) {
	 	k data
		set data(1)=$g(rset.Data("rowid"))
		set data(2)=$g(rset.Data("code"))
		set data(3)=$g(rset.Data("desc"))
		quit:('..CheckLine(repid))
		do ..OutPutInfo(repid,"",.data,key,hospId)
	}
}

/// Creator: xiongwang
/// CreatDate: 2022-03-30
/// Description: 查询费别(SQLUser.PAC_AdmReason)
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData","QryAdmReasonList","",2)
ClassMethod QryAdmReasonList(repid, key As %String = "", hospId As %String = "")
{
	&SQL(
		DECLARE cur CURSOR FOR 
		SELECT %ID, REA_Code,REA_Desc
		FROM PAC_AdmReason
		WHERE ( REA_DateFrom IS NULL OR REA_DateFrom <= CONVERT(DATE, now()) )
			AND ( REA_DateTo IS NULL OR REA_DateTo >= CONVERT(DATE, now()) )
	)
	&SQL(OPEN cur)
	for {
		kill data
		&SQL(FETCH cur INTO :data())
		quit:SQLCODE
		quit:('..CheckLine(repid))
		do ..OutPutInfo(repid,"PAC_AdmReason",.data,key,hospId)
	}
	&SQL(CLOSE cur)
}

/// Creator: ZhYW
/// CreatDate: 2022-03-18
/// Description: 查询支付方式
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData","QryPayMList")
ClassMethod QryPayMList(repid, key As %String = "", hospId As %String = "")
{
	&SQL(
		DECLARE cur CURSOR FOR 
		SELECT %ID, CTPM_Code,CTPM_Desc
		FROM CT_PayMode
		WHERE ( CTPM_DateFrom IS NULL OR CTPM_DateFrom <= CONVERT(DATE, now()) )
			AND ( CTPM_DateTo IS NULL OR CTPM_DateTo >= CONVERT(DATE, now()))
	)
	&SQL(OPEN cur)
	for {
		kill data
		&SQL(FETCH cur INTO :data())
		quit:SQLCODE
		quit:('..CheckLine(repid))
		do ..OutPutInfo(repid,"CT_PayMode",.data,key,hospId)
	}
	&SQL(CLOSE cur)
}

/// Creator: wzh
/// CreatDate: 2022.05.27
/// Description: 查询性别
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData","QrySexList","","")
ClassMethod QrySexList(repid, key As %String = "", hospId As %String = "")
{
	&SQL(
	DECLARE cur CURSOR FOR 
		SELECT %ID, CTSEX_Code,CTSEX_Desc
		FROM CT_Sex
		WHERE ( CTSEX_DateFrom IS NULL OR CTSEX_DateFrom <= CONVERT(DATE, now()) )
			AND ( CTSEX_DateTo IS NULL OR CTSEX_DateTo >= CONVERT(DATE, now()) )
	)
	&SQL(OPEN cur)
	for {
		kill data
		&SQL(FETCH cur INTO :data())
		quit:SQLCODE
		quit:('..CheckLine(repid))
		do ..OutPutInfo(repid,"CT_Sex",.data,key,hospId)
	}
	&SQL(CLOSE cur)
}

/// Creator: ZhYW
/// CreatDate: 2022-02-28
/// Description: 关系(CT_Relation)
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData","CTRelation","",2)
ClassMethod CTRelation(repid, key As %String = "", hospId As %String = "")
{
	&SQL(
		DECLARE cur CURSOR FOR 
		SELECT CTRLT_RowId, CTRLT_Code,CTRLT_Desc
		FROM CT_Relation
		WHERE  ( CTRLT_DateFrom IS NULL OR CTRLT_DateFrom <= CONVERT(DATE, now()) )
			AND ( CTRLT_DateTo IS NULL OR CTRLT_DateTo >= CONVERT(DATE, now()) )
	)
	&SQL(OPEN cur)
	for {
		&SQL(FETCH cur INTO :data())
		quit:SQLCODE
		quit:('..CheckLine(repid))
		do ..OutPutInfo(repid,"CT_Relation",.data,key,hospId)
	}
	&SQL(CLOSE cur)
}

/// Creator: TianZJ
/// CreatDate: 2022-11-28
/// Description: 查询就诊子类
/// Table: PAC_EpisodeSubType
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData", "QryEpisSubType","","2")
ClassMethod QryEpisSubType(repid, key As %String, hospId As %String = "2")
{
	&SQL(
		DECLARE cur CURSOR FOR           
		SELECT SUBT_RowId, SUBT_Code, SUBT_Desc
		FROM PAC_EpisodeSubType
		WHERE (SUBT_DateFrom IS NULL OR SUBT_DateFrom<=CONVERT(DATE, now()))
		AND (SUBT_DateTo IS NULL OR SUBT_DateTo>= CONVERT(DATE, now()))
	)
	&SQL(OPEN cur)
	For {
		&SQL(FETCH cur INTO :data())
		quit:SQLCODE
		quit:('..CheckLine(repid))
		do ..OutPutInfo(repid,"PAC_EpisodeSubType",.data,key,hospId)
	}
	&SQL(CLOSE cur)
}

/// Creator: WangXQ
/// CreatDate: 2023-04-12
/// Description: 查询卡类型
/// Table: DHC_CardTypeDef
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData", "QryCardType","","2")
ClassMethod QryCardType(repid, key As %String, hospId As %String = "2")
{
	&SQL(
		DECLARE cur CURSOR FOR           
		SELECT CTD_RowID, CTD_Code, CTD_Desc
		FROM DHC_CardTypeDef
		WHERE (CTD_DateFrom IS NULL OR CTD_DateFrom<=CONVERT(DATE, now()))
		AND (CTD_DateTo IS NULL OR CTD_DateTo>= CONVERT(DATE, now()))
	)
	&SQL(OPEN cur)
	For {
		&SQL(FETCH cur INTO :data())
		quit:SQLCODE
		quit:('..CheckLine(repid))
		do ..OutPutInfo(repid,"DHC_CardTypeDef",.data,key,hospId)
	}
	&SQL(CLOSE cur)
}

/// Creator: wzh
/// CreatDate: 2022.12.11
/// Description: 产品线
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData", "QryProLine","","2")
ClassMethod QryProLine(repid, key As %String, hospId As %String = "2")
{
	&SQL(
		DECLARE cur CURSOR FOR           
		SELECT %ID, PLCode, PLName
		FROM CF_BILL_COM.ProLine
	)
	&SQL(OPEN cur)
	For {
		&SQL(FETCH cur INTO :data())
		quit:SQLCODE
		quit:('..CheckLine(repid))		// 检验数据行数
		do ..OutPutInfo(repid,"",.data,key,hospId)	// 输出数据
	}
	&SQL(CLOSE cur)
}

/// Creator: wzh
/// CreatDate: 2022.12.11
/// Description: 模块
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData", "QryProModule","","2")
ClassMethod QryProModule(repid, key As %String, hospId As %String = "2")
{
	&SQL(
		DECLARE cur CURSOR FOR           
		SELECT %ID, PMCode, PMName
		FROM CF_BILL_COM.ProModule
	)
	&SQL(OPEN cur)
	For {
		&SQL(FETCH cur INTO :data(1),:data(2),:data(3))
		quit:SQLCODE
		quit:('..CheckLine(repid))		// 检验数据行数
		do ..OutPutInfo(repid,"",.data,key,hospId)	// 输出数据
	}
	&SQL(CLOSE cur)
}

/// Creator: wzh
/// CreatDate: 2022.12.11
/// Description: 配置点
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData", "QryCfgPoint","","2")
ClassMethod QryCfgPoint(repid, key As %String, hospId As %String = "2")
{
	&SQL(
		DECLARE cur CURSOR FOR           
		SELECT %ID, CPCode, CPDesc
		FROM CF_BILL_COM.CfgPoint
	)
	&SQL(OPEN cur)
	For {
		&SQL(FETCH cur INTO :data(1),:data(2),:data(3))
		quit:SQLCODE
		quit:('..CheckLine(repid))		// 检验数据行数
		do ..OutPutInfo(repid,"",.data,key,hospId)	// 输出数据
	}
	&SQL(CLOSE cur)
}

/// Creator: wzh
/// CreatDate: 2023.01.30
/// Description: 核算子类
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData", "QrySQL","","2")
ClassMethod QryTarEMC(repid, key As %String, hospId As %String = "2")
{
	&SQL(
		DECLARE cur CURSOR FOR           
		SELECT %ID, TAREC_Code, TAREC_Desc
		FROM DHC_TarEMCCate
	)
	&SQL(OPEN cur)
	For {
		&SQL(FETCH cur INTO :data(1),:data(2),:data(3))
		quit:SQLCODE
		quit:('..CheckLine(repid))		// 检验数据行数
		do ..OutPutInfo(repid,"PAC_EpisodeSubType",.data,key,hospId)	// 输出数据
	}
	&SQL(CLOSE cur)
}

/*
此处为sql、global、query三类调用方法的模板，实际的方法请写于此处注释之上，保证该注释一直位于类的最下方
/// Creator: wzh
/// CreatDate: 2022.12.11
/// Description: 通用方法模板-sql
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData", "QrySQL","","2")
ClassMethod QrySQL(repid, key As %String, hospId As %String = "2")
{
	// 该方法的检索模式如果是local，则下面的quit需要删除；如果是remote则需要保留下面的quit（该行注释实际代码中请删除）
	quit:(key="")
	// 此处select 查询的数据，需符合 第一个为rowid，第二个为代码，第三个为描述（该行注释实际代码中请删除）
	&SQL(
		DECLARE cur CURSOR FOR           
		SELECT %ID, SUBT_Code, SUBT_Desc
		FROM PAC_EpisodeSubType
		WHERE (SUBT_DateFrom IS NULL OR SUBT_DateFrom<=CONVERT(DATE, now()))
		AND (SUBT_DateTo IS NULL OR SUBT_DateTo>= CONVERT(DATE, now()))
	)
	&SQL(OPEN cur)
	For {
		// 此处into需要注意 如果数据id、code、desc在表结构中的顺序为1、2、3，则可使用 :data()，否则需指定（该行注释实际代码中请删除）
		&SQL(FETCH cur INTO :data(1),:data(2),:data(3))
		quit:SQLCODE
		quit:('..CheckLine(repid))		// 检验数据行数
		do ..OutPutInfo(repid,"PAC_EpisodeSubType",.data,key,hospId)	// 输出数据	此处需要更改为实际使用的表名，或者为空
	}
	&SQL(CLOSE cur)
}
/// Creator: wzh
/// CreatDate: 2022.12.11
/// Description: 通用方法模板-global
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData", "QryGLOBAL","","2")
ClassMethod QryGLOBAL(repid, key As %String, hospId As %String = "2")
{
	// 该方法的检索模式如果是local，则下面的quit需要删除；如果是remote则需要保留下面的quit（该行注释实际代码中请删除）
	quit:(key="")
	set rowId = 0
	for {
		set rowId = $o(^SSU("SSGRP",rowId))
		quit:(rowId = "")
		// 此处需生成一个data，其中data(1)为rowid，data(2)为代码，data(3)为描述（该行注释实际代码中请删除）
		kill data
		set data(1) = rowId
		set data(2) = ""
		set data(3) = $p(^SSU("SSGRP",rowId),"^",1)
		quit:('..CheckLine(repid))		// 检验数据行数
		do ..OutPutInfo(repid,"SS_Group",.data,key,hospId)		// 输出数据	此处需要更改为实际使用的表名，或者为空
	}
}
/// Creator: wzh
/// CreatDate: 2022.12.11
/// Description: 通用方法模板-query
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.CfgRelaQuery","QryData", "QryQUERY","","2")
ClassMethod QryQUERY(repid, key As %String, hospId As %String = "2")
{
	// 该方法的检索模式如果是local，则下面的quit需要删除；如果是remote则需要保留下面的quit（该行注释实际代码中请删除）
	quit:(key="")
	
	set rset=##class(%ResultSet).%New("DHCBILLConfig.DHCBILLFIND:FindTarItem")
	set rs=rset.Execute(key , "" , hospId)
	while (rset.Next()) {
		// 此处需生成一个data，其中data(1)为rowid，data(2)为代码，data(3)为描述（该行注释实际代码中请删除）
	 	k data
		set data(1)=$g(rset.Data("rowid"))
		set data(2)=$g(rset.Data("code"))
		set data(3)=$g(rset.Data("desc"))
		quit:('..CheckLine(repid))		// 检验数据行数
		do ..OutPutInfo(repid,"",.data,key,hospId)		// 输出数据	此处需要更改为实际使用的表名，或者为空
	}
}
*/
}
