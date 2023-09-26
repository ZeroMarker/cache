/// 名称: DHCHAI.IRS.ICUIExASrv
/// 描述: ICU插拔管评估相关服务
/// 编写者：ShenC
/// 编写 日期: 2020-08-26
Class DHCHAI.IRS.ICUIExASrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ShenC
/// CreatDate：   2020-08-14
/// Description:  加载'三管感染防控督察表'
/// Table：       DHCHAI.IR.ICUExA,DHCHAI.IR.ICUExAExt
/// Input:        aIExAID:督察表ID
/// 		 	  aTubeType:插管类型[PICC|VAP|UC]
/// 			  aPageID:评估表页数[一页15天]
/// 		      aPrintType:0:(只读),1(编辑),2(打印)
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.ICUIExASrv","QryIExARep","41","PICC","2","1")
Query QryIExARep(aIExAID As %String, aTubeType As %String, aPageID As %Integer, aPrintType As %String = "") As %Query(ROWSPEC = "PatName:%String,MrNo:%String,Diag:%String,IntuTypeDesc:%String,IntuDate:%String,RetReasonDesc:%String,DicTypeID:%String,DicTypeDesc:%String,DicID:%String,DicCode:%String,DicDesc:%String,Item1:%String,Item2:%String,Item3:%String,Item4:%String,Item5:%String,Item6:%String,Item7:%String,Item8:%String,Item9:%String,Item10:%String,Item11:%String,Item12:%String,Item13:%String,Item14:%String,Item15:%String,StaDay:%Integer") [ SqlProc ]
{
}

