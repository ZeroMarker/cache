Import SQLUser

Class web.DHCMedInfDiagnoseCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

//Modified By LiYang 2008-12-3

//alias:查询条件

//Type：类型HIS：HIS系统字典  InfectionSys院内感染系统自带字典

ClassMethod QueryByAlias(alias, Type)
{
		n (alias,Type)
		Set Config=##Class(websys.Configuration).%OpenId(1)
		Set MEDDATA=Config.DataNamespace
		Set LABDATA=Config.LabDataNamespace
		Set CurrentNS=$ZNSPACE
		d Config.%Close()
		zn MEDDATA
		s ret=""
		s tmp=""
		s MPOSRowid=0,i=0
		s pid=$$QueryByAlias^DHCMedInfDiagnose(alias,Type)
		f  s tmp=$$fetchByAlias^DHCMedInfDiagnose(pid,Type) q:tmp=""  do
		.s ret=ret_tmp
		zn CurrentNS
		q ret
}

ClassMethod fetchByAlias(flag)
{
		Set Config=##Class(websys.Configuration).%OpenId(1)
		Set MEDDATA=Config.DataNamespace
		Set LABDATA=Config.LabDataNamespace
		Set CurrentNS=$ZNSPACE
		d Config.%Close()
		zn MEDDATA
		s s=$$fetchByAlias^DHCMedInfDiagnose(flag)
		zn CurrentNS
		q s
}

/// w ##Class(web.DHCMedInfDiagnoseCtl).QueryInfDia(2)
ClassMethod QueryInfDia(PosRowid)
{
	n (PosRowid)
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set LABDATA=Config.LabDataNamespace
	Set CurrentNS=$ZNSPACE
	d Config.%Close()
	zn MEDDATA
	s tmp="",ret=""
	s MPOSRowid=0,i=0
	s pid=$$QueryInfDia^DHCMedInfDiagnose(PosRowid)
	f  s tmp=$$GetInfDia^DHCMedInfDiagnose(pid) q:tmp=""  do
	.s ret=ret_tmp
	zn CurrentNS
	q ret
}

ClassMethod GetInfDia(flag)
{
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set LABDATA=Config.LabDataNamespace
	Set CurrentNS=$ZNSPACE
	d Config.%Close()
	zn MEDDATA
	s s=$$GetInfDia^DHCMedInfDiagnose(flag)
	zn CurrentNS
	q s
}

}
