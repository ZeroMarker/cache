Import SQLUser

Class web.DHCMedInfConfigCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 5;

ClassMethod GetBaseConfig(data)
{
				n (data)
				Set Config=##Class(websys.Configuration).%OpenId(1)
			    Set MEDDATA=Config.DataNamespace
			    Set LABDATA=Config.LabDataNamespace
			    Set CurrentNS=$ZNSPACE
			    d Config.%Close()
				zn MEDDATA
			    s s=$$GetBaseConfig^DHCMedInfConfig(data)
			    zn CurrentNS
			    q s
}

}
