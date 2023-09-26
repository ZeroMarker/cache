Import SQLuser

/// 名称: 细项选择维护
/// 编写者：xy
/// 编写日期: 2021-08-14
Class web.DHCPE.CT.ODStandard Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：    xueying
/// CreatDate：  20211117
/// Description: 判断科室组下是否有重复的细项选择
/// Table：      细项选择表  User.DHCPEODStandard
/// Input:       StationID(站点ID),Desc(细项描述),LocID(科室下拉列表值)             
/// Return：     0/1(无/有)
/// Dubug： w ##class(web.DHCPE.CT.ODStandard).IsExsistODSDesc("3||26","老年性骨关节病","152")
ClassMethod IsExsistODSDesc(ODSParRef, Desc As %String, LocID As %String)
{
	
	s flag=0
	s sub=""
	f  s sub=$o(^DHCPEST(+ODSParRef,"OD",$p(ODSParRef,"||",2),"ODS",sub))  q:(sub="")||(flag=1)  d
	.s ODSID=ODSParRef_"||"_sub
	.s aODSDesc=$P($g(^DHCPEST(+ODSParRef,"OD",$p(ODSParRef,"||",2),"ODS",sub)),"^",2)
	.;s LocShowDFlag=##class(User.DHCPEODStandard).GetLocShowDataFlag(ODSID,LocID)
	.s EmpowerStr=##class(User.DHCPEODStandard).GetEmpowerFlag(ODSID,LocID)
    .s Empower=$p(EmpowerStr,"^",2)
    .i Empower="" s Empower="N"
	.;s LocShowDFlag= ##class(web.DHCPE.CT.DHCPEMappingLoc).GetLocShowDataFlag("DHC_PE_ODStandard",ODSID,LocID,ODSParRef,Empower)
	.;q:LocShowDFlag'="Y"
	.s:(aODSDesc=Desc) flag=1
    q flag
}

