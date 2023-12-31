///zhouxin 2018-02-02
var RowDelim=String.fromCharCode(1);  //行数据间的分隔符
//1:先挂号后分诊.
//2:先分诊后挂号.
//3:先挂号后分诊(绿色通道，三无，抢救患者可直接分诊产生挂号记录）.
//4:先分诊后挂号(绿色通道，三无，抢救患者可直接分诊产生挂号记录）
//var PATTYPE
//var MODIFYPAT=0 1:可以修改病人信息.0：不能修改
//var ISSHOWDRUG=0 1:显示.0:其他不显示
//var ISSHOWECG=0 1：显示.0:不显示
//var ISNEEDCARD=0 //1:分诊需要建卡,其他：不需要
var CSP_URL="websys.Broker.cls";
var EmBtnFlag=""; ///  分区按钮事件 2016-09-20 congyue
var defaultCardTypeDr="" //默认卡类型
var m_CCMRowID = "" ;
var TmpNurLev = "";  /// 护士分级
var EmNurReaID = ""; /// 护士修改分级原因
var LockRecLevFlag=0;       /// 禁用推荐分级
var EmCardNoFlag=0   ///防止省份证获取畜生日期重复
var SignNormalObj={}; ///生命体征正常值
var ComputerIp=GetComputerIp();
var LgParams = LgHospID +"^"+ LgCtLocID +"^"+ LgUserID +"^"+ LgGroupID;
d1=new Date()
$(function(){
	initView();          //按配置隐藏元素
	initBtn();			 //注册按钮事件
	initCheckboxEvent(); //注册checkbox的单击事件
	initComboboxEvent(); //注册Combobox的事件
	initSymLevTree()
	initRadioEvent();   //注册radio的单击事件
	initInputEvent();   //初始化input的事件
	initDataGrid();  ///  页面DataGrid初始定义
	initDefaultValue(); //初始化默认值
	initdefaultRadio();
	initSignNormalValue();   ///获取生命体征初始化正常值
	
	initIntervalFun();
	
	//initPrePlatformWin();  /// 院前院内衔接平台  页面加载时，自动打开副屏；用户大会使用 bianshuai 2022-10-12
})

/// 院前院内衔接平台
function initPrePlatformWin(){
	IsOpenMoreScreen = isOpenMoreScreen();	///是否多屏幕 2022-03-07 用户大会
	// openPatEmr(PatientID, EpisodeID, mradm);
	if(IsOpenMoreScreen){
	websys_emit("onPatCheckLev",{"PatientID":""});
	}
}

function initIntervalFun(){
	checkPatTestTime();
	myTimeoutId=setInterval('checkPatTestTime();SetShadow()',10000);
	SetShadow();
}

function SetShadow(){
	setTimeout('$("#PatTest").parent().parent().css("box-shadow","rgb(102, 102, 102) 2px 3px 10px")',300);
}

//等待超时提醒
function checkPatTestTime(){
	var link=LINK_CSP+"?";
	if ('undefined'!==typeof websys_getMWToken){
		link += "&MWToken="+websys_getMWToken()
	}
  $.ajax({
     type: "POST",
     url: link,
     data: {
		'ClassName':'web.DHCEMPatCheckLevQuery',
		'MethodName':'GetWaitOutPat',
		'limit':999,'offset':0,'LgHospID':LgHospID
	 },
     dataType: "json",
     error:function(rtn){
	    clearInterval(myTimeoutId); //hxy 2023-05-13
	    var MWToken="";
	    if ('function'==typeof websys_getMWToken) MWToken=websys_getMWToken();
	    if(MWToken){
		    if ('undefined'!==typeof lockScreenOpt && 'function'==typeof lockScreenOpt.lockScrn) lockScreenOpt.lockScrn();
		}else{
			$.messager.alert("提示", "系统已超时，请关闭界面，重新登录!");
		}
	 },
     success: function(data){
		html="";
		
		if(!data.rows.length){
			return;	
		}
		
		html=html+"<div id='PatTest' style='padding:10px'>" //hxy 2022-08-02
		html=html+"<table class='pure-table'>"
		html=html+"<tr>"
		html=html+	"<th>"+$g("姓名")+"</th><th>"+$g("分诊时间")+"</th><th>"+$g("挂号时间")+"</th><th>"+$g("操作")+"</th>"
		html=html+"</tr>"
		$.each(data.rows,function(n,rowData){
			var PatName=rowData.PatName; 
			var OpHtml="<a href='#' onClick='OpenWaitOp("+rowData.EmPCLvID+","+rowData.NurseLevel+",\""+PatName+"\","+rowData.PatNo+")'>"+$g("操作")+"</a>"
			var PCLDate=rowData.PatChkDateTime;
			var AdmDate=rowData.AdmDateTime;
			html=html+"<tr>"
			html=html+	"<td>"+PatName+"</td><td>"+PCLDate+"</td><td>"+AdmDate+"</td><td>"+OpHtml+"</td>"
			html=html+"</tr>"
		})
		html=html+"</table>"
		html=html+"</div>" //hxy 2022-08-02

		var curTop=$(window).height()-180;
		$.messager.show({
			height:180,
			width:370,
			title:$g('等候超时提醒'),
			msg:html,
			timeout:5000, //0
			showType:'slide',
			shadow:true,
			style:{
				top:curTop,
				left:0,
				bottom:0
			}
		});
     }
 }); 
}

function OpenWaitOp(EmPCLvID,NurseLevel,PatName,PatNo){
	var link='dhcem.waitout.csp?EmPCLvID='+EmPCLvID+"&NurseLevel="+NurseLevel+"&PatName="+PatName+"&PatNo="+PatNo;
	if ('undefined'!==typeof websys_getMWToken){
		link += "&MWToken="+websys_getMWToken()
	}
	$('#OutWindow').window({
		title:'等待超时处理',
		width:490,
		height:289,
		modal:true,
		href:link,
		iconCls:"icon-w-paper",
		onOpen:function(){}
	});

}

 // ComputerIP
function GetComputerIp() 
{
   if(window.ActiveXObject){
		var ipAddr="";
		var locator = new ActiveXObject("WbemScripting.SWbemLocator");
		var service = locator.ConnectServer(".");
		var properties = service.ExecQuery("Select * FROM Win32_NetworkAdapterconfiguration");
		var e = new Enumerator(properties);
		var p=e.item();
		for(;!e.atEnd();e.moveNext())
		{
			var p=e.item();
			ipAddr=p.IPAddress(0);
			if(ipAddr) break;
		}
		return ipAddr;
	}else{
		var ClientIPAddressIInfo = serverCall("User.DHCClientLogin","GetInfo");
		return ClientIPAddressIInfo.split("^")[0];
	}
}

///走后台方法:获取生命体征正常值
function initSignNormalValue(){
	runClassMethod("web.DHCEMPatCheckLevQuery","GetSignNoralList",{LgHospID:LgHospID}, //hxy 2020-06-18
	function(jsonString){
		SignNormalObj = jsonString;
	},'json',false)
}

function initView(){
	if(ISSHOWECG!=1){
		$("#EmECGFlag").hide();
		$("#EmECGFlag").prev().hide();
	}
	if(AISSCORE!="Y"){
		$("#switchHURT").hide();
	}
}
function initGreenHours(){
	
	//绿色通道时效启用 zhouxin
	if(GreenEffectSwitch>0){
		$("#greenHours").val(GreenEffectSwitch)
		//是否可以修改时长
		if(GreenModifyTime>0){
			$("#greenHours").attr("disabled",false)
		}else{
			$("#greenHours").attr("disabled",true)
		}	
	}else{
		$("#greenHours").parent().hide()	
	}
}
//注册按钮事件
function initBtn(){
	
	
	
	$($("button[name='EmAware']")).on('click',function(){
		if($(this).hasClass('dhcc-btn-blue')){
			$(this).removeClass('dhcc-btn-blue')	
		}else{
			$($("button[name='EmAware']")).not(this).removeClass('dhcc-btn-blue')
			$(this).addClass('dhcc-btn-blue');
		}
		setEmRecLevel(); //推荐分级	
	})
	
	$("#triage").on('click',function(){triage();})   //保存分诊
	$("#readCard").on('click',function(){readCard();})  ///读卡
	$("#readId").on('click',function(){readPatID();})  ///读身份证
	$("#print").on('click',function(){LevPrintout();})  ///打印
	$("#prtWD").on('click',function(){Prt_WCinctureo();})  ///打印腕带
	$('#nurcancel').on("click",cancelNurLevWin); ///  取消
	$('#nursure').on("click",surePatEmLev);///  确认
	
	$("#painBTN").on('click',function(){painSure();})  ///疼痛 评分主题
	
	//日期查询 2016-08-26 congyue
	$('[title^="日期查询"]').bind("click",function(e){
		$('.datetime-search').each(function(){
	   		if ($(this).css('display')=='none'){
		   		$(this).css('display','block');
		   		$('#stadate').datebox("setValue",formatDate(0));
		   		$('#enddate').datebox("setValue",formatDate(0));
				QueryEmPatList();
		   	}else{
			   	$(this).css('display','none');
				$('#stadate').datebox("setValue","");  //开始日期 2016-09-19 congyue
				$('#enddate').datebox("setValue","");  //结束日期 2016-09-19 congyue
				QueryEmPatList();
			 }    
	   });
	});
    $('#search').searchbox({ 
	   searcher:function(value,name){
		   QueryEmPatList();
	   }
    })
    $('#searchName').searchbox({ 
	   searcher:function(value,name){
		   QueryEmPatListName();
	   }
    })
    ///  分区按钮事件
	$('#tb .danger,#tb .warning,#tb .success,#2').bind("click",function(){ //hxy 2020-02-19
	     EmBtnFlag=this.id;
	   	 QueryEmPatList();
	});
	
	$("#updGreen").on("click",showGreenRec)
}

function showGreenRec(){
	
	var EmPCLvID=$("#EmPCLvID").val();
	if(EmPCLvID==="") {
		$.messager.alert("提示","未选择分诊记录!");
		return;
	}
	
	var lnk = 'dhcem.green.rec.csp?EmPCLvID='+EmPCLvID;
	
	websys_showModal({
		url: lnk,
		iconCls:"icon-w-paper",
		title: $g('绿色通道'),
		closed: true,
		onClose:function(){
			againSetGreenCheck();	
		}
	});
	return;
}

function againSetGreenCheck(){
	var EmPCLvID=$("#EmPCLvID").val();
	var isGreenStr=$m({ //$cm({
		ClassName:"web.DHCEMPatGreenRec",
		MethodName:"checkGreenRecAndRea", //checkGreenRec
		chk:EmPCLvID
	},false);
	
	var isGreen=isGreenStr.split("^")[0];
	var GreReaDr=isGreenStr.split("^")[1];
	
	if(isGreen=="1"){
		$HUI.radio('[name="EmGreenFlag"][value="Y"]').setValue(true);	
	}else{
		$HUI.radio('[name="EmGreenFlag"][value="Y"]').setValue(false);
	}
	//绿色通道申请原因
	$("#EmGreRea").combobox('setValue',GreReaDr); //hxy 2022-07-29
	return;
}

//初始化界面默认值
function initDefaultValue(){
	clearData();
	$('#EmToLocID').combobox({disabled:true})
	$('#EmLocID').combobox({disabled:false})
	$('#EmCheckNo').combobox({disabled:false})
	$('#EmPatWard').combobox({disabled:true});
	if(CANUPDARRDATE==1){
		$('#emvistime').datetimebox({disabled:false});
	}else{
		$('#emvistime').datetimebox({disabled:true});
	}
	initData();	
	setModifyPat(false);
}
function clearData(){
	EmNurReaID="";
	$("#layoutCenter").find('input[type="mytext"]').val('');
	//$('input[type="text"]').not('.searchbox-text').val('');
	$('input[type="hidden"]').not('.noClear').not('#GetCardTypeEncrypt,#ReadAccExpEncrypt,#ReadCardTypeEncrypt').val('');
	$('textarea').val('');
	$('#queDoc').html('');
	$('#SelEmCheckNo').val('');
	$("#SpecialPat").val("");     //特殊病人标志
	$('#EmRecLevel').combobox('setValue','')
	$('#EmUpdLevRe').combobox('setValue','')
	$('#Vitsigtype').combobox('setValue','')
	$("#empatsex").combobox('setValue','');
	
	$("button[name='EmAware']").removeClass('dhcc-btn-blue')
	
	$(".scoreGroup").find("button[class^='dhcc-btn-gray']").removeClass('dhcc-btn-blue');
	$(".scoreGroup").find("button[class^='dhcc-btn-gray']").attr('data-value','');
	$HUI.checkbox("#EmGreenFlag").enable();
	$("#updGreen").parent().hide();
	/*
	$("#switchESI").removeClass('dhcc-btn-blue')
	$("#switchPAINLEV").removeClass('dhcc-btn-blue')
	$("#switchHURT").removeClass('dhcc-btn-blue')
	$("#switchREMS").removeClass('dhcc-btn-blue')
	$("#switchMEWS").removeClass('dhcc-btn-blue')
	$("#switchFALL").removeClass('dhcc-btn-blue')
	$("#switchPAIN").removeClass('dhcc-btn-blue')
	
	$("#switchESI").attr('data-value','')
	$("#switchPAINLEV").attr('data-value','')
	$("#switchHURT").attr('data-value','')
	$("#switchREMS").attr('data-value','')
	$("#switchMEWS").attr('data-value','')
	$("#switchFALL").attr('data-value','')
	$("#switchPAIN").attr('data-value','')
	*/
	
	$("#switchGCS").attr('data-value','')
	
	
	$('.hisui-switchbox').switchbox('setValue',false);
	$('.hisui-checkbox').checkbox('setValue',false)
	$('.hisui-radio').not("input[type='radio'][name$='Flag']").radio('setValue',false)
	$('.dhc-score').find('span').html(0)
	$('#autoScoreDatagrid').datagrid({data:[]})
	/// 清空身份证图片区域  bianshuai 2018-03-17
	$("#imgPic").attr("src","../images/uiimages/patdefault.png"); //hxy 2018-06-08
	initGreenHours();
	$("#emvistime").datetimebox("setValue",formatDate(new Date()));
	$("#EmBatchNum").attr({ disabled:true});
	$("#EmBatchNum").attr({ disabled:true});
	$("#EmHisDrugDesc").attr({ disabled:true});
	$("#EmMaterialDesc").attr({ disabled:true});
	$("#EmVaccineDesc").attr({ disabled:true});
	$("#EmGregariousDesc").attr({ disabled:true});
	$("#EmTourismDesc").attr({ disabled:true});
	$("#EmContactDesc").attr({ disabled:true});
	if(PATTYPE==3){
		$("td:contains('"+$g("分诊科室")+"')").parent().css("display","");
    	$("td:contains('"+$g("已挂号别")+"')").parent().css("display","");	
	}
	
}
function initdefaultRadio(){
			/// 第1、3种模式：转诊不显示； bianshuai 2017-02-25
	/// 以下都是查到td标签的父元素tr进行隐藏
	if (PATTYPE == 1){
		/// 隐藏分诊科室
		$("td:contains('"+$g("分诊科室")+"')").parent().css("display","none");
		/// 隐藏转诊科室
		$("td:contains('"+$g("转诊科室")+"')").parent().css("display","none");
		/// 隐藏已挂号
		$('input[label="已挂号"]').parent().parent().css("display","none");
		/// 默认勾选未分诊
		//$('input[name="EmCkLvFlag"][value="N"]').prop("checked",true);
		$HUI.radio('input[name="EmCkLvFlag"][value="N"]').setValue(true);
		//$HUI.radio('#EmCkLvFlagN').setValue(true);
	}
	if (PATTYPE == 2){
		/// 隐藏已分诊
		$('input[label="已分诊"]').parent().parent().css("display","none");
		/// 隐藏已挂号别
		$("td:contains('"+$g("已挂号别")+"')").parent().css("display","none");
		/// 默认勾选未挂号
		//$('input[name="EmEpiFlag"][value="N"]').prop("checked",true);
		$HUI.radio('input[name="EmEpiFlag"][value="N"]').setValue(true);
		//$HUI.radio('#EmEpiFlagN').setValue(true);
	}
	if (PATTYPE == 3){
		/// 隐藏转诊科室
		$("td:contains('"+$g("转诊科室")+"')").parent().css("display","none");
		/// 隐藏已挂号
		$('input[label="已挂号"]').parent().parent().css("display","none");
		/// 默认勾选未分诊
		//$('input[name="EmCkLvFlag"][value="N"]').prop("checked",true);
		$HUI.radio('input[name="EmCkLvFlag"][value="N"]').setValue(true);
		//$HUI.radio('#EmCkLvFlagN').setValue(true);
	}
	if (PATTYPE == 4){ 
		/// 隐藏已分诊
		$('input[label="已分诊"]').parent().parent().css("display","none");
		/// 隐藏已挂号别
		$("td:contains('"+$g("已挂号别")+"')").parent().css("display","none");
		/// 默认勾选未挂号
		//alert( $('input[name="EmEpiFlag"][value="N"]').parent().html())
		//$('input[name="EmEpiFlag"][value="N"]').attr("checked",true);
		$HUI.radio('input[name="EmEpiFlag"][value="N"]').setValue(true);
		
	}
}
function initData(){
	
	$('#emnation').combobox("setValue",1);  
	$('#emcountry').combobox("setValue",1);
	$('#patSocailType').combobox("setValue",1);
	$('#patCertType').combobox("setValue",20);
	
	$("#emvistime").datetimebox("setValue",formatDate(new Date()));
	if(defaultCardTypeDr==""){
		$.post(CSP_URL,{ClassName:'web.DHCEMPatCheckLevCom',MethodName:'GetDefaultCardType'
		},function(ret){
			$("#emcardtype").combobox("setValue",ret);
			defaultCardTypeDr=ret;
		})
	}else{
		$("#emcardtype").combobox("setValue",defaultCardTypeDr);	
	}
	if(ISSHOWDRUG==1){
		$("td:contains('用药情况')").parent().show();
	}else{
		$("td:contains('用药情况')").parent().hide();
	}
	
	if(ISSHOWECG==1){
		//$("td:contains('ECG')").show();
		//$("td:contains('ECG')").next().show();
	}else{
		//$("td:contains('ECG')").hide();
		//$("td:contains('ECG')").next().hide();
	}
}
//初始化症状分级树
function initSymLevTree(){
	
	$('#symLevTree').tree({
    	url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonEmPatSymptomLev',
    	onClick:function(node, checked){
	        showSymptom(node.id,node)
	    },
        onLoadSuccess:function(){
	    	$("#symLevTree").tree("expandAll");
	    }
	});
}
/// 病人信息列表  卡片样式
function setCellLabel(value, rowData, rowIndex){
	
	var age = (rowData.PatAge=="未知"?$g("未知"):rowData.PatAge);
	
	var WaitTimeHtml="<span style='color: red;font-size: 10px;'>"+rowData.WaitTime.replace("分钟","m")+"</span>";  
	var htmlstr =  '<div class="celllabel">'
	htmlstr = htmlstr +'<div style="height:26px">';
	htmlstr = htmlstr+'<h3 style="float:left;background-color:transparent;">'+ rowData.PatName 
	///htmlstr = htmlstr+'<h3 style="float:left;background-color:transparent;">'+ "*"+rowData.PatName.substring(1,9) 
	htmlstr = htmlstr+WaitTimeHtml+'</h3>';
	htmlstr = htmlstr+'<h3 style="float:right;background-color:transparent;"><span>'+ rowData.PatSex+'/'+ age +'</span></h3>';
	htmlstr = htmlstr +'</div>';
	
	htmlstr = htmlstr +'<div>';
	htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">ID:'+ rowData.PatNo +'</h4>';
		var classstyle="color: #18bc9c";
		if(rowData.NurseLevel!=""){
			if(rowData.NurseLevel==3) {classstyle="color: #f9bf3b"};
			if(rowData.NurseLevel==1) {classstyle="color: #f22613"};
			if(rowData.NurseLevel==2) {classstyle="color: orange"}; //hxy 2020-02-19 #f22613
			htmlstr = htmlstr +'<h4 style="float:right;background-color:transparent;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+setCellLabelLev(rowData.NurseLevel)+'</span></h4>';
		}
	htmlstr = htmlstr +'</div>';
	//htmlstr = htmlstr +'<h4 style="float:right;background-color:transparent;"><span>多次测量生命体征：<img id="myImage'+rowData.EmPCLvID+'" style="margin-top:6px;" src="../scripts/dhcnewpro/images/edit_add.png" width="20" height="15" onclick="newSign('+rowData.EmPCLvID+')"/></span></h4>'; //hxy 2020-03-26 注释
	htmlstr = htmlstr +'</div>';
	return htmlstr;
}
function initDataGrid(){
		///  定义columns
	var columns=[[
		{field:'PatLabel',title:'预检分诊',width:208,formatter:setCellLabel},
		{field:'PatNo',title:'姓名',width:100,hidden:true},
		{field:'PatName',title:'登记号',width:100,hidden:true},
		{field:'PatSex',title:'性别',width:100,hidden:true},
		{field:'PatAge',title:'年龄',width:100,hidden:true},
		{field:'PatientID',title:'PatientID',width:100,hidden:true},
		{field:'Adm',title:'Adm',width:100,hidden:true}
	]];
	
	var Params = "^^N^" + LgHospID +"^"+ LgCtLocID +"^"+ LgUserID +"^"+ LgGroupID;
	
	$HUI.datagrid('#dgEmPatList',{
		
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=QueryEmRegPatlist&params="+Params,
		fit:true,
		autoSizeColumn:false,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		showHeader:false,
		rownumbers : false,
		showPageList : false,
        onClickRow:function(rowIndex, rowData){
	        setRegPanelInfo(rowData,1);   ///  设置登记面板数据
	        if(rowData.QueDoc){
		      $("#queDoc").html(rowData.QueDoc)  
		    }
		    if (typeof rowData.uniqueID != "undefined"){
			    /// 取登记队列
				if (rowData.uniqueID == "A"){
					$("td:contains('"+$g("已挂号别")+"')").parent().css("display","none");
					$("td:contains('"+$g("分诊科室")+"')").parent().css("display","");
				}
				/// 取挂号队列
				if (rowData.uniqueID == "B"){
				    $("td:contains('"+$g("分诊科室")+"')").parent().css("display","none");
				    $("td:contains('"+$g("已挂号别")+"')").parent().css("display","");
				}
		    }
	    },
		onLoadSuccess:function(data){
		    if(data.rows.length>0){
			   //setRegPanelInfo(data.rows[0],1);   ///  设置登记面板数据
	           //if(data.rows[0].QueDoc){
	           //   $("#queDoc").html(data.rows[0].QueDoc)  
	           //}
			}

			///  隐藏分页图标
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
            ///  设置分诊区域
            if (typeof data.EmPatLevTotal == "undefined"){return;}
        	/*$("#tb .success").html(data.EmPatLevCnt3+"/"+data.EmPatLevTotal);
			$("#tb .warning").html(data.EmPatLevCnt2+"/"+data.EmPatLevTotal);
			$("#tb .danger").html(data.EmPatLevCnt1+"/"+data.EmPatLevTotal);*///hxy 2020-02-19 注释
			$("#tb .success").html(data.EmPatLevCnt4+"/"+data.EmPatLevTotal); //hxy 2020-02-19 st
			$("#tb .warning").html(data.EmPatLevCnt3+"/"+data.EmPatLevTotal);
			$("#2").html(data.EmPatLevCnt2+"/"+data.EmPatLevTotal);
			$("#tb .danger").html(data.EmPatLevCnt1+"/"+data.EmPatLevTotal); //ed
		}
	});
	///  隐藏刷新按钮
	$('#dgEmPatList').datagrid('getPager').pagination({ showRefresh: false});  
}

