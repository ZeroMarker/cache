Import SQLUser

Class web.DHCMedBasePaadmCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 9;

ClassMethod GetAdmInfo(paadm)
{
		n (paadm)
		Set Config=##Class(websys.Configuration).%OpenId(1)
	    Set MEDDATA=Config.DataNamespace
	    Set LABDATA=Config.LabDataNamespace
	    Set CurrentNS=$ZNSPACE
	    d Config.%Close()
		zn MEDDATA
	    s s=$$GetAdmInfo^DHCMedBasePaadm(paadm)
	    zn CurrentNS
	    q s
}

ClassMethod GetMrDiagnose(paadm)
{
		n (paadm)
		Set Config=##Class(websys.Configuration).%OpenId(1)
	    Set MEDDATA=Config.DataNamespace
	    Set LABDATA=Config.LabDataNamespace
	    Set CurrentNS=$ZNSPACE
	    d Config.%Close()
		zn MEDDATA
	    s s=$$GetMrDiagnose^DHCMedBasePaadm(paadm)
	    zn CurrentNS
	    q s
}

ClassMethod GetTemperatureTMP(paadm)
{
		n (paadm)
		Set Config=##Class(websys.Configuration).%OpenId(1)
	    Set MEDDATA=Config.DataNamespace
	    Set LABDATA=Config.LabDataNamespace
	    Set CurrentNS=$ZNSPACE
	    d Config.%Close()
		zn MEDDATA
	    s s=$$GetTemperatureTMP^DHCMedBasePaadm(paadm)
	    zn CurrentNS
	    q s
}

ClassMethod GetTemperature(paadm)
{
		n (paadm)
		Set Config=##Class(websys.Configuration).%OpenId(1)
	    Set MEDDATA=Config.DataNamespace
	    Set LABDATA=Config.LabDataNamespace
	    Set CurrentNS=$ZNSPACE
	    d Config.%Close()
		zn MEDDATA
	    s s=$$GetTemperature^DHCMedBasePaadm(paadm)
	    zn CurrentNS
	    q s
}

ClassMethod GetCurrPaadms(Ward)
{
		n (paadm)
		Set Config=##Class(websys.Configuration).%OpenId(1)
	    Set MEDDATA=Config.DataNamespace
	    Set LABDATA=Config.LabDataNamespace
	    Set CurrentNS=$ZNSPACE
	    d Config.%Close()
		zn MEDDATA
	    s s=$$GetCurrPaadms^DHCMedBasePaadm(Ward)
	    zn CurrentNS
	    q s
}

ClassMethod GetMic(TestSetRow)
{
		n (TestSetRow)
		Set Config=##Class(websys.Configuration).%OpenId(1)
	    Set MEDDATA=Config.DataNamespace
	    Set LABDATA=Config.LabDataNamespace
	    Set CurrentNS=$ZNSPACE
	    d Config.%Close()
		zn LABDATA
	    s s=$$GetMic^DHCMedInfection(TestSetRow)
	    zn CurrentNS
	    q s
}

}