ClassMethod QryIExARepExecute(ByRef qHandle As %Binary, aIExAID As %String, aTubeType As %String, aPageID As %Integer, aPrintType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aIExAID="")||(aTubeType="")||(aPageID="") $$$OK
	
	Set NIndex="QryIExARep"
	Kill ^TMP($zn,$j,NIndex)
	//'督察表'数据
	Set IExAData=$g(^DHCHAI.IR.ICUIExAD(aIExAID))
	Quit:IExAData="" $$$OK
	
	Set IsActive=$lg(IExAData,7)		
	Quit:IsActive'=1 $$$OK	
	
	//扩展数据(用于打印)
	Set EpisodeID=$lg(IExAData,2)
	Quit:EpisodeID="" $$$OK
	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeID))
	Quit:PAAdmData="" $$$OK
	
	Set PatName = $lg(PAAdmData,6)			//姓名
	Set MrNo = $lg(PAAdmData,5)				//住院号
	Set Diag=""								//诊断(优先主诊断)		
	Set Diag=##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(EpisodeID,"M")	
	Set:Diag="" Diag=##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(EpisodeID,"DIS")
	Set:Diag="" Diag=##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(EpisodeID,"C008")
	Set:Diag="" Diag=##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(EpisodeID,"PRE")
	Set IntuTypeID=$lg(IExAData,3)			//'插管类型'字典ID
	Quit:IntuTypeID="" $$$OK	
	Set DicData=$g(^DHCHAI.BT.DictionaryD(IntuTypeID))	//'插管类型'字典
	Quit:DicData="" $$$OK
	Set IntuTypeDesc=$lg(DicData,3)			//'插管类型'字典描述
	Set RetReason=$lg(IExAData,6)			//留置原因
	Set RetReasonDesc=""
	For xID=1:1:$l(RetReason,","){
		Set DicID=$p(RetReason,",",xID)
		Continue:DicID=""
		
		Set DicDesc=$li($g(^DHCHAI.BT.DictionaryD(DicID)),3)
		Set RetReasonDesc=RetReasonDesc_","_DicDesc
	}
	Set:RetReasonDesc'="" RetReasonDesc=$e(RetReasonDesc,2,$l(RetReasonDesc))
	
	Set IntuDate=$li(IExAData,4)		//置管日期
	Quit:IntuDate="" $$$OK
	//当前页 开始~结束
	Set IPStaDay=##class(DHCHAI.BT.Config).GetValByCode("IExAStartDay")		//取配置数据
	Set StaDay=""
	Set:aTubeType="PICC" StaDay=$p(IPStaDay,"-",1)
	Set:aTubeType="VAP" StaDay=$p(IPStaDay,"-",2)
	Set:aTubeType="UC" StaDay=$p(IPStaDay,"-",3)
	Quit:StaDay="" $$$OK
	
	Set StartDay=(aPageID-1)*15+StaDay		//开始置管(天)
	Set EndDay=(aPageID-1)*15+StaDay+14		//结束置管(天)
	
	//1-督查,2-督查人,3-督查日期
	Set IpID1="1",IpDesc1="督查",IpID2="1",IpCode2="1",IpDesc2="督查"
	Set IpUserID1="2",IpUserDesc1="督查人",IpUserID2="2",IpUserCode2="2",IpUserDesc2="督查人"
	Set IpDateID1="3",IpDateDesc1="督查日期",IpDateID2="3",IpDateCode2="3",IpDateDesc2="督查日期"
		
	Set (IpUserVals,IpDateVals)=""
	For xDay=StartDay:1:EndDay{
		Set (IpUserVal,IpDateVal)=""
		Set UserID=$o(^DHCHAI.IR.ICUIExAExtI("ChildExt","IndexIExADateUser",aIExAID,xDay,0))
		If (UserID'=""){
			Set UserData=$g(^DHCHAI.BT.SysUserD(UserID))
			If (UserData'=""){
				Set IpUserVal=$lg(UserData,3)			//督查人
			}
			Set IpDateVal=IntuDate+xDay-1				//督查日期(2.1置管第一天为2.1)
			Set:IpDateVal'="" IpDateVal=$p($zd(IpDateVal,3),"-",2,3)
		}
		Set IpUserVals=IpUserVals_"^"_IpUserVal
		Set IpDateVals=IpDateVals_"^"_IpDateVal
	}
		
	Set:aPrintType="1" ^TMP($zn,$j,NIndex,"IExAItem",1)=IpID1_"^"_IpDesc1_"^"_IpID2_"^"_IpCode2_"^"_IpDesc2_"^"_"0^0^0^0^0^0^0^0^0^0^0^0^0^0^0"
	Set ^TMP($zn,$j,NIndex,"IExAItem",2)=IpUserID1_"^"_IpUserDesc1_"^"_IpUserID2_"^"_IpUserCode2_"^"_IpUserDesc2_IpUserVals
	Set ^TMP($zn,$j,NIndex,"IExAItem",3)=IpDateID1_"^"_IpDateDesc1_"^"_IpDateID2_"^"_IpDateCode2_"^"_IpDateDesc2_IpDateVals
	
	//4-督查项目
	Set Index=4
	Set IExAItems=..GetIExAItems(aTubeType)
	For xID=1:1:$l(IExAItems,"#"){
		Set ItemData=$p(IExAItems,"#",xID)
		Continue:ItemData=""
		
		Set DicTypeID=$p(ItemData,"^",1)	
		Set DicTypeCode=$p(ItemData,"^",2)
		Set DicTypeDesc=$p(ItemData,"^",3)
		Set DicID=$p(ItemData,"^",4)
		Set DicCode=$p(ItemData,"^",5)
		Set DicDesc=$p(ItemData,"^",6)
		
		Set ItemVals=""					//存储项目值
		for xDay=StartDay:1:EndDay{
			Set ItemVal=""
			
			Set ExtID=$o(^DHCHAI.IR.ICUIExAExtI("ChildExt","IndexIExADateItem",aIExAID,xDay,DicID,""))
			If (ExtID'=""){
				Set ExtObj=##class(DHCHAI.IR.ICUIExAExt).GetObjById(aIExAID_"||"_ExtID)
				If ($ISObject(ExtObj)){
					Set ItemVal=ExtObj.IExAItemVal
					If (aPrintType="2"){		//打印
						Set:ItemVal="1" ItemVal="√"
						Set:ItemVal="-1" ItemVal="×"
						Set:ItemVal="0" ItemVal=""
					}
				}
			}
			Set ItemVals=ItemVals_"^"_ItemVal
		}
		Set:ItemVals'="" ItemVals=$e(ItemVals,2,$l(ItemVals))
		//存储数据
		Set ^TMP($zn,$j,NIndex,"IExAItem",Index)=DicTypeID_"^"_DicTypeDesc_"^"_DicID_"^"_DicCode_"^"_DicDesc_"^"_ItemVals
		Set Index=Index+1
	}
	
	//扩展数据(用于打印)
	Set IntuDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IntuDate)	//转化日期
	Set PrintData=$lb(PatName,MrNo,Diag,IntuTypeDesc,IntuDate,RetReasonDesc)
	
	//输出数据
	Set xIndex=""
	For{
		Set xIndex=$o(^TMP($zn,$j,NIndex,"IExAItem",xIndex))
		Quit:xIndex=""
		
		Set IExAInfo=$g(^TMP($zn,$j,NIndex,"IExAItem",xIndex))
		
		Set DicTypeID=$P(IExAInfo,"^",1)		//项目类型
		Set DicTypeDesc=$P(IExAInfo,"^",2)
		Set DicID=$P(IExAInfo,"^",3)			//项目
		Set DicCode=$P(IExAInfo,"^",4)
		Set DicDesc=$P(IExAInfo,"^",5)
		
		Set ItemVal1=$P(IExAInfo,"^",6)
		Set ItemVal2=$P(IExAInfo,"^",7)
		Set ItemVal3=$P(IExAInfo,"^",8)
		Set ItemVal4=$P(IExAInfo,"^",9)
		Set ItemVal5=$P(IExAInfo,"^",10)
		Set ItemVal6=$P(IExAInfo,"^",11)
		Set ItemVal7=$P(IExAInfo,"^",12)
		Set ItemVal8=$P(IExAInfo,"^",13)
		Set ItemVal9=$P(IExAInfo,"^",14)
		Set ItemVal10=$P(IExAInfo,"^",15)
		Set ItemVal11=$P(IExAInfo,"^",16)
		Set ItemVal12=$P(IExAInfo,"^",17)
		Set ItemVal13=$P(IExAInfo,"^",18)
		Set ItemVal14=$P(IExAInfo,"^",19)
		Set ItemVal15=$P(IExAInfo,"^",20)
		// 输出数据添加StaDay，使导出表单的日期随配置显示
		Set Data=PrintData_$lb(DicTypeID,DicTypeDesc,DicID,DicCode,DicDesc,ItemVal1,ItemVal2,ItemVal3,ItemVal4,ItemVal5,ItemVal6,ItemVal7,ItemVal8,ItemVal9,ItemVal10,ItemVal11,ItemVal12,ItemVal13,ItemVal14,ItemVal15)_$lb(StaDay)
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryIExARepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAISByMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryIExARepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAISByMonthExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// (2021-12-17最新版-优化)
/// 1.取数据Get方法
/// Creator：     ShenC
/// CreatDate：   2021-01-29
/// Description:  获取插拔管评估相关信息
/// Input：       aIExAID
/// Return:		  ret()
/// w ##class(DHCHAI.IRS.ICUIExASrv).GetIExAInfo("1")
ClassMethod GetIExAInfo(aIExAID As %String) As %String
{
	new (aIExAID)
	Set Ret=""
	Quit:aIExAID="" Ret
	
	Set IExAData=$g(^DHCHAI.IR.ICUIExAD(aIExAID))
	Quit:IExAData="" Ret
	
	//病人基本信息
	Set EpisodeID=$li(IExAData,2)			//就诊号	
	Quit:EpisodeID="" Ret	
	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeID))
	Quit:PAAdmData="" Ret
	
	Set PatName = $li(PAAdmData,6)			//姓名
	Set Sex = $li(PAAdmData,7)				//性别
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	Set Age = $li(PAAdmData,37)				//年龄
	Set PapmiNo = $li(PAAdmData,4)			//登记号
	Set MrNo = $li(PAAdmData,5)				//病案号
	Set AdmDate = $li(PAAdmData,20)			//入院日期
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmLocDr = $li(PAAdmData,22)		//就诊科室
	Set AdmLocDesc=""
	Set LocData = $g(^DHCHAI.BT.LocationD(AdmLocDr))
	If LocData'="" {
		Set LocDesc2 = $li(LocData,4)
		Set LocDesc  = $li(LocData,3)
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set DischDate = $li(PAAdmData,26)		//出院日期
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischLocDr = $li(PAAdmData,28)		//出院病区
    Set LocData=""
    If (DischLocDr'="") {
    	Set LocData = $g(^DHCHAI.BT.LocationD(DischLocDr))
    }
	Set DischLocDesc=""
	If LocData'="" {
		Set LocDesc2 = $li(LocData,4)
		Set LocDesc  = $li(LocData,3)
		Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set AdmBedDr = $li(PAAdmData,25)		//床位
	Set AdmBedData=""
	If (AdmBedDr'="") {
		Set AdmBedData=$g(^DHCHAI.BT.PACBedD(AdmBedDr))
	}
	Set AdmBed=""
	If AdmBedData'="" {
		Set AdmBed = $li(AdmBedData,3)
	}
	Set Diag=""								//诊断		
	Set Diag=##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(EpisodeID,"M")	
	Set:Diag="" Diag=##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(EpisodeID,"DIS")
	Set:Diag="" Diag=##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(EpisodeID,"C008")
	Set:Diag="" Diag=##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(EpisodeID,"PRE")
	
	Set PatData=EpisodeID_"^"_PatName_"^"_Sex_"^"_Age_"^"_PapmiNo_"^"_MrNo_"^"_AdmDate
		_"^"_AdmLocDesc_"^"_DischDate_"^"_DischLocDesc_"^"_Diag
	
	//插拔管基本信息
	Set IntuTypeID=$li(IExAData,3)								//'插管类型'字典ID
	Quit:IntuTypeID="" Ret
	Set DicData=$g(^DHCHAI.BT.DictionaryD(IntuTypeID))			//'插管类型'字典
	Quit:DicData="" Ret
	Set DicTypeID=$li(DicData,4)								//'插管类型'字典分类ID
	Quit:DicTypeID="" Ret
	Set DicTypeData=$g(^DHCHAI.BT.DicTypeD(DicTypeID))			//'插管类型'字典分类字典
	Quit:DicTypeData="" Ret
	Set DicTypeCode=$li(DicTypeData,2)							//'插管类型'字典分类字典Code[IExAPICCTubeType]
	
	Set TubeType=""									//插管类别[PICC/VAP/UC]
	Set:DicTypeCode["PICC" TubeType="PICC"
	Set:DicTypeCode["VAP" TubeType="VAP"
	Set:DicTypeCode["UC" TubeType="UC"
	
	Set IntuTypeID=IntuTypeID						//'插管类型'字典ID
	Set IntuTypeDesc=$li(DicData,2)					//'插管类型'字典Code
	Set IntuTypeDesc=$li(DicData,3)					//'插管类型'字典Desc
	
	Set IntuDate=$li(IExAData,4)					//插管日期
	Set:IntuDate'="" IntuDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IntuDate)
	Set ExtuDate=$li(IExAData,5)					//拔管日期
	Set:ExtuDate'="" ExtuDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ExtuDate)
	
	Set IADays=0									//插管天数(拔管日期-插管日期+1)[置管当天算插管一天]
	Set StartDate=$li(IExAData,4)
	Set EndDate=$li(IExAData,5)	
	Set:EndDate="" EndDate=+$h
	Set IADays=EndDate-StartDate+1
	
	//当前页 开始~结束
	Set IPStaDay=##class(DHCHAI.BT.Config).GetValByCode("IExAStartDay")		//取配置数据
	Set StaDay=""
	Set:DicTypeCode["PICC" StaDay=$p(IPStaDay,"-",1)
	Set:DicTypeCode["VAP" StaDay=$p(IPStaDay,"-",2)
	Set:DicTypeCode["UC" StaDay=$p(IPStaDay,"-",3)
	Set Page=1										//打开页[总页数](默认第一页)(入院48小时后评估)
	Set Page=((IADays-StaDay)\15)+1		
	
	//插管感染基本信息(5-肺炎|6-上呼吸道...)
	Set InfList=""
	Set InfPosDescs =##class(DHCHAI.STATV2.AbstractComm).GetInfPosInfo(EpisodeID,StartDate,EndDate)
	if (InfPosDescs'="") {
		for InfNo=1:1:$L(InfPosDescs,"|") {
			Set InfPosMsg=$p(InfPosDescs,"|",InfNo)
			continue:InfPosMsg=""
				
			Set PosId	= $p(InfPosMsg,"^",1)
			Set PosDescs = $p(InfPosMsg,"^",2)
			Set InfDate	= $p(InfPosMsg,"^",3)
			Set InfType	= $p(InfPosMsg,"^",7)
			Continue:InfType="社区感染"
			
			Set InfPos=##class(DHCHAI.IR.INFDiagnos).GetObjById(PosId)
			Set InfSubDiag=InfPos.IRInfSubDr.BTDesc
			Continue:(TubeType="PICC")&&(InfSubDiag'["CLABSI") 
			Continue:(TubeType="UC")&&(InfSubDiag'["CA-UTI")
			Continue:(TubeType="VAP")&&(InfSubDiag'["VAP")
				
			Set InfDay=InfDate-StartDate
			Set InfList=InfList_"|"_InfDay_"-"_PosDescs
		}
	}
	
	Set IExAData=IntuTypeID_"^"_IntuTypeDesc_"^"_IntuDate_"^"_ExtuDate_"^"_IADays_"^"_InfList_"^"_Page
	
	Quit PatData_"#"_TubeType_"#"_IExAData
}

/// Creator：     ShenC
/// CreatDate：   2020-10-12
/// Description:  获取患者插拔管评估表数目(PICC^VAP^UC)
/// Input：       aEpisodeID
/// Return:		  ret
/// w ##class(DHCHAI.IRS.ICUIExASrv).GetIExARepCount(7500)
ClassMethod GetIExARepCount(aEpisodeID As %String) As %String
{
	new (aEpisodeID)
	Set Ret=""
	Quit:(aEpisodeID="") Ret
	//静脉导管+呼吸机+导尿管 评估表数目
	Set PICCCount=0,VAPCount=0,UCCount=0
	
	//循环插拔管评估表
	Set xIExAID=""
	For{
		Set xIExAID=$o(^DHCHAI.IR.ICUIExAI("IndexEpisodeDr",aEpisodeID,xIExAID))
		Quit:xIExAID=""
		
		Set obj=##class(DHCHAI.IR.ICUIExA).GetObjById(xIExAID)
		Continue:'$IsObject(obj)
		//过滤无效数据
		Set IsActive=obj.IExAIsActive
		Continue:IsActive'=1
		
		Set IntuTypeDr=obj.IExAIntuTypeDr		//'评估表'插管类别字典
		Continue:'$IsObject(IntuTypeDr)
		Set DicTypeDr=IntuTypeDr.BTTypeDr			//'评估表'插管类别字典分类
		Continue:'$IsObject(DicTypeDr)
		
		Set DicTypeCode=DicTypeDr.BTCode			//字典分类Code[IExAPICCTubeType]
		
		Set:DicTypeCode["PICC" PICCCount=PICCCount+1
		Set:DicTypeCode["VAP" VAPCount=VAPCount+1
		Set:DicTypeCode["UC" UCCount=UCCount+1
	}
	Quit PICCCount_"^"_VAPCount_"^"_UCCount
}

/// Creator：     ShenC
/// CreatDate：   2020-08-17
/// Description:  获取插拔管评估表项目
/// Table：       DHCHAI.IR.ICUExA
/// Input:        aTubeType
///  w ##class(DHCHAI.IRS.ICUIExASrv).GetIExAItems("PICC")
ClassMethod GetIExAItems(aTubeType As %String) As %String
{
	new (aTubeType)
	Set Ret=""
	Quit:aTubeType="" Ret
	
	//定义临时Global
	Set NIndex="GetIExAItems"
	Kill ^TMP($zn,$j,NIndex)
	
	//循环字典
	Set xDicTypeCode=""
	For{
		Set xDicTypeCode=$o(^DHCHAI.BT.DicTypeI("IdxofCode",xDicTypeCode))
		Quit:xDicTypeCode=""
		
		Continue:xDicTypeCode'[("IExA"_aTubeType)
		Continue:xDicTypeCode=("IExA"_aTubeType_"TubeType")		//排除插管类别
		Continue:xDicTypeCode=("IExA"_aTubeType_"RetReason")	//排除留置原因
		
		Set DicTypeID=$o(^DHCHAI.BT.DicTypeI("IdxofCode",xDicTypeCode,""))	//字典分类ID
		Continue:DicTypeID=""
		Set DicTypeDesc=$li(^DHCHAI.BT.DicTypeD(DicTypeID),3)				//字典分类描述
		Set:DicTypeDesc["]" DicTypeDesc=$p(DicTypeDesc,"]",2)
		Set:DicTypeDesc["(" DicTypeDesc=$p(DicTypeDesc,"(",1)
		
		Set xDicCode=""
		For{
			Set xDicCode=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",DicTypeID,xDicCode))
			Quit:xDicCode=""
		
			Set DicID=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",DicTypeID,xDicCode,""))		//字典ID
			Continue:DicID=""
			
			Set DicData=$g(^DHCHAI.BT.DictionaryD(DicID))
			Continue:DicData=""
			
			Set DicCode=xDicCode										//字典代码
			Set DicDesc=$li(DicData,3)									//字典名称
			Set IndNo=$li(DicData,5)									//排序码
			//排序码为空(往下依次显示)
			Set:IndNo="" IndNo="99"	
			
			Set ^TMP($zn,$j,NIndex,"IndNo",DicTypeID,IndNo,DicID)=DicTypeID_"^"_xDicTypeCode_"^"_DicTypeDesc_"^"_DicID_"^"_DicCode_"^"_DicDesc
		}
		
	}
	//按排序码输出数据
	Set IExAItems=""
	Set xDicTypeID=""
	For{
		Set xDicTypeID=$o(^TMP($zn,$j,NIndex,"IndNo",xDicTypeID))
		Quit:xDicTypeID=""
		
		Set xIndNo=""
		for{
			Set xIndNo=$o(^TMP($zn,$j,NIndex,"IndNo",xDicTypeID,xIndNo))
			Quit:xIndNo=""
		
			Set xDicID=""
			For{
				Set xDicID=$o(^TMP($zn,$j,NIndex,"IndNo",xDicTypeID,xIndNo,xDicID))
				Quit:xDicID=""
			
				Set Data=$g(^TMP($zn,$j,NIndex,"IndNo",xDicTypeID,xIndNo,xDicID))
				Continue:Data=""
			
				Set DicTypeID	=$p(Data,"^",1)
				Set DicTypeCode	=$p(Data,"^",2)
				Set DicTypeDesc	=$p(Data,"^",3)
				Set DicID	=$p(Data,"^",4)
				Set DicCode	=$p(Data,"^",5)
				Set DicDesc	=$p(Data,"^",6)
			
				Set IExAItems=IExAItems_"#"_DicTypeID_"^"_DicTypeCode_"^"_DicTypeDesc_"^"_DicID_"^"_DicCode_"^"_DicDesc
			}
		}
	}
	
	Set:IExAItems'="" IExAItems=$e(IExAItems,2,$l(IExAItems))
	
	Kill ^TMP($zn,$j,NIndex)
	Quit IExAItems
}

/// Creator：     ShenC
/// CreatDate：   2020-08-17
/// Description:  获取某日期N天的日期       
/// Input:        aNowDate,aSubDay
/// w ##class(DHCHAI.IRS.ICUIExASrv).GetAfterDate("2021-12-01",3)
ClassMethod GetAfterDate(aNowDate As %String, aSubDay As %String) As %String
{
	new (aNowDate,aSubDay)
	Quit:(aNowDate="")||(aSubDay="") ""
	
	Set aNowDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aNowDate)
	//注:插管一天记为当天(例:12-01号置管,插管一天也就是12-01)
	Set Date=aNowDate+aSubDay-1
	Set:Date'="" Date=$zd(Date,3)
	
	Quit Date
}

/// Creator：     ShenC
/// CreatDate：   2020-08-17
/// Description:  判断第aDay天是否评估       
/// Input:        aIExAID,aDay
/// w ##class(DHCHAI.IRS.ICUIExASrv).GetIsAssertByDay("593",3)
ClassMethod GetIsAssertByDay(aIExAID As %String, aDay As %String) As %String
{
	new (aIExAID,aDay)
	Quit:(aIExAID="")||(aDay="") ""
	
	Set IsNeedAssert=$o(^DHCHAI.IR.ICUIExAExtI("ChildExt","IndexIExADateItem",aIExAID,aDay,""))
	
	Set:IsNeedAssert'="" IsNeedAssert=1	//已评估
	Set:IsNeedAssert="" IsNeedAssert=0	//未评估
	Quit IsNeedAssert
}

/// 2.加载数据Query
/// Creator：     ShenC
/// CreatDate：   2020-08-14
/// Description:  加载插拔管数据(插管类别/留置原因/防控措施/拔管指征/评估结论...)
/// Table：       DHCHAI.BT.Dictionary
/// Input:        aRepType[报告类型(1:ICU模板,2:NICU模板)]
/// 			  aTubeType[插管类型(PICC:静脉插管,VAP:呼吸机,UC:导尿管)]
/// 			  aItemCode[数据类型(TubeType:插管类别,RetReason:留置原因,Item1:防控措施,Item2:拔管指征,EvalCon:评估结论)]
/// 			  aIExAID[报告ID]
/// Return：	  ID^Code^Desc^IsCheck
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.ICUIExASrv","QryDicList","1","PICC","RetReason","33")
Query QryDicList(aRepType As %String, aTubeType As %String, aItemCode As %String, aIExAID As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsCheck:%String") [ SqlProc ]
{
}

ClassMethod QryDicListExecute(ByRef qHandle As %Binary, aRepType As %String, aTubeType As %String, aItemCode As %String, aIExAID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aRepType="")||(aTubeType="")||(aItemCode="") $$$OK
	
	//定义临时Global
	Set NIndex="QryDicList"
	Kill ^TMP($zn,$j,NIndex)
	
	//字典类别(IEXA_PICC_TubeType)
	Set DicTypeCode=""
	Set:aRepType="1" DicTypeCode="IExA"_aTubeType_aItemCode	
	Set:aRepType="2" DicTypeCode="NIExA"_aTubeType_aItemCode
	Quit:DicTypeCode="" $$$OK
	
	Set objDicType=##class(DHCHAI.BT.DicType).GetObjByCode(DicTypeCode)
	Quit:'$ISObject(objDicType) $$$OK
	Set DicTypeID=objDicType.%Id()
	
	//循环字典
	Set xCode=""
	for{
		Set xCode=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",DicTypeID,xCode))
		Quit:xCode=""
		
		Set DicID=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",DicTypeID,xCode,""))		//字典ID
		Continue:DicID=""
		
		Set DicCode=xCode										//字典代码
		Set DicDesc=$li(^DHCHAI.BT.DictionaryD(DicID),3)		//字典名称
		Set IndNo=$li(^DHCHAI.BT.DictionaryD(DicID),5)			//排序码
		//排序码为空(往下依次显示)
		Set:IndNo="" IndNo="99"	
		
		//是否勾选(只针对插管类别+留置原因)
		Set IsCheck=0
		If ((aIExAID'="")&&((aItemCode="TubeType")||(aItemCode="RetReason"))){
			Set IExAData=$g(^DHCHAI.IR.ICUIExAD(aIExAID))
			Continue:IExAData=""
			
			If (aItemCode="TubeType"){
				Set IntuTypeID=$li(IExAData,3)
				Set:IntuTypeID=DicID IsCheck=1
			}
			If (aItemCode="RetReason"){
				Set RetReasons=$li(IExAData,6)
				For xInd=1:1:$l(RetReasons,","){
					Set RetReason=$p(RetReasons,",",xInd)
					Set:RetReason=DicID IsCheck=1
					Quit:IsCheck=1
				}
			}
		}
		//存储数据
		Set ^TMP($zn,$j,NIndex,"TubeType",IndNo,DicID)=DicID_"^"_DicCode_"^"_DicDesc_"^"_IsCheck
	}
	
	//按排序码输出数据
	Set xIndNo=""
	for{
		Set xIndNo=$o(^TMP($zn,$j,NIndex,"TubeType",xIndNo))
		Quit:xIndNo=""
		
		Set xDicID=""
		For{
			Set xDicID=$o(^TMP($zn,$j,NIndex,"TubeType",xIndNo,xDicID))
			Quit:xDicID=""
			
			Set Data=$g(^TMP($zn,$j,NIndex,"TubeType",xIndNo,xDicID))
			Continue:Data=""
			Set DicID	=$p(Data,"^",1)
			Set DicCode	=$p(Data,"^",2)
			Set DicDesc	=$p(Data,"^",3)
			Set IsCheck =$p(Data,"^",4)
			//多语言处理
			Set DicDesc= ##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",DicDesc,"DHCHAI.BT.Dictionary")
			Set Data=$lb(DicID,DicCode,DicDesc,IsCheck)
			Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1	
		}
	}
	Quit $$$OK
}

ClassMethod QryDicListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDicListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     ShenC
/// CreatDate：   2020-09-10
/// Description:  加载患者插拔管评估表列表
/// Table：       DHCHAI.IR.ICUIExA
/// Input：       aEpisodeID:就诊号,aTubeType:置管类型(PICC,UC,VAP)
/// Return：      ret
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.ICUIExASrv","QryIExARepList",3510,"VAP",1)
Query QryIExARepList(aEpisodeID As %String, aTubeType As %String, aIsALL As %String) As %Query(ROWSPEC = "IExAID:%String,DicID:%String,DicDesc:%String,IntuDate:%String,ExtuDate:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod QryIExARepListExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aTubeType As %String, aIsALL As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="")||(aTubeType="") $$$OK
	//循环评估表
	Set xIExAID=""
	for{
		Set xIExAID=$o(^DHCHAI.IR.ICUIExAI("IndexEpisodeDr",aEpisodeID,xIExAID))
		Quit:xIExAID=""
		
		Set IExAObj=##class(DHCHAI.IR.ICUIExA).GetObjById(xIExAID)
		Continue:'$ISObject(IExAObj)
		
		Set DicDr=IExAObj.IExAIntuTypeDr					//插管类别字典
		Continue:'$ISObject(DicDr)
		Set DicTypeDr=DicDr.BTTypeDr						//插管类别字典分类
		Continue:'$ISObject(DicTypeDr)
		
		Set DicTypeCode=DicTypeDr.BTCode
		//过滤插管类型
		Continue:DicTypeCode'[aTubeType		
		
		Set DicID=DicDr.%Id()								//字典ID
		Set DicDesc=DicDr.BTDesc							//字典描述
		
		Set IntuDate=IExAObj.IExAIntuDate					//插管日期
		Set ExtuDate=IExAObj.IExAExtuDate					//拔管日期
		Set IsActive=IExAObj.IExAIsActive					//是否有效
		Continue:(aIsALL'="1")&&(IsActive'=1)
		//转化日期
		Set:IntuDate'="" IntuDate=$zd(IntuDate,3)
 		Set:ExtuDate'="" ExtuDate=$zd(ExtuDate,3)
		
		Set Data=$lb(xIExAID,DicID,DicDesc,IntuDate,ExtuDate,IsActive)
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1	
	}
	Quit $$$OK
}

ClassMethod QryIExARepListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIExARepListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryIExARepListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIExARepListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 3.加载表格Query
/// Creator：     ShenC
/// CreatDate：   2020-08-26
/// Description:  查询插拔管科室患者列表
/// Table：       DHCHAI.IR.ICUExA
/// Input：       aStatus:患者状态(在院(0)/出院(1)),aDateFrom:开始日期,aDateTo:结束日期,
/// 			  aTubeType:插管类型(PICC/VAP/UC),aWardID:病区ID
/// Return：      ret
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.ICUIExASrv","QryIExA","2022-07-18","2022-07-18","ALL",28)
Query QryIExA(aDateFrom As %String, aDateTo As %String, aTubeType As %String, aWardID As %String) As %Query(ROWSPEC = "PatientIDx:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,TransLocDesc:%String,TransDate:%String,OutLocDate:%String,Diag:%String,InfTube:%String,PICCData:%String,VAPData:%String,UCData:%String") [ SqlProc ]
{
}

ClassMethod QryIExAExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aTubeType As %String, aWardID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//输出列--前台可自定义显示列+顺序
	//就诊号HIS(PatientID),就诊号(EpisodeID),登记号(PapmiNo),病案号(MrNo),姓名(PatName),年龄(Sex),就诊类型(AdmType),就诊状态(VisitStatus),入院日期时间(AdmDateTime),
	//入院科室(AdmLocDesc),入院病区(AdmWardDesc),入院房间号(AdmRoom),入院床号(AdmBed),出院日期时间(DischDateTime),出院科室(DischLocDesc),出院病区(DischWardDesc)
	//转科ID(TransID),转科科室(TransLocDesc),转科日期(TransDate),出科日期(OutLocDate)
	//诊断(Diag),插管感染(InfTube)
	//静脉插管(PICCData),呼吸机(VAPData),导尿管(UCData)
	
	Quit:(aDateFrom="")||(aDateTo="")||(aWardID="") $$$OK
	
	//转换日期
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	//定义临时Global
	Set NIndex="QryIExA"
	Kill ^TMP($zn,$j,NIndex)
	
	//日期范围内在科患者(与ICU日志保持统一)(一个日期对应一条记录)[$lb("65650","8891","O","28","35629")]
	Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"W",aWardID,"I")
    For index=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index)
		Continue:TransInfo=""
		
		Set EpisodeID	= $listget(TransInfo,2)				//就诊号
		//过滤重复病人
		Continue:$d(^TMP($zn,$j,NIndex,"AdmPat",EpisodeID))
		Set ^TMP($zn,$j,NIndex,"AdmPat",EpisodeID)=""		
		
		Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeID))
		Continue:AdmData=""
		Set Status    	= $listget(TransInfo,3)				//状态(A:在科,A2:当天入当天出,I:入科,O:出科)
		//过滤状态
		Continue:(Status'="A")&&(Status'="I")&&(Status'="O")&&(Status'="A2")  
		
		//1.患者基本信息
		Set PatData =##class(DHCHAI.STATV2.AbstractComm).BuildPaadmData(EpisodeID)
	    Continue:PatData=""
	    Set PatientIDx=$li(AdmData,3)						//HIS就诊号
	    Set PatData=$lb(PatientIDx)_PatData
	    
		//2.转科基本信息
		Set TransID		= $listget(TransInfo,5)				//转科ID
		Continue:TransID=""
		Set TransData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
		Continue:TransData=""
		Set TransDate	= $li(TransData,7)				//转科日期
		Set OutLocDate	= $li(TransData,10)				//出科日期
		
		Set TransInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeID,TransDate,"")
		Set BedDesc="",TransLocDesc=""
		Set:TransInfo'="" TransBedDesc=$p(TransInfo,"^",4)	//床位号
		Set:TransInfo'="" TransLocDesc=$p(TransInfo,"^",7)	//所在科室[调查日]
		
		Set TransData=$lb(TransID,TransLocDesc,TransDate,OutLocDate)
		
		//3.诊断基本信息[M主要诊断  C008入院诊断  PRE初步诊断 DIS出院诊断]
		Set Diag=##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(EpisodeID,"M")
		Set:Diag="" Diag=##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(EpisodeID,"DIS")
		Set:Diag="" Diag=##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(EpisodeID,"C008")
		Set:Diag="" Diag=##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(EpisodeID,"PRE")
		
		//4.插管感染基本信息[2020-01-01:呼吸机相关肺炎][住院期间]
		Set InfTube=""
		Set StartDate=$li(AdmData,20)		//开始(入院)日期
		Set EndDate=$li(AdmData,26)		//结束(出院)日期
		Set:EndDate="" EndDate=+$h
		
		Set InfPosDescs =##class(DHCHAI.STATV2.AbstractComm).GetInfPosInfo(EpisodeID,StartDate,EndDate)
		if (InfPosDescs'="") {
			for InfNo=1:1:$L(InfPosDescs,"|") {
				Set InfPosMsg=$p(InfPosDescs,"|",InfNo)
				continue:InfPosMsg=""
				
				Set InfType	= 	$p(InfPosMsg,"^",7)
				Continue:InfType="社区感染"
				
				Set PosID		=	$p(InfPosMsg,"^",1)
				Set PosDescs 	= 	$p(InfPosMsg,"^",2)
				Set InfPos=##class(DHCHAI.IR.INFDiagnos).GetObjById(PosID)
				Set InfSubDiag=InfPos.IRInfSubDr.BTDesc
				
				Continue:(InfSubDiag'["CLABSI")&&(InfSubDiag'["CA-UTI")&&(InfSubDiag'["VAP")	//插管相关感染
				
				Set InfDate	= $p(InfPosMsg,"^",3)
				Set:InfDate'="" InfDate=$zd(InfDate,3)
				
				Set InfTube=InfTube_","_InfDate_":"_PosDescs
			}
		}
		Set:InfTube'="" InfTube=$e(InfTube,2,$l(InfTube))
		
		//5.插拔管基本信息
		Set PICCData="",VAPData="",UCData=""
		Set xIExAID=""
		For{
			Set xIExAID=$o(^DHCHAI.IR.ICUIExAI("IndexEpisodeDr",EpisodeID,xIExAID))
			Quit:xIExAID=""

			Set IExAData=$g(^DHCHAI.IR.ICUIExAD(xIExAID))
			Continue:IExAData=""
			//过滤无效数据
			Set IsActive=$li(IExAData,7)		
			Continue:IsActive'=1	
				
			Set IntuTypeID=$li(IExAData,3)								//'插管类型'字典ID
			Continue:IntuTypeID=""
			Set DicData=$g(^DHCHAI.BT.DictionaryD(IntuTypeID))			//'插管类型'字典
			Continue:DicData=""
			Set DicTypeID=$li(DicData,4)								//'插管类型'字典分类ID
			Continue:DicTypeID=""
			Set DicTypeData=$g(^DHCHAI.BT.DicTypeD(DicTypeID))			//'插管类型'字典分类字典
			Continue:DicTypeData=""
			Set DicTypeCode=$li(DicTypeData,2)							//'插管类型'字典分类字典Code[IExAPICCTubeType]
	
			Set IAIntuDate=$li(IExAData,4)								//插管日期
			Set IAExtuDate=$li(IExAData,5)								//拔管日期
			
			Set IAStartDate=IAIntuDate,IAEndDate=IAExtuDate
			Set:IAEndDate="" IAEndDate=+$h
			Set IADays=(IAEndDate-IAStartDate)							//插管天数
			//是否需评估(插管后48小时开始)
			Set IsNeedAssert=0
			For xDay=2:1:IADays{
				Set xExtID=$o(^DHCHAI.IR.ICUIExAExtI("ChildExt","IndexIExADateItem",xIExAID,xDay,""))
				
				Set:xExtID="" IsNeedAssert=1
				Quit:IsNeedAssert=1	
			}
			
			Set IATypeID=IntuTypeID									//插管类型ID(699)
			Set IATypeDesc=$li(DicData,3)							//插管类型(股静脉)
			Set:IAIntuDate'="" IAIntuDate=$zd(IAIntuDate,3)			//转换日期
			Set:IAExtuDate'="" IAExtuDate=$zd(IAExtuDate,3)
			
			If (DicTypeCode["PICC"){
				Set PICCData=PICCData_"^"_xIExAID_"|"_IATypeID_"|"_IATypeDesc_"|"_IAIntuDate_"|"_IAExtuDate_"|"_IsNeedAssert
			}
			elseif(DicTypeCode["VAP"){
				Set VAPData=VAPData_"^"_xIExAID_"|"_IATypeID_"|"_IATypeDesc_"|"_IAIntuDate_"|"_IAExtuDate_"|"_IsNeedAssert
			}
			elseif(DicTypeCode["UC"){
				Set UCData=UCData_"^"_xIExAID_"|"_IATypeID_"|"_IATypeDesc_"|"_IAIntuDate_"|"_IAExtuDate_"|"_IsNeedAssert
			}
		}
		Set:PICCData'="" PICCData=$e(PICCData,2,$l(PICCData))
		Set:VAPData'="" VAPData=$e(VAPData,2,$l(VAPData))
		Set:UCData'="" UCData=$e(UCData,2,$l(UCData))
		//过滤置管类型
		Continue:(aTubeType="PICC")&&(PICCData="")
		Continue:(aTubeType="VAP")&&(VAPData="")
		Continue:(aTubeType="UC")&&(UCData="")
		
		Set:PICCData="" PICCData="首次评估"
		Set:VAPData="" VAPData="首次评估"
		Set:UCData="" UCData="首次评估"
		
		//输出数据
		Set Data=PatData_TransData_$lb(Diag)_$lb(InfTube)_$lb(PICCData,VAPData,UCData)
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1	
    }
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryIExAClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAISByMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryIExAFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAISByMonthExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 4.保存表
/// Creator：     ShenC
/// CreatDate：   2020-10-12
/// Description:  保存插拔管评估表留置原因
/// Input：       aIExAID,aRetReason
/// Return:		  ret
/// w ##class(DHCHAI.IRS.ICUIExASrv).SaveRetReason(1,"679|680")
ClassMethod SaveRetReason(aIExAID As %String, aRetReason As %String) As %String
{
	new (aIExAID,aRetReason)
	Set Ret=""
	Quit:aIExAID="" Ret
	//打开插拔管评估表
	Set obj=##class(DHCHAI.IR.ICUIExA).%OpenId(aIExAID)
	Quit:'$IsObject(obj) Ret
	
	Set obj.IExARetReason=aRetReason
	//关闭插拔管评估表
	Do obj.%Close()
	
	Set Ret=aIExAID
	Quit Ret
}

/// Creator：     ShenC
/// CreatDate：   2020-08-30
/// Description:  保存插拔管评估明细表
/// Table：       DHCHAI.IR.ICUExAExt
/// Input：       aInputStr
/// Return:		  return>0:成功、return<1:失败 
/// w ##class(DHCHAI.IRS.ICUIExASrv).SaveIExAExt("33^^1799^12^1^1197")
ClassMethod SaveIExAExt(aInputStr As %String) As %String
{
	new (aInputStr)
	Set Ret="-1"
	Quit:aInputStr="" Ret
	
	Set Parref=$p(aInputStr,"^",1)						//评估表ID
	Quit:Parref="" Ret
	Set IExAobj= ##class(DHCHAI.IR.ICUIExA).GetObjById(Parref)
	Quit:'$ISObject(IExAobj) Ret
	
	Set ChildSub	=$p(aInputStr,"^",2)				//明细表ID
	Set ItemID		=$p(aInputStr,"^",3)				//项目ID
	Set Day			=$p(aInputStr,"^",4)				//插管天
	Set ItemVal		=$p(aInputStr,"^",5)				//项目Value
	Set User		=$p(aInputStr,"^",6)				//评估人
	Set UserDate	=+$h								//评估日期
	Set UserTime	=$p($h,",",2)						//评估时间
	//获取明细表ID
	Set ChildSub=$o(^DHCHAI.IR.ICUIExAExtI("ChildExt","IndexIExADateItem",Parref,Day,ItemID,""))
	
	//获取Data
	Set aInputStr=Parref_"^"_ChildSub_"^"_ItemID_"^"_Day_"^"_ItemVal_"^"_User_"^"_UserDate_"^"_UserTime
	//保存评估明细表
	Set Flag=##class(DHCHAI.IR.ICUIExAExt).Update(aInputStr)
	if (Flag>0) {
		Set Ret = Flag
	}
	
	Quit Ret
}

/// Creator：     ShenC
/// CreatDate：   2022-12-27
/// Description:  根据'插管医嘱'自动生成'评估表'
/// Input：       aEpisodeID:就诊号
/// 			  aDateFrom:开始日期
/// 			  aDateTo:结束日期
/// Return:		  ret()
/// w ##class(DHCHAI.IRS.ICUIExASrv).CreateIExAByOEOrd("2020-05-01","2020-05-31","43","W")
ClassMethod CreateIExAByOEOrd(aDateFrom As %String, aDateTo As %String, aLocID As %String, aLocType As %String) As %String
{
	new (aLocID,aLocType,aDateFrom,aDateTo)
	Set Ret=0
	Quit:(aLocID="")||(aDateFrom="")||(aDateTo="")||(aLocType="") return
	//日期格式转换
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	//根据日期查询患者
	If (aLocType="W") {
		Set arrEpisodeDr=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate2(aDateFrom,aDateTo,"W",aLocID,"I")
	}Else {
		Set arrEpisodeDr=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"E",aLocID,"I")
	}
	For indEpis=1:1:arrEpisodeDr.Count() {
		Set TransInfo=arrEpisodeDr.GetAt(indEpis)
		Set EpisodeID = $LIST(TransInfo,2)
		Set LocID = $LIST(TransInfo,4)
		Continue:LocID'=aLocID
		
		//循环'医嘱表'->'就诊医嘱开始日期'索引
		Set xSCode=""
		For {		
			Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",EpisodeID,xSCode))
			Quit:xSCode=""
		
			Set xOrdItemDesc="" 
			For {
				Set xOrdItemDesc=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",EpisodeID,xSCode,xOrdItemDesc))
				Quit:xOrdItemDesc=""
			
				//医嘱对照
				Set objMap=##class(DHCHAI.DP.OEItmMastMap).GetObjByOrdDesc(xSCode,xOrdItemDesc)
				Continue:'$Isobject(objMap)
				Continue:objMap.BTIsActive'=1		//过滤无效数据
				//标准名 泌尿道插管[xOrdItemDesc:留置导尿(次日起)]
				Continue:'$Isobject(objMap.BTMapItemDr) 
				Continue:'$Isobject(objMap.BTMapItemDr.BTCatDr)
				Continue:'$Isobject(objMap.BTMapItemDr.BTCatDr.BTTypeDr) 	//医嘱项类别:DRT 器械相关治疗
				Set OEItemType=objMap.BTMapItemDr.BTCatDr.BTTypeDr.BTCode
				Continue:OEItemType'="DRT"			//过滤'非器械相关治疗'
				Set OEItemCat=objMap.BTMapItemDr.BTCatDr.BTCode
				Continue:$e(OEItemCat,1,6)'="DRT-I-"
				//插管类别(用于'三管感染防控督查表')
				Set objIAType=objMap.BTIExADr
				Continue:'$Isobject(objIAType)
				Set IATypeID=objIAType.%Id()
				
				Set xUpdateDate=""
				For {
					Set xUpdateDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",EpisodeID,xSCode,xOrdItemDesc,xUpdateDate))
					Quit:xUpdateDate=""
				
					Set xOrdItemID ="" 
					For {
						Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",EpisodeID,xSCode,xOrdItemDesc,xUpdateDate,xOrdItemID))
						Quit:xOrdItemID=""
					
						Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xOrdItemID)
						Continue:'$Isobject(objOrdItem)
						Set IsActive=objOrdItem.OEIsActive
						Continue:IsActive'=1					//过滤'无效数据'
					
						Set (OeItemDesc,StartDt,EndDt)=""
						Set OeItemDesc =objOrdItem.OEOrdDesc	//医嘱名	
						//医嘱开始日期
						If (objOrdItem.OESttDate'="") {
							Set StartDt=##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(objOrdItem.OESttDate)
						}
						Continue:StartDt=""
						Continue:(StartDt<aDateFrom)||(StartDt>aDateTo)		//过滤日期
					
						//医嘱结束日期
						If (objOrdItem.OEXDate'=""){
							Set EndDt = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(objOrdItem.OEXDate)
						}	
						Set OEPriority=objOrdItem.OEPriority
						Continue:OEPriority'["长期"				//过滤非长期医嘱
						
						//患者出院日期
						Set DisDate=$lg($g(^DHCHAI.DP.PAAdmD(EpisodeID)),26)
						Set:(DisDate'="")&&(EndDt="") EndDt=DisDate 	//出院未停医嘱,结束日期算到出院日期
					
						Continue:(OEItemCat'["PICC")&&(OEItemCat'["VAP")&&(OEItemCat'["UC")
					
						//患者同一天只置同一种管
						Set IAID=$o(^DHCHAI.IR.ICUIExAI("IndexEpisodeTypeDate",EpisodeID,IATypeID,StartDt,0))
						Continue:IAID'=""
						
						//根据医嘱生成评估表
						Set InputStr="^"_EpisodeID_"^"_IATypeID_"^"_StartDt_"^"_EndDt_"^^1"
					
						Set Flag=##class(DHCHAI.IR.ICUIExA).Update(InputStr)
						If (+Flag)>0 {
							Set Ret=Ret+1
						}		
					}
				}
			}
		}
	}
	Quit Ret
}

/// Creator：     ShenC
/// CreatDate：   2022-12-27
/// Description:  输出'三管感染防控督查表'插管类别(PICC+VAP+UC)
/// Table：       DHCHAI.BT.Dictionary
/// Input:        aTubeType
/// Return：	  
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.ICUIExASrv","QryTubeTypeList","PICC")
Query QryTubeTypeList(aTubeType As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IAType:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod QryTubeTypeListExecute(ByRef qHandle As %Binary, aTubeType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//定义临时Global
	Set NIndex="QryTubeTypeList"
	Kill ^TMP($zn,$j,NIndex)
	
	Set xDicTypeID=""
	For{
		Set xDicTypeID=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",xDicTypeID))
		Quit:xDicTypeID=""
		
		Set DicTypeData=$g(^DHCHAI.BT.DicTypeD(xDicTypeID))
		Continue:DicTypeData=""
		Set DicTypeCode=$lg(DicTypeData,2)
		
		Continue:(DicTypeCode'="IExAPICCTubeType")&&(DicTypeCode'="IExAVAPTubeType")&&(DicTypeCode'="IExAUCTubeType")
		Continue:(aTubeType="PICC")&&(DicTypeCode'="IExAPICCTubeType")
		Continue:(aTubeType="VAP")&&(DicTypeCode'="IExAVAPTubeType")
		Continue:(aTubeType="UC")&&(DicTypeCode'="IExAUCTubeType")
		
		Set xCode=""
		For{
			Set xCode=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",xDicTypeID,xCode))
			Quit:xCode=""
						
			Set DicID=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",xDicTypeID,xCode,""))		//字典ID
			Continue:DicID=""
		
			Set DicCode=xCode										//字典代码
			Set DicDesc=$lg(^DHCHAI.BT.DictionaryD(DicID),3)		//字典名称
			Set IAType=""
			Set:DicTypeCode="IExAPICCTubeType" IAType="血管导管"
			Set:DicTypeCode="IExAVAPTubeType" IAType="呼吸机"
			Set:DicTypeCode="IExAUCTubeType" IAType="导尿管"
			
			Set IsActive=$lg(^DHCHAI.BT.DictionaryD(DicID),6)		//是否有效
			Set IndNo=$lg(^DHCHAI.BT.DictionaryD(DicID),5)			//排序码
			//排序码为空(往下依次显示)
			Set:IndNo="" IndNo="99"	
			
			//存储数据
			Set ^TMP($zn,$j,NIndex,"TubeType",DicTypeCode,IndNo,DicID)=DicID_"^"_DicCode_"^"_DicDesc_"^"_IAType_"^"_IsActive
		}
	}
	
	//按排序码输出数据
	Set xDicCode=""
	For{
		Set xDicCode=$o(^TMP($zn,$j,NIndex,"TubeType",xDicCode))
		Quit:xDicCode=""
			
		Set xIndNo=""
		for{
			Set xIndNo=$o(^TMP($zn,$j,NIndex,"TubeType",xDicCode,xIndNo))
			Quit:xIndNo=""
		
			Set xDicID=""
			For{
				Set xDicID=$o(^TMP($zn,$j,NIndex,"TubeType",xDicCode,xIndNo,xDicID))
				Quit:xDicID=""
			
				Set Data=$g(^TMP($zn,$j,NIndex,"TubeType",xDicCode,xIndNo,xDicID))
				Continue:Data=""
				Set DicID	=$p(Data,"^",1)
				Set DicCode	=$p(Data,"^",2)
				Set DicDesc	=$p(Data,"^",3)
				Set IAType 	=$p(Data,"^",4)
				Set IsActive=$p(Data,"^",5)
				
				Set Data=$lb(DicID,DicCode,DicDesc,IAType,IsActive)
				Set ^CacheTemp(repid,ind)=Data
    			Set ind=ind+1	
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryTubeTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTubeTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTubeTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTubeTypeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
