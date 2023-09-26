/// 临床路径关联医嘱通用名
Class User.DHCMRCClinPathWaysItmGene Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = CPWSIG_RowId, SqlTableName = DHC_MRC_ClinPathWaysItmGene ]
{

Relationship IGParref As User.DHCMRCClinPathWaysEpStepItem [ Cardinality = parent, Inverse = ChildItmGene, SqlFieldName = IG_ParRef ];

/// 序号
Property IGNo As %Float;

/// 通用名 指向PHC_Generic
Property IGGeneID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 通用名（非药品类医嘱通用名）
Property IGGeneDesc As %String(MAXLEN = 200, TRUNCATE = 1);

/// 关联号
Property IGLinkNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医嘱类型 指向OEC_Priority
Property IGPriority As %String(MAXLEN = 100, TRUNCATE = 1);

/// 主医嘱标记
Property IGIsMain As %String(DISPLAYLIST = ",Yes,No", MINLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N");

/// 可选关联项
Property IGArcimList As list Of User.DHCMRCClinPathWaysARCIM;

Index IndexGeneNo On (IGParref, IGNo);

Index IndexGeneLinkNo On (IGParref, IGLinkNo);

/// Creator：     zhufei
/// CreatDate：   2015-05-27
/// Description:  根据ID取表单医嘱
/// Table：       User.DHCMRCClinPathWaysItmGene
/// Input：       Id : User.DHCMRCClinPathWaysItmGene.ID
/// Return：      返回Object
/// w ##class(User.DHCMRCClinPathWaysItmGene).GetObjById(1)
ClassMethod GetObjById(aId As %String) As User.DHCMRCClinPathWaysItmGene
{
	new (aId)
	quit:'##class(User.DHCMRCClinPathWaysItmGene).%ExistsId(aId) ""
	set obj=##Class(User.DHCMRCClinPathWaysItmGene).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-05-27
/// Description:  更新表单医嘱
/// Table：       User.DHCMRCClinPathWaysItmGene
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(User.DHCMRCClinPathWaysItmGene).Update("")
ClassMethod Update(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:aInputStr="" return
	
	Set ItemID=$p(aInputStr,"^",1)
	Set IGSub=$p(aInputStr,"^",2)
	Set IGASub=$p(aInputStr,"^",3)
	Set IGNo=$p(aInputStr,"^",4)
	Set LinkNo=$p(aInputStr,"^",5)
	Set Priority=$p(aInputStr,"^",6)
	Set IsMain=$p(aInputStr,"^",7)       //是否主医嘱
	Set ARCIMDR=$p(aInputStr,"^",8)
	Set DoseQty=$p(aInputStr,"^",9)
	Set UOMDR=$p(aInputStr,"^",10)
	Set DuratDR=$p(aInputStr,"^",11)
	Set FreqDR=$p(aInputStr,"^",12)
	Set InstrucDR=$p(aInputStr,"^",13)
	Set ItemQty=$p(aInputStr,"^",14)
	Set Resume=$p(aInputStr,"^",15)      //医嘱备注
	Set IsDefault=$p(aInputStr,"^",16)   //是否首选医嘱
	Set IsActive=$p(aInputStr,"^",17)    //是否有效
	Set UpdateUser=$p(aInputStr,"^",18)  //修改人
	Set UpdateDate=$p(aInputStr,"^",19)  //更新日期
	Set:UpdateDate["-" UpdateDate=$zdh(UpdateDate,3)
	Set:UpdateDate["/" UpdateDate=$zdh(UpdateDate,4)
	Set:UpdateDate="" UpdateDate=+$h
	Set UpdateTime=$p(aInputStr,"^",20)  //更新时间
	Set:UpdateTime[":" UpdateTime=$zth(UpdateTime,1)
	Set:UpdateTime="" UpdateTime=$p($h,",",2)
	
	Quit:(ItemID="")||(ARCIMDR="") return
	
	//医嘱套不允许有关联医嘱
	Set:$l(ARCIMDR,"||")=1 LinkNo=""
	//医嘱套不允许被其他医嘱关联
	If LinkNo'="" {
		Set objLnkGene=..GetObjById(LinkNo)
		If $IsObject(objLnkGene){
			For indArc=1:1:objLnkGene.IGArcimList.Count() {
				Quit:LinkNo=""
				Set objTmpArcim=objLnkGene.IGArcimList.GetAt(indArc)
				Continue:'$IsObject(objTmpArcim)
				Set tmpArcimID=objTmpArcim.ITMARCIMDR
				Continue:tmpArcimID=""
				Set:$l(tmpArcimID,"||")=1 LinkNo=""
			}
		}
	}
	
	//通用名
	Set arcimInfo=##class(DHCCPW.MRC.FORM.LnkArcimSrv).GetArcimInfoById(ARCIMDR)
	Set PHCGeneID=$p(arcimInfo,"^",15)
	Set PHCGeneDesc=$p(arcimInfo,"^",16)
	
	//序号
	If IGNo="" {
		Set MaxIGNo=$o(^DHCMRCi("CPW",0,"GENE","IndexGeneNo",+ItemID,+$p(ItemID,"||",2),+$p(ItemID,"||",3),+$p(ItemID,"||",4),""),-1)
		Set IGNo=(+MaxIGNo)+1
	}
	
	Set objItemID=##class(User.DHCMRCClinPathWaysEpStepItem).GetObjById(ItemID)
	Quit:'$IsObject(objItemID) return
	
	Set strArcim=ARCIMDR
	Set strArcim=strArcim_"^"_ItemQty
	Set strArcim=strArcim_"^"_FreqDR
	Set strArcim=strArcim_"^"_DuratDR
	Set strArcim=strArcim_"^"_InstrucDR
	Set strArcim=strArcim_"^"_UOMDR
	Set strArcim=strArcim_"^"_DoseQty
	Set strArcim=strArcim_"^"_Resume
	Set strArcim=strArcim_"^"_IsDefault
	Set strArcim=strArcim_"^"_IsActive
	Set strArcim=strArcim_"^"_UpdateUser
	Set strArcim=strArcim_"^"_UpdateDate
	Set strArcim=strArcim_"^"_UpdateTime
	Set strArcim=strArcim_"^"_""
	Set objArcim=##Class(User.DHCMRCClinPathWaysARCIM).GetObj(strArcim)
	Quit:'$IsObject(objArcim) return
	
	If IGSub="" {
		Set obj=##class(User.DHCMRCClinPathWaysItmGene).%New()
	} Else {
		Set obj=##class(User.DHCMRCClinPathWaysItmGene).%OpenId(ItemID_"||"_IGSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IGParref     = objItemID
	Set obj.IGNo         = IGNo
	Set obj.IGGeneID     = PHCGeneID
	Set obj.IGGeneDesc   = PHCGeneDesc
	Set obj.IGLinkNo     = LinkNo
	Set obj.IGPriority   = Priority
	Set obj.IGIsMain     = IsMain
	
	//通用名下的关联医嘱项
	If IGASub'="" {
		Do obj.IGArcimList.SetAt(objArcim,IGASub)
	} Else {
		Do obj.IGArcimList.Insert(objArcim)
	}
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {     //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

ClassMethod UpdateIsMain(aGeneID As %String, aValue As %String) As %String
{
	New (aGeneID, aValue)
	Set return=0
	Quit:aGeneID="" return
	
	Set obj=##class(User.DHCMRCClinPathWaysItmGene).%OpenId(aGeneID)
	Quit:'$IsObject(obj) return
	Set obj.IGIsMain = $s(aValue=1:"Y",1:"N")
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {     //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=1
	}
	Do obj.%Close()
	Quit return
}

ClassMethod UpdateIsDefault(aGeneID As %String, aIGASub As %String, aValue As %String) As %String
{
	New (aGeneID, aIGASub, aValue)
	Set return=0
	Quit:(aGeneID="")||(aIGASub="") return
	
	Set obj=##class(User.DHCMRCClinPathWaysItmGene).%OpenId(aGeneID)
	Quit:'$IsObject(obj) return
	Set objArcim=obj.IGArcimList.GetAt(aIGASub)
	If $IsObject(objArcim){
		Set objArcim.ITMDefault = $s(aValue=1:"Y",1:"N")
		Do obj.IGArcimList.SetAt(objArcim,aIGASub)
	}
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {     //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=1
	}
	Do obj.%Close()
	Quit return
}

ClassMethod UpdateIsActive(aGeneID As %String, aIGASub As %String, aValue As %String) As %String
{
	New (aGeneID, aIGASub, aValue)
	Set return=0
	Quit:(aGeneID="")||(aIGASub="") return
	
	Set obj=##class(User.DHCMRCClinPathWaysItmGene).%OpenId(aGeneID)
	Quit:'$IsObject(obj) return
	Set objArcim=obj.IGArcimList.GetAt(aIGASub)
	If $IsObject(objArcim){
		Set objArcim.ITMIsActive = $s(aValue=1:"Y",1:"N")
		Do obj.IGArcimList.SetAt(objArcim,aIGASub)
	}
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {     //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=1
	}
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-06-13
/// Description:  替换关联医嘱序号
/// Table：       User.DHCMRCClinPathWaysItmGene
/// Input：       FromGeneID : User.DHCMRCClinPathWaysItmGene.ID
///               ToGeneID : User.DHCMRCClinPathWaysItmGene.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(User.DHCMRCClinPathWaysItmGene).ChangeIGNo()
ClassMethod ChangeIGNo(aFromGeneID As %String, aToGeneID As %String) As %String
{
	New (aFromGeneID,aToGeneID)
	Set return=0
	Quit:(aFromGeneID="")||(aToGeneID="") return
	
	Set return=-1
	Set objFromGene=..GetObjById(aFromGeneID)
	Quit:'$IsObject(objFromGene) return
	Set FromIGNo=objFromGene.IGNo
	Set objToGene=..GetObjById(aToGeneID)
	Quit:'$IsObject(objToGene) return
	Set ToIGNo=objToGene.IGNo
	
	Set return=1
	Set obj=##class(User.DHCMRCClinPathWaysItmGene).%OpenId(aFromGeneID)
	Set obj.IGNo = ToIGNo
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {     //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-2
	}
	Do obj.%Close()
	Quit:return<0 return
	
	Set obj=##class(User.DHCMRCClinPathWaysItmGene).%OpenId(aToGeneID)
	Set obj.IGNo = FromIGNo
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {     //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-3
	}
	Do obj.%Close()
	Quit:return<0 return
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-06-13
/// Description:  合并关联医嘱
/// Table：       User.DHCMRCClinPathWaysItmGene
/// Input：       FromGeneID : User.DHCMRCClinPathWaysItmGene.ID
///               ToGeneID : User.DHCMRCClinPathWaysItmGene.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(User.DHCMRCClinPathWaysItmGene).MergeArcim("79||1||1||11||28","79||1||1||11||29")
ClassMethod MergeArcim(aFromGeneID As %String, aToGeneID As %String) As %String
{
	New (aFromGeneID,aToGeneID)
	Set return=0
	Quit:(aFromGeneID="")||(aToGeneID="") return
	
	Set return=-1
	Set objFromGene=..GetObjById(aFromGeneID)
	Quit:'$IsObject(objFromGene) return
	Set objToGene=..GetObjById(aToGeneID)
	Quit:'$IsObject(objToGene) return
	
	Set return=1
	Set obj=##class(User.DHCMRCClinPathWaysItmGene).%OpenId(aToGeneID)
	Set Count=objFromGene.IGArcimList.Count()
	For indArc=1:1:Count {
		Set objArcim=objFromGene.IGArcimList.GetAt(indArc)
		Continue:'$IsObject(objArcim)
		Set ArcimID=objArcim.ITMARCIMDR
		Continue:ArcimID=""
		Do obj.IGArcimList.Insert(objArcim)
	}
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {     //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-2
	}
	Do obj.%Close()
	Quit:return<0 return
	
	Set return=..DeleteById(aFromGeneID)
	Quit:return<0 return
	
	Set return=1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-05-27
/// Description:  删除表单医嘱
/// Table：       User.DHCMRCClinPathWaysItmGene
/// Input：       Id : User.DHCMRCClinPathWaysItmGene.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(User.DHCMRCClinPathWaysItmGene).DeleteById()
ClassMethod DeleteById(aGeneID As %String, aIGASub As %String = "") As %String
{
	New (aGeneID,aIGASub)
	Set return=0
	Quit:aGeneID="" return
	
	Set return=-1 //无通用名记录
	Set objGene=##class(User.DHCMRCClinPathWaysItmGene).GetObjById(aGeneID)
	Quit:'$IsObject(objGene) return
	
	If aIGASub'="" {
		Set return=-2
		Set Count=objGene.IGArcimList.Count()
		Quit:Count<aIGASub return
		Set IsOnlyOneArcim=1
		For indArc=1:1:Count {
			Continue:indArc=aIGASub
			Set objArcim=objGene.IGArcimList.GetAt(indArc)
			Continue:'$IsObject(objArcim)
			Set ArcimID=objArcim.ITMARCIMDR
			Continue:ArcimID=""
			Set IsOnlyOneArcim=0
		}
		Set:IsOnlyOneArcim=1 aIGASub=""
	}
	
	If aIGASub="" {
		Set sc = ##class(User.DHCMRCClinPathWaysItmGene).%DeleteId(aGeneID)
		If $system.Status.IsError(sc) {            //检查删除是否成功
	   		Do $system.OBJ.DisplayError(sc)
	   		Set return=-3
		}Else{
			Set return=1
		}
	} Else {
		Set obj=##class(User.DHCMRCClinPathWaysItmGene).%OpenId(aGeneID)
		Do obj.IGArcimList.SetAt("",aIGASub)
		Set sc=obj.%Save()
		If $System.Status.IsError(sc) {     //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc)
	   		Set return=-4
		} Else {
			Set return=1
		}
		Do obj.%Close()
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IGNo</Value>
</Value>
<Value name="3">
<Value>IGGeneID</Value>
</Value>
<Value name="4">
<Value>IGGeneDesc</Value>
</Value>
<Value name="5">
<Value>IGLinkNo</Value>
</Value>
<Value name="6">
<Value>IGPriority</Value>
</Value>
<Value name="7">
<Value>IGIsMain</Value>
</Value>
<Value name="8">
<Value>IGArcimList</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("GENE")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("GENE")</IdLocation>
<IndexLocation>^DHCMRCi("CPW",0,"GENE")</IndexLocation>
<StreamLocation>^User.DHCMRCClinPB973S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
