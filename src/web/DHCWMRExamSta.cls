Import SQLUser

Class web.DHCWMRExamSta Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 337;

ClassMethod StringDecode(str)
{
	quit:(str = $c(0)) ""
	set strTmp = ""
	set intCounter = 0
	set tmp = ""
	for intCounter = 1 : 1 : $l(str, ".")
	{
		set tmp = $c($p(str,".",intCounter))
		if (tmp '= $c(0))
		{
			set strTmp = strTmp_tmp
		}
	}
	quit strTmp
}

//查询指定日期的病案检查结果

ClassMethod QueryExamResult(RuleID, From, To, DateType)
{
	n (RuleID, From, To, DateType)
	set VolumeID=""
	set intCounter = 0
	set value=""
	set ResultID=""
	set intCounter=0
	//set From=$zdh(From,3)
	//set To=$zdh(To,3)
	k ^CacheTemp("ExamResult",$j)
	if ($d(^DHCWMRERST(0,"RuleVol",RuleID))&&((DateType=1)!(DateType=2))) //通过住院\出院日期查询检查结果
	{
		while (1)
		{
			set VolumeID=($o(^DHCWMRERST(0,"RuleVol",RuleID,VolumeID)))
			quit:VolumeID=""
			set AdmInfo=##class(web.DHCWMRBaseInfoCtl).GetAdmInfoByVol(VolumeID)
			if (DateType=1)
			{
				set value=$p(AdmInfo,"^",3) 	
			}
			if (DateType=2)
			{
				set value=$p(AdmInfo,"^",7)
				if (value = "")
				{
					set value = "1900-01-01"
				}
			}
			s value=$zdh(value,3)
			
			if ((value'<From)&&(value'>To))
			{
				set ResultID=""
				while(1)
				{
					set ResultID=$o(^DHCWMRERST(0,"RuleVol",RuleID,VolumeID,ResultID))
					q:ResultID=""
					set intCounter=intCounter+1
					set ^CacheTemp("ExamResult",$j,intCounter)=ResultID
				}
			}
		}
	}

	if ($d(^DHCWMRERST(0,"RuleDate",RuleID))&&(DateType=3)) //检查日期查询检查结果
	{
		set TmpDate=From-1		
		set ResultID=""
		while (1)
		{
			set TmpDate=$o(^DHCWMRERST(0,"RuleDate",RuleID,TmpDate))
			quit:(TmpDate="")!(TmpDate>To)
			set ResultID=""
			while (1)
			{
				quit:$d(^DHCWMRERST(0,"RuleDate",RuleID,TmpDate))=0
				set ResultID=$o(^DHCWMRERST(0,"RuleDate",RuleID,TmpDate,ResultID))
				quit:ResultID=""
				set Result=^DHCWMRERST(ResultID)
				set value=$p(Result,"^",11) //检查日期
				if ((value'<From)&&(value'>To))
				{
					set ResultID=$o(^DHCWMRERST(0,"RuleDate",RuleID,TmpDate,ResultID))
					q:ResultID=""
					set intCounter=intCounter+1					
					set ^CacheTemp("ExamResult",$j,intCounter)=ResultID
				}
			}
		}
	}
	quit intCounter
}

ClassMethod QueryExamDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExamDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Kill ^CacheTemp("ExamResult", $j)
	Quit $$$OK
}

