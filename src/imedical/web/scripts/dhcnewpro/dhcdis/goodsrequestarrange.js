/**	配送申请确认界面
  * 重新整理 sufan 2018-05-11
  * 原申请安排界面
  * 变更为护工任务确认完成和完成界面
**/
var editRow="",Select="";
$(document).ready(function() {
		
	initcombox();		// 初始化界面基本元素
	initArrgrid();		// 初始化确认列表
	initsubgrid();		// 初始化明细列表 
    initMethod();		// 初始化控件绑定的事件
	  	
});

//初始化确认数据列表
function initArrgrid()
{
 	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
    var Usereditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
			options: {
				valueField: "value", 
				textField: "text",
				url:LINK_CSP+"?ClassName=web.DHCDISEscortArrage&MethodName=GetSSUser", 
				required:true,
				editable:false, 
				panelHeight:"350",  //设置容器高度自动增长
				onSelect:function(record){
					var ed=$("#table").datagrid('getEditor',{index:editRow,field:'REQPeople'});
					$(ed.target).combobox('setValue', record.text);
					var ed=$("#table").datagrid('getEditor',{index:editRow,field:'REQPeopleDr'});
					$(ed.target).val(record.value); 
			},
		}
    }  
    
 	par=getParam();		//查询条件
 
    $('#table').datagrid({
		    url:LINK_CSP+'?ClassName=web.DHCDISGoodsRequest&MethodName=listGoodsRequest&param='+par,
		    fit:true,
		    fitColumns:true,
		    rownumbers:true,
		    columns:[[
		    {
		        field: 'REQ',
		        hidden:true
		    },
		    {
		        field: 'REQNo',
		        align: 'center',
		        title: '验证码',
		        hidden: true,
		        width:100
		    },
		 	{
		        field: 'REQCurStatus',
		        align: 'center',
		        title: '当前状态',
		        //styler: tdStyle,
		        width:100
		    },{
		        field: 'TypeID',
		        align: 'center',
		        title: '配送任务类型ID',
		        hidden:true,
		        width:100
		    },{
		        field: 'REQEmFlag',
		        align: 'center',
		        title: '加急标志',
		        hidden:true,
		        width:100
		    },{
		        field: 'REQCreateDate',
		        align: 'center',
		        title: '申请日期',
		        width:100
		    }, {
		        field: 'REQCreateTime',
		        align: 'center',
		        title: '申请时间',
		        width:100
		    }, {
		        field: 'REQLoc',
		        align: 'center',
		        title: '申请科室',
		        width:130
		    }, {
		        field: 'REQRecLoc',
		        align: 'center',
		        title: '接收科室',
		        width:130
		    }, {
		        field: 'OpUserName',
		        align: 'center',
		        title: '操作人员',
		        width:100
		    },{ 
		        field: 'REQExeDate',
		        align: 'center',
		        title: '配送日期',
		        width:100
		    }, { 
		        field: 'REQExeTime',
		        align: 'center',
		        title: '配送时间',
		        width:100
		    }, {
		        field: 'REQPeople',
		        align: 'center',
		        title: '配送人员',
		        editor:Usereditor,
		        width:100,
		        styler:function(value,row){
				if(row.REQCurStatus=="待处理")
					{return 'color:#0000CD'}
		    	}
		    }, {
		        field: 'REQPeopleDr',
		        align: 'center',
		        title: '配送人员ID',
		        hidden:true,
		        width:200,
		        editor:textEditor
		    },{
		        field:'Phone',title:'护工电话',
		    	width:120,
		    	hidden:false,
		    	styler:function(value,row){
				if(row.REQCurStatus=="待处理")
					{return 'color:#0000CD'}
		    	}
		    }, {
		        field: 'REQRemarks',
		        align: 'center',
		        title: '备注',
		        width:100
		    }
	    ]],
	    
	    pageSize:20, // 每页显示的记录条数
	    pageList:[20,40],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
	    pagination:true,
		onClickRow:function(Index, row){
			
			ClickRowDetail(row);
		},
		onDblClickRow: function (Index, row) {//双击选择行编辑
			
			if((row.REQCurStatus!="待处理")&&(row.REQCurStatus!="已安排")&&(row.REQCurStatus!="撤销安排")&&(row.REQCurStatus!="完成"))
			{
				$.messager.alert("提示:","当前状态不允许安排陪送人员!");
				return;
			}
			if ((editRow != "")||(editRow == "0")) { 
	            $("#table").datagrid('endEdit', editRow); 
	        } 
	        
	       	$("#table").datagrid('beginEdit', Index); 	
	       	Select="true"
	      	editRow = Index; 
		},
	    rowStyler:function(index,row){
			if(row.REQEmFlag=="Y"){
					return 'color:#EE2C2C'
			}
		}
	})
}

