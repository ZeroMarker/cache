Import SQLUser

///  Function:医嘱限制
///  Creator: sunfengchao
///  CreateDate:2018-06-11
Class web.DHCBL.CT.DHCArcItemAut Extends %RegisteredObject
{

/// Function:   根据type去查询不同的程序 实现级联功能
/// Creator:    sunfengchao
/// CreateDate: 2018-06-21 
/// Others:     type 是为了在修改时重新加载combox的store才使用的入参，这个参数是从前台传过来
/// Debug:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCArcItemAut","GetComboList","","","KS","")
Query GetComboList(rowid As %String, desc As %String, Type As %String, hospid As %String) As %Query(ROWSPEC = "RowId:%String,QtyDesc:%String")
{
}

ClassMethod GetComboListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, Type As %String, hospid As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1 
   s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag() //医院级授权
   if (rowid'="")
   {
       s RowId= rowid
       if (Type="HP") // 医院 
       {  
            s QtyDesc=$p($g(^CT("HOSP",RowId)),"^",2) 
            d OutputRowCombo 
        }
       elseif (Type="KS")
       { 
           ; 查询科室 
           S QtyDesc=$P(^CTLOC(RowId),"^",2)
           d OutputRowCombo 
       }
       elseif (Type="YS") // 医生
       { 
           S QtyDesc=$p($g(^CTPCP(RowId,1)),"^",1)_"-"_$p($g(^CTPCP(RowId,1)),"^",2)   
           d OutputRowCombo        
       }
       elseif (Type="ZC") // 职称
       { 
            s QtyDesc=$p(^CT("CPT",RowId),"^",2)
            d OutputRowCombo  
       }
       elseif (Type="JB") //级别
       {  
            s QtyDesc=$p($g(^CT("EMF",RowId)),"^",2) 
            d OutputRowCombo 
        }
   }
   else
   { 
       S desc=$ZCVT(desc,"U")
       if (Type="KS")
       { 
            //获取授权Json
            s AuStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
            s AuRBCDepartmentGroupStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByDefaultSession()
            s AuCTHospitalStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
            
            
            ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
            ;假设未授权情况下默认全部显示数据
            s AuFlag=0
            if (AuStr="")||(AuStr["limited:0") s AuFlag=1
            s AuRBCDepartmentGroupFlag=0
            if (AuRBCDepartmentGroupStr="")||(AuRBCDepartmentGroupStr["limited:0") s AuRBCDepartmentGroupFlag=1
            s AuCTHospitalFlag=0
            if (AuCTHospitalStr="")||(AuCTHospitalStr["limited:0") s AuCTHospitalFlag=1
            ; 查询 CTLOC  科室 
            s CTLOCRowID=0
            for  
            {
                s CTLOCRowID=$O(^CTLOC(CTLOCRowID))   
                q:CTLOCRowID="" 
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlagSpecial("CT_Loc",CTLOCRowID,hospid,"","ARC_ItmMast")
                continue:showflag="N"
                s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
                s CTLOCDepDR=$p($g(^CTLOC(CTLOCRowID)),"^",19)      //科室部分组 
                
                s strRowId = "{ID:"_CTLOCRowID_"}"
                s strCTLOCDepDR = "{ID:"_CTLOCDepDR_"}"
                s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"

                if ((AuStr[strRowId)||(AuFlag=1))&&((AuRBCDepartmentGroupStr[strCTLOCDepDR)||(AuRBCDepartmentGroupFlag=1))&&((AuCTHospitalStr[strHospitalID)||(AuCTHospitalFlag=1))&&((AuHospStr="off")||(AuHospStr[strHospitalID)||(AuHospStr=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
                {
                    S LocHospDr=$P(^CTLOC(CTLOCRowID),"^",22) 
                    S LocCode=$P(^CTLOC(CTLOCRowID),"^",1)
                    S LocDesc=$P(^CTLOC(CTLOCRowID),"^",2)
                    s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)    //截止日期
                    continue:(CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)
                
                    s PINYIN=""
                    s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(LocDesc)
                    if (($ZCVT(LocDesc,"u")[desc)||(PINYIN[desc)) &&(((hospid="")||(((hospid'="")&&(CTLOCHospitalDR=hospid)))))
                    {
                        s RowId= CTLOCRowID
                        s QtyDesc=LocDesc 
                        d OutputRowCombo
                    }
                }
            }     
       }
       elseif (Type="YS") // 医生 
       {
        s RowId=0
        for  
        {               
            s RowId=$o(^CTPCP(RowId)) 
            q:RowId="" 
            S QtyDesc=$p($g(^CTPCP(RowId,1)),"^",1)_"-"_$p($g(^CTPCP(RowId,1)),"^",2)
           
            s CTPCPCarPrvTpDR=$p($g(^CTPCP(RowId,1)),"^",4)    //人员类型ID
            if CTPCPCarPrvTpDR'=""
            {
                s CTCPTInternalType=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)    
                CONTINUE:CTCPTInternalType'="DOCTOR"
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlagSpecial("CT_CareProv",RowId,hospid,"","ARC_ItmMast")
                continue:showflag="N"
                
                s SSUSRRowId=$o(^SSU("SSUSR",0,"CTPCP",RowId,0))
                if SSUSRRowId'=""
                {
                    s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活
                    s SSUSRDateTo=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",97)  //结束日期
                    continue:SSUSRActive="N"
                    continue:(SSUSRDateTo'="")&&(SSUSRDateTo<+$h)
                    s CTPCPActiveFlag=$p($g(^CTPCP(RowId,1)),"^",9)      //是否激活
                    s CTPCPDateActiveTo=$p($g(^CTPCP(RowId,2)),"^",15)     //结束日期
                    continue:CTPCPActiveFlag="N"
                    continue:(CTPCPDateActiveTo'="")&&(CTPCPDateActiveTo<+$h)   
                    s PINYIN=""
                    s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(QtyDesc)
                    if (($zcvt(QtyDesc,"U")[desc)||(PINYIN[desc)) 
                    { 
                       d OutputRowCombo
                    }  
                }
                
                
            }
        }       
       }
       elseif (Type="ZC")
       {
            s CptDr="0" 
            for
            {
              s CptDr=$o(^CT("CPT",CptDr)) 
              q:CptDr=""  
              s CTCPTDateTo=$p($g(^CT("CPT",CptDr)),"^",6)
              continue:(CTCPTDateTo'="")&&(CTCPTDateTo<+$h)
              s CptName=$p(^CT("CPT",CptDr),"^",2)
              s PINYIN=""
              s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CptName)
              if (CptName'="")&(($ZCVT(CptName,"u")[desc)||(PINYIN[desc)) 
              {
                   s RowId= CptDr
                   s QtyDesc=CptName
                   d OutputRowCombo
              }
           }   
       }
       elseif (Type="JB")
       { 
           s CTEMFRowID=0
           for
           {
             s CTEMFRowID=$o(^CT("EMF",CTEMFRowID)) 
             q:CTEMFRowID=""  
             s CTEMFDesc=$p($g(^CT("EMF",CTEMFRowID)),"^",2) 
             s PINYIN=""
             s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTEMFDesc) 
             if (CTEMFDesc'="")&(($zcvt(CTEMFDesc,"U")[desc)||(PINYIN[desc)) 
              {
                   s RowId= CTEMFRowID
                   s QtyDesc=CTEMFDesc
                   d OutputRowCombo
              }
           }     
       }
       elseif (Type="HP") // 医院 
       {    
            s result=##class(%ResultSet).%New()
            s result.ClassName="web.DHCBL.BDP.BDPMappingHOSP"
            s result.QueryName="GetHospDataForGroup"
            if (result)
            { 
                s sc=result.Execute("","","DHC_ArcItemAut","",hospid,"ARC_ItmMast")
                if (sc)
                { 
                    while (result.Next())
                    { 
                        s RowId=result.Data("HOSPRowId")
                        s QtyDesc=result.Data("HOSPDesc")
                        d OutputRowCombo 
                    } 
                }
            }    
           
       }
   }
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRowCombo
    set Data=$lb(RowId,QtyDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetComboListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetComboListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetComboListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetComboListExecute ]
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

/// Function:进行数据检索 
/// CreateDate:2018-06-11
/// Creator: sunfengchao
/// Tables:   
/// Input:   rowid, code, desc 
/// Others:  d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCArcItemAut", "GetList","","","")
Query GetList(ParRef As %String, rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "AUTRowID,AUTRelation,AUTType,AUTOperate,AUTPointer,AUTAddUserDr,AUTDate,AUTTime")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ParRef As %String, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s:code'="" code=$zcvt(code,"U")  
 s:desc'="" desc=$zcvt(desc,"U") 
 s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag() //医院级授权
 if (rowid'="")  
 {
   s AUTRowID= rowid
   s AUTARCIMSubscript=$p(rowid,"||",1)
   s AUTARCIMVersion= $p(rowid,"||",2)
   s AUTChildsub=$p(rowid,"||",3)
   s AUTRelation= $p($g(^ARCIM(AUTARCIMSubscript,AUTARCIMVersion,"DHCAUT",AUTChildsub)),"^",1)
   s:AUTRelation="OR" AUTRelation = "或者"
   s:AUTRelation="AND" AUTRelation = "并且" 
   s AUTTypeI=$p($g(^ARCIM(AUTARCIMSubscript,AUTARCIMVersion,"DHCAUT",AUTChildsub)),"^",2)
   if AUTTypeI="HP" s AUTType="医院" 
   if AUTTypeI="KS" s AUTType="科室" 
   if AUTTypeI="ZC" s AUTType="职称"
   if AUTTypeI="YS" s AUTType="医生"  
   if AUTTypeI="JB" s AUTType="病人级别" 
   s AUTOperate=$p($g(^ARCIM(AUTARCIMSubscript,AUTARCIMVersion,"DHCAUT",AUTChildsub)),"^",3) 
   if AUTOperate="=" s AUTOperate="等于"
   else  if AUTOperate="<>" s AUTOperate="不等于"
   else  if AUTOperate=">=" s AUTOperate="大于等于"
   
   s AUTPointer=$p($g(^ARCIM(AUTARCIMSubscript,AUTARCIMVersion,"DHCAUT",AUTChildsub)),"^",4) 
   if (AUTTypeI="KS")
   { 
     ; 查询 CTLOC 类型为 E的执行科室 
     S:AUTPointer'="" AUTPointer=$P(^CTLOC(AUTPointer),"^",2)
   }
   elseif (AUTTypeI="YS")
   {
     ; 查询  医生
     S:AUTPointer'="" AUTPointer=$p($g(^CTPCP(AUTPointer,1)),"^",1)_"-"_$p($g(^CTPCP(AUTPointer,1)),"^",2)  
   }
   elseif (AUTTypeI="ZC")
   { 
      s:AUTPointer'="" AUTPointer=$p(^CT("CPT",AUTPointer),"^",2) 
   }
   elseif (AUTTypeI="JB")
   {  
      s:AUTPointer'="" AUTPointer=$p($g(^CT("EMF",AUTPointer)),"^",2)  
   }  
   elseif (AUTTypeI="HP")
   {
       s AUTPointer=$p($g(^CT("HOSP",AUTPointer)),"^",2)
   }
   s AUTAddUserDr=$p($g(^ARCIM(AUTARCIMSubscript,AUTARCIMVersion,"DHCAUT",AUTChildsub)),"^",8)
   s:AUTAddUserDr'="" AUTAddUserDr = $p($g(^SSU("SSUSR",AUTAddUserDr)),"^",2) 
   s AUTDate=$p($g(^ARCIM(AUTARCIMSubscript,AUTARCIMVersion,"DHCAUT",AUTChildsub)),"^",9)
   s:AUTDate'="" AUTDate =$zd(AUTDate,1)
   s AUTTime=$p($g(^ARCIM(AUTARCIMSubscript,AUTARCIMVersion,"DHCAUT",AUTChildsub)),"^",10)
   s:AUTTime'="" AUTTime =$zt(AUTTime,1)  
   d OutputRow
 }
 else
 {
   If (ParRef'="")
   {
        s AUTARCIMSubscript=$Piece(ParRef,"||",1) 
        s AUTARCIMVersion= $Piece(ParRef,"||",2) 
         
        s AUTChildsub=0
        for
        {
           s AUTChildsub = $O(^ARCIM(AUTARCIMSubscript,AUTARCIMVersion,"DHCAUT",AUTChildsub))
           q:AUTChildsub=""
           
           s AUTRowID=AUTARCIMSubscript_"||"_AUTARCIMVersion_"||"_AUTChildsub
           s AUTRelationI= $p($g(^ARCIM(AUTARCIMSubscript,AUTARCIMVersion,"DHCAUT",AUTChildsub)),"^",1)
           s:AUTRelationI="OR" AUTRelation = "或者"
           s:AUTRelationI="AND" AUTRelation = "并且"
           s AUTTypeI=$p($g(^ARCIM(AUTARCIMSubscript,AUTARCIMVersion,"DHCAUT",AUTChildsub)),"^",2)
           if AUTTypeI="KS" s AUTType="科室" 
           if AUTTypeI="ZC" s AUTType="职称"
           if AUTTypeI="YS" s AUTType="医生"  
           if AUTTypeI="JB" s AUTType="病人级别" 
           if AUTTypeI="HP" s AUTType="医院" 
           s AUTOperate=$p($g(^ARCIM(AUTARCIMSubscript,AUTARCIMVersion,"DHCAUT",AUTChildsub)),"^",3) 
           if AUTOperate="=" s AUTOperate="等于"
           else  if AUTOperate="<>" s AUTOperate="不等于"
           else  if AUTOperate=">=" s AUTOperate="大于等于"
           s AUTPointer=$p($g(^ARCIM(AUTARCIMSubscript,AUTARCIMVersion,"DHCAUT",AUTChildsub)),"^",4)   
           if (AUTTypeI="KS")
           { 
               ; 查询 CTLOC 类型为 E的执行科室 
               S:AUTPointer'="" AUTPointer=$P(^CTLOC(AUTPointer),"^",2)
           }
           elseif (AUTTypeI="YS") ; 查询 医生
           {  
               S:AUTPointer'="" AUTPointer=$p($g(^CTPCP(AUTPointer,1)),"^",1)_"-"_$p($g(^CTPCP(AUTPointer,1)),"^",2)  
           }
           elseif (AUTTypeI="ZC")
           { 
                s:AUTPointer'="" AUTPointer=$p(^CT("CPT",AUTPointer),"^",2) 
           }
           elseif (AUTTypeI="JB")
           {  
                s:AUTPointer'="" AUTPointer=$p($g(^CT("EMF",AUTPointer)),"^",2)  
           } 
           elseif (AUTTypeI="HP") //医院 
           {
               s AUTPointer=$p($g(^CT("HOSP",AUTPointer)),"^",2)
           }
           s AUTAddUserDr=$p($g(^ARCIM(AUTARCIMSubscript,AUTARCIMVersion,"DHCAUT",AUTChildsub)),"^",8)
           s:AUTAddUserDr'="" AUTAddUserDr = $p($g(^SSU("SSUSR",AUTAddUserDr)),"^",2) 
           s AUTDate=$p($g(^ARCIM(AUTARCIMSubscript,AUTARCIMVersion,"DHCAUT",AUTChildsub)),"^",9)
           s:AUTDate'="" AUTDate =$zd(AUTDate,1)
           s AUTTime=$p($g(^ARCIM(AUTARCIMSubscript,AUTARCIMVersion,"DHCAUT",AUTChildsub)),"^",10)
           s:AUTTime'="" AUTTime =$zt(AUTTime,1)  
           if (AUTTypeI[desc)&(AUTRelationI[code) 
           { 
              d OutputRow
           } 
        }  
    }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(AUTRowID,AUTRelation,AUTType,AUTOperate,AUTPointer,AUTAddUserDr,AUTDate,AUTTime)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Function:双击时弹出显示医嘱限制信息
/// CreateDate:2012-09-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入id
/// Tables: User.DHCArcItemAut
/// Others:w ##Class(web.DHCBL.CT.DHCArcItemAut).OpenData("23")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.DHCArcItemAut).%OpenId(id)
 s eobj = ##class(web.Entity.CT.DHCArcItemAut).%New()
 s eobj.AUTRowID = id
 s eobj.AUTRelation = pobj.AUTRelation
 s eobj.AUTType = pobj.AUTType
 s eobj.AUTOperate =pobj.AUTOperate
 s eobj.AUTPointer = pobj.AUTPointer 
 s Type=eobj.AUTType
 if (Type="KS")
 { 
     ; 查询 CTLOC  科室 
     S:eobj.AUTPointer'="" eobj.AUTPointer=$P(^CTLOC(pobj.AUTPointer),"^",2)
 }
 elseif (Type="YS")
 {
     ; 查询  医生
     S:eobj.AUTPointer'="" eobj.AUTPointer=$p($g(^CTPCP(pobj.AUTPointer,1)),"^",1)_"-"_$p($g(^CTPCP(pobj.AUTPointer,1)),"^",2)   
 }
 elseif (Type="ZC")
 { 
      s:eobj.AUTPointer'="" eobj.AUTPointer=$p(^CT("CPT",pobj.AUTPointer),"^",2) 
 }
 elseif (Type="JB")
 {  
      s:eobj.AUTPointer'="" eobj.AUTPointer=$p($g(^CT("EMF",pobj.AUTPointer)),"^",2)  
 }
 elseif (Type="HP")
 {  
      s eobj.AUTPointer=$p($g(^CT("HOSP",pobj.AUTPointer)),"^",2)  
 }
 s:pobj.AUTAddUserDr'="" eobj.AUTAddUserDr = pobj.AUTAddUserDr.%Id() 
 s:pobj.AUTDate'="" eobj.AUTDate =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.AUTDate)
 s:pobj.AUTTime'="" eobj.AUTTime = $zt(pobj.AUTTime,1) 
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function: 实现删除操作
/// Creator:  sunfengchao 
/// CreateDate:2018-06-12 
/// Input:    rowid
/// Output:   success:'true',info:'删除成功！ 失败时输出删除成功！
/// Other:    w ##class(web.DHCBL.CT.DHCArcItemAut).DeleteData("23")
ClassMethod DeleteData(id As %String) As %String
{
 s result="",flag=""
 Tstart
 s eobj = ##class(web.Entity.CT.DHCArcItemAut).%New()
 s pobj=##class(User.DHCArcItemAut).%OpenId(id)
 s eobj.AUTRowID = id
 s eobj.AUTRelation = pobj.AUTRelation
 s eobj.AUTType = pobj.AUTType
 s eobj.AUTOperate =pobj.AUTOperate
 s eobj.AUTPointer = pobj.AUTPointer 
 s:pobj.AUTAddUserDr'="" eobj.AUTAddUserDr = pobj.AUTAddUserDr.%Id() 
 s:pobj.AUTDate'="" eobj.AUTDate =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.AUTDate)
 s:pobj.AUTTime'="" eobj.AUTTime = $zt(pobj.AUTTime,1) 
 s sc=pobj.%DeleteId(id)
 if $$$ISOK(sc)
 {
   Tc
   s result="{success:'true',info:'删除成功！'}"
   d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ArcItemAut","User.DHCArcItemAut","医嘱限制",id,eobj.AUTPointer,"D",eobj)
   d eobj.%Close()
 }
 else
 {
  Trollback
  s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}" 
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱限制","web.DHCBL.CT.DHCArcItemAut","DeleteData",eobj)
  s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
 }
 q result
}

/// Function:  实现修改和保存操作
/// Creator:   sunfengchao
/// CreateDate:2018-06-12
/// Output:    success:'true',info:'添加成功！' 失败时输出添加失败！
/// Tables:    DHC_ArcItemAut
ClassMethod Insert(ParRef, AUTRelation, AUTType, AUTOperate, AUTPointer, AUTAddUserDr, AUTDate, AUTTime) As %Library.String
{
    s result=""
    S subs=$P(ParRef,"||",1)
    S vers=$P(ParRef,"||",2)
    q:subs="" -5
    q:vers="" -6
    q:'$D(^ARCIM(subs,vers)) -7
    s childsub=$o(^ARCIM(subs,vers,"DHCAUT",""),-1)+1   ;child sub   
    tstart
    &sql(
        insert into DHC_ArcItemAut(AUT_ARCIMSubscript,AUT_ARCIMVersion,AUT_Childsub,AUT_Relation,AUT_Type,AUT_Operate,AUT_Pointer ,AUT_AddUser_Dr,AUT_Date ,AUT_Time)
        values (:subs,:vers,:childsub,:AUTRelation,:AUTType,:AUTOperate,:AUTPointer,:AUTAddUserDr,:AUTDate ,:AUTTime)  
    )
    if (SQLCODE'=0)
    {
        s result="false" 
    }
    else
    { 
        tcommit
        s autid= %ROWID 
        s result="success"_"^"_autid
    } 
    q result
}

/// Function:  实现修改和保存操作
/// Creator:   sunfengchao
/// CreateDate:2018-06-12
/// Output:    success:'true',info:'添加成功！' 失败时输出添加失败！
///            success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables:    DHC_ArcItemAut
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCArcItemAut) As %String
{
   s result=""  
   if (eobj.AUTRowID="")
   { 
       if (eobj.ParRef'="")&(eobj.ParRef'["||") s eobj.ParRef=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",eobj.ParRef,eobj.LinkHospId)  // 导入时通过code找医嘱id 
       q:eobj.ParRef="" "{success:'false',errorinfo:'没有获取到医嘱项ID!'}" 
   } 
   s:eobj.AUTRelation="或者" eobj.AUTRelation="OR"
   s:eobj.AUTRelation="并且" eobj.AUTRelation="AND" 
 
   s:eobj.AUTType="CTLOC" eobj.AUTType="KS" 
   s:eobj.AUTType="CTCPT" eobj.AUTType="ZC"
   s:eobj.AUTType="SSUSR" eobj.AUTType="YS" 
   s:eobj.AUTType="CTEMF" eobj.AUTType="JB" 
   s:eobj.AUTType="AdmReason" eobj.AUTType="AR" 
   s:eobj.AUTType="PAT" eobj.AUTType="BR"  
   s:eobj.AUTType="医院" eobj.AUTType="HP" 
       
   s:eobj.AUTOperate="等于" eobj.AUTOperate="="
   s:eobj.AUTOperate="大于等于" eobj.AUTOperate=">="
   s:eobj.AUTOperate="不等于" eobj.AUTOperate="<>"
   
    /// 处理医生 工号为纯数字的情况 :001-张三 
   if (eobj.AUTType="YS")&(eobj.AUTPointer["-") s eobj.AUTPointer=$P(eobj.AUTPointer,"-",2)  
   if (+eobj.AUTPointer=0) // 传过来的是 文本而不是dr的id
   {
     if (eobj.AUTType="KS")
     { 
         ; 查询 CTLOC 科室 
         s:eobj.AUTPointer'="" eobj.AUTPointer=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(eobj.AUTPointer),0))  
     }
     elseif (eobj.AUTType="YS")
     {
         ; 查询 医生
         if eobj.AUTPointer["-"  s eobj.AUTPointer=$P(eobj.AUTPointer,"-",2)
         s:eobj.AUTPointer'="" eobj.AUTPointer=$O(^CTPCP(0,"Decs",$$ALPHAUP^SSUTIL4(eobj.AUTPointer),0))
     }
     elseif (eobj.AUTType="ZC") // 职称 (取医护人员类型)
     { 
          s:eobj.AUTPointer'="" eobj.AUTPointer=$o(^CT("CPT",0,"Desc",$$ALPHAUP^SSUTIL4(eobj.AUTPointer),0))
     }
     elseif (eobj.AUTType="JB") // 病人级别 ^CT("EMF",0,"Desc",
     {  
          s:eobj.AUTPointer'="" eobj.AUTPointer=$o(^CT("EMF",0,"Desc",$$ALPHAUP^SSUTIL4(eobj.AUTPointer),0))
     } 
     elseif (eobj.AUTType="HP") // 医院 
     {  
          s eobj.AUTPointer=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(eobj.AUTPointer),0))
     }  
   }    
  if (eobj.AUTRowID="")       
  {   
    s ParRef=eobj.ParRef
    s AUTRelation=eobj.AUTRelation 
    s AUTType=eobj.AUTType
    s AUTOperate =eobj.AUTOperate
    s AUTPointer=eobj.AUTPointer 
    s AUTDate=+$H
    s AUTTime=$P($h,",",2) 
    s AUTAddUserDr=$Get(%session.Data("LOGON.USERID")) /// 操作人   
    s result= ..Insert(eobj.ParRef, AUTRelation,AUTType,AUTOperate,AUTPointer,AUTAddUserDr,AUTDate,AUTTime)
    if (result["success"){
        s autid=""
        s autid= $p(result,"^",2)
        s result="{success:'true',id:'"_autid_"'}"   
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ArcItemAut","User.DHCArcItemAut","医嘱限制",autid,eobj.AUTRelation,"A",eobj) 
    }
    else{
       s result="{success:'false'}"  
    }
  }
  else  
  {
     s obj=##class(User.DHCArcItemAut).%OpenId(eobj.AUTRowID)
     s pobj=##class(web.Entity.CT.DHCArcItemAut).%New()
     s pobj.AUTRowID = eobj.AUTRowID
     s pobj.AUTRelation = obj.AUTRelation
     s pobj.AUTType = obj.AUTType
     s pobj.AUTOperate =obj.AUTOperate  
     s pobj.AUTPointer = obj.AUTPointer 
     s:obj.AUTAddUserDr'="" pobj.AUTAddUserDr = obj.AUTAddUserDr.%Id() 
     s:obj.AUTDate'="" pobj.AUTDate =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.AUTDate)
     s:obj.AUTTime'="" pobj.AUTTime = $zt(obj.AUTTime,1) 
     if (eobj.AUTType="YS")&(eobj.AUTPointer["-") 
     {
         s eobj.AUTPointer=$P(eobj.AUTPointer,"-",2) 
        s eobj.AUTPointer=$O(^CTPCP(0,"Decs",$$ALPHAUP^SSUTIL4(eobj.AUTPointer),0))
     } 
     s obj.AUTRelation = eobj.AUTRelation 
     s obj.AUTType = eobj.AUTType
     s obj.AUTOperate =eobj.AUTOperate
     s obj.AUTPointer =eobj.AUTPointer 
     d obj.AUTAddUserDrSetObjectId($Get(%session.Data("LOGON.USERID"))) /// 操作人
     s obj.AUTDate = +$H  ///操作日期
     s obj.AUTTime= $P($h,",",2) // 操作时间  
     Tstart
     s sc=obj.%Save()
     if $$$ISOK(sc)
     {
        Tcommit
        s id = obj.%Id()
        s result = "{success:'true',id:'"_id_"'}"      
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ArcItemAut","User.DHCArcItemAut","医嘱限制",eobj.AUTRowID,eobj.AUTPointer,"U",eobj,pobj)
       }
       else
       {
         Trollback
         s result = "{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)   
         s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱限制","web.DHCBL.CT.DHCArcItemAut","SaveEntity",eobj)
         s ^ERRORLOGINFO(logid)=$System.OBJ.DisplayError(sc)   
       } 
   } 
 q result
}

}
