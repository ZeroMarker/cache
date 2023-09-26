Import sqluser

/// Creator:      qunianpeng
/// CreatDate:    2020-03-27
/// Description:  数据映射业务列
Class web.DHCCKBComContrast Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:      qunianpeng
/// CreatDate:     2020-03-27
/// Description:  获取所有的字典集合
/// Input:		  检索条件,登录信息
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBComContrast","GetDictionList","")
Query QueryDictionList(q As %String, loginInfo As %String, drugType = "") As websys.Query(ROWSPEC = "CDRowID:%Integer,CDCode:%String,CDDesc:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBComContrast","QueryDictionList","") 
/// @param: q 查询信息
ClassMethod QueryDictionListExecute(ByRef qHandle As %Binary, q = "", loginInfo, drugType = "") As %Status
{
	n (qHandle,q,loginInfo,drugType)
	
	Set repid=$I(^CacheTemp)	
	Set ind=1
	s queryCode = $zcvt(q,"U")
	
	s extraAttr = "KnowType"
	s extraAttrValue = "DictionFlag"
	s extraAttrDr = ##class(web.DHCCKBCommon).GetDicIdByCode(extraAttr)  //附加属性
	
	s dicID=""  f   s dicID=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",extraAttrDr,dicID))  q:dicID=""   d
	.s linkID=""  f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",extraAttrDr,dicID,linkID))  q:linkID=""   d
	..s attrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)	// 附加属性值
	..q:attrDr=""
	..s attrCode=$lg(^CT.CKB.PDSS.CommonDictionD(+attrDr),2)	// 附加属性值(知识类型,区分实体、属性、数据源)
	..q:(extraAttrValue'="")&($zcvt(extraAttrValue,"U")'=$zcvt(attrCode,"U"))
	..//q:0=##class(web.DHCCKBCommon).IsShow(dicID,"DHC_CKBCommonDiction",loginInfo)
	..s dicCode = $lg(^CT.CKB.PDSS.CommonDictionD(+dicID),2)
	..s dicDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+dicID),3)
	..s parref = $lg(^CT.CKB.PDSS.CommonDictionD(+dicID),4)
	..q:(dicCode="")||(dicDesc="")
	..q:##class(web.DHCCKBCommon).CheckDrugType(drugType,dicDesc)
	..s pinDicDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	..q:(queryCode'="")&($zcvt(dicCode,"U")'[queryCode)&(dicDesc'[queryCode)&(pinDicDesc'[$zcvt(queryCode,"U"))
	..
	..d OutputList
	
	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
	
OutputList
    set Data = $lb(dicID,dicCode,dicDesc)
    set ^CacheTemp(repid,ind) = Data
    Set ind = ind+1
    quit
}

/// Creator:      qunianpeng
/// CreatDate:     2020-03-27
/// Description:  获取his数据(外部代码表)
/// input:		  医院,字典类型,检索条件
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBComContrast","QueryHisDataList","2","SpecialPopData","","false","")
Query QueryHisDataList(hospital, type = "", queryCode = "", matchtype = "", hischeck) As websys.Query(ROWSPEC = "HisRowID:%String,HisCode:%String,HisDesc:%String,ConstrastFlag:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBComContrast","QueryHisDataList","2","DrugData","","false","") 
/// @param: 
ClassMethod QueryHisDataListExecute(ByRef qHandle As %Binary, hospital, type, queryCode, matchtype, hischeck) As %Status
{
	n (qHandle,hospital,type,queryCode,matchtype,hischeck)	
	Set repid=$I(^CacheTemp)	
	Set ind=1
	s queryCode=$zcvt(queryCode,"U")
	s extRowID=""
	f  s extRowID=$o(^CKB.PDSS.ExtDictionI("Type",hospital,type,extRowID))  q:extRowID=""  d
	.s extData = $g(^CKB.PDSS.ExtDictionD(extRowID)) 
	.s extCode=$lg(extData,2)
	.s extDesc=$lg(extData,3)
	.s extParref=$lg(extData,6)
	.q:extParref=""
	.s extDesc=$p(extDesc,"||",1)
	.q:(extCode="")||(extDesc="")
	.s pinDicDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(extDesc))	
	.q:(queryCode'="")&($zcvt(extCode,"U")'[queryCode)&(extDesc'[queryCode)&(pinDicDesc'[$zcvt(queryCode,"U"))
	.s ConstrastFlag=0
	.s comfirm=""   //核对标记
	.i $d(^CKB.PDSS.ComContrastI("HisCode",$zcvt(extCode,"U")))&($d(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(extDesc,"U")))) d
	..s conID = ""
	..f  s conID=$o(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(extDesc,"U"),conID))  q:(conID="")||(ConstrastFlag=1)   d
	...s listData =$g(^CKB.PDSS.ComContrastD(conID))
	...s conCode = $lg(listData,4)
	...s libCode = $lg(listData,2)
	...s libDesc = $lg(listData,3)
	...s hospId = $lg(listData,7) // xww 2022-03-08 对照表医院id
	...;q:(hospital'="")&&(hospital'=hospId)
	...s comfirm=..comfirmFlag(type, libCode, libDesc)
	...s:(conCode=extCode)&&(hospId="") ConstrastFlag=1	//dinglei 2023-04-26 新增医院为空判断
	...s:(conCode=extCode)&&(hospital=hospId)&&(hospId'="") ConstrastFlag=1   //xww 2022-06-13 增加医院判断是否对照
	...//s:$d(^CKB.PDSS.ComContrastI("HisCode",$zcvt(extCode,"U"))) ConstrastFlag=1		
	.Q:(matchtype'="")&&(matchtype="true")&&(ConstrastFlag=1)
	.i hischeck="" s comfirm=""
	.q:(hischeck'=comfirm)
	.;s confirm = +$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",dicID,"confirm"))
	.;Q:(matchtype'="")&&(matchtype="false")&&(ConstrastFlag=1)
	.d QutputHisData
	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
	
QutputHisData
    set listData = $lb(extRowID,extCode,extDesc,ConstrastFlag)
    set ^CacheTemp(repid,ind) = listData
    Set ind = ind+1

    quit
}

/// Creator:      qunianpeng
/// CreatDate:     2020-03-27
/// Description:  获取已经对照的数据(外部代码表)
/// input:		  医院,字典类型,检索条件,登陆信息
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBComContrast","QueryContrastList","111","","","11868^7^1^289^2","","北京惠兰医院")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBComContrast","QueryContrastList","81790","","XY000207","11871^8^1^289^2","双黄连口服液10ml(哈药集团三精制药股份有限公司)","赛罕区第二医院")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBComContrast","QueryContrastList","111","","每日1剂 每日1次","11871^8^1^289^2","","赛罕区第二医院")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBComContrast","QueryContrastList","115","","A16.900x001","11871^8^1^289^2","","")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBComContrast","QueryContrastList","105","","J06004WI00","11868^7^1^289^2","注射用青霉素钠80万U(华北制药股份有限公司)","广西壮族自治区南溪山医院")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBComContrast","QueryContrastList","105","","XZS000728","4^^179^381^2","注射用苄星青霉素120万U(华北制药股份有限公司)","东华标准版数字化医院[总院]")
Query QueryContrastList(type = "", queryLibCode = "", queryHisCode = "", loginInfo, queryLibDesc = "", selHospDesc = "") As websys.Query(ROWSPEC = "CCRowID:%Integer,CCLibCode:%String,CCLibDesc:%String,CCHisCode:%String,CCHisDesc:%String,CCDicTypeDesc:%String,hospDesc:%String,confirmConsFlag:%String,CCSymRelat:%String,CCReference:%String,CCUser:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBComContrast","QueryHisDataList","") 
/// @param: pid 进程号
ClassMethod QueryContrastListExecute(ByRef qHandle As %Binary, type, queryLibCode, queryHisCode, loginInfo, queryLibDesc, selHospDesc) As %Status
{
	n (qHandle,type,queryLibCode,queryHisCode,loginInfo,queryLibDesc,selHospDesc)
 	s ^temptest("type")=$lb(type,queryLibCode,queryHisCode,loginInfo,queryLibDesc,selHospDesc)
	Set repid=$I(^CacheTemp)	
	Set ind=1	
	set SelHospID = 0
	i selHospDesc'="" s SelHospID = +$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(selHospDesc),""))
	s ccRowID=""
	f  s ccRowID=$o(^CKB.PDSS.ComContrastI("Type",type,ccRowID))	q:ccRowID=""  d
	.s listData =$g(^CKB.PDSS.ComContrastD(ccRowID))
	.s libCode = $lg(listData,2) //知识库代码
	.s libDesc = $lg(listData,3) //知识库描述
	.s hisCode = $lg(listData,4) //His代码
	.s hisDesc = $lg(listData,5) //His描述
	.s dicType = $lg(listData,6) //实体类型
	.q:(SelHospID'=0)&&('$d(^CKB.PDSS.ExtDictionI("Code",SelHospID,hisCode)))
	.q:(SelHospID'=0)&&(0=..CheckFlag(hisCode,hisDesc,SelHospID))
	.s confirmConsFlag=##class(web.DHCCKBCommon).GetConfirmConsFlag(ccRowID)
	.//q:(SelHospID'=0)&&('$d(^CKB.PDSS.ExtDictionI("Desc",SelHospID,hisDesc)))
	.s hospId = $lg(listData,7)
	.s hospDesc = $p($g(^CT("HOSP",+hospId)),"^",2)  // ##class(web.DHCCKBComContrast).getHospDesc(hisCode,hisDesc)			//取医院  sufan2020-10-19
	.q:(queryLibCode'="")&(queryLibDesc'="")&(( ..ReplaceBrackets($$UPPER^SSUTIL4(queryLibCode))'=..ReplaceBrackets($$UPPER^SSUTIL4(libCode)))||( ..ReplaceBrackets($$UPPER^SSUTIL4(queryLibDesc))'= ..ReplaceBrackets($$UPPER^SSUTIL4(libDesc))))
	.q:(queryHisCode'="")&(queryHisCode'=hisCode)
	.q:(selHospDesc'="")&(hospDesc'[selHospDesc) //对比医院
	.//q:(selHospDesc'="")&(hospDesc'=selHospDesc) //对比医院
	.s symList = ##class(web.DHCCKBDiagconstants).QueryDiagnosRel(ccRowID,"Sym")	// 病症关系 CCSymRelat
	.s:symList'="" symList = $listtostring(symList)
	.s refList = ##class(web.DHCCKBDiagconstants).QueryDiagnosRel(ccRowID,"Ref")	// 参考依据 // 参考依据 CCReference
	.s:refList'="" refList = $listtostring(refList)
	.s logId = $o(^CKB.PDSS.DicLogI("Function","DHC_CKBComContrast",ccRowID,"add",""),-1)
	.s createUser = $case(+logId=0,1:"",:$lg(^CKB.PDSS.DicLogD(+logId),5))	// 操作人	
	.s:createUser'="" createUser = $p($g(^SSU("SSUSR",+createUser)),"^",2)
	.d OutputContrast
			

	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
	
OutputContrast
    set listData = $lb(ccRowID,libCode,libDesc,hisCode,hisDesc,dicType,hospDesc,confirmConsFlag,symList,refList,createUser)
    set ^CacheTemp(repid,ind) = listData
    Set ind = ind+1
    quit
}

/// Creator:sufan
/// CreateDate:2020-10-19
/// Descript:取外部代码医院信息
/// w ##class(web.DHCCKBComContrast).getHospDesc("每日1剂 每日1次","饮片")
ClassMethod getHospDesc(hisCode, hisDesc)
{
	n (hisCode,hisDesc)
	k hosArr
	s hospId = ""
	for  s hospId = $o(^CKB.PDSS.ExtDictionI("Code",hospId))  Q:hospId=""  d
	.Q:'$d(^CKB.PDSS.ExtDictionI("Code",hospId,hisCode))
	.//Q:'$d(^CKB.PDSS.ExtDictionI("Desc",hospId,hisDesc))&('$d(^CKB.PDSS.ExtDictionI("Desc",hospId,hisDesc_"||")))
	.s exitFlag = ..CheckFlag(hisCode,hisDesc,hospId)
	.q:exitFlag=0
	.s hosArr(hospId)=hospId
	s hos = "",hosDescList = ""
	for  s hos = $o(hosArr(hos))  Q:hos=""  d
	.i '$d(^CT("HOSP",hos)) s hosDesc = hos
	.e  s hosDesc = $p(^CT("HOSP",hos),"^",2)
	.i hosDescList = "" s hosDescList = hosDesc
	.e  s hosDescList = hosDescList_","_hosDesc
	Q hosDescList
}

/// Creator:      qunianpeng
/// CreatDate:     2020-03-27
/// Description:  保存对照信息
/// input:		  对照信息,  symStr 增加病症关系字符串 2021/11/30
/// Return:       成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:        w ##class(web.DHCCKBComContrast).SaveContrastData("010101zsyqmsn^注射用青霉素钠^YPX0082^左卡尼汀口服溶液[1g;10ml]^105","1^1^1^1^2","111.18.94.180")
/// w ##class(web.DHCCKBComContrast).SaveContrastData("呼吸道感染^呼吸道感染^36.1000^主动脉冠状动脉旁路移植，为心脏血管再形成术^115","1^1^1^1^2","113.140.81.66")
/// w ##class(web.DHCCKBComContrast).SaveContrastData("水煎内服^水煎内服^025^口服(中草药)^110","11868^7^1^289^2","113.140.81.66")
ClassMethod SaveContrastData(listdata As %String, loginInfo, clientIP, selHospId, symStr = "") As %String
{
	n (listdata,loginInfo,clientIP,selHospId,symStr)	
	s result = ""
	
	set $ZT="ERROR" // 设置一个异常
	s libcode = $p(listdata,"^",1)  //知识库代码
    s libdesc = $p(listdata,"^",2)  //知识库描述
    s hiscode = $p(listdata,"^",3)  //His代码
    s hisdesc = $p($p(listdata,"^",4),"||",1)  //His描述 药品||厂家 取前半段
    s dictype = $p(listdata,"^",5)  //实体类型
   	s operator = $p(loginInfo,"^",1)
    s hospital = selHospId ;$p(loginInfo,"^",5)     shy 2021-6-2 修改为选择医院ID
    
   	s drugDataId=##class(web.DHCCKBCommon).GetDrugData()
   	s chineseDrugDataId=##class(web.DHCCKBCommon).GetChineseDrugData()	// 除药品外，其他字典对照可以多对多(qnp 2020/07/16)
   	;s hisexist=0
   	;i (dictype=drugDataId)||(dictype=chineseDrugDataId)  d
	;.s hisexist = $d(^CKB.PDSS.ComContrastI("HisCode",hiscode))
	;q:hisexist "该his通用名已对照, 不能重复对照!"   //sufan  2020-12-24 修改为字符串
	
	//s exist = $d(^CKB.PDSS.ComContrastI("LibCode",libcode,hiscode))
	//q:exist "该记录已对照, 不能重复对照!"
	b //rr
	s exist = ..ConstFlag(hiscode,hisdesc,libcode,libdesc,hospital)
	q:exist=1 0   //"该记录已对照, 不能重复对照!"
	
	s obj=##class(CKB.PDSS.ComContrast).%New()
	s obj.CCLibCode = libcode
	s obj.CCLibDesc = libdesc
	s obj.CCHisCode = hiscode
	s obj.CCHisDesc = hisdesc
	s obj.CCDicType = dictype
	s obj.CCHospital = hospital

	s:hospital="" hospital=$p(loginInfo,"^",5)  // 诊断对照时不需要医院id,日志中需要医院id,暂时取登录信息值
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	i $$$ISOK(sc) d
	.s id = obj.%Id()
	.i dictype = ##class(web.DHCCKBCommon).GetDiseaseData()  d	// 疾病对照增加病症关系和参考依据 qnp 2021/11/30
	..s ret = ##class(web.DHCCKBDiagconstants).UpdateDiagnosRel(id,$p(symStr,"&&",1),$p(symStr,"&&",2))	
	.//添加保存日志 sunhuiyong 2020-11-25
	.s addflag=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBComContrast",id,"add",operator,"","","D",hospital,clientIP,"acc")
	.// 保存后自动授权
	.s ret=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBComContrast",id,"grantAuth",operator,"","","D",hospital,clientIP,"acc")
	.i ((ret=0)&&(addflag=0)) d
	..tc
	..s result = "0"  //返回RowId
	.e  d
	..tro
	..s result= "-1" 
	
	e  d
	.Trollback
	.s result = "-1"   //返回错误信息
	
	q result
	
ERROR
	tro
	set $ZT=""
	set ErrorMsg=$ZE                  //$ZE 获取错误信息
	
	q ErrorMsg   //返回错误信息
}

/// Creator:      qunianpeng
/// CreatDate:     2020-03-27
/// Description:  删除对照信息
/// input:		  对照表id
/// Return:       成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:        w ##class(web.DHCCKBComContrast).DeleteContrastData("2219")
ClassMethod DeleteContrastData(rowid As %String) As %String
{
	n (rowid)
	s result=""

	set $ZT="ERRORMSG" // 设置一个异常
	Ts	
	s sc=##class(CKB.PDSS.ComContrast).%DeleteId(rowid)

	if $$$ISOK(sc) d
	.//需要删除授权
	.s ret=..CleanAllGrantAuth(rowid,"DHC_CKBComContrast")
	.i ret=1  d
	..tc
	..s result="{success:'true',info:'删除成功！'}"
	.e  d
	..tro
	..s result="{success:'false',info:'删除失败！'}"
	e  d
	.Trollback
	.s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
	
	q result
	
ERRORMSG
	tro
	set $ZT=""
	set ErrorMsg=$ZE                  //$ZE 获取错误信息
	
	q "{success:'false',info:'"_ErrorMsg_"'}"   //返回错误信息
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-27
/// Descript: 	   	清除数据的所有授权
/// Input:			需要清除的数据id
/// OutPut:			1 清除成功 0 清除失败
/// w ##class(web.DHCCKBComContrast).GetItmIdParref(2219,"DHC_CKBComContrast")
ClassMethod CleanAllGrantAuth(ItmId, Table)
{
	n (ItmId,Table)
	
	q:(+ItmId=0)||(Table="") 1
	q:'$d(^CKB.PDSS.DicLogI("Function",Table,ItmId,"grantAuth")) 1
	&sql(delete from CKB_PDSS.DicLog where DLG_Data_Dr=:ItmId and DLG_Function="grantAuth" and DLG_Dic=:Table)
	
	q:SQLCODE'=0 0
	
	q 1
}

/// Description:	更改外部字典表归属字典
/// Creator:		kemaolin 
/// CreateDate:		2020-07-16	
/// Input:			
/// return:			0 成功，<0 失败
/// other:			w ##class(web.DHCCKBComContrast).UpdateDataType("贫血","D53.001")
ClassMethod UpdateDataType(HisID = "", DataTypeID = "") As %String
{
	n (HisID,DataTypeID)  
    q:(HisID="")||(DataTypeID="") -1
    s DataTypeCode=$lg(^CT.CKB.PDSS.CommonDictionD(+DataTypeID),2)
    q:DataTypeCode="" -1
    &sql(UPDATE CKB_PDSS.ExtDiction SET ED_Type =:DataTypeCode WHERE ED_RowID=:HisID)
    
    q SQLCODE
}

/// Creator:      qunianpeng
/// CreatDate:     2020-03-27
/// Description:  导出等效单位
/// Input:		  检索条件,登录信息
/// Other:        w ##Class(websys.Query).ToExcel("等效单位","web.DHCCKBComContrast","QueryDrugFormEquiv")
Query QueryDrugFormEquiv() As websys.Query(ROWSPEC = "itemDesc:%String,Uom:%String,subUom:%String,eqqty:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBComContrast","QueryDictionList","") 
/// @param: q 查询信息
ClassMethod QueryDrugFormEquivExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	
	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	k ^TMP("web.DHCSTPHCMPASS","GetBUomFacInfo")
	d ..GetDrugFormEquiv()
	s count="" f  s count=$o(^TMP("web.DHCSTPHCMPASS","GetBUomFacInfo",count))  q:count=""  d
	.s itemDesc=$p(^TMP("web.DHCSTPHCMPASS","GetBUomFacInfo",count),"^",1)
	.s Uom=$p(^TMP("web.DHCSTPHCMPASS","GetBUomFacInfo",count),"^",2)
	.s subUom=$p(^TMP("web.DHCSTPHCMPASS","GetBUomFacInfo",count),"^",3)
	.s eqqty=$p(^TMP("web.DHCSTPHCMPASS","GetBUomFacInfo",count),"^",4)
	.d OutputFormEquivList
	k ^TMP("web.DHCSTPHCMPASS","GetBUomFacInfo")
	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
	
OutputFormEquivList
    set Data = $lb(itemDesc,Uom,subUom,eqqty)
    set ^CacheTemp(repid,ind) = Data
    Set ind = ind+1
    quit
}

/// 取his等效单位
/// d ##class(web.DHCSTPHCMPASS).GetDrugFormEquiv()
ClassMethod GetDrugFormEquiv()
{
	s count=0
	s subScript=""
	f  s subScript=$o(^ARCIM(subScript)) q:subScript=""  d
	.q:subScript=0
	.s version="" f  s version=$o(^ARCIM(subScript,version)) q:version=""  d
	..//医嘱项名称
	..s itemDesc=$p(^ARCIM(subScript,version,1),"^",2)
	..s arci=subScript_"||"_version
	..d ..GetBUomFacInfo(arci, itemDesc,.count)
}

ClassMethod GetBUomFacInfo(arci, itemDesc, count) As %String
{
	n (arci, itemDesc,count)
	S phcdf=$P(^ARCIM(+arci,$p(arci,"||",2),1),"^",12)
	S phc=$P(phcdf,"||",1)
	Q:phc="" 1
	S formsub=$P(phcdf,"||",2)
	Q:formsub="" 1
	s UomID=$p(^PHCD(phc,"DF",formsub,2),"^",4)
	s Uom=$p(^CT("UOM",UomID),"^",2)
	s eqsub="0",eqqty=0
	f  s eqsub=$O(^PHCD(phc,"DF",formsub,"EQ",eqsub)) q:eqsub=""  d
	.S equomdr=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",1)
	.s eqqty=+$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",2) //等效数量	
	.s subUomID=+$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",1) 
	.s subUom=$p(^CT("UOM",subUomID),"^",2)
	.s count=count+1
	.s ^TMP("web.DHCSTPHCMPASS","GetBUomFacInfo",count)=itemDesc_"^"_Uom_"^"_subUom_"^"_eqqty
}

/// Description:	导入his等效单位
/// Creator:		kml     sufan 修正代码 2020-09-27
/// CreateDate:		2020-04-16
/// Input:			
/// return:			
/// other:	w ##class(web.DHCCKBComContrast).ImportDrugDatas()
ClassMethod ImportDrugDatas() As %String
{
	TSTART
	k ^TMP("web.DHCCKBComContrast","ImportDrugDatas")
	k ^kmlFormTest1
	k ^kmlFormTest2
	s errNum=0
	s count =0,count1 =0,count2 =0
	s UnitData=##class(web.DHCCKBCommon).GetUnitData() //单位字典
	s EqUnitProp=##class(web.DHCCKBCommon).GetEqUnitProp() //等效单位属性
	s EqFromUnitProp=##class(web.DHCCKBCommon).GetEqFromUnitProp() //从单位属性
	s EqToUnitProp=##class(web.DHCCKBCommon).GetEqToUnitProp() //到单位属性
	s EqFactorProp=##class(web.DHCCKBCommon).GetEqFactorProp() //转换系数
	//s file=##class(%File).%New("D:\kml\哈医大等效单位v3.csv")
	s file=##class(%File).%New("D:\hisunit.xlsx")
	d file.Open("RS")
	d file.ReadLine() //读取一行
	s count=0
	s Err=0

	while 'file.AtEnd
	{
		s Line=file.Read()
		continue:Line=""
		s itemDesc = $p(Line,",",1)  //his药品
		continue:itemDesc=""
		s Uom = $p(Line,",",2)  //his单位	
		s subUom = $p(Line,",",3)  //his等效单位
		s eqqty = $p(Line,",",4)  //his系数
		s:$e(eqqty,1)="." eqqty="0"_eqqty //小数点前面补0
		w Line,!
		//获取知识库单位id
		s UomID="",subUomID=""
		s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",UnitData,id)) q:(id="")||((UomID'="")&&(subUomID'=""))  d
		.s tmpUnit=$lg(^CT.CKB.PDSS.CommonDictionD(+id),3)
		.s:(UomID="")&&(tmpUnit=Uom) UomID=id
		.s:(subUomID="")&&(tmpUnit=subUom) subUomID=id
		
		//等效单位 取对照
		i UomID=""  d 
		.i $d(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(Uom,"U")))  d
		..s ccID=$o(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(Uom,"U"),""))
		..s ccLibDesc=$lg(^CKB.PDSS.ComContrastD(ccID),3)
		..s:ccLibDesc'="" UomID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(ccLibDesc),""))
		i subUomID=""  d 
		.i $d(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(subUom,"U")))  d
		..s ccID=$o(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(subUom,"U"),""))
		..s ccLibDesc=$lg(^CKB.PDSS.ComContrastD(ccID),3)
		..s:ccLibDesc'="" subUomID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(ccLibDesc),""))
		//b   //33
		//获取知识库药品id
		//描述 字典类型 知识库药品id
		s ccLibDesc="",ccDicType="",libItemID=""
		i $d(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(itemDesc,"U")))  d
		.s ccID=$o(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(itemDesc,"U"),""))
		.s ccLibDesc=$lg(^CKB.PDSS.ComContrastD(ccID),3)
		.s ccDicType=$lg(^CKB.PDSS.ComContrastD(ccID),6)
		continue:ccLibDesc=""
		i ccLibDesc'=""  d
		.s cdID="" f  s cdID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(ccLibDesc),cdID)) q:(cdID="")||(libItemID'="")  d
		..s parref=$lg(^CT.CKB.PDSS.CommonDictionD(+cdID),4)
		..s:parref=ccDicType libItemID=cdID
		
		continue:libItemID=""
		i (UomID="")||(subUomID="") w itemDesc_"^"_Uom_"^"_subUom_"^"_eqqty,!
		continue:(UomID="")||(subUomID="")
		//s UomStr=""_"^"_libItemID_"^"_EqFromUnitProp_"^"_UomID_"^"_""
		//s SubUomStr=""_"^"_libItemID_"^"_EqToUnitProp_"^"_subUomID_"^"_""
		//s EqqtyStr=""_"^"_libItemID_"^"_EqFactorProp_"^"_""_"^"_eqqty
		
		s count=count+1
		//取知识库等效单位比较
		;s $p(^TMP("web.DHCCKBComContrast","ImportDrugDatas",libItemID,GroupFlag),"^",1)=ccLibDesc
		//从单位
		s attrID="" f  s attrID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",libItemID,EqFromUnitProp,attrID)) q:attrID=""  d
		.s FromUnitID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrID)),4)
		.q:FromUnitID=""
		.s FromUnit=$lg(^CT.CKB.PDSS.CommonDictionD(+FromUnitID),3)
		.s GroupFlag=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrID)),6)
		.s $p(^TMP("web.DHCCKBComContrast","ImportDrugDatas",libItemID,GroupFlag),"^",1)=ccLibDesc
		.s $p(^TMP("web.DHCCKBComContrast","ImportDrugDatas",libItemID,GroupFlag),"^",2)=FromUnit_"&&"_FromUnitID
		
		//到单位
		s attrID="" f  s attrID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",libItemID,EqToUnitProp,attrID)) q:attrID=""  d
		.s ToUnitID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrID)),4)
		.Q:ToUnitID=""
		.s ToUnit=$lg(^CT.CKB.PDSS.CommonDictionD(+ToUnitID),3)
		.s GroupFlag=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrID)),6)
		.s $p(^TMP("web.DHCCKBComContrast","ImportDrugDatas",libItemID,GroupFlag),"^",3)=ToUnit_"&&"_ToUnitID
		
		//系数
		s attrID="" f  s attrID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",libItemID,EqFactorProp,attrID)) q:attrID=""  d
		.s Factor=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrID)),5)
		.s GroupFlag=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrID)),6)	
		.s $p(^TMP("web.DHCCKBComContrast","ImportDrugDatas",libItemID,GroupFlag),"^",4)=Factor_"&&"_attrID
		s FactorAttrID=""
		
		s repeatFlag=0,updateFlag=0,partUpdateFlag=0,insertFlag=0
		s id=""  f  s id=$o(^TMP("web.DHCCKBComContrast","ImportDrugDatas",libItemID,id)) q:id=""  d
		.s data=^TMP("web.DHCCKBComContrast","ImportDrugDatas",libItemID,id)
		.s unit=$P($p(data,"^",2),"&&",2) //单位id
		.s subUnit=$P($p(data,"^",3),"&&",2) //等效单位id
		.s factor=$p($p(data,"^",4),"&&",1) //系数
		.i (UomID=unit)&&(subUomID=subUnit)&&(eqqty=factor)  d
		..s repeatFlag=1
		.i (UomID=unit)&&(subUomID=subUnit)&&(eqqty'=factor)  d
		..s updateFlag=1
		..s FactorAttrID=$p($p(data,"^",4),"&&",2) //系数更改
		.i (UomID=unit)&&(subUomID'=subUnit)  d 
		..s partUpdateFlag=1
		
		continue:repeatFlag=1
		s ^TMP("web.DHCCKBComContrast","ImportDrugDatas","saveOrUpdate",libItemID)=ccLibDesc
		
		//更新
		i (repeatFlag=0)&&(updateFlag=1)  d
		.//s ^kmlFormTest1(count)=data_"||"_Uom_"^"_subUom_"^"_eqqty
		.s count1=count1+1
		.w FactorAttrID,!
		.&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Result=:eqqty where DLA_RowID=:FactorAttrID)
		.s:SQLCODE'=0 Err=SQLCODE
		e  d //插入
		.//s ^kmlFormTest2(count)=data_"||"_Uom_"^"_subUom_"^"_eqqty
		.//0^150^74527^^&&^150^74527^3924^EqFromUnitPropId^0^&&^150^74527^3924^EqToUnitPropId^0^&&^150^74527^1^EqFactorProp^0^
		.s data1="0^"_libItemID_"^"_EqUnitProp_"^"_"^"
		.s data2="^"_libItemID_"^"_EqUnitProp_"^"_UomID_"^EqFromUnitPropId"_"^0^"
		.s data3="^"_libItemID_"^"_EqUnitProp_"^"_subUomID_"^EqToUnitPropId"_"^0^"
		.s data4="^"_libItemID_"^"_EqUnitProp_"^"_eqqty_"^EqFactorProp"_"^0^"
		.s data=data1_"&&"_data2_"&&"_data3_"&&"_data4
		.s err=##class(web.DHCCKBDicLinkAttr).saveDicAttrByType(data,"datagrid")
		.s:err'=0 Err=err
		.s count2=count2+1
		
	}  
	i Err=0 tc
	i Err'=0 tro
	w count_"条导入完成！更新："_count1_" 插入："_count2
	q ""
}

