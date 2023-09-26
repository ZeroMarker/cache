/// 名称: DHCHAI.BT.Location
/// 描述: 科室列表
/// 编写者：liyi
/// 编写日期: 2017-01-12
Class DHCHAI.BT.Location Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 关联科室
Relationship ChildLink As DHCHAI.BT.LocationLink [ Cardinality = children, Inverse = Parref ];

/// 科室代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 科室名称
Property BTDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 科室别名
Property BTDesc2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 科室类型（E执行科室、W病区、O辅助科室）
Property BTTypeDr As DHCHAI.BT.Dictionary;

/// 科室标记（O门诊、E急诊、I住院）
Property BTCateDr As DHCHAI.BT.Dictionary;

/// 科室分类
Property BTGroupDr As DHCHAI.BT.LocGroup;

/// 所属医院
Property BTHospDr As DHCHAI.BT.Hospital [ Required ];

/// 是否手术科室
Property BTIsOPER As %Boolean;

/// 是否ICU病房
Property BTIsICU As %Boolean;

/// 是否新生儿病房
Property BTIsNICU As %Boolean;

/// ICU科室类型（CCU 心脏重症室、ICU 重症室、MICU 内科重症室、NICU 新生儿重症室、PICU 儿科重症室、SICU 外科重症室、EICU 急诊重症室）
Property BTICUTpDr As DHCHAI.BT.Dictionary;

/// 记录索引码（HIS中科室ID）
Property BTXCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property BTIsActive As %Boolean;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUserDr As DHCHAI.BT.SysUser;

/// 父指针（目的是为虚拟病区）
Property BTParLocDr As DHCHAI.BT.Location;

/// 排序码
Property BTIndNo As %String(TRUNCATE = 1);

/// 科室代码索引
Index IndexLocCode On BTCode As Exact;

/// 记录索引码索引
Index IndexXCode On BTXCode As Exact;

/// 科室类型索引
Index IndexLocTypeDr On BTTypeDr;

/// 科室分类索引
Index IndexLocGroupDr On BTGroupDr;

/// 科室标记索引
Index IndexLocCateDr On BTCateDr;

/// 医院索引
Index IndexHospDr On BTHospDr;

/// 是否手术科室索引
Index IndexIsOPERLoc On BTIsOPER As Exact;

/// 是否ICU病房索引
Index IndexIsICULoc On BTIsICU As Exact;

/// 是否新生儿病房索引
Index IndexIsNICULoc On BTIsNICU As Exact;

/// 科室别名索引
Index IndexBTDesc2 On BTDesc2 As Exact;

/// 顺序号+科室名称 索引
Index IndexIndNoLocDesc On (BTIndNo, BTDesc);

