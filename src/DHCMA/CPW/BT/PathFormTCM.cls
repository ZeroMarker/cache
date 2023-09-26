Class DHCMA.CPW.BT.PathFormTCM Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.BT.PathFormItem [ Cardinality = parent, Inverse = ChildTCM ];

/// 中药方剂
Property TCMDic As DHCMA.CPW.BT.PathTCM;

/// 处置日期
Property TCMActDate As %Date;

/// 处置时间
Property TCMActTime As %Time;

/// 处置人（指向DHCMA.CPW.EP.SSUser.OID）
Property TCMActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 组套方案 指向DHCMA.CPW.BT.PathOrdGroup
Property TCMGroupID As %String;

/// 项目&方剂索引，索引唯一
Index PItemTCM On (Parref, TCMDic) [ Unique ];

/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.BT.PathFormTCM
/// Input：       aId : DHCMA.CPW.BT.PathFormTCM.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.PathFormTCM).GetObjById("1||1")
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathFormTCM
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathFormTCM).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathFormTCM).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  更新实体对象
/// Table：       DHCMA.CPW.BT.PathFormTCM
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathFormTCM).Update("4||1||1^1^1^^^9")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref		   = $p(aInputStr,aSeparete,1)
	Set ChildSub       = $p(aInputStr,aSeparete,2)
	Set TCMDicDr       = $p(aInputStr,aSeparete,3)
	Set TCMActDate     = $p(aInputStr,aSeparete,4)
	Set TCMActTime     = $p(aInputStr,aSeparete,5)
	Set TCMActUserID   = $p(aInputStr,aSeparete,6)
	
	Set:TCMActDate'="" TCMActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(TCMActDate)
	Set:TCMActTime[":" TCMActTime = $zth(TCMActTime,1)
	Set:TCMActDate="" TCMActDate=+$h
	Set:TCMActTime="" TCMActTime=+$p($h,",",2)	
	
	Quit:(Parref="")||(TCMDicDr="") -1
	Set objPathFormItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(Parref)
	Quit:'$Isobject(objPathFormItem) -1
		
	If ChildSub="" {
		Set obj=##class(DHCMA.CPW.BT.PathFormTCM).%New()
	}Else{
		Set ID = Parref_"||"_ChildSub
		Set obj=##class(DHCMA.CPW.BT.PathFormTCM).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return	
	Set obj.Parref       	= objPathFormItem  //对象
	Set obj.TCMDic	 		= ##class(DHCMA.CPW.BT.PathTCM).GetObjById(TCMDicDr)  
	Set obj.TCMActDate  	= TCMActDate
	Set obj.TCMActTime    	= TCMActTime
	Set obj.TCMActUserID	= TCMActUserID

	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
		Set return = $p(return,"||",4)
	}
	Do obj.%Close()
	
	Quit return
}

/// Description:  删除对象信息
/// Table：       DHCMA.CPW.BT.PathFormTCM
/// Input：       aId : DHCMA.CPW.BT.PathFormTCM.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathFormTCM).DeleteById("1||1")
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.BT.PathFormTCM).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
		//未知原因删除后不能成功删除相关global，这里检查执行一下
		If $d(^DHCMA.CPW.BT.PathFormD($p(aId,"||",1),"EP",$p(aId,"||",2),"ITM",$p(aId,"||",3),"TCM")) 
		{
			Kill ^DHCMA.CPW.BT.PathFormD($p(aId,"||",1),"EP",$p(aId,"||",2),"ITM",$p(aId,"||",3),"TCM")
		}
		If $d(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",$p(aId,"||",1),$p(aId,"||",2),$p(aId,"||",3))){
			Kill ^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",$p(aId,"||",1),$p(aId,"||",2),$p(aId,"||",3))	
		}
	}
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2021-01-07
/// Description:  更新医嘱分组
/// Table：       DHCMA.CPW.BT.PathFormOrd
/// Input：       aID:关联医嘱ID;aOrdGroupID:医嘱分组ID;isChecked:是否选中
/// Return：      成功：返回更新条数，失败：返回""
/// w ##class(DHCMA.CPW.BT.PathFormTCM).UpdateTCMGroup("34||1||7||1","1","1")
ClassMethod UpdateTCMGroup(aID As %String, aOrdGroupID As %String, isChecked As %String) As %String
{
	New (aID,aOrdGroupID,isChecked)
	Set return=""
	Quit:(aID="")||(aOrdGroupID="") return
	
	Set obj=##class(DHCMA.CPW.BT.PathFormTCM).GetObjById(aID)
	Quit:'$IsObject(obj) return
	Set strOrdGroup=obj.TCMGroupID
	Set listOrdGroup=$lfs(strOrdGroup,",")
	If isChecked'=1{
		Set idx= $lf(listOrdGroup,aOrdGroupID)
		If (idx>0){
			Set $list(listOrdGroup,idx,idx)=""				//若存在则删除
		}
		Set obj.TCMGroupID=$lts(listOrdGroup,",") 
	}Else{
		If strOrdGroup=""{
			Set obj.TCMGroupID=aOrdGroupID	
		}Else{
			Set:$lf(listOrdGroup,aOrdGroupID)=0 obj.TCMGroupID=strOrdGroup_","_aOrdGroupID
		}
	}
	
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

Storage Default
{
<Data name="PathFormTCMDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrdTypeDr</Value>
</Value>
<Value name="3">
<Value>OrdMastID</Value>
</Value>
<Value name="4">
<Value>OrdGeneID</Value>
</Value>
<Value name="5">
<Value>OrdPriorityID</Value>
</Value>
<Value name="6">
<Value>OrdQty</Value>
</Value>
<Value name="7">
<Value>OrdFreqID</Value>
</Value>
<Value name="8">
<Value>OrdDuratID</Value>
</Value>
<Value name="9">
<Value>OrdInstrucID</Value>
</Value>
<Value name="10">
<Value>OrdDoseQty</Value>
</Value>
<Value name="11">
<Value>OrdUOMID</Value>
</Value>
<Value name="12">
<Value>OrdNote</Value>
</Value>
<Value name="13">
<Value>OrdChkPosID</Value>
</Value>
<Value name="14">
<Value>OrdLnkOrdDr</Value>
</Value>
<Value name="15">
<Value>OrdIsDefault</Value>
</Value>
<Value name="16">
<Value>OrdIsFluInfu</Value>
</Value>
<Value name="17">
<Value>OrdIsActive</Value>
</Value>
<Value name="18">
<Value>OrdActDate</Value>
</Value>
<Value name="19">
<Value>OrdActTime</Value>
</Value>
<Value name="20">
<Value>OrdActUserID</Value>
</Value>
<Value name="21">
<Value>OrdOID</Value>
</Value>
<Value name="22">
<Value>TCMDic</Value>
</Value>
<Value name="23">
<Value>TCMActDate</Value>
</Value>
<Value name="24">
<Value>TCMActTime</Value>
</Value>
<Value name="25">
<Value>TCMActUserID</Value>
</Value>
<Value name="26">
<Value>TCMGroupID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("TCM")</DataLocation>
<DefaultData>PathFormTCMDefaultData</DefaultData>
<IdLocation>{%%PARENT}("TCM")</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathFormI("TCM")</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathFormTCMS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
