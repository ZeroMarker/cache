/// 名称：web.INSUDicDataConfig
/// 描述：医保系统参数配置相关操作
/// 编写者：韩智慧
/// 编写日期：2021 03 15
Class web.INSUDicDataConfig Extends %RegisteredObject
{

/// Creator：Hanzh
/// CreatDate：2021 03 15
/// Description:：获取医保系统参数配置数据
/// Table：INSU_DicData
/// Input：InsuType:医保类型;HospId:院区指针(默认为空)
/// Output：配置数据"^"分隔
/// Return：成功：配置数据串，失败：-1
/// Others
/// w ##class(web.INSUDicDataConfig).GetINSUDicDataConfigInfo("00A","2")
ClassMethod GetINSUDicDataConfigInfo(InsuType As %String, HospId As %String = "") As %String
{
	q:InsuType="" -1
	s rtn=""
	
	s DicStr=##class(web.INSUDicDataCom).GetSys("","","HISPROPerty"_InsuType,HospId)
	s DicList=$LISTFROMSTRING(DicStr,"!")
	s count=$LL(DicList)
	f i=2:1:count d
	.s DicInfo=$LIST(DicList,i)
	.s DicType=$p(DicInfo,"^",2)
	.s DicCode=$p(DicInfo,"^",3)
	.s DicDesc=$p(DicInfo,"^",4)
	.i ((DicCode="UpDetailMode")||(DicCode="UpFDetailMode")||(DicCode="AKA130MsgboxFlag")||(DicCode="InsuDivRegFlag")||(DicCode="OPDivFrmType")||(DicCode="optertype")||(DicCode="IsCanDiretCancelMXFlag")||(DicCode="IPRegModIsReadCard")||(DicCode="InsuDesDivReadCardFlag")||(DicCode="InsuDivReadCardFlag")||(DicCode="IsNeedSignOutFlag")||(DicCode="IsNeedSignInFlag")||(DicCode="IPRegDestroyIsReadCard")||(DicCode="Psnsetlway")||(DicCode="IsIPRegShowFlag")||(DicCode="IsOPRegShowFlag")||(DicCode="IsOPPartDivideStrikeShowFlag")||(DicCode="IsOPDivideStrikeShowFlag")||(DicCode="IsOPDivideShowFlag")||(DicCode="IsShowInsuCardInnfoDiagFlag")||(DicCode="IPUseZHFlag")||(DicCode="OPRegUseZHFlag")||(DicCode="OPUseZHFlag")||(DicCode="OPDivPreShw")||(DicCode="NotConstracted")||(DicCode="NotAudit")||(DicCode="NoChecked")||(DicCode="UpdatePatAdmReason")||(DicCode="PaadmConInadmType")||(DicCode="OPStrikeIsReadCard")||(DicCode="OPRegBXFlag")||(DicCode="OPRegDestroyIsReadCard")||(DicCode="isCanReadCardByDLL")||(DicCode="IsCanReadIDCard")||(DicCode="PacAdmreasonConAKA130Flag")||(DicCode="TarContrastAuditFlag")||(DicCode="InsuMsgInfoFlag")||(DicCode="INSUMerges")||(DicCode="INSUBILLDATECTL")||(DicCode="INSUDETDATACTL")||(DicCode="AdmDateCtl")||(DicCode="DischDateCtl")||(DicCode="AdmDateIsEdit")||(DicCode="TariInsuFlag")||(DicCode="OPRegEffecDays")||(DicCode="ICDContrastFlag")||(DicCode="CenterVersion")||(DicCode="IPIsPST")||(DicCode="TariSpecialFlag")||(DicCode="ChkInsuFlagMod")||(DicCode="ZeroOrdIsUpFlag")||(DicCode="OEMainInsCfg")||(DicCode="IsUseFundPaySumamtCTP")||(DicCode="OPDivIsBackALLCTP")||(DicCode="OPRegIsBackALLCTP")||(DicCode="IPDivIsBackALLCTP")||(DicCode="QCChronicFlag")||(DicCode="IPOutRegFlag")||(DicCode="SaveLocalPsnInfo")||(DicCode="IPDivPreShw")||(DicCode="CFTTYPE")||(DicCode="isCheckMACFlag")||(DicCode="InsuHospCode")||(DicCode="InsuHospName")||(DicCode="INSUIP")||(DicCode="MaxRectNum")||(DicCode="MaxRectNumNeg")||(DicCode="MidStartDate")||(DicCode="MidEndDate")||(DicCode="Mistake")||(DicCode="secretKey")||(DicCode="optertype")||(DicCode="InsuCenterNo")||(DicCode="infver")||(DicCode="signtype")||(DicCode="xRioPaasid")||(DicCode="pUrl")||(DicCode="pUser")||(DicCode="CenterNoDefault")||(DicCode="CenterNameDefault")||(DicCode="apiname")||(DicCode="apiversion")||(DicCode="apiaccesskey")||(DicCode="HisSysCode")||(DicCode="infosyscode")||(DicCode="infosysign")||(DicCode="SignMod")||(DicCode="INSUCURRENT")||(DicCode="SpeDiseType")||(DicCode="OPMistake")||(DicCode="IPMistake")) d
	..s rtn=rtn_","_DicType_"^"_DicCode_"^"_DicDesc
	;b ;rtn
	
	s AutoStartINSUService=##class(web.INSUDicDataCom).GetDicByCodeAndInd("SYS","AutoStartINSUService",6,HospId)
	s FilterByTarCate=##class(web.INSUDicDataCom).GetDicByCodeAndInd("SYS","FilterByTarCate",6,HospId)
	s InsuDiscountCtl=##class(web.INSUDicDataCom).GetDicByCodeAndInd("SYS","InsuDiscountCtl",6,HospId)
	s OEMainInsCfg=##class(web.INSUDicDataCom).GetDicByCodeAndInd("SYS","OEMainInsCfg",6,HospId)
	s INSUCONACTDATE=##class(web.INSUDicDataCom).GetDicByCodeAndInd("SYS","INSUCONACTDATE",6,HospId)
	s DBEncryptStr=##class(web.INSUDicDataCom).GetDicByCodeAndInd("SYS","DBEncrypt",0,HospId)
	s rtn=rtn_","_"SYS"_"^"_"AutoStartINSUService"_"^"_AutoStartINSUService_","_"SYS"_"^"_"FilterByTarCate"_"^"_FilterByTarCate_","_
				"SYS"_"^"_"InsuDiscountCtl"_"^"_InsuDiscountCtl_","_"SYS"_"^"_"OEMainInsCfg"_"^"_OEMainInsCfg_","
				_"SYS"_"^"_"INSUCONACTDATE"_"^"_INSUCONACTDATE_","_"SYS"_"^"_"DBEncrypt"_"^"_$p(DBEncryptStr,"^",5)_"^"_$p(DBEncryptStr,"^",6)_"^"_$p(DBEncryptStr,"^",7)_"^"_$p(DBEncryptStr,"^",12)
	
	s DicNmStr=##class(web.INSUDicDataCom).GetSys("","","NormalConfig",HospId)
	s DicNmList=$LISTFROMSTRING(DicNmStr,"!")
	s count=$LL(DicNmList)
	f n=2:1:count d
	.s DicNmInfo=$LIST(DicNmList,n)
	.;b ;01
	.s DicNmType=$p(DicNmInfo,"^",2)
	.s DicNmCode=$p(DicNmInfo,"^",3)
	.s DicNmDesc=$p(DicNmInfo,"^",6)
	.i ((DicNmCode="MsgBoxFlag")||(DicNmCode="InsuLogInsuFlag")||(DicNmCode="InsuLogHisFlag")||(DicNmCode="InsuLogBussFlag")||(DicNmCode="InsuMsgInfoFlag")) d
	..s rtn=rtn_","_DicNmType_"^"_DicNmCode_"^"_DicNmDesc
				
	q rtn
}

/// Creator：Hanzh
/// CreatDate：2021 03 15
/// Description:：获取医保系统参数配置数据
/// Table：INSU_DicData
/// Input：HospId:院区指针(默认为空);InsuType:医保类型
/// Output：配置数据"^"分隔
/// Return：成功：配置数据串，失败：-1
/// Others
/// w ##class(web.INSUDicDataConfig).UptINSUDicDataConfigInfo("2","00A","OPRegEffecDays","1")
ClassMethod UptINSUDicDataConfigInfo(HospId As %String = "", InsuType As %String, Code As %String, Desc As %String) As %String
{
	s flag="-1"
	s ^temp("SaveINSUDicDataConfigInfo")="HospId:"_HospId_"^InsuType:"_InsuType_"^Code:"_Code_"^Desc:"_Desc
	q:(Code="")||(Desc="") flag
	s (DHCINSUDicData,Rowid)=""
	if (Code["SYS"){	
		s Code=$p(Code,"_",1)
		s DHCINSUDicData=$$QueryByCode^DHCINSUDicData("SYS",Code,HospId)
		s Rowid=$p(DHCINSUDicData,"^",1)
		s DicBill1=$p(DHCINSUDicData,"^",6)
		i (Desc'=DicBill1){
			s $p(DHCINSUDicData,"^",6)=Desc	
		}
	}
	else{
		s DHCINSUDicData=$$QueryByCode^DHCINSUDicData("HISPROPerty"_InsuType,Code,HospId)
		q:DHCINSUDicData="" "-1^请在HISPROPerty"_InsuType_"医保配置信息下维护:"_Code_"字典数据"
		s Rowid=$p(DHCINSUDicData,"^",1)
		s DescOld=$p(DHCINSUDicData,"^",4)
		i (Desc'=DescOld){
			s $p(DHCINSUDicData,"^",4)=Desc	
		}
	}
	s rtn=$$Update^DHCINSUDicData(DHCINSUDicData)
	i +rtn>0 s flag=Rowid_"^更新字典数据成功！"
	q flag
}

/// Creator：Hanzh
/// CreatDate：2023 04 14
/// Description:：更新医保系统参数配置数据
/// Table：INSU_DicData
/// Input：HospId:院区指针(默认为空);InsuType:医保类型
/// Output：配置数据"^"分隔
/// Return：成功：配置数据串，失败：-1
/// Others
/// w ##class(web.INSUDicDataConfig).UptConfigInfo("00A","SYS^DBEncrypt^GlobalEMR^_system^1F1810aa^DLL","2")
ClassMethod UptConfigInfo(InsuType As %String, UpdateStr As %String, HospId As %String = "") As %String
{
	s flag="-1"
	;s ^temp("UptConfigInfo20230415")=$lb(InsuType,UpdateStr,HospId)
	q:(InsuType="") "-1!医保类型不能为空"
	q:(UpdateStr="") "-1!更新字典数据不能为空"
	q:(HospId="") "-1!院区指针不能为空"
	k ^CacheTemp("UptConfigInfo",$j)
	s errNum=0
	s num=$L(UpdateStr,",")
	f i=1:1:num   d
	.s UpdateInfo=$p(UpdateStr,",",i)
	.s DicType=$p(UpdateInfo,"^",1)
	.s DicCode=$p(UpdateInfo,"^",2)
	.s DicDesc=$p(UpdateInfo,"^",3)
	.s DHCINSUDicData=$$QueryByCode^DHCINSUDicData(DicType,DicCode,HospId)
	.s:DHCINSUDicData="" flag="-1!请在"_DicType_"医保配置信息下维护:"_DicCode_"字典数据"
	.q:DHCINSUDicData=""
	.s Rowid=$p(DHCINSUDicData,"^",1)
	.b ;01
	.i (DicType="SYS")||(DicType="NormalConfig") d
	..s DicBill1=$p(DHCINSUDicData,"^",6)
	..i DicDesc'=DicBill1 d
	...i DicCode="DBEncrypt" d
	....s $p(DHCINSUDicData,"^",5)=DicDesc
	....s $p(DHCINSUDicData,"^",6)=$p(UpdateStr,"^",4)
	....s $p(DHCINSUDicData,"^",7)=$p(UpdateStr,"^",5)
	....s $p(DHCINSUDicData,"^",12)=$p(UpdateStr,"^",6)
	...e  d
	....s $p(DHCINSUDicData,"^",6)=DicDesc	
	.e  d
	..s DescOld=$p(DHCINSUDicData,"^",4)
	..i (DicDesc'=DescOld) d
	...s $p(DHCINSUDicData,"^",4)=DicDesc
	.s demo=$p(DHCINSUDicData,"^",5)
	.s $p(DHCINSUDicData,"^",5)=$p(DHCINSUDicData,"^",6)
	.s $p(DHCINSUDicData,"^",6)=$p(DHCINSUDicData,"^",7)
	.s $p(DHCINSUDicData,"^",7)=demo
	.s rtn=$$Update^DHCINSUDicData(DHCINSUDicData)
	.;i +rtn>0 s flag=Rowid_"!更新字典数据成功"
	.i +rtn>0 d
	..s ^CacheTemp("UptConfigInfo",$j,"success",Rowid)=DicType_"^"_DicCode
	.e  d
	..s ^CacheTemp("UptConfigInfo",$j,"err",Rowid)=DicType_"^"_DicCode
	..s errNum=errNum+1
	q $j_"!"_num_"^"_(num-errNum)_"^"_errNum
}

}
