/// 名称: web.DHCCPW.MRC.PathWEpStepItem
/// 描述：对临床路径项目的各种操作分别有添加，删除，修改，查询等操作
/// 编写者：李宇峰
/// 编写日期：2010-05-11
Class web.DHCCPW.MRC.PathWEpStepItem Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-11-07
/// Description:  根据ID取临床路径项目
/// Table：       User.DHCMRCClinPathWaysEpStepItem
/// Input：       ID:    User.DHCMRCClinPathWaysEpStepItem.Id
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById("1||1||1||1")
ClassMethod GetObjById(argId As %String) As User.DHCMRCClinPathWaysEpStepItem
{
	New (argId)
	Set return=##Class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator      : 李宇峰
/// CreatDate    : 2010-05-11
/// Description  : 此Query是用来得到指定临床路径项目全部记录
/// Table        : User.DHCMRCClinPathWaysEpStepItem 
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.PathWEpStepItem","GetPathEpStepItem","2||1||1","")
Query GetPathEpStepItem(argStepID As %String, argCategID As %String) As %Query(ROWSPEC = "StepItemRowid:%String,Desc:%String,GroupNo:%String,SubCatRowid:%String,SubCatDesc:%String,OrdSetRowid:%String,OrdSetDesc:%String,CheckPoint:%String,CheckDesc:%String,IsMustItem:%String")
{
}

ClassMethod GetPathEpStepItemExecute(ByRef qHandle As %Binary, argStepID As %String, argCategID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set StepRowID=$p(argStepID,"-",1)
	Set CPWID=$p(StepRowID,"||",1)
	Set EpID=$p(StepRowID,"||",2)
	Set StepID=$p(StepRowID,"||",3)
	Set ItemID=0
	For {
		Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
		Quit:ItemID=""
		
		Set ItemRowID=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
		Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemRowID)
		If $IsObject(objItem){
			Set (SubCategID,SubCategDesc,CategID,OrdSetID,OrdSetDesc)=""
			If $IsObject(objItem.CPWSISubCategory){
				Set SubCategID=objItem.CPWSISubCategory.%Id()
				Set SubCategDesc=objItem.CPWSISubCategory.SISCDesc
				If $IsObject(objItem.CPWSISubCategory.SISCParRef){
					Set CategID=objItem.CPWSISubCategory.SISCParRef.%Id()
				}
			}
			Continue:(argCategID'="")&&(CategID'=argCategID)
			
			Set GroupNo=objItem.CPWSIGroupNo           //项目分组
			Set ItemDesc=objItem.CPWSIDesc             //项目描述
			Set OrdSetDR=objItem.CPWSIOrdSetDR         //医嘱套
			
			Set objOrdSet=##class(User.ARCOrdSets).%OpenId(OrdSetDR)
			If $IsObject(objOrdSet){
				Set OrdSetID=objOrdSet.%Id()
				Set OrdSetDesc=objOrdSet.ARCOSDesc
			}
			If objOrdSet'="" Do objOrdSet.%Close()
			Set CheckPoint=objItem.CPWSICheckPoint     //关键点类型K:KEY,T:TIME
			Set CheckPoint=$s(CheckPoint["T":"TIME",1:"KEY")
			Set CheckDesc=objItem.CPWSICheckDesc
			Set IsMustItem=objItem.CPWSIIsMust
			Set IsMustItem=$s(IsMustItem["Y":"Yes",1:"No")  //是否可选 Y可选 N必选
			
			Set Data=$lb(ItemRowID,ItemDesc,GroupNo,SubCategID,SubCategDesc,OrdSetID,OrdSetDesc,CheckPoint,CheckDesc,IsMustItem)
 			Set ^CacheTemp(repid,ind)=Data
 			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod GetPathEpStepItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPathEpStepItemExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPathEpStepItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPathEpStepItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{				    // fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     李宇峰
/// CreatDate：   2010-05-05
/// Description:  此Query是按照别名查找医嘱套
/// Table:        User.ARCOrdSets
/// Input：       argDesc(医嘱项别名)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.PathWEpStepItem","GetAllOrdSet","htzz")
Query GetAllOrdSet(argAlias As %String) As %Query(ROWSPEC = "rowid:%String,ordCode:%String,ordSetDesc:%String")
{
}

ClassMethod GetAllOrdSetExecute(ByRef qHandle As %Binary, argAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	s JIndex=$j,ZIndex=$zn
	k ^TMP(ZIndex,JIndex,"ARCOrdSet")
	
	//医嘱套别名查询
	//^ARC("ALIAS",0,"Desc",$$ALPHAUP({ALIAS_Text})_" ",$$ALPHAUP({ALIAS_Desc}),{ALIAS_RowId},1)
	s argAlias=$$ALPHAUP^SSUTIL4(argAlias)
	s Alias=$o(^ARC("ALIAS",0,"Desc",argAlias),-1)
	f  s Alias=$o(^ARC("ALIAS",0,"Desc",Alias)) q:(Alias="")||($e(Alias,1,$l(argAlias))'=argAlias)  d
	.s ARCDesc=""
	.f  s ARCDesc=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc)) q:ARCDesc=""  d
	..s ARCRowid=0
	..f  s ARCRowid=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc,ARCRowid)) q:ARCRowid=""  d
	...q:'$d(^ARC("ALIAS",ARCRowid))
	...s ARCType=$p(^ARC("ALIAS",ARCRowid),"^",5)
	...q:ARCType'="ARCIM"
	...s ARCAlias=$p(^ARC("ALIAS",ARCRowid),"^",6)
	...s ARCAlias=$$ALPHAUP^SSUTIL4(ARCAlias)
	...q:$e(ARCAlias,1,$l(argAlias))'=argAlias
	...s ARCType=$p(^ARC("ALIAS",ARCRowid),"^",5)
	...q:ARCType'="ARCOS"
	...s ARCOrdSetID=$p(^ARC("ALIAS",ARCRowid),"^",2)
	...q:ARCOrdSetID=""
	...s ^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID)=""
	
	//医嘱套名称查询
	//^ARCOS(0,"Desc",$$ALPHAUP({ARCOS_Desc}),{ARCOS_RowId})
	s Alias=$o(^ARCOS(0,"Desc",argAlias),-1)
	f  s Alias=$o(^ARCOS(0,"Desc",Alias)) q:(Alias="")||($e(Alias,1,$l(argAlias))'=argAlias)  d
	.s ARCOrdSetID=0
	.f  s ARCOrdSetID=$o(^ARCOS(0,"Desc",Alias,ARCOrdSetID)) q:ARCOrdSetID=""  d
	..s ^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID)=""
	
	s ARCOrdSetID=""
	f  s ARCOrdSetID=$o(^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID)) q:ARCOrdSetID=""  d
	.q:ARCOrdSetID=""
	.s ARCOrdSetCode=$p($g(^ARCOS(ARCOrdSetID)),"^",1)
	.s ARCOrdSetDesc=$p($g(^ARCOS(ARCOrdSetID)),"^",2)
	.s ARCOrdSetCode=$tr(ARCOrdSetCode,$c(13),"")
	.s ARCOrdSetCode=$tr(ARCOrdSetCode,$c(13),"")
	.s ARCOrdSetDesc=$tr(ARCOrdSetDesc,$c(13),"")
	.s ARCOrdSetDesc=$tr(ARCOrdSetDesc,$c(10),"")
	.q:ARCOrdSetDesc=""
	.s Data=$lb(ARCOrdSetID,ARCOrdSetCode,ARCOrdSetDesc)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	k ^TMP(ZIndex,JIndex,"ARCOrdSet")
	
	Quit $$$OK
}

ClassMethod GetAllOrdSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllOrdSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAllOrdSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllOrdSetExecute ]
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

