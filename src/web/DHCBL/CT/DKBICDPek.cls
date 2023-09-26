/// Function: ICD诊断码 北京版
/// CreateDate: 2016-12-20
/// Creator:  sunfengchao
Class web.DHCBL.CT.DKBICDPek Extends %RegisteredObject
{

/// Creator： sunfengchao
/// CreatDate:2016-12-20
/// Description:修改时打开的数据
/// Table：  DKB_ICDPek
/// Debug:   w ##class(web.DHCBL.CT.DKBICDPek).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""
    s obj=##class(User.DKBICDPek).%OpenId(id)
    s eobj = ##class(web.Entity.CT.DKBICDPek).%New()
    s eobj.DKBPekRowId= id
    s eobj.DKBPekCode=obj.DKBPekCode
    s eobj.DKBPekDesc=obj.DKBPekDesc
    s eobj.DKBPekICD9CMCode=obj.DKBPekICD9CMCode
    s eobj.DKBPekDateActiveFrom=obj.DKBPekDateActiveFrom
    s eobj.DKBPekDateActiveTo=obj.DKBPekDateActiveTo
    s eobj.DKBPekAgeFrom=obj.DKBPekAgeFrom
    s eobj.DKBPekAgeTo=obj.DKBPekAgeTo
    s:obj.DKBPekSexDR'="" eobj.DKBPekSexDR=obj.DKBPekSexDR.%Id() 
    s eobj.DKBPekValid =obj.DKBPekValid
    s eobj.DKBPekICD9Map=obj.DKBPekICD9Map
    s eobj.DKBPekLongDescription=obj.DKBPekLongDescription
    s eobj.DKBPekMetastaticSite=obj.DKBPekMetastaticSite //肿瘤形态学编码标志
    s eobj.DKBPekInjuryPoisoningCode=obj.DKBPekInjuryPoisoningCode //损伤中毒外部原因标志
    s eobj.DKBPekBillFlag3=obj.DKBPekBillFlag3 //中医诊断标志
    s eobj.DKBPekBillFlag1=obj.DKBPekBillFlag1 //中医标志证型
    s eobj.DKBPek2ndCodeInPair=obj.DKBPek2ndCodeInPair
    s:eobj.DKBPekDateActiveFrom'="" eobj.DKBPekDateActiveFrom=$zd(eobj.DKBPekDateActiveFrom,1) //转换日期格式
    s:eobj.DKBPekDateActiveTo'="" eobj.DKBPekDateActiveTo=$zd(eobj.DKBPekDateActiveTo,1) //转换日期格式
    s:eobj.DKBPekValid="Y" eobj.DKBPekValid="true"
    s:eobj.DKBPekMetastaticSite="Y" eobj.DKBPekMetastaticSite="true"
    s:eobj.DKBPekInjuryPoisoningCode="Y" eobj.DKBPekInjuryPoisoningCode="true"
    s:eobj.DKBPekBillFlag3="Y" eobj.DKBPekBillFlag3="true"
    s:eobj.DKBPekBillFlag1="Y" eobj.DKBPekBillFlag1="true"
    s eobj.DKBPekContrastFlag=obj.DKBPekContrastFlag
    s:eobj.DKBPekContrastFlag="Y" eobj.DKBPekContrastFlag="已映射"
    s:eobj.DKBPekContrastFlag="N" eobj.DKBPekContrastFlag="未映射"
    s:eobj.DKBPekContrastFlag="GU" eobj.DKBPekContrastFlag="放弃映射"
    s str = eobj.JsonS()    
    s str = "{list:["_str_"]}"
    q str
}

