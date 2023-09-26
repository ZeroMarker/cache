Import SQLuser

/// 名称: 站点和项目组合
/// 编写者：xy
/// 编写日期: 2021-08-11
Class web.DHCPE.CT.StationOrder Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：    xy 
/// CreatDate：  20210811
/// Description: 站点和项目组合更新/插入数据
/// Table：      站点和项目组合表 DHC_PE_StationOrder
/// Input:       InputStr(站点ID^数据ID^医嘱项ID^激活^表名^科室ID^用户ID^单独授权)
/// Return：
/// debug:d ##class(web.DHCPE.CT.StationOrder).Insert("12^^10836||1^Y^DHC_PE_StationOrder^152^12187^N")
ClassMethod Insert(InputStr As %String)
{
    s ^tempdhcpe("InsertOrder")=InputStr
    n (InputStr)
    s StationID=$p(InputStr,"^",1)
    s ARCIMID=$p(InputStr,"^",3)
    s Active=$p(InputStr,"^",4)
    s tableName=$p(InputStr,"^",5)
    s LocID=$p(InputStr,"^",6)
    s UserID=$p(InputStr,"^",7)
    s Empower=$p(InputStr,"^",8)
    s ReportFormat=$p(InputStr,"^",9)
    s PatItemName=$p(InputStr,"^",10)
    s UpdateDate=$p($h,",",1)
    s UpdateTime=$p($h,",",2)
    
    s $ZT="InsertOrderErr"
    
    s result=-1
    Set OrderDR=""
    Set xSTID=""
    For {
        Set xSTID=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,xSTID))
        Quit:xSTID=""
        
        Set xOrdSub=""
        For {
            Set xOrdSub=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,xSTID,xOrdSub))
            Quit:xOrdSub=""
            
            Continue:##class(User.DHCPEStationOrder).GetLocShowDataFlag(xSTID_"||"_xOrdSub,LocID)'="Y"
            Set OrderDR=xSTID_"||"_xOrdSub
        }
    }
    Quit:OrderDR'="" OrderDR
    
    TSTART
    ;b ;1
    If OrderDR="" {
        &sql(insert into DHC_PE_StationOrder(STORD_ParRef,STORD_ARCIM_DR,STORD_NoActive,STORD_UpdateDate,STORD_UpdateTime,STORD_UpdateUserDR)
             values(:StationID,:ARCIMID,:Active,:UpdateDate,:UpdateTime,:UserID)
        )
        ;b ; SQLCODE
       //站点项目组合表插入数据失败
        If (SQLCODE'=0){ 
            s result="-1^插入站点项目组合表失败"
            goto InsertOrderErr
        }
        s RowID=%ROWID
        ;b ;tableName,RowID,LocID,UserID,Empower
        
        s ret=##class(User.DHCPEStationOrder).SaveDataToPowerControl(RowID,LocID,UserID,Empower)
        //表记录授权插入数据失败
        If ($p(ret,"^",1)="-1"){
            s result="-1^插入记录授权表失败"
            goto InsertOrderErr
        }
    } Else {
        s RowID=OrderDR
    }
    //检查类的自动插入细项，且将大项和细项进行关联
    Set StationID=+RowID
    s StationType=##class(web.DHCPE.CT.HISUICommon).GetStationTypeByID(StationID,LocID)
    i (StationType'="") {
        s ret=##class(web.DHCPE.CT.StationOrder).InsertArcDetail(ARCIMID,StationID,StationType,"",RowID,ReportFormat,PatItemName,LocID,UserID)
        If ($p(ret,"^",1)="-1"){
            s result="-1^插入数据失败"
            goto InsertOrderErr
        }
    }
    
    TCommit
    s result="0^插入成功"
    q result
    
InsertOrderErr
    TROLLBACK 
    //q $ZE
    q result
}

/// Creator：    xy 
/// CreatDate：  20211209
/// Description: 根据站点获取细项编码
/// Input:       StationID(站点ID)
/// Return：     细项编码
/// Debug:d ##class(web.DHCPE.CT.StationOrder).GetODCode()
ClassMethod GetODCode(StationID)
{
    q:StationID="" ""
    s ODCodeH="PE"_$P($g(^DHCPEST(StationID)),"^",1)
    s ODCode=$o(^DHCPEST(0,"OD_Code",ODCodeH_"999999"),-1)
    if $e(ODCode,1,$l(ODCodeH))=ODCodeH {
    s num=+$e(ODCode,$l(ODCodeH)+1,*)+1
    } else {
        s num=1
    }
    s ODCode=ODCodeH_$e("00000000",1,3-$l(num))_num
    q ODCode
}

