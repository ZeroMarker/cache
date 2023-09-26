Import sqluser

Class web.DHCCKBComImport Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	临时存储导入数据
/// Creator:		QuNianpeng
/// CreateDate:		2019-11-04
/// Input:			pid,数据,类型
/// return:			
/// other:			
/// w ##class(web.DHCCKBComImport).TmpImportData(20,"")
ClassMethod TmpImportData(pid, mListData, type)
{

	n (pid,mListData,type)
	
	i $CLASSNAME(mListData)="%CSP.CharacterStream" d
	.d ..InsTmpGlobalStream(pid, mListData,type)
	e  d
	.d ..InsTmpGlobalString(pid, mListData,type)
	q 0
}

/// Descript: 临时存储数据[流]
/// W ##Class(web.DHCCKBComImport).InsTmpGlobalStream("1","")
ClassMethod InsTmpGlobalStream(pid As %String, mListData, type) As %String
{
	n (pid, mListData,type)

	s spac="[next]"
	s rowspac="[row]"
	k TmpGlobal	
	
	d mListData.Rewind()
	while (mListData.AtEnd = 0) { 
		s IOStrLen=5000			
		s listData=mListData.Read(.IOStrLen)
		s connetData=$g(TmpGlobal(1))_""_listData
		i connetData[rowspac  d
		.f i=1:1:$L(connetData,rowspac) d
	    ..s mData=$p(connetData,rowspac,i)
	    ..i mData[$c(2) d	   
	    ...s row=$I(^TMPImport("Num",pid))	
	   	...s ^TMP("DHCCKB","web.DHCCKBComImport","TmpImportData",pid,type,row)=$p(mData,$c(2))
	   	...k TmpGlobal(1)
		..e  d
		...s TmpGlobal(1)=mData
		e  d
		.s TmpGlobal(1)=$g(TmpGlobal(1))_""_connetData			
	}
	
	if $g(TmpGlobal(1))["#" d
	.s row=$I(^TMPImport("Num",pid))
	.s ^TMP("DHCCKB","web.DHCCKBComImport","TmpImportData",pid,type,row)=$p($g(TmpGlobal(1)),"#")
	
	k TmpGlobal
	q ""
}

/// Descript: 临时存储数据[字符串]
/// W ##Class(web.DHCCKBRuleImport).InsTmpGlobal("1","")
ClassMethod InsTmpGlobalString(pid As %String, mListData, type) As %String
{
	n (pid, mListData,type)
	
	s spac="[next]"
	s rowspac="[row]"
	F i=1:1:$L(mListData,rowspac) D
	.s listData=$p(mListData,rowspac,i)
	.//s row=$p(listData,spac,1)+1	// 序号
	.s row=$I(^TMPImport("Num",pid))
	.s listData=$tr(listData,$c(2),"")
	.s ^TMP("DHCCKB","web.DHCCKBComImport","TmpImportData",pid,type,row)=listData
	.
	Q ""
}

/// Description:	存储导入数据
/// Creator:		QuNianpeng
/// CreateDate:		2019-11-04
/// Input:			pid,数据,类型
/// return:			
/// other:			
/// w ##class(web.DHCCKBComImport).SaveImprot("entity")
ClassMethod SaveImprot(type, LoginInfo = "", ClientIPAdd = "")
{
	n (type,LoginInfo,ClientIPAdd)
	s LgUserID=$p($g(LoginInfo),"^",1)
	s LgHospID=$p($g(LoginInfo),"^",5)
	s pid=1			// 进程号

	set $ZT="ERROR" // 设置一个异常
	s total=0,successNum=0,errNum=0 // 计数器 总数,成功,失败
	s msg=""		// 提示信息
	
	k ^TMP("DHCCKB","web.DHCCKBExport","ExportDataErrMsg",type,pid)
	;d ..CleanDrugCat(pid, type) //导入数据前删除关联
	;s outObj={}
	;d outObj.%Set("code","success").%Set("total",total).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg","")
	;q outObj.%ToJSON()
	;q ""
	s row="" 
	f  s row=$o(^TMP("DHCCKB","web.DHCCKBComImport","TmpImportData",pid,type,row))  q:row=""  d	
	.s total=total+1
	.s rowData=$g(^TMP("DHCCKB","web.DHCCKBComImport","TmpImportData",pid,type,row))
	.s rowObj=..StrToObj(rowData,type)	
	.q:rowObj.%Size()=0		// 空对象
	.s err=1
	.s num=rowObj.%Get("num")	// 行号
	.
	.TS
	.i type="drugcat"	d 
	..s linkCatID=0
	..d SaveDrugCat
	..i err=0 d SetTroInfo
	..q:err=0
	..d SaveDrugBase
	..i err=0 d SetTroInfo
	..q:err=0
	.
	.i (type="entity")||(type="dictionary")||(type="property")  d
	..s err=..SaveConfig(rowObj,type)
	.i err>0 do
	..s successNum=successNum+1
	..TCOMMIT
	.else  d SetTroInfo
	

	s outObj={}
	i (successNum'=0) 	d
	.d outObj.%Set("code","success").%Set("total",total).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg","")
	e  d
	.d outObj.%Set("code","err").%Set("total",total).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg",$case(msg,"":"系统错误,代码:"_$ZE,:msg))
	
	d ..killTmpGlobal(pid)
	
	q outObj.%ToJSON()
	
SaveDrugCat		// 药学分类

	;s catDataID=##class(web.DHCCKBCommon).GetDrugCategoryData()
	;i +catDataID=0 s err=0,msg="分类字典不存在,请先在字典表中增加药学分类!"
	;q:+catDataID=0 ""
	s catDataID=  122226  ;获取医保分类id根据所添加的目录不同修改（需根据项目实际ID）
	i +catDataID=0 s err=0,msg="医保分类不存在"
	q:+catDataID=0 ""
	
	// 一级分类
	s firstCode=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("firstCode"))
	s:firstCode'="" firstCode="A"_firstCode
	s firstDesc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("firstName"))
	i firstDesc="" s err=0,msg="一级分类描述不可以为空"
	q:firstDesc="" ""
	s codeNew=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("firstCodeNew"))
	s:codeNew'="" codeNew="A"_codeNew
	s descNew=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("firstNameNew"))
	//kml s firstID=##Class(web.DHCCKBRuleImport).SaveCommonDic(firstDesc,firstDesc,catDataID)		// 因分类的excel中 分类是01,02此类无意义的数字,因此用desc代替desc
	s firstID=##class(web.DHCCKBComImport).SaveOrUpdateDrugCat(firstCode,firstDesc,catDataID,codeNew,descNew,pid,LoginInfo,ClientIPAdd)
	i +firstID=0 s err=0,msg="一级分类保存失败"
	q:+firstID=0
	s linkCatID=firstID
	//保存分类别名
	s KeyStr=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("firstKey"))
	s ret= ##class(web.DHCCKBComImport).LinkOtherNameStr(KeyStr,linkCatID)
	i ret<0 s err=0,msg="一级分类别名关联失败"
	q:ret<0
	// 二级分类
	if (##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("secondName"))'=""){
		s code=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("secondCode"))
		s:code'="" code="A"_code
		s desc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("secondName"))
		i desc="" s err=0,msg="二级分类描述不可以为空"
		q:desc=""
		s codeNew=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("secondCodeNew"))
		s:codeNew'="" codeNew="A"_codeNew	
		s descNew=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("secondNameNew"))
		//kml s secondID=##Class(web.DHCCKBRuleImport).SaveCommonDic(desc,desc,firstID)
		s secondID=##class(web.DHCCKBComImport).SaveOrUpdateDrugCat(code,desc,firstID,codeNew,descNew,pid,LoginInfo,ClientIPAdd)
		i +secondID=0 s err=0,msg="二级分类保存失败"
		q:+secondID=0	
		s linkCatID=secondID		
		//保存分类别名
		s KeyStr=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("secondKey"))
		s ret= ##class(web.DHCCKBComImport).LinkOtherNameStr(KeyStr,linkCatID)
		i ret<0 s err=0,msg="二级分类别名关联失败"	
		q:ret<0	
		// 三级分类		
		if (##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("thirdName"))'=""){
			s code=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("thirdCode"))
			s desc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("thirdName"))
			s codeNew=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("thirdCodeNew"))	
			s descNew=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("thirdNameNew"))
			s:code'="" code="A"_code
			s:codeNew'="" codeNew="A"_codeNew
			//kml s thirdID=##Class(web.DHCCKBRuleImport).SaveCommonDic(desc,desc,secondID)
			s thirdID=##class(web.DHCCKBComImport).SaveOrUpdateDrugCat(code,desc,secondID,codeNew,descNew,pid,LoginInfo,ClientIPAdd)
			i +thirdID=0 s err=0,msg="三级分类保存失败"	
			q:+thirdID=0		
			s linkCatID=thirdID	
			//保存分类别名
			s KeyStr=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("thirdKey"))
			s ret= ##class(web.DHCCKBComImport).LinkOtherNameStr(KeyStr,linkCatID)
			i ret<0 s err=0,msg="三级分类别名关联失败"		
			q:ret<0
			// 四级分类
			if (##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fourthName"))'=""){
				s code=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fourthCode"))
				s desc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fourthName"))
				s codeNew=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fourthCodeNew"))
				s descNew=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fourthNameNew"))
				s:code'="" code="A"_code
				s:codeNew'="" codeNew="A"_codeNew					
				//kml s fourthID=##Class(web.DHCCKBRuleImport).SaveCommonDic(desc,desc,thirdID)
				s fourthID=##class(web.DHCCKBComImport).SaveOrUpdateDrugCat(code,desc,thirdID,codeNew,descNew,pid,LoginInfo,ClientIPAdd)
				i +fourthID=0 s err=0,msg="四级分类保存失败"		
				q:+fourthID=0
				s linkCatID=fourthID	
				//保存分类别名
				s KeyStr=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fourthKey"))
				s ret= ##class(web.DHCCKBComImport).LinkOtherNameStr(KeyStr,linkCatID)
				i ret<0 s err=0,msg="四级分类别名关联失败"
				q:ret<0
				// 五级分类					
				if (##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fifthName"))'=""){
					s code=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fifthCode"))
					s desc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fifthName"))
					s codeNew=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fifthCodeNew"))
					s descNew=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fifthNameNew"))
					s:code'="" code="A"_code
					s:codeNew'="" codeNew="A"_codeNew
					//kml s fifthID=##Class(web.DHCCKBRuleImport).SaveCommonDic(desc,desc,fourthID)
					s fifthID=##class(web.DHCCKBComImport).SaveOrUpdateDrugCat(code,desc,fourthID,codeNew,descNew,pid,LoginInfo,ClientIPAdd)
					i +fifthID=0 s err=0,msg="五级分类保存失败"
					q:+fifthID=0
					s linkCatID=fifthID	
					//保存分类别名
					s KeyStr=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fifthKey"))
					s ret= ##class(web.DHCCKBComImport).LinkOtherNameStr(KeyStr,linkCatID)
					i ret<0 s err=0,msg="五级分类别名关联失败"
					q:ret<0
				}
			}
		}				
	}

	i +linkCatID=0  s err=0,msg="分类不能为空" 
	q:+linkCatID=0 ""
	
	quit
	
	
