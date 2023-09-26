/// 名称: DHCMed.NINFService.Rep.AimICUGrade
/// 描述: ICU临床病情等级记录
/// 编写者：zhufei
/// 编写日期: 2011-05-16
Class DHCMed.NINFService.Rep.AimICUGrade Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-07-12
/// Description:  保存ICU临床病情等级记录
/// Table：       DHCMed.NINF.Rep.AimICUGrade
/// Input:        
/// w ##Class(DHCMed.NINFService.Rep.AimICUGrade).SaveRec("^1469^2012^7^1^2^3^4^5^6^2776","^")
ClassMethod SaveRec(aInput As %String, aSeparase As %String)
{
	New (aInput,aSeparase)
	Set return=0
	Set $ZT="SaveRecErr"
	
	Set LocID=$p(aInput,aSeparase,2)
	Set Year=$p(aInput,aSeparase,3)
	Set Month=$p(aInput,aSeparase,4)
	Set Week=$p(aInput,aSeparase,5)
	Quit:(LocID="")||(Year="")||(Month="")||(Week="") return
	
	Set LogID=$o(^DHCMed.NINFi("Aim","ICUG","IndexLocYYMM",LocID,Year,Month,Week,0))
	Set $p(aInput,aSeparase,1)=LogID
	Set return=##class(DHCMed.NINF.Rep.AimICUGrade).Update(aInput,aSeparase)
	Quit return
	
SaveRecErr
	Quit "-999"
}

/// Creator：     zhufei
/// CreatDate：   2012-05-10
/// Description:  查询ICU临床病情等级记录
/// Table：       DHCMed.NINF.Rep.AimICUGrade
/// Input:        argYYMM,argLoc
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimICUGrade","QryAIGByMonth","2012-05","1921")
Query QryAIGByMonth(argYYMM As %String, argLoc As %String) As %Query(ROWSPEC = "AIGIndex:%String,AIGGrade:%String,AIGScore:%String,AIGItem1:%String,AIGItem2:%String,AIGItem3:%String,AIGItem4:%String,AIGYear:%String,AIGMonth:%String,AIGLocID:%String")
{
}

ClassMethod QryAIGByMonthExecute(ByRef qHandle As %Binary, argYYMM As %String, argLoc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(argYYMM="")||(argLoc="") $$$OK
	
	Set xYear=+$p(argYYMM,"-",1)
	Set xMonth=+$p(argYYMM,"-",2)
	Quit:(xYear=0)||(xMonth=0) $$$OK
	
	Set LocID=argLoc
	Set LocDesc=$p($g(^CTLOC(LocID)),"^",2)
	Quit:LocDesc="" $$$OK
	Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
	
	Set ZIndex=$zn,JIndex=$j,NIndex="QryAIGByMonth"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	For xWeek=1:1:4
	{
		Set (AIGItem1,AIGItem2,AIGItem3,AIGItem4,AIGItem5,AIGItemCount,AIGScoreCount)=""
		Set xLogID=$o(^DHCMed.NINFi("Aim","ICUG","IndexLocYYMM",LocID,xYear,xMonth,xWeek,0))
		Set objLog=##class(DHCMed.NINF.Rep.AimICUGrade).GetObjById(xLogID)
		If $IsObject(objLog)
		{
			Set AIGItem1=objLog.AIGItem1
			Set AIGItem2=objLog.AIGItem2
			Set AIGItem3=objLog.AIGItem3
			Set AIGItem4=objLog.AIGItem4
			Set AIGItem5=objLog.AIGItem5
			
			Set AIGItemCount=(+AIGItem1)+(+AIGItem2)+(+AIGItem3)+(+AIGItem4)+(+AIGItem5)
			Set AIGScoreCount=((+AIGItem1)*1)+((+AIGItem2)*2)+((+AIGItem3)*3)+((+AIGItem4)*4)+((+AIGItem5)*5)
		}
		Set ^TMP(ZIndex,JIndex,NIndex,1,xWeek)=AIGItem1
		Set ^TMP(ZIndex,JIndex,NIndex,2,xWeek)=AIGItem2
		Set ^TMP(ZIndex,JIndex,NIndex,3,xWeek)=AIGItem3
		Set ^TMP(ZIndex,JIndex,NIndex,4,xWeek)=AIGItem4
		Set ^TMP(ZIndex,JIndex,NIndex,5,xWeek)=AIGItem5
		Set ^TMP(ZIndex,JIndex,NIndex,6,xWeek)=AIGItemCount
		Set ^TMP(ZIndex,JIndex,NIndex,7,xWeek)=AIGScoreCount
	}
	
	Set ItemGradeList=$lb("A","B","C","D","E")
	Set ItemScoreList=$lb(1,2,3,4,5)
	Set (TPeopleNum,AvgICUGrade,TScore)=0
	For indGrade=1:1:5 {
		Set AIGItem1=$g(^TMP(ZIndex,JIndex,NIndex,indGrade,1))
		Set AIGItem2=$g(^TMP(ZIndex,JIndex,NIndex,indGrade,2))
		Set AIGItem3=$g(^TMP(ZIndex,JIndex,NIndex,indGrade,3))
		Set AIGItem4=$g(^TMP(ZIndex,JIndex,NIndex,indGrade,4))
		
		Set TPeopleNum = TPeopleNum + AIGItem1 + AIGItem2 + AIGItem3 + AIGItem4
		Set TScore = TScore + ((AIGItem1 + AIGItem2 + AIGItem3 + AIGItem4)*indGrade)
		Set Data=$lb(indGrade,$list(ItemGradeList,indGrade),$list(ItemScoreList,indGrade),AIGItem1,AIGItem2,AIGItem3,AIGItem4,xYear,xMonth,LocID)
		Set ^CacheTemp(repid,ind)=Data
	    Set ind=ind+1
	}
	
	If TPeopleNum'=0  Do
	.Set AvgICUGrade=$fn(TScore/TPeopleNum,"",2)
	.Set str="合计人数:"_TPeopleNum_",平均病情严重程度:"_AvgICUGrade
	.Set Data=$lb(6,str)
	.Set ^CacheTemp(repid,ind)=Data
	.Set ind=ind+1
	
	
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Quit $$$OK
}

