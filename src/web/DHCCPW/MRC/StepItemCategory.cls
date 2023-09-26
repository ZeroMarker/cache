/// 名称: web.DHCCPW.MRC.StepItemCategory
/// 描述：对临床路径项目大类的各种操作分别有添加，删除，修改，查询等操作
/// 编写者：李宇峰
/// 编写日期：2010-05-06
Class web.DHCCPW.MRC.StepItemCategory Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-12-16
/// Description:  根据Code取临床路径项目大类
/// Table：       User.DHCMRCStepItemCategory
/// Input：       ID:    User.DHCMRCStepItemCategory.ID
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.StepItemCategory).GetObjById(1)
ClassMethod GetObjById(argId As %String) As User.DHCMRCStepItemCategory
{
	New (argId)
	Set return=##Class(User.DHCMRCStepItemCategory).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-12-16
/// Description:  根据Code取临床路径项目大类
/// Table：       User.DHCMRCStepItemCategory
/// Input：       Code:    User.DHCMRCStepItemCategory.Code
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.StepItemCategory).GetObjByCode("01")
ClassMethod GetObjByCode(argCode As %String) As User.DHCMRCStepItemCategory
{
	New (argCode)
	Set return=""
	Quit:argCode="" return
	
	Set argId=0
	For {
		Set argId=$o(^DHCMRC("SIC",argId))
		Quit:argId=""
		Set objCateg=..GetObjById(argId)
		If $IsObject(objCateg) {
			Continue:objCateg.SICCode'=argCode
			Set return=objCateg
		}
	}
	Quit return
}