SaveDrugBase	// 药品信息

	/// 通用名带剂型
	s itmDesc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("itmName"))
	s itmCode=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("itmCode"))
	;i itmDesc="" s err=0,msg="药品描述不能为空"
	q:itmDesc="" ""
	s itmID=0
	if (itmDesc'=""){
		;s drugDataID = ##class(web.DHCCKBCommon).GetDrugData()    
		s drugDataID = ##class(web.DHCCKBCommon).GetGeneralFromData() //带剂型的通用名 修改  shy 2021-6-3
		i +drugDataID=0 s err=0,msg="药品字典不存在,请先添加药品字典!"
		q:+drugDataID=0			
		s:itmCode="" itmDesc=itmCode
		;kml 2020-02-20 s itmID=##Class(web.DHCCKBRuleImport).SaveCommonDic(itmCode,itmDesc,drugDataID)	
		s itmID=##class(web.DHCCKBComImport).SaveOrUpdateCommonDic(itmCode,itmDesc,drugDataID,itmCode,LoginInfo,ClientIPAdd)	
	}
	
	q:+itmID=0
	
	s linkID=0,factorID=0
	// 生产企业/厂家 
	if (##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("itmFactory"))'=""){
		s factoryData=##class(web.DHCCKBCommon).GetManufacturerData()
		i +factoryData=0 s err=0,msg="生产企业字典不存在,请先添加生产企业字典!"
		q:+factoryData=0		
		s facDesc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("itmFactory"))
		s factorID=##Class(web.DHCCKBRuleImport).SaveCommonDic(facDesc,facDesc,factoryData)	
		i +factorID=0 s err=0,msg="生产企业保存失败!"
		q:+factorID=0
		s manf=##class(web.DHCCKBCommon).GetDrugManf()
		;q:$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",itmID,manf))	
		i '$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",itmID,manf,factorID))  d
		.s linkID=##class(web.DHCCKBRuleImport).SaveCommonDicLinkAttr(itmID,"drugManf",factorID,"")
		if linkID<0 s err=0,msg="生产企业和药品关联失败!"
		q:linkID<0
	
	}

	// 商品名 + 关联
	

	// 药学分类和药品的关系 
	s drugcat=##class(web.DHCCKBCommon).GetPhCategory()
	;kml-2020-01-19 q:$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",itmID,drugcat)) ""
	i '$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",itmID,drugcat,linkCatID))  d
	.s linkID=##class(web.DHCCKBRuleImport).SaveCommonDicLinkAttr(itmID,"drugCat",linkCatID,"")
	if linkID<0 s err=0,msg="药学分类和药品关联失败!"	
	q:linkID<0
	//其他药学分类和药品关联
	if (##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("otherCatName"))'=""){
		s otherCatNameStr=##class(web.DHCCKBCommonUtil).ReplaceStr(rowObj.%Get("otherCatName"),"/")
		;s otherCatNameStr=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("otherCatName"))
		s ret= ##class(web.DHCCKBComImport).LinkOtherCatStr(otherCatNameStr,itmID,"/",pid)
		i ret<0 s err=0,msg="其他药学分类和药品关联关联失败"
		q:ret<0
	}
	;s ^kmlkk(3)=111
	// 商品名 + 关联	
	if (##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("proName"))'=""){
		s proNameData=##class(web.DHCCKBCommon).GetDrugProNameData()
		q:+proNameData=0	
		s proNameCode=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("itmProCode"))
		s proNameCodeNew=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("itmProCodeNew")) //新商品编码	
		s proNameDesc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("proName"))
		;kml 2020-02-20 s proNameID=##Class(web.DHCCKBRuleImport).SaveCommonDic(proNameCode,proNameDesc,proNameData)
		s proNameID=##class(web.DHCCKBComImport).SaveOrUpdateCommonDic(proNameCode,proNameDesc,proNameData,proNameCodeNew)	
		if +proNameID=0 s err=0,msg="商品名保存失败!"		
		q:+proNameID=0
		s proNameProp=##class(web.DHCCKBCommon).GetProNameProp()
		;i '$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",itmID,proNameProp))  d
		i '$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",itmID,proNameProp,proNameID))  d
		.s linkID=##class(web.DHCCKBRuleImport).SaveCommonDicLinkAttr(itmID,proNameProp,proNameID,"")
		if linkID<0 s err=0,msg="商品名和药品关联失败!"	
		q:linkID<0
		
		s manf=##class(web.DHCCKBCommon).GetDrugManf()
		i (factorID'=0)&&('$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",proNameID,manf,factorID)))  d
		.s linkID=##class(web.DHCCKBRuleImport).SaveCommonDicLinkAttr(proNameID,"drugManf",factorID,"")
		if linkID<0 s err=0,msg="生产企业和商品名关联失败!"
		q:linkID<0
	}
	;s ^kmlkk(2)=111
	//通用名+关联
	s GeneralNameID=0
	if (##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("GeneralName"))'=""){
		
		s GeneralData=##class(web.DHCCKBCommon).GetDicIdByCode("GeneralData") //放到common
		if +GeneralData=0 s err=0,msg="通用名字典不存在!"	
		q:+GeneralData=0	
		s GeneralName=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("GeneralName"))	
		s GeneralCode=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("GeneralCode"))
		s NewGeneralCode=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("NewGeneralCode"))
		s:NewGeneralCode="" NewGeneralCode=GeneralCode
		;s GeneralNameID=##Class(web.DHCCKBRuleImport).SaveCommonDic(GeneralCode,GeneralName,GeneralData)	
		s GeneralNameID=##class(web.DHCCKBComImport).SaveOrUpdateCommonDic(NewGeneralCode,GeneralName,GeneralData,NewGeneralCode)
		;s ^kmlkk(1)=GeneralNameID_"^"_GeneralCode_"^"_GeneralName_"^"_GeneralData
		if +GeneralNameID=0 s err=0,msg="通用名保存失败!"
		q:+GeneralNameID=0
		s GeneralNameProp=##class(web.DHCCKBCommon).GetDrugGenerName()
		;q:$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",itmID,GeneralNameProp))
		i '$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",itmID,GeneralNameProp,GeneralNameID))  d
		.s linkID=##class(web.DHCCKBRuleImport).SaveCommonDicLinkAttr(itmID,GeneralNameProp,GeneralNameID,"")
		if linkID<0 s err=0,msg="药品和药品通用名关联失败!"	
		q:linkID<0
		
	}
	q:GeneralNameID=0
	//别名+关联 
	if (##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("generOtherName"))'=""){
		s OtherNameStr=##class(web.DHCCKBCommonUtil).ReplaceStr(rowObj.%Get("generOtherName"),"/")
		;s OtherNameStr=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("generOtherName"))
		s ret= ##class(web.DHCCKBComImport).LinkOtherNameStr(OtherNameStr,GeneralNameID,"/")
		i ret<0 s err=0,msg="通用名和别名关联失败"
		q:ret<0
	}
	quit
	
SetTroInfo
	tro
	s errNum=errNum+1
	s ^TMP("DHCCKB","web.DHCCKBExport","ExportDataErrMsg",pid,type,row)=rowData_"[next]"_"errMsg"_$c(1)_msg	// 记录提交失败信息
	Quit


ERROR
	set errorMsg=$ZE                  //$ZE 获取错误信息
	TROLLBACK	                      //有异常，则回滚事务(Golbal才可以回滚,普通变量不能回滚)
	s ^TMP("DHCCKB","web.DHCCKBExport","ExportDataErrMsg",pid,type,row)=rowData	// 记录提交失败信息
	s outObj={}
	d outObj.%Set("code","err").%Set("total",total).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg","系统错误,代码"_errorMsg)
	d ..killTmpGlobal(pid)
	
	Quit outObj.%ToJSON()             //返回错误信息
}

/// Description:	存储导入数据(药学分类改成别名)		
/// w ##class(web.DHCCKBComImport).SaveImprot("entity")
ClassMethod SaveImprotCat(type, OldLgUserID, ClientIPAdd)
{
	n (type,OldLgUserID,ClientIPAdd)
	
	s pid=1			// 进程号

	set $ZT="ERRORNEW" // 设置一个异常
	s total=0,successNum=0,errNum=0 // 计数器 总数,成功,失败
	s msg=""		// 提示信息
	
	k ^TMP("DHCCKB","web.DHCCKBExport","ExportDataErrMsg",type,pid)
	;d ..CleanDrugCat(pid, type) //导入数据前删除关联
	s row="" 
	f  s row=$o(^TMP("DHCCKB","web.DHCCKBComImport","TmpImportData",pid,type,row))  q:row=""  d	
	.s total=total+1
	.s rowData=$g(^TMP("DHCCKB","web.DHCCKBComImport","TmpImportData",pid,type,row))
	.s rowObj=..StrToObj(rowData,type)	
	.q:rowObj.%Size()=0		// 空对象
	.s err=1
	.s num=rowObj.%Get("num")	// 行号
	.
	.TS
	.i type="drugcat"	d 
	..s linkCatID=0
	..d SaveDrugCatNew
	..i err=0 d SetTroInfoNew
	..q:err=0
	.
	.i (type="entity")||(type="dictionary")||(type="property")  d
	..s err=..SaveConfig(rowObj,type)
	.//b //12
	.i err>0 do
	..s successNum=successNum+1
	..TCOMMIT
	.else  d SetTroInfoNew
	

	s outObj={}
	i (successNum'=0) 	d
	.d outObj.%Set("code","success").%Set("total",total).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg","")
	e  d
	.d outObj.%Set("code","err").%Set("total",total).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg",$case(msg,"":"系统错误,代码:"_$ZE,:msg))
	
	d ..killTmpGlobal(pid)
	
	q outObj.%ToJSON()
	
SaveDrugCatNew	// 药学分类

	s catDataId=##class(web.DHCCKBCommon).GetDrugCategoryData()
	i +catDataId=0 s err=0,msg="分类字典不存在,请先在字典表中增加药学分类!"
	q:+catDataId=0 ""
	
	// 新分类
	s catId=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("catId"))
	i +catId=0  s err=0,msg="分类不能为空" 
	q:+catId=0 ""

	//获取待停用的分类ID
	s stopCatStr=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("stopCatStr"))
	//规则替换 用新分类替换待停用的分类	
	//停用分类
	s ret=##class(web.DHCCKBComImport).ReplaceCatStrInRule(catId, catDataId, stopCatStr, sep = ",", OldLgUserID, ClientIPAdd)
	i ret<0 s err=0,msg="规则替换或停用失败"
	q:ret<0
	//别名关联 用新分类关联待停用的分类为别名
	s ret= ##class(web.DHCCKBComImport).LinkOtherNameStr(stopCatStr,catId)
	i ret<0 s err=0,msg="分类别名关联失败"
	q:ret<0
	
	quit
	
	
SetTroInfoNew
	tro
	s errNum=errNum+1
	s ^TMP("DHCCKB","web.DHCCKBExport","ExportDataErrMsg",pid,type,row)=rowData_"[next]"_"errMsg"_$c(1)_msg	// 记录提交失败信息
	Quit


ERRORNEW
	set errorMsg=$ZE                  //$ZE 获取错误信息
	TROLLBACK	                      //有异常，则回滚事务(Golbal才可以回滚,普通变量不能回滚)
	s ^TMP("DHCCKB","web.DHCCKBExport","ExportDataErrMsg",pid,type,row)=rowData	// 记录提交失败信息
	s outObj={}
	d outObj.%Set("code","err").%Set("total",total).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg","系统错误,代码"_errorMsg)
	d ..killTmpGlobal(pid)
	
	Quit outObj.%ToJSON()             //返回错误信息
}

/// 特定格式的字符串转换为对象 		//	通用名$c(1)阿莫西林 [next] 剂型2$c(1) 片剂	
/// w ##class(web.DHCCKBComImport).StrToObj("编码1"_$c(1)_"11111[next]药品商品名1"_$c(1)_"阿莫西林").%ToJSON()
ClassMethod StrToObj(mData, type = "") As %String
{
	n (mData,type)
	
	s spec="[next]"
	s del=$c(1)
	s len=$length(mData,spec)
	s dataObj={}

	f i=1:1:len	d
	.s tmpData=$p(mData,spec,i)
	.s key=$p(tmpData,del,1)
	.i type="drugcat" d
	..s key=..SetCatKey(key)
	.e  d
	..s key=..SetCommonKey(key)
	.
	.s value=$p(tmpData,del,2)
	.d dataObj.%Set(key,value)
	
	q dataObj
}

/// 生成整行对象的key
/// w ##class(web.DHCCKBComImport).SetRowKey(20,"")
ClassMethod SetCatKey(key) As %String
{
	n (key)

	s keyObj={}
	
	d keyObj.%Set("序号","seqNo").%Set("一级编码","firstCode").%Set("一级名称","firstName").%Set("一级别名","firstKey") //second third fourth fifth
	d keyObj.%Set("二级编码","secondCode").%Set("二级名称","secondName").%Set("二级别名","secondKey")
	d keyObj.%Set("三级编码","thirdCode").%Set("三级名称","thirdName").%Set("三级别名","thirdKey")
	d keyObj.%Set("四级编码","fourthCode").%Set("四级名称","fourthName").%Set("四级别名","fourthKey")
	d keyObj.%Set("五级编码","fifthCode").%Set("五级名称","fifthName").%Set("五级别名","fifthKey")
	d keyObj.%Set("其他分类名称","otherCatName")
	d keyObj.%Set("别名","generOtherName").%Set("通用名称（含剂型）编码","itmCode").%Set("通用名称（含剂型）","itmName").%Set("编码","itmProCode")
	d keyObj.%Set("新编码","itmProCodeNew").%Set("商品名","proName").%Set("厂家","itmFactory").%Set("num","num").%Set("errMsg","errMsg")
	d keyObj.%Set("通用名","GeneralName").%Set("通用名代码","GeneralCode").%Set("新通用名代码","NewGeneralCode")
	//五级分类更新
	d keyObj.%Set("新一级编码","firstCodeNew").%Set("新一级名称","firstNameNew") 
	d keyObj.%Set("新二级编码","secondCodeNew").%Set("新二级名称","secondNameNew")
	d keyObj.%Set("新三级编码","thirdCodeNew").%Set("新三级名称","thirdNameNew")
	d keyObj.%Set("新四级编码","fourthCodeNew").%Set("新四级名称","fourthNameNew")
	d keyObj.%Set("新五级编码","fifthCodeNew").%Set("新五级名称","fifthNameNew")
	q keyObj.%Get(key)
}

/// 生成整行对象的key
/// w ##class(web.DHCCKBComImport).SetRowKey(20,"")
ClassMethod SetCommonKey(key) As %String
{
	n (key)

	s keyObj={}
	
	d keyObj.%Set("num","num").%Set("代码","itmCode").%Set("描述","itmDesc").%Set("父级节点","parent")	
	q keyObj.%Get(key)
}

