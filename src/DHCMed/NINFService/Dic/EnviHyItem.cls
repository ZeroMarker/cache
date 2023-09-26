/// 名称: DHCMed.NINFService.Dic.EnviHyItem
/// 描述: 环境卫生学监测项目的常用操作
/// 编写者：zhufei
/// 编写日期: 2012-08-14
Class DHCMed.NINFService.Dic.EnviHyItem Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-08-14
/// Description:  保存环境卫生学监测项目
/// Table：       DHCMed.NINF.Dic.EnviHyItem
/// Input：       
/// Return：      
/// w ##class(DHCMed.NINFService.Dic.EnviHyItem).SaveRec("^01^非洁净区域空气消毒^检测范围^空气消毒效果监测^1次/月^cfu/m3^1^","^")
ClassMethod SaveRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	
	Set $ZT="SaveRecErr"
	Set RowID=$p(aInput,aSeparate,1)
	Set Code=$p(aInput,aSeparate,2)
	Set Code=$zcvt(Code,"U")
	Set $p(aInput,aSeparate,2)=Code
	Set Desc=$p(aInput,aSeparate,3)
	Set Desc=$zcvt(Desc,"U")
	Quit:(Code="")||(Desc="") return
	Set return=-100
	Set xRowID=0,IsError=0
	For {
		Set xRowID=$o(^DHCMed.NINFDi("EHI",0,"IndexCode"," "_Code,xRowID)) //如果Code不存在 就没有这条索引 xRowID="" 就跳出循环 IsError就不能等于1
		Quit:xRowID=""  
		Continue:(RowID'="")&&(RowID=xRowID)  //如果Code已存在且输入的RowID为空时【即直接输入已存在的Code点保存】，就不会进行下一次循环，程序向下执行，IsError就等于1，就会出现数据重复错误
		Set IsError=1                         //Quit是添加新数据，Continue是更新数据。什么时候会出现RowID!="" 但是RowID!=xRowID呢？
		                                      //客户端操作是不会出现的，所以RowID=xRowID这个条件是可以不要的
	}
	If (IsError=0) {
		Set xRowID=0
		For {
			Set xRowID=$o(^DHCMed.NINFDi("EHI",0,"IndexDesc"," "_Desc,xRowID)) 
			Quit:xRowID=""  
			Continue:(RowID'="")&&(RowID=xRowID)  
			Set IsError=1 
		}
	}
	Quit:IsError=1 return   //-100 数据重复【没有选中Panel，输入的code重复会返回-100】
	//执行下面语句的条件是：RowID为空且Code不存在【添加】  或 RowID不为空Code存在【更新】
	Set return=##Class(DHCMed.NINF.Dic.EnviHyItem).Update(aInput_aSeparate,aSeparate)  //_"^" add by yhb 计算公式
	
	Quit return
	
SaveRecErr
	Quit "-999"
}

/// Creator：     zhufei
/// CreatDate：   2012-08-14
/// Description:  查询环境卫生学监测项目
/// Table：       DHCMed.NINF.Dic.EnviHyItem
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.EnviHyItem","QryEnviHyItem","","","","","","","","","")
Query QryEnviHyItem(aEHICode As %String, aEHIDesc As %String, aContent As %String, aCateg As %String, aFreq As %String, aNormUom As %String, aIsActive As %String, aResume As %String, aFormula As %String) As %Query(ROWSPEC = "ItemID:%String,ItemCode:%String,ItemDesc:%String,ItemContent:%String,ItemCategID:%String,ItemCategDesc:%String,ItemFreqID:%String,ItemFreqDesc:%String,ItemNormUomID:%String,ItemNormUomDesc:%String,ItemActive:%String,ItemActiveDesc:%String,ItemResume:%String,ItemFormula:%String")
{
}

ClassMethod QryEnviHyItemExecute(ByRef qHandle As %Binary, aEHICode As %String, aEHIDesc As %String, aContent As %String, aCateg As %String, aFreq As %String, aNormUom As %String, aIsActive As %String, aResume As %String, aFormula As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set aEHIDesc=$zcvt(aEHIDesc,"U")
 	Set aEHICode=$zcvt(aEHICode,"U")
 	Set aContent=$zcvt(aContent,"U")
 	Set aCateg=$zcvt(aCateg,"U")
 	Set aFreq=$zcvt(aFreq,"U")
 	Set aNormUom=$zcvt(aNormUom,"U")
 	Set:aIsActive="true" aIsActive=1
 	Set:aIsActive="false" aIsActive=0
 	Set aResume=$zcvt(aResume,"U")
 	Set aFormula=$zcvt(aFormula,"U")
 	
 	Set xCode=""
 	For {
	 	Set xCode=$o(^DHCMed.NINFDi("EHI",0,"IndexCode",xCode))
	 	Quit:xCode=""
	 	Set xID=0
	 	For {
		 	Set xID=$o(^DHCMed.NINFDi("EHI",0,"IndexCode",xCode,xID))
		 	Quit:xID=""
		 	
		 	Set ID=xID
		 	Set obj=##class(DHCMed.NINF.Dic.EnviHyItem).GetObjById(ID)
		 	Continue:'$IsObject(obj)
		 	
		 	Set EHICode=obj.EHICode
		 	Set EHIDesc=obj.EHIDesc
		 	Continue:(aEHICode '="")&&($zcvt(EHICode,"U")'[aEHICode )
		 	Continue:(aEHIDesc '="")&&($zcvt(EHIDesc,"U")'[aEHIDesc )
		 	Set EHIContent=obj.EHIContent
		 	Continue:(aContent '="")&&($zcvt(EHIContent,"U")'[aContent )
		 	Set (EHICategID,EHICategDesc)=""
		 	If $IsObject(obj.EHICateg) {
				Set EHICategID=obj.EHICateg.%Id()
				Set EHICategDesc=obj.EHICateg.Description
				Continue:(aCateg '="")&&($zcvt(EHICategID,"U")'[aCateg )
			}
			Set (EHIFreqID,EHIFreqDesc)=""
		 	If $IsObject(obj.EHIFreq) {
				Set EHIFreqID=obj.EHIFreq.%Id()
				Set EHIFreqDesc=obj.EHIFreq.Description
				Continue:(aFreq '="")&&($zcvt(EHIFreqID,"U")'[aFreq )
			}
			Set (EHINormUomID,EHINormUomDesc)=""
			If $IsObject(obj.EHINormUom) {
				Set EHINormUomID=obj.EHINormUom.%Id()
				Set EHINormUomDesc=obj.EHINormUom.Description
				Continue:(aNormUom '="")&&($zcvt(EHINormUomID,"U")'[aNormUom )
			}
		 	Set EHIActive=obj.EHIActive
		 	Continue:(aIsActive'="")&&(EHIActive'=aIsActive)
		 	Set EHIActiveDesc=$s(EHIActive=1:"是",1:"否")
		 	Set EHIResume=obj.EHIResume
		 	Continue:(aResume '="")&&($zcvt(EHIResume,"U")'[aResume )
		 	Set Formula = ""
		 	Set ChildMulaCount = obj.ChildMula.Count()
		 	for i = 1:1:ChildMulaCount {
			 	if (obj.ChildMula.GetAt(i).EHIFIsActive){
				 	Set Formula = Formula_","_obj.ChildMula.GetAt(i).EHIFForMula
				}	
			}
			Set:Formula'="" Formula = $e(Formula,"2",$l(Formula)) 
		 	Set Data=$lb(ID,EHICode,EHIDesc,EHIContent,EHICategID,EHICategDesc,EHIFreqID,EHIFreqDesc,EHINormUomID,EHINormUomDesc,EHIActive,EHIActiveDesc,EHIResume,Formula)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryEnviHyItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnviHyItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEnviHyItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnviHyItemExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-08-14
/// Description:  导入Excel环境卫生学监控项目
/// Table：       DHCMed.NINF.Dic.EnviHyItem
/// Input：       监控项目字符串,"^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINFService.Dic.EnviHyItem).ImportDic("^01^非洁净区域空气消毒^空气消毒效果监测^1次/月^cfu/m3^1^","^")
ClassMethod ImportDic(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	Set ItemCode=$p(aInput,aSeparate,2)
	Set ItemID=$o(^DHCMed.NINFDi("EHI",0,"IndexCode"," "_ItemCode,0))
	Set objItem=##class(DHCMed.NINF.Dic.EnviHyItem).GetObjById(ItemID)
	If $IsObject(objItem) {
		Set ItemID=objItem.%Id()
	} Else {
		Set ItemID=""
	}
	Set ItemCateg=$p(aInput,aSeparate,5)
	Set:ItemCateg'="" ItemCateg=##Class(DHCMed.SSService.DictionarySrv).GetIDByDesc("","NINFEnviHyItemCategory",ItemCateg)
	Set:ItemCateg'="" ItemCateg=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(ItemCateg,"NINFEnviHyItemCategory")
	Set ItemFreq=$p(aInput,aSeparate,6)
	Set:ItemFreq'="" ItemFreq=##Class(DHCMed.SSService.DictionarySrv).GetIDByDesc("","NINFEnviHyItemFrequency",ItemFreq)
	Set:ItemFreq'="" ItemFreq=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(ItemFreq,"NINFEnviHyItemFrequency")
	Set ItemNormUom=$p(aInput,aSeparate,7)
	Set:ItemNormUom'="" ItemNormUom=##Class(DHCMed.SSService.DictionarySrv).GetIDByDesc("","NINFEnviHyNormUom",ItemNormUom)
	Set:ItemNormUom'="" ItemNormUom=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(ItemNormUom,"NINFEnviHyNormUom")
	Set InputStr=ItemID
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,2)
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,3)
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,4)
	Set InputStr=InputStr_aSeparate_ItemCateg
	Set InputStr=InputStr_aSeparate_ItemFreq
	Set InputStr=InputStr_aSeparate_ItemNormUom
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,8)
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,9)
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,10)  //add by yhb 计算公式
	Set return=##Class(DHCMed.NINF.Dic.EnviHyItem).Update(InputStr, aSeparate)
	Quit return
}

}
