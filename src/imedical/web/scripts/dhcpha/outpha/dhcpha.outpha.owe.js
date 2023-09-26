/*
模块:门诊药房
子模块:门诊药房-欠药单管理
createdate:2016-05-27
creator:yunhaibao
*/

var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var gPhLocId=tkMakeServerCall("web.DHCOutPhCommon","GetPhlFrmLoc",gLocId);
var gPyUserId=tkMakeServerCall("web.DHCOutPhCommon","GetPhPerson",gUserId);
var hisPatNoLen=0;
var hisCardNoLen=0;
var inciRowId="";
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
	InitOweList();
	InitOweListItm();
	$('#patNo').bind('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#patNo").val());
			if (patno!=""){
				GetWholePatID(patno);
			}	
		}
	});
	$('#inciDesc').bind('keypress',function(event){
		if(event.keyCode == "13"){
			var input=$.trim($("#inciDesc").val());
			if (input!=""){
				var mydiv = new IncItmDivWindow($("#inciDesc"), input,getDrugList);
				mydiv.init();
			}else{
				inciRowId="";
			}	
		}
	});
	$('#btnClear').bind("click",InitCondition);  
	$('#btnFind').bind("click",QueryOwe); 
	$('#btnReadCard').bind("click",BtnReadCardHandler); 
	$('#btnFYSure').bind("click",BtnFYHandler); //发药
	$('#btnTYSure').bind("click",BtnTYHandler); //退药
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
	$("#patName").val("");
	$("#cardNo").val("");
	$("#prescNo").val("");
	inciRowId="";
	$("#inciDesc").val("");
	$('#oweStat').combobox("setValue","");
	$('#owegrid').datagrid('loadData',{total:0,rows:[]}); 
	$('#owedetailgrid').datagrid('loadData',{total:0,rows:[]});
	$('#owegrid').datagrid('options').queryParams.params = "";  
	$('#owedetailgrid').datagrid('options').queryParams.params = "";  
}

