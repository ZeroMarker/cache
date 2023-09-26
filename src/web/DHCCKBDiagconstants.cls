Import sqluser

Class web.DHCCKBDiagconstants Extends %RegisteredObject
{

/// Creator:      qunianpeng
/// CreatDate:     2020-03-27
/// Description:  获取已经对照的数据(外部代码表)
/// input:		  医院,字典类型,检索条件,登陆信息
/// Other:        
/// d ##class(%ResultSet).RunQuery("web.DHCCKBDiagconstants","QueryContrastList","","115","恶性肿瘤","恶性肿瘤","","","11870^8^1^289^2","")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBDiagconstants","QueryContrastList","","115","","","36.1200","二根冠状动脉的(主动脉)冠状动脉旁路移植","","")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBDiagconstants","QueryContrastList","","115","呼吸道感染","呼吸道感染","","","4^^179^381^2","")
Query QueryContrastList(rowID, type, queryLibCode, queryLibDesc, queryHisCode, queryHisDesc, loginInfo, selHospDesc = "") As websys.Query(ROWSPEC = "CCRowID:%Integer,CCLibCode:%String,CCLibDesc:%String,CCHisCode:%String,CCHisDesc:%String,CCDicTypeDesc:%String,hospDesc:%String,CCSymRelat:%String,CCReference:%String,CCUser:%String,Source:%String,AuditSta:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBDiagconstants","QueryHisDataList","") 
/// @param: pid 进程号
ClassMethod QueryContrastListExecute(ByRef qHandle As %Binary, rowID, type, queryLibCode, queryLibDesc, queryHisCode, queryHisDesc, loginInfo, selHospDesc = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1	
	s ^temp("repid") = $lb(rowID, type, queryLibCode, queryLibDesc, queryHisCode, queryHisDesc, loginInfo, selHospDesc)
	Set qHandle = $lb(0,repid,0)
	k TmpArr 

	if +rowID'=0  d
	.d ..QueryConstratById(.TmpArr,rowID)
	else  if (queryHisCode'="")  d
	.d ..QueryConstratByHisCode(.TmpArr, type, queryLibCode, queryLibDesc, queryHisCode, queryHisDesc, loginInfo, selHospDesc)
	else  if (queryLibCode'="")   d
	.d ..QueryConstratByLibCode(.TmpArr, type, queryLibCode, queryLibDesc, queryHisCode, queryHisDesc, loginInfo, selHospDesc)
	
	s index = ""
	f  s index = $o(TmpArr(index))  q:index=""  d
	.s listData = $g(TmpArr(index))
	.set ^CacheTemp(repid,ind) = listData
    .Set ind = ind+1

	Quit $$$OK
}

/// Description:	通过对照表id获取数据
/// Creator:		qunianpeng
/// CreateDate:		2021-07-29
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBDiagconstants).QueryDiagnosRel()
ClassMethod QueryConstratById(TmpArr, rowID As %String)
{
	s listData =$g(^CKB.PDSS.ComContrastD(rowID))
	s libCode = $lg(listData,2)  //知识库代码
	s libDesc = $lg(listData,3)  //知识库描述
	s hisCode = $lg(listData,4)  //His代码
	s hisDesc = $lg(listData,5)  //His描述
	s dicType = $lg(listData,6)  //实体类型
	s hospId = $lg(listData,7)   // 医院
	s hospDesc = $p($g(^CT("HOSP",+hospId)),"^",2)
	s symList = ##class(web.DHCCKBDiagconstants).QueryDiagnosRel(rowID,"Sym")	// 病症关系 CCSymRelat
	s:symList'="" symList = $listtostring(symList)
	s refList = ##class(web.DHCCKBDiagconstants).QueryDiagnosRel(rowID,"Ref")	// 参考依据 // 参考依据 CCReference
	s:refList'="" refList = $listtostring(refList)
	s logId = $o(^CKB.PDSS.DicLogI("Function","DHC_CKBComContrast",rowID,"add",""),-1)
	s createUser = $case(+logId=0,1:"",:$lg(^CKB.PDSS.DicLogD(+logId),5))	// 操作人	
	s:createUser'="" createUser = $p(^SSU("SSUSR",+createUser),"^",2)
	s source = ##class(web.DHCCKBDiagconstants).getDicMarks("DHC_CKBComContrast",rowID,"confirm")		//来源
	s auditSta = source  
	s dataList = $lb(rowID,libCode,libDesc,hisCode,hisDesc,dicType,hospDesc,symList,refList,createUser,source,auditSta)
	s TmpArr(1) = dataList
	q dataList
}

/// Description:	通过对照his代码获取对照数据
/// Creator:		qunianpeng
/// CreateDate:		2021-07-29
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBDiagconstants).QueryDiagnosRel()
ClassMethod QueryConstratByHisCode(TmpArr, type, queryLibCode, queryLibDesc, queryHisCode, queryHisDesc, loginInfo, selHospDesc)
{
	
	q:'$d(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(queryHisCode))) ""
	set selHospID = 0
	i selHospDesc'="" s selHospID = +$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(selHospDesc),""))
	s count = 0
	s ccRowID=""
	f  s ccRowID = $o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(queryHisCode),ccRowID)) q:ccRowID=""  d
	.s listData = $g(^CKB.PDSS.ComContrastD(ccRowID))
	.s libCode = $lg(listData,2)
	.s libDesc = $lg(listData,3) //知识库描述
	.q:(queryLibCode'="")&&(libDesc'=queryLibCode)
	.q:(queryLibDesc'="")&&(libDesc'=queryLibDesc)
	.s hisDesc = $lg(listData,5)  //His描述
	.q:(queryHisDesc'="")&&(queryHisDesc'[queryHisDesc)
	.s dicType = $lg(listData,6)  //实体类型
	.q:(type'="")&&(dicType'=type)
	.s hospId = $lg(listData,7)  // 医院
	.q:($g(selHospID)'="")&&(selHospID=hospId) //对比医院
	.s count = count + 1
	.k retList
	.s dataList = ..QueryConstratById(.retList,ccRowID)
	.s TmpArr(count) = dataList
	
	q ""
}

/// Description:	保存诊断关联的病症关系、参考依据
/// Creator:		qunianpeng
/// CreateDate:		2021-07-29
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBDiagconstants).QueryDiagnosRel()
ClassMethod QueryConstratByLibCode(TmpArr, type, queryLibCode, queryLibDesc, queryHisCode, queryHisDesc, loginInfo, selHospDesc)
{
	q:'$d(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(queryLibCode))) ""
	set selHospID = 0
	i selHospDesc'="" s selHospID = +$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(selHospDesc),""))
	s count = 0
	s hisCode = ""
	f  s hisCode = $o(^CKB.PDSS.ComContrastI("LibCode",$$ALPHAUP^SSUTIL4(queryLibCode),hisCode))  q:hisCode=""  d
	.s ccRowID="" 
	.f  s ccRowID = $o(^CKB.PDSS.ComContrastI("LibCode",$$ALPHAUP^SSUTIL4(queryLibCode),hisCode,ccRowID)) q:ccRowID=""  d
	..s listData =$g(^CKB.PDSS.ComContrastD(ccRowID))
	..s libCode = $lg(listData,2) 
	..s libDesc = $lg(listData,3) //知识库描述
	..q:(queryLibDesc'="")&&(libDesc'=queryLibDesc)
	..s hisDesc = $lg(listData,5)  //His描述
	..q:(queryHisDesc'="")&&(hisDesc'=queryHisDesc)
	..s dicType = $lg(listData,6)  //实体类型
	..q:(type'="")&&(dicType'=type)
	..s hospId = $lg(listData,7)  // 医院
	..q:($g(selHospID)'="")&&(selHospID=hospId) //对比医院
	..s count = count + 1
	..k retList
	..s dataList = ..QueryConstratById(.retList,ccRowID)
	..s TmpArr(count) = dataList
	
	q ""
}

/// Description:	获取诊断关联的病症关系、参考依据
/// Creator:		qunianpeng
/// CreateDate:		2021-07-29
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBDiagconstants).QueryDiagnosRel(585974,"Sym")
ClassMethod QueryDiagnosRel(constrastDr As %String, type As %String)
{
	q:'$d(^CF.CKB.PDSS.DiagRelationI("IndexType",constrastDr)) ""
	
	s symList = ""
	s relationDr = ""
	f  s relationDr = $o(^CF.CKB.PDSS.DiagRelationI("IndexType",constrastDr,type,relationDr)) q:relationDr=""  d
	.s relDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(relationDr)),3)
	.s $list(symList,*+1) = relDesc

	q symList
}

