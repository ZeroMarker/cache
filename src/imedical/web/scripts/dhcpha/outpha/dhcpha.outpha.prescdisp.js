/*
模块:门诊药房
子模块:门诊药房-直接发药
createdate:2016-04-29
creator:yunhaibao
*/

var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var hisPatNoLen=0;
var hisCardNoLen=0;
var LocIsCY="";
var currEditRow=undefined; //控制行编辑
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'150'
} 
$(function(){
	InitTitle();
	InitCardType();
	InitFYList();
	InitNeedFYList();
	QueryNeedFYList();
	var basicLocCombo=new ListCombobox("basicLoc",commonOutPhaUrl+'?action=GetBasicLocList','',combooption);
	basicLocCombo.init(); //初始化基数药科室
	var EMLocCombo=new ListCombobox("EMLoc",commonOutPhaUrl+'?action=GetEMLocList','',combooption);
	EMLocCombo.init(); //初始化急诊留观科室
	$('#btnClear').bind("click",InitCondition);  
	$('#btnFind').bind("click",QueryFY); 
	$('#btnReadCard').bind("click",BtnReadCardHandler); 
	$('#btnFYSure').bind("click",BtnFYHandler); //发药
	$('#btnAllFYSure').bind("click",BtnAllFYHandler); //发药
	$('#btnRefuse').bind("click",BtnRefuseHandler); //拒绝发药
	$('#btnCancelRefuse').bind("click",BtnCancelRefuseHandler); //撤销拒绝发药
	$('#btnRePrint').bind("click",BtnRePrintHandler); //补打	 
	//$('#btnPrescAnalyse').bind("click",BtnPrescAnalyseHandler); //处方分析	 
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
	InitComputerIp();
	StartDaTongDll();
	InitCondition();
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
				$('#pyUser').text(getdescarr[2]);
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
	$("#basicLoc").combobox("setValue","");
	$("#EMLoc").combobox("setValue","");
	$("input[type='checkbox'][id=checkedFY]").removeAttr("checked");
	$('#fygrid').datagrid('loadData',{total:0,rows:[]}); 
	$('#fygrid').datagrid('options').queryParams.params = "";
	//$('#fygrid').datagrid('reload')
	$("#divReport").empty(); 
}

function InitFYList(){
		//定义columns
	var columns=[[
		{field:"TPatName",title:'姓名',width:80},
		{field:"TPmiNo",title:'登记号',width:80},
		{field:'TPrescNo',title:'处方号',width:100},
		{field:'TFyFlag',title:'发药',width:40},
		{field:'TPrtDate',title:'收费日期',width:80},
		{field:'TPrintFlag',title:'配药',width:40},
		{field:'TPrtInv',title:'收据号',width:80},
		{field:'TPrt',title:'TPrt',width:50,hidden:true},
		{field:'TWinDesc',title:'窗口',width:80},
		{field:'TPrescMoney',title:'处方金额',width:80},	
		{field:'TPatSex',title:'性别',width:50},
		{field:'TPatAge',title:'年龄',width:50},
		{field:'TMR',title:'诊断',width:150},			
		{field:'TPatID',title:'TPatID',width:100,hidden:true},	
		{field:'TJyType',title:'煎药类型',width:100},	
		{field:'TPrescTitle',title:'TPrescTitle',width:100,hidden:true},	
		{field:'Tphd',title:'Tphd',width:100,hidden:true},	
		{field:'TPyCode',title:'配药人',width:100,hidden:true},	
		{field:'TPid',title:'TPid',width:100,hidden:true},	
		{field:'TFyDate',title:'发药日期',width:100}	,	
		{field:'TDocSS',title:'审核状态',width:100,
			formatter: function(value,row,index){
				return  '<span style="color:red" >'+ value+'</span>';
			}
		},
		{field:"TPassCheck",title:'合理用药',width:60,
			formatter:function(value,row,index){
				if ((value=="")||(value==undefined)){
					return "";
				}else{
					if (value == "0") {
						var imgname = "greenlight.gif";
					}else if (value == "1") {
						var imgname = "yellowlight.gif";
					}else if (value == "2") {
						var imgname = "blacklight.gif";
					}
					var str = "<img id='DrugUseImg" + index + "'" + " src='../scripts/dhcpha/img/" + imgname + "'>";
					return str
				}
			}
		},
		{field:'TPatLoc',title:'科室',width:100},
		{field:'TOrdGroup',title:'协定处方',width:100},	
		{field:'TUseLocdr',title:'TUseLocdr',width:100,hidden:true},	
		{field:'TRecLocdesc',title:'接收科室',width:100},	
		{field:'TEncryptLevel',title:'病人密级',width:100},		
		{field:'TPatLevel',title:'病人级别',width:100}			
	]];
	
	//定义datagrid
	$('#fygrid').datagrid({
		border:false,
		url:commonOutPhaUrl,
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
         	}
         	else{
				$("#divReport").empty();
	        }
         	
	    },
	    onSelect:function(rowIndex,rowData){
		    currEditRow=undefined;
			var phdrowid=rowData["Tphd"];
			var prescno=rowData["TPrescNo"];
			var cyflag=LocIsCY;
			var	prtrowid=rowData["TPrt"];
			var phlrowid=gphl;
			var paramsstr=phdrowid+"^"+prescno+"^"+prtrowid+"^"+phlrowid+"^"+cyflag
			$("#divReport").empty();
			frm_onload(paramsstr)	
	    }

	});
	$('#fygrid').gridupdown($('#fygrid'));
}
function InitNeedFYList()
{
	var columns=[[
		{field:'tbname',title:'姓名',width:80},
		{field:'tbpatid',title:'登记号',width:80},	
		{field:'TEncryptLevel',title:'病人密级',width:80},
		{field:'TPatLevel',title:'病人级别',width:80}	
	]];
	
	//定义datagrid
	$('#needfylist').datagrid({
		border:false,
		url:commonOutPhaUrl,
		fit:true,
		//rownumbers:true,
		columns:columns,
	    singleSelect:true,
	    method:'post',
		loadMsg: '正在加载信息...',
		singleSelect: true,
		selectOnCheck: true, 
		checkOnSelect: true,
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
	var basicLocId=$('#basicLoc').combobox("getValue");
	var EMLocId=$('#EMLoc').combobox("getValue");
	if ($('#basicLoc').combobox("getText")==""){
		basicLocId=""
	}
	if ($('#EMLoc').combobox("getText")==""){
		EMLocId=""
	}
	var params=startDate+"^"+endDate+"^"+gphl+"^"+gphw+"^"+patNo+"^"+patName
	+"^"+gpydr+"^"+gfydr+"^"+gpos+"^"+checkedFy+"^"+EMLocId+"^"+basicLocId
	$('#fygrid').datagrid('options').queryParams.action = "QueryDispList"; 
    $('#fygrid').datagrid('options').queryParams.params = params; 
    $("#fygrid").datagrid('reload');//重新加载table  
	var fygridpager = $('#fygrid').datagrid('getPager'); 
	fygridpager.pagination({  
		beforePageText:'',
		afterPageText:'/{pages}', 
  		displayMsg:''  
	});

}

//查询待发药列表,仅当天
function QueryNeedFYList(){
	var params=gphl+"^"+gphw+"^"+"1"
	$('#needfylist').datagrid('options').queryParams.action = "QueryNeedFYList";//传递值  
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
	var basicLocId=$("#basicLoc").combobox("getValue")
	if ((basicLocId!="")&&(basicLocId!="undefined")){
		 $.messager.alert("提示","您选择的记录为基数药,请使用全发功能生成补货单!")
		 return ;
	}
	var selecteddata = $('#fygrid').datagrid('getSelected');
	DispensingMonitor(selecteddata,"");	
	ChkUnFyOtherLoc();
}
function BtnRePrintHandler(){
	if (CheckBeforeDoSth()==false){return;}
	var selecteddata = $('#fygrid').datagrid('getSelected');
	var phdrow=selecteddata["Tphd"];
	PrintPrescCom(phdrow,LocIsCY,"")
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
		$.messager.alert("提示","撤销成功!");
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
	//发放基数药品,产生基数药补货清单
	var uselocdr=fygridrowsdata[0]["TUseLocdr"];
	if (uselocdr!=""){
		var confirmtext=confirm("确认全发吗?系统将全部发放查询出的所有处方并汇总生成补货单!")
		if (confirmtext==false) return ;
		var pid=fygridrowsdata[0]["TPid"];
        var dispbasemedret=tkMakeServerCall("web.DHCOutPhDisp","SAVESUPPDATA",pid,gfydr,gphl)
        if (dispbasemedret>0){
	        PrintPrescCom("","",dispbasemedret);
	        QueryFY();
        }
        else{
		    $.messager.alert('提示',"基数药品发药失败,错误代码:"+dispbasemedret);
	    }
		return;
	}
	var confirmtext=confirm("确认全发吗?系统将全部发放查询出的所有处方!")
	if (confirmtext==false) return ;
	for(var rowi=0;rowi<fygridrows;rowi++){
		DispensingMonitor(fygridrowsdata[rowi],"U");		
	}
	ChkUnFyOtherLoc(); //检测其他科室 
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
function DispensingMonitor(dispselectdata,updflag){
	var selectedrow=$('#fygrid').datagrid("getRowIndex",dispselectdata);
	var prescno=dispselectdata["TPrescNo"];
	var fyflag=dispselectdata["TFyFlag"];
	var patname=dispselectdata["TPatName"];
	var warnmsgtitle="病人姓名:"+patname+"\t"+"处方号:"+prescno+"\n"
	if (fyflag=="OK"){
		alert(warnmsgtitle+"该记录已经发药!");
		return;
	}
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
	var dispQtyString=""
	var prt=dispselectdata["TPrt"];
	var newwin=""
	var shdr=""                                             
	var retval=tkMakeServerCall("web.DHCOutPhDisp","SAVEDATA",prt,gphl,gphw,gpydr,gfydr,prescno,gpos,shdr,newwin,dispQtyString,updflag)
	if (retval==-1){
		alert(warnmsgtitle+"该处方已作废,不能发药!")
		return;
	}else if (retval==-2){
		alert(warnmsgtitle+"该处方药品已发,不能重复发药")
		return;
	}else if (retval==-3){
		alert(warnmsgtitle+"该处方药品已发,不能重复发药")
		return;
	}else if (retval==-4){
		alert(warnmsgtitle+"该处方医嘱已停,不能发药")
		return;
	}else if (retval==-7){
		alert(warnmsgtitle+"发药失败原因: 库存不足,请核查")
		return;
	}else if (retval==-9){
		alert(warnmsgtitle+"该病人押金不足,请核查")
		return;
	}else if (retval==-24){
		alert(warnmsgtitle+"发药失败原因: 库存不足,请核查")
		return;
	}else if (retval==-111){
		alert(warnmsgtitle+"该处方已被拒绝,不能发药")
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
	$('#fygrid').datagrid('updateRow',{
		index: selectedrow,
		row: {Tphd:retval}
	});
	PrintPrescCom(retval,LocIsCY,"")
	//ChkUnFyOtherLoc(); //检测其他科室
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
//获取其他科室未发药记录,仅读卡发药时
function ChkUnFyOtherLoc()
{
	var startDate=$('#startDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	var patNo=$("#patNo").val();
	if((patNo=="")||(patNo==null)){
		return;
	}
	var ret=tkMakeServerCall("web.DHCOutPhAdd","ChkUnFyOtherLoc",startDate,endDate,patNo,gphl)
	if(ret==-1){
		//alert("病人为空,请读卡")
	}
	else if(ret==-2)
	{
		alert("没找到登记号为"+patNo+"的病人");
		return;
		
	}
	else if((ret!="")&&(ret!=null))
	{
		alert("该病人在 "+ret+" 有药没取~！")
	}
}
 //处方分析
function BtnPrescAnalyseHandler(){
	var selecteddata = $('#fygrid').datagrid('getSelected');
	if (selecteddata==null){
		$.messager.alert('提示',"请先选中需要分析的处方!");
		return;
	}
	var fydetailgridrowsdata=$('#fydetailgrid').datagrid("getRows");
	var fydetailgridrows=fydetailgridrowsdata.length;
	if (fydetailgridrows<=0){
		$.messager.alert('提示',"没有明细数据!");
		return;
	}
	var oeoristr=""
	for(var rowi=0;rowi<fydetailgridrows;rowi++){
		var toeori=fydetailgridrowsdata[rowi]["TOrditm"];
		if (oeoristr==""){
			oeoristr=toeori;
		}else{
			oeoristr=oeoristr+"^"+toeori;
		}
	}
	if (oeoristr==""){
		return;
	}
	dtywzxUI(3, 0, "");
	var myPrescXML = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongOutPresInfo", oeoristr);
	myrtn = dtywzxUI(28676, 1, myPrescXML);
	var selectedrow=$('#fygrid').datagrid("getRowIndex",selecteddata);
    $('#fygrid').datagrid('updateRow',{
		index: selectedrow,
		row: {TPassCheck:$.trim(myrtn)}
	});
}
 //处方预览
function showPreviewPrescWindow(rowindex){
	var selecteddata=$('#fygrid').datagrid('getData').rows[rowindex];
	var phdrowid=selecteddata["Tphd"];
	var prescno=selecteddata["TPrescNo"];
	var cyflag=LocIsCY;
	var	prtrowid=selecteddata["TPrt"];
	var phlrowid=gphl;
	var lnk="dhcpha.outpha.prescpreview.csp?phdispid="+phdrowid+"&prescno="+prescno+"&cyflag="+cyflag+"&prtrowid="+prtrowid+"&phlrowid="+phlrowid;
	window.open(lnk,"处方预览","height="+document.body.clientHeight*0.95+",width="+document.body.clientWidth*0.65+",menubar=no,status=yes,toolbar=no,resizable=yes,scrollbars = yes") ;
	
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

/***************合理用药相关程序*********************/
//初始化大通
function StartDaTongDll() {
	dtywzxUI(0, 0, "");
}
//调用大通分析
function dtywzxUI(nCode, lParam, sXML) {
	var result;
	result = CaesarComponent.dtywzxUI(nCode, lParam, sXML);
	return result;
}

/****************************************************/
