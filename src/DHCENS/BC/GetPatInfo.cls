Class DHCENS.BC.GetPatInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "GetPatInfoReturn";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

/// 医嘱号 
Property Rowid As %String(TRUNCATE = 1);

/// 病人类别
Property PatientType As %String(TRUNCATE = 1);

/// 费别 
Property FeeType As %String(TRUNCATE = 1);

/// 住院号	
Property InpatientNo As %String(TRUNCATE = 1);

/// 门诊号
Property OutpatientNo As %String(TRUNCATE = 1);

/// 姓名	 
Property Name As %String(TRUNCATE = 1);

/// 性别 
Property Sex As %String(TRUNCATE = 1);

/// 年龄	 
Property Age As %String(TRUNCATE = 1);

/// 婚姻 
Property Marry As %String(TRUNCATE = 1);

/// 地址
Property Address As %String(TRUNCATE = 1);

/// 电话 	 
Property Telephone As %String(TRUNCATE = 1);

/// 病区 	 
Property Ward As %String(TRUNCATE = 1);

/// 床号	 
Property BedNo As %String(TRUNCATE = 1);

/// 身份证号 	 
Property IDCard As %String(TRUNCATE = 1);

/// 民族	 
Property Nation As %String(TRUNCATE = 1);

/// 职业	 
Property Profession As %String(TRUNCATE = 1);

/// 送检医院	 
Property Hospital As %String(TRUNCATE = 1);

/// 送检科室	 
Property Loc As %String(TRUNCATE = 1);

/// 送检医生	 
Property Doctor As %String(TRUNCATE = 1);

/// 申请日期	 
Property ApplyDate As %String(TRUNCATE = 1);

/// 标本名称	 
Property SampleName As %String(TRUNCATE = 1);

/// 临床诊断	 
Property ClinicDiagnose As %String(TRUNCATE = 1);

/// 临床病史 	 
Property ClinicDisease As %String(TRUNCATE = 1);

/// 手术资料 	 
Property OperationInfo As %String(TRUNCATE = 1);

/// 其他信息	 
Property OtherInfo As %String(TRUNCATE = 1);

/// 就诊ID	
Property AdmDR As %String(TRUNCATE = 1);

/// 出生日期 	 
Property PAPMIDOB As %String(TRUNCATE = 1);

/// 医嘱名称	 
Property OrdName As %String(TRUNCATE = 1);

/// 登记号	 
Property RegNo As %String(TRUNCATE = 1);

/// 申请时间 	 
Property ApplyTime As %String(TRUNCATE = 1);

/// 身高	 
Property Height As %String(TRUNCATE = 1);

/// 体重	 
Property Weigth As %String(TRUNCATE = 1);

/// 病历号 	 
Property EPRno As %String(TRUNCATE = 1);

/// 医保号	 
Property ISUNo As %String(TRUNCATE = 1);

/// 执行科室	 
Property ExeLoc As %String(TRUNCATE = 1);

