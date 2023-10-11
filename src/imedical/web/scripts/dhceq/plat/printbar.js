///̨�ʹ����ӡ����
function equipPrintBar()
{
	var RowID=getElementValue("RowID");
	printBars(RowID, 0);
}

function printBars(rowids, type)
{
	if (rowids=="") return;
	var arrRowId=rowids.split(",");
	var len=arrRowId.length;
	for (i=0;i<len;i++)
	{
		printBarStandard(type, arrRowId[i], {}, {}, "");
	}
}

///���յ���ӡ���� add by zyq 2022-11-16
function printOpenCheckBars(OCLRowID)
{
	if (OCLRowID=="") return; //modify by zyq 2023-02-27
	var EQRowIDs=tkMakeServerCall("web.DHCEQOpenCheckRequest","GetEQIDsByOpenCheckList", OCLRowID);
	if(EQRowIDs=="")
	{
		messageShow('alert','error','��ʾ','û���豸��Ϣ,�޷���ӡ����!','','','');
	}
	EQRowIDs=EQRowIDs.split(",")
	for(var i=0;i<EQRowIDs.length;i++)
	{
		printBarStandard(0, EQRowIDs[i], {}, {}, "") //modify by zyq 2023-02-27
	}
}

///�����ӡ����
function storeMovePrintBar()
{
	var RowID=getElementValue("SMRowID");
	printEquipBar(RowID,"StoreMove");
}
///���ݵ��ݺ�,�������͵õ�������Ϣ����ӡ
function printEquipBar(rowid,type)
{
	if (rowid=="") return;
	var strs=tkMakeServerCall("web.DHCEQ.Plat.BUSPrint","GetEquipBarInfo",rowid,type)
	if (strs=="")
	{
		messageShow('alert','error','��ʾ','û���豸��Ϣ,�޷���ӡ����!','','','');
		return;
	}
	printManyEquipNo(strs,type);
}

///��ӡ����豸����StrsΪһ���ַ���  EQNo1,EQName1^EQNO2,EQName2
function printManyEquipNo(strs,type)
{
	if (strs=="") return;
	var strArray=strs.split("^");
	var i=strArray.length;
	for (var j=0;j<i;j++)
	{
		var equipInfo=strArray[j].split(",");
		var equipRowID=equipInfo[3];
		printBarStandard(0, equipRowID, {}, {}, "");
	}
}
/*
function printBarStandard(rowid,printerName)
{
	if (rowid=="") return;
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",rowid);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow('alert','error','��ʾ',jsonData.Data,'','','');return;}
	var objEquip=jsonData.Data;
	if (objEquip.EQRowID=="")
	{
		messageShow('alert','error','��ʾ','û���ҵ��豸��Ϣ!','','','');
		return;
	}
	var Bar=new ActiveXObject("EquipmentBar.PrintBar")
	Bar.PrtName="DHCEQBarCode";	//��ӡ������
	Bar.Title=curHospitalName;
	Bar.FontName="";
	Bar.EqName=objEquip.EQName;
	Bar.EqNo=objEquip.EQNo;
	Bar.FileNo = objEquip.EQFileNo;
	Bar.OriginalFee=objEquip.EQOriginalFee;
	Bar.Model=objEquip.EQModelDR_MDesc;
	Bar.LocName=GetShortName(objEquip.EQStoreLocDR_CTLOCDesc,"-");
	Bar.StartDate=FormatDate(objEquip.EQStartDate,"","");
	Bar.Factory=objEquip.EQManuFactoryDR_MFName;	
	Bar.FacNo=objEquip.EQLeaveFactoryNo;
	Bar.Location=objEquip.EQLocationDR_LDesc;	
	Bar.InDate=FormatDate(objEquip.EQTransAssetDate,"","");
	Bar.Left=150;
	Bar.Top=500;
	//var qrcode	= new QRCode(6, QRErrorCorrectLevel.H);//ÿ���߸����� 17+3*4,������
	var valueStr=(objEquip.EQFileNo=="")?objEquip.EQNo:"fileno:"+objEquip.EQFileNo+",no:"+objEquip.EQNo;
	var type=getTypeNumber(valueStr,QRErrorCorrectLevel.Q);

	var qrcode	= new QRCode(type, QRErrorCorrectLevel.Q);//ÿ���߸����� 17+3*4,������
	ValueStr=utf16to8(valueStr);
	qrcode.addData(valueStr);
	qrcode.make();	
	var TempCode=""
	for (var i=0;i<qrcode.modules.length;i++)
	{
		for (var j=0;j<qrcode.modules.length;j++)
		{
			TempCode+=String(Number(qrcode.modules[i][j]))
		}
	}
	Bar.QRCode=TempCode
	Bar.PrintOut("1")
	//�Ǽ��Ѵ�ӡ�����־,������
	tkMakeServerCall("web.DHCEQOperateLog","SaveData","^52^"+rowid,2)
}
*/
/// 20170109 Mozy0176
function getTypeNumber(sText, nCorrectLevel)
{
	var nType = 1;
	var length = sText.length;
	
	for (var i = 0, len = QRCodeLimitLength.length; i <= len; i++)
	{
		var nLimit = 0;
		
		switch (nCorrectLevel) {
			case QRErrorCorrectLevel.L :
				nLimit = QRCodeLimitLength[i][0];
				break;
			case QRErrorCorrectLevel.M :
				nLimit = QRCodeLimitLength[i][1];
				break;
			case QRErrorCorrectLevel.Q :
				nLimit = QRCodeLimitLength[i][2];
				break;
				case QRErrorCorrectLevel.H :
				nLimit = QRCodeLimitLength[i][3];
				break;
		}
		
		if (length <= nLimit)
		{
			break;
		} else {
			nType++;
		}
	}
	
	if (nType > QRCodeLimitLength.length)
	{
		throw new Error("Too long data");
	}
	
	return nType;
}

