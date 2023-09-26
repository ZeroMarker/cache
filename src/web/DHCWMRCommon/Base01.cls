Import SQLUser

Class web.DHCWMRCommon.Base01 Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 20;

/// w ##Class(web.DHCWMRCommon.Base01).RegNoCon(RegNo)
ClassMethod RegNoCon(RegNo)
{
	n (RegNo)
	s ret=""
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s ret=$$RegNoCon^DHCWMRMedBase02(RegNo)
	zn CurrentNS
	q ret
}

}
