/// 名称: DHCMed.NINFService.Dic.EnviHyNorms
/// 描述: 环境卫生学结果判定标准的常用操作
/// 编写者：zhufei
/// 编写日期: 2012-08-14
Class DHCMed.NINFService.Dic.EnviHyNorms Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-08-14
/// Description:  保存环境卫生学结果判定标准
/// Table：       DHCMed.NINF.Dic.EnviHyNorms
/// Input：       
/// Return：     
/// w ##class(DHCMed.NINFService.Dic.EnviHyNorms).SaveRec("","^")
ClassMethod SaveRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	
	Set $ZT="SaveRecErr"
	Set RowID=$p(aInput,aSeparate,1)
	Set Categ=$p(aInput,aSeparate,2)
	Set Range=$p(aInput,aSeparate,3)
	Set Norm=$p(aInput,aSeparate,4)
	Quit:(Categ="")||(Range="")||(Norm="") return
	Set return=##Class(DHCMed.NINF.Dic.EnviHyNorms).Update(aInput,aSeparate)
	Quit return
	
SaveRecErr
	Quit "-999"
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-06-24
/// Description:  检测环境卫生学结果判定标准是否重复
/// Table：       DHCMed.NINF.Dic.EnviHyNorms
/// Input：       
/// Return：     Y:重复 或 N: 不重复
/// w ##class(DHCMed.NINFService.Dic.EnviHyNorms).CheckRec("120^6477^我^12^2^3^1^6499^6499^5^3^3^8","^")
ClassMethod CheckRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return="N"
	Quit:aInput="" return
	
	Set aRowID=$p(aInput,aSeparate,1)
	Set aCateg=$p(aInput,aSeparate,2)
	Set aRange=$p(aInput,aSeparate,3)
	Set aSpType=$p(aInput,aSeparate,9)
	
	Set xCateg=""
	For {
		Set xCateg=$o(^DHCMed.NINFDi("EHN",0,"IndexCategRange1",xCateg))
		Quit:xCateg=""
		Continue:xCateg'=aCateg
		
		Set xRange=""
		For {
			Set xRange=$o(^DHCMed.NINFDi("EHN",0,"IndexCategRange1",xCateg,xRange))
			Quit:xRange=""
			Continue:xRange'=(" "_$zcvt(aRange,"U"))
			
			Set xSpType=""
			For {
				Set xSpType=$o(^DHCMed.NINFDi("EHN",0,"IndexCategRange1",xCateg,xRange,xSpType))
				Quit:xSpType=""
				Continue:xSpType'=aSpType
				
				Set xID=$o(^DHCMed.NINFDi("EHN",0,"IndexCategRange1",xCateg,xRange,xSpType,""))
				Set:xID'=aRowID return="Y"
			}
		}
	}
	Quit return
}

