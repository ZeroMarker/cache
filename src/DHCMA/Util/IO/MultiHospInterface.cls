/// 名称: DHCMA.Util.IO.MultiHospInterface
/// 描述: 多院区处理接口类
/// 编写者：yankai
/// 编写日期: 2021-07-20
Class DHCMA.Util.IO.MultiHospInterface Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  yankai
/// CreatDate：   2021-07-20
/// Description:  判断该条数据是否要显示到界面上（数据访问权限接口）
/// Table：       
/// Input：       aTableName:表名
/// 				  aRowID:记录ID
/// 				  aHospID:查询医院OID
/// 				  aDate:日期
/// Return：      Y:有权显示；N:无权显示
/// w ##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("DHCMA.CPW.BT.PathMast",1,2)
ClassMethod IsShowOneDataByHosp(aTableName As %String, aRowID As %String, aHospID As %String, aDate As %String = "") As %String
{
	New (aTableName,aRowID,aHospID,aDate)
	Set return="-999^入参错误"
	Quit:(aTableName="")||(aRowID="")||(aHospID="") return
	
	Set $ZT="IsShowOneDataByHospErr"
	Set:aDate="" aDate=+$h
	Set aDate=##class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(aDate)
	
	Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
	If (ret="Y")||(ret=1){
		Set return=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(aTableName,aRowID,$p(aHospID,"!!",1),aDate)	
	}Else{
		Set return="Y"	
	}
	
	Quit return

IsShowOneDataByHospErr
	Quit "-999"_"^"_$ZE
}

/// Creator:	  yankai
/// CreatDate：   2021-07-20
/// Description:  将数据保存到基础平台数据医院关联表中
/// Table：       
/// Input：       aTableName:表名
/// 			  aRowID：记录ID
/// 				  aHospID：关联的医院OID
/// Return：      id^添加成功；-1^添加失败；0^未启用
/// w ##class(DHCMA.Util.IO.MultiHospInterface).SaveDataRelHosp("DHCMA.CPW.BT.PathMast",1,"2!!1")
ClassMethod SaveDataRelHosp(aTableName As %String, aRowID As %String, aHospID As %String) As %String
{
	New (aTableName,aRowID,aHospID)
	Set return="-999^入参错误"
	Quit:(aTableName="")||(aRowID="")||(aHospID="") return
	
	Set $ZT="SaveDataRelHospErr"
	Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
	If (ret="Y")||(ret=1){
		Set return=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP(aTableName,aRowID,$p(aHospID,"!!",1))	
	}Else{
		Set return="0^未启用"	
	}
	
	Quit return
	
SaveDataRelHospErr
	Quit "-999^"_$ZE
}

/// Creator:	  yankai
/// CreatDate：   2021-07-20
/// Description:  从平台组数据医院关联表中删除某条数据与指定医院的关联关系
/// Table：       
/// Input：       aTableName:表名
/// 			  aRowID：记录ID
/// 			  aHospID：关联的医院OID
/// Return：      成功：1；失败：-1^关联医院表数据删除失败；0^未启用
/// w ##class(DHCMA.Util.IO.MultiHospInterface).SaveDataRelHosp("DHCMA_Util_BT.Dictionary",2,"3!!1")
ClassMethod DelOneDataHospRelRec(aTableName As %String, aRowID As %String, aHospID As %String) As %String
{
	New (aTableName,aRowID,aHospID)
	Set return="-999^入参错误"
	Quit:(aTableName="")||(aRowID="")||(aHospID="") return
	
	Set $ZT="DelOneDataHospRelRecErr"
	Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
	If (ret="Y")||(ret=1){
		Set return=##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteHospital(aTableName,aRowID,$p(aHospID,"!!",1))	
	}Else{
		Set return="0^未启用"	
	}
	
	Quit return
	
DelOneDataHospRelRecErr
	Quit "-999^"_$ZE
}

/// Creator:	  yankai
/// CreatDate：   2021-07-20
/// Description:  删除表里某条数据时，删除跟他所有关联医院关系
/// Table：       
/// Input：       aTableName:表名
/// 				  aRowID：记录ID
/// Return：      成功：1；失败：-1^关联医院表数据删除失败；0^未启用
/// w ##class(DHCMA.Util.IO.MultiHospInterface).GetDefaultHosp("DHCMA.CPW.BT.PathMast",1)
ClassMethod DelAllDataHospRelRecs(aTableName As %String, aRowID As %String, aHospID As %String) As %String
{
	New (aTableName,aRowID,aHospID)
	Set return="-999^入参错误"
	Quit:(aTableName="")||(aRowID="")||(aHospID="") return
	
	Set $ZT="DelDataHospRelRecsErr"
	Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
	If (ret="Y")||(ret=1){
		Set return=##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteHospitals(aTableName,aRowID)
	}Else{
		Set return="0^未启用"
	}
	
	Quit return
	
DelDataHospRelRecsErr
	Quit "-999^"_$ZE
}

