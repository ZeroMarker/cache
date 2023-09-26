/// 名称:DtPortal.DD.DD21TodayLocFee
/// 描述:查询科室当日费用
/// 编写者:DanPJ
/// 编写日期:2020-12-11
Class DtPortal.DD.DD21TodayLocFee Extends %RegisteredObject
{

/// DD21.01.01查询科室当日门诊收入、住院收入、总收入、门诊次均费用、住院次均费用
/// DanPJ 2020-12-11
/// 索引、账单人数、账单费用、总账单次均费用、门诊账单人数、门诊账单费用、门诊账单次均费用、住院账单人数、住院账单费用、住院账单次均费用、出院患者人数、出院患者账单费用、出院患者账单次均费用
/// ind,BilldPatients,BilldPatFee,BPFAverage,BilldOPatNum,BilldOPatFee,BOPFAverage,BilldIPatNum,BilldIPatFee,BIPFAverage,DischgPatNum,DischgPatFee,DPFAverage
/// d ##class(%ResultSet).RunQuery("DtPortal.DD.DD21TodayLocFee","DD210101","2020-12-03","2020-12-03","151^130^131^15^19")
Query DD210101(StartDate As %String = "", EndDate As %String = "", LocGroupId As %String) As DtPortal.Query(ROWSPEC = "ind,BilldPatients,BilldPatFee,BPFAverage,BilldOPatNum,BilldOPatFee,BOPFAverage,BilldIPatNum,BilldIPatFee,BIPFAverage,DischgPatNum,DischgPatFee,DPFAverage") [ SqlProc ]
{
}

ClassMethod DD210101Execute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", LocGroupId As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	set startTime=$P($H,",",2)
	
	kill ^TEMPDHCPORDD21101($j,"PBAdmDr")
	kill ^TEMPDHCPORDD21101($j,"DischgAdm")
	
	if ((StartDate="")||(EndDate="")) set StartDate=EndDate=+$H			//如果没有传开始和结束日期，就默认查询当日数据
	else  set StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	
	
	set LocStr=##class(DtPortal.DD.DD00PublicService).getDDloc(LocGroupId,"")		//获取科室ID串
	set ILocStr=##class(DtPortal.DD.DD00PublicService).getDDloc(LocGroupId,"I")		//获取住院科室ID串			
	set LocList=$listfromstring(LocStr,"^")
	set AdmStr=""										//就诊号串
	
	set (BillAllFee)=0.0000
	//根据账单日期获取费用信息
	//^DHCPB(0,"BILLDATE",{PBD_BillDate},{DHC_PatientBill.PB_RowId},{DHC_PatBillOrder.PBO_ChildSub},{PBD_ChildSub})
	for PBDBillDate=StartDate:1:EndDate {
		set PBRowId=""
		for {
			set PBRowId=$o(^DHCPB(0,"BILLDATE",PBDBillDate,PBRowId))	
			quit:PBRowId=""												//DHC_PatientBill账单主表的Id
			
			set PBAdmDr=$P($G(^DHCPB(PBRowId)),"^",1)					//PA_Adm表中的RowId，就诊号
			continue:PBAdmDr=""
				
			set PAADMType=$P($G(^PAADM(PBAdmDr)),"^",2)					//就诊类型
			continue:PAADMType=""
			
			set PAADMDepCodeDR=$P($G(^PAADM(PBAdmDr)),"^",4)			//就诊科室
			continue:'$listfind(LocList,PAADMDepCodeDR)
			
			set ^TEMPDHCPORDD21101($j,"PBAdmDr",PBAdmDr)=1					//保存就诊号,去掉重复的就诊号
		}
	}
	
	//^PAADMi("DisDateDep",{PAADM_DepCode_DR},{PAADM_DischgDate},{PAADM_RowID})
	set ILocLength=$length(ILocStr,"^")
	for ILocIndex=1:1:ILocLength{
		set LocId=$P(ILocStr,"^",ILocIndex)	
		continue:LocId=""
		
		for DischgDate=StartDate:1:EndDate {
			set DisAdmRowId=""
			for {
				set DisAdmRowId=$o(^PAADMi("DisDateDep",LocId,DischgDate,DisAdmRowId))
				quit:DisAdmRowId=""
				
				set ^TEMPDHCPORDD21101($j,"DischgAdm",DisAdmRowId)=1				//出院患者就诊号	
			}	
		}
	}
	
	set (BilldPatients,BilldOPatNum,BilldIPatNum,DischgPatNum)=0						//初始化人数
	set (BilldPatFee,BilldOPatFee,BilldIPatFee,DischgPatFee)=0.0000						//初始化费用
	set (BPFAverage,BOPFAverage,BIPFAverage,DPFAverage)=0.0000							//初始化次均费用
	
	set PBAdmId=""
	for {
		set PBAdmId=$o(^TEMPDHCPORDD21101($j,"PBAdmDr",PBAdmId))
		quit:PBAdmId=""
		
		set PBAdmType=$P($G(^PAADM(PBAdmId)),"^",2)									//就诊类型
		continue:PBAdmType=""	
		
		set BilldAdmFee=..GetBillFeeByAdm(PBAdmId)
		set BilldPatients=BilldPatients+1											//账单人数
		set BilldPatFee=BilldPatFee+$G(BilldAdmFee)									//账单人数费用
		
		if PBAdmType="I" {
			set BilldIPatNum=BilldIPatNum+1											//账单住院人数
			set BilldIPatFee=BilldIPatFee+$G(BilldAdmFee)							//账单住院人数发生费用
		}
		if PBAdmType="O" {
			set BilldOPatNum=BilldOPatNum+1											//账单门诊人数
			set BilldOPatFee=BilldOPatFee+$G(BilldAdmFee)							//账单门诊人数发生费用
		}
	}
	
	set DisAdmId=""
	for {
		set DisAdmId=$o(^TEMPDHCPORDD21101($j,"DischgAdm",DisAdmId))
		quit:DisAdmId=""
		
		set DisBilldFee=..GetBillFeeByAdm(DisAdmId)
		set DischgPatNum=DischgPatNum+1												//出院患者人数
		set DischgPatFee=DischgPatFee+$G(DisBilldFee)								//出院患者账单发生费用
	}	
	
	if BilldPatients'=0 set BPFAverage=$fn(BilldPatFee/BilldPatients,"",2)			//账单次均费用
	else  set BPFAverage=$fn(0,"",2)
	
	if BilldOPatNum'=0 set BOPFAverage=$fn(BilldOPatFee/BilldOPatNum,"",2)			//门诊账单次均费用
	else  set BOPFAverage=$fn(0,"",2)
	
	if BilldIPatNum'=0 set BIPFAverage=$fn(BilldIPatFee/BilldIPatNum,"",2)			//住院账单次均费用
	else  set BIPFAverage=$fn(0,"",2)
	
	if DischgPatNum'=0 set DPFAverage=$fn(DischgPatFee/DischgPatNum,"",2)			//出院账单次均费用
	else  set DPFAverage=$fn(0,"",2)
	
	s BilldPatFee=$fn(+BilldPatFee/10000,"",2)
	s BilldOPatFee=$fn(+BilldOPatFee/10000,"",2)
	s BilldIPatFee=$fn(+BilldIPatFee/10000,"",2)
	s DischgPatFee=$fn(+DischgPatFee/10000,"",2)
	
	set ^||CacheTemp(repid,ind)=$lb(ind,BilldPatients,BilldPatFee,BPFAverage,BilldOPatNum,BilldOPatFee,BOPFAverage,BilldIPatNum,BilldIPatFee,BIPFAverage,DischgPatNum,DischgPatFee,DPFAverage)
	set ind=ind+1	
	w "Time="_($P($H,",",2)-startTime),!	
	Quit $$$OK
}

