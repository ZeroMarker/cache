var m_SelectCardTypeDR="";
var m_CardNoLength="";
var LgParams=LgHospID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgUserID;
var TrsExecTime=$g("执行时间");
var TrsSave=$g('保存');
var TrsCancel=$g('取消');
var TrsadmDeptDesc=$g('就诊科室');
var TrsorcatDesc=$g('医嘱大类');
var TrsarcimDesc=$g('医嘱名称');
var TrsphOrdQtyUnit=$g('总量');
var Trsprice=$g('单价');
var TrstotalAmount=$g('总价');
var TrsctcpDesc=$g('开医嘱人');
var TrsreclocDesc=$g('接收科室');
var TrscreateDateTime=$g('开医嘱时间');
var TrssttDateTime=$g('要求执行时间');
var TrsordStatDesc=$g('医嘱状态');
var TrsphcduDesc1=$g('疗程');
//var LODOP = getLodop();
$(document).ready(function(){
	InitES6();	   //初始化ES6环境
	initParams();
	initUI();      //初始化UI
	initBTN()  	   //初始化按钮事件
	initInput()    //初始化Input事件
	initCombobox() //初始化combobox
	initDateBox()  //初始化datebox
	initDefaultValue() //初始化默认值
	search();	
})

function InitES6(){
	if(websys_isIE){
		$.getScript("../scripts/dhcbill/plugin/bluebird/bluebird.min.js")
	}
}

function initParams(){
	///患者队列查询类型同步
	if(parent.TempCheckExecCode){
		var $formExecBtn=$("button[id='"+parent.TempCheckExecCode+"']")	
		if($formExecBtn.length){
			$("#queryTypeGrp button").removeClass("htm-tab");  
	  		$formExecBtn.addClass("htm-tab");
	  		$("#QueryTypeCode").val($formExecBtn.attr("id"));
	  		$("#ExecFormID").val($formExecBtn.attr("data-id"));
		}
		parent.TempCheckExecCode="";
	}
	
	if(parent.IsCheckExec){
		$HUI.checkbox("#exeRadio").setValue("true");
		parent.IsCheckExec="";
	}
	if(parent.PatCardNo!=undefined){
		$("#cardNo").val(parent.PatCardNo);
	}
	if(parent.CardTypeNew!=undefined){
		$("#CardTypeNew").val(parent.CardTypeNew);
	}
}

function initUI(){
	if(ISSHOWATTACH==1){
		$('#attachtable').datagrid({
			fitColumns:true,
			fit:true,
			pagination:true,
	        //url:'dhcapp.broker.csp?ClassName=web.DHCNurCom&MethodName=FindOrditemAttach&IsQuery=Y',
	        url:'dhcapp.broker.csp?ClassName=web.DHCEMNurExe&MethodName=GetAttach',
	        columns:[[
			{field: 'admDeptDesc',title: TrsadmDeptDesc}, //'就诊科室'
			{field: 'orcatDesc',title: TrsorcatDesc}, //'医嘱大类'
			{field: 'arcimDesc',title: TrsarcimDesc}, //'医嘱名称'
			{field: 'phOrdQtyUnit',title: TrsphOrdQtyUnit}, //'总量'
			{field: 'price',title: Trsprice}, //'单价'
			{field: 'totalAmount',title: TrstotalAmount}, //'总价'
			{field: 'ctcpDesc',title: TrsctcpDesc}, //'开医嘱人'
			{field: 'reclocDesc',title: TrsreclocDesc}, //'接收科室'
			{field: 'createDateTime',title: TrscreateDateTime}, //'开医嘱时间'
			{field: 'sttDateTime',title: TrssttDateTime}, //'要求执行时间'
			{field: 'ordStatDesc',title: TrsordStatDesc}, //'医嘱状态'
			{field: 'phcduDesc1',title: TrsphcduDesc1}, //'疗程'
			{field: 'oeoriId',title: 'oeoriId'},
			{field: 'disposeStatCode',title: 'disposeStatCode'}
			]]
	    });
	}else{
			$('#mainLayout').layout('remove', 'south');	
	}
	//显示治疗按钮
	$("#treatQueBtn").hide();
	$.ajax({ 
          type : "post", 
          url : "websys.Broker.cls", 
          data : {ClassName:"web.DHCEMOrdInfoVO",MethodName:"checkTreate",coputerName:window.parent.serverName}, 
          success : function(ret){ 
            if(ret==1){
	            if(parent.$("#BloodToolbar").length) return; ///有采血队列的是采血护士,不显示排队按钮
				$("#treatQueBtn").show();
			}
          } 
    }); 		
	showBTN();
	$('#botColorHintDiv').window('close');  //hxy 2018-07-03	
}
function showBTN(){
	hiddenAll();
	typeCode=$("#QueryTypeCode").val();
	
	//后台配置：显示什么按钮
	var showBtnDesc = BtnSetObj[typeCode]==undefined?"":BtnSetObj[typeCode];
	if(showBtnDesc!=""){
		var showBtnArr=showBtnDesc.split(",");
		for (i in showBtnArr){
			var btnDesc= showBtnArr[i];
			$("#BtnGroup a[data="+btnDesc+"]").show(); //hxy 2023-02-22 st
//		 	if($("a:contains("+showBtnArr[i]+")").length>0){
//			 	$("a:contains("+showBtnArr[i]+")").each(function(){
//					if($.trim($(this).text())==btnDesc){
//						$(this).show();
//					}
//				});
//			} //ed
		}
	}
	
	//留观和非留观判断
	if(ObsFlag==1){
		$("#nurAddOrderBtn").show();
		$("#prtbedcardBtn").show();
		$("#message").show();
	}else{
		$("#cardpaybtn").show();
		if(ARRANGESEAT==1) $("#arrangeSeatBtn").show();
		$("#nurAddOrderBtn").show();
		$("#message").show();
	}	
	
	///根据后台显示按钮+是否已执行按钮
	showExecOrCanExec(typeCode);
	
	return;
}
///根据后台显示按钮+是否已执行按钮
function showExecOrCanExec(){
	var typeCode=$("#QueryTypeCode").val();
	var exec=$("#exeRadio:checked").val()=="on"?"Y":"N";
	var showBtnInfo = BtnSetObj[typeCode]==undefined?"":","+BtnSetObj[typeCode]+",";

	if(exec=="N"){
		$("a:contains('"+$g("执行")+"')").each(function(){
			var thisText=$.trim($(this).text())
			if(thisText==$g("执行")){
				if(showBtnInfo.indexOf($g(",撤销,"))!=-1){
					$(this).show();
				}
			}else if(thisText==$g("执行并打印")){
				if(showBtnInfo.indexOf($g(",执行并打印,"))!=-1){
					$(this).show();
				}
			}else{
				$(this).hide();
			}
		});
	}
	
	if(exec=="Y"){
		$("a:contains('"+$g("执行")+"')").each(function(){
			var thisText=$.trim($(this).text())
			if(thisText==$g("撤销执行")){
				if(showBtnInfo.indexOf($g(",撤销执行,"))!=-1){
					$(this).show();
				}
			}else{
				$(this).hide();
			}
		});
	}	
}
function hiddenAll(){
	$("#exePrnBtn").hide();
	$("#exeBtn").hide();
	$("#prnBtn").hide();
	$("#undoBtn").hide();
	$("#tpqBtn").hide();
	$("#prtbedcardBtn").hide();
	$("#nurAddOrderBtn").hide();
	$("#switchBtn").hide();
	$("#selAllCard").hide();
	$("#canAllCard").hide();
	$("#message").hide();
	$("#arrangeSeatBtn").hide();
	$("#cardpaybtn").hide();
	$("#littleJY").hide();
	$("#RecOrdBtn").hide();
	$("#AddOrdBtn").hide();
	$("#RecOrdListBtn").hide();
}
function showCommon(){
	$("#exePrnBtn").show();
	$("#exeBtn").show();
	$("#prnBtn").show();
	$("#undoBtn").show();
	$("#nurAddOrderBtn").show();
	isShowPrtBedCard();
	if(ARRANGESEAT==1){
		$("#arrangeSeatBtn").show();
	}
}
function isShowPrtBedCard(){
	//输液护士不需要床头卡打印
	if(ISSHOWSY!=1){
		$('#prtbedcardBtn').show();
	}	
}
function initInput(){
	$('#RegNo').on('keypress', function(e){   
		// 监听回车按键   
		e=e||event;
		if(e.keyCode=="13"){
			$('#cardNo').val("");
			 
			if($('#RegNo').val()==""){
				parent.$.messager.alert("提示:","登记号为空");    
				return;
			}
			patNoEnter();				
		}
	});
	
	$('#RegNo').on('blur', function(){   
		$('#RegNo').val()?patNoEnter():"";
	});
	
	
	
	$('#cardNo').on('keypress', function(e){   
		// 监听回车按键   
		e=e||event;
		if(e.keyCode=="13"){
			$('#RegNo').val("");
			var CardNo = $("#cardNo").val();
			if (CardNo == "") return;
			DHCACC_GetAccInfo("", CardNo, "", "", ReadCardCallback);
		}
	});	
}

