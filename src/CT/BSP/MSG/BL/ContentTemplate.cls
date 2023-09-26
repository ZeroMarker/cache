Class CT.BSP.MSG.BL.ContentTemplate Extends %RegisteredObject
{

/// 新增模板分类或草稿分类
ClassMethod AddCatgory(Type, Title, Summary = "", RefType, RefObjId, UserId)
{
	if RefType'="",RefObjId="" s RefObjId=..GetRefObjIdBySession(RefType)
	
	s obj=##class(CT.BSP.MSG.ContentTemplate).%New()
	s obj.Type=Type
	s obj.Title=Title
	s obj.Summary=Summary
	s obj.RefType=RefType
	s obj.RefObjId=RefObjId
	if UserId="",$d(%session) s UserId=%session.Get("LOGON.USERID")
	s obj.UpdateUser=UserId
	s now=$h
	s obj.UpdateDate=+now
	s obj.UpdateTime=+$p(now,",",2)
	
	
	s sc=obj.%Save()
	if $$$ISERR(sc) {
		s obj=""
		q "-1^"_$system.Status.GetErrorText(sc)	
	}
	s Id=obj.%Id()
	s obj=""
	q Id
}

ClassMethod AddContent(Type, Catgory, Title, Summary, Content, RefType = "", RefObjId = "", UserId = "")
{
	if RefType'="",RefObjId="" s RefObjId=..GetRefObjIdBySession(RefType)
	
	s objCat=""
	if Catgory>0 s objCat=##class(CT.BSP.MSG.ContentTemplate).%OpenId(Catgory)	
	if objCat="" q "-1^Catgory="_Catgory_"不正确"
	
	if objCat.Type'=(Type_"C") {
		s objCat=""
		q "-1^内容与分类所属类型不对应"	
	}
	
	if RefType="",RefObjId="" {  //走分类关联
		s RefType=objCat.RefType
		s RefObjId=objCat.RefObjId	
	}
	
	
	s obj=##class(CT.BSP.MSG.ContentTemplate).%New()
	s obj.Type=Type
	s obj.Catgory=objCat
	s obj.Title=Title
	s obj.Summary=Summary
	
	if '$IsObject(obj.Content) s obj.Content=##class(%Stream.GlobalCharacter).%New() 
	if $IsObject(Content) {
		d Content.Rewind()
		while('Content.AtEnd){ 
			d obj.Content.Write( Content.Read())
		}
	}else{
		d obj.Content.Write(Content)	
	}
	
	
	s obj.RefType=RefType
	s obj.RefObjId=RefObjId
	if UserId="",$d(%session) s UserId=%session.Get("LOGON.USERID")
	s obj.UpdateUser=UserId
	s now=$h
	s obj.UpdateDate=+now
	s obj.UpdateTime=+$p(now,",",2)
	
	
	s sc=obj.%Save()
	if $$$ISERR(sc) {
		s obj=""
		q "-1^"_$system.Status.GetErrorText(sc)	
	}
	s Id=obj.%Id()
	s obj="",objCat=""
	q Id
}

ClassMethod OutputContent(Id)
{
	s obj=##class(CT.BSP.MSG.ContentTemplate).%OpenId(Id)
	if $IsObject(obj.Content) {
		while('obj.Content.AtEnd){ 
			w obj.Content.Read()
		}
	}
	s obj=""
	q ""
}

/// 修改模板所属分类
ClassMethod UpdateCatgory(Id, Catgory)
{
	s obj=""
	if Id>0 s obj=##class(CT.BSP.MSG.ContentTemplate).%OpenId(Id)	
	if obj="" q "-1^Id="_Id_"不正确"
	
	s objCat=""
	if Catgory>0 s objCat=##class(CT.BSP.MSG.ContentTemplate).%OpenId(Catgory)	
	if objCat="" q "-1^Catgory="_Catgory_"不正确"
	
	s ret=""
	if objCat.Type=(obj.Type_"C") {
		s obj.Catgory=objCat
		if UserId="",$d(%session) s UserId=%session.Get("LOGON.USERID")
		s obj.UpdateUser=UserId
		s now=$h
		s obj.UpdateDate=+now
		s obj.UpdateTime=+$p(now,",",2)
		s sc=obj.%Save()
		
		if $$$ISERR(sc) {
			s ret= "-1^"_$system.Status.GetErrorText(sc)	
		}else{
			s ret=obj.%Id()	
		}
		
	}else{
		s ret="-1^内容与分类所属类型不对应"	
	}
	s obj="",objCat=""
	q ret
}

