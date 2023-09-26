/// 名称: DHCHAI.IR.EnviHyItem
/// 描述: 环境卫生学监测项目
/// 编写者：liyi
/// 编写日期: 2018-01-15
Class DHCHAI.IR.EnviHyItem Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 关联对象
Relationship ChildObj As DHCHAI.IR.EnviHyItemObj [ Cardinality = children, Inverse = Parref ];

/// 项目名称
Property EHItemDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目类型 EHItemType
Property EHItemTypeDr As DHCHAI.BT.Dictionary [ Required ];

/// 标本类型 EHSpenType
Property EHSpecimenTypeDr As DHCHAI.BT.Dictionary [ Required ];

/// 环境类别 EHEnvironmentCate
Property EHEnvironmentCateDr As DHCHAI.BT.Dictionary;

/// 检测标准单位
Property EHNorm As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// [修改]项目值/中心值合格上限
Property EHNormMax As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// [修改]周边值合格上限
Property EHNormMin As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 标本数量
Property EHSpecimenNum As %Integer(MAXVAL = 1000) [ Required ];

/// 中心点个数
Property EHCenterNum As %Integer(MAXVAL = 1000) [ Required ];

/// 周边点个数
Property EHSurroundNum As %Integer(MAXVAL = 1000) [ Required ];

/// [新增]参照点个数
Property EHReferToNum As %Integer(MAXVAL = 1000) [ Required ];

/// 计算公式
Property EHForMula As %String(MAXLEN = 100, TRUNCATE = 1);

/// 监测频率
Property EHFreq As %String(MAXLEN = 100, TRUNCATE = 1);

/// 单位
Property EHUom As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property EHIsActive As %Boolean [ Required ];

/// 更新日期
Property EHActDate As %Date;

/// 更新时间
Property EHActTime As %Time;

/// 更新人
Property EHActUserDr As DHCHAI.BT.SysUser;

/// [新增]下申请时是否允许对象为空
Property EHIsObjNull As %Boolean;

/// [新增]下申请时是否允许调整标本数量
Property EHIsSpecNum As %Boolean;

/// [新增]录入方式 "EHEnterType"（1按项目、2按标本、3其他[1中心+1周边]）
Property EHEnterTypeDr As DHCHAI.BT.Dictionary;

/// [新增]支持多院区
Property EHHospDr As DHCHAI.BT.Hospital;

/// 检验外部项目
Property EHExtItemDr As DHCHAI.DP.LabInfTestSet;

/// 项目名称 索引
Index IndexOnItemDesc On EHItemDesc As Exact;