/// 根据就诊号获取患者账单发生费用
/// DanPJ  2020-12-11
/// w ##class(DtPortal.DD.DD21TodayLocFee).GetBillFeeByAdm(245)
ClassMethod GetBillFeeByAdm(AdmRowId As %String) As %String
{
	set AdmFee=0.0000					//初始化就诊患者费用
	quit:AdmRowId="" AdmFee
	//^DHCPB(0,"ADM",{PB_Adm_Dr},{PB_RowId})
	set PBRowId=""
	for {
		set PBRowId=$o(^DHCPB(0,"ADM",AdmRowId,PBRowId))
		quit:PBRowId=""	
		
		//^DHCPB({DHC_PatientBill.PB_RowId},"O",{PBO_ChildSub})
		set PBOChildSub=""
		for {
			set PBOChildSub=$o(^DHCPB(PBRowId,"O",PBOChildSub))	
			quit:PBOChildSub=""
			
			//^DHCPB({DHC_PatientBill.PB_RowId},"O",{DHC_PatBillOrder.PBO_ChildSub},"D",{PBD_ChildSub})
			set PBDChildSub=""
			for {
				set PBDChildSub=$o(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub))	
				quit:PBDChildSub=""
				
				continue:$G(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub))=""							//过滤数据为空
			
				//^DHCPB({DHC_PatientBill.PB_RowId},"O",{DHC_PatBillOrder.PBO_ChildSub},"D",{PBD_ChildSub})	
				set PBDTotalAmount=$P($G(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub)),"^",7)		//获取账单费用
				
				set AdmFee=AdmFee+$G(PBDTotalAmount)
			}
		}
	}	
	quit AdmFee
}

}
