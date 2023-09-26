/// Creator: 李明忠
/// CreatDate: 2011-6-23
/// Description: 收入数据分解业务类
Class dhc.bonus.udata.uIncomeDataAssignment Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2011-6-24
/// Description: 获取年度
/// Table：
/// Input：cycleDr:核算年度
/// Output：
/// Return：核算年度代码
/// Others：w ##class(dhc.bonus.udata.uIncomeDataAssignment).GetCycle(1)
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
/// Others：w ##class(dhc.bonus.udata.uIncomeDataAssignment).GetFZItemId("001")
ClassMethod GetFZItemId(itemCode) As %String
{
	n (itemCode)
	
	s rowid=0
	i $D(^dhcbsSubItemI("SubsItemCode",itemCode)) d
	.s rowid=$O(^dhcbsSubItemI("SubsItemCode",itemCode,rowid))
	.i rowid="" s rowid=0
	
	q rowid
}

/// Creator：李明忠
/// CreatDate：2011-6-28
/// Description: 获取科室的ID
/// Table：
/// Input：deptCode:科室code
/// Output：
/// Return：科室的ID
/// Others：w ##class(dhc.bonus.udata.uIncomeDataAssignment).GetDeptId("001")
ClassMethod GetDeptId(deptCode) As %String
{
	n (deptCode)
	
	s rowid=0
	s sqlStr="select InterLoc_rowid from dhc_bonus_inter.InterLoc where InterLoc_rowid>0 and InterLoc_code='"_deptCode_"'"	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s rowid = result.Data("InterLoc_rowid")
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
/// Others：w ##class(dhc.bonus.udata.uIncomeDataAssignment).GetDoctorId("001")
ClassMethod GetDoctorId(doctorCode) As %String
{
	n (doctorCode)
	
	s rowid=0
	s sqlStr="select InterLoc_rowid from dhc_bonus_inter.InterLoc where InterLoc_rowid>0 and InterLoc_code='"_doctorCode_"'"	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s rowid = result.Data("InterLoc_rowid")
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
/// Others：w ##class(dhc.bonus.udata.uIncomeDataAssignment).GetNameById(1)
ClassMethod GetNameById(Id) As %String
{
	n (Id)
	
	s name=""
	s sqlStr="select InterLoc_name from dhc_bonus_inter.InterLoc where InterLoc_rowid="_Id	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s name = result.Data("InterLoc_name")
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
/// Others：w ##class(dhc.bonus.udata.uIncomeDataAssignment).GetDeptOfDeptGroup("G1")
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
/// Others：w ##class(dhc.bonus.udata.uIncomeDataAssignment).GetDoctorOfDoctorGroup("G1")
ClassMethod GetDoctorOfDoctorGroup(doctorGroupDr) As %String
{
	n (doctorGroupDr)
	
	s doctorDrStr=""
	i $D(^dhcbsSubDoctorGroupMapI("Parent",doctorGroupDr)) d
	.s doctorDr=0
	.f  s doctorDr=$O(^dhcbsSubDoctorGroupMapI("Parent",doctorGroupDr,doctorDr)) q:doctorDr=""  d
	..i doctorDrStr="" s doctorDrStr=doctorDr
	..e  s doctorDrStr=doctorDrStr_"^"_doctorDr
	
	q doctorDrStr
}

/// Creator：李明忠
/// CreatDate：2011-6-28
/// Description: 生成临时Global
/// Table：
/// Input：YearCode:核算年度代码;newPeriod:组合期间(如:"M01")
/// Output：
/// Return：
/// Others：w ##class(dhc.bonus.udata.uIncomeDataAssignment).SetTmpGlobal("2009","M01")
ClassMethod SetTmpGlobal(YearCode, newPeriod) As %String
{
	n (YearCode,newPeriod)
	
	k ^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome","makebill",$j,YearCode,newPeriod)
	k ^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome","execute",$j,YearCode,newPeriod)
	k ^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome","sick",$j,YearCode,newPeriod)
	
	//1.开单科室(组)和开单医生(组)
	i $D(^dhcbsSubIncomeRateI("MakeBill")) d
	.s itemId=0
	.f  s itemId=$O(^dhcbsSubIncomeRateI("MakeBill",itemId)) q:itemId=""  d
	..s sickType=""
	..f  s sickType=$O(^dhcbsSubIncomeRateI("MakeBill",itemId,sickType)) q:sickType=""  d
	...s feeType=""
	...f  s feeType=$O(^dhcbsSubIncomeRateI("MakeBill",itemId,sickType,feeType)) q:feeType=""  d
	....s makeBillDeptRowid=0
	....f  s makeBillDeptRowid=$O(^dhcbsSubIncomeRateI("MakeBill",itemId,sickType,feeType,makeBillDeptRowid)) q:makeBillDeptRowid=""  d
	.....s deptChar=$E(makeBillDeptRowid,1)
	.....s unitDrStr=""
	.....i deptChar="G" d //该记录是科室组
	......s unitDrStr=..GetDeptOfDeptGroup($E(makeBillDeptRowid,2,$L(makeBillDeptRowid)))
	.....e  d
	......s unitDrStr=$E(makeBillDeptRowid,2,$L(makeBillDeptRowid))
	.....s makeBillDoctorRowid=0
	.....f  s makeBillDoctorRowid=$O(^dhcbsSubIncomeRateI("MakeBill",itemId,sickType,feeType,makeBillDeptRowid,makeBillDoctorRowid)) q:makeBillDoctorRowid=""  d
	......s doctorChar=$E(makeBillDoctorRowid,1)
	......s doctorDrStr=""
	......i doctorChar="G" d //该记录是医生组
	.......s doctorDrStr=..GetDoctorOfDoctorGroup($E(makeBillDoctorRowid,2,$L(makeBillDoctorRowid)))
	......e  d
	.......s doctorDrStr=$E(makeBillDoctorRowid,2,$L(makeBillDoctorRowid))
	......s rate=0
	......s rate=$O(^dhcbsSubIncomeRateI("MakeBill",itemId,sickType,feeType,makeBillDeptRowid,makeBillDoctorRowid,rate))
	......i (unitDrStr'="") && (doctorDrStr'="") d
	.......s unitDrLen=$L(unitDrStr,"^")
	.......s doctorDrLen=$L(doctorDrStr,"^")
	.......f i=1:1:unitDrLen d
	........s unitDr=$P(unitDrStr,"^",i)
	........f k=1:1:doctorDrLen d
	.........s doctorDr=$P(doctorDrStr,"^",k)
	.........s ^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome","makebill",$j,YearCode,newPeriod,itemId,sickType,feeType,unitDr,doctorDr)=rate
	
	//2.执行科室(组)和执行医生(组)
	i $D(^dhcbsSubIncomeRateI("Execute")) d
	.s itemId=0
	.f  s itemId=$O(^dhcbsSubIncomeRateI("Execute",itemId)) q:itemId=""  d
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
	......i (unitDrStr'="") && (doctorDrStr'="") d
	.......s unitDrLen=$L(unitDrStr,"^")
	.......s doctorDrLen=$L(doctorDrStr,"^")
	.......f i=1:1:unitDrLen d
	........s unitDr=$P(unitDrStr,"^",i)
	........f k=1:1:doctorDrLen d
	.........s doctorDr=$P(doctorDrStr,"^",k)
	.........s ^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome","execute",$j,YearCode,newPeriod,itemId,sickType,feeType,unitDr,doctorDr)=rate
	
	//3.病人科室(组)和主任医生(组)
	i $D(^dhcbsSubIncomeRateI("Sick")) d
	.s itemId=0
	.f  s itemId=$O(^dhcbsSubIncomeRateI("Sick",itemId)) q:itemId=""  d
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
	......s doctorChar=$E(sickDoctorRowid,1)
	......s doctorDrStr=""
	......i doctorChar="G" d //该记录是医生组
	.......s doctorDrStr=..GetDoctorOfDoctorGroup($E(sickDoctorRowid,2,$L(sickDoctorRowid)))
	......e  d
	.......s doctorDrStr=$E(sickDoctorRowid,2,$L(sickDoctorRowid))
	......s rate=0
	......s rate=$O(^dhcbsSubIncomeRateI("Sick",itemId,sickType,feeType,sickDeptRowid,sickDoctorRowid,rate))
	......i (unitDrStr'="") && (doctorDrStr'="") d
	.......s unitDrLen=$L(unitDrStr,"^")
	.......s doctorDrLen=$L(doctorDrStr,"^")
	.......f i=1:1:unitDrLen d
	........s unitDr=$P(unitDrStr,"^",i)
	........f k=1:1:doctorDrLen d
	.........s doctorDr=$P(doctorDrStr,"^",k)
	.........s ^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome","sick",$j,YearCode,newPeriod,itemId,sickType,feeType,unitDr,doctorDr)=rate
}

/// Creator：李明忠
/// CreatDate：2011-6-28
/// Description: 计算科室的比例金额(即:总金额*所占比)
/// Table：
/// Input：YearCode:年度代码,newPeriod:组合期间,itemId:项目ID,deptDr:科室ID,doctorDr:医生ID,totalFee:总金额,sickType:病人类别,feeType:费用类别,deptType:科室类别
/// Output：
/// Return：返回科室的比例金额
/// Others：w ##class(dhc.bonus.udata.uIncomeDataAssignment).Calculate("2011","M01",1,1,1,200,0.1)
ClassMethod Calculate(YearCode, newPeriod, itemId, sickType, feeType, deptType, deptDr, doctorDr, totalFee) As %String
{
	n (YearCode,newPeriod,itemId,sickType,feeType,deptType,deptDr,doctorDr,totalFee)
	
	q:deptDr=0 0
	q:doctorDr=0 0
	
	s rateFee=0,rate=0
	s feeInfo=rateFee_"^"_rate
	
	i $D(^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome",deptType,$j)) d
	.i $D(^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome",deptType,$j,YearCode,newPeriod)) d
	..i $D(^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome",deptType,$j,YearCode,newPeriod,itemId)) d
	...i $D(^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome",deptType,$j,YearCode,newPeriod,itemId,sickType)) d
	....i $D(^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome",deptType,$j,YearCode,newPeriod,itemId,sickType,feeType)) d
	.....i $D(^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome",deptType,$j,YearCode,newPeriod,itemId,sickType,feeType,deptDr)) d
	......i $D(^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome",deptType,$j,YearCode,newPeriod,itemId,sickType,feeType,deptDr,doctorDr)) d
	.......s rate=^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome",deptType,$j,YearCode,newPeriod,itemId,sickType,feeType,deptDr,doctorDr)
	.......s feeInfo=$fn(totalFee*rate,"",4)_"^"_rate
	
	q feeInfo
}

/// Creator：李明忠
/// CreatDate：2011-6-28
/// Description: 添加收入项目拆分明细记录
/// Table：BonusSubIncomeDetail
/// Input：deptId:科室ID,itemId:辅助项目ID,YearCode:年度代码,newPeriod:组合期间,unitType:单元类别,zzDoctorId:主治医生;kdDoctorId:开单医生;zxDoctorId:执行医生ID,incomeFee:总金额,sickType:病人类别,feeType:费用类别,rate:计提系数;rateFee:计提金额;interMethod:接口方法;kdDeptDr:开单科室;zxDeptDr:执行科室;brDeptDr:病人科室
/// Output：
/// Return：返回成功标志
/// Others：w ##class(dhc.bonus.udata.uIncomeDataAssignment).Insert("2011","M01",1,1,1,200,0.1)
ClassMethod Insert(deptId, itemId, YearCode, newPeriod, unitType, feeType, sickType, zzDoctorId, kdDoctorId, zxDoctorId, incomeFee, rate, rateFee, interMethod, kdDeptDr, zxDeptDr, brDeptDr) As %String
{
	n (deptId,itemId,YearCode,newPeriod,unitType,feeType,sickType,zzDoctorId,kdDoctorId,zxDoctorId,incomeFee,rate,rateFee,interMethod,kdDeptDr,zxDeptDr,brDeptDr)
	
	s state=0
	s updateDate=$P($h,",",1)
	&SQL(insert into dhc_bonus_subs.BonusSubIncomeDetail(BonusUnitID,BonusTargetID,BonusYear,BonusPeriod,BonusUnitType,ExpensesType,SickType,ChiefDoctorID,MakeBillDoctorID,ExecuteDoctorID,IncomeMoney,IncomeRate,ResultMoney,State,InterLocMethodID,MakeBillDeptID,ExecuteDeptID,SickDeptID,UpdateDate) values(:deptId,:itemId,:YearCode,:newPeriod,:unitType,:feeType,:sickType,:zzDoctorId,:kdDoctorId,:zxDoctorId,:incomeFee,:rate,:rateFee,:state,:interMethod,:kdDeptDr,:zxDeptDr,:brDeptDr,:updateDate))
	
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2011-6-28
/// Description: 分解收入数据
/// Table：
/// Input：cycleDr:核算年度;fre:周期类型;quote-期间;interSetDr-接口套;interMethod-接口方法
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.bonus.udata.uIncomeDataAssignment).Assignment("2011","M","03","13",52)
ClassMethod Assignment(cycleDr, fre, quote, interSetDr, interMethod) As %String
{
	n (cycleDr,fre,quote,interSetDr,interMethod)
	
	s YearCode=..GetCycle(cycleDr)
	s newPeriod=fre_quote
	
	//生成临时Global
	d ..SetTmpGlobal(YearCode,newPeriod)
	
	TSTART
	s rs=0,flag="true"
	
	s makeDeptType="makebill",executeDeptType="execute",sickDeptType="sick"
	//取数据
	i $D(^dhcbsSubIncomeCollectI("IdxYearPeriodMethod",YearCode,newPeriod)) d
	.i $D(^dhcbsSubIncomeCollectI("IdxYearPeriodMethod",YearCode,newPeriod,interMethod)) d
	..s rowid=0
	..f  s rowid=$O(^dhcbsSubIncomeCollectI("IdxYearPeriodMethod",YearCode,newPeriod,interMethod,rowid)) q:rowid=""  d
	...s state=$List(^dhcbsSubIncomeCollectD(rowid),21) //数据状态
	...i state=0 d
	....s itemCode=$List(^dhcbsSubIncomeCollectD(rowid),2) //项目代码
	....;查找项目ID
	....s itemId=..GetFZItemId(itemCode)
	....i (itemId'=0) && (itemId'="") d //存在实体辅助项目
	.....s incomeFee=$List(^dhcbsSubIncomeCollectD(rowid),20) //金额
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
	.....i (kdDeptId'=0)&&(kdDeptId'="")&&(kdDoctorId'=0)&&(kdDoctorId'="") d
	......s unitType=1 //开单科室
	......;取开单科室的ID、提取系数并计算收入分配金额
	......s feeInfo=..Calculate(YearCode,newPeriod,itemId,brType,feeType,makeDeptType,kdDeptId,kdDoctorId,incomeFee)
	......s rate=$P(feeInfo,"^",2)
	......s rateFee=$P(feeInfo,"^",1)
	......s rs=..Insert(kdDeptId,itemId,YearCode,newPeriod,unitType,feeType,brType,zzDoctorId,kdDoctorId,zxDoctorId,incomeFee,rate,rateFee,interMethod,kdDeptId,zxDeptId,brDeptId)
	......i rs'=0 d
	.......s flag="false"
	.....i (zxDeptId'=0)&&(zxDeptId'="")&&(zxDoctorId'=0)&&(zxDoctorId'="") d
	......s unitType=2 //执行科室
	......;取执行科室的ID、提取系数并计算收入分配金额
	......s feeInfo=..Calculate(YearCode,newPeriod,itemId,brType,feeType,executeDeptType,zxDeptId,zxDoctorId,incomeFee)
	......s rate=$P(feeInfo,"^",2)
	......s rateFee=$P(feeInfo,"^",1)
	......s rs=..Insert(zxDeptId,itemId,YearCode,newPeriod,unitType,feeType,brType,zzDoctorId,kdDoctorId,zxDoctorId,incomeFee,rate,rateFee,interMethod,kdDeptId,zxDeptId,brDeptId)
	......i rs'=0 d
	.......s flag="false"
	.....i (brDeptId'=0)&&(brDeptId'="")&&(zzDoctorId'=0)&&(zzDoctorId'="") d
	......s unitType=3 //病人科室
	......;取病人科室的ID、提取系数并计算收入分配金额
	......s feeInfo=..Calculate(YearCode,newPeriod,itemId,brType,feeType,sickDeptType,brDeptId,zzDoctorId,incomeFee)
	......s rate=$P(feeInfo,"^",2)
	......s rateFee=$P(feeInfo,"^",1)
	......s rs=..Insert(brDeptId,itemId,YearCode,newPeriod,unitType,feeType,brType,zzDoctorId,kdDoctorId,zxDoctorId,incomeFee,rate,rateFee,interMethod,kdDeptId,zxDeptId,brDeptId)
	......i rs'=0 d
	.......s flag="false"
	
	k ^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome","makebill",$j,YearCode,newPeriod)
	k ^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome","execute",$j,YearCode,newPeriod)
	k ^DHCBONUSTmpGlobal("dhc","bonus","fuzhuIncome","sick",$j,YearCode,newPeriod)
	
	i flag="false" d
	.TRollBack
	e  d
	.TCOMMIT
	
	q flag
}

/// Creator：李明忠
/// CreatDate：2011-6-29
/// Description: 查询收入辅助项目明细记录
/// Table：dhc.bonus.subs.BonusSubIncomeDetail
/// Input：cycleDr:核算年度;fre:周期类型;quote-期间;interSetDr-接口套;interMethod-接口方法;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uIncomeDataAssignment).List(1,"M","01",1,1,"","","","",0,25)
ClassMethod List(cycleDr, fre, quote, interSetDr, interMethod, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (cycleDr,fre,quote,interSetDr,interMethod,searchField,searchValue,sortField,sortDir,start,limit)
	
	s YearCode=..GetCycle(cycleDr)
	s newPeriod=fre_quote
	
	s sqlStr="select BonusSubIncomeDetailID,BonusUnitID,BonusTargetID,BonusYear,BonusPeriod,BonusUnitType,ExpensesType,SickType,ChiefDoctorID,MakeBillDoctorID,ExecuteDoctorID,IncomeMoney,IncomeRate,ResultMoney,State,MakeBillDeptID,ExecuteDeptID,SickDeptID,UpdateDate from dhc_bonus_subs.BonusSubIncomeDetail"
	s whereStr=" where BonusSubIncomeDetailID>0"
	s whereStr=whereStr_" and InterLocMethodID ='"_interMethod_"'"
	s whereStr=whereStr_" and BonusYear='"_YearCode_"'"
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
	 	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY %ID DESC"

	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^unitDr^unitName^itemDr^itemName^year^period^unitType^unitTypeName^expensesType^expensesTypeName^sickType^sickTypeName^chiefDoctorDr^chiefDoctorName^makeBillDoctorDr^makeBillDoctorName^executeDoctorDr^executeDoctorName^incomeMoney^incomeRate^resultMoney^state^stateName^updateDate^kdDeptDr^kdDeptName^zxDeptDr^zxDeptName^brDeptDr^brDeptName"
	//取结构
	While(result.Next()){
		s unitName="",itemName="",unitTypeName="",expensesTypeName="",sickTypeName="",chiefDoctorName="",makeBillDoctorName="",executeDoctorName="",stateName="",kdDeptName="",zxDeptName="",brDeptName=""
		s rowid = result.Data("BonusSubIncomeDetailID")
		s unitDr = result.Data("BonusUnitID")
		i unitDr'="" d
		.s unitName=..GetNameById(unitDr)
		s itemDr = result.Data("BonusTargetID")
		i itemDr'="" d
		.i $D(^dhcbsSubItemD(itemDr)) d
		..s itemName=$List(^dhcbsSubItemD(itemDr),3)
		s year = YearCode
		s period = newPeriod
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
		s chiefDoctorDr = result.Data("ChiefDoctorID")
		i chiefDoctorDr'="" d
		.s chiefDoctorName=..GetNameById(chiefDoctorDr)
		s makeBillDoctorDr = result.Data("MakeBillDoctorID")
		i makeBillDoctorDr'="" d
		.s makeBillDoctorName=..GetNameById(makeBillDoctorDr)
		s executeDoctorDr = result.Data("ExecuteDoctorID")
		i executeDoctorDr'="" d
		.s executeDoctorName=..GetNameById(executeDoctorDr)
		s incomeMoney = result.Data("IncomeMoney")
		s incomeRate = result.Data("IncomeRate")
		s resultMoney = result.Data("ResultMoney")
		s state = result.Data("State")
		i state=0 s sickTypeName="未处理"
		i state=1 s sickTypeName="已处理"
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
		s updateDate=$ZD(updateDate,3)
					
		s tmp=rowid_"^"_unitDr_"^"_unitName_"^"_itemDr_"^"_itemName_"^"_year_"^"_period_"^"_unitType_"^"_unitTypeName_"^"_expensesType_"^"_expensesTypeName_"^"_sickType_"^"_sickTypeName_"^"_chiefDoctorDr_"^"_chiefDoctorName_"^"_makeBillDoctorDr_"^"_makeBillDoctorName_"^"_executeDoctorDr_"^"_executeDoctorName_"^"_incomeMoney_"^"_incomeRate_"^"_resultMoney_"^"_state_"^"_stateName_"^"_updateDate_"^"_kdDeptDr_"^"_kdDeptName_"^"_zxDeptDr_"^"_zxDeptName_"^"_brDeptDr_"^"_brDeptName
		
		i searchValue'="" d
		.q:(searchField = "sickTypeName")&(sickTypeName'[searchValue)
		.q:(searchField = "unitName")&(unitName'[searchValue)
		.q:(searchField = "expensesTypeName")&(expensesTypeName'[searchValue)
		.q:(searchField = "itemName")&(itemName'[searchValue)
		.q:(searchField = "updateDate")&(updateDate'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
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
/// Others:w ##class(dhc.bonus.udata.uOutKpiRule).LocSetSubLis("","","","",0,25)
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
/// Input：cycleDr:核算年度;fre:周期类型;quote-期间;interSetDr-接口套;interMethod-接口方法
/// Output：
/// Return：成功与否的标示值,即:0-成功,1-失败
/// Others：w ##class(dhc.bonus.udata.uIncomeDataAssignment).Del(10,"M","01","",49)
ClassMethod Del(cycleDr, fre, quote, interSetDr, interMethod) As %String
{
	n (cycleDr,fre,quote,interSetDr,interMethod)
	
	s YearCode=..GetCycle(cycleDr)
	s newPeriod=fre_quote
	
	&SQL(delete from dhc_bonus_subs.BonusSubIncomeDetail where BonusYear=:YearCode and BonusPeriod=:newPeriod and InterLocMethodID=:interMethod)
	
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uIncomeDataA863S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
