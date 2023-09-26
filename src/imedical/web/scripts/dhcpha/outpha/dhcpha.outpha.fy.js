/*
模块:门诊药房
子模块:门诊药房-配药
createdate:2016-04-25
creator:yunhaibao
*/
var commonOutPhaUrl='DHCST.OUTPHA.ACTION.csp';
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var hisPatNoLen=0;
var hisCardNoLen=0;
var LocIsCY="";
$(function(){
	InitTitle();
	InitCardType();
	InitFYList();
	InitFYListItm();
	InitNeedFYList();
	QueryNeedFYList();
	$('#btnClear').bind("click",InitCondition);  
	$('#btnFind').bind("click",QueryFY); 
	$('#btnReadCard').bind("click",BtnReadCardHandler); 
	$('#btnFYSure').bind("click",BtnFYHandler); //发药
	$('#btnAllFYSure').bind("click",BtnAllFYHandler); //发药
	$('#btnRefuse').bind("click",BtnRefuseHandler); //拒绝发药
	$('#btnCancelRefuse').bind("click",BtnCancelRefuseHandler); //撤销拒绝发药
	$('#btnRePrint').bind("click",BtnRePrintHandler); //补打	 
	$('#btnRePrintLabel').bind("click",BtnRePrintLabelHandler); //补打标签	 
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
	InitComputerIp();
});
function InitTitle(){
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: commonOutPhaUrl+'?action=GetDescFromId',//提交到那里 后他的服务  
		data: "gphl="+gphl+"&gpyphw="+""+"&gpydr="+gpydr+"&gfydr="+gfydr+"&gpos="+gpos+"&gfyphw="+gphw,//提交的参数  
		success:function(value){     
			if (value!=""){
				var getdescarr=value.split("^");
				$('#currentLoc').text(getdescarr[0]);
				$('#currentWin').text(getdescarr[5]);
				$('#fyUser').text(getdescarr[3]);
			}
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
	$("#startDate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0));  //Init结束日期
	$("#patNo").val("");
	$("#cardNo").val("");
	$("input[type='checkbox'][id=checkedFY]").removeAttr("checked");
	$('#fygrid').datagrid('loadData',{total:0,rows:[]}); 
	$('#fydetailgrid').datagrid('loadData',{total:0,rows:[]});
	$('#fygrid').datagrid('options').queryParams.params = "";  
	$('#fydetailgrid').datagrid('options').queryParams.params = "";  
}

function InitFYList(){
		//定义columns
	var columns=[[
		{field:"TPatName",title:'姓名',width:80},
		{field:"TPmiNo",title:'登记号',width:80},
		{field:'TPrtDate',title:'收费日期',width:80},
		{field:'TFyFlag',title:'发药',width:40},
		{field:'TPrtInv',title:'收据号',width:80},
		{field:'TPrt',title:'TPrt',width:50,hidden:true},	
		{field:'TPrescNo',title:'处方号',width:100},
		{field:'TPrescMoney',title:'处方金额',width:80},	
		{field:'TPerSex',title:'性别',width:50},
		{field:'TPerAge',title:'年龄',width:50},
		{field:'TMR',title:'诊断',width:150},			
		{field:'TPatID',title:'TPatID',width:100,hidden:true},	
		{field:'TJyType',title:'煎药类型',width:100},	
		{field:'TPrescTitle',title:'TPrescTitle',width:100,hidden:true},	
		{field:'phdrow',title:'phdrow',width:100,hidden:true},
		{field:'TPyCode',title:'配药人',width:100,hidden:true},	
		{field:'TFyDate',title:'发药日期',width:100}	,	
		{field:'TDocSS',title:'审核状态',width:100,
			formatter: function(value,row,index){
				return  '<span style="color:red" >'+ value+'</span>';
			}
		},
		{field:'TEncryptLevel',title:'病人密级',width:100},		
		{field:'TPatLevel',title:'病人级别',width:100}			
	]];
	
	//定义datagrid
	$('#fygrid').datagrid({
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
				if (row.TFyFlag=="OK"){
                    return 'color:#ff0066;font-weight:bold';
                } 
		},
		onLoadSuccess: function(){
         	//选中第一
         	if ($('#fygrid').datagrid("getRows").length>0){
	         	$('#fygrid').datagrid("selectRow", 0)
	         	QueryFYSub();
         	}
         	
	    },
	    onSelect:function(rowIndex,rowData){
		   QueryFYSub();
		   
	    }

	});
	$('#fygrid').gridupdown($('#fygrid'));
}
function InitFYListItm()
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
	$('#fydetailgrid').datagrid({
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
function InitNeedFYList()
{
	var columns1=[[
		{field:'tbname',title:'姓名',width:80},
		{field:'tbpatid',title:'登记号',width:80},	
		{field:'TEncryptLevel',title:'病人密级',width:80},
		{field:'TPatLevel',title:'病人级别',width:80}	
	]];
	//定义datagrid
	$('#needfylist').datagrid({
		border:false,
		url:commonOutPhaUrl+"?action=QueryNeedFYList",
		fit:true,
		//rownumbers:true,
		columns:columns1,
	    //singleSelect:true,
	    method:'post',
		loadMsg: '正在加载信息...',
		singleSelect: true,
		pageSize: 30,
        pageList: [30,50,100],
		pagination:true,
		onClickRow:function(rowIndex,rowData){
			if (rowData){
				var patno=rowData['tbpatid'];
				$("#patNo").val(patno);
				QueryFY();
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
	QueryFY();
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
//查询发药列表
function QueryFY(){
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
	var checkedFy=""
	$("input[type=checkbox][id=checkedFY]").each(function(){
		if($('#'+this.id).is(':checked')){
			checkedFy=this.value;
		}
	})
	var specialId=""
	var prescno=""
	var cludeflag=""
	var params=startDate+"^"+endDate+"^"+gphl+"^"+gphw+"^"+patNo+"^"+patName
	+"^"+cludeflag+"^"+prescno+"^"+checkedFy+"^"+specialId;
	$('#fygrid').datagrid({
		url:commonOutPhaUrl+'?action=jsQueryFYList',	
		queryParams:{
			params:params}
	});
	
}
//查询发药明细
function QueryFYSub(){
	var selecteddata = $('#fygrid').datagrid('getSelected');
	if(selecteddata==null){
		return;	
	}
	var prt=selecteddata["TPrt"];
	var prescno=selecteddata["TPrescNo"];
	var phdrow=selecteddata["phdrow"];
	var params=gphl+"^"+prt+"^"+prescno;
	$('#fydetailgrid').datagrid({
		url:commonOutPhaUrl+'?action=QueryDispListDetail',	
		queryParams:{
			params:params}
	});
}
//查询待发药列表,仅当天
function QueryNeedFYList(){
	var params=gphl+"^"+gphw+"^"+""
    $('#needfylist').datagrid('options').queryParams.params = params;//传递值  
    $("#needfylist").datagrid('reload');//重新加载table  
	var fylistpager = $('#needfylist').datagrid('getPager'); 
	fylistpager.pagination({  
		beforePageText:'',
		afterPageText:'/{pages}', 
  		displayMsg:''  
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
		QueryFY();
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
		QueryFY();
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
		QueryFY();		
 	}	
}
//发药按钮触发
function BtnFYHandler(){
	if (CheckBeforeDoSth()==false){return;}
	var selecteddata = $('#fygrid').datagrid('getSelected');;
	DispensingMonitor(selecteddata);	
}
//打印处方
function BtnRePrintHandler(){
	if (CheckBeforeDoSth()==false){return;}
	var selecteddata = $('#fygrid').datagrid('getSelected');
	var phdrow=selecteddata["phdrow"];
	PrintPrescCom(phdrow,LocIsCY,"")
}
//打印标签
function BtnRePrintLabelHandler(){
	if (CheckBeforeDoSth()==false){return;}
	var selecteddata = $('#fygrid').datagrid('getSelected');
	var prt=selecteddata["TPrt"];
	var prescno=selecteddata["TPrescNo"];
	PrintPrescLabelCom(gLocId,prt,prescno)
}
function BtnRefuseHandler(){
	if (CheckBeforeDoSth()==false){return;}
	var selecteddata = $('#fygrid').datagrid('getSelected');
	var selectedrow=$('#fygrid').datagrid("getRowIndex",selecteddata);
	var fyflag=selecteddata["TFyFlag"];
	var prescno=selecteddata["TPrescNo"];
	if (fyflag=="OK"){
		$.messager.alert('提示',"该记录已经发药!");
		return;
	}
	var checkprescref = GetOrdRefResultByPresc(prescno);　　 //LiangQiang 2014-12-22  处方拒绝
	if (checkprescref=="N"){
		$.messager.alert("提示","该处方已被拒绝,不能重复操作!")
		return;
	}else if (checkprescref=="A"){
		$.messager.alert("提示","该处方已被拒绝,不能重复操作!")
		return;
	} 
	var checkprescadt=GetOrdAuditResultByPresc(prescno) ;
	if (checkprescadt==""){
		$.messager.alert("提示","该处方未审核,禁止操作!")
		return;
	}else if (checkprescadt!="Y"){
		$.messager.alert("提示","该处方审核未通过,禁止操作!")
		return;
	}
    var waycode ="32" //OutPhaWay;
	var retstr=showModalDialog('dhcpha.comment.selectreason.csp?orditm='+prescno+'&waycode='+waycode,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
	if (!(retstr)){return;}
	if (retstr==""){return;}
	var retarr=retstr.split("@");
    var ret="N";
	var reasondr=retarr[0];
	var advicetxt=retarr[2];
	var factxt=retarr[1];
	var phnote=retarr[3];		
	var input=ret+"^"+gUserId+"^"+advicetxt+"^"+factxt+"^"+phnote+"^"+gGroupId+"^"+prescno+"^OR"  //orditm;	
	if (reasondr.indexOf("$$$")=="-1"){
		reasondr=reasondr+"$$$"+prescno ;
	}
	var refuseret=tkMakeServerCall("web.DHCSTCNTSOUTMONITOR","SaveOPAuditResult",reasondr,input)
    if(refuseret==0){
		$('#fygrid').datagrid('updateRow',{
			index: selectedrow,
			row: {TDocSS:'拒绝发药'}
		});
    }else{
	    $.messager.alert("提示","拒绝失败!错误代码:"+refuseret)
		return;
    }
	
}
function BtnCancelRefuseHandler(){
	if (CheckBeforeDoSth()==false){return;}
	///检查是否有拒绝发药权限
    var refauthority=tkMakeServerCall("web.DHCSTCNTSOUTMONITOR","CheckFyUserAuthority",gphl,gfydr);
    if (refauthority=="0"){
	    $.messager.alert("提示","该用户没有操作权限,请以上级用户身份撤销!");
		return;
    }
 	var selecteddata = $('#fygrid').datagrid('getSelected');
	var selectedrow=$('#fygrid').datagrid("getRowIndex",selecteddata);
	var fyflag=selecteddata["TFyFlag"];
	var prescno=selecteddata["TPrescNo"];
	if (fyflag=="OK"){
		$.messager.alert('提示',"该记录已经发药!");
		return;
	}
	var checkprescref = GetOrdRefResultByPresc(prescno);　　 //LiangQiang 2014-12-22  处方拒绝
	if ((checkprescref!="N")&&(checkprescref!="A")){
		if (checkprescref=="S"){
			$.messager.alert("提示","该处方医生已提交申诉,不需要撤销!")
			return;
		}else{
			$.messager.alert("提示","该处方未被拒绝,不能撤销操作!")
			return;
		}
	}
	var cancelrefuseret=tkMakeServerCall("web.DHCSTCNTSOUTMONITOR","CancelRefuse",gUserId,prescno,"OR");
	if (cancelrefuseret == "0"){
		$('#fygrid').datagrid('updateRow',{
			index: selectedrow,
			row: {TDocSS:''}
		});
	}
	else if (cancelrefuseret == "-2"){
		$.messager.alert("提示","该处方未被拒绝,不能撤销操作!");
	}else if (retval == "-3"){
		$.messager.alert("提示","该处方已撤销,不能再次撤销!");
	}
}
function BtnAllFYHandler(){	
	var fygridrowsdata=$('#fygrid').datagrid("getRows");
	var fygridrows=fygridrowsdata.length;
	if (fygridrows<=0){
		$.messager.alert('提示',"没有数据!");
		return;
	}
	for(var rowi=0;rowi<fygridrows;rowi++){
		DispensingMonitor(fygridrowsdata[rowi]);		
	} 

}
function CheckBeforeDoSth(){
	if ($('#fygrid').datagrid("getRows").length<=0){
		$.messager.alert('提示',"没有数据!");
		return false;
	}
	var selecteddata = $('#fygrid').datagrid('getSelected');
	if(selecteddata==null){
		$.messager.alert('提示',"没有选中数据!");
		return false;	
	}
	return true
}
//DispensingMonitor.发药用同步
function DispensingMonitor(dispselectdata){
	var selectedrow=$('#fygrid').datagrid("getRowIndex",dispselectdata);
	var prescno=dispselectdata["TPrescNo"];
	var fyflag=dispselectdata["TFyFlag"];
	var patname=dispselectdata["TPatName"];
	var warnmsgtitle="病人姓名:"+patname+"\t"+"处方号:"+prescno+"\n"
	if (fyflag=="OK"){
		alert(warnmsgtitle+"该记录已经发药!");
		return;
	}
	var prt=dispselectdata["TPrt"];
	var checkprescadt=GetOrdAuditResultByPresc(prescno)
	if (checkprescadt==""){
		alert(warnmsgtitle+"请先审核!");
		return;
    }else if (checkprescadt=="N"){
		alert(warnmsgtitle+"审核不通过,不允许发药!");
		return;
	}else if (checkprescadt=="S"){
		if(!confirm(warnmsgtitle+"该处方医生已提交申诉\n点击'确定'将同意申诉继续发药，点击'取消'将放弃发药操作。")){
			return;
		} 
	}
	var checkprescref=GetOrdRefResultByPresc(prescno)
	if (checkprescref=="N"){
		alert(warnmsgtitle+"该处方已被拒绝,禁止发药!");
		return;
    }else if (checkprescref=="A"){
		alert(warnmsgtitle+"该处方已被拒绝,禁止发药!");
		return;
	}else if (checkprescref=="S"){
		if(!confirm(warnmsgtitle+"该处方医生已提交申诉\n点击'确定'将同意申诉继续发药，点击'取消'将放弃发药操作。")){
			return;
		} 
	}
	var retval=tkMakeServerCall("web.DHCOutPhDisp","UpdatePyd",prt,gphl,"",gfydr,prescno,"",gphw,"","")
	if (retval==-20){
		alert(warnmsgtitle+"该处方已作废,不能发药!")
		return;
	}else if (retval==-21){
		alert(warnmsgtitle+"该处方药品已发,不能重复发药")
		return;
	}else if (retval==-4){
		alert(warnmsgtitle+"该处方医嘱已停,不能发药")
		return;
	}else if (retval==-7){
		alert(warnmsgtitle+"发药失败原因: 库存不足,请核查")
		return;
	}else if (retval==-24){
		alert(warnmsgtitle+"发药失败原因: 库存不足,请核查")
		return;
	}else if (retval==-123){
		alert(warnmsgtitle+"该处方未做皮试或皮试结果阳性")
		return;
	}else if (retval<0){
		alert(warnmsgtitle+"发药失败,错误代码: "+retval)
		return;
	}else if (!(retval>0)){
		alert(warnmsgtitle+"发药失败,错误代码: "+retval)
		return;
	}
	$('#fygrid').datagrid('updateRow',{
		index: selectedrow,
		row: {TFyFlag:'OK'}
	});
}

 //获取处方拒绝结果 
function GetOrdRefResultByPresc(prescno)
{
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdRefResultByPresc",prescno);
	return ref;
}
 //获取处方审核结果 
function GetOrdAuditResultByPresc(prescno)
{
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdAuditResultByPresc",prescno);
	return ref;
}
function InitComputerIp() 
{
   var ipAddr="";
   var locator = new ActiveXObject ("WbemScripting.SWbemLocator");  
   var service = locator.ConnectServer("."); //连接本机服务器
   var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration");  //查询使用SQL标准 
   var e = new Enumerator (properties);
   var p = e.item ();
   for (;!e.atEnd();e.moveNext ())  
   {
	  	var p = e.item ();  
		ipAddr=p.IPAddress(0); 
		if(ipAddr) break;
	}
	$("#ipAddress").text(ipAddr)
}
$(document).keydown(function(event){
 	if(event.keyCode==115){BtnReadCardHandler();return false;}	//F4,读卡  
 	if(event.keyCode==118){QueryFY();return false;}	//F7,查找  
 	if(event.keyCode==120){BtnRePrintHandler();return false;}	//F9,打印 
 	if(event.keyCode==121){InitCondition();return false;}	//F10,清空 
 	if(event.keyCode==119){BtnFYHandler();return false;}	//F8,配药  
}); 