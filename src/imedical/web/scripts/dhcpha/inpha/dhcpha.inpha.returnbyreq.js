/*
模块:住院药房
子模块:住院药房-申请单退药
createdate:2016-05-16
creator:yunhaibao,dinghongying
*/
var commonInPhaUrl = "DHCST.INPHA.ACTION.csp";
var commonOutPhaUrl="DHCST.OUTPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var hisPatNoLen=0;
var RequestStatus="P";
var requestNoStr="";
var currEditRow=undefined; //控制行编辑
$(function(){
	InitTitle();
	InitPhaLoc();
	InitWardList();	
    InitReqList()
	InitReqDetail();	
	InitReqTotal();
   	$('#patNo').bind('keypress',function(event){
        if(event.keyCode == "13"){
			var patno=$.trim($("#patNo").val());
			$("#patInfo").text("")
			if (patno!=""){
				SetPatInfo(patno);
			}
        }
    });
    $('#checkedDocFlag').bind('click',function(){
		ChangeWardList();
    });
    $('#btnFind').bind('click',function(){
		QueryReqList();
    });
    $('#btnFindSelect').bind('click',function(){
		QuerySelectReqDetail();
    });
    $('#btnReturn').bind('click',function(){
		btnReturnHandler();
    });
    $('#reqdetail').datagrid('loadData',{total:0,rows:[]});
    $('#reqdetail').datagrid('options').queryParams.params = "";
    $('#reqtotal').datagrid('loadData',{total:0,rows:[]});
    $('#reqtotal').datagrid('options').queryParams.params = "";

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
	    },
	    onSelect:function(){
			ChangeWardList();	          
		}
	});
}
function InitWardList()
{
	$('#wardLoc').combobox({  
		width:150,
		panelWidth: 225,
		url:commonInPhaUrl+'?action=GetWardListByDocFlag',  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){         
	    }
	})
}
function ChangeWardList()
{
	$('#wardLoc').combobox("setValue","") 
	if($("#checkedDocFlag").is(':checked')){   
		var selectloc=$('#phaLoc').combobox("getValue") 
		var params=selectloc+"^"+"1"
		$('#wardLoc').combobox('reload',commonInPhaUrl+'?action=GetWardListByDocFlag&params='+params); 
	}
	else{
		InitWardList();
	}
}


//初始化申请单列表
function InitReqList(){
	//定义columns
	var columnspat=[[
	    {field:'TSelect',title:'选择',width:40,
	    	formatter:function(value,row,index){
				if (value=="Y"){
					return '<input type="checkbox" name="DispDataGridCheckbox" checked="checked" >';
				}
				else{
					return '<input type="checkbox" name="DispDataGridCheckbox" >';
				}
			}
	    },    
        {field:'TReqNo',title:'申请单号',width:150},    
        {field:'TReqDate',title:'申请日期',width:75},
        {field:'TWard',title:'病区',width:150},
        {field:'TReqOper',title:'申请人',width:60},
         ]];  
	
   //定义datagrid	
   $('#reqlist').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  selectOnCheck: true, 
	  checkOnSelect: false,
	  rownumbers:false,
      columns:columnspat,   
      pageSize:30,  // 每页显示的记录条数
	  pageList:[30,50,100],   // 可以设置每页记录条数的列表
	  loadMsg: '正在加载信息...',
	  pagination:true,
	  onClickCell: function (rowIndex, field, value) {
		if (field=="TSelect"){
			var tmpcheckvalue=""
			if (value=="Y"){tmpcheckvalue="N"}
			else{tmpcheckvalue="Y"}
			$('#reqlist').datagrid('updateRow',{
				index: rowIndex,
				row: {TSelect:tmpcheckvalue}
			})			
			return;
		}else{
			requestNoStr=$('#reqlist').datagrid('getData').rows[rowIndex]["TReqNo"];
		 	QueryReqDetail(requestNoStr)
		}
	  }
	    
  });
  InitReqListPage();
}


