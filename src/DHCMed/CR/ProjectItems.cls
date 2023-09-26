Class DHCMed.CR.ProjectItems Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.CR.Project [ Cardinality = parent, Inverse = ItemsChild, Required ];

Property ElementCode As %String(MAXLEN = 100, TRUNCATE = 0) [ Required ];

Property ElementDesc As %String(MAXLEN = 100, TRUNCATE = 0);

Property ElementIndex As %Integer;

Property UpdateDate As %Date;

Property UpdateTime As %Time;

Property UpdateUser As %String(TRUNCATE = 1);

Index IndexElDesc On (ParRef As Exact, ElementDesc As Exact);

Index IndexElCode On (ParRef As Exact, ElementCode As Exact);

Index IndexElIndex On (ParRef As Exact, ElementIndex As Exact);

/// Index IndexDesc On ElementDesc As SqlString;
ClassMethod Update(Instring As %String) As %String
{
	New (Instring)
	Set return=-1
	
	Set Parref=$p(Instring,"^",1)
	Set ChildSub=$p(Instring,"^",2)
	Set ElementCode=$p(Instring,"^",3)
	Set ElementDesc=$p(Instring,"^",4)
	Set ElementIndex=+$p(Instring,"^",5)
	Set UpdateDate=$p(Instring,"^",6)
	Set:UpdateDate["-" UpdateDate=$zdh(UpdateDate,3)
	Set:UpdateDate'="" UpdateDate=+UpdateDate
	Set:UpdateDate="" UpdateDate=+$h
	Set UpdateTime=$p(Instring,"^",7)
	Set:UpdateTime[":" UpdateTime=$zth(UpdateTime,1)
	Set:UpdateTime'="" UpdateTime=+UpdateTime
	Set:UpdateTime="" UpdateTime=$p($h,",",2)
	Set UpdateUser=$p(Instring,"^",8)
	Quit:(ElementCode="")||(ElementDesc="") return
	
	Set ID=Parref_"||"_ChildSub
	If ChildSub="" {
		Set objItems=##class(DHCMed.CR.ProjectItems).%New()
	} Else {
		Set objItems=##class(DHCMed.CR.ProjectItems).%OpenId(ID)
		Quit:objItems="" return
	}
	Set objItems.ParRef=##Class(DHCMed.CR.Project).%OpenId(Parref)
	Set objItems.ElementCode=ElementCode
    Set objItems.ElementDesc=ElementDesc
    Set objItems.ElementIndex=ElementIndex
    Set objItems.UpdateDate=UpdateDate
    Set objItems.UpdateTime=UpdateTime
    Set objItems.UpdateUser=UpdateUser
	Set sc=objItems.%Save()
	If ($$$ISERR(sc)) {
		Do $System.Status.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=objItems.%Id()
	}
	If objItems'="" Do objItems.%Close()
	
	Quit return
}

/// w ##Class(DHCMed.CR.ProjectItems).GetById(1)
ClassMethod GetById(RowId As %String) As DHCMed.CR.ProjectItems
{
	New (RowId)
	Set return=""
	Set return=##Class(DHCMed.CR.ProjectItems).%OpenId(RowId)
	If return'="" Do return.%Close()
	Quit return
}

/// w ##Class(DHCMed.CR.ProjectItems).ImportItems("01^XXX^AAA^")
ClassMethod ImportItems(argInput As %String, argSeparete As %String) As %String
{
	New (argInput,argSeparete)
	Set return=-1
	
	Set $ZT="ImportItemsErr"
	
	Set:argSeparete="" argSeparete=..#SEPARATE
	Set ProjectCode=$p(argInput,argSeparete,1)
	Set ProjectID=$o(^DHCMed.CR.ProjectI("IndexCode"," "_ProjectCode,0))
	Quit:ProjectID="" return
	
	Set ElementCode=$p(argInput,argSeparete,2)
	Set ElementDesc=$p(argInput,argSeparete,3)
	Set ElementIndex=+$p(argInput,argSeparete,4)
	Quit:(ElementCode="")||(ElementDesc="") return
	
	Set xChildSub=0,ChildSub=""
	For {
		Set xChildSub=$o(^DHCMed.CR.ProjectD(ProjectID,"Items",xChildSub))
		Quit:xChildSub=""
		Quit:ChildSub'=""
		Set objItem=..GetById(ProjectID_"||"_xChildSub)
		Continue:'$IsObject(objItem)
		Continue:ElementCode'=objItem.ElementCode
		Set ChildSub=xChildSub
	}
	
	Set InputStr=ProjectID_"^"_ChildSub_"^"_ElementCode_"^"_ElementDesc_"^"_ElementIndex_"^"_""_"^"_""_"^"_""
	Set flg=..Update(InputStr)
	Set:(+flg)>0 return=1
	
	Quit return
	
ImportItemsErr
	Set $ZT=""
	Quit -999
}

/// w ##Class(DHCMed.CR.ProjectItems).DeleteItems("001")
ClassMethod DeleteItems(argPrjCode As %String) As %String
{
	New (argPrjCode)
	Set return=0
	
	Set $ZT="DeleteItemsErr"
	Set ProjectID=$o(^DHCMed.CR.ProjectI("IndexCode"," "_argPrjCode,0))
	Quit:ProjectID="" return
	
	Kill ^DHCMed.CR.ProjectD(ProjectID,"Items")
	Kill ^DHCMed.CR.ProjectI("Items","IndexElDesc",ProjectID)
	Kill ^DHCMed.CR.ProjectI("Items","IndexElCode",ProjectID)
	Kill ^DHCMed.CR.ProjectI("Items","IndexElIndex",ProjectID)
	
	Set return=1
	Quit return
	
DeleteItemsErr
	Set $ZT=""
	Quit -999
}

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ElementCode</Value>
</Value>
<Value name="3">
<Value>ElementDesc</Value>
</Value>
<Value name="4">
<Value>ElementIndex</Value>
</Value>
<Value name="5">
<Value>UpdateDate</Value>
</Value>
<Value name="6">
<Value>UpdateTime</Value>
</Value>
<Value name="7">
<Value>UpdateUser</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Items")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Items")</IdLocation>
<IndexLocation>^DHCMed.CR.ProjectI("Items")</IndexLocation>
<StreamLocation>^DHCMed.CR.ProjectItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