/// Descript:批量对照数据
/// Creator:sufan
/// CreateDate:2020-12-24
/// w ##class(web.DHCCKBComContrast).saveConDataBat("达可替尼片15mg(Pfizer Manufacturing Deutschland GMBH)^达可替尼片15mg(Pfizer Manufacturing Deutschland GMBH)^X210116004^换*洁芙柔速干手消毒液(500ml)^105","11870^8^1^289^2","113.140.81.66","122","")
ClassMethod saveConDataBat(params, loginInfo, clientIP, selHospId, symData = "")
{
	
	n (params,loginInfo, clientIP,selHospId,symData)	
	s params = ##class(web.DHCCKBComContrast).dealDeaseData(params)
	
	s err = 0
	TS
	s length = $l(params,"&&")
	for i=1:1:length  q:err'=0  d
	.s tempStr = $p(params,"&&",i)
	.s err = ##class(web.DHCCKBComContrast).SaveContrastData(tempStr,loginInfo,clientIP,selHospId,symData)
	.Q:err'=0
	i err'=0 Tro
	Q:err'=0 err
	TC
	Q err
}

/// Descript:批量对照数据
/// Creator:sufan
/// CreateDate:2020-12-24
ClassMethod ReplaceBrackets(str)
{
	n (str)
	
	s str = $tr(str,"）",")")
	s str = $tr(str,"（","(")
	
	q str
}

