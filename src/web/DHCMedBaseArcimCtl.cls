Import SQLUser

Class web.DHCMedBaseArcimCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 9;

ClassMethod GetOrdsDrug(paadm, DrugFlag)
{
			n (paadm)
			Set Config=##Class(websys.Configuration).%OpenId(1)
		    Set MEDDATA=Config.DataNamespace
		    Set LABDATA=Config.LabDataNamespace
		    Set CurrentNS=$ZNSPACE
		    d Config.%Close()
			zn MEDDATA
		    s s=$$GetOrdsDrug^DHCMedBaseArcim(paadm,DrugFlag)
		    zn CurrentNS
		    q s
}

ClassMethod GetOrdsOper(paadm)
{
			n (paadm)
			Set Config=##Class(websys.Configuration).%OpenId(1)
		    Set MEDDATA=Config.DataNamespace
		    Set LABDATA=Config.LabDataNamespace
		    Set CurrentNS=$ZNSPACE
		    d Config.%Close()
			zn MEDDATA
		    ;s s=$$GetOrdsOper^DHCMedBaseArcim(paadm)
		    s s=$$GetOperationInfo^DHCMedBaseArcim(paadm)
		    zn CurrentNS
		    q s
}

ClassMethod GetOrdsLab(paadm)
{
			n (paadm)
			Set Config=##Class(websys.Configuration).%OpenId(1)
		    Set MEDDATA=Config.DataNamespace
		    Set LABDATA=Config.LabDataNamespace
		    Set CurrentNS=$ZNSPACE
		    d Config.%Close()
			zn MEDDATA
		    s s=$$GetOrdsLab^DHCMedBaseArcim(paadm)
		    zn CurrentNS
		    q s
}

ClassMethod GetOrdsDrugArcim(paadm, DrugFlag)
{
			n (paadm,DrugFlag)
			Set Config=##Class(websys.Configuration).%OpenId(1)
		    Set MEDDATA=Config.DataNamespace
		    Set LABDATA=Config.LabDataNamespace
		    Set CurrentNS=$ZNSPACE
		    d Config.%Close()
			zn MEDDATA
		    s s=$$GetOrdsDrugArcim^DHCMedBaseArcim(paadm,DrugFlag)
		    zn CurrentNS
		    q s
}

}
