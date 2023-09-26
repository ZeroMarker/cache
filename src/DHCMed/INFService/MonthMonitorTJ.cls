/// 名称: DHCMed.INFService.MonthMonitorTJ
/// 描述: DHCMed.INFService.MonthMonitorTJ 医院感染病例监测月报表
/// 编写者：LYH
/// 编写日期: 2011-07-01
Class DHCMed.INFService.MonthMonitorTJ Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     LYH
/// CreatDate：   2011-07-01
/// Description:  查询医院感染病例信息
/// Input
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.MonthMonitorTJ","QryMonthInfo","2011-06-01","2012-01-01","")
Query QryMonthInfo(SDate As %String, EDate As %String, Ctloc As %String) As %Query(ROWSPEC = "LocDesc:%String,LocAdmCount:%String,InfPatNum:%String,InfNum:%String,InfLateNum:%String,InfIOpeNum:%String,InfWJNum:%String,Inf1Num:%String,Inf2Num:%String,Inf3Num:%String,Inf4Num:%String,Inf5Num:%String,Inf6Num:%String,Inf7Num:%String,Inf8Num:%String,Inf9Num:%String,Inf10Num:%String,Inf11Num:%String,Inf12Num:%String,InfIRate:%String,InfLateRate:%String,InfRate:%String")
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
	
	s InfPatNum=0,InfIOpeNum=0,InfWJNum=0
	
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
	...i '$d(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Paadm",Paadm)) d
	....s InfPatNum=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfPatNum"))	//科室院感人数
	....s ^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Paadm",Paadm)=""
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
	
	
	...i InfPosCode=1  d
	....s Inf1Num=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf1Num"))
	...i InfPosCode=2  d
	....s Inf2Num=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf2Num"))
	...i InfPosCode=3  d
	....s Inf3Num=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf3Num"))
	...i InfPosCode=4  d
	....s Inf4Num=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf4Num"))
	...i InfPosCode=5  d
	....s Inf5Num=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf5Num"))
	...i InfPosCode=6  d
	....s Inf6Num=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf6Num"))
	...i InfPosCode=7  d
	....s Inf7Num=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf7Num"))
    ...i InfPosCode=8  d
	....s Inf8Num=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf8Num"))
	...i InfPosCode=9  d
	....s Inf9Num=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf9Num"))
	....i InfPosCode=10  d
	....s Inf10Num=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf10Num"))
	...i InfPosCode=11  d 
	....s Inf11Num=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf11Num"))
	...i InfPosCode=12  d 
	....s Inf12Num=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf12Num"))
    
    
    
    ...s InfDays=InfPosObj.InfDays		//中山三院此字段表示 切口类型 I/II/III   I表示无菌切口
    ...i InfDays="I" d
    ....s InfINum=$i(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfINum")) //科室无菌切口感染数
    
    s (TLocAdmCount,TInfNum,TInfPatNum,TInfLateNum,TInfIOpeNum,TInfWJNum,TInf1Num,TInf2Num,TInf3Num,TInf4Num,TInf5Num,TInf6Num,TInf7Num,TInf8Num,TInf9Num,TInf10Num,TInf11Num,TInf12Num,TInfQtherNum,TInfINum,TInfIRate,TInfLateRate,TInfRate)=0
    s LocID=0
    f  s LocID=$o(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID)) q:LocID=""  d
    .s LocDesc=$p($g(^CTLOC(LocID)),"^",2)
    .s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)	//科室
    .s LocAdmCount=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID)) //科室出院人数
    .s InfPatNum=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfPatNum")) //科室院感人数
    .s InfNum=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf")) //科室感染例次数
    .s InfLateNum=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfLate")) //科室漏报例次数
    .s Inf1Num=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf1Num")) 
    .s Inf2Num=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf2Num")) 
    .s Inf3Num=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf3Num")) 
    .s Inf4Num=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf4Num")) 
    .s Inf5Num=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf5Num")) 
    .s Inf6Num=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf6Num")) 
    .s Inf7Num=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf7Num")) 
  	.s Inf8Num=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf8Num")) 
    .s Inf9Num=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf9Num")) 
    .s Inf10Num=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf10Num")) 
    .s Inf11Num=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf11Num")) 
    .s Inf12Num=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"Inf12Num"))
  
  
    .s InfINum=+$g(^CacheTemp("DHCMedMonthMonitor",$zn,$j,"Ctloc",LocID,"InfINum")) //科室无菌切口感染数
    .s InfIRate=0,InfLateRate=0,InfRate=0
    .s:(LocAdmCount>0)&(InfINum>0) InfIRate=$fn((InfINum/LocAdmCount)*100,"",2)_"%" //科室无菌感染率
    .s:(InfNum>0)&(InfLateNum>0) InfLateRate=$fn((InfLateNum/InfNum)*100,"",2)_"%" //院感漏报率
    .s:(LocAdmCount>0)&(InfNum>0) InfRate=$fn((InfNum/LocAdmCount)*100,"",2)_"%" //院感例次率
    .;$fn((InCPWNum/AdmNum)*100,"",2)_"%"
    .s TLocAdmCount=TLocAdmCount+LocAdmCount
    .s TInfNum=TInfNum+InfNum
    .s TInfPatNum=TInfPatNum+InfPatNum
    .s TInfINum=TInfINum+InfINum
    .s TInfLateNum=TInfLateNum+InfLateNum
    .s TInf1Num=TInf1Num+Inf1Num
    .s TInf2Num=TInf2Num+Inf2Num
    .s TInf3Num=TInf3Num+Inf3Num
    .s TInf4Num=TInf4Num+Inf4Num
    .s TInf5Num=TInf5Num+Inf5Num
    .s TInf6Num=TInf6Num+Inf6Num
    .s TInf7Num=TInf7Num+Inf7Num
    .s TInf8Num=TInf8Num+Inf8Num
    .s TInf9Num=TInf9Num+Inf9Num
    .s TInf10Num=TInf10Num+Inf10Num
    .s TInf11Num=TInf11Num+Inf11Num
    .s TInf12Num=TInf12Num+Inf12Num
    
    .s Data=$lb(LocDesc,LocAdmCount,InfPatNum,InfNum,InfLateNum,InfIOpeNum,InfWJNum,Inf1Num,Inf2Num,Inf3Num,Inf4Num,Inf5Num,Inf6Num,Inf7Num,Inf8Num,Inf9Num,Inf10Num,Inf11Num,Inf12Num,InfIRate,InfLateRate,InfRate)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
    
    
    s:(TLocAdmCount>0)&(TInfINum>0) TInfIRate=$fn((TInfINum/TLocAdmCount)*100,"",2)_"%" //全院无菌感染率
    s:(TInfNum>0)&(TInfLateNum>0) TInfLateRate=$fn((TInfLateNum/TInfNum)*100,"",2)_"%" //全院院感漏报率
    s:(TLocAdmCount>0)&(TInfNum>0) TInfRate=$fn((TInfNum/TLocAdmCount)*100,"",2)_"%" //全院院感例次率
    
    s Data=$lb("合计",TLocAdmCount,TInfPatNum,TInfNum,TInfLateNum,TInfIOpeNum,TInfWJNum,TInf1Num,TInf2Num,TInf3Num,TInf4Num,TInf5Num,TInf6Num,TInf7Num,TInf8Num,TInf9Num,TInf10Num,TInf11Num,TInf12Num,TInfIRate,TInfLateRate,TInfRate)
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

