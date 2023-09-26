/// 系统参数界面
/// czf 2021-11-17
Class web.DHCEQ.Plat.CTSysSet Extends %RegisteredObject
{

/// 系统参数列表
/// czf 2021-11-17
/// Input:	gHospId:登录医院ID
/// 		BDPHospId:平台多院区医院Id
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTSysSet","GetSysSet")
Query GetSysSet(code As %Library.String = "", desc As %Library.String = "", remark As %Library.String = "", value As %Library.String = "", addvalue As %Library.String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "") As %Query(ROWSPEC = "SSRowID:%String,SSValue:%String,SSDesc:%String,SSRemark:%String,SSAddValue:%String,SSCode:%String,SSRow:%String,SSHospDR:%String,SSHospDR_Desc:%String,SSDefaultValue:%String,SSUniqueFlag:%String")
{
}

ClassMethod GetSysSetExecute(ByRef qHandle As %Binary, code As %Library.String = "", desc As %Library.String = "", remark As %Library.String = "", value As %Library.String = "", addvalue As %Library.String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "") As %Status
{
	//new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)
	
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCSysSet",rowid))  quit:rowid=""  d
	.q:##class(web.DHCEQ.Util.BDPCommonUtil).GetHospShowDataFlag("DHC_EQCSysSet",rowid,sHospID)'="Y"		//czf 2021-04-20
	.d ResetVariablesGetSysSet
	.s SSRowID = rowid
	.q:$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",6)="Y"
	.s SSCode=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",1)
	.q:(code'="")&&(SSCode'[code)
	.s SSValue=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",2) //值
	.q:(value'="")&&(value'=SSValue)
	.i SSCode="990018" s SSValue="*****************"		//FTP配置信息要求加密显示
	.s SSDesc=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",3) //描述
	.q:(desc'="")&&(SSDesc'[desc)
	.s SSRemark=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",4) //备注
	.q:(remark'="")&&(SSRemark'[remark)
	.s SSAddValue=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",5)
	.q:(addvalue'="")&&(addvalue'=SSAddValue)
	.s SSHospDR=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",7)
	.s SSHospDRDesc=##class(web.DHCEQCommon).GetTrakNameByID("CTHospital",SSHospDR)
	.s SSDefaultValue=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",8)
	.s SSUniqueFlag=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",9)
	.d OutputRowGetSysSet
	Quit $$$OK
	
OutputRowGetSysSet
   s Data=$lb(SSRowID,SSValue,SSDesc,SSRemark,SSAddValue,SSCode,TRow,SSHospDR,SSHospDRDesc,SSDefaultValue,SSUniqueFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesGetSysSet
	s (SSRowID,SSValue,SSDesc,SSRemark,SSAddValue,SSCode,SSHospDR,SSHospDRDesc,SSDefaultValue,SSUniqueFlag)=""
	quit
}

ClassMethod GetSysSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSysSetExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetSysSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSysSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取唯一的系统参数列表，用于放大镜检索及展示
/// czf 2021-11-17
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTSysSet","GetUniqueSysSet","入库")
Query GetUniqueSysSet(Desc As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TDefaultValue:%String")
{
}

ClassMethod GetUniqueSysSetExecute(ByRef qHandle As %Binary, Desc As %Library.String = "") As %Status
{
	//new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCSysSet",0,"Unique","Y",rowid))  q:rowid=""  d
	.d ResetVariablesGetSysSet
	.s TRowID = rowid
	.;q:$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",6)="Y"
	.s TCode=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",1)
	.q:TCode="990051"		//多院区配置
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",3) //描述
	.q:(TDesc'[Desc)&&(TCode'[Desc)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",4) //备注
	.s TDefaultValue=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",8)	//默认值
	.d OutputRowGetUniqueSysSet
	Quit $$$OK
	
OutputRowGetUniqueSysSet
   s Data=$lb(TRowID,TCode,TDesc,TRemark,TDefaultValue)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesGetSysSet
	s (TRowID,TCode,TDesc,TRemark,TDefaultValue)=""
	quit
}

ClassMethod GetUniqueSysSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUniqueSysSetExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetUniqueSysSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUniqueSysSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:	add by czf 2021-11-17
/// Description:保存/删除系统参数
/// Input:		list:系统参数列表
/// 			DelRowid:删除的拆分明细id串，逗号分隔
/// 			User:用户ID
/// Output:		操作成功或失败Json串
/// w ##class(web.DHCEQ.Plat.CTSysSet).SaveData("{""SRequestNo"":"""",""SRequestDate"":"""",""SEquipDR_EQName"":""生物组织摊烤片机"",""EquipNo"":""3221709000001"",""SLocDR_DeptDesc"":""CT室"",""SOriginalFee"":""23000"",""SDepreTotalFee"":"""",""SNetFee"":""23000"",""SEquipTypeDR_ETDesc"":""专用设备"",""SStatCatDR_SCDesc"":""临床检验分析仪器"",""SEquipCatDR_ECDesc"":""实验室辅助器具,设施及设备"",""SOriginDR_ODesc"":""1"",""STransAssetDate"":""2021-02-19"",""SStartDate"":""2021-02-24"",""SProviderDR_VName"":""合江县金屹电脑有限公司"",""SManuFactoryDR_VName"":"""",""SModelDR_MDesc"":"""",""SLimitYearsNum"":""5"",""SDepreMethodDR_DMDesc"":""平均年限法"",""LeaveFactoryNo"":"""",""SSplitOriginalFee"":""20000"",""SSplitDepreTotalFee"":""0"",""SSplitNetFee"":""20000"",""SIsKeep"":true,""SRowID"":"""",""SStatus"":"""",""SEquipDR"":""6"",""SDepreMethodDR"":""1"",""SEquipTypeDR"":""3"",""SStatCatDR"":""30"",""SEquipCatDR"":""2659"",""SLocDR"":""1"",""SOriginDR"":""自购"",""SEquipStatus"":"""",""SProviderDR"":""1"",""SManuFactoryDR"":"""",""SModelDR"":"""",""QXType"":"""",""ReadOnly"":""0"",""CurRole"":"""",""ApproveTypeCode"":""36"",""ApproveSetDR"":"""",""ApproveRoleDR"":"""",""WaitAD"":""off"",""CancelOper"":"""",""RoleStep"":""0"",""CurDate"":""2021-07-12"",""Action"":"""",""ActionID"":"""",""NextFlowStep"":"""",""NextRoleDR"":"""",""CancelFlag"":"""",""CancelToFlowDR"":"""",""ApproveStatus"":"""",""Type"":""0"",""SplitNumCode"":""$CHAR(4)"",""SplitRowCode"":""$CHAR(3)"",""HospitalDesc"":""东华标准版数字化医院[总院]"",""GetComponentID"":""1006"",""PreviewRptFlag"":""0"",""SLListTotalFee"":"""",""SLListTotalDepreFee"":"""",""Job"":""53872"",""SReason"":""111"",""SRemark"":"""",""EditOpinion"":"""",""RejectReason"":""""}","{""SLRow"":""1"",""SLRowID"":"""",""SLSplitDR"":"""",""SLEquipDR"":"""",""SLEquipNo"":"""",""SLEquipName"":""生物组织摊烤片机1"",""SLOriginalFee"":""1000"",""SLDepreTotalFee"":""0"",""SLNetFee"":1000,""SLLeaveFactoryNo"":"""",""SLFileNo"":"""",""SLItemDR"":""1067"",""SLItemDR_MIDesc"":""听诊器"",""SLEquipCatDR"":""2569"",""SLLimitYearsNum"":"""",""SLDepreMethodDR"":"""",""SLDepreMethodDR_DMDesc"":"""",""SLManuFactoryDR"":"""",""SLManuFactoryDR_VName"":"""",""SLModelDR"":"""",""SLModelDR_MDesc"":"""",""SLLocationDR"":"""",""SLLocationDR_LDesc"":"""",""SLRemark"":"""",""SLQuantityNum"":""2""}$CHAR(3){""SLLeaveFactoryNo"":"""",""SLFileNo"":"""",""SLEquipName"":""生物组织摊烤片机2"",""SLQuantityNum"":""3"",""SLOriginalFee"":""2000"",""SLDepreTotalFee"":"""",""SLItemDR_MIDesc"":""听诊器"",""SLManuFactoryDR_VName"":"""",""SLModelDR_MDesc"":"""",""SLLocationDR_LDesc"":"""",""SLLimitYearsNum"":"""",""SLDepreMethodDR_DMDesc"":"""",""SLRemark"":"""",""SLNetFee"":2000,""SLItemDR"":""1067"",""SLEquipCatDR"":""2569"",""SLModelDR"":""""}","","77")
ClassMethod SaveData(val As %Library.String = "", DelFlag As %Library.String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "")
{
	Kill PLIST,LIST,rowid,Rowid
	Set $ZT="ERRORUpdateData"
	Set CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(val)
 	s rowid = JsonData.SSRowID
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCSysSet",JsonData,.PLIST)
 	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)	//获取院区Id(多院区)
	s PLIST(8)=sHospID
 	s SQLCODE=0
 	s TableName="DHC_EQCSysSet"
 	s TableName="DHC_EQCSysSet"
 	s ClassName="User.DHCEQCSysSet"
 	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()
 	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
 	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	
 	TSTART
	i DelFlag="1"
	{
		s rowid=val
		i rowid="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9000,"rowid不能为空!")
		i $p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",9)="Y"
		{
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9000,"默认系统参数,不能删除!")
		}
		s OperateType="D"
		s OldObject=##Class(User.DHCEQCSysSet).%OpenId(rowid)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		&SQL(Delete SQLUSER.DHC_EQCSysSet where SS_RowID = :rowid)
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		;日志记录
		d ##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,rowid,OperateType,"{}",OldObj.%ToJSON(),CurUser,"")
		
		TCOMMIT
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	else
	{
		;判断数据是否重复
		s Code=JsonData.SSCode
		s Value=JsonData.SSValue
		s RtnInfo=##class(web.DHCEQ.Util.BDPCommonUtil).CodeDescIsRepeat("DHC_EQCSysSet",rowid,Code_"^"_Value,sHospID)
		s Rowid=$p(RtnInfo,"$",1)		//重复Rowid
		
		if Code="990051"
		{
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000","多院区设置不能修改!")
		}
		// MZY0116	2516855		2022-03-14
		if (Code=990018)
		{
			i $p(PLIST(3),"&",3)'="" s $p(PLIST(3),"&",3)= ##Class(web.Util.Encryption).SimpleEncrypt($p(PLIST(3),"&",3),"DHCEQ")
		}
		if (Rowid="")
		{
			If (rowid="")
			{
				s OperateType="A"
			 	&SQL(Insert SQLUSER.DHC_EQCSysSet Values :PLIST())
			}
			Else
			{
				s OperateType="U"
				s OldObject=##Class(User.DHCEQCSysSet).%OpenId(rowid)
				s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
				&SQL(Update SQLUSER.DHC_EQCSysSet Values :PLIST() where SS_RowID = :rowid)
			}
		}
		else
		{
			i rowid'=Rowid q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-3001,"数据重复!")
	  		s OperateType="U"
			s OldObject=##Class(User.DHCEQCSysSet).%OpenId(rowid)
			s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
	  		&SQL(Update SQLUSER.DHC_EQCSysSet Values :PLIST() where SS_RowID = :rowid)
		}
		If SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,$g(%msg))
		}
		s rowid=$g(%ROWID)
		
		;保存医院对照关系
		s SQLCODE=##class(web.DHCEQ.Util.BDPCommonUtil).SaveHOSP("DHC_EQCSysSet",rowid,sHospID)
		If SQLCODE<0
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存医院对照关系失败!")
		}
		
		;保存数据变更日志
		s OldObject=""	//先关闭对象 czf 2021-01-21
		s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCSysSet).%OpenId(rowid))
		i rowid'=""	//更新数据获取更新字段Json串
		{
			s key=""
			For
			{
				s value=FinalObj.GetNext(.key)
				q:key=""
    			i (value'=OldObj.%Get(key)) d NewObj.%Set(key,value)
			}
		}
		i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
		{
			d ##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,rowid,OperateType,NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
		}
		
		TCOMMIT
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,rowid)
	}

ERRORUpdateData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// Creator:	Add by CZF 2021-11-17
/// Description:系统参数JSON串
/// Input：		rowid：系统参数表rowid
/// Output:		系统参数详细Json串
/// w ##class(web.DHCEQ.Plat.CTSysSet).GetOneSysSet(8)
ClassMethod GetOneSysSet(rowid As %Library.String = "")
{
	i rowid="" q ##Class(web.DHCEQ.Lib.Common).ReturnJson(-9000,"rowid不能为空")
	s $ZT="ERRORGetOneSysSet"
	s ObjSysSet=##Class(User.DHCEQCSysSet).%OpenId(rowid)
	s SysSetInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjSysSet)
	d SysSetInfo.%Set("SSRowID",rowid)
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,SysSetInfo)
ERRORGetOneSysSet
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9000",ErrorMsg)
}

}
