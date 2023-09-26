Class web.DHCDocAPPBLExport Extends %RegisteredObject
{

/// w ##class(web.DHCDocAPPBLExport).FindBLTempeJson("CA")
ClassMethod FindBLTempeJson(MapType As %String = "")
{
	s JsonObj=[]
	s RowID=0
	for {
		s RowID=$O(^DHCDocBLTemi("LastID",0,RowID))
		q:RowID=""
		s BLMapType=$P(^DHCDocBLTem(RowID),"^",4)
		continue:(("^"_MapType_"^")'[("^"_BLMapType_"^"))
		s BLTempleDesc=$P(^DHCDocBLTem(RowID),"^",1)
		s BLTempleContetn="<xmp>"_$g(^DHCDocBLTem(RowID,"ConT"))_"</xmp>"
		s BLTempleID=$P(^DHCDocBLTem(RowID),"^",3)
		s BLTempleJS=$g(^DHCDocBLTem(RowID,"JSStr"))
		s json={}
		s json.RowID=RowID
		s json.BLTempleDesc=BLTempleDesc
		s json.BLTempleJS=BLTempleJS
		s json.BLTempleID=BLTempleID
		s json.BLTempleContetn=BLTempleContetn
		s json.FatherRowID=0
		s childrenRowID=$O(^DHCDocBLTemi("LastID",RowID,0))
		if (childrenRowID'=""){
			s childrenjson=[]
			s childrenjson=..GetChildrenTempJson(childrenjson,RowID)
			s json.children=childrenjson
		}
		d JsonObj.%Push(json)
	}
	Q JsonObj.%ToJSON()
}

ClassMethod GetChildrenTempJson(fatherjson, FatherRwodID)
{
	s RowID=0
	for {
		s RowID=$O(^DHCDocBLTemi("LastID",FatherRwodID ,RowID))
		q:RowID=""
		s BLMapType=$P(^DHCDocBLTem(RowID),"^",4)
		s BLTempleDesc=$P(^DHCDocBLTem(RowID),"^",1)
		s BLTempleContetn="<xmp>"_$g(^DHCDocBLTem(RowID,"ConT"))_"</xmp>"
		s BLTempleID=$P(^DHCDocBLTem(RowID),"^",3)
		s BLTempleJS=$g(^DHCDocBLTem(RowID,"JSStr"))
		s json={}
		s json.RowID=RowID
		s json.BLTempleDesc=BLTempleDesc
		s json.BLTempleJS=BLTempleJS
		s json.BLTempleID=BLTempleID
		s json.BLTempleContetn=BLTempleContetn
		s json.FatherRowID=0
		s childrenRowID=$O(^DHCDocBLTemi("LastID",RowID,0))
		if (childrenRowID'=""){
			s childrenjson=[]
			s childrenjson=..GetChildrenTempJson(childrenjson,RowID)
			s json.children=childrenjson
		}
		d fatherjson.%Push(json)
	}
	q fatherjson
}

ClassMethod EvalString(Str)
{
	s Str=$replace(Str,$c(9),"$9$")
	s Str=$replace(Str,$c(10),"$1$")
	s Str=$replace(Str,$c(13),"$2$")
	s Str=$replace(Str,"/","$3$")
	s Str=$replace(Str,"<","$4$")
	s Str=$replace(Str,">","$5$")
	s Str=$replace(Str,"&nbsp;","$6$")
	s Str=$replace(Str,"&nbsp","$6$")	
	s Str=$replace(Str,",","$7$")	
	Q Str
}

ClassMethod SerialString(Str)
{
	s Str=$replace(Str,"$9$",$c(9))
	s Str=$replace(Str,"$1$",$c(10))
	s Str=$replace(Str,"$2$",$c(13))
	s Str=$replace(Str,"$3$","/")
	s Str=$replace(Str,"$4$","<")
	s Str=$replace(Str,"$5$",">")
	s Str=$replace(Str,"$6$","&nbsp;")	
	s Str=$replace(Str,"$7$",",")
	s Str=$replace(Str,"""""","""")
	Q Str
}

Query QryTypeToExcel(ExportID As %String = "", MapType As %String = "") As %Query(ROWSPEC = "BLTypeCode:%String:代码,BLTypeDesc:%String:描述,BLTypeJSAddress:%String,BLInit:%String,BLItemMast:%String,BLSaveOther:%String,BLLoadOther:%String,BLXMLTempName:%String:单据关联XML模板,MapCodeStr:%String:模板内容,MapType:%String:单据类型")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocAPPBLExport","QryTempToExcel","299")
ClassMethod QryTypeToExcelExecute(ByRef qHandle As %Binary, ExportID As %String = "", MapType As %String = "") As %Status
{
	s rset=##class(%ResultSet).%New("web.DHCDocAPPBL:FindBLType")
	do rset.Execute(MapType)
	s columns = rset.GetColumnCount()
	s Delim="^"
	s row=0
	While (rset.Next()) {
		s RowID=rset.GetDataByName("RowID")
		continue:(ExportID'="")&&(("^"_ExportID_"^")'[("^"_RowID_"^"))
		s BLTypeCode=rset.GetDataByName("BLTypeCode")
		s BLTypeDesc=rset.GetDataByName("BLTypeDesc")
		s BLTypeJSAddress=rset.GetDataByName("BLTypeJSAddress")
		s BLInit=rset.GetDataByName("BLInit")
		s BLItemMast=rset.GetDataByName("BLItemMast")
		s BLSaveOther=rset.GetDataByName("BLSaveOther")
		s BLLoadOther=rset.GetDataByName("BLLoadOther")
		s BLXMLTempName=rset.GetDataByName("BLXMLTempName")
		s BLMapType=$P(^DHCDocAppBLMap(RowID),"^",9)
		s MapCodeStr=""
		s MapStr=$P(^DHCDocAppBLMap(RowID),"^",3)
		if MapStr'=""{
			s i=1
			for{
				s TempRowID=$P(MapStr,"||",i)
				q:TempRowID=""
				s i=i+1
				s TempCode=$P(^DHCDocBLTem(TempRowID),"^",3)
				if MapCodeStr="" s MapCodeStr=TempCode
				else  s MapCodeStr=MapCodeStr_$c(1)_TempCode
			}
		}
		s SortName="A"
		;s outputdata=BLTypeCode_Delim_BLTypeDesc_Delim_BLTypeJSAddress_Delim_BLInit_Delim_BLItemMast
		;s outputdata=outputdata_Delim_BLSaveOther_Delim_BLLoadOther_Delim_BLXMLTempName_Delim_MapCodeStr_Delim
		d OutputRow
	}
	Quit $$$OK 
OutputRow
	set Data=$lb(BLTypeCode,BLTypeDesc,BLTypeJSAddress,BLInit,BLItemMast,BLSaveOther,BLLoadOther,BLXMLTempName,MapCodeStr,BLMapType)
 	set qHandle(SortName,$I(ind))=Data
	quit
}

ClassMethod QryTypeToExcelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTypeToExcelExecute ]
{

	s SortName=$O(qHandle(""))
	if SortName'=""{
		s ind=$O(qHandle(SortName,""))
		if ind'=""{
			s Row=qHandle(SortName,ind)
			k qHandle(SortName,ind)
			Quit $$$OK
		}
	}
	s AtEnd=1
	Quit $$$OK
}

Query QryTempToExcel(ExportID As %String = "", HospID As %String = "", MapType As %String = "") As %Query(ROWSPEC = "BLTempleID:%String:模板代码,BLMapType:%String:模板类型,BLTempleXML:%String:模板XML信息,BLTempleContent:%String:模板内容")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocAPPBLExport","QryTempToExcel","299")
ClassMethod QryTempToExcelExecute(ByRef qHandle As %Binary, ExportID As %String = "", HospID As %String = "", MapType As %String = "") As %Status
{
	s ind=0
	s ID=0
	for{
		s ID=$O(^DHCDocBLTem(ID))
		q:ID=""
		s BLMapType=$P(^DHCDocBLTem(ID),"^",4)
		continue:(ExportID'="")&&(("^"_ExportID_"^")'[("^"_ID_"^"))
		continue:(ExportID="")&&(MapType'="")&&(MapType'=BLMapType)
		s BLTempleDesc=$P(^DHCDocBLTem(ID),"^",1)
		s BLTempleType=$P(^DHCDocBLTem(ID),"^",2)
		s BLTempleID=$P(^DHCDocBLTem(ID),"^",3)
		s BLTempleParID=$P(^DHCDocBLTem(ID),"^",5)
		if +BLTempleParID>0{
			s BLTempleParCode=$P(^DHCDocBLTem(BLTempleParID),"^",3)
			s BLParParID=$P(^DHCDocBLTem(BLTempleParID),"^",5)
			if +BLParParID>0{
				s SortName="Z"	
			}else{
				s SortName="Y"		
			}
		}else{
			s BLTempleParCode=""	
			s SortName="A"
		}
		s BLTempleContent=$g(^DHCDocBLTem(ID,"ConT"))
		s BLTempleJS=$g(^DHCDocBLTem(ID,"JSStr"))
		s BLTempleContent=..EvalString(BLTempleContent)
		s TempObj={}
		s TempObj.TempleDesc=BLTempleDesc
		s TempObj.TempleType=BLTempleType
		s TempObj.TempleJS=BLTempleJS
		s TempObj.TempleParCode=BLTempleParCode
		s BLItemCount=0
		s TempObj.TempItemObj=[]
		s RowID=0
		for{
			s RowID=$O(^DHCDocAppBLItemi("BLTemp",ID, RowID))
			q:RowID=""
			s BLItemID=$P(^DHCDocAppBLItem(RowID),"^",1)
			s BLItemDesc=$P(^DHCDocAppBLItem(RowID),"^",2)
			s BLItemType=$P(^DHCDocAppBLItem(RowID),"^",3)
			s BLItemAcqiur=$P(^DHCDocAppBLItem(RowID),"^",4)
			s BLItemSave=$P(^DHCDocAppBLItem(RowID),"^",5)
			s BLItemLength=$P(^DHCDocAppBLItem(RowID),"^",7)
			s BLItemXPrintName=$P(^DHCDocAppBLItem(RowID),"^",10)
			s BLItemJSContent=$g(^DHCDocAppBLItem(RowID,"ShowJS"))
			if BLItemJSContent="undefined" s BLItemJSContent=""
			s BLItemDesc=..EvalString(BLItemDesc)	
			s BLItemJSContent=..EvalString(BLItemJSContent)	
			s ItemObj={}
			s ItemObj.ID=BLItemID
			s ItemObj.Desc=BLItemDesc
			s ItemObj.Type=BLItemType
			s ItemObj.Acqiur=BLItemAcqiur
			s ItemObj.Save=BLItemSave
			s ItemObj.Length=BLItemLength
			s ItemObj.JSContent=BLItemJSContent
			s ItemObj.XPrintName=BLItemXPrintName
			d TempObj.TempItemObj.%Push(ItemObj)
			s BLItemCount=$I(BLItemCount)
		}
		s TempObj.ItemCount=BLItemCount
		s XMLString=TempObj.%ToJSON()
		s XMLString=..EvalString(XMLString)	
		d OutputAssScale
	}
	Quit $$$OK 
OutputAssScale
	set Data=$lb(BLTempleID,BLMapType,XMLString,BLTempleContent)
 	set qHandle(SortName,$I(ind))=Data
	quit
}

ClassMethod QryTempToExcelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTempToExcelExecute ]
{

	s SortName=$O(qHandle(""))
	if SortName'=""{
		s ind=$O(qHandle(SortName,""))
		if ind'=""{
			s Row=qHandle(SortName,ind)
			k qHandle(SortName,ind)
			Quit $$$OK
		}
	}
	s AtEnd=1
	Quit $$$OK
}

ClassMethod logdata(i, b)
{
	s ^tmplog("log",i)=b
}

/// CTOR:   nk
/// DATE:   2021-07-23
/// DESC:   病理模板批量导入Excel
/// DEBUG:  w ##class(DHCDoc.DHCDocCure.AssScaleConfig).ImportTotalExcel("D:\assscale.xlsx")
ClassMethod ImportTotalExcel(ByRef excelStrArr, ExpStr As %String = "") As %String
{
	m ^tmp("data")=excelStrArr
	s findRepeat=0,RepeatCodeStr=""
	s loop=0
	for{
		s loop=$o(excelStrArr(loop))
		q:loop=""
		s excelData=excelStrArr(loop)
		s excelStr=""
		i $CLASSNAME(excelData)["CSP.CharacterStream" {
			while (excelData.AtEnd = 0)
			{
				s excelStr=excelStr_excelData.Read(2000)
			}
		}else{
			s excelStr=excelData	
		}
		s totalLen=$l(excelStr,"!")
		f tloop=1:1:totalLen {
			s cInput = $p(excelStr,"!",tloop)
			s TempID=$p(cInput,"^",1)
		    continue:TempID=""
		    s TempMapType=$p(cInput,"^",2)
			s ID=0
			for{
				s ID=$O(^DHCDocBLTem(ID))
				q:ID=""
				s BLMapType=$P(^DHCDocBLTem(ID),"^",4)
				continue:(TempMapType'="")&&(TempMapType'=BLMapType)
				s BLTempleID=$P(^DHCDocBLTem(ID),"^",3)
				if BLTempleID=TempID{
					s findRepeat=1
				    if RepeatCodeStr="" s RepeatCodeStr=BLTempleID
				    else  s RepeatCodeStr=RepeatCodeStr_","_BLTempleID
				}
			}
		}
	}
	Q:findRepeat=1 "-1^模板ID【"_RepeatCodeStr_"】重复"
	
    Ts
	s mRtn=0
	s loop=0
	for{
		s loop=$o(excelStrArr(loop))
		q:loop=""
		s excelData=excelStrArr(loop)
		s excelStr=""
		i $CLASSNAME(excelData)["CSP.CharacterStream" {
			d excelData.Rewind()
			while (excelData.AtEnd = 0)
			{
				s excelStr=excelStr_excelData.Read(2000)
			}
		}else{
			s excelStr=excelData	
		}
		s totalLen=$l(excelStr,"!")
		f tloop=1:1:totalLen {
			s cInput = $p(excelStr,"!",tloop)
			s rtn=..ImportFromExcel(cInput,ExpStr)
			i rtn'=0{
				s mRtn=$p(cInput,"^",1)_","_$p(cInput,"^",2)_","_rtn
			}
			q:rtn'=0 
		}
		q:mRtn'=0 
	}
	if mRtn=0{
		Tc
	}else{
		Tro	
	}
	
    q mRtn
}

/// CTOR:   nk
/// DATE:   2021-07-23
/// DESC:   病理模板批量导入
/// INPUT:  
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(web.DHCDocAPPBLExport).ImportFromExcel(^tmp("data",1),"94")
ClassMethod ImportFromExcel(excelStr As %String, ExpStr As %String = "") As %String
{
	s ^tmplog("ImportFromExcel")=$lb(excelStr,ExpStr)
	s ImportHospName=""
	s ImportHospId=$p(ExpStr,"^",1) //导入院区
	s:ImportHospId'="" ImportHospName=$p(^CT("HOSP",ImportHospId),"^",2)
	
	s InPara=excelStr
	s InPara=$replace(InPara,"^""","^")
	s InPara=$replace(InPara,"""^","^")
    s TempID=$p(InPara,"^",1)
    Q:TempID="" "-1^模板ID不能为空!"
    s TempMapType=$p(InPara,"^",2)
    s TempJson=$p(InPara,"^",3)
    Q:TempJson="" "-1^模板json信息不能为空!"
    s BLTempleContent=$p(InPara,"^",4)
    s BLTempleContent=$replace(BLTempleContent,"$""","$")
    ;Q:BLTempleContent="" "-1^模板内容不能为空!"
    s myRtn=0
    s TempJson=..SerialString(TempJson)
    Job ..logdata(TempID,BLTempleContent)
	if TempJson'=""{
		s TempJsonObj={}.%FromJSON(TempJson)
		s BLTempleDesc=TempJsonObj.TempleDesc
		s BLTempleJS=TempJsonObj.TempleJS
		s BLItemCount=TempJsonObj.ItemCount
		s BLTempleType=TempJsonObj.TempleType
		s BLTempleParCode=TempJsonObj.TempleParCode
		s BLTempleContent=..SerialString(BLTempleContent)
		s BLTempleParID=0
		if BLTempleParCode'=""{
			s ID=0
			for{
				s ID=$O(^DHCDocBLTem(ID))
				q:ID=""
				s BLMapType=$P(^DHCDocBLTem(ID),"^",4)
				continue:(TempMapType'="")&&(TempMapType'=BLMapType)
				s BLTempleID=$P(^DHCDocBLTem(ID),"^",3)
				if BLTempleID=BLTempleParCode{
					s BLTempleParID=ID
					Q
				}
			}	
		}
		Ts
		s ret=##Class(web.DHCDocAPPBL).InsertBLTemple(BLTempleDesc, BLTempleContent, "",TempID, BLTempleJS, TempMapType, BLTempleParID,.BLTempRowID)
		if ret=0{
			if BLItemCount>0{
				s TempItemCount=TempJsonObj.TempItemObj.%Size()
				for myKey=1:1:TempItemCount{
					s Key=myKey-1
					s oneTempItemObj=TempJsonObj.TempItemObj.%Get(Key)
					s BLItemID=oneTempItemObj.ID
					s BLItemDesc=oneTempItemObj.Desc
					s BLItemType=oneTempItemObj.Type
					s BLItemAcqiur=oneTempItemObj.Acqiur
					s BLItemSave=oneTempItemObj.Save
					s BLItemLength=oneTempItemObj.Length
					s BLItemJSContent=oneTempItemObj.JSContent
					s BLItemXPrintName=oneTempItemObj.XPrintName
					s BLItemDesc=..SerialString(BLItemDesc)
					s BLItemJSContent=..SerialString(BLItemJSContent)
					s BLItemExp="^^"_BLItemXPrintName
					s itemret=##Class(web.DHCDocAPPBL).InsertBLItem(BLItemID, BLItemDesc, BLItemJSContent, "", BLItemAcqiur, BLItemSave, BLTempRowID, BLItemLength,BLItemExp)
					if itemret'=0{
						Tro
						s myRtn="-1^插入模板元素失败:"_itemret
						Q	
					}
				
				}
			}
		}else{
			Tro
			s myRtn="-1^插入模板失败:"_ret
		}
		if myRtn=0{
			Tc
		}
	}else{
		s myRtn="-1^模板XML解析失败"
	}
	q myRtn
}