function patNoEnter(){
	var regNo = $('#RegNo').val(); 
	var m_lenght =serverCall("web.DHCCLCom","GetPatConfig",{}).split("^")[0] 
	///登记号补0
	for (i=regNo.length;i<m_lenght;i++){
		regNo = "0"+regNo;
	}	
	$('#RegNo').val(regNo);
	searchByRegNo(regNo);
}

//初始化按钮事件	
function initBTN(){
	$("#queryBtn").on('click',function(){search();})
	//补录医嘱	
	$("#nurAddOrderBtn").on('click',function(){nurAddOrder()})
	//安排座位
	$("#arrangeSeatBtn").on('click',function(){arrangeSeat()})
	//执行并打印	
	//$("#exePrnBtn").on('click',function(){exeAction("F","Y");})
	$("#exePrnBtn").on('click',function(){WriExeTimeWinNew("F","Y");}); /// 增加修改执行时间 2018-11-23 bianshuai
	//打印执行记录	scripts/dhcem/print.exec.hisui.js	
	$("#prnBtn").on('click',function(){printAction();})
	//床头卡打印 scripts/dhcem/print.bedcard.hisui.js	
	$("#prtbedcardBtn").on('click',function(){printBedCard()})
	//执行医嘱
	//$("#exeBtn").on('click',function(){exeAction("F","");})
	$("#exeBtn").on('click',function(){WriExeTimeWinNew("F","");})
	//撤销执行医嘱
	$("#undoBtn").on('click',function(){WriExeTimeWinNew("C","");})
	//贴瓶签  scripts/dhcem/print.exec.hisui.js	
	$("#tpqBtn").on('click',function(){PrintTPQList();})
	//切换输液卡片样式和table样式 scripts/dhcem/print.exec.hisui.js	
	$("#switchBtn").on('click',function(){switchAction()})
	 
	$("#selAllCard").on('click',function(){AllSelCard()});
	$("#canAllCard").on('click',function(){AllSelCardClear()});
	
	$("#selAllCard").on('click',function(){AllSelCardNew()});
	$("#canAllCard").on('click',function(){AllSelCardClearNew()});
	
	$("#littleJY").on('click',function(){showOrdExecInfo()});
	
	$("#cardpaybtn").on('click',function(){Cardpay()})
	
	//切换输液卡片样式和table样式 scripts/dhcem/print.exec.hisui.js	
	$("#message").on('click',function(){messageAction()})
	//读卡
	$("#readCardNo").on('click',function(){readCardNo()})
	//排队
	$("#treatQueBtn").on('click',function(){treatQueAction()})		 
	$("#queryTypeGrp > button").click(function(){	
  		$("#queryTypeGrp button").removeClass("htm-tab");  //hxy 2016-11-29 htm-tab(四个)
  		$(this).addClass("htm-tab");
  		$("#QueryTypeCode").val($(this).attr("id"));
  		$("#ExecFormID").val($(this).attr("data-id"));
  		search();
	});	
	
	$("#RecOrdBtn").on('click',function(){RecOrdClick()});
	$("#AddOrdBtn").on('click',function(){AddOrdClick()});
	$("#RecOrdListBtn").on('click',function(){RecOrdListClick()});
}



//hxy 2019-09-03 接单加单列表 st
function RecOrdClick(){
	RecOrd(0);
}
function AddOrdClick(){ //加单
	RecOrd(1);
}  
function RecOrd(flag){
	var RecOrdAbnorm=""; //皮试阳性标识
	var oeoriIdStr = "";
	var selectRowDatas=$("#execTable").datagrid('getSelections');
	//输液单 切换瓶签模式 add lvpeng
	if($("#c2").is(':visible')){	
		$('input[name="IfPrint"]:checked').each(function(){
			if($(this).attr('data-oeoreid').split("^").length==1){
				var oeoriIdretstr = serverCall("Nur.NurseExcuteSheet", "getOrderGroupIdStr", {orderId:$(this).attr('data-oeoreid'),queryCode:""});
				var oeoriIdretstrList = oeoriIdretstr.split("#");
				var oeoriId = oeoriIdretstrList[0];
				if (oeoriId != "") {
					if (oeoriIdStr.length == 0) {
						oeoriIdStr = oeoriId;
					} else {
						oeoriIdStr = oeoriIdStr + "^" + oeoriId;
					}					
				}
			}else if($(this).attr('data-oeoreid').split("^").length>1){
				var arciDescArr = $(this).attr('data-arcidesc').split("^");
				for(j=0;j<$(this).attr('data-oeoreid').split("^").length;j++){
					if(arciDescArr[j].indexOf("__")!=-1) continue;
					var oeoriIdretstr = serverCall("Nur.NurseExcuteSheet", "getOrderGroupIdStr", {orderId:$(this).attr('data-oeoreid').split("^")[j],queryCode:""});
					var oeoriIdretstrList = oeoriIdretstr.split("#");
					var oeoriId = oeoriIdretstrList[0];
	   				if (oeoriId != "") {
						if (oeoriIdStr.length == 0) {
							oeoriIdStr = oeoriId;
						} else {
							oeoriIdStr = oeoriIdStr + "^" + oeoriId;
						}
					}			
				}		
			}
		})
		
	}else{
		for (i = 0; i < selectRowDatas.length; i++) {
			if(selectRowDatas[i].disposeStatCode=="SkinTestAbnorm"){
				RecOrdAbnorm=1;
			}
			var oeoriId = selectRowDatas[i].oeoreId;
			if(selectRowDatas[i].arcimDesc.indexOf("__")!="-1") continue; 
			var oeoriIdretstr = serverCall("Nur.NurseExcuteSheet", "getOrderGroupIdStr", {orderId:oeoriId,queryCode:""});
			var oeoriIdretstrList = oeoriIdretstr.split("#");
			var oeoriId = oeoriIdretstrList[0];
			if (oeoriId != "") {
				if (oeoriIdStr.length == 0) {
					oeoriIdStr = oeoriId;
				} else {
					oeoriIdStr = oeoriIdStr + "^" + oeoriId;
				}
			}
		}
		
	}
	if(oeoriIdStr == "") {
		parent.$.messager.alert('提示',"没有需要操作的医嘱,请选择医嘱!");
		return;
	}
	if(RecOrdAbnorm == 1) {
		parent.$.messager.alert('警告',"皮试阳性!");
		return;
	}
	if(oeoriIdStr!=""){
		var ret=""
		if(flag==0){
			ret = tkMakeServerCall("Nur.DHCNurOPReceiveOrd", "Save", oeoriIdStr, LgUserID, LgCtLocID);
		}else{
			ret = tkMakeServerCall("Nur.DHCNurOPReceiveOrd", "Save", oeoriIdStr, LgUserID, LgCtLocID,"","","add");
		}
		if(ret.indexOf("err:")>-1){
			parent.$.messager.alert("提示",ret.split(":")[1]);
		}else{
			parent.$.messager.alert("提示","操作成功!");
			PrintTPQList(); //贴瓶签
			printPDACard(3); //hxy 2019-11-19 加单：打印信息条码一条 st
			if(flag==0){
				//printPDACard(3); //接单：打印信息条码两条 //hxy 2019-12-09 接单不需要打两个，打一个即可 //2020-01-13 输液卡要打两个条码了
			} 
		}
	}
}

