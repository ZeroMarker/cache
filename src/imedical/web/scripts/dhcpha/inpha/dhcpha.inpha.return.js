/*
模块:住院药房
子模块:住院药房-直接退药
createdate:2016-05-30
creator:yunhaibao
*/
var commonInPhaUrl = "DHCST.INPHA.ACTION.csp";
var commonOutPhaUrl="DHCST.OUTPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var hisPatNoLen=0;
var currEditRow=undefined; //控制行编辑
var loadedFlag="";
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'150'
} 
$(function(){
	InitTitle();
	var retReasonCombo=new ListCombobox("retReason",commonInPhaUrl+'?action=GetInRetReason','',combooption);
	retReasonCombo.init(); //初始化配药人		
	InitPhaLoc();
    InitNeedRetList();
   	$('#patNo').bind('keypress',function(event){
        if(event.keyCode == "13"){
			var patno=$.trim($("#patNo").val());
			$("#patInfo").text("")
			if (patno!=""){
				SetPatInfo(patno);
			}
        }
    });
    $('#btnReturnByReq').bind('click',function(){
		var lnk="dhcpha.inpha.returnbyreq.csp";
   		window.open(lnk,"_target","height=600,width=900,menubar=no,status=yes,toolbar=no,resizable=yes") ;
    });
    $('#btnReturnQuery').bind('click',function(){
		var lnk="dhcpha.phareturnquery.csp";
   		window.open(lnk,"_target","height=600,width=900,menubar=no,status=yes,toolbar=no,resizable=yes") ;
    });
    $('#btnFind').bind('click',function(){
		btnFindHandler();
    });
	$('#btnClear').bind('click',btnClearHandler);
    $('#btnReturn').bind('click',function(){
		btnReturnHandler();
    });
    $('#patNo').focus();
})
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
			alert("获取登记号长度失败!");
		}
	});
	$("#startDate").datebox("setValue", formatDate(0));  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0));  //Init结束日期 
}
function InitPhaLoc(){
	$('#phaLoc').combobox({  
		width:150,
		panelWidth: 150,
		url:commonInPhaUrl+'?action=GetStockPhlocDs&groupId='+gGroupId,  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#phaLoc').combobox('getData');
            if (data.length > 0) {
            	$('#phaLoc').combobox('select', gLocId);
            } 
		}           
	});
}