var initPainLev=false;
var initESI=false;
var initHurtLev=false;
var initREMS=false;
var initMEWS=false;
var initPAIN=false;
var initFALL=false;
function openESIWin(){
	//if(initESI){
	//	$('#esiWindow').window('open');
	//}else{
		$('#esiWindow').window({
			title:'ESI评分',
    		width:690,
    		height:520,
    		modal:true,
			collapsible:false,
			minimizable:false,
			maximizable:false,
			iconCls:"icon-w-paper",
    		href:'dhcem.esi.hisui.csp?par='+encodeURI($("#switchESI").attr("data-value")),
    		onOpen:function(){initESI=true}
		});
	//}

}
function openPAINLEVWin(){
	//if(initPainLev){
	//	$('#EmPatPainLevWin').window('open')
	//}else{
		$('#EmPatPainLevWin').window({
			title:'疼痛评级',
	    	width:1000,
	    	height:470,
	    	modal:true,
			collapsible:false,
			minimizable:false,
			maximizable:false,
			iconCls:"icon-w-paper",
	    	href:'dhcem.painlev.hisui.csp',
	    	onOpen:function(){initPainLev=true}
		});	
	//}

}
function openHURTLEVWin(){
	//if(initHurtLev){
	//	$('#EmPatHurtLevWin').window('open')
	//}else{
		$('#EmPatHurtLevWin').window({
			title:'创伤评级',
	    	width:900,
	    	height:400,
	    	modal:true,
			collapsible:false,
			minimizable:false,
			maximizable:false,
			iconCls:"icon-w-paper",
	    	href:'dhcem.hurtlev.hisui.csp',
	    	onOpen:function(){initHurtLev=true}
		});
	//}
}
function openREMSWin(){
	//if(initREMS){
	//	$('#EmPatREMSLevWin').window('open')
	//}else{
		$('#EmPatREMSLevWin').window({
			title:'REMS评级',
	    	width:1000,
	    	height:600,
	    	modal:true,
			collapsible:false,
			minimizable:false,
			maximizable:false,
			iconCls:"icon-w-paper",
	    	href:'dhcem.rems.hisui.csp',
	    	onOpen:function(){initREMS=true}
		});
	//}
}
function openMEWSWin(){
	//if(initMEWS){
	//	$('#EmPatMEWSLevWin').window('open')
	//}else{
		$('#EmPatMEWSLevWin').window({
			title:'MEWS评级',
	    	width:1000,
	    	height:420,
	    	modal:true,
	    	collapsible:false,
			minimizable:false,
			maximizable:false,
			iconCls:"icon-w-paper",
	    	href:'dhcem.mews.hisui.csp',
			onOpen:function(){initMEWS=true}
		});
	//}
}
function openFALLWin(){
	//if(initFALL){
	//	$('#EmPatFALLLevWin').window('open')
	//}else{
		$('#EmPatFALLLevWin').window({
			title:'坠跌评分',
	    	width:1100,
	    	height:595,
	    	modal:true,
	    	collapsible:false,
			minimizable:false,
			maximizable:false,
			iconCls:"icon-w-paper",
	    	href:'dhcem.falllev.hisui.csp',
			onOpen:function(){initFALL=true}
		});
	//}
}
function openPAINWin(){
	//if(initPAIN){
	//	$('#EmPatPainWin').window('open')
	//}else{
		$('#EmPatPainWin').window({
			title:'疼痛评分',
	    	width:680,
	    	height:200,
	    	modal:true,
	    	collapsible:false,
			minimizable:false,
			maximizable:false,
			iconCls:"icon-w-paper",
	    	href:'dhcem.patpain.hisui.csp',
	    	onOpen:function(){initPAIN=true}
		});
	//}
}

//儿童早期预警评分
function openChildEarNWin(){
	//if(initPAIN){
	//	$('#EmPatPainWin').window('open')
	//}else{
		$('#EmChildEmrWin').window({
			title:'儿童早期预警评分',
	    	width:950,
	    	height:360,
	    	modal:true,
	    	collapsible:false,
			minimizable:false,
			maximizable:false,
			iconCls:"icon-w-paper",
	    	href:'dhcem.childemr.hisui.csp',
	    	onOpen:function(){initChildEmr=true}
		});
	//}
}

//省份证号多个患者
function openMorePatSelect(PatIdentNo){
	///  定义columns
	var columns=[[
		{field:'PatNo',title:'登记号',width:100},
		{field:'PatName',title:'姓名',width:100},
		{field:'PatSex',title:'性别',width:100},
		{field:'PatAge',title:'年龄',width:100},
		{field:'PatientID',title:'PatientID',width:100}
	]];
	
	$HUI.datagrid('#PatListTable',{
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=GetPatientList&PatIdentNo="+PatIdentNo+"&LgHospID="+LgHospID,
		fit:true,
		autoSizeColumn:false,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		showHeader:false,
		rownumbers : false,
		showPageList : false,
        onDblClickRow:function(rowIndex, rowData){
	        setPatMesByIdCard(rowData.PatientID);
	        $("#PatListTableWin").window("close");
	    }
	});
	$("#PatListTableWin").window("open");
}

//单击分级显示主诉，单击主诉计算分级，加入到病人评分列表
function showSymptom(id,node){
	if(node.children==undefined){
		$('#symTab').tabs('select','来诊主诉');
	}
	
	
	$('#symTree').tree({
		formatter:function(node){
			return node.EmSymFDesc;
		},
    	url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=GetSymptomFeild&EmSymLevId='+id,
    	onClick:function(node, checked){
	    	if(node.children==undefined){
		    	var root = $('#symTree').tree('getRoot')
		    	var msg=root.EmSymFDesc+":"+node.EmSymFDesc
		        $.messager.confirm('提示',msg,function(r){
	    			if (r){
		    			$('#symTab').tabs('select','症状分类');
						setSymLev(node.EmSymFId,msg)
	    			}
				});
	    	}
	    }
	});	
}



//单机Switch的时候控制后面的input的编辑
function editSwitch(obj,value){
	$(obj).next().val("");
	$(obj).next().attr({disabled:!value.value});
}

//注册checkbox的单击事件
function initCheckboxEvent(){
	

	//
	$('.hisui-checkbox').checkbox({onCheckChange:function(){
		id=$(this).attr("id")
		//转诊科室
		if('EmToLocFlag'==id){
			if($(this).is(':checked')){
				$('#EmLocID').combobox('setValue',"");    	         /// 分诊科室
				$('#EmLocID').combobox({disabled:true});
				$('#EmCheckNo').combobox({disabled:true});
				$('#EmToLocID').combobox('enable');
				$('#EmGreenFlag').checkbox("setValue",false)
				$('#EmGreenFlag').checkbox("setDisable",true); /// 绿色通道
			}else{
				$('#EmLocID').combobox('enable');
				$('#EmCheckNo').combobox('enable');
				$('#EmToLocID').combobox({disabled:true});
				$('#EmGreenFlag').checkbox("setDisable",false); /// 绿色通道
			}	
		}
		if('EmGreenFlag'==id){
			if($(this).is(':checked')){
				$('#EmGreRea').combobox('setValue',"");
				$('#EmGreRea').combobox('enable');
			}else{
				$('#EmGreRea').combobox({disabled:true});
			}	
		}
		if("EmPatChkHis"==$(this).attr('name')){
			setEmRecLevel();
		}	
	}})
	
	
	
}

//注册combox的事件
function initComboboxEvent(){
	
	
	//抢救病区
	$('#EmPatWard').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonWard&HospID='+LgHospID,
		valueField: 'value',
		textField: 'text',
		blurValidValue:true
	})
	//性别
	$('#empatsex').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonCTSex',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		editable:false
	})
	//名族
	$('#emnation').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonCTNation',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true
	})
	//国籍
	$('#emcountry').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonCTCountry',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true
	})
	
	//病人类型
	$('#patSocailType').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevCom&MethodName=GetSocialList&HospDr='+LgHospID, //hxy 2020-06-30
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		editable:false
	})
	
	//证件类型
	$('#patCertType').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevCom&MethodName=GetCertTypelList',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		editable:false,
		onSelect: function (n,o) {
			$("#emidentno").focus();
		},
		onLoadSuccess:function () {
			var nowID=$('#patCertType').combobox("getValue");
			var data = $('#patCertType').combobox('getData');
			var flag="";
			for(i=0;i<data.length;i++){
				if(data[i].value==nowID){
					flag=1;
					break;
				}
			}
			if(flag==""){
				$('#patCertType').combobox("setValue","");
			}  
		}
	})
	
	//转诊科室
	$('#EmToLocID').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=GetEmToLoc&HospID='+LgHospID,
		valueField: 'value',
		textField: 'text',
		mode:'remote',
		blurValidValue:true
	})
	//>护士更改<br>分级原因
	$('#EmUpdLevRe').combobox({
		//url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonEmUpdLevReson&HospID='+LgHospID,
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonEmDocUpdReson&HospID='+LgHospID+'&Type=Nur',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true
	})
	//意识形态
//	$('#EmAware').combobox({
//		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonPatAWare',
//		valueField: 'value',
//		textField: 'text',
//		onSelect:function(record){setEmRecLevel();}
//	})
	//宗教
	$('#religion').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonCTReligion',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true
	})
	//婚姻
	$('#marital').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonCTMarital',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true
	})
	//职业
	$('#occupation').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonCTOccupation',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true
	})					
	//卡类型
	$('#emcardtype').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevCom&MethodName=CardTypeDefineListBroker',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onChange: function (n,o) {
			var CardTypeDefArr = n.split("^");
	        m_CardNoLength = CardTypeDefArr[17];   /// 卡号长度
			m_CCMRowID = CardTypeDefArr[14];
	        if (CardTypeDefArr[16] == "Handle"){
		    	$('#emcardno').attr("readOnly",false);
		    }else{
				$('#emcardno').attr("readOnly",true);
			}

	        $("#patCertType").combobox('reload','dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevCom&MethodName=GetCertTypelList&CardType='+n.split("^")[0]); //2023-03-31
	        if(CardTypeDefArr[44]!=""){
	        	$('#patCertType').combobox("setValue",CardTypeDefArr[44]);
	        }

		}
	})	
	
	//分级    
    $('#EmRecLevel').combobox({
		blurValidValue:true,
		onSelect:function(option){
		   var EmPCLvID = $("#EmPCLvID").val(); 
		   if(EmPCLvID==""){
			   level= option.value 
			   $HUI.radio('input[name="NurseLevel"][value="'+ level +'"]').setValue(true);
			   //areaLevel=level>1?level-1:level //hxy 2020-02-19 注释
			   areaLevel=level>4?level-1:level   //hxy 2020-02-19
			   $HUI.radio('input[name="Area"][value="'+ areaLevel +'"]').setValue(true);
		   }
	    }
	});
	
	//分诊科室
	$('#EmLocID').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatLoc',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		mode:'remote',
		onSelect:function(option){
			var url = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatChkCare&LocID="+option.value;
	        $("#EmCheckNo").combobox('reload', url);
			$("#EmCheckNo").combobox('setValue', "");			
			var validLocRequireRs=validLocRequire();
			if(validLocRequireRs){
				$.messager.alert("提示",validLocRequireRs,"info");
				if($("#EmPCLvID").val()==""){
					$("#EmLocID").combobox('setValue', "");
				}
				return;
			}
	    }
	})
	
	
	//号别
	$('#EmCheckNo').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatChkCare',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onShowPanel:function(){
			var EmLocID =$("#EmLocID").combobox("getValue"); 
	        var url = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatChkCare&LocID="+EmLocID;
	        $("#EmCheckNo").combobox('reload', url);
		},
		onLoadSuccess:function(data){
			var EmLocID =$("#EmLocID").combobox("getValue");
			if(EmLocID=="") return;
			var valProName = $(this).combobox("options").valueField;
			if(data.length){
				$(this).combobox("setValue",data[0][valProName]);
			}
		}
	});	
	
	//绿色通道申请原因 hxy 2022-07-14
	$('#EmGreRea').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMDicItem&MethodName=jsonConsItem&HospID='+LgHospID+'&mCode=GreenRea',
		valueField: 'value',
		textField: 'text',
		panelHeight:"auto",
		blurValidValue:true
	})
	//获取生命体征    cy 2022-07-25
	$('#Vitsigtype').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=GetVitalsigns&phimType=Vitalsigns',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true
	})	
}


