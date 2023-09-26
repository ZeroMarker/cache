document.write("<object id='objPrintPreview' style='display:none' classid='../service/lablis/DHCLabtrakReportPrint.dll#DHCLabtrakReportPrint.DHCLabtrakReportPrint' VIEWASTEXT/>")
document.write("</object>");
//var gUsercode=session['LOGON.USERCODE'];  
var gUsercode="127001";
var PatientID="";
var tEpisodeID="";  
var Search="";
$(function(){

	GetPatId(); //拿到病人的id 

	initTable();  //
	
	//初始化科室下拉列表
	initCombobox();
	
	//绑定方法
	initMethod();
})

function initCombobox(){
//web.DHCEMPatCheckOut&MethodName=getAdmList
	$('#selCondition').dhccSelect({
		data:[{"id":"0","text":"全部"},{"id":"N","text":"无结果"},{"id":"Y","text":"有结果"}],
		minimumResultsForSearch:-1
	})

	runClassMethod("web.DHCEMPatCheckOut","getAdmList",
	{"PatientID":"3858388"},
	function(data){
		//alert($("#selDivision"));
		$("#selDivision").dhccSelect({
			data:data,
			minimumResultsForSearch:-1
		});
	},"json",false);
	
}


function initTable(){
	var columns = [
	{checkbox:true},
	{ field: 'OEOrdItemID', title: '医嘱id',align: 'center'},
	{ field: 'OrdItemName', title: '医嘱名称'},
	{ field: 'OrdItemDate', title: '申请日期'},
	{ field: 'OrdItemTime', title: '申请时间'},
	{ field: 'ResultStatus', title: '结果状态',align:'center',formatter:seeCheRst},
	{ field: 'AllPreRst', title: '历次结果',align:'center',formatter:preAllRst}, 
	//{ field: 'AuthDateTcime', title: '未知',align: 'center'},
	{ field: 'LabEpisode', title: '检验号',align: 'center'}, 
	{ field: 'LabTestSetRow', title: '报告id',align: 'center'}, 
	{ field: 'OrdSpecimen', title: '标本',align: 'center'},
	{ field: 'SpecDate', title: '采集日期',align: 'center'},
	{ field: 'SpecTime', title: '采集时间',align: 'center'},
	{ field: 'RecDate', title: '接收日期',align: 'center'},
	{ field: 'RecTime', title: '接受时间',align: 'center'},
	{ field: 'AuthDate', title: '报告日期',align: 'center'},
	{ field: 'AuthTime', title: '报告时间',align: 'center'},
	{ field: 'PreReport', title: '预报告',align: 'center'},
	{ field: 'ReadFlag', title: '阅读',align:'center',formatter:readRstView},
	{ field: 'WarnComm', title: '危急提示',align: 'center'},
	{ field: 'TSResultAnomaly', title: '异常状态',align: 'center'},
	{ field: 'TSMemo', title: '标本提示',align: 'center'},
	{ field: 'AdmNo', title: '就诊号',align: 'center'},
	{ field: 'AdmDate', title: '就诊日期',align: 'center'},
	{ field: 'AdmLoc', title: '就诊科室',align: 'center'},
	{ field: 'AdmType', title: '就诊类型',align: 'center'}
	//{ field: 'OrdNotes', title: '未知',align: 'center'}
];
	
	//alert(Search);
	$('#sampleArrTable').dhccTable({
		//height:window.parent.tabHeight-115,
		height:$(window).height()-110,
		pageSize:15,
		pageList:[50,100],
		pagination:true,
		columns:columns,
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckOut&MethodName=QueryOrderList',
		queryParam:{
			//EpisodeID:1297227,
			//PatientID:4006306,
			EpisodeID:154,
			PatientID:125,
			Search:Search
		}
	
	})
}

