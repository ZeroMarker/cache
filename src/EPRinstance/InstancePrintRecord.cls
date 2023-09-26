Class EPRinstance.InstancePrintRecord Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxECRecordIDAndSeq On (ECRecordID, ECRSeq);

Index IdxEpisodePrintRecordID On EpisodePrintRecordID;

Index IdxInstanceDataID On InstanceDataID;

Property ContinuePrint As %Boolean;

Property CreateDate As %Date;

Property CreateTime As %Time;

Property CreateUserID As %String(TRUNCATE = 1);

/// = $P(InstanceDataID,"||",2); = 历次病历的序号/成组模板的序号/唯一模板是1
Property ECRSeq As %String(TRUNCATE = 1);

Property ECRecordID As %String(TRUNCATE = 1);

Property EndPageNum As %Integer;

Property EndRowNum As %Integer;

Property EpisodePrintRecordID As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property LastRowProperty As %String(TRUNCATE = 1);

Property PrintStatus As %String(TRUNCATE = 1);

Property PrintTemplateID As %String(TRUNCATE = 1);

Property PrintTemplateVersion As %String(TRUNCATE = 1);

Property PrintType As %String(TRUNCATE = 1);

Property StartPageNum As %Integer;

Property StartRowNum As %Integer;

Property UpdateDate As %Date;

Property UpdateTime As %Time;

Property UpdateUserID As %String(TRUNCATE = 1);

ClassMethod GetInsPtRecordByEptID(AEpisodePrintRecordID As %String) As %String
{
 New Result
 new CountID
 &sql(SELECT Count(ID)
 into :CountID
 FROM EPRinstance.InstancePrintRecord
 WHERE EpisodePrintRecordID = :AEpisodePrintRecordID )

 if (CountID=0)
 { Q "0"} 
 elseif (CountID>0)
 {
 &sql(SELECT ID
 into :Result
 FROM EPRinstance.InstancePrintRecord
 WHERE EpisodePrintRecordID = :AEpisodePrintRecordID )
 QUIT Result
	}
}

ClassMethod GetInstancePrintRecordByID(AInstanceDataID As %String, AEpisodePrintRecordID As %String) As %String
{
 New Result
 new CountID
 &sql(SELECT Count(ID)
 into :CountID
 FROM EPRinstance.InstancePrintRecord
 WHERE InstanceDataID = :AInstanceDataID
 And EpisodePrintRecordID = :AEpisodePrintRecordID )

 if (CountID=0)
 { Q ""} 
 elseif (CountID>0)
 {
 &sql(SELECT ID
 into :Result
 FROM EPRinstance.InstancePrintRecord
 WHERE InstanceDataID = :AInstanceDataID
 And EpisodePrintRecordID = :AEpisodePrintRecordID )
 QUIT Result
	
	}
}

ClassMethod GetInstancePrintRecordByPTID(APTID As %String, AEpisodePrintRecordID As %String) As %String
{
	/*
 New Result
 new CountID
 &sql(SELECT Count(ID)
 into :CountID
 FROM EPRinstance.InstancePrintRecord
 WHERE PrintTemplateID = :APTID)

 if (CountID=0)
 { Q "0"} 
 elseif (CountID>0)
 {
 &sql(SELECT ID
 into :Result
 FROM EPRinstance.InstancePrintRecord
 WHERE PrintTemplateID = :APTID)

 QUIT Result
 
	}
	*/
	s Result = ""
	&sql(SELECT ID into :Result	FROM EPRinstance.InstancePrintRecord
 		WHERE EpisodePrintRecordID = :AEpisodePrintRecordID and PrintTemplateID = :APTID)
	
	q Result
}

ClassMethod GetMaxLastInstanceRecordIDBySeq(AECRecord As %String, ASeq As %String) As %String
{
	s BlankECRecord = " "_AECRecord
	Set BlankSeq = " "_ASeq
	s IDKey=""
	if $D(^DHCEPRI.InstancePrintRecordI("IdxECRecordIDAndSeq",BlankECRecord))
 {
	  
	 if $D(^DHCEPRI.InstancePrintRecordI("IdxECRecordIDAndSeq",BlankECRecord,BlankSeq))	   
 { Set IDKey = $O(^DHCEPRI.InstancePrintRecordI("IdxECRecordIDAndSeq",BlankECRecord,BlankSeq,""))	   
	 
	}
	  }  
	 Q IDKey
}

