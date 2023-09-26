Import sqluser

Class web.DHCST.PHAINSTATTYPESET Extends (%RegisteredObject, StkTypeG)
{

Parameter AppTable = "PHAIN_StatType";

/// Creator：   zhaoxinlong
/// CreatDate： 20190123    
/// Table：     PHAIN_StatType
/// description:报表类型列表
/// others:     
/// input:  
/// d ##class(%ResultSet).RunQuery("web.DHCST.PHAINSTATTYPESET","QueryStatType","10")
Query QueryStatType(inputStr = "") As websys.Query(ROWSPEC = "rowid,code,desc,remarks")
{
}

ClassMethod QueryStatTypeExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
    //s ^YSJTMP("QueryStatTypeExecute")=inputStr
    s HospId=$P(inputStr,"^",1)
    i (HospId="")&&($d(%session)) s HospId=$g(%session.Data("LOGON.HOSPID")) 
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT PINST_RowID AS rowid, PINST_Code AS code ,PINST_Desc AS PINSTdesc, PINST_Remarks AS remarks  FROM PHAIN_StatType "
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s rowid= result.Data("rowid") 
        continue:(HospId'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("PHAIN_StatType",rowid,HospId)="N")
        //w ##class(PHA.FACE.IN.Com).GetShowDataFlag("PHAIN_StatType",rowid,HospId),!
        s code= result.Data("code") 
        continue:(code="")
        s desc= result.Data("PINSTdesc") 
        s remarks= result.Data("remarks") 
        s Data=$lb(rowid,code,desc,remarks)
        s ^CacheTemp(repid,ind)=Data    
        s ind=ind+1
    }
    d result.Close()
    Quit $$$OK
}

/// description: 保存报表类型
/// w ##Class(web.DHCST.PHAINSTATTYPESET).SaveStatType("2^11^1232^^2")
ClassMethod SaveStatType(inputData)
{
    //s ^YSJTMP("SaveStatType")=inputData
    q:inputData="" "-1^没有需要保存的数据"
    s errCode=""
    s inputLen=$l(inputData,"!!")
    f inputI=1:1:inputLen d
    .s iData=$p(inputData,"!!",inputI)
    .q:iData=""
    .s saveRet=..SaveType(iData)
    .i $p(saveRet,"^",1)<0 d
    ..s saveErrInfo=$p(saveRet,"^",2)
    ..i errCode="" s errCode="-1^"_saveErrInfo
    ..e  s errCode=errCode_"</br>"_saveErrInfo
    q:errCode'="" errCode
    q 0
}