//注册radio的单击事件
function initRadioEvent(){
	  $HUI.radio("[name='NurseLevel']",{
            onChecked:function(e,value){
	           level=parseInt($(e.target).val());
		       //areaLevel=level>1?level-1:level //hxy 2020-02-19 注释
		       areaLevel=level<5?level:level-1   //hxy 2020-02-19
		       $HUI.radio('input[name="Area"][value="'+ areaLevel +'"]').setValue(true);
		        /// 分级为1、2级或去向为红区时,抢救病区可用否则不可用
			    if ((level == 1)||(level == 2)){
					/// 抢救病区可用
					$('#EmPatWard').combobox("enable");
					
				}else{
			 		/// 抢救病区不可用
					$('#EmPatWard').combobox("disable");
					$('#EmPatWard').combobox("setValue","");
				}			   
            }
      });
      $HUI.radio("[name='Area']",{
            onChecked:function(e,value){
	           level=parseInt($(e.target).val());
	           //level=level>1?level+1:level //hxy 2020-02-19 注释
	           if ($('input[name="NurseLevel"]:checked').length){
					EmNurseLevel = $('input[name="NurseLevel"]:checked').val();  /// 护士分级
			   }
			   if((EmNurseLevel==5)&&(level==4)){
			   	  level=EmNurseLevel
			   }
		   	   $HUI.radio('input[name="NurseLevel"][value="'+ level +'"]').setValue(true);
			    /// 分级为1、2级或去向为红区时,抢救病区可用否则不可用
			    if ((level == 1)||(level == 2)){
			   	    /// 抢救病区可用
					$('#EmPatWard').combobox("enable");
			    }else{
			 		/// 抢救病区不可用
					$('#EmPatWard').combobox("disable");
					$('#EmPatWard').combobox("setValue","");
				}
            }
      });   



      /// 已分诊、未分诊
      $HUI.radio("[name='EmCkLvFlag']",{
            onChecked:function(e,value){
			   QueryEmPatList(); /// 调用查询列表
            }
      });
      /// 已挂号、未挂号
      $HUI.radio("[name='EmEpiFlag']",{
            onChecked:function(e,value){
			   QueryEmPatList(); /// 调用查询列表
            }
      });      
}
//注册input的事件
function initInputEvent(){
	
	//回车键跳入下一元素 2016-09-19 congyue add ggm 2016-11-24
	var $inp = $('.enter');//input:text
	$inp.bind('keydown', function (e) {
		var key = e.keyCode;
		if (key == 13) {
			var nxtIdx = $inp.index(this) + 1;
			$(".enter:eq(" + nxtIdx + ")").focus();
		}
	});
	//生日
	$('#emborth').blur(blurBrith);
	//年龄
	$("#empatage").on('change',changeAge)
	///  生命体征
	$('input[name="EmPcs1"]').bind("blur",setEmRecLevel);
	///登记号 
	$('#EmPatNo').bind('keydown',GetEmPatInfo);
	
	$('#empatage').bind("blur",setEmRecLevel);
		///  卡号
	$('#emcardno').bind('keypress',GetEmPatInfoByCardNo);
	///症状
	$('#symFilter').bind('keydown',GetSym);
	
	/// 身份证
	$('#emidentno').bind("blur",function(e){
		setEmPatBaseInfo($(this).val());
	});
	
	$('#emidentno').keydown(function(e){
		if(e.keyCode==13){
			
		}
	})
}
//初始化silder
function initSilder(){
	$("#slider" ).slider({
		onSlideEnd:function(value){
			/// 设置疼痛分级项目值
			$("#EmPainLev").val(value);
			$(".face-regin-title span").css({"color":""});
			$(".face-regin-title span:contains('["+value+"]')").css({"color":"#ff7a00"});
			if (value == 0){
				$('#EmPainRange').combobox({disabled:true});
				$('#EmPainTime').datebox({disabled:true});
			}else{
				$('#EmPainRange').combobox({disabled:false});
				$('#EmPainTime').datebox({disabled:false});
			}
		},
		onChange:function(newValue,oldValue){
			$("#EmPainLev").val(newValue);
			$(".face-regin-title span").css({"color":""});
			$(".face-regin-title span:contains('["+newValue+"]')").css({"color":"#ff7a00"});
		}
	});	
}

////////////////////function
function CheckDate(HtDate){

	runClassMethod("web.DHCEMPatCheckLevQuery","CheckDate",{"date":HtDate},function(jsonString){
		HtDate = jsonString;
	},'',false)
	return HtDate;
}
/// 取His日期维护显示格式 bianshuai 2017-03-10
function GetSysDateToHtml(HtDate){

	runClassMethod("web.DHCAPPExaRepCom","GetSysDateToHtml",{"HtDate":HtDate},function(jsonString){
		HtDate = jsonString;
	},'',false)
	return HtDate;
}
/// 设置年龄
function setPatAge(borthdate){
	
    /// 取患者年龄
    runClassMethod("web.DHCEMPatCheckLevQuery","GetPatientAgeDesc",{"PatientDOB":borthdate},function(jsonstring){
		if (jsonstring != null){
			if(jsonstring==-1){
				$.messager.alert("提示","出生日期不能大于当前日期！");
				$("#emborth").val("");
				$("#empatage").val("");
				return;	
			}
			$("#empatage").val(jsonstring);
			setEmRecLevel();
		}
		
	},'',false)
}
function blurBrith(){
	var mybirth = $('#emborth').val();
	if (mybirth != ""){
		if ((mybirth != "")&&((mybirth.length!=8)&&((mybirth.length!=10)))){
				$.messager.alert("提示:","请输入正确的日期!","",function(){
				$("#emborth").val("")
				$("#emborth").focus();
			});
			return;
		}
			
		if (mybirth.length==8){
			var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8);
		}

		var mybirth = GetSysDateToHtml(mybirth);  /// 根据His系统配置转换日期格式
		//var mybirth =CheckDate(mybirth);
		if ((mybirth .indexOf("ERROR")>=0)||(mybirth=="")){
			$.messager.alert("提示:","请输入正确的日期!","",function(){
				$("#emborth").val("")
				$("#emborth").focus();
			});
			return ;
		}
			$('#emborth').val(mybirth);
			setPatAge(mybirth);
	}
}
function changeAge(){

		date=$("#empatage").val();
		if(date.trim()==""){
			return;
		}
		now=new Date();
		if(parseInt(date)<0){
			$.messager.alert("提示:","年龄不能为负！","",function(){
				$("#empatage").val("")
				$("#empatage").focus();
			});
			return;
		}
		
		/// 出生年龄在1岁至14岁之间，显示岁加月份，如12岁5月；
		if (date.indexOf("岁") != "-1"){
			dateArr=date.split("岁");
			if (dateArr[1].indexOf("月") != "-1"){
				new Date(now.setMonth((new Date().getMonth()-dateArr[0]*12)));
				new Date(now.setMonth((new Date().getMonth()-parseInt(dateArr[1]))));
			}else{
				new Date(now.setMonth((new Date().getMonth()-dateArr[0]*12)));
			}
			var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// 根据His系统配置转换日期格式
			$("#emborth").val(nowdate);
			
			return;	
		}
		
		/// 出生年龄在1个月至1岁之间，显示月份加天数，如5月7天；
		if (date.indexOf("月") != "-1"){
			dateArr=date.split("月");
			if (dateArr[1].indexOf("天") != "-1"){
				new Date(now.setMonth((new Date().getMonth()-dateArr[0])));
				newtimems=now.getTime()-(parseInt(dateArr[1])*24*60*60*1000);
				now.setTime(newtimems);
			}else{
				new Date(now.setMonth((new Date().getMonth()-dateArr[0])));
			}
			var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// 根据His系统配置转换日期格式
			$("#emborth").val(nowdate);
			return;	
		}
		
		/// 出生年龄在24小时至1个月，显示天，如19天
		if(date.indexOf("天") != "-1"){
			dateArr=date.split("天")
			newtimems=now.getTime()-(dateArr[0]*24*60*60*1000);
			now.setTime(newtimems);
			var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// 根据His系统配置转换日期格式
			$("#emborth").val(nowdate);
			return;	
		}
		
		/// 出生年龄在1小时至24小时之间，显示小时，如4小时；
		if(date.indexOf("小时")>=0){
			dateArr=date.split("小时")
			newtimems=now.getTime()-(dateArr[0]*60*60*1000);
			now.setTime(newtimems);
			var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// 根据His系统配置转换日期格式
			$("#emborth").val(nowdate);
			return;	
		}
		
		/// 出生年龄在1小时以内， 显示分钟，如36分钟；
		if(date.indexOf("分钟")>=0){
			dateArr=date.split("分钟")
			newtimems=now.getTime()-(dateArr[0]*60*1000);
			now.setTime(newtimems);
			var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// 根据His系统配置转换日期格式
			$("#emborth").val(nowdate);
			return;	
		}
		
		if(parseInt(date)>175){
			$.messager.alert("提示:","年龄不能大于176！","",function(){
				$("#empatage").val("")
				$("#empatage").focus();
			});
			return;
		}
		
		/// 默认数字按照岁来处理
		new Date(now.setMonth((new Date().getMonth()-$(this).val()*12)));
		var nowdate = GetSysDateToHtml(now.Format("dd/MM/yyyy")); /// 根据His系统配置转换日期格式
		$("#emborth").val(nowdate);	
}

/// 读取身份证
function readPatID(){
	
	try{
		var myInfo=DHCWCOM_PersonInfoRead("1");
	}catch(e){
		alert(e.message)   
	}
	var myary=myInfo.split("^");
	if (myary[0]=="0"){
		//str="<IDRoot><Age>24</Age><Name>王伟</Name><Sex>男</Sex><NationDesc>01</NationDesc><Birth>1988-08-19</Birth><Address>山东省东营市东营区北一路739号</Address><CredNo>37078419880819641X</CredNo></IDRoot>"
		var str=myary[1];
		var result = $.parseXML(str);
		var EmIdentno = $(result).find('CredNo').text();
		if (GetPatientID(EmIdentno) != ""){
			setEmPatBaseInfo(EmIdentno);
		}else{
			$("#empatname").val($(result).find('Name').text());
			$("#emidentno").val($(result).find('CredNo').text());
			/// 设置出生日期
			var mybirth = $(result).find('Birth').text();
			if (mybirth != ""){
				if (mybirth.length==8){
					var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8);
				}
				var mybirth = GetSysDateToHtml(mybirth);  /// 根据His系统配置转换日期格式
				$('#emborth').val(mybirth);
			}
			$("#empatage").val($(result).find('Age').text());
			$("#empatname").val($(result).find('Name').text());
			$("#emaddress").val($(result).find('Address').text());
			/// 设置民族
			var PatNation = $(result).find('NationDesc').text();
			if (PatNation != ""){
				$("#emnation").combobox('setValue',TransNationToID(PatNation));
			}
			/// 设置性别
			var PatSex = $(result).find('Sex').text();
			if (parseInt(PatSex) % 2 == 1) {
				$("#empatsex").combobox("setValue",TransPatSexToID("男"));
			}else{ 
				$("#empatsex").combobox("setValue",TransPatSexToID("女"));
			}
		}
		//使用读取得照片数据文件 2018-03-17 bianshuai
		var src = ""
		if ($(result).find('PhotoInfo').text() != ""){
			src="data:image/png;base64," + $(result).find('PhotoInfo').text();
			$("#imgPic").attr("src",src);
		}//hxy 2018-06-08
		
	}
}
/// 取His性别 bianshuai 2017-08-17
function TransPatSexToID(PatSex){
	
	var PatSexID = "";
	runClassMethod("web.DHCEMPatCheckLevCom","SexToId",{"desc":PatSex},function(jsonString){
		PatSexID = jsonString;
	},'',false)
	return PatSexID;
}

/// 取His民族 bianshuai 2017-08-17
function TransNationToID(Nation){
	
	var PatNationID = "";
	runClassMethod("web.DHCEMPatCheckLevCom","NationToId",{"Nation":Nation},function(jsonString){
		PatNationID = jsonString;
	},'',false)
	return PatNationID;
}

//检查身份证性别	
function checkSex(){
	
	var certType = $("#patCertType").combobox("getText");
	
	if(certType.indexOf("身份证")==-1) return true;
	
	psidno=$("#emidentno").val();
	sex=$("#empatsex").combobox("getValue");
	if(psidno.length==0){
		return true;	
	}
	var tmpStr;
	if(psidno.length==18){
        sexno=psidno.substring(16,17);
        tmpStr = psidno.substring(6, 14);
		tmpStr = tmpStr.substring(0, 4) + "-" + tmpStr.substring(4, 6) + "-" + tmpStr.substring(6);
    }else if(psidno.length==15){
        sexno=psidno.substring(14,15)
        tmpStr = psidno.substring(6, 12);
		tmpStr = "19" + tmpStr;
		tmpStr = tmpStr.substring(0, 4) + "-" + tmpStr.substring(4, 6) + "-" + tmpStr.substring(6);
    }else{
	    $.messager.alert("提示:","身份证号错误！");
	    return false;
	}
	tmpStr = GetSysDateToHtml(tmpStr);    /// 根据His系统配置转换日期格式
	date2=$("#emborth").val();
   	if(tmpStr!=date2){
	   	$.messager.alert("提示:","出生日期和身份证号不一致！");
	    return false;
	}
    var tempid=sexno%2;
    if((tempid==0)&&(sex!=2)){
	    $.messager.alert("提示:","身份证号对应的性别是女！");
	    return false;
	}
	
    if((tempid!=0)&&(sex!=1)){
	    $.messager.alert("提示:","身份证号对应的性别是男！");
	    return false;
	}
	return true;	
}
///  取消护士分级窗口
function cancelNurLevWin(){
	
	$("#EmNurRea").combobox("setValue","");
	$('#newNurWin').window('close');
}

function surePatEmLev(){
	EmNurReaID = $("#EmNurRea").combobox("getValue");
	if (EmNurReaID == ""){
		$.messager.alert("提示:","请填写分级变更原因！");
		return;
	}
	$("#EmNurRea").combobox("setValue","");
	$('#newNurWin').window('close');
	triage();
}
/*
 * 使用遮罩层时，调用方法showmask();
 */
function showmask(){
    //遮罩层,利用datagrid的遮罩层
    $("<div class=\"datagrid-mask\"></div>").css({display:"block",width:"100%",height:$(window).height()}).appendTo("body"); 
    $("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍候。。。").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2}); 

}
function hidemask(){
    $(".datagrid-mask").hide();
    $(".datagrid-mask-msg").hide();
}
///确认分诊
function triage(){
	
	showmask();	
	
	var validLocRequireRs=validLocRequire();
	if(validLocRequireRs){
		hidemask()
		$.messager.alert("提示",validLocRequireRs,"info");
		return;
	}
	
	if(!$HUI.validatebox("#EmOtherDesc").isValid()){
		hidemask()
		$.messager.alert("提示","(备注)的长度必须小于60");
		return;
	}
	if(!$HUI.validatebox("#EmNotes").isValid()){
		hidemask()
		$.messager.alert("提示","(其他)的长度必须小于60");
		return;
	}
	var IsSpecialPat = $("#SpecialPat").val();
	
	var EmPatType = getEmPatType();
	var PatientID = $("#PatientID").val();
	
	
	var CardInfo = $HUI.combobox("#emcardtype").getValue();
	var UsePAPMINoToCardFlag = CardInfo.split("^")[36];
	
	//分诊患者是否必须具有卡号:群伤患者、三无不走这个配置
	if((ISNEEDCARD==1)&&(IsSpecialPat!=1)&&(EmPatType=="")){
		if((UsePAPMINoToCardFlag!="Y")||(PatientID!="")){
			var CardTypeDr = $("#emcardtype").combobox("getValue");         /// 卡号类型
			var CardTypeDefArr = CardTypeDr.split("^");
			if (CardTypeDefArr[16] == "Handle"){
				message = "卡号不能为空,请先输入卡号！";
			}else{
				message = "卡号不能为空,请先读卡！";
			}
		
			var EmCardNo = $("#emcardno").val();         /// 卡号
			if (EmCardNo == ""){
				$.messager.alert("提示",message);
				hidemask()
				return;
			}
			if((m_CardNoLength!="")&&(m_CardNoLength!=0)){
				if (m_CardNoLength != EmCardNo.length){
					$.messager.alert("提示","卡号录入有误,请核实后再试！");
					hidemask()
					return;
				}
			}
		}
	}

	var emborth =$('#emborth').val();
	if($.trim(emborth)!=""){
		//var checkDate=CheckDate(emborth)
		var emborth = GetSysDateToHtml(emborth);
		if((emborth.indexOf("ERROR")>=0)||(emborth=="")){
			$.messager.alert("提示:","日期格式错误");
			hidemask()
			return;
		}else{
			$('#emborth').val(emborth)
		}
		
		emborth=new Date(Date.parse(emborth.replace(/-/g,"/")))
		minBorth=new Date("1841","00","01")
		if (emborth<minBorth){
			$.messager.alert("提示:","生日不能小于1841！");
			hidemask()
			return;
		}
	}

	var age = $("#empatage").val();
	if(parseInt(age)>120){
		$.messager.alert("提示:","年龄不能大于120！");
		hidemask()
		return;
	}
	if(parseInt(age)<0){
		$(this).val("")
		$.messager.alert("提示:","年龄不能小于0！");
		hidemask()
		return;
	}
	
	var EmIdentNo = $("#emidentno").val();        /// 证件号码
	if (!$("#emidentno").validatebox('isValid')){
		$.messager.alert("提示:","身份验证失败，请重新录入！");
		hidemask()
		return;
	}
		
	var EmFamTel = $("#emfamtel").val();         /// 家庭电话
	if (!$("#emfamtel").validatebox('isValid')){
		$.messager.alert("提示:","电话验证失败，请重新录入！");
		hidemask()
		return;
	}

	//检验性别
	if (!checkSex()){
		hidemask()
		return;
	}
	
	
	var EmPatName = $("#empatname").val();       /// 姓名    
	if (EmPatName == ""){
		$.messager.confirm('提示', '姓名为空,确定要以无名氏身份进行分诊吗?', function(result){  
        	if(result) {
	        	surePatEmTriage();
	        }else{
				hidemask()
		    	return;
		    }
	    })
	}else{
		surePatEmTriage();
	}
}
///获取SwitchBox的选中状态
function getSwitchBoxStatus(id){
	return $("#"+id).bootstrapSwitch("status")?"Y":"N";
}
function setSwitchBoxStatus(id,status){
    $('#'+id).bootstrapSwitch('setState', status=="Y"?true:false);	
}



//
function getMewsLev(score){
   	var level=0
	if(score<5){level=3}
	if((5<=score)&&(score<9)){level=2}
	if(9<=score){level=1}
	return level
}
function getPainLev(score){
   	var level=0
	if(score<=3){level=4}
	if((3<score)&&(score<6)){level=3}
	if((6<=score)&&(score<8)){level=2}
	if(8<=score){level=1}
	return level
}
function getHurtLev(score){
   	var level=0
	if(score<=3){level=1}
	if((3<score)&&(score<12)){level=2}
	if((12<=score)&&(score<14)){level=3}
	if(14<=score){level=4}
	return level
}
function getRemsLev(score){
	level=0
	if(score<=11){level=4}
	if((11<score)&&(score<18)){level=2}
	if(18<=score){level=1}
	return level
}
function getGcsScore(score){
	level=0
	if(score<=4){level=4}
	if((4<score)&&(score<8)){level=3}
	if((8<=score)&&(score<11)){level=2}
	if((11<=score)&&(score<14)){level=1}
	if(14<=score){level=0}
	return level
}

function getChildLev(score){
   	var level=0
	if((score<=2)&&(score>=0)){level=3}
	if(score==3){level=2}
	if(4<=score){level=1}
	return level
}

function collBakInsAutoScore(markID,score){
	if(markID=="switchRTS"){
		insertAutoScore("RTS","",$g("RTS评分"),score);	
	}
	if(markID=="switchISS"){
		insertAutoScore("ISS","",$g("ISS评分"),score);	
	}
	if(markID=="switchFRFA"){ //hxy 2022-08-17
		insertAutoScore("FRFA","",$g("FRFA评分"),score);	
	}
	if(markID=="switchChest"){ //hxy 2022-08-18
		insertAutoScore("ChestPain","",$g("胸痛评分"),score);	
	}
	return;
}

//
function insertAutoScore(code,lev,desc,score){
	desc = $g(desc);
	var rowIndex = $('#autoScoreDatagrid').datagrid('getRowIndex', code);
    if(rowIndex>=0){
	    $('#autoScoreDatagrid').datagrid('updateRow',{index: rowIndex, row: {lev: lev,score:score} });
	}else{
		$('#autoScoreDatagrid').datagrid('appendRow', {code: code,lev: lev,itm:desc,score:score});
	}
   	var rows = $('#autoScoreDatagrid').datagrid("getRows");
   	for (var i = 0; i < rows.length; i++) { 
       if(rows[i]['lev']>0){
	      if(rows[i]['lev']<lev){
	      	lev=rows[i]['lev']   
	   	  };  
	   }
    }
    if(lev>0){
	    $('#EmRecLevel').combobox('select',lev)  
	} 
}
/// 随机获取系统安全码
function GetSecurityNO(){
	var securityNO = "";
    runClassMethod("web.UDHCAccCardManage","GetCardCheckNo",{"PAPMINo":''},function(jsonstring){
		if (jsonstring != null){
			securityNO = jsonstring;
		}
		
	},'',false)
	return securityNO;
}