/// 标题与摘要修改
ClassMethod UpdateTitleAndSummary(Id, Title = "", Summary, UserId = "")
{
	s obj=""
	if Id>0 s obj=##class(CT.BSP.MSG.ContentTemplate).%OpenId(Id)	
	if obj="" q "-1^Id="_Id_"不正确"
	
	s obj.Title=Title
	s obj.Summary=Summary
	
	if UserId="",$d(%session) s UserId=%session.Get("LOGON.USERID")
	s obj.UpdateUser=UserId
	s now=$h
	s obj.UpdateDate=+now
	s obj.UpdateTime=+$p(now,",",2)
	
	
	s sc=obj.%Save()
	if $$$ISERR(sc) {
		s obj=""
		q "-1^"_$system.Status.GetErrorText(sc)	
	}
	s Id=obj.%Id()
	s obj=""
	q Id
}

/// 模板内容修改
ClassMethod UpdateContent(Id, Content = "", UserId = "")
{
	s obj=""
	if Id>0 s obj=##class(CT.BSP.MSG.ContentTemplate).%OpenId(Id)	
	
	if obj="" q "-1^Id="_Id_"不正确"
	

	if '$IsObject(obj.Content) s obj.Content=##class(%Stream.GlobalCharacter).%New() 
	
	if $IsObject(Content) {
		d Content.Rewind()
		while('Content.AtEnd){ 
			d obj.Content.Write( Content.Read())
		}
		
	}else{
		d obj.Content.Write(Content)	
	}
	
	if UserId="",$d(%session) s UserId=%session.Get("LOGON.USERID")
	s obj.UpdateUser=UserId
	s now=$h
	s obj.UpdateDate=+now
	s obj.UpdateTime=+$p(now,",",2)
	
	
	s sc=obj.%Save()
	if $$$ISERR(sc) {
		s obj=""
		q "-1^"_$system.Status.GetErrorText(sc)	
	}
	s Id=obj.%Id()
	s obj=""
	q Id
}

/// debug:d ##class(%ResultSet).RunQuery("CT.BSP.MSG.BL.ContentTemplate","Find","","")
Query Find(Type = "", RefType = "", RefObjId = "", Catgory = "", Title = "") As websys.Query(CONTAINID = 0, ROWSPEC = "TId,TType,TTypeDesc,TCatgory,TCatgoryDesc,TTitle,TSummary,TContent,TRefType,TRefTypeDesc,TRefObjId,TRefObjDesc,TUpdateUser,TUpdateDate,TUpdateTime")
{
}

