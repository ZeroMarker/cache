Class web.DHCPE.Occu.ReportData Extends %RegisteredObject
{

/// w ##class(web.DHCPE.Occu.ReportData).GetOccuReport(3807,"PAADM")
ClassMethod GetOccuReport(Id, Type, OutFlag = "")
{
	q:((Id="")||(Type="")) $case(OutFlag,"obj":{},:"{}")
	s PAADM=""
	if Type="PreIADM" {
		s IADM=$o(^DHCPEIADM(0,"CRMADM",Id,0))
		q:IADM="" ""
		s PAADM=$p($g(^DHCPEIADM(IADM)),"^",1)
	} elseif Type="IADM" {
		s PAADM=$p($g(^DHCPEIADM(Id)),"^",1)
	} else {
		s PAADM=Id
	}
	q:PAADM="" $case(OutFlag,"obj":{},:"{}")
	q:'$d(^PAADM(PAADM)) $case(OutFlag,"obj":{},:"{}")
	
	s IADM=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:IADM="" $case(OutFlag,"obj":{},:"{}")
	s PreIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
	q:PreIADM="" $case(OutFlag,"obj":{},:"{}")
	s PreIBI=$p($g(^DHCPEPreIADM(PreIADM)),"^",1)
	q:PreIBI="" $case(OutFlag,"obj":{},:"{}")

	s LocID=$p(^PAADM(PAADM),"^",4)
	s VIPLevel=$p($g(^DHCPEPreIADM(PreIADM)),"^",18)
	s VIPTemplateName=$p($g(^DHCPEVIPLevel("VIP",VIPLevel)),"^",6)  // 取VIP等级中维护的模板名称
	
	s reportInfo = {}
	s clsObj = ##class(web.DHCPE.Occu.ReportData).%New()
	d clsObj.getBaseInfo(PreIBI, .reportInfo)
	d clsObj.getBusinessInfoByPaadm(PAADM, .reportInfo)
	d clsObj.getChecksInfoByPaadm(PAADM, .reportInfo)

	s other = {}
	s OthCodes="FIXED"
	f tem=1:1:$l(OthCodes,"^") d
	.s OthCode=$p(OthCodes,"^",tem)
	.q:OthCode=""
	.s BaseDr=$o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_LocID, " REPORTDATA", " "_OthCode, 0))
	.s RSRowId=0
	.f  s RSRowId=$o(^User.DHCPEReportSettingI("IdxLocBeseDR", " "_LocID, " "_BaseDr, RSRowId)) q:RSRowId=""  d
	..s RSCode=$lg(^User.DHCPEReportSettingD(RSRowId),2)
	..s RSValue=$lg(^User.DHCPEReportSettingD(RSRowId),8)
	..d other.%Set(RSCode, RSValue)
	d reportInfo.%Set("other", other)

	q $case(OutFlag,"obj":reportInfo,:reportInfo.%ToJSON())
}