function InitOweList(){
		//定义columns
	var columns=[[
		{field:"TPatName",title:'姓名',width:80},
		{field:"TPmiNo",title:'登记号',width:80},
		{field:'TPrtDate',title:'收费日期',width:80},
		{field:'TPrtInv',title:'收据号',width:80},
		{field:'TPrt',title:'TPrt',width:50,hidden:true},
		{field:'TOweStatusdesc',title:'欠药状态',width:60,align:'center'},
		{field:'TPrescNo',title:'处方号',width:100},
		{field:'TPrescMoney',title:'处方金额',width:80},	
		{field:'TPerSex',title:'性别',width:50},
		{field:'TPerAge',title:'年龄',width:50},
		{field:'TMR',title:'诊断',width:150},			
		{field:'TPerLoc',title:'科室',width:150},			
		{field:'TPatID',title:'TPatID',width:100,hidden:true},	
		{field:'TJyType',title:'煎药类型',width:100,hidden:true},	
		{field:'TPrescType',title:'费别',width:100},	
		{field:'Tphdrowid',title:'Tphdrowid',width:100,hidden:true},	
		{field:'TCallCode',title:'TCallCode',width:100,hidden:true},
		{field:'TOweDate',title:'欠药时间',width:150},
		{field:'TOweUser',title:'欠药人',width:80},
		{field:'TOwedr',title:'TOwedr',width:80,hidden:true},
		{field:'TOweretdate',title:'退药时间',width:150},
		{field:'TOweretuser',title:'退药人',width:80},
		{field:'TEncryptLevel',title:'病人密级',width:100},		
		{field:'TPatLevel',title:'病人级别',width:100}			
	]];
	
	//定义datagrid
	$('#owegrid').datagrid({
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
			if (row.TOweStatusdesc=="已发药"){
	            return 'color:#ff0066;font-weight:bold';
	        }else if(row.TOweStatusdesc=="已退药"){
				return 'color:#00cc00;font-weight:bold';
	        }		   
		},
		onLoadSuccess: function(){
         	//选中第一
         	if ($('#owegrid').datagrid("getRows").length>0){
	         	$('#owegrid').datagrid("selectRow", 0)
	         	QueryOweSub();
         	}
         	else{
	        	$('#owedetailgrid').datagrid('loadData',{total:0,rows:[]}); 
				$('#owedetailgrid').datagrid('options').queryParams.params = ""; 
	        }
         	
	    },
	    onSelect:function(rowIndex,rowData){
		   currEditRow=undefined
		   QueryOweSub();
		   
	    }

	});
	$('#owegrid').gridupdown($('#owegrid'));
}
function InitOweListItm()
{
	var columns=[[
		{field:'TPhDesc',title:'药品名称',width:200},
		{field:'TPhQty',title:'数量',width:80,align:'center',
			formatter: function(value,row,index){
				return  '<span style="font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ value+'</span>';
			}
		},
		{field:'TDispedqty',title:'已发数量',width:80},
		{field:'TRealQty',title:'预发数量',width:80,align:'center',
			editor:{
			type:'numberbox',
				options:{
					precision:2
				}
			},
			formatter: function(value,row,index){
				return  '<span style="color:red;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ value+'</span>';
			}
		},
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
		{field:'TDX',title:'TDX',width:80,hidden:true}	
	]];
	
	//定义datagrid
	$('#owedetailgrid').datagrid({
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
		},
		onClickCell: function (rowIndex, field, value) {
			if (field!="TRealQty"){
				return;
			}
			var selecteddata = $('#owegrid').datagrid('getSelected');
			var owestat=selecteddata["TOweStatusdesc"];
			if (owestat=="已发药"){
				$.messager.alert('提示',"该记录已发药!","info");
				return
			}
			if (owestat=="已退药"){
				$.messager.alert('提示',"该记录已退药!","info");
				return
			}
			if (rowIndex != currEditRow) {
	        	if (endEditing()) {
					$("#owedetailgrid").datagrid('beginEdit', rowIndex);
					var realQtyEdt=	$('#owedetailgrid').datagrid('getEditor', { index: rowIndex, field: 'TRealQty' });
		     	    realQtyEdt.target.focus();
		     	    realQtyEdt.target.select();
					$(realQtyEdt.target).bind("blur",function(){
	                	endEditing();    
	            	});
					currEditRow=rowIndex;  
	        	}
			}
		}
	});
}
var endEditing = function () {
    if (currEditRow == undefined) { return true }
    if ($('#owedetailgrid').datagrid('validateRow', currEditRow)) {
        var ed = $('#owedetailgrid').datagrid('getEditor', { index: currEditRow, field: 'TRealQty' });
        var realqty = $(ed.target).numberbox('getValue');
        $('#owedetailgrid').datagrid('updateRow',{
			index: currEditRow,
			row: {TRealQty:realqty}
		});
        $('#owedetailgrid').datagrid('endEdit', currEditRow);
        currEditRow = undefined;
        return true;
    } else {
        return false;
    }
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
	QueryOwe();
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
function getDrugList(returndata){
	if (returndata["Inci"]>0){
		$("#inciDesc").val(returndata["InciDesc"]);
		inciRowId=returndata["Inci"];
	}
	else{
		$("#inciDesc").val("");
		inciRowId="";
	}
}
//查询发药列表
function QueryOwe(){
	var startDate=$('#startDate').datebox('getValue');
	if (startDate==""){
		$.messager.alert('错误提示',"请输入起始日期!");
		return;
	}
	var endDate=$('#endDate').datebox('getValue');
	if (endDate==""){
		$.messager.alert('错误提示',"请输入截止日期!");
		return;
	}
	var patNo=$("#patNo").val();
	var patName="";
	var prescNo=$("#prescNo").val();
	var oweStat=$("#oweStat").combobox("getValue");
	var disped=0,returned=0;
	if(oweStat=="1"){
		disped=1;;
	}else if(oweStat=="0"){
		returned=1
	}
	if ($.trim($("#inciDesc").val())==""){
		inciRowId="";
	}
	var gphw="",gphl="",printed="0";
	var params=startDate+"^"+endDate+"^"+gLocId+"^"+gphw+"^"+patNo+"^"+printed
	+"^"+disped+"^"+returned+"^"+prescNo+"^"+patName+"^"+inciRowId;
	$('#owegrid').datagrid({
		url:commonOutPhaUrl+'?action=QueryOweList',	
		queryParams:{
			params:params}
	});
	
}
//查询发药明细
function QueryOweSub(){
	var selecteddata = $('#owegrid').datagrid('getSelected');
	if(selecteddata==null){
		return;	
	}
	var phdowerow=selecteddata["TOwedr"];
	var params=phdowerow;
	$('#owedetailgrid').datagrid({
		url:commonOutPhaUrl+'?action=QueryOweListDetail',	
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
		QueryOwe();
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
		QueryOwe();
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
		QueryOwe();		
 	}	
}
//确认发药按钮触发
function BtnFYHandler(){
	if (CheckBeforeDoSth()==false){return;}
	var selecteddata = $('#owegrid').datagrid('getSelected');
	OweDispMonitor(selecteddata,"");	
}
//执行退药按钮触发
function BtnTYHandler(){
	if (CheckBeforeDoSth()==false){return;}
	var selecteddata = $('#owegrid').datagrid('getSelected');
	var gpydr=gPyUserId;
	var prescno=selecteddata["TPrescNo"];
	var owedr=selecteddata["TOwedr"];
	var retval=tkMakeServerCall("web.DHCOutPhOweList","ExcRetrun",gpydr,prescno,owedr);
	if (retval==-1){
		$.messager.alert("提示","该欠药单状态已处理,不能退药!","info");
		return;
	}else if (retval==-2){
		$.messager.alert("提示","该欠药单状态已处理,不能重复退药!","info")
		return;
	}else if (retval==-4){
		$.messager.alert("提示","该处方还未发药,请取消配药单,不能执行退药!","info")
		return;
	}else if (retval<0){
		$.messager.alert("提示","退药失败:"+retval,"error")
		return;
	} 
	$.messager.alert("提示","欠药退药成功,请到收费处退费!"); 
	var selectedrow=$('#owegrid').datagrid("getRowIndex",selecteddata);
	$('#owegrid').datagrid('updateRow',{
		index: selectedrow,
		row: {TOweStatusdesc:'已退药'}
	});	
}
function CheckBeforeDoSth(){
	if (($('#owegrid').datagrid("getRows").length<=0)||($('#owedetailgrid').datagrid("getRows").length<=0)){
		$.messager.alert('提示',"没有数据!","info");
		return false;
	}
	var selecteddata = $('#owegrid').datagrid('getSelected');
	if(selecteddata==null){
		$.messager.alert('提示',"没有选中数据!","info");
		return false;	
	}
	return true
}
//OweDispMonitor 欠药处理
function OweDispMonitor(oweselectdata,updflag){
	var selectedrow=$('#owegrid').datagrid("getRowIndex",oweselectdata);
	var prescno=oweselectdata["TPrescNo"];
	var owestat=oweselectdata["TOweStatusdesc"];
	var patname=oweselectdata["TPatName"];
	var warnmsgtitle="病人姓名:"+patname+"\t"+"处方号:"+prescno+"\n"
	if ((owestat=="已发药")||(owestat=="已退药")){
		$.messager.alert("提示",warnmsgtitle+"该记录"+owestat+"!","info");
		return;
	}
	var dispQtyString=""
	var updflag=""
	if (updflag==""){ //全发时此标志为U
		var owedetailgridrowsdata=$('#owedetailgrid').datagrid("getRows");
		var owedetailgridrows=owedetailgridrowsdata.length;
		if (owedetailgridrows<=0){
			$.messager.alert('提示',"没有明细数据!");
			return;
		}
		var chkflag=0,allowe=1
		var dispQtyString=0
		for(var rowi=0;rowi<owedetailgridrows;rowi++){
			var oeoriQty=owedetailgridrowsdata[rowi]["TPhQty"]
			var realQty=owedetailgridrowsdata[rowi]["TRealQty"]
			oeoriQty=$.trim(oeoriQty);
			realQty=$.trim(realQty);
			if(parseFloat(realQty)>parseFloat(oeoriQty)){
				$.messager.alert('提示',"实发数量不能大于医嘱数量!");
				return;
			}
			if (parseFloat(realQty)<0){
				$.messager.alert('提示',"实发数量不能小于0!");
				return;
			}
			if (parseFloat(realQty)!=parseFloat(oeoriQty)){
				chkflag="1";
			}
			if (allowe!=0) {allowe=0}
			var oeori=owedetailgridrowsdata[rowi]["TOrditm"]
			var unit=owedetailgridrowsdata[rowi]["TUnit"]
			var tmpdispstring=oeori+"^"+realQty+"^"+oeoriQty+"^"+unit
			if (dispQtyString==0){
				dispQtyString=tmpdispstring
			}
			else{
				dispQtyString=dispQtyString+"!!"+tmpdispstring
			}
			
		} 	
		dispQtyString=chkflag+"&&"+allowe+"&&"+dispQtyString ;
		var tmpordstr=dispQtyString.split("&&") 
		var chkord=tmpordstr[0] ;
		ChkAllOweFlag=tmpordstr[1] ;  //是否全部欠药
		ChkOweFlag=chkord;
		if (chkflag=="1"){
			if (confirm("是否需要生成欠药单? 点击[确定]生成点击[取消]退出")==false){
				return; 
			} 
		}			
	}
	var owedr=oweselectdata["TOwedr"];
	dispQtyString=dispQtyString+"&&"+owedr;
	var prt=oweselectdata["TPrt"];
	var gphl=gPhLocId;
	var gphw=""
	var gpydr=gPyUserId;
	var gfydr=gPyUserId;
	var prescno=oweselectdata["TPrescNo"];
	var gpos=""
	var newwin=""
	var shdr=""                                             
	var retval=tkMakeServerCall("web.DHCOutPhDisp","SAVEDATA",prt,gphl,gphw,gpydr,gfydr,prescno,gpos,shdr,newwin,dispQtyString)
	if (retval==-1){
		$.messager.alert("提示",warnmsgtitle+"该处方已作废,不能发药!","info");
		return;
	}else if (retval==-2){
		$.messager.alert("提示",warnmsgtitle+"该处方药品已发,不能重复发药","info");
		return;
	}else if (retval==-3){
		$.messager.alert("提示",warnmsgtitle+"该处方药品已发,不能重复发药","info");
		return;
	}else if (retval==-4){
		$.messager.alert("提示",warnmsgtitle+"该处方医嘱已停,不能发药","info");
		return;
	}else if (retval==-7){
		$.messager.alert("提示",warnmsgtitle+"发药失败原因: 库存不足,请核查","info");
		return;
	}else if (retval==-9){
		$.messager.alert("提示",warnmsgtitle+"该病人押金不足,请核查","info");
		return;
	}else if (retval==-24){
		$.messager.alert("提示",warnmsgtitle+"发药失败原因: 库存不足,请核查","info");
		return;
	}else if (retval==-111){
		$.messager.alert("提示",warnmsgtitle+"该处方已被拒绝,不能发药","info");
		return;
	}else if (retval==-5){
		$.messager.alert("提示",warnmsgtitle+"该欠药单状态已处理,不能重复发药!")
		return;
	}else if (retval==-27){
		$.messager.alert("提示",warnmsgtitle+"该欠药单状态已处理,不能重复发药!","info");
		return;
	}else if (retval<0){
		$.messager.alert("提示",warnmsgtitle+"发药失败,错误代码: "+retval,"info");
		return;
	}else if (!(retval>0)){
		$.messager.alert("提示",warnmsgtitle+"发药失败,错误代码: "+retval,"info");
		return;
	}
	$('#owegrid').datagrid('updateRow',{
		index: selectedrow,
		row: {TOweStatusdesc:'已发药'}
	});
}

$(document).keydown(function(event){
 	if(event.keyCode==115){BtnReadCardHandler();return false;}	//F4,读卡  
 	if(event.keyCode==118){QueryOwe();return false;}	//F7,查找  
 	if(event.keyCode==120){BtnTYHandler();return false;}	//F9,退药 
 	if(event.keyCode==121){InitCondition();return false;}	//F10,清空 
 	if(event.keyCode==119){BtnFYHandler();return false;}	//F8,发药  
}); 
