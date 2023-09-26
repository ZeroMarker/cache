/// CTOR: QP
/// DATE: 2021-11-12
/// DESC: 医生站交班本翻译类
Class DHCDoc.PW.CFG.BCTranslate Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-11-12
/// DESC: 翻译类型
/// IN  : InModule(产品线代码)：患者管理(Reg)、预约挂号系统(OPAdm)、 门诊护士分诊系统(Alloc)、门诊医生站(OPDoc)
/// 		  住院医嘱系统(IPDoc)、临床药理试验系统(Pilot)、 治疗科室系统(Cure)、抗菌药物管理(Ant)、
/// 		  医生交班本(PW)、化疗管理系统(Chemo)
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.PW.CFG.BCTranslate","QryType","Pilot")
Query QryType(InModule = "", InCode = "", InHosp = "") As %Library.Query(ROWSPEC = "id,pline,name,code")
{
}

ClassMethod QryTypeExecute(ByRef qHandle As %Library.Binary, InModule = "", InCode = "", InHosp = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i InModule="" {
		//Set qHandle=$lb(0,repid,0)
		//Quit $$$OK
	}
	s InCode=$zcvt(InCode,"U")
	
	s plineCode=""
	f  s plineCode=$o(^User.DHCDocPassWorkTranslateI("TProductLine",plineCode)) q:plineCode=""  d
	.s id=""
	.q:(InModule'="")&&(InModule'=plineCode)
	.f  s id=$o(^User.DHCDocPassWorkTranslateI("TProductLine",plineCode,id)) q:id=""  d
	..s pline=##class(DHCDoc.DHCDocConfig.LocalConfig).GetProductLine(.Product,plineCode)
	..s code=$lg(^User.DHCDocPassWorkTranslateD(id),3)
	..s codeU=$zcvt(code,"U")
	..s name=$lg(^User.DHCDocPassWorkTranslateD(id),4)
	..s nameU=$zcvt(name,"U")
	..s exit=1
	..i InCode'="" d
	...i codeU[InCode s exit=0
	...i nameU[InCode s exit=0
	..e  d
	...s exit=0
	..q:exit=1
	..d OuputRow1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
	/*
	k OUTList
	i InModule="PW" {
		s OUTList("User.DHCDocPassWorkBCTime")="班次信息"
		s OUTList("User.DHCDocPassWorkBCPatType")="病人类型"
	}
	i InModule="Pilot" {
		s OUTList("User.DHCDocPilotProStage")="项目阶段"
	}
	s id=""
	f  s id=$o(OUTList(id)) q:id=""  d
	.s text=OUTList(id)
	.d OuputRow1
	*/
	
 	
OuputRow1
	set Data=$lb(id,pline,name,code)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryTypeFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryTypeClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryTypeFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2021-11-12
/// DESC: 翻译类型
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.PW.CFG.BCTranslate","QryTableItem","User.DHCDocPassWorkBCTime")
Query QryTableItem(TableName = "") As %Library.Query(ROWSPEC = "id,text")
{
}

ClassMethod QryTableItemExecute(ByRef qHandle As %Library.Binary, TableName = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	
	s myobj=##class(%Dictionary.CompiledClass).%OpenId(TableName)
	s myCount = myobj.Properties.Count()
	For i = 1:1:myCount {
		s myproperty=myobj.Properties.GetAt(i)
		s myName=myproperty.Name
		s myDesc=myproperty.Description 
		continue:(myName["%")||(myName="")	
		s id=myName
		i myDesc="" s text=myName
		e  s text=myName_" "_myDesc
		d OuputRow1
	}
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	set Data=$lb(id,text)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryTableItemFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryTableItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryTableItemClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryTableItemFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 保存/更新交班本配置
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCTranslate).Save("1","PW^User.DHCDocPassWorkBCTime^班次信息")
ClassMethod Save(ID = "", inPara = "") As %String
{
	
	s ProductLine=$p(inPara,"^",1)
	s BCode=$p(inPara,"^",2)
	s BName=$p(inPara,"^",3)
	Q:ProductLine="" "-1^产品线为空！"
	Q:BCode="" "-1^表名为空！"
	Q:BName="" "-1^描述为空！"
	s HasFlag=..IsAdd(ID,inPara)
	Q:+HasFlag<0 HasFlag
	
	i ID = "" s SaveOBJ = ##class(User.DHCDocPassWorkTranslate).%New()
	e  s SaveOBJ = ##class(User.DHCDocPassWorkTranslate).%OpenId(ID)
	s SaveOBJ.TProductLine=ProductLine
	S SaveOBJ.TCode=BCode
	S SaveOBJ.TDesc=BName
	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		Quit "-1^保存失败！"
	}
	q SaveOBJ.%Id()_"^保存成功！"
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 判断能否添加
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCTranslate).Save("","1^1")
ClassMethod IsAdd(ID = "", inPara = "") As %String
{
	s ProductLine=$p(inPara,"^",1)
	s BCode=$p(inPara,"^",2)
	s BName=$p(inPara,"^",3)
	if (ID="") {
		i $d(^User.DHCDocPassWorkTranslateI("TCode",BCode)) {
			Q "-1^表名已经存在不允许重复添加！"
		}
	} else {
		s oldCode=$lg(^User.DHCDocPassWorkTranslateD(ID),3)
		i $d(^User.DHCDocPassWorkTranslateI("TCode",BCode)) {
			i (oldCode'=BCode) {
				Q "-1^表名已经存在不允许重复添加！"
			}
		}
	}
	Q 0
}

/// CTOR: QP
/// DATE: 2021-11-16
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCTranslate).Delete("")
ClassMethod Delete(ID As %String)
{
	Q:ID="" 0
	s tableName=$lg(^User.DHCDocPassWorkTranslateD(ID),3)
	&SQL(DELETE FROM SQLUser.DHCDocPassWorkTranslate WHERE ID=:ID)
	Q:SQLCODE'=0 "-102"
	d ##class(web.DHCBL.BDP.BDPTranslation).DeleteTableData(tableName)
	
	Q 0
}

/// CTOR: QP
/// DATE: 2021-11-16
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCTranslate).Delete("")
ClassMethod GetTablePropertyList(TableName = "", ByRef TList)
{
	
	s myobj=##class(%Dictionary.CompiledClass).%OpenId(TableName)
	s myCount = myobj.Properties.Count()
	For i = 1:1:myCount {
		s myproperty=myobj.Properties.GetAt(i)
		s myName=myproperty.Name
		s myDesc=myproperty.Description 
		continue:(myName["%")||(myName="")	
		s id=myName
		i myDesc="" s text=myName
		e  s text=myName_" "_myDesc
		s TList(myName)=text
	}
	
	Q ""
}

/// CTOR: QP
/// DATE: 2021-11-19
/// DESC: 查询 平台翻译 
/// IN  : rowid,tablename 表名,fieldname 字段名,language 语言,fielddesc 翻译前中文
/// 		
/// OUT : 
/// TABL: User.BDPTranslation 平台翻译
/// EXEC: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPTranslation","GetListHISUI","","","","","")
Query GetListHISUI(rowid As %String, tablename As %String, fieldname As %String, language As %String, fielddesc As %String) As %Query(ROWSPEC = "ID,BTTableName,BTFieldName,BTLanguages,BTFieldDesc,BTTransDesc")
{
}

ClassMethod GetListHISUIExecute(ByRef qHandle As %Binary, rowid As %String, tablename As %String, fieldname As %String, language As %String, fielddesc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    k TList
    d ..GetTablePropertyList(tablename,.TList)
    if (rowid'="")
    {
        
        s ID=rowid
        s BTTableName=$lg($g(^User.BDPTranslationD(ID)),2)  //表名
        s TableID=""
        s:BTTableName'="" TableID=$o(^User.BDPTableListI("UqIndex"," "_$ZCONVERT(BTTableName,"U"),0))
        s TableDesc=""
        s:TableID'="" TableDesc=$LISTGET($G(^User.BDPTableListD(TableID)),3)    //表 中文名
        s BTTableName=BTTableName_"("_TableDesc_")"
        s BTFieldName=$lg($g(^User.BDPTranslationD(ID)),3)  //字段名
        s FieldID=""
        s:(BTFieldName'="")&&(TableID'="") FieldID=$o(^User.BDPTableFieldI("NameIndex"," "_$ZCONVERT(BTFieldName,"U"),TableID,0))
        s FieldDesc=""
        s:(FieldID'="")&&(TableID'="") FieldDesc=$LISTGET($G(^User.BDPTableListD(TableID,"ChildField",FieldID)),2)  //字段名描述
        s BTFieldName=BTFieldName_"("_FieldDesc_")"

        s BTLanguages=$lg($g(^User.BDPTranslationD(ID)),4)  //语言
        if (BTLanguages'="")
        {
            s LanRowId = $o(^SS("LAN",0,"Code",$$ALPHAUP^SSUTIL4(BTLanguages),0))       //转换大写方法
            s:LanRowId'="" BTLanguages = $p($g(^SS("LAN",LanRowId)),"^",2)
        }
        s BTFieldDesc=$lg($g(^User.BDPTranslationD(ID)),5)  //翻译前中文
        s BTTransDesc=$lg($g(^User.BDPTranslationD(ID)),6)  //翻译后内容
        d OutputRow
    }
    else
    {
        s:tablename'="" tablename=$ZCONVERT(tablename,"U")
        s:fieldname'="" fieldname=$ZCONVERT(fieldname,"U")
        s:fielddesc'="" fielddesc=$ZCONVERT(fielddesc,"U")
        
        s ID=0
        for
        {
            //ID,BTTableName,BTFieldName,BTLanguages,BTFieldDesc,BTTransDesc
            s ID=$o(^User.BDPTranslationD(ID)) q:ID=""
            
            s BTTableName=$lg($g(^User.BDPTranslationD(ID)),2)  //表名
            s TableID=""
            
            s:BTTableName'="" TableID=$o(^User.BDPTableListI("UqIndex"," "_$ZCONVERT(BTTableName,"U"),0))
            s TableDesc=""
            s:TableID'="" TableDesc=$LISTGET($G(^User.BDPTableListD(TableID)),3)    //表 中文名
            ;s BTTableName=BTTableName_"("_TableDesc_")"
            s TNPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BTTableName) 
            
            s BTFieldName=$lg($g(^User.BDPTranslationD(ID)),3)  //字段名
            s FieldID=""
            s:(BTFieldName'="")&&(TableID'="") FieldID=$o(^User.BDPTableFieldI("NameIndex"," "_$ZCONVERT(BTFieldName,"U"),TableID,0))
            s FieldDesc=""
            s:(TableID'="")&&(FieldID'="") FieldDesc=$LISTGET($G(^User.BDPTableListD(TableID,"ChildField",FieldID)),2)  //字段名描述
            ;s BTFieldName=BTFieldName_"("_FieldDesc_")"
            i $d(TList(BTFieldName)) s BTFieldName=TList(BTFieldName)
            s FNPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BTFieldName)
            
            continue:'(($ZCONVERT(BTFieldName,"U")[fieldname)||(FNPYCode[fieldname))
            s BTLanguages=$lg($g(^User.BDPTranslationD(ID)),4)  //语言
            if (BTLanguages'="")    //语言不为空
            {
                continue:(language'="")&&(language'=BTLanguages)
                s LanRowId = $o(^SS("LAN",0,"Code",$$ALPHAUP^SSUTIL4(BTLanguages),0))   //根据代码获取id
                s:LanRowId'="" BTLanguages = $p($g(^SS("LAN",LanRowId)),"^",2)
            }
            
            
            s BTFieldDesc=$lg($g(^User.BDPTranslationD(ID)),5)  //翻译前中文
            continue:'($ZCONVERT(BTFieldDesc,"U")[fielddesc)
            
            s BTTransDesc=$lg($g(^User.BDPTranslationD(ID)),6)  //翻译后内容
            if (fieldname'="")           
            {
                ;需要对描述或者别名进行检索 
                s AliasFlag=0     
                s PINYINFlag=""
                s PINYINCODE=""   
                s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(fieldname) /// 是拼音 才去转换拼音码
                if (PINYINFlag=1)
                {
                  s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BTFieldName) 
                }
                if (($ZCONVERT(BTFieldName,"U")[fieldname)||(PINYINCODE[fieldname))      //过滤字段名
                {
                    s AliasFlag= 1  
                } 
            }
            else
            {
                s AliasFlag= 1
            } 
            i (($ZCONVERT(BTTableName,"U")=tablename)||(TNPYCode=tablename))&&(AliasFlag=1) //过滤表名
            {
                d OutputRow
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ID,BTTableName,BTFieldName,BTLanguages,BTFieldDesc,BTTransDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListHISUIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListHISUIExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetListHISUIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListHISUIExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
