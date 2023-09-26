///DHCOPBillDailyCollect.js
guser=session['LOGON.USERID'];
hospDr=session['LOGON.HOSPID'];
username=session['LOGON.USERNAME'];
function BodyLoadHandler(){

	var Printobj=document.getElementById("Print");
	if(Printobj)
	{
	Printobj.onclick=Print;
	}
	var printdailyobj=document.getElementById("printdaily");
	if(printdailyobj)
	{
	printdailyobj.onclick=printdaily;
	}
	
	websys_$('guser').value=session['LOGON.USERID'];
}
///
///�����շ��ձ�
function printdaily()
{
	var stDate=websys_$V('stDate');
	var endDate=websys_$V('endDate');
	var guser=session['LOGON.USERID']
	var hospDr=session['LOGON.HOSPID'];
	//alert(stDate+","+endDate+","+guser+","+hospDr);
	var str=tkMakeServerCall("web.DHCOPBillDailyCollect","GetDailyReportData",stDate,endDate,guser,hospDr);
    //alert(str);
	Data=str.split("#");
	var path=tkMakeServerCall("web.DHCOPBillDailyCollect","GetPath","","");
    var Template=path+"DHCOPBill_DailyACRep.xls"
	//var Template="d:\\DHCOPBill_DailyACRep.xls"
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet
	
	xlsheet.cells(26,4).value=guser
	xlsheet.cells(3,6).value=stDate+"--"+endDate;
	xlsheet.cells(27,7).value=websys_$V('printDate')	
	xlsheet.cells(23,8).value=Data[0]   //��Ԥ����
	xlsheet.cells(23,3).value=Data[1]   //��Ԥ���� 
	//xlsheet.cells(2,8).value=Data[2]  //Ԥ����ϼ�
	xlsheet.cells(5,3).value=Data[3]    //ʵ�պϼ�
	xlsheet.cells(9,3).value=Data[4]    //ҽ���ϼ�
	xlsheet.cells(24,3).value=Data[7]    //���������Ԥ����
	var BLBNumSum=eval(Data[8])+eval(+websys_$V('BLBNum'))  //��ѯ����+��¼����
	xlsheet.cells(26,3).value="����������:"+BLBNumSum   //����������
	//֧����ʽ
	var payMStr=Data[5].split("!")
	for(var i=1;i<payMStr.length;i++){
		var tmpPayMCode=payMStr[i].split("^")[0];
		var tmpPayMAmt=payMStr[i].split("^")[1];
		switch(tmpPayMCode){
			case "CASH":  //�ֽ�
			    xlsheet.cells(6,3).value=tmpPayMAmt;
				break; 
			case "ZP":    //֧Ʊ
			    xlsheet.cells(7,3).value=tmpPayMAmt;
				break;
			case "YHK":   //���п�
			    xlsheet.cells(8,3).value=tmpPayMAmt;
			    break;
		    case "BYB":    //��ҽ��ͳ��
		        xlsheet.cells(10,3).value=tmpPayMAmt;
				break;
			case "ZHZFB":  //���˻�֧��
			    xlsheet.cells(11,3).value=tmpPayMAmt;
			    break;
			case "YLJM":   //��ҽ�Ƽ���
			    xlsheet.cells(12,3).value=tmpPayMAmt;
				break;
			case "YLBZ":   //��ҽ�Ʋ���
			    xlsheet.cells(13,3).value=tmpPayMAmt;
				break;
			case "AYB":    //ʡҽ��ͳ��
			    xlsheet.cells(14,3).value=tmpPayMAmt;
				break;
			case "ZHZFA":   //ʡ�˻�֧��
			    xlsheet.cells(15,3).value=tmpPayMAmt;
				break;	
		}
	}
	
	//��Ʒ���
	var ACCateAry=Data[6].split("!");
	//alert(ACCateAry);
	// ��Ԥ���� # ��Ԥ���� #  Ԥ����ϼ� # ʵ�պϼ� # ҽ���ϼ� # ֧����ʽ�� # ��Ʒ��മ
   //123310.3#-465.9#122844.4#122844.4#0#!CASH^122614!YHK^230.4#!2^0^0^0!��ҩ��^13025.19^0^13025.19!�г�ҩ��^148.8^0^148.8!�в�ҩ��^0^0^0!��λ��^0^0^0!���Ʒ�^160^0^160!����^794^0^794!���Ʒ�^646.04^0^646.04!������^0^0^0!�����^1660^0^1660!�����^0^0^0!����^15^0^15!����^0^0^0!�Һŷ�^761.01^0^761.01!��ʳ��^0^0^0!�� ��^17210.04^0^0
	for(var i=1;i<ACCateAry.length;i++){
		var tmpACDesc=ACCateAry[i].split("^")[0]
		var tmpAmt=ACCateAry[i].split("^")[1]
		var tmpYBAmt=ACCateAry[i].split("^")[2]
		var tmpAmtSum=ACCateAry[i].split("^")[3]
		switch(tmpACDesc){
			case "��λ��":
			     xlsheet.cells(7,6).value=tmpAmt;
			     xlsheet.cells(7,7).value=tmpYBAmt;
			     xlsheet.cells(7,8).value=tmpAmtSum;
				break;
			case "���Ʒ�":
			     xlsheet.cells(8,6).value=tmpAmt;
			     xlsheet.cells(8,7).value=tmpYBAmt;
			     xlsheet.cells(8,8).value=tmpAmtSum;
				break;
			case "����":
			     xlsheet.cells(9,6).value=tmpAmt;
			     xlsheet.cells(9,7).value=tmpYBAmt;
			     xlsheet.cells(9,8).value=tmpAmtSum;
				break;
			case "���Ʒ�":
			     xlsheet.cells(10,6).value=tmpAmt;
			     xlsheet.cells(10,7).value=tmpYBAmt;
			     xlsheet.cells(10,8).value=tmpAmtSum;
				break
			case "������":
			     xlsheet.cells(11,6).value=tmpAmt;
			     xlsheet.cells(11,7).value=tmpYBAmt;
			     xlsheet.cells(11,8).value=tmpAmtSum;
				break;
			case "�����":
			     xlsheet.cells(12,6).value=tmpAmt;
			     xlsheet.cells(12,7).value=tmpYBAmt;
			     xlsheet.cells(12,8).value=tmpAmtSum;
				break;
			case "�����":
			     xlsheet.cells(13,6).value=tmpAmt;
			     xlsheet.cells(13,7).value=tmpYBAmt;
			     xlsheet.cells(13,8).value=tmpAmtSum;
				break;
			case "����":
			     xlsheet.cells(14,6).value=tmpAmt;
			     xlsheet.cells(14,7).value=tmpYBAmt;
			     xlsheet.cells(14,8).value=tmpAmtSum;
				break;
			case "����":
			     xlsheet.cells(15,6).value=tmpAmt;
			     xlsheet.cells(15,7).value=tmpYBAmt;
			     xlsheet.cells(15,8).value=tmpAmtSum;
				break;
			case "�Һŷ�":
			     xlsheet.cells(16,6).value=tmpAmt;
			     xlsheet.cells(16,7).value=tmpYBAmt;
			     xlsheet.cells(16,8).value=tmpAmtSum;
				break;
			case "��ʳ��":
			     xlsheet.cells(17,6).value=tmpAmt;
			     xlsheet.cells(17,7).value=tmpYBAmt;
			     xlsheet.cells(17,8).value=tmpAmtSum;
				break;
			case "��ҩ��":
			     xlsheet.cells(19,6).value=tmpAmt;
			     xlsheet.cells(19,7).value=tmpYBAmt;
			     xlsheet.cells(19,8).value=tmpAmtSum;
				break;
			case "�г�ҩ��":
			     xlsheet.cells(20,6).value=tmpAmt;
			     xlsheet.cells(20,7).value=tmpYBAmt;
			     xlsheet.cells(20,8).value=tmpAmtSum;
				break;
			case "�в�ҩ��":
			     xlsheet.cells(21,6).value=tmpAmt;
			     xlsheet.cells(21,7).value=tmpYBAmt;
			     xlsheet.cells(21,8).value=tmpAmtSum;
				break;
			case "�� ��":
			     xlsheet.cells(22,6).value=tmpAmt;
			     xlsheet.cells(22,7).value=tmpYBAmt;
			     xlsheet.cells(22,8).value=tmpAmtSum;
				break;
		}	
	}

	xlApp.Visible=true;
	xlsheet.PrintPreview();
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null;
}
//2010-11-25
//wuboshi
//��ӡ�����ձ�����
function Print()
{
	GetNum();
	var stDate=websys_$V('stDate');
	var endDate=websys_$V('endDate');
	var tsData =new Array()
	for (num;num>0;num--)
	{	
	var Objtbl=document.getElementById('tDHCOPBillDailyCollect');
	var SelRowObj=document.getElementById('Tjobz'+1);
    job=SelRowObj.innerText;
    //job=SelRowObj.value;//?ȡjob
	var str=tkMakeServerCall("web.DHCOPBillDailyCollect","GetData",guser,job,num);
		//alert(str)
		tsData[num] = str.split("^");//����tsData�A��^�ָ�
	}
    //GetPath();
    var path=tkMakeServerCall("web.DHCOPBillDailyCollect","GetPath","","");
    //alert(path);
    var Template=path+"DHCOPBillDailyCollect.xls"
	//var Template="d:\DHCOPBillDailyCollect.xls"
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet
	
	temp=tsData.join("!")
	vbdata=temp.split("!")
	
	for (i=0;i<=vbdata.length-1;i++)
	{   
	    str=vbdata[i].split(",")
	    for (j=1;j<=str.length-5;j++)
	    {    
	    	xlsheet.cells(i+4,j)=str[j]    	      
	    }
	
	}
		//alert(str)
		//return
		xlsheet.cells(5+vbdata.length-1,11).value="�Ʊ��ˡG"+username
		xlsheet.cells(2,3).value=stDate
		xlsheet.cells(2,7).value=endDate //ʱ��
		xlsheet.cells(2,11).value=websys_$V('printDate')
		//xlsheet.cells(2,8).value=str[19]

    //�����
    var hrow=vbdata.length
    //alert(vbdata.length)
    //alert(str.length)
	var lrow=str.length-5
	Grid(xlsheet,3,1,hrow,lrow) 	
	
	xlApp.Visible=true;
	xlsheet.PrintPreview();
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null;
	}