/// Descript:处理疾病对照数据[勾选分类，找相应分类的最后一级节点]
/// Creator:sufan
/// CreateDate:2022-5-26
/// w ##class(web.DHCCKBComContrast).dealDeaseData("上呼吸道感^上呼吸道感染^J00-J06^急性上呼吸道感染^115^213878")
ClassMethod dealDeaseData(params)
{
	n (params)
	s retStr = ""
	s length = $l(params,"&&")
	for i=1:1:length d
	.s tmpStr = $p(params,"&&",i)
	.s deasclsId = $p(tmpStr,"^",6)
	.i deasclsId=""  d
	..i retStr = ""  s retStr = tmpStr
	..e  s retStr = retStr_"&&"_tmpStr
	.e  d
	..s list = ..GetLastNode(tmpStr)
	..i retStr = ""  s retStr = list
	..e  s retStr = retStr_"&&"_list
	Q retStr
}

/// Descript:获取疾病的所有下级节点
/// Creator:sufan
/// CreateDate:2022-5-26
/// w ##class(web.DHCCKBComContrast).GetLastNode("骨质疏松^骨质疏松^A00.0^霍乱，由于O1群霍乱弧菌，霍乱生物型所致^115^205983")
ClassMethod GetLastNode(tmpStr)
{
	n (tmpStr)
	s retList = ""
	s hisCode = $p(tmpStr,"^",1)
	s hisDesc = $p(tmpStr,"^",2)
	s libCode = $p(tmpStr,"^",3)
	s libDesc = $p(tmpStr,"^",4)
	s dictionId = $p(tmpStr,"^",5)
	s deasclsId = $p(tmpStr,"^",6)
	i '$d(^CT.CKB.PDSS.CommonDictionI("Parref",deasclsId))  d
	.i retList = "" s retList = tmpStr
	.e  s retList = retList_"&&"_tmpStr
	e  d
	.s id = ""
	.for  s id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",deasclsId,id))	Q:id=""  d
	..s dicCode = $lg(^CT.CKB.PDSS.CommonDictionD(+id),2)
	..s dicDesc = $lg(^CT.CKB.PDSS.CommonDictionD(id),3)
	..s inList = hisCode_"^"_hisDesc_"^"_dicCode_"^"_dicDesc_"^"_dictionId_"^"_id
	..s ret = ..GetLastNode(inList)
	..i retList = "" s retList = ret
	..e  s retList = retList_"&&"_ret
	Q retList
}

