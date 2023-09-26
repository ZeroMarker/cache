/// 名称: DHCMA.CPW.KB.ClinItemBase
/// 描述: 知识库-诊疗项目库（公有数据）
/// 编写者：yankai
/// 编写日期: 2022-05-12
Class DHCMA.CPW.KB.ClinItemBase Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 项目描述
Property CIDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 项目别名
Property CIAlias As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 关联病历代码（目录或术语集）多值逗号分隔
Property CIEMRCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 分类（备用）
Property CICategory As %String;

/// 项目执行判断公式（备用）
Property CIExeFun As %String;

/// 是否启用
Property CIIsActive As %String;

/// 操作日期
Property CIActDate As %Date;

/// 操作时间
Property CIActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property CIActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 对描述建立索引
Index IdxofDesc On (CIIsActive As Exact, CIDesc As AlphaUp);

/// Creator：     yankai
/// CreatDate：   2022-05-13
/// Description:  根据ID取诊疗项目库记录
/// Table：       DHCMA.CPW.KB.ClinItemBase
/// Input：       aId :  DHCMA.CPW.KB.ClinItemBase.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.KB.ClinItemBase).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.KB.ClinItemBase
{
	New (aId)
	Quit:'##class(DHCMA.CPW.KB.ClinItemBase).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.KB.ClinItemBase).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2022-05-13
/// Description:  更新诊疗项目库记录
/// Table：       DHCMA.CPW.KB.ClinItemBase
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.KB.ClinItemBase).Update(""_"^111^abc^222^"_""_"^"_""_"^"_"1"_"^"_""_"^"_""_"^"_"")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^", aHospID As %String = "") As %String
{
	New (aInputStr,aSeparete,aHospID)
	Set return=-1
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID				= $p(aInputStr,aSeparete,1) 
	Set Desc     		= $p(aInputStr,aSeparete,2)
	Set Alias    		= $p(aInputStr,aSeparete,3)
	Set:Alias="" Alias=##class(ext.util.String).ToChineseSpell($$ALPHAUP^SSUTIL4(Desc))
	Set EMRCode    		= $p(aInputStr,aSeparete,4)
	Set Category    	= $p(aInputStr,aSeparete,5)
	Set ExeFun    		= $p(aInputStr,aSeparete,6)
	Set IsActive    	= $p(aInputStr,aSeparete,7)
	Set ActDate    		= $p(aInputStr,aSeparete,8)
	Set:ActDate="" ActDate = +$h
	Set ActTime    		= $p(aInputStr,aSeparete,9)
	Set:ActTime="" ActTime = $p($h,",",2)
	Set ActUserID    	= $p(aInputStr,aSeparete,10)
	
	If ID="" {
		Set obj=##class(DHCMA.CPW.KB.ClinItemBase).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.CIDesc    		= Desc      //写入数据
	Set obj.CIAlias    		= Alias
	Set obj.CIEMRCode		= EMRCode
	Set obj.CICategory		= Category
	Set obj.CIExeFun		= ExeFun
	Set obj.CIIsActive		= IsActive
	Set obj.CIActDate		= ActDate			//直接按传值赋值（会覆盖原值），需保留原值时另写保存方法
	Set obj.CIActTime		= ActTime
	Set obj.CIActUserID		= ActUserID
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2022-05-13
/// Description:  删除诊疗项目库记录
/// Table：       DHCMA.CPW.KB.ClinItemBase
/// Input：       aId : DHCMA.CPW.KB.ClinItemBase.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.KB.ClinItemBase).DeleteById(1)
ClassMethod DeleteById(aId As %String, aHospID As %String = "") As %String
{
	New (aId,aHospID)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.KB.PathMast")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.KB.ClinItemBase).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2022-06-27
/// Description:  更新时判断Desc是否重复
/// Table：       DHCMA.CPW.KB.ClinItemBase
/// Input：       aDesc：    描述
/// Return：      重复：ID，不重复：0
/// w ##class(DHCMA.CPW.KB.ClinItemBase).CheckKBDesc("向患者及/或家属交待围手术期注意事项并签署手术知情同意书,委托书(患者本人不能签字时),自费用品协议书,进行术前审批")
ClassMethod CheckKBDesc(aDesc As %String, aID As %String = "") As %String
{
	New (aDesc,aID)
	Set return=""
	Quit:(aDesc="") return
	Set aDesc=$$ALPHAUP^SSUTIL4(aDesc)
	If ($d(^CT.MA.CPW.KB.ClinItemBaseI("IdxofDesc","1",aDesc)))
	{
		Set ID=$o(^CT.MA.CPW.KB.ClinItemBaseI("IdxofDesc","1",aDesc,""),-1)
		Set return=ID
		Set:(aID'="")&&(aID=ID) return=0
	}else{
		set return=0
	}
	Quit return
}

/// w ##class(DHCMA.CPW.KB.ClinItemBase).UpdateEmrCode("11022","EMR020102","9!!1","1")   
ClassMethod UpdateEmrCode(aID As %String, aCode As %String, aUser As %String, aType As %String = "") As %String
{
	New (aID,aCode,aUser,aType)
	Set return=-1

	Set obj=..GetObjById(aID)
	Quit:'$IsObject(obj) return
	Set EMRCode=obj.CIEMRCode
	Set CodeStr=""
	//取消
	For index=1:1:$l(EMRCode,","){
		Set Code=$p(EMRCode,",",index)
		Continue:Code=""
		Continue:(aType=0)&&(Code=aCode)
		if (CodeStr=""){
			Set CodeStr=Code	
		}else{
			Set CodeStr=CodeStr_","_Code
		}
	}
	//新增	
	Set:aType=1 CodeStr=CodeStr_","_aCode	
	b ;123
	Set obj.CIEMRCode		= CodeStr
	Set obj.CIActDate		= +$h			//直接按传值赋值（会覆盖原值），需保留原值时另写保存方法
	Set obj.CIActTime		= $p($h,",",2)
	Set obj.CIActUserID		= aUser
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// w ##class(DHCMA.CPW.KB.ClinItemBase).GetEmrCodeByID(11022)
ClassMethod GetEmrCodeByID(aID As %String) As %String
{
	New (aID)
	Set return=""
	Set obj=..GetObjById(aID)
	Quit:'$IsObject(obj) return
	Set return=obj.CIEMRCode
	Quit return
}

Storage Default
{
<Data name="ClinItemBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CIDesc</Value>
</Value>
<Value name="3">
<Value>CIAlias</Value>
</Value>
<Value name="4">
<Value>CIEMRCode</Value>
</Value>
<Value name="5">
<Value>CICategory</Value>
</Value>
<Value name="6">
<Value>CIExeFun</Value>
</Value>
<Value name="7">
<Value>CIIsActive</Value>
</Value>
<Value name="8">
<Value>CIActDate</Value>
</Value>
<Value name="9">
<Value>CIActTime</Value>
</Value>
<Value name="10">
<Value>CIActUserID</Value>
</Value>
</Data>
<DataLocation>^CT.MA.CPW.KB.ClinItemBaseD</DataLocation>
<DefaultData>ClinItemBaseDefaultData</DefaultData>
<IdLocation>^CT.MA.CPW.KB.ClinItemBaseD</IdLocation>
<IndexLocation>^CT.MA.CPW.KB.ClinItemBaseI</IndexLocation>
<StreamLocation>^CT.MA.CPW.KB.ClinItemBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
