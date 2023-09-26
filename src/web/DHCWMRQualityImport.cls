/// 质控导入
Class web.DHCWMRQualityImport Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 92;

ClassMethod SaveToTmpData(MrNo, AdmitDate, ResultMain, ResultDtl) As %String
{
	n (MrNo, AdmitDate, ResultMain, ResultDtl)
	set MrType = 7
	
	set MainID = $o(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo,""))
	quit:MainID="" -1 //没有这个住院号
	quit:AdmitDate="" -2 //住院日期为空
	set AdmitDate = $zdh(AdmitDate,3)
	set VolID = ..IsVolExists(MainID, AdmitDate)
	quit:VolID=0 -3 //没有这一卷
	set $p(ResultMain,"^",2)=VolID
	set Ind = +$g(^DHCWMRQualityImport) + 1
	set ^DHCWMRQualityImport(Ind, "MainID") = MainID
	set ^DHCWMRQualityImport(Ind, "VolID") = VolID
	set ^DHCWMRQualityImport(Ind, "Main") = ResultMain
	set ^DHCWMRQualityImport(Ind, "Detail") = ResultDtl
	set Ind = Ind + 1
	set ^DHCWMRQualityImport = Ind
	quit 0 //OK~~~
}

ClassMethod Test()
{
		kill ^DHCWMRFP
		kill ^DHCWMRFPICD
		kill ^DHCWMRFPE
	/*	
	set intCnt = ""
	set Counter = 1
	do
	{
		set intCnt = $o(^FPImport(intCnt))
		if (intCnt '= "")
		{
			set strData = $g(^FPImport(12))
			set Main = $p(strData, "<s>", 1) 
			set History = $p(strData, "<s>", 2)
			set HistoryAdm = $p(strData, "<s>", 3) 
			set ICD = $p(strData, "<s>", 4)
			set Extra = $p(strData, "<s>", 5)			
			w !,"正在处理  病案号："_$p(Main,3)_"..."
			set ret = ##class(web.CodingImport).ImportCoding(Main, History, HistoryAdm, ICD, Extra)
			w "完成，返回值："_ret
		}
		set Counter = Counter + 1
		quit:Counter>1
	} while(intCnt '= "")*/
	quit ""
}

//w ##class(web.DHCWMRQualityImport).ProcessImport("yes")

ClassMethod ProcessImport(del)
{
	if (del="yes")
	{
		kill ^DHCWMRERST
	}
	
	set intCnt = ""
	set Counter = 1
	set intCounter = 0
	do
	{
		set intCnt = $o(^DHCWMRQualityImport(intCnt))
		if (intCnt '= "")
		{
			set VolID = $g(^DHCWMRQualityImport(intCnt,"VolID"))
			set strResultMain = $g(^DHCWMRQualityImport(intCnt,"Main"))
			set strDetailList = $g(^DHCWMRQualityImport(intCnt,"Detail"))		
			w !,"正在处理  VolID:"_VolID_"..."
			
			set $p(strResultMain, "^", 2) = VolID
			
			
			
			
			set ret = ##class(web.DHCWMRExamResultCtl).SaveExamRst(strResultMain, strDetailList)
			w "完成，返回值："_ret
			kill ^DHCWMRQualityImport(intCnt)
		}
		set Counter = Counter + 1
		//quit:Counter>10
	} while(intCnt '= "")
	quit ""
}

ClassMethod IsVolExists(MainDr, AdmitDate)
{
	n (MainDr, AdmitDate)
	set ret = 0
	set VolID = $o(^DHCWMRVOL(0,"Main", MainDr, ""))
	while (VolID '= "")
	{
		set strVol = ##class(web.DHCWMRVolumeCtl).GetVolume(+VolID)
		set Paadm = $p(strVol, "^", 3)
		set HistoryID = $p(strVol, "^", 4)
		if (Paadm '= "")
		{
			set strPaadm = ##class(web.DHCWMRBasePaadm).GetAdmInfo(Paadm)
			set AdmDate = $zdh($p(strPaadm, "^", 4), 3)
		}
		else
		{
			set strHisAdm = ##class(web.DHCWMRHistoryCtl).GetHistoryAdmById(HistoryID)
			set:$p(strHisAdm,"^",3)="" $p(strHisAdm,"^",3)="1900-01-01"
			set AdmDate = $zdh($p(strHisAdm, "^", 3), 3)
		}
		set:AdmitDate=AdmDate ret=VolID
		set VolID = $o(^DHCWMRVOL(0,"Main", MainDr, VolID))
	}
	quit ret
}

ClassMethod CreateExamEntry(EntryTitle, ResumeText, Extra) As %String
{
	n (EntryTitle, ResumeText, Extra)
	set RuleID = 52
	set SectionID = $p(Extra,"^",1)
	set SectionID = $p(SectionID,"||",2)
	quit:EntryTitle=""!SectionID="" 0
	set EntryDicID = $o(^DHCWMREDIC(0,"Title",EntryTitle,""))
	if (EntryDicID="")
	{
		set strData = ""
		set $p(strData,"^",1)=""
		set $p(strData,"^",2)=$o(^DHCWMREDIC(0,"CODE",""),-1)
		set $p(strData,"^",3)=EntryTitle
		set $p(strData,"^",4)=19
		set $p(strData,"^",5)="Y"
		set $p(strData,"^",6)=ResumeText
		set EntryDicID = ##class(web.DHCWMRQualityDic).UpdateEntryDic(strData)
	}
	set ExamEntryID = $o(^DHCWMRER(RuleID,"S",SectionID,"E",0,"Entry",EntryDicID,""))
	if (ExamEntryID = "")
	{
		set $p(Extra,"^",3)= EntryDicID
		set ExamEntryID = ##class(web.DHCWMRExamRuleCtl).UpdateEntry(Extra)
	}
	else
	{
		set ExamEntryID = RuleID_"||"_SectionID _ "||" _ ExamEntryID
	}
	quit ExamEntryID
}

}