function RecOrdListClick() {
	var regNo = $("#RegNo").val();
	if(regNo==""){
		alert("请输入登记号!")
		return;
	}
	var lnk = "dhc.nurse.oppda.recordlist.csp?" + "&regNo=" + regNo;
	
	websys_showModal({
		url: lnk,
		width: '1350px',
		height: '500px',
		iconCls:"icon-w-paper",
		title: $g('接单列表'),
		closed: true,
		modal:true,
		onClose:function(){
			
		}
	}); 
	
	return;
 }


function showOrdExecInfo(){
	var mainOrd="",selOnlyFlag=true;
	if($("#c2").is(':visible')){
		$('input[name="IfPrint"]:checked').each(function(){
			var OeoreID = $(this).attr('data-mainoeoreid');
			var OeoriID= OeoreID.split("||")[0]+"||"+OeoreID.split("||")[1]
			if(mainOrd!=""){
				if(mainOrd!=OeoriID) selOnlyFlag=false;
			}
			mainOrd = OeoriID;
		})
	}else{
		data= $("#execTable").datagrid("getSelections")	
		for(var i =0;i<data.length;i++){
			if(mainOrd!=""){
				if(mainOrd!=data[i].mainOrdItmID) selOnlyFlag=false;
			}
			mainOrd = data[i].mainOrdItmID;
		}
	}
	
	if(mainOrd==""){
		parent.$.messager.alert('警告','未选择医嘱！');
		return ;
	}
	
	if(!selOnlyFlag){
		parent.$.messager.alert('警告','请勿选中多组医嘱！');
		return ;
	}
	
	var url = 'dhcem.ordexecdetail.csp?OEORIId='+mainOrd;
	
	
	websys_showModal({
		url: url,
		width: window.screen.availWidth-100,
		height: window.screen.availHeight-500,
		iconCls:"icon-w-paper",
		title: $g('执行概览'), //小脚丫
		closed: true,
		modal:true,
		onClose:function(){
			
		}
	}); 

}

//
function initDateBox(){
	$('#startdate').datebox({
		onSelect: function(date){
			
		},
		onChange: function (newDate,oldDate){
			window.parent.StartDate=newDate;
		}
	});
	$('#enddate').datebox({
		onSelect: function(date){
			
		},onChange: function (newDate,oldDate){
			window.parent.EndDate=newDate;
		}
	});
}
//处置状态样式 hxy 2016-12-01
function disposeStatDescCellStyle(value, row, index){
	opt={};
	if(row.disposeStatDesc==$g("需处理临嘱")){
		opt={class: 'td-needdo-order'}	
	}
	if(row.disposeStatDesc==$g("已处理")){
		opt={class: 'td-did-order'}	
	}
	if(row.disposeStatDesc==$g("未收费")){
		opt={class: 'td-nopay-order'}	
	}
	if(row.disposeStatDesc==$g("皮试")){
		opt={class: 'bg-danger'}	
	}
	return opt;
	
}
function arcimDescFormatter(value,rowData,index){
	
	
	var returnStr="";
	///超1小时未执行
	if(rowData.overTimeReqExecDate){
		if(rowData.overTimeReqExecDate>0){
			returnStr = returnStr+"<span class='my-face' style='font-weight: 600;color:#000;background: #edfd6d;width: 20px;display: inline-block;text-align: center;border-radius: 5px;'>"+$g("超")+"</span>";
		}
	}
	if(rowData.isCaExec){
		if(rowData.isCaExec!=""){
			returnStr = returnStr+"<img style='position: relative;top: 2px;' src='../skin/default/images/ca_icon_green.png'></img>";
		}
	}
	returnStr = returnStr+"<b style='background-color:"+rowData.tubeColor;
	
	if(true){   ///这个判断谁根据配置颜色深浅来决定选中后底色是否发生改变  ggm 2017-08-29 检验颜色修改
		returnStr=returnStr+" !important'>";
	}
	var arcimDescColor="";
	if(rowData.tubeColor=="#000000"){   ///这个判断谁根据配置颜色深浅来决定字体的颜色
		arcimDescColor="#FFF";
	}else if(rowData.tubeColor=="#8e7cc3"){   ///这个判断谁根据配置颜色深浅来决定字体的颜色
		arcimDescColor="#FFF";
	}else if(rowData.tubeColor=="#0000ff"){   ///这个判断谁根据配置颜色深浅来决定字体的颜色
		arcimDescColor="#FFF";
	}else{
		arcimDescColor="#000";
	}
	
	returnStr=returnStr+"<span style='font-size:15px!important;color:"+arcimDescColor
	returnStr=returnStr+" !important'  onclick='OpenOrderView(\""+index+"\");'>"+value+"</span></b>"
	return returnStr ;
}
function placerNoFormatter(value, rowData,index){
	    //if((value==undefined)||(value=="")){
		   		return "<input name='placerNo' style='background:#fff;color: #333' onkeydown='setPlacerNo(this);' data-labNo='"+rowData.labNo+"' data-oeoreId='"+rowData.oeoreId+"' value='"+value+"'></input>"
		//}else{
		//		return value;	
		//}
}
//查询医嘱
function search(){
	runClassMethod("web.DHCEMColumn","getColumnNew",
		{
			execFormID:$("#ExecFormID").val()
		},function(ret){
			var columns=[];
			for(var i=0;i<ret.length;i++){
				if(ret[i].field=="disposeStatDesc"){
					columns.push({field: "disposeStatDesc", title: ret[i].title,styler:disposeStatDescCellStyle})
				}else if(ret[i].field=="op"){
					var opTitle=ret[i].title; //hxy 2023-02-14
					columns.push({field: "op", title: ret[i].title,formatter:function(value, row,index){
						if(row.skinTestFlag=="Y"){
							return "<span class='label-success' type='button'  onclick='skinTest(this,\""+opTitle+"\");' data-oeoreId='"+row.oeoreId+"' data-adm='"+row.adm+"' data-Regno='"+row.regNo+"' data-allergyflag='"+row.allgryFlag+"'>"+opTitle+"</span>" //2016-10-26 congyue
						}else{
							return "";	
						}
					},onClickCell:function(rowIndex, field, value){
					},styler: function(value,row,index){
						if(row.skinTestFlag=="Y"){
							return 'background-color:rgb(139, 195, 74);';
						}
					}
					})
				}else if(ret[i].field=="prtFlag"){
					columns.push({field: "prtFlag", title: ret[i].title,styler:function (value, row, index){
						if (row.prtFlag !=""){return "background-color:#fcf8e3";}
					}})
				}else if(ret[i].field=="arcimDesc"){
					columns.push({field: "arcimDesc", title: ret[i].title,styler:function (value, row, index){
						var typeCode = $("#QueryTypeCode").val();	
						var css="";
						if(typeCode.indexOf("JYD")!="-1"){
							css='background-color:'+row.tubeColor   ///JY bind color
						}
						
						if(typeCode.indexOf("PSD")!="-1"){
							if(row.skinRs=="Y") css='background-color:#FF2D2D';
							if(row.skinRs=="N") css='background-color:#4A4AFF';
						}
						return css;
					},formatter:arcimDescFormatter})
				}else if(ret[i].field=="placerNo"){
					columns.push({field: "placerNo", title: ret[i].title,formatter:placerNoFormatter});
				}else{
					columns.push(ret[i]);	
				}
			}
			//console.log(JSON.stringify(columns))
			$('#execTable').datagrid({
					border:false,
					fit:true,
					fitColumns:false,
				    url:'dhcapp.broker.csp?ClassName=web.DHCEMNurExe&MethodName=getExeOrders',
					columns:[columns],
					onBeforeLoad:function(param){
						param.RegNo=$("#RegNo").val()
						param.QueryType=$("#QueryTypeCode").val(),
						param.LgParams=LgParams,
						param.Exec=$("#exeRadio:checked").val()=="on"?true:false,
						param.UnExec=$("#exeRadio:checked").val()=="on"?false:true,
						param.StartDate=window.parent.StartDate,
						param.EndDate=window.parent.EndDate
						param.offset=param.page-1
						param.limit=param.rows
						return param
					},
					onLoadSuccess: function(data){
						initExecNumber(data); 	///初始化数字
						updateGroupImg();		///组符
						initBotPage(data);
						mergeCell(data);
						showBTN();
						//$("#Loading").fadeOut("fast");
						if((JYDOCHECKALL==1)&&($("#QueryTypeCode").val()=="JYDO")){ //hxy 2022-10-28
							$('#execTable').datagrid('selectAll');
						}
					},
					onClickRow:function(rowIndex,row){
						moreScr(rowIndex);	//2023-03-07
					},
					onCheck:function(index,row){ ///4个方法是为了选中和取消选中同步卡片模式,保证获取当前选中数据只用datagrid的getSelected
						IsAllCheckOrUnCheck();
						CheckLinkOrd(index, row,0);
						SynBotCheck(index,1);
						searchAttach("Y",row.oeoreId); //2023-02-28
					},
					onUncheck:function(index,row){
						IsAllCheckOrUnCheck();
						CheckLinkOrd(index, row,1);
						SynBotCheck(index,2);
						searchAttach("N",row.oeoreId); //2023-02-28
					},
					onCheckAll:function(rows){
						AllSelCard();	//按钮显示和隐藏
						for(index in rows){
							SynBotCheck(index,1);	
						}
					},
					onUncheckAll:function(rows){
						AllSelCardClear();
						for(index in rows){
							SynBotCheck(index,2);	
						}
					},
					onSelect:function(rowIndex, rowData){ 
						//点击某一行数据的时候,设置就诊
						setAdmID(rowData);
					},
					pagination:true,
					pageSize:100,  // 每页显示的记录条数
					pageList:[50,100,150,200]   // 可以设置每页记录条数的列表
			})
						
		}
	);
}

