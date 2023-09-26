Class CHSSWeb.PersonYearCheckHBVService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2009—07-08
/// Description:体检乙肝情况
/// Table：PersonYearCheckHBV
/// Input: PersonYearCheckHBV
/// Output：
/// Return：
/// Others：
ClassMethod List(YearCheckRowIdParref As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
{
      Set YearCheckRowIdParref=$G(YearCheckRowIdParref)
      Set start=$G(start)
      Set limit=$G(limit)
      Set sort=$G(sort)
      Set count=0
      Set resultString = ""
      Set end = start+limit
      Set json = ##class(Code.JsonObj).%New()
      set HBVRecordRowId = 0
      Set tmp = ""
      
      
      For  Set HBVRecordRowId=$O(^CHSS.PersonYearCheckHBVI("YearCheckRowIdParrefIndex",YearCheckRowIdParref,HBVRecordRowId)) q:HBVRecordRowId=""  d
      .
      
      .s tempPersonYearCheckHBVInfo=##class(CHSS.PersonYearCheckHBV).%OpenId(HBVRecordRowId)
      
      ./// 现症感染情况 
      .
      .set CurSizeOfLiverName = ""
      .set CurSizeOfLiver = ""
      .i tempPersonYearCheckHBVInfo.CurSizeOfLiver '= "" d
      ..s CurSizeOfLiver = tempPersonYearCheckHBVInfo.CurSizeOfLiver.%Id()
      ..s CurSizeOfLiverName = tempPersonYearCheckHBVInfo.CurSizeOfLiver.Description
      
      .set CurRigidityOfLiverName = ""
      .set CurRigidityOfLiver = ""
      .i tempPersonYearCheckHBVInfo.CurRigidityOfLiver '= "" d
      ..s CurRigidityOfLiver = tempPersonYearCheckHBVInfo.CurRigidityOfLiver.%Id()
      ..s CurRigidityOfLiverName = tempPersonYearCheckHBVInfo.CurRigidityOfLiver.Description
      
      .set CurSizeOfSpleenName = ""
      .set CurSizeOfSpleen = ""
      .i tempPersonYearCheckHBVInfo.CurSizeOfSpleen '= "" d
      ..s CurSizeOfSpleen = tempPersonYearCheckHBVInfo.CurSizeOfSpleen.%Id()
      ..s CurSizeOfSpleenName = tempPersonYearCheckHBVInfo.CurSizeOfSpleen.Description
      
      .set CurRigidityOfSpleenName = ""
      .set CurRigidityOfSpleen = ""
      .i tempPersonYearCheckHBVInfo.CurRigidityOfSpleen '= "" d
      ..s CurRigidityOfSpleen = tempPersonYearCheckHBVInfo.CurRigidityOfSpleen.%Id()
      ..s CurRigidityOfSpleenName = tempPersonYearCheckHBVInfo.CurRigidityOfSpleen.Description
      
      .set CurLiverFunctionName = ""
      .set CurLiverFunction = ""
      .i tempPersonYearCheckHBVInfo.CurLiverFunction '= "" d
      ..s CurLiverFunction = tempPersonYearCheckHBVInfo.CurLiverFunction.%Id()
      ..s CurLiverFunctionName = tempPersonYearCheckHBVInfo.CurLiverFunction.Description
      
      ./// 肝功能异常指标
      .
      .s CurALT = tempPersonYearCheckHBVInfo.CurALT
      .s CurAST = tempPersonYearCheckHBVInfo.CurAST
      .s CurALB = tempPersonYearCheckHBVInfo.CurALB
      .s CurGLOB = tempPersonYearCheckHBVInfo.CurGLOB
      .s CurAG = tempPersonYearCheckHBVInfo.CurAG
      .s CurTB = tempPersonYearCheckHBVInfo.CurTB
      .s CurDB = tempPersonYearCheckHBVInfo.CurDB
      
      ./// 乙肝标志物
      .
      .set HbsAgName = ""
      .set HbsAg = ""
      .i tempPersonYearCheckHBVInfo.HbsAg '= "" d
      ..s HbsAg = tempPersonYearCheckHBVInfo.HbsAg.%Id()
      ..s HbsAgName = tempPersonYearCheckHBVInfo.HbsAg.Description
      
      .set HbsAbName = ""
      .set HbsAb = ""
      .i tempPersonYearCheckHBVInfo.HbsAb '= "" d
      ..s HbsAb = tempPersonYearCheckHBVInfo.HbsAb.%Id()
      ..s HbsAbName = tempPersonYearCheckHBVInfo.HbsAb.Description
      
      .set HbeAgName = ""
      .set HbeAg = ""
      .i tempPersonYearCheckHBVInfo.HbeAg '= "" d
      ..s HbeAg = tempPersonYearCheckHBVInfo.HbeAg.%Id()
      ..s HbeAgName = tempPersonYearCheckHBVInfo.HbeAg.Description
      
      .set HBeAbName = ""
      .set HBeAb = ""
      .i tempPersonYearCheckHBVInfo.HBeAb '= "" d
      ..s HBeAb = tempPersonYearCheckHBVInfo.HBeAb.%Id()
      ..s HBeAbName = tempPersonYearCheckHBVInfo.HBeAb.Description
      
      .set HbcAbName = ""
      .set HbcAb = ""
      .i tempPersonYearCheckHBVInfo.HbcAb '= "" d
      ..s HbcAb = tempPersonYearCheckHBVInfo.HbcAb.%Id()
      ..s HbcAbName = tempPersonYearCheckHBVInfo.HbcAb.Description
      
      .s AFP = tempPersonYearCheckHBVInfo.AFP
      
      ./// 肝脾B超 
      .
      .set SizeOfLiverName = ""
      .set SizeOfLiver = ""
      .i tempPersonYearCheckHBVInfo.SizeOfLiver '= "" d
      ..s SizeOfLiver = tempPersonYearCheckHBVInfo.SizeOfLiver.%Id()
      ..s SizeOfLiverName = tempPersonYearCheckHBVInfo.SizeOfLiver.Description
      
      .set ShapeOfLiverName = ""
      .set ShapeOfLiver = ""
      .i tempPersonYearCheckHBVInfo.ShapeOfLiver '= "" d
      ..s ShapeOfLiver = tempPersonYearCheckHBVInfo.ShapeOfLiver.%Id()
      ..s ShapeOfLiverName = tempPersonYearCheckHBVInfo.ShapeOfLiver.Description
      
      .set EnvelopeOfLiverName = ""
      .set EnvelopeOfLiver = ""
      .i tempPersonYearCheckHBVInfo.EnvelopeOfLiver '= "" d
      ..s EnvelopeOfLiver = tempPersonYearCheckHBVInfo.EnvelopeOfLiver.%Id()
      ..s EnvelopeOfLiverName = tempPersonYearCheckHBVInfo.EnvelopeOfLiver.Description	
      
      .set EchoOfLiverName = ""
      .set EchoOfLiver = ""
      .i tempPersonYearCheckHBVInfo.EchoOfLiver '= "" d
      ..s EchoOfLiver = tempPersonYearCheckHBVInfo.EchoOfLiver.%Id()
      ..s EchoOfLiverName = tempPersonYearCheckHBVInfo.EchoOfLiver.Description	
      
      .set NoduleOfLiverName = ""
      .set NoduleOfLiver = ""
      .i tempPersonYearCheckHBVInfo.NoduleOfLiver '= "" d
      ..s NoduleOfLiver = tempPersonYearCheckHBVInfo.NoduleOfLiver.%Id()
      ..s NoduleOfLiverName = tempPersonYearCheckHBVInfo.NoduleOfLiver.Description
      
      .set PortalOfLiverName = ""
      .set PortalOfLiver = ""
      .i tempPersonYearCheckHBVInfo.PortalOfLiver '= "" d
      ..s PortalOfLiver = tempPersonYearCheckHBVInfo.PortalOfLiver.%Id()
      ..s PortalOfLiverName = tempPersonYearCheckHBVInfo.PortalOfLiver.Description
      
      ./// 肝脏门静脉 增宽大小
      .s WidthOfLiverPortal = tempPersonYearCheckHBVInfo.WidthOfLiverPortal
      
      
      .set SizeOfSpleenName = ""
      .set SizeOfSpleen = ""
      .i tempPersonYearCheckHBVInfo.SizeOfSpleen '= "" d
      ..s SizeOfSpleen = tempPersonYearCheckHBVInfo.SizeOfSpleen.%Id()
      ..s SizeOfSpleenName = tempPersonYearCheckHBVInfo.SizeOfSpleen.Description
      
      .set ShapeOfSpleenName = ""
      .set ShapeOfSpleen = ""
      .i tempPersonYearCheckHBVInfo.ShapeOfSpleen '= "" d
      ..s ShapeOfSpleen = tempPersonYearCheckHBVInfo.ShapeOfSpleen.%Id()
      ..s ShapeOfSpleenName = tempPersonYearCheckHBVInfo.ShapeOfSpleen.Description
      
      .set DepthOfSpleenName = ""
      .set DepthOfSpleen = ""
      .i tempPersonYearCheckHBVInfo.DepthOfSpleen '= "" d
      ..s DepthOfSpleen = tempPersonYearCheckHBVInfo.DepthOfSpleen.%Id()
      ..s DepthOfSpleenName = tempPersonYearCheckHBVInfo.DepthOfSpleen.Description
      
      .set NoduleOfSpleenName = ""
      .set NoduleOfSpleen = ""
      .i tempPersonYearCheckHBVInfo.NoduleOfSpleen '= "" d
      ..s NoduleOfSpleen = tempPersonYearCheckHBVInfo.NoduleOfSpleen.%Id()
      ..s NoduleOfSpleenName = tempPersonYearCheckHBVInfo.NoduleOfSpleen.Description
      
      .set SplenicVeinName = ""
      .set SplenicVein = ""
      .i tempPersonYearCheckHBVInfo.SplenicVein '= "" d
      ..s SplenicVein = tempPersonYearCheckHBVInfo.SplenicVein.%Id()
      ..s SplenicVeinName = tempPersonYearCheckHBVInfo.SplenicVein.Description
      
      ./// 脾静脉 增宽大小
      .s WidthOfSplenicVein = tempPersonYearCheckHBVInfo.WidthOfSplenicVein
      
      .s LiverBUS = tempPersonYearCheckHBVInfo.LiverBUS
      
      .///症状和体征情况
      .s CurStatusValue = tempPersonYearCheckHBVInfo.CurStatusValue
      .s PhysicalSignValue = tempPersonYearCheckHBVInfo.PhysicalSignValue
      
      .///胆囊
      .set GallSizeName = ""
      .set GallSize = ""
      .i tempPersonYearCheckHBVInfo.GallSize '= "" d
      ..s GallSize = tempPersonYearCheckHBVInfo.GallSize.%Id()
      ..s GallSizeName = tempPersonYearCheckHBVInfo.GallSize.Description
      
      .set DepthOfGallName = ""
      .set DepthOfGall = ""
      .i tempPersonYearCheckHBVInfo.DepthOfGall '= "" d
      ..s DepthOfGall = tempPersonYearCheckHBVInfo.DepthOfGall.%Id()
      ..s DepthOfGallName = tempPersonYearCheckHBVInfo.DepthOfGall.Description
      
      .s GallStone = tempPersonYearCheckHBVInfo.GallStone
      .s LiverPortalOther = tempPersonYearCheckHBVInfo.LiverPortalOther
      
      
      .Set tmp = HBVRecordRowId_"^"_CurSizeOfLiver_"^"_CurSizeOfLiverName_"^"_CurRigidityOfLiver_"^"_CurRigidityOfLiverName_"^"_CurSizeOfSpleen_"^"_CurSizeOfSpleenName_"^"_CurRigidityOfSpleen_"^"_CurRigidityOfSpleenName_"^"_CurLiverFunction_"^"_CurLiverFunctionName_"^"_CurALT_"^"_CurAST_"^"_CurALB_"^"_CurGLOB_"^"_CurAG_"^"_CurTB_"^"_CurDB_"^"_HbsAg_"^"_HbsAgName_"^"_HbsAb_"^"_HbsAbName_"^"_HbeAg_"^"_HbeAgName_"^"_HBeAb_"^"_HBeAbName_"^"_HbcAb_"^"_HbcAbName_"^"_AFP_"^"_SizeOfLiver_"^"_SizeOfLiverName_"^"_ShapeOfLiver_"^"_ShapeOfLiverName_"^"_EnvelopeOfLiver_"^"_EnvelopeOfLiverName_"^"_EchoOfLiver_"^"_EchoOfLiverName_"^"_NoduleOfLiver_"^"_NoduleOfLiverName_"^"_PortalOfLiver_"^"_PortalOfLiverName_"^"_WidthOfLiverPortal_"^"_SizeOfSpleen_"^"_SizeOfSpleenName_"^"_ShapeOfSpleen_"^"_ShapeOfSpleenName_"^"_DepthOfSpleen_"^"_DepthOfSpleenName_"^"_NoduleOfSpleen_"^"_NoduleOfSpleenName_"^"_SplenicVein_"^"_SplenicVeinName_"^"_WidthOfSplenicVein_"^"_LiverBUS_"^"_CurStatusValue_"^"_PhysicalSignValue_"^"_GallSize_"^"_GallSizeName_"^"_DepthOfGall_"^"_DepthOfGallName_"^"_GallStone_"^"_LiverPortalOther  
        .Set count=count+1
        .If (count>start)&(count<=end) d
      ..d json.InsertRowData(tmp)
      .
      .
        Set resultString = json.getJsonData("HBVRecordRowId^CurSizeOfLiver^CurSizeOfLiverName^CurRigidityOfLiver^CurRigidityOfLiverName^CurSizeOfSpleen^CurSizeOfSpleenName^CurRigidityOfSpleen^CurRigidityOfSpleenName^CurLiverFunction^CurLiverFunctionName^CurALT^CurAST^CurALB^CurGLOB^CurAG^CurTB^CurDB^HbsAg^HbsAgName^HbsAb^HbsAbName^HbeAg^HbeAgName^HBeAb^HBeAbName^HbcAb^HbcAbName^HBVDNA^AFP^SizeOfLiver^SizeOfLiverName^ShapeOfLiver^ShapeOfLiverName^EnvelopeOfLiver^EnvelopeOfLiverName^EchoOfLiver^EchoOfLiverName^NoduleOfLiver^NoduleOfLiverName^PortalOfLiver^PortalOfLiverName^WidthOfLiverPortal^SizeOfSpleen^SizeOfSpleenName^ShapeOfSpleen^ShapeOfSpleenName^DepthOfSpleen^DepthOfSpleenName^NoduleOfSpleen^NoduleOfSpleenName^SplenicVein^SplenicVeinName^WidthOfSplenicVein^LiverBUS",count)
      k json
      
      Quit tmp
}

/// Creator: lyy
/// CreatDate：2009—07-08
/// Description:添加体检乙肝情况
/// Table：PersonYearCheckHBV
/// Input: PersonYearCheckHBV
/// Output：
/// Return：
/// Others：
ClassMethod Insert(YearCheckRowIdParref As %Integer, CurSizeOfLiver As %Integer, CurRigidityOfLiver As %Integer, CurSizeOfSpleen As %Integer, CurRigidityOfSpleen As %Integer, CurLiverFunction As %Integer, CurALT As %String, CurAST As %String, CurALB As %String, CurGLOB As %String, CurAG As %String, CurTB As %String, CurDB As %String, HbsAg As %Integer, HbsAb As %Integer, HbeAg As %Integer, HBeAb As %Integer, HbcAb As %Integer, AFP As %Float, SizeOfLiver As %Integer, ShapeOfLiver As %Integer, EnvelopeOfLiver As %Integer, EchoOfLiver As %Integer, NoduleOfLiver As %Integer, PortalOfLiver As %Integer, WidthOfLiverPortal As %String, SizeOfSpleen As %Integer, ShapeOfSpleen As %Integer, DepthOfSpleen As %Integer, NoduleOfSpleen As %Integer, SplenicVein As %Integer, WidthOfSplenicVein As %String, LiverBUS As %String, CurStatusValue As %String, PhysicalSignValue As %String, GallSize As %Integer, DepthOfGall As %Integer, GallStone As %String, LiverPortalOther As %String) As %String
{
    
      s tempPersonYearCheckHBVInfo=""
      s tempPersonYearCheckHBVInfo=##class(CHSS.PersonYearCheckHBV).%New()
      q:(tempPersonYearCheckHBVInfo="") 0
      
      s YearCheckRowIdParrefobj=##class(CHSS.PersonYearCheckRecord).%OpenId(YearCheckRowIdParref)
      s tempPersonYearCheckHBVInfo.YearCheckRowIdParref=YearCheckRowIdParrefobj
      
      
      /// 现症感染情况 
      
      i CurSizeOfLiver '= "" d
      .s CurSizeOfLiverobj=##class(CHSS.DictLiverSize).%OpenId(CurSizeOfLiver)
      .s tempPersonYearCheckHBVInfo.CurSizeOfLiver=CurSizeOfLiverobj
      
      i CurRigidityOfLiver '= "" d
      .s CurRigidityOfLiverobj=##class(CHSS.DictLiverRigidity).%OpenId(CurRigidityOfLiver)
      .s tempPersonYearCheckHBVInfo.CurRigidityOfLiver=CurRigidityOfLiverobj
      
      i CurSizeOfSpleen '= "" d
      .s CurSizeOfSpleenobj=##class(CHSS.DictLiverSize).%OpenId(CurSizeOfSpleen)
      .s tempPersonYearCheckHBVInfo.CurSizeOfSpleen=CurSizeOfSpleenobj
      
      i CurRigidityOfSpleen '= "" d
      .s CurRigidityOfSpleenobj=##class(CHSS.DictLiverRigidity).%OpenId(CurRigidityOfSpleen)
      .s tempPersonYearCheckHBVInfo.CurRigidityOfSpleen=CurRigidityOfSpleenobj
      
      i CurLiverFunction '= "" d
      .s CurLiverFunctionobj=##class(CHSS.DictLiverRigidity).%OpenId(CurLiverFunction)
      .s tempPersonYearCheckHBVInfo.CurLiverFunction=CurLiverFunctionobj
      
      
      /// 肝功能异常指标
      
      s tempPersonYearCheckHBVInfo.CurALT = CurALT
      s tempPersonYearCheckHBVInfo.CurAST = CurAST
      s tempPersonYearCheckHBVInfo.CurALB = CurALB
      s tempPersonYearCheckHBVInfo.CurGLOB = CurGLOB
      s tempPersonYearCheckHBVInfo.CurAG = CurAG
      s tempPersonYearCheckHBVInfo.CurTB = CurTB
      s tempPersonYearCheckHBVInfo.CurDB = CurDB
      
      /// 乙肝标志物
      
      i HbsAg '= "" d
      .s HbsAgobj=##class(CHSS.DictHBVTag).%OpenId(HbsAg)
      .s tempPersonYearCheckHBVInfo.HbsAg=HbsAgobj
      
      i HbsAb '= "" d
      .s HbsAbobj=##class(CHSS.DictHBVTag).%OpenId(HbsAb)
      .s tempPersonYearCheckHBVInfo.HbsAb=HbsAbobj
      
      i HbeAg '= "" d
      .s HbeAgobj=##class(CHSS.DictHBVTag).%OpenId(HbeAg)
      .s tempPersonYearCheckHBVInfo.HbeAg=HbeAgobj
      
      i HBeAb '= "" d
      .s HBeAbobj=##class(CHSS.DictHBVTag).%OpenId(HBeAb)
      .s tempPersonYearCheckHBVInfo.HBeAb=HBeAbobj
      
       i HbcAb '= "" d
      .s HbcAbobj=##class(CHSS.DictHBVTag).%OpenId(HbcAb)
      .s tempPersonYearCheckHBVInfo.HbcAb=HbcAbobj
      
      
      ;s tempPersonYearCheckHBVInfo.HBVDNA = HBVDNA
      s tempPersonYearCheckHBVInfo.AFP = AFP
      
      /// 肝脾B超 
      
      i SizeOfLiver '= "" d
      .s SizeOfLiverobj=##class(CHSS.DictLiverSize).%OpenId(SizeOfLiver)
      .s tempPersonYearCheckHBVInfo.SizeOfLiver=SizeOfLiverobj
      
      i ShapeOfLiver '= "" d
      .s ShapeOfLiverobj=##class(CHSS.DictLiverShape).%OpenId(ShapeOfLiver)
      .s tempPersonYearCheckHBVInfo.ShapeOfLiver=ShapeOfLiverobj
      
      i EnvelopeOfLiver '= "" d
      .s EnvelopeOfLiverobj=##class(CHSS.DictLiverEnvelope).%OpenId(EnvelopeOfLiver)
      .s tempPersonYearCheckHBVInfo.EnvelopeOfLiver=EnvelopeOfLiverobj
      
      i EchoOfLiver '= "" d
      .s EchoOfLiverobj=##class(CHSS.DictLiverEcho).%OpenId(EchoOfLiver)
      .s tempPersonYearCheckHBVInfo.EchoOfLiver=EchoOfLiverobj
      
      i NoduleOfLiver '= "" d
      .s NoduleOfLiverobj=##class(CHSS.DictLiverNodule).%OpenId(NoduleOfLiver)
      .s tempPersonYearCheckHBVInfo.NoduleOfLiver=NoduleOfLiverobj
      
      i PortalOfLiver '= "" d
      .s PortalOfLiverobj=##class(CHSS.DictLiverPortal).%OpenId(PortalOfLiver)
      .s tempPersonYearCheckHBVInfo.PortalOfLiver=PortalOfLiverobj
      
      
      /// 肝脏门静脉 增宽大小
      s tempPersonYearCheckHBVInfo.WidthOfLiverPortal=WidthOfLiverPortal
      
      
      i SizeOfSpleen '= "" d
      .s SizeOfSpleenobj=##class(CHSS.DictLiverSize).%OpenId(SizeOfSpleen)
      .s tempPersonYearCheckHBVInfo.SizeOfSpleen=SizeOfSpleenobj
      
      i ShapeOfSpleen '= "" d
      .s ShapeOfSpleenobj=##class(CHSS.DictLiverShape).%OpenId(ShapeOfSpleen)
      .s tempPersonYearCheckHBVInfo.ShapeOfSpleen=ShapeOfSpleenobj
      
      i DepthOfSpleen '= "" d
      .s DepthOfSpleenobj=##class(CHSS.DictSpleenDepth).%OpenId(DepthOfSpleen)
      .s tempPersonYearCheckHBVInfo.DepthOfSpleen=DepthOfSpleenobj
      
      i NoduleOfSpleen '= "" d
      .s NoduleOfSpleenobj=##class(CHSS.DictLiverNodule).%OpenId(NoduleOfSpleen)
      .s tempPersonYearCheckHBVInfo.NoduleOfSpleen=NoduleOfSpleenobj
      
      i SplenicVein '= "" d
      .s SplenicVeinobj=##class(CHSS.DictLiverPortal).%OpenId(SplenicVein)
      .s tempPersonYearCheckHBVInfo.SplenicVein=SplenicVeinobj
      
      /// 脾静脉 增宽大小
      s tempPersonYearCheckHBVInfo.WidthOfSplenicVein=WidthOfSplenicVein
      
      s tempPersonYearCheckHBVInfo.LiverBUS=LiverBUS
      
      ///症状和体征情况
      s tempPersonYearCheckHBVInfo.CurStatusValue=CurStatusValue
      s tempPersonYearCheckHBVInfo.PhysicalSignValue=PhysicalSignValue
      
      ///胆囊
      i GallSize '= "" d
      .s GallSizeobj=##class(CHSS.DictLiverSize).%OpenId(GallSize)
      .s tempPersonYearCheckHBVInfo.GallSize=GallSizeobj
               
      i DepthOfGall '= "" d
      .s DepthOfGallobj=##class(CHSS.DictSpleenDepth).%OpenId(DepthOfGall)
      .s tempPersonYearCheckHBVInfo.DepthOfGall=DepthOfGallobj
                
      s tempPersonYearCheckHBVInfo.GallStone=GallStone
      s tempPersonYearCheckHBVInfo.LiverPortalOther=LiverPortalOther
          
      s result=""
      s result=tempPersonYearCheckHBVInfo.%Save()
      Set resultString = ""
      
    
      i result = "1" d
      .s resultString = "success:true,info:"_tempPersonYearCheckHBVInfo.%Id()
      .///w "{""success"":""true"",""info"":"_tempPersonYearCheckHBVInfo.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2009—07-08
/// Description:更新体检乙肝情况
/// Table：PersonYearCheckHBV
/// Input: PersonYearCheckHBV
/// Output：
/// Return：
/// Others：
ClassMethod Update(HBVRecordRowId As %Integer, CurSizeOfLiver As %Integer, CurRigidityOfLiver As %Integer, CurSizeOfSpleen As %Integer, CurRigidityOfSpleen As %Integer, CurLiverFunction As %Integer, CurALT As %String, CurAST As %String, CurALB As %String, CurGLOB As %String, CurAG As %String, CurTB As %String, CurDB As %String, HbsAg As %Integer, HbsAb As %Integer, HbeAg As %Integer, HBeAb As %Integer, HbcAb As %Integer, AFP As %Float, SizeOfLiver As %Integer, ShapeOfLiver As %Integer, EnvelopeOfLiver As %Integer, EchoOfLiver As %Integer, NoduleOfLiver As %Integer, PortalOfLiver As %Integer, WidthOfLiverPortal As %String, SizeOfSpleen As %Integer, ShapeOfSpleen As %Integer, DepthOfSpleen As %Integer, NoduleOfSpleen As %Integer, SplenicVein As %Integer, WidthOfSplenicVein As %String, LiverBUS As %String, CurStatusValue As %String, PhysicalSignValue As %String, GallSize As %Integer, DepthOfGall As %Integer, GallStone As %String, LiverPortalOther As %String) As %String
{
     
      q:($d(HBVRecordRowId)=0)||(HBVRecordRowId="")
      
      s tempPersonYearCheckHBVInfo="",result=""
      s tempPersonYearCheckHBVInfo=##class(CHSS.PersonYearCheckHBV).%OpenId(HBVRecordRowId)
      q:(tempPersonYearCheckHBVInfo="") 0
      	
      /// 现症感染情况 
      
      i CurSizeOfLiver '= "" d
      .s CurSizeOfLiverobj=##class(CHSS.DictLiverSize).%OpenId(CurSizeOfLiver)
      .s tempPersonYearCheckHBVInfo.CurSizeOfLiver=CurSizeOfLiverobj
      
      i CurRigidityOfLiver '= "" d
      .s CurRigidityOfLiverobj=##class(CHSS.DictLiverRigidity).%OpenId(CurRigidityOfLiver)
      .s tempPersonYearCheckHBVInfo.CurRigidityOfLiver=CurRigidityOfLiverobj
      
      i CurSizeOfSpleen '= "" d
      .s CurSizeOfSpleenobj=##class(CHSS.DictLiverSize).%OpenId(CurSizeOfSpleen)
      .s tempPersonYearCheckHBVInfo.CurSizeOfSpleen=CurSizeOfSpleenobj
      
      i CurRigidityOfSpleen '= "" d
      .s CurRigidityOfSpleenobj=##class(CHSS.DictLiverRigidity).%OpenId(CurRigidityOfSpleen)
      .s tempPersonYearCheckHBVInfo.CurRigidityOfSpleen=CurRigidityOfSpleenobj
      
      i CurLiverFunction '= "" d
      .s CurLiverFunctionobj=##class(CHSS.DictLiverRigidity).%OpenId(CurLiverFunction)
      .s tempPersonYearCheckHBVInfo.CurLiverFunction=CurLiverFunctionobj
      
      
      /// 肝功能异常指标
      
      s tempPersonYearCheckHBVInfo.CurALT = CurALT
      s tempPersonYearCheckHBVInfo.CurAST = CurAST
      s tempPersonYearCheckHBVInfo.CurALB = CurALB
      s tempPersonYearCheckHBVInfo.CurGLOB = CurGLOB
      s tempPersonYearCheckHBVInfo.CurAG = CurAG
      s tempPersonYearCheckHBVInfo.CurTB = CurTB
      s tempPersonYearCheckHBVInfo.CurDB = CurDB
      
      /// 乙肝标志物
      
       i HbsAg '= "" d
      .s HbsAgobj=##class(CHSS.DictHBVTag).%OpenId(HbsAg)
      .s tempPersonYearCheckHBVInfo.HbsAg=HbsAgobj
      
      i HbsAb '= "" d
      .s HbsAbobj=##class(CHSS.DictHBVTag).%OpenId(HbsAb)
      .s tempPersonYearCheckHBVInfo.HbsAb=HbsAbobj
      
      i HbeAg '= "" d
      .s HbeAgobj=##class(CHSS.DictHBVTag).%OpenId(HbeAg)
      .s tempPersonYearCheckHBVInfo.HbeAg=HbeAgobj
      
      i HBeAb '= "" d
      .s HBeAbobj=##class(CHSS.DictHBVTag).%OpenId(HBeAb)
      .s tempPersonYearCheckHBVInfo.HBeAb=HBeAbobj
      
       i HbcAb '= "" d
      .s HbcAbobj=##class(CHSS.DictHBVTag).%OpenId(HbcAb)
      .s tempPersonYearCheckHBVInfo.HbcAb=HbcAbobj
      
       s tempPersonYearCheckHBVInfo.AFP = AFP
      
      /// 肝脾B超 
      
      i SizeOfLiver '= "" d
      .s SizeOfLiverobj=##class(CHSS.DictLiverSize).%OpenId(SizeOfLiver)
      .s tempPersonYearCheckHBVInfo.SizeOfLiver=SizeOfLiverobj
      
      i ShapeOfLiver '= "" d
      .s ShapeOfLiverobj=##class(CHSS.DictLiverShape).%OpenId(ShapeOfLiver)
      .s tempPersonYearCheckHBVInfo.ShapeOfLiver=ShapeOfLiverobj
      
      i EnvelopeOfLiver '= "" d
      .s EnvelopeOfLiverobj=##class(CHSS.DictLiverEnvelope).%OpenId(EnvelopeOfLiver)
      .s tempPersonYearCheckHBVInfo.EnvelopeOfLiver=EnvelopeOfLiverobj
      
      i EchoOfLiver '= "" d
      .s EchoOfLiverobj=##class(CHSS.DictLiverEcho).%OpenId(EchoOfLiver)
      .s tempPersonYearCheckHBVInfo.EchoOfLiver=EchoOfLiverobj
      
      i NoduleOfLiver '= "" d
      .s NoduleOfLiverobj=##class(CHSS.DictLiverNodule).%OpenId(NoduleOfLiver)
      .s tempPersonYearCheckHBVInfo.NoduleOfLiver=NoduleOfLiverobj
      
      i PortalOfLiver '= "" d
      .s PortalOfLiverobj=##class(CHSS.DictLiverPortal).%OpenId(PortalOfLiver)
      .s tempPersonYearCheckHBVInfo.PortalOfLiver=PortalOfLiverobj
      
      
      /// 肝脏门静脉 增宽大小
      s tempPersonYearCheckHBVInfo.WidthOfLiverPortal=WidthOfLiverPortal
      
      
      i SizeOfSpleen '= "" d
      .s SizeOfSpleenobj=##class(CHSS.DictLiverSize).%OpenId(SizeOfSpleen)
      .s tempPersonYearCheckHBVInfo.SizeOfSpleen=SizeOfSpleenobj
      
      i ShapeOfSpleen '= "" d
      .s ShapeOfSpleenobj=##class(CHSS.DictLiverShape).%OpenId(ShapeOfSpleen)
      .s tempPersonYearCheckHBVInfo.ShapeOfSpleen=ShapeOfSpleenobj
      
      i DepthOfSpleen '= "" d
      .s DepthOfSpleenobj=##class(CHSS.DictSpleenDepth).%OpenId(DepthOfSpleen)
      .s tempPersonYearCheckHBVInfo.DepthOfSpleen=DepthOfSpleenobj
      
      i NoduleOfSpleen '= "" d
      .s NoduleOfSpleenobj=##class(CHSS.DictLiverNodule).%OpenId(NoduleOfSpleen)
      .s tempPersonYearCheckHBVInfo.NoduleOfSpleen=NoduleOfSpleenobj
      
      i SplenicVein '= "" d
      .s SplenicVeinobj=##class(CHSS.DictLiverPortal).%OpenId(SplenicVein)
      .s tempPersonYearCheckHBVInfo.SplenicVein=SplenicVeinobj
      
      /// 脾静脉 增宽大小
      s tempPersonYearCheckHBVInfo.WidthOfSplenicVein=WidthOfSplenicVein
      
      s tempPersonYearCheckHBVInfo.LiverBUS=LiverBUS
      
      ///症状和体征情况
      s tempPersonYearCheckHBVInfo.CurStatusValue=CurStatusValue
      s tempPersonYearCheckHBVInfo.PhysicalSignValue=PhysicalSignValue
      
      ///胆囊
      i GallSize '= "" d
      .s GallSizeobj=##class(CHSS.DictLiverSize).%OpenId(GallSize)
      .s tempPersonYearCheckHBVInfo.GallSize=GallSizeobj
               
      i DepthOfGall '= "" d
      .s DepthOfGallobj=##class(CHSS.DictSpleenDepth).%OpenId(DepthOfGall)
      .s tempPersonYearCheckHBVInfo.DepthOfGall=DepthOfGallobj
                
      s tempPersonYearCheckHBVInfo.GallStone=GallStone
      s tempPersonYearCheckHBVInfo.LiverPortalOther=LiverPortalOther
      
          
      s result=""
      s result=tempPersonYearCheckHBVInfo.%Save()
      Set resultString = ""
      
      i result = "1" d
      .s resultString = "success:true,info:"_HBVRecordRowId
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      q resultString
}

Storage Default
{
<Data name="PersonYearCheckHBVServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonYearCh997D</DataLocation>
<DefaultData>PersonYearCheckHBVServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonYearCh997D</IdLocation>
<IndexLocation>^CHSSWeb.PersonYearCh997I</IndexLocation>
<StreamLocation>^CHSSWeb.PersonYearCh997S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