/// Description:	判断数据是否属于当前医院
/// Creator:		QuNianpeng
/// CreateDate:		2021-04-23
/// Input:			代码，描述，医院id
/// return:			0不属于 1 属于
/// other:	w ##class(web.DHCCKBComContrast).CheckFlag("桂枝茯苓胶囊0.31g(江苏康缘药业股份有限公司)","桂枝茯苓胶囊0.31g(江苏康缘药业股份有限公司)",2)
/// w ##class(web.DHCCKBComContrast).CheckFlag("Y009123910","吡嗪酰胺片[0.25g*100片]",95)
ClassMethod CheckFlag(code, desc, hospID)
{
	n (code,desc,hospID)
	q:(code="")||(desc="")||(hospID="") 0
	
	q:'$d(^CKB.PDSS.ExtDictionI("Code",hospID,code)) 0
	//q:'$d(^CKB.PDSS.ExtDictionI("Desc",hospID,desc))&('$d(^CKB.PDSS.ExtDictionI("Desc",hospID,desc_"||"))) 0

	s existFlag = 0
	s extID = ""
	f  s extID = $o(^CKB.PDSS.ExtDictionI("Code",hospID,code,extID)) q:(extID="")||(existFlag=1)  d
	.s extData = $g(^CKB.PDSS.ExtDictionD(extID)) 
	.s extDesc = $lg(extData,3)
	.//i (extDesc=desc)||(extDesc=(desc_"||")) s existFlag = 1
	.i (extDesc=desc)||($p(extDesc,"||",1)=$p(desc,"||",1)) s existFlag = 1
	
	q existFlag
}

