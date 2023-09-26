var myData1= new Array();
var myData2 = new Array(); 
var path    //  
var Guser,GuserCode

function BodyLoadHandler(){  
    Guser=session['LOGON.USERID']
    GuserCode=session['LOGON.USERNAME']
    var obj=document.getElementById("user")
     obj.value=GuserCode
    
    var obj=document.getElementById("BQuery")	 
    if (obj) {obj.onclick=handin}
    var obj=document.getElementById("BPrint")
    DHCWeb_DisBtn(obj);
    var obj=document.getElementById("hand")
    DHCWeb_DisBtn(obj);	
    var obj=document.getElementById("BDetail");
    if (obj) obj.onclick=ShowDetails;  	 
    websys_setfocus('user')
    getpath()
    document.onkeydown = DHCWeb_EStopSpaceKey;
} 
function ShowDetails()
{
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var stdateobj=document.getElementById("stdate");
	var StartTime=document.getElementById("StTime");
	var sUser=document.getElementById("user");
	
	var uName=sUser.value
	var Enddate=Enddobj.value;
	var EndTime=Endtobj.value;
	var StDate=stdateobj.value;
	var StTime=StartTime.value;
	
	var StTime="";
	var obj=document.getElementById("StTime");
	if (obj){
		StTime=obj.value;
	}
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.Details&hUser="+Guser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate+"&StartTime=" +StTime ;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandDetails_Details","top=20,left=20,width=930,height=660,scrollbars=1");
}
function handin(){
	if (Guser=="") return;
   // Guser="10036"
	var handin=document.getElementById('handin');
	if (handin) {var encmeth=handin.value} else {var encmeth=''};
	var str=cspRunServerMethod(encmeth,Guser)
	if (str=="") {alert(t['01']);return;}
	myData1=str.split("^")
	var job=myData1[13]
    if (job=="") return;
    var getdata=document.getElementById('getdata');
	if (getdata) {var encmeth=getdata.value} else {var encmeth=''};
	var str1=cspRunServerMethod(encmeth,Guser,job)
	myData2=str1.split("@") 

	setdate()

	}	
function setdate(){
	if ((myData1=="")&&(myData2=="")) return;
	var num=myData2[0]
	var xjsum=0,xjnum=0,zfsum=0,jzsum=0,jznum=0
	for (i=1;i<=num;i++){
		var str=myData2[i].split("^")
		switch(str[0]){
			
			case "CHEQUES" :
			    var obj=document.getElementById('CheckSUM')
			    obj.value=str[1]
			    zfsum=eval(zfsum)+eval(str[1]);
			    var obj1=document.getElementById('CheckNUM')
			    obj1.value=str[2]
			    
			case "BANK" :
			    var obj=document.getElementById('cardsum') 
			    obj.value=str[1]
			     zfsum=eval(zfsum)+eval(str[1])
			    var obj1=document.getElementById('cardnum')
			    obj1.value=str[2]
			case "YBDE" :
			    var obj=document.getElementById('dejjsum')
			    obj.value=str[1]
			    jzsum=eval(jzsum)+eval(str[1])
			    jznum=eval(jznum)+eval(str[2])
			case "YBTC" :
			    var obj=document.getElementById('tcjjsum')
			    obj.value=str[1]
			    jzsum=eval(jzsum)+eval(str[1])
			    jznum=eval(jznum)+eval(str[2])
			case "NBZZ" :
			    var obj=document.getElementById('remvsum')
			    obj.value=str[1]
			     zfsum=eval(zfsum)+eval(str[1])
			    var obj1=document.getElementById('remvnum')
			    obj1.value=str[2]
			default: 
			    
			    xjsum=eval(xjsum)+eval(str[1])
			    xjnum=eval(xjnum)+eval(str[2])
			     zfsum=eval(zfsum)+eval(str[1])
			}
		}
		var obj=document.getElementById('CashSUM')
		obj.value=xjsum
	    var obj1=document.getElementById('CashNUM')
	    obj1.value=xjnum
	    var allsum=eval(zfsum)+eval(jzsum)
	    document.getElementById('zfsum').value=zfsum
	    document.getElementById('allsum').value=allsum
	    document.getElementById('jznum').value=jznum
	    document.getElementById('jzallsum').value=jzsum 
		//返回值顺序?发票区间?红冲发票号?作废发票号?收费总额?收费份数
	//退费金额?退费份数?作废金额?作废份数
		document.getElementById('RefundINV').value=myData1[1]
		document.getElementById('ParkINV').value=myData1[2]
		document.getElementById('pjsum').value=myData1[3]
		document.getElementById('pjnum').value=myData1[4]
		document.getElementById('RefundSUM').value=myData1[5]
		document.getElementById('RefundNUM').value=myData1[6]
		document.getElementById('CancelSUM').value=myData1[7]
		document.getElementById('CancelNUM').value=myData1[8]
	    document.getElementById('stdate').value=myData1[9]
	    document.getElementById('StTime').value=myData1[10]
	    document.getElementById('EndDate').value=myData1[11]
	    document.getElementById('EndTime').value=myData1[12]
        var obj=document.getElementById("BPrint")
        if (obj) {
	       obj.disabled=false;
	       obj.onclick=print_click} 
	    var obj=document.getElementById("hand")
        if (obj) {
	       obj.disabled=false;
	       obj.onclick=insert} 
	}
	