//Modefied by zc0044 2018-11-22  ��ӡ��Ƭ
function PrintEQCard(rowid,printmode)
{	
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",rowid);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow('alert','error','��ʾ',jsonData.Data,'','','');return;}
	var objEquip=jsonData.Data;
	if (objEquip.EQRowID=="")
	{
		messageShow('alert','error','��ʾ','û���ҵ��豸��Ϣ!','','','');
		return;
	}
	
	if (printmode==2) printCardLodop(objEquip);		//czf 2022-01-24 Lodop��ӡ
	else PrintEQCardNFYY(objEquip);
	
	// add by mwz 2021-06-29  MWZ0051 begin
	var OperateLog=""
	var OperateLog=OperateLog+"^52"
	var OperateLog=OperateLog+"^"+rowid;
	var OperateLog=OperateLog+"^";
	var OperateLog=OperateLog+"^";
	var OperateLog=OperateLog+"^0";
	
	result=tkMakeServerCall("web.DHCEQ.Plat.BUSOperateLog","SaveData",OperateLog,"3");
	// add by mwz 2021-06-29  MWZ0051 end
	return;
}

function PrintEQCardNFYY(objEquip)
{
	try 
    {
        var xlApp,xlsheet,xlBook
	    xlApp = new ActiveXObject("Excel.Application");
		var	Template=getElementValue("GetRepPath")+"DHCEQCardNF.xls";
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
		xlsheet.cells(1,2)=""
		xlsheet.cells(1,7)=objEquip.EQFileNo;
		xlsheet.cells(2,7)=objEquip.EQNo; 
		var Row=3;
	    xlsheet.cells(Row,3)=GetShortName(objEquip.EQUseLocDR_CTLOCDesc,"-");
	    xlsheet.cells(Row,7)=objEquip.EQLocationDR_LDesc;
	    Row=Row+1;
	    xlsheet.cells(Row,3)=objEquip.EQName;
	    xlsheet.cells(Row,7)=objEquip.EQModelDR_MDesc;
	    Row=Row+1;
	    xlsheet.cells(Row,3)=objEquip.EQManuFactoryDR_MFName;
	    xlsheet.cells(Row,7)=objEquip.EQLeaveFactoryNo;
	    Row=Row+1;
	    xlsheet.cells(Row,3)=GetShortName(objEquip.EQProviderDR_VName,"-");
	    xlsheet.cells(Row,7)=FormatDate(objEquip.EQLeaveFactoryDate,"","");
	    Row=Row+1;
	    xlsheet.cells(Row,3)=objEquip.EQOriginalFee;
	    xlsheet.cells(Row,7)=objEquip.EQHold10_EDesc;
	    Row=Row+1;
	    xlsheet.cells(Row,3)=objEquip.EQStatCatDR_SCDesc;
	    xlsheet.cells(Row,7)=FormatDate(objEquip.EQStartDate,"","");
	    Row=Row+1;
	    xlsheet.cells(Row,3)=objEquip.EQRemark;
	    
		//add by zx 2018-12-18��ӡʱ�䴦��
		var encmeth=getElementValue("GetCurDate");
		if(encmeth)
		{
			var curTime=cspRunServerMethod(encmeth);
		}
		else
		{
			var mydate = new Date();
			var curTime=mydate.getFullYear()+"-"+(mydate.getMonth()+1)+"-"+mydate.getDate();
		}
		Row=Row+1;
	    xlsheet.cells(Row,8)=xlsheet.cells(Row,8)+FormatDate(curTime,"","");
	    	    
	    xlApp.Visible=true
		xlsheet.PrintPreview();
		xlsheet.cells(1,8)="��";
		xlsheet.PrintPreview();
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	}
	catch(e)
	{	 alertShow(e.message);	 }
	
	return;	
}
//Modefied by zc0044 2018-11-22  ��ӡ��Ƭ����
function PrintEQCardVerso(rowid)
{
	PrintEQCardVersoZGYDYY(rowid);
}
function PrintEQCardVersoZGYDYY(rowid)
{
	var pageRows=14;
	var row,page;
	var	Template=getElementValue("GetRepPath")+"DHCEQCardVerso.xls";
	var encmeth=getElementValue("GetAffixInfo")
	var result=cspRunServerMethod(encmeth,rowid);
	if (rowid=="")
	{
		messageShow('alert','error','��ʾ','û���ҵ��豸��Ϣ!','','','');
		return;
	}
	var page=1;
	var row=1;
	try 
    {
        var xlApp,xlsheet,xlBook
	    xlApp = new ActiveXObject("Excel.Application");
	    //print affix info
	    if (result!="")
		{
			var rowinfos=result.split("&");
			var rows=rowinfos.length;
			for (i=0;i<rows;i++)
	    	{
		    	row=row+1;
		    	if (row>pageRows) 
		    	{
			    	xlsheet.printout; //��ӡ���
	    			xlBook.Close (savechanges=false);	    
	   				xlsheet.Quit;
	    			xlsheet=null;
			    	row=2;			    	
		    	}
		    	if (2==row)
		    	{
		    		xlBook = xlApp.Workbooks.Add(Template);
	    			xlsheet = xlBook.ActiveSheet;
	    			row=row+2;	   
	    		}
		    	
		    	var sort=18;
		    	var colinfo=rowinfos[i].split("^");
		    	xlsheet.cells(row,2)=i+1;
		    	xlsheet.cells(row,3)=colinfo[3];	// Mozy0058	2011-8-16
		    	xlsheet.cells(row,4)=colinfo[4];		    	
		    	xlsheet.cells(row,5).NumberFormatLocal = "@";
		    	xlsheet.cells(row,5).HorizontalAlignment=1; //�������
		    	xlsheet.cells(row,5)=colinfo[sort+19];		// Mozy		2017-10-9	461053
		    	xlsheet.cells(row,6)=colinfo[6];
		    	xlsheet.cells(row,7).NumberFormatLocal = "0.00_ ";
		    	xlsheet.cells(row,7)=colinfo[10];
	    	}
    	}

	    var encmeth=getElementValue("GetChangeAccount")
		var result=cspRunServerMethod(encmeth,rowid);
	    if (result!="")
		{
			row=row+1;
			if (row>pageRows)
			{
				xlsheet.printout; //��ӡ���
	    		xlBook.Close (savechanges=false);	    
	   			xlsheet.Quit;
	    		xlsheet=null;
			    row=2;
			    xlBook = xlApp.Workbooks.Add(Template);
	    		xlsheet = xlBook.ActiveSheet;			
			}
			if (!xlsheet)
			{
				xlBook = xlApp.Workbooks.Add(Template);
	    		xlsheet = xlBook.ActiveSheet;
			}
			xlsheet.Range(xlsheet.Cells(row,2),xlsheet.Cells(row,7)).mergecells=true;//�ϲ���Ԫ�� 
			//xlsheet.Range(xlsheet.Cells(row,2),xlsheet.Cells(row,7)).Borders(8).Weight = 4;	
			
			xlsheet.cells(row,2)="�豸���˼�¼";
			xlsheet.cells(row,2).HorizontalAlignment=3; //���ж���
			xlsheet.cells(row,2).Font.Bold = true;  // ����
			xlsheet.cells(row,2).Font.Size=14;
			row=row+1;
			xlsheet.Range(xlsheet.Cells(row,2),xlsheet.Cells(row,7)).HorizontalAlignment=3; //���ж���
			xlsheet.cells(row,2)="���";
			xlsheet.cells(row,3)="��ǰԭֵ";
			xlsheet.cells(row,4)="��������";
			xlsheet.cells(row,5)="�������";
			xlsheet.cells(row,6)="����ԭ��";
			xlsheet.cells(row,7)="����ԭֵ";
	    			
			var rowinfos=result.split("&");
			var rows=rowinfos.length;
			for (i=0;i<rows;i++)
	    	{
		    	row=row+1;
		    	if (row>pageRows) 
		    	{
			    	xlsheet.printout; //��ӡ���
	    			//xlBook.SaveAs("D:\\Return"+i+".xls");   //lgl+
	    			xlBook.Close (savechanges=false);	    
	   				xlsheet.Quit;
	    			xlsheet=null;
			    	row=2;			    	
		    	}
		    	if (2==row)
		    	{
		    		xlBook = xlApp.Workbooks.Add(Template);
	    			xlsheet = xlBook.ActiveSheet;
					xlsheet.Range(xlsheet.Cells(row,2),xlsheet.Cells(row,7)).mergecells=true;//�ϲ���Ԫ�� 
					xlsheet.cells(row,2)="�豸���˼�¼";
					xlsheet.cells(row,2).HorizontalAlignment=3; //���ж���
					xlsheet.cells(row,2).Font.Bold = true;  // ����
					xlsheet.cells(row,2).Font.Size=14;
					row=row+1;
					xlsheet.cells(row,2)="���";
					xlsheet.cells(row,3)="��ǰԭֵ";
					xlsheet.cells(row,4)="��������";
					xlsheet.cells(row,5)="�������";
					xlsheet.cells(row,6)="����ԭ��";
					xlsheet.cells(row,7)="����ԭֵ";
					row=row+1;
			    }
		    	
		    	var sort=27;
		    	var colinfo=rowinfos[i].split("^");
		    	xlsheet.cells(row,2)=i+1;
		    	xlsheet.cells(row,3).HorizontalAlignment=1; //���Ҷ���
		    	xlsheet.cells(row,3)=colinfo[23];
		    	xlsheet.cells(row,4).HorizontalAlignment=1; //���Ҷ���
		    	xlsheet.cells(row,4)=colinfo[8];		    	
		    	xlsheet.cells(row,5).NumberFormatLocal = "0.00_ ";
		    	xlsheet.cells(row,5)=colinfo[1];
		    	xlsheet.cells(row,6).HorizontalAlignment=2; //�������
		    	xlsheet.cells(row,6)=colinfo[7];
		    	xlsheet.cells(row,7).NumberFormatLocal = "0.00_ ";
		    	xlsheet.cells(row,7)=colinfo[2];
	    	}
    	}
	    
	    //Ԥ��
	    if (!xlsheet)
	    {
			xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    }
	    xlApp.Visible=true
		xlsheet.PrintPreview();
		xlApp.Visible=true;// 20150902 �ڶ��δ�ӡ
		xlsheet.PrintPreview();

	    //xlBook.SaveAs("D:\\cgeqipsq.xls");
	    xlsheet.Quit;
	    xlsheet=null;
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;	    
	}
	catch(e)
	{	 alertShow(e.message);	 }
	
	return;	
}
function printBarStandard(barType, equipRowID, objDisUse, objAffix, BarMark)
{
	if (equipRowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip", equipRowID);
	var jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow('alert','error','��ʾ',jsonData.Data,'','','');return;}
	var objEquip=jsonData.Data;
	if (objEquip.EQRowID=="")
	{
		messageShow('alert','error','��ʾ','û���ҵ��豸��Ϣ!','','','');
		return;
	}
	
	var Listall=tkMakeServerCall("web.DHCEQCBarInfo","GetPrintBarInfo", equipRowID, "", barType);
	if (Listall=="")
	{
		alertShow("�豸��Ϣ������������Ϣ��Ч,��˶�!");
		return;
	}
	var Lists=Listall.split(getElementValue("SplitRowCode"));
	var NewString="";
	var InfoList=Lists[0].split("^");
	for (var i=1;i<Lists.length;i++)
	{
		// 1^0^^����^��׼��ά��������ӡ^����^16^N^^^N^60^150^^^N^^^^N^^^30^^^^^$CHAR(3)1^0^������ʾϵͳ^�豸����^����:^����^8^N^1^^N^^^^^N^^^^N^^^30^^^^^$CHAR(3)1^0^3222299001100^�豸���^���:^����^8^N^2^^N^^^^^N^^^^N^^^30^^^^^$CHAR(3)1^0^\sd^����ͺ�^�ͺ�:^����^8^N^3^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^��ͨ���칫˾^��������^����:^����^8^N^4^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^CCBH2019020201^�������^SN��:^����^8^N^5^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^2019-02-02^��������^����:^����^8^N^6^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^X����^ʹ�ÿ���^����:^����^8^N^7^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^210C��^��ŵص�^���:^����^8^N^8^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^������׼�����ֻ�ҽԺ[��Ժ]^ҽԺ����^ҽԺ:^����^8^N^9^^N^^^^^N^^^^N^^^16^^^^^$CHAR(3)1^0^6300.00^ԭֵ^ԭֵ:^����^8^N^10^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^1^^^^^^N^^^N^1400^500^^^N^1400^1900^^N^^����1^4^^^^^
		var DetailList=Lists[i].split("^");
		//alertShow(DetailList[20])
		// ��������Ԫ��
		if (DetailList[19]!="Y")
		{
			if (DetailList[2]!="")
			{
				// ��ֵ��ʽ��
				if (DetailList[20]!="")
				{
					var tmpValue=ColFormat(objEquip[DetailList[2]],DetailList[20]);
					Lists[i]=DetailList[0]+"^"+DetailList[1]+"^"+tmpValue;
					//alertShow(objEquip[DetailList[2]]+"->"+tmpValue)
					for (var j=3;j<DetailList.length;j++)
					{
						Lists[i]=Lists[i]+"^"+DetailList[j];
					}
				}
				else
				{
					if (objEquip[DetailList[2]]!=undefined)
					{
						Lists[i]=Lists[i].replace("^"+DetailList[2]+"^","^"+objEquip[DetailList[2]]+"^");
					}
					else if (objDisUse[DetailList[2]]!=undefined)
					{
						Lists[i]=Lists[i].replace("^"+DetailList[2]+"^","^"+objDisUse[DetailList[2]]+"^");
					}
					else if (objAffix[DetailList[2]]!=undefined)
					{
						Lists[i]=Lists[i].replace("^"+DetailList[2]+"^","^"+objAffix[DetailList[2]]+"^");
					}
				}
			}
			if (NewString!="") NewString=NewString+getElementValue("SplitRowCode");
			NewString=NewString+Lists[i];
		}
	}
	//��ǩ����Ϣ
	var TempCode="";
	if (BarMark=="")
	{
		if (InfoList[20]!="")
		{
			if (objEquip[InfoList[20]]!=undefined)
			{
				BarMark=objEquip[InfoList[20]];
			}
			else if (objDisUse[InfoList[20]]!=undefined)
			{
				BarMark=objDisUse[InfoList[20]];
			}
			else if (objAffix[InfoList[20]]!=undefined)
			{
				BarMark=objAffix[InfoList[20]];
			}
		}
	}
	//alert(BarMark)
	if (BarMark!="")
	{
		//Lists[0]=Lists[0]+BarMark;
		//ÿ���߸����� 17+3*4,������
		var type=0;
		var qrcode="";
		if (InfoList[19]==0)
		{
			type=getTypeNumber(BarMark,QRErrorCorrectLevel.M);
			qrcode = new QRCode(type, QRErrorCorrectLevel.M);
		}
		if (InfoList[19]==1)
		{
			type=getTypeNumber(BarMark,QRErrorCorrectLevel.L);
			qrcode = new QRCode(type, QRErrorCorrectLevel.L);
		}
		if (InfoList[19]==2)
		{
			type=getTypeNumber(BarMark,QRErrorCorrectLevel.H);
			qrcode = new QRCode(type, QRErrorCorrectLevel.H);
		}
		if (InfoList[19]==3)
		{
			type=getTypeNumber(BarMark,QRErrorCorrectLevel.Q);
			qrcode = new QRCode(type, QRErrorCorrectLevel.Q);
		}
		//var valueStr=(objEquip.EQFileNo=="")?objEquip.EQNo:"fileno:"+objEquip.EQFileNo+",no:"+objEquip.EQNo;
		var ValueStr=utf16to8(BarMark);
		qrcode.addData(ValueStr);
		qrcode.make();
		for (var i=0;i<qrcode.modules.length;i++)
		{
			for (var j=0;j<qrcode.modules.length;j++)
			{
				TempCode+=String(Number(qrcode.modules[i][j]))
			}
		}
	}
	if (getElementValue("ChromeFlag")=="1")
	{
		var Str ="(function test(x){"
		Str +="var Bar=new ActiveXObject('EquipmentBar.PrintBar');"
		Str +="Bar.SplitRowCode='"+getElementValue("SplitRowCode")+"';"			// Mozy003002	2020-03-18	�������÷���
		Str +="Bar.BarInfo='"+Lists[0]+"';"	// ��ά��������ӡ-�Ϸ�ҽԺ^1^60^500^0^2^2^3500^2000^1350^200^����^10^Y^0^160^600^1200^0^3^EQNo^0^520^0^Y^tiaoma^2^N^10248^65285^42428^^^^^^^��׼��ά��^3222299001100
		Str +="Bar.BarDetail='"+NewString+"';"
		Str +="Bar.QRCode='"+TempCode+"';"
		Str +="Bar.PrintOut('1');"
		Str +="return 1;}());";
		
		CmdShell.notReturn =0;   			//�����޽������,����������
		var rtn = CmdShell.EvalJs(Str);		//ͨ���м�����д�ӡ����
	}
	else
	{
		var Bar=new ActiveXObject("EquipmentBar.PrintBar");
		Bar.SplitRowCode=getElementValue("SplitRowCode");			// Mozy003002	2020-03-18	�������÷���
		Bar.BarInfo=Lists[0];	// ��ά��������ӡ-�Ϸ�ҽԺ^1^60^500^0^2^2^3500^2000^1350^200^����^10^Y^0^160^600^1200^0^3^EQNo^0^520^0^Y^tiaoma^2^N^10248^65285^42428^^^^^^^��׼��ά��^3222299001100
		Bar.BarDetail=NewString;
		Bar.QRCode=TempCode;
		Bar.PrintOut("1");
	}
	
	//�Ǽ��Ѵ�ӡ�����־-������
	var OperateLog=""
	var OperateLog=OperateLog+"^52"
	var OperateLog=OperateLog+"^"+equipRowID;
	var OperateLog=OperateLog+"^";
	var OperateLog=OperateLog+"^";
	var OperateLog=OperateLog+"^0";
	tkMakeServerCall("web.DHCEQ.Plat.BUSOperateLog","SaveData",OperateLog,"2");
}

