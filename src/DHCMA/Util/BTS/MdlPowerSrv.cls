/// 名称: DHCMA.Util.BTS.MdlPowerSrv
/// 描述: 模块操作权限表
/// 编写者：liuzhenhe
/// 编写日期: 2018-11-27
/// 编写目的:查询DHCMA.Util.BT.MdlPower(模块权限表)
Class DHCMA.Util.BTS.MdlPowerSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2018-12-27
/// Description:  更新模块操作权限信息
/// Table：       DHCMA.Util.BT.MdlPower
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回>0，失败：返回<1
/// w ##class(DHCMA.Util.BTS.MdlPowerSrv).UpdateMdlPower("141!!1^1^^1^9!!1")
ClassMethod UpdateMdlPower(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0,Count=0
	Quit:aInputStr="" return
	
	Set SSGroupID = $p(aInputStr,"^",1)
	Set MdlDr     = $p(aInputStr,"^",2)
	Set MdlRoleDr = $p(aInputStr,"^",3)
	Set IsActive  = $p(aInputStr,"^",4)
	Set SSUserID  = $p(aInputStr,"^",5)
	Quit:SSGroupID="" return
	
	Set objSSGrp=##class(DHCMA.Util.EP.SSGroup).GetObjByOID(SSGroupID)
	Quit:'$IsObject(objSSGrp) return
	
	If MdlRoleDr="" {
		Set xSubID=0
	 	For {
		 	Set xSubID=$o(^DHCMA.Util.BT.MdlDefD(MdlDr,"R",xSubID))
		 	Quit:xSubID=""
		 	
		 	Set objRole=##class(DHCMA.Util.BT.MdlRole).GetObjById(MdlDr_"||"_xSubID)
		 	Continue:'$IsObject(objRole)
		 	Continue:'$IsObject(objRole.Parref)
		 	Set MdlRoleDr=objRole.%Id()
		 	
		 	Set InputStr=""
		 	Set InputStr=InputStr_"^"_SSGroupID
		 	Set InputStr=InputStr_"^"_MdlRoleDr
		 	Set InputStr=InputStr_"^"_IsActive
		 	Set InputStr=InputStr_"^"_+$h
		 	Set InputStr=InputStr_"^"_$p($h,",",2)
		 	Set InputStr=InputStr_"^"_SSUserID
		 	Set flg=##class(DHCMA.Util.BT.MdlPower).Update(InputStr,"^")
		 	Set:flg>0 Count=Count+1
	 	}
	} else {
	 	Set InputStr=""
	 	Set InputStr=InputStr_"^"_SSGroupID
	 	Set InputStr=InputStr_"^"_MdlRoleDr
	 	Set InputStr=InputStr_"^"_IsActive
	 	Set InputStr=InputStr_"^"_+$h
	 	Set InputStr=InputStr_"^"_$p($h,",",2)
	 	Set InputStr=InputStr_"^"_SSUserID
	 	Set flg=##class(DHCMA.Util.BT.MdlPower).Update(InputStr,"^")
	 	Set:flg>0 Count=Count+1
	}
	Set return=Count
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-11-28
/// Description:  查询模块操作权限表
/// Table：       DHCMA.Util.BT.MdlPower
/// Input：       aProCode
/// Output:		  ID,GroupID,GroupDesc,MdlDefID,MdlDefDesc,MdlRoleID,MdlRoleDesc,IsActive,ActDate,ActTime,ActUserID,ActUserDesc
/// D ##class(%ResultSet).RunQuery("DHCMA.Util.BTS.MdlPowerSrv","QryMdlPower","141!!1","")
Query QryMdlPower(aSSGrpID As %String, aProductDr As %String) As %Query(ROWSPEC = "rowIdField:%String,rowTreeField:%String,MdlID:%String,MdlRoleID:%String,ProductID:%String,ProductDesc:%String,IsActive:%String,ActDateTime:%String,ActUserOID:%String,ActUserDesc:%String,_parentId:%String")
{
}

ClassMethod QryMdlPowerExecute(ByRef qHandle As %Binary, aSSGrpID As %String, aProductDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set rowIdField=0
 	Set xProductID=0
 	For {
	 	Set xProductID=$o(^DHCMA.Util.BT.MdlDefI("IdxofProductDr",xProductID))
	 	Quit:xProductID=""
	 	Continue:(aProductDr'="")&&(xProductID'=aProductDr)
	 	
	 	Set xMdlID=0
	 	For {
		 	Set xMdlID=$o(^DHCMA.Util.BT.MdlDefI("IdxofProductDr",xProductID,xMdlID))
	 		Quit:xMdlID=""
	 		
	 		Set objMdlDef=##class(DHCMA.Util.BT.MdlDef).GetObjById(xMdlID)
	 		Continue:'$IsObject(objMdlDef)
	 		Continue:'$IsObject(objMdlDef.BTProductDr)
		 	Set MdlID=objMdlDef.%Id()
		 	Set MdlDesc=objMdlDef.BTDesc
		 	Set ProductID=objMdlDef.BTProductDr.%Id()
		 	Set ProductDesc=objMdlDef.BTProductDr.ProDesc
		 	
		 	//模块定义
		 	//rowIdField,rowTreeField,MdlID,MdlRoleID,ProductID,ProductDesc,IsActive,ActDateTime,ActUserID,ActUserDesc,_parentId
			Set rowIdField=rowIdField+1,rowTreeField="【"_ProductDesc_"】"_MdlDesc
			Set Data=$lb(rowIdField,rowTreeField,MdlID,"",ProductID,ProductDesc,"","","","","")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 		
	 		Set ParentId=rowIdField
	 		Set GroupFlag=0
	 		Set xSubID=0
		 	For {
			 	Set xSubID=$o(^DHCMA.Util.BT.MdlDefD(xMdlID,"R",xSubID))
			 	Quit:xSubID=""
			 	
			 	Set objRole=##class(DHCMA.Util.BT.MdlRole).GetObjById(xMdlID_"||"_xSubID)
			 	Continue:'$IsObject(objRole)
			 	Continue:'$IsObject(objRole.Parref)
			 	Set MdlRoleID=objRole.%Id()
			 	Set MdlRoleDesc=objRole.BTDesc
			 	
			 	Set (IsActive,ActDateTime,ActUserID,ActUserDesc)=""
			 	If aSSGrpID'="" {
				 	Set PowerID=$o(^DHCMA.Util.BT.MdlPowerI("IdxOfMdlRoleGrp",MdlRoleID," "_aSSGrpID,0))
				 	If PowerID'="" {
					 	Set objPower=##class(DHCMA.Util.BT.MdlPower).GetObjById(PowerID)
					 	If $IsObject(objPower){
						 	Set IsActive=objPower.BTIsActive
							Set IsActive=$s(IsActive=1:"是",1:"否")
						 	Set ActDate=objPower.BTActDate
						 	Set ActTime=objPower.BTActTime
							Set:ActDate'="" ActDate=$zd(ActDate,3)
						 	Set:ActTime'="" ActTime=$zt(ActTime,1)
						 	Set:ActDate'="" ActDateTime=ActDate_" "_ActTime
						 	Set objActUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(objPower.BTActUserID)
						 	If $IsObject(objActUser) {
							 	Set ActUserOID=objActUser.OID
							 	Set ActUserDesc=objActUser.BTDesc
						 	}
						}
					}
			 	}
				
				//模块角色授权
				//rowIdField,rowTreeField,MdlID,MdlRoleID,ProductID,ProductDesc,IsActive,ActDateTime,ActUserID,ActUserDesc,_parentId
				Set rowIdField=rowIdField+1,rowTreeField=MdlRoleDesc
				Set Data=$lb(rowIdField,rowTreeField,MdlID,MdlRoleID,ProductID,ProductDesc,IsActive,ActDateTime,ActUserOID,ActUserDesc,ParentId)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryMdlPowerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMdlPowerExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMdlPowerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMdlPowerExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
