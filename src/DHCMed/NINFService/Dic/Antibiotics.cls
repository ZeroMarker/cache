/// 名称: DHCMed.NINFService.Dic.Antibiotics
/// 描述: 抗生素的常用操作
/// 编写者：zhufei
/// 编写日期: 2012-06-22
Class DHCMed.NINFService.Dic.Antibiotics Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-07-04
/// Description:  保存抗生素字典
/// Table：       DHCMed.NINF.Rep.Antibiotics
/// Input：       
/// Return：      
/// w ##class(DHCMed.NINFService.Dic.Antibiotics).SaveRec("^001^AAAA^^1^","^")
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
	Set Whonet=$p(aInput,aSeparate,7)
	Set Pinyin=$p(aInput,aSeparate,8)   //update by zhangxing 20121018
	Quit:(Code="")||(Desc="") return
	
	Set return=-100
	Set xRowID=0,IsError=0
	For {
		Set xRowID=$o(^DHCMed.NINFDi("Anti",0,"IndexCode"," "_Code,xRowID))
		Quit:xRowID=""
		Continue:(RowID'="")&&(RowID=xRowID)
		Set IsError=1
	}
	Quit:IsError=1 return
	
	Set return=##Class(DHCMed.NINF.Dic.Antibiotics).Update(aInput,aSeparate)
	
	Quit return
	
SaveRecErr
	Quit "-999"
}

/// Creator：     zhufei
/// CreatDate：   2012-06-22
/// Description:  查询抗生素
/// Table：       DHCMed.NINF.Dic.Antibiotics
/// Input：       
///        aCateCode As %String,  大类代码   add by wuqk 2013-03-04
///        aSubCateCode As %String  子类代码
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.Antibiotics","QryAntibiotics","","","","","ac","")
Query QryAntibiotics(aAlias As %String, aIsActive As %String = "1", aCateCode As %String = "", aSubCateCode As %String = "", aANTWhonet As %String = "", aANTDesc As %String = "") As %Query(ROWSPEC = "AntiID:%String,AntiCode:%String,AntiDesc:%String,AntiDesc1:%String,AntiActive:%String,AntiActiveDesc:%String,AntiResume:%String,AntiWhonet:%String,AntiPinyin:%String,ANTCateCode:%String,ANTCateDesc:%String,ANTSubCateCode:%String,ANTSubCateDesc:%String")
{
}