/// 写卡 bianshuai 2017-03-30
function WrtCard(mySecrityNo){
	
	var myCardNo = $("#emcardno").val();         /// 卡号
	var rtn=DHCACC_WrtMagCard("23", myCardNo, mySecrityNo, m_CCMRowID);
	if (rtn!="0"){
		return false;
	}
	return true;
	
}	
function surePatEmTriage(){
	
	/// 转向科室 2016-09-12 congyue 
	var EmToLocID = $("#EmToLocID").combobox("getValue");   
	var EmRegID = $("#EmRegID").val();   			/// 登记ID
	var PatientID = $("#PatientID").val();   		/// PatientID
	var EmPCLvID = $("#EmPCLvID").val();   			/// 分诊ID
	
	var EmBatchNum = $("#EmBatchNum").val();        /// 总人数
	var Adm = $("#Adm").val();                      ///就诊号
	
	var EmAgainFlag = getSwitchBoxStatus("EmAgainFlag");/// 重返标识
	var EmBatchFlag = getSwitchBoxStatus("EmBatchFlag");/// 成批就诊
	
	if ((EmBatchFlag == "Y")&($("#EmBatchNum").val() == "")){
		$.messager.alert("提示:","请填写总人数!");                     /// 成批就诊为是,总人数不能为空
		hidemask()
		return;
	}
	
	var EmScreenFlag =getSwitchBoxStatus("EmScreenFlag");/// 筛查
    var EmCombFlag =getSwitchBoxStatus("EmCombFlag");    /// 复合伤
    var EmECGFlag =getSwitchBoxStatus("EmECGFlag");/// ECG
    var EmPoisonFlag =getSwitchBoxStatus("EmPoisonFlag");/// 中毒
	var EmOxygenFlag =getSwitchBoxStatus("EmOxygenFlag");/// 是否吸氧
	var EmPatAskFlag =getSwitchBoxStatus("EmPatAskFlag");/// 已开假条
	var AISActiveFlag =$("#switchHURT").hasClass("dhcc-btn-blue")?"Y":""; //getSwitchBoxStatus("switchHURT");/// 创伤级别
    var FALLActiveFlag =$("#switchFALL").hasClass("dhcc-btn-blue")?"Y":""; // getSwitchBoxStatus("switchFALL");/// 坠跌级别
	var EmPainFlag=$("#switchPAINLEV").hasClass("dhcc-btn-blue")?"Y":""; //getSwitchBoxStatus("switchPAINLEV");/// 疼痛级别
	var EmPainFlagi=$("#switchPAIN").hasClass("dhcc-btn-blue")?"Y":""; //getSwitchBoxStatus("switchPAIN");/// 疼痛评分
	var GlasgowFlag = "";/// 格拉斯哥级别
	var ESIFlag=$("#switchESI").hasClass("dhcc-btn-blue")?"Y":""; //getSwitchBoxStatus("switchESI");/// ESI评分
	var REMSFlag=$("#switchREMS").hasClass("dhcc-btn-blue")?"Y":"";//getSwitchBoxStatus("switchREMS");/// REMS评分
	var MEWSFlag=$("#switchMEWS").hasClass("dhcc-btn-blue")?"Y":"";//getSwitchBoxStatus("switchMEWS");/// MEWS评分
	var ChildEmrFlag=$("#switchChildEar").hasClass("dhcc-btn-blue")?"Y":"";//getSwitchBoxStatus("switchChildEar");/// 儿童早期预警评分 
	
	var EmAware =$("button[name='EmAware'].dhcc-btn-blue").attr('id') //$("#EmAware").combobox("getValue");    	     /// 意识状态

	var EmUpdLevRe = $("#EmUpdLevRe").combobox("getValue");    	 /// 护士更改分级原因
	
	var EmNurseLevel = "";
	if ($('input[name="NurseLevel"]:checked').length){
		EmNurseLevel = $('input[name="NurseLevel"]:checked').val();  /// 护士分级
	}
	if (EmNurseLevel == ""){
		$.messager.alert("提示:","请先选择病人病情分级！");
		hidemask()
		return;
	}
	
	/// 是否修改护士分级
	if ((EmPCLvID !="")&(TmpNurLev != EmNurseLevel)&(EmNurReaID == "")){
		showNurWin(EmPCLvID);  /// 护士修改分级窗体
		hidemask()
		return;
	}
	
	var EmRecLevel = $("#EmRecLevel").combobox("getValue");        	 /// 推荐分级
	
	var EmArea = "";
	if ($('input[name="Area"]:checked').length){
		EmArea =  $('input[name="Area"]:checked').val();   			 /// 去向分区
	}

	///  症状
	var EmSymDesc="",EmSymDescArr= [];
    var rows = $('#autoScoreDatagrid').datagrid("getRows");
   	for (var i = 0; i < rows.length; i++) { 
   		if(rows[i]['code'].indexOf("SYM")!=-1) EmSymDescArr.push(rows[i]['code'].split("SYM")[1]);
    }
    EmSymDesc = EmSymDescArr.join("#");

	/// 生命体征
	var EmPcsTemp = $("#EmPcsTemp").val();      ///  体温
	var EmPcsHeart = $("#EmPcsHeart").val();    ///  心率
	var EmPcsPulse = $("#EmPcsPulse").val();    ///  脉搏
	var EmPcsSBP = $("#EmPcsSBP").val();        ///  血压(BP)收缩压
	var EmPcsDBP = $("#EmPcsDBP").val();        ///  舒张压
	var EmPcsSoP2 = $("#EmPcsSoP2").val();      ///  血氧饱合度SoP2
	var EmPcsBreath = $("#EmPcsBreath").val();  ///  呼吸频率
	var EmPcsGLU = $("#EmPcsGLU").val();    	///  血糖
	var EmPcsTime="";
	var VitalSigns= $("#Vitsigtype").combobox("getValue")    //生命体征类型 2022-07-25 cy
	var EmPatChkSign = EmPcsTime + RowDelim + EmPcsTemp + RowDelim + EmPcsHeart + RowDelim + EmPcsPulse + RowDelim + EmPcsSBP + RowDelim + EmPcsDBP + RowDelim + EmPcsSoP2 + RowDelim + EmPcsBreath+ RowDelim +EmPcsGLU;

	/// 既往史
	var EmPatChkHisArr = [];
	$('input[name="EmPatChkHis"]:checked').each(function(){
		EmPatChkHisArr.push(this.value);
	})

	var EmPatChkHis = EmPatChkHisArr.join(RowDelim);
    ///  病人来源
	var EmPatSource = "";
	if ($('input[name="EmPatSource"]:checked').length){
		EmPatSource = $('input[name="EmPatSource"]:checked').val();
	}

    ///  病史提供人
	var EmPatProvider = "";
	if ($('input[name="EmPatProvider"]:checked').length){
		EmPatProvider = $('input[name="EmPatProvider"]:checked').val();
	}
    ///  来诊方式
	var EmPatAdmWay = "";
	if ($('input[name="EmPatAdmWay"]:checked').length){
		EmPatAdmWay = $('input[name="EmPatAdmWay"]:checked').val();
	}
	///  六大病种
	var SixSick = "";
	if ($('input[name="EmPatSixSick"]:checked').length){
		$('input[name="EmPatSixSick"]:checked').each(function(){
			if(SixSick){
				SixSick=SixSick+"#"+$(this).val();	
			}else{
				SixSick=$(this).val();
			}
		})
	}
    ///  用药情况
	var EmHisDrug = "",EmHisDrugDesc = "";
	EmHisDrug=getSwitchBoxStatus("EmHisDrug")
	if (EmHisDrug == "Y"){
		EmHisDrugDesc = $("#EmHisDrugDesc").val();
	}
	
	///   辅助物
	var EmMaterial = "",EmMaterialDesc = "";
	EmMaterial=getSwitchBoxStatus("EmMaterial")
	if (EmMaterial == "Y"){
		EmMaterialDesc = $("#EmMaterialDesc").val();
	}
	
	///   疫苗接种史
	var EmVaccine = "",EmVaccineDesc = "",EmVaccineDescMain="";

	EmVaccine=getSwitchBoxStatus("EmVaccine")
	EmVaccineDesc =EmVaccine=="Y"?$("#EmVaccineDesc").val():"";
	EmVaccineDescMain = ((EmVaccine == "Y")||(EmVaccine == "N"))?EmVaccine+"#"+EmVaccineDesc+"#"+"YM":"";
	
	///   群居史
	var EmGregarious = "",EmGregariousDesc = "",EmGregariousDescMain="";
	EmGregarious=getSwitchBoxStatus("EmGregarious")
	EmGregariousDesc =EmGregarious == "Y"?$("#EmGregariousDesc").val():"";

	EmGregariousDescMain=((EmGregarious == "Y")||(EmGregarious == "N"))?EmGregarious+"#"+EmGregariousDesc+"#"+"QJ":"";
	
	///   旅游史
	var EmTourism = "",EmTourismDesc = "",EmTourismDescMain="";
	EmTourism=getSwitchBoxStatus("EmTourism")
	EmTourismDesc = EmTourism == "Y"?$("#EmTourismDesc").val():"";
	
	EmTourismDescMain=((EmTourism == "Y")||(EmTourism == "N"))?EmTourism+"#"+EmTourismDesc+"#"+"LY":"";	
	
	///   接触史
	var EmContact = "",EmContactDesc = "",EmContactDescMain="";
	EmContact=getSwitchBoxStatus("EmContact")
	EmContactDesc =EmContact == "Y"? $("#EmContactDesc").val():"";
	EmContactDescMain=((EmContact == "Y")||(EmContact == "N"))?EmContact+"#"+EmContactDesc+"#"+"JC":"";
	///  其他
	var EmOtherDesc = $("#EmOtherDesc").val();
	
	/// 号别
	var EmPatChkCaArr = []; var EmPatChkCarePrv = "";
	//if ((PATTYPE != 1)&&(Adm=="")&&(EmToLocID=="")){
	if ((PATTYPE != 1)&&(EmToLocID=="")){
		var EmPatChkCare = $("#EmCheckNo").combobox("getValue")
		if (((EmPatChkCare == "")||(EmPatChkCare == undefined))&&(EmToLocID=="")&&(PATTYPE != 1)&&(Adm=="")){
			var EmToLocFlag=$HUI.radio('#EmToLocFlag').getValue()
			if(EmToLocFlag){
				$.messager.alert("提示:","请先选择转诊科室！");
			}else{
				$.messager.alert("提示:","请先选择号别或指向科室！"); ///2016-09-14 congyue 
			} 
			hidemask()
			return;
		}
		/// 分诊科室
		var EmLocID =$("#EmLocID").combobox("getValue"); 	      ///2016-09-06 congyue    /// 分诊科室
		if ((EmLocID == "")&&(EmToLocID=="")&&(PATTYPE != 1)&&(Adm=="")){
			$.messager.alert("提示:","请先选择分诊科室或指向科室！"); ///2016-09-14 congyue 
			hidemask()
			return;
		}
		EmPatChkCaArr.push(EmPatChkCare+","+EmLocID);
		EmPatChkCarePrv = EmPatChkCaArr.join("#");
	}else{
		EmPatChkCarePrv = $("#SelEmCheckNo").val();
	}
	
	/// 病人姓名为空,默认三无人员打钩
	var EmPatName = $("#empatname").val();       /// 姓名
	
	if (EmPatName == ""){
		$HUI.radio('input[label^="三无"]').setValue(true);
	}
	        	
	/// 特殊人群 2016-09-08 congyue 
	var EmPatChkType = [];
	$('input[name="EmPatChkType"]:checked').each(function(){
		EmPatChkType.push(this.value);
	})
	
	
	EmPatChkType = EmPatChkType.join(RowDelim);
	///congyue 2016-08-26
	var PatientID = $("#PatientID").val();  /// 病人ID

	/// 绿色通道 2017-02-28 bianshuai
	var EmGreenFlag = "N";
	if ($("input[name='EmGreenFlag']:checked").length){
		EmGreenFlag = $("input[name='EmGreenFlag']:checked").val();
	}
	
	/// 抢救病区 2017-03-08 bianshuai
	var EmPatWardID = $("#EmPatWard").combobox("getValue");
	if (typeof EmPatWardID == "undefined"){
		EmPatWardID = "";
	}
	
	/// 第1种模式:先挂号模式下;未挂号病人不允许进行分诊 
	/// 2017-03-08 bianshuai
	if ((PATTYPE == 1)&(Adm == "")){
		$.messager.alert("提示:","此病人未挂号不能分诊！");
		hidemask()
		return;
	}
	
	/// 第3种模式:先挂号模式下;需要先分诊时，必须是绿色通道或危重病人
	/// 2017-03-08 bianshuai
	var InsEpiFlag = "";
	var EmPatType = getEmPatType();
	if ((PATTYPE == 3)&(Adm == "")){
		if ((EmGreenFlag != "Y")&&(EmPatWardID == "")&&(EmPatType == "")){
			$.messager.alert("提示:","非绿色通道、抢救病人、三无人员不能直接分诊！");
			hidemask()
			return;
		}else{
			InsEpiFlag = "1";
		}
	}
	
	/// 第4种模式:先分诊;绿色通道、危重病人或三无人员默认插入挂号记录
	/// 2017-03-08 bianshuai
	if ((PATTYPE == 4)&(Adm == "")){
		if ((EmGreenFlag == "Y")||(EmPatWardID != "")||(EmPatType != "")){
			InsEpiFlag = "1";
		}
	}
	
	/// 非第一种模式,在更新分诊信息时，就诊ID取上次存储内容
	/// 2017-03-08 bianshuai
	if ((PATTYPE != 1)&(EmPCLvID != "")&(Adm == "")){
		Adm=$("#EmPatAdm").val();
	}
	
	var GreenHours = $("#greenHours").val();
	var strPAINLEV=$("#switchPAINLEV").attr("data-value");//疼痛^疼痛分级^疼痛范围^疼痛日期^疼痛时间
	strPAINLEV=strPAINLEV==""?"^^^^":strPAINLEV

	var EmNotes = $("#EmNotes").val();
	var EmVisTime = $("#emvistime").datetimebox("getValue");   /// 来诊时间
	if(EmVisTime==""){
		$.messager.alert("提示:","来诊时间不能为空！");
		hidemask()
		return;	
	}
	
	var EmPayMonay = $("input[name='EmPayMonay']:checked").length?"Y":"N";
	var AccRowId="";
	if(EmPayMonay=="Y"){
		AccRowId = GetAccRowId();
		if(AccRowId!=parseInt(AccRowId)){
			$.messager.alert("提示:",AccRowId);
			hidemask();
			return;	
		}
	}
	
	var EmGreRea= $("#EmGreRea").combobox("getValue"); //绿色通道申请原因
	if((GREENAUDIT==1)&&(EmGreenFlag=="Y")&&(EmGreRea=="")){
		$.messager.alert("提示:","绿色通道申请原因不能为空！");
		hidemask()
		return;	
	}
	
	/// 分诊护士^推荐分级^护士分级^护士分级原因^去向分区^分诊科室^重返标识^成批就诊^成批就诊人数^既往史
	/// 病人来源^来诊方式^意识状态^筛查^用药情况^用药情况描述^辅助物^辅助物描述
	/// 生命体征^症状表^症状描述^复合伤^ECG^中毒^疼痛^疼痛分级^疼痛范围^疼痛日期^疼痛时间^吸氧^请假^其他^病人ID^登记ID^已挂号别^病史提供人EmPainPosition替换EmPainRange
	var EmListData = LgUserID +"^"+ EmRecLevel +"^"+ EmNurseLevel +"^"+ EmUpdLevRe +"^"+ EmArea +"^"+ LgCtLocID +"^"+ EmAgainFlag +"^"+ EmBatchFlag +"^"+ EmBatchNum +"^"+ EmPatChkHis;
	var EmListData = EmListData +"^"+ EmPatSource +"^"+ EmPatAdmWay +"^"+ EmAware +"^"+ EmScreenFlag +"^"+ EmHisDrug +"^"+ EmHisDrugDesc +"^"+ EmMaterial +"^"+ EmMaterialDesc;
	var EmListData = EmListData +"^"+ EmPatChkSign +"^"+ "" +"^"+ EmSymDesc +"^"+ EmCombFlag +"^"+ EmECGFlag +"^"+ EmPoisonFlag +"^"+ strPAINLEV;
	var EmListData = EmListData +"^"+ EmOxygenFlag +"^"+ EmPatAskFlag +"^"+ EmOtherDesc +"^"+ PatientID +"^"+ EmRegID +"^"+ EmPatChkCarePrv +"^"+ Adm +"^"+EmPatChkType+"^"+EmToLocID+"^"+ LgHospID +"#"+ LgCtLocID +"#"+ LgUserID +"#"+ LgGroupID;
	var EmListData = EmListData +"^"+ EmGreenFlag +"^"+ EmPatWardID +"^"+ InsEpiFlag +"^"+AISActiveFlag+"^"+GlasgowFlag+"^"+EmUpdLevRe+"^"+SixSick+"^"+GreenHours;
	var	EmListData = EmListData+"^"+EmVaccineDescMain+"^"+EmGregariousDescMain+"^"+EmTourismDescMain+"^"+EmContactDescMain+"^"+EmNotes+"^"+EmVisTime;   ///分诊信息增加备注和来诊日期
	var EmListData = EmListData+"^"+EmPayMonay+"^"+AccRowId+"^"+EmGreRea+"^"+VitalSigns; // 增加生命体征类型 2022-07-25 cy
	
	if(EmPayMonay=="Y"){
		var IsNeedInsAdm=$cm({ClassName:"web.DHCEMPatCheckLev",MethodName:"ChkLevIsInsAdm",
			EmPCLvID:EmPCLvID,EmListData:EmListData,LgParams:LgParams,dataType:"text"},false);
		if((IsNeedInsAdm!=1)){
			//$.messager.alert("提示:","当前分诊条件不满足【自动挂号】或【号别未变化】,请【修改分诊信息】满足自动挂号条件或者【取消预交金缴费】选项!");
			$.messager.alert("提示:",IsNeedInsAdm);
			hidemask()
			return;
		}
	}

	
	var PatientID = $("#PatientID").val();       /// PatientID
	var EmCardNoID = $("#EmCardNoID").val();     /// 卡号ID
	var EmCardNo = $("#emcardno").val();         /// 卡号
	var EmPatNo = $("#EmPatNo").val();           /// 登记号
	var EmPatName = $("#empatname").val();       /// 姓名
	var EmPatAge = $("#empatage").val();         /// 年龄
	var EmBorth = $("#emborth").val();        	 /// 出生日期
	var EmPatSex = $("#empatsex").combobox("getValue");     /// 性别
	var EmNation = $("#emnation").combobox("getValue");     /// 民族
	var EmCountry = $("#emcountry").combobox("getValue");   /// 国籍
	var EmIdentNo = $("#emidentno").val();        /// 证件号码
	var EmFamTel = $("#emfamtel").val();          /// 家庭电话
	var EmAddress = $("#emaddress").val();        /// 家庭住址
	var EmCardType = $("#emcardtype").combobox("getValue"); /// 卡类型定义
	var empatage=$("#empatage").val()
	var occupation="" //$("#occupation").combobox("getValue");  /// 职业
	var religion="" //$("#religion").combobox("getValue");  /// 宗教
	var marital="" //$("#marital").combobox("getValue");  /// 婚姻
	var mySecrityNo = "";
	var patSocailType = $('#patSocailType').combobox("getValue");   //病人类型ID
	var patSocailTypeText = $('#patSocailType').combobox("getText");   //病人类型
	var healthCareNo =$("#healthCareNo").val();						//医保卡号
	var patCertType = $('#patCertType').combobox("getValue");
	
	///三无人员不判断身份证号
	if((patCertType==20)&&(EmIdentNo=="")&&(EmPatType=="")){
		$.messager.alert("提示:","身份证号不能为空！");
		hidemask()
		return;
	}
	
	if((patSocailTypeText.indexOf("医保")!=-1)&&(healthCareNo=="")){
		$.messager.alert("提示:","医保病人,请填写正确的医保卡号!","warning");
		hidemask()
		return;
	}
	
	if((patSocailTypeText.indexOf($g("医保"))<0)&&(healthCareNo!="")){
		$.messager.alert("提示:","非医保病人不能维护医保卡号!","warning");
		hidemask()
		return;
	}
	
	try{
		if ((EmCardNoID == "")&(EmCardNo != "")){
			/// 提取安全码异常
			mySecrityNo = GetSecurityNO();
			if (mySecrityNo == ""){
				$.messager.alert("提示:","提取安全码异常！");
				hidemask()
				return;
			}
			/// 写卡 [把安全码写到卡里]
			if (!WrtCard(mySecrityNo)){
				$.messager.alert("提示:","写卡异常！");
				hidemask()
				return;
			}
		}
	}catch(e){}
  	
  	
	
	if((patSocailType=="")||(patSocailType==undefined)){
		$.messager.alert("提示:","病人类型不能为空！");
		hidemask();
		return;
	}
	var EmCardTypeID = EmCardType.split("^")[0];
	
	/// 病人ID^登记号^姓名^身份证^性别^出生日期^国籍^民族^联系电话^家庭地址^卡号ID^卡号^登记人
	var PatListData = PatientID +"^"+ EmPatNo +"^"+ EmPatName +"^"+ EmIdentNo +"^"+ EmPatSex +"^"+ EmBorth +"^"+ EmCountry;
	var PatListData = PatListData +"^"+ EmNation +"^"+ EmFamTel +"^"+ EmAddress +"^"+ EmCardNoID +"^"+ EmCardNo +"^"+ LgUserID +"^"+ EmCardTypeID+"^"+empatage+"^"+LgHospID+"^"+mySecrityNo+"^"+occupation+"^"+marital+"^"+religion;
    var PatListData = PatListData +"^"+patSocailType+"^"+healthCareNo+"^"+patCertType
    
    var strFALL=$("#switchFALL").attr("data-value"); //坠跌评分串
    var strGCS=$("#switchGCS").attr("data-value"); //格拉斯哥昏迷子表ID串
	var strAIS=$("#switchHURT").attr("data-value"); //创伤评分
    var strESI=$("#switchESI").attr("data-value");//ESI 评分
    var strMEWS=$("#switchMEWS").attr("data-value");//MEWS 评分
    var strREMS=$("#switchREMS").attr("data-value");//REMS 评分
    var strPAIN=$("#switchPAIN").attr("data-value");//疼痛评分
    var strChildEmr=$("#switchChildEar").attr("data-value");//儿童早期预警评分
    
    var otherScoreArr=[];
    //RTS评分 other  评分项目太多，整合使用医生评分配置界面
    $(".scoreGroup").find("button[class^='dhcc-btn-gray']").each(function(){
		var thisType=$(this).attr("scoreType")||"";
		if(thisType!=""){
			var itemScoreValue=$(this).attr("data-value")||"";
			itemScoreValue!=""?otherScoreArr.push(itemScoreValue):"";
		}	
	})
	
	var otherScore=otherScoreArr.join("##");
    
	strFALL=FALLActiveFlag == "N"?"":strFALL
	strAIS=AISActiveFlag == "N"?"":strAIS
	strGCS=GlasgowFlag == "N"?"":strGCS
    strESI=ESIFlag == "N"?"":strESI
    strREMS=REMSFlag == "N"?"":strREMS
    strMEWS=MEWSFlag == "N"?"":strMEWS
    strPAIN=EmPainFlagi == "N"?"":strPAIN
    strChildEmr=ChildEmrFlag == "N"?"":strChildEmr
    
    //自动评分项
    var autoScore="",autoScoreArr=[] 
    var rows = $('#autoScoreDatagrid').datagrid("getRows");
   	for (var i = 0; i < rows.length; i++) { 
	      autoScoreArr.push(rows[i]['code']+"||"+rows[i]['lev']+"||"+rows[i]['score']+"||"+rows[i]['itm'])   
    }
    autoScore=autoScoreArr.join("^");
    	
	var ParmsObject={
		"EmPCLvID":EmPCLvID,
		"EmListData":EmListData,
		"PatListData":PatListData,
		"strAIS":strAIS,
		"strGCS":strGCS,
		"strFALL":strFALL,
		"strESI":strESI,
		"strREMS":strREMS,
		"strMEWS":strMEWS,
		"LgParams":LgParams,
		"autoScore":autoScore,
		"strPAIN":strPAIN,
		"ChkComputerIP":ComputerIp,
		"otherScore":otherScore,
		"strChildEmr":strChildEmr
	}
	
	/// 保存分诊数据
	runClassMethod("web.DHCEMPatCheckLev","saveEmPatCheckLev",ParmsObject,function(jsonString){
	  
		var retArr = jsonString.split("^");
		ret=retArr[0]
		if (ret > 0){
			$.messager.alert("提示:","保存成功！");
			$("#EmPCLvID").val(ret);   			/// 分诊ID
			AUTOPRINT=="1"?$("#print").click():"";
			$("#dgEmPatList").datagrid("reload");
			$("#PatientID").val(retArr[1])
			if(retArr[2]>0){
				$("#EmPatAdm").val(retArr[2])
			}
			
			initDefaultValue();
		}else if (ret==-401){
			$.messager.alert("提示:","该身份证已经建过卡!");
		}else if (ret==-101){
			$.messager.alert("提示:","没有找到出诊记录,或者从未排班!");
		}else if (ret==-102){
			$.messager.alert("提示:","此病人已经存在相同的登记记录,请使用病人列表查询!");
		}else if (ret==-98){
			$.messager.alert("提示:","已就诊，不允许修改或更换号别");
		}else if (ret==-99){
			$.messager.alert("提示:","号别已收费，请先退号!");
		}else if (ret==-10){
			$.messager.alert("提示:","卡已使用,请用新卡!");
		}else if (ret==-9){
			$.messager.alert("提示:","号别级别不同!");
		}else{
			msg=retArr[1]==undefined?ret:retArr[1];
			var docTip = GetErrMsg(msg);
			docTip?msg=docTip:"";
			var OldMsg=msg;
			if((ret==-27)&&(msg.indexOf("-2102") != "-1")){
				msg=$g("预交金余额不足");
			}else{
				msg=$g("保存失败！")+msg;
			}
			
			$.messager.alert("提示:",msg,"",function(){
				if((ret==-27)&&(OldMsg.indexOf("-2102") != "-1")){	///挂号结算失败
					$.messager.confirm('提示', '是否不做结算处理继续分诊?', function(result){  ///取消收费
			        	if(result) {
				        	$HUI.checkbox("#EmPayMonay").setValue("false");
							surePatEmTriage();
				        }
				    })
				}
			});
		}
		hidemask()
	},'text')
}

