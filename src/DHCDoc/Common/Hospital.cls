/// Creator:tanjishan
/// CreateDate:2020.05.13
/// Description:多院区配置及应用的派生类,用于处理医生站产品线中所有与多院区内容关联的程序逻辑
Class DHCDoc.Common.Hospital Extends web.DHCBL.BDP.BDPMappingHOSP [ ClassType = "", ProcedureBlock ]
{

/// Description:判断A医院是否有权显示表里某一条数据
/// Input:tableName(表名称，格式如ARC_ItemCat),dataid(对应表数据RowID,如 医嘱子分类rowid 12)，HospID（A医院rowid)
/// Output:Y/N
/// s flag =##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItemCat",12,2,"2020-05-07")
ClassMethod GetHospShowDataFlag(tableName As %String, dataid As %String, HospID As %String, date As %String = "") As %String
{
	q ##super(tableName, dataid , HospID, date)
}

/// Function:保存关联关系
/// input:BDPMPHTableName(表名称,如ARC_ItemCat)/BDPMPHDataReference(对应表数据RowID如 医嘱子分类rowid 12)/BDPMPHHospital(关联的医院,医院rowid 2) 
/// Debug： w ##class(DHCDoc.Common.Hospital).SaveHOSP("ARC_ItemCat",12,2)
ClassMethod SaveHOSP(BDPMPHTableName As %String, BDPMPHDataReference As %String, BDPMPHHospital As %String) As %String
{
	q ##super(BDPMPHTableName, BDPMPHDataReference, BDPMPHHospital)
}

/// Description：根据表名、业务数据中的医院、日期取要取哪个医院的配置，返回医院id
/// Table：User.BDPTableList,User.BDPExceptionHosp
/// Input：tableName表名	HospID医院DR	date日期
/// Output: 医院rowid
/// Others：w ##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("PAC_AdmReason","3","2020-05-07")
ClassMethod GetDefHospIdByTableName(tableName As %String, HospID As %String, date As %String = "") As %String
{
	s HospID=..GetCurrentSYSHospitalId(HospID)
	q ##super(tableName, HospID, date)
}

/// Function: 删除表里某条数据时，删除跟他所有关联医院关系
/// input:表名称(BDPMPHTableName，如ARC_ItemCat)/对应表数据RowID(BDPMPHDataReference,如 医嘱子分类rowid 12)
/// debug:    w ##class(DHCDoc.Common.Hospital).DeleteHospitals("CT_SocialStatus",31)
ClassMethod DeleteHospitals(BDPMPHTableName As %String, BDPMPHDataReference As %String) As %String
{
	q ##super(BDPMPHTableName, BDPMPHDataReference)
}

/// Function: 删除整张表时，删除跟他所有关联医院关系
/// input:表名称(BDPMPHTableName，如ARC_ItemCat)
/// debug:    w ##class(DHCDoc.Common.Hospital).DeleteTableHospitals("CT_SocialStatus")
ClassMethod DeleteTableHospitals(BDPMPHTableName As %String) As %String
{
	q ##super(BDPMPHTableName)
}

/// 获取登录医院id
/// debug:    w ##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId()
ClassMethod GetCurrentSYSHospitalId(HospitalId As %String) As %String
{
	i ($g(HospitalId)="")&&($d(%session)) s HospitalId=%session.Get("LOGON.HOSPID")
	Q HospitalId
}

/// 获取登录医院代码
/// debug:    w ##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalCode()
ClassMethod GetCurrentSYSHospitalCode(HospitalId As %String) As %String
{
	s HospitalId=..GetCurrentSYSHospitalId(HospitalId)
	s HospitalCode=""
	i HospitalId'="" s HospitalCode=$p($g(^CT("HOSP",HospitalId)),"^",1)
	Q HospitalCode
}

/// 获取就诊医院ID
/// debug:    w ##class(DHCDoc.Common.Hospital).GetAdmHospitalId()
ClassMethod GetAdmHospitalId(AdmDr As %String) As %String
{
	s HospitalId=""
	q:(AdmDr="") HospitalId
	s EpLoc=$P(^PAADM(AdmDr),"^",4)
	s HospitalId=..GetLocHospitalId(EpLoc)
	q HospitalId
}

/// 获取就诊医院ID
/// debug:    w ##class(DHCDoc.Common.Hospital).GetLocHospitalId()
ClassMethod GetLocHospitalId(LocID As %String) As %String
{
	s HospitalId=""
	q:(LocID="") HospitalId
	s HospitalId=$P(^CTLOC(LocID),"^",22)
	q HospitalId
}

/// Creator：	lixu
/// CreateDate：2021.05.18
/// Description:  根据就诊、科室、用户、出诊记录、医嘱 得到所属医院ID
/// Return:       所属医院的Rowid
/// debug: 		  w ##class(DHCDoc.Common.Hospital).GetAffiliatedHospitalId(112)
ClassMethod GetAffiliatedHospitalId(EpisodeID = "", CTLocId = "", UserId = "", ASRowId = "", OrderId = "") As %String
{
	q:(EpisodeID_CTLocId_UserId_ASRowId_OrderId)="" ""
	
	s HospId="",HospCode=""
	;优先判断级别:就诊,科室,用户,出诊记录,医嘱ID
	i EpisodeID'="" {
		s AdmDepId=$p(^PAADM(EpisodeID),"^",4)
		s HospId=$p(^CTLOC(AdmDepId),"^",22)
		q:HospId'="" HospId
	}
	i CTLocId'="" {
		s HospId=$p(^CTLOC(CTLocId),"^",22)
		q:HospId'="" HospId
	}
	i UserId'="" {
		s HospId=$p($g(^SSU("SSUSR",UserId)),"^",98)
		q:HospId'="" HospId
	}
	i ASRowId'="" {
		s CTLocId=$p($g(^RB("RES",+ASRowId)),"^",1)
		s HospId=$p(^CTLOC(CTLocId),"^",22)
		q:HospId'="" HospId
	}
	i OrderId'="" {
		s EpisodeID=$p(^OEORD(+OrderId),"^",1)
		i EpisodeID'=""{
			s AdmDepId=$p(^PAADM(EpisodeID),"^",4)
			s HospId=$p(^CTLOC(AdmDepId),"^",22)
			q:HospId'="" HospId
		}
	}
	q HospId
}

