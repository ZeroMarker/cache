/// creator:lulin
/// createdate:2019-12-02
/// description:敏感指标
Class web.NurSensConfigComm Extends %RegisteredObject
{

Parameter AdvType As COSEXPRESSION = "..SetAdvType()";

/// ---------------兼容性方法适用----------
/// Creator:lulin
/// Description:获取用户姓名
/// Date:2020-08-14
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetRegNoByEpisodeID(EpisodeID As %String = "") As %String
{
	q:EpisodeID="" ""
	s papmidr=$P(^PAADM(EpisodeID),"^",1)
	s regNo=""
	s:papmidr'="" regNo=$P($g(^PAPER(papmidr,"PAT",1)),"^",1)
	q regNo
}

/// Creator:lulin
/// Description:获取用户姓名
/// Date:2020-08-14
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetUserName(rw) As %String
{
	s ret=""
	q:rw="" ""
	q:rw=0 "超级管理员"
	i $LG($G(^CT.DHCINM.Set.MgArgParamSetD(1)),24)="Y" d
	.s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(rw)
	.s:$IsObject(userObj) ret=userObj.UserName
	e  d
	.s perObj=##class(DHCNS.DB.NsPersons).%OpenId(rw)
	.s:$IsObject(perObj) ret=perObj.PerName
	q ret
}

/// Creator:lulin
/// Description:获取用户姓名
/// Date:2020-08-14
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod SetTmpWard(tmpWard) As %String
{
	i $LG($G(^CT.DHCINM.Set.MgArgParamSetD(1)),24)="Y" d
	.s sort="" f  s sort=$O(^CF.DHCINM.DB.MgWardI("Sort",sort)) q:sort=""  d
	..s wardId="" f  s wardId=$O(^CF.DHCINM.DB.MgWardI("Sort",sort,wardId)) q:wardId=""  d
	...s tmpWard(sort,wardId)=wardId
	e  d
	.s sort="" f  s sort=$O(^DHCNS.DB.NsWardI("Sort",sort)) q:sort=""  d
	..s wardId="" f  s wardId=$O(^DHCNS.DB.NsWardI("Sort",sort,wardId)) q:wardId=""  d
	...s tmpWard(sort,wardId)=wardId
}

/// Creator:lulin
/// Description:获取用户姓名
/// Date:2020-08-14
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod SetTmpWardByID(tmpWard) As %String
{
	i $LG($G(^CT.DHCINM.Set.MgArgParamSetD(1)),24)="Y" d
	.s sort="" f  s sort=$O(^CF.DHCINM.DB.MgWardI("Sort",sort)) q:sort=""  d
	..s wardId="" f  s wardId=$O(^CF.DHCINM.DB.MgWardI("Sort",sort,wardId)) q:wardId=""  d
	...s tmpWard(wardId)=wardId
	e  d
	.s sort="" f  s sort=$O(^DHCNS.DB.NsWardI("Sort",sort)) q:sort=""  d
	..s wardId="" f  s wardId=$O(^DHCNS.DB.NsWardI("Sort",sort,wardId)) q:wardId=""  d
	...s tmpWard(wardId)=wardId
}

/// Creator:lulin
/// Description:病区科室关联索引
/// Date:2020-08-14
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod SetTmpWardLocUnit(tmpWardLocUnit) As %String
{
	i $LG($G(^CT.DHCINM.Set.MgArgParamSetD(1)),24)="Y" d
	.merge tmpWardLocUnit=^CF.DHCINM.DB.MgWardLocUnitI
	e  d
	.merge tmpWardLocUnit=^DHCNS.DB.NsWardLocUnitI
}

/// Creator:lulin
/// Description:病区索引
/// Date:2020-08-14
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod SetTmpWardI(tmpWardI) As %String
{
	i $LG($G(^CT.DHCINM.Set.MgArgParamSetD(1)),24)="Y" d
	.merge tmpWardI=^CF.DHCINM.DB.MgWardI
	e  d
	.merge tmpWardI=^DHCNS.DB.NsWardI
}

/// Creator:lulin
/// Description:获取用户姓名
/// Date:2020-08-14
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetUserWard(rw) As %String
{
	s ret=""
	q:rw="" ""
	q:rw=0 "超级管理员"
	i $LG($G(^CT.DHCINM.Set.MgArgParamSetD(1)),24)="Y" d
	.s perId=$LG($G(^CF.DHCINM.DB.MgUserD(rw)),5)
	.s ret=$LG($G(^CF.DHCINM.DB.MgUserD(rw)),9)
	.i ((perId'="")&&(ret'="")) d
	..s ret=$LG($G(^CF.DHCINM.HR.PersonsD(rw)),10)
	e  d
	.s ret=$LG($G(^DHCNS.DB.NsPersonsD(rw)),4)
	q ret
}

/// Creator:lulin
/// Description:获取医院名称
/// Date:2020-08-14
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetHospitalName(rw) As %String
{
	s ret=""
	q:rw="" ""
	i $LG($G(^CT.DHCINM.Set.MgArgParamSetD(1)),24)="Y" d
	.s ret=$LG($G(^CF.DHCINM.DB.MgHospitalSetD(rw)),2)
	e  d
	.s ret=$LG($G(^DHCNS.DB.NsHospitalSetD(rw)),2)
	q ret
}

/// -------------分割线--兼容性方法适用-----------------
/// Creator:lulin
/// Description:保存类别
/// Date:2019-12-02
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod SaveSensType(parr As %String = "") As %String
{
	q:parr="" "数据为空,无法保存"
	s tmp=""
	d ##class(web.NurSensUtilComm).SplitStr(parr,"^","|",.tmp)
	s Code=$g(tmp("Code"))
	q:Code="" "编码不能为空"
	s existCodeRW=$O(^CT.DHCNS.Config.NsTypeSetI("Code"," "_$zcvt(Code,"U"),""))
	q:(existCodeRW'="")&&(existCodeRW'=$g(tmp("rw"))) "编码冲突"
	i $g(tmp("rw"))'="" d
	.s obj=##class(CT.DHCNS.Config.NsTypeSet).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(CT.DHCNS.Config.NsTypeSet).%New()
	s obj.Code=Code
	s obj.TypeDesc=$g(tmp("TypeDesc"))
	s obj.Status=$g(tmp("Status"))
	s obj.Remark=$g(tmp("Remark"))
	s sc=$$$ISOK(obj.%Save())
	q sc
}

/// Creator:lulin
/// Description:查询类别
/// Date:2019-12-03
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetSensType(id As %String = "") As %String
{
	q:id="" ""
	s obj=##class(CT.DHCNS.Config.NsTypeSet).%OpenId(id)
	q:'$IsObject(obj) ""
	s ret="Code|"_obj.Code
	s ret=ret_"^TypeDesc|"_obj.TypeDesc
	s ret=ret_"^Status|"_obj.Status
	s StatusDesc="启用"
	s:obj.Status'="Y" StatusDesc="停用"
	s ret=ret_"^StatusDesc|"_StatusDesc
	s ret=ret_"^Remark|"_obj.Remark
	s ret=ret_"^rw|"_id
	q ret
}

/// Creator:lulin
/// Description:查询类别列表
/// Date:2019-12-03
/// Table:
/// Input:
/// Output：
/// Others:
Query FindSensTypeList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSensTypeListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s status=$P(parr,"^",1)
	s ret=""
	s id="" f  s id=$O(^CT.DHCNS.Config.NsTypeSetD(id)) q:id=""  d
	.s obj=##class(CT.DHCNS.Config.NsTypeSet).%OpenId(id)
	.q:'$IsObject(obj)
	.q:((status'="")&&(status="Y")&&(obj.Status'="Y"))
	.s ret=..GetSensType(id)
	.d OutPutRowData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSensTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSensTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSensTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSensTypeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:lulin
/// Description:判断某元素是否已被使用
/// Date:2019-12-05
/// Table:
/// Input:
/// Output：0:未被使用，"****":被****使用
/// Others:
ClassMethod IsUsedElement(id As %String = "") As %String
{
	q:id="" 0
	s ret=""
	s relateId="" f  s relateId=$O(^CT.DHCNS.Config.NsElementSubI("End",id,relateId)) q:relateId=""  d
	.s obj=##class(CT.DHCNS.Config.NsElement).%OpenId(relateId)
	.q:'$IsObject(obj)
	.;q:obj.Status'="Y" //放开需要跟着放开保存计算的元素启用时引用的元素都为启动
	.i ret="" s ret="【元素:["_obj.ID_"]"_obj.EleDesc_"】"
	.e  s ret=ret_";"_"【元素:["_obj.ID_"]"_obj.EleDesc_"】"
	s indexId="" f  s indexId=$O(^CT.DHCNS.Config.NsIndexSubI("Prop",id,indexId)) q:indexId=""  d
	.s indexObj=##class(CT.DHCNS.Config.NsIndex).%OpenId(indexId)
	.q:'$IsObject(indexObj)
	.;q:indexObj.Status'="Y" //放开需要跟着放开保存指标启用时引用的元素都为启动
	.i ret="" s ret="【指标:"_indexObj.IndexDesc_"】"
	.e  s ret=ret_";"_"【指标:"_indexObj.IndexDesc_"】"
	s modelId="" f  s modelId=$O(^CF.DHCNS.Config.NsModelSubI("Prop"," E",id,modelId)) q:modelId=""  d
	.s modelObj=##class(CF.DHCNS.Config.NsModel).%OpenId(modelId)
	.q:'$IsObject(modelObj)
	.i ret="" s ret="【模板:"_modelObj.ModelDesc_"】"
	.e  s ret=ret_";【模板:"_modelObj.ModelDesc_"】"
	s:ret="" ret=0
	q ret
}

/// Creator:lulin
/// Description:保存元素
/// Date:2019-12-04
/// Table:
/// Input:
/// Output：
/// Others:w ##class(web.NurSensConfigComm).SaveSensElement("")
ClassMethod SaveSensElement(parr As %String = "") As %String
{
	s ^TMP("SaveSensElement")=parr
	q:parr="" "数据为空,无法保存"
	s tmp=""
	d ##class(web.NurSensUtilComm).SplitStr(parr,"^","|",.tmp)
	s ID=$g(tmp("ID"))
	q:ID="" "ID不能为空"
	s existCodeRW=$O(^CT.DHCNS.Config.NsElementI("ID"," "_$zcvt(ID,"U"),""))
	q:(existCodeRW'="")&&(existCodeRW'=$g(tmp("rw"))) "ID冲突"
	//判断元素是否被使用，如果被使用且状态是停用则返回错误
	s Status=$g(tmp("Status"))
	;s usedObject=..IsUsedElement($g(tmp("rw")))
	;q:(usedObject'=0)&&(Status'="Y") "此元素已被"_usedObject_"使用,不可停用"
	i $g(tmp("rw"))'="" d
	.s obj=##class(CT.DHCNS.Config.NsElement).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(CT.DHCNS.Config.NsElement).%New()
	s obj.ID=ID
	s obj.EleDesc=$g(tmp("EleDesc"))
	s obj.EleClass=$g(tmp("EleClass"))
	
	s obj.Rate=$g(tmp("Rate"))
	s DataMode=$g(tmp("DataMode"))
	s obj.DataMode=DataMode
	s obj.Remark=$g(tmp("Remark"))
	s obj.KeyWord=$g(tmp("KeyWord"))
	s obj.ClassName=$g(tmp("ClassName"))
	s obj.MethodName=$g(tmp("MethodName"))
	s obj.MethodParam=$g(tmp("MethodParam"))
	s obj.AutoType=$g(tmp("AutoType"))
	s obj.DualType=$g(tmp("DualType"))
	s obj.NurMgType=$g(tmp("NurMgType"))
	s obj.NurMgSubType=$g(tmp("NurMgSubType"))
	s obj.NurMgSubTypeID=$g(tmp("NurMgSubTypeID"))
	s obj.SenioritySt=$g(tmp("SenioritySt"))
	s obj.SeniorityEnd=$g(tmp("SeniorityEnd"))
	s obj.AdvType=$g(tmp("AdvType"))
	s obj.AdvDual=$g(tmp("AdvDual"))
	s obj.PatType=$g(tmp("PatType"))
	s obj.OrderType=$g(tmp("OrderType"))
	s obj.IsNoBaby=$g(tmp("IsNoBaby"))
	s obj.IsRegister=$g(tmp("IsRegister"))
	s obj.IsOnlyWard=$g(tmp("IsOnlyWard"))
	s obj.IsOnlyInWard=$g(tmp("IsOnlyInWard"))
	s obj.IsDuty=$g(tmp("IsDuty"))
	s obj.PatSubType=$g(tmp("PatSubType"))
	s obj.InfType=$g(tmp("InfType"))
	s obj.PatSubValue=$g(tmp("PatSubValue"))
	s obj.PatSubValueType=$g(tmp("PatSubValueType"))
	s obj.PatSubEndValue=$g(tmp("PatSubEndValue"))
	s obj.RepeatFlag=$g(tmp("RepeatFlag"))
	s orderTime=$g(tmp("OrderTime"))
	i orderTime'="" d
	.s orderTime=$zth(orderTime,2)
	s obj.OrderTime=orderTime
	s obj.Status=Status
	d obj.OtherNum.Clear()
	s OtherNum=$g(tmp("OtherNum"))
	f i=1:1:$L(OtherNum,"「") d
	.s tValue=$P(OtherNum,"「",i)
	.q:tValue=""
	.d obj.OtherNum.Insert(tValue)
	;过滤病区
	d obj.FilterWard.Clear()
	s FilterWard=$g(tmp("FilterWard"))
	f i=1:1:$L(FilterWard,",") d
	.s tFilterWard=$P(FilterWard,",",i)
	.q:tFilterWard=""
	.d obj.FilterWard.Insert(tFilterWard)
	s flag=1
	TS
	s flag=flag&&$$$ISOK(obj.%Save())
	if flag'=1 {
		TRO
		q "保存失败"	
	}
	//先删除
	s subId="" f  s subId=$O(^CT.DHCNS.Config.NsElementSubD(obj.%Id(),subId)) q:(subId="")||(flag'=1)  d
	.s subObj=##class(CT.DHCNS.Config.NsElementSub).%OpenId(obj.%Id()_"||"_subId)
	.q:'$IsObject(subObj)
	.s flag=flag&&subObj.%DeleteId(obj.%Id()_"||"_subId)
	if flag'=1 {
		TRO
		q "删除关联数据失败"	
	}
	s subData=$g(tmp("subData"))
	f i=1:1:$L(subData,"「")  q:flag'=1  d
	.s subValue=$P(subData,"「",i)
	.q:subValue=""
	.s subRw=$P(subValue,"」",1)
	.s relateObj=##class(CT.DHCNS.Config.NsElement).%OpenId(subRw)
	.q:'$IsObject(relateObj)
	.s subType=$P(subValue,"」",2)
	.q:subType=""
	.s subObj=##class(CT.DHCNS.Config.NsElementSub).%New()
	.s subObj.Parref=obj
	.s subObj.EndEleDR=relateObj
	.s subObj.Type=subType
	.s flag=flag&&$$$ISOK(subObj.%Save())
	if flag'=1 {
		TRO
		q "保存关联数据失败"	
	}else{
		TC
		q 1	
	}
}

/// Creator:lulin
/// Description:获取元素
/// Date:2019-12-03
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetSensElement(id As %String = "") As %String
{
	q:id="" ""
	s obj=##class(CT.DHCNS.Config.NsElement).%OpenId(id)
	q:'$IsObject(obj) ""
	s ID=obj.ID
    s Status=obj.Status
    s StatusDesc=$case(Status,"Y":"启用","N":"停用",:"")
    s EleClass=obj.EleClass,EleClassDesc=""
    i $LG($G(^CT.DHCINM.Set.MgArgParamSetD(1)),24)="Y" d
    .s eleClassObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(EleClass)
    e  d
    .s eleClassObj=##class(DHCNS.Set.NsSysParamSub).%OpenId(EleClass)
    i $IsObject(eleClassObj) d
    .s EleClassDesc=eleClassObj.SubDesc
    s Rate=obj.Rate
    s RateDesc=$case(Rate,"D":"日","W":"周","M":"月","Q":"季","H":"半年","Y":"年",:"")
    s DataMode=obj.DataMode
    s DataModeDesc=$case(DataMode,"A":"自动","C":"计算","M":"手动",:"")
    s AutoType=obj.AutoType
    s AdvType=obj.AdvType
    s PatType=obj.PatType
    s OrderType=obj.OrderType
    s AdvDual=obj.AdvDual
    s OrderTime=obj.OrderTime
    s:OrderTime'="" OrderTime=$zt(OrderTime,2)
    s IsNoBaby=obj.IsNoBaby
    s:IsNoBaby="" IsNoBaby="Y"
    s IsRegister=obj.IsRegister
    s:IsRegister="" IsRegister="Y"
    s IsDuty=obj.IsDuty
    s:IsDuty="" IsDuty="Y"
    s IsOnlyWard=obj.IsOnlyWard
    s:IsOnlyWard="" IsOnlyWard="N"
    s IsOnlyInWard=obj.IsOnlyInWard
    s:IsOnlyInWard="" IsOnlyInWard="N"
    s OtherNum=""
	f i=1:1:obj.OtherNum.Count()  d
	.s tValue=obj.OtherNum.GetAt(i)
	.q:tValue=""
	.i OtherNum="" s OtherNum=tValue
	.e  s OtherNum=OtherNum_"「"_tValue
	s FilterWard=""
	f i=1:1:obj.FilterWard.Count()  d
	.s tValue=obj.FilterWard.GetAt(i)
	.q:tValue=""
	.i FilterWard="" s FilterWard=tValue
	.e  s FilterWard=FilterWard_","_tValue
	s PatSubType=obj.PatSubType
	s ret="ID|"_obj.ID_"^EleDesc|"_obj.EleDesc_"^Rate|"_Rate_"^RateDesc|"_RateDesc_"^DataMode|"_DataMode_"^DataModeDesc|"_DataModeDesc
	_"^EleClass|"_EleClass_"^EleClassDesc|"_EleClassDesc_"^Status|"_Status_"^StatusDesc|"_StatusDesc
	_"^Remark|"_obj.Remark_"^KeyWord|"_obj.KeyWord_"^ClassName|"_obj.ClassName_"^MethodName|"_obj.MethodName_"^MethodParam|"_obj.MethodParam
	_"^NurMgType|"_obj.NurMgType_"^NurMgSubType|"_obj.NurMgSubType_"^NurMgSubTypeID|"_obj.NurMgSubTypeID
	_"^SenioritySt|"_obj.SenioritySt_"^SeniorityEnd|"_obj.SeniorityEnd_"^DualType|"_obj.DualType
	_"^AutoType|"_AutoType_"^AdvType|"_AdvType_"^AdvDual|"_AdvDual_"^PatType|"_PatType_"^OrderType|"_OrderType
	_"^OrderTime|"_OrderTime_"^IsNoBaby|"_IsNoBaby_"^IsRegister|"_IsRegister_"^IsDuty|"_IsDuty
	_"^OtherNum|"_OtherNum_"^IsOnlyWard|"_IsOnlyWard_"^IsOnlyInWard|"_IsOnlyInWard_"^FilterWard|"_FilterWard
	_"^InfType|"_obj.InfType_"^PatSubType|"_PatSubType_"^PatSubValue|"_obj.PatSubValue_"^PatSubValueType|"_obj.PatSubValueType
	_"^PatSubEndValue|"_obj.PatSubEndValue_"^RepeatFlag|"_obj.RepeatFlag
	_"^rw|"_obj.%Id()
	q ret
}

