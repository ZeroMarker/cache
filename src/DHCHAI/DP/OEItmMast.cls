/// 名称: DHCHAI.DP.OEItmMast
/// 描述: 医嘱项
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.OEItmMast Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 医嘱代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 医嘱名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 医嘱分类
Property BTCatDr As DHCHAI.DP.OEItmCat;

/// 有效标志
Property BTIsActive As %Boolean [ Required ];

/// 医嘱分类索引
Index IndexCatDr On BTCatDr As Exact;

/// 医嘱代码索引
Index IndexCode On BTCode As Exact;

/// 医嘱名称索引
Index IndexDesc On BTDesc As Exact;

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取医嘱项分类
/// Table：       DHCHAI.DP.OEItmMast
/// Input：       ID:    DHCHAI.DP.OEItmMast.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OEItmMast).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.OEItmMast
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.OEItmMast).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.OEItmMast).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-04-17
/// Description:  根据代码、名称取医嘱项
/// Table：       DHCHAI.DP.OEItmMast
/// Input：       aCode:    医嘱项代码
/// 			  aDesc:    医嘱项名称
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OEItmMast).GetObjByCodeDesc("","")
ClassMethod GetObjByCodeDesc(aCode As %String, aDesc As %String) As DHCHAI.DP.OEItmMast
{
	New (aCode,aDesc)
	Set return=""
	Quit:((aCode="")&&(aDesc=""))||((aCode'="")&&(aDesc'="")) return
	
	Set id=""
	Set:aCode'="" id = $o(^DHCHAI.DP.OEItmMastI("IndexCode",aCode,0))
	Set:aDesc'="" id = $o(^DHCHAI.DP.OEItmMastI("IndexDesc",aDesc,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2019-03-19
/// Description:  执行下隔离医嘱 
/// 问题：医嘱单上面没有显示隔离医嘱
/// w ##class(DHCHAI.DP.OEItmMast).SaveOrderItem(82,"接触隔离",9258,248)
ClassMethod SaveOrderItem(aEpisodeDr As %String, aMRBShieldDesc As %String, aUserID As %String, aLocID As %String) As %String
{
	New (aEpisodeDr,aMRBShieldDesc,aUserID,aLocID)
	Set return=""
	Quit:((aEpisodeDr="")||(aMRBShieldDesc="")) return
	
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objPaadm) return
	Set EpisodeIDx = objPaadm.PAEpisodeIDx
	Set Paadm=$p(EpisodeIDx,"||",2)    //HIS就诊ID
	Quit:Paadm="" return
	
	Set ItmMastID = ..GetMastIDByDesc(aMRBShieldDesc)
	Quit:ItmMastID="" return
	// 增加医嘱类型为长期医嘱
	Set OEType = $O(^OECPR(0,"Code","S",0))
	Set Orditmstr=ItmMastID_$C(2)_"1"_$C(2)_OEType
	
	Set Flg=##class(web.DHCOEOrdItem).InsertContinuousOrder(Paadm,aUserID,aLocID,Orditmstr)
	
	Quit 1
}

/// Creator：     zhoubo
/// CreatDate：   2019-03-19
/// Description:  根据医嘱项名称获取医嘱项ID
/// w ##class(DHCHAI.DP.OEItmMast).GetMastIDByDesc("保护性隔离")
ClassMethod GetMastIDByDesc(aDesc As %String) As %String
{
	New (aDesc)
	Set return=""
	Quit:(aDesc="") return
	
	Set aDesc=$$ALPHAUP^SSUTIL4(aDesc)		//$$ALPHAUP^SSUTIL4("隔离(222)")
	
	Set ARCIMSubscript = $o(^ARCIM(0,"Desc",aDesc,0))
	Quit:(ARCIMSubscript="") return
	
	Set ARCIMVersion = $o(^ARCIM(0,"Desc",aDesc,ARCIMSubscript,0))
	Quit:(ARCIMVersion="") return
	
	Set ItmMastID = ARCIMSubscript_"||"_ARCIMVersion
	Set return=ItmMastID
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新医嘱项分类
/// Table：       DHCHAI.DP.OEItmMast
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OEItmMast).Update("^SHS^三管医嘱^1")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set Code		= $p(InStr,aSeparete,2)
	Set Desc		= $p(InStr,aSeparete,3)
	Set CatDr       = $p(InStr,aSeparete,4)
	Set IsActive	= +$p(InStr,aSeparete,5)
	Quit:(Code="")||(Desc="")||(IsActive="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	
	//代码唯一性
	Set tID =$o(^DHCHAI.DP.OEItmMastI("IndexCode",Code,0)) 
	Quit:(tID'="")&(ID'=tID) -100

	//名称唯一性
	Set tID =$o(^DHCHAI.DP.OEItmMastI("IndexDesc",Desc,0)) 
	Quit:(tID'="")&(ID'=tID) -100
		
	Set objCat=##class(DHCHAI.DP.OEItmCat).GetObjById(CatDr)
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.OEItmMast).%New()
	}else{
		Set obj=##class(DHCHAI.DP.OEItmMast).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode		= Code
	Set obj.BTDesc		= Desc
	Set obj.BTCatDr     = objCat
	Set obj.BTIsActive	= IsActive
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除医嘱项分类
/// Table：       DHCHAI.DP.OEItmMast
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.OEItmMast).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTCatDr</Value>
</Value>
<Value name="5">
<Value>BTIsActive</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.OEItmMastD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.OEItmMastD</IdLocation>
<IndexLocation>^DHCHAI.DP.OEItmMastI</IndexLocation>
<StreamLocation>^DHCHAI.DP.OEItmMastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
