Class web.DHCDocConfig Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 清除非统一配置的配置数据
ClassMethod ClearDocConfig(HospID As %String) As %String
{
	d ClearDocConfig^DHCDocClearData()
	//d ClearDocConfigByHospId^DHCDocConfigClear(HospID)
	Q 0
}

ClassMethod ClearOELock(PAADMRowid As %String)
{
	n (PAADMRowid,%session)
	s orderrow=$o(^OEORD(0,"Adm",+PAADMRowid,""))
	q:orderrow=""
	;s ^zhoutest("lock")=%session.SessionId_"^"_orderrow
	d ##Class(websys.Lock).LockClear($lb(orderrow,"User.OEOrder"),%session.SessionId)
}

ClassMethod GetConfigNode(Node As %String, HospId As %String = "") As %String
{
	n (Node,HospId,%session)
	Q:Node="" 0
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s str=$g(^DHCDocConfig(HospCodeNode,Node))
	}else{
		s str=$g(^DHCDocConfig(Node))
	}
	if (str="") s str=0
	q str
}

ClassMethod GetConfigNode1(Node As %String, SubNode As %String, HospId As %String = "") As %String
{
	Q:SubNode="" ""
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s str=$g(^DHCDocConfig(HospCodeNode,Node,SubNode))
	}else{
		s str=$g(^DHCDocConfig(Node,SubNode))
	}
	q str
}

/// w ##class(web.DHCDocConfig).GetConflict("10338||1")
ClassMethod GetConflict(ArcimRowid As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	;自己互斥自己不起作用
	;2017-05-05如果配置了互斥自己,则判断互斥
	s ret=""
	;如果传入的是主ID先验证主表,主表维护的对应的互斥 User.DHCItmMast
	s DHCItemRowid=0
	f  s DHCItemRowid=$O(^DHCItmMast(0,"ARCIM",ArcimRowid,DHCItemRowid)) Q:DHCItemRowid=""  d
	.s childsub=0  f  s childsub=$O(^DHCItmMast(DHCItemRowid,"CF",childsub)) q:childsub=""  d
	..s ConflictItem=$p($g(^DHCItmMast(DHCItemRowid,"CF",childsub)),"^",1)
	..Q:ConflictItem=""
	..Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ConflictItem,HospId)="N"
	..if ret=""  s ret=ConflictItem
	..else  d
	...if ("^"_ret_"^")'[("^"_ConflictItem_"^")  d
	....s ret=ret_"^"_ConflictItem
	/*s DHCItemRowid=$O(^DHCItmMast(0,"ARCIM",ArcimRowid,0))
	if DHCItemRowid'="" d
	.s childsub=0  f  s childsub=$O(^DHCItmMast(DHCItemRowid,"CF",childsub)) q:childsub=""  d
	..s ConflictItem=$p($g(^DHCItmMast(DHCItemRowid,"CF",childsub)),"^",1)
	..Q:ConflictItem=""
	..if ret=""  s ret=ConflictItem
	..else  d
	...if ("^"_ret_"^")'[("^"_ConflictItem_"^")  d
	....s ret=ret_"^"_ConflictItem*/
	;如果传入ID在其他医嘱项目子表中 User.DHCItmConflict (可能一个项目包含在多个子表中)
	s DHCItemRowid=0
	f  s DHCItemRowid=$O(^DHCItmMast("0","CFARCIM",ArcimRowid,DHCItemRowid)) Q:DHCItemRowid=""  d
	.;查找主表ID
	.s MainItemID=$P(^DHCItmMast(DHCItemRowid),"^",1)
	.Q:MainItemID=ArcimRowid
	.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",MainItemID,HospId)="N"
	.i ret="" s ret=MainItemID
	.else  d
	..if ("^"_ret_"^")'[("^"_MainItemID_"^") d
	...s ret=ret_"^"_MainItemID
	.q:##class(web.DHCDocOrderCommon).IsCNMedItem(MainItemID)
	.s DARCIMConflictType=$P(^DHCItmMast(DHCItemRowid),"^",14)
	.Q:(DARCIMConflictType="OW") //互斥类型为单向时,不进行子表互斥项目判断
	.;查找子表中互斥项目
	.s childsub=0  f  s childsub=$O(^DHCItmMast(DHCItemRowid,"CF",childsub)) q:childsub=""  d
	..s ConflictItem=$p($g(^DHCItmMast(DHCItemRowid,"CF",childsub)),"^",1)
	..Q:ConflictItem=ArcimRowid
	..i ret="" s ret=ConflictItem
	..e  d 
	...if ("^"_ret_"^")'[("^"_ConflictItem_"^") d
	....s ret=ret_"^"_ConflictItem
	Q ret
}

