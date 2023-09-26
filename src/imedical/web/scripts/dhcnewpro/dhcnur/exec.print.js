var myData=new Array();
var myColumns=new Array();
var queryTypeCode=$("#QueryTypeCode").val();
var hospitalName=LgHospDesc;

var ifPrintSheet="Y";
var ifPrintBar="Y";
var ifPrintTransfusionCard="Y";
var ifPrintLabNote="Y";
var ifPrintSeatNo="Y";
var ifRecPrint="Y";
var ifPrintLocal="N";
var offLineRecLoc="^"+"门诊化验室^病房化验室^检验生化室^血库^血液室^微生物室^免疫室^急诊化验室^肠道化验室^皮科实验室^核医学科检验"+"^"
 
var startDate=""; 
var endDate="";
var queryTypeCode="";
var hopid=""
var selectRowDatas;
var sysDate
var sysTime


var printDescList=[]
var printLenList=[]
var printVarList=[]
var path = GetFilePath();
var WebIp = serverCall("Nur.DHCMGNurseSet", "getSet").split("^")[1];

function GetFilePath()
{
	if (ifPrintLocal=="Y") var path="c:\\moban\\"
	else {
    	var path=serverCall("web.DHCCLCom","GetPath")
	}
    return path
}


function GetDate(dateStr)
{
	var tmpList=dateStr.split("/")
	if (tmpList.length<3) return 0;
	return ((tmpList[2]*1000)+(tmpList[1]*50)+tmpList[0]*1)
}

// 打印口服、输液单、口服药单
function PrintExecSheet()
{
	/*
    var printList=[],patPrint,framePrint,labNoStr="^";
	actRow=3;
	myData=[];
	oeoreIdArr=[];
	*/
	var oeoriIdStr = "",seqNoStr = "";disposeCodeStr = "";
	var orderStrListStr="";
	var printedId = new Array();
	myData=[];
	//输液单 切换瓶签模式 add lvpeng
	if($("#c2").is(':visible')){	
		$('input[name="IfPrint"]:checked').each(function(){
			var arciDescArr = $(this).attr('data-arcidesc').split("^");
			for(j=0;j<$(this).attr('data-oeoreid').split("^").length;j++){
				if(arciDescArr[j].indexOf("__")!=-1) continue;
				var oeoriIdretstr = serverCall("Nur.NurseExcuteSheet", "getOrderGroupIdStr", {orderId:$(this).attr('data-oeoreid').split("^")[j],queryCode:""});
				
				var oeoriIdretstrList = oeoriIdretstr.split("#");
				var oeoriId = oeoriIdretstrList[0];
				var seqNo = oeoriIdretstrList[1];
				
				var orderStrList = $(this).attr('data-oeoreid').split("^")[j].split("||");
				/*
				if(printedId[orderStrList[0] + "||" + orderStrList[1]])
				{
    				return true;	
   				}
   				*/
   				
   				if(disposeCodeStr.length==0){	//处置状态
	   				disposeCodeStr=$(this).attr('data-code');	
	   			}else{
		   			disposeCodeStr=disposeCodeStr+"^"+$(this).attr('data-code');
		   		}
				
				if (oeoriId != "") {
					if (oeoriIdStr.length == 0) {
						
						oeoriIdStr = oeoriId;
					} else {
						oeoriIdStr = oeoriIdStr + "^" + oeoriId;
					}
					if (seqNoStr.length == 0) {
						seqNoStr = seqNo;
					} else {
						seqNoStr = seqNoStr + "^" + seqNo;
					}
				}
				
				printedId[orderStrList[0] + "||" + orderStrList[1]] = 1;
			}
		})
		
		
		if (oeoriIdStr == "") {
		 	parent.dhccBox.message({
		    	type: 'danger',
		    	message : '请选择需要打印的医嘱!'
		    });
			return;
		}
		
		
	var codelist=disposeCodeStr.split("^");
    var chargeflag=""
    for(var k=0;k<codelist.length;k++){
	    if(codelist[k]=="UnPaid"){
		    chargeflag="Y";
	    }
	}

	if(chargeflag=="Y"){
		dhccBox.confirm("提示","包含未缴费的医嘱,是否继续打印？","exec-print",function(result){
	
			var type="PAT";
			if($('input[name="btSelectAll"]').is(':checked')){
				type="PATALL";
			}
			showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, type, queryTypeCode, WebIp, "true", 1, "NurseOrderOP.xml");  //qqa 2017-08-25 win10打印
			//if (DHCCNursePrintComm.saveFlag == 1) {
			SetPrintFlag(oeoriIdStr, "Y");
			SavePrintRecord("PAT", queryTypeCode, oeoriIdStr, LgUserID)
			//}	
		    })// confirm end
		}else{
			var type="PAT";
			if($('input[name="btSelectAll"]').is(':checked')){
				type="PATALL";
			}
			showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, type, queryTypeCode, WebIp, "true", 1, "NurseOrderOP.xml"); //qqa 2017-08-25 win10打印
			//if (DHCCNursePrintComm.saveFlag == 1) {
			SetPrintFlag(oeoriIdStr, "Y");
			SavePrintRecord("PAT", queryTypeCode, oeoriIdStr, LgUserID)
			//}		
		}
		
		
	}else{  //横向显示

	for (i=0;i<selectRowDatas.length;i++)
    {
		myData[myData.length]=selectRowDatas[i];
    }
    if(myData.length==0){
	    parent.dhccBox.message({
		    type: 'danger',
		    message : '没有需要打印的数据!'
		});
	    return;
	};
    
    /*------2016-10-13 lvpeng-----*/
	for (i=0;i<myData.length;i++)
    {  
    	if(myData[i].arcimDesc.indexOf("______")!="-1") continue;
    	var orderStrList = myData[i].oeoreId.split("||");
    	
    	/*
    	if(printedId[orderStrList[0] + "||" + orderStrList[1]])
    	{
	    	continue;	
	    }
	    */
	    
        var oeoreId=myData[i].oeoreId;
        var mainOeoreId = myData[i].mainOeoreId;
        var disposeStatCode =myData[i].disposeStatCode; //处置状态
  
        if (disposeCodeStr.length== 0){
	        disposeCodeStr = disposeStatCode;
	    }else{
			disposeCodeStr = disposeCodeStr + "^" + disposeStatCode; 
		}
		
		var oeoriIdretstr = serverCall("Nur.NurseExcuteSheet", "getOrderGroupIdStr", {orderId:oeoreId,queryCode:""});
		var oeoriIdretstrList = oeoriIdretstr.split("#");
		var oeoriId = oeoriIdretstrList[0];
		var seqNo = oeoriIdretstrList[1];
		if (oeoreId != "") {
			if (oeoriIdStr.length == 0) {
				oeoriIdStr = oeoriId;
			} else {
				oeoriIdStr = oeoriIdStr + "^" + oeoriId;
			}
			if (seqNoStr.length == 0) {
				seqNoStr = seqNo;
			} else {
				seqNoStr = seqNoStr + "^" + seqNo;
			}
		}
		printedId[orderStrList[0] + "||" + orderStrList[1]] = 1; 
    }
    
    if (oeoriIdStr == "") {
	    parent.dhccBox.message({
		    type: 'danger',
		   	message : '请选择需要打印的医嘱!'
			});
		return;
	}
    
    var codelist=disposeCodeStr.split("^");
    var chargeflag=""
    for(var k=0;k<codelist.length;k++){
	    if(codelist[k]=="UnPaid"){
		    chargeflag="Y";
	    }
	}

	if(chargeflag=="Y"){
		dhccBox.confirm("提示","包含未缴费的医嘱,是否继续打印？","exec-print",function(result){
	
			var type="PAT";
			if($('input[name="btSelectAll"]').is(':checked')){
				type="PATALL";
			}

			showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, type, queryTypeCode, WebIp, "true", 1, "NurseOrderOP.xml");  //qqa 2017-08-25 win10打印
			//if (DHCCNursePrintComm.saveFlag == 1) {
			SetPrintFlag(oeoriIdStr, "Y");
			SavePrintRecord("PAT", queryTypeCode, oeoriIdStr, LgUserID)
			//}	
		    })// confirm end
		}else{
			var type="PAT";
			if($('input[name="btSelectAll"]').is(':checked')){
				type="PATALL";
			}
			showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, type, queryTypeCode, WebIp, "true", 1, "NurseOrderOP.xml");  //qqa 2017-08-25 win10打印
			//if (DHCCNursePrintComm.saveFlag == 1) {
			SetPrintFlag(oeoriIdStr, "Y");
			SavePrintRecord("PAT", queryTypeCode, oeoriIdStr, LgUserID)
			//}		
		}
	}
}