///初始化明细列表
function initsubgrid()
{
	$('#subTable').datagrid({
		fit:true,
		columns:[[
		{
	        field: 'REQI',
	        hidden:true	        
        },
		{
	        field: 'USERID',
	        hidden:true	        
        },
		{
	        field: 'ITM',
	        align: 'center',
	        title: '项目名称',
	        width: 200	        
        },{
            field: 'RECLOC',
            align: 'center',
            title: '去向',
            hidden:true,
            width: 200
        }
        ,{
            field: 'QTY',
            align: 'center',
            title: '数量',
            width: 200
        }
        ,{
            field: 'USERNAME',
            align: 'center',
            title: '人员',
            width: 200,
            hidden:true,
            editor:{
				type:'combogrid',
				options:{
					    id:'id',
					    fitColumns:true,
					    fit: true,//自动大小  
						pagination : true,
						panelWidth:600,
						textField:'name',
						mode:'remote',
						url:'dhcapp.broker.csp?ClassName=web.DHCDISCommonDS&MethodName=LocUserComboGrid',
						columns:[[
								{field:'name',title:'姓名',width:60},
								{field:'status',title:'状态',width:40},
								{field:'locdesc',title:'科室',width:100},
								{field:'id',hidden:true}
								]],
							onSelect:function(rowIndex, rowData) {
               					fillValue(rowIndex, rowData);
            				}		   
						}
				}
        }
        ]],
	    pageSize:20,
	    pageList:[20,40],
        singleSelect:true,
        loadMsg: '正在加载信息...',
	    pagination:true,
	    onClickRow:function(index,row){onClickRow(index,row)}
    })
}
//双击编辑
function onClickRow(index,row){
	CommonRowClick(index,row,"#subTable");
}
function fillValue(rowIndex, rowData){
	
	$('#subTable').datagrid('getRows')[editIndex]['USERID']=rowData.id
}

//详情弹出层页面
function ParticularsPages(){
	
	var selectRow = $('#table').datagrid('getSelected');
	if((selectRow==null)){
		$.messager.alert("提示","请选择其中一条申请单！")
		return;	
	}
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
		title:'详情',
		border:true,
		closed:"true",
		width:800,
		height:400,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		onClose:function(){
			$('#win').remove();  //窗口关闭时移除win的DIV标签
			}
	}); 

	//iframe 定义

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcdis.accompdetail.csp?mainRowID='+selectRow.REQ+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}
//zhanghailong
function initMethod(){
	
	//拆分合并点击事件
	$("#splitmergebtn").on('click',function(){
	 	splitmerge();
	 });
	 
	//安排
	$("#Arrange").bind('click',ArrangeToo);  
	
	//查看验证码明细
	$("#vercodebtn").bind('click',verificatCode) 
	
	//取消安排
	$('#Cancelbtn').on("click",CancelArrange); 
	
	//查找
	$('#searchBtn').bind('click',search) 		
	
	//验证码回车事件
	$('#TaskID').keydown(function(e){
		if(e.keyCode==13){
	   		search();
		}
	});
	
	//详情
	$("#detailMsg").bind('click',ParticularsPages)	
	
	//完成
	$('#complete').bind('click',complete);			
}

