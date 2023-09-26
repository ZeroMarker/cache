var myData=new Array();
var myColumns=new Array();
var queryTypeCode=$("#QueryTypeCode").val();

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

var serverName=window.parent.serverName
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
	var  oeoreIdStr=checkSelectOrd();  //获取打印数据
	var stDate=window.parent.StartDate;
	var endDate=window.parent.EndDate;
	
	var params = "^"+LgHospID+"^"+stDate+"^"+endDate;
	nurPrintExecForm(oeoreIdStr,queryTypeCode,params);
	//window.open("dhcem.nurprinthtml.csp?orders="+oeoreIdStr+"&queryType="+queryTypeCode+"&params="+params);
	return;
	
}
//打印 保存 打印标记
function PrintSaveExec(oeoriIdStr,seqNoStr){
		selectRow=$("#execTable").datagrid("getSelections").length
		totalRow=$("#execTable").datagrid("getRows").length
		var type=selectRow==totalRow?"PATALL":"PAT";
		showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, type, queryTypeCode, WebIp, "true", 1, "NurseOrderOP.xml"); //qqa 2017-08-25 win10打印
		SetPrintFlag(oeoriIdStr, "Y");
		SavePrintRecord("PAT", queryTypeCode, oeoriIdStr, LgUserID)	
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
    search();  //打印标记置上之后刷新Table
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
			parent.$.messager.alert('提示',"有标本号为空的医嘱!");  
	    	return;
	    }
        if (disposeStatCode=="UnPaid") {
	        parent.$.messager.alert('提示',"有未交费医嘱!不能打印!"); 
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
					recLab = recLab + "," + labNo;
				}
			}
			continue;
		}
		
        if (labNo!=""){   
            if (oeoriIdStr.length==0){
	            oeoriIdStr=oeoreId
	        } else{
	            oeoriIdStr= oeoriIdStr+ "^" + oeoreId
	        }
			if (LabNoStr.length == 0) {
				LabNoStr = labNo;
			}else {
				LabNoStr = LabNoStr + "^" + labNo;
			}
         }
    }
    
	if ((oeoriIdStr == "") && (selectFlag)) {
		parent.$.messager.alert('提示','检验号为'+ recLab + '的样本已被检验科接收,如需打印条码,请致电检验科接收室取消接收此项目');   
		return;
	}
    if(!selectFlag){
	    parent.$.messager.alert('提示','请选择需要打印的医嘱!');   
	    return;
	}

    var sortStr = sortByLabNo(oeoriIdStr, LabNoStr)
    var sortStrArray = sortStr.split("@");
    oeoriIdStr= sortStrArray[0];
    LabNoStr = sortStrArray[1];
    
    if((PRINTBLISDOC!=1)&&(queryTypeCode.indexOf("BL")!=-1)){
		newPrintXmlModeDoc(oeoriIdStr,LabNoStr,"P",queryTypeCode);
	}else{
		newPrintXmlMode(oeoriIdStr,LabNoStr,"P",queryTypeCode);
	}
    return;
  
    showNurseExcuteSheetPreview(oeoriIdStr, LabNoStr, "P", queryTypeCode, WebIp, "true", 1, "NurseOrderOP.xml")
   
	SetPrintFlag(oeoriIdStr, "P");
	SavePrintRecord("P", queryTypeCode, oeoriIdStr, LgUserID)	

	var ifPrintJYHZD = serverCall("web.DHCLCNURCOLUMNSETPRINT", "getIfPrintJYHZD");
	if ((ifPrintJYHZD == 1)&&(queryTypeCode.indexOf("JYD"))!=-1) {
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
		parent.$.messager.alert('提示','检验号为'+ recLab + '的样本已被检验科接收,如需打印条码,请致电检验科接收室取消接收此项目');   
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

// 贴瓶签打印 在用
function PrintTPQList() {
	queryTypeCode=$("#QueryTypeCode").val();
	if(queryTypeCode.indexOf("SYDO")<0){
		//parent.$.messager.alert('提示',"请选择输液单打印!");  
		//return;	
	}
	var oeoriIdStr = "",
		seqNoStr = "";
	var notFyStr = "",disposeCodeStr = "";
		hasNotPrint = false;
	selectRowDatas=$("#execTable").datagrid('getSelections');

	var oeoriIdStr="",seqNoStr="",chargeflag="";
	if($("#c2").is(':visible')){	
		$('input[name="IfPrint"]:checked').each(function(){
			var mainOrderID=$(this).attr('data-oeoreid').split("^")[0];
			var oeoriIdretstr = serverCall("Nur.NurseExcuteSheet", "getOrderGroupIdStr", {orderId:mainOrderID,queryCode:""});
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
		})
		
		var codelist=disposeCodeStr.split("^");
    	for(var k=0;k<codelist.length;k++){
	    	if(codelist[k]=="UnPaid"){
		    	chargeflag="Y";
	    	}
		}
	}else{
		for (i = 0; i < selectRowDatas.length; i++) {
			var oeoriId = selectRowDatas[i].oeoreId;
			var mainOeoreId = selectRowDatas[i].mainOeoreId;
			if(mainOeoreId.indexOf(oeoriId)==-1) continue;
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
		
		var codelist=disposeCodeStr.split("^");
	    
	    for(var k=0;k<codelist.length;k++){
		    if(codelist[k]=="UnPaid"){
			    chargeflag="Y";
		    }
		}
	}
	
	if (oeoriIdStr == "") {
		parent.$.messager.alert('提示',"没有需要打印的医嘱,请选择医嘱!");
		return;
	}
	
	if(chargeflag=="Y"){
		parent.$.messager.confirm('提示','包含未缴费的医嘱,是否继续打印',function(r){
			if (r){
				newPrintXmlMode(oeoriIdStr,seqNoStr,"T",queryTypeCode);
				queryTypeCode.indexOf("SYD")!=-1?TreatQueue():"";     //输液队列
			}
		});
	}else{
		newPrintXmlMode(oeoriIdStr,seqNoStr,"T",queryTypeCode);
		queryTypeCode.indexOf("SYD")!=-1?TreatQueue():"";     //输液队列
	}	
	
}

function TreatQueue(){
	
		ClientID=serverCall("web.DHCEMNurTreatQueue", "getClientId", { client:serverName});
 		$.ajax({
			url : "websys.Broker.cls", 
			data : {
					ClassName:"web.DHCNurTreatQueue",
					MethodName:"InsertQueue",
					QueueUserLocDr:LgCtLocID,
					QueueUserId:LgUserID,
					TreatAdmDr:$("#EpisodeID").val(),
					ClientID:ClientID,
					TreatReportType:$("#QueryTypeCode").val(),
					RegNo:$("#RegNo").val(),
					QueueType:3,
					ServerName:serverName
				   }, 
			success : function(ret){ 
					if (ret != 0) {
						console.log(ret);
					}else{
						parent.$.messager.alert('提示','排队成功!');
						window.parent.searchPatSY();
						window.parent.searchPatTreat();	
					}
          	}	 
		}); 

}

function PrintClick()
{
    queryTypeCode=$("#QueryTypeCode").val();
    hopid=$("#hospId").val();
    selectRowDatas=$("#execTable").datagrid('getSelections');

    if ((queryTypeCode=="Default")) {
		parent.$.messager.alert('提示',"全部医嘱不打印!");    
	    return;
	}
       

    printTitleStr=serverCall("web.DHCEMNurExe","GetPrintTitle",{queryTypeCode:LgHospID+"@"+queryTypeCode});

    printTitleList=printTitleStr.split("^")
    printDescList=printTitleList[0].split("|")
    printLenList=printTitleList[1].split("|")
	printVarList=printTitleList[2].split("|")
	if(printTitleStr.length==2){
		parent.$.messager.alert('提示',"未定义该医嘱类型的查询显示项!");  
		return false;	
	}
	
	var Card,i;  
    if (queryTypeCode.indexOf("JYDO")>-1){
	    if (ifPrintBar=="Y") {
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


//公共方法，为undefined返回空
function getParam(param){
	return typeof param=="undefined"?"":param
}



function newPrintXmlMode(oreDatas,mainOreDatas,type,queryTypeCode){
	var parLimit=String.fromCharCode(2);
	var tmpName="";
	if(type=="P") {
		PRINTTMTYPE==1?tmpName="DHCEM_NurLisTM":tmpName="DHCEM_NurLisTMS";
	}
	if(type=="T") tmpName="DHCEM_NurTPQ";
	var printData="";
	runClassMethod("web.DHCEMNurPrintHtml","GetPrintDataXml",{"OreDatas":oreDatas,"MainOreDatas":mainOreDatas,"QueryCode":queryTypeCode},function(jsonString){
		printData=jsonString;
	},'text',false)
	if (printData=="") return;
	
	var myPara="";
	var LODOP = getLodop();
	LODOP.PRINT_INIT("CST PRINT");
	DHCP_GetXMLConfig("InvPrintEncrypt",tmpName);
	var printDataArr=printData.split("#");

	for (i in printDataArr){
		var itmDataArr=printDataArr[i].split("^");
		var myPara="";
		for (j in itmDataArr){
			if(myPara==""){
				myPara=itmDataArr[j].split("@")[0]+parLimit+itmDataArr[j].split("@")[1];
			}else{
				myPara=myPara+"^"+itmDataArr[j].split("@")[0]+parLimit+itmDataArr[j].split("@")[1];
			}
		}
		DHC_CreateByXML(LODOP,myPara,"",[],"PRINT-CST-NT");  //MyPara 为xml打印要求的格式
		LODOP.NEWPAGE();
	}
	var printRet = LODOP.PRINT();
	if(printRet){
		SetPrintFlag(oreDatas, type);
		SavePrintRecord(type, queryTypeCode, oreDatas, LgUserID)	
	}
	return;
}	

function newPrintXmlModeDoc(oreDatas,mainOreDatas,type,queryTypeCode){
	var oreDataArr=oreDatas.split("^");
	for(i in oreDataArr){
		var oeoreId=oreDataArr[i];
		var oeoriId=oeoreId.split("||")[0]+"||"+oeoreId.split("||")[1];
		PrintBarCode(oeoriId,"")
	}
	SetPrintFlag(oreDatas, type);
	SavePrintRecord(type, queryTypeCode, oreDatas, LgUserID);
	return;
}

