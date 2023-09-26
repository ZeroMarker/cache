/*d
dhcpha.outpha.printcom.js
模块:门诊药房
子模块:门诊药房-处方公共打印,JQuery版本,为确保原打印正常,故新建此类
createdate:2016-04-26
creator:yunhaibao
*/
var PhSplitCode=String.fromCharCode(1);
var HospitalDesc=""
HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID']);
//打印统一入口
function PrintPrescCom(phdrowidstr,cyflag,supplyid)
{
	if (supplyid==undefined){supplyid=""}
	if (phdrowidstr==undefined){phdrowidstr=""}
	if (phdrowidstr!="") {
		//处方
		var phdarr=phdrowidstr.split("^")
		for (i=0;i<phdarr.length;i++){
			var phdrowid=phdarr[i]
			if (cyflag=="1"){
				PrintPrescCY(phdrowid);
			}
			else{
				PrintPrescXY(phdrowid);
			}
		}
	}
	else {
		//补货单
		if (supplyid!=""){
			PrintSupp(supplyid);
		}
	} 
}
//西药处方
function PrintPrescXY(phdrowid)
{	    
    var zf='[正方]'
    var MyList="" ;
    var retval=tkMakeServerCall("web.DHCOutPhPrint","PrintPrescByPhd",phdrowid)
    var tmparr=retval.split("!!")
    var patinfo=tmparr[0]
    var patarr=tmparr[0].split("^")
    var PatNo=patarr[0];
    var PatientName=patarr[1];
    var PatientSex=patarr[3];
    var PatientAge=patarr[2];
    var ReclocDesc=patarr[11];
    var AdmDate=patarr[13] //就诊日期
    var PatH=patarr[5];
    var PyName=patarr[6];
    var FyName=patarr[7];
    var PatientCompany=patarr[12];  //工作单位
    var PatientMedicareNo=patarr[14]; //医保编号
    var PrescNo=patarr[15] 
    var AdmDepDesc=patarr[23]
	var Doctor=patarr[24]
    var Hospital=patarr[32]
    var diag=patarr[4];
    var DiagnoseArray=diag.split(",")
    var DiagnoseArrayLen=DiagnoseArray.length
    var m=0;

    var PrescTitle=""
    var BillType=""
    var PoisonClass="";
    var MRNo=patarr[33] 
    var TotalSum=0                   
	var MyPara='PrescTitle'+String.fromCharCode(2)+PrescTitle;
    MyPara=MyPara+'^zf'+String.fromCharCode(2)+zf;
    MyPara=MyPara+'^PresType'+String.fromCharCode(2)+'处方笺';
    MyPara=MyPara+'^PatientMedicareNo'+String.fromCharCode(2)+PatientMedicareNo;
    MyPara=MyPara+'^PrescNo'+String.fromCharCode(2)+PrescNo;
    MyPara=MyPara+'^MRNo'+String.fromCharCode(2)+MRNo;
    MyPara=MyPara+'^PANo'+String.fromCharCode(2)+PatNo;
    MyPara=MyPara+'^RecLoc'+String.fromCharCode(2)+ReclocDesc;
    MyPara=MyPara+'^Name'+String.fromCharCode(2)+PatientName;
    MyPara=MyPara+'^Sex'+String.fromCharCode(2)+PatientSex;
    MyPara=MyPara+'^Age'+String.fromCharCode(2)+PatientAge;
    MyPara=MyPara+'^Company'+String.fromCharCode(2)+PatientCompany;
    MyPara=MyPara+'^AdmDate'+String.fromCharCode(2)+AdmDate;
    MyPara=MyPara+'^PatH'+String.fromCharCode(2)+PatH;
    MyPara=MyPara+'^PyName'+String.fromCharCode(2)+PyName;
    MyPara=MyPara+'^FyName'+String.fromCharCode(2)+FyName;
    MyPara=MyPara+'^HosName'+String.fromCharCode(2)+Hospital+'处方笺';
   	for (var i=0;i<DiagnoseArrayLen;i++) {
		var m=m+1;
		MyPara=MyPara+'^Diagnose'+m+String.fromCharCode(2)+DiagnoseArray[i];
	}
    ////////////////////////////////////////////
    var sum=0;
    var medinfo=tmparr[1]
    var medarr=medinfo.split("@")
    var mlength=medarr.length
    for (h=0;h<mlength;h++)
     {
	       var medrow=medarr[h]
	       var rowarr=medrow.split("^")
	       var OrderName=rowarr[0]
	       var PackQty=rowarr[1]+rowarr[2]
	       var DoseQty=rowarr[3]
	       var Inst=rowarr[4]
	       var Freq=rowarr[5]
	       var Lc=rowarr[6]
	       var totalprice=rowarr[8]
	       var Ordremark=rowarr[10] 
	       var tmpdoseinfo=" 每次"+DoseQty
	       if (DoseQty==""){
		   		tmpdoseinfo="";
		   }
	       var firstdesc=OrderName+' X '+" / "+PackQty +tmpdoseinfo+" "+Inst+" "+Freq+" "+Lc+" "+Ordremark;		     
	       if (MyList=='') {
	        	MyList = firstdesc;
           }else{
	        	MyList = MyList + String.fromCharCode(2)+firstdesc;
		   }            

	   	   var sum=parseFloat(sum)+parseFloat(totalprice);  
     } 
     var TotalSum=sum.toFixed(2)
     MyPara=MyPara+'^Sum'+String.fromCharCode(2)+TotalSum+'元';
     MyPara=MyPara+'^AdmDep'+String.fromCharCode(2)+AdmDepDesc;
     MyPara=MyPara+'^UserAddName'+String.fromCharCode(2)+Doctor;
	 DHCSTGetXMLConfig("DHCOutPrescXYPrt");
	 DHCSTPrintFun(MyPara,MyList);  	
}
//打印处方草药 