/// Creator:	  yankai
/// CreatDate：   2021-07-20
/// Description:  根据表名、医院、日期取要取哪个医院的配置
/// Table：       
/// Input：       aTableName:表名；
/// 				  aHospID：当前医院OID
/// 				  aDate：日期
/// Return：      返回DHCMA.Util.EP.Hospital的OID
/// w ##class(DHCMA.Util.IO.MultiHospInterface).GetDefaultHosp("DHCMA.CPW.BT.PathMast","2!!1","")
ClassMethod GetDefaultHosp(aTableName As %String, aHospID As %String, aDate As %String = "") As %String
{
	New (aTableName,aHospID,aDate)
	Set return="-999^入参错误"
	Quit:(aTableName="")||(aHospID="") return
	
	Set $ZT="GetDefaultHospErr"
	Set:aDate="" aDate=+$h
	Set aDate=##class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(aDate)
	Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
	If (ret="Y")||(ret=1){
		Set retHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(aTableName,$p(aHospID,"!!",1),aDate)
	}Else{
		Set retHospID=aHospID					//如果未启用基础数据平台多院区功能，则直接返回当前医院
	}
	If (+retHospID>0)&&(retHospID'["!!"){
		Set objSYS=##class(DHCMA.Util.BT.SYSTEM).GetObjByCode("HIS01")
		Quit:'$IsObject(objSYS) "-998^MA系统参数错误"
		Set retHospID=retHospID_"!!"_objSYS.%Id()
	}
	Set return=retHospID
	
	Quit return

GetDefaultHospErr
	Quit "-999^"_$ZE
}

/// Description:	封装平台组提供获取医院下拉列表接口
/// CreateDate:		2021-07-23
/// Creator:		yankai
/// Input: 			rowid（医院OID）, desc（医院desc），tablename（表名）， SessionStr(用户ID^安全组ID^科室ID^当前登录医院ID，不传的时候默认根据session来取)
/// Output: 		HOSPRowId(医院rowid),HOSPDesc(医院名称)
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.MultiHospInterface","QryHospInfoForCombo","","","DHCMA_Util_BT.Dictionary","1^1^1^2")
Query QryHospInfoForCombo(aRowid As %String, aDesc As %String, aTableName As %String, aSessionStr As %String = "") As %Query(ROWSPEC = "OID:%String,Desc:%String,xID:%String,Code:%String,IsActive:%String,IsActDesc:%String,GroupID:%String,GroupDesc:%String") [ SqlProc ]
{
}