function GetArrayIndex(varArray,val)
{
	for (i=0;i<varArray.length;i++)
	{
		if (varArray[i]==val) {return i;}
	}
	return -1;
}

// 修改 17-02-16
function SetPrintFlag(oeoriIdStr,flag)
{  
    if (oeoriIdStr!="")
    {
	    if (!flag) {
			flag = "Y"
		}
        Wardid = serverCall("web.PACWard", "GetWardFromLoc", {loc:LgCtLocID}) //
		PrintDateTime = serverCall("web.DHCNurCom", "SetPrintFlagNew", {wardId:Wardid, userId:LgUserID, queryTypeCode:queryTypeCode, oeoriIdStr:oeoriIdStr, dhcorePrinted:flag});
    }
    loadFrame();  //打印标记置上之后刷新Table
}
function DateDemo(){
    var d, s="";
    d = new Date();
    s += d.getDate() + "/";
    s += (d.getMonth() + 1) + "/";
    s += d.getYear();
    return(s);
}
function getRelaDate(offset)
{
	//in terms of today ,calculate the date
	var obj=new Date();
	var ms=obj.getTime();
	var offsetms=60*60*24*offset*1000;
	var newms=ms+offsetms;
	var newdate=new Date(newms);
	return formatDate(newdate);
}
function setFrameTitle(xlsSheet,titleDesc,dateTimeStr,type,Row,printList,queryTypeCode,labCount)
{
    FontStyle(xlsSheet,Row,1,5,10);//12
    xlsSheet.cells(Row,1)=titleDesc+"    "+dateTimeStr;
    return Row+1
}
function SortListByCol(list,col,ascendBool)
{   //sort list by col,ascendBool:ascend order
	var tmpList=[],i,j;
	for (i=list.length-1;i>0;i--)
	{
	    for (j=0;j<i;j++)
	    {
		    if ((list[j][col]>list[j+1][col])==ascendBool)
		    {
		    	var tmpList=list[j+1];list[j+1]=list[j];list[j]=tmpList;
		    }		     
	    }
	}
}
function AddNullListByCol(list,col)
{   //对col列不同的行之间,加入空行
	var tmpList=[],i,j;
	if (list.length<1) return tmpList;
	for (i=0;i<list.length-1;i++)
	{
		tmpList[tmpList.length]=list[i];
	    if ((list[i][col]!=list[i+1][col]))
		{
			var nullList=[]
			for (j=0;j<list[i].length;j++) nullList[nullList.length]=""
			tmpList[tmpList.length]=nullList;
		}
	}
	tmpList[tmpList.length]=list[list.length-1];
	list=[];
	list=tmpList;
	return tmpList;
}

function GetFrameMark(queryTypeCode,dataList,oeoriIdInd)
{
	var tmpList=dataList[oeoriIdInd].split("||");
	if (tmpList.length>0) return tmpList[0];
}

