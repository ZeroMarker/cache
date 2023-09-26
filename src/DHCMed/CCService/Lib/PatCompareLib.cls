/// 患者基本信息比较类
/// 创建者：刘宇辉
/// 创建日期：2010-11-02
Class DHCMed.CCService.Lib.PatCompareLib Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-10-13
/// Description:  判断体温是否正常
/// Table：       
/// Input：       TempStr
/// Return：      ret=0:正常 '=0:不正常
/// w ##class(DHCMed.CCService.Lib.PatCompareLib).TempCompare("37|38")
ClassMethod TempCompare(TempStr As %String)
{
	n (TempStr, %PAADM, %ExtraData, %ExtraDataCnt)
	s ret=0
	q:TempStr="" ret	
	s TempL=+$p(TempStr,"|",1)
   	s TempH=+$p(TempStr,"|",2)
	
	s MrAdmObj=##class(DHCMed.Base.MRAdm).GeObjtByPaadm(%PAADM)
	s MrAdmDR=MrAdmObj.Rowid
	
	s MROBSSub=0
    f  s MROBSSub=$o(^MR(MrAdmDR,"OBS",MROBSSub)) q:MROBSSub=""  d
    .s ItemDR=$p($g(^MR(MrAdmDR,"OBS",+MROBSSub)),"^",1)
    .q:'$d(^MRC("OBITM",+ItemDR))
    .q:($p($g(^MRC("OBITM",+ItemDR)),"^",1)'["体温")
    .s Value=$p($g(^MR(MrAdmDR,"OBS",+MROBSSub)),"^",2)
    .s flag=$$CalcTempFlag(Value,TempL,TempH)
    .i flag'=0 d
    ..s ret=1
    ..;s Points=Points+TempWeight
    ..;s ^CacheTemp($zn,$j,"PAADM",%PAADM,"Temperature","MSG")=$g(^CacheTemp($zn,$j,"PAADM",%PAADM,"Temperature","MSG"))_Value_";"
    ..s tmp=""
	..s tmp=Value
	..s tmp=tmp_"^"_TempL		
	..s tmp=tmp_"^"_TempH 
	..s tmp=tmp_"^"_flag  		
	..s %ExtraDataCnt=%ExtraDataCnt+1
	..s $li(%ExtraData,%ExtraDataCnt)="T"_$C(1)_tmp
	..s flag=0

	q ret
	
CalcTempFlag(BodyTemp,TempL,TempH)
      n (BodyTemp,TempL,TempH)
      s flag=0
      s:BodyTemp<TempL flag=-1
      s:BodyTemp>TempH flag=1
      q flag
}

ClassMethod GetTempDetails(Str As %String) As %String
{
	n (Str)
	s ret=""
	s ret=ret_"体温值:"_$p(Str,"^",1)
	q ret
}

/// Creator：     liuyh
/// CreatDate：   2010-11-01
/// Description:  判断病人年龄是否大于该年龄
/// Input：       标准年龄
/// Return：      ret>0:大于该年龄
/// w ##class(DHCMed.CCService.Lib.PatCompareLib).AgeCompare(75)
ClassMethod AgeCompare(Age As %String)
{
		n (Age, %PAADM, %ExtraData, %ExtraDataCnt,%Patient,%Adm,%Patient)
		s ret=0
		q:+Age=0 ret
		
		s PatAge=""
		s PatAge=##Class(DHCMed.CCService.Lib.PatientLib).Age()
		q:PatAge="" ret
		
		i PatAge>Age d
		.s ret=1
		.s tmp=""
		.s tmp=PatAge				//病人年龄
		.s tmp=tmp_"^"_Age 			//标准年龄
		.s %ExtraDataCnt=%ExtraDataCnt+1
		.s $li(%ExtraData,%ExtraDataCnt)="A"_$C(1)_tmp
		q ret
}

/// w ##class(DHCMed.CCService.Lib.AgeLib).GetDetails("82^75")
ClassMethod GetAgeDetails(Str As %String) As %String
{
	n (Str)
	s ret=""
	s Str=$p(Str,$c(1),2)
	s ret="病人年龄:"_$p(Str,"^",1)
	s ret=ret_"  ||标准年龄:"_$p(Str,"^",2)
	q ret
}

Storage Default
{
<Data name="PatCompareLibDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CCServ6AF.PatCompareLibD</DataLocation>
<DefaultData>PatCompareLibDefaultData</DefaultData>
<IdLocation>^DHCMed.CCServ6AF.PatCompareLibD</IdLocation>
<IndexLocation>^DHCMed.CCServ6AF.PatCompareLibI</IndexLocation>
<StreamLocation>^DHCMed.CCServ6AF.PatCompareLibS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
