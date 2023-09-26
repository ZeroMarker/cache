/// Creator: 李明忠
/// CreatDate: 2011-6-23
/// Description: 收入数据分解业务类
Class dhc.bonus.usubs.uIncomeDataAssignment Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2011-6-24
/// Description: 获取年度
/// Table：
/// Input：cycleDr:核算年度
/// Output：
/// Return：核算年度代码
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).GetCycle(1)
ClassMethod GetCycle(cycleDr) As %String
{
	n (cycleDr)
	
	s YearCode=""
	s sqlStr="select BonusYear from dhc_bonus_data.SchemePeriod where SchemePeriodID="_cycleDr	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s YearCode = result.Data("BonusYear")
	}
		
	d result.Close()
	q YearCode
}

/// Creator：李明忠
/// CreatDate：2011-6-24
/// Description: 获取辅助项目的ID
/// Table：
/// Input：itemCode:辅助项目code
/// Output：
/// Return：辅助项目的ID
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).GetFZItemId("001")
ClassMethod GetFZItemId(itemCode) As %String
{
	n (itemCode)
	
	s itemDr=0
	i $D(^dhcbsSubItemI("SubsItemCode",itemCode)) d
	.s rowid=0
	.s rowid=$O(^dhcbsSubItemI("SubsItemCode",itemCode,rowid))
	.i rowid="" s itemDr=0
	.e  s itemDr=rowid
	
	q itemDr
}

/// Creator：李明忠
/// CreatDate：2011-6-28
/// Description: 获取科室的ID
/// Table：
/// Input：deptCode:科室code
/// Output：
/// Return：科室的ID
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).GetDeptId("001")
ClassMethod GetDeptId(deptCode) As %String
{
	n (deptCode)
	
	s rowid=0
	s sqlStr="select InterLoc_jxUnitDr from dhc_bonus_inter.InterLoc where InterLoc_rowid>0 and InterLoc_code='"_deptCode_"'"	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s rowid = result.Data("InterLoc_jxUnitDr")
	}
		
	d result.Close()
	
	q rowid
}

/// Creator：李明忠
/// CreatDate：2011-6-28
/// Description: 获取医生的ID
/// Table：
/// Input：doctorCode:医生code
/// Output：
/// Return：医生的ID
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).GetDoctorId("001")
ClassMethod GetDoctorId(doctorCode) As %String
{
	n (doctorCode)
	
	s rowid=0
	s sqlStr="select InterLoc_jxUnitDr from dhc_bonus_inter.InterLoc where InterLoc_rowid>0 and InterLoc_code='"_doctorCode_"'"	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s rowid = result.Data("InterLoc_jxUnitDr")
	}
		
	d result.Close()
	
	q rowid
}

/// Creator：李明忠
/// CreatDate：2011-6-29
/// Description: 获取名称
/// Table：
/// Input：Id:ID
/// Output：
/// Return：名称
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).GetNameById(1)
ClassMethod GetNameById(Id) As %String
{
	n (Id)
	
	s name=""
	s sqlStr="select BonusUnitName from dhc_bonus_data.BonusUnit where BonusUnitID="_Id	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s name = result.Data("BonusUnitName")
	}
		
	d result.Close()
	
	q name
}

/// Creator：李明忠
/// CreatDate：2011-6-27
/// Description: 生成科室ID字符串
/// Table：
/// Input：deptGroupDr:科室组ID
/// Output：
/// Return：返回科室ID字符串(1^2^3)
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).GetDeptOfDeptGroup("19")
ClassMethod GetDeptOfDeptGroup(deptGroupDr) As %String
{
	n (deptGroupDr)
	
	s unitDrStr=""
	
	i $D(^dhcbsSubDeptGroupMapI("Parent",deptGroupDr)) d
	.s unitDr=0
	.f  s unitDr=$O(^dhcbsSubDeptGroupMapI("Parent",deptGroupDr,unitDr)) q:unitDr=""  d
	..i unitDrStr="" s unitDrStr=unitDr
	..e  s unitDrStr=unitDrStr_"^"_unitDr
	
	q unitDrStr
}

/// Creator：李明忠
/// CreatDate：2011-6-27
/// Description: 生成医生ID字符串
/// Table：
/// Input：doctorGroupDr:医生组ID
/// Output：
/// Return：返回医生ID字符串(1^2^3)
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).GetDoctorOfDoctorGroup("G1")
ClassMethod GetDoctorOfDoctorGroup(doctorGroupDr) As %String
{
	n (doctorGroupDr)
	w "doctorGroupDr:"_doctorGroupDr,!
	s doctorDrStr=""
	i $D(^dhcbsSubDoctorGroupMapI("Parent",doctorGroupDr)) d
	.s doctorDr=0
	.f  s doctorDr=$O(^dhcbsSubDoctorGroupMapI("Parent",doctorGroupDr,doctorDr)) q:doctorDr=""  d
	..i doctorDrStr="" s doctorDrStr=doctorDr
	..e  s doctorDrStr=doctorDrStr_"^"_doctorDr
	
	q doctorDrStr
}

/// Creator：李明忠
/// CreatDate：2011-6-30
/// Description: 生成项目ID字符串
/// Table：
/// Input：itemGroupId:项目组ID
/// Output：
/// Return：返回项目ID字符串(1^2^3)
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).GetItemOfItemGroup("G3")
ClassMethod GetItemOfItemGroup(itemGroupId) As %String
{
	n (itemGroupId)
	
	s itemDrStr=""
	s itemChar=$E(itemGroupId,1)
	s itemGroupDr=$E(itemGroupId,2,$L(itemGroupId))
	i itemChar="D" d
	.s itemDrStr=itemGroupDr
	e  d
	.i $D(^dhcbsSubItemGroupMapI("Parent",itemGroupDr)) d
	..s itemDr=0
	..f  s itemDr=$O(^dhcbsSubItemGroupMapI("Parent",itemGroupDr,itemDr)) q:itemDr=""  d
	...i itemDrStr="" s itemDrStr=itemDr
	...e  s itemDrStr=itemDrStr_"^"_itemDr
	
	q itemDrStr
}

/// Creator：李明忠
/// CreatDate：2011-6-30
/// Description: 将辅助项目转换成奖金指标项目
/// Table：
/// Input：OrigItemDr:辅助项目ID
/// Output：
/// Return：返回奖金指标项目ID
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).TransItem(5)
ClassMethod TransItem(OrigItemDr) As %String
{
	
	n (OrigItemDr)
	
	s newItemDr=""
	i $D(^dhcbsSubTargetFilterI("TargetSubItem",OrigItemDr)) d
	.s subItemDr=""
	.f  s subItemDr=$O(^dhcbsSubTargetFilterI("TargetSubItem",OrigItemDr,subItemDr)) q:subItemDr=""  d
	..i subItemDr'="" d
	...s newItemDr=newItemDr_"^"_subItemDr
	
	q newItemDr
}