function initMethod(){
	$('#AdmDateAll').bind('click',FindOrderDateAll)	;
	$('#AdmDate90').bind('click',FindOrderDate90)	;
	$('#AdmDat180').bind('click',FindOrderDate180)	;
	$('#AdmDate360').bind('click',FindOrderDate365)	;
	$('#priViewBtn').bind('click',PrintPreview);
	$('#priRepBtn').bind('click',SelectPrint);
	$('#priRstBtn').bind('click',PrintEMR);
	$('#selBtn').bind('click',FindOrder);
	//$('#selCondcition').change(function(){
	//	alert("1");
	//})
	$('#selDivision').on('select2:select', function (evt) {
		//alert("");
		//alert($(this).val()); //获取选中元素的value值
		FindOrderAdmID();	
	});
	$('#selCondition').on('select2:select', function (evt) {
		//alert("");
		//alert($(this).val()); //获取选中元素的value值
		FindOrderAdmID();	
	});
}

function FindOrderAdmID()
{
	//alert(tEpisodeID);
	AdmDateType=0; //为0查询所有
	if ($("#selCondition").val()==""||$("#selCondition").val()=="0"){  //下拉中选项的内容
		FindOrderDateAll() ;    
	} else {
		var tEpisodeID=$('#selDivision').val();
		FindOrder();
	}
	return;

}




function FindOrderDate90()
{
	AdmDateType=1;
	FindOrder();
	return;
}
function FindOrderDate180()
{
	AdmDateType=2;
	FindOrder();
	return;
}
function FindOrderDate365()
{
	AdmDateType=3;
	FindOrder();
	return;
}
function FindOrderDateAll()
{
	//alert("");
	AdmDateType=4;
	FindOrder();
	return;
}

function FindOrder(){
	var Include="N"
	if (AdmDateType=="1") {tEpisodeID=""; Include="Y"} 
	if (AdmDateType=="2") {tEpisodeID=""; Include="Y"} 
	if (AdmDateType=="3") {tEpisodeID=""; Include="Y"} 
	if (AdmDateType=="4") {tEpisodeID=""; Include="Y"} 
	Search = "^^^"+$("#selCondition").val()+"^"+Include+"^"+AdmDateType;
	//alert(Search);
	$('#sampleArrTable').dhccQuery({
		query:{
			//"EpisodeID":1297227,
			//"PatientID":4006306,
			"EpisodeID":154,
			"PatientID":125,
			"Search":Search
		}
//EpisodeID=1837864&PatientID=3858388'
	})
	//AdmDateType==""; 
	return;
}


function GetPatId(){
	if(RegNo==""){
		PatientID="";	
	}else if(RegNo.length<8){
		for(i=RegNo.length;i<8;i++){
			RegNo="0"+RegNo
		}	
	}
	PatientID=MyRunClassMethod("web.patcheckout","GetPatIdByNo",{"RegNo":RegNo});  //通过病人Reg，取到病人ID
}


//调用后台方法     
function MyRunClassMethod(ClassName,MethodName,Datas){
   Datas=Datas||{};
   var RtnStr = "";
   runClassMethod(ClassName,MethodName,
   Datas,
   function (data){
	  	RtnStr=data;
	  },
	"text",false
	);
	return RtnStr;
}


function PrintPreview(){
   var ifrm,itbl,LabOeordRowidStr="";
   itbl=$('#sampleArrTable').dhccTableM('getSelections');
   if (itbl.length==0) {return}
   if (itbl) {
	  	for (var curr_row=0; curr_row<itbl.length; curr_row++) {
			var objSelectItem=itbl[curr_row];
			var TSRowId=objSelectItem.LabTestSetRow;
			TSRowId=TSRowId.replace(",","#");
			if (TSRowId) LabOeordRowidStr=LabOeordRowidStr+"^"+TSRowId;
		}
   }
  
  	if (LabOeordRowidStr=="") return;
    connectString= MyRunClassMethod("web.DHCLabRptPrintConfig","GetWebConnString");
  	if (connectString=="") return;
    userCode=gUsercode;
    param="";
    if (LabOeordRowidStr) objPrintPreview.PrintPreview(LabOeordRowidStr, userCode, param, connectString);
}

