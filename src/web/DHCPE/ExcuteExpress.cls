Class web.DHCPE.ExcuteExpress Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/*
ClassMethod OutButton(ind, Type)
{
	
	;d ##class(web.DHCPE.ExcuteExpress).OutButton()
	i Type="I" d
	.w "<button onclick='InsertRow(this)' id="_ind_">插入一行</button>"
	i Type="D" d
	.w "<button onclick='DeleteRowNew(this)' id="_ind_">删除一行</button>"
	Quit $$$OK
}
*/
ClassMethod OutButton(ElementID As %String = "", Type)
{
	
	i Type="I" d
	.w "<button onclick='InsertRow(this)' id='"_ElementID_"' name='"_ElementID_"' style='WIDTH:100px;'>插入一行</button>"
	i Type="D" d
	.w "<button onclick='DeleteRowNew(this)' id='"_ElementID_"' name='"_ElementID_"' style='WIDTH:100px;'>删除一行</button>"
	
	Quit $$$OK
}

ClassMethod SaveExpress(EDID, Express)
{
	s ^DHCPEED(EDID,"Express")=Express
	q 0
}

/// w ##class(web.DHCPE.ExcuteExpress).GetExpressDesc("[2||1||3]&&[2||7||3]")
ClassMethod GetExpressDesc(Express)
{
	s i=$L(Express,"[")
	s ExpressDesc=Express
	s ExpressDesc=##class(web.DHCPE.Public.Setting).Replace(ExpressDesc,"'","'非'")
	f j=2:1:i  d
	.s orderDetailStandardID=$P(Express,"[",j)
	
	.s orderDetailStandardID=$P(orderDetailStandardID,"]",1)
	.q:orderDetailStandardID=""
	.q:'$D(^DHCPEST(+orderDetailStandardID,"OD",$P($g(orderDetailStandardID),"||",2),"ODS",$P($g(orderDetailStandardID),"||",3)))
	.s Normal=$P(^DHCPEST(+orderDetailStandardID,"OD",$P($g(orderDetailStandardID),"||",2),"ODS",$P($g(orderDetailStandardID),"||",3)),"^",6)
	.s orderDetailID=$P($g(orderDetailStandardID),"||",1,2)
	.q:orderDetailID=""
	.s DetailDesc=$P($g(^DHCPEST(+orderDetailID,"OD",$P($g(orderDetailID),"||",2))),"^",1)
	.s ItemType=$P($g(^DHCPEST(+orderDetailID,"OD",$P($g(orderDetailID),"||",2))),"^",2)
	.s StDesc=$P(^DHCPEST(+orderDetailID),"^",2)
	.i (ItemType="N")||(ItemType="C") d
	..s Min=+$P(^DHCPEST(+orderDetailStandardID,"OD",$P($g(orderDetailStandardID),"||",2),"ODS",$P($g(orderDetailStandardID),"||",3)),"^",4)
	..s Max=+$P(^DHCPEST(+orderDetailStandardID,"OD",$P($g(orderDetailStandardID),"||",2),"ODS",$P($g(orderDetailStandardID),"||",3)),"^",5)
	..s Desc=$P(^DHCPEST(+orderDetailStandardID,"OD",$P($g(orderDetailStandardID),"||",2),"ODS",$P($g(orderDetailStandardID),"||",3)),"^",2)
	..s Desc=StDesc_"."_DetailDesc_"."_Desc_"["_Min_"-"_Max_"]"
	.e  d
	..s Desc=$P(^DHCPEST(+orderDetailStandardID,"OD",$P($g(orderDetailStandardID),"||",2),"ODS",$P($g(orderDetailStandardID),"||",3)),"^",2)
	..s Desc=StDesc_"."_DetailDesc_"."_Desc
	.s ExpressDesc=##class(web.DHCPE.Public.Setting).Replace(ExpressDesc,"["_orderDetailStandardID_"]",Desc)
	s ExpressDesc=##class(web.DHCPE.Public.Setting).Replace(ExpressDesc,"&&","'并且'")
	s ExpressDesc=##class(web.DHCPE.Public.Setting).Replace(ExpressDesc,"&","'并且'")
	s ExpressDesc=##class(web.DHCPE.Public.Setting).Replace(ExpressDesc,"||","'或者'")
	s ExpressDesc=##class(web.DHCPE.Public.Setting).Replace(ExpressDesc,"|","'或者'")
	q ExpressDesc
}