//czf 2022-01-24 Lodop��ӡ
function printCardLodop(objEquip)
{
	///modify by mwz 20220126 mwz0058 
	var CardPrintModel=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","402002")
	CardPrintModel=Math.abs(CardPrintModel)
	for (var i=0;i<(CardPrintModel+1);i++)  
	{
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCEQCard");
		var LODOP = getLodop();
		var c2=String.fromCharCode(2);
		var CardFont="��";
		if (i!=0) CardFont="��"
		var inpara="CardFont"+c2+CardFont;
		inpara+="^EQNo"+c2+objEquip.EQNo;
		inpara+="^EQFileNo"+c2+objEquip.EQFileNo;
		inpara+="^EQName"+c2+objEquip.EQName;
		inpara+="^EQOriginalFee"+c2+objEquip.EQOriginalFee;
		inpara+="^EQCountry"+c2+objEquip.EQCountryDR_CTCOUDesc;
		inpara+="^EQNum"+c2+"1";
		inpara+="^EQModel"+c2+objEquip.EQModelDR_MDesc;
		inpara+="^EQPurposeType"+c2+objEquip.EQPurposeTypeDR_PTDesc;
		inpara+="^EQLeaveFactoryNo"+c2+objEquip.EQLeaveFactoryNo;
		inpara+="^EQOrigin"+c2+objEquip.EQOriginDR_ODesc;
		inpara+="^EQManufacturer"+c2+objEquip.EQManuFactoryDR_MFName;
		inpara+="^EQContractNo"+c2+objEquip.EQContractNo;
		inpara+="^EQProvider"+c2+GetShortName(objEquip.EQProviderDR_VName,"-");
		inpara+="^EQTransAssetDate"+c2+objEquip.EQTransAssetDate;
		inpara+="^EQUseLoc"+c2+GetShortName(objEquip.EQStoreLocDR_CTLOCDesc,"-");
		inpara+="^EQStartDate"+c2+objEquip.EQStartDate;
		inpara+="^EQRemark"+c2+objEquip.EQRemark;
		inpara+="^PrintDate"+c2+GetCurrentDate(2);
		DHC_PrintByLodop(LODOP,inpara,"","","",{printListByText:true});
    }
}