/// w ##class(web.DHCCKBComImport).SetRowKey(20,"")
ClassMethod SaveConfig(knowObj, type) As %String
{
	n (knowObj,type)
	
	s knowType="",ret=1
	if (type = "property"){		// 属性配置	
		s knowType=##class(web.DHCCKBCommon).GetAttrFlag()
					
	}elseif (type = "dictionary"){	// 字典配置
		s knowType=##class(web.DHCCKBCommon).GetDictionFlag()	
		
	}elseif (type = "entity"){		// 实体配置
		s knowType=##class(web.DHCCKBCommon).GetModelFlag()		
	}
	
	s code=##Class(web.DHCCKBCommonUtil).ReplaceWordStr(knowObj.%Get("itmCode"))
	s desc=##Class(web.DHCCKBCommonUtil).ReplaceWordStr(knowObj.%Get("itmDesc"))
	s:code="" code=desc
	q:desc="" ""
	
	s parentCode=##Class(web.DHCCKBCommonUtil).ReplaceWordStr(knowObj.%Get("parent"))
	s:parentCode'="" parent=##class(web.DHCCKBCommon).GetDicIdByCode(parentCode)
	s parent=$case(+$g(parent)=0,1:"",:parent)
	s tmpid=##Class(web.DHCCKBRuleImport).SaveCommonDic(code,desc,parent)	
	q:tmpid<=0 0
			
	s attrCode=##class(web.DHCCKBCommon).GetKnowType()
	if (type = "property"){
		if (code="Prop"){
			s linkDr=##class(web.DHCCKBDicLinkAttr).SaveDicAttrNew("^"_tmpid_"^"_attrCode_"^"_knowType)	
			i linkDr'=0 s ret=0
		}
	}else{
		s linkDr=##class(web.DHCCKBDicLinkAttr).SaveDicAttrNew("^"_tmpid_"^"_attrCode_"^"_knowType)	
		i linkDr'=0 s ret=0
	}
		
	q ret
}

/// 导入分类前,清除药品和分类、药品和厂家的关联
ClassMethod CleanDrugCat(pid, type)
{
	n (pid,type)

	s row=""
	f  s row=$o(^TMP("DHCCKB","web.DHCCKBComImport","TmpImportData",pid,type,row))  q:row=""  d	
	.s rowData=$g(^TMP("DHCCKB","web.DHCCKBComImport","TmpImportData",pid,type,row))
	.q:rowData=""
	.s rowObj=..StrToObj(rowData,type)	
	.q:rowObj.%Size()=0	
	.s itmDesc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("itmName"))
	.s itmCode=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("itmCode"))	
	.s drugDataID = ##class(web.DHCCKBCommon).GetDrugData() //kml
	.;s dicID=..GetDidID(itmCode,itmDesc) //kml
	.s dicID=##class(web.DHCCKBRuleImport).CheckDictionExist(itmCode,itmDesc,drugDataID) //kml
	.q:dicID=0
	.s drugcat=##class(web.DHCCKBCommon).GetPhCategory()
	.s manf=##class(web.DHCCKBCommon).GetDrugManf()
	.s proNameProp=##class(web.DHCCKBCommon).GetProNameProp()
	.s GeneralNameProp=##class(web.DHCCKBCommon).GetDrugGenerName()
	.d ##class(web.DHCCKBDrugVO).CleanDrugPropValue(dicID,drugcat)	 // 药品和分类
	.d ##class(web.DHCCKBDrugVO).CleanDrugPropValue(dicID,manf)    // 药品和厂家
	.d ##class(web.DHCCKBDrugVO).CleanDrugPropValue(dicID,proNameProp)    // 药品和商品名
	.d ##class(web.DHCCKBDrugVO).CleanDrugPropValue(dicID,GeneralNameProp)    // 药品和通用名
	.;s ^kml($i(^kml))=itmDesc
}

ClassMethod GetDidID(code, desc)
{
	n (code,desc)
	
	s codeID=0,descID=0
		
	i code'="" s codeID=##class(web.DHCCKBCommon).GetDicIdByCode(code)				// code是%时发生错误
	i desc'="" s descID=##class(web.DHCCKBCommon).GetDicIdByDesc(desc)
	
	q:(descID'=0)&(codeID'=descID) descID 	// 代码和描述同时存在，则以描述为主
	q:descID'=0 descID
	
	q codeID
}

ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	
	k ^TMP("DHCCKB","web.DHCCKBComImport","TmpImportData",pid)
}

/// d ##class(web.DHCCKBComImport).test()
ClassMethod test()
{
	
	s a=""
	
	f  s a=$o(^TMP("DHCCKB","web.DHCCKBComImport","TmpImportData",1,"property",a)) q:a=""  d
	.w ^TMP("DHCCKB","web.DHCCKBComImport","TmpImportData",1,"property",a),!
}

/// Description:	用新分类替换规则中的旧分类
/// Creator:		kemaolin 
/// CreateDate:		2020-05-15	
/// Input:			别名代码,别名描述,字典元素id
/// return:			成功 0，失败 <0
/// other:			w ##class(web.DHCCKBComImport).LinkOtherNameStr(otherNameStr, CatID, sep = "",OldLgUserID="",ClientIPAdd="")
ClassMethod ReplaceCatStrInRule(catId, catDataId, stopCatStr, sep = "", OldLgUserID = "", ClientIPAdd = "")
{
	n ( catId,catDataId, stopCatStr,sep,OldLgUserID,ClientIPAdd)
	s:sep="" sep="/"
	s len=$l(stopCatStr,sep)
	s ret=0
	for i=1:1:len  q:ret<0  d
	.s stopCatDesc=$p(stopCatStr,sep,i)
	.s stopCatDesc=##Class(web.DHCCKBCommonUtil).ReplaceWordStr(stopCatDesc)
	.q:stopCatDesc=""
	.s stopCatId=##class(web.DHCCKBDiction).CheckTreeRepeat(stopCatDesc, 106)
	.q:+stopCatId=0
	.//用新分类替换规则中的旧分类
	.s ret=##class(web.DHCCKBComImport).ReplaceCatInRule(catId,stopCatId)
	.q:ret<0
	.//InsertDicLog(DicDr, dataDr, Function, Operator, OperateDate, OperateTime, Scope, ScopeValue As %String, ClientIPAddress As %String, Type = "") As %String
	.s ret=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction",stopCatId,"stop",OldLgUserID,"","","","",ClientIPAdd,"log")
	q ret
}

/// Description:	用新分类替换规则中的旧分类
/// Creator:		kemaolin 
/// CreateDate:		2020-05-15	
/// Input:			别名代码,别名描述,字典元素id
/// return:			成功 0，失败 <0
/// other:			w ##class(web.DHCCKBComImport).ReplaceCatInRule(catId,oldCatId)
ClassMethod ReplaceCatInRule(catId, oldCatId)
{
	n (catId, oldCatId)
	s ruleId="" 
	s flag=0
	q:'$d(^CT.CKB.PDSS.RuleDataI("RightDic","Constant",+oldCatId)) flag
	f  s ruleId=$o(^CT.CKB.PDSS.RuleDataI("RightDic","Constant",+oldCatId,ruleId)) q:(ruleId="")||(flag<0)  d
	.q:ruleId=""
	.s flag=..UpdateRightDic(ruleId,catId)
}

/// Return:	SQLCODE
/// d ##class(web.DHCCKBComImport).UpdateRightDic()
ClassMethod UpdateRightDic(ruleId, catId)
{
	n (ruleId,catId)
	&sql(UPDATE CT_CKB_PDSS.RuleData SET RD_RightDic=:catId WHERE RD_Rule=:ruleId)
	
	q SQLCODE
}

/// Description:	关联别名(输入串)
/// Creator:		kemaolin 
/// CreateDate:		2020-02-13	
/// Input:			别名代码,别名描述,字典元素id
/// return:			成功 0，失败 <0
/// other:			w ##class(web.DHCCKBComImport).LinkOtherNameStr(otherNameStr, CatID, sep = "")
ClassMethod LinkOtherNameStr(otherNameStr, CatID, sep = "")
{
	n (otherNameStr,CatID,sep)
	s:sep="" sep="/"
	s len=$l(otherNameStr,sep)
	s ret=0
	for i=1:1:len  q:ret<0  d
	.s otherName=$p(otherNameStr,sep,i)
	.s otherName=##Class(web.DHCCKBCommonUtil).ReplaceWordStr(otherName)
	.q:otherName=""
	.s ret=##class(web.DHCCKBComImport).LinkOtherName(otherName, otherName, CatID)
	q ret
}

/// Description:	关联别名
/// Creator:		kemaolin 
/// CreateDate:		2020-02-13	
/// Input:			别名代码,别名描述,字典元素id
/// return:			成功 0，失败 <0
/// other:			w ##class(web.DHCCKBComImport).LinkOtherName(OCode, ODesc, CatID)
ClassMethod LinkOtherName(OCode, ODesc, CatID)
{
	n (OCode, ODesc, CatID)
	
	s flag=-1
	q:+CatID=0 flag
	s otherNameData=##class(web.DHCCKBCommon).GetOtherName()
	q:+otherNameData=0 flag
	s otherNameID=##Class(web.DHCCKBRuleImport).SaveCommonDic(OCode,ODesc,otherNameData)
	q:+otherNameID=0 flag
	s otherNameProp= ##class(web.DHCCKBCommon).GetDicIdByCode("OtherNameProp") //别名属性Id 写到common？
	i $d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",CatID,otherNameProp,otherNameID))  s flag=0
	i '$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",CatID,otherNameProp,otherNameID))  d
	.s flag=##class(web.DHCCKBRuleImport).SaveCommonDicLinkAttr(CatID,otherNameProp,otherNameID,"")

	q flag
}

/// Description:	药品关联其他药学分类(输入串)
/// Creator:		kemaolin 
/// CreateDate:		2020-02-13	
/// Input:			别名代码,别名描述,字典元素id
/// return:			成功 0，失败 <0
/// other:			w ##class(web.DHCCKBComImport).LinkOtherNameStr(otherNameStr, CatID, sep = "")
ClassMethod LinkOtherCatStr(otherCatStr, itemID, sep = "", pid)
{
	n (otherCatStr,itemID,sep,pid)
	s:sep="" sep="/"
	s len=$l(otherCatStr,sep)
	s ret=0
	for i=1:1:len  q:ret<0  d
	.s otherCat=$p(otherCatStr,sep,i)
	.s otherCat=##Class(web.DHCCKBCommonUtil).ReplaceWordStr(otherCat)
	.q:otherCat=""
	.s ret=##class(web.DHCCKBComImport).LinkOtherCat(otherCat, otherCat, itemID,pid)
	q ret
}

/// Description:	药品关联其他药学分类
/// Creator:		kemaolin 
/// CreateDate:		2020-02-13	
/// Input:			别名代码,别名描述,字典元素id
/// return:			成功 0，失败 <0
/// other:			w ##class(web.DHCCKBComImport).LinkOtherName(OCode, ODesc, CatID)
ClassMethod LinkOtherCat(OCode, ODesc, CatID, pid)
{
	n (OCode, ODesc, CatID,pid)
	
	s flag=-1
	q:+CatID=0 flag
	;s DrugCatData=##class(web.DHCCKBCommon).GetDrugCategoryData()
	s DrugCatData=##class(web.DHCCKBCommon).GetDicIdByCode("OtherDrugCat")
	q:+DrugCatData=0 flag
	;s otherCatID=##Class(web.DHCCKBRuleImport).SaveCommonDic("B"_OCode,ODesc,DrugCatData)
	s otherCatID=##class(web.DHCCKBComImport).SaveOrUpdateDrugCat("B"_OCode, ODesc, DrugCatData, "","", pid)
	q:+otherCatID=0 flag
	s DrugCatProp= ##class(web.DHCCKBCommon).GetPhCategory()
	i $d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",CatID,DrugCatProp,otherCatID))  s flag=0
	i '$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",CatID,DrugCatProp,otherCatID))  d
	.s flag=##class(web.DHCCKBRuleImport).SaveCommonDicLinkAttr(CatID,DrugCatProp,otherCatID,"")

	q flag
}

/// Description:	保存和更新代码和描述（用于商品名、带机型通用名编码更新）
/// Creator:		QuNianpeng 
/// CreateDate:		2019-07-08	
/// Input:			代码,描述,所属字典表id
/// return:			成功id，失败代码<0
/// other:			w ##class(web.DHCCKBComImport).SaveOrUpdateCommonDic("","",4003)
ClassMethod SaveOrUpdateCommonDic(code, desc, parref, newCode = "", LoginInfo = "", ClientIPAdd = "")
{
	n (code,desc,parref,newCode,LoginInfo,ClientIPAdd)
	
	s LgUserID=$p($g(LoginInfo),"^",1)
	s LgHospID=$p($g(LoginInfo),"^",5)
	q:(code="")&(desc="") 0
	/*
	s codeID=##class(web.DHCCKBCommon).GetDicIdByCode(code)				// code是%时发生错误
	s descID=##class(web.DHCCKBCommon).GetDicIdByDesc(desc)
	q:(descID'=0)&(codeID'=descID) descID 	// 代码和描述同时存在，则以描述为主
	q:descID'=0 descID
	*/
	s dicID=##class(web.DHCCKBRuleImport).CheckDictionExist("",desc,parref)
	//更新描述
	s SQLCode=0
	i (dicID'=0)&&(newCode'="") d 
	.s SQLCode=##class(web.DHCCKBDiction).UpdateDic(dicID_"^"_newCode_"^"_desc_"^"_parref)
	.s:LoginInfo'="" retlog=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction", dicID, "edit", LgUserID, "", "", "D", LgHospID, ClientIPAdd,"log") //添加字典日志 shy 2021-6-4
	q:SQLCode'=0 0
	
	q:+dicID'=0 dicID
	s dicID=0
	s dicID=##class(web.DHCCKBDiction).SaveDic("^"_code_"^"_desc_"^"_parref)	//保存
	s:LoginInfo'="" retlog=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction", dicID, "add", LgUserID, "", "", "D", LgHospID, ClientIPAdd,"log") //添加字典日志 shy 2021-6-4
	s:LoginInfo'="" retacc=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction", dicID, "grantAuth", LgUserID, "", "", "D", LgHospID, ClientIPAdd,"acc")
	q dicID
}

