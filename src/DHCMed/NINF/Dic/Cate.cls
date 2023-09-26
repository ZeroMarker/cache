/// 名称: DHCMed.NINF.Dic.Cate
/// 描述: 院感字典分类表，存储各种多级分类信息
/// 编写者：wuqk
/// 编写日期: 2013-02-25
Class DHCMed.NINF.Dic.Cate Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// Code 代码
Property Code As %Library.String(TRUNCATE = 1);

/// Desc 描述
Property Description As %Library.String(TRUNCATE = 1);

/// Type 类型  SYS为系统分类
Property Type As %Library.String(TRUNCATE = 1);

/// HospitalDr 医院 指向 CT_Hospital
Property HospitalDr As %String(TRUNCATE = 1);

/// Active 是否有效，活动
Property Active As %Boolean;

/// DateFrom 起始日期
Property DateFrom As %Library.Date;

/// DateTo  结束日期
Property DateTo As %Library.Date;

/// StrA  备用字段1
Property StrA As %Library.String(TRUNCATE = 1);

/// StrB  备用字段2
Property StrB As %Library.String(TRUNCATE = 1);

/// StrC  备用字段3
Property StrC As %Library.String(TRUNCATE = 1);

/// StrD  备用字段4
Property StrD As %Library.String(TRUNCATE = 1);

/// 以代码为索引
Index IndexCode On Code [ Unique ];

/// 以类型、代码为索引
Index IndexTypeCode On (Type, Code);

/// 以类型、描述为索引
Index IndexTypeDesc On (Type, Description);