/// Creator：     yhb
/// CreatDate：   2013-12-03
/// Description:  导入Excel环境卫生学判定标准
/// Table：       DHCMed.NINF.Dic.EnviHyNorms
/// Input：       监控项目字符串,"^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINFService.Dic.EnviHyNorms).ImportDic("^Ⅳ类^test^≤5cfu/㎝2 不得检出致病菌^^^1^^非重点科室﹤30m2房间空气消毒效果监测^27","^")
ClassMethod ImportDic(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set Category=$p(aInput,aSeparate,2)	    //环境类别
	Quit:Category="" return
	Set:Category="无" Category=0
	Set:Category="Ⅰ类" Category=1
	Set:Category="Ⅱ类" Category=2
	Set:Category="Ⅲ类" Category=3
	Set:Category="Ⅳ类" Category=4
	Set objCategory=##class(DHCMed.SS.Dictionary).GetByTypeCode("NINFEnviHyNormCategory",Category,"")
	Quit:'$IsObject(objCategory) return
	Set Category=objCategory.%Id()
	Set Range=$p(aInput,aSeparate,3)        //检测范围
	Quit:Range="" return
	
	Set ItemID=""
	Set ItemDesc = $p(aInput,aSeparate,14) 	//检测项目
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCMed.NINFDi("EHI",0,"IndexDesc"," "_$zcvt(ItemDesc,"U"),xItemID))
		Quit:xItemID=""
		Quit:ItemID'=""
		
		Set objItem=##class(DHCMed.NINF.Dic.EnviHyItem).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
		Set IsActive=objItem.EHIActive
		Continue:IsActive'=1
		Set ItemID=objItem.%Id()
	}
	
	Set SpecimenType=$p(aInput,aSeparate,5)     //标本类型
	Set:SpecimenType'="" SpecimenType=##Class(DHCMed.SSService.DictionarySrv).GetIDByDesc("","NINFEnviHySpecimenType",SpecimenType)
	Set:SpecimenType'="" SpecimenType=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(SpecimenType,"NINFEnviHySpecimenType")
	Quit:SpecimenType="" return
	
	Set NormID=$o(^DHCMed.NINFDi("EHN",0,"IndexCategRange",Category,Range,SpecimenType,0))
	
	Set InputStr=NormID
	Set InputStr=InputStr_aSeparate_Category                //环境类别
	Set InputStr=InputStr_aSeparate_Range                   //检测范围
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,4)  //判定标准
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,6)  //中心值
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,7)  //周边值
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,13) //是否有效
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,12) //备注
	Set InputStr=InputStr_aSeparate_SpecimenType            //标本类型
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,8)	//标本数量
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,9)  //中心个数
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,10) //周边个数
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,11) //项目对象
	Set InputStr=InputStr_aSeparate_ItemID                  //检测项目
	
	Set return=##Class(DHCMed.NINF.Dic.EnviHyNorms).Update(InputStr, aSeparate)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-08-14
/// Description:  查询环境卫生学结果判定标准
/// Table：       DHCMed.NINF.Dic.EnviHyNorms
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.EnviHyNorms","QryEnviHyNorms","","","","","","")
Query QryEnviHyNorms(aItemID As %String) As %Query(ROWSPEC = "SpecimenTypeID:%String,SpecimenTypeDesc:%String,SpecimenNum:%String,CenterNum:%String,SurroundNum:%String,ItemObj:%String,ID:%String,EHNCategID:%String,EHNCategDesc:%String,EHNRange:%String,EHNNorm:%String,EHNNormMax:%String,EHNNormMin:%String,EHNIsActive:%String,EHNIsActiveDesc:%String,EHNResume:%String")
{
}

