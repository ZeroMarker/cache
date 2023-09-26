/// Description: 对外卡管理中间层后台类
/// 
/// 
/// 后台关联配置: 产品配置->医生站配置->外部接口测试->对外接口接入管理->扩展设定
/// 		对外接口接入管理-扩展设定(如不需要相关接口，请勿增加相关配置)
///     【代码】固定(模块级)
///     【描述】固定(模块级)
///     【值】具体调用后台方法,包含类方法名及入参。方法名自定义,已定好入参不要更改，其他入参可自行增加（要求前后一致）
///     	发卡相关接口入参:
///             Para1: 患者信息实体myCardObj s myPatObj=##class(web.DHCEntity.PCA.PATMAS).%New()
///             Para2: 卡信息实体myPatObj s myCardObj=##class(web.DHCEntity.PCA.CardRef).%New()			
///     	修改患者信息接口入参:
///             Para1: 病人表id PAPMIRowID
///         (修改入参个数)
///              如要修改入参个数，请分别修改后台调用和类方法，
///              中间层(本cls)方法Para1为所维护【代码】,从Para2,Para3……开始分别对应接口层方法入参的Para1,Para2……
///              原已有入参请保留,入参能一一对照即可，入参名可不完全一致
///     ● 获取二维码卡号(注册二维码) 
///         代码: GetQRCode
///         值: 如 ##class(DHCDoc.Interface.Outside.TZWYElecHealthCard.Methods).SaveCardInfo(myPatObj,myCardObj) 
///         入参:  Para1 患者信息实体myCardObj, Para2 卡信息实体myPatObj
///         返回值: 非0^Msg: 失败^报错信息  
///                 0^CardNo: 成功^卡号(可为空,不为空且建卡后台为空时将修改建卡卡号)
///     ● 创建患者信息后
///         代码: AfterPatCreat
///         值: 如 ##class(DHCDoc.Interface.Outside.TZWYElecHealthCard.Methods).SaveOtherCardInfo(myPatObj,myCardObj)
///         入参: Para1 患者信息实体myCardObj, Para2 卡信息实体myPatObj
///         返回值: 非0^Msg: 失败^报错信息  
///                 0: 成功
///     ● 更新患者信息后
///         代码: AfterPatUpdate
///         值: 如 ##class(DHCDoc.Interface.Outside.TZWYElecHealthCard.Methods).UpdatePlatPatInfo(PAPMIRowID)
///         入参: Para1 病人表id PAPMIRowID
///         返回值: 非0^Msg: 失败^报错信息  
///                 0: 成功
/// 业务层调用中间层
///     ● w ##class(DHCDoc.Interface.CardManage).Interface("GetQRCode",myCardObj,myPatObj)
///     ● w ##class(DHCDoc.Interface.CardManage).Interface("AfterPatCreat",myCardObj,myPatObj)
///     ● w ##class(DHCDoc.Interface.CardManage).Interface("AfterPatUpdate",PAPMIRowID)
Class DHCDoc.Interface.CardManage Extends %RegisteredObject
{

/// Creator: 
/// Date: 2023-02-01 15:43:39
/// Description: 获取当前卡类型是否启用此厂商卡管理【卡类型配置】
/// Table: 
/// Input: 
/// Output: 
/// Others: w ##class(DHCDoc.Interface.CardManage).GetExtCardJson(2)
ClassMethod GetExtCardJson(HospId As %String = "") As %String
{
    s ^temp("GetExtCardJson")=$lb(HospId)
    i HospId="" s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
    s ExtCardObj=##Class(DHCDoc.Util.ListData).%New()   // []  

    // s AccessLinkInfo=##class(DHCDoc.Interface.AccessManage).GetAccessLinkInfo("Company","DZJKK",HospId,"Card")    
    // [{"CompanyRowid":2,"CompanyCode":"ChangShangYi","CompanyDesc":"厂商一","ModuleRowid":2,"ModuleCode":"DZJKK","ModuleDesc":"电子健康卡","ReferenceJS":"2132323","ExtList":[{"ExtRowid":"3||1","ExtCode":"代码","ExtDesc":"描述","ExtValue":"自定义值"},{"ExtRowid":"3||2","ExtCode":"代码1","ExtDesc":"描述1","ExtValue":"自已定义1"}]},{"CompanyRowid":1,"CompanyCode":"TongZhiWeiYe","CompanyDesc":"同智伟业","ModuleRowid":2,"ModuleCode":"DZJKK","ModuleDesc":"电子健康卡","ReferenceJS":"","ExtList":[]}]
    /* s AccessLinkInfo=##class(DHCDoc.Interface.AccessManage).GetAccessLinkInfo("Company","ALL",HospId,"Card")
    s Arr=##Class(DHCDoc.Util.ArrayData).%New()
	s JsonObj=Arr.%FromJSON(AccessLinkInfo)
    //f len=1:1:JsonObj.Size {
    f len=1:1:JsonObj.%Size() {
        s CompanyRowid=JsonObj.Data(len).CompanyRowid
        s CompanyCode=JsonObj.Data(len).CompanyRowid
        s CompanyDesc=JsonObj.Data(len).CompanyDesc
        s ModuleRowid=JsonObj.Data(len).ModuleRowid
        s ModuleCode=JsonObj.Data(len).ModuleCode
        s ModuleDesc=JsonObj.Data(len).ModuleDesc
        s CompanyObj=##Class(DHCDoc.Util.ArrayData).%New()   // {}
        s CompanyObj.id=CompanyRowid_"||"_ModuleRowid
        s CompanyObj.text=CompanyDesc_"【"_ModuleDesc_"】"
        d ExtCardObj.%Push(CompanyObj)  // [{}]
    } */
    s LinkRowid=0
    f {
        s LinkRowid=$o(^CF.DOC.Interface.AccessManageD(LinkRowid)) q:(LinkRowid="")||(LinkRowid="Ext")
		s ActiveFlag=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),7)
		continue:ActiveFlag'="Y"
        s LinkProductDomainStr=""
		s LinkProductDomain=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),5)
		for m=1:1:$l(LinkProductDomain,"!") {
			s LinkProductDr=$p(LinkProductDomain,"!",m)
            continue:(LinkProductDr="")
			s LinkProductCode=$lg(^CT.DOC.Interface.AccessProductD(LinkProductDr),2)
			if (LinkProductDomainStr="") s LinkProductDomainStr=LinkProductCode
			else  s LinkProductDomainStr=LinkProductDomainStr_","_LinkProductCode
		}
		continue:(","_LinkProductDomainStr_",")'[(","_"Card"_",")     
        s LinkHospitalId=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),8)
	    continue:(HospId'="")&&(HospId'=LinkHospitalId)
        s CompanyDR=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),2)
        s ModuleDR=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),3)     
        s CompanyCode=$lg(^CT.DOC.Interface.AccessCompanyD(CompanyDR),2)
        s CompanyDesc=$lg(^CT.DOC.Interface.AccessCompanyD(CompanyDR),3)
        s ModuleCode=$lg(^CT.DOC.Interface.AccessModuleD(ModuleDR),2)
        s ModuleDesc=$lg(^CT.DOC.Interface.AccessModuleD(ModuleDR),3)            
        s CompanyObj=##Class(DHCDoc.Util.ArrayData).%New()   // {}
        s CompanyObj.id=LinkRowid
        s CompanyObj.text=CompanyDesc_"【"_ModuleDesc_"】"
        d ExtCardObj.%Push(CompanyObj)  // [{}]
    }
    
    s ExtCardStream=ExtCardObj.%ToJSON()  // 流
    s ExtCardString=ExtCardStream.Read()  // 串
    s ExtCardString=$REPLACE(ExtCardString,"""","'")
    q ExtCardString
}

/// Creator: 
/// Date: 2023-02-01 15:43:39
/// Description: 是否允许无卡号发卡
/// Table: 
/// Input: 卡类型id
/// Output: 0否  1是
/// Others: w ##class(DHCDoc.Interface.CardManage).GetNoExtCardNoFlag(2)
ClassMethod GetNoExtCardNoFlag(CardTypeDR As %String = "") As %String
{
    s ^temp("GetNoExtCardNoFlag")=$lb(CardTypeDR)    
    q:(CardTypeDR="") 0
    s AllowNoCardNoFlag=0
    s CardTypeData=..GetCardTypeData(CardTypeDR)
    s AllowNoCardNoFlag=$p(CardTypeData,"^",1)
    i AllowNoCardNoFlag="Y" s AllowNoCardNoFlag=1
    q AllowNoCardNoFlag
}

/// Creator: 
/// Date: 2023-02-01 15:43:39
/// Description: 卡类型是否开启外部卡关联
/// Table: 
/// Input: 
/// Output: 0否  1是
/// Others: w ##class(DHCDoc.Interface.CardManage).GetQRCardFlagByCardType("2","TongZhiWeiYe_DZJKK")
ClassMethod GetQRCardFlagByCardType(CardTypeDR As %String = "", LocId As %String = "", ModuleName As %String = "") As %String
{
    s ^temp("GetQRCardFlagByCardType")=$lb(CardTypeDR,LocId,ModuleName)
    q:(CardTypeDR="")||(ModuleName="") 0
    s QRCardFlag=0
    s CardTypeData=..GetCardTypeData(CardTypeDR)
    s ExtCardLinkStr=$p(CardTypeData,"^",2)
    s len=$l(ExtCardLinkStr,",")
    f i=1:1:len {
        s LinkRowid=$p(ExtCardLinkStr,",",i)
        continue:(LinkRowid="")
        /* s CompanyCode=$lg(^CT.DOC.Interface.AccessCompanyD(+ExtCardDR),"^",2) 
        s ModuleCode=$lg(^CT.DOC.Interface.AccessModuleD($p(ExtCardDR,"||",2)),2) */
        s LocOpenFlag="N",key=""
        s LinkObj=##class(CF.DOC.Interface.AccessManage).%OpenId(LinkRowid)
		while ((LinkObj.AMAuthLocStr)&&(LinkObj.AMAuthLocStr.GetNext(.key))&&(LocOpenFlag'="Y")) {
			s AuthLocId=LinkObj.AMAuthLocStr.GetAt(key)
			if (LocId'="")&&(LocId=AuthLocId) s LocOpenFlag="Y"
		}
		if (LocId="")||(LinkObj.AMAuthLocStr.Count()=0) s LocOpenFlag="Y"
        continue:LocOpenFlag'="Y"
        
        s CompanyDR=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),2)
        s ModuleDR=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),3)     
        s CompanyCode=$lg(^CT.DOC.Interface.AccessCompanyD(CompanyDR),2)
        s CompanyDesc=$lg(^CT.DOC.Interface.AccessCompanyD(CompanyDR),3)
        s ModuleCode=$lg(^CT.DOC.Interface.AccessModuleD(ModuleDR),2)
        s ModuleDesc=$lg(^CT.DOC.Interface.AccessModuleD(ModuleDR),3) 
		s CompanyCode=CompanyCode_"_"_ModuleCode
        i ModuleName=CompanyCode {
            s QRCardFlag=1
            q
        }
    }
    q QRCardFlag
}

/// Creator: 
/// Date: 2023-02-01 15:43:39
/// Description: 获取卡类型部分数据
/// Table: 
/// Input: 
/// Output: 
/// Others: w ##class(DHCDoc.Interface.CardManage).GetCardTypeData(CardTypeDR)
ClassMethod GetCardTypeData(CardTypeDR As %String = "")
{
    s ^temp("GetCardTypeData")=$lb(CardTypeDR)    
    q:(CardTypeDR="") ""
    s ExtCardLinkStr=""
    s AllowNoCardNoFlag=0
    s CardTypeObj=##class(User.DHCCardTypeDef).%OpenId(CardTypeDR)
    if $ISOBJECT(CardTypeObj) {
        s ExtCardLinkStr=CardTypeObj.CTDExtCardLinkStr
        s AllowNoCardNoFlag=CardTypeObj.CTDAllowNoCardNoFlag
        do CardTypeObj.%Close()
    }
    q AllowNoCardNoFlag_"^"_ExtCardLinkStr
}

/// Creator: 
/// Date: 2023-02-01 15:43:36
/// Description: 调用第三方平台创建相关卡(返回卡号)
/// Table: 
/// Input:  KeyName: "GetQRCode": 获取二维码卡号(注册二维码)
/// 				 "AfterPatCreat": 创建患者信息后  
/// 				 "AfterPatUpdate": 更新患者信息后
/// Output: 非0^Msg: 失败^报错信息  
///         0^CardNo(CardRowID): 成功^卡号(卡表id)
/// 			GetQRCode: 0^卡号
/// 			AfterPatCreat: 0^卡表id(可为空)
/// 			AfterPatUpdate: 0
/// Others: w ##class(DHCDoc.Interface.CardManage).Interface("GetQRCode",myCardObj,myPatObj)
/// Others: w ##class(DHCDoc.Interface.CardManage).Interface("AfterPatCreat",myCardObj,myPatObj)
/// Others: w ##class(DHCDoc.Interface.CardManage).Interface("AfterPatUpdate",PAPMIRowID)
ClassMethod Interface(KeyName As %String, Input...) As %String
{
    s $zt="InterfaceErr"


    s tmpInput=""
    f i=1:1:$g(Input,0){
        s @("Input"_i)=$g(Input(i),"<NULL>")
        if (tmpInput=""){
            s tmpInput="Input"_i
        }else{
            s tmpInput=tmpInput_","_"Input"_i
        }
    }
    s CardTypeStr=""
	i KeyName="AfterPatUpdate" {
		s PAPMIRowID=@"Input1"  // 如果和实参名一致,可以不加
		s ^temp("PAPMIRowID",3)=PAPMIRowID
		s CFRowID=""
		f {
			s CFRowID=$o(^DHCCARDi("CF",0,"PAPMIDR",PAPMIRowID,CFRowID)) q:CFRowID=""
			s CFActiveFlag=$p(^DHCCARD("CF",CFRowID),"^",10)
			continue:CFActiveFlag'="N"
			s CFCardTypeID=$p(^DHCCARD("CF",CFRowID),"^",16)
			i CardTypeStr="" s CardTypeStr=CFCardTypeID
			e  s CardTypeStr=CardTypeStr_"^"_CFCardTypeID
		}
	}else{
		s myCardObj=@"Input2"
		s CardTypeDR = myCardObj.CardTypeDefine
    	s CardTypeStr = CardTypeDR
	}
	s rtn=0
	s CardTypeLen=$l(CardTypeStr,"^")
    f i=1:1:CardTypeLen {
	    s CardTypeDR=$p(CardTypeStr,"^",i)
	    // 通过卡类型获取对应外部卡配置
	    s CardTypeData=..GetCardTypeData(CardTypeDR)
	    s ExtCardLinkStr=$p(CardTypeData,"^",2)
	    s ExtCardLinLen=$l(ExtCardLinkStr,",")
	    f j=1:1:ExtCardLinLen {
	        s LinkRowid=$p(ExtCardLinkStr,",",j)
	        continue:(LinkRowid="")
	        s ChildSub=0
	        for {
	            s ChildSub=$o(^CF.DOC.Interface.AccessManageD(LinkRowid,"Ext",ChildSub)) Q:ChildSub=""
	            s ExtRowid=LinkRowid_"||"_ChildSub
	            s ExtCode=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid,"Ext",ChildSub),2)
	            s ExtDesc=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid,"Ext",ChildSub),3)
	            s ExtValue=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid,"Ext",ChildSub),4)
	            continue:(ExtCode'=KeyName)||(ExtValue="")
                s className=$p($p(ExtValue,"##class(",2),")",1)
                s methodName=$p($p(ExtValue,").",2),"(",1)
                s className=$replace(className," ","")
                s methodName=$replace(methodName," ","")
                
                continue:(className="")||(methodName="")
                s flag=##class(%Dictionary.MethodDefinition).%ExistsId(className_"||"_methodName)
                continue:(flag'=1)
                //x "SET rtn="_ExtValue
	            //x ("(rtn) Set rtn="_ExtValue, .rtn)
	            //x ("(myPatObj, myCardObj, rtn) Set rtn="_ExtValue, myPatObj, myCardObj, .rtn)
                e  s exeStr="rtn=##class("_className_")."_methodName_"("_tmpInput_")"
                s @exeStr
                s rtn=@"rtn"
	            q:+rtn=0
	        }
	    }
    }

    q rtn
InterfaceErr
    s $zt=""
	s ermsg=$ze
	q "-1^"_ermsg
}

}
