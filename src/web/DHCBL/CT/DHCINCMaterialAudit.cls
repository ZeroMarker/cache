/// Function:材料审批表
/// CreateDate:2023-04-18
/// Creator:sunfengchao
Class web.DHCBL.CT.DHCINCMaterialAudit Extends %RegisteredObject
{

/// Function:获取日期
/// CreateDate:2023-05-23
/// Creator:sunfengchao
/// Others: w ##class(web.DHCBL.CT.DHCINCMaterialAudit).GetDate()
ClassMethod GetDate(Date As %String) As %String
{
    q:Date="" ""
    s Year=$P(Date,"-",1)
    s Month=$P(Date,"-",2)
    s Day=+$P(Date,"-",3)
    if $l(Day)=1 s Day="0"_Day
    s result=Year_"-"_Month_"-"_Day
    q result
}

/// Function:记录当前时间
/// CreateDate:2023-04-25
/// Creator:sunfengchao
/// w ##class(web.DHCBL.CT.DHCINCMaterialAudit).GetCurrentDateTime()
ClassMethod GetCurrentDateTime(Type As %String) As %String
{
   
    s Date=$zd(+$H,3)
    s Time=$zt($p($H,",",2),1)  
    s OperateDateTime=Date_"  "_Time 
    s Operator=""
    if $d(%session) s Operator= $Get(%session.Data("LOGON.USERNAME"))  
    s result= Operator_"^"_OperateDateTime
     if (Type="INC")
     {
        k ^TMP("SaveINCDateTime") 
        s ^TMP("SaveINCDateTime")=result
     }
     elseif (Type="WJ")
     {
         k ^TMP("SaveWJDateTime")
         s ^TMP("SaveWJDateTime")=result
     }
     elseif (Type="YW")
     {
         k ^TMP("SaveYWDateTime")
         s ^TMP("SaveYWDateTime")=result
     }
    q result
}

/// Function: 获取保存物资信息时的当前时间和操作人
/// CreateDate:2023-04-25
/// Creator:sunfengchao
/// w ##class(web.DHCBL.CT.DHCINCMaterialAudit).GetCurrentDateTime()
ClassMethod GetHistoryDateTime(Type As %String) As %String
{
     if (Type="INC")
     {
         s result =$g(^TMP("SaveINCDateTime")) 
     }
     elseif (Type="WJ")
     {
          s result =$g(^TMP("SaveWJDateTime"))  
     }
     elseif (Type="YW")
     {
         s result =^TMP("SaveYWDateTime") 
     } 
    q result
}

/// Function:　库存类组 查询列表
/// Creator:   sunfengchao
/// CreateDate:2023-4-20
/// Table：    SELECT SCGR_SCG_Parref * FROM DHC_StkCatGrpRelations  这个表里, 关联了库存分类的, 就可以理解为叶子类组了, 没关联库存分类的, 即使是最后一层, 也没法用
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCINCMaterialAudit","GetCatGrpList","")
///   
Query GetCatGrpList(desc As %String, hospid As %String) As websys.Query(ROWSPEC = "SCGRowId:%String,SCGDesc:%String")
{
}

ClassMethod GetCatGrpListExecute(ByRef qHandle As %Binary, desc As %String, hospid As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1 
   s:desc'="" desc=$ZCVT(desc,"U") 
   s ^TMPhospid=hospid 
   k ^TMP($j,"GetCatGrpList")
   s ParRef=0
   for
   {
       s ParRef=$O(^DHCSCG(ParRef)) q:ParRef=""
       continue:('$d(^DHCSCG(ParRef,"RE")))
       s ChildSub=0
       for
       { 
          s ChildSub=$o(^DHCSCG(ParRef,"RE",ChildSub)) 
          q:ChildSub=""   
          s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_StkCatGroup",ParRef,hospid)
          continue:ShowDataFlag'="Y"  
          s SCGRStkCatDR =$p($g(^DHCSCG(ParRef,"RE",ChildSub)),"^",1)
          continue:SCGRStkCatDR="" 
          s SCGRType=$p($g(^DHCSCG(ParRef)),"^",3)  
          continue:SCGRType'="M"  
          
          s SCGDesc=$p($g(^DHCSCG(ParRef)),"^",2)  
          if ((($ZCVT(SCGDesc,"U")[desc))||(desc=""))&('$d(^TMP($j,"GetCatGrpList",ParRef)))
          { 
            s ^TMP($j,"GetCatGrpList",ParRef)=""
            s SCGRowId=ParRef 
            d OutputRow2
          } 
       }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(SCGRowId,SCGDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Description:查询HIS系统的用户 
/// Creator:    sunfengchao
/// CreatDate:  2023-3-27
/// Input:desc
/// Other: w ##class(web.DHCBL.CT.DHCINCMaterialAudit).GetAllUser("","")
ClassMethod GetAllUser(rowid As %String, desc As %String) As %String
{
  
    s:desc'="" desc=$ZCONVERT(desc,"U")
    S type="user",isParent=0 
    s strResult="" 
    s result=##class(%ResultSet).%New()
    s result.ClassName="web.DHCBL.CT.SSUser"
    s result.QueryName="GetDataForCmb1" 
    if (result)
    { 
        s sc=result.Execute("",desc)
        if (sc)
        { 
            while (result.Next())
            { 
                s SSUSRRowId =result.Data("SSUSRRowId")
                s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)  
                s SSUSRName=result.Data("SSUSRName")
                if SSUSRName["-" s SSUSRName=$P(SSUSRName,"-",2)  // 去除工号 
                s SSUSRDefaultDeptDRCode=""
                s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
                s SSUSRDefaultDeptDRCode=""
                s:SSUSRDefaultDeptDR'="" SSUSRDefaultDeptDRCode=$p($g(^CTLOC(SSUSRDefaultDeptDR)),"^",1)        //科室Code
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(SSUSRName)
                if strResult=""  s strResult= "{""type"":"""_type_""",""id"":"""_SSUSRInitials_""",""pId"":"""_SSUSRDefaultDeptDRCode_""",""name"":"""_SSUSRName_""",""isParent"":"""_isParent_""",""initials"":"""_PINYIN_"""}" 
                else  s strResult=strResult_",{""type"":"""_type_""",""id"":"""_SSUSRInitials_""",""pId"":"""_SSUSRDefaultDeptDRCode_""",""name"":"""_SSUSRName_""",""isParent"":"""_isParent_""",""initials"":"""_PINYIN_"""}" 

            } 
        } 
        if strResult'="" s strResult="["_strResult_"]" 
    }
    q strResult
}

/// Description:查询HIS系统的科室
/// Creator:    sunfengchao
/// CreatDate:  2023-3-27
/// Input:desc
/// Other: w ##class(web.DHCBL.CT.DHCINCMaterialAudit).GetAllDept("","")
ClassMethod GetAllDept(rowid As %String, desc As %String) As %String
{
  
    s:desc'="" desc=$ZCONVERT(desc,"U")
    S type="dept",isParent=0 
    s strResult="" 
    s result=##class(%ResultSet).%New()
    s result.ClassName="web.DHCBL.CT.CTLoc"
    s result.QueryName="GetList"
    if (result)
    { 
        s sc=result.Execute("","","","","","",2,"","","")
        if (sc)
        { 
            while (result.Next())
            { 
                s CTLOCCode=result.Data("CTLOCCode")
                s CTLOCDesc=result.Data("CTLOCDesc")
                s SSUSRDefaultDeptDRCode=""
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLOCDesc)
                if strResult=""  s strResult= "{""type"":"""_type_""",""id"":"""_CTLOCCode_""",""pId"":"""_SSUSRDefaultDeptDRCode_""",""name"":"""_CTLOCDesc_""",""isParent"":"""_isParent_""",""initials"":"""_PINYIN_"""}" 
                else  s strResult=strResult_",{""type"":"""_type_""",""id"":"""_CTLOCCode_""",""pId"":"""_SSUSRDefaultDeptDRCode_""",""name"":"""_CTLOCDesc_""",""isParent"":"""_isParent_""",""initials"":"""_PINYIN_"""}" 

            } 
        } 
 
    } 
    if strResult'="" s strResult="["_strResult_"]"
}

/// Description:查询HIS系统的所有岗位(安全组)
/// Creator:    sunfengchao
/// CreatDate:  2023-3-27
/// Input:desc
/// Other: w ##class(web.DHCBL.CT.DHCINCMaterialAudit).GetAlllRole("","")
ClassMethod GetAlllRole(rowid As %String, desc As %String) As %String
{
 
    s:desc'="" desc=$ZCONVERT(desc,"U")
    S type="dept",isParent=0 
    s strResult="" 
    s result=##class(%ResultSet).%New()
    s result.ClassName="web.DHCBL.CT.SSGroup"
    s result.QueryName="GetList"
    if (result)
    { 
        s sc=result.Execute(rowid,desc)
        if (sc)
        { 
            while (result.Next())
            {  
                s SSGRPDesc=result.Data("SSGRPDesc")
                s CTLOCCode=SSGRPDesc
                s SSUSRDefaultDeptDRCode=""
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(SSGRPDesc)
                if strResult=""  s strResult= "{""type"":"""_type_""",""id"":"""_CTLOCCode_""",""pId"":"""_SSUSRDefaultDeptDRCode_""",""name"":"""_SSGRPDesc_""",""isParent"":"""_isParent_""",""initials"":"""_PINYIN_"""}" 
                else  s strResult=strResult_",{""type"":"""_type_""",""id"":"""_CTLOCCode_""",""pId"":"""_SSUSRDefaultDeptDRCode_""",""name"":"""_SSGRPDesc_""",""isParent"":"""_isParent_""",""initials"":"""_PINYIN_"""}" 
                
            } 
        } 
    } 
    if strResult'="" s strResult="["_strResult_"]"
    q strResult
}

/// Description 查询内容
/// Creator:    sunfengchao
/// CreatDate:  2023-04-18
/// Table：     CT_BDP_CT.DHC_INCMaterialAudit
/// Input：     rowid,code,desc 
/// OUtput:      
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCINCMaterialAudit","GetList","","","","","Y","","","2022-06-30","2023-07-01","2")
Query GetList(rowid As %String, code As %String, desc As %String, audit As %String, datefrom As %String, dateto As %String, hospid As %String) As websys.Query(ROWSPEC = "ID,BDPINCAMaterialCode,BDPINCAMaterialDesc,Alias,BDPINCAAuditResult,BDPINCACreatDate,BDPINCACreatTime,BDPINCATarReference,BDPINCAARCIMReference,Spec,Model,BUom,PUom,Factor,PackUomMax,PackUomFacMax,SP,StkGrp,StkCat,HighValue,Origin,MatInsuCode,MatInsuDesc,INCBCode,RegisterNo,INCEndDate,ImportFlag,PbVendor,Manf,BDPINCAProcInsId,BDPINCAuditNextNode")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, audit As %String, datefrom As %String, dateto As %String, hospid As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1  
    s:datefrom'="" datefrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom)  
    s:dateto'="" dateto=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dateto)  
    s:dateto="" dateto=+$H 
    s:datefrom="" datefrom=+$H-7
    if (rowid'="") 
    {
        s ID=rowid  
        s BDPINCAMaterialCode=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),2) /// 物资代码
        s BDPINCAMaterialDesc=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),3)  /// 物资名称   
        s BDPINCACreatDate=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),5)   ///  spd数据同步日期
        s:BDPINCACreatDate'="" BDPINCACreatDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BDPINCACreatDate) 
        s BDPINCACreatTime=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),6) ///  spd数据同步时间
        s:BDPINCACreatTime'="" BDPINCACreatTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(BDPINCACreatTime) 
        s BDPINCAMaterialValue=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),7)  ///  spd推送的材料数据   
        if (BDPINCAMaterialValue'="")
        {
            s materalJsonObj=##class(%DynamicAbstractObject).%FromJSON(BDPINCAMaterialValue) 
            s Spec=materalJsonObj.Spec  // 规格
            s Model=materalJsonObj.Model  // 型号
            s BUom=materalJsonObj.BUom  // 基本单位 
            s:BUom'="" BUom= $p($g(^CT("UOM",BUom)),"^",2)
            s PUom=materalJsonObj.PUom  // 入库单位 
            s:PUom'="" PUom= $p($g(^CT("UOM",PUom)),"^",2)
            s Factor=materalJsonObj.Factor  // 入库转换系数 
            s PackUomMax=materalJsonObj.PackUomMax  // 大包装单位 
            s:PackUomMax'="" PackUomMax= $p($g(^CT("UOM",PackUomMax)),"^",2) 
            s PackUomFacMax=materalJsonObj.PackUomFacMax  // 大包装转换系数
            s SP=materalJsonObj.SP  // 零售价
            s StkGrp=materalJsonObj.StkGrp  // 库存类组 
            s:StkGrp'="" StkGrp=$p($g(^DHCSCG(StkGrp)),"^",2)  
            s StkCat=materalJsonObj.StkCat  // 库存分类  
            s:StkCat'="" StkCat=$p(^INC("SC",StkCat),"^",2)      
            s HighValue=materalJsonObj.HighValue  // 是否高值 
            s:HighValue="" HighValue="N"
            s Origin=materalJsonObj.Origin  // 产地  
            s:Origin'="" Origin=$p($g(^DHCSTORI(Origin)),"^",2)  
            s MatInsuCode=materalJsonObj.MatInsuCode  // 国家医保编码
            s MatInsuDesc=materalJsonObj.MatInsuDesc  // 国家医保名称
            s INCBCode=materalJsonObj.INCBCode   //条码 
            s PbVendor=materalJsonObj.PbVendor  // 供应商 
            s:PbVendor'="" PbVendor=$p($g(^APC("APCVM",PbVendor)),"^",2)  
            s Manf=materalJsonObj.Manf   // 生产厂商  
            s:Manf'="" Manf=$p($g(^PHMNF(Manf)),"^",2)   
            s RegisterNo=materalJsonObj.RegisterNo  //  注册证号
            s INCEndDate=materalJsonObj.INCEndDate  // 停用日期
            s:INCEndDate'="" INCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(INCEndDate) 
            s ImportFlag=materalJsonObj.ImportFlag  //  进口标志 
            s ImportFlag=$case(ImportFlag,"IM":"进口","HM":"国产","JM":"合资","UM":"未分类","":"") 
            s Alias=materalJsonObj.Alias  // 别名 
            s LinkHospId= materalJsonObj.LinkHospId
        }  
     
        s BDPINCATarReference=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),18) 
        s BDPINCAARCIMReference=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),19)  
        s BDPINCAProcInsId =$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),21)  
        d OutputRow
    }
    else
    { 
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
       
        s CurrentDate=dateto+1   
        for
        { 
            s CurrentDate=$o(^CT.BDP.CT.DHCINCMaterialAuditI("CreatDateIdx",CurrentDate),-1) 
            q:(CurrentDate<datefrom)||(CurrentDate="")  
            s ID="" 
            for
            { 
                s ID=$o(^CT.BDP.CT.DHCINCMaterialAuditI("CreatDateIdx",CurrentDate,ID),-1) 
                q:ID=""
                s BDPINCAMaterialCode=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),2) /// 材料代码
                s BDPINCAMaterialDesc=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),3)  /// 材料名称   
                s BDPINCACreatDate=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),5)   ///  spd数据同步日期
                s:BDPINCACreatDate'="" BDPINCACreatDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BDPINCACreatDate) 
                s BDPINCACreatTime=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),6) ///  spd数据同步时间
                s:BDPINCACreatTime'="" BDPINCACreatTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(BDPINCACreatTime)
                s BDPINCAMaterialValue=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),7)  ///  spd推送的材料数据 
                s LinkHospId=""    
                if (BDPINCAMaterialValue'="")
                {  
                    s materalJsonObj=##class(%DynamicAbstractObject).%FromJSON(BDPINCAMaterialValue) 
                    s Spec=materalJsonObj.Spec  // 规格
                    s Model=materalJsonObj.Model  // 型号
                    s BUom=materalJsonObj.BUom  // 基本单位 
                    s:BUom'="" BUom= $p($g(^CT("UOM",BUom)),"^",2)
                    s PUom=materalJsonObj.PUom  // 入库单位 
                    s:PUom'="" PUom= $p($g(^CT("UOM",PUom)),"^",2)
                    s Factor=materalJsonObj.Factor  // 入库转换系数 
                    s PackUomMax=materalJsonObj.PackUomMax  // 大包装单位 
                    s:PackUomMax'="" PackUomMax= $p($g(^CT("UOM",PackUomMax)),"^",2) 
                    s PackUomFacMax=materalJsonObj.PackUomFacMax  // 大包装转换系数
                    s SP=materalJsonObj.SP  // 零售价
                    s StkGrp=materalJsonObj.StkGrp  // 库存类组 
                    s:StkGrp'="" StkGrp=$p($g(^DHCSCG(StkGrp)),"^",2)  
                    s StkCat=materalJsonObj.StkCat  // 库存分类  
                    s:StkCat'="" StkCat=$p(^INC("SC",StkCat),"^",2)      
                    s HighValue=materalJsonObj.HighValue  // 是否高值 
                    s:HighValue="" HighValue="N"
                    s Origin=materalJsonObj.Origin  // 产地  
                    s:Origin'="" Origin=$p($g(^DHCSTORI(Origin)),"^",2)  
                    s MatInsuCode=materalJsonObj.MatInsuCode  // 国家医保编码
                    s MatInsuDesc=materalJsonObj.MatInsuDesc  // 国家医保名称
                    s INCBCode=materalJsonObj.INCBCode   //条码 
                    s PbVendor=materalJsonObj.PbVendor  // 供应商 
                    s:PbVendor'="" PbVendor=$p($g(^APC("APCVM",PbVendor)),"^",2)  
                    s Manf=materalJsonObj.Manf   // 生产厂商  
                    s:Manf'="" Manf=$p($g(^PHMNF(Manf)),"^",2)   
                    s RegisterNo=materalJsonObj.RegisterNo  //  注册证号
                    s INCEndDate=materalJsonObj.INCEndDate  // 停用日期
                    s:INCEndDate'="" INCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(INCEndDate) 
                    s ImportFlag=materalJsonObj.ImportFlag  //  进口标志 
                    s ImportFlag=$case(ImportFlag,"IM":"进口","HM":"国产","JM":"合资","UM":"未分类","":"") 
                    s Alias=materalJsonObj.Alias  // 别名 
                    s LinkHospId= materalJsonObj.LinkHospId
                } 
            
                s BDPINCATarReference=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),18) 
                s BDPINCAARCIMReference=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),19)  
                s PINYIN=""
                if desc'="" s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BDPINCAMaterialDesc) 
              
                s BDPINCAProcInsId =$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),21)  
                s Resultstr= ##class(web.DHCBL.CT.DHCINCMaterialService).GetAuditResult(ID)
                s len=$P(Resultstr,"$%",1)
                s AuditStr=$P(Resultstr,"$%",2)
                s jdlen=$l(AuditStr,"#")
                s jdstr= $P(AuditStr,"#",jdlen)
                s BDPINCAAuditResult=$P(jdstr,"^",1)
                if BDPINCAAuditResult="结束" s AuditFlag="Y"
                else  s AuditFlag="N"
                if (($ZCONVERT(BDPINCAMaterialDesc,"U")[desc)||(PINYIN[desc))&(($ZCONVERT(BDPINCAMaterialCode,"U")[code)||(code=""))&(LinkHospId=hospid)&((audit="")||(AuditFlag=audit))   
                {  
                    s BDPINCAuditNextNode= ##class(web.DHCBL.CT.DHCINCMaterialService).GetNextNode(ID) 
                    d OutputRow
                } 
            }
        }
    } 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow    
    s:ImportFlag="HM" ImportFlag="国产"
    s:ImportFlag="IM" ImportFlag="进口"
    s:ImportFlag="JM" ImportFlag="合资"
    s:ImportFlag="UM" ImportFlag="未分类"
    set Data=$lb(ID,BDPINCAMaterialCode,BDPINCAMaterialDesc,Alias,BDPINCAAuditResult,BDPINCACreatDate,BDPINCACreatTime,BDPINCATarReference,BDPINCAARCIMReference,Spec,Model,BUom,PUom,Factor,PackUomMax,PackUomFacMax,SP,StkGrp,StkCat,HighValue,Origin,MatInsuCode,MatInsuDesc,INCBCode,RegisterNo,INCEndDate,ImportFlag,PbVendor,Manf,BDPINCAProcInsId,BDPINCAuditNextNode)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function: 物资信息维护完成后生成中间物资表数据,并将物资信息保存到表里
/// CreateDate:2023-04-23
/// Creator:sunfengchao
/// Table:  CT_BDP_CT.DHC_INCMaterialAudit
/// Others:  w ##class(web.DHCBL.CT.DHCINCMaterialAudit).SysnazeINCItmData()
ClassMethod SysnazeINCItmData(Ceobj As web.Entity.CT.INCMaterialEntity) As %String
{
    s $zt="ERROR" 
    s result="" 
    if ($d(%session)) s LogonUser=$Get(%session.Data("LOGON.USERCODE"))
    s auditeobj = ##class(web.Entity.CT.DHCINCMaterialAudit).%New()  // 中间物资审批表
    s auditeobj.BDPINCAProcInsId=Ceobj.BDPINCAProcInsId  //流程实列id
    s auditeobj.taskId =Ceobj.MtaskId
    s auditeobj.BDPINCAMaterialCode=Ceobj.InciCode  //材料代码
    s auditeobj.BDPINCAMaterialDesc=Ceobj.InciDesc // 材料名称
    s auditeobj.BDPINCAType="A" //操作类型
    s auditeobj.BDPINCACreatDate= +$H   // 同步日期 
    s auditeobj.BDPINCACreatTime= $P($h,",",2)   /// 同步时间 
    s auditeobj.BDPINCAMaterialValue= Ceobj.JsonS() //材料数据    
    TSTART 
    s ImportResult= ##class(web.DHCBL.CT.DHCINCMaterialAudit).SaveEntity(auditeobj) 
    s ^tmpcy("ImportResult",2)=ImportResult
    if (ImportResult["success:'true'")
    {
        s ID=##class(web.DHCBL.BDP.FunLib).GetResultRowId(ImportResult) 
        if (auditeobj.BDPINCAProcInsId="")
        {
            s startresult= ##class(web.DHCBL.CT.DHCINCMaterialService).StartTask(Ceobj.InciCode,"DHC_INCMaterialAudit",Ceobj.InciDesc_"材料审批-"_LogonUser,"hrp","HIS",LogonUser)  /// 启动数据流审批
            s messageJsonObj=##class(%DynamicAbstractObject).%FromJSON(startresult)  //将返回值json处理成对象   新增材料
            if (messageJsonObj.message["操作成功")  // //如果成功 ,需要记录一下 流程id 
            {   
                s taskId=messageJsonObj.data.taskId   //  任务id 
                s procInsId=messageJsonObj.data.procInsId    //流程实例Id  
                if (taskId'="")
                { 
                    s responseStr= ##class(web.DHCBL.CT.DHCINCMaterialService).SubmitTask(taskId,"申请新增材料")  
                    if (procInsId'="")  // 在中间物资表记录 这个固定的 流程id
                    {
                        s auditobj=##class(CT.BDP.CT.DHCINCMaterialAudit).%OpenId(ID) 
                        if (auditobj)
                        {  
                            s auditobj.BDPINCAProcInsId =procInsId
                            s sc=auditobj.%Save()
                         }
                    } 
                    Tcommit 
                    s result="{success:'true',id:'"_ID_"'}"   ///返回库存项单位
                } 
            }
        }
        else  //被驳回到拟稿后 提交流程 
        {       
            if (auditeobj.taskId'="")
            { 
                s responseStr= ##class(web.DHCBL.CT.DHCINCMaterialService).SubmitTask(auditeobj.taskId,"申请新增材料") 
                s ^TMPNextIresponseStr=responseStr  
                Tcommit 
                s result="{success:'true',id:'"_ID_"'}"   ///返回库存项单位 
            }
            else{
                Trollback
                s result= "{success:'false',errorinfo:'"_messageJsonObj.message_"'}"  
             }
        }
    }
    else
    {
        Trollback
        s result= ImportResult 
    } 
    q result  
ERROR
    Q "保存报错"_$ZE
}

/// Description:同步spd数据到中间表
/// CreateDate:2023-04-18
/// Creator:    sunfengchao
/// Table:      CT_BDP_CT.DHC_INCMaterialAudit
/// Other:      w ##class(web.DHCBL.CT.DHCINCMaterialAudit).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCINCMaterialAudit) As %String
{
    s result=""
    if $IsObject(eobj)
    {
        if (eobj.BDPINCAProcInsId="")  // 新增 材料
        {
            s obj=##class(CT.BDP.CT.DHCINCMaterialAudit).%New()
            s obj.BDPINCAMaterialCode=eobj.BDPINCAMaterialCode  //材料代码
            s obj.BDPINCAMaterialDesc=eobj.BDPINCAMaterialDesc // 材料名称
            s obj.BDPINCAType =eobj.BDPINCAType   //操作类型 
        }  
        else
        {
            s ID=$O(^CT.BDP.CT.DHCINCMaterialAuditI("ProcInsId",eobj.BDPINCAProcInsId,0))
            q:ID="" "{success:'false',errorinfo:'审批表ID为空!'}"  
            s obj=##class(CT.BDP.CT.DHCINCMaterialAudit).%OpenId(ID) 
        } 
        s obj.BDPINCACreatDate=eobj.BDPINCACreatDate   // 同步日期 
        s obj.BDPINCACreatTime=eobj.BDPINCACreatTime   /// 同步时间 
        s obj.BDPINCAMaterialValue=eobj.BDPINCAMaterialValue //材料数据 
        s obj.BDPINCAWJAuditStatus =eobj.BDPINCAWJAuditStatus // 审核结果  
        Tstart
        s sc=obj.%Save()
        if $$$ISOK(sc)
        {
            Tcommit
            s id = obj.%Id() 
            s result = "{success:'true',id:'"_id_"'}"        
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.DHC_INCMaterialAudit","CT.BDP.CT.DHCINCMaterialAudit","材料审核",id,eobj.BDPINCAMaterialDesc,"A",eobj)  
        }
        else
        {
           Trollback
           s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("材料审核","web.DHCBL.CT.DHCINCMaterialAudit","SaveEntity",eobj)
           s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
           s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
        } 
    }
    q result
}

/// Function: 数据审核时加载物资数据
/// CreatDate:2023-04-25
/// Table：  User.BDPHERPItmAudit
/// Creator: sunfengchao
/// CreatDate:2021-08-09  
/// Input:   procInsId:流程id
/// Other:   w ##class(web.DHCBL.CT.DHCINCMaterialAudit).OpenINCItmData(1)
ClassMethod OpenINCItmData(procInsId As %String) As %String
{
  s json="{}" 
  q:procInsId="" json
  s ID=$O(^CT.BDP.CT.DHCINCMaterialAuditI("ProcInsId",procInsId,0))
  q:ID="" json
  s BDPINCAMaterialValue = $lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),7)    //库存项数据  
  s BDPINCAMaterialValue  =  ##class(web.DHCBL.BDP.FunLib).Util(BDPINCAMaterialValue) 
  q:BDPINCAMaterialValue="" json
  q BDPINCAMaterialValue
}

/// Function:物价审批时返回材料的相关信息到物价办
/// CreateDate:2023-05-16
/// Creator:sunfengchao
/// Input:  procInsId :流程id
/// Others: w ##class(web.DHCBL.CT.DHCINCMaterialAudit).GetINCItmForWJData("1656960600711700481")
ClassMethod GetINCItmForWJData(procInsId As %String) As %String
{
 
  s result=""
  q:procInsId="" result
  s ID=$O(^CT.BDP.CT.DHCINCMaterialAuditI("ProcInsId",procInsId,0))
  q:ID="" result
  s MaterialCode=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),2) /// 物资代码
  s MaterialDesc=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),3)  /// 物资名称  
  s BDPINCAMaterialValue = $lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),7)    //库存项数据   
  s Spec="",Model="",BUom="",BUomDesc="",HighValue="",MatInsuCode="",MatInsuDesc="",ImportFlag="",Alias="" 
  if (BDPINCAMaterialValue'="")
  {
        s materalJsonObj=##class(%DynamicAbstractObject).%FromJSON(BDPINCAMaterialValue) 
        s Spec=materalJsonObj.Spec  // 规格
        s Model=materalJsonObj.Model  // 型号
        s BUom=materalJsonObj.BUom  // 基本单位
        s BUomDesc=""
        s:BUom'="" BUomDesc= $p($g(^CT("UOM",BUom)),"^",2)
           
        s HighValue=materalJsonObj.HighValue  // 是否高值 
        s:HighValue="" HighValue="N" 
        s MatInsuCode=materalJsonObj.MatInsuCode  // 国家医保编码
        s MatInsuDesc=materalJsonObj.MatInsuDesc  // 国家医保名称 
        s ImportFlag=materalJsonObj.ImportFlag  //  进口标志 
        s:ImportFlag="" ImportFlag="N"
        s Alias=materalJsonObj.Alias  // 别名 
        s SP=materalJsonObj.SP  // 零售价
   } 
  s result=MaterialCode_"^"_MaterialDesc_"^"_Spec_"^"_BUomDesc_"^"_SP_"^"_MatInsuCode_"^"_MatInsuDesc_"^"_ImportFlag_"^"_Alias
  q result
}

/// Function: 收费项数据保存到中间物资表
/// CreateDate:2023-04-23
/// Creator:sunfengchao
/// Input:   
/// Others: w ##class(web.DHCBL.CT.DHCINCMaterialAudit).SysnazeTARItmData("")
ClassMethod SysnazeTARItmData(Ceobj As web.Entity.CT.DHCAuditTarItem) As %String
{
    s result=""
    q:Ceobj.AuditID="" "{success:'false',errorinfo:'流程实例ID不能为空'}" 
    s ID=$O(^CT.BDP.CT.DHCINCMaterialAuditI("ProcInsId",Ceobj.AuditID,0))
    q:ID="" "{success:'false',errorinfo:'审批表ID不能为空'}" 
    s obj=##class(CT.BDP.CT.DHCINCMaterialAudit).%OpenId(ID) 
    if (obj)
    { 
        s obj.BDPINCATarValue=Ceobj.JsonS() //材料数据 
        s obj.BDPINCAWJAuditStatus ="Y" // 审核结果 通过
        s obj.BDPINCAWJAuditDate=+$H
        s obj.BDPINCAWJAuditTime = $P($h,",",2) 
        s BDPINCAYWAuditerDR=""  
        if $d(%session) s BDPINCAWJAuditerDR= $Get(%session.Data("LOGON.USERID")) 
        d obj.BDPINCAWJAuditerDRSetObjectId(BDPINCAWJAuditerDR)
        s sc=obj.%Save()
        if (sc=1)
        {  
          s WJAuditResult= ##class(web.DHCBL.CT.DHCINCMaterialService).SubmitTask(Ceobj.TaskId,Ceobj.AuditComment)
          s result="{success:'true',id:'物价办审批完成'}"   
        }
        else
        {
           s result="{success:'false'}"  
        }
    } 
    q result
}

/// Function: 医务处审核时加载收费项数据
/// CreatDate:2023-04-25
/// Table：  User.BDPHERPItmAudit
/// Creator: sunfengchao
/// CreatDate:2021-08-09
/// Other:   w ##class(web.DHCBL.CT.DHCINCMaterialAudit).OpenTarItmData("1660819555334565890")
ClassMethod OpenTarItmData(procInsId As %String) As %String
{
  s json="{}"
  q:procInsId="" json
  s ID=$O(^CT.BDP.CT.DHCINCMaterialAuditI("ProcInsId",procInsId,0))
  q:ID="" json
  s BDPINCATarValue=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),16)  //收费项数据 
  s data =##class(web.DHCBL.BDP.FunLib).Util(BDPINCATarValue)  
  q:data="" json
  q data
}

/// Function: 医嘱项数据保存到中间物资表
/// CreateDate:2023-04-23
/// Creator:sunfengchao
/// Input:   
/// Others: w ##class(web.DHCBL.CT.DHCINCMaterialAudit).SysnazeTARItmData("")
ClassMethod SysnazeARCIMData(Ceobj As web.Entity.CT.DHCAuditARCIM) As %String
{
    s result=""
    q:Ceobj.AuditID="" "{success:'false',errorinfo:'流程实例ID不能为空'}" 
    s ID=$O(^CT.BDP.CT.DHCINCMaterialAuditI("ProcInsId",Ceobj.AuditID,0))
    q:ID="" "{success:'false',errorinfo:'审批表ID不能为空'}" 
    
    s obj=##class(CT.BDP.CT.DHCINCMaterialAudit).%OpenId(ID) 
    if (obj)
    { 
        s obj.BDPINCAARCIMValue=Ceobj.JsonS() // 医嘱项数据 
        s obj.BDPINCAYWAuditStatus ="Y" // 审核结果 通过
        s obj.BDPINCAYWAuditDate=+$H
        s obj.BDPINCAYWAuditTime = $P($h,",",2) 
        s BDPINCAWJAuditerDR=""  
        if $d(%session) s BDPINCAYWAuditerDR= $Get(%session.Data("LOGON.USERID")) 
        d obj.BDPINCAYWAuditerDRSetObjectId(BDPINCAYWAuditerDR)
        s sc=obj.%Save()
        if (sc=1)
        {  
            
           ///生成数据
          s SaveAllResult=##class(web.DHCBL.CT.DHCINCMaterialAudit).SaveAllData(ID)
          if (SaveAllResult["success:'true'")
          {
              s YWAuditResult= ##class(web.DHCBL.CT.DHCINCMaterialService).SubmitTask(Ceobj.TaskId,Ceobj.AuditComment)
              s result="{success:'true',id:'医务处审批完成'}"   
          }
          else
          {  s ^TMPSaveAllResult=SaveAllResult
              s result="{success:'false',errorinfo:'数据生成失败'}" 
          }
        }
        else
        {
           
           s result="{success:'false',errorinfo:'审批表保存失败'}" 
        }
    } 
    q result
}

/// Description: 数据审核完成后调用物资组接口生成库存项 
/// CreatDate:  2023-04-18
/// Creator:    sunfengchao
/// Table:      User.DHCTarItem
/// Input:      procInsId 
/// Other:      w ##class(web.DHCBL.CT.DHCINCMaterialAudit).SaveAllData(15)
ClassMethod SaveAllData(ID As %String) As %String
{
 
    s PreResult=""   
    q:ID="" "{success:'false',errorinfo:'审批表ID不能为空！'}" 
    s BDPINCAMaterialValue = $lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),7)    //库存项数据
    s BDPINCATarValue=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),16)  //收费项数据
    s BDPINCAARCIMValue=$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),17)  // 医嘱项数据  
    q:(BDPINCAMaterialValue="")||(BDPINCATarValue="")||(BDPINCAARCIMValue="") "{success:'false',errorinfo:'物资审批明细数据为空！'}"
    s Ceobj=##class(web.BDPExt.WZAuditEntity).%New() 
    s materalJsonObj=##class(%DynamicAbstractObject).%FromJSON(BDPINCAMaterialValue)
    s tarJsonObj=##class(%DynamicAbstractObject).%FromJSON(BDPINCATarValue) 
    s arcimJsonObj=##class(%DynamicAbstractObject).%FromJSON(BDPINCAARCIMValue)  
    s Ceobj.LinkHospId=materalJsonObj.LinkHospId 
    s Ceobj.Charge=materalJsonObj.Charge         //收费标志 
    s Ceobj.InciCode =materalJsonObj.InciCode     //物资编码      
    s Ceobj.InciDesc =materalJsonObj.InciDesc     //物资名称      
    s Ceobj.Alias =materalJsonObj.Alias     //      别名  
    s Ceobj.Spec=materalJsonObj.Spec  // 规格
    s Ceobj.Model=materalJsonObj.Model  // 型号
    s Ceobj.Manf=materalJsonObj.Manf   // 生产厂商  
    s Ceobj.BUom=materalJsonObj.BUom  // 基本单位 
    s Ceobj.PUom=materalJsonObj.PUom  // 入库单位 
    s Ceobj.Factor=materalJsonObj.Factor  // 入库转换系数 
    s Ceobj.PackUomMax=materalJsonObj.PackUomMax  // 大包装单位 
    s Ceobj.PackUomFacMax=materalJsonObj.PackUomFacMax  // 大包装转换系数
    s Ceobj.SP=materalJsonObj.SP  // 零售价
    s Ceobj.StkGrp=materalJsonObj.StkGrp  // 库存类组 
    s Ceobj.StkCat=materalJsonObj.StkCat  // 库存分类  
    s Ceobj.HighValue=materalJsonObj.HighValue  // 是否高值 
    s:Ceobj.HighValue="" Ceobj.HighValue="N"
    s Ceobj.Origin=materalJsonObj.Origin  // 产地  
    s Ceobj.MatInsuCode=materalJsonObj.MatInsuCode  // 国家医保编码
    s Ceobj.MatInsuDesc=materalJsonObj.MatInsuDesc  // 国家医保名称
    s Ceobj.INCBCode=materalJsonObj.INCBCode   //条码 
    s Ceobj.PbVendor=materalJsonObj.PbVendor  // 供应商 
    s Ceobj.RegisterNo=materalJsonObj.RegisterNo  //  注册证号
    s Ceobj.INCEndDate=materalJsonObj.INCEndDate  // 停用日期 
    s Ceobj.ImportFlag=materalJsonObj.ImportFlag  //  进口标志 
    s:Ceobj.ImportFlag="" Ceobj.ImportFlag="N"
             
     
   s Ceobj.TARICode = tarJsonObj.TARICode                     
   s Ceobj.TARIDesc=  tarJsonObj.TARIDesc  
   s Ceobj.TARIAlias=tarJsonObj.TARIAlias
   s Ceobj.TARIInsuCode= tarJsonObj.TARIInsuCode        
   s Ceobj.TARIInsuName= tarJsonObj.TARIInsuName 
   s Ceobj.TARIStartDate =  tarJsonObj.TARIStartDate  
   s Ceobj.TARIEndDate= tarJsonObj.TARIEndDate 
   //s Ceobj.TARIActiveFlag= tarJsonObj.TARIActiveFlag 
   s Ceobj.TARIUOM = materalJsonObj.BUom  //取材料的基本单位   
   s Ceobj.TARISubCate =  tarJsonObj.TARISubCate 
   s Ceobj.TARIInpatCate =  tarJsonObj.TARIInpatCate 
   s Ceobj.TARIEMCCate =  tarJsonObj.TARIEMCCate 
   s Ceobj.TARIAcctCate = tarJsonObj.TARIAcctCate 
   s Ceobj.TARIOutpatCate = tarJsonObj.TARIOutpatCate 
   s Ceobj.TARIMRCate = tarJsonObj.TARIMRCate 
   s Ceobj.TARIAcctCate = tarJsonObj.TARIAcctCate   
   s Ceobj.TARIMCNew = tarJsonObj.TARIMCNew    
   s Ceobj.TPPrice= tarJsonObj.TPPrice   //标准价格
   s Ceobj.TPPatInsType= tarJsonObj.TPPatInsType  // 患者费别
       
   s Ceobj.ARCIMCode = arcimJsonObj.ARCIMCode  //医嘱代码                     
   s Ceobj.ARCIMDesc=  arcimJsonObj.ARCIMDesc  /// 医嘱名称
   s Ceobj.Alias=arcimJsonObj.Alias  // 医嘱别名     
   s Ceobj.ARCIMItemCatDR= arcimJsonObj.ARCIMItemCatDR // 医嘱子分类
   s Ceobj.ARCIMBillSubDR =  arcimJsonObj.ARCIMBillSubDR // 账单子组   
   s Ceobj.ARCIMEffDate= arcimJsonObj.ARCIMEffDate  ///  起始日期  
   s Ceobj.ARCIMEffDateTo = arcimJsonObj.ARCIMEffDateTo  ///  结束日期
   s Ceobj.ARCIMBillingUOMDR  =materalJsonObj.BUom  //单位 
   s Ceobj.ARCIMAllowOrderWOStockCheck=arcimJsonObj.ARCIMAllowOrderWOStockCheck  //无库存医嘱标志
   s:Ceobj.ARCIMAllowOrderWOStockCheck="" Ceobj.ARCIMAllowOrderWOStockCheck="N"
   s Ceobj.ARCIMOrderOnItsOwn = arcimJsonObj.ARCIMOrderOnItsOwn  // 独立医嘱标志 
   s:Ceobj.ARCIMOrderOnItsOwn="" Ceobj.ARCIMOrderOnItsOwn="N"
   s PreResult= ##class(web.BDPExt.INCMaterialAuditBLL).SaveEntity(Ceobj)    
   ;s ^tmpPreResult11=PreResult  
   q PreResult
}

/// Function:   数据审批 (物价办、医务处审批)
/// CreateDate: 2023-04-18
/// Creator:    sunfengchao
/// Inupt:      procInsId
/// Output:
/// Other:      w ##class(web.DHCBL.CT.DHCINCMaterialAudit).ChangeAuditStatus(15)
ClassMethod ChangeAuditStatus(procInsId As %String, WJAudit As %String, YWAudit As %String) As %String
{
   s result=""
   q:(procInsId="") "{success:'false',info:'流程实例ID不能为空！'}"
   s ID=$O(^CT.BDP.CT.DHCINCMaterialAuditI("ProcInsId",procInsId,0))
   q:ID="" "{success:'false',errorinfo:'审批表ID不能为空！'}"
   s UpdateUserDR=""
   if $d(%session)  s UpdateUserDR=$Get(%session.Data("LOGON.USERID"))    
   s auditobj=##class(CT.BDP.CT.DHCINCMaterialAudit).%OpenId(ID)
   if (auditobj)
   {
       if (WJAudit'="")
       {
           s auditobj.BDPINCAWJAuditStatus=WJAudit ///  物价办审批状态
           s auditobj.BDPINCAWJAuditDate=+$H /// 审核日期
           s auditobj.BDPINCAWJAuditTime =$P($h,",",2) /// 审批时间 
           d auditobj.BDPINCAWJAuditerDRSetObjectId(UpdateUserDR) ///  审核人 
       }
       if (YWAudit'="")
       {
           s auditobj.BDPINCAYWAuditStatus=YWAudit ///  物价办审批状态
           s auditobj.BDPINCAYWAuditDate=+$H /// 审核日期
           s auditobj.BDPINCAYWAuditTime =$P($h,",",2) /// 审批时间 
           d auditobj.BDPINCAYWAuditerDRSetObjectId(UpdateUserDR) ///  审核人
       } 
       s auditsc=auditobj.%Save()
       if (auditsc=1)
       {
          s result="{success:'true',info:'操作成功!'}"  
       }
       else
       {
          s result= "{success:'false',info:'审批失败!'"_$system.OBJ.DisplayError(auditsc)_"'}" 
       } 
   } 
   q result
}

/// Function:   数据拒绝 (物价办、医务处拒绝审批)
/// CreateDate: 2023-05-18
/// Creator:    sunfengchao
/// Inupt:      procInsId
/// Output:
/// Other:      w ##class(web.DHCBL.CT.DHCINCMaterialAudit).ChangeAuditStatus(15)
ClassMethod RefuseAuditStatus(comment As %String, taskId As %String, procInsId As %String, WJAudit As %String, YWAudit As %String) As %String
{
   s result="" 
   q:(procInsId="") "{success:'false',info:'流程实例ID不能为空！'}"
   s ID=$O(^CT.BDP.CT.DHCINCMaterialAuditI("ProcInsId",procInsId,0))
   q:ID="" "{success:'false',errorinfo:'审批表ID不能为空！'}"
    // s result= ##class(web.DHCBL.CT.DHCINCMaterialService).BackToInitiator(taskId,comment)   // 驳回到拟稿
   if (WJAudit'="")  s activityId="initiator_1" //物价审批 驳回到拟稿 
   if (YWAudit'="") s activityId="task_1" // 驳回到物价审批 
   s result= ##class(web.DHCBL.CT.DHCINCMaterialService).BackToCustom(activityId,comment,taskId,"")   // 驳回到上一个节点
    
   s UpdateUserDR=""
   if $d(%session)  s UpdateUserDR=$Get(%session.Data("LOGON.USERID"))    
   s auditobj=##class(CT.BDP.CT.DHCINCMaterialAudit).%OpenId(ID)
   if (auditobj)
   {
       if (WJAudit'="")
       {
           s auditobj.BDPINCAWJAuditStatus=WJAudit ///  物价办审批状态
           s auditobj.BDPINCAWJAuditDate=+$H /// 审核日期
           s auditobj.BDPINCAWJAuditTime =$P($h,",",2) /// 审批时间 
           d auditobj.BDPINCAWJAuditerDRSetObjectId(UpdateUserDR) ///  审核人 
       }
       if (YWAudit'="")
       {
           s auditobj.BDPINCAYWAuditStatus=YWAudit ///  物价办审批状态
           s auditobj.BDPINCAYWAuditDate=+$H /// 审核日期
           s auditobj.BDPINCAYWAuditTime =$P($h,",",2) /// 审批时间 
           d auditobj.BDPINCAYWAuditerDRSetObjectId(UpdateUserDR) ///  审核人
       } 
       s auditsc=auditobj.%Save()
       if (auditsc=1)
       {
          s result="{success:'true',info:'操作成功!'}"  
       }
       else
       {
          s result= "{success:'false',info:'审批失败!'"_$system.OBJ.DisplayError(auditsc)_"'}" 
       } 
   } 
   q result
}

/// Other:      w ##class(web.DHCBL.CT.DHCINCMaterialAudit).Test()
ClassMethod Test()
{
    s eobj=##class(web.Entity.CT.DHCAuditARCIM).%New()
    s eobj.ARCIMCode ="DZ010981" 
    s eobj.ARCIMDesc="一次性注射针[12#1]"
    
     
    s eobj.ARCIMItemCatDR= 81 
    s eobj.ARCIMBillSubDR= "2||1"
    s eobj.ARCIMEffDate="2023-05-15"
    s eobj.ARCIMEffDateTo=""
    s eobj.ARCIMBillingUOMDR=4
    s eobj.ARCIMOrderOnItsOwn="Y"
    s eobj.AuditID="1657951871412543489"
    s eobj.LinkHospId= 2
    s eobjsc=..SysnazeARCIMData(eobj)
    w eobjsc
}

}
