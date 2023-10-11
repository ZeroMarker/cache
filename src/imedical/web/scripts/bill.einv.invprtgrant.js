//定义全局变量
var buyend = "";
var AMRowID = "";
//入口函数
$(function(){
	setPageLayout(); //页面布局初始化
	setElementEvent();	//页面事件初始化
});

//页面布局初始化
function setPageLayout(){
	initDate(); //初始化日期
	initType(); //初始化票据类型
	initLquser(); //初始化领取人
	initInvprtFlag(); //初始化发票标志
	initInvgrantDataGrid(); //初始化发票发放查询明细表格
	initNumListDataGrid(); //初始化号段列表表格
}

//页面事件初始化
function setElementEvent(){
	initImportBtn(); //初始化导入发票发放信息事件
	initSelectBtn(); //初始化选择号段事件
	initAddBtn(); //初始化发票发放事件
	initSerachBtn(); //初始化查询发票发放明细信息事件
	initSetValue(); //开始号码赋值
	initUpdateInvType(); 
}

function initDate(){
	//获取当前日期
	var CurrentDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + new Date().getDate();
	//设置开始日期值
	$('#stdate').datebox('setValue', CurrentDate);
	//设置结束日期值
	$('#enddate').datebox('setValue', CurrentDate);
}

//票据类型下拉框	
function initType(){
	
	$("#type").combobox({
		valueField:'DicCode', 
		textField:'DicDesc',
		panelHeight:"auto",
		url:$URL,
		editable:false,
    	method:"GET",
    	onBeforeLoad:function(param)
    	{
	   		param.ClassName="BILL.EINV.BL.COM.DicDataCtl"
	    	param.QueryName="QueryDicDataInfo"
	   		param.ResultSetType="array"
	 		param.Type="LogicIUDType"          
	    },
	    onLoadSuccess:function(){
		    $('#type').combobox('setValue','PO');
		}
	});
}	


//领取人下拉框
function initLquser(){
	
	/*$HUI.combobox('#lquser', {
		panelHeight: 150,
		url: $URL,
		valueField: 'userID',
		textField: 'userName',
		mode:'remote',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.EINV.BL.COM.InvPrtGrantCtl";
			param.QueryName = 'QuerySSUserInfo';
			param.ResultSetType = 'array';
			param.KeyWord=$('#lquser').combobox('getValue');
		}
	});*/
	
	//取收费员信息
	$HUI.combobox('#lquser', {
		panelHeight: 150,
		url: $URL,
		valueField: 'userID',
		textField: 'userName',
		mode:'remote',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.EINV.BL.COM.InvPrtGrantCtl";
			param.QueryName = 'QuerySFUserInfo';
			param.ResultSetType = 'array';
			param.Type=$('#type').combobox('getValue');
			param.KeyWord=$('#lquser').combobox('getValue');
		},
	    onLoadSuccess:function(){
		   
		}
	});
}

//发票标志下拉框	
function initInvprtFlag(){
	
	$HUI.combobox('#invprtFlag',{
		valueField:'code',
		textField:'desc',
		panelHeight:'auto',
		data:[
			{code:'All',desc:'全部',selected:'true'},
			{code:'Y',desc:'可用'},
			{code:'N',desc:'已用完'},
			{code:'',desc:'待用'},
			{code:'Confirm',desc:'已核销'}
		]
	});
}

//发票发放查询明细表格	
function initInvgrantDataGrid(){
	
	$('#invgrant').datagrid({
		fit:true,
		border:false,
		pagination:true,    
    	url:$URL,    
    	columns:[[    
        	{field:'Trowid',title:'Trowid',width:100},    
        	{field:'Tdate',title:'日期',width:100},    
        	{field:'Ttime',title:'时间',width:100},
        	{field:'Tstartno',title:'开始号码',width:100},    
        	{field:'Tendno',title:'结束号码',width:100},    
        	{field:'Tcurrentno',title:'当前号码',width:100}, 
        	{field:'INVBillInvCode',title:'票据代码',width:100},
        	{field:'Tlquser',title:'领取人',width:100},    
        	{field:'leftinvnum',title:'剩余张数',width:100},    
        	{field:'Tflag',title:'标志',width:100}, 
        	{field:'Ttype',title:'类型',width:100},    
        	{field:'TconfirmInvDate',title:'核销日期',width:100},    
        	{field:'TConfirmInvUser',title:'核销人',width:100}
    	]]    
	}); 
}

//号段列表表格
function initNumListDataGrid(){
	
	$('#NumList').datagrid({
		fit:true,
		pagination:true,    
    	url:$URL,
    	columns:[[
    		{field: 'TRowID',title: 'TRowID',hidden: true},  
        	{field:'TStartNO',title:'开始号码',width:100},    
        	{field:'TEndNO',title:'结束号码',width:100},    
        	{field:'TCurrentNO',title:'当前号码',width:100}, 
        	{field:'finaccode',title:'票据代码',width:100},
        	{field:'TTitle',title:'开始字母',width:100},    
        	{field:'TBuyer',title:'购入人',width:100},    
        	{field:'TDate',title:'购入日期',width:100}
    	]],
    	onDblClickRow:function(index, row){
	    	$('#startno').val(row.TCurrentNO);
	    	//$("#startno").attr("readonly",true);
	    	$('#endno').val(row.TEndNO);
	    	$('#finaccode').val(row.finaccode);
	    	//将此号段置为启用
	    	var rtn = tkMakeServerCall("web.UDHCJFInvprt","UpdateAmtMagAvail",row.TRowID)
	    	//给全局变量buyend、AMRowID赋值
	    	buyend = row.TEndNO;
	    	AMRowID = row.TRowID;
	    	$('#Dialog').dialog('close');
	    }    
	});
}

