/*
 *模块:门诊药房
 *子模块:门诊药房-欠药单管理
 *createdate:2016-09-18
 *creator:dinghongying
*/
DHCPHA_CONSTANT.DEFAULT.PHLOC="";
DHCPHA_CONSTANT.DEFAULT.PHUSER="";
DHCPHA_CONSTANT.DEFAULT.PHWINDOW="";
DHCPHA_CONSTANT.DEFAULT.CYFLAG="";
DHCPHA_CONSTANT.VAR.TIMER="";
DHCPHA_CONSTANT.DEFAULT.FYFLAG=""
$(function(){
	CheckPermission();	
	/* 初始化插件 start*/
	var daterangeoptions={
		singleDatePicker:true
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);
	
	InitGridOwe();
	InitGirdOweDetail();	
	/* 表单元素事件 start*/
	//登记号回车事件
	$('#txt-patno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txt-patno").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				QueryGridOwe();
			}	
		}
	});
	//卡号回车事件
	$('#txt-cardno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var cardno=$.trim($("#txt-cardno").val());
			if (cardno!=""){
				BtnReadCardHandler();
			}	
		}
	});
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	/* 表单元素事件 end*/
	
	/* 绑定按钮事件 start*/
	$("#chk-fy").on("ifChanged",function(){
		if($(this).is(':checked')==true){
			$('#chk-return').iCheck('uncheck');		
		}
	})
	$("#chk-return").on("ifChanged",function(){
		if($(this).is(':checked')==true){
			$('#chk-fy').iCheck('uncheck');		
		}
	})
	$("#btn-find").on("click",QueryGridOwe);
	$("#btn-clear").on("click",ClearConditions);
	$("#btn-fy").on("click",function(){
		if(DHCPHA_CONSTANT.DEFAULT.FYFLAG!="Y"){
		dhcphaMsgBox.alert("用户没有发药权限，发药失败！");	
		return ;
		}
		ExecuteFY();
	});
	$("#btn-return").on("click",DoReturn);
	$("#btn-readcard").on("click",BtnReadCardHandler); //读卡
	/* 绑定按钮事件 end*/;	
	InitBodyStyle();
})
window.onload=function(){
	QueryGridOwe()
}
//初始化欠药table
function InitGridOwe(){
	var columns=[
		{header:'选择',index:'TSelect',name:'TSelect',width:70,hidden:true},	
	    {header:'姓名',index:'TPatName',name:'TPatName',width:100},
	    {header:'登记号',index:'TPmiNo',name:'TPmiNo',width:100},
	    {header:'收费日期',index:'TPrtDate',name:'TPrtDate',width:100},
	    {header:'收据号',index:'TPrtInv',name:'TPrtInv',width:90,hidden:true},
	    {header:'处方',index:'TPrescNo',name:'TPrescNo',width:120},
	    {header:'金额',index:'TPrescMoney',name:'TPrescMoney',width:70,align:'right'},
	    {header:'性别',index:'TPerSex',name:'TPerSex',width:40},
	    {header:'年龄',index:'TPerAge',name:'TPerAge',width:40},
		{header:'科室',index:'TPerLoc',name:'TPerLoc',width:100},		
	    {header:'费别',index:'TPrescType',name:'TPrescType',width:70},
	    {header:'电话',index:'TCallCode',name:'TCallCode',width:100},
	    {header:'欠药时间',index:'TOweDate',name:'TOweDate',width:140},
	    {header:'欠药人',index:'TOweUser',name:'TOweUser',width:100},
		{header:'欠药状态',index:'TOweStatusdesc',name:'TOweStatusdesc',width:70},	
	    {header:'退药日期',index:'TOweretdate',name:'TOweretdate',width:100},
	    {header:'退药人',index:'TOweretuser',name:'TOweretuser',width:70},
	   	{header:'诊断',index:'TMR',name:'TMR',width:250,align:'left'},
	    {header:'病人密级',index:'TEncryptLevel',name:'TEncryptLevel',width:100},		
		{header:'病人级别',index:'TPatLevel',name:'TPatLevel',width:100},
	    {header:'TPrt',index:'TPrt',name:'TPrt',width:60,hidden:true},
	    {header:'TOwedr',index:'TOwedr',name:'TOwedr',width:60,hidden:true},
	    {header:'Tphdrowid',index:'Tphdrowid',name:'Tphdrowid',width:80,hidden:true}
	]; 
	var jqOptions={
	    colModel: columns, //列
	    url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+'?action=QueryOweList', //查询后台	
	    height: DhcphaJqGridHeight(2,3)*0.5,
	    multiselect: false,
	    datatype:'local',
	    pager: "#jqGridPager", //分页控件的id  
	    shrinkToFit:false,
	    onSelectRow:function(id,status){
			QueryGridOweSub()
		},
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#grid-owedetail").clearJqGrid();
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
	};
	$("#grid-owe").dhcphaJqGrid(jqOptions);
}

