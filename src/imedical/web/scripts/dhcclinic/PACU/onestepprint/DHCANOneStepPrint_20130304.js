document.write("<object id='FormICU' classid='../service/DHCClinic/App/AN/UI.dll#UI.OneStepPrint' height='0' width='0' VIEWASTEXT/>")
document.write("</object>");

 Ext.onReady( function ()
 {   
  _DHCANOPCom=ExtTool.StaticServerObject('web.DHCANOPCom');
  var opaIdStr=_DHCANOPCom.GetOpaIdStr(EpisodeID);
  var documentTypeStr="AMT^AN^PACU"  //ԭ���ƻ����δ�ӡ��ͬ�ĵ����ͣ�����һ��ȫ��������أ����ֱ��ƴ����������
  var docTypeArr=documentTypeStr.split("^");
  var i,str1="",str2="";
  for(i=0;i<docTypeArr.length;i++)
  {
    if(docTypeArr[i]!="PACU")
	{
	 if(str1=="")str1=docTypeArr[i];
	 else str1=str1+"^"+docTypeArr[i];
	}
	else str2="PACU"
  }
  if(opaIdStr=="") return;
  var userId=session['LOGON.USERID'];
  var userGroupId=session['LOGON.GROUPID'];
  var isSuperUser=false;
  var curLocation=unescape(window.location);
	curLocation=curLocation.toLowerCase();
	filePathStr=curLocation.substr(0,curLocation.indexOf('/csp/'))+"/service/DHCClinic/Configuration/";
	if(str1!="")
	{
	  var count=opaIdStr.split("^").length;
	  var i=0;
	  for(i=0;i<count;i++)
	  {
	  opaId=opaIdStr.split("^")[i];
	  if(opaId=="")continue;
	  ctlocId=_DHCANOPCom.GetAnLocId(opaId)
	  FormICU.InitOneStepPrint(opaId,userId,connectStr,isSuperUser,userGroupId,ctlocId,filePathStr,str1,""); 
	  }
	}
	if(str2!="")
	{ 
	  var count=opaIdStr.split("^").length;
      var i;
      for(i=0;i<count;i++)
      {	
        opaId=opaIdStr.split("^")[i];
        if(opaId=="")continue;
		storeProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
	     url : ExtToolSetting.RunQueryPageURL
	      }));
        store = new Ext.data.Store({
	    proxy: storeProxy,
	    reader: new Ext.data.JsonReader({
	    root: 'record',
	    totalProperty: 'total',
	    idProperty: 'id'
		}, 
		[
			 {name: 'id', mapping: 'id'}
			,{name: 'startTime', mapping: 'startTime'}
			,{name: 'bpAnoNote', mapping: 'bpAnoNote'}
			,{name: 'bpAnoId', mapping: 'bpAnoId'}
			,{name: 'hrAnoQty', mapping: 'hrAnoQty'}
			,{name: 'hrAnoId', mapping: 'hrAnoId'}
			,{name: 'spAnoQty', mapping: 'spAnoQty'}
			,{name: 'spAnoId', mapping: 'spAnoId'}
			,{name: 'dvAnoQty', mapping: 'dvAnoQty'}
			,{name: 'dvAnoId', mapping: 'dvAnoId'}
			,{name: 'scAnoNote', mapping: 'scAnoNote'}
			,{name: 'scAnoId', mapping: 'scAnoId'}
			,{name: 'opaId', mapping: 'opaId'}
		])
	});
	 storeProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCPacuRecord';
			param.QueryName = 'GetPacuOrder';
			param.Arg1 = opaId;
			param.ArgCnt = 1;
		});
	store.load({
	  callback:function(records,option,success)
	  {
	   if(success)
	   {
	    PrintFunc(records)
	   }
	  }
	})
      }
	 }
	setTimeout("window.close();", 10000 )
})
function PrintFunc(records)
{
var fileName,path;
	 var xlsExcel,xlsBook,xlsSheet;
	 var row=3;
	 var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
	 var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
	 path=GetFilePath()
	 fileName=path+"DHCPACUREC.xls"
	 try { 
   	 xlsExcel = new ActiveXObject("Excel.Application");
	 xlsBook = xlsExcel.Workbooks.Add(fileName);
	 xlsSheet = xlsBook.ActiveSheet;
	 }
	 catch(e) { 
     alert("���ĵ���û�а�װMicrosoft Excel�����"); 
     return false; 
     } 
	 var opaId=records[0].get('opaId');
	 if(opaId=="")return;
	 var retStr=""
	 var _DHCPacuRecord=ExtTool.StaticServerObject('web.DHCPacuRecord');
	  retStr=_DHCPacuRecord.GetBaseInfo(opaId);
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
	 var pacuVitalSigns=retStr.split("^")[9]
	 var opaBP=pacuVitalSigns.split("!")[0]
	 var opaHR=pacuVitalSigns.split("!")[1]
	 var opaSpO2=pacuVitalSigns.split("!")[2]
	 var opaRR=pacuVitalSigns.split("!")[3]
	 var opaSense=pacuVitalSigns.split("!")[4]
	 var opaNausea=pacuVitalSigns.split("!")[5]
	 var opaVomit=pacuVitalSigns.split("!")[6]
	 var opaHoarse=pacuVitalSigns.split("!")[7]
	 var opaMotionHinder=pacuVitalSigns.split("!")[8]
	 var opaSpSituation=pacuVitalSigns.split("!")[9]
	 var opaAppendix=pacuVitalSigns.split("!")[10]
	 var opaIntoPACUScore=pacuVitalSigns.split("!")[11]
	 var opaOutPACUScore=pacuVitalSigns.split("!")[12]
	 var pacuOutDate=retStr.split("^")[10]
     var pacuOutTime=retStr.split("^")[11]
	 mergcell(xlsSheet,1,8,11); //�ϲ����õĵ�Ԫ��
	 mergcell(xlsSheet,2,10,11); //�ϲ����õĵ�Ԫ��
	 mergcell(xlsSheet,3,10,11); //�ϲ����õĵ�Ԫ��
	 mergcell(xlsSheet,4,1,11); //�ϲ����õĵ�Ԫ��
	 mergcell(xlsSheet,8,10,11);  //�ϲ����õĵ�Ԫ��
	 var printLen=11
	 mergcell(xlsSheet,1,1,7);
	 xlsSheet.cells(1,1)="�й�ҽ�ƴ�ѧ������һҽԺ";
	 xlcenter(xlsSheet,1,1,7);
	 xlsSheet.cells(2,9)="����:";
	 xlsSheet.cells(2,9).HorizontalAlignment=4
	 xlsSheet.cells(2,10)=pacuBed;
	 nmergcell(xlsSheet,2,3,1,7);
	 xlsSheet.cells(2,1)="���������¼";
	 fontcell(xlsSheet,2,1,7,25)
	 xlcenter(xlsSheet,2,1,7);
	 xlsSheet.cells(3,9)="סԺ��:";
	 xlsSheet.cells(3,9).HorizontalAlignment=4
	 xlsSheet.cells(3,10)=medCareNo;
	 xlsSheet.cells(5,1)="����:";
	 mergcell(xlsSheet,5,2,3);
	 xlsSheet.cells(5,2)=patName;
	 xlsSheet.cells(5,4)="�Ա�:";
	 xlsSheet.cells(5,5)=sex;
	 xlsSheet.cells(5,6)="����:";
	 xlsSheet.cells(5,7)=age;
	 xlsSheet.cells(5,8)="����:";
	 mergcell(xlsSheet,5,9,11);
	 xlsSheet.cells(5,9)=locDes;
	 mergcell(xlsSheet,6,1,2);
	 xlsSheet.cells(6,1)="����ʽ:";
	 mergcell(xlsSheet,6,3,11);
	 xlsSheet.cells(6,4)=anMethod;
     mergcell(xlsSheet,7,1,11);
	 xlsSheet.cells(7,1)="����ָ����"
	 xlsSheet.cells(8,1)="Ѫѹ:"
	 mergcell(xlsSheet,8,2,3);
     xlsSheet.cells(8,2)=opaBP+" mmHg";
	 xlsSheet.cells(8,4)="����:"
	 mergcell(xlsSheet,8,5,6);
     xlsSheet.cells(8,5)=opaHR+" ��/��";
	 xlsSheet.cells(8,7)="SpO2:"
     xlsSheet.cells(8,8)=opaSpO2+" %";
	 xlsSheet.cells(8,9)="����Ƶ��:"
     xlsSheet.cells(8,10)=opaRR+" ��/��";
	 xlsSheet.cells(9,1)="��־:"
	 mergcell(xlsSheet,9,2,3);
     xlsSheet.cells(9,2)=opaSense;
	 xlsSheet.cells(9,4)="����:"
     xlsSheet.cells(9,5)=opaNausea;
     xlsSheet.cells(9,6)="Ż��:"
     xlsSheet.cells(9,7)=opaVomit;
	 xlsSheet.cells(9,8)="����˻��:"
     xlsSheet.cells(9,9)=opaHoarse;
	 xlsSheet.cells(9,10)="֫��о�/�˶��ϰ�:"
     xlsSheet.cells(9,11)=opaMotionHinder;
	 mergcell(xlsSheet,10,1,2);
	 xlsSheet.cells(10,1)="�������:"
	 mergcell(xlsSheet,10,3,11);
     xlsSheet.cells(10,3)=opaSpSituation;
	 mergcell(xlsSheet,11,1,11);
	 mergcell(xlsSheet,12,1,11);
	 xlsSheet.cells(12,1).HorizontalAlignment=3
	 xlsSheet.cells(12,1)="�����ָ���(PACU)��¼��";
	 var row=13
	 mergcell(xlsSheet,row,2,3);
	 xlsSheet.cells(row,2)="ʱ��";
	 mergcell(xlsSheet,row,4,5);
	 xlsSheet.cells(row,4)="Ѫѹ mmHg";
	 mergcell(xlsSheet,row,6,7);
	 xlsSheet.cells(row,6)="���� ��/��";
	 xlsSheet.cells(row,8)="SpO2 %";
	 xlsSheet.cells(row,9)="������ ml";
	 xlsSheet.cells(row,10)="����/�������";
	 mergcell(xlsSheet,row,10,11);
	 var count=records.length;
	 for (var i=0;i<count;i++)
		{
		 row=row+1;
		 var record=records[i];
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
	 xlsSheet.cells(row+2,1)="steward���֣�"
	 mergcell(xlsSheet,row+3,1,3)
	 xlsSheet.cells(row+3,1).VerticalAlignment = 1
	 xlsSheet.cells(row+3,1)="��PACU����:"
	 mergcell(xlsSheet,row+3,4,7)
	 xlsSheet.cells(row+3,4)=opaIntoPACUScore;
	 mergcell(xlsSheet,row+3,8,9)
	 xlsSheet.cells(row+3,8)="��PACU����:"
	 mergcell(xlsSheet,row+3,10,11)
	 xlsSheet.cells(row+3,10)=opaOutPACUScore;
	 mergcell(xlsSheet,row+4,1,11)
	 mergcell(xlsSheet,row+5,1,11)
	 xlsSheet.cells(row+5,1)="��¼��"
	 nmergcell(xlsSheet,row+6,row+9,1,11);
	 xlsSheet.cells(row+6,1)=opaAppendix;
	 xlsSheet.cells(row+6,1).VerticalAlignment = 1
	 mergcell(xlsSheet,row+10,1,2)
	 xlsSheet.cells(row+10,1)="����ҽ��:"
	 xlsSheet.cells(row+10,3)=anDoc;
	 mergcell(xlsSheet,row+10,4,5)
	 xlsSheet.cells(row+10,4)="����ʿ:";
	 mergcell(xlsSheet,row+10,6,7)
	 xlsSheet.cells(row+10,6)=anNurse;
	 xlsSheet.cells(row+10,8)="ʱ��:"
	 xlsSheet.cells(row+10,9)=pacuOutDate;
	 xlsSheet.cells(row+10,10)=pacuOutTime;
	 var CenterHeader=""
	 var LeftHeader="";
	 titleRows=4;
	 titleCols=1;
	 RightHeader = " ";LeftFooter = "";CenterFooter = "";RightFooter = "&N - &P";
	 ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
	 AddGrid(xlsSheet,5,1,10,printLen,5,1);
	 AddGrid(xlsSheet,13,1,row,printLen,13,1);
	 AddGrid(xlsSheet,row+3,1,row+3,printLen,row+3,1);
	 AddGrid(xlsSheet,row+6,1,row+9,printLen,row+6,1);
	 //FrameGrid(xlsSheet,24,0,row-1,printLen-1,24,1);
	 //xlsExcel.Visible = true;
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
    var _DHCLCNUREXCUTE=ExtTool.StaticServerObject('web.DHCLCNUREXCUTE');
	var path=_DHCLCNUREXCUTE.GetPath();
	return path;
 }
function xlHVRight(objSheet,row1,row2,c1,c2)
{
  objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).HorizontalAlignment =-4108;
  objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).VerticalAlignment =-4108;
}