/// Function: ICD诊断码 卫计委版
/// CreateDate: 2016-12-20
/// Creator:  sunfengchao
Class web.DHCBL.CT.DKBICDHpc Extends %RegisteredObject
{

/// Creator： sunfengchao
/// CreatDate:2016-12-20
/// Description:修改时打开的数据
/// Table：  DKB_ICDHpc
/// Debug:   w ##class(web.DHCBL.CT.DKBICDHpc).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""
    s obj=##class(User.DKBICDHpc).%OpenId(id)
    s eobj = ##class(web.Entity.CT.DKBICDHpc).%New()
    s eobj.DKBHpcRowId= id
    s eobj.DKBHpcCode=obj.DKBHpcCode
    s eobj.DKBHpcDesc=obj.DKBHpcDesc
    s eobj.DKBHpcICD9CMCode=obj.DKBHpcICD9CMCode
    s eobj.DKBHpcDateActiveFrom=obj.DKBHpcDateActiveFrom
    s eobj.DKBHpcDateActiveTo=obj.DKBHpcDateActiveTo
    s eobj.DKBHpcAgeFrom=obj.DKBHpcAgeFrom
    s eobj.DKBHpcAgeTo=obj.DKBHpcAgeTo
    s:obj.DKBHpcSexDR'="" eobj.DKBHpcSexDR=obj.DKBHpcSexDR.%Id() 
    s eobj.DKBHpcValid =obj.DKBHpcValid
    s eobj.DKBHpcICD9Map=obj.DKBHpcICD9Map
    s eobj.DKBHpcLongDescription=obj.DKBHpcLongDescription
    s eobj.DKBHpcMetastaticSite=obj.DKBHpcMetastaticSite //肿瘤形态学编码标志
    s eobj.DKBHpcInjuryPoisoningCode=obj.DKBHpcInjuryPoisoningCode //损伤中毒外部原因标志
    s eobj.DKBHpcBillFlag3=obj.DKBHpcBillFlag3 //中医诊断标志
    s eobj.DKBHpcBillFlag1=obj.DKBHpcBillFlag1 //中医标志证型
    s eobj.DKBHpc2ndCodeInPair=obj.DKBHpc2ndCodeInPair
    s:eobj.DKBHpcDateActiveFrom'="" eobj.DKBHpcDateActiveFrom=$zd(eobj.DKBHpcDateActiveFrom,1) //转换日期格式
    s:eobj.DKBHpcDateActiveTo'="" eobj.DKBHpcDateActiveTo=$zd(eobj.DKBHpcDateActiveTo,1) //转换日期格式
    s:eobj.DKBHpcValid="Y" eobj.DKBHpcValid="true"
    s:eobj.DKBHpcMetastaticSite="Y" eobj.DKBHpcMetastaticSite="true"
    s:eobj.DKBHpcInjuryPoisoningCode="Y" eobj.DKBHpcInjuryPoisoningCode="true"
    s:eobj.DKBHpcBillFlag3="Y" eobj.DKBHpcBillFlag3="true"
    s:eobj.DKBHpcBillFlag1="Y" eobj.DKBHpcBillFlag1="true"
    s eobj.DKBHpcContrastFlag=obj.DKBHpcContrastFlag
    s:eobj.DKBHpcContrastFlag="Y" eobj.DKBHpcContrastFlag="已映射"
    s:eobj.DKBHpcContrastFlag="N" eobj.DKBHpcContrastFlag="未映射"
    s:eobj.DKBHpcContrastFlag="GU" eobj.DKBHpcContrastFlag="放弃映射"
    s str = eobj.JsonS()    
    s str = "{list:["_str_"]}"
    q str
}

