var Guser,BillNo
var printobj,job
var path,tmpstr,num,pross,BackType
var AdmReasonDr,Districtobj,Typeobj,Dailyobj,InPutobj,Printobj
var CurrentSel=0
function BodyLoadHandler() 
{
	getpath();
	var Printobj=document.getElementById("prtDueList");
	if (Printobj){ Printobj.onclick=PrintDueList;}
	var InPutobj=document.getElementById("btnInPut")
	if (InPutobj) { InPutobj.onclick=BackFileInPut;}
	//var Dailyobj=document.getElementById("btnDaily")
	var Districtobj=document.getElementById("District")
	var Typeobj=document.getElementById("BackType")
	if (Typeobj){Typeobj.onclick=ChangeBackType;}
	//if (Districtobj){Districtobj.onkeydown=District_keydown;}
	//if (Districtobj){Districtobj.onkeyup=clearDistrict;}
	var qfPatobj=document.getElementById("qfPat")
	if (qfPatobj){qfPatobj.onclick=qfPat_OnClick}
	var JSPqfPatobj=document.getElementById("JSPqfPat")
	if (JSPqfPatobj){JSPqfPatobj.onclick=JSPqfPat_OnClick}
	var HKPatobj=document.getElementById("HKPat")
	if (HKPatobj){HKPatobj.onclick=HKPat_OnClick}
    var RefusePatobj=document.getElementById("RefusePat")
    if (RefusePatobj){RefusePatobj.onclick=RefusePat_OnClick}
       
    var YBInPutobj=document.getElementById("YBInPut")
	if (YBInPutobj){YBInPutobj.onclick=FileInPut}
	
    var btnInsertDaiFang=document.getElementById('btnInsertDaiFang');
    var DaiFangAmount=document.getElementById('DaiFangAmount');
	if (JSPqfPatobj.checked==false){btnInsertDaiFang.disabled=true;} //visible
	if (JSPqfPatobj.checked==false){DaiFangAmount.disabled=true;}
	if (btnInsertDaiFang){btnInsertDaiFang.onclick=InsertDaiFang}

}
function District_keydown() {
	if (window.event.keyCode==13)
	{ window.event.keyCode=117;
	    District_lookuphandler(); 
	}
}


//ҽ���ϴ����� add by wangli 20081125
function FileInPut(){
	
	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLBJDFacade"); 
	var rtnStr=DHCINSUBLL.InsuFileInput();
}


 //�ĸ���ѯ������Ϊ��ѡ�� ����ֻ��ѡ����һ
 //�����ĸ���ѯ������ؿ������Ϊ��ѡ,����ֻ��ѡ����һ,��ѡ�����ĸ���ѯ�����е�һ��,���Զ�ȥ���ؿ����Ĺ�
function qfPat_OnClick(){
  var qfPatobj=document.getElementById("qfPat")
  var JSPqfPatobj=document.getElementById("JSPqfPat")
  var HKPatobj=document.getElementById("HKPat")
  var RefusePatobj=document.getElementById("RefusePat")
  var Typeobj=document.getElementById("BackType")
  if (qfPatobj.checked==true){
  JSPqfPatobj.checked=false;
  HKPatobj.checked=false;
  RefusePatobj.checked=false;
  Typeobj.checked=false;}
}
function JSPqfPat_OnClick(){
  var qfPatobj=document.getElementById("qfPat")
  var JSPqfPatobj=document.getElementById("JSPqfPat")
  var HKPatobj=document.getElementById("HKPat")
  var RefusePatobj=document.getElementById("RefusePat")
  var Typeobj=document.getElementById("BackType")
  if (JSPqfPatobj.checked==true){
  qfPatobj.checked=false;
  HKPatobj.checked=false;
  RefusePatobj.checked=false;
  Typeobj.checked=false;}
    var btnInsertDaiFang=document.getElementById('btnInsertDaiFang');
  	if (JSPqfPatobj.checked==false){btnInsertDaiFang.disabled=true;}
  	else {btnInsertDaiFang.disabled=false;}
    var DaiFangAmount=document.getElementById('DaiFangAmount');
	if (JSPqfPatobj.checked==false){DaiFangAmount.disabled=true;}
	else {DaiFangAmount.disabled=false;}

}
function HKPat_OnClick(){
  var qfPatobj=document.getElementById("qfPat")
  var JSPqfPatobj=document.getElementById("JSPqfPat")
  var HKPatobj=document.getElementById("HKPat")
  var RefusePatobj=document.getElementById("RefusePat")
  var Typeobj=document.getElementById("BackType")
  if (HKPatobj.checked==true){
  qfPatobj.checked=false;
  JSPqfPatobj.checked=false;
  RefusePatobj.checked=false;
  Typeobj.checked=false;}
}
function RefusePat_OnClick(){
  var qfPatobj=document.getElementById("qfPat")
  var JSPqfPatobj=document.getElementById("JSPqfPat")
  var HKPatobj=document.getElementById("HKPat")
  var RefusePatobj=document.getElementById("RefusePat")
  var Typeobj=document.getElementById("BackType")
  if (RefusePatobj.checked==true){
  qfPatobj.checked=false;
  JSPqfPatobj.checked=false;
  HKPatobj.checked=false;
  Typeobj.checked=false;}
}
 //
