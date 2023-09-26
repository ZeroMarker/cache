Class DHCHAI.IR.HandHyDataSyn Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenrui
/// CreatDate：   2020-07-27
/// Description:  根据日期同步手卫生请领单数据
/// Input：       aDateTo：结束日期
/// 			  aDateFrom : 开始日期
/// 			  aHospCode：医院代码
/// Return：      处理的条数
/// w ##class(DHCHAI.IR.HandHyDataSyn).SyncHandByDate("HAND01",65591,65591)
ClassMethod SyncHandByDate(aSCode As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	
	set xCode=""
	For {
		Set xCode = $o(^DHCHAI.BT.SystemMapI("IdxofCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.BT.SystemMapI("IdxofCode",xCode,xID))
			Quit:xID=""
			Set objSystemMap = ##class(DHCHAI.BT.SystemMap).GetObjById(xID)
			Continue:'$isobject(objSystemMap)
			Set Code = objSystemMap.BTCode
		}
		quit:Code'="HAND01"
	}
	
	New (aSCode,aDateFrom,aDateTo)
	Set return="",Count=0
	Quit:aSCode="" return
	Quit:(aDateFrom="")||(aDateTo="") return
	set aDateFrom = $zd(aDateFrom,3)
	set aDateTo = $zd(aDateTo,3)
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="MMS" return  //物资管理
	//调用接口取手卫生用品数据
	
	set Count1 = 0	//记录手卫生用品维护同步的数据量
	set Count2 = 0  //记录手卫生用品消耗登记同步的数据量
	Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DHS.SyncCSSDInfo:QueryMatReq")
  	Set sc=rs.Execute(aDateFrom,aDateTo)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
		Set XCode=rs.Data("InciCode")
		Set DiagDesc=rs.Data("InciDesc")
		Set PinYin = ""
		Set DiagSpec=rs.Data("Spec")
		Set tempDiagUom=rs.Data("Uom")
		set Uom = ##class(DHCHAI.BT.Dictionary).GetIDByDesc("HandHyUnit",tempDiagUom)
		//判断单位是否维护在手卫生用品单位字典当中，不存在则需要维护进去
		if (Uom=""){
			set UID=""
			set TypeDr = 0
			set TypeDr = $o(^DHCHAI.BT.DicTypeI("IdxofCode","HandHyUnit",TypeDr))
			set UCode = ""
			for {
				set UCode = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",69,UCode))
				quit:UCode=""
				set MaxUCode=Ucode
			}
			set UomCode = MaxUCode+1
			set UspDesc = tempDiagUom
			set Paixu = UomCode
			set UIsActive = 1
			Set InputStr = UID							//UID
			Set InputStr = InputStr_"^"_UomCode			//单位代码
			Set InputStr = InputStr_"^"_UspDesc			//单位描述
			Set InputStr = InputStr_"^"_Paixu			//排序码
			Set InputStr = InputStr_"^"_UIsActive		//是否有效
			set chenckret = ##class(DHCHAI.BT.Dictionary).Update(InputStr,"^")
		}

		//手卫生用品维护
		set DiagUom = ##class(DHCHAI.BT.Dictionary).GetIDByDesc("HandHyUnit",tempDiagUom)
		Set Avg=3
		Set IsActive=1 
		set Resume=""
		Set xID=0
	 	set xID=$o(^DHCHAI.IR.HandHyProductsI("IndexDesc",DiagDesc,xID))
	 	continue:xID'=""							//过滤重复的手卫生用品
	 	set ID = ""
		Set InputStr = ID							//ID
		Set InputStr = InputStr_"^"_XCode			//手卫生用品代码
		Set InputStr = InputStr_"^"_DiagDesc		//手卫生用品描述
		Set InputStr = InputStr_"^"_PinYin			//拼音
		Set InputStr = InputStr_"^"_DiagSpec		//用品规格
		Set InputStr = InputStr_"^"_DiagUom			//用品单位
		Set InputStr = InputStr_"^"_Avg				//次均用量
		Set InputStr = InputStr_"^"_IsActive	 	//是否有效
		Set InputStr = InputStr_"^"_Resume			//备注
		Set ret = ##class(DHCHAI.IR.HandHyProducts).Update(InputStr,"^")
		continue:ret<1
		Set Count1=Count1+1
	}
	Set ms=##Class(%ResultSet).%New("DHCHAI.DI.DHS.SyncCSSDInfo:QueryMatReq")
  	Set sc=ms.Execute(aDateFrom,aDateTo)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	quit return	
  	}
	 While (ms.Next()){
		//手卫生用品消耗登记
		set MID = ""
		Set LocDr=ms.Data("ReqLocid")
		Set TempObsDate=ms.Data("date")
		set ObsDate=$zd(TempObsDate,3)
		Set ProductCode = ms.Data("InciCode")
		set ProductDr = 0
		set ProductDr = $o(^DHCHAI.IR.HandHyProductsI("IndexCode",ProductCode,ProductDr))
		Set Consumption=ms.Data("qty")
		Set Recipient=ms.Data("ssuser")
		Set RepDate     = ""
		Set RepTime     = ""
		set RegUserDr = 8
		set Active = 1
		set MResume	= "" 
		//拼接保存的数据
		Set MInputStr = MID								//手卫生用品消耗登记表ID
		Set MInputStr = MInputStr_"^"_LocDr				//病区
		Set MInputStr = MInputStr_"^"_ObsDate			//手卫生用品登记时间
		Set MInputStr = MInputStr_"^"_ProductDr			//手卫生用品登记的物品
		Set MInputStr = MInputStr_"^"_Consumption		//消耗量
		Set MInputStr = MInputStr_"^"_Recipient			//领用人
		Set MInputStr = MInputStr_"^"_RepDate			//登记日期
		Set MInputStr = MInputStr_"^"_RepTime	 		//登记时间
		Set MInputStr = MInputStr_"^"_RegUserDr			//登记人
		Set MInputStr = MInputStr_"^"_Active	 		//是否有效
		Set MInputStr = MInputStr_"^"_MResume			//备注
		Set Mret = ##class(DHCHAI.IR.HandHyConsums).Update(MInputStr,"^")
		continue:Mret<1
		
		Set Count2=Count2+1
	}
	Set return=Count1_","_Count2
	Quit return
SyncAdmDiagnosErr
	Set return="-999^"_$ZError
	Quit return
}

}
