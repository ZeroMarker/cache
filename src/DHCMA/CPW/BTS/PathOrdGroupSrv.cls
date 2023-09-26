/// 名称: DHCMA.CPW.BTS.PathOrdGroupSrv
/// 描述: 临床路径医嘱分组服务类
/// 编写者：yankai
/// 编写日期: 2020-12-29
Class DHCMA.CPW.BTS.PathOrdGroupSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     yankai
/// CreatDate：   2020-12-29
/// Description:  查询临床路径阶段医嘱分组方案
/// Table：       DHCMA.CPW.BT.PathOrdGroup
/// Input：       
/// output: 
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathOrdGroupSrv","QryPathOrdGroup","17||1")
Query QryPathOrdGroup(aFormEpID As %String) As %Query(ROWSPEC = "ID:%String,FormEpID:%String,OrdGroupDesc:%String,OrdGroupNote:%String")
{
}

ClassMethod QryPathOrdGroupExecute(ByRef qHandle As %Binary, aFormEpID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set LangID= 20,Languages= "CH",aHospID=""
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
		Set aHospID = $g(%session.Data("'LOGON.HOSPID'"))
	}
	
	Quit:aFormEpID="" $$$OK	
 	Set xID = ""
 	For {
	 	Set xID = $o(^DHCMA.CPW.BT.PathOrdGroupI("IdxofFormEpDr",aFormEpID,xID))
	 	Quit:xID=""
	 	Set obj = ##class(DHCMA.CPW.BT.PathOrdGroup).GetObjById(xID)
	 	Continue:'$IsObject(obj)

	 	Continue:'$Isobject(obj.CPFormEpDr)
	 	Set OrdGroupDesc =obj.CPOrdGroupDesc
	 	Set:OrdGroupDesc'="" OrdGroupDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormEp","CPOrdGroupDesc",OrdGroupDesc,LangID)
	 	Set OrdGroupNote = obj.CPOrdGroupNote
	 	Set:OrdGroupNote'="" OrdGroupNote=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormEp","CPOrdGroupNote",OrdGroupNote,LangID)
	 	Set Data=$lb(xID,aFormEpID,OrdGroupDesc,OrdGroupNote)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	
	Quit $$$OK
}

ClassMethod QryPathOrdGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathOrdGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathOrdGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathOrdGroupExecute ]
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

/// Creator：     yankai
/// CreatDate：   2020-12-29
/// Description:  拆分医嘱组服务类
/// Table：       DHCMA.CPW.BT.PathOrdGroup
/// Input：       
/// output: 
/// w ##class(DHCMA.CPW.BTS.PathOrdGroupSrv).SplitOrdGroupSrv()
/// w ##class(DHCMA.CPW.BTS.PathOrdGroupSrv).SplitOrdGroupSrv("0^17||1||7||3"_$c(1)_"0^FJ:16:17||1||7||1"_$c(1)_"0^FJ:17:17||1||8||17"_$c(1)_"0^17||1||9||2"_$c(1)_"0^17||1||9||3"_$c(1)_"0^17||1||9||4"_$c(1)_"0^17||1||12||1"_$c(1)_"0^17||1||13||2"_$c(1)_"0^17||1||17||5"_$c(1)_"1^17||1||18||1"_$c(1)_"0^17||1||22||6"_$c(1)_"0^17||1||22||7"_$c(1)_"0^17||1||22||8"_$c(1)_"0^17||1||23||2"_$c(1)_"0^FJ:16:17||1||23||14","1","方案1","测试数据1","17||1")
ClassMethod SplitOrdGroupSrv(aOrdsOrTCMInfo As %String, aGroupID As %String, aGroupName As %String, aGroupNote As %String, aFormEpID As %String) As %String
{
	New (aOrdsOrTCMInfo,aGroupID,aGroupName , aGroupNote, aFormEpID)
	Set return=""
	//Set ^TEMPYK("SplitOrdGroupSrv")=$lb(aOrdsOrTCMInfo, aGroupID, aGroupName , aGroupNote, aFormEpID)
	Quit:(aOrdsOrTCMInfo="")||(aGroupName="")||(aFormEpID="") return
	
	Set $ZT="SplitOrdGroupSrvErr"
	TStart
	
	//更新质控
	Set inputStr=aGroupID_"^"_aGroupName_"^"_aGroupNote_"^"_aFormEpID
	Set flg=##class(DHCMA.CPW.BT.PathOrdGroup).Update(inputStr,"^")
	If +flg<0{
		TRollBack
		Set return="-1^更新医嘱分组错误"
		Quit return	
	}Else{
		Set return = flg	
	}
	
	Set aGroupID=flg
	For index=1:1:$l(aOrdsOrTCMInfo,$c(1)){
		Set xOrdInfo=$p(aOrdsOrTCMInfo,$c(1),index)
		Continue:xOrdInfo=""
		Set isChecked=$p(xOrdInfo,"^",1)
		Set xID=$p(xOrdInfo,"^",2)
		If xID'["FJ"{			//普通医嘱
			Set ret=##class(DHCMA.CPW.BT.PathFormOrd).UpdateOrdGroup(xID,aGroupID,isChecked)
			If +ret<0{
				TRollBack
				Set return="-2^"_xID
				Quit
			}
		}Else{
			Set TcmID=$p(xID,":",3)
			Set ret=##class(DHCMA.CPW.BT.PathFormTCM).UpdateTCMGroup(TcmID,aGroupID,isChecked)
			If +ret<0{
				TRollBack
				Set return="-2^"_xID
				Quit	
			}	
		}
	}
	Quit:+return<0 return
	
	If $TLevel>0 TCommit
	Quit return
	
