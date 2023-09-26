function InitViewScreenEvent(obj)
{
	var _DHCANOPRiskAssessment=ExtTool.StaticServerObject('web.DHCANOPRiskAssessment');
	var _DHCANOPNurRecord=ExtTool.StaticServerObject('web.DHCANOPNurRecord');
	var _DHCANOPArrangeExtend=ExtTool.StaticServerObject('web.DHCANOPArrangeExtend');
	//var _DHCLCNUREXCUTE=ExtTool.StaticServerObject('web.DHCLCNUREXCUTE');
	var _DHCClinicCom=ExtTool.StaticServerObject('web.DHCClinicCom');
	//var intReg=/^[1-9]\d*$/;
	var UserId=session['LOGON.USERID'];
	obj.LoadEvent=function(args)
	{
		if(opaId!="")
		{
		    var res=_DHCANOPRiskAssessment.GetPatientInfo(opaId)
		    var patInfo=res.split("^");
		    LoadData(patInfo)
		    var res1=_DHCANOPRiskAssessment.GetRiskAssessmentInfo(opaId);
		    var RiskAssessmentInfo=res1.split("^");
		    //20161028+dyl
		    var opBladeTypeStr=RiskAssessmentInfo[0];
		    var opBladeTypeInfo=opBladeTypeStr.split(":");
		   // alert(opBladeTypeInfo[0]+"/"+opBladeTypeInfo[1])
		    obj.opBladeType.setRawValue(opBladeTypeInfo[1]);
		    //20161028+dyl
		    var ASAClassStr=RiskAssessmentInfo[1];
		    var ASAClassInfo=ASAClassStr.split(":");
		    obj.ASAClass.setRawValue(ASAClassInfo[1]);
		     //20161028+dyl
		    var OpTimesStr=RiskAssessmentInfo[2];
		    var OpTimesInfo=OpTimesStr.split(":");
		    obj.OpTimes.setRawValue(OpTimesInfo[1]);
		     //20161028+dyl
		    var comOPTypeStr=RiskAssessmentInfo[3];
		    var comOPTypeInfo=comOPTypeStr.split(":");
		    obj.comOPType.setRawValue(comOPTypeInfo[1]);
		     //20161028+dyl
		    var InfectedStr=RiskAssessmentInfo[4];
		    var InfectedInfo=InfectedStr.split(":");
		    obj.Infected.setRawValue(InfectedInfo[1]);
		    //20161028+dyl
		     var opDocSignStr=RiskAssessmentInfo[5];
		    var opDocSignInfo=opDocSignStr.split(":");
		    obj.opDocSign.setRawValue(opDocSignInfo[1]);
		    //20161028+dyl
		    var anDocSignStr=RiskAssessmentInfo[6];
		    var anDocSignInfo=anDocSignStr.split(":");
		    obj.anDocSign.setRawValue(anDocSignInfo[1]);
		    //20161028+dyl
		    var circleNurseSignStr=RiskAssessmentInfo[7];
		    var circleNurseSignInfo=circleNurseSignStr.split(":");
		    obj.circleNurseSign.setRawValue(circleNurseSignInfo[1]);
		    //20161028+dyl
		    var InfectedscoreStr=RiskAssessmentInfo[8];
		    var InfectedscoreInfo=InfectedscoreStr.split(":");
		    obj.Infectedscore.setRawValue(InfectedscoreInfo[1]);
		    //20161028+dyl
		    var ASAscoreStr=RiskAssessmentInfo[9];
		    var ASAscoreInfo=ASAscoreStr.split(":");
		    obj.ASAscore.setRawValue(ASAscoreInfo[1]);
		    //20161028+dyl
		    var OpTimesScoreStr=RiskAssessmentInfo[10];
		    var OpTimesScoreInfo=OpTimesScoreStr.split(":");
		    obj.OpTimesScore.setRawValue(OpTimesScoreInfo[1]);
		    //20161028+dyl
		    var SumScoreStr=RiskAssessmentInfo[11];
		    var SumScoreInfo=SumScoreStr.split(":");
		    obj.SumScore.setRawValue(SumScoreInfo[1]);
		     //20161028+dyl
		    var NNISRateStr=RiskAssessmentInfo[12];
		    var NNISRateInfo=NNISRateStr.split(":");
		    obj.NNISRate.setRawValue(NNISRateInfo[1]);
	        
	    }
		obj.txtPatname.disable()
		obj.txtPatSex.disable()
		obj.txtPatAge.disable()
		obj.txtPatCtloc.disable()
		obj.txtPatBedNo.disable()
		obj.txtMedCareNo.disable()
		obj.patOpName.disable()
		obj.opDoc.disable()
	}
	function LoadData(patInfo)
	 {
	   obj.txtPatname.setValue(patInfo[0]); //姓名
	   obj.txtPatSex.setValue(patInfo[1]); //性别
	   obj.txtPatAge.setValue(patInfo[2]); //年龄
	   
	   obj.txtPatCtloc.setValue(patInfo[3]); //科室
	   obj.txtPatBedNo.setValue(patInfo[4]); //床号
	   obj.txtMedCareNo.setValue(patInfo[5]); //住院号
	   obj.patOpName.setValue(patInfo[6]);   //拟施手术名称
	 }
	 obj.LoadCombox=function(combox,item)
	{
	 if("undefined" == typeof item) return;
	 var itemList=item.split("!")
	 if(itemList.length>1)
	 {
	 combox.setValue(itemList[0]);
	 combox.setRawValue(itemList[1])
	 }
	}
	
	obj.btnSave_click=function()
	 {
		 if(opaId!="")
		{
		  var paraStr="opBladeType"+"$"+obj.opBladeType.getRawValue()+"^"+"ASAClass"+"$"+obj.ASAClass.getRawValue()+"^"+"OpTimes"+"$"+obj.OpTimes.getRawValue()+"^"+"comOPType"+"$"+obj.comOPType.getRawValue()+"^"+"Infected"+"$"+obj.Infected.getRawValue()
		  +"^"+"opDocSign"+"$"+obj.opDocSign.getRawValue()+"^"+"anDocSign"+"$"+obj.anDocSign.getRawValue()+"^"+"circleNurseSign"+"$"+obj.circleNurseSign.getRawValue()+"^"+"Infectedscore"+"$"+obj.Infectedscore.getRawValue()+"^"+"ASAscore"+"$"+obj.ASAscore.getRawValue()
		  +"^"+"OpTimesScore"+"$"+obj.OpTimesScore.getRawValue()+"^"+"SumScore"+"$"+obj.SumScore.getRawValue()+"^"+"NNISRate"+"$"+obj.NNISRate.getRawValue();
		  var ret1=_DHCANOPRiskAssessment.SaveOrder(opaId,paraStr,UserId);
		  
		  if ((ret1=" ")||(ret1=""))Ext.Msg.alert("提示","更新成功!",function(){ 
		  	window.location.reload()
	  	  	});
		  
		}
	 }
	 
	 obj.btnPrint_click=function()
	 {
	   var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter;
    var path,fileName;
    path = _DHCClinicCom.GetPath();
    fileName=path + "DHCANOPNurRecord.xls";
    //fileName="C:\\Users\LX\Desktop\DHCANOPNurRecord.xls";
    xlsExcel = new ActiveXObject("Excel.Application");
    xlsBook = xlsExcel.Workbooks.Add(fileName);
    xlsSheet = xlsBook.ActiveSheet;
    xlsTop=1;xlsLeft=1;
    var patLoc="",patName="",patSex="",patAge="",patMedCareNo="",patBloodType="",patOpRoom="",patOpDate="",patOpName="",TheatreInTime="",TheatreOutTime="";
  
	//基本信息
	var row=3;
	xlsSheet.cells(row,2)="姓名:"+obj.txtPatname.getValue()+"  性别:"+obj.txtPatSex.getValue()+"  年龄:"+obj.txtPatAge.getValue()+"  病区:"+obj.txtPatCtloc.getValue()+"  床号:"+obj.txtPatBedNo.getValue()+" 住院号:"+obj.txtMedCareNo.getValue();
	/*
	xlsSheet.cells(row,3)="性别:"+obj.txtPatSex.getValue();
	xlsSheet.cells(row,4)="年龄:"+obj.txtPatAge.getValue();
	xlsSheet.cells(row,5)="病区:"+obj.txtPatWard.getValue();
	xlsSheet.cells(row,6)="床号:"+obj.txtPatBedNo.getValue();
	xlsSheet.cells(row,7)="住院号:"+obj.txtMedCareNo.getValue();
	*/
	
	row=5;
	xlsSheet.cells(row,3)=obj.patOpName.getRawValue();
	xlsSheet.cells(row,9)=obj.opDoc.getRawValue();
	
	row=row+1;
	xlsSheet.cells(row,3)=obj.AnMethod.getRawValue();
	xlsSheet.cells(row,9)=obj.AnDoc.getRawValue();
	
	row=row+1;
	//xlsSheet.cells(row,3)=obj.dateOper.getValue();
	xlsSheet.cells(row,4)=obj.dateOper.getRawValue()
	
	row=row+1;
	xlsSheet.cells(row,7)=obj.OpsSTime.getValue();

	row=row+1;
	xlsSheet.cells(row,3)=obj.OpEndTime.getValue();
	
	
	xlsExcel.Visible = true;
	//xlsSheet.PrintPreview;
   // xlsSheet.PrintOut
   /*
    xlsSheet = null;
    xlsBook.Close(savechanges=false)
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;
    */
	 }
	 
	 obj.btnClose_click=function()
	 {
	   window.close()
	 }
	
	obj.opBladeType_select = function()//自动带出得分及总分 YL  20160922
	{
	  //obj.Infectedscore.setValue(obj.opBladeType.getValue());
	  var TypeId=obj.opBladeType.getValue()
	  if((TypeId==1)||(TypeId==2))
	  {
		  obj.Infectedscore.setValue("0")
	  }
	  if((TypeId==3)||(TypeId==4))
	  {
		  var TypeValue=1
		  obj.Infectedscore.setValue("1")
	  }
	  if(obj.ASAscore.getValue()!="")
	  {
	     if(obj.OpTimesScore.getValue()!="")
	     {
	       SumScore=parseInt(obj.Infectedscore.getValue())+parseInt(obj.ASAscore.getValue())+parseInt(obj.OpTimesScore.getValue())
	       obj.SumScore.setValue(SumScore)
	     }
	  }
	}
	 //自动带出得分及总分 YL  20160922
	obj.ASAClass_select = function()
	{
	  //obj.ASAscore.setValue(obj.ASAClass.getValue());
	  var TypeId=obj.ASAClass.getValue();
	  if((TypeId==1)||(TypeId==2))
	  {
		  var TypeValue=0
		  obj.ASAscore.setValue(TypeValue)
	  }
	  if((TypeId==3)||(TypeId==4)||(TypeId==5)||(TypeId==6))
	  {
		  var TypeValue=1
		  obj.ASAscore.setValue(TypeValue)
	  }
	  if(obj.Infectedscore.getValue()!="")
	  {
	     if(obj.OpTimesScore.getValue()!="")
	     {
	       SumScore=parseInt(obj.Infectedscore.getValue())+parseInt(obj.ASAscore.getValue())+parseInt(obj.OpTimesScore.getValue())
	       obj.SumScore.setValue(SumScore)
	     }
	  }
	}
	
	obj.OpTimes_select = function()
	{
	  //obj.OpTimesScore.setValue(obj.OpTimes.getValue());
	  var TypeId=obj.OpTimes.getValue();
	  if(TypeId==1)
	  {
		  var TypeValue=0
		  obj.OpTimesScore.setValue(TypeValue)
	  }
	  if(TypeId==2)
	  {
		  var TypeValue=1
		  obj.OpTimesScore.setValue(TypeValue)
	  }
	  if(obj.Infectedscore.getValue()!="")
	  {
	     if(obj.ASAscore.getValue()!="")
	     {
	       SumScore=parseInt(obj.Infectedscore.getValue())+parseInt(obj.ASAscore.getValue())+parseInt(obj.OpTimesScore.getValue())
	       obj.SumScore.setValue(SumScore)
	     }
	  }
	}
}