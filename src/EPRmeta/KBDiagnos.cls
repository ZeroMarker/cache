/// 知识库诊断表
Class EPRmeta.KBDiagnos Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxCTLocID On CTLocID;

Index IdxCTLocIDAndName On (CTLocID, Name);

Index IdxCTLocIDAndGroupNameAndName On (CTLocID, GroupName, Name);

/// 病种代码
Property Name As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 病种名称
Property Description As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 病种分组代码
Property GroupName As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 病种分组名称
Property GroupDescription As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// ICD诊断代码串
Property Diagnos As %String(TRUNCATE = 1);

/// CT_Loc指针
Property CTLocID As %Integer [ Required ];

/// 创建者UserID
Property UserID As %String(TRUNCATE = 1);

/// 创建时间
Property CreateDate As %Date;

/// Debug:	d ##Class(%ResultSet).RunQuery("EPRmeta.KBDiagnos","GetDiagnosByCtLocID",34)
Query GetDiagnosByCtLocID(ACtLocID As %String) As %Query(ROWSPEC = "ID,Name,Description,GroupName,GroupDescription,Diagnos,UserID,UserName,UserCreateDate")
{
}

ClassMethod GetDiagnosByCtLocIDExecute(ByRef qHandle As %Binary, ACtLocID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	s Name = ""
	
	q:($g(ACtLocID) = "") $$$OK
	
	for {
		s Name = $o(^DHCEPRM.KBDiagnosI("IdxCTLocIDAndName",$g(ACtLocID),$zcvt(Name,"U")))
		q:(Name = "")
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRM.KBDiagnosI("IdxCTLocIDAndName",$g(ACtLocID),$zcvt(Name,"U"),rowID))
			q:(rowID = "")
			s objKBDiagnos = ##Class(EPRmeta.KBDiagnos).%OpenId(rowID)
			continue:(objKBDiagnos = "")
		
			s name = objKBDiagnos.Name
			s desc = objKBDiagnos.Description
			s groupName = objKBDiagnos.GroupName
			s groupDescription = objKBDiagnos.GroupDescription
			s diagnos = objKBDiagnos.Diagnos
			s userID = objKBDiagnos.UserID
			s userName = $s(userID '= "":$p($g(^SSU("SSUSR",+userID)),"^",2),1:"")
			s createDate = $s(objKBDiagnos.CreateDate '= "":$zd(objKBDiagnos.CreateDate,3),1:"")
		
			s Data = $lb(rowID,name,desc,groupName,groupDescription,diagnos,userID,userName,createDate)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1	
		}
	}
	
	q $$$OK
}

ClassMethod GetDiagnosByCtLocIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosByCtLocIDExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetDiagnosByCtLocIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosByCtLocIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Storage Default
{
<Data name="KBDiagnosDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Diagnos</Value>
</Value>
<Value name="5">
<Value>CTLocID</Value>
</Value>
<Value name="6">
<Value>UserID</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>GroupDescription</Value>
</Value>
<Value name="9">
<Value>GroupName</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.KBDiagnosD</DataLocation>
<DefaultData>KBDiagnosDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.KBDiagnosD</IdLocation>
<IndexLocation>^DHCEPRM.KBDiagnosI</IndexLocation>
<StreamLocation>^DHCEPRM.KBDiagnosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
