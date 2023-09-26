Import SQLUser

Class web.DHCWMRVolumeQuery Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 98;

//通过（住院/出院）日期查询病案卷

//From 开始时间  To 结束时间  DateType：1：住院日期  2：出院日期

ClassMethod QueryVolumeByDate(From, To, DateType)
{
	n (From, To, DateType)	
	//set From=$zdh(From, 3)
	//set To=$zdh(To, 3)
	set intCnt = 0
	k ^CacheTemp("QueryVolumeByDate", $j)
	if (DateType = 1)
	{
		set intCnt = ..QueryVolumeByAdmitDate(From, To)
	}
	if (DateType = 2)
	{
		set intCnt = ..QueryVolumeByDisChargeDate(From, To)
	}
	q intCnt
}

ClassMethod QueryVolumeByAdmitDate(From, To)
{
	n (From, To)
	set admID = ""
	set tmpDate = 0
	set admInfo = ""
	set intCounter = 0
	set intCnt = 0
	for tmpDate=From:1:To
	{
		if ($d(^PAADMi("PAADM_AdmDate",tmpDate))) //查询Paadm
		{
			do
			{
				set admID=($o(^PAADMi("PAADM_AdmDate",tmpDate,admID)))
				if (admID '= "")
				{
					set admInfo = ^PAADM(admID)	
					if ($p(admInfo, "^", 2) = "I")
					{
						if ($d(^DHCWMRVOL(0,"VolAdm",admID)))
						{
							set ^CacheTemp("QueryVolumeByDate", $j, $o(^DHCWMRVOL(0,"VolAdm",admID,""))) = ""
							set intCounter = intCounter + 1
						}
						set intCnt = intCnt + 1
					}
				}
			} while (admID '= "")
		}
		if ($d(^DHCWMRHISADM(0,"ADMDate",tmpDate))) //查询病案记录
		{
			do
			{
				set admID=($o(^DHCWMRHISADM(0,"ADMDate",tmpDate,admID)))
				if (admID '= "")
				{
					if ($d(^DHCWMRVOL(0,"HistoryAdm",admID)))
					{
						set ^CacheTemp("QueryVolumeByDate", $j, $o(^DHCWMRVOL(0,"HistoryAdm",admID,""))) = ""
					}			
					set intCounter = intCounter + 1
				}
			} while (admID '= "")
		}			
	}
	
	q intCounter
}

//按出院日期查询

ClassMethod QueryVolumeByDisChargeDate(From, To)
{
	n (From, To)
	set admID = ""
	set tmpDate = 0
	set admInfo = ""
	set intCounter = 0
	set intCnt = 0
	for tmpDate=From:1:To
	{
		if ($d(^PAADMi("DischDate",tmpDate))) //查询Paadm
		{
			do
			{
				set admID=($o(^PAADMi("DischDate",tmpDate,admID)))
				if (admID '= "")
				{
					set admInfo = ^PAADM(admID)	
					if ($p(admInfo, "^", 2) = "I")
					{
						if ($d(^DHCWMRVOL(0,"VolAdm",admID)))
						{
							set ^CacheTemp("QueryVolumeByDate", $j, $o(^DHCWMRVOL(0,"VolAdm",admID,""))) = ""
							set intCounter = intCounter + 1
						}
						set intCnt = intCnt + 1
					}
				}
			} while (admID '= "")
		}
		if ($d(^DHCWMRHISADM(0,"DisDate",tmpDate))) //查询病案记录
		{
			do
			{
				set admID=($o(^DHCWMRHISADM(0,"DisDate",tmpDate,admID)))
				if (admID '= "")
				{
					if ($d(^DHCWMRVOL(0,"HistoryAdm",admID)))
					{
						set ^CacheTemp("QueryVolumeByDate", $j, $o(^DHCWMRVOL(0,"HistoryAdm",admID,""))) = ""
					}			
					set intCounter = intCounter + 1
				}
			} while (admID '= "")
		}			
	}
	
	q intCounter
}

}