/// 读卡回调
function ReadCardCallback(rtnValue){
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case '0':
		break;
	case '-200':
		$.messager.alert("提示", "卡无效", "info", function() {
		});
		break;
	case '-201':
		break;
	default:
	}
}

/// 读卡
function GetAccRowId(){
	loadingShowOrHide("show");
	var ret="";
	var CardNo=$("#emcardno").val();
	var BackRet=DHCACC_GetAccInfo("", CardNo, "", "", ReadCardCallback);
	var BackAry = BackRet.split("^");
	if(BackAry[0]==0){
		ret=BackAry[7];
	}
	loadingShowOrHide("hide");
	return ret;
	return;
	loadingShowOrHide("show");
	var jsonData=$cm({ClassName:"web.DHCEMPatCheckLevCom",MethodName:"CardTypeDefineListBroker"},false);
	var ret="";
	for (var k=0;k<jsonData.length;k++){
		var myoptval=jsonData[k]["value"];
		var myEquipDR=myoptval.split("^")[14];
		if ((myoptval.split("^")[16]=="Handle")||(myEquipDR=="")) continue;
		var CardTypeRowId=myoptval.split("^")[0];
		var Infortn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
		var myary=Infortn.split("^");
		var rtn=myary[0];
		if ((rtn=="0")||(rtn=="-201")){
			ret = myary[7];
		}else if(rtn=="-200"){
			ret = "卡无效,无法获取账户信息!";
		}else if(rtn=="-1"){
			ret = "未检测到卡信息,无法获取账户信息!";
		}
	}
	loadingShowOrHide("hide");
	return ret;
}

