/*
 *模块:			门诊药房
 *子模块:		门诊药房-草药处方发药
 *createdate:	2018-07-01
 *creator:		hulihua
*/
DHCPHA_CONSTANT.DEFAULT.PHLOC="";
DHCPHA_CONSTANT.DEFAULT.PHPYUSER="";
DHCPHA_CONSTANT.DEFAULT.PHUSER="";
DHCPHA_CONSTANT.DEFAULT.PHWINDOW="";
DHCPHA_CONSTANT.DEFAULT.CYFLAG="Y";
DHCPHA_CONSTANT.VAR.OUTPHAWAY=tkMakeServerCall("web.DHCSTCNTSCOMMON","GetWayIdByCode","OA")
DHCPHA_CONSTANT.DEFAULT.APPTYPE="OR";
DHCPHA_CONSTANT.URL.THIS_URL=ChangeCspPathToAll("dhcpha.outpha.outmonitor.save.csp");
var COOKTYPEDr = "";
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
$(function(){
	CheckPermission();	
	var ctloc=DHCPHA_CONSTANT.DEFAULT.LOC.text;
	$("#currentctloc").text(ctloc)
	/* 初始化插件 start*/
	var daterangeoptions={
		singleDatePicker:true
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);
	var tmpstartdate=FormatDateT("t-2")
	//$("#date-start").data('daterangepicker').setStartDate(tmpstartdate);
	//$("#date-start").data('daterangepicker').setStartDate(tmpstartdate);
	
	InitGridDisp();	
	/* 表单元素事件 start*/
	//登记号回车事件
	$('#txt-patno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txt-patno").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				QueryGridDisp();
			}
			ChkUnFyOtherLoc();	
		}
	});
	
	//卡号回车事件
	$('#txt-cardno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var cardno=$.trim($("#txt-cardno").val());
			if (cardno!=""){
				BtnReadCardHandler();	
			}
			ChkUnFyOtherLoc();
			SetFocus();	
		}
	});
	
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	$("#txt-cardno").focus();
	/* 表单元素事件 end*/
	/* 绑定按钮事件 start*/
	$("#btn-change").on("click",function(){
		$("#modal-windowinfo").modal('show');
	});
	$("#btn-reffy").on("click",ExecuteRefuseFY);
	$("#btn-cancelreffy").on("click",CancelRefuseFY);
	$("#btn-readcard").on("click",BtnReadCardHandler); //读卡
	/* 绑定按钮事件 end*/
	/*加载处方修改模态框及部分事件 */
	InitPrescModify();
	$("#sel-cmbMakeMedthod").change(function(){
		var PrescConfigId=$("#sel-cmbMakeMedthod").val();
		InitPhcInstruc(PrescConfigId);
	});
	$("#sel-cmbPhcInstruc").change(function(){
		var phcInstr=$("#sel-cmbPhcInstruc").val();
		InitPrescOrderQty(phcInstr);	
	});
	showModifyDeatil();
	showAddMaterial();
	$('#btn-modifySubmit').on("click",savePrescModified);
	$("#btn-modalclose").on("click",closeAddPrescModal);
	InitBodyStyle();
	HotKeyInit("CMPrescDisp","grid-disp");	//快捷键
})

//载入数据
window.onload=function(){
	if (LoadPatNo!=""){
		$('#txt-patno').val(LoadPatNo);
	}
	setTimeout("QueryGridDisp()",500);
}

//初始化处方修改模态框控件
function InitPrescModify(){
	InitPhcInstruc();
	InitPhcDuration();
	InitPHCFreq();
	InitMakeMedthod();
	InitPrescOrderQty();
}
// 药品特殊煎法明细
function showModifyDeatil(){
	$("#grid-dispdetail tr").empty();
	$('#prescModal').on('show.bs.modal', function () {
  		 InitModifyDeatil();
  		//InitPrescModalStyle();
	});
	$('#prescModal').on('hide.bs.modal', function () {
  		closeAddPrescModal();
	});	
}
//补录煎药费的附加材料
function showAddMaterial(){
	$("#grid-materialtail tr").empty();
	$('#AddMaterialModal').on('hide.bs.modal', function () {
  		$("#prescModal").removeData('bs.modal');
		$("#grid-materialtail tr").empty();
	});
	
}
//链接退药
function ReturnDisp(){
	//var lnk="dhcpha/dhcpha.outpha.return.csp";
  
	//var lnk="dhcpha.outpha.return.csp";
	//window.open(lnk,"_target","width="+(window.screen.availWidth-50)+",height="+(window.screen.availHeight-100)+ ",left=0,top=0,menubar=no,status=yes,toolbar=no,resizable=yes") ;
	//该界面有可能草药发药 ，也可能消息需处理的草药发药界面。调用csp的判读层次不一致  改为下面
	$.ajax({
        type: "GET",
        cache: false,
        url: "dhcpha/dhcpha.outpha.return.csp",
        data: "",
        success: function() {
	        var lnk="dhcpha/dhcpha.outpha.return.csp";
            window.open(lnk,"_target","width="+(window.screen.availWidth-50)+",height="+(window.screen.availHeight-100)+ ",left=0,top=0,menubar=no,status=yes,toolbar=no,resizable=yes") ;

        },
        error: function() {
            var lnk="dhcpha.outpha.return.csp";
            window.open(lnk,"_target","width="+(window.screen.availWidth-50)+",height="+(window.screen.availHeight-100)+ ",left=0,top=0,menubar=no,status=yes,toolbar=no,resizable=yes") ;

        }
    });
}