/// Creator：     zhufei
/// CreatDate：   2017-09-30
/// Description:  根据科室代码取对照科室
/// Table：       DHCHAI.BT.Location、DHCHAI.BT.LocationMap
/// Input：       aSCode : DHCHAI.BT.LocationMap.BTSCode
///               aLocCode : DHCHAI.BT.LocationMap.BTCode
/// Return：      返回obj
/// w ##class(DHCHAI.BT.Location).GetObjByLocCode("LIS02","产科")
ClassMethod GetObjByLocCode(aSCode As %String, aLocCode As %String) As DHCHAI.BT.Location
{
	New (aSCode,aLocCode)
	Set return = ""
	Quit:(aSCode="")||(aLocCode="") return
	
	Set aSCode=$zcvt(aSCode,"U")
	Set aLocCode=$zcvt(aLocCode,"U")
	Set objMap=##class(DHCHAI.BT.LocationMap).GetObjByCode(aSCode,aLocCode)
	If $IsObject(objMap) {
		Quit:'$IsObject(objMap.BTMapLocDr) return
		Set return=objMap.BTMapLocDr
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-30
/// Description:  根据XCode取对照科室
/// Table：       DHCHAI.BT.Location、DHCHAI.BT.LocationMap
/// Input：       aSCode : DHCHAI.BT.LocationMap.BTSCode
///               aXCode : DHCHAI.BT.LocationMap.BTXCode
/// Return：      返回obj
/// w ##class(DHCHAI.BT.Location).GetObjByXCode(1)
ClassMethod GetObjByXCode(aSCode As %String, aXCode As %String) As DHCHAI.BT.Location
{
	New (aSCode,aXCode)
	Set return = ""
	Quit:(aSCode="")||(aXCode="") return
	
	Set aSCode=$zcvt(aSCode,"U")
	Set aXCode=$zcvt(aXCode,"U")
	Set objMap=##class(DHCHAI.BT.LocationMap).GetObjByXCode(aSCode,aXCode)
	If $IsObject(objMap) {
		Quit:'$IsObject(objMap.BTMapLocDr) return
		Set return=objMap.BTMapLocDr
	}
	Quit:return'="" return
	
	Set ID=$o(^DHCHAI.BT.LocationI("IndexXCode",aSCode_"||"_aXCode,0))
	Set:ID'="" return=##class(DHCHAI.BT.Location).GetObjById(ID)
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2017-10-31
/// Description:  根据科室别名取科室对象
/// Table：       DHCHAI.BT.Location
/// Input：       aLocDesc2 : DHCHAI.BT.Location.BTDesc2
/// Return：      返回obj
/// w ##class(DHCHAI.BT.Location).GetObjByLocDesc2("肾心内科病房(西院)")
ClassMethod GetObjByLocDesc2(aLocDesc2 As %String) As DHCHAI.BT.Location
{
	New (aLocDesc2)
	Set return=""
	Quit:(aLocDesc2="") return
	
	Set xLocID=0
	For {
		Set xLocID=$o(^DHCHAI.BT.LocationI("IndexBTDesc2",aLocDesc2,xLocID))
		Quit:xLocID=""
		
		Set objLoc=..GetObjById(xLocID)
		Continue:'$IsObject(objLoc)
		Continue:objLoc.BTIsActive'=1
		Set return=objLoc
		Quit
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取科室信息
/// Table：       DHCHAI.BT.Location
/// Input：       aId : DHCHAI.BT.Location.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.Location).GetObjById(62)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.Location
{
	New (aId,%session)
	Quit:'##class(DHCHAI.BT.Location).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.Location).%OpenId(aId)
	If $IsObject(obj){
		If '$IsObject(obj.BTGroupDr) {
			Set obj.BTGroupDr=##class(DHCHAI.BT.LocGroup).GetObjByDesc("其他科")
		}
	}
	Do:obj'="" obj.%Close()
	//多语言处理
	set obj.BTDesc = ##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",obj.BTDesc,"User.CTLoc")
	Quit obj
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新科室信息
/// Table：       DHCHAI.BT.Location
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.Location).Update("")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(aInputStr,aSeparete,1)
	Set Code		= $p(aInputStr,aSeparete,2)
	Set Desc		= $p(aInputStr,aSeparete,3)
	Set Desc2	    = $p(aInputStr,aSeparete,4)
	Set TypeDr		= $p(aInputStr,aSeparete,5)
	Set CateDr		= $p(aInputStr,aSeparete,6)
	Set GroupDr	    = $p(aInputStr,aSeparete,7)
	Set HospDr		= $p(aInputStr,aSeparete,8)
	Set IsOPER	    = +$p(aInputStr,aSeparete,9)
	Set IsICU	    = +$p(aInputStr,aSeparete,10)
	Set IsNICU	    = +$p(aInputStr,aSeparete,11)
	Set ICUTpDr	    = $p(aInputStr,aSeparete,12)
	Set XCode		= $p(aInputStr,aSeparete,13)
	Set IsActive	= +$p(aInputStr,aSeparete,14)
	Set ActDate		= $p(aInputStr,aSeparete,15)
	Set ActTime		= $p(aInputStr,aSeparete,16)
	Set ActUserDr   = $p(aInputStr,aSeparete,17)
	Set ParLocDr    = $p(aInputStr,aSeparete,18)
	Set IndNo    	= $p(aInputStr,aSeparete,19)									   
	Quit:(Code="")||(Desc="")||(HospDr="")||(XCode="") return
	
	Set Code=$zcvt(Code,"U")
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	
	Set objParLoc=##class(DHCHAI.BT.Location).GetObjById(ParLocDr)
	
	Set XCode=$zcvt(XCode,"U")
	Set tID=$o(^DHCHAI.BT.LocationI("IndexXCode",XCode,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	Set objType=##class(DHCHAI.BT.Dictionary).GetObjById(TypeDr)
	Set objCate=##class(DHCHAI.BT.Dictionary).GetObjById(CateDr)
	Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjById(GroupDr)
	Set objHosp=##class(DHCHAI.BT.Hospital).GetObjById(HospDr)
	Set objICUTp=##class(DHCHAI.BT.Dictionary).GetObjById(ICUTpDr)
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	Quit:'$isobject(objHosp) return
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.Location).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.Location).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode	    = Code
	Set obj.BTDesc	    = Desc
	Set obj.BTDesc2	    = Desc2
	Set obj.BTTypeDr	= objType
	Set obj.BTCateDr	= objCate
	Set obj.BTGroupDr	= objGroup
	Set obj.BTHospDr	= objHosp
	Set obj.BTIsOPER	= IsOPER
	Set obj.BTIsICU	    = IsICU
	Set obj.BTIsNICU	= IsNICU
	Set obj.BTICUTpDr	= objICUTp
	Set obj.BTXCode		= XCode
	Set obj.BTIsActive 	= IsActive
	Set obj.BTActDate 	= ActDate
	Set obj.BTActTime 	= ActTime
	Set obj.BTActUserDr = objActUser
	Set obj.BTParLocDr  = objParLoc
	Set obj.BTIndNo     = IndNo						
	
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

/// 创建虚拟病区
/// w ##class(DHCHAI.BT.Location).Update2("^1570030^JZZHBF-急诊综合病房^急诊重症监护室^32^36^^2^0^0^1^^HIS01||341^1^^^6543^830")
ClassMethod Update2(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID=$p(aInputStr,aSeparete,1)
	Set XCode=$p(aInputStr,aSeparete,13)
	Set ParLocDr=$p(aInputStr,aSeparete,18)
	Quit:ID'="" return
	Quit:ParLocDr="" return
	
	Set XCode=$zcvt(XCode,"U")
	Set pXCode=$o(^DHCHAI.BT.LocationI("IndexXCode",XCode_"||X"),-1)
	If ($p(XCode,"||",1)=$p(pXCode,"||",1))&($p(XCode,"||",2)=$p(pXCode,"||",2)) {
		Set XCode=XCode_"||"_(+$p(pXCode,"||",1)+1)
	} Else {
		Set XCode=XCode_"||"_1
	}
	Set $p(aInputStr,aSeparete,13)=XCode
	Set return=..Update(aInputStr,aSeparete)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除科室信息
/// Table：       DHCHAI.BT.Location
/// Input：       aId : DHCHAI.BT.Location.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.Location).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.BT.Location).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2017-09-28
/// Description:  导入科室修改信息
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##Class(DHCHAI.BT.Location).ImportLoc("35^1240032^SJWKSJJZZJHBQ-神经外科神经急重症监护病区^神经外科神经急重症监护病区^HIS01^1^1^0^1")
ClassMethod ImportLoc(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set XCode		= $p(aInputStr,aSeparete,1)
	Set Code		= $p(aInputStr,aSeparete,2)
	Set Desc		= $p(aInputStr,aSeparete,3)
	Set Desc2	    = $p(aInputStr,aSeparete,4)
	Set HospCode	= $p(aInputStr,aSeparete,5)
	Set IsActive	= +$p(aInputStr,aSeparete,6)
	Set IsICU	    = +$p(aInputStr,aSeparete,7)
	Set IsNICU	    = +$p(aInputStr,aSeparete,8)
	Set IsOPER	    = +$p(aInputStr,aSeparete,9)
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjByXCode(HospCode,XCode)
	Quit:'$IsObject(objLoc) return
	Set ID=objLoc.%Id()
	Set Code=objLoc.BTCode
	Set Desc=objLoc.BTDesc
	Set XCode=objLoc.BTXCode
	
	Set (HospDr,TypeDr,CateDr,GroupDr,ICUTpDr,ParLocDr)=""
	Set:$IsObject(objLoc.BTHospDr) HospDr=objLoc.BTHospDr.%Id()
	Set:$IsObject(objLoc.BTTypeDr) TypeDr=objLoc.BTTypeDr.%Id()
	Set:$IsObject(objLoc.BTCateDr) CateDr=objLoc.BTCateDr.%Id()
	Set:$IsObject(objLoc.BTGroupDr) GroupDr=objLoc.BTGroupDr.%Id()
	Set:$IsObject(objLoc.BTICUTpDr) ICUTpDr=objLoc.BTICUTpDr.%Id()
	Set:$IsObject(objLoc.BTParLocDr) ParLocDr=objLoc.BTParLocDr.%Id()
	
	Set InputStr=ID
	Set InputStr=InputStr_"^"_Code
	Set InputStr=InputStr_"^"_Desc
	Set InputStr=InputStr_"^"_Desc2
	Set InputStr=InputStr_"^"_TypeDr
	Set InputStr=InputStr_"^"_CateDr
	Set InputStr=InputStr_"^"_GroupDr
	Set InputStr=InputStr_"^"_HospDr
	Set InputStr=InputStr_"^"_IsOPER
	Set InputStr=InputStr_"^"_IsICU
	Set InputStr=InputStr_"^"_IsNICU
	Set InputStr=InputStr_"^"_ICUTpDr
	Set InputStr=InputStr_"^"_XCode
	Set InputStr=InputStr_"^"_IsActive
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_ParLocDr
	Set return=..Update(InputStr)
	Quit return
}

Storage Default
{
<Data name="LocationDefaultData">
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
<Value>BTDesc2</Value>
</Value>
<Value name="5">
<Value>BTTypeDr</Value>
</Value>
<Value name="6">
<Value>BTCateDr</Value>
</Value>
<Value name="7">
<Value>BTGroupDr</Value>
</Value>
<Value name="8">
<Value>BTHospDr</Value>
</Value>
<Value name="9">
<Value>BTIsOPER</Value>
</Value>
<Value name="10">
<Value>BTIsICU</Value>
</Value>
<Value name="11">
<Value>BTIsNICU</Value>
</Value>
<Value name="12">
<Value>BTICUTpDr</Value>
</Value>
<Value name="13">
<Value>BTXCode</Value>
</Value>
<Value name="14">
<Value>BTIsActive</Value>
</Value>
<Value name="15">
<Value>BTActDate</Value>
</Value>
<Value name="16">
<Value>BTActTime</Value>
</Value>
<Value name="17">
<Value>BTActUserDr</Value>
</Value>
<Value name="18">
<Value>BTParLocDr</Value>
</Value>
<Value name="19">
<Value>BTIndNo</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.LocationD</DataLocation>
<DefaultData>LocationDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.LocationD</IdLocation>
<IndexLocation>^DHCHAI.BT.LocationI</IndexLocation>
<StreamLocation>^DHCHAI.BT.LocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
