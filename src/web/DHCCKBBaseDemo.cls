Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2019-05-15
/// Descript: 		知识库审查
Class web.DHCCKBBaseDemo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:  提取模板数据
/// w ##Class(web.DHCCKBBaseDemo).JsTakTemp()
ClassMethod JsTakTempO() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CT_RowID ,CT_Title FROM DHC_CKBTestCaseTemp"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s ID = result.Data("CT_RowID")
		s Desc = result.Data("CT_Title")
		Continue:Desc["[standard]"
		Continue:Desc=""
		s tmp=ID_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Descript:  提取模板数据
/// w ##Class(web.DHCCKBBaseDemo).JsTakTemp()
ClassMethod JsTakTemp() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CT_RowID ,CT_Title FROM DHC_CKBTestCaseTemp"
    d result.Prepare(sqlStr)
	d result.Execute()
	s retArr=[]
	s model={}
	s model.value="1"
   	s model.text="标准化模板"
   	s children=[]
   	While(result.Next())
	{	
	   	s subModel={}
	   	s ID = result.Data("CT_RowID")
		s Desc = result.Data("CT_Title")
		continue:Desc'["[standard]"
		continue:Desc=""
		s Desc=$replace(Desc,"[standard]","")
	    s subModel.value=ID
	    s subModel.text=Desc
	    d children.%Push(subModel)
	}
	d model.%Set("children",children)
	d retArr.%Push(model)
	
	d result.Execute()
	While(result.Next())
	{	
		s model={}
		s ID = result.Data("CT_RowID")
		s Desc = result.Data("CT_Title")
		Continue:Desc["[standard]"
		Continue:Desc=""
		s model.value=ID
   		s model.text=Desc
		d retArr.%Push(model)
	}
	w retArr.%ToJSON()

	Q ""
}

/// Descript:  提取模板数据
/// w ##Class(web.DHCCKBBaseDemo).getStandardTag()
ClassMethod getStandardTag() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CT_RowID ,CT_Title FROM DHC_CKBTestCaseTemp"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s str= "["
	While(result.Next())
	{	
		s ID = result.Data("CT_RowID")
		s Desc = result.Data("CT_Title")
		Continue:Desc'["[standard]"
		s Desc=$replace(Desc,"[standard]","")
		Continue:Desc=""
		s children="[]"
		s tmp=ID_"^"_Desc_"^"_children
		s count = count+1
		I count=1 d
		.s str=str_##class(web.DHCAPPJsonCommon).getJsonData("value^text^children",tmp)
		e  d
		.s str=str_ ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^children",tmp)
	}
	s str=str_ "]"
	Q str
}

/// Descript:  提取肝损状态数据
/// w ##Class(web.DHCCKBBaseDemo).JsTakLiver()
ClassMethod JsTakLiver() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTCPT_RowId ,CTCPT_Desc FROM CT_CarPrvTp"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s ID = result.Data("CTCPT_RowId")
		s Desc = result.Data("CTCPT_Desc")
		Continue:Desc=""
		s tmp=ID_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Descript:  提取肾损状态数据
/// w ##Class(web.DHCCKBBaseDemo).JsTakRenal()
ClassMethod JsTakRenal() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTCPT_RowId ,CTCPT_Desc FROM CT_CarPrvTp"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s ID = result.Data("CTCPT_RowId")
		s Desc = result.Data("CTCPT_Desc")
		Continue:Desc=""
		s tmp=ID_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Descript:  提取肾损状态数据
/// w ##Class(web.DHCCKBBaseDemo).JsTakSpecGrps()
ClassMethod JsTakSpecGrps() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s itmid=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("SpecialPopData"),"")) /// 按代码
	s sqlStr = "SELECT CD_RowID ,CD_Desc FROM CT_CKB_PDSS.CommonDiction where CD_Parref_Dr="_itmid
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s ID = result.Data("CD_RowID")
		s Desc = result.Data("CD_Desc")
		Continue:Desc=""
		Continue:0=##class(web.DHCCKBCommon).IsShow(ID,"DHC_CKBCommonDiction","")
		s tmp=ID_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// 通过类型提取数据(下拉框)