//初始化药品明细列表
function InitNeedRetList(){
	//定义columns
	var columns=[[ 
	   	{field:'TWard',title:'病区',width:150},  
    	{field:'TPaNo',title:'登记号',width:80},  
    	{field:'TPaName',title:'病人姓名',width:80}, 
    	{field:'TBedNo',title:'床号',width:80}, 
    	{field:'TDesc',title:'药品名称',width:200}, 
    	{field:'TUom',title:'单位',width:80},
    	{field:'TReturnPrice',title:'单价',width:80,align:'right'},
    	{field:'TDispQty',title:'发药数量',width:80,align:'right'},
    	{field:'TReturnQty',title:'退药数量',width:80,align:'right',
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
    	{field:'TReturnAmt',title:'发药金额',width:80,align:'right'},
    	{field:'TBatchNo',title:'批号',width:80},	
    	{field:'TPrescNo',title:'处方号',width:100},	
    	{field:'TEncryptLevel',title:'病人密级',width:100},
    	{field:'TPatLevel',title:'病人级别',width:100},
    	{field:'TADMDR',title:'TADMDR',width:80,hidden:true},
    	{field:'TDspid',title:'TDspid',width:80,hidden:true},
    	{field:'TINCLBDR',title:'TINCLBDR',width:80,hidden:true},
    	{field:'TRETRQDR',title:'TRETRQDR',width:80,hidden:true},
        {field:'TOEDISDR',title:'TOEDISDR',width:80,hidden:true},
        {field:'TRECLOCDR',title:'TRECLOCDR',width:80,hidden:true},
        {field:'TDEPTDR',title:'TDEPTDR',width:80,hidden:true},
        {field:'TBEDDR',title:'TBEDDR',width:80,hidden:true}
            	   
   	]];  
	
   //定义datagrid	
   $('#needretlist').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  //rownumbers:true,
      columns:columns,
      pageSize:30,  // 每页显示的记录条数
	  pageList:[30,50,100],   // 可以设置每页记录条数的列表
	  loadMsg: '正在加载信息...',
	  onLoadSuccess: function(){
		if (currEditRow!=undefined){
			$('#needretlist').datagrid('endEdit', currEditRow);
			currEditRow = undefined
		}
		
		var rowsdata = $('#needretlist').datagrid('getRows');
		if (rowsdata.length > 0){
			loadedFlag="";
			return
		}
		else{
			if (loadedFlag!=""){
				$('#needretlist').datagrid('options').queryParams.params = "";
				$('#needretlist').datagrid('loadData',{total:0,rows:[]});
				loadedFlag="1";
			}			
		}
	  },
	  onClickCell: function (rowIndex, field, value) {
		if (field!="TReturnQty"){return;}
		var selectdata=$('#needretlist').datagrid('getData').rows[rowIndex];
		if (rowIndex != currEditRow) {
			if (endEditing(field)) {
				$("#needretlist").datagrid('beginEdit', rowIndex);
				var editor = $('#needretlist').datagrid('getEditor', {index:rowIndex,field:field});
				editor.target.focus();
				editor.target.select();
				$(editor.target).bind("blur",function(){
					endEditing(field);        
				});
				currEditRow=rowIndex;  
			}
		}
	   }  
    });
}
var endEditing = function (field) {
    if (currEditRow == undefined) { return true }
    if ($('#needretlist').datagrid('validateRow', currEditRow)) {
        var ed = $('#needretlist').datagrid('getEditor', { index: currEditRow, field: field });
		var selecteddata = $('#needretlist').datagrid('getRows')[currEditRow];
		var dispqty=selecteddata["TDispQty"]; 
		var retqty=selecteddata["TReturnQty"]; 
		var dispId=selecteddata["TDspid"];
        var inputtxt=$(ed.target).numberbox('getValue');
        var canreturn=1;
	    if (inputtxt<0){
	    	$.messager.alert('提示',"数字不能小于0!");
	    	return false;
	    }
	    if ($.trim(inputtxt)!=""){
		  	var allowret=tkMakeServerCall("web.DHCSTPHARETURN","AllowReturnByDodis","","",dispId,parseFloat(inputtxt));
		  	if (allowret=="0"){
			  	if (canreturn!=0){
		  			$.messager.alert('提示',"退药数量不能大于发药数量!");
			  	}
				canreturn=0;
		  	}
		  	var checkpartret=tkMakeServerCall("web.DHCSTPHARETURN2","GetRetParted",dispId,parseFloat(inputtxt));
			if ((checkpartret=="0")&&(canreturn!=0)){
				$.messager.alert('提示',"此记录有附加收费项目，不能部分退药!");
				canreturn=0;	
			}
			if (canreturn==0){
	  			$('#needretlist').datagrid('updateRow',{
					index: currEditRow,
					row: {TReturnQty:retqty}
				});
				currEditRow=undefined;
		  		return false;		
			}
	    }
		$('#needretlist').datagrid('updateRow',{
			index: currEditRow,
			row: {TReturnQty:inputtxt}
		});
        $('#needretlist').datagrid('endEdit', currEditRow);
        currEditRow = undefined;
        return true;
    } else {
        return false;
    }
}
function SetPatInfo(RegNo)
{    
	if (RegNo=="") {
		return;
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
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: commonInPhaUrl+'?action=GetPatInfoByNo&patNo='+RegNo,//提交到那里 后他的服务  
		data: "",
		success:function(value){     
			if ($.trim(value)!=""){
				var painfoarr=value.split("^")	;
				if (painfoarr.length >0){
					$("#patName").val(painfoarr[0]);
					$("#patSex").val(painfoarr[1]);
					$("#patAge").val(painfoarr[2]+"("+painfoarr[3]+")")
				}
				btnFindHandler();
			} else{
				alert("不存在该病人！");
				$('#patNo').focus();
				return;			
			}  
		},    
		error:function(){        
			alert("获取病人基础数据失败!");
		}
	});
}
//查询待退药列表
function btnFindHandler(){
	var startDate=$("#startDate").datebox("getValue");
	var endDate=$("#endDate").datebox("getValue");
	if ((startDate=="")||(endDate=="")){
		$.messager.alert("提示","日期不能为空!","info");
		return;
	}
	var phaLoc=$('#phaLoc').combobox("getValue");
	if ($.trim($('#phaLoc').combobox("getText"))=="") {
		phaLoc="";
		$.messager.alert("提示","药房科室为空!","info");
		return;
	}
	var patNo=$.trim($("#patNo").val());
	if (patNo==""){
		$.messager.alert("提示","请输入病人登记号!","info");
		return;
	}
	var params=startDate+"^"+endDate+"^"+patNo+"^"+phaLoc;
	$('#needretlist').datagrid({
		url:commonInPhaUrl+'?action=QueryNeedReturn',	
		queryParams:{
			params:params}
	});
	
}
//清空
function btnClearHandler(){
	$("#startDate").datebox("setValue", formatDate(0));  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0));  //Init结束日期 
	$("#patNo").val("");	
	$("#patName").val("");	
	$("#patSex").val("");	
	$("#patAge").val("");
	$("#retReason").combobox("setValue","");
	$('#needretlist').datagrid('options').queryParams.params = "";  
	$('#needretlist').datagrid('loadData',{total:0,rows:[]});	
}
//退药
function btnReturnHandler(){
	var detailrowsdata=$('#needretlist').datagrid("getRows");
	var detailrows=detailrowsdata.length;
	if (detailrows<=0){
		$.messager.alert('提示',"没有数据!","info");
		return;
	}
	var retreason=$("#retReason").combobox("getValue");
	if ($.trim($("#retReason").combobox("getText"))==""){
		retreason=""
		$.messager.alert('提示',"请选择退药原因!","info");
		return;
	}
	var reclocdr="";
	var returnstr=""
	$.each(detailrowsdata, function(index, item){
		var retqty=$.trim(item["TReturnQty"]);
		var dispId=item["TDspid"]; 
		var tmpreturndata=dispId+"^"+retqty+"^"+retreason;
		reclocdr=item["TRECLOCDR"];
		if((retqty!="")&&(retqty!=0)){
			if (returnstr==""){
		 		returnstr=tmpreturndata;	
		 	}else{
			 	returnstr=returnstr+","+tmpreturndata;
			}
		}
	})
	if (returnstr==""){
		$.messager.alert('提示',"请填入需要退药记录的退药数量!","info");
		return;	
	}
	var execret=tkMakeServerCall("web.DHCSTPHARETURN","ExecReturn",reclocdr,gUserId,"RT",returnstr)
	var execretarr=execret.split("^");
	if(execretarr[0]=="success"){
	    var RetNo=execretarr[1];
	}else{
		if (execretarr[1]==-3){  
			$.messager.alert('提示',"存在药品退药数量 >  (发药数量 - 已退药数量),请刷新后核实!","info") ;
		}else if(execretarr[1]==-12){
			$.messager.alert('提示',"存在执行记录状态不是停止执行或撤销执行的药品，不允许退药!","info") ;			 
		}else if(execretarr[1]==-9){
			$.messager.alert('提示',"存在未退申请单，不允许再使用直接退药!","info") 	;		 
		}else if(execretarr[1]==-4){
			$.messager.alert('提示',"该患者已做完最终结算，不允许退药!","info") ;	 
		}else if(execretarr[1]==-11){
			$.messager.alert('提示',"不允许退药:已经中途结算,不能退药!","info") ;	 
		}else{ 
			$.messager.alert('错误',"退药失败,错误代码:"+execretarr[1],"warning");
		}
		return ;
	}
	btnFindHandler();	
	$.messager.confirm('提示', '退药成功!是否打印?', function(r) {
    	if(r==true){
	    	PrintReturnCom(RetNo,"")
	    }else{
			return;
		}
	});
			  
}