/// Description:	更新诊断关联的病症关系、参考依据
/// Creator:		qunianpeng
/// CreateDate:		2021-07-29
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBDiagconstants).UpdateDiagnosRel("585977","127237","127250^127249")
ClassMethod UpdateDiagnosRel(constStr As %String, symId As %String, refStr As %String)
{
	s ^TMPEDD = $lb(constStr,symId,refStr)
	
	s ret = 0
	s len = $length(constStr,"^")
	f i=1:1:len  d
	.s constId = $p(constStr,"^",i)
	.i symId'=""  d
	..s type = "Sym"
	..s ret = ..DeleteDiagnosRel(constId,type)
	..s ret = ..SaveDiagnosRel(constId,symId,type)
	.i refStr'=""  d
	..s type = "Ref"
	..s ret =  ..DeleteDiagnosRel(constId,type)
	..f k=1:1:$length(refStr,"^")  d
	...s refId = $p(refStr,"^",k)
	...s ret = ..SaveDiagnosRel(constId,refId,type)
	..
		
	q ret
}

/// Description:	保存诊断关联的病症关系、参考依据
/// Creator:		qunianpeng
/// CreateDate:		2021-07-29
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBDiagconstants).QueryDiagnosRel()
ClassMethod SaveDiagnosRel(constId As %String, symId As %String, type As %String)
{
		
	&SQL(
		INSERT INTO CF_CKB_PDSS.DiagRelation VALUES (:constId,:symId,:type)
	)
	q SQLCODE
}

