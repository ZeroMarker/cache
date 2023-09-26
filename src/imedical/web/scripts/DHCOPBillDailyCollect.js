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
///门诊收费日报
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
	xlsheet.cells(23,8).value=Data[0]   //收预交金
	xlsheet.cells(23,3).value=Data[1]   //退预交金 
	//xlsheet.cells(2,8).value=Data[2]  //预交金合计
	xlsheet.cells(5,3).value=Data[3]    //实收合计
	xlsheet.cells(9,3).value=Data[4]    //医保合计
	xlsheet.cells(24,3).value=Data[7]    //收入冲销的预交金
	var BLBNumSum=eval(Data[8])+eval(+websys_$V('BLBNum'))  //查询个数+补录个数
	xlsheet.cells(26,3).value="病历本个数:"+BLBNumSum   //病历本个数
	//支付方式
	var payMStr=Data[5].split("!")
	for(var i=1;i<payMStr.length;i++){
		var tmpPayMCode=payMStr[i].split("^")[0];
		var tmpPayMAmt=payMStr[i].split("^")[1];
		switch(tmpPayMCode){
			case "CASH":  //现金
			    xlsheet.cells(6,3).value=tmpPayMAmt;
				break; 
			case "ZP":    //支票
			    xlsheet.cells(7,3).value=tmpPayMAmt;
				break;
			case "YHK":   //银行卡
			    xlsheet.cells(8,3).value=tmpPayMAmt;
			    break;
		    case "BYB":    //市医保统筹
		        xlsheet.cells(10,3).value=tmpPayMAmt;
				break;
			case "ZHZFB":  //市账户支付
			    xlsheet.cells(11,3).value=tmpPayMAmt;
			    break;
			case "YLJM":   //市医疗减免
			    xlsheet.cells(12,3).value=tmpPayMAmt;
				break;
			case "YLBZ":   //市医疗补助
			    xlsheet.cells(13,3).value=tmpPayMAmt;
				break;
			case "AYB":    //省医保统筹
			    xlsheet.cells(14,3).value=tmpPayMAmt;
				break;
			case "ZHZFA":   //省账户支付
			    xlsheet.cells(15,3).value=tmpPayMAmt;
				break;	
		}
	}
	
	//会计分类
	var ACCateAry=Data[6].split("!");
	//alert(ACCateAry);
	// 收预交金 # 退预交金 #  预交金合计 # 实收合计 # 医保合计 # 支付方式串 # 会计分类串
   //123310.3#-465.9#122844.4#122844.4#0#!CASH^122614!YHK^230.4#!2^0^0^0!西药费^13025.19^0^13025.19!中成药费^148.8^0^148.8!中草药费^0^0^0!床位费^0^0^0!诊疗费^160^0^160!检查费^794^0^794!治疗费^646.04^0^646.04!手术费^0^0^0!化验费^1660^0^1660!护理费^0^0^0!其他^15^0^15!诊查费^0^0^0!挂号费^761.01^0^761.01!伙食费^0^0^0!合 计^17210.04^0^0
	for(var i=1;i<ACCateAry.length;i++){
		var tmpACDesc=ACCateAry[i].split("^")[0]
		var tmpAmt=ACCateAry[i].split("^")[1]
		var tmpYBAmt=ACCateAry[i].split("^")[2]
		var tmpAmtSum=ACCateAry[i].split("^")[3]
		switch(tmpACDesc){
			case "床位费":
			     xlsheet.cells(7,6).value=tmpAmt;
			     xlsheet.cells(7,7).value=tmpYBAmt;
			     xlsheet.cells(7,8).value=tmpAmtSum;
				break;
			case "诊疗费":
			     xlsheet.cells(8,6).value=tmpAmt;
			     xlsheet.cells(8,7).value=tmpYBAmt;
			     xlsheet.cells(8,8).value=tmpAmtSum;
				break;
			case "检查费":
			     xlsheet.cells(9,6).value=tmpAmt;
			     xlsheet.cells(9,7).value=tmpYBAmt;
			     xlsheet.cells(9,8).value=tmpAmtSum;
				break;
			case "治疗费":
			     xlsheet.cells(10,6).value=tmpAmt;
			     xlsheet.cells(10,7).value=tmpYBAmt;
			     xlsheet.cells(10,8).value=tmpAmtSum;
				break
			case "手术费":
			     xlsheet.cells(11,6).value=tmpAmt;
			     xlsheet.cells(11,7).value=tmpYBAmt;
			     xlsheet.cells(11,8).value=tmpAmtSum;
				break;
			case "化验费":
			     xlsheet.cells(12,6).value=tmpAmt;
			     xlsheet.cells(12,7).value=tmpYBAmt;
			     xlsheet.cells(12,8).value=tmpAmtSum;
				break;
			case "护理费":
			     xlsheet.cells(13,6).value=tmpAmt;
			     xlsheet.cells(13,7).value=tmpYBAmt;
			     xlsheet.cells(13,8).value=tmpAmtSum;
				break;
			case "其他":
			     xlsheet.cells(14,6).value=tmpAmt;
			     xlsheet.cells(14,7).value=tmpYBAmt;
			     xlsheet.cells(14,8).value=tmpAmtSum;
				break;
			case "诊查费":
			     xlsheet.cells(15,6).value=tmpAmt;
			     xlsheet.cells(15,7).value=tmpYBAmt;
			     xlsheet.cells(15,8).value=tmpAmtSum;
				break;
			case "挂号费":
			     xlsheet.cells(16,6).value=tmpAmt;
			     xlsheet.cells(16,7).value=tmpYBAmt;
			     xlsheet.cells(16,8).value=tmpAmtSum;
				break;
			case "伙食费":
			     xlsheet.cells(17,6).value=tmpAmt;
			     xlsheet.cells(17,7).value=tmpYBAmt;
			     xlsheet.cells(17,8).value=tmpAmtSum;
				break;
			case "西药费":
			     xlsheet.cells(19,6).value=tmpAmt;
			     xlsheet.cells(19,7).value=tmpYBAmt;
			     xlsheet.cells(19,8).value=tmpAmtSum;
				break;
			case "中成药费":
			     xlsheet.cells(20,6).value=tmpAmt;
			     xlsheet.cells(20,7).value=tmpYBAmt;
			     xlsheet.cells(20,8).value=tmpAmtSum;
				break;
			case "中草药费":
			     xlsheet.cells(21,6).value=tmpAmt;
			     xlsheet.cells(21,7).value=tmpYBAmt;
			     xlsheet.cells(21,8).value=tmpAmtSum;
				break;
			case "合 计":
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
//打印门诊日报汇总
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
    //job=SelRowObj.value;//?取job
	var str=tkMakeServerCall("web.DHCOPBillDailyCollect","GetData",guser,job,num);
		//alert(str)
		tsData[num] = str.split("^");//存入tsData用^分割
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
		xlsheet.cells(5+vbdata.length-1,11).value="制表人"+username
		xlsheet.cells(2,3).value=stDate
		xlsheet.cells(2,7).value=endDate //时间
		xlsheet.cells(2,11).value=websys_$V('printDate')
		//xlsheet.cells(2,8).value=str[19]

    //画表格
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
    //job=SelRowObj.value;//?取job
    //alert(job)
    
	var str=tkMakeServerCall("web.DHCOPBillDailyCollect","GetNum","","",guser,job);
    str=str.split("^")
    //alert(str)
    num=str[0]//得到??量
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
	var Info=value.split("^")//定?所取值分隔符
	document.getElementById("guserDr").value=Info[0]
	document.getElementById("CashierName").value=Info[2]//中文
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