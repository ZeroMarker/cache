Class CHSSWeb.CardNumberService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 返回虚拟卡号
ClassMethod GetCardNumber() As %String
{
	;新增或修改个人档案的时候，自动生成虚拟卡号
	;设置CommunityCode
	s CommunityCode = "00502"
	;设置TableName
	s TableName = "CARDNUMBER"
	set CurDate = $zd($Horolog,8)
	s ReturnCommunityCode= ##class(CHSSWeb.SystemIdService).existCommunityCode(CommunityCode,TableName)
	;w ReturnCommunityCode
	i ReturnCommunityCode '= 1 d
	.&sql(insert into CHSS.DictSystemId (SystemId,DateOfLast,TableName,CommunityCode,bValid) values(1,:CurDate,:TableName,:CommunityCode,1))
	.w CommunityCode_"0000000001"
	e  d
	.&sql(update CHSS.DictSystemId set SystemId = SystemId+1,DateOfLast=:CurDate,TableName=:TableName where CommunityCode = :CommunityCode and TableName=:TableName)
	.s ReturnId=..GetCardNumberWithTable(CommunityCode, TableName)
	.w CommunityCode_ReturnId
	q ""
}

/// 判断卡号是否为正式卡号
ClassMethod GetRealCardNumber(CredNo As %String) As %String
{
	//CredNo="身份证号码"
	//CardNO= 卡号
	;ZN "DHC-APP"
	s CardNO = ""
	s status = ""
	s PersonRowId=""
	;w CredNo
	f  s PersonRowId=$o(^PAPERi("DVA",CredNo,PersonRowId)) q:PersonRowId=""  d
	.s cardrowid=""
	.f  s cardrowid=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,cardrowid)) q:cardrowid=""  d
	..;w cardrowid
	..s status=$p(^DHCCARD("CF",cardrowid),"^",10)
	..q:status'="N"
	..s CardNO=$p(^DHCCARD("CF",cardrowid),"^",2)
	..
	;ZN "DHC-CHSSWEB"
	;w CardNO
	q CardNO
}

ClassMethod GetCardNumberWithTable(CommunityCode, TableName) As %String
{
	q:CommunityCode="" "-1"

	///$lg(^CHSS.PersonHealthRecordMainD(PersonRowId),32)
	s SystemId = ""
	s result = ##class(%Library.ResultSet).%New()
	Set prepareString = "SELECT SystemId,DateOfLast,CommunityCode FROM CHSS.DictSystemId WHERE CommunityCode='"_CommunityCode_"' and TableName='"_TableName_"'"
  
	Do result.Prepare(prepareString)
	Do result.Execute()
	While (result.Next()){
	 s SystemId = result.Data("SystemId")
	 while ($l(SystemId) < 10)
	 {
		 s SystemId = "0"_SystemId
		 }
	 s SystemId = SystemId
	 
	}
	q SystemId
}

Storage Default
{
<Data name="CardNumberServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CardNumberServiceD</DataLocation>
<DefaultData>CardNumberServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CardNumberServiceD</IdLocation>
<IndexLocation>^CHSSWeb.CardNumberServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.CardNumberServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
