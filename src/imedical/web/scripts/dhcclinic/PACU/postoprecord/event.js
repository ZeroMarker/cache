
function InitViewScreenEvent(obj)
{ 
  var _DHCPacuRecord=ExtTool.StaticServerObject('web.DHCPacuRecord');
  var _DHCLCNUREXCUTE=ExtTool.StaticServerObject('web.DHCLCNUREXCUTE');
  obj.LoadEvent = function(args)
	{
	  var opaId=getUrlParam('opaId');
	  var retStr=_DHCPacuRecord.GetBaseInfo(opaId)
	  var patName=retStr.split("^")[0]
	  var sex=retStr.split("^")[1]
	  var age=retStr.split("^")[2]
	  var locDes=retStr.split("^")[3]
	  var medCareNo=retStr.split("^")[4]
	  var anMethod=retStr.split("^")[5]
	  var pacuBed=retStr.split("^")[6]
	  var anDocId=retStr.split("^")[7].split("!")[0]
	  var anDoc=retStr.split("^")[7].split("!")[1]
	  var anNurseId=retStr.split("^")[8].split("!")[0]
	  var anNurse=retStr.split("^")[8].split("!")[1]
	  obj.txtName.setValue(patName)
	  obj.comSex.setValue(sex)
	  obj.txtAge.setValue(age)
	  obj.txtCtLoc.setValue(locDes)
	  obj.txtAnMethod.setValue(anMethod)
	  obj.txtHosNum.setValue(medCareNo)
	  obj.txtBedCode.setValue(pacuBed)
	  obj.comAnDoctor.setValue(anDocId)
	  obj.comAnDoctor.setRawValue(anDoc)
	  obj.comAnNurse.setValue(anNurseId)
	  obj.comAnNurse.setRawValue(anNurse)
	  var pacuVitalSigns=retStr.split("^")[9]
	  var opaBP=pacuVitalSigns.split("!")[0]
	  obj.txtBP.setValue(opaBP);
	  var opaHR=pacuVitalSigns.split("!")[1]
	  obj.txtHR.setValue(opaHR);
	  var opaSpO2=pacuVitalSigns.split("!")[2]
	  obj.txtSPO2.setValue(opaSpO2);
	  var opaRR=pacuVitalSigns.split("!")[3]
	  obj.txtRR.setValue(opaRR);
	  var opaSense=pacuVitalSigns.split("!")[4]
	  obj.comSense.setRawValue(opaSense)
	  var opaNausea=pacuVitalSigns.split("!")[5]
	  obj.comNausea.setRawValue(opaNausea);
	  var opaVomit=pacuVitalSigns.split("!")[6]
	  obj.comVomit.setRawValue(opaVomit);
	  var opaHoarse=pacuVitalSigns.split("!")[7]
	  obj.comHoarse.setRawValue(opaHoarse);
	  var opaMotionHinder=pacuVitalSigns.split("!")[8]
	  obj.comMotionHinder.setRawValue(opaMotionHinder);
	  var opaSpSituation=pacuVitalSigns.split("!")[9]
	  obj.txtSpSituation.setValue(opaSpSituation);
	  var opaAppendix=pacuVitalSigns.split("!")[10]
	  obj.txtAppendix.setValue(opaAppendix);
	  var opaIntoPACUScore=pacuVitalSigns.split("!")[11]
	  obj.txtInScore.setValue(opaIntoPACUScore);
	  var opaOutPACUScore=pacuVitalSigns.split("!")[12]
	  obj.txtOutScore.setValue(opaOutPACUScore);
	  var pacuOutDate=retStr.split("^")[10]
	  obj.frmDate.setRawValue(pacuOutDate)
	  var pacuOutTime=retStr.split("^")[11]
	  obj.txtTime.setValue(pacuOutTime)
	  var ret=_DHCPacuRecord.insertPacuOrder(opaId)
	  if(ret!='0')
	  {
	   alert(ret);
	   return;
	  }
	  obj.recordListGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCPacuRecord';
			param.QueryName = 'GetPacuOrder';
			param.Arg1 = opaId;
			param.ArgCnt = 1;
		});
		obj.recordListGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		});  
	}
	obj.btnSave_click=function()
	{
	 var count=obj.recordListGridPanelStore.getCount();
	 for (var i=0;i<count;i++)
		{
			var record=obj.recordListGridPanelStore.getAt(i);
			var startTime=record.get('startTime');
			var bpAnoId=record.get('bpAnoId');
			var bpAnoNote=record.get('bpAnoNote');
			var hrAnoQty=record.get('hrAnoQty');
			var hrAnoId=record.get('hrAnoId');
			var spAnoQty=record.get('spAnoQty');
			var spAnoId=record.get('spAnoId');
			var dvAnoQty=record.get('dvAnoQty');
			var dvAnoId=record.get('dvAnoId');
			var scAnoNote=record.get('scAnoNote');
			var scAnoId=record.get('scAnoId');
			if((bpAnoId!="")&&(hrAnoId!="")&&(spAnoId!="")&&(dvAnoId!="")&&(scAnoId!=""))
			{
			var bpAnoStr=bpAnoNote+"^"+bpAnoId
	        var hrAnoStr=hrAnoQty+"^"+hrAnoId
			var spAnoStr=spAnoQty+"^"+spAnoId
			var dvAnoStr=dvAnoQty+"^"+dvAnoId
			var scAnoStr=scAnoNote+"^"+scAnoId
            var ret=_DHCPacuRecord.UpdatePacuOrder(startTime,bpAnoStr,hrAnoStr,spAnoStr,dvAnoStr,scAnoStr)
			if(ret!='0')
			{
			  var err=ret.split("^")[1]
			  var msg=ret.split("^")[0]
			  var n=i+1
			  alert("第"+n+"条记录("+err+")导致"+msg+",请检查输入格式!");
			  return;
			}
			}
		}
	 var opaId=getUrlParam('opaId');
	 var opaBP=obj.txtBP.getValue();
	 var opaHR=obj.txtHR.getValue();
	 var opaSpO2=obj.txtSPO2.getValue();
	 var opaRR=obj.txtRR.getValue();
	 var opaSense=obj.comSense.getRawValue()
	 var opaNausea=obj.comNausea.getRawValue();
	 var opaVomit=obj.comVomit.getRawValue();
	 var opaHoarse=obj.comHoarse.getRawValue();
	 var opaMotionHinder=obj.comMotionHinder.getRawValue();
	 var opaSpSituation=obj.txtSpSituation.getValue();
	 var opaAppendix=obj.txtAppendix.getValue();
	 var opaIntoPACUScore=obj.txtInScore.getValue();
	 var opaOutPACUScore=obj.txtOutScore.getValue();
	 var opaPACUOutDate=obj.frmDate.getRawValue();
	 var opaPACUOutTime=obj.txtTime.getRawValue();
	 var anDoctorId=obj.comAnDoctor.getValue()
	 var anNurseId=obj.comAnNurse.getValue()
	 var ret=_DHCPacuRecord.UpdatePacuVitalSigns(opaId,opaBP,opaHR,opaSpO2,opaRR,opaSense,opaNausea,opaVomit,opaHoarse,opaMotionHinder,opaSpSituation,opaAppendix,opaIntoPACUScore,opaOutPACUScore,opaPACUOutDate,opaPACUOutTime,anDoctorId,anNurseId)
	if(ret!='0') 
	 {
	   alert(ret);
	   return;
	 }
	 alert("更新成功")
	}
	obj.btnPrint_click=function()
   {
     var fileName,path;
	 var xlsExcel,xlsBook,xlsSheet;
	 var row=3;
	 var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
	 var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
	 path=GetFilePath()
	 fileName=path+"DHCPACUREC.xls";
	try { 
   	 xlsExcel = new ActiveXObject("Excel.Application");
	 xlsBook = xlsExcel.Workbooks.Add(fileName);
	 xlsSheet = xlsBook.ActiveSheet;
	 }
	catch(e) { 
     alert("您的电脑没有安装Microsoft Excel软件！"); 
     return false; 
     } 
	 mergcell(xlsSheet,1,8,11); //合并不用的单元格
	 mergcell(xlsSheet,2,10,11); //合并不用的单元格
	 mergcell(xlsSheet,3,10,11); //合并不用的单元格
	 mergcell(xlsSheet,4,1,11); //合并不用的单元格
	 mergcell(xlsSheet,8,10,11);  //合并不用的单元格
	 var printLen=11
	 mergcell(xlsSheet,1,1,7);
	 xlsSheet.cells(1,1)="中国医科大学附属第一医院";
	 xlcenter(xlsSheet,1,1,7);
	 xlsSheet.cells(2,9)="床号:";
	 xlsSheet.cells(2,9).HorizontalAlignment=4
	 xlsSheet.cells(2,10)=obj.txtBedCode.getValue();
	 nmergcell(xlsSheet,2,3,1,7);
	 xlsSheet.cells(2,1)="麻醉术后记录";
	 fontcell(xlsSheet,2,1,7,25)
	 xlcenter(xlsSheet,2,1,7);
	 xlsSheet.cells(3,9)="住院号:";
	 xlsSheet.cells(3,9).HorizontalAlignment=4
	 xlsSheet.cells(3,10)=obj.txtHosNum.getValue();
	 xlsSheet.cells(5,1)="姓名:";
	 mergcell(xlsSheet,5,2,3);
	 xlsSheet.cells(5,2)=obj.txtName.getValue();
	 xlsSheet.cells(5,4)="性别:";
	 xlsSheet.cells(5,5)=obj.comSex.getRawValue();
	 xlsSheet.cells(5,6)="年龄:";
	 xlsSheet.cells(5,7)=obj.txtAge.getValue();
	 xlsSheet.cells(5,8)="科室:";
	 mergcell(xlsSheet,5,9,11);
	 xlsSheet.cells(5,9)=obj.txtCtLoc.getValue();
	 mergcell(xlsSheet,6,1,2);
	 xlsSheet.cells(6,1)="麻醉方式:";
	 mergcell(xlsSheet,6,3,11);
	 xlsSheet.cells(6,4)=obj.txtAnMethod.getValue();
     mergcell(xlsSheet,7,1,11);
	 xlsSheet.cells(7,1)="麻醉恢复情况"
	 xlsSheet.cells(8,1)="血压:"
	 mergcell(xlsSheet,8,2,3);
     xlsSheet.cells(8,2)=obj.txtBP.getValue()+" mmHg";
	 xlsSheet.cells(8,4)="心率:"
	 mergcell(xlsSheet,8,5,6);
     xlsSheet.cells(8,5)=obj.txtHR.getValue()+" 次/分";
	 xlsSheet.cells(8,7)="SpO2:"
     xlsSheet.cells(8,8)=obj.txtSPO2.getValue()+" %";
	 xlsSheet.cells(8,9)="呼吸频率:"
     xlsSheet.cells(8,10)=obj.txtRR.getValue()+" 次/分";
	 xlsSheet.cells(9,1)="神志:"
	 mergcell(xlsSheet,9,2,3);
     xlsSheet.cells(9,2)=obj.comSense.getRawValue();
	 xlsSheet.cells(9,4)="恶心:"
     xlsSheet.cells(9,5)=obj.comNausea.getRawValue();
     xlsSheet.cells(9,6)="呕吐:"
     xlsSheet.cells(9,7)=obj.comVomit.getRawValue();
	 xlsSheet.cells(9,8)="声音嘶哑:"
     xlsSheet.cells(9,9)=obj.comHoarse.getRawValue();
	 xlsSheet.cells(9,10)="肢体感觉/运动障碍:"
     xlsSheet.cells(9,11)=obj.comMotionHinder.getRawValue();
	 mergcell(xlsSheet,10,1,2);
	 xlsSheet.cells(10,1)="特殊情况:"
	 mergcell(xlsSheet,10,3,11);
     xlsSheet.cells(10,3)=obj.txtSpSituation.getValue();
	 mergcell(xlsSheet,11,1,11);
	 mergcell(xlsSheet,12,1,11);
	 xlsSheet.cells(12,1).HorizontalAlignment=3
	 xlsSheet.cells(12,1)="麻醉后恢复室(PACU)记录单";
	 var row=13
	 mergcell(xlsSheet,row,2,3);
	 xlsSheet.cells(row,2)="时间";
	 mergcell(xlsSheet,row,4,5);
	 xlsSheet.cells(row,4)="血压 mmHg";
	 mergcell(xlsSheet,row,6,7);
	 xlsSheet.cells(row,6)="心率 次/分";
	 xlsSheet.cells(row,8)="SpO2 %";
	 xlsSheet.cells(row,9)="引流量 ml";
	 xlsSheet.cells(row,10)="处置/特殊情况";
	 mergcell(xlsSheet,row,10,11);
	 var count=obj.recordListGridPanelStore.getCount();
	 for (var i=0;i<count;i++)
		{
		 row=row+1;
		 var record=obj.recordListGridPanelStore.getAt(i);
		 xlsSheet.cells(row,1)=record.get('id')
		 xlsSheet.cells(row,1).HorizontalAlignment=4
		 mergcell(xlsSheet,row,2,3);
		 xlsSheet.cells(row,2)=record.get('startTime')
		 mergcell(xlsSheet,row,4,5);
		 xlsSheet.cells(row,4)=record.get('bpAnoNote')
		 mergcell(xlsSheet,row,6,7);
		 xlsSheet.cells(row,6)=record.get('hrAnoQty')
		 xlsSheet.cells(row,8)=record.get('spAnoQty')
		 xlsSheet.cells(row,9)=record.get('dvAnoQty')
		 xlsSheet.cells(row,10).WrapText=true;
		 xlsSheet.cells(row,10)=record.get('scAnoNote')
		 mergcell(xlsSheet,row,10,11);
		 
		}
	 xlsSheet.Rows("14:"+row).RowHeight = 50; 
	 xlHVRight(xlsSheet,14,row,1,11)
	 mergcell(xlsSheet,row+1,1,11)
	 mergcell(xlsSheet,row+2,1,11)
	 xlsSheet.cells(row+2,1)="附录："
	 nmergcell(xlsSheet,row+3,row+6,1,11);
	 xlsSheet.cells(row+3,1).VerticalAlignment = 1
	 xlsSheet.cells(row+3,1)=obj.txtAppendix.getValue();
	 mergcell(xlsSheet,row+7,1,2)
	 xlsSheet.cells(row+7,1)="麻醉医生:"
	 xlsSheet.cells(row+7,3)=obj.comAnDoctor.getRawValue();
	 mergcell(xlsSheet,row+7,4,5)
	 xlsSheet.cells(row+7,4)="麻醉护士:";
	 mergcell(xlsSheet,row+7,6,7)
	 xlsSheet.cells(row+7,6)=obj.comAnNurse.getRawValue();
	 xlsSheet.cells(row+7,8)="时间:"
	 xlsSheet.cells(row+7,9)=obj.frmDate.getRawValue();
	 xlsSheet.cells(row+7,10)=obj.txtTime.getValue();
	 var CenterHeader=""
	 var LeftHeader="";
	 titleRows=2;
	 titleCols=1;
	 RightHeader = " ";LeftFooter = "";CenterFooter = "";RightFooter = "";
	 ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
	 AddGrid(xlsSheet,5,1,10,printLen,5,1);
	 AddGrid(xlsSheet,13,1,row,printLen,13,1);
	 AddGrid(xlsSheet,row+3,1,row+6,printLen,row+3,1);
	 //FrameGrid(xlsSheet,24,0,row-1,printLen-1,24,1);
	 xlsExcel.Visible = true;
	 //xlsSheet.PrintPreview;
	 xlsSheet.PrintOut(); 
	 xlsSheet = null;
 	 xlsBook.Close(savechanges=false)
	 xlsBook = null;
	 xlsExcel.Quit();
	 xlsExcel = null;
   }
   function GetFilePath()
	{
		var path=_DHCLCNUREXCUTE.GetPath();
		return path;
	}
}

function   getUrlParam(name)
 {      
    var   reg   =   new   RegExp("(^|&)"+   name   +"=([^&]*)(&|$)");      
    var   r   =   window.location.search.substr(1).match(reg);      
    if   (r!=null)   return   unescape(r[2]);   return   null;      
 } 
 function xlHVRight(objSheet,row1,row2,c1,c2)
{
  objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).HorizontalAlignment =-4108;
  objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).VerticalAlignment =-4108;
}
