/// 名称: DHCMed.INFService.MonthMonitor
/// 描述: DHCMed.INFService.MonthMonitor 医院感染病例监测月报表
/// 编写者：LYH
/// 编写日期: 2011-05-31
Class DHCMed.INFService.MonthMonitor Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     LYH
/// CreatDate：   2011-05-31
/// Description:  查询医院感染病例信息
/// Input
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.MonthMonitor","QryMonthInfo","2011-06-02","2011-06-02","")
Query QryMonthInfo(SDate As %String, EDate As %String, Ctloc As %String) As %Query(ROWSPEC = "LocDesc:%String,LocAdmCount:%String,InfNum:%String,InfLateNum:%String,InfHXNum:%String,InfXYNum:%String,InfXHNum:%String,InfMNNum:%String,InfSSNum:%String,InfPFNum:%String,InfKQNum:%String,InfQtherNum:%String,InfIRate:%String,InfLateRate:%String,InfRate:%String")
{
}

ClassMethod QryMonthInfoExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, Ctloc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:SDate="" $$$OK
	q:EDate="" $$$OK
	
	s:SDate["-" SDate=$zdh(SDate,3)
	s:SDate["/" SDate=$zdh(SDate,1)
	s:EDate["-" EDate=$zdh(EDate,3)
	s:EDate["/" EDate=$zdh(EDate,1)
	k ^CacheTemp("DHCMedMonthMonitor")

    //^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
	f DischDate=SDate:1:EDate d
    .s Paadm=0
	.f  s Paadm=$o(^PAADMi("DischDate",DischDate,Paadm)) q:Paadm=""  d
	..s AdmInfo=$g(^PAADM(Paadm))
	..q:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
	..q:$p(AdmInfo,"^",20)="C"  //就诊状态过滤
	..//Continue:$d(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",Paadm))  //招回病人不算出院
	..s LocID=$p(AdmInfo,"^",4)     //就诊科室
	..q:LocID=""
	..q:(Ctloc'="")&(Ctloc'=LocID)
	..s AdmitDate=$p(AdmInfo,"^",6)  //就诊日期
	..s DischDate=$p(AdmInfo,"^",17) //出院日期
	..s Num=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID))	//科室出院病人数量
	..s InfRepID=""
	..f  s InfRepID=$o(^DHCMed.INF.ReportD(InfRepID)) q:InfRepID=""  d
	...s InfRepObj=##Class(DHCMed.INF.Report).GetObjById(InfRepID)
	...q:InfRepObj.Type'=1
	...s PaadmDR=InfRepObj.PaadmDR
	...q:PaadmDR'=Paadm
	...q:InfRepObj.StatusDr=0	//删除的报告不计算
	...s InfNum=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf")) //科室院感例次
	...s InfStaDtlsID=$o(^DHCMed.INF.RepStatusDtlsI("InfRepDr",InfRepID,""))
	...s InfStaDtlsObj=##Class(DHCMed.INF.RepStatusDtls).GetObjById(InfStaDtlsID)
	...s InfUpdateDate=InfStaDtlsObj.UpdateDate
	...i InfUpdateDate>DischDate d
	....s InfLateNum=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfLate")) //科室漏报病例数
	...s SumID=$o(^DHCMed.INF.SummaryI("InfRepDr",InfRepID,""))
	...q:SumID=""
	...s InfPosID=$o(^DHCMed.INF.RepPosI("InfRepDr",SumID,""))
	...s InfPosObj=##Class(DHCMed.INF.RepPos).GetObjById(InfPosID)
	...s InfPosCode=InfPosObj.InfPosCode
	...i InfPosCode=1  d //感染部位为呼吸系统
	....s InfHXNum=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfHXNum"))
	...i InfPosCode=3  d //感染部位为血液系统
	....s InfXYNum=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfXYNum"))
	...i InfPosCode=4  d //感染部位为消化系统
	....s InfXHNum=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfXHNum"))
	...i InfPosCode=6  d //感染部位为泌尿系统
	....s InfMNNum=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfMNNum"))
	...i InfPosCode=7  d //感染部位为手术部位系统
	....s InfSSNum=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfSSNum"))
	...i InfPosCode=8  d //感染部位为皮肤和软组织系统
	....s InfPFNum=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfPFNum"))
	...i InfPosCode=11  d //感染部位为口腔系统
	....s InfKQNum=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfKQNum"))
    ...s InfDays=InfPosObj.InfDays		//中山三院此字段表示 切口类型 I/II/III   I表示无菌切口
    ...i InfDays="I" d
    ....s InfINum=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfINum")) //科室无菌切口感染数
    
    s (TLocAdmCount,TInfNum,TInfLateNum,TInfHXNum,TInfXYNum,TInfXHNum,TInfMNNum,TInfSSNum,TInfPFNum,TInfKQNum,TInfQtherNum,TInfINum,TInfIRate,TInfLateRate,TInfRate)=0
    s LocID=0
    f  s LocID=$o(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID)) q:LocID=""  d
    .s LocDesc=$p($g(^CTLOC(LocID)),"^",2)
    .s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)	//科室
    .s LocAdmCount=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID)) //科室出院人数
    .s InfNum=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf")) //科室感染例次数
    .s InfLateNum=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfLate")) //科室漏报例次数
    .s InfHXNum=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfHXNum")) //呼吸
    .s InfXYNum=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfXYNum")) //血液
    .s InfXHNum=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfXHNum")) //消化
    .s InfMNNum=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfMNNum")) //泌尿
    .s InfSSNum=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfSSNum")) //手术
    .s InfPFNum=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfPFNum")) //皮肤
    .s InfKQNum=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfKQNum")) //口腔
    .s InfQtherNum=InfNum-InfHXNum-InfXYNum-InfXHNum-InfMNNum-InfSSNum-InfPFNum-InfKQNum //其它
    .s:InfQtherNum<0 InfQtherNum=0
    .s InfINum=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfINum")) //科室无菌切口感染数
    .s InfIRate=0,InfLateRate=0,InfRate=0
    .s:(LocAdmCount>0)&(InfINum>0) InfIRate=$fn((InfINum/LocAdmCount)*100,"",2)_"%" //科室无菌感染率
    .s:(InfNum>0)&(InfLateNum>0) InfLateRate=$fn((InfLateNum/InfNum)*100,"",2)_"%" //院感漏报率
    .s:(LocAdmCount>0)&(InfNum>0) InfRate=$fn((InfNum/LocAdmCount)*100,"",2)_"%" //院感例次率
    .;$fn((InCPWNum/AdmNum)*100,"",2)_"%"
    .s TLocAdmCount=TLocAdmCount+LocAdmCount
    .s TInfNum=TInfNum+InfNum
    .s TInfINum=TInfINum+InfINum
    .s TInfLateNum=TInfLateNum+InfLateNum
    .s TInfHXNum=TInfHXNum+InfHXNum
    .s TInfXYNum=TInfXYNum+InfXYNum
    .s TInfXHNum=TInfXHNum+InfXHNum
    .s TInfMNNum=TInfMNNum+InfMNNum
    .s TInfSSNum=TInfSSNum+InfSSNum
    .s TInfPFNum=TInfPFNum+InfPFNum
    .s TInfKQNum=TInfKQNum+InfKQNum
    .s TInfQtherNum=TInfQtherNum+InfQtherNum
    
    
    
    .s Data=$lb(LocDesc,LocAdmCount,InfNum,InfLateNum,InfHXNum,InfXYNum,InfXHNum,InfMNNum,InfSSNum,InfPFNum,InfKQNum,InfQtherNum,InfIRate,InfLateRate,InfRate)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
    
    
    s:(TLocAdmCount>0)&(TInfINum>0) TInfIRate=$fn((TInfINum/TLocAdmCount)*100,"",2)_"%" //全院无菌感染率
    s:(TInfNum>0)&(TInfLateNum>0) TInfLateRate=$fn((TInfLateNum/TInfNum)*100,"",2)_"%" //全院院感漏报率
    s:(TLocAdmCount>0)&(TInfNum>0) TInfRate=$fn((TInfNum/TLocAdmCount)*100,"",2)_"%" //全院院感例次率
    
    s Data=$lb("合计",TLocAdmCount,TInfNum,TInfLateNum,TInfHXNum,TInfXYNum,TInfXHNum,TInfMNNum,TInfSSNum,TInfPFNum,TInfKQNum,TInfQtherNum,TInfIRate,TInfLateRate,TInfRate)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
    
	Quit $$$OK
}

