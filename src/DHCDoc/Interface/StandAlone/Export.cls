Import SQLUSER

/// 
/// Filename         :DHCDoc.Interface.StandAlone.Export
/// Description      :应急系统读取HIS本地数据方法
/// Time             :2021/04/23
/// Author           :tanjishan
Class DHCDoc.Interface.StandAlone.Export Extends Base
{

Parameter DataCreateUser = "HISDOC";

/***
  **Description      :69.挂号职称字典表(RBC_SessionType)
  **Author           :tanjishan
  **Time             :2021/04/23
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Export).GetRBCSessionType(1,10000)
  **Parameter        :
  **Returns          :
***/
ClassMethod GetRBCSessionType(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
    set tabName="RBC_SessionType"
    set queryColumn=" TOP "_(+expNum) 
    set queryColumn= queryColumn_" * "
    set condition=" %ID >"_(+stIndex)
    quit ##Class(BILL.CES.BL.Export).GetDataByTabName(tabName, queryColumn, condition)
}

/***
  **Description      :70.挂号职称费用表(DHC_RBCSessionTypeService)
  **Author           :tanjishan
  **Time             :2021/04/23
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Export).GetDHCRBCSessionTypeService(1,10000).Read()
  **Parameter        :
  **Returns          :
***/
ClassMethod GetDHCRBCSessionTypeService(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
    set tabName="DHC_RBCSessionTypeService"
    set queryColumn=" TOP "_(+expNum) 
    set queryColumn= queryColumn_" * "
    //set condition=" %ID >"_(+stIndex)
    set condition=" (($PIECE(%ID,'||')="_+$p(stIndex,"||",1)_" AND ($PIECE(%ID,'||',2)>"_+$p(stIndex,"||",2)_"))"
    set condition=condition_" OR ($PIECE(%ID,'||')>"_+$p(stIndex,"||",1)_" ))"
    quit ##Class(BILL.CES.BL.Export).GetDataByTabName(tabName, queryColumn, condition)
}

/***
  **Description      :71.科室医生号别对照(DHCMarkDoc)
  **Author           :tanjishan
  **Time             :2021/05/10
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Export).GetDHCMarkDoc(1,10000).Read()
  **Parameter        :
  **Returns          :
***/
ClassMethod GetDHCMarkDoc(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
    set stream=##class(%Stream.GlobalCharacter).%New()
    set endIndex=-1
    s ID=stIndex
    for {
    s ID=$O(^User.DHCMarkDocD(ID))
    q:(ID="")
    q:(ID>=expNum)
    s endIndex=ID
    s MarkdDocDr=$List(^User.DHCMarkDocD(ID),2)
    s MarkdMarkDr=$List(^User.DHCMarkDocD(ID),3)
    s MarkddepDr=$List(^User.DHCMarkDocD(ID),4)
    s Markddefault=$lg(^User.DHCMarkDocD(ID),5)
      
    s ResRowId=$O(^RB("RES",0,"CTPCP",MarkdMarkDr,MarkddepDr,""),-1)
    continue:(ResRowId="")

    s SessionTypeDr=""

    //在排班模板中找
    if (SessionTypeDr=""){
      s RBResEffDateChildsub=$O(^RB("RES",ResRowId,"DATE",""),-1)
      i RBResEffDateChildsub'="" {
        s SESSChildsub=0
        f  {
          s SESSChildsub=$o(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub)) 
          q:(SESSChildsub="")
          s SessScheduleGenerFlag=$p(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub),"^",16)
          continue:(SessScheduleGenerFlag="N")
          s SessionTypeDr=$p(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub),"^",9)
        }
      }
    }
     //从最近的排班中找
    s ASChildDr=$O(^RBAS(ResRowId,""),-1)
    if (ASChildDr'=""){
      S ASDate=$o(^RBAS(ResRowId,0,"DateSTime",""),-1)
      //s ASDate=$P(^RBAS(ResRowId,ASChildDr),"^",1)
      if ($ZABS(+$H-ASDate)<50){
        S SessStartTime=$o(^RBAS(ResRowId,0,"DateSTime",ASDate,""),-1)
        if (SessStartTime'=""){
          s ASChildDr=$o(^RBAS(ResRowId,0,"DateSTime",ASDate,SessStartTime,""),-1)
          if (ASChildDr'=""){
            s SessionTypeDr=$P($G(^RBAS(ResRowId,ASChildDr,"DHC")),"^",6)
          }
        }
      }
    }

    continue:(SessionTypeDr="")
    set ID1=##class(BILL.CES.COM.Util).EscapeMysqlStr(ID)
    set MarkdDocDr=##class(BILL.CES.COM.Util).EscapeMysqlStr(MarkdDocDr)
    set MarkdMarkDr=##class(BILL.CES.COM.Util).EscapeMysqlStr(MarkdMarkDr)
    set MarkddepDr=##class(BILL.CES.COM.Util).EscapeMysqlStr(MarkddepDr)
    set Markddefault=##class(BILL.CES.COM.Util).EscapeMysqlStr(Markddefault)
    set SessionTypeDr=##class(BILL.CES.COM.Util).EscapeMysqlStr(SessionTypeDr)
    set Data=$lb(ID1,MarkdDocDr,MarkdMarkDr,MarkddepDr,Markddefault,SessionTypeDr)
    set sql= "INSERT INTO DHCMarkDoc (ID,MarkdDocDr,MarkdMarkDr,MarkddepDr,Markddefault,SessionTypeDr)"
    set sql= sql_" VALUES ("_$lts(Data,",")_");"
    do stream.Write(sql)
    }

    do stream.Write("^"_endIndex) 
    q stream
}

