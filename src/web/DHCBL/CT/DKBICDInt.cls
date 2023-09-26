/// Function: ICD诊断码 国际版
/// CreateDate: 2016-12-19
/// Creator:  sunfengchao
Class web.DHCBL.CT.DKBICDInt Extends %RegisteredObject
{

/// Creator： sunfengchao
/// CreatDate:2012-12-3
/// Description:修改时打开的数据
/// Table：  DKB_ICDInt
/// Debug:   w ##class(web.DHCBL.CT.DKBICDInt).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""
    s obj=##class(User.DKBICDInt).%OpenId(id)
    s eobj = ##class(web.Entity.CT.DKBICDInt).%New()
    s eobj.DKBIntRowId= id
    s eobj.DKBIntCode=obj.DKBIntCode
    s eobj.DKBIntDesc=obj.DKBIntDesc.GetAt(1)
    s eobj.DKBIntICD9CMCode=obj.DKBIntICD9CMCode
    s eobj.DKBIntDateActiveFrom=obj.DKBIntDateActiveFrom
    s eobj.DKBIntDateActiveTo=obj.DKBIntDateActiveTo
    s eobj.DKBIntAgeFrom=obj.DKBIntAgeFrom
    s eobj.DKBIntAgeTo=obj.DKBIntAgeTo
    s:obj.DKBIntSexDR'="" eobj.DKBIntSexDR=obj.DKBIntSexDR.%Id() 
    s eobj.DKBIntValid =obj.DKBIntValid
    s eobj.DKBIntICD9Map=obj.DKBIntICD9Map
    s eobj.DKBIntLongDescription=obj.DKBIntLongDescription.GetAt(1)
    s eobj.DKBIntMetastaticSite=obj.DKBIntMetastaticSite //肿瘤形态学编码标志
    s eobj.DKBIntInjuryPoisoningCode=obj.DKBIntInjuryPoisoningCode //损伤中毒外部原因标志
    s eobj.DKBIntBillFlag3=obj.DKBIntBillFlag3 //中医诊断标志
    s eobj.DKBIntBillFlag1=obj.DKBIntBillFlag1 //中医标志证型
    s eobj.DKBInt2ndCodeInPair=obj.DKBInt2ndCodeInPair
    s:eobj.DKBIntDateActiveFrom'="" eobj.DKBIntDateActiveFrom=$zd(eobj.DKBIntDateActiveFrom,1) //转换日期格式
    s:eobj.DKBIntDateActiveTo'="" eobj.DKBIntDateActiveTo=$zd(eobj.DKBIntDateActiveTo,1) //转换日期格式
    s:eobj.DKBIntValid="Y" eobj.DKBIntValid="true"
    s:eobj.DKBIntMetastaticSite="Y" eobj.DKBIntMetastaticSite="true"
    s:eobj.DKBIntInjuryPoisoningCode="Y" eobj.DKBIntInjuryPoisoningCode="true"
    s:eobj.DKBIntBillFlag3="Y" eobj.DKBIntBillFlag3="true"
    s:eobj.DKBIntBillFlag1="Y" eobj.DKBIntBillFlag1="true"
    s eobj.DKBIntContrastFlag=obj.DKBIntContrastFlag 
    s:eobj.DKBIntContrastFlag="Y" eobj.DKBIntContrastFlag="已映射"
    s:eobj.DKBIntContrastFlag="N" eobj.DKBIntContrastFlag="未映射"
    s:eobj.DKBIntContrastFlag="GU" eobj.DKBIntContrastFlag="放弃映射"
    s str = eobj.JsonS()    
    s str = "{list:["_str_"]}"
    q str
}