//初始化发药table
function InitGridDisp(){
	var columns=[
		{header:'发药状态',index:'TDspStatus',name:'TDspStatus',width:65,cellattr: addPhDispStatCellAttr},
		{header:'是否加急',name:"TEmergFlag",index:"TEmergFlag",width:70,
			formatter: function(value, options, rowdata){
				if(value == "Y"){
					return "是";	
				}else{
					return "否";	
				}
			}
		},
		{header:'姓名',index:'TPatName',name:'TPatName',width:100},
		{header:'登记号',index:'TPmiNo',name:'TPmiNo',width:100},
		{header:'发药',index:'TFyFlag',name:'TFyFlag',width:40,hidden:true},
		{header:'处方号',index:'TPrescNo',name:'TPrescNo',width:120},
		{header:'处方剂型',index:"TPrescType",name:"TPrescType",width:80},
		{header:'付数',index:"TDuration",name:"TDuration",width:80,hidden:true},
		{header:'煎药方式',index:"TCookType",name:"TCookType",width:60},
		{header:'煎药费/申请状态',index:"TCookCost",name:"TCookCost",width:110,align:'left'},
		{header:'费别',index:"TBillType",name:"TBillType",width:60},
		{header:'诊断',index:'TMR',name:'TMR',width:300,align:'left'},
		//鉴于现在标库上还没有慢病诊断录入的地方，经与测试组沟通后暂时先隐藏此列信息 MaYuqiang 20200320
		{header:'慢病诊断',index:'TMBDiagnos',name:'TMBDiagnos',width:150,align:'left',hidden:true},
		{header:'性别',index:'TPatSex',name:'TPatSex',width:40},
		{header:'年龄',index:'TPatAge',name:'TPatAge',width:40},
		{header:'科室',index:'TPatLoc',name:'TPatLoc',width:100},
		{header:'先发标志',index:'TPayDispFlag',name:'TPayDispFlag',width:70,
			formatter: function(value, options, rowdata){
				if(value == "Y"){
					return "是";	
				}else{
					return "否";	
				}
			}
		},
		{header:'手工方',name:"THandMadeFlag",index:"THandMadeFlag",width:80,hidden:true},
		{header:'付数',name:"TDuration",index:"TDuration",width:70,hidden:true},
		{header:'拒绝发药理由',name:"TRefResult",index:"TRefResult",width:300,align:'left'},
		{header:'拒绝发药申诉理由',name:"TDocNote",index:"TDocNote",width:300,align:'left'},
		{header:'TAdm',index:'TAdm',name:'TAdm',width:60,hidden:true},
		{header:'TPapmi',index:'TPapmi',name:'TPapmi',width:60,hidden:true},
		{header:'TPatLoc',index:'TPatLoc',name:'TPatLoc',width:60,hidden:true},
		{header:'Tphd',index:'Tphd',name:'Tphd',width:60,hidden:true},
		{header:'TOeori',index:'TOeori',name:'TOeori',width:60,hidden:true},
		{header:'病人密级',index:'TEncryptLevel',name:'TEncryptLevel',width:70,hidden:true},
		{header:'病人级别',index:'TPatLevel',name:'TPatLevel',width:70,hidden:true}
	]; 
	var jqOptions={
		datatype:'local',
		colModel: columns, //列
		url:ChangeCspPathToAll(LINK_CSP)+'?ClassName=PHA.OP.HMDisp.Query&MethodName=jsQueryPrecsCheckDispList&style=jqGrid', //查询后台	
		height: DhcphaJqGridHeight(1,3)+26,
		shrinkToFit: false,
		pager: "#jqGridPager", 	//分页控件的id
		rownumbers: true,
		viewrecords: true,
		onSelectRow:function(id,status){
			QueryGridDispSub();
			/**
			手工方补录由于标库未启用，暂注释
			var selrowdata = $("#grid-disp").jqGrid('getRowData', id);
			var handmadeflag=selrowdata.THandMadeFlag;
			var dispstatus=selrowdata.TDspStatus; 
			if(handmadeflag=="1"){			//&&((dispstatus=="")||(dispstatus==null)))
				$("#grid-dispdetail").empty();	//清空模态框table 
				InitPrescModify();
				$('#prescModal').modal('show');
			}**/
	},
	loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#ifrm-presc").attr("src","");
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
	};
	$("#grid-disp").dhcphaJqGrid(jqOptions);
}