ClassMethod SaveNewExpress(Type, SourceID, Info)
{
	;InfoStr
	s $ZT="ErrInfo" 
	TSTART
	&SQL(Delete from sqluser.DHC_PE_Express where E_Type=:Type and E_SourceID=:SourceID)
	i Info=""
	{
		TCOMMIT
		q 0
	}
	s i=$L(Info,$C(1))
	s SQLCODE=0
	for j=1:1:i
	{
		s InfoStr=$P(Info,$C(1),j)
		s obj=##class(User.DHCPEExpress).%New()
		s obj.EType=Type
		s obj.ESourceID=SourceID
		s obj.EPreBracket=$P(InfoStr,"^",1)
		d obj.EItemDRSetObjectId($P(InfoStr,"^",2))
		s obj.EOperator=$P(InfoStr,"^",3)
		d obj.EODStandardDRSetObjectId($P(InfoStr,"^",4))
		s obj.EReference=$P(InfoStr,"^",5)
		s obj.EAfterBracket=$P(InfoStr,"^",7)
		s obj.ERelation=$P(InfoStr,"^",8)
		s obj.ESex=$P(InfoStr,"^",6)
		s obj.ENoBloodFlag=$P(InfoStr,"^",9)
		s obj.EAgeRange=$P(InfoStr,"^",10)
		s:j=i obj.ERelation=""
		s obj.EKBXCode=$P(InfoStr,"^",11)
		s obj.EKBItemDtlCode=$P(InfoStr,"^",12)
		s obj.EKBItemDtlDesc=$P(InfoStr,"^",13)
		s sc=obj.%Save()
		d obj.%Close()
		If ($System.Status.IsError(sc))	
		{
			s SQLCODE=$System.Status.GetErrorText(sc)
			q
		}
	}
	i SQLCODE'=0{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
ErrInfo
	TROLLBACK
	q $ZERROR
}

/// w ##class(web.DHCPE.ExcuteExpress).ExcuteExpress("")
ClassMethod ExcuteExpress(FinalExpress)
{
	s $ZT="ExcuteExpressErr"
	
	s rStr="s rStr="_FinalExpress
	xecute rStr  //执行上面的M表达式
	q rStr
	
ExcuteExpressErr
	q 0
}

ClassMethod OutPreBracketToHTML(ElementID As %String = "", ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	;d ##class(web.DHCPE.ExcuteExpress).OutPreBracketToHTML()
	//s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='"_ElementID_"' id='"_ElementID_"' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''></option>",!
	s Selected=""
	s:DefaultValue="(" Selected="Selected"
	w "<option value='(' "_Selected_">(</option>",!
	s Selected=""
	s:DefaultValue="((" Selected="Selected"
	w "<option value='((' "_Selected_">((</option>",!
	s Selected=""
	s:DefaultValue="(((" Selected="Selected"
	w "<option value='(((' "_Selected_">(((</option>",!
	s Selected=""
	s:DefaultValue="((((" Selected="Selected"
	w "<option value='((((' "_Selected_">((((</option>",!
	s Selected=""
	s:DefaultValue="(((((" Selected="Selected"
	w "<option value='(((((' "_Selected_">(((((</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutAfterBracketToHTML(ElementID As %String = "", ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	;d ##class(web.DHCPE.ExcuteExpress).OutAfterBracketToHTML()
	//s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='"_ElementID_"' id='"_ElementID_"' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''></option>",!
	s Selected=""
	s:DefaultValue=")" Selected="Selected"
	w "<option value=')' "_Selected_">)</option>",!
	s Selected=""
	s:DefaultValue="))" Selected="Selected"
	w "<option value='))' "_Selected_">))</option>",!
	s Selected=""
	s:DefaultValue=")))" Selected="Selected"
	w "<option value=')))' "_Selected_">)))</option>",!
	s Selected=""
	s:DefaultValue="))))" Selected="Selected"
	w "<option value='))))' "_Selected_">))))</option>",!
	s Selected=""
	s:DefaultValue=")))))" Selected="Selected"
	w "<option value=')))))' "_Selected_">)))))</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutOperatorToHTML(ElementID As %String = "", ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	;d ##class(web.DHCPE.ExcuteExpress).OutOperatorToHTML()
	//s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	//h 1
	w "<select name='"_ElementID_"' id='"_ElementID_"' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''></option>",!
	s Selected=""
	s:DefaultValue=">" Selected="Selected"
	w "<option value='>' "_Selected_">大于</option>",!
	
	s Selected=""
	s:DefaultValue=">=" Selected="Selected"
	w "<option value='>=' "_Selected_">大于等于</option>",!
	
	s Selected=""
	s:DefaultValue="<" Selected="Selected"
	w "<option value='<' "_Selected_">小于</option>",!
	
	s Selected=""
	s:DefaultValue="<=" Selected="Selected"
	w "<option value='<=' "_Selected_">小于等于</option>",!
	
	s Selected=""
	s:DefaultValue="[" Selected="Selected"
	w "<option value='[' "_Selected_">包含</option>",!
	
	s Selected=""
	s:DefaultValue="'[" Selected="Selected"
	w "<option value=""'["" "_Selected_">不包含</option>",!
	
	s Selected=""
	s:DefaultValue="=" Selected="Selected"
	w "<option value='=' "_Selected_">等于</option>",!
	
	s Selected=""
	s:DefaultValue="'=" Selected="Selected"
	;w "<option value=""'="" "_Selected_">不等于</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutRelationToHTML(ElementID As %String = "", ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	;d ##class(web.DHCPE.ExcuteExpress).OutRelationToHTML()
	//s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='"_ElementID_"' id='"_ElementID_"' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''></option>",!
	s Selected=""
	s:DefaultValue="||" Selected="Selected"
	w "<option value='||' "_Selected_">或者</option>",!
	s Selected=""
	s:DefaultValue="&&" Selected="Selected"
	w "<option value='&&' "_Selected_">并且</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutSexToHTML(ElementID As %String = "", ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	;d ##class(web.DHCPE.ExcuteExpress).OutSexToHTML()
	//s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='"_ElementID_"' id='"_ElementID_"' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	s Selected=""
	s:DefaultValue="N" Selected="Selected"
	w "<option value='N' "_Selected_">不限</option>",!
	s Selected=""
	s:DefaultValue="M" Selected="Selected"
	w "<option value='M' "_Selected_">男</option>",!
	s Selected=""
	s:DefaultValue="F" Selected="Selected"
	w "<option value='F' "_Selected_">女</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutItemToHTML(ElementID As %String = "", ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	;d ##class(web.DHCPE.ExcuteExpress).OutItemToHTML()
	//s:(""=ContrlWidth) ContrlWidth="155"
	Write "<input onchange='ItemOnChange(this);' onkeydown='ItemOnKeydown(this);' id='"_ElementID_"' name='"_ElementID_"' "
	Write " style='WIDTH:"_ContrlWidth_"px; HEIGHT: 24px' value='"_DefaultValue_"'>"
	Quit $$$OK
}

