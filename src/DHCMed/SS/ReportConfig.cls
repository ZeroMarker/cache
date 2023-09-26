/// 报表配置，用于润乾报表的各种配置项目存储
/// 创建者：李阳
/// 创建日期：2012-05-18
Class DHCMed.SS.ReportConfig Extends (%Persistent, DHCMed.Abstract, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 代码
Property Code As %String;

/// 描述
Property Description As %String;

Relationship ConfigItems As DHCMed.SS.ReportConfigItem [ Cardinality = children, Inverse = Parent ];

/// 类别
Property Kind As %String;

/// 使用产品   指向 DHCMed.SS.Products
Property ProductDr As %Integer;

/// 医院       指向 CT_Hospital
Property HospitalDr As %Integer;

/// 备注
Property Resume As %String(TRUNCATE = 1);

/// 主索引
Index IndexMaster On (HospitalDr, ProductDr, Kind, Code) [ Unique ];

ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.SS.ReportConfig).%New()
		} 
	else {
		set obj=##class(DHCMed.SS.ReportConfig).%OpenId(ID)
		}
	set obj.Code=$p(InStr,separete,2)
	set obj.Description=$p(InStr,separete,3)
	set obj.Kind=$p(InStr,separete,4)
	Set tmp=$p(InStr,separete,5)
	Set:tmp'=+tmp tmp=$o(^DHCMed.SS.ProductsI("ProCodeIndex"," "_tmp,""))	
	set obj.ProductDr=tmp
	set obj.HospitalDr=+$p(InStr,separete,6)
	set obj.Resume=$p(InStr,separete,7)
	
	Set:obj.Kind="" obj.Kind="_Other"
	Set:obj.ProductDr="" obj.ProductDr=0
	set:obj.HospitalDr="" obj.HospitalDr=0
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

ClassMethod GetObjById(id As %String) As DHCMed.SS.ReportConfig
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.SS.ReportConfig).%ExistsId(+id) return
	set obj=##Class(DHCMed.SS.ReportConfig).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// 查询报表配置项目
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.SS.ReportConfig","QryItems","","NINF","常见疾病","CommonDisease")
Query QryItems(HospitalID As %String, ProductCode As %String, Kind As %String, Code As %String) As %Query(ROWSPEC = "RowID:%String,代码:%String,值1:%String,值2:%String,ParentID:%String") [ SqlProc ]
{
}

ClassMethod QryItemsExecute(ByRef qHandle As %Binary, HospitalID As %String, ProductCode As %String, Kind As %String, Code As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xProID=0
 	For {
		Set xProID=$o(^DHCMed.SS.ReportConfigI("IndexMaster",+HospitalID,xProID))
		Quit:xProID=""
		
		If ProductCode'="" {
			Set objPro=##class(DHCMed.SS.Products).GetObjById(xProID)
			Continue:'$IsObject(objPro)
			Continue:objPro.ProCode'=ProductCode
		}
		
		Set xCfgID=0
		For {
			Set xCfgID=$o(^DHCMed.SS.ReportConfigI("IndexMaster",+HospitalID,xProID," "_$ZCVT(Kind,"U")," "_$ZCVT(Code,"U"),xCfgID))
			Quit:xCfgID=""
			
			Set objCfg=##class(DHCMed.SS.ReportConfig).GetObjById(xCfgID)
			Continue:'$IsObject(objCfg)
			/*For indItm=1:1:objCfg.ConfigItems.Count() {
				Set objItm=objCfg.ConfigItems.GetAt(indItm)
				Set data=$lb("")
				Set $li(data,1)=objItm.%Id()
				Set $li(data,2)=objItm.Code
				Set $li(data,3)=objItm.Value1
				Set $li(data,4)=objItm.Value2
				Set $li(data,5)=xCfgID
				Set ^CacheTemp(repid,ind)=data
				Set ind=ind+1
			}*/
			Set xCfgItemID=0
			For {
				Set xCfgItemID=$o(^DHCMed.SS.ReportConfigD(xCfgID,"ConfigItems",xCfgItemID))
				Quit:xCfgItemID=""
			
				Set ObjCfgItem=##class(DHCMed.SS.ReportConfigItem).GetObjById(xCfgID_"||"_xCfgItemID)
				Continue:'$IsObject(ObjCfgItem)
			 	Set ItemID=ObjCfgItem.%Id()
				Set Code=ObjCfgItem.Code
				Set Value1=ObjCfgItem.Value1
				Set Value2=ObjCfgItem.Value2
				Set Data=$lb(ItemID,Code,Value1,Value1,xCfgID)
			
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1		
			
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItemsExecute ]
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

/// D ##class(%Library.ResultSet).RunQuery("DHCMed.SS.ReportConfig","QryAll")
Query QryAll() As %Query(ROWSPEC = "RowID:%String,代码:%String,描述:%String,医院:%String,产品:%String,备注:%String,类别:%String") [ SqlProc ]
{
}

ClassMethod QryAllExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	Set RowID=""
 	For {
	 	Set RowID=$o(^DHCMed.SS.ReportConfigD(RowID))
	 	Quit:RowID=""
	 	Set data=$lb("")
	 	Set obj=##class(DHCMed.SS.ReportConfig).%OpenId(RowID)
	 	Do obj.%Close()
	 	Set $li(data,1)=obj.%Id()
	 	Set $li(data,2)=obj.Code
	 	Set $li(data,3)=obj.Description
	 	Set objHospital=##class(DHCMed.Base.Hospital).GetObjById(obj.HospitalDr)
	 	Set:$IsObject(objHospital)=0 objHospital=##class(DHCMed.Base.Hospital).%New()
	 	Do objHospital.%Close()
	 	Set $li(data,4)=objHospital.Descs
	 	Set objProduct=##class(DHCMed.SS.Products).GetObjById(obj.ProductDr)
	 	Set:$IsObject(objProduct)=0 objProduct=##class(DHCMed.SS.Products).%New()
	 	Do objProduct.%Close()
	 	Set $li(data,5)=objProduct.ProName	 	
	 	Set $li(data,6)=obj.Resume
	 	Set $li(data,7)=obj.Kind
	 	Set ^CacheTemp(repid,ind)=data
	 	Set ind=ind+1	
	 }	
	Quit $$$OK
}

ClassMethod QryAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAllExecute ]
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

/// w ##class(DHCMed.SS.ReportConfig).ClearData()
ClassMethod ClearData() As %String
{
	New
	Kill ^DHCMed.SS.ReportConfigD
	Kill ^DHCMed.SS.ReportConfigI
	Quit "OK"
}

Storage Default
{
<Data name="ReportConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Kind</Value>
</Value>
<Value name="5">
<Value>HospitalDr</Value>
</Value>
<Value name="6">
<Value>ProductDr</Value>
</Value>
<Value name="7">
<Value>Resume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SS.ReportConfigD</DataLocation>
<DefaultData>ReportConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SS.ReportConfigD</IdLocation>
<IndexLocation>^DHCMed.SS.ReportConfigI</IndexLocation>
<StreamLocation>^DHCMed.SS.ReportConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
