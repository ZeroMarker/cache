/// 名称: DHCMed.CCService.Sys.CommonSrv
/// 描述: DHCMed.CC.ContentDic 监控内容字典表常用方法
/// 
/// 编写者：liuyh
/// 编写日期: 2010-04-26
Class DHCMed.CCService.Sys.CommonSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-04-30
/// Description:  根据ARCIM_Desc汉字描述或其别名表的拼音首字母查询
/// Table：       ARC_ItmMast
/// Input：       ARCIMDesc:ARC_ItmMast.ARCIM_Desc汉字描述或ARC_Alias.ARC_Alias首字母别名
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.Sys.CommonSrv","QryArcimByAlias","qms")
Query QryArcimByAlias(argAlias As %String) As %Query(ROWSPEC = "ArcimID:%String,ArcimDesc:%String:描述,ARCIMCode:%String:代码,ArcimDR:%String,ARCICOrdCatDR:%String:项目大类Rowid,ORCATDesc:%String:项目大类描述,ARCIMItemCatDR:%String:项目子类Rowid,ARCICDesc:%String:项目子类描述")
{
}

ClassMethod QryArcimByAliasExecute(ByRef qHandle As %Binary, argAlias As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:argAlias="" $$$OK
	Set argAlias=$ZCVT(argAlias,"U")
 	Set ArcimID=0
 	For {
	 	Set ArcimID=$o(^ARCIM(ArcimID))
	 	Quit:ArcimID=""
	 	Set SubID=0
	 	For {
			Set SubID=$o(^ARCIM(ArcimID,SubID))
			Quit:SubID=""
			Set ARCItemID=ArcimID_"||"_SubID
			Set objArcim=##Class(DHCMed.Base.Arcim).GetObjById(ARCItemID)
			If $IsObject(objArcim){
				Set ArcimDesc=objArcim.ARCIMDesc
				Set AliasText=objArcim.ALIASText
				Set ArcimDesc=AliasText_"-"_ArcimDesc
				Continue:ArcimDesc'[argAlias			//按照别名过滤
				Set ArcimDesc=$tr(ArcimDesc,"[","")
				Set ArcimDesc=$tr(ArcimDesc,"]","")
				Set ArcimDesc=$tr(ArcimDesc,")","")
				Set ArcimDesc=$tr(ArcimDesc,")","")
				Set ArcimDesc=$tr(ArcimDesc,"|","")
				Set ArcimDesc=$tr(ArcimDesc,"||","")
				Set ARCIMCode=objArcim.ARCIMCode
				Set ARCICOrdCatDR=objArcim.ARCICOrdCatDR
				Set ORCATDesc=objArcim.ORCATDesc
				Set ARCIMItemCatDR=objArcim.ARCIMItemCatDR
				Set ARCICDesc=objArcim.ARCICDesc
				Set Data=$lb(ArcimID,ArcimDesc,ARCIMCode,ARCItemID,ARCICOrdCatDR,ORCATDesc,ARCIMItemCatDR,ARCICDesc)
 				Set ^CacheTemp(repid,ind)=Data
 				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryArcimByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryArcimByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryArcimByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryArcimByAliasExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-05-04
/// Description:  通过监控项目字典代码判断医嘱(诊断)是否已添加
/// Table：       DHCMed.CC.ItemDic
/// Input：       rowid : 医嘱(诊断)rowid str : OE()
/// Return		  1 : 已添加
/// w ##class(DHCMed.CCService.Sys.CommonSrv).IsDataAdd("1","OE")
ClassMethod IsDataAdd(argID As %String, argStr As %String) As %String
{
	New (argID,argStr)
	Set return=-1
	Quit:(argID="")||(argStr="") return
	
	Set IDDesc=argStr_argID
	If $o(^DHCMed.CCi("ItemDic",0,"IDCodeIndex"," "_IDDesc,""))'=""
	{
		Set return=$o(^DHCMed.CCi("ItemDic",0,"IDCodeIndex"," "_IDDesc,""))
	}
	
	Quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-05-06
/// Description:  获取所有检验科室
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.Sys.CommonSrv","GetDepartment","3")
Query GetDepartment(aSSHospCode As %String) As %Query(ROWSPEC = "DepNo:%String,DepName:%String")
{
}

ClassMethod GetDepartmentExecute(ByRef qHandle As %Binary, aSSHospCode As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
    
	//update by zf 20160308 数据池相关程序修改(检验)
    Set xID=""
    For {
		Set xID=$o(^DHCMed.DC.LIS.BTWorkGroupD(xID))
		Quit:xID=""
		
		Set obj=##Class(DHCMed.DC.LIS.BTWorkGroup).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.Active'=1
		Set DepCode=obj.Code
		Set DepName=obj.CName
		Set HospCode=obj.HospCode
		Continue:'$d(^DHCMed.DC.BTHospitalI("IndexSCode"," "_$zcvt(HospCode,"U")," "_$zcvt(aSSHospCode,"U"),1))
		Set Data=$lb(DepCode,DepName)
		Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
    }
    
 	Quit $$$OK
}

ClassMethod GetDepartmentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepartmentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDepartmentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepartmentExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-05-06
/// Description:  获取检验科室对应的检验项目列表
/// Input:		  DepCode : 检验科室code TCName : ""
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.Sys.CommonSrv","GetTestCode","D","","D")
Query GetTestCode(aDepCode As %String, aTCName As %String, aTestDesc As %String, aSSHospCode As %String) As %Query(ROWSPEC = "TestCode:%String,TestName:%String")
{
}

ClassMethod GetTestCodeExecute(ByRef qHandle As %Binary, aDepCode As %String, aTCName As %String, aTestDesc As %String, aSSHospCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	//update by zf 20160308 数据池相关程序修改(检验)
	Set xHospCode=""
	For {
		Set xHospCode=$o(^DHCMed.DC.LIS.BTTestCodeI("IndexCode",xHospCode))
		Quit:xHospCode=""
		Continue:'$d(^DHCMed.DC.BTHospitalI("IndexSCode",xHospCode," "_$zcvt(aSSHospCode,"U"),1))
		
		Set xCode=""
		For {
			Set xCode=$o(^DHCMed.DC.LIS.BTTestCodeI("IndexCode",xHospCode,xCode))
			Quit:xCode=""
			
			Set xID=""
			For {
				Set xID=$o(^DHCMed.DC.LIS.BTTestCodeI("IndexCode",xHospCode,xCode,xID))
				Quit:xID=""
				
				Set obj=##class(DHCMed.DC.LIS.BTTestCode).GetObjById(xID)
				Continue:'$IsObject(obj)
				Set TCCode=obj.Code
				Set TCDesc=obj.CName
				Set TCResultFormat=obj.ResultFormat
				Continue:(aTCName'="")&&(TCCode'[aTCName)&&(TCDesc'[aTCName)
				Continue:((aTestDesc'="")&&(TCDesc'[aTestDesc))
				Continue:$e(TCCode,1,$l(aDepCode))'=aDepCode
				Set TCDesc="@"_TCDesc
				
			 	Set Data=$lb(TCCode,TCDesc)
				Set ^CacheTemp(repid,ind)=Data
			 	Set ind=ind+1
			}
		}
	}
	
 	Quit $$$OK
}

ClassMethod GetTestCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTestCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetTestCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTestCodeExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-05-06
/// Description:  通过字典名称获取字典项目
/// Input:		  DicName : 字典名字
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.Sys.CommonSrv","QryLabCompareOperator","CompareOperator")
Query QryLabCompareOperator(DicName As %String) As %Query(ROWSPEC = "rowid:%String,DicCode:%String,DicName:%String")
{
}

ClassMethod QryLabCompareOperatorExecute(ByRef qHandle As %Binary, DicName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Quit:DicName="" $$$OK
	Set strOpers=$lb("大于","小于","大于等于","小于等于","等于","不等于","包含","被包含","不包含","异常标记")
	For i=1:1:$listlength(strOpers)
	{
		Set Oper=$li(strOpers,i)
		Set Data=$lb(i,Oper,Oper)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabCompareOperatorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabCompareOperatorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLabCompareOperatorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabCompareOperatorExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-05-06
/// Description:  通过检验项目获取对应的值
/// 
/// Input:		  LabCode : 检验项目Code
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.Sys.CommonSrv","GetValueListByCode","F0360","3")
Query GetValueListByCode(aLabCode As %String, aSSHospCode As %String) As %Query(ROWSPEC = "Code:%String,Descs:%String")
{
}

ClassMethod GetValueListByCodeExecute(ByRef qHandle As %Binary, aLabCode As %String, aSSHospCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Set xHospCode=""
	For {
		Set xHospCode=$o(^DHCMed.DC.LIS.BTTestCodeI("IndexCode",xHospCode))
		Quit:xHospCode=""
		Continue:'$d(^DHCMed.DC.BTHospitalI("IndexSCode",xHospCode," "_$zcvt(aSSHospCode,"U"),1))
		
		Set xTCID=0
		For {
			Set xTCID=$o(^DHCMed.DC.LIS.BTTestCodeI("IndexCode",xHospCode," "_$zcvt(aLabCode,"U"),xTCID))
			Quit:xTCID=""
			
			Set objTC=##class(DHCMed.DC.LIS.BTTestCode).GetObjById(xTCID)
			Continue:'$IsObject(objTC)
			
			Set TCCode=objTC.Code
			Set TCDesc=objTC.CName
			Set ResultFormat=objTC.ResultFormat
			
		    If (ResultFormat="M")||(ResultFormat="V") {
			    //细菌字典
			    Set xCode=""
			    For {
					Set xCode=$o(^DHCMed.DC.LIS.BTOrganismI("IndexCode",xHospCode,xCode))
					Quit:xCode=""
					Set xID=0
					For {
						Set xID=$o(^DHCMed.DC.LIS.BTOrganismI("IndexCode",xHospCode,xCode,xID))
						Quit:xID=""
						Set obj=##class(DHCMed.DC.LIS.BTOrganism).GetObjById(xID)
						Continue:'$IsObject(obj)
						Continue:obj.Active'=1
						Set Code=obj.Code
						Set Desc=obj.CName
						Set ^CacheTemp(repid,ind)=$lb(Code,Desc)
				 		Set ind=ind+1
					}
				}
			} ElseIf (ResultFormat="S") {
				//Standard Comment标准意见
				Set TCCodeDR=$o(^DHCMed.DC.LIS.BTTestCodeI("IndexCode",xHospCode," "_$zcvt(TCCode,"U"),0))
				Set xTscCode=""
				For {
					Set xTscCode=$o(^DHCMed.DC.LIS.BTTestCodeSCI("IndexCode",TCCodeDR,xTscCode))
					Quit:xTscCode=""
					Continue:xTscCode'[TCCode
					
					Set xID=0
					For {
						Set xID=$o(^DHCMed.DC.LIS.BTTestCodeSCI("IndexCode",TCCodeDR,xTscCode,xID))
						Quit:xID=""
						
						Set obj=##class(DHCMed.DC.LIS.BTTestCodeSC).GetObjById(xID)
						Continue:'$IsObject(obj)
						Continue:obj.Active'=1
						Set Code=obj.Code
						Set Desc=obj.CName
						Set ^CacheTemp(repid,ind)=$lb(Code,Desc)
				 		Set ind=ind+1
					}
				}
			} ElseIf (ResultFormat="B2") {
				//血型
				Set xID=0
				For {
					Set xID=$o(^DHCMed.DC.LIS.BTABOBGD(xID))
					Quit:xID=""
					Set obj=##class(DHCMed.DC.LIS.BTABOBG).GetObjById(xID)
					Continue:'$IsObject(obj)
					Set Code=obj.Code
					Set Desc=obj.CName
					Set ^CacheTemp(repid,ind)=$lb(Code,Desc)
			 		Set ind=ind+1
				}
			} Else {}
		}
	}
	
	Quit $$$OK
}

ClassMethod GetValueListByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetValueListByCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetValueListByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetValueListByCodeExecute ]
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

/// w ##Class(DHCMed.CCService.Sys.CommonSrv).getSet()
ClassMethod getSet() As %String
{
   //s a=##class(Nur.DHCMGNurseSet).getSet()
	s id=$O(^Nur.DHCMGNurseSetD(""))
	if id="" q ""
	s db=$ListGet(^Nur.DHCMGNurseSetD(id),2)
	s websv=$ListGet(^Nur.DHCMGNurseSetD(id),3)
	s genpath=$ListGet(^Nur.DHCMGNurseSetD(id),4)
	q db_"^"_websv_"^"_genpath
}

}
