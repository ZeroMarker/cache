Import SQLUser

Class web.DHCMedInfDictionaryCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 13;

ClassMethod QueryAntiDic(Code, Desc, Active)
{
	n (Code,Desc,Active)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    s ret=""
    d Config.%Close()
	zn MEDDATA
	s PID=$p($$QueryAntiDic^DHCMedInfDictionary(Code,Desc,Active),"^",2)
	zn CurrentNS
    q PID
}

ClassMethod GetAntiDicList(Rowid, JIndex)
{
	n (Rowid, JIndex)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    s ret=""
    d Config.%Close()
	zn MEDDATA
	s ret=$$GetAntiDicList^DHCMedInfDictionary(Rowid,JIndex)
	zn CurrentNS
    q ret
}

ClassMethod QueryPathogenDic(Code, Desc, Active)
{
	n (Code,Desc,Active)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    s ret=""
    d Config.%Close()
	zn MEDDATA
	s PID=$p($$QueryPathogenDic^DHCMedInfDictionary(Code,Desc,Active),"^",2)
	zn CurrentNS
    q PID
}

ClassMethod GetPathogenDicList(Rowid, JIndex)
{
	n (Rowid, JIndex)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    s ret=""
    d Config.%Close()
	zn MEDDATA
	s ret=$$GetPathogenDicList^DHCMedInfDictionary(Rowid,JIndex)
	zn CurrentNS
    q ret
}

ClassMethod QueryAntiDicByPy(Code, Type, Active)
{
	n (Code,Type,Active)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    s ret=""
    d Config.%Close()
	zn MEDDATA
	s PID=$p($$QueryAntiDicByPy^DHCMedInfDictionary(Code,Type,Active),"^",2)
	zn CurrentNS
    q PID
}

ClassMethod GetAntiDicByPyList(Rowid, JIndex)
{
	n (Rowid, JIndex)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    s ret=""
    d Config.%Close()
	zn MEDDATA
	s ret=$$GetAntiDicByPyList^DHCMedInfDictionary(Rowid,JIndex)
	zn CurrentNS
    q ret
}

}