function GetNum()
{
	var Objtbl=document.getElementById('tDHCOPBillDailyCollect');
	var SelRowObj=document.getElementById('Tjobz'+1);
    job=SelRowObj.innerText;
    //job=SelRowObj.value;//?ȡjob
    //alert(job)
    
	var str=tkMakeServerCall("web.DHCOPBillDailyCollect","GetNum","","",guser,job);
    str=str.split("^")
    //alert(str)
    num=str[0]//�õ�??��
}
function GetPath() {
	var path=tkMakeServerCall("web.DHCOPBillDailyCollect","GetPath","","");
	//return path;
	//alert(path);
}
function Grid(objSheet,xlsTop,xlsLeft,hrow,lrow)
{   
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(1).LineStyle=1 ;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(2).LineStyle=1;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(3).LineStyle=1 ;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(4).LineStyle=1 ;
}
function UserLookUp(value){
	//alert(value)
	var Info=value.split("^")//��?��ȡֵ�F�ָ���
	document.getElementById("guserDr").value=Info[0]
	document.getElementById("CashierName").value=Info[2]//����
	//alert(Info[2])
}
function FormatDate(value)
{
	var curdate=value;
	var str=curdate.split("/")
	curdate=str[2]+"-"+str[1]+"-"+str[0]
	return curdate
}
document.body.onload = BodyLoadHandler;