ClassMethod addDrugCat(pid, desc, descID)
{
	n (pid,desc,descID)
	i '$d(^TMP("DHCCKB","web.DHCCKBComImport","SaveOrUpdateDrugCat",pid,desc))  d
	.s ^TMP("DHCCKB","web.DHCCKBComImport","SaveOrUpdateDrugCat",pid,desc)=descID
}

ClassMethod delDrugCat(pid, desc)
{
	n (pid,desc)
	i $d(^TMP("DHCCKB","web.DHCCKBComImport","SaveOrUpdateDrugCat",pid,desc))  d
	.s ^TMP("DHCCKB","web.DHCCKBComImport","SaveOrUpdateDrugCat",pid,desc)=0
}

ClassMethod checkDrugCat(pid, desc)
{
	n (pid,desc)

	q +$g(^TMP("DHCCKB","web.DHCCKBComImport","SaveOrUpdateDrugCat",pid,desc))
}

ClassMethod killDrugCat(pid, desc)
{
	n (pid,desc)

	k ^TMP("DHCCKB","web.DHCCKBComImport","SaveOrUpdateDrugCat",pid,desc)
}

/// Description:	保存和更新五级分类
/// Creator:		kemaolin 
/// CreateDate:		2020-02-18
/// Input:			代码,描述,所属字典表id，新代码，新描述
/// return:			成功id，失败代码<0
/// other:			w ##class(web.DHCCKBComImport).SaveOrUpdateDrugCat("AZA01AA", "辛温解表剂", 120998,"","", pid)
ClassMethod SaveOrUpdateDrugCat(code, desc, parref, codeNew = "", descNew = "", pid, LoginInfo = "", ClientIPAdd = "")
{
	n (code, desc, parref, codeNew,descNew,pid,LoginInfo,ClientIPAdd)
	//^TMP("DHCCKB","web.DHCCKBComImport","SaveOrUpdateDrugCat",pid,desc)
	s LgUserID=$p($g(LoginInfo),"^",1)
	s LgHospID=$p($g(LoginInfo),"^",5)
	q:desc="" ""
	s dicID=0
	//s descID=##class(web.DHCCKBCommon).GetDicIdByDesc(desc)
	s descID=##class(web.DHCCKBCommon).GetDicIdByCode(code)    //shy 2021-6-4  将描述判断改为code  确保唯一性！
	i (descNew="")  d
	.s:codeNew'="" code=codeNew
	.i +descID=0  d
	..s dicID=##class(web.DHCCKBDiction).SaveDic("^"_code_"^"_desc_"^"_parref)
	..s:LoginInfo'="" retlog=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction", dicID, "add", LgUserID, "", "", "D", LgHospID, ClientIPAdd,"log") //添加字典日志 shy 2021-6-4
	..s:LoginInfo'="" retacc=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction", dicID, "grantAuth", LgUserID, "", "", "D", LgHospID, ClientIPAdd,"acc")
	..d ..addDrugCat(pid, desc, 0)
	.e  d
	..d ..addDrugCat(pid,desc,descID)
	..i ..checkDrugCat(pid,desc)'=0  d
	...s SQLCode=##class(web.DHCCKBDiction).UpdateDic(descID_"^"_code_"^"_desc_"^"_parref)
	...s:LoginInfo'="" retlogedit=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction", dicID, "edit", LgUserID, "", "", "D", LgHospID, ClientIPAdd,"log") //添加字典日志 shy 2021-6-4
	...s:SQLCode=0 dicID=descID
	...i SQLCode=0 d ..delDrugCat(pid, desc)
	..e  d
	...i parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+descID)),4) s dicID=descID
	...q:parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+descID)),4)
	...i '$d(^CT.CKB.PDSS.CommonDictionI("LinkParrefDr",descID,parref))  d
	....s dicID=##class(web.DHCCKBDiction).SaveDic("^"_"^"_"^"_parref_"^"_descID)
	....s:LoginInfo'="" retlogadd=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction", dicID, "add", LgUserID, "", "", "D", LgHospID, ClientIPAdd,"log") //添加字典日志 shy 2021-6-4
	...e  d
	....s dicID=$o(^CT.CKB.PDSS.CommonDictionI("LinkParrefDr",descID,parref,""))
	e  d
	.s descIDNew=##class(web.DHCCKBCommon).GetDicIdByDesc(descNew)
	.s:codeNew="" codeNew=code
	.
	.i (+descIDNew=0)&&(+descID=0) d
	..s dicID=##class(web.DHCCKBDiction).SaveDic("^"_codeNew_"^"_descNew_"^"_parref)
	..s:LoginInfo'="" retlogadd=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction", dicID, "add", LgUserID, "", "", "D", LgHospID, ClientIPAdd,"log") //添加字典日志 shy 2021-6-4
	..d ..addDrugCat(pid, descNew, 0) ////////////
	.
	.i (+descIDNew=0)&&(+descID'=0) d
	..d ..addDrugCat(pid, desc, descID)
	..i ..checkDrugCat(pid,desc)'=0  d
	...s SQLCode=##class(web.DHCCKBDiction).UpdateDic(descID_"^"_codeNew_"^"_descNew_"^"_parref)
	...s:LoginInfo'="" retlogedit=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction", descID, "edit", LgUserID, "", "", "D", LgHospID, ClientIPAdd,"log") //添加字典日志 shy 2021-6-4
	...s:SQLCode=0 dicID=descID
	...i SQLCode=0 d ..killDrugCat(pid, desc)
	...i SQLCode=0 d ..addDrugCat(pid, descNew,0)
	..e  d
	...;i parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+descID)),4) s dicID=descID
	...;q:parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+descID)),4)
	...;i $d(^CT.CKB.PDSS.CommonDictionI("LinkParrefDr",descIDNew,parref))  d
	...;.s dicID=$o(^CT.CKB.PDSS.CommonDictionI("LinkParrefDr",descIDNew,parref))
	...
	...s dicID=##class(web.DHCCKBDiction).SaveDic("^"_codeNew_"^"_descNew_"^"_parref)
	...s:LoginInfo'="" retlogadd=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction", dicID, "add", LgUserID, "", "", "D", LgHospID, ClientIPAdd,"log") //添加字典日志 shy 2021-6-4
	...d ..addDrugCat(pid, codeNew, 0)
	.
	.i (+descIDNew'=0) d
	..d ..addDrugCat(pid, descNew, descIDNew)
	..i descID'=0 d ..addDrugCat(pid, desc, descID)
	..i ..checkDrugCat(pid,descNew)'=0  d
	...s SQLCode=##class(web.DHCCKBDiction).UpdateDic(descIDNew_"^"_codeNew_"^"_descNew_"^"_parref)
	...s:SQLCode=0 dicID=descIDNew
	...i SQLCode=0 d ..delDrugCat(pid, descNew)
	..e  d
	...i parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+descIDNew)),4) s dicID=descIDNew
	...q:parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+descIDNew)),4)
	...i $d(^CT.CKB.PDSS.CommonDictionI("LinkParrefDr",descIDNew,parref))  d
	....s dicID=$o(^CT.CKB.PDSS.CommonDictionI("LinkParrefDr",descIDNew,parref,""))
	...e  d
	....i +..checkDrugCat(pid,desc)'=0  d
	.....s SQLCode=##class(web.DHCCKBDiction).UpdateDic(descID_"^"_"^"_"^"_parref_"^"_descIDNew)
	.....s:SQLCode=0 dicID=descID
	.....i SQLCode=0 d ..killDrugCat(pid, desc)
	....e  d
	.....s dicID=##class(web.DHCCKBDiction).SaveDic("^"_"^"_"^"_parref_"^"_descIDNew)
	
	q dicID
}

/// other:	w ##class(web.DHCCKBComImport).queryUnuseCat(1)
ClassMethod queryUnuseCat(pid)
{
	
	n (pid)
	s desc=""
	f  s desc=$o(^TMP("DHCCKB","web.DHCCKBComImport","SaveOrUpdateDrugCat",pid,desc)) q:desc=""  d
	.i ^TMP("DHCCKB","web.DHCCKBComImport","SaveOrUpdateDrugCat",pid,desc)'=0  d
	..w !,desc
	q ""
}

/// Debug w ##class(web.DHCCKBComImport).getDrugCat(50032) 149
ClassMethod getDrugCat(parref, pid)
{
	n (parref,pid)
	q:+parref=0 
	s catID=""
	f  s catID= $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,catID)) q:catID=""  d
	.q:catID="" 
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),3)
	.q:desc=""
	.;b ;11
	.i '$d(^TMP("DHCCKB","web.DHCCKBComImport","SaveOrUpdateDrugCat",pid,desc))  d
	..w !,desc 
	.e  d
	..i ^TMP("DHCCKB","web.DHCCKBComImport","SaveOrUpdateDrugCat",pid,desc)'=0  d
	...w !,desc 
	.d ..getDrugCat(catID,pid)
}

/// 导出所有药学分类（test）
/// Debug d ##class(web.DHCCKBComImport).SortCatByCode(106)
ClassMethod SortCatByCode(parref = 106, otherFlag = 0)
{
	n (parref,otherFlag)
	q:+parref=0 
	s catID=""
	f  s catID= $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,catID)) q:catID=""  d
	.q:catID="" 
	.q:(otherFlag=1)&&((catID=50032)||(catID=50033))
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),2)
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),3)
	.s stop=0
	.//s:##class(web.DHCCKBCommon).GetStopDicDataByfunction(catID,"stop") stop=1 有bug
	.i $d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",+catID))  d
	..i $d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",+catID,"stop")) s stop=1
	.s:(desc'="")&&(stop=0) ^TMP("web.DHCPUEImport","SortCatByCode",catID)=desc_"^"_code
	.//b ;1
	.d ..SortCatByCode(catID,otherFlag)
}

/// d ##class(web.DHCCKBComImport).TestStreamForCat("D:/kml","新编药物学分类.txt",50032,0)
/// d ##class(web.DHCCKBComImport).TestStreamForCat("D:/kml","其他分类.txt",50033,0)
/// d ##class(web.DHCCKBComImport).TestStreamForCat("D:/kml","剩余分类.txt",106,1)
ClassMethod TestStreamForCat(dir, filename, DataId, otherFlag)
{
	/*
	"其他分类" --50033 "新编药物学分类" --50032
	"药品字典" --105 "药学分类字典"--106 "成分字典" --108 "疾病字典" --115 
	"职业字典" --119 "检验项字典" --123  特殊人群字典 117
	*/
	n (dir, filename, DataId, otherFlag)
	Set dir = ##class(%File).NormalizeDirectory(dir)
	if ('##class(%File).DirectoryExists(dir)){
		Do ##class(%File).CreateDirectoryChain(dir)
	}
	s fileFullPath=##class(%File).NormalizeDirectory(dir_"/"_filename)
	Set file = ##class(%FileCharacterStream).%New()
	Set file.Filename=fileFullPath
	
	s i=0
	k ^TMP("web.DHCPUEImport","SortCatByCode")
	d ##class(web.DHCCKBComImport).SortCatByCode(DataId,otherFlag)
	
	s count=0
	s id="" f  s id= $o(^TMP("web.DHCPUEImport","SortCatByCode",id)) q:id=""  d
	.q:id=""
	.s count=count+1
	.s desc=$p(^TMP("web.DHCPUEImport","SortCatByCode",id),"^",1)
	.s code=$p(^TMP("web.DHCPUEImport","SortCatByCode",id),"^",2)
	.//s stop=$p(^TMP("web.DHCPUEImport","SortCatByCode",id),"^",3)
	.q:desc=""
	.s line=id_" "_code_" "_desc
	.do file.WriteLine(line)
	
	s mdef=""
	Do file.Flush()
	Do file.%Save()
	Do file.%Close()
	s file=""
	k ^TMP("web.DHCPUEImport","SortCatByCode")
}

/// 导出通用名和药学分类字典重复的元素
/// 导出所有药学分类（test）
/// Debug d ##class(web.DHCCKBComImport).GetCatByDic(106)
ClassMethod GetCatByDic(parref = 106)
{
	n (parref)
	q:+parref=0 
	s catID=""
	f  s catID= $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,catID)) q:catID=""  d
	.q:catID="" 
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),2)
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),3)
	.s stop=0
	.//s:##class(web.DHCCKBCommon).GetStopDicDataByfunction(catID,"stop") stop=1 有bug
	.i $d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",+catID))  d
	..i $d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",+catID,"stop")) s stop=1
	.s:(desc'="")&&(stop=0) ^TMP("web.DHCCKBComImport","GetCatByDic",catID)=desc_"^"_code
	.d ..GetCatByDic(catID)
}

