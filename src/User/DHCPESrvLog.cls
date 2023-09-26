/// Descripiton: 服务调用日志 不局限于DHCPEService，其他调用外部方法或接口都可以记录于此
/// Creator:	wangguoying
/// CreateDate:	2021-11-24
Class User.DHCPESrvLog Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_SrvLog ]
{

Parameter ClassName = "User.DHCPESrvLog";

/// 日志保留天数
Parameter InDateNum = 30;

Relationship SLDetailChild As User.DHCPESrvLogDetail [ Cardinality = children, Inverse = SLDParRef ];

/// 服务类型   体检公共webservice业务代码  HTTP服务为请求路径
Property SLType As %String(COLLATION = "ALPHAUP", MAXLEN = 200) [ Required, SqlColumnNumber = 2, SqlFieldName = SL_Type ];

/// 业务ID  无实际业务时默认 ISNULL
Property SLBusID As %String(COLLATION = "ALPHAUP") [ InitialExpression = "ISNULL", Required, SqlColumnNumber = 3, SqlFieldName = SL_BusID ];

/// 成功标记 
Property SLSuccess As %Boolean [ InitialExpression = "1", Required, SqlColumnNumber = 4, SqlFieldName = SL_Success ];

/// 请求参数
Property SLRequest As %GlobalCharacterStream [ SqlColumnNumber = 5, SqlFieldName = SL_Request ];

/// 响应参数
Property SLResponse As %GlobalCharacterStream [ SqlColumnNumber = 6, SqlFieldName = SL_Response ];

/// 备注  预留
Property SLRemark As %String [ SqlColumnNumber = 7, SqlFieldName = SL_Remark ];

/// 日期
Property SLDate As %Date [ InitialExpression = {+$H}, Required, SqlColumnNumber = 8, SqlFieldName = SL_Date ];

/// 时间
Property SLTime As %Time [ InitialExpression = {$P($H,",",2)}, Required, SqlColumnNumber = 9, SqlFieldName = SL_Time ];

Index DateTimeIndex On (SLDate, SLTime);

Index TypeDateBusIndex On (SLType, SLDate, SLTime, SLBusID);

/// Description: 记录日志
/// Input:   
/// Return:		0：成功  非0^失败信息
/// Creator:	wangguoying
/// CreateDate:	2021-11-24
/// Debug: w ##class(User.DHCPESrvLog).Log("HS10222","","","<Request><locId/></Request>","<Response><ResultCode>-200</ResultCode><ResultDesc> PARAMETER zGetPrice^web.DHCPE.Handle.ARCOrdSets.1</ResultDesc></Response>","")
ClassMethod Log(SrvType, BusID = "", Success = "1", Request, Response, Remark = "")
{
	q:SrvType="DHCPETOOL" 0
	q:SrvType="PE2002" 0
	s $ZT="LogErr"
	d ..DeleteExpireLog()
	s:Success="" Success=1
	i (Request'="")&&('##class(web.DHCPE.Utils.StreamUtil).IsStream(Request))
	{
		s Stream = ##class(%GlobalCharacterStream).%New()
		d Stream.Write(Request)
		s Request = Stream
	}
	i (Response'="")&&('##class(web.DHCPE.Utils.StreamUtil).IsStream(Response))
	{
		s Stream = ##class(%GlobalCharacterStream).%New()
		d Stream.Write(Response)
		s Response = Stream
	}
	s obj = ##class(User.DHCPESrvLog).%New()
	s obj.SLType = SrvType
	s:BusID'="" obj.SLBusID = BusID
	s obj.SLSuccess = Success
	s obj.SLRequest = Request
	s obj.SLResponse = Response
	s obj.SLRemark = Remark
	d obj.SetBussID()
	s sc = obj.%Save()
	i $$$ISERR(sc)  q "-1^"_$System.Status.GetErrorText(sc)
	q 0
LogErr
	s $Zt=""
	q "-100^"_$ZE
}

// w ##class(User.DHCPESrvLog).SetBussIDTest(13136)

ClassMethod SetBussIDTest(LogID)
{
	s obj = ##class(User.DHCPESrvLog).%OpenId(LogID)
	s RequestCode=obj.SLType
	s params=obj.SLRequest
	d obj.SetBussID()
	s sc=obj.%Save()
	q sc
}

Method SetBussID()
{
	//d %this.SLRequest.Read(100000)
	s params=$this.SLRequest.Read(100000)
	s RequestCode=$this.SLType
	s BussID=""
	i RequestCode="FKYY.GetItemInfo"{
		s BussID=$P(params,"<HPNo>",2)
		s BussID=$P(BussID,"</HPNo>",1)
	}elseif RequestCode="FKYY.UpdateResult"{
		s BussID=$P(params,"<OrdItemID>",2)
		s BussID=$P(BussID,"</OrdItemID>",1)
	}elseif RequestCode="FKYY.UpdateItemStatus"{
		s BussID=$P(params,"<OrdItemID>",2)
		s BussID=$P(BussID,"</OrdItemID>",1)
	}elseif RequestCode="FKYY.UpdateLabNo"{
		s ItemLength=$L(params,"<OrdItemID>")
		f ItemI=2:1:ItemLength{
			s OneInfo=$P(params,"<OrdItemID>",ItemI)
			s OneBuss=$P(OneInfo,"</OrdItemID>",1)
			i BussID="" d
			.s BussID=OneBuss
			e  d
			.s BussID=BussID_"^"_OneBuss
		}
	}
	q:BussID=""
	s BussLength=$L(BussID,"^")
	f BussI=1:1:BussLength{
		s ChildObj=##class(User.DHCPESrvLogDetail).%New()
		s ChildObj.SLDType=$this.SLType
		s ChildObj.SLDBusiID=$P(BussID,"^",BussI)
		d $this.SLDetailChild.Insert(ChildObj)
	}
	q $this
}

/// Description: 删除过期日志
/// Input:   
/// Return:		0：成功  非0^失败信息
/// Creator:	wangguoying
/// CreateDate:	2021-11-24
/// Debug: w ##class(User.DHCPESrvLog).DeleteExpireLog()
ClassMethod DeleteExpireLog()
{
	s lastLogDate = +$O(^User.DHCPESrvLogI("DateTimeIndex",""))
	s validityDate = +$H-..#InDateNum //保质期内
	q:lastLogDate>=validityDate 0	//不存在过期记录
	s date = validityDate
	f  s date = $O(^User.DHCPESrvLogI("DateTimeIndex",date),-1) q:date=""  d
	.s time = ""
	.f  s time = $O(^User.DHCPESrvLogI("DateTimeIndex",date,time)) q:time=""  d
	..s id = ""
	..f  s id = $O(^User.DHCPESrvLogI("DateTimeIndex",date,time,id)) q:id=""  d
	...d ##Class(User.DHCPESrvLog).Delete(id)
	q 0
}

/// Description: 记录日志
/// Input:   
/// Return:		0：成功  非0^失败信息
/// Creator:	wangguoying
/// CreateDate:	2021-11-24
/// Debug: w ##class(User.DHCPESrvLog).Log()
Storage Default
{
<Data name="DHCPESrvLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SLType</Value>
</Value>
<Value name="3">
<Value>SLBusID</Value>
</Value>
<Value name="4">
<Value>SLSuccess</Value>
</Value>
<Value name="5">
<Value>SLRequest</Value>
</Value>
<Value name="6">
<Value>SLResponse</Value>
</Value>
<Value name="7">
<Value>SLRemark</Value>
</Value>
<Value name="8">
<Value>SLDate</Value>
</Value>
<Value name="9">
<Value>SLTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCPESrvLogD</DataLocation>
<DefaultData>DHCPESrvLogDefaultData</DefaultData>
<Description>
<![CDATA[Description: 记录日志
Input:   
Return:		0：成功  非0^失败信息
Creator:	wangguoying
CreateDate:	2021-11-24
Debug: w ##class(User.DHCPESrvLog).Log()]]></Description>
<IdLocation>^User.DHCPESrvLogD</IdLocation>
<IndexLocation>^User.DHCPESrvLogI</IndexLocation>
<StreamLocation>^User.DHCPESrvLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