function clearDistrict(){
	var Districtobj=document.getElementById("District");
	Districtobj.value="";
}
function BackFileInPut(){
	var Typeobj=document.getElementById("BackType")
	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLBJEFacade"); 
	if (Typeobj.checked==true){
		var rtnStr=DHCINSUBLL.InsuBackFileInput();} //��������Żؿ�������Żؿ����
	else{
    var rtnStr=DHCINSUBLL.InsuFileInput();} //�����̻ؿ�
}
function ChangeBackType(){
	var Typeobj=document.getElementById("BackType")
	//var Dailyobj=document.getElementById("btnDaily")
	var TypeTextobj=document.getElementById("BackTypeText")
    if(Typeobj.checked==true){//Dailyobj.disabled=true;
    TypeTextobj.value="���Żؿ�"}
    else {//Dailyobj.disabled=false;
    TypeTextobj.value="�����̻ؿ�"} //�����Żؿ��ʱ��,�սᰴť������

	var qfPatobj=document.getElementById("qfPat")
    var JSPqfPatobj=document.getElementById("JSPqfPat")
    var HKPatobj=document.getElementById("HKPat")
    var RefusePatobj=document.getElementById("RefusePat")
	if (Typeobj.checked==true){
      JSPqfPatobj.checked=false;
      HKPatobj.checked=false;
      RefusePatobj.checked=false;
      qfPatobj.checked=false;}
}
function DailyCount() {
	var Typeobj=document.getElementById("BackType")
	var Dailyobj=document.getElementById("btnDaily")
    /*alert(Typeobj.value)
	if (Dailyobj.disabled==false){
	   var s=confirm("�Ƿ�����ս�?")
	   if (s==true){
	     var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLBJEFacade");
	     var rtnStr=-1;
	     var rtnStr=DHCINSUBLL.DailyCount(Typeobj.value);
	     if (rtnStr=="False") {alert("����û�з������ñ仯") }//("�ս�ʧ��,��ע��!\n\n����ԭ��:\n����û�з���Ƿ�Ѻͻؿ�\n���ݱ������")} //����
	     else {alert("�ս�ɹ�")}
	   }
	}*/
	var DailyCount=document.getElementById("DailyCount");
	if (DailyCount) {var encmeth=DailyCount.value} else {var encmeth=''}
	var ret=cspRunServerMethod(encmeth)
}
function getpath() {
	var getpath=document.getElementById('getpath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	path=cspRunServerMethod(encmeth,'','')
	//alert(path)
	
	}
function PrintDueList() {
    var Districtobj=document.getElementById("District")
    var qfPatobj=document.getElementById("qfPat")
	var JSPqfPatobj=document.getElementById("JSPqfPat")
	var HKPatobj=document.getElementById("HKPat")
	var RefusePatobj=document.getElementById("RefusePat")
	
    if ((qfPatobj.checked==false)&&(JSPqfPatobj.checked==false)&&(HKPatobj.checked==false)&&(RefusePatobj.checked==false)&&(Districtobj.value==""))
    {alert("��ѡ��Ҫ��ӡ�����������²�ѯ!")}	
    else{
    var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j 
    var Template
   //path="http://10.4.11.57/TrakCare/app/trak/med/Results/Templates/"
    Template=path+"INSU_PRTDueList.xls"
    
    //alert(Template)
    xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet ; 
	var objtbl=document.getElementById('tINSUDueListPrint');

	var str=objtbl.rows(1).cells(1).innerText.split("-")
	    xlsheet.cells(3,1)=str[0]+"��"
	    //Ƿ�Ѳ��˸ı䱨����ʾ����
		if (qfPatobj.checked==true){
		//xlsheet.cells(2,1)="";
		xlsheet.cells(2,4)="����δ�ؿ���б�";
		xlsheet.cells(2,9)="";}
		if (JSPqfPatobj.checked==true){
		xlsheet.cells(2,4)="�ѻؿδ���˵Ĳ����б�";
		xlsheet.cells(2,9)="";}
		if (HKPatobj.checked==true){
		xlsheet.cells(2,4)="�ѵ��ʲ����б�";
		xlsheet.cells(2,9)="";}
		if (RefusePatobj.checked==true){
		xlsheet.cells(2,4)="ҽ���ܸ������б�";
		xlsheet.cells(2,9)="";}
		//
	    var Districtobj=document.getElementById("District")
	    xlsheet.cells(2,3)=Districtobj.value
	    var TypeTextobj=document.getElementById("BackTypeText")
	    xlsheet.cells(2,9)=TypeTextobj.value

	for (i=1;i<objtbl.rows.length;i++)
	{
	     str=objtbl.rows(i).cells(1).innerText.split("-");

	     xlsheet.cells(4+i,1)=str[1];
	     xlsheet.cells(4+i,2)=str[2];
		
           for (j=2;j<objtbl.rows(1).cells.length-3;j++)
		{
           xlsheet.cells(4+i,j+1)=objtbl.rows(i).cells(j).innerText;
           xlsheet.Cells(4+i,j+1).Borders(9).LineStyle = 1;
           xlsheet.Cells(4+i,j+1).Borders(7).LineStyle = 1;
           xlsheet.Cells(4+i,j+1).Borders(10).LineStyle = 1;
           xlsheet.Cells(4+i,j+1).Borders(8).LineStyle = 1;

	     }

	    for (j=1;j<objtbl.rows(1).cells.length-2;j++)
           {
            xlsheet.Cells(4+i,j).Borders(9).LineStyle = 1;
	     xlsheet.Cells(4+i,j).Borders(7).LineStyle = 1;
	     xlsheet.Cells(4+i,j).Borders(10).LineStyle = 1;
	     xlsheet.Cells(4+i,j).Borders(8).LineStyle = 1;}
	}

	    xlApp.Visible=true;
	   	xlsheet.PrintPreview();	    
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet=null ;
}
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tINSUDueListPrint');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    
	if (!selectrow) return;
	var SelRowObj
	var obj	
	if (selectrow==CurrentSel){		
        obj=document.getElementById("INPAYID");
        if (obj){obj.value=""}        
	    return;
	}			
	CurrentSel=selectrow;		

	/*for (var i=0;i<obj.options.length;i++){
		if (SelRowObj.innerText==obj.options[i].value){
		   obj.selectedIndex=i;
		}
	}*/
	SelRowObj=document.getElementById('INPAYRowidz'+selectrow);
	obj=document.getElementById("INPAYID");
	if (SelRowObj.innerText==" "){SelRowObj.innerText=""}
	obj.value=SelRowObj.innerText;
}
//�ֹ���������̻ؿ���Ϣ LOU 2008-12-28
function InsertDaiFang(){
	
	var DaiFangAmount=document.getElementById('DaiFangAmount').value;
	if (DaiFangAmount==""){alert("������������!!");return}
	if (DaiFangAmount=="0"){alert("��������ȷ�Ĵ������!!");return}
	var INPAYID=document.getElementById("INPAYID").value;
	if (INPAYID==""){alert("��ѡ��Ҫ���ô������ļ�¼!!");return}
	
	//����dividȡ��������Ϣ
	var GetPatInfoByDivID=document.getElementById('GetPatInfoByDivID');
	if (GetPatInfoByDivID){var encmeth=GetPatInfoByDivID.value} else {var encmeth=''};
	var Info=cspRunServerMethod(encmeth,INPAYID)
	if (Info==""){alert("û���ҵ��˲��˵Ľ跽��Ϣ!");return}
	var tmpField=Info.split("^")
    
    var d, s=""; //��õ�������
    d = new Date();
    s = d.getYear();
    s += "-" +(d.getMonth() + 1)
    s += "-" + d.getDate() 

	var Balance=tmpField[3]-DaiFangAmount
	
	if (Balance>0){
		var l=confirm("�˲��˵Ĵ��������跽����,�跽Ϊ"+tmpField[3]+",�ֹ�����Ĵ������Ϊ"+DaiFangAmount+"\n"+"�Ƿ����ܸ�?      �ܸ����Ϊ"+Balance);
		if (l==true){
			var SubDueInfo=Info+"^"+DaiFangAmount
			var m=confirm("�Ƿ񱣴�������Ϣ?\n"+tmpField[2]+"��"+s+"�ؿ�"+DaiFangAmount+",�ܸ�"+Balance)
			if (m==true){
				var InsertSubDueDaiFang=document.getElementById('InsertSubDueDaiFang');
				if (InsertSubDueDaiFang){var encmeth=InsertSubDueDaiFang.value} else {var encmeth=''};
				var Flag=cspRunServerMethod(encmeth,SubDueInfo)
				if (Flag=="0"){alert("����ɹ�!!");}
			    else {alert("����ʧ��!")}
				}
			}
		}
		
	if (Balance<0){alert("���������ڽ跽���,ʧ��!!");return}
	
	if (Balance==0){
		var SubDueInfo=Info+"^"+DaiFangAmount
		var m=confirm("�Ƿ񱣴�������Ϣ?\n"+tmpField[2]+"��"+s+"�ؿ�"+DaiFangAmount+",�ܸ�0")
		if (m==true){
			var InsertSubDueDaiFang=document.getElementById('InsertSubDueDaiFang');
			if (InsertSubDueDaiFang){var encmeth=InsertSubDueDaiFang.value} else {var encmeth=''};
			var Flag=cspRunServerMethod(encmeth,SubDueInfo)
			if (Flag=="0"){alert("����ɹ�!!");}
			else {alert("����ʧ��!")}
			}
	}
	
	}
document.body.onload = BodyLoadHandler;