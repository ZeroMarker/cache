Import SQLUser

/// 名称:系统管理-安全组
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 -陈莹
/// 编写日期: 2012-12-15
Class web.DHCBL.CT.SSGroup Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter SQLTableName = "SS_Group";

/// Creator:陈莹
/// CreatDate:2013-05-06
/// Description:查询 安全组 
/// Table:User.SSGroup
/// Input:rowid,desc,hospid（医院id）
/// Return:SSGRPRowId,SSGRPDesc,SSGRPCode
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSGroup","GetList","","","","","")
Query GetList(rowid As %String, desc As %String, hospid As %String, activeflag As %String, code As %String) As %Query(ROWSPEC = "SSGRPRowId:%String,SSGRPDesc:%String,SSGRPCode:%String,SSGRPGroupDr,SSGRPActiveFlag:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, hospid As %String, activeflag As %String, code As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	
	if (rowid'="")
	{
		s SSGRPRowId=rowid
		s SSGRPDesc=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",1) 
		s SSGRPCode=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",152) //代码
		s SSGRPGroupDr=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",166) //上级安全组
		s:SSGRPGroupDr'="" SSGRPGroupDr=$p($g(^SSU("SSGRP",SSGRPGroupDr)),"^",1)
		s SSGRPActiveFlag=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",151) //有效标志 2021-08-26 
		s:SSGRPActiveFlag="" SSGRPActiveFlag="Y"
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("SS_Group",SSGRPRowId)
		s BDPInternalCode =$p($g(resultStr),"^",1)
		s BDPInternalDesc = $p($g(resultStr),"^",2)
		s BDPHospNationalCode=$p($g(resultStr),"^",3)  
		s BDPHospNationalDesc = $p($g(resultStr),"^",4)
		d OutputRow
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U")
		///医院级授权，2015-1-20
		//s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
		
		s AuStr=##class(web.DHCBL.Authorize.SSGroup).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 

		s SSGRPRowId=0
		for
		{
			s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
			if hospid'=""
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,SSGRPRowId,hospid)
				continue:showflag="N"
			}
			/*
			s strHospRowId="",AuHospFlag=0
			if (AuHospStr'="off")
			{
				s HOSPChildsub=0
				for
				{
					s HOSPChildsub=$o(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")||(AuHospFlag=1)
					s CTHospitalDR=$p($g(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)),"^",1)
					s strHospRowId="{ID:"_CTHospitalDR_"}"
					if (AuHospStr[strHospRowId) s AuHospFlag=1
				}
			}
			
			*/
			s strRowId="{ID:"_SSGRPRowId_"}"
			//((AuHospFlag=1)||(AuHospStr=1)||(AuHospStr="off"))&&
			if ((AuStr[strRowId)||(AuFlag=1)) ;用来筛选授权数据
			{
				s SSGRPDesc=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",1)  //描述
				s SSGRPActiveFlag=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",151) //有效标志 2021-08-26
				if SSGRPActiveFlag=""
				{
					continue:((activeflag="N")&&(SSGRPDesc'["停用"))
					continue:((activeflag="Y")&&(SSGRPDesc["停用"))
				}
				else
				{
					s:SSGRPActiveFlag="" SSGRPActiveFlag="Y"
					continue:(SSGRPActiveFlag'[activeflag)
				}  
				s SSGRPCode=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",152) //代码
				continue:$zcvt(SSGRPCode,"U")'[$zcvt(code,"U")  //2022-10-19
				s SSGRPGroupDr=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",166) //上级安全组
				s:SSGRPGroupDr'="" SSGRPGroupDr=$p($g(^SSU("SSGRP",SSGRPGroupDr)),"^",1)
				
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("SS_Group",SSGRPRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)
				s BDPInternalDesc = $p($g(resultStr),"^",2)
				s BDPHospNationalCode=$p($g(resultStr),"^",3)  
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("SS_Group",SSGRPRowId,SSGRPDesc,desc)
				}
				else
				{
					s AliasFlag=1
				}
				i (AliasFlag=1)
				{
					d OutputRow
				}
			}
		}
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(SSGRPRowId,SSGRPDesc,SSGRPCode,SSGRPGroupDr,SSGRPActiveFlag,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2013-05-06
/// Description:查询 安全组 
/// Table:User.SSGroup
/// Input:rowid,desc,hospid（医院id）
/// Return:SSGRPRowId,SSGRPDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSGroup","GetDataForCmb1","","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, hospid As %String, code As %String) As %Query(ROWSPEC = "SSGRPRowId:%String,SSGRPDesc:%String,SSGRPCode:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, hospid As %String, code As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	///医院级授权串，2015-1-20
	s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
	///基础数据授权
	s AuStr=##class(web.DHCBL.Authorize.SSGroup).DHCGetDataByDefaultSession()
	
	s AuFlag=0
	;未授权情况下，默认显示全部数据
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="")
	{
		s SSGRPRowId=rowid
		s SSGRPDesc=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",1)
		s SSGRPCode=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",152) //代码
		d OutputRowCmb
	}
	else
	{

		s:desc'="" desc=$ZCONVERT(desc,"U")
		
		s SSGRPRowId=0
		for
		{
			s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
			if hospid'=""
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,SSGRPRowId,hospid)
				continue:showflag="N"
			}
			else
			{
				///新增医院级授权限制，2015-1-20
				s strHospRowId="",AuHospFlag=0 
				
				//如果登录医院不等于医院组，要判断医院级授权是不是只有登录医院的权限，要能看到医院组的安全组数据。
				s HOSPID=""
				if $d(%session) s HOSPID=$g(%session.Data("LOGON.HOSPID"))
				s DefHospId= ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(..#SQLTableName,HOSPID,"")
				s strHOSPID="{ID:"_HOSPID_"}"
				if (AuHospStr'="off")
				{
					s HOSPChildsub=0
					for
					{
						s HOSPChildsub=$o(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")||(AuHospFlag=1)
						s CTHospitalDR=$p($g(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)),"^",1)
						s strHospRowId="{ID:"_CTHospitalDR_"}"
						if (AuHospStr[strHospRowId) s AuHospFlag=1
						if (HOSPID'=DefHospId)&&(DefHospId=CTHospitalDR)  //如果登录医院不等于医院组，要判断医院级授权是不是只有登录医院的权限，要能看到医院组的安全组数据。
						{
							if (AuHospStr[strHOSPID)||(AuHospStr[strHospRowId) s AuHospFlag=1
						}
					}
				}
				if '((AuHospFlag=1)||(AuHospStr=1)||(AuHospStr="off")) continue
			}
			s strRowId="{ID:"_SSGRPRowId_"}"
			
			if ((AuStr[strRowId)||(AuFlag=1)) ;用来筛选授权数据
			{
				s SSGRPDesc=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",1)
				continue:SSGRPDesc["停用"  //2019-06-25
				s SSGRPCode=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",152) //代码
				continue:$zcvt(SSGRPCode,"U")'[$zcvt(code,"U")  //2022-10-19
				
				s SSGRPActiveFlag=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",151)  //有效标志
				continue:(SSGRPActiveFlag="N")
				s SSGRPEndDate=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",154)  //结束日期
				continue:(SSGRPEndDate'="")&&(SSGRPEndDate<+$h)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("SS_Group",SSGRPRowId,SSGRPDesc,desc)
				}
				else
				{
					s AliasFlag=1
				}
				i (AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(SSGRPRowId,SSGRPDesc,SSGRPCode)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSSGroupSet(id As %String) As %String
{
    s str = ""
	s eobj = ##class(web.Entity.CT.SSGroup).%New()
	s eobj.SSGRPRowId = id
	s eobj.SSGRPDesc=$p($g(^SSU("SSGRP",id)),"^",1)  //安全组描述
	s eobj.SSGRPCode=$p($g(^SSU("SSGRP",id)),"^",152) //代码
	s eobj.SSGRPGroupDr=$p($g(^SSU("SSGRP",id)),"^",166) //上级安全组
	s eobj.SSGRPActiveFlag=$p($g(^SSU("SSGRP",id)),"^",151) //有效标志
	if (eobj.SSGRPDesc["停用")
	{
		s eobj.SSGRPActiveFlag = "N"    //有效标志		
	}
	s:eobj.SSGRPActiveFlag="" eobj.SSGRPActiveFlag="Y"
	s:eobj.SSGRPActiveFlag="Y" eobj.SSGRPActiveFlag="true"
	
	s eobj.SSGRPStartDate=$p($g(^SSU("SSGRP",id)),"^",153) //开始日期
	s eobj.SSGRPEndDate=$p($g(^SSU("SSGRP",id)),"^",154) //结束日期
	s:eobj.SSGRPStartDate'="" eobj.SSGRPStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.SSGRPStartDate)
	s:eobj.SSGRPEndDate'="" eobj.SSGRPEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.SSGRPEndDate)
	s eobj.SSGRPSeqNo=$p($g(^SSU("SSGRP",id)),"^",159) //系统排序号
	s eobj.SSGRPPYCode=$p($g(^SSU("SSGRP",id)),"^",163) //拼音码
	s eobj.SSGRPWBCode=$p($g(^SSU("SSGRP",id)),"^",164) //五笔码
	s eobj.SSGRPMark=$p($g(^SSU("SSGRP",id)),"^",165) //备注

	//1.Bed Management
	s eobj.SSGRPWardViewLocListDR=$p($g(^SSU("SSGRP",id)),"^",36)
	s eobj.SSGRPWardPlaceLocListDR=$p($g(^SSU("SSGRP",id)),"^",37)
	s eobj.SSGRPAllowDeleteBedTransactions=$p($g(^SSU("SSGRP",id)),"^",47)
	s:eobj.SSGRPAllowDeleteBedTransactions="Y" eobj.SSGRPAllowDeleteBedTransactions="true" // checkbox
	s eobj.SSGRPRestrictWardsToDepartment=$p($g(^SSU("SSGRP",id)),"^",120)
	s:eobj.SSGRPRestrictWardsToDepartment="Y" eobj.SSGRPRestrictWardsToDepartment="true"
	//Booking
	s eobj.SSGRPAllowBookOutsideRange=$p($g(^SSU("SSGRP",id)),"^",11)
	s:eobj.SSGRPAllowBookOutsideRange="Y" eobj.SSGRPAllowBookOutsideRange="true"  
	s eobj.SSGRPAllowedtoBookOR=$p($g(^SSU("SSGRP",id)),"^",12)
	s:eobj.SSGRPAllowedtoBookOR="Y" eobj.SSGRPAllowedtoBookOR="true"  
	;;; s eobj.SSGRPAllowBookPastGuarDateOP=$p($g(^SSU("SSGRP",id)),"^",148)
	;;; s:eobj.SSGRPAllowBookPastGuarDateOP="Y" eobj.SSGRPAllowBookPastGuarDateOP="true"  
	s eobj.SSGRPAllowMultipleServAdhoc=$p($g(^SSU("SSGRP",id)),"^",122)
	s:eobj.SSGRPAllowMultipleServAdhoc="Y" eobj.SSGRPAllowMultipleServAdhoc="true"  
	s eobj.SSGRPAllowOverBookRB=$p($g(^SSU("SSGRP",id)),"^",32)
	s:eobj.SSGRPAllowOverBookRB="Y" eobj.SSGRPAllowOverBookRB="true"  
	s eobj.SSGRPAllowOverBookOnSlotZero=$p($g(^SSU("SSGRP",id)),"^",104)
	s:eobj.SSGRPAllowOverBookOnSlotZero="Y" eobj.SSGRPAllowOverBookOnSlotZero="true"  
	s eobj.SSGRPAllowUndoAppt=$p($g(^SSU("SSGRP",id)),"^",45)
	s:eobj.SSGRPAllowUndoAppt="Y" eobj.SSGRPAllowUndoAppt="true"  
	s eobj.SSGRPAllowOverPayorRestrict=$p($g(^SSU("SSGRP",id)),"^",44)
	s:eobj.SSGRPAllowOverPayorRestrict="Y" eobj.SSGRPAllowOverPayorRestrict="true"  
	s eobj.SSGRPChkFutureAppts=$p($g(^SSU("SSGRP",id)),"^",59)
	s:eobj.SSGRPChkFutureAppts="Y" eobj.SSGRPChkFutureAppts="true"  
	s eobj.SSGRPNotBookOutSess=$p($g(^SSU("SSGRP",id)),"^",60)
	s:eobj.SSGRPNotBookOutSess="Y" eobj.SSGRPNotBookOutSess="true"  
	s eobj.SSGRPNotExcLoadLevelOverrides=$p($g(^SSU("SSGRP",id)),"^",67)
	s:eobj.SSGRPNotExcLoadLevelOverrides="Y" eobj.SSGRPNotExcLoadLevelOverrides="true"  
	s eobj.SSGRPNAllAddPastAppt=$p($g(^SSU("SSGRP",id)),"^",117)
	s:eobj.SSGRPNAllAddPastAppt="Y" eobj.SSGRPNAllAddPastAppt="true"  
	s eobj.SSGRPDFLocListDR=$p($g(^SSU("SSGRP",id)),"^",69)
	
	///billing and cashiers
	s eobj.SSGRPAllowDiscPaidOrder=$p($g(^SSU("SSGRP",id)),"^",119)
	s:eobj.SSGRPAllowDiscPaidOrder="Y" eobj.SSGRPAllowDiscPaidOrder="true"  
	s eobj.SSGRPRoundingAutomatic=$p($g(^SSU("SSGRP",id)),"^",144)
	s:eobj.SSGRPRoundingAutomatic="Y" eobj.SSGRPRoundingAutomatic="true"  
	s eobj.SSGRPRoundingOnPayment=$p($g(^SSU("SSGRP",id)),"^",143)
	s:eobj.SSGRPRoundingOnPayment="Y" eobj.SSGRPRoundingOnPayment="true"  
	
	//clinical and EMR
	s eobj.SSGRPAllowOSFEdit24hrs=$p($g(^SSU("SSGRP",id)),"^",57)
	s:eobj.SSGRPAllowOSFEdit24hrs="Y" eobj.SSGRPAllowOSFEdit24hrs="true"  
	s eobj.SSGRPOrdersPrevEpisode=$p($g(^SSU("SSGRP",id)),"^",24)
	s:eobj.SSGRPOrdersPrevEpisode="Y" eobj.SSGRPOrdersPrevEpisode="true"  
	//s eobj.SSGRPAllowToExecuteOrderOutsideShift=$p($g(^SSU("SSGRP",id)),"^",18)
	//s:eobj.SSGRPAllowToExecuteOrderOutsideShift="Y" eobj.SSGRPAllowToExecuteOrderOutsideShift="true"  
	s eobj.SSGRPShowAllPatientsInNWB=$p($g(^SSU("SSGRP",id)),"^",27)
	s:eobj.SSGRPShowAllPatientsInNWB="Y" eobj.SSGRPShowAllPatientsInNWB="true"  
	s eobj.SSGRPDisplayDiagnProcDRG=$p($g(^SSU("SSGRP",id)),"^",35)
	s:eobj.SSGRPDisplayDiagnProcDRG="Y" eobj.SSGRPDisplayDiagnProcDRG="true"  
	s eobj.SSGRPClinicalLocListDr=$p($g(^SSU("SSGRP",id)),"^",89)
	
	//Discharge
	s eobj.SSGRPAutoMedDischarge=$p($g(^SSU("SSGRP",id)),"^",58)
	s:eobj.SSGRPAutoMedDischarge="Y" eobj.SSGRPAutoMedDischarge="true"  
	s eobj.SSGRPDischargeLocList=$p($g(^SSU("SSGRP",id)),"^",92)
	
	//general system information
	s eobj.SSGRPAllowSendMsgAll=$p($g(^SSU("SSGRP",id)),"^",70)
	s:eobj.SSGRPAllowSendMsgAll="Y" eobj.SSGRPAllowSendMsgAll="true"  
	s eobj.SSGRPEnableSystemCT=$p($g(^SSU("SSGRP",id)),"^",33)
	s:eobj.SSGRPEnableSystemCT="Y" eobj.SSGRPEnableSystemCT="true"  
	s eobj.SSGRPRestrictLocForGrHospitals=$p($g(^SSU("SSGRP",id)),"^",98)
	s:eobj.SSGRPRestrictLocForGrHospitals="Y" eobj.SSGRPRestrictLocForGrHospitals="true"  
	s eobj.SSGRPSecurityLevel=$p($g(^SSU("SSGRP",id)),"^",64)
	s eobj.SSGRPInactivityTimeOut=$p($g(^SSU("SSGRP",id)),"^",56)
	s eobj.SSGRPPasswordDaysToExpire=$p($g(^SSU("SSGRP",id)),"^",61)
	
	///operating theatre workbench
	s eobj.SSGRPAllowChangeDepOT=$p($g(^SSU("SSGRP",id)),"^",39)
	s:eobj.SSGRPAllowChangeDepOT="Y" eobj.SSGRPAllowChangeDepOT="true"  
	s eobj.SSGRPNAllORBookNA=$p($g(^SSU("SSGRP",id)),"^",31)
	s:eobj.SSGRPNAllORBookNA="Y" eobj.SSGRPNAllORBookNA="true"  
	s eobj.SSGRPNAllORBookNoSess=$p($g(^SSU("SSGRP",id)),"^",30)
	s:eobj.SSGRPNAllORBookNoSess="Y" eobj.SSGRPNAllORBookNoSess="true"  
	s eobj.SSGRPNAllORBookPast=$p($g(^SSU("SSGRP",id)),"^",29)
	s:eobj.SSGRPNAllORBookPast="Y" eobj.SSGRPNAllORBookPast="true"  
	s eobj.SSGRPDontBookOutsideOTSchedule=$p($g(^SSU("SSGRP",id)),"^",142)
	s:eobj.SSGRPDontBookOutsideOTSchedule="Y" eobj.SSGRPDontBookOutsideOTSchedule="true"  
	s eobj.SSGRPWarnORBookingMoveRes=$p($g(^SSU("SSGRP",id)),"^",28)
	s:eobj.SSGRPWarnORBookingMoveRes="Y" eobj.SSGRPWarnORBookingMoveRes="true"  
	
	///order and results
	s eobj.SSGRPAllowToChangeOEStatus=$p($g(^SSU("SSGRP",id)),"^",55)
	s:eobj.SSGRPAllowToChangeOEStatus="Y" eobj.SSGRPAllowToChangeOEStatus="true"  
	s eobj.SSGRPAllowDiscOrdPackedPres=$p($g(^SSU("SSGRP",id)),"^",79)
	s:eobj.SSGRPAllowDiscOrdPackedPres="Y" eobj.SSGRPAllowDiscOrdPackedPres="true"  
	s eobj.SSGRPAllowedSeeSEnsitRes=$p($g(^SSU("SSGRP",id)),"^",81)
	s:eobj.SSGRPAllowedSeeSEnsitRes="Y" eobj.SSGRPAllowedSeeSEnsitRes="true"  
	s eobj.SSGRPCheckApproved=$p($g(^SSU("SSGRP",id)),"^",133)
	s:eobj.SSGRPCheckApproved="Y" eobj.SSGRPCheckApproved="true"  
	s eobj.SSGRPDefaultDoseEquiv=$p($g(^SSU("SSGRP",id)),"^",40)
	s:eobj.SSGRPDefaultDoseEquiv="Y" eobj.SSGRPDefaultDoseEquiv="true"  
	s eobj.SSGRPDisableAddAll=$p($g(^SSU("SSGRP",id)),"^",82)
	s:eobj.SSGRPDisableAddAll="Y" eobj.SSGRPDisableAddAll="true"  
	s eobj.SSGRPDiscontinueExecOrders=$p($g(^SSU("SSGRP",id)),"^",53)
	s:eobj.SSGRPDiscontinueExecOrders="Y" eobj.SSGRPDiscontinueExecOrders="true"  
	s eobj.SSGRPSuppressPin=$p($g(^SSU("SSGRP",id)),"^",42)
	s:eobj.SSGRPSuppressPin="Y" eobj.SSGRPSuppressPin="true"  
	s eobj.SSGRPIgnoreOrderRestrictions=$p($g(^SSU("SSGRP",id)),"^",108)
	s:eobj.SSGRPIgnoreOrderRestrictions="Y" eobj.SSGRPIgnoreOrderRestrictions="true"  
	s eobj.SSGRPJobOE=$p($g(^SSU("SSGRP",id)),"^",54)
	s:eobj.SSGRPJobOE="Y" eobj.SSGRPJobOE="true"  
	s eobj.SSGRPMinimizeOEUpdate=$p($g(^SSU("SSGRP",id)),"^",6)
	s:eobj.SSGRPMinimizeOEUpdate="Y" eobj.SSGRPMinimizeOEUpdate="true"  
	s eobj.SSGRPRetainOrderCategory=$p($g(^SSU("SSGRP",id)),"^",5)
	s:eobj.SSGRPRetainOrderCategory="Y" eobj.SSGRPRetainOrderCategory="true"  
	s eobj.SSGRPPrice=$p($g(^SSU("SSGRP",id)),"^",7)
	s:eobj.SSGRPPrice="Y" eobj.SSGRPPrice="true"  
	
	///paper record traking
	s eobj.SSGRPAllowIssueArchiveMR=$p($g(^SSU("SSGRP",id)),"^",25)
	s:eobj.SSGRPAllowIssueArchiveMR="Y" eobj.SSGRPAllowIssueArchiveMR="true"  
	s eobj.SSGRPRestrictMRTypeCurrHosp=$p($g(^SSU("SSGRP",id)),"^",90)
	s:eobj.SSGRPRestrictMRTypeCurrHosp="Y" eobj.SSGRPRestrictMRTypeCurrHosp="true"  
	s eobj.SSGRPAllowActivateVolume=$p($g(^SSU("SSGRP",id)),"^",91)
	s:eobj.SSGRPAllowActivateVolume="Y" eobj.SSGRPAllowActivateVolume="true"  
	s eobj.SSGRPAllowNewMRTypesPat=$p($g(^SSU("SSGRP",id)),"^",94)
	s:eobj.SSGRPAllowNewMRTypesPat="Y" eobj.SSGRPAllowNewMRTypesPat="true"  
	
	///patient management
	s eobj.SSGRPWaitListStatusDR=$p($g(^SSU("SSGRP",id)),"^",34)
	s eobj.SSGRPEmergencyLocListDR=$p($g(^SSU("SSGRP",id)),"^",22)
	s eobj.SSGRPHealthPromLocListDR=$p($g(^SSU("SSGRP",id)),"^",23)
	s eobj.SSGRPInPatLocListDR=$p($g(^SSU("SSGRP",id)),"^",21)
	s eobj.SSGRPOnlyInpatUnitsForMyHospita=$p($g(^SSU("SSGRP",id)),"^",110)
	s:eobj.SSGRPOnlyInpatUnitsForMyHospita="Y" eobj.SSGRPOnlyInpatUnitsForMyHospita="true"  
	s eobj.SSGRPTempPatLocList=$p($g(^SSU("SSGRP",id)),"^",63)
	s eobj.SSGRPOutPatLocListDR=$p($g(^SSU("SSGRP",id)),"^",20)
	s eobj.SSGRPOnlyOutpatUnitsForMyHospit=$p($g(^SSU("SSGRP",id)),"^",109)
	s:eobj.SSGRPOnlyOutpatUnitsForMyHospit="Y" eobj.SSGRPOnlyOutpatUnitsForMyHospit="true"  
	s eobj.SSGRPInPatTransferListDR=$p($g(^SSU("SSGRP",id)),"^",132)
	s eobj.SSGRPRadLocList=$p($g(^SSU("SSGRP",id)),"^",62)
	s eobj.SSGRPWaitListLocListDR=$p($g(^SSU("SSGRP",id)),"^",66)
	s eobj.SSGRPWLStatusListDR=$p($g(^SSU("SSGRP",id)),"^",83)
	s eobj.SSGRPWardAttendLocListDR=$p($g(^SSU("SSGRP",id)),"^",87)
	
	//patient management2
	s eobj.SSGRPAllowDeleteEpisode=$p($g(^SSU("SSGRP",id)),"^",9)
	s:eobj.SSGRPAllowDeleteEpisode="Y" eobj.SSGRPAllowDeleteEpisode="true"  
	s eobj.SSGRPAllowedAddOrdersReview=$p($g(^SSU("SSGRP",id)),"^",4)
	s:eobj.SSGRPAllowedAddOrdersReview="Y" eobj.SSGRPAllowedAddOrdersReview="true"  
	;;;暂时不加  s eobj.SSGRPAllowBookPastGuarDateWL=$p($g(^SSU("SSGRP",id)),"^",149)
	;;;s:eobj.SSGRPAllowBookPastGuarDateWL="Y" eobj.SSGRPAllowBookPastGuarDateWL="true"  
	s eobj.SSGRPAllowToChangeFamilyDoctor=$p($g(^SSU("SSGRP",id)),"^",13)
	s:eobj.SSGRPAllowToChangeFamilyDoctor="Y" eobj.SSGRPAllowToChangeFamilyDoctor="true"  
	s eobj.SSGRPChangeDataAfterDischarge=$p($g(^SSU("SSGRP",id)),"^",14)
	s:eobj.SSGRPChangeDataAfterDischarge="Y" eobj.SSGRPChangeDataAfterDischarge="true"  
	s eobj.SSGRPAllowDeleteDiagOtherUs=$p($g(^SSU("SSGRP",id)),"^",46)
	s:eobj.SSGRPAllowDeleteDiagOtherUs="Y" eobj.SSGRPAllowDeleteDiagOtherUs="true"  
	s eobj.SSGRPAllowEditEpLogLoc=$p($g(^SSU("SSGRP",id)),"^",74)
	s:eobj.SSGRPAllowEditEpLogLoc="Y" eobj.SSGRPAllowEditEpLogLoc="true"  
	s eobj.SSGRPAllowEditWLStatusTreated=$p($g(^SSU("SSGRP",id)),"^",129)
	s:eobj.SSGRPAllowEditWLStatusTreated="Y" eobj.SSGRPAllowEditWLStatusTreated="true"  
	s eobj.SSGRPAllowViewVIPPatients=$p($g(^SSU("SSGRP",id)),"^",68)
	s:eobj.SSGRPAllowViewVIPPatients="Y" eobj.SSGRPAllowViewVIPPatients="true"  
	s eobj.SSGRPShowPatientSearch=$p($g(^SSU("SSGRP",id)),"^",10)
	s:eobj.SSGRPShowPatientSearch="Y" eobj.SSGRPShowPatientSearch="true"  
	s eobj.SSGRPDisplayDiagnosis=$p($g(^SSU("SSGRP",id)),"^",8)
	s:eobj.SSGRPDisplayDiagnosis="Y" eobj.SSGRPDisplayDiagnosis="true"  
	s eobj.SSGRPCheckOrdersCovered=$p($g(^SSU("SSGRP",id)),"^",41)
	s:eobj.SSGRPCheckOrdersCovered="Y" eobj.SSGRPCheckOrdersCovered="true"  
	s eobj.SSGRPShowOnlyIPUnitsForWL=$p($g(^SSU("SSGRP",id)),"^",114)
	s:eobj.SSGRPShowOnlyIPUnitsForWL="Y" eobj.SSGRPShowOnlyIPUnitsForWL="true"  
	s eobj.SSGRPRestrictSearchEMR=$p($g(^SSU("SSGRP",id)),"^",85)
	s:eobj.SSGRPRestrictSearchEMR="Y" eobj.SSGRPRestrictSearchEMR="true"  
	s eobj.SSGRPShowAllLocations=$p($g(^SSU("SSGRP",id)),"^",19)
	s:eobj.SSGRPShowAllLocations="Y" eobj.SSGRPShowAllLocations="true"  
	s eobj.SSGRPShowPreadmafterAppoint=$p($g(^SSU("SSGRP",id)),"^",26)
	s:eobj.SSGRPShowPreadmafterAppoint="Y" eobj.SSGRPShowPreadmafterAppoint="true"  
	s eobj.SSGRPMoveToDefaultBed=$p($g(^SSU("SSGRP",id)),"^",43)
	s:eobj.SSGRPMoveToDefaultBed="Y" eobj.SSGRPMoveToDefaultBed="true"  
	s eobj.SSGRPWLAuditLetterDays=$p($g(^SSU("SSGRP",id)),"^",112)
	
	//stock
	s eobj.SSGRPAllowEditPriceGR=$p($g(^SSU("SSGRP",id)),"^",48)
	s:eobj.SSGRPAllowEditPriceGR="Y" eobj.SSGRPAllowEditPriceGR="true"  
	s eobj.SSGRPAllowToChangeAgrPrice=$p($g(^SSU("SSGRP",id)),"^",38)
	s:eobj.SSGRPAllowToChangeAgrPrice="Y" eobj.SSGRPAllowToChangeAgrPrice="true"  
	//s eobj.SSGRPAllowToAddItemToVendPortfolio=$p($g(^SSU("SSGRP",id)),"^",17)
	//s:eobj.SSGRPAllowToAddItemToVendPortfolio="Y" eobj.SSGRPAllowToAddItemToVendPortfolio="true"  
	s eobj.SSGRPAllowAddStockItem=$p($g(^SSU("SSGRP",id)),"^",15)
	s:eobj.SSGRPAllowAddStockItem="Y" eobj.SSGRPAllowAddStockItem="true"  
	//s eobj.SSGRPAllowToAddItemToLocPortfolio=$p($g(^SSU("SSGRP",id)),"^",16)
	//s:eobj.SSGRPAllowToAddItemToLocPortfolio="Y" eobj.SSGRPAllowToAddItemToLocPortfolio="true"  
	s eobj.SSGRPOnePOforEveryVendor=$p($g(^SSU("SSGRP",id)),"^",134)
	s:eobj.SSGRPOnePOforEveryVendor="Y" eobj.SSGRPOnePOforEveryVendor="true"  
	s eobj.SSGRPConsReasonMandatory=$p($g(^SSU("SSGRP",id)),"^",49)
	s:eobj.SSGRPConsReasonMandatory="Y" eobj.SSGRPConsReasonMandatory="true"  
	s eobj.SSGRPUserPOReferenceNotMandator=$p($g(^SSU("SSGRP",id)),"^",135)
	s:eobj.SSGRPUserPOReferenceNotMandator="Y" eobj.SSGRPUserPOReferenceNotMandator="true"  
	s eobj.SSGRPDefaultPOReferenceDR=$p($g(^SSU("SSGRP",id)),"^",136)
	s eobj.SSGRPMaxPOAmount=$p($g(^SSU("SSGRP",id)),"^",116)
	
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

ClassMethod SaveEntitybed(eobj As web.Entity.CT.SSGroup) As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s id=eobj.SSGRPRowId
		//1.Bed Management
		s $p(^SSU("SSGRP",id),"^",36)= eobj.SSGRPWardViewLocListDR
		s $p(^SSU("SSGRP",id),"^",37)= eobj.SSGRPWardPlaceLocListDR
		s $p(^SSU("SSGRP",id),"^",47)=eobj.SSGRPAllowDeleteBedTransactions
		s $p(^SSU("SSGRP",id),"^",120)=eobj.SSGRPRestrictWardsToDepartment
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitybooking(eobj As web.Entity.CT.SSGroup) As %String
{
	s result=""
	if $IsObject(eobj)
	{	

		s id=eobj.SSGRPRowId
		//Booking
		s $p(^SSU("SSGRP",id),"^",11)=eobj.SSGRPAllowBookOutsideRange
		s $p(^SSU("SSGRP",id),"^",12)=eobj.SSGRPAllowedtoBookOR
		;;; 暂时不加  s $p(^SSU("SSGRP",id),"^",148)=eobj.SSGRPAllowBookPastGuarDateOP
		s $p(^SSU("SSGRP",id),"^",122)=eobj.SSGRPAllowMultipleServAdhoc
		s $p(^SSU("SSGRP",id),"^",32)=eobj.SSGRPAllowOverBookRB
		s $p(^SSU("SSGRP",id),"^",104)=eobj.SSGRPAllowOverBookOnSlotZero
		s $p(^SSU("SSGRP",id),"^",45) =eobj.SSGRPAllowUndoAppt
		s $p(^SSU("SSGRP",id),"^",44)=eobj.SSGRPAllowOverPayorRestrict
		s $p(^SSU("SSGRP",id),"^",59)=eobj.SSGRPChkFutureAppts
		s $p(^SSU("SSGRP",id),"^",60)=eobj.SSGRPNotBookOutSess
		s $p(^SSU("SSGRP",id),"^",67)=eobj.SSGRPNotExcLoadLevelOverrides
		s $p(^SSU("SSGRP",id),"^",117)=eobj.SSGRPNAllAddPastAppt
		s $p(^SSU("SSGRP",id),"^",69)=eobj.SSGRPDFLocListDR
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitybilling(eobj As web.Entity.CT.SSGroup) As %String
{
	s result=""
	if $IsObject(eobj)
	{	

		s id=eobj.SSGRPRowId
		///billing and cashiers
		s $p(^SSU("SSGRP",id),"^",119)=eobj.SSGRPAllowDiscPaidOrder
		s $p(^SSU("SSGRP",id),"^",144)=eobj.SSGRPRoundingAutomatic
		s $p(^SSU("SSGRP",id),"^",143)=eobj.SSGRPRoundingOnPayment
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntityclinical(eobj As web.Entity.CT.SSGroup) As %String
{
	s result=""
	if $IsObject(eobj)
	{	

		s id=eobj.SSGRPRowId
		//clinical and EMR
		s $p(^SSU("SSGRP",id),"^",57)=eobj.SSGRPAllowOSFEdit24hrs
		s $p(^SSU("SSGRP",id),"^",24)=eobj.SSGRPOrdersPrevEpisode
		//s $p(^SSU("SSGRP",id),"^",18)=eobj.SSGRPAllowToExecuteOrderOutsideShift
		s $p(^SSU("SSGRP",id),"^",27)=eobj.SSGRPShowAllPatientsInNWB
		s $p(^SSU("SSGRP",id),"^",35)=eobj.SSGRPDisplayDiagnProcDRG
		s $p(^SSU("SSGRP",id),"^",89)=eobj.SSGRPClinicalLocListDr
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitydischarge(eobj As web.Entity.CT.SSGroup) As %String
{
	s result=""
	if $IsObject(eobj)
	{	

		s id=eobj.SSGRPRowId
		//Discharge
		s $p(^SSU("SSGRP",id),"^",58)=eobj.SSGRPAutoMedDischarge
		s $p(^SSU("SSGRP",id),"^",92)=eobj.SSGRPDischargeLocList
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitygeneral(eobj As web.Entity.CT.SSGroup) As %String
{
	s result=""
	if $IsObject(eobj)
	{	

		s id=eobj.SSGRPRowId
		//general system information
		s $p(^SSU("SSGRP",id),"^",70)=eobj.SSGRPAllowSendMsgAll
		s $p(^SSU("SSGRP",id),"^",33)=eobj.SSGRPEnableSystemCT
		s $p(^SSU("SSGRP",id),"^",98)=eobj.SSGRPRestrictLocForGrHospitals
		s $p(^SSU("SSGRP",id),"^",64)=eobj.SSGRPSecurityLevel
		s $p(^SSU("SSGRP",id),"^",56)=eobj.SSGRPInactivityTimeOut
		s $p(^SSU("SSGRP",id),"^",61)=eobj.SSGRPPasswordDaysToExpire
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntityoperating(eobj As web.Entity.CT.SSGroup) As %String
{
	s result=""
	if $IsObject(eobj)
	{	

		s id=eobj.SSGRPRowId
		///operating theatre workbench
		s $p(^SSU("SSGRP",id),"^",39)=eobj.SSGRPAllowChangeDepOT
		s $p(^SSU("SSGRP",id),"^",31)=eobj.SSGRPNAllORBookNA
		s $p(^SSU("SSGRP",id),"^",30)=eobj.SSGRPNAllORBookNoSess
		s $p(^SSU("SSGRP",id),"^",29)=eobj.SSGRPNAllORBookPast
		s $p(^SSU("SSGRP",id),"^",142)=eobj.SSGRPDontBookOutsideOTSchedule
		s $p(^SSU("SSGRP",id),"^",28)=eobj.SSGRPWarnORBookingMoveRes
	
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntityorders(eobj As web.Entity.CT.SSGroup) As %String
{
	s result=""
	if $IsObject(eobj)
	{	

		s id=eobj.SSGRPRowId
		///orders and results
		s $p(^SSU("SSGRP",id),"^",55)=eobj.SSGRPAllowToChangeOEStatus
		s $p(^SSU("SSGRP",id),"^",79)=eobj.SSGRPAllowDiscOrdPackedPres
		s $p(^SSU("SSGRP",id),"^",81)=eobj.SSGRPAllowedSeeSEnsitRes
		s $p(^SSU("SSGRP",id),"^",133)=eobj.SSGRPCheckApproved
		s $p(^SSU("SSGRP",id),"^",40)=eobj.SSGRPDefaultDoseEquiv
		s $p(^SSU("SSGRP",id),"^",82)=eobj.SSGRPDisableAddAll
		s $p(^SSU("SSGRP",id),"^",53)=eobj.SSGRPDiscontinueExecOrders
		s $p(^SSU("SSGRP",id),"^",42)=eobj.SSGRPSuppressPin
		s $p(^SSU("SSGRP",id),"^",108)=eobj.SSGRPIgnoreOrderRestrictions
		s $p(^SSU("SSGRP",id),"^",54)=eobj.SSGRPJobOE
		s $p(^SSU("SSGRP",id),"^",6)=eobj.SSGRPMinimizeOEUpdate
		s $p(^SSU("SSGRP",id),"^",5)=eobj.SSGRPRetainOrderCategory
		s $p(^SSU("SSGRP",id),"^",7)=eobj.SSGRPPrice
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitypaper(eobj As web.Entity.CT.SSGroup) As %String
{
	s result=""
	if $IsObject(eobj)
	{	

		s id=eobj.SSGRPRowId
		///paper record traking
		s $p(^SSU("SSGRP",id),"^",25)=eobj.SSGRPAllowIssueArchiveMR
		s $p(^SSU("SSGRP",id),"^",90)=eobj.SSGRPRestrictMRTypeCurrHosp
		s $p(^SSU("SSGRP",id),"^",91)=eobj.SSGRPAllowActivateVolume
		s $p(^SSU("SSGRP",id),"^",94)=eobj.SSGRPAllowNewMRTypesPat
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitypatient(eobj As web.Entity.CT.SSGroup) As %String
{
	s result=""
	if $IsObject(eobj)
	{	

		s id=eobj.SSGRPRowId
		///patient management
		s $p(^SSU("SSGRP",id),"^",34)=eobj.SSGRPWaitListStatusDR
		s $p(^SSU("SSGRP",id),"^",22)=eobj.SSGRPEmergencyLocListDR
		s $p(^SSU("SSGRP",id),"^",23)=eobj.SSGRPHealthPromLocListDR
		s $p(^SSU("SSGRP",id),"^",21)=eobj.SSGRPInPatLocListDR
		s $p(^SSU("SSGRP",id),"^",110)=eobj.SSGRPOnlyInpatUnitsForMyHospita
		s $p(^SSU("SSGRP",id),"^",63)=eobj.SSGRPTempPatLocList
		s $p(^SSU("SSGRP",id),"^",20)=eobj.SSGRPOutPatLocListDR
		s $p(^SSU("SSGRP",id),"^",109)=eobj.SSGRPOnlyOutpatUnitsForMyHospit
		s $p(^SSU("SSGRP",id),"^",132)=eobj.SSGRPInPatTransferListDR
		s $p(^SSU("SSGRP",id),"^",62)=eobj.SSGRPRadLocList
		s $p(^SSU("SSGRP",id),"^",66)=eobj.SSGRPWaitListLocListDR
		s $p(^SSU("SSGRP",id),"^",83)=eobj.SSGRPWLStatusListDR
		s $p(^SSU("SSGRP",id),"^",87)=eobj.SSGRPWardAttendLocListDR
	
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitypatient2(eobj As web.Entity.CT.SSGroup) As %String
{
	s result=""
	if $IsObject(eobj)
	{	

		s id=eobj.SSGRPRowId
		//patient management2
		s $p(^SSU("SSGRP",id),"^",9)=eobj.SSGRPAllowDeleteEpisode
		s $p(^SSU("SSGRP",id),"^",4)=eobj.SSGRPAllowedAddOrdersReview
		;;; s $p(^SSU("SSGRP",id),"^",149)=eobj.SSGRPAllowBookPastGuarDateWL
		s $p(^SSU("SSGRP",id),"^",13)=eobj.SSGRPAllowToChangeFamilyDoctor
		s $p(^SSU("SSGRP",id),"^",14)=eobj.SSGRPChangeDataAfterDischarge
		s $p(^SSU("SSGRP",id),"^",46)=eobj.SSGRPAllowDeleteDiagOtherUs
		s $p(^SSU("SSGRP",id),"^",74)=eobj.SSGRPAllowEditEpLogLoc
		s $p(^SSU("SSGRP",id),"^",129)=eobj.SSGRPAllowEditWLStatusTreated
		s $p(^SSU("SSGRP",id),"^",68)=eobj.SSGRPAllowViewVIPPatients
		s $p(^SSU("SSGRP",id),"^",10)=eobj.SSGRPShowPatientSearch
		s $p(^SSU("SSGRP",id),"^",8)=eobj.SSGRPDisplayDiagnosis
		s $p(^SSU("SSGRP",id),"^",41)=eobj.SSGRPCheckOrdersCovered
		s $p(^SSU("SSGRP",id),"^",114)=eobj.SSGRPShowOnlyIPUnitsForWL
		s $p(^SSU("SSGRP",id),"^",85)=eobj.SSGRPRestrictSearchEMR
		s $p(^SSU("SSGRP",id),"^",19)=eobj.SSGRPShowAllLocations
		s $p(^SSU("SSGRP",id),"^",26)=eobj.SSGRPShowPreadmafterAppoint
		s $p(^SSU("SSGRP",id),"^",43)=eobj.SSGRPMoveToDefaultBed
		s $p(^SSU("SSGRP",id),"^",112)=eobj.SSGRPWLAuditLetterDays
	
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitystock(eobj As web.Entity.CT.SSGroup) As %String
{
	s result=""
	if $IsObject(eobj)
	{	

		s id=eobj.SSGRPRowId
			//stock
		s $p(^SSU("SSGRP",id),"^",48)=eobj.SSGRPAllowEditPriceGR
		s $p(^SSU("SSGRP",id),"^",38)=eobj.SSGRPAllowToChangeAgrPrice
		//s $p(^SSU("SSGRP",id),"^",17)=eobj.SSGRPAllowToAddItemToVendPortfolio
		s $p(^SSU("SSGRP",id),"^",15)=eobj.SSGRPAllowAddStockItem
		//s $p(^SSU("SSGRP",id),"^",16)=eobj.SSGRPAllowToAddItemToLocPortfolio
		s $p(^SSU("SSGRP",id),"^",134)=eobj.SSGRPOnePOforEveryVendor
		s $p(^SSU("SSGRP",id),"^",49)=eobj.SSGRPConsReasonMandatory
		s $p(^SSU("SSGRP",id),"^",135)=eobj.SSGRPUserPOReferenceNotMandator
		s $p(^SSU("SSGRP",id),"^",136)=eobj.SSGRPDefaultPOReferenceDR
		s $p(^SSU("SSGRP",id),"^",116)=eobj.SSGRPMaxPOAmount
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/*
/// Creator：陈莹 
/// CreatDate: 2014-3-25
/// Description：根据RowId查询安全组设置
/// Table：User.SSGroup
/// Return：Json格式的字符串(即：form表单中对应的数据项)
/// w ##class(web.DHCBL.CT.SSGroup).GetSet("1")
ClassMethod GetSet1(id As %String) As %String
{
    s str = ""
	s eobj = ##class(web.Entity.CT.SSGroup).%New()
	s eobj.SSGRPRowId = id
	s eobj.SSGRPDesc=$p($g(^SSU("SSGRP",id)),"^",1)
	s eobj.SSGRPCode=$p($g(^SSU("SSGRP",id)),"^",152) //代码
	s eobj.SSGRPGroupDr=$p($g(^SSU("SSGRP",id)),"^",166) //上级安全组
	//1.Bed Management
	s eobj.SSGRPWardViewLocListDR=$p($g(^SSU("SSGRP",id)),"^",36)
	s eobj.SSGRPWardPlaceLocListDR=$p($g(^SSU("SSGRP",id)),"^",37)
	s eobj.SSGRPAllowDeleteBedTransactions=$p($g(^SSU("SSGRP",id)),"^",47)
	s eobj.SSGRPRestrictWardsToDepartment=$p($g(^SSU("SSGRP",id)),"^",120)
	
	//Booking
	s eobj.SSGRPAllowBookOutsideRange=$p($g(^SSU("SSGRP",id)),"^",11)
	s eobj.SSGRPAllowedtoBookOR=$p($g(^SSU("SSGRP",id)),"^",12)
	;;; 暂时不加  s eobj.SSGRPAllowBookPastGuarDateOP=$p($g(^SSU("SSGRP",id)),"^",148)
	s eobj.SSGRPAllowMultipleServAdhoc=$p($g(^SSU("SSGRP",id)),"^",122)
	s eobj.SSGRPAllowOverBookRB=$p($g(^SSU("SSGRP",id)),"^",32)
	s eobj.SSGRPAllowOverBookOnSlotZero=$p($g(^SSU("SSGRP",id)),"^",104)
	s eobj.SSGRPAllowUndoAppt=$p($g(^SSU("SSGRP",id)),"^",45)
	s eobj.SSGRPAllowOverPayorRestrict=$p($g(^SSU("SSGRP",id)),"^",44)
	s eobj.SSGRPChkFutureAppts=$p($g(^SSU("SSGRP",id)),"^",59)
	s eobj.SSGRPNotBookOutSess=$p($g(^SSU("SSGRP",id)),"^",60)
	s eobj.SSGRPNotExcLoadLevelOverrides=$p($g(^SSU("SSGRP",id)),"^",67)
	s eobj.SSGRPNAllAddPastAppt=$p($g(^SSU("SSGRP",id)),"^",117)
	s eobj.SSGRPDFLocListDR=$p($g(^SSU("SSGRP",id)),"^",69)
	
	///billing and cashiers
	s eobj.SSGRPAllowDiscPaidOrder=$p($g(^SSU("SSGRP",id)),"^",119)
	s eobj.SSGRPRoundingAutomatic=$p($g(^SSU("SSGRP",id)),"^",144)
	s eobj.SSGRPRoundingOnPayment=$p($g(^SSU("SSGRP",id)),"^",143)
	
	//clinical and EMR
	s eobj.SSGRPAllowOSFEdit24hrs=$p($g(^SSU("SSGRP",id)),"^",57)
	s eobj.SSGRPOrdersPrevEpisode=$p($g(^SSU("SSGRP",id)),"^",24)
	//s eobj.SSGRPAllowToExecuteOrderOutsideShift=$p($g(^SSU("SSGRP",id)),"^",18)
	s eobj.SSGRPShowAllPatientsInNWB=$p($g(^SSU("SSGRP",id)),"^",27)
	s eobj.SSGRPDisplayDiagnProcDRG=$p($g(^SSU("SSGRP",id)),"^",35)
	s eobj.SSGRPClinicalLocListDr=$p($g(^SSU("SSGRP",id)),"^",89)
	
	//Discharge
	s eobj.SSGRPAutoMedDischarge=$p($g(^SSU("SSGRP",id)),"^",58)
	s eobj.SSGRPDischargeLocList=$p($g(^SSU("SSGRP",id)),"^",92)
	
	//general system information
	s eobj.SSGRPAllowSendMsgAll=$p($g(^SSU("SSGRP",id)),"^",70)
	s eobj.SSGRPEnableSystemCT=$p($g(^SSU("SSGRP",id)),"^",33)
	s eobj.SSGRPRestrictLocForGrHospitals=$p($g(^SSU("SSGRP",id)),"^",98)
	s eobj.SSGRPSecurityLevel=$p($g(^SSU("SSGRP",id)),"^",64)
	s eobj.SSGRPInactivityTimeOut=$p($g(^SSU("SSGRP",id)),"^",56)
	s eobj.SSGRPPasswordDaysToExpire=$p($g(^SSU("SSGRP",id)),"^",61)
	
	///operating theatre workbench
	s eobj.SSGRPAllowChangeDepOT=$p($g(^SSU("SSGRP",id)),"^",39)
	s eobj.SSGRPNAllORBookNA=$p($g(^SSU("SSGRP",id)),"^",31)
	s eobj.SSGRPNAllORBookNoSess=$p($g(^SSU("SSGRP",id)),"^",30)
	s eobj.SSGRPNAllORBookPast=$p($g(^SSU("SSGRP",id)),"^",29)
	s eobj.SSGRPDontBookOutsideOTSchedule=$p($g(^SSU("SSGRP",id)),"^",142)
	s eobj.SSGRPWarnORBookingMoveRes=$p($g(^SSU("SSGRP",id)),"^",28)
	
	///order and results
	s eobj.SSGRPAllowToChangeOEStatus=$p($g(^SSU("SSGRP",id)),"^",55)
	s eobj.SSGRPAllowDiscOrdPackedPres=$p($g(^SSU("SSGRP",id)),"^",79)
	s eobj.SSGRPAllowedSeeSEnsitRes=$p($g(^SSU("SSGRP",id)),"^",81)
	s eobj.SSGRPCheckApproved=$p($g(^SSU("SSGRP",id)),"^",133)
	s eobj.SSGRPDefaultDoseEquiv=$p($g(^SSU("SSGRP",id)),"^",40)
	s eobj.SSGRPDisableAddAll=$p($g(^SSU("SSGRP",id)),"^",82)
	s eobj.SSGRPDiscontinueExecOrders=$p($g(^SSU("SSGRP",id)),"^",53)
	s eobj.SSGRPSuppressPin=$p($g(^SSU("SSGRP",id)),"^",42)
	s eobj.SSGRPIgnoreOrderRestrictions=$p($g(^SSU("SSGRP",id)),"^",108)
	s eobj.SSGRPJobOE=$p($g(^SSU("SSGRP",id)),"^",54)
	s eobj.SSGRPMinimizeOEUpdate=$p($g(^SSU("SSGRP",id)),"^",6)
	s eobj.SSGRPRetainOrderCategory=$p($g(^SSU("SSGRP",id)),"^",5)
	s eobj.SSGRPPrice=$p($g(^SSU("SSGRP",id)),"^",7)
	
	///paper record traking
	s eobj.SSGRPAllowIssueArchiveMR=$p($g(^SSU("SSGRP",id)),"^",25)
	s eobj.SSGRPRestrictMRTypeCurrHosp=$p($g(^SSU("SSGRP",id)),"^",90)
	s eobj.SSGRPAllowActivateVolume=$p($g(^SSU("SSGRP",id)),"^",91)
	s eobj.SSGRPAllowNewMRTypesPat=$p($g(^SSU("SSGRP",id)),"^",94)
	
	///patient management
	s eobj.SSGRPWaitListStatusDR=$p($g(^SSU("SSGRP",id)),"^",34)  //User.PACWaitingListStatus
	s eobj.SSGRPEmergencyLocListDR=$p($g(^SSU("SSGRP",id)),"^",22)  //User.CTLocationList
	s eobj.SSGRPHealthPromLocListDR=$p($g(^SSU("SSGRP",id)),"^",23) //
	s eobj.SSGRPInPatLocListDR=$p($g(^SSU("SSGRP",id)),"^",21) //
	s eobj.SSGRPOnlyInpatUnitsForMyHospita=$p($g(^SSU("SSGRP",id)),"^",110)
	s eobj.SSGRPTempPatLocList=$p($g(^SSU("SSGRP",id)),"^",63)  //
	s eobj.SSGRPOutPatLocListDR=$p($g(^SSU("SSGRP",id)),"^",20) //
	s eobj.SSGRPOnlyOutpatUnitsForMyHospit=$p($g(^SSU("SSGRP",id)),"^",109)
	s eobj.SSGRPInPatTransferListDR=$p($g(^SSU("SSGRP",id)),"^",132) // 
	s eobj.SSGRPRadLocList=$p($g(^SSU("SSGRP",id)),"^",62) //
	s eobj.SSGRPWaitListLocListDR=$p($g(^SSU("SSGRP",id)),"^",66) //
	s eobj.SSGRPWLStatusListDR=$p($g(^SSU("SSGRP",id)),"^",83)  //User.PACWLStatusList
	s eobj.SSGRPWardAttendLocListDR=$p($g(^SSU("SSGRP",id)),"^",87) //
	
	//patient management2
	s eobj.SSGRPAllowDeleteEpisode=$p($g(^SSU("SSGRP",id)),"^",9)
	s eobj.SSGRPAllowedAddOrdersReview=$p($g(^SSU("SSGRP",id)),"^",4)
	;;;暂时不加  s eobj.SSGRPAllowBookPastGuarDateWL=$p($g(^SSU("SSGRP",id)),"^",149)
	s eobj.SSGRPAllowToChangeFamilyDoctor=$p($g(^SSU("SSGRP",id)),"^",13)
	s eobj.SSGRPChangeDataAfterDischarge=$p($g(^SSU("SSGRP",id)),"^",14)
	s eobj.SSGRPAllowDeleteDiagOtherUs=$p($g(^SSU("SSGRP",id)),"^",46)
	s eobj.SSGRPAllowEditEpLogLoc=$p($g(^SSU("SSGRP",id)),"^",74)
	s eobj.SSGRPAllowEditWLStatusTreated=$p($g(^SSU("SSGRP",id)),"^",129)
	s eobj.SSGRPAllowViewVIPPatients=$p($g(^SSU("SSGRP",id)),"^",68)
	s eobj.SSGRPShowPatientSearch=$p($g(^SSU("SSGRP",id)),"^",10)
	s eobj.SSGRPDisplayDiagnosis=$p($g(^SSU("SSGRP",id)),"^",8)
	s eobj.SSGRPCheckOrdersCovered=$p($g(^SSU("SSGRP",id)),"^",41)
	s eobj.SSGRPShowOnlyIPUnitsForWL=$p($g(^SSU("SSGRP",id)),"^",114)
	s eobj.SSGRPRestrictSearchEMR=$p($g(^SSU("SSGRP",id)),"^",85)
	s eobj.SSGRPShowAllLocations=$p($g(^SSU("SSGRP",id)),"^",19)
	s eobj.SSGRPShowPreadmafterAppoint=$p($g(^SSU("SSGRP",id)),"^",26)
	s eobj.SSGRPMoveToDefaultBed=$p($g(^SSU("SSGRP",id)),"^",43)
	s eobj.SSGRPWLAuditLetterDays=$p($g(^SSU("SSGRP",id)),"^",112)
	
	//stock
	s eobj.SSGRPAllowEditPriceGR=$p($g(^SSU("SSGRP",id)),"^",48)
	s eobj.SSGRPAllowToChangeAgrPrice=$p($g(^SSU("SSGRP",id)),"^",38)
	//s eobj.SSGRPAllowToAddItemToVendPortfolio=$p($g(^SSU("SSGRP",id)),"^",17)
	s eobj.SSGRPAllowAddStockItem=$p($g(^SSU("SSGRP",id)),"^",15)
	//s eobj.SSGRPAllowToAddItemToLocPortfolio=$p($g(^SSU("SSGRP",id)),"^",16)
	s eobj.SSGRPOnePOforEveryVendor=$p($g(^SSU("SSGRP",id)),"^",134)
	s eobj.SSGRPConsReasonMandatory=$p($g(^SSU("SSGRP",id)),"^",49)
	s eobj.SSGRPUserPOReferenceNotMandator=$p($g(^SSU("SSGRP",id)),"^",135)
	s eobj.SSGRPDefaultPOReferenceDR=$p($g(^SSU("SSGRP",id)),"^",136)
	s eobj.SSGRPMaxPOAmount=$p($g(^SSU("SSGRP",id)),"^",116)
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}
*/
/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：User.SSGroup
/// Return：Json格式的字符串(即：form表单中对应的数据项)
/// w ##class(web.DHCBL.CT.SSGroup).OpenData(1)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(User.SSGroup).%OpenId(id)
	s eobj = ##class(web.Entity.CT.SSGroup).%New()
	s eobj.SSGRPRowId = id
	s eobj.SSGRPDesc = pobj.SSGRPDesc
	s eobj.SSGRPActiveFlag = pobj.SSGRPActiveFlag
	s eobj.SSGRPCode=pobj.SSGRPCode //代码
	if $IsObject(pobj.SSGRPGroupDr)
	{
		s eobj.SSGRPGroupDr = pobj.SSGRPGroupDr.%Id()   //上级安全组
	}
	if (eobj.SSGRPDesc["停用")
	{
		s eobj.SSGRPActiveFlag = "N"    //有效标志		
	}
	s:eobj.SSGRPActiveFlag="" eobj.SSGRPActiveFlag="Y"
	s:eobj.SSGRPActiveFlag="Y" eobj.SSGRPActiveFlag="true"
	s eobj.SSGRPStartDate=pobj.SSGRPStartDate //开始日期
	s eobj.SSGRPEndDate=pobj.SSGRPEndDate //结束日期
	s:eobj.SSGRPStartDate'="" eobj.SSGRPStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.SSGRPStartDate)
	s:eobj.SSGRPEndDate'="" eobj.SSGRPEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.SSGRPEndDate)
	s eobj.SSGRPSeqNo=pobj.SSGRPSeqNo //系统排序号
	s eobj.SSGRPPYCode=pobj.SSGRPPYCode //拼音码
	s eobj.SSGRPWBCode=pobj.SSGRPWBCode //五笔码
	s eobj.SSGRPMark=pobj.SSGRPMark //备注
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹 
/// CreatDate:2012-12-24
/// Description:数据重复验证方法,js调用
/// Table:User.SSGroup
/// Input:id, desc,hospid,code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.SSGroup).FormValidate("","","","")
ClassMethod FormValidate(id As %String, desc As %String, hospid As %String = "", code As %String) As %String
{
	n (id,desc,hospid,code)
	s flag=0
	if desc'=""
	{
		if $d(^SSU("SSGRP",0,"Desc"))
		{
			s rowid=0
			for
		    {
				s rowid=$o(^SSU("SSGRP",0,"Desc",desc,rowid)) q:(rowid="")||(flag=1)
				i (rowid'=id)
				{
					s flag=1 //有重复
				}
		    }
		}
		else
		{
			s rowid=0
			for
		    {
				s rowid=$o(^SSU("SSGRP",rowid)) q:(rowid="")||(flag=1)
				s SSGRPDesc=$p($g(^SSU("SSGRP",rowid)),"^",1)
				i (desc=SSGRPDesc)&(rowid'=id)
				{
					s flag=1 //有重复
				}
		    }
		}
	}
	if code'=""
	{
		if $d(^SSU("SSGRP",0,"Code"))
		{
			s rowid=0
			for
		    {
				s rowid=$o(^SSU("SSGRP",0,"Code",code,rowid)) q:(rowid="")||(flag=1)
				i (rowid'=id)
				{
					s flag=1 //有重复
				}
		    }
		}
		else
		{
			s rowid=0
			for
		    {
				s rowid=$o(^SSU("SSGRP",rowid)) q:(rowid="")||(flag=1)
				s SSGRPCode=$p($g(^SSU("SSGRP",rowid)),"^",152)
				continue:SSGRPCode=""
				i (code=SSGRPCode)&(rowid'=id)
				{
					s flag=1 //有重复
				}
		    }
		}
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2013-05-06
/// Description:保存 安全组
/// Table:User.SSGroup
/// Input:web.Entity.CT.SSGroup
/// Return:成功返回true和id,失败返回false和errorinfo
ClassMethod SaveEntity(eobj As web.Entity.CT.SSGroup) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{	
		s:eobj.SSGRPActiveFlag="" eobj.SSGRPActiveFlag ="N" 
		if (eobj.SSGRPDesc["停用") s eobj.SSGRPActiveFlag ="N" 
		s:eobj.SSGRPStartDate'="" eobj.SSGRPStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.SSGRPStartDate)
		s:eobj.SSGRPEndDate'="" eobj.SSGRPEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.SSGRPEndDate)
		s:eobj.SSGRPStartDate="" eobj.SSGRPStartDate=+$h
		s eobj.SSGRPLastUpdateDate=+$H               ///系统最后更新日期
		s eobj.SSGRPLastUpdateTime=$p($h,",",2)       ///系统最后更新时间
		if (eobj.ID="")  //新增
		{
			s eobj.SSGRPCreateDate=+$H           ///系统创建日期
			s eobj.SSGRPCreateTime=$p($h,",",2)  ///系统创建时间
		}
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID")) 
			if (eobj.SSGRPCreateUser="")&&(eobj.ID="") s eobj.SSGRPCreateUser=USERID   ///系统创建人
			if (eobj.SSGRPLastUpdateUser="") s eobj.SSGRPLastUpdateUser=USERID  ///系统最新更新人
		}
		if (eobj.SSGRPDesc="")
		{
			s result = "{success:'false',errorinfo:'安全组不可为空！'}"
		}
		else
		{
			
			s flag= ##class(web.DHCBL.CT.SSGroup).FormValidate(eobj.SSGRPRowId,eobj.SSGRPDesc,eobj.LinkHospId,eobj.SSGRPCode)
			if flag=1 q "{success:'false',errorinfo:'该记录已经存在！'}"
			if (eobj.SSGRPRowId="") //如果RowId未赋值则增加
			{
				s obj=##class(User.SSGroup).%New()
				s obj.SSGRPCreateDate=eobj.SSGRPCreateDate         ///系统创建日期
				s obj.SSGRPCreateTime=eobj.SSGRPCreateTime  ///系统创建时间
				d obj.SSGRPCreateUserSetObjectId(eobj.SSGRPLastUpdateUser)  ///系统创建人
			}
			else //如果RowId已赋值则修改
			{
				s obj=##class(User.SSGroup).%OpenId(eobj.SSGRPRowId)
				s bobj = ##class(web.Entity.CT.SSGroup).%New()
				s bobj.SSGRPRowId = eobj.SSGRPRowId  
				s bobj.SSGRPDesc = obj.SSGRPDesc   //安全组名称
				s bobj.SSGRPCode = obj.SSGRPCode   //安全组代码
				s bobj.SSGRPActiveFlag = obj.SSGRPActiveFlag    //有效标志
				if $IsObject(obj.SSGRPGroupDr){
					s bobj.SSGRPGroupDr = obj.SSGRPGroupDr.%Id()   // 上级安全组代码
				}
				
				s bobj.SSGRPStartDate=obj.SSGRPStartDate //开始日期
				s bobj.SSGRPEndDate=obj.SSGRPEndDate //结束日期
				s bobj.SSGRPCreateDate=obj.SSGRPCreateDate ///系统创建日期
				s bobj.SSGRPCreateTime=obj.SSGRPCreateTime ///系统创建时间
				if $IsObject(obj.SSGRPCreateUser)
				{   
					s bobj.SSGRPCreateUser = obj.SSGRPCreateUser.%Id()   ///系统创建人
				}
				s bobj.SSGRPSeqNo=obj.SSGRPSeqNo ///系统排序号
				s bobj.SSGRPLastUpdateDate=obj.SSGRPLastUpdateDate ///系统最后更新日期
				s bobj.SSGRPLastUpdateTime=obj.SSGRPLastUpdateTime ///系统最后更新时间
				if $IsObject(obj.SSGRPLastUpdateUser)
				{   
					s bobj.SSGRPLastUpdateUser = obj.SSGRPLastUpdateUser.%Id()   ///系统最新更新人
				}
				s bobj.SSGRPPYCode=obj.SSGRPPYCode //拼音码
				s bobj.SSGRPWBCode=obj.SSGRPWBCode //五笔码
				s bobj.SSGRPMark=obj.SSGRPMark //备注
	
			}
			s obj.SSGRPDesc = eobj.SSGRPDesc    //安全组名称
			s obj.SSGRPCode = eobj.SSGRPCode    //安全组代码
			s obj.SSGRPActiveFlag = eobj.SSGRPActiveFlag    //有效标志
			d obj.SSGRPGroupDrSetObjectId(eobj.SSGRPGroupDr)  // 上级安全组代码
			s obj.SSGRPStartDate = eobj.SSGRPStartDate  //开始日期
			s obj.SSGRPEndDate = eobj.SSGRPEndDate      //结束日期 
			s obj.SSGRPSeqNo=eobj.SSGRPSeqNo              ///系统排序号
			s obj.SSGRPLastUpdateDate=eobj.SSGRPLastUpdateDate   ///系统最后更新日期
			s obj.SSGRPLastUpdateTime=eobj.SSGRPLastUpdateTime   ///系统最后更新时间
			d obj.SSGRPLastUpdateUserSetObjectId(eobj.SSGRPLastUpdateUser)  ///系统最新更新人
			s obj.SSGRPPYCode=eobj.SSGRPPYCode ///拼音码
			s obj.SSGRPWBCode=eobj.SSGRPWBCode ///五笔码
			s obj.SSGRPMark=eobj.SSGRPMark ///备注
			
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"
				if (eobj.SSGRPRowId="")
				{
					if eobj.LinkHospId'=""
					{
						///2020-05-20添加时自动和医院关联
						s hospeobj=##class(web.Entity.CT.SSGroupHospitals).%New()
						s hospeobj.HOSPRowId=""
						s hospeobj.HOSPHospitalDR=eobj.LinkHospId
						s hospeobj.HOSPParRef=id
						D ##class(web.DHCBL.CT.SSGroupHospitals).SaveEntity(hospeobj)	
					}
				}
				d:eobj.SSGRPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_Group","User.SSGroup","安全组",id,eobj.SSGRPDesc,"A",eobj)
				d:eobj.SSGRPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_Group","User.SSGroup","安全组",id,eobj.SSGRPDesc,"U",eobj,bobj)
			}else{
				Trollback
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组","web.DHCBL.CT.SSGroup","SaveEntity",eobj)
    			s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:陈莹
/// CreatDate:2014-12-16
/// Description:保存 安全组所有参数配置
/// Table:User.SSGroup
/// Input:web.Entity.CT.SSGroup
/// Return:成功返回true和id,失败返回false和errorinfo
ClassMethod SaveEntityAll(eobj As web.Entity.CT.SSGroup) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.SSGRPActiveFlag="" eobj.SSGRPActiveFlag ="N" 
		if (eobj.SSGRPDesc["停用") s eobj.SSGRPActiveFlag ="N" 
		s:eobj.SSGRPStartDate'="" eobj.SSGRPStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.SSGRPStartDate)
		s:eobj.SSGRPEndDate'="" eobj.SSGRPEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.SSGRPEndDate)
		s:eobj.SSGRPStartDate="" eobj.SSGRPStartDate=+$h
		s eobj.SSGRPLastUpdateDate=+$H               ///系统最后更新日期
		s eobj.SSGRPLastUpdateTime=$p($h,",",2)       ///系统最后更新时间
		if (eobj.SSGRPRowId="")  //新增
		{
			s eobj.SSGRPCreateDate=+$H           ///系统创建日期
			s eobj.SSGRPCreateTime=$p($h,",",2)  ///系统创建时间
		}
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID")) 
			if (eobj.SSGRPCreateUser="")&&(eobj.SSGRPRowId="") s eobj.SSGRPCreateUser=USERID   ///系统创建人
			if (eobj.SSGRPLastUpdateUser="") s eobj.SSGRPLastUpdateUser=USERID  ///系统最新更新人
		}
		if (eobj.SSGRPDesc="")
		{
			s result = "{success:'false',errorinfo:'安全组不可为空！'}"
		}
		else
		{
			s flag= ##class(web.DHCBL.CT.SSGroup).FormValidate(eobj.SSGRPRowId,eobj.SSGRPDesc,eobj.LinkHospId,eobj.SSGRPCode)
			if flag=1 q "{success:'false',errorinfo:'该记录已经存在！'}"
			
			if (eobj.SSGRPRowId="") //如果RowId未赋值则增加
			{
	        	s obj=##class(User.SSGroup).%New()
	        	s obj.SSGRPCreateDate=eobj.SSGRPCreateDate         ///系统创建日期
				s obj.SSGRPCreateTime=eobj.SSGRPCreateTime  ///系统创建时间
				d obj.SSGRPCreateUserSetObjectId(eobj.SSGRPLastUpdateUser)  ///系统创建人
			}
			else //如果RowId已赋值则修改
			{
				///SSGRPCumAllowedSeeGraphLink 数据有误，存在多个空格 应该是,Y,N
				s:$p($G(^SSU("SSGRP",eobj.SSGRPRowId)),"^",102)'="Y" $p(^SSU("SSGRP",eobj.SSGRPRowId),"^",102)="N"
				//SSGRP_DisplayQnsOnAlertScreen
				s:$p($G(^SSU("SSGRP",eobj.SSGRPRowId)),"^",106)'="Y" $p(^SSU("SSGRP",eobj.SSGRPRowId),"^",106)="N"
				
				
				
				s obj=##class(User.SSGroup).%OpenId(eobj.SSGRPRowId)
				///日志bobj
				s bobj = ##class(web.Entity.CT.SSGroup).%New()
				s bobj.SSGRPRowId = eobj.SSGRPRowId  
				s bobj.SSGRPDesc = obj.SSGRPDesc
				s bobj.SSGRPActiveFlag = obj.SSGRPActiveFlag    //有效标志
				s bobj.SSGRPCode = obj.SSGRPCode   //安全组代码
				if $IsObject(obj.SSGRPGroupDr){
					s bobj.SSGRPGroupDr = obj.SSGRPGroupDr.%Id()   // 上级安全组代码
				}
				s bobj.SSGRPStartDate=obj.SSGRPStartDate //开始日期
				s bobj.SSGRPEndDate=obj.SSGRPEndDate //结束日期
				s bobj.SSGRPCreateDate=obj.SSGRPCreateDate ///系统创建日期
				s bobj.SSGRPCreateTime=obj.SSGRPCreateTime ///系统创建时间
				if $IsObject(obj.SSGRPCreateUser)
				{   
					s bobj.SSGRPCreateUser = obj.SSGRPCreateUser.%Id()   ///系统创建人
				}
				s bobj.SSGRPSeqNo=obj.SSGRPSeqNo ///系统排序号
				s bobj.SSGRPLastUpdateDate=obj.SSGRPLastUpdateDate ///系统最后更新日期
				s bobj.SSGRPLastUpdateTime=obj.SSGRPLastUpdateTime ///系统最后更新时间
				if $IsObject(obj.SSGRPLastUpdateUser)
				{   
					s bobj.SSGRPLastUpdateUser = obj.SSGRPLastUpdateUser.%Id()   ///系统最新更新人
				}
				s bobj.SSGRPPYCode=obj.SSGRPPYCode //拼音码
				s bobj.SSGRPWBCode=obj.SSGRPWBCode //五笔码
				s bobj.SSGRPMark=obj.SSGRPMark //备注
				//1.Bed Management
				if $IsObject(obj.SSGRPWardViewLocListDR){
					s bobj.SSGRPWardViewLocListDR = obj.SSGRPWardViewLocListDR.%Id() 
				}
				if $IsObject(obj.SSGRPWardPlaceLocListDR){
					s bobj.SSGRPWardPlaceLocListDR = obj.SSGRPWardPlaceLocListDR.%Id() 
				}
				s bobj.SSGRPAllowDeleteBedTransactions=obj.SSGRPAllowDeleteBedTransactions		
				s bobj.SSGRPRestrictWardsToDepartment=obj.SSGRPRestrictWardsToDepartment
	
				//Booking
				s bobj.SSGRPAllowBookOutsideRange=obj.SSGRPAllowBookOutsideRange
				s bobj.SSGRPAllowedtoBookOR=obj.SSGRPAllowedtoBookOR
				;;; 暂时不加  s eobj.SSGRPAllowBookPastGuarDateOP=obj.SSGRPAllowBookPastGuarDateOP
				s bobj.SSGRPAllowMultipleServAdhoc=obj.SSGRPAllowMultipleServAdhoc
				s bobj.SSGRPAllowOverBookRB=obj.SSGRPAllowOverBookRB
				s bobj.SSGRPAllowOverBookOnSlotZero=obj.SSGRPAllowOverBookOnSlotZero
				s bobj.SSGRPAllowUndoAppt=obj.SSGRPAllowUndoAppt
				s bobj.SSGRPAllowOverPayorRestrict=obj.SSGRPAllowOverPayorRestrict
				s bobj.SSGRPChkFutureAppts=obj.SSGRPChkFutureAppts
				s bobj.SSGRPNotBookOutSess=obj.SSGRPNotBookOutSess
				s bobj.SSGRPNotExcLoadLevelOverrides=obj.SSGRPNotExcLoadLevelOverrides
				s bobj.SSGRPNAllAddPastAppt=obj.SSGRPNAllAddPastAppt
				if $IsObject(obj.SSGRPDFLocListDR){
					s bobj.SSGRPDFLocListDR = obj.SSGRPDFLocListDR.%Id() 
				}
	
	
				///billing and cashiers
				s bobj.SSGRPAllowDiscPaidOrder=obj.SSGRPAllowDiscPaidOrder
				s bobj.SSGRPRoundingAutomatic=obj.SSGRPRoundingAutomatic
				s bobj.SSGRPRoundingOnPayment=obj.SSGRPRoundingOnPayment
	
				//clinical and EMR
				s bobj.SSGRPAllowOSFEdit24hrs=obj.SSGRPAllowOSFEdit24hrs
				s bobj.SSGRPOrdersPrevEpisode=obj.SSGRPOrdersPrevEpisode
				//s eobj.SSGRPAllowToExecuteOrderOutsideShift=obj.SSGRPAllowToExecuteOrderOutsideShift
				s bobj.SSGRPShowAllPatientsInNWB=obj.SSGRPShowAllPatientsInNWB
				s bobj.SSGRPDisplayDiagnProcDRG=obj.SSGRPDisplayDiagnProcDRG
				if $IsObject(obj.SSGRPClinicalLocListDr){
					s bobj.SSGRPClinicalLocListDr = obj.SSGRPClinicalLocListDr.%Id() 
				}
				
	
				//Discharge
				s bobj.SSGRPAutoMedDischarge=obj.SSGRPAutoMedDischarge
				if $IsObject(obj.SSGRPDischargeLocList){
					s bobj.SSGRPDischargeLocList = obj.SSGRPDischargeLocList.%Id() 
				}
	
				//general system information
				s bobj.SSGRPAllowSendMsgAll=obj.SSGRPAllowSendMsgAll
				s bobj.SSGRPEnableSystemCT=obj.SSGRPEnableSystemCT
				s bobj.SSGRPRestrictLocForGrHospitals=obj.SSGRPRestrictLocForGrHospitals
				s bobj.SSGRPSecurityLevel=obj.SSGRPSecurityLevel
				s bobj.SSGRPInactivityTimeOut=obj.SSGRPInactivityTimeOut
				s bobj.SSGRPPasswordDaysToExpire=obj.SSGRPPasswordDaysToExpire
	
				///operating theatre workbench
				s bobj.SSGRPAllowChangeDepOT=obj.SSGRPAllowChangeDepOT
				s bobj.SSGRPNAllORBookNA=obj.SSGRPNAllORBookNA
				s bobj.SSGRPNAllORBookNoSess=obj.SSGRPNAllORBookNoSess
				s bobj.SSGRPNAllORBookPast=obj.SSGRPNAllORBookPast
				s bobj.SSGRPDontBookOutsideOTSchedule=obj.SSGRPDontBookOutsideOTSchedule
				s bobj.SSGRPWarnORBookingMoveRes=obj.SSGRPWarnORBookingMoveRes
	
				///order and results
				s bobj.SSGRPAllowToChangeOEStatus=obj.SSGRPAllowToChangeOEStatus
				s bobj.SSGRPAllowDiscOrdPackedPres=obj.SSGRPAllowDiscOrdPackedPres
				s bobj.SSGRPAllowedSeeSEnsitRes=obj.SSGRPAllowedSeeSEnsitRes
				s bobj.SSGRPCheckApproved=obj.SSGRPCheckApproved
				s bobj.SSGRPDefaultDoseEquiv=obj.SSGRPDefaultDoseEquiv
				s bobj.SSGRPDisableAddAll=obj.SSGRPDisableAddAll
				s bobj.SSGRPDiscontinueExecOrders=obj.SSGRPDiscontinueExecOrders
				s bobj.SSGRPSuppressPin=obj.SSGRPSuppressPin
				s bobj.SSGRPIgnoreOrderRestrictions=obj.SSGRPIgnoreOrderRestrictions
				s bobj.SSGRPJobOE= obj.SSGRPJobOE
				s bobj.SSGRPMinimizeOEUpdate=obj.SSGRPMinimizeOEUpdate
				s bobj.SSGRPRetainOrderCategory=obj.SSGRPRetainOrderCategory
				s bobj.SSGRPPrice=obj.SSGRPPrice
	
				///paper record traking
				s bobj.SSGRPAllowIssueArchiveMR=obj.SSGRPAllowIssueArchiveMR
				s bobj.SSGRPRestrictMRTypeCurrHosp=obj.SSGRPRestrictMRTypeCurrHosp
				s bobj.SSGRPAllowActivateVolume=obj.SSGRPAllowActivateVolume
				s bobj.SSGRPAllowNewMRTypesPat=obj.SSGRPAllowNewMRTypesPat
	
				///patient management
				if $IsObject(obj.SSGRPWaitListStatusDR){
					s bobj.SSGRPWaitListStatusDR = obj.SSGRPWaitListStatusDR.%Id() 
				}
				if $IsObject(obj.SSGRPEmergencyLocListDR){
					s bobj.SSGRPEmergencyLocListDR = obj.SSGRPEmergencyLocListDR.%Id() 
				}
				if $IsObject(obj.SSGRPHealthPromLocListDR){
					s bobj.SSGRPHealthPromLocListDR = obj.SSGRPHealthPromLocListDR.%Id() 
				}
				if $IsObject(obj.SSGRPInPatLocListDR){
					s bobj.SSGRPInPatLocListDR = obj.SSGRPInPatLocListDR.%Id() 
				}
				s bobj.SSGRPOnlyInpatUnitsForMyHospita=obj.SSGRPOnlyInpatUnitsForMyHospita
				if $IsObject(obj.SSGRPTempPatLocList){
					s bobj.SSGRPTempPatLocList = obj.SSGRPTempPatLocList.%Id() 
				}
				if $IsObject(obj.SSGRPOutPatLocListDR){
					s bobj.SSGRPOutPatLocListDR = obj.SSGRPOutPatLocListDR.%Id() 
				}
				s bobj.SSGRPOnlyOutpatUnitsForMyHospit=obj.SSGRPOnlyOutpatUnitsForMyHospit
				if $IsObject(obj.SSGRPInPatTransferListDR){
					s bobj.SSGRPInPatTransferListDR = obj.SSGRPInPatTransferListDR.%Id() 
				}
				if $IsObject(obj.SSGRPRadLocList){
					s bobj.SSGRPRadLocList = obj.SSGRPRadLocList.%Id() 
				}
				if $IsObject(obj.SSGRPWaitListLocListDR){
					s bobj.SSGRPWaitListLocListDR = obj.SSGRPWaitListLocListDR.%Id() 
				}
				if $IsObject(obj.SSGRPWLStatusListDR){
					s bobj.SSGRPWLStatusListDR = obj.SSGRPWLStatusListDR.%Id() 
				}
				if $IsObject(obj.SSGRPWardAttendLocListDR){
					s bobj.SSGRPWardAttendLocListDR = obj.SSGRPWardAttendLocListDR.%Id() 
				}
				
	
				//patient management2
				s bobj.SSGRPAllowDeleteEpisode=obj.SSGRPAllowDeleteEpisode
				s bobj.SSGRPAllowedAddOrdersReview=obj.SSGRPAllowedAddOrdersReview
				;;;暂时不加  s eobj.SSGRPAllowBookPastGuarDateWL=obj.SSGRPAllowBookPastGuarDateWL
				s bobj.SSGRPAllowToChangeFamilyDoctor=obj.SSGRPAllowToChangeFamilyDoctor
				s bobj.SSGRPChangeDataAfterDischarge=obj.SSGRPChangeDataAfterDischarge
				s bobj.SSGRPAllowDeleteDiagOtherUs=obj.SSGRPAllowDeleteDiagOtherUs
				s bobj.SSGRPAllowEditEpLogLoc=obj.SSGRPAllowEditEpLogLoc
				s bobj.SSGRPAllowEditWLStatusTreated=obj.SSGRPAllowEditWLStatusTreated
				s bobj.SSGRPAllowViewVIPPatients=obj.SSGRPAllowViewVIPPatients
				s bobj.SSGRPShowPatientSearch=obj.SSGRPShowPatientSearch
				s bobj.SSGRPDisplayDiagnosis=obj.SSGRPDisplayDiagnosis
				s bobj.SSGRPCheckOrdersCovered=obj.SSGRPCheckOrdersCovered
				s bobj.SSGRPShowOnlyIPUnitsForWL=obj.SSGRPShowOnlyIPUnitsForWL
				s bobj.SSGRPRestrictSearchEMR=obj.SSGRPRestrictSearchEMR
				s bobj.SSGRPShowAllLocations=obj.SSGRPShowAllLocations
				s bobj.SSGRPShowPreadmafterAppoint=obj.SSGRPShowPreadmafterAppoint
				s bobj.SSGRPMoveToDefaultBed=obj.SSGRPMoveToDefaultBed
				s bobj.SSGRPWLAuditLetterDays=obj.SSGRPWLAuditLetterDays
	
				//stock
				s bobj.SSGRPAllowEditPriceGR=obj.SSGRPAllowEditPriceGR
				s bobj.SSGRPAllowToChangeAgrPrice=obj.SSGRPAllowToChangeAgrPrice
				//s eobj.SSGRPAllowToAddItemToVendPortfolio=obj.SSGRPAllowToAddItemToVendPortfolio
				s bobj.SSGRPAllowAddStockItem=obj.SSGRPAllowAddStockItem
				//s eobj.SSGRPAllowToAddItemToLocPortfolio=obj.SSGRPAllowToAddItemToLocPortfolio
				s bobj.SSGRPOnePOforEveryVendor=obj.SSGRPOnePOforEveryVendor
				s bobj.SSGRPConsReasonMandatory=obj.SSGRPConsReasonMandatory
				s bobj.SSGRPUserPOReferenceNotMandator=obj.SSGRPUserPOReferenceNotMandator
				if $IsObject(obj.SSGRPDefaultPOReferenceDR){
					s bobj.SSGRPDefaultPOReferenceDR = obj.SSGRPDefaultPOReferenceDR.%Id() 
				}
				s bobj.SSGRPMaxPOAmount=obj.SSGRPMaxPOAmount
				
				
			}
				
				
			s obj.SSGRPDesc = eobj.SSGRPDesc 
			s obj.SSGRPCode = eobj.SSGRPCode    //安全组代码
			s obj.SSGRPActiveFlag = eobj.SSGRPActiveFlag    //有效标志
			d obj.SSGRPGroupDrSetObjectId(eobj.SSGRPGroupDr)  // 上级安全组代码
			s obj.SSGRPStartDate = eobj.SSGRPStartDate  //开始日期
			s obj.SSGRPEndDate = eobj.SSGRPEndDate      //结束日期 
			s obj.SSGRPSeqNo=eobj.SSGRPSeqNo              ///系统排序号
			s obj.SSGRPLastUpdateDate=eobj.SSGRPLastUpdateDate   ///系统最后更新日期
			s obj.SSGRPLastUpdateTime=eobj.SSGRPLastUpdateTime   ///系统最后更新时间
			d obj.SSGRPLastUpdateUserSetObjectId(eobj.SSGRPLastUpdateUser)  ///系统最新更新人
			s obj.SSGRPPYCode=eobj.SSGRPPYCode ///拼音码
			s obj.SSGRPWBCode=eobj.SSGRPWBCode ///五笔码
			s obj.SSGRPMark=eobj.SSGRPMark ///备注
			//1.Bed Management
			d obj.SSGRPWardViewLocListDRSetObjectId(eobj.SSGRPWardViewLocListDR)
			d obj.SSGRPWardPlaceLocListDRSetObjectId(eobj.SSGRPWardPlaceLocListDR)
			s:eobj.SSGRPAllowDeleteBedTransactions="" eobj.SSGRPAllowDeleteBedTransactions="N" //checkbox
			s obj.SSGRPAllowDeleteBedTransactions=eobj.SSGRPAllowDeleteBedTransactions		
			s:eobj.SSGRPRestrictWardsToDepartment="" eobj.SSGRPRestrictWardsToDepartment="N"
			s obj.SSGRPRestrictWardsToDepartment=eobj.SSGRPRestrictWardsToDepartment

			//Booking
			s:eobj.SSGRPAllowBookOutsideRange="" eobj.SSGRPAllowBookOutsideRange="N"
			s obj.SSGRPAllowBookOutsideRange=eobj.SSGRPAllowBookOutsideRange
			s:eobj.SSGRPAllowedtoBookOR="" eobj.SSGRPAllowedtoBookOR="N"
			s obj.SSGRPAllowedtoBookOR=eobj.SSGRPAllowedtoBookOR
			;;; 暂时不加  s eobj.SSGRPAllowBookPastGuarDateOP=eobj.SSGRPAllowBookPastGuarDateOP
			s:eobj.SSGRPAllowMultipleServAdhoc="" eobj.SSGRPAllowMultipleServAdhoc="N"
			s obj.SSGRPAllowMultipleServAdhoc=eobj.SSGRPAllowMultipleServAdhoc
			s:eobj.SSGRPAllowOverBookRB="" eobj.SSGRPAllowOverBookRB="N"
			s obj.SSGRPAllowOverBookRB=eobj.SSGRPAllowOverBookRB
			s:eobj.SSGRPAllowOverBookOnSlotZero="" eobj.SSGRPAllowOverBookOnSlotZero="N"
			s obj.SSGRPAllowOverBookOnSlotZero=eobj.SSGRPAllowOverBookOnSlotZero
			s:eobj.SSGRPAllowUndoAppt="" eobj.SSGRPAllowUndoAppt="N"
			s obj.SSGRPAllowUndoAppt=eobj.SSGRPAllowUndoAppt
			s:eobj.SSGRPAllowOverPayorRestrict="" eobj.SSGRPAllowOverPayorRestrict="N"
			s obj.SSGRPAllowOverPayorRestrict=eobj.SSGRPAllowOverPayorRestrict
			s:eobj.SSGRPChkFutureAppts="" eobj.SSGRPChkFutureAppts="N"
			s obj.SSGRPChkFutureAppts=eobj.SSGRPChkFutureAppts
			s:eobj.SSGRPNotBookOutSess="" eobj.SSGRPNotBookOutSess="N"
			s obj.SSGRPNotBookOutSess=eobj.SSGRPNotBookOutSess
			s:eobj.SSGRPNotExcLoadLevelOverrides="" eobj.SSGRPNotExcLoadLevelOverrides="N"
			s obj.SSGRPNotExcLoadLevelOverrides=eobj.SSGRPNotExcLoadLevelOverrides
			s:eobj.SSGRPNAllAddPastAppt="" eobj.SSGRPNAllAddPastAppt="N"
			s obj.SSGRPNAllAddPastAppt=eobj.SSGRPNAllAddPastAppt
			d obj.SSGRPDFLocListDRSetObjectId(eobj.SSGRPDFLocListDR)
			


			///billing and cashiers
			s:eobj.SSGRPAllowDiscPaidOrder="" eobj.SSGRPAllowDiscPaidOrder="N"
			s obj.SSGRPAllowDiscPaidOrder=eobj.SSGRPAllowDiscPaidOrder
			s:eobj.SSGRPRoundingAutomatic="" eobj.SSGRPRoundingAutomatic="N"
			s obj.SSGRPRoundingAutomatic=eobj.SSGRPRoundingAutomatic
			s:eobj.SSGRPRoundingOnPayment="" eobj.SSGRPRoundingOnPayment="N"
			s obj.SSGRPRoundingOnPayment=eobj.SSGRPRoundingOnPayment

			//clinical and EMR
			s:eobj.SSGRPAllowOSFEdit24hrs="" eobj.SSGRPAllowOSFEdit24hrs="N"
			s obj.SSGRPAllowOSFEdit24hrs=eobj.SSGRPAllowOSFEdit24hrs
			s:eobj.SSGRPOrdersPrevEpisode="" eobj.SSGRPOrdersPrevEpisode="N"
			s obj.SSGRPOrdersPrevEpisode=eobj.SSGRPOrdersPrevEpisode
			//s eobj.SSGRPAllowToExecuteOrderOutsideShift=eobj.SSGRPAllowToExecuteOrderOutsideShift
			s:eobj.SSGRPShowAllPatientsInNWB="" eobj.SSGRPShowAllPatientsInNWB="N"
			s obj.SSGRPShowAllPatientsInNWB=eobj.SSGRPShowAllPatientsInNWB
			s:eobj.SSGRPDisplayDiagnProcDRG="" eobj.SSGRPDisplayDiagnProcDRG="N"
			s obj.SSGRPDisplayDiagnProcDRG=eobj.SSGRPDisplayDiagnProcDRG
			d obj.SSGRPClinicalLocListDrSetObjectId(eobj.SSGRPClinicalLocListDr)
			
			

			//Discharge
			s:eobj.SSGRPAutoMedDischarge="" eobj.SSGRPAutoMedDischarge="N"
			s obj.SSGRPAutoMedDischarge=eobj.SSGRPAutoMedDischarge
			d obj.SSGRPDischargeLocListSetObjectId(eobj.SSGRPDischargeLocList)
			

			//general system information
			s:eobj.SSGRPAllowSendMsgAll="" eobj.SSGRPAllowSendMsgAll="N"
			s obj.SSGRPAllowSendMsgAll=eobj.SSGRPAllowSendMsgAll
			s:eobj.SSGRPEnableSystemCT="" eobj.SSGRPEnableSystemCT="N"
			s obj.SSGRPEnableSystemCT=eobj.SSGRPEnableSystemCT
			s:eobj.SSGRPRestrictLocForGrHospitals="" eobj.SSGRPRestrictLocForGrHospitals="N"
			s obj.SSGRPRestrictLocForGrHospitals=eobj.SSGRPRestrictLocForGrHospitals
			s obj.SSGRPSecurityLevel=eobj.SSGRPSecurityLevel
			s obj.SSGRPInactivityTimeOut=eobj.SSGRPInactivityTimeOut
			s obj.SSGRPPasswordDaysToExpire=eobj.SSGRPPasswordDaysToExpire

			///operating theatre workbench
			s:eobj.SSGRPAllowChangeDepOT="" eobj.SSGRPAllowChangeDepOT="N"
			s obj.SSGRPAllowChangeDepOT=eobj.SSGRPAllowChangeDepOT
			s:eobj.SSGRPNAllORBookNA="" eobj.SSGRPNAllORBookNA="N"
			s obj.SSGRPNAllORBookNA=eobj.SSGRPNAllORBookNA
			s:eobj.SSGRPNAllORBookNoSess="" eobj.SSGRPNAllORBookNoSess="N"
			s obj.SSGRPNAllORBookNoSess=eobj.SSGRPNAllORBookNoSess
			s:eobj.SSGRPNAllORBookPast="" eobj.SSGRPNAllORBookPast="N"
			s obj.SSGRPNAllORBookPast=eobj.SSGRPNAllORBookPast
			s:eobj.SSGRPDontBookOutsideOTSchedule="" eobj.SSGRPDontBookOutsideOTSchedule="N"
			s obj.SSGRPDontBookOutsideOTSchedule=eobj.SSGRPDontBookOutsideOTSchedule
			s:eobj.SSGRPWarnORBookingMoveRes="" eobj.SSGRPWarnORBookingMoveRes="N"
			s obj.SSGRPWarnORBookingMoveRes=eobj.SSGRPWarnORBookingMoveRes

			///order and results
			s:eobj.SSGRPAllowToChangeOEStatus="" eobj.SSGRPAllowToChangeOEStatus="N"
			s obj.SSGRPAllowToChangeOEStatus=eobj.SSGRPAllowToChangeOEStatus
			s:eobj.SSGRPAllowToChangeOEStatus="" eobj.SSGRPAllowToChangeOEStatus="N"
			s obj.SSGRPAllowDiscOrdPackedPres=eobj.SSGRPAllowDiscOrdPackedPres
			s:eobj.SSGRPAllowedSeeSEnsitRes="" eobj.SSGRPAllowedSeeSEnsitRes="N"
			s obj.SSGRPAllowedSeeSEnsitRes=eobj.SSGRPAllowedSeeSEnsitRes
			s:eobj.SSGRPCheckApproved="" eobj.SSGRPCheckApproved="N"
			s obj.SSGRPCheckApproved=eobj.SSGRPCheckApproved
			s:eobj.SSGRPDefaultDoseEquiv="" eobj.SSGRPDefaultDoseEquiv="N"
			s obj.SSGRPDefaultDoseEquiv=eobj.SSGRPDefaultDoseEquiv
			s:eobj.SSGRPDisableAddAll="" eobj.SSGRPDisableAddAll="N"
			s obj.SSGRPDisableAddAll=eobj.SSGRPDisableAddAll
			s:eobj.SSGRPDiscontinueExecOrders="" eobj.SSGRPDiscontinueExecOrders="N"
			s obj.SSGRPDiscontinueExecOrders=eobj.SSGRPDiscontinueExecOrders
			s:eobj.SSGRPSuppressPin="" eobj.SSGRPSuppressPin="N"
			s obj.SSGRPSuppressPin=eobj.SSGRPSuppressPin
			s:eobj.SSGRPIgnoreOrderRestrictions="" eobj.SSGRPIgnoreOrderRestrictions="N"
			s obj.SSGRPIgnoreOrderRestrictions=eobj.SSGRPIgnoreOrderRestrictions
			s:eobj.SSGRPJobOE="" eobj.SSGRPJobOE="N"
			s obj.SSGRPJobOE= eobj.SSGRPJobOE
			s:eobj.SSGRPMinimizeOEUpdate="" eobj.SSGRPMinimizeOEUpdate="N"
			s obj.SSGRPMinimizeOEUpdate=eobj.SSGRPMinimizeOEUpdate
			s:eobj.SSGRPRetainOrderCategory="" eobj.SSGRPRetainOrderCategory="N"
			s obj.SSGRPRetainOrderCategory=eobj.SSGRPRetainOrderCategory
			s:eobj.SSGRPPrice="" eobj.SSGRPPrice="N"
			s obj.SSGRPPrice=eobj.SSGRPPrice

			///paper record traking
			s:eobj.SSGRPAllowIssueArchiveMR="" eobj.SSGRPAllowIssueArchiveMR="N"
			s obj.SSGRPAllowIssueArchiveMR=eobj.SSGRPAllowIssueArchiveMR
			s:eobj.SSGRPRestrictMRTypeCurrHosp="" eobj.SSGRPRestrictMRTypeCurrHosp="N"
			s obj.SSGRPRestrictMRTypeCurrHosp=eobj.SSGRPRestrictMRTypeCurrHosp
			s:eobj.SSGRPAllowActivateVolume="" eobj.SSGRPAllowActivateVolume="N"
			s obj.SSGRPAllowActivateVolume=eobj.SSGRPAllowActivateVolume
			s:eobj.SSGRPAllowNewMRTypesPat="" eobj.SSGRPAllowNewMRTypesPat="N"
			s obj.SSGRPAllowNewMRTypesPat=eobj.SSGRPAllowNewMRTypesPat

			///patient management
			d obj.SSGRPWaitListStatusDRSetObjectId(eobj.SSGRPWaitListStatusDR)
			d obj.SSGRPEmergencyLocListDRSetObjectId(eobj.SSGRPEmergencyLocListDR)
			d obj.SSGRPHealthPromLocListDRSetObjectId(eobj.SSGRPHealthPromLocListDR)
			d obj.SSGRPInPatLocListDRSetObjectId(eobj.SSGRPInPatLocListDR)
			s:eobj.SSGRPOnlyInpatUnitsForMyHospita="" eobj.SSGRPOnlyInpatUnitsForMyHospita="N"
			s obj.SSGRPOnlyInpatUnitsForMyHospita=eobj.SSGRPOnlyInpatUnitsForMyHospita
			d obj.SSGRPTempPatLocListSetObjectId(eobj.SSGRPTempPatLocList)
			d obj.SSGRPOutPatLocListDRSetObjectId(eobj.SSGRPOutPatLocListDR)
			s:eobj.SSGRPOnlyOutpatUnitsForMyHospit="" eobj.SSGRPOnlyOutpatUnitsForMyHospit="N"
			s obj.SSGRPOnlyOutpatUnitsForMyHospit=eobj.SSGRPOnlyOutpatUnitsForMyHospit
			d obj.SSGRPInPatTransferListDRSetObjectId(eobj.SSGRPInPatTransferListDR)
			d obj.SSGRPRadLocListSetObjectId(eobj.SSGRPRadLocList)
			d obj.SSGRPWaitListLocListDRSetObjectId(eobj.SSGRPWaitListLocListDR)
			d obj.SSGRPWLStatusListDRSetObjectId(eobj.SSGRPWLStatusListDR)
			d obj.SSGRPWardAttendLocListDRSetObjectId(eobj.SSGRPWardAttendLocListDR)


			//patient management2
			s:eobj.SSGRPAllowDeleteEpisode="" eobj.SSGRPAllowDeleteEpisode="N"
			s obj.SSGRPAllowDeleteEpisode=eobj.SSGRPAllowDeleteEpisode
			s:eobj.SSGRPAllowedAddOrdersReview="" eobj.SSGRPAllowedAddOrdersReview="N"
			s obj.SSGRPAllowedAddOrdersReview=eobj.SSGRPAllowedAddOrdersReview
			;;;暂时不加  s eobj.SSGRPAllowBookPastGuarDateWL=eobj.SSGRPAllowBookPastGuarDateWL
			s:eobj.SSGRPAllowToChangeFamilyDoctor="" eobj.SSGRPAllowToChangeFamilyDoctor="N"
			s obj.SSGRPAllowToChangeFamilyDoctor=eobj.SSGRPAllowToChangeFamilyDoctor
			s:eobj.SSGRPChangeDataAfterDischarge="" eobj.SSGRPChangeDataAfterDischarge="N"
			s obj.SSGRPChangeDataAfterDischarge=eobj.SSGRPChangeDataAfterDischarge
			s:eobj.SSGRPAllowDeleteDiagOtherUs="" eobj.SSGRPAllowDeleteDiagOtherUs="N"
			s obj.SSGRPAllowDeleteDiagOtherUs=eobj.SSGRPAllowDeleteDiagOtherUs
			s:eobj.SSGRPAllowEditEpLogLoc="" eobj.SSGRPAllowEditEpLogLoc="N"
			s obj.SSGRPAllowEditEpLogLoc=eobj.SSGRPAllowEditEpLogLoc
			s:eobj.SSGRPAllowEditWLStatusTreated="" eobj.SSGRPAllowEditWLStatusTreated="N"
			s obj.SSGRPAllowEditWLStatusTreated=eobj.SSGRPAllowEditWLStatusTreated
			s:eobj.SSGRPAllowViewVIPPatients="" eobj.SSGRPAllowViewVIPPatients="N"
			s obj.SSGRPAllowViewVIPPatients=eobj.SSGRPAllowViewVIPPatients
			s:eobj.SSGRPShowPatientSearch="" eobj.SSGRPShowPatientSearch="N"
			s obj.SSGRPShowPatientSearch=eobj.SSGRPShowPatientSearch
			s:eobj.SSGRPDisplayDiagnosis="" eobj.SSGRPDisplayDiagnosis="N"
			s obj.SSGRPDisplayDiagnosis=eobj.SSGRPDisplayDiagnosis
			s:eobj.SSGRPCheckOrdersCovered="" eobj.SSGRPCheckOrdersCovered="N"
			s obj.SSGRPCheckOrdersCovered=eobj.SSGRPCheckOrdersCovered
			s:eobj.SSGRPShowOnlyIPUnitsForWL="" eobj.SSGRPShowOnlyIPUnitsForWL="N"
			s obj.SSGRPShowOnlyIPUnitsForWL=eobj.SSGRPShowOnlyIPUnitsForWL
			s:eobj.SSGRPRestrictSearchEMR="" eobj.SSGRPRestrictSearchEMR="N"
			s obj.SSGRPRestrictSearchEMR=eobj.SSGRPRestrictSearchEMR
			s:eobj.SSGRPShowAllLocations="" eobj.SSGRPShowAllLocations="N"
			s obj.SSGRPShowAllLocations=eobj.SSGRPShowAllLocations
			s:eobj.SSGRPShowPreadmafterAppoint="" eobj.SSGRPShowPreadmafterAppoint="N"
			s obj.SSGRPShowPreadmafterAppoint=eobj.SSGRPShowPreadmafterAppoint
			s:eobj.SSGRPMoveToDefaultBed="" eobj.SSGRPMoveToDefaultBed="N"
			s obj.SSGRPMoveToDefaultBed=eobj.SSGRPMoveToDefaultBed
			s obj.SSGRPWLAuditLetterDays=eobj.SSGRPWLAuditLetterDays

			//stock
			s:eobj.SSGRPMoveToDefaultBed="" eobj.SSGRPMoveToDefaultBed="N"
			s obj.SSGRPAllowEditPriceGR=eobj.SSGRPAllowEditPriceGR
			s:eobj.SSGRPAllowToChangeAgrPrice="" eobj.SSGRPAllowToChangeAgrPrice="N"
			s obj.SSGRPAllowToChangeAgrPrice=eobj.SSGRPAllowToChangeAgrPrice
			//s eobj.SSGRPAllowToAddItemToVendPortfolio=eobj.SSGRPAllowToAddItemToVendPortfolio
			s:eobj.SSGRPAllowToChangeAgrPrice="" eobj.SSGRPAllowToChangeAgrPrice="N"
			s obj.SSGRPAllowAddStockItem=eobj.SSGRPAllowAddStockItem
			//s eobj.SSGRPAllowToAddItemToLocPortfolio=eobj.SSGRPAllowToAddItemToLocPortfolio
			s:eobj.SSGRPOnePOforEveryVendor="" eobj.SSGRPOnePOforEveryVendor="N"
			s obj.SSGRPOnePOforEveryVendor=eobj.SSGRPOnePOforEveryVendor
			s:eobj.SSGRPConsReasonMandatory="" eobj.SSGRPConsReasonMandatory="N"
			s obj.SSGRPConsReasonMandatory=eobj.SSGRPConsReasonMandatory
			s:eobj.SSGRPUserPOReferenceNotMandator="" eobj.SSGRPUserPOReferenceNotMandator="N"
			s obj.SSGRPUserPOReferenceNotMandator=eobj.SSGRPUserPOReferenceNotMandator
			d obj.SSGRPDefaultPOReferenceDRSetObjectId(eobj.SSGRPDefaultPOReferenceDR)
			s obj.SSGRPMaxPOAmount=eobj.SSGRPMaxPOAmount
			
			
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"
				
				if (eobj.SSGRPRowId="") 
				{
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_Group","User.SSGroup","安全组",id,eobj.SSGRPDesc,"A",eobj)
					if eobj.LinkHospId'=""
					{
						///2020-05-20添加时自动和医院关联
						s hospeobj=##class(web.Entity.CT.SSGroupHospitals).%New()
						s hospeobj.HOSPRowId=""
						s hospeobj.HOSPHospitalDR=eobj.LinkHospId
						s hospeobj.HOSPParRef=id
						D ##class(web.DHCBL.CT.SSGroupHospitals).SaveEntity(hospeobj)	
					}
				}
				else
				{
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_Group","User.SSGroup","安全组",id,eobj.SSGRPDesc,"U",eobj,bobj)
				}
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:陈莹
/// CreatDate:2013-8-21
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	//用户表SS_User.安全组主菜单设置表epr.GroupSettings中
	if ($d(^SSU("SSUSR",0,"Group",id))'=0)
	{
		s flag=1
		s myInfo=myInfo_"<用户>"
	}
	if ($d(^SSU("SSGRP",0,"GroupDr",id))'=0)
	{
		s flag=1
		s myInfo=myInfo_"<安全组>"
	}
	s RowId=0,flag=0
	for
	{
		s RowId=$o(^SSU("SSUSR",RowId)) q:(RowId="")||(flag=1)  d
		s SUB=0
		for
		{
			s SUB=$o(^SSU("SSUSR",RowId,"OTHLL",SUB)) q:(SUB="")||(flag=1)  d
			s GroupDR=$P($G(^SSU("SSUSR",RowId,"OTHLL",SUB)),"^",2)
			i (GroupDR=id)
			{
				s flag=1
			}
		}
	}
	if flag=1 s myInfo=myInfo_"<用户其他登录科室>"
	
	s RowId=0,flag=0
	for
	{
		s RowId=$o(^ooGroupSettingsD(RowId)) q:(RowId="")||(flag=1)  d
		s GroupDR=$LISTGET($g(^ooGroupSettingsD(RowId)),4)
		i (GroupDR=id)
		{
			s flag=1
		}
	}
	if flag=1 s myInfo=myInfo_"<安全组主菜单设置表>"
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator:陈莹
/// CreatDate:2013-05-06
/// Description：根据id删除 安全组
/// Table:User.SSGroup
/// Input:id
/// Return:成功返回true和info,失败返回false和info
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	
	s re=##class(web.DHCBL.CT.SSGroup).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){

		s pobj = ##class(User.SSGroup).%OpenId(id)
		s eobj = ##class(web.Entity.CT.SSGroup).%New()
		s eobj.SSGRPRowId = id
		s eobj.SSGRPDesc = pobj.SSGRPDesc
		s eobj.SSGRPCode = pobj.SSGRPCode    //安全组代码
		s eobj.SSGRPActiveFlag = pobj.SSGRPActiveFlag    //有效标志 
		if $IsObject(pobj.SSGRPGroupDr){
			s bobj.SSGRPGroupDr = pobj.SSGRPGroupDr.%Id()   // 上级安全组代码
		}
		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(User.SSGroup).%DeleteId(id)
		IF $$$ISOK(sc){ 
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_Group","User.SSGroup","安全组",id,eobj.SSGRPDesc,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组","web.DHCBL.CT.SSGroup","DeleteData",eobj)
	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	
	q result
}

/// 以下都为复制授权用到的类方法
/// Creator:陈莹
/// 编写日期:2013-7-18
/// Description:清除之前的权限，再赋予新值（安全组下,权限复制页面）
/// Table:User.SSGroup,User.SSGroupOrderCategory,User.SSGroupStockLocations
/// Input:SSGroupId1(要复制授权的安全组id),SSGroupId2(被复制授权的安全组id)
/// Return:error=1时说明权限赋值过程中出现错误,error=0 复制正常完成。
/// w ##class(web.DHCBL.CT.SSGroup).CopyEntity("26","29")
/// modified on 2013-7-21
ClassMethod CopyEntity(SSGroupId1, SSGroupId2) As %String
{
	s result ="",error=0
	   
	s SSORDChildsub1=0
	for
	{
		s SSORDChildsub1=$o(^SSU("SSGRP",SSGroupId1,"SSORD",SSORDChildsub1)) q:(SSORDChildsub1="")
		s SSORDRowId1=SSGroupId1_"||"_SSORDChildsub1
		s OldSSORDOrdSubCategory=$p($g(^SSU("SSGRP",SSGroupId1,"SSORD",SSORDChildsub1)),"^",5)
		i OldSSORDOrdSubCategory'=""
		{
			s ITMChildsub1=0
			for
			{
				s ITMChildsub1=$o(^SSU("SSGRP",SSGroupId1,"SSORD",SSORDChildsub1,"ITM",ITMChildsub1)) q:ITMChildsub1=""
				s ITMRowId1=SSGroupId1_"||"_SSORDChildsub1_"||"_ITMChildsub1
				s itmflag= ##class(web.DHCBL.CT.SSGroupOrderCategoryItems).DeleteData(ITMRowId1) //清空子类明细
				i itmflag["success:'false'"
				{
					s error=1
				}
			}
		}
		s ssordflag=##class(web.DHCBL.CT.SSGroupOrderCategory).DeleteData(SSORDRowId1)
		i ssordflag["success:'false'"
		{
			s error=1
		}
	}
	
	if (error=1)
	s STChildsub1=0
	for
	{
		s STChildsub1=$o(^SSU("SSGRP",SSGroupId1,"ST",STChildsub1)) q:STChildsub1=""
		s STRowId1=SSGroupId1_"||"_STChildsub1
		s stflag=##class(web.DHCBL.CT.SSGroupStockLocations).DeleteData(STRowId1) //清空库存授权
		i stflag["success:'false'"
		{
			s error=1
		}
	}
	//医院
	s HOSPChildsub1=0
	for
	{
		s HOSPChildsub1=$o(^SSU("SSGRP",SSGroupId1,"HOSP",HOSPChildsub1)) q:HOSPChildsub1=""
		s HOSPRowId1=SSGroupId1_"||"_HOSPChildsub1
		s hospflag=##class(web.DHCBL.CT.SSGroupHospitals).DeleteData(HOSPRowId1) //清空医院
		i hospflag["success:'false'"
		{
			s error=1
		}
	}
	//医嘱状态
	s OSTATChildsub1=0
	for
	{
		s OSTATChildsub1=$o(^SSU("SSGRP",SSGroupId1,"OSTAT",OSTATChildsub1)) q:OSTATChildsub1=""
		s OSTATRowId1=SSGroupId1_"||"_OSTATChildsub1
		s ostatflag=##class(web.DHCBL.CT.SSGroupOrderStatus).DeleteData(OSTATRowId1) //清空医嘱状态
		i ostatflag["success:'false'"
		{
			s error=1
		}
	}
	
	;k ^SSU("SSGRP",SSGroupId,"ST",0)
	;k ^SSU("SSGRP",SSGroupId,"SSORD",SSORDChildsub,"ITM",0) 
	;k ^SSU("SSGRP",SSGroupId,"SSORD",0)	
	
	s SSORDChildsub2=0
	for
	{
		s SSORDChildsub2=$o(^SSU("SSGRP",SSGroupId2,"SSORD",SSORDChildsub2)) q:SSORDChildsub2=""
		s ssordeobj = ##class(web.Entity.CT.SSGroupOrderCategory).%New()
		s ssordeobj.SSORDParRef=SSGroupId1
		s ssordeobj.SSORDOrdCatDR=$P($g(^SSU("SSGRP",SSGroupId2,"SSORD",SSORDChildsub2)),"^",1)
		s ssordeobj.SSORDOrdSubCategory=$P($g(^SSU("SSGRP",SSGroupId2,"SSORD",SSORDChildsub2)),"^",5)
		s ssordeobj.SSORDOrderOnDischarge=$P($g(^SSU("SSGRP",SSGroupId2,"SSORD",SSORDChildsub2)),"^",2)
		s ssordeobj.SSORDOrderInvisbleItem=$P($g(^SSU("SSGRP",SSGroupId2,"SSORD",SSORDChildsub2)),"^",3)
		s ssordeobj.SSORDOrderSets=$P($g(^SSU("SSGRP",SSGroupId2,"SSORD",SSORDChildsub2)),"^",4)
		s ssordeobj.SSORDRequireAuthorisation=$P($g(^SSU("SSGRP",SSGroupId2,"SSORD",SSORDChildsub2)),"^",7)
		s ssordeobj.SSORDOrderOnFinanceDisch=$P($g(^SSU("SSGRP",SSGroupId2,"SSORD",SSORDChildsub2)),"^",8)
		s ssordeobj.SSORDBookingOnly=$P($g(^SSU("SSGRP",SSGroupId2,"SSORD",SSORDChildsub2)),"^",9)
		s ord= ##class(web.DHCBL.CT.SSGroup).SaveSSORD(ssordeobj)  // 0^26||27
		s ordresult=$p(ord,"^",1)
		i ordresult=1  //医嘱授权保存失败
		{
			s error=1	
		}
		else
		{
			s NewSSORDRowId1=$p(ord,"^",2)
			if ssordeobj.SSORDOrdSubCategory'=""   //查询医嘱子类
			{
				s ITMChildsub2=0
				for
				{
					s ITMChildsub2=$o(^SSU("SSGRP",SSGroupId2,"SSORD",SSORDChildsub2,"ITM",ITMChildsub2)) q:ITMChildsub2=""
					s itmeobj = ##class(web.Entity.CT.SSGroupOrderCategoryItems).%New()
					s itmeobj.ITMParRef=NewSSORDRowId1
					s itmeobj.ITMARCIMDR=$P($g(^SSU("SSGRP",SSGroupId2,"SSORD",SSORDChildsub2,"ITM",ITMChildsub2)),"^",1)
					s itmeobj.ITMUnverifOrder=$P($g(^SSU("SSGRP",SSGroupId2,"SSORD",SSORDChildsub2,"ITM",ITMChildsub2)),"^",2)
					s itmeobj.ITMIncludeExclude=$P($g(^SSU("SSGRP",SSGroupId2,"SSORD",SSORDChildsub2,"ITM",ITMChildsub2)),"^",3)
					s itm= ##class(web.DHCBL.CT.SSGroup).SaveITM(itmeobj)  // result_"^"_26||27||1
					s itmresult=$p(itm,"^",1)
					i itmresult=1  //子类明细保存失败
					{
						s error=1
					}
				}
			}
		}
	}
		
	s STChildsub2=0
	for
	{
		s STChildsub2=$o(^SSU("SSGRP",SSGroupId2,"ST",STChildsub2)) q:STChildsub2=""
		s steobj = ##class(web.Entity.CT.SSGroupStockLocations).%New()
		s steobj.STParRef=SSGroupId1
		s steobj.STCTLOCDR=$p($g(^SSU("SSGRP",SSGroupId2,"ST",STChildsub2)),"^",1)
		s st= ##class(web.DHCBL.CT.SSGroup).SaveST(steobj)  // flag_"^"_id
		s stresult=$p(st,"^",1)
		i stresult=1
		{
			s error=1
		}
	}
	
	s HOSPChildsub2=0
	for
	{
		s HOSPChildsub2=$o(^SSU("SSGRP",SSGroupId2,"HOSP",HOSPChildsub2)) q:HOSPChildsub2=""
		s hospeobj = ##class(web.Entity.CT.SSGroupHospitals).%New()
		s hospeobj.HOSPParRef=SSGroupId1
		s hospeobj.HOSPHospitalDR=$p($g(^SSU("SSGRP",SSGroupId2,"HOSP",HOSPChildsub2)),"^",1)
		s hosp= ##class(web.DHCBL.CT.SSGroup).SaveHOSP(hospeobj)  // flag_"^"_id
		s hospresult=$p(hosp,"^",1)
		i hospresult=1
		{
			s error=1
		}
	}
	
	s OSTATChildsub2=0
	for
	{
		s OSTATChildsub2=$o(^SSU("SSGRP",SSGroupId2,"OSTAT",OSTATChildsub2)) q:OSTATChildsub2=""
		s ostateobj = ##class(web.Entity.CT.SSGroupOrderStatus).%New()
		s ostateobj.OSTATParRef=SSGroupId1
		s ostateobj.OSTATOrdStatDR=$P($g(^SSU("SSGRP",SSGroupId2,"OSTAT",OSTATChildsub2)),"^",1)
		s ostat= ##class(web.DHCBL.CT.SSGroup).SaveOSTAT(ostateobj)  // flag_"^"_id
		s ostatresult=$p(ostat,"^",1)
		i ostatresult=1
		{
			s error=1
		}
	}
	///复制菜单配置  2017-03-20
	//epr.GroupSetting表中MenuSecurity字段   
	s myeprrowid2=$o(^ooGroupSettingsI("GroupDRIndex",SSGroupId2,0))
	if (myeprrowid2'="")
	{
		s myeprrowid1=$o(^ooGroupSettingsI("GroupDRIndex",SSGroupId1,0))
		if (myeprrowid1'="")
		{
			s obj=##Class(epr.GroupSettings).%OpenId(+myeprrowid1,0)	
		}
		else
		{
			s obj=##Class(epr.GroupSettings).%New()
			d obj.GroupDRSetObjectId(SSGroupId1)
		}
		s obj.MenuSecurity= $lg($g(^ooGroupSettingsD(myeprrowid2)),24)   //菜单配置
		///2019-04-16 add
		d obj.MainMenuDRSetObjectId($lg($g(^ooGroupSettingsD(myeprrowid2)),14))  //头菜单
		d obj.SideMenuGroupDRSetObjectId($lg($g(^ooGroupSettingsD(myeprrowid2)),1))    //侧菜单组
		d obj.StartPageDRSetObjectId($lg($g(^ooGroupSettingsD(myeprrowid2)),16)) //开始工作流
		//2019-11-15add
		d obj.MainChartBookDRSetObjectId($lg($g(^ooGroupSettingsD(myeprrowid2)),46))    ///默认图表组  epr.ChartBook
		d obj.MainChartDRSetObjectId($lg($g(^ooGroupSettingsD(myeprrowid2)),13))   //默认图表  //epr.Chart
		d obj.PrevEpisChartDRSetObjectId($lg($g(^ooGroupSettingsD(myeprrowid2)),15))   //前一就诊的图表  //epr.Chart
		s obj.AppTimeout=$lg($g(^ooGroupSettingsD(myeprrowid2)),26) ///重新登录时间
		s obj.LockScrTimeOut=$lg($g(^ooGroupSettingsD(myeprrowid2)),115) // 锁屏时间设置，0表示永不锁屏
		set PropObj=##class(%Dictionary.PropertyDefinition).%OpenId("epr.GroupSettings||MutilTabMenu",0)
		i $IsObject(PropObj)
		{
			s obj.MutilTabMenu=$lg($g(^ooGroupSettingsD(myeprrowid2)),116) /// 是否能多页签打开菜单 2021-10-21
			s obj.ShowPanelMenu=$lg($g(^ooGroupSettingsD(myeprrowid2)),117) /// 是否以面板方式显示菜单
		}

		s sc=obj.%Save()
	 	if (sc'=1) s error=1
	 	s ssgrpobj2=##Class(User.SSGroup).%OpenId(SSGroupId2)	
	 	s ssgrpobj1=##Class(User.SSGroup).%OpenId(SSGroupId1)	
	 	s ssgrpobj1.SSGRPAllowWebColumnManager=ssgrpobj2.SSGRPAllowWebColumnManager  //允许使用列编辑器
	 	s ssgrpobj1.SSGRPAllowWebLayoutManager=ssgrpobj2.SSGRPAllowWebLayoutManager  //允许使用界面编辑器
		s sc=ssgrpobj1.%Save()
	 	if (sc'=1) s error=1
	}
		
	
	i (error=0) 
	{
		s result ="{success:'true'}"
	}
	else 
	{
		s result= "{success:'false',info:'有些授权未复制成功,请检查被复制的安全组数据是否正确！'}"
	}
	q result
}

ClassMethod SaveHOSP(eobj As web.Entity.CT.SSGroupHospitals) As %String
{
	s flag=0,id=""
	if $IsObject(eobj)
	{
	
		s obj = ##class(User.SSGroupHospitals).%New(eobj.HOSPParRef)
		s SSGRPRowId=0,flag1=0
		for
		{
			s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
			s HOSPChildsub=0
			for
			{
				s HOSPChildsub=$o(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)) q:HOSPChildsub=""
				s HOSPRowId=SSGRPRowId_"||"_HOSPChildsub
				s HOSPParRef=SSGRPRowId
				s HOSPHospitalDR=$p($g(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)),"^",1)
				i ((eobj.HOSPParRef=HOSPParRef)&(eobj.HOSPHospitalDR=HOSPHospitalDR)&(HOSPChildsub>0))
				{
					s flag1=1 //flag1=1 有重复
				}
			}
		}
		if (flag1'=1) {
 			d obj.HOSPParRefSetObjectId(eobj.HOSPParRef)
			d obj.HOSPHospitalDRSetObjectId(eobj.HOSPHospitalDR)
			s SSGRPDesc=$p($g(^SSU("SSGRP",eobj.HOSPParRef)),"^",1)
			s HOSPDesc=$p($g(^CT("HOSP",eobj.HOSPHospitalDR)),"^",2)
			
			Tstart
			s sc=obj.%Save()
			do obj.%Close()
			if $$$ISOK(sc){
				Tcommit
				s id = obj.%Id()
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupHospitals","User.SSGroupHospitals","安全组-医院",id,SSGRPDesc_"->"_HOSPDesc,"A",eobj)
			}else{
				Trollback
				s flag =1
			}
		}
		else{
			s flag =1
		}
		
	}
	else
	{
		s flag =1
	}	
	q flag_"^"_id
}

ClassMethod SaveOSTAT(eobj As web.Entity.CT.SSGroupOrderStatus) As %String
{
	s flag=0,id=""
	if $IsObject(eobj)
	{
	
		s obj = ##class(User.SSGroupOrderStatus).%New(eobj.OSTATParRef)
		s SSGRPRowId=0,flag1=0
		for
		{
			s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
			s OSTATChildsub=0
			for
			{
				s OSTATChildsub=$o(^SSU("SSGRP",SSGRPRowId,"OSTAT",OSTATChildsub)) q:OSTATChildsub=""
				s OSTATRowId=SSGRPRowId_"||"_OSTATChildsub
				s OSTATParRef=SSGRPRowId
				s OSTATOrdStatDR=$p($g(^SSU("SSGRP",SSGRPRowId,"OSTAT",OSTATChildsub)),"^",1)
				i ((eobj.OSTATParRef=OSTATParRef)&(eobj.OSTATOrdStatDR=OSTATOrdStatDR)&(OSTATChildsub>0))
				{
					s flag1=1 //flag1=1 有重复
				}
			}
		}
		if (flag1'=1) {
 			d obj.OSTATParRefSetObjectId(eobj.OSTATParRef)
			d obj.OSTATOrdStatDRSetObjectId(eobj.OSTATOrdStatDR)
			s SSGRPDesc=$p($g(^SSU("SSGRP",eobj.OSTATParRef)),"^",1)
			s OSTATDesc=$p($g(^OEC("OSTAT",eobj.OSTATOrdStatDR)),"^",2)
			
			Tstart
			s sc=obj.%Save()
			do obj.%Close()
			if $$$ISOK(sc){
				Tcommit
				s id = obj.%Id()
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupOrderStatus","User.SSGroupOrderStatus","安全组-医嘱状态",id,SSGRPDesc_"->"_OSTATDesc,"A",eobj)
			}else{
				Trollback
				s flag =1
			}
		}
		else{
			s flag =1
		}
		
	}
	else
	{
		s flag =1
	}	
	q flag_"^"_id
}

/// Creator:陈莹
/// CreatDate:2012-9-20
/// Description:增加/修改 库存授权
/// Table:User.SSGroupStockLocations
/// Input:web.Entity.CT.SSGroupStockLocations
/// Return:成功返回success:'true'和id;失败返回success:'false'和errorinfo
ClassMethod SaveST(eobj As web.Entity.CT.SSGroupStockLocations) As %String
{
	s flag=0,id=""
	if $IsObject(eobj)
	{
	
		s obj = ##class(User.SSGroupStockLocations).%New(eobj.STParRef)
		s SSGRPRowId=0,flag1=0
		for
		{
			s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
			s STChildsub=0
			for
			{
				s STChildsub=$o(^SSU("SSGRP",SSGRPRowId,"ST",STChildsub)) q:STChildsub=""
				s STRowId=SSGRPRowId_"||"_STChildsub
				s STParRef=SSGRPRowId
				s STCTLOCDR=$p($g(^SSU("SSGRP",SSGRPRowId,"ST",STChildsub)),"^",1)
				i ((eobj.STParRef=STParRef)&(eobj.STCTLOCDR=STCTLOCDR)&(STChildsub>0))
				{
					s flag1=1 //flag1=1 有重复
				}
			}
		}
		if (flag1'=1) {
 			d obj.STParRefSetObjectId(eobj.STParRef)
			d obj.STCTLOCDRSetObjectId(eobj.STCTLOCDR)
			s SSGRPDesc=$p($g(^SSU("SSGRP",eobj.STParRef)),"^",1)
			s CTLOCDesc=$p($g(^CTLOC(eobj.STCTLOCDR)),"^",2)
			
			Tstart
			s sc=obj.%Save()
			do obj.%Close()
			if $$$ISOK(sc){
				Tcommit
				s id = obj.%Id()
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupStockLocations","User.SSGroupStockLocations","安全组-库存授权",id,SSGRPDesc_"->"_CTLOCDesc,"A",eobj)
			}else{
				Trollback
				s flag =1
			}
		}
		else{
			s flag =1
		}
		
	}
	else
	{
		s flag =1
	}	
	q flag_"^"_id
}

/// Description:复制 医嘱子类明细授权
ClassMethod SaveITM(eobj As web.Entity.CT.SSGroupOrderCategoryItems) As %String
{
	s flag=0,id=""
	if $IsObject(eobj)
	{
		s obj = ##class(User.SSGroupOrderCategoryItems).%New(eobj.ITMParRef)
		s SSGRPRowId=$p(eobj.ITMParRef,"||",1)
		s SSORDChildsub=$p(eobj.ITMParRef,"||",2)
		s ITMARCIMDR=$d(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",0,"ARCIM",eobj.ITMARCIMDR))
		if (ITMARCIMDR=0) {
			s flag1=0
			s ITMChildsub=0,IncludeExclude="I"
			s ITMChildsub=$o(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",ITMChildsub))
			if (ITMChildsub'="")
			{
				s IncludeExclude=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",ITMChildsub)),"^",3)
				i eobj.ITMIncludeExclude'=IncludeExclude 
				{
					s flag1=1
				}
			}
			i (flag1=0)	
			{
 				d obj.ITMParRefSetObjectId(eobj.ITMParRef)
				d obj.ITMARCIMDRSetObjectId(eobj.ITMARCIMDR)
				s obj.ITMUnverifOrder=eobj.ITMUnverifOrder
				s obj.ITMIncludeExclude=eobj.ITMIncludeExclude
				s SSORDOrdSubCategory=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",5)
				s ARCICDesc=$p($g(^ARC("IC",SSORDOrdSubCategory)),"^",2)
				s ARCIMSubscript=$p(eobj.ITMARCIMDR,"||",1),ARCIMVersion=$p(eobj.ITMARCIMDR,"||",2)
				s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
				Tstart
				s sc=obj.%Save()
				do obj.%Close()
				if $$$ISOK(sc){
					Tcommit
					s id = obj.%Id()
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupOrderCategoryItems","User.SSGroupOrderCategoryItems","安全组-医嘱子类明细",id,ARCICDesc_"->"_ARCIMDesc,"A",eobj)
				}else{
					Trollback
					s flag =1
				}
			}
			else{
				s flag =1
			}	
		}
		else{
			s flag = 1
		}
	}
	else
	{
		s flag =1
	}	
	q flag_"^"_id
}

/// Description:复制医嘱授权
ClassMethod SaveSSORD(eobj As web.Entity.CT.SSGroupOrderCategory) As %String
{
	s flag=0,id=""
	if $IsObject(eobj)
	{
		s:eobj.SSORDOrderOnDischarge="" eobj.SSORDOrderOnDischarge="N"  //checkbox  radio没有
		s:eobj.SSORDOrderInvisbleItem="" eobj.SSORDOrderInvisbleItem="N"
		s:eobj.SSORDOrderSets="" eobj.SSORDOrderSets="N"
		s:eobj.SSORDRequireAuthorisation="" eobj.SSORDRequireAuthorisation="N"
		s:eobj.SSORDOrderOnFinanceDisch="" eobj.SSORDOrderOnFinanceDisch="N"
		s:eobj.SSORDBookingOnly="" eobj.SSORDBookingOnly="N"

		s obj = ##class(User.SSGroupOrderCategory).%New(eobj.SSORDParRef)
		s SSGRPRowId=0,flag1=0
		for
		{
			s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
			s SSORDChildsub=0
			for
			{
				s SSORDChildsub=$o(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)) q:SSORDChildsub=""
				s SSORDRowId=SSGRPRowId_"||"_SSORDChildsub
				s SSORDParRef=SSGRPRowId
				s SSORDOrdCatDR=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",1)
				s SSORDOrdSubCategory=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",5)
				i ((eobj.SSORDParRef=SSORDParRef)&(eobj.SSORDOrdCatDR=SSORDOrdCatDR)&(eobj.SSORDOrdSubCategory=SSORDOrdSubCategory)&(SSORDChildsub>0))
				{
					s flag1=1 //flag1=1 有重复
				}
			}
		}
		if (flag1'=1) {
 			d obj.SSORDParRefSetObjectId(eobj.SSORDParRef)
			d obj.SSORDOrdCatDRSetObjectId(eobj.SSORDOrdCatDR)
			
			d obj.SSORDOrdSubCategorySetObjectId(eobj.SSORDOrdSubCategory)
			s obj.SSORDOrderOnDischarge=eobj.SSORDOrderOnDischarge
			s obj.SSORDOrderInvisbleItem=eobj.SSORDOrderInvisbleItem
			s obj.SSORDOrderSets=eobj.SSORDOrderSets
			s obj.SSORDRequireAuthorisation=eobj.SSORDRequireAuthorisation
			s obj.SSORDOrderOnFinanceDisch=eobj.SSORDOrderOnFinanceDisch
			s obj.SSORDBookingOnly=eobj.SSORDBookingOnly
			s SSGRPDesc=$p($g(^SSU("SSGRP",eobj.SSORDParRef)),"^",1)
			s ORCATDesc=$p($g(^OEC("ORCAT",eobj.SSORDOrdCatDR)),"^",2)
			
			Tstart
			s sc=obj.%Save()
			do obj.%Close()
			if $$$ISOK(sc){
				Tcommit
				s id = obj.%Id()
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupOrderCategory","User.SSGroupOrderCategory","安全组-医嘱授权",id,SSGRPDesc_"->"_ORCATDesc,"A",eobj)
			}else{
				Trollback
				s flag =1
			}
		}
		else{
			s flag =1
		}
	}
	else
	{
		s flag = 1
	}	
	q flag_"^"_id
}

/// Creator:陈莹
/// CreatDate:2014-03-30
/// Description:查询 User.PACWaitingListStatus
/// Table:User.PACWaitingListStatus
/// Input:desc
/// Return:WLSRowId,WLSDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSGroup","GetDataForWLS","")
Query GetDataForWLS(rowid As %String, desc As %String) As %Query(ROWSPEC = "WLSRowId:%String,WLSDesc:%String")
{
}

ClassMethod GetDataForWLSExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s WLSRowId=rowid
		s WLSDesc=$p($g(^PAC("WLS",WLSRowId)),"^",2)
		d OutputRowWLS
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U")

		s WLSRowId=0
		for
		{
			s WLSRowId=$o(^PAC("WLS",WLSRowId)) q:WLSRowId=""
			s WLSDesc=$p($g(^PAC("WLS",WLSRowId)),"^",2)
			i ($ZCONVERT(WLSDesc,"U")[desc)
			{
				d OutputRowWLS
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowWLS
    set Data=$lb(WLSRowId,WLSDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForWLSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForWLSExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDataForWLSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForWLSExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2014-03-30
/// Description:查询 PACWLStatusList
/// Table:User.PACWLStatusList
/// Input:desc
/// Return:WLSLRowId,WLSLDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSGroup","GetDataForWLSL","")
Query GetDataForWLSL(rowid As %String, desc As %String) As %Query(ROWSPEC = "WLSLRowId:%String,WLSLDesc:%String")
{
}

ClassMethod GetDataForWLSLExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s WLSLRowId=rowid
		s WLSLDesc=$p($g(^PAC("WLSL",WLSLRowId)),"^",2)
		d OutputRowWLSL
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s WLSLRowId=0
		for
		{
			s WLSLRowId=$o(^PAC("WLSL",WLSLRowId)) q:WLSLRowId=""
			s WLSLDesc=$p($g(^PAC("WLSL",WLSLRowId)),"^",2)
			i ($ZCONVERT(WLSLDesc,"U")[desc)
			{
				d OutputRowWLSL
			}
		}		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowWLSL
    set Data=$lb(WLSLRowId,WLSLDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForWLSLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForWLSLExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDataForWLSLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForWLSLExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2014-03-30
/// Description:查询 User.INCPOReference
/// Table:User.INCPOReference
/// Input:desc
/// Return:POREFRowId,POREFDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSGroup","GetDataForPOREF","")
Query GetDataForPOREF(rowid As %String, desc As %String) As %Query(ROWSPEC = "POREFRowId:%String,POREFDesc:%String")
{
}

ClassMethod GetDataForPOREFExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s POREFRowId=rowid
		s POREFDesc=$p($g(^INC("POREF",POREFRowId)),"^",2)
		d OutputRowPOREF
	}
	else
	{

		s:desc'="" desc=$ZCONVERT(desc,"U")
		s POREFRowId=0
		for
		{
			s POREFRowId=$o(^INC("POREF",POREFRowId)) q:POREFRowId=""
			s POREFDesc=$p($g(^INC("POREF",POREFRowId)),"^",2)
			i ($ZCONVERT(POREFDesc,"U")[desc)
			{
				d OutputRowPOREF
			}
		}	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowPOREF
    set Data=$lb(POREFRowId,POREFDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForPOREFFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForPOREFExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDataForPOREFClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForPOREFExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 参数配置获取左边的树
/// [{"id":"6","text":"码表日志维护","iconCls":"","myhref":"dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/Aut/BDPSystem/BDP_DataChangeLog","leaf":true},{"id":"127","text":"Ext功能大表维护","iconCls":"","myhref":"dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/Aut/BDPSystem/BDPExecutables","leaf":true},{"id":"8","text":"菜单维护","iconCls":"","myhref":"dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/Aut/BDPSystem/BDP_Menu","leaf":true},{"id":"139","text":"菜单授权","iconCls":"","myhref":"dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/Aut/BDPSystem/BDPAuthorize_Menu","leaf":true},{"id":"140","text":"功能元素授权","iconCls":"","myhref":"dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/Aut/BDPSystem/BDPAuthorize_Item","leaf":true},{"id":"141","text":"基础数据授权","iconCls":"","myhref":"dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/Aut/BDPSystem/BDPAuthorize_BaseData","leaf":true},{"id":"294","text":"医院级授权","iconCls":"","myhref":"dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/Aut/BDPSystem/DataAutHospPre","leaf":true},{"id":"278","text":"授权浏览","iconCls":"","myhref":"dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/Aut/BDPSystem/BDPPreferences","leaf":true}]
/// w ##class(web.DHCBL.CT.SSGroup).GetTreeJson("","","")
ClassMethod GetTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String) As %String
{
	if (ParentID="menuTreeRoot") s ParentID=-100000000000000
	//输出菜单JSON串
	s myJsonStr=""
	
	//1
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"1"_""",""text"":"""_"床位管理"_""","
	s myUrl1="dhc.bdp.ext.default.csp?extfilename=App/System/SSGroup/bed"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl1_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	
	//2
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"2"_""",""text"":"""_"计费和出纳"_""","
	s myUrl2="dhc.bdp.ext.default.csp?extfilename=App/System/SSGroup/billing"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl2_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//3
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"3"_""",""text"":"""_"预约"_""","
	s myUrl3="dhc.bdp.ext.default.csp?extfilename=App/System/SSGroup/booking"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl3_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//4
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"4"_""",""text"":"""_"临床和电子病历"_""","
	s myUrl4="dhc.bdp.ext.default.csp?extfilename=App/System/SSGroup/clinical"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl4_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//5
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"5"_""",""text"":"""_"卸货"_""","
	s myUrl5="dhc.bdp.ext.default.csp?extfilename=App/System/SSGroup/discharge"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl5_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//6
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"6"_""",""text"":"""_"一般系统信息"_""","
	s myUrl6="dhc.bdp.ext.default.csp?extfilename=App/System/SSGroup/general"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl6_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//7
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"7"_""",""text"":"""_"手术室工作站"_""","
	s myUrl7="dhc.bdp.ext.default.csp?extfilename=App/System/SSGroup/operating"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl7_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//8
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"8"_""",""text"":"""_"医嘱与结果"_""","
	s myUrl8="dhc.bdp.ext.default.csp?extfilename=App/System/SSGroup/orders"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl8_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//9
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"9"_""",""text"":"""_"纸质记录追踪"_""","
	s myUrl9="dhc.bdp.ext.default.csp?extfilename=App/System/SSGroup/paper"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl9_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//10
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"10"_""",""text"":"""_"病人管理"_""","
	s myUrl10="dhc.bdp.ext.default.csp?extfilename=App/System/SSGroup/patient"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl10_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//11
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"11"_""",""text"":"""_"病人管理2"_""","
	s myUrl11="dhc.bdp.ext.default.csp?extfilename=App/System/SSGroup/patient2"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl11_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//12
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"12"_""",""text"":"""_"库存"_""","
	s myUrl12="dhc.bdp.ext.default.csp?extfilename=App/System/SSGroup/stock"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl12_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// Creator:陈莹
/// CreatDate:2013-05-06
/// Description:返回安全组设置csp 
/// Input:安全组rowid
/// Return:安全组设置csp 路径
ClassMethod GetHtmlS1(GroupRowId As %String) As %String
{
	s HtmlS1="websys.default.csp?WEBSYS.TCOMPONENT=epr.GroupSettings.Edit&GroupID=''&ID=''"
	IF (GroupRowId)
	{
		s ID=$o(^ooGroupSettingsI("GroupDRIndex",GroupRowId,0))
		s HtmlS1="websys.default.csp?WEBSYS.TCOMPONENT=epr.GroupSettings.Edit&GroupID="_GroupRowId_"&ID="_ID
		//s HtmlS1="websys.default.csp?WEBSYS.TCOMPONENT=epr.GroupSettings.Edit&GroupID="_GroupRowId_"&ID="_##Class(epr.GroupSettings).GetIdFromGroupId(GroupRowId)
	
	}
	q HtmlS1
}

/// Creator:陈莹
/// CreatDate:2013-05-06  2018-11-22 修改
/// Description:返回安全组菜单配置csp路径 
/// Input:安全组rowid
/// Return:安全组菜单配置路径
/// Other:w ##class(web.DHCBL.CT.SSGroup).GetHtmlM1("1")
ClassMethod GetHtmlM1(GroupRowId As %String) As %String
{
	/*s HtmlM1="epr.groupsettings.editmenusecurity.csp?GroupDR=''&ID=''&SSGRPDesc=''"
	IF (GroupRowId)
	{
		s ID=$o(^ooGroupSettingsI("GroupDRIndex",GroupRowId,0))
		s HtmlM1="epr.groupsettings.editmenusecurity.csp?GroupDR="_GroupRowId_"&ID="_ID_"&SSGRPDesc="_$p($g(^SSU("SSGRP",GroupRowId)),"^",1)
		//s HtmlM1="epr.groupsettings.editmenusecurity.csp?GroupDR="_GroupRowId_"&ID="_##Class(epr.GroupSettings).GetIdFromGroupId(GroupRowId)_"&SSGRPDesc="_$p($g(^SSU("SSGRP",GroupRowId)),"^",1)
	}*/
	s HtmlM1="websys.menu.security.csp?GroupDR="_GroupRowId
	q HtmlM1
}

/// 安全组其他配置-获取左边的树
ClassMethod GetOtherSetTreeJson(ParentID, GroupRowId As %String) As %String
{
	
	if (ParentID="setmenuTreeRoot") s ParentID=-100000000000000
	s myJsonStr=""
	IF (GroupRowId)
	{
		s GroupDesc=""
		s GroupDesc=$p($g(^SSU("SSGRP",GroupRowId)),"^",1)
		//输出菜单JSON串
	
	
		/*s myJsonStr1="[{"_"""id"":"""_""_"2"_""",""text"":"""_"诊室设置"_""","
		s myUrl11="websys.default.csp?WEBSYS.TCOMPONENT=DHCSSGroup.RegRoom&GroupRowId="_GroupRowId
		s myJsonStr1=myJsonStr1_"""myhref"":"""_""_myUrl11_""","_"""leaf"":true"_"}"
		
		s myJsonStr1=myJsonStr1_",{"_"""id"":"""_""_"3"_""",""text"":"""_"科室医生设置"_""","
		s myUrl12="websys.default.csp?WEBSYS.TCOMPONENT=DHCSSGroup.Resource&GroupRowId="_GroupRowId
		s myJsonStr1=myJsonStr1_"""myhref"":"""_""_myUrl12_""","_"""leaf"":true"_"}"	
	
		s myJsonStr1=myJsonStr1_",{"_"""id"":"""_""_"4"_""",""text"":"""_"医嘱录入设置"_""","
		s myUrl13="websys.default.csp?WEBSYS.TCOMPONENT=DHCSSGroup.DocEntry&GroupRowId="_GroupRowId
		s myJsonStr1=myJsonStr1_"""myhref"":"""_""_myUrl13_""","_"""leaf"":true"_"}"
	
		s myJsonStr1=myJsonStr1_",{"_"""id"":"""_""_"13"_""",""text"":"""_"门诊医生站跳转页面设置"_""","
		//websys.default.csp   DHCSSGroup.OutDocEntry   "&GroupRowId="_rs.GetData(1)
		s myUrl14="websys.default.csp?WEBSYS.TCOMPONENT=DHCSSGroup.OutDocEntry&GroupRowId="_GroupRowId
		s myJsonStr1=myJsonStr1_"""myhref"":"""_""_myUrl14_""","_"""leaf"":true"_"}"
		
		s myJsonStr1=myJsonStr1_"]"
		//1
		s myJsonStr=myJsonStr_"{"
		s myJsonStr=myJsonStr_"""id"":"""_""_"1"_""",""text"":"""_"医生站-安全组功能授权"_""","
		s myUrl1=""
		s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl1_""","
		s myJsonStr=myJsonStr_"""leaf"":false,"_"""expanded"":true"_","
		s myJsonStr=myJsonStr_"""children"":"_myJsonStr1
		s myJsonStr=myJsonStr_"},"		
		*/
	
	
		//2
		s myJsonStr=myJsonStr_"{"_"""id"":"""_""_"5"_""",""text"":"""_"护理组-护士执行安全组"_""","
		s myUrl21="websys.default.csp?WEBSYS.TCOMPONENT=DHCNurAccessDetail&ssgrp="_GroupRowId
		s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl21_""","_"""leaf"":true"_"}"
	
		//3-1待定
		s myJsonStr3="[{"_"""id"":"""_""_"7"_""",""text"":"""_"访问代码表"_""","
		//s myUrl31="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCGroupCTableList&RowID="_GroupRowId_"&Group="_GroupDesc  //原来的
		s myUrl31="dhceq.plat.cgrouptable.csp?id="_GroupRowId  //hisui版 20190918
		s myJsonStr3=myJsonStr3_"""myhref"":"""_""_myUrl31_""","_"""leaf"":true"_"}"
	
		//3-2待定
		s myJsonStr3=myJsonStr3_",{"_"""id"":"""_""_"8"_""",""text"":"""_"访问类组"_""","
		//s myUrl32="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCGroupEquipTypeList&RowID="_GroupRowId_"&Group="_GroupDesc  //原来的
		s myUrl32="dhceq.plat.cgroupequiptype.csp?id="_GroupRowId  //hisui版 20190918
		s myJsonStr3=myJsonStr3_"""myhref"":"""_""_myUrl32_""","_"""leaf"":true"_"}]"
	
		//3
		s myJsonStr=myJsonStr_",{"
		s myJsonStr=myJsonStr_"""id"":"""_""_"6"_""",""text"":"""_"设备管理组-安全组访问设备代码"_""","
		s myUrl6=""
		s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl6_""","_"""leaf"":false,"_"""expanded"":true"_","
		s myJsonStr=myJsonStr_"""children"":"_myJsonStr3
		s myJsonStr=myJsonStr_"}"	
	
		//4-1
		s myJsonStr4="[{"_"""id"":"""_""_"10"_""",""text"":"""_"安全组与押金类型配置"_""","
		;s myUrl10="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFSSGrpDepTypeSet"_
		s myUrl41="dhc.bdp.ext.default.csp?extfilename=App/System/SSGroup/UDHCJFSSGrpDepTypeSet&gid="_GroupRowId
		s myJsonStr4=myJsonStr4_"""myhref"":"""_""_myUrl41_""","_"""leaf"":true"_"}"
		//4-2
		s myJsonStr4=myJsonStr4_",{"_"""id"":"""_""_"11"_""",""text"":"""_"门诊收费安全组配置"_""","
		s myUrl42="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPGCF.GroupSet&GPRowID="_GroupRowId
		s myJsonStr4=myJsonStr4_"""myhref"":"""_""_myUrl42_""","_"""leaf"":true"_"}"	
		//4-3
		s myJsonStr4=myJsonStr4_",{"_"""id"":"""_""_"12"_""",""text"":"""_"安全组与病人类型配置"_""","
		;s myUrl12="websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBillPatTypeSet"
		s myUrl43="dhc.bdp.ext.default.csp?extfilename=App/System/SSGroup/DHCIPBillPatTypeSet&gid="_GroupRowId
		s myJsonStr4=myJsonStr4_"""myhref"":"""_""_myUrl43_""","_"""leaf"":true"_"}]"
	
	
		//4
		s myJsonStr=myJsonStr_",{"
		s myJsonStr=myJsonStr_"""id"":"""_""_"9"_""",""text"":"""_"计费组-新计费代码"_""","
		s myUrl9=""
		s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl9_""","
		s myJsonStr=myJsonStr_"""leaf"":false,"_"""expanded"":true"_","
		s myJsonStr=myJsonStr_"""children"":"_myJsonStr4
		s myJsonStr=myJsonStr_"}"	
		/*
		//6-1
		s myJsonStr6="[{"_"""id"":"""_""_"15"_""",""text"":"""_"安全组设置"_""","
		s myUrl15="websys.default.csp?WEBSYS.TCOMPONENT=epr.GroupSettings.Edit&GroupID="_GroupRowId_"&ID="_##Class(epr.GroupSettings).GetIdFromGroupId(GroupRowId)
		s myJsonStr6=myJsonStr6_"""myhref"":"""_""_myUrl15_""","_"""leaf"":true"_"}"
		//6-2
		s myJsonStr6=myJsonStr6_",{"_"""id"":"""_""_"16"_""",""text"":"""_"菜单授权"_""","
		s myUrl16="epr.groupsettings.editmenusecurity.csp?GroupDR="_GroupRowId_"&ID="_##Class(epr.GroupSettings).GetIdFromGroupId(GroupRowId)_"&SSGRPDesc="_GroupDesc
		s myJsonStr6=myJsonStr6_"""myhref"":"""_""_myUrl16_""","_"""leaf"":true"_"}"	
		//6-3
		s myJsonStr6=myJsonStr6_",{"_"""id"":"""_""_"17"_""",""text"":"""_"菜单Map"_""","
		s myUrl17="websys.menumap.csp?GroupID="_GroupRowId
		s myJsonStr6=myJsonStr6_"""myhref"":"""_""_myUrl17_""","_"""leaf"":true"_"}]"

		//6
		s myJsonStr=myJsonStr_",{"
		s myJsonStr=myJsonStr_"""id"":"""_""_"14"_""",""text"":"""_"系统配置-菜单Map"_""","
		s myUrl14=""
		s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl14_""","
		s myJsonStr=myJsonStr_"""leaf"":false,"_"""expanded"":true"_","
		s myJsonStr=myJsonStr_"""children"":"_myJsonStr6
		s myJsonStr=myJsonStr_"}"
		*/
		//5
		s myJsonStr=myJsonStr_",{"_"""id"":"""_""_"14"_""",""text"":"""_"系统配置-菜单Map"_""","
		s myUrl51="websys.menumap.csp?GroupID="_GroupRowId
		s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl51_""","_"""leaf"":true"_"}"
		
	
		s myJsonStr="["_myJsonStr_"]"
	}
	q myJsonStr
}

/// Creator: chenying
/// Date:2018-11-12
/// 获取 安全组 Tree类型的json串
/// 供平台配置-开启安全组数据查询权限 调用
/// Input:FilterCK:全部 "" /已选checked/未选unchecked
/// w ##class(web.DHCBL.CT.SSGroup).GetGroupTreeJson("checked","")
ClassMethod GetGroupTreeJson(FilterCK As %String, desc As %String) As %String
{
	s myJsonStr=""	
	s AuStr=##class(web.DHCBL.Authorize.SSGroup).DHCGetDataByDefaultSession()
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	s configValue=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPQUERYAUTGROUPDATA")
	s myRowId=0
	for 
	{
		s myRowId=$o(^SSU("SSGRP",myRowId)) q:(myRowId="")
		//筛选授权后的数据
		s strRowId="{ID:"_myRowId_"}"
		if (AuStr[strRowId)||(AuFlag=1) {
			
			if (configValue[("&"_myRowId_"&"))||(myRowId=1)
			{
				s CheckedFlag=1
			}
			else
			{
				s CheckedFlag=0
			}
			if (FilterCK="checked") 
			{
				if ('CheckedFlag)
				{
					continue
				}
			}
			elseif (FilterCK="unchecked") 
			{
				if (CheckedFlag) {
					continue
				}
			}
			s myObj=##Class(User.SSGroup).%OpenId(myRowId)
			if $IsObject(myObj) {
				s myDesc = myObj.SSGRPDesc //安全组名称
				s myCode = myObj.SSGRPCode //安全组代码
				s SSGRPActiveFlag =$p($g(^SSU("SSGRP",myRowId)),"^",151)
				continue:(SSGRPActiveFlag="N")
				continue:(myDesc["停用")
				s myDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(myDesc)
				continue:$zcvt(myDesc,"U")'[$zcvt(desc,"U")
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_myRowId_""",""text"":"""_myDesc_""",""code"":"""_myCode_""","
				if (CheckedFlag) s myJsonStr=myJsonStr_"""checked"":true,"	
				else  s myJsonStr=myJsonStr_"""checked"":false,"
				s myJsonStr=myJsonStr_"""leaf"":true"
				s myJsonStr=myJsonStr_"}"
				d myObj.%Close()
			}
		}
	}

	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// Creator:陈莹
/// CreatDate:2018-12-26
/// Description：安全组医嘱授权0节点缺少计数。
/// Table:User.SSGroup
/// D ##class(web.DHCBL.CT.SSGroup).RepairData(0)
/// D ##class(web.DHCBL.CT.SSGroup).RepairData(1)
ClassMethod RepairData(flag) As %String
{
	k ^tmpcy
	s SSGRPRowId=0
	for
	{
		s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
		if ($o(^SSU("SSGRP",SSGRPRowId,"SSORD",""),-1)'="")&&($o(^SSU("SSGRP",SSGRPRowId,"SSORD",""),-1)'=0)
		{
			if ($D(^SSU("SSGRP",SSGRPRowId,"SSORD",0))=0)||($g(^SSU("SSGRP",SSGRPRowId,"SSORD",0))<$o(^SSU("SSGRP",SSGRPRowId,"SSORD",""),-1))
			{
				if (flag=0) s ^tmpcy("error","SSORD",SSGRPRowId)=$g(^SSU("SSGRP",SSGRPRowId,"SSORD",0))
				if (flag=1) s ^SSU("SSGRP",SSGRPRowId,"SSORD",0)=$o(^SSU("SSGRP",SSGRPRowId,"SSORD",""),-1)	
			}
		}
		if ($o(^SSU("SSGRP",SSGRPRowId,"ST",""),-1)'="")&&($o(^SSU("SSGRP",SSGRPRowId,"ST",""),-1)'=0)
		{
			if ($D(^SSU("SSGRP",SSGRPRowId,"ST",0))=0)||($g(^SSU("SSGRP",SSGRPRowId,"ST",0))<$o(^SSU("SSGRP",SSGRPRowId,"ST",""),-1))
			{
				if (flag=0) s ^tmpcy("error","ST",SSGRPRowId)=$g(^SSU("SSGRP",SSGRPRowId,"ST",0))
				if (flag=1) s ^SSU("SSGRP",SSGRPRowId,"ST",0)=$o(^SSU("SSGRP",SSGRPRowId,"ST",""),-1)	
			}
		}
	}
	
	zw ^tmpcy
}

/// Creator:陈莹
/// CreatDate:2021-08-26
/// Description：批量处理安全组有效标志
/// Table:User.SSGroup
/// D ##class(web.DHCBL.CT.SSGroup).UpdateActiveFlag()
ClassMethod UpdateActiveFlag() As %String
{
	s SSGRPRowId=0
	for
	{
		s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
		s SSGRPDesc=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",1)
		s obj=##class(User.SSGroup).%OpenId(SSGRPRowId)
		if (SSGRPDesc["停用")
		{
			s obj.SSGRPActiveFlag = "N"    //有效标志		
		}
		else
		{
			s obj.SSGRPActiveFlag = "Y"    //有效标志		
		}
		s sc=obj.%Save()
		d obj.%Close()
	}
	//重新生成索引 Desc
	d ##class(User.SSGroup).%BuildIndices()
	q ""
}

/// w ##Class(web.DHCBL.CT.SSGroup).GetSSGroup()
ClassMethod GetSSGroup()
{
	set pStream=##class(%Stream.GlobalCharacter).%New()
	d pStream.Write("{""code"":""200"",""data"":[")
	s total=0
	s SSGRPRowId=0
	for
	{
		s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
		s SSGRPDesc=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",1)
		continue:(SSGRPDesc["停用")
		s SSGRPActiveFlag =$p($g(^SSU("SSGRP",myRowId)),"^",151)
		continue:(SSGRPActiveFlag="N")
		s SSGRPCode=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",152)
		s:SSGRPCode="" SSGRPCode=SSGRPDesc
		s total=total+1
		if total>1 d pStream.Write(",")
		d pStream.Write("{""roleId"":"""_SSGRPRowId_""",""desc"":"""_SSGRPDesc_""",""code"":"""_SSGRPCode_"""}")
	}
	d pStream.Write("],""total"":"_total_",""errMSG"":""""}")
	q pStream.Read()
	q $$Global2Json(.pStream)
Global2Json(pStream)
	d pStream.Rewind()
	While('pStream.AtEnd){
		W pStream.Read()
	}
	Quit ""
}

/// Function:   修改安全组，将描述同步到代码
/// Creator:    chenying
/// CreateDate: 2022-10-17
/// TableName:  SS_Group
/// Debug:      w ##class(web.DHCBL.CT.SSGroup).UpdateGroupCode()
ClassMethod UpdateGroupCode()
{
	s SSGRPRowId=0
	for
	{
		s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
		s SSGRPDesc=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",1)
		s obj=##class(User.SSGroup).%OpenId(SSGRPRowId)
		s obj.SSGRPCode ="G"_##class(web.DHCBL.BDP.FunLib).AddZEROToStr(SSGRPRowId,4)
		s obj.SSGRPStartDate=65379
		if obj.SSGRPActiveFlag="N"
		{
			s obj.SSGRPEndDate=65380
		}
		s sc=obj.%Save()
		d obj.%Close()
	}
	q ""
}

}
