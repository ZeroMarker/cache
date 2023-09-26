/// 名称: DHCMed.DCEns.NIS.ObResultByV1
/// 描述: 护理记录数据输入服务类（东华体温单V1.0）
/// 编写者：zhufei
/// 编写日期: 2016-04-14
Class DHCMed.DCEns.NIS.ObResultByV1 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// *********************************************************************************
/// 以下内容为：同步护理记录数据方法
/// *********************************************************************************
/// Creator：     zhufei
/// CreatDate：   2016-04-14
/// Description:  根据起止日期同步护理记录数据
/// Table：       DHCMed.DC.NIS.Observations
/// Input：       FromDate:开始日期
///               ToDate:结束日期
///               HospCode:医院缩写码（DHCMed_DC_SYS.BTHospital.SCode）
/// Return：      OK
/// w ##class(DHCMed.DCEns.NIS.ObResultByV1).SyncObsByDate("2016-05-04","2016-05-04","NIS01",1)
ClassMethod SyncObsByDate(aFromDate As %String, aToDate As %String, aHospCode As %String, aInitFlag As %String = "0") As %String
{
	New (aFromDate,aToDate,aHospCode,aInitFlag)
	Set return="0^入参错误",Count=0
	Quit:(aFromDate="")||(aToDate="")||(aHospCode="") return
	
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	
	If aInitFlag=1 {
		//护理记录数据
		Kill ^DHCMed.DC.NIS.ObservationsD
		Kill ^DHCMed.DC.NIS.ObservationsI
	}
	
	Set return="-1^医院缩写码维护错误"
	Set SSHospCodeList=##class(DHCMed.DCEns.HospitalSrv).GetCodeBySCode(aHospCode)
	Quit:SSHospCodeList="" return
	
	Set xHospCode=""
	For {
		Set xHospCode=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",xHospCode))
		Quit:xHospCode=""
		
		Set tHospCode=$tr(xHospCode," ","")
		Set tSSHospCodeList=##class(DHCMed.DCEns.HospitalSrv).GetCodeBySCode(tHospCode)
		Continue:tSSHospCodeList=""
		
		Set HospCodeFlag=0
		For indHosp=1:1:$ll(tSSHospCodeList) {
			Set tSSHospCode=$list(tSSHospCodeList,indHosp)
			Continue:tSSHospCode=""
			Continue:$listfind(SSHospCodeList,tSSHospCode)<1
			Set HospCodeFlag=1
			Quit
		}
		Continue:HospCodeFlag<1
		
		Set xAdmType=""
		For {
			Set xAdmType=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",xHospCode,xAdmType))
			Quit:xAdmType=""
			
			Continue:(xAdmType'="I")&&(xAdmType'="E")&&(xAdmType'="EP")
			
			Set xAdmDays=""
			For {
				Set xAdmDays=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",xHospCode,xAdmType,xAdmDays))
				Quit:xAdmDays=""
				
				Set xDate=$s(xAdmDays>0:aFromDate-xAdmDays,1:"")
				For {
					Set xDate=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",xHospCode,xAdmType,xAdmDays,xDate))
					Quit:xDate=""
					
					Quit:(xAdmDays>0)&&(xDate>(aToDate-xAdmDays+1))
					Quit:(xAdmDays<0)&&(xDate>aToDate)
					
					Set xID=0
					For {
						Set xID=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",xHospCode,xAdmType,xAdmDays,xDate,xID))
						Quit:xID=""
						
						Set objAdm=##class(DHCMed.DC.HIS.InHospital).GetObjById(xID)
						Continue:'$IsObject(objAdm)
						Continue:objAdm.IsActive'=1
						Set EpisodeID=objAdm.EpisodeID
						
						Set Count=Count+1
						W:(Count#100)=0 "已处理 "_Count_" 条数据!",!
						
						Set flg=..UpdateObservations(EpisodeID,aHospCode,aFromDate,aToDate)
					}
				}
			}
		}
	}
	
	Quit "OK"
}

/// Creator：     zhufei
/// CreatDate：   2016-04-14
/// Description:  同步就诊记录时间段内护理记录
/// Table：       DHCMed.DC.NIS.Observations
/// Input：       aPaadm:就诊ID
/// 	          aFromDate:开始日期
///               aToDate:结束日期
/// Return：      
/// w ##Class(DHCMed.DCEns.NIS.ObResultByV1).UpdateObservations(5,"59172","59175","NIS01")
ClassMethod UpdateObservations(aPaadm As %String, aHospCode As %String, aFromDate As %String, aToDate As %String) As %String
{
	New (aPaadm,aHospCode,aFromDate,aToDate)
	Set return=0
	Quit:(aPaadm="") return
	
	Set MRAdm=##class(DHCMed.SSService.CommonCls).GetMRAdm(aPaadm)
	Quit:MRAdm="" return
	Set xSubID=0
	For {
		Set xSubID=$o(^MR(MRAdm,"OBS",xSubID))
		Quit:xSubID=""
		
		Set ItemDR=$p($g(^MR(MRAdm,"OBS",xSubID)),"^",1)
		Continue:'$d(^MRC("OBITM",+ItemDR))
		Set ItemDesc=$p($g(^MRC("OBITM",+ItemDR)),"^",2)
		Set ItemValue=$p($g(^MR(MRAdm,"OBS",xSubID)),"^",2)
		
		Set OBSDate=$p($g(^MR(MRAdm,"OBS",xSubID)),"^",3)
		Set OBSTime=$p($g(^MR(MRAdm,"OBS",xSubID)),"^",4)
		Continue:(OBSDate="")||(OBSTime="")
		Continue:OBSDate<1
		Set OBSUser=$p($g(^MR(MRAdm,"OBS",xSubID)),"^",5)
		Set OBSUserDesc=""
		Set:OBSUser'="" OBSUserDesc=$p($g(^SSU("SSUSR",OBSUser)),"^",2)
		
		Set UpdateDate=$p($g(^MR(MRAdm,"OBS",xSubID)),"^",11)
		Set:UpdateDate="" UpdateDate=OBSDate
		Continue:(aFromDate'="")&&(UpdateDate<aFromDate)
		Continue:(aToDate'="")&&(UpdateDate>aToDate)
		
		Set ObItemDR=##class(DHCMed.DC.NIS.BTObItem).GetIDByCodeDesc(ItemDR,ItemDesc,aHospCode)
		If ObItemDR="" {
			Set InputStr=ItemDR                    //Code
			Set InputStr=InputStr_$c(1)_ItemDesc   //CName
			Set InputStr=InputStr_$c(1)_aHospCode  //HospCode
			Set InputStr=InputStr_$c(1)_ItemDR     //XCode
			Set InputStr=InputStr_$c(1)_1          //Active
			Set flg=##class(DHCMed.DC.LIS.BTTestCode).Update(InputStr,$c(1))
			If (+flg)<1 {
				Set error="-2^错误提示:护理项目保存错误!return="_flg_",InputStr="_InputStr
				Quit
			}
			Set TestCodeDR=flg
		}
		
		Set InputStr = MRAdm_"||"_xSubID
		Set InputStr = InputStr_"^"_aPaadm
		Set InputStr = InputStr_"^"_ObItemID
		Set InputStr = InputStr_"^"_ItemValue
		Set InputStr = InputStr_"^"_OBSDate
		Set InputStr = InputStr_"^"_OBSTime
		Set InputStr = InputStr_"^"_OBSUserDesc
		Set InputStr = InputStr_"^"_1
		Set flg=##class(DHCMed.DC.NIS.Observations).Update(InputStr,"^")
		If (+flg)<1 {
			Set error="-3^错误提示:护理记录保存错误!return="_flg_",InputStr="_InputStr
			Quit
		}
	}
	
	Quit return
}

/// *********************************************************************************
/// 以下内容为：同步护理管理基础数据方法
/// *********************************************************************************
/// Creator：     zhufei
/// CreatDate：   2016-04-19
/// Description:  护理管理基础数据同步
/// Table：       DHCMed.DC.NIS.*
/// Input：       HospCode ：医院缩写码（DHCMed_DC_SYS.BTHospital.SCode）
/// Return：      OK
/// w ##class(DHCMed.DCEns.NIS.ObResultByV1).ProcBaseData("NIS01")
ClassMethod ProcBaseData(aHospCode As %String, aInitFlag As %String = "0") As %String
{
	New (aHospCode,aInitFlag)
	Set return="0^入参为空"
	Quit:aHospCode="" return
	
	Set return="-1^医院缩写码维护错误"
	Set flg=##class(DHCMed.DC.BTHospital).GetIDBySCode(aHospCode)
	Quit:flg="" return
	
	//处理【基础字典】护理项目
	If aInitFlag=1 {
		Kill ^DHCMed.DC.NIS.BTObItemD
		Kill ^DHCMed.DC.NIS.BTObItemI
	}
	Set flg=..ChangeBTObItem(aHospCode)
	
	Quit "OK"
}

ClassMethod ChangeBTObItem(aHospCode As %String) As %String
{
	Set Count=0
	Set xID=""
	For {
		Set xID=$o(^MRC("OBITM",xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^MRC("OBITM",xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		
		set Code     = xID
		set CName    = $p(tmpInfo,"^",2)
		continue:CName=""
		set XCode    = xID
		set Active 	 = 1
		Set HospCode = aHospCode
		Set InStr=Code_"^"_CName_"^"_HospCode_"^"_XCode_"^"_Active
		Set flg=##class(DHCMed.DC.NIS.BTObItem).Update(InStr,"^")
		If (flg<1) {
			Write "医生：flg="_flg_","_InStr,!
		}
	}
	Quit Count
}

}