function initBotPage(data){
	var queryTypeCode=$("#QueryTypeCode").val();
	var showBotTypeCode=",SYDO,";
	if(showBotTypeCode.indexOf(","+queryTypeCode+",")>-1){
		$("#execBotArea").empty();
		_initBotPage(data.rows,4);
	}else{
		if($(".execBotArea").is(':visible')){
			$(".execTableArea").show();
			$(".execBotArea").hide();
			$HUI.datagrid("#execTable").resize();
		}
	}
	return;
}

function initExecNumber(data){
	$("#queryTypeGrp .label-success").each(function(){
		$(this).remove();	
	})
	$(data.info).each(function(index,item){ 
		$("#"+item.shet.replace("[", "\\[").replace("]", "\\]")).append("<span class='label-success'>"+item.num+"</span>"); //add ed
	})
	return;
}


function setAdmID(row){							
	var frm=window.parent.parent.document.forms["fEPRMENU"];	
	if(frm.EpisodeID){
		frm.EpisodeID.value=row.adm
	}
	$("#EpisodeID",window.parent.document).val(row.adm);
	window.parent.ADM=row.adm
	return true;	
}

function searchAttach(flag,oeoreId){

	if(ISSHOWATTACH!=1){
		return;
	}
	
	var rows = $('#execTable').datagrid('getSelections');
	if(rows.length==0){
		$('#attachtable').datagrid('loadData',{total:0,rows:[]});
		//return;
	}
	var ids=[];
	for(var i=0; i<rows.length; i++){
		if((flag=="N")&&(rows[i].oeoreId==oeoreId)){
			break;
		}
    	ids.push(rows[i].oeoreId);
	}
	if(flag=="Y"){
		ids.push(oeoreId);
	}
	exeStDate=serverCall("web.DHCEMCommonUtil","DateHtmlToLogical",{date:window.parent.StartDate})
    exeEdDate=serverCall("web.DHCEMCommonUtil","DateHtmlToLogical",{date:window.parent.EndDate})
	$('#attachtable').datagrid('load',{
		regNo:$("#RegNo").val(),
		userId:LgUserID,
		startDate:exeStDate,
		endDate:exeEdDate,
		admType:"OE",
		DetailFlag:"on",
		ordId:"^"+ids.join("^")+"^",
		queryTypeCode: $("#QueryTypeCode").val()});
}
function mergeCell(data){
	
	var queryTypeCode=$("#QueryTypeCode").val();
	var mergeCellTextObj={};
	if((queryTypeCode.indexOf("SYD")==-1)&&(queryTypeCode.indexOf("JCD")==-1)&&(queryTypeCode.indexOf("JYD")==-1)) return;
	
	var mark=1;
	for(var i=1;i <data.rows.length; i++){
		var isMerge=false;
		var mergeCellsColumns="";
		var oeoreId=data.rows[i]['mainOeoreId'];
		var upOeoreId=data.rows[i-1]['mainOeoreId'];
		var labNo=data.rows[i]['labNo'];
		var upLabNo=data.rows[i-1]['labNo'];
		var oeoreIdArr=oeoreId.split("||");
		var upOeoreIdArr=upOeoreId.split("||");
		if(queryTypeCode.indexOf("JCD")!=-1){
			(oeoreIdArr[0]==upOeoreIdArr[0])&&(oeoreIdArr[1]==upOeoreIdArr[1])?isMerge=true:"";
			mergeCellsColumns="arcimDesc"
		}else if(queryTypeCode.indexOf("JYD")!=-1){
			if(labNo!=""){
				labNo==upLabNo?isMerge=true:"";
				mergeCellsColumns="arcimDesc";
			}
		}else{
			oeoreId==upOeoreId?isMerge=true:"";
			mergeCellsColumns="arcimDesc";
		}
		
		
		var mergeCellsColumnsArr=mergeCellsColumns.split("^");
		if (isMerge) {	
			mark += 1; 
			for (var j in mergeCellsColumnsArr){
				var mergeCellsColumn=mergeCellsColumnsArr[j];
				if(mergeCellTextObj[mergeCellsColumn]){
					if(mergeCellTextObj[mergeCellsColumn].indexOf(data.rows[i][mergeCellsColumn])!=-1) continue;
					mergeCellTextObj[mergeCellsColumn]=mergeCellTextObj[mergeCellsColumn]+"<br/>"+data.rows[i][mergeCellsColumn];
				}else{
					if(data.rows[i-1][mergeCellsColumn].indexOf(data.rows[i][mergeCellsColumn])!=-1) continue;
					mergeCellTextObj[mergeCellsColumn]=data.rows[i-1][mergeCellsColumn]+"<br/>"+data.rows[i][mergeCellsColumn]
				}
			}
			continue;
		}else{
			if(mark!=1){
				$('#execTable').datagrid('updateRow',{index:i-mark,row: mergeCellTextObj});		
				$('#execTable').datagrid('mergeCells',{index:i-mark,field:mergeCellsColumn,rowspan:mark});	
				mergeCellTextObj={};
				mark=1; 
				continue;	
			}
		}
			
	}
	
	if(mark!=1){
		$('#execTable').datagrid('updateRow',{index:i-mark,row: mergeCellTextObj});		
		$('#execTable').datagrid('mergeCells',{index:i-mark,field:mergeCellsColumn,rowspan:mark});	
	}
}
//初始化默认值
function initDefaultValue(){
	$("#startdate").datebox('setValue',window.parent.StartDate);
	$("#enddate").datebox('setValue',window.parent.EndDate);
}
//初始化combobox	
function initCombobox(){
	$.ajax({
			url : "websys.Broker.cls", 
			data : {
					ClassName:"web.DHCEMNurTreatQueue",
					MethodName:"GetClientStr",
					serverIP:window.parent.serverName
				    }, 
			success : function(ret){ 
				if(ret!=""){
					treateQueArr=ret.split("^")
					carArr=[]
					for(i=0;i<treateQueArr.length;i++){
						itmArr=treateQueArr[i].split(String.fromCharCode(1))
						var obj=new Object();
						obj.id=itmArr[0];
						obj.text=itmArr[1];
						carArr.push(obj);
					}
					if($('#TreatQueClient').length){
						$('#TreatQueClient').combobox({
							valueField:'id', 
							textField:'text',
							data:carArr
						})
					}
				}
          	}	 
	}); 
}
/// 读卡 新
function readCardNo() {
	DHCACC_GetAccInfo7(ReadCardCallback);
}
/// 读卡
function ReadCardCallback(rtnValue){
	var patientId = "";
	var PatientNo ="";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case '0':
		$("#cardNo").val(myAry[1]);
		patientId = myAry[4];
		PatientNo=myAry[5];
		break;
	case '-200':
		$.messager.alert("提示", "卡无效", "info", function() {
			$("#cardNo").focus();
		});
		break;
	case '-201':
		$("#cardNo").val(myAry[1]);
		patientId = myAry[4];
		PatientNo=myAry[5];
		break;
	default:
	}
	if (patientId != "") {
		searchByRegNo(PatientNo);
	}
}
function GetComputerName() {
 	var computerName;
 	try {
 		var WshNetwork = new ActiveXObject("WScript.Network");
 		computerName = WshNetwork.ComputerName;
 		WshNetwork = null;
 	} catch (e) {
 		computerName = "";
 	}
 	return computerName;
 }
 
 //btn按钮事件区
 //补录医嘱
 function nurAddOrder(){
	
	var rowsData = $("#execTable").datagrid("getSelections")	
	var Moeori="",adm="";
	if($("#c2").is(':visible')){	
		$('input[name="IfPrint"]:checked').each(function(){
			adm=$.ajax({url : "websys.Broker.cls", 
			            data : {ClassName:"web.DHCEMOrdInfoVO",MethodName:"getAdm",ord:$(this).attr('data-oeoreid')}, 
			          	async : false
			    }).responseText; 
			return  false;
		})
	}		

	if(rowsData.length>0){
		Moeori = rowsData[0].oeoriId;
		adm=rowsData[0].adm;
	}
	if(adm==""){
		parent.$.messager.alert('警告','请选择医嘱');
		return;
	} 
	var TabType = $('#QueryTypeCode').val()
	//var url = 'dhcem.nuraddorder.hisui.csp?EpisodeID='+adm+"&Moeori="+Moeori+"&TabType="+TabType;
	var url = 'ipdoc.nursebatchsupplementord.hui.csp?EpisodeID='+adm+"&Moeori="+Moeori+"&TabType="+TabType+"&NotUnSelectPat=Y";
	
	//var openCss = 'width='+(window.screen.availWidth-10)+',height='+(window.screen.availHeight-30)+ ', top=0, left=0, location=no,toolbar=no, menubar=no, scrollbars=no, resizable=no,status=no'
	/*
	$('#commonIframe')[0].src=url;
	$('#CommonWin').window({
			title:'补录费用',
    		width:$(window).width(),
    		height:$(window).height(),
    		modal:true
	});
	*/
	//window.open(url,'newwindow',openCss)	
	
	websys_showModal({
		url: url,
		width: '97%',
		height: '85%',
		iconCls:"icon-w-paper",
		title: $g('补录费用'),
		closed: true,
		modal:true,
		onClose:function(){
			//解除患者锁
    		tkMakeServerCall("web.DHCDocOrderCommon","OrderEntryClearLock");
		}
	}); 
 }
