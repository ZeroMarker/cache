Class web.DHCPE.CT.ChargeLimit Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：	  xy
/// CreatDate：	  20210822
/// Description:  获取打折权限
/// Table：       体检收费权限维护 DHC_PE_ChargeLimit
/// Input:        UserId（用户ID）, LocID(科室ID)
/// Return：      return=优惠打折^视同收费权限
/// Dubug:  d ##class(web.DHCPE.CT.ChargeLimit).GetOPChargeLimitInfo()
ClassMethod GetOPChargeLimitInfo(UserId As %String = "", LocID As %String = "")
{
	q:(UserId="")&&(LocID="") "N^N^0^0"
	s ID=$o(^CF.PE.ChargeLimitI("IdxOfLocUser"," "_LocID," "_UserId,0))
	q:(ID="") "N^N^0^0"
	s OPFlag=$lg($g(^CF.PE.ChargeLimitD(ID)),5)  //优惠打折
	s OPLimit=$lg($g(^CF.PE.ChargeLimitD(ID)),4)  //最大折扣
	s ASChargedFlag=$lg($g(^CF.PE.ChargeLimitD(ID)),12)  //取消/视同收费
	s OPChargeLimit=$lg($g(^CF.PE.ChargeLimitD(ID)),6) //视同收费权限 0：都不允许  1：个人允许 2：团体允许 3：个人和团体都允许
	s RoundingFeeMode=$lg($g(^CF.PE.ChargeLimitD(ID)),7) //凑整费模式
	s SetASCharged=$lg($g(^CF.PE.ChargeLimitD(ID)),13)  //定额卡支付
	s ALLRefund=$lg($g(^CF.PE.ChargeLimitD(ID)),14)     //全退申请
	//优惠打折^取消/视同收费^凑整费模式^最大折扣^定额卡支付
	q OPFlag_"^"_ASChargedFlag_"^"_RoundingFeeMode_"^"_OPLimit_"^"_SetASCharged_"^"_ALLRefund
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.ChargeLimit","FindChargeLimit","",304)
Query FindChargeLimit(UserId As %String = "", LocID As %String = "") As %Query(ROWSPEC = "TUserId:%String,TOPNumber:%String,TName:%String,TDFLimit:%String,TOPFlag:%String,CLOPChargeLimit:%String,CLOPChargeLimitDesc:%String,CLRoundingFee:%String,CLRoundingFeeDesc:%String,CLNoActive:%String,ID:%String,TAscharge:%String,CLSetASCharged,CLALLRefund")
{
}

ClassMethod FindChargeLimitExecute(ByRef qHandle As %Binary, UserId As %String = "", LocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s CurUser=""
 	s ^DHCPERecord("FindChargeLimit")=$lb(UserId,LocID)
 	for{
	 	s CurUser=$o(^CF.PE.ChargeLimitI("IdxOfLocUser"," "_LocID,CurUser))	
	 	q:(CurUser="")
	 	s ID=$o(^CF.PE.ChargeLimitI("IdxOfLocUser"," "_LocID,CurUser,0))
	 	q:(ID="")
	 	s (SSUser,Number,Name,DFLimit,OPFlag,ASChargedFlag)=""
	 	s SSUser=$replace(CurUser," ","")
	 	q:(UserId'="")&&(UserId'=SSUser)
	 	s Name=$p($g(^SSU("SSUSR",SSUser)),"^",2)
	 	s Number=$p($g(^SSU("SSUSR",SSUser)),"^",1)
	 	s DFLimit=$lg(^CF.PE.ChargeLimitD(ID),4)_"%"  // 最大折扣
	 	s OPFlag=$lg(^CF.PE.ChargeLimitD(ID),5)  // 打折权限
	 	i (DFLimit="0%")&&(OPFlag="N") s DFLimit=""
	 	// 0：都不允许  1：个人允许 2：团体允许 3：个人和团体都允许
	 	s CLOPChargeLimit=$lg(^CF.PE.ChargeLimitD(ID),6) // 视同收费模式 0123
	 	s CLOPChargeLimitDesc=""
	 	s:(CLOPChargeLimit=0) CLOPChargeLimitDesc="都不允许"
	 	s:(CLOPChargeLimit=1) CLOPChargeLimitDesc="个人允许"
	 	s:(CLOPChargeLimit=2) CLOPChargeLimitDesc="团体允许"
	 	s:(CLOPChargeLimit=3) CLOPChargeLimitDesc="个人和团体都允许"
	 	s CLRoundingFee=$lg(^CF.PE.ChargeLimitD(ID),7)
	 	s CLRoundingFeeDesc=""
	 	s:(CLRoundingFee=0) CLRoundingFeeDesc="都不允许"
	 	s:(CLRoundingFee=1) CLRoundingFeeDesc="个人允许"
	 	s:(CLRoundingFee=2) CLRoundingFeeDesc="团体允许"
	 	s:(CLRoundingFee=3) CLRoundingFeeDesc="个人和团体都允许"
	 	s CLNoActive=$lg(^CF.PE.ChargeLimitD(ID),8)
	 	s:(OPFlag="Y") OPFlag="是"
 		s:(OPFlag="N") OPFlag="否"
 		s TAscharge=$lg(^CF.PE.ChargeLimitD(ID),12)
 		s:(TAscharge="Y") TAscharge="是"
 		s:(TAscharge="N") TAscharge="否"
 		s:(CLNoActive="Y") CLNoActive="是"
 		s:(CLNoActive="N") CLNoActive="否"
 		s CLSetASCharged=$lg(^CF.PE.ChargeLimitD(ID),13)
 		s CLALLRefund=$lg(^CF.PE.ChargeLimitD(ID),14)
 		d FindBuild
	 }
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(SSUser,Number,Name,DFLimit,OPFlag,CLOPChargeLimit,CLOPChargeLimitDesc,CLRoundingFee,CLRoundingFeeDesc,CLNoActive,ID,TAscharge,CLSetASCharged,CLALLRefund)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindChargeLimitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindChargeLimitExecute ]
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

ClassMethod FindChargeLimitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindChargeLimitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Description: 打折权限维护
/// Table：表记录授权表 User.DHCPEChargeLimit  DHC_PE_ChargeLimit
/// Input: Instring：用户^ChargeLimit:最大折扣率^OPFlag:优惠打折^CLOPChargeLimit:视同收费权限^CLOPChargeMode:视同收费模式^CLRoundingFeeMode:凑整费最大额度 
/// ID:空标识新增,LocID,sessionUser,Active
/// Return：记录ID^错误描述 记录id返回-1标识更新失败
/// Creator：sxt 
/// CreatDate：20210808
/// dubug: w ##class(web.DHCPE.CT.ChargeLimit).OPChargeLimit("1^20^Y^Y^1^2","","152","12187","Y")
ClassMethod OPChargeLimit(Instring As %String, ID As %String, LocID, SessionUserID, Active)
{
	s ^DHCPERecord("OPChargeLimit")=$lb(Instring , ID , LocID, SessionUserID, Active)
	TS
	s OldData=""
	s OldUserID=""
	s UserID=$p(Instring,"^",1)
	if (ID=""){
		s obj=##class(User.DHCPEChargeLimit).%New()	
	}
	else{
		s OldData=$ListToString($g(^CF.PE.ChargeLimitD(ID)),"^")
		s obj=##class(User.DHCPEChargeLimit).%OpenId(ID)
		s OldUserID=$LG($G(^CF.PE.ChargeLimitD(ID)),3)	
	}
	q:(UserID'=OldUserID)&&($d(^CF.PE.ChargeLimitI("IdxOfLocUser"," "_LocID," "_UserID))) "-1^操作员重复!"
	s obj.CLLocDR=LocID
	s obj.CLUserDR=$p(Instring,"^",1)
	s obj.CLChargeLimit=+$p(Instring,"^",2)
	s obj.CLOPFlag=$p(Instring,"^",3)
	s obj.CLASChargedFlag=$p(Instring,"^",4) // 视同收费权限
	s obj.CLOPChargeLimit=$p(Instring,"^",5) // 视同收费模式
	s obj.CLRoundingFeeMode=$p(Instring,"^",6) //凑整费
	s obj.CLNoActive=Active
	s obj.CLUpdateDate=+$H
	s obj.CLUpdateTime=$p($h,",",2)
	s obj.CLUpdateUserDR=SessionUserID
	s obj.CLSetASCharged=$p(Instring,"^",7) //定额卡支付
	s obj.CLALLRefund=$p(Instring,"^",8) //全退申请
	s sc=obj.%Save()
	d obj.%Close()
	if ($System.Status.IsError(sc)){
		
		q "-1^"_$System.Status.GetErrorText(sc)
	}
	else{
		s RowID=obj.%Id()
		s NewData=$ListToString($g(^CF.PE.ChargeLimitD(RowID)),"^")
		/// 插入修改记录表
		s:(ID="") DeleteLog=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_ChargeLimit",RowID,"I",OldData,NewData,SessionUserID)
		s:(ID'="") DeleteLog=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_ChargeLimit",RowID,"U",OldData,NewData,SessionUserID)
		if ($p(DeleteLog,"^",1)<0){
			TRO
			q DeleteLog
		}
		else{
			TC
			q obj.%Id()
		}	
	}
}

/// Description: 删除打折授权记录
/// Input: ID(数据ID),UserId(用户ID)
/// Return：记录ID^错误描述 记录id返回-1标识更新失败
/// Creator：sxt 
/// CreatDate：20210808
ClassMethod DeleteOPChargeLimit(ID As %String, UserId As %String)
{
	q:ID="" "-1^未选择数据"
	TS
	 
	s OldData=$ListToString($g(^CF.PE.ChargeLimitD(ID)),"^")
	s obj=##class(User.DHCPEChargeLimit).%New()
	s sc=obj.%DeleteId(ID)
	d obj.%Close()
	if ($System.Status.IsError(sc)){
		TRO
		q "-1^"_$System.Status.GetErrorText(sc)
	}
	else{
		
		s DeleteLog=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_ChargeLimit",ID,"D",OldData,"",UserId)
		if ($p(DeleteLog,"^",1)<0){
			TRO
			q DeleteLog
		}
		else{
			TC
			q 0
		}	
	}
}

}
