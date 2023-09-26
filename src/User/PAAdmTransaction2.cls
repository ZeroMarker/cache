Class User.PAAdmTransaction2 Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PA_AdmTransaction2 ]
{

Property TRANSRowId As PAAdmTransaction;

Property TRANSStartDate As %Date;

Property TRANSEndDate As %Date;

Property TRANSCTCPDR As CTCareProv;

Property TRANSCTLOCDR As CTLoc;

Property TRANSWardDR As PACWard;

Property TRANSRoomDR As PACRoom;

Property TRANSBedDR As PACBed;

Property TRANSStatusDR As PACTransfRequestStatus;

Property TRANSMain As %String(TRUNCATE = 1);

Property TRANSTransTypeDR As PACTransType;

Index TRANSStartDate On TRANSStartDate [ Type = bitmap ];

Index TRANSEndDate On TRANSEndDate [ Type = bitmap ];

Index WardStartDate On (TRANSWardDR, TRANSStartDate) [ Type = bitmap ];

Index WardEndDate On (TRANSWardDR, TRANSEndDate) [ Type = bitmap ];

Index TRANSCTCPDR On TRANSCTCPDR [ Type = bitmap ];

Index TRANSCTLOCDR On TRANSCTLOCDR [ Type = bitmap ];

Index TRANSWardDR On TRANSWardDR [ Type = bitmap ];

Index TRANSRoomDR On TRANSRoomDR [ Type = bitmap ];

Index TRANSBedDR On TRANSBedDR [ Type = bitmap ];

Index TRANSStatusDR On TRANSStatusDR [ Type = bitmap ];

Index TRANSMain On TRANSMain [ Type = bitmap ];

Index TRANSTransTypeDR On TRANSTransTypeDR [ Type = bitmap ];

Storage Default
{
<Data name="PAAdmTransaction2DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TRANSBedDR</Value>
</Value>
<Value name="3">
<Value>TRANSCTCPDR</Value>
</Value>
<Value name="4">
<Value>TRANSCTLOCDR</Value>
</Value>
<Value name="5">
<Value>TRANSEndDate</Value>
</Value>
<Value name="6">
<Value>TRANSRoomDR</Value>
</Value>
<Value name="7">
<Value>TRANSRowId</Value>
</Value>
<Value name="8">
<Value>TRANSStartDate</Value>
</Value>
<Value name="9">
<Value>TRANSStatusDR</Value>
</Value>
<Value name="10">
<Value>TRANSWardDR</Value>
</Value>
<Value name="11">
<Value>TRANSMain</Value>
</Value>
<Value name="12">
<Value>TRANSTransTypeDR</Value>
</Value>
</Data>
<DataLocation>^User.PAAdmTransaction2D</DataLocation>
<DefaultData>PAAdmTransaction2DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.PAAdmTransaction2D</IdLocation>
<IndexLocation>^User.PAAdmTransaction2I</IndexLocation>
<StreamLocation>^User.PAAdmTransaction2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index TRANSRowId On TRANSRowId;

}
