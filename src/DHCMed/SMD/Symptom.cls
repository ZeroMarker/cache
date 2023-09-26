/// 精神症状字典维护
Class DHCMed.SMD.Symptom Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// Code
Property MSCode As %String;

/// 描述
Property MSDesc As %String;

/// 症状归类("SMDSymptom")
Property MSCateDr As DHCMed.SS.Dictionary;

/// 是否有效
Property MSIsActive As %Boolean;

/// 备注
Property MSResume As %String;

/// 代码索引
Index IndexCateCode On (MSCateDr, MSCode) [ Unique ];

/// Creator     : zhouruimeng
/// CreatDate   : 2015-01-05
/// Description : 取精神症状字典
/// Table       : DHCMed.SMD.Symptom
/// Input       : ID
/// Return      : Object
/// w ##class(DHCMed.SMD.Symptom).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMed.SMD.Symptom
{
	New (aID)
	Quit:'##class(DHCMed.SMD.Symptom).%ExistsId(aID) ""
	Set obj=##class(DHCMed.SMD.Symptom).%OpenId(aID)
	Do:$IsObject(obj) obj.%Close()
	Quit obj
}

/// Creator     : zhufei
/// CreatDate   : 2015-01-07
/// Description : 根据类别取精神症状字典串
/// Table       : DHCMed.SMD.Symptom
/// Input       : CateID : 类别代码
/// Return      : String
/// w ##class(DHCMed.SMD.Symptom).GetStringByCat("4755")
ClassMethod GetStringByCat(aCateID As %String) As %String
{
	New (aCateID)
	Set return=""
	Quit:aCateID="" return
	
	Set xCode=""
	For {
		Set xCode=$o(^DHCMed.SMD.SymptomI("IndexCateCode",aCateID,xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCMed.SMD.SymptomI("IndexCateCode",aCateID,xCode,xID))
			Quit:xID=""
			
			Set obj=##class(DHCMed.SMD.Symptom).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.MSIsActive'=1
			Set:return'="" return=return_$c(1)
			Set return=return_obj.%Id()
			Set return=return_$c(2)_obj.MSDesc
		}
	}
	
	Quit return
}

/// Creator     : zhouruimeng
/// CreatDate   : 2015-01-05
/// Description : 更新精神症状字典
/// Table       : DHCMed.SMD.Symptom
/// Input       : InputStr; Separate:分隔符
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.SMD.Symptom).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String) As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:(aInputStr="")||(aSeparete="") return
	
	Set ID		= $p(aInputStr,aSeparete,1)
	Set Code	= $p(aInputStr,aSeparete,2)
	Set Desc	= $p(aInputStr,aSeparete,3)
	Set MSCateDr= $p(aInputStr,aSeparete,4)
	Set IsActive= $p(aInputStr,aSeparete,5)
	Set Resume	= $p(aInputStr,aSeparete,6)
	
	Quit:(Code="")||(Desc="")||(MSCateDr="") return
	Set flgCode=..CheckCode(MSCateDr,Code)
	Quit:(ID="")&&(flgCode>0) -2
	//update by pylian 20150616 110374 修改精神症状字典-代码重复报错“SyntaxError: 无效字符”
	Set objMSCate=##class(DHCMed.SS.Dictionary).GetObjById(MSCateDr)
	Quit:'$IsObject(objMSCate) return
	
	//Set tID = $o(^DHCMed.SMD.SymptomI("IndexCateCode",$ZCVT(MSCateDr,"U")," "_$ZCVT(Code,"U"),0))
	//Quit:((ID="")&&(tID'="")) -2
	
	If (ID="") {
		Set obj=##class(DHCMed.SMD.Symptom).%New()
	} Else {
		Set obj=##class(DHCMed.SMD.Symptom).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.MSCode		= Code
	Set obj.MSDesc		= Desc
	Set obj.MSCateDr	= objMSCate
	Set obj.MSIsActive  = IsActive
	Set obj.MSResume    = Resume
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator     : zhouruimeng
/// CreatDate   : 2015-01-05
/// Description : 删除精神症状字典
/// Table       : DHCMed.SMD.Symptom
/// Input       : ID
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.SMD.Symptom).DeleteById("")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMed.SMD.Symptom")
	Quit:Flg'=1 -777
	Set sc=##class(DHCMed.SMD.Symptom).%DeleteId(+aID)
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator     : zhouruimeng
/// CreatDate   : 2015-01-05
/// Description : 检查精神症状字典代码是否重复
/// Table       : DHCMed.SMD.Symptom
/// Input       : Code
/// Return      : return>0:重复; return<=0:不重复
/// w ##class(DHCMed.SMD.Symptom).CheckCode("8296","094003")
ClassMethod CheckCode(aCateID As %String, aCode As %String) As %String
{
	New (aCateID,aCode)
	Set return=+$o(^DHCMed.SMD.SymptomI("IndexCateCode",$ZCVT(aCateID,"U")," "_$ZCVT(aCode,"U"),""))
	//update by pylian 20150616 110374 修改精神症状字典-代码重复报错“SyntaxError: 无效字符”
	Quit return
}