// excel 用到
function SetFrameData(queryTypeCode,printList,actRow,xlsSheet,xlsLeft,xlsTop,typeDesc,labNoStr,maxFrameCols,framePrint) //ypz 061128
{
    if (queryTypeCode.indexOf("JYDO")==-1) {
    	//ReplaceOreIdByOriId(printList,oeoriIdInd)
    	//MergeListByCol(printList,oeoriIdInd)
    }

    var str=serverCall("web.DHCCLCom","PatInfo",{curId:printList[0].oeoriId})
    var arr=str.split("^");//regNo_"^"_ctloc_"^"_room_"^"_sex_
	var titleDesc2="日期:"+printList[0].createDateTime+"        "+"床号:"+arr[6]+"       "+"科室:"+arr[1] ;
	var titleDesc="姓名:"+arr[4]+"   "+"登记号:"+arr[0]+"   "+"性别:"+arr[3] +"   "+"年龄:"+arr[7];
	var strdig=serverCall("web.DHCEmNurCom","GetDiagnosyy",{rowid:printList[0].oeoriId})

	var titleDesc4="诊断:"+strdig;

	xlsSheet.cells(2,1)=titleDesc2;
    xlsSheet.cells(3,1)=titleDesc;
    xlsSheet.cells(4,1)=titleDesc4;
    actRow=actRow+1
	
	gridlistRow(xlsSheet,actRow,actRow-1,1,cols);

	actRow=actRow+1;
	//title

	for (j=0;j<printDescList.length;j++) 
	{
		
		xlsSheet.cells(actRow,j+1)=printDescList[j];
	}
    for (i=0;i<=printList.length-1;i++)
    {   
		actRow=actRow+1;
	    for (j=0;j<=printVarList.length-1;j++) 
        { 
        	 str=printList[i][printVarList[j]]
        	 if(printVarList[j]=="arcimDesc"){
	        	 if(str.indexOf("______")>-1){
		         	str=str.split("______")[1];
		         }
	         }
             xlsSheet.cells(actRow,j+1)=str;  
        }
    }
	if (framePrint=="Y"){
		//gridlistRow(xlsSheet,actRow,actRow-newPrintList.length-p,1,cols);
	}
	mergcell(xlsSheet,actRow+2,1,printDescList.length)
	xlsSheet.cells(actRow+2,1)="医生:" +printList[0].ctcpDesc+"     "+ "打印日期:" + sysDate+" "+sysTime;
	actRow=eval(actRow)+1; //a blank line after frame
	xlsSheet.Columns.AutoFit();
	return actRow;
}
function MergeListByCol(list,col)
{   //merge list by col
	var tmpList=[],i,j,k=0,tmpI,tmpJ;	
	for (i=0;i<list.length;i++)
	{
		tmpI=list[i][col];
		if (col==oeoriIdInd){
			tmpList=tmpI.split("||");
			if (tmpList.length>1) tmpI=tmpList[0]+"||"+tmpList[1];
		}
	    for (j=i+1;j<list.length;j++)
	    {
			tmpJ=list[j][col];
			if (col==oeoriIdInd){
				tmpList=tmpJ.split("||");
				if (tmpList.length>1) tmpJ=tmpList[0]+"||"+tmpList[1];
			}
		    if (tmpI==tmpJ)
		    {
		    	list[j][col]="Merge Row";
		    	//tmpList=list[j+1];list[j+1]=list[j];list[j]=tmpList;
		    }		     
	    }
	}
	j=1;
	for (i=1;i<list.length;i++)	{
	    if (list[i][col]!="Merge Row"){
		    list[j++]=list[i];
	    }
	}
	for (i=list.length-1;i>=j;i--){
		list.pop()
	}
}



function PrintSeatClick()//print seat
{
   	var Card,i; 
   	Card=new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
   	for (i=0;i<selectRowDatas.length;i++){
	   	
	   	var oeoriId=selectRowDatas[i].oeoriId;
	    var PrintFlag=selectRowDatas[i].prtFlag;
	    if(PrintFlag=="Y"){continue;}
	    var str=serverCall("web.DHCNurCom","OrdPrintInfo",{oeoreIdStr:oeoriId})

        if (str!="")
        {
        	Card.xtprint="xiaotiao";//printer name
          	Card.OrderString=str;
           	Card.PrintSeat();
           	return;
        }
	}
}

// 打印检验单或者病理单
function PrintBar()//print barcode
{
    var Bar,i,j; 
    var oeoriIdStr="",LabNoStr=""; //printedLabNoStr="^"
    var selectFlag = false;
    var recLab = ""; //接收标本存储  有无检验科接收
    for (i=0;i<selectRowDatas.length;i++)
    {
        var oeoreId=selectRowDatas[i].oeoreId; // 取执行记录id
        var PrintFlag=selectRowDatas[i].prtFlag;
        var disposeStatCode=selectRowDatas[i].disposeStatCode;
        var labNo=selectRowDatas[i].labNo;
        if(labNo==undefined){
	    	labNo=""   
	    }
        if (labNo==""){
	       parent.dhccBox.message({
		    	type: 'danger',
		    	message : '有标本号为空的医嘱!'
			});   
	    	return;
	    }
        if (disposeStatCode=="UnPaid") {
	       parent.dhccBox.message({
		    	type: 'danger',
		    	message : '有未交费医嘱!不能打印!'
			});  
        	return;
        }	
        
		selectFlag = true;
		
		//判断检验科是否接受 add by linyuxu
		var ifRecLab = serverCall("web.DHCLCNUREXCUTE", "ifLabReceive", {LabEpisode:labNo});
		if (ifRecLab == 1) {
			if (recLab.indexOf(labNo) == -1) {
				if (recLab == "") {
					recLab = labNo;
				} else {
					retLab = recLab + "," + labNo;
				}
			}

			continue;
		}
		//end
        if (labNo!="") //&&(tmpList.length<2)
        {           

            if (oeoriIdStr.length==0){
	            oeoriIdStr=oeoreId
	         } 	//17-02-16
            else
            {
	            oeoriIdStr= oeoriIdStr+ "^" + oeoreId
	        }
	
			if (LabNoStr.length == 0) {
				LabNoStr = labNo;
			} else {
				LabNoStr = LabNoStr + "^" + labNo;
			}

         }
    }
    
	//add by linyuxu
	if ((oeoriIdStr == "") && (selectFlag)) {
		parent.dhccBox.message({
		    type: 'danger',
		    message : '检验号为'+ recLab + '的样本已被检验科接收,如需打印条码,请致电检验科接收室取消接收此项目'
		});  
		return;
	}
    if(!selectFlag){
	    parent.dhccBox.message({
		    type: 'danger',
		    message : '请选择需要打印的医嘱!'
		});
	    return;
	}

    var sortStr = sortByLabNo(oeoriIdStr, LabNoStr)
    var sortStrArray = sortStr.split("@");
    oeoriIdStr= sortStrArray[0];
    LabNoStr = sortStrArray[1];
    showNurseExcuteSheetPreview(oeoriIdStr, LabNoStr, "P", queryTypeCode, WebIp, "true", 1, "NurseOrderOP.xml")
   
	SetPrintFlag(oeoriIdStr, "P");
	SavePrintRecord("P", queryTypeCode, oeoriIdStr, LgUserID)	

	var ifPrintJYHZD = serverCall("web.DHCLCNURCOLUMNSETPRINT", "getIfPrintJYHZD");
	if (ifPrintJYHZD == 1) {
		var printStr = serverCall("Nur.NurseExcuteSheet", "DeleRepOrd", {OrdStr:oeoriIdStr});
		var printord = printStr.split("$");
		var PrintOeordStr = printord[0];
		var printLabStr = printord[1];
		
		//打印回执单 待加配置 qqa 2017-08-25 win10打印修改
		//DHCCNursePrintComm.showNurseExcuteSheetPreview(PrintOeordStr, printLabStr, "L", queryTypeCode, WebIp, "true", 1, "LabOrderSheet.xml");
		showNurseExcuteSheetPreview(PrintOeordStr, printLabStr, "L", queryTypeCode, WebIp, "true", 1, "LabOrderSheet.xml");

	}
	
	///qqa 2017-08-25  
    if((queryTypeCode=="BLDO")&&(LabNoStr!="")){
	   var rtn1 = serverCall("web.DHCPisApplicationSheet","UpdateTmOurINfo",LgCtLocID,LabNoStr);
	   var rtn2 = serverCalll("web.DHCPisApplicationSheet","UpdateResult1",LabNoStr);
	}
	
	//add by linyuxu
	if (recLab != "") {
		parent.dhccBox.message({
		    type: 'danger',
		    message : '检验号为'+ recLab + '的样本已被检验科接收,如需打印条码,请致电检验科接收室取消接收此项目'
		}); 
	
	}
	//end
}


