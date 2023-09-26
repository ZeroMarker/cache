/// 创建:DJ 2015-08-24
/// 描述:设置组件Table元素显示顺序
Class web.DHCEQCComponentSet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2015-08-24
/// 描述:
ClassMethod SaveComponentSet(vSourceType, vSourceID, vComponentName) As %String [ SqlProc ]
{
	n (vSourceType,vSourceID,vComponentName)
	i ((vSourceType="")||(vComponentName=""))  q "-1"
	s FindID=0
	s SQLCODE=0
	s CSRowID=0
	f  s CSRowID=$o(^DHCEQCComponent("DHCEQCComponentSet",0,"Component",vSourceType,+vSourceID,vComponentName,CSRowID))  q:(CSRowID="")||(FindID'=0)  d
	.s CSInvalidFlag=$p($g(^DHCEQCComponet(CSRowID)),"^",8)
	.q:CSInvalidFlag="Y"
	.s FindID=CSRowID
	
	i FindID=0
	{
		K PLIST
		s PLIST(2)=vSourceType
		s PLIST(3)=vSourceID
		s PLIST(4)=vComponentName
		s PLIST(6)=+$H
		s PLIST(7)=$p($H,",",2)
		s PLIST(9)="N"
		&SQL(insert into SQLUSER.DHC_EQCComponentSet values :PLIST())
		i SQLCODE q SQLCODE
		s FindID=$G(%ROWID)
	}
	q FindID
}

/// add by zy 2017-4-6  ZY0162
/// 保存组件设置元素的信息
/// 入参：val	信息窜
/// 	 delIs  是删除还是更新操作 1是删除，否则是更新
/// w ##Class(web.DHCEQCComponentSet).SaveComponentSetNew(0,0,2)
ClassMethod SaveComponentSetNew(val, delIs) As %String
{
	n CSRowID
	k PLIST
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s CSRowID=$p(val,"^",1)
	if +delIs=1
	{
		&SQL(update SQLUSER.DHC_EQCComponentSet set CS_InvalidFlag='Y' where CS_RowID=:CSRowID)
		q SQLCODE
	}	
	s PLIST(2)=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	i ((PLIST(2)="")||(PLIST(3)=""))  q "-1"
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",5)
	s PLIST(6)=+$H
	s PLIST(7)=$p($H,",",2)
	s PLIST(8)=User
	s PLIST(9)="N"
	s PLIST(10)=$p(val,"^",6)
	s PLIST(11)=$p(val,"^",7)
	s PLIST(12)=$p(val,"^",8)
	s PLIST(13)=$p(val,"^",9)
	s PLIST(14)=$p(val,"^",10)
	i CSRowID=""
	{
		s FindID=0
		s SQLCODE=0
		s CSRowID=0
		f  s CSRowID=$o(^DHCEQCCode("DHCEQCComponentSet",0,"SourceComponent",PLIST(2), PLIST(3), PLIST(4),CSRowID))  q:(CSRowID="")||(FindID'=0)  d
		.s CSInvalidFlag=$p($g(^DHCEQCCode("DHCEQCComponentSet",CSRowID)),"^",8)
		.q:CSInvalidFlag="Y"
		.s FindID=CSRowID
	
		i FindID=0
		{
			&SQL(insert into SQLUSER.DHC_EQCComponentSet values :PLIST())
			i SQLCODE q SQLCODE
		}
		else
		{
			q FindID
		}
	}
	else
	{
		&SQL(update sqluser.DHC_EQCComponentSet values :PLIST() where CS_RowID=:CSRowID)
	}
	
	q SQLCODE
}

/// add by zy 2017-4-6  ZY0162
/// 保存组件设置元素的信息
/// 入参：ComponentSetID	组件设置表ID
/// 	 listVal  设置明细信息
/// w ##Class(web.DHCEQComponent).SaveComponentItem("",15,"Test","测试","100,center",1,Y)
ClassMethod SaveComponentItem(ComponentSetID, listVal)
{
	new Length,CSIRowID,Flag,i,List
	k PLISTMX
	i listVal="" q 0
	i ComponentSetID="" q -1
	
	s Length=$l(listVal,"&")
	s PLISTMX(2)=ComponentSetID  				;ComponentDR
	
	s Flag=0
	for i=1:1:Length
	{
		q:Flag'=0
		s List=	$p(listVal,"&",i)
		s NeedFlag= $p(List,"^",1)
		s CSIRowID= $p(List,"^",2)
		s PLISTMX(3)=$p(List,"^",3)  	;ItemID
		s PLISTMX(4)=$p(List,"^",4)		;Caption
		s PLISTMX(5)=$p(List,"^",5)		;CaptionStyle
		s PLISTMX(6)=$p(List,"^",6)		;Disabled
		s PLISTMX(7)=$p(List,"^",7)		;DisplayOnly
		s PLISTMX(8)=$p(List,"^",8)		;Hidden
		s PLISTMX(9)=$p(List,"^",9)		;Style
		s PLISTMX(10)=$p(List,"^",10)	;ReadOnly
		s PLISTMX(11)=$p(List,"^",11)	;Sort
		s PLISTMX(12)=$p(List,"^",12)	;Hold1
		s PLISTMX(13)=$p(List,"^",13)	;Hold2
		s PLISTMX(14)=$p(List,"^",14)	;Hold3
		s PLISTMX(15)=$p(List,"^",15)	;Hold4
		s PLISTMX(16)=$p(List,"^",16)	;Hold5
		
		if (CSIRowID="")
		{
			if (NeedFlag="Y")
			{
				&SQL(Insert Into SQLUSER.DHC_EQCComponentSetItem Values :PLISTMX())
				s CSIRowID=$G(%ROWID)
			}
		}
		else
		{
			if (NeedFlag="Y")
			{
				&SQL(update sqluser.DHC_EQCComponentSetItem values :PLISTMX() where CSI_RowID=:CSIRowID)
			}
			else
			{
				&SQL(delete from sqluser.DHC_EQCComponentSetItem  where CSI_RowID=:CSIRowID)
			}
			
		}
	}
	q SQLCODE
}

/// add by zy 2017-4-6  ZY0162
/// 查询所有的设置信息
/// 入参：SourceType	设置的类型
/// 	 SourceID    	类型ID
/// 	 ComponentID 	组件id
/// d ##class(%ResultSet).RunQuery("web.DHCEQCComponentSet","GetComponentSet","","","")
Query GetComponentSet(SourceType As %String = "", SourceID As %String = "", ComponentID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TComponentID:%String,TSourceType:%String,TSourceTypeDesc:%String,TSourceID:%String,TSource:%String,TComponentName:%String,TLayout:%String,TComponentDesc:%String,THold1:%String")
{
}

ClassMethod GetComponentSetExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "", ComponentID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCComponentSet",rowid)) q:rowid=""  d
 	.s TRowID=rowid
 	.s DataList=$g(^DHCEQCCode("DHCEQCComponentSet",rowid))
	.quit:$p(DataList,"^",8)="Y"
	.s TSourceType=$p(DataList,"^",1)
	.q:TSourceType=""
 	.q:(SourceType'="")&(SourceType'=TSourceType)
 	.i TSourceType'="" s TSourceTypeDesc=$CASE(TSourceType,0:"系统",1:"院区",2:"安全组",3:"用户",:"")
	.s TSourceID=$p(DataList,"^",2)
	.q:TSourceID=""
 	.q:(SourceID'="")&(SourceID'=TSourceID)
	.i (TSourceID'="")&(TSourceType=0) d  //系统
	..s TSource=0
	.i (TSourceID'="")&(TSourceType=1) d  //院区
	..s TSource=$p($g(^CT("HOSP",TSourceID)),"^",2)
	.i (TSourceID'="")&(TSourceType=2) d  //安全组
	..s TSource = ##class(web.DHCEQCommon).GetTrakNameByID("grp",TSourceID)
	.i (TSourceID'="")&(TSourceType=3) d  //用户
	..s TSource = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSourceID)
	.s TComponentID=$p(DataList,"^",3)
	.q:TComponentID=""
	.q:(ComponentID'="")&&(TComponentID'=ComponentID)
	.i TComponentID'="" s TComponentName=$p($g(^DHCEQCCode("DHCEQCComponent",TComponentID)),"^",1)
	.i TComponentID'="" s TComponentDesc=$p($g(^DHCEQCCode("DHCEQCComponent",TComponentID)),"^",2)
	.i TComponentID'="" s THold1=$p($g(^DHCEQCCode("DHCEQCComponent",TComponentID)),"^",13)
	.s TLayout=$p($g(^DHCEQCComponent("DHCEQCComponentSet",rowid)),"^",4)
	.d OutputRowGetComponentSet
	Quit $$$OK
OutputRowGetComponentSet
	set Data=$lb(TRowID,TComponentID,TSourceType,TSourceTypeDesc,TSourceID,TSource,TComponentName,TLayout,TComponentDesc,THold1)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetComponentSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetComponentSetExecute ]
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

ClassMethod GetComponentSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetComponentSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zy 2017-4-6  ZY0162
/// 组件对应的所有元素信息
/// 入参：ComponentID 	组件id
/// d ##class(%ResultSet).RunQuery("web.DHCEQCComponentSet","GetComponentSetItem","1")
Query GetComponentSetItem(ComponentSetID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TCaption:%String,TCaptionStyle:%String,TClassMethod:%String,TClassMethodIfDirty:%String,TCustomExpression:%String,TDataType:%String,TDefaultValueAlways:%String,TDefaultValueExpression:%String,TDescription:%String,TDisabled:%String,TDisplayOnly:%String,TDisplayType:%String,THelpUrl:%String,THidden:%String,TImage:%String,TLinkComponent:%String,TLinkConditionalExp:%String,TLinkExpression:%String,TLinkUrl:%String,TLinkWorkFlow:%String,TListCellStyle:%String,TLookupBrokerMethod:%String,TLookupClassName:%String,TLookupCustomComponent:%String,TLookupJavascriptFunction:%String,TLookupProperties:%String,TLookupQueryName:%String,TLookupUserDefined:%String,TLookupUserDefinedValues:%String,TNestedComponent:%String,TNestedCondExpr:%String,TOrderMode:%String,TPassword:%String,TReadOnly:%String,TReferencedObject:%String,TRequired:%String,TShortcutKey:%String,TShowInNewWindow:%String,TStyle:%String,TTabSequence:%String,TTooltip:%String,TValueGet:%String,TValueSet:%String,TNeedFlag:%String,TCSIRowID:%String,TSort:%String")
{
}

ClassMethod GetComponentSetItemExecute(ByRef qHandle As %Binary, ComponentSetID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i +ComponentSetID=0 Quit $$$OK
	s ComponentID=$p($g(^DHCEQCCode("DHCEQCComponentSet",ComponentSetID)),"^",3)
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
	.s TDisplayType=##Class(web.DHCEQCComponent).ElementDisplayType($p(DataList,"^",14))
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
	.s TNeedFlag="N"
	.s (TCSIRowID,TSort)=""
	.i $Data(^DHCEQCCode("DHCEQCComponentSetItem",0,"ComponentItem",ComponentSetID,TRowID))  d
	..s TNeedFlag="Y"
	..s TCSIRowID=$o(^DHCEQCCode("DHCEQCComponentSetItem",0,"ComponentItem",ComponentSetID,TRowID,0))
	..;modify by lmm 2019-11-19 LMM0049 begin
	..i $p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",3)'="" s TCaption=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",3)
	..i $p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",4)'="" s TCaptionStyle=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",4)
	..i $p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",5)'="" s TDisabled=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",5)
	..i $p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",6)'="" s TDisplayOnly=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",6)
	..i $p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",7)'="" s THidden=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",7)
	..i $p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",8)'="" s TStyle=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",8)
	..i $p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",9)'="" s TReadOnly=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",9)
	..;modify by lmm 2019-11-19 LMM0049 end
	..s TSort=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",10)
	..s THold1=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",11)
	..s THold2=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",12)
	..s THold3=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",13)
	..s THold4=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",14)
	..s THold5=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",15)
	.d OutputRowGetComponentSetItem
	Quit $$$OK
