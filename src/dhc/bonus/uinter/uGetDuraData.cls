/// 采集科室成本_物资
/// Zhao LiGuo
/// 2015-1-8
Class dhc.bonus.uinter.uGetDuraData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：zhaoliguo
/// CreatDate：2015-1-8
/// Description:  调用成本核算系统的物资材料成本
/// Table：
/// Input：start-起始日期,end-终止日期
/// Output：
/// Return：///73 物资供应，198 器械材料库,85 药库
/// Others：d ##class(dhc.bonus.uinter.uGetDuraData).GetBonusDura("2014-03-1","2014-03-31",13)
ClassMethod GetBonusDura(start, end, MethodDr) As %String
{
	n (start,end,MethodDr)
	
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
 	....&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID,ExecuteDeptName)
 		values(:itemCode,:itemName,:unitCode,:unitName,:Year, :sMonth,:je,getdate(), 0,0,:MethodDr,"YFSR")		)

 	k ^tempBonusDura($j)
	q 0
}

Storage Default
{
<StreamLocation>^dhc.bonus.uinter.uGetDuraDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