/// 院区+项目名称 索引
Index IdxHospDrItemDesc On (EHHospDr, EHItemDesc) [ Unique ];

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  根据ID取监测项目
/// Table：       DHCHAI.IR.EnviHyItem
/// Input：       id:    DHCHAI.IR.EnviHyItem.ID
/// Return：      返回Object
/// w ##class(DHCHAI.IR.EnviHyItem).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.IR.EnviHyItem
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.IR.EnviHyItem).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.IR.EnviHyItem).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  更新监测项目
/// Table：       DHCHAI.IR.EnviHyItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.EnviHyItem).Update("")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set $ZT="UpdateErr"
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID				= $p(InStr,aSeparete,1)
	Set ItemDesc		= $p(InStr,aSeparete,2)
	Set SpecimenTypeDesc= $p(InStr,aSeparete,3)
	Set Norm			= $p(InStr,aSeparete,4)
	Set NormMax			= $p(InStr,aSeparete,5)
	Set NormMin			= $p(InStr,aSeparete,6)
	Set SpecimenNum		= $p(InStr,aSeparete,7)
	Set CenterNum		= $p(InStr,aSeparete,8)
	Set SurroundNum		= $p(InStr,aSeparete,9)
	Set ForMula			= $p(InStr,aSeparete,10)
	Set Freq			= $p(InStr,aSeparete,11)
	Set Uom				= $p(InStr,aSeparete,12)
	Set IsActive		= +$p(InStr,aSeparete,13)
	Set ItemTypeDesc	= $p(InStr,aSeparete,14)
	Set EnvironmentCateDesc	= $p(InStr,aSeparete,15)
	Set ReferToNum		= $p(InStr,aSeparete,16)
	Set IsObjNull		= $p(InStr,aSeparete,17)
	Set IsSpecNum		= $p(InStr,aSeparete,18)
	Set EnterTypeDesc	= $p(InStr,aSeparete,19)
	Set HospID			= $p(InStr,aSeparete,20)
	Set ActUserDr		= $p(InStr,aSeparete,21)
	Set EHExtItemDr     = $p(InStr,aSeparete,22)
	Quit:(ItemDesc="")||(SpecimenTypeDesc="")||(Norm="")||(NormMax="")||(NormMin="") return
	
	Quit:(SpecimenNum="")||(CenterNum="")||(SurroundNum="") return
	
	Set objSpecType = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("EHSpenType",SpecimenTypeDesc)
	Quit:'$IsObject(objSpecType) return

	Set objItemType = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("EHItemType",ItemTypeDesc)
	Quit:'$IsObject(objItemType) return
	
	Set objEnvironmentCate = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("EHEnvironmentCate",EnvironmentCateDesc)
	Set objEnterType = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("EHEnterType",EnterTypeDesc)
	//关联院区处理
	Set HospDr=""
	if (+HospID'=0) {
		Set HospDr=##class(DHCHAI.BT.Hospital).GetObjById(HospID)
		Quit:'$IsObject(HospDr) return
	}
	Set objExt = ##class(DHCHAI.DP.LabInfTestSet).GetObjById(EHExtItemDr)
	//操作人
	Set ActUserDr = ##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	// 医院+项目名称索引码 唯一性(这里允许医院为空，为空则对所有医院生效；反之则只对关联医院生效)
	Set tID =..GetExsitID(ItemDesc,HospDr)
	Quit:(tID'="")&(ID'="")&(ID'=tID) -100 
	Set:tID'="" ID=tID
	if ID="" {
		Set obj=##class(DHCHAI.IR.EnviHyItem).%New()
	}else{
		Set obj=##class(DHCHAI.IR.EnviHyItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EHItemDesc			= ItemDesc
	Set obj.EHSpecimenTypeDr	= objSpecType
	Set obj.EHNorm				= Norm
	Set obj.EHNormMax			= NormMax
	Set obj.EHNormMin			= NormMin
	Set obj.EHSpecimenNum		= SpecimenNum
	Set obj.EHCenterNum			= CenterNum
	Set obj.EHSurroundNum		= SurroundNum
	Set obj.EHForMula			= ForMula
	Set obj.EHFreq				= Freq
	Set obj.EHUom				= Uom
	Set obj.EHIsActive			= IsActive
	Set obj.EHItemTypeDr		= objItemType
	Set obj.EHEnvironmentCateDr	= objEnvironmentCate
	Set obj.EHReferToNum		= ReferToNum
	Set obj.EHIsObjNull			= IsObjNull
	Set obj.EHIsSpecNum			= IsSpecNum
	Set obj.EHEnterTypeDr		= objEnterType
	Set obj.EHHospDr			= HospDr
	Set obj.EHActDate			= +$h
	Set obj.EHActTime			= $p($h,",",2)
	Set obj.EHActUserDr			= ActUserDr
	Set obj.EHExtItemDr         = objExt
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
UpdateErr
	Write "Error:"_$ZERROR,!
 	Quit -1
}

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  获取监测项目默认标本数量
/// Table：       DHCHAI.IR.EnviHyItem
/// Input：       Id
/// Return：      默认标本数量
/// w ##class(DHCHAI.IR.EnviHyItem).GetSpenNumById("4")
ClassMethod GetSpenNumById(Id)
{
	New (Id)
	Set return = ""
	Set obj = ##class(DHCHAI.IR.EnviHyItem).GetObjById(Id)
	Quit:obj="" return
	Set EHSpecimenNum 	= +obj.EHSpecimenNum
	Set EHCenterNum		= +obj.EHCenterNum
	Set EHSurroundNum	= +obj.EHSurroundNum
	Set EHReferToNum	= +obj.EHReferToNum
	Set EHIsSpecNum		= obj.EHIsSpecNum
	If ('$IsObject(obj.EHEnterTypeDr)){
		set EHEnterTypeDr=0
		Set EHEnterTypeDesc=""
	}else{
		Set EHEnterTypeDr   = obj.EHEnterTypeDr.BTCode
		Set EHEnterTypeDesc = obj.EHEnterTypeDr.BTDesc	
	}
	Set:EHIsSpecNum'=1 EHIsSpecNum=0
	Set ret=EHSpecimenNum_"^"_EHCenterNum_"^"_EHSurroundNum_"^"_EHReferToNum_"^"_EHIsSpecNum_"^"_EHEnterTypeDr_"^"_EHEnterTypeDesc
	Quit ret
}

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  获取监测项目str
/// Table：       DHCHAI.IR.EnviHyItem
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.IR.EnviHyItem).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// w ##class(DHCHAI.IR.EnviHyItem).GetExsitID("百级洁净手术室空气消毒效果监测","")
ClassMethod GetExsitID(ItemDesc, HospDr) As %String
{
	New (ItemDesc,HospDr)
	Set HospID="",return=""
	Set:$Isobject(HospDr) HospID=HospDr.%Id()
	if (HospID'=""){
		Set return=$o(^DHCHAI.IR.EnviHyItemI("IdxHospDrItemDesc",HospID," "_ItemDesc,0))
	}else{
		Set xID=""
		for {
			Set xID=$o(^DHCHAI.IR.EnviHyItemI("IndexOnItemDesc",ItemDesc,xID)) 
			Quit:(xID="")||(return'="")
			Set ItemObj=##class(DHCHAI.IR.EnviHyItem).GetObjById(xID)
			continue:'$IsObject(ItemObj)
			Set xHospID=""
			Set:$IsObject(ItemObj.EHHospDr) xHospID=ItemObj.EHHospDr.%Id()
			Set:(HospID=xHospID) return=xID
		}
	}
	Quit return
}

Storage Default
{
<Data name="EnviHyItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EHItemDesc</Value>
</Value>
<Value name="3">
<Value>EHSpecimenTypeDr</Value>
</Value>
<Value name="4">
<Value>EHNorm</Value>
</Value>
<Value name="5">
<Value>EHNormMax</Value>
</Value>
<Value name="6">
<Value>EHNormMin</Value>
</Value>
<Value name="7">
<Value>EHSpecimenNum</Value>
</Value>
<Value name="8">
<Value>EHCenterNum</Value>
</Value>
<Value name="9">
<Value>EHSurroundNum</Value>
</Value>
<Value name="10">
<Value>EHForMula</Value>
</Value>
<Value name="11">
<Value>EHFreq</Value>
</Value>
<Value name="12">
<Value>EHUom</Value>
</Value>
<Value name="13">
<Value>EHIsActive</Value>
</Value>
<Value name="14">
<Value>EHItemTypeDr</Value>
</Value>
<Value name="15">
<Value>EHEnvironmentCateDr</Value>
</Value>
<Value name="16">
<Value>EHActDate</Value>
</Value>
<Value name="17">
<Value>EHActTime</Value>
</Value>
<Value name="18">
<Value>EHActUserDr</Value>
</Value>
<Value name="19">
<Value>EHIsObjNull</Value>
</Value>
<Value name="20">
<Value>EHIsSpecNum</Value>
</Value>
<Value name="21">
<Value>EHEnterTypeDr</Value>
</Value>
<Value name="22">
<Value>EHReferToNum</Value>
</Value>
<Value name="23">
<Value>EHHospDr</Value>
</Value>
<Value name="24">
<Value>EHExtItemDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.EnviHyItemD</DataLocation>
<DefaultData>EnviHyItemDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.EnviHyItemD</IdLocation>
<IndexLocation>^DHCHAI.IR.EnviHyItemI</IndexLocation>
<StreamLocation>^DHCHAI.IR.EnviHyItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
