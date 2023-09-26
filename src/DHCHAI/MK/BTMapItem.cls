/// 名称: DHCHAI.MK.BTMapItem（对应原有类：DHCMed.SS.Dictionary）
/// 描述: 医政管理基础字典表
/// 编写者：wuqk
/// 编写日期: 2010-04-06
Class DHCHAI.MK.BTMapItem Extends %Persistent [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// Code 代码
Property Code As %Library.String(TRUNCATE = 1);

/// Desc 描述
Property Description As %Library.String(TRUNCATE = 1);

/// Type 类型
Property Type As %Library.String(TRUNCATE = 1);

/// HospitalDr 医院 指向 CT_Hospital
Property HospitalDr As %Integer;

/// Active 是否有效，活动
Property Active As %Boolean;

/// DateFrom 起始日期
Property DateFrom As %Library.Date;

/// DateTo  结束日期
Property DateTo As %Library.Date;

/// StrA  备用字段1
Property StrA As %Library.String(TRUNCATE = 1);

/// StrB  备用字段2
Property StrB As %Library.String(TRUNCATE = 1);

/// StrC  备用字段3
Property StrC As %Library.String(TRUNCATE = 1);

/// StrD  备用字段4
Property StrD As %Library.String(TRUNCATE = 1);

/// 产品代码
/// Add By LiYang 2011-05-28
Property ProductCode As %String(TRUNCATE = 1);

Index ProductCodeIndex On (ProductCode, Type);

/// Index 
Index IdxofType On Type;

Index IdxofTypeCode On (Code, Type) [ Unique ];

/// 以类型、代码为索引,生成索引中的数据系统自动转化为Type全大写,Code全大写
Index IndexTypeCode On (Type, Code);

/// 以类型、描述为索引
Index IndexTypeDesc On (Type, Description);

/// Creator：     wuwj
/// CreatDate：   2010-04-14
/// Description:  将对象格式化为字符串
/// Table：       DHCHAI.MK.BTMapItem
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:Code 3:Description 4:Type 5:HospitalDr 6:Active 7:DateFrom 8:DateTo
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete="^"
		} 
	set return=..%Id()_separete
	set return=return_..Code_separete
	set return=return_..Description_separete
	set return=return_..Type_separete
	set return=return_..HospitalDr_separete
	set return=return_..Active_separete
    set DateFrom=""
    set DateTo=""
    set:+..DateFrom'=0 DateFrom=$zd(..DateFrom,3)
	set:+..DateTo'=0 DateTo=$zd(..DateTo,3)
	set return=return_DateFrom_separete
	set return=return_DateTo_separete
	set return=return_..ProductCode_separete
	quit return
}

/// Creator：     wuwj
/// CreatDate：   2010-04-14
/// Description:  根据ID取配置信息
/// Table：       DHCHAI.MK.BTMapItem
/// Input：       ID:    DHCHAI.MK.BTMapItem.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCHAI.MK.BTMapItem).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.MK.BTMapItem
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCHAI.MK.BTMapItem).%ExistsId(+id) return
	set obj=##Class(DHCHAI.MK.BTMapItem).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     wuwj
