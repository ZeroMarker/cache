/// 名称: DHCMed.NINFService.Dic.InfPosition
/// 描述: 感染部位的常用操作
/// 编写者：zhufei
/// 编写日期: 2012-05-19
Class DHCMed.NINFService.Dic.InfPosition Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-07-04
/// Description:  保存感染部位字典
/// Table：       DHCMed.NINF.Rep.InfPosition
/// Input：       aRepTypeCode : 报告类型代码
/// Return：      
/// w ##class(DHCMed.NINFService.Dic.InfPosition).SaveRec("","^")
ClassMethod SaveRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	
	Set $ZT="SaveRecErr"
	
	Set RowID=$p(aInput,aSeparate,1)
	Set Code=$p(aInput,aSeparate,2)
	Set Code=$zcvt(Code,"U")          //Code大写
	Set $p(aInput,aSeparate,2)=Code
	Set Desc=$p(aInput,aSeparate,3)
	Set IsActive=$p(aInput,aSeparate,4)
	Set Resume=$p(aInput,aSeparate,5)
	Quit:(Code="")||(Desc="") return
	
	Set return=-100
	Set xRowID=0,IsError=0
	For {
		Set xRowID=$o(^DHCMed.NINFDi("InfPos",0,"IndexCode"," "_Code,xRowID))
		Quit:xRowID=""
		Continue:(RowID'="")&&(RowID=xRowID)
		Set IsError=1
	}
	Quit:IsError=1 return
	
	Set return=##Class(DHCMed.NINF.Dic.InfPosition).Update(aInput,aSeparate)
	
	Quit return
	
SaveRecErr
	Quit "-999"
}

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  查询院感部位
/// Table：       DHCMed.NINF.Dic.InfPosition
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.InfPosition","QryInfPosition","1")
Query QryInfPosition(aIsActive As %String) As %Query(ROWSPEC = "InfPosRowId:%String,InfPosCode:%String,InfPosDesc:%String,InfPosActive:%String,InfPosActiveDesc:%String,InfPosResume:%String") [ SqlProc ]
{
}

ClassMethod QryInfPositionExecute(ByRef qHandle As %Binary, aIsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set Code=""
 	For {
	 	Set Code=$o(^DHCMed.NINFDi("InfPos",0,"IndexCode",Code))
	 	Quit:Code=""
	 	Set ID=0
	 	For {
		 	Set ID=$o(^DHCMed.NINFDi("InfPos",0,"IndexCode",Code,ID))
		 	Quit:ID=""
		 	
		 	Set obj=##class(DHCMed.NINF.Dic.InfPosition).GetObjById(ID)
		 	Continue:'$IsObject(obj)
		 	Set IPCode=obj.IPCode
		 	Set IPDesc=obj.IPDesc
		 	Set IPActive=obj.IPActive
		 	Continue:(aIsActive'="")&&(IPActive'=aIsActive)
		 	Set IPActiveDesc=$s(IPActive=1:"是",1:"否")
		 	Set IPResume=obj.IPResume
		 	
		 	Set Data=$lb(ID,IPCode,IPDesc,IPActive,IPActiveDesc,IPResume)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryInfPositionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPositionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPositionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPositionExecute ]
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

/// w ##Class(DHCMed.NINFService.Dic.InfPosition).ChangeDic()
ClassMethod ChangeDic()
{
	New
	Kill ^DHCMed.NINFD("InfPos")
	Kill ^DHCMed.NINFDi("InfPos")
	
	Set DicID=0,num=0
	For {
		Set DicID=$o(^DHCMed.INF.InfPositionD(DicID))
		Quit:DicID=""
		Set objDic=##Class(DHCMed.INF.InfPosition).GetObjById(DicID)
		Continue:'$IsObject(objDic)
		Set num=num+1
		Set:$l(num)=1 No="0"_num
		Set:$l(num)>1 No=num
		Set InputStr=""
		Set InputStr=InputStr_$c(1)_No
		Set InputStr=InputStr_$c(1)_objDic.InfPosition
		Set InputStr=InputStr_$c(1)_objDic.Active
		Set InputStr=InputStr_$c(1)_objDic.ResumeText
		Set flg=##Class(DHCMed.NINF.Dic.InfPosition).Update(InputStr,$c(1))
	}
	
	Quit "ChangeDic() Over!"
}

/// Creator：     PanLei
/// CreatDate：   2012-08-01
/// Description:  导入Excel感染部位字典
/// Table：       DHCMed.NINF.Dic.InfPosition
/// Input：       感染部位字符串,"^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINFService.Dic.InfPosition).ImportInfPositionDic("","^")
ClassMethod ImportInfPositionDic(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	If aInput["undefined" {
		While (aInput["undefined") {
			Set aInput=$p(aInput,"undefined",1)_$e(aInput,$l($p(aInput,"undefined",1)_"undefined")+1,aInput)
		}
	}
	
	Set ItemCode=$p(aInput,aSeparate,2)
	Set ItemID=$o(^DHCMed.NINFDi("InfPos",0,"IndexCode"," "_ItemCode,0))
	Set objItem=##class(DHCMed.NINF.Dic.InfPosition).GetObjById(ItemID)
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
	Set return=##Class(DHCMed.NINF.Dic.InfPosition).Update(InputStr, aSeparate)
	Quit return
}

}
