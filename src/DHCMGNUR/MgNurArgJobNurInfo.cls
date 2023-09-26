Import SQLUser

Class DHCMGNUR.MgNurArgJobNurInfo Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 护士病区
Property WardID As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = Ward_ID ];

/// 护士工号
Property NurseID As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = Nurse_ID ];

/// 护士姓名
Property NurseName As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = Nurse_Name ];

/// 护士层级
Property NurseBty As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Nurse_Bty ];

/// 护士顺序
Property NurseOrder As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Nurse_Order ];

/// 人员类型
Property NurseType As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Nurse_Type ];

Index WardNurse On (WardID, NurseID, NurseType);

Index Ward On WardID;

Index WardOrder On (WardID, NurseOrder);

ClassMethod Save(parr As %String) As %String
{
	q:parr=""
	s WardId=$P(parr,"!",1)
	d ..deleteWard(WardId)
	s len=$L($P(parr,"!",2),"@")
	f i=1:1:len
	{
		s parm=$P($P(parr,"!",2),"@",i)
		k tmp
		s tmp=""
		d ##class(web.DHCNurRosterComm).setTmp(parm,.tmp)
		s obj=##class(DHCMGNUR.MgNurArgJobNurInfo).%New()
		s obj.WardID=WardId
		i $g(tmp("NurseID"))'="" s obj.NurseID=tmp("NurseID")
		i $g(tmp("NurseName"))'="" s obj.NurseName=tmp("NurseName")
		i $g(tmp("NurseBty"))'="" s obj.NurseBty=tmp("NurseBty")
		i $g(tmp("NurseOrder"))'="" s obj.NurseOrder=tmp("NurseOrder")
		i $g(tmp("NurseType"))'="" s obj.NurseType=tmp("NurseType")
		s sc = obj.%Save()
	}
}

ClassMethod deleteWard(WardID As %String) As %String
{
	&sql(delete from DHCMGNUR.MgNurArgJobNurInfo where Ward_ID=:WardID)
	q SQLCODE
}

/// w ##class(DHCMGNUR.MgNurArgJobNurInfo).ChangeOrder("1018^9151^3^MgPersons")
ClassMethod ChangeOrder(parr As %String) As %String
{
	q:parr=""
	s WardId=$P(parr,"^",1) q:WardId=""
	s NurseId=$P(parr,"^",2) q:NurseId=""
	s Order = $P(parr,"^",3) q:Order=""
	s NurseType=$zcvt($P(parr,"^",4),"U") q:NurseType=""
	s ID=$O(^DHCMGNUR.MgNurArgJobNurInfoI("WardNurse"," "_WardId," "_NurseId," "_NurseType,""))
	q:ID=""
	s object = ##class(DHCMGNUR.MgNurArgJobNurInfo).%OpenId(ID)
	s OldOrder = object.NurseOrder
	s object.NurseOrder = Order
	i OldOrder>Order d
	.f AdmOrder=(OldOrder-1):-1:Order d
	..s ID2=$O(^DHCMGNUR.MgNurArgJobNurInfoI("WardOrder"," "_WardId," "_AdmOrder,""))
	..q:ID2=""
	..s a = ##class(DHCMGNUR.MgNurArgJobNurInfo).%OpenId(ID2)
	..s a.NurseOrder = a.NurseOrder+1
	..s sc = a.%Save()
	..i $$$ISERR(sc) Do $System.Status.DisplayError(sc)
	i OldOrder<Order d
	.f AdmOrder=(OldOrder+1):1:Order d
	..s ID2=$O(^DHCMGNUR.MgNurArgJobNurInfoI("WardOrder"," "_WardId," "_AdmOrder,""))
	..b ;02
	..s b = ##class(DHCMGNUR.MgNurArgJobNurInfo).%OpenId(ID2)
	..q:ID2=""
	..s b.NurseOrder = b.NurseOrder-1
	..s sc = b.%Save()
	..i $$$ISERR(sc) Do $System.Status.DisplayError(sc)
	s sc = object.%Save()
	i $$$ISERR(sc) Do $System.Status.DisplayError(sc)
	q 0
}

Storage Default
{
<Data name="MgNurArgJobNurInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NurseID</Value>
</Value>
<Value name="3">
<Value>NurseOrder</Value>
</Value>
<Value name="4">
<Value>WardID</Value>
</Value>
<Value name="5">
<Value>NurseBty</Value>
</Value>
<Value name="6">
<Value>NurseName</Value>
</Value>
<Value name="7">
<Value>NurseType</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurArgJobNurInfoD</DataLocation>
<DefaultData>MgNurArgJobNurInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurArgJobNurInfoD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurArgJobNurInfoI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurArgJobNurInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
