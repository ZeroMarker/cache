/// 名称: DHCMed.NINFService.Dic.InfDiagnose
/// 描述: 感染诊断的常用操作
/// 编写者：zhufei
/// 编写日期: 2012-05-19
Class DHCMed.NINFService.Dic.InfDiagnose Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-07-04
/// Description:  保存感染诊断字典
/// Table：       DHCMed.NINF.Rep.InfDiagnose
/// Input：       aRepTypeCode : 报告类型代码
/// Return：      
/// w ##class(DHCMed.NINFService.Dic.InfDiagnose).SaveRec("","^")
ClassMethod SaveRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	
	Set $ZT="SaveRecErr"
	
	Set RowID=$p(aInput,aSeparate,1)
	Set Code=$p(aInput,aSeparate,2)
	Set Code=$zcvt(Code,"U")            //Code大写
	Set $p(aInput,aSeparate,2)=Code
	Set Desc=$p(aInput,aSeparate,3)
	Set ICD10=$p(aInput,aSeparate,4)
	Set IsActive=$p(aInput,aSeparate,5)
	Set Alias=$p(aInput,aSeparate,6)
	Set Alias=$zcvt(Alias,"U")          //Alias大写
	Set $p(aInput,aSeparate,6)=Alias
	Set Resume=$p(aInput,aSeparate,7)
	Quit:(Code="")||(Desc="") return
	
	Set return=-100
	Set xRowID=0,IsError=0
	For {
		Set xRowID=$o(^DHCMed.NINFDi("InfDia",0,"IndexCode"," "_Code,xRowID))
		Quit:xRowID=""
		Continue:(RowID'="")&&(RowID=xRowID)
		Set IsError=1
	}
	Quit:IsError=1 return
	
	Set return=##Class(DHCMed.NINF.Dic.InfDiagnose).Update(aInput,aSeparate)
	
	Quit return
	
SaveRecErr
	Quit "-999"
}

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  查询感染诊断
/// Table：       DHCMed.NINF.Dic.InfDiagnose
/// Input：       DHCMed.NINF.Dic.InfPosition.ID
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.InfDiagnose","QryInfDiaByPos","1")
Query QryInfDiaByPos(aInfPosID As %String) As %Query(ROWSPEC = "InfDiaRowId:%String,InfDiaICD:%String,InfDiaDesc:%String")
{
}