ClassMethod FindExecute(ByRef QHandle As %Library.Binary, Type = "", RefType = "", RefObjId = "", Catgory = "", Title = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	set ind=1 s QHandle=$lb(0,repid,0) 
	
	s Title=$zcvt(Title,"U")
	
	if Type'="" s Type=","_Type_","
	s iType=""
	for {
		s iType=$o(^CT.BSP.MSG.ContentTemplateI("TypeRefCat",iType))
		q:iType'=""
		continue:(Type'="")&&(Type'[(","_iType_","))
		
		s iRefType=""
		if RefType'="" s iRefType=$o(^CT.BSP.MSG.ContentTemplateI("TypeRefCat",iType,RefType),-1)
		for {
			s iRefType=$o(^CT.BSP.MSG.ContentTemplateI("TypeRefCat",iType,iRefType))
			q:iRefType=""
			q:(RefType'="")&&(iRefType'=RefType)
			
			s iRefObjId=""
			if RefObjId'="" s iRefObjId=$o(^CT.BSP.MSG.ContentTemplateI("TypeRefCat",iType,iRefType,RefObjId),-1)
			for {
				s iRefObjId=$o(^CT.BSP.MSG.ContentTemplateI("TypeRefCat",iType,iRefType,iRefObjId))
				q:iRefObjId=""
				q:(RefObjId'="")&&(iRefObjId'=RefObjId)
				
				
				s iCatgory=""
				if Catgory'="" s iCatgory=$o(^CT.BSP.MSG.ContentTemplateI("TypeRefCat",iType,iRefType,iRefObjId,Catgory),-1)
				for {
					s iCatgory=	$o(^CT.BSP.MSG.ContentTemplateI("TypeRefCat",iType,iRefType,iRefObjId,iCatgory))
					q:iCatgory=""
					q:(Catgory'="")&&(iCatgory'=Catgory)
					
					s id=""
					for {
						s id=$o(^CT.BSP.MSG.ContentTemplateI("TypeRefCat",iType,iRefType,iRefObjId,iCatgory,id))
						q:id=""
						
						d OutputRow
						
						
						
						
						
					} //end id

				} //end Catgory
				
			} //end RefObjId

		} //end RefType
		
	}  //end Type
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	s g=^CT.BSP.MSG.ContentTemplateD(id)
	s TType=$lg(g,2)
	s TCatgory=$lg(g,3)
	s TTitle=$lg(g,4)
	q:(Title'="")&&($zcvt(TTitle,"U")'[Title)&&(##class(ext.util.String).ToChineseSpell(TTitle)'[Title)
	s TSummary=$lg(g,5)
	s TContent=""
	s TRefType=$lg(g,7)
	s TRefObjId=$lg(g,8)
	s TUpdateUser=$lg(g,9)
	s TUpdateDate=$lg(g,10)
	s TUpdateTime=$lg(g,11)
	
	s TTypeDesc=..GetTypeDesc(TType)
	s TCatgoryDesc=""
	if TCatgory>0 s TCatgoryDesc=..GetCatgoryDesc(TCatgory)
	s TRefTypeDesc=..GetRefTypeDesc(TRefType)
	s TRefObjDesc=..GetRefObjDesc(TRefType,TRefObjId)
	if TUpdateUser>0 s TUpdateUser=$p($g(^SSU("SSUSR",TUpdateUser),"^Err"_TUpdateUser),"^",2)
	if TUpdateDate>0 s TUpdateDate=##class(websys.Conversions).DateLogicalToHtml(TUpdateDate)
	if TUpdateTime'="" s TUpdateTime=$zt(TUpdateTime)

	set Data=$lb(id,TType,TTypeDesc,TCatgory,TCatgoryDesc,TTitle,TSummary,TContent,TRefType,TRefTypeDesc,TRefObjId,TRefObjDesc,TUpdateUser,TUpdateDate,TUpdateTime)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

ClassMethod GetTypeDesc(type)
{
	
	q $case(type,"T":"模板","TC":"模板分类","D":"草稿","DC":"草稿分类",:type)
}

ClassMethod GetRefTypeDesc(reftype)
{
	
	q $case(reftype,"S":"站点","H":"医院","G":"安全组","L":"科室","U":"个人",:reftype)
}

ClassMethod GetRefObjDesc(reftype, objid)
{
	
	if reftype="S" {
		q objid	
	}elseif reftype="H" {
		s desc=$p($g(^CT("HOSP",objid),"^Err"_objid),"^",2)
		q desc	
	}elseif reftype="L" {
		s desc=$p($g(^CTLOC(objid),"^Err"_objid),"^",2)
		q desc	
	}elseif reftype="U" {
		s desc=$p($g(^SSU("SSUSR",objid),"^Err"_objid),"^",2)
		q desc	
	}elseif reftype="G" {
		s desc=$p($g(^SSU("SSGRP",objid),"Err"_objid),"^",1)
		q desc	
	}else{
		q objid	
	}
}

ClassMethod GetCatgoryDesc(Catgory)
{
	q $lg($g(^CT.BSP.MSG.ContentTemplateD(Catgory)),4)
}

/// isSuper 是否是超管
/// 超管树层级：关连类型-对象-分类-模板
/// 个人树层级：关联类型-分类-模板
ClassMethod LazyTree(id = "", type = "T", isSuper = "", user = "", loc = "", group = "", hosp = "", site = "")
{
	if id="" { //根节点 
		if isSuper {  //超管第一层根节点
			w "["
			w "{""id"":""U"",""text"":""个人"",""state"":""closed""}"
			w ",{""id"":""L"",""text"":""科室"",""state"":""closed""}"
			w ",{""id"":""G"",""text"":""安全组"",""state"":""closed""}"
			w ",{""id"":""H"",""text"":""医院"",""state"":""closed""}"
			w ",{""id"":""S"",""text"":""站点"",""state"":""closed""}"
			w "]"
			q ""
			
		}else{  //普通用户第一层根节点
			
			if user="" s user=..GetRefObjIdBySession("U")
			if loc="" s loc=..GetRefObjIdBySession("L")
			if group="" s group=..GetRefObjIdBySession("G")
			if hosp="" s hosp=..GetRefObjIdBySession("H")
			if site="" s site=..GetRefObjIdBySession("S")
			
			w "["
			w "{""id"":""U-"_user_""",""text"":""个人-"_##class(BSP.SYS.COM.ProxyObject).Escape(..GetRefObjDesc("U",user))_""",""state"":""closed""}"
			w ",{""id"":""L-"_loc_""",""text"":""科室-"_##class(BSP.SYS.COM.ProxyObject).Escape(..GetRefObjDesc("L",loc))_""",""state"":""closed""}"
			w ",{""id"":""G-"_group_""",""text"":""安全组-"_##class(BSP.SYS.COM.ProxyObject).Escape(..GetRefObjDesc("G",group))_""",""state"":""closed""}"
			w ",{""id"":""H-"_hosp_""",""text"":""医院-"_##class(BSP.SYS.COM.ProxyObject).Escape(..GetRefObjDesc("H",hosp))_""",""state"":""closed""}"
			w ",{""id"":""S-"_site_""",""text"":""站点-"_##class(BSP.SYS.COM.ProxyObject).Escape(..GetRefObjDesc("S",site))_""",""state"":""closed""}"
			w "]"
			q ""
		}
	}
	if id'="",$l(id,"-")=1 {  //超管第二层  索引所有用户、科室、医院
		
		s iType=type_"C"   //用分类数据的索引结构
		
		w "["
		s refType=id
		s refId=""
		for {
			s refId=$o(^CT.BSP.MSG.ContentTemplateI("TypeRefCat",iType,refType,refId))
			q:refId=""
			s refObjDesc=..GetRefObjDesc(refType,refId)
			
			s myid=refType_"-"_refId,mytext=##class(BSP.SYS.COM.ProxyObject).Escape(refObjDesc)
			if $i(mycnt)>1 w ","
			w "{""id"":"""_myid_""",""text"":"""_mytext_""",""state"":""closed""}"
			
		}
		w "]"
		q ""
	}
	
	if $l(id,"-")=2 { //超管第三层 用户第二层  索引相应 个人、科室、院区、站点的模板分类
		s iType=type_"C"   //用分类数据的索引结构
		w "["
		s refType=$p(id,"-",1),refId=$p(id,"-",2)
		s cat=""
		for {
			s cat=$o(^CT.BSP.MSG.ContentTemplateI("TypeRefCat",iType,refType,refId,cat))
			q:cat=""
			
			/// 模板分类数据的 cat都是空  再循环一层 取到模板分类的数据
			
			s catId=""
			for {
				s catId=$o(^CT.BSP.MSG.ContentTemplateI("TypeRefCat",iType,refType,refId,cat,catId))
				q:catId=""
				
				s catDesc=..GetCatgoryDesc(catId)
				s myid=refType_"-"_refId_"-"_catId,mytext=##class(BSP.SYS.COM.ProxyObject).Escape(catDesc)
				s mysummary=##class(BSP.SYS.COM.ProxyObject).Escape($lg($g(^CT.BSP.MSG.ContentTemplateD(catId)),5))
				
				if $i(mycnt)>1 w ","
				w "{""id"":"""_myid_""",""text"":"""_mytext_""",""state"":""closed"",""attributes"":{""summary"":"""_mysummary_"""}}"
				
			}
			

		}
		w "]"
		q ""
	}
	
	if $l(id,"-")=3 { //跟节点 超管第四层 用户第三层  索引相应 个人、科室、院区、站点的模板分类
		s iType=type  //此层使用内容数据的索引结构
		w "["
		s refType=$p(id,"-",1),refId=$p(id,"-",2),cat=$p(id,"-",3)
		s cid=""
		for {
			s cid=$o(^CT.BSP.MSG.ContentTemplateI("TypeRefCat",iType,refType,refId,cat,cid))
			q:cid=""
			
			s title=$lg($g(^CT.BSP.MSG.ContentTemplateD(cid)),4)
			
			s myid=refType_"-"_refId_"-"_cat_"-"_cid,mytext=##class(BSP.SYS.COM.ProxyObject).Escape(title)
			s mysummary=##class(BSP.SYS.COM.ProxyObject).Escape($lg($g(^CT.BSP.MSG.ContentTemplateD(cid)),5))
			if $i(mycnt)>1 w ","
			w "{""id"":"""_myid_""",""text"":"""_mytext_""",""state"":""open"",""attributes"":{""summary"":"""_mysummary_"""}}"
		}
		w "]"
		q ""
		
	}
	q ""
}

/// 删除一个
ClassMethod Delete(Id)
{
	if Id="" q "-1^Id为空"
	s sc=##class(CT.BSP.MSG.ContentTemplate).%DeleteId(Id)
	if $$$ISERR(sc){
		q "-1^"_$system.Status.GetErrorText(sc)	
	}	
	q Id
}

/// 删除一个
ClassMethod DeleteCatgory(Catgory)
{
	s objCat=""
	if Catgory>0 s objCat=##class(CT.BSP.MSG.ContentTemplate).%OpenId(Catgory,0)	
	if objCat="" q "-1^Catgory="_Catgory_"不正确"
	
	s Type=objCat.Type,RefType=objCat.RefType,RefObjId=objCat.RefObjId
	s Type=$e(Type,1,$l(Type)-1)
	
	&sql(
		delete from CT_BSP_MSG.ContentTemplate where Type=:Type and RefType=:RefType and RefObjId=:RefObjId and Catgory=:Catgory
	)
	
	q ..Delete(Catgory)
}

/// debug:d ##class(%ResultSet).RunQuery("CT.BSP.MSG.BL.ContentTemplate","LookUp","T","1","1","1","2","DHCHEALTH","")
Query LookUp(type = "", user = "", loc = "", group = "", hosp = "", site = "", title = "") As websys.Query(CONTAINID = 0, ROWSPEC = "TId,TType,TTypeDesc,TCatgory,TCatgoryDesc,TTitle,TSummary,TContent,TRefType,TRefTypeDesc,TRefObjId,TRefObjDesc,TUpdateUser,TUpdateDate,TUpdateTime")
{
}

ClassMethod LookUpExecute(ByRef QHandle As %Library.Binary, type = "", user = "", loc = "", group = "", hosp = "", site = "", title = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	set ind=1 s QHandle=$lb(0,repid,0) 
	
	s Title=$zcvt(title,"U")
	
	
	if user="" s user=..GetRefObjIdBySession("U")
	if loc="" s loc=..GetRefObjIdBySession("L")
	if group="" s group=..GetRefObjIdBySession("G")
	if hosp="" s hosp=..GetRefObjIdBySession("H")
	if site="" s site=..GetRefObjIdBySession("S")
	
	
	s iType=type
	s iRefType=""
	for {
		s iRefType=$o(^CT.BSP.MSG.ContentTemplateI("TypeRefCat",iType,iRefType))
		q:iRefType=""
		
		s iRefObjId=$case(iRefType,"U":user,"L":loc,"G":group,"H":hosp,"S":site,:"")
		continue:iRefObjId=""
		
		s iCatgory=""
		for {
			s iCatgory=	$o(^CT.BSP.MSG.ContentTemplateI("TypeRefCat",iType,iRefType,iRefObjId,iCatgory))
			q:iCatgory=""
			
			
			s id=""
			for {
				s id=$o(^CT.BSP.MSG.ContentTemplateI("TypeRefCat",iType,iRefType,iRefObjId,iCatgory,id))
				q:id=""
				
				d OutputRow

			} //end id

		} //end Catgory

	} //end RefType
		
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	s g=^CT.BSP.MSG.ContentTemplateD(id)
	s TType=$lg(g,2)
	s TCatgory=$lg(g,3)
	s TTitle=$lg(g,4)
	q:(Title'="")&&($zcvt(TTitle,"U")'[Title)&&(##class(ext.util.String).ToChineseSpell(TTitle)'[Title)
	s TSummary=$lg(g,5)
	s TContent=""
	s TRefType=$lg(g,7)
	s TRefObjId=$lg(g,8)
	s TUpdateUser=$lg(g,9)
	s TUpdateDate=$lg(g,10)
	s TUpdateTime=$lg(g,11)
	
	s TTypeDesc=..GetTypeDesc(TType)
	s TCatgoryDesc=""
	if TCatgory>0 s TCatgoryDesc=..GetCatgoryDesc(TCatgory)
	s TRefTypeDesc=..GetRefTypeDesc(TRefType)
	s TRefObjDesc=..GetRefObjDesc(TRefType,TRefObjId)
	if TUpdateUser>0 s TUpdateUser=$p($g(^SSU("SSUSR",TUpdateUser),"^Err"_TUpdateUser),"^",2)
	if TUpdateDate>0 s TUpdateDate=##class(websys.Conversions).DateLogicalToHtml(TUpdateDate)
	if TUpdateTime'="" s TUpdateTime=$zt(TUpdateTime)

	set Data=$lb(id,TType,TTypeDesc,TCatgory,TCatgoryDesc,TTitle,TSummary,TContent,TRefType,TRefTypeDesc,TRefObjId,TRefObjDesc,TUpdateUser,TUpdateDate,TUpdateTime)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

ClassMethod GetRefObjIdBySession(RefType)
{
	if '$d(%session) q ""
	if RefType="U"{
		q %session.Get("LOGON.USERID")
	}elseif RefType="L" {
		q %session.Get("LOGON.CTLOCID")
	}elseif RefType="G" {
		q %session.Get("LOGON.GROUPID")
	}elseif RefType="H" {
		q %session.Get("LOGON.HOSPID")
	}elseif RefType="S" {
		s site=%session.Get("LOGON.SITECODE")
		if site="" s site="DHCHEALTH"
		q site
	}
	q ""
}

}