/// Creator:李宇峰
/// CreatDate:2010-05-12
/// Description:AddStepItem添加一条临床路径项目记录
/// Table:User.DHCMRCClinPathWaysEpStepItem
ClassMethod AddStepItem(StepRowid As %String, Desc As %String, GroupNo As %String, SubCat As %String, OrdSet As %String, CheckPoint As %String, CheckDesc As %String, IsMustItem As %String)
{
	New (StepRowid,Desc,GroupNo,SubCat,OrdSet,CheckPoint,CheckDesc,IsMustItem)
	Set return=-1
	Quit:(StepRowid="")||(Desc="")||(GroupNo="")||(SubCat="") return
	
	Set InputStr=StepRowid_"^"_""_"^"_SubCat_"^"_GroupNo_"^"_Desc_"^"_OrdSet_"^"_CheckPoint_"^"_CheckDesc_"^"_IsMustItem
	Set return=..Update(InputStr)
	Quit return
}

/// Creator:李宇峰
/// CreatDate:2010-05-12
/// Description:UpdateStepItem修改一条临床路径项目记录
/// Table:User.DHCMRCClinPathWaysEpStepItem
ClassMethod UpdateStepItem(StepItemRowid As %String, Desc As %String, GroupNo As %String, SubCat As %String, OrdSet As %String, CheckPoint As %String, CheckDesc As %String, IsMustItem As %String)
{
	New (StepItemRowid,Desc,GroupNo,SubCat,OrdSet,CheckPoint,CheckDesc,IsMustItem)
	Set return=-1
	Quit:(StepItemRowid="")||(Desc="")||(GroupNo="")||(SubCat="") return
	
	Set CPWID=$p(StepItemRowid,"||",1)
	Set EpID=$p(StepItemRowid,"||",2)
	Set StepID=$p(StepItemRowid,"||",3)
	Set StepRowID=CPWID_"||"_EpID_"||"_StepID
	Set ItemID=$p(StepItemRowid,"||",4)
	Set InputStr=StepRowID_"^"_ItemID_"^"_SubCat_"^"_GroupNo_"^"_Desc_"^"_OrdSet_"^"_CheckPoint_"^"_CheckDesc_"^"_IsMustItem
	Set return=..Update(InputStr)
	Quit return
}

