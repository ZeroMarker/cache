Class web.DHCEQ.Plat.CTCComponentSet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified by zy 20180930  ZY0170
/// 增加TSort输出，用来控制链接图标
/// 减少前台调用,方法合并且改为Query输出
/// Modified By QW20200108 BUG:QW0034 增加输入ApproveSetDR, ActionDR,ApproveRole
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTCComponentSet","ComponentSetItem","","86","1402","2","","","","EQ_EquipEdit")
Query ComponentSetItem(ComponentName As %String = "", GroupID As %String = "", UserID As %String = "", HosptailID As %String = "", Frozen As %String = "", ApproveSetDR As %String = "", ApproveRole As %String = "", Action As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TCaption:%String,TCaptionStyle:%String,TClassMethod:%String,TClassMethodIfDirty:%String,TCustomExpression:%String,TDataType:%String,TDefaultValueAlways:%String,TDefaultValueExpression:%String,TDescription:%String,TDisabled:%String,TDisplayOnly:%String,TDisplayType:%String,THelpUrl:%String,THidden:%String,TImage:%String,TLinkComponent:%String,TLinkConditionalExp:%String,TLinkExpression:%String,TLinkUrl:%String,TLinkWorkFlow:%String,TListCellStyle:%String,TLookupBrokerMethod:%String,TLookupClassName:%String,TLookupCustomComponent:%String,TLookupJavascriptFunction:%String,TLookupProperties:%String,TLookupQueryName:%String,TLookupUserDefined:%String,TLookupUserDefinedValues:%String,TNestedComponent:%String,TNestedCondExpr:%String,TOrderMode:%String,TPassword:%String,TReadOnly:%String,TReferencedObject:%String,TRequired:%String,TShortcutKey:%String,TShowInNewWindow:%String,TStyle:%String,TTabSequence:%String,TTooltip:%String,TValueGet:%String,TValueSet:%String,TSort:%String,TSaveFlag:%String,TTableName:%String,TItemType:%String,TMultiFLag:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TAreaID:%String")
{
}

ClassMethod ComponentSetItemExecute(ByRef qHandle As %Binary, ComponentName As %String = "", GroupID As %String = "", UserID As %String = "", HosptailID As %String = "", Frozen As %String = "", ApproveSetDR As %String = "", ApproveRole As %String = "", Action As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	//Modified By QW20200108 BUG:QW0034 Begin 在原基础上增加ApproveSetDR判断。ApproveSetDR为空保持不变
    if ((ApproveSetDR'="")&&((ApproveRole'=""))||(Action'=""))
    {
	    //Modify by zx 2020-12-31 BUG ZX0126
	    i UserID ="" s UserID = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
		i GroupID ="" s GroupID = %session.Get("LOGON.GROUPID")
		i HosptailID="" s HosptailID=%session.Data("LOGON.HOSPID")
		
	    s ApproveFlowDR=""
		if (Action'="") 
		{
			s ActionDR=$o(^DHCEQCCode("DHCEQCAction",0,"Code",Action,0))
			i ActionDR'="" s ApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSetDR,ActionDR,0))
		}
		else  
		{
			s ApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSetDR,ApproveRole,0))
		}
		s ComponentSetID=""
		i ApproveFlowDR'="" s ComponentSetID=$p(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR),"^",19)
		i (ComponentSetID="")&&(Action="") Quit $$$OK
		
		//获取同一key值下SourceType值下限
		s CurSourceType=0  //初始为系统级
		s ComponentID=""
		s CurComponentID=""
		s CurComponentSetID=0
		f  s CurComponentSetID=$o(^DHCEQCCode("DHCEQCComponentSet",0,"ComponentSetKey",Action,CurComponentSetID)) q:CurComponentSetID=""  d
		.s ComponentID=$p($g(^DHCEQCCode("DHCEQCComponentSet",CurComponentSetID)),"^",3)  //获取列定义id,同一key的列定义id相同
		.s SourceType=$p($g(^DHCEQCCode("DHCEQCComponentSet",CurComponentSetID)),"^",1)
		.s SourceID=$p($g(^DHCEQCCode("DHCEQCComponentSet",CurComponentSetID)),"^",2)  //设置SourceID
		.s ParamSourceID=$Case(+SourceType,"0":"0","1":HosptailID,"2":GroupID,"3":UserID,:"")  //实际SourceID
		.//Modefied by zc0117 20220428  修改移动端列定义取值 begin
		.;i (SourceID=ParamSourceID)&&(+SourceType>CurSourceType) d
		.;.s CurSourceType=+SourceType
		.;.s CurComponentID=ComponentID
		.i SourceID=ParamSourceID d
		..i (ComponentSetID="")&&(+SourceType>=CurSourceType) d
		...s CurSourceType=+SourceType
		...s CurComponentID=ComponentID
		..e  i (ComponentSetID'="")&&(+SourceType>CurSourceType) d
		...s CurSourceType=+SourceType
		...s CurComponentID=ComponentID
		.//Modefied by zc0117 20220428  修改移动端列定义取值 end
		//确定SourceType值下限后匹配SourceID
		s CurSourceID=$Case(CurSourceType,"0":"0","1":HosptailID,"2":GroupID,"3":UserID,:"")
		s CurComponentSetID=""
		i (CurSourceID'="")&&(CurComponentID'="") d
		.s CurComponentSetID=$o(^DHCEQCCode("DHCEQCComponentSet",0,"SourceComponent",CurSourceType,CurSourceID,CurComponentID,0))
		i CurComponentSetID'="" s ComponentSetID=CurComponentSetID
		i +ComponentSetID=0 Quit $$$OK
		
    }else
    {
	    i ComponentName="" Quit $$$OK
		
		//先找到组件ID		Mozy	2018-10-19
		s ComponentID=""
		s rowid=0
		f  s rowid=$o(^DHCEQCCode("DHCEQCComponent",0,"Name",ComponentName,rowid)) q:(rowid="")  d
		.quit:$p($g(^DHCEQCCode("DHCEQCComponent",rowid)),"^",12)="Y"
		.s ComponentID=rowid
		i ComponentID="" Quit $$$OK
		
		i UserID ="" s UserID = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
		i GroupID ="" s GroupID = %session.Get("LOGON.GROUPID")
		i HosptailID="" s HosptailID=%session.Data("LOGON.HOSPID")
		
		//找设置表的ID,找到之后存在FindFlag变量中
		//SourceType 0 系统 ，1 院区，2 安全组 3 用户
		s (FindFlag,SourceType,SourceID)=""
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
		.//modified by zy 20181023 ZY0172 没有找到SourceType和SourceID的时候进行下一个循环.
		.q:(SourceType="")||(SourceID="")
		.//确定好SourceType,SourceID,ComponentID三个值后就找对应的设置表的ID
		.s ComponentSetID=0
		.f  s ComponentSetID=$o(^DHCEQCCode("DHCEQCComponentSet",0,"SourceComponent",SourceType,SourceID,ComponentID,ComponentSetID))  q:(ComponentSetID="")||(FindFlag'="")  d
		..quit:$p($g(^DHCEQCCode("DHCEQCComponentSet",ComponentSetID)),"^",8)="Y"
		..s FindFlag=ComponentSetID
		
		s ComponentSetID=FindFlag
		i ComponentSetID="" Quit $$$OK
	}
	//Modified By QW20200108 BUG:QW0034 End
	
	s (Sort,ItemInfo)=""
	f  s Sort=$o(^DHCEQCCode("DHCEQCComponentSetItem",0,"ItemSort",ComponentSetID,Sort))  quit:Sort=""  d
	.s ItemID=""
	.f  s ItemID=$o(^DHCEQCCode("DHCEQCComponentSetItem",0,"ItemSort",ComponentSetID,Sort,ItemID))  quit:ItemID=""  d
	..//先从组件设置中取信息
	..s ItemSetID=$o(^DHCEQCCode("DHCEQCComponentSetItem",0,"ItemSort",ComponentSetID,Sort,ItemID,""))
	..q:ItemSetID=""
	..d ResetComponentSetItem
	..s DataList=$g(^DHCEQCCode("DHCEQCComponentItem",ItemID))
	..q:(Frozen="Y")&&($p(DataList,"^",46)'="Y")	;Mozy	754500	2018-12-7	输出冻结列
	..q:(Frozen="N")&&($p(DataList,"^",46)="Y")		;Mozy	754500	2018-12-7	输出非冻结列
	..s EXDataList= $g(^DHCEQCCode("DHCEQCComponentSetItem",ItemSetID))
	..s TRowID=ItemID
	..s TName=$p(DataList,"^",2)
	..s TCaption=$p(DataList,"^",3)
	..i $p(EXDataList,"^",3)'="" s TCaption=$p(EXDataList,"^",3)
	..s TCaptionStyle=$p(DataList,"^",4)
	..i $p(EXDataList,"^",4)'="" s TCaptionStyle=$p(EXDataList,"^",4)
	..s TClassMethod=$p(DataList,"^",5)
	..s TClassMethodIfDirty=$p(DataList,"^",6)
	..s TCustomExpression=$p(DataList,"^",7)
	..s TDataType=$p(DataList,"^",8)
	..s TDefaultValueAlways=$p(DataList,"^",9)
	..s TDefaultValueExpression=$p(DataList,"^",10)
	..s TDescription=$p(DataList,"^",11)
	..s TDisabled=$p(DataList,"^",12)
	..i $p(EXDataList,"^",5)'="" s TDisabled=$p(EXDataList,"^",5)
	..s TDisplayOnly=$p(DataList,"^",13)
	..i $p(EXDataList,"^",6)'="" s TDisplayOnly=$p(EXDataList,"^",6)
	..//s TDisplayType=##Class(web.DHCEQCComponent).ElementDisplayType($p(DataList,"^",14))
	..s TDisplayType=$p(DataList,"^",14)
	..s THelpUrl=$p(DataList,"^",15)
	..s THidden=$p(DataList,"^",16)
	..i $p(EXDataList,"^",7)'="" s THidden=$p(EXDataList,"^",7)
	..//add by ZY0271 20210618
	..i (##class(web.DHCEQ.Plat.CTCComponentSet).GetComponentItemVisitFlag(ItemID,GroupID)=1) s THidden="Y"
	..s TImage=$p(DataList,"^",17)
	..s TLinkComponent=$p(DataList,"^",18)
	..s TLinkConditionalExp=$p(DataList,"^",19)
	..s TLinkExpression=##class(web.DHCEQCommon).Replace($p(DataList,"^",20),"'","")
	..s TLinkUrl=$p(DataList,"^",21)
	..s TLinkWorkFlow=$p(DataList,"^",22)
	..s TListCellStyle=$p(DataList,"^",23)
	..s TLookupBrokerMethod=$p(DataList,"^",24)
	..s TLookupClassName=$p(DataList,"^",25)
	..s TLookupCustomComponent=$p(DataList,"^",26)
	..s TLookupJavascriptFunction=$p(DataList,"^",27)
	..s TLookupProperties=$p(DataList,"^",28)
	..s TLookupQueryName=$p(DataList,"^",29)
	..s TLookupUserDefined=$p(DataList,"^",30)
	..s TLookupUserDefinedValues=$p(DataList,"^",31)
	..s TNestedComponent=$p(DataList,"^",32)
	..s TNestedCondExpr=$p(DataList,"^",33)
	..s TOrderMode=$p(DataList,"^",34)
	..//modified by ZY0279 输出控制在js中处理
	..//Modify By zx 2020-02-20 BUG ZX0076 处理排序
	..//i TOrderMode>0 s TOrderMode="true" //不为空表示可排序,默认升序或降序暂不处理
	..s TPassword=$p(DataList,"^",35)
	..s TReadOnly=$p(DataList,"^",36)
	..i $p(EXDataList,"^",9)'="" s TReadOnly=$p(EXDataList,"^",9)
	..s TReferencedObject=$p(DataList,"^",37)
	..s TRequired=$p(EXDataList,"^",11)  //Modified By QW20200108 BUG:QW0034 必填项从DHCEQCComponentSetItem中取出
	..s TShortcutKey=$p(DataList,"^",39)
	..s TShowInNewWindow=$p(DataList,"^",40)
	..s TStyle=$p(DataList,"^",41)
	..i $p(EXDataList,"^",8)'="" s TStyle=$p(EXDataList,"^",8)
	..s TTabSequence=$p(DataList,"^",42)
	..s TTooltip=$p(DataList,"^",43)
	..s TValueGet=$p(DataList,"^",44)
	..s TValueSet=$p(DataList,"^",45)
	..s TSaveFlag=$p(EXDataList,"^",12)  //Add By QW20200108 BUG:QW0034 增加输出TSaveFlag
	..s TTableName=$p(DataList,"^",47)   //Add By QW20200108 BUG:QW0034 增加输出TTableName
	..s TSort=##Class(web.DHCEQ.Lib.Common).Trim(Sort)
	..//modified by ZY0213
	..s TItemType=$p(DataList,"^",48)
	..s TMultiFLag=$p(DataList,"^",49)
	..s THold1=$p(DataList,"^",50)
	..s THold2=$p(DataList,"^",51)
	..s THold3=$p(DataList,"^",52)
	..s THold4=$p(DataList,"^",53)
	..s THold5=$p(DataList,"^",54)
	..s TAreaID=$p(EXDataList,"^",14)   //Add By QW20200622  增加输出TAreaID
	..i TAreaID'="" s TAreaID=$p($g(^DHCEQCCode("DHCEQCComponentZone",TAreaID)),"^",2) //Add By QW20200622  增加输出TAreaID
	..s TDisplayOnly=$p(EXDataList,"^",6)  //Add By QW20200622  增加输出TDisplayOnly
	..d OutputRowComponentSetItem
	
	Quit $$$OK
OutputRowComponentSetItem
	set Data=$lb(TRowID,TName,TCaption,TCaptionStyle,TClassMethod,TClassMethodIfDirty,TCustomExpression,TDataType,TDefaultValueAlways,TDefaultValueExpression,TDescription,TDisabled,TDisplayOnly,TDisplayType,THelpUrl,THidden,TImage,TLinkComponent,TLinkConditionalExp,TLinkExpression,TLinkUrl,TLinkWorkFlow,TListCellStyle,TLookupBrokerMethod,TLookupClassName,TLookupCustomComponent,TLookupJavascriptFunction,TLookupProperties,TLookupQueryName,TLookupUserDefined,TLookupUserDefinedValues,TNestedComponent,TNestedCondExpr,TOrderMode,TPassword,TReadOnly,TReferencedObject,TRequired,TShortcutKey,TShowInNewWindow,TStyle,TTabSequence,TTooltip,TValueGet,TValueSet,TSort,TSaveFlag,TTableName,TItemType,TMultiFLag,THold1,THold2,THold3,THold4,THold5,TAreaID)  //Modified By QW20200108 BUG:QW0034 增加输出TSaveFlag,TTableName
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetComponentSetItem
	Set (TRowID,TName,TCaption,TCaptionStyle,TClassMethod,TClassMethodIfDirty,TCustomExpression,TDataType,TDefaultValueAlways,TDefaultValueExpression,TDescription,TDisabled,TDisplayOnly,TDisplayType,THelpUrl,THidden,TImage,TLinkComponent,TLinkConditionalExp,TLinkExpression,TLinkUrl,TLinkWorkFlow,TListCellStyle,TLookupBrokerMethod,TLookupClassName,TLookupCustomComponent,TLookupJavascriptFunction,TLookupProperties,TLookupQueryName,TLookupUserDefined,TLookupUserDefinedValues,TNestedComponent,TNestedCondExpr,TOrderMode,TPassword,TReadOnly,TReferencedObject,TRequired,TShortcutKey,TShowInNewWindow,TStyle,TTabSequence,TTooltip,TValueGet,TValueSet,TSort,TSaveFlag,TTableName,TItemType,TMultiFLag,THold1,THold2,THold3,THold4,THold5,TAreaID)=""  //Modified By QW20200108 BUG:QW0034 增加输出TSaveFlag,TTableName
	Quit
}

ClassMethod ComponentSetItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ComponentSetItemExecute ]
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

ClassMethod ComponentSetItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ComponentSetItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By DJ 2018-07-06
/// w ##Class(web.DHCEQ.Plat.CTCComponentSet).GetComponentsInfo(",DHCEQMMaintRequest_MRObjLoc,DHCEQMMaintRequest_MRExObj,DHCEQMMaintRequest_MREquipStatus,DHCEQMMaintRequest_MRRequestUser")
ClassMethod GetComponentsInfo(vComponentNames As %String = "")
{
	new ComponentID,Caption,ClassName,QueryName,ComponentParasDR,Paras,Code,ValueType,Value,Paras,CurComponent,CRowID,ComponentsInfo
	s (ComponentID,Caption,ClassName,QueryName,ComponentParasDR,Paras,Code,ValueType,Value,Paras,CurComponent)=""
	
	s ComponentsInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	i vComponentNames="" q ""
	s i=0
	f i=1:1:$L(vComponentNames,",")  d
	.s CurComponent=$p(vComponentNames,",",i)
	.q:CurComponent=""
	.s ComponentID=""
	.s CRowID=0
	.f  s CRowID=$o(^DHCEQCCode("DHCEQCComponent",0,"Name",CurComponent,CRowID))  q:(CRowID="")||(ComponentID'="")  d
	..q:$p($g(^DHCEQCCode("DHCEQCComponent",CRowID)),"^",12)="Y"
	..s ComponentID=CRowID
	.q:ComponentID=""
	.s ComponentName=$p($g(^DHCEQCCode("DHCEQCComponent",ComponentID)),"^",1)
	.s Caption=$p($g(^DHCEQCCode("DHCEQCComponent",ComponentID)),"^",2)
	.s ClassName=$p($g(^DHCEQCCode("DHCEQCComponent",ComponentID)),"^",4)
	.s QueryName=$p($g(^DHCEQCCode("DHCEQCComponent",ComponentID)),"^",5)
	.s IDField=$p($g(^DHCEQCCode("DHCEQCComponent",ComponentID)),"^",14)
	.i IDField'="" s IDField=$p($g(^DHCEQCCode("DHCEQCComponentItem",IDField)),"^",2)
	.s TextField=$p($g(^DHCEQCCode("DHCEQCComponent",ComponentID)),"^",15)
	.i TextField'="" s TextField=$p($g(^DHCEQCCode("DHCEQCComponentItem",TextField)),"^",2)
	.//modified by ZY0197 2019-11-27
	.s DefaultSize=$p($g(^DHCEQCCode("DHCEQCComponent",ComponentID)),"^",16)
	.s ComponentParasDR=0
	.s Paras=""
	.f  s ComponentParasDR=$o(^DHCEQCCode("DHCEQCComponentParas",0,"ComponentDR",ComponentID,ComponentParasDR)) q:ComponentParasDR=""  d
	..s Code=$p($g(^DHCEQCCode("DHCEQCComponentParas",ComponentParasDR)),"^",2)
	..s Position=$p($g(^DHCEQCCode("DHCEQCComponentParas",ComponentParasDR)),"^",3)
	..s ValueType=$p($g(^DHCEQCCode("DHCEQCComponentParas",ComponentParasDR)),"^",4)
	..s Value=$p($g(^DHCEQCCode("DHCEQCComponentParas",ComponentParasDR)),"^",5)
	..i Paras'="" s Paras=Paras_"#"
	..s Paras=Paras_Code_"*"_Position_"*"_ValueType_"*"_Value
	.//modified by ZY0197 2019-11-27
	.s CurComponentInfo=ComponentID_"^"_CurComponent_"^"_Caption_"^"_ClassName_"^"_QueryName_"^"_Paras_"^"_IDField_"^"_TextField_"^"_DefaultSize
	.d ComponentsInfo.%Set(CurComponent,CurComponentInfo)
	
	q ComponentsInfo.%ToJSON()
}

/// add by lmm 2018-10-09
/// 查询所有的设置信息
/// 入参：SourceType	设置的类型
/// 	 SourceID    	类型ID
/// 	 ComponentID 	组件id
/// Modified By QW20200108 BUG:QW0034 增加输入ComponentSetKey 增加输出TComponentSetKey
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTCComponentSet","GetComponentSet","","","")
Query GetComponentSet(SourceType As %String = "", SourceID As %String = "", ComponentID As %String = "", ComponentSetKey As %String = "") As %Query(ROWSPEC = "TRowID:%String,TComponentID:%String,TSourceType:%String,TSourceTypeDesc:%String,TSourceID:%String,TSource:%String,TComponentName:%String,TLayout:%String,TComponentDesc:%String,THold1:%String,TComponentSetKey:%String")
{
}

ClassMethod GetComponentSetExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "", ComponentID As %String = "", ComponentSetKey As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCComponentSet",rowid)) q:rowid=""  d
 	.s TRowID=rowid
 	.s DataList=$g(^DHCEQCCode("DHCEQCComponentSet",rowid))
 	.;Add By QW20200108 BUG:QW0034 begin  增加输入ComponentSetKey 输出TComponentSetKey
 	.s TComponentSetKey=$p(DataList,"^",9)
 	.quit:(ComponentSetKey'="")&&(TComponentSetKey'=ComponentSetKey)
 	.;Add By QW20200108 BUG:QW0034 end
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
	set Data=$lb(TRowID,TComponentID,TSourceType,TSourceTypeDesc,TSourceID,TSource,TComponentName,TLayout,TComponentDesc,THold1,TComponentSetKey) ;Modified By QW20200108 BUG:QW0034
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

/// add by lmm 2018-10-09
/// 描述：组件对应的所有元素信息
/// 入参：ComponentSetID 组件设置id
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
	..i TCaption="" s TCaption=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",3)
	..i TCaptionStyle="" s TCaptionStyle=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",4)
	..i TDisabled="" s TDisabled=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",5)
	..i TDisplayOnly="" s TDisplayOnly=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",6)
	..i THidden="" s THidden=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",7)
	..i TStyle="" s TStyle=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",8)
	..i TReadOnly="" s TReadOnly=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",9)
	..s TSort=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",10)
	..;Modified By QW20200108 BUG:QW0034 begin中间增加3个字段
	..s THold1=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",14)
	..s THold2=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",15)
	..s THold3=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",16)
	..s THold4=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",17)
	..s THold5=$p(($g(^DHCEQCCode("DHCEQCComponentSetItem",TCSIRowID))),"^",18)
	..;Modified By QW20200108 BUG:QW0034 begin中间增加3个字段
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

/// Creator：      ZX
/// CreatDate：    2020-06-10
/// Description:   移动端通过列定义名一次获取列定义信息及列名
/// Table：        DHC_EQCComponent,DHC_EQCComponentItem
/// Input：        RowID:台账ID
/// Return：       表数据解析 json返回
/// w ##Class(web.DHCEQ.Plat.CTCComponentSet).WechatComponentInfo("EM.L.EquipCat")
ClassMethod WechatComponentInfo(ComponentName As %String = "")
{
	i ComponentName="" q ""
	
	s ComponentsInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s ComponentID=$o(^DHCEQCCode("DHCEQCComponent",0,"Name",ComponentName,""))
	i ComponentID'="" d
	.q:$p($g(^DHCEQCCode("DHCEQCComponent",ComponentID)),"^",12)="Y"
	.q:ComponentID=""
	.s Caption=$p($g(^DHCEQCCode("DHCEQCComponent",ComponentID)),"^",2)
	.s ClassName=$p($g(^DHCEQCCode("DHCEQCComponent",ComponentID)),"^",4)
	.d ComponentsInfo.%Set("ClassName",ClassName)
	.s QueryName=$p($g(^DHCEQCCode("DHCEQCComponent",ComponentID)),"^",5)
	.d ComponentsInfo.%Set("QueryName",QueryName)
	.s IDField=$p($g(^DHCEQCCode("DHCEQCComponent",ComponentID)),"^",14)
	.i IDField'="" s IDField=$p($g(^DHCEQCCode("DHCEQCComponentItem",IDField)),"^",2)
	.d ComponentsInfo.%Set("IDField",IDField)
	.s TextField=$p($g(^DHCEQCCode("DHCEQCComponent",ComponentID)),"^",15)
	.i TextField'="" s TextField=$p($g(^DHCEQCCode("DHCEQCComponentItem",TextField)),"^",2)
	.d ComponentsInfo.%Set("TextField",TextField)
	.s ComponentItemInfo=""
	.s ComponentItemID=0
	.f  s ComponentItemID=$o(^DHCEQCCode("DHCEQCComponentItem",0,"Component",ComponentID,ComponentItemID)) q:ComponentItemID=""  d
	..s ComponentItemName=$p($g(^DHCEQCCode("DHCEQCComponentItem",ComponentItemID)),"^",2)
	..s ComponentItemHiddenFlag=$p($g(^DHCEQCCode("DHCEQCComponentItem",ComponentItemID)),"^",16)
	..i ComponentItemInfo'="" s ComponentItemInfo=ComponentItemInfo_"^"
	..s ComponentItemInfo=ComponentItemInfo_ComponentItemName_","_ComponentItemHiddenFlag
	.d ComponentsInfo.%Set("ComponentItemInfo",ComponentItemInfo)
	
	q ComponentsInfo.%ToJSON()
}

/// add by QW 2020-06-02
/// 查询所有的设置信息
/// 入参：BussType	    业务类型
/// 	 ComponentSetKey    	组件设置key值
/// 	 ApproveSetDR 	 审批设置id
///      ApproveRole     审批角色
///      ActionDR        动作id
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTCComponentSet","GetComponentZone","85","1","94","18","18","YS_Audit4")
Query GetComponentZone(GroupID As %String = "", UserID As %String = "", HosptailID As %String = "", ApproveSetDR As %String = "", ApproveRole As %String = "", Action As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TTitle:%String,TTitleID:%String,TSort:%String,TStyle:%String,THidden:%String,TReadOnly:%String")
{
}

ClassMethod GetComponentZoneExecute(ByRef qHandle As %Binary, GroupID As %String = "", UserID As %String = "", HosptailID As %String = "", ApproveSetDR As %String = "", ApproveRole As %String = "", Action As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	if ((ApproveSetDR'="")&&((ApproveRole'=""))||(Action'=""))
    {
	    //Modify by zx 2020-12-31 BUG ZX0126
	    i UserID ="" s UserID = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
		i GroupID ="" s GroupID = %session.Get("LOGON.GROUPID")
		i HosptailID="" s HosptailID=%session.Data("LOGON.HOSPID")
		
	    s ApproveFlowDR=""
		if (Action'="") 
		{
			s ActionDR=$o(^DHCEQCCode("DHCEQCAction",0,"Code",Action,0))
			i ActionDR'="" s ApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSetDR,ActionDR,0))
		}
		else  
		{
			s ApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSetDR,ApproveRole,0))
		}
		s ComponentSetID=""
		i ApproveFlowDR'="" s ComponentSetID=$p(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR),"^",19)
		i (ComponentSetID="")&&(Action="") Quit $$$OK
		
		//获取同一key值下SourceType值下限
		s CurSourceType=0  //初始为系统级
		s ComponentID=""
		s CurComponentID=""
		s CurComponentSetID=0
		f  s CurComponentSetID=$o(^DHCEQCCode("DHCEQCComponentSet",0,"ComponentSetKey",Action,CurComponentSetID)) q:CurComponentSetID=""  d
		.s ComponentID=$p($g(^DHCEQCCode("DHCEQCComponentSet",CurComponentSetID)),"^",3)  //获取列定义id,同一key的列定义id相同
		.s SourceType=$p($g(^DHCEQCCode("DHCEQCComponentSet",CurComponentSetID)),"^",1)
		.s SourceID=$p($g(^DHCEQCCode("DHCEQCComponentSet",CurComponentSetID)),"^",2)  //设置SourceID
		.s ParamSourceID=$Case(+SourceType,"0":"0","1":HosptailID,"2":GroupID,"3":UserID,:"")  //实际SourceID
		.//Modefied by zc0117 20220428  修改移动端列定义取值 begin
		.;i (SourceID=ParamSourceID)&&(+SourceType>CurSourceType) d
		.;.s CurSourceType=+SourceType
		.;.s CurComponentID=ComponentID
		.i SourceID=ParamSourceID d
		..i (ComponentSetID="")&&(+SourceType>=CurSourceType) d
		...s CurSourceType=+SourceType
		...s CurComponentID=ComponentID
		..e  i (ComponentSetID'="")&&(+SourceType>CurSourceType) d
		...s CurSourceType=+SourceType
		...s CurComponentID=ComponentID
		.//Modefied by zc0117 20220428  修改移动端列定义取值 end
		//确定SourceType值下限后匹配SourceID
		s CurSourceID=$Case(CurSourceType,"0":"0","1":HosptailID,"2":GroupID,"3":UserID,:"")
		s CurComponentSetID=""
		i (CurSourceID'="")&&(CurComponentID'="") d
		.s CurComponentSetID=$o(^DHCEQCCode("DHCEQCComponentSet",0,"SourceComponent",CurSourceType,CurSourceID,CurComponentID,0))
		i CurComponentSetID'="" s ComponentSetID=CurComponentSetID
		i +ComponentSetID=0 Quit $$$OK
		s nodestr="web.DHCEQ.Plat.CTCComponentSet_GetComponentZone"
		s Date=+$H
		s Job=$J
		d ##class(web.DHCEQCommon).KillTempGlobal(nodestr)
		s rowid=0
		f  s rowid=$o(^DHCEQCCode("DHCEQCComponentSetItem",0,"Zone",ComponentSetID,rowid)) q:rowid=""  d
		.q:$p($g(^DHCEQCCode("DHCEQCComponentZone",rowid)),"^",9)="Y"
		.s Sort=$p($g(^DHCEQCCode("DHCEQCComponentZone",rowid)),"^",6)
		.s ^DHCEQTemp(nodestr,Date,Job,UserID,+Sort,rowid)=$g(^DHCEQCCode("DHCEQCComponentZone",rowid))
		
		s tmpsort=""
		f  s tmpsort=$o(^DHCEQTemp(nodestr,Date,Job,UserID,tmpsort)) q:tmpsort=""  d
		.s id=0
		.f  s id=$o(^DHCEQTemp(nodestr,Date,Job,UserID,tmpsort,id)) q:id=""  d
		..d ResetGetComponentZone
		..s ZoneList=$g(^DHCEQTemp(nodestr,Date,Job,UserID,tmpsort,id))
		..d GetComponentZoneInfo
		d ##class(web.DHCEQCommon).KillTempGlobal(nodestr)
    }

	Quit $$$OK
GetComponentZoneInfo
 	s TRowID=id
 	s TCode=$p(ZoneList,"^",2)
 	s TDesc=$p(ZoneList,"^",3)
 	s TTitle=$p(ZoneList,"^",4)
 	s TTitleID=$p(ZoneList,"^",5)
 	s TSort=$p(ZoneList,"^",6)
 	s TStyle=$p(ZoneList,"^",7)
 	s TReadOnly=$p(ZoneList,"^",8)
	d OutputRowGetComponentZone
	quit
OutputRowGetComponentZone
	set Data=$lb(TRowID,TCode,TDesc,TTitle,TTitleID,TSort,TStyle,THidden,TReadOnly)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetGetComponentZone
	Set (TRowID,TZoneID,TTitle,TTitleID,TSort,TStyle,THidden,TReadOnly)=""
	Quit
}

ClassMethod GetComponentZoneFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetComponentZoneExecute ]
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

ClassMethod GetComponentZoneClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetComponentZoneExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by ZY0271 20210618
/// 用于获取组件列定义元素的是否为敏感信息0:不是,1:隐藏,2:password样式显示
/// w ##class(web.DHCEQ.Plat.CTCComponentSet).initElementVisit("EM.P.OpenCheckRequest" ,"OriginalFee","85")
ClassMethod initElementVisit(ComponentName, ItemName, GroupID)
{
	new ComponentID,ItemID,DataList,TItemType,TName,VisitFlag
	i GroupID ="" s GroupID = %session.Get("LOGON.GROUPID")
	s VisitFlag=0
	s ComponentID=0
	f  s ComponentID=$o(^DHCEQCCode("DHCEQCComponent",0,"Name",ComponentName,ComponentID)) q:(ComponentID="")  d
	.quit:$p($g(^DHCEQCCode("DHCEQCComponent",ComponentID)),"^",12)="Y"
	.s ItemID=0
	.f  s ItemID=$o(^DHCEQCCode("DHCEQCComponentItem",0,"Component",ComponentID,ItemID))  quit:ItemID=""  d
	..s DataList=$g(^DHCEQCCode("DHCEQCComponentItem",ItemID))
	..s TItemType=$p(DataList,"^",48)
	..q:TItemType'=1
	..s TName=$p(DataList,"^",2)
	..i (TName=ItemName) s VisitFlag=##class(web.DHCEQ.Plat.CTCComponentSet).GetComponentItemVisitFlag(ItemID ,GroupID)
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(VisitFlag)
}

/// add by ZY0271 20210618
/// 用于获取组件列定义元素的是否为敏感信息0:不是,1:隐藏,2:password样式显示
/// w ##class(web.DHCEQ.Plat.CTCComponentSet).GetComponentItemVisitFlag(85 ,321)
ClassMethod GetComponentItemVisitFlag(ItemID, GroupID)
{
	new displayType,CIVRowID
	s displayType=0
	i $Data(^DHCEQCCode("DHCEQCComponentItemVisit",0,"ComponentItem",GroupID,ItemID))
	{
		s CIVRowID=$o(^DHCEQCCode("DHCEQCComponentItemVisit",0,"ComponentItem",GroupID,ItemID,0))
		i CIVRowID'="" s displayType=$p($g(^DHCEQCCode("DHCEQCComponentItemVisit",CIVRowID)),"^",3)
	}
	q displayType
}

}