/// 基本信息
Method getBaseInfo(preIBaseInfo, reportArr As %Library.DynamicObject)
{
	s CurData=$g(^DHCPEPreIBI(preIBaseInfo))
	q:CurData=""
	
	s RegNo=$p(CurData,"^",1)  // 登记号
	d reportArr.%Set("RegNo", RegNo)
	
	s Name=$p(CurData,"^",2)  // 姓名
	d reportArr.%Set("Name", Name)
	
	s Sex=$p(CurData,"^",3)  // 性别
	s:(""'=Sex) Sex=$p(^CT("SEX",Sex),"^",2)
	d reportArr.%Set("Sex", Sex)
	
	s Dob=$p(CurData,"^",4),Age=""  // 出生日期 年龄
	s:(""'=Dob) Age=##class(web.DHCLCNUREXCUTE).CalAge(Dob, +$h)
	s Age=$p(Age,"Y")
	d reportArr.%Set("Age", Age)
 	i Dob'="" s Dob=$zd(Dob,3)
	d reportArr.%Set("Dob", Dob)
	
	
	s PatType=$p(CurData,"^",5)  // 客户类型
	d reportArr.%Set("PatType", PatType)
	
	
	s Tel=$p(CurData,"^",8) // 联系电话
 	s:Tel="" Tel=$p(CurData,"^",6)
 	s:Tel="" Tel=$p(CurData,"^",7)
	d reportArr.%Set("Tel", Tel)
	
	s IDCard=$p(CurData,"^",9)  // 身份证号
	d reportArr.%Set("IDCard", IDCard)
	
	s Vocation=$p(CurData,"^",10)  // 职业
	d reportArr.%Set("Vocation", Vocation)

	s Position=$p(CurData,"^",11)  // 职位 部门
	d reportArr.%Set("Position", Position)
 	
 	// 工作单位
 	s Company=$p(CurData,"^",12)
	d reportArr.%Set("Company", Company)
	
 	s Postalcode=$p(CurData,"^",13)  // 邮编
	d reportArr.%Set("Postalcode", Postalcode)
 	
 	s Address=$p(CurData,"^",14)  // 地址
	d reportArr.%Set("Address", Address)
 	
	s Nation=$p(CurData,"^",15)  // 民族
	d reportArr.%Set("Nation", Nation)
 	
	s Email=$p(CurData,"^",16)  // 电子邮件
	d reportArr.%Set("Email", Email)
 	
	s Married=$p(CurData,"^",17)  // 婚姻状况
	s:Married'="" Married=$p($g(^CT("MAR",Married)),"^",2)
	d reportArr.%Set("Married", Married)
  	
	s BloodDR=$p(CurData,"^",18)  // 血型
	d reportArr.%Set("BloodDR", BloodDR)
}

/// 业务信息
Method getBusinessInfoByPaadm(paadm, reportArr As %Library.DynamicObject)
{
	q:paadm=""
	
	s IADM=$o(^DHCPEIADM(0,"PAADM",paadm,0))
	q:IADM=""
	
	s PreIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
	q:PreIADM=""
	
	s DepLoc=$p($g(^DHCPEPreIADM(PreIADM)),"^",26)
	s HPNo=$p($g(^DHCPEPreIADM(PreIADM)),"^",27)  // 体检编号
	d reportArr.%Set("HPNo", HPNo)
	
	s VIPLevel=$p($g(^DHCPEPreIADM(PreIADM)),"^",18)  // VIP等级
	s:VIPLevel'="" VIPLevel=$p($g(^DHCPEVIPLevel("VIP",VIPLevel)),"^",2)
	d reportArr.%Set("VIPLevel", VIPLevel)
	
	s Department=$g(^DHCPEDataEx("DHCPEPreIADM","Position",PreIADM))  // 部门
	d reportArr.%Set("Department", Department)
	
	s GName=""
	s PreGADM=$p($g(^DHCPEPreIADM(PreIADM)),"^",2)
	i PreGADM'="" {
		s PreGBI=$p($g(^DHCPEPreGADM(PreGADM)),"^",1)
		s:PreGBI'="" GName=$p($g(^DHCPEPreGBI(PreGBI)),"^",2)
	}
	d:reportArr.Company="" reportArr.%Set("Company", GName)
	
	s ArrDate=$p($g(^DHCPEIADM(IADM)),"^",5)
	s:ArrDate'="" reportArr.ArrDate=$zd(ArrDate,3)  // 到达日期
	
	s occuInfo=##class(web.DHCPE.OccupationalDisease).GetPreOccuInfo(PreIADM)
	s occuJson={}.%FromJSON(occuInfo)
	if occuJson.code="0" {
		s reportArr.occuData=occuJson.msg
	    s HarmInfoData=##class(web.DHCPE.DHCPEOccuBaseEx).GetHarmInfoForReport(PreIADM)
	    s reportArr.HarmInfoData=HarmInfoData
	}
	
	// 总检信息
	s GSID=$o(^DHCPEGS(0,"IADM",IADM,0))
	i GSID'="" {
		// 项目小结
		s ItemSum=##class(web.DHCPE.GeneralSummarizeEx).OutConcResult(GSID,"",DepLoc)
		s ItemSum={}.%FromJSON(ItemSum)
		i ItemSum.code="0" {
			s ItemSumData={}.%FromJSON(ItemSum.data)
			d reportArr.%Set("ItemSum", ItemSumData.OCCUSUM)
		}
		
		set retJson=##class(web.DHCPE.GeneralSummarizeEx).GetGSExInfoNew(GSID,"OC","","Text")
		set conclusion="",suggestions=""
		if retJson.%Size()>0 {
			set num=0
			for tmpi=0:1:(retJson.%Size()-1) {
				set retObj=retJson.%Get(tmpi)
				set:conclusion'="" conclusion=conclusion_"、"_retObj.ConcDesc
				set:conclusion="" conclusion=retObj.ConcDesc
				
				set:suggestions'="" suggestions=suggestions_"、"_retObj.Suggestions
				set:suggestions="" suggestions=retObj.Suggestions
			}
		} else {
			s GSEXID=$o(^User.DHCPEGeneralSummarizeExI("GeneralSummarizeID",GSID,0))
			if GSEXID'="" {
				s conclusion=$lg(^User.DHCPEGeneralSummarizeExD(GSEXID),3)
				s:conclusion'="" conclusion=$lg(^User.DHCPEConclusionD(conclusion),3)
				s suggestions=$lg(^User.DHCPEGeneralSummarizeExD(GSEXID),6)
			}
		}
		d reportArr.%Set("Conclusion", conclusion)
		d reportArr.%Set("Suggestions", suggestions)
		set Evaluation=$p($g(^DHCPEGS(GSID,1)),"^",9)  // 适应性评价
		d reportArr.%Set("Evaluation", Evaluation)
		
		s GenDate=$p($g(^DHCPEGS(GSID,1)),"^",6)  // 总检日期
		i GenDate'="" d
		.s GenDate=$zd(GenDate,3)
		.d reportArr.%Set("GenDate", GenDate)
		.d reportArr.%Set("GenDateHTM", $p(GenDate,"-",1)_"年"_$p(GenDate,"-",2)_"月"_$p(GenDate,"-",3)_"日")
		e  d
		.d reportArr.%Set("GenDateHTM", "&ensp;&ensp;&ensp;&ensp;年&ensp;&ensp;月&ensp;&ensp;日")
		
		s GenDoc=$p($g(^DHCPEGS(GSID,1)),"^",5)  // 总检医生
		i GenDoc'="" d
		.s GenDoc=$p($g(^SSU("SSUSR",GenDoc)),"^",2)
		.d reportArr.%Set("GenDoc", GenDoc)
		
		// $P($g(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",paadm)),"^",1)
		s AudDate=$p($g(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",paadm)),"^",2)  // 复检日期
		i AudDate'="" d
		.s AudDate=$zd(AudDate,3)
		.d reportArr.%Set("AudDate", AudDate)
		.d reportArr.%Set("AudDateHTM", $p(AudDate,"-",1)_"年"_$p(AudDate,"-",2)_"月"_$p(AudDate,"-",3)_"日")
		e  d
		.d reportArr.%Set("AudDateHTM", "&ensp;&ensp;&ensp;&ensp;年&ensp;&ensp;月&ensp;&ensp;日")
		
		s AudDoc=$P($g(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",paadm)),"^",1)  // 复检医生
		i AudDoc'="" d
		.s AudDoc=$p($g(^SSU("SSUSR",AudDoc)),"^",2)
		.d reportArr.%Set("AudDoc", AudDoc)
	
		d reportArr.%Set("CAAduitUser", ##class(web.DHCPE.CA.Main).GetSignName(2,paadm))
		d reportArr.%Set("CAMainDoctor", ##class(web.DHCPE.CA.Main).GetSignName(3,paadm))
	}

	s reportId=$o(^DHCPERPT(0,"IADM",IADM,0))
	i reportId'="" {
		s RptDate=$p($g(^DHCPERPT(reportId)),"^",7)  // 报告日期
		i RptDate'="" d
		.s RptDate=$zd(RptDate,3)
		.d reportArr.%Set("RptDate", RptDate)
	}
}

/// 查询复查记录及对应结论
Method getChecksInfoByPaadm(paadm, reportArr As %Library.DynamicObject)
{
	q:paadm=""
	
	s IADM=$o(^DHCPEIADM(0,"PAADM",paadm,0))
	q:IADM=""
	
	s PreIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
	q:PreIADM=""
	
	s ChecksInfo=[]
	s retId=PreIADM
	f {
		s retId=##class(web.DHCPE.PreIADM).GetReviewRecord(retId,"","Original")
		q:retId=""
		
		s tGName=""
		s tPreGADM=$p($g(^DHCPEPreIADM(retId)),"^",2)
		i tPreGADM'="" {
			s tPreGBI=$p($g(^DHCPEPreGADM(tPreGADM)),"^",1)
			s:tPreGBI'="" tGName=$p($g(^DHCPEPreGBI(tPreGBI)),"^",2)
		}
		d:reportArr.Company="" reportArr.%Set("Company", tGName)
		;continue:$p($g(^DHCPEPreIADM(retId)),"^",28)'="Y"
		s retIADM=$o(^DHCPEIADM(0,"CRMADM",retId,0))
		continue:retIADM=""
		
		s retPAADM=$p($g(^DHCPEIADM(retIADM)),"^",1)
		continue:retPAADM=""
		s CheckInfo = {}
		s chkObj = ##class(web.DHCPE.Occu.ReportData).%New()
		d chkObj.getBusinessInfoByPaadm(retPAADM, .CheckInfo)
		d ChecksInfo.%Push(CheckInfo)
	}
	s reportArr.CheckInfo=ChecksInfo
}

}