/// Creator:李宇峰
/// CreatDate:2010-05-06
/// Description:此Query是用来得到  临床路径项目大类  的所有记录。
/// Input:argItemCateType 0-不过滤日期；1-过滤开始结束日期
/// Table:User.DHCMRCStepItemCategory
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.StepItemCategory","GetStepItemCat")
Query GetStepItemCat(argItemCateType As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,DateFrom:%String,DateTo:%String")
{
}

ClassMethod GetStepItemCatExecute(ByRef qHandle As %Binary, argItemCateType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set argItemCateType=+$g(argItemCateType),DateCur=$p($h,",",1)	// Add by zhaoyu 2013-05-02 项目大类，开始日期不起作用 249
	Set CategID=0
	For {
		Set CategID=$o(^DHCMRC("SIC",CategID))
		Quit:CategID=""
		Set objCateg=..GetObjById(CategID)
		If $IsObject(objCateg) {
			Set Code=objCateg.SICCode
			Set Desc=objCateg.SICDesc
			Set DateFrom=objCateg.SICDateFrom
			Continue:(DateFrom'="")&&(argItemCateType=1)&&(DateFrom>DateCur)	// Add by zhaoyu 2013-05-02 项目大类，开始日期不起作用 249
			;Set:DateFrom'="" DateFrom=$zd(DateFrom,3)
			Set:DateFrom'="" DateFrom=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DateFrom)
			Set DateTo=objCateg.SICDateTo
			Continue:(DateTo'="")&&(argItemCateType=1)&&(DateTo<DateCur)	// Add by zhaoyu 2013-05-02 项目大类，开始日期不起作用 249
			;Set:DateTo'="" DateTo=$zd(DateTo,3)
			Set:DateTo'="" DateTo=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DateTo)
			
			Set Data=$lb(CategID,Code,Desc,DateFrom,DateTo)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod GetStepItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStepItemCatExecute ]
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

ClassMethod GetStepItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStepItemCatExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2011-01-29
/// Description:  保存临床路径项目大类
/// Table：       User.DHCMRCStepItemCategory
/// Input：       argInPut: 临床路径项目子类数据
/// Return：      return<0: 保存失败
/// w ##Class(web.DHCCPW.MRC.StepItemCategory).Update(argInput)
ClassMethod Update(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set ID=$p(argInput,"^",1)
	If ID="" {
		Set obj=##class(User.DHCMRCStepItemCategory).%New()
	} Else {
		Set obj=##class(User.DHCMRCStepItemCategory).%OpenId(ID)
		Quit:obj="" return
	}
	
	Set Code=$p(argInput,"^",2)
	Set Desc=$p(argInput,"^",3)
	Set DateFrom=$p(argInput,"^",4)
	Set:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	Set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	Set:DateFrom'="" DateFrom=+DateFrom
	Set DateTo=$p(argInput,"^",5)
	Set:DateTo["/" DateTo=$zdh(DateTo,4)
	Set:DateTo["-" DateTo=$zdh(DateTo,3)
	Set:DateTo'="" DateTo=+DateTo
	Quit:(Code="")||(Desc="") return
	
	Set obj.SICCode=Code               //代码
	Set obj.SICDesc=Desc               //描述
	Set obj.SICDateFrom=DateFrom       //开始日期
	Set obj.SICDateTo=DateTo           //结束日期
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
/// CreatDate:2010-05-06
/// Description:AddStepItemCat 添加一条临床路径项目大类 记录
/// Table:User.DHCMRCStepItemCategory
ClassMethod AddStepItemCat(Code As %String, Desc As %String, DateFrom As %String, DateTo As %String)
{
	New (Code,Desc,DateFrom,DateTo)
	Set return=-1
	Quit:(Code="")||(Desc="")||(DateFrom="") return
	
	Set InputStr=""_"^"_Code_"^"_Desc_"^"_DateFrom_"^"_DateTo
	Set return=..Update(InputStr)
	Quit return
}

/// Creator:李宇峰
/// CreatDate:2010-05-06
/// Description:UpdateStepItemCat 修改一条临床路径项目大类 记录
/// Table:User.DHCMRCStepItemCategory
ClassMethod UpdateStepItemCat(Rowid As %String, Code As %String, Desc As %String, DateFrom As %String, DateTo As %String)
{
	New (Rowid,Code,Desc,DateFrom,DateTo)
	Set return=-1
	Quit:(Rowid="")||(Code="")||(Desc="")||(DateFrom="") return
	
	Set InputStr=Rowid_"^"_Code_"^"_Desc_"^"_DateFrom_"^"_DateTo
	Set return=..Update(InputStr)
	Quit return
}

/// Creator:李宇峰
/// CreatDate:2010-05-06
/// Description:CheckItemCode 检查Code在临床路径项目大类的代码是否已经存在。
/// Table:User.DHCMRCStepItemCategory
/// w ##Class(web.DHCCPW.MRC.StepItemCategory).CheckItemCode("01",1)
ClassMethod CheckItemCode(argCode As %String, argCategID As %String)
{
	New (argCode,argCategID)
	Set return=0
	Quit:argCode="" return
	
	Set CategID=0
	For {
		Set CategID=$o(^DHCMRC("SIC",CategID))
		Quit:(CategID="")||(return=1)
		Continue:(argCategID'="")&(argCategID=CategID)
		
		Set objCateg=..GetObjById(CategID)
		If $IsObject(objCateg) {
			Set Code=objCateg.SICCode
			Continue:argCode'=Code
			Set return=1
		}
	}
	
	Quit return
}

/// Creator:李宇峰
/// CreatDate:2010-05-06
/// Description:DeleteStepItemCat 删除一条临床路径项目大类 记录
/// Table:User.DHCMRCStepItemCategory
/// w ##Class(web.DHCCPW.MRC.StepItemCategory).DeleteStepItemCat(3)
ClassMethod DeleteStepItemCat(argId As %String) As %String
{
	new (argId)
	set return=1
	set sc = ##class(User.DHCMRCStepItemCategory).%DeleteId(argId)
	if $system.Status.IsError(sc) {         //检查删除是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}
	quit return
}

}
