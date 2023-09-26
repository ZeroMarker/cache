/// 创建者：李阳
/// 创建日期：2013-12-07
/// 功能：同步诊断信息
Class DHCMed.DPCustom.Meta.HIS.Diagnose Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// 抽取诊断数据
/// FromDate:出院日期的开始日期
/// ToDate：出院日期的结束日期
/// 注意：如果FromDate,ToDate均等于0，则抽取所有在院患者的诊断数据
ClassMethod ExtractData(FromDate As %Date, ToDate As %Date) As %String
{
	n (FromDate,ToDate)
	
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For tmpDate=FromDate:1:ToDate {
		For {
			Set EpisodeID=$o(^PAADMi(DischDateIndex,tmpDate,EpisodeID))
			Quit:EpisodeID=""
			Continue:$d(^PAADMi("PAADM_Type","I",EpisodeID))=0
			Set tmpRet=$$ExtractEpisodeDia(EpisodeID)
		}	
	}
	
	if (FromDate=0) {
		Set WardID=""
		For {
			Set WardID=$o(^PAADMi("CurrWard",WardID))
			Quit:WardID=""
			Set RoomID=""
			For {
				Set RoomID=$o(^PAADMi("CurrWard",WardID,RoomID))
				Quit:RoomID=""
				Set EpisodeID=""
				For {
					Set EpisodeID=$o(^PAADMi("CurrWard",WardID,RoomID,EpisodeID))
					Quit:EpisodeID=""
					Set tmpRet=$$ExtractEpisodeDia(EpisodeID)
				}
			}
		}
	}
	
	
	Quit 1
ExtractEpisodeDia(EpisodeID)
	n (EpisodeID)
	quit:'$d(^PAADM(+EpisodeID)) return
	set PAADMMainMRADMDR=$p(^PAADM(+paadm),"^",61)
	Set ChildSub=""
	For {
		Set ChildSub=$o(^MR(PAADMMainMRADMDR,"DIA",ChildSub))
		Quit:ChildSub=""
		Set objDia=##class(DHCMed.Base.MRDiagnose).GetObjById(PAADMMainMRADMDR_"||"_ChildSub)
		Continue:'$IsObject(objDia)
		
		//保存ActMain
		Set strArg=""
		Set $p(strArg,"^",1)=""
		Set $p(strArg,"^",2)=EpisodeID
		Set $p(strArg,"^",3)="DG"
		Set $p(strArg,"^",4)="DG-HIS-DIAG"
		Set $p(strArg,"^",5)=objDia.DiaDate
		Set $p(strArg,"^",6)=objDia.ICD9CMCode_"--"_objDia.ICDDesc
		Set $p(strArg,"^",7)=PAADMMainMRADMDR_"||"_ChildSub
		Set $p(strArg,"^",8)="" //XDate
		Set $p(strArg,"^",9)=1 //IsActive
		Set $p(strArg,"^",10)=+$h
		Set $p(strArg,"^",11)=$p($h,",",2)
		Set $p(strArg,"^",12)=objDia.AliasDiagText
		Set ActMainID=##class(DHCMed.DP.Meta.ActMain).Update(strArg)
		
		Set strArg=""
		Set $p(strArg,"^",1)=""
		Set $p(strArg,"^",2)=ActMainID
		Set $p(strArg,"^",3)="DG-HIS-DIAG"
		Set $p(strArg,"^",4)=PAADMMainMRADMDR_"||"_ChildSub
		Set $p(strArg,"^",5)=objDia.ICD9CMCode
		Set $p(strArg,"^",6)=objDia.ICDDesc
		Set $p(strArg,"^",7)=objDia.AliasDiagText
		Set TypeChildSub=$o(^MR(PAADMMainMRADMDR,"DIA",ChildSub,"TYP",""),-1)
		Set $p(strArg,"^",8)=$p($g(^MRC("DTYP",+$g(^MR(PAADMMainMRADMDR,"DIA",ChildSub,"TYP",TypeChildSub)))),"^",2)  //类别
		Set $p(strArg,"^",9)=objDia.DiaDate
		Set $p(strArg,"^",10)=objDia.DiaTime
		Set $p(strArg,"^",11)=""
		Set ret=##class(DHCMed.DP.Meta.Diagnose).Update(strArg)
	}
	
	Quit 1
}

}
