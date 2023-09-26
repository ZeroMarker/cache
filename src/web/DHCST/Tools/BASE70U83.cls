Import SQLUSER

/// Description: HIS7.0升级8.3的基础数据处理,数据来源为老系统数据导global到新系统
/// Creator:	 yunhaibao
/// CreateDate:	 2019-05-09
Class web.DHCST.Tools.BASE70U83 Extends %RegisteredObject
{

/// Description: 导入Global基础数据后执行,更新字段与关联
/// 			 !!!
/// 			 升级项目,基础数据导global的方式,非前台导excel
/// 			 !!!
/// w ##class(web.DHCST.Tools.BASE70U83).UpdateBaseAfterImpGlobal()
ClassMethod UpdateBaseAfterImpGlobal()
{
	w !,"创建库存与收费项关联关系"
	w ##class(web.DHCST.Tools.BASE70U83).CreateDHCIncTarRela()
	w !,"更新移动字段,库存项移动到药学项"
	w ##class(web.DHCST.Tools.BASE70U83).UpdatePHCDrgFormExtFromINCItm()
	w !,"更新住院发药单位与门诊发药单位"
	w ##class(web.DHCST.Tools.BASE70U83).UpdateINCItm()	
	w !,"将厂商由药学项更新到库存项"
	w ##class(web.DHCST.Tools.BASE70U83).UpdatePhmanfFromPhc()
	w !,"更新库存分类类型"
	w ##class(web.DHCST.Tools.BASE70U83).UpdateINCStkCat()
	w !,"根据药学项剂型更新处方通用名剂型"
	w ##class(web.DHCST.Tools.BASE70U83).UpdateGenericFromPHC()	
	w !,"建立新药学分类,数据源为原三级分类"
	w ##class(web.DHCST.Tools.BASE70U83).CreateDHCPHCCat()
	w !
 	q "更新完成"
}

/// Description: 判断是否药品
/// Return:		 Y-是
ClassMethod IsDrug(Inci)
{
	s stkCat=$p($g(^INCI(+Inci,2)),"^",2)
	q:stkCat=0 ""
	s catGrp=$o(^DHCSCG("STKCAT",stkCat,""))
	q:catGrp="" ""
	s catGrpType=$p($g(^DHCSCG(catGrp)),"^",3)	
	q:catGrpType="G" "Y"
	q ""
}

/// Description: 转换YN,1转Y,Y转Y,其余转N
ClassMethod FmtYN(Flag)
{
	q:Flag=1 "Y"
	q:Flag="Y" "Y"
	q "N"
}

/// Description: 根据医嘱项取收费项Id,药品取第一个在有效日期内的
/// w ##class(web.DHCST.Tools.BASE70U83).GetTarItmByArcim("2351||1")
ClassMethod GetTarItmByArcim(Arcim)
{
	q:+Arcim=0 ""
	s Arcim=+Arcim_"||"_1
	s tarItmId=""
	s stDate=""
	f  s stDate=$o(^DHCOLT(0,"ARCIM",Arcim,"Z",stDate)) q:(stDate="")||(tarItmId'="")  d
	.s oltId=""
	.f  s oltId=$o(^DHCOLT(0,"ARCIM",Arcim,"Z",stDate,oltId)) q:(oltId="")||(tarItmId'="")  d
	..q:+oltId=0
	..s oltData=^DHCOLT(oltId)
	..s edDate=$p(oltData,"^",5)
	..q:(edDate'="")&&(+edDate<+$h)
	..s tarItmId=$p(oltData,"^",2)
	q tarItmId
}

/// 
/// Description: 建立新药学分类,数据源为原三级分类
/// w ##class(web.DHCST.Tools.BASE70U83).CreateDHCPHCCat()
ClassMethod CreateDHCPHCCat()
{
	w "处理药学分类字典",!
	w ##class(web.DHCST.DHCSTPHCCATMAINTAIN).ImportAllPhcCat()
	w "处理院区字段",!
	&SQL(UPDATE DHC_PHCCat SET PHCC_Hosp_Dr=(SELECT TOP 1 HOSP_RowId FROM CT_Hospital ORDER BY HOSP_RowId))
	i SQLCODE=0 w "院区字段处理成功",!
	e  w "院区字段处理失败,"_SQLCODE_$g(%msg),!
	q "完成"
}

/// Description: 更新库存分类类型
/// w ##class(web.DHCST.Tools.BASE70U83).UpdateINCStkCat()
ClassMethod UpdateINCStkCat()
{
	s cnt=0,succCnt=0,failCnt=0
	s stkCat=""
	f  s stkCat=$o(^INC("SC",stkCat)) q:stkCat=""  d
	.s catGrp=$o(^DHCSCG("STKCAT",stkCat,""))
	.q:catGrp=""
	.s catGrpType=$p(^DHCSCG(catGrp),"^",3)
	.q:catGrpType'="G"
	.q:$p(^INC("SC",stkCat),"^",3)'=""
	.&SQL(UPDATE INC_StkCat SET INCSC_StkType=:catGrpType WHERE INCSC_RowId=:stkCat)
	.i SQLCODE=0 s succCnt=succCnt+1
	.e  s failCnt=failCnt+1
	.s cnt=cnt+1
	.w stkCat_","
	w !
	q "总记录数:"_cnt_",成功记录数:"_succCnt_",失败记录数:"_failCnt
}

/// Description: 创建库存与收费项关联关系
/// w ##class(web.DHCST.Tools.BASE70U83).CreateDHCIncTarRela()
ClassMethod CreateDHCIncTarRela()
{
	s cnt=0,succCnt=0,failCnt=0
	s startDate=+$h-1
	s inci=""
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.q:+inci=0
	.q:..IsDrug(inci)'="Y"
	.s arcim=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(inci)
	.q:+arcim=0
	.s tarItm=..GetTarItmByArcim(arcim)
	.i '$d(^DHCINCTARi("INCI",inci)) d
	..&SQL(
		INSERT INTO DHC_IncTarRela 
		(INCTR_INCI_Dr,INCTR_Tari_Dr,INCTR_Qty,INCTR_StartDate)
		VALUES
		(:inci,:tarItm,1,:startDate)
	 )
	..i SQLCODE=0 s succCnt=succCnt+1
	..e  s failCnt=failCnt+1
	..s cnt=cnt+1
	..w inci_","
	q "总记录数:"_cnt_",成功记录数:"_succCnt_",失败记录数:"_failCnt
}

/// Description: 更新住院发药单位与门诊发药单位
/// w ##class(web.DHCST.Tools.BASE70U83).UpdateINCItm()
ClassMethod UpdateINCItm()
{
	s cnt=0,succCnt=0,failCnt=0
	s inci=""
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.q:+inci=0
	.q:..IsDrug(inci)'="Y"
	.s bUomId=$p(^INCI(inci,1),"^",10)
	.q:+bUomId=0
	.s arcim=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(inci)
	.q:+arcim=0
	.s billUomId=$p($g(^ARCIM(+arcim,1,8)),"^",14)
	.q:+billUomId=0
	.&SQL(UPDATE INC_Itm SET INCI_CTUOM_OutPat_DR=:billUomId,INCI_CTUOM_InPat_DR=:bUomId WHERE INCI_RowId=:inci)
	.i SQLCODE=0 s succCnt=succCnt+1
	.e  s failCnt=failCnt+1
	.s cnt=cnt+1
	.w inci_","
	w !
	q "总记录数:"_cnt_",成功记录数:"_succCnt_",失败记录数:"_failCnt
}

/// Description: 更新移动字段,库存项移动到药学项
/// w ##class(web.DHCST.Tools.BASE70U83).UpdatePHCDrgFormExtFromINCItm()
ClassMethod UpdatePHCDrgFormExtFromINCItm()
{
	s cnt=0,succCnt=0,failCnt=0
	s inci=""
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.q:+inci=0
	.q:..IsDrug(inci)'="Y"
	.s bUomId=$p(^INCI(inci,1),"^",10)
	.q:+bUomId=0
	.s arcim=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(inci)
	.q:+arcim=0
	.s phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcim)
	.s itmAdd=$o(^DHCITMINFO(0,"INCI",inci,""))
	.q:+itmAdd=0
	.s itmAddData=$g(^DHCITMINFO(itmAdd))
	.q:itmAddData=""
	.// 国家基本药物,YN
	.s INFOBasicDrug=..FmtYN($p(itmAddData,"^",4))
	.// 非处方OTC,5
	.s INFOOTC=$p(itmAddData,"^",5)
	.// 中国药典
	.s INFOCodex=..FmtYN($p(itmAddData,"^",7))
	.// 临床验证用药
	.s INFOTest=..FmtYN($p(itmAddData,"^",6))
	.// 处方购药
	.s INFORec=..FmtYN($p(itmAddData,"^",11))
	.// TPN
	.s INFOTpnFlag=..FmtYN($p(itmAddData,"^",39))
	.// 省基本药物
	.s INFODrugbase2=..FmtYN($p(itmAddData,"^",40))
	.// 市基本药物
	.s INFOPDrugbase1=..FmtYN($p(itmAddData,"^",41))
	.// 区县基本药物
	.s INFOPDrugbase2=..FmtYN($p(itmAddData,"^",42))
	.// 重点监控
	.s INFOMonitorFlag=..FmtYN($p(itmAddData,"^",93))
	.&SQL(
		UPDATE PHC_DrgFormExt
		SET 
		PHCDF_BasicDrug=:INFOBasicDrug,
		PHCDF_Drugbase2=:INFODrugbase2,
		PHCDF_PDrugbase1=:INFOPDrugbase1,
		PHCDF_PDrugbase2=:INFOPDrugbase2,
		PHCDF_OTC=:INFOOTC,
		PHCDF_Codex=:INFOCodex,
		PHCDF_Test=:INFOTest,
		PHCDF_TpnFlag=:INFOTpnFlag,
		PHCDF_MonitorFlag=:INFOMonitorFlag
		WHERE PHCDF_RowId=:phcdf
	 )
	.i SQLCODE=0 s succCnt=succCnt+1
	.e  s failCnt=failCnt+1
	.s cnt=cnt+1
	.w inci_","
	w !
	q "总记录数:"_cnt_",成功记录数:"_succCnt_",失败记录数:"_failCnt
}

/// Description: 导入处方通用名+药学分类+品种通用+类组的关系
/// 			 导入文件为制表符格式的txt
/// windows路径: w ##class(web.DHCST.Tools.BASE70U83).InputGeneric("D:\import\generic.txt")
/// 小机路径:	 w ##class(web.DHCST.Tools.BASE70U83).InputGeneric("/tmp/dhcst/generic.txt")
ClassMethod InputGeneric(FilePathName)
{
  s cnt=0,succCnt=0,failCnt=0
  s sub="InputGeneric"
  s p=$zn
  k ^zTSA(p,sub)
  s ret=##class(web.DHCST.Tools.LoadData).LoadData(FilePathName,sub,p)
  // 抬头
  s rowTitleStr=$g(^zTSA(p,sub,2))
  q:rowTitleStr="" "-1^没有标题"
  s rowTitleList=$lfs(rowTitleStr,"^")
  s i=2
  f  s i=$O(^zTSA(p,sub,i)) q:i=""  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .s rowData=""
  .s rowI=""
  .f rowI=1:1:$ll(rowTitleList) d
  ..s rowColData=$lg(rowTitleList,rowI)_"^"_$p(rowStr,"^",rowI)
  ..i rowData="" s rowData=rowColData
  ..e  s rowData=rowData_"|"_rowColData
  .// 数据
  .s saveRet=##class(web.DHCST.Tools.InputDrugBasicLevelData).SaveChemGeneForUpdate(rowData)
  .s cnt=cnt+1
  .i $p(saveRet,"^",1)<0 d
  ..w failCnt=failCnt+1
  ..w saveRet,!
  .e  d
  ..w "."
  ..w succCnt=succCnt+1
  q "总记录数:"_cnt_",成功记录数:"_succCnt_",失败记录数:"_failCnt
}

/// Description: 重置计数器
/// w ##class(web.DHCST.Tools.BASE70U83).ReBulidMData()
ClassMethod ReBulidMData()
{
	s cnt=999999999999999
	s addNum=1
	w "重置计数器",!,!
	w "药学项",!
	s ^PHCD(0)=$o(^PHCD(cnt),-1)+addNum
	w "库存项",!
	s ^INCI(0)=$o(^INCI(cnt),-1)+addNum
	s ^mdata("DHCITMADDIONINFO")=$o(^DHCITMINFO(cnt),-1)+addNum
	w "科室库存扩展",!
	s ^mdata("DHCINCITMLOC")=$o(^DHCINCIL(cnt),-1)+addNum
	w "类组",!
	s ^mdata("DHCSTKCATGROUP")=$o(^DHCSCG(cnt),-1)+addNum
	w "库存分类",!
	s ^INC("SC",0)=$o(^INC("SC",cnt),-1)+addNum
	w "供应商",!
	s ^APC("APCVM",0)=$o(^APC("APCVM",cnt),-1)+addNum
	s ^mdata("DHCSTVENDOR")=$o(^DHCSTV(cnt),-1)+addNum
	w "供应商分类",!
	s ^APC("APCVC",0)=$o(^APC("APCVC",cnt),-1)+addNum
	w "配送商",!
	s ^mdata("DHCCARRIER")=$o(^DHCCARR(cnt),-1)+addNum
	w "厂商",!
	s ^PHMNF(0)=$o(^PHMNF(cnt),-1)+addNum
	s ^mdata("DHCMANFADDIONINFO")=$o(^DHCMANF(cnt),-1)+addNum
	w "库存信息",!
	s ^mdata("DHCLOCDAILYTOTAL")=$o(^DHCLOCTOT(cnt),-1)+addNum
	w !
	q "完成"
}

/// Description: 清除批次库存信息
/// w ##class(web.DHCST.Tools.BASE70U83).KillInclb()
ClassMethod KillInclb()
{
	/*
	&SQL(DELETE FROM INC_ItmBat)		// 批次信息
	&SQL(DELETE FROM INC_ItmLcBt)		// 批次库存
	&SQL(DELETE FROM IN_AdjPriceBatch)	// 批次价格
	&SQL(DELETE FROM DHC_ASPAmount)		// 损益
	&SQL(DELETE FROM DHC_ASPAmountLB)	// 批次损益
	&SQL(DELETE FROM DHC_IncItmBat)		// 批次信息附加
	&SQL(DELETE FROM DHC_INCItmLcBt)	// 批次库存信息附加
	&SQL(DELETE FROM DHC_LocBTDailyTotal) // 科室批次库存
	&SQL(DELETE FROM DHC_LocDailyTotal) 	// 科室库存
	*/
	
	k ^INCI("LB_IB")
	k ^INCI("IB_EX")
	k ^INCI("IB_NO")
	k ^DHCINCLBi,^DHCINCLB				// 批次信息附加-global
	k ^DHCINCIB
	k ^DHCLOCTOT
	k ^DHCBTLOCTOT
	s incId=""
	f  s incId=$o(^INCI(incId)) q:incId=""  d
	.q:+incId=0
	.k ^INCI(incId,"IB")
	.s incCh=""
	.f  s incCh=$o(^INCI(incId,"IL",incCh)) q:incCh=""  d
	..q:+incCh=0
	..k ^INCI(incId,"IL",incCh,"LB")
	q 0
}

/// Description: 更新货位,创建到货位表
/// w ##class(web.DHCST.Tools.BASE70U83).CreateDHCIncItmLocBin()
ClassMethod CreateDHCIncItmLocBin()
{
	
	s cnt=0,succCnt=0,failCnt=0
	s incId=""
	f  s incId=$o(^INCI(incId)) q:incId=""  d
	.q:+incId=0
	.s incCh=""
	.f  s incCh=$o(^INCI(incId,"IL",incCh)) q:incCh=""  d
	..q:+incCh=0
	..s incLocBinDr=$p(^INCI(incId,"IL",incCh),"^",2)
	..s locId=$p(^INCI(incId,"IL",incCh),"^",1)
	..q:+incLocBinDr=0
	..s incil=incId_"||"_incCh
	..&SQL(SELECT * from DHC_IncItmLocBin where INCILB_ItmLoc_Dr=:incil and INCILB_StkBin_Dr=:incLocBinDr)
	..q:SQLCODE=0
	..&sql(Insert into DHC_IncItmLocBin(INCILB_ItmLoc_Dr,INCILB_StkBin_Dr)values(:incil,:incLocBinDr))
	..i SQLCODE=0 s succCnt=succCnt+1
	..e  s failCnt=failCnt+1
	..s cnt=cnt+1
	..w inci,!
	w !
	q "总记录数:"_cnt_",成功记录数:"_succCnt_",失败记录数:"_failCnt
}

/// Description: 将药学分类在化学通用名的关联更新到处方通用名
/// w ##class(web.DHCST.Tools.BASE70U83).UpdateGenePhcCatFromChem()
ClassMethod UpdateGenePhcCatFromChem()
{
	s cnt=0,succCnt=0,failCnt=0
	s geneId=""
	s geneId=""
	f  s geneId=$o(^PHCGE("GE",geneId)) q:geneId=""  d
	.q:+geneId=0  
	.s dhcGeneData=$g(^PHCGE("GE",geneId,"DHC"))
	.q:dhcGeneData=""
	.s chemId=$p(dhcGeneData,"^",3)
	.s phcCatId=$p($g(^DHCPHCM(+chemId)),"^",3)
	.q:phcCatId="" 
	.&SQL(
	 	UPDATE DHC_PhcGeneric 
	 	SET PHCGE_PHCC_DR=:phcCatId
	 	WHERE PHCGE_RowId=:geneId
	  )
	.i SQLCODE=0 s succCnt=succCnt+1
	.e  s failCnt=failCnt+1
	.s cnt=cnt+1
	.w geneId,!
	w !
	q "总记录数:"_cnt_",成功记录数:"_succCnt_",失败记录数:"_failCnt
}

/// Description: 将厂商由药学项更新到库存项
/// w ##class(web.DHCST.Tools.BASE70U83).UpdatePhmanfFromPhc()
ClassMethod UpdatePhmanfFromPhc()
{
	s cnt=0,succCnt=0,failCnt=0
	s inci=""
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.q:+inci=0
	.s stkCat=$p($g(^INCI(inci,2)),"^",2)
	.q:stkCat=""
	.q:$p($G(^INC("SC",stkCat)),"^",3)'="G"
	.s arcimId=$p($g(^INCI(inci,1)),"^",3)
	.q:arcimId=""
	.s phcdfId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",12)
	.q:phcdfId=""
	.s manfId=$p(^PHCD(+phcdfId,2),"^",4)
	.s itmInfoId=$o(^DHCITMINFO(0,"INCI",inci,""))
	.q:itmInfoId=""
	.&SQL(UPDATE DHC_ItmAddionInfo SET INFO_PHMNF_DR=:manfId WHERE INFO_RowId=:itmInfoId)
	.i SQLCODE=0 s succCnt=succCnt+1
	.e  s failCnt=failCnt+1
	.s cnt=cnt+1
	.w inci,!
	w !
	q "总记录数:"_cnt_",成功记录数:"_succCnt_",失败记录数:"_failCnt
}

/// Description: 根据药学项剂型更新处方通用名剂型
/// w ##class(web.DHCST.Tools.BASE70U83).UpdateGenericFromPHC()
ClassMethod UpdateGenericFromPHC()
{
	s cnt=0,succCnt=0,failCnt=0
	s phcd=""
	f  s phcd=$o(^PHCD(phcd)) q:phcd=""  d
	.q:+phcd=0
	.s geneId=$p($g(^PHCD(phcd,4)),"^",1)
	.s formId=$p($g(^PHCD(phcd,"DF",1,1)),"^",1)
	.q:formId=""
	.q:geneId=""
	.&SQL(
	 	UPDATE DHC_PhcGeneric 
	 	SET PHCGE_PHCF_Dr=:formId
	 	WHERE PHCGE_RowId=:geneId
	  )	
	.i SQLCODE=0 s succCnt=succCnt+1
	.e  s failCnt=failCnt+1
	.s cnt=cnt+1
	.w $P(^PHCF(formId),"^",2),!
	w !
	q "总记录数:"_cnt_",成功记录数:"_succCnt_",失败记录数:"_failCnt
}

}
