 var gHospname;
 var gPrnpath="";
 var ReqRowID="";
 //var RePrintFlag="";
 var PrtSumFlag="";
 var ReqType="";

 var AllowRePrintFlag=""
 var printedFlag
 
 var saveExcelFlag="";//�Ƿ񵼳�������ϸ���
 var DispUser=""
 
function BodyLoadHandler()
{
 var obj=document.getElementById("mGetPrnPath") ;
 if (obj) {var encmeth=obj.value;} else {var encmeth='';}
 gPrnpath=cspRunServerMethod(encmeth,'','') ;

 var obj=document.getElementById("mPrtHospName") ;
 if (obj) {var encmeth=obj.value;} else {var encmeth='';}
 gHospname=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID'])

 var obj=document.getElementById("ReqRowID") ;  //����rowid
 if (obj) ReqRowID=obj.value;
 
 //var obj=document.getElementById("RePrintFlag") ;  //�ظ���ӡ��־
 //if (obj) RePrintFlag=obj.value;

 var obj=document.getElementById("PrtSumFlag") ;  //���ܴ�ӡ��־
 if (obj) PrtSumFlag=obj.value;

 var obj=document.getElementById("AllowRePrintFlag") ;  //���ظ���ӡ��־
 if (obj) AllowRePrintFlag=obj.value;

  // kww 20130414 add
 var obj=document.getElementById("saveExcelFlag") ;  //�Ƿ񵼳�������ϸ���
 if (obj) saveExcelFlag=obj.value;

 if (ReqRowID=="") return;
 
 var obj=document.getElementById("GetReqType") ;
 if (obj) var encmet=obj.value;
 else var encmet=""
 ReqType=cspRunServerMethod(encmet,ReqRowID) ;   //��������(1,2)

 PrtSumFlag='1'
 
 if (PrtSumFlag=='1') 
 { 
     printReq(ReqRowID,ReqType);
 }
 else if(PrtSumFlag=='2')
 {
	 printReqBM(ReqRowID);
 }
 else
 {
	if (ReqType=='2') printReqJSDM(ReqRowID);  //ֻ�о��������󵥿ɴ�ӡ��ϸ
 }
 
}
function printReq(req,ReqType)
{
	var obj=document.getElementById("DispUser") ;  
	if (obj) DispUser=obj.value;
	if (req=="") return;
    printedFlag=GetPrintReqFlag(req);  // ��ӡ��־
 	if ((printedFlag=="1")&&(ReqType=="2")) 
	{
		alert('���������󵥽�ֹ�ظ���ӡ!');
		return;
	}
	
	var exeReq="";
	var exeReqItm="";
	var obj=document.getElementById("mListReq");
	if (obj) exeReq=obj.value;
	var obj=document.getElementById("mListReqItm");
	if (obj) exeReqItm=obj.value;
 	if 	(exeReq!="")
 	{
	 	var result=cspRunServerMethod(exeReq,req);
 	    if (result=="") return;
 		if (setPrintReqFlag(req)<0)
 		{
 		  alert('�������󵥴�ӡ��־ʧ��!');
 		  return;
 		}			    
	 	var ss=result.split("^");
	 	
	 	var pid=ss[0];
	 	var cnt=ss[1];
	 	var recLoc=ss[2];
	 	var reqLoc=ss[3];
	 	var reqNo=ss[4];
	 	var reqDate=ss[5];
	 	var reqUser=ss[6];
	 	var sd=ss[7];
	 	var ed=ss[8];
	 	var collUser=ss[9]; // ��ҩ��
	 	var startNo=5;
	 	var prnTemp=gPrnpath+"STP_BaseDrugReqItm.xls";
	 	//var prnTemp="C:\\dhcpha\\STP_BaseDrugReqItm.xls";
	    var xlApp = new ActiveXObject("Excel.Application");
	    var xlBook = xlApp.Workbooks.Add(prnTemp);
	    var xlsheet = xlBook.ActiveSheet ;
	    xlsheet.Cells(1,1).value=gHospname+"����ҩƷ������"
	 	if(ReqType==1){
	 		xlsheet.Cells(1,1).value=xlsheet.Cells(1,1).value+"(����)";
	 	}else if(ReqType==2){
	 		xlsheet.Cells(1,1).value=xlsheet.Cells(1,1).value+"(����)";
	 	}
	 	if (printedFlag=='1')
	 	{
		 	xlsheet.Cells(1,1).value=xlsheet.Cells(1,1).value+"  (����)";
	 	}
	 	
	 	xlsheet.Cells(2,1).value="";
	 	xlsheet.Cells(3,1).value="";
	 	xlsheet.Cells(2,1).value="�������:"+recLoc+"  "+"��Ӧ����:"+reqLoc+"  " + "���󵥺�:"+reqNo;
	 	xlsheet.Cells(3,1).value="���ڷ�Χ:"+sd+"~"+ed+"   "+"��ӡ����:"+getPrintDateTime();
 		
		
 		var row=startNo-1;
 		for (var i=1;i<=cnt;i++)
 		{
	 		var reqitm=cspRunServerMethod(exeReqItm,pid,i);
 			
 			var ss=reqitm.split("^");
 			var stkbin=ss[7];
 			var desc=ss[2];
 			var spec=ss[8];
 			var uom=ss[3];
 			var qty=ss[4];
 			var sp=ss[5];
 			
 			row++;
 			xlsheet.Cells(row,1).value=i;
 			xlsheet.Cells(row,2).value=stkbin;
 			xlsheet.Cells(row,3).value=desc;
 			xlsheet.Cells(row,4).value=spec;
 			xlsheet.Cells(row,5).value=uom;
 			xlsheet.Cells(row,6).value=qty;
 			//xlsheet.Cells(row,7).value="";
 			gridlist(xlsheet,row,row,1,6);
 		}
 		row+=1; 
 		//CellMerge(xlsheet,row,row,1,7);
 		xlsheet.Cells(row,2).value="�Ƶ���:"+reqUser+"  ������:"+collUser+"  ��ҩ/�����:"+DispUser+"  ��ҩ��:      ������ʿ:  "
 		xlsheet.printout();
		SetNothing(xlApp,xlBook,xlsheet);
 	}
}
function printReqJSDM(req)
{
	var obj=document.getElementById("DispUser") ;  
	if (obj) DispUser=obj.value;
	if (req=="") return;
    printedFlag=GetPrintReqFlag(req);  // ��ӡ��־
	if ((printedFlag=="1")&&(ReqType=="2"))
	{
		alert('���������󵥽�ֹ�ظ���ӡ!');
		return;
	}

	var exeReq="";
	var exeReqItm="";
	var obj=document.getElementById("mListReq");
	if (obj) exeReq=obj.value;
	var obj=document.getElementById("mListReqItmOrd");
	if (obj) exeReqItm=obj.value;
 	if 	(exeReq!="")
 	{
	 	var result=cspRunServerMethod(exeReq,req);
 	    if (result=="") return;
 		if (setPrintReqFlag(req)<0)
 		{
 		  alert('�������󵥴�ӡ��־ʧ��!');
 		  return;
 		}
	 	var ss=result.split("^");
	 	var pid=ss[0];
	 	var cnt=ss[1];
	 	var recLoc=ss[2];
	 	var reqLoc=ss[3];
	 	var reqNo=ss[4];
	 	var reqDate=ss[5];
	 	var reqUser=ss[6];
	 	var sd=ss[7];
	 	var ed=ss[8];
	 	var collUser=ss[9];
	 	var startNo=5;
	 	
	 	var prnTemp=gPrnpath+"STP_BaseDrugReqItmOrd.xls";
	    var xlApp = new ActiveXObject("Excel.Application");
	    var xlBook = xlApp.Workbooks.Add(prnTemp);
	    var xlsheet = xlBook.ActiveSheet ;
	 	
	 	if (printedFlag=='1')
	 	{
		 	xlsheet.Cells(1,1).value=xlsheet.Cells(1,1).value+"  (����)";
		 	}
	 	xlsheet.Cells(2,1).value="";
	 	xlsheet.Cells(3,1).value="";
	 	xlsheet.Cells(2,1).value="�������:"+recLoc+"      "+"��Ӧ����:"+reqLoc+"      " + "���󵥺�:"+reqNo;
	 	xlsheet.Cells(3,1).value="���ڷ�Χ:"+sd+"~"+ed+"   "+"��ӡ����:"+getPrintDateTime();
 
 		var row=startNo-1;
 		
 		i=0
		do {
	 		var reqitm=cspRunServerMethod(exeReqItm,pid,i);
 			if (reqitm!="") 
 			{
	 			var ss=reqitm.split("^");
	 			
				var paname=ss[0];
				var pasex=ss[1];
				var paage=ss[2];
				var papmiid=ss[3];
				var disease=ss[4];
				var medicareno=ss[5];
				var regno=ss[6];
				
				var prescno=ss[7];
				var doctor=ss[8];
				var freq=ss[9];
				var doseqty=ss[10];
				var admloc=ss[11];
				var instruction=ss[12];
				var doclocdr=ss[13];
				var OldWardDesc=ss[14];
				var  inciDesc=ss[15];
				var spec=ss[16];
				var buomDesc=ss[17];
				var ordDate=ss[18];
				var qty=ss[19];
	 			
	 			row++;
	 			xlsheet.Cells(row,1).value=inciDesc; //����
	 			xlsheet.Cells(row,2).value= spec;//���
	 			xlsheet.Cells(row,3).value= ordDate  ; //��������
	 			xlsheet.Cells(row,4).value=paname;  //����
	 			xlsheet.Cells(row,5).value=pasex;//�Ա�
	 			xlsheet.Cells(row,6).value=paage;//����
				xlsheet.Cells(row,7).value=papmiid;//���֤��
	 			xlsheet.Cells(row,8).value=regno;//סԺ��
	 			xlsheet.Cells(row,9).value=disease;//���
	 			xlsheet.Cells(row,10).value=qty;//����
	 			xlsheet.Cells(row,11).value=doctor;//����ҽ��
	 			gridlist(xlsheet,row,row,1,11);		
	 			i++;	
 			}
		} while (reqitm!="")
 		row+=1; 
 		xlsheet.Cells(row,2).value="�Ƶ���:"+reqUser+"  ������:"+collUser+"  ��ҩ/�����:"+DispUser+"  ��ҩ��:      ������ʿ:  "

 		//xlsheet.printout();
		//SetNothing(xlApp,xlBook,xlsheet);
		// kww 20130514 add start ����һ���ж��Ǵ�ӡ���ǵ���
		if(saveExcelFlag!=1)
 		{
 			xlsheet.printout();
 			SetNothing(xlApp,xlBook,xlsheet);
 		} else if(saveExcelFlag==1)
 		{
 			SetNothingSave(xlApp,xlBook,xlsheet);
 		}
		// kww 20130514 add end
 	}	
}

