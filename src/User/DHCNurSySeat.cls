Class User.DHCNurSySeat Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property SyLoc As %String(TRUNCATE = 1);

Property SySeatCode As %String(TRUNCATE = 1);

Property SySeatDes As %String(TRUNCATE = 1);

/// width,height
Property SySeatSize As %String(TRUNCATE = 1);

/// x,y
Property SySeatLocation As %String(TRUNCATE = 1);

Property SySeatFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

Index loc On SyLoc;

Index seatCode On SySeatCode [ Unique ];

/// add by linyuxu 20150830
/// parameter：LocId:科室ID，x:起始左上横坐标，y:起始左上纵坐标,width:每个座位的宽度，height:每个座位的高度
///            hint:每个座位的间隔，columnCount:定义座位显示列数，seatCount:生成座位的数量，seatDesc:每个座位名称的前面相同描述
///            startCode:生成的座位的起始代码，seatZone:座位的区域
/// d ##class(User.DHCNurSySeat).generatorSeat("445",4,4,100,50,5,10,56,"小儿区",1)
ClassMethod generatorSeat(LocId, x, y, width, height, hint, columnCount, seatCount, seatDesc, startCode)
{
	f i=1:1:seatCount
	{
		s SeatObj=##class(User.DHCNurSySeat).%New()
		s SeatObj.SyLoc=LocId
		s SeatObj.SySeatCode=seatDesc_"-"_(+i+startCode-1)
		s SeatObj.SySeatDes=seatDesc_"-"_(+i+startCode-1)
		s SeatObj.SySeatSize=width_","_height
		s w=((i-1)#columnCount)*width
		s hix=((i-1)#columnCount)*hint
		s PointX=+x+w+hix
		i (i#columnCount=0){
			s h=((i\columnCount)-1)*height
			s hiy=((i\columnCount)-1)*hint
		}else{
			s h=(i\columnCount)*height
			s hiy=(i\columnCount)*hint
		}
		s PointY=+y+h+hiy
		s SeatObj.SySeatLocation=PointX_","_PointY
		s SeatObj.SySeatFlag="Y"
		d SeatObj.%Save()
		d SeatObj.%Close()

	}
	q 0
}

/// ##class(User.DHCNurSySeat).save("66^7^nfm-2^nfm-2^100,100^5,5^Y")
ClassMethod save(parr As %String) As %String
{
	S ^TEMPSC("save")=parr
	s id=$P(parr,"^")
	s SyLoc=$P(parr,"^",2)
	s SySeatCode=$P(parr,"^",3)
	s SySeatDes=$P(parr,"^",4)
	s size=$P(parr,"^",5)
	s point=$P(parr,"^",6)
	s flag=$P(parr,"^",7)
	if id="" s a=##class(User.DHCNurSySeat).%New()
	e  s a=##class(User.DHCNurSySeat).%OpenId(id)
	if id="" s a.SyLoc=SyLoc
	s a.SySeatCode=SySeatCode
	s a.SySeatDes=SySeatDes
	s a.SySeatSize=size
	s a.SySeatLocation=point
	s a.SySeatFlag=flag
	s sc=a.%Save()
	s errText=""
	if $$$ISERR(sc) d 
	.s errText=$system.Status.GetErrorText(sc)
	.;d $system.Status.DisplayError(sc)
	i errText["键不唯一" q "座位代码重复,保存失败!"
	q 0
}

ClassMethod SaveLocation(parr) As %String
{
   s id=$P(parr,"^",1)
   s point=$P(parr,"^",2)
   s a=##class(User.DHCNurSySeat).%OpenId(id)
   s a.SySeatLocation=point
   d a.%Save()
   q 0
}

Storage Default
{
<Data name="DHCNurSySeatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SyLoc</Value>
</Value>
<Value name="3">
<Value>SySeatCode</Value>
</Value>
<Value name="4">
<Value>SySeatDes</Value>
</Value>
<Value name="5">
<Value>SySeatLocation</Value>
</Value>
<Value name="6">
<Value>SySeatSize</Value>
</Value>
<Value name="7">
<Value>SySeatFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCNurSySeatD</DataLocation>
<DefaultData>DHCNurSySeatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCNurSySeatD</IdLocation>
<IndexLocation>^User.DHCNurSySeatI</IndexLocation>
<StreamLocation>^User.DHCNurSySeatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
