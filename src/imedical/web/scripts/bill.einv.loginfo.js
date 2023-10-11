//入口函数
$(function(){
	setPageLayout(); //设置页面布局
	setElementEvent();	//设置页面元素事件
});
//设置页面布局
function setPageLayout(){
	initloginfoGV();//初始化日志列表
	initDate();//初始化日期
	initIPAddrCombo();//初始化IP地址下拉框
}
//设置页面元素事件
function setElementEvent(){
	initQueryBtn();//初始化查询按钮事件
	initCheckBox();//初始化复选框事件
}
//初始化查询按钮事件
function initQueryBtn(){
	$('#QueryBtn').click(function(){
		loadLogInfo();	
	});
}
//初始化复选框事件
function initCheckBox(){
	$('#ErrFlag').checkbox({
		onChecked: function(){
			loadLogInfo();
		},
		onUnchecked: function(){
			loadLogInfo();
		}	
	});
}
//初始化IP地址下拉框
function initIPAddrCombo(){
	var StDate=tkMakeServerCall("BILL.EINV.BL.COM.LogInfoCtl","FormatDate",$('#StDate').datebox('getValue'));
	var EdDate=tkMakeServerCall("BILL.EINV.BL.COM.LogInfoCtl","FormatDate",$('#EdDate').datebox('getValue'));
	$HUI.combobox("#IPAddr",{
		url:$URL,
		mode:'remote',
		valueField:'IPAdress', 
		textField:'IPAdress',
		panelHeight:"auto",
		onBeforeLoad:function(param)
		{
			param.ClassName="BILL.EINV.BL.COM.LogInfoCtl"
			param.QueryName="SQLQueryList"
			param.ResultSetType="array"
			param.StDate=StDate
			param.EdDate=EdDate
		},
	});
}
//初始化日志列表
function initloginfoGV(){
	$('#loginfoGV').datagrid({
		url:$URL,
		fit:true,
		border:false,
		striped:true,
		pagination:true,
		//sortName:'CreateDate',
		pageSize:20,
		pageList:[20,40,60],
    	columns:[[   
        	{field:'IPAdress',title:'客户端IP',width:125,align:'center'},    
        	{field:'LogType',title:'日志类型',width:100,align:'center',
        		formatter: function(value,row,index){
					if(value == "Debug"){
						value="调试日志";
					}else if(value == "Info"){
						value="提醒日志";
					}else{
						value="错误日志";
					}
					return value
				}
        	},    
        	{field:'CreateDate',title:'日志日期',width:100,align:'center',sortable:true}, 
        	{field:'CreateTime',title:'日志时间',width:100,align:'center'},    
        	{field:'LogMsg',title:'日志信息',width:1000,align:'left',showTip:true,
				styler: function(value,row,index){
					if(row.LogType == 'Error'){
						return 'background-color:#ffee00;color:red;';
					}
				}
        	},    
        	{field:'LogLevel',title:'日志级别',width:100},
        	{field:'UserCode',title:'操作员编码',width:100,align:'center'},
        	{field:'MacAdress',title:'客户端MAC地址',width:120,align:'center'},
        	{field:'PayAdmType',title:'票据业务类型',width:100,align:'center'},
        	{field:'HISPrtRowID',title:'发票表Dr',width:100,align:'center'}, 
        	{field:'OrgHISPrtRowID',title:'原发票ID',width:100,align:'center'},
        	{field:'PathCode',title:'业务处理路径',width:100,align:'center'}, 
        	{field:'ExpStr',title:'入参扩展参数',width:100,align:'center'},
        	{field:'XStr1',title:'扩展参数1',width:100,align:'center'},
        	{field:'XStr2',title:'扩展参数2',width:100,align:'center'},
        	{field:'XStr3',title:'扩展参数3',width:100,align:'center'},
        	{field:'XStr4',title:'扩展参数4',width:100,align:'center'},
        	{field:'XStr5',title:'扩展参数5',width:100,align:'center'},  
    	]]
	});	
}
//初始化日期
function initDate(){
	$('#StDate').datebox({
    	onSelect: function(){
        	loadIPAddrInfo();
   		}
	});
	$('#EdDate').datebox({
    	onSelect: function(){
        	loadIPAddrInfo();
   		}
	});
	//获取当前日期
	var nowDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + new Date().getDate();
	//设置开始日期值
	$('#StDate').datebox('setValue', nowDate);
	//设置结束日期值
	$('#EdDate').datebox('setValue', nowDate);
}
//加载datagrid数据
function loadLogInfo(){
	var StDate = $('#StDate').datebox('getValue');
	var EdDate = $('#EdDate').datebox('getValue');
	var IPAddr = $('#IPAddr').combobox('getValue');
	if($('#ErrFlag').is(':checked')){
		var ErrFlag = 'ON';
	}else{
		var ErrFlag = 'OFF';	
	}
	$('#loginfoGV').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.LogInfoCtl",
		QueryName:"QueryLogInfo",
		StDate:StDate,
		EdDate:EdDate,
		IPAddr:IPAddr,
		ErrFlag:ErrFlag
	});		
}
//加载IP下拉框数据
function loadIPAddrInfo(){
	var StDate=tkMakeServerCall("BILL.EINV.BL.COM.LogInfoCtl","FormatDate",$('#StDate').datebox('getValue'));
	var EdDate=tkMakeServerCall("BILL.EINV.BL.COM.LogInfoCtl","FormatDate",$('#EdDate').datebox('getValue'));
	$cm({
		ClassName:"BILL.EINV.BL.COM.LogInfoCtl",
		QueryName:"SQLQueryList",
		ResultSetType:"array",
		StDate:StDate,
		EdDate:EdDate
	},function(Data){
		if(Data.length > 0){
			$('#IPAddr').combobox('loadData', Data);
		}
	});
}