//��ӡ�������ҩ
function printReqBM(req)
{
	var obj=document.getElementById("DispUser") ;  
	if (obj) DispUser=obj.value;
	if (req=="") return;

    printedFlag=GetPrintReqFlag(req);  // ��ӡ��־
   
	if ((printedFlag=="1")&&(AllowRePrintFlag=="0")) 
	{
		alert('���������󵥽�ֹ�ظ���ӡ!');
		return;
	}
	if((ReqType!="1"))
	{
		//�ǻ������������Ը����ʹ�ӡ
		return;
	}
	
	var exeReq="";
	var exeReqItm="";
	var obj=document.getElementById("mListReq");
	if (obj) exeReq=obj.value;
	var obj=document.getElementById("mListReqItmOrd");
	if (obj) exeReqItm=obj.value;
 	if 	(exeReq!="")
 	{
	 	var result=cspRunServerMethod(exeReq,req);
 	    if (result=="") return;
 	    
	 	var ss=result.split("^");
	 	var pid=ss[0];
	 	var cnt=ss[1];
	 	var recLoc=ss[2];
	 	var reqLoc=ss[3];
	 	var reqNo=ss[4];
	 	var reqDate=ss[5];
	 	var reqUser=ss[6];
	 	var sd=ss[7];
	 	var ed=ss[8];
	 	var collUser=ss[9];
	 	var startNo=5;
	 	
	 	var prnTemp=gPrnpath+"STP_BaseDrugReqItmOrd.xls";
	    var xlApp = new ActiveXObject("Excel.Application");
	    var xlBook = xlApp.Workbooks.Add(prnTemp);
	    var xlsheet = xlBook.ActiveSheet ;
	    xlsheet.Cells(1,1).value = "�������ҩƷ���󵥣�������";
	 	xlsheet.Cells(2,1).value="";
	 	xlsheet.Cells(3,1).value="";
	 	xlsheet.Cells(2,1).value="�������:"+recLoc+"      "+"��Ӧ����:"+reqLoc+"      " + "���󵥺�:"+reqNo;
	 	xlsheet.Cells(3,1).value="���ڷ�Χ:"+sd+"~"+ed+"   "+"��ӡ����:"+getPrintDateTime();
 

 		i=0
		do {
			var row=startNo-1;
	 		var reqitm=cspRunServerMethod(exeReqItm,pid,i);
 			if (reqitm!="") 
 			{
	 			var ss=reqitm.split("^");
	 			
				var paname=ss[0];
				var pasex=ss[1];
				var paage=ss[2];
				var papmiid=ss[3];
				var disease=ss[4];
				var medicareno=ss[5];
				var regno=ss[6];
				
				var prescno=ss[7];
				var doctor=ss[8];
				var freq=ss[9];
				var doseqty=ss[10];
				var admloc=ss[11];
				var instruction=ss[12];
				var doclocdr=ss[13];
				var OldWardDesc=ss[14];
				var  inciDesc=ss[15];
				var spec=ss[16];
				var buomDesc=ss[17];
				var ordDate=ss[18];
				var qty=ss[19];
				if(inciDesc.indexOf("����") == -1)
				{
					i++;
					continue;	//�Ǳ���ҩ�˳�
				}
	 			
	 			row++;
	 			xlsheet.Cells(row,1).value=inciDesc; //����
	 			xlsheet.Cells(row,2).value= spec;//���
	 			xlsheet.Cells(row,3).value= ordDate  ; //��������
	 			xlsheet.Cells(row,4).value=paname;  //����
	 			xlsheet.Cells(row,5).value=pasex;//�Ա�
	 			xlsheet.Cells(row,6).value=paage;//����
				xlsheet.Cells(row,7).value=papmiid;//���֤��
	 			xlsheet.Cells(row,8).value=regno;//סԺ��
	 			xlsheet.Cells(row,9).value=disease;//���
	 			xlsheet.Cells(row,10).value=qty;//����
	 			xlsheet.Cells(row,11).value=doctor;//����ҽ��
	 			gridlist(xlsheet,row,row,1,11);		
	 			i++;	
	 			
	 			row+=1; 
 				xlsheet.Cells(row,2).value="�Ƶ���:"+reqUser+"  ������:"+collUser+"  ��ҩ/�����:"+DispUser+"  ��ҩ��:      ������ʿ:  "
 				xlsheet.printout();
 			}
		} while (reqitm!="")
 		
 		// kww 20130514 add start ����һ���ж��Ǵ�ӡ���ǵ���
 		//xlsheet.printout();
	 	//SetNothing(xlApp,xlBook,xlsheet);
		if(saveExcelFlag!=1)
 		{
 			SetNothing(xlApp,xlBook,xlsheet);
 		} else if(saveExcelFlag==1)
 		{
 			SetNothingSave(xlApp,xlBook,xlsheet);
 		}
		// kww 20130514 add end
 	}	
}

function setPrintReqFlag(req)
{
 var exe="";
 var obj=document.getElementById("mSetPrintReqFlag");
 if (obj) exe=obj.value;
 if (exe!="")
 {
	 var result=cspRunServerMethod(exe,req);
	 return result;
  }
 else  {return -9 ;}
}
function SetNothing(app,book,sheet)
{
 app=null;
 book.Close(savechanges=false);
 sheet=null;
}

// kww 20130514 add �ر�excelʱ����excel
function SetNothingSave(app,book,sheet)
{
 app=null;
 book.Close(savechanges=true);
 sheet=null;
}

function GetPrintReqFlag(req)
{
  var exe="";
  var result="";
  var obj=document.getElementById("GetPrintReqFlag");
  if (obj) exe=obj.value;
  if (exe!="")
  {var result=cspRunServerMethod(exe,req);
   
   return result;
  }
}
document.body.onload=BodyLoadHandler;