/// Creator：    xy 
/// CreatDate：  20211209
/// Description: 根据医嘱项、站点获取默认的导诊单格式
/// Input:       ARCID(医嘱项ID), StationID(站点ID), StationType(站点类型LIS/RIS)
/// Return：     导诊单类别ID
/// Debug:d ##class(web.DHCPE.CT.StationOrder).GetDefPatItemCat()
ClassMethod GetDefPatItemCat(ARCID, StationID, StationType)
{
    q:(ARCID="")||(StationID="") ""
    s ArcimName=$p($g(^ARCIM(+ARCID,$p(ARCID,"||",2),1)),"^",2)
    s StationDesc=$p($g(^DHCPEST(StationID)),"^",2)
    i StationType="LIS" d
    .i ArcimName["便" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □便常规",0))
    .e  i ArcimName["尿" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □尿常规",0))
    .e  s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □空腹抽血",0))
    i StationType="RIS" d
    .i StationDesc["超声" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □超声检查",0))
    .e  i StationDesc["核磁" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □核磁",0))
    .e  i StationDesc["放射" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □放射检查",0))
    .e  i StationDesc["心电" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □心电图",0))
    .e  i StationDesc["骨密度" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □骨密度",0))
    .e  i StationDesc["肺功能" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □肺功能",0))
    .s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □超声检查",0))
    i StationType="NOR" d
    .i StationDesc["一般检查" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □一般检查",0))
    .i StationDesc["内科" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □内科",0))
    .i StationDesc["外科" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □外科",0))
    .i StationDesc["眼科" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □眼科",0))
    .i StationDesc["耳鼻喉科" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □耳鼻喉科",0))
    .i StationDesc["妇科" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □妇科",0))
    .i StationDesc["口腔科" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □口腔科",0))
    .i StationDesc["神经内科" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □神经内科",0))
    .i StationDesc["内分泌科" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □内分泌科",0))
    .i StationDesc["消化科" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □消化科",0))
    .i StationDesc["药品" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □药品",0))
    .i StationDesc["其他" s PatItemName=$o(^CF.PE.UsherItemCatI("IdxOfLocCat"," "_LocID," □其他",0))


    q PatItemName
}

/// Creator：    xy 
/// CreatDate：  20211207
/// Description: 站点项目组合新增项目时，自动插入站点项目组合扩展表、细项表、细项扩展表，且进行大项细项关联
/// Input:       ARCID:医嘱项ID, StationID:站点ID, StationType:站点类型, Sequence:顺序号, 
///              OrderDR:站点项目组合ID, ReportFormat:报告格式, PatItemName:导诊单类别ID, 
///              LocID:科室ID, UserID:用户ID   
/// Return：     0(成功)
/// Debug:d ##class(web.DHCPE.CT.StationOrder).InsertArcDetail("11108||1",12,"RIS","","12||114","","","152","12187")
ClassMethod InsertArcDetail(ARCID, StationID, StationType, Sequence, OrderDR, ReportFormat, PatItemName, LocID, UserID)
{
    ;b ;InsertArcDetail
    s ^tempdhcpe("InsertArcDetail")=$lb(ARCID, StationID, StationType, Sequence, OrderDR,ReportFormat,PatItemName, LocID, UserID)
     
    s LocGrpID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetLocGrpByLocID(LocID)
    i $p(LocGrpID,"^",1)="-1" q "1^该科室没有维护对应的默认科室"   
    s LocStr=##class(web.DHCPE.CT.DHCPEMappingLoc).GetLocIDByLocGrp(LocGrpID)
    i $p(LocStr,"^",1)="-1"  q "-1^科室组下没有对应的科室ID"

    s SQLCODE=0
    i PatItemName="" s PatItemName=##class(web.DHCPE.CT.StationOrder).GetDefPatItemCat(ARCID,StationID,StationType)
    ;b ;StationType
    
    /*******************常规检查类医嘱*********************/
    i StationType="NOR" d
    .s ReportFormat="RF_NOR"
    ./***********插入站点项目组合扩展表 Start**********/
    .f LISSOSLocNum=1:1:$l(LocStr,"^") d
    ..s CurLocID=$P(LocStr,"^",LISSOSLocNum)
    ..s IFPrint="Y",IFReprotPrint="Y",AutoReturn="Y",Diet="N",SOSNoActive="Y",UpdateDate=+$h,UpdateTime=$p($h,",",2),UpdateUserDR=UserID
    ..s StatOrdSetID=""
    ..s StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_CurLocID,OrderDR,0))
    ..i StatOrdSetID="" d
    ...&SQL(insert into sqluser.DHC_PE_StationOrderSet
        (SOS_OrderDR,SOS_LocDR,SOS_Diet,SOS_ReportFormat,SOS_AutoReturn,SOS_IFReprotPrint,SOS_UsherItemCatDR,SOS_NoActive,SOS_UpdateDate,SOS_UpdateTime,SOS_UpdateUserDR) 
        values(:OrderDR,:CurLocID,:Diet,:ReportFormat,:AutoReturn,:IFReprotPrint,:PatItemName,:SOSNoActive,:UpdateDate,:UpdateTime,:UpdateUserDR))
    ...i SQLCODE'=0 s SQLCODE="-1^插入站点项目组合扩展表失败"
    ...q:SQLCODE'=0
    ...s StatOrdSetID=%ROWID
    ...s ret=##class(User.DHCPEStationOrderSet).SaveDataToPowerControl(StatOrdSetID,CurLocID,UserID)
    ...If ($p(ret,"^",1)="-1") s SQLCODE="-1^站点项目组合扩展插入记录授权表失败"  
    ...q:SQLCODE'=0
    .
    ./***********插入站点项目组合扩展表 end**********/

    /*******************检验类医嘱*********************/
    s ThirdPartyLIS=$g(^DHCPESetting("DHCPE","ThirdPartyLIS",LocID))
    i StationType="LIS" d
    .s ReportFormat="RF_LIS"
    ./***********插入站点项目组合扩展表 Start**********/
    .f LISSOSLocNum=1:1:$l(LocStr,"^") d
    ..s CurLocID=$P(LocStr,"^",LISSOSLocNum)
    ..s IFPrint="Y",IFReprotPrint="Y",AutoReturn="Y",Diet="N",SOSNoActive="Y",UpdateDate=+$h,UpdateTime=$p($h,",",2),UpdateUserDR=UserID
    ..s StatOrdSetID=""
    ..s StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_CurLocID,OrderDR,0))
    ..i StatOrdSetID="" d
    ...&SQL(insert into sqluser.DHC_PE_StationOrderSet
        (SOS_OrderDR,SOS_LocDR,SOS_Diet,SOS_ReportFormat,SOS_AutoReturn,SOS_IFReprotPrint,SOS_UsherItemCatDR,SOS_NoActive,SOS_UpdateDate,SOS_UpdateTime,SOS_UpdateUserDR) 
        values(:OrderDR,:CurLocID,:Diet,:ReportFormat,:AutoReturn,:IFReprotPrint,:PatItemName,:SOSNoActive,:UpdateDate,:UpdateTime,:UpdateUserDR))
    ...i SQLCODE'=0 s SQLCODE="-1^插入站点项目组合扩展表失败"
    ...q:SQLCODE'=0
    ...s StatOrdSetID=%ROWID
    ...s ret=##class(User.DHCPEStationOrderSet).SaveDataToPowerControl(StatOrdSetID,CurLocID,UserID)
    ...If ($p(ret,"^",1)="-1") s SQLCODE="-1^站点项目组合扩展插入记录授权表失败"  
    ...q:SQLCODE'=0
    .
    ./***********插入站点项目组合扩展表 end**********/
    .i ThirdPartyLIS="Y" d   //导入检验细项
    ..s SQLCODE=##class(web.DHCPE.TransOrderDetail).MainNew(ARCID,StationID,OrderDR,LocID,UserID,LocStr)  //自动插入检验细项
    
    /*******************检查类医嘱*********************/
    i StationType="RIS" d
    .
    ./***********插入站点项目组合扩展表 Start**********/
    .s ReportFormat="RF_RIS"
    .f RISSOSLocNum=1:1:$l(LocStr,"^") d
    ..s CurLocID=$P(LocStr,"^",RISSOSLocNum)
    ..s IFPrint="Y",IFReprotPrint="Y",AutoReturn="Y",Diet="N",SOSNoActive="Y",UpdateDate=+$h,UpdateTime=$p($h,",",2),UpdateUserDR=UserID
    ..s StatOrdSetID=""
    ..s StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_CurLocID,OrderDR,0))
    ..i StatOrdSetID="" d
    ...&SQL(insert into sqluser.DHC_PE_StationOrderSet
        (SOS_OrderDR,SOS_LocDR,SOS_Diet,SOS_ReportFormat,SOS_AutoReturn,SOS_IFReprotPrint,SOS_UsherItemCatDR,SOS_NoActive,SOS_UpdateDate,SOS_UpdateTime,SOS_UpdateUserDR) 
        values(:OrderDR,:CurLocID,:Diet,:ReportFormat,:AutoReturn,:IFReprotPrint,:PatItemName,:SOSNoActive,:UpdateDate,:UpdateTime,:UpdateUserDR))
    ...i SQLCODE'=0 s SQLCODE="-1^插入站点项目组合扩展表失败"
    ...q:SQLCODE'=0
    ...s StatOrdSetID=%ROWID
    ...;b ;插入细项表 SQLCODE StatOrdSetID
    ...s ret=##class(User.DHCPEStationOrderSet).SaveDataToPowerControl(StatOrdSetID,CurLocID,UserID)
    ...;b ;插入细项表 ret
    ...If ($p(ret,"^",1)="-1") s SQLCODE="-1^站点项目组合扩展插入记录授权表失败" 
    ...q:SQLCODE'=0
    
    ./***********插入站点项目组合扩展表 end**********/
    .
    ./***********插入细项表 start**********/
    .s Sequence=1
    .s SequenceStr=##class(web.DHCPE.CT.StationOrder).GetODCode(StationID)
    .s:SequenceStr="" SQLCODE="-1^细项编码生成失败"
    .q:SQLCODE'=0
    .s OrdDetailDesc=$p($g(^ARCIM(+ARCID,$p(ARCID,"||",2),1)),"^",2)_"-检查结果"
    .s Type="T",DetailSex="N",Submit="Y",Advice="Y",UpdateDate=+$h,UpdateTime=$p($h,",",2),UpdateUserDR=UserID
    .s ExsistFlag=##class(web.DHCPE.CT.StatOrderDetail).IsExsistODDesc(StationID,OrdDetailDesc,LocID)
    .i ExsistFlag="0" d
    ..&sql(insert into sqluser.DHC_PE_OrderDetail 
    (
        OD_ParRef,OD_Code,OD_Desc,OD_Type,
        OD_Summary,OD_Advice,OD_Sequence,OD_Sex,
        OD_UpdateDate,OD_UpdateTime,OD_UpdateUserDR
    )values 
    (
        :StationID,:SequenceStr,:OrdDetailDesc,:Type,
        :Submit,:Advice,:Sequence,:DetailSex,
        :UpdateDate,:UpdateTime,:UpdateUserDR
    ))
    ..;b ;插入细项表 SQLCODE
    ..i SQLCODE'=0 s SQLCODE="-1^插入细项表失败"
    ..q:SQLCODE'=0
    ..s OrdDetailID=%ROWID
    ..s Empower="N" 
    ..s ret=##class(User.DHCPEOrderDetail).SaveDataToPowerControl(OrdDetailID,LocID,UserID,Empower) //插入授权表
    ..If ($p(ret,"^",1)="-1") s SQLCODE="-1^细项插入记录授权表失败"     
    ..q:SQLCODE'=0
    ../***********插入细项表 end**********/
    ..
    ../***********插入细项扩展表 start**********/
    ..f RISODSLocNum=1:1:$l(LocStr,"^") d
    ...s CurLocID=$P(LocStr,"^",RISODSLocNum)
    ...s Summary="Y",NoPrint="N",ODSetID=""
    ...s UpdateDate=+$h,UpdateTime=$p($h,",",2),UpdateUserDR=UserID
    ...s OrdDetailSetID=""
    ...s OrdDetailSetID=$o(^CF.PE.OrderDetailSetI("IdxOfLocOrdDtl"," "_CurLocID,OrdDetailID,0))
    ...i OrdDetailSetID=""  d
    ....&sql(insert into sqluser.DHC_PE_OrderDetailSet
    (
        ODS_OrderDtlDR,ODS_LocDR,ODS_Summary,ODS_NoPrint,
        ODS_UpdateDate,ODS_UpdateTime,ODS_UpdateUserDR
    )values 
    (
        :OrdDetailID,:CurLocID,:Summary,:NoPrint,
        :UpdateDate,:UpdateTime,:UpdateUserDR
    ))
    ....;b ;插入细项扩展表  SQLCODE
    ....i SQLCODE'=0 s SQLCODE="-1^插入细项扩展表失败"
    ....q:SQLCODE'=0
    ....s ODSetID=%ROWID //细项扩展表ID
    ....s ret=##class(User.DHCPEOrderDetailSet).SaveDataToPowerControl(ODSetID,CurLocID,UserID)
    ....If ($p(ret,"^",1)="-1") s SQLCODE="-1^细项扩展表插入记录授权表失败"    
    ....q:SQLCODE'=0
    ../***********插入细项扩展表 end**********/
    ..
    ../***********插入大项细项组合表 start**********/
    ..i OrdDetailID'="" d
    ...s IsExsistODRelate=##class(web.DHCPE.CT.OrderDetailRelate).IsExsistODRelate(OrderDR,OrdDetailID,LocID)
    ...i (IsExsistODRelate="0") d
    ....&SQL(insert into sqluser.DHC_PE_OrderDetailRelate 
        (ODR_OrderDR,ODR_ARCIM_DR,ODR_OD_DR,ODR_Sequence,ODR_Required,ODR_NoActive,ODR_UpdateDate,ODR_UpdateTime,ODR_UpdateUserDR) 
        values(:OrderDR,:ARCID,:OrdDetailID,:Sequence,'Y','Y',:UpdateDate,:UpdateTime,:UpdateUserDR))
    ....i SQLCODE'=0 s SQLCODE="-1^插入大项细项组合表失败"
    ....q:SQLCODE'=0
    ....;b ;插入大项细项组合表  SQLCODE
    ....s OrdDetRelateID=%ROWID //大项细项组合表ID
    ....s ret=##class(User.DHCPEOrderDetailRelate).SaveDataToPowerControl(OrdDetRelateID,LocID,UserID,"N")
    ....If ($p(ret,"^",1)="-1") s SQLCODE="-1^大项细项组合插入记录授权表失败"   
    ....q:SQLCODE'=0
    ../***********插入大项细项组合表 end**********/
    
    q SQLCODE
}

/// Creator：     xy 
/// CreatDate：   20210811
/// Description:  站点和项目组合更新/插入数据
/// Table：       站点和项目组合表 DHC_PE_StationOrder
/// Input:        InputStr(站点ID^数据ID^医嘱项ID^激活^表名^科室ID^用户ID^单独授权)
/// Return：
/// debug:d ##class(web.DHCPE.CT.StationOrder).Update()
ClassMethod Update(InputStr As %String)
{
   s ^tempdhcpe("UpdateOrder")=InputStr 
   n (InputStr) 
   s ID=$p(InputStr,"^",2)
   s ARCIMID=$p(InputStr,"^",3)
   s Active=$p(InputStr,"^",4)
   s tableName=$p(InputStr,"^",5)
   s LocID=$p(InputStr,"^",6)
   s UserID=$p(InputStr,"^",7)
   s Empower=$p(InputStr,"^",8)
   s UpdateDate=$p($h,",",1)
   s UpdateTime=$p($h,",",2)
   
   s $ZT="UpdateOrderErr"
   s result=0
   s OldRecord=$g(^DHCPEST($p(ID,"||",1),"O",$p(ID,"||",2)))
 
   &sql(update DHC_PE_StationOrder
        set STORD_ARCIM_DR=:ARCIMID,
        STORD_NoActive=:Active,
        STORD_UpdateDate=:UpdateDate,
        STORD_UpdateTime=:UpdateTime,
        STORD_UpdateUserDR=:UserID
	    where STORD_RowId=:ID
	     )

   if (SQLCODE'=0){
   		s result="-1^更新站点项目组合表失败"
   		goto UpdateOrderErr
   }else{ 
   		s ret=##class(User.DHCPEStationOrder).SaveDataToPowerControl(ID,LocID,UserID,Empower)
   }
   ;b ;ret
    //表记录授权插入/更新数据失败
    If ($p(ret,"^",1)="-1")  
    { 
        s result="-1^插入记录授权表失败"
        goto UpdateOrderErr
        
    }else{
	    s NewRecord=$g(^DHCPEST($p(ID,"||",1),"O",$p(ID,"||",2)))
   	    if (OldRecord'=NewRecord) {
   	    s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_StationOrder",ID,"U",OldRecord,NewRecord,UserID)
		if ($p(Logret,"^",1)="-1"){
			s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        	goto UpdateOrderErr
			}
   	    }
        q result
    }
UpdateOrderErr  
    q result
}

/// Creator：    xy 
/// CreatDate：  20210811
/// Description: 站点和项目组合查询（使用数据，只有授权的科室才显示）
/// Table：      站点和项目组合表 DHC_PE_StationOrder
/// Input: 
/// Return：
/// debug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.StationOrder","FindStationOrder","1","","B","1","2","DHC_PE_StationOrderSort")
Query FindStationOrder(StationID As %String = "", ARCIMDesc As %String = "", Active As %String = "Y", Type As %String = "", LocID As %String = "", hospId As %String = "", tableName As %String = "") As websys.Query(ROWSPEC = "TOrderID:%String,TStationName:%String,TARCIMDR:%String,TARCIMCode:%String,TARCIMDesc:%String,TEmpower:%String,TEffPowerFlag:%String,TNoActive:%String,TUpdateDate:%String,TUpdateTime:%String,TUserName:%String")
{
}

ClassMethod FindStationOrderExecute(ByRef qHandle As %Binary, StationID As %String = "", ARCIMDesc As %String = "", Active As %String = "Y", Type As %String = "", LocID As %String = "", hospId As %String = "", tableName As %String = "") As %Status
{
    s ^tempdhcpe("FindStationOrder")=$lb(StationID,ARCIMDesc,Active,Type,LocID,hospId,tableName)
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s ARCIMDesc=$ZCVT(ARCIMDesc,"U")
    if (StationID=""){
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK 
     }
    s id="0"    
    f  s id=$O(^DHCPEST(StationID,"O",id)) q:id=""  d
    .s StationName=$p($g(^DHCPEST(StationID)),"^",2)
    .// 医嘱
    .s iARCIMDR=$p($g(^DHCPEST(StationID,"O",id)),"^",1)
    .q:iARCIMDR=""
    .q:iARCIMDR'["||"
    .s EffDate=$p($g(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),7)),"^",1)
    .i EffDate="" s EffDate=+$H+1
    .q:EffDate<+$H
    .s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("ARC_ItmMast",iARCIMDR,Type,LocID)
    .q:DateShowFlag="Y"
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",iARCIMDR,hospId)
    .q:(HOSPshowFlag="N")
    .
    .s iARCIMCode=$p($G(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1)),"^",1)
    .s iARCIMDesc=$p($G(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1)),"^",2)
    .
    .s AliasId=0
    .s Alias=""
    .f  s AliasId=$o(^ARC("ALIAS",0,"ARCIM",iARCIMDR,AliasId)) q:(AliasId="")  d
    ..s EffDate=$p(^ARC("ALIAS",AliasId),"^",13)
    ..i EffDate="" s EffDate=+$h+1
    ..q:EffDate<+$h
    ..s Alia=$p(^ARC("ALIAS",AliasId),"^",6)
    ..s Alia=$ZCVT(Alia,"U")
    ..s Alias=Alias_"^"_Alia
    .
    .q:(($ZCVT(iARCIMDesc,"U")'[ARCIMDesc)&&(Alias'[ARCIMDesc))
    .s TActive=$p($g(^DHCPEST(StationID,"O",id)),"^",9)
    .i TActive="" s TActive="Y"
    .q:(Active'="")&&(Active'=TActive)
    .s UpdateDate=$p($g(^DHCPEST(StationID,"O",id)),"^",10)
    .i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    .s UpdateTime=$p($g(^DHCPEST(StationID,"O",id)),"^",11)
    .i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    .s User=""
    .s UserDR=$p($g(^DHCPEST(StationID,"O",id)),"^",12)
    .i UserDR'="" s User=$p($g(^SSU("SSUSR",UserDR)),"^",2)
    .s LocShowDFlag=##class(User.DHCPEStationOrder).GetLocShowDataFlag(StationID_"||"_id,LocID)
    .q:LocShowDFlag'="Y"
    .s EmpowerStr=##class(User.DHCPEStationOrder).GetEmpowerFlag(StationID_"||"_id,LocID)
    .s Empower=$p(EmpowerStr,"^",2)
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    .;s StationName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",StationName,"STDesc","cls")
    .;s iARCIMDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",iARCIMDesc,"ARCIMDesc","cls")
    .;s User=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",User,"SSUSRName","cls")
    .s ^CacheTemp(repid,ind)=$lb(StationID_"||"_id,StationName,iARCIMDR,iARCIMCode,iARCIMDesc,Empower,EffPowerFlag,TActive,UpdateDate,UpdateTime,User)
    .s ind=ind+1
        
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator：    xy 
/// CreatDate：  20211122
/// Description: 站点和项目组合查询(维护数据，显示所有数据）
/// Table：      站点和项目组合表 DHC_PE_StationOrder
/// Input: 
/// Return：
/// debug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.StationOrder","FindStationOrderNew","1","","B","1","2","DHC_PE_StationOrderSort")
Query FindStationOrderNew(StationID As %String = "", ARCIMDesc As %String = "", Active As %String = "Y", Type As %String = "", LocID As %String = "", hospId As %String = "", tableName As %String = "") As websys.Query(ROWSPEC = "TOrderID:%String,TStationName:%String,TARCIMDR:%String,TARCIMCode:%String,TARCIMDesc:%String,TEmpower:%String,TEffPowerFlag:%String,TNoActive:%String,TUpdateDate:%String,TUpdateTime:%String,TUserName:%String")
{
}

ClassMethod FindStationOrderNewExecute(ByRef qHandle As %Binary, StationID As %String = "", ARCIMDesc As %String = "", Active As %String = "Y", Type As %String = "", LocID As %String = "", hospId As %String = "", tableName As %String = "") As %Status
{
    s ^tempdhcpe("FindStationOrderNew")=$lb(StationID,ARCIMDesc,Active,Type,LocID,hospId,tableName)
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s ARCIMDesc=$ZCVT(ARCIMDesc,"U")
    if (StationID=""){
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK 
     }
    s id="0"    
    f  s id=$O(^DHCPEST(StationID,"O",id)) q:id=""  d
    .s StationName=$p($g(^DHCPEST(StationID)),"^",2)
    .// 医嘱
    .s iARCIMDR=$p($g(^DHCPEST(StationID,"O",id)),"^",1)
    .q:iARCIMDR=""
    .q:iARCIMDR'["||"
    .s EffDate=$p($g(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),7)),"^",1)
    .i EffDate="" s EffDate=+$H+1
    .q:EffDate<+$H
    .s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("ARC_ItmMast",iARCIMDR,Type,LocID)
    .q:DateShowFlag="Y"
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",iARCIMDR,hospId)
    .q:(HOSPshowFlag="N")
    .
    .s iARCIMCode=$p($G(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1)),"^",1)
    .s iARCIMDesc=$p($G(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1)),"^",2)
    .
    .s AliasId=0
    .s Alias=""
    .f  s AliasId=$o(^ARC("ALIAS",0,"ARCIM",iARCIMDR,AliasId)) q:(AliasId="")  d
    ..s EffDate=$p(^ARC("ALIAS",AliasId),"^",13)
    ..i EffDate="" s EffDate=+$h+1
    ..q:EffDate<+$h
    ..s Alia=$p(^ARC("ALIAS",AliasId),"^",6)
    ..s Alia=$ZCVT(Alia,"U")
    ..s Alias=Alias_"^"_Alia
    .
    .q:(($ZCVT(iARCIMDesc,"U")'[ARCIMDesc)&&(Alias'[ARCIMDesc))
    .s TActive=$p($g(^DHCPEST(StationID,"O",id)),"^",9)
    .i TActive="" s TActive="Y"
    .q:(Active'="")&&(Active'=TActive)
    .s UpdateDate=$p($g(^DHCPEST(StationID,"O",id)),"^",10)
    .i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    .s UpdateTime=$p($g(^DHCPEST(StationID,"O",id)),"^",11)
    .i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    .s User=""
    .s UserDR=$p($g(^DHCPEST(StationID,"O",id)),"^",12)
    .i UserDR'="" s User=$p($g(^SSU("SSUSR",UserDR)),"^",2)
    .s LocShowDFlag=##class(User.DHCPEStationOrder).GetLocShowDataFlag(StationID_"||"_id,LocID)
    .q:LocShowDFlag="N"
    .s EmpowerStr=##class(User.DHCPEStationOrder).GetEmpowerFlag(StationID_"||"_id,LocID)
    .s Empower=$p(EmpowerStr,"^",2)
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    .;s StationName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",StationName,"STDesc","cls")
    .;s iARCIMDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",iARCIMDesc,"ARCIMDesc","cls")
    .;s User=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",User,"SSUSRName","cls")
    .s ^CacheTemp(repid,ind)=$lb(StationID_"||"_id,StationName,iARCIMDR,iARCIMCode,iARCIMDesc,Empower,EffPowerFlag,TActive,UpdateDate,UpdateTime,User)
    .s ind=ind+1
        
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator：    xy 
/// CreatDate：  20210816
/// Description: 科室维护项目查询
/// Table：      站点和项目组合表 DHC_PE_StationOrder
/// Input: 
/// Return：
/// debug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.StationOrder","FindLocAllOrder","","B","1","2","DHC_PE_StationOrder")
Query FindLocAllOrder(ARCIMDesc As %String = "", Type As %String = "", LocID As %String = "", hospId As %String = "", tableName As %String = "", Active As %String = "Y") As websys.Query(ROWSPEC = "TOrderID:%String,TStationName:%String,TARCIMDR:%String,TARCIMCode:%String,TARCIMDesc:%String,TEmpower:%String,TEffPowerFlag:%String")
{
}

ClassMethod FindLocAllOrderExecute(ByRef qHandle As %Binary, ARCIMDesc As %String = "", Type As %String = "", LocID As %String = "", hospId As %String = "", tableName As %String = "", Active As %String = "Y") As %Status
{
    s ^tempdhcpe("FindLocAllOrder")=$lb(ARCIMDesc,Type,LocID,hospId,tableName,Active)
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s ARCIMDesc=$ZCVT(ARCIMDesc,"U")
   
    s StatID=""
    f  s StatID=$o(^DHCPEST(StatID))  q:StatID=""  d
    .s id="0"   
    .f  s id=$O(^DHCPEST(StatID,"O",id)) q:id=""  d
    ..s StationName=$p($g(^DHCPEST(StatID)),"^",2)
    ..// 医嘱
    ..s iARCIMDR=$p($g(^DHCPEST(StatID,"O",id)),"^",1)
    ..q:iARCIMDR=""
    ..q:iARCIMDR'["||"
    ..s TActive=$p($g(^DHCPEST(StatID,"O",id)),"^",9)
    ..i TActive="" s TActive="Y"
    ..q:(Active'="")&&(Active'=TActive)
    ..s EffDate=$p($g(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),7)),"^",1)
    ..i EffDate="" s EffDate=+$H+1
    ..q:EffDate<+$H
    ..s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("ARC_ItmMast",iARCIMDR,Type,LocID)
    ..q:DateShowFlag="Y"
    ..s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",iARCIMDR,hospId)
    ..q:(HOSPshowFlag="N")
    ..
    ..s iARCIMCode=$p($G(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1)),"^",1)
    ..s iARCIMDesc=$p($G(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1)),"^",2)
    ..
    ..s AliasId=0
    ..s Alias=""
    ..f  s AliasId=$o(^ARC("ALIAS",0,"ARCIM",iARCIMDR,AliasId)) q:(AliasId="")  d
    ...s EffDate=$p(^ARC("ALIAS",AliasId),"^",13)
    ...i EffDate="" s EffDate=+$h+1
    ...q:EffDate<+$h
    ...s Alia=$p(^ARC("ALIAS",AliasId),"^",6)
    ...s Alia=$ZCVT(Alia,"U")
    ...s Alias=Alias_"^"_Alia
    ..
    ..q:(($ZCVT(iARCIMDesc,"U")'[ARCIMDesc)&&(Alias'[ARCIMDesc))
    ..s LocShowDFlag=##class(User.DHCPEStationOrder).GetLocShowDataFlag(StatID_"||"_id,LocID)
    ..q:LocShowDFlag="N"
    ..s EmpowerStr=##class(User.DHCPEStationOrder).GetEmpowerFlag(StatID_"||"_id,LocID)
    ..s Empower=$p(EmpowerStr,"^",2)
    ..s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    ..;d TranslateFindLocAllOrder
    ..s ^CacheTemp(repid,ind)=$lb(StatID_"||"_id,StationName,iARCIMDR,iARCIMCode,iARCIMDesc,Empower,EffPowerFlag)
    ..s ind=ind+1
        
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
TranslateFindLocAllOrder
    s iARCIMDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",iARCIMDesc,"ARCIMDesc","cls")
    s StationName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",StationName,"STDesc","cls")
}

/// Creator：    xy 
/// CreatDate：  20210811
/// Description: 获取科室项目扩展表数据
/// Table：      站点项目扩展表 DHC_PE_StationOrderSet
/// Input:       ID(数据ID), InString(数据信息拼串), tableName(表名)
/// Return：
/// debug:d ##class(web.DHCPE.CT.StationOrder).GetStionOrderSetByID(8)
ClassMethod GetStionOrderSetByID(ID As %String = "")
{
    i (ID="") q ""
    s Info=""
    s Diet=$lg($g(^CF.PE.StationOrderSetD(ID)),4)
    s ReportFormat=$lg($g(^CF.PE.StationOrderSetD(ID)),5)  
    s AutoReturn=$lg($g(^CF.PE.StationOrderSetD(ID)),7)
    s Sort=$lg($g(^CF.PE.StationOrderSetD(ID)),8)
    s SexDR=$lg($g(^CF.PE.StationOrderSetD(ID)),9)
    s MarriedDR=$lg($g(^CF.PE.StationOrderSetD(ID)),10)
    s AgeMax=$lg($g(^CF.PE.StationOrderSetD(ID)),11)
    s AgeMin=$lg($g(^CF.PE.StationOrderSetD(ID)),12)
    s VIPLevelDR=$lg($g(^CF.PE.StationOrderSetD(ID)),13) 
    s BaseInfoBar=$lg($g(^CF.PE.StationOrderSetD(ID)),14)
    s AlowAddFlag=$lg($g(^CF.PE.StationOrderSetD(ID)),15)
    s PisCodeDR=$lg($g(^CF.PE.StationOrderSetD(ID)),16)
    s PreNum=$lg($g(^CF.PE.StationOrderSetD(ID)),17)
    s TempName=$lg($g(^CF.PE.StationOrderSetD(ID)),18)
    s YGFlag=$lg($g(^CF.PE.StationOrderSetD(ID)),19)
    s SignItem=$lg($g(^CF.PE.StationOrderSetD(ID)),20)
    s ShowOrHide=$lg($g(^CF.PE.StationOrderSetD(ID)),21)
    s Extend=$lg($g(^CF.PE.StationOrderSetD(ID)),22)
    s Photo=$lg($g(^CF.PE.StationOrderSetD(ID)),23)
    s IFReprotPrint=$lg($g(^CF.PE.StationOrderSetD(ID)),24) //报告上打印
    i IFReprotPrint="" s IFReprotPrint="Y"                  //未设置默认为打印
    s BarPrintNum=$lg($g(^CF.PE.StationOrderSetD(ID)),25)
    s NoticeInfo=$lg($g(^CF.PE.StationOrderSetD(ID)),26)
    s UsherItemCatDR=$lg($g(^CF.PE.StationOrderSetD(ID)),27)
    s UsherSort=$lg($g(^CF.PE.StationOrderSetD(ID)),28)
    s UsherIsPrint=$lg($g(^CF.PE.StationOrderSetD(ID)),29)  //导诊单上打印
    i UsherIsPrint="" s UsherIsPrint="Y"                    //未设置默认为打印
    s UsherPrtName=$lg($g(^CF.PE.StationOrderSetD(ID)),30)
    s PatFeeType=$lg($g(^CF.PE.StationOrderSetD(ID)),35)
    s NoDiscount=$lg($g(^CF.PE.StationOrderSetD(ID)),36) //不打折
    s DoseQty=$lg($g(^CF.PE.StationOrderSetD(ID)),37) //剂量
    s UOM=$lg($g(^CF.PE.StationOrderSetD(ID)),38) //剂量单位
    s Frequence=$lg($g(^CF.PE.StationOrderSetD(ID)),39) //频次
    s Duration=$lg($g(^CF.PE.StationOrderSetD(ID)),41) //疗程
    s Instruction=$lg($g(^CF.PE.StationOrderSetD(ID)),40) //用法
    s PrintType=$lg($g(^CF.PE.StationOrderSetD(ID)),42) //合并打印
    s Purpose = $lg($g(^CF.PE.StationOrderSetD(ID)),43) //检查目的
    s NetPreFlag = $lg($g(^CF.PE.StationOrderSetD(ID)),44) //网络预约
    s Info=Diet_"^"_ReportFormat_"^"_NoticeInfo_"^"_AutoReturn_"^"_Sort_"^"_SexDR_"^"_MarriedDR_"^"_AgeMax_"^"_AgeMin
    s Info=Info_"^"_VIPLevelDR_"^"_BaseInfoBar_"^"_AlowAddFlag_"^"_PisCodeDR_"^"_PreNum_"^"_TempName_"^"_YGFlag
    s Info=Info_"^"_SignItem_"^"_ShowOrHide_"^"_Extend_"^"_Photo_"^"_IFReprotPrint_"^"_BarPrintNum_"^"_UsherItemCatDR_"^"_UsherSort_"^"_UsherIsPrint_"^"_UsherPrtName_"^"_PatFeeType_"^"_NoDiscount
    s Info=Info_"^"_DoseQty_"^"_UOM_"^"_Frequence_"^"_Duration_"^"_Instruction_"^"_PrintType_"^"_Purpose_"^"_NetPreFlag
    q Info
}

/// Creator：    xy 
/// CreatDate：  20210811
/// Description: 科室项目扩展表更新/插入数据
/// Table：      站点项目扩展表 DHC_PE_StationOrderSet
/// Input:       ID(数据ID), InString(数据信息拼串), tableName(表名)
/// Return：
/// debug:d ##class(web.DHCPE.CT.StationOrder).SaveStationOrderSet("","1||2^1^N^RF_CAT^^N^N^N^^1^N^N^N^^^^^N^^N^^^^N^^^^^^^N^1","DHC_PE_StationOrderSet")
ClassMethod SaveStationOrderSet(ID As %String = "", InString As %String = "", tableName As %String = "")
{
        
    s ^tempdhcpe("SaveStationOrderSet")=$lb(ID,InString,tableName)
    s $ZT="SaveStatOrderSetErr"
    s result=1              
    s OrderID=$p(InString,"^",1)    
    s LocID=$p(InString,"^",2)
    s Diet=$p(InString,"^",3)    
    s ReportFormat=$p(InString,"^",4)
    s Notice=$p(InString,"^",5)
    s AutoReturn=$p(InString,"^",6)
    s SignItem=$p(InString,"^",7)
    s Photo=$p(InString,"^",8)
    s TempName=$p(InString,"^",9)
    s PatItemName=$p(InString,"^",10)   //导诊单类别
    s Extend=$p(InString,"^",11)        //继承结果
    s ShowOrHide=$p(InString,"^",12)    //禁用
    s YGFlag=$p(InString,"^",13)        //乙肝标记
    s PatFeeType=$p(InString,"^",14)    //费用类别
    s Sex=$p(InString,"^",15)
    s ReportItemName=$p(InString,"^",16)
    s Sort=$p(InString,"^",17)
    s BaseInfoBar=$p(InString,"^",18)
    s PatPrintOrder=$p(InString,"^",19)
    s IFPrint=$p(InString,"^",20)       //打印(导)
    s VIPLevel=$p(InString,"^",21)
    s PreNum=$p(InString,"^",22)
    s PISCode=$p(InString,"^",23)
    s AlowAddFlag=$p(InString,"^",24)
    s AgeMax=$p(InString,"^",25)
    s AgeMin=$p(InString,"^",26)
    s MarriedDR=$p(InString,"^",27)
    s PrintName=$p(InString,"^",28)     //打印名称(导)
    s BarPrintNum=$p(InString,"^",29)
    s PrintSort=$p(InString,"^",30)     //顺序(导)
    s IFReprotPrint=$p(InString,"^",31) //打印(报告)
    s UserID=$p(InString,"^",32)
    s NoDiscount=$p(InString,"^",33) //不打折
    s PrintType=$p(InString,"^",34) //合并打印
    s DoseQty=$p(InString,"^",35) //剂量
    s UOM=$p(InString,"^",36) //剂量单位
    s Frequence=$p(InString,"^",37) //频次
    s Duration=$p(InString,"^",38) //疗程
    s Instruction=$p(InString,"^",39) //用法
    s Purpose=$p(InString,"^",40) //检查目的
	s NetPreFlag=$p(InString,"^",41) //网络预约
    s Date=+$h
    s Time=$p($h,",",2)
    
    s SOSLocID="",SOSOrderID=""
    
    if ID="" d
    .s obj=##class(User.DHCPEStationOrderSet).%New()
    e  d
    .;s OldRecord=$ListToString($g(^CF.PE.StationOrderSetD(ID)))
    .s OldRecord=$ListToString($g(^CF.PE.StationOrderSetD(ID)),,1) // 1  缺省的默认为空
    .s obj=##class(User.DHCPEStationOrderSet).%OpenId(ID)
    
    q:(ID="")&&($d(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,OrderID))) "-1^该项目详情已维护"
    
    s obj.SOSLocDR=LocID
    d obj.SOSOrderDRSetObjectId(OrderID)
    d obj.SOSUsherItemCatDRSetObjectId(PatItemName)
    d obj.SOSPatFeeTypeDRSetObjectId(PatFeeType)
    s obj.SOSDiet=Diet
    s obj.SOSReportFormat=ReportFormat
    s obj.SOSAutoReturn=AutoReturn
    s obj.SOSSort=Sort
    s obj.SOSSexDR=Sex
    s obj.SOSMarriedDR=MarriedDR
    s obj.SOSAgeMax=AgeMax
    s obj.SOSAgeMin=AgeMin
    d obj.SOSVIPLevelDRSetObjectId(VIPLevel)
    s obj.SOSBaseInfoBar=BaseInfoBar
    s obj.SOSAlowAddFlag=AlowAddFlag
    s obj.SOSPisCodeDR=PISCode
    s obj.SOSPreNum=PreNum
    s obj.SOSTempName=TempName  
    s obj.SOSYGFlag=YGFlag
    s obj.SOSSignItem=SignItem
    s obj.SOSShowOrHide=ShowOrHide
    s obj.SOSExtend=Extend
    s obj.SOSPhoto=Photo
    s obj.SOSIFReprotPrint=IFReprotPrint   
    s obj.SOSBarPrintNum=BarPrintNum
    s obj.SOSNoticeInfo=Notice
    s obj.SOSUsherSort=PrintSort
    s obj.SOSUsherIsPrint=IFPrint
    s obj.SOSUsherPrtName=PrintName 
    s obj.SOSNoDiscount=NoDiscount
    
    s obj.SOSDoseQty=DoseQty
    d obj.SOSDoseUOMDRSetObjectId(UOM)
    d obj.SOSFreqDRSetObjectId(Frequence)
    d obj.SOSInstrucDRSetObjectId(Instruction)
    d obj.SOSDuratDRSetObjectId(Duration)
    s obj.SOSPrintType=PrintType
    s obj.SOSPurpose = Purpose
	s obj.SOSNetPreFlag = NetPreFlag
    
    s obj.SOSUpdateDate=Date
    s obj.SOSUpdateTime=Time
    s obj.SOSUpdateUserDR=UserID
    
    TSTART
    
    s sc=obj.%Save()
    d obj.%Close()
    ;b ;$System.Status.IsError(sc)
    If ($System.Status.IsError(sc))  
     { 
        s result="-1^保存项目扩展信息失败"
        goto SaveStatOrderSetErr
        
      }else{
       
       s RowID=obj.%Id() 
       if (ID="") {
            b ;tableName,RowID,LocID,UserID
            s ret=##class(User.DHCPEStationOrderSet).SaveDataToPowerControl(RowID,LocID,UserID)
            //表记录授权插入数据失败
            If ($p(ret,"^",1)="-1")  
            { 
                s result="-1^插入记录授权表失败"
                goto SaveStatOrderSetErr
        
             }
       }
       if (""=ID){	
   	    	s OldRecord=""
   	    	s NewRecord=$ListToString($g(^CF.PE.StationOrderSetD(RowID)),,1) // 1  缺省的默认为空
   	    	s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_StationOrderSet",RowID,"I",OldRecord,NewRecord,UserID)
   	    
			if ($p(Logret,"^",1)="-1"){
				s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        		goto SaveStatOrderSetErr
			}
   	    }else{
	   	    
   	    	s NewRecord=$ListToString($g(^CF.PE.StationOrderSetD(RowID)),,1) // 1  缺省的默认为空
   	    	if (OldRecord'=NewRecord) {
   	    		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_StationOrderSet",RowID,"U",OldRecord,NewRecord,UserID)
				if ($p(Logret,"^",1)="-1"){
					s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        			goto SaveStatOrderSetErr
				}
   	    	}
   	    }
                
    }
     
    TCommit
        s result="0^保存成功"
        q result  
SaveStatOrderSetErr
	
	TROLLBACK 
	s result = "-1^"_$ZE
    q result
}

/// Creator：     xy 
/// CreatDate：   20210811
/// Description:  站点项目扩展表
/// Table：       站点项目扩展表 DHC_PE_StationOrderSet
/// Input: 
/// Return：
/// debug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.StationOrder","FindStationOrderSet","1||2","1")
Query FindStationOrderSet(OrderID As %String = "", LocID As %String = "", tableName As %String = "") As websys.Query(ROWSPEC = "TOrderSetID:%String,TStationName,TARCIMDesc,TDiet,TReportFormat,TNotice,TAutoReturn,TSort,TSexDR,TSex,TMarriedDR,TMarryDesc,TAgeMax,TAgeMin,TVIPLevelDR,TVIPLevel,TBaseInfoBar,TAlowAddFlag,TPisCodeDR,TPISCode,TPreNum,TTempName,TYGFlag,TSignItem,TShowOrHide,TExtend,TPhoto,TIFReprotPrint,TBarPrintNum,TNoticeInfo,TUsherItemCatDR,TPatItemName,TUsherSort,TUsherIsPrint,TUsherPrtName,TUpdateDate,TUpdateTime,TUpdateUserDR,TUpdateUser,TPatFeeTypeDR,TPatFeeType,TNoDiscount,TDoseQty,TUOM,TFrequence,TDuration,TInstruction,TPrintType,TPurpose,TNetPreFlag")
{
}

ClassMethod FindStationOrderSetExecute(ByRef qHandle As %Binary, OrderID As %String = "", LocID As %String = "", tableName As %String = "") As %Status
{
    s ^tempdhcpe("FindStationOrderSet")=$lb(OrderID,LocID,tableName)
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
   
    if (OrderID="")&&(LocID=""){ 
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    
    s ID=""
    f  s ID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,OrderID,ID))  q:ID=""  d
    .s StationName=$p($g(^DHCPEST($p(OrderID,"||",1))),"^",2)
    .// 医嘱 
    .s ARCIMDR=$p($g(^DHCPEST($p(OrderID,"||",1),"O",$p(OrderID,"||",2))),"^",1)
    .s ARCIMDesc=$p($G(^ARCIM($p(ARCIMDR,"||",1),$p(ARCIMDR,"||",2),1)),"^",2)
    .s Diet=$lg($g(^CF.PE.StationOrderSetD(ID)),4)
    .i Diet="PRE" S Diet="餐前"
    .e  i Diet="POST" S Diet="餐后"
    .e  S Diet="不限"
    .s ReportFormat=$lg($g(^CF.PE.StationOrderSetD(ID)),5)
    .i ReportFormat'="" s ReportFormat=..GetReportFormat(ReportFormat)
    .s Notice=$lg($g(^CF.PE.StationOrderSetD(ID)),6)
    .s AutoReturn=$lg($g(^CF.PE.StationOrderSetD(ID)),7)
    .s Sort=$lg($g(^CF.PE.StationOrderSetD(ID)),8)
    .s Sex=""
    .s SexDR=$lg($g(^CF.PE.StationOrderSetD(ID)),9)
    .i SexDR'="" s Sex=$P(^CT("SEX",SexDR),"^",2)
    .s MarryDesc=""
    .s MarriedDR=$lg($g(^CF.PE.StationOrderSetD(ID)),10)
    .i MarriedDR'="" s MarryDesc=$p($g(^CT("MAR",MarriedDR)),"^",2)
    .s AgeMax=$lg($g(^CF.PE.StationOrderSetD(ID)),11)
    .s AgeMin=$lg($g(^CF.PE.StationOrderSetD(ID)),12)
    .s VIPLevel=""
    .s VIPLevelDR=$lg($g(^CF.PE.StationOrderSetD(ID)),13)
    .i VIPLevelDR'="" s VIPLevel=$lg($g(^CT.PE.VIPLevelD(VIPLevelDR)),3)
    .s BaseInfoBar=$lg($g(^CF.PE.StationOrderSetD(ID)),14)
    .s AlowAddFlag=$lg($g(^CF.PE.StationOrderSetD(ID)),15)
    .s PisCodeDR=$lg($g(^CF.PE.StationOrderSetD(ID)),16)
    .s PISCode=""
    .i PisCodeDR'="" s PISCode=$p($g(^DHCAPPTS(PisCodeDR)),"^",2)
    .s PreNum=$lg($g(^CF.PE.StationOrderSetD(ID)),17)
    .s TempName=$lg($g(^CF.PE.StationOrderSetD(ID)),18)
    .s YGFlag=$lg($g(^CF.PE.StationOrderSetD(ID)),19)
    .s SignItem=$lg($g(^CF.PE.StationOrderSetD(ID)),20)
    .s ShowOrHide=$lg($g(^CF.PE.StationOrderSetD(ID)),21)
    .s Extend=$lg($g(^CF.PE.StationOrderSetD(ID)),22)
    .s Photo=$lg($g(^CF.PE.StationOrderSetD(ID)),23)
    .s IFReprotPrint=$lg($g(^CF.PE.StationOrderSetD(ID)),24)
    .i IFReprotPrint="" s IFReprotPrint="Y"                     //未设置默认为打印
    .s BarPrintNum=$lg($g(^CF.PE.StationOrderSetD(ID)),25)
    .s NoticeInfo=$lg($g(^CF.PE.StationOrderSetD(ID)),26)
    .s UsherItemCat=""
    .s UsherItemCatDR=$lg($g(^CF.PE.StationOrderSetD(ID)),27)
    .i UsherItemCatDR'="" s UsherItemCat=$lg($g(^CF.PE.UsherItemCatD(UsherItemCatDR)),3)
    .s UsherSort=$lg($g(^CF.PE.StationOrderSetD(ID)),28)
    .s UsherIsPrint=$lg($g(^CF.PE.StationOrderSetD(ID)),29)
    .i UsherIsPrint="" s UsherIsPrint="Y"                   //未设置默认为打印
    .s UsherPrtName=$lg($g(^CF.PE.StationOrderSetD(ID)),30)
    .s UpdateDate=$lg($g(^CF.PE.StationOrderSetD(ID)),32)
    .i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    .s UpdateTime=$lg($g(^CF.PE.StationOrderSetD(ID)),33)
    .i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    .s UpdateUserDR=$lg($g(^CF.PE.StationOrderSetD(ID)),34)
    .s UpdateUser=""
    .i UpdateUserDR'="" s UpdateUser=$p($g(^SSU("SSUSR",UpdateUserDR)),"^",2)
    .s PatFeeType=""
    .s PatFeeTypeDR=$lg($g(^CF.PE.StationOrderSetD(ID)),35)
    .i PatFeeTypeDR'="" s PatFeeType=$P($G(^PAC("SUBT",PatFeeTypeDR)),"^",2)
    .s NoDiscount=$lg($g(^CF.PE.StationOrderSetD(ID)),36)
    .s DoseQty=$lg($g(^CF.PE.StationOrderSetD(ID)),37)
    .s UOM=""
    .s UOMDR=$lg($g(^CF.PE.StationOrderSetD(ID)),38)
    .i UOMDR'="" s UOM=$P($g(^CT("UOM",UOMDR)),"^",2)
    .s Frequence=""
    .s FrequenceDR=$lg($g(^CF.PE.StationOrderSetD(ID)),39)
    .i FrequenceDR'="" s Frequence=$p($g(^PHCFR(FrequenceDR)),"^",3)
    .s Duration=""
    .s DurationDR=$lg($g(^CF.PE.StationOrderSetD(ID)),40)
    .i DurationDR'="" s Duration=$p($g(^PHCDU(DurationDR)),"^",3)
    .s Instruction=""
    .s InstructionDR=$lg($g(^CF.PE.StationOrderSetD(ID)),41)
    .i InstructionDR'="" s Instruction=$p($g(^PHCIN(InstructionDR)),"^",2)
    .s PrintType=$lg($g(^CF.PE.StationOrderSetD(ID)),42)
    .s Purpose=$lg($g(^CF.PE.StationOrderSetD(ID)),43)
	.s NetPreFlag=$lg($g(^CF.PE.StationOrderSetD(ID)),44)
	.s ^CacheTemp(repid,ind)=$lb(ID,StationName,ARCIMDesc,Diet,ReportFormat,Notice,AutoReturn,Sort,SexDR,Sex,MarriedDR,MarryDesc,AgeMax,AgeMin,VIPLevelDR,VIPLevel,BaseInfoBar,AlowAddFlag,PisCodeDR,PISCode,PreNum,TempName,YGFlag,SignItem,ShowOrHide,Extend,Photo,IFReprotPrint,BarPrintNum,NoticeInfo,UsherItemCatDR,UsherItemCat,UsherSort,UsherIsPrint,UsherPrtName,UpdateDate,UpdateTime,UpdateUserDR,UpdateUser,PatFeeTypeDR,PatFeeType,NoDiscount,DoseQty,UOM,Frequence,Duration,Instruction,PrintType,Purpose,NetPreFlag)
	.s ind=ind+1
        
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
Translation
    s StationName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",StationName,"STDesc","cls")
    s ARCIMDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ARCIMDesc,"ARCIMDesc","cls")
    s Diet=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stationordercom.csp",Diet)
    s MarryDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTMarital",MarryDesc,"CTMARDesc","cls")
    s NoticeInfo=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStationOrderSet",NoticeInfo,"SOSNoticeInfo","cls")
    s PISCode=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCAppTestSpec",PISCode,"ATSDesc","cls")
    s PatFeeType=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.PACEpisodeSubType",PatFeeType,"SUBTDesc","cls")
    s UsherItemCat=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEUsherItemCat",UsherItemCat,"PICategory","cls")
    s Purpose=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStationOrderSet",Purpose,"SOSPurpose","cls")
    s Sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",Sex,"CTSEXDesc","cls")
    s TempName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStationOrderSet",TempName,"SOSTempName","cls")
    s UpdateUser=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",UpdateUser,"SSUSRName","cls")
    s UsherPrtName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStationOrderSet",UsherPrtName,"SOSUsherPrtName","cls")
    s VIPLevel=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",VIPLevel,"VLDesc","cls")
}

/// Creator：    xy 
/// CreatDate：  20210811
/// Description: 获取报告格式描述
/// d ##class(web.DHCPE.CT.StationOrder).GetReportFormat()
ClassMethod GetReportFormat(Format)
{
     s Desc=""
     i Format="RF_CAT" s Desc="多层"
     i Format="RF_NOR" s Desc="默认"
     i Format="RF_LIS" s Desc="检验"
     i Format="RF_RIS" s Desc="检查"
     i Format="RF_EKG" s Desc="心电"
     i Format="RF_PIS" s Desc="病理"
     ;s Desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stationordercom.csp",Desc)
     q Desc
}

/// Creator：    xy 
/// CreatDate：  20220616
/// Description: 根据站点项目组合ID获取站点项目组合信息
/// Debug: d ##class(web.DHCPE.CT.StationOrder).GetInfoByOrderID()
ClassMethod GetInfoByOrderID(OrderID)
{
   q:OrderID="" ""
   q $g(^DHCPEST($p(OrderID,"||",1),"O",$p(OrderID,"||",2)))
}

/// Creator：    xy 
/// CreatDate：  20220617
/// Description: 根据医嘱ID获取项目子分类ID
/// Debug: d ##class(web.DHCPE.CT.StationOrder).GetArcItemCat()
ClassMethod GetArcItemCat(ArcItemID)
{
   
    s ItemSubCatDR="",ItemCatDR="",ItemOrderType=""
    s ItemSubCatDR=$p($g(^ARCIM(+ArcItemID,$p(ArcItemID,"||",2),1)),"^",10)
    i ItemSubCatDR'="" d
    .s ItemCatDR=$p($g(^ARC("IC",ItemSubCatDR)),"^",8)
    .s ItemOrderType=$p($g(^ARC("IC",ItemSubCatDR)),"^",7)
    q ItemOrderType
}

/// Creator：    xy
/// CreatDate：  20221115
/// Description: 删除导错站点的医嘱项
/// Input:       ARCIMID      : 医嘱项ID
///              locid        : 科室ID
/// Return：     0/1(删除成功/删除失败)
/// Debug:w ##class(web.DHCPE.CT.StationOrder).DeleteSTOrder("5000||1",105)
ClassMethod DeleteSTOrder(ARCIMID As %String, locid As %String)
{
    S flag=0
    s RLTRowId=""
    s LocGrpID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetLocGrpByLocID(locid)
    i LocGrpID'=""  s LocListID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetLocIDByLocGrp(locid)
    s $ZT="DeleteSTOrderErr"
    
    TSTART
    s length=$l(LocListID,"^")
    f LocNum=1:1:length d
    .s LocID=$p(LocListID,"^",LocNum)
    .s STRowId=""
    .f  s STRowId=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,STRowId)) q:(STRowId="")||(RLTRowId'="")  d
    ..s STOrdSub=""
    ..f  s STOrdSub=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,STRowId,STOrdSub))  q:(STOrdSub="")||(RLTRowId'="")  d
    ...s STOrderID=STRowId_"||"_STOrdSub
    ...s LocShowDFlag=##class(User.DHCPEStationOrder).GetLocShowDataFlag(STOrderID,LocID)
    ...q:LocShowDFlag="N"
    ...s RLTRowId=$o(^DHCPERLT(0,"ARCIM",ARCIMID,0)) 
    ...q:RLTRowId'=""
    ...s ODRRowId=$o(^DHCPEODR(0,"OrderID",STOrderID,0))
    ...i ODRRowId'="" d
    ....s ret=##class(web.DHCPE.CT.DHCPEMappingLoc).DeletePowerControl("User.DHCPEOrderDetailRelate",ODRRowId,LocID)
    ....i (ret'=0) d
    .....s flag="-1^删除大项细项组合表对应的表记录授权表的数据失败"
    .....goto DeleteSTOrderErr
    ....&SQL(delete from sqluser.DHC_PE_OrderDetailRelate where ODR_RowId=:ODRRowId)  //删除大项细项组合表
    ....//大项细项组合表删除数据失败
    ....i (SQLCODE'=0) d
    .....s flag="-1^删除大项细项组合表失败"
    .....goto DeleteSTOrderErr
    ...
    ...s STOrderSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,STOrderID,0))  //站点项目组合扩展表
    ...i STOrderSetID'="" d
    ....s ret=##class(web.DHCPE.CT.DHCPEMappingLoc).DeletePowerControl("User.DHCPEStationOrderSet",STOrderSetID,LocID)
    ....i (ret'=0) d
    .....s flag="-1^删除站点项目组合扩展表对应的表记录授权表的数据失败"
    .....goto DeleteSTOrderErr
    ....&SQL(delete from sqluser.DHC_PE_StationOrderSet where ID=:STOrderSetID)  //删除站点项目组合扩展表
    ....//站点项目组合扩展表删除数据失败
    ....i (SQLCODE'=0) d
    .....s flag="-1^删除站点项目组合扩展表失败"
    .....goto DeleteSTOrderErr
    ...
    ...s STOrderSID=$O(^User.DHCPESTOrderSettingI("IdxOfItmMastDR"," "_ARCIMID," "_LocID,0))
    ...i STOrderSID'="" d
    ....&SQL(delete from sqluser.DHC_PE_STOrderSetting where ID=:STOrderSID)  //删除站点医嘱项设置表
    ....i (SQLCODE'=0) d
    .....s flag="-1^删除站点医嘱项设置表的数据失败"
    .....goto DeleteSTOrderErr
    

    f LocNum=1:1:length d
    .s LocID=$p(LocListID,"^",LocNum)
    .s STRowId=""
    .f  s STRowId=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,STRowId)) q:(STRowId="")||(RLTRowId'="")  d
    ..s STOrdSub=""
    ..f  s STOrdSub=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,STRowId,STOrdSub))  q:(STOrdSub="")||(RLTRowId'="")  d
    ...s STOrderID=STRowId_"||"_STOrdSub
    ...s LocShowDFlag=##class(User.DHCPEStationOrder).GetLocShowDataFlag(STOrderID,LocID)
    ...q:LocShowDFlag="N"
    ...s RLTRowId=$o(^DHCPERLT(0,"ARCIM",ARCIMID,0)) 
    ...q:RLTRowId'=""   
    ...&SQL(delete from sqluser.DHC_PE_StationOrder where STORD_RowId=:STOrderID)  //删除站点项目组合扩展表
    ...s ret=##class(web.DHCPE.CT.DHCPEMappingLoc).DeletePowerControl("User.DHCPEStationOrder",STOrderID,LocID)
    ...i (ret'=0) d
    ....s flag="-1^删除站点项目组合表对应的表记录授权表的数据失败"
    ....goto DeleteSTOrderErr
    ...//站点项目组合表删除数据失败
    ...i (SQLCODE'=0) d
    ....s flag="-1^删除站点项目组合表失败"
    ....goto DeleteSTOrderErr
    
    
    TCommit
    s flag="0^删除成功"
    q flag
    
DeleteSTOrderErr
    TROLLBACK 
    q flag
}

}
