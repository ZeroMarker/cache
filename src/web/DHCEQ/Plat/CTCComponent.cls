Class web.DHCEQ.Plat.CTCComponent Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by lmm 2018-10-11
/// 获取一个组件的所有元素信息
/// 入参：ComponentID	元素ID  DHC_EQCComponent表的ID
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTComponent","GetComponentItem","3")
Query GetComponentItem(ComponentID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TCaption:%String,TCaptionStyle:%String,TClassMethod:%String,TClassMethodIfDirty:%String,TCustomExpression:%String,TDataType:%String,TDefaultValueAlways:%String,TDefaultValueExpression:%String,TDescription:%String,TDisabled:%String,TDisplayOnly:%String,TDisplayType:%String,THelpUrl:%String,THidden:%String,TImage:%String,TLinkComponent:%String,TLinkConditionalExp:%String,TLinkExpression:%String,TLinkUrl:%String,TLinkWorkFlow:%String,TListCellStyle:%String,TLookupBrokerMethod:%String,TLookupClassName:%String,TLookupCustomComponent:%String,TLookupJavascriptFunction:%String,TLookupProperties:%String,TLookupQueryName:%String,TLookupUserDefined:%String,TLookupUserDefinedValues:%String,TNestedComponent:%String,TNestedCondExpr:%String,TOrderMode:%String,TPassword:%String,TReadOnly:%String,TReferencedObject:%String,TRequired:%String,TShortcutKey:%String,TShowInNewWindow:%String,TStyle:%String,TTabSequence:%String,TTooltip:%String,TValueGet:%String,TValueSet:%String,TDisplayTypeDesc:%String")
{
}

ClassMethod GetComponentItemExecute(ByRef qHandle As %Binary, ComponentID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i ComponentID="" Quit $$$OK
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCComponentItem",0,"Component",ComponentID,rowid))  quit:rowid=""  d
	.s DataList=$g(^DHCEQCCode("DHCEQCComponentItem",rowid))
	.s TRowID=rowid
	.s TName=$p(DataList,"^",2)
	.s TCaption=$p(DataList,"^",3)
	.s TCaptionStyle=$p(DataList,"^",4)
	.s TClassMethod=$p(DataList,"^",5)
	.s TClassMethodIfDirty=$p(DataList,"^",6)
	.s TCustomExpression=$p(DataList,"^",7)
	.s TDataType=$p(DataList,"^",8)
	.s TDefaultValueAlways=$p(DataList,"^",9)
	.s TDefaultValueExpression=$p(DataList,"^",10)
	.s TDescription=$p(DataList,"^",11)
	.s TDisabled=$p(DataList,"^",12)
	.s TDisplayOnly=$p(DataList,"^",13)
	.s TDisplayType=$p(DataList,"^",14)
	.s TDisplayTypeDesc=##Class(web.DHCEQCComponent).ElementDisplayType($p(DataList,"^",14))
	.s THelpUrl=$p(DataList,"^",15)
	.s THidden=$p(DataList,"^",16)
	.s TImage=$p(DataList,"^",17)
	.s TLinkComponent=$p(DataList,"^",18)
	.s TLinkConditionalExp=$p(DataList,"^",19)
	.s TLinkExpression=$p(DataList,"^",20)
	.s TLinkUrl=$p(DataList,"^",21)
	.s TLinkWorkFlow=$p(DataList,"^",22)
	.s TListCellStyle=$p(DataList,"^",23)
	.s TLookupBrokerMethod=$p(DataList,"^",24)
	.s TLookupClassName=$p(DataList,"^",25)
	.s TLookupCustomComponent=$p(DataList,"^",26)
	.s TLookupJavascriptFunction=$p(DataList,"^",27)
	.s TLookupProperties=$p(DataList,"^",28)
	.s TLookupQueryName=$p(DataList,"^",29)
	.s TLookupUserDefined=$p(DataList,"^",30)
	.s TLookupUserDefinedValues=$p(DataList,"^",31)
	.s TNestedComponent=$p(DataList,"^",32)
	.s TNestedCondExpr=$p(DataList,"^",33)
	.s TOrderMode=$p(DataList,"^",34)
	.s TPassword=$p(DataList,"^",35)
	.s TReadOnly=$p(DataList,"^",36)
	.s TReferencedObject=$p(DataList,"^",37)
	.s TRequired=$p(DataList,"^",38)
	.s TShortcutKey=$p(DataList,"^",39)
	.s TShowInNewWindow=$p(DataList,"^",40)
	.s TStyle=$p(DataList,"^",41)
	.s TTabSequence=$p(DataList,"^",42)
	.s TTooltip=$p(DataList,"^",43)
	.s TValueGet=$p(DataList,"^",44)
	.s TValueSet=$p(DataList,"^",45)
	.d OutputRowGetComponentItem
	Quit $$$OK
OutputRowGetComponentItem
	set Data=$lb(TRowID,TName,TCaption,TCaptionStyle,TClassMethod,TClassMethodIfDirty,TCustomExpression,TDataType,TDefaultValueAlways,TDefaultValueExpression,TDescription,TDisabled,TDisplayOnly,TDisplayType,THelpUrl,THidden,TImage,TLinkComponent,TLinkConditionalExp,TLinkExpression,TLinkUrl,TLinkWorkFlow,TListCellStyle,TLookupBrokerMethod,TLookupClassName,TLookupCustomComponent,TLookupJavascriptFunction,TLookupProperties,TLookupQueryName,TLookupUserDefined,TLookupUserDefinedValues,TNestedComponent,TNestedCondExpr,TOrderMode,TPassword,TReadOnly,TReferencedObject,TRequired,TShortcutKey,TShowInNewWindow,TStyle,TTabSequence,TTooltip,TValueGet,TValueSet,TDisplayTypeDesc)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetComponentItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetComponentItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetComponentItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetComponentItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