// 按照执行记录id和标本号
function sortByLabNo(oeorIdStr, labNoStr) {
	var oeordIdArray = oeorIdStr.split("^")
	var labNoArray = labNoStr.split("^")
	var tmpLabNo = ""
	var tmpOeordId = "";
	var index = "";
	var tmpLabNoArray = [];
	var tmpOrderIdArray = [];
	var tmpCollectArray = [];
	for (var i = 0; i < oeordIdArray.length; i++) {
		if (!tmpCollectArray[i]) {
			tmpOrderIdArray[tmpOrderIdArray.length] = oeordIdArray[i]
			tmpLabNoArray[tmpLabNoArray.length] = labNoArray[i]
		} else {
			continue;
		}
		for (var j = i + 1; j < oeordIdArray.length; j++) {
			if ((labNoArray[i] == labNoArray[j]) && (!tmpCollectArray[j])) {
				tmpOrderIdArray[tmpOrderIdArray.length] = oeordIdArray[j]
				tmpLabNoArray[tmpLabNoArray.length] = labNoArray[j]
				tmpCollectArray[j] = 1	
			}
		}
	}
	return tmpOrderIdArray.join("^") + "@" + tmpLabNoArray.join("^")
}

// 病理单 没用
function PrintPathologyBar() //print Pathology barcode
{
    var Bar,i,j;

    if ((queryTypeCode.indexOf("BLDO")<0)) return;
    Bar= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
    Bar.PrintName="tiaoma";//printer name
    //Bar.SetBarPrint();return;
    var oeoriIdStr="";
    for (i=0;i<selectRowDatas.length;i++)
    {
        
        var oeoriId=selectRowDatas[i].oeoriId;
        var PrintFlag=selectRowDatas[i].prtFlag;
        var disposeStatCode=selectRowDatas[i].disposeStatCode;
        var labNo=selectRowDatas[i].labNo;
        var specDesc="";
        var objSpecDesc=selectRowDatas[i].specDesc;
        if ((disposeStatCode=="UnPaid")) alert(t['没有交费'])
        if ((PrintFlag!="Y")&&(disposeStatCode!="UnPaid")&&(specDesc.length>1))
        {           
            if (oeoriIdStr.length==0){oeoriIdStr=oeoriId}
            else{oeoriIdStr=oeoriIdStr+"^"+oeoriId}
            var str=serverCall("web.DHCNurCom","OrdPrintInfo",{oeoreIdStr:oeoriId})
            var arr=str.split("^");//regNo_"^"_ctloc_"^"_room_"^"_sex_"^"_pagName
            var regNo=arr[0];
            var ctloc=arr[1]; var room=arr[2];
            var reclocDesc=selectRowDatas[i].reclocDesc;
            var OrdName=""  ///reclocDesc
            var Sex=arr[3];
            var PatName=regNo+" "+arr[4]
            var Age=arr[7]
            var bedCode=arr[6]
            var patLoc=arr[1]
            var tmpList=arr[1].split("-")
            if (tmpList.length>1) patLoc=tmpList[1]
	        OrdName=serverCall("web.DHCCLCom","GetArcimShortDesc",{oeoriId:oeoriId})   
            tmpList=specDesc.split("/");
            for (j=0;j<tmpList.length;j++)
            {
	               //alert(tmpList[j]);continue;
                Bar.LabNo=labNo;
                Bar.RecLoc=reclocDesc;
                Bar.LabelDesc=tmpList[j];;
                Bar.PatLoc=patLoc;
                Bar.OrdName=OrdName;
                Bar.PatName=PatName;
                Bar.Sex=Sex;
                Bar.Age=Age;
                Bar.BedCode=bedCode;
                Bar.PrintOut(1);
            }
        }
    }	
}

function PrintSingleOrder(queryTypeCode,oeoriId)
{

	var resStr=serverCall("web.DHCNurCom","OrdPrintInfo",{oeoreIdStr:oeoriId})
	if (resStr!="")
	{
		var Card;  
		Card= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
		Card.OrderString=resStr;
		Card.SetPrint();
		if (queryTypeCode=="SYDO"){
			Card.PrintName="tiaoma";//printer name
			Card.PrintSycd();
		}
		else
		{
	   		if ((queryTypeCode.indexOf("JYDO")==-1)&&(queryTypeCode!="ZSDO")){
				Card.xtprint="xiaotiao"
				Card.PrintCureSheet();
			}
		}
	}
	else{alert(t["alert:carderr"]);return false;}  
	return true;
}


function ReplaceOreIdByOriId(list,col)
{   
	var tmpList=[],i;
	for (i=0;i<list.length;i++)	{
		if (list[i].length>col) {
			tmpList=list[i][col].split("||")
			if (tmpList.length>1) list[i][col]=tmpList[0]+"||"+tmpList[1];
	    }
	}
}


