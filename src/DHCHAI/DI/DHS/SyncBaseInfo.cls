/// 名称: DHCHAI.DI.DHS.SyncBaseInfo
/// 描述: 同步数据池基础字典服务
/// 编写者：zhufei
/// 编写日期: 2017-12-26
Class DHCHAI.DI.DHS.SyncBaseInfo Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCHAI.DI.DHS.SyncBaseInfo).Test()
ClassMethod Test()
{
	New
	w "护理项目："
	w ##class(DHCHAI.DI.DHS.SyncBaseInfo).SyncNisItemDic("NIS01")
	w !,"检验-标本："
	w ##class(DHCHAI.DI.DHS.SyncBaseInfo).SyncLisSpecDic("LIS01")
	w !,"检验-抗生素："
	w ##class(DHCHAI.DI.DHS.SyncBaseInfo).SyncLisAntiDic("LIS01")
	w !,"检验-菌："
	w ##class(DHCHAI.DI.DHS.SyncBaseInfo).SyncLisBactDic("LIS01")
	w !,"检验-项目："
	w ##class(DHCHAI.DI.DHS.SyncBaseInfo).SyncLisTestCodeDic("LIS01")
	w !,"检验-医嘱："
	w ##class(DHCHAI.DI.DHS.SyncBaseInfo).SyncLisTestSetDic("LIS01")
	w !,"医嘱-抗生素+处置治疗："
	w ##class(DHCHAI.DI.DHS.SyncBaseInfo).SyncHisArcimDic("HIS01")
	w !,"医嘱-检查项目："
	w ##class(DHCHAI.DI.DHS.SyncBaseInfo).SyncRisArcimDic("RIS01")
	w !,"医嘱-给药途径、剂量单位、频次："
	w ##class(DHCHAI.DI.DHS.SyncBaseInfo).SyncHisOrderItemDic("HIS01")
	Quit "OK"
}

