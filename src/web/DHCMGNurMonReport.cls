Class web.DHCMGNurMonReport Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: 	wxl
/// CreatDate: 	2010-06-22
/// Description:护理技术操作培训考评情况
/// Table：		User.DHCMGNurTrainExam
/// Input：		parr(科室^护士^开始日期^结束日期^)
/// Return：	depdes,person,content,score,date,typ,rw
/// 			科室,人员,内容,分数,日期,类型,RowID
ClassMethod GetNurTrainExamExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="1^^2010-06-22^2010-06-22"
 	//d ##class(%ResultSet).RunQuery("web.DHCMGNurMonReport","GetNurTrainExam","1^^2010-06-22^2010-06-22")
 	s loc=$P(parr,"^")
 	s per=$P(parr,"^",2)
 	s sdate=$P(parr,"^",3)
 	s edate=$P(parr,"^",4)
 	s examtyp=$P(parr,"^",5)
 	i sdate'="" s sdate=$ZDH(sdate,3)
 	i edate'="" s edate=$ZDH(edate,3)
 	if (loc="")!(sdate="")!(edate="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
	for curdate=sdate:1:edate
	{
		s dep=""  f  s dep=$O(^User.DHCMGNurTrainExamI("DateDep",curdate,dep)) q:(dep="")!(dep=" ")  d
		.s curdep=$Tr(dep," ","")
		.q:(curdep'=loc)&(loc'="")
		.s rw=""  f  s rw=$O(^User.DHCMGNurTrainExamI("DateDep",curdate,dep,rw)) q:rw=""  d
		..d out	
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (depdes,person,content,score)=""
    s a=^User.DHCMGNurTrainExamD(rw)
    s depdr=$List(a,4)
    if depdr'="" s depdes=$P(^CTLOC(depdr),"^",2)
    e  s depdes=""
    s nur=$List(a,5)
    if (nur'=per)&(per'="") q        
    s parr=^User.DHCMGPersonsD(nur)
    s person=$list(parr,21)
    s content=$List(a,2)
    s score=$List(a,6)
    s date=$List(a,3)
    if date'="" s date=$ZD(date,3)
    s typdr=$ListGet(a,7)
    if (examtyp'="")&(typdr'=examtyp) q
    if typdr'="" s typ=$List($G(^User.DHCMGNurExamTypD(typdr)),3)
    e  s typ=""
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,person,content,score,date,typ,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetNurTrainExamFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNurTrainExamExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetNurTrainExamClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNurTrainExamExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetNurTrainExam(parr As %String) As %Query(ROWSPEC = "depdes,person,content,score,date,typ,rw")
{
}

/// Creator: 	wxl
/// CreatDate: 	2010-06-22
/// Description:培训/考核/质控类型
/// Table：		User.DHCMGNurExamTyp
/// Input：		parr(描述)
/// Return：	code,desc,rw
/// 			代码,描述,ROwID
ClassMethod GetNurExamTypExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="1^^2010-06-22^2010-06-22"
 	//d ##class(%ResultSet).RunQuery("web.DHCMGNurMonReport","GetNurExamTyp","")
 	s desc=$P(parr,"^")	
	s rw=""  f  s rw=$O(^User.DHCMGNurExamTypD(rw)) q:(rw="")  d
	.s a=^User.DHCMGNurExamTypD(rw)
	.s examcode=$List(a,2)
	.s examdesc=$List(a,3)
	.q:(desc'="")&(examdesc'[desc)
	.s qualcode=$ListGet(a,4)
	.s examtype=""
	.i qualcode'="" d
	..s ret=##class(User.DHCMGNurExamTyp).GetExamTyp(qualcode)
	..i ret'="" d
	...s examtype=$P(ret,"^",1)
	...i $L(examtype,"|")>1 s examtype=$P(examtype,"|",2)
	.d output
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
output
	set Data=$lb(examcode,examdesc,examtype,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetNurExamTypFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNurExamTypExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetNurExamTypClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNurExamTypExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetNurExamTyp(parr As %String) As %Query(ROWSPEC = "examcode,examdesc,examtype,rw")
{
}

/// Creator: 	wxl
/// CreatDate: 	2010-06-22
/// Description:取质控记录(总数/平均分/合格率界面)
/// Table:		User.DHCMGNurExamQual
/// Input:		parr(科室^开始日期^结束日期^是否平均^HIS安全组^登陆用户)
/// Return：
ClassMethod GetDepQual(parr As %String) As %String
{
	//w ##class(web.DHCMGNurMonReport).GetDepQual("1^2010-07-01^2010-07-31^N^1^1^OP")
	s dep=$P(parr,"^",1)
	s stdate=$P(parr,"^",2)
	s edate=$P(parr,"^",3)
	s flag=$P(parr,"^",4)
	s SSGroup=$P(parr,"^",5)
	s Group=##class(User.DHCMGSSGRPRELHISGRP).getgrp(SSGroup)
	s Group=+Group		//1^A
	q:Group=0 ""
	s deptyp=$P(Group,"^",2)
	s UserID=$P(parr,"^",6)
	s type=$P(parr,"^",7)
	s StYear=+$P(stdate,"-",1)
	s StMonth=+$P(stdate,"-",2)
	s EndYear=+$P(edate,"-",1)
	s EndMonth=+$P(edate,"-",2)
	s YearMonth=""
	for Year=StYear:1:EndYear
	{
		for Month=StMonth:1:EndMonth
		{
			i YearMonth="" s YearMonth=Year_"-"_Month
			e  s YearMonth=YearMonth_"^"_Year_"-"_Month
		}
	}
	i stdate'="" s stdate=$ZDH(stdate,3)
	i edate'="" s edate=$ZDH(edate,3)
	k DepQual
    for date=stdate:1:edate
    {
		s loc="" f  s loc=$O(^User.DHCMGNurExamQualI("DepDate"," "_Group,loc)) q:loc=""  d
		.s curloc=$Tr(loc," ","")
		.q:(dep'="")&(dep'=curloc)
		.s rw="" f  s rw=$O(^User.DHCMGNurExamQualI("DepDate"," "_Group,loc,date,rw)) q:rw=""  d
		..s StYear=+$P($ZD(date,3),"-",1)
		..s StMonth=+$P($ZD(date,3),"-",2)
		..s StYearMonth=StYear_"-"_StMonth
		..s Qual=^User.DHCMGNurExamQualD(rw)
		..s QualDep=$List(Qual,2)
		..s QualItm=$List(Qual,3)
		..q:QualItm=""
		..s QualNum=$List(Qual,4)
		..s QualScore=$List(Qual,5)
		..s QualPercent=$List(Qual,6)
		..s QualStDate=$List(Qual,10)
		..s QualEndDate=$List(Qual,11)
		..s QualRecUser=$List(Qual,9)
		..s QualRecDate=$List(Qual,7)
		..s QualRecTime=$List(Qual,8)
		..s QualCareNum=$List(Qual,14)
		..s QualDischNum=$List(Qual,15)
		..s QualDischScore=$List(Qual,17)
		..s QualDischPercent=$List(Qual,16)
		..s DepQual(QualDep,StYearMonth,QualItm)=QualCareNum_"^"_QualNum_"^"_QualScore_"^"_QualPercent_"^"_QualDischNum_"^"_QualDischScore_"^"_QualDischPercent_"^"_rw
    }
    b //000
	i deptyp="" s deptyp="NUR"
	//s ret=##class(web.DHCMGPERSON).GetSortDep(deptyp)
	s ret=##class(User.DHCMGNurExamDepSort).GetSortDep(type)
	s groupdesc=..GetGroup(Group_"^M")
	if groupdesc["科护士长" d  //"科护士长"
	.s ret=##class(User.DHCMGNurExamDep).GetNurDep(UserID)
	s ln=$L(ret,"^")
	s Itm=##class(User.DHCMGNurExamTyp).GetExamCode("QUAL^"_type)
	s ItmLn=$L(Itm,"^")
	s YearMonthLn=$L(YearMonth,"^")
	k AveDepQual
	s datatb=""
	for i=1:1:ln
	{
		s curdep=$P(ret,"^",i)
		if curdep="" continue
		s rowdata=""
		s depId=$P(curdep,"|",1),depdes=$P(curdep,"|",2)
		i $L(depdes,"-")>1 s depdes=$P(depdes,"-",2)
		if ((depId'=dep)&(dep'="")) continue
		s averowdata=""
		for j=1:1:YearMonthLn
		{
			s StYearMonth=$P(YearMonth,"^",j)
			if StYearMonth="" continue
			s rowdata=""
			if $D(DepQual(depId,StYearMonth))>0 
			{
				b //1
				for k=1:1:ItmLn
				{
					s QualItm=$P(Itm,"^",k)
					s QualRw=$P(QualItm,"|",1)
					if QualRw="" continue
					s CareNum=$P($G(DepQual(depId,StYearMonth,QualRw)),"^",1)
					s Num=$P($G(DepQual(depId,StYearMonth,QualRw)),"^",2)
					s Score=$P($G(DepQual(depId,StYearMonth,QualRw)),"^",3)
					s Percent=$P($G(DepQual(depId,StYearMonth,QualRw)),"^",4)
					s DischNum=$P($G(DepQual(depId,StYearMonth,QualRw)),"^",5)
					s DischScore=$P($G(DepQual(depId,StYearMonth,QualRw)),"^",6)
					s DischPercent=$P($G(DepQual(depId,StYearMonth,QualRw)),"^",7)
					s RowId=$P($G(DepQual(depId,StYearMonth,QualRw)),"^",8)
					s rowdata=rowdata_CareNum_"^"_Num_"^"_Score_"^"_Percent_"^"_DischNum_"^"_DischScore_"^"_DischPercent_"^"_RowId_"^"
					s $P(AveDepQual(depId,QualRw),"^",1)=+$P($G(AveDepQual(depId,QualRw)),"^",1)+CareNum
					s $P(AveDepQual(depId,QualRw),"^",2)=+$P($G(AveDepQual(depId,QualRw)),"^",2)+Num
					s $P(AveDepQual(depId,QualRw),"^",3)=+$P($G(AveDepQual(depId,QualRw)),"^",3)+Score
					s $P(AveDepQual(depId,QualRw),"^",4)=+$P($G(AveDepQual(depId,QualRw)),"^",4)+Percent
					s $P(AveDepQual(depId,QualRw),"^",5)=+$P($G(AveDepQual(depId,QualRw)),"^",5)+DischNum
					s $P(AveDepQual(depId,QualRw),"^",6)=+$P($G(AveDepQual(depId,QualRw)),"^",6)+DischScore
					s $P(AveDepQual(depId,QualRw),"^",7)=+$P($G(AveDepQual(depId,QualRw)),"^",7)+DischPercent
					s $P(AveDepQual(depId,QualRw),"^",8)=""
				}	
			}
			else
			{
				b //2
				for k=1:1:ItmLn
				{
					s QualItm=$P(Itm,"^",k)
					s QualRw=$P(QualItm,"|",1)
					if QualRw="" continue
					s CareNum=""
					s Num=""
					s Score=""
					s Percent=""
					s DischNum=""
					s DischScore=""
					s DischPercent=""
					s RowId=""
					s rowdata=rowdata_CareNum_"^"_Num_"^"_Score_"^"_Percent_"^"_DischNum_"^"_DischScore_"^"_DischPercent_"^"_RowId_"^"
					s $P(AveDepQual(depId,QualRw),"^",1)=+$P($G(AveDepQual(depId,QualRw)),"^",1)+CareNum
					s $P(AveDepQual(depId,QualRw),"^",2)=+$P($G(AveDepQual(depId,QualRw)),"^",2)+Num
					s $P(AveDepQual(depId,QualRw),"^",3)=+$P($G(AveDepQual(depId,QualRw)),"^",3)+Score
					s $P(AveDepQual(depId,QualRw),"^",4)=+$P($G(AveDepQual(depId,QualRw)),"^",4)+Percent
					s $P(AveDepQual(depId,QualRw),"^",5)=+$P($G(AveDepQual(depId,QualRw)),"^",5)+DischNum
					s $P(AveDepQual(depId,QualRw),"^",6)=+$P($G(AveDepQual(depId,QualRw)),"^",6)+DischScore
					s $P(AveDepQual(depId,QualRw),"^",7)=+$P($G(AveDepQual(depId,QualRw)),"^",7)+DischPercent
					s $P(AveDepQual(depId,QualRw),"^",8)=""			
				}	
			}
			b //3
			if (flag="Y")&(j=YearMonthLn) 
			{
				for k=1:1:ItmLn
				{
					s QualItm=$P(Itm,"^",k)
					s QualRw=$P(QualItm,"|",1)
					if QualRw="" continue
					s QualScore=$P(AveDepQual(depId,QualRw),"^",3)
					s QualScore=QualScore/YearMonthLn
					if $L(QualScore,".")>1 s $P(AveDepQual(depId,QualRw),"^",3)=$Fn(QualScore,"",1)
					else  s $P(AveDepQual(depId,QualRw),"^",3)=QualScore
					s QualPercent=$P(AveDepQual(depId,QualRw),"^",4)
					s QualPercent=QualPercent/YearMonthLn
					if $L(QualPercent,".")>1 s $P(AveDepQual(depId,QualRw),"^",4)=$Fn(QualPercent,"",1)_"%"
					else  s $P(AveDepQual(depId,QualRw),"^",4)=QualPercent		//_"%" 
					s QualDischScore=$P(AveDepQual(depId,QualRw),"^",6)
					s QualDischScore=QualDischScore/YearMonthLn
					if $L(QualDischScore,".")>1 s $P(AveDepQual(depId,QualRw),"^",6)=$Fn(QualDischScore,"",1)
					else  s $P(AveDepQual(depId,QualRw),"^",6)=QualDischScore
					s QualDichPercent=$P(AveDepQual(depId,QualRw),"^",4)
					s QualDichPercent=QualDichPercent/YearMonthLn
					if $L(QualDichPercent,".")>1 s $P(AveDepQual(depId,QualRw),"^",4)=$Fn(QualDichPercent,"",1)_"%"
					else  s $P(AveDepQual(depId,QualRw),"^",4)=QualDichPercent		//_"%" 
					s averowdata=averowdata_AveDepQual(depId,QualRw)_"^"
				}
			}
			if flag'="Y" s datatb=datatb_depId_"^"_depdes_"^"_rowdata_StYearMonth_$C(2)
		}
		if flag="Y" s datatb=datatb_depId_"^"_depdes_"^"_averowdata_$Tr(YearMonth,"^"," ")_$C(2)
	}
	q datatb
}

/// Creator: 	wxl
/// CreatDate: 	2010-06-22
/// Description:保存质控记录(总数/平均分/合格率界面)
/// Table：		
/// Input：		科室1$C(3)开始日期$C(3)结束日期$C(3)月份$C(3)项目!数目!分数!合格率^项目!数目!分数!合格率$C(2)科室2$C(1)录入人
/// Return：	
ClassMethod SaveQual(parr As %String) As %String
{
	//w ##class(web.DHCMGNurMonReport).SaveQual("1"_$C(3)_"2010-07-01"_$C(3)_"2010-07-01"_$C(3)_"1!100!100!100^2!!!^3!!!^4!!!^5!!!^6!!!^7!!!^"_$C(2)_$C(1)_"1")
	s RowData=$P(parr,$C(1),1)
	s User=$P(parr,$C(1),2)
	s SSGroup=$P(parr,$C(1),3)
	s Group=##class(User.DHCMGSSGRPRELHISGRP).getgrp(SSGroup)
	s Group=+Group		//1^A
	q:Group=0 ""
	s Ln=$L(RowData,$C(2))
	for i=1:1:Ln
	{
	    s DepDateData=$P(RowData,$C(2),i)
	    s Dep=$P(DepDateData,$C(3),1)
	    s StDate=$P(DepDateData,$C(3),2)
	    s EndData=$P(DepDateData,$C(3),3)
	    s Mon=$P(DepDateData,$C(3),4)
	    s Data=$P(DepDateData,$C(3),5)    
	    s DataLn=$L(Data,"^")
	    for j=1:1:DataLn
	    {
			s QualItm=$P(Data,"^",j)
			if QualItm="" continue
			s Itm=$P(QualItm,"!",1)
			s Num=$P(QualItm,"!",2)
			s Score=$P(QualItm,"!",3)
			s Percent=$P(QualItm,"!",4)
			s Id=$P(QualItm,"!",5)
			s CareNum=$P(QualItm,"!",6)
			s DischNum=$P(QualItm,"!",7)
			s DischScore=$P(QualItm,"!",8)
			s DischPercent=$P(QualItm,"!",9)
			s par=Id_"^"_Dep_"^"_Itm_"^"_StDate_"^"_EndData_"^"_Num_"^"_Score_"^"_Percent_"^"_User_"^"_Mon_"^"_CareNum_"^"_DischNum_"^"_DischScore_"^"_DischPercent_"^"_Group
			b //001
			s a=##class(User.DHCMGNurExamQual).Save(par)
			i a'=0 q   
		}	    
	}
	q 0
}

/// Creator: 	wxl
/// CreatDate: 	2010-06-08
/// Description:护士长月报表
/// Table：		NurID:护士长的ID	
/// Input：		
/// Return：	
ClassMethod GetNurManagerMon(parr As %String) As %String
{
	//w ##class(web.DHCMGNurMonReport).GetNurManagerMon("^1^1^2010-07-07")
	//"1^^^2010-07-07"
	s MonHosp="",MonDep="",MonUser="",MonYear="",MonMonth="",MonDate="",PerHoliday="",SickLeave="",PersonalLeave="",OutMeeting="",OutAcademic="",PerSchooling="",PerDuty=""
	s AdmissionNum="",OperationNum="",CriticalCare="",FirstCare="",DeathNum="",PraiseNum="",PraisePerson="",CriticizeNum="",CriticizePerson="",ComplainNum="",ComplainPerson="",InfusionReaction="",ComplicationNum="",ComplicationPerson=""
	s NightShift="",OverTime="",OverHours="",MonNote="",AuditDr="",AuditStat=""
	s Data=""
	s ReportId=$P(parr,"^",1)
	if ReportId=""
	{
		s DepId=$P(parr,"^",2)
		s PersonId=$P(parr,"^",3)
		s ReportDate=$P(parr,"^",4)
		
		s HospId=$O(^CT("HOSP",0))
		i HospId'="" s MonHosp=$P(^CT("HOSP",HospId),"^",2)
		s MonDep=DepId
		s MonUser=PersonId
		i ReportDate'="" d
		.s Year=$P(ReportDate,"-",1)
		.s Month=+$P(ReportDate,"-",2)
		.s ReportDate=$ZDH(ReportDate,3)
		e  d
		.s Year=$P($ZD($h,3),"-",1)
		.s Month=+$P($ZD($h,3),"-",2)
		.s ReportDate=+$h
		s MonYear=Year
		s MonMonth=$S(Month=1:"一月",Month=2:"二月",Month=3:"三月",Month=4:"四月",Month=5:"五月",Month=6:"六月",Month=7:"七月",Month=8:"八月",Month=9:"九月",Month=10:"十月",Month=11:"十一月",Month=12:"十二月",1:"")
		s curDate=..GetMonStartEndDate(ReportDate)
		s stdate=$P(curDate,"^",1)
		s edate=$P(curDate,"^",2)

		s PerHoliday=$P(..GetPersonHL(PersonId_"^休^"_stdate_"^"_edate),"^",1)
		s SickLeave=$P(..GetPersonHL(PersonId_"^病假^"_stdate_"^"_edate),"^",1)
		s PersonalLeave=$P(..GetPersonHL(PersonId_"^事假^"_stdate_"^"_edate),"^",1)
		s OutMeeting=$P(..GetPersonHL(PersonId_"^外出开会^"_stdate_"^"_edate),"^",1)
		s OutAcademic=..GetPersonTrain(PersonId_"^"_stdate_"^"_edate) 	//外出学术
		s PerSchooling=""	//授课
		s PerDuty="" 		//周末节假日值班
		s PatNum=..GetPatNum(DepId_"^"_stdate_"^"_edate)
		s AdmissionNum=$P(PatNum,"@",1)
		s DeathNum=$P(PatNum,"@",3)
		s OperationNum=$P(PatNum,"@",4)
		s NightShift=..GetNightNum(DepId_"^"_stdate_"^"_edate)
		s OverRet=..GetOverRest(DepId_"^"_stdate_"^"_edate)
		s OverTime=$P(OverRet,"@",1)
		s OverHours=$P(OverRet,"@",2)
    }
    else 
    {
		s Report=$G(^User.DHCMGNurMonReportD(ReportId))
		s HospId=$List(Report,32)
		i HospId'="" s MonHosp=$P(^CT("HOSP",HospId),"^",2)
		s MonDep=$List(Report,3)
		s MonUser=$List(Report,5)
		s YearMonth=$List(Report,4)
		s MonYear=+$P(YearMonth,"-",1)
		s Month=+$P(YearMonth,"-",2)
		s MonMonth=$S(Month=1:"一月",Month=2:"二月",Month=3:"三月",Month=4:"四月",Month=5:"五月",Month=6:"六月",Month=7:"七月",Month=8:"八月",Month=9:"九月",Month=10:"十月",Month=11:"十一月",Month=12:"十二月",1:"")
		s MonDate=$List(Report,23)
		i MonDate'="" s MonDate=$ZD(MonDate,3)
		s PerHoliday=$List(Report,9)
		s SickLeave=$List(Report,12)
		s PersonalLeave=$List(Report,11)
		s OutMeeting=$List(Report,7)
		s OutAcademic=$List(Report,6)
		s PerSchooling=$List(Report,10)
		s PerDuty=$List(Report,8)
		
		s AdmissionNum=$List(Report,2)
		s OperationNum=$List(Report,26)
		s CriticalCare=$List(Report,17)
		s FirstCare=$List(Report,21)
		s DeathNum=$List(Report,20)
		s PraiseNum=$List(Report,29)
		s PraisePerson=$List(Report,30)
		s CriticizeNum=$List(Report,18)
		s CriticizePerson=$List(Report,19)
		s ComplainNum=$List(Report,13)
		s ComplainPerson=$List(Report,14)
		s InfusionReaction=$List(Report,22)
		s ComplicationNum=$List(Report,15)
		s ComplicationPerson=$List(Report,16)
		
		s NightShift=$List(Report,25)
		s OverTime=$List(Report,28)
		s OverHours=$List(Report,27)
		s MonNote=$List(Report,24)
		s AuditDr=$List(Report,31)
		i AuditDr'="" s AuditStat=$List(^User.DHCMGNurMonAuditD(AuditDr),10)
	}
	s Data=MonHosp_"^"_MonDep_"^"_MonUser_"^"_MonYear_"^"_MonMonth_"^"_MonDate_"^"_PerHoliday_"^"_SickLeave_"^"_PersonalLeave_"^"_OutMeeting_"^"_OutAcademic_"^"_PerSchooling_"^"_PerDuty
	s Data=Data_"^"_AdmissionNum_"^"_OperationNum_"^"_CriticalCare_"^"_FirstCare_"^"_DeathNum_"^"_PraiseNum_"^"_PraisePerson_"^"_CriticizeNum_"^"_CriticizePerson_"^"_ComplainNum_"^"_ComplainPerson_"^"_InfusionReaction_"^"_ComplicationNum_"^"_ComplicationPerson
	s Data=Data_"^"_NightShift_"^"_OverTime_"^"_OverHours_"^"_MonNote_"^"_AuditDr_"^"_AuditStat
	q Data
}

/// Creator: 	wxl
/// CreatDate: 	2010-06-08
/// Description:取日期所在月份的开始日期与结束日期
/// Table：			
/// Input：		date:日期(2010-06-08或08/06/2010或61885)
/// Return：	61878^61907
ClassMethod GetMonStartEndDate(date) As %String
{
	s curDate=..TransDateToNum(date)
	s curDate=$ZD(curDate,3)
	s Year=$P(curDate,"-",1)
	s Mon=$P(curDate,"-",2)
	s stdate=Year_"-"_Mon_"-01"
	s stdate=$ZDH(stdate,3)
	s edate=$ZDH(Year_"-"_(Mon+1)_"-01",3)-1
	q stdate_"^"_edate
}

/// Creator: 	wxl
/// CreatDate: 	2010-06-08
/// Description:将日期格式转换为数字格式
/// Table：			
/// Input：		date:日期(2010-06-08或08/06/2010或61885)
/// Return：	61885
ClassMethod TransDateToNum(date) As %String
{
	s TransDate=date
	i +TransDate'=TransDate  d
	.i TransDate["-" s TransDate=$ZDH(date,3)
	.i TransDate["/" s TransDate=$ZDH(date,4)
	q TransDate
}

/// Creator: 	wxl
/// CreatDate: 	2010-06-08
/// Description:取某人某时间段内某种休假的天数
/// Table：			
/// Input：		parr:人员ID^休假名称^开始日期^结束日期
/// Return：	休假天数
ClassMethod GetPersonHL(parr) As %String
{
	//w ##class(web.DHCMGPerArrange).GetPersonHL("1^病假^2010-06-01^2010-06-30")
	s perId=$P(parr,"^",1)
	s hldesc=$P(parr,"^",2)
	s stdate=$P(parr,"^",3)
	s edate=$P(parr,"^",4)
	s stdate=..TransDateToNum(stdate)
	s edate=..TransDateToNum(edate)
	q:(perId="")!(hldesc="")!(stdate="")!(edate="") ""
	s perholnum="",perholId=""
	s hlrw=""  f  s hlrw=$O(^User.DHCMGCHolidayD(hlrw)) q:hlrw=""  d
	.s a=^User.DHCMGCHolidayD(hlrw)
	.s flag=$List(a,3)
	.q:flag="Y"
	.s desc=$List(a,4)
	.q:desc'=hldesc
	.s perholId=hlrw
    .s rw="" f  s rw=$O(^User.DHCMGPersonHolidayI("PerHl"," "_perId," "_hlrw,rw)) q:rw=""  d
    ..s arr=^User.DHCMGPersonHolidayD(rw)
    ..s st=$List(arr,3)
    ..s ed=$List(arr,2)
    ..s dnum=""
    ..q:(ed<stdate)!(st>edate)
    ..if (stdate'>st)&(edate'<ed) s dnum=(ed-st+1)
    ..if (stdate>st)&(edate'<ed) s dnum=(ed-stdate+1)
    ..if (stdate'>st)&(edate<ed)  s dnum=(edate-st+1)
    ..if (stdate>st)&(edate<ed) s dnum=(edate-stdate)
    ..s perholnum=$G(perholnum)+dnum
	q perholnum_"^"_perholId
}

/// Creator: 	wxl
/// CreatDate: 	2010-06-08
/// Description:取外出参加学术活动天数
/// Table：			
/// Input：		parr:人员ID^开始日期^结束日期
/// Return：	天数
ClassMethod GetPersonTrain(parr) As %String
{
 	//w ##class(web.DHCMGPerArrange).GetPersonTrain("1^2010-06-01^2010-06-30")
 	s per=$P(parr,"^",1)
 	q:per="" ""
 	s stdate=$P(parr,"^",2)
 	s edate=$P(parr,"^",3)
	s stdate=..TransDateToNum(stdate)
	s edate=..TransDateToNum(edate)
	s perwcxsnum=""
	s rw=""  f  s rw=$O(^User.DHCMGNurTrainI("Nur",per,rw)) q:rw=""  d
    .s a=^User.DHCMGNurTrainD(rw)
    .s st=$List(a,5)
    .s ed=$List(a,3)
    .q:(ed<stdate)!(st>edate)
    .if (stdate'>st)&(edate'<ed) s dnum=(ed-st+1)
    .if (stdate>st)&(edate'<ed) s dnum=(ed-stdate+1)
    .if (stdate'>st)&(edate<ed)  s dnum=(edate-st+1)
    .if (stdate>st)&(edate<ed) s dnum=(edate-stdate)
    .s perwcxsnum=$G(perwcxsnum)+dnum
	q perwcxsnum
}

/// Creator: 	wxl
/// CreatDate: 	2010-06-08
/// Description:取入院人数
/// Table：			
/// Input：		parr:病区ID^开始日期^结束日期
/// Return：	入院人数@出院人数@死亡人数@手术人数
ClassMethod GetPatNum(parr) As %String
{
 	//w ##class(web.DHCMGPerArrange).GetPatNum("211^2010-06-01^2010-06-30")
 	s loc=$P(parr,"^",1)
 	q:loc="" ""
 	s stdate=$P(parr,"^",2)
 	s edate=$P(parr,"^",3)
	s stdate=..TransDateToNum(stdate)
	s edate=..TransDateToNum(edate)
	s pacward=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	q:pacward="" ""
	//入院,出院,死亡
	s InPatNum="",OutPatNum="",DeathPatNum=""
	s room=""  f  s room=$O(^PAADMi("CurrWard",pacward,room)) q:room=""  d
	.s adm=""  f  s adm=$O(^PAADMi("CurrWard",pacward,room,adm)) q:adm=""  d   
	..s admdate=$P(^PAADM(adm),"^",6)
	..i (admdate>=stdate)&(admdate<=edate) s InPatNum=$G(InPatNum)+1
	..s dischdate=$P(^PAADM(adm),"^",17)
	..i (dischdate>=stdate)&(dischdate<=edate) s OutPatNum=$G(OutPatNum)+1
	..s mradm=$P(^PAADM(adm),"^",61)
	..s disReasondr=$P(^MR(mradm,"PRO",1),"^",10)
	..i disReasondr'=""  s deathflag=$P(^PAC("DISCON",disReasondr),"^",3)
	..e  s deathflag=""
	..i (dischdate>=stdate)&(dischdate<=edate) &($G(deathflag)="D") s DeathPatNum=$G(DeathPatNum)+1

	//手术
	s OPPatNum=""
    f date=stdate:1:edate
    {  
		s opaId=""
		f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
		.q:$d(^DHCANOPArrange(opaId))<1
		.s Stat=$P(^DHCANOPArrange(opaId),"^",27)
		.q:Stat="D"		//"A/申请""D/拒绝""R/安排""N/非预约""I/术中""P/恢复室""L/术毕""F/完成"
		.s patWardId=$P($G(^DHCANOPArrange(opaId)),"^",32)
		.//q:pacward'=patWardId
		.q:loc'=patWardId
		.s OPPatNum=$G(OPPatNum)+1
   }
   q InPatNum_"@"_OutPatNum_"@"_DeathPatNum_"@"_OPPatNum
}

/// Creator: 	wxl
/// CreatDate: 	2010-06-08
/// Description:护理人员出席情况
/// Table：		
/// Input：		parr:(科室ID!开始日期!结束日期)
/// Return：	
ClassMethod LookupDepHolExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//补贴调节记录
	//d ##class(%ResultSet).RunQuery("web.DHCMGNurMonReport","LookupDepHol","1^1^^2010-07-01")
	s ReportId=$P(parr,"^",1)
	s loc=$P(parr,"^",2)
	if (ReportId="")&(loc="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s PersonId=$P(parr,"^",3)
	s ReportDate=$P(parr,"^",4)
	i ReportDate'="" s ReportDate=$ZDH(ReportDate,3)
	e  s ReportDate=+$h
	s curDate=..GetMonStartEndDate(ReportDate)
	s stdate=$P(curDate,"^",1)
	s edate=$P(curDate,"^",2)
	
	s AuditStat=""
	if ReportId'="" d
	.s Report=^User.DHCMGNurMonReportD(ReportId)
	.s AuditDr=$List(Report,31)
	.i AuditDr'="" d
	..s AuditStat=$List(^User.DHCMGNurMonAuditD(AuditDr),10)
	if AuditStat="" {
		b //1
		s hlname="病假^产假^事假^丧假^婚假^计划生育"
		s hllen=$L(hlname,"^")
		s ret=##class(web.DHCMGPerArrange).GetDepPerson(loc_"^"_stdate_"^"_edate)
		s ln=$L(ret,"^")
		for i=1:1:ln {
			s str=$P(ret,"^",i)
			s perid=$P(str,"|",1)
			if perid="" continue
			//护士长本人不统计
			if perid=PersonId continue
			s parr=^User.DHCMGPersonsD(perid)
			s person=$list(parr,21)
			for ii=1:1:hllen {
				s holiday=$P(hlname,"^",ii)
				s holidayret=..GetPersonHL(perid_"^"_holiday_"^"_stdate_"^"_edate)
				s holidaydays=$P(holidayret,"^",1)
				s holid=$P(holidayret,"^",2)
				if (holidaydays="")!(holidaydays=0) continue
				s rw=""
				d out			
			}
		}
	} 
	else {
		//提交后不允须修改
		b //2
		s rw=""  f  s rw=$O(^User.DHCMGNurMonReportD(ReportId,"ChildSubHol",rw)) q:rw=""  d
		.s a=^User.DHCMGNurMonReportD(ReportId,"ChildSubHol",rw)
		.s perid=$List(a,4)
		.s parr=^User.DHCMGPersonsD(perid)
		.s person=$list(parr,21)
		.s holid=$List(a,2)
		.s holiday=$List(^User.DHCMGCHolidayD(holid),4)
		.s holidaydays=$List(a,3)
		.d out		
	}
	s ^TMP("web.DHCMGNurMonReport:LookupDepHol")=ind
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
out
	set Data=$lb(person,perid,holiday,holid,holidaydays,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookupDepHolFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookupDepHolExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookupDepHolClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookupDepHolExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query LookupDepHol(parr As %String) As %Query(ROWSPEC = "person,perid,holiday,holid,holidaydays,rw")
{
}

/// Creator: 	wxl
/// CreatDate: 	2010-06-08
/// Description:取表扬信人数与人员
/// Table：			
/// Input：		parr:科室ID^开始日期^结束日期
/// Return：	表扬信人数@人员
ClassMethod GetEncourage(parr) As %String
{
	//w ##class(web.DHCMGNurMonReport).GetEncourage("211^2010-06-01^2010-06-30")
	s loc=$P(parr,"^",1)
	q:loc="" ""
	s stdate=$P(parr,"^",2)
	s edate=$P(parr,"^",3)
	s stdate=..TransDateToNum(stdate)
	s edate=..TransDateToNum(edate)
	s num="",nurList=""
	f date=stdate:1:edate
    {  
		s curDate=$ZD(date,3)
		s dep=""  f  s dep=$O(^User.DHCMGNurEncourageI("DateDep"," "_curDate,dep)) q:dep=""  d
		.s curdep=$Tr(dep," ","")
		.q:(curdep'=loc)&(loc'="")
		.s rw=""  f  s rw=$O(^User.DHCMGNurEncourageI("DateDep"," "_curDate,dep,rw)) q:rw=""  d
		..s a=^User.DHCMGNurEncourageD(rw)
	    ..s content=$List(a,2)
	    ..q:content'["表扬信"
	    ..s nur=$List(a,5)
    	..s parr=^User.DHCMGPersonsD(nur)
    	..s person=$list(parr,21)
    	..if nurList="" s nurList=person
    	..e  s nurList=nurList_" "_person
    	..s num=num+1
	}
	q num_"@"_nurList
}

/// Creator: 	wxl
/// CreatDate: 	2010-06-08
/// Description:取批评信人数与人员
/// Table：			
/// Input：		parr:科室ID^开始日期^结束日期
/// Return：	批评信人数@人员
ClassMethod GetPunish(parr) As %String
{
	//w ##class(web.DHCMGNurMonReport).GetPunish("211^2010-06-01^2010-06-30")
	s loc=$P(parr,"^",1)
	q:loc="" ""
	s stdate=$P(parr,"^",2)
	s edate=$P(parr,"^",3)
	s stdate=..TransDateToNum(stdate)
	s edate=..TransDateToNum(edate)
	s num="",nurList=""
	f date=stdate:1:edate
    {  
		s curDate=$ZD(date,3)
		s dep=""  f  s dep=$O(^User.DHCMGNurPunishI("DateDep"," "_curDate,dep)) q:dep=""  d
		.s curdep=$Tr(dep," ","")
		.q:(curdep'=loc)&(loc'="")
		.s rw=""  f  s rw=$O(^User.DHCMGNurPunishI("DateDep"," "_curDate,dep,rw)) q:rw=""  d
		..s a=^User.DHCMGNurPunishD(rw)
	    ..s content=$List(a,2)
	    ..q:content'["批评信"
	    ..s nur=$List(a,5)
    	..s parr=^User.DHCMGPersonsD(nur)
    	..s person=$list(parr,21)
    	..if nurList="" s nurList=person
    	..e  s nurList=nurList_" "_person
    	..s num=num+1
	}
	q num_"@"_nurList
}

/// Creator: 	wxl
/// CreatDate: 	2010-06-08
/// Description:取夜班人数
/// Table：		DHCMG_PersonArrange	
/// Input：		parr:科室ID^开始日期^结束日期
/// Return：	夜班人数
ClassMethod GetNightNum(parr) As %String
{
	//w ##class(web.DHCMGNurMonReport).GetNightNum("1^2010-07-01^2010-07-30")
	s loc=$P(parr,"^",1)
	q:loc="" ""
	s stdate=$P(parr,"^",2)
	s edate=$P(parr,"^",3)
	s stdate=..TransDateToNum(stdate)
	s edate=..TransDateToNum(edate)
	s num=""
	k NightNum
	f date=stdate:1:edate
    {  
		s par="" f  s par=$O(^User.DHCMGPersonArrangeI("DepDate"," "_loc,date,par)) q:par=""  d
	    .s arr=^User.DHCMGPersonArrangeD(par)
        .s PostDr=$List(arr,6)
	    .s pflag=$List(^User.DHCMGPostD(PostDr),7)
	    .q:pflag'="Y"
		.s per=$List(arr,5)
		.q:per=""
	    .q:$D(NightNum(per))>0
	    .s NightNum(per)=""
	    .s num=num+1
    }
	q num
}

/// Creator: 	wxl
/// CreatDate: 	2010-06-08
/// Description:取加班人次与总时间
/// Table：			
/// Input：		parr:科室ID^开始日期^结束日期
/// Return：	加班人次@总时间
ClassMethod GetOverRest(parr) As %String
{
	//w ##class(web.DHCMGNurMonReport).GetOverRest("211^2010-06-01^2010-06-30")
	s loc=$P(parr,"^",1)
	q:loc="" ""
	s stdate=$P(parr,"^",2)
	s edate=$P(parr,"^",3)
	s stdate=..TransDateToNum(stdate)
	s edate=..TransDateToNum(edate)
	s num="",alltime=""
	f date=stdate:1:edate
    {  
		s rw=""  f  s rw=$O(^User.DHCMGPersonOverRestI("DepDate"," "_loc,date,rw)) q:rw=""  d
		.s a=^User.DHCMGPersonOverRestD(rw)
		.s OVSum=$List(a,11)
		.s num=num+1
		.s alltime=alltime+OVSum
    }
	q num_"@"_alltime
}

/// Creator: 	wxl
/// CreatDate: 	2010-06-08
/// Description:借入借出(借出时填写临时科室)
/// Table：		^User.DHCMGPersonsI("TempDep"
/// Input：		parr:(科室ID!开始日期!结束日期)
/// Return：	
ClassMethod LookupLendOrBorrowExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGNurMonReport","LookupLendOrBorrow","1^1^1^2010-07-01")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ReportId=$P(parr,"^",1)
	s loc=$P(parr,"^",2)
	if (ReportId="")&(loc="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s PersonId=$P(parr,"^",3)
	s ReportDate=$P(parr,"^",4)
	i ReportDate'="" s ReportDate=$ZDH(ReportDate,3)
	e  s ReportDate=+$h
	s curDate=..GetMonStartEndDate(ReportDate)
	s stdate=$P(curDate,"^",1)
	s edate=$P(curDate,"^",2)
	s AuditStat=""
	if ReportId'="" d
	.s Report=^User.DHCMGNurMonReportD(ReportId)
	.s AuditDr=$List(Report,31)
	.i AuditDr'="" d
	..s AuditStat=$List(^User.DHCMGNurMonAuditD(AuditDr),10)
	if AuditStat="" {
		k LendNurNum,BorrowNurNum
		f date=stdate:1:edate
	    {  
			s rw=""  f  s rw=$O(^User.DHCMGPersonArrangeI("DepDate"," "_loc,date,rw)) q:rw=""  d
			.s a=^User.DHCMGPersonArrangeD(rw)
			.s per=$List(a,5)
			.q:per=""
			.s parr=^User.DHCMGPersonsD(per)
			.s depdr=$list(parr,7)	
			.//借入/排班的科室与人员所在科室不同为借入
			.i depdr'=loc s BorrowNurNum(per,depdr,date)=""
			.s PostDr=$List(a,6)
		    .s PostDesc=$List(^User.DHCMGPostD(PostDr),3)
		    .//借出/人员临时科室为借出科室
		    .//s zcdepdr=$list(parr,44)
		    .//i depdr=loc,zcdepdr'="" s LendNurNum(per,zcdepdr,date)=""
			.i PostDesc["外借" d
			..b //1
			..s zcrw="" f  s zcrw=$O(^User.DHCMGPersonArrangeI("PersonDate"," "_per,date,zcrw)) q:zcrw=""  d
			...s zcarr=^User.DHCMGPersonArrangeD(zcrw)
			...s zcdepdr=$List(zcarr,3)
	        ...q:zcdepdr=loc
	        ...s LendNurNum(per,zcdepdr,date)=""
	    }
	    b //000
		s nur="" f  s nur=$O(LendNurNum(nur)) q:nur=""  d
		.s depdr="" f  s depdr=$O(LendNurNum(nur,depdr)) q:depdr=""  d
		..s startdate="",num=0
		..s curdate="" f  s curdate=$O(LendNurNum(nur,depdr,curdate)) q:curdate=""  d
		...i startdate="" s startdate=$ZD(curdate,3)
		...s num=num+1
		..s type="借出"
		..s parr=^User.DHCMGPersonsD(nur)
		..s person=$list(parr,21)
		..s perid=nur 
		..s depdesc=$P(^CTLOC(depdr),"^",2)
		..s depid=depdr
		..s rw=""
		..d out
		
		s nur="" f  s nur=$O(BorrowNurNum(nur)) q:nur=""  d
		.s depdr="" f  s depdr=$O(BorrowNurNum(nur,depdr)) q:depdr=""  d
		..s startdate="",num=0
		..s curdate="" f  s curdate=$O(BorrowNurNum(nur,depdr,curdate)) q:curdate=""  d
		...i startdate="" s startdate=$ZD(curdate,3)
		...s num=num+1
		..s type="借入"
		..s parr=^User.DHCMGPersonsD(nur)
		..s person=$list(parr,21)
		..s perid=nur
		..s depdesc=$P(^CTLOC(depdr),"^",2)
		..s depid=depdr
		..s rw=""
		..d out
	}
	else
	{
		//提交后不允须修改
		s rw=""  f  s rw=$O(^User.DHCMGNurMonReportD(ReportId,"ChildSubExch",rw)) q:rw=""  d
		.s a=^User.DHCMGNurMonReportD(ReportId,"ChildSubExch",rw)
		.s type=$List(a,6)
		.s perid=$List(a,5)
		.s parr=^User.DHCMGPersonsD(perid)
		.s person=$list(parr,21)
		.s startdate=$List(a,2)
		.i startdate'="" s startdate=$ZD(startdate,3)
		.s depid=$List(a,4)
		.i depid'="" d
		..s depdesc=$P(^CTLOC(depid),"^",2)
		..i $L(depdesc,"-")>1 s depdesc=$P(depdesc,"-",2)
		.e  s depdesc=""
		.s num=$List(a,3)
		.d out
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
out
	set Data=$lb(type,person,perid,startdate,depdesc,depid,num,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookupLendOrBorrowFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookupLendOrBorrowExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookupLendOrBorrowClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookupLendOrBorrowExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query LookupLendOrBorrow(parr As %String) As %Query(ROWSPEC = "type,person,perid,startdate,depdesc,depid,num,rw")
{
}

/// Creator: 	wxl
/// CreatDate: 	2010-07-05
/// Description:根据代码取某月的培训/查房/考评情况
/// Table：		User.DHCMGNurTrainExam
/// Input：		parr(代码(TE1,TE2,TE3)^科室^日期)
/// Return：	date,content,person,score,rw
/// 			日期,内容,人员,分数,RowID
ClassMethod GetNurTrainExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="1^^2010-06-22^2010-06-22"
 	//d ##class(%ResultSet).RunQuery("web.DHCMGNurMonReport","GetNurTrain","TE1^1^2010-07-01")
	s ReportId=$P(parr,"^",1)
	s loc=$P(parr,"^",2)
	if loc="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s TypCode=$P(parr,"^",3)
	s Typ=##class(User.DHCMGNurExamTyp).GetExamCode(TypCode)
	s TypId=$P(Typ,"|",1)
	s ReportDate=$P(parr,"^",4)
	i ReportDate'="" s ReportDate=$ZDH(ReportDate,3)
	e  s ReportDate=+$h
	s curDate=..GetMonStartEndDate(ReportDate)
	s stdate=$zd($P(curDate,"^",1),3)
	s edate=$zd($P(curDate,"^",2),3)
	s par=loc_"^^"_stdate_"^"_edate_"^"_TypId
	b //000
	s rset=##class(%ResultSet).%New("web.DHCMGNurMonReport:GetNurTrainExam")
	do rset.Execute(par)
	while (rset.Next()) {
		s date=rset.GetData(5)
		s content=rset.GetData(3)
		s person=rset.GetData(2)
		s score=rset.GetData(4)
		s rw=rset.GetData(7)
		d OutRowtyp
	}	
	d rset.Close()
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(date,content,person,score,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetNurTrainFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNurTrainExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetNurTrainClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNurTrainExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetNurTrain(parr As %String) As %Query(ROWSPEC = "date,content,person,score,rw")
{
}

/// Creator: 	wxl
/// CreatDate: 	2010-07-05
/// Description:根据代码取某月的考评情况
/// Table：		User.DHCMGNurTrainExam
/// Input：		parr(代码TE3^科室^日期)
/// Return：	date,content,person,score,rw
/// 			日期,内容,人员,分数,RowID
ClassMethod GetNurExam(parr) As %String
{
	//w ##class(web.DHCMGNurMonReport).GetNurExam("^1^TE3^2010-07-01")
	s ReportId=$P(parr,"^",1)
	s loc=$P(parr,"^",2)
	if loc="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s TypCode=$P(parr,"^",3)
	s Typ=##class(User.DHCMGNurExamTyp).GetExamCode(TypCode)
	s TypId=$P(Typ,"|",1)
	s ReportDate=$P(parr,"^",4)
	i ReportDate'="" s ReportDate=$ZDH(ReportDate,3)
	e  s ReportDate=+$h
	s curDate=..GetMonStartEndDate(ReportDate)
	s stdate=$zd($P(curDate,"^",1),3)
	s edate=$zd($P(curDate,"^",2),3)
	s par=loc_"^^"_stdate_"^"_edate_"^"_TypId
	b //000
	s header="检查项目^"  //"受检人\分数\检查项目^"
	s rowdata=""
	s tb=""
	k NurExam,NurExamScore
	s rset=##class(%ResultSet).%New("web.DHCMGNurMonReport:GetNurTrainExam")
	do rset.Execute(par)
	while (rset.Next()) {
		s date=rset.GetData(5)
		s content=rset.GetData(3)
		s person=rset.GetData(2)
		s score=rset.GetData(4)
		s rw=rset.GetData(7)
		s NurExam(person)=""
		s NurExamScore(content,person)=score_"^"_rw
	}	
	d rset.Close()
	s nur=""  f  s nur=$O(NurExam(nur))  q:nur=""  d
	.//护士姓名1^rw1^护士姓名2^rw2
	.s header=header_nur_"^^"
	
	s curcontent=""  f  s curcontent=$O(NurExamScore(curcontent))  q:curcontent=""  d
	.s rowdata=""
	.s nur=""  f  s nur=$O(NurExam(nur))  q:nur=""  d
	..s score=$P($G(NurExamScore(curcontent,nur)),"^",1)
	..s rw=$P($G(NurExamScore(curcontent,nur)),"^",2)
	..s rowdata=rowdata_score_"^"_rw_"^"
	.s tb=tb_curcontent_"^"_rowdata_$C(2)
	q header_$C(1)_tb
}

/// Creator: 	wxl
/// CreatDate: 	2010-07-06
/// Description:取护理质控
/// Table：		User.DHCMGNurExamQual
/// Input：		parr:(月报ID^科室ID^用户ID^开始日期^登陆His安全组ID)
/// Return：	itm,num,score,percent,rw
/// 			项目,人数,分数,合格率,记录ROWID
ClassMethod GetDepMonQualExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//d ##class(%ResultSet).RunQuery("web.DHCMGNurMonReport","GetDepMonQual","^1^1^2010-07-01^1")
	s ReportId=$P(parr,"^",1)
	s dep=$P(parr,"^",2)
	if dep="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s PersonId=$P(parr,"^",3)
	s ReportDate=$P(parr,"^",4)
	i ReportDate="" s ReportDate=$ZD(+$h,3)
	s Year=+$P(ReportDate,"-",1)
    s Month=+$P(ReportDate,"-",2)
    s YearMonth=Year_"-"_Month
    s ssgroup=$P(parr,"^",5)
	if ssgroup="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s group=##class(User.DHCMGSSGRPRELHISGRP).getgrp(ssgroup)
	s group=+group		//1^A
	if group=0 Set qHandle=$lb(0,repid,0) Quit $$$OK

	k DepQual
	s loc="" f  s loc=$O(^User.DHCMGNurExamQualI("DepMon"," "_group,loc)) q:loc=""  d
	.s curloc=$Tr(loc," ","")
	.q:(dep'="")&(dep'=curloc)
	.s rw="" f  s rw=$O(^User.DHCMGNurExamQualI("DepMon"," "_group,loc," "_YearMonth,rw)) q:rw=""  d
	..s Qual=^User.DHCMGNurExamQualD(rw)
	..s QualDep=$List(Qual,2)
	..s QualItm=$List(Qual,3)
	..q:QualItm=""
	..s QualNum=$List(Qual,4)
	..s QualScore=$List(Qual,5)
	..s QualPercent=$List(Qual,6)
	..s DepQual(QualDep,QualItm)=QualNum_"^"_QualScore_"^"_QualPercent_"^"_rw

	s Itm=##class(User.DHCMGNurExamTyp).GetExamCode("QUAL")
	s ItmLn=$L(Itm,"^")
	for i=1:1:ItmLn
	{
		s QualItm=$P(Itm,"^",i)
		s QualRw=$P(QualItm,"|",1)
		s itm=$P(QualItm,"|",2)
		if QualRw="" continue
		s num=$P($G(DepQual(dep,QualRw)),"^",1)
		s score=$P($G(DepQual(dep,QualRw)),"^",2)
		s percent=$P($G(DepQual(dep,QualRw)),"^",3)
		s rw=$P($G(DepQual(dep,QualRw)),"^",4)
		d out3
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
out3
	set Data=$lb(itm,num,score,percent,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDepMonQualFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepMonQualExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDepMonQualClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepMonQualExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDepMonQual(parr As %String) As %Query(ROWSPEC = "itm,num,score,percent,rw")
{
}

/// Creator: 	wxl
/// CreatDate: 	2010-07-06
/// Description:取科室的月报记录
/// Table：		User.DHCMGNurMonReport
/// Input：		
/// Return：	mondep,monmonth,monuser,mondate,status,auditid,rw,mondepid,monuserid
/// 			科室,月份,报表人,报表日期,状态,审核表ID,月报ID,科室ID,报表人ID
ClassMethod GetMonReportExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//d ##class(%ResultSet).RunQuery("web.DHCMGNurMonReport","GetMonReport","1^2010-07-01^2010-07-31")
 	s dep=$P(parr,"^",1)
 	s stdate=$P(parr,"^",2)
	s edate=$P(parr,"^",3)
	s stdate1=$ZDH(stdate,3)
	s edate1=$ZDH(edate,3)
	s manager=$P(parr,"^",4)
	for date=stdate1:1:edate1
	{
		s loc=""  f  s loc=$O(^User.DHCMGNurMonReportI("DepDate",loc)) q:loc=""  d
	    .s curloc=$Tr(loc," ","")
	    .q:(curloc'=dep)&(dep'="")
	    .s rw=""  f  s rw=$O(^User.DHCMGNurMonReportI("DepDate",loc,date,rw)) q:rw=""  d
		..s monmanager=$ListGet(^User.DHCMGNurMonReportD(rw),37)
		..q:(manager="Y")&(monmanager'="Y")
		..d out
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (mondep,monmonth,monuser,mondate,status,auditid,mondepid,monmanager)=""
    s a=^User.DHCMGNurMonReportD(rw)   
    s mondepid=$List(a,3)
    if mondepid'="" s mondep=$P(^CTLOC(mondepid),"^",2)
    e  s mondep=""
    s monmonth=$List(a,4)
    s monuserid=$List(a,5)
	if monuserid'="" d
	.s parr=^User.DHCMGPersonsD(monuserid)
    .s monuser=$list(parr,21)
    e  s monuser=""
    s mondate=$List(a,23)
    i mondate'="" s mondate=$ZD(mondate,3)
    s auditid=$List(a,31)
    i auditid'="" d
    .s audit=^User.DHCMGNurMonAuditD(auditid)
    .s statuscode=$List(audit,10)
    .i statuscode="S" s status="提交"
	.i statuscode="A" s status="审核"
	.i statuscode="R" s status="退回"
    s monmanager=$ListGet(a,37)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(mondep,monmonth,monuser,mondate,status,auditid,rw,mondepid,monuserid,monmanager)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMonReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAuditRecordExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMonReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAuditRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMonReport(parr As %String) As %Query(ROWSPEC = "mondep,monmonth,monuser,mondate,status,auditid,rw,mondepid,monuserid,monmanager")
{
}

/// Creator: 	wxl
/// CreatDate: 	2010-07-06
/// Description:取月报审核记录
/// Table：		DHCMgNurMonAudit
/// Input：		parr(科室ID^开始日期^结束日期)
/// Return：	depdes,stdate,edate,person,audate,autime,dep,rw,SmUser,SmDate,SmTime,Stat,mem,Sel:%Boolean,reportId
/// 			科室描述,月报开始日期,结束日期,审核人,审核日期,审核时间,科室ID,审核表ID,提交人,提交日期,提交时间,状态,退回原因,选择勾,月报ID
ClassMethod GetAuditRecordExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//d ##class(%ResultSet).RunQuery("web.DHCMGNurMonReport","GetAuditRecord","1^2010-07-01^2010-07-31")
 	s dep=$P(parr,"^",1)
 	s stdate=$P(parr,"^",2)
	s edate=$P(parr,"^",3)
	s stdate1=$ZDH(stdate,3)
	s edate1=$ZDH(edate,3)
	for date=stdate1:1:edate1 
	{
	    s loc=""  f  s loc=$O(^User.DHCMGNurMonAuditI("DepDate",loc)) q:loc=""  d
	    .s curloc=$Tr(loc," ","")
	    .q:(curloc'=dep)&(dep'="")
	    .s rw=""  f  s rw=$O(^User.DHCMGNurMonAuditI("DepDate",loc,date,rw)) q:rw=""  d
	    ..d out
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (depdes,stdate,edate,person,audate,autime,SmUser,SmDate,SmTime,Stat,mem)=""
    s a=^User.DHCMGNurMonAuditD(rw)
	s depdr=$List(a,3)
    if depdr'="" s depdes=$P(^CTLOC(depdr),"^",2)
    s dep=depdr
	s Stdate=$List(a,9)
    s eDate=$List(a,4)
	s edate=$ZD(eDate,3)
    s stdate=$ZD(Stdate,3) 
    s user=$List(a,12)
	if user'="" d
	.s parr=^User.DHCMGPersonsD(user)
	.s person=$list(parr,21)
    s audate=$List(a,2)
    s autime=$List(a,11)
	if audate'="" s audate=$ZD(audate,3)
    if autime'="" s autime=$ZT(autime,2)   
	s SmUser=$List(a,8)
    q:SmUser=""
	s parr=^User.DHCMGPersonsD(SmUser)
    s SmUser=$list(parr,21)
    s SmDate=$List(a,6)
    s SmTime=$List(a,7)
    if SmDate'="" s SmDate=$ZD(SmDate,3)
    if SmTime'="" s SmTime=$ZT(SmTime,2)
    s Stat=$List(a,10)
    s mem= $List(a,5)
    s reportId=$O(^User.DHCMGNurMonReportI("Audit",rw,""))
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,stdate,edate,person,audate,autime,dep,rw,SmUser,SmDate,SmTime,Stat,mem,"false",reportId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAuditRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAuditRecordExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAuditRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAuditRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetAuditRecord(parr As %String) As %Query(ROWSPEC = "depdes,stdate,edate,person,audate,autime,dep,rw,SmUser,SmDate,SmTime,Stat,mem,Sel:%Boolean,reportId")
{
}

/// Creator: 	wxl
/// CreatDate: 	2010-07-06
/// Description:保存月报记录
/// Table：		User.DHCMGNurMonReport,User.DHCMGNurMonReportHol,User.DHCMGNurMonReportExch
/// Input：		
/// Return：	
ClassMethod SaveMonReport(parr As %String) As %String
{
	//s parr="1^宁夏医科大学附属医院^1^1^2010^七月^2010-07-07^^2^9^^10^^^^^^^^^^^^^^^^^2^2^7^fdafaf^"_$C(2)_"2006!6!7!^1258!9!7!^1955!3!7!^"_$C(2)_"借出!1952!2010-07-05!211!7!^借入!1028!2010-07-05!211!7!^借入!2006!2010-07-01!211!4!^"_$C(2)_"49|51|52|"_$C(2)_"48|53|"_$C(2)_"61|62|60|63|55|54|59|57|58|56|"_$C(2)_"10|11|12|13|14|15|16|17|"
	//w ##class(web.DHCMGNurMonReport).SaveMonReport("")
	s SingleData=$P(parr,$C(2),1)
	s Holiday=$P(parr,$C(2),2)
	s LendBorrow=$P(parr,$C(2),3)
	s MonTrain=$P(parr,$C(2),4)
	s MonCare=$P(parr,$C(2),5)
	s MonExam=$P(parr,$C(2),6)
	s MonQual=$P(parr,$C(2),7)
	
	s id=$P(SingleData,"^",1)
	s MonHosp=$P(SingleData,"^",2)
	i MonHosp'=+MonHosp d
	.s MonHosp=$$ALPHAUP^SSUTIL4(MonHosp)
	.s MonHospId=$O(^CT("HOSP",0,"Desc",MonHosp,""))
	e  s MonHospId=MonHosp
	b //00
	s MonHosp=$P(SingleData,"^",2)
	s Year=$P(SingleData,"^",5)
	s Month=$P(SingleData,"^",6)
	s MonMonth=$S(Month="一月":1,Month="二月":2,Month="三月":3,Month="四月":4,Month="五月":5,Month="六月":6,Month="七月":7,Month="八月":8,Month="九月":9,Month="十月":10,Month="十一月":11,Month="十二月":12,1:"")
	s MonMonth=Year_"-"_MonMonth
	s MonDate=$P(SingleData,"^",7)
	i MonDate'="" s MonDate=$ZDH(MonDate,3)
	s MonUser=$P(SingleData,"^",4)
	s AuditDr=$P(SingleData,"^",33)
	
	TSTART
	if id'=""  s Mon=##class(User.DHCMGNurMonReport).%OpenId(id)
	e  s Mon=##class(User.DHCMGNurMonReport).%New()
	s Mon.MonHosp=MonHospId
	s Mon.MonDep=$P(SingleData,"^",3)
	s Mon.MonUser=##class(User.DHCMGPersons).%OpenId(MonUser) 
	s Mon.MonMonth=MonMonth
	s Mon.MonDate=MonDate
	s Mon.MonNote=$P(SingleData,"^",32)
	s Mon.AuditDr=##class(User.DHCMGNurMonAudit).%OpenId(AuditDr)
	s Mon.PerHoliday=$P(SingleData,"^",8)
	s Mon.SickLeave=$P(SingleData,"^",9)
	s Mon.PersonalLeave=$P(SingleData,"^",10)
	s Mon.OutMeeting=$P(SingleData,"^",11)
	s Mon.OutAcademic=$P(SingleData,"^",12)
	s Mon.PerSchooling=$P(SingleData,"^",13)
	s Mon.PerDuty=$P(SingleData,"^",14)
	s Mon.AdmissionNum=$P(SingleData,"^",15)
	s Mon.OperationNum=$P(SingleData,"^",16)
	s Mon.CriticalCare=$P(SingleData,"^",17)
	s Mon.FirstCare=$P(SingleData,"^",18)
	s Mon.DeathNum=$P(SingleData,"^",19)
	s Mon.PraiseNum=$P(SingleData,"^",20)
	s Mon.PraisePerson=$P(SingleData,"^",21)
	s Mon.CriticizeNum=$P(SingleData,"^",22)
	s Mon.CriticizePerson=$P(SingleData,"^",23)
	s Mon.ComplainNum=$P(SingleData,"^",24)
	s Mon.ComplainPerson=$P(SingleData,"^",25)
	s Mon.InfusionReaction=$P(SingleData,"^",26)
	s Mon.ComplicationNum=$P(SingleData,"^",27)
	s Mon.ComplicationPerson=$P(SingleData,"^",28)
	s Mon.NightShift=$P(SingleData,"^",29)
	s Mon.OverTime=$P(SingleData,"^",30)
	s Mon.OverHours=$P(SingleData,"^",31)
	s Mon.MonTrain=MonTrain
	s Mon.MonCare=MonCare
	s Mon.MonExam=MonExam
	s Mon.MonQual=MonQual
	if $$$ISOK(Mon) d
	.d Mon.%Save()
	.d Mon.%Close()
	e  d
	.TROLLBACK
	b //001
	s HolidayLn=$L(Holiday,"^")
	f i=1:1:HolidayLn d
	.s Hol=$P(Holiday,"^",i)
	.q:Hol=""
	.s PerDr=$P(Hol,"!",1)
	.s HolDr=$P(Hol,"!",2)
	.s HolDays=$P(Hol,"!",3)
	.s HolRw=$P(Hol,"!",4)
	.if HolRw'=""  s ReportHol=##class(User.DHCMGNurMonReportHol).%OpenId(HolRw)
	.e  s ReportHol=##class(User.DHCMGNurMonReportHol).%New()
	.s ReportHol.HolParref=Mon
    .s ReportHol.HolNur=PerDr
    .s ReportHol.HolHolDr=HolDr
    .s ReportHol.HolHolNum=HolDays
    .if $$$ISOK(ReportHol) d
    ..d ReportHol.%Save()
    .e  TROLLBACK
   	b //002
   	s LendBorrowLn=$L(LendBorrow,"^")
	f j=1:1:LendBorrowLn d
	.s Exch=$P(LendBorrow,"^",j)
	.q:Exch=""
	.s ExchTyp=$P(Exch,"!",1)
	.s ExchNur=$P(Exch,"!",2)
	.s ExchDate=$P(Exch,"!",3)
	.i ExchDate'="" s ExchDate=$ZDH(ExchDate,3)
	.s ExchDep=$P(Exch,"!",4)
	.s ExchDays=$P(Exch,"!",5)
	.s ExchRw=$P(Exch,"!",6)
	.if ExchRw'=""  s ReportExch=##class(User.DHCMGNurMonReportExch).%OpenId(ExchRw)
	.e  s ReportExch=##class(User.DHCMGNurMonReportExch).%New()
	.s ReportExch.ExchParref=Mon
    .s ReportExch.ExchTyp=ExchTyp
    .s ReportExch.ExchNur=ExchNur
    .s ReportExch.ExchDate=ExchDate
    .s ReportExch.ExchDep=ExchDep
    .s ReportExch.ExchDays=ExchDays
    .if $$$ISOK(ReportExch) d
    ..d ReportExch.%Save()
    .e  TROLLBACK
	TCOMMIT
	q Mon.%Id()
}

/// Creator: 	wxl
/// CreatDate: 	2010-07-06
/// Description:提交月报记录
/// Table：		User.DHCMGNurMonAudit,User.DHCMGNurMonReport	
/// Input：		parr(月报ID^科室ID^报表人ID^报表日期)
/// Return：	月报审核表ID
ClassMethod SubmitReport(parr As %String) As %String
{
	//w ##class(web.DHCMGNurMonReport).SubmitReport("1^1^1^2010-07-07")
	s ReportId=$P(parr,"^",1)
	q:ReportId="" ""
	s dep=$P(parr,"^",2)
	s PersonId=$P(parr,"^",3)
	s ReportDate=$P(parr,"^",4)
	i ReportDate="" s ReportDate=$ZD(+$h,3)
	s curDate=..GetMonStartEndDate(ReportDate)
	s stdate=$ZD($P(curDate,"^",1),3)
	s edate=$ZD($P(curDate,"^",2),3)
	
	s Report=^User.DHCMGNurMonReportD(ReportId)
	s AuditDr=$List(Report,31)
	s parr=AuditDr_"^"_PersonId_"^"_stdate_"^"_edate_"^"_dep
	b //000
	s AuditId=##class(User.DHCMGNurMonAudit).SubmitArrange(parr)
	s Mon=##class(User.DHCMGNurMonReport).%OpenId(ReportId)
	s Mon.AuditDr=##class(User.DHCMGNurMonAudit).%OpenId(AuditId)
	d Mon.%Save()
	q AuditId
}

/// Creator: 	wxl
/// CreatDate: 	2010-07-12
/// Description:判所选日期内是否已有月报
/// Table：		User.DHCMGNurMonReport
/// Input：		parr(科室ID^开始日期^结束日期)
/// Return：	有返回Y,否则N
ClassMethod IfExistMonReport(parr As %String) As %String
{
	//w ##class(web.DHCMGNurMonReport).IfExistMonReport("1^2010-07-01^2010-07-12")
	s flag="N"
	s dep=$P(parr,"^",1)
 	s stdate=$P(parr,"^",2)
	s edate=$P(parr,"^",3)
	s stdate1=$ZDH(stdate,3)
	s edate1=$ZDH(edate,3)
	s perId=$P(parr,"^",4)
	s manager=$P(parr,"^",5)
	for date=stdate1:1:edate1
	{
		s loc=""  f  s loc=$O(^User.DHCMGNurMonReportI("DepDate",loc)) q:(loc="")!(flag="Y")  d
	    .s curloc=$Tr(loc," ","")
	    .q:(curloc'=dep)&(dep'="")
	    .s rw=""  f  s rw=$O(^User.DHCMGNurMonReportI("DepDate",loc,date,rw)) q:(rw="")!(flag="Y")  d
	    ..s monuser=$ListGet(^User.DHCMGNurMonReportD(rw),5)
	    ..s monmanager=$ListGet(^User.DHCMGNurMonReportD(rw),37)
		..i manager="Y",perId=monuser,monmanager="Y" s flag="Y"
	    ..i manager'="Y" s flag="Y"
	    if flag="Y" q
	}
	q flag
}

/// Creator: 	wxl
/// CreatDate: 	2010-07-28
/// Description:取存在问题(分项目显示)
/// Table：		User.DHCMGNurMonReport
/// Input：		parr(科室ID^月份^HIS安全组)
/// Return：	项目1名称$C(1)备注1$C(1)项目1ID$C(1)记录1ID$C(2)项目2名称$C(1)备注2$C(1)项目2ID$C(1)记录2ID.....
ClassMethod GetQualRefun(parr As %String) As %String
{
	//w ##class(web.DHCMGNurMonReport).GetQualRefun("1^2010-7^1")
	s dep=$P(parr,"^",1)
	s mon=$P(parr,"^",2)
	s ssgroup=$P(parr,"^",3)
	q:(dep="")!(mon="")!(ssgroup="") ""
	s type=$P(parr,"^",4)
	s group=##class(User.DHCMGSSGRPRELHISGRP).getgrp(ssgroup)
	s group=+group		//1^A
	q:group=0 ""
	k QualNote
	s rw="" f  s rw=$O(^User.DHCMGNurExamQualI("DepMon"," "_group," "_dep," "_mon,rw)) q:rw=""  d
	.s Qual=^User.DHCMGNurExamQualD(rw)
	.s QualItm=$List(Qual,3)
	.q:QualItm=""
	.s Note=$List(Qual,13)
	.s QualNote(QualItm)=Note_"^"_rw
	b //000
	s ret=""
	s Itm=##class(User.DHCMGNurExamTyp).GetExamCode("QUAL^"_type)
	s ItmLn=$L(Itm,"^")
	for i=1:1:ItmLn
	{
		s ItmStr=$P(Itm,"^",i)
		s ItmId=$P(ItmStr,"|",1)
		s ItmDesc=$P(ItmStr,"|",2)
		if ItmId="" continue
		s note=$P($G(QualNote(ItmId)),"^",1)
		s rw=$P($G(QualNote(ItmId)),"^",2)
		if ret'="" s ret=ret_$C(2)_ItmDesc_$C(1)_note_$C(1)_ItmId_$C(1)_rw
		else  s ret=ItmDesc_$C(1)_note_$C(1)_ItmId_$C(1)_rw
	}
	q ret
}

/// Creator: 	wxl
/// CreatDate: 	2010-07-28
/// Description:取存在问题(汇总显示)
/// Table：		User.DHCMGNurMonReport
/// Input：		parr(科室ID^月份^HIS安全组)
/// Return：	项目1名称$C(1)备注1$C(1)项目1ID$C(1)记录1ID$C(2)项目2名称$C(1)备注2$C(1)项目2ID$C(1)记录2ID.....
ClassMethod GetQualRefunTotal(parr As %String) As %String
{
	//w ##class(web.DHCMGNurMonReport).GetQualRefunTotal("1^2010-7^1")
	s dep=$P(parr,"^",1)
	s mon=$P(parr,"^",2)
	s ssgroup=$P(parr,"^",3)
	q:(dep="")!(mon="")!(ssgroup="") ""
	s group=##class(User.DHCMGSSGRPRELHISGRP).getgrp(ssgroup)
	s group=+group		//1^A
	q:group=0 ""
	s ret=""
	s rw="" f  s rw=$O(^User.DHCMGNurExamQualI("DepMon"," "_group," "_dep," "_mon,rw)) q:rw=""  d
	.s Qual=^User.DHCMGNurExamQualD(rw)
	.s QualItm=$List(Qual,3)
	.q:QualItm=""
	.s Note=$List(Qual,13)
	.s QualNote(QualItm)=Note
	s Itm=##class(User.DHCMGNurExamTyp).GetExamCode("QUAL")
	s ItmLn=$L(Itm,"^")
	for i=1:1:ItmLn
	{
		s ItmStr=$P(Itm,"^",i)
		s ItmId=$P(ItmStr,"|",1)
		s ItmDesc=$P(ItmStr,"|",2)
		if ItmId="" continue
		s Note=$P($G(QualNote(ItmId)),"^",1)
		if Note="" continue
		i ret="" s ret=ItmDesc_":"_Note
		e  s ret=ret_" "_ItmDesc_":"_Note
	}
	q ret
}

/// Creator: 	wxl
/// CreatDate: 	2010-07-28
/// Description:保存存在问题
/// Table：		User.DHCMGNurMonReport
/// Input：		parr(科室ID$C(3)月份$C(3)HIS安全组$C(3)项目1的ID$C(1)质控记录1的ID$C(1)备注1$C(2)项目2的ID$C(1)质控记录2的ID$C(1)备注2......)
/// Return：	成功为0,否则非0
ClassMethod SaveQualNote(parr As %String) As %String
{
	//w ##class(web.DHCMGNurMonReport).SaveQualNote("")
	//s parr="1"_$C(3)_"2010-7"_$C(3)_"1"_$C(3)_"1"_$C(1)_"1"_$C(1)_"qqqqqqqqqqqqqq"_$C(2)_"2"_$C(1)_"2"_$C(1)_"qqqqqqqqqqqqqq"_$C(2)_"3"_$C(1)_"3"_$C(1)_"qqqqqqqqqqqqqq"
	s dep=$P(parr,$C(3),1)
	s mon=$P(parr,$C(3),2)
	s ssgroup=$P(parr,$C(3),3)
	s notelist=$P(parr,$C(3),4)
	q:(dep="")!(mon="")!(ssgroup="")!(notelist="") ""
	s group=##class(User.DHCMGSSGRPRELHISGRP).getgrp(ssgroup)
	s group=+group		//1^A
	q:group=0 ""
	s stenddate=..GetMonStartEndDate(mon_"-01")
	s stdate=$P(stenddate,"^",1)
	s enddate=$P(stenddate,"^",2)
	s notelen=$L(notelist,$C(2))
	for i=1:1:notelen
	{
		s notestr=$P(notelist,$C(2),i)
		s ItmId=$P(notestr,$C(1),1)
		s qualId=$P(notestr,$C(1),2)
		s note=$P(notestr,$C(1),3)
		b //000
		if ItmId="" continue
		if qualId'="" d
		.s a=##class(User.DHCMGNurExamQual).%OpenId(qualId)
		.s qualdep=a.QualDep
		.i qualdep="" s a.QualDep=dep
		.s qualitm=a.QualItm
		.i qualitm="" s a.QualItm=##class(User.DHCMGNurExamTyp).%OpenId(ItmId)
		.s qualstdate=a.QualStDate
		.i qualstdate="" s a.QualStDate=stdate
		.s qualenddate=a.QualEndDate
		.i qualenddate="" s a.QualEndDate=enddate
		.s qualmon=a.QualMon
		.i qualmon="" s a.QualMon=mon
		.s qualgroup=a.QualGroup
		.i qualgroup="" s a.QualGroup=group 
		.s a.QualNote=note
		.d a.%Save()
		e  d
		.s a=##class(User.DHCMGNurExamQual).%New()
		.s a.QualDep=dep
		.s a.QualItm=##class(User.DHCMGNurExamTyp).%OpenId(ItmId)
		.s a.QualStDate=stdate
		.s a.QualEndDate=enddate
		.s a.QualMon=mon
		.s a.QualNote=note
		.s a.QualGroup=group
		.d a.%Save()
	}
	q 0
}

/// 查询质控安全组设置
ClassMethod FindExamGrpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExamGrpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod FindExamGrpExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	//d ##class(%ResultSet).RunQuery("web.DHCMGNurMonReport","FindExamGrp","4^")
 	s group=$P(parr,"^",1)
 	s examtyp=$P(parr,"^",2)
 	s grp="" f  s grp=$O(^User.DHCMGNurExamGrpI("Grp",grp)) q:grp=""  d 
 	.s curgrp=$Tr(grp," ","")
 	.q:(group'="")&(group'=curgrp)
 	.s id="" f  s id=$O(^User.DHCMGNurExamGrpI("Grp",grp,id)) q:id=""  d
 	..s a=^User.DHCMGNurExamGrpD(id)
   	..s mggroupid=$List(a,4)
   	..i mggroupid'="" s mggroup=$List(^User.DHCMGSSGROUPD(mggroupid),3)
   	..e  s mggroup=""
	..s typid=$List(a,2)
	..q:(examtyp'="")&(examtyp'=typid)
	..i typid'="" s typ=$List(^User.DHCMGNurExamTypD(typid),3)
	..e  s typ=""
	..s rw=id
	..d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(mggroup,typ,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindExamGrpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExamGrpExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindExamGrp(parr) As %Query(ROWSPEC = "mggroup,typ,rw")
{
}

/// 护理质控项填写的项目(H：HIS安全组,M：护理安组)
ClassMethod GetExamTypSub(parr As %String) As %String
{
 	//w ##class(web.DHCMGNurMonReport).GetExamTypSub("^3^1^M")
 	s id=$P(parr,"^",1)
 	s MGGroup=$P(parr,"^",2)
 	s ExamTyp=$P(parr,"^",3)
 	s ExamTypSub=""
 	s HISorMDGrp=$P(parr,"^",4)
 	s ret=""
 	if id'="" {
		s a=$G(^User.DHCMGNurExamGrpD(id))
 		if a'="" 
 		{
			s MGGroup=$List(a,4)
 			s ExamTypSub=$List(a,3)	
		}
	}
	else
	{
		if MGGroup'="",ExamTyp'="" 
		{
			if HISorMDGrp'="M"
			{
				s group=##class(User.DHCMGSSGRPRELHISGRP).getgrp(MGGroup)
				s MGGroup=+group		//1^A
			}
			s id="" f  s id=$O(^User.DHCMGNurExamGrpI("Grp"," "_MGGroup,id)) q:id=""  d
			.s a=^User.DHCMGNurExamGrpD(id)
			.s TypId=$List(a,2)
			.q:ExamTyp'=TypId
			.s ExamTypSub=$List(a,3)
		}	
	}
	s TypSubArr=##class(User.DHCMGNurExamGrp).GetTypSub(MGGroup_"^"_ExamTyp)
	s TypSubLn=$L(TypSubArr,"^")
	for i=1:1:TypSubLn
	{
		s TypSubStr=$P(TypSubArr,"^",i)
		s TypSubDesc=$P(TypSubStr,"|",2)
		if TypSubDesc="" continue
		if ret="" s ret=$P(ExamTypSub,"!",i)_"^"_TypSubDesc
		else  s ret=ret_"@"_$P(ExamTypSub,"!",i)_"^"_TypSubDesc
	}
	q ret
}

/// 护理质控项查询(护士长^科护士长^护理部安全组的ID)
ClassMethod GetExamGrp(GrpStr = "") As %String
{
	//w ##class(web.DHCMGNurMonReport).GetExamGrp("")
	s ret=""
	k ExamGrp
	s grpdr=""  f  s grpdr=$O(^User.DHCMGNurExamGrpI("Grp",grpdr)) q:grpdr=""  d
	.s rw=$Tr(grpdr," ","")
	.b //00
	.s name=$List(^User.DHCMGSSGROUPD(rw),2)
	.s ExamGrp(name)=rw
	if GrpStr="" s GrpStr="护士长^超级^护理部"   //"护士长^科护士长^护理部"
	s GrpLen=$L(GrpStr,"^")
	for i=1:1:GrpLen
	{
		s GrpDesc=$P(GrpStr,"^",i)
		if ret="" s ret=$G(ExamGrp(GrpDesc))_"|"_GrpDesc
		e  s ret=ret_"^"_$G(ExamGrp(GrpDesc))_"|"_GrpDesc
	}
   	q ret
}

/// 取安全组的描述
ClassMethod GetGroup(parr = "") As %String
{
	//w ##class(web.DHCMGNurMonReport).GetGroup("1^H")
	s mggroup=$P(parr,"^",1)
	s grptyp=$P(parr,"^",2)
	if grptyp'="M"
	{
		s group=##class(User.DHCMGSSGRPRELHISGRP).getgrp(mggroup)
		s mggroup=+group		//1^A
	}
	s ret=""
	if mggroup'=""
	{
		s mggroupdesc=$List(^User.DHCMGSSGROUPD(mggroup),3)
		s mggrouptyp=$ListGet(^User.DHCMGSSGROUPD(mggroup),4)
		s ret=mggroup_"^"_mggroupdesc_"^"_mggrouptyp
	}
   	q ret
}

/// Creator: 	wxl
/// CreatDate: 	2010-06-22
/// Description:护理质控项查询(护士长--总数/平均分/合格率界面)
/// Table:		User.DHCMGNurExamQual
/// Input:		parr(科室^开始日期^结束日期^是否平均^HIS安全组^登陆用户^返回记录的开始数目值^返回记录的结束数目值)
/// Return：
ClassMethod GetGrpQual(parr As %String) As %String
{
	//w ##class(web.DHCMGNurMonReport).GetGrpQual("^2010-08-01^2010-08-31^Y^1^1^50^")
	s dep=$P(parr,"^",1)
	s stdate=$P(parr,"^",2)
	s edate=$P(parr,"^",3)
	s flag=$P(parr,"^",4)
	s SSGroup=$P(parr,"^",5)
	s Group=##class(User.DHCMGSSGRPRELHISGRP).getgrp(SSGroup)
	s Group=+Group		//1^A
	q:Group=0 ""
	s deptyp=$P(Group,"^",2)
	s UserID=$P(parr,"^",6)
	s type=$P(parr,"^",7)
	s startnum=+$P(parr,"^",8)			//返回记录的开始数目值(1到30,31到60等)
	s endnum=+$P(parr,"^",9)			//返回记录的结束数目值
	s StYear=+$P(stdate,"-",1)
	s StMonth=+$P(stdate,"-",2)
	s EndYear=+$P(edate,"-",1)
	s EndMonth=+$P(edate,"-",2)
	s YearMonth=""
	for Year=StYear:1:EndYear
	{
		for Month=StMonth:1:EndMonth
		{
			i YearMonth="" s YearMonth=Year_"-"_Month
			e  s YearMonth=YearMonth_"^"_Year_"-"_Month
		}
	}
	k GrpQual
	i stdate'="" s stdate=$ZDH(stdate,3)
	i edate'="" s edate=$ZDH(edate,3)
    for date=stdate:1:edate
    {
		s grp="" 
		s grp="" f  s grp=$O(^User.DHCMGNurExamQualI("DepDate",grp)) q:grp=""  d
		.s loc="" f  s loc=$O(^User.DHCMGNurExamQualI("DepDate",grp,loc)) q:loc=""  d
		..s curloc=$Tr(loc," ","")
		..q:(dep'="")&(dep'=curloc)
		..s rw="" f  s rw=$O(^User.DHCMGNurExamQualI("DepDate",grp,loc,date,rw)) q:rw=""  d
		...s StYear=+$P($ZD(date,3),"-",1)
		...s StMonth=+$P($ZD(date,3),"-",2)
		...s StYearMonth=StYear_"-"_StMonth
		...s Qual=^User.DHCMGNurExamQualD(rw)
		...s QualDep=$List(Qual,2)
		...s QualItm=$List(Qual,3)
		...q:QualItm=""
		...s QualNum=$List(Qual,4)
		...s QualScore=$List(Qual,5)
		...s QualPercent=$List(Qual,6)
		...s QualStDate=$List(Qual,10)
		...s QualEndDate=$List(Qual,11)
		...s QualCareNum=$List(Qual,14)
		...s QualDischNum=$List(Qual,15)
		...s QualDischScore=$List(Qual,17)
		...s QualDischPercent=$List(Qual,16)
		...s QualGroup=$List(Qual,18)
		...s GrpQual(QualDep,StYearMonth,QualItm,QualGroup)=QualCareNum_"^"_QualNum_"^"_QualScore_"^"_QualPercent_"^"_QualDischNum_"^"_QualDischScore_"^"_QualDischPercent
    }
    b //000
	i deptyp="" s deptyp="NUR"
	//s ret=##class(web.DHCMGPERSON).GetSortDep(deptyp)
	s ret=##class(User.DHCMGNurExamDepSort).GetSortDep(type)
	s ln=$L(ret,"^")
	s Grp=##class(web.DHCMGNurMonReport).GetExamGrp("")
	s GrpLn=$L(Grp,"^")
	s Itm=##class(User.DHCMGNurExamTyp).GetExamCode("QUAL^"_type)
	s ItmLn=$L(Itm,"^")
	s YearMonthLn=$L(YearMonth,"^")
	k AveGrpQual
	s datatb=""
	for i=1:1:ln
	{
		if (startnum>0)&(i<startnum) continue
		if (endnum>0)&(i>endnum) continue
		s curdep=$P(ret,"^",i)
		if curdep="" continue
		s rowdata=""
		s depId=$P(curdep,"|",1),depdes=$P(curdep,"|",2)
		i $L(depdes,"-")>1 s depdes=$P(depdes,"-",2)
		if ((depId'=dep)&(dep'="")) continue
		s averowdata=""
		for j=1:1:YearMonthLn
		{
			s StYearMonth=$P(YearMonth,"^",j)
			if StYearMonth="" continue
			s rowdata=""
			if $D(GrpQual(depId,StYearMonth))>0 
			{
				//b //1
				for k=1:1:ItmLn
				{
					s QualItm=$P(Itm,"^",k)
					s QualRw=$P(QualItm,"|",1)
					if QualRw="" continue
					for l=1:1:GrpLn
					{
						s QualGrp=$P(Grp,"^",l)
						s QualGrpRw=$P(QualGrp,"|",1)
						if QualGrpRw="" continue
						s CareNum=$P($G(GrpQual(depId,StYearMonth,QualRw,QualGrpRw)),"^",1)
						s Num=$P($G(GrpQual(depId,StYearMonth,QualRw,QualGrpRw)),"^",2)
						s Score=$P($G(GrpQual(depId,StYearMonth,QualRw,QualGrpRw)),"^",3)
						s Percent=$P($G(GrpQual(depId,StYearMonth,QualRw,QualGrpRw)),"^",4)
						s DischNum=$P($G(GrpQual(depId,StYearMonth,QualRw,QualGrpRw)),"^",5)
						s DischScore=$P($G(GrpQual(depId,StYearMonth,QualRw,QualGrpRw)),"^",6)
						s DischPercent=$P($G(GrpQual(depId,StYearMonth,QualRw,QualGrpRw)),"^",7)
						s rowdata=rowdata_CareNum_"^"_Num_"^"_Score_"^"_Percent_"^"_DischNum_"^"_DischScore_"^"_DischPercent_"^"
						s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",1)=+$P($G(AveGrpQual(depId,QualRw,QualGrpRw)),"^",1)+CareNum
						s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",2)=+$P($G(AveGrpQual(depId,QualRw,QualGrpRw)),"^",2)+Num
						s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",3)=+$P($G(AveGrpQual(depId,QualRw,QualGrpRw)),"^",3)+Score
						s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",4)=+$P($G(AveGrpQual(depId,QualRw,QualGrpRw)),"^",4)+Percent
						s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",5)=+$P($G(AveGrpQual(depId,QualRw,QualGrpRw)),"^",5)+DischNum
						s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",6)=+$P($G(AveGrpQual(depId,QualRw,QualGrpRw)),"^",6)+DischScore
						s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",7)=+$P($G(AveGrpQual(depId,QualRw,QualGrpRw)),"^",7)+DischPercent
					}
				}	
			}
			else
			{
				//b //2
				for k=1:1:ItmLn
				{
					s QualItm=$P(Itm,"^",k)
					s QualRw=$P(QualItm,"|",1)
					if QualRw="" continue
					for l=1:1:GrpLn
					{
						s QualGrp=$P(Grp,"^",l)
						s QualGrpRw=$P(QualGrp,"|",1)
						if QualGrpRw="" continue					
						s CareNum=""
						s Num=""
						s Score=""
						s Percent=""
						s DischNum=""
						s DischScore=""
						s DischPercent=""
						s rowdata=rowdata_CareNum_"^"_Num_"^"_Score_"^"_Percent_"^"_DischNum_"^"_DischScore_"^"_DischPercent_"^"
						s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",1)=+$P($G(AveGrpQual(depId,QualRw,QualGrpRw)),"^",1)+CareNum
						s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",2)=+$P($G(AveGrpQual(depId,QualRw,QualGrpRw)),"^",2)+Num
						s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",3)=+$P($G(AveGrpQual(depId,QualRw,QualGrpRw)),"^",3)+Score
						s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",4)=+$P($G(AveGrpQual(depId,QualRw,QualGrpRw)),"^",4)+Percent
						s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",5)=+$P($G(AveGrpQual(depId,QualRw,QualGrpRw)),"^",5)+DischNum
						s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",6)=+$P($G(AveGrpQual(depId,QualRw,QualGrpRw)),"^",6)+DischScore
						s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",7)=+$P($G(AveGrpQual(depId,QualRw,QualGrpRw)),"^",7)+DischPercent			
					}
				}	
			}	
			//b //3
			if (flag="Y")&(j=YearMonthLn) 
			{
				for k=1:1:ItmLn
				{
					s QualItm=$P(Itm,"^",k)
					s QualRw=$P(QualItm,"|",1)
					if QualRw="" continue
					for l=1:1:GrpLn
					{
						s QualGrp=$P(Grp,"^",l)
						s QualGrpRw=$P(QualGrp,"|",1)
						if QualGrpRw="" continue			
						s QualScore=$P(AveGrpQual(depId,QualRw,QualGrpRw),"^",3)
						s QualScore=QualScore/YearMonthLn
						if $L(QualScore,".")>1 s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",3)=$Fn(QualScore,"",1)
						else  s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",3)=QualScore
						s QualPercent=$P(AveGrpQual(depId,QualRw,QualGrpRw),"^",4)
						s QualPercent=QualPercent/YearMonthLn
						if $L(QualPercent,".")>1 s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",4)=$Fn(QualPercent,"",1)_"%"
						else  s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",4)=QualPercent		//_"%" 
						s QualDischScore=$P(AveGrpQual(depId,QualRw,QualGrpRw),"^",6)
						s QualDischScore=QualDischScore/YearMonthLn
						if $L(QualDischScore,".")>1 s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",6)=$Fn(QualDischScore,"",1)
						else  s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",6)=QualDischScore
						s QualDichPercent=$P(AveGrpQual(depId,QualRw,QualGrpRw),"^",4)
						s QualDichPercent=QualDichPercent/YearMonthLn
						if $L(QualDichPercent,".")>1 s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",4)=$Fn(QualDichPercent,"",1)_"%"
						else  s $P(AveGrpQual(depId,QualRw,QualGrpRw),"^",4)=QualDichPercent		//_"%" 
						s averowdata=averowdata_AveGrpQual(depId,QualRw,QualGrpRw)_"^"
					}
				}
			}
			if flag'="Y" s datatb=datatb_depId_"^"_depdes_"^"_rowdata_StYearMonth_$C(2)
		}
		if flag="Y" s datatb=datatb_depId_"^"_depdes_"^"_averowdata_$Tr(YearMonth,"^"," ")_$C(2)
	}
	q datatb
}

/// 护理质控项查询打印配置
ClassMethod GrpPrintSet(typ) As %String
{
	//w ##class(web.DHCMGNurMonReport).GrpPrintSet(typ)
	//现共8个质控项目
	//第一页打印1页//第二页打印4个//剩下打印第3页
	//第一页开始项位置!结束项位置!列宽^第二页开始项位置!结束项位置!列宽^第二页开始项位置!结束项位置!列宽@题头
	s ret="0!3!3.5^3!7!6^7!8!4@病房护理质量(信息)反馈"
   	i typ="O" s ret="0!3!5@门诊综合质量检查信息反馈"
   	i typ="OP" s ret="0!4!4@ICU、急诊、手术室、供应室、导管室综合质量评价结果反馈"
   	q ret
}

/// 病区月报打印配置
ClassMethod MonReportPrintSet() As %String
{
	//w ##class(web.DHCMGNurMonReport).MonReportPrintSet()
	//对应Excel模版中第几行,B5/A4切换用
	//休假^借出借入^专科业备培训^护理查房^操作培训考评^护理质控^报表人
	s ret="13^22^32^40^49^59^74"
   	q ret
}

/// Creator: 	wxl
/// CreatDate: 	2010-08-06
/// Description:取科护士长设置
/// Table：		User.DHCMGNurExamDep
/// Input：		parr
/// Return：	
ClassMethod FindNurDepExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//d ##class(%ResultSet).RunQuery("web.DHCMGNurMonReport","FindNurDep","^")
 	s nur=$P(parr,"^",1)
 	s dep=$P(parr,"^",2)
	
	s rw="" f  s rw=$O(^User.DHCMGNurExamDepD(rw)) q:(rw="")  d
	.s a=^User.DHCMGNurExamDepD(rw)
	.s depId=$List(a,2)
	.q:(dep'="")&(dep=depId)
	.s depdesc=$P(^CTLOC(depId),"^",2)
	.s nurId=$List(a,3)
	.q:(nur'="")&(nur=nurId)
	.s nurname=$list(^User.DHCMGPersonsD(nurId),21)
	.d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(nurname,depdesc,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindNurDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurDepExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNurDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindNurDep(parr As %String) As %Query(ROWSPEC = "nurname,depdesc,rw")
{
}

Storage Default
{
<Data name="DHCMGNurMonReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCMGNurMonReportD</DataLocation>
<DefaultData>DHCMGNurMonReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCMGNurMonReportD</IdLocation>
<IndexLocation>^web.DHCMGNurMonReportI</IndexLocation>
<StreamLocation>^web.DHCMGNurMonReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