/// Creator:		qunianpeng
/// CreateDate:		2021-07-29
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBDiagconstants).QueryDiagnosRel()
ClassMethod DeleteDiagnosRel(constId As %String, type As %String)
{
	
	&sql(delete from CF_CKB_PDSS.DiagRelation where DR_ContrastDr=:constId and DR_Type=:type)

	q SQLCODE
}

/// Creator:		qunianpeng
/// CreateDate:		2021-07-29
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBDiagconstants).QueryDiagnosRel()
ClassMethod DeleteDiagnosRelById(constId)
{
	
	&sql(delete from CF_CKB_PDSS.DiagRelation where DR_ContrastDr=:constId)

	q SQLCODE
}

/// Creator:		qunianpeng
/// CreateDate:		2021-07-29
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBDiagconstants).QueryDiagnosRel()
ClassMethod DeleteConstSym(constId As %String)
{
				
	s ret = ##class(web.DHCCKBComContrast).DeleteContrastData(constId)
	i ret["true" d 
	.s ret = ..DeleteDiagnosRelById(constId)
	.s:ret>=0 ret = 0
	q ret
}

/// Creator:		sufan
/// CreateDate:		2022-05-31
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBDiagconstants).getDicMarks("DHC_CKBComContrast",1272436,"sourcebgdata02")
ClassMethod getDicMarks(dic As %String, constId As %String, functCode As %String)
{
	s function = ""
	s dlgFun = ""
	s logId = ""
	for  s logId = $o(^CKB.PDSS.DicLogI("DLGDataDr",constId,logId),-1) Q:(logId="")||(function'="")  d
	.s listData = $g(^CKB.PDSS.DicLogD(logId))
	.s dlgDic = $lg(listData,2)
	.Q:(dic'="")&&(dic'=dlgDic)
	.s dlgFun = $lg(listData,4)
	.Q:(dlgFun="grantAuth")||(dlgFun="add")
	.s function = dlgFun
	Q function
}

}