/// Creator：     pylian
/// CreatDate：   2021-09-09
/// Description:  同步医嘱给药途径、剂量单位、频次(包括药品及材料等)
/// Input：       无
/// Return：      处理数
/// w ##class(DHCHAI.DI.DHS.SyncBaseInfo).SyncHisOrderItemDic("HIS01")
ClassMethod SyncHisOrderItemDic(aSCode As %String) As %String
{
	New (aSCode)
	Set return=0,Count=0
	Quit:aSCode="" return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="HIS" return  //医嘱管理系统
	
    Set xInstrucID=""
    For {
	    Set xInstrucID=$o(^PHCIN(xInstrucID))
	    Quit:xInstrucID=""
	    Set Instruc=$p($g(^PHCIN(+xInstrucID)),"^",2)				//给药途径（用法）
		If Instruc'="" {
			Set InputStr=""
			Set $p(InputStr,"^",1)="AntiAdminRoute"  // 抗菌药物给药途径
			Set $p(InputStr,"^",2)=Instruc
			Set $p(InputStr,"^",3)=Instruc
			Set flg=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
			If (+flg)<1 {
				w "同步医嘱给药途径、剂量单位、频次字典错误,Err="_flg_";Input="_InputStr,!
				Continue
			}
			Set Count=Count+1 //计数
		}
    }
    Set xQtyUomID=""
    For {
	    Set xQtyUomID=$o(^CT("UOM",xQtyUomID))
	    Quit:xQtyUomID=""
	    Set DoseQtyUom=$p($g(^CT("UOM",+xQtyUomID)),"^",2)				//剂量单位
	    
	   	If DoseQtyUom'="" {
			Set InputStr=""
			Set $p(InputStr,"^",1)="OEDoseUnit"  // 医嘱剂量单位
			Set $p(InputStr,"^",2)=DoseQtyUom
			Set $p(InputStr,"^",3)=DoseQtyUom
			Set flg=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
			If (+flg)<1 {
				w "同步医嘱给药途径、剂量单位、频次字典错误,Err="_flg_";Input="_InputStr,!
				Continue
			}
			Set Count=Count+1 //计数
		}
    }
    Set xFreqID=""
    For {
	    Set xFreqID=$o(^PHCFR(xFreqID))
	    Quit:xFreqID=""
	    Set PhcFreq=$p($g(^PHCFR(+xFreqID)),"^",2)				 // 频次
	    If PhcFreq'="" {
			Set InputStr=""
			Set $p(InputStr,"^",1)="OEPhcFreq"  // 频次
			Set $p(InputStr,"^",2)=PhcFreq
			Set $p(InputStr,"^",3)=PhcFreq
			Set flg=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
			If (+flg)<1 {
				w "同步医嘱给药途径、剂量单位、频次字典错误,Err="_flg_";Input="_InputStr,!
				Continue
			}
			Set Count=Count+1 	//计数
		}
    } 
	
    Set return=Count
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-12-26
/// Description:  同步护理管理项目字典
/// Input：       无
/// Return：      处理数
/// w ##class(DHCHAI.DI.DHS.SyncBaseInfo).SyncNisItemDic("NIS01")
ClassMethod SyncNisItemDic(aSCode As %String) As %String
{
	New (aSCode)
	Set return=0,Count=0
	Quit:aSCode="" return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="NIS" return  //护理管理系统
	
	Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromNisSrv:GetObsItemDic")
  	Set sc=rs.Execute()
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
    While (rs.Next()){
	    
	    Do rowData.Clear()  //清空数组
	    Do rowData.SetAt(rs.Data("ID"),"ID")               // ID
		Do rowData.SetAt(rs.Data("Code"),"Code")           // 代码
		Do rowData.SetAt(rs.Data("Desc"),"Desc")           // 描述
		Do rowData.SetAt(rs.Data("IsActive"),"IsActive")   // 是否有效
		
		//检查项目是否有效
		Set ItemDesc=rowData.GetAt("Desc")
		Set IsActive=rowData.GetAt("IsActive")
		Set (ID,MapItemDr,MapNote,SCode,ActDate,ActTime,ActUser)=""
		Set objItemMap=##class(DHCHAI.DP.MROBSItemMap).GetObjByItemDesc(aSCode,ItemDesc)
		If $IsObject(objItemMap) {
			Set ID=objItemMap.%Id()
			If $IsObject(objItemMap.BTMapItemDr) {
				Set MapItemDr=objItemMap.BTMapItemDr.%Id()
			}
			Set MapNote=objItemMap.BTMapNote
			Set SCode=objItemMap.BTSCode
			Set ActDate=objItemMap.BTActDate
			Set ActTime=objItemMap.BTActTime
			Set ActUser=objItemMap.BTActUser
			Set:objItemMap.BTIsActive=0 IsActive=0  //院感可手动设置成无效
		} Else {
			Set SCode=aSCode
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=$g(ID)
		Set $p(InputStr,"^",2)=$g(ItemDesc)
		Set $p(InputStr,"^",3)=$g(MapItemDr)
		Set $p(InputStr,"^",4)=$g(MapNote)
		Set $p(InputStr,"^",5)=$g(SCode)
		Set $p(InputStr,"^",6)=+$g(IsActive)
		Set $p(InputStr,"^",7)=$g(ActDate)
		Set $p(InputStr,"^",8)=$g(ActTime)
		Set $p(InputStr,"^",9)=$g(ActUser)
		Set flg=##class(DHCHAI.DP.MROBSItemMap).Update(InputStr,"^")
		If (+flg)<1 {
			w "同步护理管理项目字典错误,Err="_flg_";Input="_InputStr,!
			Continue
		}
		
		//计数
		Set Count=Count+1
    }
    
    Set return=Count
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-12-26
/// Description:  同步检验2.0抗生素字典
/// Input：       无
/// Return：      处理数
/// w ##class(DHCHAI.DI.DHS.SyncBaseInfo).SyncLisAntiDic("LIS01")
ClassMethod SyncLisAntiDic(aSCode As %String) As %String
{
	New (aSCode)
	Set return=0,Count=0
	Quit:aSCode="" return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="LIS" return  //检验系统
	
	Set LabReportVer=##class(DHCHAI.BT.Config).GetValByCode("DPLabReportVer")
	If LabReportVer="LIS1.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLis10Srv:GetLisAntiDic")
	} ElseIf LabReportVer="LIS2.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLisSrv:GetLisAntiDic")
	} ElseIf LabReportVer="LISC1.0" {
		//无接口
		Quit return
	} ElseIf LabReportVer="LISC2.0" {
		//无接口
		Quit return
	} Else {
		Quit return
	}
  	Set sc=rs.Execute()
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
    While (rs.Next()){
	    
	    Do rowData.Clear()  //清空数组
	    Do rowData.SetAt(rs.Data("ID"),"ID")               // ID
		Do rowData.SetAt(rs.Data("Code"),"Code")           // 代码
		Do rowData.SetAt(rs.Data("Desc"),"Desc")           // 描述
		Do rowData.SetAt(rs.Data("IsActive"),"IsActive")   // 是否有效
		
		//检查项目是否有效
		Set ItemDesc=rowData.GetAt("Desc")
		Set IsActive=rowData.GetAt("IsActive")
		Set (ID,MapItemDr,MapNote,SCode,ActDate,ActTime,ActUser)=""
		Set objItemMap=##class(DHCHAI.DP.LabAntiMap).GetObjByAntDesc(aSCode,ItemDesc)
		If $IsObject(objItemMap) {
			Set ID=objItemMap.%Id()
			If $IsObject(objItemMap.BTMapItemDr) {
				Set MapItemDr=objItemMap.BTMapItemDr.%Id()
			}
			Set MapNote=objItemMap.BTMapNote
			Set SCode=objItemMap.BTSCode
			Set ActDate=objItemMap.BTActDate
			Set ActTime=objItemMap.BTActTime
			Set ActUser=objItemMap.BTActUser
			Set:objItemMap.BTIsActive=0 IsActive=0  //院感可手动设置成无效
		} Else {
			Set SCode=aSCode
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=$g(ID)
		Set $p(InputStr,"^",2)=$g(ItemDesc)
		Set $p(InputStr,"^",3)=$g(MapItemDr)
		Set $p(InputStr,"^",4)=$g(MapNote)
		Set $p(InputStr,"^",5)=$g(SCode)
		Set $p(InputStr,"^",6)=$g(IsActive)
		Set $p(InputStr,"^",7)=$g(ActDate)
		Set $p(InputStr,"^",8)=$g(ActTime)
		Set $p(InputStr,"^",9)=$g(ActUser)
		Set flg=##class(DHCHAI.DP.LabAntiMap).Update(InputStr,"^")
		If (+flg)<1 {
			w "同步检验抗生素字典错误,Err="_flg_";Input="_InputStr,!
			Continue
		}
		
		//计数
		Set Count=Count+1
    }
    
    Set return=Count
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-12-26
/// Description:  同步检验2.0细菌字典
/// Input：       无
/// Return：      处理数
/// w ##class(DHCHAI.DI.DHS.SyncBaseInfo).SyncLisBactDic("LISC02")
ClassMethod SyncLisBactDic(aSCode As %String) As %String
{
	New (aSCode)
	Set return=0,Count=0
	Quit:aSCode="" return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="LIS" return  //检验系统
	
	Set LabReportVer=##class(DHCHAI.BT.Config).GetValByCode("DPLabReportVer")
	If LabReportVer="LIS1.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLis10Srv:GetLisBactDic")
	} ElseIf LabReportVer="LIS2.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLisSrv:GetLisBactDic")
	} ElseIf LabReportVer="LISC1.0" {
		//无接口
		Quit return
	} ElseIf LabReportVer="LISC2.0" {
		//无接口
		Quit return
	} Else {
		Quit return
	}
  	Set sc=rs.Execute()
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
    While (rs.Next()){
	    
	    Do rowData.Clear()  //清空数组
	    Do rowData.SetAt(rs.Data("ID"),"ID")               // ID
		Do rowData.SetAt(rs.Data("Code"),"Code")           // 代码
		Do rowData.SetAt(rs.Data("Desc"),"Desc")           // 描述
		Do rowData.SetAt(rs.Data("IsActive"),"IsActive")   // 是否有效
		
		//检查项目是否有效
		Set ItemDesc=rowData.GetAt("Desc")
		Set IsActive=rowData.GetAt("IsActive")
		Set (ID,MapItemDr,MapNote,SCode,ActDate,ActTime,ActUser)=""
		Set objItemMap=##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(aSCode,ItemDesc)
		If $IsObject(objItemMap) {
			Set ID=objItemMap.%Id()
			If $IsObject(objItemMap.BTMapItemDr) {
				Set MapItemDr=objItemMap.BTMapItemDr.%Id()
			}
			Set MapNote=objItemMap.BTMapNote
			Set SCode=objItemMap.BTSCode
			Set ActDate=objItemMap.BTActDate
			Set ActTime=objItemMap.BTActTime
			Set ActUser=objItemMap.BTActUser
			Set:objItemMap.BTIsActive=0 IsActive=0  //院感可手动设置成无效
		} Else {
			Set SCode=aSCode
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=$g(ID)
		Set $p(InputStr,"^",2)=$g(ItemDesc)
		Set $p(InputStr,"^",3)=$g(MapItemDr)
		Set $p(InputStr,"^",4)=$g(MapNote)
		Set $p(InputStr,"^",5)=$g(SCode)
		Set $p(InputStr,"^",6)=$g(IsActive)
		Set $p(InputStr,"^",7)=$g(ActDate)
		Set $p(InputStr,"^",8)=$g(ActTime)
		Set $p(InputStr,"^",9)=$g(ActUser)
		Set flg=##class(DHCHAI.DP.LabBactMap).Update(InputStr,"^")
		If (+flg)<1 {
			w "同步检验细菌字典错误,Err="_flg_";Input="_InputStr,!
			Continue
		}
		
		//计数
		Set Count=Count+1
    }
    
    Set return=Count
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-12-26
/// Description:  同步检验2.0标本字典
/// Input：       无
/// Return：      处理数
/// w ##class(DHCHAI.DI.DHS.SyncBaseInfo).SyncLisSpecDic("LIS01")
ClassMethod SyncLisSpecDic(aSCode As %String) As %String
{
	New (aSCode)
	Set return=0,Count=0
	Quit:aSCode="" return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="LIS" return  //检验系统
	
	Set LabReportVer=##class(DHCHAI.BT.Config).GetValByCode("DPLabReportVer")
	If LabReportVer="LIS1.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLis10Srv:GetLisSpecDic")
	} ElseIf LabReportVer="LIS2.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLisSrv:GetLisSpecDic")
	} ElseIf LabReportVer="LISC1.0" {
		//无接口
		Quit return
	} ElseIf LabReportVer="LISC2.0" {
		//无接口
		Quit return
	} Else {
		Quit return
	}
  	Set sc=rs.Execute()
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
    While (rs.Next()){
	    
	    Do rowData.Clear()  //清空数组
	    Do rowData.SetAt(rs.Data("ID"),"ID")               // ID
		Do rowData.SetAt(rs.Data("Code"),"Code")           // 代码
		Do rowData.SetAt(rs.Data("Desc"),"Desc")           // 描述
		Do rowData.SetAt(rs.Data("IsActive"),"IsActive")   // 是否有效
		
		//检查项目是否有效
		Set ItemDesc=rowData.GetAt("Desc")
		Set IsActive=rowData.GetAt("IsActive")
		Set (ID,MapItemDr,MapNote,SCode,ActDate,ActTime,ActUser)=""
		Set objItemMap=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(aSCode,ItemDesc)
		If $IsObject(objItemMap) {
			Set ID=objItemMap.%Id()
			If $IsObject(objItemMap.BTMapItemDr) {
				Set MapItemDr=objItemMap.BTMapItemDr.%Id()
			}
			Set MapNote=objItemMap.BTMapNote
			Set SCode=objItemMap.BTSCode
			Set ActDate=objItemMap.BTActDate
			Set ActTime=objItemMap.BTActTime
			Set ActUser=objItemMap.BTActUser
			Set:objItemMap.BTIsActive=0 IsActive=0  //院感可手动设置成无效
		} Else {
			Set SCode=aSCode
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=$g(ID)
		Set $p(InputStr,"^",2)=$g(ItemDesc)
		Set $p(InputStr,"^",3)=$g(MapItemDr)
		Set $p(InputStr,"^",4)=$g(MapNote)
		Set $p(InputStr,"^",5)=$g(SCode)
		Set $p(InputStr,"^",6)=$g(IsActive)
		Set $p(InputStr,"^",7)=$g(ActDate)
		Set $p(InputStr,"^",8)=$g(ActTime)
		Set $p(InputStr,"^",9)=$g(ActUser)
		Set flg=##class(DHCHAI.DP.LabSpecMap).Update(InputStr,"^")
		If (+flg)<1 {
			w "同步检验标本字典错误,Err="_flg_";Input="_InputStr,!
			Continue
		}
		
		//计数
		Set Count=Count+1
    }
    
    Set return=Count
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-12-26
/// Description:  同步检验2.0检验医嘱（组套）字典
/// Input：       无
/// Return：      处理数
/// w ##class(DHCHAI.DI.DHS.SyncBaseInfo).SyncLisTestSetDic("LIS01")
ClassMethod SyncLisTestSetDic(aSCode As %String) As %String
{
	New (aSCode)
	Set return=0,Count=0
	Quit:aSCode="" return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="LIS" return  //检验系统
	
	Set LabReportVer=##class(DHCHAI.BT.Config).GetValByCode("DPLabReportVer")
	If LabReportVer="LIS1.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLis10Srv:GetLisTestSetDic")
	} ElseIf LabReportVer="LIS2.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLisSrv:GetLisTestSetDic")
	} ElseIf LabReportVer="LISC1.0" {
		//无接口
		Quit return
	} ElseIf LabReportVer="LISC2.0" {
		//无接口
		Quit return
	} Else {
		Quit return
	}
  	Set sc=rs.Execute()
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
    While (rs.Next()){
	    
	    Do rowData.Clear()  //清空数组
	    Do rowData.SetAt(rs.Data("ID"),"ID")               // ID
		Do rowData.SetAt(rs.Data("Code"),"Code")           // 代码
		Do rowData.SetAt(rs.Data("Desc"),"Desc")           // 描述
		Do rowData.SetAt(rs.Data("IsActive"),"IsActive")   // 是否有效
		Do rowData.SetAt(rs.Data("TSHISCode"),"TSHISCode") // HIS关联码
		Do rowData.SetAt(rs.Data("ArcimCode"),"ArcimCode") // 医嘱代码
		Do rowData.SetAt(rs.Data("ArcimDesc"),"ArcimDesc") // 医嘱名称
		
		//检查项目是否有效
		Set ItemDesc=rowData.GetAt("Desc")
		Continue:ItemDesc=""
		Set ItemDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(ItemDesc)  //去掉特殊字符
		Continue:ItemDesc=""
		Set ArcimDesc=rowData.GetAt("ArcimDesc")
		//Continue:ArcimDesc=""
		Set IsActive=rowData.GetAt("IsActive")
		Set (ID,MapItemDr,MapNote,SCode,ActDate,ActTime,ActUser)=""
		Set objItemMap=##class(DHCHAI.DP.LabTestSetMap).GetObjByTestSet(aSCode,ItemDesc)
		If $IsObject(objItemMap) {
			Set ID=objItemMap.%Id()
			If $IsObject(objItemMap.BTMapItemDr) {
				Set MapItemDr=objItemMap.BTMapItemDr.%Id()
			}
			Set MapNote=objItemMap.BTMapNote
			Set SCode=objItemMap.BTSCode
			Set ActDate=objItemMap.BTActDate
			Set ActTime=objItemMap.BTActTime
			Set ActUser=objItemMap.BTActUser
			Set:objItemMap.BTIsActive=0 IsActive=0  //院感可手动设置成无效
		} Else {
			Set SCode=aSCode
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=$g(ID)
		Set $p(InputStr,"^",2)=$g(ItemDesc)
		Set $p(InputStr,"^",3)=$g(ArcimDesc)
		Set $p(InputStr,"^",4)=$g(MapItemDr)
		Set $p(InputStr,"^",5)=$g(MapNote)
		Set $p(InputStr,"^",6)=$g(SCode)
		Set $p(InputStr,"^",7)=$g(IsActive)
		Set $p(InputStr,"^",8)=$g(ActDate)
		Set $p(InputStr,"^",9)=$g(ActTime)
		Set $p(InputStr,"^",10)=$g(ActUser)
		Set flg=##class(DHCHAI.DP.LabTestSetMap).Update(InputStr,"^")
		If (+flg)<1 {
			w "同步检验检验医嘱（组套）字典错误,Err="_flg_";Input="_InputStr,!
			Continue
		}
		
		//计数
		Set Count=Count+1
    }
    
    Set return=Count
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-12-26
/// Description:  同步检验2.0检验项目字典
/// Input：       无
/// Return：      处理数
/// w ##class(DHCHAI.DI.DHS.SyncBaseInfo).SyncLisTestCodeDic("LIS01")
ClassMethod SyncLisTestCodeDic(aSCode As %String) As %String
{
	New (aSCode)
	Set return=0,Count=0
	Quit:aSCode="" return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="LIS" return  //检验系统
	
	Set LabReportVer=##class(DHCHAI.BT.Config).GetValByCode("DPLabReportVer")
	If LabReportVer="LIS1.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLis10Srv:GetLisTestCodeDic")
	} ElseIf LabReportVer="LIS2.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLisSrv:GetLisTestCodeDic")
	} ElseIf LabReportVer="LISC1.0" {
		//无接口
		Quit return
	} ElseIf LabReportVer="LISC2.0" {
		//无接口
		Quit return
	} Else {
		Quit return
	}
  	Set sc=rs.Execute()
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
    While (rs.Next()){
	    
	    Do rowData.Clear()  //清空数组
	    Do rowData.SetAt(rs.Data("ID"),"ID")               // ID
		Do rowData.SetAt(rs.Data("Code"),"Code")           // 代码
		Do rowData.SetAt(rs.Data("Desc"),"Desc")           // 描述
		Do rowData.SetAt(rs.Data("RstFormat"),"RstFormat") // 结果类型
		Do rowData.SetAt(rs.Data("IsActive"),"IsActive")   // 是否有效
		Do rowData.SetAt(rs.Data("TSDescStr"),"TSDescStr") // 检验医嘱（多值!!分割）
		
		//检查项目是否有效
		Set ItemCode=rowData.GetAt("Code")
		Set ItemDesc=rowData.GetAt("Desc")
		Set RstFormat=rowData.GetAt("RstFormat")
		Set IsActive=rowData.GetAt("IsActive")
		Set (ID,AbFlagS,SCode,ActDate,ActTime,ActUser)=""
		Set objItemMap=##class(DHCHAI.DP.LabTCMap).GetObjByTestCode(aSCode,ItemCode)
		If $IsObject(objItemMap) {
			Set ID=objItemMap.%Id()
			Set RstFormat=objItemMap.BTRstFormat
			Set AbFlagS=objItemMap.BTAbFlagS
			Set SCode=objItemMap.BTSCode
			Set ActDate=objItemMap.BTActDate
			Set ActTime=objItemMap.BTActTime
			Set ActUser=objItemMap.BTActUser
			Set:objItemMap.BTIsActive=0 IsActive=0  //院感可手动设置成无效
		} Else {
			Set SCode=aSCode
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=$g(ID)
		Set $p(InputStr,"^",2)=$g(ItemCode)
		Set $p(InputStr,"^",3)=$g(ItemDesc)
		Set $p(InputStr,"^",4)=$g(RstFormat)
		Set $p(InputStr,"^",5)=$g(AbFlagS)
		Set $p(InputStr,"^",6)=$g(SCode)
		Set $p(InputStr,"^",7)=$g(IsActive)
		Set $p(InputStr,"^",8)=$g(ActDate)
		Set $p(InputStr,"^",9)=$g(ActTime)
		Set $p(InputStr,"^",10)=$g(ActUser)
		Set flg=##class(DHCHAI.DP.LabTCMap).Update(InputStr,"^")
		If (+flg)<1 {
			w "同步检验项目字典错误,Err="_flg_";Input="_InputStr,!
			Continue
		}
		Set TCMapID=+flg
		
		Set TSDescStr=rowData.GetAt("TSDescStr")
		For indTS=1:1:$l(TSDescStr,"!!") {
			Set TSDesc=$p(TSDescStr,"!!",indTS)
			Continue:TSDesc=""
			Set TSDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TSDesc)  //去掉特殊字符
			Continue:TSDesc=""
			Set objTSMap=##class(DHCHAI.DP.LabTestSetMap).GetObjByTestSet(aSCode,TSDesc)
			Continue:'$IsObject(objTSMap)
			Set TSMapID=objTSMap.%Id()
			Set objTCMapTS=##class(DHCHAI.DP.LabTCMapTS).GetObjByTSMapDr(TCMapID,TSMapID)
			Continue:$IsObject(objTCMapTS)
			Set InputStr=""_"^"_TCMapID_"^"_TSMapID
			Set flg=##class(DHCHAI.DP.LabTCMapTS).Update(InputStr)
			If (+flg)<1 {
				w "同步检验项目字典关联组套错误,Err="_flg_";Input="_InputStr,!
				Continue
			}
		}
		
		//计数
		Set Count=Count+1
    }
    
    Set return=Count
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-12-26
/// Description:  同步医嘱相关字典
/// Input：       无
/// Return：      处理数
/// w ##class(DHCHAI.DI.DHS.SyncBaseInfo).SyncHisArcimDic("HIS01")
ClassMethod SyncHisArcimDic(aSCode As %String) As %String
{
	New (aSCode)
	Set return=0,Count=0
	Quit:aSCode="" return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="HIS" return  //HIS系统
	
	Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromHisSrv:GetArcimDic")
  	Set sc=rs.Execute()
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
    While (rs.Next()){
	    
	    Do rowData.Clear()  //清空数组
	    Do rowData.SetAt(rs.Data("ArcimID"),"ArcimID")                 // 医嘱ID
	    Do rowData.SetAt(rs.Data("ArcimCode"),"ArcimCode")             // 医嘱代码
	    Do rowData.SetAt(rs.Data("ArcimDesc"),"ArcimDesc")             // 医嘱名称
	    Do rowData.SetAt(rs.Data("ArcOrdType"),"ArcOrdType")           // 医嘱类型（R、L）
	    Do rowData.SetAt(rs.Data("ArcCatDesc"),"ArcCatDesc")           // 医嘱大类
	    Do rowData.SetAt(rs.Data("ArcSubCatDesc"),"ArcSubCatDesc")     // 医嘱子类
	    Do rowData.SetAt(rs.Data("PHCCatDesc"),"PHCCatDesc")           // 药学大类
	    Do rowData.SetAt(rs.Data("PHCSubCatDesc"),"PHCSubCatDesc")     // 药学子类
	    Do rowData.SetAt(rs.Data("PHCPoisonDesc"),"PHCPoisonDesc")     // 限制分类
	    Do rowData.SetAt(rs.Data("AntiFlag"),"AntiFlag")               // 抗生素标志
	    Do rowData.SetAt(rs.Data("PHCGeneric"),"PHCGeneric")           // 药品通用名
	    Do rowData.SetAt(rs.Data("PHChemical"),"PHChemical")           // 药品化学名
	    Do rowData.SetAt(rs.Data("IsActive"),"IsActive")               // 是否有效
	    
		Set MapOrdCat=""
		Set ArcimCode=rowData.GetAt("ArcimCode")
		Set ArcimDesc=rowData.GetAt("ArcimDesc")
		Set ArcOrdType=rowData.GetAt("ArcOrdType")
		Set ArcCatDesc=rowData.GetAt("ArcCatDesc")
		Set ArcSubCatDesc=rowData.GetAt("ArcSubCatDesc")
		Set PHCCatDesc=rowData.GetAt("PHCCatDesc")
		Set PHCSubCatDesc=rowData.GetAt("PHCSubCatDesc")
		Set PHCPoisonDesc=rowData.GetAt("PHCPoisonDesc")
		Set AntiFlag=rowData.GetAt("AntiFlag")
		Set PHCGeneric=rowData.GetAt("PHCGeneric")
		Set PHChemical=rowData.GetAt("PHChemical")
		Set IsActive=rowData.GetAt("IsActive")
		If ArcOrdType="R" {
			If (PHCSubCatDesc'="")&(MapOrdCat="") {
				Set tDesc="药学子类."_PHCSubCatDesc
				Set MapOrdCat=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"ARCOrdCat",tDesc)
			}
			If (PHCCatDesc'="")&(MapOrdCat="") {
				Set tDesc="药学大类."_PHCCatDesc
				Set MapOrdCat=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"ARCOrdCat",tDesc)
			}
			If (PHCPoisonDesc'="")&(MapOrdCat="") {
				Set tDesc="管制分类."_PHCPoisonDesc
				Set MapOrdCat=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"ARCOrdCat",tDesc)
			}
			If (AntiFlag'="")&(MapOrdCat="") {
				Set tDesc="抗生素标志."_AntiFlag
				Set MapOrdCat=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"ARCOrdCat",tDesc)
			}
		} Else {
			If (ArcimDesc'="")&(MapOrdCat="") {
				Set tDesc="医嘱名."_ArcimDesc
				Set MapOrdCat=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"ARCOrdCat",tDesc)
			}
			If (ArcSubCatDesc'="")&(MapOrdCat="") {
				Set tDesc="医嘱子类."_ArcSubCatDesc
				Set MapOrdCat=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"ARCOrdCat",tDesc)
			}
			If (ArcCatDesc'="")&(MapOrdCat="") {
				Set tDesc="医嘱大类."_ArcCatDesc
				Set MapOrdCat=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"ARCOrdCat",tDesc)
			}
		}
		Continue:(MapOrdCat'="DRT")&(MapOrdCat'="ANT")&(MapOrdCat'="ISO")&(MapOrdCat'="COD")  //DRT器械相关治疗、ANT抗菌药物、ISO隔离类医嘱、COD会诊医嘱
		
		//根据医嘱项判断是否同步
		Set AntUseFlag=0
		If MapOrdCat="ANT" {
			Set AntUseFlag=1
			Set (ID,MapItemDr,MapNote,SCode,ActDate,ActTime,ActUser)=""
			Set objItemMap=##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc(aSCode,ArcimDesc)
			If $IsObject(objItemMap){
				Set ID=objItemMap.%Id()
				If $IsObject(objItemMap.BTMapItemDr) {
					Set MapItemDr=objItemMap.BTMapItemDr.%Id()
				}
				Set MapNote=objItemMap.BTMapNote
				Set SCode=objItemMap.BTSCode
				Set ActDate=objItemMap.BTActDate
				Set ActTime=objItemMap.BTActTime
				Set ActUser=objItemMap.BTActUser
				Set:objItemMap.BTIsActive=0 IsActive=0  //院感可手动设置成无效
			} Else {
				Set SCode=aSCode
			}
			Set InputStr = $g(ID)
			Set InputStr = InputStr_"^"_$g(ArcimDesc)	//医嘱名称
			Set InputStr = InputStr_"^"_$g(PHCGeneric)	//药品通用名
			Set InputStr = InputStr_"^"_$g(PHChemical)	//药品化学名
			Set InputStr = InputStr_"^"_$g(MapItemDr)	//标准名称
			Set InputStr = InputStr_"^"_$g(MapNote)		//标准备注
			Set InputStr = InputStr_"^"_SCode			//子系统代码
			Set InputStr = InputStr_"^"_IsActive		//有效标志
			Set InputStr = InputStr_"^"_$g(ActDate)		//处置日期
			Set InputStr = InputStr_"^"_$g(ActTime)		//处置时间
			Set InputStr = InputStr_"^"_$g(ActUser)		//处置人
			Set flg=##class(DHCHAI.DP.OEAntiMastMap).Update(InputStr,"^")
			If (+flg)<1 {
				w "同步抗菌用药字典错误,Err="_flg_";Input="_InputStr,!
				Continue
			}
		} Else {   //器械相关治疗等医嘱
			Set (ID,MapItemDr,MapNote,SCode,ActDate,ActTime,ActUser)=""
			Set objItemMap=##class(DHCHAI.DP.OEItmMastMap).GetObjByOrdDesc(aSCode,ArcimDesc)
			If $IsObject(objItemMap){
				Set ID=objItemMap.%Id()
				If $IsObject(objItemMap.BTMapItemDr) {
					Set MapItemDr=objItemMap.BTMapItemDr.%Id()
				}
				Set MapNote=objItemMap.BTMapNote
				Set SCode=objItemMap.BTSCode
				Set ActDate=objItemMap.BTActDate
				Set ActTime=objItemMap.BTActTime
				Set ActUser=objItemMap.BTActUser
				Set:objItemMap.BTIsActive=0 IsActive=0  //院感可手动设置成无效
			} Else {
				Set SCode=aSCode
			}
			Set InputStr = ID
			Set InputStr = InputStr_"^"_ArcimDesc		//医嘱名称
			Set InputStr = InputStr_"^"_ArcCatDesc_"."_ArcSubCatDesc //医嘱分类
			Set InputStr = InputStr_"^"_$g(MapItemDr)	//标准名称
			Set InputStr = InputStr_"^"_$g(MapNote)		//标准备注
			Set InputStr = InputStr_"^"_SCode			//子系统代码
			Set InputStr = InputStr_"^"_IsActive		//有效标志
			Set InputStr = InputStr_"^"_$g(ActDate)		//处置日期
			Set InputStr = InputStr_"^"_$g(ActTime)		//处置时间
			Set InputStr = InputStr_"^"_$g(ActUser)		//处置人
			Set flg=##class(DHCHAI.DP.OEItmMastMap).Update(InputStr,"^")
			If (+flg)<1 {
				w "同步治疗医嘱字典错误,Err="_flg_";Input="_InputStr,!
				Continue
			}
		}
		
		//计数
		Set Count=Count+1
    }
    
    Set return=Count
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-12-26
/// Description:  同步检查医嘱字典
/// Input：       无
/// Return：      处理数
/// w ##class(DHCHAI.DI.DHS.SyncBaseInfo).SyncRisArcimDic("RIS01")
ClassMethod SyncRisArcimDic(aSCode As %String) As %String
{
	New (aSCode)
	Set return=0,Count=0
	Quit:aSCode="" return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="RIS" return  //检查系统
	Set HISSCode=objSYS.BTHISCode
	
	Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromHisSrv:GetArcimDic")
  	Set sc=rs.Execute()
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
    While (rs.Next()){
	    
	    Do rowData.Clear()  //清空数组
	    Do rowData.SetAt(rs.Data("ArcimID"),"ArcimID")                 // 医嘱ID
	    Do rowData.SetAt(rs.Data("ArcimCode"),"ArcimCode")             // 医嘱代码
	    Do rowData.SetAt(rs.Data("ArcimDesc"),"ArcimDesc")             // 医嘱名称
	    Do rowData.SetAt(rs.Data("ArcOrdType"),"ArcOrdType")           // 医嘱类型（R、L）
	    Do rowData.SetAt(rs.Data("ArcCatDesc"),"ArcCatDesc")           // 医嘱大类
	    Do rowData.SetAt(rs.Data("ArcSubCatDesc"),"ArcSubCatDesc")     // 医嘱子类
	    Do rowData.SetAt(rs.Data("PHCCatDesc"),"PHCCatDesc")           // 药学大类
	    Do rowData.SetAt(rs.Data("PHCSubCatDesc"),"PHCSubCatDesc")     // 药学子类
	    Do rowData.SetAt(rs.Data("PHCPoisonDesc"),"PHCPoisonDesc")     // 限制分类
	    Do rowData.SetAt(rs.Data("AntiFlag"),"AntiFlag")               // 抗生素标志
	    Do rowData.SetAt(rs.Data("PHCGeneric"),"PHCGeneric")           // 药品通用名
	    Do rowData.SetAt(rs.Data("PHChemical"),"PHChemical")           // 药品化学名
	    Do rowData.SetAt(rs.Data("IsActive"),"IsActive")               // 是否有效
	    
		Set MapOrdCat=""
		Set ArcimCode=rowData.GetAt("ArcimCode")
		Set ArcimDesc=rowData.GetAt("ArcimDesc")
		Set ArcOrdType=rowData.GetAt("ArcOrdType")
		Set ArcCatDesc=rowData.GetAt("ArcCatDesc")
		Set ArcSubCatDesc=rowData.GetAt("ArcSubCatDesc")
		Set PHCCatDesc=rowData.GetAt("PHCCatDesc")
		Set PHCSubCatDesc=rowData.GetAt("PHCSubCatDesc")
		Set PHCPoisonDesc=rowData.GetAt("PHCPoisonDesc")
		Set AntiFlag=rowData.GetAt("AntiFlag")
		Set PHCGeneric=rowData.GetAt("PHCGeneric")
		Set PHChemical=rowData.GetAt("PHChemical")
		Set IsActive=rowData.GetAt("IsActive")
		Continue:ArcOrdType="R"
		If (ArcimDesc'="")&(MapOrdCat="") {
			Set tDesc="医嘱名."_ArcimDesc
			Set MapOrdCat=##class(DHCHAI.DP.PhraseMap).GetMapValue(HISSCode,"ARCOrdCat",tDesc)
		}
		If (ArcSubCatDesc'="")&(MapOrdCat="") {
			Set tDesc="医嘱子类."_ArcSubCatDesc
			Set MapOrdCat=##class(DHCHAI.DP.PhraseMap).GetMapValue(HISSCode,"ARCOrdCat",tDesc)
		}
		If (ArcCatDesc'="")&(MapOrdCat="") {
			Set tDesc="医嘱大类."_ArcCatDesc
			Set MapOrdCat=##class(DHCHAI.DP.PhraseMap).GetMapValue(HISSCode,"ARCOrdCat",tDesc)
		}
		Continue:(MapOrdCat'="RIS")  //检查医嘱
		
		//根据医嘱项判断是否同步
		Set (ID,MapItemDr,MapNote,SCode,ActDate,ActTime,ActUser)=""
		Set objItemMap=##class(DHCHAI.DP.RBItmMastMap).GetObjByItemDesc(aSCode,ArcimDesc)
		If $IsObject(objItemMap){
			Set ID=objItemMap.%Id()
			If $IsObject(objItemMap.BTMapItemDr) {
				Set MapItemDr=objItemMap.BTMapItemDr.%Id()
			}
			Set MapNote=objItemMap.BTMapNote
			Set SCode=objItemMap.BTSCode
			Set ActDate=objItemMap.BTActDate
			Set ActTime=objItemMap.BTActTime
			Set ActUser=objItemMap.BTActUser
			Set:objItemMap.BTIsActive=0 IsActive=0  //院感可手动设置成无效
		} Else {
			Set SCode=aSCode
		}
		Set InputStr = ID
		Set InputStr = InputStr_"^"_ArcimDesc		//医嘱名称
		Set InputStr = InputStr_"^"_$g(MapItemDr)	//标准名称
		Set InputStr = InputStr_"^"_$g(MapNote)		//标准备注
		Set InputStr = InputStr_"^"_SCode			//子系统代码
		Set InputStr = InputStr_"^"_IsActive		//有效标志
		Set InputStr = InputStr_"^"_$g(ActDate)		//处置日期
		Set InputStr = InputStr_"^"_$g(ActTime)		//处置时间
		Set InputStr = InputStr_"^"_$g(ActUser)		//处置人
		Set flg=##class(DHCHAI.DP.RBItmMastMap).Update(InputStr,"^")
		If (+flg)<1 {
			w "同步检查医嘱字典错误,Err="_flg_";Input="_InputStr,!
			Continue
		}
		
		//计数
		Set Count=Count+1
    }
    
    Set return=Count
    Quit return
}

}