/***
  **Description      :73.医嘱项外部代码对照表(ARC_ItemExternalCodes)
  **Author           :tanjishan
  **Time             :2021/07/20
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Export).GetARCItemExternalCodes("11583||1",10000).Read()
  **Parameter        :
  **Returns          :
***/
ClassMethod GetARCItemExternalCodes(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
    set tabName="ARC_ItemExternalCodes"
    set queryColumn=" TOP "_(+expNum) 
    set queryColumn= queryColumn_" * "
    //set condition=" %ID >"_(+stIndex)
    set condition=" ($PIECE(%ID,'||')>"_+$p(stIndex,"||",1)_" )  ORDER BY $PIECE(%ID,'||')" 

    quit ##Class(BILL.CES.BL.Export).GetDataByTabName(tabName, queryColumn, condition)
}

/***
  **Description      :74.外部代码登记信息表(ARC_ItemExternalInfo)--新建表，HIS无对照实体
  **Author           :tanjishan
  **Time             :2021/07/20
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Export).GetARCItemExternalInfo("1",10000).Read()
  **Parameter        :
  **Returns          :
***/
ClassMethod GetARCItemExternalInfo(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
    set stream=##class(%Stream.GlobalCharacter).%New()
    set tabName="ARC_ItemExternalCodes"
    Set rset=##class(%ResultSet).%New("DHCLIS.DHCBTQuery:QryTestSetInfo")
    do rset.Execute("","","","","","","","","","","","","","")
    s Count=0
    s rsIndex=0
    While (rset.Next()) {
    //Code,SpecimenCode,Specimen,ContainerCode,ContainerDesc,TestSetGroupCode,HospitalCode,IsDefault
    s ExtCode=$$ALPHAUP^SSUTIL4(rset.GetData(1))
    s SpecimenCode=rset.GetData(2)
    s Specimen=rset.GetData(3)
    s ContainerCode=rset.GetData(4)
	s ContainerDesc=rset.GetData(5)
    s TestSetGroupCode=rset.GetData(6)
    s HospitalCode=rset.GetData(7)
    s IsDefault=rset.GetData(8)
    
    continue:ContainerCode=""
    continue:Specimen=""

    s rsIndex=rsIndex+1   ;本次取的的满足条件的序号
    continue:(rsIndex<stIndex)
    s Count=Count+1     ;本次请求的满足条件的数量
    if (Count>expNum){
      s rsIndex=rsIndex-1
      q
    }

    s Data=$LB(Count,ExtCode,SpecimenCode,Specimen,ContainerCode,ContainerDesc,TestSetGroupCode,HospitalCode)
    for index=1:1:$ll(Data) do
    .set Data=$lu(Data,index,##class(BILL.CES.COM.Util).EscapeMysqlStr($lg(Data,index)))
    set sql= "INSERT INTO ARC_ItemExternalInfo (ID,ExtCode,SpecimenCode,Specimen,ContainerCode,ContainerDesc,TestSetGroupCode,HospitalCode)"
    set sql= sql_" VALUES ("_$lts(Data,",")_");"
    do stream.Write(sql)
    }
    s endIndex=-1
    s:Count>0 endIndex=rsIndex+1
    do stream.Write("^"_endIndex) 
    q stream
}

/***
  **Description      :插件管理表 (WebsysAddIns)
  **Author           :zhouc
  **Time             :2021/04/23
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Export).GetWebsysAddIns(1,10000)
  **Parameter        :
  **Returns          :
***/
ClassMethod GetWebsysAddIns(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
    set tabName="websys.AddIns"
    set queryColumn=" TOP "_(+expNum) 
    set queryColumn= queryColumn_" * "
    set condition=" %ID >"_(+stIndex)
    quit ##Class(BILL.CES.BL.Export).GetDataByTabName(tabName, queryColumn, condition)
}

/***  
  **Description      :硬件参数维护函数表 (DHCCardHardComManager)
  **Author           :zhouc
  **Time             :2021/04/23
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Export).GetDHCCardHardComManager(1,10000)
  **Parameter        :
  **Returns          :
***/
ClassMethod GetDHCCardHardComManager(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
    set tabName="DHC_CardHardComManager"
    set queryColumn=" TOP "_(+expNum) 
    set queryColumn= queryColumn_" * "
    set condition=" %ID >"_(+stIndex)
    quit ##Class(BILL.CES.BL.Export).GetDataByTabName(tabName, queryColumn, condition)
}

/***
  **Description      :硬件参数维护函数表 (DHCCardHardDLLFunction)
  **Author           :zhouc
  **Time             :2021/04/23
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Export).GetDHCCardHardDLLFunction(1,10000)
  **Parameter        :
  **Returns          :
***/
ClassMethod GetDHCCardHardDLLFunction(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
    set tabName="DHC_CardHardDLLFunction"
    set queryColumn=" TOP "_(+expNum) 
    set queryColumn= queryColumn_" * "
    set condition=" CDF_CCM_ParRef >"_(+stIndex)
    quit ##Class(BILL.CES.BL.Export).GetDataByTabName(tabName, queryColumn, condition)
}

/***
  **Description      :医生站配置中相关项目插入到dicdata 的SQL
  **Author           :zhouc
  **Time             :2021/06/29
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Export).GetDocDicData()
  **Parameter        :
  **Returns          :
***/
ClassMethod GetDocDicData()
{
    s DocConfigSql=""
    
    //0.删除dicdata项目
    //s DelSql=..DelDocDicData()
    //s:DelSql'="" DocConfigSql=$s(DocConfigSql="":DelSql,1:DocConfigSql_";"_DelSql) 
    
    //1.挂号相关配置
    s RegConfigSql=..GetRegArcimConf()
    s:RegConfigSql'="" DocConfigSql=$s(DocConfigSql="":RegConfigSql,1:DocConfigSql_";"_RegConfigSql) 
    
    
    q DocConfigSql
}

/***
  **Description      :删除dicdata相关配置语句
  **Author           :zhouc
  **Time             :2021/06/29
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Export).GetRegArcimConf()
  **Parameter        :
  **Returns          :
***/
ClassMethod DelDocDicData()
{
    s UserName=..#DataCreateUser
    s DelSql="DELETE FROM `dicdata` WHERE `create_user`='"_UserName_"'"
    q DelSql
}

/***
  **Description      :医生站配置中挂号相关配置
  **Author           :zhouc
  **Time             :2021/06/29
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Export).GetRegArcimConf()
  **Parameter        :
  **Returns          :
***/
ClassMethod GetRegArcimConf()
{
    s UserName=..#DataCreateUser
    s ConfigSql=""
    
    s DocConfNodes="MRArcimId"_"|"_"病历本费医嘱"
    s DocConfNodes=DocConfNodes_"^"_"NeedBillCardFeeOrder"_"|"_"卡费医嘱"
    s DocConfNodes=DocConfNodes_"^"_"RegFeeBillSub"_"|"_"挂号费账单子类"
    s DocConfNodes=DocConfNodes_"^"_"CheckFeeBillSub"_"|"_"诊查费账单子类"
    s DocConfNodes=DocConfNodes_"^"_"ReCheckFeeBillSub"_"|"_"复诊费账单子类"
    s DocConfNodes=DocConfNodes_"^"_"AppFeeBillSub"_"|"_"预约费账单子类"
    s DocConfNodes=DocConfNodes_"^"_"HoliFeeBillSub"_"|"_"假日费账单子类"
    s DocConfNodes=DocConfNodes_"^"_"OtherFeeBillSub"_"|"_"其他账单子类"
    
    s HospDrs=""
    s HospDr=0
    f {
        s HospDr=$o(^CT("HOSP",HospDr))
        q:HospDr=""
        continue:("^"_HospDrs_"^")[("^"_HospDr_"^")
        s HospDrs=$s(HospDrs="":HospDr,1:HospDrs_"^"_HospDr)
    }
    s:HospDrs'[("^^") HospDrs=HospDrs_"^"
    f HospInd=1:1:$l(HospDrs,"^"){
        s HospItem=$p(HospDrs,"^",HospInd)
        i HospItem'=""{
            s HospDesc=$p(^CT("HOSP",HospItem),"^",2)
        }else{
            s HospDesc="院区通用"
        }
        //1.医生站配置,挂号医嘱账单子类配置
        f DocConfInd=1:1:$l(DocConfNodes,"^"){
            s DocConfNodeItem=$p(DocConfNodes,"^",DocConfInd)
            s DocConfNode=$p(DocConfNodeItem,"|",1)
            s DocConfNodeDesc=$p(DocConfNodeItem,"|",2)
            s DocConfVal=$$GetSpecConfigNode(DocConfNode,HospItem)
            
            s:DocConfNode="NeedBillCardFeeOrder" DocConfVal=$p(DocConfVal,"@",1)
            s:DocConfNode="MRArcimId" DocConfVal=$p(DocConfVal,"@",1)
            
            continue:DocConfVal=""
            s SQLVal="RegArcimConf"
            s SQLVal=SQLVal_"^"_DocConfNode
            s SQLVal=SQLVal_"^"_DocConfNodeDesc
            s SQLVal=SQLVal_"^"_""
            s SQLVal=SQLVal_"^"_"Y"
            s SQLVal=SQLVal_"^"_HospItem
            s SQLVal=SQLVal_"^"_DocConfVal
            s SQLVal=SQLVal_"^"_""
            s SQLVal=SQLVal_"^"_"RegArcimConf"
            s SQLVal=SQLVal_"^"_UserName
            s SQLVal=SQLVal_"^"_$zdt($h,3)
            s SQLStr=..GetInsertSQL(SQLVal,"R")

            s ConfigSql=ConfigSql_SQLStr
        }
        //2.是否收在不收取诊查费的时候不收取挂号费 本地有配置时不再插入
        s SQLVal="JFOPPara"
        s SQLVal=SQLVal_"^"_"NoCheckNoReg"
        s SQLVal=SQLVal_"^"_"是否同时判断是否收取挂号费和诊查费"
        s SQLVal=SQLVal_"^"_"Y:是,N:否 在医生站就诊登记时,若配置为:Y 则提示:是否插入挂号费和诊查费医嘱 ,以此判断是否插入两费医嘱;若配置为 N ,则提示:是否插入诊查费医嘱 ,挂号费医嘱默认总会插入"
        s SQLVal=SQLVal_"^"_"Y"
        s SQLVal=SQLVal_"^"_HospItem
        s SQLVal=SQLVal_"^"_"N"
        s SQLVal=SQLVal_"^"_""
        s SQLVal=SQLVal_"^"_"JFOPPara"
        s SQLVal=SQLVal_"^"_UserName
        s SQLVal=SQLVal_"^"_$zdt($h,3)
        s SQLStr=..GetInsertSQL(SQLVal,"I")
        s ConfigSql=ConfigSql_SQLStr

        //6.中草药子类
        s CNMedItemCatStr=##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr(HospItem)
        s CNMedItemCatStr=$replace(CNMedItemCatStr,"^",",")
        s:CNMedItemCatStr'="" CNMedItemCatStr=","_CNMedItemCatStr_","
        s SQLVal="DOCOPPara"
        s SQLVal=SQLVal_"^"_"CNMedItemCatStr"
        s SQLVal=SQLVal_"^"_"中草药子类"
        s SQLVal=SQLVal_"^"_"客户端不要改动"
        s SQLVal=SQLVal_"^"_"Y"
        s SQLVal=SQLVal_"^"_HospItem
        s SQLVal=SQLVal_"^"_CNMedItemCatStr
        s SQLVal=SQLVal_"^"_""
        s SQLVal=SQLVal_"^"_"DOCOPPara"
        s SQLVal=SQLVal_"^"_UserName
        s SQLVal=SQLVal_"^"_$zdt($h,3)
        s SQLStr=..GetInsertSQL(SQLVal,"R")
        s ConfigSql=ConfigSql_SQLStr
    }
    //3.是否启用收费处挂号费诊后结算模式
    s SQLVal="JFOPPara"
    s SQLVal=SQLVal_"^"_"BillRegLast"
    s SQLVal=SQLVal_"^"_"结算时收取挂号费"
    s SQLVal=SQLVal_"^"_"Y:是,N:否;设置为Y时,计费端就诊登记时不对挂号医嘱进行结算"
    s SQLVal=SQLVal_"^"_"Y"
    s SQLVal=SQLVal_"^"_""
    s SQLVal=SQLVal_"^"_"N"
    s SQLVal=SQLVal_"^"_""
    s SQLVal=SQLVal_"^"_"JFOPPara"
    s SQLVal=SQLVal_"^"_UserName
    s SQLVal=SQLVal_"^"_$zdt($h,3)
    s SQLStr=..GetInsertSQL(SQLVal,"I")
    //默认不下载此项,若有需要,可放开,存在漏挂号费风险
    //s ConfigSql=ConfigSql_SQLStr

    //4.当插入挂号医嘱时才打印挂号单
    s SQLVal="JFOPPara"
    s SQLVal=SQLVal_"^"_"PrintOnlyInsOrd"
    s SQLVal=SQLVal_"^"_"插入挂号医嘱时才打印挂号单"
    s SQLVal=SQLVal_"^"_"Y:是,N:否;设置为Y时,只有插入挂号医嘱时才打印挂号条"
    s SQLVal=SQLVal_"^"_"Y"
    s SQLVal=SQLVal_"^"_""
    s SQLVal=SQLVal_"^"_"N"
    s SQLVal=SQLVal_"^"_""
    s SQLVal=SQLVal_"^"_"JFOPPara"
    s SQLVal=SQLVal_"^"_UserName
    s SQLVal=SQLVal_"^"_$zdt($h,3)
    s SQLStr=..GetInsertSQL(SQLVal,"I")
    s ConfigSql=ConfigSql_SQLStr
    //5.限制实时检索关键字长度 小于等于此配置数量 的关键字长度不进行自动检索 为0 时,全部字段实时检索
    s SQLVal="JFOPPara"
    s SQLVal=SQLVal_"^"_"LimitAutSearchNum"
    s SQLVal=SQLVal_"^"_"限制实时检索关键字长度"
    s SQLVal=SQLVal_"^"_"小于等于此配置数量的关键字长度不进行自动检索 为0 时,全部字段实时检索,例如:配置为2,检索医嘱时2个字符(不算模糊检索字符和空格)及以内的关键字,不会实时检索,若需检索,需输入空格,进行强制检索"
    s SQLVal=SQLVal_"^"_"Y"
    s SQLVal=SQLVal_"^"_""
    s SQLVal=SQLVal_"^"_"2"
    s SQLVal=SQLVal_"^"_""
    s SQLVal=SQLVal_"^"_"JFOPPara"
    s SQLVal=SQLVal_"^"_UserName
    s SQLVal=SQLVal_"^"_$zdt($h,3)
    s SQLStr=..GetInsertSQL(SQLVal,"I")
    s ConfigSql=ConfigSql_SQLStr

    //6.默认按排班过滤医生
    s SQLVal="JFOPPara"
    s SQLVal=SQLVal_"^"_"DefFilterByApptSchedule"
    s SQLVal=SQLVal_"^"_"默认按排班过滤医生"
    s SQLVal=SQLVal_"^"_"Y:是,N:否;"
    s SQLVal=SQLVal_"^"_"Y"
    s SQLVal=SQLVal_"^"_""
    s SQLVal=SQLVal_"^"_"N"
    s SQLVal=SQLVal_"^"_""
    s SQLVal=SQLVal_"^"_"JFOPPara"
    s SQLVal=SQLVal_"^"_UserName
    s SQLVal=SQLVal_"^"_$zdt($h,3)
    s SQLStr=..GetInsertSQL(SQLVal,"I")
    s ConfigSql=ConfigSql_SQLStr
    
    Q ConfigSql
    
GetSpecConfigNode(NodeName, HospId)
    q:NodeName="" ""
    s str=""
    if (HospId'="") {
        s HospCodeNode="HospDr_"_HospId
        s str=$g(^DHCOPRegConfig(HospCodeNode,NodeName))
    }else{
        s str=$g(^DHCOPRegConfig(NodeName))
    }
    q str
}

/***
  **Description      :医生站配置sql语句处理
  **Author           :zhouc
  **Time             :2021/06/29
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Export).GetLocalConfig()
  **Parameter        :ConfVal:type^code^desc^demo^activeflag^hospital^concode^condesc^relation_dic^create_user^create_datetime
  **                  InsertType:"I":ignore-忽略插入 ; "R":"replace"-替代插入 ;"" :普通插入
  **Returns          :
***/
ClassMethod GetInsertSQL(ConfVal, InsertType = "")
{
    s OpBase="INSERT INTO `dicdata` (`type`,`code`,`desc`,`demo`,`activeflag`,`hospital`,`concode`,`condesc`,`relation_dic`,`create_user`,`create_datetime`) "
    s DocConfType=$p(ConfVal,"^",1)
    s DocConfCode=$p(ConfVal,"^",2)
    s HospId=$p(ConfVal,"^",6)
    s ColVals=$$FormatVal(DocConfType)
    s ColVals=ColVals_","_$$FormatVal(DocConfCode)
    s ColVals=ColVals_","_$$FormatVal($p(ConfVal,"^",3))
    s ColVals=ColVals_","_$$FormatVal($p(ConfVal,"^",4))
    s ColVals=ColVals_","_$$FormatVal($p(ConfVal,"^",5))
    s ColVals=ColVals_","_$$FormatVal(HospId)
    s ColVals=ColVals_","_$$FormatVal($p(ConfVal,"^",7))
    s ColVals=ColVals_","_$$FormatVal($p(ConfVal,"^",8))
    s ColVals=ColVals_","_$$FormatVal($p(ConfVal,"^",9))
    s ColVals=ColVals_","_$$FormatVal($p(ConfVal,"^",10))
    s ColVals=ColVals_","_$$FormatVal($p(ConfVal,"^",11))
    if (InsertType="I"){
        //存在记录时忽略
        s SQLStr=OpBase_"SELECT "
        s SQLStr=SQLStr_ColVals
        s SQLStr=SQLStr_" where not exists ("
        s SQLStr=SQLStr_" select * from `dicdata` where `type` ="_$$FormatVal(DocConfType)
        s SQLStr=SQLStr_" and `code`="_$$FormatVal(DocConfCode)
        if (HospId=""){
            s SQLStr=SQLStr_" and (`hospital` is NUll or `hospital`='' )"
        }else{
            s SQLStr=SQLStr_" and `hospital`="_$$FormatVal(HospId)
        }
        s SQLStr=SQLStr_");"
    }elseif(InsertType="R"){
        //存在记录时替代
        s DelSQL="DELETE FROM `dicdata` WHERE `type` ="_$$FormatVal(DocConfType)
        s DelSQL=DelSQL_" and `code`="_$$FormatVal(DocConfCode)
        if (HospId=""){
            s DelSQL=DelSQL_" and (`hospital` is NUll or `hospital`='' )"
        }else{
            s DelSQL=DelSQL_" and `hospital`="_$$FormatVal(HospId)
        }
        s DelSQL=DelSQL_";"
        s SQLStr=DelSQL_OpBase_"VALUES ("
        s SQLStr=SQLStr_ColVals
        s SQLStr=SQLStr_");"
    }else{
        s SQLStr=OpBase_"VALUES ("
        s SQLStr=SQLStr_ColVals
        s SQLStr=SQLStr_");"
    }
    q SQLStr
FormatVal(Val)
    q:Val'="" "'"_Val_"'"
    q "NULL"
}

/// d ##Class(DHCDoc.Interface.StandAlone.Export).Test()
ClassMethod Test() As %Status
{
    &SQL(SELECT  TOP 10000 *  FROM  SQLUser.DHC_RBCSessionTypeService 
     WHERE  (($PIECE(%ID,'||')=1 AND ($PIECE(%ID,'||',2)>0)) OR ($PIECE(%ID,'||')>1 )))
    ;CAST(($PIECE(Code,'_',2))
     b ;2
}

/***
  **Description      :医嘱模板大类
  **Author           :zhouc
  **Time             :2022/10/19
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Export).GetARCOrdFavCat(1,1000).Read()
  **Parameter        :
  **Returns          :
***/
ClassMethod GetARCOrdFavCat(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
    set tabName="ARC_OrdFavCat"
    if (##class(MySQLDB).IsTableExist(tabName)=1){
        set queryColumn=" TOP "_(+expNum) 
        set queryColumn= queryColumn_" * "
        set condition=" %ID >"_(+stIndex)
        quit ##Class(BILL.CES.BL.Export).GetDataByTabName(tabName, queryColumn, condition)
    }else{
        set stream=##class(%Stream.GlobalCharacter).%New()
        do stream.Write("^-1") 
        q stream
    }
}

/***
  **Description      :医嘱模板子类
  **Author           :zhouc
  **Time             :2022/10/19
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Export).GetARCOrdFavSubCat(1,1000).Read()
  **Parameter        :
  **Returns          :
***/
ClassMethod GetARCOrdFavSubCat(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
    set tabName="ARC_OrdFavSubCat"
    if (##class(MySQLDB).IsTableExist(tabName)=1){
        set queryColumn=" TOP "_(+expNum) 
        set queryColumn= queryColumn_" * "
        set condition=" %ID >"_(+stIndex)
        quit ##Class(BILL.CES.BL.Export).GetDataByTabName(tabName, queryColumn, condition)
    }else{
        set stream=##class(%Stream.GlobalCharacter).%New()
        do stream.Write("^-1") 
        q stream
    }
}

/***
  **Description      :医嘱模板项目
  **Author           :zhouc
  **Time             :2022/10/19
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Export).GetARCOrdFavItem(1,1000).Read()
  **Parameter        :
  **Returns          :
***/
ClassMethod GetARCOrdFavItem(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
    set tabName="ARC_OrdFavItem"
    if (##class(MySQLDB).IsTableExist(tabName)=1){
        set queryColumn=" TOP "_(+expNum) 
        set queryColumn= queryColumn_" * "
        set condition=" %ID >"_(+stIndex)
        quit ##Class(BILL.CES.BL.Export).GetDataByTabName(tabName, queryColumn, condition)
    }else{
        set stream=##class(%Stream.GlobalCharacter).%New()
        do stream.Write("^-1") 
        q stream
    }
}

ClassMethod GetDHCUserFavItems(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
    set tabName="DHC_UserFavItems"
    if (##class(MySQLDB).IsTableExist(tabName)=1){
        set queryColumn=" TOP "_(+expNum) 
        set queryColumn= queryColumn_" * "
        set condition=" %ID >"_(+stIndex)
        quit ##Class(BILL.CES.BL.Export).GetDataByTabName(tabName, queryColumn, condition)
    }else{
        set stream=##class(%Stream.GlobalCharacter).%New()
        do stream.Write("^-1") 
        q stream
    }
}

ClassMethod GetARCOrdSetsHosp(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
    set tabName="ARC_OrdSetsHosp"
    if (##class(MySQLDB).IsTableExist(tabName)=1){
        set queryColumn=" TOP "_(+expNum) 
        set queryColumn= queryColumn_" * "
        set condition=" %ID >"_(+stIndex)
        quit ##Class(BILL.CES.BL.Export).GetDataByTabName(tabName, queryColumn, condition)
    }else{
        set stream=##class(%Stream.GlobalCharacter).%New()
        do stream.Write("^-1") 
        q stream
    }
}

/***
  **Description      :医嘱套明细中的医嘱
  **Author           :zhouc
  **Time             :2022/10/19
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Export).GetARCOrdSetDateOS(1,1000).Read()
  **Parameter        :
  **Returns          :
***/
ClassMethod GetARCOrdSetDateOS(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
    set tabName="ARC_OrdSetDateOS"
    if (##class(MySQLDB).IsTableExist(tabName)=1){
        set queryColumn=" TOP "_(+expNum) 
        set queryColumn=queryColumn_" * "
        set condition=" ((OS_ParRef->DATE_ParRef="_+$p(stIndex,"||",1)_" AND OS_ParRef->DATE_Childsub="_+$p(stIndex,"||",2)_" AND OS_Childsub>"_+$p(stIndex,"||",3)_")"
        set condition=condition_" OR (OS_ParRef->DATE_ParRef="_+$p(stIndex,"||",1)_" AND OS_ParRef->DATE_Childsub>"_+$p(stIndex,"||",2)_")"
        set condition=condition_" OR (OS_ParRef->DATE_ParRef>"_+$p(stIndex,"||",1)_" ))"
        set condition=condition_" ORDER BY OS_ParRef->DATE_ParRef,OS_ParRef->DATE_Childsub,OS_Childsub"
        quit ##Class(BILL.CES.BL.Export).GetDataByTabName(tabName, queryColumn, condition,2)
    }else{
        set stream=##class(%Stream.GlobalCharacter).%New()
        do stream.Write("^-1") 
        q stream
    }
}

/***
  **Description      :排班表数据
  **Author           :zhouc
  **Time             :2023/04/21
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Export).GetRBApptSchedule(1,1000).Read()
  **Parameter        :
  **Returns          :
***/
ClassMethod GetRBApptSchedule(stIndex As %String = "", expNum As %Integer = 0) As %Stream.GlobalCharacter
{
    set tabName="RB_ApptSchedule ra,DHC_RBApptSchedule dhcra"
    set queryColumn=" TOP "_(+expNum) 
    set queryColumn= queryColumn_" ra.*,dhcra.AS_SessionType_DR as DHC_AS_SessionType_DR "
    set condition=" (($PIECE(ra.%ID,'||')="_+$p(stIndex,"||",1)_" AND ($PIECE(ra.%ID,'||',2)>"_+$p(stIndex,"||",2)_"))"
    set condition=condition_" OR ($PIECE(ra.%ID,'||')>"_+$p(stIndex,"||",1)_" ))"
    set condition=condition_" AND (ra.AS_Date >='"_$zd(+$h,3)_"' )"
    set condition=condition_" AND (ra.AS_Date <='"_$zd(+$h+7,3)_"' )"
    set condition=condition_" AND (ra.AS_Rowid=dhcra.AS_RowId)"
    set condition=condition_" ORDER BY AS_RES_PARREF ASC,AS_CHILDSUB ASC"
    quit ##Class(BILL.CES.BL.Export).GetDataByTabName(tabName, queryColumn, condition,2)
}

}