ClassMethod QryHospInfoForComboExecute(ByRef qHandlex As %Binary, aRowid As %String, aDesc As %String, aTableName As %String, aSessionStr As %String = "") As %Status
{
    Set repidx=$I(^CacheTemp)
 	Set indx=1
 	Set qHandlex=$lb(0,repidx,0)
    //Set ^TEMPYK("QryHospInfoForCombo")=$lb(aRowid,aDesc,aTableName,aSessionStr)
   
    Set userHospID=$p(aSessionStr,"^",4)
    Set objSYS=##class(DHCMA.Util.BT.SYSTEM).GetObjByCode("HIS01")
	Quit:'$IsObject(objSYS) $$$OK
	Set SysID=objSYS.%Id()
    Set:(userHospID'="")&&(userHospID'["!!") userHospID=userHospID_"!!"_SysID   
	
    Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",userHospID)
    If (ret="Y")||(ret=1){																				//启用基础平台多院区功能，则调用基础平台提供的接口查询医院
	    Set rs1=##Class(%ResultSet).%New("web.DHCBL.BDP.BDPMappingHOSP:GetHospDataForCombo")			//这里rs变量一定要重新命名，否则前台获取不到数据
	    Set sc1=rs1.Execute(aRowid,aDesc,aTableName,aSessionStr)
	  	If $$$ISERR(sc1) {
		  	Do $System.Status.DisplayError(sc1)
		  	Quit $$$OK
	  	}
	  	
	    While (rs1.Next()){
			Set HOSPRowID=rs1.Data("HOSPRowId")                // CT_Hospital的RowId
			Set Desc=rs1.Data("HOSPDesc")             	  	   // 描述
			Set OID=HOSPRowID_"!!"_SysID
			Set objHosp=##class(DHCMA.Util.EP.Hospital).GetObjByOID(OID)
			Continue:'$IsObject(objHosp)
			Set xID=$o(^DHCMA.Util.EPx.HospitalI("IdxOfOID"," "_$zcvt(OID,"U"),0))
			Set Code=objHosp.BTCode
			Set IsActive=objHosp.BTIsActive
			Set IsActDesc=$SELECT(objHosp.BTIsActive=1:"是",1:"否")
			Set (GroupID,GroupDesc)=""
			If $IsObject(objHosp.BTGroupDr) {
				Set GroupID=objHosp.BTGroupDr.%Id()
				Set GroupDesc=objHosp.BTGroupDr.BTDesc
			}
		 	
			set Data=$lb(OID,Desc,xID,Code,IsActive,IsActDesc,GroupID,GroupDesc)
       	 	Set ^CacheTemp(repidx,indx)=Data
        	Set indx=indx+1
	    }
	    Do rs1.Close()
	}
	Else{
											//不启用基础平台多院区功能，则直接返回有效的MA下医院,当前医院存在分组医院时，只显示本组下医院
		Set userHospGroupDr=""
		If userHospID'=""{
			Set userHospDr=$o(^DHCMA.Util.EPx.HospitalI("IdxOfOID"," "_$zcvt(userHospID,"U"),0))
			Quit:(userHospDr="") $$$OK
			Set objUserHosp=##class(DHCMA.Util.EPx.Hospital).%OpenId(userHospDr)
			Set:$IsObject(objUserHosp.BTGroupDr) userHospGroupDr=objUserHosp.BTGroupDr.%Id()		
		}
		
		Set xID=0
	 	For {
		 	Set xID=$o(^DHCMA.Util.EPx.HospitalD(xID))
		 	Quit:xID=""
		 	
		 	Set obj=##class(DHCMA.Util.EPx.Hospital).GetObjById(xID)
		 	Continue:'$IsObject(obj)
		 	
		 	Set OID         = obj.OID
		 	Set Code        = obj.BTCode
			Set Desc        = obj.BTDesc
			Set IsActive    = obj.BTIsActive
			Continue:IsActive'=1
			Set IsActDesc 	= $SELECT(obj.BTIsActive=1:"是",1:"否")
			Set ActDate     = obj.BTActDate
			Set ActTime     = obj.BTActTime
			Set ActUserID   = obj.BTActUserID
			Set GroupID="",GroupDesc=""
			If $IsObject(obj.BTGroupDr) {
				Set GroupID=obj.BTGroupDr.%Id()
				Continue:(userHospGroupDr'="")&&(userHospGroupDr'=GroupID)
				Set GroupDesc=obj.BTGroupDr.BTDesc
			}
			
			set Data=$lb(OID,Desc,xID,Code,IsActive,IsActDesc,GroupID,GroupDesc)
       	 	Set ^CacheTemp(repidx,indx)=Data
        	Set indx=indx+1
	 	}
	}
	Quit $$$OK
}

ClassMethod QryHospInfoForComboClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryHospInfoForComboExecute ]
{
    Set repidx=$LIST(qHandlex,2)
    Kill ^CacheTemp(repidx)
    Quit $$$OK
}

ClassMethod QryHospInfoForComboFetch(ByRef qHandlex As %Binary, ByRef Rowx As %List, ByRef AtEndx As %Integer = 0) As %Status [ PlaceAfter = QryHospInfoForComboExecute ]
{
    Set AtEndx=$LIST(qHandlex,1)
    Set repidx=$LIST(qHandlex,2)
    Set indx=$LIST(qHandlex,3)
    
    Set indx=$o(^CacheTemp(repidx,indx))
    If indx=""
    {
        //if there are no more rows,finish fetching...
        Set AtEndx=1
        Set Rowx=""
    }
    Else
    {
        Set Rowx=^CacheTemp(repidx,indx)
    }
    s qHandlex=$lb(AtEndx,repidx,indx)
    Quit $$$OK
}