function getRadioVal(name){
	exp='input[name="'+name+'"]:checked'
    return $(exp).length==0?0:$(exp).val()
}
function getRadioDataId(name){
	exp='input[name="'+name+'"]:checked'
    return $(exp).length==0?0:$(exp).attr("data-id")
}
/// 已分诊/未分诊 2016-09-20 congyue
function QueryEmPatList(){
	$('#searchName').searchbox('setValue',"")
	var EmPatNo=$('#search').searchbox('getValue');
	var params = GetParams(EmPatNo);
	//initDefaultValue(); 				//QQA 清空面板
	$("#dgEmPatList").datagrid("load",{"params":params}); //cy
}
function QueryEmPatListName(){
	$('#search').searchbox('setValue',"")
	var EmPatName=$('#searchName').searchbox('getValue');
	var params = GetParams("",EmPatName);
	$("#dgEmPatList").datagrid("load",{"params":params});
}
///  按日期查询登记病人列表 2016-09-20 congyue
function GetParams(EmPatNo,EmPatName)
{
    
	///  登记号补0
	if((EmPatNo!="")&&(!isNaN(EmPatNo))) //if (EmPatNo!="")
	{
		var EmPatNo = GetWholePatNo(EmPatNo);
	}
	$("#search+.searchbox>.searchbox-text").val(EmPatNo);
	var EmStaDate=$('#stadate').datebox('getText');  //开始日期
	var EmEndDate=$('#enddate').datebox('getText');  //结束日期

   	var EmChkFlag = "";  ///挂号/未挂号/分诊/未分诊标志 bianshuai 2018-03-24
	if ((PATTYPE == 1)||(PATTYPE == 3)){
		EmChkFlag=$("input[name='EmCkLvFlag']:checked").val();
	}else{
		EmChkFlag=$("input[name='EmEpiFlag']:checked").val();
	}
	if($("#StartTimeQ").val()){
		EmStaDate=$("#StartTimeQ").val();    //QQA 2016-11-12
		EmEndDate=$("#EndTimeQ").val();      //QQA 2016-11-12
	}
  	var ChekLevId=$("#ChekLevId").val();   //QQA 2016-11-12  
  	if(EmPatName==undefined){
	  	EmPatName="";
	}
	var Params = EmPatNo+"^"+EmBtnFlag+"^"+EmChkFlag+"^" + LgHospID +"^"+ LgCtLocID +"^"+ LgUserID +"^"+ LgGroupID+"^"+EmStaDate+"^"+EmEndDate+"^"+ChekLevId;
	Params=Params+"^"+EmPatName;
	$("#ChekLevId").val("");   //QQA 2016-11-12
	$("#StartTimeQ").val("");  //QQA 2016-11-12
	$("#EndTimeQ").val("");    //QQA 2016-11-12
	
	EmBtnFlag="";
	return  Params;

}
///补0病人登记号
function GetWholePatNo(EmPatNo){

	///  判断登记号是否为空
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  登记号长度值
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('错误提示',"登记号输入错误！");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;
}
/// flag:1/0  1:设置分诊数据 0:不设置分诊数据
/// 设置登记面板数据
function setRegPanelInfo(rowData,flag){
	
	//initDefaultValue();
	clearData();
	if(rowData.IsDeath=="Y"){
		$.messager.alert("提示","注意,患者已故!","warning");	
	}	
	
	$("#EmCardNoID").val(rowData.CardNoID);   		/// 卡号ID
	$("#EmRegID").val(rowData.EmRegID);   		    /// 登记ID
	$("#emcardno").val(rowData.PatCardNo);   		/// 卡号
	$("#PatientID").val(rowData.PatientID);   		/// PatientID
	$("#SelEmCheckNo").val(rowData.EpiRegData);
	
	$("#EmPatNo").val(rowData.PatNo);   		    /// 登记号
	$("#empatname").val(rowData.PatName);   		/// 姓名
	///$("#empatname").val("*"+rowData.PatName.substring(1,9));   		/// 姓名
	$("#empatage").val(rowData.PatAge);        		/// 年龄
	
	//$("#empatsex").combobox("setValue",rowData.sexId);    	 /// 性别
	$("#empatsex").combobox("setValue",""); 
	data=$("#empatsex").combobox("getData")
	for ( var i = 0; i <data.length; i++){
    	if(data[i].value==rowData.sexId){
			$("#empatsex").combobox("setValue",rowData.sexId);    	 /// 性别
		}	
	}
	$("#emnation").combobox("setValue",rowData.nationdr);    /// 民族
	$("#emcountry").combobox("setValue",rowData.countrydr);  /// 国籍
	$("#occupation").combobox("setValue",rowData.PAPEROccupationDR);  /// 职业
	$("#religion").combobox("setValue",rowData.PAPERReligionDR);  /// 宗教
	$("#marital").combobox("setValue",rowData.PAPERMaritalDR);  /// 婚姻
	$("#emborth").val(rowData.birthday);    /// 出生日期
	
	$("#emidentno").val(rowData.IdentNo);   /// 证件号码
	$("#emfamtel").val(rowData.PatTelH);    /// 家庭电话
	$("#emaddress").val(rowData.Address);   /// 家庭住址
	$("#SpecialPat").val(rowData.SpecialPat);  ///特殊病人：(配置了分诊需要建卡可以特殊对待)
	$("#patSocailType").combobox("setValue",rowData.BillType);
	$("#patCertType").combobox("setValue",rowData.IdentID);
	$("#healthCareNo").val(rowData.PatYBCode);
	if(rowData.CardNoID!=""){
		$("#EmCardNoID").val(rowData.CardNoID);   		/// 卡号ID
		$("#emcardno").val(rowData.PatCardNo);   		/// 卡号
		GetEmPatCardTypeDefine(rowData.CardTypeID);  ///  设置卡类型
	}
	
	setModifyPat(true);	
	
	if(flag==0){
		return;
	}
	
	$("#Adm").val(rowData.EpisodeID);             /// 就诊ID //hxy 2020-03-24 原：rowData.Adm
	var EmRegDateTime=rowData.EmRegDate+" "+rowData.EmRegTime
	$("#emvistime").datetimebox("setValue",EmRegDateTime);   /// 来诊时间
	$("#EmPCLvID").val(rowData.EmPCLvID);   		/// 分诊ID
	
	LoadEmPatCheckLevInfo(rowData.EmPCLvID);     ///  如果病人已经进行分级,显示分级数据
}
///  如果病人已经进行分级,显示分级数据
function LoadEmPatCheckLevInfo(EmPCLvID){
	/// 提取分级数据
	$('#EmLocID').combobox('enable');
	$('#EmCheckNo').combobox('enable');
	$HUI.checkbox("#EmGreenFlag").disable();
	$("#updGreen").parent().show();
	
	initPainLev=false;
 	initESI=false;
 	initHurtLev=false;
 	initREMS=false;
 	initMEWS=false;
 	initPAIN=false;
 	initFALL=false;
	
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmPatCheckLev",{"EmPCLvID":EmPCLvID},function(jsonString){
		
		if (jsonString != null){
			var EmPatCheckLevObj = jsonString;
			LockRecLevFlag=1;
			if(EmPatCheckLevObj.EmToLocID!=0){
				$("#EmLocID").combobox('setValue',"");
				$("#EmCheckNo").combobox('setValue',"");
				$('#EmLocID').combobox({disabled:true})
				$('#EmCheckNo').combobox({disabled:true})
				$('#EmToLocID').combobox('enable');
				/// 转向科室 2016-09-12 congyue
				$HUI.radio('#EmToLocFlag').setValue(true);
				$("#EmToLocID").combobox('select',EmPatCheckLevObj.EmToLocID);
			}
			
			///来诊时间
			if(EmPatCheckLevObj.CreatDate!=""){
				$("#emvistime").datetimebox("setValue",EmPatCheckLevObj.CreatDate+" "+EmPatCheckLevObj.CreatTime);	
			}
			
			if(EmPatCheckLevObj.EmLocID!=0){
				$('#EmToLocID').combobox('setValue',"");
				$("#EmLocID").combobox('setValue',EmPatCheckLevObj.EmLocID)
			} 
			///	 总人数
			$("#EmBatchNum").val(EmPatCheckLevObj.EmBatchNum);
			
			
			///  护士更改分级原因
			$("#EmUpdLevRe").combobox('setValue',EmPatCheckLevObj.EmUpdLevRe);

			///  分诊科室
			///$("#EmLocID").val(EmPatCheckLevObj.EmLocID);  //2016-09-06 congyue

			///  意识状态
			//$("#EmAware").combobox('setValue',EmPatCheckLevObj.EmAware);
			$("button[name='EmAware'][id='"+EmPatCheckLevObj.EmAware+"']").addClass("dhcc-btn-blue");
			///  护士分级
			$HUI.radio('input[name="NurseLevel"][value="'+ EmPatCheckLevObj.NurseLevel +'"]').setValue(true);
			TmpNurLev = EmPatCheckLevObj.NurseLevel;
			EmNurReaID = ""; 
			
			///  去向
			$HUI.radio('input[name="Area"][value="'+ EmPatCheckLevObj.Area +'"]').setValue(true); 
			
			//重返标识
			setSwitchBoxStatus("EmAgainFlag",EmPatCheckLevObj.EmAgainFlag)
			//成批就诊
			setSwitchBoxStatus("EmBatchFlag",EmPatCheckLevObj.EmBatchFlag)

			///  中毒
            setSwitchBoxStatus("EmPoisonFlag",EmPatCheckLevObj.EmPoisonFlag)
			///  是否吸氧
            setSwitchBoxStatus("EmOxygenFlag",EmPatCheckLevObj.EmOxygenFlag) 
			///  筛查
            setSwitchBoxStatus("EmScreenFlag",EmPatCheckLevObj.EmScreenFlag)
			///  复合伤
			setSwitchBoxStatus("EmCombFlag",EmPatCheckLevObj.EmCombFlag)
			///  已开假条
			setSwitchBoxStatus("EmPatAskFlag",EmPatCheckLevObj.EmPatAskFlag)
			///  ECG
            setSwitchBoxStatus("EmECGFlag",EmPatCheckLevObj.EmECGFlag)
			///  用药情况
            setSwitchBoxStatus("EmHisDrug",EmPatCheckLevObj.EmHisDrug)
			///  辅助物
            setSwitchBoxStatus("EmMaterial",EmPatCheckLevObj.EmMaterial)
			///  疼痛分级
			setSwitchBoxStatus("EmPainFlagi",EmPatCheckLevObj.EmPainFlag)
			
			///	 既往史
			var EmPatChkHisArr = EmPatCheckLevObj.EmPatChkHis.split("#");
			for(var i=0;i<EmPatChkHisArr.length;i++){
				$HUI.radio('input[name="EmPatChkHis"][value="'+ EmPatChkHisArr[i] +'"]').setValue(true);
			}
			
			///  病人来源
			$HUI.radio('[name="EmPatSource"][value="'+ EmPatCheckLevObj.EmPatSource +'"]').setValue(true);
			///  病史提供人
			$HUI.radio('[name="EmPatProvider"][value="'+ EmPatCheckLevObj.EmPatProvider +'"]').setValue(true);
			///  来诊方式
			$HUI.radio('[name="EmPatAdmWay"][value="'+ EmPatCheckLevObj.EmPatAdmWay +'"]').setValue(true);
			///  特殊人群 2016-09-05 congyue
			$HUI.radio('[name="EmPatChkType"][value="'+ EmPatCheckLevObj.EmPatChkType +'"]').setValue(true);
				
			///  六大病种
			if(EmPatCheckLevObj.SixSick!==""){
				sixSickArr = EmPatCheckLevObj.SixSick.split("#");
				for(x in sixSickArr){
					$HUI.radio('[name="EmPatSixSick"][value="'+ sixSickArr[x] +'"]').setValue(true);		
				}
			}
				
			//疼痛评分
			if(EmPatCheckLevObj.PainStr!=""){
				if(EmPatCheckLevObj.PainStr.split("#")[5]=="Y"){
					$("#switchPAIN").addClass("dhcc-btn-blue");
					$("#switchPAIN").attr("data-value",EmPatCheckLevObj.PainStr);
				}else{
					$("#switchPAIN").attr("data-value","");
				}
			}
			///创伤分级
			if(EmPatCheckLevObj.EmAisFlag=="Y"){
				$("#switchHURT").addClass("dhcc-btn-blue");
				$("#switchHURT").attr("data-value",EmPatCheckLevObj.AisIdStr);
			}else{
				$("#switchHURT").attr("data-value","");
			}
			
			///坠跌分级
			if(EmPatCheckLevObj.FALLFlag=="Y"){
				$("#switchFALL").addClass("dhcc-btn-blue");
				$("#switchFALL").attr("data-value",EmPatCheckLevObj.FallIdStr);
			}else{
				$("#switchFALL").attr("data-value","");
			}
		    ///Esi分级
			var esiIdArr = EmPatCheckLevObj.EsiIdStr.split("#");
			if(esiIdArr[5]=="Y"){
				$("#switchESI").addClass("dhcc-btn-blue");
				$("#switchESI").attr("data-value",EmPatCheckLevObj.EsiIdStr);
			}else{
				$("#switchESI").attr("data-value","");
			}
			
		    ///Rems分级
		    var remsIdArr = EmPatCheckLevObj.RemsIdStr.split("#");
			if(remsIdArr[5]=="Y"){
				$("#switchREMS").addClass("dhcc-btn-blue");
				$("#switchREMS").attr("data-value",EmPatCheckLevObj.RemsIdStr);
			}else{
				$("#switchREMS").attr("data-value","");
			}
			///格拉斯哥
			$("#switchGCS").attr("data-value",EmPatCheckLevObj.GcsIdStr);
			
		    ///Mews分级
		    var mewsIdArr = EmPatCheckLevObj.MewsIdStr.split("#");
			if(mewsIdArr[5]=="Y"){
				$("#switchMEWS").addClass("dhcc-btn-blue");
				$("#switchMEWS").attr("data-value",EmPatCheckLevObj.MewsIdStr);
			}else{
				$("#switchMEWS").attr("data-value","");
			}
										
			
			/// 疼痛分级
            if(EmPatCheckLevObj.EmPainFlag=="Y"){
	        	$("#switchPAINLEV").addClass("dhcc-btn-blue");
	        	PainDate="",PainTime=""
	        	if (EmPatCheckLevObj.EmPainTime != ""){
					PainDate = EmPatCheckLevObj.EmPainTime.split(" ")[0];
					PainTime = EmPatCheckLevObj.EmPainTime.split(" ")[1];
				}
	        	parStr="Y^"+EmPatCheckLevObj.EmPainLev+"^"+EmPatCheckLevObj.EmPainRange+"^"+PainDate+"^"+PainTime
	        	$("#switchPAINLEV").attr("data-value",parStr);
	        }else{
				$("#switchPAINLEV").attr("data-value","");
			} 
			
			///儿童早期预警评分 lp 20200911
		    var ChildEarArr = EmPatCheckLevObj.ChildEarStr.split("#");
			if(ChildEarArr[0] != ""){
				$("#switchChildEar").addClass("dhcc-btn-blue");
				$("#switchChildEar").attr("data-value",EmPatCheckLevObj.ChildEarStr);
			}else{
				$("#switchChildEar").attr("data-value","");
			}		

			///RTS评分
			$(".scoreGroup").find("button[class^='dhcc-btn-gray']").each(function(){
				var thisType=$(this).attr("scoreType")||"";
				if(thisType!=""){
					if(EmPatCheckLevObj[thisType]||false){
						var scoreValue=EmPatCheckLevObj[thisType];
						scoreValue=scoreValue.replaceAll("$c(2)",String.fromCharCode(2));
						scoreValue=scoreValue.replaceAll("$c(94)",String.fromCharCode(94));
						$(this).addClass("dhcc-btn-blue");
						$(this).attr("data-value",scoreValue);
					}else{
						$(this).attr("data-value","");
					}
				}	
			})
			
			
			$("#EmBatchNum").val(EmPatCheckLevObj.EmBatchNum); //	 成批就诊
			$("#EmHisDrugDesc").val(EmPatCheckLevObj.EmHisDrugDesc); ///	 用药情况
			$("#EmMaterialDesc").val(EmPatCheckLevObj.EmMaterialDesc);///	 辅助物

			
			///既往综合史 zhl 2019-01-31
			if (EmPatCheckLevObj.ListHisArray != "") {
				var listHistorArray=EmPatCheckLevObj.ListHisArray
				for(i=0;i<listHistorArray.split("$").length;i++){
					var hisStr=listHistorArray.split("$")[i];
					if(hisStr.split("#")[2]=="YM"){
						setSwitchBoxStatus("EmVaccine",hisStr.split("#")[0])
						if(hisStr.split("#")[1]!=""){
							$("#EmVaccineDesc").val(hisStr.split("#")[1]);
						    $('#EmVaccineDesc').attr("disabled",false);
							}
						
						}
						
					if(hisStr.split("#")[2]=="QJ"){
						setSwitchBoxStatus("EmGregarious",hisStr.split("#")[0])
						if(hisStr.split("#")[1]!=""){
							$("#EmGregariousDesc").val(hisStr.split("#")[1]);
						    $('#EmGregariousDesc').attr("disabled",false);
							}
						
					}
						
					if(hisStr.split("#")[2]=="LY"){
						setSwitchBoxStatus("EmTourism",hisStr.split("#")[0])
						if(hisStr.split("#")[1]!=""){
							$("#EmTourismDesc").val(hisStr.split("#")[1]);
						    $('#EmTourismDesc').attr("disabled",false);
							}
						
						}
					if(hisStr.split("#")[2]=="JC"){
						setSwitchBoxStatus("EmContact",hisStr.split("#")[0])
						if(hisStr.split("#")[1]!=""){
						$("#EmContactDesc").val(hisStr.split("#")[1]);
						$('#EmContactDesc').attr("disabled",false);
							}

						}
					}
				
			}			
			///	 其他
			$("#EmOtherDesc").val(EmPatCheckLevObj.EmOtherDesc);
		
			///  预检号别
			if (EmPatCheckLevObj.EmPatChkCare != ""){
				var EmPatChkCare = EmPatCheckLevObj.EmPatChkCare.split("#");
				var EmPatChkCareID = EmPatChkCare[0].split("@")[0];
				var EmPatChkCareDesc = EmPatChkCare[0].split("@")[1];
				$("#EmCheckNo").combobox('setValue',EmPatChkCareID);
				$("#EmCheckNo").combobox('setText',EmPatChkCareDesc);
				
				var queDocStr="";
				for(var i=0;i<EmPatChkCare.length;i++){
					queDocStr=queDocStr+EmPatChkCare[i].split("@")[1]+","
				}
		        $("#queDoc").html(queDocStr)
			}
						
			

			
			///	 生命体征
			var flag="";
			var EmPatChkSignArr = EmPatCheckLevObj.EmPatChkSign.split("#");
			for(var i=0;i<EmPatChkSignArr.length;i++){
				if (i!=0){flag=1};
				var EmPcsArr = EmPatChkSignArr[i].split("@");
				$("#EmPcsTime"+flag).val(EmPcsArr[0]);   ///  时间
				$("#EmPcsTemp"+flag).val(EmPcsArr[1]);   ///  体温
				$("#EmPcsHeart"+flag).val(EmPcsArr[2]);  ///  心率
				$("#EmPcsPulse"+flag).val(EmPcsArr[3]);  ///  脉搏
				$("#EmPcsSBP"+flag).val(EmPcsArr[4]);    ///  血压(BP)收缩压
				$("#EmPcsDBP"+flag).val(EmPcsArr[5]);    ///  舒张压
				$("#EmPcsSoP2"+flag).val(EmPcsArr[6]);   ///  血氧饱合度SoP2
				$("#EmPcsBreath"+flag).val(EmPcsArr[7]);      ///  呼吸频率
				$("#EmPcsGLU"+flag).val(EmPcsArr[8]);      ///  血糖
			}
			//生命体征类型 2022-07-25 cy 
			var VitialSignsType=EmPatCheckLevObj.Vitalsign
			$("#Vitsigtype").combobox('setValue',VitialSignsType); 
			///分诊备注
			$("#EmNotes").val(EmPatCheckLevObj.PCLNotes);

			/// 绿色通道 2017-02-28 bianshuai
			if (EmPatCheckLevObj.EmPatGreFlag == 1){
				$HUI.radio('[name="EmGreenFlag"][value="Y"]').setValue(true);
				$("#greenHours").val(EmPatCheckLevObj.EmPatGreHours);
				$("#greenHours").attr("disabled",true);
				$('#EmGreRea').combobox({disabled:true});
			}
			
			///  绿色通道申请原因
			$("#EmGreRea").combobox('setValue',EmPatCheckLevObj.GreReaDr)

			/// 抢救病区 2017-03-08 bianshuai
			//if (EmPatCheckLevObj.EmWardID != ""){
			//	$('#EmPatWard').combobox({disabled:false});
			//	
			//}else{
			//	$('#EmPatWard').combobox({disabled:true});
			//}
			$("#EmPatWard").combobox('setValue',EmPatCheckLevObj.EmWardID);
			
			/// 预检就诊ID 2017-03-08 bianshuai
			$("#EmPatAdm").val(EmPatCheckLevObj.EmPatAdm);
			
			/// 自动评分项
			AutoScoreStrArr=EmPatCheckLevObj.AutoScoreStr.split("$$")
			for(var i=0;i<AutoScoreStrArr.length;i++){
				if(AutoScoreStrArr[i]!=""){
					var tmpArr=AutoScoreStrArr[i].split("||")
					var rowIndex = $('#autoScoreDatagrid').datagrid('getRowIndex', tmpArr[5]);
				    if(rowIndex>=0){
					    $('#autoScoreDatagrid').datagrid('updateRow',{index: rowIndex, row: {lev: tmpArr[2],score:tmpArr[3]} });
					}else{
						$('#autoScoreDatagrid').datagrid('appendRow', {code: tmpArr[5],lev: tmpArr[2],itm:tmpArr[4],score:tmpArr[3]});
					}
					//$('#autoScoreDatagrid').datagrid('appendRow', {code: tmpArr[5],lev: tmpArr[2],itm:tmpArr[4],score:tmpArr[3]});
				}
			}
			///  推荐分级
			$("#EmRecLevel").combobox('setValue',EmPatCheckLevObj.EmRecLevel);
			LockRecLevFlag=0;
		}else{
			$('#EmBatchNum').attr("disabled",true);	
		}
	})
}
/// 获取病人对应卡类型数据
function GetEmPatCardTypeDefine(CardTypeID){
    
	runClassMethod("web.DHCEMPatCheckLevCom","GetEmPatCardTypeDefine",{"CardTypeID":CardTypeID},function(jsonString){
		
		if ((jsonString != null)&&((jsonString != ""))){
			var CardTypeDefine = jsonString;
			var CardTypeDefArr = CardTypeDefine.split("^");
			if (CardTypeDefArr[16] == "Handle"){
				$('#emcardno').attr("readOnly",false);
			}else{
				$('#emcardno').attr("readOnly",true);
			}
			m_CardNoLength = CardTypeDefArr[17];   /// 卡号长度
			m_CCMRowID = CardTypeDefArr[14];
			$("#emcardtype").combobox("setValue",CardTypeDefine);
		}
	},'text')
}

///  计算生命体征
function setEmRecLevel(){
	
	if(LockRecLevFlag!=0){
		return;	
	}
	
	var EmPcsListData = "";
	/// 意识状态
	var EmAware =$("button[name='EmAware'].dhcc-btn-blue").attr("id") //$("#EmAware").combobox("getValue");
	EmAware=EmAware==undefined?"":EmAware;
	
	/// 既往史
	var EmPatChkHisArr = [];
	$('input[name="EmPatChkHis"]:checked').each(function(){
		EmPatChkHisArr.push(this.value);
	})
	EmPatChkHis = EmPatChkHisArr.join("$$");
    //疼痛评级
	EmPainLev1=$("#EmPainLev").val();
	EmPainLev1=EmPainLev1==EmPainLev1?"":EmPainLev1;
	
	///  症状  单独计算
	var EmSymDesc = "";
		
	/// (2)生命数据
	var EmPcsTemp = $("#EmPcsTemp").val();      ///  体温
	var EmPcsHeart = $("#EmPcsHeart").val();    ///  心率
	var EmPcsSBP = $("#EmPcsSBP").val();        ///  血压(BP)收缩压
	var EmPcsDBP = $("#EmPcsDBP").val();
	var EmPcsSoP2 = $("#EmPcsSoP2").val();      ///  血氧饱合度SoP2
	var EmPcsPulse = $("#EmPcsPulse").val();    ///  脉搏 2016-12-06 congyue
	var EmPcsBreath = $("#EmPcsBreath").val();    ///  呼吸频率
	var EmPcsGLU = $("#EmPcsGLU").val();    ///  血糖
	var age=$("#empatage").val();            ///年龄
	var pGCS="";
	
	///荒诞值验证
	if(!valiAbsValue()){
		return ;	
	}
	
	if ((EmPcsTemp!="")||(EmPcsHeart!="")||(EmPcsSBP!="")||(EmPcsSoP2!="")||(EmPainLev1!="")||(EmSymDesc!="")||(EmAware!="")||(EmPcsPulse!="")||(age!="")||(EmPcsBreath!="")||(pGCS!="")){
		EmPcsListData = EmPcsSBP +"^"+ EmPcsSoP2 +"^"+ EmPcsHeart +"^"+ EmAware +"^"+ EmPatChkHis +"^"+ EmPcsTemp+"^"+EmSymDesc+"^"+EmPainLev1+"^"+EmPcsDBP+"^"+EmPcsPulse+"^"+age+"^"+EmPcsBreath+"^"+pGCS; //2016-12-06 cy 添加脉搏 EmPcsPulse
	}
	/// 系统推荐分级
	if(EmPcsListData!= ""){
			runClassMethod("web.DHCEMCalPatLevel","calPatLevel",{"EmPCLvID":EmPcsListData},function(jsonString){
				EmRecLevel=jsonString==null?"":jsonString
				insertAutoScore("SIGN",EmRecLevel,$g("生命体征分级"),"")
			},'',false)
	}
	
}


