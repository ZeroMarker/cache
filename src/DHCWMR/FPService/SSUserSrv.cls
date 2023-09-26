/// 名称: DHCWMR.FPService.SSUserSrv
/// 描述: 用户/医护人员相关服务
/// 编写者：zhufei
/// 编写日期: 2014-10-29
Class DHCWMR.FPService.SSUserSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-10-29
/// Description:  查询用户/医护人员列表
/// Table：       SS_User,CT_CareProv
/// Input：       Alias : 别名
///               TypeCode : 分类（DOCTOR医生、NURSE护士、OPRDOC手术医生、OPRASS一助/二助、NARDOC麻醉医师）
///               PageSize : 输入行
/// Return：      返回Query
/// D ##class(%ResultSet).RunQuery("DHCWMR.FPService.SSUserSrv","QryUserByAlias","王","DOCTOR",10)
Query QryUserByAlias(aAlias As %String, aTypeCode As %String, aPageSize As %String) As %Query(ROWSPEC = "UserID:%String,UserInitials:%String,UserName:%String,UserPinYin:%String,CTPID:%String,CTPCode:%String,CTPDesc:%String,CTPTpDesc:%String,CTPIntTp:%String") [ SqlProc ]
{
}

ClassMethod QryUserByAliasExecute(ByRef qHandle As %Binary, aAlias As %String, aTypeCode As %String, aPageSize As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	Quit:(aAlias="")||(aTypeCode="") $$$OK
	
	Set Count=0,aPageSize=+aPageSize
	
	Set yAlias=$$ALPHAUP^SSUTIL4(aAlias)
	//完全匹配 姓名
 	Set xID=0
	For {
 		Set xID=$o(^SSU("SSUSR",0,"SSUSR_Name",yAlias,xID))
 		Quit:xID=""
 		Set UserID=xID
		Do BuildDataByAlias
	}
	//完全匹配 工号
 	Set xID=0
	For {
 		Set xID=$o(^SSU("SSUSR",0,"SSUSR_Initials",yAlias,xID))
 		Quit:xID=""
 		Set UserID=xID
		Do BuildDataByAlias
	}
	//完全匹配 姓名拼音
 	Set xCTPDesc=""
	For {
 		Set xCTPDesc=$o(^CTPCP(0,"SMCNo",yAlias,xCTPDesc))
 		Quit:xCTPDesc=""
 		Set xCTPID=0
 		For {
	 		Set xCTPID=$o(^CTPCP(0,"SMCNo",yAlias,xCTPDesc,xCTPID))
 			Quit:xCTPID=""
 			Set xID=0
 			For {
	 			Set xID=$o(^SSU("SSUSR",0,"CTPCP",xCTPID,xID))
 				Quit:xID=""
	 			Set UserID=xID
				Do BuildDataByAlias
	 		}
	 	}
	}
	
	//包含关系 姓名
	Set xAlias=yAlias
	For {
		Set xAlias=$o(^SSU("SSUSR",0,"SSUSR_Name",xAlias))
		Quit:xAlias=""
		Quit:$p(xAlias,yAlias,1)'=""
		Quit:(aPageSize>0)&&(Count>aPageSize)
	 	
		Set xID=0
		For {
	 		Set xID=$o(^SSU("SSUSR",0,"SSUSR_Name",xAlias,xID))
	 		Quit:xID=""
 			Quit:(aPageSize>0)&&(Count>aPageSize)
	 		
	 		Set UserID=xID
			Do BuildDataByAlias
		}
	}
	//完全匹配 工号
	Set xAlias=yAlias
	For {
		Set xAlias=$o(^SSU("SSUSR",0,"SSUSR_Initials",xAlias))
		Quit:xAlias=""
		Quit:$p(xAlias,yAlias,1)'=""
		Quit:(aPageSize>0)&&(Count>aPageSize)
	 	
		Set xID=0
		For {
	 		Set xID=$o(^SSU("SSUSR",0,"SSUSR_Initials",xAlias,xID))
	 		Quit:xID=""
	 		Quit:(aPageSize>0)&&(Count>aPageSize)
	 		
 			Set UserID=xID
			Do BuildDataByAlias
		}
	}
	//完全匹配姓名拼音Set xAlias=yAlias
	For {
		Set xAlias=$o(^CTPCP(0,"SMCNo",xAlias))
		Quit:xAlias=""
		Quit:$p(xAlias,yAlias,1)'=""
		Quit:(aPageSize>0)&&(Count>aPageSize)
	 	
		Set xCTPDesc=""
		For {
	 		Set xCTPDesc=$o(^CTPCP(0,"SMCNo",xAlias,xCTPDesc))
	 		Quit:xCTPDesc=""
	 		Quit:(aPageSize>0)&&(Count>aPageSize)
	 		
	 		Set xCTPID=0
	 		For {
		 		Set xCTPID=$o(^CTPCP(0,"SMCNo",xAlias,xCTPDesc,xCTPID))
	 			Quit:xCTPID=""
	 			Quit:(aPageSize>0)&&(Count>aPageSize)
	 			
	 			Set xID=0
	 			For {
		 			Set xID=$o(^SSU("SSUSR",0,"CTPCP",xCTPID,xID))
	 				Quit:xID=""
	 				Quit:(aPageSize>0)&&(Count>aPageSize)
	 				
 					Set UserID=xID
					Do BuildDataByAlias
		 		}
		 	}
		}
	}
	//匹配首拼
	Set xCTPID=0
	For {
		Set xCTPID = $o(^CTPCP(xCTPID))
		Quit:xCTPID=""
	
		Set OtherName = $p($g(^CTPCP(xCTPID,3)),"^",28)
		Continue:OtherName'[yAlias
		
		Set xID=0
	 	For {
		 	Set xID=$o(^SSU("SSUSR",0,"CTPCP",xCTPID,xID))
	 		Quit:xID=""
	 		Quit:(aPageSize>0)&&(Count>aPageSize)
	 				
 			Set UserID=xID
			Do BuildDataByAlias
		}
	}
	/*If $l(aAlias)>1 {
	 	Set Data=$LB("-","",aAlias,"","","","","","")
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	}*/
 	
	Quit $$$OK
	
BuildDataByAlias
	Set IsActive=$p($g(^SSU("SSUSR",xID)),"^",19)
	Quit:IsActive'="Y"
	Set CTPID=$p($g(^SSU("SSUSR",xID)),"^",14)
	Quit:CTPID=""
	Set UserInitials=$p($g(^SSU("SSUSR",xID)),"^",1)
	Set UserName=$p($g(^SSU("SSUSR",xID)),"^",2)
	//Set UserPinYin=$p($g(^SSU("SSUSR",xID)),"^",11)
	Set UserPinYin=$p($g(^CTPCP(CTPID,1)),"^",6)
	Set OtherName = $p($g(^CTPCP(CTPID,3)),"^",28)
	Quit:($zcvt(UserName,"U")'[$zcvt(aAlias,"U"))&&($zcvt(UserInitials,"U")'[$zcvt(aAlias,"U"))&&($zcvt(UserPinYin,"U")'[$zcvt(aAlias,"U"))&&($zcvt(OtherName,"U")'[$zcvt(aAlias,"U"))
	Quit:(UserName["测试")||(UserName["作废")
	
	Set CTPCode=$p($g(^CTPCP(CTPID,1)),"^",1)
	Set CTPDesc=$p($g(^CTPCP(CTPID,1)),"^",2)
	Set CTPTpID=$p($g(^CTPCP(CTPID,1)),"^",4)
	Set CTPTpDesc=$p($g(^CT("CPT",+CTPTpID)),"^",2)
	Set CTPIntTp=$p($g(^CT("CPT",+CTPTpID)),"^",4)
	If aTypeCode'="" {
		Quit:(aTypeCode="DOCTOR")&&(CTPIntTp'="DOCTOR")
		Quit:(aTypeCode="NURSE")&&(CTPIntTp'="NURSE")
		Quit:(aTypeCode="OPRDOC")&&(CTPIntTp'="DOCTOR")&&(CTPIntTp'="NURSE")
		Quit:(aTypeCode="OPRASS")&&(CTPIntTp'="DOCTOR")&&(CTPIntTp'="NURSE")
		Quit:(aTypeCode="NARDOC")&&(CTPIntTp'="DOCTOR")&&(CTPIntTp'="NURSE")
	}
	
	Set Count=Count+1
	
 	Set Data=$LB(xID,UserInitials,UserName,UserPinYin,CTPID,CTPCode,CTPDesc,CTPTpDesc,CTPIntTp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	
 	Quit
}

ClassMethod QryUserByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUserByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryUserByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUserByAliasExecute ]
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

/// w ##Class(DHCWMR.FPService.SSUserSrv).GetUserNameByID(1)
ClassMethod GetUserNameByID(aUserID As %String) As %String
{
	New (aUserID)
	Set return=""
	Quit:aUserID="" return
	Quit:'$d(^SSU("SSUSR",+aUserID)) return
	Set return=$p($g(^SSU("SSUSR",+aUserID)),"^",2)
	Quit return
}

/// 通过姓名/工号查询医护人员列表
/// d ##class(%ResultSet).RunQuery("DHCWMR.FPService.SSUserSrv","QueryByName","4","","6")
Query QueryByName(HospID As %String, Name As %String, Ctloc As %String) As %Query(ROWSPEC = "UserRowid:%String,UserCode:%String,UserName:%String,UserLoc:%String")
{
}

ClassMethod QueryByNameExecute(ByRef qHandle As %Binary, HospID As %String, Name As %String, Ctloc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s Name=$$ALPHAUP^SSUTIL4(Name)
	s Rowid=0
    f  s Rowid=$o(^SSU("SSUSR",Rowid)) q:Rowid=""  d
    .q:$p($g(^SSU("SSUSR",+Rowid)),"^",19)'="Y"
    .s UserCode=$p($g(^SSU("SSUSR",+Rowid)),"^",1)
    .s UserName=$p($g(^SSU("SSUSR",+Rowid)),"^",2)
    .s UserLocRowid=+$p($g(^SSU("SSUSR",+Rowid)),"^",4)
    .s HospId = ##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(UserLocRowid)
    .s UserPinYin=$p($g(^SSU("SSUSR",+Rowid)),"^",11)
    .;q:(Code'="")&&($e(UserCode,1,$l(Code))'=Code)
    .q:(Name'="")&&($e(UserName,1,$l(Name))'=Name)&&($e(UserPinYin,1,$l(Name))'=Name)
    .q:(Ctloc'="")&(UserLocRowid'=Ctloc)
    .//q:(HospID'="")&(HospId'=HospID)
    .s UserLoc=""
    .s:UserLocRowid'=0 UserLoc=$p(^CTLOC(+UserLocRowid),"^",2)
    .s:UserLoc["-" UserLoc=$p(UserLoc,"-",2)
    .s Data=$lb(Rowid,UserCode,UserName,UserLoc)
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
    
    Quit $$$OK
}

ClassMethod QueryByNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByNameExecute ]
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

ClassMethod QueryByNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