/// Description:	判断数据是否已经对照
/// Creator:		QuNianpeng
/// CreateDate:		2021-04-23
/// Input:			his代码，his描述，	系统代码，系统描述
/// return:			0不属于 1 属于
/// other:	w ##class(web.DHCCKBComContrast).ConstFlag("皮下注射","皮下注射","皮下注射","皮下注射","2")
ClassMethod ConstFlag(hisCode, hisDesc, libCode, libDesc, Hospt = "")
{
	n (hisCode,hisDesc,libCode,libDesc,Hospt)
	
	q:'$d(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(libCode),$$UPPER^SSUTIL4(hisCode))) 0
	q:'$d(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(libDesc),$$UPPER^SSUTIL4(hisDesc))) 0
	
	s exitFlag = 0
	s codeConstID = ""
	f  s codeConstID = $o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(libCode),$$UPPER^SSUTIL4(hisCode),codeConstID)) q:(codeConstID)=""||(exitFlag=1)  d
	.s descConstID = ""
	.f  s descConstID = $o(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(libDesc),$$UPPER^SSUTIL4(hisDesc),descConstID))  q:(descConstID)=""||(exitFlag=1)  d
	..i (Hospt'="")&&(codeConstID=descConstID)&&($d(^CKB.PDSS.ComContrastI("CCHospital",$$UPPER^SSUTIL4(libDesc),$$UPPER^SSUTIL4(hisDesc))))&&(Hospt=$lg(^CKB.PDSS.ComContrastD(contrID),7))  d
	...s exitFlag=1
	..e  i (Hospt="")&&(codeConstID=descConstID)  d
	...s exitFlag=1
	q exitFlag
}