//查询发药列表
function QueryGridDisp(){
 	var stdate = $("#date-start").val();
	var enddate = $("#date-end").val();
 	var phalocid=DHCPHA_CONSTANT.DEFAULT.LOC.id;
	var chkdisp="";
	if($("#chk-disp").is(':checked')){
		chkdisp="Y";
	}else{
	    chkdisp="";
	}
	var patno=$("#txt-patno").val();
	var params=stdate+"^"+enddate+"^"+phalocid+"^"+patno+"^"+chkdisp+"^"+DHCPHA_CONSTANT.DEFAULT.PHLOC;		
	$("#grid-disp").setGridParam({
		datatype:'json',
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
	$("#ifrm-presc").attr("src","");
}
//查询发药明细
function QueryGridDispSub(){
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	var prescno=selrowdata.TPrescNo;
	var cyflag=DHCPHA_CONSTANT.DEFAULT.CYFLAG;
	var phartype="DHCOUTPHA";
	var paramsstr=phartype+"^"+prescno+"^"+cyflag;
	$("#ifrm-presc").attr("src",ChangeCspPathToAll("dhcpha/dhcpha.common.prescpreview.csp")+"?paramsstr="+paramsstr+"&PrtType=DISPPREVIEW");
}

//执行全发
function ExecuteAllFY(){	
    var fyrowdata = $("#grid-disp").jqGrid('getRowData');
	var fygridrows=fyrowdata.length;
	if (fygridrows<=0){
		dhcphaMsgBox.alert("处方列表没有数据!");
		return;
	}
	dhcphaMsgBox.confirm("确认全发吗?系统将全部发放查询出的所有处方!",ConfirmDispAll);
}

function ConfirmDispAll(result){
	if (result==true){
		var chkdisp="";
		if($("#chk-disp").is(':checked')){
			chkdisp="Y";
		}else{
		    chkdisp="";
		}
		if(chkdisp=="Y"){
			dhcphaMsgBox.alert("检索为已发药数据,不能发药!");
	    	return;
		}
		var fyrowdata = $("#grid-disp").jqGrid('getRowData');
		var fygridrows=fyrowdata.length;
		for(var rowi=1;rowi<=fygridrows;rowi++){
			DispensingMonitor(rowi);		
		} 
	}
	QueryGridDisp();
}

// 执行发药
function ExecuteFY(){
	if (DhcphaGridIsEmpty("#grid-disp")==true){
		return;
	}
	var selectid=$("#grid-disp").jqGrid('getGridParam','selrow');
	if (selectid==null){
	    dhcphaMsgBox.alert("没有选中数据,不能发药!");
	    return;
	}
	DispensingMonitor(selectid);
	//刷新查询
	QueryGridDisp();
}

function DispensingMonitor(rowid){
	
	var selrowdata = $("#grid-disp").jqGrid('getRowData', rowid);
	var prescno=selrowdata.TPrescNo;
	var fyflag=selrowdata.TFyFlag;
	var patname=selrowdata.TPatName;
	var warnmsgtitle="病人姓名:"+patname+"\t"+"处方号:"+prescno+"\n"
	if (fyflag=="OK"){
		dhcphaMsgBox.alert(warnmsgtitle+"该记录已经发药!");
		return;
	}
	var checkprescref=GetOrdRefResultByPresc(prescno)
	if (checkprescref=="N"){
		dhcphaMsgBox.alert(warnmsgtitle+"该处方已被拒绝,禁止发药!");
		return;
    }else if (checkprescref=="A"){
		dhcphaMsgBox.alert(warnmsgtitle+"该处方已被拒绝,禁止发药!");
		return;
	}else if (checkprescref=="S"){
		if(!confirm(warnmsgtitle+"该处方医生已提交申诉\n点击'确定'将同意申诉继续发药，点击'取消'将放弃发药操作。")){
			return;
		}
		var cancelrefuseret=tkMakeServerCall("web.DHCSTCNTSOUTMONITOR","CancelRefuse",DHCPHA_CONSTANT.SESSION.GUSER_ROWID,prescno,"OR"); //申诉后发药应先撤消拒绝
	}
	var params=DHCPHA_CONSTANT.DEFAULT.PHLOC+tmpSplit+DHCPHA_CONSTANT.DEFAULT.PHWINDOW+tmpSplit+DHCPHA_CONSTANT.DEFAULT.PHPYUSER+tmpSplit+DHCPHA_CONSTANT.DEFAULT.PHUSER+tmpSplit+prescno;                                       
	var retval=tkMakeServerCall("PHA.OP.HMDisp.OperTab","SaveData",params)
	var retcode=retval.split("^")[0];
	var retmessage=retval.split("^")[1];
	if ((retcode<0)||((retcode==0))){
		dhcphaMsgBox.alert("发药失败,"+retmessage)
		return;
	}else if (retval>0){  
		var bgcolor=$(".dhcpha-record-disped").css("background-color");
		var cssprop = {  
			background: bgcolor,
			color:'black'
		}; 
		$("#grid-disp").setCell(rowid,'TFyFlag','OK');
		$("#grid-disp").setCell(rowid,'Tphd',retval);
		$("#grid-disp").setCell(rowid,'TDspStatus','已发药',cssprop); 
		if (top && top.HideExecMsgWin) {
            top.HideExecMsgWin();
        }
        /// 打印标签
        PrintOutphaCom(prescno, retval)
    }
    //SendOrderToMachine(retval);
}

// 执行拒绝发药
function ExecuteRefuseFY(){
	if (DhcphaGridIsEmpty("#grid-disp")==true){
		return;
	}
	var selectid=$("#grid-disp").jqGrid('getGridParam','selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	if (selectid==null){
	    dhcphaMsgBox.alert("没有选中数据,不能拒绝发药!");
	    return;
	}
	var fyflag=selrowdata.TFyFlag;
	if (fyflag=="OK"){
		dhcphaMsgBox.alert("处方已发药，不能拒绝!");
		return;
	}
	var prescno=selrowdata.TPrescNo;
	if(prescno==""){
		dhcphaMsgBox.alert("请选择要拒绝的处方");
		return;
	}
	var checkprescref = GetOrdRefResultByPresc(prescno);　　 //LiangQiang 2014-12-22  处方拒绝
	if (checkprescref=="N"){
		dhcphaMsgBox.alert("该处方已被拒绝,不能重复操作!")
		return;
	}else if (checkprescref=="A"){
		dhcphaMsgBox.alert("该处方已被拒绝,不能重复操作!")
		return;
	} 
	var waycode =DHCPHA_CONSTANT.VAR.OUTPHAWAY;
	
	
	var orditm=selrowdata.TOeori;
	ShowPHAPRASelReason({
		wayId:waycode,
		oeori:"",
		prescNo:prescno,
		selType:"PRESCNO"
	},SaveCommontResultEX,{orditm:orditm}); 
	
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
	var User = session['LOGON.USERID'];
	var grpdr = session['LOGON.GROUPID'];
	var input = ret + tmpSplit + User + tmpSplit + advicetxt + tmpSplit + factxt + tmpSplit + phnote + tmpSplit + grpdr + tmpSplit + origOpts.orditm;
	var input = input + tmpSplit + DHCPHA_CONSTANT.DEFAULT.APPTYPE;
	SaveCommontResult(reasondr, input)
}

//审核拒绝
function SaveCommontResult(reasondr, input){
	$.ajax({
		url:DHCPHA_CONSTANT.URL.THIS_URL + '?action=SaveOPAuditResult&Input=' + encodeURI(input) + '&ReasonDr=' + reasondr,
		type:'post',   
		success:function(data){	
			var retjson=JSON.parse("["+data+"]");
			if (retjson[0].retvalue==0){
				QueryGridDisp();
				if (top && top.HideExecMsgWin) {
		            top.HideExecMsgWin();
		        }
			}else{
				dhcphaMsgBox.alert(retjson.retinfo);
				return
			} 
		},  
		error:function(){}  
	})
}

// 撤消拒绝发药
function CancelRefuseFY(){
	if (DhcphaGridIsEmpty("#grid-disp")==true){
		return;
	}
	var selectid=$("#grid-disp").jqGrid('getGridParam','selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	if (selectid==null){
	    dhcphaMsgBox.alert("没有选中数据,不能撤消拒绝发药!");
	    return;
	}
	var fyflag=selrowdata.TFyFlag;
	var prescno=selrowdata.TPrescNo;
	if (fyflag=="OK"){
		dhcphaMsgBox.alert("该记录已经发药!");
		return;
	}
	if(prescno==""){
		dhcphaMsgBox.alert("请选择要撤消拒绝的处方");
		return;
	}
	var checkprescref = GetOrdRefResultByPresc(prescno);　　 //LiangQiang 2014-12-22  处方拒绝
	if ((checkprescref!="N")&&(checkprescref!="A")){
		if (checkprescref=="S"){
			dhcphaMsgBox.alert("该处方医生已提交申诉,不需要撤消!")
			return;
		}else{
			dhcphaMsgBox.alert("该处方未被拒绝,不能撤消操作!")
			return;
		}
	}
	var cancelrefuseret=tkMakeServerCall("web.DHCSTCNTSOUTMONITOR","CancelRefuse",DHCPHA_CONSTANT.SESSION.GUSER_ROWID,prescno,"OR");
	if (cancelrefuseret == "0"){
		var newdata={
			TDspStatus:''
		};	
		$("#grid-disp").jqGrid('setRowData',selectid,newdata,"");
		dhcphaMsgBox.alert("撤消成功!","success");
		QueryGridDisp();
	}else if (cancelrefuseret == "-2"){
		dhcphaMsgBox.alert("该处方未被拒绝,不能撤消操作!");
	}else if (retval == "-3"){
		dhcphaMsgBox.alert("该处方已撤消,不能再次撤消!");
	}
}
 //获取处方拒绝结果 
function GetOrdRefResultByPresc(prescno){
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdRefResultByPresc",prescno);
	return ref;
}

//获取其他科室未发药记录,仅读卡发药时
function ChkUnFyOtherLoc(){
 	var startdate = $("#date-start").val();
	var enddate = $("#date-end").val();
	var patno=$("#txt-patno").val();
	if((patno=="")||(patno==null)){
		return;
	}
	var ret=tkMakeServerCall("web.DHCOUTPHA.Common.CommonDisp","ChkUnFyOtherLoc",startdate,enddate,patno,DHCPHA_CONSTANT.DEFAULT.PHLOC,"")
	if(ret==-1){
		//alert("病人为空,请读卡")
	}
	else if(ret==-2){
		dhcphaMsgBox.alert("没找到登记号为"+patno+"的病人");
		return;
		
	}else if((ret!="")&&(ret!=null)){
		dhcphaMsgBox.message(ret);
	}
}

//清空
function ClearConditions(){
	var cardoptions={
		id:"#sel-cardtype"
	}
	InitSelectCardType(cardoptions);
	$("#txt-patno").val("");
	$("#txt-cardno").val("");
	$('#chk-disp').iCheck('uncheck');
	$("#grid-disp").clearJqGrid();
	$("#ifrm-presc").attr("src","");
	var tmpstartdate=FormatDateT("t-2")
	$("#date-start").data('daterangepicker').setStartDate(new Date());
	$("#date-start").data('daterangepicker').setEndDate(new Date());
	$("#date-end").data('daterangepicker').setStartDate(new Date());
	$("#date-end").data('daterangepicker').setEndDate(new Date());
	SetFocus();
}

//权限验证
function CheckPermission(){
	$.ajax({
		url:ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCOUTPHA.InfoCommon&MethodName=CheckPermission'+
			'&groupid='+DHCPHA_CONSTANT.SESSION.GROUP_ROWID+
			'&userid='+DHCPHA_CONSTANT.SESSION.GUSER_ROWID+
			'&locid='+DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
		type:'post',   
		success:function(data){
			var retjson=eval("(" + data + ")");
			var retdata= retjson[0];
			var permissionmsg="",permissioninfo="";
			if (retdata.phloc==""){
				permissionmsg="药房科室:"+gLocDesc;
				permissioninfo="尚未在门诊药房科室维护中维护!"	
			}else {
				permissionmsg="工号:"+DHCPHA_CONSTANT.SESSION.GUSER_CODE+"　　姓名:"+DHCPHA_CONSTANT.SESSION.GUSER_NAME;
				if (retdata.phuser==""){					
					permissioninfo="尚未在门诊药房人员代码维护!"
				}else if(retdata.phnouse=="Y"){
					permissioninfo="门诊药房人员代码维护中已设置为无效!"
				}else if(retdata.phfy!="Y"){
					permissioninfo="门诊药房人员代码维护中未设置发药权限!"
				}
			}
			if (permissioninfo!=""){	
				$('#modal-dhcpha-permission').modal({backdrop: 'static', keyboard: false}); //点灰色区域不关闭
				$('#modal-dhcpha-permission').on('show.bs.modal', function () {
					$("#lb-permission").text(permissionmsg)
					$("#lb-permissioninfo").text(permissioninfo)
		
				})
				$("#modal-dhcpha-permission").modal('show');
			}else{
				DHCPHA_CONSTANT.DEFAULT.PHLOC=retdata.phloc;
				DHCPHA_CONSTANT.DEFAULT.PHPYUSER=retdata.phuser;
				DHCPHA_CONSTANT.DEFAULT.PHUSER=retdata.phuser;
			}
		},  
		error:function(){}  
	})
}

function InitBodyStyle(){
	var height1=$("[class='container-fluid dhcpha-condition-container']").height();
	var height3=parseFloat($("[class='panel div_content']").css('margin-top'));
	var height4=parseFloat($("[class='panel div_content']").css('margin-bottom'));
	var height5=parseFloat($("[class='panel-heading']").height());
	var height6=parseFloat($("[class='container-fluid presccontainer']").height());
	var tableheight=$(window).height()-height1*2-height3-height4-height5-12;
	var dbLayoutWidth=$("[class='panel div_content']").width();
	if (!(!!window.ActiveXObject || "ActiveXObject" in window))  {
		dbLayoutWidth = dbLayoutWidth-7;
	}
	var dbLayoutCss={
		width:dbLayoutWidth,
		height:tableheight
	};
	$("#ifrm-presc").css(dbLayoutCss);
}
function addPhDispStatCellAttr(rowId, val, rawObject, cm, rdata){
	if (val=="已配药"){
		return "class=dhcpha-record-pyed";
	}else if (val=="已打印"){
		return "class=dhcpha-record-printed";
	}else if (val=="已发药"){
		return "class=dhcpha-record-disped";
	}else if (val=="拒绝发药"){
		return "class=dhcpha-record-refused";
	}else if (val=="申诉(拒绝发药)"){
		return "class=dhcpha-record-appeal";
	}else if (val=="接受(拒绝发药)"){
		return "class=dhcpha-record-owefee";
	}else{
		return "";
	}
}

//读卡
function BtnReadCardHandler(){
	var readcardoptions={
		CardTypeId:"sel-cardtype",
		CardNoId:"txt-cardno",
		PatNoId:"txt-patno"		
	}
	DhcphaReadCardCommon(readcardoptions,ReadCardReturn)
}
//读卡返回操作
function ReadCardReturn(){
	QueryGridDisp();
}
/*@ 初始化补录处方模态框信息
  @ pushuangcai
  @ 2018/08/28   */
function InitModifyDeatil(){
	var selrowdata=getSelectRowData();
	var phdprescno=selrowdata.TPrescNo;
	var prescForm=selrowdata.TPrescType;
	var duration=selrowdata.TDuration;
	
	$("#lab-prescno").text(phdprescno);		//处方号
	$("#lab-prescform").text(prescForm);	//处方类别
	$("#lab-duration").text(duration);		//付数
	$(".lab").css({
	  "color":"red",
	  "font-family":"Arial",
	  "font-size":"26px"
	});
	var ret=tkMakeServerCall("PHA.OP.HMDisp.Query","GetPrescDetailList",phdprescno);
	var jsonobj = JSON.parse(ret);
	var tdHtml1 = "";
	var tdHtml2 = "";
	var count = 0;
	var PrescConfigId = jsonobj.TPrescConfigId;
	var PrescConfig = jsonobj.TPrescConfig;
	var OrderQty = jsonobj.TOrderQty;
	var OrderQtyDesc = jsonobj.TOrderQtyDesc;
	var FreqDr = jsonobj.TFreqDr;
	var FreqDesc = jsonobj.TFreqDesc;
	var Insdr = jsonobj.TInsdr;
	var Instruc = jsonobj.TInstruc;
	var cookType = jsonobj.TCoookType;
	var Efficacy = jsonobj.TEfficacy;
	var PrescTypedr = jsonobj.TPrescTypedr;
	//根据处方类型加载配制方法和用法
	InitMakeMedthod(PrescTypedr);
	// 设置默认值
	$("input:radio[name=Efficacy][value="+Efficacy+"]").attr("checked",true); 
	if(PrescConfig!=""){
		$("#sel-cmbMakeMedthod").append('<option value="'+PrescConfigId+'" selected="selected">'+PrescConfig+'</option>')
	}
	if(OrderQtyDesc!=""){
		$("#sel-cmbPrescOrderQty").append('<option value="'+OrderQty+'" selected="selected">'+OrderQtyDesc+'</option>')
	}
	if(FreqDesc!=""){
		$("#sel-cmbInitPHCFreq").append('<option value="'+FreqDr+'" selected="selected">'+FreqDesc+'</option>')
	}
	if(OrderQtyDesc!=""){
		$("#sel-cmbPhcInstruc").append('<option value="'+Insdr+'" selected="selected">'+Instruc+'</option>')
	}
	$.each(jsonobj["TDetail"],function(i){	
		var oeori = jsonobj["TDetail"][i].TOeori;
		var inciDesc = jsonobj["TDetail"][i].TInciDesc.trim();
		var boilType = jsonobj["TDetail"][i].TBoilType;
		var dose = jsonobj["TDetail"][i].TDose.trim();
		var oeoriTmpHtml='<td class="text-right" style="display: none;">'+oeori+'</td>';
		var inciTmpHtml='<td class="text-right">'+inciDesc+"&nbsp;&nbsp;"+dose+'</td>';
		var selTmpHtml="";
		if(boilType!=""){	//显示已保存的煎法
			selTmpHtml='<td>'+'<select class="form-control" id="sel-cmbBoil'+i+'"><option value="'+boilType+'">'+boilType+'</option></select></td>';
		}else{
			selTmpHtml='<td>'+'<select class="form-control in_select" id="sel-cmbBoil'+i+'"></select></td>';
		}
		var tmpHtml=oeoriTmpHtml+inciTmpHtml+selTmpHtml;
		tdHtml1=tdHtml1+tmpHtml;
		count++;
		if(count%4==0){		//设置一行4个药品
			tdHtml2=tdHtml2+'<tr>'+tdHtml1+'</tr>';
			tdHtml1="";
		}
	});
	if(tdHtml1!=""){		
			tdHtml2=tdHtml2+'<tr>'+tdHtml1+'</tr>';
		}
	//console.log(tdHtml2)
	$('#grid-dispdetail').append(tdHtml2);
	InitPhSpecInst(count);		//加载煎法
}

/* 保存补录处方信息 */
function savePrescModified(){
	var selrowdata = getSelectRowData();
	var phdrowid = selrowdata.Tphd;
	var prescno = selrowdata.TPrescNo;
	var paramStr = getPrescModifyParam();
	var detailStr = getPrescModifyDetail();
	var ret=tkMakeServerCall("PHA.OP.HMDisp.OperTab","SavePrescModified",prescno,paramStr,detailStr);
	if(ret==0){
		dhcphaMsgBox.message("保存成功！")
		$('#prescModal').modal('hide');
		return;
	}else{
		dhcphaMsgBox.message("保存失败！")
	}
}
//保存之后刷新
function closeAddPrescModal(){
	$("#prescModal").removeData('bs.modal');
	$("#grid-dispdetail tr").empty();
	$("#sel-cmbMakeMedthod").val("");
    $("#sel-cmbPhcInstruc").val("");
    QueryGridDispSub();
}
/* 获取补录处方模态框信息 */
function getPrescModifyParam(){
	var phcMakeMethod = $("#sel-cmbMakeMedthod").val(); 			//配制方法
	if (phcMakeMethod==null) phcMakeMethod="";
	var phcInstruc = $("#sel-cmbPhcInstruc").val();					//用法
	if (phcInstruc==null) phcInstruc="";
	var PhcFreq = $("#sel-cmbInitPHCFreq").val();					//频次
	if (PhcFreq==null) PhcFreq="";
	var PrescOrderQty = $("#sel-cmbPrescOrderQty").val();			//用量
	if (PrescOrderQty==null) PrescOrderQty="";
	var Efficacy = $("input[name='Efficacy']:checked").val(); 		//功效
	paramStr=phcInstruc+"^"+phcMakeMethod+"^"+PhcFreq+"^"+PrescOrderQty+"^"+Efficacy;
	return paramStr;		
}
/* 获取补录处方明细信息 */
function getPrescModifyDetail(){
	var detailStr = "";
	$('#grid-dispdetail').each(function(index) {
		$(this).find('tr').each(function() {
			var n = 0;
			var tmpStr = "";
		    $(this).find('td').each(function() {
			    n = n+1;
			    var tmp = $(this).text().trim();
			    if($(this).children().length>0){
				   tmp = $(this).children().val();
				   if(tmp==null) tmp="";
				}
			    tmpStr = tmpStr+"^"+tmp;  
			    if(n%3==0){
				    detailStr = detailStr+"&"+tmpStr;
			    	tmpStr = "";
				}
			});
		});
	})
	return detailStr;
}
// 获取选中行数据
function getSelectRowData(){
	var selectid=$("#grid-disp").jqGrid('getGridParam','selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	return selrowdata;
}
//初始化煎药类型
function InitCookType(cookType){
	$.ajax({  
		type: 'POST',
		url: encodeURI(LINK_CSP+'?ClassName=PHA.OP.COM.Store&MethodName=jsGetCookType&params='+cookType+'&gLocId='+ session['LOGON.CTLOCID']),
		data: "json",
		success:function(data){   
			var jsondata=JSON.parse(data);
			var selectoption={
				data:jsondata,	
				minimumResultsForSearch: Infinity
			}
			$("#sel-cook").dhcphaSelect(selectoption);
		}
	})
}
//煎药费申请
function RequstCookType(){
	if (DhcphaGridIsEmpty("#grid-disp")==true){
		return;
	}
	var selrowdata = getSelectRowData();
	var CookType=selrowdata.TCookType;
	if(CookType=="") {
		dhcphaMsgBox.message("煎药方式为空不允许申请煎药费！");
		return;
	};
	var htmlStr = '<div class="input-group">'
		htmlStr += '<span  class="input-group-addon dhcpha-input-group-addon-in"><strong>转煎药方式为</strong></span>'                         
	    htmlStr += '<select class="form-control in_select" id="sel-cook"></select>'
	    htmlStr += '</div>';
	dhcphaMsgBox.confirm(htmlStr,function(result){
		if(!result) {return};
		var cookTypeDr = $("#sel-cook").val();
		if(!cookTypeDr) {
			dhcphaMsgBox.message("煎药方式为空不能申请煎药费！");
			return;
		};
		COOKTYPEDr = cookTypeDr;
		var PrescNo=selrowdata.TPrescNo;
		var ReqCookStr=tkMakeServerCall("PHA.OP.HMDisp.Query","CheckIfInsertCookFee",PrescNo,DHCPHA_CONSTANT.DEFAULT.PHLOC,cookTypeDr);
		var ReqCookCode=ReqCookStr.split("^")[0];
		var ReqCookMessage=ReqCookStr.split("^")[1];
		if(ReqCookCode!=0){
			dhcphaMsgBox.alert(ReqCookMessage);
			return;
		}
		$('#AddMaterialModal').modal('show');
		var appendArcimArr = ReqCookMessage.split(",");
		//alert("appendArcimArr:"+appendArcimArr)
		var trHtml = "";
		for(var i = 0; i < appendArcimArr.length; i++){
			var arcimArr = appendArcimArr[i].split("&");
			var PresAppendItem = arcimArr[0];
			var PresAppendDesc = arcimArr[1];
			var PresAppendQty = arcimArr[2];
			var AricmIdHtml='<td class="text-right" style="display: none;">'+PresAppendItem+'</td>';
			var AricmDescHtml='<td class="text-left" style="font-size:16px">'+PresAppendDesc+"  /  "+PresAppendQty+'</td>';
			var tdHtml='<tr>'+AricmIdHtml+AricmDescHtml+'</tr>'
			trHtml += tdHtml;
		}
		$('#grid-materialtail').html(trHtml);
	});
	InitCookType(CookType);
}
//保存附件材料费
function SaveMaterInfo(){
	var selrowdata = getSelectRowData();
	var PrescNo = selrowdata.TPrescNo;
	var AdmDr=selrowdata.TAdm;
	$('#AddMaterialModal').modal('hide');
	SaveCookFee(AdmDr,PrescNo,COOKTYPEDr);
	COOKTYPEDr = "";
}

function SaveCookFee(AdmDr,PrescNo,cookTypeDr){
	var InputDate=AdmDr+"^"+PrescNo+"^"+gUserID+"^"+gLocId+"^"+cookTypeDr+"^"+gGroupId;
	var RetStr=tkMakeServerCall("PHA.OP.HMDisp.Query","SaveCookFee",InputDate);
	var RetCode=RetStr.split("^")[0];
	var RetMessage=RetStr.split("^")[1];
	if(RetCode!=0){
		var message=RetStr.split("^")[1];
		dhcphaMsgBox.alert(RetMessage);
	}else{
		var newcookcost="煎药已申请";
		var newdata={
	    	TCookCost:newcookcost 
	    };
	    var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	    $("#grid-disp").jqGrid('setRowData',selectid,newdata);
		//dhcphaMsgBox.message("煎药费申请成功！如果之前已经缴纳了煎药费请到收费处退费，然后再缴纳新的煎药费！")
		dhcphaMsgBox.alert("煎药费申请成功！如果之前已经缴纳了煎药费请到收费处退费，然后再缴纳新的煎药费！")
	}
	return;
}

//转换煎药类型
function ExchangeCookType(){
	var prescrowdata = $("#grid-disp").jqGrid('getRowData');
	var prescridrows=prescrowdata.length;
	if(prescridrows<=0){
	    dhcphaMsgBox.alert("审方发药列表无数据!");
	    return;
	}
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	var CookType=selrowdata.TCookType;
	if(CookType=="") {
		dhcphaMsgBox.message("煎药方式为空不允许转换煎药方式！");
		return;
	};
	var htmlStr = '<div class="input-group">'
		htmlStr += '<span  class="input-group-addon dhcpha-input-group-addon-in"><strong>转煎药方式为</strong></span>'                         
	    htmlStr += '<select class="form-control in_select" id="sel-cook"></select>'
	    htmlStr += '</div>';
	dhcphaMsgBox.confirm(htmlStr,function(result){
		if(!result) {return};
		var cookTypeDr = $("#sel-cook").val();
		if(!cookTypeDr) {
			dhcphaMsgBox.message("不允许将煎药方式转换为空！");
			return;
		};
		
		Exchange(cookTypeDr);
	})
	InitCookType(CookType);
}

function Exchange(CookType){
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	//var CookType=selrowdata.TCookType;
	var PrescNo=selrowdata.TPrescNo;
	var DspStatus=selrowdata.TDspStatus;
	var Ret=tkMakeServerCall("PHA.OP.HMDisp.OperTab","SavePrescCookType",PrescNo,CookType,DHCPHA_CONSTANT.DEFAULT.PHLOC);
	var RetCode=Ret.split("^")[0];
	var RetMessage=Ret.split("^")[1];
	if(RetCode==0){
		dhcphaMsgBox.message("转换成功！");
	}else{
		dhcphaMsgBox.alert("转换失败，"+RetMessage);
		return;
	}
	if (CookType!==""){
		var newdata={
	    	TCookType:$("#sel-cook").select2('data')[0].text
	    };
	}
	else{
		var newdata={
	    	TCookType:''
	    };
	}
    $("#grid-disp").jqGrid('setRowData',selectid,newdata);
    QueryGridDispSub();
    if (DspStatus.indexOf("已发药")>-1){
		//AfreshSend();
	}
	return;
}

//重推处方
function AfreshSend(){
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	var dspstatus=selrowdata.TDspStatus;
	if (dspstatus.indexOf("已发药")<0){
		dhcphaMsgBox.alert("该处方还未发药,无法重推!");
		return;
	}
	var phd=selrowdata.Tphd;
	//SendOrderToMachine(phd);
}

//给第三方发送数据
function SendOrderToMachine(phd){
	var sendret=tkMakeServerCall("web.DHCSTInterfacePH","SendPhlDataToMechine",phd);
	if (sendret!="0"){
		var retString=sendret.split("^")[1];
		dhcphaMsgBox.alert("发送数据失败,错误代码:"+retString,"error");
		return;  
	}
}	

function SetFocus()
{
	$("#txt-cardno").focus();
}				