/// Creator：     wuqk
/// CreatDate：   2013-02-25
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.NINF.Dic.Cate
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:Code 3:Description 4:Type 5:HospitalDr 6:Active 7:DateFrom 8:DateTo
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..Code_separete
	set return=return_..Description_separete
	set return=return_..Type_separete
	set return=return_..HospitalDr_separete
	set return=return_..Active_separete
    set DateFrom=""
    set DateTo=""
    set:+..DateFrom'=0 DateFrom=$zd(..DateFrom,3)
	set:+..DateTo'=0 DateTo=$zd(..DateTo,3)
	set return=return_DateFrom_separete
	set return=return_DateTo_separete
	//set return=return_..ProductCode_separete
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2013-02-25
/// Description:  根据ID取分类对象
/// Table：       DHCMed.NINF.Dic.Cate
/// Input：       ID:    DHCMed.NINF.Dic.Cate.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.NINF.Dic.Cate).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.Dic.Cate
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.Dic.Cate).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.Dic.Cate).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2013-02-25
/// Description:  根据ID取分类信息
/// Table：       DHCMed.NINF.Dic.Cate
/// Input：       ID:    DHCMed.NINF.Dic.Cate.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.NINF.Dic.Cate).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2013-02-25
/// Description:  更新分类
/// Table：       DHCMed.NINF.Dic.Cate
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:Code 3:Description 4:Type 5:HospitalDr 6:Active 7:DateFrom 8:DateTo
/// w ##class(DHCMed.NINF.Dic.Cate).Update("^^aaa^MDRPY^^1^^^","")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	New (InStr,separete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(separete)="" separete=..#SEPARATE
	Set ID=$p(InStr,separete,1)
	Set Code=$p(InStr,separete,2)
	Set Desc=$p(InStr,separete,3)
	Set TypeCode=$p(InStr,separete,4)
	
	//如果分类下已维护分类项目，不允许新建子类
	Quit:$d(^DHCMed.NINFDi("CateItem",0,"IndexTypeCode"," "_$zcvt(TypeCode,"U"))) -2
	
	//特殊处理,主要是针对重复导数据问题
	If (ID="")&&(Code'="") {
		Set ID=$o(^DHCMed.NINFDi("Cate",0,"IndexTypeCode"," "_$ZCVT(TypeCode,"U")," "_$ZCVT(Code,"U"),0))
	}
	If ID="" {
		Set obj=##class(DHCMed.NINF.Dic.Cate).%New()
		If Code="" {
			//如果代码为空，自动生成代码
			Set Code=$o(^DHCMed.NINFDi("Cate",0,"IndexTypeCode"," "_$ZCVT(TypeCode,"U")," "_$ZCVT(TypeCode,"U")_"999"),-1)
			Set Num=+$e(Code,$l($ZCVT(TypeCode,"U"))+2,$l(Code))
			Set Num=Num+1
			Set Code=""
			Set $p(Code,"0",4-$l(Num))=Num
			Set Code=TypeCode_Code
		}
	}Else{
		Set obj=##class(DHCMed.NINF.Dic.Cate).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Code=Code
	Set obj.Description=Desc
	Set obj.Type=TypeCode
	Set obj.HospitalDr=+$p(InStr,separete,5)
	Set obj.Active=+$p(InStr,separete,6)
	Set DateFrom=$p(InStr,separete,7)
	;Set:DateFrom'="" DateFrom=$zdh(DateFrom,3)
	Set:DateFrom'="" DateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DateFrom)
	Set obj.DateFrom=DateFrom
	Set DateTo=$p(InStr,separete,8)
	;Set:DateTo'="" DateTo=$zdh(DateTo,3)
	Set:DateTo'="" DateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DateTo)
	Set obj.DateTo=DateTo
	
	//Set obj.HospitalDr=+$p(InStr,separete,5)
	//Set obj.Active=$p(InStr,separete,6)
	//Set DateFrom=$p(InStr,separete,7)
	//Set:DateFrom'="" DateFrom=$zdh(DateFrom,3)
	//Set obj.DateFrom=DateFrom
	//Set DateTo=$p(InStr,separete,8)
	//Set:DateTo'="" DateTo=$zdh(DateTo,3)
	//Set obj.DateTo=DateTo
	//Set obj.ProductCode=$p(InStr,separete,9)
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     wuqk
/// CreatDate：   2013-02-25
/// Description:  删除配置
/// Table：       DHCMed.NINF.Dic.Cate
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.NINF.Dic.Cate).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Creator：     wuqk
/// CreatDate：   2013-02-25
/// 功能：通过字典的类别、代码查询字典项目
/// 参数描述：
/// Type:字典类别
/// Code:字典项目代码
/// set obj = ##class(DHCMed.NINF.Dic.Cate).GetObjByCode(code)
ClassMethod GetObjByCode(argCode As %String, argIsActive As %String = "") As DHCMed.NINF.Dic.Cate
{
	New (argCode,argIsActive)
	Set return=""
	Quit:(argCode="") return
	
	Quit:'$d(^DHCMed.NINFDi("Cate",0,"IndexCode"," "_$ZCVT(argCode,"U"))) return
	Set Rowid=""
	For {
		Set Rowid=$o(^DHCMed.NINFDi("Cate",0,"IndexCode"," "_$ZCVT(argCode,"U"),Rowid))
		Quit:Rowid=""
		
		Set objDic=..GetObjById(Rowid)
		Continue:'$IsObject(objDic)
		Set IsActive=objDic.Active
		Continue:(argIsActive'="")&&(IsActive'=argIsActive)
		Set return=objDic
	}
	
	Quit return
}

/// Creator：     wuqk
/// CreatDate：   2013-02-26
/// 查询树
/// D ##class(%ResultSet).RunQuery("DHCMed.NINF.Dic.Cate","QueryByType","","INFPY","")
Query QueryByType(aDicTypeID As %String, aDicTypeCode As %String, aIsActive As %String) As %Query(ROWSPEC = "ID:%String,Active:%String:活动,Code:%String:代码,DateFrom:%String:生效日期,DateTo:%String:废止日期,Description:%String:描述,HospitalDr:%String,HOSPDesc:%String,StrA:%String,StrB:%String,StrC:%String,StrD:%String,Type:%String") [ SqlProc ]
{
}