/// 获取多院区业务 按科室的配置
/// 入参：登录园区，科室ID
/// 出参：Y允许N不允许
/// debug: w ##class(DHCDoc.Common.Hospital).GetMultiHospConfigLoc(2,1)
ClassMethod GetMultiHospConfigLoc(LogHospId, LocID)
{
	s DepHosStr=##class(web.DHCBL.CT.BDPHospitalServiceConfig).GetMultiHospConfig(LogHospId,"OPReg")
	k HospFlagArr
	if ($P(DepHosStr,"#",1)="Y"){
		s DepHosStrNext=$P(DepHosStr,"#",2)
		for i=1:1:$L(DepHosStrNext,"&"){
			s OneDepHosStr=$P(DepHosStrNext,"&",i)
			Continue:OneDepHosStr=""
			s DepHospID=$P(OneDepHosStr,"^",2)
			s DepLocStr=$P($P(OneDepHosStr,"^",3),":",2)
			s HospFlagArr(DepHospID)=DepLocStr
			}
	}
	s DepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(LocID)
	if LogHospId=DepHosDr q "Y"
	if '$d(HospFlagArr(DepHosDr)) q "N"
	if (HospFlagArr(DepHosDr)="") q "Y"
	if (("!"_HospFlagArr(DepHosDr)_"!")[("!"_myrowid_"!")) q "Y"
	q "N"
}

}