//初始化发药明细table
function InitGirdOweDetail(){
	var columns=[
	    {header:'药品名称',index:'TInciDesc',name:'TInciDesc',width:250,align:'left'},
		{header:'单位',index:'TPhUom',name:'TPhUom',width:60},
		{header:'欠药数量',index:'TPhQty',name:'TPhQty',width:70,align:'right'},
		{header:'预发',index:'TRealQty',name:'TRealQty',width:70,
			editable:true,
			cellattr:addTextCellAttr			
		},
		{header:'已发',index:'TDispedqty',name:'TDispedqty',width:70},
		{header:'单价',index:'TPrice',name:'TPrice',width:80,align:'right'},
		{header:'金额',index:'TMoney',name:'TMoney',width:80,align:'right'},
		{header:'状态',index:'TOrdStatus',name:'TOrdStatus',width:50},
		{header:'剂量',index:'TDoseQty',name:'TDoseQty',width:50},
		{header:'频次',index:'TPC',name:'TPC',width:60},
		{header:'用法',index:'TYF',name:'TYF',width:40},
		{header:'疗程',index:'TLC',name:'TLC',width:40},
		{header:'医师',index:'TDoctor',name:'TDoctor',width:70,hidden:true},
		{header:'医保类别',index:'TInsuCode',name:'TInsuCode',width:70},
		{header:'货位',index:'TIncHW',name:'TIncHW',width:70},
		{header:'规格',index:'TSpec',name:'TSpec',width:70},
		{header:'备注',index:'TPhbz',name:'TPhbz',width:80},
		{header:'厂商',index:'TManfDesc',name:'TManfDesc',width:200,align:'left'},
		{header:'库存',index:'TKCFlag',name:'TKCFlag',width:50},
		{header:'库存数量',index:'TKCQty',name:'TKCQty',width:80},
		{header:'TOrditm',index:'TOrditm',name:'TOrditm',width:80,hidden:true},
		{header:'TUnit',index:'TUnit',name:'TUnit',width:80,hidden:true},
		{header:'TDoctCode',index:'TDoctCode',name:'TDoctCode',width:80,hidden:true},
		{header:'TInci',index:'TInci',name:'TInci',width:80,hidden:true}
		
	]; 
	var jqOptions={
		datatype:'local',
	    colModel: columns, //列
	    url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+'?action=QueryOweListDetail',	
	    height: DhcphaJqGridHeight(2,3)*0.5,
	    shrinkToFit:false,
	    onSelectRow:function(id,status){
		    if ((JqGridCanEdit==false)&&(LastEditSel!="")&&(LastEditSel!=id)){
			    $("#grid-owedetail").jqGrid('setSelection',LastEditSel);
			    return
			}
			if ((LastEditSel!="")&&(LastEditSel!=id)){
				$(this).jqGrid('saveRow', LastEditSel);
			}			
			$(this).jqGrid("editRow", id,{
				oneditfunc:function(){
					$editinput = $(event.target).find("input");
					$editinput.focus(); 
					$editinput.select();
                    $editinput.unbind().on("keyup",function(e){
						$editinput.val(ParseToNum($editinput.val()))
					});					
					$("#"+id+"_TRealQty").on("focusout || mouseout",function(){
						var reg = /^[0-9]\d*$/;
						if (!reg.test(this.value)) {
							dhcphaMsgBox.message("第"+id+"行的预发数量只能为整数!")
							$("#grid-owedetail").jqGrid('restoreRow',id);
							return false
						}	
						var iddata=$('#grid-owedetail').jqGrid('getRowData',id);
						var oeoriqty=iddata.TPhQty;								
						if (parseFloat(this.value*1000)>parseFloat(oeoriqty*1000)) {
							dhcphaMsgBox.message("第"+id+"行预发数量大于处方数量!")
							$("#grid-owedetail").jqGrid('restoreRow',id);
							return false
						}else{
							JqGridCanEdit=true
							return true
						}
					});
				}
			});
			LastEditSel=id;
		}
	    
	};
	$("#grid-owedetail").dhcphaJqGrid(jqOptions);
	PhaGridFocusOut("grid-owedetail");
}