ClassMethod QueryByTypeExecute(ByRef qHandle As %Binary, aDicTypeID As %String, aDicTypeCode As %String, aIsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	if aDicTypeID'="" {
	 	set objDicType=##class(DHCMed.NINF.Dic.Cate).GetObjById(aDicTypeID)
	 	if $d(objDicType) {
		 	set aDicTypeCode=objDicType.Code
		}
	}
 	
 	set codeActive=""
 	set xcode = " "_$zcvt(aDicTypeCode,"U")
 	for {
		set xcode=$o(^DHCMed.NINFDi("Cate",0,"IndexCode",xcode))
		quit:xcode=""
		
		continue:$e(xcode,2,$l($zcvt(aDicTypeCode,"U"))+1)'=$zcvt(aDicTypeCode,"U")
		
		set rowid=0
		for {
		 	set rowid=$o(^DHCMed.NINFDi("Cate",0,"IndexCode",xcode,rowid))
		 	quit:rowid=""
	 		
		 	set objCate=..GetObjById(rowid)
		 	if $IsObject(objCate) {
			 	set Type=objCate.Type
			 	set Active=objCate.Active
			 	set Code=objCate.Code
			 	set Description=objCate.Description
			 	
			 	//判定，大类无效，大类下的子类都无效
			 	if aIsActive'="" {
				 	if codeActive="" {
					 	if aIsActive'=Active {
						 	set codeActive=Code
						 	continue
					 	}
				 	} else {
					 	if $p(Code,codeActive,2)'="" {
						 	continue
						} else {
							set codeActive=""
							if aIsActive'=Active {
							 	set codeActive=Code
							 	continue
						 	}
						}
					}
			 	}
			 	
			 	set num=(($l(Code)-$l(aDicTypeCode))\3)
			 	set tmp="",$p(tmp,"----",num)=""
			 	set Description=tmp_Description
			 	
			 	set DateFrom=objCate.DateFrom
			 	set DateTo=objCate.DateTo
			 	set HospitalDr=objCate.HospitalDr
			 	set HospitalDesc=$p($g(^CT("HOSP",+HospitalDr)),"^",2)
			 	set StrA=objCate.StrA
			 	set StrB=objCate.StrB
			 	set StrC=objCate.StrC
			 	set StrD=objCate.StrD
			 	set Data=$lb(rowid,Active,Code,DateFrom,DateTo,Description,HospitalDr,HospitalDesc,StrA,StrB,StrC,StrD,Type)
			 	set ^CacheTemp(repid,ind)=Data
			 	set ind=ind+1
		 	}
		}
	}
 	
	Quit $$$OK
}

ClassMethod QueryByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     wuqk
/// CreatDate：   2013-02-26
/// 查询树
/// D ##class(%ResultSet).RunQuery("DHCMed.NINF.Dic.Cate","QueryByType02","INFPY","")
Query QueryByType02(aDicTypeCode As %String, aIsActive As %String) As %Query(ROWSPEC = "ID:%String,Active:%String:活动,Code:%String:代码,DateFrom:%String:生效日期,DateTo:%String:废止日期,Description:%String:描述,HospitalDr:%String,HOSPDesc:%String,StrA:%String,StrB:%String,StrC:%String,StrD:%String,Type:%String") [ SqlProc ]
{
}

