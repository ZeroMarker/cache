/// 奖金数据筛选
/// sjf
/// 2011-6-9
Class dhc.bonus.usubs.uBonusDataFilter Extends %RegisteredObject [ Not ProcedureBlock ]
{

//数据来源为 5：收入指标   6：工作量  7：支出指标

// w ##Class(dhc.bonus.usubs.BonusDataFilter).GetBonusIndexes()

ClassMethod GetBonusIndexes(start, limit) As %Library.String
{
	n (start,limit)
	set sql="select BonusTargetID,BonusTargetCode,BonusTargetName,TargetTypeID,TargetTypeID->TargetTypeName from dhc_bonus_data.BonusTarget  where datasource in (5,6,7) "
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	s end = start+limit
	s count=0
	s jsonTitle="BonusTargetID^BonusTargetCode^BonusTargetName^TargetTypeID^TargetTypeName"
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	while(rs.Next())
	{
		s count=count+1
		
		s BonusTargetID=rs.Data("BonusTargetID")
		s BonusTargetCode=rs.Data("BonusTargetCode")
		s BonusTargetName=rs.Data("BonusTargetName")
		s TargetTypeID=rs.Data("TargetTypeID")
		s TargetTypeName=rs.Data("TargetTypeName")
		s tmp=BonusTargetID_"^"_BonusTargetCode_"^"_BonusTargetName_"^"_TargetTypeID_"^"_TargetTypeName
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	 d rs.Close()
     s resultString = json.getJsonData(jsonTitle,count)
     k json
     q resultString
}

// w ##Class(dhc.bonus.usubs.uBonusDataFilter).GetJsonStr()

ClassMethod GetJsonStr() As %String
{
	k ^dhcbsAssistCompItems("sjf","AssistCompItems")
	d ..GenSubTree(1,0,0,0)
	;d ..GenLeafflag("")
	q ..GetTreeJson(0)
}

//  d ##class(dhc.bonus.usubs.uBonusDataFilter).GenSubTree(1,0,0,0)

ClassMethod GenSubTree(type, subRootDr, subLevel, tmpNum) As %Library.String
{
    n (type,subRootDr,subLevel,tmpNum)
	s parentSortNum=tmpNum
	s tmpSub=""
	s subLevel=subLevel+1
	s tmpNum=tmpNum+1
	
	f  s tmpSub=$o(^dhcbsSubItemI("ValidTypeUpID",1,subRootDr,tmpSub)) q:tmpSub=""  d
       .s updr=subRootDr
       .;tmpNum 是序号,tmpsub 是这行数据在表中的id，sublevel 为层次，updr 为父节点那行数据在表中的id，parentSortNum 父节点的序号
       .s name=$li(^dhcbsSubItemD(tmpSub),3)
       .s leafflag=$li(^dhcbsSubItemD(tmpSub),6)
       .s ^dhcbsAssistCompItems("sjf","AssistCompItems",tmpNum)=tmpSub_"^"_subLevel_"^"_updr_"^"_parentSortNum_"^"_name_"^"_leafflag
       .s tmpNum= ..GenSubTree(type,tmpSub,subLevel,tmpNum)
        q tmpNum
}

//d ##Class(dhc.bonus.usubs.uBonusDataFilter).GenLeafflag("")

//添加节点是否是叶子节点

//current 为当前节点的序号，previous 是前一个节点的序号

ClassMethod GenLeafflag(current)
{
	n (current)
	set previous=$o(^dhcbsAssistCompItems("sjf","AssistCompItems",current),-1)
	
	q:previous=""
	s previousData=^dhcbsAssistCompItems("sjf","AssistCompItems",previous)
	i current="" d
	.s ^dhcbsAssistCompItems("sjf","AssistCompItems",previous)=previousData_"^"_"leaf"
	e  d
	.s currentData=^dhcbsAssistCompItems("sjf","AssistCompItems",current)

	.s levelCurrent=$p(currentData,"^",2)
	.s levelPrevious=$p(previousData,"^",2)
	
	.i levelPrevious<levelCurrent  d
	..s ^dhcbsAssistCompItems("sjf","AssistCompItems",previous)=previousData_"^"_"notleaf"
	.e  d
	..s ^dhcbsAssistCompItems("sjf","AssistCompItems",previous)=previousData_"^"_"leaf"

	d ..GenLeafflag(previous)
}

//sortNum 序号

//w ##Class(dhc.bonus.usubs.BonusDataFilter).GetTreeJson(0)

ClassMethod GetTreeJson(sortNum) As %String
{

         n (sortNum)
         //如果当前节点是父节点 
        
        s ^dhcbsAssistCompItemsCursor=sortNum
         if sortNum=0
         {
	        s str="["
	        //s currentsortNum=0
	        
	        s ^dhcbsAssistCompItemsCursor=0
	      
         }
         else
         {
	         s data=^dhcbsAssistCompItems("sjf","AssistCompItems",sortNum)
	         
	         s id=$p(data,"^",1)
	         s leafstr= $p(data,"^",6)
	         s name= $p(data,"^",5)
	         
	         
	         if leafstr="0"
	         {
		       
	          s str="{id:"_id_",text:'"_name_"',checked:false,children:["
	         }
	         else
	         {
		       
		         //s currentsortNum=sortNum
		         
		         q "{id:"_id_",text:'" _name_ "',checked:false,leaf:true}"  
	         }
	         
         }
         
         s flag="true"
         
         s childsortNum=^dhcbsAssistCompItemsCursor+1
         
         
         
         
         s str1=""
          do 
          {
	        //为空
	        
	        s info=$g(^dhcbsAssistCompItems("sjf","AssistCompItems",childsortNum))
	        
	        if info'=""
	        {
		     
	          s parentSortNo=$p(^dhcbsAssistCompItems("sjf","AssistCompItems",childsortNum),"^",4)
	          if parentSortNo=sortNum
	          {
		       
	           s rtnstr=..GetTreeJson(childsortNum)
	           if str1="" 
	           {
		        
	            s str1=rtnstr
	           }
	           else 
	           {
		     
		        s str1=str1_","_rtnstr
	           }
	            //s childsortNum=childsortNum+1 
	          }
	          else
	          {
		      
		        s flag="false"
	          }
	        }
	        else
	        {
		      
		         s flag="false"
	        }
	        
	        //s childsortNum=childsortNum+1 
	         s childsortNum=^dhcbsAssistCompItemsCursor+1
          }while(flag="true")
          s str=str_str1
          
          
         if sortNum=0
         {
	        s str=str_"]"
         }
         else
         {
	        s str=str_"]}"
         }
        
         q str
         
     //如果不是父节点，是叶子节点
}

// w ##Class(dhc.bonus.usubs.uBonusDataFilter).GetInfoByID(1)

ClassMethod GetInfoByID(ID As %Library.Integer)
{
	n (ID)
	
	s AssistCompItemIds=""
	s tempid=""
	f  s tempid=$o(^dhcbsSubTargetFilterI("BonusTargetIDIndex",ID,tempid)) q:tempid=""  d
	.s AssistCompItemId=$li(^dhcbsSubTargetFilterD(tempid),2)
	.b ;1
	.i AssistCompItemIds'="" d
	..s AssistCompItemIds=AssistCompItemIds_","_AssistCompItemId
	.e  d
	..s AssistCompItemIds=AssistCompItemId
	
	
	
    s BonusUnitFlagCodes=""
	s tempid=""
	f  s tempid=$o(^dhcbsSubUnitFliterI("BonusTargetIDIndex",ID,tempid)) q:tempid=""  d
	.s BonusUnitFlagCode=$li(^dhcbsSubUnitFliterD(tempid),3)
	.i BonusUnitFlagCodes'="" d
	..s BonusUnitFlagCodes=BonusUnitFlagCodes_","_BonusUnitFlagCode
	.e  d
	..s BonusUnitFlagCodes=BonusUnitFlagCode
	
	
	
	s ExpensesFlagCodes=""
	s tempid=""
	f  s tempid=$o(^dhcbsSubExpensesFliterI("BonusTargetIDIndex",ID,tempid)) q:tempid=""  d
	.s ExpensesFlagCode=$li(^dhcbsSubExpensesFliterD(tempid),3)
	.i ExpensesFlagCodes'="" d
	..s ExpensesFlagCodes=ExpensesFlagCodes_","_ExpensesFlagCode
	.e  d
	..s ExpensesFlagCodes=ExpensesFlagCode
	
	
	s SickFlagCodes=""
	s tempid=""
	f  s tempid=$o(^dhcbsSickFliterI("BonusTargetIDIndex",ID,tempid)) q:tempid=""  d
	.s SickFlagCode=$li(^dhcbsSickFliterD(tempid),3)
	.i SickFlagCodes'="" d
	..s SickFlagCodes=SickFlagCodes_","_SickFlagCode
	.e  d
	..s SickFlagCodes=SickFlagCode
	
	
	q "|"_AssistCompItemIds_"|"_BonusUnitFlagCodes_"|"_ExpensesFlagCodes_"|"_SickFlagCodes
}

//d ##Class(dhc.bonus.usubs.BonusDataFilter).SaveInfo(1,"1,2,3","1,开单科室|2,执行科室","1,门诊|2,住院","1,自费|2,医保")

ClassMethod SaveInfo(ID As %Library.Integer, AssistCompItems As %Library.String, DeptType As %Library.String, ChargeType As %Library.String, PatientType As %Library.String)
{
	n (ID,AssistCompItems,DeptType,ChargeType,PatientType)
	set ^sjfTemp=ID_"^"_AssistCompItems_"^"_DeptType_"^"_ChargeType_"^"_PatientType
	set len=$l(AssistCompItems,",")

	&sql(delete from dhc_bonus_subs.BonusSubTargetFilter where BonusTargetID=:ID)
	f i=1:1:len d
	.s AssistCompItemId=$p(AssistCompItems,",",i)
	.&sql(insert into dhc_bonus_subs.BonusSubTargetFilter (BonusTargetID,BonusSubItemID) values(:ID,:AssistCompItemId)) 
	
	
	&sql(delete from dhc_bonus_subs.BonusSubUnitFliter where BonusTargetID=:ID)
	set len=$l(DeptType,"|")
	f i=1:1:len d
	.s DeptTypeInfo=$p(DeptType,"|",i)
	.s DeptTypeCode=$p(DeptTypeInfo,",",1)
	.i DeptTypeCode=1 d
	..s DeptTypeName="开单科室"
	.i DeptTypeCode=2 d
	..s DeptTypeName="执行科室"
	.i DeptTypeCode=3 d
	..s DeptTypeName="病人科室"
	.i DeptTypeCode=4 d
	..s DeptTypeName="开单医生"
	.i DeptTypeCode=5 d
	..s DeptTypeName="执行医生"
	.i DeptTypeCode=6 d
	..s DeptTypeName="负责医生"

	.;s DeptTypeName=$p(DeptTypeInfo,",",2)
	
	.&sql(insert into dhc_bonus_subs.BonusSubUnitFliter (BonusTargetID,BonusUnitFlagCode,BonusUnitFlagName) values(:ID,:DeptTypeCode,:DeptTypeName)) 
	
	
	&sql(delete from dhc_bonus_subs.BonusSubExpensesFliter where BonusTargetID=:ID)
	set len=$l(ChargeType,"|")
	f i=1:1:len d
	.s ChargeTypeInfo=$p(ChargeType,"|",i)
	.s ChargeTypeCode=$p(ChargeTypeInfo,",",1)
	.i ChargeTypeCode=1 d
	..s ChargeTypeName="门诊"
	.i ChargeTypeCode=2 d
	..s ChargeTypeName="住院"
	.i ChargeTypeCode=3 d
	..s ChargeTypeName="急诊"
	
	.;s ChargeTypeName=$p(ChargeTypeInfo,",",2)
	
	.&sql(insert into dhc_bonus_subs.BonusSubExpensesFliter (BonusTargetID,ExpensesFlagCode,ExpensesFlagName) values(:ID,:ChargeTypeCode,:ChargeTypeName)) 
	
	
	&sql(delete from dhc_bonus_subs.BonusSubSickFliter where BonusTargetID=:ID)
	set len=$l(PatientType,"|")
	f i=1:1:len d
	.s PatientTypeInfo=$p(PatientType,"|",i)
	.s PatientTypeCode=$p(PatientTypeInfo,",",1)
	.i PatientTypeCode=1 d
	..s PatientTypeName="自费"
	.i PatientTypeCode=2 d
	..s PatientTypeName="医保"
	.i PatientTypeCode=3 d
	..s PatientTypeName="新农合"
	
	.;s PatientTypeName=$p(PatientTypeInfo,",",2)
	
	.&sql(insert into dhc_bonus_subs.BonusSubSickFliter (BonusTargetID,SickFlagCode,SickFlagName) values(:ID,:PatientTypeCode,:PatientTypeName))
}

}