ClassMethod OutItemStandardToHTML(ElementID As %String = "", ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	;d ##class(web.DHCPE.ExcuteExpress).OutItemStandardToHTML()
	//s:(""=ContrlWidth) ContrlWidth="155"
	Write "<input onchange='ItemStandardOnChange(this);' onkeydown='ItemStandardOnKeydown(this);' id='"_ElementID_"' name='"_ElementID_"' "
	Write " style='WIDTH:"_ContrlWidth_"px; HEIGHT: 24px' value='"_DefaultValue_"'>"
	Quit $$$OK
}

Query FindExpress(ParrefRowId As %Library.String = "", Type As %Library.String = "", CTLOCID As %Library.String = "") As %Query(ROWSPEC = "TPreBracket:%String,TItem:%String,TItemID:%String,TOperator:%String,TReference:%String,TODStandardID:%String,TAfterBracket:%String,TRelation:%String,ind:%String,TSelect:%String,TSex:%String,TNoBloodFlag:%String,TAgeRange:%String,TAdd:%String,TDelete:%String,TOperatorname:%String,TRelationname:%String,TSexname:%String,EKBItemDtlCode:%String,EKBItemDtlDesc:%String,EKBXCode:%String")
{
}

ClassMethod FindExpressExecute(ByRef qHandle As %Binary, ParrefRowId As %Library.String = "", Type As %Library.String = "", CTLOCID As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	if ParrefRowId=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
 	s ind=1
 	s k=0
 	s ID=0
 	i Type="" s Type="ED"
 	;w !,ParrefRowId
 	f  s ID=$O(^User.DHCPEExpressI("SourceIDIndex",Type,ParrefRowId,ID)) q:ID=""  d
 	.s k=k+1
 	.d ClearInfo
 	.s obj=##class(User.DHCPEExpress).%OpenId(ID)
 	.s EKBXCode =obj.EKBXCode 
 	.s EKBItemDtlCode=obj.EKBItemDtlCode
    .s EKBItemDtlDesc=obj.EKBItemDtlDesc
 	.s TPreBracket=obj.EPreBracket
 	.s TItemID=obj.EItemDRGetObjectId()
 	.s LocShowDFlag=##class(User.DHCPEOrderDetail).GetLocShowDataFlag(TItemID,CTLOCID)
	.q:LocShowDFlag="N"
 	.s TItem=obj.EItemDR.ODDesc
 	.s TOperator=obj.EOperator
 	.d GetText("Operator")
 	.s TODStandardID=obj.EODStandardDRGetObjectId()
 	.i TODStandardID'="" d
 	..s TReference=obj.EODStandardDR.ODSTextVal
 	.e  d
 	..s TReference=obj.EReference
 	.s TAfterBracket=obj.EAfterBracket
 	.s TRelation=obj.ERelation
 	.d GetText("Relation")
 	.s TSelect=obj.EItemDR.ODType
 	.s:TSelect="S" TSelect=1
 	.s:TSelect'="1" TSelect=0
 	.s TSex=obj.ESex
 	.d GetText("Sex")
 	.s TNoBloodFlag=obj.ENoBloodFlag
 	.d GetText("BloodFlag")
 	.s TAgeRange=obj.EAgeRange
 	.s TADD="新增一行",TDel="删除一行"
 	.d FindBuild
 	s j=100-k
 	f i=1:1:j
 	{
 		d ClearInfo
		d FindBuild
 	}	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ClearInfo
	s (TPreBracket,TItem,TItemID,TOperator,TReference,TODStandardID,TAfterBracket,TRelation,TSelect,TSex,TNoBloodFlag,TAgeRange,EKBItemDtlCode,EKBItemDtlDesc,EKBXCode)=""
	s (TOperatorname,TRelationname,TSexname)=""
	s TADD="新增一行",TDel="删除一行"
	q
	
GetText(Type)
	if (Type="Operator") {
		s:TOperator=">" TOperatorname="大于"
		s:TOperator=">=" TOperatorname="大于等于"
		s:TOperator="<" TOperatorname="小于"
		s:TOperator="<=" TOperatorname="小于等于"
		s:TOperator="[" TOperatorname="包含"
		s:TOperator="'[" TOperatorname="不包含"
		s:TOperator="=" TOperatorname="等于"
		s:TOperator="'=" TOperatorname="不等于"
	} elseif (Type="Relation") {
		s:TRelation="||" TRelationname="或者"
		s:TRelation="&&" TRelationname="并且"
	} elseif (Type="Sex") {
		s:TSex="N" TSexname="不限"
		s:TSex="M" TSexname="男"
		s:TSex="F" TSexname="女"
	}
	//
	q
FindBuild      
	
	set Data=$lb(TPreBracket,TItem,TItemID,TOperator,TReference,TODStandardID,TAfterBracket,TRelation,ind,TSelect,TSex,TNoBloodFlag,TAgeRange,TADD,TDel,TOperatorname,TRelationname,TSexname,EKBItemDtlCode,EKBItemDtlDesc,EKBXCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindExpressFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExpressExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindExpressClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExpressExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod TestOneED(EpisodeID, EDRowId)
{
	;w ##class(web.DHCPE.ExcuteExpress).TestOneED(3444616,2528)
	s Express=""
	s ExpressID=0
	f  s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","ED",EDRowId,ExpressID)) q:ExpressID=""  d
	.s obj=##class(User.DHCPEExpress).%OpenId(ExpressID)
	.s Express=Express_obj.EPreBracket
	.s ItemID=obj.EItemDRGetObjectId()
	.i $D(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID)) d  ;;逐个判断此细项是否满足
	..s ItemType=obj.EItemDR.ODType
	..s Reference=obj.EReference
	..i Reference="" s Reference=obj.EODStandardDR.ODSTextVal
	..s Operator=obj.EOperator
	..s IsResult=0
	..s RLTID=0
	..f  s RLTID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID,RLTID)) q:(RLTID="")||(IsResult=1)  d
 	...s Result=$P(^DHCPERLT(RLTID),"^",4)
 	...s EDID=$P(^DHCPERLT(RLTID),"^",9)
 	...i (ItemType="S")||(ItemType="T") d
 	....s Result=""""_Result_""""
 	....s Reference=""""_Reference_""""
 	...s OneExpress=Result_Operator_Reference
 	...s IsResult=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(OneExpress)
	...b ;OneExpress_"^"_IsResult
	.e  d  ;;没有结果设置为0
	..s IsResult=0
	.s ExpressSex=obj.ESex
	.;性别不符设置为0
	.s:(ExpressSex'="N")&&(ExpressSex'=sexStr) IsResult=0
	.s Express=Express_IsResult_obj.EAfterBracket_obj.ERelation
	s rStr=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(Express)
	q rStr
}

}
