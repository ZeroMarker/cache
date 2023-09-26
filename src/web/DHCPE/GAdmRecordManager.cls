Class web.DHCPE.GAdmRecordManager Extends %Persistent
{

ClassMethod Insert(PreGADM, GAdmType, Type, User, Remark)
{
	;d ##class(web.DHCPE.GAdmRecordManager).Insert(78,"P","PRE","1","备注")
	;AdmType  P;DHCPEPreGADM  I;DHCPEGADM  A:ADM
	q:PreGADM=""
	s obj=##class(User.DHCPEGAdmRecordManager).%New()
	i GAdmType="I" d
	.s PreGADM=$P($g(^DHCPEGADM(PreGADM)),"^",2)
	i GAdmType="A" d
	.s PreGADM=$O(^DHCPEGADM(0,"DelegateADM",PreGADM,0))
	.q:PreGADM=""
	.s PreGADM=$P($g(^DHCPEGADM(PreGADM)),"^",2)
	q:PreGADM=""
	d obj.GRMADMDRSetObjectId(PreGADM)
	s:User="" User=%session.Get("LOGON.USERID")
	
	s obj.GRMUser=User
	s obj.GRMDate=+$H
	s obj.GRMTime=$P($H,",",2)
	s obj.GRMType=Type
	s obj.GRMRemark=Remark
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

Query FindGAdmRecord(GAdmId As %String = "") As %Query(ROWSPEC = "TID:%String,TDate:%String,TTime:%String,TType:%String,TRemark:%String,TUser:%String")
{
}

ClassMethod FindGAdmRecordExecute(ByRef qHandle As %Binary, GAdmId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.GAdmRecordManager", "FindGAdmRecord",552)
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	s id=0
	f  s id=$o(^User.DHCPEGAdmRecordManagerI("AdmIndex",GAdmId,id)) q:id=""  d
	.s Date=$LG(^User.DHCPEGAdmRecordManagerD(id),4)
	.s TDate=##class(websys.Conversions).DateLogicalToHtml(Date)
	.s Time=$LG(^User.DHCPEGAdmRecordManagerD(id),5)
	.s TTime=##class(websys.Conversions).TimeLogicalToHtml(Time)
	.s Type=$LG(^User.DHCPEGAdmRecordManagerD(id),6)
	.s Remark=$LG(^User.DHCPEGAdmRecordManagerD(id),7)
	.s TType=..GetRecordTypeDesc(Type)
	.s TRemark=..GetRemarkDesc(Type,Remark)
	.s User=$LG(^User.DHCPEGAdmRecordManagerD(id),3)
	.s TUser=$P($g(^SSU("SSUSR",User)),"^",2)
	.d FindAdmRecordBuild	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindAdmRecordBuild      
	set Data=$lb(id,TDate,TTime,TType,TRemark,TUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindGAdmRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGAdmRecordExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindGAdmRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGAdmRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetBaseInfo(GAdmId)
{
	;##class(web.DHCPE.GAdmRecordManager).GetBaseInfo()
	s PGBI=$p($g(^DHCPEPreGADM(GAdmId)),"^",1)
	q:PGBI="" ""
	s BookDate=$p($g(^DHCPEPreGADM(GAdmId)),"^",2)
	s:BookDate'="" BookDate=##class(websys.Conversions).DateLogicalToHtml(BookDate)
	s GCode=$p($g(^DHCPEPreGBI(PGBI)),"^",1)
	s GDesc=$p($g(^DHCPEPreGBI(PGBI)),"^",2)
	q GDesc_"^"_GCode_"^"_BookDate
}

ClassMethod GetRecordTypeDesc(Type)
{
	;w ##class(web.DHCPE.GAdmRecordManager).GetRecordTypeDesc("Cashier")
	q:Type="PREInsert" "预约"
	q:Type="TeamInsert" "新建分组"  //
	q:Type="TeamRegister" "分组登记"    //每个组一条，备注为组的ID
	q:Type="TeamArrived" "分组到达" 
	q:Type="TeamDisCount" "审核记录打折"
	q:Type="CancleTeamDisCount" "无优惠"
	q:Type="DeleteTeam" "删除分组"
	q:Type="Import" "导入人员"
	q:Type="Cashier" "收费"
	q:Type="DropInvPrt" "退费"
	q:Type="CANCELPE" "取消体检"
	q:Type="UNCANCELPE" "撤消取消体检"
	q:Type="CANCELPREREG" "取消预约"
	q:Type="InsertTeamDiscount" "新增分组折扣率"
	q:Type="UpdateTeamDiscount" "更新分组折扣率"
	q ""
}

ClassMethod GetRemarkDesc(Type, Remark)
{
	;w ##class(web.DHCPE.GAdmRecordManager).GetRemarkDesc("Cashier","285")
	q:Remark="" ""
	i Type="TeamDisCount" d
	.s Rebate=$p(Remark,"^",2)
	.s PreAudit=$p(Remark,"^",3)
	.s PrivilegeMode=##class(web.DHCPE.PreAudit).GetPrivilegeMode($p(Remark,"^",4)) 
	.s Remark=$p(Remark,"^",1)
	.i Remark["||" d
	..i $D(^DHCPEPreGADM(+Remark,"Team",$p(Remark,"||",2))) d
	...s TeamDesc=$p($g(^DHCPEPreGADM(+Remark,"Team",$p(Remark,"||",2))),"^",1)
	...s Remark="分组名称："_TeamDesc_"，审核记录:"_PreAudit_"，折扣率："_Rebate_"%，优惠方式："_PrivilegeMode
	.e  d
	..s Remark="审核记录:"_Remark_"，折扣率："_Rebate_"%，优惠方式："_PrivilegeMode
	e  i Type="InsertTeamDiscount" d
	.s Rebate="预约折扣率："_$p(Remark,"^",2)_"%,公加折扣率："_$p(Remark,"^",3)_"%,自加折扣率："_$p(Remark,"^",4)_"%"
	.s Remark=$p(Remark,"^",1)
	.i Remark["||" d
	..i $D(^DHCPEPreGADM(+Remark,"Team",$p(Remark,"||",2))) d
	...s TeamDesc=$p($g(^DHCPEPreGADM(+Remark,"Team",$p(Remark,"||",2))),"^",1)
	...s Remark="分组名称："_TeamDesc_"，折扣率："_Rebate_"%"
	e  i Type="UpdateTeamDiscount" d
	.s Rebate="预约折扣率："_$p(Remark,"^",2)_"%,公加折扣率："_$p(Remark,"^",3)_"%,自加折扣率："_$p(Remark,"^",4)_"%,原预约折扣率："_$p(Remark,"^",5)_"%,原公加折扣率："_$p(Remark,"^",6)_"%,原自加折扣率："_$p(Remark,"^",7)_"%"
	.s Remark=$p(Remark,"^",1)
	.i Remark["||" d
	..i $D(^DHCPEPreGADM(+Remark,"Team",$p(Remark,"||",2))) d
	...s TeamDesc=$p($g(^DHCPEPreGADM(+Remark,"Team",$p(Remark,"||",2))),"^",1)
	...s Remark="分组名称："_TeamDesc_"，折扣率："_Rebate_"%"
	e  i Type="Cashier" d
	.s Remark=$P($g(^DHCPEINVPRT(Remark)),"^",1)
	.s Remark="发票号:"_Remark
	e  i Type="DropInvPrt" d
	.s Remark=$P($g(^DHCPEINVPRT(Remark)),"^",1)
	.s Remark="发票号:"_Remark
	e  i Type="DeleteTeam" d
	.s Remark="删除分组:"_Remark
	e  d
	.i $D(^DHCPEPreGADM(+Remark,"Team",$p(Remark,"||",2))) d
	..s TeamDesc=$p($g(^DHCPEPreGADM(+Remark,"Team",$p(Remark,"||",2))),"^",1)
	..s Remark="分组名称:"_TeamDesc
	.e  d
	..s Remark="该分组已被删除:"_Remark
	
	q Remark
}

Storage Default
{
<Data name="GAdmRecordManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.GAdmRecordManagerD</DataLocation>
<DefaultData>GAdmRecordManagerDefaultData</DefaultData>
<IdLocation>^web.DHCPE.GAdmRecordManagerD</IdLocation>
<IndexLocation>^web.DHCPE.GAdmRecordManagerI</IndexLocation>
<StreamLocation>^web.DHCPE.GAdmRecordManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