/// Creator：zhaoliguo
/// CreatDate：2011-9-2
/// Description: 获取名称
/// Table：
/// Input：Id:ID
/// Output：
/// Return：名称
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).GetTargetBySubItem(5,3,1,1)
ClassMethod GetTargetBySubItem(SubItemID, UnitFlag, SickFlag, ExpensesFlag) As %String
{
	n (SubItemID,UnitFlag,SickFlag,ExpensesFlag)
	
	s name=""

	s sqlStr="SELECT distinct a.BonusTargetID FROM dhc_bonus_subs.BonusSubTargetFilter a,dhc_bonus_subs.BonusSubSickFliter b,dhc_bonus_subs.BonusSubUnitFliter c,dhc_bonus_subs.BonusSubExpensesFliter d"
	_" where a.BonusTargetID = b.BonusTargetID and a.BonusTargetID = c.BonusTargetID and a.BonusTargetID = d.BonusTargetID"
	_" and a.BonusSubItemID="_SubItemID
	
	i UnitFlag'=0 d
	.d  s sqlStr=sqlStr _ "and c.BonusUnitFlagCode='"_UnitFlag_"'"
	i SickFlag'=0 d
	.d  s sqlStr=sqlStr _" and b.SickFlagCode='"_SickFlag_"'"
	i ExpensesFlag'=0 d
	.d  s sqlStr=sqlStr _"	 and d.ExpensesFlagCode='"_ExpensesFlag_"'"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s name =name_"^"_ result.Data("BonusTargetID")
	}
		
	d result.Close()
	
	q name
}

/// Creator：zhao li guo 
/// CreatDate：2011-7-1
/// Description: 生成临时Global
/// Table：
/// Input：YearCode:核算年度代码;newPeriod:组合期间(如:"M01")
/// Output：
/// Return：
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).SetSubIncomeRateGlobal("3")
/// 	s IncomeDataAssignment = ##class(dhc.bonus.usubs.uIncomeDataAssignment).%New()
ClassMethod SetSubIncomeRateGlobal(SubIncomeRateID) As %String
{
	n (SubIncomeRateID)
	i SubIncomeRateID'="" d
	.s num = SubIncomeRateID
	k ^dhcbsSubIncomeRateAll(num)

	s BonusSubItemID = $LIST(^dhcbsSubIncomeRateD(num),2)
	s MakeBillDept = $LIST(^dhcbsSubIncomeRateD(num),3)
	s ExecuteDept = $LIST(^dhcbsSubIncomeRateD(num),4)
	s SickDept = $LIST(^dhcbsSubIncomeRateD(num),5)
	s ChiefDoctor = $LIST(^dhcbsSubIncomeRateD(num),6)
	s MakeBillDoctor = $LIST(^dhcbsSubIncomeRateD(num),7)
	s ExecuteDoctor = $LIST(^dhcbsSubIncomeRateD(num),8)
	s SubItemName = $LIST(^dhcbsSubIncomeRateD(num),9)
	s ExpensesType = $LIST(^dhcbsSubIncomeRateD(num),10)
	s SickType = $LIST(^dhcbsSubIncomeRateD(num),11)
	s MakeBillDeptRate = $LIST(^dhcbsSubIncomeRateD(num),12)
	s ExecuteDeptRate = $LIST(^dhcbsSubIncomeRateD(num),13)
	s SickDeptRate = $LIST(^dhcbsSubIncomeRateD(num),14)

	i MakeBillDept="0" d
	.s MakeBillDeptDr ="0"
	e  d
	.i $E(MakeBillDept,1,1)="D" d
	..s MakeBillDeptDr=  $E(MakeBillDept,2,$L(MakeBillDept))
	.e  d
	..s MakeBillDeptDr = ..GetDeptOfDeptGroup($E(MakeBillDept,2,$L(MakeBillDept)))
	
	i ExecuteDept="0" d
	.s ExecuteDeptDr="0"
	e  d
	.i $E(ExecuteDept,1,1)="D" d
	..s ExecuteDeptDr=  $E(ExecuteDept,2,$L(ExecuteDept))
	.e  d
	..s ExecuteDeptDr = ..GetDeptOfDeptGroup($E(ExecuteDept,2,$L(ExecuteDept)))
	
	i SickDept="0" d
	.s SickDeptDr = "0"
	e  d
	.i $E(SickDept,1,1)="D" d
	..s SickDeptDr=  $E(SickDept,2,$L(SickDept))
	.e  d
	..s SickDeptDr = ..GetDeptOfDeptGroup($E(SickDept,2,$L(SickDept)))

	i ChiefDoctor = "0" d
	.s ChiefDoctorDr = "0"
	e  d
	.i $E(ChiefDoctor,1,1)="D" d
	..s ChiefDoctorDr=  $E(ChiefDoctor,2,$L(ChiefDoctor))
	.e  d
	..s ChiefDoctorDr = ..GetDoctorOfDoctorGroup($E(ChiefDoctor,2,$L(ChiefDoctor)))
	
	i MakeBillDoctor = "0" d
	.s MakeDoctorDr = "0"	
	e  d
	.i $E(MakeBillDoctor,1,1)="D" d
	..s MakeDoctorDr=  $E(MakeBillDoctor,2,$L(MakeBillDoctor))
	.e  d
	..s MakeDoctorDr = ..GetDoctorOfDoctorGroup($E(MakeBillDoctor,2,$L(MakeBillDoctor)))
	
	i ExecuteDoctor= "0" d
	.s ExecuteDoctorDr = "0"	
	e  d
	.i $E(ExecuteDoctor,1,1)="D" d
	..s ExecuteDoctorDr=  $E(ExecuteDoctor,2,$L(ExecuteDoctor))
	.e  d
	..s ExecuteDoctorDr = ..GetDoctorOfDoctorGroup($E(ExecuteDoctor,2,$L(ExecuteDoctor)))
		
							
	s makeBillLen= $L(MakeBillDeptDr,"^")
	s ExecuteDeptLen= $L(ExecuteDeptDr,"^")
	s SickDeplLen= $L(SickDeptDr,"^")
	
	s ChiefDoctorLen= $L(ChiefDoctorDr,"^")
	s MakeDoctorLen= $L(MakeDoctorDr,"^")
	s ExecuteDoctorLen= $L(ExecuteDoctorDr,"^")
		
	s itemGroups = ..GetItemOfItemGroup(BonusSubItemID)
	s itemDrLen=$L(itemGroups,"^")

	f n=1:1:itemDrLen d
	.s itemDr=$P(itemGroups,"^",n)
	.f i=1:1:makeBillLen d
	..s makeDr = $P(MakeBillDeptDr,"^",i)
	..f k=1:1:ExecuteDeptLen d
	...s ExecuteDr = $P(ExecuteDeptDr,"^",k)	
	...f m=1:1:SickDeplLen d
	....s SickDr = $P(SickDeptDr,"^",m)	
	....f h=1:1:ChiefDoctorLen d
	.....s ChiefDoctorDr1 = $P(ChiefDoctorDr,"^",h)
	.....f h=1:1:MakeDoctorLen d
	......s MakeDoctorDr1 = $P(MakeDoctorDr,"^",h)
	......f h=1:1:ExecuteDoctorLen d
	.......s ExecuteDoctorDr1 = $P(ExecuteDoctorDr,"^",h)	
	.......s ^dhcbsSubIncomeRateAll(num,"MakeBill",itemDr,makeDr,ExecuteDr,SickDr,ChiefDoctorDr1,MakeDoctorDr1,ExecuteDoctorDr1,ExpensesType,SickType) = MakeBillDeptRate
	.......s ^dhcbsSubIncomeRateAll(num,"ExecuteDept",itemDr,makeDr,ExecuteDr,SickDr,ChiefDoctorDr1,MakeDoctorDr1,ExecuteDoctorDr1,ExpensesType,SickType) = ExecuteDeptRate
	.......s ^dhcbsSubIncomeRateAll(num,"SickDept",itemDr,makeDr,ExecuteDr,SickDr,ChiefDoctorDr1,MakeDoctorDr1,ExecuteDoctorDr1,ExpensesType,SickType) = SickDeptRate
	
	q 0
}

