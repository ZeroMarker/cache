/// 诊断操作类
/// 创建者：刘宇辉
/// 创建日期：2010-10-09
Class DHCMed.CCService.Lib.MRDiagnoseTestLib Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-10-09
/// Description:  判断病人该次就诊是否下了该诊断
/// Table：       MR_Adm、MR_Diagnos
/// Input：       MRCID
/// Return：      ret=1:下了该诊断
/// w ##class(DHCMed.CCService.Lib.MRDiagnoseTestLib).HasMRC("||1")
ClassMethod HasMRC(MRCStr As %String)
{
		n (MRCStr, %PAADM, %ExtraData, %ExtraDataCnt)
		s ret=0
		s MRCID=$p(MRCStr,"||",2)
		q:MRCID="" ret
		//^MR({MR_Adm.MRADM_RowId},"DIA",{MRDIA_Childsub}) 
		s objMRAdm=##class(DHCMed.Base.MRAdm).GeObjtByPaadm(%PAADM)
		q:'$IsObject(objMRAdm) ret
		q:'$d(^MR(objMRAdm.Rowid,"DIA")) ret
		s MRDiaChildSub="" f  s MRDiaChildSub=$o(^MR(objMRAdm.Rowid,"DIA",MRDiaChildSub)) q:MRDiaChildSub=""  d
		.s ICDCodeDr=$p($g(^MR(objMRAdm.Rowid,"DIA",MRDiaChildSub)),"^",1)
		.q:ICDCodeDr'=MRCID
		.s ret=1
		.s objMRCItm=##class(DHCMed.Base.MRCICDDx).GetObjById(MRCID)
		.s objMRDiaItm=##class(DHCMed.Base.MRDiagnose).GetObjById(objMRAdm.Rowid_"||"_MRDiaChildSub)
		.q:'$IsObject(objMRCItm)
		.q:'$IsObject(objMRDiaItm)
		.s tmp=""
		.s tmp=objMRDiaItm.Rowid //记录ID
		.s tmp=tmp_"^"_objMRCItm.Descs 			//诊断名称
		.s tmp=tmp_"^"_$zd(objMRDiaItm.DiaDate,3) //下诊断日期
		.s tmp=tmp_"^"_$zt(objMRDiaItm.DiaTime,1)  //下诊断时间
		.s tmp=tmp_"^"_objMRDiaItm.IsActive 		//是否有效
		.s %ExtraDataCnt=%ExtraDataCnt+1
		.s $li(%ExtraData,%ExtraDataCnt)="D"_$C(1)_tmp
		.do objMRCItm.%Close()
		.do objMRDiaItm.%Close()
		q ret
}

ClassMethod GetDetails(Str As %String) As %String
{
	n (Str)
	s ret=""
	s ret="诊断名称:"_$p(Str,"^",2)
	s ret=ret_"  ||诊断时间:"_$p(Str,"^",3)_" "_$p(Str,"^",4)
	q ret
}

}
