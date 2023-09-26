Class DHCENS.LIS.AdmInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "AdmInfo";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 就诊号
Property AdmNo As %String(TRUNCATE = 1);

/// 就诊日期
Property AdmDate As %String(TRUNCATE = 1);

/// 就诊时间
Property AdmTime As %String(TRUNCATE = 1);

/// 费别
Property FeeType As %String(TRUNCATE = 1);

/// 患者所在科室
Property PatientDept As %String(TRUNCATE = 1);

/// 患者所在病区
Property PatientWard As %String(TRUNCATE = 1);

/// 床号
Property BedNo As %String(TRUNCATE = 1);

/// 诊断
Property Diagnose As %String(TRUNCATE = 1);

ClassMethod GetAdmInfoByRowid(rowid As %String) As DHCENS.LIS.AdmInfo
{
	set obj=##class(DHCENS.LIS.AdmInfo).%New()
	set obj.AdmNo=rowid
	
	s obj.AdmDate=$zd($p($g(^PAADM(rowid)),"^",6),3)	
	s obj.AdmTime=$zt($p($g(^PAADM(rowid)),"^",7))		
	s obj.FeeType=""
	
	s DepCodeDr=$p($g(^PAADM(rowid)),"^",4)
	i (DepCodeDr'="")
	{ 
		s obj.PatientDept=$p($g(^CTLOC(DepCodeDr)),"^",1)_"@"_$p($g(^CTLOC(DepCodeDr)),"^",2)
	}

	s WardDR=$p(^PAADM(rowid),"^",70)
  	i (WardDR'="")
  	{
		s obj.PatientWard=$p($g(^PAWARD(WardDR)),"^",1)_"@"_$p($g(^PAWARD(WardDR)),"^",2)
	}
  
	s BedNoDR=$p(^PAADM(rowid),"^",73)
	i (BedNoDR'="")    ; 取床号
	{
		s wardrowid=$p(BedNoDR,"||",1)
		s bedchildsub=$p(BedNoDR,"||",2)
		s obj.BedNo=$p($g(^PAWARD(wardrowid,"BED",bedchildsub)),"^",1)
	}
	s obj.Diagnose=##class(DHCENS.Method.BaseMethod).GetMRAdmDiagnosis(rowid)	
    
	Quit obj
}

}