/// d ##class(web.DHCCKBComImport).GetRepeatFormGenAndCat("D:/kml","别名和药学分类重复项.txt",106)
ClassMethod GetRepeatFormGenAndCat(dir, filename, DataId)
{
	/*
	"其他分类" --50033 "新编药物学分类" --50032
	"药品字典" --105 "药学分类字典"--106 "成分字典" --108 "疾病字典" --115 
	"职业字典" --119 "检验项字典" --123  特殊人群字典 117
	*/
	n (dir, filename, DataId)
	Set dir = ##class(%File).NormalizeDirectory(dir)
	if ('##class(%File).DirectoryExists(dir)){
		Do ##class(%File).CreateDirectoryChain(dir)
	}
	s fileFullPath=##class(%File).NormalizeDirectory(dir_"/"_filename)
	Set file = ##class(%FileCharacterStream).%New()
	Set file.Filename=fileFullPath
	
	s i=0
	k ^TMP("web.DHCCKBComImport","GetCatByDic")
	d ##class(web.DHCCKBComImport).GetCatByDic(DataId)
	
	s count=0
	s id="" f  s id= $o(^TMP("web.DHCCKBComImport","GetCatByDic",id)) q:id=""  d
	.q:id=""
	.s count=count+1
	.s desc=$p(^TMP("web.DHCCKBComImport","GetCatByDic",id),"^",1)
	.s code=$p(^TMP("web.DHCCKBComImport","GetCatByDic",id),"^",2)
	.s genId="",genCode="",genDesc=""
	.s tmpId="" f  s tmpId=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(desc),tmpId)) q:tmpId=""  d
	..s stop=0
	..i $d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",+tmpId))  d
	...i $d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",+tmpId,"stop")) s stop=1
	..q:stop=1
	..s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+tmpId)),4)  //通用名字典 49802 成分字典108 别名 26942
	..i parref=26942 d
	...s genId=tmpId
	...s genCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(+tmpId)),2) 
	...s genDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+tmpId)),3) 
	.q:(desc="")||(genDesc="")
	.s line=id_" "_code_" "_desc_" "_genId_" "_genCode_" "_genDesc
	.do file.WriteLine(line)
	
	s mdef=""
	Do file.Flush()
	Do file.%Save()
	Do file.%Close()
	s file=""
	k ^TMP("web.DHCCKBComImport","GetCatByDic")
}

/// Description	按层级关系导出分类
/// d ##class(web.DHCCKBComImport).TestStreamForLevelCat("D:/kml","其他分类层级.txt",50033)
ClassMethod TestStreamForLevelCat(dir, filename, DataId)
{
	/*
	"其他分类" --50033 "新编药物学分类" --50032
	"药品字典" --105 "药学分类字典"--106 "成分字典" --108 "疾病字典" --115 
	"职业字典" --119 "检验项字典" --123  特殊人群字典 117
	*/
	n (dir, filename, DataId)
	Set dir = ##class(%File).NormalizeDirectory(dir)
	if ('##class(%File).DirectoryExists(dir)){
		Do ##class(%File).CreateDirectoryChain(dir)
	}
	s fileFullPath=##class(%File).NormalizeDirectory(dir_"/"_filename)
	Set file = ##class(%FileCharacterStream).%New()
	Set file.Filename=fileFullPath
	
	s i=0
	k ^TMP("web.DHCCKBComImport","GetLevelCatByDic")
	d ##class(web.DHCCKBComImport).GetLevelCatByDic(DataId)
	
	s count=0
	s id="" f  s id= $o(^TMP("web.DHCCKBComImport","GetLevelCatByDic",id)) q:id=""  d
	.q:id=""
	.s count=count+1
	.s res=##class(web.DHCCKBComImport).getDrugCat1(id,DataId)
	.do file.WriteLine(res)
	
	s mdef=""
	Do file.Flush()
	Do file.%Save()
	Do file.%Close()
	s file=""
	k ^TMP("web.DHCCKBComImport","GetLevelCatByDic")
}

/// 导出通用名和药学分类字典重复的元素
/// 导出所有药学分类（test）
/// Debug d ##class(web.DHCCKBComImport).GetLevelCatByDic(106)
ClassMethod GetLevelCatByDic(parref = 106)
{
	n (parref)
	q:+parref=0 
	s ChildNum=0,catID=""
	f  s catID= $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,catID)) q:catID=""  d
	.q:+catID=0
	.s ChildNum=ChildNum+1,stop=0
	.i $d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",+catID))  d
	..i $d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",+catID,"stop")) s ChildNum=ChildNum-1,stop=1
	.i stop=0 d ..GetLevelCatByDic(catID)
	//s:ChildNum=0 ^TMP("web.DHCCKBComImport","GetLevelCatByDic",parref)=parref
	s ^TMP("web.DHCCKBComImport","GetLevelCatByDic",parref)=parref
}

/// Debug w ##class(web.DHCCKBComImport).getDrugCat1(74911,50033)
ClassMethod getDrugCat1(catID, drugCatData)
{
	n (catID,drugCatData)
	q:catID="" ""
	s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),3)
	s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),4)
	s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),5)
	i (desc="")&&(linkDr'="") s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+linkDr)),3)
	
	q:parref=drugCatData desc
	q ..getDrugCat1(parref,drugCatData)_" "_desc
}

/// ////////////////////////////////////////////////////////////////////////////////////
/// 导出错误规则   相互作用和配伍禁忌中出现分类和通用名并且关系的数据
/// Debug d ##class(web.DHCCKBComImport).getErrRule()
ClassMethod getErrRule()
{
	k ^kmlErrRule
	s ^kmlErrRule=0
	s ruleId=""
	f  s ruleId=$o(^CT.CKB.PDSS.RuleD(ruleId))	 q:ruleId=""  d
	.q:'($d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,76))||$d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,75))) //相互作用 配伍禁忌
	.s dicId=""
	.i $d(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,105))  d //西药
	..s ruleDicId=$o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,105,""))
	..s dicId=$lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),3)
	.i $d(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,81790))  d //中成药
	..s ruleDicId=$o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,81790,""))
	..s dicId=$lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),3)
	.q:+dicId=0
	.s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+dicId)),3)
	.//药品日志找ip
	.s ip="",date=""
	.s dicLogDr=$o(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",dicId,"add",""))
	.s:dicLogDr'="" ip=$lg(^CKB.PDSS.DicLogD(dicLogDr),10)
	.s ruleLog=$o(^CKB.PDSS.RuleLogI("Rule",ruleId,""))
	.s:ruleLog'="" date=$lg(^CKB.PDSS.RuleLogD(ruleLog),4)
	.s:date'="" date=$zd(date,3)
	.s ruleNodeId="",RNParent=""
	.f  s ruleNodeId=$o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",0,ruleNodeId)) q:ruleNodeId=""  d
	..i $d(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",ruleNodeId))  d
	...
	...s ruleNodeIdCh="" f  s ruleNodeIdCh=$o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",ruleNodeId,ruleNodeIdCh)) q:ruleNodeIdCh=""  d
	....q:$lg($g(^CT.CKB.PDSS.RuleNodeD(ruleNodeIdCh)),3)'="and"
	....w dicDesc,!
	....s ruleDataId="" ,count=0
	....f  s ruleDataId=$o(^CT.CKB.PDSS.RuleDataI("Node",ruleNodeIdCh,ruleDataId)) q:ruleDataId=""  d
	.....s dicType=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),4)
	.....s:(dicType=38)||(dicType=39)||(dicType=42) count=count+1 //通用名 成分 分类
	....i count>1  d
	.....s ^kmlErrRule(dicId,ruleId)="^"_dicDesc_"^"_ruleId_"^"_ip_"^"_date
	.....s ^kmlErrRule=^kmlErrRule+1
	..
	..q:$lg($g(^CT.CKB.PDSS.RuleNodeD(ruleNodeId)),3)'="and"
	..s ruleDataId="" ,count=0
	..f  s ruleDataId=$o(^CT.CKB.PDSS.RuleDataI("Node",ruleNodeId,ruleDataId)) q:ruleDataId=""  d
	...s dicType=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),4)
	...s:(dicType=38)||(dicType=39)||(dicType=42) count=count+1 //通用名 成分 分类
	..i count>1  d
	...s ^kmlErrRule(dicId,ruleId)="^"_dicDesc_"^"_ruleId_"^"_ip_"^"_date
	...s ^kmlErrRule=^kmlErrRule+1
}

/// /////////////////////////////////////////////////////////////////////////
/// 补充分类 其他分类 50033
/// Debug d ##class(web.DHCCKBComImport).GetCatByDic2()
ClassMethod GetCatByDic2(parref = 50033)
{
	n (parref)
	q:+parref=0 
	s catID=""
	f  s catID= $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,catID)) q:catID=""  d
	.q:catID="" 
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),2)
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),3)
	.s LinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),5)
	.i (LinkDr'="")&&(desc="") s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+LinkDr)),3)
	.s stop=0
	.//s:##class(web.DHCCKBCommon).GetStopDicDataByfunction(catID,"stop") stop=1 有bug
	.i $d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",+catID))  d
	..i $d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",+catID,"stop")) s stop=1
	.//s:(desc'="")&&(stop=0) ^TMP("web.DHCCKBComImport","GetCatByDic2",desc,catID)=1
	.//b ;1
	.i (desc'="")&&(stop=0)  d
	..i $d(^TMP("web.DHCCKBComImport","GetCatByDic2",desc))  d
	...s ^TMP("web.DHCCKBComImport","GetCatByDic2",desc)=1
	..s ^TMP("web.DHCCKBComImport","GetCatByDic2",desc,catID)=1
	.d ..GetCatByDic2(catID)
}

/// Debug d ##class(web.DHCCKBComImport).ImportDrugCatDatas()
ClassMethod ImportDrugCatDatas() As %String
{
	TSTART
	//k ^TMP("web.DHCCKBComContrast","ImportDrugDatas")
	k ^TMP("web.DHCCKBComImport","GetCatByDic2")
	//k ^TMP("web.DHCCKBComImport","None")
	//k ^TMP("web.DHCCKBComImport","Repeat")
	//k ^kmlTmpCat  //存放删除的数据
	//k ^kmlTmpGen
	//k ^kmlTmpForm
	
	d ##class(web.DHCCKBComImport).GetCatByDic2()
	
	s errNum=0
	s count =0,count1 =0,count2 =0
	//s file=##class(%File).%New("D:\kml\补充分类删减.csv")
	s file=##class(%File).%New("D:\kml\补充分类补充别名.csv")
	d file.Open("RS")
	d file.ReadLine() //读取一行
	s count=0
	s Err=0
	s PhCategory=##class(web.DHCCKBCommon).GetPhCategory()
	while 'file.AtEnd
	{
		s Line=file.Read()
		continue:Line=""
		//s itemDesc=$p(Line,",",3)
		//s itemCatStr=$p(Line,",",4)
		//s otherNameStr=$p(Line,",",5)
		s itemDesc=$p(Line,",",1)
		s itemCatStr=$p(Line,",",2)
		s otherNameStr=$p(Line,",",3)
		continue:(itemDesc="")||(itemCatStr="")
		//w itemDesc_"^"_itemCatStr,! //_"^"_otherNameStr,!
		i '$d(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(itemDesc,"U")))  d
		.s ^TMP("web.DHCCKBComImport","NoneDrug",itemDesc)="^"_itemDesc
		//continue:1=1
		s length=$l(itemCatStr,"、")
		f i=1:1:length  d
		.s itemCat=$p(itemCatStr,"、",i)
		.q:(itemCat="")||(itemCat="无")
		.//w itemCat,!
		.i '$d(^TMP("web.DHCCKBComImport","GetCatByDic2",itemCat))  d
		..s ^TMP("web.DHCCKBComImport","None",itemCat)="^"_itemDesc_"^"_itemCat
		.e  d
		..i $d(^TMP("web.DHCCKBComImport","GetCatByDic2",itemCat))>10  d
		...s ^TMP("web.DHCCKBComImport","Repeat",itemCat)="^"_itemDesc_"^"_itemCat
		..e  d
		...i $d(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(itemDesc,"U")))  d
		....s ccID=$o(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(itemDesc,"U"),""))
		....q:ccID=""
		....s ccData = $g(^CKB.PDSS.ComContrastD(ccID))
		....s libDesc = $lg(listData,3)
		....s DataType = $lg(listData,6)
		....s dicID=""
		....s ID="" f  s ID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(libDesc),ID)) q:(ID="")||(dicID'="")  d
		.....q:$lg($g(^CT.CKB.PDSS.CommonDictionD(+ID)),4)'=DataType
		.....s dicID=ID
		....q:dicID=""
		....i ('$d(^kmlTmpCat(libDesc)))&&(itemCatStr)  d
		......//d ..deleteCat(libDesc, dicID, PhCategory)
		....s itemCatID=$o(^TMP("web.DHCCKBComImport","GetCatByDic2",itemCat,""))
		....q:(dicID="")||(PhCategory="")||(itemCatID="")
		....w libDesc,!
		....s ListData="^"_dicID_"^"_PhCategory_"^"_""_"^"_itemCatID
		....i '$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",dicID,PhCategory,itemCatID))  d
		.....s res=##class(web.DHCCKBDicLinkAttr).AddDicAttr(ListData)
		.....//s res=##class(web.DHCCKBComImport).LinkOtherNameStr(otherNameStr, itemCatID, "、")

	}  
	i Err=0 tc
	i Err'=0 tro
	w count_"条导入完成！更新："_count1_" 插入："_count2
	q ""
}

ClassMethod deleteCat(itemDesc, dicID, attrDr)
{
	n (itemDesc, dicID, attrDr)
	s attrRowID="" f  s attrRowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,attrDr,attrRowID)) q:attrRowID=""  d
	.s ^kmlTmpCat(itemDesc,attrRowID)=$lts($list(^CT.CKB.PDSS.DicLinkAttrD(attrRowID),2,*),"^")
	.s res= ##class(web.DHCCKBDicLinkAttr).DelDicAttr(attrRowID)
}

