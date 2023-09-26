/// 主要用于门诊插入数据的接口
Class DHCDoc.Interface.Outside.ImportData.DocOPInfo Extends %RegisteredObject
{

/// Creator:    qujian
/// Desc:       插入住院证
/// CreateTime：2020-07-17
/// 入参Instring
/// s Instr=BookID_"^"_PatID_"^"_PAAdmOP_"^"_PAAdmIP_"^"_CreateDate_"^"_CreateTime_"^"_CreaterUser_"^"_CreaterDocIDUser;
/// s Instr=Instr_"^"_InCurStatu_"^"_BookActive_"^"_InSdate_"^"_InWard_"^"_InBed_"^"_InCtloc;
/// s Instr=Instr_"^"_ICDCode_"^"_InResumeText_"^"_""_"^"_IPDeposit_"^"_MRCCondtion;
/// s Instr=Instr_"^"_AdmInitState_"^"_InReason_"^"_InSorce_"^"_InBedType_"^"_ICDList;
/// s Instr=Instr_"^"_CTLocMedUnit_"^"_InDoctor_"^"_PatientLevel_"^"_TreatedPrinciple;
/// s Instr=Instr_"^"_IsDayFlag_"^"_IsOutTriage_"^"_WardFlag_"^"_LocLogOn;
/// w ##class(DHCDoc.Interface.Outside.ImportData.DocOPInfo).InsertIPBookInfo(Instr)
ClassMethod InsertIPBookInfo(Instring)
{
	q:Instring=""
	s BookID=$P(Instring,"^",1)
	s PatientID=$P(Instring,"^",2)
	s EpsiodeID=$P(Instring,"^",3)
	s BookStr="Booking^Cancel^PreInPatient"
	s OtherBookStr="Booking^Cancel"
	s checkBefor=##class(web.DHCDocIPBookNew).CheckBeforeSave(EpsiodeID,BookID,1)
	q:checkBefor'=0 checkBefor
	s checkBefor=##class(web.DHCDocIPBookNew).CheckBeforeSave(EpsiodeID,BookID,2,Instring,BookStr)
	q:checkBefor'=0 checkBefor
	s rtn = ##class(web.DHCDocIPBookNew).SaveBookMeth(Instring)
	q rtn
}

/// Creator:    qujian
/// Desc:       撤销住院证
/// CreateTime：2022-10-17
/// 入参 ：BookID :住院证ID (如果没有可以传这次住院的门诊就诊EpisodeIDFrom 或者住院就诊EpisodeIDTo)
///        StatuCode ：Cancel 撤销，UserDr 用户，CancleID ：取消预约id
/// 出参 ：0 成功 
/// w ##class(DHCDoc.Interface.Outside.ImportData.DocOPInfo)UpdateBookStatu(BookID, StatuCode, UserDr, CancleID,EpisodeIDFrom,EpisodeIDTo)
ClassMethod UpdateBookStatu(BookID, StatuCode, UserDr, CancleID = "", EpisodeIDFrom = "", EpisodeIDTo = "")
{
	if (BookID=""){
		if (EpisodeIDFrom'=""){
			s BookID=$O(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeIDFrom,0)) 
			}elseif (EpisodeIDTo'=""){
			s BookID=$O(^DHCDocIPBK(0,"EpisodeIDTo",EpisodeIDTo,0)) 	
			}
		}
	q:BookID="" "-1^未找到住院证"
	s rtn=##class(web.DHCDocIPBookNew).UpdateBookStatu(BookID, StatuCode, UserDr, CancleID)
	q rtn
}

}