//执行，撤消,打印
function exeAction(exeflag,prtflag){
	
	var execDate = "";  /// 执行日期
	var execTime = "";  /// 执行时间
	var exeRemark = ""; /// 执行备注
	if ((exeflag == "F")&&(CANUPDEXEDATE==1)){
		execDate = $HUI.datebox("#ExeDate").getValue();     /// 执行日期
		execTime = $("#ExeTime").val();                     /// 执行时间
		exeRemark = $("#ExeRemark").val();
		if (execTime == ""){
		    parent.$.messager.alert('提示',"执行时间不能为空!");
			return false;
		}
	}

	//判断是否选择医嘱
	var oeoreIdStr=checkSelectOrd();
	if(oeoreIdStr==""){return false;}
	$.ajax({
			url : "websys.Broker.cls", 
			data : {
					ClassName:"web.DHCEMNurExe",
					MethodName:"UpdateOrdGroupNew",
					OrdExecStr:oeoreIdStr,
					Date:execDate,
					Time:execTime,
					Type:exeflag,
					Remark:exeRemark,
					LgParams:LgParams,
					QueryCode:$("#QueryTypeCode").val()
					/*
					HospitalRowId:LgHospID,
					queryTypeCode:$("#QueryTypeCode").val(),
					execStatusCode:exeflag,
					oeoreIdStr:oeoreIdStr,
					userId:LgUserID,
					userDeptId:LgCtLocID,
					execDate:execDate,
					execTime:execTime,
					exeRemark:exeRemark
					*/
			}, 
			async : false,
			success : function(ret){ 
            		if(ret==0){
						parent.$.messager.alert('提示',"操作成功!");
						if(IsCA){
							InsDigitalSignNew(oeoreIdStr,LgUserID,exeflag,"EXEC",queryTypeCode); ///保存数字签名日志
						}
						//需要打印的时候调用打印方法
						if(prtflag=="Y"){
							PrintClick();				
						}else{
							search();   //刷新table
						}
						$('#ExeTimeWin').dialog('close');
						$("#ExeRemark").val("");
						
					}else{
						retStr=ret.split("!"); //huaxiaoying 2017-01-18
						parent.$.messager.alert('警告',retStr[0]+"!","warning");
					}
          	}	 
	}); 
	return true;
}

