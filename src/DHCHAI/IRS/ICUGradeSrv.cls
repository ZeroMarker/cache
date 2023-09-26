/// 名称: DHCHAI.IRS.ICUGradeSrv
/// 描述: ICU临床病情等级服务
/// 编写者：pylian
/// 编写日期: 2017-10-18
Class DHCHAI.IRS.ICUGradeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-10-19
/// Description:  保存ICU临床病情等级记录
/// Table：       DHCHAI.IR.ICUGrade
/// Input:        
/// w ##Class(DHCHAI.IRS.ICUGradeSrv).GetGradeID("8","2017","10")
ClassMethod GetGradeID(aLocID As %String, aYear As %String, aMonth As %String) As %String
{
	New (aLocID,aYear,aMonth)
	Set return=""
	Quit:(aLocID="")||(aYear="")||(aMonth="") return
	Set:$e(aMonth,1)=0 aMonth=$e(aMonth,2)  //月份为"01"处理
	Set xWeek="",GradeList=""
	For {
		Set xWeek=$o(^DHCHAI.IR.ICUGradeI("IndexLocYYMM",aLocID,aYear,aMonth,xWeek))
		Quit:xWeek=""
	
		Set xGradeID=$o(^DHCHAI.IR.ICUGradeI("IndexLocYYMM",aLocID,aYear,aMonth,xWeek,""))
	    Set GradeList=GradeList_","_xGradeID
		
	}
	Set:GradeList="" GradeList=$e(GradeList,2,$l(GradeList))
	Set return=GradeList
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-10-19
/// Description:  取ICU临床病情等级记录
/// Table：       DHCHAI.IR.ICUGrade
/// Input：       ID:    DHCHAI.IR.ICUGrade.ID
/// Return：      返回String
/// w ##class(DHCHAI.IRS.ICUGradeSrv).GetGradeString(1)
ClassMethod GetGradeString(aGradeID As %String) As %String
{
	New (aGradeID)
	Set return=""
	Quit:aGradeID="" return
	Set aSeparase = "^"
	
	Set obj=##class(DHCHAI.IR.ICUGrade).GetObjById(aGradeID)
	Quit:'$IsObject(obj) return

	Set return = aGradeID_aSeparase                               //1
	Set return = return_obj.IGItem1_aSeparase                     //2
	Set return = return_obj.IGItem2_aSeparase                     //3
	Set return = return_obj.IGItem3_aSeparase                     //4
	Set return = return_obj.IGItem4_aSeparase                     //5
	Set return = return_obj.IGItem5                               //6
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-10-20
/// Description:  保存ICU临床病情等级记录
/// Table：       DHCMed.NINF.Rep.AimICUGrade
/// Input:        
/// w ##Class(DHCHAI.IRS.ICUGradeSrv).SaveRec("2^8^2017^10^1^3^5^12^4^1^^^7935#1^8^2017^10^2^12^6^2^4^1^^^7935#3^8^2017^10^3^2^3^4^5^6^^^7935#4^8^2017^10^3^5^3^8^7^7^^^7935","^")
ClassMethod SaveRec(aInput As %String, aSeparase As %String) As %String
{
	New (aInput,aSeparase)
	Set return=0
	Set $ZT="SaveRecErr"
	
	Set InputWeek1 = $p(aInput,"#",1)
	Set InputWeek2 = $p(aInput,"#",2)
	Set InputWeek3 = $p(aInput,"#",3)
	Set InputWeek4 = $p(aInput,"#",4)

	// 第一周
	Set return = -1
	Set GradeID1 = $p(InputWeek1,aSeparase,1)
	Set LocID1   = $p(InputWeek1,aSeparase,2)
	Set Year1    = $p(InputWeek1,aSeparase,3)
	Set Month1   = $p(InputWeek1,aSeparase,4)
	Set Week1    = $p(InputWeek1,aSeparase,5)
	Quit:(LocID1="")||(Year1="")||(Month1="")||(Week1="") return
	If (GradeID1="") {
		Set GradeID1=$o(^DHCHAI.IR.ICUGradeI("IndexLocYYMM",LocID1,Year1,Month1,Week1,0))
		Set $p(InputWeek1,aSeparase,1)=GradeID1
		Set flg=##Class(DHCHAI.IR.ICUGrade).Update(InputWeek1,aSeparase)
		Quit:(+flg)<1 return
	}Else {
		Set objGrade=##class(DHCHAI.IR.ICUGrade).GetObjById(GradeID1)
		Set $p(InputWeek1,aSeparase,11)=objGrade.UpdateDate
		Set $p(InputWeek1,aSeparase,12)=objGrade.UpdateTime
		Set $p(InputWeek1,aSeparase,13)=objGrade.UpdateUser
		Set flg=##Class(DHCHAI.IR.ICUGrade).Update(InputWeek1,aSeparase)
		Quit:(+flg)<1 return	
	}

	Set return = -2
	Set GradeID2 = $p(InputWeek2,aSeparase,1)
	Set LocID2   = $p(InputWeek2,aSeparase,2)
	Set Year2    = $p(InputWeek2,aSeparase,3)
	Set Month2   = $p(InputWeek2,aSeparase,4)
	Set Week2    = $p(InputWeek2,aSeparase,5)
	Quit:(LocID2="")||(Year2="")||(Month2="")||(Week2="") return
	If (GradeID2="") {
		Set GradeID2=$o(^DHCHAI.IR.ICUGradeI("IndexLocYYMM",LocID2,Year2,Month2,Week2,0))
		Set $p(InputWeek2,aSeparase,1)=GradeID2
		Set flg=##Class(DHCHAI.IR.ICUGrade).Update(InputWeek2,aSeparase)
		Quit:(+flg)<1 return
	}Else {
		Set objGrade=##class(DHCHAI.IR.ICUGrade).GetObjById(GradeID2)
		Set $p(InputWeek2,aSeparase,11)=objGrade.UpdateDate
		Set $p(InputWeek2,aSeparase,12)=objGrade.UpdateTime
		Set $p(InputWeek2,aSeparase,13)=objGrade.UpdateUser
		Set flg=##Class(DHCHAI.IR.ICUGrade).Update(InputWeek2,aSeparase)
		Quit:(+flg)<1 return	
	}
	
	Set return = -3
	Set GradeID3 = $p(InputWeek3,aSeparase,1)
	Set LocID3   = $p(InputWeek3,aSeparase,2)
	Set Year3    = $p(InputWeek3,aSeparase,3)
	Set Month3   = $p(InputWeek3,aSeparase,4)
	Set Week3    = $p(InputWeek3,aSeparase,5)
	Quit:(LocID3="")||(Year3="")||(Month3="")||(Week3="") return
	If (GradeID3="") {
		Set GradeID3=$o(^DHCHAI.IR.ICUGradeI("IndexLocYYMM",LocID3,Year3,Month3,Week3,0))
		Set $p(InputWeek3,aSeparase,1)=GradeID3
		Set flg=##Class(DHCHAI.IR.ICUGrade).Update(InputWeek3,aSeparase)
		Quit:(+flg)<1 return
	}Else {
		Set objGrade=##class(DHCHAI.IR.ICUGrade).GetObjById(GradeID3)
		Set $p(InputWeek3,aSeparase,11)=objGrade.UpdateDate
		Set $p(InputWeek3,aSeparase,12)=objGrade.UpdateTime
		Set $p(InputWeek3,aSeparase,13)=objGrade.UpdateUser
		Set flg=##Class(DHCHAI.IR.ICUGrade).Update(InputWeek3,aSeparase)
		Quit:(+flg)<1 return	
	}
	
	Set return = -4
	Set GradeID4 = $p(InputWeek4,aSeparase,1)
	Set LocID4   = $p(InputWeek4,aSeparase,2)
	Set Year4    = $p(InputWeek4,aSeparase,3)
	Set Month4   = $p(InputWeek4,aSeparase,4)
	Set Week4    = $p(InputWeek4,aSeparase,5)
	Quit:(LocID4="")||(Year4="")||(Month4="")||(Week4="") return
	If (GradeID4="") {
		Set GradeID4=$o(^DHCHAI.IR.ICUGradeI("IndexLocYYMM",LocID4,Year4,Month4,Week4,0))
		Set $p(InputWeek4,aSeparase,1)=GradeID4
		Set flg=##Class(DHCHAI.IR.ICUGrade).Update(InputWeek4,aSeparase)
		Quit:(+flg)<1 return
	}Else {
		Set objGrade=##class(DHCHAI.IR.ICUGrade).GetObjById(GradeID4)
		Set $p(InputWeek4,aSeparase,11)=objGrade.UpdateDate
		Set $p(InputWeek4,aSeparase,12)=objGrade.UpdateTime
		Set $p(InputWeek4,aSeparase,13)=objGrade.UpdateUser
		Set flg=##Class(DHCHAI.IR.ICUGrade).Update(InputWeek4,aSeparase)
		Quit:(+flg)<1 return	
	}
	Set return=1
	
	Quit return
	
SaveRecErr
	Quit "-999"
}

// ***********新版ICU危险等级评定**************//

/// Creator：     ShenC
/// CreatDate：   2020-06-03
/// Description:  查询ICU临床病情等级记录
/// Table：       DHCHAI.IR.ICUGrade
/// Input：       aLocID:科室ID, aYYMM:年月
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.ICUGradeSrv","QryIGByMonth","8","2017-10")
Query QryIGByMonth(aLocID As %String, aYYMM As %String) As %Query(ROWSPEC = "Index:%String,IGGrade:%String,IGScore:%String,IGWeek1:%String,IGWeek2:%String,IGWeek3:%String,IGWeek4:%String,IGWeek5:%String,IGYear:%String,IGMonth:%String,IGLocID:%String")
{
}

ClassMethod QryIGByMonthExecute(ByRef qHandle As %Binary, aLocID As %String, aYYMM As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set Year=+$p(aYYMM,"-",1)
	Set Month=+$p(aYYMM,"-",2)
	Quit:(aLocID="")||(Year=0)||(Month=0) $$$OK
	
	Kill ^TMP($zn,$j,"QryIGByMonth")
	//循环ICU危险等级患者明细表
	For xWeek=1:1:5
	{
		Set IGCountA=0,IGCountB=0,IGCountC=0,IGCountD=0,IGCountE=0
		Set xEpisodeID=0
		for{
			Set xEpisodeID=$o(^DHCHAI.IR.ICUGradeI("IndexEpisodeLocYYMM",aLocID,Year,Month,xWeek,xEpisodeID))
			Quit:xEpisodeID=""
			
			Set xIGradeID=0
			for{
				Set xIGradeID=$o(^DHCHAI.IR.ICUGradeI("IndexEpisodeLocYYMM",aLocID,Year,Month,xWeek,xEpisodeID,xIGradeID))
				Quit:xIGradeID=""
				
				Set objGrade=##class(DHCHAI.IR.ICUGrade).GetObjById(xIGradeID)
				Continue:'$IsObject(objGrade)
				
				Set IGItem1=objGrade.IGItem1	//评分A
				Set:IGItem1=1 IGCountA=IGCountA+1	
				Set IGItem2=objGrade.IGItem2	//评分B
				Set:IGItem2=1 IGCountB=IGCountB+1
				Set IGItem3=objGrade.IGItem3	//评分C
				Set:IGItem3=1 IGCountC=IGCountC+1
				Set IGItem4=objGrade.IGItem4	//评分D
				Set:IGItem4=1 IGCountD=IGCountD+1
				Set IGItem5=objGrade.IGItem5	//评分E
				Set:IGItem5=1 IGCountE=IGCountE+1
			}
		}
		//统计每周A,B,C,D,E各等级患者人数
		Set ^TMP($zn,$j,"QryIGByMonth","A",xWeek)=IGCountA
		Set ^TMP($zn,$j,"QryIGByMonth","B",xWeek)=IGCountB
		Set ^TMP($zn,$j,"QryIGByMonth","C",xWeek)=IGCountC
		Set ^TMP($zn,$j,"QryIGByMonth","D",xWeek)=IGCountD
		Set ^TMP($zn,$j,"QryIGByMonth","E",xWeek)=IGCountE
	}
	Set ItemGradeList=$lb("A","B","C","D","E")	//等级列表(A,B,C,D,E)
	Set ItemScoreList=$lb(1,2,3,4,5)			//评分列表(1->A,2->B,3->C,4->D,5->E)
	
	Set (TPeopleNum,AvgICUGrade,TScore)=0
	For xIndGrade=1:1:5 {
		Set ItemGrade=$lg(ItemGradeList,xIndGrade)
		//危险等级为ItemGrade每周评定人数
		Set IGCount1=$g(^TMP($zn,$j,"QryIGByMonth",ItemGrade,1))	//第一周
		Set IGCount2=$g(^TMP($zn,$j,"QryIGByMonth",ItemGrade,2))	//第二周
		Set IGCount3=$g(^TMP($zn,$j,"QryIGByMonth",ItemGrade,3))	//第三周
		Set IGCount4=$g(^TMP($zn,$j,"QryIGByMonth",ItemGrade,4))	//第四周
		Set IGCount5=$g(^TMP($zn,$j,"QryIGByMonth",ItemGrade,5))	//第五周
		
		//危险等级为ItemGrade的评定总人数
		Set TPeopleNum =TPeopleNum+IGCount1 + IGCount2 + IGCount3 + IGCount4+ IGCount5
		//危险等级为ItemGrade的评定总分数
		Set TScore = TScore + ((IGCount1 + IGCount2 + IGCount3+ IGCount4+ IGCount5)*xIndGrade)
		
		Set Data=$lb(xIndGrade,$list(ItemGradeList,xIndGrade),$list(ItemScoreList,xIndGrade),IGCount1,IGCount2,IGCount3,IGCount4,IGCount5,xYear,xMonth,aLocID)
		Set ^CacheTemp(repid,ind)=Data
	    Set ind=ind+1
	}
	If TPeopleNum'=0  Do
	.Set AvgICUGrade=$fn(TScore/TPeopleNum,"",2)
	.Set str=##class(websys.Translation).Get("dhcma.hai.ir.icu.grade.csp","合计人数")_":"_TPeopleNum_","_##class(websys.Translation).Get("dhcma.hai.ir.icu.grade.csp","平均病情严重程度")_":"_AvgICUGrade
	.Set Data=$lb(6,str)
	.Set ^CacheTemp(repid,ind)=Data
	.Set ind=ind+1
		
	Kill ^TMP($zn,$j,"QryIGByMonth")
	Quit $$$OK
}

ClassMethod QryIGByMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIGByMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryIGByMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIGByMonthExecute ]
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

/// Creator：     ShenC
/// Description:  查询ICU临床病情等级记录(详细病人)
/// Table：       DHCHAI.IR.ICUGrade
/// Input：       aLocID:科室ID, aYYMM:年月, aWeek:周
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.ICUGradeSrv","QryIGByWeek","43","2020-05",2)
Query QryIGByWeek(aLocID As %String, aYYMM As %String, aWeek As %String = "") As %Query(ROWSPEC = "Paadm:%String,PAMrNo:%String,PatName:%String,Sex:%String,Age:%String,Bed:%String,PAAdmDate:%String,Item1:%String,Item2:%String,Item3:%String,Item4:%String,Item5:%String,UserID:%String,AssertUser:%String,TransDate:%String")
{
}

ClassMethod QryIGByWeekExecute(ByRef qHandle As %Binary, aLocID As %String, aYYMM As %String, aWeek As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set Year=+$p(aYYMM,"-",1)
	Set Month=+$p(aYYMM,"-",2)
	Quit:(Year=0)||(Month=0)||(aLocID="")||(aWeek="") $$$OK
	//定义临时Global
	Set ZIndex=$zn,JIndex=$j,NIndex="QryIGByWeek"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	//取每周评估日期
	Set AssertDates=..GetAssertDate(aYYMM)
	Quit:AssertDates="" $$$OK
	//同期在科(当天在科+新入+新出+当天入当天出)
	Set Date=$p(AssertDates,"^",aWeek)
    Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate2(Date,Date,"W",aLocID,"I")
    For index=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index)
		Continue:TransInfo=""
		
		Set Paadm      = $LIST(TransInfo,2)
		Set TransID    =$LIST(TransInfo,5)
		Set TranData=$g(^DHCHAI.DP.PAAdmTransD(TransID))
		Continue:TranData=""
		Set TransDate=$zd($lg(TranData,7),3)
		Set AdmObj=##class(DHCHAI.DP.PAAdm).GetObjById(Paadm)
		Continue:'$ISObject(AdmObj)
		
		Set PAMrNo=AdmObj.PAMrNo	//病案号
		Set PatName=AdmObj.PAPatName	//姓名
		Set Sex=AdmObj.PASex			//性别
		Set Age=AdmObj.PAAge			//年龄
		Set BedDr=AdmObj.PAAdmBedDr		//床位
		Set:$ISObject(BedDr) Bed=BedDr.BTDesc
		Set PaadmDate=AdmObj.PAAdmDate		//入院日期
		Set:PaadmDate'="" PaadmDate=$zd(PaadmDate,3)
		//患者危险评定信息
		Set Items=..GetItemsByEpisode(Paadm,aLocID,Year,Month,aWeek)
		Set Item1=$p(Items,"^",1)	//等级A
		Set Item2=$p(Items,"^",2)	//等级B
		Set Item3=$p(Items,"^",3)	//等级C
		Set Item4=$p(Items,"^",4)	//等级D
		Set Item5=$p(Items,"^",5)	//等级E
		Set UserID=$p(Items,"^",6)	//评估人
		Set UserDesc=$p(Items,"^",7)	//评估人
		//多语言处理
		Set:Age["岁" Age=$Replace(Age,"岁",##class(websys.Translation).Get("Bill.Com.Age","岁"))
		Set:Age["月" Age=$Replace(Age,"月",##class(websys.Translation).Get("Bill.Com.Age","月"))
		Set:Age["天" Age=$Replace(Age,"天",##class(websys.Translation).Get("Bill.Com.Age","天"))
		
		Set Str=$lb(Paadm,PAMrNo,PatName,Sex,Age,Bed,PaadmDate,Item1,Item2,Item3,Item4,Item5,UserID,UserDesc,TransDate)
		Set ^CacheTemp(repid,ind)=Str
		Set ind=ind+1
	}
	
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit $$$OK
}

ClassMethod QryIGByWeekClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIGByMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryIGByWeekFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIGByMonthExecute ]
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

/// Creator：     ShenC
/// Description:  获取每周平均ICU危险等级
/// Table：       DHCHAI.IR.ICUGrade
/// Input：       aLocID:科室ID, aYYMM:年月, aWeek:周
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.ICUGradeSrv","QryAvgICUGrade","43","2020-05")
Query QryAvgICUGrade(aLocID As %String, aYYMM As %String) As %Query(ROWSPEC = "Week:%String,AvgICUGrade:%String")
{
}

ClassMethod QryAvgICUGradeExecute(ByRef qHandle As %Binary, aLocID As %String, aYYMM As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set Year=+$p(aYYMM,"-",1)
	Set Month=+$p(aYYMM,"-",2)
	Quit:(Year=0)||(Month=0)||(aLocID="") $$$OK
	//定义临时Global
	Set ZIndex=$zn,JIndex=$j,NIndex="QryAvgICUGrade"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	//取每周评估日期
	Set AssertDates=..GetAssertDate(aYYMM)
	Quit:AssertDates="" $$$OK
	
	Set WeekCnt=4
	Set:$p(AssertDates,"^",5)'="" WeekCnt=5
	For xIndWeek=1:1:WeekCnt{
		Set (IGCountA,IGCountB,IGCountC,IGCountD,IGCountE)=0
		
		Set xEpisodeID=""
		For{
			Set xEpisodeID=$o(^DHCHAI.IR.ICUGradeI("IndexEpisodeLocYYMM",aLocID,Year,Month,xIndWeek,xEpisodeID))
			Quit:xEpisodeID=""
			
			Set xIGradeID=""
			For{
				Set xIGradeID=$o(^DHCHAI.IR.ICUGradeI("IndexEpisodeLocYYMM",aLocID,Year,Month,xIndWeek,xEpisodeID,xIGradeID))
				Quit:xIGradeID=""
				
				Set IGObj=##class(DHCHAI.IR.ICUGrade).GetObjById(xIGradeID)
				Continue:'$ISObject(IGObj)
				
				Set Item1=IGObj.IGItem1
				Set:Item1=1 IGCountA=IGCountA+1
				Set Item2=IGObj.IGItem2
				Set:Item2=1 IGCountB=IGCountB+1
				Set Item3=IGObj.IGItem3
				Set:Item3=1 IGCountC=IGCountC+1
				Set Item4=IGObj.IGItem4
				Set:Item4=1 IGCountD=IGCountD+1
				Set Item5=IGObj.IGItem5
				Set:Item5=1 IGCountE=IGCountE+1
			}
		}
		//统计每周平均危险等级
		Set TPeopleNum =IGCountA + IGCountB + IGCountC + IGCountD+ IGCountE		//总人数
		Set TScore =(IGCountA*1) + (IGCountB*2) + (IGCountC*3)+ (IGCountD*4)+ (IGCountE*5)	//总分数
		Set AvgICUGrade=0
		Set:TPeopleNum'=0 AvgICUGrade=$fn(TScore/TPeopleNum,"",2)
		Set:xIndWeek=1 Week="第一周"
		Set:xIndWeek=2 Week="第二周"
		Set:xIndWeek=3 Week="第三周"
		Set:xIndWeek=4 Week="第四周"
		Set:xIndWeek=5 Week="第五周"
		Set Data=$lb(Week,AvgICUGrade)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit $$$OK
}

ClassMethod QryAvgICUGradeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAvgICUGradeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAvgICUGradeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAvgICUGradeExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2020-06-02
/// Description:  根据就诊号取ICU临床病情等级记录
/// Table：       DHCHAI.IR.ICUGrade
/// Input：       ID:    DHCHAI.IR.ICUGrade.ID
/// Return：      返回Item
/// w ##class(DHCHAI.IRS.ICUGradeSrv).GetObjByEpisode(1)
ClassMethod GetItemsByEpisode(aEpisode As %String, aLocDr As %String, aYear As %String, aMonth As %String, aWeek As %String) As %String
{
	new (aEpisode,aLocDr,aYear,aMonth,aWeek)
	Set return=""
	
	Set IGId=$o(^DHCHAI.IR.ICUGradeI("IndexEpisodeLocYYMM",aLocDr,aYear,aMonth,aWeek,aEpisode,0))
	Quit:(IGId="") ""
	
	Set IGObj=##class(DHCHAI.IR.ICUGrade).GetObjById(IGId)
	Quit:'$ISObject(IGObj) ""
	//评估人
	Set UserID="",UserDesc=""
	Set objUser=IGObj.UpdateUser
	if $IsObject(objUser){
		Set UserID=objUser.%Id()
		Set UserDesc=objUser.BTDesc
	}
	
	Set Item1=IGObj.IGItem1
	Set Item2=IGObj.IGItem2
	Set Item3=IGObj.IGItem3
	Set Item4=IGObj.IGItem4
	Set Item5=IGObj.IGItem5
	
	Quit Item1_"^"_Item2_"^"_Item3_"^"_Item4_"^"_Item5_"^"_UserID_"^"_UserDesc
}

/// Creator：     ShenC
/// CreatDate：   2020-06-01
/// Description:  取当月评定日期
/// Table：       DHCHAI.IR.ICUGradeSrv
/// Input：       ID:    DHCHAI.IR.ICUGradeSrv.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IRS.ICUGradeSrv).GetAssertDate("2020-05")
ClassMethod GetAssertDate(aYYMM As %String) As %String
{
	new (aYYMM)
	Set return=""
	
	Quit:aYYMM="" return
	
	Set ItmWeek=##class(DHCHAI.BT.Config).GetValByCode("ICUGradeWeek")	//根据系统参数取每周评估(ItmWeek)
	//取评估日期和开始日期差值
	Set StartDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aYYMM_"-01")
	Set SubDay=ItmWeek-((StartDate+4)#7)
	Set:SubDay<0 SubDay=7+SubDay
	//第一周(01-07)
	Set AssertDate1=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aYYMM_"-01")+SubDay
	Set:AssertDate1'="" AssertDate1=$zd(AssertDate1,3)
	//第二周(08-14)
	Set AssertDate2=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aYYMM_"-08")+SubDay
	Set:AssertDate2'="" AssertDate2=$zd(AssertDate2,3)
	//第三周(15-21)
	Set AssertDate3=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aYYMM_"-15")+SubDay
	Set:AssertDate3'="" AssertDate3=$zd(AssertDate3,3)
	//第四周(22-28)
	Set AssertDate4=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aYYMM_"-22")+SubDay
	Set:AssertDate4'="" AssertDate4=$zd(AssertDate4,3)
	//第五周
	Set AssertDate5=""
	Set StartDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aYYMM_"-29")
	if (StartDate'=""){		//存在第五周
		Set AssertDate=$zd(StartDate+SubDay,3)
		Set AssertDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(AssertDate)
		
		Set aMonth=$p(aYYMM,"-",2)
		Set AssertMonth=$p($zd(AssertDate,3),"-",2)
		
		Set:AssertMonth[aMonth AssertDate5=$zd(AssertDate,3)
	}
		
	Set return=	AssertDate1_"^"_AssertDate2_"^"_AssertDate3_"^"_AssertDate4_"^"_AssertDate5
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2021-06-24
/// Description:  取科室当前周是否需评定
/// Table：       DHCHAI.IR.ICUGradeSrv
/// Input：       ID:    DHCHAI.IR.ICUGradeSrv.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IRS.ICUGradeSrv).GetIsNeedAssert("28","2021-06",1)
ClassMethod GetIsNeedAssert(aLocID As %String, aYYMM As %String, aWeek As %String) As %String
{
	new (aLocID,aYYMM,aWeek)
	Set return=0
	Quit:(aYYMM="")||(aLocID="")||(aWeek="") return
	Set Year=+$p(aYYMM,"-",1)
	Set Month=+$p(aYYMM,"-",2)
	Quit:(Year=0)||(Month=0) return
	
	Set ZIndex=$zn,JIndex=$j,NIndex="QryIGByWeek"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	//取每周评估日期
	Set AssertDates=..GetAssertDate(aYYMM)
	Quit:AssertDates="" $$$OK
	Set Date=$p(AssertDates,"^",aWeek)
	//大于当前日期不需评估
	Set AssertDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(Date)
	Quit:AssertDate>+$h return	
	//同期在科(当天在科+新入+新出+当天入当天出)
    Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate2(Date,Date,"W",aLocID,"I")
    For index=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index)
		Continue:TransInfo=""
		
		Set Paadm      = $LIST(TransInfo,2)
		Set AdmObj=##class(DHCHAI.DP.PAAdm).GetObjById(Paadm)
		Continue:'$ISObject(AdmObj)
		
		//需评估人数
		Set num=$i(^TMP(ZIndex,JIndex,NIndex,"PatCount"))
		
		Set Items=##class(DHCHAI.IRS.ICUGradeSrv).GetItemsByEpisode(Paadm,aLocID,Year,Month,aWeek)
		Continue:Items=""
		Set Item1=$p(Items,"^",1)
		Set Item2=$p(Items,"^",2)
		Set Item3=$p(Items,"^",3)
		Set Item4=$p(Items,"^",4)
		Set Item5=$p(Items,"^",5)
		//评估人数
		Set:(Item1'=0)||((Item2'=0))||((Item3'=0))||((Item4'=0))||(Item5'=0) num=$i(^TMP(ZIndex,JIndex,NIndex,"IGCount"))
	}
	
	Set PatCount=+$g(^TMP(ZIndex,JIndex,NIndex,"PatCount"))
	Set IGCount=+$g(^TMP(ZIndex,JIndex,NIndex,"IGCount"))
	
	if (IGCount<PatCount){
		Set return=1
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2023-04-13
/// Description:  保存ICU危险登记评定
/// Table：       DHCHAI.IR.ICUGradeSrv
/// Input：       ID:    DHCHAI.IR.ICUGradeSrv.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IRS.ICUGradeSrv).SaveGrade("")
ClassMethod SaveGrade(aInputStrs As %String, aSeparete As %String = "^") As %String
{
	new (aInputStrs,aSeparete)
	Set return=0
	Quit:(aInputStrs="") return
	
	TStart			//启动事务
	Set GID=""
	For xInd=1:1:$l(aInputStrs,"#"){
		Set InputStr=$p(aInputStrs,"#",xInd)
		Continue:InputStr=""
		//保存危险登记评定表
		Set ret = ##Class(DHCHAI.IR.ICUGrade).Update(InputStr,aSeparete)
		
		If ret<1 {
			Set GID="0"
			break
		}
		else{
			Set GID=GID_","_ret
		}
	}
	If (GID="0"){
		Trollback		//保存失败回滚
		Quit return
	}
	
	Tcommit
	Set return = "1"
	Quit return
}

}