/// Description：复制ICD诊断代码信息(除代码和描述外)
/// Creator：    sunfengchao
/// CreatDate:   2016-12-19
/// Table：      User.DKBICDInt
/// Debug:       w ##class(web.DHCBL.CT.DKBICDInt).CopyData()
ClassMethod CopyData(id As %String) As %String
{
    s str=""
    s eobj = ##class(web.Entity.CT.DKBICDInt).%New()
    s obj=##class(User.DKBICDInt).%OpenId(id)
    s eobj.DKBIntRowId = ""
    s eobj.DKBIntCode=""
    s eobj.DKBIntDesc=""
    s eobj.DKBIntLongDescription=""
    s eobj.DKBIntICD9CMCode=obj.DKBIntICD9CMCode
    s eobj.DKBIntDateActiveFrom=obj.DKBIntDateActiveFrom
    s eobj.DKBIntDateActiveTo=obj.DKBIntDateActiveTo
    s eobj.DKBIntAgeFrom=obj.DKBIntAgeFrom
    s eobj.DKBIntAgeTo=obj.DKBIntAgeTo
    s:obj.DKBIntSexDR'="" eobj.DKBIntSexDR=obj.DKBIntSexDR.%Id()
    s eobj.DKBIntValid =obj.DKBIntValid
    s eobj.DKBIntICD9Map=obj.DKBIntICD9Map
    s eobj.DKBIntMetastaticSite=obj.DKBIntMetastaticSite //肿瘤形态学编码标志
    s eobj.DKBIntInjuryPoisoningCode=obj.DKBIntInjuryPoisoningCode //损伤中毒外部原因标志
    s eobj.DKBIntBillFlag3=obj.DKBIntBillFlag3 //中医诊断标志
    s eobj.DKBIntBillFlag1=obj.DKBIntBillFlag1 //中医标志证型
    s eobj.DKBInt2ndCodeInPair=obj.DKBInt2ndCodeInPair
    s:eobj.DKBIntDateActiveFrom'="" eobj.DKBIntDateActiveFrom=$zd(eobj.DKBIntDateActiveFrom,1) //转换日期格式
    s:eobj.DKBIntDateActiveTo'="" eobj.DKBIntDateActiveTo=$zd(eobj.DKBIntDateActiveTo,1) //转换日期格式
    s:eobj.DKBIntValid="Y" eobj.DKBIntValid="true"
    s:eobj.DKBIntMetastaticSite="Y" eobj.DKBIntMetastaticSite="true"
    s:eobj.DKBIntInjuryPoisoningCode="Y" eobj.DKBIntInjuryPoisoningCode="true"
    s:eobj.DKBIntBillFlag3="Y" eobj.DKBIntBillFlag3="true"
    s:eobj.DKBIntBillFlag1="Y" eobj.DKBIntBillFlag1="true"
    s eobj.DKBIntContrastFlag=obj.DKBIntContrastFlag
    s:eobj.DKBIntContrastFlag="Y" eobj.DKBIntContrastFlag="已映射"
    s:eobj.DKBIntContrastFlag="N" eobj.DKBIntContrastFlag="未映射"
    s:eobj.DKBIntContrastFlag="GU" eobj.DKBIntContrastFlag="放弃映射"
    s str = eobj.JsonS()    
    s str = "{list:["_str_"]}"
    q str
}

/// Function：数据重复验证方法,js调用
/// Creator： sunfengchao
/// CreatDate:2016-12-19
/// Table：   User.DKBICDInt
/// Input：   id, code, desc
/// Return：  "1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) 
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc)  
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DKBICDINT(0,"Code",code))
    s:desc'="" flagd=$d(^DKBICDINT(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DKBICDINT(0,"Code",code,0))
        s:desc'="" idd=$o(^DKBICDINT(0,"Desc",desc,0))
        if (desc="")
        {
            if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
            else  s flag=0 //返回不重复标志
        }
        elseif (code="")
        {
            if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
            else  s flag=0 //返回不重复标志
        }
    }
    q flag
}

