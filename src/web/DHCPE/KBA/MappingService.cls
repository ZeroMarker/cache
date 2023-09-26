/// 名称: web.DHCPE.KBA.MappingService
/// 描述: 健康体检知识库应用对照服务
/// 编写者：zhufei
/// 编写日期: 2021-11-04
Class web.DHCPE.KBA.MappingService Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    yupeng
/// CreatDate：  2021-11-10
/// Description: 知识库维护-站点项目分类
/// Table：      站点项目分类 HM.BT.ExamItemCat 
/// Input:       
/// Return：
/// Dubug:d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.MappingService","QueryExamItemCat","ST")
Query QueryExamItemCat(aType As %String = "ST") As websys.Query(ROWSPEC = "EICRowId,EICCode,EICDesc,EICDesc2,EICSort")
{
}

ClassMethod QueryExamItemCatExecute(ByRef qHandle As %Binary, aType As %String = "ST") As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
    Set qHandle=$lb(0,repid,0)
    
	Set arrItemCat=##class(HMS.IO.ToPESrv).GetItemCatArray()
	Quit:arrItemCat.Count()<1 return
	Set Cnt=arrItemCat.Count()
	For idxCat=1:1:Cnt {
		Set objCat=arrItemCat.GetAt(idxCat)
		Continue:'$IsObject(objCat)
		
		Set ID           = objCat.GetAt("ID")            //ID
		Set Code         = objCat.GetAt("Code")          //内部编码
		Set Desc         = objCat.GetAt("Desc")          //分类名称
		Set Desc2        = objCat.GetAt("Desc2")         //别名
		Set Sort         = objCat.GetAt("Sort")          //顺序号
		Continue:(Code="")||(Desc="")
    	Continue:(aType="ST")&&(($e(Code,1,2)="U2")&&(Code'="U200"))
    	Continue:(aType="STC")&&(($e(Code,1,2)'="U2")||(Code="U200"))
		
		;s Desc = ##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("HM.BT.ExamItemCat",Desc,"EICDesc","cls")
		;s Desc2 = ##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("HM.BT.ExamItemCat",Desc2,"EICDesc2","cls")
		Set Data=$lb(ID,Code,Desc,Desc2,Sort)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
    Quit $$$OK
}

/// Creator：    zhufei
/// CreatDate：  2021-11-11
/// Description: 知识库版本下拉框
/// Table：      医院标签定义（版本定义） HM.BT.HospitalTags 
/// Input:       aAlias ：别名
/// Return：     ROWSPEC = 
/// Do ##class(%ResultSet).RunQuery("web.DHCPE.KBA.MappingService","QryExamItemDtl","152")
Query QryExamItemDtl(aLocID As %String, aAlias As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,ItemCatCode:%String,ItemCatDesc:%String,DataFormat:%String,Unit:%String,Explain:%String,DataFormatDesc:%String") [ SqlProc ]
{
}

ClassMethod QryExamItemDtlExecute(ByRef qHandle As %Binary, aLocID As %String, aAlias As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Kill arrKBItemDtlCode
	Set xID=0
	For {
		Set xID=$o(^User.DHCPEExpressD(xID))
		Quit:xID=""
		
		Set objEDExpress=##class(User.DHCPEExpress).GetObjById(xID)
		Continue:'$IsObject(objEDExpress)
		Set KBItemDtlCode=objEDExpress.EKBItemDtlCode
		Set KBItemDtlDesc=objEDExpress.EKBItemDtlDesc
		Continue:KBItemDtlCode=""
		Set SourceID=objEDExpress.ESourceID
		Continue:SourceID=""
		Set flg=##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(SourceID,aLocID)
		Continue:flg'="Y"
		
		Set arrKBItemDtlCode(KBItemDtlCode)=KBItemDtlDesc
	}
	Quit:$o(arrKBItemDtlCode(""))="" $$$OK
	
	Set arrOrdDtl=##class(HMS.IO.ToPESrv).GetItemDtlArray()
	Quit:arrOrdDtl.Count()<1 return
	Set Cnt=arrOrdDtl.Count()
	For idxOrdDtl=1:1:Cnt {
		Set objOrdDtl=arrOrdDtl.GetAt(idxOrdDtl)
		Continue:'$IsObject(objOrdDtl)
		
		Set ID           = objOrdDtl.GetAt("ID")            //ID
		Set Code         = objOrdDtl.GetAt("Code")          //内部编码
		Set Desc         = objOrdDtl.GetAt("Desc")          //细项名称
		Set ItemCatCode  = objOrdDtl.GetAt("ItemCatCode")   //站点项目分类代码
		Set ItemCatDesc  = objOrdDtl.GetAt("ItemCatDesc")   //站点项目分类名称
		Set DataFormat   = objOrdDtl.GetAt("DataFormat")    //数据格式（T说明型，N数值型，C计算型，S选择型，A多行文本）
		Set Unit         = objOrdDtl.GetAt("Unit")          //单位
		Set Explain      = objOrdDtl.GetAt("Explain")       //说明
		Set Sex          = objOrdDtl.GetAt("Sex")           //性别
		Set Sort         = objOrdDtl.GetAt("Sort")          //顺序号
		Continue:(Code="")||(Desc="")
		Continue:'$d(arrKBItemDtlCode(Code))
		
		Set DataFormatDesc = $s(DataFormat="T":"说明型",DataFormat="N":"数值型",DataFormat="C":"计算型",DataFormat="S":"选择型",DataFormat="A":"多行文本",1:DataFormat)
		Continue:($zcvt(Desc,"U")'[$zcvt(aAlias,"U"))&($zcvt(ItemCatDesc,"U")'[$zcvt(aAlias,"U"))
		;d Translate
		Set Data=$lb(ID,Code,Desc,ItemCatCode,ItemCatDesc,DataFormat,Unit,Explain,DataFormatDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill arrKBItemDtlCode
	
    Quit $$$OK
Translate
	s Desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("HM.BT.ExamItemDetail",Desc,"EIDDesc","cls")
	s ItemCatDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("HM.BT.ExamItemCat",ItemCatDesc,"EICDesc","cls")
	s DataFormat=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("HM.BT.ExamItemDetail",DataFormat,"EIDDataFormat","cls")
	s Explain=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("HM.BT.ExamItemDetail",Explain,"EIDExplain","cls")
	s DataFormatDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.orderdetail.csp",DataFormatDesc)
}

}