// 贴瓶签打印 没用
function PrintTPQ() {
	queryTypeCode=$("#QueryTypeCode").val();
	if(queryTypeCode.indexOf("SYDO")<0){
		parent.dhccBox.message({
		    type: 'danger',
		    message : '请选择输液单打印!'
		});
		return;	
	}
	//var objSeatNo = parent.frames["NurseTop"].document.getElementById("SeatNo");
	//if (objSeatNo) SeatNo = objSeatNo.value;
	//var objtbl = document.getElementById('tDHCNurOPExec');
	selectRowDatas=$("#execTable").dhccTableM('getSelections');
	var oeoriIdStr = "",
		seqNoStr = "",
		notFyStr = "",
		hasNotPrint = false;
	for (i = 0; i < selectRowDatas.length; i++) {
		//var check = document.getElementById('seleitemz' + i);
		var oeoriId = selectRowDatas[i].oeoreId;
		var seqNo = selectRowDatas[i].mainOeoreId;
		var PrintFlag=selectRowDatas[i].prtFlag;
		//if (check.checked == true) {

			if ((PrintFlag.indexOf("T") == -1) && (hasNotPrint == false)) hasNotPrint = true;

			//var fyFlag = serverCall("web.DHCOutPhCommon", "GetfyflagforNurse", oeoriId);
			//if (fyFlag == "0") {
				//notFyStr = "患者有未发药的医嘱,请到药房取药！";
				//continue;
			//}


			if (oeoriIdStr.length == 0) {
				oeoriIdStr = oeoriId;
			} else {
				oeoriIdStr = oeoriIdStr + "^" + oeoriId
			}
			if (seqNoStr.length == 0) {
				seqNoStr = seqNo;
			} else {
				seqNoStr = seqNoStr + "^" + seqNo
			}
		//}
	}

	if (notFyStr != "") {
		alert(notFyStr);
	}
	if (oeoriIdStr == "") {
		parent.dhccBox.message({
		    type: 'danger',
		    message : '请选择医嘱打印!'
		});
		return;
	}

	//DHCCNursePrintComm.showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, "T", queryTypeCode, WebIp, "true", 1, "NurseOrderOP.xml")
	showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, "T", queryTypeCode, WebIp, "true", 1, "NurseOrderOP.xml") //qqa 2017-08-25 win10打印
	//if (DHCCNursePrintComm.saveFlag == 1) {
		SetPrintFlag(oeoriIdStr, "T");
		SavePrintRecord("T", queryTypeCode, oeoriIdStr, LgUserID);
	//}
	//DHCCNursePrintComm.showNurseExcuteSheetPreview(oeoriIdStr,seqNoStr,"T",queryTypeCode,session['WebIP'],"true",1,"NurseOrderOPInfusionLabel.xml") 	

}

// 贴瓶签打印 在用
function PrintTPQList() {
	queryTypeCode=$("#QueryTypeCode").val();
	if(queryTypeCode.indexOf("SYDO")<0){
		parent.dhccBox.message({
		    type: 'danger',
		    message : '请选择输液单打印!'
		});
		return;	
	}
	var oeoriIdStr = "",
		seqNoStr = "";
	var notFyStr = "",disposeCodeStr = "";
		hasNotPrint = false;
	selectRowDatas=$("#execTable").dhccTableM('getSelections');
		//输液单 切换瓶签模式 add lvpeng
	if($("#c2").is(':visible')){	
		$('input[name="IfPrint"]:checked').each(function(){
			if($(this).attr('data-oeoreid').split("^").length==1){
				var oeoriIdretstr = serverCall("Nur.NurseExcuteSheet", "getOrderGroupIdStr", {orderId:$(this).attr('data-oeoreid'),queryCode:""});
				var oeoriIdretstrList = oeoriIdretstr.split("#");
				var oeoriId = oeoriIdretstrList[0];
				var seqNo = oeoriIdretstrList[1];
				if (oeoriId != "") {
					if (oeoriIdStr.length == 0) {
						oeoriIdStr = oeoriId;
					} else {
						oeoriIdStr = oeoriIdStr + "^" + oeoriId;
					}
					if (seqNoStr.length == 0) {
						seqNoStr = seqNo;
					} else {
						seqNoStr = seqNoStr + "^" + seqNo;
					}
					
				}
				
				if(disposeCodeStr.length==0){	//处置状态
		   			disposeCodeStr=$(this).attr('data-code');	
		   		}else{
			   		disposeCodeStr=disposeCodeStr+"^"+$(this).attr('data-code');
			   	}


			}else if($(this).attr('data-oeoreid').split("^").length>1){
				var arciDescArr = $(this).attr('data-arcidesc').split("^");
				for(j=0;j<$(this).attr('data-oeoreid').split("^").length;j++){
					if(arciDescArr[j].indexOf("__")!=-1) continue;
					var oeoriIdretstr = serverCall("Nur.NurseExcuteSheet", "getOrderGroupIdStr", {orderId:$(this).attr('data-oeoreid').split("^")[j],queryCode:""});
					var oeoriIdretstrList = oeoriIdretstr.split("#");
					var oeoriId = oeoriIdretstrList[0];
					var seqNo = oeoriIdretstrList[1];
	   				if (oeoriId != "") {
						if (oeoriIdStr.length == 0) {
							oeoriIdStr = oeoriId;
						} else {
							oeoriIdStr = oeoriIdStr + "^" + oeoriId;
						}
						if (seqNoStr.length == 0) {
							seqNoStr = seqNo;
						} else {
							seqNoStr = seqNoStr + "^" + seqNo;
						}

					}
					
					if(disposeCodeStr.length==0){	//处置状态
		   				disposeCodeStr=$(this).attr('data-code');	
		   			}else{
			   			disposeCodeStr=disposeCodeStr+"^"+$(this).attr('data-code');
			   		}
					
				}
					
			}
		
		})
		if (oeoriIdStr == "") {
			parent.dhccBox.message({
		    	type: 'danger',
		    	message : '请选择需要打印的医嘱!'
			});
			return;
		}
		
		var codelist=disposeCodeStr.split("^");
    	var chargeflag=""
    	for(var k=0;k<codelist.length;k++){
	    	if(codelist[k]=="UnPaid"){
		    	chargeflag="Y";
	    	}
		}
		
		TreatQueue();     //输液队列
		
		if(chargeflag=="Y"){
			dhccBox.confirm("提示","包含未缴费的医嘱,是否继续打印？","exec-print",function(result){
				showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, "T", queryTypeCode, WebIp, "true", 1, "NurseOrderOP.xml")	//qqa 2017-08-25 win10打印
				SavePrintRecord("T", queryTypeCode, oeoriIdStr, LgUserID);
				SetPrintFlag(oeoriIdStr, "T");
			})
		}else{
			showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, "T", queryTypeCode, WebIp, "true", 1, "NurseOrderOP.xml")  //qqa 2017-08-25 win10打印
			SavePrintRecord("T", queryTypeCode, oeoriIdStr, LgUserID);			
			SetPrintFlag(oeoriIdStr, "T");
		}	
	}else{
	
		for (i = 0; i < selectRowDatas.length; i++) {
			var oeoriId = selectRowDatas[i].oeoreId;
			if(selectRowDatas[i].arcimDesc.indexOf("______")!="-1") continue;
			var printFlag = selectRowDatas[i].prtFlag;
			var seqNo = selectRowDatas[i].mainOeoreId;
			var disposeStatCode =selectRowDatas[i].disposeStatCode; //处置状态
			if (oeoriId != "") // 界面上勾选后 oeoriId 才不为空
			{
				if ((getParam(printFlag).indexOf("T") == -1) && (hasNotPrint == false)) hasNotPrint = true;
			}
			
			var oeoriIdretstr = serverCall("Nur.NurseExcuteSheet", "getOrderGroupIdStr", {orderId:oeoriId,queryCode:""});
			var oeoriIdretstrList = oeoriIdretstr.split("#");
			var oeoriId = oeoriIdretstrList[0];
			var seqNo = oeoriIdretstrList[1];
			if (oeoriId != "") {
				if (oeoriIdStr.length == 0) {
					oeoriIdStr = oeoriId;
				} else {
					oeoriIdStr = oeoriIdStr + "^" + oeoriId;
				}
				if (seqNoStr.length == 0) {
					seqNoStr = seqNo;
				} else {
					seqNoStr = seqNoStr + "^" + seqNo;
				}
			}
			
			if (disposeCodeStr.length== 0){ //处置状态
		        disposeCodeStr = disposeStatCode;
		    }else{
				disposeCodeStr = disposeCodeStr + "^" + disposeStatCode; 
			}
		}
		
		
		if (notFyStr != "") {
			alert(notFyStr);
		}

		if (oeoriIdStr == "") {
			parent.dhccBox.message({
			    	type: 'danger',
			    	message : '没有需要打印的医嘱,请选择医嘱!'
			});
			return;
		}
		//TreatQueueFn(false);

		var codelist=disposeCodeStr.split("^");
	    var chargeflag=""
	    for(var k=0;k<codelist.length;k++){
		    if(codelist[k]=="UnPaid"){
			    chargeflag="Y";
		    }
		}
		
		TreatQueue();   //排队
		
		if(chargeflag=="Y"){
			dhccBox.confirm("提示","包含未缴费的医嘱,是否继续打印？","exec-print",function(result){
				showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, "T", queryTypeCode, WebIp, "true", 1, "NurseOrderOP.xml");  //qqa 2017-08-25 win10打印
				SavePrintRecord("T", queryTypeCode, oeoriIdStr, LgUserID);
				SetPrintFlag(oeoriIdStr, "T");
			})// confirm end
		}else{
			showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, "T", queryTypeCode, WebIp, "true", 1, "NurseOrderOP.xml");   //qqa 2017-08-25 win10打印
			SavePrintRecord("T", queryTypeCode, oeoriIdStr, LgUserID);
			SetPrintFlag(oeoriIdStr, "T");
		}
	}
}

