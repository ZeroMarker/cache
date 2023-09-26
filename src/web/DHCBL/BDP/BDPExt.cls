Class web.DHCBL.BDP.BDPExt Extends web.DHCBL.BDP.MenuIO [ Not ProcedureBlock ]
{

/// Creator：陈莹
/// CreatDate: 2017-08-16
/// Description：批量处理国家标准编码数据与基础数据对照
/// Other: d ##class(web.DHCBL.BDP.BDPExt).BatchBDPDomain()
ClassMethod BatchBDPDomain() As %Integer
{
	n
	///国家标准编码
	k ^User.BDPStandardCodeI
	k ^User.BDPStandardCodeD

	s ID=0
	for
	{
		s ID=$O(^User.BDPMenuNATDataTypeD(ID)) Q:ID=""
		s MenuCode=$lg($g(^User.BDPMenuNATDataTypeD(ID)),2)  ///dhc.bdp.NewBorn.PACDeliveryMethod
		s NATDataType=$lg($g(^User.BDPMenuNATDataTypeD(ID)),3)  //CV02.10.003
		S MenuID=$O(^User.BDPMenuI("UniqueCodeIndex"," "_$ZCVT(MenuCode,"U"),0))
		S ExecutableId=$LISTGET($G(^User.BDPMenuD(MenuID)),4)
		if ExecutableId=""
		{
			 b ;111 
			 continue
		}
		S TableName=$LISTGET($G(^User.BDPExecutablesD(ExecutableId)),4)  //"PAC_DeliveryMethod"
		
		s BDPDomainCodeA=$$ALPHAUP^SSUTIL4(NATDataType)

		K ^TMPBDPDomain
		s BDPDomainRowId=0
		for
		{
			s BDPDomainRowId=$o(^BDPDATADOMAIN(0,"Code",BDPDomainCodeA,BDPDomainRowId)) q:BDPDomainRowId=""
			s BDPDomainValue=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",3)
			s BDPDomainExpression=$p($g(^BDPDATADOMAIN(BDPDomainRowId)),"^",4)
			s ^TMPBDPDomain(NATDataType,BDPDomainValue)=BDPDomainExpression
		}
		s Xrowid="",Xcode=""
		if (TableName="PAC_DeliveryMethod")  //分娩方法
		{
			s Xrowid="s RowId=$o(^PAC(""DLMTH"",RowId))"
			s Xcode="s Code=$p($g(^PAC(""DLMTH"",RowId)),""^"",1)"
		}
		
		if (TableName="PAC_Allergy")  //过敏源
		{
			s Xrowid="s RowId=$o(^PAC(""ALG"",RowId))"
			s Xcode="s Code=$p($g(^PAC(""ALG"",RowId)),""^"",1)"
		}
		if (TableName="PAC_DischCondit")  //出院条件
		{
			
			s Xrowid="s RowId=$o(^PAC(""DISCON"",RowId))"
			s Xcode="s Code=$p($g(^PAC(""DISCON"",RowId)),""^"",1)"
		}
		if (TableName="ORC_ASA_ClassPhActiv")  //ASA分级
		{
			
			s Xrowid="s RowId=$o(^ORC(""ASA"",RowId))"
			s Xcode="s Code=$p($g(^ORC(""ASA"",RowId)),""^"",1)"
		}
		if (TableName="ORC_BladeType")  //切口类型
		{
			
			s Xrowid="s RowId=$o(^ORC(""BLDTP"",RowId))"
			s Xcode="s Code=$p($g(^ORC(""BLDTP"",RowId)),""^"",1)"
		}
		if (TableName="ORC_OperationCategory")  //手术分类
		{
			
			s Xrowid="s RowId=$o(^ORC(""CATEG"",RowId))"
			s Xcode="s Code=$p($g(^ORC(""CATEG"",RowId)),""^"",1)"
		}
		
		if (TableName="ORC_AnaestMethod")  //麻醉方法
		{
			
			s Xrowid="s RowId=$o(^ORC(""ANMET"",RowId))"
			s Xcode="s Code=$p($g(^ORC(""ANMET"",RowId)),""^"",1)"
		}
		if (TableName="ORC_OperPosition")  //手术位置
		{
			
			s Xrowid="s RowId=$o(^ORC(""OPPOS"",RowId))"
			s Xcode="s Code=$p($g(^ORC(""OPPOS"",RowId)),""^"",1)"
		}
		if (TableName="OEC_BodySite")  //操作部位
		{
			
			s Xrowid="s RowId=$o(^OEC(""BODS"",RowId))"
			s Xcode="s Code=$p($g(^OEC(""BODS"",RowId)),""^"",1)"
		}
		
		if (TableName="CT_CarPrvTp")  //医护人员类型
		{
			
			s Xrowid="s RowId=$o(^CT(""CPT"",RowId))"
			s Xcode="s Code=$p($g(^CT(""CPT"",RowId)),""^"",1)"
		}
		if (TableName="PAC_AdmSource")  //许可来源
		{
			
			s Xrowid="s RowId=$o(^PAC(""ADSOU"",RowId))"
			s Xcode="s Code=$p($g(^PAC(""ADSOU"",RowId)),""^"",1)"
		}
		if (TableName="CT_Country")  //国家
		{
			
			s Xrowid="s RowId=$o(^CT(""COU"",RowId))"
			s Xcode="s Code=$p($g(^CT(""COU"",RowId)),""^"",1)"
		}
		if (TableName="CT_Nation")  //民族
		{
			
			s Xrowid="s RowId=$o(^CT(""NAT"",RowId))"
			s Xcode="s Code=$p($g(^CT(""NAT"",RowId)),""^"",1)"
		}
		if (TableName="CT_Occupation")  //职业
		{
			
			s Xrowid="s RowId=$o(^CT(""OCC"",RowId))"
			s Xcode="s Code=$p($g(^CT(""OCC"",RowId)),""^"",1)"
		}
		if (TableName="CT_Marital")  //婚姻状况
		{
			
			s Xrowid="s RowId=$o(^CT(""MAR"",RowId))"
			s Xcode="s Code=$p($g(^CT(""MAR"",RowId)),""^"",1)"
		}
		if (TableName="CT_Relation")  //家庭关系
		{
			
			s Xrowid="s RowId=$o(^CT(""RLT"",RowId))"
			s Xcode="s Code=$p($g(^CT(""RLT"",RowId)),""^"",1)"
		}
		if (TableName="ORC_Operation")  //手术/过程
		{
			
			s Xrowid="s RowId=$o(^ORC(""OPER"",RowId))"
			s Xcode="s Code=$p($g(^ORC(""OPER"",RowId)),""^"",1)"
		}
		if (TableName="CT_Sex")  //性别
		{
			
			s Xrowid="s RowId=$o(^CT(""SEX"",RowId))"
			s Xcode="s Code=$p($g(^CT(""SEX"",RowId)),""^"",1)"
		}
		if (TableName="CT_Province")  //省
		{
			
			s Xrowid="s RowId=$o(^CT(""PROV"",RowId))"
			s Xcode="s Code=$p($g(^CT(""PROV"",RowId)),""^"",1)"
		}
		if (TableName="CT_City")  //城市
		{
			
			s Xrowid="s RowId=$o(^CT(""CIT"",RowId))"
			s Xcode="s Code=$p($g(^CT(""CIT"",RowId)),""^"",1)"
		}
		if (TableName="CT_CityArea")  //城市区域
		{
			
			s Xrowid="s RowId=$o(^CT(""CITAREA"",RowId))"
			s Xcode="s Code=$p($g(^CT(""CITAREA"",RowId)),""^"",1)"
		}
		
		if (TableName="CT_Education")  //教育水平
		{
			
			s Xrowid="s RowId=$o(^CT(""EDU"",RowId))"
			s Xcode="s Code=$p($g(^CT(""EDU"",RowId)),""^"",1)"
		}
		if (TableName="MRC_ICDDx")  //诊断
		{
			
			s Xrowid="s RowId=$o(^MRC(""ID"",RowId))"
			s Xcode="s Code=$p($g(^MRC(""ID"",RowId)),""^"",4)"
		}
		IF Xrowid="" 
		{
			b ;XROWID=""
			continue	
		}
		s RowId=0
		for
		{
			x Xrowid
			q:RowId=""
			x Xcode
			if $d(^TMPBDPDomain(NATDataType,Code)) 
			{
				IF $d(^User.BDPStandardCodeI("InternalCodeRef",TableName,NATDataType,RowId))=0
				{
					s obj = ##class(User.BDPStandardCode).%New()
					s obj.BDPInternalCode =NATDataType   
					s obj.BDPInternalDesc = $G(^TMPBDPDomain(NATDataType,Code)) 
					s obj.BDPInternalValue=Code
					s obj.DataReference=RowId
					s obj.TableName=TableName
					s sc = obj.%Save()
				}
			}
		}
		
		S TableNameDesc=$LISTGET($G(^User.BDPExecutablesD(ExecutableId)),3)  //"PAC_DeliveryMethod"
		W TableName_","_TableNameDesc,!
		;B ;
		
		
	}
}

}
