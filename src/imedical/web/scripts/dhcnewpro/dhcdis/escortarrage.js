/// Creator: congyue
/// CreateDate: 2017-01-12
/// Descript: 陪送申请查询安排
var disreqID="";
var WardDr="";
var DisREQNums="";
var editRow="";
var Select="";
$(document).ready(function() {

	//初始化时间控件
	initDate();
	
	//初始化combo
	initCombo();
	
	//初始化 table
	initTable();
	
	//初始化控件绑定的事件
	initMethod();

	setInterval("search()",150000);
});
function initDate(){
	$("#StDate").datebox("setValue", formatDate(0));  //Init起始日期
	$("#EndDate").datebox("setValue", formatDate(0));  //Init结束日期
}
function initCombo(){
	/* 科室 LocUserCombo*/
	$('#ApplyLoc').combobox({
    	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' 
	});
	var typecode="陪送";
	/* 状态 */
	$('#Status').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=StatusCombo&type="+0,// type 0: 陪送 ,1: 配送
		valueField:'id',
	    textField:'text' ,
	    panelHeight:100,
	});
	///陪送状态默认   sufan 2017-12-26
	runClassMethod("web.DHCDISRequest","getStatusValue",{'code':10},function(data){
		$('#Status').combobox("setValue",data);
	},'text',false)
}
function initTable(){
	
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	var Usereditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISEscortArrage&MethodName=GetSSUser", 
			//required:true,
			//editable:false, 
			panelHeight:200,  //设置容器高度自动增长
			mode:'remote',
			onSelect:function(record){
				///设置类型值
				var ed=$("#DisReqtb").datagrid('getEditor',{index:editRow,field:'DisREQLocUser'});
				$(ed.target).combobox('setValue', record.text);
				var ed=$("#DisReqtb").datagrid('getEditor',{index:editRow,field:'UserDr'});
				$(ed.target).val(record.value); 
				var ed=$("#DisReqtb").datagrid('getEditor',{index:editRow,field:'PhoneStr'});
				$(ed.target).val(record.telphone); 
			},
		}
	} 
	//定义columns
	var columns=[[
	    {field:'DisREQ',title:'disreqID',hidden:true},
		{field:'DisREQTypeID',title:'类型ID',hidden:true},  
		{field:'DisName',title:'姓名'},    //zhl
		{field:'DisHosNo',title:'住院号'},  //zhl
		{field:'DisREQCreateDate',title:'申请日期'},
		{field:'DisREQPatNo',title:'登记号'},
		{field:'DisREQWardBed',title:'床号'},
		{field:'DisREQWard',title:'病区'},
		{field:'DisREQNo',title:'验证码',hidden:true},
		{field:'DisREQExeDate',title:'陪送日期'},
		{field:"DisREQEscortTool",title:'方式',hidden:false},
		{field:'DisREQEscortType',title:'类型'},
		{field:'DisREQCurStatus',title:'陪送状态',styler:function(value,row){   ///sufan 2017-11-28
			if((row.DisREQCurStatus=="待处理")&&(row.DisREQEscortType=="急诊"))
			{return 'background-color:rgb(255, 98, 72);color:white'}
			if((row.DisREQCurStatus=="待处理")&&(row.DisREQEscortType!="急诊"))
			{
				return 'background-color:rgb(139, 195, 74);color:white'
			}
			if(row.DisREQCurStatus=="撤销安排")
			{
				return 'background-color:#ffb746;color:white'
			}
		}},
		{field:'DisREQCurStatusCode',title:'陪送状态Code',hidden:true},
		{field:'DisREQLocUser',title:'陪送人员',editor:Usereditor},
		{field:'UserDr',title:'护工ID',hidden:true,editor:textEditor},
		{field:'PhoneStr',title:'陪送人员电话',hidden:false,editor:textEditor},
		{field:'DisREQRemarks',title:'备注',hidden:false},
		{field:'DisREQNums',title:'陪送人数',hidden:true},
		{field:'AssNumber',title:'评分'},
		{field:'AssRemarks',title:'评价'}
		
	]];
	var param=getParam();
	var option = {
		singleSelect : true,
		pageSize:20,
	    pageList:[20,40],
	    loadMsg: '正在加载信息...',
	    onClickRow:function(Index, row){
			disreqID=row.DisREQ;
			DisREQNums=row.DisREQNums; //陪送人数
			ClickRowDetail(disreqID);//显示申请单明细列表
		},
       onDblClickRow: function (Index, row) {//双击选择行编辑
			if((row.DisREQCurStatus!="待处理")&&(row.DisREQCurStatus!="已安排")&&(row.DisREQCurStatus!="撤销安排"))
			{
				$.messager.alert("提示:","当前状态不允许安排陪送人员!");
				return;
			}
			if (editRow != ""||editRow === 0){ 
           		 $("#DisReqtb").datagrid('endEdit', editRow); 
        	} 
			if(Select=="true")
			{
            	$.messager.alert("提示:","请先保存上一条数据");
            	Select="false"
            	return;
			}
       		$("#DisReqtb").datagrid('beginEdit', Index); 
       		Select="true";
        	editRow = Index;
            	
        }
	};
	var uniturl = LINK_CSP+'?ClassName=web.DHCDISEscortArrage&MethodName=listDisRequest&param='+param;
	new ListComponent('DisReqtb', columns, uniturl, option).Init(); 
	
	//定义columns
	var DRItmcolumns=[[
		{field:'DISREQI',title:'DISREQI',width:100,hidden:true},
		{field:'ItemDR',title:'项目名称ID',width:100,hidden:true},
	    {field:'Item',title:'项目名称',width:200},
	    {field:'ExeLocDR',title:'RECLOCDR',width:100,hidden:true},
		{field:'ExeLoc',title:'去向',width:200},
		{field:'ItemType',title:'项目类型',width:100,hidden:true}
	]];
	//申请单明细列表 
    $('#DisReqItmtb').datagrid({
		columns:DRItmcolumns,
		fit:true,
	    url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=listGoodsRequestItm&disreq='+'',
	    pageSize:20,
	    pageList:[20,40],
        singleSelect:true,
        loadMsg: '正在加载信息...',
	    nowrap:false,//数据自动换行
	    pagination:true
    });
    
    
    //已申请未安排病区列表 
    
    $('#DisReqWardtb').datagrid({
		columns:[[
			{field:'WardDesc',title:'病区',width:190,hidden:false}, ///,formatter:setCellLabel
			{field:'WardDr',title:'WardDr',width:20,hidden:true}
		]],
	    url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=listWard&param='+param,
		fit:true,
		rownumbers:true,
		pageSize:10,  	// 每页显示的记录条数
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		showHeader:false,
		rownumbers : false,
		showPageList : false,
	    onClickRow:function(Index, row){
			WardDr=row.WardDr;
			var Params=getParam(); //获取参数
			$('#DisReqtb').datagrid({
				queryParams:{param:Params}	
			});
			$('#DisReqItmtb').datagrid({
				url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=listGoodsRequestItm&disreq='+''
			}); 

		},
		onLoadSuccess:function(data){
			// 隐藏分页图标
            $('#List .pagination-page-list').hide();
            $('#List .pagination-info').hide();
            
		}
    });
	//隐藏刷新
    $('#DisReqWardtb').datagrid('getPager').pagination({ showRefresh: false}); 
}	
/// 已申请未安排病区列表   卡片样式
function setCellLabel(value, rowData, rowIndex){
	var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.WardDesc +'</h3><br></div>';
	return htmlstr;
}