ClassMethod QryEnviHyNormsExecute(ByRef qHandle As %Binary, aItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCMed.NINFD("EHN",xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMed.NINF.Dic.EnviHyNorms).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set ID=obj.%Id()
	 	Set ItemID=$o(^DHCMed.NINFDi("EHI",0,"MAP","IndexEHIMNorm",ID,0))
	 	Continue:(aItemID'="")&&(ItemID'=aItemID)
	 	
	 	Set (EHNCategID,EHNCategDesc,SpecimenTypeID,SpecimenTypeDesc)=""
	 	If $IsObject(obj.EHNCateg) {
			Set EHNCategID=obj.EHNCateg.%Id()
			Set EHNCategDesc=obj.EHNCateg.Description
		}
		If $IsObject(obj.SpecimenType) {
			Set SpecimenTypeID=obj.SpecimenType.%Id()
			Set SpecimenTypeDesc=obj.SpecimenType.Description
		}
		Set SpecimenNum=obj.SpecimenNum
		Set CenterNum=obj.CenterNum
		Set SurroundNum=obj.SurroundNum
		Set ItemObj=obj.ItemObj
		
		Set EHNRange=obj.EHNRange
		Set EHNNorm=obj.EHNNorm
		Set EHNNormMax=obj.EHNNormMax
		Set EHNNormMin=obj.EHNNormMin
	 	Set EHNIsActive=obj.EHNIsActive
	 	Set EHNIsActiveDesc=$s(EHNIsActive=1:"是",1:"否")
	 	Set EHNResume=obj.EHNResume
	 	
	 	Set Data=$lb(SpecimenTypeID,SpecimenTypeDesc,SpecimenNum,CenterNum,SurroundNum,ItemObj,ID,EHNCategID,EHNCategDesc,EHNRange,EHNNorm,EHNNormMax,EHNNormMin,EHNIsActive,EHNIsActiveDesc,EHNResume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryEnviHyNormsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnviHyNormsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEnviHyNormsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnviHyNormsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2012-08-14
/// Description:  查询环境卫生学结果判定标准
/// Table：       DHCMed.NINF.Dic.EnviHyNorms
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.EnviHyNorms","QryEnviHyNormToItem","1")
Query QryEnviHyNormToItem(aItemID As %String) As %Query(ROWSPEC = "ID:%String,EHNRange:%String,SpecimenTypeID:%String,SpecimenTypeDesc:%String,SpecimenNum:%String,CenterNum:%String,SurroundNum:%String,ItemObj:%String")
{
}

ClassMethod QryEnviHyNormToItemExecute(ByRef qHandle As %Binary, aItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set (ID,EHNRange,SpecimenTypeID,SpecimenTypeDesc,SpecimenNum,ItemObj)=""
 	if (aItemID=""){
		for {
			Set aItemID =$o(^DHCMed.NINFD("EHI",aItemID))
			Quit:aItemID=""
			Set obj=##class(DHCMed.NINF.Dic.EnviHyItem).GetObjById(aItemID)
		 	If $IsObject(obj) {
			 	Set norms = obj.ChildMap.Count()
			 	for i=1:1:norms {
				 	Set (ID,EHNRange) = ""
				 	Set objNormMap = obj.ChildMap.GetAt(i)
				 	If $IsObject(objNormMap) {
					 	Set objItem = objNormMap.EHIMNorm
					 	If $IsObject(objItem) {
					 		Set ID=objItem.%Id()
					 		Set EHNRange=objItem.EHNRange
					 		If $IsObject(objItem.SpecimenType) {
								Set SpecimenTypeID=objItem.SpecimenType.%Id()
								Set SpecimenTypeDesc=objItem.SpecimenType.Description
							}
							Set SpecimenNum=objItem.SpecimenNum
							Set CenterNum=objItem.CenterNum
							Set SurroundNum=objItem.SurroundNum
							Set ItemObj=objItem.ItemObj
					 		Set Data=$lb(ID,EHNRange,SpecimenTypeID,SpecimenTypeDesc,SpecimenNum,CenterNum,SurroundNum,ItemObj)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
					}
				}
			}
		}
	}
 	Set obj=##class(DHCMed.NINF.Dic.EnviHyItem).GetObjById(aItemID)
 	If $IsObject(obj) {
	 	Set norms = obj.ChildMap.Count()
	 	for i=1:1:norms {
		 	Set (ID,EHNRange) = ""
		 	Set objNormMap = obj.ChildMap.GetAt(i)
		 	If $IsObject(objNormMap) {
			 	Set objItem = objNormMap.EHIMNorm
			 	If $IsObject(objItem) {
			 		Set ID=objItem.%Id()
			 		Set EHNRange=objItem.EHNRange
			 		If $IsObject(objItem.SpecimenType) {
						Set SpecimenTypeID=objItem.SpecimenType.%Id()
						Set SpecimenTypeDesc=objItem.SpecimenType.Description
					}
					Set SpecimenNum=objItem.SpecimenNum
					Set CenterNum=objItem.CenterNum
					Set SurroundNum=objItem.SurroundNum
					Set ItemObj=objItem.ItemObj
			 		Set Data=$lb(ID,EHNRange,SpecimenTypeID,SpecimenTypeDesc,SpecimenNum,CenterNum,SurroundNum,ItemObj)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryEnviHyNormToItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnviHyNormToItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEnviHyNormToItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnviHyNormToItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