function PrintPrescCY(phdrowid)
{
    var totalmoney=0;
	var zf='[正方]'
    var MyList="" ;
	var retval=tkMakeServerCall("web.DHCOutPhPrint","PrintPrescByPhd",phdrowid)
    var tmparr=retval.split("!!")
    var patinfo=tmparr[0]
    var ordinfo=tmparr[1]
    var patarr=patinfo.split("^")
    var Quefac=patarr[26]
    var Queinst=patarr[25]
    var Queqty=patarr[27]
    var PyName=patarr[6];
    var FyName=patarr[7];
    var FyDate=patarr[8];
    var PrescNo=patarr[15];
    var PatNo=patarr[0];
    var Patloc=patarr[16];
    var PatientName=patarr[1];
    var PatientSex=patarr[3];
    var Doctor=patarr[24];
    var PatientAge=patarr[2];
    var Patcall=patarr[18];
    var Pataddress=patarr[19];
    var Orddate=patarr[31];
    var Quecook=patarr[20];
    var Diag=patarr[4];
	var Hospital=patarr[32]
    var ordarr=ordinfo.split("@")
    var OrdRows=ordarr.length
    var pc= new Array(new Array(),new Array());
    
    for (i=0;i<OrdRows;i++)
    {
       
       	var ordstr=ordarr[i];
       	var SStr=ordstr.split("^")
       	pc[i]=new Array();
        var OrderName=SStr[11]
        var Quenote=SStr[10]
        var Queuom=SStr[2]
        var Oneqty=(SStr[1]*1) /parseFloat(Quefac)
        var Price= SStr[7]
        var money=SStr[8]
       	totalmoney=totalmoney+parseFloat(money);//金额
    
        pc[i][1]=OrderName+""+Quenote+""+Oneqty.toFixed(4)+Queuom+" "+Price
   	
    }
    
    
    var yfpc="共"+Quefac+"剂"+" "+"用法:"+Queinst+"  一次用量:"+Queqty
    var singlemoney=(totalmoney/parseFloat(Quefac)).toFixed(2)
    totalmoney=totalmoney.toFixed(2);
    totalmoney="一付金额:"+singlemoney+"  合计金额:"+totalmoney+"   "
    var yfpc=yfpc+"  "+totalmoney
    var lastrow="配药人:"+PyName+"     发药人:"+FyName+"     发药时间:"+FyDate
    var MyPara="";
    var MyList=""  
    MyPara=MyPara+"PrescNo"+String.fromCharCode(2)+PrescNo; 
    MyPara=MyPara+"^PatNo"+String.fromCharCode(2)+PatNo; 
    MyPara=MyPara+"^PatLoc"+String.fromCharCode(2)+Patloc;
	MyPara=MyPara+"^PyName"+String.fromCharCode(2)+FyName;  		    	
    MyPara=MyPara+"^PatName"+String.fromCharCode(2)+PatientName;
    MyPara=MyPara+"^PatSex"+String.fromCharCode(2)+PatientSex;
    MyPara=MyPara+"^Doctor"+String.fromCharCode(2)+Doctor;
    MyPara=MyPara+"^PatAge"+String.fromCharCode(2)+PatientAge;
    MyPara=MyPara+"^jytype"+String.fromCharCode(2)+Quecook;
    MyPara=MyPara+"^AdmDate"+String.fromCharCode(2)+Orddate;
    MyPara=MyPara+"^PatICD"+String.fromCharCode(2)+Diag;
    MyPara=MyPara+"^PatCall"+String.fromCharCode(2)+Patcall;
    MyPara=MyPara+"^PatAdd"+String.fromCharCode(2)+Pataddress;

    MyPara=MyPara+"^TotalMoney"+String.fromCharCode(2);
    MyPara=MyPara+"^YFSM"+String.fromCharCode(2)+yfpc;
    MyPara=MyPara+'^HosName'+String.fromCharCode(2)+Hospital+'处方笺';
    MyPara=MyPara+"^PrintSign"+String.fromCharCode(2)+lastrow;
  
    var k=0;
   
    for (k=1;k<OrdRows+1;k++)
      {
	     var l=0;
	     for (l=1;l<2;l++)
	      {
		     
	        MyPara=MyPara+"^txt"+k+l+String.fromCharCode(2)+pc[k-1][l]; 
	      }
      }
     
    childtype=""  
 	if (childtype=="1")  
	{
		DHCSTGetXMLConfig("DHCOutPrescCYChild");
	}
	else
	{
		DHCSTGetXMLConfig("DHCOutPrescCY");
	}         
    DHCSTPrintFun(MyPara,MyList); 
    return 0;
    
}
function PrintSupp(supp)
{
    var gPrnpath;
	gPrnpath=tkMakeServerCall("web.UDHCJFTITMP","getpath")
    var cnt=0;
	var tmpstr=tkMakeServerCall("web.DHCOutPhPrint","GetSuppData",supp)
	if (tmparr!=""){
		var tmparr=tmpstr.split("^")
		var pid=tmparr[0];
		var cnt=tmparr[1];
	}
	if (!(cnt>0)) return;
	var Template=gPrnpath+"STP_OutLYD_BJXH.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;
	
	if (xlsheet==null)
	{ 
	   alert("模板"+Template+"不存在")
	   return;
	}
	
    var cols=3
	for (i=1;i<=cnt;i++)
	{
		var data=tkMakeServerCall("web.DHCOutPhPrint","ListSuppData",pid,i)
		var tmpstr=data.split("^")
	    var phadate=tmpstr[0]
	    var phaloc=tmpstr[6];
	    var warddesc=tmpstr[4];
	    var locdesc=tmpstr[5];
	    var incidesc=tmpstr[1];
	    var qty=tmpstr[2];
	    var spec=tmpstr[3];
	    var sysdate=tmpstr[7];
	    
	    if (warddesc!="") var desc=warddesc;
	    if (locdesc!="") var desc=locdesc;
		 
		var Startrow=3 
		if (i==1) {
			setBottomLine(xlsheet,Startrow,1,cols);
			xlsheet.Cells(1, 1).Value=HospitalDesc+"基数药发药汇总单"
			xlsheet.Cells(Startrow-1, 1).Value = "发药科室:"+phaloc + " 科室:"+desc+ " 日期:"+sysdate+ " 发药人:"+session['LOGON.USERNAME'];
		}
		 
		xlsheet.Cells(Startrow+i, 1).Value = incidesc
		xlsheet.Cells(Startrow+i, 2).Value = spec
		xlsheet.Cells(Startrow+i, 3).Value = qty
        
        setBottomLine(xlsheet,Startrow+i,1,cols);
      
	}			
	xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet)       
}
 //打印标签