function initMethod(){
	//登记号回车事件
	$('#RegNo').bind('keypress',RegNoBlur)
	$("#acceptbtn").on('click',function(){
		Accept(); 
	})
	$("#rejectbtn").on('click',function(){
		Refuse(); 
	})
	//详情 点击事件
	$("#detailsbtn").on('click',function(){
	 	details();
	}) 
	$("#Arrange").bind("click",ArrangeToo);
	$('#searchBtn').bind('click',search) //查找申请单数据
	//$('#Arrangebtn').bind("click",Arrange);//安排 弹出安排窗口
	$('#Cancelbtn').bind("click",CancelArrange); //取消安排
	$("#vercodebtn").on('click',function(){
	 	verificatCode();//验证码明细
	}) 
	
	
}	

/*======================================================*/

//登记号回车事件
function RegNoBlur(event){
    if(event.keyCode == "13")    
    {
	    var RegNo=$('#RegNo').val();
	    if(RegNo==""){return false;}
		var len=RegNo.length;
		var  reglen=10;
		var zerolen=reglen-len;
		var zero="";
		for (var i=1;i<=zerolen;i++)
		{
			zero=zero+"0" ;
		}
	    $("#RegNo").val(zero+RegNo);
    }
};
//Table请求参数
//return ：开始日期、截止日期、申请科室id、登记号、任务id、状态
function getParam(){
	var stDate = $('#StDate').datebox('getValue');
	var endDate=$('#EndDate').datebox('getValue');
	var RegNo= $('#RegNo').val();
	
	var ApplyLoc= $('#ApplyLoc').combobox('getValue');
	var taskID= $('#TaskID').val();
	var DisHosNo = $('#HosNo').val();
	if(taskID==undefined)
	{
		taskID="";
	}
	
	if(ApplyLoc==undefined){
		ApplyLoc=""	;	
	}
	var status = $('#Status').combobox('getValue');
	if(status==undefined){
		status="" ;		
	}
	return stDate+"^"+endDate+"^"+ApplyLoc+"^"+RegNo+"^"+taskID+"^"+status+"^"+WardDr+"^"+DisHosNo+"^"+LgHospID;
}