ClassMethod QryMonthInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMonthInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMonthInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMonthInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##Class(DHCMed.INFService.MonthMonitor).GetMonthInfo("fillxlSheet","2010-01-01^2012-01-01^")
ClassMethod GetMonthInfo(itmjs As %String, strArguments As %String) As %String
{
	n (itmjs,strArguments)
	s Count=0
	s SDate=$p(strArguments,"^",1)
	s EDate=$p(strArguments,"^",2)
	s Ctloc=$p(strArguments,"^",3)

	s ds = ##class(%Library.ResultSet).%New("DHCMed.INFService.MonthMonitor:QryMonthInfo")
	d ds.Execute(SDate,EDate,Ctloc)
	s StartRow=8
	while(ds.Next())
	{
		s LocDesc=ds.Data("LocDesc")
		s LocAdmCount=ds.Data("LocAdmCount")
		s InfNum=ds.Data("InfNum")
		s InfLateNum=ds.Data("InfLateNum")
		s InfHXNum=ds.Data("InfHXNum")
		s InfXYNum=ds.Data("InfXYNum")
		s InfXHNum=ds.Data("InfXHNum")
		s InfMNNum=ds.Data("InfMNNum")
		s InfSSNum=ds.Data("InfSSNum")
		s InfPFNum=ds.Data("InfPFNum")
		s InfKQNum=ds.Data("InfKQNum")
		s InfQtherNum=ds.Data("InfQtherNum")
		s InfIRate=ds.Data("InfIRate")
		s InfLateRate=ds.Data("InfLateRate")
		s InfRate=ds.Data("InfRate")
		
		s valCells=LocDesc_$c(1)_LocAdmCount_$c(1)_InfNum_$c(1)_InfLateNum_$c(1)_InfHXNum_$c(1)_InfXYNum_$c(1)_InfXHNum_$c(1)_InfMNNum_$c(1)_InfSSNum_$c(1)_InfPFNum_$c(1)_InfKQNum_$c(1)_InfQtherNum_$c(1)_InfIRate_$c(1)_InfLateRate_$c(1)_InfRate
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	d ds.Close()
	
	q Count
}

}