OutputRowGetComponentSetItem
	set Data=$lb(TRowID,TName,TCaption,TCaptionStyle,TClassMethod,TClassMethodIfDirty,TCustomExpression,TDataType,TDefaultValueAlways,TDefaultValueExpression,TDescription,TDisabled,TDisplayOnly,TDisplayType,THelpUrl,THidden,TImage,TLinkComponent,TLinkConditionalExp,TLinkExpression,TLinkUrl,TLinkWorkFlow,TListCellStyle,TLookupBrokerMethod,TLookupClassName,TLookupCustomComponent,TLookupJavascriptFunction,TLookupProperties,TLookupQueryName,TLookupUserDefined,TLookupUserDefinedValues,TNestedComponent,TNestedCondExpr,TOrderMode,TPassword,TReadOnly,TReferencedObject,TRequired,TShortcutKey,TShowInNewWindow,TStyle,TTabSequence,TTooltip,TValueGet,TValueSet,TNeedFlag,TCSIRowID,TSort)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetComponentSetItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetComponentSetItemExecute ]
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

ClassMethod GetComponentSetItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetComponentSetItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zy 2015-11-26   ZY0162
/// 根据组件及权限获取当前界面需要显示的元素
/// 入参：
/// 		ComponentName:  组件名称
/// 		GroupID	: 安全组ID
/// 		UserID	：用户ID
/// 		HosptailID	：hospID院区ID
///   SourceType 0 系统 ，1 院区，2 安全组 3 用户
/// w ##Class(web.DHCEQCComponentSet).GetComponentItemSetInfo("31","1","1","1")
ClassMethod GetComponentItemSetInfo(ComponentName, GroupID, UserID, HosptailID)
{
	new ComponentID,ComponentSetID,Sort,ItemInfo,ItemID,ItemSetID
	s ItemInfo=""
	//先找到组件ID
	i '$Data(^DHCEQCCode("DHCEQCComponent",0,"Name",ComponentName)) q ""
	s ComponentID=$o(^DHCEQCCode("DHCEQCComponent",0,"Name",ComponentName,0))
	i ComponentID="" q ""
	
	i UserID ="" s UserID = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i GroupID ="" s GroupID = %session.Get("LOGON.GROUPID")
	i HosptailID="" s HosptailID=%session.Data("LOGON.HOSPID")
	//找设置表的ID,找到之后存在FindFlag变量中
	//SourceType 0 系统 ，1 院区，2 安全组 3 用户
	s FindFlag=""
	s vSourceType=""
	f  s vSourceType=$o(^DHCEQCCode("DHCEQCComponentSet",0,"SourceComponent",vSourceType),-1) q:(vSourceType="")||(FindFlag'="")  d
	.i (vSourceType=3)&($Data(^DHCEQCCode("DHCEQCComponentSet",0,"SourceComponent",vSourceType,UserID,ComponentID)))  d
	..s SourceType=3
	..s SourceID=UserID
	.e  i (vSourceType=2)&($Data(^DHCEQCCode("DHCEQCComponentSet",0,"SourceComponent",vSourceType,GroupID,ComponentID)))  d
	..s SourceType=2
	..s SourceID=GroupID
	.e  i (vSourceType=1)&($Data(^DHCEQCCode("DHCEQCComponentSet",0,"SourceComponent",vSourceType,HosptailID,ComponentID)))  d
	..s SourceType=1
	..s SourceID=HosptailID
	.e  i (vSourceType=0)&($Data(^DHCEQCCode("DHCEQCComponentSet",0,"SourceComponent",vSourceType,0,ComponentID)))  d
	..s SourceType=0
	..s SourceID=0
	.//确定好SourceType,SourceID,ComponentID三个值后就找对应的设置表的ID
	.s ComponentSetID=0
	.f  s ComponentSetID=$o(^DHCEQCCode("DHCEQCComponentSet",0,"SourceComponent",SourceType,SourceID,ComponentID,ComponentSetID))  q:(ComponentSetID="")||(FindFlag'="")  d
	..quit:$p($g(^DHCEQCCode("DHCEQCComponentSet",ComponentSetID)),"^",8)="Y"
	..s FindFlag=ComponentSetID
	
	s ComponentSetID=FindFlag
	i ComponentSetID="" q ""
	
	s (Sort,ItemInfo)=""
	f  s Sort=$o(^DHCEQCCode("DHCEQCComponentSetItem",0,"ItemSort",ComponentSetID,Sort))  quit:Sort=""  d
	.s ItemID=""
	.f  s ItemID=$o(^DHCEQCCode("DHCEQCComponentSetItem",0,"ItemSort",ComponentSetID,Sort,ItemID))  quit:ItemID=""  d
	..//先从组件设置中取信息
	..s ItemSetID=$o(^DHCEQCCode("DHCEQCComponentSetItem",0,"ItemSort",ComponentSetID,Sort,ItemID,""))
	..q:ItemSetID=""
	..i ItemInfo=""  d
	...s ItemInfo=ItemID_","_ItemSetID
	..e  d
	...s ItemInfo=ItemInfo_"^"_ItemID_","_ItemSetID
	
	quit ItemInfo
}

/// add by zy 2015-11-26   ZY0162
/// 取一个元素的信息
/// 入参：
/// 		ItemID:  元素ID
/// 		ItemSetID	: 元素设置的ID
/// w ##Class(web.DHCEQCComponentSet).GetComponentOneItem("6","5")
ClassMethod GetComponentOneItem(ItemID, ItemSetID)
{
	new result,resultEX
	s (result,resultEX)=""
	s result= $g(^DHCEQCCode("DHCEQCComponentItem",ItemID))
	i ItemSetID'="" s resultEX= $g(^DHCEQCCode("DHCEQCComponentSetItem",ItemSetID))
	i $p(resultEX,"^",3)'="" s $p(result,"^",3)=$p(resultEX,"^",3)
	i $p(resultEX,"^",4)'="" s $p(result,"^",4)=$p(resultEX,"^",4)
	i $p(resultEX,"^",5)'="" s $p(result,"^",12)=$p(resultEX,"^",5)
	i $p(resultEX,"^",6)'="" s $p(result,"^",13)=$p(resultEX,"^",6)
	i $p(resultEX,"^",7)'="" s $p(result,"^",16)=$p(resultEX,"^",7)
	i $p(resultEX,"^",8)'="" s $p(result,"^",41)=$p(resultEX,"^",8)
	i $p(resultEX,"^",9)'="" s $p(result,"^",36)=$p(resultEX,"^",9)
	
	s $p(result,"^",16)=$CASE($p(result,"^",16),"Y":"true","N":"false",:"")
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// add by zy 2017-08-31
/// 初始化各个业务界面jquery显示的列数据
/// w ##Class(web.DHCEQCComponentSet).SetSysjQueryComponent()
ClassMethod SetSysjQueryComponent()
{
	s SQLCODE=0
	s ComponentID=0
	f  s ComponentID=$o(^DHCEQCCode("DHCEQCComponentItem",0,"Component",ComponentID))  quit:ComponentID=""||SQLCODE'=0  d
	.k PLIST
	.s PLIST(2)=0
	.s PLIST(3)=0
	.s PLIST(4)=ComponentID
	.s PLIST(6)=+$H
	.s PLIST(7)=$p($H,",",2)
	.s PLIST(9)="N"
	.s tmp=""
	.&SQL(select CS_RowID Into :tmp from SQLUSER.DHC_EQCComponentSet where CS_SourceType='0' and CS_SourceID='0' and CS_ComponentDR=:ComponentID)
	.i tmp= ""  d
	..&SQL(insert into SQLUSER.DHC_EQCComponentSet values :PLIST())
	..s SetID=$g(%ROWID)
	.e  d
	..s SetID=tmp
	.s rowid=0
	.f  s rowid=$o(^DHCEQCCode("DHCEQCComponentItem",0,"Component",ComponentID,rowid))  quit:rowid=""||SQLCODE'=0  d
	..s DataList=$g(^DHCEQCCode("DHCEQCComponentItem",rowid))
	..s Name=$p(DataList,"^",3)
	..s tmp=""
	..&SQL(select CSI_RowID Into :tmp from SQLUSER.DHC_EQCComponentSetItem where CSI_ComponentSetDR=:SetID and CSI_ComponentItemDR=:rowid)
	..i tmp= "" d
	...&SQL(Insert Into SQLUSER.DHC_EQCComponentSetItem (CSI_ComponentSetDR,CSI_ComponentItemDR,CSI_Caption) values (:SetID,:rowid,:Name))
	q SQLCODE
}

}