/// Creator:lulin
/// Description:查询元素列表
/// Date:2019-12-03
/// Table:
/// Input:条件(元素分类、状态、频率、数据来源、时段计算方式、自动方式)，模糊查询,isEnd:是否只需非计算的,1:是，""：否
/// Output：
/// Others:d ##class(%ResultSet).RunQuery("web.NurSensConfigComm","FindSensElementList","2__1^^^^^","")
Query FindSensElementList(parr As %String = "", input As %String = "", isEnd As %String = "", findRw As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSensElementListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", isEnd As %String = "", findRw As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s indexClass=$tr($P(parr,"^",1),"__","||") //元素分类
	s status=$P(parr,"^",2) //状态
	s rate=$P(parr,"^",3) //频率
	s findModel=$P(parr,"^",4) //数据来源[自动、计算、手动]
	s dualType=$P(parr,"^",5) //日期段计算方式
	s autoType=$P(parr,"^",6)
	s eleID="" f  s eleID=$O(^CT.DHCNS.Config.NsElementI("ID",eleID)) q:eleID=""  d
	.s id="" f  s id=$O(^CT.DHCNS.Config.NsElementI("ID",eleID,id)) q:id=""  d
	..q:(findRw'="")&&(findRw=id)
	..s obj=##class(CT.DHCNS.Config.NsElement).%OpenId(id)
	..q:'$IsObject(obj)
	..q:(isEnd=1)&&(obj.DataMode'="A")&&(obj.DataMode'="M")
	..q:(findModel'="")&&(obj.DataMode'=findModel)
	..q:(indexClass'="")&&(obj.EleClass'=indexClass)
	..q:(status'="")&&(obj.Status'=status)
	..q:(rate'="")&&(obj.Rate'=rate)
	..q:(dualType'="")&&(obj.DualType'=dualType)
	..q:(autoType'="")&&(obj.AutoType'=autoType)
	..s ID=obj.ID
	..s EleDesc=obj.EleDesc
	..s KeyWord=obj.KeyWord
	..s shellName=##class(web.NurSensUtilComm).ToChineseSpell(EleDesc_KeyWord)
	..q:(input'="")&&((ID_EleDesc_KeyWord)'[($ZCVT(input,"U")))&&(((shellName)'[($ZCVT(input,"U"))))
	..s ret=..GetSensElement(id)
	..d OutPutRowData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSensElementListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSensElementListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSensElementListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSensElementListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:lulin
/// Description:查询元素子类列表
/// Date:2019-12-03
/// Table:
/// Input:id,父表id
/// Output：
/// Others:d ##class(%ResultSet).RunQuery("web.NurSensConfigComm","FindSensElementSubList","1")
Query FindSensElementSubList(par As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSensElementSubListExecute(ByRef qHandle As %Binary, par As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	if par="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s subId="" f  s subId=$O(^CT.DHCNS.Config.NsElementSubD(par,subId)) q:subId=""  d
	.s subObj=##class(CT.DHCNS.Config.NsElementSub).%OpenId(par_"||"_subId)
	.q:'$IsObject(subObj)
	.q:'$IsObject(subObj.Parref)
	.q:'$IsObject(subObj.EndEleDR)
	.q:subObj.Type=""
	.s subDesc="["_subObj.EndEleDR.ID_"]"_subObj.EndEleDR.EleDesc
	.s subType=subObj.Type
	.s subTypeDesc=$case(subType,"Y":"+","N":"-",:"+")
	.s ret="subDesc|"_subDesc_"^subType|"_subType_"^subTypeDesc|"_subTypeDesc
	.s ret=ret_"^EndEleDR|"_subObj.EndEleDR.%Id()
	.d OutPutRowData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSensElementSubListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSensElementSubListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSensElementSubListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSensElementSubListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:lulin
/// Description:判断指标是否被用
/// Date:2019-12-04
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod IsUsedIndex(id) As %String
{
	q:id="" 0
	s ret=""
	s modelId="" f  s modelId=$O(^CF.DHCNS.Config.NsModelSubI("Prop"," I",id,modelId)) q:modelId=""  d
	.s modelObj=##class(CF.DHCNS.Config.NsModel).%OpenId(modelId)
	.q:'$IsObject(modelObj)
	.i ret="" s ret="【模板："_modelObj.ModelDesc_"】"
	.e  s ret=ret_";【模板"_modelObj.ModelDesc_"】"
	s:ret="" ret=0
	q ret
}

/// Creator:lulin
/// Description:保存指标
/// Date:2019-12-13
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod SaveSensIndex(parr As %String = "") As %String
{
	q:parr="" "入参为空"
	s ^TMP("SaveSensIndex")=parr
	s tmp=""
	d ##class(web.NurSensUtilComm).SplitStr(parr,"^","|",.tmp)
	s rw=$G(tmp("rw"))
	//判断指标是否被使用，如果被使用且状态是停用则返回错误
	s Status=$g(tmp("Status"))
	s usedObject=..IsUsedIndex(rw)
	q:(usedObject'=0)&&(Status'="Y") "此指标已被"_usedObject_"使用,不可停用"
	s ret=""
	i rw'=""  d
	.s obj=##class(CT.DHCNS.Config.NsIndex).%OpenId(rw)
	e  d
	.s obj=##class(CT.DHCNS.Config.NsIndex).%New()
	s IndexType=$g(tmp("IndexType"))
	i IndexType'="" d
	.s indexTypeObj=##class(CT.DHCNS.Config.NsTypeSet).%OpenId(IndexType)
	.i $IsObject(indexTypeObj) s obj.IndexType=indexTypeObj
	s className="CT.DHCNS.Config.NsIndex"
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p["ChildSub"
	.q:p["Parref"
	.q:p["IndexType"
	.q:p["TableData"
	.q:p["Review"
	.q:p["NumOther"
	.q:p["DenOther"
	.q:p["FilterWard"
	.i $D(tmp(p)) d
	..s $ZOBJPROPERTY(obj,p)=$tr(tmp(p),"__","||")
	
	;过滤病区
	d obj.FilterWard.Clear()
	s FilterWard=$g(tmp("FilterWard"))
	f i=1:1:$L(FilterWard,",") d
	.s tFilterWard=$P(FilterWard,",",i)
	.q:tFilterWard=""
	.d obj.FilterWard.Insert(tFilterWard)
	;关联评审
	d obj.Review.Clear()
	s Review=$g(tmp("Review"))
	f i=1:1:$L(Review,",") d
	.s tReview=$P(Review,",",i)
	.q:tReview=""
	.d obj.Review.Insert(tReview)
	;指标异常通知人员
	d obj.ExcepTableData.Clear()
	s ExcepTableData=$g(tmp("ExcepTableData"))
	f i=1:1:$L(ExcepTableData,",") d
	.s tValue=$P(ExcepTableData,",",i)
	.q:tValue=""
	.d obj.ExcepTableData.Insert(tValue)
	;指标预警通知人员
	d obj.WarnTableData.Clear()
	s WarnTableData=$g(tmp("WarnTableData"))
	f i=1:1:$L(WarnTableData,",") d
	.s tValue=$P(WarnTableData,",",i)
	.q:tValue=""
	.d obj.WarnTableData.Insert(tValue)
	;指标停用通知人员
	d obj.StopTableData.Clear()
	s StopTableData=$g(tmp("StopTableData"))
	f i=1:1:$L(StopTableData,",") d
	.s tValue=$P(StopTableData,",",i)
	.q:tValue=""
	.d obj.StopTableData.Insert(tValue)
	;分子额外数
	d obj.NumOther.Clear()
	s NumOther=$g(tmp("NumOther"))
	f i=1:1:$L(NumOther,"「") d
	.s tValue=$P(NumOther,"「",i)
	.q:tValue=""
	.d obj.NumOther.Insert(tValue)
	;分母额外数
	d obj.DenOther.Clear()
	s DenOther=$g(tmp("DenOther"))
	f i=1:1:$L(DenOther,"「") d
	.s tValue=$P(DenOther,"「",i)
	.q:tValue=""
	.d obj.DenOther.Insert(tValue)
	TS
	s sc=$$$ISOK(obj.%Save())
	if sc'=1{
		TRO
		q "保存失败"
	}
	//清空子表
	s subid="" f  s subid=$O(^CT.DHCNS.Config.NsIndexSubD(obj.%Id(),subid)) q:(subid="")||(sc'=1)  d
	.s subObj=##class(CT.DHCNS.Config.NsIndexSub).%OpenId(obj.%Id()_"||"_subid)
	.q:'$IsObject(subObj)
	.s sc=sc&&subObj.%DeleteId(obj.%Id()_"||"_subid)
	if 'sc{
		TRO
		q "保存失败-重置分子分母信息失败"		
	}
	;添加子表信息
	s subTmp("N")=$G(tmp("Num")),subTmp("NR")=$G(tmp("NumRemove"))
	s subTmp("D")=$G(tmp("Den")),subTmp("DR")=$G(tmp("DenRemove"))
	s subType="" f  s subType=$O(subTmp(subType)) q:(subType="")||(sc'=1)  d
	.s SubData=subTmp(subType)
	.q:SubData=""
	.f i=1:1:$L(SubData,",") q:sc'=1  d
	..s eleId=$P(SubData,",",i)
	..q:eleId=""
	..s subEleObj=##class(CT.DHCNS.Config.NsElement).%OpenId(eleId)
	..q:'$IsObject(subEleObj)
	..s subObj=##class(CT.DHCNS.Config.NsIndexSub).%New()
	..s subObj.Parref=obj
	..s subObj.SubProp=subEleObj
	..s subObj.SubType=subType
	..s sc=sc&&$$$ISOK(subObj.%Save())
	if 'sc{
		TRO
		q "保存失败-保存分子分母信息失败"	
	}else{
		TC
		q 1
	}
}

/// Creator:lulin
/// Description:获取指标
/// Date:2019-12-13
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetSensIndex(id As %String = "") As %String
{
	q:id="" ""
	s obj=##class(CT.DHCNS.Config.NsIndex).%OpenId(id)
	q:'$IsObject(obj) ""
	s IndexType="",IndexTypeDesc=""
	i $IsObject(obj.IndexType)  d
	.s IndexType=obj.IndexType.%Id(),IndexTypeDesc=obj.IndexType.TypeDesc
	s ret="rw|"_id_"^IndexType|"_IndexType_"^IndexTypeDesc|"_IndexTypeDesc
	s className="CT.DHCNS.Config.NsIndex"
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p["ChildSub"
	.q:p["Parref"
	.q:p["IndexType"  //类别
	.q:p["Review" //评审
	.q:p["FilterWard"
	.s value=$ZOBJPROPERTY(obj,p)
	.i p["TableData"  d
	..s tableData=""
	..f i=1:1:value.Count()  d
	...s perId=value.GetAt(i)
	...q:perId=""
	...s perName=..GetUserName(perId)
	...s WardId=..GetUserWard(perId)
	...s WardDesc=""
	...s wardObj=##class(DHCNS.Config.NsWard).%New(WardId)
	...s WardDesc=wardObj.Desc
	...i tableData="" s tableData=perId_"」"_perName_"」"_WardDesc
	...e  s tableData=tableData_"「"_perId_"」"_perName_"」"_WardDesc
	..s value=tableData
	.e  i (p["NumOther")||(p["DenOther") d
	..s tableData=""
	..f i=1:1:value.Count()  d
	...s tValue=value.GetAt(i)
	...q:tValue=""
	...i tableData="" s tableData=tValue
	...e  s tableData=tableData_"「"_tValue
	..s value=tableData
	.s ret=ret_"^"_p_"|"_value
	s Review=""
	f i=1:1:obj.Review.Count()  d
	.s tValue=obj.Review.GetAt(i)
	.q:tValue=""
	.i Review="" s Review=tValue
	.e  s Review=Review_","_tValue
	s ret=ret_"^Review|"_Review
	s FilterWard=""
	f i=1:1:obj.FilterWard.Count()  d
	.s tValue=obj.FilterWard.GetAt(i)
	.q:tValue=""
	.i FilterWard="" s FilterWard=tValue
	.e  s FilterWard=FilterWard_","_tValue
	s ret=ret_"^FilterWard|"_FilterWard
	s subTmp("N")="Num",subTmp("NR")="NumRemove"
	s subTmp("D")="Den",subTmp("DR")="DenRemove"
	s subType=""  f  s subType=$O(^CT.DHCNS.Config.NsIndexSubI("Type",id,subType)) q:subType=""  d
	.s key=$g(subTmp($tr(subType," ","")))
	.q:key=""
	.s subValue=""
	.s subId=""  f  s subId=$O(^CT.DHCNS.Config.NsIndexSubI("Type",id,subType,subId)) q:subId=""  d
	..s subObj=##class(CT.DHCNS.Config.NsIndexSub).%OpenId(id_"||"_subId)
	..q:'$IsObject(subObj)
	..q:'$IsObject(subObj.SubProp)
	..i subValue="" s subValue=subObj.SubProp.%Id()
	..e  s subValue=subValue_","_subObj.SubProp.%Id()
	.i subValue'="" d
	..s ret=ret_"^"_key_"|"_subValue
	q ret
}

/// Creator:lulin
/// Description:查询类别列表
/// Date:2019-12-13
/// Table:
/// Input:条件，模糊查询
/// Output：
/// Others:
Query FindSensIndexList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSensIndexListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp) 
	s ind=1
	s ret=""
	s findType=$P(parr,"^",1)
	s findStatus=$P(parr,"^",2)
	s findRate=$P(parr,"^",3)
	s id="" f  s id=$O(^CT.DHCNS.Config.NsIndexD(id)) q:id=""  d
	.s obj=##class(CT.DHCNS.Config.NsIndex).%OpenId(id)
	.q:'$IsObject(obj)
	.q:(findStatus'="")&&(findStatus'=obj.Status)
	.q:(findType'="")&&('$IsObject(obj.IndexType))
	.q:(findType'="")&&(findType'=obj.IndexType.%Id())
	.q:(findRate'="")&&(findRate'=obj.Rate)
	.s IndexDesc=obj.IndexDesc
	.s shellName=##class(web.NurSensUtilComm).ToChineseSpell(IndexDesc)
	.q:(input'="")&&((IndexDesc)'[($ZCVT(input,"U")))&&(((shellName)'[($ZCVT(input,"U"))))
	.s ret=..GetSensIndex(id)
	.d OutPutRowData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSensIndexListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSensIndexListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSensIndexListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSensIndexListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:lulin
/// Description:保存模板数据
/// Date:2019-12-14
/// Table:
/// Input:
/// Output：
/// Others:w ##class(web.NurSensConfigComm).SaveSensModel(^TMP("SaveSensModel"))
ClassMethod SaveSensModel(parr, SubData) As %String
{
	//ModelUse|C^UseLimit|1,3"
	s ^TMP("SaveSensModel")=parr
	q:parr="" "数据为空,无法保存"
	q:SubData="" "请选择统计项目"
	s tmp=""
	d ##class(web.NurSensUtilComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(CF.DHCNS.Config.NsModel).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(CF.DHCNS.Config.NsModel).%New()
	s ModelType=$g(tmp("ModelType"))
	i ModelType'="" d
	.s ModelTypeObj=##class(CT.DHCNS.Config.NsTypeSet).%OpenId(ModelType)
	.i $IsObject(ModelTypeObj) s obj.ModelType=ModelTypeObj
	s obj.Rate=$g(tmp("Rate"))
	s obj.ModelDesc=$g(tmp("ModelDesc"))
	s obj.UseType=$g(tmp("UseType"))
	s stDate=$g(tmp("StDate"))
	i stDate["-" s stDate=$zdh(stDate,3)
	e  s stDate=""
	s obj.StDate=stDate
	s EndDate=$g(tmp("EndDate"))
	i EndDate["-" s EndDate=$zdh(EndDate,3)
	e  s EndDate=""
	s obj.EndDate=EndDate
#;	d obj.ModelUse.Clear()
	s ModelUse=$g(tmp("ModelUse"))
#;	f i=1:1:$L(ModelUse,",") d
#;	.s tValue=$P(ModelUse,",",i)
#;	.q:tValue=""
#;	.d obj.ModelUse.Insert(tValue)
	s obj.ModelUse=ModelUse
	d obj.UseLimit.Clear()
	s UseLimit=$g(tmp("UseLimit"))
	f i=1:1:$L(UseLimit,",") d
	.s tValue=$P(UseLimit,",",i)
	.q:tValue=""
	.d obj.UseLimit.Insert(tValue)
	s obj.IsClassify=$g(tmp("IsClassify"))
	s flag=1
	TS
	s flag=flag&&$$$ISOK(obj.%Save())
	if flag'=1 {
		TRO
		q "保存失败"	
	}
	//先删除
	s subId="" f  s subId=$O(^CF.DHCNS.Config.NsModelSubD(obj.%Id(),subId)) q:(subId="")||(flag'=1)  d
	.s subObj=##class(CF.DHCNS.Config.NsModelSub).%OpenId(obj.%Id()_"||"_subId)
	.q:'$IsObject(subObj)
	.s flag=flag&&subObj.%DeleteId(obj.%Id()_"||"_subId)
	if flag'=1 {
		TRO
		q "删除关联数据失败"	
	}
	s subSort=1
	f i=1:1:$L(SubData,"「")  q:flag'=1  d
	.s subValue=$P(SubData,"「",i)
	.q:subValue=""
	.s rw=$P(subValue,"」",1)
	.s subType=$e(rw,1,1)
	.s subProp=$e(rw,2,$L(rw))
	.q:subType=""
	.q:subProp=""
	.s subObj=##class(CF.DHCNS.Config.NsModelSub).%New()
	.s subObj.Parref=obj
	.s subObj.SubProp=subProp
	.s subObj.SubType=subType
	.s subObj.SubSort=subSort
	.s subObj.SubClass=$P(subValue,"」",2)
	.s subObj.SubDescD=$P(subValue,"」",3)
	.s subObj.SubDescM=$P(subValue,"」",4)
	.s subObj.SubDescQ=$P(subValue,"」",5)
	.s subObj.SubDescH=$P(subValue,"」",6)
	.s subObj.SubDescY=$P(subValue,"」",7)
	.s flag=flag&&$$$ISOK(subObj.%Save())
	.s subSort=subSort+1
	if flag'=1 {
		TRO
		q "保存关联数据失败"	
	}else{
		TC
		q 1	
	}
}

/// Creator:lulin
/// Description:获取模板数据
/// Date:2019-12-14
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetSensModel(id) As %String
{
	q:id="" ""
	s obj=##class(CF.DHCNS.Config.NsModel).%OpenId(id)
	q:'$IsObject(obj) ""
	s ret=""
	s ModelType="",ModelTypeDesc=""
	i $IsObject(obj.ModelType)  d
	.s ModelType=obj.ModelType.%Id()
	.s ModelTypeDesc=obj.ModelType.TypeDesc
	s ret="ModelType|"_ModelType_"^ModelTypeDesc|"_ModelTypeDesc_"^ModelDesc|"_obj.ModelDesc
	s ret=ret_"^Rate|"_obj.Rate_"^UseType|"_obj.UseType
	s IsClassify=obj.IsClassify
	s:IsClassify'="Y" IsClassify="N"
	s ret=ret_"^IsClassify|"_IsClassify
	s StDate=""
	i obj.StDate'="" s StDate=$zd(obj.StDate,3)
	s EndDate=""
	i obj.EndDate'="" s EndDate=$zd(obj.EndDate,3)
	s ret=ret_"^StDate|"_StDate_"^EndDate|"_EndDate
	s ModelUse=obj.ModelUse
	s ModelUseDesc=$case(ModelUse,"E":"填报模板","C":"统计模板",:"")
#;	f i=1:1:obj.ModelUse.Count() d
#;	.s value=obj.ModelUse.GetAt(i)
#;	.q:value=""
#;	.s valueDesc=$case(value,"E":"填报模板","C":"统计模板",:"")
#;	.i ModelUse="" s ModelUse=value,ModelUseDesc=valueDesc
#;	.e  s ModelUse=ModelUse_","_value,ModelUseDesc=ModelUseDesc_","_valueDesc
	s ret=ret_"^ModelUse|"_ModelUse_"^ModelUseDesc|"_ModelUseDesc
	s UseLimit="",UseLimitDesc=""
	f i=1:1:obj.UseLimit.Count() d
	.s value=obj.UseLimit.GetAt(i)
	.q:value=""
	.s isExist=0,valueDesc=""
	.i obj.UseType="L" d
	..s locObj=##class(DHCNS.Config.NsWardLoc).%New(value)
	..s:locObj.Desc'="" isExist=1,valueDesc=locObj.Desc
	.e  i obj.UseType="W" d
	..s wardObj=##class(DHCNS.Config.NsWard).%New(value)
	..s:(wardObj.Desc'="") isExist=1,valueDesc=wardObj.Desc
	.q:isExist=0
	.i UseLimit="" s UseLimit=value,UseLimitDesc=valueDesc
	.e  s UseLimit=UseLimit_","_value,UseLimitDesc=UseLimitDesc_","_valueDesc
	s ret=ret_"^UseLimit|"_UseLimit_"^UseLimitDesc|"_UseLimitDesc
	s subData=""
	s subSort="" f  s subSort=$O(^CF.DHCNS.Config.NsModelSubI("Sort",obj.%Id(),subSort)) q:subSort=""  d
	.s subId="" f  s subId=$O(^CF.DHCNS.Config.NsModelSubI("Sort",obj.%Id(),subSort,subId)) q:(subId="")  d
	..s subObj=##class(CF.DHCNS.Config.NsModelSub).%OpenId(obj.%Id()_"||"_subId)
	..q:'$IsObject(subObj)
	..s subType=subObj.SubType
	..s subProp=subObj.SubProp
	..s SubSort=subObj.SubSort
	..s SubClass=subObj.SubClass
	..s SubDescD=subObj.SubDescD,SubDescM=subObj.SubDescM,SubDescQ=subObj.SubDescQ,SubDescH=subObj.SubDescH
	..s SubDescY=subObj.SubDescY
	..q:(subType="")||(subProp="")
	..s subRw=subType_subProp
	..s typeDesc=$case(subType,"I":"指标","E":"元素",:"")
	..s propDesc="",isSubExist=0
	..i subType="I" d
	...s indexObj=##class(CT.DHCNS.Config.NsIndex).%OpenId(subProp)
	...i $IsObject(indexObj) s isSubExist=1,propDesc=indexObj.IndexDesc
	..i subType="E" d
	...s eleObj=##class(CT.DHCNS.Config.NsElement).%OpenId(subProp)
	...i $IsObject(eleObj) s isSubExist=1,propDesc=eleObj.EleDesc
	..q:isSubExist=0
	..s subDesc="["_typeDesc_"]"_propDesc
	..s:SubDescD="" SubDescD=propDesc
	..s:SubDescM="" SubDescM=propDesc
	..s:SubDescQ="" SubDescQ=propDesc
	..s:SubDescH="" SubDescH=propDesc
	..s:SubDescY="" SubDescY=propDesc
	..s outputRet=subRw_"」"_subDesc_"」"_SubSort_"」"_SubClass_"」"_SubDescD_"」"_SubDescM_"」"_SubDescQ_"」"_SubDescH_"」"_SubDescY
	..i subData="" s subData=outputRet
	..e  s subData=subData_"「"_outputRet
	s ret=ret_"^SubData|"_subData
	s ret=ret_"^rw|"_id
	q ret
}

/// Creator:lulin
/// Description:查询模板列表
/// Date:2019-12-13
/// Table:
/// Input:条件，模糊查询
/// Output：
/// Others:d ##class(%ResultSet).RunQuery("web.NurSensConfigComm","FindSensModelList","","")
Query FindSensModelList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSensModelListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp) 
	s ind=1
	s ret=""
	s findType=$P(parr,"^",1)
	s findModelUse=$P(parr,"^",2)
	s id="" f  s id=$O(^CF.DHCNS.Config.NsModelD(id)) q:id=""  d
	.s obj=##class(CF.DHCNS.Config.NsModel).%OpenId(id)
	.q:'$IsObject(obj)
	.q:(findType'="")&&('$IsObject(obj.ModelType))
	.q:(findType'="")&&(findType'=obj.ModelType.%Id())
	.q:(findModelUse'="")&&(obj.ModelUse'=findModelUse)
	.s modelDesc=obj.ModelDesc
	.s spell=##class(web.NurSensUtilComm).ToChineseSpell(modelDesc)
	.q:(input'="")&&($zcvt((modelDesc_spell),"U")'[$zcvt(input,"U"))
	.s ret=..GetSensModel(id)
	.d OutPutRowData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSensModelListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSensModelListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSensModelListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSensModelListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:lulin
/// Description:查询模板Store使用
/// Date:2019-12-15
/// Table:
/// Input:条件，用途、是否有时间限制
/// Output：
/// Others:d ##class(%ResultSet).RunQuery("web.NurSensConfigComm","FindSensModelStore","1^1^^^","E",1)
Query FindSensModelStore(parr As %String = "", UseType As %String = "", flag As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSensModelStoreExecute(ByRef qHandle As %Binary, parr As %String = "", UseType As %String = "", flag As %String = "") As %Status
{
	s repid=$I(^CacheTemp) 
	s ind=1
	s ret=""
	s findType=$P(parr,"^",1)
	s findWard=$P(parr,"^",2)
	s findRate=$P(parr,"^",3)
	s stDate=$p(parr,"^",4)
	s endDate=$p(parr,"^",5)
	i stDate["-" s stDate=$zdh(stDate,3)
	e  s stDate=+$H
	i endDate["-" s endDate=$zdh(endDate,3)
	e  s endDate=+$H
	s tmpWardLocUnit=""
	d ..SetTmpWardLocUnit(.tmpWardLocUnit)
	s id="" f  s id=$O(^CF.DHCNS.Config.NsModelD(id)) q:id=""  d
	.s obj=##class(CF.DHCNS.Config.NsModel).%OpenId(id)
	.q:'$IsObject(obj) 
	.q:(findType'="")&&('$IsObject(obj.ModelType))
	.q:(findType'="")&&(findType'=obj.ModelType.%Id())
	.q:(UseType'="")&&(obj.ModelUse'=UseType)
	.q:(flag'="")&&(obj.StDate'="")&&(obj.StDate>endDate)
	.q:(flag'="")&&(obj.EndDate'="")&&(obj.EndDate<stDate)
	.q:(findRate'="")&&(obj.Rate'=findRate)
	.s isQuit=1
	.i findWard="" s isQuit=0
	.e  d
	..i obj.UseType="H" s isQuit=0
	..e  i obj.UseType="L" d
	...s findLoc=""  f  s findLoc=$O(tmpWardLocUnit("Ward",findWard,findLoc)) q:(findLoc="")||(isQuit=0)  d
	....i obj.UseLimit.Find(findLoc)>0 s isQuit=0
	..e  i obj.UseType="W" d
	...i obj.UseLimit.Find(findWard)>0  s isQuit=0
	.q:isQuit=1
	.s IsClassify=obj.IsClassify
	.s:IsClassify'="Y" IsClassify="N"
	.s ret="rw|"_id_"^ModelDesc|"_obj.ModelDesc_"^Rate|"_obj.Rate_"^IsClassify|"_IsClassify
	.d OutPutRowData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSensModelStoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSensModelStoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSensModelStoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSensModelStoreExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:lulin
/// Description:查询模板子类:列头使用
/// Date:2019-12-15
/// Table:
/// Input:条件，模糊查询
/// Output：
/// Others:d ##class(%ResultSet).RunQuery("web.NurSensConfigComm","FindModelTableColumn",1)
Query FindModelTableColumn(par As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindModelTableColumnExecute(ByRef qHandle As %Binary, par As %String = "") As %Status
{
	s repid=$I(^CacheTemp) 
	s ind=1
	s ret=""
	if (par=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s sort="" f  s sort=$O(^CF.DHCNS.Config.NsModelSubI("Sort",par,sort)) q:sort=""  d
	.s subId="" f  s subId=$O(^CF.DHCNS.Config.NsModelSubI("Sort",par,sort,subId)) q:subId=""  d
	..s subObj=##class(CF.DHCNS.Config.NsModelSub).%OpenId(par_"||"_subId)
	..q:'$IsObject(subObj)
	..q:subObj.SubType=""
	..q:subObj.SubProp=""
	..s prop=subObj.SubType_subObj.SubProp
	..s label=""
	..i subObj.SubType="E"  d
	...s eleObj=##class(CT.DHCNS.Config.NsElement).%OpenId(subObj.SubProp)
	...i $IsObject(eleObj) s label=eleObj.EleDesc
	..e  i subObj.SubType="I" d
	...s indexObj=##class(CT.DHCNS.Config.NsIndex).%OpenId(subObj.SubProp)
	...i $IsObject(indexObj) s label=indexObj.IndexDesc
	..q:label=""
	..s SubDescD=subObj.SubDescD,SubDescM=subObj.SubDescM,SubDescQ=subObj.SubDescQ,SubDescH=subObj.SubDescH
	..s SubDescY=subObj.SubDescY,SubClass=subObj.SubClass,SubClassDesc=""
	..i $LG($G(^CT.DHCINM.Set.MgArgParamSetD(1)),24)="Y" d
    ...s SubClassObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(SubClass)
    ...s:$IsObject(SubClassObj) SubClassDesc=SubClassObj.SubDesc
    ..e  d
    ...s SubClassObj=##class(DHCNS.Set.NsSysParamSub).%OpenId(SubClass)
    ...s:$IsObject(SubClassObj) SubClassDesc=SubClassObj.SubDesc
    ..s:SubDescD="" SubDescD=label
    ..s:SubDescM="" SubDescM=label
    ..s:SubDescQ="" SubDescQ=label
    ..s:SubDescH="" SubDescH=label
    ..s:SubDescY="" SubDescY=label
	..s ret="prop|"_prop_"^label|"_label_"^SubDescD|"_SubDescD_"^SubDescM|"_SubDescM_"^SubDescQ|"_SubDescQ
	..s ret=ret_"^SubDescH|"_SubDescH_"^SubDescY|"_SubDescY_"^SubClassDesc|"_SubClassDesc
	..d OutPutRowData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindModelTableColumnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindModelTableColumnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindModelTableColumnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindModelTableColumnExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:lulin
/// Description:查询填报模板数据
/// Date:2019-12-15
/// Table:
/// Input:条件，模糊查询
/// Output：
/// Others:d ##class(%ResultSet).RunQuery("web.NurSensConfigComm","FindEditDataList","4^30^2020^11","E131,E132,E100,E102,E101")
Query FindEditDataList(parr As %String = "", columns As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindEditDataListExecute(ByRef qHandle As %Binary, parr As %String = "", columns As %String = "") As %Status
{
	s repid=$I(^CacheTemp) 
	s ind=1
	s ret=""
	s FindModelId=$P(parr,"^",1)
	s FindWard=$P(parr,"^",2)
	s FindYear=$P(parr,"^",3)
	s FindMonth=$P(parr,"^",4)
	if (FindModelId="")||(FindYear="")||(columns=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s tmpColumn=""
	f i=1:1:$L(columns,",") d
	.s indexId=$P(columns,",",i)
	.q:indexId=""
	.s tmpColumn(indexId)=0
	s modelObj=##class(CF.DHCNS.Config.NsModel).%OpenId(FindModelId)
	if '$IsObject(modelObj)||(modelObj.Rate="")||(modelObj.Rate="D"&&(FindMonth="")) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s rows=$case(modelObj.Rate,"D":30,"W":52,"M":12,"Q":4,"H":2,"Y":1,:"")
	if modelObj.Rate="D"{
		s:FindMonth<10 FindMonth="0"_FindMonth
		s rows=##class(web.NurSensUtilComm).GetMonthDay(FindYear_"-"_FindMonth_"-01")	
	}
	s tmpWard=""
	d ..SetTmpWard(.tmpWard)
	s wardSort="" f  s wardSort=$O(tmpWard(wardSort)) q:wardSort=""  d
	.s wardId="" f  s wardId=$O(tmpWard(wardSort,wardId)) q:wardId=""  d
	..q:((FindWard'="")&&(FindWard'=wardId))
	..s wardObj=##class(DHCNS.Config.NsWard).%New(wardId)
	..s WardDesc=wardObj.Desc
	..f i=1:1:rows d
	...s lastTime=i
	...s:i<10 lastTime="0"_lastTime
	...i modelObj.Rate="D" s dateTime=FindYear_"-"_FindMonth_"-"_lastTime
	...e  i modelObj.Rate="Y" s dateTime=FindYear
	...e  s dateTime=FindYear_"-"_lastTime
	...s DataDateDesc=dateTime
	...i modelObj.Rate="Q" d
	....s DataDateDesc=$case(i,1:"第一季度",2:"第二季度",3:"第三季度",4:"第四季度",:dateTime)
	...i modelObj.Rate="H" d
	....s DataDateDesc=$case(i,1:"上半年",2:"下半年",:dateTime)
	...i modelObj.Rate="W" d
	....s DataDateDesc="第"_i_"周"
	....s firstYearDay=$zdh(FindYear_"-01-01",3)
	....s weekDualDate=(i-1)*7+(8-$zd(firstYearDay,10))
	....s weekStDate=firstYearDay+weekDualDate
	....s DataDateDesc=DataDateDesc_"("_$zd(weekStDate,3)_"至"_$zd((weekStDate+6),3)_")"
	...s ret="DataSort|"_i_"^DataDate|"_dateTime_"^DataDateDesc|"_DataDateDesc_"^WardId|"_wardId_"^ModelID|"_FindModelId
	...s ret=ret_"^WardDesc|"_WardDesc
	...s UpdateDate=""
	...s indexId="" f  s indexId=$O(tmpColumn(indexId)) q:indexId=""  d
	....s editDataId=$O(^DHCNS.Config.NsEditDataI("Index"," "_indexId,wardId," "_dateTime,""))
	....s value=""
	....i editDataId'="" d
	.....s editDataObj=##class(DHCNS.Config.NsEditData).%OpenId(editDataId)
	.....i $IsObject(editDataObj) d
	......s value=editDataObj.Value
	......s:UpdateDate<editDataObj.UpdateDate UpdateDate=editDataObj.UpdateDate
	....s ret=ret_"^"_indexId_"|"_value
	....i value'=0 d
	.....s tmpColumn(indexId)=tmpColumn(indexId)+value
	...s:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
	...s ret=ret_"^UpdateDate|"_UpdateDate
	...d OutPutEditData
	s ret="DataSort|总计^DataDate|^WardId|^ModelID|^UpdateDate|"
	s indexId="" f  s indexId=$O(tmpColumn(indexId)) q:indexId=""  d
	.s value=tmpColumn(indexId)
	.s:$e(value,1,1)="." value="0"_value
	.s ret=ret_"^"_indexId_"|"_value
	d OutPutEditData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEditData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindEditDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEditDataListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindEditDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEditDataListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:lulin
/// Description:保存数据
/// Date:2019-12-14
/// Table:
/// Input:
/// Output：
/// Others:d ##class(web.NurSensConfigComm).SaveEditData("1^2020-02-01^E92^4","2",0)
ClassMethod SaveEditData(parr As %String = "", value As %String = "", loginId As %String = "") As %String
{
	s WardDR=$P(parr,"^",1)
	s dateTime=$P(parr,"^",2)
	s IndexDR=$P(parr,"^",3)
	s ModelID=$P(parr,"^",4)
	s DataDay=""
	i dateTime["-" s DataDay=$zdh(dateTime,3)
	q:(WardDR="")||(dateTime="")||(IndexDR="")||(ModelID="") "缺少有效数据"
	q:DataDay="" "数据科室错误,请联系开发"
	s rw=$O(^DHCNS.Config.NsEditDataI("IndexDay"," "_IndexDR,WardDR,DataDay,""))
	s oldValue=""
	i rw="" s obj=##class(DHCNS.Config.NsEditData).%New()
	e  d
	.s obj=##class(DHCNS.Config.NsEditData).%OpenId(rw)
	.s oldValue=obj.Value
	s obj.WardDR=WardDR
	s obj.DataTime=dateTime
	s obj.Value=value
	s obj.IndexDR=IndexDR
	s obj.UpdateDate=+$H
	s obj.Updator=loginId
	s obj.ModelID=ModelID
	s obj.DataDay=DataDay
	s sc=obj.%Save()
	s logRet=ModelID_"^"_IndexDR_"^"_dateTime_"^"_oldValue_"^"_value_"^"_loginId_"^"_WardDR
	d ..SaveEditLog(logRet)
	q 1
}

/// Creator:lulin
/// Description:保存数据
/// Date:2019-12-14
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod SaveEditLog(parr As %String = "") As %String
{
	q:parr="" ""
	s $zt="err"
	s ModelId=$P(parr,"^",1)
	s IndexId=$P(parr,"^",2)
	s DataTime=$P(parr,"^",3)
	s OldValue=$P(parr,"^",4)
	s NewValue=$P(parr,"^",5)
	s Updator=$P(parr,"^",6)
	s WardDR=$P(parr,"^",7)
	s ModelDesc=""
	i ModelId'="" d
	.s modelObj=##class(CF.DHCNS.Config.NsModel).%OpenId(ModelId)
	.s:$IsObject(modelObj) ModelDesc=modelObj.ModelDesc
	s IndexDesc="",Rate=""
	i IndexId'="" d
	.s indexType=$E(IndexId,1,1)
	.s rIndexId=$E(IndexId,2,$L(IndexId))
	.i indexType="E" d
	..s eleObj=##class(CT.DHCNS.Config.NsElement).%OpenId(rIndexId)
	..s:$IsObject(eleObj) IndexDesc=eleObj.EleDesc,Rate=eleObj.Rate
	.i indexType="I" d
	..s indexObj=##class(CT.DHCNS.Config.NsIndex).%OpenId(rIndexId)
	..s:$IsObject(indexObj) IndexDesc=indexObj.IndexDesc,Rate=indexObj.Rate
	s obj=##class(DHCNS.Config.NsEditLog).%New()
	s obj.ModelId=ModelId
	s obj.ModelDesc=ModelDesc
	s obj.IndexId=IndexId
	s obj.IndexDesc=IndexDesc
	s obj.DataTime=DataTime
	s obj.OldValue=OldValue
	s obj.NewValue=NewValue
	s obj.Updator=Updator
	s obj.UpdateDate=+$H
	s obj.WardDR=WardDR
	s obj.Rate=Rate
	d obj.%Save()
	q ""
err
	q ""
}

/// Creator:lulin
/// Description:查询填报模板修改记录
/// Date:2019-12-15
/// Table:
/// Input:条件，模糊查询
/// Output：
/// Others:d ##class(%ResultSet).RunQuery("web.NurSensConfigComm","FindEditLogList","22^4^E131^^^")
Query FindEditLogList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindEditLogListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp) 
	s ind=1
	s ret=""
	s findWard=$P(parr,"^",1)
	if findWard="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s findModelId=$P(parr,"^",2)
	s findIndexId=$P(parr,"^",3)
	s stDate=$P(parr,"^",4)
	i stDate["-" s stDate=$zdh(stDate,3)
	e  s stDate=""
	s endDate=$P(parr,"^",5)
	i endDate["-" s endDate=$zdh(endDate,3)
	e  s endDate=""
	s dateTime=$P(parr,"^",6)
	s modelId="" f  s modelId=$O(^DHCNS.Config.NsEditLogI("Index",findWard,modelId)) q:modelId=""  d
	.q:(findModelId'="")&&(findModelId'=modelId)
	.s indexId="" f  s indexId=$O(^DHCNS.Config.NsEditLogI("Index",findWard,modelId,indexId)) q:indexId=""  d
	..q:(findIndexId'="")&&(findIndexId'=$tr(indexId," ",""))
	..s id="" f  s id=$O(^DHCNS.Config.NsEditLogI("Index",findWard,modelId,indexId,id)) q:id=""  d
	...s obj=##class(DHCNS.Config.NsEditLog).%OpenId(id)
	...q:'$IsObject(obj)
	...q:obj.DataTime=""
	...q:(dateTime'="")&&(dateTime'=obj.DataTime)
	...s dateTime=obj.DataTime
	...s Rate=obj.Rate,Updator=obj.Updator,UpdateDate=obj.UpdateDate
	...s tYear=$P(dateTime,"-",1)
	...s secondNum=$fn($P(dateTime,"-",2),"",0)
	...s isExist=1
	...s tStDate=obj.DataTime,tEndDate=obj.DataTime
	...;M、H
	...i Rate="Y" d
	....s tStDate=tYear_"-01-01"
	....s tEndDate=tYear_"-12-31"
	...i Rate="Q" d
	....s tStMonth=(secondNum-1)*3+1 //1-3,4-6,7,10
	....s tEndMonth=(secondNum-1)*3+3
	....s:tStMonth<10 tStMonth="0"_tStMonth
	....s:tEndMonth<10 tEndMonth="0"_tEndMonth
	....s tStDate=tYear_"-"_tStMonth_"-01"
	....s tEndDate=tYear_"-"_tEndMonth_"-"_##class(web.NurSensUtilComm).GetMonthDay(tYear_"-"_tEndMonth_"-01")
	....s dateTime=$case(secondNum,1:(tYear_"第一季度"),2:(tYear_"第二季度"),3:(tYear_"第三季度"),4:(tYear_"第四季度"),:dateTime)
	...i Rate="H" d
	....i secondNum=1 s tStDate=tYear_"-01-01",tEndDate=tYear_"-06-30"
	....e  s tStDate=tYear_"-07-01",tEndDate=tYear_"-12-31"
	....s dateTime=$case(secondNum,1:(tYear_"上半年"),2:(tYear_"下半年"),:dateTime)
	...i Rate="W" d
	....s dateTime=tYear_"第"_secondNum_"周"
	....s firstYearDay=$zdh(tYear_"-01-01",3)
	....s weekDualDate=(secondNum-1)*7+(8-$zd(firstYearDay,10))
	....s weekStDate=firstYearDay+weekDualDate
	....s dateTime=dateTime_"("_$zd(weekStDate,3)_"至"_$zd((weekStDate+6),3)_")"
	....s tStDate=$zd(weekStDate,3),tEndDate=$zd((weekStDate+6),3)
	...i Rate="M" d
	....s tMonth=secondNum
	....s:tMonth<10 tMonth="0"_tMonth
	....s tStDate=tYear_"-"_tMonth_"-01"
	....s tEndDate=tYear_"-"_tMonth_##class(web.NurSensUtilComm).GetMonthDay(tYear_"-"_tMonth_"-01")
	...s:tStDate'="" tStDate=$zdh(tStDate,3)
	...s:tEndDate'="" tEndDate=$zdh(tEndDate,3)
	...q:(stDate'="")&&((tEndDate="")||(stDate>tEndDate))
	...q:(endDate'="")&&((tStDate="")||(endDate<tStDate))
	...s WardDesc=""
	...s wardObj=##class(DHCNS.Config.NsWard).%New(findWard)
	...s WardDesc=wardObj.Desc
	...s UpdatorDesc=..GetUserName(Updator)
	...s UpdateDateDesc=""
	...s:UpdateDate'="" UpdateDateDesc=$zd(UpdateDate,3)
	...s ret="ModelDesc|"_obj.ModelDesc_"^WardDesc|"_WardDesc_"^IndexDesc|"_obj.IndexDesc_"^DataTime|"_dateTime_"^OldValue|"_obj.OldValue
	...s ret=ret_"^NewValue|"_obj.NewValue_"^UpdatorDesc|"_UpdatorDesc_"^UpdateDateDesc|"_UpdateDateDesc
	...d OutPutRowData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindEditLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEditLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindEditLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FFindEditLogListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:lulin
/// Description:根据开始日期、行数等获取时间格式、显示格式、开始日期、结束日期
/// Date:2019-12-15
/// Table:
/// Input:开始日期年、月、日、第几行、频率
/// Output:时段时间格式^显示格式^开始日期^结束日期
/// Others:
ClassMethod GetDateFormat(stYear, stMonth, stDate, i, rate) As %String
{
	s ret=""
	if rate="D"{//日
		s rowStDate=stDate+i-1
		s ret=$zd((stDate+i-1),3)_"^"_rowStDate_"^"_rowStDate_"^"_$zd((stDate+i-1),3)
	}elseIf rate="M"{ //月
		s nextMonth=(stMonth+i-1)
		s month=(stMonth+i-1)#12  
		s month=$case(month,0:12,:month)
		s:month<10 month="0"_month
		s addYear=nextMonth\12
		s:month=12 addYear=addYear-1
		s dateTime=(stYear+addYear)_"-"_month
		s rowStDate=$zdh(dateTime_"-01",3)
		s rowEndDate=$zdh(dateTime_"-"_##class(web.NurSensUtilComm).GetMonthDay(rowStDate),3)
		s ret=dateTime_"^"_rowStDate_"^"_rowEndDate_"^"_dateTime
	}elseIf rate="Q"{
		s month=(stMonth+((i-1)*3)) //1、4、7、10、13
		s realMonth=month#12
		s stTwoNum=$case(realMonth,1:"01",4:"02",7:"03",10:"04")
		s stTwoDesc=$case(realMonth,1:"第一季度",4:"第二季度",7:"第三季度",10:"第四季度")
		s addYear=month\12
		s:realMonth=12 addYear=addYear-1
		s year=(stYear+(month\12))
		s dateTime=year_"-"_stTwoNum
		s monthStr=realMonth
		s:monthStr<10 monthStr="0"_monthStr
		s rowStDate=$zdh(year_"-"_monthStr_"-01",3)
		s endDay=$case(realMonth,1:"31",4:"30",7:"30",10:"31") //结束日期天
		s endMonth=$case(realMonth,1:"03",4:"06",7:"09",10:"12") //结束月
		s rowEndDate=$zdh(year_"-"_endMonth_"-"_endDay,3)
		s dateDesc=year_stTwoDesc
		s ret=dateTime_"^"_rowStDate_"^"_rowEndDate_"^"_dateDesc
	}elseIf rate="H"{
		s month=(stMonth+((i-1)*6)) //1、7、13、19、
		s realMonth=month#12
		s stTwoNum=$case(realMonth,1:"01",7:"02")
		s stTwoDesc=$case(realMonth,1:"上半年",7:"下半年")
		s addYear=month\12
		s:realMonth=12 addYear=addYear-1
		s year=(stYear+addYear)
		s dateTime=year_"-"_stTwoNum
		s rowStDate=$zdh(year_"-0"_realMonth_"-01",3)
		s endDay=$case(realMonth,1:"30",7:"31") //结束日期天
		s endMonth=$case(realMonth,1:"06",7:"12") //结束月
		s rowEndDate=$zdh(year_"-"_endMonth_"-"_endDay,3)
		s dateDesc=year_stTwoDesc
		s ret=dateTime_"^"_rowStDate_"^"_rowEndDate_"^"_dateDesc
	}elseIf rate="Y"{//年
		s dateTime=stYear+i-1,rowStDate=$zdh(((stYear+i-1)_"-01-01"),3),rowEndDate=$zdh(((stYear+i-1)_"-12-31"),3)
		s ret=dateTime_"^"_rowStDate_"^"_rowEndDate_"^"_dateTime
	}
	q ret
}

/// Creator:lulin
/// Description:元素方法。设置需要获取的最小元素和计算公式
/// Date:id
/// Table:
/// Input:
/// Output:
/// Others:
ClassMethod SetMinEle(id, tmpMinEle) As %String
{
	s obj=##class(CT.DHCNS.Config.NsElement).%OpenId(id)
	q:'$IsObject(obj) ""
	i (obj.DataMode="A")||(obj.DataMode="M") d
	.i $g(tmpMinEle(id))="" s tmpMinEle(id)=0
	q:(obj.DataMode="A")||(obj.DataMode="M") "」i"_id
	q:obj.DataMode'="C" ""
	s ret=""
	s subId="" f  s subId=$O(^CT.DHCNS.Config.NsElementSubD(id,subId)) q:subId=""  d
	.s subObj=##class(CT.DHCNS.Config.NsElementSub).%OpenId(id_"||"_subId)
	.q:'$IsObject(subObj)
	.q:'$IsObject(subObj.EndEleDR)
	.s nextId=subObj.EndEleDR.%Id()
	.i $g(tmpMinEle(nextId))="" s tmpMinEle(nextId)=0
	.s CalType=subObj.Type
	.i CalType="N" s CalType="-"
	.e  s CalType="+"
	.i ret="" d
	..s:CalType="+" CalType=""
	..s ret=CalType_"」i"_nextId
	.e  s ret=ret_"」"_CalType_"」i"_nextId
	q:ret="" ""
	s:((ret["+")||(ret["-")) ret="」("_ret_"」)"
	i obj.OtherNum.Count()>0 d
	.s ret="」("_ret
	.f i=1:1:obj.OtherNum.Count()  d
	..s otherNum=obj.OtherNum.GetAt(i)
	..q:otherNum=""
	..s otherNumMethod=$P(otherNum,"」",1)
	..s otherNumNum=$P(otherNum,"」",2)
	..s otherNumRealMethod="*"
	..s:otherNumMethod'="N" otherNumRealMethod="/"
	..s ret=ret_"」"_otherNumRealMethod_"」"_otherNumNum
	.s ret=ret_"」)"
	q ret
}

ClassMethod GetIndexCal(id, type, tmpMinEle) As %String
{
	s ret=""
	s subId="" f  s subId=$O(^CT.DHCNS.Config.NsIndexSubI("Type",id," "_type,subId)) q:subId=""  d
	.s subObj=##class(CT.DHCNS.Config.NsIndexSub).%OpenId(id_"||"_subId)
	.q:'$IsObject(subObj)
	.q:'$IsObject(subObj.SubProp)
	.s tRet=..SetMinEle(subObj.SubProp.%Id(),.tmpMinEle)
	.s tMethod="+"
	.;i type["R" d //排除元素
	.;.s tMethod="-"
	.q:tRet=""
	.i ret="" s ret=tRet
	.e  s ret=ret_"」+"_tRet
	q:ret="" ""
	s ret="」("_ret_"」)"
	q ret
}

/// Creator:lulin
/// Description:指标方法。设置获取的最小元素和计算公式
/// Date:id
/// Table:
/// Input:
/// Output:
/// Others:
ClassMethod SetIndexCal(id, tmpMinEle) As %String
{
	s obj=##class(CT.DHCNS.Config.NsIndex).%OpenId(id)
	q:'$IsObject(obj) ""
	s ret=""
	//分子
	s NRet=..GetIndexCal(id,"N",.tmpMinEle)
	s NRet2=..GetIndexCal(id,"NR",.tmpMinEle)
	i NRet2'="" d
	.i NRet="" s NRet="」-"_NRet2
	.e  s NRet=NRet_"」-"_NRet2
	q:NRet="" ""
	i obj.NumOther.Count()>0  d
	.s NRet="」("_NRet
	.f i=1:1:obj.NumOther.Count() d
	..s value=obj.NumOther.GetAt(i)
	..q:value=""
	..s method=$P(value,"」",1)
	..s num=$P(value,"」",2)
	..s tData=num
	..s tCal=""
	..i method="D" s tCal="」/」"_num
	..e  s tCal="」*」"_num
	..s NRet=NRet_tCal
	.s NRet=NRet_"」)"
	//分母
	s DRet=..GetIndexCal(id,"D",.tmpMinEle)
	s DRet2=..GetIndexCal(id,"DR",.tmpMinEle)
	i DRet2'="" d
	.i DRet="" s DRet="」-"_DRet2
	.e  s DRet=DRet_"」-"_DRet2
	q:DRet="" NRet
	i obj.DenOther.Count()>0  d
	.s DRet="」("_DRet
	.f i=1:1:obj.DenOther.Count() d
	..s value=obj.DenOther.GetAt(i)
	..q:value=""
	..s method=$P(value,"」",1)
	..s num=$P(value,"」",2)
	..s tData=num
	..s tCal=""
	..i method="D" s tCal="」/」"_num
	..e  s tCal="」*」"_num
	..s DRet=DRet_tCal
	.s DRet=DRet_"」)"
	q NRet_"」「"_DRet
}

/// Creator:lulin
/// Description:得到需要获取的最小元素值及每个元素/指标的计算公式
/// Date:2019-12-15
/// Table:
/// Input:
/// Output:
/// Others:
ClassMethod SetMinAndCal(tmpColumn, tmpMinEle, tmpColumnCal) As %String
{
	s indexId="" f  s indexId=$O(tmpColumn(indexId)) q:indexId=""  d
	.s indexType=$e(indexId,1,1)
	.s id=$e(indexId,2,$L(indexId))
	.q:(indexType="")||(id="")
	.i indexType="E"  d ;元素
	..s cal=..SetMinEle(id,.tmpMinEle)
	..s tmpColumnCal(indexId)=cal
	.e  d //指标
	..s cal=..SetIndexCal(id,.tmpMinEle)
	..s tmpColumnCal(indexId)=cal //」分割+/-，「分割分子/分母
}

/// Creator:lulin
/// Description:初始化最小值
/// Date:2020-01-07
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod initMinData(tmpMinEle) As %String
{
	s isNurMgFlag=0
	s id="" f  s id=$O(tmpMinEle(id)) q:id=""  d
	.s tmpMinEle(id)=""
	.s objLB=$g(^CT.DHCNS.Config.NsElementD(id))
	.q:objLB=""
	.s:$lg(objLB,13)="A" isNurMgFlag=1
	q isNurMgFlag
}

/// Creator:lulin
/// Description:判断是否有护管数值，并设置医嘱、诊断关联typeid
/// Date:2020-01-07
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod SetTypeTmp(tmpMinEle, tmpEleType) As %String
{
	s isNurMgFlag=0
	s id="" f  s id=$O(tmpMinEle(id)) q:id=""  d
	.s tmpMinEle(id)=""
	.s objLB=$g(^CT.DHCNS.Config.NsElementD(id))
	.q:objLB=""
	.s AutoType=$lg(objLB,13)
	.s:AutoType="A" isNurMgFlag=1
	.q:((AutoType'="L")&&(AutoType'="O")&&(AutoType'="H"))
	.s eleTypeID="" f  s eleTypeID=$O(^CT.DHCNS.Config.NsEleTypeD(id,eleTypeID)) q:eleTypeID=""  d
	..s typeLB=$g(^CT.DHCNS.Config.NsEleTypeD(id,eleTypeID))
	..q:typeLB=""
	..s TypeID=$lg(typeLB,2)
	..q:TypeID=""
	..s typeFlag=$lg(typeLB,5)
	..s:typeFlag="" typeFlag="N"
	..s tmpEleType(id,typeFlag,eleTypeID)=TypeID
	q isNurMgFlag
}

/// Creator:lulin
/// Description:获取手动获取数据
/// Date:2020-01-07
/// Table:
/// Input:parr:病区、元素id、开始日期、结束日期、类型（A:期初末,S:和值）
/// Output：
/// Others:
ClassMethod GetManualData(id, wardId, stDate, endDate, type) As %String
{
	q:(id="")||(wardId="")||(stDate="")||(endDate="")||(type="") ""
	s value=""
	i (type="A")||(type="E")  d ;期初、期末的值
	.s dataDate=stDate
	.i type="E" s dataDate=endDate
	.s stId=$O(^DHCNS.Config.NsEditDataI("IndexDay"," "_id,wardId,dataDate,""))
	.i stId'="" d
	..;s editDataObj=##class(DHCNS.Config.NsEditData).%OpenId(stId)
	..;s:$IsObject(editDataObj) value=editDataObj.Value
	..s value=$LG(^DHCNS.Config.NsEditDataD(stId),4)
	q:type'="S" value
	s date=stDate-1 f  s date=$O(^DHCNS.Config.NsEditDataI("IndexDay"," "_id,wardId,date)) q:(date="")||(date>endDate)  d
	.s editId="" f  s editId=$O(^DHCNS.Config.NsEditDataI("IndexDay"," "_id,wardId,date,editId)) q:editId=""  d
	..;s editDataObj=##class(DHCNS.Config.NsEditData).%OpenId(editId)
	..;q:'$IsObject(editDataObj)
	..;s value=value+editDataObj.Value
	..s value=value+$LG(^DHCNS.Config.NsEditDataD(editId),4)
	q value
}

ClassMethod SetTmpNurMgData(dualType, subType, adcaDR, appDutyDR, headShipDR, WorkDate, date, ctLocId, IsRegister, WardWorkDay, tmpNurMgData) As %String
{
	s tmpNurMgData(ctLocId,dualType,subType,"W","N")=$g(tmpNurMgData(ctLocId,dualType,subType,"W","N"))+1 ;总数
	s:IsRegister="Y" tmpNurMgData(ctLocId,dualType,subType,"W","Y")=$g(tmpNurMgData(ctLocId,dualType,subType,"W","Y"))+1
	i adcaDR'="" d
	.s tmpNurMgData(ctLocId,dualType,subType,"E",adcaDR,"N")=$g(tmpNurMgData(ctLocId,dualType,subType,"E",adcaDR,"N"))+1
	.s:IsRegister="Y" tmpNurMgData(ctLocId,dualType,subType,"E",adcaDR,"Y")=$g(tmpNurMgData(ctLocId,dualType,subType,"E",adcaDR,"Y"))+1
	i appDutyDR'="" d
	.s tmpNurMgData(ctLocId,dualType,subType,"D",appDutyDR,"N")=$g(tmpNurMgData(ctLocId,dualType,subType,"D",appDutyDR,"N"))+1
	.s:IsRegister="Y" tmpNurMgData(ctLocId,dualType,subType,"D",appDutyDR,"Y")=$g(tmpNurMgData(ctLocId,dualType,subType,"D",appDutyDR,"Y"))+1
	i headShipDR'="" d
	.s tmpNurMgData(ctLocId,dualType,subType,"P",headShipDR,"N")=$g(tmpNurMgData(ctLocId,dualType,subType,"P",headShipDR,"N"))+1
	.s:IsRegister="Y" tmpNurMgData(ctLocId,dualType,subType,"P",headShipDR,"Y")=$g(tmpNurMgData(ctLocId,dualType,subType,"P",headShipDR,"Y"))+1
	i WorkDate'="" d
	.s:WorkDate["-" WorkDate=$zdh(WorkDate,3)
	.s year=(date-WorkDate)\365
	.s tmpNurMgData(ctLocId,dualType,subType,"S",year,"N")=$g(tmpNurMgData(ctLocId,dualType,subType,"S",year,"N"))+1
	.s:IsRegister="Y" tmpNurMgData(ctLocId,dualType,subType,"S",year,"Y")=$g(tmpNurMgData(ctLocId,dualType,subType,"S",year,"Y"))+1
	i WardWorkDay'=""  d ;本病区执业工作年限
	.s year=WardWorkDay\365 ; $P(##class(web.NurSensUtilComm).CalAge(1,WardWorkDay),"Y",1)
	.s tmpNurMgData(ctLocId,dualType,subType,"S",year,"W")=$g(tmpNurMgData(ctLocId,dualType,subType,"S",year,"W"))+1
}

/// Creator:lulin
/// Description:获取护理管理自动获取数据
/// Date:2020-01-07
/// Table:
/// Input:parr:病区、元素id、开始日期、结束日期、类型（A:期初末,S:和值）
/// Output：
/// Others:d ##class(web.NurSensConfigComm).GetAutoMgData("",65557,65557,.tmpNurMgData)
ClassMethod GetAutoMgData(stDate, endDate, tmpNurMgData) As %String
{
	q:(stDate="")||(endDate="") ""
	//期初、期末的值
	s tmpDayCountPer="",tmpNightCountPer="",tmpAllCountPer=""
	s tmpDayCountPerD="",tmpNightCountPerD="",tmpAllCountPerD=""
	s date=stDate-1 f  s date=$O(^DHCNS.Config.NsAutoMgDataI("key",date)) q:((date="")||(date>endDate))  d
	.s dataKey="" f  s dataKey=$O(^DHCNS.Config.NsAutoMgDataI("key",date,dataKey)) q:dataKey=""  d
	..s mgId=""  f  s mgId=$O(^DHCNS.Config.NsAutoMgDataI("key",date,dataKey,mgId)) q:mgId=""  d
	...s lgObj=$g(^DHCNS.Config.NsAutoMgDataD(mgId))
	...q:lgObj=""
	...s tCtLocId=$LG(lgObj,4)
	...s BeforWard=$LG(lgObj,15)
	...q:tCtLocId="9999"  ;作废区
	...q:tCtLocId="9998"  ;退休区
	...;q:((tCtLocId=9997)&&(ctLocId'=BeforWard))  //离职前病区与所查不符合
	...;q:((tCtLocId'=9997)&&(ctLocId'=tCtLocId))
	...s NurseID=$LG(lgObj,5)
	...;q:NurseID=""
	...s:tCtLocId="" tCtLocId="O"
	...s workDate=$LG(lgObj,14)
	...s:workDate="" workDate=$LG(lgObj,13)
	...s AdcaDR=$LG(lgObj,8)
	...s AppDutyDR=$LG(lgObj,9)
	...s HeadShipDR=$LG(lgObj,10)
	...s DayCount=$LG(lgObj,11)
	...s NightCount=$LG(lgObj,12)
	...s allCount=$LG(lgObj,21)
	...s IsRegister=$LG(lgObj,18)
	...s:IsRegister="" IsRegister="Y"
	...s WardWorkDay=$LG(lgObj,23)
	...i (tCtLocId="9997") d ;离职区----此处有问题啊？？？？
	....s:tCtLocId=9997 tCtLocId=BeforWard
	....d ..SetTmpNurMgData("S","Q",AdcaDR,AppDutyDR,HeadShipDR,workDate,date,tCtLocId,IsRegister,WardWorkDay,.tmpNurMgData)
	....i date=stDate d  ;期初
	.....d ..SetTmpNurMgData("A","Q",AdcaDR,AppDutyDR,HeadShipDR,workDate,date,tCtLocId,IsRegister,WardWorkDay,.tmpNurMgData)
	....i date=endDate d  ;期末
	.....d ..SetTmpNurMgData("E","Q",AdcaDR,AppDutyDR,HeadShipDR,workDate,date,tCtLocId,IsRegister,WardWorkDay,.tmpNurMgData)
	...e  d ;在职
	....d ..SetTmpNurMgData("S","I",AdcaDR,AppDutyDR,HeadShipDR,workDate,date,tCtLocId,IsRegister,WardWorkDay,.tmpNurMgData)
	....i date=stDate d  ;期初
	.....d ..SetTmpNurMgData("A","I",AdcaDR,AppDutyDR,HeadShipDR,workDate,date,tCtLocId,IsRegister,WardWorkDay,.tmpNurMgData)
	....i date=endDate d  ;期末
	.....d ..SetTmpNurMgData("E","I",AdcaDR,AppDutyDR,HeadShipDR,workDate,date,tCtLocId,IsRegister,WardWorkDay,.tmpNurMgData)
	....;小时数、上班护士数
	....i (DayCount'="")&&(DayCount>0) d
	.....s tmpNurMgData(tCtLocId,"D","N","N")=$g(tmpNurMgData(tCtLocId,"D","N","N"))+DayCount
	.....s:IsRegister="Y" tmpNurMgData(tCtLocId,"D","Y","N")=$g(tmpNurMgData(tCtLocId,"D","Y","N"))+DayCount
	.....i $g(tmpDayCountPer(date,dataKey))="" d
	......s tmpNurMgData(tCtLocId,"DN","N","N")=$g(tmpNurMgData(tCtLocId,"DN","N","N"))+1
	......s:IsRegister="Y" tmpNurMgData(tCtLocId,"DN","Y","N")=$g(tmpNurMgData(tCtLocId,"DN","Y","N"))+1
	......s tmpDayCountPer(date,dataKey)=1
	....i ((NightCount'="")&&(NightCount>0)) d
	.....s tmpNurMgData(tCtLocId,"N","N","N")=$g(tmpNurMgData(tCtLocId,"N","N","N"))+NightCount
	.....s:IsRegister="Y" tmpNurMgData(tCtLocId,"N","Y","N")=$g(tmpNurMgData(tCtLocId,"N","Y","N"))+NightCount
	.....i $g(tmpNightCountPer(date,dataKey))="" d
	......s tmpNurMgData(tCtLocId,"NN","N","N")=$g(tmpNurMgData(tCtLocId,"NN","N","N"))+1
	......s:IsRegister="Y" tmpNurMgData(tCtLocId,"NN","Y","N")=$g(tmpNurMgData(tCtLocId,"NN","Y","N"))+1
	......s tmpNightCountPer(date,dataKey)=1
	....i ((allCount'="")&&(allCount>0)) d
	.....s tmpNurMgData(tCtLocId,"V","N","N")=$g(tmpNurMgData(tCtLocId,"V","N","N"))+allCount
	.....s:IsRegister="Y" tmpNurMgData(tCtLocId,"V","Y","N")=$g(tmpNurMgData(tCtLocId,"V","Y","N"))+allCount
	.....i $g(tmpAllCountPer(date,dataKey))="" d
	......s tmpNurMgData(tCtLocId,"VN","N","N")=$g(tmpNurMgData(tCtLocId,"VN","N","N"))+1
	......s:IsRegister="Y" tmpNurMgData(tCtLocId,"VN","Y","N")=$g(tmpNurMgData(tCtLocId,"VN","Y","N"))+1
	......s tmpAllCountPer(date,dataKey)=1
	....;责班
	....;i $LG(lgObj,18)="Y" d
	....s DayCount=$LG(lgObj,19)
	....s NightCount=$LG(lgObj,20)
	....s allCount=$LG(lgObj,22)
	....i (DayCount'="")&&(DayCount>0) d
	.....s tmpNurMgData(tCtLocId,"D","N","Y")=$g(tmpNurMgData(tCtLocId,"D","N","Y"))+DayCount
	.....s:IsRegister="Y" tmpNurMgData(tCtLocId,"D","Y","Y")=$g(tmpNurMgData(tCtLocId,"D","Y","Y"))+DayCount
	.....i $g(tmpDayCountPerD(date,dataKey))="" d
	......s tmpNurMgData(tCtLocId,"DN","N","Y")=$g(tmpNurMgData(tCtLocId,"DN","N","Y"))+1
	......s:IsRegister="Y" tmpNurMgData(tCtLocId,"DN","Y","Y")=$g(tmpNurMgData(tCtLocId,"DN","Y","Y"))+1
	......s tmpDayCountPerD(date,dataKey)=1
	....i ((NightCount'="")&&(NightCount>0)) d
	.....s tmpNurMgData(tCtLocId,"N","N","Y")=$g(tmpNurMgData(tCtLocId,"N","N","Y"))+NightCount
	.....s:IsRegister="Y" tmpNurMgData(tCtLocId,"N","Y","Y")=$g(tmpNurMgData(tCtLocId,"N","Y","Y"))+NightCount
	.....i $g(tmpNightCountPerD(date,dataKey))="" d
	......s tmpNurMgData(tCtLocId,"NN","N","Y")=$g(tmpNurMgData(tCtLocId,"NN","N","Y"))+1
	......s:IsRegister="Y" tmpNurMgData(tCtLocId,"NN","N","Y")=$g(tmpNurMgData(tCtLocId,"NN","N","Y"))+1
	......s tmpNightCountPerD(date,dataKey)=1
	....i ((allCount'="")&&(allCount>0)) d
	.....s tmpNurMgData(tCtLocId,"V","N","Y")=$g(tmpNurMgData(tCtLocId,"V","N","Y"))+allCount
	.....s:IsRegister="Y" tmpNurMgData(tCtLocId,"V","Y","Y")=$g(tmpNurMgData(tCtLocId,"V","Y","Y"))+allCount
	.....i $g(tmpAllCountPerD(tCtLocId,date,dataKey))="" d
	......s tmpNurMgData(tCtLocId,"VN","N","Y")=$g(tmpNurMgData(tCtLocId,"VN","N","Y"))+1
	......s:IsRegister="Y" tmpNurMgData(tCtLocId,"VN","N","Y")=$g(tmpNurMgData(tCtLocId,"VN","N","Y"))+1
	......s tmpAllCountPerD(tCtLocId,date,dataKey)=1
}

/// Creator:lulin
/// Description:获取不良事件相关
/// Date:2020-02-22
/// Table:
/// Input:p病区、元素id、开始日期、结束日期、类型（A:期初末,S:和值）
/// Output：
/// Others:
ClassMethod GetAutoAdvData(advTypes, wardId, stDate, endDate, type, advDual) As %String
{
	q:(advTypes="")||(wardId="")||(stDate="")||(endDate="")||(type="") ""
	;advTypes:GDHT,导尿管/胃肠管/PICC/气管导管；DD，S/H,0/1/2/3/4;YC,S/Q,1,-1
	s wardObj=##class(DHCNS.Config.NsWard).%New(wardId)
	q:wardObj.Desc="" ""
	s ctLocId=wardObj.CTLocDR,pacward="",WardDesc=""
	i ctLocId'="" d
	.;s LocDesc=$P($p(^CTLOC(ctLocId),"^",2),"-",2)
	.s pacward=$O(^PAWARD(0,"WARD_LocationDR",ctLocId,""))
	.i pacward'="" d
	..s WardDesc=$P(^PAWARD(pacward),"^",2)
	s:WardDesc["-" WardDesc=$P(WardDesc,"-",2)
	s WardDescNative=wardObj.Desc
	s tStDate=stDate,tEndDate=endDate
	i type="A" {
		s tStDate=stDate,tEndDate=stDate
	}elseif type="E"{
		s tStDate=endDate,tEndDate=endDate
	}
	s value=0
	s advType=$P(advTypes,",",1) ;GDHT;DD;YC
	s advType2=$P(advTypes,",",2) ;导尿管/胃肠管/PICC/气管导管;S/H;S/Q
	s advType3=$P(advTypes,",",3) ;"";"";"";"";"";0/1/2/3/4;"";1/-1
	s advDualNightFlag=0
	s dataDate=tStDate-1 f  s dataDate=$O(^DHCNS.Config.NsAutoAdvI("TypeDate"," "_advType,dataDate)) q:(dataDate="")||(dataDate>tEndDate)  d
	.s advId="" f  s advId=$O(^DHCNS.Config.NsAutoAdvI("TypeDate"," "_advType,dataDate,advId)) q:advId=""  d
	..s flag=..GetAdvFlag(advId,ctLocId,WardDesc,WardDescNative,advDual,advDualNightFlag,advType,advType2,advType3)
	..q:flag=0
	..s value=value+1
	i advDual="N" d ;夜班获取第二天数据
	.s advDualNightFlag=1
	.s dataDate=tStDate f  s dataDate=$O(^DHCNS.Config.NsAutoAdvI("TypeDate"," "_advType,dataDate)) q:(dataDate="")||(dataDate>(tEndDate+1))  d
	..s advId="" f  s advId=$O(^DHCNS.Config.NsAutoAdvI("TypeDate"," "_advType,dataDate,advId)) q:advId=""  d
	...s flag=..GetAdvFlag(advId,ctLocId,WardDesc,WardDescNative,advDual,advDualNightFlag,advType,advType2,advType3)
	...q:flag=0
	...s value=value+1
	q value
}

/// Creator:lulin
/// Description:获取不良事件相关
/// Date:2020-02-22
/// Table:
/// Input:获取某天的value
/// Output：
/// Others:
ClassMethod GetAdvFlag(advId, ctLocId, WardDesc, WardDescNative, advDual, advDualNightFlag, advType, advType2, advType3) As %String
{
	s sysParamObj=##class(DHCNS.Config.NsSysParam).%New(1)
	s AdvFlag=sysParamObj.AdvInter
	s dayStartTime=sysParamObj.DayStTime
	s dayEndTime=sysParamObj.DayEndTime
	s:dayStartTime="" dayStartTime=28800
	s:dayEndTime="" dayEndTime=57600
	s flag=0
	s advLB=$G(^DHCNS.Config.NsAutoAdvD(advId))
	q:advLB="" 0
	s ReportWardDesc=$LG(advLB,25)
	s ReportLocID=$LG(advLB,28)
	q:((AdvFlag="A")&&(ReportLocID'=ctLocId)) 0
	q:((AdvFlag'="A")&&(ReportWardDesc'=WardDesc)&&(ReportWardDesc'=WardDescNative)) 0  ;过滤掉科室的，此处需要根据项目要求更改
	;过滤白班、夜班时间
	s ReportTime=$LG(advLB,25)
	q:((advDual="D")&&((ReportTime>=dayEndTime)||(ReportTime<dayStartTime))) 0
	q:((advDualNightFlag=0)&&(advDual="N")&&(ReportTime<dayEndTime)) 0
	q:((advDualNightFlag=1)&&(advDual="N")&&(ReportTime>dayStartTime)) 0
	s status=$LG(advLB,10)
	;只要已审核
    q:((AdvFlag'="A")&&(status'="A")) 0 
    q:((AdvFlag="A")&&(status'=4)&&(status'=5)&&(status'=6)) 0 
    s AdvGlideType=$LG(advLB,26)
    s Degree=$LG(advLB,19)
    s UlcerLevel=$LG(advLB,20)
    i advType="GDHT" d ;管道滑脱
    .s AdvGlideType=","_AdvGlideType_","
    .i AdvFlag'="A" d
    ..i AdvGlideType[(","_advType2_",") s flag=1
    .e  d
    ..i advType2="PICC" d
    ...i AdvGlideType[(",PICC,") s flag=1
    ..i advType2="导尿管" d
    ...i AdvGlideType[(",尿管,") s flag=1
    ..i advType2="胃肠管" d
    ...i ((AdvGlideType[(",胃管,"))||(AdvGlideType[(",鼻饲管,"))) s flag=1
    ..i advType2="CVC" d
    ...i ((AdvGlideType[(",透析管路,"))||(AdvGlideType[(",深静脉置管,"))||(AdvGlideType[(",动脉置管,"))) s flag=1
	..i advType2="气管导管" d
    ...i ((AdvGlideType[(",气管插管,"))||(AdvGlideType[(",气管切开套管,"))) s flag=1
	..i advType2="术区引流管" d
    ...i ((AdvGlideType[(",胸腔闭式引流管,"))||(AdvGlideType[(",腹腔引流管,"))||(AdvGlideType[(",伤口引流管,"))||(AdvGlideType[(",心包引流管,"))||(AdvGlideType[(",脑室引流管,"))) s flag=1
    e  i advType="DD" d ;跌倒坠床
    .i advType2="S"  s flag=1
    .e  i advType2="H" d  
    ..i advType3=Degree s flag=1
    e  i advType="YC" d ;压疮
    .s UlcerPart=$LG(advLB,29)
    .i UlcerPart["院内" d ;只取院内
    ..i advType2="S" d ;总计
    ...s flag=1
    ..e  i advType2="Q" d  ;期数
    ...i (advType3=1)&&(UlcerLevel=1) s flag=1
    ...e  i (advType3="-1")&&(UlcerLevel'="")&&(UlcerLevel'=1) s flag=1
	q flag
}

/// Creator:lulin
/// Description:获取患者相关
/// Date:2020-02-22
/// Table:
/// Input:p病区、元素id、开始日期、结束日期、类型（A:期初末,S:和值）
/// Output：
/// Others:
ClassMethod GetAutoPatData(patType, wardId, stDate, endDate, type, IsNoBaby, SubType, SubValue, SubValueType, subEndValue, rowIndex, tmpRowPat) As %String
{
	q:(patType="")||(wardId="")||(stDate="")||(endDate="")||(type="") ""
	//期初、期末的值
	s tStDate=stDate,tEndDate=endDate
	i type="A" {
		s tStDate=stDate,tEndDate=stDate
	}elseif type="E"{
		s tStDate=endDate,tEndDate=endDate
	}
	s value="",subPattmp=""
	s dataDate=tStDate-1 f  s dataDate=$O(^DHCNS.Config.NsAutoPatI("Index"," "_patType,wardId,dataDate)) q:(dataDate="")||(dataDate>tEndDate)  d
	.s autoId="" f  s autoId=$O(^DHCNS.Config.NsAutoPatI("Index"," "_patType,wardId,dataDate,autoId)) q:autoId=""  d
	..s tValue=+$LG(^DHCNS.Config.NsAutoPatD(autoId),4)
	..q:((tValue="")||(tValue=0))
	..k patSubTmp
	..s patSubTmp=""
	..s subid=""  f  s subid=$O(^DHCNS.Config.NsAutoPatSubD(autoId,subid)) q:subid=""  d
	...s subGlo=^DHCNS.Config.NsAutoPatSubD(autoId,subid)
	...s KeyWord=$lg(subGlo,2)
	...q:KeyWord=""
	...s IsBaby=$lg(subGlo,6)
	...q:((IsNoBaby="Y")&&(IsBaby="Y"))
	...s PerDiagnos=$lg(subGlo,10)
	...s PerLevelDiagnos=$lg(subGlo,11)
	...s diagnosFlag=0,levelDiagnosFlag=0 ;默认不符合
	...i ((SubValue'="")&&((SubType="D")||(SubType="L"))) d
	....i ((PerDiagnos'="")||(PerLevelDiagnos'="")) d
	.....f diagnosIndex=1:1:$L(SubValue,",") q:((diagnosFlag=1)&&(levelDiagnosFlag=1))  d
	......s diagnosDesc=$p(SubValue,",",diagnosIndex)
	......q:diagnosDesc=""
	......s:(PerDiagnos[diagnosDesc) diagnosFlag=1
	......s:(PerLevelDiagnos[diagnosDesc) levelDiagnosFlag=1
	...s:(SubValue="") diagnosFlag=1,levelDiagnosFlag=1
	...q:((SubType="D")&&(diagnosFlag=0)) ;诊断
	...q:((SubType="L")&&(levelDiagnosFlag=0)) ;出院诊断
	...s existFlag=0
	...s PerBirthDateDesc="",AdmDateDesc=""
	...i SubType="Y" d
	....s:((SubValue="")&&(subEndValue="")) existFlag=0 ;空取全部
	....s AdmDate=$lg(subGlo,7)
	....s PerBirthDate=$lg(subGlo,9)
	....i PerBirthDate["-" d
	.....s PerBirthDate=$zdh(PerBirthDate,3)
	....e  d
	.....s PerBirthDate=""
	....s:((SubValue'="")||(subEndValue'="")) existFlag=..IsInDateDual(SubValue,subEndValue,PerBirthDate,AdmDate,SubValueType)
	....s:PerBirthDate'="" PerBirthDateDesc=$zd(PerBirthDate,3)
	....s:AdmDate'="" AdmDateDesc=$zd(AdmDate,3)
	...q:existFlag=1
	...s value=value+1
	...s PatTypeSub=""
	...i $e(patType,1,1)="D" s PatTypeSub="D"
	...e  i $e(patType,1,1)="0" s PatTypeSub="0"
	...e  i $e(patType,1,1)="N" s PatTypeSub="N"
	...s:PatTypeSub'="" tmpRowPat(patType,rowIndex,KeyWord,autoId_"||"_subid)=patType
	
	q value
}

// 在范围内返回0

ClassMethod IsInDateDual(start, end, date, toDate, unit) As %String
{
	q:((date="")||(toDate="")) 1
	s dual=""
	i unit="D" d
	.s dual=toDate-date
	e  d
	.s age=##class(NurSensUtilComm).CalAge(toDate,date)
	.i unit="Y" d
	..s dual=$P(age,"Y",1)
	.e  d
	..s dual=$P(age,"Y",1)*12+$P($P(age," ",2),"M")
	q:dual="" 1
	q:((start'="")&&(dual<start)) 1
	q:((end'="")&&(dual>=end)) 1
	q 0
}

/// Creator:lulin
/// Description:获取医嘱例次、留置日数
/// Date:2020-01-10
/// Table:
/// Input:p病区、元素id、开始日期、结束日期、类型（A:期初末,S:和值）
/// Output：
/// Others:
ClassMethod GetAutoOrderData(id, wardId, stDate, endDate, type, TMPNurSensOrder, tmpEleType) As %String
{
	q:(id="")||(wardId="")||(stDate="")||(endDate="")||(type="") ""
	//期初、期末的值
	s tStDate=stDate,tEndDate=endDate
	i type="A" {
		s tStDate=stDate,tEndDate=stDate
	}elseif type="E"{
		s tStDate=endDate,tEndDate=endDate
	}
	s wardObj=##class(DHCNS.Config.NsWard).%New(wardId)
	s CTLocDR=wardObj.CTLocDR
	q:(CTLocDR="") ""
	s value=""
	s OrderType=$LG(^CT.DHCNS.Config.NsElementD(id),22) ;O:例次，L：留置数, P:患者数
	s autoType=$LG(^CT.DHCNS.Config.NsElementD(id),13) ;O:医嘱执行、L:医嘱启停
	s orderTime=$LG(^CT.DHCNS.Config.NsElementD(id),24) ;设定得启停时间
	q:OrderType="" ""
	q:((autoType="L")&&(orderTime="")) "" ;医嘱启停类型，如果没有设置时间点则不统计这个时间

	s tmpPat="" ;整个周期的医嘱患者数
	;autoType="L" 目前是根据医嘱当天有执行才进行计算。在严谨性上不够。
	s DataSort=1
	s EleTypeId="" f  s EleTypeId=$O(tmpEleType(id,"N",EleTypeId)) q:EleTypeId=""  d
	.s typeObj=$G(^CT.DHCNS.Config.NsEleTypeD(id,EleTypeId))
	.q:typeObj=""
	.s TypeID=$LG(typeObj,2)
	.q:TypeID=""
	.i autoType="L" d ;医嘱启停
	..s ArcimEndDate="-100000000000000"
	..d subOrder
	..s ArcimEndDate=tStDate-2 f  s ArcimEndDate=$O(^DHCNS.Config.NsAutoOrderI("ARCIMDate",CTLocDR, " "_TypeID,ArcimEndDate)) q:ArcimEndDate=""  d
	...d subOrder
	.e  d
	..f dataDate=tStDate:1:tEndDate d
	...s execDataDate=dataDate
	...s EpisodeID="" f  s EpisodeID=$O(^DHCNS.Config.NsAutoOrderExecI("ARCIM",CTLocDR," "_TypeID,execDataDate,EpisodeID)) q:EpisodeID=""  d
	....q:((OrderType="P")&&($D(tmpPat(EpisodeID))'=0)) ;患者数，周期内只取一次
	....q:((OrderType'="O")&&($D(tmpPat(EpisodeID,dataDate))'=0))  ;非例次 每天只取一个
	....s autoOrderId="" f  s autoOrderId=$O(^DHCNS.Config.NsAutoOrderExecI("ARCIM",CTLocDR," "_TypeID,execDataDate,EpisodeID,autoOrderId)) q:autoOrderId=""  d
	.....q:((OrderType="P")&&($D(tmpPat(EpisodeID))'=0)) ;患者数，周期内只取一次
	.....q:((OrderType'="O")&&($D(tmpPat(EpisodeID,dataDate))'=0)) ;非例次 每天只取一个
	.....s autoOrderLB=$g(^DHCNS.Config.NsAutoOrderD(autoOrderId))
	.....q:autoOrderLB=""
	.....q:..DoseInstrFlag(typeObj,autoOrderLB)'=1 ;剂量、用法判断
	.....;前置医嘱
	.....s MotherEpisodeID=$lg(autoOrderLB,23)
	.....s flag=..PreFlag(.tmpEleType,id,CTLocDR,execDataDate,EpisodeID,autoOrderId)
	.....q:flag'=1
	.....;排除医嘱
	.....s flag=..ExcludeFlag(.tmpEleType,id,CTLocDR,execDataDate,EpisodeID,MotherEpisodeID)
	.....q:flag'=1
	.....s disdate=$LG(autoOrderLB,21)
	.....s DHCdisdate=$p($g(^PAADM($tr(EpisodeID," ",""))),"^",59)
	.....s:(DHCdisdate'="") disdate=DHCdisdate
	.....q:((disdate'="")&&(disdate<dataDate)) ;今天0点之前已出院
	.....s OrderExecId="" f  s OrderExecId=$O(^DHCNS.Config.NsAutoOrderExecI("ARCIM",CTLocDR," "_TypeID,execDataDate,EpisodeID,autoOrderId,OrderExecId)) q:OrderExecId=""  d
	......q:((OrderType="P")&&($D(tmpPat(EpisodeID))'=0)) ;患者数，周期内只取一次
	......q:((OrderType'="O")&&($D(tmpPat(EpisodeID,dataDate))'=0)) ;非例次 每天只取一个
	......s value=value+1
	......s tmpPat(EpisodeID,dataDate)=EpisodeID
	......s PatName=$LG(autoOrderLB,9)
	......s ArcimDesc=$LG(autoOrderLB,11)
	......s SubDesc=PatName_"("_..GetRegNoByEpisodeID($tr(EpisodeID," ",""))_");"_ArcimDesc_";"_$zd(dataDate,3)
	......s ArcimExecID=$LG($g(^DHCNS.Config.NsAutoOrderExecD(autoOrderId,OrderExecId)),8)
	......s ret="DataSort|"_DataSort_"^KeyWord|"_ArcimExecID_"^SubDesc|"_SubDesc_"^Updator|系统任务^Update|"_$zd(dataDate,3)
	......s DataSort=DataSort+1
	......s TMPNurSensOrder(DataSort)=ret
	q value
subOrder
	s startDate="" f  s startDate=$O(^DHCNS.Config.NsAutoOrderI("ARCIMDate",CTLocDR, " "_TypeID,ArcimEndDate,startDate)) q:(startDate="")||(startDate>tEndDate)  d
	.s EpisodeID="" f  s EpisodeID=$O(^DHCNS.Config.NsAutoOrderI("ARCIMDate",CTLocDR, " "_TypeID,ArcimEndDate,startDate,EpisodeID)) q:EpisodeID=""  d
	..q:((OrderType="P")&&($D(tmpPat(EpisodeID))'=0)) ;患者数，周期内只取一次
	..s autoOrderId="" f  s autoOrderId=$O(^DHCNS.Config.NsAutoOrderI("ARCIMDate",CTLocDR, " "_TypeID,ArcimEndDate,startDate,EpisodeID,autoOrderId)) q:autoOrderId=""  d
	...q:((OrderType="P")&&($D(tmpPat(EpisodeID))'=0)) ;患者数，周期内只取一次
	...s autoOrderLB=$g(^DHCNS.Config.NsAutoOrderD(autoOrderId))
	...q:autoOrderLB=""
	...q:..DoseInstrFlag(typeObj,autoOrderLB)'=1 ;剂量、用法判断
	...s execFirstId=$O(^DHCNS.Config.NsAutoOrderExecD(autoOrderId,""))
	...q:execFirstId="" ;无医嘱执行记录得不计入
	...s OrderItemId=$lg(autoOrderLB,2)
	...;前置医嘱
	...s MotherEpisodeID=$lg(autoOrderLB,23)
	...s startTime=$LG(autoOrderLB,4)
	...s realStDate=$lg(autoOrderLB,27)
	...s realStTime=$lg(autoOrderLB,28)
	...s XDate=$LG(autoOrderLB,5)
	...s XTime=$LG(autoOrderLB,6)
	...i ((XDate'="")&&($d(tmpEleType(id,"M"))'=0)) d 
	....;存在互斥医嘱如果停用当天存在执行,且出院日期>当天，停用日期到次日，时间到次日八点
	....s disdate=$LG(autoOrderLB,21)
	....s XOrderCTLocID=$LG(autoOrderLB,22)
	....s DHCdisdate=$p($g(^PAADM($tr(EpisodeID," ",""))),"^",59)
	....s:(DHCdisdate'="") disdate=DHCdisdate
	....s mutextFlag=..MutextFlag(id,.tmpEleType, XDate, EpisodeID, autoOrderId)
	....s:((mutextFlag=0)&&((XOrderCTLocID="")||(XOrderCTLocID=CTLocDR))&&((disdate="")||(disdate>XDate))) XDate=XDate+1,XTime=28800
	...q:((XDate'="")&&(XDate<tStDate)) ;医嘱停止小于此次统计开始周期
	...s realStartDate=startDate
	...q:(realStartDate>tEndDate)
	...s:(realStartDate<tStDate) realStartDate=tStDate
	...s realEndDate=tEndDate
	...s:((XDate'="")&&(XDate<tEndDate)) realEndDate=XDate
	...f dataDate=realStartDate:1:realEndDate  d
	....q:((OrderType="P")&&($D(tmpPat(EpisodeID))'=0)) ;患者数，周期内只取一次
	....q:((OrderType'="O")&&($D(tmpPat(EpisodeID,dataDate))'=0)) ;非例次 每天只取一个
	....q:((dataDate=startDate)&&(startTime>orderTime)) ;开医嘱当天,时间大于统计时间
	....q:((dataDate=XDate)&&(XTime<orderTime)) ;停医嘱日期,时间小于统计时间
	....s flag=..PreFlag(.tmpEleType,id,CTLocDR,startDate,EpisodeID,autoOrderId)
	....q:flag'=1
	....;排除医嘱
	....s flag2=..ExcludeFlag(.tmpEleType,id,CTLocDR,dataDate,EpisodeID,MotherEpisodeID)
	....q:flag2'=1
	....s dateMutextFlag=..MutextExecFlag(id,.tmpEleType, dataDate, EpisodeID, autoOrderId,realStDate,realStTime,OrderItemId,XDate)
	....q:dateMutextFlag=1
	....;s execWard=CTLocDR
	....;s execID=$O(^DHCNS.Config.NsAutoOrderExecI("ExecDate",autoOrderId,dataDate,""))
	....;i execID'="" d
	....;.s execWard=$lg($g(^DHCNS.Config.NsAutoOrderExecD(autoOrderId,execID)),4)
	....;q:execWard'=CTLocDR
	....s value=value+1,tmpPat(EpisodeID,dataDate)=EpisodeID,tmpPat(EpisodeID)=EpisodeID
	....;明细
	....s PatName=$LG(autoOrderLB,9)
	....s ArcimDesc=$LG(autoOrderLB,11)
	....s SubDesc=PatName_"("_..GetRegNoByEpisodeID($tr(EpisodeID," ",""))_");"_ArcimDesc
	....s ret="DataSort|"_DataSort_"^KeyWord|"_OrderItemId_"^SubDesc|"_SubDesc_"^Updator|系统任务^Update|"_$zd(dataDate,3)
	....s DataSort=DataSort+1
	....s TMPNurSensOrder(DataSort)=ret
}

/// 是否固定剂量、频次数据，0:不当等。1：相等
ClassMethod DoseInstrFlag(eleTypeLB, autoOrderLB) As %String
{
	s DoseQty1=$lg(eleTypeLB,6)
	s OrderUnit1=$lg(eleTypeLB,7)
	s OrderInstrDR1=$LFS($lg(eleTypeLB,8),",")
	q:((DoseQty1="")&&(OrderUnit1="")&&(OrderInstrDR1="")) 1
	s DoseQty=$lg(autoOrderLB,24)
	q:((DoseQty1'="")&&(DoseQty'=DoseQty1)) 0
	s OrderUnit=$lg(autoOrderLB,25)
	q:((OrderUnit1'="")&&(OrderUnit'=OrderUnit1)) 0
	s OrderInstrDR=$lg(autoOrderLB,26)
	q:((OrderInstrDR1'="")&&($LF(OrderInstrDR1,OrderInstrDR)<1)) 0
	q 1
}

/// 排除医嘱，是否存在，1：不存在。0：存在
ClassMethod ExcludeFlag(tmpEleType, id, CTLocDR, dataDate, EpisodeID, MotherEpisodeID) As %String
{
	q:'$d(tmpEleType(id,"E")) 1
	s flag=1
	s tTypeID="" f  s tTypeID=$O(tmpEleType(id,"E",tTypeID)) q:(tTypeID="")||(flag=0)  d
	.s tArcimID=$g(tmpEleType(id,"E",tTypeID))
	.q:tArcimID=""
	.s eleTypeLB=$g(^CT.DHCNS.Config.NsEleTypeD(id,tTypeID))
	.s motherFlag=$lg(eleTypeLB,9)
	.s tEpisodeID=EpisodeID
	.s:motherFlag="Y" tEpisodeID=MotherEpisodeID
	.q:tEpisodeID=""
	.q:'$d(^DHCNS.Config.NsAutoOrderExecI("ARCIM",CTLocDR," "_tArcimID,dataDate,tEpisodeID))
	.s flag=0
	q flag
}

/// 前置判断，是否存在，1：存在。0：不存在
ClassMethod PreFlag(tmpEleType, id, CTLocDR, startDate, EpisodeID, autoOrderId) As %String
{
	q:'$d(tmpEleType(id,"P")) 1
	s flag=0
	s autoOrderLB=$g(^DHCNS.Config.NsAutoOrderD(autoOrderId))
	q:autoOrderLB="" 1
	s MotherEpisodeID=$lg(autoOrderLB,23)
	s tTypeID="" f  s tTypeID=$O(tmpEleType(id,"P",tTypeID)) q:(tTypeID="")||(flag=1)  d
	.s tArcimID=$g(tmpEleType(id,"P",tTypeID))
	.q:tArcimID=""
	.s eleTypeLB=$g(^CT.DHCNS.Config.NsEleTypeD(id,tTypeID))
	.s motherFlag=$lg(eleTypeLB,9)
	.s tEpisodeID=EpisodeID
	.s:motherFlag="Y" tEpisodeID=MotherEpisodeID
	.q:tEpisodeID=""
	.s:$d(^DHCNS.Config.NsAutoOrderExecI("PatNum",startDate," "_tArcimID,EpisodeID)) flag=1
	q:flag=1 1
	;之前的前置医嘱
	s OrderItemId=$lg(autoOrderLB,2)
	s ArcimID=$lg(autoOrderLB,10)
	s breakFlag=0,lastStDate=startDate
	s tPreEndDate=startDate+1 f  s tPreEndDate=$o(^DHCNS.Config.NsAutoOrderI("PatEnd",EpisodeID," "_ArcimID,tPreEndDate),-1) q:(tPreEndDate="")||(breakFlag=1)||(flag=1)  d
	.q:tPreEndDate>lastStDate
	.s tAutoOrderId="" f  s tAutoOrderId=$o(^DHCNS.Config.NsAutoOrderI("PatEnd",EpisodeID," "_ArcimID,tPreEndDate,tAutoOrderId)) q:(tAutoOrderId="")||(breakFlag=1)||(flag=1)  d
	..q:tAutoOrderId=autoOrderId
	..s tAutoOrderLB=$g(^DHCNS.Config.NsAutoOrderD(tAutoOrderId))
	..q:tAutoOrderLB=""
	..i (lastStDate-tPreEndDate>1)||(lastStDate-tPreEndDate<0) s breakFlag=1 q
	..s tPreStDate=$lg(autoOrderLB,3)
	..q:tPreStDate=""
	..s lastStDate=tPreStDate
	..s tTypeID="" f  s tTypeID=$O(tmpEleType(id,"P",tTypeID)) q:(tTypeID="")||(flag=1)  d
	...s tArcimID=$g(tmpEleType(id,"P",tTypeID))
	...q:tArcimID=""
	...s eleTypeLB=$g(^CT.DHCNS.Config.NsEleTypeD(id,tTypeID))
	...s motherFlag=$lg(eleTypeLB,9)
	...s tEpisodeID=EpisodeID
	...s:motherFlag="Y" tEpisodeID=MotherEpisodeID
	...q:tEpisodeID=""
	...s:$d(^DHCNS.Config.NsAutoOrderExecI("PatNum",lastStDate," "_tArcimID,tEpisodeID)) flag=1	
	q flag
}

/// 互斥判断过滤 1、存在,0：不存在.以开医嘱开始日期后者为准
ClassMethod MutextExecFlag(id, tmpEleType, execDate, EpisodeID, autoOrderId, startDate, startTime, OrderItemId, XDate) As %String
{
	q:'$d(tmpEleType(id,"M")) 0
	s mutextFlag=0
	s typeLB=$lb("N","M")
	s execorderId=$O(^DHCNS.Config.NsAutoOrderExecI("ExecDate",autoOrderId,execDate,""))
	f i=1:1:$LL(typeLB) q:mutextFlag'=0  d
	.s type=$LG(typeLB,i)
	.s tTypeID="" f  s tTypeID=$O(tmpEleType(id,type,tTypeID)) q:((tTypeID="")||(mutextFlag'=0))  d
	..s tArcimID=$g(tmpEleType(id,type,tTypeID))
	..q:tArcimID=""
	..s mutextOrderId="" f  s mutextOrderId=$O(^DHCNS.Config.NsAutoOrderExecI("PatNum",execDate," "_tArcimID, EpisodeID, mutextOrderId)) q:((mutextOrderId="")||(mutextFlag'=0))  d
	...q:mutextOrderId=autoOrderId ;本医嘱不计算在内
	...s orderLB=$g(^DHCNS.Config.NsAutoOrderD(mutextOrderId))
	...q:orderLB=""
	...s tOrderItemId=$lg(orderLB,2)
	...q:tOrderItemId=OrderItemId ;本医嘱不计算在内
	...s tStartDate=$lg(orderLB,27)
	...s tStartTime=$lg(orderLB,28)
	...q:(tStartDate="")
	...q:((XDate'="")&&(XDate=tStartDate)) ;停医嘱当天新开医嘱不计入
	...q:((execorderId'="")&&((tStartDate<startDate)||((tStartDate=startDate)&&(tStartTime<startTime))))
	...s mutextFlag=1
	q mutextFlag
}

/// 互斥判断 1、存在,0：不存在;用于判断是否对医嘱进行加1判断
ClassMethod MutextFlag(id, tmpEleType, startDate, EpisodeID, autoOrderId) As %String
{
	s mutextFlag=0
	s typeLB=$lb("N","M")
	f i=1:1:$LL(typeLB) q:mutextFlag'=0  d
	.s type=$LG(typeLB,i)
	.s tTypeID="" f  s tTypeID=$O(tmpEleType(id,type,tTypeID)) q:((tTypeID="")||(mutextFlag'=0))  d
	..s tArcimID=$g(tmpEleType(id,type,tTypeID))
	..q:tArcimID=""
	..s mutextAutoOrderId="" f  s mutextAutoOrderId=$O(^DHCNS.Config.NsAutoOrderI("PatNum",startDate," "_tArcimID,EpisodeID,mutextAutoOrderId))  q:((mutextAutoOrderId="")||(mutextFlag'=0))  d
	...q:'$d(^DHCNS.Config.NsAutoOrderExecD(mutextAutoOrderId)) ;无医嘱执行记录得不计入
	...q:mutextAutoOrderId=autoOrderId ;本医嘱不计算在内，同一天启停
	...s mutextFlag=1
	..i mutextFlag=0 d ;当天存在其他医嘱执行，也不累加,主要针对临时医嘱，出院前一天同开两且都停用？
	...s mutextOrderId="" f  s mutextOrderId=$O(^DHCNS.Config.NsAutoOrderExecI("PatNum",startDate," "_tArcimID, EpisodeID, mutextOrderId)) q:((mutextOrderId="")||(mutextFlag'=0))  d
	....q:mutextOrderId=autoOrderId ;本医嘱不计算在内，同一天启停
	....s mutextFlag=1
	q mutextFlag
}

/// Creator:lulin
/// Description:获取其他
/// Date:2020-01-10
/// Table:
/// Input:病区、元素id、开始日期、结束日期、类型（A:期初末,S:和值）
/// Output：
/// Others:
ClassMethod GetOtherAutoData(id, wardId, stDate, endDate, type, repeatFlag) As %String
{
	q:(id="")||(wardId="")||(stDate="")||(endDate="")||(type="") ""
	//期初、期末的值
	s value=""
	s tStDate=stDate,tEndDate=endDate
	i type="A" {
		s tStDate=stDate,tEndDate=stDate
	}elseif type="E"{
		s tStDate=endDate,tEndDate=endDate
	}
	k tmpOtherData
	s tmpOtherData=""
	s dataDate=tStDate-1 f  s dataDate=$O(^DHCNS.Config.NsAutoDataI("Index",id,wardId,dataDate)) q:(dataDate="")||(dataDate>tEndDate)  d
	.s autoId="" f  s autoId=$O(^DHCNS.Config.NsAutoDataI("Index",id,wardId,dataDate,autoId)) q:autoId=""  d
	..;s autoObj=##class(DHCNS.Config.NsAutoData).%OpenId(autoId)
	..;q:'$IsObject(autoObj)
	..;s value=value+autoObj.Value
	..i repeatFlag="Y" d
	...s autoSubId="" f  s autoSubId=$O(^DHCNS.Config.NsAutoDataSubD(autoId,autoSubId)) q:autoSubId=""  d
	....s KeyWord=$lg($g(^DHCNS.Config.NsAutoDataSubD(autoId,autoSubId)),2)
	....q:KeyWord=""
	....q:$d(tmpOtherData(KeyWord))
	....s tmpOtherData(KeyWord)=1
	....s value=value+1
	..e  d
	...s value=value+$LG(^DHCNS.Config.NsAutoDataD(autoId),4)
	q value
}

/// Creator:lulin
/// Description:得到最小元素值
/// Date:2020-01-07
/// Table:
/// Input:病区、元素id、开始日期、结束日期，tmpMinEle
/// Output：
/// Others:
ClassMethod GetMinData(wardParr, rowStDate, rowEndDate, tmpMinEle, tmpNurMgData, tmpEleType, rowIndex, tmpRowPat) As %String
{
	q:(wardParr="")||(rowStDate="")||(rowEndDate="") ""
	;k tmpNurMgData
	;s tmpNurMgData=""
	s isWardFlag=0
	s wardId=$P(wardParr,"^",1)
	s NurMgInter=$P(wardParr,"^",2)
	s ctLocId=$P(wardParr,"^",3)
	s mgWardCode=$P(wardParr,"^",4)
	s IsWard=$P(wardParr,"^",5)
	s mgCtLocId=ctLocId
	s:(mgWardCode'="") mgCtLocId=mgWardCode ;第三方存护管工号代码
	s:(NurMgInter="W") mgCtLocId=wardId
	s id="" f  s id=$O(tmpMinEle(id)) q:id=""  d
	.q:..FiterWardFlag("E",id,wardId)=1
	.s objLB=$g(^CT.DHCNS.Config.NsElementD(id))
	.q:objLB=""
	.s IsOnlyInWard=$lg(objLB,30)
	.q:((IsOnlyInWard="Y")&&(IsWard'=1))
	.s value=""
	.s dualType=$lg(objLB,14)
	.s autoType=$lg(objLB,13)
	.q:((autoType'="A")&&(ctLocId=""))
	.q:((autoType="A")&&(mgCtLocId=""))
	.s DataMode=$lg(objLB,6)
	.i DataMode="M" d ;手动
	..s value=..GetManualData("E"_id,wardId,rowStDate,rowEndDate,dualType)
	.e  i DataMode="A" d ;自动
	..i autoType="A" d ;护理管理数据 单独处理
	...s NurMgType=$lg(objLB,15)
	...s IsRegister=$lg(objLB,26)
	...s:IsRegister="" IsRegister="Y"
	...s isDuty=$lg(objLB,27)
	...s:isDuty="" isDuty="Y"
	...;白班小时数、护士数。夜班小时数、护士数
	...i (NurMgType="D")||(NurMgType="DN")||(NurMgType="N")||(NurMgType="NN")||(NurMgType="V")||(NurMgType="VN") d
	....s value=$g(tmpNurMgData(mgCtLocId,NurMgType,IsRegister,isDuty))
	...e  d
	....s NurMgSubType=$lg(objLB,16)
	....s NurMgSubTypeID=$lg(objLB,17)
	....i (dualType'="")&&(NurMgSubType'="") d
	.....i NurMgSubType="W" d  ;总数
	......s value=$g(tmpNurMgData(mgCtLocId,dualType,NurMgType,NurMgSubType,IsRegister))
	.....e  i NurMgSubType="S" d ;年资
	......s IsOnlyWard=$lg(objLB,29)
	......s:IsOnlyWard="Y" IsRegister="W" ;本病区年资
	......s SenioritySt=$lg(objLB,18)
	......s SeniorityEnd=$lg(objLB,19)
	......s tYear="" f  s tYear=$O(tmpNurMgData(mgCtLocId,dualType,NurMgType,"S",tYear)) q:tYear=""  d
	.......q:(SenioritySt'="")&&(tYear<SenioritySt)
	.......q:(SeniorityEnd'="")&&(tYear>=SeniorityEnd)
	.......s value=value+$g(tmpNurMgData(mgCtLocId,dualType,NurMgType,"S",tYear,IsRegister))
	.....e  s:(NurMgSubTypeID'="") value=$g(tmpNurMgData(mgCtLocId,dualType,NurMgType,NurMgSubType,NurMgSubTypeID,IsRegister))
	..e  i (autoType="O")||(autoType="L") d ;医嘱例次、留置日数、患者数
	...k TMPNurSensOrder
	...s TMPNurSensOrder=""
	...s value=..GetAutoOrderData(id,wardId,rowStDate,rowEndDate,dualType,.TMPNurSensOrder,.tmpEleType)
	..e  i (autoType="V") d ;不良事件
	...s advType=$lg(objLB,20)
	...s advDual=$lg(objLB,23)
	...s value=..GetAutoAdvData(advType,wardId,rowStDate,rowEndDate,dualType,advDual)
	..e  i (autoType="P") d ;患者
	...s patType=$lg(objLB,21)
	...s IsNoBaby=$lg(objLB,25)
	...s:IsNoBaby="" IsNoBaby="Y"
	...s SubType=$lg(objLB,32)
	...s SubValue=$lg(objLB,34)
	...s SubValueType=$lg(objLB,35)
	...s subEndValue=$lg(objLB,36)
	...s value=..GetAutoPatData(patType,wardId,rowStDate,rowEndDate,dualType,IsNoBaby,SubType,SubValue,SubValueType,subEndValue,rowIndex,.tmpRowPat)
	..e  i (autoType="I") d ;院感
	...s InfType=$lg(objLB,33)
	...s value=..GetAutoInfData(InfType,wardId,rowStDate,rowEndDate,dualType)
	..e  i (autoType="H") d ;手术
	...k tmpPatANData
	...s tmpPatANData=""
	...s value=..GetAutoANData(id,wardId,rowStDate,rowEndDate,dualType,.tmpEleType,.tmpPatANData)
	..e  d ;Z:其他
	...s repeatFlag=$lg(objLB,37)
	...s value=..GetOtherAutoData(id,wardId,rowStDate,rowEndDate,dualType,repeatFlag)
	.s tmpMinEle(id)=value
	q 1
}

ClassMethod CalRealValue(cal, tmpMinEle) As %String
{
	q:cal="" ""
	s realCal=""
	f i=1:1:$L(cal,"」") d
	.s tValue=$P(cal,"」",i)
	.q:tValue=""
	.i tValue["i" d
	..s tValue=$g(tmpMinEle($tr(tValue,"i","")))
	.s:tValue="" tValue=0
	.s realCal=realCal_tValue
	s result=""
	s x="s result="_realCal
	s result= ##class(web.NurSensUtilComm).CalXMethod(x)	
	q result
}

/// Creator:lulin
/// Description:计算值
/// Date:2020-01-07
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetCalValue(cal, tmpMinEle) As %String
{
	s nCal=$P(cal,"「",1) ;分子
	s dCal=$P(cal,"「",2) //分母
	q:nCal="" ""
	;循环分子,取出分子值进行加减
	s nValue=..CalRealValue(nCal,.tmpMinEle)
	s dValue=..CalRealValue(dCal,.tmpMinEle)
	s:dValue="" dValue=1
	q nValue_"^"_dValue
}

ClassMethod CalRealValueForHospital(cal, tmpMinEleAll, transStatus, rows, fixedRow, tmpRowPat) As %String
{
	q:cal="" ""
	s realCal=""
	s repeatStFlag=1
	i transStatus="Y" d
	.s repeatStFlag=0
	.f i=1:1:$L(cal,"」") q:repeatStFlag=1  d
	..s tValue=$P(cal,"」",i)
	..q:tValue=""
	..i tValue["i" d
	...s eleId=$tr(tValue,"i","")
	...s eleObjLB=$g(^CT.DHCNS.Config.NsElementD(eleId))
	...s AutoType=$LG(eleObjLB,13)
	...s PatType=$LG(eleObjLB,21)
	...s DualType=$LG(eleObjLB,14)
	...i ((AutoType="P")&&(PatType="0")&&(DualType="A")) d ;期初0点值
	....s repeatStFlag=1
	f i=1:1:$L(cal,"」") d
	.s tValue=$P(cal,"」",i)
	.q:tValue=""
	.i tValue["i" d
	..s eleId=$tr(tValue,"i","")
	..s eleObjLB=$g(^CT.DHCNS.Config.NsElementD(eleId))
	..s AutoType=$LG(eleObjLB,13)
	..s PatType=$LG(eleObjLB,21)
	..s DualType=$LG(eleObjLB,14)
	..s tValue=""
	..i ((transStatus="Y")&&(AutoType="P")&&(PatType["T"))  d  ;转入的过滤重复人员，
	...s dataRow=""
	...s:DualType="A" dataRow=1
	...s:DualType="E" dataRow=rows
	...s PatTypeSub=$e(patType,1,1)
	...i repeatStFlag=1 d ;若用起初开始算，则整个周期内计算重复行，否则单日计算重复性
	....k tmpPat
	....s tmpPat=""
	...f j=1:1:rows  d
	....q:((fixedRow'="")&&(fixedRow'=j))
	....q:((fixedRow="")&&(dataRow'="")&&(dataRow'=j))
	....s wardId="" f  s wardId=$O(tmpMinEleAll(eleId,j,wardId)) q:wardId=""  d
	.....s tValue=tValue+$g(tmpMinEleAll(eleId,j,wardId))
	....s dualNum=0
	....i repeatStFlag'=1 d
	.....k tmpPat
	.....s tmpPat=""
	....s EpisodeID="" f  s EpisodeID=$O(tmpRowPat(PatTypeSub,j,EpisodeID)) q:EpisodeID=""  d
	.....s patDataSubID="" f  s patDataSubID=$O(tmpRowPat(PatTypeSub,j,EpisodeID,patDataSubID)) q:patDataSubID=""  d
	......s patType=$g(tmpRowPat(PatTypeSub,j,EpisodeID,patDataSubID))
	......s:$d(tmpPat(EpisodeID)) dualNum=dualNum+1 ;存在重复
	......s tmpPat(EpisodeID)=EpisodeID
	....s tValue=tValue-dualNum
	..e  d ;全院过滤转入
	...s dataRow=""
	...s:DualType="A" dataRow=1
	...s:DualType="E" dataRow=rows
	...f j=1:1:rows  d
	....q:((fixedRow'="")&&(fixedRow'=j))
	....q:((fixedRow="")&&(dataRow'="")&&(dataRow'=j))
	....s wardId="" f  s wardId=$O(tmpMinEleAll(eleId,j,wardId)) q:wardId=""  d
	.....s tValue=tValue+$g(tmpMinEleAll(eleId,j,wardId))
	..e  i ((transStatus="Y")&&(AutoType="P")&&(PatType="0T"))  d  ;全院过滤重复人员
	...s dataRow=""
	...s:DualType="A" dataRow=1
	...s:DualType="E" dataRow=rows
	...f j=1:1:rows  d
	....q:((fixedRow'="")&&(fixedRow'=j))
	....q:((fixedRow="")&&(dataRow'="")&&(dataRow'=j))
	....s wardId="" f  s wardId=$O(tmpMinEleAll(eleId,j,wardId)) q:wardId=""  d
	.....s tValue=tValue+$g(tmpMinEleAll(eleId,j,wardId))
	....s dualNum=0
	....k tmpPat
	....s tmpPat=""
	....s EpisodeID="" f  s EpisodeID=$O(tmpRowPat(j,EpisodeID)) q:EpisodeID=""  d
	.....s patDataSubID="" f  s patDataSubID=$O(tmpRowPat(j,EpisodeID,patDataSubID)) q:patDataSubID=""  d
	......s patType=$g(tmpRowPat(j,EpisodeID,patDataSubID))
	......q:((patType'["0"))
	......s:$d(tmpPat(EpisodeID)) dualNum=dualNum+1 ;存在重复
	......s tmpPat(EpisodeID)=EpisodeID
	....s tValue=tValue-dualNum
	....b ;001
	.s:tValue="" tValue=0
	.s realCal=realCal_tValue
	s result=""
	s x="s result="_realCal
	s result= ##class(web.NurSensUtilComm).CalXMethod(x)
	q result
}

/// Creator:lulin
/// Description:计算值
/// Date:2020-01-07
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetCalValueForHospital(cal, tmpMinEleAll, transStatus, rows, fixedRow, tmpRowPat) As %String
{
	s nCal=$P(cal,"「",1) ;分子
	s dCal=$P(cal,"「",2) //分母
	q:nCal=""
	;循环分子,取出分子值进行加减
	s nValue=..CalRealValueForHospital(nCal,.tmpMinEleAll,transStatus,rows,fixedRow,.tmpRowPat)
	s dValue=..CalRealValueForHospital(dCal,.tmpMinEleAll,transStatus,rows,fixedRow,.tmpRowPat)
	s:dValue="" dValue=1
	q nValue_"^"_dValue
}

/// Creator:lulin
/// Description:查询统计数据
/// Date:2019-12-15
/// Table:
/// Input:parr:病区、频率、开始时间、结束时间
/// Output：包头包尾
/// Others:d ##class(%ResultSet).RunQuery("web.NurSensConfigComm","FindCountList","H1^M^2022-03-01^2022-03-31^23^0","I107")
Query FindCountList(parr As %String = "", columns As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCountListExecute(ByRef qHandle As %Binary, parr As %String = "", columns As %String = "") As %Status
{
	s repid=$I(^CacheTemp) 
	s ind=1
	s ^TMP("FindCountList")=parr_","_columns
	//如果是模板过滤模板开始的日期,增加入参模板
	s ret=""
	s ward=$P(parr,"^",1)
	s rate=$P(parr,"^",2)
	s stDate=$P(parr,"^",3)
	i stDate["-" s stDate=stDate
	e  s stDate=""
	s endDate=$P(parr,"^",4) 
	i endDate["-" s endDate=endDate
	e  s endDate=""
	s findModelId=$P(parr,"^",5) 
	s wardType=$P(parr,"^",6) ;仅手术室
	if (rate="")||(stDate="")||(endDate="")||(columns=""){
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
	s sysParam=##class(DHCNS.Config.NsSysParam).%New(1)
	s findModelObj="",FindWardQuit=0,tmpFindWard="",tmpWardLocUnit=""
	s startTime=$P($H,",",2)
	d ..SetTmpWardLocUnit(.tmpWardLocUnit)
	i findModelId'="" d
	.s findModelObj=##class(CF.DHCNS.Config.NsModel).%OpenId(findModelId)
	.i findModelObj.UseType="H" s FindWardQuit=0
	.e  i findModelObj.UseType="L" d
	..s FindWardQuit=1
	..s locUnitLocId=""  f  s locUnitLocId=$O(tmpWardLocUnit("Loc",locUnitLocId)) q:(locUnitLocId="")  d
	...s locUnitWardId=""  f  s locUnitWardId=$O(tmpWardLocUnit("Loc",locUnitLocId,locUnitWardId)) q:(locUnitWardId="")  d
	....i findModelObj.UseLimit.Find(locUnitWardId)>0 s tmpFindWard(locUnitWardId)=1
	.e  i findModelObj.UseType="W" d
	..s FindWardQuit=1
	..f i=1:1:findModelObj.UseLimit.Count() d
	...s limitWardId=findModelObj.UseLimit.GetAt(i)
	...q:limitWardId=""
	...s tmpFindWard(limitWardId)=1
	//选择某院区
	s tmpHospitalWard="",tmpWardI=""
	d ..SetTmpWardI(.tmpWardI)
	i ward["H"  d
	.s hospitalId=$e(ward,2,$L(ward))
	.i hospitalId'="" d
	..s hospitalWardId="" f  s hospitalWardId=$O(tmpWardI("Hospital",hospitalId,hospitalWardId)) q:hospitalWardId=""  d
	...s tmpHospitalWard(hospitalWardId)=1
	//.转换时间格式得到年-月-日
	s stYear=$fn($P(stDate,"-",1),"",0)
	s endYear=$fn($P(endDate,"-",1),"",0)
	s stMonthNum=$fn($P(stDate,"-",2),"",0)
	s endMonthNum=$fn($P(endDate,"-",2),"",0)
	s stDate=$zdh(stDate,3)
	s endDate=$zdh(endDate,3)
	//计算需要输出数据行数
	s rows=0
	if rate="D" {
		s rows=endDate-stDate+1
	}elseif rate="Y" {
		s rows=endYear-stYear+1
	}else{
		s step=$case(rate,"M":1,"Q":3,"H":6,:1) ;一个周期几个月
		s yearStep=$case(rate,"M":12,"Q":4,"H":2,:12)	;一年多少个周期
		s rows=((endYear-stYear)*yearStep)+((endMonthNum-stMonthNum+1)\step)
	}
	;循环需要获取那些自动或者手动上传数据及
	s tmpColumn="",tmpColumnIndex="",tmpWard=""
	d ..SetTmpWard(.tmpWard)
	f i=1:1:$L(columns,",") d
	.s indexId=$P(columns,",",i)
	.q:indexId="" 
	.s tmpColumn(indexId)=0
	;需要获取的最小元素,每个指标/元素对最小元素的计算公式。
	k tmpMinEle,tmpColumnCal,tmpMinEleAll,tmpEleType,tmpRowPat
	s tmpMinEle="",tmpColumnCal="",tmpMinEleAll="",isNurMgFlag=0,tmpEleType="",tmpRowPat=""
	d ..SetMinAndCal(.tmpColumn,.tmpMinEle,.tmpColumnCal)
	s isNurMgFlag=..SetTypeTmp(.tmpMinEle,.tmpEleType) ;是否有护管相关数据
	s sysParam=##class(DHCNS.Config.NsSysParam).%New(1)
	;m tmpMinEleAll=tmpMinEle
	s DataSort=1
	f i=1:1:rows  d ;第几行
	.s dateDual=..GetDateFormat(stYear,stMonthNum,stDate,i,rate)
	.q:dateDual=""
	.s dateDesc=$P(dateDual,"^",4)
	.s dateTime=$P(dateDual,"^",1)
	.s rowStDate=$P(dateDual,"^",2)
	.s rowEndDate=$P(dateDual,"^",3)
	.k tmpNurMgData
	.s tmpNurMgData=""
	.d:isNurMgFlag=1 ..GetAutoMgData(rowStDate, rowEndDate,.tmpNurMgData)
	.;日期、指标、病区
	.s wardSort="" f  s wardSort=$O(tmpWard(wardSort)) q:wardSort=""  d
	..s wardId="" f  s wardId=$O(tmpWard(wardSort,wardId)) q:wardId=""  d
	...q:((ward'["H")&&(ward'="")&&(ward'=wardId))
	...q:((ward["H")&&($g(tmpHospitalWard(wardId))=""))
	...q:((FindWardQuit'=0)&&($g(tmpFindWard(wardId))'=1)) ;过滤掉模板需要统计的病区
	...s wardObj=##class(DHCNS.Config.NsWard).%New(wardId)
	...;只要模板使用范围
	...;q:(wardObj.CTLocDR="")
	...q:((wardObj.StDate'="")&&(wardObj.StDate>endDate))
	...q:((wardObj.EndDate'="")&&(wardObj.EndDate<=stDate))
	...q:((wardType=1)&&((ward="")||(ward["H"))&&(wardObj.ClassDesc'["手术"))
	...s wardDesc=wardObj.Desc
	...s ret="DataSort|"_DataSort_"^DataDate|"_dateTime_"^DataDateDesc|"_dateDesc_"^WardId|"_wardId_"^WardDesc|"_wardDesc
	...s ret=ret_"^rowStDate|"_$zd(rowStDate,3)_"^rowEndDate|"_$zd(rowEndDate,3)_"^OneRow|1"
	...s isExistData=0
	...;每次先初始化,获取tmpMinEle值
	...s isNurMgFlagc=..initMinData(.tmpMinEle)
	...;期初、期末、和值已根据数据属性进行分离
	...;先把每行数据存下来？
	...s dataWardParr=wardId_"^"_sysParam.NurMgInter_"^"_wardObj.CTLocDR_"^"_wardObj.WardMGCode_"^"_wardObj.IsWard
 	...d ..GetMinData(dataWardParr,rowStDate,rowEndDate,.tmpMinEle,.tmpNurMgData,.tmpEleType,i,.tmpRowPat)
	...s indexId="" f  s indexId=$O(tmpColumn(indexId)) q:indexId=""  d
	....s indexType=$E(indexId,1)
	....s indexRealId=$E(indexId,2,$L(indexId))
	....q:(indexType="")||(indexRealId="")
	....;进行指标/元素过滤病区
	....s calStr=$g(tmpColumnCal(indexId))
	....q:calStr=""
	....s value=..GetCalValue(calStr,.tmpMinEle)
	....q:value=""
	....i indexType="E" d ;元素
	.....;s eleObj=##class(CT.DHCNS.Config.NsElement).%OpenId(indexRealId)
	.....s value=$P(value,"^",1)
	....i indexType="I" d ;指标
	.....s value=..GetIndexValue(indexRealId,value)
	....s ret=ret_"^"_indexId_"|"_value_"^cal"_indexId_"|"_calStr
	...;q:isExistData=0  ;存在数据则在统计界面显示，否则不显示。
	...d OutPutRowData
	...s DataSort=DataSort+1
	...s minEleId="" f  s minEleId=$O(tmpMinEle(minEleId)) q:minEleId=""  d
	....s tmpMinEleAll(minEleId,i,wardId)=$g(tmpMinEle(minEleId))
	//输出总计
	s ^tmp("sensConut",1)=$P($H,",",2)-startTime
	s startTime=$P($H,",",2)
	s wardDesc=""
	i ward="" s wardDesc="全院"
	e  i ward["H" d
	.s hospitalId=$e(ward,2,$L(ward))
	.s:hospitalId'="" wardDesc=..GetHospitalName(hospitalId)
	e  d
	.s wardObj=##class(DHCNS.Config.NsWard).%New(ward)
	.s:$IsObject(wardObj) wardDesc=wardObj.Desc
	s oneRow=1
	s:rows>1 oneRow=0
	s ret="DataSort|总计^DataDate|^WardId|^UpdateDate|"_"^WardId|"_ward_"^WardDesc|"_wardDesc_"^OneRow|"_oneRow
	s ret=ret_"^rowStDate|"_$zd(stDate,3)_"^rowEndDate|"_$zd(endDate,3)
	s indexId="" f  s indexId=$O(tmpColumn(indexId)) q:indexId=""  d
	.s indexType=$E(indexId,1)
	.s indexRealId=$E(indexId,2,$L(indexId))
	.q:(indexType="")||(indexRealId="")
	.s calStr=$g(tmpColumnCal(indexId))
	.q:calStr=""
	.s value=..GetHospitalCountData(indexType,indexRealId,.tmpMinEleAll,calStr,rows,ward,"",.tmpRowPat)
	.s ret=ret_"^"_indexId_"|"_value_"^cal"_indexId_"|"_calStr
	d OutPutRowData
 	s ^tmp("sensConut",2)=$P($H,",",2)-startTime
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCountListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCountListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCountListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCountListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:lulin
/// Description:获取公式
/// Date:
/// Table:
/// Input:元素id字符串如"9」5「5」9」"
/// Output：
/// Others:w ##class(web.NurSensConfigComm).GetIndexCalDesc("I11","」(」(」(+」i128」+」i75」+」i79」)」*」9」/」8」)」+」(」(+」i129」+」i76」+」i80」)」*」15」/」8」)」)」「」(」i67」+」i69」)")
ClassMethod GetIndexCalDesc(id As %String = "", parr As %String = "") As %String
{
	s ret=""
	f i=1:1:$L(parr,"」") d
	.s tValue=$P(parr,"」",i)
	.q:tValue=""
	.i tValue["i" d
	..s obj=##class(CT.DHCNS.Config.NsElement).%OpenId($tr(tValue,"i",""))
	..s tValue=""
	..i $IsObject(obj)  d
	...s tValue=obj.EleDesc
	.s endChat=$e(ret,*)
	.s:tValue["「" tValue="÷"
	.s:tValue["/" tValue="÷"
	.s:tValue["*" tValue="×"
	.s ret=ret_tValue
	i id["I" d
	.s indexObj=##class(CT.DHCNS.Config.NsIndex).%OpenId(id)
	.i $IsObject(indexObj) d
	..s unit=indexObj.Unit
	..i unit="I" s ret="1:"_ret
	..s:unit="T" ret="("_ret_")"_unit_"‰"
	..s:unit="P" ret="("_ret_")"_unit_"％"
	q ret
}

/// Creator:lulin
/// Description:查询统计数据明细左侧列表最小元素名称。
/// Date:2020-01-10
/// Table:
/// Input:元素id字符串如"9」5「5」9」"
/// Output：
/// Others:d ##class(%ResultSet).RunQuery("web.NurSensConfigComm","FindDetailCatalog",^TMP("FindDetailCatalog"))
Query FindDetailCatalog(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindDetailCatalogExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp) 
	s ind=1
	s tmpRet=""
	f i=1:1:$L(parr,"」")  d
	.s id=$P(parr,"」",i)
	.q:id'["i"
	.s realId=$tr(id,"i","")
	.q:realId=""
	.s tmpRet(realId)=1
	s ret=""
	s id="" f  s id=$O(tmpRet(id)) q:id=""  d
	.s obj=##class(CT.DHCNS.Config.NsElement).%OpenId(id)
	.q:'$IsObject(obj)
	.s desc=obj.EleDesc
	.s ret="rw|"_id_"^desc|"_desc_"^remark|"_obj.Remark
	.d OutPutRowData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDetailCatalogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDetailCatalogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDetailCatalogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDetailCatalogExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:lulin
/// Description:查询统计数据明细
/// Date:2020-01-10
/// Table:
/// Input:元素id、病区、开始日期、结束日期
/// Output：
/// Others:d ##class(%ResultSet).RunQuery("web.NurSensConfigComm","FindDetailTableData","80^29^2021-08-03^2021-08-03^3^0")
Query FindDetailTableData(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindDetailTableDataExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp) 
	s ind=1
	s ret=""
	s eleId=$p(parr,"^",1)
	s FindWardID=$p(parr,"^",2)
	s rowStDate=$p(parr,"^",3)
	s rowEndDate=$p(parr,"^",4)
	s modelId=$p(parr,"^",5)
	s wardType=$P(parr,"^",6)
	if (eleId="")||(rowStDate="")||(rowEndDate=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s rowStDate=$zdh(rowStDate,3)
	s rowEndDate=$zdh(rowEndDate,3)
	s obj=##class(CT.DHCNS.Config.NsElement).%OpenId(eleId)
	i '$IsObject(obj)||((obj.DataMode'="M")&&(obj.DataMode'="A")) { //q:非手动或自动元素
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s sysParam=##class(DHCNS.Config.NsSysParam).%New(1)
	s FindWardQuit=0,tmpFindWard="",tmpWardLocUnit=""
	s startTime=$P($H,",",2)
	d ..SetTmpWardLocUnit(.tmpWardLocUnit)
	;模板过滤病区
	i modelId'="" d
	.s modelObj=##class(CF.DHCNS.Config.NsModel).%OpenId(modelId)
	.i $IsObject(modelObj) d
	..i modelObj.UseType="H" s FindWardQuit=0
	..e  i modelObj.UseType="L" d
	...s FindWardQuit=1
	...s locUnitLocId=""  f  s locUnitLocId=$O(tmpWardLocUnit("Loc",locUnitLocId)) q:(locUnitLocId="")  d
	....s locUnitWardId=""  f  s locUnitWardId=$O(tmpWardLocUnit("Loc",locUnitLocId,locUnitWardId)) q:(locUnitWardId="")  d
	.....i modelObj.UseLimit.Find(locUnitWardId)>0 s tmpFindWard(locUnitWardId)=1
	..e  i modelObj.UseType="W" d
	...s FindWardQuit=1
	...f i=1:1:modelObj.UseLimit.Count() d
	....s limitWardId=modelObj.UseLimit.GetAt(i)
	....q:limitWardId=""
	....s tmpFindWard(limitWardId)=1
	//院区过滤病区
	s tmpHospitalWard="",tmpWardI=""
	d ..SetTmpWardI(.tmpWardI)
	i FindWardID["H"  d
	.s hospitalId=$e(FindWardID,2,$L(FindWardID))
	.i hospitalId'="" d
	..s hospitalWardId="" f  s hospitalWardId=$O(tmpWardI("Hospital",hospitalId,hospitalWardId)) q:hospitalWardId=""  d
	...s tmpHospitalWard(hospitalWardId)=1
	s tmpWard=""
	d ..SetTmpWard(.tmpWard)
	
	
	s dualType=obj.DualType
	s autoType=obj.AutoType
	s stSelDateSt=rowStDate,stSelDateEnd=rowEndDate
	i dualType="A" s stSelDateEnd=rowStDate  //期初、期末
	i dualType="E" s stSelDateSt=rowEndDate
	s DataSort=1
	s tmpMinEle(eleId)=0,tmpEleType=""
	s isNurMgFlag=..SetTypeTmp(.tmpMinEle,.tmpEleType) ;是否有护管相关数据
	s wardSort="" f  s wardSort=$O(tmpWard(wardSort)) q:wardSort=""  d
	.s wardId="" f  s wardId=$O(tmpWard(wardSort,wardId)) q:wardId=""  d
	..q:((FindWardID'["H")&&(FindWardID'="")&&(FindWardID'=wardId)) ;过滤查询病区
	..q:((FindWardID["H")&&($g(tmpHospitalWard(wardId))="")) ;过滤掉非本院区
	..q:((FindWardQuit'=0)&&($g(tmpFindWard(wardId))'=1)) ;过滤掉模板需要统计的病区
	..q:((obj.FilterWard.Count()>0)&&(obj.FilterWard.Find(wardId)>0))
	..s wardObj=##class(DHCNS.Config.NsWard).%New(wardId)
	..q:((wardObj.StDate'="")&&(wardObj.StDate>rowEndDate))
	..q:((wardObj.EndDate'="")&&(wardObj.EndDate<=rowStDate))
	..q:((wardType=1)&&((FindWardID="")||(FindWardID["H"))&&(wardObj.ClassDesc'["手术"))
	..s wardDesc=wardObj.Desc
	..s CTLocDR=wardObj.CTLocDR
	..d SubData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	s DataSort=DataSort+1
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
SubData
	if obj.DataMode="M"{ ;手动数据
		s dataDate=stSelDateSt-1 f  s dataDate=$O(^DHCNS.Config.NsEditDataI("IndexDay"," E"_eleId,wardId,dataDate)) q:(dataDate="")||(dataDate>stSelDateEnd)  d
		.s editId="" f  s editId=$O(^DHCNS.Config.NsEditDataI("IndexDay"," E"_eleId,wardId,dataDate,editId)) q:editId=""  d
		..s editObj=##class(DHCNS.Config.NsEditData).%OpenId(editId)
		..q:'$IsObject(editObj)
		..s Update=editObj.DataTime
		..s Updator=..GetUserName(editObj.Updator)
		..s SubDesc=editObj.Value
		..s KeyWord="手动填写"
		..s ret="DataSort|"_DataSort_"^KeyWord|"_KeyWord_"^SubDesc|"_SubDesc_"^Updator|"_Updator_"^Update|"_Update
		..d OutPutRowData
	}elseIf autoType="A"{ ;自动-护理管理
		s NurMgType=obj.NurMgType ;护理类型
		s NurMgSubType=obj.NurMgSubType
		s IsRegister=obj.IsRegister
		s:IsRegister="" IsRegister="Y"
		s IsDuty=obj.IsDuty
		s:IsDuty="" IsDuty="Y"
		s sysParam=##class(DHCNS.Config.NsSysParam).%New(1)
		s:(wardObj.WardMGCode'="") CTLocDR=wardObj.WardMGCode ;第三方存护管工号代码
		s:(sysParam.NurMgInter="W") CTLocDR=wardId
		i CTLocDR'=""  d
		.s date=stSelDateSt-1 f  s date=$O(^DHCNS.Config.NsAutoMgDataI("key",date)) q:((date="")||(date>stSelDateEnd))  d
		..s dataKey="" f  s dataKey=$O(^DHCNS.Config.NsAutoMgDataI("key",date,dataKey)) q:dataKey=""  d
		...s mgId=""  f  s mgId=$O(^DHCNS.Config.NsAutoMgDataI("key",date,dataKey,mgId)) q:mgId=""  d
		....s mgobj=##class(DHCNS.Config.NsAutoMgData).%OpenId(mgId)
		....q:'$IsObject(obj)
		....s tCtLocId=mgobj.CTLocDR
		....q:tCtLocId="9999"  ;作废区
		....q:tCtLocId="9998"  ;退休区
		....q:tCtLocId=""
		....q:((tCtLocId=9997)&&(CTLocDR'=mgobj.NurBeforWard))  //离职前病区与所查不符合
		....q:((tCtLocId'=9997)&&(CTLocDR'=tCtLocId))
		....q:(NurMgType'="Q")&&(tCtLocId=9997) ;查在职
		....q:(NurMgType="Q")&&(tCtLocId'=9997) ;查离职
		....s tIsRegister=mgobj.IsRegister
		....s:tIsRegister="" tIsRegister="Y"
		....q:((IsRegister="Y")&&(tIsRegister'="Y"))
		....s isExistFlag=0
		....s DayCount=mgobj.DayCount,NightCount=mgobj.NightCount,AllDayCount=mgobj.AllDayCount
		....i ((IsDuty="Y"))  d
		.....s DayCount=mgobj.DayCountDuty,NightCount=mgobj.NightCountDuty,AllDayCount=mgobj.AllDayCountDuty
		....s:(((NurMgType="D")||(NurMgType="DN"))&&(+DayCount=0)) isExistFlag=1
		....s:(((NurMgType="N")||(NurMgType="NN"))&&(+NightCount=0)) isExistFlag=1
		....s:(((NurMgType="V")||(NurMgType="VN"))&&(+AllDayCount=0)) isExistFlag=1
		....q:isExistFlag=1
		....i ((NurMgType'="O")&&(NurMgType'="I")) d
		.....;白班上班护士、白班小时数、夜班上班护士、夜班数、0-0班次;输出
		.....s SubDesc=mgobj.PersonName_"("_mgobj.NurseID_")"
		.....s:((NurMgType="D")||(NurMgType="DN")) SubDesc=$fn(DayCount,"",2)
		.....s:((NurMgType="N")||(NurMgType="NN")) SubDesc=$fn(NightCount,"",2)
		.....s:((NurMgType="V")||(NurMgType="VN")) SubDesc=$fn(AllDayCount,"",2)
		.....s KeyWord=mgobj.PersonName_"("_mgobj.NurseID_")" ;姓名/工号
		.....s ret="DataSort|"_DataSort_"^KeyWord|"_KeyWord_"^SubDesc|"_SubDesc_"^Updator|系统任务^Update|"_$zd(date,3)
		.....d OutPutRowData
		....e  d
		.....i (NurMgSubType="W") d  ;总值
		......s KeyWord=mgobj.NurseID
		......s SubDesc=mgobj.PersonName
		......s ret="DataSort|"_DataSort_"^KeyWord|工号"_KeyWord_"^SubDesc|"_SubDesc_"^Updator|系统任务^Update|"_$zd(date,3)
		......d OutPutRowData
		.....i NurMgSubType="E" d ;学历
		......i obj.NurMgSubTypeID=mgobj.AdcaDR d
		.......s KeyWord=mgobj.NurseID
		.......s SubDesc=mgobj.PersonName
		.......s ret="DataSort|"_DataSort_"^KeyWord|工号"_KeyWord_"^SubDesc|"_SubDesc_"^Updator|系统任务^Update|"_$zd(date,3)
		.......d OutPutRowData
		.....i NurMgSubType="P"  d  ;职务
		......i obj.NurMgSubTypeID=mgobj.HeadShipDR d
		.......s KeyWord=mgobj.NurseID
		.......s SubDesc=mgobj.PersonName
		.......s ret="DataSort|"_DataSort_"^KeyWord|工号"_KeyWord_"^SubDesc|"_SubDesc_"^Updator|系统任务^Update|"_$zd(date,3)
		.......d OutPutRowData
		.....i NurMgSubType="D" d ;职称
		......i obj.NurMgSubTypeID=mgobj.AppDutyDR d
		.......s KeyWord=mgobj.NurseID
		.......s SubDesc=mgobj.PersonName
		.......s ret="DataSort|"_DataSort_"^KeyWord|工号"_KeyWord_"^SubDesc|"_SubDesc_"^Updator|系统任务^Update|"_$zd(date,3)
		.......d OutPutRowData
		.....i NurMgSubType="S"  d ;年资
		......s workDate=mgobj.WorkDate
		......s:workDate="" workDate=mgobj.ComeDate
		......s IsOnlyWard=obj.IsOnlyWard
		......s tDate=date
		......s:IsOnlyWard="Y" tDate=mgobj.WardWorkDay,workDate=1
		......i workDate'="" d
		.......s:workDate["-" workDate=$zdh(workDate,3)
		.......s year=##class(web.NurSensUtilComm).CalAge(workDate,tDate)
		.......i (((obj.SenioritySt="")||(obj.SenioritySt<=year))&&((obj.SeniorityEnd="")||(obj.SeniorityEnd>year))) d
		........s KeyWord=mgobj.PersonName_"("_mgobj.NurseID_")"
		........s SubDesc=year
		........s ret="DataSort|"_DataSort_"^KeyWord|"_KeyWord_"^SubDesc|"_SubDesc_"^Updator|系统任务^Update|"_$zd(date,3)
		........d OutPutRowData
	}elseIf (((autoType="O")||(autoType="L"))&&(CTLocDR'="")) { ;自动-例次、留置日数、患者数
		s OrderType=obj.OrderType
		s orderTime=obj.OrderTime
		k TMPNurSensOrder
		s TMPNurSensOrder=""
		d ..GetAutoOrderData(eleId, wardId, stSelDateSt, stSelDateEnd,"S",.TMPNurSensOrder,.tmpEleType)
		s tSort="" f  s tSort=$O(TMPNurSensOrder(tSort)) q:tSort=""  d
		.s ret=$g(TMPNurSensOrder(tSort))
		.q:ret=""
		.d OutPutRowData
	}elseIf((autoType="V")&&(CTLocDR'="")){ ;不良事件
		s WardDescNative=wardObj.Desc
		s pacward="",WardDesc=""
		i CTLocDR'="" d
		.;s LocDesc=$P($p(^CTLOC(ctLocId),"^",2),"-",2)
		.s pacward=$O(^PAWARD(0,"WARD_LocationDR",CTLocDR,""))
		.i pacward'="" d
		..s WardDesc=$P(^PAWARD(pacward),"^",2)
		s:WardDesc["-" WardDesc=$P(WardDesc,"-",2)
		s advTypes=obj.AdvType
		s advType=$P(advTypes,",",1) ;GDHT;DD;YC
		s advType2=$P(advTypes,",",2) ;导尿管/胃肠管/PICC/气管导管;S/H;S/Q
		s advType3=$P(advTypes,",",3) ;"";"";"";"";"";0/1/2/3/4;"";1/-1
		s advDual=obj.AdvDual
		s advDualNightFlag=0
		s dataDate=stSelDateSt-1 f  s dataDate=$O(^DHCNS.Config.NsAutoAdvI("TypeDate"," "_advType,dataDate)) q:(dataDate="")||(dataDate>stSelDateEnd)  d
		.s advId="" f  s advId=$O(^DHCNS.Config.NsAutoAdvI("TypeDate"," "_advType,dataDate,advId)) q:advId=""  d
		..s advObj=##class(DHCNS.Config.NsAutoAdv).%OpenId(advId)
		..q:'$IsObject(advObj)
		..s flag=..GetAdvFlag(advId,CTLocDR,WardDesc,WardDescNative,advDual,advDualNightFlag,advType,advType2,advType3)
		..q:flag=0
	    ..s dataDateStr=$zd(dataDate,3)
		..s Updator="系统任务"
		..s SubDesc=advObj.PaName_"("_advObj.PaRecord_advObj.PaSex_")"
		..s KeyWord=advObj.DataId
	    ..s ret="DataSort|"_DataSort_"^KeyWord|"_KeyWord_"^SubDesc|"_SubDesc_"^Updator|"_Updator_"^Update|"_dataDateStr
		..d OutPutRowData
		i advDual="N" d
		.s advDualNightFlag=1
		.s dataDate=stSelDateSt f  s dataDate=$O(^DHCNS.Config.NsAutoAdvI("TypeDate"," "_advType,dataDate)) q:(dataDate="")||(dataDate>(stSelDateEnd+1))  d
		..s advId="" f  s advId=$O(^DHCNS.Config.NsAutoAdvI("TypeDate"," "_advType,dataDate,advId)) q:advId=""  d
		...s advObj=##class(DHCNS.Config.NsAutoAdv).%OpenId(advId)
		...q:'$IsObject(advObj)
		...s flag=..GetAdvFlag(advId,CTLocDR,WardDesc,WardDescNative,advDual,advDualNightFlag,advType,advType2,advType3)
		...q:flag=0
	    ...s dataDateStr=$zd(dataDate,3)
		...s Updator="系统任务"
		...s SubDesc=advObj.PaName_"("_advObj.PaRecord_advObj.PaSex_")"
		...s KeyWord=advObj.DataId
	    ...s ret="DataSort|"_DataSort_"^KeyWord|"_KeyWord_"^SubDesc|"_SubDesc_"^Updator|"_Updator_"^Update|"_dataDateStr
		...d OutPutRowData
	}elseIf(autoType="P"){ ;患者
		s patType=obj.PatType
		s IsNoBaby=obj.IsNoBaby
		s:IsNoBaby="" IsNoBaby="Y"
		s SubType=obj.PatSubType,SubValue=obj.PatSubValue,subEndValue=obj.PatSubEndValue,SubValueType=obj.PatSubValueType
		s dataDate=stSelDateSt-1 f  s dataDate=$O(^DHCNS.Config.NsAutoPatI("Index"," "_patType,wardId,dataDate)) q:(dataDate="")||(dataDate>stSelDateEnd)  d
		.s autoPatId="" f  s autoPatId=$O(^DHCNS.Config.NsAutoPatI("Index"," "_patType,wardId,dataDate,autoPatId)) q:autoPatId=""  d
		..s autoPatObj=##class(DHCNS.Config.NsAutoPat).%OpenId(autoPatId)
		..q:'$IsObject(autoPatObj)
		..s Update=$zd(autoPatObj.DataDate,3)
		..s Updator="系统任务"
		..s patSubId="" f  s patSubId=$O(^DHCNS.Config.NsAutoPatSubD(autoPatId,patSubId)) q:patSubId=""  d
		...s patSubObj=##class(DHCNS.Config.NsAutoPatSub).%OpenId(autoPatId_"||"_patSubId)
		...q:'$IsObject(patSubObj)
		...q:((IsNoBaby="Y")&&(patSubObj.IsBaby="Y")) ;
		...s PerDiagnos=patSubObj.PerDiagnos
		...s PerLevelDiagnos=patSubObj.PerLeaveDiagnos
		...s diagnosFlag=0,levelDiagnosFlag=0 ;默认不符合
		...i ((SubValue'="")&&((SubType="D")||(SubType="L"))) d
		....i ((PerDiagnos'="")||(PerLevelDiagnos'="")) d
		.....f diagnosIndex=1:1:$L(SubValue,",") q:((diagnosFlag=1)&&(levelDiagnosFlag=1))  d
		......s diagnosDesc=$p(SubValue,",",diagnosIndex)
		......q:diagnosDesc=""
		......s:(PerDiagnos[diagnosDesc) diagnosFlag=1
		......s:(PerLevelDiagnos[diagnosDesc) levelDiagnosFlag=1
		...s:(SubValue="") diagnosFlag=1,levelDiagnosFlag=1
		...q:((SubType="D")&&(diagnosFlag=0)) ;诊断
		...q:((SubType="L")&&(levelDiagnosFlag=0)) ;出院诊断
		...s existFlag=0
		...s PerBirthDateDesc="",AdmDateDesc=""
		...i SubType="Y" d
		....s:((SubValue="")&&(subEndValue="")) existFlag=0 ;空取全部
		....s AdmDate=patSubObj.AdmDate
		....s PerBirthDate=patSubObj.PerBirthDate
		....i PerBirthDate["-" d
		.....s PerBirthDate=$zdh(PerBirthDate,3)
		....e  d
		.....s PerBirthDate=""
		....s:((SubValue'="")||(subEndValue'="")) existFlag=..IsInDateDual(SubValue,subEndValue,PerBirthDate,AdmDate,SubValueType)
		....s:PerBirthDate'="" PerBirthDateDesc=$zd(PerBirthDate,3)
		....s:AdmDate'="" AdmDateDesc=$zd(AdmDate,3)
		...q:existFlag=1
		...s KeyWord=..GetRegNoByEpisodeID($tr(patSubObj.KeyWord," ",""))
		...s SubDesc=patSubObj.SubDesc
		...s:SubType["D" SubDesc=SubDesc_"("_PerDiagnos_")"
		...s:SubType["L" SubDesc=SubDesc_"("_PerLevelDiagnos_")"
		...s:SubType["Y" SubDesc=SubDesc_";出生日期:"_PerBirthDateDesc_";就诊日期:"_AdmDateDesc
		...s ret="DataSort|"_DataSort_"^KeyWord|"_KeyWord_"^SubDesc|"_SubDesc_"^Updator|"_Updator_"^Update|"_Update
		...d OutPutRowData
	}elseIf(autoType="I"){ ;院感
		s InfType=obj.InfType
		s dataDate=stSelDateSt-1 f  s dataDate=$O(^DHCNS.Config.NsAutoInfI("TypeDate"," "_InfType,dataDate)) q:(dataDate="")||(dataDate>stSelDateEnd)  d
		.s infId="" f  s infId=$O(^DHCNS.Config.NsAutoInfI("TypeDate"," "_InfType,dataDate,infId)) q:infId=""  d
		..s infObj=##class(DHCNS.Config.NsAutoInf).%OpenId(infId)
		..q:'$IsObject(infObj)
		..q:infObj.RepStatus'=3
		..s ret=""
		..s p="" f  s p=$O(^oddCOM("DHCNS.Config.NsAutoInf","a",p)) q:p=""  d
		...q:p["%"
		...s value=$ZOBJPROPERTY(infObj,p)
		...s ret=ret_"^"_p_"|"_value
		..d OutPutRowData
	}elseif(autoType="H"){
		k tmpPatANData
		s tmpPatANData=""
		d ..GetAutoANData(eleId,wardId,stSelDateSt,stSelDateEnd,"S",.tmpEleType,.tmpPatANData)
		s tSort="" f  s tSort=$O(tmpPatANData(tSort)) q:tSort=""  d
		.s ret=$g(tmpPatANData(tSort))
		.q:ret=""
		.d OutPutRowData	
	}else{ ;自动-其他,如果有分离出来在增加R:护理病历,R:不良事件,Z:其他
		k tmpOtherData
		s tmpOtherData=""
		s repeatFlag=obj.RepeatFlag
		s dataDate=stSelDateSt-1 f  s dataDate=$O(^DHCNS.Config.NsAutoDataI("Index",eleId,wardId,dataDate)) q:(dataDate="")||(dataDate>stSelDateEnd)  d
		.s autoId="" f  s autoId=$O(^DHCNS.Config.NsAutoDataI("Index",eleId,wardId,dataDate,autoId)) q:autoId=""  d
		..s autoObj=##class(DHCNS.Config.NsAutoData).%OpenId(autoId)
		..q:'$IsObject(autoObj)
		..s Update=$zd(autoObj.DataDate,3)
		..s Updator="系统任务"
		..s autoSubId="" f  s autoSubId=$O(^DHCNS.Config.NsAutoDataSubD(autoId,autoSubId)) q:autoSubId=""  d
		...s autoSubObj=##class(DHCNS.Config.NsAutoDataSub).%OpenId(autoId_"||"_autoSubId)
		...q:'$IsObject(autoSubObj)
		...q:autoSubObj.KeyWord=""
		...q:((repeatFlag="Y")&&($d(tmpOtherData(autoSubObj.KeyWord))))
		...s tmpOtherData(autoSubObj.KeyWord)=1
		...s KeyWord=autoSubObj.KeyWord
		...s SubDesc=autoSubObj.SubDesc
		...s ret="DataSort|"_DataSort_"^KeyWord|"_KeyWord_"^SubDesc|"_SubDesc_"^Updator|"_Updator_"^Update|"_Update
		...d OutPutRowData
	}
}

ClassMethod FindDetailTableDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDetailTableDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDetailTableDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDetailTableDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:lulin
/// Description:保存元素关联医嘱、手术项目
/// Date:2019-12-26
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod SaveOrderArc(parr As %String, par As %String) As %String
{
	q:((parr="")!(par="")) "入参为空"
	s flag=1
	s len=$l(parr,"^")
	s parObj=##class(CT.DHCNS.Config.NsElement).%OpenId(par)
	q:'$IsObject(parObj) "未找到相关元素"
	s AutoType=parObj.AutoType
	f i=1:1:len
	{
		s itm=$p(parr,"^",i)
		i itm="" continue
		s orderId=$P(itm,"「",1)
		s orderDesc=$P(itm,"「",2)
		q:orderId=""
		s rw=$o(^CT.DHCNS.Config.NsEleTypeI("itm",par," "_orderId,""))
		i rw="" d
		.s obj=##class(CT.DHCNS.Config.NsEleType).%New()
		.s obj.Parref=parObj
		e  d
		.s obj=##class(CT.DHCNS.Config.NsEleType).%OpenId(par_"||"_rw)
		s obj.TypeID=orderId
		s obj.TypeDesc=orderDesc
		s obj.TypeFlag="N"
		i ((AutoType="L")||(AutoType="O")) {
			s obj.MotherFlag="N"
		}
		s sc=obj.%Save()
		s:'$$$ISOK(sc) flag="保存失败"
		q:flag'=1
	}
	
	q flag
}

/// Creator:lulin
/// Description:保存元素关联医嘱项目
/// Date:2019-12-26
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod SaveOrderTable(parr As %String) As %String
{
	s len=$l(parr,"「")
	s ret=1
	TS
	f i=1:1:len
	{
		s itm=$p(parr,"「",i)
		i itm="" continue
		s rw=$P(itm,"^",1)
		q:rw=""
		s obj=##class(CT.DHCNS.Config.NsEleType).%OpenId(rw)
		s obj.TypeFlag=$P(itm,"^",2)
		s obj.DoseQty=$P(itm,"^",3)
		s obj.OrderInstrDR=$P(itm,"^",4)
		s obj.MotherFlag=$P(itm,"^",5)
		s obj.OrderUnit=$P(itm,"^",6)
		s flag=$$$ISOK(obj.%Save())
		s:'flag ret="保存失败"
		q:ret'=1
	}
	if ret=1{
		TC	
	}else{
		TRO	
	}
	q ret
}

/// Creator:lulin
/// Description:删除元素医嘱项目
/// Date:2019-12-26
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod DelOrderItm(parr As %String) As %String
{
	s len=$p(parr,"^")
	s flag=1
	f i=1:1:len
	{
		s itm=$p(parr,"^",i)
		i itm="" continue
		s par=$p(itm,"|",1)
		s rw=$p(itm,"|",2)
		s obj=##class(CT.DHCNS.Config.NsEleType).%OpenId(par_"||"_rw)
		i '$IsObject(obj) continue
		s sc=obj.%DeleteId(par_"||"_rw)
		s flag=($$$ISOK(sc)&&flag)
	}
	q flag
}

/// Creator:lulin
/// Description:获取元素已关联医嘱项目
/// Date:2019-12-26
/// Table:
/// Input:
/// Output：
/// Others:d ##class(%ResultSet).RunQuery("web.NurSensConfigComm","FindOrderTable","359","")
Query FindOrderTable(par As %String, flag As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindOrderTableExecute(ByRef qHandle As %Binary, par As %String, flag As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	i par="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s rw="" f  s rw=$o(^CT.DHCNS.Config.NsEleTypeD(par,rw)) q:rw=""  d
	.s obj=##class(CT.DHCNS.Config.NsEleType).%OpenId(par_"||"_rw)
	.q:'$IsObject(obj)
	.s TypeID=obj.TypeID
	.q:TypeID=""
	.s typeDesc=obj.TypeDesc
	.s AutoType=obj.Parref.AutoType
	.i ((AutoType="L")||(AutoType="O")) d
	..s ArcimPar=$P(TypeID,"||",1)
	..s ArcimSub=$P(TypeID,"||",2)
	..s:((ArcimPar'="")&&(ArcimSub'="")) typeDesc=$p($g(^ARCIM(ArcimPar,ArcimSub,1)),"^",2)
	.s TypeCode=""
	.s:(AutoType="H") typeDesc=$P($g(^ORC("OPER",TypeID)),"^",2),TypeCode=$P($g(^ORC("OPER",TypeID)),"^",1)
	.s typeFlag=obj.TypeFlag
	.s DoseQty=obj.DoseQty
	.s OrderUnit=obj.OrderUnit
	.s OrderUnitDesc=""
	.s:OrderUnit'="" OrderUnitDesc=$P($g(^CT("UOM",OrderUnit)),"^",3)
	.s OrderInstrDR=obj.OrderInstrDR
	.s MotherFlag=obj.MotherFlag
	.s:MotherFlag="" MotherFlag="N"
	.s ret="TypeID|"_TypeID_"^TypeDesc|"_typeDesc_"^par|"_par_"^rw|"_rw_"^TypeFlag|"_typeFlag
	.s ret=ret_"^DoseQty|"_DoseQty_"^OrderInstrDR|"_OrderInstrDR_"^MotherFlag|"_MotherFlag
	.s ret=ret_"^OrderUnit|"_OrderUnit_"^OrderUnitDesc|"_OrderUnitDesc_"^TypeCode|"_TypeCode
	.do OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindOrderTableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrderTableExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOrderTableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrderTableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:判断指标是否只有和值的元素
/// Date:2020-03-18
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod isIndexOnlyDual(indexRealId As %String = "") As %String
{
	q:indexRealId="" 0
	s flag=1
	s subId="" f  s subId=$O(^CT.DHCNS.Config.NsIndexSubD(indexRealId,subId)) q:(subId="")||(flag=0)  d
	.s subObj=##class(CT.DHCNS.Config.NsIndexSub).%OpenId(indexRealId_"||"_subId)
	.q:'$IsObject(subObj)
	.i subObj.SubProp.DualType'="S" s flag=0
	q flag
}

/// Creator:lulin
/// Description:判断指标是否只有和值的元素
/// Date:2020-03-18
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetOtherNum(indexRealId As %String = "") As %String
{
	q:(indexRealId="") 1
	s indexObj=##class(CT.DHCNS.Config.NsIndex).%OpenId(indexRealId)
	q:'$IsObject(indexObj) 1
	s ret=1
	f i=1:1:indexObj.NumOther.Count() d
	.s value=indexObj.NumOther.GetAt(i)
	.q:value=""
	.s method=$P(value,"」",1)
	.s num=$P(value,"」",2)
	.s tData=num
	.i method="D" s tData=1/tData
	.s ret=ret*tData
	f i=1:1:indexObj.DenOther.Count() d
	.s value=indexObj.DenOther.GetAt(i)
	.q:value=""
	.s method=$P(value,"」",1)
	.s num=$P(value,"」",2)
	.s tData=num
	.i method="N" s tData=1/tData
	.s ret=ret*tData
	q ret
}

/// Creator:lulin
/// Description:查询统计数据---竖版
/// Date:2019-12-15
/// Table:
/// Input:parr:全院、频率、开始时间、结束时间
/// Output：包头包尾
/// Others:d ##class(%ResultSet).RunQuery("web.NurSensConfigComm","FindCountListForReport","^Q^2020-01-01^2020-03-31^3","E50,E137,E139,E51,E52,E134,E138,E140,E172,E135,E136,I3,I99,I100,I4,I5,E75,E79,I103,I84,E76,E80,I104,I85,I2,I1,I49")
Query FindCountListForReport(parr As %String = "", columns As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCountListForReportExecute(ByRef qHandle As %Binary, parr As %String = "", columns As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindCountList")=parr_","_columns
	//如果是模板过滤模板开始的日期,增加入参模板
	s ret=""
	s ward=$P(parr,"^",1)
	s rate=$P(parr,"^",2)
	s stDate=$P(parr,"^",3)
	i stDate["-" s stDate=stDate
	e  s stDate=""
	s endDate=$P(parr,"^",4) 
	i endDate["-" s endDate=endDate
	e  s endDate=""
	s findModelId=$P(parr,"^",5) 
	s wardType=$P(parr,"^",6)
	if (rate="")||(stDate="")||(endDate="")||(columns="")||((ward'="")&&(ward'["H")){
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
	s sysParam=##class(DHCNS.Config.NsSysParam).%New(1)
	s findModelObj="",FindWardQuit=0,tmpFindWard="",tmpWardLocUnit=""
	d ..SetTmpWardLocUnit(.tmpWardLocUnit)
	i findModelId'="" d
	.s findModelObj=##class(CF.DHCNS.Config.NsModel).%OpenId(findModelId)
	.i findModelObj.UseType="H" s FindWardQuit=0
	.e  i findModelObj.UseType="L" d
	..s FindWardQuit=1
	..s locUnitLocId=""  f  s locUnitLocId=$O(tmpWardLocUnit("Loc",locUnitLocId)) q:(locUnitLocId="")  d
	...s locUnitWardId=""  f  s locUnitWardId=$O(tmpWardLocUnit("Loc",locUnitLocId,locUnitWardId)) q:(locUnitWardId="")  d
	....i findModelObj.UseLimit.Find(locUnitWardId)>0 s tmpFindWard(locUnitWardId)=1
	.e  i findModelObj.UseType="W" d
	..s FindWardQuit=1
	..f i=1:1:findModelObj.UseLimit.Count() d
	...s limitWardId=findModelObj.UseLimit.GetAt(i)
	...q:limitWardId=""
	...s tmpFindWard(limitWardId)=1
	//选择某院区
	s tmpHospitalWard="",tmpWardI=""
	d ..SetTmpWardI(.tmpWardI)
	i ward["H"  d
	.s hospitalId=$e(ward,2,$L(ward))
	.i hospitalId'="" d
	..s hospitalWardId="" f  s hospitalWardId=$O(tmpWardI("Hospital",hospitalId,hospitalWardId)) q:hospitalWardId=""  d
	...s tmpHospitalWard(hospitalWardId)=1
	//.转换时间格式得到年-月-日
	s stYear=$fn($P(stDate,"-",1),"",0)
	s endYear=$fn($P(endDate,"-",1),"",0)
	s stMonthNum=$fn($P(stDate,"-",2),"",0)
	s endMonthNum=$fn($P(endDate,"-",2),"",0)
	s stDate=$zdh(stDate,3)
	s endDate=$zdh(endDate,3)
	//计算需要输出数据行数
	s rows=0
	if rate="D" {
		s rows=endDate-stDate+1
	}elseif rate="Y" {
		s rows=endYear-stYear+1
	}else{
		s step=$case(rate,"M":1,"Q":3,"H":6,:1) ;一个周期几个月
		s yearStep=$case(rate,"M":12,"Q":4,"H":2,:12)	;一年多少个周期
		s rows=((endYear-stYear)*yearStep)+((endMonthNum-stMonthNum+1)\step)
	}
	;循环需要获取那些自动或者手动上传数据及
	s tmpColumn="",tmpColumnIndex="",tmpWard=""
	d ..SetTmpWard(.tmpWard)
	f i=1:1:$L(columns,",") d
	.s indexId=$P(columns,",",i)
	.q:indexId=""
	.s tmpColumn(indexId)=0
	;需要获取的最小元素,每个指标/元素对最小元素的计算公式。
	s tmpMinEle="",tmpColumnCal="",tmpMinEleAll="",isNurMgFlag=0,tmpEleType="",tmpRowPat=""
	d ..SetMinAndCal(.tmpColumn,.tmpMinEle,.tmpColumnCal)
	s isNurMgFlag=..SetTypeTmp(.tmpMinEle,.tmpEleType) ;是否有护管相关数据
	s DataSort=1,tmpRet=""
	f i=1:1:rows  d ;第几行
	.s dateDual=..GetDateFormat(stYear,stMonthNum,stDate,i,rate)
	.q:dateDual=""
	.s dateDesc=$P(dateDual,"^",4)
	.s dateTime=$P(dateDual,"^",1)
	.s rowStDate=$P(dateDual,"^",2)
	.s rowEndDate=$P(dateDual,"^",3)
	.k tmpNurMgData
	.s tmpNurMgData=""
	.d:isNurMgFlag=1 ..GetAutoMgData(rowStDate, rowEndDate,.tmpNurMgData)
	.;日期、指标、病区
	.s wardSort="" f  s wardSort=$O(tmpWard(wardSort)) q:wardSort=""  d
	..s wardId="" f  s wardId=$O(tmpWard(wardSort,wardId)) q:wardId=""  d
	...q:((ward'["H")&&(ward'="")&&(ward'=wardId))
	...q:((ward["H")&&($g(tmpHospitalWard(wardId))=""))
	...q:((FindWardQuit'=0)&&($g(tmpFindWard(wardId))'=1)) ;过滤掉模板需要统计的病区
	...s wardObj=##class(DHCNS.Config.NsWard).%New(wardId)
	...;只要模板使用范围
	...;q:(wardObj.CTLocDR="")
	...q:((wardObj.StDate'="")&&(wardObj.StDate>endDate))
	...q:((wardObj.EndDate'="")&&(wardObj.EndDate<=stDate))
	...q:((wardType=1)&&((ward="")||(ward["H"))&&(wardObj.ClassDesc'["手术"))
	...s wardDesc=wardObj.Desc
	...s ret="DataSort|"_DataSort_"^DataDate|"_dateTime_"^DataDateDesc|"_dateDesc_"^WardId|"_wardId_"^WardDesc|"_wardDesc
	...s ret=ret_"^rowStDate|"_$zd(rowStDate,3)_"^rowEndDate|"_$zd(rowEndDate,3)
	...s isExistData=0
	...;每次先初始化,获取tmpMinEle值
	...s isNurMgFlagc=..initMinData(.tmpMinEle)
	...;期初、期末、和值已根据数据属性进行分离
	...;先把每行数据存下来？
	...s dataWardParr=wardId_"^"_sysParam.NurMgInter_"^"_wardObj.CTLocDR_"^"_wardObj.WardMGCode_"^"_wardObj.IsWard
 	...d ..GetMinData(dataWardParr,rowStDate,rowEndDate,.tmpMinEle,.tmpNurMgData,.tmpEleType,i,.tmpRowPat)
	...s minEleId="" f  s minEleId=$O(tmpMinEle(minEleId)) q:minEleId=""  d
	....s tmpMinEleAll(minEleId,i,wardId)=$g(tmpMinEle(minEleId))
	//输出
	s oldSubClassDesc=""
	f i=1:1:$L(columns,",") d
	.s indexId=$P(columns,",",i)
	.q:indexId=""
	.s indexType=$E(indexId,1)
	.s indexRealId=$E(indexId,2,$L(indexId))
	.q:((indexType="")||(indexRealId=""))
	.s calStr=$g(tmpColumnCal(indexId))
	.q:calStr=""
	.s SubDesc="",SubClassDesc="",SubNum=""
	.i indexType="E" d ;元素
	..s SubDesc=$LG($G(^CT.DHCNS.Config.NsElementD(indexRealId)),3)
	.e  d
	..s SubDesc=$LG($G(^CT.DHCNS.Config.NsIndexD(indexRealId)),3)
	.s SubNum=..GetHospitalCountData(indexType,indexRealId,.tmpMinEleAll,calStr,rows,ward,"",.tmpRowPat)
	.;模板的指标重定义名称和分类名称
	.i findModelId'=""  d
	..s modelSubId=$O(^CF.DHCNS.Config.NsModelSubI("Prop"," "_indexType,indexRealId,findModelId,""))
	..s modelSubObj=##class(CF.DHCNS.Config.NsModelSub).%OpenId(findModelId_"||"_modelSubId)
	..i $IsObject(modelSubObj) d
	...s tSubDesc=$ZOBJPROPERTY(modelSubObj,"SubDesc"_rate)
	...s:tSubDesc'="" SubDesc=tSubDesc
	...s SubClass=modelSubObj.SubClass
	...i $LG($G(^CT.DHCINM.Set.MgArgParamSetD(1)),24)="Y" d
    ....s SubClassObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(SubClass)
    ....s:$IsObject(SubClassObj) SubClassDesc=SubClassObj.SubDesc
    ...e  d
    ....s SubClassObj=##class(DHCNS.Set.NsSysParamSub).%OpenId(SubClass)
    ....s:$IsObject(SubClassObj) SubClassDesc=SubClassObj.SubDesc
    .i SubClassDesc=oldSubClassDesc d
    ..s SubClassDesc=""
    .e  d
    ..s oldSubClassDesc=SubClassDesc
    .s ret="SubClassDesc|"_SubClassDesc_"^indexId|"_indexId_"^SubDesc|"_SubDesc_"^DataSort|"_i_"^SubNum|"_SubNum
    .//循环每个指标/元素每个日期的值
    .i rows>1  d
    ..f j=1:1:rows  d ;第几行
	...s dateDual=..GetDateFormat(stYear,stMonthNum,stDate,j,rate)
	...q:dateDual=""
	...s key=$P(dateDual,"^",1)
	...s value=..GetHospitalCountData(indexType,indexRealId,.tmpMinEleAll,calStr,rows,ward,j,.tmpRowPat)
	...s ret=ret_"^"_key_"|"_value
	.d OutPutRowData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCountListForReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCountListForReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCountListForReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCountListForReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetHospitalCountData(indexType, indexRealId, tmpMinEleAll, calStr, rows, ward, fixedRow, tmpRowPat)
{
	s retNum=""
	i indexType="E" d ;元素
	.s retNum=..GetCalValueForHospital(calStr,.tmpMinEleAll,"N",rows,fixedRow)
	.s retNum=$P(retNum,"^",1)
	i indexType="I" d ;指标
	.s transStatus=$LG($G(^CT.DHCNS.Config.NsIndexD(indexRealId)),30)
	.s:transStatus="" transStatus="N"
	.s:((ward'["H")&&(ward'="")) transStatus="N" ;总计是否过滤转入
	.s retNum=..GetCalValueForHospital(calStr,.tmpMinEleAll,transStatus,rows,fixedRow,.tmpRowPat)
	.s retNum=..GetIndexValue(indexRealId,retNum)	
	q retNum
}

ClassMethod GetIndexValue(rw, value)
{
	s retValue=""
	s indexObjLB=$g(^CT.DHCNS.Config.NsIndexD(rw))
	q:indexObjLB="" ""
	s unit=$LG(indexObjLB,6)
	s Decimals=$LG(indexObjLB,7)
	s nValue=$P(value,"^",1),dValue=$P(value,"^",2)
	s:dValue=0 retValue=""
	i dValue'=0  d
	.s unitRate=1
	.s:unit="T" unitRate=1000
	.s:unit="P" unitRate=100
	.s:unit="A" unitRate=100
	.s retValue=$fn(((nValue/dValue)*unitRate),"",Decimals)
	.s retValue=$fn(retValue,"",Decimals)
	.s:unit="A" retValue=100-retValue
	e  s retValue=""
	s:retValue="" retValue=0
	i unit="T" s retValue=retValue_"‰"
	e  i ((unit="P")||(unit="A")) s retValue=retValue_"％"
	e  i unit="I" s retValue="1:"_retValue
	q retValue
}

/// Creator:lulin
/// Description:获取病区信息列表
/// Date:2019-11-25
/// Table:
/// Input:
/// Output：
/// Others:
Query FindWardList(parr As %String = "", input As %String = "", loginId As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", loginId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s nowDate=+$H
	s tmpLocWard=""
	s dateFlag=$P(parr,"^",1)
	s nowDate=+$H,retTmp=""
	i $LG($G(^CT.DHCINM.Set.MgArgParamSetD(1)),24)="Y" d
	.s isAll=##class(web.INMLoginComm).SetLoginWard(loginId,.tmpWard)
	.s id="" f  s id=$O(^CF.DHCINM.DB.MgWardD(id)) q:id=""  d
	..q:(isAll=0)&&('$d(tmpWard(id)))
	..s objLB=$G(^CF.DHCINM.DB.MgWardD(id))
	..q:objLB=""
	..s WardStDate=$LG(objLB,11)
	..s WardEndDate=$LG(objLB,12)
	..q:((dateFlag=1)&&(WardStDate'="")&&(WardStDate>nowDate))
	..q:((dateFlag=1)&&(WardEndDate'="")&&(WardEndDate<nowDate))
	..s retValue=##class(web.INMDBComm).GetWard(id)
	..s Sort=$lg(objLB,16)
	..s:Sort="" Sort=9999
	..s retTmp(Sort,id)=retValue
	e  d
	.s tmpWard=""
	.s isAll=##class(web.NurSensLoginComm).SetLoginWard(loginId,.tmpWard)
	.s id="" f  s id=$O(^DHCNS.DB.NsWardD(id)) q:id=""  d
	..s obj=##class(DHCNS.DB.NsWard).%OpenId(id)
	..q:'$IsObject(obj)
	..q:((dateFlag=1)&&(obj.WardStDate'="")&&(obj.WardStDate>nowDate))
	..q:((dateFlag=1)&&(obj.WardEndDate'="")&&(obj.WardEndDate<nowDate))
	..q:((parr'="")&&($g(tmpLocWard(id))'=""))
	..q:((input'="")&&((obj.WardSpell_obj.WardDesc)'[$zcvt($tr(input," ",""),"U")))
	..q:(isAll'=1)&&($g(tmpWard(id))="")
	..s Sort=obj.WardSort
	..s:Sort="" Sort=9999
	..s retTmp(Sort,id)=##class(web.NurSensDBComm).GetWard(id)
 	s Sort="" f  s Sort=$o(retTmp(Sort)) q:Sort=""  d
 	.s id="" f  s id=$O(retTmp(Sort,id)) q:id=""  d
	..s ret=retTmp(Sort,id)
	..d OutWard
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 过滤病区
ClassMethod FiterWardFlag(indexType, indexRealId, wardId) As %String
{
	s filterWardFlag=0
	i indexType="E" d
	.s filterWards=$lg($g(^CT.DHCNS.Config.NsElementD(indexRealId)),31)
	s:((filterWards'="")&&($LF(filterWards,wardId)'=0)) filterWardFlag=1
	e  d
	.s filterWards=$lg($g(^CT.DHCNS.Config.NsIndexD(indexRealId)),31)
	.s:((filterWards'="")&&($LF(filterWards,wardId)'=0)) filterWardFlag=1	
	q filterWardFlag
}

/// Creator:lulin
/// Description:获取院感相关
/// Date:2020-02-22
/// Table:
/// Input:p病区、元素id、开始日期、结束日期、类型（A:期初末,S:和值）
/// Output：
/// Others:
ClassMethod GetAutoInfData(infType, wardId, stDate, endDate, type) As %String
{
	q:(infType="")||(wardId="")||(stDate="")||(endDate="")||(type="") ""
	;advTypes:PICC,CVC,VAP,UC
	s wardObj=##class(DHCNS.Config.NsWard).%New(wardId)
	q:wardObj.CTLocDR=""
	s tStDate=stDate,tEndDate=endDate
	i type="A" {
		s tStDate=stDate,tEndDate=stDate
	}elseif type="E"{
		s tStDate=endDate,tEndDate=endDate
	}
	s value=0
	s dataDate=tStDate-1 f  s dataDate=$O(^DHCNS.Config.NsAutoInfI("TypeDate"," "_infType,dataDate)) q:(dataDate="")||(dataDate>tEndDate)  d
	.s infId="" f  s infId=$O(^DHCNS.Config.NsAutoInfI("TypeDate"," "_infType,dataDate,infId)) q:infId=""  d
	..s objLB=$g(^DHCNS.Config.NsAutoInfD(infId))
	..q:objLB=""
	..s RepWard=$lg(objLB,12)
	..q:RepWard'=wardObj.CTLocDR
	..s RepStatus=$lg(objLB,7)
	..q:RepStatus'=3
	..s value=value+1
	q value
}

/// Creator:lulin
/// Description:获取手术相关
/// Date:2021-07-22
/// Table:
/// Input:病区、元素id、开始日期、结束日期、类型（A:期初末,S:和值）
/// Output：
/// Others:
ClassMethod GetAutoANData(id, wardId, rowStDate, rowEndDate, dualType, tmpEleType, tmpPatANData) As %String
{
	q:(wardId="")||(rowStDate="")||(rowEndDate="")||(dualType="")||(id="") ""
	s wardObj=##class(DHCNS.Config.NsWard).%New(wardId)
	q:wardObj.CTLocDR=""
	s CTLocDR=wardObj.CTLocDR
	s tStDate=rowStDate,tEndDate=rowEndDate
	i dualType="A" {
		s tStDate=rowStDate,tEndDate=rowStDate
	}elseif dualType="E"{
		s tStDate=rowEndDate,tEndDate=rowEndDate
	}
	s value=0,DataSort=1
	f date=tStDate-1:1:tEndDate d
	.s eleTypeID="" f  s eleTypeID=$O(tmpEleType(id,"N",eleTypeID)) q:eleTypeID=""  d
	..s TypeID=$g(tmpEleType(id,"N",eleTypeID))
	..q:TypeID=""
	..s dataId="" f  s dataId=$O(^DHCNS.Config.NsAutoANI("WardDateOp"," "_CTLocDR,date,TypeID,dataId)) q:dataId=""  d
	...s dataLB=$g(^DHCNS.Config.NsAutoAN(dataId))
	...q:dataLB=""
	...s OPAStatus=$lg(dataLB,13)
	...q:OPAStatus'="F"
	...s value=value+1
	...s PatName=$lg(dataLB,5)
	...s OPERDesc=$lg(dataLB,11)
	...s SubDesc=PatName_":"_OPERDesc
	...s ret="DataSort|"_DataSort_"^KeyWord|"_dataId_"^SubDesc|"_SubDesc_"^Updator|系统任务^Update|"_$zd(date,3)
	...s tmpPatANData(DataSort)=ret
	...s DataSort=DataSort+1
	q value
}

/// Creator:lulin
/// Description:获取明细列头
/// Date:2021-08-06
/// Table:
/// Input:
/// Output：
/// Others:d ##class(%ResultSet).RunQuery("web.NurSensConfigComm","FindDetailColumnList",73)
Query FindDetailColumnList(id As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindDetailColumnListExecute(ByRef qHandle As %Binary, id As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""

	s column=$lb("prop","label","width")
	s defaultFlag=1
	i id'="" d
	.s obj=##class(CT.DHCNS.Config.NsElement).%OpenId(id)
	.b ;001
	.i (($IsObject(obj))&&(obj.AutoType="I")) d
	..i obj.InfType="PICC" d
	...s tmp(1)="CtLocDesc^发生病区名称^120"
	...s tmp(2)="PaRecord^住院患者病案号^150"
	...s tmp(3)="AdmDateYear^入院时间(年)^130"
	...s tmp(4)="AdmDateMonth^月^50"
	...s tmp(5)="AdmDateDate^日^50"
	...s tmp(6)="SexDesc^性别^80"
	...s tmp(7)="PatYear^年龄^80"
	...s tmp(8)="InfReason^留置导管的主要原因^180"
	...s tmp(9)="InfPosition^PICC置管位置^120"
	...s tmp(10)="IntubationMode^PICC置管方式^120"
	...s tmp(11)="InfIntubationType^导管类型^120"
	...s tmp(12)="AntibiosisFlag^是否为抗菌导管^120"
	...s tmp(13)="LienTime^发生CLABSI时PICC留置时长(天)^260"
	...s defaultFlag=0
	..e  i obj.InfType="CVC" d
	...s tmp(1)="CtLocDesc^发生病区名称^120"
	...s tmp(2)="PaRecord^住院患者病案号^150"
	...s tmp(3)="AdmDateYear^入院时间(年)^130"
	...s tmp(4)="AdmDateMonth^月^50"
	...s tmp(5)="AdmDateDate^日^50"
	...s tmp(6)="SexDesc^性别^80"
	...s tmp(7)="PatYear^年龄^80"
	...s tmp(8)="InfReason^留置导管的主要原因^180"
	...s tmp(9)="InfPosition^CVC置管位置^120"
	...s tmp(10)="InfIntubationType^导管类型^120"
	...s tmp(11)="AntibiosisFlag^是否为抗菌导管^120"
	...s tmp(12)="LienTime^发生CLABSI时CVC留置时长(天)^260"
	...s defaultFlag=0
	..e  i obj.InfType="UC" d ;导尿管
	...s tmp(1)="CtLocDesc^发生病区名称^120"
	...s tmp(2)="PaRecord^住院患者病案号^150"
	...s tmp(3)="AdmDateYear^入院时间(年)^130"
	...s tmp(4)="AdmDateMonth^月^50"
	...s tmp(5)="AdmDateDate^日^50"
	...s tmp(6)="SexDesc^性别^80"
	...s tmp(7)="PatYear^年龄^80"
	...s tmp(8)="InfReason^留置导尿管的主要原因^180"
	...s tmp(9)="IntubationNum^导尿管型号^120"
	...s tmp(10)="InfIntubationType^导尿管类型^120"
	...s tmp(11)="IntubationQuality^导管材质^120"
	...s tmp(12)="DeviceFlag^是否使用抗返流集尿装置^180"
	...s tmp(13)="RinsingFlag^发生CAUTI前是否有膀胱冲洗^260"
	...s tmp(14)="LienTime^发生CAUTI时导尿管留置时长(天)^260"
	...s defaultFlag=0
	..e  i obj.InfType="VAP" d ;呼吸机
	...s tmp(1)="CtLocDesc^发生病区名称^120"
	...s tmp(2)="PaRecord^住院患者病案号^150"
	...s tmp(3)="AdmDateYear^入院时间(年)^130"
	...s tmp(4)="AdmDateMonth^月^50"
	...s tmp(5)="AdmDateDate^日^50"
	...s tmp(6)="SexDesc^性别^80"
	...s tmp(7)="PatYear^年龄^80"
	...s tmp(8)="ETTType^人工气道类型^120"
	...s tmp(9)="InfIntubationType^导管类型^120"
	...s tmp(10)="Humidification^湿化装置^120"
	...s tmp(11)="Endotracheal^吸痰方式^120"
	...s tmp(12)="OralCareType^口腔护理方式^120"
	...s tmp(13)="OralCareNum^每天口腔护理次数^150"
	...s tmp(14)="OralCareLiquid^口腔护理液选择^150"
	...s tmp(15)="NutritionFlag^经人工气道通气的同时,是否有经鼻胃管肠内营养^300"
	...s tmp(16)="LienTime^发生VAP时,经人工气道机械通气时长(天)^300"
	...s defaultFlag=0
	i defaultFlag=1 d
	.s tmp(1)="DataSort^序号^50"
	.s tmp(2)="KeyWord^唯一标识^150"
	.s tmp(3)="SubDesc^明细^0"
	.s tmp(4)="Updator^更新人^120"
	.s tmp(5)="Update^数据日期^120"
	;输出
	s sort="" f  s sort=$O(tmp(sort)) q:sort=""  d
	.s parr=$g(tmp(sort))
	.s ret=""
	.f i=1:1:$ll(column) d
	..s key=$Lg(column,i)
	..s value=$P(parr,"^",i)
	..i ret="" d
	...s ret=key_"|"_value
	..e  d
	...s ret=ret_"^"_key_"|"_value
	.d OutPutRowData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDetailColumnListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDetailColumnListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDetailColumnListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDetailColumnListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:liwenzhen
/// Createdate:2022-04-19
/// Description:不良事件类型配置
/// Input:
/// Output:
/// Other:
/// Test: w ##class(web.NurSensConfigComm).SetAdvType()
ClassMethod SetAdvType() As %ListOfDataTypes
{
	// s tmp(parent,children)=$lb(value,label,typeCode,$lb(alias),$lb(class,method,param))
	s @"tmp(""GDHT"")"=$lb("GDHT","非计划拔管","advPipeOff","",$lb("web.NurSensAdvComm","GetPipeOff","ID"))
	s @"tmp(""GDHT"",""导尿管"")"=$lb("导尿管","导尿管","",$lb("尿管"))
	s @"tmp(""GDHT"",""胃肠管"")"=$lb("胃肠管","胃肠管(经口鼻)","",$lb("胃管","鼻饲管"))
	s @"tmp(""GDHT"",""胃管"")"=$lb("胃管","胃管(经口鼻)")
	s @"tmp(""GDHT"",""肠管"")"=$lb("肠管","肠管(经口鼻)")
	s @"tmp(""GDHT"",""CVC"")"=$lb("CVC","CVC","",$lb("透析管路","深静脉置管","动脉置管"))
	s @"tmp(""GDHT"",""PICC"")"=$lb("PICC","PICC","",$lb("PICC"))
	s @"tmp(""GDHT"",""气管导管"")"=$lb("气管导管","气管导管","",$lb("气管插管","气管切开套管"))
	s @"tmp(""GDHT"",""术区引流管"")"=$lb("术区引流管","术区引流管导管","",$lb("胸腔闭式引流管","腹腔引流管","伤口引流管","心包引流管","脑室引流管"))
	s @"tmp(""DD"")"=$lb("DD","跌倒","advFallDownFill")
	s @"tmp(""DD"",""S"")"=$lb("S","总数")
	s @"tmp(""DD"",""H"")"=$lb("H","伤害度")
	s @"tmp(""DD"",""H"",""0"")"=$lb("0","无伤害")
	s @"tmp(""DD"",""H"",""1"")"=$lb("1","1级")
	s @"tmp(""DD"",""H"",""2"")"=$lb("2","2级")
	s @"tmp(""DD"",""H"",""3"")"=$lb("3","3级")
	s @"tmp(""DD"",""H"",""4"")"=$lb("4","死亡")
	s @"tmp(""YC"")"=$lb("YC","压疮","advSkinUlcer","",$lb("web.NurSensAdvComm","GetSkinUlcer","ID")) 
	s @"tmp(""YC"",""S"")"=$lb("S","总数")
	s @"tmp(""YC"",""Q"")"=$lb("Q","期数")
	s @"tmp(""YC"",""Q"",""1"")"=$lb("1","I期")
	s @"tmp(""YC"",""Q"",""-1"")"=$lb("-1","Ⅱ期及以上")
	;s @"tmp(""YYCW"")"=$lb("YYCW","用药错误","advDrugUseErr")
	;s @"tmp(""YYCW"",""S"")"=$lb("S","总数")
	s advType=##class(web.NurSensConfigComm).GetAdvTypeList("tmp")
	q advType
}

/// Creator:liwenzhen
/// Createdate:2022-04-24
/// Description:获取不良事件类型ArrayList
/// Input:
/// Output:
/// Other:
/// Test: w ##class(web.NurSensConfigComm).GetAdvTypeList()
ClassMethod GetAdvTypeList(tmp) As %ListOfDataTypes
{
	s advType=##class(%ListOfDataTypes).%New()
	s key="" f  s key=$o(@tmp@(key)) q:key=""  d
	.s advInfo=##class(%ArrayOfDataTypes).%New()
	.s info=$g(@tmp@(key))
	.s value=$lg(info,1)
	.s label=$lg(info,2)
	.s typeCode=$lg(info,3)
	.d advInfo.SetAt(value,"value")
	.d advInfo.SetAt(label,"label")
	.d:typeCode'="" advInfo.SetAt(typeCode,"typeCode")
	.s alias=$lg(info,4)
	.s interface=$lg(info,5)
	.i alias'="" d
	..s aliasList=##class(%ListOfDataTypes).%New()
	..f i=1:1:$ll(alias) d
	...s aliasData=$lg(alias,i)
	...d aliasList.Insert(aliasData)
	..d advInfo.SetAt(aliasList,"alias")
	.i interface'="" d
	..s interfaceArray=##class(%ArrayOfDataTypes).%New()
	..s class=$lg(interface,1)
	..s method=$lg(interface,2)
	..s param=$lg(interface,3)
	..q:(class="")||(method="")
	..d interfaceArray.SetAt(class,"class")
	..d interfaceArray.SetAt(method,"method")
	..d interfaceArray.SetAt(param,"param")
	..d advInfo.SetAt(interfaceArray,"interface")
	.i $d(@tmp@(key))=11 d
	..s childlist=..GetAdvTypeList($name(@tmp@(key)))
	..d:childlist.Count()>0 advInfo.SetAt(childlist,"children")
	.d advType.Insert(advInfo)
	q advType
}

/// Creator:liwenzhen
/// Createdate:2022-04-24
/// Description:获取不良事件类型JSON
/// Input:
/// Output:
/// Other:
/// Test: w ##class(web.NurSensConfigComm).GetAdvType()
ClassMethod GetAdvType() As %String
{
	w ##class(DHCINM.WebService.INMAppCommon).Encode(..#AdvType)
	q ""
}

/// Creator:liwenzhen
/// Createdate:2022-04-24
/// Description:根据key类型与key值取相应的value值
/// Input:typeCode
/// Output:
/// Other:
/// Test: zw ##class(web.NurSensConfigComm).GetAdvTypeValue(##class(web.NurSensConfigComm).#AdvType,"value","胃肠管","alias")
ClassMethod GetAdvTypeValue(array, key, value, targetKey As %String = "") As %String
{
	s targetValue=""
	s isFind=0
	s type=array.%ClassName()
	i type="%ListOfDataTypes" d
	.f i=1:1:array.Count() q:isFind=1  d
	..s targetValue=..GetAdvTypeValue(array.GetAt(i),key,value,targetKey)
	..s:targetValue'="" isFind=1
	i type="%ArrayOfDataTypes" d
	.s curValue=array.GetAt(key)
	.i curValue=value d
	..s:targetKey'="" targetValue=array.GetAt(targetKey)
	..s:targetKey="" targetValue=array
	..s isFind=1
	.i (array.GetAt("children")'="")&&(isFind=0) d
	..s targetValue=..GetAdvTypeValue(array.GetAt("children"),key,value,targetKey)
	q targetValue
}

/// Creator:
/// Description:查询统计数据(提供)
/// Date:2022-01-17
/// Table:
/// Input:parr:病区、开始时间、结束时间
/// Output：包头包尾
/// Others:d ##class(%ResultSet).RunQuery("web.NurSensConfigComm","FindBdeDataList","313^2022-01-11^2022-01-11")
Query FindBdeDataList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindBdeDataListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp) 
	s ind=1
	s ^TMP("FindBdeDataList")=parr
	//如果是模板过滤模板开始的日期,增加入参模板 
	//E134:一级护理患者占用床日数；E138:二级护理患者占用床日数；E140:三级护理患者占用床日数；；E176:特级护理患者占用床日数；
	s columns="E134,E138,E140,E176"
	s ret=""
	s ward1=$P(parr,"^",1)  
	
	s ward=$o(^CF.DHCINM.DB.MgWardI("CTLoc",ward1,"")) //转为CF.DHCINM.DB.MgWard 护管的病区ID
	q:ward="" ""
	;s rate=$P(parr,"^",2)
	s rate="D"
	s stDate=$P(parr,"^",2)
	i stDate["-" s stDate=stDate
	e  s stDate=""
	s endDate=$P(parr,"^",3) 
	i endDate["-" s endDate=endDate
	e  s endDate=""
	;s findModelId=$P(parr,"^",5) 
	;s wardType=$P(parr,"^",6) ;仅手术室
	s findModelId=24
	s wardType=0
	if (rate="")||(stDate="")||(endDate="")||(columns=""){
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
	s sysParam=##class(DHCNS.Config.NsSysParam).%New(1)
	s findModelObj="",FindWardQuit=0,tmpFindWard="",tmpWardLocUnit=""
	s startTime=$P($H,",",2)
	d ..SetTmpWardLocUnit(.tmpWardLocUnit)
	i findModelId'="" d
	.s findModelObj=##class(CF.DHCNS.Config.NsModel).%OpenId(findModelId)
	.i findModelObj.UseType="H" s FindWardQuit=0
	.e  i findModelObj.UseType="L" d
	..s FindWardQuit=1
	..s locUnitLocId=""  f  s locUnitLocId=$O(tmpWardLocUnit("Loc",locUnitLocId)) q:(locUnitLocId="")  d
	...s locUnitWardId=""  f  s locUnitWardId=$O(tmpWardLocUnit("Loc",locUnitLocId,locUnitWardId)) q:(locUnitWardId="")  d
	....i findModelObj.UseLimit.Find(locUnitWardId)>0 s tmpFindWard(locUnitWardId)=1
	.e  i findModelObj.UseType="W" d
	..s FindWardQuit=1
	..f i=1:1:findModelObj.UseLimit.Count() d
	...s limitWardId=findModelObj.UseLimit.GetAt(i)
	...q:limitWardId=""
	...s tmpFindWard(limitWardId)=1
	//选择某院区
	s tmpHospitalWard="",tmpWardI=""
	d ..SetTmpWardI(.tmpWardI)
	i ward["H"  d
	.s hospitalId=$e(ward,2,$L(ward))
	.i hospitalId'="" d
	..s hospitalWardId="" f  s hospitalWardId=$O(tmpWardI("Hospital",hospitalId,hospitalWardId)) q:hospitalWardId=""  d
	...s tmpHospitalWard(hospitalWardId)=1
	//.转换时间格式得到年-月-日
	s stYear=$fn($P(stDate,"-",1),"",0)
	s endYear=$fn($P(endDate,"-",1),"",0)
	s stMonthNum=$fn($P(stDate,"-",2),"",0)
	s endMonthNum=$fn($P(endDate,"-",2),"",0)
	s stDate=$zdh(stDate,3)
	s endDate=$zdh(endDate,3)
	//计算需要输出数据行数
	s rows=0
	if rate="D" {
		s rows=endDate-stDate+1
	}elseif rate="Y" {
		s rows=endYear-stYear+1
	}else{
		s step=$case(rate,"M":1,"Q":3,"H":6,:1) ;一个周期几个月
		s yearStep=$case(rate,"M":12,"Q":4,"H":2,:12)	;一年多少个周期
		s rows=((endYear-stYear)*yearStep)+((endMonthNum-stMonthNum+1)\step)
	}
	;循环需要获取那些自动或者手动上传数据及
	s tmpColumn="",tmpColumnIndex="",tmpWard=""
	d ..SetTmpWard(.tmpWard)
	f i=1:1:$L(columns,",") d
	.s indexId=$P(columns,",",i)
	.q:indexId="" 
	.s tmpColumn(indexId)=0
	;需要获取的最小元素,每个指标/元素对最小元素的计算公式。
	k tmpMinEle,tmpColumnCal,tmpMinEleAll,tmpEleType
	s tmpMinEle="",tmpColumnCal="",tmpMinEleAll="",isNurMgFlag=0,tmpEleType=""
	d ..SetMinAndCal(.tmpColumn,.tmpMinEle,.tmpColumnCal)
	s isNurMgFlag=..SetTypeTmp(.tmpMinEle,.tmpEleType) ;是否有护管相关数据
	s sysParam=##class(DHCNS.Config.NsSysParam).%New(1)
	;m tmpMinEleAll=tmpMinEle
	s DataSort=1
	f i=1:1:rows  d ;第几行
	.s dateDual=..GetDateFormat(stYear,stMonthNum,stDate,i,rate)
	.q:dateDual=""
	.s dateDesc=$P(dateDual,"^",4)
	.s dateTime=$P(dateDual,"^",1)
	.s rowStDate=$P(dateDual,"^",2)
	.s rowEndDate=$P(dateDual,"^",3)
	.k tmpNurMgData
	.s tmpNurMgData=""
	.d:isNurMgFlag=1 ..GetAutoMgData(rowStDate, rowEndDate,.tmpNurMgData)
	.;日期、指标、病区
	.s wardSort="" f  s wardSort=$O(tmpWard(wardSort)) q:wardSort=""  d
	..s wardId="" f  s wardId=$O(tmpWard(wardSort,wardId)) q:wardId=""  d
	...q:((ward'["H")&&(ward'="")&&(ward'=wardId))
	...q:((ward["H")&&($g(tmpHospitalWard(wardId))=""))
	...q:((FindWardQuit'=0)&&($g(tmpFindWard(wardId))'=1)) ;过滤掉模板需要统计的病区
	...s wardObj=##class(DHCNS.Config.NsWard).%New(wardId)
	...;只要模板使用范围
	...;q:(wardObj.CTLocDR="")
	...q:((wardObj.StDate'="")&&(wardObj.EndDate>endDate))
	...q:((wardObj.EndDate'="")&&(wardObj.EndDate<=stDate))
	...q:((wardType=1)&&((ward="")||(ward["H"))&&(wardObj.ClassDesc'["手术"))
	...s wardDesc=wardObj.Desc
	...;s ret="DataSort|"_DataSort_"^DataDate|"_dateTime_"^DataDateDesc|"_dateDesc_"^WardId|"_wardId_"^WardDesc|"_wardDesc
	...;s ret=ret_"^rowStDate|"_$zd(rowStDate,3)_"^rowEndDate|"_$zd(rowEndDate,3)_"^OneRow|1"
	...s isExistData=0
	...;每次先初始化,获取tmpMinEle值
	...s isNurMgFlagc=..initMinData(.tmpMinEle)
	...;期初、期末、和值已根据数据属性进行分离
	...;先把每行数据存下来？
	...s dataWardParr=wardId_"^"_sysParam.NurMgInter_"^"_wardObj.CTLocDR_"^"_wardObj.WardMGCode_"^"_wardObj.IsWard
 	...d ..GetMinData(dataWardParr,rowStDate,rowEndDate,.tmpMinEle,.tmpNurMgData,.tmpEleType)
	...s indexId="" f  s indexId=$O(tmpColumn(indexId)) q:indexId=""  d
	....s indexType=$E(indexId,1)
	....s indexRealId=$E(indexId,2,$L(indexId))
	....q:(indexType="")||(indexRealId="")
	....;进行指标/元素过滤病区
	....s calStr=$g(tmpColumnCal(indexId))
	....q:calStr=""
	....s value=..GetCalValue(calStr,.tmpMinEle)
	....q:value=""
	....i indexType="E" d ;元素
	.....;s eleObj=##class(CT.DHCNS.Config.NsElement).%OpenId(indexRealId)
	.....s value=$P(value,"^",1)
	....i indexType="I" d ;指标
	.....s value=..GetIndexValue(indexRealId,value)
	....;s ret=ret_"^"_indexId_"|"_value_"^cal"_indexId_"|"_calStr
	...;q:isExistData=0  ;存在数据则在统计界面显示，否则不显示。
	...;d OutPutRowData
	...s DataSort=DataSort+1
	...s minEleId="" f  s minEleId=$O(tmpMinEle(minEleId)) q:minEleId=""  d
	....s tmpMinEleAll(minEleId,i,wardId)=$g(tmpMinEle(minEleId))
	//输出总计
	s ^tmp("sensConut",1)=$P($H,",",2)-startTime
	s startTime=$P($H,",",2)
	s wardDesc=""
	i ward="" s wardDesc="全院"
	e  i ward["H" d
	.s hospitalId=$e(ward,2,$L(ward))
	.s:hospitalId'="" wardDesc=..GetHospitalName(hospitalId)
	e  d
	.s wardObj=##class(DHCNS.Config.NsWard).%New(ward)
	.s:$IsObject(wardObj) wardDesc=wardObj.Desc
	s oneRow=1
	s:rows>1 oneRow=0
	s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(ward)
	s wardDesc=wardObj.CTLocDR.CTLOCDesc
	s ward=wardObj.CTLocDR
	s ret="DataSort|总计^DataDate|^WardId|^UpdateDate|"_"^WardId|"_ward_"^WardDesc|"_wardDesc_"^OneRow|"_oneRow
	s ret=ret_"^rowStDate|"_$zd(stDate,3)_"^rowEndDate|"_$zd(endDate,3)
	s indexId="" f  s indexId=$O(tmpColumn(indexId)) q:indexId=""  d
	.s indexType=$E(indexId,1)
	.s indexRealId=$E(indexId,2,$L(indexId))
	.q:(indexType="")||(indexRealId="")
	.s calStr=$g(tmpColumnCal(indexId))
	.q:calStr=""
	.s value=..GetHospitalCountData(indexType,indexRealId,.tmpMinEleAll,calStr,rows,ward,"")
	.;//E134:一级护理患者占用床日数；E138:二级护理患者占用床日数；E140:三级护理患者占用床日数；；E176:特级护理患者占用床日数；
	.s ret=ret_"^"_indexId_"|"_value
	d OutPutRowData
 	s ^tmp("sensConut",2)=$P($H,",",2)-startTime
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindBdeDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBdeDataListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindBdeDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBdeDataListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
