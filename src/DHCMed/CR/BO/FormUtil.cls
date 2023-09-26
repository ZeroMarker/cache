Class DHCMed.CR.BO.FormUtil Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

//Property Form As DHCMed.CR.PO.Form [ Required ];

Property EName As %String [ Required ];

Property CName As %String [ Required ];

Property ESchema As %String [ Required ];

Property Type As %String [ Required ];

Property Business As %String [ Required ];

Property htmlLayout As %Library.GlobalCharacterStream;

//list Of %String;

Property djLayout As %Library.GlobalCharacterStream;

//list Of %String;

/// d ##class(DHCMed.CR.BO.FormUtil).ExportFormVer("2||1")
ClassMethod ExportFormVer(VerID)
{
	//set VerID="1||1"
	set objVer = ##class(DHCMed.CR.PO.FormVer).%OpenId(VerID)
	
	set obj = ##class(DHCMed.CR.BO.FormUtil).%New()
	//set obj.Form = objVer.Form
	set obj.EName = objVer.Form.EName
	set obj.CName = objVer.Form.CName
	set obj.ESchema = objVer.Form.ESchema
	set obj.Type = objVer.Form.Type
	set obj.Business = objVer.Form.Business
	set obj.djLayout = objVer.djLayout
	set obj.htmlLayout = objVer.htmlLayout
	
	
	set index=1
	//#dim stream as %Stream.Object  //Modified By LiYang 2014-07-10 老版本兼容，不直接声明变量
	set sc = obj.XMLExportToStream(.stream)
	for {
		set f=stream.ReadLine(,.sc,.e)
		quit:e=0
		//quit:f=""
		//w !,index,"len= sc=",sc," end=",e
		write:f'="" !,f
		;write:f'="" f
		set index=index+1
	}
	quit ""
}

/// d ##class(DHCMed.CR.BO.FormUtil).ExportFormVer("2||2")
ClassMethod ExportFormVerBak1(VerID)
{
	//set VerID="1||1"
	set objVer = ##class(DHCMed.CR.PO.FormVer).%OpenId(VerID)
	
	set obj = ##class(DHCMed.CR.BO.FormUtil).%New()
	set obj.Form = objVer.Form
	
	w "<FormUtil>",!
	//d obj.Form.XMLExportToString(.form)
	//w form,!
	
	w "<djLayout>",!
	set index=1
	set djLayout=objVer.djLayout
	for {
		set layout=djLayout.ReadLine()
		quit:layout=""
		//do obj.djLayout.SetAt(index, layout)
		
		w "<row>",!
		w layout,!
		w "</row>",!
		set index=index+1
	}
	w "</djLayout>",!
	
	
	w "<htmlLayout>",!
	set index=1
	set htmlLayout=objVer.djLayout
	for {
		set layout=htmlLayout.ReadLine()
		quit:layout=""
		//do obj.htmlLayout.SetAt(index, layout)
		
		w "<row>",!
		w layout,!
		w "</row>",!
		set index=index+1
	}
	w "</htmlLayout>",!
	
	w "</FormUtil>"
	
	quit ""
}

/// d ##class(DHCMed.CR.BO.FormUtil).ExportFormVerBak()
ClassMethod ExportFormVerBak()
{
	set VerID="1||1"
	set objVer = ##class(DHCMed.CR.PO.FormVer).%OpenId(VerID)
	
	set obj = ##class(DHCMed.CR.BO.FormUtil).%New()
	set obj.Form = objVer.Form
	
	set index=1
	set djLayout=objVer.djLayout
	for {
		set layout=djLayout.ReadLine()
		quit:layout=""
		do obj.djLayout.SetAt(index, layout)
		set index=index+1
	}
	
	set index=1
	set htmlLayout=objVer.djLayout
	for {
		set layout=htmlLayout.ReadLine()
		quit:layout=""
		do obj.htmlLayout.SetAt(index, layout)
		set index=index+1
	}
	
	set index=1
	//#dim stream as %Stream.Object  //Modified By LiYang 2014-07-10 老版本兼容，不直接声明变量
	set sc = obj.XMLExportToStream(.stream)
	for {
		set f=stream.ReadLine(,.sc,.e)
		quit:e=0
		//quit:f=""
		//w !,index,"len= sc=",sc," end=",e
		write:f'="" !,f
		set index=index+1
	}
	quit ""
}

