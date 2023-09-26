Class dhc.bonus.umodule.uGetDuraData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：zhaoliguo
/// CreatDate：2015-1-8
/// Description:  调用成本核算系统的物资材料成本
/// Table：
/// Input：start-起始日期,end-终止日期
/// Output：
/// Return：///73 物资供应，198 器械材料库,85 药库
/// Others：w ##class(dhc.bonus.umodule.uGetDuraData).GetBonusDura("2015-03","1","chenwen")
ClassMethod GetBonusDura(payYearMonth, Methord, user) As %String
{
	n (payYearMonth,Methord,user)
	
	s ret=0
	q:payYearMonth="" 0
	k ^herpcwtemp("Dura02")
	s year=$P(payYearMonth,"-",1)
	s month=$P(payYearMonth,"-",2)
	s period="M"_month
	s frdate=payYearMonth_"-01"
	s todate=payYearMonth_"-28"
	
	s frdate=$zdh(frdate,3)
	s todate=$zdh(todate,3)
	s month1="M"_month
	&sql(delete from dhc_bonus_module.BonusExpendCollect  where Methord=1 and BonusYear=:year and BonusPeriod=:month1 )
	
	s sqlStr1=" select  a.SMT_SMR_Parref->SMR_SM_Parref as stkmonrowid,a.SMT_SMR_Parref->SMR_SM_Parref->DHCSM_CTLOC_DR as payLocId, a.SMT_SMR_Parref->SMR_INCI_DR->INCI_INCSC_DR as INCI_INCSC_DR, "
			 _" a.SMT_SMR_Parref->SMR_SM_Parref->DHCSM_CTLOC_DR->CTLOC_Code as fCTLOC_Code, "
			 _" -sum(SMT_CostAmount) as je,SMT_RelaLoc_DR->CTLOC_Code as tCTLOC_Code,a.SMT_SMR_Parref->SMR_SM_Parref->DHCSM_FromDate as DHCSM_Month"
 			 _" from DHC_StkMonTrans a,DHC_StkCatGrpRelations b "
			 _" where a.SMT_SMR_Parref->SMR_INCI_DR->INCI_INCSC_DR=b.SCGR_StkCat_DR "
			 _" and a.SMT_SMR_Parref->SMR_SM_Parref->DHCSM_FromDate between "_"'"_frdate_"'"_" and "_"'"_todate_"'"_" and a.SMT_OperateType=12 "
			 _" group by a.SMT_SMR_Parref->SMR_INCI_DR->INCI_INCSC_DR,a.SMT_SMR_Parref->SMR_SM_Parref->DHCSM_CTLOC_DR->CTLOC_Code, "
			 _" SMT_RelaLoc_DR->CTLOC_Code,a.SMT_SMR_Parref->SMR_SM_Parref->DHCSM_Month "		
	   K ^cwtemp
	   s ^cwtemp=sqlStr1
	   
	
	
						
	;CTLOC_Dep_DR=40 不统计二级库请领

	s result1=##class(%Library.ResultSet).%New()
	d result1.Prepare(sqlStr1)
	d result1.Execute()
    s i=0
    
	while(result1.Next())
	{  
		s stkmonrowid=result1.Data("stkmonrowid")
		
		s fCTLOCCode=result1.Data("fCTLOC_Code")
		&SQL(select CTLOC_Desc into :fLOCDesc from SQLUSER.CT_Loc where CTLOC_Code=:fCTLOCCode)
		s fCTLOCDesc=$p(fLOCDesc,"-",2)
		s tCTLOCCode=result1.Data("tCTLOC_Code")
		&SQL(select CTLOC_Desc into :tCTLOCDesc1 from SQLUSER.CT_Loc where CTLOC_Code=:tCTLOCCode)
        s payLocId=result1.Data("payLocId")
		s tCTLOCDesc=""
		i $P(tCTLOCDesc1,"-",2)'="" s tCTLOCDesc=$P(tCTLOCDesc1,"-",2)
		e  s tCTLOCDesc=$P(tCTLOCDesc1,"-",1)
		s je=result1.Data("je")		
		s INTRDate=$ZD(result1.Data("DHCSM_Month"),3)
		s TypeDr= result1.Data("INCI_INCSC_DR") 
		s TypeDesc=""
		s INCSCCode=""
		s INCSCDesc=""  
		i TypeDr'="" d
		.s TypeDesc=##Class(web.DHCST.Common.DrugInfoCommon).StkCatGrpStr(TypeDr)
		i TypeDesc'="" d
		.s INCSCDesc=$p(TypeDesc,"^",2)
		.s INCSCCode=$p(TypeDesc,"^",1)
		.s scgname=$p(TypeDesc,"^",4)
		.s scgid=$p(TypeDesc,"^",5)
		.s tStkGrpId=scgid
		
		i (payLocId=569)&(scgname'="专用低值品耗材") d
        .s tStkGrpId="999"
        
        s tmpzero="00000"
        s len=5-$l(stkmonrowid)
        s upstring=$e(tmpzero,1,len)
        s rprowid=upstring_stkmonrowid
        s zero="0000"
        s tmplen=4-$l(tStkGrpId)
        s downstring=$e(zero,1,tmplen)
        s scgrowid=downstring_tStkGrpId 
        s onlyrowid=rprowid_scgrowid
        
		
		i (payLocId=569)&(scgname'="专用低值品耗材") d
		.s INCSCDesc="卫生材料"
		.s INCSCCode="CL999"
		//s year=$P(INTRDate,"-",1)
		//s month=$P(INTRDate,"-",2)
		s i=i+1
		//s storename=fCTLOCCode_":"_fCTLOCDesc
		s storename=tCTLOCCode_":"_tCTLOCDesc
		s INCame=INCSCCode_":"_INCSCDesc
		
		
		s ^herpcwtemp("Dura02",storename,INCame)=$g(^herpcwtemp("Dura02",storename,INCame))+je
		
		
		
	   
	}
   
	d result1.Close()
		s DataFrom=1
		//s sDate= $ZD($h,3)_" "_$ZT($P($h,",",2),3)
		s storename="" 
		f  s storename=$O(^herpcwtemp("Dura02",storename)) q:storename=""  d
	
		.s INCame=""  f  s INCame=$O(^herpcwtemp("Dura02",storename,INCame)) q:INCame=""  d
		
		..s je=$g(^herpcwtemp("Dura02",storename,INCame)) 
		..s deptcode=$p(storename,":",1)
		..s deptname=$p(storename,":",2)
		..s ItemCode=$p(INCame,":",1)
		..s ItemName=$p(INCame,":",2)
	    ..s date=$zd($h,3)
	    ..s date=$zdh(date,3)
	
		..&SQL(insert into dhc_bonus_module.BonusExpendCollect(DeptCode,DeptName,BonusYear,
		BonusPeriod,ItemCode,ItemName,ItemValue,CollectDate,Operator,state,Methord,IsValue
	) values(:deptcode,:deptname,:year,:period,:ItemCode,:ItemName,:je,:date,:user,0,1,"Y"))
	  
	q 0
}

/*
ClassMethod GetBonusDura(start, end, user) As %String
{
	n (start,end,user)
	
	s Year=$p(start,"-",1)
	s sMonth="M" _ $p(start,"-",2)
		
	zn "dhc-data"
	
	d GetOutECKFData^DHCSTINTERFACEEC(start,end,$LB(73,471,537)) //---73,471,537,----73 物资供应，198 器械材料库,85 药库 471-化学试剂库,537--XSYPK-消杀药品--517 
	d GetOutECSBKFData^DHCSTINTERFACEEC(start,end,$LB(198,188)) //198 设备器械材料库,85 药库 471-化学试剂库,537--XSYPK-消杀药品--188 消毒供应室
	
	zn "dhc-app"
	
	k ^tempBonusDura
 	s num=""
 	f  s num=$o(^TMP("DHCST","DHCSTINTERFACEEC","ECC1",$j,num))  q:num=""  d
 	.s itemCode=$p($g(^TMP("DHCST","DHCSTINTERFACEEC","ECC1",$j,num)),"^",2)
 	.s itemName=$p($g(^TMP("DHCST","DHCSTINTERFACEEC","ECC1",$j,num)),"^",3)
 	.s unitCode=$p($g(^TMP("DHCST","DHCSTINTERFACEEC","ECC1",$j,num)),"^",6)
 	.s unitCode="H"_ $e(unitCode,4,$l(unitCode))
 	.s unitName=$p($g(^TMP("DHCST","DHCSTINTERFACEEC","ECC1",$j,num)),"^",7)
 	.s money=$p($g(^TMP("DHCST","DHCSTINTERFACEEC","ECC1",$j,num)),"^",5)
 	.s ^tempBonusDura($j,unitCode,unitName,itemCode,itemName)=$g(^tempBonusDura($j,unitCode,itemCode))+money
 	
 	s num=""
 	f  s num=$o(^TMP("DHCST","DHCSTINTERFACEEC","ECC2",$j,num))  q:num=""  d
 	.s itemCode=$p($g(^TMP("DHCST","DHCSTINTERFACEEC","ECC2",$j,num)),"^",2)
 	.s itemName=$p($g(^TMP("DHCST","DHCSTINTERFACEEC","ECC2",$j,num)),"^",3)
 	.s unitCode=$p($g(^TMP("DHCST","DHCSTINTERFACEEC","ECC2",$j,num)),"^",6)
 	.s unitCode="H"_ $e(unitCode,4,$l(unitCode))
 	.s unitName=$p($g(^TMP("DHCST","DHCSTINTERFACEEC","ECC2",$j,num)),"^",7)
 	.s money=$p($g(^TMP("DHCST","DHCSTINTERFACEEC","ECC2",$j,num)),"^",5)
 	.s ^tempBonusDura($j,unitCode,unitName,itemCode,itemName)=$g(^tempBonusDura($j,unitCode,itemCode))+money
 	
 	&sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:Year and BonusPeriod=:sMonth and InterLocMethodID=:MethodDr)
 	s unitCode=""
 	f  s unitCode=$o(^tempBonusDura($j,unitCode))  q:unitCode=""  d
	.s unitName=""
 	.f  s unitName=$o(^tempBonusDura($j,unitCode,unitName))  q:unitName=""  d
 	..s itemCode=""
 	..f  s itemCode=$o(^tempBonusDura($j,unitCode,unitName,itemCode))  q:itemCode=""  d
 	...s itemName=""
 	...f  s itemName=$o(^tempBonusDura($j,unitCode,unitName,itemCode,itemName))  q:itemName=""  d
 	....s je=$G(^tempBonusDura($j,unitCode,unitName,itemCode,itemName))
 	....&sql(insert into dhc_bonus_module.BonusExpendCollect(ItemCode,ItemName, DeptCode,DeptName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,Operator)
 		values(:itemCode,:itemName,:unitCode,:unitName,:Year, :sMonth,:je,getdate(), 0,:user)		)

 	k ^tempBonusDura($j)
	q 0
}
*/
Storage Default
{
<StreamLocation>^dhc.bonus.umo866B.uGetDuraDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