ClassMethod GetDHCCTLOCFieldValue(Rowid As %String, DHCFieldNum As %String) As %String
{
 Q:'$d(^CTLOC(Rowid,"DHC")) ""
 Q $P($G(^CTLOC(Rowid,"DHC")),"^",DHCFieldNum)
}

ClassMethod GetPCSConfigNode(Node As %String) As %String
{
	q $g(^DHCPCSConfig(Node))
}

ClassMethod GetPCSLoc() As %String
{
	s count=0
	s ret=""
	s index=0  f index=$o(^DHCPCSConfig("Loc",index)) q:index=""  d
	.s count=count+1
	.i count=1 s ret=$g(^DHCPCSConfig("Loc",index))
	.e  s ret=ret_"^"_$g(^DHCPCSConfig("Loc",index))
	if ret'="" s ret="^"_ret_"^"
	q ret
}

ClassMethod GetPath()
{
	&SQL(select pathtoreports into :path from websys.configuration)
	Q path
}

ClassMethod PutConfigNode(Nodeinfo As %String, HospCodeNode As %String) As %String
{
	s Node=$p(Nodeinfo,$C(1),1)
	s Info=$p(Nodeinfo,$C(1),2)
	if (HospCodeNode'="") {
		s ^DHCDocConfig(HospCodeNode,Node)=Info
	}else{
		s ^DHCDocConfig(Node)=Info
	}
}

ClassMethod SaveConfig(Coninfo As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
	}else{
		s HospCodeNode=""
	}
	s ConNum=$l(Coninfo,$C(2))
	f i=1:1:ConNum  d
	.s evNoteinfo=$p(Coninfo,$C(2),i)
	.i evNoteinfo'="" d ..PutConfigNode(evNoteinfo,HospCodeNode)
	q 0
}

ClassMethod SaveConfig1(Node As %String, Node1 As %String, NodeValue As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s ^DHCDocConfig(HospCodeNode,Node,Node1)=NodeValue
	}else{
		s ^DHCDocConfig(Node,Node1)=NodeValue
	}
	q 0
}

ClassMethod SaveConfig1New(Coninfo As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
	}else{
		s HospCodeNode=""
	}
	s ConNum=$l(Coninfo,$C(2))
	f i=1:1:ConNum  d
	.s evNoteinfo=$p(Coninfo,$C(2),i)
	.i evNoteinfo'="" d ..PutConfigNode1(evNoteinfo,HospCodeNode)
	q 0
}

ClassMethod PutConfigNode1(Nodeinfo As %String, HospCodeNode As %String = "") As %String
{
	
	s Node=$p(Nodeinfo,$C(1),1)
	s NodeValue=$p(Nodeinfo,$C(1),2)
	s Node1=$p(Nodeinfo,$C(1),3)
	d ..SaveConfig1(Node,Node1,NodeValue,HospCodeNode)
}

ClassMethod SaveConfig2(Node As %String, NodeValue As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s ^DHCDocConfig(HospCodeNode,Node)=NodeValue
	}else{
		s ^DHCDocConfig(Node)=NodeValue
	}
	q 0
}

ClassMethod SaveConfig3(Node As %String, Node1 As %String, NodeValue As %String, HospId As %String = "") As %String
{
 	;s ^tempfxn("SaveConfig3")=Node_","_Node_","_NodeValue
 	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		if (Node1="") {
			s Node1=$o(^DHCDocConfig(HospCodeNode,Node,""),-1)
			i Node1="" s Node1=0
			s Node1=Node1+1
		}
		s ^DHCDocConfig(HospCodeNode,Node,Node1)=NodeValue
	}else{
		if (Node1="") {
			s Node1=$o(^DHCDocConfig(Node,""),-1)
			i Node1="" s Node1=0
			s Node1=Node1+1
		}
		s ^DHCDocConfig(Node,Node1)=NodeValue
	}
	q 0
}

ClassMethod test(value As %String) As %String
{
	s ^tempscl("test",value)=value
	q 0
}

