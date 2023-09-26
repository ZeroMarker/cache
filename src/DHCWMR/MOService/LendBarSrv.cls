/// 名称: DHCWMR.MOService.LendBarSrv
/// 描述: 出库条相关服务
/// 编写者：liyi
/// 编写日期: 2015-11-17
Class DHCWMR.MOService.LendBarSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2015-11-17
/// Description:  通过就诊批量出库门诊病案，处理当天，插入需自动打印出库条记录
/// Input：		  aMrTypeID:病案类型ID
/// 			  aUserID：登陆用户
/// Return：      
/// w ##class(DHCWMR.MOService.LendBarSrv).BatchLendByAdm(6,9)
ClassMethod BatchLendByAdm(aMrTypeID As %String, aUserID As %String) As %String
{
	New (aMrTypeID,aUserID)
	Set return = 0
	Quit:(aMrTypeID="")||(aUserID="") return
	
	Set objMrType = ##class(DHCWMR.SS.MrType).GetObjById(aMrTypeID)
	Quit:'$IsObject(objMrType) return
	Quit:objMrType.MTMrClass.MCCode'="O" return
	
	Set QueryDate = +$h,xTime = ""
	For {
		Set xTime = $o(^PAADMi("PAADM_DateTime",QueryDate,xTime))
		Quit:xTime=""
		Set xPaadm=""
		For {
			Set xPaadm=$o(^PAADMi("PAADM_DateTime",QueryDate,xTime,xPaadm))
			Quit:xPaadm=""
			Continue:$d(^DHCWMR.MO.LendBarI("IndexEpisodeID"," "_xPaadm))	//已记录
			
			Set AdmStr = $g(^PAADM(xPaadm))
			Set AdmType =$p(AdmStr,"^",2)
			Continue:AdmType'="O"						//非门诊就诊过滤
			Continue:$p(AdmStr,"^",20)="C"   			//取消就诊过滤
			Set Papmi = $p(AdmStr,"^",1)
			Continue:+Papmi=0
			Set MrNo= ##class(DHCWMR.SSService.MrNoSrv).GetMrNoByPatientID(Papmi,aMrTypeID)
			Continue:MrNo=""
			Set MrInfo = ##class(DHCWMR.SSService.NewRecordSrv).GetMRInfoByMrNo(aMrTypeID,MrNo)
			Set MainID = $p(MrInfo,"^",1)
			Continue:MainID=""
			
			//处理修改病案号之后的历史数据
			Set HisMainIDs=##class(DHCWMR.SS.Main).GetHisMainByID(MainID)
			If HisMainIDs'="" {
				Set flg=##Class(DHCWMR.MO.LendRecord).UpdateErrorMainDr(HisMainIDs)
			}
			
			If $d(^DHCWMR.MO.LendRecordI("IndexMainDrStatus",MainID," L")){  //病历为出库状态
				Set LendRecordID = $o(^DHCWMR.MO.LendRecordI("IndexMainDrStatus",MainID," L",""))
				Set PrintFlg=0
				Set IsLend=1
				Set CreateDate=+$h
			}else{
				Set LendRecordID=""
				Set PrintFlg=0
				Set IsLend=0
				Set CreateDate=+$h
				//批量出库
				Set MRecord=MainID
				Set Detail = ""
				Set Detail = Detail_"^"_""         	//借阅科室名称
				Set Detail = Detail_"^"_""          //借阅科室电话
				Set Detail = Detail_"^"_""          //借阅人
				Set Detail = Detail_"^"_""         	//借阅人姓名
				Set Detail = Detail_"^"_""          //借阅人电话
				Set Detail = Detail_"^"_""          //借阅目的
				Set Detail = Detail_"^"_""          //预计归还日期
				Set Detail = Detail_"^"_""          //备注
				Set Detail = Detail_"^"_xPaadm      //就诊号
				Set Detail = Detail_"^"_1           //分类
				Set flg = ##class(DHCWMR.MOService.LendRecordSrv).LendOperation("L",aUserID,"",MRecord,"",Detail,"A")
			}
			Set InputStr = ""
			Set $p(InputStr,"^",1)=""
			Set $p(InputStr,"^",2)=aMrTypeID
			Set $p(InputStr,"^",3)=xPaadm
			Set $p(InputStr,"^",4)=LendRecordID
			Set $p(InputStr,"^",5)=PrintFlg
			Set $p(InputStr,"^",6)=IsLend
			Set $p(InputStr,"^",7)=CreateDate
			Set flg = ##Class(DHCWMR.MO.LendBar).Update(InputStr,"^")
		}
	}
	Set return = 1
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-11-17
/// Description:  通过出库条ID获取挂号出库条信息
/// Input：		  aBarID:DHCWMR.MO.LendBar.ID
/// 			  aHospID:医院ID
/// Return：      打印信息
/// w ##class(DHCWMR.MOService.LendBarSrv).GetPrintInfo(1,"3")
ClassMethod GetPrintInfo(aBarID As %String, aHospID As %String) As %String
{
	New (aBarID,aHospID)
	Set return=""
	Quit:(aBarID="")||(aHospID="") return
	
	Set objLendBar = ##class(DHCWMR.MO.LendBar).GetObjById(aBarID)
	Quit:'$IsObject(objLendBar) return
	
	Set SSHospCode = ##class(DHCWMR.SSService.HospitalSrv).GetSSHospCode(aHospID)
	Quit:SSHospCode="" return
	
	Set IsLend = objLendBar.MLIsLend
	Set EpisodeID = objLendBar.MLEpisodeID
	Set MrtypeID = objLendBar.MLMrType.%Id()
	Quit:EpisodeID="" return
	
	Set MrNo = ##class(DHCWMR.SSService.MrNoSrv).GetMrNoByEpisodeID(EpisodeID,MrtypeID)
	Quit:MrNo="" return
	
	Set MainID = $o(^DHCWMR.SS.MainI("IndexTypeNoAct",MrtypeID," "_$zcvt(MrNo,"U"),1,""))
	Quit:MainID="" return
	
	Set VolumeID = $o(^DHCWMR.SS.VolumeI("IndexMainDrAct",MainID,1,""))
	Quit:VolumeID="" return
		
	If SSHospCode["BJTR"			//北京同仁
	{
		Set Titie = "同仁医院门诊病历单"
	} Else {
		Set Titie = "XXXX/医院门诊病历单"
	}
	Set objVolPaadm = ##class(DHCWMR.SS.VolPaadm).GetObjById(VolumeID_"||"_1)
	Quit:'$IsObject(objVolPaadm) return
	//就诊信息
	Set PatName = objVolPaadm.VPPatName
	Set Sex = objVolPaadm.VPSex
	//Set AdmDate = $p($g(^PAADM(EpisodeID)),"^",6)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetAdmDateTime(EpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set:+AdmDate'=0 AdmDate = $zd(AdmDate,3)
	
	//挂号信息
	Set SepInfo =  ##class(DHCWMR.MOService.LendBarSrv).GetRegInfo(EpisodeID)
	Set DocDesc = $p(SepInfo,"^",4)								//挂号医生
	Set Number  = $p(SepInfo,"^",1)_$p(SepInfo,"^",2)_"号"		//排号
	Set LocDesc = $p(SepInfo,"^",3)								//挂号科室
	Set LocID   = $p(SepInfo,"^",7)	
	Quit:'$d(^DHCWMR.SS.PrintLocI("IndexHospLoc"," "_aHospID," "_LocID)) return  //只打配置科室的挂号条
	
	Set AdmDateTime = $p(SepInfo,"^",5)_" "_$p(SepInfo,"^",6)	//挂号时间
	If IsLend = 1
	{
		Set objLendRecord = objLendBar.MLLendRecordDr
		//借出信息
		Set MrStatus ="病历已借出"
		Set LendLocID 	=objLendRecord.LRLocID					//借出科室
		Set:LendLocID'="" LendLocDesc=$p($g(^CTLOC(+LendLocID)),"^",2)
		Set:LendLocDesc["-" LendLocDesc=$p(LendLocDesc,"-",2)
		Set LendUserID 	=objLendRecord.LRUserID				//借阅医生
		Set:LendUserID'="" LendDocDesc = $p($g(^SSU("SSUSR",LendUserID)),"^",2)
		Set LendDate    =objLendRecord.LRLendDate
		Set:+LendDate'=0 LendDate=$zd(LendDate,3)
		Set LendTime    =objLendRecord.LRLendTime
		Set:+LendTime'=0 LendTime=$zt(LendTime,2)
		Set LendDateTime = LendDate_" "_LendTime	//借阅时间
	}else{
		//更新打印标记
		Set InputStr = aBarID_"^"_1
		d ##class(DHCWMR.MO.LendBar).UpdatePrintFlag(InputStr,"^")
	}
	Set return =IsLend_"^"_Titie_"^"_DocDesc_"^"_Number_"^"_LocDesc_"^"_MrNo_"^"_PatName_"^"_Sex_"^"_AdmDate_"^"_AdmDateTime_"^"_$g(MrStatus)_"^"_$g(LendLocDesc)_"^"_$g(LendDocDesc)_"^"_$g(LendDateTime)

	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-11-17
/// Description:  通过EpisodeID取挂号信息
/// Input：		  EpisodeID
/// Return：      挂号信息
/// w ##class(DHCWMR.MOService.LendBarSrv).GetRegInfo(134)
ClassMethod GetRegInfo(aEpisodeID As %String)
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	Set RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM"," "_aEpisodeID,""))
	Set RegTimeRange=""  //时段
	Set RegfeeNo=""      //序号
	Set RegfeeDepDesc="" //科室
	Set RegfeeDocDesc="" //号别
	Set RegfeeDate=""	 //挂号日期
	Set RegfeeTime=""	 //挂号时间
	If (RegfeeDr'=""){	
		Set RegTimeRangeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
	 	If $g(RegTimeRangeDr)'="" {
		 	Set RegTimeRange=$p(^DHCTimeRange(RegTimeRangeDr),"^",2)                     //挂号时段
	 	}
	 	Set RegfeeNo=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),8)						 //序号
	 	Set RegfeeDepDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),13)
	 	Set:RegfeeDepDr'="" RegfeeDepDesc=$p($g(^CTLOC(+RegfeeDepDr)),"^",2)   //科室
	 	Set:RegfeeDepDesc["-" RegfeeDepDesc=$p(RegfeeDepDesc,"-",2)
	 	Set RegfeeDocDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),14)
	 	Set:RegfeeDocDr'="" RegfeeDocDesc=$p($g(^CTPCP(RegfeeDocDr,1)),"^",2)			 //号别
	 	Set RegfeeDate=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),15)
	 	Set:+RegfeeDate'=0 RegfeeDate = $zd(RegfeeDate,3)								 //挂号日期
	 	Set RegfeeTime=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),16)
	 	Set:+RegfeeTime'=0 RegfeeTime=$zt(RegfeeTime,2)									 //挂号日期
	 	Set return = RegTimeRange_"^"_RegfeeNo_"^"_RegfeeDepDesc_"^"_RegfeeDocDesc_"^"_RegfeeDate_"^"_RegfeeTime_"^"_RegfeeDepDr
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-11-17
/// Description:  查询出库条记录
/// Table：       DHCWMR.MO.LendBar
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.MOService.LendBarSrv","QryLendBar","3","6","2013-03-05","2013-03-05",0)
Query QryLendBar(aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aFrintFlg As %String = "") As %Query(ROWSPEC = "BarID:%String")
{
}

ClassMethod QryLendBarExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aFrintFlg As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="")||(aHospID="")||(aMrTypeID="") $$$OK
	
	For xDate = aDateFrom:1:aDateTo{
		Set xPrintFlg = ""
		For {
			Set xPrintFlg = $o(^DHCWMR.MO.LendBarI("IndexMrTypeCreateDatePrintFlg",aMrTypeID,xDate,xPrintFlg))
			Quit:xPrintFlg=""
			Continue:(aFrintFlg'="")&&(aFrintFlg'=xPrintFlg)
			
			Set xBarID = ""
			For {
				Set xBarID = $o(^DHCWMR.MO.LendBarI("IndexMrTypeCreateDatePrintFlg",aMrTypeID,xDate,xPrintFlg,xBarID))
				Quit:xBarID=""
				
				Set Data = $lb(xBarID)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
			
		}
	}
	
	Quit $$$OK
}

ClassMethod QryLendBarClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLendBarExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLendBarFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLendBarExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
