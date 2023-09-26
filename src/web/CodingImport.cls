Import SQLUser

Class web.CodingImport Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 38;

ClassMethod SaveToTmpData(Main, History, HistoryAdm, ICD, Extra)
{
	set strData = ""
	set $p(strData, "<s>", 1) = Main
	set:$p(History,"^",5)="0:00:00" $p(History,"^",5)=""
	set $p(strData, "<s>", 2) = History
	set $p(strData, "<s>", 3) = HistoryAdm
	set $p(strData, "<s>", 4) = ICD
	set $p(strData, "<s>", 5) = Extra
	set intCnt = +$g(^FPImport)
	set ^FPImport = intCnt + 1
	set ^FPImport(intCnt + 1) = strData
}

ClassMethod ProcessImport(del)
{
	if (del="yes")
	{
		kill ^DHCWMRHISTORY
		kill ^DHCWMRHISADM
		kill ^DHCWMRMAIN
		kill ^DHCWMRVOL
		kill ^DHCWMRVOLINFO
		kill ^DHCWMRFP
		kill ^DHCWMRFPICD
		kill ^DHCWMRFPE
	}
	
	set intCnt = ""
	do
	{
		set intCnt = $o(^FPImport(intCnt))
		if (intCnt '= "")
		{
			set strData = $g(^FPImport(intCnt))
			set Main = $p(strData, "<s>", 1) 
			set History = $p(strData, "<s>", 2)
			set HistoryAdm = $p(strData, "<s>", 3) 
			set ICD = $p(strData, "<s>", 4)
			set Extra = $p(strData, "<s>", 5)			
			w !,"正在处理  病案号："_$p(Main,3)_"..."
			set ret = ##class(web.CodingImport).ImportCoding(Main, History, HistoryAdm, ICD, Extra)
			w "完成，返回值："_ret
		}
	} while(intCnt '= "")
	quit 1
}

ClassMethod ImportCoding(Main, History, HistoryAdm, ICD, Extra)
{
	n (Main, History, HistoryAdm, ICD, Extra)
	quit:Main="" -1
	//Main Info
	set MrType = $p(Main, "^", 2)
	set MrNo = $p(Main, "^", 3)
	set MainDr = 0
	if ($d(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo)) = 0)
	{
		set HistoryID = ##class(web.DHCWMRHistoryCtl).UpdateHistory(History)
		set $p(Main,"^",5) = HistoryID
		set $p(HistoryAdm, "^", 2) = HistoryID
		set MainDr = ##class(web.DHCWMRMainCtl).UpdateMain(Main)
	}
	else
	{
		set MainDr = $o(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo,""))
	}
	quit:+MainDr=0 -1
	
	//HistoryAdm
	set AdmitDate = $zdh($p(HistoryAdm, "^", 3),3)
	set VolID = ##class(web.CodingImport).IsVolExists(MainDr, AdmitDate)
	if (VolID = 0)
	{
		set HistoryAdm = ##class(web.DHCWMRHistoryCtl).UpdateAdm(HistoryAdm)
		set VolData = "^"_MainDr_"^^"_HistoryAdm_"^N^N^9^Y^N^Import^"
		set VolID = ##class(web.DHCWMRVolumeCtl).UpdateVol(VolData)
	}
	//b
	//Front Page
	set fpID = $o(^DHCWMRFP(0,"VolumeDr", VolID, ""))
	quit:fpID'="" -100
	set FpMain = "^^^^^^"
	set $p(FpMain, "^", 1) = fpID
	set $p(FpMain, "^", 2) = VolID
	set $p(FpMain, "^", 3) = "Import"
	set $p(FpMain, "^", 4) = 2040
	set $p(FpMain, "^", 5) = $p($h, ",", 1)
	set $p(FpMain, "^", 6) = $p($h, ",", 2)
		//set FpID = ##class(web.DHCWMRFrontPageCtl).UpdateFrontPage(FpMain)

	set strICD = ""
	set intCounter = 0
	set tmpICD = ""
	for intCounter=1:1:$l(ICD, $c(1))
	{
		set strICD = $p(ICD, $c(1), intCounter)
		continue:strICD=""
		set strICDInfo = $p(strICD, "^", 3)
		set ICDCode = $p(strICDInfo, "#", 1)
		set ICDDesc = $p(strICDInfo, "#", 2)
		set ICDVer = $p(strICDInfo, "#", 3)
		set ICDPinYin = $p(strICDInfo, "#", 4)
		set ICDDxDr = $o(^DHCWMRICD(0,"ICD", ICDCode, ""))
		if (ICDDxDr = "")
		{
			set ICDDxInfo = "^"_ICDCode_"^^"_ICDDesc_"^"_ICDVer_"^Import^Y"
			set ICDDxDr = ##class(web.DHCWMRICDCtl).UpdateICDDx(ICDDxInfo)
			//d ##class(web.DHCWMRICDCtl).UpdateICDDx("^"_ICDDxDr_"^"_ICDPinYin)
		}
		set $p(strICD, "^", 3) = ICDDxDr
		set tmpICD=tmpICD_strICD_$c(1)
	}
	set result = ##class(web.DHCWMRFrontPageCtl).Coding("", FpMain, tmpICD, Extra)
	quit result
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
			set AdmDate = $zdh($p(strHisAdm, "^", 3), 3)
		}
		set:AdmitDate=AdmDate ret=VolID
		set VolID = $o(^DHCWMRVOL(0,"Main", MainDr, VolID))
	}
	quit ret
}

}