///查询按钮的条件，去掉病区信息
function getSearch()
{
	var stDate = $('#StDate').datebox('getValue');
	var endDate=$('#EndDate').datebox('getValue');
	var RegNo= $('#RegNo').val();
	
	var ApplyLoc= $('#ApplyLoc').combobox('getValue');
	var taskID= $('#TaskID').val();
	var DisHosNo = $('#HosNo').val();
	if(taskID==undefined)
	{
		taskID="";
	}
	
	if(ApplyLoc==undefined){
		ApplyLoc=""	;	
	}
	var status = $('#Status').combobox('getValue');
	if(status==undefined){
		status="" ;		
	}
	return stDate+"^"+endDate+"^"+ApplyLoc+"^"+RegNo+"^"+taskID+"^"+status+"^"+""+"^"+DisHosNo+"^"+LgHospID;
}
//查询明细
function ClickRowDetail(disreqID){
	$('#DisReqItmtb').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=listGoodsRequestItm&disreq='+disreqID
	});	
}
//查询
function search(){
	Select="";
	var Params=getSearch(); //获取参数
	$('#DisReqtb').datagrid('load',{param:Params}); 
	
	$('#DisReqItmtb').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=listGoodsRequestItm&disreq='+''
	}); 
	//var StDate=$('#StDate').datebox('getValue');
	//var EndDate=$('#EndDate').datebox('getValue');
	//var DateParams=StDate+"^"+EndDate
	$('#DisReqWardtb').datagrid({
		queryParams:{param:Params}	
	});
	
}
//详情 add lvpeng 17-02-22 修改
function details(){
	var selectRow = $('#DisReqtb').datagrid('getSelected');
	if (selectRow==null){
		$.messager.alert("提示:","请选一条数据！");
		return;
	}

	if($('#detailswin').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append("<div id='detailswin' class='hisui-window' title='详情' style='width:800px;height:400px;top:100px;left:260px;padding:10px'></div>");
	$('#detailswin').window({
		iconCls:'icon-paper-info',
		collapsible:true,
		border:false,
		closed:"true",
		minimizable:false,
		maximizable:false,
		resizable:false,
		onClose:function(){
			$('#detailswin').remove();
		}
	});
	var iframe='<iframe scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.affirmdetail.csp?mainRowID='+disreqID+'&typeID='+selectRow.DisREQTypeID+'"></iframe>';
	$('#detailswin').html(iframe);
	$('#detailswin').window('open');

}

//接受 拒绝操作 //状态代码 接受 12 拒绝 98
function operation(statusCode){
	var selectRow = $('#DisReqtb').datagrid('getSelected');
	var TypeID=selectRow.DisREQTypeID;

	if (selectRow==null){
		$.messager.alert("提示:","请选一条数据！");
		return;
	}
	/// 接受，拒绝申请单操作
	runClassMethod("web.DHCDISEscortArrage","StatusOperat",{"pointer":disreqID,"typeid":TypeID,"status":statusCode,"lgUser":LgUserID},function(jsonString){
		if (jsonString==0){
			$.messager.alert("提示","保存成功！");
			search();
		}else{
			$.messager.alert('错误',jsonString);
		}
	},'text');
}
//安排 窗口	
function Arrange()
{
	var selectRow = $('#DisReqtb').datagrid('getSelected');
	if (selectRow==null){
		$.messager.alert("提示:","请选一条数据！");
		return;
	}
	var Typeid=selectRow.DisREQTypeID;
	$('#ArrangeWin').window({
		title:'安排',
		collapsible:false,
		border:false,
		closed:false,
		width:820,
		height:600
	});
	$('#ArrangeWin').window('open');
	WardNurserList(Typeid);
}
//加载安排窗口中数据表格
function WardNurserList(Typeid)
{
	var freecolumns=[[
	    {field:'id',title:'id',width:20,hidden:true},
	    {field:'Score',title:'评分',width:50,align:'center'},
		{field:'UserCode',title:'工号',width:80,align:'center'},
	    {field:'User',title:'姓名',width:100,align:'center'},
		{field:'Desc',title:'上一次任务',width:80,align:'center'},
		{field:'AllNum',title:'AllNum',width:80,align:'center',hidden:true},
		{field:'UserDr',title:'UserDr',width:20,hidden:true},
		
	]];
	var busycolumns=[[
	    {field:'id',title:'id',width:20,hidden:true},
	    {field:'Score',title:'评分',width:50,align:'center'},
		{field:'UserCode',title:'工号',width:80,align:'center'},
	    {field:'User',title:'姓名',width:100,align:'center'},
		{field:'Desc',title:'正在进行',width:80,align:'center'},
		{field:'AllNum',title:'AllNum',width:80,align:'center',hidden:true}
	]];
	//所在病区护工列表 空闲
	$('#wardnurfreedg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=QueryWardNurList&locId='+LgCtLocID+'&StatusType='+0+'&Typeid='+Typeid,
		columns:freecolumns,
		width:400,
		height:290,
		rownumbers:true,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		onClickRow:function(rowIndex, rowData){  //yuliping  单击添加陪送人员 2017-05-03
			var UserCode=rowData.UserCode
			var User=rowData.User                
			var UserDr=rowData.UserDr
			var  dataList=$('#selnurdg').datagrid('getData'); 
			for(var i=0;i<dataList.rows.length;i++){
		
			if(UserDr==dataList.rows[i].ID){
				
			$.messager.alert("提示","该人员已添加！"); 
				return ;
			}
			}
		$('#selnurdg').datagrid('insertRow',{
			index: 0, // 行索引
			row: {
				ID:UserDr, UserCode:UserCode, User:User
			 }
			
			});
			
			}
		
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
		height:290,
		rownumbers:true,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		
		onClickRow:function(rowIndex, rowData){  //yuliping  单击添加陪送人员 2017-05-03
			var UserCode=rowData.UserCode
			var User=rowData.User                
			var UserDr=rowData.UserDr
			//alert(ID+','+UserCode+','+User)
			
			var  dataList=$('#selnurdg').datagrid('getData'); 
			for(var i=0;i<dataList.rows.length;i++){
		
			if(UserDr==dataList.rows[i].ID){
				
			$.messager.alert("提示","该人员已添加！"); 
				return ;
			}
			}
		$('#selnurdg').datagrid('insertRow',{
			index: 0, // 行索引
			row: {
				ID:UserDr, UserCode:UserCode, User:User
			}
			
			});
			
			}
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
		{field:'DPRowid',title:'DPRowid',width:80,hidden:true},
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
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){  //双击清除选中行
			if((rowData.DPRowid==undefined)||(rowData.DPRowid=="")){
				$('#selnurdg').datagrid('deleteRow',rowIndex);
			}
		}
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
	var rows = $("#selnurdg").datagrid('getRows');
	var changerows = $("#selnurdg").datagrid('getChanges');
	
	var rowdata = $("#DisReqtb").datagrid('getSelected');
	var Typeid=rowdata.DisREQTypeID;
	var emflag="Y";
	var curStatus=rowdata.DisREQCurStatus;
	
	var dataList = [],LocUserList="";
	if(changerows.length==0){
		$.messager.alert("提示","请添加指定人员！"); 
		return false;
	}
	if(rows.length!=DisREQNums){
		$.messager.alert("提示","请添加"+DisREQNums+"个指定人员！"); 
		return false;
	}
	for(var i=0;i<rows.length;i++)
	{
		var tmp=rows[i].ID+"^"+rows[i].UserCode+"^"+rows[i].User;
		dataList.push(tmp);
	} 
	LocUserList=dataList.join("$c(1)");
	//alert(disreqID+"&"+typeID+"&"+11+"&"+LgUserID+"&"+emflag+"&"+""+"&"+LocUserList+"&"+curStatus);
	/// 安排指定人员 安排代码:11
	runClassMethod("web.DHCDISEscortArrage","ArrangeDisReq",{"pointer":disreqID,"type":Typeid,"statuscode":11,"lgUser":LgUserID,"EmFlag":emflag,"reason":"","LocUserList":LocUserList,"curStatus":curStatus},function(jsonString){
		if (jsonString==0){
			$.messager.alert("提示","保存成功！");
			WardNurserList(Typeid);
			search();
		}else{
			$.messager.alert('错误',jsonString+" 操作失败");
		}
	},'text');
}
//验证码明细    zwq
function verificatCode(){
	var selectRow = $('#DisReqtb').datagrid('getSelected');
	if (selectRow==null){
		$.messager.alert("提示:","请选一条数据！");
		return;
	}

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
	var iframe='<iframe scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.codedetail.csp?mainRowID='+disreqID+'"></iframe>';
	$('#vercodewin').html(iframe);
	$('#vercodewin').window('open'); 

}
/// 接受操作 zhaowuqiang
function Accept()
{
	var selectRow = $('#DisReqtb').datagrid('getSelected');
	if (selectRow==null){
		$.messager.alert("提示:","请选一条数据！");
		return;
	}
	var ReqType = selectRow.DisREQTypeID;
	runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":disreqID,"type":ReqType,"statuscode":12,"lgUser":LgUserID,"EmFlag":"Y"},function(jsonString){
		if (jsonString==0){
			$.messager.alert("提示","保存成功！");
			search();
		}else{
			$.messager.alert('错误',jsonString+" 操作失败");
		}
	},'text');
}
///   2017-05-31  zwq
function CancelArrange()
{
	var selectRow = $('#DisReqtb').datagrid('getSelected');
	if (selectRow==null){
		$.messager.alert("提示:","请选一条数据！");
		return;
	}
	var Crrstatue=selectRow.DisREQCurStatus;
	var TypeID = selectRow.DisREQTypeID;
	var statusCode=99;
	if(Crrstatue!="已安排")
	{
		$.messager.alert("提示:","已安排申请单才可以进行此操作!")
		return;
	}
	//var str=disreqID+"^"+TypeID+"^"+statusCode+"^"+LgUserID
	//alert(str)
	runClassMethod("web.DHCDISEscortArrage","CancelArrange",{"pointer":disreqID,"typeid":TypeID,"statuscode":statusCode,"lgUser":LgUserID},function(jsonString){
		if (jsonString==0){
			$.messager.alert("提示","操作成功！");
			search();
		}else{
			$.messager.alert('错误',jsonString);
		}
	},'text');
	
}
///   2017-05-31  zwq
function ArrangeToo()
{
	if(editRow>="0"){			///sufan 2017-11-23  可连续点安排保存数据
		$("#DisReqtb").datagrid('endEdit', editRow);
	}
	var selectRow=$('#DisReqtb').datagrid('getSelected');
	if (selectRow==null){
		$.messager.alert("提示:","请选一条数据！");
		return;
	}
	if((selectRow.DisREQCurStatus!="已安排")&&(selectRow.DisREQCurStatus!="待处理")&&(selectRow.DisREQCurStatus!="撤销安排"))
	{
		$.messager.alert("提示:","当前状态不允许此操作!");
		return;
	}
	if(selectRow.DisREQCurStatus=="已安排")
	{
		var rowsData = $("#DisReqtb").datagrid('getChanges');
		if(rowsData=="")
		{
			$.messager.alert("提示:","已安排护工，请核查！");
			return;
		}
		
	}
	if((selectRow.UserDr=="")||(selectRow.DisREQLocUser==""))
	{
		$.messager.alert("提示:","请选择陪送人员!");
		return;
	}
	var SetUserDr = selectRow.UserDr;
	var ReqID = selectRow.DisREQ
	var TypeID = selectRow.DisREQTypeID;
	var statusCode = 11;
	//var ss=ReqID+"^"+TypeID+"^"+SetUserDr+"^"+statusCode+"^"+LgUserID
	//alert(ss)
	runClassMethod("web.DHCDISEscortArrage","ArrangeToo",{"pointer":ReqID,"typeid":TypeID,"user":SetUserDr,"statuscode":statusCode,"lgUser":LgUserID},function(jsonString){
		if (jsonString==0){
			//$.messager.alert("提示","保存成功！");
			Select=""; //是否已安排
			$('#DisReqtb').datagrid('reload'); //重新加载
			//search();
		}else{
			$.messager.alert('错误',jsonString);
		}
	},'text',false);
	

}
