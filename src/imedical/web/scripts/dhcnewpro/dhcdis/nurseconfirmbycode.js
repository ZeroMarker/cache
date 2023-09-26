/**	配送申请确认界面
  * 重新整理 sufan 2018-05-11
  * 原申请安排界面
  * 变更为护工任务确认完成和完成界面
**/
var pid="1";
$(document).ready(function() {
		
	initArrgrid();			 //初始化确认列表
 	initsubgrid();
 	$("#discode").focus();  //设置焦点
 	
   	//物品码回车事件
	$('#discode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			SaveBarCode();
			QueryDisList();	 
		}     
	});
	
	//工号回车事件
	$('#usercode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			ExecuteSure();
		}    		 
	});
	
	$("#compty").on('click',EmptyCode);
	$("#confirm").on('click',ExecuteSure);
	$("#exeuser").val(LgUserName) 	
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
    $('#disItemList').datagrid({
		    url:LINK_CSP+'?ClassName=web.DHCDISGoodsRequest&MethodName=getDisLabel',
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
		        title: '确认人员',
		        width:100
		    },{ 
		        field: 'ExeDate',
		        align: 'center',
		        title: '确认日期',
		        width:100
		    }, { 
		        field: 'ExeTime',
		        align: 'center',
		        title: '确认时间',
		        width:100
		    },
		    {
		        field: 'REQPeople',
		        align: 'center',
		        title: '配送人员',
		        width:100
		    }, { 
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
			ClickRowDetail(row)
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
        }]],
	    pageSize:20,
	    pageList:[20,40],
        singleSelect:true,
        loadMsg: '正在加载信息...',
	    pagination:true
    })
}

//查询明细
function ClickRowDetail(row){
	$('#subTable').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCDISGoodsRequest&MethodName=listGoodsRequestItm&req='+row.REQ
	});	
}
///根据条码查询任务列表
function QueryDisList()
{
	var ReqDisCode=$.trim($("#discode").val());
	if (ReqDisCode!=""){
		var retValue=tkMakeServerCall("web.DHCDISGoodsRequest","CheckReqBarCode",ReqDisCode);
		if(retValue==-1){
			$.messager.alert("提示","配送物品码为空,请核实!");
			$("#discode").focus();
			return false;
		}
		if(retValue==-2){
			$.messager.alert("提示","配送物品码错误,请核实!");
			killTmpGlobal();
			$("#discode").val("");
			$("#discode").focus();
			return false;
		}else if(retValue==-3){
			$.messager.alert("提示","护工未签收,请核实!");
			killTmpGlobal();
			$("#discode").val("");
			$("#discode").focus();
			return false;
		}else if(retValue==-4){
			$.messager.alert("提示","此包裹已确认,请核实!");
			killTmpGlobal();
			$("#discode").val("");
			$("#discode").focus();
			return false;
		}else if(retValue==-5){
			$.messager.alert("提示","未找到申请信息,请核实!");
			killTmpGlobal();
			$("#discode").val("");
			$("#discode").focus();
			return false;
		}else{
			var params=ReqDisCode;
			$('#disItemList').datagrid('load',{params:params});  
			$("#discode").val("");
			//$("#usercode").focus();         
		}			
		
	}
	else{
		$.messager.alert("提示","配送物品码为空,请核实!"); 
	}
	$('#disItemList').datagrid('load',{params:ReqDisCode}); 
}

///sufan 2018-05-11 护工工作确认
function ExecuteSure()
{
	var userLoginID=$.trim($("#usercode").val());
	var userId="",userName=""
	if (userLoginID!="")
	{
		var retValue=tkMakeServerCall("web.DHCDISGoodsRequest","getExeUser",userLoginID);
		if(retValue=="-1")
		{
			$.messager.alert("提示","工牌错误,请核实！")
			return;
		}
		userId=retValue.split("^")[0];
		userName=retValue.split("^")[1];
		$("#exeuser").val("")
		$("#exeuser").val(userName)
	}else{
		$.messager.alert("提示","请扫描工牌！")
		return;
	}
	var rowsData = $("#disItemList").datagrid("getRows");
	if((rowsData.length<=0)){
		$.messager.alert("提示","请先扫描物品码！")
		$("#usercode").val(""); 
		$("#usercode").focus();  //设置焦点
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
		var DisUserId = rowsData[i].REQPeopleDr;		//护工Id
			
		var tmp=ReqID +"^"+ TypeID +"^"+ statuscode +"^"+ userId +"^"+ EmFlag +"^"+ "" +"^"+ Relation +"^"+ LocaFlag +"^"+ DisUserId ;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	runClassMethod("web.DHCDISGoodsRequest","DisTaskConfirm",{"ListData":params},function(jsonString){
		if (jsonString==0){
			//$.messager.alert("提示","保存成功！");
			killTmpGlobal();
			$("#usercode").val(""); 
			$("#discode").focus();  //设置焦点
		}else{
			$.messager.alert('错误',jsonString);
			return;
		}
	},'text');
	$('#disItemList').datagrid('reload');
	
}
///清空code
function EmptyCode()
{
	$("#discode").val("");
	$("#usercode").val("");
	$("#disItemList").datagrid('loadData',{total:0,rows:[]});
	$("#subTable").datagrid('loadData',{total:0,rows:[]});
	$("#discode").focus();  //设置焦点
}
function SaveBarCode()
{
	var BarCode=$("#discode").val();
	runClassMethod("web.DHCDISGoodsRequest","SaveBarCode",{"pid":pid,"BarCode":BarCode},function(jsonString){
	},'text');
}

function killTmpGlobal()
{
	runClassMethod("web.DHCDISGoodsRequest","killTmpGlobal",{},function(jsonString){
	},'',false)
}