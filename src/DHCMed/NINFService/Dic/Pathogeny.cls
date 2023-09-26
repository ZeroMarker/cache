/// 名称: DHCMed.NINFService.Dic.Pathogeny
/// 描述: 病原体的常用操作
/// 编写者：zhufei
/// 编写日期: 2012-05-26
Class DHCMed.NINFService.Dic.Pathogeny Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-07-04
/// Description:  保存病原体字典
/// Table：       DHCMed.NINF.Rep.Pathogeny
/// Input：       
/// Return：      
/// w ##class(DHCMed.NINFService.Dic.Pathogeny).SaveRec("272^001^AAAA^^1^","^")
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
	Set Desc1=$p(aInput,aSeparate,4)
	Set $p(aInput,aSeparate,4)=Desc1
	Set IsActive=$p(aInput,aSeparate,5)
	Set Resume=$p(aInput,aSeparate,6)
	Set IsMultires=$p(aInput,aSeparate,7)
	Set MultiresGroup=$p(aInput,aSeparate,8)
	Set Whonet=$p(aInput,aSeparate,9)
	Set Pinyin=$p(aInput,aSeparate,10)   //update by zhangxing 20121018
	Quit:(Code="")||(Desc="") return
	
	Set return=-100
	Set xRowID=0,IsError=0
	For {
		Set xRowID=$o(^DHCMed.NINFDi("Py",0,"IndexCode"," "_Code,xRowID))
		Quit:xRowID=""
		Continue:(RowID'="")&&(RowID=xRowID)
		Set IsError=1
	}
	Quit:IsError=1 return
	
	Set return=##Class(DHCMed.NINF.Dic.Pathogeny).Update(aInput,aSeparate)
	
	Quit return
	
SaveRecErr
	Quit "-999"
}

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  查询病原体
/// Table：       DHCMed.NINF.Dic.Pathogeny
/// Input：       
///        aCateCode As %String,  大类代码   add by wuqk 2013-03-04
///        aSubCateCode As %String  子类代码
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.Pathogeny","QryPathogeny","","","","","","白")
Query QryPathogeny(aAlias As %String, aIsActive As %String = "1", aCateCode As %String = "", aSubCateCode As %String = "", aPyWhonet As %String = "", aPyDesc As %String = "") As %Query(ROWSPEC = "PyID:%String,PyCode:%String,PyDesc:%String,PyDesc1:%String,PyActive:%String,PyActiveDesc:%String,PyResume:%String,PYIsMultires:%String,PYIsMultiresDesc:%String,MultiresGroupID:%String,MultiresGroupDesc:%String,PyWhonet:%String,PyPinyin:%String,PYCateCode:%String,PYCateDesc:%String,PYSubCateCode:%String,PYSubCateDesc:%String")
{
}

