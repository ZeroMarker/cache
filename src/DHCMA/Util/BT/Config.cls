/// 名称: DHCMA.Util.BT.Config
/// 描述: 系统参数表
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.BT.Config Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 描述
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 配置值
Property BTValue As %String(MAXLEN = 500, TRUNCATE = 1);

/// 医院（指向DHCMA.Util.EP.Hospital.OID）
Property BTHospID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 产品线
Property BTProductDr As DHCMA.Util.BT.Product;

/// 有效标志
Property BTIsActive As %Boolean [ Required ];

/// 备注
Property BTComments As %String(MAXLEN = 100, TRUNCATE = 1);

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 代码+医院 索引
Index IdxofCode On (BTCode, BTHospID) [ Unique ];

Index IdxofProduct On (BTProductDr, BTHospID);

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据ID取系统参数信息
/// Table：       DHCMA.Util.BT.Config
/// Input：       aId : DHCMA.Util.BT.Config.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.BT.Config).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.BT.Config
{
	New (aId)
	Quit:'##class(DHCMA.Util.BT.Config).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.Util.BT.Config).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据Code取系统参数信息
/// Table：       DHCMA.Util.BT.Config
/// Input：       aCode : DHCMA.Util.BT.Config.Code
/// Return：      返回obj
/// w ##class(DHCMA.Util.BT.Config).GetValueByCode("HISIOEmrHDSDCode")
ClassMethod GetValueByCode(aCode As %String, aHospID As %String = "") As %String
{
	New (aCode,aHospID,%session)
	Set return=""
	Quit:(aCode="") return
	
	Set:(aHospID="")&&($d(%session)) aHospID=$g(%session.Data("LOGON.HOSPID"))
	If (aHospID'="")&&(aHospID'["!!"){
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aHospID=aHospID_"!!"_SYSDr	
	}
	
	If $d(^DHCMA.Util.BT.ConfigI("IdxofCode"," "_$zcvt(aCode,"U")," "_$zcvt(aHospID,"U"))) {
		Set ID=$o(^DHCMA.Util.BT.ConfigI("IdxofCode"," "_$zcvt(aCode,"U")," "_$zcvt(aHospID,"U"),0))
	} Else {
		Set xHospID=$o(^DHCMA.Util.BT.ConfigI("IdxofCode"," "_$zcvt(aCode,"U"),""))
		Quit:xHospID="" return
		Set ID=$o(^DHCMA.Util.BT.ConfigI("IdxofCode"," "_$zcvt(aCode,"U"),xHospID,0))
	}
	Quit:ID="" return
	Set obj=..GetObjById(ID)
	Quit:'$IsObject(obj) return
	Quit:obj.BTIsActive'=1 return //无效配置取值为空
	Set return=obj.BTValue
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  更新系统参数信息
/// Table：       DHCMA.Util.BT.Config
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.Util.BT.Config).Update("3^12^21^二恶烷若2^2!!2^1^1^9!!2^耳闻","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set Value    = $p(aInputStr,aSeparete,4)
	Set HospID    = $p(aInputStr,aSeparete,5)
	Set ProductID= $p(aInputStr,aSeparete,6)
	Set IsActive = $p(aInputStr,aSeparete,7)
	Set ActUserID = $p(aInputStr,aSeparete,8)
	Set Comments = $p(aInputStr,aSeparete,9)
	Set ActDate = +$H
	Set ActTime = $p($h,",",2)
	Quit:(Code="")||(Desc="") return
	
	Set objProduct=##class(DHCMA.Util.BT.Product).GetObjById(ProductID)
	Quit:'$IsObject(objProduct) return
	//字典类型代码必须与产品代码匹配
	Set ProCode=objProduct.ProCode
	Quit:$e(Code,1,$l(ProCode))'=ProCode return
	
	Set tID=$o(^DHCMA.Util.BT.ConfigI("IdxofCode"," "_$zcvt(Code,"U")," "_HospID,0))
	Set:ID="" ID=tID
	Quit:(tID'="")&&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCMA.Util.BT.Config).%New()
	}Else{
		Set obj=##class(DHCMA.Util.BT.Config).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode         = Code
	Set obj.BTDesc         = Desc
	Set obj.BTValue        = Value
	Set obj.BTHospID       = HospID
	Set obj.BTProductDr    = objProduct
	Set obj.BTIsActive     = IsActive
	Set obj.BTActDate      = ActDate
	Set obj.BTActTime      = ActTime
	Set obj.BTActUserID    = ActUserID
	Set obj.BTComments	   = Comments
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
		
		//系统代码为SYS同步到DHCMed.SS.Config中一份，以SS或SS-开头
		If (ProCode="SYS") {
			Set MedCode=$e(Code,4,$l(Code))
			Set ProductID=""
			If ProCode'="" {
				Set ProCode=$ZConvert(ProCode,"T")
				Set ProductID=$o(^DHCMed.SS.ProductsI("ProCodeIndex"," "_ProCode,0))
			}
			Quit:ProductID="" return
			
			Set ConfigID = ""
			Set ConfigRowID = ""
			Set Keys="SS-"_MedCode
			If $d(^DHCMed.SS.ConfigI("IndexKeyHosp"," "_$ZConvert(Keys,"T"))) {
				Set ConfigRowID=$o(^DHCMed.SS.ConfigI("IndexKeyHosp"," "_$ZConvert(Keys,"T"),0,0))
				Set ConfigID=ConfigRowID
			}
			Set:ConfigRowID="" Keys="SS"_MedCode
			Set ConfigRowID=0
			For {
				Set ConfigRowID=$o(^DHCMed.SS.ConfigI("IndexKeyHosp"," "_$ZConvert(Keys,"T"),0,ConfigRowID))
				Quit:ConfigRowID=""
				Set objConfig=##class(DHCMed.SS.Config).GetObjById(ConfigRowID)
				Continue:'$IsObject(objConfig)
				Continue:objConfig.ProductDr'=ProductID
			 	Set ConfigID=ConfigRowID
			}
			Set InputStrConf=ConfigID
			Set InputStrConf=InputStrConf_aSeparete_Keys
			Set InputStrConf=InputStrConf_aSeparete_Desc
			Set InputStrConf=InputStrConf_aSeparete_Value
			Set InputStrConf=InputStrConf_aSeparete_Comments
			Set InputStrConf=InputStrConf_aSeparete_ProductID
			Set InputStrConf=InputStrConf_aSeparete_"0"
			Set InputStrConf=InputStrConf_aSeparete_""
			Set return=##Class(DHCMed.SS.Config).Update(InputStrConf,aSeparete)
		}
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  删除系统参数信息
/// Table：       DHCMA.Util.BT.Config
/// Input：       aId : DHCMA.Util.BT.Config.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.Util.BT.Config).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.Util.BT.Config")
	Quit:Flg'=1 -777
	Set sc = ##class(DHCMA.Util.BT.Config).%DeleteId(aId)
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
<Data name="ConfigDefaultData">
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
<Value>BTValue</Value>
</Value>
<Value name="5">
<Value>BTHospID</Value>
</Value>
<Value name="6">
<Value>BTProductDr</Value>
</Value>
<Value name="7">
<Value>BTIsActive</Value>
</Value>
<Value name="8">
<Value>BTActDate</Value>
</Value>
<Value name="9">
<Value>BTActTime</Value>
</Value>
<Value name="10">
<Value>BTActUserID</Value>
</Value>
<Value name="11">
<Value>BTComments</Value>
</Value>
</Data>
<DataLocation>^DHCMA.Util.BT.ConfigD</DataLocation>
<DefaultData>ConfigDefaultData</DefaultData>
<IdLocation>^DHCMA.Util.BT.ConfigD</IdLocation>
<IndexLocation>^DHCMA.Util.BT.ConfigI</IndexLocation>
<StreamLocation>^DHCMA.Util.BT.ConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