//初始化药品明细列表
function InitReqDetail(){
	//定义columns
	var columns=[[
	    {field:'TSelect',title:'<a id="AllSelect" href="#" style="font-weight:bold;color:black" onclick="SetSelectAll()">全消</a>',width:40,
	    	formatter:function(value,row,index){
				if (value=="Y"){
					return '<input type="checkbox" name="ReqDetailDataGridCheckbox" checked="checked" >';
				}
				else{
					return '<input type="checkbox" name="ReqDetailDataGridCheckbox" >';
				}
			}
	    },    
        {field:'TRegNo',title:'登记号',width:80},    
        {field:'TBedNo',title:'床号',width:80},
        {field:'TName',title:'姓名',width:80},
        {field:'TDesc',title:'名称',width:250},
        {field:'TUom',title:'单位',width:75},
        {field:'TRetQty',title:'本次退药数量',width:85,align:'right',
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
        {field:'TQty',title:'申请数量',width:60},
        {field:'TReturnqty',title:'已退数量',width:60},
        {field:'TSurqty',title:'未退数量',width:65},
        {field:'TReqDate',title:'申请日期',width:75},
        {field:'TReqTime',title:'申请时间',width:75},
        {field:'TStatus',title:'状态',width:40},
        {field:'TRetReason',title:'退药原因',width:60},
        {field:'TOECPRCode',title:'医嘱优先级代码',width:90},
        {field:'TEncryptLevel',title:'病人密级',width:60},
        {field:'TPatLevel',title:'病人级别',width:60},
        {field:'Tpid',title:'Tpid',width:60,hidden:true},
        {field:'Tretrqrowid',title:'Tretrqrowid',width:60,hidden:true},
        {field:'TDEPTDR',title:'TDEPTDR',width:60,hidden:true},
        {field:'TDodis',title:'TDodis',width:60,hidden:true},
        {field:'TBEDDR',title:'TBEDDR',width:60,hidden:true},
        {field:'TADMDR',title:'TADMDR',width:60,hidden:true},
        {field:'TADMLOCDR',title:'TADMLOCDR',width:60,hidden:true},
        {field:'TRECLOCDR',title:'TRECLOCDR',width:60,hidden:true},
        {field:'TRetPartFlag',title:'TRetPartFlag',width:60,hidden:true}
        
   ]];  
	
   //定义datagrid	
   $('#reqdetail').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  //rownumbers:true,
      columns:columns,
      pageSize:50,  // 每页显示的记录条数
	  pageList:[50,100,300],   // 可以设置每页记录条数的列表
	  loadMsg: '正在加载信息...',
	  pagination:true,    
	  onLoadSuccess: function(){
		if (currEditRow!=undefined){
			$('#reqdetail').datagrid('endEdit', currEditRow);
			currEditRow = undefined
		}
		var data = $('#reqdetail').datagrid('getRows');
		if (data.length > 0){
		    var pid=$('#reqdetail').datagrid('getData').rows[0]["Tpid"];
	 		QueryReqTotal(pid);
		}
		else{
			$('#reqtotal').datagrid('options').queryParams.params = "";
			$('#reqtotal').datagrid('loadData',{total:0,rows:[]});			
		}
	  },
  	  onClickCell: function (rowIndex, field, value) {
	  	if (field=="TSelect"){
			var tmpcheckvalue=""
			if (value=="Y"){tmpcheckvalue="N"}
			else{tmpcheckvalue="Y"}
			$('#reqdetail').datagrid('updateRow',{
				index: rowIndex,
				row: {TSelect:tmpcheckvalue}
			})			
			return;
		}
		if (field!="TRetQty"){return;}
		var selectdata=$('#reqdetail').datagrid('getData').rows[rowIndex];
		var prioritycode=selectdata["TOECPRCode"];
		var dodis=selectdata["TDodis"];
		var retqty=selectdata["TRetQty"];
		var surqty=selectdata["TSurqty"];
		var retpartflag=selectdata["TRetPartFlag"];
		if (retpartflag=="0"){						
			$.messager.alert("提示","此记录有附加收费项目，不允许修改退药数量!","info")
			return ;	
		}
	  	if (rowIndex != currEditRow) {
        	if (endEditing(field)) {
				$("#reqdetail").datagrid('beginEdit', rowIndex);
				var editor = $('#reqdetail').datagrid('getEditor', {index:rowIndex,field:field});
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
    if ($('#reqdetail').datagrid('validateRow', currEditRow)) {
        var ed = $('#reqdetail').datagrid('getEditor', { index: currEditRow, field: field });
		var selecteddata = $('#reqdetail').datagrid('getRows')[currEditRow];
		var surqty=selecteddata["TSurqty"]; 
		var retqty=selecteddata["TRetqty"];
        var inputtxt=$(ed.target).numberbox('getValue');
	    if (inputtxt<0){
	    	$.messager.alert('错误提示',"数字不能小于0!");
	    	return false;
	    }
	    if (inputtxt!=""){
		    var diffqty=parseFloat(inputtxt)-parseFloat(surqty);
		    diffqty=diffqty.toFixed(2)
		   	if (parseFloat(diffqty)>0){
		    	$.messager.alert('错误提示',"退药数量不能大于未退数量!");
		    	$('#reqdetail').datagrid('updateRow',{
					index: currEditRow,
					row: {TRetQty:retqty}
				});
				currEditRow=undefined;
		    	return false;
		    }
	    }else{
			$.messager.alert('错误提示',"退药数量为空!");
			$('#reqdetail').datagrid('updateRow',{
				index: currEditRow,
				row: {TRetQty:retqty}
			});
			currEditRow=undefined;
	    	return false;
		}
		$('#reqdetail').datagrid('updateRow',{
			index: currEditRow,
			row: {TRetQty:inputtxt}
		});
        $('#reqdetail').datagrid('endEdit', currEditRow);
        currEditRow = undefined;
        return true;
    } else {
        return false;
    }
}
//初始化单品汇总列表
function InitReqTotal(){
	//定义columns
	var columnspat=[[
	    {field:'Tdesc',title:'药品名称',width:250},    
        {field:'Tuom',title:'单位',width:75},    
        {field:'Treqqty',title:'申请数量',width:80},
        {field:'Treturnedqty',title:'已退数量',width:80},
        {field:'TSurqty',title:'未退数量',width:80},
        {field:'Tform',title:'剂型',width:100},
        {field:'Tmanf',title:'厂家',width:150},
        {field:'Tprice',title:'单价',width:100,align:'right'},
        {field:'Tamount',title:'金额',width:100,align:'right'}
    ]];  
   //定义datagrid	
   $('#reqtotal').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  //rownumbers:true,
      columns:columnspat,
      pageSize:30,  // 每页显示的记录条数
	  pageList:[30,50,100],   // 可以设置每页记录条数的列表
	  loadMsg: '正在加载信息...',
	  pagination:true    
	});
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
			if (value!=""){
				var painfoarr=value.split("^")	;
				if (painfoarr.length >0){
					$("#patName").val(painfoarr[0]);
				}
				QueryReqList();
			}   
		},    
		error:function(){        
			alert("获取病人基础数据失败!");
		}
	});
}
 //查询申请单列表