ClassMethod GetNewInstancePrintRecordByID(AInstanceDataID As %String) As %String
{
 Set ReturnInsPRID=""
 set BlankInstanceDataID = " "_AInstanceDataID

 if $D(^DHCEPRI.InstancePrintRecordI("IdxInstanceDataID",BlankInstanceDataID))
 { 	s ReturnInsPRID  = $O(^DHCEPRI.InstancePrintRecordI("IdxInstanceDataID",BlankInstanceDataID,""))
 }
 else 
 {
 S ReturnInsPRID="0"	 
	 }	 	
 QUIT ReturnInsPRID
}

ClassMethod GetStartPageNumAndRowNum(AInstanceDataID As %String, ByRef AStartPageNum As %Integer, ByRef AStartRowNum As %Integer)
{
 s BlankECRecord = " "_$P(AInstanceDataID,"||")
 if $D(^DHCEPRI.InstancePrintRecordI("IdxECRecordIDAndSeq",BlankECRecord))
 {
 s IDKey=""
 S SeqKey = $O(^DHCEPRI.InstancePrintRecordI("IdxECRecordIDAndSeq",BlankECRecord,""))	 
 WHILE (SeqKey '="") 
 { Set IDKey = $O(^DHCEPRI.InstancePrintRecordI("IdxECRecordIDAndSeq",BlankECRecord,SeqKey,""))	   
	 set SeqKey = $O(^DHCEPRI.InstancePrintRecordI("IdxECRecordIDAndSeq",BlankECRecord,SeqKey))
	}
	if (IDKey'="")
	{
 set objInsPtRecord = ##class(EPRinstance.InstancePrintRecord).%OpenId(IDKey)		
	  if (objInsPtRecord'="")
	   { 
	     set AStartPageNum= objInsPtRecord.EndPageNum
	     s AStartRowNum = objInsPtRecord.EndRowNum+1
	   	 }
 }
	elseif (IDKey="")
	{ s AStartPageNum = 1
 S AStartRowNum  = 1	 
		}
 }
 Else
 {
 s AStartPageNum = 1
 S AStartRowNum  = 1	 
	 }
}

Storage Default
{
<Data name="InstancePrintRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ContinuePrint</Value>
</Value>
<Value name="3">
<Value>EpisodePrintRecordID</Value>
</Value>
<Value name="4">
<Value>InstanceDataID</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>CreateUserID</Value>
</Value>
<Value name="8">
<Value>EndPageNum</Value>
</Value>
<Value name="9">
<Value>EndRowNum</Value>
</Value>
<Value name="10">
<Value>PrintTemplateID</Value>
</Value>
<Value name="11">
<Value>PrintTemplateVersion</Value>
</Value>
<Value name="12">
<Value>StartPageNum</Value>
</Value>
<Value name="13">
<Value>StartRowNum</Value>
</Value>
<Value name="14">
<Value>UpdateDate</Value>
</Value>
<Value name="15">
<Value>UpdateTime</Value>
</Value>
<Value name="16">
<Value>UpdateUserID</Value>
</Value>
<Value name="17">
<Value>PrintStatus</Value>
</Value>
<Value name="18">
<Value>PrintType</Value>
</Value>
<Value name="19">
<Value>ECRSeq</Value>
</Value>
<Value name="20">
<Value>ECRecordID</Value>
</Value>
<Value name="21">
<Value>LastRowProperty</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.InstancePrintRecordD</DataLocation>
<DefaultData>InstancePrintRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.InstancePrintRecordD</IdLocation>
<IndexLocation>^DHCEPRI.InstancePrintRecordI</IndexLocation>
<StreamLocation>^DHCEPRI.InstancePrintRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