ClassMethod QryInfDiaByPosExecute(ByRef qHandle As %Binary, aInfPosID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set InfPosID=0,Count=0
 	For {
	 	Set InfPosID=$o(^DHCMed.NINFDi("MapPosDia",0,"IndexInfPos",InfPosID))
	 	Quit:InfPosID=""
	 	Continue:(aInfPosID'="")&&(aInfPosID'=InfPosID)
	 	Set MapID=0
	 	For {
		 	Set MapID=$o(^DHCMed.NINFDi("MapPosDia",0,"IndexInfPos",InfPosID,MapID))
		 	Quit:MapID=""
		 	
		 	Set objMap=##class(DHCMed.NINF.Dic.MapPosDia).GetObjById(MapID)
		 	Continue:'$IsObject(objMap)
		 	Continue:'$IsObject(objMap.MPDInfDiaDr)
		 	Set InfDiaID=objMap.MPDInfDiaDr.%Id()
		 	Set IDICD10=objMap.MPDInfDiaDr.IDICD10
		 	Set IDDesc=objMap.MPDInfDiaDr.IDDesc
		 	Set IsActive=objMap.MPDInfDiaDr.IDActive
		 	Continue:IsActive'=1
		 	
		 	Set Count=Count+1
		 	Set Data=$lb(InfDiaID,IDICD10,IDDesc)
 			Set ^CacheTemp(repid,ind)=Data
 			Set ind=ind+1
		}
	}
	Quit:Count>0 $$$OK
	
	//如果没有关联诊断,取所有感染诊断
 	Set Code=""
 	For {
	 	Set Code=$o(^DHCMed.NINFDi("InfDia",0,"IndexCode",Code))
	 	Quit:Code=""
	 	Set ID=0
	 	For {
		 	Set ID=$o(^DHCMed.NINFDi("InfDia",0,"IndexCode",Code,ID))
		 	Quit:ID=""
		 	
		 	Set obj=##class(DHCMed.NINF.Dic.InfDiagnose).GetObjById(ID)
		 	Continue:'$IsObject(obj)
		 	Set InfDiaID=obj.%Id()
		 	Set IDICD10=obj.IDICD10
		 	Set IDDesc=obj.IDDesc
		 	Set IsActive=obj.IDActive
		 	Continue:IsActive'=1
		 	
		 	Set Data=$lb(InfDiaID,IDICD10,IDDesc)
 			Set ^CacheTemp(repid,ind)=Data
 			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryInfDiaByPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfDiaByPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfDiaByPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfDiaByPosExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-07-04
/// Description:  查询院感诊断
/// Table：       DHCMed.NINF.Dic.InfDiagnose
/// Input：       
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.InfDiagnose","QryInfDiagnose")
Query QryInfDiagnose() As %Query(ROWSPEC = "RowID:%String,IDCode:%String,IDDesc:%String,IDICD10:%String,IDActive:%String,IDActiveDesc:%String,IDAlias:%String,IDResume:%String")
{
}

ClassMethod QryInfDiagnoseExecute(ByRef qHandle As %Binary, aInfPosID As %String, aRepType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set RowID=""
 	For {
	 	Set RowID=$o(^DHCMed.NINFD("InfDia",RowID))
	 	Quit:RowID=""
	 	
	 	Set obj=##class(DHCMed.NINF.Dic.InfDiagnose).GetObjById(RowID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set (IDCode,IDDesc,IDICD10,IDActive,IDActiveDesc,IDAlias,IDResume)=""
	 	
	 	Set IDCode=obj.IDCode
		Set IDDesc=obj.IDDesc
		Set IDICD10=obj.IDICD10
		Set IDActive=obj.IDActive
		Set IDActiveDesc=$s(IDActive=1:"是",1:"否")
		Set IDAlias=obj.IDAlias
		Set IDResume=obj.IDResume
		
	 	Set Data=$lb(RowID,IDCode,IDDesc,IDICD10,IDActive,IDActiveDesc,IDAlias,IDResume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryInfDiagnoseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfDiagnoseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfDiagnoseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfDiagnoseExecute ]
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

/// w ##Class(DHCMed.NINFService.Dic.InfDiagnose).ChangeDic()
ClassMethod ChangeDic()
{
	New
	Kill ^DHCMed.NINFD("InfDia")
	Kill ^DHCMed.NINFDi("InfDia")
	
	Set DicID=0,num=0
	For {
		Set DicID=$o(^DHCMed.INF.InfDiagnoseD(DicID))
		Quit:DicID=""
		Set objDic=##Class(DHCMed.INF.InfDiagnose).GetObjById(DicID)
		Continue:'$IsObject(objDic)
		Set num=num+1
		Set:$l(num)=1 No="0"_num
		Set:$l(num)>1 No=num
		Set InputStr=""
		Set InputStr=InputStr_$c(1)_No
		Set InputStr=InputStr_$c(1)_objDic.DiseaseName
		Set InputStr=InputStr_$c(1)_""  //objDic.ICD
		Set InputStr=InputStr_$c(1)_objDic.Active
		Set InputStr=InputStr_$c(1)_$zcvt(objDic.Alias,"U")
		Set InputStr=InputStr_$c(1)_objDic.ResumeText
		Set flg=##Class(DHCMed.NINF.Dic.InfDiagnose).Update(InputStr,$c(1))
	}
	
	Quit "ChangeDic() Over!"
}

/// Creator：     PanLei
/// CreatDate：   2012-08-01
/// Description:  导入Excel感染诊断字典
/// Table：       DHCMed.NINF.Dic.InfDiagnose
/// Input：       感染诊断字符串,"^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINFService.Dic.InfDiagnose).ImportInfDiagnosDic("","^")
ClassMethod ImportInfDiagnosDic(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ItemCode=$p(aInput,aSeparate,2)
	Set ItemID=$o(^DHCMed.NINFDi("InfDia",0,"IndexCode"," "_ItemCode,0))
	Set objItem=##class(DHCMed.NINF.Dic.InfDiagnose).GetObjById(ItemID)
	If $IsObject(objItem) {
		Set ItemID=objItem.%Id()
	} Else {
		Set ItemID=""
	}
	
	Set InputStr=ItemID
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,2)
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,3)
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,4)
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,5)
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,6)
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,7)
	Set return=##Class(DHCMed.NINF.Dic.InfDiagnose).Update(InputStr, aSeparate)
	
	Quit return
}

}