ClassMethod QueryByType02Execute(ByRef qHandle As %Binary, aDicTypeCode As %String, aIsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xCode=""
 	For {
	 	Set xCode=$o(^DHCMed.NINFDi("Cate",0,"IndexTypeCode"," "_$zcvt(aDicTypeCode,"U"),xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCMed.NINFDi("Cate",0,"IndexTypeCode"," "_$zcvt(aDicTypeCode,"U"),xCode,xID))
			Quit:xID=""
			
			Set objCate=..GetObjById(xID)
			Continue:'$IsObject(objCate)
		 	Set Type=objCate.Type
		 	Set Active=objCate.Active
		 	Set Code=objCate.Code
		 	Set Description=objCate.Description
		 	Continue:(aIsActive'="")&&(aIsActive'=Active)
		 	
		 	Set DateFrom=objCate.DateFrom
		 	;Set:DateFrom'="" DateFrom=$zdt(DateFrom,3)  //add by likai20140709 
		 	Set:DateFrom'="" DateFrom=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DateFrom)
		 	Set DateTo=objCate.DateTo
		 	;Set:DateTo'="" DateTo=$zdt(DateTo,3)   //add by likai20140709
		 	Set:DateTo'="" DateTo=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DateTo)
		 	Set HospitalDr=objCate.HospitalDr
		 	Set HospitalDesc=$p($g(^CT("HOSP",+HospitalDr)),"^",2)
		 	Set StrA=objCate.StrA
		 	Set StrB=objCate.StrB
		 	Set StrC=objCate.StrC
		 	Set StrD=objCate.StrD
		 	Set Data=$lb(xID,Active,Code,DateFrom,DateTo,Description,HospitalDr,HospitalDesc,StrA,StrB,StrC,StrD,Type)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}
 	
	Quit $$$OK
}

ClassMethod QueryByType02Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByType02Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByType02Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByType02Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod DeleteDictionarys(aTypeCode As %String) As %String
{
	New (aTypeCode)
	Set return=-1
	Quit:aTypeCode="" return
	
	Set $ZT="DeleteDictionarysErr"
	
	Set DicID=0
	For {
		Set DicID=$o(^DHCMed.NINFDi("Cate",0," "_$ZCVT(aTypeCode,"U"),DicID))
		Quit:DicID=""
		Set flg=..DeleteById(DicID)
	}
	
	Set DicID=$o(^DHCMed.NINFDi("Cate",0," SYS"," "_$ZCVT(aTypeCode,"U"),0))
	If DicID'="" {
		Set flg=..DeleteById(DicID)
	}
	
	Set return=1
	Quit return
	
DeleteDictionarysErr
	Write "Error:"_$ZError,!
	Quit -999
}

/// Creator：     wuqk
/// CreatDate：   2013-02-26
/// 查询树
/// D ##class(%ResultSet).RunQuery("DHCMed.NINF.Dic.Cate","QryCateTree","")
Query QryCateTree(Type As %String) As %Query(ROWSPEC = "id:%String,text:%String,icon:%String,leaf:%String") [ SqlProc ]
{
}

ClassMethod QryCateTreeExecute(ByRef qHandle As %Binary, Type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1	
 	
 	set Type = $zcvt($p(Type,"-",2),"U")
 	
 	SET code = ""
 	while (1)
 	{
	 	set code=$o(^DHCMed.NINFDi("Cate",0,"IndexTypeCode"," "_Type,code))
	 	//w !,"Code="_code
	 	quit:code=""
	 	set rowid=$o(^DHCMed.NINFDi("Cate",0,"IndexTypeCode"," "_Type,code,""))
	 	//w !,"rowid="_rowid
	 	quit:rowid=""
	 	set objCate=##class(DHCMed.NINF.Dic.Cate).%OpenId(rowid)
	 	if (objCate'="")
	 	{
		 	d objCate.%Close()
		 	set data=$lb("")
		 	set $li(data,1)="dicType-"_objCate.Code_"-"_objCate.%Id()
		 	set $li(data,2)=objCate.Description
		 	set iconFileName="menudic.gif"
		 	//set $li(data,3)="../scripts/dhcmed/img/"_iconFileName
		 	set $li(data,4)=1
		 	set:$d(^DHCMed.NINFDi("Cate",0,"IndexTypeCode"," "_$ZCVT(objCate.Code,"U"))) $li(data,4)=0
		 	set ^CacheTemp(repid,ind)=data
		 	set ind=ind+1
	 	}
	 }	
	
	
	Quit $$$OK
}

ClassMethod QryCateTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCateTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCateTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCateTreeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

Storage Default
{
<Data name="CateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>HospitalDr</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>DateFrom</Value>
</Value>
<Value name="8">
<Value>DateTo</Value>
</Value>
<Value name="9">
<Value>StrA</Value>
</Value>
<Value name="10">
<Value>StrB</Value>
</Value>
<Value name="11">
<Value>StrC</Value>
</Value>
<Value name="12">
<Value>StrD</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFD("Cate")</DataLocation>
<DefaultData>CateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFD("Cate")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("Cate",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.CateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
