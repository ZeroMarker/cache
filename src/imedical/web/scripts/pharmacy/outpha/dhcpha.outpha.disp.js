/*
 *模块:门诊药房
 *子模块:门诊药房-直接发药
 *createdate:2016-09-05
 *creator:dinghongying
 */
 DHCPHA_CONSTANT.DEFAULT.PHLOC = "";
 DHCPHA_CONSTANT.DEFAULT.PHUSER = "";
 DHCPHA_CONSTANT.DEFAULT.PHPYUSER = "";
 DHCPHA_CONSTANT.DEFAULT.PHWINDOW = "";
 DHCPHA_CONSTANT.DEFAULT.CYFLAG = "";
 DHCPHA_CONSTANT.DEFAULT.OweDisp = "";
 DHCPHA_CONSTANT.VAR.TIMER = "";
 DHCPHA_CONSTANT.VAR.TIMERSTEP = 1000;
 DHCPHA_CONSTANT.VAR.OUTPHAWAY = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetWayIdByCode", "OA");
 var Com_CardPayFlag = tkMakeServerCall("PHA.FACE.IN.Com", "GetCardPayFlag", DHCPHA_CONSTANT.SESSION.GROUP_ROWID,DHCPHA_CONSTANT.SESSION.GHOSP_ROWID);
 var PrintType="";
 var FocusFlag="";
 var PartPiedDispFlag=""
 var readCardFlag=0;
 var tipNum=0;
 var changeFlag=0;
 var HttpSrc="";
 var ChkUnFyThisLocFlag="";
 var OnlyDispByPatNoFlag = "";
 var curPatNo = "";
 if (websys_isIE) {  //卡消费的条码验证仅限ie浏览器加载
	 document.write("<script type='text/javascript' src='../scripts/dhcbill/plugin/bluebird/bluebird.min.js'></script>");
 }
 
 $(function () {
	 
	 var ctloc = DHCPHA_CONSTANT.DEFAULT.LOC.text;
	 $("#currentctloc").text(ctloc)
	 /* 初始化插件 start*/
	 var daterangeoptions={
		 singleDatePicker:true
	 }
	 $("#date-start").dhcphaDateRange(daterangeoptions);
	 $("#date-end").dhcphaDateRange(daterangeoptions);
	 var tmpstartdate = FormatDateT("t-2")
	 $("#date-start").data('daterangepicker').setStartDate(tmpstartdate);
	 $("#date-start").data('daterangepicker').setEndDate(tmpstartdate);
 	 CheckPermission();
	 InitGridWin();
	 InitFYWin();
	 InitGridDisp();
	 InitGirdDispDetail();
	 InitBasicLoc();
	 InitSpecial();
	 InitFYSTAFF();
	 InitGirdWAITFY();
	 InitConfig();	//初始化配置
	 /* 表单元素事件 start*/
	 //登记号回车事件
	 $('#txt-patno').on('keypress', function (event) {
		 if (window.event.keyCode == "13") {
			 var patno = $.trim($("#txt-patno").val());
			 if (patno != "") {
				 var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				 $(this).val(newpatno);
				 if(newpatno==""){return;}
				 QueryGridDisp();
			 }
		 }
	 });
	 //卡号回车事件
	 $('#txt-cardno').on('keypress', function (event) {
		 if (window.event.keyCode == "13") {
			 var cardno = $.trim($("#txt-cardno").val());
			 
			 if (cardno != "") {
				 readCardFlag=1
				 BtnReadCardHandler();
			 }
		 }
	 });
	 //单机恢复条码 回车事件
	 $('#txt-recoverBarCode').on('keypress', function (event) {
		 if (window.event.keyCode == "13") {
			 
			 var barCodeInfo = $.trim($("#txt-recoverBarCode").val());
			 if (barCodeInfo != "") {				
				 QueryGridDisp();
			 }
			 
		 }
		 
	 });
	 $("#txt-recoverBarCode").attr("style","display:none;");
	 $('#chk-recover').on('ifChanged',function(checked){
		 if ($(this).is(':checked') == true) {
			 $("#txt-recoverBarCode").attr("style","display:inline-block;");
		 }else{
			 $("#txt-recoverBarCode").attr("style","display:none;");
		 }
	 
	 });
	 //屏蔽所有回车事件
	 $("input[type=text]").on("keypress", function (e) {
		 if (window.event.keyCode == "13") {
			 return false;
		 }
	 })
	 /* 表单元素事件 end*/
 
 
	 /* 绑定按钮事件 start*/
	 $("#a-refresh").on("click", QueryGridWaitFY)
	 $("#btn-find").on("click", QueryGridDisp);
	 $("#btn-clear").on("click", ClearConditions);
	 $("#btn-change").on("click", function () {
		 $("#modal-windowinfo").modal('show');
	 });
	 $("#btn-fy").on("click",function(){
		 CACert("PHAOPExecuteFY",ExecuteFY)
	 });
	 $("#btn-reffy").on("click", ExecuteRefuseFY);
	 $("#btn-cancelreffy").on("click", CancelRefuseFY);
	 $("#btn-allfy").on("click",function(){
		 CACert("PHAOPExecuteAllFY",ExecuteAllFY)
	 });
	 $('#btn-print').bind("click", PrintHandler);
	 $('#btn-printlabel').on("click", RePrintLabelHandler);
	 $("#btn-win-sure").on("click", FYWindowConfirm);
	 $("#btn-cardpay").on("click", function(){
		 if(Com_CardPayFlag!="Y") {return}  //防止快捷键
		 CardBillClick();
	 })
	 
 
	 $("#btn-readcard").on("click", BtnReadCardHandler); //读卡
	 $("#btn-redir-return").on("click", function () {
		 var lnk = ChangeCspPathToAll("dhcpha/dhcpha.outpha.return.csp");
		 websys_createWindow(lnk, $g("退药"), "width=95%,height=75%")
		 //window.open(lnk,"_target","width="+(window.screen.availWidth-50)+",height="+(window.screen.availHeight-100)+ ",left=0,top=0,menubar=no,status=yes,toolbar=no,resizable=yes") ;
	 });
	 $("#modal-prescinfo .close").on("click", function () {
		 hide();
	 })
 //	$("#a-changegrid").on("click",function(){		
 //		var _opt={
 //			gridName:"grid-dispdetail",
 //			initGrid:InitGirdDispDetail,
 //			changFlag:changeFlag,
 //			gridHeight:DhcphaJqGridHeight(2, 3) * 0.5
 //		};
 //		InitJqGirdPrescDetail(_opt);
 //		changeFlag=changeFlag+1;
 //	});
	 $("#a-changegrid").on("click", function(){
		 $('.js-pha-orders-preview').toggle();
		 var _opt={
			 gridName:"grid-dispdetail",
			 changFlag:changeFlag
		 };
		 QueryDetailOrders(_opt);
		 changeFlag=changeFlag+1;
	 });
	 $('#pha-orders-preview').css('height',(DhcphaJqGridHeight(2, 3) * 0.5)+34);
 
	 /* 绑定按钮事件 end*/
	 InitBodyStyle();
	 //DHCPHA_CONSTANT.VAR.TIMER = setInterval("QueryGridWaitFY();", DHCPHA_CONSTANT.VAR.TIMERSTEP);
	 $("#modal-windowinfo").on('shown.bs.modal', function () {
		 $('input[type=checkbox][name=dhcphaswitch]').bootstrapSwitch({
			 onText: $g("有人"),
			 offText: $g("无人"),
			 onColor: "success",
			 offColor: "default",
			 size: "small",
			 onSwitchChange: function (event, state) {
				 var ret = ChangeWinStat(state);
				 if (ret == false) {
					 $(this).bootstrapSwitch('state', !state, true);
				 }
			 }
		 })
		 $("#grid-window").setGridWidth($("#modal-windowinfo .div_content").width())
		 $("#grid-window").HideJqGridScroll({
			 hideType: "X"
		 })
	 })
	 $("#modal-windowinfo").on('hidden.bs.modal', function () {
		 Setfocus();
	 })
	 if(Com_CardPayFlag!="Y"){
		 $("#btn-cardpay").attr("style","display:none;");
	 }
	 HotKeyInit("Disp","grid-disp");
	 Setfocus();
	 
 })
 
 //初始化发药table
 function InitGridDisp() {
	 var columns = [{
			 header: ("发药状态"),
			 index: 'TPhDispStat',
			 name: 'TPhDispStat',
			 width: 65,
			 cellattr: addPhDispStatCellAttr
		 },
		 {
			 header: ("姓名"),
			 index: 'TPatName',
			 name: 'TPatName',
			 width: 100
		 },
		 {
			 header: ("登记号"),
			 index: 'TPmiNo',
			 name: 'TPmiNo',
			 width: 100
		 },
		 {
			 header: ("收费日期"),
			 index: 'TPrtDate',
			 name: 'TPrtDate',
			 width: 150
		 },
		 {
			 header: ("配药"),
			 index: 'TPrintFlag',
			 name: 'TPrintFlag',
			 width: 40,
			 hidden: true
		 },
		 {
			 header: ("发药"),
			 index: 'TFyFlag',
			 name: 'TFyFlag',
			 width: 40,
			 hidden: true
		 },
		 {
			 header: ("处方号"),
			 index: 'TPrescNo',
			 name: 'TPrescNo',
			 width: 115,
			 sortable: true
		 },
		 {
			 header: ("预览"),
			 index: 'TPrescView',
			 name: 'TPrescView',
			 width: 50,
			 formatter: PrescFormatter,
			 hidden: true
		 },
		 {
			 header: ("处方金额"),
			 index: 'TPrescMoney',
			 name: 'TPrescMoney',
			 width: 70,
			 align: 'right'
		 },
		 {
			 header: ("剂数"),
			 index: 'TJS',
			 name: 'TJS',
			 width: 40,
			 hidden: true
		 },
		 {
			 header: ("费别"),
			 index: 'TPrescType',
			 name: 'TPrescType',
			 width: 70
		 },
		 {
			 header: ("窗口"),
			 index: 'TWinDesc',
			 name: 'TWinDesc',
			 width: 80
		 },
		 {
			 header: ("诊断"),
			 index: 'TMR',
			 name: 'TMR',
			 width: 150,
			 align: "left"
		 },
		 {
			 header: ("性别"),
			 index: 'TPatSex',
			 name: 'TPatSex',
			 width: 40
		 },
		 {
			 header: ("年龄"),
			 index: 'TPatAge',
			 name: 'TPatAge',
			 width: 40
		 },
		 {
			 header: ("科室"),
			 index: 'TPatLoc',
			 name: 'TPatLoc',
			 width: 100
		 },
		 {
			 header: ("协定处方"),
			 index: 'TOrdGroup',
			 name: 'TOrdGroup',
			 width: 60,
			 hidden: true
		 },
		 {
			 header: ("接收科室"),
			 index: 'TRecLocdesc',
			 name: 'TRecLocdesc',
			 width: 100
		 },
		 {
			 header: ("审核状态"),
			 index: 'TDocSS',
			 name: 'TDocSS',
			 width: 70
		 },
		 {
			 header: ("合理用药"),
			 index: 'TPassCheck',
			 name: 'TPassCheck',
			 width: 70,
			 hidden: true
		 },
		 {
			 header: 'TAdm',
			 index: 'TAdm',
			 name: 'TAdm',
			 width: 60,
			 hidden: true
		 },
		 {
			 header: 'TPatID',
			 index: 'TPatID',
			 name: 'TPatID',
			 width: 60,
			 hidden: true
		 },
		 {
			 header: 'TPatLoc',
			 index: 'TPatLoc',
			 name: 'TPatLoc',
			 width: 60,
			 hidden: true
		 },
		 {
			 header: 'TJYType',
			 index: 'TJYType',
			 name: 'TJYType',
			 width: 60,
			 hidden: true
		 },
		 {
			 header: 'TCallCode',
			 index: 'TCallCode',
			 name: 'TCallCode',
			 width: 60,
			 hidden: true
		 },
		 {
			 header: 'TPatAdd',
			 index: 'TPatAdd',
			 name: 'TPatAdd',
			 width: 60,
			 hidden: true
		 },
		 {
			 header: 'TPrescTitle',
			 index: 'TPrescTitle',
			 name: 'TPrescTitle',
			 width: 60,
			 hidden: true
		 },
		 {
			 header: 'TUseLocdr',
			 index: 'TUseLocdr',
			 name: 'TUseLocdr',
			 width: 60,
			 hidden: true
		 },
		 {
			 header: 'Tphd',
			 index: 'Tphd',
			 name: 'Tphd',
			 width: 60,
			 hidden: true
		 },
		 {
			 header: 'TPid',
			 index: 'TPid',
			 name: 'TPid',
			 width: 60,
			 hidden: true
		 },
		 {
			 header: ("病人密级"),
			 index: 'TEncryptLevel',
			 name: 'TEncryptLevel',
			 width: 70,
			 hidden: true
		 },
		 {
			 header: ("病人级别"),
			 index: 'TPatLevel',
			 name: 'TPatLevel',
			 width: 70,
			 hidden: true
		 },
		 {
			 header: ("可欠药"),
			 index: 'TCanOwe',
			 name: 'TCanOwe',
			 width: 70,
			 hidden: true
		 },
	 ];
	 var jqOptions = {
		 colModel: columns, //列
		 url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryDispList&style=jqGrid', //查询后台	
		 height: DhcphaJqGridHeight(2, 3) * 0.5,
		 shrinkToFit: false,
		 datatype: 'local',
		 pager: "#jqGridPager", //分页控件的id  
		 onSelectRow: function (id, status) {
			 QueryGridDispSub();
			 var selrowdata = $(this).jqGrid('getRowData', id);
			 var prescNo = selrowdata.TPrescNo;
			 InitErpMenu(prescNo);
		 },
		 loadComplete: function () {
			 var grid_records = $(this).getGridParam('records');
			 if (grid_records == 0) {
				 $("#grid-dispdetail").clearJqGrid();
			 } else {
				 $(this).jqGrid('setSelection', 1);
			 }
			 
			 var chkdisp=""
			 if ($("#chk-disp").is(':checked')) {
				 chkdisp = "1";
			 }
			 if(chkdisp!=1){
				 var fyrowdata = $("#grid-disp").jqGrid('getRowData');
				 var fygridrows = fyrowdata.length;
				 if (fygridrows <= 0) {
					 return;
				 }
				 for (var rowi = 1; rowi <= fygridrows; rowi++) {
					 var selrowdata=$("#grid-disp").jqGrid('getRowData', rowi)
					 var prescno = selrowdata.TPrescNo;
					 if(readCardFlag==1){
						 SendOPInfoToMachine("105",prescno,"")
					 }
 
				 }
			 }
		 }
	 };
	 $("#grid-disp").dhcphaJqGrid(jqOptions);
 }
 //自定义处方预览列格式
 function PrescFormatter(cellvalue, options, rowdata) {
	 return '<i class="fa fa-file-text-o" style="cursor:pointer;" onClick=pop() alt="' + cellvalue + '"  />'
	 //return '<i class="fa fa-file-text-o" style="cursor:pointer;" onMouseOver=pop() onMouseOut=hide() alt="' + cellvalue + '"  />' 
 }
 
 function pop() {
	 $td = $(event.target).closest("td");
	 var rowid = $td.closest("tr.jqgrow").attr("id");
	 var selectdata = $('#grid-disp').jqGrid('getRowData', rowid);
	 var phdrowid = selectdata.Tphd;
	 var prescno = selectdata.TPrescNo;
	 var prtrowid = "";
	 var cyflag = DHCPHA_CONSTANT.DEFAULT.CYFLAG;
	 var newurl = "dhcpha.outpha.prescpreview.csp" +
		 "?phdispid=" + phdrowid + "&prescno=" + prescno + "&cyflag=" + cyflag + "&prtrowid=" + prtrowid + "&phlrowid=" + DHCPHA_CONSTANT.DEFAULT.PHLOC;
	 $('iframe').attr('src', newurl);
	 document.getElementById("modal-prescinfo").style.display = "inline";
 }
 
 function hide() {
	 $('iframe').attr('src', "")
	 document.getElementById("modal-prescinfo").style.display = "none";
 }
 //初始化发药明细table
 function InitGirdDispDetail() {
	 var columns = [{
			 header: ("明细状态"),
			 index: 'TPhDispItmStat',
			 name: 'TPhDispItmStat',
			 width: 65,
			 cellattr: addPhDispItmStatCellAttr
		 },
		 {
			 header: ("药品名称"),
			 index: 'TPhDesc',
			 name: 'TPhDesc',
			 width: 200,
			 align: 'left'
		 },
		 {
			 header: ("数量"),
			 index: 'TPhQty',
			 name: 'TPhQty',
			 width: 60,
			 align: 'right'
		 },
		 {
			 header: ("实发"),
			 index: 'TRealQty',
			 name: 'TRealQty',
			 width: 60,
			 editable: true,
			 cellattr: addTextCellAttr
		 },
		 {
			 header: ("单位"),
			 index: 'TPhUom',
			 name: 'TPhUom',
			 width: 70
		 },
		 {
			 header: ("剂量"),
			 index: 'TJL',
			 name: 'TJL',
			 width: 60
		 },
		 {
			 header: ("频次"),
			 index: 'TPC',
			 name: 'TPC',
			 width: 40
		 },
		 {
			 header: ("用法"),
			 index: 'TYF',
			 name: 'TYF',
			 width: 40
		 },
		 {
			 header: ("疗程"),
			 index: 'TLC',
			 name: 'TLC',
			 width: 40
		 },
		 {
			 header: ("规格"),
			 index: 'TPhgg',
			 name: 'TPhgg',
			 width: 100
		 },
		 {
			 header: ("货位"),
			 index: 'TIncHW',
			 name: 'TIncHW',
			 width: 100
		 },
		 {
			 header: ("生产企业"),
			 index: 'TPhFact',
			 name: 'TPhFact',
			 width: 170,
			 align: 'left'
		 },
		 {
			 header: ("备注"),
			 index: 'TPhbz',
			 name: 'TPhbz',
			 width: 40
		 },
		 {
			 header: ("库存不足"),
			 index: 'TKCFlag',
			 name: 'TKCFlag',
			 width: 40,
			 hidden: true
		 },
		 {
			 header: ("库存数量"),
			 index: 'TKCQty',
			 name: 'TKCQty',
			 width: 70
		 },
		 {
			 header: ("医保类型"),
			 index: 'TYBType',
			 name: 'TYBType',
			 width: 75
		 },
		 {
			 header: ("单价"),
			 index: 'TPrice',
			 name: 'TPrice',
			 width: 60,
			 align: 'right'
		 },
		 {
			 header: ("金额"),
			 index: 'TMoney',
			 name: 'TMoney',
			 width: 60,
			 align: 'right'
		 },
		 {
			 header: ("状态"),
			 index: 'TOrdStatus',
			 name: 'TOrdStatus',
			 width: 60
		 },
		 {
			 header: 'TOrditm',
			 index: 'TOrditm',
			 name: 'TOrditm',
			 width: 60,
			 hidden: true
		 },
		 {
			 header: 'TUnit',
			 index: 'TUnit',
			 name: 'TUnit',
			 width: 60,
			 hidden: true
		 },
		 {
			 header: ("批次"),
			 index: 'TIncPC',
			 name: 'TIncPC',
			 width: 60,
			 hidden: true
		 },
		 {
			 header: ("发票号"),
			 index: 'TPrtNo',
			 name: 'TPrtNo',
			 width: 100
		 },
		 {
			 header: ("皮试"),
			 index: 'TSkinTest',
			 name: 'TSkinTest',
			 width: 60
		 },
		 {
			 header: ("国家医保编码"),
			 index: 'TCInsuCode',
			 name: 'TCInsuCode',
			 width: 120
		 },
		 {
			 header: ("国家医保名称"),
			 index: 'TCInsuDesc',
			 name: 'TCInsuDesc',
			 width: 120
		 },
		 {
			 header: ("处方号"),
			 index: 'TPrescNo',
			 name: 'TPrescNo',
			 width: 60,
			 hidden: true
		 },
		 {
			 header: 'TInci',
			 index: 'TInci',
			 name: 'TInci',
			 width: 60,
			 hidden: true
		 }
	 ];
	 var jqOptions = {
		 //cellEdit:true,
		 //cellsubmit:'clientArray',
		 colModel: columns, //列
		 url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryDispListDetail&style=jqGrid',
		 height: DhcphaJqGridHeight(2, 3) * 0.5,
		 shrinkToFit: false,
		 rowNum: 200,
		 datatype: 'local',
		 loadComplete: function () {
			 QueryDetailOrders({
				 gridName:"grid-dispdetail",
				 changFlag:changeFlag+1
			 });
		 },
		 onSelectRow: function (id, status) {
			 if (DHCPHA_CONSTANT.DEFAULT.CYFLAG == "Y") {
				 return;
			 }
			 if (DHCPHA_CONSTANT.DEFAULT.OweDisp != "Y") {
				 return;
			 }
			 var dispselid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
			 var selrowdata = $("#grid-disp").jqGrid('getRowData', dispselid);
			 var fyflag = selrowdata["TFyFlag"];
			 var pyflag = selrowdata["TPrintFlag"];
			 var dispstat = selrowdata["TPhDispStat"];
			 var canOwe = selrowdata["TCanOwe"];
			 if (fyflag == "OK") {
				 return;
			 }
			 if ((dispstat.indexOf($g("已配")) >= 0) || (dispstat.indexOf($g("已打印")) >= 0)) {
				 return;
			 }
			 if (canOwe != "Y") {
				 return;
			 }
			 if ((JqGridCanEdit == false) && (LastEditSel != "") && (LastEditSel != id)) {
				 $("#grid-dispdetail").jqGrid('setSelection', LastEditSel);
				 return
			 }
			 if ((LastEditSel != "") && (LastEditSel != id)) {
				 $(this).jqGrid('saveRow', LastEditSel);
			 }
			 $(this).jqGrid("editRow", id, {
				 oneditfunc: function () {
					 $editinput = $(event.target).find("input");
					 $editinput.focus();
					 $editinput.select();
					 $editinput.unbind().on("keyup",function(e){
						 $editinput.val(ParseToNum($editinput.val()))
					 });
					 $("#" + id + "_TRealQty").on("focusout || mouseout", function () {
						 var reg = /^[0-9]\d*$/;
						 if (!reg.test(this.value)) {
							 dhcphaMsgBox.message($g("第") + id + $g("行的实发数量只能为整数")+"!")
							 $("#grid-dispdetail").jqGrid('restoreRow', id);
							 JqGridCanEdit = false
							 return false
						 }
						 var iddata = $('#grid-dispdetail').jqGrid('getRowData', id);
						 var oeoriqty = iddata.TPhQty;
						 if (parseFloat(this.value * 1000) > parseFloat(oeoriqty * 1000)) {
							 dhcphaMsgBox.message($g("第") + id + $g("行实发数量大于医嘱数量")+"!")
							 $("#grid-dispdetail").jqGrid('restoreRow', id);
							 JqGridCanEdit = false
							 return false
						 } else {
							 JqGridCanEdit = true
							 return true
						 }
					 });
				 }
			 });
			 LastEditSel = id;
		 }
 
	 };
	 $("#grid-dispdetail").dhcphaJqGrid(jqOptions);
	 PhaGridFocusOut("grid-dispdetail");
 }
 //叫号消息发送
 function SendMessToVoice(rowIndex) {
 
	 if ((rowIndex == null) || (rowIndex == "")) {
		 dhcphaMsgBox.alert($g("没有选中数据,不能叫号!"));
		 return;
	 }
	 var selrowdata = $("#grid-waitfy").jqGrid('getRowData', rowIndex);
	 var patno = selrowdata.tbpatid;
	 var patname = selrowdata.tbname;
	 var window = DHCPHA_CONSTANT.DEFAULT.PHWINDOW;
	 var serverip = ClientIPAddress;
	 var FYUserID = DHCPHA_CONSTANT.DEFAULT.PHUSER;
	 var phwQuId=selrowdata.phwQuId;
	 if(phwQuId!=""){
		 var state="Call"
		 var retInfo=tkMakeServerCall("PHA.OP.Queue.OperTab", "UpdQueueState",phwQuId,state); 
	 }
	 SendOPInfoToMachine("103^107","",patno)			// 叫号亮灯	叫号上屏	
 
	 var SendVoiceRet = tkMakeServerCall("PHA.FACE.IN.Com", "SendMessToVoice", patno, patname, serverip, window, FYUserID)
	 QueryGridWaitFY();
 }
 function PassQueueNo(rowIndex,state){
	 if ((rowIndex == null) || (rowIndex == "")) {
		 dhcphaMsgBox.alert($g("没有选中数据,不需过号!"));
		 return;
	 }
	 var selrowdata = $("#grid-waitfy").jqGrid('getRowData', rowIndex);
	 var phwQuId=selrowdata.phwQuId;
	 if(phwQuId==""){
		 dhcphaMsgBox.alert($g("没有报到排队,不需过号!"));
		 return;
	 }
	 var state="Skip"
	 var retInfo=tkMakeServerCall("PHA.OP.Queue.OperTab", "UpdQueueState",phwQuId,state); 
	 QueryGridWaitFY();
		 
 }
 function CallPatForMat(cellvalue, options, rowObject) {
	 var pathInfo=document.location.pathname.toString();
	 if(pathInfo.indexOf("dhcpha")>-1){
		 var srcPath="../../";
	 }else{
		 var srcPath="../"
	 }
	 
	 //return "<a href='#' onclick='SendMessToVoice(\"" + options.rowId + "\")'><i class='fa fa-bullhorn'></i></a>";
	 return "<a onclick='SendMessToVoice(\"" + options.rowId + "\")'><img src='"+srcPath+"scripts_lib/hisui-0.1.0/dist/css/icons/big/ring.png' border=0/></a>"
		 +"<a style='margin-left:10px' onclick='PassQueueNo(\"" + options.rowId + "\")'><img src='"+srcPath+"scripts_lib/hisui-0.1.0/dist/css/icons/big/skip_no.png' border=0/></a>";
 }
 //初始化待发药table
 function InitGirdWAITFY() {
	 var columns = [{
			 header: ("叫号"),
			 index: 'tSendVoice',
			 name: 'tSendVoice',
			 width: 80,
			 cellattr: addtSendVoiceCellAttr,
			 formatter: CallPatForMat
		 },{
			 header: ("姓名"),
			 index: 'tbname',
			 name: 'tbname',
			 
			 width: 100
		 },
		 {
			 header: ("登记号"),
			 index: 'tbpatid',
			 name: 'tbpatid',
			 width: 100
		 },
		 {
			 header: ("排队号"),
			 index: 'queueNo',
			 name: 'queueNo',
			 width: 100
		 },
		 {
			 header: ("叫号状态"),
			 index: 'callFlag',
			 name: 'callFlag',
			 width: 100,
			 hidden: true
		 },
		 {
			 header: ("叫号id"),
			 index: 'phwQuId',
			 name: 'phwQuId',
			 width: 100,
			 hidden: true
		 },
		 {
			 header: ("病人密级"),
			 index: 'TEncryptLevel',
			 name: 'TEncryptLevel',
			 width: 100,
			 hidden: true
		 },
		 {
			 header: ("病人级别"),
			 index: 'TPatLevel',
			 name: 'TPatLevel',
			 width: 100,
			 hidden: true
		 },
		 {
			 header: 'TWarnLevel',
			 index: 'TWarnLevel',
			 name: 'TWarnLevel',
			 width: 100,
			 hidden: true
		 }
	 ];
	 var jqOptions = {
		 colModel: columns, //列
		 url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryNeedFYList&style=jqGrid',
		 height: DhcphaJqGridHeight(1, 1),
		 shrinkToFit: false,
		 datatype: 'local',
		 onSelectRow: function (id, status) {
			 var selrowdata = $(this).jqGrid('getRowData', id);
			 var patno = selrowdata.tbpatid;
			 $("#txt-patno").val(patno);
			 QueryGridDisp();
			 
		 },
		 gridComplete: function () {
			 var ids = $("#grid-waitfy").jqGrid("getDataIDs");
			 var rowDatas = $("#grid-waitfy").jqGrid("getRowData");
			 for (var i = 0; i < rowDatas.length; i++) {
				 var rowData = rowDatas[i];
				 var warnLevel = rowData.TWarnLevel;
				 var callFlag=rowData.callFlag;
				 if ((warnLevel.indexOf($g("毒")) >= 0) || (warnLevel.indexOf($g("麻")) >= 0)) {
					 $("#grid-waitfy" + " #" + ids[i] + " td").css({
						 color: '#FF6356',
						 'font-weight': 'bold'
					 });
				 }
			 }
			 return true;
		 }
	 };
	 $("#grid-waitfy").dhcphaJqGrid(jqOptions);
 }
 
 //查询待发药table
 function QueryGridWaitFY() {
	 var stdate = $("#date-start").val();
	 var enddate = $("#date-end").val();
	 var params = DHCPHA_CONSTANT.DEFAULT.PHLOC + "^" + DHCPHA_CONSTANT.DEFAULT.PHWINDOW + "^" + 1 + "^" + stdate + "^" + enddate;
	 $("#grid-waitfy").setGridParam({
		 datatype: 'json',
		 postData: {
			 'params': params
		 }
	 }).trigger("reloadGrid");
	 if ((DHCPHA_CONSTANT.DEFAULT.PHLOC != "") && (DHCPHA_CONSTANT.DEFAULT.PHWINDOW != "")) {
		 clearTimeout(DHCPHA_CONSTANT.VAR.TIMER);
	 }
 }
 
 //初始化基数科室
 function InitBasicLoc() {
	 var selectoption = {
		 url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
			 '?action=GetBasicLocList&style=select2',
		 placeholder: $g("基数科室"),
		 minimumResultsForSearch: Infinity,
		 width: 120
	 }
	 $("#sel-basicloc").dhcphaSelect(selectoption)
	 $('#sel-basicloc').on('select2:select', function (event) {
		 //alert(event)
	 });
 }
 //初始化留观室
 function InitSpecial() {
	 var selectoption = {
		 url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
			 '?action=GetEMLocList&style=select2',
		 placeholder: $g("留观科室"),
		 minimumResultsForSearch: Infinity,
		 width: 120
	 }
	 $("#sel-special").dhcphaSelect(selectoption)
	 $('#sel-special').on('select2:select', function (event) {
		 //alert(event)
	 });
 }
 //查询发药列表
 function QueryGridDisp() {
	curPatNo = "";
	 ClearErpMenu();
	 ChkUnFyOtherLoc();
	 var stdate = $("#date-start").val();
	 var enddate = $("#date-end").val();
	 var chkdisp = "";
	 if ($("#chk-disp").is(':checked')) {
		 chkdisp = "1";
	 }
	 var patno = $("#txt-patno").val();
	 var GPhl = DHCPHA_CONSTANT.DEFAULT.PHLOC;
	 var GPhw = DHCPHA_CONSTANT.DEFAULT.PHWINDOW; //这是配药窗口的ID
	 var CPatName = "";
	 var basicloc = $("#sel-basicloc").val();
	 if (basicloc == null) {
		 basicloc = "";
	 }
	 var emloc = $("#sel-special").val();
	 if (emloc == null) {
		 emloc = "";
	 }
	 var prescBarCode =DealPrescBarCode();  //单机恢复条码(处理后为处方号)
	 if(prescBarCode===false){
		 dhcphaMsgBox.alert($g("处方未结算!"));
		 return;
	 }
	 var cesFlag = "";
	 if ($("#chk-recover").is(':checked')) {
		 cesFlag = "Y";
	 }
	 if((OnlyDispByPatNoFlag =="Y")&&(patno=="")&&(basicloc=="")&&(emloc=="")&&(cesFlag!="Y")&&(chkdisp!="1")){
		dhcphaMsgBox.alert($g("请输入基数药科室/留观科室/患者信息后查询!"));
		return;
	 }
	 curPatNo = patno;
	 var params = stdate + "^" + enddate + "^" + GPhl + "^" + GPhw + "^" + patno + "^" + CPatName + "^" + chkdisp + "^" + emloc + "^" + basicloc+ "^" +prescBarCode+ "^" +cesFlag;
	 $("#grid-disp").setGridParam({
		 datatype: 'json',
		 postData: {
			 'params': params
		 },
		 page:1
	 }).trigger("reloadGrid");
	 JqGridCanEdit = true;
	 readCardFlag=0
	 Setfocus();
 }
 // 条码
 function DealPrescBarCode(){
	 var barCodeInfo=$("#txt-recoverBarCode").val();
	 if(barCodeInfo==""){return ""}
	 var prescNo="";
	 var BarCodeData="";
	 try {
		 var strData = window.atob(barCodeInfo);
		 BarCodeData = pako.inflate(strData, {
			 to: 'string'
		 });
		 if (typeof JSON.parse(BarCodeData) == "object") {
			 var jsonInfo=JSON.parse(BarCodeData);
			 var info=jsonInfo.Info;
			 var ArrInfo=info.split("*");
			 if(ArrInfo.length>4){
				 prescNo=ArrInfo[3];
				 
				 var payInfo=jsonInfo.PayInfo; 
				 var payFlag=payInfo.split("*")[0];
				 if(payFlag!="P"){
					 $("#txt-recoverBarCode").val("");
					 return false;
				 }
				 $("#txt-recoverBarCode").val("");
			 }
		 }
	 } catch(ex) {
		 try {
			 if (typeof JSON.parse(barCodeInfo) == "object") {
				 var jsonInfo=JSON.parse(barCodeInfo);
				 var info=jsonInfo.Info;
				 var ArrInfo=info.split("*");
				 if(ArrInfo.length>4){
					 prescNo=ArrInfo[3];
					 
					 var payInfo=jsonInfo.PayInfo; 
					 var payFlag=payInfo.split("*")[0];
					 if(payFlag!="P"){
						 $("#txt-recoverBarCode").val("");
						 return false;
					 }
					 $("#txt-recoverBarCode").val("");
				 }
			 }
		 } catch(e) {
			 prescNo=barCodeInfo;
			 $("#txt-recoverBarCode").val("");
		 }
	 }
	 return prescNo;
 }
 //查询发药明细
 function QueryGridDispSub() {
 
	 var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	 var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	 var prescno = selrowdata.TPrescNo;
	 var rPhdrow = selrowdata.Tphd;
	 var params = DHCPHA_CONSTANT.DEFAULT.PHLOC + "^" + prescno + "^" + rPhdrow;
	 $("#grid-dispdetail").setGridParam({
		 datatype: 'json',
		 page: '1',
		 postData: {
			 'params': params
		 }
	 }).trigger("reloadGrid");
	 JqGridCanEdit = true;
 }
 // 执行发药
 function ExecuteFY() {
	 if (DhcphaGridIsEmpty("#grid-disp") == true) {
		 return;
	 }
	 var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	 var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	 if (selectid == null) {
		 dhcphaMsgBox.alert($g("没有选中数据,不能发药!"));
		 return;
	 }
	 var basicloc = $("#sel-basicloc").val();
	 if (basicloc == null) {
		 basicloc = "";
	 }
	 if (basicloc != "") {
		 dhcphaMsgBox.alert($g("您选择的记录为基数药,请使用全发功能生成补货单!"))
		 return;
	 }
	 /**if (JqGridCanEdit==false){
		 return;
	 }**/
	 var fyflag = selrowdata.TFyFlag;
	 //DispensingMonitor(selectid, "");
	 ChkUnFyThisLocFlag="0"
	 CheckPayment(selectid, "");
	 if (ChkUnFyThisLocFlag=="1") ChkUnFyThisLoc(1);
	 QueryGridWaitFY();
	 Setfocus();
 }
 
 //执行全发
 function ExecuteAllFY() {
	 var fyrowdata = $("#grid-disp").jqGrid('getRowData');
	 var fygridrows = fyrowdata.length;
	 if (fygridrows <= 0) {
		 dhcphaMsgBox.alert($g("没有数据!"));
		 return;
	 }
	 //发放基数药品,产生基数药补货清单
	 var firstrowdata = $("#grid-disp").jqGrid("getRowData", 1);
	 var uselocdr = firstrowdata.TUseLocdr;
	 if (uselocdr == undefined) {
		 uselocdr = "";
	 }
	 // 全发前简单检验下数据
	var retFlag = ChkDataBeforeALLFY()
	if(retFlag==false){
		dhcphaMsgBox.alert($g("当前处方数据中，有已发数据，请重新查询后再试！"), "error");
		return;
	}
	if (uselocdr != "") {
		dhcphaMsgBox.confirm($g("确认全发吗?系统将全部发放查询出的所有处方并汇总生成补货单!"), ConfirmDispBasic);
	} else {
		if ((IsOnlyOnePatno() == false)){
			if (OnlyDispByPatNoFlag = 'Y') {
				dhcphaMsgBox.alert($g("多个患者处方不允许使用全发!"), "warn");	
				return;
			}
			var warntitle = $g("存在多个患者的处方确认全发吗?系统将全部发放查询出的所有处方!")
		}else {
			var warntitle = $g("确认全发吗?系统将全部发放查询出的所有处方!")
		}
		dhcphaMsgBox.confirm($g(warntitle), ConfirmDispAll);
	}
	Setfocus();
 }
 
 function ConfirmDispBasic(result) {
	 if (result == true) {
		 var firstrowdata = $("#grid-disp").jqGrid("getRowData", 1);
		 var pid = firstrowdata.TPid;
		 var RetInfo = tkMakeServerCall("PHA.OP.Supply.OperTab", "SaveSupData", pid, DHCPHA_CONSTANT.DEFAULT.PHUSER, DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHPYUSER, DHCPHA_CONSTANT.DEFAULT.PHWINDOW);
		 var retarr = RetInfo.split("^");
		 var retval = retarr[0];
		 var retmessage = retarr[1];
		 if (retval > 0) {
			 PrintSupp(retval)
			 QueryGridDisp();
			 if (top && top.HideExecMsgWin) {
				 top.HideExecMsgWin();
			 }
		 } else {
			 dhcphaMsgBox.alert($g("基数药品发药失败,错误代码:") + retmessage, "error");
		 }
	 }
 }
 
 function ConfirmDispAll(result) {
	 if (result == true) {
		 
		 var fyrowdata = $("#grid-disp").jqGrid('getRowData');
		 var fygridrows = fyrowdata.length;	 
		 tipNum=0;
		 for (var rowi = 1; rowi <= fygridrows; rowi++) {
			 //DispensingMonitor(rowi, "U");		 	 
			 CheckPayment(rowi, "U");
			 if(tipNum>0){
				 return;
			}
		 }
		 ChkUnFyThisLoc(fygridrows)	
	 }
	 QueryGridWaitFY();
	 
 }
 
 
 /* 检查收费情况 */
 function CheckPayment(rowid, updflag){
	 var selectrow = $("#grid-disp").jqGrid('getRowData', rowid);
	 var prescNo = selectrow.TPrescNo;
	 /* 获取处方中的未交费医嘱信息 */
	 var unPaidInfo = GetUnPaidOrder(prescNo)
		 /* 存在未交费时是否允许发药 */
	 if (unPaidInfo !== ""){
		 if (PartPiedDispFlag == "Y") {
			 dhcphaMsgBox.confirm(prescNo + $g("中存在未交费的医嘱明细!医嘱名称为:") + "<br/>" + unPaidInfo + "<br/>" + $g("点击[确认]将继续发药，点击[取消]将放弃发药操作。"), function (r) {
				 if (r == true) {
					 DispensingMonitor(rowid, updflag);	
				 } else {
					 return;
				 }
			 });
		 }
		 else {
			 dhcphaMsgBox.alert(prescNo + $g("中存在未交费的医嘱明细,禁止发药!医嘱名称为:") + "<br/>" + unPaidInfo);
			 return;
		 }
	 }
	 else{
		 DispensingMonitor(rowid, updflag);	
	 }
		 
 }
 
 function DispensingMonitor(rowid, updflag) {
 
	 var selrowdata = $("#grid-disp").jqGrid('getRowData', rowid);
	 var prescno = selrowdata.TPrescNo;
	 var fyflag = selrowdata.TFyFlag;
	 var patname = selrowdata.TPatName;
	 var warnmsgtitle = $g("病人姓名")+":" + patname + "<br/>" + $g("处方号")+":" + prescno + "<br/>"
	 if (fyflag == "OK") {
		 dhcphaMsgBox.alert(warnmsgtitle + $g("该记录已经发药")+"!");
		 return;
	 }
	 var checkprescadt = GetOrdAuditResultByPresc(prescno)
	 if (checkprescadt == "") {
		 dhcphaMsgBox.alert(warnmsgtitle + $g("请先审核")+"!");
		 return;
	 } else if (checkprescadt == "N") {
		 dhcphaMsgBox.alert(warnmsgtitle + $g("审核不通过,不允许发药!"));
		 return;
	 } else if (checkprescadt == "S") {
		 if (!confirm(warnmsgtitle + $g("该处方医生已提交申诉\n点击'确认'将同意申诉继续发药，点击'取消'将放弃发药操作。"))) {
			 return;
		 }
	 }
 
	 var checkprescref = GetOrdRefResultByPresc(prescno)
	 if (checkprescref == "N") {
		 dhcphaMsgBox.alert(warnmsgtitle + $g("该处方已被拒绝,禁止发药!"));
		 return;
	 } else if (checkprescref == "A") {
		 dhcphaMsgBox.alert(warnmsgtitle +$g("该处方已被拒绝,禁止发药!"));
		 return;
	 } else if (checkprescref == "S") {
		 dhcphaMsgBox.confirm(warnmsgtitle + $g("该处方医生已提交申诉<br/>点击[确认]将同意申诉继续发药，点击[取消]将放弃发药操作。"), function (r) {
			 if (r == true) {
				 var cancelrefuseret = tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "CancelRefuse", DHCPHA_CONSTANT.SESSION.GUSER_ROWID, prescno, "OR"); //申诉后发药应先撤消拒绝
				 DispMonitor(prescno, updflag, rowid);
			 } else {
				 return;
			 }
		 });
	 } else {
		 DispMonitor(prescno, updflag, rowid);
	 }
 }
 
 function DispMonitor(prescno, updflag, rowid) {
	 var dispQtyString = ""
	 if ((updflag == "") && (DHCPHA_CONSTANT.DEFAULT.OweDisp == "Y")) { //全发时此标志为U
		 var fydetailrowdata = $("#grid-dispdetail").jqGrid('getRowData');
		 var fydetailgridrows = fydetailrowdata.length;
		 if (fydetailgridrows <= 0) {
			 dhcphaMsgBox.alert($g("没有明细数据")+"!");
			 return;
		 }
		 var chkflag = 0,
			 allowe = 1,
			 zeroFlag = 0
		 var dispQtyString = 0
		 for (var rowi = 0; rowi < fydetailgridrows; rowi++) {
			 var oeoriQty = fydetailrowdata[rowi].TPhQty;
			 var realQty = fydetailrowdata[rowi].TRealQty;
			 var oeoriPrescNo = fydetailrowdata[rowi].TPrescNo;
			 if (oeoriPrescNo != prescno) {
				 dhcphaMsgBox.alert($g("药品详细列表非本处方数据,请重新选中处方!"));
				 return;
			 }
			 oeoriQty = $.trim(oeoriQty);
			 realQty = $.trim(realQty);
			 if (parseFloat(realQty) != 0) {
				 var zeroFlag = 1;
			 }
			 if (parseFloat(realQty) > parseFloat(oeoriQty)) {
				 dhcphaMsgBox.alert($g("实发数量不能大于医嘱数量!"));
				 return;
			 }
			 if (parseFloat(realQty) < 0) {
				 dhcphaMsgBox.alert($g("实发数量不能小于0!"));
				 return;
			 }
			 if (parseFloat(realQty) != parseFloat(oeoriQty)) {
				 chkflag = "1";
			 }
			 if (allowe != 0) {
				 allowe = 0
			 }
			 var oeori = fydetailrowdata[rowi].TOrditm
			 var unit = fydetailrowdata[rowi].TUnit
			 var realqty = fydetailrowdata[rowi].TRealQty
			 var Inci = fydetailrowdata[rowi].TInci
			 var tmpdispstring = oeori + "^" + realQty + "^" + oeoriQty + "^" + unit + "^" + Inci
			 if (dispQtyString == 0) {
				 dispQtyString = tmpdispstring
			 } else {
				 dispQtyString = dispQtyString + "!!" + tmpdispstring
			 }
 
		 }
		 if (zeroFlag != 1) {
			 dhcphaMsgBox.alert($g("实发数量不能都为0!"));
			 return;
		 }
		 dispQtyString = chkflag + "&&" + allowe + "&&" + dispQtyString;
		 var tmpordstr = dispQtyString.split("&&")
		 var chkord = tmpordstr[0];
		 ChkAllOweFlag = tmpordstr[1]; //是否全部欠药
		 ChkOweFlag = chkord;
	 }
	 if (chkflag == "1") {
		 dhcphaMsgBox.confirm($g("是否需要生成欠药单? 点击[确认]生成，点击[取消]退出"), function (r) {
			 if (r == true) {
				 ExecuteDisp(rowid, prescno, dispQtyString, updflag);
			 } else {
				 return;
			 }
		 });
	 } else {
		 ExecuteDisp(rowid, prescno, dispQtyString, updflag);
	 }
 }
 
 function ExecuteDisp(rowid, prescno, dispQtyString, updflag) {
	 var RetInfo = tkMakeServerCall("PHA.OP.DirDisp.OperTab", "SaveDispData", DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHWINDOW, DHCPHA_CONSTANT.DEFAULT.PHPYUSER, DHCPHA_CONSTANT.DEFAULT.PHUSER, prescno, dispQtyString);
	 var retarr = RetInfo.split("^");
	 var retval = retarr[0];
	 var retmessage = retarr[1];
	 if (retval > 0) {
		 var bgcolor = $(".dhcpha-record-disped").css("background-color");
		 var cssprop = {
			 background: bgcolor,
			 color: 'black'
		 };
		 $("#grid-disp").setCell(rowid, 'TFyFlag', 'OK');
		 $("#grid-disp").setCell(rowid, 'Tphd', retval);
		 $("#grid-disp").setCell(rowid, 'TPhDispStat', $g("已发药"), cssprop);
		 var phOweId = tkMakeServerCall("PHA.OP.COM.Print", "GetPhOweByPhd", retval);
		 
		 if((updflag!="U")&&(phOweId=="")){
			 var nextSelectid=parseInt(rowid)+1
			 var rowDatas = $("#grid-disp").jqGrid("getRowData");
			 if(nextSelectid<=rowDatas.length)
			 {
				 $("#grid-disp").setSelection(nextSelectid);
			 }
		 }
		 AfterExecPrint(prescno,PrintType,retval,"")
		 PrintPhdOwe(phOweId);
		 SendOPInfoToMachine("104^108^110",prescno,"");			//104发药灭灯 108发药时下屏 110发送机(处方状态)
		 ChkUnFyThisLocFlag="1"
		 if (top && top.HideExecMsgWin) {
			 top.HideExecMsgWin();
		 }
		 
	 } else {
		 dhcphaMsgBox.alert($g(retmessage));
		 tipNum=tipNum+1;
		 return;
	 }
 }
 
 // 执行拒绝发药
 function ExecuteRefuseFY() {
	 if (DhcphaGridIsEmpty("#grid-disp") == true) {
		 return;
	 }
	 var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	 var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	 if (selectid == null) {
		 dhcphaMsgBox.alert($g("没有选中数据,不能拒绝发药!"));
		 return;
	 }
	 var fyflag = selrowdata.TFyFlag;
	 if (fyflag == "OK") {
		 dhcphaMsgBox.alert($g("处方已发药，不能拒绝!"));
		 return;
	 }
	 var prescno = selrowdata.TPrescNo;
	 if (prescno == "") {
		 dhcphaMsgBox.alert($g("请选择要拒绝的处方"));
		 return;
	 }
	 var checkprescref = GetOrdRefResultByPresc(prescno); //LiangQiang 2014-12-22  处方拒绝
	 if (checkprescref == "N") {
		 dhcphaMsgBox.alert($g("该处方已被拒绝,不能重复操作!"))
		 return;
	 } else if (checkprescref == "A") {
		 dhcphaMsgBox.alert($g("该处方已被拒绝,不能重复操作!"))
		 return;
	 }
	 var checkprescadt = GetOrdAuditResultByPresc(prescno);
	 if (checkprescadt == "") {
		 dhcphaMsgBox.alert($g("该处方未审核,禁止操作!"))
		 return;
	 } else if (checkprescadt != "Y") {
		 dhcphaMsgBox.alert($g("该处方审核未通过,禁止操作!"))
		 return;
	 }
	 var waycode = DHCPHA_CONSTANT.VAR.OUTPHAWAY;
	 
	 ShowPHAPRASelReason({
		 wayId:waycode,
		 oeori:"",
		 prescNo:prescno,
		 selType:"PRESCNO"
	 },SaveCommontResultEX,{prescno:prescno});
 }
 
 function SaveCommontResultEX(reasonStr,origOpts){
	 if (reasonStr==""){
		 return "";
	 }
	 var retarr = reasonStr.split("@");
	 var ret = "N";
	 var reasondr = retarr[0];
	 var advicetxt = retarr[2];
	 var factxt = retarr[1];
	 var phnote = retarr[3];
	 var input = ret + "^" + DHCPHA_CONSTANT.SESSION.GUSER_ROWID + "^" + advicetxt + "^" + factxt + "^" + phnote + "^" + DHCPHA_CONSTANT.SESSION.GROUP_ROWID + "^" + origOpts.prescno + "^OR" //orditm;	
	 var refuseret = tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "SaveOPAuditResult", reasondr, input);
	 var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	 if (refuseret == 0) {
		 var newdata = {
			 TDocSS: '拒绝发药'
		 };
		 $("#grid-disp").jqGrid('setRowData', selectid, newdata);
	 } else {
		 dhcphaMsgBox.alert($g("拒绝失败!错误代码:") + refuseret)
		 return;
	 }
 
 }
 // 撤消拒绝发药
 function CancelRefuseFY() {
	 if (DhcphaGridIsEmpty("#grid-disp") == true) {
		 return;
	 }
	 var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	 var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	 if (selectid == null) {
		 dhcphaMsgBox.alert($g("没有选中数据,不能撤消拒绝发药!"));
		 return;
	 }
	 var fyflag = selrowdata.TFyFlag;
	 var prescno = selrowdata.TPrescNo;
	 if (fyflag == "OK") {
		 dhcphaMsgBox.alert($g("该记录已经发药!"));
		 return;
	 }
	 if (prescno == "") {
		 dhcphaMsgBox.alert($g("请选择要撤消拒绝的处方"));
		 return;
	 }
	 var checkprescref = GetOrdRefResultByPresc(prescno); //LiangQiang 2014-12-22  处方拒绝
	 if ((checkprescref != "N") && (checkprescref != "A")) {
		 if (checkprescref == "S") {
			 dhcphaMsgBox.alert($g("该处方医生已提交申诉,不需要撤消!"))
			 return;
		 } else {
			 dhcphaMsgBox.alert($g("该处方未被拒绝,不能撤消操作!"))
			 return;
		 }
	 }
	 var cancelrefuseret = tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "CancelRefuse", DHCPHA_CONSTANT.SESSION.GUSER_ROWID, prescno, "OR");
	 if (cancelrefuseret == "0") {
		 var PrescResult = GetPrescResult(prescno);
		 var newdata = {
			 TDocSS: PrescResult
		 };
 
		 $("#grid-disp").jqGrid('setRowData', selectid, newdata);
		 dhcphaMsgBox.alert($g("撤消成功!"), "success");
	 } else if (cancelrefuseret == "-2") {
		 dhcphaMsgBox.alert($g("该处方未被拒绝,不能撤消操作!"));
	 } else if (retval == "-3") {
		 dhcphaMsgBox.alert($g("该处方已撤消,不能再次撤消!"));
	 }
 }
 //获取处方拒绝结果 
 function GetOrdRefResultByPresc(prescno) {
	 var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdRefResultByPresc", prescno);
	 return ref;
 }
 //获取处方审核结果 
 function GetOrdAuditResultByPresc(prescno) {
	 var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdAuditResultByPresc", prescno);
	 return ref;
 }
 //获取拒绝发药和处方审核结果 
 function GetPrescResult(prescno) {
	 var ref = tkMakeServerCall("web.DHCOUTPHA.Common.CommonDisp", "GetPrescAuditFlag", prescno);
	 return ref;
 }
 //获取处方中未交费医嘱明细
 function GetUnPaidOrder(prescno) {
	 var ref = tkMakeServerCall("PHA.OP.COM.Method", "GetUnPaidInfo", prescno);
	 return ref;
 }
 //获取其他科室未发药记录,仅读卡发药时
 function ChkUnFyOtherLoc() {
	 var LocId=DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	 var GroupId=DHCPHA_CONSTANT.SESSION.GROUP_ROWID;
	 var UserId=DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
	 var ChkOtherLocUnFyRet = tkMakeServerCall("PHA.OP.COM.Method","GetSingleProp",GroupId,LocId,UserId,"ChkUnDispOtherLoc")
	 if (ChkOtherLocUnFyRet!="Y") return;
	 var startdate = $("#date-start").val();
	 var enddate = $("#date-end").val();
	 var patno = $("#txt-patno").val();
	 if ((patno == "") || (patno == null)) {
		 return;
	 }
	 var ret = tkMakeServerCall("PHA.OP.COM.Method", "ChkUnFyOtherLoc", startdate, enddate, patno, DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHWINDOW,1)
	 if (ret == -1) {
		 //alert("病人为空,请读卡")
	 } else if (ret == -2) {
		 dhcphaMsgBox.alert($g("没找到登记号为") + patno + $g("的病人"));
		 return;
 
	 } else if ((ret != "") && (ret != null)) {
		 //dhcphaMsgBox.message(ret);
		 dhcphaMsgBox.alert(ret);
	 }
 }
 //重打标签