function SelectPrint(){
   var ifrm,itbl,LabOeordRowidStr="";
    itbl=$('#sampleArrTable').dhccTableM('getSelections');
   if (itbl.length==0) {return}
   if (itbl) {
	  	for (var curr_row=0; curr_row<itbl.length; curr_row++) {
			//var objSelectItem=document.getElementById("Selectz"+curr_row);
			var objSelectItem=itbl[curr_row];
			//var TSRowId=document.getElementById("LabTestSetRowz"+curr_row).value;   //Hide
			//var TSRowId="这是我的第一个打印";
			var TSRowId=objSelectItem.LabTestSetRow;
			//var TSRowId=document.getElementById("LabTestSetRowz"+curr_row).innerText;
			TSRowId=TSRowId.replace(",","#");
			if (TSRowId) LabOeordRowidStr=LabOeordRowidStr+"^"+TSRowId;
		}
   }
 
	if (LabOeordRowidStr=="") return;
	//var GetReportNoMethod=document.getElementById('getWebConnString').value;  //
    connectString= MyRunClassMethod("web.DHCLabRptPrintConfig","GetWebConnString");
	//alert(connectString);
	//connectString = cspRunServerMethod(GetReportNoMethod);
  	if (connectString=="") return;
    userCode=gUsercode;
    param="";
    //connectString = "cn_iptcp:127.0.0.1[1972]:DHC-APP";
    if (LabOeordRowidStr) objPrintPreview.PrintOut(LabOeordRowidStr, userCode, param, connectString);  
}

function PrintEMR(){
	EpisodeID = "1297227";	
	if (EpisodeID=="") {return ;}
	var AmdId=EpisodeID;
	//var AmdId="1297227";
    var xlApp,obook,osheet,xlsheet,xlBook
	var path
	
	//var getpath=document.getElementById('getpath');
	//if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	//path=cspRunServerMethod(encmeth,'','');
	path = MyRunClassMethod("web.UDHCJFCOMMON","getpath",{"itmjs":"","itmjsex":""});
	var fileName=path+"DHCLabResultEMR.xls";
	alert(fileName);
	//var GetResults=document.getElementById('getResultsByAdm');
	//if (GetResults) {var encmeth=GetResults.value} else {var encmeth=''};
	//var RetVal=cspRunServerMethod(encmeth,'','',AmdId);
	var RetVal = MyRunClassMethod("web.DHCLabResultEMR","getResultsByAdm",{"itmjs":"","itmjsex":"","AmdID":AmdId});
	alert(RetVa);
	var tmpVal=RetVal.split("^");
	var num=tmpVal[0];
	if (num==0) {return ;}
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(fileName);
	xlsheet = xlBook.ActiveSheet;

	var z,row,j,SumData;
	row=3;
	xlsheet.cells(row,1)=tmpVal[1];   
	row=row+1;
	var TSRowIDLists=tmpVal[2].split("#");
	
	for(z=1;z<=num;z++){
		var TSRowID=TSRowIDLists[z-1];	
		var RetStr = MyRunClassMethod("web.DHCLabResultEMR","getDate",{"itmjs":"","itmjsex":"","LabTestSetRow":TSRowID});
		var pRetValues=RetStr.split("||");
		SumData=pRetValues[0];
		var pDataList=pRetValues[1].split('@@');
		for(j=1;j<=SumData;j++){
			var pData=pDataList[j-1].split('^');
			row=row+1;
			if (pData[0]==2) {
	   			mergcell(xlsheet,row,1,6)
		        xlsheet.cells(row,1)=pData[1];   
		        gridlist(xlsheet,row,row,1,6);
			}
			if (pData[0]==3) {
		        xlsheet.cells(row,1)=pData[1];    
		        xlsheet.cells(row,2)=pData[2];    
		        xlsheet.cells(row,3)=pData[3]; 
		        xlsheet.cells(row,4)=pData[4]; 
		        xlsheet.cells(row,5)=pData[5];  
		        xlsheet.cells(row,6)=pData[6];  
			}
			if (pData[0]==4) {
		        xlsheet.cells(row,1)=pData[1];    
		        xlsheet.cells(row,3)=pData[2]; 
			}

			if (pData[0]==5) {
	   			mergcell(xlsheet,row,1,6)
		        xlsheet.cells(row,1)=pData[1];    
		        gridlist(xlsheet,row,row,1,6);
			}
		}
	}		

    xlApp.Visible=true;
    xlsheet.PrintPreview();
    xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    xlsheet=null	


}




