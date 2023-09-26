/*
模块:门诊药房
子模块:门诊药房-配药
createdate:2016-04-25
creator:yunhaibao
*/
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var hisPatNoLen=0;
var hisCardNoLen=0;
var LocIsCY="";
var The_Time;
$(function(){
	InitTitle();
	InitCardType();
	InitPYList();
	InitPYListItm();
	$('#btnClear').bind("click",InitCondition);  
	$('#btnFind').bind("click",QueryPY); 
	$('#btnReadCard').bind("click",BtnReadCardHandler); 
	$('#btnPYSure').bind("click",BtnPYHandler); //配药
	$('#btnTime').bind("click",BtnTimeHandler); 
	$('#btnRePrint').bind("click",BtnRePrintHandler); //补打	 
	//登记号回车事件
	$('#patNo').bind('keypress',function(event){
	 if(window.event.keyCode == "13"){
		 var patno=$.trim($("#patNo").val());
		 if (patno!=""){
			GetWholePatID(patno);
		 }	
	 }
	});
	$('#cardNo').bind('keypress',function(event){
	 if(window.event.keyCode == "13"){
		 CardNoKeyPress()
	 }
	});
	InitCondition();
});
function InitTitle(){
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: commonOutPhaUrl+'?action=GetDescFromId',//提交到那里 后他的服务  
		data: "gphl="+gphl+"&gpyphw="+gphw+"&gpydr="+gpydr+"&gfydr="+gfydr+"&gpos="+gpos,//提交的参数  
		success:function(value){     
			if (value!=""){
				var getdescarr=value.split("^");
				$('#currentLoc').text(getdescarr[0]);
				$('#currentWin').text(getdescarr[1]);
				$('#pyUser').text(getdescarr[2]);
			}
			$('#stepTime').text(gsteptime+"秒");    
		},    
		error:function(){        
			alert("获取数据失败!");
		}
	}); 
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: commonOutPhaUrl+'?action=GetPminoLen',//提交到那里 后他的服务  
		data: "",
		success:function(value){     
			if (value!=""){
				hisPatNoLen=value;
			}   
		},    
		error:function(){        
			alert("获取数据失败!");
		}
	});
	//药房参数
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: commonOutPhaUrl+'?action=GetPhLocConfig',//提交到那里 后他的服务  
		data: "gLocId="+gLocId,
		success:function(value){     
			if (value!=""){
				var valuearr=value.split("^")
				LocIsCY=valuearr[1];
			}   
		},    
		error:function(){        
			alert("获取数据失败!");
		}
	});	
}
function InitCondition(){
	$("#startDate").datebox("setValue", formatDate(0));  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0));  //Init结束日期
	$("#patNo").val("");
	$("#cardNo").val("");
	$("input[type='checkbox'][id=checkedPY]").removeAttr("checked");
	$('#pygrid').datagrid('loadData',{total:0,rows:[]}); 
	$('#pydetailgrid').datagrid('loadData',{total:0,rows:[]});
	$('#pygrid').datagrid('options').queryParams.params = "";  
	$('#pydetailgrid').datagrid('options').queryParams.params = ""; 
	
}
function InitPYList(){
		//定义columns
	var columns=[[
		{field:"TPatName",title:'姓名',width:80},
		{field:"TPmiNo",title:'登记号',width:80},
		{field:'TPrtDate',title:'收费日期',width:80},
		{field:'TPrintFlag',title:'打印',width:40},	
		{field:'TFyFlag',title:'配药',width:40,hidden:true},
		{field:'TPrtInv',title:'收据号',width:80},
		{field:'TPrtTime',title:'收据时间',width:100},
		{field:'TPrt',title:'TPrt',width:50,hidden:true},	
		{field:'TPrescNo',title:'处方号',width:100},
		{field:'TPrescMoney',title:'处方金额',width:80},	
		{field:'TPerSex',title:'性别',width:50},
		{field:'TPerAge',title:'年龄',width:50},
		{field:'TMR',title:'诊断',width:150},	
		{field:'TGLOrd',title:'TGLOrd',width:100,hidden:true},			
		{field:'TPerLoc',title:'科室',width:100},
		{field:'TSyFlag',title:'TSyFlag',width:100,hidden:true},	
		{field:'TPrescType',title:'费别',width:100},	
		{field:'TWinDesc',title:'发药窗口',width:100},
		{field:'TPatID',title:'TPatID',width:100,hidden:true},	
		{field:'TJS',title:'剂数',width:100},
		{field:'TJYType',title:'煎药类型',width:100},	
		{field:'TCallCode',title:'电话',width:100},	
		{field:'TPatAdd',title:'地址',width:100,hidden:true},
		{field:'TPrescTitle',title:'TPrescTitle',width:100,hidden:true},	
		{field:'Tphdrowid',title:'Tphdrowid',width:100,hidden:true},
		{field:'TEncryptLevel',title:'病人密级',width:100},		
		{field:'TPatLevel',title:'病人级别',width:100},			
	]];
	
	//定义datagrid
	$('#pygrid').datagrid({
		border:false,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		singleSelect: true,
		selectOnCheck: true, 
		checkOnSelect: true,
		pageSize:30,  // 每页显示的记录条数
		pageList:[30,50,100],   // 可以设置每页记录条数的列表
		pagination:true,
		rowStyler: function(index,row){
		      /* if (row.TPrintFlag=="OK"){
			    $('tr[datagrid-row-index='+index+']')
			    	.removeClass("datagrid-row-alt")
					.addClass("datagrid-row-set");
				}*/
				if (row.TPrintFlag=="OK"){
                    return 'color:#ff0066;font-weight:bold';
                } 
		},
		onLoadSuccess: function(){
         	//选中第一
         	if ($('#pygrid').datagrid("getRows").length>0){
	         	$('#pygrid').datagrid("selectRow", 0)
	         	QueryPYSub();
         	}
         	
	    },
	    onSelect:function(rowIndex,rowData){
		   QueryPYSub();   
	    }

	});
	$('#pygrid').gridupdown($('#pygrid'));
}
function InitPYListItm()
{
	var columns=[[
		{field:'TPhDesc',title:'药品名称',width:200},
		{field:'TPhQty',title:'数量',width:80},
		{field:'TPhUom',title:'单位',width:80},
		{field:'TPrice',title:'单价',width:80},	
		{field:'TMoney',title:'金额',width:80},	
		{field:'TOrdStatus',title:'医嘱状态',width:80},	
		{field:'TJL',title:'剂量',width:80},	
		{field:'TPC',title:'频次',width:80},
		{field:'TYF',title:'用法',width:80},
		{field:'TLC',title:'疗程',width:80},	
		{field:'TDoctor',title:'医师',width:80},	
		{field:'TOrditm',title:'TOrditm',width:80,hidden:true},	
		{field:'TUnit',title:'TUnit',width:80,hidden:true},	
		{field:'TIncPC',title:'批次',width:80,hidden:true},	
		{field:'TIncHW',title:'货位',width:80},
		{field:'TPhType',title:'TPhType',width:80,hidden:true},	
		{field:'TPhgg',title:'规格',width:80},
		{field:'TPhbz',title:'备注',width:80},
		{field:'TKCFlag',title:'库存',width:80,hidden:true},	
		{field:'TSkinTest',title:'皮试',width:80},
		{field:'TSyFlag',title:'TSyFlag',width:80,hidden:true},
		{field:'TPhFact',title:'厂家',width:80},
		{field:'TDoctCode',title:'TDoctCode',width:80,hidden:true},
		{field:'TJRFlag',title:'TJRFlag',width:80,hidden:true},
		{field:'TCyyf',title:'TCyyf',width:80,hidden:true},
		{field:'TKCQty',title:'库存量',width:80},
		{field:'TYBType',title:'类型',width:80},
		{field:'TDX',title:'TDX',width:80,hidden:true},
		{field:'TRealQty',title:'实发数',width:80,hidden:true}		
	]];
	
	//定义datagrid
	$('#pydetailgrid').datagrid({
		border:false,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		singleSelect: true,
		selectOnCheck: true, 
		checkOnSelect: true,
		toolbar:"#conditiondiv",
		rowStyler: function(index,row){
			if (row.TOrdStatus!="核实"){
                return 'color:#ff0066;font-weight:bold';
            } 
            if (row.TKCFlag=="不够"){
                return 'color:#00cc00;font-weight:bold';
            } 
		}
	});
}
function InitCardType()
{
	$('#cardType').combobox({  
		width:100,
		panelHeight:'auto',
		panelWidth: 100,
		url:commonOutPhaUrl+'?action=GetCardType',  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#cardType').combobox('getData');
            if (data.length > 0) {
                  $('#cardType').combobox('select', data[0].RowId);
                  for (var i=0;i<data.length;i++){
						var tmpcardvalue = data[i].RowId;
						var tmpcardarr = tmpcardvalue.split("^");
						var defaultflag = tmpcardarr[8];
						if (defaultflag == "Y") {
							$('#cardType').combobox('select', data[i].RowId);
						}
	              }
              }            
	    },
       onSelect:function(record){  
       		if (record.Desc=="条形码"){
	       		//$("#cardNo").attr("disabled", true);	
	       	}
	       	else{
		      // $("#cardNo").attr("disabled", true);	
		    }  
        } 
	    
	});
}
///补0病人登记号
function GetWholePatID(RegNo)
{    
	if (RegNo=="") {
		return RegNo;
	}
	var patLen = hisPatNoLen;
	var plen=RegNo.length;
	if (plen>patLen){
		$.messager.alert('错误提示',"登记号输入错误！");
		return;
	}
	for (i=1;i<=patLen-plen;i++){
		RegNo="0"+RegNo;  
	}
	$("#patNo").val(RegNo);
	QueryPY();
}
function GetCardTypeRowId() {
	var CardTypeRowId = "";
	var CardTypeValue = $('#cardType').combobox("getValue");
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardTypeRowId = CardTypeArr[0];
		m_CardNoLength= CardTypeArr[17];
	}
	return CardTypeRowId;
}
//查询配药列表
function QueryPY(){
	var startDate=$('#startDate').datebox('getValue');
	if (startDate==""){
		$.messager.alert('错误提示',"请输入开始日期!");
		return;
	}
	var endDate=$('#endDate').datebox('getValue');
	if (endDate==""){
		$.messager.alert('错误提示',"请输入开始日期!");
		return;
	}
	var patNo=$("#patNo").val();
	var patName=""
	var checkedPy=""
	$("input[type=checkbox][id=checkedPY]").each(function(){
		if($('#'+this.id).is(':checked')){
			checkedPy=this.value;
		}
	})
	var cPyUser=""
	var specialId=""
	var stopcon=""
	var params=startDate+"^"+endDate+"^"+gphl+"^"+gphw+"^"+patNo+"^"+patName
	+"^"+gpydr+"^"+gfydr+"^"+gpos+"^"+checkedPy+"^"+cPyUser+"^"+stopcon+"^"+specialId;
	$('#pygrid').datagrid({
		url:commonOutPhaUrl+'?action=QueryPYList',	
		queryParams:{
			params:params}
	});
	
}
//查询配药明细
function QueryPYSub(){
	var selecteddata = $('#pygrid').datagrid('getSelected');
	if(selecteddata==null){
		return;	
	}
	var prt=selecteddata["TPrt"];
	var prescno=selecteddata["TPrescNo"];
	var phdrow=selecteddata["Tphdrowid"];
	var params=gphl+"^"+prt+"^"+prescno;
	$('#pydetailgrid').datagrid({
		url:commonOutPhaUrl+'?action=QueryDispListDetail',	
		queryParams:{
			params:params}
	});
}
//读卡
function BtnReadCardHandler() {
	var CardTypeRowId = GetCardTypeRowId();
	var myoptval = $('#cardType').combobox("getValue");
	var myrtn; 
	myrtn = DHCACC_GetAccInfo(CardTypeRowId, myoptval); 
	if (myrtn == -200) { //卡无效
		$.messager.alert('错误提示',"卡无效!");
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
		$("#patNo").val(PatientNo);
		QueryPY();
		break;
	case "-200":
		$.messager.alert('错误提示',"卡无效");
		break;
	case "-201":
		//现金
		PatientID = myary[4];
		var PatientNo = myary[5];
		var CardNo = myary[1]
		var NewCardTypeRowId = myary[8];
		$("#patNo").val(PatientNo);
		QueryPY();
		break;
	default:
	}
}
function CardNoKeyPress(){
	 var cardno=$.trim($("#cardNo").val());
	 if (cardno!=""){
		var cardlen=cardno.length
		var CardTypeValue =$('#cardType').combobox("getValue");
		if (CardTypeValue != "") {
			var CardTypeArr = CardTypeValue.split("^");
			m_CardNoLength= CardTypeArr[17]
		}
		else {
			return
		}
		if (m_CardNoLength>cardlen){
			var lszero="";
			for (i=1;i<=m_CardNoLength-cardlen;i++)
			{
				lszero=lszero+"0"  
			}
			var lscard=lszero+cardno;
		}

		var pminofrmcardno=tkMakeServerCall("web.DHCOutPhCommon","GetPmiNoFrCardNo",lscard)	
		if (pminofrmcardno=="-1")
		{
			$("#cardNo").val("");
			$.messager.alert('错误提示',"卡无效!");
			return;
		}
		$("#patNo").val(pminofrmcardno);
		$("#cardNo").val("");
		QueryPY();		
 	}	
}
//配药按钮触发
function BtnPYHandler(){
	if ($('#pygrid').datagrid("getRows").length<=0){
		$.messager.alert('提示',"没有数据,无法配药!");
		return;
	}
	var selecteddata = $('#pygrid').datagrid('getSelected');
	if(selecteddata==null){
		$.messager.alert('提示',"没有选中数据,无法配药!");
		return;	
	}
	var selectedrow=$('#pygrid').datagrid("getRowIndex",selecteddata);
    /*if (selecteddata["TPrintFlag"]=="OK"){
    $('tr[datagrid-row-index='+selectedrow+']').removeClass("datagrid-row-alt")
		.addClass("datagrid-row-set");
	} */
	var prescno=selecteddata["TPrescNo"];
	var printflag=selecteddata["TPrintFlag"];
	var prt=selecteddata["TPrt"];
	if (printflag=="OK"){
		$.messager.alert('提示',"该记录已经配药!");
		return;
	}
	//检查处方审核结果
	var checkprescadt=tkMakeServerCall("web.DHCOutPhCommon","GetOrdAuditResultByPresc",prescno)
	if (checkprescadt==""){
		$.messager.alert('提示',"请先审核!");
		return;
    }
     
	if (checkprescadt=="N"){
		$.messager.alert('提示',"审核不通过,不允许配药");
		return;
	}
	var dispret=tkMakeServerCall("web.DHCOutPhTQDisp","InsertPHDisp",prt,gphl,gphw,gpydr,"",prescno,"",gpydr)
     if (dispret==-1){
	     $.messager.alert('提示',"该处方已作废,不能配药");
	     return -1;
     }
     if (dispret==-2){
	     $.messager.alert('提示',"该处方药品已配,不能重复配药");
	     return -2;
     }
     if (dispret==-3){  
	     $.messager.alert('提示',"该处方药品配药,不能重复配药");
	     return -3;
     }
	 if (dispret==-4){
	     $.messager.alert('提示',"该处方医嘱已停,不能配药");
	     return -4;
     }     
     if (dispret==-7){
	     $.messager.alert('提示',"配药失败,"+"失败原因: 库存不足,请核查");
	     return -7;
     }     
     if (dispret==-10){   
         $.messager.alert('提示',"已配药,不能重复配药")
	     return -10;
     }     
     if (dispret==-24){
	     $.messager.alert('提示',"配药失败,"+"失败原因: 库存不足,请核查")
	     return -24;
     }
     if (dispret==-123){
	     $.messager.alert('提示',"该处方未做皮试或皮试结果阳性!")
	     return -123;
     }
     if (dispret<0){
	     $.messager.alert('提示',"配药失败,"+"错误代码: "+retval)
	     return retval;
     } 
     if (!(dispret>0)){
	     $.messager.alert('提示',"配药失败,"+"错误代码: "+retval)
	     return -100;
	     
     }
     if (dispret>0){   
	     $('#pygrid').datagrid('updateRow',{
			index: selectedrow,
			row: {Tphdrowid: dispret,TPrintFlag:'OK'}
		 });
		 PrintPrescCom(dispret,LocIsCY,"")
 		 /*if (selecteddata["TPrintFlag"]=="OK"){
		     $('tr[datagrid-row-index='+selectedrow+']')
		     	.removeClass("datagrid-row-alt")
				.addClass("datagrid-row-set");
			 $("#pydetailgrid").removeClass("datagrid-row-set")
		 }*/
     }
	
}
function BtnTimeHandler()
{

	if ($.trim($('#btnTime').text())=="开始"){
		$('#btnTime').linkbutton({
			iconCls : 'icon-stop',
			text:'停止'
		});
		AutoDispHandler();
	}
	else{
		$('#btnTime').linkbutton({
			iconCls : 'icon-start',
			text:'开始'
		});
		clearTimeout(The_Time) 
	}
}
function AutoDispHandler()
{
  var cyflag=LocIsCY;
  var autopy=tkMakeServerCall("web.DHCOutPhCode","GetPhlAutoPyFlag",gphl)
  if (autopy!=1) return ;
  var startDate=$('#startDate').datebox('getValue');
  var endDate=$('#endDate').datebox('getValue');
  var settime=gsteptime;
  var step=settime*1000
  The_Time=setTimeout("AutoDispHandler();", step);
  var getautodispinfo=tkMakeServerCall("web.DHCOutPhTQDisp","GetAutoDispInfo",startDate,startDate,gphl,gphw)
  var retarr=getautodispinfo.split("^")
  var retnum=retarr[0]
  var retpid=retarr[1]
  if  (retnum==0) {return ;}
  var insertphdispauto=tkMakeServerCall("web.DHCOutPhTQDisp","InsertPHDispAuto",cyflag,retpid,gphl,gphw,gpydr,"")
  if (insertphdispauto==""){return ; }
  PrintPrescCom(insertphdispauto,cyflag,"")

}
function BtnRePrintHandler(){
	var selecteddata = $('#pygrid').datagrid('getSelected');
	if(selecteddata==null){
		$.messager.alert('提示',"没有选中数据,无法打印!");
		return;	
	}
	var phdrowid=selecteddata["Tphdrowid"];
	PrintPrescCom(phdrowid,LocIsCY,"")
}
//快捷键
//jQuery(document).bind('KeyDown.f5',function(){ BtnReadCardHandler();return false});
$(document).keydown(function(event){
 	if(event.keyCode==115){BtnReadCardHandler();return false;}	//F4,读卡  
 	if(event.keyCode==118){QueryPY();return false;}	//F7,查找  
 	if(event.keyCode==120){BtnRePrintHandler();return false;}	//F9,打印 
 	if(event.keyCode==121){InitCondition();return false;}	//F10,清空 
 	if(event.keyCode==119){BtnPYHandler();return false;}	//F8,配药  
}); 