/// d ##class(DHCMed.CR.BO.FormUtil).ImportFormVer("F:\随访信息-V4.0 已发布 2013-05-22.xml")
ClassMethod ImportFormVer(fileName As %String)
{
		;set EName = ""
		;set CName = ""
		;set ESchema = ""
		;set Type = ""
		;set Business = ""
		;set djLayout=""
		;set htmlLayout=""
	
	set reader = ##class(%XML.Reader).%New()	
	set stream=##class(%FileCharacterStream).%New()
	set stream.Filename=fileName //"F:\随访信息-V1.0 已发布.xml"
	set sc=reader.OpenStream(stream)
	Do reader.Correlate("FormUtil","DHCMed.CR.BO.FormUtil")
	
	While reader.Next(.objFormUtil,.sc) 
	{
		set EName = objFormUtil.EName
		set CName = objFormUtil.CName
		set ESchema = objFormUtil.ESchema
		set Type = objFormUtil.Type
		set Business = objFormUtil.Business
		set djLayout=objFormUtil.djLayout
		set htmlLayout=objFormUtil.htmlLayout
	}
	
	if $d(^DHCMed.CR.PO.FormI("IndexTypeName"," "_$ZCVT(ESchema,"U")," "_$ZCVT(Type,"U")," "_$ZCVT(EName,"U"))) {
		set formId=$o(^DHCMed.CR.PO.FormI("IndexTypeName"," "_$ZCVT(ESchema,"U")," "_$ZCVT(Type,"U")," "_$ZCVT(EName,"U"),0))
	} else {
		set formInfo="^"_CName_"^"_EName_"^"_ESchema_"^"_Type_"^"_Business
		set formId=##class(DHCMed.CR.PO.Form).Update(formInfo)
	}
	quit:'##class(DHCMed.CR.PO.Form).%ExistsId(formId) -1
	set objForm = ##class(DHCMed.CR.PO.Form).%OpenId(formId)
	set maxSub = +$g(^DHCMed.CR.PO.FormD(formId,"Versions"))
	if maxSub=0 {
		set version = 1
	} else {
		set maxFormVerId = formId_"||"_maxSub
		set objFormVer = ##class(DHCMed.CR.PO.FormVer).%OpenId(maxFormVerId)
		if $IsObject(objFormVer) {
			set version = objFormVer.Version + 1
		} else {
			set version = maxSub + 1
		}
	}

	set objFormVer = ##class(DHCMed.CR.PO.FormVer).%New()
	set objFormVer.djLayout=djLayout
	set objFormVer.htmlLayout=htmlLayout
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

/// w ##class(DHCMed.CR.BO.FormUtil).xmlll(2,"F:\随访信息-V4.0 已发布 2013-05-22.xml")
ClassMethod xmlll(formId As %String, fileName As %String)
{
	;new (formId)
	quit:'##class(DHCMed.CR.PO.Form).%ExistsId(formId) -1
	
	set objForm = ##class(DHCMed.CR.PO.Form).%OpenId(formId)
	
	set maxSub = +$g(^DHCMed.CR.PO.FormD(formId,"Versions"))
	if maxSub=0 {
		set version = 1
	}
	else {
		set maxFormVerId = formId_"||"_maxSub
		set objFormVer = ##class(DHCMed.CR.PO.FormVer).%OpenId(maxFormVerId)
		if $IsObject(objFormVer) {
			set version = objFormVer.Version + 1
		} else {
			set version = maxSub + 1
		}
	}
	set objFormVer = ##class(DHCMed.CR.PO.FormVer).%New()

	set reader = ##class(%XML.Reader).%New()	
	set stream=##class(%FileCharacterStream).%New()
	set stream.Filename=fileName //"F:\随访信息-V1.0 已发布.xml"
	//set sc = stream.Write(^tmpcrf("import","%request")) //,"data")
	set sc=reader.OpenStream(stream)	
	Do reader.Correlate("FormUtil","DHCMed.CR.BO.FormUtil")
	
	While reader.Next(.objFormUtil,.sc) 
	{
		;s objFormUtil.Ename=reader.%GetParameter("Ename")
		;Set sc=objFormUtil.%Save()
		;s cc=stream.GetAttribute("Ename")
		;d $System.OBJ.Dump(objFormUtil)
		;w !,objFormUtil.EName
		;w !,objFormUtil.djLayout
		;w !,objFormUtil.htmlLayout
		set objFormVer.djLayout=objFormUtil.djLayout
		set objFormVer.htmlLayout=objFormUtil.htmlLayout
	}
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

/// Creator: LiYang
/// Create Date:2014-05-17
/// Description:从CS版程序导入模板的类方法
ClassMethod ImportFormVerCS(objFormUtil As %RegisteredObject) As %Integer
{
	n (objFormUtil)
	set EName = objFormUtil.EName
	set CName = objFormUtil.CName
	set ESchema = objFormUtil.ESchema
	set Type = objFormUtil.Type
	set Business = objFormUtil.Business
	set djLayout=objFormUtil.djLayout
	set htmlLayout=objFormUtil.htmlLayout
	Set ^CacheTemp("AAA",99)=$ZCVT(ESchema,"U")_"^"_$ZCVT(Type,"U")_"^"_$ZCVT(EName,"U")
	if $d(^DHCMed.CR.PO.FormI("IndexTypeName"," "_$ZCVT(ESchema,"U")," "_$ZCVT(Type,"U")," "_$ZCVT(EName,"U"))) {
		set formId=$o(^DHCMed.CR.PO.FormI("IndexTypeName"," "_$ZCVT(ESchema,"U")," "_$ZCVT(Type,"U")," "_$ZCVT(EName,"U"),0))
	}
	else {
		set formInfo="^"_CName_"^"_EName_"^"_ESchema_"^"_Type_"^"_Business
		set formId=##class(DHCMed.CR.PO.Form).Update(formInfo)
	}
	quit:'##class(DHCMed.CR.PO.Form).%ExistsId(formId) -1
	set objForm = ##class(DHCMed.CR.PO.Form).%OpenId(formId)
		set maxSub = +$g(^DHCMed.CR.PO.FormD(formId,"Versions"))
		if maxSub=0 {
			set version = 1
		} else {
			set maxFormVerId = formId_"||"_maxSub
			set objFormVer = ##class(DHCMed.CR.PO.FormVer).%OpenId(maxFormVerId)
			if $IsObject(objFormVer) {
				set version = objFormVer.Version + 1
			} else {
				set version = maxSub + 1
			}
		}

	set objFormVer = ##class(DHCMed.CR.PO.FormVer).%New()
	set ^CacheTemp("AAA",2)=objFormVer.djLayout.CopyFromAndSave(djLayout)
	Do objFormVer.djLayout.Write("<!-- Temp data 1234567890  --> ")
	set ^CacheTemp("AAA",3)=objFormVer.htmlLayout.CopyFromAndSave(htmlLayout)
	Do objFormVer.htmlLayout.Write("<!-- Temp data 1234567890  --> ")
	Do objFormVer.htmlLayout.Flush()
	Do objFormVer.djLayout.Flush()
	set objFormVer.IsPublished = 0
	set objFormVer.Version = version
	set objFormVer.Form = objForm
	set sc = objFormVer.%Save()
	do objFormVer.htmlLayout.SaveStream()
	S ^CacheTemp("AAA",1)=sc
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
