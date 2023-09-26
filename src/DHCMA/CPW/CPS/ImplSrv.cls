/// 名称: DHCMA.CPW.CPS.ImplSrv
/// 描述: 临床路径阶段内容相关服务
/// 编写者：jiangpengpeng
/// 编写日期: 2018-09-15
Class DHCMA.CPW.CPS.ImplSrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-15
/// Description:  将该阶段的内容同步到项目执行表中（同步阶段时同步）
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       aPathwayID:出入径记录ID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.ImplSrv).SyncImpl(122,122||5,"10209!!1")
ClassMethod SyncImpl(aPathwayID As %String, aEpisID As %String, aUserID As %String) As %String
{
	New (aPathwayID,aEpisID,aUserID)
	Set return=""
	Quit:(aPathwayID="")||(aEpisID="") -1
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(aPathwayID)
	Quit:'$IsObject(objPathway) -2
	
	Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aEpisID)
	Quit:'$IsObject(objEpis) -3
	
	Set objFormEp=objEpis.CPFormEpDr
	Quit:'$IsObject(objFormEp) -4
	
	Set FormEpID=$p(objFormEp.%Id(),"||",2)
	Set FormID=$p(objFormEp.%Id(),"||",1)
	Set xItemID=""
	For {
		Set xItemID=$o(^DHCMA.CPW.BT.PathFormD(FormID,"EP",FormEpID,"ITM",xItemID))
		Quit:xItemID=""
		
		Set objItem=##class(DHCMA.CPW.BT.PathFormItem).GetObjById(FormID_"||"_FormEpID_"||"_xItemID)
		Continue:'$IsObject(objItem)
		Set FormItemID=objItem.%Id()
		
		Set IsActive=objItem.ItemIsActive
		Continue:'IsActive
		Set ItemDesc=objItem.ItemDesc
		Set ItemIndNo=objItem.ItemIndNo
		Set ItemCatDesc=objItem.ItemCatDr.BTTypeDr.BTDesc
		Set ChildID=""
		If $d(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParFormItem",aPathwayID,FormItemID)){			//之前如果同步过，则直接更新
			Set ChildID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParFormItem",aPathwayID,FormItemID,""))	
		}
		
		Set Inputs=aPathwayID_"^"_ChildID_"^"_aEpisID_"^"_FormItemID_"^^^"_aUserID
		Set ret=##class(DHCMA.CPW.CP.PathwayImpl).Update(Inputs,"^")
		Set return=ret
		If (+ret<0) {
			Set return=-5
			Quit
		}
	}

	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-05-20
/// Description:  展现表单执行记录，输出所有内容
/// Table：       DHCMA.CPW.CP.PathwayImpl
/// Input：       
/// output: 
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.ImplSrv","QryImplItems","21","2")
Query QryImplItems(aPathwayID As %String, aEpisID As %String) As %Query(ROWSPEC = "ind:%String,PathwayID:%String,EpisID:%String,ImplID:%String,TypeDesc:%String,ItemDesc:%String,IsOption:%String,IsImp:%String,IsVar:%String")
{
}

