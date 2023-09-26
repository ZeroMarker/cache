Class EPRinstance.EpisodePrintRecord Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxEpisodeAndECRecordID On (EpisodeID, PrintType, ECRecordID);

Index IdxEpisodeAndPrintType On (EpisodeID, PrintType);

Property CurPageNum As %String(TRUNCATE = 1);

Property CurRowNum As %String(TRUNCATE = 1);

Property ECRecordID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property PrintType As %String(TRUNCATE = 1);

ClassMethod GetPrintRecordByEpisodeAndType(AEpisodeID As %String, APrintType As %String, AECRecordID As %String) As %String
{
 Set ReturnEPRID="" 
 set BlankEpisodeID  = " "_AEpisodeID
 Set BlankPrintType=  " "_$ZCONVERT(APrintType,"U")
 if (APrintType="Single") 
 { if $D(^DHCEPRI.EpisodePrintRecordI("IdxEpisodeAndPrintType",BlankEpisodeID,BlankPrintType))
	{	set ReturnEPRID=$O(^DHCEPRI.EpisodePrintRecordI("IdxEpisodeAndPrintType",BlankEpisodeID,BlankPrintType,"")) 
	  }
	 else
	 {	set ReturnEPRID="0" 
		 } 
	  }
 elseif (APrintType="Multiple")
 {
 if $D(^DHCEPRI.EpisodePrintRecordI("IdxEpisodeAndECRecordID",BlankEpisodeID,BlankPrintType))
 { Set BlankECRecordID=  " "_AECRecordID
	   if $D(^DHCEPRI.EpisodePrintRecordI("IdxEpisodeAndECRecordID",BlankEpisodeID,BlankPrintType,BlankECRecordID))
	   {
		 s ReturnEPRID= $O(^DHCEPRI.EpisodePrintRecordI("IdxEpisodeAndECRecordID",BlankEpisodeID,BlankPrintType,BlankECRecordID,""))  
		   }
	    else
	    { set ReturnEPRID="0"    }	  
	    }
	    else
	    { set ReturnEPRID="0"    }	  
	  }
	  Quit ReturnEPRID
}

ClassMethod GetPrintRecordByID(AEpisodeID As %String) As %String
{
 New Result
 New CountID
 &sql(SELECT Count(ID)
 into :CountID
 FROM EPRinstance.EpisodePrintRecord
 WHERE EpisodeID = :AEpisodeID)

 if (CountID=0)
 { Q "0"} 
 elseif (CountID>0)
 {
 &sql(SELECT ID
 into :Result
 FROM EPRinstance.EpisodePrintRecord
 WHERE EpisodeID = :AEpisodeID)
 
 QUIT Result
	
	}
}

ClassMethod GetByEpisodeAndPrintTplID(aEpisodeID As %String, aPrintType As %String, aPrintTplID As %String) As %String
{
	s retId = ""
	if aPrintTplID '= "" s aPrintTplID = "S"_aPrintTplID
	
	&sql(select top 1 ID into :retId from EPRinstance.EpisodePrintRecord
		where EpisodeID = :aEpisodeID and PrintType = :aPrintType and ECRecordID = :aPrintTplID)
	
	q retId
}

Storage Default
{
<Data name="EpisodePrintRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CurPageNum</Value>
</Value>
<Value name="3">
<Value>CurRowNum</Value>
</Value>
<Value name="4">
<Value>EpisodeID</Value>
</Value>
<Value name="5">
<Value>ECRecordID</Value>
</Value>
<Value name="6">
<Value>PrintType</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.EpisodePrintRecordD</DataLocation>
<DefaultData>EpisodePrintRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.EpisodePrintRecordD</IdLocation>
<IndexLocation>^DHCEPRI.EpisodePrintRecordI</IndexLocation>
<StreamLocation>^DHCEPRI.EpisodePrintRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