/// Creator：李明忠
/// CreatDate：2011-6-28
/// Description: 生成临时Global----业务调换
/// Table：
/// Input：YearCode:核算年度代码;newPeriod:组合期间(如:"M01")
/// Output：
/// Return：
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).SetTmpGlobal("2011","M03")
ClassMethod SetTmpGlobal(YearCode, newPeriod) As %String
{
	n (YearCode,newPeriod)
	
	k ^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome","makebill",$j,YearCode,newPeriod)
	k ^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome","execute",$j,YearCode,newPeriod)
	k ^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome","sick",$j,YearCode,newPeriod)
	
	//1.开单科室(组)和开单医生(组)
	i $D(^dhcbsSubIncomeRateI("MakeBill")) d
	.;w 222,!
	.s itemId=0
	.f  s itemId=$O(^dhcbsSubIncomeRateI("MakeBill",itemId)) q:itemId=""  d
	..s itemDrStr=..GetItemOfItemGroup(itemId)
	..;w itemDrStr,!
	..s sickType=""
	..f  s sickType=$O(^dhcbsSubIncomeRateI("MakeBill",itemId,sickType)) q:sickType=""  d
	...;w itemDrStr_"^"_sickType,!
	...s feeType=""
	...f  s feeType=$O(^dhcbsSubIncomeRateI("MakeBill",itemId,sickType,feeType)) q:feeType=""  d
	....;w itemDrStr_"^"_sickType_"^"_feeType,!
	....s makeBillDeptRowid=0
	....f  s makeBillDeptRowid=$O(^dhcbsSubIncomeRateI("MakeBill",itemId,sickType,feeType,makeBillDeptRowid)) q:makeBillDeptRowid=""  d
	.....;w itemDrStr_"^"_sickType_"^"_feeType_"^"_makeBillDeptRowid,!
	.....s deptChar=$E(makeBillDeptRowid,1)
	.....s unitDrStr=""
	.....i deptChar="G" d //该记录是科室组
	......s unitDrStr=..GetDeptOfDeptGroup($E(makeBillDeptRowid,2,$L(makeBillDeptRowid)))
	.....e  d
	......s unitDrStr=$E(makeBillDeptRowid,2,$L(makeBillDeptRowid))
	.....;w unitDrStr,!
	.....s makeBillDoctorRowid=0
	.....f  s makeBillDoctorRowid=$O(^dhcbsSubIncomeRateI("MakeBill",itemId,sickType,feeType,makeBillDeptRowid,makeBillDoctorRowid)) q:makeBillDoctorRowid=""  d
	......;w makeBillDoctorRowid,!
	......s doctorChar=$E(makeBillDoctorRowid,1)
	......s doctorDrStr=""
	......i doctorChar="G" d //该记录是医生组
	.......s doctorDrStr=..GetDoctorOfDoctorGroup($E(makeBillDoctorRowid,2,$L(makeBillDoctorRowid)))
	......e  d
	.......s doctorDrStr=$E(makeBillDoctorRowid,2,$L(makeBillDoctorRowid))
	......s rate=0
	......s rate=$O(^dhcbsSubIncomeRateI("MakeBill",itemId,sickType,feeType,makeBillDeptRowid,makeBillDoctorRowid,rate))
	......i rate="" s rate=1
	......i (itemDrStr'="") && (unitDrStr'="") && (doctorDrStr'="") d
	.......;w itemDrStr_"^"_unitDrStr_"^"_doctorDrStr,!
	.......s itemDrLen=$L(itemDrStr,"^")
	.......s unitDrLen=$L(unitDrStr,"^")
	.......s doctorDrLen=$L(doctorDrStr,"^")
	.......f n=1:1:itemDrLen d
	........s itemDr=$P(itemDrStr,"^",n)
	........s newItemDr=..TransItem(itemDr)
	........;w newItemDr,!
	........i newItemDr'="" d
	.........f i=1:1:unitDrLen d
	..........s unitDr=$P(unitDrStr,"^",i)
	..........f k=1:1:doctorDrLen d
	...........s doctorDr=$P(doctorDrStr,"^",k)
	...........s ^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome","makebill",$j,YearCode,newPeriod,newItemDr,sickType,feeType,unitDr,doctorDr)=rate
	
	//2.执行科室(组)和执行医生(组)
	i $D(^dhcbsSubIncomeRateI("Execute")) d
	.s itemId=0
	.f  s itemId=$O(^dhcbsSubIncomeRateI("Execute",itemId)) q:itemId=""  d
	..s itemDrStr=..GetItemOfItemGroup(itemId)
	..s sickType=""
	..f  s sickType=$O(^dhcbsSubIncomeRateI("Execute",itemId,sickType)) q:sickType=""  d
	...s feeType=""
	...f  s feeType=$O(^dhcbsSubIncomeRateI("Execute",itemId,sickType,feeType)) q:feeType=""  d
	....s executeDeptRowid=0
	....f  s executeDeptRowid=$O(^dhcbsSubIncomeRateI("Execute",itemId,sickType,feeType,executeDeptRowid)) q:executeDeptRowid=""  d
	.....s deptChar=$E(executeDeptRowid,1)
	.....s unitDrStr=""
	.....i deptChar="G" d //该记录是科室组
	......s unitDrStr=..GetDeptOfDeptGroup($E(executeDeptRowid,2,$L(executeDeptRowid)))
	.....e  d
	......s unitDrStr=$E(executeDeptRowid,2,$L(executeDeptRowid))
	.....s executeDoctorRowid=0
	.....f  s executeDoctorRowid=$O(^dhcbsSubIncomeRateI("Execute",itemId,sickType,feeType,executeDeptRowid,executeDoctorRowid)) q:executeDoctorRowid=""  d
	......s doctorChar=$E(executeDoctorRowid,1)
	......s doctorDrStr=""
	......i doctorChar="G" d //该记录是医生组
	.......s doctorDrStr=..GetDoctorOfDoctorGroup($E(executeDoctorRowid,2,$L(executeDoctorRowid)))
	......e  d
	.......s doctorDrStr=$E(executeDoctorRowid,2,$L(executeDoctorRowid))
	......s rate=0
	......s rate=$O(^dhcbsSubIncomeRateI("Execute",itemId,sickType,feeType,executeDeptRowid,executeDoctorRowid,rate))
	......i rate="" s rate=1
	......i (itemDrStr'="") && (unitDrStr'="") && (doctorDrStr'="") d
	.......s itemDrLen=$L(itemDrStr,"^")
	.......s unitDrLen=$L(unitDrStr,"^")
	.......s doctorDrLen=$L(doctorDrStr,"^")
	.......f n=1:1:itemDrLen d
	........s itemDr=$P(itemDrStr,"^",n)
	........s newItemDr=..TransItem(itemDr)
	........i newItemDr'="" d
	.........f i=1:1:unitDrLen d
	..........s unitDr=$P(unitDrStr,"^",i)
	..........f k=1:1:doctorDrLen d
	...........s doctorDr=$P(doctorDrStr,"^",k)
	...........s ^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome","execute",$j,YearCode,newPeriod,newItemDr,sickType,feeType,unitDr,doctorDr)=rate
	
	//3.病人科室(组)和主任医生(组)
	i $D(^dhcbsSubIncomeRateI("Sick")) d
	.s itemId=0
	.f  s itemId=$O(^dhcbsSubIncomeRateI("Sick",itemId)) q:itemId=""  d
	..s itemDrStr=..GetItemOfItemGroup(itemId)
	..s sickType=""
	..f  s sickType=$O(^dhcbsSubIncomeRateI("Sick",itemId,sickType)) q:sickType=""  d
	...s feeType=""
	...f  s feeType=$O(^dhcbsSubIncomeRateI("Sick",itemId,sickType,feeType)) q:feeType=""  d
	....s sickDeptRowid=0
	....f  s sickDeptRowid=$O(^dhcbsSubIncomeRateI("Sick",itemId,sickType,feeType,sickDeptRowid)) q:sickDeptRowid=""  d
	.....s deptChar=$E(sickDeptRowid,1)
	.....s unitDrStr=""
	.....i deptChar="G" d //该记录是科室组
	......s unitDrStr=..GetDeptOfDeptGroup($E(sickDeptRowid,2,$L(sickDeptRowid)))
	.....e  d
	......s unitDrStr=$E(sickDeptRowid,2,$L(sickDeptRowid))
	.....s sickDoctorRowid=0
	.....f  s sickDoctorRowid=$O(^dhcbsSubIncomeRateI("Sick",itemId,sickType,feeType,sickDeptRowid,sickDoctorRowid)) q:sickDoctorRowid=""  d
	......w sickDoctorRowid,!
	......s doctorChar=$E(sickDoctorRowid,1)
	......s doctorDrStr=""
	......i doctorChar="G" d //该记录是医生组
	.......s doctorDrStr=..GetDoctorOfDoctorGroup($E(sickDoctorRowid,2,$L(sickDoctorRowid)))
	......e  d
	.......s doctorDrStr=$E(sickDoctorRowid,2,$L(sickDoctorRowid))
	......s rate=0
	......s rate=$O(^dhcbsSubIncomeRateI("Sick",itemId,sickType,feeType,sickDeptRowid,sickDoctorRowid,rate))
	......i rate="" s rate=1
	......i (itemDrStr'="") && (unitDrStr'="") && (doctorDrStr'="") d
	.......w itemDrStr_"^"_itemDrStr_"^"_doctorDrStr,!
	.......s itemDrLen=$L(itemDrStr,"^")
	.......s unitDrLen=$L(unitDrStr,"^")
	.......s doctorDrLen=$L(doctorDrStr,"^")
	.......f n=1:1:itemDrLen d
	........s itemDr=$P(itemDrStr,"^",n)
	........s newItemDr=..TransItem(itemDr)
	........i newItemDr'="" d
	.........f i=1:1:unitDrLen d
	..........s unitDr=$P(unitDrStr,"^",i)
	..........f k=1:1:doctorDrLen d
	...........s doctorDr=$P(doctorDrStr,"^",k)
	...........s ^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome","sick",$j,YearCode,newPeriod,newItemDr,sickType,feeType,unitDr,doctorDr)=rate
}

/// Creator：李明忠
/// CreatDate：2011-6-28
/// Description: 计算科室的比例金额(即:总金额*所占比)
/// Table：
/// Input：itemId:辅助项目,kdDeptId:开单科室,zxDeptId:执行科室,brDeptId:病人科室,zzDoctorId:主治医生,kdDoctorId:开单医生,zxDoctorId:执行医生,sickType:病人类别,feeType:费用类别,deptTypeName:科室类别,incomeFee:总金额
/// Output：
/// Return：返回科室的比例金额
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).Calculate(9,0,102,0,0,0,0,0,0,"MakeBill",0)
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).Calculate(9,0,102,0,0,0,0,0,0,"ExecuteDept",0)
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).Calculate(9,0,102,0,0,0,0,0,0,"SickDept",0)
ClassMethod Calculate(itemId, kdDeptId, zxDeptId, brDeptId, zzDoctorId, kdDoctorId, zxDoctorId, feeType, brType, deptTypeName, incomeFee) As %String
{
	n (itemId,kdDeptId,zxDeptId,brDeptId,zzDoctorId,kdDoctorId,zxDoctorId,feeType,brType,deptTypeName,incomeFee)
	
	s rateFee=0,rate=0
	s feeInfo=rateFee_"^"_rate
	
	s num=0
	f  s num=$O(^dhcbsSubIncomeRateAll(num)) q:num=""  d
	.s deptType=""
	.f  s deptType=$O(^dhcbsSubIncomeRateAll(num,deptType)) q:deptType=""  d
	..;w deptType_":"_deptTypeName,!
	..i deptType=deptTypeName d
	...s itemDr=""
	...f  s itemDr=$O(^dhcbsSubIncomeRateAll(num,deptType,itemDr)) q:itemDr=""  d
	....i (itemDr=itemId) || (itemId =0) d
	.....;w deptType_"^"_itemDr,!
	.....s makeDr=""
	.....f  s makeDr=$O(^dhcbsSubIncomeRateAll(num,deptType,itemDr,makeDr)) q:makeDr=""  d
	......;w deptType_"^"_itemDr_"^"_makeDr,!
	......i (makeDr=kdDeptId) || (makeDr =0) d
	.......s ExecuteDr=""
	.......f  s ExecuteDr=$O(^dhcbsSubIncomeRateAll(num,deptType,itemDr,makeDr,ExecuteDr)) q:ExecuteDr=""  d
	........i (ExecuteDr=zxDeptId) || (ExecuteDr=0)  d
	.........;w deptType_"^"_itemDr_"^"_makeDr_"^"_ExecuteDr,!
	.........s SickDr=""
	.........f  s SickDr=$O(^dhcbsSubIncomeRateAll(num,deptType,itemDr,makeDr,ExecuteDr,SickDr)) q:SickDr=""  d
	..........i (SickDr=brDeptId) || (SickDr =0) d
	...........;w deptType_"^"_itemDr_"^"_makeDr_"^"_ExecuteDr_"^"_SickDr,!
	
	...........s ChiefDoctorDr=""
	...........f  s ChiefDoctorDr=$O(^dhcbsSubIncomeRateAll(num,deptType,itemDr,makeDr,ExecuteDr,SickDr,ChiefDoctorDr)) q:ChiefDoctorDr=""  d
	............i (ChiefDoctorDr=zzDoctorId) || (ChiefDoctorDr =0 ) d
	.............;w deptType_"^"_itemDr_"^"_makeDr_"^"_ExecuteDr_"^"_SickDr_"^"_ChiefDoctorDr,!
	.............s MakeDoctorDr=""
	.............f  s MakeDoctorDr=$O(^dhcbsSubIncomeRateAll(num,deptType,itemDr,makeDr,ExecuteDr,SickDr,ChiefDoctorDr,MakeDoctorDr)) q:MakeDoctorDr=""  d
	..............i (MakeDoctorDr=kdDoctorId) || (MakeDoctorDr=0)  d
	...............;w deptType_"^"_itemDr_"^"_makeDr_"^"_ExecuteDr_"^"_SickDr_"^"_ChiefDoctorDr_"^"_MakeDoctorDr,!
	...............s ExecuteDoctorDr=""
	...............f  s ExecuteDoctorDr=$O(^dhcbsSubIncomeRateAll(num,deptType,itemDr,makeDr,ExecuteDr,SickDr,ChiefDoctorDr,MakeDoctorDr,ExecuteDoctorDr)) q:ExecuteDoctorDr=""  d
	................;w ExecuteDoctorDr_"^"_66,!
	................i (ExecuteDoctorDr=zxDoctorId) || (ExecuteDoctorDr=0) d
	.................;w deptType_"^"_itemDr_"^"_makeDr_"^"_ExecuteDr_"^"_SickDr_"^"_ChiefDoctorDr_"^"_MakeDoctorDr_"^"_ExecuteDoctorDr,!
	.................s ExpensesType=""
	.................f  s ExpensesType=$O(^dhcbsSubIncomeRateAll(num,deptType,itemDr,makeDr,ExecuteDr,SickDr,ChiefDoctorDr,MakeDoctorDr,ExecuteDoctorDr,ExpensesType)) q:ExpensesType=""  d
	..................i (ExpensesType=feeType) || (ExpensesType=0) d
	...................;w deptType_"^"_itemDr_"^"_makeDr_"^"_ExecuteDr_"^"_SickDr_"^"_ChiefDoctorDr_"^"_MakeDoctorDr_"^"_ExecuteDoctorDr_"^"_ExpensesType,!
	...................s SickType=""
	...................f  s SickType=$O(^dhcbsSubIncomeRateAll(num,deptType,itemDr,makeDr,ExecuteDr,SickDr,ChiefDoctorDr,MakeDoctorDr,ExecuteDoctorDr,ExpensesType,SickType)) q:SickType=""  d
	....................;w deptType_"^"_itemDr_"^"_makeDr_"^"_ExecuteDr_"^"_SickDr_"^"_ChiefDoctorDr_"^"_MakeDoctorDr_"^"_ExecuteDoctorDr_"^"_ExpensesType_"^"_SickType,!
	....................i (SickType=brType) || (SickType =0) d
	.....................;w deptType_"^"_itemDr_"^"_makeDr_"^"_ExecuteDr_"^"_SickDr_"^"_ChiefDoctorDr_"^"_MakeDoctorDr_"^"_ExecuteDoctorDr_"^"_ExpensesType_"^"_SickType,!
	.....................s rate=^dhcbsSubIncomeRateAll(num,deptType,itemDr,makeDr,ExecuteDr,SickDr,ChiefDoctorDr,MakeDoctorDr,ExecuteDoctorDr,ExpensesType,SickType)
	.....................;w rate,!
	.....................s feeInfo=$fn(incomeFee*rate,"",4)_"^"_rate
	
	q feeInfo
}