///取配置判断荒诞值
function valiAbsValue(){
	if(Object.keys(SignNormalObj).length>0){
		var itmInfo = "";
		var itmMinVal="";
		var itmMaxVal="";
		var EmPcsSBP = $("#EmPcsSBP").val();  ///收缩压
		EmPcsSBP = parseInt(EmPcsSBP);
		itmInfo = SignNormalObj.sysPressure; 
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsSBP!="")&&(itmMinVal!="")&&(EmPcsSBP<itmMinVal)){
				$.messager.alert("提示","收缩压值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!","info",function(){
					$("#EmPcsSBP").focus();	
				});
				$("#EmPcsSBP").val("");
				return false;
			} 
			
			if((EmPcsSBP!="")&&(itmMaxVal!="")&&(EmPcsSBP>itmMaxVal)){
				$.messager.alert("提示","收缩压值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!","info",function(){
					$("#EmPcsSBP").focus();	
				});
				$("#EmPcsSBP").val("");
				return false;
			}
		}
		
		var EmPcsDBP =  $("#EmPcsDBP").val();  ///舒张压
		EmPcsDBP = parseInt(EmPcsDBP);
		itmInfo = SignNormalObj.diaPressure;  //hxy 2020-06-18 add
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsDBP!="")&&(itmMinVal!="")&&(EmPcsDBP<itmMinVal)){
				$.messager.alert("提示","舒张压值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!","info",function(){
					$("#EmPcsDBP").focus();	
				});
				$("#EmPcsDBP").val("");
				return false;
			}
			
			if((EmPcsDBP!="")&&(itmMaxVal!="")&&(EmPcsDBP>itmMaxVal)){
				$.messager.alert("提示","舒张压值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!","info",function(){
					$("#EmPcsDBP").focus();	
				});
				$("#EmPcsDBP").val("");
				return false;
			}
		}
		
		
		var EmPcsSoP2 =  $("#EmPcsSoP2").val();  ///舒张压
		EmPcsSoP2 = parseInt(EmPcsSoP2);
		itmInfo = SignNormalObj.degrBlood;  
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsSoP2!="")&&(itmMinVal!="")&&(EmPcsSoP2<itmMinVal)){
				$.messager.alert("提示","血氧饱和浓度值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!","info",function(){
					$("#EmPcsSoP2").focus();	
				});
				$("#EmPcsSoP2").val("");
				return false; 
			}
			
			if((EmPcsSoP2!="")&&(itmMaxVal!="")&&(EmPcsSoP2>itmMaxVal)){
				$.messager.alert("提示","血氧饱和浓度值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!","info",function(){
					$("#EmPcsSoP2").focus();	
				});
				$("#EmPcsSoP2").val("");
				return false;
			}
		}
		
		
		var EmPcsBreath =  $("#EmPcsBreath").val();  ///呼吸频率
		EmPcsBreath = parseInt(EmPcsBreath);
		itmInfo = SignNormalObj.breath;  
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsBreath!="")&&(itmMinVal!="")&&(EmPcsBreath<itmMinVal)){
				$.messager.alert("提示","呼吸频率值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!","info",function(){
					$("#EmPcsBreath").focus();	
				});
				$("#EmPcsBreath").val("");
				return false;
			}
			
			if((EmPcsBreath!="")&&(itmMaxVal!="")&&(EmPcsBreath>itmMaxVal)){
				$.messager.alert("提示","呼吸频率值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!","info",function(){
					$("#EmPcsBreath").focus();	
				});
				$("#EmPcsBreath").val("");
				return false;
			}
		}
		
		var EmPcsTemp =  $("#EmPcsTemp").val();  ///体温
		EmPcsTemp = parseInt(EmPcsTemp);
		itmInfo = SignNormalObj.temperature;  
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsTemp!="")&&(itmMinVal!="")&&(EmPcsTemp<itmMinVal)){
				$.messager.alert("提示","体温值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!","info",function(){
					$("#EmPcsTemp").focus();	
				});
				$("#EmPcsTemp").val("");
				return false;
			}
			
			if((EmPcsTemp!="")&&(itmMaxVal!="")&&(EmPcsTemp>itmMaxVal)){
				$.messager.alert("提示","体温值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!","info",function(){
					$("#EmPcsTemp").focus();	
				});
				$("#EmPcsTemp").val("");
				return false;
			}
		}
		
		var EmPcsHeart =  $("#EmPcsHeart").val();  ///心律
		EmPcsHeart = parseInt(EmPcsHeart);
		itmInfo = SignNormalObj.heartbeat; 
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsHeart!="")&&(itmMinVal!="")&&(EmPcsHeart<itmMinVal)){
				$.messager.alert("提示","心率值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!","info",function(){
					$("#EmPcsHeart").focus();	
				});
				$("#EmPcsHeart").val("");
				return false;
			}
			
			if((EmPcsHeart!="")&&(itmMaxVal!="")&&(EmPcsHeart>itmMaxVal)){
				$.messager.alert("提示","心率值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!","info",function(){
					$("#EmPcsHeart").focus();	
				});
				$("#EmPcsHeart").val("");
				return false;
			}
		}
		
		var EmPcsPulse =  $("#EmPcsPulse").val();  ///脉搏
		EmPcsPulse = parseInt(EmPcsPulse);
		itmInfo = SignNormalObj.pulse; 
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsPulse!="")&&(itmMinVal!="")&&(EmPcsPulse<itmMinVal)){
				$.messager.alert("提示","脉搏值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!","info",function(){
					$("#EmPcsPulse").focus();	
				});
				$("#EmPcsPulse").val("");
				return false;
			}
			
			if((EmPcsPulse!="")&&(itmMaxVal!="")&&(EmPcsPulse>itmMaxVal)){
				$.messager.alert("提示","脉搏值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!","info",function(){
					$("#EmPcsPulse").focus();	
				});
				$("#EmPcsPulse").val("");
				return false;
			}
		}
		return true;
		
	}
		
}

///计算症状分级
function setSymLev(id,desc){
	EmPcsListData="^^^^^^"+desc+"^^^^^^"
	runClassMethod("web.DHCEMCalPatLevel","calPatLevel",{"EmPCLvID":EmPcsListData},function(jsonString){
				EmRecLevel=jsonString==null?"":jsonString
				insertAutoScore("SYM"+id,EmRecLevel,desc,"")
	},'',false)
}
function formatOp(code){	
 return "<span onClick='deleteRow(this,\""+code+"\")' ><img style='position: relative;left:2px' src='../scripts/dhcnewpro/images/grid_delete.png'></span>" //hxy add .png 2018-06-06	
}
function deleteRow(obj,code){
        index=parseInt($(obj).parent().parent().parent().attr('datagrid-row-index')); 
	    $.messager.confirm('提示', '确定要删除吗?', function(result){  
        	if(result) {
	        	$('#autoScoreDatagrid').datagrid('deleteRow', index);
				if("ESI"==code){
		        	$("#switchESI").attr("data-value","");
		        	$("#switchESI").removeClass('dhcc-btn-blue')
		        }
		       	if("PAIN"==code){
		        	$("#switchPAINLEV").attr("data-value","");
		        	$("#switchPAINLEV").removeClass('dhcc-btn-blue')
		        }
		        if("HURT"==code){
		        	$("#switchHURT").attr("data-value","");
		        	$("#switchHURT").removeClass('dhcc-btn-blue')
		        }
		        if("REMS"==code){
		        	$("#switchREMS").attr("data-value","");
					$("#switchGCS").attr("data-value","");
		        	$("#switchREMS").removeClass('dhcc-btn-blue')
		        }
		        if("MEWS"==code){
		        	$("#switchMEWS").attr("data-value","");
		        	$("#switchMEWS").removeClass('dhcc-btn-blue')
		        }
		        if("RTS"==code){
		        	$("#switchRTS").attr("data-value","");
		        	$("#switchRTS").removeClass('dhcc-btn-blue')
		        }
		        if("ISS"==code){
		        	$("#switchISS").attr("data-value","");
		        	$("#switchISS").removeClass('dhcc-btn-blue')
		        }
		        if("FRFA"==code){ //hxy 2022-08-17
		        	$("#switchFRFA").attr("data-value","");
		        	$("#switchFRFA").removeClass('dhcc-btn-blue')
		        }
		        if("ChestPain"==code){ //hxy 2022-08-18
		        	$("#switchChest").attr("data-value","");
		        	$("#switchChest").removeClass('dhcc-btn-blue')
		        }
		        
	        }else{
		    	return;
		    }
	    })
}
///读卡
function readCard(){
	runClassMethod ("web.DHCOPConfig","GetVersion",{},
		function(myVersion){
   			var CardTypeRowId = "";
			var CardTypeValue = $("#emcardtype").combobox("getValue");
			if (CardTypeValue != "") {
				var CardTypeArr = CardTypeValue.split("^");
				m_CCMRowID = CardTypeArr[14];
			}
			var rtn = DHCACC_GetAccInfo(m_CCMRowID, CardTypeValue);
			
   			var myary=rtn.split("^");
   			if (myary[0]!="0"){
	   			if((myary[1])&&(myary[1]!="undefined")){
		   			$.messager.confirm("提示:", "卡无效!是否为患者新建卡?", function (data) {
					    if (data) {
							$('#emcardno').val(myary[1]);
					    }else{
							return;    
						}
					});
		   		}else{
			   		$.messager.alert("提示","卡无效!");	
			   	}
	   		}
   			
			if ((myary[0]=="0")&&(myary[1]!="undefined")){
				$('#emcardno').val(myary[1]);
				//if(myary[3]!=undefined) SetPatInfoXml(myary[3]);
				GetValidatePatbyCard();
			}			
		},"text",false
	)
}

function SetPatInfoXml(XMLStr){
	var XMLStr = "<?xml version='1.0' encoding='gb2312'?>"+ XMLStr;
	var xmlDoc = $.parseXML(XMLStr);
	$xml = $(xmlDoc);
	var PatName = $xml.find("Name").text();	
	var Age = $xml.find("Age").text();	
	var SexID = $xml.find("Sex").text();
	var CredNo = $xml.find("CredNo").text();
	var NationDesc = $xml.find("NationDesc").text();
	var Address = $xml.find("Address").text();
	
	$("#empatname").val(PatName);
	$("#empatage").val(Age);
	$("#empatsex").combobox("setValue",SexID); 
	$("#emidentno").val(CredNo);
	$("#emaddress").val(Address);
	setEmBorth();   //设置出生日期
	return;
}


function M1Card_InitPassWord()
{
  try{
		var myobj=document.getElementById("ClsM1Card");
		if (myobj==null) return;
		var rtn=myobj.M1Card_Init();
  }catch(e){}
}
function GetValidatePatbyCard()
{
	
	var myCardNo = $('#emcardno').val();   //卡号
	 
	var SecurityNo=""
	var myExpStr=""
	var CardTypeRowId=""
	
	var CardTypeValue =$("#emcardtype").combobox("getValue");

	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardTypeRowId = CardTypeArr[0];
	}

	runClassMethod("web.DHCBL.CARDIF.ICardRefInfo","ReadPatValidateInfoByCardNo",
		{'CardNO':myCardNo,
		 'SecurityNo':SecurityNo,
		 'CardTypeDR':CardTypeRowId,   //全局变量
		 'ExpStr':myExpStr
		},
		function(data){
			
			if (data=="") { return;}
			var myary=data.split("^");
			if(myary[0]=="0"){
				CardSetPatInfo();
			}else if(myary[0]=="-341"){
				CardSetPatInfo();
			}else{
				switch(myary[0]){
					case "-340":
						$.messager.alert("提示","发卡时,此卡已经有对应的登记号了,不能在新增了");
						break;
					case "-350":
						$.messager.alert("提示","此卡已经使用,不能重复发卡!");
						break;
					case "-351":
						$.messager.alert("提示","此卡已经被挂失,不能使用!");
						break;
					case "-352":
						$.messager.alert("提示","此卡已经被作废?不能使用!");
						break;
					case "-356":
						$.messager.alert("提示","发卡时,配置要求新增卡记录,但是此卡数据被预先生成错误!");
						break;
					case "-357":
						$.messager.alert("提示","发卡时,配置要求更新卡记录,但是此卡数据没有预先生成!");
						break;
					case "-358":
						$.messager.alert("提示","发卡时,此卡已经有对应的登记号了,不能在新增了");
						break;
					default:
						$.messager.alert("Error Code:" +myary[0]);
						break;
				}
				
					
			}
			
		},"text",false
	)
}


function CardSetPatInfo(){
	var CardTypeInfo = $("#emcardtype").combobox("getValue");         /// 卡号类型
	var CardTypeInfoArr = CardTypeInfo.split("^");
	var CardTypeID=CardTypeInfoArr[0];
	runClassMethod("web.DHCEMPatientSeat","GetPatInfo",{'CardNo':$('#emcardno').val(),'RegNo':'',"CardTypeID":CardTypeID},
		function(myData){
			var myDataArr= myData.split("^");
			if(myDataArr[0]=="0"){
				$("#EmPatNo").val(myDataArr[2]);      /// 登记号;
				$("#PatientID").val(myDataArr[3]);  /// 病人ID
				GetEmRegPatInfo();
				return;
			}
		},"text"
	)	
}


/// 根据证件号获取病人ID
function GetPatientID(PatIdentNo){
	var PatientID = "";
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatientID",{"PatIdentNo":PatIdentNo},function(retData){
		if (retData != null){
			PatientID = retData.split("^")[0];
		}
	},'',false)
	return PatientID;
}
///congyue 2016-08-26  分诊挂号单打印
function LevPrintout() {
	
	var EmPCLvID = $("#EmPCLvID").val();  /// 2017-04-13 bianshuai 分诊ID
	if (EmPCLvID == ""){
		$.messager.alert("提示:","请先选中一条分诊数据！");
		return;
	}
	
	var PrintData="";
	var queDoc="";
	if(PATTYPE==1){
		queDoc=$('#queDoc').html();
	}
	
	/// 获取打印分诊数据
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmPatCheLevPriInfo",{"EmPCLvID":EmPCLvID,hospDr:LgHospID,queDoc:queDoc,PATTYPE:PATTYPE},function(jsonString){
		PrintData=jsonString
	},"",false)
	try {
		if (PrintData=="") return;
		
		var LODOP = getLodop();
		LODOP.PRINT_INIT("CST PRINT");
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_CheckLev");
		
		var PrintArr=PrintData.split("^");
		var PatientID=PrintArr[0];
		var PatNo=PrintArr[1];
		var PatCardNo=PrintArr[2];
		var PatName=PrintArr[3];
		var PatSex=PrintArr[4];
		var PatAge=PrintArr[5];
		var EmRecLevel=PrintArr[6];
		var EmNurseLevel=PrintArr[7];
		var EmDesc=""
		if(EmNurseLevel=="4级"){
			EmDesc="您的分级是Ⅳa级，我们将在60分钟给您处理！"
			}
		if(EmNurseLevel=="5级"){
			EmDesc="您的分级是Ⅳb级，我们将在120分钟给您处理！"
			}
		if(EmNurseLevel=="3级"){
			EmDesc="您的分级是Ⅲ级，我们将在30分钟给您处理！"
			}
		if(EmNurseLevel=="2级"){
			EmDesc="您的分级是Ⅱ级，我们将在10分钟给您处理！"
			}
		if(EmNurseLevel=="1级"){
			EmDesc="您的分级是Ⅰ级，我们将立即给您处理！"
			}
		var EmUpdLevRe=PrintArr[8];
		var EmLocDesc=PrintArr[9];
		var EmPatChkSign=PrintArr[10];
		var EmRegDate=PrintArr[11]; //登记日期
		var EmCreator=PrintArr[12];
		var PrintDate=PrintArr[13];
		var PrintTime=PrintArr[14];
		var EmRegTime=PrintArr[15]; //登记时间
		var CreateDate=PrintArr[16]; //分诊日期 2016-09-19
		var CreateTime=PrintArr[17]; //分诊时间 2016-09-19
		var EmAware=PrintArr[18]; //意识状态 2016-09-19
		var HospName = PrintArr[19];  //医院名称 QQA  2016-10-21
		var DontNo =PrintArr[20];
		var PatDob =PrintArr[21];
		var LocSeqNo = PrintArr[22];
		var GreFlag = PrintArr[23]; //绿色通道 hxy 2022-06-22
		///	 生命体征
		var flag="";
		var EmPcsTime="",EmPcsTemp="",EmPcsHeart="",EmPcsPulse="",EmPcsSBP="",EmPcsDBP="",EmPcsSoP2="",EmPcsR="";  
		var EmPcsTime1="",EmPcsTemp1="",EmPcsHeart1="",EmPcsPulse1="",EmPcsSBP1="",EmPcsDBP1="",EmPcsSoP21="",EmPcsR1="";  
		var EmPatChkSignArr = EmPatChkSign.split("#");
		for(var i=0;i<EmPatChkSignArr.length;i++){
			if (i==0){
				EmPcsArr = EmPatChkSignArr[i].split("@");
				EmPcsTime=EmPcsArr[0];   ///  时间
				EmPcsTemp=EmPcsArr[1];   ///  体温
				EmPcsHeart=EmPcsArr[2];  ///  心率
				EmPcsPulse=EmPcsArr[3];  ///  脉搏
				EmPcsSBP=EmPcsArr[4];    ///  血压(BP)收缩压
				EmPcsDBP=EmPcsArr[5];    ///  舒张压
				EmPcsSoP2=EmPcsArr[6];   ///  血氧饱合度SoP2
				EmPcsR = EmPcsArr[7]     ///  呼吸频率
				EmPcsGlu = EmPcsArr[8]
			}if (i!=0){
				EmPcsArr1= EmPatChkSignArr[i].split("@");
				EmPcsTime1=EmPcsArr1[0];   ///  时间
				EmPcsTemp1=EmPcsArr1[1];   ///  体温
				EmPcsHeart1=EmPcsArr1[2];  ///  心率
				EmPcsPulse1=EmPcsArr1[3];  ///  脉搏
				EmPcsSBP1=EmPcsArr1[4];    ///  血压(BP)收缩压
				EmPcsDBP1=EmPcsArr1[5];    ///  舒张压
				EmPcsSoP21=EmPcsArr1[6];   ///  血氧饱合度SoP2
				EmPcsR1 = EmPcsArr[7]       ///  呼吸频率
				EmPcsGlu1=EmPcsArr[8]
			}
		}
		EmNurseLevel=setCellLabelLev(EmNurseLevel) //hxy 2020-02-20
		var MyPara="HospName"+String.fromCharCode(2)+HospName+"^"+"PatNo"+String.fromCharCode(2)+PatNo+"^"+"PatName"+String.fromCharCode(2)+PatName+"^"+"PatCardNo"+String.fromCharCode(2)+PatCardNo+"^"+"PatSex"+String.fromCharCode(2)+PatSex+"^"+"PatAge"+String.fromCharCode(2)+PatAge;
		var MyPara=MyPara+"^"+"EmNurseLevel"+String.fromCharCode(2)+EmNurseLevel+"^"+"EmLocDesc"+String.fromCharCode(2)+EmLocDesc+"^"+"DontNo"+String.fromCharCode(2)+DontNo+"^"+"EmCreator"+String.fromCharCode(2)+EmCreator+"^"+"CreateDate"+String.fromCharCode(2)+CreateDate+" "+CreateTime;
		var MyPara=MyPara+"^"+"EmAware"+String.fromCharCode(2)+EmAware+"^"+"PrintDate"+String.fromCharCode(2)+PrintDate+" "+PrintTime;       
		var MyPara=MyPara+"^"+"EmPcsTemp"+String.fromCharCode(2)+EmPcsTemp+"^"+"EmPcsHeart"+String.fromCharCode(2)+EmPcsHeart;
		var MyPara=MyPara+"^"+"EmPcsPulse"+String.fromCharCode(2)+EmPcsPulse+"^"+"EmPcsSBP"+String.fromCharCode(2)+EmPcsSBP+"^"+"EmPcsDBP"+String.fromCharCode(2)+EmPcsDBP+"^"+"EmPcsSoP2"+String.fromCharCode(2)+EmPcsSoP2;
		var MyPara=MyPara+"^"+"EmPcsR"+String.fromCharCode(2)+EmPcsR+"^"+"EmPcsTime"+String.fromCharCode(2)+EmPcsTime+"^"+"PatDob"+String.fromCharCode(2)+PatDob
		var MyPara=MyPara+"^"+"EmPcsGlu"+String.fromCharCode(2)+EmPcsGlu
		var MyPara=MyPara+"^"+"GreFlag"+String.fromCharCode(2)+GreFlag;
		//DHCP_PrintFunHDLP(myobj,MyPara,"");
		DHC_CreateByXML(LODOP,MyPara,"",[],"PRINT-CST-NT");  //MyPara 为xml打印要求的格式
		var printRet = LODOP.PRINT();
	} catch(e) {alert(e.message)};
}
function GetSym(e){
	if(e.keyCode == 13){
		
		url='dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonEmPatSymptomLev&q='+$("#symFilter").val()
		$('#symLevTree').tree('options').url =encodeURI(url);
		$('#symLevTree').tree('reload');
	}
}
///  登记号回车
function GetEmPatInfo(e){
	 if(e.keyCode == 13){
		PatRegNoEnter();
	}
}

