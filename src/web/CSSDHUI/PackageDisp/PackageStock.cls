Import sqluser

/// Creator:ban
/// CreatDate:2022-4-1
/// Description:消毒包库存盘点
/// Table:CSSD_PackageStock
Class web.CSSDHUI.PackageDisp.PackageStock Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:ban
/// CreatDate:2022-4-1
/// Description:查询入库消毒包
/// Table:CSSD_PackageStock
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageDisp.PackageStock","SelectAll",^tmpmy("vfd"))
Query SelectAll(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Label,PkgId,PkgDesc,SterDate,SterNo,ExpDate,InDate,InUserName,DispUserName,ToLocDesc,ChkFlag,ThirdFlag,Location")
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"",MethodName_":参数解析失败")
	q:RtnObj.success'=0 RtnObj.Json()
	s FStartDate=PJObj.%Get("FStartDate")
	s FEndDate=PJObj.%Get("FEndDate")
	s FStartTime=PJObj.%Get("FStartTime")
	s FEndTime=PJObj.%Get("FEndTime")
	s StockFlag=PJObj.%Get("StockFlag")
	s PPkgId=PJObj.%Get("package")
	s FLabel=PJObj.%Get("Label")
	s FExpDate=PJObj.%Get("ExpDate")
	s FStartDate=..DH2L(FStartDate)
	s FEndDate=..DH2L(FEndDate)
	s FStartTime=..TH2L(FStartTime)
	s FEndTime=..TH2L(FEndTime)
	s FExpDate=..DH2L(FExpDate)
	
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT CSSDPS_RowId,CSSDPS_Package_DR,CSSDPS_Label,CSSDPS_InDate,"
			_"CSSDPS_InTime,CSSDPS_InUserDR,CSSDPS_ExpDate,CSSDPS_ChkFlag,CSSDPS_ThirdFlag,"
			_"CSSDPS_Location "
			_"FROM CSSD_PackageStock "
			_"where CSSDPS_InDate between "_FStartDate_" and "_FEndDate
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("CSSDPS_RowId")
		s InDate= Result.Data("CSSDPS_InDate")
		s InTime = Result.Data("CSSDPS_InTime")
		s Label = Result.Data("CSSDPS_Label")
		s ExpDate = Result.Data("CSSDPS_ExpDate")
		s ChkFlag = Result.Data("CSSDPS_ChkFlag")
		s ThirdFlag = Result.Data("CSSDPS_ThirdFlag")
		s PkgId = Result.Data("CSSDPS_Package_DR")
		s InUserDR = Result.Data("CSSDPS_InUserDR")
		s Location = Result.Data("CSSDPS_Location")
		s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,0))
		continue:(ThirdFlag'="Y")&&(TransId="")	//系统生成标签有trans
		continue:(ThirdFlag="Y")&&(ChkFlag="Y")&&(TransId="")	//第三方标签确认时插入trans
		
		s (Status,SterDate,SterNo,DispUserId,ToLocId)=""
		i TransId'="" d	//第三方标签确认前没有TransId
		.s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
		.q:'$IsObject(TransObj)
		.s Status=TransObj.CSSDTStatus
		.s SterDetailObj=TransObj.CSSDTSterilize
		.s DispObj=TransObj.CSSDTDisp
		.i $IsObject(SterDetailObj) d
		..s SterObj=SterDetailObj.CSSDPSParref
		..q:'$IsObject(SterObj)
		..s SterDate=SterObj.CSSDSRDate
		..s SterNo=SterObj.CSSDSRNo
		.i $IsObject(DispObj) d
		..s DispUserId=DispObj.CSSDPDParrefDr.CSSDPDMFromUserDrGetObjectId()
		..s ToLocId=DispObj.CSSDPDParrefDr.CSSDPDMToLocDrGetObjectId()
		.
		continue:((FStartTime'="")&&(FStartTime>InTime))
		continue:((FEndTime'="")&&(FEndTime<=InTime))
		continue:((FLabel'="")&&(FLabel'=Label))
		continue:((PPkgId'="")&&(PPkgId'=PkgId))
		continue:((StockFlag="I")&&(Status'="")&&(Status'="S"))
		continue:((StockFlag="O")&&((Status="S")||(Status="")))
		continue:((FExpDate'="")&&(FExpDate'=ExpDate))
		
		s PackageObj=##class(User.CSSDPackage).%OpenId(PkgId)
		d PackageObj.%Reload()
		s PkgDesc=PackageObj.CSSDPDesc
		s:InTime'="" InTime=..TL2H(InTime)
		s:InDate'="" InDate=..DL2H(InDate)
		s InDate=InDate_" "_InTime
		s:ExpDate'="" ExpDate=..DL2H(ExpDate)
		s:SterDate'="" SterDate=..DL2H(SterDate)
		s InUserName=..sssUserName(InUserDR)
		s ToLocDesc=$s(ToLocId'="":..sssLocDesc(ToLocId),1:"")
		s DispUserName=$s(DispUserId'="":..sssUserName(DispUserId),1:"")
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Label,PkgId,PkgDesc,SterDate,SterNo,ExpDate,InDate,InUserName,
			DispUserName,ToLocDesc,ChkFlag,ThirdFlag,Location)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// CreatDate:2022-4-1
/// Description:新增入库的消毒包
/// Table:CSSD_PackageStock
/// w ##class(web.CSSDHUI.PackageDisp.PackageStock).jsSaveDetail("11","{""Label"":""00032022010800006"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}","11889")
ClassMethod jsSave(Params) As %Library.String
{
	n (Params,%session)
	s $ZT=..sssError()
	ts
	s RtnObj=..Save(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod Save(Params) As web.CSSDHUI.RtnObj
{
	n (Params,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	s Label=PJObj.%Get("Label")
	s gUserId=PJObj.%Get("gUserId")
	s PPkgId=PJObj.%Get("package")
	s PExpDate=PJObj.%Get("ExpDate")
	s PLocation=PJObj.%Get("Location")
	s PExpDate=..DH2L(PExpDate)
	
	s StockId=$o(^User.CSSDPackageStockI("CSSDPSLabelIndex",Label,""))
	q:StockId'="" RtnObj.Err(-3,"","该标签已入库，请核对！")
	
	s PackId= $o(^User.CSSDPackagePackI("CSSDPPLabelIndex",Label,""))
	q:(PackId="")&&((PPkgId="")||(PExpDate="")) RtnObj.Err(-3,"","第三方标签对应消毒包、失效日期不能为空!")
	
	s ThirdFlag="Y"
	i PackId'="" d
	.s ThirdFlag="N"
	.s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
	.d PackObj.%Reload()
	.s PackageObj=PackObj.CSSDPPPackage
	.s IsSter=PackageObj.CSSDPSterType.CSSDSTIsSter
	.s PkgId=PackageObj.%Id()
	.i IsSter="Y" d
	..s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,""))
	..s TransInfo=##Class(User.CSSDTrans).%OpenId(TransId)
	..d TransInfo.%Reload()
	..s SterItmId=TransInfo.CSSDTSterilizeGetObjectId()
	..s ExpDate=TransInfo.CSSDTExpDate
	..s status=TransInfo.CSSDTStatus
	..i SterItmId="" d RtnObj.Err(-5,"","标签没有灭菌,不能入库！") q
	..s IsChkSate=##class(User.CSSDPackageSterilize).%OpenId(SterItmId).CSSDPSStates
	..i IsChkSate="N" d RtnObj.Err(-6,"","标签灭菌不合格,不能入库！") q
	..i +$h>=ExpDate d RtnObj.Err(-7,"","标签已经过期,不能入库！") q
	..i status="RC" d RtnObj.Err(-8,"","标签召回状态,不能入库！") q
	..i status'="S" d RtnObj.Err(-9,"","标签非灭菌状态,不能入库！") q
	e  d
	.s PkgId=PPkgId
	.s PkgObj=##class(User.CSSDPackage).%OpenId(PkgId)
	.s AttributeId=PkgObj.CSSDPPackTypeDetail
	.s IsSter=PkgObj.CSSDPSterType.CSSDSTIsSter
	.i AttributeId'=2 d RtnObj.Err(-5,"","消毒包属性不是普通循环包!") q
	.i IsSter="Y" d RtnObj.Err(-5,"","消毒包的灭菌方式必须是不使用灭菌器") q
	q:RtnObj.success'=0 RtnObj
	
	s NowTime=$P($h,",",2)
	s NowDate=$P($h,",",1)
	s ChkFlag="N"
	s:PExpDate'="" ExpDate=PExpDate
	&sql(INSERT INTO CSSD_PackageStock (CSSDPS_Package_DR,CSSDPS_Label,
		CSSDPS_InDate,CSSDPS_InTime,CSSDPS_InUserDR,CSSDPS_ExpDate,
		CSSDPS_ChkFlag,CSSDPS_ThirdFlag,CSSDPS_Location)
		VALUES (:PkgId,:Label,:NowDate,:NowTime,:gUserId,
		:ExpDate,:ChkFlag,:ThirdFlag,:PLocation))
	q:SQLCODE'=0 RtnObj.Err(-12,"","保存标签盘点信息失败")
	
	q RtnObj
}

/// Creator:ban
/// CreatDate:2022.4.1
/// Description:删除入库的消毒包
/// Table: CSSD_PackageStock
/// Input: rowId ：入库的ID
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.PackageDisp.PackageStock).jsDelete(^templxt("jsDelete"))
ClassMethod jsDelete(Params) As %Library.String
{
	n (Params,%session)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 tro  q RtnObj.Err(-1,"","入参解析失败!").Json()
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s RtnObj=..Delete(RowId)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 删除入库的消毒包
ClassMethod Delete(RowId) As web.CSSDHUI.RtnObj
{
	n (RowId,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s StockObj = ##class(User.CSSDPackageStock).%OpenId(RowId)
	q:'$IsObject(StockObj) RtnObj.Err(-1,"","数据已删除")
	
	s ChkFlag=StockObj.CSSDPSChkFlag
	q:ChkFlag="Y" RtnObj.Err(-1,"","已确认不能删除！")
	
	&sql(delete from CSSD_PackageStock where CSSDPS_RowId=:RowId)
	q:SQLCODE'=0 RtnObj.Err(-2,"","删除已入库消毒包失败!")
	
	q RtnObj
}

/// Creator:lxt
/// CreatDate:20220715
/// Description:确认入库的消毒包
/// Table: CSSD_PackageStock
/// Input: rowId ：入库的ID
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.PackageDisp.PackageStock).jsCheck(^templxt("jsCheck",1),^templxt("jsCheck",2))
ClassMethod jsCheck(Main, Detail) As %Library.String
{
	n (Main,Detail,%session)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Check(Main,Detail)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 确认入库的消毒包
ClassMethod Check(Main, Detail) As web.CSSDHUI.RtnObj
{
	n (Main,Detail,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s MPJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=MPJObj.%FromJSON(Main)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	s gHospId=MPJObj.%Get("gHospId")
	s gGroupId=MPJObj.%Get("gGroupId")
	s gLocId=MPJObj.%Get("gLocId")
	s gUserId=MPJObj.%Get("gUserId")
	s DPJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=DPJObj.%FromJSON(Detail)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	s SerialNo=##class(web.CSSDHUI.Common.AppCommon).CreatePackSerialNo()
	s NowDate=+$h,NowTime=$p($h,",",2)
	while(RtnObj.success=0){
		s Obj=DPJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s StockObj=##class(User.CSSDPackageStock).%OpenId(RowId)
		s Label=StockObj.CSSDPSLabel
		s ThirdFlag=StockObj.CSSDPSThirdFlag
		s ChkFlag=StockObj.CSSDPSChkFlag
		s PkgObj=StockObj.CSSDPSPackage
		s ExpDate=StockObj.CSSDPSExpDate
		s PkgId=PkgObj.%Id()
		i ChkFlag="Y" d RtnObj.Err(-2,"",Label_"已确认！")
		q:RtnObj.success'=0
		
		s StockObj.CSSDPSChkFlag="Y"
		s SC=StockObj.%Save()
		i $$$ISERR(SC) d RtnObj.Err(-3,"",Label_"确认失败！")
		q:RtnObj.success'=0
		
		i ThirdFlag="Y" d
		.s packId= $o(^User.CSSDPackagePackI("CSSDPPLabelIndex",Label,""))
		.i packId'="" d RtnObj.Err(-3,"",Label_"标签已存在系统中，请核实！")
		.q:RtnObj.success'=0
		.s PackMaterialId=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PkgId)
		.i PackMaterialId="" d RtnObj.Err(-1,"","未获取到包装材料")
		.q:RtnObj.success'=0
		.s ToLocId=PkgObj.CSSDPLOCDRGetObjectId()
		.
		.//插入标签信息
		.&sql(Insert into CSSD_PackagePack(CSSDPP_Label,CSSDPP_Package_DR,CSSDPP_Loc_DR,
			CSSDPP_Date,CSSDPP_Time,CSSDPP_Qty,CSSDPP_SerialNo,CSSDPP_IsLoadSteCar
			,CSSDPP_Material_DR,CSSDPP_PackLocDr,CSSDPP_PrtTimes) 
			Values 
			(:Label,:PkgId,:gLocId,:NowDate,:NowTime,1,:SerialNo,0,:PackMaterialId,:ToLocId,0))
		.i SQLCODE'=0 d RtnObj.Err(-10,"","插入标签包装数据失败")
		.q:RtnObj.success'=0
		.s PackId=%ROWID
		.//插入追踪信息
		.&sql(Insert into CSSD_Trans(CSSDT_Label,CSSDT_Pack_DR,CSSDT_Package_DR,
			CSSDT_Date,CSSDT_Time,CSSDT_ExpDate,cssdt_Status) 
			Values
			(:Label,:PackId,:PkgId,:NowDate,:NowTime,:ExpDate,'S'))
		.i SQLCODE'=0 d RtnObj.Err(-11,"","插入标签追踪数据失败")
		.q:RtnObj.success'=0
		.s TransId=%ROWID
		q:RtnObj.success'=0
		
	}
	q RtnObj
}

}