/// w ##Class(web.DHCCKBBaseDemo).JsTakDataByType("unit","")
ClassMethod JsTakDataByType(type, q = "") As %String
{
	n (type,q)
	s input=$zcvt(q,"U")
	
	s result = ##class(%Library.ResultSet).%New()
	
	i type="sex" d	// 性别
	.s parref=##class(web.DHCCKBCommon).GetSexData()
	e  i type="form" d	// 剂型
	.s parref=##class(web.DHCCKBCommon).GetFormData()
	e  i type="freq" d	// 频次
	.s parref=##class(web.DHCCKBCommon).GetDrugFreqData()
	e  i type="unit" d	// 单位
	.s parref=##class(web.DHCCKBCommon).GetUnitData()
	e  i type="premet" d	// 给药途径
	.s parref=##class(web.DHCCKBCommon).GetDrugPreMetData()
	e  i type="profess" d	// 职业
	.s parref=##class(web.DHCCKBCommon).GetProfessData()
	e  i type="firstuse" d	// 首次用药
	.s parref=##class(web.DHCCKBCommon).GetFirstUseData()
	i parref="" w "[]"
	q:parref="" ""
	
	//s itmid=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("SpecialPopData"),"")) /// 按代码
	s sqlStr = "SELECT CD_RowID ,CD_Code,CD_Desc FROM CT_CKB_PDSS.CommonDiction where CD_Parref_Dr="_parref
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s ID = result.Data("CD_RowID")
		s Code = result.Data("CD_Code")
		s Desc = result.Data("CD_Desc")
		continue:##class(web.DHCCKBCommon).IsEnabled(ID)=0	// 过滤停用数据
		Continue:Desc=""
		s PinDesc=##class(web.DHCCKBCommonUtil).GetPYCODE(Desc)
		continue:(input'="")&&(($zcvt(Code,"U")'[input)&(Desc'[input)&(PinDesc'[input))
		s tmp=ID_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Creator：sufan
/// Descript:首次用药标记
/// w ##Class(web.DHCCKBBaseDemo).ListIsActive("unit","")
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","Y"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","N"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// Descript:  保存测试用例模板
/// w ##Class(web.DHCCKBBaseDemo).InsTestCaseTemp()
ClassMethod InsTestCaseTemp(ID As %String, TempTitle As %String, jsTempObj) As %String
{
	n (ID, TempTitle, jsTempObj)
	
	q:(ID'="")&&($p($g(^DHCCKBTCT(ID)),"^",3)["[standard]") "-77"
	
	s jsTempObj=$replace(jsTempObj,""""_""""""""_"""",""""_""""_"""")
	i ID="" D
	.s ID=..Insert(TempTitle, jsTempObj)
	E  D
	.s ID=..Update(ID, TempTitle, jsTempObj)
	Q ID
}

/// Descript:  插入测试用例模板
ClassMethod Insert(TempTitle As %String, jsTempObj As %String) As %String
{
	n (TempTitle, jsTempObj)
	s CsRDate=+$H   		            ///新建日期
	s CsRTime=$p($H,",",2)              ///新建时间
	&SQL(insert into DHC_CKBTestCaseTemp(CT_CreateDate, CT_CreateTime, CT_Title, CT_TempText)
		values(:CsRDate, :CsRTime, :TempTitle, :jsTempObj))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript:  更新测试用例模板
ClassMethod Update(ID As %String, TempTitle As %String, jsTempObj As %String) As %String
{
	n (ID, TempTitle, jsTempObj)
	&SQL(update DHC_CKBTestCaseTemp set CT_Title=:TempTitle,CT_TempText=:jsTempObj where CT_RowID=:ID)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript:删除模板
ClassMethod DelTemp(ID As %String)
{
	 n (ID)
	 &SQL(delete from  DHC_CKBTestCaseTemp where CT_RowID=:ID)
	 Q SQLCODE
}

/// Descript:  提取模板数据
/// w ##Class(web.DHCCKBBaseDemo).JsGetKbTemp(317)
ClassMethod JsGetKbTemp(ID As %String) As %String
{
	n (ID)
	s jsTempObj=$p($g(^DHCCKBTCT(+ID)),"^",4) /// 模板数据
	i jsTempObj'="" w jsTempObj
	E  w "{}"
	Q ""
}

/// Descript:  唯一标识
/// w ##Class(web.DHCCKBBaseDemo).TakUniqueIdent()
ClassMethod TakUniqueIdent(ID As %String) As %String
{
	n (ID)
	s unIdent=$i(^TMPCKBUNIQUE(ID))
	Q unIdent
}

/// Description:	查询实体字典
/// Creator:		QuNianpeng 
/// CreateDate:		2019-11-230
/// Input:			id,q
/// return:			实体字典列表 
/// other:			w ##class(web.DHCCKBBaseDemo).QueryDicComgrid(20,1,"","黑顺片")
ClassMethod QueryDicComgrid(rows = 10, page = 1, id As %String, q As %String = "") As %String
{
	n (rows,page,id,q)

	s input=$zcvt(q,"U")
	s end = page*rows
	s start=(page-1)*rows+1
	/*
	i (+id = 0)&&(id '="") d
	.i $d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(id))) d
	..s id = $o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(id),""),-1)
	
	q:+id=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	q:+id=0 ""
	*/
	s drugDataID = ##class(web.DHCCKBCommon).GetDrugData()
	s chinaDataID = ##class(web.DHCCKBCommon).GetChineseDrugData()
	s chinaHMDataDta = ##class(web.DHCCKBCommon).GetChineseHMData()
	s drugList = $lb(drugDataID,chinaDataID,chinaHMDataDta)
	
	s h=0
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	f j=1:1:$listlength(drugList)  d
	.s id = $listget(drugList,j)
	.q:id=""
	.s dicID=""   f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",id,dicID))   q:dicID=""  d
	..q:1'=##class(web.DHCCKBCommon).IsEnabled(dicID)
	..s dicCode=$lg(^CT.CKB.PDSS.CommonDictionD(+dicID),2)
	..s dicDesc=$lg(^CT.CKB.PDSS.CommonDictionD(+dicID),3)
	..s pinDesc=##class(web.DHCCKBCommonUtil).GetPYCODE(dicDesc)
	..q:(input'="")&($zcvt(dicCode,"U")'[input)&(dicDesc'[input)&(pinDesc'[input)
	..s parref=id
	..s:parref'="" parrefDesc=$lg(^CT.CKB.PDSS.CommonDictionD(+parref),3)
	..s linkDr=$lg(^CT.CKB.PDSS.CommonDictionD(dicID),5)
	..s linkDesc=""
	..i linkDr'="" d
	...s dicCode=$lg(^CT.CKB.PDSS.CommonDictionD(+linkDr),2)
	...s dicDesc=$lg(^CT.CKB.PDSS.CommonDictionD(+linkDr),3)
	...s linkDesc=dicDesc
	..
	..//xww 2021-08-13 判断是否有规则及规则是否确认
	..s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(dicID)		//判断是否有规则
	..s Img="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>"
	..s RuleImg=$s(ruleFlag=1:Img,1:"")
	..s drugConfirmFlag = +$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",dicID,"confirm"))	
	..s confirmImg="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png' border=0/>"
	..s confirmImg=$case(drugConfirmFlag>0,1:confirmImg,:"")
	
	..s data=dicID_"^"_dicCode_"^"_dicDesc_"^"_parref_"^"_$g(parrefDesc)_"^"_linkDr_"^"_linkDesc_"^"_RuleImg_confirmImg
	..s h=h+1	
	..s ^TMP("DHCCKB","web.DHCCKBBaseDemo","QueryDicComgrid",pid,h)=data
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""
	
	s count=0	
	s listTitle="ID^CDCode^CDDesc^CDParref^CDParrefDesc^CDLinkDr^CDLinkDesc^CDImg"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBBaseDemo","QueryDicComgrid",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBBaseDemo","QueryDicComgrid",pid,index))
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符	
	
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)	
	
	k ^TMP("DHCCKB","web.DHCCKBBaseDemo","QueryDicComgrid",pid)
}

// w ##class(web.DHCCKBBaseDemo).WLog()

ClassMethod WLog() As %String
{
	k ^tlq("WLog")
	s i=0
	s datarowid=0
	f  s datarowid=$o(^CKB.PDSS.DicLogD(datarowid)) q:datarowid=""  d
	.s listData = $g(^CKB.PDSS.DicLogD(datarowid))
	.s datafun= $lg(listData,4)
	.q:datafun'="add"
	.s datadr= $lg(listData,3)
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(+datadr))
	.s datatypedr= $lg(^CT.CKB.PDSS.CommonDictionD(+datadr),4)
	.q:(datatypedr'="105")&&(datatypedr'="81790")
	.s dataname=$lg(^CT.CKB.PDSS.CommonDictionD(+datadr),3)
	.s datadate= $lg(listData,6) 
	.i datadate'="" s datadate=$zd(datadate,3)
	.s datatime=$lg(listData,7)
	.i datatime'="" s datatime=$zt(datatime,1)
	.s dataip=$lg(listData,10)
	.q:datadate'="2020-05-15"
	.//i datadr="81934" b
	.//q:(dataip'="10.10.0.1")  //&&(dataip'="180.166.22.190")&&(dataip'="183.195.7.206")
	.s i=i+1
	.w !,"i:"_i_"^"_dataip_"^"_datadate_"^"_datatime_"^"_dataname_"^"_datarowid
	.s tmpdata=dataip_"^"_datadate_"^"_datatime_"^"_datarowid_"^"_dataname
	.s ^tlq("WLog",tmpdata)=""
	
	/*
	s i=0
	s index=""
	f  s index=$o(^tlq("WLog",index)) q:index=""  d
	.s i=i+1
	.w !,"i:"_i_"^"_index
	*/
	
	q "end"
}

}