function print_click(){
	if ((myData1=="")&&(myData2=="")) return;
	printopspedaily()
	}	
function insert(){
	if ((myData1=="")&&(myData2=="")) return;
	var str=myData1[9]+"^"+myData1[10]+"^"+myData1[11]+"^"+myData1[12]
	var insert=document.getElementById('insert');
	if (insert) {var encmeth=insert.value} else {var encmeth=''};
	
	var err=cspRunServerMethod(encmeth,Guser,str)

	if (err=="0") {alert(t['02']);return;}
	}
function printopspedaily(){
	
        var xlApp,obook,osheet,xlsheet,xlBook
	    var patname,patno,patdw,paymode,payamt,payamtdx,temp	    	    
	    Template=path+"JFOP_SpecialPatientDaily.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    var stdate="",sttime="",enddate="",endtime=""
	    stdate=myData1[9]
	    sttime=myData1[10]
	    enddate=myData1[11]
	    endtime=myData1[12]
	    var xjsum=0,xjnum=0,jzsum=0,zfsum=0,jznum=0
	    var zpsum=0,yhksum=0,nbzzsum=0
	    if (myData2[0]!=""){
		    num=myData2[0]	
	    for (i=1;i<=num;i++){
		var str=myData2[i].split("^")
		switch(str[0]){
			case "CHEQUES" :
			    xlsheet.cells(9,3).value=str[1]
			    xlsheet.cells(9,7).value=str[2]
			    zfsum=eval(zfsum)+eval(str[1])
			    zpsum=eval(str[1])
			case "BANK" :
			    xlsheet.cells(10,3).value=str[1]
			    xlsheet.cells(10,7).value=str[2]
			    zfsum=eval(zfsum)+eval(str[1])
			    yhksum=eval(str[1])
			case "YBDE" :
			    xlsheet.cells(4,3).value=str[1]
			     jzsum=eval(jzsum)+eval(str[1])
			     jznum=eval(jznum)+eval(str[2])
			case "YBTC" :
			    xlsheet.cells(3,3).value=str[1]
			    jzsum=eval(jzsum)+eval(str[1])
			    jznum=eval(jznum)+eval(str[2])
			case "NBZZ" :
			    xlsheet.cells(11,3).value=str[1]
			    xlsheet.cells(11,7).value=str[2]
			    zfsum=eval(zfsum)+eval(str[1])
			    nbzz=eval(str[1])
			default: 
			     xjsum=xjsum+str[1]
			     xjnum=xjnum+str[2]
			    zfsum=eval(zfsum)+eval(str[1])
			}
		}
	    }
	    allsum=eval(zfsum)+eval(jzsum)
	    xlsheet.cells(3,7).value=zfsum
	    xlsheet.cells(5,3).value=jzsum
	    xlsheet.cells(4,7).value=allsum
	    xlsheet.cells(5,7).value=jznum
	    xlsheet.cells(15,3).value=myData1[5]
	    xlsheet.cells(15,7).value=myData1[6]
	    xlsheet.cells(16,3).value=myData1[7]
	    xlsheet.cells(16,7).value=myData1[8]
	    xlsheet.cells(17,3).value=myData1[1]
	    xlsheet.cells(19,3).value=myData1[2]
	    xlsheet.cells(23,2).value=myData1[3]
	    xlsheet.cells(23,3).value=myData1[4]
	    xlsheet.cells(23,4).value=myData1[5]
	    xlsheet.cells(23,5).value=myData1[6]
	    xlsheet.cells(23,6).value=myData1[7]
	    xlsheet.cells(23,7).value=myData1[8]
	    var hjsum=eval(myData1[3])+eval(myData1[5])
	    var hjnum=eval(myData1[4])+eval(myData1[6])+eval(myData1[8])
	    xlsheet.cells(23,8).value=hjsum
	    xlsheet.cells(23,9).value=hjnum
	    xlsheet.cells(14,3).value=hjsum;
	    xlsheet.cells(14,7).value=hjnum
	    xlsheet.cells(24,3).value=myData1[0]
	    xlsheet.cells(26,4).value=jzsum
	    xlsheet.cells(27,4).value=zfsum
	    xlsheet.cells(28,3).value=xjsum
	    xlsheet.cells(29,3).value=zpsum
	    xlsheet.cells(30,3).value=yhksum
	    xlsheet.cells(31,3).value=nbzzsum
	    
	    
	    xlsheet.cells(2,3).value=GuserCode
	    xlsheet.cells(2,5).value=Guser
	    xlsheet.cells(2,7).value=stdate+" "+sttime+"---"+enddate+" "+endtime
	    xlsheet.cells(32,7).value=GuserCode
	    xlsheet.printout;
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null;
	
	}
function getpath() {
		   
			var getpath=document.getElementById('getpath');
			if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
		
			path=cspRunServerMethod(encmeth,'','')
			
	}
document.body.onload = BodyLoadHandler