/// Description：复制ICD诊断代码信息(除代码和描述外)
/// Creator：    sunfengchao
/// CreatDate:   2016-12-19
/// Table：      DKB_ICDHpc
/// Debug:       w ##class(web.DHCBL.CT.DKBICDHpc).CopyData()
ClassMethod CopyData(id As %String) As %String
{
    s str=""
    s eobj = ##class(web.Entity.CT.DKBICDHpc).%New()
    s obj=##class(User.DKBICDHpc).%OpenId(id)
    s eobj.DKBHpcRowId = ""
    s eobj.DKBHpcCode=""
    s eobj.DKBHpcDesc=""
    s eobj.DKBHpcICD9CMCode=obj.DKBHpcICD9CMCode
    s eobj.DKBHpcDateActiveFrom=obj.DKBHpcDateActiveFrom
    s eobj.DKBHpcDateActiveTo=obj.DKBHpcDateActiveTo
    s eobj.DKBHpcAgeFrom=obj.DKBHpcAgeFrom
    s eobj.DKBHpcAgeTo=obj.DKBHpcAgeTo
    s:obj.DKBHpcSexDR'="" eobj.DKBHpcSexDR=obj.DKBHpcSexDR.%Id()
    s eobj.DKBHpcValid =obj.DKBHpcValid
    s eobj.DKBHpcICD9Map=obj.DKBHpcICD9Map
    s eobj.DKBHpcLongDescription=obj.DKBHpcLongDescription
    s eobj.DKBHpcMetastaticSite=obj.DKBHpcMetastaticSite //肿瘤形态学编码标志
    s eobj.DKBHpcInjuryPoisoningCode=obj.DKBHpcInjuryPoisoningCode //损伤中毒外部原因标志
    s eobj.DKBHpcBillFlag3=obj.DKBHpcBillFlag3 //中医诊断标志
    s eobj.DKBHpcBillFlag1=obj.DKBHpcBillFlag1 //中医标志证型
    s eobj.DKBHpc2ndCodeInPair=obj.DKBHpc2ndCodeInPair
    s:eobj.DKBHpcDateActiveFrom'="" eobj.DKBHpcDateActiveFrom=$zd(eobj.DKBHpcDateActiveFrom,1) //转换日期格式
    s:eobj.DKBHpcDateActiveTo'="" eobj.DKBHpcDateActiveTo=$zd(eobj.DKBHpcDateActiveTo,1) //转换日期格式
    s:eobj.DKBHpcValid="Y" eobj.DKBHpcValid="true"
    s:eobj.DKBHpcMetastaticSite="Y" eobj.DKBHpcMetastaticSite="true"
    s:eobj.DKBHpcInjuryPoisoningCode="Y" eobj.DKBHpcInjuryPoisoningCode="true"
    s:eobj.DKBHpcBillFlag3="Y" eobj.DKBHpcBillFlag3="true"
    s:eobj.DKBHpcBillFlag1="Y" eobj.DKBHpcBillFlag1="true"
    s eobj.DKBHpcContrastFlag=obj.DKBHpcContrastFlag
    s:eobj.DKBHpcContrastFlag="Y" eobj.DKBHpcContrastFlag="已映射"
    s:eobj.DKBHpcContrastFlag="N" eobj.DKBHpcContrastFlag="未映射"
    s:eobj.DKBHpcContrastFlag="GU" eobj.DKBHpcContrastFlag="放弃映射"
    s str = eobj.JsonS()    
    s str = "{list:["_str_"]}"
    q str
}