/// Description：复制ICD诊断代码信息(除代码和描述外)
/// Creator：    sunfengchao
/// CreatDate:   2016-12-19
/// Table：      DKB_ICDPek
/// Debug:       w ##class(web.DHCBL.CT.DKBICDPek).CopyData()
ClassMethod CopyData(id As %String) As %String
{
    s str=""
    s eobj = ##class(web.Entity.CT.DKBICDPek).%New()
    s obj=##class(User.DKBICDPek).%OpenId(id)
    s eobj.DKBPekRowId = ""
    s eobj.DKBPekCode=""
    s eobj.DKBPekDesc=""
    s eobj.DKBPekICD9CMCode=obj.DKBPekICD9CMCode
    s eobj.DKBPekDateActiveFrom=obj.DKBPekDateActiveFrom
    
    s eobj.DKBPekDateActiveTo=obj.DKBPekDateActiveTo
    s eobj.DKBPekAgeFrom=obj.DKBPekAgeFrom
    s eobj.DKBPekAgeTo=obj.DKBPekAgeTo
    s:obj.DKBPekSexDR'="" eobj.DKBPekSexDR=obj.DKBPekSexDR.%Id()
    s eobj.DKBPekValid =obj.DKBPekValid
    s eobj.DKBPekICD9Map=obj.DKBPekICD9Map
    s eobj.DKBPekLongDescription=obj.DKBPekLongDescription
    s eobj.DKBPekMetastaticSite=obj.DKBPekMetastaticSite //肿瘤形态学编码标志
    s eobj.DKBPekInjuryPoisoningCode=obj.DKBPekInjuryPoisoningCode //损伤中毒外部原因标志
    s eobj.DKBPekBillFlag3=obj.DKBPekBillFlag3 //中医诊断标志
    s eobj.DKBPekBillFlag1=obj.DKBPekBillFlag1 //中医标志证型
    s eobj.DKBPek2ndCodeInPair=obj.DKBPek2ndCodeInPair
    s:eobj.DKBPekDateActiveFrom'="" eobj.DKBPekDateActiveFrom=$zd(eobj.DKBPekDateActiveFrom,1) //转换日期格式
    s:eobj.DKBPekDateActiveTo'="" eobj.DKBPekDateActiveTo=$zd(eobj.DKBPekDateActiveTo,1) //转换日期格式
    s:eobj.DKBPekValid="Y" eobj.DKBPekValid="true"
    s:eobj.DKBPekMetastaticSite="Y" eobj.DKBPekMetastaticSite="true"
    s:eobj.DKBPekInjuryPoisoningCode="Y" eobj.DKBPekInjuryPoisoningCode="true"
    s:eobj.DKBPekBillFlag3="Y" eobj.DKBPekBillFlag3="true"
    s:eobj.DKBPekBillFlag1="Y" eobj.DKBPekBillFlag1="true"
    s eobj.DKBPekContrastFlag=obj.DKBPekContrastFlag
    s:eobj.DKBPekContrastFlag="Y" eobj.DKBPekContrastFlag="已映射"
    s:eobj.DKBPekContrastFlag="N" eobj.DKBPekContrastFlag="未映射"
    s:eobj.DKBPekContrastFlag="GU" eobj.DKBPekContrastFlag="放弃映射"
    s str = eobj.JsonS()    
    s str = "{list:["_str_"]}"
    q str
}

