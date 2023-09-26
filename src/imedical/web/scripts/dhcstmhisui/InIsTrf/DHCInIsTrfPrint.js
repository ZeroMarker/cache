function PrintInIsTrf(Init, AutoFlag) {
	if(PrintMethod==0){
		LodopPrintInIsTrf(Init, AutoFlag);
	}else{
		RQPrintInIsTrf(Init, AutoFlag);
	}
}

function PrintInIsTrfHVCol(Init, AutoFlag) {
	if(PrintMethod==0){
		LodopPrintInIsTrfHVCol(Init, AutoFlag);
	}else{
		RQPrintInIsTrfHVCol(Init, AutoFlag);
	}
}

function PrintInIsTrfReturn(Init, AutoFlag) {
	if(PrintMethod==0){
		LodopPrintInIsTrfReturn(Init, AutoFlag);
	}else{
		RQPrintInIsTrfReturn(Init, AutoFlag);
	}
}

function PrintInIsTrfReturnHVCol(Init, AutoFlag) {
	if(PrintMethod==0){
		LodopPrintInIsTrfReturnHVCol(Init, AutoFlag);
	}else{
		RQPrintInIsTrfReturnHVCol(Init, AutoFlag);
	}
}


//���ⵥLodop��ӡ
function LodopPrintInIsTrf(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	//��ȡ��ӡ�������Ƿ�Ԥ����ӡ�������ӡ��־�ʹ���
	var PrintNum = parseInt(InitParamObj.PrintNum);
	var IndirPrint = InitParamObj.IndirPrint;
	//��־�ʹ�������
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	Common_PrintLog('T', Init, AutoFlag, PrintNum);
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	},false);
	var DetailData=GetDetailDataInIs(Init,"T"); //��ϸ��Ϣ
	var FrLocDesc=MainObj.InitFrLoc.Description;
	var ToLocDesc=MainObj.InitToLoc.Description;
	var InitNo=MainObj.InitNo;
	var InitReqUser=MainObj.InitReqUser.Description;
	var InitDate=MainObj.InitDate;
	var InitUser=MainObj.InitUser.Description;
	var InitAckUser=MainObj.InitAckUserName;
	var PrintDate=DateFormatter(new Date());
	//������Ϣչʾ
	var TaskName="���ⵥ��ӡ";  //��ӡ��������
	//������Ϣ
	var Title=FrLocDesc+"���ⵥ"; 
	//ҳü��Ϣ
	var Head="���տ���:"+ToLocDesc+"      "
			+"���ⵥ��:"+InitNo+"      "
			+"�Ƶ�����:"+PrintDate;
	//ҳβ��Ϣ
	var Foot="��ӡ����:"+PrintDate+"          "
			+"�Ƶ�:"+InitUser+"          "
			+"���:"+InitAckUser+"          "
			+"����:"+InitReqUser;
	//��ϸ��Ϣչʾ
	var Cols=[
	{field:"Num",title:"���",width:"25px",align:"center"},
	{field:"InciCode",title:"���ʴ���",width:"10%",align:"left"},
	{field:"InciDesc",title:"��������",width:"13%",align:"left"},
	{field:"Spec",title:"���",width:"7%",align:"left"},
	{field:"SterilizedBat",title:"�������",width:"10%",align:"left"},
	{field:"UomDesc",title:"��λ",width:"5%",align:"left"},
	{field:"Qty",title:"����",width:"5%",align:"right",format:"#,##0.00"},
	{field:"BatExp",title:"����~Ч��",width:"15%",align:"left"},
	{field:"Rp",title:"����",width:"7%",align:"right",format:"#,##0.00"},
	{field:"RpAmt",title:"���۽��",width:"10%",align:"right",format:"#,##0.00",sum:"Y"},
	{field:"SpecDesc",title:"������",width:"10%",align:"left"},
	{field:"ManfDesc",title:"����",width:"10%",align:"left"}
//	{field:"Sp",title:"�ۼ�",width:"100px",align:"right",format:"#,##0.00"},
//	{field:"SpAmt",title:"�ۼ۽��",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
	];
	PrintDocument(PrintNum,IndirPrint,TaskName,Title,Head,Foot,Cols,DetailData)
}
//��ֵ���ⵥLodop��ӡ
function LodopPrintInIsTrfHVCol(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	//��ȡ��ӡ�������Ƿ�Ԥ����ӡ�������ӡ��־�ʹ���
	var PrintNum = parseInt(InitParamObj.PrintNum);
	var IndirPrint = InitParamObj.IndirPrint;
	//��־�ʹ�������
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	Common_PrintLog('T', Init, AutoFlag, PrintNum);
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	},false);
	var DetailData=GetHVColDetailData(Init,"T"); //��ϸ��Ϣ
	var FrLocDesc=MainObj.InitFrLoc.Description;
	var ToLocDesc=MainObj.InitToLoc.Description;
	var InitNo=MainObj.InitNo;
	var InitReqUser=MainObj.InitReqUser.Description;
	var InitDate=MainObj.InitDate;
	var InitUser=MainObj.InitUser.Description;
	var InitAckUser=MainObj.InitAckUserName;
	var PrintDate=DateFormatter(new Date());
	//������Ϣչʾ
	var TaskName="��ֵ���ⵥ��ӡ";  //��ӡ��������
	//������Ϣ
	var Title=FrLocDesc+"���ⵥ"; 
	//ҳü��Ϣ
	var Head="���տ���:"+ToLocDesc+"      "
			+"���ⵥ��:"+InitNo+"      "
			+"�Ƶ�����:"+PrintDate;
	//ҳβ��Ϣ
	var Foot="��ӡ����:"+PrintDate+"          "
			+"�Ƶ�:"+InitUser+"          "
			+"���:"+InitAckUser+"          "
			+"����:"+InitReqUser;
	//��ϸ��Ϣչʾ
	var Cols=[
		{field:"Num",title:"���",width:"25px",align:"center"},
		{field:"InciCode",title:"���ʴ���",width:"10%",align:"left"},
		{field:"InciDesc",title:"��������",width:"13%",align:"left"},
		{field:"Spec",title:"���",width:"7%",align:"left"},
		{field:"SterilizedBat",title:"�������",width:"10%",align:"left"},
		{field:"UomDesc",title:"��λ",width:"5%",align:"left"},
		{field:"Qty",title:"����",width:"5%",align:"right",format:"#,##0.00"},
		{field:"BatExp",title:"����~Ч��",width:"15%",align:"left"},
		{field:"Rp",title:"����",width:"7%",align:"right",format:"#,##0.00"},
		{field:"RpAmt",title:"���۽��",width:"10%",align:"right",format:"#,##0.00",sum:"Y"},
		{field:"SpecDesc",title:"������",width:"10%",align:"left"},
		{field:"ManfDesc",title:"����",width:"10%",align:"left"}
	//	{field:"Sp",title:"�ۼ�",width:"100px",align:"right",format:"#,##0.00"},
	//	{field:"SpAmt",title:"�ۼ۽��",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
		];
	PrintDocument(PrintNum,IndirPrint,TaskName,Title,Head,Foot,Cols,DetailData)
}
//�˿ⵥLodop��ӡ
function LodopPrintInIsTrfReturn(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	//��ȡ��ӡ�������Ƿ�Ԥ����ӡ�������ӡ��־�ʹ���
	var PrintNum = parseInt(InitParamObj.PrintNum);
	var IndirPrint = InitParamObj.IndirPrint;
	//��־�ʹ�������
	if (isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	Common_PrintLog('T', Init, AutoFlag, PrintNum);
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	},false);
	var DetailData=GetDetailDataInIs(Init,"K"); //��ϸ��Ϣ
	var FrLocDesc=MainObj.InitFrLoc.Description;
	var ToLocDesc=MainObj.InitToLoc.Description;
	var InitNo=MainObj.InitNo;
	var InitReqUser=MainObj.InitReqUser.Description;
	var InitDate=MainObj.InitDate;
	var InitUser=MainObj.InitUser.Description;
	var PrintDate=DateFormatter(new Date());
	//������Ϣչʾ
	var TaskName="�˿ⵥ��ӡ";  //��ӡ��������
	//������Ϣ
	var Title=ToLocDesc+"�˿ⵥ"; 
	//ҳü��Ϣ
	var Head="�˿����:"+FrLocDesc+"      "
			+"�˿ⵥ��:"+InitNo+"      "
			+"�Ƶ�����:"+PrintDate;
	//ҳβ��Ϣ
	var Foot="��ӡ����:"+PrintDate+"          "
			+"���:"+"          "
			+"�˿���:"+"          "
			+"�Ƶ���:"+InitUser;
	//��ϸ��Ϣչʾ
	var Cols=[
		{field:"Num",title:"���",width:"25px",align:"center"},
		{field:"InciCode",title:"���ʴ���",width:"10%",align:"left"},
		{field:"InciDesc",title:"��������",width:"13%",align:"left"},
		{field:"Spec",title:"���",width:"7%",align:"left"},
		{field:"SterilizedBat",title:"�������",width:"10%",align:"left"},
		{field:"UomDesc",title:"��λ",width:"5%",align:"left"},
		{field:"Qty",title:"����",width:"5%",align:"right",format:"#,##0.00"},
		{field:"BatExp",title:"����~Ч��",width:"15%",align:"left"},
		{field:"Rp",title:"����",width:"7%",align:"right",format:"#,##0.00"},
		{field:"RpAmt",title:"���۽��",width:"10%",align:"right",format:"#,##0.00",sum:"Y"},
		{field:"SpecDesc",title:"������",width:"10%",align:"left"},
		{field:"ManfDesc",title:"����",width:"10%",align:"left"}
	//	{field:"Sp",title:"�ۼ�",width:"100px",align:"right",format:"#,##0.00"},
	//	{field:"SpAmt",title:"�ۼ۽��",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
		];
	PrintDocument(PrintNum,IndirPrint,TaskName,Title,Head,Foot,Cols,DetailData)
}
//��ֵ�˿ⵥLodop��ӡ
function LodopPrintInIsTrfReturnHVCol(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	//��ȡ��ӡ�������Ƿ�Ԥ����ӡ�������ӡ��־�ʹ���
	var PrintNum = parseInt(InitParamObj.PrintNum);
	var IndirPrint = InitParamObj.IndirPrint;
	//��־�ʹ�������
	if (isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	Common_PrintLog('T', Init, AutoFlag, PrintNum);
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	},false);
	var DetailData=GetHVColDetailData(Init,"K"); //��ϸ��Ϣ
	var FrLocDesc=MainObj.InitFrLoc.Description;
	var ToLocDesc=MainObj.InitToLoc.Description;
	var InitNo=MainObj.InitNo;
	var InitReqUser=MainObj.InitReqUser.Description;
	var InitDate=MainObj.InitDate;
	var InitUser=MainObj.InitUser.Description;
	var PrintDate=DateFormatter(new Date());
	//������Ϣչʾ
	var TaskName="��ֵ�˿ⵥ��ӡ";  //��ӡ��������
	//������Ϣ
	var Title=ToLocDesc+"�˿ⵥ"; 
	//ҳü��Ϣ
	var Head="�˿����:"+FrLocDesc+"      "
			+"�˿ⵥ��:"+InitNo+"      "
			+"�Ƶ�����:"+PrintDate;
	//ҳβ��Ϣ
	var Foot="��ӡ����:"+PrintDate+"          "
			+"���:"+"          "
			+"�˿���:"+"          "
			+"�Ƶ���:"+InitUser;
	//��ϸ��Ϣչʾ
	var Cols=[
		{field:"Num",title:"���",width:"25px",align:"center"},
		{field:"InciCode",title:"���ʴ���",width:"10%",align:"left"},
		{field:"InciDesc",title:"��������",width:"13%",align:"left"},
		{field:"Spec",title:"���",width:"7%",align:"left"},
		{field:"SterilizedBat",title:"�������",width:"10%",align:"left"},
		{field:"UomDesc",title:"��λ",width:"5%",align:"left"},
		{field:"Qty",title:"����",width:"5%",align:"right",format:"#,##0.00"},
		{field:"BatExp",title:"����~Ч��",width:"15%",align:"left"},
		{field:"Rp",title:"����",width:"7%",align:"right",format:"#,##0.00"},
		{field:"RpAmt",title:"���۽��",width:"10%",align:"right",format:"#,##0.00",sum:"Y"},
		{field:"SpecDesc",title:"������",width:"10%",align:"left"},
		{field:"ManfDesc",title:"����",width:"10%",align:"left"}
	//	{field:"Sp",title:"�ۼ�",width:"100px",align:"right",format:"#,##0.00"},
	//	{field:"SpAmt",title:"�ۼ۽��",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
		];
	PrintDocument(PrintNum,IndirPrint,TaskName,Title,Head,Foot,Cols,DetailData)
}