function QueryReqList(){
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
	var wardLoc=$('#wardLoc').combobox("getValue");
	if ($.trim($('#wardLoc').combobox("getText"))=="") {
		wardLoc="";
	} 
	var patNo=$("#patNo").val();
	var patName=$("#patName").val();
	var docFlag=""
	if ($("#checkedDocFlag").is(':checked')){ 
		docFlag="1"
	}
	var params=startDate+"^"+endDate+"^"+phaLoc+"^"+wardLoc+"^"+patNo+
			   "^"+docFlag+"^"+RequestStatus;
	$('#reqlist').datagrid({
		url:commonInPhaUrl+'?action=QueryReqListForReturn',	
		queryParams:{
			params:params}
	});	
	InitReqListPage();
}
//查询申请单明细
function QueryReqDetail(params){
	$('#reqdetail').datagrid({
		url:commonInPhaUrl+'?action=QueryReqDetail',	
		queryParams:{
			params:params}
	});	
}  
//查询申请单单品汇总
function QueryReqTotal(params){
	$('#reqtotal').datagrid({
		url:commonInPhaUrl+'?action=QueryReqTotal',	
		queryParams:{
			params:params}
	});	
}  
//查看选择的申请单明细
function QuerySelectReqDetail(){
	var reqrowsdata=$('#reqlist').datagrid("getRows");
	var reqrows=reqrowsdata.length;
	if (reqrows<=0){
		$.messager.alert('提示',"没有数据!","info");
		return;
	}
	var reqnostr=""
	for (var reqi=0;reqi<reqrows;reqi++){
		var selectdata=reqrowsdata[reqi];
		var select=selectdata["TSelect"];
		if (select=="Y"){
			var reqno=selectdata["TReqNo"]
			if (reqnostr==""){
				reqnostr=reqno
			}
			else{
				reqnostr=reqnostr+"^"+reqno
			}
		}		
	}
	if (reqnostr==""){
		$.messager.alert('提示',"请勾选需要退药的退药申请!","info");
		return;
	}
	requestNoStr=reqnostr
	QueryReqDetail(requestNoStr);	
}
function InitReqListPage(){
	var reqlistpager = $('#reqlist').datagrid('getPager'); 
	reqlistpager.pagination({  
		beforePageText:'',
		afterPageText:'/{pages}', 
  		displayMsg:''  
	}); 
}
function SetSelectAll()
{
	var detailrowsdata=$('#reqdetail').datagrid("getRows");
	var detailrows=detailrowsdata.length;
	if (detailrows<=0){
		return;
	}
	var tmpSelectFlag=""
	if($("#AllSelect").text()=="全选"){
		$("#AllSelect").text("全消")
		tmpSelectFlag="Y"
	}else{
		$("#AllSelect").text("全选")
		tmpSelectFlag="N"
	}
	var columns = $('#reqdetail').datagrid("options").columns;
	var columnsstr=$('#reqdetail').datagrid('getColumnFields',false);
	var columni=columnsstr.indexOf("TSelect");
	$.each(detailrowsdata, function(index, item){
		detailrowsdata[index][columns[0][columni].field]=tmpSelectFlag;
		$('#reqdetail').datagrid('refreshRow', index);
	})
}
//执行退药
function btnReturnHandler(){
	var detailrowsdata=$('#reqdetail').datagrid("getRows");
	var detailrows=detailrowsdata.length;
	if (detailrows<=0){
		$.messager.alert('提示',"没有数据!","info");
		return;
	}
	var quitFlag="";
	var returnstr=""
	$.each(detailrowsdata, function(index, item){
		if (item["TSelect"]=="Y"){
			var retqty=$.trim(item["TRetQty"]);
			var surqty=$.trim(item["TSurQty"]);
			var reqitmrowid=$.trim(item["Tretrqrowid"]); //申请子表id
			if (retqty==""){
				$.messager.alert('提示',"第"+(index+1)+"行数量为空!","info");
				quitFlag=1;
				return;
			}
			var tmpreturndata=reqitmrowid+"^"+retqty;
			if (returnstr==""){
		 		returnstr=tmpreturndata;	
		 	}else{
			 	returnstr=returnstr+","+tmpreturndata;
			}
		}
	})
	if (quitFlag==1){
		return;
	}
	if (returnstr==""){
		$.messager.alert('提示',"请勾选需要退药的数据!","info");
		return;
	}
	var detaildata=detailrowsdata[0]
	var reclocdr=detaildata["TRECLOCDR"]
	if (reclocdr==""){
		$.messager.alert('提示',"医嘱接收科室为空!","info");
		return;
	}
	var excuteret=tkMakeServerCall("web.DHCSTPHARETURN","ExecReturnByReq","","",reclocdr,gUserId,"RT",returnstr)
	var retarr=excuteret.split(",");
	var retNo=""
	if(retarr[0]=="failure")
	{
		if (retarr[1]==-3){  
	 		$.messager.alert("提示","不允许退药:退药数量超过发药数量,或未发药","info") ;	
		}else if (retarr[1]==-2){  
			$.messager.alert("提示","存在申请记录已经退药或拒绝退药!","info") ; 		
		}else if (retarr[1]==-4){
			$.messager.alert("提示","患者已最终结算,不允许退药,请联系结算处","info");
		}else if (retarr[1]==-5){  
			$.messager.alert("提示","保存退药明细失败","info");
		}else if ((retarr[1]==-6)){ 	
			$.messager.alert("提示","更新申请单状态失败","info") ;	
		}else if ((retarr[1]==-7)){ 
			$.messager.alert("提示","审核退药单失败","info");	
		}else if ((retarr[1]==-10)){ 
			$.messager.alert("提示","有附加收费项目执行记录不允许部分退药",info);	
		}else if ((retarr[1]==-11)){ 
			$.messager.alert("提示","不允许退药:已经中途结算,不能退药!") ;	
		}else if (retarr[1]!=0){
			 $.messager.alert("提示","退药失败:"+retarr,"info") ;	
		}		
		return;
	}else{ 
		retNo=retarr[1];
		QueryReqDetail(requestNoStr)
		$.messager.confirm('提示', '退药成功!是否打印?', function(r) {
	    	if(r==true){
		    	PrintReturnCom(retNo,"")
		    }else{
				return;
			}
		});
	}					  
	
}