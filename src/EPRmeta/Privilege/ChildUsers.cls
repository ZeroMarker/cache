Class EPRmeta.Privilege.ChildUsers Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property DetailNum As %Integer;

Property UserID As %String(TRUNCATE = 1);

Property SuperiorUserID As %String(TRUNCATE = 1);

Relationship ThePowerUser As EPRmeta.Privilege.PowerUser [ Cardinality = parent, Inverse = TheChildUsers ];

Index IdxMain On (ThePowerUser, DetailNum) [ Unique ];

Index IdxSuperiorUserID On SuperiorUserID;

Index IdxUserID On UserID;

Index IdxSuperiorAndSubUserID On (SuperiorUserID, UserID);

/// d ##class(EPRmeta.Privilege.ChildUsers).UpdateOldData()
ClassMethod UpdateOldData() As %String
{
	s rowID = ""
	for {
		s rowID=$o(^DHCEPRM.PowerUserD(rowID))
		q:(rowID = "")
		
		s powerUserObj = ##class(EPRmeta.Privilege.PowerUser).%OpenId(rowID)
		s powerUserID = powerUserObj.UserID
		s childUsersIDs = powerUserObj.ChildUsers
		s:(childUsersIDs = $c(0)) childUsersIDs = ""
		continue:(childUsersIDs = "")
		for index=1:1:$l(childUsersIDs,"^")
		{
			s childUserID = $p(childUsersIDs,"^",index)
			s childUserRowID = ""
			s childUserRowID = $o(^EPRmeta.Privilege.ChildUsersI("IdxSuperiorAndSubUserID"," "_powerUserID," "_childUserID,childUserRowID))
			//b "s"
			if (childUserRowID = "")
			{
				s childUsersObj = ##Class(EPRmeta.Privilege.ChildUsers).%New()
				s childUsersObj.DetailNum = powerUserObj.TheChildUsers.Count() + 1
				s childUsersObj.ThePowerUser = powerUserObj
				s childUsersObj.UserID = childUserID
				s childUsersObj.SuperiorUserID = powerUserID
			
				s sc = childUsersObj.%Save()
				if ($$$ISOK(sc))
				{
					w !,childUsersObj.%Id()
				}
				else
				{
					w "error"
				}
			}
		}
	}
}

Storage Default
{
<Data name="ChildUsersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Remark</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>DetailNum</Value>
</Value>
<Value name="5">
<Value>SuperiorUserID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("TheChildUsers")</DataLocation>
<DefaultData>ChildUsersDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRmeta.Privilege.PowerUserC("TheChildUsers")</IdLocation>
<IndexLocation>^EPRmeta.Privilege.ChildUsersI</IndexLocation>
<StreamLocation>^EPRmeta.Privilege.ChildUsersS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
