/// description: 配液药品信息维护
Class web.DHCSTPIVAS.DrugMaintain Extends web.DHCSTPIVAS.Common
{

Parameter LogSign [ Final ] = "配液中心 - 药品信息维护";

/// creator: 	yunhaibao
/// createdate: 2018-03-29
/// description:获取配液药品信息表格,仅显示
/// w ##class(web.DHCSTPIVAS.DrugMaintain).JsGetIncItm("30","1","102^^^N")
ClassMethod JsGetIncItm(rows, page, inputStr, filterRules)
{
	#; s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.DrugMaintain","JsGetIncItm")=$lb(rows, page, inputStr)
	i +page=0 s page=1
	s filterFlag = ##class(web.DHCSTPIVAS.Util).NeedFilterPagination(filterRules)
	s rowsNum = $s(filterFlag = $$$YES : 99999 , 1 : rows)
	s pageNum = $s(filterFlag = $$$YES : 1 , 1 : page)
	s fStart = ((page-1)*rows)+1
	s fEnd = page*rows  
	s getRet=..GetIncItm(rowsNum, pageNum, inputStr)
	s pid=$p(getRet,"^",1)
	s total=$p(getRet,"^",2)
	q:(pid="")||(+total=0) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
   	s title1="incil^incId^incCode^incDesc^incSpec"
    s title2="manfDesc^phcDrugTypeDesc^menstruumFlag^phcPivaCatDesc^ivgttSpeed"
    s title3="labelSign^useInfo^storeInfo^phcPivaCatId^phcDrugTypeCode"
    s title4="conTblId^conTblDesc^coef^conCoef^sameCoef"
	s title5="ordCode"
    s title=title1_"^"_title2_"^"_title3_"^"_title4_"^"_title5
    
    s hasFirst=$$$NO
    s count=0
	s outputI=""
	f  s outputI=$o(^||TMP("DHCST","web.DHCSTPIVAS.DrugMaintain","GetIncItm",pid,outputI)) q:outputI=""  d
	.s outputData=^||TMP("DHCST","web.DHCSTPIVAS.DrugMaintain","GetIncItm",pid,outputI)
	.s rowData = ##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
	.q:(filterFlag = $$$YES)&&(##class(web.DHCSTPIVAS.Util).DataGridFilter(rowData, filterRules)'=$$$YES)
	.s count=count+1
	.q:(filterFlag = $$$YES)&&((count < fStart) || (count > fEnd))	
	.w $s(hasFirst=$$$YES:",",1:##class(web.DHCSTJQUERYCOMMON).getJsonRowSign()) s hasFirst=$$$YES
	.w rowData
	i count>0   w ##class(web.DHCSTJQUERYCOMMON).getJsonTotalEndSign($s(filterFlag = $$$YES : count, 1:total))
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	d ..KillGetIncItm(pid)
	q ""
}

/// creator: 	yunhaibao
/// createdate: 2018-03-29
/// description:获取配液药品信息
ClassMethod GetIncItm(rows, page, inputStr)
{
	k GetIncItmDATA
	s EndRow=page*rows  
	s StartRow=((page-1)*rows)+1
	s PivaLocId=$p(inputStr,"^",1)
	s StkCatId=$p(inputStr,"^",2)
	s IncAlias=$p(inputStr,"^",3)
	s MyLoc=$p(inputStr,"^",4)
    s InciRowId=+$p(inputStr,"^",5)
	q:PivaLocId="" ""
	s HospId=$p($g(^CTLOC(PivaLocId)),"^",22)
	q:(MyLoc="Y")&&(PivaLocId="") ""
	s pid=..NewPid()
	i IncAlias="1234321" d
    e  i InciRowId'=0  d 
    .s incId=InciRowId
    .d GetIncItmData
	e  i MyLoc="Y" d
	.s incId=""
	.f  s incId=$o(^INCI("IL_LOC",PivaLocId,incId)) q:incId=""  d
	..d GetIncItmData
	e  d
	.s incId=0
	.f  s incId=$o(^INCI(incId)) q:incId=""  d
	..q:+incId=0
	..q:(HospId'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_Itm",incId,HospId)="N")
	..d GetIncItmData
	s count=0
	s sortIndex=""
	f  s sortIndex=$o(GetIncItmDATA(sortIndex)) q:sortIndex=""  d
	.s incId=""
	.f  s incId=$o(GetIncItmDATA(sortIndex,incId)) q:incId=""  d
	..s count=count+1
	..q:count<StartRow
    ..q:count>EndRow
    ..s tmpData=GetIncItmDATA(sortIndex,incId)
    ..s arcItm=$p(tmpData,"^",1)
    ..s phcdRowId=$p(tmpData,"^",2)
    ..s inciCh=$o(^INCI("IL_LOC",PivaLocId,incId,""))
    ..i inciCh'="" d
    ...s incil=incId_"||"_inciCh
	...s dhcincil=$o(^DHCINCIL(0,"INCIL",incil,""))
    ..e  s (incil,dhcincil)=""
    ..s incDesc=##class(PHA.COM.Data.Base).InciDesc(incId)
    ..s incCode=$p(^INCI(incId,1),"^",1)
    ..s incSpec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",incId)
    ..s manfStr=##class(web.DHCST.Common.DrugInfoCommon).GetManf(incId)
    ..s manfDesc=##class(PHA.COM.Data.Base).ManfName($p(manfStr,"^",1))
	..s phcdId=+phcdRowId,phcdfId=+$p(phcdRowId,"||",2)
	..s phcdExtData=$g(^PHCD(+phcdId,"DF",+phcdfId,"DHC"))
	..s ivgttSpeed=$p(phcdExtData,"^",13) 			// 滴速
	..s menstruumFlag=$p(phcdExtData,"^",44)      	// 溶媒
	..i menstruumFlag'="Y" s menstruumFlag="N"
	..s phcPivaCatId=$p(phcdExtData,"^",24) 		// 配液小类
	..s phcPivaCatDesc=##class(PHA.PIVAS.Data.Base).PHCPivaCatDesc(phcPivaCatId)
	..s phcDrugType=$p(phcdExtData,"^",18) 			// 主治辅助用药
	..s ordCode=""
	..i phcDrugType'="" d
	...s phcDrugTypeDesc=##class(PHA.COM.Data.Base).StkComDictionaryDesc(+phcDrugType)
	...s phcDrugTypeCode=$p($g(^DHCSTSCDI(+phcDrugType)),"^",1)
	..e  s (phcDrugTypeDesc,phcDrugTypeCode)=""
	..s itmAdd=$o(^DHCITMINFO(0,"INCI",incId,""))
	..s (labelSign,useInfo,storeInfo,conTblId,conTblDesc,coef,conCoef,sameCoef)=""
	..i itmAdd'="" s labelSign=$p($g(^DHCITMINFO(itmAdd)),"^",116)
	..i dhcincil'="" d
	...s useInfo=$p($g(^DHCINCIL(dhcincil,"PIVAS")),"^",1)
	...s storeInfo=$p($g(^DHCINCIL(dhcincil,"PIVAS")),"^",2)
	...s conTblId=$p($g(^DHCINCIL(dhcincil)),"^",37)
	...i conTblId'="" s conTblDesc=##class(PHA.COM.Data.Base).PIVAConfigTableDesc(conTblId)
	...s coef=$p($g(^DHCINCIL(dhcincil)),"^",30)
	...i (coef>0)&&(coef<1)&&($p(coef,".",1)="") s coef=0_coef
	...s conCoef=$p($g(^DHCINCIL(dhcincil,"PIVAS")),"^",5)
	...i (conCoef>0)&&(conCoef<1)&&($p(conCoef,".",1)="") s conCoef=0_conCoef
	...s sameCoef=$p($g(^DHCINCIL(dhcincil,"PIVAS")),"^",6)
	...i (sameCoef>0)&&(sameCoef<1)&&($p(sameCoef,".",1)="") s sameCoef=0_sameCoef
	...s ordCode=$p($g(^DHCINCIL(dhcincil,"PIVAS")),"^",4)
    ..s data1=incil_"^"_incId_"^"_incCode_"^"_incDesc_"^"_incSpec
    ..s data2=manfDesc_"^"_phcDrugTypeDesc_"^"_menstruumFlag_"^"_phcPivaCatDesc_"^"_ivgttSpeed
    ..s data3=labelSign_"^"_useInfo_"^"_storeInfo_"^"_phcPivaCatId_"^"_phcDrugTypeCode
    ..s data4=conTblId_"^"_conTblDesc_"^"_coef_"^"_conCoef_"^"_sameCoef
	..s data5=ordCode
    ..s data=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5
    ..s ^||TMP("DHCST","web.DHCSTPIVAS.DrugMaintain","GetIncItm",pid,count)=data
    q pid_"^"_count
GetIncItmData
	q:+incId=0
	q:$p(^INCI(incId,2),"^",9)="Y"
	s incStkCat=$p(^INCI(incId,2),"^",2)
	q:(StkCatId'="")&&(StkCatId'=incStkCat)
	s stkCatType=$p($g(^INC("SC",+incStkCat)),"^",3)
	q:stkCatType'="G"
	s arcItm=$p(^INCI(incId,1),"^",3)
	q:+arcItm=0
	s arcSub=+arcItm,arcVer=+$p(arcItm,"||",2)
	s phcdRowId=$p(^ARCIM(arcSub,arcVer,1),"^",12) 
	q:+phcdRowId=0
	q:(IncAlias'="")&&(+##class(web.DHCST.INCALIAS).CheckIncAliasExist(incId,IncAlias)<0)
	s incCode=$p(^INCI(incId,1),"^",1)
	s sortIndex=incCode
	s GetIncItmDATA(sortIndex,incId)=arcItm_"^"_phcdRowId
	q
}

/// creator: 	yunhaibao
/// createdate: 2018-03-29
/// description:保存配液药品信息
ClassMethod SaveData(inputStr)
{
	s $zt="ThrowSaveData"
	s locId=$p(inputStr,"^",1)
	s incId=$p(inputStr,"^",2)
	s conTblId=$p(inputStr,"^",3)
	s useInfo=$p(inputStr,"^",4)
	s storeInfo=$p(inputStr,"^",5)
	s ivgttSpeed=$p(inputStr,"^",6)
	s phcPivaCat=$p(inputStr,"^",7)
	s phcDrgType=$p(inputStr,"^",8)
	s menstrFlag=$p(inputStr,"^",9)
	s labelSign=$p(inputStr,"^",10)
	s coef=$p(inputStr,"^",11)
   	s conCoef=$p(inputStr,"^",12)
    s sameCoef=$p(inputStr,"^",13)
	s ordCode=$p(inputStr,"^",14)
	s phcDrgTypeId=""
	i phcDrgType'="" &SQL(SELECT SCDI_RowID into :phcDrgTypeId FROM DHC_StkComDictionary WHERE SCDI_Type='MedicalType' AND SCDI_Code=:phcDrgType)
	q:locId="" ..Translate("-1^配液中心为空") // @translate
	q:incId="" ..Translate("-1^药品为空") // @translate
	s errCode=""
    s oldJson=..GetDrugData(locId, incId)
	ts
	s inciCh=$o(^INCI("IL_LOC",locId,incId,""))
	i inciCh="" d
	.s incil=##class(web.DHCST.INCItmLoc).Insert(incId,locId)
	.i +incil<0  d
	..d ErrorRecord^DHCSTERROR("DHCSTINPIVA","incId:"_incId_",locId:"_locId,"插入科室库存项失败")
	..s errCode=..Translate("-2^插入科室库存项失败") // @translate
	e  s incil=incId_"||"_inciCh
	q:errCode'="" errCode
	s dhcincil=$o(^DHCINCIL(0,"INCIL",incil,""))
	i dhcincil="" d
	.&sql(insert into dhc_incitmloc (incil_incil_dr) values (:incil) )
	.i SQLCODE'=0 d
	..d ErrorRecord^DHCSTERROR("DHCSTINPIVA","incil:"_incil,%msg)
	..s errCode="-2^"_%msg
	.e  s dhcincil=%ROWID
	q:errCode'="" errCode
	&SQL(
		UPDATE DHC_IncItmLoc SET 
		INCIL_PIVAConfTable=:conTblId,INCIL_UseInfo=:useInfo,INCIL_StoreInfo=:storeInfo,
		INCIL_PIVACoefficient=:coef,INCIL_PIVAConCoef=:conCoef,INCIL_PIVASameCoef=:sameCoef,
		INCIL_PIVAOrdCode=:ordCode
		WHERE INCIL_RowId=:dhcincil
	)
	i SQLCODE'=0 d
	.d ErrorRecord^DHCSTERROR("DHCSTINPIVA","INCIL_RowId:"_dhcincil,%msg)
	.s errCode=$$$pivasError4Sql($g(%msg))
	q:errCode'="" errCode
	s arcItm=$p(^INCI(incId,1),"^",3)
	s arcSub=+arcItm,arcVer=+$p(arcItm,"||",2)
	s phcdRowid=$p(^ARCIM(arcSub,arcVer,1),"^",12)
	&sql(
		Update  PHC_DrgFormExt set 
		PHCDF_ivgttSpeed=:ivgttSpeed,PHCDF_SCDI_Dr=:phcDrgTypeId,PHCDF_PivaCatDr=:phcPivaCat,PHCDF_MenstruumFlag=:menstrFlag
		where PHCDF_RowId=:phcdRowid
	)
	i SQLCODE'=0 d
	.d ErrorRecord^DHCSTERROR("DHCSTINPIVA","PHCDF_RowId:"_phcdRowid,%msg)
	.s errCode=$$$pivasError4Sql($g(%msg))
	q:errCode'="" errCode
	&SQL(
		UPDATE  DHC_ItmAddionInfo 
		SET INFO_PivaBack=:labelSign
		WHERE INFO_INCI_DR=:incId
	)
	i SQLCODE'=0 d
	.d ErrorRecord^DHCSTERROR("DHCSTINPIVA","INFO_INCI_DR:"_incId,%msg)
	.s errCode=$$$pivasError4Sql($g(%msg))
	q:errCode'="" errCode
	tc
    s newJson=..GetDrugData(locId, incId)
    #; 日志
    s rowID = locId_ "||" _ incId
	s logSignDesc=$p(^INCI(incId, 1), "^", 2)
	s logType = "U"
    s newJsonStr = newJson.%ToJSON()
    s oldJsonStr = oldJson.%ToJSON()
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("web.DHCSTPIVAS.DrugMaintain", "web.DHCSTPIVAS.DrugMaintain", ..#LogSign, rowID, logSignDesc, logType, newJsonStr, oldJsonStr)

	q 0
	
ThrowSaveData
	s errMsgInfo="##class(web.DHCSTPIVAS.DrugMaintain).SaveData"
	d ErrorRecord^DHCSTERROR("DHCSTINPIVA",errMsgInfo,$ze)	
	q "-2^"_$tr($ze,"^","-")
}

ClassMethod KillGetIncItm(pid)
{
	q:pid="" ""
	k ^TMP("DHCST","web.DHCSTPIVAS.DrugMaintain","GetIncItm",pid)
	q ""
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($this,"PIVA")
}

/// Description: 获取一条药品信息
/// Debug:       w ##class(web.DHCSTPIVAS.DrugMaintain).GetDrugData("2661||11").%ToJSON()
ClassMethod GetDrugData(pLoc, pInci) As %DynamicObject
{
    s paramsStr = $lts($lb(pLoc, "", "", "", +pInci), "^")
    s dataStr = ..GetIncItm(1, 1, paramsStr)
    s pid = $p(dataStr, "^", 1)
    s count = $p(dataStr, "^", 2)
    q:(count = 0) {}
    s index = $o(^||TMP("DHCST", "web.DHCSTPIVAS.DrugMaintain", "GetIncItm", pid, ""))
    q:(index = "") {}
    s data = $g(^||TMP("DHCST", "web.DHCSTPIVAS.DrugMaintain", "GetIncItm", pid, index))
    k ^||TMP("DHCST", "web.DHCSTPIVAS.DrugMaintain", "GetIncItm", pid, index)
    q {
        "incil": ($p(data, "^", 1)),
        "incId": ($p(data, "^", 2)),
        "药品代码": ($p(data, "^", 3)),
        "药品名称": ($p(data, "^", 4)),
        "主辅用药": ($p(data, "^", 7)),
        "是否溶媒": ($p(data, "^", 8)),
        "配液小类": ($p(data, "^", 9)),
        "滴速": ($p(data, "^", 10)),
        "标签标识": ($p(data, "^", 11)),
        "用法": ($p(data, "^", 12)),
        "存储条件": ($p(data, "^", 13)),
        "phcPivaCatId": ($p(data, "^", 14)),
        "phcDrugTypeCode": ($p(data, "^", 15)),
        "conTblId": ($p(data, "^", 16)),
        "配置台": ($p(data, "^", 17)),
        "难度系数1": ($p(data, "^", 18)),
        "难度系数2": ($p(data, "^", 19)),
        "难度系数3": ($p(data, "^", 20)),
        "显示顺序": ($p(data, "^", 21))
    }
}

}