function PatRegNoEnter(){
	var EmPatNo = $("#EmPatNo").val();
	var CurCardNo = $("#emcardno").val();
	var CurCardID = $("#emcardtype").combobox("getValue");
	var CurPatientID = $("#PatientID").val();       /// PatientID
	initDefaultValue();   //初始化数据
	var EmPatNo = GetWholePatNo(EmPatNo);
	$("#EmPatNo").val(EmPatNo);
	runClassMethod("web.DHCEMPatCheckLevCom","CheckPatNo",{"EmPatNo":EmPatNo},function(jsonString){
		if (jsonString ==-1){
			$.messager.alert("提示:","当前登记号无病人信息,请重试！");
			return;
		}else{
			GetEmRegPatInfo();
		}

	},'text',false)	
}
/// 获取病人信息
function GetEmRegPatInfo(){
	var EmPatNo = $("#EmPatNo").val();      /// 登记号;
	var PatientID = $("#PatientID").val();  /// 病人ID
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmRegPatInfo",{"EmPatNo":EmPatNo,"PatientID":PatientID},function(jsonString){
		
		if (jsonString != null){
			var rowData = jsonString;
			setRegPanelInfo(rowData,0);
		}
	},'json',false)
}
///  卡号回车
function GetEmPatInfoByCardNo(e){

	if(e.keyCode == 13){
		var CardNo = $("#emcardno").val();
		var CardNoLen = CardNo.length;
		if((m_CardNoLength!="")&&(m_CardNoLength!=0)){
			if (m_CardNoLength < CardNoLen){
				$.messager.alert("提示:","卡号输入错误,请重新录入！");
				return;
			}

			/// 卡号不足位数时补0
			for (var k=1;k<=m_CardNoLength-CardNoLen;k++){
				CardNo="0"+CardNo;  
			}
		}
		var CardTypeInfo = $("#emcardtype").combobox("getValue");         /// 卡号类型
		var CardTypeInfoArr = CardTypeInfo.split("^");
		var CardTypeID=CardTypeInfoArr[0];
		
		/// 先通过卡号获得病人信息，如果卡号已经绑定病人，则加载病人信息，无绑定信息相当于读空白卡
		///  根据卡号取登记号
		var EmPatNo = "";
		runClassMethod("web.DHCEMPatCheckLevCom","GetPmiNoFrCardNo",{"cardno":CardNo,"typeID":CardTypeID},function(jsonString){

			if (jsonString ==-1){
				$.messager.alert("提示:","当前卡无效,请重试！");
				return;

			}else{
				var CurEmPatNo = $("#EmPatNo").val();
				EmPatNo = jsonString;
				if((EmPatNo=="")&&(CurEmPatNo!="")){  ///输入卡为新卡，并且界面已经带入了病人信息
					initDefaultValue();	
					$("#emcardno").val(CardNo);	
				}else{
					$("#emcardno").val(CardNo);	
				}
				$("#EmPatNo").val(EmPatNo);
			}
			
		},'text',false)
	
		if(EmPatNo=="") return;
		initDefaultValue();				///  清空
		$("#EmPatNo").val(EmPatNo);		/// 登记号
		GetEmRegPatInfo();
	}
}


function uploadImg(){
	var EmPCLvID = $("#EmPCLvID").val();   			/// 分诊ID
	var lnk = "dhcem.uploadify.csp?EmPCLvID="+EmPCLvID;
	//var openCss = 'width='+(window.screen.availWidth)+',height='+(window.screen.availHeight-100)+ ', top=100, left=0, location=no,toolbar=no, menubar=no, scrollbars=no, resizable=no,status=no'
	//window.open(lnk,'newwindow',openCss);
	
	websys_showModal({
		url: lnk,
		iconCls:"icon-w-paper",
		title: $g('上传查看图片'),
		closed: true,
		onClose:function(){}
	});
	
}


function GroupHurtReg(){
	var EmPCLvID = $("#EmPCLvID").val();   			/// 分诊ID
	var lnk = "dhcem.grouppat.csp?EmPCLvID="+EmPCLvID;
	//var openCss = 'width='+(window.screen.availWidth)+',height='+(window.screen.availHeight-100)+ ', top=100, left=0, location=no,toolbar=no, menubar=no, scrollbars=no, resizable=no,status=no'
	//window.open(lnk,'newwindow',openCss)
	
	websys_showModal({
		url: lnk,
		height:window.screen.availHeight-100,
		iconCls:"icon-w-paper",
		title: $g('群伤患者录入'),
		closed: true,
		onClose:function(){}
	});
}

///  设置病人基本信息
function setEmPatBaseInfo(PatIdentNo){
	
	var PCLRowID = $("#EmPCLvID").val();
	if(PCLRowID!="") return;			///左侧面板选中带入,不需再次带入
	
	if (!$("#emidentno").validatebox('isValid')){
		return;
	}
	if (PatIdentNo != ""){
		runClassMethod("web.DHCEMPatCheckLevCom","GetPatientID",{"PatIdentNo":PatIdentNo},function(jsonString){
			if (jsonString != null){
				if(jsonString.indexOf("^")!=-1){
					openMorePatSelect(PatIdentNo);
					return;
				}
				var PatientID = jsonString
				setPatMesByIdCard(PatientID);
			}
		},'',false)
	}
}

function setPatMesByIdCard(PatientID){
	if (PatientID != ""){
		var EmCardNo = $("#emcardno").val();
		var mPatientID = $("#PatientID").val();
		if (PatientID == mPatientID) return;
		$("#PatientID").val(PatientID);
		GetEmRegPatInfo();
	}else{
		setEmBorth();
	}
	return;
}


///  设置出生日期
function setEmBorth(){
	
	if (!$("#emidentno").validatebox('isValid')){
		return;
	}
	var d;
	var value = $("#emidentno").val();
	var number = value.toLowerCase();
	var re = number.match(/^(\d{2})\d{4}(((\d{2})(\d{2})(\d{2})(\d{3}))|((\d{4})(\d{2})(\d{2})(\d{3}[x\d])))$/);
	if (re == null) return false;
	if (re[2].length == 9) {
		number = number.substr(0, 6) + '19' + number.substr(6);
		d = ['19' + re[4], re[5], re[6]].join('-');
	} else{
		d = [re[9], re[10], re[11]].join('-');
	}
	//$("#empatage").val(jsGetAge(d)+"岁")  //setEmPatAges(d)); /// 年龄：不根据这个计算，只能精确到年
	d = GetSysDateToHtml(d)    /// 根据His系统配置转换日期格式
	$("#emborth").val(d);      /// 出生日期
	blurBrith();  			   /// 设置年龄：通过出生日期设置
	/// 设置性别
	if (parseInt(value.substr(16, 1)) % 2 == 1) {
		$("#empatsex").combobox("setValue",TransPatSexToID("男"));
	}else{ 
		$("#empatsex").combobox("setValue",TransPatSexToID("女"));
	}
}

function PatCheckByGroup(GroupPatReg){
	$("#EmPatNo").val(GroupPatReg);
	GetEmPatInfoEnter();
	websys_showModal("close");
	return;
}

/// 取His日期维护显示格式 bianshuai 2017-03-10
function GetSysDateToHtml(HtDate){

	runClassMethod("web.DHCAPPExaRepCom","GetSysDateToHtml",{"HtDate":HtDate},function(jsonString){
		HtDate = jsonString;
	},'',false)
	return HtDate;
}

function jsGetAge(strBirthday)
{    
	var bDay = new Date(strBirthday),
	nDay = new Date(),
	nbDay = new Date(nDay.getFullYear(),bDay.getMonth(),bDay.getDate()),
	age = nDay.getFullYear() - bDay.getFullYear();
	if (bDay.getTime()>nDay.getTime()) {return '日期有错'}
	return nbDay.getTime()<=nDay.getTime()?age:--age;  
}
function clearNoNum(obj){ 
    obj.value = obj.value.replace(/[^\d.]/g,"");  //清除“数字”和“.”以外的字符  
    obj.value = obj.value.replace(/\.{2,}/g,"."); //只保留第一个. 清除多余的  
    obj.value = obj.value.replace(".","$#$").replace(/\./g,"").replace("$#$","."); 
    obj.value = obj.value.replace(/^(\-)*(\d+)\.(\d\d).*$/,'$1$2.$3');//只能输入两个小数  
    if(obj.value.indexOf(".")< 0 && obj.value !=""){//以上已经过滤，此处控制的是如果没有小数点，首位不能为类似于 01、02的金额 
        obj.value= parseFloat(obj.value); 
    } 
}
function setModifyPat(flag){
	
	if(MODIFYPAT==1){
		return;	
	}
	
	$("#emaddress").attr("disabled",flag);
	$("#emfamtel").attr("disabled",flag);
	$("#emidentno").attr("disabled",flag);
	$("#emborth").attr("disabled",flag);
	$("#marital").attr("disabled",flag);
	$("#religion").attr("disabled",flag);
	$("#occupation").attr("disabled",flag);
	$("#healthCareNo").attr("disabled",flag);
	
	
	$("#empatage").attr("disabled",flag);
	$("#empatname").attr("disabled",flag);
	$("#EmPatNo").attr("disabled",flag);
	
	$("#emcardno").attr("disabled",flag);	
	
	if(flag){
		$("#emnation").combobox("disable");
		$("#emcountry").combobox("disable");
		$("#empatsex").combobox("disable");
		$("#patCertType").combobox("disable");
		$("#patSocailType").combobox("disable");
		$("#emcardtype").combobox("disable");
	}else{
		$("#emnation").combobox("enable");
		$("#emcountry").combobox("enable");
		$("#empatsex").combobox("enable");
		$("#patCertType").combobox("enable");
		$("#patSocailType").combobox("enable");
		$("#emcardtype").combobox("enable");
	}
}


function inGroupPat(RegNo){
	websys_showModal("close");
	$("#EmPatNo").val(RegNo);
	PatRegNoEnter();
	return;
}

///重写身份证验证方式
$.extend($.fn.validatebox.defaults.rules, {
	idcard: {
	    validator: function (value, param) {
	       	var idCardType=	$('#patCertType').combobox("getText")
	    	if(idCardType.indexOf("居民身份证")==-1){
		    	return true;
		    }   	
		    
	        return idCard(value);
	    },
	    message:'请输入正确的身份证号码'
	} 
})

///打印腕带
function Prt_WCinctureo() {
	var EmPCLvID = $("#EmPCLvID").val();  /// 2017-04-13 bianshuai 分诊ID
	if (EmPCLvID == ""){
		$.messager.alert("提示:","请先选中一条分诊数据！");
		return;
	}
	newProPrtWd(EmPCLvID,"",LgHospID);
	return ;
}



//血压值 接口
function getDevData(){
	var rtn=serverCall("web.DHCEMPatCheckLev","GetDevDataInterface",{"IPAdress":ComputerIp})
	$("#EmPcsSBP").val(rtn.split("^")[0]) //收缩压
	$("#EmPcsDBP").val(rtn.split("^")[1])	//舒张压
	$("#EmPcsHeart").val(rtn.split("^")[2]) //心率
}

///判断元素是否三无患者
function getEmPatType(){
	var ret="";
	$('input[name="EmPatChkType"]:checked').each(function(){
		if ($(this).attr("label") == $g("三无人员")){ ret = this.value;} //hxy 2022-12-08 $g		
	})
	return ret;
}

//hxy 2020-02-19
function setCellLabelLev(value){
	if(value=="1"){value="Ⅰ";}
	if(value=="2"){value="Ⅱ";}
	if(value=="3"){value="Ⅲ";}
	if(value=="4"){value="Ⅳa";}
	if(value=="5"){value="Ⅳb";}
	if(value=="1级"){value=$g("Ⅰ级");}
	if(value=="2级"){value=$g("Ⅱ级");}
	if(value=="3级"){value=$g("Ⅲ级");}
	if(value=="4级"){value=$g("Ⅳa级");}
	if(value=="5级"){value=$g("Ⅳb级");}
	return value;
}

//重大事件
function GroupReg(){
	var PatientID = $("#PatientID").val();   		/// PatientID
	//alert(PatientID)
	var lnk = "dhcem.grouppatmajor.csp?PatientID="+PatientID;
	//var openCss = 'width='+(window.screen.availWidth)+',height='+(window.screen.availHeight-100)+ ', top=100, left=0, location=no,toolbar=no, menubar=no, scrollbars=no, resizable=no,status=no'
	//window.open(lnk,'newwindow',openCss)
	
	websys_showModal({
		url: lnk,
		height:600,
		iconCls:"icon-w-paper",
		title: $g('事件患者关联'),
		closed: true,
		onClose:function(){}
	});
}

//二次干预
function newSign(){ //EmPCLvIDSave

	var EmPCLvIDSave=$("#EmPCLvID").val();  //hxy 2020-03-26 add

	// 判断有木有id
	if ((EmPCLvIDSave == "")||(EmPCLvIDSave == undefined)){
		$.messager.alert('提示',"请选择已分诊患者!","warning");
		return;
	}
	
	var lnk = "dhcem.patchksign.csp?EmPCLvID="+EmPCLvIDSave;
	websys_showModal({
		url: lnk,
		width:1000,
		height:550,
		iconCls:"icon-w-paper",
		title: $g('干预措施'),
		closed: true,
		onClose:function(){}
	});
}

/**
 *  修改挂号时间 bianshuai 2020-03-18
 */
function modRegTime(){
	
	var row = $HUI.datagrid('#dgEmPatList').getSelected();
	if (row == null){
		$.messager.alert("提示:","请先选择病人！","warning");
		return;
	}
	var EpisodeID = $("#Adm").val();             /// 就诊ID
	if (EpisodeID == ""){
		$.messager.alert("提示:","病人未挂号！","warning");
		return;
	}
	
	/*commonShowWin({ //hxy 2020-03-24 st
		url:"dhcem.patregtime.csp?EpisodeID="+ EpisodeID,
		title:"修改挂号时间",
		width: 400,
		height: 310
	})*/
	var lnk = "dhcem.patregtime.csp?EpisodeID="+EpisodeID;
	websys_showModal({
		url: lnk,
		width:400,
		height:167,
		iconCls:"icon-w-paper",
		title: $g('修改挂号时间'),
		closed: true,
		onClose:function(){}
	}); //edds
}

///RTS评分
function openScoreScaleWin(_this){
	var thisID=_this.id;
	var ScoreCode=_this.getAttribute("scoreType");
	var ScoreName = _this.textContent;
	var RelListData = {
		"sbp":	$("#EmPcsSBP").val(),
		"breath": $("#EmPcsBreath").val()
	}
	var lnk ="dhcemc.scoretabreview.csp?ScoreCode="+ScoreCode+"&EditFlag=3&CheckMasID="+thisID+"&RelListData="+encodeURIComponent(JSON.stringify(RelListData));
	websys_showModal({
		url: lnk,
		iconCls:"icon-w-paper",
		title: ScoreName,
		closed: true,
		onClose:function(){}
	});
}


function loadingShowOrHide(mode){
	if(mode=="hide"){
		$("#Loading").fadeOut("fast");	
	}else{
		$("#Loading").fadeIn("fast");	
	}
}

function validLocRequire(){
	var emLocId = $('#EmLocID').combobox('getValue');
	if(!emLocId) return '';
	
	var emLocList=$('#EmLocID').combobox('getData');
	var checkedData="";
	for(var index in emLocList){
		emLocList[index].value==emLocId?checkedData=emLocList[index]:'';
	}
	if(!checkedData) return '';

	var ageFrom=checkedData.ageFrom;
	var ageTo=checkedData.ageTo;
	var wardSingleSex=checkedData.wardSingleSex;
	var wardSingleSexDesc=checkedData.wardSingleSexDesc;
	var empatage=ageYear($('#empatage').val()); ///需要特殊处理
	var empatsex=$('#empatsex').combobox('getValue');
	var ret="";
	if(wardSingleSex&&(wardSingleSex!=empatsex)) ret='性别限制,科室要求性别为<span style="color:red">'+wardSingleSexDesc+'<span>!';
	if(ret) return ret;
	
	if(ageFrom&&(empatage<ageFrom)) ret='最小年龄限制,科室要求年龄范围<span style="color:red">'+ageFrom+'-'+ageTo+'<span>!';
	if(ret) return ret;
	
	if(ageTo&&(empatage>ageTo)) ret='最大年龄限制,科室要求年龄范围<span style="color:red">'+ageFrom+'-'+ageTo+'<span>!';
	return ret;
}

function ageYear(ageStr){
	var retAge='';
	if(ageStr.indexOf('岁')!=-1){
		retAge=parseInt(ageStr);	
	}else if(ageStr==parseInt(ageStr)){
		retAge=parseInt(empatage);
	}else{
		retAge=0;
	}
	return retAge;
}

/// 勾选三无
function CheckThree(){
	$HUI.radio('input[label^="三无"]').setValue(true);
}

function GetErrMsg(ErrCode){
	ErrCode = ErrCode.split("||")[0];
	var errmsg="";
	if (ErrCode=="-201")  errmsg="生成就诊记录失败!";
	if (ErrCode=="-202")  errmsg="取号不成功!";
	if (ErrCode=="-2121") errmsg="更新预约状态失败!";
	if (ErrCode=="-2122") errmsg="系统忙,请稍后重试!";
	if (ErrCode=="-206")  errmsg="插入挂号费医嘱失败!";
	if (ErrCode=="-207")  errmsg="插入诊查费医嘱失败!";
	if (ErrCode=="-208")  errmsg="插入假日费医嘱失败!";
	if (ErrCode=="-209")  errmsg="插入预约费医嘱失败!";
	if (ErrCode=="-210")  errmsg="计费失败!";
	if (ErrCode=="-211")  errmsg="插入挂号记录失败!";
	if (ErrCode=="-212")  errmsg="插入叫号队列失败!";
	if (ErrCode=="-301")  errmsg="超过每人每天可挂限额,不能再挂号或预约!";
	if (ErrCode=="-302")  errmsg="超过每人每天可挂相同号的限额!";
	if (ErrCode=="-303")  errmsg="超过每人每天可挂相同科室号的限额!";
	if (ErrCode=="-401")  errmsg="还没有到挂号时间!";
	if (ErrCode=="-402")  errmsg="还未到预约时间!";
	if (ErrCode=="-403")  errmsg="还未到加号时间!";
	if (ErrCode=="-404")  errmsg="已经过了此排班记录出诊时间点!";
	if (ErrCode=="-2010") errmsg="更新医保挂号信息失败!";
	if (ErrCode=="-304")  errmsg="超过每人每天相同时段同科室同医生限额!";
	if (ErrCode=="-405")  errmsg="请去挂号设置界面维护免费医嘱!";
	if (ErrCode=="-406")  errmsg="已过挂号结束时间!";
	if (ErrCode=="-213")  errmsg="已经开启停止挂号,不予许挂号及取号";
	return errmsg;
}
