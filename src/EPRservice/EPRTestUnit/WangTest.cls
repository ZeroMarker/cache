Class EPRservice.EPRTestUnit.WangTest Extends %Persistent
{

//d ##class(EPRservice.EPRTestUnit.WangTest).GetYXDisDT(7)

/// 说明：
/// 把下面内容拷贝到 EPRservice.SystemData  中，编译
/// 然后在Terminal中执行下面语句
/// w ##class(EPRservice.SystemData).DelErrScatterFormateInfo("58","-4")
/// 其中58是病人就诊RowId，-4是打印时所报的错误数字
/// CreateDate: 2008-09-22
/// CreateUser: houjian@dhcc.com.cn
/// Description: 删除EpisodeID所有ISegment和ITextDesc中的错误格式信息
/// Input：EpisodeID 病人就诊号
/// 	   ErrorNum  打印时报错信息的数字，如-2，-3等
/// Example: w ##class(EPRservice.SystemData).DelErrScatterFormateInfo("58","-4")
ClassMethod DelErrScatterFormateInfo(AEpisodeID As %String, AErrorNum As %String) As %String
{
	quit:((AEpisodeID="")||(AErrorNum="")) "EpisodeID or ErrorNum is null !!!"
	
	s blankeid = " "_AEpisodeID
	
	//清除ISegment中的错误格式信息
	s tid = $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,""))
	while tid '= ""
	{
		s scode =  $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,tid,""))
		while scode '= ""
		{
			s iid = $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,tid,scode,""))
			while iid '= ""
			{
				s rowid = $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,tid,scode,iid,""))
				if rowid '= ""
				{
					do ..DelScaErrFormateInfoById("EPRinstance.ISegment",rowid,AErrorNum)
				}
				
				s iid = $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,tid,scode,iid))
			}
			
			s scode =  $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,tid,scode))
		}
		
		s tid = $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,tid))
	}
	
	//清除ITextDesc中的错误格式信息
	s tid = $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,""))
	while tid '= ""
	{
		s tcode =  $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,tid,""))
		while tcode '= ""
		{
			s iid = $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,tid,tcode,""))
			while iid '= ""
			{
				s rowid = $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,tid,tcode,iid,""))
				if rowid '= ""
				{
					do ..DelScaErrFormateInfoById("EPRinstance.ITextDesc",rowid,AErrorNum)
				}
				
				s iid = $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,tid,tcode,iid))
			}
			
			s tcode =  $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,tid,tcode))
		}
		
		s tid = $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,tid))
	}
	
	quit "Succeed !!!"
}