function RePrintLabelHandler() {
	if (DhcphaGridIsEmpty("#grid-disp") == true) {
		return;
	}
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert($g("没有选中数据,无法打印!"));
		return;
	}
	var prescno = selrowdata.TPrescNo;
	OUTPHA_PRINTCOM.Label(prescno);
}
 //打印
 function PrintHandler() {
	 if (DhcphaGridIsEmpty("#grid-disp") == true) {
		 return;
	 }
	 var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	 var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	 if (selectid == null) {
		 dhcphaMsgBox.alert($g("没有选中数据,无法打印!"));
		 return;
	 }
	 var prescno = selrowdata.TPrescNo;
	 var phdrow = selrowdata.Tphd;
	 //AfterExecPrint(prescno,PrintType,phdrow,"")
	 OUTPHA_PRINTCOM.Presc(prescno, $g("正方"), "");
 }
 
 //清空
 function ClearConditions() {
	 $("#txt-patno").val("");
	 $("#txt-cardno").val("");
	 $("#txt-recoverBarCode").val("");
	 $('#chk-recover').iCheck('uncheck');
	 $('#chk-disp').iCheck('uncheck');
	 $("#grid-disp").clearJqGrid();
	 $("#grid-dispdetail").clearJqGrid();
	 $("#sel-basicloc").empty();
	 $("#sel-special").empty();
	 var tmpstartdate = FormatDateT("t-2");
	 $("#date-start").data('daterangepicker').setStartDate(tmpstartdate);
	 $("#date-start").data('daterangepicker').setEndDate(tmpstartdate);
	 $("#date-end").data('daterangepicker').setStartDate(new Date());
	 $("#date-end").data('daterangepicker').setEndDate(new Date());
	 QueryGridWaitFY();
	 JqGridCanEdit = true;
	 ClearErpMenu();
	 curPatNo = "";
	 return
	 if ($("#col-right").is(":hidden") == false) {
		 $("#col-right").hide();
		 $("#col-left").removeClass("col-lg-9 col-md-9 col-sm-9")
	 } else {
		 $("#col-right").show()
		 $("#col-left").addClass("col-lg-9 col-md-9 col-sm-9")
	 }
	 $("#grid-disp").setGridWidth("")
	 $("#grid-dispdetail").setGridWidth("")
	 $("#grid-waitfy").setGridWidth("");
	 
 }
 
 //初始化配药窗口table
 function InitGridWin() {
	 var columns = [{
			 header: ("药房窗口"),
			 index: 'phwWinDesc',
			 name: 'phwWinDesc'
		 },
		 {
			 header: ("窗口状态"),
			 index: 'phwWinStat',
			 name: 'phwWinStat',
			 formatter: statusFormatter,
			 title: false
		 },
		 {
			 header: 'phwid',
			 index: 'phwid',
			 name: 'phwid',
			 width: 20,
			 hidden: true
		 },
		 {
			 header: 'phwpid',
			 index: 'phwpid',
			 name: 'phwpid',
			 width: 20,
			 hidden: true
		 }
	 ];
	 var jqOptions = {
		 colModel: columns, //列
		 url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryDispWinList&gLocId=' + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + '',
		 height: '100%',
		 autowidth: true,
		 loadComplete: function () {
 
		 }
	 };
	 $("#grid-window").dhcphaJqGrid(jqOptions);
 }
 
 function statusFormatter(cellvalue, options, rowdata) {
	 if (cellvalue == "有人") {
		 return '<input name="dhcphaswitch" type="checkbox" checked> '
	 } else {
		 return '<input name="dhcphaswitch" type="checkbox" unchecked> '
	 }
 }
 
 function ChangeWinStat(state) {
	 var wintd = $(event.target).closest("td");
	 var rowid = $(wintd).closest("tr.jqgrow").attr("id");
	 var selrowdata = $("#grid-window").jqGrid('getRowData', rowid);
	 var phwpid = selrowdata.phwpid;
	 var phwid= selrowdata.phwid
	 var phwWinStat = state;
	 var winstat = "";
	 if (phwWinStat == true) {
		 phwWinStat = "1";
	 } else {
		 phwWinStat = "0";
	 }
	 var paramStr=DHCPHA_CONSTANT.SESSION.GROUP_ROWID+"^"+DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID+"^"+DHCPHA_CONSTANT.SESSION.GUSER_ROWID+"^"+DHCPHA_CONSTANT.SESSION.GHOSP_ROWID;
	 var modifyret = tkMakeServerCall("PHA.OP.CfDispWin.OperTab", "UpdWinDoFlag", phwid, phwWinStat,paramStr);
	 if (modifyret == 0) {
		 return true;
	 } else if (modifyret == -11) {
		 dhcphaMsgBox.alert($g("请确保至少一个窗口为有人状态!"));
		 return false;
	 } else {
		 dhcphaMsgBox.alert($g("修改窗口状态失败,错误代码:") + modifyret, "error");
		 return false;
	 }
 }
 //发药窗口确认
 function FYWindowConfirm() {
	 var pyusr = DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
	 var ctloc = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	 var fywindata = $("#sel-window").select2("data")[0];
	 var fystaffdata = $("#sel-staff").select2("data")[0];
	 if (fywindata == undefined) {
		 dhcphaMsgBox.alert($g("发药窗口不能为空!"));
		 return false;
	 }
	 if (fystaffdata == undefined) {
		 dhcphaMsgBox.alert($g("配药人不能为空!"));
		 return false;
	 }
	 var fywin = fywindata.id;
	 var fywindesc = fywindata.text;
	 var fystaff = fystaffdata.id;
	 var fystaffdesc = fystaffdata.text;
	 $('#modal-windowinfo').modal('hide');
	 $("#currentwin").text("");
	 $("#currentwin").text(fywindesc);
	 DHCPHA_CONSTANT.DEFAULT.PHWINDOW = fywin;
	 $("#currentpyuser").text("");
	 $("#currentpyuser").text(fystaffdesc);
	 DHCPHA_CONSTANT.DEFAULT.PHPYUSER = fystaff;
	 var phcookieinfo = fywin + "^" + fywindesc + "^" + fystaff + "^" + fystaffdesc;
	 removeCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^disp");
	 setCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^disp", phcookieinfo);
	 ClearConditions();
	 return false;
 }
 
 //权限验证
 function CheckPermission() {
	 if(LoadOrdItmId!=""){
	 	InitParams();
	 }
	 $.ajax({
		 url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=CheckPermission' +
			 '&groupId=' + DHCPHA_CONSTANT.SESSION.GROUP_ROWID +
			 '&gUserId=' + DHCPHA_CONSTANT.SESSION.GUSER_ROWID +
			 '&gLocId=' + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
		 type: 'post',
		 success: function (data) {
			 var retjson = JSON.parse(data);
			 var retdata = retjson[0];
			 var permissionmsg = "",
				 permissioninfo = "";
			 if (retdata.phloc == "") {
				 permissionmsg = $g("药房科室")+":" + DHCPHA_CONSTANT.DEFAULT.LOC.text;
				 permissioninfo = $g("尚未在门诊药房科室配置的人员权限页签中维护!")
			 } else {
				 permissionmsg = $g("工号")+":" + DHCPHA_CONSTANT.SESSION.GUSER_CODE + "　　"+$g("姓名")+":" + DHCPHA_CONSTANT.SESSION.GUSER_NAME;
				 if (retdata.phuser == "") {
					 permissioninfo = $g("尚未在门诊药房科室配置的人员权限页签维护!")
				 } else if (retdata.phnouse == "Y") {
					 permissioninfo = $g("门诊药房科室配置的人员权限页签中已设置为无效!")
				 } else if (retdata.phfy != "Y") {
					 permissioninfo = $g("门诊药房科室配置的人员权限页签中未设置发药权限!")
				 }
			 }
			 if (permissioninfo != "") {
				 $('#modal-dhcpha-permission').modal({
					 backdrop: 'static',
					 keyboard: false
				 }); //点灰色区域不关闭
				 $('#modal-dhcpha-permission').on('show.bs.modal', function () {
					 $("#lb-permission").text(permissionmsg)
					 $("#lb-permissioninfo").text(permissioninfo)
 
				 })
				 $("#modal-dhcpha-permission").modal('show');
			 } else {
				 DHCPHA_CONSTANT.DEFAULT.PHLOC = retdata.phloc;
				 DHCPHA_CONSTANT.DEFAULT.PHUSER = retdata.phuser;
				 DHCPHA_CONSTANT.DEFAULT.CYFLAG = retdata.phcy;
				 DHCPHA_CONSTANT.DEFAULT.OweDisp = retdata.owedisp;
				 var getphcookie = getCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^disp");
				 if (getphcookie != "") {
					 $("#currentwin").text(getphcookie.split("^")[1]);
					 DHCPHA_CONSTANT.DEFAULT.PHWINDOW = getphcookie.split("^")[0];
					 $("#currentpyuser").text(getphcookie.split("^")[3]);
					 DHCPHA_CONSTANT.DEFAULT.PHPYUSER = getphcookie.split("^")[2];
					 QueryGridWaitFY();
				 } else {
					 $("#modal-windowinfo").modal('show');
				 }
				 $('#modal-windowinfo').on('show.bs.modal', function () {
					 $("#sel-window ").empty();
					 $("#sel-staff ").empty();
				 })
			 }
			 if (DHCPHA_CONSTANT.DEFAULT.CYFLAG == "Y") {
				 $("#grid-disp").setGridParam().showCol("TJS");
				 $("#grid-disp").setGridParam().showCol("TOrdGroup");
			 }
		 },
		 error: function () {}
	 })
 }
 //初始化发药窗口
 function InitFYWin() {
	 var selectoption = {
		 url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
			 "?action=GetFYWinList&style=select2&gLocId=" +
			 DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
		 minimumResultsForSearch: Infinity
	 }
	 $("#sel-window").dhcphaSelect(selectoption)
 }
 //初始化发药人员
 function InitFYSTAFF() {
	 var selectoption = {
		 url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
			 "?action=GetPYUserList&style=select2" + '&gLocId=' +
			 DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + '&gUserId=' +
			 DHCPHA_CONSTANT.SESSION.GUSER_ROWID + "&flag=PY",
		 minimumResultsForSearch: Infinity
	 }
	 $("#sel-staff").dhcphaSelect(selectoption)
 }
 
 function InitBodyStyle() {
	 $("#grid-waitfy").setGridWidth("");
	 if (LoadPatNo != "") {
		 setTimeout(function () {
			 $("#txt-patno").val(LoadPatNo);
			 InitParams();
			 QueryGridDisp();
		 }, 1000)
	 }
 }