ClassMethod QryAIGByMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAIGByMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAIGByMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAIGByMonthExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2013-03-07
/// Description:  统计ICU临床病情等级记录
/// Table：       DHCMed.NINF.Rep.AimICUGrade
/// Input:        aDateFrom, aDateTo
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimICUGrade","StaICUGrade","2013-03-01","2013-03-18")
Query StaICUGrade(aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "AIGLocID:%String,AIGLocDesc:%String,AIGYear:%String,AIGMonth:%String,AIGItem1:%Integer,AIGItem2:%Integer,AIGItem3:%Integer,AIGItem4:%Integer,AIGItem5:%Integer,AIGItemCount:%Integer,AIGScoreCount:%Integer") [ SqlProc ]
{
}

ClassMethod StaICUGradeExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set aDateFrom=+aDateFrom
	Set aDateFrom=$zd(aDateFrom,3)
	Set YearFrom=$p(aDateFrom,"-",1)
	Set MonthFrom=$p(aDateFrom,"-",2)
	Set WeekFrom=$p(aDateFrom,"-",3)\7
	Set:WeekFrom>4 WeekFrom=4
	
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set aDateTo=+aDateTo
	Set aDateTo=$zd(aDateTo,3)
	Set YearTo=$p(aDateTo,"-",1)
	Set MonthTo=$p(aDateTo,"-",2)
	Set WeekTo=$p(aDateTo,"-",3)\7
	Set:WeekTo>4 WeekFrom=4
	
	Set xLocID=0
	For {
		Set xLocID=$o(^DHCMed.NINFi("Aim","ICUG","IndexLocYYMM",xLocID))
		Quit:xLocID=""
		Set LocDesc=$p($g(^CTLOC(xLocID)),"^",2)
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		Set xYear=YearFrom-1
		For {
			Set xYear=$o(^DHCMed.NINFi("Aim","ICUG","IndexLocYYMM",xLocID,xYear))
			Quit:xYear=""
			Quit:xYear>YearTo
			Set xMonth=0
			For {
				Set xMonth=$o(^DHCMed.NINFi("Aim","ICUG","IndexLocYYMM",xLocID,xYear,xMonth))
				Quit:xMonth=""
				Continue:(xYear=YearFrom)&&(xMonth<MonthFrom)
				Continue:(xYear=YearTo)&&(xMonth>MonthTo)
				Set xWeek=0
				For {
					Set xWeek=$o(^DHCMed.NINFi("Aim","ICUG","IndexLocYYMM",xLocID,xYear,xMonth,xWeek))
					Quit:xWeek=""
					Continue:(xYear=YearFrom)&&(xMonth=MonthFrom)&&(xWeek<WeekFrom)
					Continue:(xYear=YearTo)&&(xMonth=MonthTo)&&(xWeek>WeekTo)
					
					Set (AIGItem1,AIGItem2,AIGItem3,AIGItem4,AIGItem5,AIGItemCount,AIGScoreCount)=""
					Set xLogID=$o(^DHCMed.NINFi("Aim","ICUG","IndexLocYYMM",xLocID,xYear,xMonth,xWeek,0))
					Set objLog=##class(DHCMed.NINF.Rep.AimICUGrade).GetObjById(xLogID)
					If $IsObject(objLog)
					{
						Set AIGItem1=objLog.AIGItem1
						Set AIGItem2=objLog.AIGItem2
						Set AIGItem3=objLog.AIGItem3
						Set AIGItem4=objLog.AIGItem4
						Set AIGItem5=objLog.AIGItem5
						
						Set AIGItemCount=(+AIGItem1)+(+AIGItem2)+(+AIGItem3)+(+AIGItem4)+(+AIGItem5)
						Set AIGScoreCount=((+AIGItem1)*1)+((+AIGItem2)*2)+((+AIGItem3)*3)+((+AIGItem4)*4)+((+AIGItem5)*5)
						Set Data=$lb(xLocID,LocDesc,xYear,xMonth,AIGItem1,AIGItem2,AIGItem3,AIGItem4,AIGItem5,AIGItemCount,AIGScoreCount)
						Set ^CacheTemp(repid,ind)=Data
	    				Set ind=ind+1
					}
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod StaICUGradeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaICUGradeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaICUGradeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaICUGradeExecute ]
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

}