/// CreateDate: 2008-09-22
/// CreateUser: houjian@dhcc.com.cn
/// Description: 删除EpisodeID下某个ISegment和ITextDesc中的错误格式信息
/// Input：AClassName 类名
/// 	   ARowId     
/// 	   ErrorNum   打印时报错信息的数字，如-2，-3等
ClassMethod DelScaErrFormateInfoById(AClassName As %String, ARowId As %String, AErrorNum As %String)
{
	quit:((AClassName=0)||(ARowId="")||(AErrorNum="")) "0"
	
	//错误的格式信息标志
	s tag = "</StartPos><EndPos>"_AErrorNum_"</EndPos><FontStruct>"
		
	s obj = $zobjclassmethod(AClassName,"%OpenId",ARowId)
	if obj '= ""
	{
		//备份流数据
		s len = 32000
		s ^DHCEPRBackupScatterData(AClassName,ARowId) = obj.FormateInfo.Read(.len)
		while (len '= -1)
		{
			s ^DHCEPRBackupScatterData(AClassName,ARowId) = ^DHCEPRBackupScatterData(AClassName,ARowId)_obj.FormateInfo.Read(.len)
		} 
		
		s strTot = ^DHCEPRBackupScatterData(AClassName,ARowId)
		s count = $Length(strTot,"<FormatRange>")
		if (count > 1)   //包含格式信息
		{
			s modifiedStr = ""
			for I = 1:1:count
			{
				s str = $p(strTot,"<FormatRange>",I)
				if $find(str,tag)
				{	s modifiedStr = modifiedStr_$p(str,"</FormatRange>",2)}
				else
				{	
					if I = 1
					{ s modifiedStr = str}
					else
					{ s modifiedStr = modifiedStr_"<FormatRange>"_str}	
				}
			}
			do obj.FormateInfo.Clear()
			do obj.FormateInfo.Write(modifiedStr)
			do obj.%Save()
			w AClassName_" "_ARowId_" Succeed!!!",!		
		}	
	}
	
	quit
}

ClassMethod testmr() As %String
{
	
	w ##Class(EPRservice.HISInterface.PatientInfoAssist).DisDateTimeMR(7,"DHC-DATA","DiTan")
}

ClassMethod test(argData As %String) As %String
{
	s Data=argData
	s SubYear="",SubMonth="",SubDay=""
	s Year="",Month="",Day="",Count="1"
	
	s Data=$p($g(Data)," ",1)
	
	s SubYear=$p($g(Data),"-",1)
	s SubMonth=$p($g(Data),"-",2)
	s SubDay=$p($g(Data),"-",3)
	
	if SubMonth+9 <12
	{
		if SubDay+7>30
		{
			s Day=(SubDay+7)#30
			s Month=((SubMonth+9)+Count)#12
			if Month="0" { s Month="12" }
			s Year=SubYear	}
		else
		{
			s Day=(SubDay+7)
			s Month=(SubMonth+9)
			s Year=SubYear	}
								}
	elseif  SubMonth+9 =12
	{ 
		if SubDay+7 >30
		{
			s Day=(SubDay+7)#30
			s Month=((SubMonth+9)+Count)#12
			s Year=SubYear+Count }
		else
		{
			s Day=(SubDay+7)
			s Month=(SubMonth+9)
			s Year=SubYear	}
								}
	else
	{ 
		if SubDay+7 >30
		{
			s Day=(SubDay+7)#30
			s Month=((SubMonth+9)+Count)#12
			s Year=SubYear+Count }
		else
		{
			s Day=(SubDay+7)
			s Month=((SubMonth+9))#12
			s Year=SubYear+Count
			if (Month="2")&&((SubDay+7 =30)||(SubDay+7 =29))
			{
				s Day=Day#28
				s Month=Month+Count
				s Year=Year
				}		
						}
								}
	w "============",!,Year_"-"_Month_"-"_Day,!,"============",!
	;
}

ClassMethod CheckCharLength(argChar As %String, argLength As %Integer) As %String
{
	q:($d(argChar)=0)||($d(argLength)=0)||(argChar="")||(argLength="") ""

	/// get the length of argChar in GB character set, that is, a GB character's length is 2
	;b "s"
	s charLength=$l($zcvt(argChar,"O","GB"))
	s length=$l(argChar)
	q:(charLength'>argLength) argChar
	;q:(length<4) ""
	q:(length<4) $e(argChar,1,argLength)
	if argLength<=4
	{
		s getLength = argLength - 1
		s endString = "."	
	}
	else
	{
		s getLength = argLength - 4
		s endString = "...."	
	}

	if charLength - length > argLength - 4
	{
		q $e(argChar,1,getLength/2)_endString
	}
	else
	{
		q $e(argChar,1,getLength -(charLength - length))_endString
	}
	q argChar
}

ClassMethod GetYXDisDT(adm As %String) As %String
{
	;出院日期(调袁旭第一次出院日期), 时间
 ;Remote Update by wangwt 2008-01-29
 b "s"
 s dischgDate=$zd($P(^PAADM(adm),"^",17),3) ;comment by wangwt
 ;w !,"dischgDate=4321"_dischgDate
 ;Begin wangwt
 ;d $zu(5,"meddata")
 ;s dischgDate2=$$GetDisAdmDate^DHCMRIPday(adm)
 ;w !,"dischgDate=1234"_dischgDate
 ;zn "websource"
 ;End wangwt
 ;lgl+
 ;q:'$d(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",adm)) 
 ;zn "meddata"
 s iprowid=0 f  s iprowid=$o(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",adm,iprowid)) q:iprowid=""  d
 .s MRIPDayDr=$p(^DHCMRIPDetail(iprowid),"^",3)
 .s dischgDate=$p(^MRIPdaily(MRIPDayDr),"^",6)
 ;d $zu(5,"websource")
 /*
 i dischgDate'="" d
 .s dischgDate=$zd(dischgDate,3)
 .s OutYear=$p(dischgDate,"-",1),OutMonth=$p(dischgDate,"-",2),OutDay=$p(dischgDate,"-",3)
 s dischgTime=$P(^PAADM(adm),"^",18)  ;
 i dischgTime'="" d
 .s dischgTime=$zt(dischgTime,1)
 else  d
 .s dischgTime="00:00:00"
 s dischgDateTime=dischgDate_" "_dischgTime
 if dischgDateTime=" " {s dischgDateTime=""}
	*/
	w "1111111111111111111111111"
	b
}

Storage Default
{
<Data name="WangTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EPRservice.EPRTest82D.WangTestD</DataLocation>
<DefaultData>WangTestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRservice.EPRTest82D.WangTestD</IdLocation>
<IndexLocation>^EPRservice.EPRTest82D.WangTestI</IndexLocation>
<StreamLocation>^EPRservice.EPRTest82D.WangTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

/// ///////////////////////////////////////////////////////// ///////////////////////////////////////////////////////// //////////////////////////////////////////////////////
/// ///////////////////////////////////////////////////////// ///////////////////////////////////////////////////////// /////////////////////////////////////////////////////
/// //////////////////////////////////////////////////////[HIS]病人出入院信息
ClassMethod GetADTInfoExecute(ByRef qHandle As %Binary, adm As %String) As %Status
{
 s qHandle=""
 s SQLCODE=0
 
 ;EPR> 系统标识号
 s papmidr="",paperdr=""

 ;EPR> PA_Adm.PAADM_PAPMI_DR
 s papmidr = $P($g(^PAADM(adm)),"^",1)
 
 ;EPR> PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
 s paperdr = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(papmidr)


 
 set MQueryPat=$LB("",adm,papmidr,RegisterNo,Medicare,OMedicare,EMedicare,IDCard,InsuranceNo,Name,Sex,Birthday,Age,AgeDay,MedicareAgeYear,MedicareAge,MedicareAgeUnit,Marriage,Native,CityBirth,ProvinceBirth,Occupation,Nation,Nationality,PayMode,MoubilePhone,LinkName,LinkRelation,LinkAddress,LinkPhone,WorkAddress,WorkTel,WorkPostalCode,HuKouAddress,HuKouTel,HuKouPostalCode,AdmDoctor,AdmDateTime,AdmDate,AdmTime,AdmDateTimeInBed,AdmDateInBed,AdmTimeInBed,InTimes,AdmDept,AdmWard,AdmBed,TransDept,TransDeptDetail,DischgDateTime,DischgDate,DischgTime,DischgDept,DischgWard,DischgBed,ResidentDays,Diag01,Diag02,Diag03,Diag04,Diag05,Diag06,Diag07,Diag08,Diag09,Diag10,Diag11,Diag12,Diag13,Diag14,Diag15,Care1,Care2,Care3,Care4,Care5,Care6)
 
 s qHandle=MQueryPat
 Quit $$$OK
}

ClassMethod GetADTInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
	if qHandle'=""
	{
		s Row=qHandle
		s qHandle=""
	}
	else
	{
		s Row = ""
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetADTInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
 s qHandle="" 
	Quit $$$OK
}

Query GetADTInfo(adm As %String) As %Query(ROWSPEC = "NULL:%String,AdmID:%String,PapmiDR:%String,RegisterNo:%String,Medicare:%String,OMedicare:%String,EMedicare:%String,IDCard:%String,InsuranceNo:%String,Name:%String,Sex:%String,Birthday:%String,Age:%String,AgeDay:%String,MedicareAgeYear:%String,MedicareAge:%String,MedicareAgeUnit:%String,Marriage:%String,Native:%String,CityBirth:%String,ProvinceBirth:%String,Occupation:%String,Nation:%String,Nationality:%String,PayMode:%String,MoubilePhone:%String,LinkName:%String,LinkRelation:%String,LinkAddress:%String,LinkPhone:%String,WorkAddress:%String,WorkTel:%String,WorkPostalCode:%String,HuKouAddress:%String,HuKouTel:%String,HuKouPostalCode:%String,AdmDoctor:%String,AdmDateTime:%String,AdmDate:%String,AdmTime:%String,AdmDateTimeInBed:%String,AdmDateInBed:%String,AdmTimeInBed:%String,InTimes:%String,AdmDept:%String,AdmWard:%String,AdmBed:%String,TransDept:%String,TransDeptDetail:%String,DischgDateTime:%String,DischgDate:%String,DischgTime:%String,DischgDept:%String,DischgWard:%String,DischgBed:%String,ResidentDays:%String,Diag01:%String,Diag02:%String,Diag03:%String,Diag04:%String,Diag05:%String,Diag06:%String,Diag07:%String,Diag08:%String,Diag09:%String,Diag10:%String,Diag11:%String,Diag12:%String,Diag13:%String,Diag14:%String,Diag15:%String,Care1:%String,Care2:%String,Care3:%String,Care4:%String,Care5:%String,Care6:%String")
{
}

}