/// CreatDate：   2010-04-14
/// Description:  根据ID取配置信息
/// Table：       DHCHAI.MK.BTMapItem
/// Input：       ID:    DHCHAI.MK.BTMapItem.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCHAI.MK.BTMapItem).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     wuwj
/// CreatDate：   2010-04-14
/// Description:  更新Menu
/// Table：       DHCHAI.MK.BTMapItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:Code 3:Description 4:Type 5:HospitalDr 6:Active 7:DateFrom 8:DateTo 9:ProductCode
/// w ##class(DHCHAI.MK.BTMapItem).Update("^EpdemicType^传染病类别^SYS^^1^^^^EPD","")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	New (InStr,separete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(separete)="" separete="^"
	Set ID=$p(InStr,separete,1)
	Set Code=$p(InStr,separete,2)
	Set Desc=$p(InStr,separete,3)
	Set TypeCode=$p(InStr,separete,4)
	
	//特殊处理,主要是针对重复导数据问题
	Set tID=$o(^DHCHAI.MK.BTMapItemI("IndexTypeCode"," "_$ZCVT(TypeCode,"U")," "_$ZCVT(Code,"U"),0))
	Quit:((ID="")&&(tID'="")) -2 //Add By LiYang 2014-10-31 FixBug:3808 医院感染管理-全院综合性监测-基础数据维护-基础字典-增加一条与原记录代码相同的记录，新记录覆盖原记录
	
	If ID="" {
		Set obj=##class(DHCHAI.MK.BTMapItem).%New()
	}Else{
		Set obj=##class(DHCHAI.MK.BTMapItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Code=Code
	Set obj.Description=Desc
	Set obj.Type=TypeCode
	Set obj.HospitalDr=+$p(InStr,separete,5)
	Set obj.Active=$p(InStr,separete,6)
	Set DateFrom=$p(InStr,separete,7)
	Set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	Set:DateFrom["/" DateFrom=$zdh(DateFrom,1)
	Set obj.DateFrom=DateFrom
	Set DateTo=$p(InStr,separete,8)
	Set:DateTo["-" DateTo=$zdh(DateTo,3)
	Set:DateTo["/" DateTo=$zdh(DateTo,1)
	Set obj.DateTo=DateTo
	Set obj.ProductCode=$p(InStr,separete,9)
	Set obj.StrA=$p(InStr,separete,10)
	Set obj.StrB=$p(InStr,separete,11)
	Set obj.StrC=$p(InStr,separete,12)
	Set obj.StrD=$p(InStr,separete,13)
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

/// Creator：     wuwj
/// CreatDate：   2010-04-14
/// Description:  删除配置
/// Table：       DHCHAI.MK.BTMapItem
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCHAI.MK.BTMapItem).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Creator:      PanLei
/// CreatDate:    2013-09-13
/// Description:  根据基础字典类别,基础字典项目代码获取基础字典记录
/// Table：       DHCHAI.MK.BTMapItem
/// Input：       argType:基础字典类别
///               argCode:基础字典项目代码
///               argIsActive:是否有效,0-无效,1-有效
/// Return：      返回obj
/// W ##class(DHCHAI.MK.BTMapItem).GetByTypeCode("NINFInfReportType","COMP","1")
/// W ##class(DHCHAI.MK.BTMapItem).GetByTypeCode("NINFAimMDRInvalidPy","11","1")
ClassMethod GetByTypeCode(argType As %String, argCode As %String, argIsActive As %String) As DHCHAI.MK.BTMapItem
{
	New (argType,argCode,argIsActive)
	Set return = ""
	Quit:(argType="")||(argCode="") return
	
	Set argType = $ZCVT(argType,"U")
	Set argCode = $ZCVT(argCode,"U")
	Quit:'$d(^DHCHAI.MK.BTMapItemI("IndexTypeCode"," "_argType," "_argCode)) return
	
	Set ID = ""
	For {
		Set ID = $o(^DHCHAI.MK.BTMapItemI("IndexTypeCode"," "_argType," "_argCode,ID))
		Quit:ID=""
		
		Set objDic = ##class(DHCHAI.MK.BTMapItem).%OpenId(ID)
		Continue:'$IsObject(objDic)
		
		Do:objDic'="" objDic.%Close()
		Set IsActive = objDic.Active
		Continue:(argIsActive'="")&&(argIsActive'=IsActive)
		
		Set return = objDic
	}
	Quit return
}

/// 通过类别查询字典项目
/// Add By LiYang 2010-4-27
/// do ##class(%ResultSet).RunQuery("DHCHAI.MK.BTMapItem","QueryByType","NINFEnviHyReportStatus","1")
Query QueryByType(aType As %String, aIsActive As %String, aAddItem As %String = "") As %Query(ROWSPEC = "RowID:%String,Code:%String,Description:%String,Type:%String,Active:%String,HispsDescs:%String,DateFrom:%String,DateTo:%String,HospDr:%String") [ SqlProc ]
{
}

ClassMethod QueryByTypeExecute(ByRef qHandle As %Binary, aType As %String, aIsActive As %String, aAddItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	If aAddItem'="" {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemCode,addItemDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
 	Set aType=$ZCVT($g(aType),"U")
 	Set RowID=0
 	For {
	 	Set RowID=$o(^DHCHAI.MK.BTMapItemI("IdxofType"," "_aType,RowID))
	 	Quit:RowID=""
	 	Set objDic=##class(DHCHAI.MK.BTMapItem).%OpenId(RowID)
		If $IsObject(objDic){
		 	Set Code=objDic.Code
			Set Description=objDic.Description
			Set Type=objDic.Type
			Continue:(aType'="")&&(aType'=$ZCVT($g(Type),"U"))
			Set Active=objDic.Active
			Continue:((aIsActive'="")&&(aIsActive'="-1"))&&(aIsActive'=Active)
			If (Active="1"){
				Set Active="Yes"
			}Else{
			  	Set Active="No"
			}
			Set HospitalDr=objDic.HospitalDr
			Set HispsDescs=$p($g(^CT("HOSP",+HospitalDr)),"^",2)
			Set DateFrom=objDic.DateFrom
			Set DateTo=objDic.DateTo
			If (DateFrom'=""){
				Set DateFrom=$zd(DateFrom,1)
			}
			If (DateTo'=""){
		    	Set DateTo=$zd(DateTo,1)
			}
			
			set Data=$lb(RowID,Code,Description,Type,Active,HispsDescs,DateFrom,DateTo,HospitalDr)
	        Set ^CacheTemp(repid,ind)=Data
	        Set ind=ind+1
		}
		If objDic'="" Do objDic.%Close()
	}
	
	Quit $$$OK
}

ClassMethod QueryByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByTypeExecute ]
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

ClassMethod DeleteDictionarys(aTypeCode As %String) As %String
{
	New (aTypeCode)
	Set return=-1
	Quit:aTypeCode="" return
	
	Set $ZT="DeleteDictionarysErr"
	
	Set DicID=0
	For {
		Set DicID=$o(^DHCHAI.MK.BTMapItemI("IdxofType"," "_$ZCVT(aTypeCode,"U"),DicID))
		Quit:DicID=""
		Set flg=..DeleteById(DicID)
	}
	
	Set DicID=$o(^DHCHAI.MK.BTMapItemI("IndexTypeCode"," SYS"," "_$ZCVT(aTypeCode,"U"),0))
	If DicID'="" {
		Set flg=..DeleteById(DicID)
	}
	
	Set return=1
	Quit return
	
DeleteDictionarysErr
	Write "Error:"_$ZError,!
	Quit -999
}

/// Creator：     jiangpengpeng
/// CreatDate：   2014-11-06
/// Description:  更新时检测代码重复问题
/// Table：       DHCHAI.MK.BTMapItem
/// Input：       aTypeCode,aCode
/// Return：      重复1，不重复0
/// w ##class(DHCHAI.MK.BTMapItem).CheckCode()
ClassMethod CheckCode(aTypeCode As %String, aCode As %String) As %String
{
	 
	New (aTypeCode,aCode)
	Set return=0
	Quit:(aTypeCode="")||(aCode="") return
	
	Set ID=$o(^DHCHAI.MK.BTMapItemI("IndexTypeCode"," "_$ZCVT(aTypeCode,"U")," "_$ZCVT(aCode,"U"),0))
	Set:ID>0 return=1
	Quit return
}

Storage Default
{
<Data name="DictionaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Active</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>DateFrom</Value>
</Value>
<Value name="6">
<Value>DateTo</Value>
</Value>
<Value name="7">
<Value>HospitalDr</Value>
</Value>
<Value name="8">
<Value>StrA</Value>
</Value>
<Value name="9">
<Value>StrB</Value>
</Value>
<Value name="10">
<Value>StrC</Value>
</Value>
<Value name="11">
<Value>StrD</Value>
</Value>
<Value name="12">
<Value>Type</Value>
</Value>
<Value name="13">
<Value>ProductCode</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.MK.BTMapItemD</DataLocation>
<DefaultData>DictionaryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCHAI.MK.BTMapItemD</IdLocation>
<IndexLocation>^DHCHAI.MK.BTMapItemI</IndexLocation>
<StreamLocation>^DHCHAI.MK.BTMapItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