SplitOrdGroupSrvErr
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     yankai
/// CreatDate：   2020-12-29
/// Description:  删除医嘱分组服务类，同步删除所有依赖该分组的医嘱及方剂的该组信息
/// Table：       DHCMA.CPW.BT.PathOrdGroup
/// Input：       
/// output: 
/// w ##class(DHCMA.CPW.BTS.PathOrdGroupSrv).DeleteOrdGroupSrv()
ClassMethod DeleteOrdGroupSrv(aGroupID As %String, aOrdsInfo As %String) As %String
{
	New (aGroupID,aOrdsInfo)
	Set return=""
	Quit:(aGroupID="")||(aOrdsInfo="") return
	
	Set $ZT="DeleteOrdGroupSrvErr"
	TStart
	
	Set ret=##class(DHCMA.CPW.BT.PathOrdGroup).DeleteById(aGroupID)
	If ret<0{
		TRollBack
		Set return="-1^删除医嘱分组错误！"
		Quit return		
	}
	
	For index=1:1:$l(aOrdsInfo,$c(1)){
		Set xOrdInfo=$p(aOrdsInfo,$c(1),index)
		Continue:xOrdInfo=""
		Set isChecked=$p(xOrdInfo,"^",1)
		Set xID=$p(xOrdInfo,"^",2)
		If xID'["FJ"{			//普通医嘱
			Set ret=##class(DHCMA.CPW.BT.PathFormOrd).UpdateOrdGroup(xID,aGroupID,isChecked)
			If +ret<0{
				TRollBack
				Set return="-2^"_xID
				Quit	
			}
		}Else{
			Set TcmID=$p(xID,":",3)
			Set ret=##class(DHCMA.CPW.BT.PathFormTCM).UpdateTCMGroup(TcmID,aGroupID,isChecked)
			If +ret<0{
				TRollBack
				Set return="-2^"_xID
				Quit	
			}	
		}
	}
	Quit:+return<0 return
	
	If $TLevel>0 TCommit	
	Set return =1
	Quit return
	
DeleteOrdGroupSrvErr
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     yankai
/// CreatDate：   2021-01-18
/// Description:  检查同阶段下分组名称是否存在
/// Table：       DHCMA.CPW.BT.PathOrdGroup
/// Input：       
/// output: 
/// w ##class(DHCMA.CPW.BTS.PathOrdGroupSrv).CheckNameIsExist("17||1","方案1")
ClassMethod CheckNameIsExist(aFormEpDr As %String, aGroupName As %String, aGroupID As %String = "") As %String
{
	New (aFormEpDr,aGroupName,aGroupID)
	Set return=0
	Quit:(aFormEpDr="")||(aGroupName="") return
	
	Set xID=""
	For {
		Set xID=$o(^DHCMA.CPW.BT.PathOrdGroupI("IdxofFormEpDr",aFormEpDr,xID))
		Quit:return=1
		Quit:xID=""
		
		Set obj=##class(DHCMA.CPW.BT.PathOrdGroup).GetObjById(xID)
		Continue:'$IsObject(obj)
		If aGroupID=""{
			Set:$tr(obj.CPOrdGroupDesc," ")=$tr(aGroupName," ") return=1
		}Else{
			Set:($tr(obj.CPOrdGroupDesc," ")=$tr(aGroupName," "))&&(aGroupID'=xID) return=1
		}
	}
	
	Quit return
}

}