///初始化界面元素
function initcombox()
{
	$('#StrDate').datebox("setValue",formatDate(0));
	$('#EndDate').datebox("setValue",formatDate(0));
	
	//当前位置
	$('#currLoca').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISGoodsRequest&MethodName=GetCurrLoca",
		valueField:'id',    
	    textField:'text',
	    mode:'remote',
	    panelHeight:"auto",  
	});
}
//查询明细
function ClickRowDetail(row){
	$('#subTable').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCDISGoodsRequest&MethodName=listGoodsRequestItm&req='+row.REQ
	});	
}

//查询
function search(){
	var Params=getParam(); //获取参数
	$('#table').datagrid({
			queryParams:{param:Params}	
	})
}	


//配送确认
function save(){
	
	
	if(($("#subTable").datagrid('getSelected')=="")){
			$.messager.alert("提示","请选择其中一条记录！")
			return;
	}
	arr=new Array();
	tableData=$("#subTable").datagrid('getRows');
	for(var i=0;i<tableData.length;i++){
		arr.push(tableData[i].REQI+"!!"+tableData[i].USERID)
	}
	subStr=arr.join("^");
	runClassMethod(
		"web.DHCDISGoodsRequest",
		"saveUser",
		{'mainStr':subStr},
		function(data){ 
			$.messager.alert("保存成功");
			search();  
		},
		"json")	 	
}

//function arrange(){
//
//	updateStatus(27,"");
//	
//}
function refuse(){
	var row=$("#table").datagrid('getSelected')
		if(row==""){
				$.messager.alert("提示","请选择其中一条申请！")
				return;
		}	
	var typeid=row.TypeID
	var reqID=row.REQ
	runClassMethod("web.DHCDISGoodsRequest",
					   "refuse",
					   {'reqID':reqID,
					   'type':typeid,
					   'statuscode':98,
					   'lgUser':LgUserID,
					   'reason':''},
					   function(data){
						    
						    if(data==0){
							  $.messager.alert("提示","操作成功!");
					   		  search();  
							}else{
								$.messager.alert('错误',data);	
							}  
					   		
					   },"text")
}
function accpet(){

	updateStatus(12,"");
	
}
function updateStatus(statuscode,reason){
	    
	var row=$("#table").datagrid('getSelected')
		if(row==""){
				$.messager.alert("提示","请选择其中一条申请！")
				return;
		}	
	var typeid=row.TypeID
	var disreqID=row.REQ
	var emflag=row.REQEmFlag
		runClassMethod("web.DHCDISRequestCom",
					   "updateStatus",
					   {'pointer':disreqID,
					   'type':typeid,
					   'statuscode':statuscode,
					   'lgUser':LgUserID,
					   'EmFlag':emflag,
					   'reason':reason},
					   function(data){
						    
						    if(data==0){
							  $.messager.alert("提示","保存成功");
					   		  search();  
							}else{
								$.messager.alert('错误',data);	
							}  
					   		
					   },"text")	 	
	
}

