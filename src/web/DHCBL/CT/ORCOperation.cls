Import SQLUser

/// 名称:手术和过程 - 18 手术/过程
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-9-19
Class web.DHCBL.CT.ORCOperation Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter SQLTableName = "ORC_Operation";

/// Creator:陈莹
/// CreatDate:2013-2-21
/// Description:查询 手术/过程
/// Table:User.ORCOperation
/// Input:rowid,code,desc
/// Return:OPERRowId,OPERCode,OPERDesc,OPERARCIMDR,OPERDateActiveFrom,OPERActiveDateTo,OPERDefaultCategoryDR,OPERAgeFrom,OPERAgeTo,OPERSexDR,OPERICD10,OPERICD9Map,OPERValid,OPERAgeFrom1,OPERAgeTo1,OPERLongDescription,OPERGrayCodeFlag,OPERDaySurgery
/// Other: w ##class(web.DHCBL.CT.ORCOperation).GetList("1","","","","","","","")
/// Query GetList(rowid As %String) As %SQLQuery(CONTAINID = 1)
ClassMethod GetList(rowid As %String, code As %String, desc As %String, icd10 As %String, icd9 As %String, category As %String, start As %String, limit As %String, activeflag As %String, hospid As %String, insucode As %String, insucodeflag As %String, versiondr As %String) As %String
{
	if start="" s start=0
	if limit="" s limit=20
	
	if (rowid'="")
	{
		
		w "{""data"":["
		s InsuInfo=##class(web.DHCBL.CT.ORCOperation).GetStdInsuInfo(rowid,hospid)
		s OPERInsuCode=$p(InsuInfo,"^",1)  //国家医保编码
		s OPERInsuDesc=$p(InsuInfo,"^",2)  //国家医保名称
		w ##class(web.DHCBL.CT.ORCOperation).GetItmByRowID(rowid,hospid,OPERInsuCode,OPERInsuDesc)
		w "],""total"":""1"",""success"":""true""}"
		
	}
	else
	{
		K ^TMPEXPORT("ORCOperation")
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s:icd10'="" icd10=$ZCONVERT(icd10,"U")
		s:icd9'="" icd9=$ZCONVERT(icd9,"U")
		s LookUpMode=##class(web.DHCBL.BDP.BDPAlias).GetConfig("ORC_Operation")
		s AuStr=##class(web.DHCBL.Authorize.ORCOperation).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s ARCIMRowIdAuStr=##class(web.DHCBL.Authorize.ARCItmMast).DHCGetDataByDefaultSession()
		if ($l(ARCIMRowIdAuStr,"#")=1) 
		{
			s Limited=0
			s AutBit=""
		}
		elseif ($l(ARCIMRowIdAuStr,"#")=2) 
		{
			s Limited=$p(ARCIMRowIdAuStr,"#",1)
			s AutBit=$p(ARCIMRowIdAuStr,"#",2)
 		}
		s ARCIMRowIdAuFlag=0
		if (ARCIMRowIdAuStr="")||((ARCIMRowIdAuStr'="")&(Limited=0)) s ARCIMRowIdAuFlag=1 //判断是否有授权,如果没有则全部显示
		s OPERDefaultCategoryDRAuStr=##class(web.DHCBL.Authorize.ORCOperationCategory).DHCGetDataByDefaultSession()
		s OPERDefaultCategoryDRAuFlag=0
		;未授权情况下，默认显示全部数据
		if (OPERDefaultCategoryDRAuStr="")||(OPERDefaultCategoryDRAuStr["limited:0") s OPERDefaultCategoryDRAuFlag=1
		s OPERSexDRAuStr=##class(web.DHCBL.Authorize.CTSex).DHCGetDataByDefaultSession()
		s OPERSexDRAuFlag=0
		;未授权情况下，默认显示全部数据
		if (OPERSexDRAuStr="")||(OPERSexDRAuStr["limited:0") s OPERSexDRAuFlag=1
		
		s count2=0
	    s start=start+1  ////start=0  从1条开始 不加会导致第一页显示的记录比设置的“每页显示记录数”少一条
	    
	    
	    s CurrentCount=0
        w "{""data"":["
	    
		s OPERRowId=0
		for
		{
			s OPERRowId=$o(^ORC("OPER",OPERRowId)) q:OPERRowId=""
			s ARCIMRowId=$p($g(^ORC("OPER",OPERRowId)),"^",4)  //ARCIMRowId=ARCIMSubscript||ARCIMVersion
			s ARCIMSubscript=$p(ARCIMRowId,"||",1)
			s OPERDefaultCategoryDR=$p($g(^ORC("OPER",OPERRowId)),"^",7)
			s OPERSexDR=$p($g(^ORC("OPER",OPERRowId)),"^",12)
			
			
			s strRowId="{ID:"_OPERRowId_"}"
			s OPERDefaultCategoryDRstrRowId="{ID:"_OPERDefaultCategoryDR_"}"
			s OPERSexDRstrRowId="{ID:"_OPERSexDR_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((OPERDefaultCategoryDRAuStr[OPERDefaultCategoryDRstrRowId)||(OPERDefaultCategoryDRAuFlag=1))&&((OPERSexDRAuStr[OPERSexDRstrRowId)||(OPERSexDRAuFlag=1))&&((ARCIMSubscript'="")&&($bit(AutBit,ARCIMSubscript)=1)||(ARCIMRowIdAuFlag=1)) ;用来筛选授权数据
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,OPERRowId,hospid)
				continue:showflag="N"
				s OPERCode=$p($g(^ORC("OPER",OPERRowId)),"^",1)
				s OPERDesc=$p($g(^ORC("OPER",OPERRowId)),"^",2)
				s OPERICD10=$p($g(^ORC("OPER",OPERRowId)),"^",14)
				s OPERICD9Map=$p($g(^ORC("OPER",OPERRowId)),"^",21)
				continue:($ZCONVERT(OPERCode,"U")'[code)
				continue:($ZCONVERT(OPERICD10,"U")'[icd10)
				continue:($ZCONVERT(OPERICD9Map,"U")'[icd9)
				continue:((category'="")&&(OPERDefaultCategoryDR'=category))
				
				if desc'=""
				{
					s AliasFlag=0
					s ALIASText1=""
					s ALIASChildsub=0
					for
					{
						s ALIASChildsub=$o(^ORC("OPER",OPERRowId,"ALIAS",ALIASChildsub)) q:ALIASChildsub=""					
						s ALIASText=$g(^ORC("OPER",OPERRowId,"ALIAS",ALIASChildsub))
						s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
					}
				
					s Flag1=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,OPERDesc,desc)
					s PINYIN="" //##class(web.DHCBL.BDP.FunLib).GetPYCODE(OPERDesc)
					s Flag2="" //##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,PINYIN,desc)
					s Flag3=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,ALIASText1,desc)
					if (Flag1=1)||(Flag2=1)||(Flag3=1) s AliasFlag=1
				}
				else
				{
					s AliasFlag=1
				}
				continue:(AliasFlag'=1)
				
				s OPERValid=$p($g(^ORC("OPER",OPERRowId)),"^",22)
				s:OPERValid="" OPERValid="Y"   //默认激活  20170725
				s OPERActiveDateTo=$p($g(^ORC("OPER",OPERRowId)),"^",6) //结束日期
					 
				
				//根据有效/无效过滤数据  
				if (activeflag="Y")
				{
					//结束日期为空，或者结束日期在今天之后，且有效标志为Y的数据为有效数据
					if '(((OPERActiveDateTo="")||((OPERActiveDateTo'="")&&(OPERActiveDateTo>=+$h)))&&(OPERValid="Y")) continue	
				}
				if (activeflag="N")
				{
					//结束日期不为空且结束日期在今天之前，或者有效标志为N的数据为无效数据
					if '(((OPERActiveDateTo'="")&&(OPERActiveDateTo<+$h))||(OPERValid="N")) continue
				}
				s OPERVersionDictDR=$p($g(^ORC("OPER",OPERRowId)),"^",41) //版本号
				continue:((versiondr'="")&&(OPERVersionDictDR'=versiondr))
				// 根据国家医保编码查询过滤数据
				s GettingFlag=0
				if ((insucode'="")||(insucodeflag'=""))
				{
					s GettingFlag=1
					s InsuInfo=##class(web.DHCBL.CT.ORCOperation).GetStdInsuInfo(OPERRowId,hospid)
					s OPERInsuCode=$p(InsuInfo,"^",1)  //国家医保编码
					s OPERInsuDesc=$p(InsuInfo,"^",2)  //国家医保名称
					if (OPERInsuCode'=-1)
					{
						continue:($ZCONVERT(OPERInsuCode,"U")'[$ZCONVERT(insucode,"U"))
						continue:(insucodeflag="Y")&&(OPERInsuCode="")
						continue:(insucodeflag="N")&&(OPERInsuCode'="")
					}
				}
				
				i ($ZCONVERT(OPERCode,"U")[code)&&(AliasFlag=1)&(OPERICD10[icd10)&(OPERICD9Map[icd9)&((OPERDefaultCategoryDR=category)||(category=""))
				{
					s count2=count2+1
					s ^TMPEXPORT("ORCOperation",count2)=OPERRowId
					if (count2<start) continue
					if ((count2<(start+limit)))
					{
						if (CurrentCount=0) 
						{
							s CurrentCount=1
						}
						else
						{  
							s CurrentCount=CurrentCount+1
							w ","
						}
						if (GettingFlag=0)
						{
							s InsuInfo=##class(web.DHCBL.CT.ORCOperation).GetStdInsuInfo(OPERRowId,hospid)
							s OPERInsuCode=$p(InsuInfo,"^",1)  //国家医保编码
							s OPERInsuDesc=$p(InsuInfo,"^",2)  //国家医保名称
						}
						w ##class(web.DHCBL.CT.ORCOperation).GetItmByRowID(OPERRowId,hospid,OPERInsuCode,OPERInsuDesc)
					}
				}
			}
		}
		w "],""total"":"""_count2_""",""success"":""true""}"
	}
	q ""
}

/// Creator:陈莹
/// CreatDate:2010-09-29
/// Description:查询 手术/过程
/// Table:User.ORCOperation
/// Input:rowid
/// Return:OPERRowId,OPERCode,OPERDesc,OPERARCIMDR,OPERDateActiveFrom,OPERActiveDateTo,OPERDefaultCategoryDR,OPERAgeFrom,OPERAgeTo,OPERSexDR,OPERICD10,OPERICD9Map,OPERValid,OPERAgeFrom1,OPERAgeTo1,OPERLongDescription,OPERGrayCodeFlag,OPERDaySurgery
/// Other: w ##class(web.DHCBL.CT.ORCOperation).GetItmByRowID("1","")
ClassMethod GetItmByRowID(rowid As %String, hospid As %String = "", OPERInsuCode As %String = "", OPERInsuDesc As %String = "") As %String
{
	n (rowid,hospid,OPERInsuCode,OPERInsuDesc)
	s OPERRowId=rowid
	s OPERCode=$p($g(^ORC("OPER",OPERRowId)),"^",1)
	s OPERDesc=$p($g(^ORC("OPER",OPERRowId)),"^",2)
	
	s ARCIMRowId=$p($g(^ORC("OPER",OPERRowId)),"^",4)  //ARCIMRowId=ARCIMSubscript||ARCIMVersion
	s ARCIMSubscript=$p(ARCIMRowId,"||",1)
	i ARCIMRowId'=""
	{
		s ARCIMVersion=$p(ARCIMRowId,"||",2)
		s OPERARCIMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)	
	}
	else
	{
		s OPERARCIMDR=""
	}
	
	s OPERDateActiveFrom=$p($g(^ORC("OPER",OPERRowId)),"^",5)
	s OPERActiveDateTo=$p($g(^ORC("OPER",OPERRowId)),"^",6)
	s:OPERDateActiveFrom'="" OPERDateActiveFrom=$zd(OPERDateActiveFrom,1)
	s:OPERActiveDateTo'="" OPERActiveDateTo=$zd(OPERActiveDateTo,1)
	s OPERDefaultCategoryDR=$p($g(^ORC("OPER",OPERRowId)),"^",7)
	i OPERDefaultCategoryDR'=""
	{
		s OPERDefaultCategoryDR=$p($g(^ORC("CATEG",OPERDefaultCategoryDR)),"^",2)
	}
	
	
	s OPERAgeFrom=$p($g(^ORC("OPER",OPERRowId)),"^",10)
	s OPERAgeTo=$p($g(^ORC("OPER",OPERRowId)),"^",11)
	s OPERSexDR=$p($g(^ORC("OPER",OPERRowId)),"^",12)
	i OPERSexDR'=""
	{
		s OPERSexDR=$p($g(^CT("SEX",OPERSexDR)),"^",2)
	}
	
	s OPERICD10=$p($g(^ORC("OPER",OPERRowId)),"^",14)
	s OPERICD9Map=$p($g(^ORC("OPER",OPERRowId)),"^",21)
	s OPERValid=$p($g(^ORC("OPER",OPERRowId)),"^",22)
	s:OPERValid="" OPERValid="Y"   //默认激活  20170725
	
	
	s OPERDaySurgery=$p($g(^ORC("OPER",OPERRowId)),"^",9)  //2017-3-8
	s OPERAgeFrom1=$p($g(^ORC("OPER",OPERRowId)),"^",24)
	s OPERAgeTo1=$p($g(^ORC("OPER",OPERRowId)),"^",25)
	s OPERLongDescription=$p($g(^ORC("OPER",OPERRowId)),"^",35)
	s OPERGrayCodeFlag=$p($g(^ORC("OPER",OPERRowId)),"^",40) //医保灰码标志
	s:OPERGrayCodeFlag="" OPERGrayCodeFlag="N"
	s OPERVersionDictDR=$p($g(^ORC("OPER",OPERRowId)),"^",41) //版本号
	s:OPERVersionDictDR'="" OPERVersionDictDR=$lg($g(^CT.BDP.CT.BDVersionDictD(OPERVersionDictDR)),4)
	s OPERStandardClassDR=$p($g(^ORC("OPER",OPERRowId)),"^",42) //国家标准分级
	s:OPERStandardClassDR'="" OPERStandardClassDR=$p($g(^ORC("CATEG",OPERStandardClassDR)),"^",2)
	
	s OPERBladeDr=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",3)  //手术切口类型
	s:OPERBladeDr'="" OPERBladeDr=$p($g(^ORC("BLDTP",OPERBladeDr)),"^",2)
	s OPERBodySiteDr=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",2) //手术部位表
	s:OPERBodySiteDr'="" OPERBodySiteDr=$p($g(^OEC("BODS",OPERBodySiteDr)),"^",2)
	s OPEROperPositionDr=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",4)  //手术体位
	s:OPEROperPositionDr'="" OPEROperPositionDr=$p($g(^ORC("OPPOS",OPEROperPositionDr)),"^",2)
	s OPERDefaultOperLocDr=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",10)  //默认手术室
	s:OPERDefaultOperLocDr'="" OPERDefaultOperLocDr=$p($G(^CTLOC(OPERDefaultOperLocDr)),"^",2)	
	s OPERCategoryDr=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",16)   //手术分类
	s:OPERCategoryDr'="" OPERCategoryDr=$LISTGET($G(^DHCANC("OperationCat",OPERCategoryDr)),2)	
	s OPERType=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",11)  //手术操作类别
	if OPERType="O" S OPERType="N"
	s OPERIsKeyOperation=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",7)  //是否重点手术
	s OPERIsUploadCode=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",17)  //是否有上传编码
	s OPERTechnique=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",18)  //使用技术
	s OPERIsSpecial=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",20)  //是否特殊手术
	s OPERIsHighRisk=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",21)  //是否高风险技术
	s OPERIsAudit=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",22)  //是否审批技术
	s OPERIsPacs=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",23)  //是否有PACS影像
	s OPERIsSupplierPreparation=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",26)  //是否供应商备货
	
	s OPERIsProtectiveAntibacterial=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",27)  //是否使用预防性抗菌药物
	
	s OPERApplyFeature=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",28)  //手术应用特性
	s OPERIsMinInvasive=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",29)  //是否微创手术
	s OPERIsSubOperation=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",30)  // 是否子手术
	s OPERIsRestrictedTechnology=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",31)  // 是否限制类技术
	s OPERIsNewItem=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",32)  // 是否限制类技术
	
	if OPERDaySurgery="" s OPERDaySurgery="N"
	if OPERIsUploadCode="" s OPERIsUploadCode="N"
	if OPERIsKeyOperation="" s OPERIsKeyOperation="N"
	if OPERIsSpecial="" s OPERIsSpecial="N"
	if OPERIsHighRisk="" s OPERIsHighRisk="N"
	if OPERIsAudit="" s OPERIsAudit="N"
	if OPERIsPacs="" s OPERIsPacs="N"
	if OPERIsSupplierPreparation="" s OPERIsSupplierPreparation="N"
	if OPERIsSupplierPreparation="1" s OPERIsSupplierPreparation="Y"
	if OPERIsSupplierPreparation="0" s OPERIsSupplierPreparation="N"
	if OPERIsProtectiveAntibacterial="" s OPERIsProtectiveAntibacterial="N"
	if OPERIsProtectiveAntibacterial="1" s OPERIsProtectiveAntibacterial="Y"
	if OPERIsProtectiveAntibacterial="0" s OPERIsProtectiveAntibacterial="N"
	if OPERIsMinInvasive="" s OPERIsMinInvasive="N"
	if OPERIsSubOperation="" s OPERIsSubOperation="N"
	if OPERIsRestrictedTechnology="" s OPERIsRestrictedTechnology="N"
	if OPERIsNewItem="" s OPERIsNewItem="N"
	
	//s OPERInsuCode=$p($g(^ORC("OPER",OPERRowId)),"^",38)  //国家医保编码  2021-11-12
	//s OPERInsuDesc=$p($g(^ORC("OPER",OPERRowId)),"^",39)  //国家医保名称
	//s InsuInfo=##class(web.DHCBL.CT.ORCOperation).GetStdInsuInfo(OPERRowId,hospid)
	//s OPERInsuCode=$p(InsuInfo,"^",1)  //国家医保编码  2022-04-11
	//s OPERInsuDesc=$p(InsuInfo,"^",2)  //国家医保名称
	
	s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_Operation",OPERRowId)
	s BDPInternalCode =$p($g(resultStr),"^",1)
	s BDPInternalDesc = $p($g(resultStr),"^",2)
	s BDPHospNationalCode=$p($g(resultStr),"^",3)  
	s BDPHospNationalDesc = $p($g(resultStr),"^",4)
	s OPERCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(OPERCode)
	s OPERDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(OPERDesc)
	s OPERARCIMDR=##class(web.DHCBL.BDP.FunLib).EvalJSON(OPERARCIMDR)
	s OPERLongDescription=##class(web.DHCBL.BDP.FunLib).EvalJSON(OPERLongDescription)
	if OPERDesc["?"  s OPERDesc=$tr(OPERDesc,"?","")
	s ret= "{""OPERRowId"":"""_OPERRowId_""",""OPERCode"":"""_OPERCode_""",""OPERDesc"":"""_OPERDesc_""",""OPERARCIMDR"":"""_OPERARCIMDR_""",""OPERDateActiveFrom"":"""_OPERDateActiveFrom_""",""OPERActiveDateTo"":"""_OPERActiveDateTo_""",""OPERDefaultCategoryDR"":"""_OPERDefaultCategoryDR_""",""OPERAgeFrom"":"""_OPERAgeFrom_""",""OPERAgeTo"":"""_OPERAgeTo_""",""OPERSexDR"":"""_OPERSexDR_""",""OPERICD10"":"""_OPERICD10_""",""OPERICD9Map"":"""_OPERICD9Map_""",""OPERValid"":"""_OPERValid_""",""OPERDaySurgery"":"""_OPERDaySurgery_""",""OPERAgeFrom1"":"""_OPERAgeFrom1_""",""OPERAgeTo1"":"""_OPERAgeTo1_""",""OPERLongDescription"":"""_OPERLongDescription_""",""OPERVersionDictDR"":"""_OPERVersionDictDR_""",""OPERStandardClassDR"":"""_OPERStandardClassDR_""",""OPERBladeDr"":"""_OPERBladeDr_""",""OPERBodySiteDr"":"""_OPERBodySiteDr_""",""OPEROperPositionDr"":"""_OPEROperPositionDr_""",""OPERDefaultOperLocDr"":"""_OPERDefaultOperLocDr_""",""OPERCategoryDr"":"""_OPERCategoryDr_""",""OPERType"":"""_OPERType_""",""OPERApplyFeature"":"""_OPERApplyFeature_""",""OPERIsKeyOperation"":"""_OPERIsKeyOperation_""",""OPERIsUploadCode"":"""_OPERIsUploadCode_""",""OPERTechnique"":"""_OPERTechnique_""",""OPERIsSpecial"":"""_OPERIsSpecial_""",""OPERIsHighRisk"":"""_OPERIsHighRisk_""",""OPERIsAudit"":"""_OPERIsAudit_""",""OPERIsPacs"":"""_OPERIsPacs_""",""OPERIsSupplierPreparation"":"""_OPERIsSupplierPreparation_""",""OPERIsProtectiveAntibacterial"":"""_OPERIsProtectiveAntibacterial_""",""OPERIsMinInvasive"":"""_OPERIsMinInvasive_""",""OPERIsSubOperation"":"""_OPERIsSubOperation_""",""OPERIsRestrictedTechnology"":"""_OPERIsRestrictedTechnology_""",""OPERIsNewItem"":"""_OPERIsNewItem_""",""OPERInsuCode"":"""_OPERInsuCode_""",""OPERInsuDesc"":"""_OPERInsuDesc_""",""OPERGrayCodeFlag"":"""_OPERGrayCodeFlag_""",""BDPInternalCode"":"""_BDPInternalCode_""",""BDPInternalDesc"":"""_BDPInternalDesc_""",""BDPHospNationalCode"":"""_BDPHospNationalCode_""",""BDPHospNationalDesc"":"""_BDPHospNationalDesc_"""}" 
	q ret
}

/// Creator:陈莹
/// CreatDate:2013-2-22
/// Description:为combobox查询取数据
/// Table:User.ORCOperation
/// Input:code,desc
/// Return:OPERRowId,OPERCode,OPERDesc,OPERICD10
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCOperation","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "OPERRowId:%String,OPERCode:%String,OPERDesc:%String,OPERICD10:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s OPERRowId=rowid
		s OPERCode=$p($g(^ORC("OPER",OPERRowId)),"^",1)
		s OPERDesc=$p($g(^ORC("OPER",OPERRowId)),"^",2)
		//s OPERCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(OPERCode)
		//s OPERDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(OPERDesc)
		s OPERICD10=$p($g(^ORC("OPER",OPERRowId)),"^",14)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s LookUpMode=##class(web.DHCBL.BDP.BDPAlias).GetConfig("ORC_Operation")
		
		s AuStr=##class(web.DHCBL.Authorize.ORCOperation).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s ARCIMRowIdAuStr=##class(web.DHCBL.Authorize.ARCItmMast).DHCGetDataByDefaultSession()
		if ($l(ARCIMRowIdAuStr,"#")=1) 
		{
			s Limited=0
			s AutBit=""
		}
		elseif ($l(ARCIMRowIdAuStr,"#")=2) 
		{
			s Limited=$p(ARCIMRowIdAuStr,"#",1)
			s AutBit=$p(ARCIMRowIdAuStr,"#",2)
 		}
		s ARCIMRowIdAuFlag=0
		if (ARCIMRowIdAuStr="")||((ARCIMRowIdAuStr'="")&(Limited=0)) s ARCIMRowIdAuFlag=1 //判断是否有授权,如果没有则全部显示
		s OPERDefaultCategoryDRAuStr=##class(web.DHCBL.Authorize.ORCOperationCategory).DHCGetDataByDefaultSession()
		s OPERDefaultCategoryDRAuFlag=0
		;未授权情况下，默认显示全部数据
		if (OPERDefaultCategoryDRAuStr="")||(OPERDefaultCategoryDRAuStr["limited:0") s OPERDefaultCategoryDRAuFlag=1
		s OPERSexDRAuStr=##class(web.DHCBL.Authorize.CTSex).DHCGetDataByDefaultSession()
		s OPERSexDRAuFlag=0
		;未授权情况下，默认显示全部数据
		if (OPERSexDRAuStr="")||(OPERSexDRAuStr["limited:0") s OPERSexDRAuFlag=1
		s OPERRowId=0
		for
		{
			s OPERRowId=$o(^ORC("OPER",OPERRowId)) q:OPERRowId=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,OPERRowId,hospid)
			continue:showflag="N"
			s ARCIMRowId=$p($g(^ORC("OPER",OPERRowId)),"^",4)  //ARCIMRowId=ARCIMSubscript||ARCIMVersion
			s ARCIMSubscript=$p(ARCIMRowId,"||",1)
			s OPERDefaultCategoryDR=$p($g(^ORC("OPER",OPERRowId)),"^",7)
			s OPERSexDR=$p($g(^ORC("OPER",OPERRowId)),"^",12)
			
			
			s strRowId="{ID:"_OPERRowId_"}"
			s OPERDefaultCategoryDRstrRowId="{ID:"_OPERDefaultCategoryDR_"}"
			s OPERSexDRstrRowId="{ID:"_OPERSexDR_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((OPERDefaultCategoryDRAuStr[OPERDefaultCategoryDRstrRowId)||(OPERDefaultCategoryDRAuFlag=1))&&((OPERSexDRAuStr[OPERSexDRstrRowId)||(OPERSexDRAuFlag=1))&&((ARCIMSubscript'="")&&($bit(AutBit,ARCIMSubscript)=1)||(ARCIMRowIdAuFlag=1)) ;用来筛选授权数据
			{
				s OPERCode=$p($g(^ORC("OPER",OPERRowId)),"^",1)
				s OPERDesc=$p($g(^ORC("OPER",OPERRowId)),"^",2)
				//s OPERCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(OPERCode)
				//s OPERDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(OPERDesc)
				s OPERICD10=$p($g(^ORC("OPER",OPERRowId)),"^",14)
				s OPERDateActiveFrom=$p($g(^ORC("OPER",OPERRowId)),"^",5)
				continue:(OPERDateActiveFrom'="")&&(OPERDateActiveFrom>+$h)
				s OPERActiveDateTo=$p($g(^ORC("OPER",OPERRowId)),"^",6)
				continue:(OPERActiveDateTo'="")&&(OPERActiveDateTo<+$h)
				
				s OPERValid=$p($g(^ORC("OPER",OPERRowId)),"^",22)
				continue:OPERValid="N"	
				
				
				if desc'=""
				{
					s AliasFlag=0
					s ALIASText1=""
					s ALIASChildsub=0
					for
					{
						s ALIASChildsub=$o(^ORC("OPER",OPERRowId,"ALIAS",ALIASChildsub)) q:ALIASChildsub=""					
						s ALIASText=$g(^ORC("OPER",OPERRowId,"ALIAS",ALIASChildsub))
						s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
					}
				
					s Flag1=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,OPERDesc,desc)
					s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(OPERDesc)
					s Flag2=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,PINYIN,desc)
					s Flag3=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,ALIASText1,desc)
					if (Flag1=1)||(Flag2=1)||(Flag3=1) s AliasFlag=1
				}
				else
				{
					s AliasFlag=1
				}
				i ($ZCONVERT(OPERCode,"U")[code)&(AliasFlag=1)
				{
				
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(OPERRowId,OPERCode,OPERDesc,OPERICD10)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：chenying
/// CreatDate: 2017-06-14
/// Description：查询手术的内容  真分页  下拉框调用
/// Table：User.ORCOperation
/// Input：rowid,code,desc
/// Return: 
/// w ##class(web.DHCBL.CT.ORCOperation).GetDataForCmbM("","","","0","10")
ClassMethod GetDataForCmbM(rowid As %String, code As %String, desc As %String, start As %String, limit As %String) As %String
{
	if start="" s start=0
	if limit="" s limit=20
	
	if (rowid'="")
	{
		s OPERRowId=rowid
		s OPERCode=$p($g(^ORC("OPER",OPERRowId)),"^",1)
		s OPERDesc=$p($g(^ORC("OPER",OPERRowId)),"^",2)
		s OPERCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(OPERCode)
		s OPERDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(OPERDesc)
		s OPERICD10=$p($g(^ORC("OPER",OPERRowId)),"^",14)
		w "{""data"":["
		w "{""OPERRowId"":"""_OPERRowId_""",""OPERCode"":"""_OPERCode_""",""OPERDesc"":"""_OPERDesc_""",""OPERICD10"":"""_OPERICD10_"""}" 
 		w "],""total"":""1"",""success"":""true""}"
		
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s LookUpMode=##class(web.DHCBL.BDP.BDPAlias).GetConfig("ORC_Operation")
		s AuStr=##class(web.DHCBL.Authorize.ORCOperation).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s ARCIMRowIdAuStr=##class(web.DHCBL.Authorize.ARCItmMast).DHCGetDataByDefaultSession()
		if ($l(ARCIMRowIdAuStr,"#")=1) 
		{
			s Limited=0
			s AutBit=""
		}
		elseif ($l(ARCIMRowIdAuStr,"#")=2) 
		{
			s Limited=$p(ARCIMRowIdAuStr,"#",1)
			s AutBit=$p(ARCIMRowIdAuStr,"#",2)
 		}
		s ARCIMRowIdAuFlag=0
		if (ARCIMRowIdAuStr="")||((ARCIMRowIdAuStr'="")&(Limited=0)) s ARCIMRowIdAuFlag=1 //判断是否有授权,如果没有则全部显示
		s OPERDefaultCategoryDRAuStr=##class(web.DHCBL.Authorize.ORCOperationCategory).DHCGetDataByDefaultSession()
		s OPERDefaultCategoryDRAuFlag=0
		;未授权情况下，默认显示全部数据
		if (OPERDefaultCategoryDRAuStr="")||(OPERDefaultCategoryDRAuStr["limited:0") s OPERDefaultCategoryDRAuFlag=1
		s OPERSexDRAuStr=##class(web.DHCBL.Authorize.CTSex).DHCGetDataByDefaultSession()
		s OPERSexDRAuFlag=0
		;未授权情况下，默认显示全部数据
		if (OPERSexDRAuStr="")||(OPERSexDRAuStr["limited:0") s OPERSexDRAuFlag=1
		
		s count2=0
	    s start=start+1  ////start=0  从1条开始 不加会导致第一页显示的记录比设置的“每页显示记录数”少一条
	    
	    s CurrentCount=0
        w "{""data"":["
	    
		s OPERRowId=0
		for
		{
			s OPERRowId=$o(^ORC("OPER",OPERRowId)) q:OPERRowId=""
			s flag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetShowDataFlag(..#SQLTableName,OPERRowId)
			continue:flag="N"
			s ARCIMRowId=$p($g(^ORC("OPER",OPERRowId)),"^",4)  //ARCIMRowId=ARCIMSubscript||ARCIMVersion
			s ARCIMSubscript=$p(ARCIMRowId,"||",1)
			s OPERDefaultCategoryDR=$p($g(^ORC("OPER",OPERRowId)),"^",7)
			s OPERSexDR=$p($g(^ORC("OPER",OPERRowId)),"^",12)
			
			
			s strRowId="{ID:"_OPERRowId_"}"
			s OPERDefaultCategoryDRstrRowId="{ID:"_OPERDefaultCategoryDR_"}"
			s OPERSexDRstrRowId="{ID:"_OPERSexDR_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((OPERDefaultCategoryDRAuStr[OPERDefaultCategoryDRstrRowId)||(OPERDefaultCategoryDRAuFlag=1))&&((OPERSexDRAuStr[OPERSexDRstrRowId)||(OPERSexDRAuFlag=1))&&((ARCIMSubscript'="")&&($bit(AutBit,ARCIMSubscript)=1)||(ARCIMRowIdAuFlag=1)) ;用来筛选授权数据
			{
				s OPERCode=$p($g(^ORC("OPER",OPERRowId)),"^",1)
				s OPERDesc=$p($g(^ORC("OPER",OPERRowId)),"^",2)
				s OPERCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(OPERCode)
				s OPERDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(OPERDesc)
				s OPERDateActiveFrom=$p($g(^ORC("OPER",OPERRowId)),"^",5)
				continue:(OPERDateActiveFrom'="")&&(OPERDateActiveFrom>+$h)
				s OPERActiveDateTo=$p($g(^ORC("OPER",OPERRowId)),"^",6)
				continue:(OPERActiveDateTo'="")&&(OPERActiveDateTo<+$h)
				
				s OPERValid=$p($g(^ORC("OPER",OPERRowId)),"^",22)
				continue:OPERValid="N"	
				
				s OPERICD10=$p($g(^ORC("OPER",OPERRowId)),"^",14)
				s OPERICD9Map=$p($g(^ORC("OPER",OPERRowId)),"^",21)
				
				if desc'=""
				{
					s AliasFlag=0
					s ALIASText1=""
					s ALIASChildsub=0
					for
					{
						s ALIASChildsub=$o(^ORC("OPER",OPERRowId,"ALIAS",ALIASChildsub)) q:ALIASChildsub=""					
						s ALIASText=$g(^ORC("OPER",OPERRowId,"ALIAS",ALIASChildsub))
						s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
					}
				
					s Flag1=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,OPERDesc,desc)
					s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(OPERDesc)
					s Flag2=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,PINYIN,desc)
					s Flag3=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,ALIASText1,desc)
					if (Flag1=1)||(Flag2=1)||(Flag3=1) s AliasFlag=1
				}
				else
				{
					s AliasFlag=1
				}
				i ($ZCONVERT(OPERCode,"U")[code)&&(AliasFlag=1)
				{
					s count2=count2+1
					if (count2<start) continue
					if ((count2<(start+limit)))
					{
									
						if (CurrentCount=0) 
						{
							s CurrentCount=1
						}
						else
						{  
							s CurrentCount=CurrentCount+1
							w ","
						}
						
						w "{""OPERRowId"":"""_OPERRowId_""",""OPERCode"":"""_OPERCode_""",""OPERDesc"":"""_OPERDesc_""",""OPERICD10"":"""_OPERICD10_"""}" 
	 				}
				}
			}
		}
		w "],""total"":"""_count2_""",""success"":""true""}"
	}
	q ""
}

/// Creator:陈莹
/// CreatDate:2012-12-24
/// Description:数据重复验证方法,js调用
/// Table:User.MRCICDDx
/// Input:id, code, desc, hospid,enddate（结束日期）
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.ORCOperation).FormValidate("","00.02001","心脏治疗性超声","3","")
/// 校验：2021-01-15 代码和描述都重复时返回1(有结束日期和有效标志为N的不校验
/// 20221229增加版本号入参
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "", enddate As %String = "", versiondr As %String = "") As %String
{
	new (id,code,desc,hospid,enddate,versiondr)
	
	s flag=0
	///2021-01-22 chenying  停掉的数据不校验名称和代码
	if enddate'="" q flag
	s ConfigType="OPERCONFIG"
	s ValidCode=$p($g(^Config.BDPSpeConfig("OPERCONFIG")),"^",1)         //校验代码+描述是否重复，默认true
	s:ValidCode="" ValidCode="true"
	if (ValidCode="true")&&($$ALPHAUP^SSUTIL4(code)'="")&&(desc'="")
	{
		s rowid=0
		for
		{
			s rowid=$o(^ORC("OPER",0,"Code",$$ALPHAUP^SSUTIL4(code),rowid)) q:rowid=""
			s OPERCode=$p($g(^ORC("OPER",rowid)),"^",1)  //手术代码
			s OPERDesc=$p($g(^ORC("OPER",rowid)),"^",2)  //手术名称
			s OPERActiveDateTo=$p($g(^ORC("OPER",rowid)),"^",6)  //结束日期
			continue:(OPERActiveDateTo'="")
			s OPERValid=$p($g(^ORC("OPER",rowid)),"^",22)  //有效标志
			continue:(OPERValid="N")
			
			s OPERVersionDictDR=$p($g(^ORC("OPER",rowid)),"^",41) //版本号
			continue:(OPERVersionDictDR'=versiondr)
			if ((OPERCode=code)&&(OPERDesc=desc)&&(id'=rowid))
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,rowid,hospid)
				continue:showflag="N"
				s flag=1
			}
		
		}
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-19
/// Description:双击修改时,从后台取数据
/// Table:User.ORCOperation
/// Input:id
/// Return:Json格式的字符串str={list:[OPERCode,OPERDesc,OPERARCIMDR,OPERDateActiveFrom,OPERActiveDateTo,
/// 						OPERDefaultCategoryDR,OPERAgeFrom,OPERAgeTo,OPERSexDR,OPERICD10,OPERICD9Map,
/// 						OPERValid,OPERAgeFrom1,OPERAgeTo1,OPERLongDescription,OPERGrayCodeFlag,OPERRowId]}
/// Other:w ##class(web.DHCBL.CT.ORCOperation).OpenData2("1")
ClassMethod OpenData2(id As %String, hospid As %String = "") As %String
{
	new (id,hospid)
	s str=""
	s pobj = ##class(User.ORCOperation).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCOperation2).%New()
	s eobj.OPERRowId = id
	s eobj.OPERCode = pobj.OPERCode
	s eobj.OPERDesc = pobj.OPERDesc
	if $IsObject(pobj.OPERARCIMDR){
		s eobj.OPERARCIMDR = pobj.OPERARCIMDR.%Id() 
	}
	s eobj.OPERDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.OPERDateActiveFrom)
	s eobj.OPERActiveDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.OPERActiveDateTo)
	
	if $IsObject(pobj.OPERDefaultCategoryDR){
		s eobj.OPERDefaultCategoryDR = pobj.OPERDefaultCategoryDR.%Id() 
	}
	s eobj.OPERAgeFrom = pobj.OPERAgeFrom
	s eobj.OPERAgeTo = pobj.OPERAgeTo
	if $IsObject(pobj.OPERSexDR){
		s eobj.OPERSexDR = pobj.OPERSexDR.%Id() 
	}
	s eobj.OPERICD10 = pobj.OPERICD10
	s eobj.OPERICD9Map = pobj.OPERICD9Map
	//checkbox
	s:(pobj.OPERValid="Y")||(pobj.OPERValid="") eobj.OPERValid="true"   //默认有效
	s:pobj.OPERDaySurgery="Y" eobj.OPERDaySurgery="true"
	
	s eobj.OPERAgeFrom1 = pobj.OPERAgeFrom1
	s eobj.OPERAgeTo1 = pobj.OPERAgeTo1
	s eobj.OPERLongDescription = pobj.OPERLongDescription
	if $IsObject(pobj.OPERVersionDictDR)
	{
		s eobj.OPERVersionDictDR = pobj.OPERVersionDictDR.%Id()  //版本号
	}
	if $IsObject(pobj.OPERStandardClassDR)
	{
		s eobj.OPERStandardClassDR = pobj.OPERStandardClassDR.%Id()  //国家标准分级
	}
	//s eobj.OPERInsuCode = pobj.OPERInsuCode
	//s eobj.OPERInsuDesc = pobj.OPERInsuDesc
	//2022-04-11
	s InsuInfo=##class(web.DHCBL.CT.ORCOperation).GetStdInsuInfo(id,hospid)
	s eobj.OPERInsuCode = $p(InsuInfo,"^",1)  //国家医保编码  2022-04-11
	s eobj.OPERInsuDesc =$p(InsuInfo,"^",2)  //国家医保名称
	s eobj.OPERGrayCodeFlag=pobj.OPERGrayCodeFlag
	s:pobj.OPERGrayCodeFlag="Y" eobj.OPERGrayCodeFlag="true"
	
	s pobj2 = ##class(User.ORCOperationExtend).%OpenId(id)
	if $IsObject(pobj2.OPERClassDr){
		s eobj.OPERClassDr = pobj2.OPERClassDr.%Id() 
	}	
	if $IsObject(pobj2.OPERBladeDr){
		s eobj.OPERBladeDr = pobj2.OPERBladeDr.%Id() 
	}
	if $IsObject(pobj2.OPERBodySiteDr){
		s eobj.OPERBodySiteDr = pobj2.OPERBodySiteDr.%Id() 
	}
	if $IsObject(pobj2.OPEROperPositionDr){
		s eobj.OPEROperPositionDr = pobj2.OPEROperPositionDr.%Id() 
	}
	if $IsObject(pobj2.OPERDefaultOperLocDr){
		s eobj.OPERDefaultOperLocDr = pobj2.OPERDefaultOperLocDr.%Id() 
	}
	if $IsObject(pobj2.OPERCategoryDr){
		s eobj.OPERCategoryDr = pobj2.OPERCategoryDr.%Id() 
	}

	s eobj.OPERSurgeonDeptDr = pobj2.OPERSurgeonDeptDr  //手术医生科室Id(|分割)

	S OPERSurgeonDeptDrDesc=""
	if (pobj2.OPERSurgeonDeptDr'="")
	{
		s Length=$l(pobj2.OPERSurgeonDeptDr,"|")
		if Length>0
		{
			for i=1:1:Length
			{
				s LocID=$P(pobj2.OPERSurgeonDeptDr,"|",i)
				s LocDesc=""
				if LocID'="" s LocDesc=$p($G(^CTLOC(LocID)),"^",2)
				
				if OPERSurgeonDeptDrDesc'="" 
				{
					S OPERSurgeonDeptDrDesc=OPERSurgeonDeptDrDesc_","_LocDesc
				}
				else
				{
					S OPERSurgeonDeptDrDesc=LocDesc
				}
				
			}
		}
		
	}
	s eobj.OPERSurgeonDeptDrDesc =OPERSurgeonDeptDrDesc
	
	s eobj.OPERIsKeyOperation = pobj2.OPERIsKeyOperation
	s eobj.OPERScrubNurseClass = pobj2.OPERScrubNurseClass
	s eobj.OPERCirculNurseClass = pobj2.OPERCirculNurseClass
	s eobj.OPERType = pobj2.OPERType
	s:pobj2.OPERType="O" eobj.OPERType="N" //2018-11-2 去掉O类型 跟N一样的
	s eobj.OPERRegType = pobj2.OPERRegType
	s eobj.OPERIsUploadCode = pobj2.OPERIsUploadCode
	s eobj.OPERTechnique = pobj2.OPERTechnique
	s eobj.OPERMedicalTechniqueLevel = pobj2.OPERMedicalTechniqueLevel
	s eobj.OPERIsSpecial = pobj2.OPERIsSpecial
	s eobj.OPERIsHighRisk = pobj2.OPERIsHighRisk
	s eobj.OPERIsAudit = pobj2.OPERIsAudit
	s eobj.OPERIsPacs = pobj2.OPERIsPacs
	s eobj.OPERHospitalDr = pobj2.OPERHospitalDr  //医院Id(|分割)
	
	s eobj.OPERIsSupplierPreparation = pobj2.OPERIsSupplierPreparation
	s eobj.OPERIsProtectiveAntibacterial = pobj2.OPERIsProtectiveAntibacterial
	
	S OPERHospitalDrDesc=""
	if (pobj2.OPERHospitalDr'="")
	{
		s Length=$l(pobj2.OPERHospitalDr,"|")
		if Length>0
		{
			for i=1:1:Length
			{
				s HOSPID=$P(pobj2.OPERHospitalDr,"|",i)
				s HOSPDesc=""
				if HOSPID'="" s HOSPDesc=$p($g(^CT("HOSP",HOSPID)),"^",2)
				
				if OPERHospitalDrDesc'="" 
				{
					S OPERHospitalDrDesc=OPERHospitalDrDesc_","_HOSPDesc
				}
				else
				{
					S OPERHospitalDrDesc=HOSPDesc
				}
				
			}
		}
	}
	s eobj.OPERHospitalDrDesc =OPERHospitalDrDesc
	s eobj.OPERAbbreviation = pobj2.OPERAbbreviation
	s:pobj2.OPERIsKeyOperation="Y" eobj.OPERIsKeyOperation="true"
	s:pobj2.OPERIsUploadCode="Y" eobj.OPERIsUploadCode="true"
	s:pobj2.OPERIsSpecial="Y" eobj.OPERIsSpecial="true"
	s:pobj2.OPERIsHighRisk="Y" eobj.OPERIsHighRisk="true"
	s:pobj2.OPERIsAudit="Y" eobj.OPERIsAudit="true"
	s:pobj2.OPERIsPacs="Y" eobj.OPERIsPacs="true"

	s:pobj2.OPERIsSupplierPreparation="1" eobj.OPERIsSupplierPreparation="true"
	s:pobj2.OPERIsProtectiveAntibacterial="1" eobj.OPERIsProtectiveAntibacterial="true"
	s eobj.OPERApplyFeature = pobj2.OPERApplyFeature  //手术应用特性
	s eobj.OPERIsMinInvasive = pobj2.OPERIsMinInvasive   //是否微创手术
	s:pobj2.OPERIsMinInvasive="Y" eobj.OPERIsMinInvasive="true"
	
	s eobj.OPERIsSubOperation = pobj2.OPERIsSubOperation   //是否子手术
	s:pobj2.OPERIsSubOperation="Y" eobj.OPERIsSubOperation="true"
	s eobj.OPERIsRestrictedTechnology = pobj2.OPERIsRestrictedTechnology   //是否限制类技术
	s:pobj2.OPERIsRestrictedTechnology="Y" eobj.OPERIsRestrictedTechnology="true"
	s eobj.OPERIsNewItem = pobj2.OPERIsNewItem   //是否新项目新技术
	s:pobj2.OPERIsNewItem="Y" eobj.OPERIsNewItem="true"
	
	
	d pobj.%Close()
	d pobj2.%Close()
	s str = "{list:["_eobj.JsonS()_"]}"
	q str
}

ClassMethod OpenData(id As %String, hospid As %String = "") As %String
{
	new (id,hospid)
	s str=""
	s pobj = ##class(User.ORCOperation).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCOperation).%New()
	s eobj.OPERRowId = id
	s eobj.OPERCode = pobj.OPERCode
	s eobj.OPERDesc = pobj.OPERDesc
	if $IsObject(pobj.OPERARCIMDR){
		s eobj.OPERARCIMDR = pobj.OPERARCIMDR.%Id() 
	}
	s eobj.OPERDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.OPERDateActiveFrom)
	s eobj.OPERActiveDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.OPERActiveDateTo)
	
	if $IsObject(pobj.OPERDefaultCategoryDR){
		s eobj.OPERDefaultCategoryDR = pobj.OPERDefaultCategoryDR.%Id() 
	}
	s eobj.OPERAgeFrom = pobj.OPERAgeFrom
	s eobj.OPERAgeTo = pobj.OPERAgeTo
	if $IsObject(pobj.OPERSexDR){
		s eobj.OPERSexDR = pobj.OPERSexDR.%Id() 
	}
	s eobj.OPERICD10 = pobj.OPERICD10
	s eobj.OPERICD9Map = pobj.OPERICD9Map
	//checkbox
	s:(pobj.OPERValid="Y")||(pobj.OPERValid="") eobj.OPERValid="true"   //默认有效
	s:pobj.OPERDaySurgery="Y" eobj.OPERDaySurgery="true"
	
	s eobj.OPERAgeFrom1 = pobj.OPERAgeFrom1
	s eobj.OPERAgeTo1 = pobj.OPERAgeTo1
	s eobj.OPERLongDescription = pobj.OPERLongDescription
	if $IsObject(pobj.OPERVersionDictDR)
	{
		s eobj.OPERVersionDictDR = pobj.OPERVersionDictDR.%Id()  //版本号
	}
	if $IsObject(pobj.OPERStandardClassDR)
	{
		s eobj.OPERStandardClassDR = pobj.OPERStandardClassDR.%Id()  //国家标准分级
	}
	//s eobj.OPERInsuCode = pobj.OPERInsuCode
	//s eobj.OPERInsuDesc = pobj.OPERInsuDesc
	//2022-04-11
	s InsuInfo=##class(web.DHCBL.CT.ORCOperation).GetStdInsuInfo(id,hospid)
	s eobj.OPERInsuCode =$p(InsuInfo,"^",1)  //国家医保编码  2022-04-11
	s eobj.OPERInsuDesc = $p(InsuInfo,"^",2)  //国家医保名称
	s eobj.OPERGrayCodeFlag=pobj.OPERGrayCodeFlag
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2012-9-19
/// Description:双击修改时,快速复制手术，从后台取数据
/// Table:User.ORCOperation
/// Input:id
/// Return:Json格式的字符串str={list:[OPERCode,OPERDesc,OPERARCIMDR,OPERDateActiveFrom,OPERActiveDateTo,
/// 						OPERDefaultCategoryDR,OPERAgeFrom,OPERAgeTo,OPERSexDR,OPERICD10,OPERICD9Map,
/// 						OPERValid,OPERAgeFrom1,OPERAgeTo1,OPERLongDescription,OPERRowId]}
/// Other:w ##class(web.DHCBL.CT.ORCOperation).CopyData("1")
ClassMethod CopyData(id As %String, hospid As %String = "") As %String
{
	new (id,hospid)
	s str=""
	s pobj = ##class(User.ORCOperation).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCOperation2).%New()
	s eobj.OPERRowId = ""
	s eobj.OPERCode =##class(web.DHCBL.CT.ORCOperation).AutoCreateCode()
	s eobj.OPERDesc = pobj.OPERDesc
	if $IsObject(pobj.OPERARCIMDR){
		s eobj.OPERARCIMDR = pobj.OPERARCIMDR.%Id() 
	}
	s eobj.OPERDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	s eobj.OPERActiveDateTo=""
	
	if $IsObject(pobj.OPERDefaultCategoryDR){
		s eobj.OPERDefaultCategoryDR = pobj.OPERDefaultCategoryDR.%Id() 
	}
	s eobj.OPERAgeFrom = pobj.OPERAgeFrom
	s eobj.OPERAgeTo = pobj.OPERAgeTo
	if $IsObject(pobj.OPERSexDR){
		s eobj.OPERSexDR = pobj.OPERSexDR.%Id() 
	}
	s eobj.OPERICD10 = pobj.OPERICD10
	s eobj.OPERICD9Map = pobj.OPERICD9Map
	//checkbox
	s eobj.OPERValid="true"   //默认有效
	s:pobj.OPERDaySurgery="Y" eobj.OPERDaySurgery="true"
	
	s eobj.OPERAgeFrom1 = pobj.OPERAgeFrom1
	s eobj.OPERAgeTo1 = pobj.OPERAgeTo1
	s eobj.OPERLongDescription = pobj.OPERLongDescription
	if $IsObject(pobj.OPERVersionDictDR)
	{
		s eobj.OPERVersionDictDR = pobj.OPERVersionDictDR.%Id()  //版本号
	}
	if $IsObject(pobj.OPERStandardClassDR)
	{
		s eobj.OPERStandardClassDR = pobj.OPERStandardClassDR.%Id()  //国家标准分级
	}
	//s eobj.OPERInsuCode = pobj.OPERInsuCode
	//s eobj.OPERInsuDesc = pobj.OPERInsuDesc
	//2022-04-11
	s Config=##class(web.DHCBL.BDP.INSUConfig).GetConfigByHospId(hospid,"ORC_Operation")
	if Config="INSU"
	{
		
	}
	else
	{
		s eobj.OPERInsuCode = pobj.OPERInsuCode
		s eobj.OPERInsuDesc = pobj.OPERInsuDesc
	}
	s eobj.OPERGrayCodeFlag=pobj.OPERGrayCodeFlag
	s:pobj.OPERGrayCodeFlag="Y" eobj.OPERGrayCodeFlag="true"


	s pobj2 = ##class(User.ORCOperationExtend).%OpenId(id)
	if $IsObject(pobj2.OPERClassDr){
		s eobj.OPERClassDr = pobj2.OPERClassDr.%Id() 
	}	
	if $IsObject(pobj2.OPERBladeDr){
		s eobj.OPERBladeDr = pobj2.OPERBladeDr.%Id() 
	}
	if $IsObject(pobj2.OPERBodySiteDr){
		s eobj.OPERBodySiteDr = pobj2.OPERBodySiteDr.%Id() 
	}
	if $IsObject(pobj2.OPEROperPositionDr){
		s eobj.OPEROperPositionDr = pobj2.OPEROperPositionDr.%Id() 
	}
	if $IsObject(pobj2.OPERDefaultOperLocDr){
		s eobj.OPERDefaultOperLocDr = pobj2.OPERDefaultOperLocDr.%Id() 
	}
	if $IsObject(pobj2.OPERCategoryDr){
		s eobj.OPERCategoryDr = pobj2.OPERCategoryDr.%Id() 
	}

	s eobj.OPERSurgeonDeptDr = pobj2.OPERSurgeonDeptDr  //手术医生科室Id(|分割)

	S OPERSurgeonDeptDrDesc=""
	if (pobj2.OPERSurgeonDeptDr'="")
	{
		s Length=$l(pobj2.OPERSurgeonDeptDr,"|")
		if Length>0
		{
			for i=1:1:Length
			{
				s LocID=$P(pobj2.OPERSurgeonDeptDr,"|",i)
				s LocDesc=""
				if LocID'="" s LocDesc=$p($G(^CTLOC(LocID)),"^",2)
				
				if OPERSurgeonDeptDrDesc'="" 
				{
					S OPERSurgeonDeptDrDesc=OPERSurgeonDeptDrDesc_","_LocDesc
				}
				else
				{
					S OPERSurgeonDeptDrDesc=LocDesc
				}
				
			}
		}
		
	}
	s eobj.OPERSurgeonDeptDrDesc =OPERSurgeonDeptDrDesc
	
	s eobj.OPERIsKeyOperation = pobj2.OPERIsKeyOperation
	s eobj.OPERScrubNurseClass = pobj2.OPERScrubNurseClass
	s eobj.OPERCirculNurseClass = pobj2.OPERCirculNurseClass
	s eobj.OPERType = pobj2.OPERType
	s:pobj2.OPERType="O" eobj.OPERType="N" //2018-11-2 去掉O类型 跟N一样的
	s eobj.OPERRegType = pobj2.OPERRegType
	s eobj.OPERIsUploadCode = pobj2.OPERIsUploadCode
	s eobj.OPERTechnique = pobj2.OPERTechnique
	s eobj.OPERMedicalTechniqueLevel = pobj2.OPERMedicalTechniqueLevel
	s eobj.OPERIsSpecial = pobj2.OPERIsSpecial
	s eobj.OPERIsHighRisk = pobj2.OPERIsHighRisk
	s eobj.OPERIsAudit = pobj2.OPERIsAudit
	s eobj.OPERIsPacs = pobj2.OPERIsPacs
	s eobj.OPERHospitalDr = pobj2.OPERHospitalDr  //医院Id(|分割)
	
	s eobj.OPERIsSupplierPreparation = pobj2.OPERIsSupplierPreparation
	s eobj.OPERIsProtectiveAntibacterial = pobj2.OPERIsProtectiveAntibacterial
	
	S OPERHospitalDrDesc=""
	if (pobj2.OPERHospitalDr'="")
	{
		s Length=$l(pobj2.OPERHospitalDr,"|")
		if Length>0
		{
			for i=1:1:Length
			{
				s HOSPID=$P(pobj2.OPERHospitalDr,"|",i)
				s HOSPDesc=""
				if HOSPID'="" s HOSPDesc=$p($g(^CT("HOSP",HOSPID)),"^",2)
				
				if OPERHospitalDrDesc'="" 
				{
					S OPERHospitalDrDesc=OPERHospitalDrDesc_","_HOSPDesc
				}
				else
				{
					S OPERHospitalDrDesc=HOSPDesc
				}
				
			}
		}
	}
	s eobj.OPERHospitalDrDesc =OPERHospitalDrDesc
	s eobj.OPERAbbreviation = pobj2.OPERAbbreviation
	s:pobj2.OPERIsKeyOperation="Y" eobj.OPERIsKeyOperation="true"
	s:pobj2.OPERIsUploadCode="Y" eobj.OPERIsUploadCode="true"
	s:pobj2.OPERIsSpecial="Y" eobj.OPERIsSpecial="true"
	s:pobj2.OPERIsHighRisk="Y" eobj.OPERIsHighRisk="true"
	s:pobj2.OPERIsAudit="Y" eobj.OPERIsAudit="true"
	s:pobj2.OPERIsPacs="Y" eobj.OPERIsPacs="true"

	s:pobj2.OPERIsSupplierPreparation="1" eobj.OPERIsSupplierPreparation="true"
	s:pobj2.OPERIsProtectiveAntibacterial="1" eobj.OPERIsProtectiveAntibacterial="true"
	s eobj.OPERApplyFeature = pobj2.OPERApplyFeature  //手术应用特性
	s eobj.OPERIsMinInvasive = pobj2.OPERIsMinInvasive   //是否微创手术
	s:pobj2.OPERIsMinInvasive="Y" eobj.OPERIsMinInvasive="true"
	
	s eobj.OPERIsSubOperation = pobj2.OPERIsSubOperation   //是否子手术
	s:pobj2.OPERIsSubOperation="Y" eobj.OPERIsSubOperation="true"
	s eobj.OPERIsRestrictedTechnology = pobj2.OPERIsRestrictedTechnology   //是否限制类技术
	s:pobj2.OPERIsRestrictedTechnology="Y" eobj.OPERIsRestrictedTechnology="true"
	s eobj.OPERIsNewItem = pobj2.OPERIsNewItem   //是否新项目新技术
	s:pobj2.OPERIsNewItem="Y" eobj.OPERIsNewItem="true"
	
	d pobj.%Close()
	d pobj2.%Close()
	s str = "{list:["_eobj.JsonS()_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2012-9-19
/// Description:增加/修改 手术/过程
/// Table:User.ORCOperation
/// Input:web.Entity.CT.ORCOperation
/// Return:成功返回success:'true'和新增或修改的数据的OPERRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCOperation) As %String
{
    new (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.OPERValid="" eobj.OPERValid="N"
		s:eobj.OPERDaySurgery="" eobj.OPERDaySurgery="N"	
		s:eobj.OPERDateActiveFrom'="" eobj.OPERDateActiveFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OPERDateActiveFrom)
		s:eobj.OPERActiveDateTo'="" eobj.OPERActiveDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OPERActiveDateTo)
		s:eobj.OPERDateActiveFrom="" eobj.OPERDateActiveFrom = +$h
		s flag= ##class(web.DHCBL.CT.ORCOperation).FormValidate(eobj.OPERRowId,eobj.OPERCode,eobj.OPERDesc,eobj.LinkHospId,eobj.OPERActiveDateTo,eobj.OPERVersionDictDR)
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'代码和描述已存在！'}"
			Q result
		}
		if (eobj.OPERRowId="")       
		{
			s obj=##class(User.ORCOperation).%New()
		}
		else                           
		{
			s obj=##class(User.ORCOperation).%OpenId(eobj.OPERRowId)
	
			s bobj = ##class(web.Entity.CT.ORCOperation).%New()
			s bobj.OPERRowId = eobj.OPERRowId
			s bobj.OPERCode = obj.OPERCode
			s bobj.OPERDesc = obj.OPERDesc
			if $IsObject(obj.OPERARCIMDR){
					s bobj.OPERARCIMDR = obj.OPERARCIMDR.%Id() 
				}	
			s bobj.OPERDateActiveFrom=obj.OPERDateActiveFrom
			s bobj.OPERActiveDateTo=obj.OPERActiveDateTo
			if $IsObject(obj.OPERDefaultCategoryDR){
					s bobj.OPERDefaultCategoryDR = obj.OPERDefaultCategoryDR.%Id() 
				}
			s bobj.OPERAgeFrom = obj.OPERAgeFrom
			s bobj.OPERAgeTo = obj.OPERAgeTo
			if $IsObject(obj.OPERSexDR){
					s bobj.OPERSexDR = obj.OPERSexDR.%Id() 
				}
			s bobj.OPERICD10 =obj.OPERICD10
			s bobj.OPERICD9Map = obj.OPERICD9Map
			s bobj.OPERValid = obj.OPERValid
			s bobj.OPERDaySurgery = obj.OPERDaySurgery
		
			s bobj.OPERAgeFrom1 = obj.OPERAgeFrom1
			s bobj.OPERAgeTo1 = obj.OPERAgeTo1
			s bobj.OPERLongDescription = obj.OPERLongDescription
			s Config=##class(web.DHCBL.BDP.INSUConfig).GetConfigByHospId(eobj.LinkHospId,"ORC_Operation")
			if Config="BDP"
			{
				s bobj.OPERInsuCode = obj.OPERInsuCode
				s bobj.OPERInsuDesc = obj.OPERInsuDesc
			}
			s bobj.OPERGrayCodeFlag=obj.OPERGrayCodeFlag
			if $IsObject(obj.OPERVersionDictDR)
			{
				s bobj.OPERVersionDictDR = obj.OPERVersionDictDR.%Id()  //版本号
			}
			if $IsObject(obj.OPERStandardClassDR){		
				s bobj.OPERStandardClassDR = obj.OPERStandardClassDR.%Id() 	//国家标准分级
			}
		}

		s obj.OPERCode = eobj.OPERCode
		s obj.OPERDesc = eobj.OPERDesc
		d obj.OPERARCIMDRSetObjectId(eobj.OPERARCIMDR)
		s obj.OPERDateActiveFrom=eobj.OPERDateActiveFrom
		s obj.OPERActiveDateTo=eobj.OPERActiveDateTo
		d obj.OPERDefaultCategoryDRSetObjectId(eobj.OPERDefaultCategoryDR)
		s obj.OPERAgeFrom = eobj.OPERAgeFrom
		s obj.OPERAgeTo = eobj.OPERAgeTo
		d obj.OPERSexDRSetObjectId(eobj.OPERSexDR)
		s obj.OPERICD10 = eobj.OPERICD10
		s obj.OPERICD9Map = eobj.OPERICD9Map
		s obj.OPERValid = eobj.OPERValid
		s obj.OPERDaySurgery = eobj.OPERDaySurgery
	
		s obj.OPERAgeFrom1 = eobj.OPERAgeFrom1
		s obj.OPERAgeTo1 = eobj.OPERAgeTo1
		s obj.OPERLongDescription = eobj.OPERLongDescription
		s Config=##class(web.DHCBL.BDP.INSUConfig).GetConfigByHospId(eobj.LinkHospId,"ORC_Operation")
		if Config="INSU"
		{
			
		}
		else
		{
			s obj.OPERInsuCode = eobj.OPERInsuCode
			s obj.OPERInsuDesc = eobj.OPERInsuDesc
		}
		s obj.OPERGrayCodeFlag=eobj.OPERGrayCodeFlag  //医保灰码标志
		d obj.OPERVersionDictDRSetObjectId(eobj.OPERVersionDictDR)  //版本号
		d obj.OPERStandardClassDRSetObjectId(eobj.OPERStandardClassDR)  //国家标准分级
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.OPERRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_Operation","User.ORCOperation","手术/过程",id,eobj.OPERDesc,"A",eobj)
			d:eobj.OPERRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_Operation","User.ORCOperation","手术/过程",id,eobj.OPERDesc,"U",eobj,bobj)
			//版本号不为空时判断是否要同步给病案 2022-12-29
            if (eobj.OPERVersionDictDR'="")
            {
                s IsSyncToMr=$lg($g(^CT.BDP.CT.BDVersionDictD(eobj.OPERVersionDictDR)),7)
                if (IsSyncToMr="Y")
                {
	                ///调用病案同步接口 2023-02-02
	                s retMsg= ##class(web.DHCBL.CT.ORCOperation).SendMsgToEMR(id)
	                if $p(retMsg,"^",1)'=1
	                {
		                 s result= "{success:'false',errorinfo:'"_$p(retMsg,"^",2)_"'}"  
	                }
                }
                
            }
			s flag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospPortal")
			if flag="Y"
			{
				s ret=""
			
				s CATEG=$p($g(^ORC("OPER",id)),"^",7)
				if CATEG'="" s CATEG=$p($g(^ORC("CATEG",CATEG)),"^",2)
				if eobj.OPERRowId="" S Type="A"
				if eobj.OPERRowId'="" S Type="M"
				//s ret=##class(CommonService.CommonServiceHttpPort).%New().saveOperation(id_"^"_eobj.OPERDesc_"^"_CATEG_"^"_Type)
				//调用医师资质接口同步手术信息	2022-06-28
				s:eobj.OPERRowId="" ret=##class(web.DHCBL.BDP.SyncInterface).saveOperation(id,"A")
				s:eobj.OPERRowId'="" ret=##class(web.DHCBL.BDP.SyncInterface).saveOperation(id,"U")
				if ($p(ret,"^",1)=-1)
				{
					s result = "{success:'false',errorinfo:'与医院协同数据同步失败："_$p(ret,"^",2)_"'}"
				}
				
			}

		}else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术/过程","web.DHCBL.CT.ORCOperation","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}
			
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator:陈莹
/// CreatDate:2016-08-30
/// Description:增加/修改 手术/过程（包含扩展信息)
/// Table:User.ORCOperation
/// Input:web.Entity.CT.ORCOperation
/// Return:成功返回success:'true'和新增或修改的数据的OPERRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity2(mobj As web.Entity.CT.ORCOperation2) As %String
{
    new (mobj,%session)
    s $zt="ERROR"
	s result=""
	
	s eobj = ##class(web.Entity.CT.ORCOperation).%New()
	s eobj.OPERRowId = mobj.OPERRowId
	s eobj.OPERCode = mobj.OPERCode
	s eobj.OPERDesc = mobj.OPERDesc
	s eobj.OPERARCIMDR = mobj.OPERARCIMDR	
	s eobj.OPERDateActiveFrom=mobj.OPERDateActiveFrom
	s eobj.OPERActiveDateTo=mobj.OPERActiveDateTo
	s eobj.OPERDefaultCategoryDR = mobj.OPERDefaultCategoryDR
	
	s mobj.OPERClassDr=mobj.OPERDefaultCategoryDR   //2017-3-8
	
	
	s eobj.OPERAgeFrom = mobj.OPERAgeFrom
	s eobj.OPERAgeTo = mobj.OPERAgeTo
	s eobj.OPERSexDR = mobj.OPERSexDR
	s eobj.OPERICD10 =mobj.OPERICD10
	s eobj.OPERICD9Map = mobj.OPERICD9Map
	s eobj.OPERValid = mobj.OPERValid
	s eobj.OPERDaySurgery = mobj.OPERDaySurgery
	
	s eobj.OPERAgeFrom1 = mobj.OPERAgeFrom1
	s eobj.OPERAgeTo1 = mobj.OPERAgeTo1
	s eobj.OPERLongDescription = mobj.OPERLongDescription
	s eobj.OPERInsuCode = mobj.OPERInsuCode
	s eobj.OPERInsuDesc = mobj.OPERInsuDesc
	s eobj.OPERGrayCodeFlag=mobj.OPERGrayCodeFlag  //医保灰码标志
	s eobj.OPERVersionDictDR = mobj.OPERVersionDictDR //版本号
	s eobj.OPERStandardClassDR = mobj.OPERStandardClassDR 	//国家标准分级
	s result= ##class(web.DHCBL.CT.ORCOperation).SaveEntity(eobj)	
	if result["success:'true'"
	{
		s OPERRowId=##class(web.DHCBL.BDP.FunLib).GetResultRowId(result)
		if OPERRowId'=""
		{
			s eobjextend = ##class(web.Entity.CT.ORCOperationExtend).%New()
			s eobjextend.OPERERowId =OPERRowId
			s eobjextend.OPERClassDr=mobj.OPERClassDr
			s eobjextend.OPERBladeDr=mobj.OPERBladeDr
			s eobjextend.OPERBodySiteDr=mobj.OPERBodySiteDr
			s eobjextend.OPEROperPositionDr=mobj.OPEROperPositionDr
			s eobjextend.OPERDefaultOperLocDr=mobj.OPERDefaultOperLocDr
			s eobjextend.OPERCategoryDr=mobj.OPERCategoryDr
			s eobjextend.OPERUpdateUserDr=mobj.OPERUpdateUserDr
			s eobjextend.OPERSurgeonDeptDr = mobj.OPERSurgeonDeptDr  //手术医生科室Id(|分割)
			s eobjextend.OPERIsKeyOperation = mobj.OPERIsKeyOperation
			s eobjextend.OPERScrubNurseClass = mobj.OPERScrubNurseClass
			s eobjextend.OPERCirculNurseClass = mobj.OPERCirculNurseClass
			s eobjextend.OPERType =mobj.OPERType
			s eobjextend.OPERRegType = mobj.OPERRegType
			s eobjextend.OPERUpdateDate =mobj.OPERUpdateDate
			s eobjextend.OPERUpdateTime =mobj.OPERUpdateTime
			s eobjextend.OPERIsUploadCode = mobj.OPERIsUploadCode
			s eobjextend.OPERTechnique = mobj.OPERTechnique
			s eobjextend.OPERMedicalTechniqueLevel = mobj.OPERMedicalTechniqueLevel
			s eobjextend.OPERIsSpecial = mobj.OPERIsSpecial
			s eobjextend.OPERIsHighRisk = mobj.OPERIsHighRisk
			s eobjextend.OPERIsAudit = mobj.OPERIsAudit
			s eobjextend.OPERIsPacs =mobj.OPERIsPacs
			s eobjextend.OPERIsSupplierPreparation =mobj.OPERIsSupplierPreparation
			s eobjextend.OPERIsProtectiveAntibacterial =mobj.OPERIsProtectiveAntibacterial
			s eobjextend.OPERIsMinInvasive =mobj.OPERIsMinInvasive  //是否微创手术
			s eobjextend.OPERApplyFeature =mobj.OPERApplyFeature   //手术应用特性
			s eobjextend.OPERHospitalDr = mobj.OPERHospitalDr  //医院Id(|分割)
			s eobjextend.OPERAbbreviation =mobj.OPERAbbreviation
			
			s eobjextend.OPERIsSubOperation =mobj.OPERIsSubOperation  //是否子手术
			s eobjextend.OPERIsRestrictedTechnology =mobj.OPERIsRestrictedTechnology  //是否限制类技术
			s eobjextend.OPERIsNewItem =mobj.OPERIsNewItem  //是否新项目新技术
			s res= ##class(web.DHCBL.CT.ORCOperationExtend).SaveEntity(eobjextend)
			if res'["success:'true'"
			{
				s result =res
			}
		}
		else
		{
			q result
		}
	}
	q result
ERROR
	s result = "{success:'false',errorinfo:'"_$ze_"'}"    //返回错误信息
	q result
}

/// Creator:陈莹
/// CreatDate:2013-9-4
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	s flag=0
	if $d(^User.CSSDOPClsDetailI("OPClas",id))>0
	{
		s flag=1
		s myInfo=myInfo_"<手术分类明细>" //User.CSSDOPClsDetail
	}
	if $d(^ORi("Operation",id))>0
	{
		s flag=1
		s myInfo=myInfo_"<User.ORAnaestAdditionalStaff>" //User.ORAnaestAdditionalStaff
	}
	if $d(^User.ORCDaySurgeryI("DaySurgeryIndex",id))>0
	{
		s flag=1
		s myInfo=myInfo_"<日间手术>" //User.ORCDaySurgery
	}
	
	if $d(^PAWLi("OPDays",+id))>0
	{
		s flag=1
		s myInfo=myInfo_"<User.PAWaitingList>" //User.PAWaitingList
	}
	if (flag=0)
	{
		s ID=0
		for
		{
			s ID=$o(^CIS.AN.OperListD(ID)) q:((ID="")||(flag=1))
			s Operation=$LISTGET($G(^CIS.AN.OperListD(ID)),2)
			i Operation=id 
			{
				s flag=1
				s myInfo=myInfo_"<手术申请>" //CIS.AN.OperList
				q
			}
		}
	}
	if (flag=0)
	{
		s ID=0
		for
		{
			s ID=$o(^CIS.AN.PlanOperListD(ID)) q:((ID="")||(flag=1))
			s Operation=$LISTGET($G(^CIS.AN.PlanOperListD(ID)),2)
			i Operation=id 
			{
				s flag=1
				s myInfo=myInfo_"<拟施手术>" //CIS.AN.PlanOperList
				q
			}
		}
	}
	if (flag=0)
	{
		s PAADMRowID=0,flag=0
		for
		{
			s PAADMRowID=$o(^PAADM(PAADMRowID)) q:(PAADMRowID="")||(flag=1)
			s PAADMOperDR=$p($g(^PAADM(PAADMRowID)),"^",54)
			i PAADMOperDR=id 
			{
				s flag=1
				s myInfo=myInfo_"<病人就诊信息表>" //PAAdm
			}
		}
	}
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator:陈莹
/// CreatDate:2012-9-19
/// Description:根据id删除 手术/过程
/// Table:User.ORCOperation
/// Input:id(ORCOperation的OPERRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.ORCOperation).DeleteData("1")
ClassMethod DeleteData(id As %String, hospid As %String = "") As %String
{
	new (id,hospid,%session)
	s result=""
	
	s re=##class(web.DHCBL.CT.ORCOperation).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(User.ORCOperation).%OpenId(id)
		s eobj = ##class(web.Entity.CT.ORCOperation).%New()
		s eobj.OPERRowId = id
		s eobj.OPERCode = pobj.OPERCode
		s eobj.OPERDesc = pobj.OPERDesc
		if $IsObject(pobj.OPERARCIMDR){
			s eobj.OPERARCIMDR = pobj.OPERARCIMDR.%Id() 
		}
		s eobj.OPERDateActiveFrom = pobj.OPERDateActiveFrom 
		s eobj.OPERActiveDateTo =  pobj.OPERActiveDateTo 
		if $IsObject(pobj.OPERDefaultCategoryDR){
			s eobj.OPERDefaultCategoryDR = pobj.OPERDefaultCategoryDR.%Id() 
		}
		s eobj.OPERAgeFrom = pobj.OPERAgeFrom
		s eobj.OPERAgeTo = pobj.OPERAgeTo
		if $IsObject(pobj.OPERSexDR){
			s eobj.OPERSexDR = pobj.OPERSexDR.%Id() 
		}
		s eobj.OPERICD10 = pobj.OPERICD10
		s eobj.OPERICD9Map = pobj.OPERICD9Map
		s eobj.OPERValid=pobj.OPERValid 
		s eobj.OPERDaySurgery=pobj.OPERDaySurgery 
		
		s eobj.OPERAgeFrom1 = pobj.OPERAgeFrom1
		s eobj.OPERAgeTo1 = pobj.OPERAgeTo1
		s eobj.OPERLongDescription = pobj.OPERLongDescription
		//s eobj.OPERInsuCode = pobj.OPERInsuCode
		//s eobj.OPERInsuDesc = pobj.OPERInsuDesc
		//2022-04-11
		s Config=##class(web.DHCBL.BDP.INSUConfig).GetConfigByHospId(hospid,"ORC_Operation")
		if Config="INSU"
		{
			
		}
		else
		{
			s eobj.OPERInsuCode = pobj.OPERInsuCode
			s eobj.OPERInsuDesc = pobj.OPERInsuDesc
		}
		s eobj.OPERGrayCodeFlag=pobj.OPERGrayCodeFlag
		if $IsObject(pobj.OPERVersionDictDR){
			s eobj.OPERVersionDictDR = pobj.OPERVersionDictDR.%Id() 
		}
		if $IsObject(pobj.OPERStandardClassDR){
			s eobj.OPERStandardClassDR = pobj.OPERStandardClassDR.%Id() //国家标准分级
		}
		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(User.ORCOperation).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_Operation","User.ORCOperation","手术/过程",id,eobj.OPERDesc,"D",eobj)
			s flag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospPortal")
			if flag="Y"
			{
				s ret=""
				S Type="D"
				//s ret=##class(CommonService.CommonServiceHttpPort).%New().saveOperation(id_"^"_Type)
				s ret=##class(web.DHCBL.BDP.SyncInterface).saveOperation(id,"D")	//调用医师资质接口同步手术信息
				if ($p(ret,"^",1)=-1)
				{
					s result = "{success:'false',errorinfo:'与医院协同数据同步删除失败："_$p(ret,"^",2)_"'}"
				}
			}
		}
		else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术/过程","web.DHCBL.CT.ORCOperation","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	
	q result
}

/// Creator:陈莹
/// CreatDate:2018-02-28 已同步
/// Description:第一次批量同步手术信息（与医院协同服务器）
/// Table:User.ORCOperation
/// Input:
/// Return:返回同步失败数据的rowid
/// w ##class(web.DHCBL.CT.ORCOperation).batchSyncOper()
ClassMethod batchSyncOper() As %String
{
	s ErrorResult=""
	s OPERRowId=0
	for
	{
		s OPERRowId=$o(^ORC("OPER",OPERRowId)) q:OPERRowId=""
		s OPERDesc=$p($g(^ORC("OPER",OPERRowId)),"^",2)
		s CATEG=$p($g(^ORC("OPER",OPERRowId)),"^",7)
		if CATEG'="" s CATEG=$p($g(^ORC("CATEG",CATEG)),"^",2)
		S Type="A"
		//s ret=##class(CommonService.CommonServiceHttpPort).%New().saveOperation(OPERRowId_"^"_OPERDesc_"^"_CATEG_"^"_Type)
		s ret=##class(web.DHCBL.BDP.SyncInterface).saveOperation(OPERRowId,"A")		//调用医师资质接口同步手术信息	2022-06-28
		if ($p(ret,"^",1)=-1)
		{
			if ErrorResult="" s ErrorResult =OPERRowId
			else  s ErrorResult =ErrorResult_"^"_OPERRowId	
		}
	}
	q ErrorResult
}

/// Function:添加时， 手术自动生成代码
/// Creator:陈莹
///  兰大一院 库里最大值+1（总共6位,S开头，S00040，S53300）
/// CreateDate: 2017-07-26
/// input:  44f+1-->45,f44+1-->
/// Debug:w ##class(web.DHCBL.CT.ORCOperation).AutoCreateCode()
ClassMethod AutoCreateCode() As %String
{
	n
	s MaxCode=""
	s ConfigType="OPERCONFIG"
	if $d(^Config.BDPSpeConfig(ConfigType))
	{
		s ConfigStr=$g(^Config.BDPSpeConfig(ConfigType))
		s AutoCode=$p($g(^Config.BDPSpeConfig(ConfigType)),"^",3)
		if AutoCode="true"
		{
			k ^TMPCODE(ConfigType)
			s OriginCode=$p($g(^Config.BDPSpeConfig(ConfigType)),"^",4)
			s TotalLength=$p($g(^Config.BDPSpeConfig(ConfigType)),"^",5)
			s olength=$l(OriginCode)
			if ((TotalLength-$l(OriginCode))<=0)
			{
				 s MaxCode="ERROR"
			}
			else
			{
				s Code1=""
				s Code=0
				for
				{
					S Code=$o(^ORC("OPER",0,"Code",Code)) q:Code=""
					s id=0
					for
					{
						S id=$o(^ORC("OPER",0,"Code",Code,id)) q:id=""
						s RCode=$p($g(^ORC("OPER",id)),"^",1)
						s RCode=##class(web.DHCBL.BDP.FunLib).Util(RCode)
						if ($e(RCode,1,olength)=OriginCode)&&($l(RCode)=TotalLength)
						{
							s Code1=$e(RCode,olength+1,TotalLength)+1
							S:Code1'="" ^TMPCODE(ConfigType,Code1)=RCode
						}
					}
				}
				s Code1=$o(^TMPCODE(ConfigType,""),-1)
				s Code1=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(Code1,TotalLength-$l(OriginCode)) 
				s MaxCode=OriginCode_Code1
				k ^TMPCODE(ConfigType)
			}
		}
	}
	q MaxCode
}

/// Creator:陈莹
/// CreatDate:2017-07-26
/// Description:获取页面的配置
/// ^Config.BDPSpeConfig("OPERCONFIG")
/// w ##class(web.DHCBL.CT.ORCOperation).GetConfigValue()
ClassMethod GetConfigValue() As %String
{
	s ConfigType="OPERCONFIG"
	s ValidCode=$p($g(^Config.BDPSpeConfig(ConfigType)),"^",1)         //校验代码+描述是否重复，默认true
	if (ValidCode="") S ValidCode="true"
	s ValidDesc="" //$p($g(^Config.BDPSpeConfig(ConfigType)),"^",2)         //校验描述是否重复，默认true，20220805不用了
	//if (ValidDesc="") S ValidDesc="true"
	s AutoCode=$p($g(^Config.BDPSpeConfig(ConfigType)),"^",3)          //自动生成代码，默认false
	if (AutoCode="") S AutoCode="false"
	s CodeType=$p($g(^Config.BDPSpeConfig(ConfigType)),"^",4)          ///代码规则：字母开头 或者纯数字不填
	s TotalLength=$p($g(^Config.BDPSpeConfig(ConfigType)),"^",5)       ///自动生成总共多少位的代码
	s str="ValidCode:"""_ValidCode_""",ValidDesc:"""_ValidDesc_""",AutoCode:"""_AutoCode_""",OriginCode:"""_CodeType_""",TotalLength:"""_TotalLength_""""
	s str = "{list:[{"_str_"}]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2017-07-26
/// Description:保存页面的配置
/// Input：校验代码+描述是否重复^^自动生成代码^代码规则：字母开头 或者纯数字不填^自动生成总共多少位的代码
/// w ##class(web.DHCBL.CT.ORCOperation).SaveConfigValue("true^true^false^^")
ClassMethod SaveConfigValue(ConfigStr) As %String
{
	n (ConfigStr)
	s ConfigType="OPERCONFIG"
	s ^Config.BDPSpeConfig(ConfigType)=ConfigStr
	q "{success:'true'}"
}

/// s ^Config.BDPSpeConfig("OPERCONFIG")="false^false^false" 
/// Creator:陈莹
/// CreatDate:2019-05-28
/// Description:批量全停所有有效手术
/// Table：User.ORCOperation
/// Input：enddate结束日期 （年-月-日格式）
/// d ##class(web.DHCBL.CT.ORCOperation).EndAllOperation("2019-05-31") /// 批量全停所有有效手术
ClassMethod EndAllOperation(enddate) As %String
{
	s enddate=$zdh(enddate,3)
	s id=0
	for
	{
		s id=$o(^ORC("OPER",id)) q:id=""   //循环手术表
		s OPERDateActiveFrom=$p($g(^ORC("OPER",id)),"^",5)  //手术开始日期
		s OPERActiveDateTo=$p($g(^ORC("OPER",id)),"^",6)  //手术结束日期
		//手术数据结束日期为空，且开始日期早于入参date时会修改结束日期
		if (OPERActiveDateTo="")&&(OPERDateActiveFrom'="")&&(OPERDateActiveFrom<enddate)
		{
			s obj=##class(User.ORCOperation).%OpenId(id)
			s obj.OPERActiveDateTo=enddate
			//s obj.OPERValid="N"
			Ts
			s sc=obj.%Save()
			do obj.%Close()
			if $$$ISOK(sc){
				Tcommit
				w !,id
			}else{
				Trollback
				w !,id_" "_$p($g(^ORC("OPER",id)),"^",1)_" "_$p($g(^ORC("OPER",id)),"^",2)_" "_$SYSTEM.Status.GetErrorText(sc)
			}
		}	
	}
}

/// Function: 更新手术数据操作类型和使用技术
/// Input:k (查询到的第几条手术数据）
/// Retrun:手术信息
/// CreateDate:2019-04-17
/// Creator: chenying
/// Input：&%分隔   代码&%名称&%手术操作类型&%使用技术
/// Return:返回0 保存失败
/// W ##class(web.DHCBL.CT.ORCOperation).ImportExcel("")
ClassMethod ImportExcel(datastr) As %String
{
	s result=""
	s Code=$p(datastr,"&%",1)
	q:$$ALPHAUP^SSUTIL4(Code)="" 0
	s id=$o(^ORC("OPER",0,"Code",$$ALPHAUP^SSUTIL4(Code),0))
	if (id="") q 0
	s Desc=$p($g(^ORC("OPER",id)),"^",2)
	if Desc'=$p(datastr,"&%",2) q 0
	s obj = ##class(User.ORCOperation).%OpenId(id)
	s oldType=$p($g(^ORC("OPER",id,"DHC")),"^",11)
	s oldTechnique=$p($g(^ORC("OPER",id,"DHC")),"^",19)
	s OPERType=$p(datastr,"&%",3)
	s OPERTechnique=$p(datastr,"&%",4)
	s OPERType=$CASE(OPERType,"常规":"N","诊断性操作":"D","治疗性操作":"T","手术":"N","介入治疗":"I",:"") 
	s OPERTechnique=$CASE(OPERTechnique,"常规":"N","开放":"N","介入":"I","内镜":"E","腹镜":"L","腔镜":"L","操作":"P",:"")
	
	s obj.OPERType = OPERType
	s obj.OPERTechnique = OPERTechnique
	Ts
	s sc=obj.%Save()
	if $$$ISOK(sc){
		Tcommit
		s NewJsonStr="{""OPERRowId"":"""_id_""",""OPERCode"":"""_obj.OPERCode_""",""OPERDesc"":"""_obj.OPERDesc_""",""OPERType"":"""_OPERType_""",""OPERTechnique"":"""_OPERTechnique_"""}"     
		s OldJsonStr="{""OPERRowId"":"""_id_""",""OPERCode"":"""_obj.OPERCode_""",""OPERDesc"":"""_obj.OPERDesc_""",""OPERType"":"""_oldType_""",""OPERTechnique"":"""_oldTechnique_"""}"     
	
		d ##class(web.BDPYG.BDP.BDPDataChangeLog).SaveLogForOther("ORC_Operation","User.ORCOperation","手术/过程",id,obj.OPERDesc,"U",NewJsonStr,OldJsonStr)
		do obj.%Close()
	}
	else
	{
		Trollback
		s result=0
	}
	q result
}

/// Function: 获取查询出的手术信息总数
/// Retrun:count
/// CreateDate:2019-08-22
/// Creator: chenying
/// w ##class(web.DHCBL.CT.ORCOperation).GetDataCount()
ClassMethod GetDataCount() As %String
{
	s count=$o(^TMPEXPORT("ORCOperation",""),-1)
	if count="" s count=0
	q count
}

/// Function: 获取第K条手术信息,导出信息时调用
/// Input:k (查询到的第几条手术数据）
/// Retrun:手术信息
/// CreateDate:2019-08-22
/// Creator: chenying
/// w ##class(web.DHCBL.CT.ORCOperation).GetDataValue(2)
ClassMethod GetDataValue(rownumber, hospid As %String = "") As %String
{
	n (rownumber,hospid)
	s OPERRowId=$g(^TMPEXPORT("ORCOperation",rownumber))
	s OPERCode=$p($g(^ORC("OPER",OPERRowId)),"^",1)
	s OPERDesc=$p($g(^ORC("OPER",OPERRowId)),"^",2)
	s OPERARCIMDR=$p($g(^ORC("OPER",OPERRowId)),"^",4)
	i OPERARCIMDR'="" 
	{
		s ARCIMSubscript=$p(OPERARCIMDR,"||",1)
		s ARCIMVersion=$p(OPERARCIMDR,"||",2)
		s OPERARCIMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	}
	
	s OPERDateActiveFrom=$p($g(^ORC("OPER",OPERRowId)),"^",5)
	s OPERActiveDateTo=$p($g(^ORC("OPER",OPERRowId)),"^",6)
	
	s:OPERDateActiveFrom'="" OPERDateActiveFrom=$zd(OPERDateActiveFrom,3)
	s:OPERActiveDateTo'="" OPERActiveDateTo=$zd(OPERActiveDateTo,3)
	s OPERDefaultCategoryDR=$p($g(^ORC("OPER",OPERRowId)),"^",7)
	i OPERDefaultCategoryDR'="" {
		s OPERDefaultCategoryDR=$p($g(^ORC("CATEG",OPERDefaultCategoryDR)),"^",2)
	}
	s OPERValid=$p($g(^ORC("OPER",OPERRowId)),"^",22)
	if OPERValid="" s OPERValid="Y"
	s OPERAgeFrom=$p($g(^ORC("OPER",OPERRowId)),"^",10)
	s OPERAgeTo=$p($g(^ORC("OPER",OPERRowId)),"^",11)
	s OPERSexDR=$p($g(^ORC("OPER",OPERRowId)),"^",12)
	i OPERSexDR'="" {
		s OPERSexDR=$p($g(^CT("SEX",OPERSexDR)),"^",2)
	}
	
	s OPERICD10=$p($g(^ORC("OPER",OPERRowId)),"^",14)
	s OPERICD9Map=$p($g(^ORC("OPER",OPERRowId)),"^",21)
	
	s OPERAgeFrom1=$p($g(^ORC("OPER",OPERRowId)),"^",24)
	s OPERAgeTo1=$p($g(^ORC("OPER",OPERRowId)),"^",25)
	s OPERLongDescription=$p($g(^ORC("OPER",OPERRowId)),"^",35)
	s OPERGrayCodeFlag=$p($g(^ORC("OPER",OPERRowId)),"^",40)	//是否灰码
	
	s OPERVersionDictDR=$p($g(^ORC("OPER",OPERRowId)),"^",41)	//版本号
	s:OPERVersionDictDR'="" OPERVersionDictDR=$lg($g(^CT.BDP.CT.BDVersionDictD(OPERVersionDictDR)),4)
	s OPERStandardClassDR=$p($g(^ORC("OPER",OPERRowId)),"^",42)	//国家标准分级
	s:OPERStandardClassDR'="" OPERStandardClassDR=$p($g(^ORC("CATEG",OPERStandardClassDR)),"^",2)
	
	s OPERDaySurgery=$p($g(^ORC("OPER",OPERRowId)),"^",9)
	s OPERType=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",11)  //手术操作类别
	s OPERType=$CASE(OPERType,"N":"手术","D":"诊断性操作","T":"治疗性操作","I":"介入治疗",:OPERType) 
	s OPERTechnique=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",18)  //使用技术
	
	s OPERTechnique=$CASE(OPERTechnique,"N":"普通","I":"介入","E":"内镜","L":"腔镜","P":"操作",:OPERTechnique) 
	s OPERApplyFeature=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",28)  //手术应用特性
	s OPERApplyFeature=$CASE(OPERApplyFeature,"R":"必选","C":"中医必选","O":"选择性",:OPERApplyFeature) 
	s OPERIsMinInvasive=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",29)  //是否微创手术
	s OPERIsSubOperation=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",30)  //是否子手术
	s OPERIsRestrictedTechnology=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",31)  //是否限制类技术
	s OPERIsNewItem=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",32)  //是否新项目新技术	
	
	
	//s OPERInsuCode=$p($g(^ORC("OPER",OPERRowId)),"^",38)  //国家医保编码  2021-11-12
	//s OPERInsuDesc=$p($g(^ORC("OPER",OPERRowId)),"^",39)  //国家医保名称
	
	s InsuInfo=##class(web.DHCBL.CT.ORCOperation).GetStdInsuInfo(OPERRowId,hospid)
	s OPERInsuCode=$p(InsuInfo,"^",1)  //国家医保编码  2022-04-11
	s OPERInsuDesc=$p(InsuInfo,"^",2)  //国家医保名称
	s Value=OPERCode_"&%"_OPERDesc_"&%"_OPERARCIMDR_"&%"_OPERDateActiveFrom_"&%"_OPERActiveDateTo_"&%"_OPERValid_"&%"_OPERDefaultCategoryDR_"&%"_OPERICD10_"&%"_OPERICD9Map_"&%"_OPERAgeFrom_"&%"_OPERAgeTo_"&%"_OPERAgeFrom1_"&%"_OPERAgeTo1_"&%"_OPERSexDR_"&%"_OPERLongDescription_"&%"_OPERType_"&%"_OPERTechnique_"&%"_OPERApplyFeature_"&%"_OPERIsMinInvasive_"&%"_OPERIsSubOperation_"&%"_OPERIsRestrictedTechnology_"&%"_OPERIsNewItem_"&%"_OPERInsuCode_"&%"_OPERInsuDesc_"&%"_OPERGrayCodeFlag_"&%"_OPERVersionDictDR_"&%"_OPERStandardClassDR  //_"&%"_OPERDaySurgery
	
	q Value
}

/// Function: 获取导出表格的标题
/// CreateDate:2022-12-28
/// Creator: chenying
/// w ##class(web.DHCBL.CT.ORCOperation).GetExceltitlename()
ClassMethod GetExceltitlename() As %String
{
	s Exceltitlename="代码&%描述&%医嘱项&%开始日期&%结束日期&%有效性&%手术分级&%ICD10&%ICD9&%从年龄&%到年龄&%从限制年龄&%到限制年龄&%限制性别&%备注&%手术操作类别&%使用技术&%手术应用特性&%微创手术(Y/N)&%子手术(Y/N)&%限制类技术(Y/N)&%新项目新技术(Y/N)&%国家医保编码&%国家医保名称&%医保灰码标志&%版本号&%国家标准分级"  //^日间手术
	q Exceltitlename
}

/// Function: 根据手术rowid获取手术国家医保编码
/// Creator:陈莹
/// CreateDate: 2021-11-12
/// Input:RowId:手术rowid
/// Return :国家医保编码
/// Debug: w ##class(web.DHCBL.CT.ORCOperation).GetInsuCodeByRowId("1")
ClassMethod GetInsuCodeByRowId(RowId) As %String
{
	n (RowId,%session)
	q:RowId="" ""
	s OPERInsuCode=$p($g(^ORC("OPER",RowId)),"^",38)   //手术国家医保编码
	//取翻译后的内容 2022-12-19
	s:OPERInsuCode'="" OPERInsuCode=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.ORCOperation","OPERInsuCode","",OPERInsuCode)
	q OPERInsuCode
}

/// Function: 根据手术rowid获取手术国家医保名称
/// Creator:陈莹
/// CreateDate:  2021-11-12
/// Input:RowId: 手术rowid
/// Return :OPERInsuDesc:国家医保名称
/// Debug: w ##class(web.DHCBL.CT.ORCOperation).GetInsuName("1")
ClassMethod GetInsuName(RowId) As %String
{
	n (RowId,%session)
	q:RowId="" ""
	s OPERInsuDesc=$p($g(^ORC("OPER",RowId)),"^",39)   //手术国家医保名称
	//取翻译后的内容 2022-12-19
	s:OPERInsuDesc'="" OPERInsuDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.ORCOperation","OPERInsuDesc","",OPERInsuDesc)
	q OPERInsuDesc
}

/// Function: 根据手术rowid获取国家医保编码和国家医保名称
/// Creator:陈莹
/// CreateDate: 2022-04-11
/// Input:Rowid手术rowid,HospDr医院rowid
/// Return:国家医保编码^国家医保名称
/// Debug:w ##class(web.DHCBL.CT.ORCOperation).GetStdInsuInfo("1","2")
ClassMethod GetStdInsuInfo(Rowid As %String, HospDr As %String) As %String
{
	n (Rowid,HospDr)
	s $ZT="ErrorStd"
	q:Rowid="" ""
	if (HospDr="")
	{
		s HospDr= ##class(web.DHCBL.BDP.BDPDataExport).GetHospital("ORC_Operation",Rowid,"")
		if HospDr'="" s HospDr=+HospDr
		if (HospDr="") s HospDr=$o(^CT("HOSP",0))
	}
	s InsuStr=""
	s Config=##class(web.DHCBL.BDP.INSUConfig).GetConfigByHospId(HospDr,"ORC_Operation")
	if Config="INSU"
	{
		s InsuStr=##class(web.DHCINSUPort).GetStdInfoByORCOperRowId(Rowid, HospDr,"","",1,"","")
	}
	else
	{
		s InsuCode=##class(web.DHCBL.CT.ORCOperation).GetInsuCodeByRowId(Rowid)
		s InsuName=##class(web.DHCBL.CT.ORCOperation).GetInsuName(Rowid)
		s InsuStr=InsuCode_"^"_InsuName
	}
	q InsuStr
ErrorStd
	q "-1^"_$ZE
}

/// Function: 根据手术rowid获取手术操作类型
/// Creator:陈莹
/// CreateDate:  2021-11-18
/// Input:RowId: 手术rowid
/// Return :OPERType:手术操作类型
/// Debug: w ##class(web.DHCBL.CT.ORCOperation).GetOPERType("1")
ClassMethod GetOPERType(RowId) As %String
{
	n (RowId)
	q:RowId="" ""
	s OPERType=$p($g(^ORC("OPER",RowId,"DHC")),"^",11)  //手术操作类别
	s OPERType=$CASE(OPERType,"N":"手术","D":"诊断性操作","T":"治疗性操作","I":"介入治疗",:OPERType) 
	q OPERType
}

/// Function: 根据手术代码获取手术操作类型
/// Creator:陈莹
/// CreateDate:  2021-11-18
/// Input:code: 手术代码
/// Return :OPERType:手术操作类型
/// Debug: w ##class(web.DHCBL.CT.ORCOperation).GetOPERTypeByCode("00.01001")
ClassMethod GetOPERTypeByCode(Code) As %String
{
	n (Code)
	q:Code="" ""
	q:$$ALPHAUP^SSUTIL4(Code)="" ""
	s OPERType=""
	s RowId=0
	for
	{
		s RowId=$o(^ORC("OPER",0,"Code",$$ALPHAUP^SSUTIL4(Code),RowId)) q:RowId=""
		s OPERCode=$p($g(^ORC("OPER",RowId)),"^",1)  //手术代码
		if (OPERCode=Code)
		{
			s OPERActiveDateTo=$p($g(^ORC("OPER",RowId)),"^",6)  //结束日期
			continue:(OPERActiveDateTo'="")
			s OPERValid=$p($g(^ORC("OPER",RowId)),"^",22)  //有效标志
			continue:(OPERValid="N")
			s OPERType=$p($g(^ORC("OPER",RowId,"DHC")),"^",11)  //手术操作类别
			s OPERType=$CASE(OPERType,"N":"手术","D":"诊断性操作","T":"治疗性操作","I":"介入治疗",:OPERType)
		}
	
	}
	q OPERType
}

/// Creator:陈莹
/// CreatDate:2022-12-07
/// Description:停止手术/过程
/// Table:User.ORCOperation
/// Input:web.Entity.CT.ORCOperation
/// Return:成功返回success:'true'和新增或修改的数据的OPERRowId;失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.CT.ORCOperation).EndORCOperation(eobj)
ClassMethod EndORCOperation(eobj As web.Entity.CT.ORCOperation) As %String
{
    new (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.OPERValid="" eobj.OPERValid="N"
		s:eobj.OPERActiveDateTo'="" eobj.OPERActiveDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OPERActiveDateTo)
		s eobj.OPERRowId=""
		s idc=0
		for
		{
			s idc=$o(^ORC("OPER",0,"Code",$$ALPHAUP^SSUTIL4(eobj.OPERCode),idc)) q:idc=""
			s OPERCode=$p($g(^ORC("OPER",idc)),"^",1)
			s OPERActiveDateTo=$p($g(^ORC("OPER",idc)),"^",6)
			continue:(OPERActiveDateTo'="")
			s OPERValid=$p($g(^ORC("OPER",idc)),"^",22)
			continue:(OPERValid="N")
			s OPERDesc=$p($g(^ORC("OPER",idc)),"^",2)
			if (OPERCode=eobj.OPERCode)&&(OPERDesc=eobj.OPERDesc)
			{
				s OPERRowId=idc
				q
			}
		}
		if (OPERRowId="")
		{
			s result = "{success:'false',errorinfo:'没有找到有效的代码及描述！'}"
		}
		else
		{
			s eobj.OPERRowId=OPERRowId
			
			s obj=##class(User.ORCOperation).%OpenId(eobj.OPERRowId)
			s bobj = ##class(web.Entity.CT.ORCOperation).%New()
			s bobj.OPERRowId = eobj.OPERRowId
			s bobj.OPERCode = obj.OPERCode
			s bobj.OPERDesc = obj.OPERDesc
			if $IsObject(obj.OPERARCIMDR){
					s bobj.OPERARCIMDR = obj.OPERARCIMDR.%Id() 
				}	
			s bobj.OPERDateActiveFrom=obj.OPERDateActiveFrom
			s bobj.OPERActiveDateTo=obj.OPERActiveDateTo
			if $IsObject(obj.OPERDefaultCategoryDR){
					s bobj.OPERDefaultCategoryDR = obj.OPERDefaultCategoryDR.%Id() 
				}
			s bobj.OPERAgeFrom = obj.OPERAgeFrom
			s bobj.OPERAgeTo = obj.OPERAgeTo
			if $IsObject(obj.OPERSexDR){
					s bobj.OPERSexDR = obj.OPERSexDR.%Id() 
				}
			s bobj.OPERICD10 =obj.OPERICD10
			s bobj.OPERICD9Map = obj.OPERICD9Map
			s bobj.OPERValid = obj.OPERValid
			s bobj.OPERDaySurgery = obj.OPERDaySurgery
		
			s bobj.OPERAgeFrom1 = obj.OPERAgeFrom1
			s bobj.OPERAgeTo1 = obj.OPERAgeTo1
			s bobj.OPERLongDescription = obj.OPERLongDescription
			s bobj.OPERGrayCodeFlag = obj.OPERGrayCodeFlag
			if $IsObject(obj.OPERVersionDictDR){
					s bobj.OPERVersionDictDR = obj.OPERVersionDictDR.%Id() 
				}
			
			//修改结束日期+有效标志
			s obj.OPERActiveDateTo=eobj.OPERActiveDateTo
			s obj.OPERValid = eobj.OPERValid
			if $IsObject(obj.OPERStandardClassDR){
					s bobj.OPERStandardClassDR = obj.OPERStandardClassDR.%Id() 
				}
			Tstart
			s sc=obj.%Save()
			do obj.%Close()
			if $$$ISOK(sc){
				Tcommit
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"
				d:eobj.OPERRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_Operation","User.ORCOperation","停用手术/过程",id,eobj.OPERDesc,"U",eobj,bobj)
				
			}else{
				Trollback
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术/过程","web.DHCBL.CT.ORCOperation","EndORCOperation",eobj)
				s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：chenying
/// CreatDate: 2023-02-02
/// Description：调用病案组接口同步手术字典数据
/// Table：User.ORCOperation
/// Input：id 
/// Return：1^同步成功，-1^失败原因
/// Other: w ##class(web.DHCBL.CT.ORCOperation).SendMsgToEMR(1)
ClassMethod SendMsgToEMR(id) As %String
{
	n (id,%session)
	q:id="" ""
	s VersionCode="",VersionName="",Valid="",ALIAS="",GrayCodeFlag=""
	s OPERCode=$p($g(^ORC("OPER",id)),"^",1)
	s OPERDesc=$p($g(^ORC("OPER",id)),"^",2)
	s OPERDateActiveFrom=$p($g(^ORC("OPER",id)),"^",5)
	s OPERActiveDateTo=$p($g(^ORC("OPER",id)),"^",6)
	s:OPERDateActiveFrom'="" OPERDateActiveFrom=$zd(OPERDateActiveFrom,3)
	s:OPERActiveDateTo'="" OPERActiveDateTo=$zd(OPERActiveDateTo,3)
	s OPERDefaultCategoryDR=$p($g(^ORC("OPER",id)),"^",7)
	i OPERDefaultCategoryDR'=""
	{
		s OPERDefaultCategoryDR=$p($g(^ORC("CATEG",OPERDefaultCategoryDR)),"^",2)
	}
	s OPERICD10=$p($g(^ORC("OPER",id)),"^",14)
	s OPERICD9Map=$p($g(^ORC("OPER",id)),"^",21)
	s OPERValid=$p($g(^ORC("OPER",id)),"^",22)
	s:OPERValid="" OPERValid="Y"   //默认激活  20170725
	s OPERGrayCodeFlag=$p($g(^ORC("OPER",id)),"^",40) //医保灰码标志
	s:OPERGrayCodeFlag="" OPERGrayCodeFlag="N"
	s OPERVersionDictDR=$p($g(^ORC("OPER",id)),"^",41) //版本号
	s OPERType=$p($g(^ORC("OPER",id,"DHC")),"^",11)  //手术操作类别
	s OPERType=$CASE(OPERType,"D":"诊断性操作","T":"治疗性操作","O":"手术","N":"手术","I":"介入治疗",:"")
    s:OPERGrayCodeFlag="Y" GrayCodeFlag=1
    s:OPERGrayCodeFlag'="Y" GrayCodeFlag=0
    S:OPERVersionDictDR'="" VersionCode=$lg($g(^CT.BDP.CT.BDVersionDictD(OPERVersionDictDR)),3)
    S:OPERVersionDictDR'="" VersionName=$lg($g(^CT.BDP.CT.BDVersionDictD(OPERVersionDictDR)),4)
    s:OPERValid="Y" Valid=1
    s:OPERValid'="Y" Valid=0
    s ALIASChildsub=0
	for 
	{
		s ALIASChildsub=$o(^ORC("OPER",id,"ALIAS",ALIASChildsub)) q:ALIASChildsub=""
		s ALIASText=$p($g(^ORC("OPER",id,"ALIAS",ALIASChildsub)),"^",1)
		s:ALIAS'="" ALIAS=ALIAS_"^"_ALIASText
		s:ALIAS="" ALIAS=ALIASText
	}
	s retMsg= ##class(MA.IPMR.IO.OutService).SendICDInfo(1,VersionCode,VersionName,OPERCode,OPERICD10,"",OPERDesc,GrayCodeFlag,"",id,OPERDateActiveFrom,OPERActiveDateTo,Valid,OPERType,OPERDefaultCategoryDR,ALIAS,.ErrMsg)
    q retMsg
}

}