/// Creator		: zhouruimeng
/// CteatData	: 2015-01-06
/// Description : 查询精神症状字典 
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.SMD.Symptom","QryMentalSym","","","")
Query QryMentalSym(aCode As %String, aDesc As %String, aCateID As %String) As %Query(ROWSPEC = "RowID:%String,Code:%String,Desc:%String,CateID:%String,CateDesc:%String,IsActive:%String,Resume:%String")
{
}

ClassMethod QryMentalSymExecute(ByRef qHandle As %Binary, aCode As %String, aDesc As %String, aCateID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aCode'="" aCode = " "_$zcvt(aCode,"U")
	Set:aCateID'="" aCateID = $zcvt(aCateID,"U")
	
	Set xCateID = ""
	For {
		Set xCateID = $o(^DHCMed.SMD.SymptomI("IndexCateCode",xCateID))
		Quit:xCateID=""
		Set objDic = ##class(DHCMed.SS.Dictionary).GetObjById(xCateID)
		Continue:'$IsObject(objDic)	
		Continue:(aCateID'="")&&(xCateID'=aCateID)
		
		Set xCode = ""
		For {
			Set xCode = $o(^DHCMed.SMD.SymptomI("IndexCateCode",xCateID,xCode))
			Quit:xCode=""
			Continue:(aCode'="")&&(xCode'=aCode)
			
			Set RowID = ""
			For {
				Set RowID = $o(^DHCMed.SMD.SymptomI("IndexCateCode",xCateID,xCode,RowID))	
				Quit:RowID=""
				
				Set objMentalSym = ..GetObjById(RowID)
				Continue:'$IsObject(objMentalSym)
				Continue:objMentalSym.MSDesc'[aDesc
				
				Set Code    = objMentalSym.MSCode
				Set Desc    = objMentalSym.MSDesc
				Set CateID  = xCateID
				Set CateDesc= objDic.Description
				Set IsActive= objMentalSym.MSIsActive
				Set IsActive= $s(IsActive=1:"是",1:"否")
				Set Resume  = objMentalSym.MSResume
				
				Set data=$lb(RowID,Code,Desc,CateID,CateDesc,IsActive,Resume)
				Set ^CacheTemp(repid,ind)=data
				Set ind=ind+1	
			}
		}
	}					
		
	
	Quit $$$OK
}

ClassMethod QryMentalSymClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMentalSymExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMentalSymFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMentalSymExecute ]
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

/// Creator     : zhouruimeng
/// CreatDate   : 2015-01-05
/// Description : 导入精神症状字典
/// Table       : DHCMed.SMD.Symptom
/// Input       : InputStr
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.SMD.Symptom).ImportMsDic("")
ClassMethod ImportMsDic(aInputStr As %String)
{
	New (aInputStr)
	
	Set return = ""
	Quit:aInputStr="" return
	
	Set ID	 = $p(aInputStr,"^",1)
	Set Code = $p(aInputStr,"^",2)
	Set Desc = $p(aInputStr,"^",3)
	Set MsCateDesc 	= $p(aInputStr,"^",4)
	Set IsActive 	= $p(aInputStr,"^",5)
	Set Resume 		= $p(aInputStr,"^",6)
	
	Quit:(Code="")||(MsCateDesc="") return
	
	Set MsCateID = $o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," SMDSYMPTOM"," "_$ZCVT(MsCateDesc,"U"),0))
	Set InputStr = ID_"^"_Code_"^"_Desc_"^"_MsCateID_"^"_IsActive_"^"_Resume
	Set return = ..Update(InputStr,"^")
	
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MSCode</Value>
</Value>
<Value name="3">
<Value>MSDesc</Value>
</Value>
<Value name="4">
<Value>MSCateDr</Value>
</Value>
<Value name="5">
<Value>MSIsActive</Value>
</Value>
<Value name="6">
<Value>MSResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SMD.SymptomD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SMD.SymptomD</IdLocation>
<IndexLocation>^DHCMed.SMD.SymptomI</IndexLocation>
<StreamLocation>^DHCMed.SMD.SymptomS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
