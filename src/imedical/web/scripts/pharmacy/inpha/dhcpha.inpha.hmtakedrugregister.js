/*
 *模块:			草药房
 *子模块:		草药房-草药领取登记
 *createdate:	2017-07-06
 *creator:		dinghongying
*/
DhcphaTempBarCode="";
var reguserid="";	//登记人工号
$(function(){
	/* 初始化插件 start*/
	var daterangeoptions={
		timePicker : true, 
		timePickerIncrement:1,
		locale: {
			format: DATEFMT
		}
	}
	$("#date-daterange").dhcphaDateRange(daterangeoptions);
	
	//给日期控件赋初始化值！
	var configstr=tkMakeServerCall("web.DHCSTPHALOC","GetPhaflag",gLocId);
	var configarr=configstr.split("^");
	var startdate=configarr[2];
	var enddate=configarr[3] ;
	startdate=FormatDateT(startdate);
	enddate=FormatDateT(enddate);
	$("#date-daterange").data('daterangepicker').setStartDate(startdate);
	$("#date-daterange").data('daterangepicker').setEndDate(enddate);
	
	InitGirdWardList();
	InitGirdPreList();
	
	/* 表单元素事件 start*/
	//卡号失去焦点触发事件
	$('#txt-cardno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			SetUserInfo();	 
		}     
	});
	
	$('#txt-label').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			GetLablePres();	 
		}     
	});
	
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	});    
	
	$("#chk-register").on("ifChanged",function(){
		QueryGridRegWard();
	})
		
	document.onkeydown=OnKeyDownHandler;
})

//扫描或者输入工号之后验证以及填充界面
function SetUserInfo(){
	DhcphaTempBarCode="";
	var cardno=$.trim($("#txt-cardno").val());
	$('#currentnurse').text("");
	$('#currentctloc').text("");
	$('#txt-cardno').val("");
	if (cardno!=""){
		var defaultinfo=tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod","GetUserDefaultInfo",cardno);
		if (defaultinfo==null||defaultinfo==""){
			dhcphaMsgBox.alert("输入工号有误，请核实!");
			return;
		}
		var ss=defaultinfo.split("^");
		reguserid=ss[0];
		$('#currentnurse').text(ss[2]);
		$('#currentctloc').text(ss[4]);				
	}
	QueryGridRegWard();
	$("#txt-label").focus();
}

//初始化已发待登记病区列表table
function InitGirdWardList(){
	var columns=[
		{header:'TWardId',index:'TWardId',name:'TWardId',width:30,hidden:true},
		{header:'病区',index:'TWard',name:'TWard',width:160,align:'left'}
	]; 
	var jqOptions={
	    colModel: columns, //列
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery&MethodName=GetDurgRegWardList',	
	    height: TakeRegHeight(),
	    recordtext:"",
	    pgtext:"",
	    rownumbers: true,
	    shrinkToFit:false,
	    onSelectRow:function(id,status){
			QueryGridPreList();
		},loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				if(reguserid!=""){
					dhcphaMsgBox.alert("请核实是否为护士的工号或该护士所在的病区没有需要领取的处方!");
				}
				$("#grid-wardlist").clearJqGrid();
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
		
	};
	$("#grid-wardlist").dhcphaJqGrid(jqOptions);
}

//初始化处方列表table
function InitGirdPreList(){
	var columns=[
		{header:'TPhac',index:'TPhac',name:'TPhac',width:10,hidden:true},
		{header:'序号',index:'TCount',name:'TCount',width:30},
		{header:'状态',index:'TStatue',name:'TStatue',width:50,cellattr: addCollStatCellAttr},
		{header:'处方号',index:'TPrescNo',name:'TPrescNo',width:80},
		{header:'用法',index:'TInstruc',name:'TInstruc',width:60},
		{header:'付数',index:'TFactor',name:'TFactor',width:40},
		{header:'煎药方式',index:'TCookType',name:'TCookType',width:60},
		{header:'备注',index:'TNote',name:'TNote',width:40},
		{header:'登记号',index:'TPatNo',name:'TPatNo',width:70},
		{header:'病案号',index:'TPameNo',name:'TPameNo',width:60},
		{header:'姓名',index:'TPatName',name:'TPatName',width:60},
		{header:'性别',index:'TPatSex',name:'TPatSex',width:30},
		{header:'发药人',index:'TCollectUserName',name:'TCollectUserName',width:60},
		{header:'发药日期',index:'TCollectDate',name:'TCollectDate',width:60},
		{header:'发药时间',index:'TCollectTime',name:'TCollectTime',width:60}
	]; 
	var jqOptions={
	    colModel: columns, //列
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery&MethodName=GetWardPrescnoList',	
	    height: TakeRegHeight(),
	    recordtext:"",
	    pgtext:"",
	    rownumbers: true,
	   	multiselect: true,
	    shrinkToFit:false,
		
	};
	$("#grid-presclist").dhcphaJqGrid(jqOptions);
}