/// Description：数据重复验证方法
/// Creator：    sunfengchao
/// CreatDate:   2016-12-19
/// Table：      User.DKBICDInt
/// Input：      id, code, desc
/// Return：     "1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
    s flag="",flagc="",flagd=""
    s flagc=$d(^DKBICDINT(0,"Code",code))
    if (id="") //如果为空，增加时的重复判断
    {
        if (flagc>0) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s idc=$o(^DKBICDINT(0,"Code",code,0))
        if ((idc'=id)&(flagc>0))  s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Description保存修改ICD诊断代码的内容
/// Creator：  sunfengchao
/// CreatDate: 2016-12-19
/// Table：    DKB_ICDInt
/// Input：    web.Entity.CT.DKBICDInt 实体类
/// Return：   成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:     d ##class(web.DHCBL.CT.DKBICDInt).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.DKBICDInt) As %String
{
    s $zt="ERROE"
    s result=""
    if $IsObject(eobj)
    {
        s:eobj.DKBIntValid="" eobj.DKBIntValid="N"
        s eobj.DKBIntValid = "Y"
        s:eobj.DKBIntMetastaticSite="" eobj.DKBIntMetastaticSite="N"
        s:eobj.DKBIntInjuryPoisoningCode="" eobj.DKBIntInjuryPoisoningCode="N"
        s:eobj.DKBIntBillFlag3="" eobj.DKBIntBillFlag3="N"
        s:eobj.DKBIntBillFlag1="" eobj.DKBIntBillFlag1="N"
        if eobj.DKBIntBillFlag1="Y" s eobj.DKBIntBillFlag3="Y"
        s:eobj.DKBIntICD9CMCode'="" eobj.DKBIntICD9CMCode=$ZCONVERT(eobj.DKBIntICD9CMCode,"U")   
        s:eobj.DKBIntDateActiveFrom'="" eobj.DKBIntDateActiveFrom=$zdh(eobj.DKBIntDateActiveFrom,15)  
        s:eobj.DKBIntDateActiveTo'="" eobj.DKBIntDateActiveTo=$zdh(eobj.DKBIntDateActiveTo,15)       
      
        s:eobj.DKBIntContrastFlag="已映射" eobj.DKBIntContrastFlag="Y"
        s:eobj.DKBIntContrastFlag="未映射" eobj.DKBIntContrastFlag="N"
        s:eobj.DKBIntContrastFlag="放弃映射" eobj.DKBIntContrastFlag="GU"
        s:eobj.DKBIntContrastFlag="" eobj.DKBIntContrastFlag="N"
        s flag=..Validate(eobj.DKBIntRowId,eobj.DKBIntCode,eobj.DKBIntDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {  
            if (eobj.DKBIntRowId="")  
            {
                s obj=##class(User.DKBICDInt).%New()
            }
            else                     
            {
                s obj=##class(User.DKBICDInt).%OpenId(eobj.DKBIntRowId)
                s bobj=##class(web.Entity.CT.DKBICDInt).%New()
                s bobj.DKBIntRowId = eobj.DKBIntRowId
                s bobj.DKBIntCode = obj.DKBIntCode
                s bobj.DKBIntDesc = obj.DKBIntDesc
                s bobj.DKBIntICD9CMCode = obj.DKBIntICD9CMCode
                s bobj.DKBIntDateActiveFrom = obj.DKBIntDateActiveFrom
                s bobj.DKBIntDateActiveTo = obj.DKBIntDateActiveTo
                s bobj.DKBIntAgeFrom = obj.DKBIntAgeFrom
                s bobj.DKBIntAgeTo = obj.DKBIntAgeTo
                s bobj.DKBInt2ndCodeInPair = obj.DKBInt2ndCodeInPair 
                if $IsObject(obj.DKBIntSexDR){
                    s:obj.DKBIntSexDR'="" bobj.DKBIntSexDR = obj.DKBIntSexDR.%Id() 
                }
                s bobj.DKBIntValid = obj.DKBIntValid
                s bobj.DKBIntICD9Map = obj.DKBIntICD9Map
                s bobj.DKBIntLongDescription = obj.DKBIntLongDescription
                s bobj.DKBIntMetastaticSite = obj.DKBIntMetastaticSite
                s bobj.DKBIntInjuryPoisoningCode = obj.DKBIntInjuryPoisoningCode
                s bobj.DKBIntBillFlag3 = obj.DKBIntBillFlag3
                s bobj.DKBIntBillFlag1 = obj.DKBIntBillFlag1
                s bobj.DKBIntContrastFlag=obj.DKBIntContrastFlag
                s:bobj.DKBIntContrastFlag="Y" bobj.DKBIntContrastFlag="已映射"
                s:bobj.DKBIntContrastFlag="N" bobj.DKBIntContrastFlag="未映射"
                s:bobj.DKBIntContrastFlag="GU" bobj.DKBIntContrastFlag="放弃映射"
            }
            Ts                              
            s obj.DKBIntCode = eobj.DKBIntCode      
            /// 英文说明     
            s DKBIntDesc=##class(%ListOfDataTypes).%New()
            do DKBIntDesc.Insert(eobj.DKBIntDesc)
            s obj.DKBIntDesc = DKBIntDesc   
            /// 中文说明
            s DKBIntLongDescription=##class(%ListOfDataTypes).%New()
            do DKBIntLongDescription.Insert(eobj.DKBIntLongDescription)
            s obj.DKBIntLongDescription = DKBIntLongDescription 
                         
            s obj.DKBIntICD9CMCode = eobj.DKBIntICD9CMCode
            s obj.DKBIntDateActiveFrom = eobj.DKBIntDateActiveFrom
            s obj.DKBIntDateActiveTo = eobj.DKBIntDateActiveTo
            s obj.DKBIntAgeFrom = eobj.DKBIntAgeFrom
            s obj.DKBIntAgeTo = eobj.DKBIntAgeTo
            d obj.DKBIntSexDRSetObjectId(eobj.DKBIntSexDR)
            s obj.DKBIntValid = "Y"
           
            s obj.DKBInt2ndCodeInPair = eobj.DKBInt2ndCodeInPair
            s obj.DKBIntICD9Map = eobj.DKBIntICD9Map
            s obj.DKBIntMetastaticSite = eobj.DKBIntMetastaticSite
            s obj.DKBIntInjuryPoisoningCode = eobj.DKBIntInjuryPoisoningCode
            s obj.DKBIntBillFlag1 = eobj.DKBIntBillFlag1
            s obj.DKBIntBillFlag3 = eobj.DKBIntBillFlag3
            s obj.DKBIntContrastFlag=eobj.DKBIntContrastFlag
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"         //返回RowId
                //保存日志
                d:eobj.DKBIntRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_ICDDx","User.DKBICDInt","ICD诊断代码国际版",id,eobj.DKBIntDesc,"A",eobj)
                d:eobj.DKBIntRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_ICDDx","User.DKBICDInt","ICD诊断代码国际版",eobj.DKBIntRowId,eobj.DKBIntDesc,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("ICD诊断代码国际版","web.DHCBL.CT.DKBICDInt","SaveEntity",eobj)
                s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
                s result= "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
            }
         }       
    }
    else
    {
        s result= "{success:'false',errorinfo:'对象不存在！'}"
    }  
    q result
ERROE
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("ICD诊断代码国际版","web.DHCBL.CT.DKBICDInt","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：查询ICD诊断代码的内容  真分页
/// CreatDate:   2016-12-19
/// Creator：    sunfengchao
/// Table：      User.DKBICDInt
/// Input：      rowid,code,desc
/// Debug:       w ##class(web.DHCBL.CT.DKBICDInt).GetList("","","","","0","20")
ClassMethod GetList(rowid As %String, code As %String, desc As %String, icd10 As %String, ConstrStaus As %String, start As %String, limit As %String) As %String
{
    if start="" s start=0
    if limit="" s limit=20
    if (rowid'="") 
    {
        s DKBIntRowId=rowid
        s DKBIntCode=$p($g(^DKBICDINT(DKBIntRowId)),"^",1)
        if ($d(^DKBICDINT(rowid,"Desc"))>0)
        {
          s DKBIntDesc=$listget(^DKBICDINT(rowid,"Desc"))  
        }
        else
        {
           s DKBIntDesc=""
        } 
        s DKBIntICD9CMCode=$p($g(^DKBICDINT(DKBIntRowId)),"^",2)
        s DKBIntDateActiveFrom=$p($g(^DKBICDINT(DKBIntRowId)),"^",3)
        s DKBIntDateActiveTo=$p($g(^DKBICDINT(DKBIntRowId)),"^",4)
        s DKBIntAgeFrom=$p($g(^DKBICDINT(DKBIntRowId)),"^",5)
        s DKBIntAgeTo=$p($g(^DKBICDINT(DKBIntRowId)),"^",6)
        s DKBIntSexDR=$p($g(^DKBICDINT(DKBIntRowId)),"^",7)
        s:DKBIntSexDR'="" DKBIntSexDR=$p($g(^CT("SEX",DKBIntSexDR)),"^",2) //获取性别描述
        s DKBIntValid=$p($g(^DKBICDINT(DKBIntRowId)),"^",8)
        s DKBIntICD9Map=$p($g(^DKBICDINT(DKBIntRowId)),"^",9)
        s DKBInt2ndCodeInPair=$p($g(^DKBICDINT(DKBIntRowId)),"^",10)
        s DKBIntLongDescription=""
        if ($d(^DKBICDINT(rowid,"LONGDesc"))>0)
        {
          s DKBIntLongDescription=$listget(^DKBICDINT(rowid,"LONGDesc"))  
        }
        s DKBIntMetastaticSite=$p($g(^DKBICDINT(DKBIntRowId)),"^",11) //肿瘤形态学编码标志
        s DKBIntInjuryPoisoningCode=$p($g(^DKBICDINT(DKBIntRowId)),"^",12) //损伤中毒外部原因标志
        s DKBIntBillFlag1=$p($g(^DKBICDINT(DKBIntRowId)),"^",13) //中医证型标志
        s DKBIntBillFlag3=$p($g(^DKBICDINT(DKBIntRowId)),"^",14) //中医诊断标志
        s DKBIntContrastFlag=$p($g(^DKBICDINT(DKBIntRowId)),"^",15) //映射标志
        s:DKBIntContrastFlag="N" DKBIntContrastFlag="未映射"
        s:DKBIntContrastFlag="Y" DKBIntContrastFlag="已映射"
        s:DKBIntContrastFlag="GU" DKBIntContrastFlag="放弃映射"
        s:DKBIntDateActiveFrom'="" DKBIntDateActiveFrom=$zd(DKBIntDateActiveFrom,1) //转换日期格式
        s:DKBIntDateActiveTo'="" DKBIntDateActiveTo=$zd(DKBIntDateActiveTo,1) //转换日期格式 
        s strResult= "{""DKBIntRowId"":"""_DKBIntRowId_""",""DKBIntCode"":"""_DKBIntCode_""",""DKBIntDesc"":"""_DKBIntDesc_""",""DKBIntICD9CMCode"":"""_DKBIntICD9CMCode_""",""DKBIntDateActiveFrom"":"""_DKBIntDateActiveFrom_""",""DKBIntDateActiveTo"":"""_DKBIntDateActiveTo_""",""DKBIntAgeFrom"":"""_DKBIntAgeFrom_""",""DKBIntAgeTo"":"""_DKBIntAgeTo_""",""DKBIntSexDR"":"""_DKBIntSexDR_""",""DKBIntValid"":"""_DKBIntValid_""",""DKBIntICD9Map"":"""_DKBIntICD9Map_""",""DKBInt2ndCodeInPair"":"""_DKBInt2ndCodeInPair_""",""DKBIntLongDescription"":"""_DKBIntLongDescription_""",""DKBIntMetastaticSite"":"""_DKBIntMetastaticSite_""",""DKBIntInjuryPoisoningCode"":"""_DKBIntInjuryPoisoningCode_""",""DKBIntBillFlag1"":"""_DKBIntBillFlag1_""",""DKBIntBillFlag3"":"""_DKBIntBillFlag3_""",""DKBIntContrastFlag"":"""_DKBIntContrastFlag_"""}"
        s strResult="{""total"":""1"",""success"":""true"",""data"":["_strResult_"]}"
    }
    else
    {
        s:code'="" code=$ZCVT(code,"U")  
        s:desc'="" desc=$ZCVT(desc,"U")  
        s:icd10'="" icd10=$ZCONVERT(icd10,"U") 
        s count2=0, strResult=""
        s start=start+1  
            
        s DKBIntRowId=0
        for 
        {
            s DKBIntRowId=$o(^DKBICDINT(DKBIntRowId))
            q:DKBIntRowId=""
            s DKBIntCode=$p($g(^DKBICDINT(DKBIntRowId)),"^",1)
            s DKBIntDesc=""
            if ($d(^DKBICDINT(DKBIntRowId,"Desc"))>0)
            {
              s DKBIntDesc=$listget(^DKBICDINT(DKBIntRowId,"Desc"))  
            }
            s DKBIntICD9CMCode=$p($g(^DKBICDINT(DKBIntRowId)),"^",2)
            s DKBIntValid=$p($g(^DKBICDINT(DKBIntRowId)),"^",8)
            continue:DKBIntValid="N"
            s PINYIN="" 
            s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(DKBIntDesc)
            s DKBIntContrastFlag=$p($g(^DKBICDINT(DKBIntRowId)),"^",15) //映射标志
            if ($zcvt(DKBIntCode,"U")[code)&((PINYIN[desc)||($ZCVT(DKBIntDesc,"U")[desc))&($ZCVT(DKBIntICD9CMCode,"U")[icd10)&(DKBIntContrastFlag[ConstrStaus)
            {
                s count2=count2+1
                if (count2<start) continue
                if ((count2<(start+limit)))
                {
                    s DKBIntICD9CMCode=$p($g(^DKBICDINT(DKBIntRowId)),"^",2)
                    s DKBIntDateActiveFrom=$p($g(^DKBICDINT(DKBIntRowId)),"^",3)
                    s DKBIntDateActiveTo=$p($g(^DKBICDINT(DKBIntRowId)),"^",4)
                    s DKBIntAgeFrom=$p($g(^DKBICDINT(DKBIntRowId)),"^",5)
                    s DKBIntAgeTo=$p($g(^DKBICDINT(DKBIntRowId)),"^",6)
                    s DKBIntSexDR=$p($g(^DKBICDINT(DKBIntRowId)),"^",7)
                    s:DKBIntSexDR'="" DKBIntSexDR=$p($g(^CT("SEX",DKBIntSexDR)),"^",2) //获取性别描述
                    s DKBIntValid=$p($g(^DKBICDINT(DKBIntRowId)),"^",8)
                    s DKBIntICD9Map=$p($g(^DKBICDINT(DKBIntRowId)),"^",9)
                    s DKBInt2ndCodeInPair=$p($g(^DKBICDINT(DKBIntRowId)),"^",10)
                    s DKBIntLongDescription=""
                    if ($d(^DKBICDINT(DKBIntRowId,"LONGDesc"))>0)
                    {
                      s DKBIntLongDescription=$listget(^DKBICDINT(DKBIntRowId,"LONGDesc"))  
                    }
                    s DKBIntMetastaticSite=$p($g(^DKBICDINT(DKBIntRowId)),"^",11) //肿瘤形态学编码标志
                    s DKBIntInjuryPoisoningCode=$p($g(^DKBICDINT(DKBIntRowId)),"^",12) //损伤中毒外部原因标志
                    s DKBIntBillFlag1=$p($g(^DKBICDINT(DKBIntRowId)),"^",13) //中医证型标志
                    s DKBIntBillFlag3=$p($g(^DKBICDINT(DKBIntRowId)),"^",14) //中医诊断标志
                    s:DKBIntContrastFlag="N" DKBIntContrastFlag="未映射"
                    s:DKBIntContrastFlag="Y" DKBIntContrastFlag="已映射"
                    s:DKBIntContrastFlag="GU" DKBIntContrastFlag="放弃映射"
                    s:DKBIntDateActiveFrom'="" DKBIntDateActiveFrom=$zd(DKBIntDateActiveFrom,1) //转换日期格式
                    s:DKBIntDateActiveTo'="" DKBIntDateActiveTo=$zd(DKBIntDateActiveTo,1) //转换日期格式
                    if (strResult'="") 
                    {
                        s strResult=strResult_",{""DKBIntRowId"":"""_DKBIntRowId_""",""DKBIntCode"":"""_DKBIntCode_""",""DKBIntDesc"":"""_DKBIntDesc_""",""DKBIntICD9CMCode"":"""_DKBIntICD9CMCode_""",""DKBIntDateActiveFrom"":"""_DKBIntDateActiveFrom_""",""DKBIntDateActiveTo"":"""_DKBIntDateActiveTo_""",""DKBIntAgeFrom"":"""_DKBIntAgeFrom_""",""DKBIntAgeTo"":"""_DKBIntAgeTo_""",""DKBIntSexDR"":"""_DKBIntSexDR_""",""DKBIntValid"":"""_DKBIntValid_""",""DKBIntICD9Map"":"""_DKBIntICD9Map_""",""DKBInt2ndCodeInPair"":"""_DKBInt2ndCodeInPair_""",""DKBIntLongDescription"":"""_DKBIntLongDescription_""",""DKBIntMetastaticSite"":"""_DKBIntMetastaticSite_""",""DKBIntInjuryPoisoningCode"":"""_DKBIntInjuryPoisoningCode_""",""DKBIntBillFlag1"":"""_DKBIntBillFlag1_""",""DKBIntBillFlag3"":"""_DKBIntBillFlag3_""",""DKBIntContrastFlag"":"""_DKBIntContrastFlag_"""}"
                    }
                    else
                    {  
                        s strResult= "{""DKBIntRowId"":"""_DKBIntRowId_""",""DKBIntCode"":"""_DKBIntCode_""",""DKBIntDesc"":"""_DKBIntDesc_""",""DKBIntICD9CMCode"":"""_DKBIntICD9CMCode_""",""DKBIntDateActiveFrom"":"""_DKBIntDateActiveFrom_""",""DKBIntDateActiveTo"":"""_DKBIntDateActiveTo_""",""DKBIntAgeFrom"":"""_DKBIntAgeFrom_""",""DKBIntAgeTo"":"""_DKBIntAgeTo_""",""DKBIntSexDR"":"""_DKBIntSexDR_""",""DKBIntValid"":"""_DKBIntValid_""",""DKBIntICD9Map"":"""_DKBIntICD9Map_""",""DKBInt2ndCodeInPair"":"""_DKBInt2ndCodeInPair_""",""DKBIntLongDescription"":"""_DKBIntLongDescription_""",""DKBIntMetastaticSite"":"""_DKBIntMetastaticSite_""",""DKBIntInjuryPoisoningCode"":"""_DKBIntInjuryPoisoningCode_""",""DKBIntBillFlag1"":"""_DKBIntBillFlag1_""",""DKBIntBillFlag3"":"""_DKBIntBillFlag3_""",""DKBIntContrastFlag"":"""_DKBIntContrastFlag_"""}"
                    }
                }      
            }
      }
      s strResult="{""total"":"""_count2_""",""success"":""true"",""data"":["_strResult_"]}"
}
    q strResult
}

/// Description：用于combox查询
/// Creator：    sunfengchao
/// CreatDate:   2016-12-19
/// Table：      User.DKBICDInt
/// Input：      rowid,code,desc
/// Return：     DKBIntRowId,DKBIntCode,DKBIntDesc
/// Other:       d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DKBICDInt","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, icd10 As %String) As %Query(ROWSPEC = "DKBIntRowId:%String,DKBIntCode:%String,DKBIntDesc:%String,DKBIntLongDescription:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, icd10 As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    if (rowid'="") 
    {
        s DKBIntRowId=rowid
        s DKBIntCode=$p($g(^DKBICDINT(DKBIntRowId)),"^",1)
        if ($d(^DKBICDINT(rowid,"Desc"))>0)
        {
          s DKBIntDesc=$listget(^DKBICDINT(rowid,"Desc"))  
        }
        else
        {
           s DKBIntDesc=""
        } 
        if ($d(^DKBICDINT(rowid,"LONGDesc"))>0)
        {
           s DKBIntLongDescription=$listget(^DKBICDINT(rowid,"LONGDesc"))  
        }
        else
        { 
           s DKBIntLongDescription=""
        } 
        d OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCVT(code,"U")  
        s:desc'="" desc=$ZCVT(desc,"U") 
        s DKBIntRowId=0
        for
        {
            s DKBIntRowId=$o(^DKBICDINT(DKBIntRowId))
            q:DKBIntRowId=""
            s DKBIntCode=$p($g(^DKBICDINT(DKBIntRowId)),"^",1)
            if ($d(^DKBICDINT(DKBIntRowId,"Desc"))>0)
            {
              s DKBIntDesc=$listget(^DKBICDINT(DKBIntRowId,"Desc"))  
            }
            else
            {
               s DKBIntDesc=""
            } 
            s PINYIN=""
            s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(DKBIntDesc)
            
            if ($d(^DKBICDINT(DKBIntRowId,"LONGDesc"))>0)
            {
              s DKBIntLongDescription=$listget(^DKBICDINT(DKBIntRowId,"LONGDesc"))  
            }
            else
            {
               s DKBIntLongDescription=""
            } 
            if ($ZCVT(DKBIntCode,"U")[code)&((PINYIN[desc)||($ZCVT(DKBIntDesc,"U")[desc))
            {
                d OutputRowCmb
            }
         }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(DKBIntRowId,DKBIntCode,DKBIntDesc,DKBIntLongDescription)
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

/// Function:   反向查询映射的诊断术语
/// CreateDate: 2017-1-11
/// Creator:    sunfengchao
/// Debug:      w ##class(web.DHCBL.CT.DKBICDInt).GetContrastList(1)
ClassMethod GetContrastList(id As %String, desc As %String, start As %String, limit As %String) As %String
{
  s strResult="", count=0
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc)
  if (id'=""){
  s DKBIntCode=$p($g(^DKBICDINT(id)),"^",1)
  s start=start+1  
  if ($d(^DKBICDCONINT(0,"IntCode"))>0){ 
  s DKBIntRowId=0
  for
  {
    s DKBIntRowId=$o(^DKBICDCONINT(0,"IntCode",DKBIntCode,DKBIntRowId))
    q:DKBIntRowId=""
   
    s DKBDiCode=$p($g(^DKBICDCONINT(DKBIntRowId)),"^",1)
    s DKBDiDesc=$p($g(^DKBICDCONINT(DKBIntRowId)),"^",2)
    if (($$ALPHAUP^SSUTIL4((DKBDiDesc)[desc))||(desc="")){
    s count=count+1
    if (count<start) continue
    if ((count<(start+limit)))
    {
      if (strResult'="") 
      {
        s strResult=strResult_",{""DKBPekRowId"":"""_DKBPekRowId_""",""DKBDiCode"":"""_DKBDiCode_""",""DKBDiDesc"":"""_DKBDiDesc_"""}"
      }
      else
      {  
        s strResult="{""DKBPekRowId"":"""_DKBPekRowId_""",""DKBDiCode"":"""_DKBDiCode_""",""DKBDiDesc"":"""_DKBDiDesc_"""}"
      } 
    }
   }  
  }
 }
}
  s strResult="{""total"":"""_count_""",""success"":""true"",""data"":["_strResult_"]}"
  q strResult
}

}
