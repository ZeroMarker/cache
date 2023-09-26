Class web.DHCPE.EDKey Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Update(ID, Key, Color)
{
	i ID="" d
	.s obj=##class(User.DHCPEEDKey).%New()
	e  d
	.s obj=##class(User.DHCPEEDKey).%OpenId(ID)
	s obj.EDKDesc=Key
	s obj.EDKColor=Color
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q "0"
	}
}

ClassMethod Delete(ID)
{
	&SQL(Delete From Sqluser.DHC_PE_EDKey where ID=:ID)
	q SQLCODE
}

Query SearchEDKey() As %SQLQuery(ROWSPEC = "TID:%String,TColor:%String,TDesc:%String,TNoActive:%String,TUpdateDate:%String,TUpdateTime:%String,TUpdateUser:%String") [ SqlProc ]
{
	select * from Sqluser.DHC_PE_EDKey
}

}