ClassMethod SetDHCCTLOCFieldValue(Rowid As %String, DHCFieldNum As %String, Val As %String)
{
 s $P(^CTLOC(Rowid,"DHC"),"^",DHCFieldNum)=Val
}

ClassMethod UpdateDeductPartial()
{
	s billsub="2||1",count=0
	s child=0
	s arcim=0  f  s arcim=$o(^ARCIM(0,"ARCSG_DR",billsub,arcim)) q:arcim=""  d 
	.s child=0 f  s child=$o(^ARCIM(0,"ARCSG_DR",billsub,arcim,child)) q:child=""  d
	..s DrgFormRowid=$p(^ARCIM(arcim,child,1),"^",12)
	..s desc=$p(^ARCIM(arcim,child,1),"^",2)
	..s count=count+1
	..q:(DrgFormRowid="")
	..q:(DrgFormRowid="-1")
	..s DeductPartia=$p($g(^PHCD(+DrgFormRowid,"DF",$p(DrgFormRowid,"||",2),2)),"^",6)
	..;w DeductPartia_"^"_desc_"^"_DrgFormRowid_"^"_arcim_"||"_child,!
	..s $p(^PHCD(+DrgFormRowid,"DF",$p(DrgFormRowid,"||",2),2),"^",6)="Y"
	w count
}

ClassMethod UpdateDeductPartialNew()
{
	s count=0
	s phcd=0  f  s phcd=$o(^PHCD(phcd)) q:phcd=""  d 
	.s child=0 f  s child=$o(^PHCD(phcd,"DF",child)) q:child=""  d
	..s DeductPartia=$p($g(^PHCD(phcd,"DF",child,2)),"^",6)
	..i DeductPartia="Y" d
	...s $p(^PHCD(phcd,"DF",child,"DHC"),"^",1)=1
	...w $p($g(^PHCD(phcd,1)),"^",1)_"^"_$p($g(^PHCD(phcd,1)),"^",2),!
	...s count=count+1
	w count
}

/// d ##class(web.DHCDocConfig).GenConfigJson("",.paraarr)
ClassMethod GenConfigJson(JsonName As %String, ByRef ParaArr As %Library.String)
{
	if JsonName="" s JsonName="DocConfig"
	s json=""
	s paraname=""
	for {
		s paraname=$O(ParaArr(paraname))
		Quit:paraname=""
		s nodename=paraname
		if ParaArr(paraname)'="" s nodename=ParaArr(paraname)
		s paravalue=..%GetConfig(nodename)
		if json="" {
			s json="'"_paraname_"':'"_paravalue_"'"
		}else {
			s json=json_",'"_paraname_"':'"_paravalue_"'"
		}
	}
	w "<SCRIPT Language=""Javascript"">",!
	w " var "_JsonName_"={"_json_"}",!
	w "</SCRIPT>",!
}

ClassMethod GetConfigNodeNew(Node As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s rtn=$g(^DHCDocConfig(HospCodeNode,Node))
	}else{
		s rtn=$g(^DHCDocConfig(Node))
	}
	s rtn="{"_"""result"""_":"_""""_rtn_""""_"}"
	q rtn
}

ClassMethod GetConfigNode1New(Node As %String, SubNode As %String, HospId As %String = "") As %String
{
	Q:SubNode="" ""
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s rtn=$g(^DHCDocConfig(HospCodeNode,Node,SubNode))
	}else{
		s rtn=$g(^DHCDocConfig(Node,SubNode))
	}
	s rtn="{"_"""result"""_":"_""""_rtn_""""_"}"
	q rtn
}

/// 设置卡的全局配置
ClassMethod SetDHCDocCardConfig(Node As %String, Value As %String) As %String
{
	s ^DHCDocCardConfig(Node)=Value
	q 0
}

/// 获取卡的全局配置
ClassMethod GetDHCDocCardConfig(Node As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s HospCodeNode="HospDr_"_HospId
	Q $G(^DHCDocCardConfig(HospCodeNode,Node))
}

ClassMethod GetConfigNode3(Node As %String, SubNode1 As %String, SubNode2 As %String, HospId As %String = "") As %String
{
	Q:(Node="")||(SubNode1="")||(SubNode2="") ""
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s str=$g(^DHCDocConfig(HospCodeNode,Node,SubNode1,SubNode2))
	}else{
		s str=$g(^DHCDocConfig(Node,SubNode1,SubNode2))
	}
	q str
}