//安排座位
function arrangeSeat(){
	var url = "dhcem.patientseatnew.csp?planPatModel=1";
 	websys_showModal({
		url: url,
		width: window.screen.availWidth-100,
		height: window.screen.availHeight-230,
		title: $g('座位安排'),
		closed: true,
		onClose:function(){
			
		}
	});
	
}

//只打印执行记录
function printAction(){
	if(checkSelectOrd()!=""){PrintClick();}
}
//判断是否选中医嘱
function checkSelectOrd(PriFlg){
	var oeoreIdStr=""
	data=$("#execTable").datagrid("getSelections");
	if(data.length==0){
		return oeoreIdStr;
	}
	for(var i=0;i<data.length;i++){
		if ((PriFlg=="1")&&((data[i].disposeStatCode=="UnPaid")||(data[i].SkinTestPay!=""))) { //hxy 2022-06-22 st //2022-07-28 add ||(data[i].SkinTestPay!="")
	        parent.$.messager.alert('提示',"有未交费医嘱!不能打印!"); 
	        oeoreIdStr="";
	        break;
        } //ed
		if(oeoreIdStr.length==0){
			oeoreIdStr=data[i].oeoreId;
		}else{
			oeoreIdStr=oeoreIdStr+"^"+data[i].oeoreId;
		}
	}
	return oeoreIdStr;
}


function switchAction(){
	if(!$(".execBotArea").is(':visible')){
		$(".execTableArea").hide();
		$(".execBotArea").show();
	}else{
		$(".execTableArea").show();
		$(".execBotArea").hide();
		$HUI.datagrid("#execTable").resize();
	}
	return;
}

function switchActionBak(){
	if(!$("#c2").is(':visible')){
		if(ISSHOWATTACH==1){
			$('#mainLayout').layout('collapse', 'south');
		}	
		height=$("#execTable").parent().parent().height();
		$("#execTable").parent().parent().height(70);
		$("#c2").height(height-75) //hxy 2020-06-19
		$("#c2").show();
		$("#selAllCard").show();
		//$("#canAllCard").show();

	}else{
		if(ISSHOWATTACH==1){
			$('#mainLayout').layout('expand', 'south');	
		}
		$("#c2").height(0)
		$("#execTable").datagrid('resize')
		$("#c2").hide();
		$("#selAllCard").hide();
		$("#canAllCard").hide();

	}
}

function messageAction(){
	//$("#botColorHintDiv",parent.document).show();
	$('#botColorHintDiv').window('open');  //hxy 2018-07-03
}

function searchByRegNo(regNo){
	
	var data=serverCall("web.DHCEMPatientSeat","GetCurrAdm",{"CardNo":'',"RegNo":regNo,"LgHospID":LgHospID})
	
	if(data==""){
		parent.$.messager.alert('提示',"病人没有就诊记录!","info");
	   	$('#RegNo').val("");
	   	return;
	}
	
	var EpisodeID =data.split("^")[0];
	$("#EpisodeID",parent.document).val(data.split("^")[0]);
	$("#EpisodeID").val(data.split("^")[0]);
	selectTest(EpisodeID);
}
function selectTest(EpisodeID){
		runClassMethod("web.DHCEMPat",
			"GetPatInfo",
			{'EpisodeID':EpisodeID},
			function(data){
				var PatCardNo = $("#cardNo").val();
				var CardTypeNew=$("#CardTypeNew").val();
				if(PatCardNo==""){
					if(data.CardTypeNew!=""){
						parent.CardTypeNew = data.CardTypeNew;
					}
				}else{
					if(typeof data == "object"){
						data.PatCardNo=PatCardNo;
						data.CardTypeNew=CardTypeNew;
					}
				}
				parent.setPatInfo(data);
				parent.loadFrame(data);
			},
			"json")	
	
}

///打开皮试界面
function skinTest(obj,opTitle){
	
	event.stopPropagation();  ///阻止冒泡
	
	var oeoreID = $(obj).attr("data-oeoreId");
	data=serverCall("web.DHCEMSkinTest", "TestPayMoney", { 'oriOreId':oeoreID})
	if (data!= "") {
			$.messager.alert("提示",data,"info")
			return;
	}
//	runClassMethod("web.DHCEMInComUseMethod","GetSkinOrdPayStatus",{'OeOrdItmID':oeoreID},function(ret){
//		if(ret==0){
//			$.messager.alert("提示","皮试医嘱未交费不能置皮试结果","info");
//			return;
//		}else{
			url='dhcem.skinTest.csp?adm='+$(obj).attr("data-adm")+"&oeoreId="+oeoreID+"&RegNo="+$(obj).attr("data-Regno")+"&Allgryflag="+$(obj).attr("data-allergyflag");
		 	websys_showModal({
				url: url,
				width: window.screen.availWidth-100,
				height: window.screen.availHeight-230,
				title:opTitle,//$g('皮试'),
				iconCls:"icon-w-paper",//hxy 2023-01-06
				closed: true,
				onClose:function(){
					
				}
			});
			
					
//		}
//	},"text")	
}

function setPlacerNo(obj){
	if (window.event.keyCode == 13) {
		$input = $("input[name='placerNo']");
		placerNo=$.trim($(obj).val());
		oeoreId=$(obj).attr("data-oeoreId");
		var nextIndex = $input.index(obj)+1;
		if (placerNo.length > 9) {
          	ret=serverCall("web.DHCEMNurExe", "SetPlacerNo", { userId:LgUserID, oeoreId:oeoreId, placerNo:placerNo})
            if(ret==0){
	            releLabNo($(obj));
	        }else{
		        $.messager.alert("提示","第"+nextIndex+"行条码"+ret,"info");
		        $input[nextIndex-1].focus();
		    }
            
		}else if(placerNo.length ==0){
			oeoreId=$(obj).attr("data-oeoreId");
			ret=serverCall("web.DHCEMNurExe", "ClearPlacerFlag", { OrdID:oeoreId})
			if(ret==0){
	            releLabNo($(obj));
	        }else{
		        $.messager.alert("提示","第"+nextIndex+"行条码"+ret,"info");
		    }
		}else{
			$.messager.alert("提示","第"+nextIndex+"行条码不能小于10位!","info");
			$(obj).focus();
			
		}	
	}	
	
}
function releLabNo($obj){
	$input = $("input[name='placerNo']");
	var nextIndex = $input.index($obj)+1;
	var labNo = $obj.attr("data-labNo");
	var nextLabNo =  $($input[nextIndex]).attr("data-labNo");
	if(labNo===nextLabNo){
		$($input[nextIndex]).val($obj.val());	
	}else{
		$input[nextIndex+1].focus();
		return;	
	}
	releLabNo($input[nextIndex]);
}