/// Creator：李明忠
/// CreatDate：2011-6-28
/// Description: 分解收入数据
/// Table：
/// Input：cycleDr:核算年度;fre:周期类型;quote-期间;interSetDr-接口套;interMethod-接口方法
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).Assignment("2011","M","04",4,3)
ClassMethod Assignment(cycleDr, fre, quote, interSetDr, interMethod) As %String
{
	n (cycleDr,fre,quote,interSetDr,interMethod)
	//w $zt($p($h,",",2)),!
	s YearCode=cycleDr 
	s newPeriod=fre_quote
	
	TSTART
	s $zt="GetLogError"
 
	d ..Del(cycleDr, fre, quote, interSetDr, interMethod)
	
	
	s rs=0,flag="true"
	
	//取数据
	i $D(^dhcbsSubIncomeCollectI("IdxYearPeriodMethod",YearCode,newPeriod)) d
	.i $D(^dhcbsSubIncomeCollectI("IdxYearPeriodMethod",YearCode,newPeriod,interMethod)) d
	..s rowid=0
	..f  s rowid=$O(^dhcbsSubIncomeCollectI("IdxYearPeriodMethod",YearCode,newPeriod,interMethod,rowid)) q:rowid=""  d
	...s state=$List(^dhcbsSubIncomeCollectD(rowid),21) //数据状态
	...i state=0 d
	....;w "zlg1 rowid:"_rowid,!
	....s itemCode=$List(^dhcbsSubIncomeCollectD(rowid),2) //项目代码
	....;w "itemCode:"_itemCode,! ;查找项目ID
	....s itemId=..GetFZItemId(itemCode)
	....i (itemId'=0) && (itemId'="") d //存在实体辅助项目
	.....s incomeFee=$List(^dhcbsSubIncomeCollectD(rowid),20) //金额
	.....i incomeFee="" s incomeFee=0
	.....s brType=$List(^dhcbsSubIncomeCollectD(rowid),18) //病人类型
	.....s feeType=$List(^dhcbsSubIncomeCollectD(rowid),19) //费用类型
	.....s kdDeptCode=$List(^dhcbsSubIncomeCollectD(rowid),6) //开单科室代码
	.....s kdDeptId=..GetDeptId(kdDeptCode)
	.....s kdDoctorCode=$List(^dhcbsSubIncomeCollectD(rowid),14) //开单医生代码
	.....s kdDoctorId=..GetDoctorId(kdDoctorCode)
	.....s zxDeptCode=$List(^dhcbsSubIncomeCollectD(rowid),8) //执行科室代码
	.....s zxDeptId=..GetDeptId(zxDeptCode)
	.....s zxDoctorCode=$List(^dhcbsSubIncomeCollectD(rowid),16) //执行医生代码
	.....s zxDoctorId=..GetDoctorId(zxDoctorCode)
	.....s brDeptCode=$List(^dhcbsSubIncomeCollectD(rowid),10) //病人科室代码
	.....s brDeptId=..GetDeptId(brDeptCode)
	.....s zzDoctorCode=$List(^dhcbsSubIncomeCollectD(rowid),12) //主治医师代码
	.....s zzDoctorId=..GetDoctorId(zzDoctorCode)
	.....;i rowid >100 d  s ss =100/0
	.....;w "itemId:"_itemId,!
	.....i (itemId'="") && (itemId'=0) d
	......;w "zlg_itemDr:"_itemId_"^"_feeType_"^"_brType_":"_expensFlag_"^"_sickFlag,!
	......s deptType=""
	......s deptId=0
	......;去掉开单科室
	......f i=2:1:3 d
	.......i i=1 d
	........s deptType="MakeBill"	 //开单科室
	........s unitType=1 		  	 //开单科室
	........s deptId=kdDeptId
	.......i i=2 d
	........s deptType="ExecuteDept" //执行科室
	........s unitType=2			 //执行科室
	........s deptId=zxDeptId
	.......i i=3 d
	........s deptType="SickDept" 	//病人科室
	........s unitType=3 			//病人科室
	........s deptId=brDeptId
	........;w "zlg5:"_kdDeptId_"^"_zxDeptId_"^"_brDeptId_"^"_kdDoctorId_"^"_zxDoctorId_"^"_zzDoctorId_"^"_brType_"^"_feeType,!
	.......;按照科室类型（deptType=1，2，3）获取费用及比例
	.......i (kdDeptId'="") && (zxDeptId'="") && (brDeptId'="") && (kdDoctorId'="") && (zxDoctorId'="") && (zzDoctorId'="") && (brType'="") && (feeType'="") d
	........s feeInfo=..Calculate(itemId,kdDeptId,zxDeptId,brDeptId,zzDoctorId,kdDoctorId,zxDoctorId,feeType,brType,deptType,incomeFee)
	........s rate=$P(feeInfo,"^",2)
	........s rateFee=$P(feeInfo,"^",1)
	........i i=2 d  //计算执行科室
	.........s itemDrs=..GetTargetBySubItem(itemId,i,brType,feeType)
	.........f n=2:1:$l(itemDrs,"^")  d
	..........s itemDr = $p(itemDrs,"^",n)
	..........w "rowID1:"_rowid,!
	..........s rs=..Insert(deptId,itemDr,YearCode,newPeriod,unitType,feeType,brType,zzDoctorId,kdDoctorId,zxDoctorId,incomeFee,rate,rateFee,interMethod,kdDeptId,zxDeptId,brDeptId,itemId,rowid)
	..........i rs'=0 s flag="false" 
	........i (i=3) && (zxDeptId'=brDeptId) d //计算病人科室，当执行科室等于病人科室时不再计算
	.........s itemDrs=..GetTargetBySubItem(itemId,i,brType,feeType)
	.........f n=2:1:$l(itemDrs,"^")  d
	..........s itemDr = $p(itemDrs,"^",n)
	..........w "rowID2:"_rowid,!
	..........s rs=..Insert(deptId,itemDr,YearCode,newPeriod,unitType,feeType,brType,zzDoctorId,kdDoctorId,zxDoctorId,incomeFee,rate,rateFee,interMethod,kdDeptId,zxDeptId,brDeptId,itemId,rowid)
	..........i rs'=0 s flag="false" 

	i flag="false" d
	.TRollBack
	e  d
	.TCOMMIT
	q 0

GetLogError
  	TRollBack
  	
	q "false"
}

/// Creator：李明忠
/// CreatDate：2011-6-28
/// Description: 添加收入项目拆分明细记录
/// Table：BonusSubIncomeDetail
/// Input：deptId:科室ID,itemId:辅助项目ID,YearCode:年度代码,newPeriod:组合期间,unitType:单元类别,zzDoctorId:主治医生;kdDoctorId:开单医生;zxDoctorId:执行医生ID,incomeFee:总金额,sickType:病人类别,feeType:费用类别,rate:计提系数;rateFee:计提金额;interMethod:接口方法;kdDeptDr:开单科室;zxDeptDr:执行科室;brDeptDr:病人科室;BonusSubItemID:辅助项目ID
/// Output：
/// Return：返回成功标志
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).Insert("2011","M01",1,1,1,200,0.1)
ClassMethod Insert(deptId, itemId, YearCode, newPeriod, unitType, feeType, sickType, zzDoctorId, kdDoctorId, zxDoctorId, incomeFee, rate, rateFee, interMethod, kdDeptDr, zxDeptDr, brDeptDr, BonusSubItemID, IncomeCollectID) As %String
{
	n (deptId,itemId,YearCode,newPeriod,unitType,feeType,sickType,zzDoctorId,kdDoctorId,zxDoctorId,incomeFee,rate,rateFee,interMethod,kdDeptDr,zxDeptDr,brDeptDr,BonusSubItemID,IncomeCollectID)
	//q deptId=102 q 1
	
	s state=0
	s updateDate=$zd($P($h,",",1),3)_" "_$zt($P($h,",",2))
	&SQL(insert into dhc_bonus_subs.BonusSubIncomeDetail(BonusUnitID,BonusTargetID,BonusYear,BonusPeriod,BonusUnitType,ExpensesType,SickType,ChiefDoctorID,MakeBillDoctorID,ExecuteDoctorID,IncomeMoney,IncomeRate,ResultMoney,State,InterLocMethodID,MakeBillDeptID,ExecuteDeptID,SickDeptID,UpdateDate,BonusSubItemID,IncomeCollectID) values(:deptId,:itemId,:YearCode,:newPeriod,:unitType,:feeType,:sickType,:zzDoctorId,:kdDoctorId,:zxDoctorId,:incomeFee,:rate,:rateFee,:state,:interMethod,:kdDeptDr,:zxDeptDr,:brDeptDr,:updateDate,:BonusSubItemID,:IncomeCollectID))
	s rtn = SQLCODE
	i rtn '=0 d
	.w rtn_":"_deptId_"^"_itemId_"^"_YearCode_"^"_newPeriod_"^"_unitType_"^"_feeType_"^"_sickType_"^"_zzDoctorId_"^"_kdDoctorId_"^"_zxDoctorId_"^"_incomeFee_"^"_rate_"^"_rateFee_"^"_interMethod_"^"_kdDeptDr_"^"_zxDeptDr_"^"_brDeptDr,!

	q rtn
}