/// Creator:李宇峰
/// CreatDate:2010-05-12
/// Description:DeleteStepItem删除一条临床路径项目记录
/// Table:User.DHCMRCClinPathWaysEpStepItem
/// w ##class(web.DHCCPW.MRC.PathWEpStepItem).DeleteStepItem(1)
ClassMethod DeleteStepItem(argId As %String) As %String
{
	new (argId)
	set return=0
	set sc = ##class(User.DHCMRCClinPathWaysEpStepItem).%DeleteId(argId)
	if $system.Status.IsError(sc) {         //检查删除是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-11-01
/// Description:  保存临床路径项目
/// Table：       User.DHCMRCClinPathWaysEpStepItem
/// Input：       argInPut: 临床路径项目数据
/// Return：      return<0: 保存失败
/// w ##Class(web.DHCCPW.MRC.PathWEpStepItem).Update(argInput)
ClassMethod Update(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set ParRef=$p(argInput,"^",1)
	Quit:ParRef="" return
	Set ChildSub=$p(argInput,"^",2)
	If ChildSub="" {
		Set obj=##class(User.DHCMRCClinPathWaysEpStepItem).%New()
	} Else {
		Set ID=ParRef_"||"_ChildSub
		Set obj=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(ID)
		Quit:obj="" return
	}
	
	Set objParRef=##Class(User.DHCMRCClinPathWaysEpStep).%OpenId(ParRef)
	If objParRef'="" Do objParRef.%Close()
	Set SubCategID=$p(argInput,"^",3)
	Set objSubCateg=##class(User.DHCMRCStepItemSubCategory).%OpenId(SubCategID)
	If objSubCateg'="" Do objSubCateg.%Close()
	Set GroupNo=+$p(argInput,"^",4)
	Set Desc=$p(argInput,"^",5)
	Set OrdSet=$p(argInput,"^",6)
	Set CheckPoint=$p(argInput,"^",7)
	Set CheckPoint=$s(CheckPoint["K":"K",1:"T")
	Set CheckDesc=$p(argInput,"^",8)
	Set IsMustItem=$p(argInput,"^",9)
	Set IsMustItem=$s(IsMustItem["Y":"Y",1:"N")  //Y可选，N必选
	
	Quit:(Desc="")||(GroupNo="")||(objSubCateg="")||(objParRef="") return
	
	Set obj.CPWSIParRef=objParRef
	Set obj.CPWSISubCategory=objSubCateg
	Set obj.CPWSIGroupNo=GroupNo
	Set obj.CPWSIDesc=Desc
	Set obj.CPWSIOrdSetDR=OrdSet
	Set obj.CPWSICheckPoint=CheckPoint
	Set obj.CPWSICheckDesc=CheckDesc
	Set obj.CPWSIIsMust=IsMustItem
	
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

/// w ##Class(web.DHCCPW.MRC.PathWEpStepItem).GetStepItem("1||1||1")
ClassMethod GetStepItem(argStepRowID As %String)
{
	New (argStepRowID)
	Set return=""
	Quit:argStepRowID="" return
	
	Set CPWID=$p(argStepRowID,"||",1)
	Set EpID=$p(argStepRowID,"||",2)
	Set StepID=$p(argStepRowID,"||",3)
	Quit:(CPWID="")||(EpID="")||(StepID="") return
	
	Set ItemID=0
	For {
		Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
		Quit:ItemID=""
		
		Set ItemRowID=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
		Set objItem=..GetObjById(ItemRowID)
		If $IsObject(objItem){
			Set Desc=objItem.CPWSIDesc
			Set Desc=$tr(Desc,"^","")
			Set Desc=$tr(Desc,$c(0),"")
			Set Desc=$tr(Desc,$c(10),"")
			Set Desc=$tr(Desc,$c(13),"")
			Set return=return_","_ItemRowID_"^"_Desc
		}
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// w ##Class(web.DHCCPW.MRC.PathWEpStepItem).GetNewItem("1||1||1")
ClassMethod GetNewItem(argStepRowID As %String)
{
	New (argStepRowID)
	Set return=""
	Quit:argStepRowID="" return
	
	Set CPWID=$p(argStepRowID,"||",1)
	Set EpID=$p(argStepRowID,"||",2)
	Set StepID=$p(argStepRowID,"||",3)
	Quit:(CPWID="")||(EpID="")||(StepID="") return
	
	Set return=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",""),-1)
	Quit return
}

/// w ##Class(web.DHCCPW.MRC.PathWEpStepItem).GetStepItemNum("1||1||1","1||1||1||3")
ClassMethod GetStepItemNum(argStepRowID As %String, argItemRowID As %String)
{
	New (argStepRowID,argItemRowID)
	Set num=0
	Set rset=##class(%ResultSet).%New("web.DHCCPW.MRC.PathWEpStepItem:GetPathEpStepItem")
    Set sc = rset.Execute(argStepRowID,"")
	While (rset.Next(.sc))
	{
		If ($SYSTEM.Status.IsOK(sc))
		{
			Set num=num+1
			Set ItemRowID=rset.Data("StepItemRowid")
			Quit:ItemRowID=argItemRowID
		} Else {
			Quit
		}
	}
	If $SYSTEM.Status.IsError(sc)
	{
    	Do $system.OBJ.DisplayError(sc)
	}
	Quit num
}

/// Creator:李宇峰
/// CreatDate:2010-07-07
/// Description:取得一条医嘱项的剂量，剂量单位，频次，用法，疗程
/// 调试：w ##class(web.DHCCPW.MRC.PathWEpStepItem).GetArcimInfoById("1242||1")
ClassMethod GetArcimInfoById(ArcimRowid As %String)
{
	New (ArcimRowid)
	Set return=""
	
	If $l(ArcimRowid,"||")=2 {  //医嘱项
		Set (FormDoseUOMRowid,FormFreqRowid,FormInstrRowid,FormDurRowid,FormDoseQty)=""
		Set ItemCatRowid=$p($g(^ARCIM(+ArcimRowid,+$p(ArcimRowid,"||",2),1)),"^",10)
		Set OrderType=$p($g(^ARC("IC",+ItemCatRowid)),"^",7)
		If OrderType="R"{
			Set PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(+ItemCatRowid)
			If PHPrescType="" Set PHPrescType="1"
		}Else{
			Set PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(+ItemCatRowid)
		}
		Set DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)   //药学项
		If DrgformRowid'="" {
			Set PHCDRowid=$p(DrgformRowid,"||",1)
		  	Set ChildSub=$p(DrgformRowid,"||",2)
			Set FormDoseUOMRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4) //剂量单位
			Set FormFreqRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",4)    //频次
			Set FormInstrRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",5)   //用法
			Set FormDurRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",8)     //疗程
			Set FormDoseQty=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",5)      //剂量
		}
		If PHPrescType="4" {
			Set FormFreqRowid=##class(web.DHCDocConfig).GetConfigNode("FrequencedItemFreq")
			Set FormDurRowid=##class(web.DHCDocConfig).GetConfigNode("FrequencedItemDur")
		}
		Set CPWHospitalCode=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("CPWHospitalCode")
		Set:CPWHospitalCode="BJ_FXYY" FormDurRowid=""
		Set return=ArcimRowid_"^"_OrderType_"^"_PHPrescType_"^"_FormDoseQty_"^"_FormDoseUOMRowid_"^"_FormDurRowid_"^"_FormFreqRowid_"^"_FormInstrRowid
	} Else {    //医嘱套
		Set return="^^^^^^^"
	}
	Quit return
}

/// Creator:LIYI
/// Creatdate:2013-04-27
/// Description:对医嘱项序号要求必须连续,
/// Input:ItemRowID:项目ID
/// Output：
/// Debug：do ##class(web.DHCCPW.MRC.PathWEpStepItem).SerializationARCIM("120||1||1||6")
ClassMethod SerializationARCIM(ItemRowID As %String)
{
	New (ItemRowID)
	Set return=0
	Quit:ItemRowID="" return
	Set obj=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(ItemRowID)
	Quit:'$IsObject(obj) return
	Set Count=0
	Set ListLength=obj.CPWSIARCIM.Count()
	//计算医嘱List中有效的医嘱项条数
	for Index=1:1:ListLength
	{
		Set objARCIMTMP=obj.CPWSIARCIM.GetAt(Index)
		Continue:'$IsObject(objARCIMTMP)
		If objARCIMTMP.ITMNo'=""
		{
			Set Count=Count+1
			}
		}
	Quit:Count>=ListLength
	//对医嘱项List重新排列
	Set CountNum=1
	for Index=1:1:obj.CPWSIARCIM.Count()
	{
		
		Set objARCIMTMP=obj.CPWSIARCIM.GetAt(Index)
		Continue:'$IsObject(objARCIMTMP)
		
		If objARCIMTMP.ITMNo'=""
			{
				//获取有效的医嘱对象
				Set objARCIMTMP.ITMNo=CountNum
				Do obj.CPWSIARCIM.SetAt(objARCIMTMP,CountNum)
				Set CountNum=CountNum+1
				Quit:CountNum>Count
			}
	}
	//对于有效长度以为的全部置空
	Set CountNull=Count+1
	for Index=CountNull:1:ListLength
	{
		Do obj.CPWSIARCIM.SetAt("",Index)
		}
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
}

/// w ##class(web.DHCCPW.MRC.PathWEpStepItem).InsertARCIM("78||2||1||7","^^11373||1^^^^^^1^Yes^1^5^Yes^")
ClassMethod InsertARCIM(ItemRowID As %String, PathARCIM As %String)
{
	New (ItemRowID,PathARCIM)
	Set return=0
	Quit:ItemRowID="" return
	
	Set obj=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(ItemRowID)
	Quit:'$IsObject(obj) return
	
	Set ItmNo=$p(PathARCIM,"^",1)
	Set ItmLinkNo=$p(PathARCIM,"^",2)
	//*********************************************
	//update by zf 20120405 处理复制医嘱问题
	//Quit:(+ItmNo)<1 return
	Set ItmInd=""
	Set CPWSIARCIMCount=obj.CPWSIARCIM.Count()
	If ItmNo="" {
		Set ItmNo=CPWSIARCIMCount+1
		Set ItmLinkNo=""
	}
	//*********************************************
	For Ind=1:1:CPWSIARCIMCount {
		Quit:ItmInd'=""
		Set objARCIMTMP=obj.CPWSIARCIM.GetAt(Ind)
		Continue:'$IsObject(objARCIMTMP)
		Set tmpItmNo=objARCIMTMP.ITMNo
		If ItmNo=tmpItmNo {
			Set ItmInd=Ind
		}
	}
	Set:ItmInd="" ItmInd=ItmNo
	If ItmInd>CPWSIARCIMCount {
		For tmpItmInd=1:1:(ItmInd-CPWSIARCIMCount) {
			Do obj.CPWSIARCIM.Insert("")
		}
	}
	
	Set objARCIM=##class(User.DHCMRCClinPathWaysARCIM).%New()
	Quit:'$IsObject(objARCIM)
	Set objARCIM.ITMNo=ItmNo
	Set objARCIM.ITMLinkNo=ItmLinkNo   //$p(PathARCIM,"^",2)
	Set objARCIM.ITMARCIMDR=$p(PathARCIM,"^",3)
	Set objARCIM.ITMDoseQty=$p(PathARCIM,"^",4)
	Set objARCIM.ITMUOMDR=$p(PathARCIM,"^",5)
	Set objARCIM.ITMDuratDR=$p(PathARCIM,"^",6)
	Set objARCIM.ITMFreqDR=$p(PathARCIM,"^",7)
	Set objARCIM.ITMInstrucDR=$p(PathARCIM,"^",8)
	Set objARCIM.ITMQty=$p(PathARCIM,"^",9)
	Set itmDefault=$p(PathARCIM,"^",10)
	Set itmDefault=$s(itmDefault["Y":"Y",1:"N")
	Set objARCIM.ITMDefault=itmDefault
	
	Set objARCIM.ITMPriority=$p(PathARCIM,"^",12)
	Set itmIsMain=$p(PathARCIM,"^",13)
	Set itmIsMain=$s(itmIsMain["Y":"Y",1:"N")
	Set objARCIM.ITMIsMain=itmIsMain
	Set objARCIM.ITMGroupNo=$p(PathARCIM,"^",14)
	Set objARCIM.ITMResume=$p(PathARCIM,"^",15)
	
	Set objARCIM.ITMIsActive=$s($p(PathARCIM,"^",16)["N":"N",1:"Y")    //是否有效
	Set objARCIM.ITMUpdateUser=$p(PathARCIM,"^",17)  //修改人
	Set UpdateDate=$p(PathARCIM,"^",18)
	Set:UpdateDate["-" UpdateDate=$zdh(UpdateDate,3)
	Set:UpdateDate["/" UpdateDate=$zdh(UpdateDate,4)
	Set:UpdateDate="" UpdateDate=+$h
	Set objARCIM.ITMUpdateDate=UpdateDate            //修改日期
	Set UpdateTime=$p(PathARCIM,"^",19)
	Set:UpdateTime[":" UpdateTime=$zth(UpdateTime,1)
	Set objARCIM.ITMUpdateTime=UpdateTime            //修改时间
	
	Set objARCIMTMP=obj.CPWSIARCIM.GetAt(ItmInd)
	//If $IsObject(objARCIMTMP) {  //update by zf 20120330
		Do obj.CPWSIARCIM.SetAt(objARCIM,ItmInd)
	//}
	Do ..SerializationARCIM(ItemRowID)
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

/// w ##Class(web.DHCCPW.MRC.PathWEpStepItem).CheckLinkArcimBat(70)
ClassMethod CheckLinkArcimBat(aCPWID As %String) As %String
{
	New (aCPWID)
	Set return=0
	
	Set $ZT="CheckLinkArcimErr"
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRC("CPW",CPWID))
		Quit:CPWID=""
		Continue:aCPWID'=CPWID
		Set EpID=0
		For {
			Set EpID=$o(^DHCMRC("CPW",CPWID,"EP",EpID))
			Quit:EpID=""
			Set StepID=0
			For {
				Set StepID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID))
				Quit:StepID=""
				Set ItemID=0
				For {
					Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
					Quit:ItemID=""
					
					Set StepItemRowID=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
					Set obj=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(StepItemRowID)
					Continue:'$IsObject(obj)
					
					Kill LinkArcimTMPList
					Set LinkArcimListCount=obj.CPWSIARCIM.Count()
					For IndLinkArcim=1:1:LinkArcimListCount
					{
						Set LinkArcimTMP=obj.CPWSIARCIM.GetAt(IndLinkArcim)
						Set ItmNo=LinkArcimTMP.ITMNo
						Continue:ItmNo=""
						Set LinkArcimTMPList(ItmNo)=LinkArcimTMP
						Do obj.CPWSIARCIM.SetAt("",IndLinkArcim)
					}
					Set ItmNo=0
					For {
						Set ItmNo=$o(LinkArcimTMPList(ItmNo))
						Quit:ItmNo=""
						Set objLinkArcim=$g(LinkArcimTMPList(ItmNo))
						If ItmNo > obj.CPWSIARCIM.Count()
						{
							For tmpItmInd=1:1:(ItmNo - obj.CPWSIARCIM.Count())
							{
								Do obj.CPWSIARCIM.Insert("")
							}
						}
						Do obj.CPWSIARCIM.SetAt(objLinkArcim,ItmNo)
					}
					
					Set sc=obj.%Save()
					If $System.Status.IsError(sc) {                      //检查Save是否成功
				   		Do $system.OBJ.DisplayError(sc) 
				   		Set return=-1
					} Else {
						Set return=obj.%Id()
					}
					Do obj.%Close()
				}
			}
		}
	}
	
	Set return=1
	Quit return
	
CheckLinkArcimErr
	Quit -999
}

/// w ##Class(web.DHCCPW.MRC.PathWEpStepItem).Test()
ClassMethod Test()
{
	New
	Set listArcim=$g(^DHCMRC("CPW",70,"EP",1,"STEP",1,"ITEM",6))
	Set A1=$lb($lb("11350||1","Y","","","","","",1,1,"","Y","5","","",,"","","","",""))
	Set A2=$lb($lb("11350||1","Y","","","","","",4,1,"","Y","5","","",,"","","","",""))
	Set A3=$lb($lb("11350||1","Y","","","","","",3,1,"","Y","5","","",,"","","","",""))
	Set ArcimList=$lb(A1,A2,"",A3)
	Set LinkArcimList=$lb("","2||1","1","呼吸内科护理常规",ArcimList,"","K","","","")
	Set ^DHCMRC("CPW",70,"EP",1,"STEP",1,"ITEM",6)=LinkArcimList
	Quit "Test()"
}

/// w ##class(web.DHCCPW.MRC.PathWEpStepItem).DeleteARCIM("2||1||1||5","80910||1")
ClassMethod DeleteARCIM(ItemRowID As %String, ItmNo As %String)
{
	New (ItemRowID,ItmNo)
	Set return=0
	Quit:(ItemRowID="")||(ItmNo="") return
	
	Set obj=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(ItemRowID)
	Quit:'$IsObject(obj) return
	
	For Ind=1:1:obj.CPWSIARCIM.Count() {
		Set objARCIMTMP=obj.CPWSIARCIM.GetAt(Ind)
		Continue:'$IsObject(objARCIMTMP)
		Set tmpItmNo=objARCIMTMP.ITMNo
		Continue:tmpItmNo'=ItmNo
		
		//update by zf 20120213
		//Do obj.CPWSIARCIM.RemoveAt(Ind)
		Do obj.CPWSIARCIM.SetAt("",Ind)
	}
	Do ..SerializationARCIM(ItemRowID)
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

/// w ##class(web.DHCCPW.MRC.PathWEpStepItem).CheckARCIM("2||1||1||5","","81221||1")
ClassMethod CheckARCIM(ItemRowID As %String, Ind As %String, PathARCIMID As %String)
{
	New (ItemRowID,Ind,PathARCIMID)
	Set return=0
	Quit:(ItemRowID="")||(PathARCIMID="") return
	
	Set obj=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(ItemRowID)
	Quit:'$IsObject(obj) return
	
	Set ARCIMLen=obj.CPWSIARCIM.Count()
	For lnInd=1:1:ARCIMLen {
		Continue:(Ind'="")&&(Ind=lnInd)
		Set objARCIM=obj.CPWSIARCIM.GetAt(lnInd)
		Continue:'$IsObject(objARCIM)
		Set ARCIMID=objARCIM.ITMARCIMDR
		Continue:ARCIMID'=PathARCIMID
		Set return=1
	}
	Do obj.%Close()
	
	Quit return
}

}