//拆分合并zhanghailong
function splitmerge(){
	
	var selItems = $('#table').datagrid('getSelections');
	
	if (!selItems.length){
		$.messager.alert("提示:","请选一条数据！");
		return;
	}
	var row=$('#table').datagrid('getSelected');
	var req=row.REQ;    //取id
	if($('#splitmergewin').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="splitmergewin"></div>');
	$('#splitmergewin').window({
		title:'拆分合并',
		collapsible:true,
		border:false,
		closed:"true",
		width:600,
		height:400,
		onClose:function(){
			$('#splitmergewin').remove();
		}
	});
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcdis.splitmerge.csp?reqs='+ req+'"></iframe>';
	$('#splitmergewin').html(iframe);
	$('#splitmergewin').window('open');

}
//Table请求参数
//return ：开始时间^结束时间^任务ID^申请科室^状态
function getParam(){
		
	 var stDate = $('#StrDate').datebox('getValue');			//开始日期	
	 var endDate=$('#EndDate').datebox('getValue');				//结束日期
	 //taskID= $('#TaskID').val();
	 var recLoc = $('#RecLoc').combobox('getValue');			//接收科室
	 var applayLocDr= $('#ApplayLoc').combobox('getValue');		//申请科室
	 var status = $('#status').combobox('getValue');			//申请单状态
	 var currloc = $("#currLoca").combobox("getValue");			//当前位置
	return stDate +"^"+ endDate +"^"+ "" +"^"+ recLoc +"^"+ applayLocDr +"^"+ status +""+ currloc;
}


//安排 窗口	
function arrange()
{
	var selectRow = $('#table').datagrid('getSelected');
	var Typeid=selectRow.TypeID; //cy  2017-05-09 获取申请单类型id
	if (selectRow==null){ 
		$.messager.alert("提示:","请选一条数据！");
		return;
	}
	
	$('#ArrangeWin').window({
		title:'安排',
		collapsible:false,
		border:false,
		closed:false,
		width:820,
		height:500
	});
	$('#ArrangeWin').window('open');
	WardNurserList(selectRow.REQ,Typeid);
}
//加载安排窗口中数据表格
function WardNurserList(disreqID,Typeid)
{
	var freecolumns=[[
	    {field:'id',title:'id',width:20,hidden:true},
	    {field:'Score',title:'评分',width:80},
		{field:'UserCode',title:'工号',width:80,align:'center'},
	    {field:'User',title:'姓名',width:80},
		{field:'Desc',title:'上一次任务',width:80,align:'center'}
	]];
	var busycolumns=[[
	    {field:'id',title:'id',width:20,hidden:true},
	    {field:'Score',title:'评分',width:80},
		{field:'UserCode',title:'工号',width:80,align:'center'},
	    {field:'User',title:'姓名',width:80},
		{field:'Desc',title:'正在进行',width:80,align:'center'}
	]];
	//所在病区护工列表 空闲
	$('#wardnurfreedg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=QueryWardNurList&locId='+LgCtLocID+'&StatusType='+0+'&Typeid='+Typeid,
		columns:freecolumns,
		width:400,
		height:187,
		rownumbers:true,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true
	});
	//所在病区护工列表 忙碌
	$('#wardnurbusydg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=QueryWardNurList&locId='+LgCtLocID+'&StatusType='+1+'&Typeid='+Typeid,
		columns:busycolumns,
		width:400,
		height:189,
		rownumbers:true,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true
	});
	//其他护工列表 空闲
	$('#othnurfreedg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=QueryOthNurList&locId='+LgCtLocID+'&StatusType='+0+'&Typeid='+Typeid,
		columns:freecolumns,
		width:400,
		height:187,
		rownumbers:true,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true
	});
	//其他护工列表 忙碌
	$('#othnurbusydg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=QueryOthNurList&locId='+LgCtLocID+'&StatusType='+1+'&Typeid='+Typeid,
		columns:busycolumns,
		width:400,
		height:189,
		rownumbers:true,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true
	});
	//已选护工列表
	var selnurcolumns=[[
	    {field:'ID',title:'ID',width:80,hidden:true},
	    {field:'UserCode',title:'工号',width:80},
		{field:'User',title:'姓名',width:100,align:'center'}
	]];
	$('#selnurdg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=QueryLocUserList&disreqID='+disreqID+'&reqtypeid='+Typeid,
		columns:selnurcolumns,
		fit:true,
		height:375,
		rownumbers:true,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true
	});
	/* 指定人员下拉列表*/
	$('#LocUser').combogrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=LocUserComboGrid&page='+1+'&rows='+20,
		columns:[[
			{field:'UserCode',title:'工号',width:90,hidden:false},
			{field:'name',title:'姓名',width:90,hidden:false},
			{field:'id',title:'id',width:20,hidden:true}
		]],
		required : true,
	    idField:'id',
	    fitColumns:true,
	    fit: true,//自动大小  
		panelWidth:150,
		panelHeight:150,
		textField:'name',
		mode:'remote'
	});
}