/// description: 保存报表类型(代码作为唯一标识，名称不要求)
/// input:       inputStr^1:描述
/// return:      +ret=0 成功
/// w ##class(web.DHCST.PHAINSTATTYPESET).SaveType("焕娟测试")
ClassMethod SaveType(inputStr)
{
    
    s pinst=$p(inputStr,"^",1)
    s code=$p(inputStr,"^",2)
    s desc=$p(inputStr,"^",3)
    s remarks=$p(inputStr,"^",4)
    s HospId =$p(inputStr,"^",5)  
    q:(code="") "-1^代码不能为空"
    q:(desc="") "-1^名称不能为空"
    s errCode=""
    
    s errCode = ##class(PHA.IN.COM.DataCheck).CheckRepeat(..#AppTable, code, desc, HospId, pinst)  
    e  s errCode=..CheckPINSTExist(pinst,code,desc,HospId)
    q:errCode'="" errCode
    
    s dataJosn = ..UniteTypeData(code, desc, remarks)
    s statement = ##class(PHA.COM.SqlByJson).%New("User.PHAINStatType")
    d statement.SaveInLog(dataJosn, pinst, "药房药库-药品自定义分类-大类", desc)
    i (statement.success '= "Y")  q "-1^"_statement.message
    s pinst = statement.data
    s ret = ##class(PHA.FACE.IN.Com).SaveBasicDataHosp("PHAIN_StatType", pinst, HospId)
    i (ret '= 1) q "-1^数据院区授权失败"
    q 0_"^保存成功"
}

ClassMethod UniteTypeData(code, desc, remarks)
{
    s dataJosn = {}    
    d dataJosn.%Set("PINST_Code", code)
    d dataJosn.%Set("PINST_Desc", desc)
    d dataJosn.%Set("PINST_Remarks", remarks)
    q dataJosn
}

/// Description:判断报表类型的名称和代码是否重复
///  w ##class(web.DHCST.PHAINSTATTYPESET).CheckPINSTExist("11","11",2) 
ClassMethod CheckPINSTExist(pinst, code, desc, hopid)
{
    s ret=""
    q:hopid="" ret
    s PINST=""
    f  s PINST=$O(^CD.PHA.IN.STAT(PINST)) q:(PINST="")||(ret'="")  d
    .q:+PINST=0
    .q:pinst=PINST
    .s tmpCode=$P(^CD.PHA.IN.STAT(PINST),"^",1)
    .s tmpDesc=$P(^CD.PHA.IN.STAT(PINST),"^",2)
    .s existFlag=""
    .i (code'="")&&(code=tmpCode)  s existFlag=##class(PHA.FACE.IN.Com).GetShowDataFlag("PHAIN_StatType",PINST,hopid)
    .i existFlag="Y"  s ret="-10^代码重复:"_code
    .q:ret'=""
    .i (desc'="")&&(desc=tmpDesc)  s existFlag=##class(PHA.FACE.IN.Com).GetShowDataFlag("PHAIN_StatType",PINST,hopid)
    .i existFlag="Y"  s ret="-11^描述重复:"_desc
    .q:ret'=""
    q ret
}

/// description: 删除报表类型
/// w ##class(web.DHCST.PHAINSTATTYPESET).DeleteType("28")
ClassMethod DeleteType(pinst)
{
    q:(pinst = "") "-1^Id为空"
    s msg = ""
    q:('..CanDeleteType(pinst, .msg)) -2 _"^" _ msg
    
    ts
    
    /* 删除表数据 */
    s desc = $p(^CD.PHA.IN.STAT(pinst), "^", 2)
    s statement = ##class(PHA.COM.SqlByJson).%New("User.PHAINStatType")
    d statement.DeleteInLog(pinst, "药房药库-药品自定义分类-大类", desc)
    i (statement.success '= "Y")  tro  return "-1^"_statement.message
    
    tc
    q 0
}

ClassMethod CanDeleteType(pinst, msg = "")
{
    s itm = $o(^CD.PHA.IN.STAT(pinst, "C" , 0))
    if (itm '= ""){
        s msg = "包含自定分类小类,不允许删除"
        q $$$NO
    }
    q $$$YES
}

/// Creator：zhaoxinlong
/// CreatDate：20190123    
/// Table：PHAIN_StatCat
/// description:报表类型分类列表
/// others:     
/// input:  
/// d ##class(%ResultSet).RunQuery("web.DHCST.PHAINSTATTYPESET","QueryStatTypeCat","1")
Query QueryStatTypeCat(pinst) As websys.Query(ROWSPEC = "rowid,code,desc")
{
}

ClassMethod QueryStatTypeCatExecute(ByRef qHandle As %Binary, pinst) As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    Q:pinst="" $$$OK
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT PINSC_RowID AS rowid, PINSC_Code AS code ,PINSC_Desc AS PINSCdesc FROM PHAIN_StatCat where PINSC_ST_Parref="_pinst
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s rowid= result.Data("rowid") 
        s code= result.Data("code") 
        s desc= result.Data("PINSCdesc") 
        s Data=$lb(rowid,code,desc)
        s ^CacheTemp(repid,ind)=Data    
        s ind=ind+1
    }
    d result.Close()
    Quit $$$OK
}

/// description: 保存报表类型子分类
ClassMethod SaveStatTypeCat(inputData)
{
    q:inputData="" "-1^没有需要保存的数据"
    s errCode=""
    s inputLen=$l(inputData,"!!")
    f inputI=1:1:inputLen d
    .s iData=$p(inputData,"!!",inputI)
    .q:iData=""
    .s saveRet=..SaveTypeCat(iData)
    .i $p(saveRet,"^",1)<0 d
    ..s saveErrInfo=$p(saveRet,"^",2)
    ..i errCode="" s errCode="-1^"_saveErrInfo
    ..e  s errCode=errCode_"</br>"_saveErrInfo
    q:errCode'="" errCode
    q 0
}

/// description: 保存报表分类
/// input:       inputStr：
/// w ##class(web.DHCSTPIVAS.OrderLink).SavePivasCat("^35^1")
ClassMethod SaveTypeCat(inputStr)
{
    s pinst=$p(inputStr,"^",1)
    s pinsc=$p(inputStr,"^",2)
    s code=$p(inputStr,"^",3)
    s desc=$p(inputStr,"^",4)
    q:code="" "-1^代码不能为空"
    q:desc="" "-1^名称不能为空"
    s errCode=""
    
    s sub = $p(pinsc, "||", 2)
    i pinsc=""  d
    .&SQL(SELECT * FROM PHAIN_StatCat WHERE PINSC_ST_Parref=:pinst and PINSC_Code=:code)
    .i SQLCODE=0 return errCode="-1^该分类代码已存在" 
    .s sub = $o(^CD.PHA.IN.STAT(pinst, "C", ""), -1) + 1
    
    s dataJosn = ..UniteTypeCatData(pinst, sub, code, desc)
    s statement = ##class(PHA.COM.SqlByJson).%New("User.PHAINStatCat")
    d statement.SaveInLog(dataJosn, pinsc, "药房药库-药品自定义分类-小类", desc)
    i (statement.success '= "Y")  q "-1^"_statement.message
    
    q 0_"^保存成功"
}

ClassMethod UniteTypeCatData(pinst, sub, code, desc)
{
    s dataJosn = {}    
    
    d dataJosn.%Set("PINSC_ST_Parref", pinst)
    d dataJosn.%Set("PINSC_ChildSub", sub)
    d dataJosn.%Set("PINSC_Code", code)
    d dataJosn.%Set("PINSC_Desc", desc)
    q dataJosn
}

/// description: 删除报表类型
/// w ##class(web.DHCST.PHAINSTATTYPESET).DeletePIVAOrderLink("34")
ClassMethod DeleteTypeCat(pinsc)
{
    q:(pinsc = "") "-1^Id为空"
    q:('..CanDeleteTypeCat(pinsc, .msg)) -2 _"^" _ msg
    ts
    
    /* 删除表数据 */
    s desc = $p(^CD.PHA.IN.STAT(+pinsc, "C", $p(pinsc, "||", 2)), "^", 2)
    s statement = ##class(PHA.COM.SqlByJson).%New("User.PHAINStatCat")
    d statement.DeleteInLog(pinsc, "药房药库-药品自定义分类-小类", desc)
    i (statement.success '= "Y")  tro  return "-1^"_statement.message

    tc
    q 0
}

ClassMethod CanDeleteTypeCat(pinsc, msg = "")
{
    s pinst = +pinsc 
    s itm = $p(pinsc, "||", 2)
    s sub = $o(^CD.PHA.IN.STAT(pinst, "C", itm, "D", 0))
    if (sub '= ""){
        s msg = "小类包含药品,不允许删除"
        q $$$NO
    }
    q $$$YES
}

/// Creator：zhaoxinlong
/// CreatDate：20190123    
/// Table：Inc_itm
/// description:库存项中所有未分类药品
/// others:     
/// input:  
/// d ##class(%ResultSet).RunQuery("web.DHCST.PHAINSTATTYPESET","QueryInci","13||1!!!!10")
Query QueryInci(inputStr) As websys.Query(ROWSPEC = "rowid,code,desc,operate")
{
}

ClassMethod QueryInciExecute(ByRef qHandle As %Binary, inputStr) As %Status
{
    //s ^zhxl("QueryInci")=$lb(inputStr)
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    Q:inputStr="" $$$OK
    s pinsc=$p(inputStr,"!!",1)
    s incAlias=$p(inputStr,"!!",2)
    s HospId=$p(inputStr,"!!",3)
    i incAlias'="" s incAlias=$ZCVT(incAlias,"U")
    Q:pinsc="" $$$OK
    s inci=0
    s operate="0"
    f  s inci=$o(^INCI(inci))  Q:(inci="")||(inci=0)  d
    .q:'$d(^INCI(+inci,1))
    .Q:$d(^CD.PHA.IN.STAT("INCI",inci,+pinsc,$p(pinsc,"||",2)))
    .s Ret=$$checkAlias(incAlias,inci)
    .Q:Ret'=1
    .s incicode=$p(^INCI(inci,1),"^",1)
    .s incidesc=$p(^INCI(inci,1),"^",2) 
    .s stkgrpinfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
    .s arc=$P(^INCI(inci,1),"^",3)
    .q:arc=""
    .q:(HospId'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("ARC_ItmMast",arc,HospId)="N")
    .s grptype=$p(stkgrpinfo,"^",3)
    .q:grptype'=..sssCode()
    .s NotUseFlag=$p(^INCI(inci,2),"^",9)
    .q:NotUseFlag="Y"
    .s Data=$lb(inci,incicode,incidesc,operate)
    .s ^CacheTemp(repid,ind)=Data    
    .s ind=ind+1
  
    Quit $$$OK
checkAlias(incAlias,inci)
 s ret=0
 s alias=""
 f  s alias=$o(^INCALIAS(0,"INCI",inci,alias))  Q:alias=""||(ret=1)  d
 .s alitext=$p(^INCALIAS(alias),"^",4)
 .s alitext=$ZCVT(alitext,"U")
 .i $f(alitext,incAlias)  s ret=1
 q ret
}

/// Creator：zhaoxinlong
/// CreatDate：20190123    
/// Table：Inc_itm
/// description：报表分类下的已分类药品
/// others:     
/// input:  
/// d ##class(%ResultSet).RunQuery("web.DHCST.PHAINSTATTYPESET","QueryStatInci","3||3")
Query QueryStatInci(pinsc = "") As websys.Query(ROWSPEC = "rowid,code,desc,operate")
{
}

ClassMethod QueryStatInciExecute(ByRef qHandle As %Binary, pinsc = "") As %Status
{
    ;s ^zhxl("QueryStatInci")=$lb(pinsc)
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    Q:pinsc="" $$$OK
    s pinst=$p(pinsc,"||",1)
    s chil=$p(pinsc,"||",2)
    Q:(chil="")||(pinst="") $$$OK
    s operate="1"
    s sub=""
    f  s sub=$o(^CD.PHA.IN.STAT(pinst,"C",chil,"D",sub))  Q:sub=""  d
    .s inci=$p(^CD.PHA.IN.STAT(pinst,"C",chil,"D",sub),"^",1)
    .q:'$d(^INCI(+inci,1))
    .s incicode=$p(^INCI(inci,1),"^",1)
    .s incidesc=$p(^INCI(inci,1),"^",2)
    .s pinsd=pinst_"||"_chil_"||"_sub
    .s Data=$lb(pinsd,incicode,incidesc,operate)
    .s ^CacheTemp(repid,ind)=Data    
    .s ind=ind+1
  
    Quit $$$OK
}

/// w ##class(web.DHCST.PHAINSTATTYPESET).addInci("4||1","41")
ClassMethod addInci(pinsc, inci) As %String
{
    ;s ^zhxl("addInci")=$lb(pinsc, inci)
    Q:(pinsc="")||(inci)="" "-1^数据为空"
    s pinst=$p(pinsc,"||",1) 
    s chil=$p(pinsc,"||",2) 
    Q:(chil="")||(pinst="") "-1^数据为空"
    s errCode=""
    &SQL(SELECT * FROM PHAIN_StatCat WHERE PINSC_RowID=:pinsc)
    i SQLCODE'=0 s errCode="-2^该报表分类不存在"
    q:errCode'="" errCode
    &SQL(SELECT * FROM PHAIN_StatDetail WHERE PINSD_SC_Parref =:pinsc and PINSD_INCI_Dr =:inci )
    i SQLCODE=0 s errCode="-2^该报表分类下已存在该药品"
    q:errCode'="" errCode
    s sub = $o(^CD.PHA.IN.STAT(pinst, "C", chil, "D", ""), -1) + 1
    
    s inciDesc = $p(^INCI(inci, 1), "^", 2)
    s dataJosn = ..UniteInciData(pinsc, sub, inci)
    s statement = ##class(PHA.COM.SqlByJson).%New("User.PHAINStatDetail")
    d statement.SaveInLog(dataJosn, "", "药房药库-药品自定义分类-药品", inciDesc)
    i (statement.success '= "Y")  q "-1^"_statement.message

    q 0_"^成功"
}

ClassMethod UniteInciData(pinsc, sub, inci)
{
    s dataJosn = {}    
    
    d dataJosn.%Set("PINSD_SC_Parref", pinsc)
    d dataJosn.%Set("PINSD_ChildSub", sub)
    d dataJosn.%Set("PINSD_INCI_Dr", inci)
    q dataJosn
}

/// creator:     zhaoxinlong
/// createdate:  20190124
/// description: 删除药品
ClassMethod delInci(pinsd)
{
    q:(pinsd = "") "-1^Id为空"
    ts
    
    /* 删除表数据 */
    s inci = $p(^CD.PHA.IN.STAT(+pinsd,"C", $p(pinsd, "||", 2), "D", $p(pinsd, "||", 3)), "^", 1)
    s inciDesc = $p(^INCI(inci, 1), "^", 2)
    s statement = ##class(PHA.COM.SqlByJson).%New("User.PHAINStatDetail")
    d statement.DeleteInLog(pinsd, "药房药库-药品自定义分类-小类", inciDesc)
    i (statement.success '= "Y")  tro  return "-1^"_statement.message
    
    b //tc
    tc
    q 0
}

/// creator:zhaoxinlong   2020-01-03
/// description:获取已维护的药品分类标识获取,统一公共方法
/// input：库存项id,报表类型代码,报表分类代码
/// return:Y--存在， N--不存在
/// w ##class(web.DHCST.PHAINSTATTYPESET).GetDrugFlag(530,"002","JCZXYP")
ClassMethod GetDrugFlag(Inci, TypeCode, CatCode)
{
    q:(TypeCode="")||(CatCode="") "N"
    s pinsc=""
    &sql(SELECT PINST_RowID into:pinsc FROM SQLUser.PHAIN_StatType where PINST_Code=:TypeCode )
    q:pinsc="" "N"
    s chilsub=""
    &sql(SELECT PINSC_ChildSub into:chilsub  FROM SQLUser.PHAIN_StatCat WHERE PINSC_ST_Parref=:pinsc  AND PINSC_Code=:CatCode  )
    q:chilsub="" "N"
    q:Inci="" "N"
    i $d(^CD.PHA.IN.STAT("INCI",Inci,pinsc,chilsub))  s ret="Y" 
    e  s ret="N"
    q ret
}

}