/// Function：数据重复验证方法,js调用
/// Creator： sunfengchao
/// CreatDate:2016-12-19
/// Table：   DKB_ICDPek
/// Input：   id, code, desc
/// Return：  "1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) 
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc)  
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DKBICDPEK(0,"Code",code))
    s:desc'="" flagd=$d(^DKBICDPEK(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DKBICDPEK(0,"Code",code,0))
        s:desc'="" idd=$o(^DKBICDPEK(0,"Desc",desc,0))
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
/// Table：      DKB_ICDPek
/// Input：      id, code, desc
/// Return：     "1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
    s flag="",flagc="",flagd=""
    s flagc=$d(^DKBICDPEK(0,"Code",code))
    s flagd=$d(^DKBICDPEK(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s idc=$o(^DKBICDPEK(0,"Code",code,0))
        s idd=$o(^DKBICDPEK(0,"Desc",desc,0))
        if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Description保存修改ICD诊断代码的内容
/// Creator：  sunfengchao
/// CreatDate: 2016-12-19
/// Table：    DKB_ICDPek
/// Input：    web.Entity.CT.DKBICDPek 实体类
/// Return：   成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:     d ##class(web.DHCBL.CT.DKBICDPek).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.DKBICDPek) As %String
{
    s $zt="ERROE"
    s result=""
    if $IsObject(eobj)
    {
        s:eobj.DKBPekValid="" eobj.DKBPekValid="N"
        s eobj.DKBPekValid = "Y"
        s:eobj.DKBPekMetastaticSite="" eobj.DKBPekMetastaticSite="N"
        s:eobj.DKBPekInjuryPoisoningCode="" eobj.DKBPekInjuryPoisoningCode="N"
        s:eobj.DKBPekBillFlag3="" eobj.DKBPekBillFlag3="N"
        s:eobj.DKBPekBillFlag1="" eobj.DKBPekBillFlag1="N"
        if eobj.DKBPekBillFlag1="Y" s eobj.DKBPekBillFlag3="Y"
        s:eobj.DKBPekICD9CMCode'="" eobj.DKBPekICD9CMCode=$ZCONVERT(eobj.DKBPekICD9CMCode,"U")  
        s:eobj.DKBPekDateActiveFrom'="" eobj.DKBPekDateActiveFrom=$zdh(eobj.DKBPekDateActiveFrom,15)  
        s:eobj.DKBPekDateActiveTo'="" eobj.DKBPekDateActiveTo=$zdh(eobj.DKBPekDateActiveTo,15)       
        s:eobj.DKBPekContrastFlag="已映射" eobj.DKBPekContrastFlag="Y"
        s:eobj.DKBPekContrastFlag="未映射" eobj.DKBPekContrastFlag="N"
        s:eobj.DKBPekContrastFlag="放弃映射" eobj.DKBPekContrastFlag="GU"
        s:eobj.DKBPekContrastFlag="" eobj.DKBPekContrastFlag="N"
        s flag=..Validate(eobj.DKBPekRowId,eobj.DKBPekCode,eobj.DKBPekDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.DKBPekRowId="")  
            {
                s obj=##class(User.DKBICDPek).%New()
            }
            else                     
            {
                s obj=##class(User.DKBICDPek).%OpenId(eobj.DKBPekRowId)
                s bobj=##class(web.Entity.CT.DKBICDPek).%New()
                s bobj.DKBPekRowId = eobj.DKBPekRowId
                s bobj.DKBPekCode = obj.DKBPekCode
                s bobj.DKBPekDesc = obj.DKBPekDesc
                s bobj.DKBPekICD9CMCode = obj.DKBPekICD9CMCode
                s bobj.DKBPekDateActiveFrom = obj.DKBPekDateActiveFrom
                s bobj.DKBPekDateActiveTo = obj.DKBPekDateActiveTo
                s bobj.DKBPekAgeFrom = obj.DKBPekAgeFrom
                s bobj.DKBPekAgeTo = obj.DKBPekAgeTo
                s bobj.DKBPek2ndCodeInPair = obj.DKBPek2ndCodeInPair
                
                if $IsObject(obj.DKBPekSexDR){
                    s:obj.DKBPekSexDR'="" bobj.DKBPekSexDR = obj.DKBPekSexDR.%Id() 
                }
                s bobj.DKBPekValid = obj.DKBPekValid
             
                s bobj.DKBPekICD9Map = obj.DKBPekICD9Map
                s bobj.DKBPekLongDescription = obj.DKBPekLongDescription
                s bobj.DKBPekMetastaticSite = obj.DKBPekMetastaticSite
                s bobj.DKBPekInjuryPoisoningCode = obj.DKBPekInjuryPoisoningCode
                s bobj.DKBPekBillFlag3 = obj.DKBPekBillFlag3
                s bobj.DKBPekBillFlag1 = obj.DKBPekBillFlag1
                s:bobj.DKBPekContrastFlag="Y" bobj.DKBPekContrastFlag="已映射"
                s:bobj.DKBPekContrastFlag="N" bobj.DKBPekContrastFlag="未映射"
                s:bobj.DKBPekContrastFlag="GU" bobj.DKBPekContrastFlag="放弃映射"
            }
            Ts                              
            s obj.DKBPekCode = eobj.DKBPekCode          //修改代码
            s obj.DKBPekDesc = eobj.DKBPekDesc          //修改描述
            s obj.DKBPekICD9CMCode = eobj.DKBPekICD9CMCode
            s obj.DKBPekDateActiveFrom = eobj.DKBPekDateActiveFrom
            s obj.DKBPekDateActiveTo = eobj.DKBPekDateActiveTo
            s obj.DKBPekAgeFrom = eobj.DKBPekAgeFrom
            s obj.DKBPekAgeTo = eobj.DKBPekAgeTo
            d obj.DKBPekSexDRSetObjectId(eobj.DKBPekSexDR)
            s obj.DKBPekValid = "Y"
            s obj.DKBPek2ndCodeInPair = eobj.DKBPek2ndCodeInPair
            s obj.DKBPekICD9Map = eobj.DKBPekICD9Map
            s obj.DKBPekLongDescription = eobj.DKBPekLongDescription
            s obj.DKBPekMetastaticSite = eobj.DKBPekMetastaticSite
            s obj.DKBPekInjuryPoisoningCode = eobj.DKBPekInjuryPoisoningCode
            s obj.DKBPekBillFlag1 = eobj.DKBPekBillFlag1
            s obj.DKBPekBillFlag3 = eobj.DKBPekBillFlag3
            s obj.DKBPekContrastFlag=eobj.DKBPekContrastFlag
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"         //返回RowId
                //保存日志
                d:eobj.DKBPekRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_ICDDx","User.DKBICDPek","ICD诊断代码北京版",id,eobj.DKBPekDesc,"A",eobj)
                d:eobj.DKBPekRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_ICDDx","User.DKBICDPek","ICD诊断代码北京版",eobj.DKBPekRowId,eobj.DKBPekDesc,"U",eobj,bobj) 
            }
            else
            {
                Trollback
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("ICD诊断代码北京版","web.DHCBL.CT.DKBICDPek","SaveEntity",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("ICD诊断代码北京版","web.DHCBL.CT.DKBICDPek","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：查询ICD诊断代码北京版 
/// CreatDate:   2016-12-19
/// Creator：    sunfengchao
/// Table：      DKB_ICDPek
/// Input：      rowid,code,desc
/// Debug:       w ##class(web.DHCBL.CT.DKBICDPek).GetList("","","","","0","20")
ClassMethod GetList(rowid As %String, code As %String, desc As %String, icd10 As %String, ConstrStaus As %String, start As %String, limit As %String) As %String
{
    if start="" s start=0
    if limit="" s limit=20
    if (rowid'="") 
    {
        s DKBPekRowId=rowid
        s DKBPekCode=$p($g(^DKBICDPEK(DKBPekRowId)),"^",1)
        s DKBPekDesc=$p($g(^DKBICDPEK(DKBPekRowId)),"^",2)
        s DKBPekICD9CMCode=$p($g(^DKBICDPEK(DKBPekRowId)),"^",3)
        s DKBPekDateActiveFrom=$p($g(^DKBICDPEK(DKBPekRowId)),"^",4)
        s DKBPekDateActiveTo=$p($g(^DKBICDPEK(DKBPekRowId)),"^",5)
        s DKBPekAgeFrom=$p($g(^DKBICDPEK(DKBPekRowId)),"^",6)
        s DKBPekAgeTo=$p($g(^DKBICDPEK(DKBPekRowId)),"^",7)
        s DKBPekSexDR=$p($g(^DKBICDPEK(DKBPekRowId)),"^",8)
        s:DKBPekSexDR'="" DKBPekSexDR=$p($g(^CT("SEX",DKBPekSexDR)),"^",2) //获取性别描述
        s DKBPekValid=$p($g(^DKBICDPEK(DKBPekRowId)),"^",9)
        s DKBPekICD9Map=$p($g(^DKBICDPEK(DKBPekRowId)),"^",10)
        s DKBPek2ndCodeInPair=$p($g(^DKBICDPEK(DKBPekRowId)),"^",11)
        
        s DKBPekLongDescription=$p($g(^DKBICDPEK(DKBPekRowId)),"^",12)
        s DKBPekMetastaticSite=$p($g(^DKBICDPEK(DKBPekRowId)),"^",13) //肿瘤形态学编码标志
        s DKBPekInjuryPoisoningCode=$p($g(^DKBICDPEK(DKBPekRowId)),"^",14) //损伤中毒外部原因标志
        s DKBPekBillFlag1=$p($g(^DKBICDPEK(DKBPekRowId)),"^",15) //中医证型标志
        s DKBPekBillFlag3=$p($g(^DKBICDPEK(DKBPekRowId)),"^",16) //中医诊断标志
        s DKBPekContrastFlag=$p($g(^DKBICDPEK(DKBPekRowId)),"^",17) //映射标志
        s:DKBPekContrastFlag="N" DKBPekContrastFlag="未映射"
        s:DKBPekContrastFlag="Y" DKBPekContrastFlag="已映射"
        s:DKBPekContrastFlag="GU" DKBPekContrastFlag="放弃映射"
        s:DKBPekDateActiveFrom'="" DKBPekDateActiveFrom=$zd(DKBPekDateActiveFrom,1) //转换日期格式
        s:DKBPekDateActiveTo'="" DKBPekDateActiveTo=$zd(DKBPekDateActiveTo,1) //转换日期格式
     
        s strResult= "{""DKBPekRowId"":"""_DKBPekRowId_""",""DKBPekCode"":"""_DKBPekCode_""",""DKBPekDesc"":"""_DKBPekDesc_""",""DKBPekICD9CMCode"":"""_DKBPekICD9CMCode_""",""DKBPekDateActiveFrom"":"""_DKBPekDateActiveFrom_""",""DKBPekDateActiveTo"":"""_DKBPekDateActiveTo_""",""DKBPekAgeFrom"":"""_DKBPekAgeFrom_""",""DKBPekAgeTo"":"""_DKBPekAgeTo_""",""DKBPekSexDR"":"""_DKBPekSexDR_""",""DKBPekValid"":"""_DKBPekValid_""",""DKBPekICD9Map"":"""_DKBPekICD9Map_""",""DKBPek2ndCodeInPair"":"""_DKBPek2ndCodeInPair_""",""DKBPekLongDescription"":"""_DKBPekLongDescription_""",""DKBPekMetastaticSite"":"""_DKBPekMetastaticSite_""",""DKBPekInjuryPoisoningCode"":"""_DKBPekInjuryPoisoningCode_""",""DKBPekBillFlag1"":"""_DKBPekBillFlag1_""",""DKBPekBillFlag3"":"""_DKBPekBillFlag3_""",""DKBPekContrastFlag"":"""_DKBPekContrastFlag_"""}"
        s strResult="{""total"":""1"",""success"":""true"",""data"":["_strResult_"]}"
    }
    else
    {
        s:code'="" code=$ZCVT(code,"U") 
        s:desc'="" desc=$ZCVT(desc,"U")  
        s:icd10'="" icd10=$ZCONVERT(icd10,"U") 
        s count2=0, strResult=""
        s start=start+1       
        s DKBPekRowId=0
        for 
        {
            s DKBPekRowId=$o(^DKBICDPEK(DKBPekRowId))
            q:DKBPekRowId=""
 
            s DKBPekCode=$p($g(^DKBICDPEK(DKBPekRowId)),"^",1)
            s DKBPekDesc=$p($g(^DKBICDPEK(DKBPekRowId)),"^",2)
            continue:(DKBPekCode="-")||(DKBPekDesc="-") //屏蔽垃圾数据
            s DKBPekICD9CMCode=$p($g(^DKBICDPEK(DKBPekRowId)),"^",3)
            s DKBPekValid=$p($g(^DKBICDPEK(DKBPekRowId)),"^",9)
            continue:DKBPekValid="N"
            s PINYIN="" ; (ALIASText1[desc)||
            s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(DKBPekDesc)
            s DKBPekContrastFlag=$p($g(^DKBICDPEK(DKBPekRowId)),"^",17) //映射标志
            if ($zcvt(DKBPekCode,"U")[code)&((PINYIN[desc)||($ZCVT(DKBPekDesc,"U")[desc))&($ZCVT(DKBPekICD9CMCode,"U")[icd10)&(DKBPekContrastFlag[ConstrStaus)
            {
                s count2=count2+1
                if (count2<start) continue
                if ((count2<(start+limit)))
                {     
                    s DKBPekICD9CMCode=$p($g(^DKBICDPEK(DKBPekRowId)),"^",3)
                    s DKBPekDateActiveFrom=$p($g(^DKBICDPEK(DKBPekRowId)),"^",4)
                    s DKBPekDateActiveTo=$p($g(^DKBICDPEK(DKBPekRowId)),"^",5)
                    s DKBPekAgeFrom=$p($g(^DKBICDPEK(DKBPekRowId)),"^",6)
                    s DKBPekAgeTo=$p($g(^DKBICDPEK(DKBPekRowId)),"^",7)
                    s DKBPekSexDR=$p($g(^DKBICDPEK(DKBPekRowId)),"^",8)
                    s:DKBPekSexDR'="" DKBPekSexDR=$p($g(^CT("SEX",DKBPekSexDR)),"^",2) //获取性别描述
                    s DKBPekValid=$p($g(^DKBICDPEK(DKBPekRowId)),"^",9)
                    s DKBPekICD9Map=$p($g(^DKBICDPEK(DKBPekRowId)),"^",10)
                    s DKBPek2ndCodeInPair=$p($g(^DKBICDPEK(DKBPekRowId)),"^",11)
        
                    s DKBPekLongDescription=$p($g(^DKBICDPEK(DKBPekRowId)),"^",12)
                    s DKBPekMetastaticSite=$p($g(^DKBICDPEK(DKBPekRowId)),"^",13) //肿瘤形态学编码标志
                    s DKBPekInjuryPoisoningCode=$p($g(^DKBICDPEK(DKBPekRowId)),"^",14) //损伤中毒外部原因标志
                    s DKBPekBillFlag1=$p($g(^DKBICDPEK(DKBPekRowId)),"^",15) //中医证型标志
                    s DKBPekBillFlag3=$p($g(^DKBICDPEK(DKBPekRowId)),"^",16) //中医诊断标志
                    s:DKBPekDateActiveFrom'="" DKBPekDateActiveFrom=$zd(DKBPekDateActiveFrom,1) //转换日期格式
                    s:DKBPekDateActiveTo'="" DKBPekDateActiveTo=$zd(DKBPekDateActiveTo,1) //转换日期格式
                    s:DKBPekContrastFlag="N" DKBPekContrastFlag="未映射"
                    s:DKBPekContrastFlag="Y" DKBPekContrastFlag="已映射"
                    s:DKBPekContrastFlag="GU" DKBPekContrastFlag="放弃映射"
                    if (strResult'="") 
                    {
                        s strResult=strResult_",{""DKBPekRowId"":"""_DKBPekRowId_""",""DKBPekCode"":"""_DKBPekCode_""",""DKBPekDesc"":"""_DKBPekDesc_""",""DKBPekICD9CMCode"":"""_DKBPekICD9CMCode_""",""DKBPekDateActiveFrom"":"""_DKBPekDateActiveFrom_""",""DKBPekDateActiveTo"":"""_DKBPekDateActiveTo_""",""DKBPekAgeFrom"":"""_DKBPekAgeFrom_""",""DKBPekAgeTo"":"""_DKBPekAgeTo_""",""DKBPekSexDR"":"""_DKBPekSexDR_""",""DKBPekValid"":"""_DKBPekValid_""",""DKBPekICD9Map"":"""_DKBPekICD9Map_""",""DKBPek2ndCodeInPair"":"""_DKBPek2ndCodeInPair_""",""DKBPekLongDescription"":"""_DKBPekLongDescription_""",""DKBPekMetastaticSite"":"""_DKBPekMetastaticSite_""",""DKBPekInjuryPoisoningCode"":"""_DKBPekInjuryPoisoningCode_""",""DKBPekBillFlag1"":"""_DKBPekBillFlag1_""",""DKBPekBillFlag3"":"""_DKBPekBillFlag3_""",""DKBPekContrastFlag"":"""_DKBPekContrastFlag_"""}"
                    }
                    else
                    {  
                        s strResult= "{""DKBPekRowId"":"""_DKBPekRowId_""",""DKBPekCode"":"""_DKBPekCode_""",""DKBPekDesc"":"""_DKBPekDesc_""",""DKBPekICD9CMCode"":"""_DKBPekICD9CMCode_""",""DKBPekDateActiveFrom"":"""_DKBPekDateActiveFrom_""",""DKBPekDateActiveTo"":"""_DKBPekDateActiveTo_""",""DKBPekAgeFrom"":"""_DKBPekAgeFrom_""",""DKBPekAgeTo"":"""_DKBPekAgeTo_""",""DKBPekSexDR"":"""_DKBPekSexDR_""",""DKBPekValid"":"""_DKBPekValid_""",""DKBPekICD9Map"":"""_DKBPekICD9Map_""",""DKBPek2ndCodeInPair"":"""_DKBPek2ndCodeInPair_""",""DKBPekLongDescription"":"""_DKBPekLongDescription_""",""DKBPekMetastaticSite"":"""_DKBPekMetastaticSite_""",""DKBPekInjuryPoisoningCode"":"""_DKBPekInjuryPoisoningCode_""",""DKBPekBillFlag1"":"""_DKBPekBillFlag1_""",""DKBPekBillFlag3"":"""_DKBPekBillFlag3_""",""DKBPekContrastFlag"":"""_DKBPekContrastFlag_"""}"
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
/// Table：      DKB_ICDPek
/// Input：      rowid,code,desc
/// Return：     DKBPekRowId,DKBPekCode,DKBPekDesc
/// Other:       d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DKBICDPek","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, icd10 As %String) As %Query(ROWSPEC = "DKBPekRowId:%String,DKBPekCode:%String,DKBPekDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, icd10 As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    if (rowid'="")
    {
        s DKBPekRowId=rowid
        s DKBPekCode=$p($g(^DKBICDPEK(DKBPekRowId)),"^",1)
        s DKBPekDesc=$p($g(^DKBICDPEK(DKBPekRowId)),"^",2)
        d OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCVT(code,"U")  
        s:desc'="" desc=$ZCVT(desc,"U") 
        s DKBPekRowId=0
        for
        {
            s DKBPekRowId=$o(^DKBICDPEK(DKBPekRowId))
            q:DKBPekRowId=""
            s DKBPekCode=$p($g(^DKBICDPEK(DKBPekRowId)),"^",1)
            s DKBPekDesc=$p($g(^DKBICDPEK(DKBPekRowId)),"^",2)
            continue:(DKBPekCode="-")||(DKBPekDesc="-") //屏蔽垃圾数据
            s PINYIN=""
            s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(DKBPekDesc)
            if ($ZCVT(DKBPekCode,"U")[code)&((PINYIN[desc)||($ZCVT(DKBPekDesc,"U")[desc))
            {
                d OutputRowCmb
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(DKBPekRowId,DKBPekCode,DKBPekDesc)
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
/// Debug:      w ##class(web.DHCBL.CT.DKBICDPek).GetContrastList(1,"",0,10)
ClassMethod GetContrastList(id As %String, desc As %String, start As %String, limit As %String) As %String
{
	  s strResult="", count=0
	  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc)
	  if (id'=""){
	  s DKBPekCode=$p($g(^DKBICDPEK(id)),"^",1)
	  s start=start+1  
	  if ($d(^DKBICDCONPEK(0,"PekCode"))>0)
	  {
		  s DKBPekRowId=0
		  for
		  {
		    s DKBPekRowId=$o(^DKBICDCONPEK(0,"PekCode",DKBPekCode,DKBPekRowId))
		    q:DKBPekRowId=""
   
		    s DKBDiCode=$p($g(^DKBICDCONPEK(DKBPekRowId)),"^",1)
		    s DKBDiDesc=$p($g(^DKBICDCONPEK(DKBPekRowId)),"^",2)
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