ClassMethod QryAntibioticsExecute(ByRef qHandle As %Binary, aAlias As %String, aIsActive As %String, aCateCode As %String = "", aSubCateCode As %String = "", aANTWhonet As %String = "", aANTDesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aCateCode=$zcvt(aCateCode,"U")
 	Set aSubCateCode=$zcvt(aSubCateCode,"U")
 	Set aANTWhonet=$zcvt(aANTWhonet,"U")
 	Set aAlias=$zcvt(aAlias,"U")
 	Set Code=""
 	For {
	 	Set Code=$o(^DHCMed.NINFDi("Anti",0,"IndexCode",Code))
	 	Quit:Code=""
	 	Set ID=0
	 	For {
		 	Set ID=$o(^DHCMed.NINFDi("Anti",0,"IndexCode",Code,ID))
		 	Quit:ID=""
		 	
		 	Set obj=##class(DHCMed.NINF.Dic.Antibiotics).GetObjById(ID)
		 	Continue:'$IsObject(obj)
		 	Set ANTCode=obj.ANTCode
		 	Set ANTDesc=obj.ANTDesc
		 	Set ANTDesc1=obj.ANTDesc1
		 	Set ANTPinyin=obj.ANTPinyin   //update by zhangxing 20121018
		 	Continue:(aAlias'="")&&($zcvt(ANTCode,"U")'[aAlias)&&($zcvt(ANTDesc,"U")'[aAlias)&&($zcvt(ANTDesc1,"U")'[aAlias)&&($zcvt(ANTPinyin,"U")'[aAlias)
		 	Set ANTActive=obj.ANTActive
		 	Continue:(aIsActive'="")&&(ANTActive'=aIsActive)
		 	Set ANTActiveDesc=$s(ANTActive=1:"是",1:"否")
		 	Set ANTResume=obj.ANTResume
		 	Set ANTWhonet=obj.ANTWhonet
		 	
		 	//add by lyh 2013-03-20
		 	Continue:(aANTWhonet'="")&&(ANTWhonet'[aANTWhonet)
		 	Continue:(aANTDesc'="")&&(ANTDesc'[aANTDesc)
		 	
			//add by wuqk 2013-03-04 --- begin--
		 	Set ANTCateCode=obj.ANTCateCode          
		 	Continue:(aCateCode'=ANTCateCode)&(aCateCode'="")
		 	Set ANTCateDesc=""
		 	if (ANTCateCode'="") {
			 	set objANTCate = ##class(DHCMed.NINF.Dic.Cate).GetObjByCode(ANTCateCode)
			 	if $IsObject(objANTCate){set ANTCateDesc=objANTCate.Description}
			 }
		 	Set ANTSubCateCode=obj.ANTSubCateCode
		 	Continue:(aSubCateCode'=ANTSubCateCode)&(aSubCateCode'="")
		 	Set ANTSubCateDesc=""
		 	if (ANTSubCateCode'="") {
			 	set objANTSubCate = ##class(DHCMed.NINF.Dic.Cate).GetObjByCode(ANTSubCateCode)
			 	if $IsObject(objANTSubCate){set ANTSubCateDesc=objANTSubCate.Description}
			 }		 	
			//add by wuqk 2013-03-04 --- end---
			
		 	Set Data=$lb(ID,ANTCode,ANTDesc,ANTDesc1,ANTActive,ANTActiveDesc,ANTResume,ANTWhonet,ANTPinyin,ANTCateCode,ANTCateDesc,ANTSubCateCode,ANTSubCateDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryAntibioticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntibioticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntibioticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntibioticsExecute ]
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

/// w ##Class(DHCMed.NINFService.Dic.Antibiotics).ChangeDic()
ClassMethod ChangeDic()
{
	New
	Kill ^DHCMed.NINFD("Anti")
	Kill ^DHCMed.NINFDi("Anti")
	
	Set DicID=0,num=0
	For {
		Set DicID=$o(^DHCMed.INF.InfAntiDicD(DicID))
		Quit:DicID=""
		Set objDic=##Class(DHCMed.INF.InfAntiDic).GetObjById(DicID)
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
		Set flg=##Class(DHCMed.NINF.Dic.Antibiotics).Update(InputStr,$c(1))
	}
	
	Quit "ChangeDic() Over!"
}

/// Creator：     PanLei
/// CreatDate：   2012-07-31
/// Description:  导入抗生素字典
///               数据来源,检验系统的抗生素表CT_Antibiotics
/// Table：       DHCMed.NINF.Dic.Antibiotics
/// Return：      return>0:成功  return<=0:失败
/// W ##Class(DHCMed.NINFService.Dic.Antibiotics).ImportAntiDicByLab()
ClassMethod ImportAntiDicByLab() As %String
{
	New
	Kill ^DHCMed.NINFD("Anti")
	Kill ^DHCMed.NINFDi("Anti")
	
	//update by zf 20160308 数据池相关程序修改(检验)
	Set xID=0
	For {
		Set xID=$o(^DHCMed.DC.LIS.BTAntibioticsD,xID)
		Quit:xID=""
		
		Set obj=##class(DHCMed.DC.LIS.BTAntibiotics).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.Active'=1
		Set ANTCode=obj.Code
		Set ANTDesc=obj.CName
		
		Set InputStr="^"_ANTCode_"^"_ANTDesc_"^"_""_"^"_"1"_"^"_""
		Set flg=##Class(DHCMed.NINF.Dic.Antibiotics).Update(InputStr,"^")
	}
	
	Quit "ImportAntiDicByLab() Over!"
}

/// Creator：     zhufei
/// CreatDate：   2012-08-07
/// Description:  导入抗生素字典(whonet码)
/// Table：       DHCMed.NINF.Dic.Antibiotics
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINFService.Dic.Antibiotics).ImportAntiDic("","^")
ClassMethod ImportAntiDic(aInput As %String, aSeparate As %String) As %String
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
	Set ItemID=$o(^DHCMed.NINFDi("Anti",0,"IndexCode"," "_$zcvt(ItemCode,"U"),0))
	Set objItem=##class(DHCMed.NINF.Dic.Antibiotics).GetObjById(ItemID)
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
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,8)   //update by zhangxing 20121018
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,9)
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,10)
	
	Set flg=##Class(DHCMed.NINF.Dic.Antibiotics).Update(InputStr,"^")
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-10-20
/// Description:  查询抗生素
/// Table：       DHCMed.NINF.Dic.Antibiotics
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.Antibiotics","QryAntiToCombo","yx","1")
Query QryAntiToCombo(aAlias As %String, aIsActive As %String = "1") As %Query(ROWSPEC = "AntiID:%String,AntiCode:%String,AntiDesc:%String,AntiDesc1:%String,AntiActive:%String,AntiActiveDesc:%String,AntiResume:%String,AntiWhonet:%String,AntiPinyin:%String")
{
}

ClassMethod QryAntiToComboExecute(ByRef qHandle As %Binary, aAlias As %String, aIsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aAlias=$zcvt(aAlias,"U")
 	Set Code="",Count=0
 	For {
	 	Set Code=$o(^DHCMed.NINFDi("Anti",0,"IndexCode",Code))
	 	Quit:Code=""
	 	Set ID=0
	 	For {
		 	Set ID=$o(^DHCMed.NINFDi("Anti",0,"IndexCode",Code,ID))
		 	Quit:ID=""
			Quit:Count>100
		 	
		 	Set obj=##class(DHCMed.NINF.Dic.Antibiotics).GetObjById(ID)
		 	Continue:'$IsObject(obj)
		 	Set ANTCode=obj.ANTCode
		 	Set ANTDesc=obj.ANTDesc
		 	Set ANTDesc1=obj.ANTDesc1
		 	Set ANTPinyin=obj.ANTPinyin   //update by zhangxing 20121018
		 	Continue:(aAlias'="")&&($zcvt(ANTCode,"U")'[aAlias)&&($zcvt(ANTDesc,"U")'[aAlias)&&($zcvt(ANTDesc1,"U")'[aAlias)&&($zcvt(ANTPinyin,"U")'[aAlias)
		 	Set ANTActive=obj.ANTActive
		 	Continue:(aIsActive'="")&&(ANTActive'=aIsActive)
		 	Set ANTActiveDesc=$s(ANTActive=1:"是",1:"否")
		 	Set ANTResume=obj.ANTResume
		 	Set ANTWhonet=obj.ANTWhonet
		 	
			Set Count=Count+1
		 	Set Data=$lb(ID,ANTCode,ANTDesc,ANTDesc1,ANTActive,ANTActiveDesc,ANTResume,ANTWhonet,ANTPinyin)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryAntiToComboClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntiToComboExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntiToComboFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntiToComboExecute ]
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
