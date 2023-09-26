/// 名称: DHCMA.CPW.SD.QCEntity
/// 描述: 特定（单）病种质量控制 病种定义
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.SD.QCEntity Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildItem As DHCMA.CPW.SD.QCEntityItem [ Cardinality = children, Inverse = Parref ];

Relationship ChildRule As DHCMA.CPW.SD.QCEntityMatchRule [ Cardinality = children, Inverse = Parref ];

Relationship ChildIndex As DHCMA.CPW.SD.QCIndex [ Cardinality = children, Inverse = Parref ];

/// 病种代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 病种名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 病种缩写
Property BTAbbrev As %String(MAXLEN = 50, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean;

/// 排序码
Property BTIndNo As %Integer;

/// 发布时间
Property BTPubdate As %String;

/// 手术关键字
Property BTOperKey As %String(MAXLEN = 500);

/// 病种上报地址
Property BTURL As %String(MAXLEN = 1000) [ Required ];

/// 病种关联科室
Property BTLocation As %List;

/// 病种参考费用
Property BTTotalFee As %Float;

/// 病种参考住院日
Property BTInDays As %Integer;

/// 当前版本
Property BTVersion As DHCMA.CPW.SD.QCEntityVersion [ Required ];

/// 病种系统
Property BTEntityCat As DHCMA.Util.BT.Dictionary;

Index IdxofCode On BTCode;

/// 病种缩写索引
Index IdxofAbb On BTAbbrev As Exact;

/// 排序码索引
Index IdxofIndNo On BTIndNo;

/// Creator：     xuwenjie
/// CreatDate：   2018-08-29
/// Description:  根据ID取质控病种信息
/// Table：       DHCMA.CPW.SD.QCEntity
/// Input：       aId : DHCMA.CPW.SD.QCEntity.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.SD.QCEntity).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.QCEntity
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.QCEntity).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.QCEntity).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     xuwenjie
/// CreatDate：   2018-08-29
/// Description:  根据Code取质控病种信息
/// Table：       DHCMA.CPW.SD.QCEntity
/// Input：       aCode : DHCMA.CPW.SD.QCEntity.BTCode
/// Return：      返回String
/// w ##class(DHCMA.CPW.SD.QCEntity).GetObjByCode("Code")
ClassMethod GetObjByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^DHCMA.CPW.SD.QCEntityI("IdxofCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     xuwenjie
/// CreatDate：   2018-08-29
/// Description:  更新质控病种信息
/// Table：       DHCMA.CPW.SD.QCEntity
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.QCEntity).Update("^WS006^膝关节置换术^Knee^7^2009^^/interface/010102/Knee/1.2/put/^^^^^V202010")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID               = $p(aInputStr,aSeparete,1)
	Set Code             = $p(aInputStr,aSeparete,2)
	Set Desc             = $p(aInputStr,aSeparete,3)
	Set Abbrev           = $p(aInputStr,aSeparete,4)
	Set IsActive         = $p(aInputStr,aSeparete,5)
	Set IndNo            = $p(aInputStr,aSeparete,6)
	Set Pubdate          = $p(aInputStr,aSeparete,7)
	Set OperKey          = $p(aInputStr,aSeparete,8)
	Set URL			 	 = $p(aInputStr,aSeparete,9)	
	Set Location	 	 = $p(aInputStr,aSeparete,10)
	Set TotalFee	 	 = $p(aInputStr,aSeparete,11)
	Set InDays	 	 	 = $p(aInputStr,aSeparete,12)
	Set EntiyCat	 	 = $p(aInputStr,aSeparete,13)
	Set Version			 = $p(aInputStr,aSeparete,14)
	Quit:(Code="")||(Desc="") return
	
	Set tID=$o(^DHCMA.CPW.SD.QCEntityI("IdxofCode"," "_$zcvt(Code,"U"),0))
	Quit:(ID'="")&(ID'=tID) -2  //如果入参ID与代码索引查找ID不一致 返回-2
	Set ID=tID
	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.QCEntity).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.QCEntity).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode        = Code
	Set obj.BTDesc        = Desc
	Set obj.BTAbbrev      = Abbrev
	Set obj.BTIsActive    = IsActive
	Set obj.BTIndNo       = IndNo
	Set obj.BTPubdate     = Pubdate
	Set obj.BTOperKey	  = OperKey
	Set obj.BTURL	  	  = URL
	Set LocOIDLB=""
	For idx=1:1:$l(Location,","){
		
		Set LocOID=$p(Location,",",idx)
		Continue:LocOID=""
		Continue:$listfind(LocOIDLB,LocOID)>0
		Set LocOIDLB=LocOIDLB_$lb(LocOID)
	}
	Set obj.BTTotalFee	  = TotalFee
	Set obj.BTInDays	  = InDays
	Set obj.BTLocation	  = LocOIDLB
	//增加病种疾病分类信息
	If (EntiyCat'="") {
		if (+EntiyCat=0){
			Set EntiyCatObj=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("SDENTITYCAT",EntiyCat)
			Set obj.BTEntityCat	  = EntiyCatObj
		}else{
			Set EntiyCatObj=##class(DHCMA.Util.BT.Dictionary).GetObjById(EntiyCat)
			Set obj.BTEntityCat	  = EntiyCatObj
		}
		
	}
	//增加病种版本信息
	If (Version'="") {
		Set vID=""
		For{
			Set vID=$o(^DHCMA.CPW.SD.QCEntityVersionI("IdxofCode",vID))
			Quit:vID=""
			Set VersionID=""
			For{
				Set VersionID=$o(^DHCMA.CPW.SD.QCEntityVersionI("IdxofCode",vID,VersionID))
				Quit:VersionID=""
				continue:Version'=VersionID
				Set Version=vID
			}
		}
		
		Set VersionObj=##class(DHCMA.CPW.SD.QCEntityVersion).GetObjByCode(Version)
		Set obj.BTVersion=VersionObj
	}
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

/// Creator：     xuwenjie
/// CreatDate：   2018-08-29
/// Description:  删除质控病种信息
/// Table：       DHCMA.CPW.SD.QCEntity
/// Input：       aId : DHCMA.CPW.SD.QCEntity.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.QCEntity).DeleteById(6)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.SD.QCEntity")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.SD.QCEntity).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="QCEntityDefaultData">
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
<Value>BTAbbrev</Value>
</Value>
<Value name="5">
<Value>BTIsActive</Value>
</Value>
<Value name="6">
<Value>BTIndNo</Value>
</Value>
<Value name="7">
<Value>BTPubdate</Value>
</Value>
<Value name="8">
<Value>BTVersion</Value>
</Value>
<Value name="9">
<Value>BTOperKey</Value>
</Value>
<Value name="10">
<Value>BTURL</Value>
</Value>
<Value name="11">
<Value>BTLocation</Value>
</Value>
<Value name="12">
<Value>BTTotalFee</Value>
</Value>
<Value name="13">
<Value>BTInDays</Value>
</Value>
<Value name="14">
<Value>BTEntityCat</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.QCEntityD</DataLocation>
<DefaultData>QCEntityDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.QCEntityD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCEntityI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCEntityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
