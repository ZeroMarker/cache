Import sqluser

/// 描述：字典对照
Class web.DHCMedContrastData Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 48;

/// 描述：		调用程序后让民科医嘱抗生素和HIS里抗生素描述对照
///         	完全相同则在DHC_MedInfAntiContrast中插入记录
/// 编写者： 	刘宇辉
/// 编写日期：	2010-02-24
ClassMethod AntiContrast()
{
   s Subscript=0,MRowid=0,ind=0
  
   f  s Subscript=$o(^ARCIM(Subscript)) q:Subscript=""  d
   .s ARowid=Subscript_"||"_1
   .s ADesc=$p(^ARCIM(Subscript,1,1),"^",2)    //取HIS中抗生素描述
   .f  s MRowid=$o(^DHCMInfAD(MRowid)) q:MRowid=""  d
   ..s MDesc=$p($g(^DHCMInfAD(MRowid)),"^",2)     //取民科系统抗生素
   ..i ADesc=MDesc  d
   ...s ind=ind+1
   ...&SQL(insert into DHC_MedInfAntiContrast(MIAC_ItmMastDR,MIAC_InfAntiDR,MIAC_IsActive) values (:ARowid,:MRowid,'Y'))
   
   q "有  "_ind_"  个抗生素完成对照"
}

/// 描述：		调用程序后让民科病原体和HIS里病原体描述对照
///         	完全相同则在DHC_MedInfPathogenMaping中插入记录
/// 编写者： 	刘宇辉
/// 编写日期：	2010-02-24
ClassMethod PathogenContrast()
{
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$QryBugsDicExecute^DHCMedInfPathogenMaping("","","Y","DHC-MEDSRC","DHC-APP")
	s Ret=$$Fetch^DHCMedInfPathogenMaping(ret,"DHC-MEDSRC","DHC-APP")
	zn CurrentNS
    s rowid=0,ind=0
    f i=1:1:$l(Ret,$c(1)) d
    .w $p(Ret,$c(1),i),!
    .s rowid=0 f  s rowid=$o(^DHCMInfPD(rowid)) q:rowid=""  d
    ..s PDDesc=$p(^DHCMInfPD(rowid),"^",2)
    ..s MIPMCode=$p($p(Ret,$c(1),i),"^",1)
    ..i PDDesc=$p($p(Ret,$c(1),i),"^",2)  d
    ...s ind=ind+1
    ...&SQL(insert into DHC_MedInfPathogenMaping(MIPM_PatID,MIPM_Code,MIPM_Desc ,MIPM_IsActive) values (:rowid,:MIPMCode,:PDDesc,'Y'))
    q "有  "_ind_"  个病原体完成对照"
}

}
