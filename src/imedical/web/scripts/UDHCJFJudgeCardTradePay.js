/////UDHCJFJudgeCardTradePay.js

function BodyLoadHandler()
{
	//ChooseTime()
	GetNowTime()
	ChooseBank()
	var Exportobj=document.getElementById("Export")
	if(Exportobj){
		Exportobj.onclick=Export_Click
	}
	
	var Importobj=document.getElementById("Import")
	if(Importobj){
		Importobj.onclick=Import_Click
	}
	
	var PrintBtnobj=document.getElementById("PrintBtn")
	if(PrintBtnobj){
		PrintBtnobj.onclick=PrintBtn_Click
	}
	
	var Processobj=document.getElementById("Process")
	if(Processobj){
		Processobj.onclick=Process_Click
	}
}

function ChooseTime()
{
	//��ʼ����������
	var obj=document.getElementById("TimeFlag");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=TimeFlag_OnChange;
	}	
	var varItem = new Option("HIS����ʱ��","1");
    obj.options.add(varItem);
    var varItem = new Option("���н���ʱ��","2");
    obj.options.add(varItem);
    //var varItem = new Option("���н���ʱ��","3");
    //obj.options.add(varItem);
}

function TimeFlag_OnChange()
{
	var obj=document.getElementById("TimeFlag");
	var index=obj.options.selectedIndex
	obj.options[index].selected = true;
}

function ChooseBank()
{
	//��ʼ��֧����ʽ
	var obj=document.getElementById("ChooseBankId");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=BankId_OnChange;
	}	
	var varItem = new Option("ȫ��","99");
    obj.options.add(varItem);
    var varItem = new Option("�й���������","01");
    obj.options.add(varItem);
    var varItem = new Option("�й�ũҵ����","02");
    obj.options.add(varItem);
    var varItem = new Option("�й�����","03");
    obj.options.add(varItem);
    var varItem = new Option("�й���������","04");
    obj.options.add(varItem);
    obj=null
}

function BankId_OnChange()
{
	var obj=document.getElementById("ChooseBankId");
	var index=obj.options.selectedIndex
	obj.options[index].selected = true;
}

function GetNowTime()
{
	var NowTimeobj=document.getElementById("GetNowTime");
		if (NowTimeobj){
			var encmeth=NowTimeobj.value;
			var NowTimeStr=cspRunServerMethod(encmeth)
		}
		if(NowTimeStr!=""){
			var StTimeobj=document.getElementById("StTime");
			var EndTimeobj=document.getElementById("EndTime");
			StTimeobj.value=NowTimeStr.split("^")[0]
			EndTimeobj.value=NowTimeStr.split("^")[1]
		}
}

function PrintBtn_Click()
{
	var xlApp,obook,osheet,xlsheet,xlBook,i,j
	var Template
	var encmeth=""
	var obj=document.getElementById('getpath');
	if (obj) encmeth=obj.value;
	if (encmeth) var TemplatePath=cspRunServerMethod(encmeth);
	var Template=TemplatePath+"UDHCJFJudgeBankTradePay.xls" 
	//var Template="d:\\JF_OPInvprtSearch.xls" 

    var job=document.getElementById('Tjobz'+1);
	var Tjob=job.innerText;
	var GetInvprtNum=document.getElementById('GetInvprtNum');
	if (GetInvprtNum) {var encmeth=GetInvprtNum.value} else {var encmeth=''};
	var GetInvprtNum=cspRunServerMethod(encmeth,session['LOGON.USERID'],Tjob)
	if(GetInvprtNum==0){
		alert("û������,���ܴ�ӡ!")
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet  
    //xlApp.visible=true
	for (i=1;i<=GetInvprtNum;i++)
	{
		var GetInvDetail=document.getElementById('GetInvDetail');
     	if (GetInvDetail) {var encmeth=GetInvDetail.value} else {var encmeth=''};
	    var GetInvDetail=cspRunServerMethod(encmeth,session['LOGON.USERID'],Tjob,i)
		var GetInvDetail=GetInvDetail.split("^");
		var ColLength=GetInvDetail.length;
		var ColLength=16
		for(j=0;j<ColLength;j++)
		{
			xlsheet.cells(3+i,j+1).value=GetInvDetail[j];
		}
	}
	var Colnum=i
    xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,ColLength-1)).MergeCells=true
	xlsheet.Cells(1,1)="��ҽ�����˲����ϸ"
    
    var obj=document.getElementById("StDate");
	if (obj) var StDate=obj.value;
	   //StDate=StDate.split("/");
	   //StDate=StDate[2]+"-"+StDate[1]+"-"+StDate[0]
	var obj=document.getElementById("EndDate");
	if (obj) var EndDate=obj.value;
	   //EndDate=EndDate.split("/");
	   //EndDate=EndDate[2]+"-"+EndDate[1]+"-"+EndDate[0]
	var date=new Date();
    var TodayDate=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()
    TodayDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",TodayDate)
    TodayDate=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",TodayDate)
    var TodayTime=date.getHours()+":"+date.getMinutes()+":"+date.getSeconds()
    var ColNum=parseInt(ColLength/3)
	xlsheet.cells(3,2).value="��ѯ����:"+StDate+" -- "+EndDate
	xlsheet.cells(3,6).value="��ӡ����:"+TodayDate+" "+TodayTime
	xlsheet.cells(3,11).value="��ӡ��:"+session['LOGON.USERNAME']
	AddGrid(xlsheet,5,2,4+Colnum,ColLength+1,4,1)

	xlsheet.printout	    
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet.Quit;
	xlsheet=null;
}