function PrintPrescLabelCom(ctloc,prt,prescno){
	var printsum=0;
	var printInfo=tkMakeServerCall("web.DHCOutPhPrint","GetPrintRow",ctloc,prt,prescno)
	if (printInfo==""){
		return;
	}
    var printInfoArr=printInfo.split("!!");
    var printInfoMain=printInfoArr[0];
    var printInfoDetail=printInfoArr[1];
    var printInfoMainArr=printInfoMain.split("^");
    var patno=printInfoMainArr[0];
    var patname=printInfoMainArr[1];
    var sysdate=printInfoMainArr[2];
    var patsex="";
    var patage="";
    var printInfoDetailArr=printInfoDetail.split(PhSplitCode);
    var OrdRows=printInfoDetailArr.length
	for (var printi=1;printi<OrdRows+1;printi++){ 
		var detailStr=printInfoDetailArr[printi-1];
		var detailArr=detailStr.split("^");
		var yfdesc=detailArr[4];
		var checkyfret="";
		if (yfdesc!=''){
			var checkyfret=tkMakeServerCall("web.DHCOutPhTQDisp","CheckPT",ctloc,yfdesc) //验证打印标签用法是否已维护
		}
       	if (checkyfret=="1") {
			var phdesc=detailArr[0]
			var pc=detailArr[5]
			var jl=detailArr[3]
			var qty=detailArr[2]
			var uom=detailArr[1]
			var qtyuom=qty+uom
			var xh=printi+"/"+OrdRows
			var allyf=yfdesc+" "+pc+" 每次"+jl
			var MyPara="";
			var MyList=""  
			MyPara=MyPara+"PatName"+String.fromCharCode(2)+patname;
			MyPara=MyPara+"^PatSex"+String.fromCharCode(2)+patsex;
			MyPara=MyPara+"^PatAge"+String.fromCharCode(2)+patage;
			MyPara=MyPara+"^RQ"+String.fromCharCode(2)+sysdate; 
			// MyPara=MyPara+"^XH"+String.fromCharCode(2)+xh;
			// MyPara=MyPara+"^win"+String.fromCharCode(2)+windesc;
			MyPara=MyPara+"^PhDesc"+String.fromCharCode(2)+phdesc;
			MyPara=MyPara+"^PhQtyUom"+String.fromCharCode(2)+qtyuom;
			MyPara=MyPara+"^ALLYF"+String.fromCharCode(2)+allyf;
			// MyPara=MyPara+"^PINC"+String.fromCharCode(2)+pc;
			// MyPara=MyPara+"^JL"+String.fromCharCode(2)+jl;			
			DHCSTGetXMLConfig("DHCOutPharmacyKFBQ");      
			DHCSTPrintFun(MyPara,MyList);
			printsum=printsum+1;
       	}
	 }
	 if (printsum==0){
	 	$.messager.alert("提示","该处方的药品用法尚未在打印标签用法维护中维护!","info")
	 	return;
	 }
}
function SetNothing(app,book,sheet)
{
        app=null;
        book.Close(savechanges=false);
        sheet=null;
} 
function setBottomLine(objSheet,row,startcol,colnum)
{
    objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).Borders(9).LineStyle=1 ;
}