ClassMethod QueryExamDetailExecute(ByRef qHandle As %Binary, RuleID As %String, From As %String, To As %String, DateType As %String, Department As %String, SubDepartment As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	quit:(From="")!(To="")!(RuleID="") $$$OK
	set:From["/" From=$zdh(From,4)
	set:To["/" To=$zdh(To,4)
	set:From["-" From=$zdh(From,3)
	set:To["-" To=$zdh(To,3)	
	set Department = ..StringDecode(Department)
	set SubDepartment = ..StringDecode(SubDepartment)
	set intCnt = ..QueryExamResult(RuleID, From, To, DateType)
	set intCounter = 0
	set resultID=""
	set Result=""
	set intProblemCnt=""
	set intCounter1 = 0
	set Problem=""
	set EntryID=""
	for intCounter=1:1:intCnt
	{
		set resultID=^CacheTemp("ExamResult", $j, intCounter)
		set Result=$g(^DHCWMRERST(resultID))
		q:Result=""
		set VolumeAdm=##class(web.DHCWMRBaseInfoCtl).GetAdmInfoByVol($p(Result,"^",1))
		set VolumeInfo=##class(web.DHCWMRVolumeCtl).GetVolInfoByVol($p(Result,"^",1))
		set Volume=##class(web.DHCWMRVolumeCtl).GetVolume($p(Result,"^",1))
		set MainInfo=##class(web.DHCWMRMainCtl).GetMainById($p(Volume,"^",2))
		set intProblemCnt=$g(^DHCWMRERST(resultID,"D",0))
		continue:$p(VolumeAdm,"^",9)=""
		set strLoc = $o(^CTLOC(0,"Desc", $p(VolumeAdm,"^",9), ""))
		
		set strDep = ""
		if (strLoc '= "")
		{
			set strLoc = ^CTLOC(strLoc)
			if $d(^RBC("DEP", $p(strLoc,"^",19)))'=0
			{
				set strDep = ^RBC("DEP", $p(strLoc,"^",19))
			}
		}

		//b
		if (((Department="")!(strDep=Department))&((SubDepartment="")!(strLoc=SubDepartment)))
		{
			for intCounter1=1:1:intProblemCnt
			{
				set Problem=^DHCWMRERST(resultID,"D",intCounter1)
				if ($p(Problem,"^",7)="Y")
				{			
					set data = $$BuildQueryExamDetailData(MainInfo,VolumeInfo,VolumeAdm,Problem,resultID,intCounter1,strDep)
					Set ^CacheTemp(repid,ind)=data
					Set ind=ind+1
				}
			}
		}
		
	}	
	Quit $$$OK
	
BuildQueryExamDetailData(MainInfo,VolumeInfo,VolumeAdm,Problem,ResultID,ProblemChildSub,Dep)
	n (MainInfo,VolumeInfo,VolumeAdm,Problem,ResultID,ProblemChildSub,Dep)
	set MrTypeDic = ##class(web.DHCWMRDictionaryCtl).GetDataById($p(MainInfo,"^",2))
	set EntryID=$p(Problem,"^",1)
	set Entry = ##class(web.DHCWMRExamRuleCtl).ByIdGetEntry(EntryID)
	set EntryData=$p(Entry,$c(2),1)  //原始信息	
	set EntryItem = $p(Entry,$c(2),2) //格式化后的信息
	set SectionID = $p(EntryID,"||",1)_"||"_$p(EntryID,"||",2)
	set Section = ##class(web.DHCWMRExamRuleCtl).ByIdGetSection(SectionID)
	set PeopleCnt = $g(^DHCWMRERST(ResultID,"D",ProblemChildSub,"P",0))
	set People = ""
	set intCounter=0
	set kind = ""
	set strLoc = $o(^CTLOC(0,"Desc", $p(VolumeAdm,"^",9), ""))
	set strDep = Dep
	set People="" //"责任人："
	set PatientInfo = ##Class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(+$p(MainInfo,"^",1))
	for intCounter=1:1:PeopleCnt
	{
		set PeopleStr=^DHCWMRERST(ResultID,"D",ProblemChildSub,"P",intCounter)
		if ($p(PeopleStr,"^",3)'="")
		{
			set kind=##class(web.DHCWMRDictionaryCtl).GetDataById($p(PeopleStr,"^",3))
		}		
		set person=##class(web.DHCMedBaseCtl).GetUsrStr($p(PeopleStr,"^",2))
		set People=People_$p(person,"/",2)_" "_$p(person,"/",3)
		//b
	}
	//MrType:%String,MrNo:%String,PatientName:%String,Sex:%String,Age:%String,
	//DischargeDate:%String,DischargeDep:%String,DischargeSubDep:%String,
	//Section:%String,Entry:%String,Times:%String,Score:%String,
	//Money:%String,HappendDate:%String,People:%String,AdmitDate:%String
	Set Data=$lb("")
	Set $li(Data,1)=$p(MrTypeDic,"^",4)                      //MrType
	Set $li(Data,2)=$p(MainInfo,"^",3)                     //MrNo,
	Set $li(Data,3)=$p(PatientInfo,"^",2)                  //姓名,
	Set $li(Data,4)=$p(PatientInfo,"^",4)                      //sex,
	Set $li(Data,5)=$p(PatientInfo,"^",6)                       //age,
	Set $li(Data,6)=$p(VolumeAdm,"^",7)                        //discharge date,
	Set $li(Data,7)= strDep                //Discharge dep
	Set $li(Data,8)=$p(VolumeAdm,"^",9)                  //Discharge dep
	Set $li(Data,9)=$p(Section,"^",8)                   //Section
	Set $li(Data,10)=$p(EntryItem,"^",3)                  //Entry
	Set $li(Data,11)=$p(Problem,"^",2)                      //times
	Set $li(Data,12)=$p(Problem,"^",3)               //score
	Set $li(Data,13)=$p(Problem,"^",4)                   //Money
	Set $li(Data,14)=$zd($p(Problem,"^",5),3)				//触发日期
	Set $li(Data,15)=People                 //责任人	
	Set $li(Data,16)=$p(kind,"^",4) //$p(Problem,"^",6)				//问题类型

	Set $li(Data,17)=$p(VolumeAdm,"^",3)
 	Quit Data
}

ClassMethod QueryExamDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExamDetailExecute ]
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

Query QueryExamDetail(RuleID As %String, From As %String, To As %String, DateType As %String, Department As %String, SubDepartment As %String) As %Query(ROWSPEC = "MrType:%String:病案类型,MrNo:%String:病案号,PatientName:%String:病人姓名,Sex:%String:性别,Age:%String:年龄,DischargeDate:%String:出院日期,DischargeDep:%String:科室,DischargeSubDep:%String:病区,Section:%String:大类,Entry:%String:条目,Times:%Numeric:次数,Score:%Numeric:扣分,Money:%Numeric:扣款,HappendDate:%String:发生时间,People:%String:责任人,ProblemType:%String:问题类型,AdmitDate:%String:住院日期")
{
}

//--------------------------------按问题统计------------------------------------

ClassMethod StaByProblemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaByProblemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Kill ^CacheTemp("ExamResult", $j)
 	Kill ^CacheTemp("StaByProblem", $j)
	Quit $$$OK
}

ClassMethod StaByProblemExecute(ByRef qHandle As %Binary, RuleID As %String, From As %String, To As %String, DateType As %String, Department As %String, SubDepartment As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	quit:(From="")!(To="")!(RuleID="") $$$OK
	set:From["/" From=$zdh(From,4)
	set:To["/" To=$zdh(To,4)
	set:From["-" From=$zdh(From,3)
	set:To["-" To=$zdh(To,3)	
	set ^CacheTemp("From") = Department
	set Department = ..StringDecode(Department)
	set SubDepartment = ..StringDecode(SubDepartment)

	
	//set ^CacheTemp("To") = Department
	//set ^CacheTemp("RuleID") = Department
	set intCnt = ..QueryExamResult(RuleID, From, To, DateType)
	//w intCnt
	quit:intCnt=0 $$$OK
	set intCounter = 0
	set resultID=""
	set Result=""
	set intProblemCnt=""
	set intCounter1 = 0
	set Problem=""
	set EntryID=""
	s i = 0
	for intCounter=1:1:intCnt
	{
		set resultID=^CacheTemp("ExamResult", $j, intCounter)
		set Result=$g(^DHCWMRERST(resultID))
		if (Result '= "")
		{
			set VolumeAdm=##class(web.DHCWMRBaseInfoCtl).GetAdmInfoByVol($p(Result,"^",1))
			set VolumeInfo=##class(web.DHCWMRVolumeCtl).GetVolInfoByVol($p(Result,"^",1))
			set Volume=##class(web.DHCWMRVolumeCtl).GetVolume($p(Result,"^",1))
			set MainInfo=##class(web.DHCWMRMainCtl).GetMainById($p(Volume,"^",2))
			set intProblemCnt=$g(^DHCWMRERST(resultID,"D",0))
			set strLoc = $o(^CTLOC(0,"Desc", $p(VolumeAdm,"^",9), ""))
			set strDep = ""
			set score = 0
			set times = 0
			set money = 0
			if (strLoc '= "")
			{
				set strLoc = ^CTLOC(strLoc)
				if $d(^RBC("DEP", $p(strLoc,"^",19)))'=0
				{
					set strDep = ^RBC("DEP", $p(strLoc,"^",19))
				}else
				{
					set strDep = "其他"
				}
			}else
			{
				set strLoc = "其他"
			}
			set:(Department="") strDep="全部"
			set:(SubDepartment="") strLoc="全部"
			if (((Department="")!(strDep=Department))&&((SubDepartment="")!(strLoc=SubDepartment)))
			{
				for intCounter1=1:1:intProblemCnt
				{
					set Problem=^DHCWMRERST(resultID,"D",intCounter1)
					if ($p(Problem,"^",7)="Y")
					{
						set EntryID=$p(Problem,"^",1)
						set SectionID = $p(EntryID,"||",1)_"||"_$p(EntryID,"||",2)
						set strData = $g(^CacheTemp("StaByProblem", $j, strDep, strLoc, EntryID))
						set $p(strData,"^",1)=$p(strData,"^",1) + $p(Problem, "^", 2)
						set $p(strData,"^",2)=$p(strData,"^",2) + $p(Problem, "^", 3)
						set $p(strData,"^",3)=$p(strData,"^",3) + $p(Problem, "^", 4)
						//w !,strDep_"  "_strLoc_"  "_SectionID_"  "_EntryID_"  "_strData
						set ^CacheTemp("StaByProblem", $j, strDep, strLoc, EntryID) = strData	
						//b	
						//set data = $$BuildStaByProblemData(MainInfo,VolumeInfo,VolumeAdm,Problem,resultID,intCounter1)
						//Set ^CacheTemp(repid,ind)=data
						//Set ind=ind+1
						//s i=i+1
					}
				}
			}
		}
		set strDep=""
	}
	do
	{
		set strDep=$o(^CacheTemp("StaByProblem", $j, strDep))
		if (strDep '= "")
		{
			set strLoc = ""
			do {
				set strLoc = $o(^CacheTemp("StaByProblem", $j, strDep, strLoc))
				if (strLoc '= "")
				{
					set EntryID = ""
					do  
					{
						set EntryID = $o(^CacheTemp("StaByProblem", $j, strDep, strLoc, EntryID))
						if (EntryID '= "")
						{
							set strData = ^CacheTemp("StaByProblem", $j, strDep, strLoc, EntryID)
							set strData = $$BuildStaByProblemData(strDep, strLoc, $p(EntryID,"||",1)_"||"_$p(EntryID,"||",2), EntryID, strData)
							Set ^CacheTemp(repid,ind)=strData
							Set ind=ind+1
							set EntryID = $o(^CacheTemp("StaByProblem", $j, strDep, strLoc, EntryID))	
						}
					} while (EntryID '= "")
				}
			}while (strLoc '= "")
		}
	} while(strDep'="")	
	Quit $$$OK
	
BuildStaByProblemData(Dep, Loc, SectionID, EntryID, strData)
	n (Dep, Loc, SectionID, EntryID, strData)
	set Entry = ##class(web.DHCWMRExamRuleCtl).ByIdGetEntry(EntryID)
	set EntryData=$p(Entry,$c(2),1)  //原始信息	
	set EntryItem = $p(Entry,$c(2),2) //格式化后的信息
	set Section = ##class(web.DHCWMRExamRuleCtl).ByIdGetSection(SectionID)

	Set Data=$lb("")
	Set $li(Data,1)=Dep                      //科室
	Set $li(Data,2)=Loc                     //二级科室,
	Set $li(Data,3)=$p(Section,"^",8)                     //Section ,
	Set $li(Data,4)=$p(EntryItem,"^",3)                       //Entry
	Set $li(Data,5)=$p(strData,"^",1)                       //数量
	Set $li(Data,6)=$p(strData,"^",2)                       //扣分
	Set $li(Data,7)= $p(strData,"^",3)                //扣款
 	Quit Data
}

ClassMethod StaByProblemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaByProblemExecute ]
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

Query StaByProblem(RuleID As %String, From As %String, To As %String, DateType As %String, Department As %String, SubDepartment As %String) As %Query(ROWSPEC = "Dep:%String:科室,SubDep:%String:病区,Section:%String:大项,Entry:%String:条目,Number:%String:数量,Score:%String:扣分,Money:%String:扣款")
{
}

//----------------------------------------------------------------------------------------

//

//成绩汇总

ClassMethod StaExamResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaExamResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Kill ^CacheTemp("StaExamResult", $j)
 	Kill ^CacheTemp("QueryVolumeByDate", $j)
 	Kill ^CacheTemp("StaExamResultGrade", $j)
	Quit $$$OK
}

//出院科室、出院人数、检察病例数量、检察覆盖率、甲级数量、乙级数量、丙级数量、单项否决数量、问题总数、最高分、最低分、平均分、扣款总额、甲级率、乙级率、丙级率

ClassMethod StaExamResultExecute(ByRef qHandle As %Binary, RuleID As %String, From As %String, To As %String, DateType As %String, DepType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	set:From["/" From=$zdh(From,4)
	set:To["/" To=$zdh(To,4)
	set:From["-" From=$zdh(From,3)
	set:To["-" To=$zdh(To,3)	
	set strGrade = ##class(web.DHCWMRExamRuleCtl).GetGardeByRuleId(RuleID, "Y")
	set intCounter = 0
	set strTmp = ""
	for intCounter=1:1:$l(strGrade, $c(1))
	{
		set strTmp = $p(strGrade, $c(1), intCounter)
		set ^CacheTemp("StaExamResultGrade", $j, $p(strTmp, "^" ,1))= intCounter - $l(strGrade, $c(2)) 
	}
	set intCnt = ##class(web.DHCWMRVolumeQuery).QueryVolumeByDate(From, To, DateType)
	set VolumeID = $o(^CacheTemp("QueryVolumeByDate", $j, ""))
	set strDep = "", strLoc = "", LocID = ""
	while (VolumeID '= "")
	{
		set Volume=$g(^DHCWMRVOL(VolumeID))
		set VolumeAdm=##class(web.DHCWMRBaseInfoCtl).GetAdmInfoByVol($p(VolumeID,"^",1))
		set LocID = ""
		set strLoc = $p(VolumeAdm,"^",9)
		if ($p(VolumeAdm,"^",9) '= "")
		{
			set LocID = $o(^CTLOC(0,"Desc", strLoc, ""))
		}
		if (LocID '= "")
		{
			set strLocInfo = ^CTLOC(LocID)
			if $d(^RBC("DEP", $p(strLocInfo,"^",19)))'=0
			{
				set strDep = ^RBC("DEP", $p(strLocInfo,"^",19))
			}else
			{
				set strDep = "其他"
			}
		}
		
		set:(strDep="") strDep="其他"
		set:(strLoc="") strLoc="其他"
		if (DepType '= "1")  //1-科室  2-病区
		{
			set strDep = strLoc
		}
		
		
		set strData = $g(^CacheTemp("StaExamResult", $j, strDep))
		set:strData="" strData="0^0^0^0^0^0^0^0^0^9999^0^0^0^0^0^0^0^0^"
		set $p(strData, "^", 1) = $p(strData, "^", 1) + 1 //出院人数

		set resultID = $o(^DHCWMRERST(0,"RuleVol",RuleID,VolumeID,""))
		while (resultID '= "")
		{
			set result = $g(^DHCWMRERST(resultID))
			if (($p(result, "^", 13) = "Y") && ($p(result, "^", 6) = "Y")) //要求是主评价+Active
			{
				set $p(strData, "^", 2) = $p(strData, "^", 2) + 1  //检查数量
				if ($p(strData, "^", 1) > 0)
				{
					set $p(strData, "^", 3) = ($p(strData, "^", 2) / $p(strData, "^", 1) * 100)_"%" //覆盖率
				}					
				set Level = $p(result, "^", 7)
				if (Level = "")
				{
					set Level = -100
				}
				
				if ($g(^CacheTemp("StaExamResultGrade", $j, Level)) = 2)
				{
					set $p(strData, "^", 4) = $p(strData, "^", 4) + 1  //甲级数量
				}	
				if ($g(^CacheTemp("StaExamResultGrade", $j, Level)) = 1)
				{
					set $p(strData, "^", 5) = $p(strData, "^", 5) + 1  //乙级数量
				}
				if ($g(^CacheTemp("StaExamResultGrade", $j, Level)) = 0)
				{
					set $p(strData, "^", 6) = $p(strData, "^", 6) + 1  //丙级数量
				}
			}
			if ($p(result, "^", 3) = "Y")
			{
				set $p(strData, "^", 7) = $p(strData, "^", 7) + 1 //单项否决
			}
			///set $p(strData, "^", 8) = $p(strData, "^", 8) + $g(^DHCWMRERST(resultID,"D",0)) //问题总数量
			if ($p(strData, "^", 9) < $p(result, "^", 4))
			{
				set $p(strData, "^", 9) = $p(result, "^", 4) //最高分
			}
			if ($p(strData, "^", 10) > $p(result, "^", 4))
			{
				set $p(strData, "^", 10) = $p(result, "^", 4)  //最低分
			}					
			set $p(strData, "^", 11) = $p(strData, "^", 11) + $p(result, "^", 4) //总得分（分数累加，用来最后计算平均分）
			set $p(strData, "^", 12) = $p(strData, "^", 12) + 1 //统计出有多少份检查结果，好计算平均分
			set DetailID = ""
			do
			{
				set DetailID = $o(^DHCWMRERST(resultID,"D",DetailID))
				if (DetailID '= "")
				{
					set Detail = $g(^DHCWMRERST(resultID,"D",DetailID))
					set $p(strData, "^", 13) = $p(strData, "^", 13) + $p(Detail, "^", 4)  //总扣款
					set $p(strData, "^", 8) = $p(strData, "^", 8) + $p(Detail, "^", 2)    //问题总数
					
				}
			} while(DetailID '= "")
			set ^CacheTemp("StaExamResult", $j, strDep) =  strData		
			set resultID = $o(^DHCWMRERST(0,"RuleVol",RuleID,VolumeID,resultID))		
		}
		set VolumeID=$o(^CacheTemp("QueryVolumeByDate", $j, VolumeID))	
	} 
	set strDep = ""
	set strLoc = ""
	do
	{
		set strDep=$o(^CacheTemp("StaExamResult", $j, strDep))
		if (strDep '= "")
		{
			set strData = $$BuildStaExamResultData(strDep, $g(^CacheTemp("StaExamResult", $j, strDep)))
			Set ^CacheTemp(repid,ind)=strData
			Set ind=ind+1
		}
	} while(strDep'="")	
	Quit $$$OK
	
BuildStaExamResultData(strDep, strData)
	n (strDep, strData)
	Set Data=$lb("")
	set total = $p(strData,"^",1)
	set totalCheck = $p(strData,"^",2)
	set intCnt = $p(strData,"^",12) 

	Set $li(Data,1)=strDep                     												 //科室                  													 //二级科室,
	Set $li(Data,2)=$p(strData,"^",1)               									      //出院人数 ,
	Set $li(Data,3)=$p(strData,"^",2)                       								//检查数量
	if (total = "")!(total = 0)
	{
		set total = 1
	}
	if (totalCheck = "")!(totalCheck = 0)
	{
		set totalCheck = 1
	}
	if (intCnt = "")!(intCnt = 0)
	{
		set intCnt = 1
	}	
	
	Set $li(Data,4)=$number(($p(strData,"^",2) / total)*100,2)_"%"                       //覆盖率
	Set $li(Data,5)=$p(strData,"^",4)                       								//甲级
	Set $li(Data,6)= $p(strData,"^",5)                										//乙级
	Set $li(Data,7)=$p(strData,"^",6)                     									//丙级
	Set $li(Data,8)=$p(strData,"^",7)                      									 //单项否决
	Set $li(Data,9)=$p(strData,"^",8)                      									 //问题总数量
	Set $li(Data,10)=$p(strData,"^",9)                       								//最高分
	Set $li(Data,11)= $p(strData,"^",10)                										//最低分
	Set $li(Data,12)= $number($p(strData,"^",11) / intCnt,2)                				//平均分
	Set $li(Data,13)= $p(strData,"^",13)                										//总扣款
	Set $li(Data,14)= $number((($p(strData,"^",4) / totalCheck) * 100),2)_"%"              		 //甲级率
	Set $li(Data,15)= $number((($p(strData,"^",5) / totalCheck) * 100),2)_"%"               		 //乙级率
	Set $li(Data,16)= $number((($p(strData,"^",6) / totalCheck) * 100),2)_"%"                	//丙级率
	//b
	
	
	
	
	
 	Quit Data
}

ClassMethod StaExamResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaExamResultExecute ]
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

//出院科室、二级科室， 出院人数、检察病例数量、检察覆盖率、甲级数量、乙级数量、丙级数量、单项否决数量、问题总数、最高分、最低分、平均分、扣款总额、甲级率、乙级率、丙级率

Query StaExamResult(RuleID As %String, From As %String, To As %String, DateType As %String, DepType As %String) As %Query(ROWSPEC = "Department:%String:科室,DischargeCnt:%String:出院人数,CheckCnt:%String:检查数量,Cover:%String:覆盖率,Level1:%String:甲级,Level2:%String:乙级,Level3:%String:丙级,Veto:%String:单项否决,TotalProblemCnt:%String:问题总量,Max:%String:最高分,Min:%String:最低分,Avg:%String:平均分,Money:%String:扣款,LevelPs:%String:甲级率,Level2Ps:%String:乙级率,Level3Ps:%String:丙级率")
{
}

}