function InitParams(){
	if(LoadOrdItmId==""){return;}
	var retVal=tkMakeServerCall("PHA.COM.Method","GetOrdItmInfoForTipMess",LoadOrdItmId,DHCPHA_CONSTANT.SESSION.GUSER_ROWID ,DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
	if(retVal!="{}"){
		var retJson=JSON.parse(retVal)
		var ordDate=retJson.ordDate;
		$("#date-start").data('daterangepicker').setStartDate(ordDate);
		$("#date-start").data('daterangepicker').setEndDate(ordDate);
		
		var winId=retJson.winId;
		var winDesc=retJson.winDesc;
		var perId=retJson.perId;
		var perName=retJson.perName;
		if((winId !="")&&(perId !="" )){
	 		var phcookieinfo =  winId + "^" + winDesc + "^" + perId + "^" + perName;
	 		removeCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^disp");
	 		setCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^disp", phcookieinfo);
		}
	}
}
 //读卡返回,后期读卡可能用这种方式
 function CardCallBack() {
	 var cardTypeRowId = arguments[0];
	 var cardTypeDesc = arguments[1];
	 var cardTypeValue = arguments[1];
	 myrtn = DHCACC_GetAccInfo(cardTypeRowId, cardTypeValue);
	 if (myrtn == -200) { //卡无效
		 dhcphaMsgBox.alert($g("卡无效!"));
		 return;
	 }
	 var myary = myrtn.split("^");
	 var rtn = myary[0];
	 switch (rtn) {
		 case "0":
			 //卡有效
			 PatientID = myary[4];
			 var PatientNo = myary[5];
			 var CardNo = myary[1]
			 var NewCardTypeRowId = myary[8];
			 break;
		 case "-200":
			 dhcphaMsgBox.alert($g("卡无效!"));
			 break;
		 case "-201":
			 //现金
			 PatientID = myary[4];
			 var PatientNo = myary[5];
			 var CardNo = myary[1]
			 var NewCardTypeRowId = myary[8];
			 break;
		 default:
	 }
 }
 
 function addtSendVoiceCellAttr(rowId, val, rawObject, cm, rdata) {
	 var callFlag=rawObject.callFlag
	 if (callFlag =="0") {
		 return "class=dhcpha-record-call";
	 }else if (callFlag == "3") {
		 return "class=dhcpha-record-skip";
	 }else if (callFlag == "5") {
		 return "class=dhcpha-record-unqueue";
	 }else {
		 return "";
	 }
 }
 
 function addPhDispStatCellAttr(rowId, val, rawObject, cm, rdata) {
	 if (val == $g("已配药")) {
		 return "class=dhcpha-record-pyed";
	 } else if (val == $g("已打印")) {
		 return "class=dhcpha-record-printed";
	 } else if (val == $g("已发药")) {
		 return "class=dhcpha-record-disped";
	 } else {
		 return "";
	 }
 }
 
 function addPhDispItmStatCellAttr(rowId, val, rawObject, cm, rdata) {
	 if (val == $g("库存不足")) {
		 return "class=dhcpha-record-nostock";
	 } else if ((val.indexOf($g("作废")) > 0) || (val.indexOf($g("停止")) > 0)) {
		 return "class=dhcpha-record-ordstop";
	 }else if ((val.indexOf($g("退费")) > 0) || (val.indexOf($g("未收费")) > -1)){
		 return "class=dhcpha-record-owefee";
	 }else {
		 return "";
	 }
 }
 
 function PhaGridFocusOut(gridid) {
	 $("#" + gridid).on("mouseleave",function (e) {
		 if (e.relatedTarget) {
			 var $related = $("#" + gridid).find(e.relatedTarget);
			 if ($related.length <= 0 && LastEditSel != "") {
				 $("#" + gridid).jqGrid('saveRow', LastEditSel);
			 }
		 }
	 })
 }
 //读卡
 function BtnReadCardHandler() {
	 var readcardoptions = {
		 CardTypeId: "txt-cardtype",
		 CardNoId: "txt-cardno",
		 PatNoId: "txt-patno"
	 }
	 DhcphaReadCardCommon(readcardoptions, ReadCardReturn)
 }
 //读卡返回操作
 function ReadCardReturn() {
	 QueryGridDisp();
 }
 function InitConfig(){
	 var CongigStr= tkMakeServerCall("PHA.OP.COM.Method", "GetParamProp", DHCPHA_CONSTANT.SESSION.GROUP_ROWID, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, DHCPHA_CONSTANT.SESSION.GUSER_ROWID)
	 if(CongigStr!=""){
		 var arr=CongigStr.split("^");
		 if(arr.length>=13){
			 PrintType=arr[10];
			 FocusFlag=arr[12];
			 PartPiedDispFlag=arr[13];
			 OnlyDispByPatNoFlag = arr[15];
		 }
	 }
 }
 function CardBillClick(){	
	 var readcardoptions = {
		 CardTypeId: "txt-cardtype",
		 CardNoId: "txt-cardno",
		 PatNoId: "txt-patno"
	 }
	 DhcphaReadCardCommon(readcardoptions, CardPay)
 }
 function CardPay(){
	 
	 var startdate = $("#date-start").val();
	 var enddate = $("#date-end").val();
	 var carpayoptions = {
		 CardTypeId: "txt-cardtype",
		 CardNoId: "txt-cardno",
		 PatNoId: "txt-patno",
		 StDate:startdate,
		 EndDate:enddate
	 }	
	 DhcCardPayCommon(carpayoptions,QueryGridDisp);	
 }
 
 
 function SendOPInfoToMachine(faceCode,prescNo,patNo)
 {
	 if(prescNo==undefined){
		 prescNo=""
	 }
	 if(patNo==undefined){patNo="";}
	 var paramStr = {
		 faceCode:faceCode,
		 prescNo: prescNo,
		 patNo:patNo
	 };
	 DoOPInterfaceCom(paramStr)
 }
 function Setfocus()
 {
	 $("#txt-patno").val("");
	 $("#txt-cardno").val("");
 
	 if(FocusFlag==1){
		 $('#txt-cardno').focus();
	 }
	 else{
		 $('#txt-patno').focus();
	 }
 }
 
 function ChkUnFyThisLoc(dspPrescNum)
 {
	 var LocId=DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	 var GroupId=DHCPHA_CONSTANT.SESSION.GROUP_ROWID;
	 var UserId=DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
	 var ChkUnFyRet=tkMakeServerCall("PHA.OP.COM.Method","GetSingleProp",GroupId,LocId,UserId,"ChkUnDispPrescNum")
	 if (ChkUnFyRet!="Y") return;
	 var PatNo=curPatNo
	 var GPhl=DHCPHA_CONSTANT.DEFAULT.PHLOC;
	 var GPhw = DHCPHA_CONSTANT.DEFAULT.PHWINDOW;
	 var StDate = $("#date-start").val();
	 var EndDate = $("#date-end").val();
	
	 var fyrowdata = $("#grid-disp").jqGrid('getRowData');
	 var fygridrows = fyrowdata.length;	 
	 if(dspPrescNum!=1){
		var successNum=0;
		for (var rowi = 1; rowi <= fygridrows; rowi++) {
			rowdata = fyrowdata[rowi-1]
			var okFlag = rowdata.TFyFlag;		 
			if(okFlag == "OK")successNum = successNum + 1
		}
		dspPrescNum = successNum;
	}
	 
	 if (PatNo!=""){
		 var unDspNum=tkMakeServerCall("PHA.OP.COM.Method","ChkUnFyThisLoc",StDate,EndDate,PatNo,GPhl)
		 var otherLocRet=tkMakeServerCall("PHA.OP.COM.Method","ChkUnFyOtherLoc",StDate,EndDate,PatNo,GPhl,GPhw, "1")
		 if (unDspNum<0) unDspNum=0
		 if (unDspNum>=0) { 
			 var prescNum = parseInt(unDspNum) + dspPrescNum;
			 var alertMsg=$g("该患者本次就诊共缴费待发处方数：")+prescNum+"<br>"+$g("此次发药处方数：")+dspPrescNum+"</br>"+$g("待发处方数：")+unDspNum
			 if (otherLocRet!="") alertMsg=alertMsg +"</br>"+otherLocRet
			 dhcphaMsgBox.alert(alertMsg)
		 }
		 else  if (otherLocRet!="") {
			 dhcphaMsgBox.alert(otherLocRet)
		 }
	 }else  {
		dhcphaMsgBox.alert($g("此次发药处方数：")+dspPrescNum)
	 }
 }
// add by zhaoxinlong  2022.05.16 
 function IsOnlyOnePatno()
 {
	var firstrowdata = $("#grid-disp").jqGrid('getRowData', 1);
	var firstpatno = firstrowdata.patNo;
	var fyrowdata = $("#grid-disp").jqGrid('getRowData');
	var fygridrows = fyrowdata.length;
	for (var rowi = 1; rowi <= fygridrows; rowi++) {
		var rowdata = $("#grid-disp").jqGrid('getRowData', rowi);
		var patno = rowdata.patNo;
		if (patno != firstpatno){
			return false;
		}	
	}
	return true;
 }
 function ChkDataBeforeALLFY(){
	var $grid = $("#grid-disp")
	var fyrowdata = $grid.jqGrid('getRowData');
    var fygridrows = fyrowdata.length;
	for (var rowi = 1; rowi <= fygridrows; rowi++) {
		var rowdata = $grid.jqGrid('getRowData', rowi);
		var okFlag = rowdata.TFyFlag;		 
		if(okFlag == "OK"){
			return false;
		}
   	}
	return true;
}
