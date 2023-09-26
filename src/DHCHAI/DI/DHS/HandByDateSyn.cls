Class DHCHAI.DI.DHS.HandByDateSyn Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     陈剑波
/// CreatDate：   2022-11-07
/// Description:  根据日期同步手卫生物资库存转移数据
/// Input：       aDateTo：结束日期
/// 			  aDateFrom : 开始日期
/// 			  aHospCode：医院代码
/// Return：      处理的条数
/// w ##class(DHCHAI.DI.DHS.HandByDateSyn).SyncHandByDate("HAND01",66261,66291)
ClassMethod SyncHandByDate(aSCode As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	
	New (aSCode,aDateFrom,aDateTo)
	Set return="",Count=0
	Quit:aSCode="" return
	
	Set $ZT="SyncHandByDateErr"
	
	Quit:(aDateFrom="")||(aDateTo="") return
	set aDateFrom = $zd(aDateFrom,3)
	set aDateTo = $zd(aDateTo,3)
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="MMS" return  //物资管理
	//手消品请领类型描述
	Set IncscDesc=##class(DHCHAI.BT.Config).GetValByCode("IncscTypeDesc") 
	Quit:IncscDesc="" return
	//调用接口取手卫生用品数据
	set Count1 = 0	//记录手卫生用品维护同步的数据量
	set Count2 = 0  //记录手卫生用品消耗登记同步的数据量
	//循环科室病区进行同步
	Set xHospID=0
	For {
		Set xHospID=$o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID))
		Quit:xHospID=""
		
		Set xIDN=0
		For {
			Set xIDN=$o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID,xIDN))
			Quit:xIDN=""
			
			Set objLocN=##class(DHCHAI.BT.Location).GetObjById(xIDN)
			Continue:'$isobject(objLocN)
			Continue:'$isobject(objLocN.BTTypeDr)
			Set IsActive	= objLocN.BTIsActive
			Continue:IsActive'=1
			Set LocTypeN     =objLocN.BTTypeDr.BTCode
			//Continue:(LocType'="W")
			Continue:(LocTypeN'="W")&&(LocTypeN'="E")  
			Set LocCateCode =""
			Set:'$Isobject(objLocN.BTCateDr) LocCateCode = objLocN.BTCateDr.BTCode			
			Continue:(LocCateCode'="E")&&(LocCateCode'="I")
			Set IsICU	    = objLocN.BTIsICU
			Set IsNICU	    = objLocN.BTIsNICU
			//Continue:(IsICU'=1)&&(IsNICU'=1)
			Set LocDrN=objLocN.%Id()
			Set xLocCode = $p(objLocN.BTXCode,"||",2)
			Write "Hand LocDr="_LocDrN,!
			
			Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DHS.SyncCSSDInfo:QueryMatTrf")
		  	Set sc=rs.Execute(aDateFrom,aDateTo,xLocCode,"")
		  	If $$$ISERR(sc) {
			  	Do $System.Status.DisplayError(sc)
			  	Continue
		  	}
		  	
		    While (rs.Next()){
			    //增加类型过滤
			    Set IncscRst = rs.Data("IncscDesc")
			    Continue:IncscRst=""
			    Continue:IncscDesc'[IncscRst  //不包含即不存储
				Set XCode=rs.Data("InciCode")
				Set DiagDesc=rs.Data("InciDesc")
				Set PinYin = ""
				Set DiagSpec=rs.Data("Spec")
				Set tempDiagUom=rs.Data("BUomDesc")
				set Uom = ##class(DHCHAI.BT.Dictionary).GetIDByDesc("HandHyUnit",tempDiagUom)
				//判断单位是否维护在手卫生用品单位字典当中，不存在则需要维护进去
				if (Uom=""){
					set UID=""
					set TypeDr = 0
					set TypeDr = $o(^DHCHAI.BT.DicTypeI("IdxofCode","HandHyUnit",TypeDr))
					set UCode = ""
					for {
						set UCode = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,UCode))
						quit:UCode=""
						set MaxUCode=UCode
					}
					set UomCode = MaxUCode+1
					set UspDesc = tempDiagUom
					set Paixu = UomCode
					set UIsActive = 1
					Set InputStr = UID							//UID
					Set InputStr = InputStr_"^"_UomCode			//单位代码
					Set InputStr = InputStr_"^"_UspDesc			//单位描述
					Set InputStr = InputStr_"^"_TypeDr			//字典类型
					Set InputStr = InputStr_"^"_Paixu			//排序码
					Set InputStr = InputStr_"^"_UIsActive		//是否有效
					set chenckret = ##class(DHCHAI.BT.Dictionary).Update(InputStr,"^")
				}

				//手卫生用品维护
				set DiagUom = ##class(DHCHAI.BT.Dictionary).GetIDByDesc("HandHyUnit",tempDiagUom)
				Set Avg=0
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
			Set ms=##Class(%ResultSet).%New("DHCHAI.DI.DHS.SyncCSSDInfo:QueryMatTrf")
		  	Set scN=ms.Execute(aDateFrom,aDateTo,xLocCode,"")
		  	If $$$ISERR(scN) {
			  	Do $System.Status.DisplayError(scN)
			  	Continue
		  	}
		  	
			 While (ms.Next()){
				//手卫生用品消耗登记
				set MID = ""
				Set LocDr=ms.Data("Loc")
				Set TempObsDate=ms.Data("Date")
				set ObsDate=$zd(TempObsDate,3)
				Set ProductCode = ms.Data("InciCode")
				set ProductDr = 0
				set ProductDr = $o(^DHCHAI.IR.HandHyProductsI("IndexCode",ProductCode,ProductDr))
				Set Consumption=ms.Data("TrQtyB")
				Set Recipient=ms.Data("AuditUser")
				Set:Recipient="" Recipient="为空值"
				Set RepDate     = ""
				Set RepTime     = ""
				set RegUserDr = 8
				set Active = 1
				set MResume	= "" 
				Set reqitmid=ms.Data("TrId")
				continue:$d(^DHCHAI.IR.HandHyConsumsI("IndexxCode",reqitmid))
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
				Set MInputStr = MInputStr_"^"_reqitmid
				Set Mret = ##class(DHCHAI.IR.HandHyConsums).Update(MInputStr,"^")
				continue:Mret<1
				
				Set Count2=Count2+1
			}
		}
	}
	
	
	Set return=Count1_","_Count2
	Quit return
