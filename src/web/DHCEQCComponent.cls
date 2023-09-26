/// creator zy  2017-04-06  YZ0162
/// 主要用于jQuery界面中datagrid的columns信息的编辑
Class web.DHCEQCComponent Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by zy 2017-4-6  ZY0162
/// 获取一个组件的所有元素信息
/// 入参：ComponentID	元素ID  DHC_EQCComponent表的ID
/// d ##class(%ResultSet).RunQuery("web.DHCEQCComponent","GetComponentItem","45")
/// modify by lmm 2018-11-09 增加出参：TFrozen TDataTypeDesc
Query GetComponentItem(ComponentID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TCaption:%String,TCaptionStyle:%String,TClassMethod:%String,TClassMethodIfDirty:%String,TCustomExpression:%String,TDataType:%String,TDefaultValueAlways:%String,TDefaultValueExpression:%String,TDescription:%String,TDisabled:%String,TDisplayOnly:%String,TDisplayType:%String,THelpUrl:%String,THidden:%String,TImage:%String,TLinkComponent:%String,TLinkConditionalExp:%String,TLinkExpression:%String,TLinkUrl:%String,TLinkWorkFlow:%String,TListCellStyle:%String,TLookupBrokerMethod:%String,TLookupClassName:%String,TLookupCustomComponent:%String,TLookupJavascriptFunction:%String,TLookupProperties:%String,TLookupQueryName:%String,TLookupUserDefined:%String,TLookupUserDefinedValues:%String,TNestedComponent:%String,TNestedCondExpr:%String,TOrderMode:%String,TPassword:%String,TReadOnly:%String,TReferencedObject:%String,TRequired:%String,TShortcutKey:%String,TShowInNewWindow:%String,TStyle:%String,TTabSequence:%String,TTooltip:%String,TValueGet:%String,TValueSet:%String,TDisplayTypeDesc:%String,TFrozen:%String,TDataTypeDesc:%String")
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
	.s TDataTypeDesc=##Class(web.DHCEQCComponent).ElementDataType(TDataType)
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
	.s TFrozen=$p(DataList,"^",46)
	.d OutputRowGetComponentItem
	Quit $$$OK
OutputRowGetComponentItem
	set Data=$lb(TRowID,TName,TCaption,TCaptionStyle,TClassMethod,TClassMethodIfDirty,TCustomExpression,TDataType,TDefaultValueAlways,TDefaultValueExpression,TDescription,TDisabled,TDisplayOnly,TDisplayType,THelpUrl,THidden,TImage,TLinkComponent,TLinkConditionalExp,TLinkExpression,TLinkUrl,TLinkWorkFlow,TListCellStyle,TLookupBrokerMethod,TLookupClassName,TLookupCustomComponent,TLookupJavascriptFunction,TLookupProperties,TLookupQueryName,TLookupUserDefined,TLookupUserDefinedValues,TNestedComponent,TNestedCondExpr,TOrderMode,TPassword,TReadOnly,TReferencedObject,TRequired,TShortcutKey,TShowInNewWindow,TStyle,TTabSequence,TTooltip,TValueGet,TValueSet,TDisplayTypeDesc,TFrozen,TDataTypeDesc)
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

/// add by zy 2017-4-6  ZY0162
/// 组件信息编辑界面的保存
/// 入参:val	主表的信息
/// 	 listVal 明细信息 多条明细中间用&连接
/// 	 Delis   操作类型：1 删除  0 或""  是更新
/// Modified By QW20200108 BUG:QW0034 增加入参ComponentSetKey
/// w ##Class(web.DHCEQCComponent).SaveData("^EM.L.GetMasterItemaaa^设备项^width:100,align:center^web.DHCEQ.EM.CTMasterItem^GetMasterItem^TName^名称^^^^^^","1^TName^1^^^&2^TCa^2^^^&3^TCas^3^^^",0)
ClassMethod SaveData(val, listVal, Delis, Sort As %String = "", ComponentSetKey = "")
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	//s User=1
	//s RowID=$P(val,"^",1)
	s Date=+$H
	s Time=$P($H,",",2)
	
	k PList,rowid
	s rowid=$P(val,"^",1)
	Set $ZT="ERRORSave"
	TStart
	if Delis=1
	{
		//Modefied by zc 2017-5-22  begin
		s PList(10)=Date	//Date    
		s PList(11)=Time	//Time
		s PList(12)=User	//User		
		//Modefied by zc 2017-5-22  end
		s PList(13)="Y"		//InvalidFlag  
		&SQL(Update SQLUser.DHC_EQCComponent values :PList() where C_RowID=:rowid)
	}
	else
	{
		s PList(2)=$P(val,"^",2)		//Name
		s PList(3)=$P(val,"^",3)		//Caption
		s PList(4)=$P(val,"^",4)		//CaptionStyle
		s PList(5)=$P(val,"^",5)		//ClassName
		s PList(6)=$P(val,"^",6)		//QueryName
		s PList(7)=$P(val,"^",7)		//Template
		s PList(8)=$P(val,"^",8)		//Specification
		s PList(9)=$P(val,"^",9)		//Remark
		//Modefied by zc 2017-5-22  begin
		s PList(10)=Date	//Date
		s PList(11)=Time	//Time
		s PList(12)=User	//User
		//Modefied by zc 2017-5-22  end
		s PList(13)="N"		//InvalidFlag
		s PList(14)=##class(web.DHCEQCommon).TransValueFromPage($P(val,"^",10),"bool")
		i $P(val,"^",11)'="" s PList(15)=$P(val,"^",11)  //modify by lmm 2019-08-06  解决重复赋空
		i $P(val,"^",12)'="" s PList(16)=$P(val,"^",12) //modify by lmm 2019-08-06
		s PList(17)=$P(val,"^",13)
		s PList(18)=$P(val,"^",14)
		s tmpid=""
		&SQL(select C_RowID into :tmpid from sqluser.DHC_EQCComponent where C_Name=:PList(2)  and C_InvalidFlag='N')
		i rowid="" s rowid=tmpid
		i ((tmpid'="")&&(tmpid'=rowid)) q "-1000^数据有重复"	;重复记录
		i rowid=""
		{
			&SQL(Insert Into SQLUser.DHC_EQCComponent values :PList())
			s rowid=$g(%ROWID)
		}
		else
		{
			&SQL(Update SQLUser.DHC_EQCComponent values :PList() where C_RowID=:rowid)
			i SQLCODE=100 s SQLCODE=0
		}
		if SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s SQLCODE=##Class(web.DHCEQCComponent).SaveListData(rowid,listVal,Sort,ComponentSetKey) //Modified By QW20200108 BUG:QW0034 增加入参ComponentSetKey
		if SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		//add by lmm 2018-09-29 begin
		
		s SQLCODE=##Class(web.DHCEQCComponent).UpdateHoldData(rowid,listVal)
		if SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		
		//add by lmm 2018-09-29 end
		
		s ClassName=PList(5)
		s QueryName=PList(6)
		s result=##Class(web.DHCEQCComponent).AutoSaveColumns(ClassName, QueryName)
		s cols=$p(result,"^",1)
		s colsLen=$l(cols)
		
		//modify by lmm 2018-09-29 不使用表结构字段名作变量名
		/*
		f i=1:1:colsLen d
		.q:SQLCODE'=0
		.k PLISTMX
		.s PLISTMX(2)=rowid				;ComponentDR
		.s PLISTMX(3)=$p(cols,":",i)	;Name
		.q:PLISTMX(3)=""
		.s PLISTMX(15)=0					;DataType
		.
		.s tmpid=""
		.&SQL(select CI_RowID Into :tmpid from SQLUSER.DHC_EQCComponentItem where CI_ComponentDR=:PLISTMX(2) and CI_Name=:PLISTMX(3))
		.i tmpid="" &SQL(Insert Into SQLUSER.DHC_EQCComponentItem Values :PLISTMX())

		s params=$p(result,"^",2)
		s paramsLen=$l(params)
		f i=1:1:paramsLen d
		.q:SQLCODE'=0
		.k PLISTMX
		.s PLISTMX(2)=rowid				;ComponentDR
		.s PLISTMX(3)=$p(params,":",i)	;Name
		.q:PLISTMX(3)=""
		.s PLISTMX(5)=1					;ValueType
		.s PLISTMX(6)=""				;Value
		.
		.s tmpid=""
		.&SQL(select CP_RowID Into :tmpid from SQLUSER.DHC_EQCComponentParas where CP_ComponentDR=:PLISTMX(2) and CP_Code=:PLISTMX(3))
		.i tmpid="" &SQL(Insert Into SQLUSER.DHC_EQCComponentParas Values :PLISTMX())
		*/  //modify by lmm 2018-11-09
		
	}
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q rowid
ERRORSave 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// add by zy 2017-4-6  ZY0162
/// 组件元素信息编辑界面的保存
/// 入参：ComponentID	组件ID
/// 	 listVal 明细信息 多条明细中间用&连接
/// Modified By QW20200108 BUG:QW0034 增加入参ComponentSetKey
ClassMethod SaveListData(ComponentID, listVal, Sort As %String = "", ComponentSetKey = "")
{
	new Length,CIRowID,Flag,i,User
	n List,TSourceType,TSourceID
	
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k CSPLIST,CSLPLIST,PLISTMX
	i listVal="" q 0
	i ComponentID="" q -1
	
	s Length=$l(listVal,"#")
	s PLISTMX(2)=ComponentID  				;ComponentDR
	if Sort'=""
	{
		//查找当前组件的设置记录
		s ComponentSetID=""
		s (FindID,SQLCODE,CSRowID)=0
		f  s CSRowID=$o(^DHCEQCCode("DHCEQCComponentSet",0,"SourceComponent",0,0,ComponentID,CSRowID))  q:(CSRowID="")||(FindID'=0)  d
		.s CSInvalidFlag=$p($g(^DHCEQCCode("DHCEQCComponentSet",CSRowID)),"^",8)
		.;Modified By QW20200108 BUG:QW0034 begin
		.s CSComponentSetKey=$p($g(^DHCEQCCode("DHCEQCComponentSet",CSRowID)),"^",9)
		.q:CSInvalidFlag="Y"
		.q:(ComponentSetKey'="")&&(CSComponentSetKey'=ComponentSetKey)
		.;Modified By QW20200108 BUG:QW0034 begin
		.s FindID=CSRowID
		i FindID=0
		{
			s CSPLIST(2)=0
			s CSPLIST(3)=0
			s CSPLIST(4)=ComponentID
			s CSPLIST(5)=""
			s CSPLIST(6)=+$H
			s CSPLIST(7)=$p($H,",",2)
			s CSPLIST(8)=User
			s CSPLIST(9)="N"
			//Modified By QW20200108 BUG:QW0034 begin 表结构修改User.DHCEQCComponentSet
			s CSPLIST(10)=ComponentSetKey
			s CSPLIST(11)=""
			s CSPLIST(12)=""
			s CSPLIST(13)=""
			s CSPLIST(14)=""
			s CSPLIST(15)=""
			//Modified By QW20200108 BUG:QW0034 End 表结构修改User.DHCEQCComponentSet
			&SQL(insert into SQLUSER.DHC_EQCComponentSet values :CSPLIST())
			i SQLCODE q SQLCODE
			s ComponentSetID=$G(%ROWID)
		}
		else
		{
			s ComponentSetID=FindID
		}
		i ComponentSetID="" q "" //没有设置信息时,不能继续
	}
	
	s Flag=0
	for i=1:1:Length
	{
		q:Flag'=0
		s List=	$p(listVal,"#",i)
		//s CIRowID= $p(List,"^",1)    //modify by lmm 2018-10-20 重写变量值
		s PLISTMX(3)=$p(List,"^",2)  	;Name
		q:PLISTMX(3)=""					//czf 2021-05-17 
		s PLISTMX(4)=$p(List,"^",3)		;Caption
		s PLISTMX(5)=$p(List,"^",4)		;CaptionStyle
		s PLISTMX(6)=$p(List,"^",5)		;ClassMethod
		s PLISTMX(7)=$p(List,"^",6)		;ClassMethodIfDirty
		s PLISTMX(8)=$p(List,"^",7)		;CustomExpression
		s PLISTMX(9)=$p(List,"^",8)		;DataType
		s PLISTMX(10)=$p(List,"^",9)		;DefaultValueAlways
		s PLISTMX(11)=$p(List,"^",10)		;DefaultValueExpression
		s PLISTMX(12)=$p(List,"^",11)		;Description
		s PLISTMX(13)=$p(List,"^",12)		;Disabled
		s PLISTMX(14)=$p(List,"^",13)		;DisplayOnly
		s PLISTMX(15)=$p(List,"^",14)	//##Class(web.DHCEQCComponent).ElementType($p(List,"^",14))		;DisplayType
		s PLISTMX(16)=$p(List,"^",15)		;HelpUrl
		s PLISTMX(17)=$p(List,"^",16)		;Hidden
		s PLISTMX(18)=$p(List,"^",17)		;Image
		s PLISTMX(19)=$p(List,"^",18)		;LinkComponent
		s PLISTMX(20)=$p(List,"^",19)		;LinkConditionalExp
		s PLISTMX(21)=$p(List,"^",20)		;LinkExpression
		s PLISTMX(22)=$p(List,"^",21)		;LinkUrl
		s PLISTMX(23)=$p(List,"^",22)		;LinkWorkFlow
		s PLISTMX(24)=$p(List,"^",23)		;ListCellStyle
		s PLISTMX(25)=$p(List,"^",24)		;LookupBrokerMethod
		s PLISTMX(26)=$p(List,"^",25)		;LookupClassName
		s PLISTMX(27)=$p(List,"^",26)		;LookupCustomComponent
		s PLISTMX(28)=$p(List,"^",27)		;LookupJavascriptFunction
		s PLISTMX(29)=$p(List,"^",28)		;LookupProperties
		s PLISTMX(30)=$p(List,"^",29)		;LookupQueryName
		s PLISTMX(31)=$p(List,"^",30)		;LookupUserDefined
		s PLISTMX(32)=$p(List,"^",31)		;LookupUserDefinedValues
		s PLISTMX(33)=$p(List,"^",32)		;NestedComponent
		s PLISTMX(34)=$p(List,"^",33)		;NestedCondExpr
		s PLISTMX(35)=$p(List,"^",34)		;OrderMode
		s PLISTMX(36)=$p(List,"^",35)		;Password
		s PLISTMX(37)=$p(List,"^",36)		;ReadOnly
		s PLISTMX(38)=$p(List,"^",37)		;ReferencedObject
		s PLISTMX(39)=$p(List,"^",38)		;Required
		s PLISTMX(40)=$p(List,"^",39)		;ShortcutKey
		s PLISTMX(41)=$p(List,"^",40)		;ShowInNewWindow
		s PLISTMX(42)=$p(List,"^",41)		;Style
		s PLISTMX(43)=$p(List,"^",42)		;TabSequence
		s PLISTMX(44)=$p(List,"^",43)		;Tooltip
		s PLISTMX(45)=$p(List,"^",44)		;ValueGet //Modified By QW20200108 BUG:QW0034 修正错误
		s PLISTMX(46)=$p(List,"^",45)		;ValueSet
		s PLISTMX(47)=$p(List,"^",50)		;Frozen  ;modify by lmm 2018-11-14
		///modified by ZY0276 20210722
		s PLISTMX(48)=$p(List,"^",59)		;TableName  ;modify by ZY0271 20210621
		s PLISTMX(49)=$p(List,"^",60)		;ItemType  ;modify by ZY0271 20210621	1：控制界面敏感信息时用到
		s PLISTMX(50)=$p(List,"^",61)		;MultiFlag  ;modify by ZY0271 20210621
		
		//add by ZY0213
		s PLISTMX(51)=$p(List,"^",53)
		s PLISTMX(52)=$p(List,"^",54)
		s PLISTMX(53)=$p(List,"^",55)
		s PLISTMX(54)=$p(List,"^",56)
		s PLISTMX(55)=$p(List,"^",57)
		
		;modify by lmm 2019-10-16 begin 添加根据旧列名更新新列明
		s OldItemName=$p(List,"^",51)		;OldItemName  
		
		//add by lmm 2018-10-20 根据名称及组件id查找组件明细id
		&SQL(select CI_RowID into :CIRowID from sqluser.DHC_EQCComponentItem where CI_Name=:PLISTMX(3) and CI_ComponentDR=:ComponentID)
		s OldCIRowID=""
		if (OldItemName'="")
		{
			&SQL(select CI_RowID into :OldCIRowID from sqluser.DHC_EQCComponentItem where CI_Name=:OldItemName and CI_ComponentDR=:ComponentID)
		}
		if ((CIRowID="")&&(OldItemName=""))
		{
			&SQL(Insert Into SQLUSER.DHC_EQCComponentItem Values :PLISTMX())
			s CIRowID=$G(%ROWID)
		}
		elseif ((PLISTMX(3)'="")&&(OldCIRowID'=""))
		{
			&SQL(update sqluser.DHC_EQCComponentItem values :PLISTMX() where CI_RowID=:OldCIRowID)
			i SQLCODE=100 s SQLCODE=0
			s CIRowID=OldCIRowID
		}
		elseif ((CIRowID'="")&&(OldItemName=""))
		{
			&SQL(update sqluser.DHC_EQCComponentItem values :PLISTMX() where CI_RowID=:CIRowID)
			i SQLCODE=100 s SQLCODE=0
		}
		i SQLCODE
 		{
			s Flag=SQLCODE
 		}
		;modify by lmm 2019-10-16 end
		if Sort'=""
		{
	 		//写组件设置明细
	 		//s SetList=	$p(listVal,"#",i)
	 		s DataList=$g(^DHCEQCCode("DHCEQCComponentItem",CIRowID))
			s CSLPLIST(2)=ComponentSetID
			s CSLPLIST(3)=CIRowID
			s CSLPLIST(4)=$p(DataList,"^",3)	;Caption
			s CSLPLIST(5)=$p(DataList,"^",4)	;CaptionStyle
			s CSLPLIST(6)=$p(DataList,"^",12)	;Disabled
			s CSLPLIST(7)=$p(DataList,"^",13)	;DisplayOnly
			s CSLPLIST(8)=$p(DataList,"^",16)	;Hidden
			s CSLPLIST(9)=$p(DataList,"^",41)	;Style
			s CSLPLIST(10)=$p(DataList,"^",36)	;ReadOnly
			s CSLPLIST(11)=$p(List,"^",46)		;Sort  //modify by lmm 2018-09-28
			//Modified By QW20200108 BUG:QW0034 begin 增加字段及导入列-表结构修改User.DHCEQCComponentSetItem
			s CSLPLIST(12)=$p(List,"^",38)      ;Required
			s CSLPLIST(13)=$p(List,"^",52)      ;SaveFlag 
			//add by QW20200628 
			s zoneid="" 
			i $p(List,"^",58)'="" s zoneid=$o(^DHCEQCCode("DHCEQCComponentZone",0,"Code",$p(List,"^",58),0))  //add by QW20200628 
			s CSLPLIST(15)=zoneid			    ;Hold1 //add by QW20200628 
			s CSLPLIST(16)=""					;Hold2
			s CSLPLIST(17)=""					;Hold3
			s CSLPLIST(18)=""					;Hold4
			s CSLPLIST(19)=""					;Hold5
			//Modified By QW20200108 BUG:QW0034 End 增加字段及导入列
			s CSIID=""
			//modify by lmm 2018-09-28 变量修改：CSIID
			&SQL(Select CSI_RowID into :CSIID from SQLUSER.DHC_EQCComponentSetItem where CSI_ComponentSetDR=:ComponentSetID and CSI_ComponentItemDR=:CIRowID)
			if (CSIID="")
			{
				&SQL(Insert Into SQLUSER.DHC_EQCComponentSetItem Values :CSLPLIST())
				s CSIID=$G(%ROWID)
			}
			else
			{
				&SQL(update sqluser.DHC_EQCComponentSetItem values :CSLPLIST() where CSI_RowID=:CSIID)
			}
		}
	}
	q Flag
}

/// add by zy 2017-4-6  ZY0162
/// 元素删除操作
/// 入参：ItemID	组件ID
/// 	 
/// w ##Class(web.DHCEQCComponent).DeleteItemData(2)
ClassMethod DeleteItemData(ItemID)
{
	new tmp
	i ItemID="" q
	s tmp=0
	&SQL(select count(*) into :tmp from sqluser.DHC_EQCComponentSetItem  where CSI_ComponentItemDR=:ItemID)
	i tmp=0
	{
		&SQL(delete from sqluser.DHC_EQCComponentItem  where CI_RowID=:ItemID)
		q SQLCODE
	}
	else
	{
		q tmp
	}
}

/// w ##Class(web.DHCEQCComponent).GetOneComponent(2)
ClassMethod GetOneComponent(rowid)
{
	new result
	s result=""
	s result= ^DHCEQCCode("DHCEQCComponent",rowid)
	s $p(result,"^",13)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",13),"bool")
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// modified by ZY0200
/// 0:text,1:link,2:button,3:checkbox,4:icheckbox,5:switchbox,6:numberbox,7:combobox,
/// 8:validatebox,9:combogrid,10:datebox,11:datetimebox,12:combotree,13:textare
/// w ##Class(web.DHCEQCComponent).ElementDisplayType(2)
ClassMethod ElementDisplayType(DisplayType)
{
	//q $CASE(DisplayType,"":"","0":"text","1":"link","2":"button","3":"checkbox","4":"combobox","5":"combogrid")
	q $CASE(DisplayType,"":"","0":"text","1":"link","2":"button","3":"checkbox","4":"icheckbox","5":"switchbox","6":"numberbox","7":"combobox","8":"validatebox","9":"combogrid","10":"datebox","11":"datetimebox","12":"combotree","13":"textare")
}

/// modified by ZY0200
/// w ##Class(web.DHCEQCComponent).ElementType(2)
ClassMethod ElementType(DisplayType)
{
	//q $CASE(DisplayType,"":"","text":"0","link":"1","button":"2","checkbox":"3","combobox":"4","combogrid":"5")
	q $CASE(DisplayType,"":"","text":"0","link":"1","button":"2","checkbox":"3","icheckbox":"4","switchbox":"5","numberbox":"6","combobox":"7","validatebox":"8","combogrid":"9","datebox":"10","datetimebox":"11","combotree":"12","textare":"13")
}

/// add by zy 2018-3-1 ZY0168
/// 通过query 找到query的参数和输出列
/// 入参：ClassName	类名
/// 	  QueryName query名
/// 输出：cols_"^"_params
/// 	  cols Col1:Col2:Col3:Col4:Col5
/// 	  params param1:param2:param3:param4:param5
/// w ##Class(web.DHCEQCComponent).AutoSaveColumns("web.DHCEQ.Process.DHCEQFind","GetEquipType")
ClassMethod AutoSaveColumns(ClassName, QueryName)
{
	q:'##class(websys.Conversions).IsValidClassName(ClassName) "" ;"Not Find Class: "_ClassName
	q:'##class(websys.Conversions).IsValidQueryName(ClassName,QueryName) "" ;"Not Find Query: "_ClassName_":"_QueryName
	s myobj=##class(%Dictionary.CompiledQuery).%OpenId(ClassName_"||"_QueryName,0)
	s params= $lts(myobj.ParmNames,":")
	s rset=##class(%ResultSet).%New(ClassName_":"_QueryName)
	s columns = rset.GetColumnCount()
	s cols=""
	f i=1:1:columns d
	.s colName=rset.GetColumnName(i)
	.i cols=""  d
	..s cols=colName
	.e  d
	..s cols=cols_":"_colName
	q cols_"^"_params
}

/// add by lmm 2018-09-29
/// 描述：更新组件表中idfield textfield jsfunction
/// 入参：ComponentID 组件id
///       valList  组件明细拼串
/// 返回值：sqlcode
/// modify by lmm 2018-11-08  修复置空数据列bug
/// w ##Class(web.DHCEQCComponent).UpdateHoldData("1","^THold2Desc^院区^width:100,align:center^^^^^^^^^^0^^Y^^^^^^^^^^^^^^^^^^^^^^^^^width:100,align:center^^^^^^TRowID^TName^^"")
ClassMethod UpdateHoldData(ComponentID, valList)
{
	//new (ComponentID,valList)
	k PListHD  
	s CINameId= $p(valList,"^",47)
	s CINameText=$p(valList,"^",48) 
	
	 
	s IdField=""
	s TextField=""
	&SQL(Select CI_RowID into :IdField from SQLUSER.DHC_EQCComponentItem where CI_ComponentDR=:ComponentID and CI_Name=:CINameId)
	&SQL(Select CI_RowID into :TextField from SQLUSER.DHC_EQCComponentItem where CI_ComponentDR=:ComponentID and CI_Name=:CINameText)
	
	///modified by ZY0200
	//add by lmm 2019-08-06 begin 修改重复置空问题
	s (Hold2,Hold3)=""
	&SQL(Select C_ValueItemDR,C_DescItemDR into :Hold2,:Hold3 from SQLUSER.DHC_EQCComponent where C_RowID=:ComponentID)
	if (IdField'="")&&(Hold2="") s PListHD(15)=IdField
	if (TextField'="")&&(Hold3="") s PListHD(16)=TextField
	//add by lmm 2019-08-06 end
	if ($p(valList,"^",49)'="") s PListHD(17)=$p(valList,"^",49)  ;JsFunction	
	//add by lmm 2020-05-20
	if ((IdField="")&&(CINameId'=""))||((TextField="")&&(CINameText'=""))
	{
		s SQLCODE=-1111
	}
	elseif (IdField="")&&(CINameId="")&&(TextField="")&&(CINameText="")&&($p(valList,"^",49)="")
	{
		s SQLCODE=0
	}
	else
	{
		&SQL(Update SQLUser.DHC_EQCComponent values PListHD() where C_RowID=:ComponentID)
		i SQLCODE=100 s SQLCODE=0			
	}
		
	q SQLCODE
}

/// add by zy 2017-4-6  ZY0162
/// 描述：保存组件参数
/// 入参：componentName	组件名
/// 	  componentparaCode 组件入参代码
///       Position  入参位置
///       ValueType  入参类型
///       Value  入参值
/// Modified By QW20200108 BUG:QW0034 begin 增加入参OldParaCode
ClassMethod SaveComponentParaData(componentName, componentparaCode, Position, ValueType, Value As %String = "", OldParaCode As %String = "")
{
	
	k PLISTMX
	s PLISTMX(3)=componentparaCode	;Name
	q:PLISTMX(3)=""
	s PLISTMX(4)=Position
	s PLISTMX(5)=ValueType		;ValueType
	s PLISTMX(6)=Value			;Value
	s CRowID=""
	&SQL(select C_RowID into :CRowID from sqluser.DHC_EQCComponent where C_Name=:componentName  and C_InvalidFlag='N')
	i (CRowID="")
	{ 
		s SQLCODE=0 
	}
	else
	{
		s PLISTMX(2)=CRowID		;ComponentDR
		s tmpid=""
		//Modified By QW20200108 BUG:QW0034 begin 增加修改原参数
		s OldCPRowID=""
		&SQL(select CP_RowID Into :tmpid from SQLUSER.DHC_EQCComponentParas where CP_ComponentDR=:CRowID and CP_Code=:PLISTMX(3))
		if OldParaCode'=""
		{
			&SQL(select CP_RowID Into :OldCPRowID from SQLUSER.DHC_EQCComponentParas where CP_ComponentDR=:CRowID and CP_Code=:OldParaCode)
		}
		i ((tmpid="")&&(OldParaCode=""))
		{ 
			&SQL(Insert Into SQLUSER.DHC_EQCComponentParas Values :PLISTMX())
		}
		elseif((PLISTMX(3)'="")&&(OldCPRowID'=""))
		{
			&SQL(Update SQLUser.DHC_EQCComponentParas values :PLISTMX() where CP_RowID=:OldCPRowID)
			i SQLCODE=100 s SQLCODE=0			
		}elseif((tmpid'="")&&(OldParaCode=""))
		{
			&SQL(Update SQLUser.DHC_EQCComponentParas values :PLISTMX() where CP_RowID=:tmpid)
			i SQLCODE=100 s SQLCODE=0
		}
		//Modified By QW20200108 BUG:QW0034 End 
		
	}
	
	q SQLCODE
}

/// modified by ZY0200
/// add by lmm 2018-12-06
/// w ##Class(web.DHCEQCComponent).ElementDataType(DataType)
ClassMethod ElementDataType(DataType)
{
	///modified by ZY0201
	//q $CASE(DataType,"":"","0":"text","2":"checkbox","7":"combobox","9":"combogrid","5":"datebox")
	q $CASE(DataType,"":"","0":"string","1":"int","2":"float","3":"date","4":"time","5":"bool")
}

}
