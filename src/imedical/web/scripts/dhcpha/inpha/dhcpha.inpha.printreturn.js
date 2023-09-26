/*
dhcpha.inpha.printreturn.js
模块:住院药房
子模块:住院药房-退药单打印
createdate:2016-05-17
creator:yunhaibao
*/
var HospitalDesc=""
HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID']);
var printPath=GetPrintPath();
//退药单打印统一入口
function PrintReturnCom(phareturnno,reprint){
	if(printPath==""){
		$.messager.alert("提示","获取打印模板路径失败!","info") ;	
		return
	}
	if (phareturnno==""){return;}        
	PrintReturn(phareturnno)
}
 //打印退药单
function PrintReturn(retno){
	//printPath  路径
	var Template=printPath+"STP_PhaRet_BJFC.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	
	var startrow=4 ; //begin to print from the 7th row 
	if (xlsheet==null){ 
		$.messager.alert("提示","无法找到打印模版路径,请检查系统配置表!","info") ;
		return ;		  
	}
	var retstr=tkMakeServerCall("web.DHCSTPHARETURN","GetRetByNo","","",retno)
	var retarr=retstr.split("^") ;
	var pid=retarr[0] ;
	var cnt=retarr[1] ;
	if (pid=="") {return;}
	if (cnt<1) {return ;}
	var detailarr;
	var detailstr=GetReturnDetailData(pid,1)
	detailarr=detailstr.split("^")
	var mWardDesc=detailarr[14];
	if (mWardDesc.indexOf("-")>0){
		mWardDesc=mWardDesc.split("-")[1];
	}
	var mRecLoc=detailarr[12];
	if (mRecLoc.indexOf("-")>0){
		mRecLoc=mRecLoc.split("-")[1];
	}
	var mRetDate=detailarr[1];
	var mRetTime=detailarr[2];
	var mAuditDate=detailarr[28];
	var mAuditTime=detailarr[29];
	var mOperUser=detailarr[4];
	var mAuditUser=detailarr[30];
	var mStatus=detailarr[31];
	var mRetNo=detailarr[0];
	var mOrdLoc=detailarr[37]; 
	var status;
	var dodate="";
	var sumamt=0;
	if (mStatus=="Y"){
		status="已审核";
	    dodate="审核日期:"+ mAuditDate
	}else {
	   status="未审核"
	   dodate="退药日期:"+mRetDate;
	   }
	xlsheet.Cells(1,1)=mRecLoc+"退药单"+"      "+"申请科室:"+mOrdLoc;  
	xlsheet.Cells(3,1)="病区:"+mWardDesc+" "+"退药单号:"+ retno +"  " +dodate +"   " 
	var pano,paname,bed,prescno,incidesc,uomdesc,retqty,retdate;
	var reason,amount,barcode,manufacture,batno;
	var row;
	var tmppano="";
	row=startrow
	for ( var i=1;i<=cnt;i++){  
		var retdetailstr=GetReturnDetailData(pid,i)
		data=retdetailstr.split("^");
		pano=data[24] ;
		paname=data[25] ;
		bed=data[21] ;
		prescno=data[16] ;;
		incidesc=data[23]
		var tmpuom=data[27].split("(");
		uomdesc=tmpuom[0] ;
		retqty=data[17] ;
		retdate=data[1] ;
		recloc=data[12] ;
		reason=data[32];
		price=data[18];
	    amount=data[19];
	    barcode=data[34];
	    manufacture=data[35];
	    var dex=manufacture.indexOf("-")
	    if(dex>=0){
			manufacture=manufacture.substr(dex+1)
		}		
	    batno=data[36];	   	
	   	if ((tmppano=="")||(tmppano!=pano)){
		   	if(tmppano!=""){
			   	setBottomLine(xlsheet,row+i-1,1,8);
			}
		   	xlsheet.Cells(row+i,1)=pano;
			xlsheet.Cells(row+i,2)=paname;			
			tmppano=pano;
			cellEdgeRightLine(xlsheet,row+i,1,8);
		}
		sumamt=parseFloat(sumamt)+parseFloat(amount);		
		xlsheet.Cells(row+i,3)=incidesc;
		xlsheet.Cells(row+i,4)=batno;
		xlsheet.Cells(row+i,5)=manufacture;		
		xlsheet.Cells(row+i,6)=retqty
		xlsheet.Cells(row+i,7)=price
		xlsheet.Cells(row+i,8)=amount;
		cellEdgeRightLine(xlsheet,row+i,1,8);
	}	
	setBottomLine(xlsheet,row+i-1,1,8);	
	var endrow=row+i+2 ;
	xlsheet.Cells(endrow,1)="退药人:"+session['LOGON.USERNAME']+"   "+"收药人:" +"            "+"总金额:"+sumamt.toFixed(2) +"      打印时间:"+getPrintDateTime();
	xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet)
	KillTmpAfterPrint(pid)

	
}
function PrintReturnBeforeExec(){
}
function PrintReturnTotal(){
}
function GetReturnMainData(){
}
function GetReturnDetailData(pid,pidi){
	var returndetaildata=tkMakeServerCall("web.DHCSTPHARETURN","ListRetTotal","","",pid,pidi);
	return returndetaildata;
}
function KillTmpAfterPrint(pid){
	tkMakeServerCall("web.DHCSTPHARETURN","killRetTmpAfterPrint",pid)
}

