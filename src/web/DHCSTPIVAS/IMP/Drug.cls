/// Description: 配液药品信息导入
/// 小机:		 w ##class(web.DHCSTPIVAS.IMP.Drug).StartInput("/tmp/DHCSTPIVASDrug.txt")
/// window:		 w ##class(web.DHCSTPIVAS.IMP.Drug).StartInput("D:\tmp\DHCSTPIVASDrug.txt")
Class web.DHCSTPIVAS.IMP.Drug Extends %RegisteredObject
{

/// Description: 导入入口
ClassMethod StartInput(fileName As %String, sub As %String = "") As %String
{
  i sub="" s sub="PIVAS"
  s p=$zn
  s ret=##class(web.DHCST.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  s i=1
  f  s i=$O(^zTSA(p,sub,i)) q:i=""  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .q:rowStr["药品代码"
  .s cnt=cnt+1
  .tstart
  .s ret=..SaveDrug(rowStr)
  .i $p(ret,"^",1)<0 d
  ..w $p(ret,"^",2)_":"_rowStr,!
  ..trollback
  .e  d
  ..tcommit
  ..s successCnt=successCnt+1
  ..w "."
  k ^zTSA(p,sub)  //删除临时global
  q "共"_cnt_"条记录,成功更新"_successCnt_"条"
}

ClassMethod SaveDrug(rowStr)
{
	s locDesc=$p(rowStr,"^",1)
	q:locDesc="" "-1^科室为空"
	s locId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(locDesc),""))
	q:locId="" "-1^科室不存在"
	s inciCode=$p(rowStr,"^",2)
	q:inciCode="" "-1^代码为空"
	s inciDesc=$p(rowStr,"^",3)
	s inci=""
	&SQL(SELECT INCI_RowId INTO :inci FROM SQLUSER.INC_Itm WHERE INCI_Code=:inciCode)
	q:inci="" "-1^代码为空"
	s phcDrgType=$p(rowStr,"^",4)
	i phcDrgType="主治用药" s phcDrgType="P" 
	e  i phcDrgType="辅助用药" s phcDrgType="A"
	e  s phcDrgType=""
	s menstrFlag=$p(rowStr,"^",5)
	i menstrFlag="是" s menstrFlag="Y"
	e  i menstrFlag="否" s menstrFlag="N"
	e  s menstrFlag=""
	s conTblDesc=$p(rowStr,"^",6)
	s conTblId=$s(conTblDesc'="":$o(^PIVACTi("Desc",locId,conTblDesc,"")),1:"")
	s phcPivaCatDesc=$p(rowStr,"^",7)
	s phcPivaCatId=$s(phcPivaCatDesc'="":$o(^PHCPIVACAT(0,"Desc",$$ALPHAUP^SSUTIL4(phcPivaCatDesc),"")),1:"")
	s ivgttSpeed=$p(rowStr,"^",8)
	s labelSign=$p(rowStr,"^",9)
	s useInfo=$p(rowStr,"^",10)
	s storeInfo=$p(rowStr,"^",11)
	s saveData1=locId_"^"_inci_"^"_conTblId_"^"_useInfo_"^"_storeInfo
	s saveData2=ivgttSpeed_"^"_phcPivaCatId_"^"_phcDrgType_"^"_menstrFlag_"^"_labelSign
	s saveData=saveData1_"^"_saveData2
	s saveRet=##class(web.DHCSTPIVAS.DrugMaintain).SaveData(saveData)
	q saveRet
}

}