/// Creator：李明忠
/// CreatDate：2011-6-29
/// Description: 查询收入辅助项目明细记录
/// Table：dhc.bonus.subs.BonusSubIncomeDetail
/// Input：cycleDr:核算年度;fre:周期类型;quote-期间;interSetDr-接口套;interMethod-接口方法;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.usubs.uIncomeDataAssignment).List("2011","M","04",4,3,"","","","",0,25)
ClassMethod List(cycleDr, fre, quote, interSetDr, interMethod, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (cycleDr,fre,quote,interSetDr,interMethod,searchField,searchValue,sortField,sortDir,start,limit)
	
	s YearCode=cycleDr  //..GetCycle(cycleDr)
	s newPeriod=fre_quote
	
	s sqlStr="select BonusSubIncomeDetailID,BonusUnitID,BonusTargetID,BonusYear,BonusPeriod,BonusUnitType,ExpensesType,SickType,ChiefDoctorID,MakeBillDoctorID,ExecuteDoctorID,IncomeMoney,IncomeRate,ResultMoney,State,MakeBillDeptID,ExecuteDeptID,SickDeptID,UpdateDate from dhc_bonus_subs.BonusSubIncomeDetail"
	s whereStr=" where BonusSubIncomeDetailID>0"
	s whereStr=whereStr_" and InterLocMethodID ='"_interMethod_"'"
	s whereStr=whereStr_" and BonusYear='"_cycleDr_"'"
	s whereStr=whereStr_" and BonusPeriod='"_newPeriod_"'"
	
	s sortStr="",sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="BonusSubIncomeDetailID"
	.i sortField="unitName" s sortField1="BonusUnitID"
	.i sortField="itemName" s sortField1="BonusTargetID"
	.i sortField="year" s sortField1="BonusYear"
	.i sortField="period" s sortField1="BonusPeriod"
	.i sortField="unitTypeName" s sortField1="BonusUnitType"
	.i sortField="expensesTypeName" s sortField1="ExpensesType"
	.i sortField="sickTypeName" s sortField1="SickType"
	.i sortField="chiefDoctorName" s sortField1="ChiefDoctorID"
	.i sortField="makeBillDoctorName" s sortField1="MakeBillDoctorID"
	.i sortField="executeDoctorName" s sortField1="ExecuteDoctorID"
	.i sortField="incomeMoney" s sortField1="IncomeMoney"
	.i sortField="incomeRate" s sortField1="IncomeRate"
	.i sortField="resultMoney" s sortField1="ResultMoney"
	.i sortField="stateName" s sortField1="State"
	.i sortField="kdDeptName" s sortField1="MakeBillDeptID"
	.i sortField="zxDeptName" s sortField1="ExecuteDeptID"
	.i sortField="brDeptName" s sortField1="SickDeptID"
	.i sortField="updateDate" s sortField1="UpdateDate"
	/* 	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY %ID DESC"
    */
	s sqlStr=sqlStr_whereStr_sortStr
	
	w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^unitDr^unitName^itemDr^itemName^year^period^unitType^unitTypeName^expensesType^expensesTypeName^sickType^sickTypeName^chiefDoctorDr^chiefDoctorName^makeBillDoctorDr^makeBillDoctorName^executeDoctorDr^executeDoctorName^incomeMoney^incomeRate^resultMoney^state^stateName^updateDate^kdDeptDr^kdDeptName^zxDeptDr^zxDeptName^brDeptDr^brDeptName"
	//取结构
	While((result.Next()) & (count>=start)&(count<=end)){
		s unitName="",itemName="",unitTypeName="",expensesTypeName="",sickTypeName="",chiefDoctorName="",makeBillDoctorName="",executeDoctorName="",stateName="",kdDeptName="",zxDeptName="",brDeptName=""
		s rowid = result.Data("BonusSubIncomeDetailID")
		s unitDr = result.Data("BonusUnitID")
		i unitDr'="" d
		.s unitName=..GetNameById(unitDr)
		s itemDr = result.Data("BonusTargetID")
		i itemDr'="" d
		.i $D(^dhcbsBonusTargetD(itemDr)) d
		..s itemName=$List(^dhcbsBonusTargetD(itemDr),3)
		s year = YearCode
		s period = newPeriod
		i fre="M" s period=quote_"月"
		i fre="Q" s period=quote_"季"
		i (fre="H" && quote="01") s period="上半年"
		i (fre="H" && quote="02") s period="下半年"
		i fre="Y" s period=""
		s unitType = result.Data("BonusUnitType")
		i unitType=1 s unitTypeName="开单科室"
		i unitType=2 s unitTypeName="执行科室"
		i unitType=3 s unitTypeName="病人科室"
		i unitType=4 s unitTypeName="开单医生"
		i unitType=5 s unitTypeName="执行医生"
		s expensesType = result.Data("ExpensesType")
		i expensesType=0 s expensesTypeName="全部"
		i expensesType=1 s expensesTypeName="门诊"
		i expensesType=2 s expensesTypeName="住院"
		i expensesType=3 s expensesTypeName="急诊"
		s sickType = result.Data("SickType")
		i sickType=0 s sickTypeName="全部"
		i sickType=1 s sickTypeName="自费"
		i sickType=2 s sickTypeName="医保"
		i sickType=3 s sickTypeName="新农合"
		
		s chiefDoctorName=""
		s chiefDoctorDr = result.Data("ChiefDoctorID")
		i chiefDoctorDr>0 d
		.s chiefDoctorName=..GetNameById(chiefDoctorDr)
		
		s makeBillDoctorName=""
		s makeBillDoctorDr = result.Data("MakeBillDoctorID")
		i makeBillDoctorDr>0 d
		.s makeBillDoctorName=..GetNameById(makeBillDoctorDr)
		
		s executeDoctorDr = result.Data("ExecuteDoctorID")
		s executeDoctorName=""
		i executeDoctorDr>0 d
		.w "zlg1:"_executeDoctorDr,!
		.s executeDoctorName= $list(^dhcbsBonusUnitD(executeDoctorDr),3)
		
		s incomeMoney = result.Data("IncomeMoney")
		s incomeRate = result.Data("IncomeRate")
		s resultMoney = result.Data("ResultMoney")
		s state = result.Data("State")
		i state=0 s stateName="未处理"
		i state=1 s stateName="已处理"
		s kdDeptDr=result.Data("MakeBillDeptID")
		i kdDeptDr'="" d
		.s kdDeptName=..GetNameById(kdDeptDr)
		s zxDeptDr=result.Data("ExecuteDeptID")
		i zxDeptDr'="" d
		.s zxDeptName=..GetNameById(zxDeptDr)
		s brDeptDr=result.Data("SickDeptID")
		i brDeptDr'="" d
		.s brDeptName=..GetNameById(brDeptDr)
		s updateDate=result.Data("UpdateDate")
		//s updateDate=$ZD(updateDate,3)
					
		s tmp=rowid_"^"_unitDr_"^"_unitName_"^"_itemDr_"^"_itemName_"^"_year_"^"_period_"^"_unitType_"^"_unitTypeName_"^"_expensesType_"^"_expensesTypeName_"^"_sickType_"^"_sickTypeName_"^"_chiefDoctorDr_"^"_chiefDoctorName_"^"_makeBillDoctorDr_"^"_makeBillDoctorName_"^"_executeDoctorDr_"^"_executeDoctorName_"^"_incomeMoney_"^"_incomeRate_"^"_resultMoney_"^"_state_"^"_stateName_"^"_updateDate_"^"_kdDeptDr_"^"_kdDeptName_"^"_zxDeptDr_"^"_zxDeptName_"^"_brDeptDr_"^"_brDeptName
		/*
		i searchValue'="" d
		.q:(searchField = "sickTypeName")&(sickTypeName'[searchValue)
		.q:(searchField = "unitName")&(unitName'[searchValue)
		.q:(searchField = "expensesTypeName")&(expensesTypeName'[searchValue)
		.q:(searchField = "itemName")&(itemName'[searchValue)
		.q:(searchField = "updateDate")&(updateDate'[searchValue)
		*/
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:李明忠
/// CreatDate:2011-6-29
/// Description:查询收入接口套记录
/// Table:dhc_bonus_inter.InterLocSet
/// Input:searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.usubs.uIncomeDataAssignment).LocSetSubLis("","","","",0,25)
ClassMethod LocSetSubList(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)

	s sqlStr="select InterLocSet_rowid,InterLocSet_order,InterLocSet_code,InterLocSet_name,"
	_" InterLocSet_shortcut,InterLocSet_desc,InterLocSet_active,InterLocSet_type from dhc_bonus_inter.InterLocSet "
	_" where %ID>0 and InterLocSet_type in (2,3) and InterLocSet_active='Y'"
		
	
	//w sqlStr,!
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^order^code^name^shortcut^desc^active"
	
	While(result.Next()){
		s rowid=result.Data("InterLocSet_rowid")
		s order=result.Data("InterLocSet_order")
		s code=result.Data("InterLocSet_code")
		s name=result.Data("InterLocSet_name")
		s shortcut=result.Data("InterLocSet_shortcut")
		s desc=result.Data("InterLocSet_desc")
		s active=result.Data("InterLocSet_active")
		s type=result.Data("InterLocSet_type")
		i type=2 d
		.s tmp=rowid_"^"_order_"^"_code_"^"_name_"^"_shortcut_"^"_desc_"^"_active
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2011-6-29
/// Description: 删除收入明细数据
/// Table：
/// Input：cycleCode:核算年度;fre:周期类型;quote-期间;interSetDr-接口套;interMethod-接口方法
/// Output：
/// Return：成功与否的标示值,即:0-成功,1-失败
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).Del(10,"M","01","",49)
ClassMethod Del(cycleCode, fre, quote, interSetDr, interMethod) As %String
{
	n (cycleCode,fre,quote,interSetDr,interMethod)
	
	s YearCode=cycleCode
	s newPeriod=fre_quote
	
	&SQL(delete from dhc_bonus_subs.BonusSubIncomeDetail where BonusYear=:YearCode and BonusPeriod=:newPeriod and InterLocMethodID=:interMethod)
	
	q SQLCODE
}

/// Creator：zhaoliguo
/// CreatDate：2011-7-25
/// Description: 辅助核算数据过滤
/// Table：
/// Input：cycleCode:核算年度;fre:周期类型;quote-期间;interSetDr-接口套;interMethod-接口方法
/// Output：
/// Return：成功与否的标示值,即:0-成功,1-失败
/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).DataFliter(10,"M","01","",49)
ClassMethod DataFliter(itemId, kdDeptId, zxDeptId, brDeptId, zzDoctorId, kdDoctorId, zxDoctorId, feeType, brType, deptTypeName) As %String
{
	n (itemId, kdDeptId, zxDeptId, brDeptId, zzDoctorId, kdDoctorId, zxDoctorId, feeType, brType, deptTypeName)

	q SQLCODE
}

/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).GetUnitFliter(2,1)
ClassMethod GetUnitFliter(itemId, unitFlag) As %String
{
	n (itemId,unitFlag)
	q:unitFlag=0 1
	s isExist =0
	s UnitFlagID=""
	f  s UnitFlagID=$O(^dhcbsSubUnitFliterI("TargetUnit",itemId,UnitFlagID)) q:UnitFlagID=""  d
	.i UnitFlagID= unitFlag d
	..s isExist = 1
	
	q isExist
}

/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).GetExpensesFliter(2,1)
ClassMethod GetExpensesFliter(itemId, ExpensesFlag) As %String
{
	n (itemId,ExpensesFlag)
	
	q:ExpensesFlag=0 1
	
	s isExist =0
	
	s itemDr=""
	s ExpensesDr =""
	f  s ExpensesDr=$O(^dhcbsSubExpensesFliterI("TargetExpens",itemId,ExpensesDr)) q:ExpensesDr=""  d
	.i ExpensesDr=ExpensesFlag d
	..s isExist =1
	
	q isExist
}

/// Others：w ##class(dhc.bonus.usubs.uIncomeDataAssignment).GetSickFliter(2,1)
ClassMethod GetSickFliter(itemId, SickFlag) As %String
{
	n (itemId,SickFlag)

	q:SickFlag=0 1
	
	s isExist =0
	
	s itemDr=""
	s SickDr =""
	f  s SickDr=$O(^dhcbsSickFliterI("TargetSick",itemId,SickDr)) q:SickDr=""  d
	.i SickDr=SickFlag d
	..s isExist =1
	
	q isExist
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5E4.uIncomeDataA863S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
