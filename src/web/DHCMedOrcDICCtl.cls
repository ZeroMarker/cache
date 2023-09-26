Import SQLUser

/// HIS字典中的手术操作字典
Class web.DHCMedOrcDICCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 4;

ClassMethod GetORCOperByAlias(MyAlias, dDate)
{
	n (MyAlias,dDate)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    s ret=""
    zn MEDDATA
	s ret= $$QueryORCOper^DHCMedOrcDic(MyAlias,dDate)
	
	zn CurrentNS
	q ret
}

}