//弹出排队界面
function treatQueAction(){
	if(parent.$("#patBloodTable").length){
		var lnk = "dhcem.bloodline.csp";
	 	websys_showModal({
			url: lnk,
			width: '97%',
			height: '85%',
			title: $g('采血排队'),
			closed: true,
			onClose:function(){
				parent.searchPatBlood();
			}
		});
	}else{
		$HUI.dialog('#treatQueDialog').open()
	}
	return;
}
function saveTreatQue(QueueType){
	$.ajax({
			url : "websys.Broker.cls", 
			data : {
					 ClassName:"web.DHCNurTreatQueue",
					 MethodName:"InsertQueue",
					 QueueUserLocDr:LgCtLocID,
					 QueueUserId:LgUserID,
					 TreatAdmDr:$("#EpisodeID").val(),
					 ClientID:$("#TreatQueClient").combobox('getValue'),
					 TreatReportType:$("#QueryTypeCode").val(),
					 RegNo:$("#RegNo").val(),
					 QueueType:QueueType,
					 ServerName:window.parent.serverName
				    }, 
			success : function(ret){
					$HUI.dialog('#treatQueDialog').close()
					if (ret != 0) {
						parent.$.messager.alert('提示',ret); 
					}else{
						parent.$.messager.alert('提示','排队成功!'); 
						window.parent.searchPatTreat();	
					} 
          	}	 
	}); 
}

///check 0/1 (取消选中/选中)
///getGroupId 1/其他 (获取成组医嘱ID串/"")
function CheckLinkOrd(rowIndex, rowData,check,getGroupId){
	var queryTypeCode=$("#QueryTypeCode").val();
	var rows = $("#execTable").datagrid('getRows');
	typeof rowData!=="object"?rowData=rows[rowIndex]:"";
	
	var ordGroupIdStr=rowData.oeoriId;
	
	for(var i=0;i<rows.length;i++)
	{
		if(i==rowIndex){
			continue;
		}
		
		var mainOeoreId=rowData.mainOeoreId;
		var checkMainOeoreId=rows[i].mainOeoreId;
		var mainOeoreIdArr=mainOeoreId.split("||");
		var checkMainOeoreIdArr=checkMainOeoreId.split("||");
		var isOneGroup=false;
		if(queryTypeCode.indexOf("JCD")==-1){
			mainOeoreId==checkMainOeoreId?isOneGroup=true:"";
		}else{
			(mainOeoreIdArr[0]==checkMainOeoreIdArr[0])&&(mainOeoreIdArr[1]==checkMainOeoreIdArr[1])?isOneGroup=true:"";	
		}
		if((isOneGroup)||((rowData.labNo==rows[i].labNo)&&(rowData.labNo!=undefined)&&(rowData.labNo!=""))){
			
			ordGroupIdStr=ordGroupIdStr+"^"+rows[i].oeoriId;	
			
			if(getGroupId=="1"){
				continue;
			}
			
			selects= $("#execTable").datagrid('getSelections');
			selectFlag=0;
			for(j=0;j<selects.length;j++){
				if(selects[j].oeoreId==rows[i].oeoreId){selectFlag=1}
			}
			
			if(check==1){
				if(selectFlag==1){
					$("#execTable").datagrid('uncheckRow',i);  //qx
				}
			}else{
				if(selectFlag==0){
					$("#execTable").datagrid('checkRow',i);
				}
			}
			
		}
	}
	return ordGroupIdStr;
}
function Cardpay(){ 
	var rowsData = $("#execTable").datagrid("getSelections");
	var adm="";
	if($("#c2").is(':visible')){	
		$('input[name="IfPrint"]:checked').each(function(){
			adm=serverCall("web.DHCEMOrdInfoVO","getAdm",{ord:$(this).attr('data-oeoreid')}) 
			return false;
		})
	}

	if(rowsData.length>0) adm=rowsData[0].adm;
	if(adm==""){
		$.messager.alert("提示", "请选择医嘱！");
		return;
	}
	
	
	
	var patInfo = serverCall("web.DHCEMInComUseMethod","GetPatInfo",{EpisodeID:adm}) 
	var cardTypeID = (parent.cardTypeID==undefined?"":parent.cardTypeID.split("^")[0]);
	var patId = patInfo.split("^")[2];
	$.m({
		ClassName:"web.udhcOPBillIF",
		MethodName:"GetCheckOutMode",
		expStr:LgGroupID+"^"+LgCtLocID+"^"+LgHospID
	},function(mode){
		var PatDefCardInfo=$.cm({ 
			ClassName:"web.DHCOPAdmReg",
			MethodName:"GetValidAccMNoCardNo",
			PatientID:patId,
			dataType:"text"
		}, false);
       	var CardNo = PatDefCardInfo.split("^")[0];
        var CardType = PatDefCardInfo.split("^").slice(1,PatDefCardInfo.split("^").length).join("^");
        ///预扣费报错修复：DHCOPBillLocCheckOut.js AdmStr is not defined
		if ($("#CardBillCardTypeValue").length==0) {
			$('body').append("<input id='CardBillCardTypeValue' name='CardBillCardTypeValue' type='hidden' value='"+CardType+"'>");
		}else{
			$("#CardBillCardTypeValue").val(CardType);
		}
		
		if(mode == 1) {
			if (CardNo == "") {
		       	$.messager.alert("提示","该患者无对应卡信息,不能进行预扣费!");
		       	return false;
		    }
		    $.messager.confirm('提示', '是否确认扣费?', function(r){
			    if (r){
			    	var insType = "";
					var oeoriIDStr = "";
					var guser = LgUserID;
					var groupDR = LgGroupID;
					var locDR = LgCtLocID;
					var hospDR = LgHospID;
					var rtn = checkOut(CardNo,patId,adm,insType,oeoriIDStr,guser,groupDR,locDR,hospDR);
					search();
				}
			});
        	return;
			
		}else {
		 	var lnk = "dhcbill.opbill.charge.main.csp?ReloadFlag=3&CardNo=" + patInfo.split("^")[1] + "&SelectAdmRowId=" + adm + "&SelectPatRowId=" + patInfo.split("^")[2]+"&CardTypeRowId=" + cardTypeID;
		 	websys_showModal({
				url: lnk,
				width: '97%',
				height: '85%',
				title: $g('预扣费'),
				closed: true,
				onClose:function(){
					serverCall("web.DHCDocOrderCommon","OrderEntryClearLock",{}) 	///解锁
					search();
				}
			});
		}	 	
	});

}



///卡片全选
function AllSelCard(){
	$("#c2 .panel-body").each(function(){
		selectCheckBox(this,1);
	})
	$("#selAllCard").hide();
	$("#canAllCard").show();	
}

///卡片取消选中
function AllSelCardClear(){
	$("#c2 .panel-body").each(function(){
		selectCheckBox(this,2);	
	})
	$("#selAllCard").show();
	$("#canAllCard").hide();
}


function WriExeTimeWinNew(exeflag,prtflag){
	//判断是否选择医嘱
	var oeoreIdStr=checkSelectOrd();
	if(oeoreIdStr==""){return false;}
	
	ThisExecFlag=exeflag;
	ThisPrtFlag=prtflag;
	///验证CA签名
	var ModelCode=(exeflag=="F"?"NurseExec":"NurseCancelExec");
	isTakeDigSignNew({"callback":WriExeTimeWin,"modelCode":ModelCode});
	return;
}

