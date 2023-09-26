/// 名称: ICD诊断代码
/// 描述: ICD诊断代码，包含添加、修改、查询、复制、合并功能
/// 编写者：基础数据平台组  陈莹
/// 编写日期: 2012-12-17
Class web.DHCBL.CT.MRCICDDx Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter SQLTableName = "MRC_ICDDx";

/// Creator：chenying
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.MRCICDDx
/// input: id(ICD诊断的rowid)
/// Ruturn： Json字符串
/// w ##class(web.DHCBL.CT.MRCICDDx).OpenData(1,"","")
/// RetFlag=""时，用于EXT, =JSON时，用于HISUI，不输出 "{list:["_str_"]}",Y/N不需要转换true  //2019-12-17
ClassMethod OpenData(id As %String, RetFlag As %String = "", hospid As %String = "") As %String
{
    n (id,RetFlag,hospid)
    s str=""
    s eobj = ##class(web.Entity.CT.MRCICDDx).%New()
    s eobj.MRCIDRowId = id
    s eobj.MRCIDCode=$p($g(^MRC("ID",id)),"^",1)  //代码
    s eobj.MRCIDDesc=$p($g(^MRC("ID",id)),"^",2)   //名称
    s eobj.MRCIDICD9CMCode=$p($g(^MRC("ID",id)),"^",4)     ///ICD10
    s eobj.MRCIDDateActiveFrom=$p($g(^MRC("ID",id)),"^",6)  //开始日期
    s eobj.MRCIDDateActiveTo=$p($g(^MRC("ID",id)),"^",7)  //结束日期
    s eobj.MRCIDAgeFrom=$p($g(^MRC("ID",id)),"^",8)  //开始年龄
    s eobj.MRCIDAgeTo=$p($g(^MRC("ID",id)),"^",9)  //结束年龄
    s eobj.MRCIDSexDR=$p($g(^MRC("ID",id)),"^",10)  //性别指针
    s eobj.MRCIDValid=$p($g(^MRC("ID",id)),"^",27)    //有效标志
    s:eobj.MRCIDValid="" eobj.MRCIDValid="Y"   //有效标志空时默认为Y 
    s eobj.MRCIDICD9Map=$p($g(^MRC("ID",id)),"^",35)     //ICD9代码
    s eobj.MRCIDNationalDesc=$p($g(^MRC("ID",id)),"^",49)  //国家标准名称
    s eobj.MRCIDLongDescription=$p($g(^MRC("ID",id)),"^",36)   //注释
    s eobj.MRCIDMetastaticSite=$p($g(^MRC("ID",id)),"^",40) //肿瘤形态学编码标志
    s eobj.MRCIDInjuryPoisoningCode=$p($g(^MRC("ID",id)),"^",41) //损伤中毒外部原因标志
    s eobj.MRCIDBillFlag3=$p($g(^MRC("ID",id)),"^",15) //中医诊断标志
    s eobj.MRCIDBillFlag1=$p($g(^MRC("ID",id)),"^",13) //中医标志证型
    s eobj.MRCID2ndCodeInPair=$p($g(^MRC("ID",id)),"^",43)   //副编码
    
    s eobj.MRCIDAgeFromType=$p($g(^MRC("ID",id)),"^",53)  //从年龄类型 （岁/月/日）
    s eobj.MRCIDAgeToType=$p($g(^MRC("ID",id)),"^",54)  //到年龄类型 （岁/月/日）
    s eobj.MRCIDGrayCodeFlag=$p($g(^MRC("ID",id)),"^",55) //医保灰码标志
    s eobj.MRCIDRareDiseaseFlag=$p($g(^MRC("ID",id)),"^",58) //罕见病标志
    
    //s eobj.ALIASText=$g(^MRC("ID",id,"ALIAS",1)) //取拼音
    s eobj.MRCIDDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MRCIDDateActiveFrom)
    s eobj.MRCIDDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MRCIDDateActiveTo)
    
    if RetFlag=""
    {
        s:eobj.MRCIDValid="Y" eobj.MRCIDValid="true"
        s:eobj.MRCIDMetastaticSite="Y" eobj.MRCIDMetastaticSite="true"
        s:eobj.MRCIDInjuryPoisoningCode="Y" eobj.MRCIDInjuryPoisoningCode="true"
        s:eobj.MRCIDBillFlag3="Y" eobj.MRCIDBillFlag3="true"
        s:eobj.MRCIDBillFlag1="Y" eobj.MRCIDBillFlag1="true"
        s:eobj.MRCIDGrayCodeFlag="Y" eobj.MRCIDGrayCodeFlag="true"
        s:eobj.MRCIDRareDiseaseFlag="Y" eobj.MRCIDRareDiseaseFlag="true"
    }
    s eobj.MRCIDCode=##class(web.DHCBL.BDP.FunLib).Util(eobj.MRCIDCode)
    s eobj.MRCIDDesc=##class(web.DHCBL.BDP.FunLib).Util(eobj.MRCIDDesc)
    s eobj.MRCIDICD9CMCode =##class(web.DHCBL.BDP.FunLib).Util(eobj.MRCIDICD9CMCode)
    s eobj.MRCIDICD9Map=##class(web.DHCBL.BDP.FunLib).Util(eobj.MRCIDICD9Map)
    s eobj.MRCIDLongDescription =##class(web.DHCBL.BDP.FunLib).Util(eobj.MRCIDLongDescription)
    s eobj.MRCIDTypeDR=$p($g(^MRC("ID",id)),"^",46)   //诊断类型
    s eobj.MRCIDClinicType = $p($g(^MRC("ID",id)),"^",47)   //就诊类型
    if eobj.MRCIDClinicType="" s eobj.MRCIDClinicType = "O,E,I,H,N"   //就诊类型为空时 默认门诊。急诊。住院。体检都可以开
    if eobj.MRCIDClinicType["O" s eobj.MRCIDClinicTypeO="O"  // 就诊类型 门诊
    if eobj.MRCIDClinicType["E" s eobj.MRCIDClinicTypeE="E"  // 就诊类型 急诊
    if eobj.MRCIDClinicType["I" s eobj.MRCIDClinicTypeI="I"  // 就诊类型 住院
    if eobj.MRCIDClinicType["H" s eobj.MRCIDClinicTypeH="H"  // 就诊类型 体检
    if eobj.MRCIDClinicType["N" s eobj.MRCIDClinicTypeN="N"  // 就诊类型 新生儿
    s eobj.MRCIDNationalCode=$p($g(^MRC("ID",id)),"^",50)   //国家标准编码
    
    //s eobj.MRCIDInsuCode=$p($g(^MRC("ID",id)),"^",51)   //国家医保编码  
    //s eobj.MRCIDInsuDesc=$p($g(^MRC("ID",id)),"^",52)   //国家医保名称
    s InsuInfo=##class(web.DHCBL.CT.MRCICDDx).GetStdInsuInfo(id,hospid)
    s eobj.MRCIDInsuCode=$p(InsuInfo,"^",1)  //国家医保编码  2022-04-11
    s eobj.MRCIDInsuDesc=$p(InsuInfo,"^",2)  //国家医保名称
    s eobj.MRCIDVersionDictDR=$p($g(^MRC("ID",id)),"^",56)   //版本号
    s eobj.MRCIDDiagnosticType=$p($g(^MRC("ID",id)),"^",57)
    s str = eobj.JsonS()    
    if RetFlag=""
    {
        s str = "{list:["_str_"]}"
    }
    q str
}

/// Creator：chenying
/// CreatDate: 2016-3-2
/// Description：复制ICD诊断代码信息，除代码和描述外
/// Table：User.MRCICDDx
/// Ruturn： Json字符串
/// w ##class(web.DHCBL.CT.MRCICDDx).CopyData(1,"","")
/// RetFlag=""时，用于EXT, =JSON时，用于HISUI，不输出 "{list:["_str_"]}",Y/N不需要转换true
ClassMethod CopyData(id As %String, RetFlag As %String = "", hospid As %String = "") As %String
{
    n (id,RetFlag,hospid)
    s str=""
    s eobj = ##class(web.Entity.CT.MRCICDDx).%New()
    s eobj.MRCIDRowId = ""
    ///兰大一院  自动生成诊断代码，库里最大值+1（总共5位)
    //s eobj.MRCIDCode=""
    if $p($g(^Config.BDPSpeConfig("MRCIDCONFIG")),"^",3)="true"
    {   
        s eobj.MRCIDCode =##class(web.DHCBL.CT.MRCICDDx).AutoCreateCode() 
    }
    else
    {
        s eobj.MRCIDCode=$p($g(^MRC("ID",id)),"^",1) 
    }
    s eobj.MRCIDDesc=$p($g(^MRC("ID",id)),"^",2) 
    s eobj.MRCIDICD9CMCode=$p($g(^MRC("ID",id)),"^",4)   //ICD10
    s eobj.MRCIDDateActiveFrom=$p($g(^MRC("ID",id)),"^",6)
    s eobj.MRCIDDateActiveTo=$p($g(^MRC("ID",id)),"^",7)
    s eobj.MRCIDAgeFrom=$p($g(^MRC("ID",id)),"^",8)
    s eobj.MRCIDAgeTo=$p($g(^MRC("ID",id)),"^",9)
    s eobj.MRCIDSexDR=$p($g(^MRC("ID",id)),"^",10)
    s eobj.MRCIDValid=$p($g(^MRC("ID",id)),"^",27)  //有效标志
    s:eobj.MRCIDValid="" eobj.MRCIDValid="Y"
    s eobj.MRCIDICD9Map=$p($g(^MRC("ID",id)),"^",35)   //ICD9
    s eobj.MRCIDNationalDesc=$p($g(^MRC("ID",id)),"^",49)  //国家标准名称
    s eobj.MRCIDLongDescription=$p($g(^MRC("ID",id)),"^",36)  //注释
    s eobj.MRCIDMetastaticSite=$p($g(^MRC("ID",id)),"^",40) //肿瘤形态学编码标志
    s eobj.MRCIDInjuryPoisoningCode=$p($g(^MRC("ID",id)),"^",41) //损伤中毒外部原因标志
    s eobj.MRCIDBillFlag3=$p($g(^MRC("ID",id)),"^",15) //中医诊断标志
    s eobj.MRCIDBillFlag1=$p($g(^MRC("ID",id)),"^",13)   //中医证型标志
    s eobj.MRCID2ndCodeInPair=$p($g(^MRC("ID",id)),"^",43)  //副编码
    
    s eobj.MRCIDAgeFromType=$p($g(^MRC("ID",id)),"^",53)  //从年龄类型 （岁/月/日）
    s eobj.MRCIDAgeToType=$p($g(^MRC("ID",id)),"^",54)  //到年龄类型 （岁/月/日）
    s eobj.MRCIDGrayCodeFlag=$p($g(^MRC("ID",id)),"^",55) //医保灰码标志
    s eobj.MRCIDRareDiseaseFlag=$p($g(^MRC("ID",id)),"^",58)
    s eobj.MRCIDDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MRCIDDateActiveFrom)
    s eobj.MRCIDDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MRCIDDateActiveTo)
    if RetFlag=""
    {
        s:eobj.MRCIDValid="Y" eobj.MRCIDValid="true"
        s:eobj.MRCIDMetastaticSite="Y" eobj.MRCIDMetastaticSite="true"
        s:eobj.MRCIDInjuryPoisoningCode="Y" eobj.MRCIDInjuryPoisoningCode="true"
        s:eobj.MRCIDBillFlag3="Y" eobj.MRCIDBillFlag3="true"
        s:eobj.MRCIDBillFlag1="Y" eobj.MRCIDBillFlag1="true"
        s:eobj.MRCIDGrayCodeFlag="Y" eobj.MRCIDGrayCodeFlag="true"
        s:eobj.MRCIDRareDiseaseFlag="Y" eobj.MRCIDRareDiseaseFlag="true"
    }
    s eobj.MRCIDCode=##class(web.DHCBL.BDP.FunLib).Util(eobj.MRCIDCode)
    s eobj.MRCIDDesc=##class(web.DHCBL.BDP.FunLib).Util(eobj.MRCIDDesc)
    s eobj.MRCIDICD9CMCode =##class(web.DHCBL.BDP.FunLib).Util(eobj.MRCIDICD9CMCode)
    s eobj.MRCIDICD9Map=##class(web.DHCBL.BDP.FunLib).Util(eobj.MRCIDICD9Map)
    s eobj.MRCIDLongDescription =##class(web.DHCBL.BDP.FunLib).Util(eobj.MRCIDLongDescription)
    s eobj.MRCIDTypeDR=$p($g(^MRC("ID",id)),"^",46)  //诊断类型
    
    s eobj.MRCIDClinicType = $p($g(^MRC("ID",id)),"^",47)  //就诊类型
    if eobj.MRCIDClinicType="" s eobj.MRCIDClinicType = "O,E,I,H,N"   //就诊类型为空时 默认门诊。急诊。住院。体检都可以开
    if eobj.MRCIDClinicType["O" s eobj.MRCIDClinicTypeO="O"  // 就诊类型 门诊
    if eobj.MRCIDClinicType["E" s eobj.MRCIDClinicTypeE="E"  // 就诊类型 急诊
    if eobj.MRCIDClinicType["I" s eobj.MRCIDClinicTypeI="I"  // 就诊类型 住院
    if eobj.MRCIDClinicType["H" s eobj.MRCIDClinicTypeH="H"  // 就诊类型 体检
    if eobj.MRCIDClinicType["N" s eobj.MRCIDClinicTypeN="N"  // 就诊类型 新生儿
    s eobj.MRCIDNationalCode=$p($g(^MRC("ID",id)),"^",50)   //国家标准编码
    //s eobj.MRCIDInsuCode=$p($g(^MRC("ID",id)),"^",51)   //国家医保编码  
    //s eobj.MRCIDInsuDesc=$p($g(^MRC("ID",id)),"^",52)   //国家医保名称
    //2022-04-11
    s Config=##class(web.DHCBL.BDP.INSUConfig).GetConfigByHospId(hospid,"MRC_ICDDx")
    if Config="INSU"
    {
        
    }
    else
    {
        s eobj.MRCIDInsuCode=$p($g(^MRC("ID",id)),"^",51)   //国家医保编码    
        s eobj.MRCIDInsuDesc=$p($g(^MRC("ID",id)),"^",52)   //国家医保名称
    }
    s eobj.MRCIDVersionDictDR=$p($g(^MRC("ID",id)),"^",56)   //版本号
    s eobj.MRCIDDiagnosticType=$p($g(^MRC("ID",id)),"^",57)  //诊断类型
    s str = eobj.JsonS()    
    if RetFlag=""
    {
        s str = "{list:["_str_"]}"
    }
    q str
}

/// Creator：chenying
/// CreatDate: 2017-07-03
/// Description：数据重复验证方法
/// Table：User.MRCICDDx
/// Input：id, code, desc, hospid ,enddate结束日期
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.DHCBL.CT.MRCICDDx).FormValidate("1","A00.01","肺结核瘤,痰镜检(+)","2","")
/// 校验：2021-01-15 代码和描述都一样的数据 返回1(有结束日期和有效标志为N的不校验
/// 20221229增加版本号入参
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "", enddate As %String = "", versiondr As %String = "") As %String
{
    n (id,code,desc,hospid,enddate,versiondr) 
    s flag=0    
    ///2021-01-22 chenying  停掉的数据不校验名称和代码
    if enddate'="" q flag
    
    s ValidCode=$p($g(^Config.BDPSpeConfig("MRCIDCONFIG")),"^",1)         //校验代码/描述是否重复，默认true
    s:ValidCode="" ValidCode="true"
    if (ValidCode="true")&&($$ALPHAUP^SSUTIL4(code)'="")
    {
        s rowid=0
        for
        {
            s rowid=$o(^MRC("ID",0,"Code",$$ALPHAUP^SSUTIL4(code),rowid)) q:rowid=""
            s MRCIDCode=$p($g(^MRC("ID",rowid)),"^",1)  //诊断代码
            s MRCIDDesc=$p($g(^MRC("ID",rowid)),"^",2)  //诊断描述
            s MRCIDValid=$p($g(^MRC("ID",rowid)),"^",27)  //诊断有效标志
            continue:MRCIDValid="N"
            s MRCIDDateActiveTo=$p($g(^MRC("ID",rowid)),"^",7)  //诊断结束日期
            continue:(MRCIDDateActiveTo'="")
            s MRCIDVersionDictDR=$p($g(^MRC("ID",rowid)),"^",56)  //版本号
            continue:(MRCIDVersionDictDR'=versiondr)
            if (MRCIDCode=code)&&(MRCIDDesc=desc)&&(id'=rowid)  //代码和描述一起校验
            {
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,rowid,hospid) //多院区判断医院
                continue:showflag="N"
                s flag=1
                
            }
        }
    }
    q flag
}

/// Creator：陈莹 基础数据平台
/// CreatDate: 2017-05-03
/// Description：河南省医与病案同步ICD诊断信息
/// Table：User.MRCICDDx
/// Input：str ( rowid^代码^名称^ICD10)
/// Return：>0(成功，返回rowid),-1(失败)
/// Other: w ##class(web.DHCBL.CT.MRCICDDx).SyncICDInfo("^S09.900^头部外伤^S09.900")
ClassMethod SyncICDInfo(str) As %String
{
    n (str,%session)
    s Rtn=""
    s eobj=##class(web.Entity.CT.MRCICDDx).%New()
    s eobj.MRCIDValid = "Y"
    s eobj.MRCIDRowId =$p(str,"^",1)
    s eobj.MRCIDCode = $p(str,"^",2)
    s eobj.MRCIDDesc = $p(str,"^",3)
    s eobj.MRCIDICD9CMCode = $p(str,"^",4)
    s result=##class(web.DHCBL.CT.MRCICDDx).SaveEntity(eobj)
    if result["success:'true'"
    {
        s Rtn=$p($p(result,"id:'",2),"'",1) 
    }
    else
    {
        s Rtn=-1
    }
    q Rtn
}

/// Creator：chenying
/// CreatDate: 2012-12-17
/// Description：保存修改ICD诊断代码的内容
/// Table：User.MRCICDDx
/// Input：web.Entity.CT.MRCICDDx 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.MRCICDDx).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.MRCICDDx) As %String
{
    n (eobj,%session)
    s result=""
    if $IsObject(eobj)
    {
        s:eobj.MRCIDValid="" eobj.MRCIDValid="N"
        ///s eobj.MRCIDValid = "Y"    ///有效性默认为Y
        s:eobj.MRCIDMetastaticSite="" eobj.MRCIDMetastaticSite="N"
        s:eobj.MRCIDInjuryPoisoningCode="" eobj.MRCIDInjuryPoisoningCode="N" 
        s:eobj.MRCIDBillFlag3="" eobj.MRCIDBillFlag3="N"
        s:eobj.MRCIDBillFlag1="" eobj.MRCIDBillFlag1="N"
        s:eobj.MRCIDGrayCodeFlag="" eobj.MRCIDGrayCodeFlag="N"  // 医保灰码
        s:eobj.MRCIDRareDiseaseFlag="" eobj.MRCIDRareDiseaseFlag="N"
        if (eobj.MRCIDAgeFromType'="Y")&&(eobj.MRCIDAgeFromType'="M")&&(eobj.MRCIDAgeFromType'="D")
        {
            s eobj.MRCIDAgeFromType=$case(eobj.MRCIDAgeFromType,"岁":"Y","月":"M","日":"D",:"")
        }
        if (eobj.MRCIDAgeToType'="Y")&&(eobj.MRCIDAgeToType'="M")&&(eobj.MRCIDAgeToType'="D")
        {
            s eobj.MRCIDAgeToType=$case(eobj.MRCIDAgeToType,"岁":"Y","月":"M","日":"D",:"")
        }
    
        ////2016-4-19 chenying  医生站需求  如果选择中医证型 必须选择中医诊断
        if eobj.MRCIDBillFlag1="Y" s eobj.MRCIDBillFlag3="Y"
        //诊断类型
        s MRCIDDiagnosticType=""
    	if (eobj.MRCIDBillFlag3'="Y")
	    {
		    s MRCIDDiagnosticType="WM"
	    }
	    if ((eobj.MRCIDBillFlag3="Y")&&(eobj.MRCIDBillFlag1'="Y"))
	    {
		    s MRCIDDiagnosticType="TCM"
	    }
	    if (eobj.MRCIDBillFlag1="Y")
	    {
		    s MRCIDDiagnosticType="ST"
	    }
	    s eobj.MRCIDDiagnosticType=MRCIDDiagnosticType
        
        s:eobj.MRCIDDateActiveFrom'="" eobj.MRCIDDateActiveFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MRCIDDateActiveFrom)
        s:eobj.MRCIDDateActiveTo'="" eobj.MRCIDDateActiveTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MRCIDDateActiveTo)
        s:eobj.MRCIDDateActiveFrom="" eobj.MRCIDDateActiveFrom=+$h
        //针对导入修改  2020-01-13
        if eobj.MRCIDClinicType["门诊" s eobj.MRCIDClinicTypeO="O"
        if eobj.MRCIDClinicType["急诊" s eobj.MRCIDClinicTypeE="E"
        if eobj.MRCIDClinicType["住院" s eobj.MRCIDClinicTypeI="I"
        if eobj.MRCIDClinicType["体检" s eobj.MRCIDClinicTypeH="H"
        if eobj.MRCIDClinicType["新生儿" s eobj.MRCIDClinicTypeN="N"
        ///将就诊类型拼起来， 用,分隔  
        s eobj.MRCIDClinicType=eobj.MRCIDClinicTypeO_","_eobj.MRCIDClinicTypeE_","_eobj.MRCIDClinicTypeI_","_eobj.MRCIDClinicTypeH_","_eobj.MRCIDClinicTypeN
        ///如果就诊类型都没有勾选，将就诊类型置为空
        I (eobj.MRCIDClinicTypeO'="")&&(eobj.MRCIDClinicTypeE'="")&&(eobj.MRCIDClinicTypeI'="")&&(eobj.MRCIDClinicTypeH'="")&&(eobj.MRCIDClinicTypeN'="") s eobj.MRCIDClinicType=""
        ///如果就诊类型勾选，将就诊类型置为空
        I (eobj.MRCIDClinicTypeO="")&&(eobj.MRCIDClinicTypeE="")&&(eobj.MRCIDClinicTypeI="")&&(eobj.MRCIDClinicTypeH="")&&(eobj.MRCIDClinicTypeN="") s eobj.MRCIDClinicType=""
        
        
        s flag=##class(web.DHCBL.CT.MRCICDDx).FormValidate(eobj.MRCIDRowId,eobj.MRCIDCode,eobj.MRCIDDesc,eobj.LinkHospId,eobj.MRCIDDateActiveTo,eobj.MRCIDVersionDictDR)
    
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该代码和描述已经存在！'}"
        }
        else
        {
            if (eobj.MRCIDRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.MRCICDDx).%New()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(User.MRCICDDx).%OpenId(eobj.MRCIDRowId)
                s bobj=##class(web.Entity.CT.MRCICDDx).%New()
                s bobj.MRCIDRowId = eobj.MRCIDRowId
                s bobj.MRCIDCode = obj.MRCIDCode
                s bobj.MRCIDDesc = obj.MRCIDDesc
                s bobj.MRCIDICD9CMCode = obj.MRCIDICD9CMCode
                s bobj.MRCIDDateActiveFrom = obj.MRCIDDateActiveFrom
                s bobj.MRCIDDateActiveTo = obj.MRCIDDateActiveTo
                s bobj.MRCIDAgeFrom = obj.MRCIDAgeFrom
                s bobj.MRCIDAgeTo = obj.MRCIDAgeTo
                s bobj.MRCID2ndCodeInPair = obj.MRCID2ndCodeInPair
                
                if $IsObject(obj.MRCIDSexDR){
                    s bobj.MRCIDSexDR = obj.MRCIDSexDR.%Id() 
                }
                s bobj.MRCIDValid = obj.MRCIDValid
            
                s bobj.MRCIDICD9Map = obj.MRCIDICD9Map
                s bobj.MRCIDLongDescription = obj.MRCIDLongDescription
                s bobj.MRCIDMetastaticSite = obj.MRCIDMetastaticSite  
                s bobj.MRCIDInjuryPoisoningCode = obj.MRCIDInjuryPoisoningCode    
                s bobj.MRCIDBillFlag3 = obj.MRCIDBillFlag3  
                s bobj.MRCIDBillFlag1 = obj.MRCIDBillFlag1   
                if $IsObject(obj.MRCIDTypeDR){
                    s bobj.MRCIDTypeDR = obj.MRCIDTypeDR.%Id() 
                }
                s bobj.MRCIDClinicType = obj.MRCIDClinicType
                s bobj.MRCIDNationalDesc = obj.MRCIDNationalDesc
                
                s bobj.MRCIDNationalCode=obj.MRCIDNationalCode  //国家标准编码
                s bobj.MRCIDInsuCode=obj.MRCIDInsuCode   //国家医保编码   
                s bobj.MRCIDInsuDesc=obj.MRCIDInsuDesc   //国家医保名称
                s bobj.MRCIDAgeFromType=obj.MRCIDAgeFromType
                s bobj.MRCIDAgeToType=obj.MRCIDAgeToType
                s bobj.MRCIDGrayCodeFlag = obj.MRCIDGrayCodeFlag   
                if $IsObject(obj.MRCIDVersionDictDR)
                {
                    s bobj.MRCIDVersionDictDR = obj.MRCIDVersionDictDR.%Id() 
                }
                s bobj.MRCIDDiagnosticType=obj.MRCIDDiagnosticType	//诊断类型
                s bobj.MRCIDRareDiseaseFlag=obj.MRCIDRareDiseaseFlag	//罕见病标志
                
            } 
                                        
            s obj.MRCIDCode = eobj.MRCIDCode
            s obj.MRCIDDesc = eobj.MRCIDDesc  
            s obj.MRCIDICD9CMCode = eobj.MRCIDICD9CMCode   //ICD10代码
            s obj.MRCIDDateActiveFrom = eobj.MRCIDDateActiveFrom
            s obj.MRCIDDateActiveTo = eobj.MRCIDDateActiveTo
            s obj.MRCIDAgeFrom = eobj.MRCIDAgeFrom
            s obj.MRCIDAgeTo = eobj.MRCIDAgeTo
            d obj.MRCIDSexDRSetObjectId(eobj.MRCIDSexDR)
            s obj.MRCIDValid =eobj.MRCIDValid
            s obj.MRCID2ndCodeInPair = eobj.MRCID2ndCodeInPair  //副编码
            s obj.MRCIDICD9Map = eobj.MRCIDICD9Map
            s obj.MRCIDLongDescription = eobj.MRCIDLongDescription  //注释
            s obj.MRCIDMetastaticSite = eobj.MRCIDMetastaticSite   //肿瘤形态学编码标志
            s obj.MRCIDInjuryPoisoningCode = eobj.MRCIDInjuryPoisoningCode   //损伤中毒外部原因标志
            s obj.MRCIDBillFlag1 = eobj.MRCIDBillFlag1    //中医证型标志
            s obj.MRCIDBillFlag3 = eobj.MRCIDBillFlag3    //中医诊断标志
            d obj.MRCIDTypeDRSetObjectId(eobj.MRCIDTypeDR)  //ICD诊断分类 2019-04-19 
            s obj.MRCIDClinicType = eobj.MRCIDClinicType //就诊类型 2020-01-14
            s obj.MRCIDNationalDesc = eobj.MRCIDNationalDesc //国家标准名称
            s obj.MRCIDNationalCode=eobj.MRCIDNationalCode  //国家标准编码
            //s obj.MRCIDInsuCode=eobj.MRCIDInsuCode   //国家医保编码 
            //s obj.MRCIDInsuDesc=eobj.MRCIDInsuDesc   //国家医保名称
            s Config=##class(web.DHCBL.BDP.INSUConfig).GetConfigByHospId(eobj.LinkHospId,"MRC_ICDDx")
            if Config="INSU"
            {
                
            }
            else
            {
                s obj.MRCIDInsuCode = eobj.MRCIDInsuCode
                s obj.MRCIDInsuDesc = eobj.MRCIDInsuDesc
            }
            s obj.MRCIDAgeFromType=eobj.MRCIDAgeFromType
            s obj.MRCIDAgeToType=eobj.MRCIDAgeToType
            s obj.MRCIDGrayCodeFlag = eobj.MRCIDGrayCodeFlag // 医保灰码
            d obj.MRCIDVersionDictDRSetObjectId(eobj.MRCIDVersionDictDR) //版本号
            s obj.MRCIDDiagnosticType=eobj.MRCIDDiagnosticType
            s obj.MRCIDRareDiseaseFlag=eobj.MRCIDRareDiseaseFlag
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"         //返回RowId
                //保存日志
                d:eobj.MRCIDRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_ICDDx","User.MRCICDDx","ICD诊断代码",id,eobj.MRCIDDesc,"A",eobj)
                d:eobj.MRCIDRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_ICDDx","User.MRCICDDx","ICD诊断代码",eobj.MRCIDRowId,eobj.MRCIDDesc,"U",eobj,bobj)
                
                ///同步数据给医学知识库-数据处理工厂 2021-04-19
                s SyncFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPSyncStructedICDData")  
                if (SyncFlag="Y")
                {
                    d ##class(web.DHCBL.CT.MRCICDDx).HisICDSyncToDataFactory(id)
                }
                if (eobj.MRCIDRowId'="")
                {
                    ////描述修改后自动添加新的别名
                    IF (eobj.MRCIDDesc'=bobj.MRCIDDesc)
                    {
                        s aliaseobj = ##class(web.Entity.CT.MRCICDAlias).%New()
                        s aliaseobj.ALIASRowId=""
                        s aliaseobj.ALIASText=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.MRCIDDesc)
                        s aliaseobj.ALIASParRef=id
                        s aliasret=##class(web.DHCBL.CT.MRCICDAlias).SaveEntity(aliaseobj)
                    }
                }
            
                if (eobj.DataAlias'="")&&(eobj.MRCIDRowId="")
                {
                    s length=$l(eobj.DataAlias,"&")
                    for aliasi=1:1:length
                    {
                        s alias=$p(eobj.DataAlias,"&",aliasi)
                        continue:alias=""
                        s aliaseobj = ##class(web.Entity.CT.MRCICDAlias).%New()
                        s aliaseobj.ALIASRowId=""
                        s aliaseobj.ALIASText=alias
                        s aliaseobj.ALIASParRef=id
                        s aliasret=##class(web.DHCBL.CT.MRCICDAlias).SaveEntity(aliaseobj)
                    }
                }
                //版本号不为空时判断是否要同步给病案 2022-12-29
                if (eobj.MRCIDVersionDictDR'="")
                {
	                s IsSyncToMr=$lg($g(^CT.BDP.CT.BDVersionDictD(eobj.MRCIDVersionDictDR)),7)
	                if (IsSyncToMr="Y")
	                {
		                ///调用病案同步接口 2023-02-02
		                s retMsg= ##class(web.DHCBL.CT.MRCICDDx).SendMsgToEMR(id)
		                if $p(retMsg,"^",1)'=1
		                {
			                 s result= "{success:'false',errorinfo:'"_$p(retMsg,"^",2)_"'}"  
		                }
	                }
                } 
            }
            else
            {
                Trollback
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("ICD诊断代码","web.DHCBL.CT.MRCICDDx","SaveEntity",eobj)
                s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
                s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
            }
        }       
    }
    else
    {
        s result= "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
}

/// Function:通过ID 查找诊断明细
/// Creator:陈莹
/// CreateDate: 2019-12-17
/// Debug: w ##class(web.DHCBL.CT.MRCICDDx).GetItmByRowID("13367","2")
ClassMethod GetItmByRowID(id As %String, hospid As %String = "", MRCIDInsuCode As %String = "", MRCIDInsuDesc As %String = "") As %String
{
    n (id,hospid,MRCIDInsuCode,MRCIDInsuDesc)
    q:id="" ""
    s MRCIDRowId=id
    s MRCIDCode=$p($g(^MRC("ID",MRCIDRowId)),"^",1)
    s MRCIDDesc=$p($g(^MRC("ID",MRCIDRowId)),"^",2)
    
    s MRCIDICD9CMCode=$p($g(^MRC("ID",MRCIDRowId)),"^",4)            ///ICD10
    s MRCIDDateActiveFrom=$p($g(^MRC("ID",MRCIDRowId)),"^",6)
    s MRCIDDateActiveTo=$p($g(^MRC("ID",MRCIDRowId)),"^",7)
    s MRCIDAgeFrom=$p($g(^MRC("ID",MRCIDRowId)),"^",8)
    s MRCIDAgeTo=$p($g(^MRC("ID",MRCIDRowId)),"^",9)
    s MRCIDSexDR=$p($g(^MRC("ID",MRCIDRowId)),"^",10)
    s:MRCIDSexDR'="" MRCIDSexDR=$p($g(^CT("SEX",MRCIDSexDR)),"^",2) //获取性别描述
    s MRCIDValid=$p($g(^MRC("ID",MRCIDRowId)),"^",27) //有效
    s:MRCIDValid="" MRCIDValid="Y"
    s MRCIDICD9Map=$p($g(^MRC("ID",MRCIDRowId)),"^",35)   //ICD9代码
    s MRCIDNationalDesc=$p($g(^MRC("ID",MRCIDRowId)),"^",49)    //国家标准名称
    s MRCID2ndCodeInPair=$p($g(^MRC("ID",MRCIDRowId)),"^",43)      ///副编码
    
    s MRCIDLongDescription=$p($g(^MRC("ID",MRCIDRowId)),"^",36)
    s MRCIDMetastaticSite=$p($g(^MRC("ID",MRCIDRowId)),"^",40) //肿瘤形态学编码标志
    s MRCIDInjuryPoisoningCode=$p($g(^MRC("ID",MRCIDRowId)),"^",41) //损伤中毒外部原因标志
    s MRCIDBillFlag1=$p($g(^MRC("ID",MRCIDRowId)),"^",13) //中医证型标志
    s MRCIDBillFlag3=$p($g(^MRC("ID",MRCIDRowId)),"^",15) //中医诊断标志
    Set MRCIDDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MRCIDDateActiveFrom)  //转换日期格式
    Set MRCIDDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MRCIDDateActiveTo)  //转换日期格式
    
    s MRCIDCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(MRCIDCode)
    s MRCIDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(MRCIDDesc)
    s MRCIDICD9CMCode =##class(web.DHCBL.BDP.FunLib).EvalJSON(MRCIDICD9CMCode)
    s MRCIDICD9Map=##class(web.DHCBL.BDP.FunLib).EvalJSON(MRCIDICD9Map)
    s MRCIDLongDescription =##class(web.DHCBL.BDP.FunLib).EvalJSON(MRCIDLongDescription)
    
    s MRCIDTypeDR=$p($g(^MRC("ID",MRCIDRowId)),"^",46) //ICD诊断分类  2019-04-19
    s:MRCIDTypeDR'="" MRCIDTypeDR=$p($g(^MRC("ICDTYPE",MRCIDTypeDR)),"^",2)
    //就诊类型 (门诊,急诊,住院,体检,新生儿) 20200113
    s MRCIDClinicType=$p($g(^MRC("ID",MRCIDRowId)),"^",47)
    s MRCIDNationalCode=$p($g(^MRC("ID",MRCIDRowId)),"^",50)   //国家标准编码
    //s MRCIDInsuCode=$p($g(^MRC("ID",MRCIDRowId)),"^",51)   //国家医保编码   
    //s MRCIDInsuDesc=$p($g(^MRC("ID",MRCIDRowId)),"^",52)   //国家医保名称
    //s InsuInfo=##class(web.DHCBL.CT.MRCICDDx).GetStdInsuInfo(id,hospid)
    //s MRCIDInsuCode=$p(InsuInfo,"^",1)  //国家医保编码  2022-04-11
    //s MRCIDInsuDesc=$p(InsuInfo,"^",2)  //国家医保名称
    s MRCIDAgeFromType=$p($g(^MRC("ID",MRCIDRowId)),"^",53)
    s MRCIDAgeFromType=$case(MRCIDAgeFromType,"Y":"岁","M":"月","D":"日",:"")
    s MRCIDAgeToType=$p($g(^MRC("ID",MRCIDRowId)),"^",54)
    s MRCIDAgeToType=$case(MRCIDAgeToType,"Y":"岁","M":"月","D":"日",:"")
    s MRCIDGrayCodeFlag=$p($g(^MRC("ID",MRCIDRowId)),"^",55) //医保灰码    
    s:MRCIDGrayCodeFlag="" MRCIDGrayCodeFlag="N"   
    s MRCIDVersionDictDR=$p($g(^MRC("ID",MRCIDRowId)),"^",56) //版本号 
    s:MRCIDVersionDictDR'="" MRCIDVersionDictDR=$lg($g(^CT.BDP.CT.BDVersionDictD(MRCIDVersionDictDR)),4)
    s MRCIDDiagnosticType=$p($g(^MRC("ID",MRCIDRowId)),"^",57) //诊断类型
    s MRCIDDiagnosticType=$case(MRCIDDiagnosticType,"TCM":"中医","WM":"西医","ST":"证型",:"")
    s MRCIDClinicType=##class(web.DHCBL.CT.PHCFreq).GetClinicType(MRCIDClinicType)
    s MRCIDRareDiseaseFlag=$p($g(^MRC("ID",MRCIDRowId)),"^",58) //罕见病标志
    s:MRCIDRareDiseaseFlag="" MRCIDRareDiseaseFlag="N"
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("MRC_ICDDx",MRCIDRowId)
    s BDPInternalCode =$p($g(resultStr),"^",1)
    s BDPInternalDesc = $p($g(resultStr),"^",2)
    s BDPHospNationalCode=$p($g(resultStr),"^",3)  
    s BDPHospNationalDesc = $p($g(resultStr),"^",4)
    
    s strResult=  "{""MRCIDRowId"":"""_MRCIDRowId_""",""MRCIDCode"":"""_MRCIDCode_""",""MRCIDDesc"":"""_MRCIDDesc_""",""MRCIDICD9CMCode"":"""_MRCIDICD9CMCode_""",""MRCIDDateActiveFrom"":"""_MRCIDDateActiveFrom_""",""MRCIDDateActiveTo"":"""_MRCIDDateActiveTo_""",""MRCIDAgeFrom"":"""_MRCIDAgeFrom_""",""MRCIDAgeTo"":"""_MRCIDAgeTo_""",""MRCIDTypeDR"":"""_MRCIDTypeDR_""",""MRCIDVersionDictDR"":"""_MRCIDVersionDictDR_""",""MRCIDSexDR"":"""_MRCIDSexDR_""",""MRCIDValid"":"""_MRCIDValid_""",""MRCIDICD9Map"":"""_MRCIDICD9Map_""",""MRCID2ndCodeInPair"":"""_MRCID2ndCodeInPair_""",""MRCIDLongDescription"":"""_MRCIDLongDescription_""",""MRCIDMetastaticSite"":"""_MRCIDMetastaticSite_""",""MRCIDInjuryPoisoningCode"":"""_MRCIDInjuryPoisoningCode_""",""MRCIDBillFlag1"":"""_MRCIDBillFlag1_""",""MRCIDBillFlag3"":"""_MRCIDBillFlag3_""",""MRCIDClinicType"":"""_MRCIDClinicType_""",""MRCIDGrayCodeFlag"":"""_MRCIDGrayCodeFlag_""",""MRCIDDiagnosticType"":"""_MRCIDDiagnosticType_""",""MRCIDNationalDesc"":"""_MRCIDNationalDesc_""",""MRCIDNationalCode"":"""_MRCIDNationalCode_""",""MRCIDInsuCode"":"""_MRCIDInsuCode_""",""MRCIDInsuDesc"":"""_MRCIDInsuDesc_""",""BDPInternalCode"":"""_BDPInternalCode_""",""BDPInternalDesc"":"""_BDPInternalDesc_""",""BDPHospNationalCode"":"""_BDPHospNationalCode_""",""BDPHospNationalDesc"":"""_BDPHospNationalDesc_""",""MRCIDAgeFromType"":"""_MRCIDAgeFromType_""",""MRCIDAgeToType"":"""_MRCIDAgeToType_""",""MRCIDRareDiseaseFlag"":"""_MRCIDRareDiseaseFlag_"""}"
    q strResult
}

/// Creator：chenying
/// CreatDate: 2016-3-1 
/// Description：查询ICD诊断代码的内容  真分页
/// Table：User.MRCICDDx
/// Input：rowid,code,desc
/// w ##class(web.DHCBL.CT.MRCICDDx).GetList("","","","","0","20",1,20,"Y","")
ClassMethod GetList(rowid As %String, code As %String, desc As %String, icd10 As %String, start As %String, limit As %String, page As %String, rows As %String, activeflag As %String, hospid As %String, type As %String, insucode As %String, insucodeflag As %String, versiondr As %String) As %String
{
    s RetFlag=""
    if (page'="")&&(rows'="")  //HISUI
    {
        s limit=page*rows  //结束行
        s start=((page-1)*rows) //开始行
        s RetFlag="JSON"
    }
    if start="" s start=0
    if limit="" s limit=20
    if (rowid'="") //根据rowid返回该条记录
    {
        IF RetFlag="" w "{""data"":["
        IF RetFlag="JSON" w "{""rows"":["
        s InsuInfo=##class(web.DHCBL.CT.MRCICDDx).GetStdInsuInfo(rowid,hospid)
        s MRCIDInsuCode=$p(InsuInfo,"^",1)  //国家医保编码  2022-04-11
        s MRCIDInsuDesc=$p(InsuInfo,"^",2)  //国家医保名称
        w ##class(web.DHCBL.CT.MRCICDDx).GetItmByRowID(rowid,hospid,MRCIDInsuCode,MRCIDInsuDesc)
        IF RetFlag="" w "],""total"":""1"",""success"":""true""}"
        IF RetFlag="JSON" w "],""total"":""1""}"
    }
    else
    {
        s:code'="" code=$ZCVT(code,"U") //转换成大写
        s:desc'="" desc=$ZCVT(desc,"U") //转换成大写
        s:icd10'="" icd10=$ZCONVERT(icd10,"U") //转换成大写
        s LookUpMode=##class(web.DHCBL.BDP.BDPAlias).GetConfig("MRC_ICDDx")
        //获取授权
        s AuStr=##class(web.DHCBL.Authorize.MRCICDDx).DHCGetDataByDefaultSession()
        if ($l(AuStr,"#")=1) {
            s Limited=0
            s AutBit=""
        }
        elseif ($l(AuStr,"#")=2) {
            s Limited=$p(AuStr,"#",1)
            s AutBit=$p(AuStr,"#",2)
        }
        s AuFlag=0
        if (AuStr="")||((AuStr'="")&(Limited=0)) s AuFlag=1 //判断是否有授权,如果没有则全部显示
        s MRCIDSexDRAuStr=##class(web.DHCBL.Authorize.CTSex).DHCGetDataByDefaultSession()
        s MRCIDSexDRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (MRCIDSexDRAuStr="")||(MRCIDSexDRAuStr["limited:0") s MRCIDSexDRAuFlag=1 
        
        s total=0
        s start=start+1  ////start=6700  从6701条开始
        s CurrentCount=0
        IF RetFlag="" w "{""data"":["
        IF RetFlag="JSON" w "{""rows"":["
        s MRCIDRowId=0
        for
        {
            s MRCIDRowId=$o(^MRC("ID",MRCIDRowId)) q:MRCIDRowId=""
            s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,MRCIDRowId,hospid)
            continue:showflag="N"
            s MRCIDSexDR=$p($g(^MRC("ID",MRCIDRowId)),"^",10)
            s MRCIDSexDRstrRowId="{ID:"_MRCIDSexDR_"}"
            //筛选授权后的数据
            if (($bit(AutBit,MRCIDRowId)=1)||(AuFlag=1))&&((MRCIDSexDRAuStr[MRCIDSexDRstrRowId)||(MRCIDSexDRAuFlag=1))
            {
                s MRCIDCode=$p($g(^MRC("ID",MRCIDRowId)),"^",1) //诊断代码
                s MRCIDDesc=$p($g(^MRC("ID",MRCIDRowId)),"^",2)   //诊断描述      
                continue:(MRCIDCode="-")||(MRCIDDesc="-") //屏蔽垃圾数据
                s MRCIDICD9CMCode=$p($g(^MRC("ID",MRCIDRowId)),"^",4)    ///ICD10
                continue:($zcvt(MRCIDCode,"U")'[code)
                continue:($ZCVT(MRCIDICD9CMCode,"U")'[icd10)
                s MRCIDValid=$p($g(^MRC("ID",MRCIDRowId)),"^",27)  //有效
                s:MRCIDValid="" MRCIDValid="Y"
                s MRCIDDateActiveTo=$p($g(^MRC("ID",MRCIDRowId)),"^",7)  //结束日期
            
                //根据有效/无效过滤数据  
                if (activeflag="Y")
                {
                    //结束日期为空，或者结束日期在今天之后，且有效标志为Y的数据为有效数据
                    if '(((MRCIDDateActiveTo="")||((MRCIDDateActiveTo'="")&&(MRCIDDateActiveTo>=+$h)))&&(MRCIDValid="Y")) continue  
                }
                if (activeflag="N")
                {
                    //结束日期不为空且结束日期在今天之前，或者有效标志为N的数据为无效数据
                    if '(((MRCIDDateActiveTo'="")&&(MRCIDDateActiveTo<+$h))||(MRCIDValid="N")) continue
                }
                s MRCIDVersionDictDR=$p($g(^MRC("ID",MRCIDRowId)),"^",56)  //版本号
                continue:(versiondr'="")&&(MRCIDVersionDictDR'=versiondr)
                
                if type'=""
                {
                    s MRCIDMetastaticSite=$p($g(^MRC("ID",MRCIDRowId)),"^",40) //肿瘤形态学编码标志
                    s MRCIDInjuryPoisoningCode=$p($g(^MRC("ID",MRCIDRowId)),"^",41) //损伤中毒外部原因标志
                    s MRCIDBillFlag1=$p($g(^MRC("ID",MRCIDRowId)),"^",13) //中医证型标志
                    s MRCIDBillFlag3=$p($g(^MRC("ID",MRCIDRowId)),"^",15) //中医诊断标志
                    
                    if type="XYZD"  //西医诊断
                    {
                        continue:MRCIDBillFlag3="Y"
                    }
                    if type="ZYZD"  //中医诊断
                    {
                        continue:MRCIDBillFlag3'="Y"  //过滤掉西医诊断
                        continue:MRCIDBillFlag1="Y"  //过滤掉中医证型
                    }
                    if type="ZYZX"  //中医症型
                    {
                        continue:MRCIDBillFlag1'="Y"
                    }
                    if type="ZLBM"  //肿瘤形态学编码
                    {
                        continue:MRCIDMetastaticSite'="Y"
                    }
                    if type="SSZD"  //损伤中毒外部原因
                    {
                        continue:MRCIDInjuryPoisoningCode'="Y"
                    }
                    
                    
                }
                
                // 根据国家医保编码查询过滤数据
                s GettingFlag=0
                if ((insucode'="")||(insucodeflag'=""))
                {
                    s GettingFlag=1
                    s InsuInfo=##class(web.DHCBL.CT.MRCICDDx).GetStdInsuInfo(MRCIDRowId,hospid)
                    s MRCIDInsuCode=$p(InsuInfo,"^",1)  //国家医保编码
                    s MRCIDInsuDesc=$p(InsuInfo,"^",2)  //国家医保名称
                    if (MRCIDInsuCode'=-1)
                    {
                        continue:($ZCONVERT(MRCIDInsuCode,"U")'[$ZCONVERT(insucode,"U"))
                        continue:(insucodeflag="Y")&&(MRCIDInsuCode="")
                        continue:(insucodeflag="N")&&(MRCIDInsuCode'="")
                    }
                }
                i ($zcvt(MRCIDCode,"U")[code)&&($ZCVT(MRCIDICD9CMCode,"U")[icd10)
                {
                    if desc'=""
                    {
                        s AliasFlag=0
                        s ALIASText1=""
                        s ALIASChildsub=0
                        for
                        {
                            s ALIASChildsub=$o(^MRC("ID",MRCIDRowId,"ALIAS",ALIASChildsub))
                            q:ALIASChildsub=""
                            s ALIASText=$g(^MRC("ID",MRCIDRowId,"ALIAS",ALIASChildsub))
                            s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                        }
                        s Flag1=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,MRCIDDesc,desc)
                        //s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MRCIDDesc)
                        s Flag2="" //##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,PINYIN,desc)
                        s Flag3=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,ALIASText1,desc)
                        if (Flag1=1)||(Flag2=1)||(Flag3=1) s AliasFlag=1
                        
                        /*
                        //安贞医院  如果desc带空格 则模糊查询 
                        
                        ///ofy2 安贞医院  检索时 如果描述包含空格 支持模糊查询 即“查询条件”加空格加“查询条件”，比如支持 风湿空格瓣膜，可以查出“风湿性心内瓣膜炎”
                    
                        s length=$l(desc," ")
                        s icount=0
                        s AFlag=1
                        for 
                        {
                            s icount=icount+1  q:(icount>length)||(AFlag=0)
                            s desci=$p(desc," ",icount)
                            if ($zcvt(MRCIDDesc,"U")[desci) s descFlag=1
                            else  s descFlag=0
                    
                            if (ALIASText1[desci) s textFlag=1
                            else  s textFlag=0
                            if (textFlag=1)||(descFlag=1) s AFlag=1
                            else  s AFlag=0
                        }
                        s AliasFlag=AFlag
                        
                        */
                    }
                    else
                    {
                        s AliasFlag=1
                    }
                    
                    if (AliasFlag'=1) continue
                    s total=total+1
                    if (total<start) continue
                    if ((total<(start+limit)))
                    {
                        s CurrentCount=CurrentCount+1
                        if (CurrentCount>1) 
                        {
                            w ","
                        }               
                        if (GettingFlag=0)
                        {
                            s InsuInfo=##class(web.DHCBL.CT.MRCICDDx).GetStdInsuInfo(MRCIDRowId,hospid)
                            s MRCIDInsuCode=$p(InsuInfo,"^",1)  //国家医保编码
                            s MRCIDInsuDesc=$p(InsuInfo,"^",2)  //国家医保名称
                        }
                        w ##class(web.DHCBL.CT.MRCICDDx).GetItmByRowID(MRCIDRowId,hospid,MRCIDInsuCode,MRCIDInsuDesc)
                    }
                
                }
            }
        }
        IF RetFlag="" w "],""total"":"""_total_""",""success"":""true""}"
        IF RetFlag="JSON" w "],""total"":"""_total_"""}"
    }
    q ""
}

/// Creator：chenying
/// CreatDate: 2017-06-14
/// Description：查询ICD诊断代码的内容  真分页  下拉框调用
/// Table：User.MRCICDDx
/// Input：rowid,code,desc
/// Return: MRCIDRowId,MRCIDCode,MRCIDDesc
/// w ##class(web.DHCBL.CT.MRCICDDx).GetDataForCmbM("","","","0","10")
ClassMethod GetDataForCmbM(rowid As %String, code As %String, desc As %String, start As %String, limit As %String, hospid As %String = "") As %String
{
    if start="" s start=0
    if limit="" s limit=10
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s MRCIDRowId=rowid
        s MRCIDCode=$p($g(^MRC("ID",MRCIDRowId)),"^",1)
        s MRCIDDesc=$p($g(^MRC("ID",MRCIDRowId)),"^",2)
        s MRCIDCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(MRCIDCode)
        s MRCIDDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(MRCIDDesc)
        s MRCIDICD9CMCode=$p($g(^MRC("ID",MRCIDRowId)),"^",4)
        w "{""data"":["
        w "{""MRCIDRowId"":"""_MRCIDRowId_""",""MRCIDCode"":"""_MRCIDCode_""",""MRCIDDesc"":"""_MRCIDDesc_""",""MRCIDICD9CMCode"":"""_MRCIDICD9CMCode_"""}"
        w "],""total"":""1"",""success"":""true""}"
    }
    else
    {
        s:code'="" code=$ZCVT(code,"U") //转换成大写
        s:desc'="" desc=$ZCVT(desc,"U") //转换成大写
        s LookUpMode=##class(web.DHCBL.BDP.BDPAlias).GetConfig("MRC_ICDDx")
        //获取授权
        s AuStr=##class(web.DHCBL.Authorize.MRCICDDx).DHCGetDataByDefaultSession()
        if ($l(AuStr,"#")=1) {
            s Limited=0
            s AutBit=""
        }
        elseif ($l(AuStr,"#")=2) {
            s Limited=$p(AuStr,"#",1)
            s AutBit=$p(AuStr,"#",2)
        }
        s AuFlag=0
        if (AuStr="")||((AuStr'="")&(Limited=0)) s AuFlag=1 //判断是否有授权,如果没有则全部显示
        s MRCIDSexDRAuStr=##class(web.DHCBL.Authorize.CTSex).DHCGetDataByDefaultSession()
        s MRCIDSexDRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (MRCIDSexDRAuStr="")||(MRCIDSexDRAuStr["limited:0") s MRCIDSexDRAuFlag=1 
        
        s count2=0
        s start=start+1  ////start=6700  从6701条开始
        
        s CurrentCount=0
        w "{""data"":["
        
        s MRCIDRowId=0
        for
        {
            s MRCIDRowId=$o(^MRC("ID",MRCIDRowId)) q:MRCIDRowId=""
            if hospid'=""
            {
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,MRCIDRowId,hospid)
                continue:showflag="N"
            }
            s MRCIDSexDR=$p($g(^MRC("ID",MRCIDRowId)),"^",10)
            s MRCIDSexDRstrRowId="{ID:"_MRCIDSexDR_"}"
            //筛选授权后的数据
            if (($bit(AutBit,MRCIDRowId)=1)||(AuFlag=1))&&((MRCIDSexDRAuStr[MRCIDSexDRstrRowId)||(MRCIDSexDRAuFlag=1))
            {   
                s MRCIDCode=$p($g(^MRC("ID",MRCIDRowId)),"^",1)    //代码
                s MRCIDDesc=$p($g(^MRC("ID",MRCIDRowId)),"^",2)    //描述
                s MRCIDCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(MRCIDCode)
                s MRCIDDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(MRCIDDesc)
                continue:(MRCIDCode="-")||(MRCIDDesc="-") //屏蔽垃圾数据
                
                s MRCIDValid=$p($g(^MRC("ID",MRCIDRowId)),"^",27)
                s:MRCIDValid="" MRCIDValid="Y"
                continue:MRCIDValid="N" 
                s MRCIDDateActiveFrom=$p($g(^MRC("ID",MRCIDRowId)),"^",6)
                continue:(MRCIDDateActiveFrom'="")&&(MRCIDDateActiveFrom>+$h)
                s MRCIDDateActiveTo=$p($g(^MRC("ID",MRCIDRowId)),"^",7)
                continue:(MRCIDDateActiveTo'="")&&(MRCIDDateActiveTo<+$h)       
                s MRCIDICD9CMCode=$p($g(^MRC("ID",MRCIDRowId)),"^",4)   //ICD10
                
                i ($zcvt(MRCIDCode,"U")[code)
                {
                    if desc'=""
                    {
                        s AliasFlag=0
                        s ALIASText1=""
                        s ALIASChildsub=0
                        for
                        {
                            s ALIASChildsub=$o(^MRC("ID",MRCIDRowId,"ALIAS",ALIASChildsub))
                            q:ALIASChildsub=""
                            s ALIASText=$g(^MRC("ID",MRCIDRowId,"ALIAS",ALIASChildsub))
                            s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                        }
                        s Flag1=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,MRCIDDesc,desc)
                        s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MRCIDDesc)
                        s Flag2=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,PINYIN,desc)
                        s Flag3=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,ALIASText1,desc)
                        if (Flag1=1)||(Flag2=1)||(Flag3=1) s AliasFlag=1
                    }
                    else
                    {
                        s AliasFlag=1
                    }
                    
                    if (AliasFlag'=1) continue
                    
                    s count2=count2+1
                    if (count2<start) continue
                    if ((count2<(start+limit)))
                    {
                        
                        
                        if (CurrentCount=0) 
                        {
                            s CurrentCount=1
                        }
                        else
                        {  
                            s CurrentCount=CurrentCount+1
                            w ","
                        }
                                        
                                        
                        w "{""MRCIDRowId"":"""_MRCIDRowId_""",""MRCIDCode"":"""_MRCIDCode_""",""MRCIDDesc"":"""_MRCIDDesc_""",""MRCIDICD9CMCode"":"""_MRCIDICD9CMCode_"""}"
                        
                    }
                
                }
            }
        }
        w "],""total"":"""_count2_""",""success"":""true""}"
        
    }
    q ""
}

/// Creator：chenying
/// CreatDate: 2015-3-27
/// Description：用于combox查询
/// Table：User.MRCICDDx
/// Input：rowid,code,desc
/// Return：MRCIDRowId,MRCIDCode,MRCIDDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.MRCICDDx","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, icd10 As %String, hospid As %String) As %Query(ROWSPEC = "MRCIDRowId:%String,MRCIDCode:%String,MRCIDDesc:%String,MRCIDICD9CMCode:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, icd10 As %String, hospid As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s MRCIDRowId=rowid
        s MRCIDCode=$p($g(^MRC("ID",MRCIDRowId)),"^",1)
        s MRCIDDesc=$p($g(^MRC("ID",MRCIDRowId)),"^",2)
        //s MRCIDCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(MRCIDCode)
        //s MRCIDDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(MRCIDDesc)
        s MRCIDICD9CMCode=$p($g(^MRC("ID",MRCIDRowId)),"^",4)
        d OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCVT(code,"U") //转换成大写
        s:desc'="" desc=$ZCVT(desc,"U") //转换成大写
        s:icd10'="" icd10=$ZCVT(icd10,"U")
        s LookUpMode=##class(web.DHCBL.BDP.BDPAlias).GetConfig("MRC_ICDDx")
        //获取授权
        s AuStr=##class(web.DHCBL.Authorize.MRCICDDx).DHCGetDataByDefaultSession()
        if ($l(AuStr,"#")=1) {
            s Limited=0
            s AutBit=""
        }
        elseif ($l(AuStr,"#")=2) {
            s Limited=$p(AuStr,"#",1)
            s AutBit=$p(AuStr,"#",2)
        }
        s AuFlag=0
        if (AuStr="")||((AuStr'="")&(Limited=0)) s AuFlag=1 //判断是否有授权,如果没有则全部显示
        s MRCIDSexDRAuStr=##class(web.DHCBL.Authorize.CTSex).DHCGetDataByDefaultSession()
        s MRCIDSexDRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (MRCIDSexDRAuStr="")||(MRCIDSexDRAuStr["limited:0") s MRCIDSexDRAuFlag=1 
        
        s MRCIDRowId=0
        for
        {
            s MRCIDRowId=$o(^MRC("ID",MRCIDRowId)) q:MRCIDRowId=""
            if hospid'=""
            {
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,MRCIDRowId,hospid)
                continue:showflag="N"
            }
            s MRCIDSexDR=$p($g(^MRC("ID",MRCIDRowId)),"^",10)
            s MRCIDSexDRstrRowId="{ID:"_MRCIDSexDR_"}"
            //筛选授权后的数据
            if (($bit(AutBit,MRCIDRowId)=1)||(AuFlag=1))&&((MRCIDSexDRAuStr[MRCIDSexDRstrRowId)||(MRCIDSexDRAuFlag=1))
            {
                s MRCIDCode=$p($g(^MRC("ID",MRCIDRowId)),"^",1)
                s MRCIDDesc=$p($g(^MRC("ID",MRCIDRowId)),"^",2)
                //s MRCIDCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(MRCIDCode)
                //s MRCIDDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(MRCIDDesc)
                continue:(MRCIDCode="-")||(MRCIDDesc="-") //屏蔽垃圾数据
                s MRCIDValid=$p($g(^MRC("ID",MRCIDRowId)),"^",27)
                s:MRCIDValid="" MRCIDValid="Y"
                continue:MRCIDValid="N"
                s MRCIDDateActiveFrom=$p($g(^MRC("ID",MRCIDRowId)),"^",6)
                s MRCIDDateActiveTo=$p($g(^MRC("ID",MRCIDRowId)),"^",7)
                continue:(MRCIDDateActiveFrom'="")&&(MRCIDDateActiveFrom>+$h)
                continue:(MRCIDDateActiveTo'="")&&(MRCIDDateActiveTo<+$h)
                s MRCIDICD9CMCode=$p($g(^MRC("ID",MRCIDRowId)),"^",4)
                if desc'=""
                {
                    s AliasFlag=0
                    s ALIASText1=""
                    s ALIASChildsub=0
                    for
                    {
                        s ALIASChildsub=$o(^MRC("ID",MRCIDRowId,"ALIAS",ALIASChildsub))
                        q:ALIASChildsub=""
                        s ALIASText=$g(^MRC("ID",MRCIDRowId,"ALIAS",ALIASChildsub))
                        s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                    }
                    s Flag1=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,MRCIDDesc,desc)
                    s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MRCIDDesc)
                    s Flag2=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,PINYIN,desc)
                    s Flag3=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,ALIASText1,desc)
                    if (Flag1=1)||(Flag2=1)||(Flag3=1) s AliasFlag=1
                }
                else
                {
                    s AliasFlag=1
                }
                
                i ($ZCVT(MRCIDCode,"U")[code)&&(AliasFlag=1)&&($ZCVT(MRCIDICD9CMCode,"U")[icd10)
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(MRCIDRowId,MRCIDCode,MRCIDDesc,MRCIDICD9CMCode)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
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

/// Creator：chenying
/// CreatDate: 2012-12-27
/// Description：合并ICD诊断代码的内容
/// Table：User.MRCICDDx
/// Input：web.Entity.CT.MRCICDDx 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.MRCICDDx).SaveEntity()
ClassMethod MergeData(eobj As web.Entity.CT.MRCICDDx) As %String
{
    s result=""
    if $IsObject(eobj)
    {
        if (eobj.DelFormId="")
        {
            s result= "{success:'false',errorinfo:'合并删除项id不存在！'}"
        }
        else
        {
            Ts
            s flag=..HideICDData(eobj.DelFormId)
            if (flag=1)
            {
                ///add 20170703 中医诊断数据 只校验描述，不校验代码（代码会有重复）
                //if (eobj.MRCIDBillFlag3="Y")
                s flag=##class(web.DHCBL.CT.MRCICDDx).FormValidate(eobj.MRCIDRowId,eobj.MRCIDCode,eobj.MRCIDDesc)
                
                if (flag =1)
                {
                    Trollback
                    s result = "{success:'false',errorinfo:'该代码或描述已经存在，无法合并！'}"
                }
                else
                {
                
                    s str=..SaveEntity(eobj)
                    s ff=$p(str,"'",2)
                    s id=$p(str,"'",4)
                    if (ff="true")
                    {
                        Tc
                        s result = "{success:'true',id:'"_id_"'}"         //返回RowId
                    }
                    else
                    {
                        Trollback
                        s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
                    }
                }
                
            }
            else
            {
                Trollback
                s result= "{success:'false',errorinfo:'合并失败！'}"    //返回错误信息
            }
        }
    }
    else
    {
        s result= "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
}

/// Creator：蔡昊哲
/// CreatDate: 2012-1-16
/// Description：修改被合并的ICD诊断码置为无效,隐藏掉,不删除
/// Table：User.MRCICDDx
/// Input：要被合并的诊断rowid
/// Return：合并信息（0 失败 1成功） 
/// Other: w ##class(web.DHCBL.CT.MRCICDDx).HideICDData("1")
ClassMethod HideICDData(DelFormId) As %String
{
    s result=""
    s obj=##class(User.MRCICDDx).%OpenId(DelFormId)         
    Ts                              
    s obj.MRCIDValid = "N"
    
    s obj.MRCIDDateActiveTo =+$h  //被合并的数据置上结束日期
    s sc=obj.%Save()
    d obj.%Close()
    If $$$ISOK(sc)
    {
        Tc
        //s id = obj.%Id()
        s result = 1       //返回RowId
    }
    else
    {
        Trollback
        s result= 0    //返回错误信息
    }
    q result
}

/// Function:添加时，自动生成诊断代码，库里最大值+1（总共5位，00040，53300）
/// Creator:陈莹
/// FOR 兰大一院
/// CreateDate: 2016-12-23
/// input:  44f+1-->45,f44+1-->
/// Debug:w ##class(web.DHCBL.CT.MRCICDDx).AutoCreateCode()
ClassMethod AutoCreateCode() As %String
{
    n
    s MaxCode=""
    s ConfigType="MRCIDCONFIG"
    if $d(^Config.BDPSpeConfig(ConfigType))
    {
        s ConfigStr=$g(^Config.BDPSpeConfig(ConfigType))
        s AutoCode=$p($g(^Config.BDPSpeConfig(ConfigType)),"^",3)
        if AutoCode="true"
        {
            k ^TMPCODE(ConfigType)
            s OriginCode=$p($g(^Config.BDPSpeConfig(ConfigType)),"^",4)
            s TotalLength=$p($g(^Config.BDPSpeConfig(ConfigType)),"^",5)
            s olength=$l(OriginCode)
            if ((TotalLength-$l(OriginCode))<=0)
            {
                 s MaxCode="ERROR"
            }
            else
            {
            
                s Code1=""
                s Code=0
                for
                {
                    S Code=$o(^MRC("ID",0,"Code",Code)) q:Code=""
                    s id=0
                    for
                    {
                        S id=$o(^MRC("ID",0,"Code",Code,id)) q:id=""
                        s RCode=$p($g(^MRC("ID",id)),"^",1)
                        s RCode=##class(web.DHCBL.BDP.FunLib).Util(RCode)
                        if ($e(RCode,1,olength)=OriginCode)&&($l(RCode)=TotalLength)
                        {
                            s Code1=$e(RCode,olength+1,TotalLength)+1
                            S:Code1'="" ^TMPCODE(ConfigType,Code1)=RCode
                        }
                    }
                }
                s Code1=$o(^TMPCODE(ConfigType,""),-1)
                s Code1=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(Code1,TotalLength-$l(OriginCode)) 
                s MaxCode=OriginCode_Code1
                k ^TMPCODE(ConfigType)
            }
        }
    }
    q MaxCode
}

/// Creator:陈莹
/// CreatDate:2017-07-03
/// Description:获取页面的配置
/// w ##class(web.DHCBL.CT.MRCICDDx).GetConfigValue()
/// RetFlag=""时，用于EXT, =JSON时，用于HISUI，不输出 "{list:["_str_"]}",Y/N不需要转换true
ClassMethod GetConfigValue(RetFlag As %String = "") As %String
{
    s ConfigType="MRCIDCONFIG"
    s ValidCode=$p($g(^Config.BDPSpeConfig(ConfigType)),"^",1)         //校验代码是否重复，默认true
    if (ValidCode="") S ValidCode="true"
    s ValidDesc=$p($g(^Config.BDPSpeConfig(ConfigType)),"^",2)         //校验描述是否重复，默认true
    if (ValidDesc="") S ValidDesc="true"
    s AutoCode=$p($g(^Config.BDPSpeConfig(ConfigType)),"^",3)          //自动生成代码，默认false
    if (AutoCode="") S AutoCode="false"
    s CodeType=$p($g(^Config.BDPSpeConfig(ConfigType)),"^",4)          ///代码规则：字母开头 或者纯数字不填
    s TotalLength=$p($g(^Config.BDPSpeConfig(ConfigType)),"^",5)       ///自动生成总共多少位的代码
    s str="ValidCode:"""_ValidCode_""",ValidDesc:"""_ValidDesc_""",AutoCode:"""_AutoCode_""",OriginCode:"""_CodeType_""",TotalLength:"""_TotalLength_""""
    if RetFlag=""
    {
        s str = "{list:[{"_str_"}]}"
    }
    q str
}

/// Creator:陈莹
/// CreatDate:2017-07-03
/// Description:保存页面的配置
/// Input：校验代码是否重复^校验代码是否重复^自动生成代码^代码规则：字母开头 或者纯数字不填^自动生成总共多少位的代码
/// w ##class(web.DHCBL.CT.MRCICDDx).SaveConfigValue("true^true^false^^")
ClassMethod SaveConfigValue(ConfigStr) As %String
{
    n (ConfigStr)
    s ConfigType="MRCIDCONFIG"
    s ^Config.BDPSpeConfig(ConfigType)=ConfigStr
    q "{success:'true'}"
}

/// CreatDate: 2019-05-28
/// Creator:陈莹
/// Description:批量停止诊断方法
/// Input:enddate(结束日期），flag3(中医标志，Y为中医）,多院区项目使用hospid停用一个院区的诊断
/// w ##class(web.DHCBL.CT.MRCICDDx).EndAllICD("2021-06-02","","")  ///// 批量全停所有有效诊断
/// w ##class(web.DHCBL.CT.MRCICDDx).EndAllICD("2021-06-02","N","")  //停西医诊断
/// w ##class(web.DHCBL.CT.MRCICDDx).EndAllICD("2021-06-02","Y","")  //停中医诊断
ClassMethod EndAllICD(enddate, flag3 As %String = "", hospid As %String = "") As %String
{
    if enddate="" q "结束日期不能为空"
    ///同步数据给医学知识库-数据处理工厂 2021-04-19
    s SyncFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPSyncStructedICDData")  
    s enddate=$zdh(enddate,3)
    s count=0
    s id=0
    for
    {
        s id=$o(^MRC("ID",id)) q:id=""
        if hospid'=""
        {
            s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("MRC_ICDDx",id,hospid) //多院区判断医院
            continue:showflag="N"
        }
        s MRCIDDateActiveFrom=$p($g(^MRC("ID",id)),"^",6)
        s MRCIDDateActiveTo=$p($g(^MRC("ID",id)),"^",7)
        if flag3'="" //判断中医诊断还是西医诊断
        {
            s MRCIDBillFlag3=$p($g(^MRC("ID",id)),"^",15)  //中医诊断标志
            if MRCIDBillFlag3="" s MRCIDBillFlag3="N"
            if MRCIDBillFlag3'=flag3 continue
        }
        //开始日期在结束日期以后的数据不会停止，已经有结束日期的数据不会更新
        if (MRCIDDateActiveTo="")&&(MRCIDDateActiveFrom'="")&&(MRCIDDateActiveFrom<enddate)
        {
            
            s obj=##class(User.MRCICDDx).%OpenId(id)
            s obj.MRCIDDateActiveTo=enddate
            Ts
            s sc=obj.%Save()
            do obj.%Close()
            if $$$ISOK(sc){
                Tcommit
                s count=count+1
                ///同步数据给医学知识库-数据处理工厂 2021-04-19
                if (SyncFlag="Y")
                { 
                   d ##class(web.DHCBL.CT.MRCICDDx).HisICDSyncToDataFactory(id)
                }
                w id,!
            }else{
                Trollback
                w id_" "_$p($g(^MRC("ID",id)),"^",1)_" "_$p($g(^MRC("ID",id)),"^",2)_" "_$SYSTEM.Status.GetErrorText(sc),!
            }
        }   
        
    }
    q count
}

/// Creator：chenying
/// CreatDate: 2021-06-15
/// Description：调用数据处理工厂的接口，同步数据
/// Table：User.MRCICDDx
/// input: id(ICD诊断的rowid)
/// Ruturn：ret 
/// w ##class(web.DHCBL.CT.MRCICDDx).HisICDSyncToDataFactory(1)
ClassMethod HisICDSyncToDataFactory(id As %String) As %String
{
    n (id)
    s ret=""
    s eobj = ##class(web.Entity.CT.MRCICDDx).%New()
    s eobj.MRCIDRowId = id
    s eobj.MRCIDCode=$p($g(^MRC("ID",id)),"^",1)  //代码
    s eobj.MRCIDDesc=$p($g(^MRC("ID",id)),"^",2)   //名称
    s eobj.MRCIDICD9CMCode=$p($g(^MRC("ID",id)),"^",4)     ///ICD10
    s eobj.MRCIDDateActiveFrom=$p($g(^MRC("ID",id)),"^",6)  //开始日期
    s eobj.MRCIDDateActiveTo=$p($g(^MRC("ID",id)),"^",7)  //结束日期
    s eobj.MRCIDAgeFrom=$p($g(^MRC("ID",id)),"^",8)  //开始年龄
    s eobj.MRCIDValid=$p($g(^MRC("ID",id)),"^",27)    //有效标志
    s:eobj.MRCIDValid="" eobj.MRCIDValid="Y"   //有效标志空时默认为Y 
    s eobj.MRCIDAgeTo=$p($g(^MRC("ID",id)),"^",9)  //结束年龄
    s eobj.MRCIDSexDR=$p($g(^MRC("ID",id)),"^",10)  //性别DR
    s:eobj.MRCIDSexDR'="" eobj.MRCIDSexDR=$p($g(^CT("SEX",eobj.MRCIDSexDR)),"^",2) //性别描述
    s eobj.MRCIDICD9Map=$p($g(^MRC("ID",id)),"^",35)     //ICD9代码
    s eobj.MRCIDLongDescription=$p($g(^MRC("ID",id)),"^",36)   //注释
    s eobj.MRCIDMetastaticSite=$p($g(^MRC("ID",id)),"^",40) //肿瘤形态学编码标志
    s eobj.MRCIDInjuryPoisoningCode=$p($g(^MRC("ID",id)),"^",41) //损伤中毒外部原因标志
    s eobj.MRCIDBillFlag3=$p($g(^MRC("ID",id)),"^",15) //中医诊断标志
    s eobj.MRCIDBillFlag1=$p($g(^MRC("ID",id)),"^",13) //中医标志证型
    s eobj.MRCID2ndCodeInPair=$p($g(^MRC("ID",id)),"^",43)   //副编码
    s eobj.MRCIDDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MRCIDDateActiveFrom)
    s eobj.MRCIDDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MRCIDDateActiveTo)
    s eobj.MRCIDAgeFromType=$p($g(^MRC("ID",id)),"^",53)  //从年龄类型 （岁/月/日）
    s eobj.MRCIDAgeToType=$p($g(^MRC("ID",id)),"^",54)  //到年龄类型 （岁/月/日）
    s eobj.MRCIDGrayCodeFlag=$p($g(^MRC("ID",id)),"^",55) //医保灰码
    s eobj.MRCIDRareDiseaseFlag=$p($g(^MRC("ID",id)),"^",58)
    
    set myobj=##class(%Dictionary.PropertyDefinition).%OpenId("web.Entity.CT.MRCICDDx"_"||"_"MRCIDTypeDR",0)
    i ($IsObject(myobj))
    {
        s myobj=""
        s eobj.MRCIDTypeDR=$p($g(^MRC("ID",id)),"^",46)   //诊断类型
        s:eobj.MRCIDTypeDR'="" eobj.MRCIDTypeDR=$p($g(^MRC("ICDTYPE",eobj.MRCIDTypeDR)),"^",2)
    }
    set myobj=##class(%Dictionary.PropertyDefinition).%OpenId("web.Entity.CT.MRCICDDx"_"||"_"MRCIDClinicType",0)
    i ($IsObject(myobj))
    {
        s myobj=""
        s eobj.MRCIDClinicType = $p($g(^MRC("ID",id)),"^",47)   //就诊类型
        if eobj.MRCIDClinicType="" s eobj.MRCIDClinicType = "O,E,I,H,N"   //就诊类型为空时 默认门诊。急诊。住院。体检都可以开   
    }
    set myobj=##class(%Dictionary.PropertyDefinition).%OpenId("web.Entity.CT.MRCICDDx"_"||"_"MRCIDNationalDesc",0)
    i ($IsObject(myobj))
    {
        s myobj=""
        s eobj.MRCIDNationalDesc=$p($g(^MRC("ID",id)),"^",49)  //国家标准名称
    }
    
    s ICDJson = eobj.JsonS()
    s ret= ##class(web.DHCBL.MKB.MKBStructIndex).HisICDJsonSyncToDataFactory(ICDJson)
    q ret
}

/// Function: 根据ICD诊断rowid获取诊断国家医保编码
/// Creator:陈莹
/// CreateDate: 2021-11-12
/// Input:RowId:ICD诊断rowid
/// Return :国家医保编码
/// Debug: w ##class(web.DHCBL.CT.MRCICDDx).GetInsuCodeByRowId("1")
ClassMethod GetInsuCodeByRowId(RowId) As %String
{
	n (RowId,%session)
	q:RowId="" ""
	s MRCIDInsuCode=$p($g(^MRC("ID",RowId)),"^",51)   //诊断国家医保编码
	//取翻译后的内容 2022-12-19
	s:MRCIDInsuCode'="" MRCIDInsuCode=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.MRCICDDx","MRCIDInsuCode","",MRCIDInsuCode)
	q MRCIDInsuCode
}

/// Function: 根据ICD诊断rowid获取诊断国家医保名称
/// Creator:陈莹
/// CreateDate:  2021-11-12
/// Input:RowId: ICD诊断rowid
/// Return :MRCIDInsuDesc:国家医保名称
/// Debug: w ##class(web.DHCBL.CT.MRCICDDx).GetInsuName("1")
ClassMethod GetInsuName(RowId) As %String
{
	n (RowId,%session)
	q:RowId="" ""
	s MRCIDInsuDesc=$p($g(^MRC("ID",RowId)),"^",52)   //诊断国家医保名称
	//取翻译后的内容 2022-12-19
	s:MRCIDInsuDesc'="" MRCIDInsuDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.MRCICDDx","MRCIDInsuDesc","",MRCIDInsuDesc)
	q MRCIDInsuDesc
}

/// Function: 根据诊断rowid获取国家医保编码和国家医保名称
/// Creator:陈莹
/// CreateDate: 2022-04-11
/// Input:Rowid诊断rowid,HospDr医院rowid
/// Return:国家医保编码^国家医保名称
/// Debug:w ##class(web.DHCBL.CT.MRCICDDx).GetStdInsuInfo("1","2")
ClassMethod GetStdInsuInfo(Rowid As %String, HospDr As %String) As %String
{
    n (Rowid,HospDr)
    s $ZT="ErrorStd"
    q:Rowid="" ""
    if (HospDr="")
    {
        s HospDr= ##class(web.DHCBL.BDP.BDPDataExport).GetHospital("MRC_ICDDx",Rowid,"")
        if HospDr'="" s HospDr=+HospDr
        if (HospDr="") s HospDr=$o(^CT("HOSP",0))
    }
    s InsuStr=""
    s Config=##class(web.DHCBL.BDP.INSUConfig).GetConfigByHospId(HospDr,"MRC_ICDDx")
    if Config="INSU"
    {
        s InsuStr=##class(web.DHCINSUPort).GetStdInfoByMRCICDDxRowId(Rowid, HospDr,"","","")
    }
    else
    {
        s InsuCode=##class(web.DHCBL.CT.MRCICDDx).GetInsuCodeByRowId(Rowid)
        s InsuName=##class(web.DHCBL.CT.MRCICDDx).GetInsuName(Rowid)
        s InsuStr=InsuCode_"^"_InsuName
    }
    q InsuStr
ErrorStd
    q "-1^"_$ZE
}

/// Creator：chenying
/// CreatDate: 2022-12-07
/// Description：停用ICD诊断代码的内容
/// Table：User.MRCICDDx
/// Input：web.Entity.CT.MRCICDDx 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.CT.MRCICDDx).EndMRCICDDx(eobj)
ClassMethod EndMRCICDDx(eobj As web.Entity.CT.MRCICDDx) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.MRCIDDateActiveTo'="" eobj.MRCIDDateActiveTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MRCIDDateActiveTo)
		s MRCIDRowId=""
		s idc=0
		for
		{
			s idc=$o(^MRC("ID",0,"Code",$$ALPHAUP^SSUTIL4(eobj.MRCIDCode),idc)) q:idc=""
			s MRCIDCode=$p($g(^MRC("ID",idc)),"^",1)
			s MRCIDValid=$p($g(^MRC("ID",idc)),"^",27)
			continue:MRCIDValid="N"
			s MRCIDDateActiveTo=$p($g(^MRC("ID",idc)),"^",7)
			continue:(MRCIDDateActiveTo'="")
			s MRCIDDesc=$p($g(^MRC("ID",idc)),"^",2)
			if (MRCIDCode=eobj.MRCIDCode)&&(MRCIDDesc=eobj.MRCIDDesc)
			{
				s MRCIDRowId=idc
			}
			
		}
		if (MRCIDRowId="")
		{
			s result = "{success:'false',errorinfo:'没有找到有效的代码及描述！'}"
		}
		else
		{
			s eobj.MRCIDRowId=MRCIDRowId
			
			s obj=##class(User.MRCICDDx).%OpenId(eobj.MRCIDRowId)
			s bobj=##class(web.Entity.CT.MRCICDDx).%New()
			s bobj.MRCIDRowId = eobj.MRCIDRowId
			s bobj.MRCIDCode = obj.MRCIDCode
			s bobj.MRCIDDesc = obj.MRCIDDesc
			s bobj.MRCIDICD9CMCode = obj.MRCIDICD9CMCode
			s bobj.MRCIDDateActiveFrom = obj.MRCIDDateActiveFrom
			s bobj.MRCIDDateActiveTo = obj.MRCIDDateActiveTo
			s bobj.MRCIDAgeFrom = obj.MRCIDAgeFrom
			s bobj.MRCIDAgeTo = obj.MRCIDAgeTo
			s bobj.MRCID2ndCodeInPair = obj.MRCID2ndCodeInPair
			
			if $IsObject(obj.MRCIDSexDR){
				s bobj.MRCIDSexDR = obj.MRCIDSexDR.%Id() 
			}
			s bobj.MRCIDValid = obj.MRCIDValid
		
			s bobj.MRCIDICD9Map = obj.MRCIDICD9Map
			s bobj.MRCIDLongDescription = obj.MRCIDLongDescription
			s bobj.MRCIDMetastaticSite = obj.MRCIDMetastaticSite  
			s bobj.MRCIDInjuryPoisoningCode = obj.MRCIDInjuryPoisoningCode    
			s bobj.MRCIDBillFlag3 = obj.MRCIDBillFlag3  
			s bobj.MRCIDBillFlag1 = obj.MRCIDBillFlag1   
			
			
			//修改结束日期+有效标志
			s obj.MRCIDDateActiveTo = eobj.MRCIDDateActiveTo
			s obj.MRCIDValid = eobj.MRCIDValid
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"         //返回RowId
				//保存日志
				d:eobj.MRCIDRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_ICDDx","User.MRCICDDx","停用ICD诊断代码",eobj.MRCIDRowId,eobj.MRCIDDesc,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("ICD诊断代码","web.DHCBL.CT.MRCICDDx","EndMRCICDDx",eobj)
     			s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}
		}		
	}
	else
	{
		s result= "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator：chenying
/// CreatDate: 2023-02-02
/// Description：调用病案组接口同步诊断字典数据
/// Table：User.MRCICDDx
/// Input：id 
/// Return：1^同步成功，-1^失败原因
/// Other: w ##class(web.DHCBL.CT.MRCICDDx).SendMsgToEMR(1)
ClassMethod SendMsgToEMR(id) As %String
{
	n (id,%session)
	q:id="" ""
	s VersionCode="",VersionName="",Valid="",ALIAS="",GrayCodeFlag=""
	s MRCIDCode=$p($g(^MRC("ID",id)),"^",1)  //代码
    s MRCIDDesc=$p($g(^MRC("ID",id)),"^",2)   //名称
    s MRCIDICD9CMCode=$p($g(^MRC("ID",id)),"^",4)     ///ICD10
    s MRCIDDateActiveFrom=$p($g(^MRC("ID",id)),"^",6)  //开始日期
    s MRCIDDateActiveTo=$p($g(^MRC("ID",id)),"^",7)  //结束日期
    s MRCIDValid=$p($g(^MRC("ID",id)),"^",27)    //有效标志
    s:MRCIDValid="" MRCIDValid="Y"   //有效标志空时默认为Y 
    s MRCID2ndCodeInPair=$p($g(^MRC("ID",id)),"^",43)   //副编码
    s:MRCIDDateActiveFrom'="" MRCIDDateActiveFrom=$zd(MRCIDDateActiveFrom,3)
    s:MRCIDDateActiveTo'="" MRCIDDateActiveTo=$zd(MRCIDDateActiveFrom,3)
    s MRCIDVersionDictDR=$p($g(^MRC("ID",id)),"^",56)   //版本号
    s MRCIDGrayCodeFlag=$p($g(^MRC("ID",id)),"^",55) //医保灰码
    s:MRCIDGrayCodeFlag="Y" GrayCodeFlag=1
    s:MRCIDGrayCodeFlag'="Y" GrayCodeFlag=0
    S:MRCIDVersionDictDR'="" VersionCode=$lg($g(^CT.BDP.CT.BDVersionDictD(MRCIDVersionDictDR)),3)
    S:MRCIDVersionDictDR'="" VersionName=$lg($g(^CT.BDP.CT.BDVersionDictD(MRCIDVersionDictDR)),4)
    s:MRCIDValid="Y" Valid=1
    s:MRCIDValid'="Y" Valid=0
    s ALIASChildsub=0
	for 
	{
		s ALIASChildsub=$o(^MRC("ID",id,"ALIAS",ALIASChildsub)) q:ALIASChildsub=""
		s ALIASText=$p($g(^MRC("ID",id,"ALIAS",ALIASChildsub)),"^",1)
		s:ALIAS'="" ALIAS=ALIAS_"^"_ALIASText
		s:ALIAS="" ALIAS=ALIASText
	}
    s retMsg= ##class(MA.IPMR.IO.OutService).SendICDInfo(1,VersionCode,VersionName,MRCIDCode,MRCIDICD9CMCode,MRCID2ndCodeInPair,MRCIDDesc,GrayCodeFlag,id,"",MRCIDDateActiveFrom,MRCIDDateActiveTo,Valid,"","",ALIAS,.ErrMsg)
    q retMsg
}

/// Creator：zrf
/// CreatDate: 2023-3-7
/// Description：默认诊断类型的值
/// Table：User.MRCICDDx
/// Input：id 
/// Return：
/// Other: w ##class(web.DHCBL.CT.MRCICDDx).DiagnosticTypeData()
ClassMethod DiagnosticTypeData()
{
	s result="true"
	
	s MRCIDRowId=0
    for
    {
        s MRCIDRowId=$o(^MRC("ID",MRCIDRowId)) q:MRCIDRowId=""
        s MRCIDMetastaticSite=$p($g(^MRC("ID",MRCIDRowId)),"^",40) //肿瘤形态学编码标志
	    s MRCIDInjuryPoisoningCode=$p($g(^MRC("ID",MRCIDRowId)),"^",41) //损伤中毒外部原因标志
	    s MRCIDBillFlag1=$p($g(^MRC("ID",MRCIDRowId)),"^",13) //中医证型标志
	    s MRCIDBillFlag3=$p($g(^MRC("ID",MRCIDRowId)),"^",15) //中医诊断标志
	    s OldMRCIDDiagnosticType=$p($g(^MRC("ID",MRCIDRowId)),"^",57)
	    s MRCIDDiagnosticType=""

        if (MRCIDBillFlag3'="Y")
	    {
		    s MRCIDDiagnosticType="WM"
	    }
	    if ((MRCIDBillFlag3="Y")&&(MRCIDBillFlag1'="Y"))
	    {
		    s MRCIDDiagnosticType="TCM"
	    }
	    if (MRCIDBillFlag1="Y")
	    {
		    s MRCIDDiagnosticType="ST"
	    }            
	    
	    if (MRCIDDiagnosticType'=OldMRCIDDiagnosticType)
	    {
		    s obj=##class(User.MRCICDDx).%OpenId(MRCIDRowId)
		    s obj.MRCIDDiagnosticType=MRCIDDiagnosticType
		    s sc=obj.%Save()
	        d obj.%Close()
	        s:sc'=1 result="false"
	        q:result="false"
	    }
    }
    q result
}

}
