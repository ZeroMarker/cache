Import SQLUser

/// by wuqk 2007-11
/// For  Medcare OPAdmLog
Class web.DHCMedAdmLogCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 9;

ClassMethod UpdateAdmStatus(str)
{
	n (str)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s ret=$$UpdateAdmStatus^DHCMedAdmLog(str)
	zn CurrentNS
	q ret
}

ClassMethod UpdateAdmLog(str)
{
	n (str)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s ret=$$UpdateAdmLog^DHCMedAdmLog(str)
	zn CurrentNS
	q ret
}

ClassMethod GetLogById(Rowid)
{
	n (Rowid)
	s ret=""
	q:'$d(^DHCMEDADMLOG(Rowid)) ret
	s ret=$g(^DHCMEDADMLOG(Rowid))
	s ret=Rowid_"^"_ret
	q ret
}

/// 根据paadm取就诊轨迹
ClassMethod GetLinByAdm(paadm)
{
}

}