/// Description:	封装平台组提供的根据登录角色的医院级授权，返回医院信息
/// CreateDate:		2021-07-26
/// Creator:		yankai
/// Input: 			aRowid:医院rowid， aDesc:医院desc，aTableName：表名，aDataid：数据rowid，aSessionStr：用户ID^安全组ID^科室ID^当前登录医院ID，不传的时候默认根据session来取
/// Output: 		MappingID：关联医院数据的rowid，HOSPRowId：医院rowid，HOSPDesc：医院名称，LinkFlag：表里的这条数据是否关联此医院
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.MultiHospInterface","QryHospDataForCloud","","","DHCMA_Util_BT.Dictionary","1","1^1^1^2")
Query QryHospDataForCloud(aRowid As %String, aDesc As %String, aTableName As %String, aDataID As %String, aSessionStr As %String) As %Query(ROWSPEC = "MappingID:%String,HOSPRowId:%String,HOSPDesc:%String,LinkFlag:%String,OID:%String,ID:%String,Code:%String")
{
}

ClassMethod QryHospDataForCloudExecute(ByRef qHandlex As %Binary, aRowid As %String, aDesc As %String, aTableName As %String, aDataID As %String, aSessionStr As %String) As %Status
{
	Set repidx=$I(^CacheTemp)
 	Set indx=1
 	Set qHandlex=$lb(0,repidx,0)
    
    Set userHospID=$p(aSessionStr,"^",4)
    Set objSYS=##class(DHCMA.Util.BT.SYSTEM).GetObjByCode("HIS01")
	Quit:'$IsObject(objSYS) $$$OK
	Set SysID=objSYS.%Id()
    Set:(userHospID'="")&&(userHospID'["!!") userHospID=userHospID_"!!"_SysID   
    
    Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",userHospID)
    If (ret="Y")||(ret=1){						//启用基础平台多院区功能，则调用基础平台提供的接口查询医院
	    Set rs1=##Class(%ResultSet).%New("web.DHCBL.BDP.BDPMappingHOSP:GetHospDataForCloud")
	  	Set sc1=rs1.Execute(aRowid,aDesc,aTableName,aDataID,aSessionStr)
	  	If $$$ISERR(sc1) {
		  	Do $System.Status.DisplayError(sc1)
		  	Quit $$$OK
	  	}
	    While (rs1.Next()){	//MappingID,HOSPRowId,HOSPDesc,LinkFlag
			Set MappingID=rs1.Data("MappingID")                // BDP_MappingHosp的RowId
			Set HOSPRowId=rs1.Data("HOSPRowId")          	  // ct_hospital表医院id
			Set HOSPDesc=rs1.Data("HOSPDesc")				  // 医院描述
			Set LinkFlag=rs1.Data("LinkFlag")				  // 关联标志
			
			Set OID=HOSPRowId_"!!"_SysID
			Set objHosp=##class(DHCMA.Util.EPx.Hospital).GetObjByOID(OID)
			Continue:'$IsObject(objHosp)
			Set ID=$o(^DHCMA.Util.EPx.HospitalI("IdxOfOID"," "_$zcvt(OID,"U"),0))
			Set Code=objHosp.BTCode
			
			set Data=$lb(MappingID,HOSPRowId,HOSPDesc,LinkFlag,OID,ID,Code)
       	 	Set ^CacheTemp(repidx,indx)=Data
        	Set indx=indx+1
	    }
	    Do rs1.Close()
	}Else{
		//未开启基础平台多院区功能的无需返回数据，页面不显示该授权按钮
	}
    Quit $$$OK
}

ClassMethod QryHospDataForCloudClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryHospDataForCloudExecute ]
{
    Set repidx=$LIST(qHandlex,2)
    Kill ^CacheTemp(repidx)
    Quit $$$OK
}

ClassMethod QryHospDataForCloudFetch(ByRef qHandlex As %Binary, ByRef Rowx As %List, ByRef AtEndx As %Integer = 0) As %Status [ PlaceAfter = QryHospDataForCloudExecute ]
{
    Set AtEndx=$LIST(qHandlex,1)
    Set repidx=$LIST(qHandlex,2)
    Set indx=$LIST(qHandlex,3)
    
    Set indx=$o(^CacheTemp(repidx,indx))
    If indx=""
    {
        //if there are no more rows,finish fetching...
        Set AtEndx=1
        Set Rowx=""
    }
    Else
    {
        Set Rowx=^CacheTemp(repidx,indx)
    }
    s qHandlex=$lb(AtEndx,repidx,indx)
    Quit $$$OK
}

}
