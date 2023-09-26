Import SQLuser

/// 存在系统		：体检系统
/// 关联数据		: DHC_PE_NewMessageTemplet
/// 主要功能		：短信模板维护 
/// create by yandong
Class web.DHCPE.MessageTemplet Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindMessageTemplet(VIPLevel As %String, Type As %String, Templet As %String, Active As %String = "1", Default As %String) As %Query(ROWSPEC = "NMT_Type:%String:短信类型,NMT_Templet:%String:模板内容,NMT_Active:%String:使用标志,Hidden:%String,ID:%String,NMT_VIPLevel:%String:VIP等级")
{
}

ClassMethod FindMessageTempletExecute(ByRef qHandle As %Binary, VIPLevel As %String, Type As %String, Templet As %String, Active As %String = "1", Default As %String = "") As %Status
{
	 
      Set repid=$I(^CacheTemp)
      s ind=1
      s NMTType=""
	  f  s NMTType=$o(^User.DHCPENewMessageTempletI("TypeDefaultIndex",NMTType)) q:NMTType=""  d
	  .s NMTDefault=""
	  .f  s NMTDefault=$o(^User.DHCPENewMessageTempletI("TypeDefaultIndex",NMTType,NMTDefault)) q:NMTDefault=""  d
	  ..s ID="0"
	  ..f  s ID=$o(^User.DHCPENewMessageTempletI("TypeDefaultIndex",NMTType,NMTDefault,ID)) q:ID=""  d  
	  ...s aType=$listget(^User.DHCPENewMessageTempletD(ID),2)
	  ...q:(aType'=Type)&(Type'="")
	  ...s NMTActive=$listget(^User.DHCPENewMessageTempletD(ID),5)
      ...q:((""'=Active)&((NMTActive'[Active)))
      ...i NMTActive="0" s NMTActive="否"
      ...i NMTActive="1" s NMTActive="是"
      ...s NMTTemplet=$listget(^User.DHCPENewMessageTempletD(ID),4)
      ...q:((""'=Templet)&((NMTTemplet'[Templet)))
      ...s Default=$listget(^User.DHCPENewMessageTempletD(ID),3)
      ...q:((""'=Default)&((NMTDefault'[Default)))
      ...s vip=$listget(^User.DHCPENewMessageTempletD(ID),6)
      ...s VIPDesc=""
      ...i vip'="" s VIPDesc=$P(^DHCPEVIPLevel("VIP",vip),"^",2)
      ...;q:((VIPLevel'="")&(VIPLevel'=VIPDesc))
      ...q:((VIPLevel'="")&(VIPLevel'=vip))
      ...Do FindBuild
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
FindBuild
      set Data=$lb(NMTType,NMTTemplet,NMTActive,NMTDefault,ID,VIPDesc)
      Set ^CacheTemp(repid,ind)=Data
      Set ind=ind+1
      quit
}

ClassMethod FindMessageTempletFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMessageTempletExecute ]
{
	
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind) 
	Quit $$$OK
}

ClassMethod FindMessageTempletClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMessageTempletExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMessageTempletByID(ID As %Library.String = "")
{
	s Type=$listget(^User.DHCPENewMessageTempletD(ID),2)
	s Active=$listget(^User.DHCPENewMessageTempletD(ID),5)
    s Templet=$listget(^User.DHCPENewMessageTempletD(ID),4)
    s Default=$listget(^User.DHCPENewMessageTempletD(ID),3)
    s VIP=$listget(^User.DHCPENewMessageTempletD(ID),6)
    q Type_"^"_Active_"^"_Templet_"^"_Default_"^"_VIP
}

// 短信模板类型的下拉列表

ClassMethod OutTypeToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	
	//下拉列表
	w "<select name='Type' id='Type' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
	w "<option value=''>"_""_"</option>",!
	s NMTType=""
    w "<option value='"_"老年短信"_"'>"_"老年短信"_"</option>",!
    w "<option value='"_"普通短信"_"'>"_"普通短信"_"</option>",!
    w "<option value='"_"VIP短信"_"'>"_"VIP短信"_"</option>",!
    w "<option value='"_"高危短信"_"'>"_"高危短信"_"</option>",!
    w "<option value='"_"西院短信"_"'>"_"西院短信"_"</option>",!
    ;f  s NMTType=$o(^User.DHCPENewMessageTempletI("TypeDefaultIndex",NMTType)) q:NMTType=""  d
	;.w "<option value='"_NMTType_"'>"_NMTType_"</option>",!
	w "</select>",!
	Quit $$$OK
}

// 修改短信内容

ClassMethod Update(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
   s rowid=$P(InString,"^",1)
   s Type=$p(InString,"^",2)
   
   s Templet=$p(InString,"^",3)
   s Active=$p(InString,"^",4)
   s Default=$p(InString,"^",5)
   s VIP=$p(InString,"^",6)
    &sql(update DHC_PE_NewMessageTemplet set NMT_VIPLevel =:VIP,NMT_Type =:Type,NMT_Templet =:Templet,NMT_Active =:Active,NMT_Default =:Default where ID=:rowid)

	Q SQLCODE
}

// 增加模板短信

ClassMethod Add(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	
   //s VIP=
   s Type=$p(InString,"^",1)
   s Templet=$p(InString,"^",2)
   s Active=$p(InString,"^",3)
   s Default=$p(InString,"^",4)
   s VIP=$p(InString,"^",5)
  &sql(insert into DHC_PE_NewMessageTemplet(NMT_Type,NMT_Templet,NMT_Active, NMT_Default,NMT_VIPLevel)

	     values (:Type,:Templet,:Active,:Default,:VIP))
	
	;s ID=%ID 
	;w !,ID_"IDmmmm"    
	Q SQLCODE
}

// 删除所选模板短信

ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
  s rowid=$p(InString,"^",1)
	 &sql(

		delete from DHC_PE_NewMessageTemplet where ID=:rowid

	     )
	Q SQLCODE
}

ClassMethod GetVipDesc(VIP)
{
  q:VIP="" ""
  s VIPDesc=$P(^DHCPEVIPLevel("VIP",VIP),"^",2)
  q VIPDesc
}

Storage Default
{
<Data name="MessageTempletDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.MessageTempletD</DataLocation>
<DefaultData>MessageTempletDefaultData</DefaultData>
<IdLocation>^web.DHCPE.MessageTempletD</IdLocation>
<IndexLocation>^web.DHCPE.MessageTempletI</IndexLocation>
<StreamLocation>^web.DHCPE.MessageTempletS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