/// w ##Class(DHCMed.INFService.MonthMonitorTJ).GetMonthInfo("fillxlSheet","2010-01-01^2012-01-01^")
ClassMethod GetMonthInfo(itmjs As %String, strArguments As %String) As %String
{
	n (itmjs,strArguments)
	s Count=0
	s SDate=$p(strArguments,"^",1)
	s EDate=$p(strArguments,"^",2)
	s Ctloc=$p(strArguments,"^",3)

	s ds = ##class(%Library.ResultSet).%New("DHCMed.INFService.MonthMonitorTJ:QryMonthInfo")
	d ds.Execute(SDate,EDate,Ctloc)
	s StartRow=7
	while(ds.Next())
	{
		s LocDesc=ds.Data("LocDesc")
		s LocAdmCount=ds.Data("LocAdmCount")
		s InfPatNum=ds.Data("InfPatNum")
		s InfNum=ds.Data("InfNum")
		s InfLateNum=ds.Data("InfLateNum")
		s InfIOpeNum=ds.Data("InfIOpeNum")
		s InfWJNum=ds.Data("InfWJNum")
		s Inf1Num=ds.Data("Inf1Num")
		s Inf2Num=ds.Data("Inf2Num")
		s Inf3Num=ds.Data("Inf3Num")
		s Inf4Num=ds.Data("Inf4Num")
		s Inf5Num=ds.Data("Inf5Num")
		s Inf6Num=ds.Data("Inf6Num")
		s Inf7Num=ds.Data("Inf7Num")
		s Inf8Num=ds.Data("Inf8Num")
		s Inf9Num=ds.Data("Inf9Num")
		s Inf10Num=ds.Data("Inf10Num")
		s Inf11Num=ds.Data("Inf11Num")
		s Inf12Num=ds.Data("Inf12Num")
		s InfIRate=ds.Data("InfIRate")
		s InfLateRate=ds.Data("InfLateRate")
		s InfRate=ds.Data("InfRate")
		
		s valCells=LocDesc_$c(1)_LocAdmCount_$c(1)_InfPatNum_$c(1)_InfNum_$c(1)_InfLateNum_$c(1)_InfIOpeNum_$c(1)_InfWJNum_$c(1)_Inf1Num_$c(1)_Inf2Num_$c(1)_Inf3Num_$c(1)_Inf4Num_$c(1)_Inf5Num_$c(1)_Inf6Num_$c(1)_Inf7Num_$c(1)_Inf8Num_$c(1)_Inf9Num_$c(1)_Inf10Num_$c(1)_Inf11Num_$c(1)_Inf12Num_$c(1)_InfIRate_$c(1)_InfLateRate_$c(1)_InfRate
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	d ds.Close()
	
	q Count
}

}