function TreatQueue(){
		ClientID=serverCall("web.DHCEMNurTreatQueue", "getClientId", { client:serverName});
 		runClassMethod("web.DHCNurTreatQueue",
		"InsertQueue",
		{QueueUserLocDr:LgCtLocID,
		 QueueUserId:LgUserID,
		 TreatAdmDr:$("#EpisodeID").val(),
		 ClientID:ClientID,
		 TreatReportType:$("#QueryTypeCode").val(),
		 RegNo:$("#RegNo").val(),
		 QueueType:3,
		 ServerName:serverName},
		function(ret){
			if (ret != 0) {
				//window.parent.dhccBox.alert(ret);
			}else{
				window.parent.dhccBox.message({message : '排队成功!'})
				window.parent.searchPatTreat();
					
			}
			
		},
		"text")	

}
// 治疗
function TreatQueueFn(alertFlag) {
	//var ClientTyp = "";
	var regNo = parent.frames["NurseTop"].document.getElementById("regNo").value;
	var TreatAdmDr = 0,
		insertTreatFlag = false;
	var objtbl = document.getElementById('tDHCNurOPExec');
	for (var i = 1; i < objtbl.rows.length; i++) {

		var check = document.getElementById('seleitemz' + i);
		var oeoriId = document.getElementById('oeoriIdz' + i).innerText;
		var comparId = oeoriId.split("||")[0];
		//var oeoriId = serverOrderID[i];
		//var tmpOrderDataList = serverOrderData[i].split("^");


		if (check.checked == true) {
			if (oeoriId != "") {
				var ExecStat = document.getElementById('disposeStatDescz' + i).innerText;
				if ((ExecStat == "已执行") || (ExecStat == "停止执行")) {
					//输液单没有未执行的不插入队列
				} else {
					if (TreatAdmDr < comparId) {
						TreatAdmDr = comparId; //取就诊最近的一次
					}
				}
			}
		}

	}
	TreatAdmDr = tkMakeServerCall("Nur.Infusion.DHCIFWorkLoad", "getAdmByOrdId", TreatAdmDr);
	if (TreatAdmDr == "") {
		if (alertFlag != false) {
			alert("请选择一条医嘱!");
		}
		return;
	}

	if (true) {
		var userId = session['LOGON.USERID'];
		var locId = session['LOGON.CTLOCID'];
		var parr = "TreatLocDr|" + locId + "^TreatRecUser|" + userId + "^TreatQueState|Wait^TreatQuePrior|2^TreatQueDate|^TreatQueTime|" + "^TreatQueueCat|" + ClientTyp + "^TreatReportType|" + queryTypeCode + "^RegNo|" + regNo;
		var resStr = tkMakeServerCall("User.DHCNurTreatQueue", "Save", "", parr);
		if (resStr != 0) {
			if (alertFlag != false) {
				alert(resStr);
			}
			return;
		} else {
			var regNo = parent.frames["NurseTop"].document.getElementById("regNo").value;

			//DHCCNursePrintComm.showOtherSingleSheet(regNo + "$" + TreatAdmDr + "$" + session['LOGON.CTLOCID'], "BedCard", session['WebIP'], "NurseOrderOP.xml");
			showOtherSingleSheet(regNo + "$" + TreatAdmDr + "$" + LgCtLocID, "BedCard", WebIp, "NurseOrderOP.xml");
			//PrintQueueNo(TreatAdmDr, locId, ClientId)
			if (parent.parent.frames["TreatLeft"]) {
				parent.parent.frames["TreatLeft"].RefreshFn();
			}
			var curAdm = tkMakeServerCall("Nur.Infusion.DHCIFWorkLoad", "getCurrAdm", regNo);
			if (queryTypeCode == "SYDO") {
				//插入工作量
				if (ClientTyp == "T1") {
					var ret = tkMakeServerCall("Nur.Infusion.DHCIFWorkLoad", "InsertWork", curAdm, 5, session['LOGON.USERID'], session['LOGON.CTLOCID'], 0, "O");
				} else {
					var ret = tkMakeServerCall("Nur.Infusion.DHCIFWorkLoad", "InsertWork", curAdm, 5, session['LOGON.USERID'], session['LOGON.CTLOCID'], 0, "E");
				}
			}
		}
	}
}