/// Description:	根据his代码、描述找到对照的系统代码和描述
/// Creator:		QuNianpeng
/// CreateDate:		2021-05-07
/// Input:			his代码，his描述
/// return:			知识库代码、知识库描述
/// other:	w ##class(web.DHCCKBComContrast).GetSysConst()
ClassMethod GetSysConst(hisCode, hisDesc, type, hosp = "")
{
	n (hisCode, hisDesc, type,hosp)
	q:(hisCode="")||(hisDesc="")||(type="") ""

	s constID = "", exitFlag = 0
	s codeConstID = ""
	f  s codeConstID = $o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(hisCode),codeConstID)) q:(codeConstID)=""||(exitFlag=1)  d
	.s listData =$g(^CKB.PDSS.ComContrastD(codeConstID))
	.s tmpType = $lg(listData,6)
	.s constHosp = $lg(listData,7)
	.q:(hosp'="")&&(constHosp'=hosp)	
	.q:tmpType'=type
	.s tmpDesc = $lg(listData,5)
	.i tmpDesc = hisDesc  d
	..s exitFlag = 1
	..s constID = codeConstID
	.q:exitFlag=1
	.s descConstID = ""
	.f  s descConstID = $o(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(hisDesc),descConstID))  q:(descConstID)=""||(exitFlag=1)  d
	..s constHosp = $lg(^CKB.PDSS.ComContrastD(+descConstID),7)
	..q:(hosp'="")&&(constHosp'=hosp)	
	..i codeConstID=descConstID  d
	...s exitFlag=1
	...s constID = codeConstID
	
	q:+constID=0 ""
	s libCode = $lg(^CKB.PDSS.ComContrastD(+constID),2)
	s libDesc = $lg(^CKB.PDSS.ComContrastD(+constID),3)
	s constStr = libCode_"^"_libDesc
		
	q constStr
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-06-30
/// Descript: 	    判断系统的药品是否在当前医院对照
/// Input:			系统药品id,医院id
/// OutPut:			1 对照 0 未对照
/// w ##class(web.DHCCKBComContrast).IsSysContrast()
ClassMethod IsSysContrast(ItmId, HospId)
{
	n (ItmId,HospId)
		
	q:(+ItmId=0)||(+HospId=0) 0

	s LibCode = $lg(^CT.CKB.PDSS.CommonDictionD(ItmId),2)
	s LibDesc = $lg(^CT.CKB.PDSS.CommonDictionD(ItmId),3)
	q:(LibCode="")||(LibDesc="") 0 
	s IsPermissFlag=0
	s HisCode=""
	f  s HisCode=$o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(LibCode),HisCode)) q:(HisCode="")||(IsPermissFlag=1)  d
	.s CCRowID=""	
	.f  s CCRowID=$o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(LibCode),$$UPPER^SSUTIL4(HisCode),CCRowID))	q:(CCRowID="")||(IsPermissFlag=1)   d
	..s HisDesc = $lg(^CKB.PDSS.ComContrastD(+CCRowID),5)
	..s IsPermissFlag=..CheckFlag(HisCode,HisDesc,HospId)	// 对照是否授权
	..q:IsPermissFlag=1

	s Ret=IsPermissFlag
	
	q Ret
}