//czf 2022-01-24 Lodop��ӡ
function printCardVersoLodop(rowid)
{
	if (rowid=="")
	{
		messageShow('alert','error','��ʾ','û���ҵ��豸��Ϣ!','','','');
		return;
	}
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEQCardVerso");
	var LODOP = getLodop();
	var c2=String.fromCharCode(2);
	var inpara="PrintUser"+c2+curUserName;
	inpara+="^PrintDate"+c2+GetCurrentDate(2);
	var inlist="";
	
	var result=tkMakeServerCall("web.DHCEQAffix","GetAffixsInfoByEquip",rowid)
	if (result!="")
	{
		var rowinfos=result.split("&");
		var rows=rowinfos.length;
		for (i=0;i<rows;i++)
    	{
	    	var sort=18;
	    	var colinfo=rowinfos[i].split("^");
	    	inlist+=i+1;
	    	inlist+="^"+colinfo[3];
	    	inlist+="^"+colinfo[4];	
	    	inlist+="^"+colinfo[6];	 
	    	inlist+="^"+colinfo[10];   	
	    	inlist+="^"+colinfo[sort+19];
	    	if(i<rows-1) inlist+=c2;
    	}
    	
	}
	DHC_PrintByLodop(LODOP,inpara,inlist,"","",{printListByText:true});
}