function PrintClick()
{
    queryTypeCode=$("#QueryTypeCode").val();
    hopid=$("#hospId").val();
    //startDate=$("#exeDate").getDate(); 
	//endDate=$("#exeDate").getDate();
    selectRowDatas=$("#execTable").dhccTableM('getSelections');
    
    //sysDate=serverCall("web.DHCNurCom","Getsysdate")
	//sysTime=serverCall("web.DHCNurCom","Getsystime")
    
    if ((queryTypeCode=="Default")) {
	    parent.dhccBox.message({
		    type: 'danger',
		    message : '全部医嘱不打印!'
		    });
	    return;
	}
       

    printTitleStr=serverCall("web.DHCEMNurExe","GetPrintTitle",{queryTypeCode:hopid+"@"+queryTypeCode});

    printTitleList=printTitleStr.split("^")
    printDescList=printTitleList[0].split("|")
    printLenList=printTitleList[1].split("|")
	printVarList=printTitleList[2].split("|")
	if(printTitleStr.length==2){
		parent.dhccBox.message({
		    type: 'danger',
		    message : '未定义该医嘱类型的查询显示项!'
		  });
		return false;	
	}
	
	var Card,i;  
    if (queryTypeCode.indexOf("JYDO")>-1){
	    if (ifPrintBar=="Y") {
		   //var truthBePrint = window.confirm("是否打印标签?");
	       //if(truthBePrint){PrintBar();}
	       PrintBar();
	    }
	    return;
    }
	if (queryTypeCode.indexOf("BLDO")>-1)
	{   
	    if (ifPrintBar=="Y"){PrintBar();}
    	return ;  
	}
	
	if ((queryTypeCode.indexOf("JYDO")<0)) {
		PrintExecSheet();
 		return;
	}
	//输液卡的打印和检验单的	检验取单条打印设置(ifPrintLabNote)
    if (((queryTypeCode=="SYDO")&&(ifPrintTransfusionCard=="Y"))||((queryTypeCode.indexOf("JYDO")>-1)&&(ifPrintLabNote=="Y")))
    {
        Card= new ActiveXObject("PrintBar.PrnBar");
    }
 

    var oeoriIdStr="";
    var oeoriIdArr=[];
	for (i=0;i<selectRowDatas.length;i++)
    {
		
	    var oeoriId=selectRowDatas[i].oeoriId;
	    var PrintFlag=selectRowDatas[i].prtFlag;
	    if(PrintFlag=="Y"){continue}
           
	        var arcimDesc=selectRowDatas[i].arcimDesc;
		 	var tmpList=arcimDesc.split("____");
		 	if ((tmpList.length<2)||(queryTypeCode=="PSDO")){
               	oeoriIdArr.push(oeoriId)
 				var str=serverCall("web.DHCNurCom","OrdPrintInfo",{oeoreIdStr:oeoriId})
				if (str!=""){
	           		if ((queryTypeCode=="SYDO")&&(ifPrintTransfusionCard=="Y")){
		           		Card.PrintName="tiaoma";//printer name
    	           		Card.OrderString=str;
        	       		Card.SetPrint();
            	   		Card.PrintSycd();
	           		}
               	}
		 
	    }
	}
	oeoriIdStr=oeoriIdArr.join("^");
	if (oeoriIdStr=="") return;
	if ((queryTypeCode.indexOf("JYDO")>-1)&&(ifPrintLabNote=="Y"))
   	{	
   		var str=serverCall("web.DHCNurCom","OrdPrintInfo",{oeoreIdStr:oeoriIdStr})
		Card.xtprint="xiaotiao";//printer name
    	Card.OrderString=str;
        Card.SetPrint();
   		Card.PrintLabNote();
	}
}

