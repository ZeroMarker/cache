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


//医保上传导入 add by wangli 20081125
function FileInPut(){
	
	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLBJDFacade"); 
	var rtnStr=DHCINSUBLL.InsuFileInput();
}


 //四个查询条件作为单选项 四者只能选择其一
 //并且四个查询条件与回款类别作为单选,两者只能选择其一,即选择了四个查询条件中的一个,会自动去掉回款类别的勾
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
		var rtnStr=DHCINSUBLL.InsuBackFileInput();} //如果是首信回款调用首信回款界面
	else{
    var rtnStr=DHCINSUBLL.InsuFileInput();} //金算盘回款
}
function ChangeBackType(){
	var Typeobj=document.getElementById("BackType")
	//var Dailyobj=document.getElementById("btnDaily")
	var TypeTextobj=document.getElementById("BackTypeText")
    if(Typeobj.checked==true){//Dailyobj.disabled=true;
    TypeTextobj.value="首信回款"}
    else {//Dailyobj.disabled=false;
    TypeTextobj.value="金算盘回款"} //是首信回款的时候,日结按钮不可用

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
	   var s=confirm("是否进行日结?")
	   if (s==true){
	     var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLBJEFacade");
	     var rtnStr=-1;
	     var rtnStr=DHCINSUBLL.DailyCount(Typeobj.value);
	     if (rtnStr=="False") {alert("当天没有发生费用变化") }//("日结失败,请注意!\n\n可能原因:\n当天没有发生欠费和回款\n数据保存出错")} //换行
	     else {alert("日结成功")}
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
    {alert("请选择要打印的区县再重新查询!")}	
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
	    xlsheet.cells(3,1)=str[0]+"年"
	    //欠费病人改变报表显示内容
		if (qfPatobj.checked==true){
		//xlsheet.cells(2,1)="";
		xlsheet.cells(2,4)="首信未回款病人列表";
		xlsheet.cells(2,9)="";}
		if (JSPqfPatobj.checked==true){
		xlsheet.cells(2,4)="已回款但未到账的病人列表";
		xlsheet.cells(2,9)="";}
		if (HKPatobj.checked==true){
		xlsheet.cells(2,4)="已到帐病人列表";
		xlsheet.cells(2,9)="";}
		if (RefusePatobj.checked==true){
		xlsheet.cells(2,4)="医保拒付病人列表";
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
//手工保存金算盘回款信息 LOU 2008-12-28
function InsertDaiFang(){
	
	var DaiFangAmount=document.getElementById('DaiFangAmount').value;
	if (DaiFangAmount==""){alert("请输入贷方金额!!");return}
	if (DaiFangAmount=="0"){alert("请输入正确的贷方金额!!");return}
	var INPAYID=document.getElementById("INPAYID").value;
	if (INPAYID==""){alert("请选中要设置贷方金额的记录!!");return}
	
	//根据divid取出病人信息
	var GetPatInfoByDivID=document.getElementById('GetPatInfoByDivID');
	if (GetPatInfoByDivID){var encmeth=GetPatInfoByDivID.value} else {var encmeth=''};
	var Info=cspRunServerMethod(encmeth,INPAYID)
	if (Info==""){alert("没有找到此病人的借方信息!");return}
	var tmpField=Info.split("^")
    
    var d, s=""; //获得当天日期
    d = new Date();
    s = d.getYear();
    s += "-" +(d.getMonth() + 1)
    s += "-" + d.getDate() 

	var Balance=tmpField[3]-DaiFangAmount
	
	if (Balance>0){
		var l=confirm("此病人的贷方金额与借方金额不符,借方为"+tmpField[3]+",手工输入的贷方金额为"+DaiFangAmount+"\n"+"是否发生拒付?      拒付金额为"+Balance);
		if (l==true){
			var SubDueInfo=Info+"^"+DaiFangAmount
			var m=confirm("是否保存以下信息?\n"+tmpField[2]+"于"+s+"回款"+DaiFangAmount+",拒付"+Balance)
			if (m==true){
				var InsertSubDueDaiFang=document.getElementById('InsertSubDueDaiFang');
				if (InsertSubDueDaiFang){var encmeth=InsertSubDueDaiFang.value} else {var encmeth=''};
				var Flag=cspRunServerMethod(encmeth,SubDueInfo)
				if (Flag=="0"){alert("保存成功!!");}
			    else {alert("保存失败!")}
				}
			}
		}
		
	if (Balance<0){alert("贷方金额大于借方金额,失败!!");return}
	
	if (Balance==0){
		var SubDueInfo=Info+"^"+DaiFangAmount
		var m=confirm("是否保存以下信息?\n"+tmpField[2]+"于"+s+"回款"+DaiFangAmount+",拒付0")
		if (m==true){
			var InsertSubDueDaiFang=document.getElementById('InsertSubDueDaiFang');
			if (InsertSubDueDaiFang){var encmeth=InsertSubDueDaiFang.value} else {var encmeth=''};
			var Flag=cspRunServerMethod(encmeth,SubDueInfo)
			if (Flag=="0"){alert("保存成功!!");}
			else {alert("保存失败!")}
			}
	}
	
	}
document.body.onload = BodyLoadHandler;