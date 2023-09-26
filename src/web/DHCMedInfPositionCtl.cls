Import SQLUser

/// 院内感染部位维护
/// 
Class web.DHCMedInfPositionCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 6;

ClassMethod QueryInfectionPosition(flag)
{
		n (flag)
		Set Config=##Class(websys.Configuration).%OpenId(1)
		Set MEDDATA=Config.DataNamespace
		Set LABDATA=Config.LabDataNamespace
		Set CurrentNS=$ZNSPACE
		d Config.%Close()
		zn MEDDATA
		s s=""
		s MPOSRowid=0,i=0
		s s=s_$$fetch^DHCMedInfPosition(flag)
		zn CurrentNS
		q s
}

}