/// ////////////////////////////////////////////////////////////////////////
/// excel导入通用名和分类
/// Debug d ##class(web.DHCCKBComImport).ImportDrugCatAndGenDatas()
ClassMethod ImportDrugCatAndGenDatas() As %String
{
	TSTART
	//k ^TMP("web.DHCCKBComContrast","ImportDrugDatas")
	k ^TMP("web.DHCCKBComImport","GetCatByDic2")
	//k ^TMP("web.DHCCKBComImport","None")
	//k ^TMP("web.DHCCKBComImport","Repeat")
	
	d ##class(web.DHCCKBComImport).GetCatByDic2()
	
	s errNum=0
	s count =0,count1 =0,count2 =0
	s file=##class(%File).%New("D:\kml\药品分类数据20200727.csv")
	d file.Open("RS")
	d file.ReadLine() //读取一行
	s count=0
	s Err=0
	s PhCategory=##class(web.DHCCKBCommon).GetPhCategory() //分类属性
	s GeneralData=##class(web.DHCCKBCommon).GetDicIdByCode("GeneralData") //通用名字典
	s GenerNameProp=##class(web.DHCCKBCommon).GetDrugGenerName()
	s DrugData=##class(web.DHCCKBCommon).GetDrugData()
	s ChineseDrugData=##class(web.DHCCKBCommon).GetChineseDrugData()
	while 'file.AtEnd
	{
		s Line=file.Read()
		continue:Line=""
		s libDesc=$p(Line,",",2)
		continue:libDesc=""
		s newGenNameStr=$p(Line,",",4)
		s newCatStr=$p(Line,",",6)
		s dicID="" //取药品名ID
		s ID="" f  s ID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(libDesc),ID)) q:(ID="")||(dicID'="")  d
		.q:$lg($g(^CT.CKB.PDSS.CommonDictionD(+ID)),4)'=DrugData
		.s dicID=ID
		continue:dicID=""
		/*
		w libDesc,!
		//^kmlTmpCat(itemDesc)
		//^kmlTmpGen(itemDesc)
		//通用名
		i ('$d(^kmlTmpGen(libDesc)))&&(newGenNameStr'="") d
		.d ..deleteGen(libDesc,dicID,GenerNameProp)
		
		s len=$l(newGenNameStr,"、")
		f i=1:1:len  d
		.s newGenName=$p(newGenNameStr,"、",i)
		.q:newGenName=""
		.w newGenName,!
		.s genID=""
		.s ID="" f  s ID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(newGenName),ID)) q:(ID="")||(genID'="")  d
		..q:$lg($g(^CT.CKB.PDSS.CommonDictionD(+ID)),4)'=GeneralData
		..s genID=ID
		.i genID=""  d
		..s genID=##class(web.DHCCKBDiction).SaveDic("^"_newGenName_"^"_newGenName_"^"_GeneralData)
		..s ^TMP("web.DHCCKBComImport","NoneGen",genID)=$lts(^CT.CKB.PDSS.CommonDictionD(genID),"^") ^DHCCKBCD(genID)
		.q:genID=""
		.i '$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",dicID,GenerNameProp,genID))  d
		..s ListData="^"_dicID_"^"_GenerNameProp_"^"_""_"^"_genID
		..s res=##class(web.DHCCKBDicLinkAttr).AddDicAttr(ListData)
		
		//药学分类
		i ('$d(^kmlTmpCat(libDesc)))&&(newCatStr'="") d
		.d ..deleteGen(libDesc,dicID,PhCategory)
		*/
		s len=$l(newCatStr,"@@")
		f i=1:1:len  d
		.s catID=..getCatByStr($P(newCatStr,"@@",i))
		.//b ;1
		.i (catID="")&&(newCatStr'="") w libDesc_"^"_$P(newCatStr,"@@",i),!
		.q:catID=""
		.q:(dicID="")||(PhCategory="")||(catID="")
		.i '$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",dicID,PhCategory,catID))  d
		..//s ListData="^"_dicID_"^"_PhCategory_"^"_""_"^"_catID
		..//s res=##class(web.DHCCKBDicLinkAttr).AddDicAttr(ListData)
		
	}  
	i Err=0 tc
	i Err'=0 tro
	w count_"条导入完成！更新："_count1_" 插入："_count2
	q ""
}

ClassMethod deleteGen(itemDesc, dicID, attrDr)
{
	n (itemDesc, dicID, attrDr)
	s attrRowID="" f  s attrRowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,attrDr,attrRowID)) q:attrRowID=""  d
	.s ^kmlTmpGen(itemDesc,attrRowID)=$lts($list(^CT.CKB.PDSS.DicLinkAttrD(attrRowID),2,*),"^")
	.s res= ##class(web.DHCCKBDicLinkAttr).DelDicAttr(attrRowID)
}

// Debug w ##class(web.DHCCKBComImport).getCatByStr("新编药物学分类/维生素类营养类药物酶制剂以及调节水电解质和酸碱平衡的药物/调节水电解质和酸碱平衡用药/电解质平衡调节药")

ClassMethod getCatByStr(str)
{
	n (str)
	s len=$l(str,"/")
	q:str="" ""
	s catID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4($p(str,"/",1)),""))
	//b ;1
	f i=2:1:len q:catID=""  d
	.s parref=catID
	.s catID=""
	.//b ;2
	.s ID="" f  s ID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,ID)) q:(ID="")||(catID'="")  d
	..s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+ID)),3)
	..s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+ID)),4)
	..s:(desc="")&&(linkDr'="") desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+linkDr)),3)
	..i desc=$p(str,"/",i)  d
	...s catID=ID
	q catID
}

/// ////////////////////////////////////////////////////////////////////////
/// excel导入通用名和分类
/// Debug d ##class(web.DHCCKBComImport).ImportDrugIngrAndFormDatas()
ClassMethod ImportDrugIngrAndFormDatas() As %String
{
	TSTART
	//k ^TMP("web.DHCCKBComContrast","ImportDrugDatas")
	k ^TMP("web.DHCCKBComImport","GetCatByDic2")
	//k ^TMP("web.DHCCKBComImport","None")
	//k ^TMP("web.DHCCKBComImport","Repeat")
	
	d ##class(web.DHCCKBComImport).GetCatByDic2()
	
	s errNum=0
	s count =0,count1 =0,count2 =0
	s file=##class(%File).%New("D:\kml\药品分类数据20200728成分剂型删减.csv")
	d file.Open("RS")
	d file.ReadLine() //读取一行
	s count=0
	s Err=0
	//s DrugForm=##class(web.DHCCKBCommon).GetDrugForm() //剂型属性
	s FormData=##class(web.DHCCKBCommon).GetFormData() //剂型字典
	s DrugData=##class(web.DHCCKBCommon).GetDrugData() //西药字典
	s ChineseDrugData=##class(web.DHCCKBCommon).GetChineseDrugData() //中成药字典
	while 'file.AtEnd
	{
		s Line=file.Read()
		continue:Line=""
		s libDesc=$p(Line,",",2)
		continue:libDesc=""
		s newFormStr=$p(Line,",",4)
		continue:newFormStr=""
		s DataCode=$p(Line,",",5)
		continue:DataCode=""
		s DrugForm=##class(web.DHCCKBCommon).GetDrugForm() //剂型属性
		s:DataCode="ChineseDrugData" DrugForm=81836 //中成药剂型属性，先写上
		s dicID="" //取药品名ID
		s ID="" f  s ID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(libDesc),ID)) q:(ID="")||(dicID'="")  d
		.q:($lg($g(^CT.CKB.PDSS.CommonDictionD(+ID)),4)'=DrugData)&&($lg($g(^CT.CKB.PDSS.CommonDictionD(+ID)),4)'=ChineseDrugData)
		.s dicID=ID
		continue:dicID=""
		w libDesc_"^"_newFormStr_"^"_DataCode,!
		//^kmlTmpCat(itemDesc)
		//^kmlTmpGen(itemDesc)
		//剂型
		i ('$d(^kmlTmpForm(libDesc)))&&(newFormStr'="") d
		.d ..deleteForm(libDesc,dicID,DrugForm)
		i '$d(^kmlTmpForm(libDesc))  s ^kmlTmpForm(libDesc)=1
		s len=$l(newFormStr,"、")
		f i=1:1:len  d
		.s newForm=$p(newFormStr,"、",i)
		.q:newForm=""
		.s formID=""
		.s ID="" f  s ID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(newForm),ID)) q:(ID="")||(formID'="")  d
		..q:$lg($g(^CT.CKB.PDSS.CommonDictionD(+ID)),4)'=FormData
		..s formID=ID
		.i formID=""  d
		..s formID=##class(web.DHCCKBDiction).SaveDic("^"_newForm_"^"_newForm_"^"_FormData)
		..s ^TMP("web.DHCCKBComImport","NoneForm",formID)=$lts($g(^CT.CKB.PDSS.CommonDictionD(formID)),"^") //^DHCCKBCD(formID)
		.q:formID=""
		.q:(dicID="")||(DrugForm="")||(formID="")
		.i '$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",dicID,DrugForm,formID))  d
		..s ListData="^"_dicID_"^"_DrugForm_"^"_""_"^"_formID
		..s res=##class(web.DHCCKBDicLinkAttr).AddDicAttr(ListData)
		
	}  
	i Err=0 tc
	i Err'=0 tro
	w count_"条导入完成！更新："_count1_" 插入："_count2
	q ""
}

ClassMethod deleteForm(itemDesc, dicID, attrDr)
{
	n (itemDesc, dicID, attrDr)
	s attrRowID="" f  s attrRowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,attrDr,attrRowID)) q:attrRowID=""  d
	.s ^kmlTmpForm(itemDesc,attrRowID)=$lts($list(^CT.CKB.PDSS.DicLinkAttrD(attrRowID),2,*),"^")  //$lts($list(^CT.CKB.PDSS.DicLinkAttrD(attrRowID),2,*),"^")
	.s res= ##class(web.DHCCKBDicLinkAttr).DelDicAttr(attrRowID)
}

/// ///////////////////////////////////
/// 统计非其他非五级药学分类
/// Debug d ##class(web.DHCCKBComImport).getNoneDrugCat()
ClassMethod getNoneDrugCat()
{
	//k ^kmlTmpRule
	/*
	s exID="" f  s exID=$o(^CKB.PDSS.ExtDictionI("Type",94,"ChineseDrugData",exID)) q:exID=""  d
	.s extData = $g(^CKB.PDSS.ExtDictionD(exID)) 
	.s hisDesc=$p($lg(extData,3),"||",1)
	.s ccID=$o(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(hisDesc,"U"),""))
	.q:ccID=""
	.s libDesc=$lg(^CKB.PDSS.ComContrastD(ccID),3)
	.s dicID=..getDrugByDesc(libDesc)
	.q:dicID=""
	.s rdID="" f  s rdID=$o(^CT.CKB.PDSS.RuleDicI("Dic",dicID,rdID))  q:rdID=""  d
	..s ^kmlTmpRule(rdID)=rdID
	
	s exID="" f  s exID=$o(^CKB.PDSS.ExtDictionI("Type",94,"DrugData",exID)) q:exID=""  d
	.s extData = $g(^CKB.PDSS.ExtDictionD(exID)) 
	.s hisDesc=$p($lg(extData,3),"||",1)
	.s ccID=$o(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(hisDesc,"U"),""))
	.q:ccID=""
	.s libDesc=$lg(^CKB.PDSS.ComContrastD(ccID),3)
	.s dicID=..getDrugByDesc(libDesc)
	.q:dicID=""
	.s rdID="" f  s rdID=$o(^CT.CKB.PDSS.RuleDicI("Dic",dicID,rdID))  q:rdID=""  d
	..s ^kmlTmpRule(rdID)=rdID
	*/
	s RDataID="" f  s RDataID=$o(^CT.CKB.PDSS.RuleDataD(RDataID)) q:RDataID=""  d
	.q:+RDataID=0
	.s rdID=$lg($g(^CT.CKB.PDSS.RuleDataD(RDataID)),2)
	.q:'$d(^kmlTmpRule(rdID))
	.s rdLeft=$lg($g(^CT.CKB.PDSS.RuleDataD(RDataID)),4)
	.q:rdLeft'=38
	.s rdLeftValue=$lg($g(^CT.CKB.PDSS.RuleDataD(RDataID)),8) //right_dic
	.q:rdLeftValue=""
	.s:$d(^kmlCatCount(rdLeftValue)) ^kmlCatCount(rdLeftValue)=^kmlCatCount(rdLeftValue)+1
	.q:$d(^kmlCatCount(rdLeftValue))
	.q:$d(^TMP("NewCat",rdLeftValue))||$d(^TMP("OtherCat",rdLeftValue))
	.s ^kmlCatCount(rdLeftValue)=1
	.s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+rdLeftValue)),3)
	.
	.s NewCatStr=""
	.s newID="" f  s newID=$o(^TMP("NewCat",newID)) q:newID=""  d
	..s newDesc=^TMP("NewCat",newID)
	..i newDesc[dicDesc  d
	...s NewCatStr=$case(NewCatStr,"":newDesc,:NewCatStr_"/"_newDesc)
	.
	.s OtherCatStr=""
	.s otherID="" f  s otherID=$o(^TMP("OtherCat",otherID)) q:otherID=""  d
	..s otherDesc=^TMP("OtherCat",otherID)
	..i otherDesc[dicDesc  d
	...s OtherCatStr=$case(OtherCatStr,"":otherDesc,:OtherCatStr_"/"_otherDesc)
	.
	.s ^kmlCatOutput(rdLeftValue)=dicDesc_"^"_NewCatStr_"^"_OtherCatStr
	
	q ""
}

ClassMethod getDrugByDesc(libDesc)
{
	n (libDesc)
	s dicID=""
	s DrugData=##class(web.DHCCKBCommon).GetDrugData() //西药字典
	s ChineseDrugData=##class(web.DHCCKBCommon).GetChineseDrugData() //中成药字典
	s ID="" f  s ID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(libDesc),ID)) q:(ID="")||(dicID'="")  d
	.q:($lg($g(^CT.CKB.PDSS.CommonDictionD(+ID)),4)'=DrugData)&&($lg($g(^CT.CKB.PDSS.CommonDictionD(+ID)),4)'=ChineseDrugData)
	.s dicID=ID	
	q dicID
}