/// creator:倪康
/// createdate:20220611
/// description:用于后台导出病理模板相关信息
/// windows路径命令:w ##class(web.DHCDocAPPBLExport).TempToExport("d:\TempToText.txt","63^64^65^66^67^68^69^70^72^73^71")
/// 小机路径命令:w ##class(web.DHCDocAPPBLExport).TempToExport("/tmp/TempToText.txt","63^64^65^66^67^68^69^70^72^73^71")
/// 导出text到对应服务器目录查找
/// input:文件路径 ；ExportID 需要导出的模板ID
ClassMethod TempToExport(filename, ExportID As %String = "", MapType As %String = "CA")
{
	s $ztrap="TempToExportErr"
	q:filename="" "请输出需导出到的文件路径!"
	s num=1
	s ret=""
	try{
 		o filename:"WNS":5
	}catch(e){
		s ret="导出错误!请确认导出路径是否正确！"_e
	}
	Q:ret'="" ret
	u filename
	s rset=##class(%ResultSet).%New("web.DHCDocAPPBLExport:QryTempToExcel")
	do rset.Execute(ExportID,MapType)
	s columns = rset.GetColumnCount()
	s Delim="^"
	;w "模板代码"_Delim_"模板类型"_Delim_"模板XML信息"_Delim_"模板内容",!
	s row=0
	While (rset.Next()) {
		;BLTempleID:%String:模板代码,BLMapType:%String:模板类型,BLTempleXML:%String:模板XML信息,BLTempleContent:%String:模板内容
		s BLTempleID=rset.GetDataByName("BLTempleID")
		s BLMapType=rset.GetDataByName("BLMapType")
		s BLTempleXML=rset.GetDataByName("BLTempleXML")
		s BLTempleContent=rset.GetDataByName("BLTempleContent")
		s outputdata=BLTempleID_Delim_BLMapType_Delim_BLTempleXML_Delim_BLTempleContent
 		w outputdata,!
 		s row=$I(row)
	}
 	c filename
    q "导出文件至服务器对应路径完成!共"_row_"条数据。"
TempToExportErr
	s $ztrap=""
	q "导出错误!请确认导出路径是否正确！"_$ZERROR
}