//添加指定人员
function AddLocUserRow()
{
	var LocUserItme= $('#LocUser').combogrid('grid');	// get datagrid object
    var rowData = LocUserItme.datagrid('getSelected');	// get the selected row
	var LocUserID=rowData.id;
    //判断不良事件名称添加是否重复
	var  dataList=$('#selnurdg').datagrid('getData'); 
	for(var i=0;i<dataList.rows.length;i++){
		if(LocUserID==dataList.rows[i].ID){
			$.messager.alert("提示","该人员已添加！"); 
				return false;
		}
	}
	$('#selnurdg').datagrid('insertRow',{
		index: 0, // 行索引
		row: {
			ID:LocUserID, UserCode:rowData.UserCode, User:rowData.name
		}
	});
}
//安排指定人员
function SaveLocUserList()
{
	var rows = $("#selnurdg").datagrid('getChanges');
	var rowdata = $("#table").datagrid('getSelected');
	var typeid=rowdata.TypeID
	var disreqID=rowdata.REQ
	var emflag=rowdata.REQEmFlag
	var curStatus=rowdata.REQCurStatus
	
	var dataList = [],LocUserList="";
	for(var i=0;i<rows.length;i++)
	{
		var tmp=rows[i].ID+"^"+rows[i].UserCode+"^"+rows[i].User;
		dataList.push(tmp);
	} 
	LocUserList=dataList.join("$c(1)");
	if(LocUserList==""){
		$.messager.alert("提示","请添加指定人员！"); 
		return false;
	}
	//disreqID=$('#table').datagrid('getSelected').REQ
	/// 安排指定人员 安排代码:
	//alert(disreqID)
	//alert(typeid)
	//alert(LgUserID)
	//alert(LocUserList)
	//alert(curStatus)
	runClassMethod("web.DHCDISEscortArrage","ArrangeDisReq",{"pointer":disreqID,"type":typeid,"statuscode":11,"lgUser":LgUserID,"EmFlag":emflag,"reason":"","LocUserList":LocUserList,"curStatus":curStatus},function(jsonString){
		if (jsonString==0){
			$.messager.alert("提示","保存成功！");
			WardNurserList();
			search();
		}else{
			$.messager.alert('错误',jsonString);
		}
	},'text');
}
//验证码明细    zhaowuqiang   2017-02-27
function verificatCode(){
	var selectRow = $('#table').datagrid('getSelected');
	if (selectRow==null){
		$.messager.alert("提示:","请选一条数据！");
		return;
	}

	var row=$('#table').datagrid('getSelected');
	var disreqID=row.REQ;
	var typeID=row.TypeID
	if($('#vercodewin').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="vercodewin"></div>');
	$('#vercodewin').window({
		title:'验证码明细',
		collapsible:true,
		border:false,
		closed:"true",
		width:800,
		height:400,
		minimizable:false,
		maximizable:false,
		resizable:false,
		onClose:function(){
			$('#vercodewin').remove();
		}
	});
	//var iframe='<iframe scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.affirmdetail.csp?mainRowID='+disreqID+'"></iframe>';
	var iframe='<iframe scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.idcodedetail.csp?mainRowID='+disreqID+'&TypeID='+typeID+'"></iframe>';
	$('#vercodewin').html(iframe);
	$('#vercodewin').window('open'); 

}
/// 安排护工   2017-06-20  zwq
function ArrangeToo()
{
	if(editRow>="0"){			///sufan 2017-11-23  可连续点安排保存数据
		$("#table").datagrid('endEdit', editRow);
	}
	var selectRow=$('#table').datagrid('getChanges');
	if(selectRow.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	if((selectRow.REQCurStatus!="已安排")&&(selectRow.REQCurStatus!="待处理")&&(selectRow.REQCurStatus!="撤销安排"))
	{
		$.messager.alert("提示:","当前状态不允许此操作!");
		return;
	}
	if((selectRow.REQPeopleDr=="")&&(selectRow.REQPeople==""))
	{
		$.messager.alert("提示:","请选择陪送人员!");
		return;
	}
	
	var SetUserDr=selectRow.REQPeopleDr;
	var ReqID=selectRow.REQ
	var TypeID = selectRow.TypeID;
	var statusCode=11			//sufan 2018-03-22,此处应该动态取
	if(TypeID!="18")
	{
		statusCode="101"
	}
	var ss=ReqID+"^"+TypeID+"^"+SetUserDr+"^"+statusCode+"^"+LgUserID
	runClassMethod("web.DHCDISGoodsRequest","ArrangeToo",{"pointer":ReqID,"typeid":TypeID,"user":SetUserDr,"statuscode":statusCode,"lgUser":LgUserID},function(jsonString){
		if (jsonString==0){
			//$.messager.alert("提示","保存成功！");
			Select=""; //是否已安排
			$('#table').datagrid('reload'); //重新加载
			//search();
		}else{
			$.messager.alert('错误',jsonString);
		}
	},'text');
}
///   2017-06-20  zwq
function CancelArrange()
{
	var selectRow = $('#table').datagrid('getSelected');
	if (selectRow==null){
		$.messager.alert("提示:","请选一条数据！");
		return;
	}
	var disreqID=selectRow.REQ
	var Crrstatue=selectRow.REQCurStatus;
	var TypeID = selectRow.TypeID;
	var statusCode="105";
	if(Crrstatue!="已安排")
	{
		$.messager.alert("提示:","已安排申请单才可以进行此操作!")
		return;
	}
	var str=disreqID+"^"+TypeID+"^"+statusCode+"^"+LgUserID
	runClassMethod("web.DHCDISGoodsRequest","CancelArrange",{"pointer":disreqID,"typeid":TypeID,"statuscode":statusCode,"lgUser":LgUserID},function(jsonString){
		if (jsonString==0){
			$.messager.alert("提示","操作成功！");
			search();
		}else{
			$.messager.alert('错误',jsonString);
		}
	},'text');
	
}

///sufan 2018-05-11 护工工作确认
function complete()
{
	if(editRow>="0"){
		$("#table").datagrid('endEdit', editRow);
	}
	var rowsData = $("#table").datagrid('getSelections');
	if((rowsData.length<=0)){
			$.messager.alert("提示","没有待保存数据！")
			return;	
		}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].REQCurStatus=="确认完成"){
			return false;
		}	
		if ((rowsData[i].REQPeopleDr=="")||(rowsData[i].REQPeople=="")){
			$.messager.alert("提示","第"+i-1+"行配送人员不能为空！"); 
			return false;
		} 
		var ReqID = rowsData[i].REQ;					//申请Id
		var TypeID = rowsData[i].TypeID;				//申请类型
		if(TypeID!="18")
		{ 	
		
			if(rowsData[i].tmpRecLoc== LgCtLocID){
				statuscode="104";
			}else{
				statuscode="104";
				}							//状态代码
		}
		var EmFlag = rowsData[i].REQEmFlag;				//是否加急
		var Relation = ""
		var LocaFlag = ""
		Relation = $("#currLoca").combobox("getValue");	//当前位置	
		if(Relation == ""){
			Relation = LgCtLocID;							
			LocaFlag = "1";				
		}else{
			LocaFlag = "0";								//位置标识
		}
		var DisUserId = rowsData[i].REQPeopleDr;		//护工Id
			
		var tmp=ReqID +"^"+ TypeID +"^"+ statuscode +"^"+ LgUserID +"^"+ EmFlag +"^"+ "" +"^"+ Relation +"^"+ LocaFlag +"^"+ DisUserId ;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	runClassMethod("web.DHCDISGoodsRequest","DisTaskConfirm",{"ListData":params},function(jsonString){
		if (jsonString==0){
			$.messager.alert("提示","保存成功！");

		}else{
			$.messager.alert('错误',jsonString);
			return;
		}
	},'text');
	$('#table').datagrid('reload');
	rowData="";
	
}