/// 名称: web.DHCCPW.MRC.StepItemSubCategory
/// 描述：对临床路径项目子类的各种操作分别有添加，删除，修改，查询等操作
/// 编写者：李宇峰
/// 编写日期：2010-05-07
Class web.DHCCPW.MRC.StepItemSubCategory Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-12-16
/// Description:  根据Code取临床路径项目子类
/// Table：       User.DHCMRCStepItemSubCategory
/// Input：       ID:    User.DHCMRCStepItemSubCategory.ID
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.StepItemSubCategory).GetObjById("1||1")
ClassMethod GetObjById(argId As %String) As User.DHCMRCStepItemSubCategory
{
	New (argId)
	Set return=##Class(User.DHCMRCStepItemSubCategory).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-05-15
/// Description:  根据Code取临床路径项目子类
/// Table：       User.DHCMRCStepItemSubCategory
/// Input：       ID:    User.DHCMRCStepItemSubCategory.ID
///               separete: 指定的分隔符
/// Return：      返回String
/// w ##class(web.DHCCPW.MRC.StepItemSubCategory).GetSubCatByDesc("重点医嘱")
ClassMethod GetSubCatByDesc(aDesc As %String) As %String
{
	New (aDesc)
	Set return=""
	Quit:aDesc="" return
	
	Set CategID=0
	For {
		Set CategID=$o(^DHCMRC("SIC",CategID))
		Quit:CategID=""
	
		Set objCateg=##class(web.DHCCPW.MRC.StepItemCategory).GetObjById(CategID)
		If $IsObject(objCateg) {
			Continue:objCateg.SICDesc'=aDesc
			Set CategSub=0
			For {
				Set CategSub=$o(^DHCMRC("SIC",CategID,"SUB",CategSub))
				Quit:CategSub=""
				Set CategSubID=CategID_"||"_CategSub
				Set objCategSub=##class(web.DHCCPW.MRC.StepItemSubCategory).GetObjById(CategSubID)
				If $IsObject(objCategSub) {
					Set Code=objCategSub.SISCCode
					Set Desc=objCategSub.SISCDesc
					Set return=return_Code_"^"_Desc_","
				}
			}
		}
		Set:(return'="") return=$e(return,1,$l(return)-1)
	}
	Quit return
}

/// Creator:      李宇峰
/// CreatDate:    2010-05-07
/// Description:  此Query是用来得到  临床路径项目子类  的所有记录。
/// Table:        User.DHCMRCStepItemSubCategory
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.StepItemSubCategory","GetStepItemSubCat","","","","","")
Query GetStepItemSubCat(argCategID As %String, argCode As %String, argDesc As %String, argDateFrom As %String, argDateTo As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,DateFrom:%String,DateTo:%String,ItemRowid:%String,ItemDesc:%String,SubCatPower:%String,SubCatPowerDesc:%String")
{
}

ClassMethod GetStepItemSubCatExecute(ByRef qHandle As %Binary, argCategID As %String, argCode As %String, argDesc As %String, argDateFrom As %String, argDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	
	Set CategID=0
	For {
		Set CategID=$o(^DHCMRC("SIC",CategID))
		Quit:CategID=""
		Continue:(argCategID'="")&&(argCategID'=CategID)
		Set CategSub=0
		For {
			Set CategSub=$o(^DHCMRC("SIC",CategID,"SUB",CategSub))
			Quit:CategSub=""
			Set CategSubID=CategID_"||"_CategSub
			Set objCategSub=##class(web.DHCCPW.MRC.StepItemSubCategory).GetObjById(CategSubID)
			If $IsObject(objCategSub) {
				Set Code=objCategSub.SISCCode
				Continue:(argCode'="")&&(argCode'=Code)
				Set Desc=objCategSub.SISCDesc
				Continue:(argDesc'="")&&(argDesc'=Desc)
				Set DateFrom=objCategSub.SISCDateFrom
				Continue:(DateFrom'="")&&(argDateFrom'="")&&(DateFrom>argDateFrom)
				Set:DateFrom'="" DateFrom=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DateFrom)
				Set DateTo=objCategSub.SISCDateTo
				Continue:(DateTo'="")&&(argDateTo'="")&&(DateTo<argDateTo)
				Set:DateTo'="" DateTo=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DateTo)
				Set Power=objCategSub.SISCPower
				Set PowerDesc=##class(web.DHCCPW.MRC.BaseConfig).GetDicByCode("ItemSubCatPower",Power)
				Set CategDesc=objCategSub.SISCParRef.SICDesc
				
				Set Data=$lb(CategSubID,Code,Desc,DateFrom,DateTo,CategID,CategDesc,Power,PowerDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod GetStepItemSubCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStepItemSubCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetStepItemSubCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStepItemSubCatExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// w ##Class(web.DHCCPW.MRC.StepItemSubCategory).CheckItemSubCode("01-01","1||1")
ClassMethod CheckItemSubCode(argCode As %String, argCategSubID As %String)
{
	New (argCode,argCategSubID)
	Set return=0
	Quit:argCode="" return
	
	Set CategID=0
	For {
		Set CategID=$o(^DHCMRC("SIC",CategID))
		Quit:(CategID="")||(return=1)
		
		Set CategSub=0
		For {
			Set CategSub=$o(^DHCMRC("SIC",CategID,"SUB",CategSub))
			Quit:(CategSub="")||(return=1)
			Set CategSubID=CategID_"||"_CategSub
			Continue:(argCategSubID'="")&&(argCategSubID=CategSubID)
			Set objCategSub=##class(web.DHCCPW.MRC.StepItemSubCategory).GetObjById(CategSubID)
			If $IsObject(objCategSub){
				Set Code=objCategSub.SISCCode
				Continue:argCode'=Code
				Set return=1
			}
		}
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-01-29
/// Description:  保存临床路径项目子类
/// Table：       User.DHCMRCStepItemSubCategory
/// Input：       argInPut: 临床路径项目子类数据
/// Return：      return<0: 保存失败
/// w ##Class(web.DHCCPW.MRC.StepItemSubCategory).Update(argInput)
ClassMethod Update(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set ParRef=$p(argInput,"^",1)
	Quit:ParRef="" return
	Set ChildSub=$p(argInput,"^",2)
	If ChildSub="" {
		Set obj=##class(User.DHCMRCStepItemSubCategory).%New()
	} Else {
		Set ID=ParRef_"||"_ChildSub
		Set obj=##class(User.DHCMRCStepItemSubCategory).%OpenId(ID)
		Quit:obj="" return
	}
	
	Set objParRef=##Class(User.DHCMRCStepItemCategory).%OpenId(ParRef)
	If objParRef'="" Do objParRef.%Close()
	
	Set Code=$p(argInput,"^",3)
	Set Desc=$p(argInput,"^",4)
	Set DateFrom=$p(argInput,"^",5)
	Set:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	Set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	Set:DateFrom'="" DateFrom=+DateFrom
	Set DateTo=$p(argInput,"^",6)
	Set:DateTo["/" DateTo=$zdh(DateTo,4)
	Set:DateTo["-" DateTo=$zdh(DateTo,3)
	Set:DateTo'="" DateTo=+DateTo
	Set Power=$p(argInput,"^",7)
	Quit:(Code="")||(Desc="")||(objParRef="") return
	
	Set obj.SISCParRef=objParRef
	Set obj.SISCCode=Code               //代码
	Set obj.SISCDesc=Desc               //描述
	Set obj.SISCDateFrom=DateFrom       //开始日期
	Set obj.SISCDateTo=DateTo           //结束日期
	Set obj.SISCPower=Power             //项目子类权限
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// Creator:李宇峰
/// CreatDate:2010-05-10
/// Description:AddItemSubCat  添加  一条临床路径项目子类记录 
/// Table:User.DHCMRCStepItemSubCategory
ClassMethod AddItemSubCat(ItemRowid As %String, Code As %String, Desc As %String, DateFrom As %String, DateTo As %String, ItemSubCatPower As %String)
{
	New (ItemRowid,Code,Desc,DateFrom,DateTo,ItemSubCatPower)
	Set return=-1
	Quit:(ItemRowid="")||(Code="")||(Desc="")||(DateFrom="") return
	
	Set InputStr=ItemRowid_"^"_""_"^"_Code_"^"_Desc_"^"_DateFrom_"^"_DateTo_"^"_ItemSubCatPower
	Set return=..Update(InputStr)
	Quit return
}

ClassMethod UpdateItemSubCat(ItemSubRowid As %String, Code As %String, Desc As %String, DateFrom As %String, DateTo As %String, ItemSubCatPower As %String)
{
	New (ItemSubRowid,Code,Desc,DateFrom,DateTo,ItemSubCatPower)
	Set return=-1
	Quit:(ItemSubRowid="")||(Code="")||(Desc="")||(DateFrom="") return
	
	Set CategID=$p(ItemSubRowid,"||",1)
	Set SubID=$p(ItemSubRowid,"||",2)
	Set InputStr=CategID_"^"_SubID_"^"_Code_"^"_Desc_"^"_DateFrom_"^"_DateTo_"^"_ItemSubCatPower
	Set return=..Update(InputStr)
	Quit return
}

/// w ##Class(web.DHCCPW.MRC.StepItemSubCategory).DeleteItemSubCat(argId)
ClassMethod DeleteItemSubCat(argId As %String) As %String
{
	new (argId)
	set return=1
	set sc = ##class(User.DHCMRCStepItemSubCategory).%DeleteId(argId)
	if $system.Status.IsError(sc) {         //检查删除是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}
	quit return
}

}