ClassMethod GetPatInfo(OrdID As %String) As %GlobalCharacterStream
{
	s obj=##class(DHCENS.BC.GetPatInfo).%New()
		
	s obj.Rowid=OrdID
	s OrdID=##class(DHCENS.Method.BaseMethod).ReplaceStr(OrdID,"_","||")
	s obj.FeeType=""
	s obj.AdmDR=$p($g(^OEORD(+OrdID)),"^",1)
	
	s PatientType=$p(^PAADM(obj.AdmDR),"^",2)
	i (PatientType="E")
	{
		s obj.PatientType="急诊"
	}
	i (PatientType="O")
	{
		s obj.PatientType="门诊"
	}
	i (PatientType="I")
	{
		s obj.PatientType="住院"
	}
	i (PatientType="H")
	{
		s obj.PatientType="体检"
	}
	i (PatientType="N")
	{
		s obj.PatientType="新生儿"
	}
	s PapatDr=$p($g(^PAADM(obj.AdmDR)),"^",1)
	if (PapatDr'="")
	{
		s obj.RegNo=$p($g(^PAPER(PapatDr,"PAT",1)),"^",1)
		s obj.InpatientNo=$p($g(^PAPER(PapatDr,"PAT",1)),"^",1)
		s obj.OutpatientNo=$p($g(^PAPER(PapatDr,"PAT",1)),"^",1)

		s obj.Name=$p($g(^PAPER(PapatDr,"ALL")),"^",1)
		s Dob=$p($g(^PAPER(PapatDr,"ALL")),"^",6)
		if (Dob'="")
		{
			s obj.Age=##class(DHCENS.Method.BaseMethod).GetAgeByPatid(PapatDr)
		}
		s SexDr=$p($g(^PAPER(PapatDr,"ALL")),"^",7)
		if (SexDr'="")
		{
			s obj.Sex=$p($g(^CT("SEX",SexDr)),"^",1)_"@"_$p($g(^CT("SEX",SexDr)),"^",2)
		}
		
		s obj.Address=$g(^PAPER(PapatDr,"PER","ADD",1))
		s obj.Telephone=$p($g(^PAPER(PapatDr,"PER",1)),"^",11)
		s obj.IDCard=$p($g(^PAPER(PapatDr,"ALL")),"^",9)     ; 身份证
		
		s NationDR=$p($g(^PAPER(PapatDr,"PER",2)),"^",1) 
 		i (NationDR'="")
 		{
	 		 s obj.Nation = $p($g(^CT("NAT",NationDR)),"^",2)
 		}
 		; 职业
 		s occuptiondr=$p($g(^PAPER(PapatDr,"PER",2)),"^",6)
		i (occuptiondr'="")
		{ 
			s obj.Profession=$p(^CT("OCC",occuptiondr),"^",2)
		}
		s obj.PAPMIDOB=$zd($p($g(^PAPER(PapatDr,"ALL")),"^",6),3)
	}
	s MrAdmDr=$p(^PAADM(obj.AdmDR),"^",61)
	i (MrAdmDr'="")
	{
	   	s obj.Height=$p($g(^MR(MrAdmDr,"PRO",1)),"^",20)
		s obj.Weigth=$p($g(^MR(MrAdmDr,"PRO",1)),"^",27)
	}
	s MartialID=$P($g(^PAADM(obj.AdmDR,1)),"^",1)
	i (MartialID'="")
	{
	s obj.Marry=$p(^CT("MAR",MartialID),"^",2) 
	}   
  	s WardDR=$p(^PAADM(obj.AdmDR),"^",70)
  	i (WardDR'="")
  	{
		s obj.Ward=$p($g(^PAWARD(WardDR)),"^",1)_"@"_$p($g(^PAWARD(WardDR)),"^",2)
	}
  
	s BedNoDR=$p(^PAADM(obj.AdmDR),"^",73)
	i (BedNoDR'="")    ; 取床号
	{
		s wardrowid=$p(BedNoDR,"||",1)
		s bedchildsub=$p(BedNoDR,"||",2)
		s obj.BedNo=$p($g(^PAWARD(wardrowid,"BED",bedchildsub)),"^",1)
	}
    ; 申请科室
 	s LocDR=$p(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1),"^",3)
 	i ($g(LocDR)'="")
 	{
	 	s obj.Loc=$p(^CTLOC(LocDR),"^",1)_"@"_$p(^CTLOC(LocDR),"^",2)
 	} 

	s DoctorDR=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1)),"^",11)
	i (DoctorDR'="")
	{
		s obj.Doctor=$p($g(^CTPCP(DoctorDR,1)),"^",1)_"@"_$p($g(^CTPCP(DoctorDR,1)),"^",2)
	}
    ;医嘱日期 OEORI_Date
    s date=$p(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1),"^",9)  
	s obj.ApplyDate=$zd(date,3)
	s ApplyTime=$p(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1),"^",10)   ;医嘱时间
	s obj.ApplyTime=$zt(ApplyTime)
	s exelocDr=$p(^OEORD(+OrdID,"I",$p(OrdID,"||",2),3),"^",6)   ; 获得执行科室
	s obj.ExeLoc=$P(^CTLOC(exelocDr),"^",1)_"@"_$P(^CTLOC(exelocDr),"^",2)
	s obj.Hospital=""
    s obj.OtherInfo=""   ;..GetAppItemInfo(OrdID)
	s arcimId=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1)),"^",2)
	s obj.OrdName=$p(^ARCIM($p(arcimId,"||",1),$p(arcimId,"||",2),1),"^",1)_"@"_$p(^ARCIM($p(arcimId,"||",1),$p(arcimId,"||",2),1),"^",2)
	; 标本名称
	s obj.SampleName=""
	s obj.OperationInfo=""
	s obj.ClinicDiagnose=##class(DHCENS.Method.BaseMethod).GetMRAdmDiagnosis(obj.AdmDR)
	s obj.ClinicDisease=""
	s obj.EPRno=""
	s obj.ISUNo=""
	s obj.ResultCode="0"
	s obj.ResultContent="成功"
	d obj.XMLExportToStream(.Xml)
	s objStream=##class(%GlobalCharacterStream).%New()
    d objStream.Write("<Response>")
    d objStream.CopyFrom(Xml)
    d objStream.Write("</Response>")
	q objStream
}

/*ClassMethod GetAppItemInfo(OeOrditemID As %String) As %String
{
	
	s BodyDesc=""
	s ARCIMRowId=$p($g(^OEORD(+OeOrditemID,"I",$P(OeOrditemID,"||",2),1)),"^",2)
	s RisBodyRowid=$o(^DHCRISBODY("ARCIM",ARCIMRowId,""),-1)
	q:RisBodyRowid="" ""
	s BodyDesc=$P(^DHCRISBODY(RisBodyRowid),"^",3)
	q BodyDesc
}
*/
}
