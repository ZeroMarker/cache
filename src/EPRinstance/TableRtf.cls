Class EPRinstance.TableRtf Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Rule reference
Property TableRtfDRDescription As %String(MAXLEN = 500, TRUNCATE = 1);

Property TableRtfDRContent As %GlobalCharacterStream(LOCATION = "^DHCEPRI.TableRtfS");

Property CreateDate As %Date;

Property CreateTime As %Time;

ClassMethod AddTableRtfInfos(Nameinfos As %String, TableRtfInfos As %String) As %String
{
	if (..CheckNameUnique(Nameinfos)>0)
	{
		s ID=..CheckNameID(Nameinfos)
		d ..UpdateTableRtfInfos(ID,TableRtfInfos)
		q 1
	}
	else
	{
		s objTableRtf = ##class(EPRinstance.TableRtf).%New()
		q:(objTableRtf="") "0"
			
		s now = $H
		s date = $P(now,",",1)
		s time = $P(now,",",2)
			
		Set stream = ##class(%GlobalCharacterStream).%New()
	    Do stream.Write(TableRtfInfos)        
	    Do stream.SaveStream()
			
	    s objTableRtf.TableRtfDRDescription = Nameinfos
		s objTableRtf.TableRtfDRContent =stream
	
		s objTableRtf.CreateDate = date
		s objTableRtf.CreateTime = time
			
		s status = objTableRtf.%Save()
		d stream.%Close()
		q:('$$$ISOK(status)) "0"	
		q objTableRtf.%Id()
	}
}

ClassMethod CheckNameUnique(AName As %String) As %Integer
{
 new Result
 &sql(SELECT Count(TableRtfDRDescription)
 into :Result 
 FROM EPRinstance.TableRtf
 WHERE TableRtfDRDescription = :AName)
 QUIT Result
}

ClassMethod CheckNameID(AName As %String) As %Integer
{
 new Result
 &sql(SELECT ID
 into :Result 
 FROM EPRinstance.TableRtf
 WHERE TableRtfDRDescription = :AName)
 QUIT Result
}

ClassMethod DeleteTableRtfInfos(AName As %String) As %String
{
	//q:(($d(AID) = 0)||(AID = "")) 0	
	//set objTableRtf = ##class(EPRinstance.TableRtf).%OpenId(AID)
	//Quit objTableRtf.%DeleteId(AID)
	
	 //new Result
	 &sql(delete FROM EPRinstance.TableRtf
	 WHERE TableRtfDRDescription = :AName)
	 QUIT 1
}

ClassMethod UpdateTableRtfInfos(AID As %String, TableRtf As %String) As %String
{
	
	q:(($d(AID) = 0)||(AID = "")) 0	
	Set stream = ##class(%GlobalCharacterStream).%New()
    Do stream.Write(TableRtf)        
    Do stream.SaveStream()
    
	set objTableRtf = ##class(EPRinstance.TableRtf).%OpenId(AID)	
	d objTableRtf.TableRtfDRContent.CopyFrom(stream)
	d objTableRtf.TableRtfDRContent.SaveStream()
	d stream.%Close()
	d objTableRtf.%Close()	
	q 1
}

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "TableRtfDRDescription,ID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_TableRtf_SELECTALL, SqlProc ]
{
 SELECT TableRtfDRDescription,ID FROM EPRinstance.TableRtf
}

ClassMethod GetTableRtfStramToString(ID As %String) As %String
{
	s TmpStrText="",StrText=""
    s ID=$g(ID)
    b
	Set stream = ##class(%GlobalCharacterStream).%New()	
	&sql(select TableRtfDRContent into :fdata from EPRinstance.TableRtf where ID=:ID)	
	q:SQLCODE stream
	s fstream=##class(%SerialStream).%Open(fdata)
	d fstream.Rewind()	
	d stream.CopyFrom(fstream)	
	d fstream.%Close()
	d stream.Rewind()	
	if stream.SizeGet()>0
	{	
	    d stream.Rewind()
	    While (stream.AtEnd = 0) 
		{
			Set len = stream.SizeGet()
			set TmpStrText= stream.Read(len)
			set StrText= StrText_TmpStrText  
		}
	}
	q StrText
}

Storage Default
{
<Data name="TableRtfDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CreateDate</Value>
</Value>
<Value name="3">
<Value>CreateTime</Value>
</Value>
<Value name="4">
<Value>TableRtfDR</Value>
</Value>
<Value name="5">
<Value>TableRtfDRContent</Value>
</Value>
<Value name="6">
<Value>TableRtfDRDescription</Value>
</Value>
</Data>
<DataLocation>^EPRinstance.TableRtfD</DataLocation>
<DefaultData>TableRtfDefaultData</DefaultData>
<IdLocation>^EPRinstance.TableRtfD</IdLocation>
<IndexLocation>^EPRinstance.TableRtfI</IndexLocation>
<StreamLocation>^EPRinstance.TableRtfS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
