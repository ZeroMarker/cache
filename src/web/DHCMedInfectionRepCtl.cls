Import SQLUser

Class web.DHCMedInfectionRepCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 68;

ClassMethod UpdateInfRep(Instring)
{
    n (Instring)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$UpdateInfRep^DHCMedInfectionRep(Instring)
	zn CurrentNS
    q ret
}

ClassMethod CheckInfRep(MIRRowid, Status, CheckUsr, CheckDate, CheckTime, Demo)
{
    n (MIRRowid, Status, CheckUsr, CheckDate, CheckTime, Demo)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$CheckInfRep^DHCMedInfectionRep(MIRRowid,Status,CheckUsr,CheckDate,CheckTime,Demo)
	zn CurrentNS
    q ret
}

ClassMethod DeleteInfRep(MIRRowid, Status, UsrName, CheckDate, CheckTime, Demo)
{
    n (MIRRowid,Status,UsrName,CheckDate,CheckTime,Demo)
    //s CheckDate=$zdh(CheckDate,3)
    //s CheckTime=$zth(CheckTime)
    s delRes="删除原因 "_Demo_";"_CheckDate_";"_UsrName
    &sql(update DHC_MedInfectionRep set MIR_Status=:Status,MIR_Demo=:delRes where MIR_Rowid=:MIRRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod UpdateInfRepDia(Instring)
{
    n (Instring)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$UpdateInfRepDia^DHCMedInfectionRep(Instring)
	zn CurrentNS
    q ret
}

ClassMethod DeleteInfRepDia(MIRMRRowid)
{
    n (MIRMRRowid)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$DeleteInfRepDia^DHCMedInfectionRep(MIRMRRowid)
	zn CurrentNS
    q ret
}

ClassMethod UpdateInfRepOPR(Instring)
{
    n (Instring)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$UpdateInfRepOPR^DHCMedInfectionRep(Instring)
	zn CurrentNS
    q ret
}

ClassMethod DeleteInfRepOPR(MIRMRRowid)
{
    n (MIRMRRowid)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$DeleteInfRepOPR^DHCMedInfectionRep(MIRMRRowid)
	zn CurrentNS
    q ret
}

ClassMethod UpdateInfRepRea(Instring)
{
    n (Instring)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$UpdateInfRepRea^DHCMedInfectionRep(Instring)
	zn CurrentNS
    q ret
}

ClassMethod DeleteInfRepRea(MIRMRRowid)
{
    n (MIRMRRowid)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$DeleteInfRepRea^DHCMedInfectionRep(MIRMRRowid)
	zn CurrentNS
    q ret
}

ClassMethod UpdateInfRepPos(Instring)
{
    n (Instring)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$UpdateInfRepPos^DHCMedInfectionRep(Instring)
	zn CurrentNS
    q ret
}

ClassMethod DeleteInfRepPos(MIRMRRowid)
{
    n (MIRMRRowid)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$DeleteInfRepPos^DHCMedInfectionRep(MIRMRRowid)
	zn CurrentNS
    q ret
}

ClassMethod UpdateInfRepDrug(Instring)
{
    n (Instring)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$UpdateInfRepDrug^DHCMedInfectionRep(Instring)
	zn CurrentNS
    q ret
}

ClassMethod DeleteInfRepDrug(MIRMRRowid)
{
    n (MIRMRRowid)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$DeleteInfRepDrug^DHCMedInfectionRep(MIRMRRowid)
	zn CurrentNS
    q ret
}

ClassMethod UpdateInfPathogeny(Instring)
{
    n (Instring)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$UpdateInfPathogeny^DHCMedInfectionRep(Instring)
	zn CurrentNS
    q ret
}

ClassMethod DeleteInfPathogeny(MIRMRRowid)
{
    n (MIRMRRowid)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$DeleteInfPathogeny^DHCMedInfectionRep(MIRMRRowid)
	zn CurrentNS
    q ret
}

ClassMethod UpdateInfPyObj(Instring)
{
    n (Instring)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$UpdateInfPyObj^DHCMedInfectionRep(Instring)
	zn CurrentNS
    q ret
}

ClassMethod DeleteInfPyObj(MIRMRRowid)
{
    n (MIRMRRowid)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$DeleteInfPyObj^DHCMedInfectionRep(MIRMRRowid)
	zn CurrentNS
    q ret
}

ClassMethod UpdateInfPyObjDrug(Instring)
{
    n (Instring)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$UpdateInfPyObjDrug^DHCMedInfectionRep(Instring)
	zn CurrentNS
    q ret
}

ClassMethod DeleteInfPyObjDrug(MIRMRRowid)
{
    n (MIRMRRowid)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$DeleteInfPyObjDrug^DHCMedInfectionRep(MIRMRRowid)
	zn CurrentNS
    q ret
}

ClassMethod DeleteInfReportSub(MIRMRRowid)
{
    n (MIRMRRowid)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	w !,$$DeleteAllInfRepDia^DHCMedInfectionRep(MIRMRRowid)
	w !,$$DeleteAllInfRepOPR^DHCMedInfectionRep(MIRMRRowid)
	w !,$$DeleteAllInfRepRea^DHCMedInfectionRep(MIRMRRowid)
	w !,$$DeleteAllInfRepPos^DHCMedInfectionRep(MIRMRRowid)
	w !,$$DeleteAllInfRepDrug^DHCMedInfectionRep(MIRMRRowid)
	w !,$$DeleteAllInfPathogeny^DHCMedInfectionRep(MIRMRRowid)
	w !,$$DeleteAllInfPyObj^DHCMedInfectionRep(MIRMRRowid)
	w !,$$DeleteAllInfPyObjDrug^DHCMedInfectionRep(MIRMRRowid)
	zn CurrentNS
    q "^_^"
}

ClassMethod SaveInfectionRep(MainStr, DiaStr, ReaStr, InfStr, OpeStr, LabStr, DrugStr, GermStr, SenStr)
{
    n (MainStr, DiaStr, ReaStr, InfStr, OpeStr, LabStr, DrugStr, GermStr, SenStr)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret="",len="",tmp="",flag="",r="1"
	s MIRMRRowid = $p(MainStr,"^",1)
	;w !,1
	if (MIRMRRowid '= ""){
		s ret=$$DeleteAllInfRepDia^DHCMedInfectionRep(MIRMRRowid)
		s ret=$$DeleteAllInfRepOPR^DHCMedInfectionRep(MIRMRRowid)
		s ret=$$DeleteAllInfRepRea^DHCMedInfectionRep(MIRMRRowid)
		s ret=$$DeleteAllInfRepPos^DHCMedInfectionRep(MIRMRRowid)
		s ret=$$DeleteAllInfRepDrug^DHCMedInfectionRep(MIRMRRowid)
		s ret=$$DeleteAllInfPyObjDrug^DHCMedInfectionRep(MIRMRRowid)
		s ret=$$DeleteAllInfPyObj^DHCMedInfectionRep(MIRMRRowid)		
		s ret=$$DeleteAllInfPathogeny^DHCMedInfectionRep(MIRMRRowid)
	}
	;w !,2
	s MIRMRRowid=$$UpdateInfRep^DHCMedInfectionRep(MainStr)
	
	
	;w !,3
	//诊断
	s len=$l(DiaStr,$c(1))
	f index=1:1:len  d
	.i $p(DiaStr,$c(1),index)'=""  d
	..s flag=$$UpdateInfRepDia^DHCMedInfectionRep(MIRMRRowid_$p(DiaStr,$c(1),index))
	
	;w !,4
	//手术
	s len=$l(OpeStr,$c(1))
	f index=1:1:len  d
	.i $p(OpeStr,$c(1),index)'="" d
	..s flag=$$UpdateInfRepOPR^DHCMedInfectionRep(MIRMRRowid_$p(OpeStr,$c(1),index))	
	
	;w !,5
	//抗菌素
	s len=$l(DrugStr,$c(1))
	f index=1:1:len  d
	.i $p(DrugStr,$c(1),index)'="" d
	..s flag=$$UpdateInfRepDrug^DHCMedInfectionRep(MIRMRRowid_$p(DrugStr,$c(1),index))	

	;w !,6
	//感染
	//
	s len=$l(InfStr,$c(1))
	f index=1:1:len  d
	.i $p(InfStr,$c(1),index)'=""  d
	..s flag=$$UpdateInfRepPos^DHCMedInfectionRep(MIRMRRowid_$p(InfStr,$c(1),index))	

	;w !,7
	//易感因素
	s len=$l(ReaStr,$c(1))
	f index=1:1:len  d
	.i $p(ReaStr,$c(1),index)'="" d
	..s flag=$$UpdateInfRepRea^DHCMedInfectionRep(MIRMRRowid_$p(ReaStr,$c(1),index))	

	;w !,8
	//辅助检查
	//Lab_$c(1)_Lab_$c(1)_Lab
	//Lab =LabCheck_$c(2)_ Germ_$c(3)_Germ
	//Germ = GermObj_$(4)_DrugSen__$c(5)_DrugSen
	s strLabstr="",strLabRowID="",strGermRowID=""
	s strGerm="", strDrug="",strTmp=""
	
	
	s len=$l(LabStr,$c(1))
	f index=1:1:len  d
	.s strLabstr = $p(LabStr,$c(1),index)
	.s LabCheck=$p(strLabstr,$c(2),1)
	.i LabCheck'=""  d
	..s strLabRowID=$$UpdateInfPathogeny^DHCMedInfectionRep(MIRMRRowid_LabCheck)	
	.s GermStr=$p(strLabstr,$c(2),2)
	.s lenGerm=$l(GermStr,$c(3))
	.f indexGerm=1:1:lenGerm  d
	..s GermItem=$p(GermStr,$c(3),indexGerm)
	..s Germ=$p(GermItem,$c(4),1)
	..i Germ'=""  d
	...s strGermRowID=$$UpdateInfPyObj^DHCMedInfectionRep(strLabRowID_Germ)
	..s DrugStr=$p(GermItem,$c(4),2)
	..s lenDrug=$l(DrugStr,$c(5))
	..f indexDrug=1:1:lenDrug  d
	...s Drug=$p(DrugStr,$c(5),indexDrug)
	...i Drug'=""  d
	....s strDrugRowID=$$UpdateInfPyObjDrug^DHCMedInfectionRep(strGermRowID_Drug)
	
	zn CurrentNS
    q MIRMRRowid
}

ClassMethod GetInfRep(RowID)
{
    n (RowID)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$GetInfRep^DHCMedInfectionRep(RowID)
	zn CurrentNS
    q ret
}

ClassMethod GetInfRepDia(RefRowID)
{
    n (RefRowID)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$GetInfRepDia^DHCMedInfectionRep(RefRowID)
	zn CurrentNS
    q ret
}

ClassMethod GetInfRepOPR(RefRowID)
{
    n (RefRowID)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$GetInfRepOPR^DHCMedInfectionRep(RefRowID)
	zn CurrentNS
    q ret
}

ClassMethod GetInfRepRea(RefRowID)
{
    n (RefRowID)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$GetInfRepRea^DHCMedInfectionRep(RefRowID)
	zn CurrentNS
    q ret
}

ClassMethod GetInfRepPos(RefRowID)
{
    n (RefRowID)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$GetInfRepPos^DHCMedInfectionRep(RefRowID)
	zn CurrentNS
    q ret
}

ClassMethod GetInfRepDrug(RefRowID)
{
    n (RefRowID)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$GetInfRepDrug^DHCMedInfectionRep(RefRowID)
	zn CurrentNS
    q ret
}

ClassMethod GetInfRepPathogeny(RefRowID)
{
    n (RefRowID)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$GetInfRepPathogeny^DHCMedInfectionRep(RefRowID)
	zn CurrentNS
    q ret
}

ClassMethod GetInfRepPyObj(RefRowID)
{
    n (RefRowID)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$GetInfRepPyObj^DHCMedInfectionRep(RefRowID)
	zn CurrentNS
    q ret
}

ClassMethod GetInfRepPyObjDrug(RefRowID)
{
    n (RefRowID)
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$GetInfRepPyObjDrug^DHCMedInfectionRep(RefRowID)
	zn CurrentNS
    q ret
}

}