function GetDetailDataInIs(Init,InitType) {
	if (isEmpty(Init)) {
		return;
	}
	var Params = JSON.stringify({Init:Init,InitType:InitType});
	var jsonData = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
		QueryName: 'DHCINIsTrfD',
		Params: Params,
		rows:99999
	},false);
	var DetailData=jsonData.rows;
	return DetailData;
}

function GetHVColDetailData(Init,InitType) {
	if (isEmpty(Init)) {
		return;
	}
	var Params = JSON.stringify({Init:Init,InitType:InitType});
	var jsonData = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
		QueryName: 'QueryHVColDetail',
		Params: Params,
		rows:99999
	},false);
	var DetailData=jsonData.rows;
	return DetailData;
}

function RQPrintInIsTrf(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var InitObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	},false);
	var FrLocId = InitObj['InitFrLoc']['RowId'];
	var ScgId = InitObj['ScgId'];
	if(isEmpty(FrLocId)){
		return;
	}
	var PrintMode = GetPrintMode(FrLocId, ScgId);
	var RaqName = 'DHCSTM_HUI_InIsTrf_Common.raq';
	if(PrintMode == 'MO'){
		RaqName = 'DHCSTM_HUI_InIsTrf_MO_Common.raq';
	}
	///var Params = JSON.stringify({Init:Init});
	var Params="";
	var RQInitStr = Init;
	var DirectPrintStr = '{' + RaqName + '(Params=' + Params + ';Init=' + Init +';RQInitStr=' + RQInitStr + ')}';
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	for (var i = 1; i <= PrintNum; i++) {
		if (InitParamObj.IndirPrint != 'N') {
			DHCSTM_DHCCPM_RQPrint(RQPrintStr);
		} else {
			DHCCPM_RQDirectPrint(DirectPrintStr);
		}
		Common_PrintLog('T', Init, AutoFlag);
	}
	//��ӡ��ǩ
	//PrintItmLabel(Init);
}