/// description:用于后台导入病理模板相关信息
/// windows路径命令:w ##class(web.DHCDocAPPBLExport).ImportTempByTxt("d:\TempToText.txt")
/// 小机路径命令:w ##class(web.DHCDocAPPBLExport).ImportTempByTxt("/tmp/TempToText.txt")
ClassMethod ImportTempByTxt(FilePath As %String) As %String
{
	Set file=##class(%File).%New(FilePath)
	set ExistsFlag=##class(%File).Exists(FilePath)
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	Q:ExistsFlag'=1 "文件不存在"
	
	k HasBLTempleAry
	s ID=0
	for{
		s ID=$O(^DHCDocBLTem(ID))
		q:ID=""
		s BLMapType=$P(^DHCDocBLTem(ID),"^",4)
		s BLTempleID=$P(^DHCDocBLTem(ID),"^",3)
		if BLMapType="" s BLMapType="BL"
		s HasBLTempleAry(BLMapType,BLTempleID)=ID
	}
			
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=FilePath
	;w !,"数据生成中...",!
	s findRepeat=0,RepeatCodeStr=""
	set total=0
	While 'stream.AtEnd {
		set total=total+1
		Set cInput=stream.ReadLine(999999999)
		Set TempID=$p(cInput,"^",1)
	    continue:TempID=""
	    s TempMapType=$p(cInput,"^",2)
	    if TempMapType="" s TempMapType="BL"
		if $d(HasBLTempleAry(TempMapType,TempID)){
			s findRepeat=1
		    if RepeatCodeStr="" s RepeatCodeStr=TempID
		    else  s RepeatCodeStr=RepeatCodeStr_","_TempID
		    continue
		}
		s cInput=$replace(cInput,"""","""""")
		s TempAry(total)=cInput
	}
	;w "以下模板ID因重复未导入：【"_RepeatCodeStr_"】",!
	s RepeatCodeInfo=""
	s:RepeatCodeStr'="" RepeatCodeInfo="以下模板ID因重复未导入：【"_RepeatCodeStr_"】"
	s mRtn=0,Total=0	
	Ts
	for loop=1:1:total{	
		continue:'$d(TempAry(loop))
		s data=TempAry(loop)
		s rtn=..ImportFromExcel(data)
		i rtn'=0{
			s mRtn=$p(data,"^",1)_","_$p(data,"^",2)_","_rtn
			Q
		}
		s Total=Total+1
	}
	if mRtn=0{
		Tc
		;w !,"数据生成OK...",!
	}else{
		Tro	
	}
	if mRtn=0{
		s mRtn="成功导入"_Total_"条数据"
		s:RepeatCodeInfo'="" mRtn=mRtn_"&&&"_RepeatCodeInfo	
	}
    q mRtn
}

/// description:用于后台导出病理单相关信息
/// windows路径命令:w ##class(web.DHCDocAPPBLExport).TypeToExport("d:\MapToText.txt","CA")
/// 小机路径命令:w ##class(web.DHCDocAPPBLExport).TypeToExport("/tmp/MapToText.txt")
/// 导出text到对应服务器目录查找
/// input:文件路径 ；ExportID 需要导出的模板ID
ClassMethod TypeToExport(filename, MapType As %String = "CA")
{
	q:filename="" "无路径!"
	s num=1
 	o filename:"WNS"
 	u filename
	s rset=##class(%ResultSet).%New("web.DHCDocAPPBL:FindBLType")
	do rset.Execute(MapType)
	s columns = rset.GetColumnCount()
	s Delim="^"
	;w "模板代码"_Delim_"模板类型"_Delim_"模板XML信息"_Delim_"模板内容",!
	;RowID:%String,BLTypeCode:%String,BLTypeDesc:%String,BLTypeJSAddress:%String,BLInit:%String,
	;BLItemMast:%String,BLSaveOther:%String,BLLoadOther:%String,BLXMLTempName:%String
	s row=0
	While (rset.Next()) {
		;BLTempleID:%String:模板代码,BLMapType:%String:模板类型,BLTempleXML:%String:模板XML信息,BLTempleContent:%String:模板内容
		s RowID=rset.GetDataByName("RowID")
		s BLTypeCode=rset.GetDataByName("BLTypeCode")
		s BLTypeDesc=rset.GetDataByName("BLTypeDesc")
		s BLTypeJSAddress=rset.GetDataByName("BLTypeJSAddress")
		s BLInit=rset.GetDataByName("BLInit")
		s BLItemMast=rset.GetDataByName("BLItemMast")
		s BLSaveOther=rset.GetDataByName("BLSaveOther")
		s BLLoadOther=rset.GetDataByName("BLLoadOther")
		s BLXMLTempName=rset.GetDataByName("BLXMLTempName")
		
		s MapCodeStr=""
		s MapStr=$P(^DHCDocAppBLMap(RowID),"^",3)
		if MapStr'=""{
			s i=1
			for{
				s TempRowID=$P(MapStr,"||",i)
				q:TempRowID=""
				s i=i+1
				s TempCode=$P(^DHCDocBLTem(TempRowID),"^",3)
				if MapCodeStr="" s MapCodeStr=TempCode
				else  s MapCodeStr=MapCodeStr_$c(1)_TempCode
			}
		}
		
		s outputdata=BLTypeCode_Delim_BLTypeDesc_Delim_BLTypeJSAddress_Delim_BLInit_Delim_BLItemMast
		s outputdata=outputdata_Delim_BLSaveOther_Delim_BLLoadOther_Delim_BLXMLTempName_Delim_MapCodeStr_Delim
 		w outputdata,!
	}
 	c filename
    q "导出完成!"
}

/// Delim="^"
/// BLTypeCode_Delim_BLTypeDesc_Delim_BLTypeJSAddress_Delim_BLInit_Delim_BLItemMast
/// BLSaveOther_Delim_BLLoadOther_Delim_BLXMLTempName_Delim_MapCodeStr
/// 代码^描述^调用js文件^启动初始化^启动医嘱勾选/取消勾选功能^
/// 启动保存其他数据^启动加载其他数据^XML打印模板名称^关联的模板内容代码1$c(1)关联的模板内容代码2...
/// description:用于后台导入病理模板相关信息
/// windows路径命令:w ##class(web.DHCDocAPPBLExport).ImportBLByTxt("d:\MapToText.txt","CA")
/// 小机路径命令:w ##class(web.DHCDocAPPBLExport).ImportBLByTxt("/tmp/MapToText.txt","CA")
ClassMethod ImportBLByTxt(FilePath As %String, MapType As %String) As %String
{
	Set file=##class(%File).%New(FilePath)
	set ExistsFlag=##class(%File).Exists(FilePath)
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	Q:ExistsFlag'=1 "文件不存在"
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=FilePath
	w !,"数据生成中...",!
	
	k HadTypeAry,TempAry
	s RowID=0
	for{
		s RowID=$O(^DHCDocAppBLMap(RowID))
		q:RowID=""
		s BLTypeCode=$P(^DHCDocAppBLMap(RowID),"^",1)
		s BLTypeDesc=$P(^DHCDocAppBLMap(RowID),"^",2)
		s BLMapType=$P(^DHCDocAppBLMap(RowID),"^",9)
		s HadTypeAry(BLTypeCode)=RowID
	}
	k HasBLTempleAry
	s ID=0
	for{
		s ID=$O(^DHCDocBLTem(ID))
		q:ID=""
		s BLMapType=$P(^DHCDocBLTem(ID),"^",4)
		s BLTempleID=$P(^DHCDocBLTem(ID),"^",3)
		if BLMapType="" s BLMapType="BL"
		s HasBLTempleAry(BLMapType,BLTempleID)=ID
	}
	s findRepeat=0,RepeatCodeStr=""
	set total=0
	While 'stream.AtEnd {
		set total=total+1
		Set cInput=stream.ReadLine()
		Set BLTypeCode=$p(cInput,"^",1)
	    continue:BLTypeCode=""
		if $d(HadTypeAry(BLTypeCode)){
			s findRepeat=1
		    if RepeatCodeStr="" s RepeatCodeStr=BLTypeCode
		    else  s RepeatCodeStr=RepeatCodeStr_","_BLTypeCode
		    continue
		}
		s TempAry(total)=cInput
	}
	;Q:findRepeat=1 "-1^模板ID【"_RepeatCodeStr_"】重复"
	w "以下模板ID因重复未导入：【"_RepeatCodeStr_"】",!
	s mRtn=0	
	Ts
	for loop=1:1:total{	
		continue:'$d(TempAry(loop))
		s data=TempAry(loop)
		s BLTypeCode=$p(data,"^",1)
		s BLTypeDesc=$p(data,"^",2)
		s BLTypeJSAddress=$p(data,"^",3)
		s BLInit=$p(data,"^",4)
		s BLItemMast=$p(data,"^",5)
		s BLSaveOther=$p(data,"^",6)
		s BLLoadOther=$p(data,"^",7)
		s BLXMLTempName=$p(data,"^",8)
		s MapCodeStr=$p(data,"^",9)
		s BLTempIDStr=""
		s NotExistTemp=""
		if MapCodeStr'=""{
			s MapCodeStrLen=$l(MapCodeStr,$c(1))
			for tp=1:1:MapCodeStrLen{
				s MapBLTempCode=$p(MapCodeStr,$c(1),tp)
				if $d(HasBLTempleAry(MapType,MapBLTempCode)){
					s BLTempID=HasBLTempleAry(MapType,MapBLTempCode)	
					if BLTempIDStr="" s BLTempIDStr=BLTempID
					else  s BLTempIDStr=BLTempIDStr_"||"_BLTempID
				}else{
					if NotExistTemp="" s NotExistTemp=MapBLTempCode
					else  s NotExistTemp=NotExistTemp_","_MapBLTempCode
				}
			}	
		}
		s tBLTypeCode=BLTypeCode
		if NotExistTemp'=""{
			w tBLTypeCode_",对应代码为【"_NotExistTemp_"】的模板不存在,未导入",!
		}
		;s ret=##class(web.DHCDocAPPBL).InsertBLType(BLTypeCode,BLTypeDesc,BLTypeJSAddress,"",BLInit,BLItemMast,BLSaveOther,BLLoadOther,MapType,BLXMLTempName)
		&SQL(insert into SQLUser.DHC_DocAppBLMap 
			(APPMap_Code,APPMap_Name,APPMap_ShowJS,APPMap_FristFunction,
			APPMap_ItmmastFunction,APPMap_SaveOtherInfo,APPMap_LoadOtherInfo,APPMap_MapType,APPMap_XMLTempName,APPMap_ShowTemp
			) Values(:BLTypeCode,:BLTypeDesc,:BLTypeJSAddress,:BLInit,
			:BLItemMast,:BLSaveOther,:BLLoadOther,:MapType,:BLXMLTempName,:BLTempIDStr))
		if 'SQLCODE{
			s Rowid=+%ROWID 
		}else{
			s mRtn=BLTypeCode_",插入DHC_DocAppBLMap失败,错误代码："	_SQLCODE
		}
		i mRtn'=0{
			Q
		}
	}
	if mRtn=0{
		Tc
	}else{
		Tro	
	}
	w "数据生成OK...",!
    q mRtn
}

ClassMethod ImportTypeExcel(ByRef excelStrArr, ExpStr As %String = "") As %String
{
	m ^tmp("data")=excelStrArr
	k HadTypeAry,TempAry
	s RowID=0
	for{
		s RowID=$O(^DHCDocAppBLMap(RowID))
		q:RowID=""
		s BLTypeCode=$P(^DHCDocAppBLMap(RowID),"^",1)
		s BLTypeDesc=$P(^DHCDocAppBLMap(RowID),"^",2)
		s BLMapType=$P(^DHCDocAppBLMap(RowID),"^",9)
		s HadTypeAry(BLTypeCode)=RowID
	}
	s findRepeat=0,RepeatCodeStr=""
	s loop=0
	for{
		s loop=$o(excelStrArr(loop))
		q:loop=""
		s excelData=excelStrArr(loop)
		s excelStr=""
		i $CLASSNAME(excelData)["CSP.CharacterStream" {
			while (excelData.AtEnd = 0)
			{
				s excelStr=excelStr_excelData.Read(2000)
			}
		}else{
			s excelStr=excelData	
		}
		s totalLen=$l(excelStr,"!")
		f tloop=1:1:totalLen {
			s cInput = $p(excelStr,"!",tloop)
			Set BLTypeCode=$p(cInput,"^",1)
		    continue:BLTypeCode=""
			if $d(HadTypeAry(BLTypeCode)){
				s findRepeat=1
			    if RepeatCodeStr="" s RepeatCodeStr=BLTypeCode
			    else  s RepeatCodeStr=RepeatCodeStr_","_BLTypeCode
			}
		}
	}
	Q:findRepeat=1 "-1^单据代码【"_RepeatCodeStr_"】重复"
	
    Ts
	s mRtn=0
	s loop=0
	for{
		s loop=$o(excelStrArr(loop))
		q:loop=""
		s excelData=excelStrArr(loop)
		s excelStr=""
		i $CLASSNAME(excelData)["CSP.CharacterStream" {
			d excelData.Rewind()
			while (excelData.AtEnd = 0)
			{
				s excelStr=excelStr_excelData.Read(2000)
			}
		}else{
			s excelStr=excelData	
		}
		s totalLen=$l(excelStr,"!")
		f tloop=1:1:totalLen {
			s cInput = $p(excelStr,"!",tloop)
			s rtn=..ImportTypeFromExcel(cInput,ExpStr)
			i rtn'=0{
				s mRtn=$p(cInput,"^",1)_","_$p(cInput,"^",2)_","_rtn
			}
			q:rtn'=0 
		}
		q:mRtn'=0 
	}
	if mRtn=0{
		Tc
	}else{
		Tro	
	}
	
    q mRtn
}

ClassMethod ImportTypeFromExcel(excelStr As %String, ExpStr As %String = "") As %String
{
	s ^tmplog("ImportTypeFromExcel")=$lb(excelStr,ExpStr)
	s ImportHospName=""
	s ImportHospId=$p(ExpStr,"^",1) //导入院区
	s:ImportHospId'="" ImportHospName=$p(^CT("HOSP",ImportHospId),"^",2)
	
	k HasBLTempleAry
	s ID=0
	for{
		s ID=$O(^DHCDocBLTem(ID))
		q:ID=""
		s BLMapType=$P(^DHCDocBLTem(ID),"^",4)
		s BLTempleID=$P(^DHCDocBLTem(ID),"^",3)
		if BLMapType="" s BLMapType="BL"
		s HasBLTempleAry(BLMapType,BLTempleID)=ID
	}
	
	s InPara=excelStr
	s InPara=$replace(InPara,"^""","^")
	s InPara=$replace(InPara,"""^","^")
    s TempID=$p(InPara,"^",1)
    Q:TempID="" "-1^单据ID不能为空!"
    s TempDesc=$p(InPara,"^",2)
    Q:TempDesc="" "-1^单据描述不能为空!"
    s myRtn=0
    s BLTypeCode=$p(InPara,"^",1)
	s BLTypeDesc=$p(InPara,"^",2)
	s BLTypeJSAddress=$p(InPara,"^",3)
	s BLInit=$p(InPara,"^",4)
	s BLItemMast=$p(InPara,"^",5)
	s BLSaveOther=$p(InPara,"^",6)
	s BLLoadOther=$p(InPara,"^",7)
	s BLXMLTempName=$p(InPara,"^",8)
	s MapCodeStr=$p(InPara,"^",9)
	s MapType=$p(InPara,"^",10)
	s BLTempIDStr=""
	s NotExistTemp=""
	if MapCodeStr'=""{
		s MapCodeStrLen=$l(MapCodeStr,$c(1))
		for tp=1:1:MapCodeStrLen{
			s MapBLTempCode=$p(MapCodeStr,$c(1),tp)
			if $d(HasBLTempleAry(MapType,MapBLTempCode)){
				s BLTempID=HasBLTempleAry(MapType,MapBLTempCode)	
				if BLTempIDStr="" s BLTempIDStr=BLTempID
				else  s BLTempIDStr=BLTempIDStr_"||"_BLTempID
			}else{
				if NotExistTemp="" s NotExistTemp=MapBLTempCode
				else  s NotExistTemp=NotExistTemp_","_MapBLTempCode
			}
		}	
	}
	s tBLTypeCode=BLTypeCode
	if NotExistTemp'=""{
		;w tBLTypeCode_",对应代码为【"_NotExistTemp_"】的模板不存在,未导入",!
	}
	;s ret=##class(web.DHCDocAPPBL).InsertBLType(BLTypeCode,BLTypeDesc,BLTypeJSAddress,"",BLInit,BLItemMast,BLSaveOther,BLLoadOther,MapType,BLXMLTempName)
	&SQL(insert into SQLUser.DHC_DocAppBLMap 
		(APPMap_Code,APPMap_Name,APPMap_ShowJS,APPMap_FristFunction,
		APPMap_ItmmastFunction,APPMap_SaveOtherInfo,APPMap_LoadOtherInfo,APPMap_MapType,APPMap_XMLTempName,APPMap_ShowTemp
		) Values(:BLTypeCode,:BLTypeDesc,:BLTypeJSAddress,:BLInit,
		:BLItemMast,:BLSaveOther,:BLLoadOther,:MapType,:BLXMLTempName,:BLTempIDStr))
	if 'SQLCODE{
		s Rowid=+%ROWID 
	}else{
		s mRtn=BLTypeCode_",插入DHC_DocAppBLMap失败,错误代码："	_SQLCODE
	}
	q myRtn
}

}