/// 导出所有药学分类（test）
/// Debug d ##class(web.DHCCKBComImport).ExpNewCat(50032)
ClassMethod ExpNewCat(parref = 106)
{
	n (parref,otherFlag)
	q:+parref=0 
	s catID=""
	f  s catID= $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,catID)) q:catID=""  d
	.q:catID="" 
	.//q:(otherFlag=1)&&((catID=50032)||(catID=50033))
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),2)
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),3)
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),5)
	.s:(desc="")&&(linkDr'="") desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+linkDr)),3)
	.s stop=0
	.i $d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",+catID))  d
	..i $d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",+catID,"stop")) s stop=1
	.s:(desc'="")&&(stop=0) ^TMP("NewCat",catID)=desc
	.d ..ExpNewCat(catID)
}

/// 导出所有药学分类（test）
/// Debug d ##class(web.DHCCKBComImport).ExpOtherCat(50033)
ClassMethod ExpOtherCat(parref = 50033)
{
	n (parref)
	q:+parref=0 
	s catID=""
	f  s catID= $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,catID)) q:catID=""  d
	.q:catID="" 
	.//q:(otherFlag=1)&&((catID=50032)||(catID=50033))
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),2)
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),3)
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),5)
	.s:(desc="")&&(linkDr'="") desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+linkDr)),3)
	.s stop=0
	.i $d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",+catID))  d
	..i $d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",+catID,"stop")) s stop=1
	.s:(desc'="")&&(stop=0) ^TMP("OtherCat",catID)=desc
	.//b ;1
	.d ..ExpOtherCat(catID)
}

/// Creator:      qunianpeng
/// CreatDate:     2020-03-27
/// Description:  统计非其他非五级药学分类
/// Input:		  检索条件,登录信息
/// Other:        w ##Class(websys.Query).ToExcel("等效单位","web.DHCCKBComContrast","QueryDrugFormEquiv")
Query QueryNoneCat() As websys.Query(ROWSPEC = "noneCat:%String,newCat:%String,otherCat:%String,count:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBComContrast","QueryDictionList","") 
/// @param: q 查询信息
ClassMethod QueryNoneCatExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	
	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	s id="" f  s id=$o(^kmlCatOutput(id)) q:id=""  d
	.s noneCat=$p(^kmlCatOutput(id),"^",1)
	.s newCat=$p(^kmlCatOutput(id),"^",2)
	.s otherCat=$p(^kmlCatOutput(id),"^",3)
	.s count=$g(^kmlCatCount(id))
	.d OutputFormEquivList
	
	
	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
	
OutputFormEquivList
    set Data = $lb(noneCat,newCat,otherCat,count)
    set ^CacheTemp(repid,ind) = Data
    Set ind = ind+1
    quit
}

/// 
/// 导出错误规则   适应症中症状和疾病的并且关系数据
/// Debug d ##class(web.DHCCKBComImport).getIndicatErrRule(73)
ClassMethod getIndicatErrRule(catList)
{
	n (catList)
	k ^kmlErrRule
	s ^kmlErrRule = 0
 s drugDictionId = ##class(web.DHCCKBCommon).GetDrugData()			//西药字典
 s chnDictionId = ##class(web.DHCCKBCommon).GetChineseDrugData() 		//中成药字典
	s ruleId=""
	f  s ruleId = $o(^CT.CKB.PDSS.RuleD(ruleId))	 q:ruleId=""  d
	.q:..isExistThisCat(ruleId,catList)'=1     			//判断规则是否在目录下
	.s dicId = ""
	.i $d(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,drugDictionId))  d //西药
	..s ruleDicId = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,drugDictionId,""))
	..s dicId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),3)
	.i $d(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,chnDictionId))  d //中成药
	..s ruleDicId = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,chnDictionId,""))
	..s dicId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),3)
	.q:+dicId=0
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicId)),3)
	.//药品日志找ip
	.s ip="",date=""
	.s dicLogId = $o(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",dicId,"add",""))	
	.s:dicLogId'="" ip = $lg(^CKB.PDSS.DicLogD(dicLogId),10)
	.s ruleLogId = $o(^CKB.PDSS.RuleLogI("Rule",ruleId,""))
	.s:ruleLogId'="" date = $lg(^CKB.PDSS.RuleLogD(ruleLogId),4)
	.s:date'="" date=$zd(date,3)
	.s ruleNodeId = "",ruleParent = ""
	.f  s ruleNodeId = $o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",0,ruleNodeId)) q:ruleNodeId=""  d
	..i $d(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",ruleNodeId))  d
	...s ruleNodeIdsub = "" 
	...f  s ruleNodeIdsub = $o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",ruleNodeId,ruleNodeIdsub)) q:ruleNodeIdsub=""  d
	....q:$lg($g(^CT.CKB.PDSS.RuleNodeD(ruleNodeIdsub)),3)'="and"
	....w dicDesc,!
	....s ruleDataId="" ,count=0
	....f  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("Node",ruleNodeIdsub,ruleDataId)) q:ruleDataId=""  d
	.....s dicType  =$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),4)
	.....;s count = count+1
	.....s:(dicType=10)||(dicType=12)||(dicType=6)||(dicType=9) count=count+1 //通用名 成分 分类
	....i count>1  d
	.....s ^kmlErrRule(dicId,ruleId)="^"_dicDesc_"^"_ruleId_"^"_ip_"^"_date
	.....s ^kmlErrRule=^kmlErrRule+1
	..
	..q:$lg($g(^CT.CKB.PDSS.RuleNodeD(ruleNodeId)),3)'="and"
	..s ruleDataId="" ,count=0
	..f  s ruleDataId=$o(^CT.CKB.PDSS.RuleDataI("Node",ruleNodeId,ruleDataId)) q:ruleDataId=""  d
	...s dicType=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),4)
	...;s count=count+1
	...s:(dicType=10)||(dicType=12)||(dicType=6)||(dicType=9) count=count+1  //通用名 成分 分类
	..i count>1  d
	...s ^kmlErrRule(dicId,ruleId)="^"_dicDesc_"^"_ruleId_"^"_ip_"^"_date
	...s ^kmlErrRule=^kmlErrRule+1
	Q ""
}

/// Descript:判断是否在对应目录的规则
/// w ##class(web.DHCCKBComImport).isExistThisCat(137758,73)
ClassMethod isExistThisCat(ruleId, catList)
{
	n (ruleId,catList)
	s existFlag = 0
	s length = $l(catList,"^")
	for i = 1:1:length  d
	.s catId = $p(catList,"^",i)
	.Q:'$d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,catId))
	.s existFlag = 1
	Q existFlag
}

/// Description:	中药饮片字典数据后台导入
/// Creator:		qunianpeng
/// CreateDate:		2021-01-25
/// Input:			filepath：文件路径, loginInfo:登录信息(取一个登录界面中的loginInfo:登录信息), clientIPAddress:客户端ip
/// return:			
/// other:	w ##class(web.DHCCKBComImport).ImportChineseHMDatas("D:\知识图谱\饮片药嘱系统数据信息整理-院内品种字典数据.csv","11871^8^1^289^2","113.140.81.66")
ClassMethod ImportChineseHMDatas(filepath, loginInfo, clientIPAddress) As %String
{
	n (filepath,loginInfo, clientIPAddress)	
	s count = 0,total = 0
	s parref = ##class(web.DHCCKBCommon).GetChineseHMData() //中药饮片字典id
	
	TSTART
	
	s file=##class(%File).%New(filepath)
	d file.Open("RS")
	d file.ReadLine() //读取一行
	s count=0
	while 'file.AtEnd
	{
		s Line=file.Read()
		continue:Line=""
		s total = total + 1
		s code = $p(Line,",",1)  //知识库数据代码	 
		continue:code=""
		s desc = $p(Line,",",2)  //知识库数据描述	
		continue:desc=""
		i code="无" s code=desc
		s code = $replace(code,"（","(")   //sufan 2020-04-23 转换括号
		s code = $replace(code,"）",")")
		s desc = $replace(desc,"（","(")
		s desc = $replace(desc,"）",")")		
		s dicStr = ""_"^"_code_"^"_desc_"^"_parref_"^"_""
		
		s ret = ##class(web.DHCCKBDiction).SaveUpdateNew(dicStr,"",loginInfo,clientIPAddress)
		continue:ret'=0
		s count = count+1
	}	
	i count=0 tro
	e  tc

	w "成功导入"_count_"条"_",共:"_total_"条",!
	
	q ""
}

