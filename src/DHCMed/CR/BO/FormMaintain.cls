/// 名称: DHCMed.CR.BO.FormMaintain
/// 描述: 表单维护
/// 编写者：wuqk
/// 编写日期: 2012-12-18
Class DHCMed.CR.BO.FormMaintain Extends %RegisteredObject [ Not ProcedureBlock ]
{

///  Creator：     wuqk
///  CreatDate：   2012-11-23
///  Description:  保存设计表单和运行表单
///  Table：       DHCMed.CR.PO.Form
///  Input：       parentNode
///  Return：      
Query FormList(parentNode As %String) As %Query(ROWSPEC = "id:%String,text:%String,leaf:%String,icon:%String,cls:%String")
{
}

ClassMethod FormListExecute(ByRef qHandle As %Binary, parentNode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	quit:parentNode="" $$$OK
 	
 	if parentNode="-root" {
	 	set ret = $$BuildProduct(repid,ind)
	 }
 	elseif parentNode["-pro-" {
	 	set proCode=$p(parentNode,"-pro-",2)
	 	set ret = $$BuildForms(repid,ind,proCode)
	 	
	 }
 	elseif parentNode["-form-" {
	 	set formId=+$p(parentNode,"-form-",2)
	 	set ret = $$BuildFormVers(repid,ind,formId)
	 	
	 }
 	
	Quit $$$OK
BuildProduct(repid,ind)
	new (repid,ind)
	set productId=0
	for {
		set productId = $o(^DHCMed.SS.ProductsD(productId))
		quit:productId=""
		//#dim objProduct As DHCMed.SS.Products //Modified By LiYang 2014-05-13 为老版本数据库提供兼容
		set objProduct = ##class(DHCMed.SS.Products).GetObjById(productId)
		continue:objProduct.ProActive=0
		set data = $LB("-pro-"_objProduct.ProCode,objProduct.ProName,"false","",objProduct.IconClass)
		set ^CacheTemp(repid,ind)=data
		set ind=ind+1
	}
	quit $$$OK
BuildForms(repid,ind,proCode)
	new (repid,ind,proCode)
	set formId=0
	for {
		set formId = $o(^DHCMed.CR.PO.FormD(formId))
		quit:formId=""
		//#dim objForm As DHCMed.CR.PO.Form //Modified By LiYang 2014-05-13 为老版本数据库提供兼容
		set objForm = ##class(DHCMed.CR.PO.Form).GetObjById(formId)
		continue:objForm.Type'=proCode
		set data = $LB("-form-"_formId,objForm.CName,"false","../images/websys/zreports.gif","")
		set ^CacheTemp(repid,ind)=data
		set ind=ind+1
	}
	quit $$$OK
BuildFormVers(repid,ind,formId)
	new (repid,ind,formId)
	set versionId=0
	for {
		//DHCMed.CR.PO.FormD(1,"Versions")
		set versionId = $o(^DHCMed.CR.PO.FormD(formId,"Versions",versionId))
		quit:versionId=""
		//#dim objFormVer As DHCMed.CR.PO.FormVer //Modified By LiYang 2014-05-13 为老版本数据库提供兼容
		set objFormVer = ##class(DHCMed.CR.PO.FormVer).GetObjById(formId_"||"_versionId)
		set $li(data,1)="-ver-"_formId_"||"_versionId_"-"_objFormVer.IsPublished
		set $li(data,2)="V"_objFormVer.Version_".0 "_$s(objFormVer.IsPublished=1:"已发布 "_$zd(objFormVer.PublishDate,3),1:"未发布")  //217
		set $li(data,3)="true"
		set $li(data,4)=$s(objFormVer.IsPublished=1:"../images/websys/edit_green.gif",1:"../images/websys/edit_orange.gif")
		//'../images/websys/edit_orange.gif'
		//'../images/websys/edit_green.gif'
		set ^CacheTemp(repid,ind)=data
		set ind=ind+1
	}
	
	quit $$$OK
}

ClassMethod FormListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FormListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FormListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FormListExecute ]
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

///  Creator：     wuqk
///  CreatDate：   2012-12-20
///  Description:  表单版本发布
///  Table：       DHCMed.CR.PO.FormVer
///  Input：       formVerId
///  Return：      
///  w ##class(DHCMed.CR.BO.FormMaintain).Published("1||1")
ClassMethod Published(formVerId As %String)
{
	new (formVerId)
	quit:'##class(DHCMed.CR.PO.FormVer).%ExistsId(formVerId) -1
	set flag = 0
	set $ZT ="errPublish"
	TStart
	//GetObjById
	set objFormVer = ##class(DHCMed.CR.PO.FormVer).%OpenId(formVerId)
	set objFormVer.Form.CurrentVerID = formVerId
	set objFormVer.IsPublished = 1
	set objFormVer.PublishDate = +$h
	set sc = objFormVer.%Save()
	if $$$ISERR(sc){
		d $system.OBJ.DisplayError(sc) 
   		set flag=-2
   		
	}
	TRollback:flag<0
	quit:flag<0 flag
		
	set objForm = ##class(DHCMed.CR.PO.Form).%OpenId(+formVerId)
	set objForm.CurrentVerID = formVerId
	set sc = objForm.%Save()
	if $$$ISERR(sc){
		d $system.OBJ.DisplayError(sc) 
   		set flag=-3
   		
	}
	TRollback:flag<0
	quit:flag<0 flag
	TCommit	
	
	quit $$$OK
errPublish
	TRollback
	quit -4
}

///  Creator：     wuqk
///  CreatDate：   2012-12-20
///  Description:  取消表单版本发布
///  Table：       DHCMed.CR.PO.FormVer
///  Input：       formVerId
///  Return：      
///  w ##class(DHCMed.CR.BO.FormMaintain).CanclePublished("1||1")
ClassMethod CanclePublished(formVerId As %String)
{
	new (formVerId)
	quit:'##class(DHCMed.CR.PO.FormVer).%ExistsId(formVerId) -1
	set flag = 0
	set $ZT ="errCanclePublish"
	TStart
	set objFormVer = ##class(DHCMed.CR.PO.FormVer).%OpenId(formVerId)
	//set objFormVer.Form.CurrentVerID = formVerId
	set objFormVer.IsPublished = 0
	set objFormVer.PublishDate = ""
	set sc = objFormVer.%Save()
	if $$$ISERR(sc){
		d $system.OBJ.DisplayError(sc) 
   		set flag=-2
	}
	TRollback:flag<0
	quit:flag<0 flag
	
	set objForm = ##class(DHCMed.CR.PO.Form).%OpenId(+formVerId)
	set versionId=""
	for {
		set versionId = $o(^DHCMed.CR.PO.FormD(+formVerId,"Versions",versionId),-1)
		quit:versionId=""
		set objFormVer = ##class(DHCMed.CR.PO.FormVer).GetObjById(+formVerId_"||"_versionId)
		continue:objFormVer.IsPublished=0
		quit:objFormVer.IsPublished=1
	}
	set:versionId="" objForm.CurrentVerID = "" 
	set:versionId'="" objForm.CurrentVerID = +formVerId_"||"_versionId 
	set sc = objForm.%Save()
	if $$$ISERR(sc){
		d $system.OBJ.DisplayError(sc) 
   		set flag=-3
	}
	TRollback:flag<0
	quit:flag<0 flag
	TCommit	
	
	quit $$$OK
errCanclePublish
	TRollback
	quit -4
}

///  Creator：     wuqk
///  CreatDate：   2012-12-21
///  Description:  另存为新版本
///  Table：       DHCMed.CR.PO.FormVer
///  Input：       formVerId
///  Return：      
///  w ##class(DHCMed.CR.BO.FormMaintain).SaveAs("1||1")
ClassMethod SaveAs(formVerId As %String)
{
	
	new (formVerId)
	quit:'##class(DHCMed.CR.PO.FormVer).%ExistsId(formVerId) -1
	
	
	set objForm = ##class(DHCMed.CR.PO.Form).%OpenId(+formVerId)
	
	set maxSub = +$g(^DHCMed.CR.PO.FormD(+formVerId,"Versions"))
	if maxSub=0 {
		set version = 1
	}
	else {
		set maxFormVerId = +formVerId_"||"_maxSub
		set objFormVer = ##class(DHCMed.CR.PO.FormVer).%OpenId(maxFormVerId)
		set version = objFormVer.Version + 1
	}
	
	
	;set objFormVer = ##class(DHCMed.CR.PO.FormVer).%OpenId(formVerId)
	;set version = objFormVer.Version + 1
	set objFormVer = ""
	TStart
	set formId = +formVerId
	set sub = $p(formVerId,"||",2)
	;set newSub = $g(^DHCMed.CR.PO.FormD(formId,"Versions"))+1
	;set ^DHCMed.CR.PO.FormD(formId,"Versions",newSub)= ^DHCMed.CR.PO.FormD(formId,"Versions",sub)
	;set ^DHCMed.CR.PO.FormD(formId,"Versions") = newSub
	;set objFormVer = ##class(DHCMed.CR.PO.FormVer).%OpenId(formId_"||"_newSub)
	set obj = ##class(DHCMed.CR.PO.FormVer).%OpenId(formVerId)
	set djLayout = ##class(%Library.GlobalCharacterStream).%New()
	set htmlLayout = ##class(%Library.GlobalCharacterStream).%New()
	do djLayout.CopyFrom(obj.djLayout)
	do htmlLayout.CopyFrom(obj.htmlLayout)

	set objFormVer = ##class(DHCMed.CR.PO.FormVer).%New()
	set objFormVer.Form = objForm
	set objFormVer.djLayout = djLayout
	set objFormVer.htmlLayout = htmlLayout
	set objFormVer.IsPublished = 0
	set objFormVer.Version = version
	set sc = objFormVer.%Save()
	TCommit
	quit $$$OK
}

///  Creator：     wuqk
///  CreatDate：   2012-12-21
///  Description:  新建版本
///  Table：       DHCMed.CR.PO.FormVer
///  Input：       formId
///  Return：      
///  w ##class(DHCMed.CR.BO.FormMaintain).NewVersion(1)
ClassMethod NewVersion(formId As %String)
{
	
	new (formId)
	quit:'##class(DHCMed.CR.PO.Form).%ExistsId(formId) -1
	
	set objForm = ##class(DHCMed.CR.PO.Form).%OpenId(formId)
	
	set maxSub = +$o(^DHCMed.CR.PO.FormD(formId,"Versions",""),-1)
	if maxSub=0 {
		set version = 1
	}
	else {
		set maxFormVerId = formId_"||"_maxSub
		set objFormVer = ##class(DHCMed.CR.PO.FormVer).%OpenId(maxFormVerId)
		set version = objFormVer.Version + 1
	}
	
	set objFormVer = ##class(DHCMed.CR.PO.FormVer).%New()
	set objFormVer.IsPublished = 0
	set objFormVer.Version = version
	set objFormVer.Form = objForm
	set sc = objFormVer.%Save()
	if $$$ISERR(sc){
		d $system.OBJ.DisplayError(sc) 
   		set flag=-2
	}
	else{
		set flag=$$$OK
	}
	quit flag
}

}