//查询待登记的病区列表
function QueryGridRegWard(){
	$("#grid-wardlist").jqGrid("clearGridData");
	$("#grid-presclist").jqGrid("clearGridData");
	var params=GetComCodtion();
	$("#grid-wardlist").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

//通过病区ID查询该病去的处方信息列表
function QueryGridPreList(){
	var selectid = $("#grid-wardlist").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-wardlist").jqGrid('getRowData', selectid);
	var wardid=selrowdata.TWardId;
	var params=GetComCodtion()+"^"+wardid;
	$("#grid-presclist").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

//获取界面的公共条件信息
function GetComCodtion(){
	var currentnurse=$.trim($("#currentnurse").text());
	var currentctloc=$.trim($("#currentctloc").text());
	if (currentnurse==null||currentnurse==""||currentctloc==null||currentctloc==""){
	    dhcphaMsgBox.alert("请先刷领药人的卡或者输入工号!");
	    return;
	}
	var daterange=$("#date-daterange").val(); 
	daterange=FormatDateRangePicker(daterange);                       
 	var stdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];
	var chkregflag="N";
	if($("#chk-register").is(':checked')){
		chkregflag="Y";
	}	
	var params=stdate+"^^"+enddate+"^^"+gLocId+"^"+chkregflag+"^"+reguserid;
	return params;
}

//点击领取调用的方法
function ReceivePrescno(){
	var selectids=$("#grid-presclist").jqGrid('getGridParam','selarrrow');
	if ((selectids=="")||(selectids==null)){
		dhcphaMsgBox.alert("请先选择需要领取的处方!");
		return;
	}
	var phacrowidstr="";
	$.each(selectids, function(){
		var selrowdata = $("#grid-presclist").jqGrid('getRowData', this);
		var phacrowid=selrowdata.TPhac;
		if (phacrowidstr==""){
			phacrowidstr=phacrowid;
		}else{
			phacrowidstr=phacrowidstr+"#"+phacrowid;
		}
	})
	var params=phacrowidstr+"^"+reguserid;
	runClassMethod("web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery","SavePreReg", 
			{'params':params},
			function(data){
				if(data==-1){
					dhcphaMsgBox.alert("未选中处方，请核实!");
					return;	
			    }else if(data==-2){
				    dhcphaMsgBox.alert("登记人为空，请核实!");
					return;
				}else if(data==-3){
				    dhcphaMsgBox.alert("更新表数据失败，请核实!");
					return;
				}else{
					dhcphaMsgBox.alert("登记成功!");
					QueryGridRegWard();
					return ;
				}	
	});	
}

//清空
function ClearConditions(){
	$('#currentnurse').text("");
	$('#currentctloc').text("");
	$("#grid-wardlist").clearJqGrid();
	$("#grid-presclist").clearJqGrid();
	reguserid="";
}

//本页面table可用高度
function TakeRegHeight(){
	var height1=$("[class='container-fluid dhcpha-condition-container']").height();
	var height2=parseFloat($("[class='panel-heading']").height());					
	var tableheight=$(window).height()-2*height1-height2-70 
	return tableheight;
}

//扫描标签实现自动定位和自动登记功能！
function GetLablePres(){
	DhcphaTempBarCode="";
	var barcode=$.trim($("#txt-label").val());
	if(barcode==""||barcode==null){
		return;
	}
	$("#txt-label").val("");
	if (reguserid==null||reguserid==""){
	    dhcphaMsgBox.alert("请先刷领药人的卡或者输入工号!");
	    return;
	}
	var dispgridrows=$("#grid-presclist").getGridParam('records');
	var quitflag=0;
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$("#grid-presclist").jqGrid('getRowData',i);
		var tmpprescno=tmpselecteddata["TPrescNo"];
		if (tmpprescno==barcode){
			quitflag=1;
			$("#grid-presclist").jqGrid('setSelection',i);
			var newdata={
		    	TStatue:"已登记"
		    };
		    $("#grid-presclist").jqGrid('setRowData',i,newdata);
			var phacrowid=tmpselecteddata["TPhac"];;
			var params=phacrowid+"^"+reguserid;
			runClassMethod("web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery","SavePreReg", 
					{'params':params},
					function(data){
						if(data==-1){
							dhcphaMsgBox.alert("未选中处方，请核实!");
							return;	
					    }else if(data==-2){
						    dhcphaMsgBox.alert("登记人为空，请核实!");
							return;
						}else if(data==-3){
						    dhcphaMsgBox.alert("更新表数据失败，请核实!");
							return;
						}else{
							return ;
						}	
			});	
		}
	}
	if (quitflag==0){
		dhcphaMsgBox.alert("该处方已经领走或者不是本病区处方，请核实!");
		return;
	}
}

function CheckTxtFocus(){
	var txtfocus1=$("#txt-cardno").is(":focus");
	var txtfocus2=$("#txt-label").is(":focus");
	if ((txtfocus1!=true)&&(txtfocus2!=true)){
		return false;
	}
	return true;	
}

//监听keydown,用于定位扫描枪扫完后给值
function OnKeyDownHandler(){
	if (CheckTxtFocus()!=true){
		if (event.keyCode==13){
			var BarCode=tkMakeServerCall("web.DHCST.Common.JsonObj","GetData",DhcphaTempBarCode);
			if (BarCode.indexOf("I")>-1){
				$("#txt-label").val(BarCode);
				GetLablePres();
			}else{			
				$("#txt-cardno").val(BarCode);
				SetUserInfo();
			}
			DhcphaTempBarCode="";
		}else{
			DhcphaTempBarCode+=String.fromCharCode(event.keyCode);
		}
	}
}

//对状态进行着色
function addCollStatCellAttr(rowId, val, rawObject, cm, rdata){
	if (val.indexOf("已登记")>=0){
		return "class=dhcpha-record-presregister";
	}else{
		return "";
	}
}