// 执行并打印 护士站在用的
function ExecuteClick(needPrint) {
 	var DrugCell = ""; // + wxl 090301
 	var objDrugCell = document.getElementById("DrugCell");
 	if (objDrugCell) DrugCell = objDrugCell.value;
 	if (((queryTypeCode == "SYDO") || (queryTypeCode == "ZSDO")) && (DrugCell == "")) {
 		
 	}
 	var obj = document.getElementById("OrdExecute");
 	if (obj) {
 		obj.disabled = true;
 		obj.onclick = function() {
 			return false;
 		}
 	}
 	var obj = document.getElementById("executeOnly");
 	if (obj) {
 		obj.disabled = true;
 		obj.onclick = function() {
 			return false;
 		}
 	}
 	//alert("ok");return;
 	if (queryTypeCode == "Default") return;
 	var userId = session['LOGON.USERID'];
 	var ctlocId = session["LOGON.CTLOCID"];

 	var objtbl = document.getElementById('tDHCNurOPExec');
 	var updateOrdGroup = document.getElementById("UpdateOrdGroup").value;
 	var oeoreParaStr, flag, oeoriIdStr = "",
 		exeResult = false;
 	var objPrintSeat = document.getElementById("printSeat");
 	var objSeatNo = parent.frames["NurseTop"].document.getElementById("SeatNo");
 	if (objSeatNo) var SeatNo = objSeatNo.value;
 	else var SeatNo = "";
 	oeoreParaStr = "";
 	var excuteAndPrintFlag = "";
 	if (needPrint == true) {
 		excuteAndPrintFlag = 1
 	}
 	for (var i = 1; i < objtbl.rows.length; i++) {
 		var item = document.getElementById("seleitemz" + i);
 		var execDateTime = document.getElementById("execDateTimez" + i).innerText;
 		if ((item.checked == true) && (execDateTime == " ")) {
 			disposeStatCode = document.getElementById("disposeStatCodez" + i).innerText
 			if (disposeStatCode == "UnPaid") {
 				alert(t['alert:ExecPaid']);
 				self.location.reload();
 				return;
 			}
 			var arcimDesc = document.getElementById("arcimDescz" + i).innerText;
 			var tmpList = arcimDesc.split("____");
 			if (tmpList.length < 2) {
 				if ((queryTypeCode.indexOf("JYDO") > -1)) {
 					var obj = document.getElementById("placerNoz" + i);
 					if (obj) {
 						var placerNo = obj.value;
 					}
 				}
 				var basedose = "";
 				var obj = document.getElementById("doseQtyUnitz" + i)
 				if (obj) basedose = obj.innerText;
 				var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
 				var sttDateTime = document.getElementById("sttDateTimez" + i).innerText;
 				if ((sttDateTime == " ")) {
 					alert(t['alert:setSttDateTime']);
 					return false;
 				} //ypz 060430
 				oeoreParaStr = oeoreParaStr + "^" + basedose + "!" + oeoriId + "!!" + i;
 				if (oeoriIdStr.length == 0) {
 					oeoriIdStr = oeoriId;
 				} else {
 					oeoriIdStr = oeoriIdStr + "^" + oeoriId
 				}
 				flag = 1
 				if ((queryTypeCode != "SYDO") || (!objPrintSeat)) {
 					var resStr, printed = false;

 					var userId = session['LOGON.USERID'];
 					var curExecStatDesc = t['val:finish']; //stat.options[index].text;
 					if ((disposeStatCode != "Immediate") && (disposeStatCode != "LongNew") && (disposeStatCode != "Temp") && (disposeStatCode != "TempTest") && (disposeStatCode != "Discontinue") && (disposeStatCode != "Needless") && (disposeStatCode != "SkinTestNorm") && (disposeStatCode != "SkinTest")) {} else {
 						var ordstat = document.getElementById("ordStatDescz" + i).innerText;
 						if (ordstat == t['var:dischOrder']) {} //
 						else {
 							var flag = 1; //SeatNo="";

 							//resStr=cspRunServerMethod(updateOrdGroup,sttDateTime,oeoriId+"^"+SeatNo+"^"+ctlocId+"^^"+queryTypeCode,userId,flag);
 							resStr = cspRunServerMethod(updateOrdGroup, sttDateTime, oeoriId + "^" + SeatNo + "^" + ctlocId + "^^" + queryTypeCode + "^^^" + DrugCell, userId, flag, 1); //+ wxl 090301
 							if (resStr == "0") {
 								exeResult = true;
 							} else {
 								alert(resStr);
 								exeResult = false;
 							}
 						}
 					}

 				}
 			}
 		}
 	}
 	if (oeoreParaStr == "") return;
 	//alert(oeoreParaStr)
 	/*if ((queryTypeCode.indexOf("JYDO")>-1)&&(oeoriIdStr!="")) //print lab note
    {	
        Card= new ActiveXObject("PrintBar.PrnBar");
        var ordPrintInfo=document.getElementById("OrdPrintInfo").value;
   	    var str=cspRunServerMethod(ordPrintInfo,oeoriIdStr,"false");
	    Card.xtprint="xiaotiao";//printer name
    	Card.OrderString=str;
        Card.SetPrint();
	    Card.PrintLabNote();
		//PrintBar();//print barcode//ypz placer unuse
	    return;//placerno: keep to see result, not refresh
	}*/
 	var objRegNo = parent.frames["NurseTop"].document.getElementById("regNo")
 	var objPatMainInfo = parent.frames["NurseTop"].document.getElementById("patMainInfo")
 	if ((queryTypeCode != "SYDO") || (!objPrintSeat)) {
 		if (exeResult) {
 			alert(t['alert:success']);
 			if (needPrint) {
 				PrintClick();
 				self.location.reload()
 					// setTimeout('parent.frames["NurseTop"].ClearScreen();',1000); //ypz 081216
 			} else self.location.reload();
 		}
 		self.location.reload();
 		return;
 	}
 	oeoreParaStr = escape(oeoreParaStr);
 	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOPExecAdmin" + "&execData=" + oeoreParaStr;
 	//window.open(lnk,"Order_Exec","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=300,width=400,top=100,left=300");
 	var ifSuccess = window.showModalDialog(lnk, window, "dialogWidth:400px;status:no;dialogHeight:300px");
 	//alert(ifSuccess)
 	if ((ifSuccess) && (needPrint)) PrintClick();

 	if (needPrint) {
 		if (objRegNo) objRegNo.value = "";
 		if (objPatMainInfo) objPatMainInfo.value = "";
 		parent.frames["NurseTop"].ClearScreen();
 	}
 	self.location.reload();
 }

// 保存打印记录
function SavePrintRecord(printType, queryTypeCode, OrderStr, UserId) {
	var ModelName;
	if (printType == "P") {		// 按条码
		ModelName = "DHCNurIPExecP"; ///模块代码，DHC_EventModel表中Code
	} else if (printType == "PAT") {	//按病人
		ModelName = "DHCNurIPExecPAT";	
	} else if (printType == "S") {	// 按输液卡
		ModelName = "DHCNurIPExecS";
	} else if (printType == "T") {	//按瓶签
		ModelName = "DHCNurIPExecT";
	} else if (printType == "WARD") {	//按病区
		ModelName = "DHCNurIPExecWARD";
	}
	var SecretCode = ""
	var ret = serverCall("web.DHCCLCom", "SaveRecord", {ModelName:ModelName, ConditionStr:OrderStr, printType:printType, queryTypeCode:queryTypeCode, SecretCode:SecretCode, UserId:UserId})
		//alert(ret)
}

///封装clickonce调用方法
///20170727 Songchao add by qqa 2017-08-25 win10打印
function showNurseExcuteSheetPreview(orderItemIdStr, seqNoStr, type, queryCode, webIp, savePrintHistory, printNum, xmlName) {
	var link = ""
		link = webIp + "/DHCMG/NurseExcute/DHCCNursePrintComm.application?method=showNurseExcuteSheetPreview&orderItemIdStr=" + orderItemIdStr
		 + "&seqNoStr=" + seqNoStr + "&type=" + type + "&queryCode=" + queryCode + "&webIp=" + webIp
		 + "&savePrintHistory=" + savePrintHistory + "&printNum=" + printNum + "&xmlName=" + xmlName;

    window.open(link,"正在打印...", 'height=20, width=30, top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
}

///clickOnce打印方式
///20170724 songchao
function showOtherSingleSheet(orderItemIdStr, seqNoStr, webIp,  xmlName){
	var link = ""
		link = webIp + "/DHCMG/NurseExcute/DHCCNursePrintComm.application?method=showOtherSingleSheet&orderItemIdStr=" + orderItemIdStr
		 + "&seqNoStr=" + seqNoStr  + "&webIp=" + webIp + "&xmlName=" + xmlName;
	//if(parent.parent.frames["TRAK_main"]){
	//	parent.parent.frames["TRAK_main"].location = link;
	//}else{
		window.open(link,"", 'height=20, width=30, top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
	//}
}


//公共方法，为undefined返回空
function getParam(param){
	return typeof param=="undefined"?"":param
	}
	