function Export_Click()
{
	var xlApp,obook,osheet,xlsheet,xlBook,i,j
	var Template
	var encmeth=""
	var obj=document.getElementById('getpath');
	if (obj) encmeth=obj.value;
	if (encmeth) var TemplatePath=cspRunServerMethod(encmeth);
	var Template=TemplatePath+"UDHCJFJudgeBankTradePay.xls" 
	//var Template="d:\\JF_OPInvprtSearch.xls" 

    var job=document.getElementById('Tjobz'+1);
	var Tjob=job.innerText;
	var GetInvprtNum=document.getElementById('GetInvprtNum');
	if (GetInvprtNum) {var encmeth=GetInvprtNum.value} else {var encmeth=''};
	var GetInvprtNum=cspRunServerMethod(encmeth,session['LOGON.USERID'],Tjob)
	if(GetInvprtNum==0){
		alert("û������,���ܴ�ӡ!")
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet  
    //xlApp.visible=true
	for (i=1;i<=GetInvprtNum;i++)
	{
		var GetInvDetail=document.getElementById('GetInvDetail');
     	if (GetInvDetail) {var encmeth=GetInvDetail.value} else {var encmeth=''};
	    var GetInvDetail=cspRunServerMethod(encmeth,session['LOGON.USERID'],Tjob,i)
		var GetInvDetail=GetInvDetail.split("^");
		var ColLength=GetInvDetail.length;
		var ColLength=16
		for(j=0;j<ColLength;j++)
		{
			xlsheet.cells(3+i,j+1).value=GetInvDetail[j];
		}
	}
	var Colnum=i
    xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,ColLength-1)).MergeCells=true
	xlsheet.Cells(1,1)="��ҽ�����˲����ϸ"
    
    var obj=document.getElementById("StDate");
	if (obj) var StDate=obj.value;
	   //StDate=StDate.split("/");
	  // StDate=StDate[2]+"-"+StDate[1]+"-"+StDate[0]
	var obj=document.getElementById("EndDate");
	if (obj) var EndDate=obj.value;
	   //EndDate=EndDate.split("/");
	   //EndDate=EndDate[2]+"-"+EndDate[1]+"-"+EndDate[0]
	var date=new Date();
    var TodayDate=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()
    var TodayTime=date.getHours()+":"+date.getMinutes()+":"+date.getSeconds()
    TodayDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",TodayDate)
    TodayDate=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",TodayDate)
    var ColNum=parseInt(ColLength/3)
	xlsheet.cells(3,2).value="��ѯ����:"+StDate+" -- "+EndDate
	xlsheet.cells(3,6).value="��ӡ����:"+TodayDate+" "+TodayTime
	xlsheet.cells(3,11).value="��ӡ��:"+session['LOGON.USERNAME']
	AddGrid(xlsheet,5,2,4+Colnum,ColLength+1,4,1)

    //xlsheet.printout;
	//xlsheet.visable=true;
    //xlsheet.PrintPreview();
	xlBook.Close (savechanges=true);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null

}

function AddGrid(objSheet,fRow,fCol,tRow,tCol,xlsTop,xlsLeft)
{        
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
}

function Import_Click()
{
	var GetRecTXTFromFTPobj=document.getElementById('GetRecTXTFromFTP');
	if (GetRecTXTFromFTPobj) {var encmeth=GetRecTXTFromFTPobj.value} else {var encmeth=''};
	var Flag=cspRunServerMethod(encmeth)
	if(Flag==0){
		alert("����ɹ�!")
	}else if(Flag=="-1"){
		alert("ϵͳ����,����ϵ��Ϣ��!")
	}else if(Flag=="-2"){
		alert("�����ı�������,����ϵ��Ϣ��!")
	}else if(Flag=="-3"){
		alert("�ı��ѵ���")
	}else{
		alert("���벿�ֳɹ�,ʧ�ܼ�¼: "+Flag+" ��")
	}
}

function Process_Click()
{
	alert("���򿪷�������,���Ե�!���������������ǲ�������.")
	return;
    var Objtbl=document.getElementById('tUDHCJFJudgeCardTradePay');
    var Rows=Objtbl.rows.length;
    if(Rows<2){
	    return
    }
    var Str=""
    for(i=1;i<Rows;i++){
    	var TselectObj=document.getElementById('Tselectz'+i);
    	if(TselectObj.checked==true){
    		var TindObj=document.getElementById('Tindz'+i); 
	    	if(Str==""){
		    	Str=TindObj.innerText
	    	}else{
		    	Str=Str+"^"+TindObj.innerText
	    	}
	    }  
    }
    if(Str==""){
	    alert("û�д�������!")
	    return;
    }
    var SelRowObj=document.getElementById('Tjobz'+1);   
    var job=SelRowObj.innerText;
    var Guser=session['LOGON.USERID']
    
	var SaveProcessInfoobj=document.getElementById('SaveProcessInfo');
	if (SaveProcessInfoobj) {var encmeth=SaveProcessInfoobj.value} else {var encmeth=''};
	var rtn=cspRunServerMethod(encmeth,Guser,job,Str)
	if(rtn==0){
		alert("�������")
	}else{
		alert("����ʧ��:"+rtn)
	}
}

document.body.onload=BodyLoadHandler;