/// Description:	判断数据是否已经核对
/// Creator:		yuliping
/// CreateDate:		2021-07-23
/// Input:			his代码，his描述
/// return:			0没有核对 1 核对
/// other:	w ##class(web.DHCCKBComContrast).comfirmFlag("DrugData","注射用青霉素钠80万U(华北制药股份有限公司)","注射用青霉素钠80万U(华北制药股份有限公司)")
ClassMethod comfirmFlag(type, libCode, libDesc)
{
	n (type, libCode, libDesc)
	
	q:'$d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(libCode))) 0
	q:'$d(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(libDesc))) 0
	
	s id=0
	s exitFlag = 0
	s codeConstID = 0
	f  s codeConstID = $o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(libCode),codeConstID)) q:(codeConstID)=""  d
	.s parref = $lg(^CT.CKB.PDSS.CommonDictionD(+codeConstID),4)
	.q:+parref=0
	.s parrCode = $lg(^CT.CKB.PDSS.CommonDictionD(+parref),2)
	.q:type'=parrCode
	.s descConstID = ""
	.f  s descConstID = $o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(libDesc),descConstID))  q:(descConstID)=""  d
	..i codeConstID=descConstID s id=descConstID
	
	q:id=0 0
	i ($d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",id,"confirm"))) s exitFlag=1
	q exitFlag
}

