Import SQLUser

Class web.DHCWMRFpCodingQryMultiAdm Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 42;

//病案号，住院次数

/// 本查询用来查找多次住院的病人信息
/// Create By LiYang 2008-10-09
/// 查询结果与编目查询返回数据格式一致
ClassMethod GetAdmitList(MrNo, Times)
{
		n (MrNo)
		quit:+MrNo=0 ""
		set MrType = 7
		set MainDr = $o(^DHCWMRMAIN(0,"TypeNO", +MrType, +MrNo, ""))
		quit:MainDr="" ""
		set ret = ""
		set VolID = ""
		set intCnt = 0
		while 1
		{
			set VolID = $o(^DHCWMRVOL(0,"Main", MainDr, VolID))
			quit:VolID=""
			set intCnt = intCnt + 1
			set ret = ret _ VolID _ "^"
		}
		quit:intCnt>=2 ret
		quit ""
}

//查询结果与编目查询返回数据格式一致

ClassMethod BuildQueryData(VolumeID, FPRowID, Simple)
{
	n (VolumeID, FPRowID, Simple)
	//set $ZT="BuildQueryDataError"
	set data=$lb("")
 	set volume=$g(^DHCWMRVOL(VolumeID))
	set main=$g(^DHCWMRMAIN($p(volume,"^",1)))
	set mrTypeDic=$g(^DHCWMRDIC($p(main,"^",1)))
 	//疾病、手术
 	set strICDID = ""
 	set strDisease = ""
 	set strOpe = ""	
	if (Simple=0)
	{
		set adm=##class(web.DHCWMRBaseInfoCtl).GetAdmInfoByVol(VolumeID)
		set baseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain($p(volume,"^",1))
		while (1)
 		{
		 	set strICDID = $o(^DHCWMRFPICD(0, "FP", FPRowID, strICDID))
		 	quit:strICDID=""
		 	set strICD = $g(^DHCWMRFPICD(+strICDID))
		 	set strICDDx = $g(^DHCWMRICD(+$p(strICD,"^",2)))
		 	set:$p($g(^DHCWMRDIC(+$p(strICD,"^",10))),"^",2)="D" strDisease = strDisease _ $p(strICDDx,"^",3) _ ","
		 	set:$p($g(^DHCWMRDIC(+$p(strICD,"^",10))),"^",2)="O" strOpe = strOpe _ $p(strICDDx,"^",3) _ "," 
		}		
	}else
	{
		set adm=""
		set baseInfo=""
	}
	set $li(data,1)=$p(volume,"^",1) //MrMainID
	set $li(data,2)=VolumeID //volumeID
	set $li(data,3)=FPRowID //FrontPage RowID
	set $li(data,4)=$p(mrTypeDic,"^",3) //MrTypeDesc
 	set $li(data,5)=$p(main,"^",2) //MrNo
 	set $li(data,6)=$p(baseInfo,"^",2) //PatientName
 	set $li(data,7)=$p(baseInfo,"^",4) //sex
 	set $li(data,8)=""
 	set birthday = $p(baseInfo, "^", 5)	
 	set $li(data,9)=$p(adm,"^",3) //admit date
 	set $li(data,10)=$p(adm,"^",5) //admit dep
 	set $li(data,11)=$p(adm,"^",7) //discharge date
 	set $li(data,12)=$p(adm,"^",9) //discharge dep
 	set start = $p(adm,"^",3)
 	set end = $p(adm,"^",7)
 	set:(start'="")&(end'="") $li(data,13) = $zdh(end, 3) - $zdh(start, 3)
 	set:(start="")!(end="") $li(data,13) = ""
 	
 	


	set $li(data,14) = strDisease
	set $li(data,15) = strOpe
 	set:(birthday'="")&(start'="") $li(data,8)= ($zdh(start, 3) - $zdh(birthday,3))\365
 	
 	Quit data
 
BuildQueryDataError
	set intCounter = 0
	for intCounter=1:1:13
	{
		set $li(data,intCounter)=""
	}
 	Quit data
}

ClassMethod QueryByMrNoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByMrNoListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryByMrNoListExecute(ByRef qHandle As %Binary, MrNoList As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	set intCnt = 0
	set intCounter = 0
	set MrNo = ""
	set tmpVolID = ""
	for intCnt=1:1:$l(MrNoList,"^")
	{
		set MrNo = $p(MrNoList, "^", intCnt)
		set VolList = ..GetAdmitList(MrNo)
		if (VolList '= "")
		{
			for intCounter=1:1:$l(VolList,"^")
			{
				set tmpVolID = $p(VolList, "^", intCounter)
				set FpRowID = $o(^DHCWMRFP(0, "VolumeDr", +tmpVolID, ""))
				if (FpRowID'="")
				{
					set data = ..BuildQueryData(tmpVolID, FpRowID, 0)
					set ^CacheTemp(repid, ind) = data
					set ind = ind + 1
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QueryByMrNoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByMrNoListExecute ]
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

Query QueryByMrNoList(MrNoList As %String) As %Query(ROWSPEC = "MainID:%String:MainID,VolID:%String:VolID,FpID:%String:FpID,MrType:%String:病案种类,MrNo:%String:病案号,PatientName:%String:姓名,Sex:%String:性别,Age:%String:年龄,AdmitDate:%String:住院日期,AdmitDep:%String:住院科室,DisDate:%String:出院日期,DisDep:%String:出院科室,Days:%String:住院天数,Diagnose:%String:诊断,Operation:%String:手术")
{
}

ClassMethod Test()
{
	set mrno = "0000000^0000000^0413970^0414240^0111051^0413251^0189054^0414396^0331909^0414614^0414577^0411359^0414681^0414665^0414680^0000000^0373666^0415121^0000000^0415215^0415218^0389856^0415217^0374074^0374074^0415175^0365586^0365586^0410867^0362813^0322453^0415475^0415790^0384758^0384758^0415844^0416006^0366189^0366189^0416120^0000000^0000000^0000000^0000000^0416302^0416302^0348471^0049060^0416186^0394000^0416376^0347261^0416445^0416445^0366112^0416517^0416517^0000000^0000000^0000000^0353071^0357714^0357714^0417002^0417093^0362751^0416800^0344798^0109917^0417473^0335465^0417534^0417731^0417725^0417725^0417716^0417716^0417698^0417698^0396145^0396145^0320240^0417675^0417837^0417725^0417887^0000000^0000000^0000000^0000000^0000000^0000000^0418304^0418304^0018335^0344798^0306524^0418244^0000000^0000000^0000000^0418462^0138914^0306291^0418577^0418824^0000000^0418916^0418933^0418971^0398483^0418904^0395440^0000000^0000000^0418949^0000000^0419027^0419396^0337883^0419725^0419724^0419730^0419661^0271015^0199135^0420061^"
	d ##Class(%ResultSet).RunQuery("web.DHCWMRTest", "QueryByMrNoList", mrno)
	quit ""
}

Storage StorageSQL
{
<Type>%Storage.SQL</Type>
}

}