SyncHandByDateErr
	
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：     chenrui  已不用 2022-11-07
/// CreatDate：   2020-07-27
/// Description:  根据日期同步手卫生请领单数据
/// Input：       aDateTo：结束日期
/// 			  aDateFrom : 开始日期
/// 			  aHospCode：医院代码
/// Return：      处理的条数
/// w ##class(DHCHAI.DI.DHS.HandByDateSyn).SyncHandByDate("HAND01",$zdh("2019-02-01",3),$zdh("2019-03-01",3))
ClassMethod SyncHandByDateDelete(aSCode As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	
	New (aSCode,aDateFrom,aDateTo)
	Set $ZT="SyncHandByDateDeleteErr"
	
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
	//手消品请领类型描述
	Set IncscDesc=##class(DHCHAI.BT.Config).GetValByCode("IncscTypeDesc") 
	Quit:IncscDesc="" return
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
	    //增加类型过滤
	    Set IncscRst = rs.Data("Incsc")
	    Continue:IncscRst=""
	    Continue:IncscDesc'[IncscRst  //不包含即不存储
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
				set UCode = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,UCode))
				quit:UCode=""
				set MaxUCode=UCode
			}
			set UomCode = MaxUCode+1
			set UspDesc = tempDiagUom
			set Paixu = UomCode
			set UIsActive = 1
			Set InputStr = UID							//UID
			Set InputStr = InputStr_"^"_UomCode			//单位代码
			Set InputStr = InputStr_"^"_UspDesc			//单位描述
			Set InputStr = InputStr_"^"_TypeDr			//字典类型
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
		Set reqitmid=ms.Data("reqitmid")
		continue:$d(^DHCHAI.IR.HandHyConsumsI("IndexxCode",reqitmid))
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
		Set MInputStr = MInputStr_"^"_reqitmid
		Set Mret = ##class(DHCHAI.IR.HandHyConsums).Update(MInputStr,"^")
		continue:Mret<1
		
		Set Count2=Count2+1
	}
	Set return=Count1_","_Count2
	Quit return
SyncHandByDateDeleteErr
	Set return="-999^"_$ZError
	Quit return
}

}