ClassMethod QryImplItemsExecute(ByRef qHandle As %Binary, aPathwayID As %String, aEpisID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	Set strHeDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.cp.form.csp","【合】",LangID)			//页面返回约定数据翻译处理	
	
	Quit:(aPathwayID="")||(aEpisID="") $$$OK	
 	Set NIndex="QryImplItems"
    Kill ^TMP($zn,$j,NIndex)
 	
 	Set HospID=""
 	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(aPathwayID)
 	Quit:'$IsObject(objPathway) $$$OK
 	Set LocOID=objPathway.CPInLocID
 	Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(LocOID)
 	Set:$IsObject(objLoc) HospID=objLoc.BTHospID
 	
 	// 检查配置是否显示合并症执行的项目
 	Set IsShowComplItem=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWIsShowComplItem",HospID)
 	
	Set xImplID=""
	For {
		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",aPathwayID,aPathwayID_"||"_aEpisID,xImplID))
		Quit:xImplID=""
		
		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aPathwayID_"||"_xImplID)
		Continue:'$IsObject(objImpl)
 		Set IsActive=objImpl.CPIsActive
 		Continue:'IsActive
 		Continue:('+IsShowComplItem)&&(objImpl.CPPathwayComplDr'="")			//表单输出不输出合并症项目
 		
 		Set TypeCode=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTCode 
 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc		//项目类型描述
 		Set:TypeDesc'="" TypeDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.Dictionary","BTDesc",TypeDesc,LangID)
		Continue:TypeDesc=""
 		Set ItemIndNo=objImpl.CPFormItemDr.ItemIndNo 	//顺序号	
 		Set ItemDesc=objImpl.CPFormItemDr.ItemDesc		//项目描述
 		Set:ItemDesc'="" ItemDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormItem","ItemDesc",ItemDesc,LangID)
 		Set:objImpl.CPPathwayComplDr'="" ItemDesc="【合】"_ItemDesc
 		Set IsOption=objImpl.CPFormItemDr.ItemIsOption	//是否可选
 		Set IsImp=+objImpl.CPIsImp		//是否执行
 		
 		Set IsVar=0
 		If ('IsImp) {
	 		Set xVarID=""
	 		For {
				Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEpImpl",aPathwayID,aPathwayID_"||"_aEpisID,aPathwayID_"||"_xImplID,xVarID))
				Quit:xVarID=""
				
		 		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_xVarID)
		 		If ($IsObject(objVar)) {
			 		Continue:'objVar.CPIsActive
					Continue:objVar.CPVariatDr=""	//add by liuyh 2021-05-10
					Set IsVar=1
		 		}
			}
 		}
 		If (TypeCode="A") {
	 		If $d(^TMP($zn,$j,NIndex,1,ItemIndNo)){
		 		Set count=$o(^TMP($zn,$j,NIndex,1,ItemIndNo,""),-1)
		 		Set ^TMP($zn,$j,NIndex,1,ItemIndNo,count+1)=$lb(ind,aPathwayID,aEpisID,xImplID,TypeDesc,ItemDesc,IsOption,IsImp,IsVar)	
		 	}else{
			 	Set ^TMP($zn,$j,NIndex,1,ItemIndNo,1)=$lb(ind,aPathwayID,aEpisID,xImplID,TypeDesc,ItemDesc,IsOption,IsImp,IsVar)
			}		
 		} ElseIf (TypeCode="B") {
	 		If $d(^TMP($zn,$j,NIndex,2,ItemIndNo)){
		 		Set count=$o(^TMP($zn,$j,NIndex,2,ItemIndNo,""),-1)
		 		Set ^TMP($zn,$j,NIndex,2,ItemIndNo,count+1)=$lb(ind,aPathwayID,aEpisID,xImplID,TypeDesc,ItemDesc,IsOption,IsImp,IsVar)	
		 	}else{
			 	Set ^TMP($zn,$j,NIndex,2,ItemIndNo,1)=$lb(ind,aPathwayID,aEpisID,xImplID,TypeDesc,ItemDesc,IsOption,IsImp,IsVar)
			}
	 	} ElseIf (TypeCode="C") {
		 	If $d(^TMP($zn,$j,NIndex,3,ItemIndNo)){
		 		Set count=$o(^TMP($zn,$j,NIndex,3,ItemIndNo,""),-1)
		 		Set ^TMP($zn,$j,NIndex,3,ItemIndNo,count+1)=$lb(ind,aPathwayID,aEpisID,xImplID,TypeDesc,ItemDesc,IsOption,IsImp,IsVar)	
		 	}else{
			 	Set ^TMP($zn,$j,NIndex,3,ItemIndNo,1)=$lb(ind,aPathwayID,aEpisID,xImplID,TypeDesc,ItemDesc,IsOption,IsImp,IsVar)
			}
	 	} Else {}
 		
	}
	
	Set xItemType=""
	For{
		Set xItemType=$o(^TMP($zn,$j,NIndex,xItemType))
		Quit:xItemType=""
		
		Set xItemIndNo=""
		For {
			Set xItemIndNo=$o(^TMP($zn,$j,NIndex,xItemType,xItemIndNo))
			Quit:xItemIndNo=""
			
			Set xCount=""
			For {
				Set xCount=$o(^TMP($zn,$j,NIndex,xItemType,xItemIndNo,xCount))
				Quit:xCount=""
				
				Set Data=$g(^TMP($zn,$j,NIndex,xItemType,xItemIndNo,xCount))
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1	
			}
		}	
	}
		
	Quit $$$OK
}

ClassMethod QryImplItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryImplItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryImplItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryImplItemsExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2019-05-30
/// Description:  批量操作
/// Table：       
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CPS.ImplSrv).UpdateItms("7^11^13^14^18^18^19^19","1","2","21","10209!!1")
ClassMethod UpdateItms(aItms As %String, aIsImpl As %String, aType As %String, aPathwayID As %String, aUserID As %String) As %String
{
	New (aItms,aIsImpl,aType,aPathwayID,aUserID)
	Set return=""
	Quit:(aItms="")||(aIsImpl="")||(aType="")||(aPathwayID="")||(aUserID="") return
	
	For ind=1:1:$length(aItms,"^"){
		Set ItmID=$p(aItms,"^",ind)
		Continue:ItmID=""
		
		Set ret=##class(DHCMA.CPW.CP.PathwayImpl).ExecuteItem(aPathwayID,ItmID,"",aUserID,aIsImpl,aType)
		Set return=ret
	}
	
	Quit return
}

}