/// 执行时间窗口 bianshuai 2018-11-23
function WriExeTimeWin(){
	
	if((CANUPDEXEDATE!=1)||(ThisExecFlag!="F")){
		exeAction(ThisExecFlag,ThisPrtFlag);
		return;	
	}
	
	//判断是否选择医嘱
	var oeoreIdStr=checkSelectOrd();
	if(oeoreIdStr==""){return false;}
	
	var option = {
		modal : true,
		title : TrsExecTime, //$g("执行时间"),
		collapsible : false,
		minimizable : false,
		maximizable : false,
		width : 400,
		height : 207,
		iconCls:'icon-w-paper',
		buttons:[{
			text:TrsSave, //$g('保存'),
			//iconCls:'icon-w-save',
			handler:function(){
				var flag = exeAction(ThisExecFlag,ThisPrtFlag);
				if(flag){
					$("#ExeRemark").val("");
				}
			}
		},{
			text:TrsCancel,//$g('取消'),
			//iconCls:'icon-w-close',
			handler:function(){
				$("#ExeRemark").val("");
				$('#ExeTimeWin').dialog('close');
			}
		}]
	};
	
	$HUI.dialog('#ExeTimeWin', $.extend({},option));
	$('#ExeTimeWin').dialog('open');
	InitNurExeTime();  /// 初始化执行时间
}

///  效验时间栏录入数据合法性
function CheckEmPcsTime(id){

	var InTime = $('#'+ id).val();
	InTime=InTime.replace(/\D/g,'')
	if (InTime == ""){return "";}
	
	if (InTime.length < 4){InTime = "0" + InTime;}
	if (InTime.length != 4){
		$.messager.alert("提示:","请录入正确的时间格式！<span style='color:red;'>例如:18:23,请录入1823</span>");
		$('#'+ id).val("");
		return "";
	}
	
	var hour = InTime.substring(0,2);
	if (hour > 23){
		$.messager.alert("提示:","小时数不能大于23！");
		$('#'+ id).val("");
		return "";
	}
	
	var itme = InTime.substring(2,4);
	if (itme > 59){
		$.messager.alert("提示:","分钟数不能大于59！");
		$('#'+ id).val("");
		return "";
	}
	
	return hour +":"+ itme;
}

/// 初始化执行时间
function InitNurExeTime(){
	
	runClassMethod("web.DHCEMNurExe","GetSystemTime",{},function(jsonObject){
		if (jsonObject != null){
			$HUI.datebox("#ExeDate").setValue(jsonObject["SystemDate"]); /// 执行日期
			$("#ExeTime").val(jsonObject["SystemTime"]); /// 执行时间
		}
	},'json',false)
}

/// 获取焦点后时间栏设置
function SetEmPcsTime(id){
	
//	var InTime = $('#'+ id).val();
//	if (InTime == ""){return "";}
//	InTime = InTime.replace(":","");
	return "";
}



function updateGroupImg(){
	var allData=$("#execTable").datagrid("getRows");
	if(allData.length==0){
		return;	
	}
	
	for (var i=0;i<allData.length;i++){
		var isLastRow=((i+1)==allData.length?true:false);	///是否最后一行
		var itmData=allData[i];
		var upItmData=(i>0?allData[i-1]:"");
		var upGroupNo=(i>0?allData[i-1].groupNo:"");
		var thisGroupNo=itmData.groupNo;
		
		
		///存在子医嘱
		if(thisGroupNo!=parseInt(thisGroupNo)){
			var rowIndex=$('#execTable').datagrid('getRowIndex',upItmData);
			if(upGroupNo==parseInt(upGroupNo)){
				///上一条是主医嘱
				updGroupImg(rowIndex,1);
			}else{
				///上一条是主医嘱
				updGroupImg(rowIndex,2);
			}
		}
		
		///最后一行
		if(isLastRow){
			var rowIndex=$('#execTable').datagrid('getRowIndex',itmData);
			if(thisGroupNo!=parseInt(thisGroupNo)){
				updGroupImg(rowIndex,3);
			}
			
			if(parseInt(thisGroupNo)!=parseInt(upGroupNo)){
				if(upGroupNo!=parseInt(upGroupNo)){
					var rowIndex=$('#execTable').datagrid('getRowIndex',upItmData);
					updGroupImg(rowIndex,3);
				}
			}
			
			if(parseInt(thisGroupNo)==parseInt(upGroupNo)){
				if(upGroupNo!=parseInt(upGroupNo)){
					var rowIndex=$('#execTable').datagrid('getRowIndex',upItmData);
					updGroupImg(rowIndex,2);
				}
			}
			
			return;	
		}
		
		///下一组并且非最后一条
		if(thisGroupNo==parseInt(thisGroupNo)){
			if(upItmData==""){
				continue;	
			}
			var rowIndex=$('#execTable').datagrid('getRowIndex',upItmData);
			if(upGroupNo!=parseInt(upGroupNo)){
				updGroupImg(rowIndex,3);
			}
			
		}
	}
}

function updGroupImg(rowIndex,Model){
	if(rowIndex===-1){
		return true;
	}
	var groupImg="";
	Model==1?groupImg="┓":"";
	Model==2?groupImg="┃":"";
	Model==3?groupImg="┛":"";
	groupImg="<span style='color:red'>"+groupImg+"</span>";
	$('#execTable').datagrid('updateRow',{
	    index: rowIndex,
	    row: {
	        GroupImg: groupImg
	    }
	});		
}

function OpenOrderView(rowIndex){
	var OEItemIdStr=CheckLinkOrd(rowIndex,"","",1);
	websys_showModal({
		url:"dhc.orderview.csp?ord=" + OEItemIdStr,
		title:$g('医嘱查看'),
		iconCls:"icon-w-paper",//hxy 2023-02-03
		width:screen.availWidth-200,height:screen.availHeight-300
	});
}



function SynBotCheck(index,check){
	$("#execBotArea").find(".panelBox").each(function(){
		var thisDatax=$(this).attr("datax");
		if(index==parseInt(thisDatax)){	
			if(check==1){
				$(this).find(".panel-body").next().is(':checked')?"":checkOrUnCheckBot($(this).find(".panel-body"),check);
			}else{
				$(this).find(".panel-body").next().is(':checked')?checkOrUnCheckBot($(this).find(".panel-body"),check):"";
			}
		}	
	})
}

///卡片全选
function AllSelCardNew(){
	$("#execTable").datagrid('checkAll');
	AllSelCard();
}

///卡片取消选中
function AllSelCardClearNew(){
	$("#execTable").datagrid('uncheckAll');
	AllSelCardClear();
}

///卡片全选
function AllSelCard(){
	$("#selAllCard").hide();
	$("#canAllCard").show();	
}

///卡片取消选中
function AllSelCardClear(){
	$("#selAllCard").show();
	$("#canAllCard").hide();
}

function IsAllCheckOrUnCheck(){
	var allCheckRows=$("#execTable").datagrid("getSelections");	
	var allRows=$("#execTable").datagrid("getRows");
	if(!allCheckRows.length){
		AllSelCardClear();
		return;	
	}
	if(allCheckRows.length==allRows.length){
		AllSelCard();
		return;
	}
	if(allCheckRows.length!=allRows.length){
		AllSelCardClear();
		return;
	}
	return;
}

function moreScr(rowIndex){
	IsOpenMoreScreen = isOpenMoreScreen();	///是否多屏幕 2022-03-07 用户大会
	if(!IsOpenMoreScreen)return;
	var ordItemStr=CheckLinkOrd(rowIndex,"","",1);
	var ordExecStr=checkSelectOrd("");
	var data=$("#execTable").datagrid("getSelections");
	var CurAdm="";
	if(data.length>0){
		CurAdm=data[0].adm;
	}else{
		var rows = $('#execTable').datagrid('getRows');
		CurAdm= rows[rowIndex].adm;
	}
	websys_emit("onEmNurData",{
		ord:ordItemStr,
		ordExe:ordExecStr,
		EpisodeID:CurAdm,
	});
	return;
}
