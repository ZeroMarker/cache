/// CTOR: QP
/// DATE: 2019-10-23
/// DESC: Page Dom Setting
Class web.DHCDocPageDom Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2019-10-23
/// DESC: 是否缓存
/// IN  :  
/// OUT : 1:是，0：否
/// w ##class(web.DHCDocPageDom).HasCache("IPBook","textbox")
ClassMethod HasCache(pageCode As %String = "", domSelector As %String = "") As %String
{
	n (pageCode,domSelector)
	s mRtn=0
	Q:(pageCode="")||(domSelector="") mRtn
	q:'$d(^DHCDocOPi("Code",0,pageCode)) mRtn
	s PDParRef=$o(^DHCDocOPi("Code",0,pageCode,0))
	q:PDParRef="" mRtn
	q:'$d(^DHCDocPageDomI("DomClass",PDParRef,domSelector)) mRtn
	s mRtn=1
	
	Q mRtn
}

ClassMethod ConfigHasCache(pageCode As %String = "") As %String
{
	n (pageCode)
	s mRtn=0
	Q:(pageCode="") mRtn
	Q:'$d(^DHCDocOPi("Code",0,pageCode)) mRtn
	Q 1
}

/// CTOR: QP
/// DATE: 2019-10-31
/// DESC: 得到必填DOM元素
/// IN  :  
/// OUT : 1:是，0：否
/// w ##class(web.DHCDocPageDom).GetMustFillDom("IPBook",".textbox")
ClassMethod GetMustFillDom(pageCode As %String = "", domSelector As %String = "") As %String
{
	n (pageCode,domSelector)
	s mRtn=""
	Q:(pageCode="")||(domSelector="") mRtn
	q:'$d(^DHCDocOPi("Code",0,pageCode)) mRtn
	s PDParRef=$o(^DHCDocOPi("Code",0,pageCode,0))
	q:PDParRef="" mRtn
	q:'$d(^DHCDocPageDomI("DomClass",PDParRef,domSelector)) mRtn
	s mRtn="{"
	s sub="",count=0
	f  s sub=$o(^DHCDocPageDomI("DomClass",PDParRef,domSelector,sub)) q:sub=""  d
	.s mustFill=$p(^DHCDocPageDom(PDParRef,sub),"^",3)
	.s domId=$p(^DHCDocPageDom(PDParRef,sub),"^",1)
	.s domName=$p(^DHCDocPageDom(PDParRef,sub),"^",2)
	.q:mustFill'="Y"
	.s count=count+1
	.i count=1 s mRtn=mRtn_""""_domId_""":"""_domName_""""
	.e  s mRtn=mRtn_","""_domId_""":"""_domName_""""
	s mRtn=mRtn_"}"
	
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-10-31
/// DESC: 得到光标跳转的DOM元素
/// IN  :  
/// OUT : 1:是，0：否
/// w ##class(web.DHCDocPageDom).GetFocusJumpDom("IPBook",".textbox")
ClassMethod GetFocusJumpDom(pageCode As %String = "", domSelector As %String = "") As %String
{
	n (pageCode,domSelector)
	s mRtn=""
	Q:(pageCode="")||(domSelector="") mRtn
	q:'$d(^DHCDocOPi("Code",0,pageCode)) mRtn
	s PDParRef=$o(^DHCDocOPi("Code",0,pageCode,0))
	q:PDParRef="" mRtn
	q:'$d(^DHCDocPageDomI("DomClass",PDParRef,domSelector)) mRtn
	
	s mRtn="{"
	s num="",count=0
	f  s num=$o(^DHCDocPageDomI("DomClassSeqno",PDParRef,domSelector,num)) q:num=""  d
	.s sub=""
	.f  s sub=$o(^DHCDocPageDomI("DomClassSeqno",PDParRef,domSelector,num,sub)) q:sub=""  d
	..s mustFill=$p(^DHCDocPageDom(PDParRef,sub),"^",3)
	..s domId=$p(^DHCDocPageDom(PDParRef,sub),"^",1)
	..s domName=$p(^DHCDocPageDom(PDParRef,sub),"^",2)
	..s seqno=$p(^DHCDocPageDom(PDParRef,sub),"^",4)
	..q:seqno=""
	..s count=count+1
	..i count=1 s mRtn=mRtn_""""_seqno_""":"""_domId_""""
	..e  s mRtn=mRtn_","""_seqno_""":"""_domId_""""
	
	s mRtn=mRtn_"}"
	
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-10-23
/// DESC: 存储缓存
/// IN  :  
/// OUT : 其他:不成功，0：成功
/// w ##class(web.DHCDocPageDom).StorageCache("IPBook","{name:""jj"",age:1}",".textbox")
/// w ##class(web.DHCDocPageDom).StorageCache(^TEMP("SC",1), ^TEMP("SC",2), ^TEMP("SC",3), ^TEMP("SC",4))
ClassMethod StorageCache(pageCode As %String = "", domJson As %String = "", domSelector As %String = "", forceUpdate = "") As %String
{
	n (pageCode,domJson,domSelector,forceUpdate)
	
	s ^TEMP("SC",1)=pageCode
	s ^TEMP("SC",2)=domJson
	s ^TEMP("SC",3)=domSelector
	s ^TEMP("SC",4)=forceUpdate
	
	s jsonstrlen=$length(domJson)
	s tempstr=$EXTRACT(domJson,2,jsonstrlen-1)
	s len=$length(tempstr,",")
	s PDParRef=$o(^DHCDocOPi("Code",0,pageCode,0))
	s saveFlag=0
	Q:PDParRef="" "-102"
	i forceUpdate'=1 {
		s saveFlag=..ClearCache(PDParRef)
	}
	Q:saveFlag'=0 "-103"
	TS
	for i=1:1:len {
		s tempstr1=$P(tempstr,",",i)
		s name=$P(tempstr1,":",1)
		s value=$E(tempstr1,$l(name)+2,$l(tempstr1)) 
		
		if name["""" {
			s name=$P(name,"""",2)
		}
		if value["""" {
			s value=$P(value,"""",2)
		}
		s PDMustFill="",PDSeqno="",PDCss="",PDNote=""
		s Selector=domSelector
		if (Selector="") s Selector=$p(value,"^",6)
		s mList=PDParRef_$c(1)_name_$c(1)_value_$c(1)_Selector
		s saveFlag=..SavePageDom(mList,pageCode)
		Q:saveFlag'=0 
	}
	i saveFlag'=0 {
		TRO
		Q "-101"
	}
	TC
	
	Q 0
}

/// CTOR: QP
/// DATE: 2019-10-31
/// DESC: 得到首次进入光标位置
/// IN  :  
/// OUT : 1:是，0：否
/// w ##class(web.DHCDocPageDom).GetMousePois("doc.ipbookcreate.hui.csp",".textbox")
ClassMethod GetMousePois(pageCode As %String = "", domSelector As %String = "") As %String
{
	n (pageCode,domSelector)
	s mRtn=""
	Q:(pageCode="")||(domSelector="") mRtn
	q:'$d(^DHCDocOPi("Code",0,pageCode)) mRtn
	s PDParRef=$o(^DHCDocOPi("Code",0,pageCode,0))
	q:PDParRef="" mRtn
	q:'$d(^DHCDocPageDomI("DomClass",PDParRef,domSelector)) mRtn
	
	s num="",count=0
	f  s num=$o(^DHCDocPageDomI("DomClassSeqno",PDParRef,domSelector,num)) q:(num="")||(mRtn'="")  d
	.s sub=""
	.f  s sub=$o(^DHCDocPageDomI("DomClassSeqno",PDParRef,domSelector,num,sub)) q:(sub="")||(mRtn'="")  d
	..s mustFill=$p(^DHCDocPageDom(PDParRef,sub),"^",3)
	..s domId=$p(^DHCDocPageDom(PDParRef,sub),"^",1)
	..s domName=$p(^DHCDocPageDom(PDParRef,sub),"^",2)
	..s seqno=$p(^DHCDocPageDom(PDParRef,sub),"^",4)
	..q:seqno=""
	..s mRtn=domId

	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-10-23
/// DESC: 清楚cache
/// IN  :  
/// OUT : 
/// w ##class(web.DHCDocPageDom).ClearCache("56")
ClassMethod ClearCache(PDParRef As %String = "") As %String
{
	n (PDParRef)
	s mRtn=0
	Q:PDParRef="" "-1"
	&SQL(
		DELETE FROM SQLUser.DHC_DocPageDom WHERE PD_ParRef=:PDParRef
	)
	Q:SQLCODE=100 mRtn
	Q:SQLCODE'=0 SQLCODE
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-10-23
/// DESC: 删除
/// IN  :  
/// OUT : 
/// w ##class(web.DHCDocPageDom).ClearCache("56")
ClassMethod DeleteSinglePS(psid As %String = "") As %String
{
	n (psid)
	s mRtn=0
	Q:psid="" "-1"
	&SQL(
		DELETE FROM SQLUser.DHC_DocPageDom WHERE PD_Id=:psid
	)
	Q:SQLCODE'=0 SQLCODE
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-10-23
/// DESC: 得到Dom信息
/// IN  :  
/// OUT : 
/// w ##class(web.DHCDocPageDom).GetDomInfo("56||51")
ClassMethod GetDomInfo(psid As %String = "", sp As %String = "") As %String
{
	n (psid,sp)
	s mRtn=""
	Q:psid="" ""
	i sp="" s sp="^"
	s outObj=##class(User.DHCDocPageDom).%OpenId(psid)
	i $ISObject(outObj) {
		s domId=outObj.PDDomID
		s domName=outObj.PDDomName
		s mustFill=outObj.PDMustFill
		s seqno=outObj.PDSeqno
		s domCss=outObj.PDCss
		s note=outObj.PDNote
		s domClass=outObj.PDDomClass
		s comType=outObj.PDComponentType
		s supJump=outObj.PDSupportJump
		s mRtn=domId_sp_domName_sp_mustFill_sp_seqno_sp_domCss_sp_note_sp_domClass_sp_comType_sp_supJump
		d outObj.%Close()
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-10-23
/// DESC: 保存PageDom
/// IN  : 
/// OUT : 
/// w ##class(web.DHCDocPageDom).SavePageDom("^Test^测试")
ClassMethod SavePageDom(mList As %String, pageCode As %String = "") As %String
{
	n (mList,pageCode)
	s PDParRef=$p(mList,$c(1),1)
	i PDParRef="" {
		s PDParRef=$o(^DHCDocOPi("Code",0,pageCode,0))
	}
	Q:PDParRef="" "-1"
	s PDDomID=$p(mList,$c(1),2)
	s PDDomNameInfo=$p(mList,$c(1),3)
	s PDDomClass=$p(mList,$c(1),4)
	s PDDomName=$p(PDDomNameInfo,"^",1)
	s PDComponentType=$p(PDDomNameInfo,"^",2)
	s PDSupportJump=$p(PDDomNameInfo,"^",3)
	s PDDomUnitID=$p(PDDomNameInfo,"^",4)
	s PDDomUnitName=$p(PDDomNameInfo,"^",5)
	i PDSupportJump=1 s PDSupportJump="Y"
	e  s PDSupportJump="N"
	s PDId=""
	
	i $d(^DHCDocPageDomI("DomId",PDParRef,PDDomID)) {
		s PDId=$o(^DHCDocPageDomI("DomId",PDParRef,PDDomID,""))
	}
	i PDId="" {
		&SQL(
			INSERT INTO SQLUser.DHC_DocPageDom(PD_ParRef,PD_DomID,PD_DomName,PD_DomClass,PD_ComponentType,PD_SupportJump,PD_DomUnitID,PD_DomUnitName) 
			VALUES(:PDParRef,:PDDomID,:PDDomName,:PDDomClass,:PDComponentType,:PDSupportJump,:PDDomUnitID,:PDDomUnitName)
		)
	} else {
		s PDId=PDParRef_"||"_PDId
		&SQL(
			UPDATE SQLUser.DHC_DocPageDom SET PD_DomName=:PDDomName,PD_DomClass=:PDDomClass,
							PD_ComponentType=:PDComponentType,PD_SupportJump=:PDSupportJump,
							PD_DomUnitID=:PDDomUnitID,PD_DomUnitName=:PDDomUnitName
			WHERE PD_Id=:PDId
		)
	}
	
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2019-10-24
/// DESC: 查询页面设置
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("web.DHCDocPageDom","QryPageSet",56,"PatN")
Query QryPageSet(inPage As %String = "", inContent As %String = "", inCdVal As %String = "") As %Query(ROWSPEC = "id,domID,domName,mustFill,seqno,css,note,domClss,componentType,supportJump")
{
}

ClassMethod QryPageSetExecute(ByRef qHandle As %Binary, inPage As %String = "", inContent As %String = "", inCdVal As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^TEMP("QryPageSet",1)=$LB(inPage,inContent)
 	if (inPage="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s inContent=$zcvt(inContent,"U") 
	s sub=0
	f  s sub=$o(^DHCDocPageDom(inPage,sub)) q:sub=""  d
	.s domID=$p(^DHCDocPageDom(inPage,sub),"^",1)
	.s domName=$p(^DHCDocPageDom(inPage,sub),"^",2) 
	.s mustFill=$p(^DHCDocPageDom(inPage,sub),"^",3)
	.Q:(inCdVal=1)&&(mustFill'="Y")
	.s seqno=$p(^DHCDocPageDom(inPage,sub),"^",4) 
	.Q:(inCdVal=2)&&(seqno="")
	.s css=$p(^DHCDocPageDom(inPage,sub),"^",5) 
	.s note=$p(^DHCDocPageDom(inPage,sub),"^",6)
	.s domClss=$p(^DHCDocPageDom(inPage,sub),"^",7)
	.s componentType=$p(^DHCDocPageDom(inPage,sub),"^",8)
	.s supportJump=$p(^DHCDocPageDom(inPage,sub),"^",9)
	.s isExit=$$IfExit
	.q:isExit=1
	.s id=inPage_"||"_sub
   	.d OutPutRow1
   	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
IfExit()
	s uDomID=$zcvt(domID,"U") 
	s uDomName=$zcvt(domName,"U")
	s uCss=$zcvt(css,"U") 
	s uNote=$zcvt(note,"U")
	s uDomClss=$zcvt(domClss,"U")
	s uComponentType=$zcvt(componentType,"U")
	s mRtn=0
	I inContent'="" {
		s mRtn=1 
		i uDomID[inContent s mRtn=0
		i uDomName[inContent s mRtn=0
		i uCss[inContent s mRtn=0
		i uNote[inContent s mRtn=0
		i uDomClss[inContent s mRtn=0
		i uComponentType[inContent s mRtn=0
	}
	
	Q mRtn
	
	
OutPutRow1
	set Data=$lb(id,domID,domName,mustFill,seqno,css,note,domClss,componentType,supportJump)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryPageSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPageSetExecute ]
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

ClassMethod QryPageSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPageSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-10-23
/// DESC: 保存PageDom
/// IN  : 
/// OUT : 
/// w ##class(web.DHCDocPageDom).SavePS(^TEMP("SavePS",1),^TEMP("SavePS",2),^TEMP("SavePS",3))
ClassMethod SavePS(mList As %String, mRef As %String, mSP As %String = "") As %String
{
	n (mList,mRef,mSP)
	s ^TEMP("SavePS",1)=mList
	s ^TEMP("SavePS",2)=mRef
	s ^TEMP("SavePS",3)=mSP
	i mSP="" s mSP="^"
	s id=$p(mList,mSP,1)
	s domId=$p(mList,mSP,2)
	s domName=$p(mList,mSP,3)
	s mustFill=$p(mList,mSP,4)
	s seqno=$p(mList,mSP,5)
	s domCss=$p(mList,mSP,6)
	s note=$p(mList,mSP,7)
	s domSelector=$p(mList,mSP,8)
	s comType=$p(mList,mSP,9)
	s supJump=$p(mList,mSP,10)
	B ;001
	s PDId=""
	i $d(^DHCDocPageDomI("DomId",mRef,domId)) {
		s PDId=$o(^DHCDocPageDomI("DomId",mRef,domId,""))
	}
		
	i id="" {
		Q:PDId'="" "-1"	//已存在
	}
	i id'="" {
		s PDId=mRef_"||"_PDId
		q:PDId'=id "-1"	//已存在
	}
	i id="" {
		&SQL(
			INSERT INTO SQLUser.DHC_DocPageDom(PD_ParRef,PD_DomID,PD_DomName,PD_MustFill,PD_Seqno,PD_Css,PD_Note,PD_DomClass,PD_ComponentType,PD_SupportJump) 
			VALUES(:mRef,:domId,:domName,:mustFill,:seqno,:domCss,:note,:domSelector,:comType,:supJump)
		)
	} else {
		&SQL(
			UPDATE SQLUser.DHC_DocPageDom SET PD_DomID=:domId,PD_DomName=:domName,PD_MustFill=:mustFill,
					PD_Seqno=:seqno,PD_Css=:domCss,PD_Note=:note,PD_DomClass=:domSelector,PD_ComponentType=:comType,
					PD_SupportJump=:supJump
			WHERE PD_Id=:id
		)
	}
	
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2019-11-19
/// DESC: 得到Message信息
/// IN  :  
/// OUT : 
/// w ##class(web.DHCDocPageDom).GetMessageInfo("1||2")
ClassMethod GetMessageInfo(msid As %String = "", sp As %String = "") As %String
{
	n (msid,sp)
	s mRtn=""
	Q:msid="" ""
	i sp="" s sp="^"
	s outObj=##class(User.DHCDocOrderMessage).%OpenId(msid)
	i $ISObject(outObj) {
		//
		s mCode=outObj.DOMCode
		s mDesc=outObj.DOMDesc
		s mOhter=outObj.DOMOtherDesc
		s mRtn=mCode_sp_mDesc_sp_mOhter
		d outObj.%Close()
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-11-19
/// DESC: 得到Message信息
/// IN  :  
/// OUT : 
/// w ##class(web.DHCDocPageDom).GetKeyInfo("55||1")
ClassMethod GetKeyInfo(keyid As %String = "", sp As %String = "") As %String
{
	n (keyid,sp)
	s mRtn=""
	Q:keyid="" ""
	i sp="" s sp="^"
	s outObj=##class(User.DHCDocShortCutKey).%OpenId(keyid)
	i $ISObject(outObj) {
		s mCode=outObj.DSKItemID
		s mKey=outObj.DSKShortCutKey
		s mCallBack=outObj.DSKCallBackFun
		S mDesc=outObj.DSKItemDesc
		s mRtn=mCode_sp_mKey_sp_mCallBack_sp_mDesc
		d outObj.%Close()
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-11-19
/// DESC: 保存快捷键
/// IN  :  
/// OUT : 
/// w ##class(web.DHCDocPageDom).GetKeyInfo("55||1")
ClassMethod updateShortcutKey(ID As %String, DOPRowId As %String, ItemID As %String, ItemShortcutKey As %String, ShortcutKeyCallFun As %String, ItemDesc As %String) As %String
{
	n (ID,DOPRowId,ItemID,ItemShortcutKey,ShortcutKeyCallFun,ItemDesc)
	q:DOPRowId="" "-1^未选择行"
	s ^TEMP("QP","updateShortcutKey")=$LB(ID,DOPRowId,ItemID,ItemShortcutKey,ShortcutKeyCallFun)
	s ItemShortcutKey=$zcvt(ItemShortcutKey,"U")
	q:'(("^F1^F2^F3^F4^F5^F6^F7^F8^F9^F10^F11^F12^")[("^"_ItemShortcutKey_"^")) "-2^快捷键只能是F1~F12"
	s repeat=0
    s Rowid=0
 	f  s Rowid=$o(^DHCDocSCK(DOPRowId,Rowid)) q:(Rowid="")||(repeat=1)  d
 	.s itemid=$p($g(^DHCDocSCK(DOPRowId,Rowid)),"^",1)
 	.s shortcutkey=$p($g(^DHCDocSCK(DOPRowId,Rowid)),"^",2)
 	.if ((itemid=ItemID)||(ItemShortcutKey=shortcutkey))&&(ID'=(DOPRowId_"||"_Rowid)) s repeat=1
 	Q:repeat=1 "-1^已经存在相同元素ID/快捷键"
	i ID="" {
	  	&sql(insert into SQLUser.DHC_DocShortCutKey(DSK_DOP_ParRef,DSK_ItemID,DSK_ShortCutKey,DSK_CallBackFun,DSK_ItemDesc) values (:DOPRowId,:ItemID,:ItemShortcutKey,:ShortcutKeyCallFun,:ItemDesc))
	}else {
		&sql(Update  SQLUser.DHC_DocShortCutKey  set DSK_ItemID=:ItemID,DSK_ShortCutKey=:ItemShortcutKey,DSK_CallBackFun=:ShortcutKeyCallFun,DSK_ItemDesc=:ItemDesc where DSK_RowId=:ID)
	}
	q SQLCODE
}

/// CTOR: QP
/// DATE: 2019-10-31
/// DESC: 得到本页面的快捷键设置
/// IN  :  
/// OUT : 1:是，0：否
/// w ##class(web.DHCDocPageDom).GetShortKey("oeorder.oplistcustom.new.csp")
ClassMethod GetShortKey(pageCode As %String = "") As %String
{
	n (pageCode)
	s mRtn=""
	Q:(pageCode="") mRtn
	q:'$d(^DHCDocOPi("Code",0,pageCode)) mRtn
	s PDParRef=$o(^DHCDocOPi("Code",0,pageCode,0))
	q:PDParRef="" mRtn
	q:'$d(^DHCDocSCK(PDParRef,0)) mRtn
	s mRtn="{"
	s sub=0,count=0
	f  s sub=$o(^DHCDocSCK(PDParRef,sub)) q:sub=""  d
	.s itemId=$p(^DHCDocSCK(PDParRef,sub),"^",1)
	.s key=$p(^DHCDocSCK(PDParRef,sub),"^",2)
	.s callback=$p(^DHCDocSCK(PDParRef,sub),"^",3)
	.s desc=$p(^DHCDocSCK(PDParRef,sub),"^",4)
	.s record=callback_"^"_desc
	.s count=count+1
	.i count=1 s mRtn=mRtn_""""_key_""":"""_callback_""""
	.e  s mRtn=mRtn_","""_key_""":"""_callback_""""
	s mRtn=mRtn_"}"
	
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-10-31
/// DESC: 得到本页面的快捷键设置
/// IN  :  
/// OUT : 1:是，0：否
/// w ##class(web.DHCDocPageDom).GetKeyDesc("oeorder.oplistcustom.new.csp")
ClassMethod GetKeyDesc(pageCode As %String = "") As %String
{
	n (pageCode)
	s mRtn=""
	Q:(pageCode="") mRtn
	q:'$d(^DHCDocOPi("Code",0,pageCode)) mRtn
	s PDParRef=$o(^DHCDocOPi("Code",0,pageCode,0))
	q:PDParRef="" mRtn
	q:'$d(^DHCDocSCK(PDParRef,0)) mRtn
	s mRtn="{"
	s sub=0,count=0
	f  s sub=$o(^DHCDocSCK(PDParRef,sub)) q:sub=""  d
	.s itemId=$p(^DHCDocSCK(PDParRef,sub),"^",1)
	.s key=$p(^DHCDocSCK(PDParRef,sub),"^",2)
	.s callback=$p(^DHCDocSCK(PDParRef,sub),"^",3)
	.s desc=$p(^DHCDocSCK(PDParRef,sub),"^",4)
	.s record=callback_"^"_desc
	.s count=count+1
	.i count=1 s mRtn=mRtn_""""_itemId_""":"""_desc_""""
	.e  s mRtn=mRtn_","""_itemId_""":"""_desc_""""
	s mRtn=mRtn_"}"
	
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-12-09
/// DESC: 查询快捷键设置
/// IN  :  
/// OUT : 1:是，0：否
/// EXEC: d ##class(%ResultSet).RunQuery("web.DHCDocPageDom","GetShortcutKey",56)
Query GetShortcutKey(DOPRowId) As %Library.Query(CONTAINID = 0, ROWSPEC = "rowid:%String,ItemID:%String,ShortcutKey:%String,callBackFun:%String,ItemDesc") [ SqlProc ]
{
}

ClassMethod GetShortcutKeyExecute(ByRef qHandle As %Binary, DOPRowId) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s desc="",rowid="",mrdesc=""
	i DOPRowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s Rowid=0
 	f  s Rowid=$o(^DHCDocSCK(DOPRowId,Rowid)) q:Rowid=""  d
 	.s ItemID=$p($g(^DHCDocSCK(DOPRowId,Rowid)),"^",1)
 	.s ShortcutKey=$p($g(^DHCDocSCK(DOPRowId,Rowid)),"^",2)
 	.s callBackFun=$p($g(^DHCDocSCK(DOPRowId,Rowid)),"^",3)
 	.s ItemDesc=$p($g(^DHCDocSCK(DOPRowId,Rowid)),"^",4)
 	.d OutputRow5
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(DOPRowId_"||"_Rowid,ItemID,ShortcutKey,callBackFun,ItemDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetShortcutKeyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShortcutKeyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	}
	Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetShortcutKeyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShortcutKeyExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-12-09
/// DESC: 
/// IN  :  
/// OUT : 1:是，0：否
/// EXEC: d ##class(%ResultSet).RunQuery("web.DHCDocPageDom","QryKey")
Query QryKey() As %Library.Query(CONTAINID = 0, ROWSPEC = "id,desc") [ SqlProc ]
{
}

ClassMethod QryKeyExecute(ByRef qHandle As %Binary, DOPRowId) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s mArr="F1^F2^F4^F6^F7^F8^F9^F10"
	s len=$l(mArr,"^")
	f i=1:1:len {
		s id=$P(mArr,"^",i)
		s desc=id
		d OutputRow6
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(id,desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryKeyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryKeyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	}
	Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryKeyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryKeyExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 医生站应用配置页面csp缓存
ClassMethod SaveConfigPage(Str As %String) As %String
{
	s DOPCode=$p(Str,"^",1)
	s DOPDesc=$p(Str,"^",2)
	s DOPProductLine=$p(Str,"^",3) 
	s DOPMainCSPCode=$p(Str,"^",4)
	s DOPMainCSPDesc=$p(Str,"^",5) 
	s DOPMainCSPIsLink=$p(Str,"^",6)
	Q:($d(^DHCDocOPi("Code",0,DOPCode))) "-1^已经存在相同代码"
	&sql(insert into SQLUser.DHC_DocOrderPage  (DOP_Code,DOP_Desc,DOP_ProductLine,DOP_MainCSPCode,DOP_MainCSPDesc,DOP_MainCSPIsLink)
	values (:DOPCode,:DOPDesc,:DOPProductLine,:DOPMainCSPCode,:DOPMainCSPDesc,:DOPMainCSPIsLink))
	Q SQLCODE
}

}