/// Description:	批量删除已对照数据
/// Creator:		xww
/// CreateDate:		2021-07-06
/// Input:			params:已对照rowid串
/// return:			
/// other:			w ##class(web.DHCCKBComContrast).DeleteAllContrastData("560334&&560330")
ClassMethod DeleteAllContrastData(params As %String)
{
	
	n (params)
	s err = "{success:'true',info:'删除成功！'}"
	TS
	s length = $l(params,"&&")
	for i=1:1:length  q:err'["{success:'true',info:'删除成功！'}"  d
	.s rowid = $p(params,"&&",i)
	.s err = ##class(web.DHCCKBComContrast).DeleteContrastData(rowid)
	.Q:err'["{success:'true',info:'删除成功！'}"	
	i err'["{success:'true',info:'删除成功！'}" Tro
	Q:err'["{success:'true',info:'删除成功！'}" err
	TC
	Q err
}

/// w ##class(web.DHCCKBComContrast).test1()
ClassMethod test1()
{
	s libCode=1
	s libDesc=2
	s hisCode=3
	s hisDesc=3
	s typeId=5
	&sql(insert into CKB_PDSS.ComContrast (CC_LibCode,CC_LibDesc,CC_HisCode,CC_HisDesc,CC_DicType) values(
	:libCode,:libDesc,:hisCode,:hisDesc,:typeId
	))
	Q SQLCODE
}

}
