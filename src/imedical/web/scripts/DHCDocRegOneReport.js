
document.body.onload = BodyLoadHandler;
function BodyLoadHandler(){
	
	var obj=document.getElementById('Report');
	if (obj){obj.onclick=Report;}
	var obj=document.getElementById('RegUser');
	if (obj){obj.onkeydown=RegIDChange;}
	var obj=document.getElementById('RegUser');
	if (obj){obj.value=session['LOGON.USERNAME'];}
	var ObjRegID=document.getElementById('RegID');
	if (ObjRegID){ObjRegID.value=session['LOGON.USERID'];}
	
}

function RegIDChange()
{	var obj=document.getElementById('RegUser');
	if (obj){
		if (obj.value="")
		{var ObjRegID=document.getElementById('RegID');
		if (ObjRegID){ObjRegID.value="";}
		}
	
	}
}
function Report()
{
	var UserID="";
	var Obj=document.getElementById('UserID');
	if (Obj){UserID=Obj.value};
	if (UserID==""){alert("ȱ���û�;");return;}
	var ReturnNo=tkMakeServerCall("web.DHCOPRegReports","GetOneRepInfo",UserID,"",1);
	if (ReturnNo==""){alert("ȱ�ٴ�������,���Ȳ�ѯ!");return;}
	try {  
		var TemplatePath=""
		TemplatePath=tkMakeServerCall("web.UDHCJFCOMMON","getpath","","")
        var xlApp,xlsheet,xlBook
	    Template=TemplatePath+"DHCDocRegOneReport.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0; 
	    xlsheet.PageSetup.RightMargin=0;
	    var xlsrow=3; //����ָ��ģ��Ŀ�ʼ����λ��
		var xlsCurcol=0;  //����ָ����ʼ������λ��
		var BaseMessage="";
		var Type="";
		var DateStr="";
		var UserNameGet="";
		var DateGet=""
		
	for (var i=1;i<=ReturnNo;i++)
	{
	var MessageStr=tkMakeServerCall("web.DHCOPRegReports","GetOneRepInfo",UserID,i,2);
	if (MessageStr=="") continue;

	if (BaseMessage=="")
	{
		BaseMessage=MessageStr.split("@")[0].split("^");
		var JZ=BaseMessage[0];
		var TX=BaseMessage[1];
		var MZ=BaseMessage[2];
		var STDate=BaseMessage[3];
		var EndDate=BaseMessage[4];
		var RegName=BaseMessage[5];
		UserNameGet=BaseMessage[6];
		DateGet=BaseMessage[7];
		DateStr=STDate+"-"+EndDate
		if (JZ=="on"){if (Type==""){Type=Type+"����"}}
		if (TX=="on"){if (Type==""){Type=Type+"����"}else{Type=Type+"/����"}}
		if (MZ=="on"){if (Type==""){Type=Type+"����"}else{Type=Type+"/����"}}
		xlsheet.cells(xlsrow-1,xlsCurcol+3)=Type;
		xlsheet.cells(xlsrow-1,xlsCurcol+10)=DateStr;
		
	}
	var Str=MessageStr.split("@")[1].split("^");
	xlsrow=xlsrow+1;	 //�ӵ����п�ʼ
	var NO=Str[0];
	var UserName=Str[1];
	var StrType=Str[2]
	var AllRegNo=Str[3];
	var YXGH=Str[4];
	var BYZGYB=Str[5];
	var THS=Str[6];
	var TBR=Str[7];
	var TTR=Str[8];
	var SumFee=Str[9];
	var THFee=Str[10];
	var JKFee=Str[11];
	var YBF=Str[12];
	var YBNO=Str[13];
	var YBN=Str[14];
	var ZFN=Str[15];
	var THZF=Str[16];
	var THYB=Str[17];
	var OutDateReturnNO=Str[18];
	var MRFee=Str[19];
	var CardFee=Str[20];
	var RegFee=Str[21];
	var CheckFee=Str[22];
	var ReCheckFee=Str[23];
	var AppFee=Str[24];
	var HoliFee=Str[25];
	var OtherFee=Str[26];
	
	xlsheet.cells(xlsrow,xlsCurcol+1)=NO; 
	xlsheet.cells(xlsrow,xlsCurcol+2)=StrType; 
	xlsheet.cells(xlsrow,xlsCurcol+3)=AllRegNo; 
	xlsheet.cells(xlsrow,xlsCurcol+4)=THS; 
	xlsheet.cells(xlsrow,xlsCurcol+5)=YXGH;
	xlsheet.cells(xlsrow,xlsCurcol+6)=SumFee; 
	xlsheet.cells(xlsrow,xlsCurcol+7)=THFee; 
	xlsheet.cells(xlsrow,xlsCurcol+8)=JKFee; 
	xlsheet.cells(xlsrow,xlsCurcol+9)=MRFee;
	xlsheet.cells(xlsrow,xlsCurcol+10)=RegFee; 
	xlsheet.cells(xlsrow,xlsCurcol+11)=CheckFee; 
	xlsheet.cells(xlsrow,xlsCurcol+12)=OtherFee;

	}
	gridlist(xlsheet,4,xlsrow,1,12)  //�˴��ǻ�������
	xlsrow=xlsrow+1;
	xlsheet.cells(xlsrow,xlsCurcol+2)="����:";
	xlApp.Range('C'+xlsrow+":"+'D'+xlsrow).Select();
	xlApp.Selection.Merge();
	xlsheet.cells(xlsrow,xlsCurcol+3)=DateGet; 
	xlsheet.cells(xlsrow,xlsCurcol+10)="ǩ��:" 
	alert(session['LOGON.USERNAME']);
	xlsheet.cells(xlsrow,xlsCurcol+11)=session['LOGON.USERNAME'];
	
	var d=new Date();
	var h=d.getHours();
	var m=d.getMinutes();
	var s=d.getSeconds();
	var Obj=document.getElementById("CheckReport");
	if (Obj){
		if (Obj.checked){
				alert("�ļ�������������C�̸�Ŀ¼��");
				xlBook.SaveAs("C:\\�ҺŸ���ͳ�Ʊ���"+h+m+s+".xls");
		}else{xlBook.Printout;}
	}
	else{
			xlBook.Printout;
		} 
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet.Quit;
	xlsheet=null;
	}
catch(e) {alert(e.message);};


}
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}

	
	

function uselook(str) {	
	var obj=document.getElementById('RegID');
	var tem=str.split("^");
	obj.value=tem[1];
	
}