//formatter测试跳转
function seeCheRst(value,rowDate,rowIndex){
	//alert(value);//
	//alert(rowDate.ResultStatus);
	//alert(rowDate.OEOrdItemID);
	var ordItemId1=rowDate.OEOrdItemID.split("||")[0];
	var ordItemId2=rowDate.OEOrdItemID.split("||")[1];
	//alert(ordItemId1+":"+ordItemId2);
	if(rowDate.ResultStatus=="Y"){
		if(rowDate.TSResultAnomaly=="0"){
			return "<a style='color:blue;font-size:16px' href='javascript:void(ReportView("+rowDate.LabTestSetRow+","+ordItemId1+","+ordItemId2+"))'><i class='fa fa-exclamation-triangle' aria-hidden='true'></i>结果</a>";
		}
		if(rowDate.TSResultAnomaly=="1"){
			return "<a style='color:red;font-size:16px' href='javascript:void(ReportView("+rowDate.LabTestSetRow+","+ordItemId1+","+ordItemId2+"))'><i class='fa fa-exclamation-triangle' aria-hidden='true'></i>结果</a>";	return "<a style='color:red;font-size:16px' href='javascript:void(ReportView())'>结果</a>";
		}
	}else{
		return "-"
	}
}
function readRstView(value,rowDate,rowIndex){
	var readFlag = MyRunClassMethod("web.DHCLabReportControl","ReportViewLog",{"requestId":rowDate.OEOrdItemID})
	var ordItmId1 =rowDate.OEOrdItemID.split("||")[0];
	var ordItmId2 =rowDate.OEOrdItemID.split("||")[1];
	//alert();
	//if(readFlag=="100"){
	return "<a href='javascript:void(readForword("+ordItmId1+","+ordItmId2+"))'><i class='fa fa-book fa-lg' aria-hidden='true'></i>阅读</a>"
	//}
}

function readForword(ordItemId1,ordItemId2){
	//alert(ordItemId);
	var p1 = ordItemId1+"||"+ordItemId2;
	//p1="1880741||10";
	alert(p1);
	var url='websys.default.csp?WEBSYS.TCOMPONENT=MRAdm.ResultAuditView&RequestiD='+p1+'&ComponentID=1403';
	//var url='websys.default.csp?RequestiD=1285041||2&ComponentID=1403';
	//alert(url);

	option={
		title:'阅读',
		type:2,
		shadeClose:true,
		shade:0.8,
		area:['950px','500px'],
		content:url
	}
	//?PatientBanner=1&PatientID=4006306&TestSetRow='+p1+'OrderID='+rowDate.OEOrdItemID
	window.parent.layer.open(option);
	return false;
}


function ReportView(p1,ordItmId1,ordItemId2){

	var ordItemId = ordItmId1+"||"+ordItemId2;
	alert(ordItemId);
	var url='dhclabdoctorreport.csp?PatientBanner=1&PatientID=4006306&TestSetRow='+p1+'&OrderID='+ordItemId;
	alert(url);
	option={
		title:'结果查看',
		type:2,
		shadeClose:true,
		shade:0.8,
		area:['950px','500px'],
		content:url
	}
	//?PatientBanner=1&PatientID=4006306&TestSetRow='+p1+'OrderID='+rowDate.OEOrdItemID
	window.parent.layer.open(option);
	return false;
}

function preAllRst(value,rowDate,rowIndex){
	var ordItemId1=rowDate.OEOrdItemID.split("||")[0];
	var ordItemId2=rowDate.OEOrdItemID.split("||")[1];
	return "<a style='color:blue;font-size:16px' href='javascript:void(allRstPre("+rowDate.LabTestSetRow+","+ordItemId1+","+ordItemId2+"))'><i class='fa fa-line-chart' aria-hidden='true'></i></a>";
}
function allRstPre(p1,ordItmId1,ordItemId2){

	var ordItemId = ordItmId1+"||"+ordItemId2;
	//alert(ordItemId);
	var url='dhclabviewoldresult.csp?PatientBanner=1&PatientID=4006306&TestSetRow='+p1+'&OrderID='+ordItemId;
	alert(url);
	option={
		title:'结果查看',
		type:2,
		shadeClose:true,
		shade:0.8,
		area:['950px','500px'],
		content:url
	}
	//?PatientBanner=1&PatientID=4006306&TestSetRow='+p1+'OrderID='+rowDate.OEOrdItemID
	window.parent.layer.open(option);
	return false;
}