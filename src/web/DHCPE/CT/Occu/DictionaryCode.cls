/// web.DHCPE.CT.Occu.DictionaryCode
/// create by zhongricheng
/// 职业病基础代码对照表 - 用于增加/对照新的职业病字段
Class web.DHCPE.CT.Occu.DictionaryCode Extends %RegisteredObject
{

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 按类型查询对应的分类数据
/// Table：        DHC_PE_DictionaryCode
/// Input：        类型  描述  激活
/// Output：       ID  代码  描述  类型  关联  激活  子节点标志  扩展信息  备注  平台代码  自定义数据1  自定义数据2  自定义数据3
/// Return：       
/// Others：       d ##class(%ResultSet).RunQuery("web.DHCPE.CT.Occu.DictionaryCode","SearchBaseCode","36000","AREA")
Query SearchBaseCode(Type, PType As %String = "", Desc As %String = "", Active As %String = "") As websys.Query(ROWSPEC = "TId:%String,TCode:%String,TDesc:%String,TType:%String,TRelation:%String,TActive:%String,TExFlag:%String,TExp:%String,TRemark:%String,TPlatformCode:%String,TCustomData1:%String,TCustomData2:%String,TCustomData3:%String")
{
}

ClassMethod SearchBaseCodeExecute(ByRef qHandle As %Binary, Type, PType As %String = "", Desc As %String = "", Active As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	if (Type="") Quit $$$OK
	s Type=$$ALPHAUP^SSUTIL4(Type)
	
	s Id=""
	f  s Id=$o(^CT.PE.OccuDictionaryCodeI("TypeIndex"," "_Type,Id)) q:Id=""  d
	.s Data=$g(^CT.PE.OccuDictionaryCodeD(Id))
	.s iCode=$lg(Data,2)
	.s iDesc=$lg(Data,3)
	.q:((Desc'="")&&(iDesc'[Desc))
	.s iType=$lg(Data,4)
	.s iRelation=$lg(Data,5)
	.s iRType=""
	.s:((iRelation'="")&&(iRelation'="Base")) iRType=$lg(^CT.PE.OccuDictionaryCodeD(iRelation),4)
	.q:((PType'="")&&(iRType'=PType))
	.
	.s iActive=$lg(Data,6)
	.q:((Active'="")&&(iActive'=Active))
	.s iExFlag=$lg(Data,7)
	.s iExp=$lg(Data,8)
	.s iRemark=$lg(Data,9)
	.s iPlatformCode=$lg(Data,10)
	.s iCustomData1=$lg(Data,11)
	.s iCustomData2=$lg(Data,12)
	.s iCustomData3=$lg(Data,13)
	.d TheBaseCode
	
	Quit $$$OK
	
TheBaseCode	
	s iDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEOccuDictionaryCode",iDesc,"ODCDesc","cls")
	
	set Data=$lb(Id,iCode,iDesc,iType,iRelation,iActive,iExFlag,iExp,iRemark,iPlatformCode,iCustomData1,iCustomData2,iCustomData3)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 增加/更新 基础代码  基础类型一旦增加 则代码不能修改
/// Table：        DHC_PE_DictionaryCode
/// Input：        类型  描述  激活
/// Output：       ID    代码^描述^激活^子节点标志^扩展信息^备注
/// Return：       
/// Others：       w ##class(web.DHCPE.CT.Occu.DictionaryCode).UpdBaseCode("","AREA^地区^Y^Y^^")
ClassMethod UpdBaseCode(Id, Strs)
{
    q:Strs="" ..OutJson("-1","无效数据")
    s Code=$$ALPHAUP^SSUTIL4($p(Strs,"^",1))
    q:Code="" ..OutJson("-1","代码不能为空")
    s Desc=$$ALPHAUP^SSUTIL4($p(Strs,"^",2))
    q:Desc="" ..OutJson("-1","描述不能为空")
    s Type="BASE"
    
    s tem=$o(^CT.PE.OccuDictionaryCodeI("TypeCodeIndex"," "_Type," "_Code,0))
    q:((Id'="")&&(Id'=tem)) ..OutJson("-1","相同代码已存在")
    q:((Id="")&&(""'=tem)) ..OutJson("-1","相同代码已存在")
    
    s Active=$p(Strs,"^",3)
    s:Active'="Y" Active="N"
    s ExFlag=$p(Strs,"^",4)
    s:ExFlag'="Y" ExFlag="N"
    
    s ExpInfo=$$ALPHAUP^SSUTIL4($p(Strs,"^",5))
    s Remark=$$ALPHAUP^SSUTIL4($p(Strs,"^",6))
    
    i Id="" {  // 增加
        s obj=##class(User.DHCPEOccuDictionaryCode).%New()
    } else {
        s obj=##class(User.DHCPEOccuDictionaryCode).%OpenId(Id)
    }
    
    s obj.ODCCode=Code
    s obj.ODCDesc=Desc
    s obj.ODCType=Type
    s obj.ODCActive=Active
    s obj.ODCExpInfo=ExpInfo
    s obj.ODCRemark=Remark
    s obj.ODCExFlag=ExFlag
    
    s sc=obj.%Save()
    d obj.%Close()
    If ($System.Status.IsError(sc)) {
        q ..OutJson("-1",$System.Status.GetErrorText(sc))
    } else {
        q ..OutJson("0",obj.%Id())
    }
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 增加/更新 基础明细代码
/// Table：        DHC_PE_DictionaryCode
/// Input：        类型  描述  激活
/// Output：       ID    对照节点ID    代码^描述^类型^激活^子节点标志^扩展信息^备注^平台代码^自定义数据1^自定义数据2^自定义数据3
/// Return：       
/// Others：       w ##class(web.DHCPE.CT.Occu.DictionaryCode).UpdBaseDetileCode("","1","100^内资企业^Y^^^N^ECONOMIC")
ClassMethod UpdBaseDetileCode(Id, pId, Strs)
{
    q:pId="" ..OutJson("-1","无效父节点")
    q:Strs="" ..OutJson("-1","无效数据")
    s Code=$$ALPHAUP^SSUTIL4($p(Strs,"^",1))
    q:Code="" ..OutJson("-1","代码不能为空")
    s Desc=$$ALPHAUP^SSUTIL4($p(Strs,"^",2))
    q:Desc="" ..OutJson("-1","描述不能为空")
    s Type=$$ALPHAUP^SSUTIL4($p(Strs,"^",3))
    q:Type="" ..OutJson("-1","未获取到类型")
    s PType=$lg(^CT.PE.OccuDictionaryCodeD(pId),2)
    q:Type'=PType ..OutJson("-1","无对应类型")
    
    s tem=$o(^CT.PE.OccuDictionaryCodeI("TypeCodeIndex"," "_Type," "_Code,0))
    q:((Id'="")&&(tem'="")&&(Id'=tem)) ..OutJson("-1","相同代码已存在")
    q:((Id="")&&(""'=tem)) ..OutJson("-1","相同代码已存在")
    
    s Active=$p(Strs,"^",4)
    s:Active'="Y" Active="N"
    
    s ExFlag=$p(Strs,"^",5)
    s:ExFlag'="Y" ExFlag="N"
    
    s ExpInfo=$$ALPHAUP^SSUTIL4($p(Strs,"^",6))
    s Remark=$$ALPHAUP^SSUTIL4($p(Strs,"^",7))
    
    s PlatformCode=$p(Strs,"^",8)
    s CustomData1=$p(Strs,"^",9)
    s CustomData2=$p(Strs,"^",10)
    s CustomData3=$p(Strs,"^",11)
    
    i Id="" {  // 增加
        s obj=##class(User.DHCPEOccuDictionaryCode).%New()
    } else {
        s obj=##class(User.DHCPEOccuDictionaryCode).%OpenId(Id)
    }
    
    s obj.ODCCode=Code
    s obj.ODCDesc=Desc
    s obj.ODCType=Type
    d obj.ODCRelationSetObjectId(pId)
    s obj.ODCActive=Active
    s obj.ODCExpInfo=ExpInfo
    s obj.ODCRemark=Remark
    s obj.ODCExFlag=ExFlag
    s obj.ODCPlatformCode=PlatformCode
    s obj.ODCCustomData1=CustomData1
    s obj.ODCCustomData2=CustomData2
    s obj.ODCCustomData3=CustomData3
    
    s sc=obj.%Save()
    d obj.%Close()
    If ($System.Status.IsError(sc)) {
        q ..OutJson("-1",$System.Status.GetErrorText(sc))
    } else {
        q ..OutJson("0",obj.%Id())
    }
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 返回所有子节点 返回子节点对象
/// Table：        DHC_PE_DictionaryCode
/// Input：        对照节点类型   类型   返回节点数   返回类型
/// Output：       
/// Return：       
/// Others：       w ##class(web.DHCPE.CT.Occu.DictionaryCode).GetBaseCodeObjByPIdNew("BASE", "ECONOMIC","",2,"String")
ClassMethod GetBaseCodeObjByPIdNew(pType, Type, pObj As %Library.DynamicObject = "", SubTree As %Library.Integer = 1, RtnFlag As %String = "", Active As %String = "")
{
	q:pType="" pObj
    q:Type="" pObj
    
    s pId=$o(^CT.PE.OccuDictionaryCodeI("TypeCodeIndex"," "_pType," "_Type,0))
    q:pId="" pObj
    
    q:'$d(^CT.PE.OccuDictionaryCodeD(pId)) pObj
    s PCode=$lg(^CT.PE.OccuDictionaryCodeD(pId),2)
    q:Type'=PCode pObj
    s DescTemp=""
    
    if (pObj="") {
        s PData=$g(^CT.PE.OccuDictionaryCodeD(pId))
        q:((Active'="")&&(Active'=$lg(PData,6))) pObj
        
	    s pObj=##class(%Library.DynamicObject).%New()
        s pObj.id=pId
        s pObj.text=$lg(PData,3)
        s pObj.state="open"
        s pObj.attributes={}
        s pObj.attributes.Code=$lg(PData,2)
        s DescTemp=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEOccuDictionaryCode",$lg(PData,3),"ODCDesc","cls")
        s pObj.attributes.Desc=DescTemp
        s pObj.attributes.Type=$lg(PData,4)
        s pObj.attributes.LinkDr=$lg(PData,5)
        s pObj.attributes.Active=$lg(PData,6)
        s pObj.attributes.ExFlag=$lg(PData,7)
        s pObj.attributes.ExCode=$lg(PData,8)
        s pObj.attributes.Remark=$lg(PData,9)
	    s pObj.attributes.PlCode=$lg(PData,10)
	    s pObj.attributes.Custom1=$lg(PData,11)
	    s pObj.attributes.Custom2=$lg(PData,12)
	    s pObj.attributes.Custom3=$lg(PData,13)
    }
    s pObj.children=##class(%Library.DynamicArray).%New()
    
    s BaseId=0
    f  s BaseId=$o(^CT.PE.OccuDictionaryCodeI("TypeRelationIndex"," "_Type,pId,BaseId)) q:BaseId=""  d
    .q:'$d(^CT.PE.OccuDictionaryCodeD(BaseId))
    .s Data=$g(^CT.PE.OccuDictionaryCodeD(BaseId))
    .q:((Active'="")&&(Active'=$lg(Data,6)))
    .s bobj=""
    .s bobj=##class(%Library.DynamicObject).%New()
    .s bobj.id=BaseId
    .s bobj.text=$lg(Data,3)_" ["_$lg(Data,2)_"]"
    .s bobj.state="closed"
    .
    .s bobj.attributes={}
    .s bobj.attributes.Code=$lg(Data,2)
    .s DescTemp=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEOccuDictionaryCode",$lg(Data,3),"ODCDesc","cls")
    .s bobj.attributes.Desc=DescTemp
    .s bobj.attributes.Type=$lg(Data,4)
    .s bobj.attributes.LinkDr=$lg(Data,5)
    .s bobj.attributes.Active=$lg(Data,6)
    .s bobj.attributes.ExFlag=$lg(Data,7)
    .s bobj.attributes.ExCode=$lg(Data,8)
    .s bobj.attributes.Remark=$lg(Data,9)
	.s bobj.attributes.PlCode=$lg(Data,10)
	.s bobj.attributes.Custom1=$lg(Data,11)
	.s bobj.attributes.Custom2=$lg(Data,12)
	.s bobj.attributes.Custom3=$lg(Data,13)
    .
    .d:SubTree>1 ..GetBaseCodeObjByPIdNew(Type,$lg(Data,2),.bobj,(SubTree-1),"",Active)
    .
    .d pObj.children.%Push(bobj)
    
    q:RtnFlag="String" pObj.%ToJSON()
    q pObj
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 通过父节点找所有子节点 返回流
/// Table：        DHC_PE_DictionaryCode
/// Input：        对照节点类型   类型   类型   
/// Output：       
/// Return：       
/// Others：       w ##class(web.DHCPE.CT.Occu.DictionaryCode).GetBaseCodeStreamByPIdNew("BASE","ECONOMIC")
ClassMethod GetBaseCodeStream(pType, Type, pObj As %Library.DynamicObject = "")
{
    q:pType="" ""
    q:Type="" ""
    
    d ..GetBaseCodeObjByPIdNew(pType, Type, .pObj, 5)
    s tmpObject = ##class(%Stream.GlobalCharacter).%New()
    d pObj.%ToJSON(tmpObject)
    
    s bigJson = ##class(%Stream.GlobalCharacter).%New()
    d bigJson.CopyFrom(tmpObject)
    q bigJson
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 通过父节点ID 查询下一层节点
/// Table：        DHC_PE_DictionaryCode
/// Input：        节点ID
/// Output：       
/// Return：       
/// Others：       w ##class(web.DHCPE.CT.Occu.DictionaryCode).GetOSubCodeByPId(1)
ClassMethod GetOSubCodeByPId(pId)
{
    q:pId="" ""
    s PData=$g(^CT.PE.OccuDictionaryCodeD(pId))
    s pCode=$lg(PData,2)
    s pExCode=$lg(PData,4)
    
    s data=..GetBaseCodeObjByPIdNew(pExCode, pCode, "", 1)
    q:data="" ""
    s cidData=data.children
    s pJson=[]
    for cnt=0:1:(cidData.%Size()-1) {
		s cid = cidData.%Get(cnt)
		s cJson={}
		s cJson.TId = cid.id
		s cJson.TCode = cid.attributes.Code
		s cJson.TDesc = cid.attributes.Desc
		s cJson.TType = cid.attributes.Type
		d pJson.%Push(cJson)
	}
	
    q pJson.%ToJSON()
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 返回所有根节点
/// Table：        DHC_PE_DictionaryCode
/// Input：        ID   ShowFlag(1:返回根节点Code  2:返回根节点描述  其他:返回ID)   SplitChar 返回分隔符
/// Output：       
/// Return：       
/// Others：       w ##class(web.DHCPE.CT.Occu.DictionaryCode).GetBaseCodeObjById(55,"",2,"")
ClassMethod GetBaseCodeObjById(Id, pIdStrs As %String = "", ShowFlag As %String = "", SplitChar As %String = "^")
{
    s pId=$lg(^CT.PE.OccuDictionaryCodeD(Id),5)
    q:pId="" ""
    s pStr=Id
    s:ShowFlag="1" pStr=$lg(^CT.PE.OccuDictionaryCodeD(Id),2)
    s:ShowFlag="2" pStr=$lg(^CT.PE.OccuDictionaryCodeD(Id),3)
    
    s pIdStrs=..GetBaseCodeObjById(pId,.pIdStrs,ShowFlag,SplitChar)_SplitChar_pStr
    q pIdStrs
}

/// Creator：      zhongricheng 
/// CreatDate：     
/// Description:： 返回所有根节点
/// Table：        DHC_PE_DictionaryCode
/// Input：        ID   ShowFlag(1:返回根节点Code  2:返回根节点描述  其他:返回ID)   SplitChar 返回分隔符
/// Output：       
/// Return：       
/// Others：       w ##class(web.DHCPE.CT.Occu.DictionaryCode).GetBaseCode(55,2)
ClassMethod GetBaseCode(Id, ShowFlag As %String = "")
{
    s pId=$lg(^CT.PE.OccuDictionaryCodeD(Id),5)
    q:pId="" ""
    s pStr=Id
    s:ShowFlag="1" pStr=$lg(^CT.PE.OccuDictionaryCodeD(Id),2)
    s:ShowFlag="2" pStr=$lg(^CT.PE.OccuDictionaryCodeD(Id),3)
    
    q pStr
}

ClassMethod OutJson(Code, Msg)
{
	s json={}
	s json.code=Code
	s json.msg=Msg
	q json.%ToJSON()
}

}