/// Description: 细项选择保存数据
/// Table：细项选择表 DHC_PE_ODStandard
/// Input: InString(数据信息拼串), tableName(表名),UserID(登陆用户ID),LocID(登陆科室ID)
/// Return：
/// Creator：xy 
/// CreatDate：20210814
/// Debug:d ##class(web.DHCPE.CT.ODStandard).SaveODStandard("2||31^^1^左上肺^^N^^^^N^^^5^Y^Y^^N^^N^Y^Y","DH   C_PE_ODStandard","12187","152")
ClassMethod SaveODStandard(InString As %String = "", tableName As %String = "", UserID As %String = "", LocID As %String = "")
{
    s ^TMP("DHCPE","SaveODStandard")=$lb(InString,tableName,UserID,LocID)
    n (InString,tableName,UserID,LocID)
    
    s $ZT="SaveODStandardErr"
    
    s ODSDesc=""
      
    s result=1
    
    s PLIST(0)=$p(InString,"^",1)
    
    s value=$p(InString,"^",3)    
    s:(""'=value) PLIST(2)=value
    
    s:(0'=$D(PLIST(2))) PLIST(1)=PLIST(0)_"||"_PLIST(2)

    // ODS_TextVal	文本值
    s PLIST(3)=$p(InString,"^",4) 
 	s TextVal=$p(InString,"^",4) 
   
    // ODS_Unit	单位
    s Unit=$p(InString,"^",5)
    
    // ODS_Sex	适用性别
    s Sex=$p(InString,"^",6)
    	
    // ODS_Min	下限
	s Min=$p(InString,"^",7)
	
    // ODS_Max	上限
    s Max=$p(InString,"^",8)
    
    // ODS_NatureValue	是否正常值
    s NatureValue=$p(InString,"^",10)
    
    // ODS_AgeMin	年龄下限
    s AgeMin=$p(InString,"^",11)
    
    // ODS_AgeMax	年龄上限
    s AgeMax=$p(InString,"^",12) 
    
    // ODS_Template	模版
    s Template=$p(InString,"^",13)
     
    //荒诞值   
	s HDValue=$p(InString,"^",19) 
    
    //所见
	s EyeSee=$p(InString,"^",18)
	
	//是否打印
    s NoPrint=$p(InString,"^",15)
    
    // 是否进入小结
    s Summary=$p(InString,"^",14) 
	//s HighRisk=$p(InString,"^",17)
	
	//默认  
	s ODSDefault=$p(InString,"^",20)
	
	//作废
	s NoActive=$p(InString,"^",21) 
	 
	//单独授权
	s Empower=$p(InString,"^",22)
    
	//更新日期
	s UpdateDate=$p($h,",",1)
	
	//更新时间
	s UpdateTime=$p($h,",",2)
	
	//更新人
	s UpdateUserDR=UserID 
	
	//由于细项选择是私有数据，因为不同科室组下面的描述有可能是重复的,因此采用下面的方法进行判断
	if (0'=$D(PLIST(1))) d
	.s ParRef=PLIST(0)
	.s ChildSub=PLIST(2)
	.s ODSDesc=$P($g(^DHCPEST(+ParRef,"OD",$p(ParRef,"||",2),"ODS",ChildSub)),"^",2)
	
	if (ODSDesc'=PLIST(3)) {
    	s ExsistFlag=##class(web.DHCPE.CT.ODStandard).IsExsistODSDesc(PLIST(0),PLIST(3),LocID)
    	q:ExsistFlag=1 "-1^细项选择重复!"
	}
	
	
	TSTART
	i (0=$D(PLIST(1))) {
		k PLIST(1)
		k PLIST(2)
		&sql(
			insert into DHC_PE_ODStandard
			(ODS_ParRef,
			ODS_TextVal,ODS_Unit,
			ODS_Min,ODS_Max,
			ODS_Sex,ODS_NatureValue,
			ODS_AgeMax,ODS_AgeMin,
			ODS_Template,ODS_HDValue,
			ODS_EyeSee,ODS_NoPrint,
			ODS_Summary,ODS_Default,ODS_NoActive,
			ODS_UpdateDate,ODS_UpdateTime,ODS_UpdateUserDR
			)
     		values(
     		:PLIST(0),
    		:TextVal,:Unit,
			:Min,:Max,
			:Sex,:NatureValue,
			:AgeMax,:AgeMin,
			:Template,:HDValue,
			:EyeSee,:NoPrint,
			:Summary,:ODSDefault,:NoActive,
			:UpdateDate,:UpdateTime,:UpdateUserDR
			
			)
		) 
		 ;b ; SQLCODE
 		//细项选择表插入数据失败
     	If (SQLCODE'=0)	 
      	{ 
        	s result="-1^插入细项选择表失败"
        	goto SaveODStandardErr
		
       	}   	 
	
	}else{
		
		s ParRef=PLIST(0)
		s ChildSub=PLIST(2)
		s OldRecord=$g(^DHCPEST(+ParRef,"OD",$P(ParRef,"||",2),"ODS",ChildSub))
		k PLIST(0)
		k PLIST(1)
		k PLIST(2)
       
		&sql(update DHC_PE_ODStandard
			set ODS_TextVal=:TextVal,
			ODS_Unit=:Unit,
			ODS_Min=:Min, 
			ODS_Max=:Max,
			ODS_Sex=:Sex,
			ODS_NatureValue=:NatureValue,
			ODS_AgeMax=:AgeMax,
    		ODS_AgeMin=:AgeMin,
    		ODS_Template=:Template,
    		ODS_HDValue=:HDValue,
    		ODS_EyeSee=:EyeSee,
    		ODS_NoPrint=:NoPrint,  
    		ODS_Summary=:Summary, 
    		ODS_Default=:ODSDefault, 
    		ODS_NoActive=:NoActive,  
    		ODS_UpdateDate=:UpdateDate, 
    		ODS_UpdateTime=:UpdateTime, 
    		ODS_UpdateUserDR=:UpdateUserDR
			where ODS_ParRef=:ParRef and ODS_ChildSub=:ChildSub
		)
	     //细项选择表更新数据失败
	    ;b ;SQLCODE
     	If (SQLCODE'=0)	 
      	{ 
        	s result="-1^更新细项选择表失败"
        	goto SaveODStandardErr
       	}
       
	}
	 ;b ;SQLCODE
	i (SQLCODE=0) {
		s RowID=%ROWID
		  /*
   			//b ;tableName,RowID,LocID,UserID
   			s ret=##class(User.DHCPEODStandard).SaveDataToPowerControl(RowID,LocID,UserID,Empower)
   			//表记录授权插入数据失败
    		If ($p(ret,"^",1)="-1")	 
    		{ 
        		s result="-1^插入记录授权表失败"
        		goto SaveODStandardErr
		
   			 }	
   		*/
   		if (""=$p(InString,"^",3)){	
   	    	s OldRecord=""
   	    	s NewRecord=$g(^DHCPEST($P(RowID,"||",1),"OD",$P(RowID,"||",2),"ODS",$p(RowID,"||",3)))
   	    	s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_ODStandard",RowID,"I",OldRecord,NewRecord,UserID)
   	    
			if ($p(Logret,"^",1)="-1"){
				s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        		goto SaveODStandardErr
			}
   	    }else{
	   	    
   	    	s NewRecord=$g(^DHCPEST($P(RowID,"||",1),"OD",$P(RowID,"||",2),"ODS",$p(RowID,"||",3)))
   	    	if (OldRecord'=NewRecord) {
   	    		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_ODStandard",RowID,"U",OldRecord,NewRecord,UserID)
				if ($p(Logret,"^",1)="-1"){
					s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        			goto SaveODStandardErr
				}
   	    	}
   	    }
   		
   	 }
   	 
   	TCommit
        s result="0^保存成功"
        q result  
SaveODStandardErr	
	TROLLBACK 
	//q $ZE
    q result
}

/// Description: 查询细项选择
/// Table：细项选择表 DHC_PE_ODStandard
/// Input: ParRef（细项表ID),NoActiveFlag(作废), tableName(表名), LocID(科室下拉列表值)
/// Return：
/// Creator：xy 
/// CreatDate：20210814
/// Debug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.ODStandard","FindODStandard","1||22","Y","DHC_PE_ODStandard","152")
Query FindODStandard(ParRef As %String = "", NoActiveFlag As %String = "Y", tableName As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "ODS_ParRef:%String,ODS_RowId:%String,ODS_ChildSub:%String,TSex:%String,TSexDesc:%String,TTextVal:%String,TUnit:%String,TMin:%String,TMax:%String,TNatureValue:%String,TAgeMin:%String,TAgeMax:%String,TSort:%String,THDValue:%String,TEyeSee:%String,TNoPrint:%String,TSummary:%String,TDefault,TNoActive,TUpdateDate,TUpdateTime,TUserName,TEmpower,TEffPowerFlag")
{
}

ClassMethod FindODStandardExecute(ByRef qHandle As %Binary, ParRef As %String = "", NoActiveFlag As %String = "Y", tableName As %String = "", LocID As %String = "") As %Status
{
	s ^TMP("DHCPE","FindODStandard")=$lb(ParRef,NoActiveFlag,tableName,LocID)

    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
   	
   	if (ParRef=""){
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
    }
    
    s id=0
	f  s id=$o(^DHCPEST($P(ParRef,"||",1),"OD",$P(ParRef,"||",2),"ODS",id)) q:(id="")  d
	.s Data=$g(^DHCPEST($P(ParRef,"||",1),"OD",$P(ParRef,"||",2),"ODS",id))
	.S ODSRowId=ParRef_"||"_id
	.s SexDR=$p(Data,"^",1)
	.i SexDR'="" S SexDesc=##class(web.DHCPE.CT.StatOrderDetail).GetODSex(SexDR)
	.S TextVal=$p(Data,"^",2)
	.S Unit=$p(Data,"^",3)
	.s Min=$p(Data,"^",4)
	.s Max=$p(Data,"^",5)
	.s NatureValue=$p(Data,"^",6)
	.s AgeMin=$p(Data,"^",7)
	.i ($p(AgeMin,".",1)="")&&(AgeMin[".") s AgeMin=0_AgeMin
	.s AgeMax=$p(Data,"^",8)
	.i ($p(AgeMax,".",1)="")&&(AgeMax[".") s AgeMax=0_AgeMax
	.s Sort=$p(Data,"^",9)
	.s HDValue=$p(Data,"^",10)
	.s EyeSee=$p(Data,"^",11)
	.s NoPrint=$p(Data,"^",12)	
	.s Summary=$p(Data,"^",13)
	.s Default=$p(Data,"^",14)
	.s NoActive=$p(Data,"^",15)
	.i NoActive="" s NoActive="Y"
	.q:(NoActiveFlag'="")&&(NoActive'=NoActiveFlag)
	.s UpdateDate=$p(Data,"^",16)
	.i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    .s UpdateTime=$p(Data,"^",17)
    .i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    .s UserDR=$p(Data,"^",18)
    .i UserDR'="" s UserName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
    .s LocShowDFlag=##class(User.DHCPEOrderDetail).GetLocShowDataFlag(ParRef,LocID)
	.//s LocShowDFlag=##class(User.DHCPEODStandard).GetLocShowDataFlag(ODSRowId,LocID)
    .q:LocShowDFlag="N"
    .s EmpowerStr=##class(User.DHCPEOrderDetail).GetEmpowerFlag(ODSRowId,LocID)
    .s Empower=$p(EmpowerStr,"^",2)
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    .;d TranslateFindODStandard
	.s ^CacheTemp(repid,ind)=$lb(ParRef,ODSRowId,id,SexDR,SexDesc,TextVal,Unit,Min,Max,NatureValue,AgeMin,AgeMax,Sort,HDValue,EyeSee,NoPrint,Summary,Default,NoActive,UpdateDate,UpdateTime,UserName,Empower,EffPowerFlag)
	.s ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TranslateFindODStandard
	s TextVal=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEODStandard",TextVal,"ODSTextVal","cls")
	s UserName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",UserName,"SSUSRName","cls")
}

}
