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
/*
* @creator: huxt 2019-11-24
* @desc: 退药单打印入口
*/
function PrintReturnCom(pharet, reprint){
	if (pharet==""){
		return;
	}
	PrintReturn(pharet);
}

/*
* @creator: huxt 2019-11-24
* @desc: 使用xml模板打印
*/
function PrintReturn(pharet){
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: 'PHAIPReturn',
		dataOptions: {
			ClassName: 'web.DHCSTPHARETURN',
			MethodName: 'GetRetPrintDataByNo',
			PhaRet: pharet
		},
		listColAlign: {retQty:'right', sp:'right', spAmt:'right'},
		preview:true,
		aptListFields: ["label17", "userName", "label19", "acceptUser", 'label21', 'spAmtSum', 'label23', 'sysDT'],
		listBorder: {style:4, startX:1, endX:190}
	});
}


function PrintReturnBeforeExec(){
}
function PrintReturnTotal(){
}
function GetReturnMainData(){
}
function GetReturnDetailData(pid,pidi){
	var returndetaildata=tkMakeServerCall("web.DHCSTPHARETURN","ListRet","","",pid,pidi);
	return returndetaildata;
}
function KillTmpAfterPrint(pid){
	tkMakeServerCall("web.DHCSTPHARETURN","killRetTmpAfterPrint",pid)
}
function GetPrintPath(){
	var prnpath=tkMakeServerCall("web.DHCSTCOMWEB", "GetPrintPath") ;
	if(prnpath.substring(prnpath.length,prnpath.length-1)!="\\"){prnpath=prnpath+"\\"}
	return prnpath	
}