ClassMethod SetConfigNode3(Node As %String, SubNode1 As %String, SubNode2 As %String, HospId As %String = "", Value As %String) As %String
{
	Q:(Node="")||(SubNode1="")||(SubNode2="") ""
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s ^DHCDocConfig(HospCodeNode,Node,SubNode1,SubNode2)=Value
	}else{
		s ^DHCDocConfig(Node,SubNode1,SubNode2)=Value
	}
	q 0
}

/// ##class(web.DHCDocConfig).GetConfigNodeNew2
ClassMethod GetConfigNodeNew2(Node As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s str=$g(^DHCDocConfig(HospCodeNode,Node))
	}else{
		s str=$g(^DHCDocConfig(Node))
	}
	q str
}

/// 页面设置数据保存
ClassMethod SetPageSetting(Type, TypeValue, PageCode, Data, HospId = "")
{
	s:($g(HospId)="")&&($d(%session)) HospId=%session.Get("LOGON.HOSPID")
	s HospCodeNode="HospDr_"_HospId
	s ^DHCDocConfig(HospCodeNode,Type,TypeValue,PageCode)=Data
	Q 0
}

/// 页面设置数据获取 DataType传obj，返回动态对象数据类型
ClassMethod GetPageSetting(Type, TypeValue, PageCode, HospId = "", DataType = "")
{
	s Data=""
	s:($g(HospId)="")&&($d(%session)) HospId=%session.Get("LOGON.HOSPID")
	s HospCodeNode="HospDr_"_HospId
	if (Type'="")&&(TypeValue'="")&&(PageCode'=""){
		s Data=$G(^DHCDocConfig(HospCodeNode,Type,TypeValue,PageCode))
	}
	s:Data="" Data="{}"
	Q:$ZCVT(DataType,"U")="OBJ" {}.%FromJSON(Data)
	Q Data
}

/// 获取用户的页面设置，如果没有，取安全组的设置
/// w ##class(web.DHCDocConfig).GetUserPageSetting("OrderEntry","obj",17573,23,2)
ClassMethod GetUserPageSetting(PageCode, DataType = "", UserID = "", GroupID = "", HospId = "")
{
	if $D(%session){
		s:UserID="" UserID=%session.Get("LOGON.USERID")
		s:GroupID="" GroupID=%session.Get("LOGON.GROUPID")
		s:HospId="" HospId=%session.Get("LOGON.HOSPID")
	}
	s CfgData=..GetPageSetting("User.SSUser",UserID_"|"_GroupID,PageCode,HospId,"obj")
	/*if 'CfgData.%Size(){
		s CfgData=..GetPageSetting("User.SSGroup",GroupID,PageCode,HospId,"obj")
	}*/
	s CfgDataGroup=..GetPageSetting("User.SSGroup",GroupID,PageCode,HospId,"obj")
	if ('CfgData.%Size()){
		s CfgData=CfgDataGroup
	}else{
		s Arr=##Class(DHCDoc.Util.ArrayData).%New()
		s CfgDataArr=Arr.%FromJSON(CfgData.%ToJSON())
		s CfgDataGroupArr=Arr.%FromJSON(CfgDataGroup.%ToJSON())
		//合并两个配置信息，防止护士拖动界面保存数据时json中只有高度信息
		s CfgDataArr=##class(DHCDoc.Util.ArrayData).MergeObjects(CfgDataGroupArr,CfgDataArr)
		s CfgData={}.%FromJSON(CfgDataArr.%ToJSON().Read())
    	
	}
	Q:$ZCVT(DataType,"U")="OBJ" CfgData
	Q CfgData.%ToJSON()
}

/// 用户界面动态设置模板高度
ClassMethod SetUserPageScale(PageCode, Property, Value, UserID = "", GroupID = "", HospId = "")
{
	if $D(%session){
		s:UserID="" UserID=%session.Get("LOGON.USERID")
		s:GroupID="" GroupID=%session.Get("LOGON.GROUPID")
		s:HospId="" HospId=%session.Get("LOGON.HOSPID")
	}
	s CfgData=..GetPageSetting("User.SSUser",UserID_"|"_GroupID,PageCode,HospId,"obj")
	d CfgData.%Set(Property,Value)
	Q ..SetPageSetting("User.SSUser", UserID_"|"_GroupID, PageCode, CfgData.%ToJSON(),HospId)
}

}