/*
 * ��ӡ��ֵ����
 */
function RQPrintInIsTrfHVCol(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var RaqName = 'DHCSTM_HUI_InIsTrfHVCol_Common.raq';
	//var Params = JSON.stringify({Init:Init});
	var Params = "";
	var RQInitStr = Init;
	var DirectPrintStr = '{' + RaqName + '(Params=' + Params + ';Init=' + Init +';RQInitStr=' + RQInitStr + ')}';
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	for (var i = 1; i <= PrintNum; i++) {
		if (InitParamObj.IndirPrint != 'N') {
			DHCSTM_DHCCPM_RQPrint(RQPrintStr);
		} else {
			DHCCPM_RQDirectPrint(DirectPrintStr);
		}
		Common_PrintLog('T', Init, AutoFlag);
	}
}

/*
 * ��ӡ�˿ⵥ
 */
function RQPrintInIsTrfReturn(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var InitObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	},false);
	var ToLocId = InitObj['InitToLoc']['RowId'];
	var ScgId = InitObj['ScgId'];
	if(isEmpty(ToLocId)){
		return;
	}
	var PrintMode = GetPrintMode(ToLocId, ScgId);
	var RaqName = 'DHCSTM_HUI_InIsTrfRet_Common.raq';
	if(PrintMode == 'MO'){
		RaqName = 'DHCSTM_HUI_InIsTrfRet_MO_Common.raq';
	}
	//var Params = JSON.stringify({Init:Init, InitType:'K'});
	var Params = ""; 
	var RQInitStr = Init+"^K";
	var DirectPrintStr = '{' + RaqName + '(Params=' + Params + ';Init=' + Init +';RQInitStr=' + RQInitStr + ')}';
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	for (var i = 1; i <= PrintNum; i++) {
		if (InitParamObj.IndirPrint != 'N') {
			DHCSTM_DHCCPM_RQPrint(RQPrintStr);
		} else {
			DHCCPM_RQDirectPrint(DirectPrintStr);
		}
		Common_PrintLog('T', Init, AutoFlag);
	}
}

/*
 * ��ӡ�˿ⵥ(��ֵ����)
 */
function RQPrintInIsTrfReturnHVCol(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var RaqName = 'DHCSTM_HUI_InIsTrfRetHVCol_Common.raq';
	//var Params = JSON.stringify({Init:Init, InitType:'K'});
	var Params = "";
	var RQInitStr = Init+"^K";
	var DirectPrintStr = '{' + RaqName + '(Params=' + Params + ';Init=' + Init + ';RQInitStr=' + RQInitStr + ')}';
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	for (var i = 1; i <= PrintNum; i++) {
		if (InitParamObj.IndirPrint != 'N') {
			DHCSTM_DHCCPM_RQPrint(RQPrintStr);
		} else {
			DHCCPM_RQDirectPrint(DirectPrintStr);
		}
		Common_PrintLog('T', Init, AutoFlag);
	}
}