ClassMethod QryPathogenyExecute(ByRef qHandle As %Binary, aAlias As %String, aIsActive As %String, aCateCode As %String = "", aSubCateCode As %String = "", aPyWhonet As %String = "", aPyDesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aCateCode=$zcvt(aCateCode,"U")
 	Set aSubCateCode=$zcvt(aSubCateCode,"U")
 	Set aPyWhonet=$zcvt(aPyWhonet,"U")
 	Set aAlias=$zcvt(aAlias,"U")
 	Set Code=""
 	For {
	 	Set Code=$o(^DHCMed.NINFDi("Py",0,"IndexCode",Code))
	 	Quit:Code=""
	 	Set ID=0
	 	For {
		 	Set ID=$o(^DHCMed.NINFDi("Py",0,"IndexCode",Code,ID))
		 	Quit:ID=""
		 	
		 	Set obj=##class(DHCMed.NINF.Dic.Pathogeny).GetObjById(ID)
		 	Continue:'$IsObject(obj)
		 	Set PYCode=obj.PYCode
		 	Set PYDesc=obj.PYDesc
		 	Set PYDesc1=obj.PYDesc1
		 	Set PYPinyin=obj.PYPinyin   //update by zhangxing 20121018
		 	Continue:(aAlias'="")&&($zcvt(PYCode,"U")'[aAlias)&&($zcvt(PYDesc,"U")'[aAlias)&&($zcvt(PYDesc1,"U")'[aAlias)&&($zcvt(PYPinyin,"U")'[aAlias)
		 	Set PYActive=obj.PYActive
		 	Continue:(aIsActive'="")&&(PYActive'=aIsActive)
		 	Set PYActiveDesc=$s(PYActive=1:"是",1:"否")
		 	Set PYResume=obj.PYResume
		 	Set PYIsMultires=obj.PYIsMultires
		 	Set PYIsMultiresDesc=$s(PYIsMultires=1:"是",1:"否")
		 	Set (MultiresGroupID,MultiresGroupDesc)=""
		 	If $IsObject(obj.PYMultiresGroup) {
			 	Set MultiresGroupID=obj.PYMultiresGroup.%Id()
			 	Set MultiresGroupDesc=obj.PYMultiresGroup.Description
			}
			Set PYWhonet=obj.PYWhonet
			//add by liuyh 2013-03-21
			Set sPYWhonet=$zcvt(PYWhonet,"U")
			Continue:(aPyWhonet'="")&&(sPYWhonet'[aPyWhonet)
			Continue:(aPyDesc'="")&&(PYDesc'[aPyDesc)
			//add by wuqk 2013-03-04 --- begin--
		 	Set PYCateCode=obj.PYCateCode
		 	Continue:(aCateCode'=PYCateCode)&(aCateCode'="")
		 	Set PYCateDesc=""
		 	if (PYCateCode'="") {
			 	set objPYCate = ##class(DHCMed.NINF.Dic.Cate).GetObjByCode(PYCateCode)
			 	if $IsObject(objPYCate){set PYCateDesc=objPYCate.Description}
			 }
		 	Set PYSubCateCode=obj.PYSubCateCode
		 	Continue:(aSubCateCode'=PYSubCateCode)&(aSubCateCode'="")
		 	Set PYSubCateDesc=""
		 	if (PYSubCateCode'="") {
			 	set objPYSubCate = ##class(DHCMed.NINF.Dic.Cate).GetObjByCode(PYSubCateCode)
			 	if $IsObject(objPYSubCate){set PYSubCateDesc=objPYSubCate.Description}
			 }
			 
			//add by wuqk 2013-03-04 --- end---
			
			
		 	Set Data=$lb(ID,PYCode,PYDesc,PYDesc1,PYActive,PYActiveDesc,PYResume,PYIsMultires,PYIsMultiresDesc,MultiresGroupID,MultiresGroupDesc,PYWhonet,PYPinyin,PYCateCode,PYCateDesc,PYSubCateCode,PYSubCateDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryPathogenyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathogenyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathogenyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathogenyExecute ]
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

/// w ##Class(DHCMed.NINFService.Dic.Pathogeny).ChangeDic()
ClassMethod ChangeDic()
{
	New
	Kill ^DHCMed.NINFD("Py")
	Kill ^DHCMed.NINFDi("Py")
	
	Set DicID=0,num=0
	For {
		Set DicID=$o(^DHCMed.INF.InfPathogenDicD(DicID))
		Quit:DicID=""
		Set objDic=##Class(DHCMed.INF.InfPathogenDic).GetObjById(DicID)
		Continue:'$IsObject(objDic)
		Set num=num+1
		Set:$l(num)=1 No="00"_num
		Set:$l(num)=2 No="0"_num
		Set:$l(num)>2 No=num
		Set InputStr=""
		Set InputStr=InputStr_$c(1)_No
		Set InputStr=InputStr_$c(1)_objDic.Description
		Set InputStr=InputStr_$c(1)_$zcvt(objDic.Code,"U")
		Set InputStr=InputStr_$c(1)_objDic.Active
		Set InputStr=InputStr_$c(1)_objDic.ResumeText
		Set flg=##Class(DHCMed.NINF.Dic.Pathogeny).Update(InputStr,$c(1))
	}
	
	Quit "ChangeDic() Over!"
}

/// Creator：     PanLei
/// CreatDate：   2012-07-31
/// Description:  导入病原体字典
///               数据来源,检验系统的细菌表CT_Bugs
/// Table：       DHCMed.NINF.Dic.Pathogeny
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINFService.Dic.Pathogeny).ImportPyDicByLab()
ClassMethod ImportPyDicByLab() As %String
{
	New
	Kill ^DHCMed.NINFD("Py")
	Kill ^DHCMed.NINFDi("Py")

	//update by zf 20160308 数据池相关程序修改(检验)
	Set xID=0
	For {
		Set xID=$o(^DHCMed.DC.LIS.BTOrganismD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCMed.DC.LIS.BTOrganism).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.Active'=1
		Set PYCode=obj.Code
		Set PYDesc=obj.CName
		Set InputStr="^"_PYCode_"^"_PYDesc_"^"_""_"^"_"1"_"^"
		Set flg=##Class(DHCMed.NINF.Dic.Pathogeny).Update(InputStr,"^")
	}
	
	Quit "ImportPyDicByLab() Over!"
}

/// Creator：     zhufei
/// CreatDate：   2012-08-07
/// Description:  导入病原体字典(whonet码)
/// Table：       DHCMed.NINF.Dic.Pathogeny
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINFService.Dic.Pathogeny).ImportPyDic("","^")
ClassMethod ImportPyDic(aInput As %String, aSeparate As %String) As %String
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
	Set ItemID=$o(^DHCMed.NINFDi("Py",0,"IndexCode"," "_$zcvt(ItemCode,"U"),0))
	Set objItem=##class(DHCMed.NINF.Dic.Pathogeny).GetObjById(ItemID)
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
	Set MultiresGroup=$p(aInput,aSeparate,8)
	Set:MultiresGroup'="" MultiresGroup=##Class(DHCMed.SSService.DictionarySrv).GetIDByDesc("","NINFMultiresGroup",MultiresGroup)
	Set:MultiresGroup'="" MultiresGroup=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(MultiresGroup,"NINFMultiresGroup")
	Set InputStr=InputStr_aSeparate_MultiresGroup
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,9)
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,10)   //update by zhangxing 20121018
	
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,11)
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,12)
	Set flg=##Class(DHCMed.NINF.Dic.Pathogeny).Update(InputStr,"^")
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-10-20
/// Description:  查询病原体
/// Table：       DHCMed.NINF.Dic.Pathogeny
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.Pathogeny","QryPyToCombo","bd","1")
Query QryPyToCombo(aAlias As %String, aIsActive As %String = "1") As %Query(ROWSPEC = "PyID:%String,PyCode:%String,PyDesc:%String,PyDesc1:%String,PyActive:%String,PyActiveDesc:%String,PyResume:%String,PYIsMultires:%String,PYIsMultiresDesc:%String,MultiresGroupID:%String,MultiresGroupDesc:%String,PyWhonet:%String,PyPinyin:%String")
{
}

ClassMethod QryPyToComboExecute(ByRef qHandle As %Binary, aAlias As %String, aIsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aAlias=$zcvt(aAlias,"U")
 	Set Code="",Count=0
 	For {
	 	Set Code=$o(^DHCMed.NINFDi("Py",0,"IndexCode",Code))
	 	Quit:Code=""
	 	Set ID=0
	 	For {
		 	Set ID=$o(^DHCMed.NINFDi("Py",0,"IndexCode",Code,ID))
		 	Quit:ID=""
			Quit:Count>100
		 	
		 	Set obj=##class(DHCMed.NINF.Dic.Pathogeny).GetObjById(ID)
		 	Continue:'$IsObject(obj)
		 	Set PYCode=obj.PYCode
		 	Set PYDesc=obj.PYDesc
		 	Set PYDesc1=obj.PYDesc1
		 	Set PYPinyin=obj.PYPinyin   //update by zhangxing 20121018
		 	Continue:(aAlias'="")&&($zcvt(PYCode,"U")'[aAlias)&&($zcvt(PYDesc,"U")'[aAlias)&&($zcvt(PYDesc1,"U")'[aAlias)&&($zcvt(PYPinyin,"U")'[aAlias)
		 	Set PYActive=obj.PYActive
		 	Continue:(aIsActive'="")&&(PYActive'=aIsActive)
		 	Set PYActiveDesc=$s(PYActive=1:"是",1:"否")
		 	Set PYResume=obj.PYResume
		 	Set PYIsMultires=obj.PYIsMultires
		 	Set PYIsMultiresDesc=$s(PYIsMultires=1:"是",1:"否")
		 	Set (MultiresGroupID,MultiresGroupDesc)=""
		 	If $IsObject(obj.PYMultiresGroup) {
			 	Set MultiresGroupID=obj.PYMultiresGroup.%Id()
			 	Set MultiresGroupDesc=obj.PYMultiresGroup.Description
			}
			Set PYWhonet=obj.PYWhonet
			
			Set Count=Count+1
		 	Set Data=$lb(ID,PYCode,PYDesc,PYDesc1,PYActive,PYActiveDesc,PYResume,PYIsMultires,PYIsMultiresDesc,MultiresGroupID,MultiresGroupDesc,PYWhonet,PYPinyin)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryPyToComboClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPyToComboExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPyToComboFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPyToComboExecute ]
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

}