/// Function：数据重复验证方法,js调用
/// Creator： sunfengchao
/// CreatDate:2016-12-19
/// Table：   DKB_ICDHpc
/// Input：   id, code, desc
/// Return：  "1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) 
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc)  
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DKBICDHPC(0,"Code",code))
    s:desc'="" flagd=$d(^DKBICDHPC(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DKBICDHPC(0,"Code",code,0))
        s:desc'="" idd=$o(^DKBICDHPC(0,"Desc",desc,0))
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
/// Table：      DKB_ICDHpc
/// Input：      id, code, desc
/// Return：     "1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
    s flag="",flagc="",flagd=""
    s flagc=$d(^DKBICDHPC(0,"Code",code))
    s flagd=$d(^DKBICDHPC(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s idc=$o(^DKBICDHPC(0,"Code",code,0))
        s idd=$o(^DKBICDHPC(0,"Desc",desc,0))
        if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Description保存修改ICD诊断代码的内容
/// Creator：  sunfengchao
/// CreatDate: 2016-12-19
/// Table：    DKB_ICDHpc
/// Input：    web.Entity.CT.DKBICDHpc 实体类
/// Return：   成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:     d ##class(web.DHCBL.CT.DKBICDHpc).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.DKBICDHpc) As %String
{
    s $zt="ERROE"
    s result=""
    if $IsObject(eobj)
    {
        s:eobj.DKBHpcValid="" eobj.DKBHpcValid="N"
        s eobj.DKBHpcValid = "Y"
        s:eobj.DKBHpcMetastaticSite="" eobj.DKBHpcMetastaticSite="N"
        s:eobj.DKBHpcInjuryPoisoningCode="" eobj.DKBHpcInjuryPoisoningCode="N"
        s:eobj.DKBHpcBillFlag3="" eobj.DKBHpcBillFlag3="N"
        s:eobj.DKBHpcBillFlag1="" eobj.DKBHpcBillFlag1="N"
        if eobj.DKBHpcBillFlag1="Y" s eobj.DKBHpcBillFlag3="Y"
        s:eobj.DKBHpcICD9CMCode'="" eobj.DKBHpcICD9CMCode=$ZCONVERT(eobj.DKBHpcICD9CMCode,"U")  
        s:eobj.DKBHpcDateActiveFrom'="" eobj.DKBHpcDateActiveFrom=$zdh(eobj.DKBHpcDateActiveFrom,15)  
        s:eobj.DKBHpcDateActiveTo'="" eobj.DKBHpcDateActiveTo=$zdh(eobj.DKBHpcDateActiveTo,15) 
        s:eobj.DKBHpcContrastFlag="已映射" eobj.DKBHpcContrastFlag="Y"
        s:eobj.DKBHpcContrastFlag="未映射" eobj.DKBHpcContrastFlag="N"
        s:eobj.DKBHpcContrastFlag="放弃映射" eobj.DKBHpcContrastFlag="GU"
        s:eobj.DKBHpcContrastFlag="" eobj.DKBHpcContrastFlag="N"      
        s flag=..Validate(eobj.DKBHpcRowId,eobj.DKBHpcCode,eobj.DKBHpcDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.DKBHpcRowId="")  
            {
                s obj=##class(User.DKBICDHpc).%New()
            }
            else                     
            {
                s obj=##class(User.DKBICDHpc).%OpenId(eobj.DKBHpcRowId)
                s bobj=##class(web.Entity.CT.DKBICDHpc).%New()
                s bobj.DKBHpcRowId = eobj.DKBHpcRowId
                s bobj.DKBHpcCode = obj.DKBHpcCode
                s bobj.DKBHpcDesc = obj.DKBHpcDesc
                s bobj.DKBHpcICD9CMCode = obj.DKBHpcICD9CMCode
                s bobj.DKBHpcDateActiveFrom = obj.DKBHpcDateActiveFrom
                s bobj.DKBHpcDateActiveTo = obj.DKBHpcDateActiveTo
                s bobj.DKBHpcAgeFrom = obj.DKBHpcAgeFrom
                s bobj.DKBHpcAgeTo = obj.DKBHpcAgeTo
                s bobj.DKBHpc2ndCodeInPair = obj.DKBHpc2ndCodeInPair
                if $IsObject(obj.DKBHpcSexDR){
                    s:obj.DKBHpcSexDR'="" bobj.DKBHpcSexDR = obj.DKBHpcSexDR.%Id() 
                }
                s bobj.DKBHpcValid = obj.DKBHpcValid
                s bobj.DKBHpcICD9Map = obj.DKBHpcICD9Map
                s bobj.DKBHpcLongDescription = obj.DKBHpcLongDescription
                s bobj.DKBHpcMetastaticSite = obj.DKBHpcMetastaticSite
                s bobj.DKBHpcInjuryPoisoningCode = obj.DKBHpcInjuryPoisoningCode
                s bobj.DKBHpcBillFlag3 = obj.DKBHpcBillFlag3
                s bobj.DKBHpcBillFlag1 = obj.DKBHpcBillFlag1
                s:bobj.DKBHpcContrastFlag="Y" bobj.DKBHpcContrastFlag="已映射"
                s:bobj.DKBHpcContrastFlag="N" bobj.DKBHpcContrastFlag="未映射"
                s:bobj.DKBHpcContrastFlag="GU" bobj.DKBHpcContrastFlag="放弃映射"
            }
            Ts                              
            s obj.DKBHpcCode = eobj.DKBHpcCode          //修改代码
            s obj.DKBHpcDesc = eobj.DKBHpcDesc          //修改描述
            s obj.DKBHpcICD9CMCode = eobj.DKBHpcICD9CMCode
            s obj.DKBHpcDateActiveFrom = eobj.DKBHpcDateActiveFrom
            s obj.DKBHpcDateActiveTo = eobj.DKBHpcDateActiveTo
            s obj.DKBHpcAgeFrom = eobj.DKBHpcAgeFrom
            s obj.DKBHpcAgeTo = eobj.DKBHpcAgeTo
            d obj.DKBHpcSexDRSetObjectId(eobj.DKBHpcSexDR)
            s obj.DKBHpcValid = "Y"
            s obj.DKBHpc2ndCodeInPair = eobj.DKBHpc2ndCodeInPair
            s obj.DKBHpcICD9Map = eobj.DKBHpcICD9Map
            s obj.DKBHpcLongDescription = eobj.DKBHpcLongDescription
            s obj.DKBHpcMetastaticSite = eobj.DKBHpcMetastaticSite
            s obj.DKBHpcInjuryPoisoningCode = eobj.DKBHpcInjuryPoisoningCode
            s obj.DKBHpcBillFlag1 = eobj.DKBHpcBillFlag1
            s obj.DKBHpcBillFlag3 = eobj.DKBHpcBillFlag3
            s obj.DKBHpcContrastFlag=eobj.DKBHpcContrastFlag
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"       
                d:eobj.DKBHpcRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_ICDDx","User.DKBICDHpc","ICD诊断代码卫计委版",id,eobj.DKBHpcDesc,"A",eobj)
                d:eobj.DKBHpcRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_ICDDx","User.DKBICDHpc","ICD诊断代码卫计委版",eobj.DKBHpcRowId,eobj.DKBHpcDesc,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("ICD诊断代码卫计委版","web.DHCBL.CT.DKBICDHpc","SaveEntity",eobj)
                s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
                s result= "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   
            }
        }       
    }
    else
    {
       s result= "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("ICD诊断代码卫计委版","web.DHCBL.CT.DKBICDHpc","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：查询ICD诊断代码卫计委版 
/// CreatDate:   2016-12-19
/// Creator：    sunfengchao
/// Table：      DKB_ICDHpc
/// Input：      rowid,code,desc
/// Debug:       w ##class(web.DHCBL.CT.DKBICDHpc).GetList("","","","","0","20")
ClassMethod GetList(rowid As %String, code As %String, desc As %String, icd10 As %String, ConstrStaus As %String, start As %String, limit As %String) As %String
{
    if start="" s start=0
    if limit="" s limit=20
    if (rowid'="") 
    {
        s DKBHpcRowId=rowid
        s DKBHpcCode=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",1)
        s DKBHpcDesc=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",2)
        s DKBHpcICD9CMCode=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",3)
        s DKBHpcDateActiveFrom=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",4)
        s DKBHpcDateActiveTo=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",5)
        s DKBHpcAgeFrom=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",6)
        s DKBHpcAgeTo=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",7)
        s DKBHpcSexDR=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",8)
        s:DKBHpcSexDR'="" DKBHpcSexDR=$p($g(^CT("SEX",DKBHpcSexDR)),"^",2) //获取性别描述
        s DKBHpcValid=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",9)
        s DKBHpcICD9Map=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",10)
        s DKBHpc2ndCodeInPair=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",11)
        s DKBHpcLongDescription=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",12)
        s DKBHpcMetastaticSite=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",13) //肿瘤形态学编码标志
        s DKBHpcInjuryPoisoningCode=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",14) //损伤中毒外部原因标志
        s DKBHpcBillFlag1=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",15) //中医证型标志
        s DKBHpcBillFlag3=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",16) //中医诊断标志
        s DKBHpcContrastFlag=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",17) //映射标志
        s:DKBHpcContrastFlag="N" DKBHpcContrastFlag="未映射"
        s:DKBHpcContrastFlag="Y" DKBHpcContrastFlag="已映射"
        s:DKBHpcContrastFlag="GU" DKBHpcContrastFlag="放弃映射"
        s:DKBHpcDateActiveFrom'="" DKBHpcDateActiveFrom=$zd(DKBHpcDateActiveFrom,1)  
        s:DKBHpcDateActiveTo'="" DKBHpcDateActiveTo=$zd(DKBHpcDateActiveTo,1) 
        s strResult= "{""DKBHpcRowId"":"""_DKBHpcRowId_""",""DKBHpcCode"":"""_DKBHpcCode_""",""DKBHpcDesc"":"""_DKBHpcDesc_""",""DKBHpcICD9CMCode"":"""_DKBHpcICD9CMCode_""",""DKBHpcDateActiveFrom"":"""_DKBHpcDateActiveFrom_""",""DKBHpcDateActiveTo"":"""_DKBHpcDateActiveTo_""",""DKBHpcAgeFrom"":"""_DKBHpcAgeFrom_""",""DKBHpcAgeTo"":"""_DKBHpcAgeTo_""",""DKBHpcSexDR"":"""_DKBHpcSexDR_""",""DKBHpcValid"":"""_DKBHpcValid_""",""DKBHpcICD9Map"":"""_DKBHpcICD9Map_""",""DKBHpc2ndCodeInPair"":"""_DKBHpc2ndCodeInPair_""",""DKBHpcLongDescription"":"""_DKBHpcLongDescription_""",""DKBHpcMetastaticSite"":"""_DKBHpcMetastaticSite_""",""DKBHpcInjuryPoisoningCode"":"""_DKBHpcInjuryPoisoningCode_""",""DKBHpcBillFlag3"":"""_DKBHpcBillFlag3_""",""DKBHpcBillFlag1"":"""_DKBHpcBillFlag1_""",""DKBHpcContrastFlag"":"""_DKBHpcContrastFlag_"""}"
        s strResult="{""total"":""1"",""success"":""true"",""data"":["_strResult_"]}"
    }
    else
    {
        s:code'="" code=$ZCVT(code,"U") 
        s:desc'="" desc=$ZCVT(desc,"U")  
        s:icd10'="" icd10=$ZCONVERT(icd10,"U") 
        s count2=0, strResult=""
        s start=start+1   
        s DKBHpcRowId=0
        for 
        {
            s DKBHpcRowId=$o(^DKBICDHPC(DKBHpcRowId))
            q:DKBHpcRowId=""
            s DKBHpcCode=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",1)
            s DKBHpcDesc=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",2)
            continue:(DKBHpcCode="-")||(DKBHpcDesc="-") //屏蔽垃圾数据
            s DKBHpcICD9CMCode=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",3)
            s DKBHpcValid=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",10)
            continue:DKBHpcValid="N"       
            s PINYIN=""  
            s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(DKBHpcDesc)
            s DKBHpcContrastFlag=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",17) //映射标志
          
            if ($zcvt(DKBHpcCode,"U")[code)&((PINYIN[desc)||($ZCVT(DKBHpcDesc,"U")[desc))&($ZCVT(DKBHpcICD9CMCode,"U")[icd10)&(DKBHpcContrastFlag[ConstrStaus)
            {
                s count2=count2+1
                if (count2<start) continue
                if ((count2<(start+limit)))
                {
                    
                    s DKBHpcICD9CMCode=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",3)
                    s DKBHpcDateActiveFrom=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",4)
                    s DKBHpcDateActiveTo=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",5)
                    s DKBHpcAgeFrom=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",6)
                    s DKBHpcAgeTo=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",7)
                    s DKBHpcSexDR=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",8)
                    s:DKBHpcSexDR'="" DKBHpcSexDR=$p($g(^CT("SEX",DKBHpcSexDR)),"^",2) //获取性别描述
                    s DKBHpcValid=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",9)
                    s DKBHpcICD9Map=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",10)
                    s DKBHpc2ndCodeInPair=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",11)
                    s DKBHpcLongDescription=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",12)
                    s DKBHpcMetastaticSite=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",13) //肿瘤形态学编码标志
                    s DKBHpcInjuryPoisoningCode=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",14) //损伤中毒外部原因标志
                    s DKBHpcBillFlag1=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",15) //中医证型标志
                    s DKBHpcBillFlag3=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",16) //中医诊断标
                    s:DKBHpcDateActiveFrom'="" DKBHpcDateActiveFrom=$zd(DKBHpcDateActiveFrom,1) //转换日期格式
                    s:DKBHpcDateActiveTo'="" DKBHpcDateActiveTo=$zd(DKBHpcDateActiveTo,1) //转换日期格式
                    s:DKBHpcContrastFlag="N" DKBHpcContrastFlag="未映射"
                    s:DKBHpcContrastFlag="Y" DKBHpcContrastFlag="已映射"
                    s:DKBHpcContrastFlag="GU" DKBHpcContrastFlag="放弃映射"
                    if (strResult'="") 
                    {
                        s strResult=strResult_",{""DKBHpcRowId"":"""_DKBHpcRowId_""",""DKBHpcCode"":"""_DKBHpcCode_""",""DKBHpcDesc"":"""_DKBHpcDesc_""",""DKBHpcICD9CMCode"":"""_DKBHpcICD9CMCode_""",""DKBHpcDateActiveFrom"":"""_DKBHpcDateActiveFrom_""",""DKBHpcDateActiveTo"":"""_DKBHpcDateActiveTo_""",""DKBHpcAgeFrom"":"""_DKBHpcAgeFrom_""",""DKBHpcAgeTo"":"""_DKBHpcAgeTo_""",""DKBHpcSexDR"":"""_DKBHpcSexDR_""",""DKBHpcValid"":"""_DKBHpcValid_""",""DKBHpcICD9Map"":"""_DKBHpcICD9Map_""",""DKBHpc2ndCodeInPair"":"""_DKBHpc2ndCodeInPair_""",""DKBHpcLongDescription"":"""_DKBHpcLongDescription_""",""DKBHpcMetastaticSite"":"""_DKBHpcMetastaticSite_""",""DKBHpcInjuryPoisoningCode"":"""_DKBHpcInjuryPoisoningCode_""",""DKBHpcBillFlag1"":"""_DKBHpcBillFlag1_""",""DKBHpcBillFlag3"":"""_DKBHpcBillFlag3_""",""DKBHpcContrastFlag"":"""_DKBHpcContrastFlag_"""}"
                    }
                    else
                    {  
                        s strResult= "{""DKBHpcRowId"":"""_DKBHpcRowId_""",""DKBHpcCode"":"""_DKBHpcCode_""",""DKBHpcDesc"":"""_DKBHpcDesc_""",""DKBHpcICD9CMCode"":"""_DKBHpcICD9CMCode_""",""DKBHpcDateActiveFrom"":"""_DKBHpcDateActiveFrom_""",""DKBHpcDateActiveTo"":"""_DKBHpcDateActiveTo_""",""DKBHpcAgeFrom"":"""_DKBHpcAgeFrom_""",""DKBHpcAgeTo"":"""_DKBHpcAgeTo_""",""DKBHpcSexDR"":"""_DKBHpcSexDR_""",""DKBHpcValid"":"""_DKBHpcValid_""",""DKBHpcICD9Map"":"""_DKBHpcICD9Map_""",""DKBHpc2ndCodeInPair"":"""_DKBHpc2ndCodeInPair_""",""DKBHpcLongDescription"":"""_DKBHpcLongDescription_""",""DKBHpcMetastaticSite"":"""_DKBHpcMetastaticSite_""",""DKBHpcInjuryPoisoningCode"":"""_DKBHpcInjuryPoisoningCode_""",""DKBHpcBillFlag1"":"""_DKBHpcBillFlag1_""",""DKBHpcBillFlag3"":"""_DKBHpcBillFlag3_""",""DKBHpcContrastFlag"":"""_DKBHpcContrastFlag_"""}"
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
/// Table：      DKB_ICDHpc
/// Input：      rowid,code,desc
/// Return：     DKBHpcRowId,DKBHpcCode,DKBHpcDesc
/// Other:       d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DKBICDHpc","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, icd10 As %String) As %Query(ROWSPEC = "DKBHpcRowId:%String,DKBHpcCode:%String,DKBHpcDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, icd10 As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    if (rowid'="") //根据rowid返回该条记录
    {
        s DKBHpcRowId=rowid
        s DKBHpcCode=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",1)
        s DKBHpcDesc=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",2)
        d OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCVT(code,"U") 
        s:desc'="" desc=$ZCVT(desc,"U")  
        s DKBHpcRowId=0
        for
        {
            s DKBHpcRowId=$o(^DKBICDHPC(DKBHpcRowId))
            q:DKBHpcRowId=""
            s DKBHpcCode=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",1)
            s DKBHpcDesc=$p($g(^DKBICDHPC(DKBHpcRowId)),"^",2)
            continue:(DKBHpcCode="-")||(DKBHpcDesc="-") //屏蔽垃圾数据
            s PINYIN=""
            s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(DKBHpcDesc)
            if ($ZCVT(DKBHpcCode,"U")[code)&((PINYIN[desc)||($ZCVT(DKBHpcDesc,"U")[desc))
            {
                d OutputRowCmb
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(DKBHpcRowId,DKBHpcCode,DKBHpcDesc)
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
/// Debug:      w ##class(web.DHCBL.CT.DKBICDHpc).GetContrastList(1)
ClassMethod GetContrastList(id As %String, desc As %String, start As %String, limit As %String) As %String
{
  s strResult="", count=0
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc)
  if (id'=""){
  s DKBHpcCode=$p($g(^DKBICDHPC(id)),"^",1)
  s start=start+1  
  if ($d(^DKBICDCONHPC(0,"HpcCode",DKBHpcCode))>0){   
  s DKBHpcRowId=0
  for
  {
    s DKBHpcRowId=$o(^DKBICDCONHPC(0,"HpcCode",DKBHpcCode,DKBHpcRowId))
    q:DKBHpcRowId=""
       
    s DKBDiCode=$p($g(^DKBICDCONHPC(DKBHpcRowId)),"^",1)
    s DKBDiDesc=$p($g(^DKBICDCONHPC(DKBHpcRowId)),"^",2)
    if (($$ALPHAUP^SSUTIL4((DKBDiDesc)[desc))||(desc="")){
    s count=count+1
    if (count<start) continue
    if ((count<(start+limit)))
    {
      if (strResult'="") 
      {
        s strResult=strResult_",{""DKBHpcRowId"":"""_DKBHpcRowId_""",""DKBDiCode"":"""_DKBDiCode_""",""DKBDiDesc"":"""_DKBDiDesc_"""}"
      }
      else
      {  
        s strResult="{""DKBHpcRowId"":"""_DKBHpcRowId_""",""DKBDiCode"":"""_DKBDiCode_""",""DKBDiDesc"":"""_DKBDiDesc_"""}"
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