//查询欠药列表
function QueryGridOwe(){
 	var stdate = $("#date-start").val();
	var enddate = $("#date-end").val();
 	var chkfy=0;
	if($("#chk-fy").is(':checked')){
		chkfy="1";
	}
	var chkreturn=0;
	if($("#chk-return").is(':checked')){
		chkreturn="1";
	}
	var patno=$("#txt-patno").val();
	var prescno=$("#txt-prescno").val();;
	var ctloc=DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID; 
	var patname="";
	var CPrint=0;
	var inci="";
	var params=stdate+"^"+enddate+"^"+ctloc+"^"+patno+"^"+CPrint+"^"+chkfy+"^"+chkreturn+"^"+prescno+"^"+patname+"^"+inci;	
	$("#grid-owe").setGridParam({
		datatype:'json',
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
	JqGridCanEdit=true;
	$("#grid-owedetail").jqGrid("clearGridData");
	//$("#grid-owedetail").clearJqGrid();
}
//查询欠药明细
function QueryGridOweSub(){
	var selectid = $("#grid-owe").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-owe").jqGrid('getRowData', selectid);
	var phdowerow=selrowdata.TOwedr;
	var params=phdowerow;
	$("#grid-owedetail").setGridParam({
		datatype:'json',
		postData:{
			'params':params
		}	
	}).trigger("reloadGrid");
	JqGridCanEdit=true;
}
// 执行发药
function ExecuteFY(){
	if (DhcphaGridIsEmpty("#grid-owe")==true){
		return;
	}
	if(DhcphaGridIsEmpty("#grid-owedetail")==true){
		 dhcphaMsgBox.alert("欠药单没有明细,不能发药!");
		 return;
	}
	var selectid=$("#grid-owe").jqGrid('getGridParam','selrow');
	if (selectid==null){
	    dhcphaMsgBox.alert("没有选中数据,不能发药!");
	    return;
	}
	if(JqGridCanEdit==false){
		return;
	}
	OweDispMonitor(selectid);
}

function OweDispMonitor(rowid){
	var oweselrowdata=$("#grid-owe").jqGrid('getRowData', rowid);
	var prescno=oweselrowdata.TPrescNo;
	var owestat=oweselrowdata.TOweStatusdesc;
	var patname=oweselrowdata.TPatName;
	var warnmsgtitle="病人姓名:"+patname+"</br>"+"处方号:"+prescno+"</br>";
	if ((owestat=="已发药")||(owestat=="已退药")){
		dhcphaMsgBox.alert(warnmsgtitle+"该记录"+owestat+"!");
		return;
	}
	var dispQtyString="";
	var owedetailrowdata = $("#grid-owedetail").jqGrid('getRowData');
    var owedetailgridrows=owedetailrowdata.length;
	if (owedetailgridrows<=0){
		dhcphaMsgBox.alert("没有明细数据!");
		return;
	}
	var chkflag=0,allowe=1,zeroFlag=0
	var dispQtyString=0
	for(var rowi=0;rowi<owedetailgridrows;rowi++){
		var oeoriQty=owedetailrowdata[rowi].TPhQty
		var realQty=owedetailrowdata[rowi].TRealQty
		oeoriQty=$.trim(oeoriQty);
		realQty=$.trim(realQty);
		if(parseFloat(realQty)!=0){
			var zeroFlag=1;
		}
		if(parseFloat(realQty)>parseFloat(oeoriQty)){
			dhcphaMsgBox.alert("预发数量不能大于医嘱数量!");
			return;
		}
		if (parseFloat(realQty)<0){
			dhcphaMsgBox.alert("预发数量不能小于0!");
			return;
		}
		if (parseFloat(realQty)!=parseFloat(oeoriQty)){
			chkflag="1";
		}
		if (allowe!=0) {allowe=0}
		var oeori=owedetailrowdata[rowi].TOrditm
		var unit=owedetailrowdata[rowi].TUnit
		var Inci=owedetailrowdata[rowi].TInci
		var tmpdispstring=oeori+"^"+realQty+"^"+oeoriQty+"^"+unit+"^"+Inci
		if (dispQtyString==0){
			dispQtyString=tmpdispstring
		}
		else{
			dispQtyString=dispQtyString+"!!"+tmpdispstring
		}
		
	} 	
	if(zeroFlag!=1){
		dhcphaMsgBox.alert("预发数量不能都为0!");
		return;
	}
	dispQtyString=chkflag+"&&"+allowe+"&&"+dispQtyString ;
	var tmpordstr=dispQtyString.split("&&") 
	var chkord=tmpordstr[0] ;
	ChkAllOweFlag=tmpordstr[1] ;  //是否全部欠药
	ChkOweFlag=chkord;
	var owedr=oweselrowdata.TOwedr;
	dispQtyString=dispQtyString+"&&"+owedr;
	var prescno=oweselrowdata.TPrescNo;
	if (chkflag=="1"){
		dhcphaMsgBox.confirm("是否需要生成欠药单？点击[确认]生成，点击[取消]退出。",function(r){
			if(r==true){
				DispMonitor(prescno,dispQtyString,rowid);
			}else{
				return;
			}
		});  
	}else{
		DispMonitor(prescno,dispQtyString,rowid);
	}			
}

function DispMonitor(prescno,dispQtyString,rowid){                                       
	var RetInfo=tkMakeServerCall("PHA.OP.DirDisp.OperTab","SaveDispData",DHCPHA_CONSTANT.DEFAULT.PHLOC,DHCPHA_CONSTANT.DEFAULT.PHWINDOW,DHCPHA_CONSTANT.DEFAULT.PHUSER,DHCPHA_CONSTANT.DEFAULT.PHUSER,prescno,dispQtyString);
	var retarr=RetInfo.split("^");
	var retval=retarr[0];
	var retmessage=retarr[1];
	var warnmsgtitle="处方号:"+prescno+"</br>"
	if (!(retval>0)){
		dhcphaMsgBox.alert(warnmsgtitle+"发药失败,错误代码: "+retmessage);
		return;
	}
	var newdata={
		TOweStatusdesc:'已发药'
	};	
	$("#grid-owe").jqGrid('setRowData',rowid,newdata);
	dhcphaMsgBox.alert("欠药发药成功","success");
	var phOweId=tkMakeServerCall("PHA.OP.COM.Print","GetPhOweByPhd",retval);
	PrintPhdOwe(phOweId);
	QueryGridOweSub();
}
//执行退药
function DoReturn(){	
	if (DhcphaGridIsEmpty("#grid-owe")==true){
		return;
	}
	if(DhcphaGridIsEmpty("#grid-owedetail")==true){
		 dhcphaMsgBox.alert("欠药单没有明细,不需退药!");
		 return;
	}
	var selectid=$("#grid-owe").jqGrid('getGridParam','selrow');
	var selrowdata = $("#grid-owe").jqGrid('getRowData', selectid);
	var prescno=selrowdata.TPrescNo;
	var owedr=selrowdata.TOwedr;
	var retval=tkMakeServerCall("PHA.OP.Owe.OperTab","ExcRetrun",DHCPHA_CONSTANT.DEFAULT.PHUSER,prescno,owedr);
	if (retval==-1){
		dhcphaMsgBox.alert("该欠药单状态已处理,不能退药!");
		return;
	}else if (retval==-2){
		dhcphaMsgBox.alert("该欠药单状态已处理,不能重复退药!")
		return;
	}else if (retval==-4){
		dhcphaMsgBox.alert("该处方还未发药,请取消配药单,不能执行退药!")
		return;
	}else if (retval<0){
		dhcphaMsgBox.alert("退药失败:"+retval)
		return;
	} 
	dhcphaMsgBox.alert("欠药退药成功,请到收费处退费!"); 
	var RetData=tkMakeServerCall("PHA.OP.COM.Method","GetPhOweInfo",owedr);
	var RetOweDate=RetData.split("^")[2];
	var RetOweUser=RetData.split("^")[3];
	var newdata={
		TOweStatusdesc:'已退药',
		TOweretdate:RetOweDate,
		TOweretuser:RetOweUser
	};	
	$("#grid-owe").jqGrid('setRowData',selectid,newdata);
	
}
//清空
function ClearConditions(){
	$("#txt-patno").val("");
	$("#txt-cardno").val("");
	$("#txt-patname").val("");
	$("#txt-prescno").val("");
	$('#chk-fy').iCheck('uncheck');
	$('#chk-return').iCheck('uncheck');
	$("#grid-owe").clearJqGrid();
	$("#grid-owedetail").clearJqGrid();
	$("#date-start").data('daterangepicker').setEndDate(new Date());
	$("#date-start").data('daterangepicker').setStartDate(new Date());
	$("#date-end").data('daterangepicker').setEndDate(new Date());
	$("#date-end").data('daterangepicker').setStartDate(new Date());
	JqGridCanEdit=true;
}
//权限验证
function CheckPermission(){
	$.ajax({
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=CheckPermission'+
			'&groupId='+DHCPHA_CONSTANT.SESSION.GROUP_ROWID+
			'&gUserId='+DHCPHA_CONSTANT.SESSION.GUSER_ROWID+
			'&gLocId='+DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
		type:'post',   
		success:function(data){ 
			var retjson=eval("(" + data + ")");
			var retdata= retjson[0];
			var permissionmsg="",permissioninfo="";
			if (retdata.phloc==""){
				permissionmsg="药房科室:"+defaultLocDesc;
				permissioninfo="尚未在门诊药房人员代码维护!"	
			}else {
				permissionmsg="工号:"+DHCPHA_CONSTANT.SESSION.GUSER_CODE+"　　姓名:"+DHCPHA_CONSTANT.SESSION.GUSER_NAME;
				if (retdata.phuser==""){					
					permissioninfo="尚未在门诊药房人员代码维护!";
				}else if(retdata.phnouse=="Y"){
					permissioninfo="门诊药房人员代码维护中已设置为无效!";
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
				DHCPHA_CONSTANT.DEFAULT.PHUSER=retdata.phuser;
				DHCPHA_CONSTANT.DEFAULT.CYFLAG=retdata.phcy;
				DHCPHA_CONSTANT.DEFAULT.FYFLAG=retdata.phfy;
			}
		},  
		error:function(){}  
	})
}

function InitBodyStyle(){
	//$("#btn-fy").dhcphaImageBtn({image:"disp-red"});
	//$("#btn-return").dhcphaImageBtn({image:"return"});
}
function PhaGridFocusOut(gridid){
	$("#"+gridid).on("mouseleave",function (e) {
		if (e.relatedTarget) {
	        var $related = $("#"+gridid).find(e.relatedTarget);
	        if ($related.length <= 0 && LastEditSel!="") {
	            $("#"+gridid).jqGrid('saveRow', LastEditSel);
	        }
	    }
	})
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
	QueryGridOwe();
}