/// Description:	中药饮片知识数据
/// Creator:		qunianpeng
/// CreateDate:		2021-01-25
/// Input:			filepath：文件路径, loginInfo:登录信息(取一个登录界面中的loginInfo:登录信息), clientIPAddress:客户端ip
/// return:			
/// other:	w ##class(web.DHCCKBComImport).ImportChineseHMKnowDatas("D:\知识图谱\饮片药嘱系统数据信息整理-院内品种(知识).csv","11871^8^1^289^2","222.90.61.44")
ClassMethod ImportChineseHMKnowDatas(filepath, loginInfo, clientIPAddress) As %String
{
	n (filepath, loginInfo, clientIPAddress)
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	d ..ReadChHMDataByFile(pid,filepath)	// 先从后台导入数据
	s err = 0

	s row ="",count = 0 
	f  s row = $o(^TMP("DHCCKB","web.DHCCKBComImport","ImportChineseHMKnowDatas",pid,row))  q:(row="")||(err'=0)  d
	.s rowData=$g(^TMP("DHCCKB","web.DHCCKBComImport","ImportChineseHMKnowDatas",pid,row))
	.s drugObj=..DrugStrToObj(rowData,"drug")	// 药品字典
	.//s ..SaveDrug() //
	.s err=..SaveDrugInstructions(rowData, loginInfo, clientIPAddress)	// 保存药品说明书信息
	.s count = count + 1
	.s:err'=0 err = err + 1
	
	w "共"_count_"条数据."_"失败"_err_"条."
	q ""
}

/// Description:	中药饮片字典数据从后台写入文件中
/// Creator:		qunianpeng
/// CreateDate:		2021-01-25
/// Input:			filepath：文件路径
/// return:			
/// other:	w ##class(web.DHCCKBComImport).ReadChHMDataByFile(1,"D:\知识图谱\中药饮片标准库字典.csv")
ClassMethod ReadChHMDataByFile(pid, filepath) As %String
{
	n (pid, filepath)	
	s count = 0,total = 0
	s parref = ##class(web.DHCCKBCommon).GetChineseHMData() //中药饮片字典id
	
	
	s file=##class(%File).%New(filepath)
	d file.Open("RS")
	d file.ReadLine() //读取一行
	s count=0
	while 'file.AtEnd
	{
		s Line=file.Read()
		continue:Line=""
		s total = total + 1
		i total = 1  d
		.s title = Line
		continue:total<=2
		s data=""
		f k=1:1:$length(Line,",") d
		.s code = $p(title,",",k)
		.s value = $p(Line,",",k)
		.s tmpValue = code_$c(1)_value
		.i data=""  s data = tmpValue
		.e  s data = data_$c(2)_tmpValue
		// 将数据处理成 code_$c(1)_value的形式
		s ^TMP("DHCCKB","web.DHCCKBComImport","ImportChineseHMKnowDatas",pid,total) = data
		
	}
	d file.%Close()
	
	q ""
}

/// Description:	保存中药饮片说明书信息
/// Creator:		qunianpeng
/// CreateDate:		2021-01-25
/// Input:			filepath：文件路径
/// return:			
/// other:	w ##class(web.DHCCKBComImport).ReadChHMDataByFile("D:\饮片药嘱系统数据信息整理-标准库1.csv","11863^8^1^291^2","127.0.0.1")
ClassMethod SaveDrugInstructions(rowData, loginInfo, clientIPAddress) As %String
{
	n (rowData,loginInfo,clientIPAddress)
	
	
	s dataObj=..DrugStrToObj(rowData)	// 知识str转换成Obj
	q:dataObj.%Size()=0 ""		// 空对象
	//s num=dataObj.%Get("num")	// 序号
	
	s drugCode = dataObj.%Get("itmCode")
	s drugDesc = dataObj.%Get("itmDesc")
	s parref = ##class(web.DHCCKBCommon).GetChineseHMData() //中药饮片字典id
	q:(drugCode="")||(drugDesc="") -1
	s dicStr = ""_"^"_drugCode_"^"_drugDesc_"^"_parref_"^"_""		
	s ret = ##class(web.DHCCKBDiction).SaveUpdateNew(dicStr,"",loginInfo,clientIPAddress)	// 保存药品信息
	q:(ret'=0)&(ret='-98)&(ret'=-99) -1	// 保存失败

	s drugId = ##class(web.DHCCKBCommon).GetDicIdByDesc(drugDesc,parref)	// 药品id
	q:drugId=0 -1 
	s err = 0
	set iter = dataObj.%GetIterator()
	while iter.%GetNext(.key, .value) { 
		continue:(key="num")||(key="itmCode")||(key="itmDesc")
		continue:(value="")||(value="无")
		if key["SecondName"  d 
		.s ret = ..SaveSecondData(drugId,value,loginInfo,clientIPAddress)
		.i ret'=0 s err=err+1
		e  d
		.// 直接保存关系
		.s propId = ..GetPropIdByCode(key)
		.i (key="IsConcoctProp")||(key="IsCostlyProp") d
		..s value=$select(value="0":"否",value="1":"是",1:value)
		.q:value=0
		.s listData = "^"_drugId_"^"_propId_"^^"_value_"^^"
		.s dataType = "text"
		.i (key="DivisionProp")||(key="FunIndicat_L")||(key="RuleUsage_L")||(key="RuleContr_L")||(key="RuleMatNeAt_L") s dataType="textarea"
		.i (key="MedNotifyProp")||(key="ConcoctMethodProp")||(key="FoodContrProp") s dataType="textarea"
		.s ret = ##class(web.DHCCKBDicLinkAttr).saveDicAttrByType(listData,dataType,loginInfo,clientIPAddress)
		.i ret'=0 s err=err+1		
	}
	
	q err
}

/// 特定格式的字符串转换为对象 		//	通用名$c(1)阿莫西林 [next] 剂型2$c(1) 片剂	
/// w ##class(web.DHCCKBComImport).StrToObj("编码1"_$c(1)_"11111[next]药品商品名1"_$c(1)_"阿莫西林").%ToJSON()
ClassMethod DrugStrToObj(mData, type = "") As %String
{
	n (mData,type)
	
	s spec=$c(2)
	s del=$c(1)
	s len=$length(mData,spec)
	s dataObj={}

	f i=1:1:len	d
	.s tmpData=$p(mData,spec,i)
	.s key=$p(tmpData,del,1)
	.s value=$p(tmpData,del,2)
	.d dataObj.%Set(key,value)
	
	q dataObj
}

/// 保存别名字典
/// w ##class(web.DHCCKBComImport).SaveSecondData()
ClassMethod SaveSecondData(drugID, str, loginInfo, clientIPAddress) As %String
{
	n (drugID,str,loginInfo,clientIPAddress)
	//s parref = ##class(web.DHCCKBCommon).GetOtherName()
	s chHMPropId = ##class(web.DHCCKBCommon).GetChinaHMedicineProp()
	s comProp = ##class(web.DHCCKBCommon).GetDicIdByCode("ComProp")
	s otherNameProp = ..GetPropIdByLinkCode("OtherNameProp",chHMPropId,comProp)	//别名属性
	s listTitle = "0^"_drugID_"^"_otherNameProp_"^^"
	s listData = ""
	f k =1:1:$length(str,"、")  d
	.s value = $p(str,"、",k)
	.q:value="无"
	.//s dicStr = ""_"^"_value_"^"_value_"^"_parref_"^"_""
	.//s ret = ##class(web.DHCCKBDiction).SaveUpdateNew(dicStr,"",loginInfo,clientIPAddress)	// 保存别名
	.//q:ret'=0
	.//s dicID = ##class(web.DHCCKBCommon).GetDicIdByDesc(value,parref)
	.//q:+dicID=0
	.// 保存关联关系
	.s data = "^"_drugID_"^"_otherNameProp_"^"_value_"^"_"OtherNameProp^0^"
	.i listData = "" s listData = data
	.e  s listData = listData_"&&"_data

	s listData = listTitle_"&&"_listData
	s ret = ##class(web.DHCCKBDicLinkAttr).saveDicAttrByType(listData,"datagrid",loginInfo,clientIPAddress)

	q ret
	// 0^药品id^属性id^^
	//var ListStr="0" +"^"+ tmpparref +"^"+ linkRowID +"^"+ "" +"^"+ 组号
	// ^药品id^属性id^字典值id^??^序号^
	//	var ListData = ItmId +"^"+ tmpparref +"^"+ linkRowID +"^"+ rowsData[i][fileds[j]] +"^"+ fileds[j] +"^"+ i +"^"+ GroupNum;
	// params=dataList.join("&&");
	//("0^150^26947^^&&^150^26947^别名测试^OtherNameProp^0^","datagrid")
}

/// 获取属性代码
ClassMethod GetPropIdByCode(key) As %String
{
	n (key)
	s chHMPropId = ##class(web.DHCCKBCommon).GetChinaHMedicineProp()
	s propId = 0
	i key["_L" d	// 在药品目录下找属性id
	.s drugLibaryData = ##class(web.DHCCKBCommon).GetDrugLibaryData()
	.s propId=..GetPropIdByLinkCode($p(key,"_L",1),chHMPropId,drugLibaryData) 

	q:propId'=0 propId
	//1. 优先在中药饮片属性下找,找不到在西药属性下找
	s propId = ##class(web.DHCCKBCommon).GetDicIdByCode(key,chHMPropId)	
	s drugProp = ##class(web.DHCCKBCommon).GetDrugProp()
	i +propId=0  s propId=..GetPropIdByLinkCode(key,chHMPropId,drugProp) 
	
	q propId
}

ClassMethod GetPropIdByLinkCode(key, parref, linkParref) As %String
{
	n (key,parref,linkParref)
	s linkPropId = ##class(web.DHCCKBCommon).GetDicIdByCode(key,linkParref)	// 原本所在的位置
	q:+linkPropId=0 0
	s id = "",exitFlag=0,propId=0
	f  s id = $o(^CT.CKB.PDSS.CommonDictionI("Link",linkPropId,id))  q:(id="")||(exitFlag=1)  d
	.q:+id=0
	.i $lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),4)=parref s exitFlag=1
	.s propId=id
	
	q propId
}

/// 临时处理 中药饮片别名的重复问题
/// w ##class(web.DHCCKBComImport).DealOhterRepleat()
ClassMethod DealOhterRepleat() As %String
{
	s parref = ##class(web.DHCCKBCommon).GetChineseHMData()
	
	s dicID = "",total = 0
	k TmpArr
	f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,dicID))	q:dicID=""  d
	.//q:114362'=dicID
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",dicID,114555))
	.s attr = "",count = 0
	.f  s attr = $o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",dicID,114555,attr))	q:attr=""  d
	..s linkID = ""
	..f  s linkID = $o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",dicID,114555,attr,linkID))  q:linkID=""  d
	...//b:dicID="114362"
	...//i ($d(TmpArr("other",dicID,114555,attr)))&($g(TmpArr("other",dicID,114555,attr))>1) d
	...//b //11
	...i ($d(TmpArr("other",dicID,114555,attr))) d
	....w dicID_":"_$lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),3)_":"_linkID,!
	....//&sql(delete from CT_CKB_PDSS.DicLinkAttr where DLA_RowID=:linkID)
	...e  d
	....s count = count + 1
	....s TmpArr("other",dicID,114555,attr)=1
	
	q total
}

/// Description:	导入指定分类
/// Creator:		QuNianpeng
/// CreateDate:		2021-02-09
/// Input:			pid,数据,类型
/// return:			
/// other:			
/// w ##class(web.DHCCKBComImport).SaveDrugCatImprot("drugcat")
ClassMethod SaveDrugCatImprot(type, LoginInfo = "", ClientIPAdd = "")
{
	n (type,LoginInfo,ClientIPAdd)
	s LgUserID=$p($g(LoginInfo),"^",1)
	s LgHospID=$p($g(LoginInfo),"^",5)
	s pid=1			// 进程号

	set $ZT="ERROR" // 设置一个异常
	s total=0,successNum=0,errNum=0 // 计数器 总数,成功,失败
	s msg=""		// 提示信息
	
	k ^TMP("DHCCKB","web.DHCCKBExport","ExportDataErrMsg",type,pid)
	
	s row="" 
	f  s row=$o(^TMP("DHCCKB","web.DHCCKBComImport","TmpImportData",pid,type,row))  q:row=""  d	
	.s total=total+1
	.s rowData=$g(^TMP("DHCCKB","web.DHCCKBComImport","TmpImportData",pid,type,row))
	.s rowObj=..StrToObj(rowData,type)	
	.q:rowObj.%Size()=0		// 空对象
	.s err=1
	.s num=rowObj.%Get("num")	// 行号
	.
	.TS	
	.d SaveDrugCatALone
	.i err=0 d SetTroInfoAlone
	.q:err=0
	.
	.i err>0 do
	..s successNum=successNum+1
	..TCOMMIT
	.else  d SetTroInfoAlone
	

	s outObj={}
	i (successNum'=0) 	d
	.d outObj.%Set("code","success").%Set("total",total).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg","")
	e  d
	.d outObj.%Set("code","err").%Set("total",total).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg",$case(msg,"":"系统错误,代码:"_$ZE,:msg))
	
	d ..killTmpGlobal(pid)
	
	q outObj.%ToJSON()
	
SaveDrugCatALone		// 药学分类

	s catDataID=  ##class(web.DHCCKBCommon).GetDicIdByCode("ATC分类")
	i +catDataID=0 s err=0,msg="ATC分类不存在"
	q:+catDataID=0 ""
	
	// 一级分类
	s firstCode=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("firstCode"))
	s firstDesc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("firstName"))
	i firstDesc="" s err=0,msg="一级分类描述不可以为空"
	q:firstDesc="" ""	
	s firstID=##class(web.DHCCKBComImport).SaveDrugCat(firstCode,firstDesc,catDataID,pid,LoginInfo,ClientIPAdd)
	i +firstID=0 s err=0,msg="一级分类保存失败"
	q:+firstID=0
	// 二级分类
	if (##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("secondName"))'=""){
		s code=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("secondCode"))
		s desc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("secondName"))
		i desc="" s err=0,msg="二级分类描述不可以为空"
		q:desc=""	
		s secondID=##class(web.DHCCKBComImport).SaveDrugCat(code,desc,firstID,pid,LoginInfo,ClientIPAdd)
		i +secondID=0 s err=0,msg="二级分类保存失败"
		q:+secondID=0	
		
		// 三级分类		
		if (##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("thirdName"))'=""){
			s code=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("thirdCode"))
			s desc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("thirdName"))	
			q:desc="" 		
			s thirdID=##class(web.DHCCKBComImport).SaveDrugCat(code,desc,secondID,pid,LoginInfo,ClientIPAdd)
			i +thirdID=0 s err=0,msg="三级分类保存失败"	
			q:+thirdID=0		
			
			// 四级分类
			if (##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fourthName"))'=""){
				s code=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fourthCode"))
				s desc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fourthName"))
				q:desc=""
				s fourthID=##class(web.DHCCKBComImport).SaveDrugCat(code,desc,thirdID,pid,LoginInfo,ClientIPAdd)
				i +fourthID=0 s err=0,msg="四级分类保存失败"		
				q:+fourthID=0			
				// 五级分类					
				if (##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fifthName"))'=""){
					s code=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fifthCode"))
					s desc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fifthName"))
					q:desc=""					
					s fifthID=##class(web.DHCCKBComImport).SaveDrugCat(code,desc,fourthID,pid,LoginInfo,ClientIPAdd)
					i +fifthID=0 s err=0,msg="五级分类保存失败"
					q:+fifthID=0					
				}
			}
		}				
	}

	quit
	
	
SetTroInfoAlone
	tro
	s errNum=errNum+1
	s ^TMP("DHCCKB","web.DHCCKBExport","ExportDataErrMsg",pid,type,row)=rowData_"[next]"_"errMsg"_$c(1)_msg	// 记录提交失败信息
	Quit


ERRORNew
	set errorMsg=$ZE                  //$ZE 获取错误信息
	TROLLBACK	                      //有异常，则回滚事务(Golbal才可以回滚,普通变量不能回滚)
	s ^TMP("DHCCKB","web.DHCCKBExport","ExportDataErrMsg",pid,type,row)=rowData	// 记录提交失败信息
	s outObj={}
	d outObj.%Set("code","err").%Set("total",total).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg","系统错误,代码"_errorMsg)
	d ..killTmpGlobal(pid)
	
	Quit outObj.%ToJSON()             //返回错误信息
}

/// Description:	新增五级分类
/// Creator:		qunianpeng 
/// CreateDate:		2022-02-09
/// Input:			代码,描述,所属字典表id
/// return:			成功id，失败代码<0
/// other:			w ##class(web.DHCCKBComImport).SaveDrugCat("AZA01AA", "辛温解表剂", 120998,"","", pid)
ClassMethod SaveDrugCat(code, desc, parref, pid, LoginInfo = "", ClientIPAdd = "")
{
	n (code, desc, parref,pid,LoginInfo,ClientIPAdd)
	s LgUserID=$p($g(LoginInfo),"^",1)
	s LgHospID=$p($g(LoginInfo),"^",5)
	s dicID=0	
	s dicID = ##class(web.DHCCKBCommon).GetDicIDByCodeAndDesc(code,desc,parref)
	q:dicID'=0 dicID
	
	  // 新增
	s dicID=##class(web.DHCCKBDiction).SaveDic("^"_code_"^"_desc_"^"_parref)
	s:LoginInfo'="" retlog=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction", dicID, "add", LgUserID, "", "", "", LgHospID, ClientIPAdd,"log")
	s:LoginInfo'="" retacc=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction", dicID, "grantAuth", LgUserID, "", "", "D", LgHospID, ClientIPAdd,"acc")
	
	q dicID
}

}