//导入发票发放信息
function initImportBtn(){	
	
	$('#importBtn').click(function(){
		var UserDr=session['LOGON.USERID'];
		var GlobalDataFlg="0";                        	 //是否保存到临时global的标志 1 保存到临时global 0 保存到表中(必须有类名和方法名)
		var ClassName="BILL.EINV.BL.COM.InvPrtGrantCtl"; //导入处理类名
		var MethodName="ImportInvPrtGrantByExcel";       //导入处理方法名
		var ExtStrPam="";                			     //备用参数()
		ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam);
	});
	
	$('#downloadInv').click(function(){
		downloadEinvInfo();
	});
}

/// 功能说明：同步博思的票据到发放表中
function downloadEinvInfo(){
	//var userId=$('#lquser').combobox('getValue'); //领取人
	//var InputPam=userId+"^^";
	
	var userId=$('#lquser').combobox('getValue'); //领取人	
	if(userId==""){
		//var userId=session['LOGON.USERID'];	
		alert("领取人员不能为空！");
		return;
	}
	var InvType=$('#type').combobox('getValue'); //票据类型
	var InputPam=userId+"^^^"+InvType;
	
	//return 0;
	$.m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"GetBillParagraphNo",
		InputPam:InputPam
		},function(rtn){
			alert(rtn);
			LoadInvPrtGrantList(); //加载发票发放明细列表
	});	
}

//选择号段	
function initSelectBtn(){
	
	$('#selectBtn').click(function(){
		var type = $('#type').combobox('getValue'); //票据类型
		$('#NumList').datagrid('load',{
			ClassName:'web.UDHCJFInvprt',
			QueryName:'FindInvBuyList',
			type:type,
			hospital:session['LOGON.HOSPID']
		});	
		$('#Dialog').dialog({    
    		title: '号段列表',    
   			width: 606,    
    		height: 300,     
    		modal: true    
		});	
	});
}

//结束号码赋值
function initSetValue(){
	
	$("#invnum").keyup(function(){
		var startno = $.trim($('#startno').val());
		if(startno != ""){
			var invnum = $.trim($('#invnum').val());
			if(invnum != ""){
				$('#endno').val((Array(startno.length).join("0") + (parseInt(invnum)+parseInt(startno,10)-1)).slice(-startno.length)); 
			}
		}
	});
}	

//发放发票
function initAddBtn(){
	
	$('#addBtn').click(function(){
		var startno = $('#startno').val();
		if($.trim(startno) == ""){
			alert("开始号码不能为空！");
			return
		}
		var lquser = $('#lquser').combobox('getValue'); //领取人
		if(lquser == ""){
			alert("领取人员不能为空！");
		}else{
			var startno = $('#startno').val(); //开始号码
			var endno = $('#endno').val(); //结束号码
			var type=$("#type").combobox('getValue'); //票据类型
			var finaccode = $('#finaccode').val(); //票据代码
			var InStr=type+"^"+startno+"^"+endno+"^"+lquser+"^"+session['LOGON.HOSPID']+"^"+finaccode;
			var r = confirm("您确认要发放从"+startno+"到"+endno+"的发票吗？");
			if(r){
				$m({
					ClassName:"BILL.EINV.BL.COM.InvoiceCtl",
					MethodName:"SaveDHcinvoice",
					Str:InStr
				},function(value){
					if(value == 0){
						alert("发放成功！");
						var endno = $('#endno').val(); //结束号码
						var type=$("#type").combobox('getValue'); //票据类型
						//更新DHC_AMTMAG表当前号段 
						//参数说明：buyend:购入结束号码  AMRowID:DHC_AMTMAG表的rowid
						var rtn=tkMakeServerCall("web.UDHCJFInvprt","invupdateByRowID",endno,buyend,type,AMRowID);
						$('#lquser').combobox('setValue',"");
						$('#startno').val("");
						$('#invnum').val("");
						$('#endno').val("");
						LoadInvPrtGrantList();	//加载发票发放明细列表
					}else{
						alert("号段重复，请重选号段！")
					}
				});
			}
		}
	});
}

//查询发票发放明细信息
function initSerachBtn(){
	
	$('#serachBtn').click(function(){
		LoadInvPrtGrantList(); //加载发票发放明细列表
	});	
}	
	
//加载发票发放明细列表
function LoadInvPrtGrantList(){
	var stdate = $('#stdate').datebox('getValue'); //开始日期
	var enddate = $('#enddate').datebox('getValue'); //结束日期
	var type = $('#type').combobox('getValue'); //票据类型
	var invprtFlag = $('#invprtFlag').combobox('getValue'); //发票标志
	var lquser = $('#lquser').combobox('getText'); //领取人
	$('#invgrant').datagrid('load',{
		ClassName:'web.UDHCJFInvprt',
		QueryName:'InvprtGrantList',
		invprtFlag:invprtFlag,
		type:type,
		stdate:stdate,
		enddate:enddate,
		lquser:lquser
	});	
}


function initUpdateInvType(){
	$('#UpdateInvTypeBtn').click(function(){
		var rows = $('#invgrant').datagrid('getChecked');
		var ID=rows[0].Trowid;
		var InvType=$('#type').combobox('getValue'); //票据类型
		
		$.m({
			ClassName:"BILL.EINV.BL.COM.InvoiceCtl",
			MethodName:"UpdateDHCInvoiceById",
			DhcInvoiceId:ID,
			type:InvType,
			HospDr:session['LOGON.HOSPID']
			},function(rtn){
				if(rtn<0){
					alert("更新失败")
				}else{
					//alert("更新成功");
					LoadInvPrtGrantList(); //加载发票发放明细列表
				}
			});	
	});
}