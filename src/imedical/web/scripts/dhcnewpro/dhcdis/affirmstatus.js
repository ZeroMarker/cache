/// Creator: qiaoqingao&lvpeng
/// CreateDate: 2017-01-05

var createUser=""; //创建人 dws 2017-02-24
var varSelect=""   //空趟原因 ylp

$(document).ready(function() {
	//初始化参数
	initParam();
	
	//初始化时间控件
	initDate();
	
	//初始化combo
	initCombo();
	
	//初始化easyui datagrid
	initTable();
	
	//初始化控件绑定的事件
	initMethod();
	
});

//初始化参数
function initParam(){
	//用途：获取后台参数
	$.ajax({
		url:LINK_CSP,
		data:{
			"ClassName":"web.DHCDISAffirmStatus",
	        "MethodName":"GetParamByInit"
		},
		type:'get',
		async:false,
		dataType:'json',
		success:function (data){
			Params = data;    
		}
		})
		
	rowData="";   //选中行数据全局变量
}

//初始化时间框
function initDate(){
	$('#StrDate').datebox("setValue",formatDate(0));
	$('#EndDate').datebox("setValue",formatDate(0));	
}

//初始化datagrid
function initTable(){
	
	var columns = [[
		{
	        field: 'patname',
	        align: 'center',
            title: '姓名',
            width: 80
	    },
	    {
	        field: 'hosno',
	        align: 'center',
            title: '住院号',
            width: 80
	    },
     	{
	        field: 'mainRowID',
	        align: 'center',
	        hidden: true,
            title: '申请单ID',
            width: 80
	    },{
	        field: 'newStatus',
	        align: 'center',
            title: '当前状态',
            width: 80
	    },{
	        field: 'TypeID',
	        align: 'center',
	        hidden: true,
            title: '类型ID',
            width: 80
	    },{
            field: 'applyDate',
            align: 'center',
            title: '申请日期',
            width: 100
        }, /* {
            field: 'applyTime',
            align: 'center',
            title: '申请时间',
            width: 80
        },  */ {
            field: 'currregNo',
            align: 'center',
            title: '登记号',
            width: 100
        }, {
            field: 'bedNo',
            align: 'center',
            title: '床号',
            width: 80
        }, {
            field: 'endemicArea',
            align: 'center',
            title: '病区',
            width: 180
        }, {
            field: 'taskID',
            align: 'center',
            title: '验证码',
            width: 80 
        },{
            field: 'acceptLoc',
            align: 'center',
            title: '接收科室',
            hidden: true,
            width: 100
        },{ 
            field: 'deliveryDate',
            align: 'center',
            title: '陪送日期',
            width: 100 
        }, /* { 
            field: 'deliveryTime',
            align: 'center',
            title: '陪送时间',
            width: 60 
        }, */ {
            field: 'deliveryWay',  
            align: 'center',
            title: '陪送方式',
            width: 60
        }, {
            field: 'deliveryType',
            align: 'center',
            title: '陪送类型',
            width: 60
        }, {
            field: 'remarkDesc',
            align: 'center',
            title: '备注',
            width: 100
        }, 
        {
            field: 'dispeople',
            align: 'center',
            title: '陪送人员',
            width: 100
        }, {
            field: 'nullFlag',
            align: 'center',
            title: '空趟',
            hidden: true,
            width: 60
        }
        ]]
        
    var param=getParam(); //获取参数
    $('#cspAffirmStatusTb').datagrid({
	    url:LINK_CSP+'?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisListOrd&param='+param,
	   	//formatShowingRows:function(pageFrom, pageTo, totalRows){
		   	//pageTo=0;
		   	//totalRows=0
		    //return "第 "+pageFrom+" 到第 "+pageTo+" 条记录，共 "+totalRows+" 条记录"
		    //return "第 0到第 0 条记录，共 0 条记录"
		//},
	    fit:true,
	    rownumbers:true,
	    fitColumns:true,
	    columns:columns,
	    pageSize:20, // 每页显示的记录条数
	    pageList:[20,40],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
	    pagination:true,
	    onSelect:function(Index, row){
	        rowData= row;
	    },
	    onUnselect:function (Index, row){
			rowData= "";
		},
		onClickRow:function(Index, row){
			ClickRowDetail();
		}
	})
	
	var columnsdetail = [[
		{
	        field: 'projectName',
	        align: 'center',
	        title: '项目名称',
	        width: 250	        
        },{
            field: 'toBourn',
            align: 'center',
            title: '去向',
            width: 200
        }
        ]]
		
	$('#cspAffirmStatusCarefulTb').datagrid({
		columns:columnsdetail,
	    pageSize:20,
	    pageList:[20,40],
        singleSelect:true,
        loadMsg: '正在加载信息...',
	    pagination:true,
	    nowrap:false//数据自动换行
    })
 
}

//查询明细
function ClickRowDetail(){
	var row =$("#cspAffirmStatusTb").datagrid('getSelected');
	DisMainRowId=row.mainRowID; //申请id
	$('#cspAffirmStatusCarefulTb').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisListOrdDetail&DisMainRowId='+DisMainRowId
	});
	
	}

//初始化combobox
function initCombo(){
	$('#ApplayLoc').combobox({
		//url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo",
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' 
	});
	
	$('#AffirmStatus').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=StatusCombo&type="+0,// type 0: 陪送 ,1: 配送
		valueField:'id',
	    textField:'text'
	});
}

// 初始按钮绑定方法
function initMethod(){
	 //回车事件
     $('#RegNo').bind('keypress',RegNoBlur);
     //$('#verifiBtn').bind('click',verifiDis); //验证确认
     $('#exeBtn').bind('click',DisAffirm);       //陪送确认
     $("#undoBtn").bind('click',Undorequest)	//撤销申请
 	 $('#searchBtn').bind('click',search) //查找
 	 $('#nullflagBtn').bind('click',SetNullFlag) //设置空趟标识
 	 $('#requestCopy').bind('click',RequestCopy) //复制陪送申请
 	 $('#recieve').bind('click',Recieve)  
 	 $('#complete').bind('click',complete)
 	 $('#confirm').keydown(function (e) {
     if (e.keyCode == 13) {
        afterconfirm();
     }
 	 })
 	 
 	 $("#appraiseBtn").on('click',function(){
		if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
		}
	/*  if(($("#cspAffirmStatusTb").datagrid('getSelected').newStatus)=="已评价"){
		$.messager.alert("提示","该订单已评价！")
			return;
		} 
		*/
		//dws 2017-02-24 评价权限
		if((($("#cspAffirmStatusTb").datagrid('getSelected').newStatus)=="完成确认")||(($("#cspAffirmStatusTb").datagrid('getSelected').newStatus)=="已评价")||(($("#cspAffirmStatusTb").datagrid('getSelected').newStatus)=="空趟")){
			/*runClassMethod("web.DHCDISAppraise","getAffPeo",{mainRowId:DisMainRowId},function(data){
				if(data==LgUserID){
					createUser=data;
					appraise(); //打开评价界面
				}
				else{
					$.messager.alert("提示","申请单创建人才可以评价!");
				}
			});*/
			appraise(); //打开评价界面
		}
		else{
			$.messager.alert("提示","请完成确认申请单后再评价!");
		}
	 })
	 
	 $("#detailsbtn").on('click',function(){
	 	ParticularsPages();   //详情
	 })

	 $("#unfiniBtn").on('click',function(){
	 	unfinished();   //未完成                  
	 })
}


/*======================================================*/

//登记号回车事件
function RegNoBlur(event)
{
    if(event.keyCode == "13")    
    {
        var i;
	    var Regno=$('#RegNo').val();
	    var oldLen=Regno.length;
	    if (oldLen>Params.regNoLen){
		    $.messager.alert("提示","登记号长度输入有误！");
		    $('#RegNo').val("");
		    return;
		    }
		if (Regno!="") {  //add 0 before regno
		    for (i=0;i<Params.regNoLen-oldLen;i++)
		    //for (i=0;i<8-oldLen;i++)
		    {
		    	Regno="0"+Regno 
		    }
		}
	    $("#RegNo").val(Regno);
    }
}


//设置空趟标识
function SetNullFlag()
{
	if((rowData=="")){
		$.messager.alert("提示","请选择其中一条申请单！")
		return;	
	}
	var data=$("#cspAffirmStatusTb").datagrid('getSelected')
	if((data.newStatus=="已评价")){
		$.messager.alert("提示","申请单已评价，无法操作！");
		return;	
	}
	if((data.newStatus=="空趟")){
		$.messager.alert("提示","不允许重复置空趟！");
		return;	
	}
	if((data.newStatus=="待处理")||(data.newStatus=="")){
		$.messager.alert("提示","申请单未接受，无法置空趟！");
		return;	
	}
	var mainRowID=$("#cspAffirmStatusTb").datagrid('getSelected').mainRowID
	var varSelect=""      //空趟原因


	$('#NullReason').window({
		title:'空趟原因',
		collapsible:false,
		border:false,
		closed:false,
		width:300,
		height:200
	});
	
	$('#NullReason').window('open');
	$('#FailReason').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISAffirmStatus&MethodName=getFailReason',
		required : true,
	    idField:'id',
	    fitColumns:true,
	    fit: true,//自动大小  
		panelWidth:150,
		panelHeight:150,
		textField:'name',
		mode:'remote',
		valueField:'value',											
		textField:'text',
		onSelect:function(){
		varSelect = $(this).combobox('getValue');
		
		}
	});
	
	
}
// yuliping  空趟填写原因
function nullconfirm(){
	var reason=$('#FailReason').combobox('getValue')
	var mainID = rowData.mainRowID
	var TypeID = rowData.TypeID
	var ReqNo=rowData.taskID
	
	if(reason!=""){
		$.messager.confirm('确认空趟','确认将改陪送状态置为空趟吗？',function(r){
			if (r){
				runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":mainID,"type":TypeID,"statuscode":19,"lgUser":LgUserID,"EmFlag":"Y","reason":reason},
						function(data){
							if(data!=0){
								
								$.messager.alert("提示",data);	
							}
							else{
								
								runClassMethod("web.DHCDISAffirmStatus","SetNullFlag",{param:ReqNo},function(data){
										if(data==0){
											$.messager.alert("提示","成功!");
											$('#NullReason').window('close');
											$('#cspAffirmStatusTb').datagrid('reload')
										}
										else{
											$.messager.alert("提示","失败!");
										}
										//$('#cspAffirmStatusCarefulTb').datagrid('loadData', {total:0,rows:[]})
										
									});
							
							}
							
						},'text',false)
			$('#cspAffirmStatusTb').datagrid('reload');
			rowData="";
			}		
		})
				
	}
	
}

///复制陪送申请
function RequestCopy()
{
	if((rowData=="")){
		$.messager.alert("提示","请选择其中一条申请单！")
		return;	
	}

	$('#copyTime').window({
		title:'时间',
		collapsible:false,
		border:false,
		closed:false,
		width:500,
		height:260
	});
			
	$('#copyTime').window('open');
	InitCopyCombobox();  //初始化combobox
	GetReqMessage(rowData); //获取申请单信息
}
///初始化combobox
function InitCopyCombobox()
{
	$('#CopyRecLoc').combobox({ //接收科室    
	    //url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetApplayLoc&HospID="+hosp,
    	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote'     
	});
	$('#CopyReqType').combobox({ //陪送类型   
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisTypeList",    
	    valueField:'id',    
	    textField:'text'   
	});  
	$('#CopyReqWay').combobox({ //陪送方式 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisToolList",    
	    valueField:'id',    
	    textField:'text'   
	});
	$('#CopyTime').combobox({ //陪送时间 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=IntTime",    
	    valueField:'id',    
	    textField:'text',  
	});
	$('#CopyTimePart').combobox({ //陪送时间段 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisTimePart",    
	    valueField:'id',    
	    textField:'text',
	    panelHeight:'auto'
	});
}
///获取申请单信息  2017-06-02  zwq
function GetReqMessage(rowData)
{
	var ReqID=rowData.mainRowID;
	runClassMethod("web.DHCDISAffirmStatus","GetReqMessage",{'ReqID':ReqID},function(data){
				SetComboboxValue(data);
			},'text');
	
}
///给combobox设置原申请单默认值
function SetComboboxValue(ReqMessage)
{
	var CopyReqRecLocdr=ReqMessage.split("^")[0];
	var CopyReqWay=ReqMessage.split("^")[1];
	var CopyReqType=ReqMessage.split("^")[2];
	var CopyReqMark=ReqMessage.split("^")[3];
	if(CopyReqRecLocdr=="")
	{
		$('#CopyRecLoc').combobox({disabled:true});
	}
	else
	{
		$('#CopyRecLoc').combobox('setValue',CopyReqRecLocdr);
	}
	$('#CopyReqWay').combobox('setValue',CopyReqWay);
	$('#CopyReqType').combobox('setValue',CopyReqType);
	$('#CopyNote').combobox('setValue',CopyReqMark);
}
///确认复制陪送申请
function SureRequestCopy(){
	var ReqID=rowData.mainRowID
	var ReqRecLoc=rowData.acceptLoc
	var CopyReqRecLoc=$('#CopyRecLoc').combobox('getValue');//接收科室
	var CopyReqDate=$('#CopyStartDate').combobox('getValue'); //陪送日期
	var CopyReqWay=$('#CopyReqWay').combobox('getValue');
	var CopyReqTimePoint=$('#CopyTimePart').combobox('getText');
	var CopyReqType=$('#CopyReqType').combobox('getValue');
	var CopyReqTime=$('#CopyTime').combobox('getText')
	var CopyReqNote=$('#CopyNote').val()
	var CopyNum=1
	CopyDate=CopyReqDate+" "+CopyReqTime+" "+CopyReqTimePoint;
	if(CopyReqDate=="")
	{
		$.messager.alert("提示:","请选择陪送时间!");
		return;
	}
	if(CopyReqWay=="")
	{
		$.messager.alert("提示:","请选择陪送方式!");
		return;
	}
	if(CopyReqType=="")
	{
		$.messager.alert("提示:","请选择陪送类型!");
		return;
	}
	if(CopyReqTimePoint=="")
	{
		$.messager.alert("提示:","请选择陪送时间段!");
		return;
	}
	if((ReqRecLoc!="")&&(CopyReqRecLoc==""))
	{
		$.messager.alert("提示:","请选择接收科室!");
		return;
	}
	var CopyStr=CopyReqRecLoc+"^"+CopyDate+"^"+CopyReqType+"^"+CopyReqWay+"^"+CopyNum+"^"+CopyReqNote+"^"+locId+"^"+LgUserID
	runClassMethod("web.DHCDISAffirmStatus","RequestCopy",{'reqID':ReqID,'copyStr':CopyStr},function(data){
				if(data==0){
					$.messager.alert("提示","复制成功!");
					$('#copyTime').window('close');
				}
				else{
					$.messager.alert("提示","复制失败!");
				}
				$('#cspAffirmStatusTb').datagrid('reload')
			});
			rowData=="";
		
}
///点击取消,关闭复制窗口
function CancleRequestCopy()
{
	$('#copyTime').window('close');
}
//查询
function search(){
	//$('#cspAffirmStatusTb').datagrid('loadData', {total:0,rows:[]}); 
	var Params=getParam(); //获取参数
	//$('#cspAffirmStatusTb').datagrid('reload',{params:Params})
	$('#cspAffirmStatusTb').datagrid({
			queryParams:{param:Params}	
	})
	$('#cspAffirmStatusCarefulTb').datagrid('loadData', {total:0,rows:[]})
	
}	
//验证确认
function verifiDis()
{
	if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
		}
	createVertifyWin();

}

function createVertifyWin(){	
	if($('#confirmwin').is(":hidden")){
	   $('#confirmwin').window('open');
		return;
		}           ///窗体处在打开状态,退出	
	var option = {
		closed:"true"
	};
	new WindowUX('出科确认', 'confirmwin', '300', '180', option).Init();
	
}

///弹出出科确认窗口
function afterconfirm()
{
	var StatusCode=13
	var ReqID=rowData.mainRowID;
	var TypeID=rowData.TypeID
	runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":13,"lgUser":LgUserID,"EmFlag":"Y","reason":""},function(jsonString){
		if (jsonString==0){
			$.messager.alert("提示","确认成功！");
			$('#confirmwin').window('close');
		}else{
			$.messager.alert('错误',jsonString);
			return;
		}
	},'text');
	$('#cspAffirmStatusTb').datagrid('reload');
	rowData="";
}
//  **********************************************
function DisAffirm()
{
	if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
		}
	var CurrentStatus=rowData.newStatus
	if(CurrentStatus!="已安排")
	{
		$.messager.alert("提示:","当前状态不允许此操作!");
		return;
	}
	DisAffirmWindow();
}
function DisAffirmWindow()
{
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
			title:'评价',
			border:true,
			closed:"true",
			width:600,
			height:450,
			collapsible:false,
			minimizable:false,
			maximizable:false,
			resizable:false,
			collapsible:true,
			draggable:false,
			onClose:function(){
				$('#win').remove();  //窗口关闭时移除win的DIV标签
			}
		});
		
		//iframe 定义
	var iframe='<iframe id="ifraemApp" scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.disaffirm.csp?mainRowID='+DisMainRowId+'&createUser='+LgUserID+'&type='+rowData.TypeID+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}
//陪送确认
function exeDis(){
	if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
		}
	var mainID = rowData.mainRowID
	var TypeID = rowData.TypeID
	$.messager.confirm('配送确认','确认将改陪送状态置为完成确认吗？',function(r){
		if (r){
			runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":mainID,"type":TypeID,"statuscode":16,"lgUser":LgUserID,"EmFlag":"Y","reason":""},
					function(data){
						if(data!=0){
							$.messager.alert("提示",data);	
						}
						else{
							$.messager.alert("提示","操作成功！");
						}
						
					},'text',false)
			$('#cspAffirmStatusTb').datagrid('reload');
			rowData="";
		}		
	})
}

// 撤销申请
function Undorequest(){
	if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
	}
	var ReqID=rowData.mainRowID
	var StatusCode=100
	var ReqType=rowData.TypeID
	var CurStatus=$("#cspAffirmStatusTb").datagrid('getSelected').newStatus;
	if((CurStatus!="待处理")&&(CurStatus!=("撤销安排"))){
		$.messager.alert("提示","待处理或撤销安排的申请单才可以撤销！");
		return;	
		}
	//var ss=ReqID+"^"+StatusCode+"^"+ReqType+"^"+LgUserID
	//alert(ss)
	$.messager.confirm('确认','您确认想要删除该条记录吗？',function(r){
			if(r){
				runClassMethod("web.DHCDISAffirmStatus","CancelApplicaion",{'disreqID':ReqID,'statuscode':StatusCode,'type':ReqType,'lgUser':LgUserID},function(data){
					if(data!=0){
						$.messager.alert("提示",data)
					}else{
						$.messager.alert("提示","撤销成功！")
					}
				},'text',false)
				$('#cspAffirmStatusTb').datagrid('reload');
				rowData="";
			}	
	})
}


//详情弹出层页面
function ParticularsPages(mainRowID){
	if((rowData=="")){
		$.messager.alert("提示","请选择其中一条申请单！")
		return;	
	}
	if($('#detailswin').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="detailswin"></div>');

	$('#detailswin').window({
		title:'详情',
		border:true,
		closed:"true",
		width:800,
		height:400,
		collapsible:true,
		minimizable:false,
		maximizable:false,
		resizable:false,
		//draggable:false,
		onClose:function(){
			$('#detailswin').remove();  //窗口关闭时移除win的DIV标签
			}
	}); 

	//iframe 定义
	var iframe='<iframe scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.affirmdetail.csp?mainRowID='+rowData.mainRowID+'&typeID='+rowData.TypeID+'"></iframe>';
	$('#detailswin').html(iframe);
	$('#detailswin').window('open');
}


//评价弹出层界面 dws 2017-2-21 修改
function appraise(){
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
			title:'评价',
			border:true,
			closed:"true",
			width:600,
			height:350,
			collapsible:false,
			minimizable:false,
			maximizable:false,
			resizable:false,
			collapsible:true,
			draggable:false,
			onClose:function(){
				$('#win').remove();  //窗口关闭时移除win的DIV标签
			}
		}); 
		
	//iframe 定义
	var iframe='<iframe id="ifraemApp" scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.disappraise.csp?mainRowID='+DisMainRowId+'&createUser='+LgUserID+'&type='+rowData.TypeID+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}


//未完成界面窗口
function unfinished(){
	if((rowData=="")){
		$.messager.alert("提示","请选择其中一条申请单！")
		return;	
	}
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
		title:'未完成',
		border:true,
		closed:"true",
		width:600,
		height:400,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		resizable:false,
		draggable:false,
		onClose:function(){
			$('#win').remove();  //窗口关闭时移除win的DIV标签
			}
	}); 

	//iframe 定义
	var iframe='<iframe scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.failreason.csp"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');	
}

//Table请求参数
//return ：开始时间^结束时间^任务ID^登记号^申请科室^状态
function getParam(){
	var stDate = $('#StrDate').datebox('getValue');
	var endDate=$('#EndDate').datebox('getValue');
	var taskID= $('#TaskID').val();
	var regno = $('#RegNo').val();
	var applayLocDr= $('#ApplayLoc').combobox('getValue');
	var DisHosNo = $('#HosNo').val();
	if(applayLocDr==undefined){
		applayLocDr=""		
	}
	var affirmStatus = $('#AffirmStatus').combobox('getValue');
	if(affirmStatus==undefined){
		affirmStatus=""		
	}
	return stDate+"^"+endDate+"^"+taskID+"^"+regno+"^"+applayLocDr+"^"+affirmStatus+"^"+DisHosNo;
}
function Recieve()
{
	if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
		}
	var ReqID=rowData.mainRowID;
	var TypeID = rowData.TypeID
	runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":14,"lgUser":LgUserID,"EmFlag":"Y","reason":""},
					function(data){
						if(data!=0){
							$.messager.alert("提示",data);	
						}
						else{
							$.messager.alert("提示","操作成功！");
						}
						
					},'text',false)
	$('#cspAffirmStatusTb').datagrid('reload');
	rowData="";
}
function complete()
{
	if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
		}
	var ReqID=rowData.mainRowID;
	var TypeID = rowData.TypeID
	runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":15,"lgUser":LgUserID,"EmFlag":"Y","reason":""},
					function(data){
						if(data!=0){
							$.messager.alert("提示",data);	
						}
						else{
							$.messager.alert("提示","操作成功！");
						}
						
					},'text',false)
	$('#cspAffirmStatusTb').datagrid('reload');
	rowData="";
}
///  效验时间栏录入数据合法性 add 2016-09-23
function CheckDHCCTime(id){
	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	
	if (InTime.length < 4){InTime = "0" + InTime;}
	if (InTime.length != 4){
		dhccBox.alert("请录入正确的时间格式！例如:18:23,请录入1823","register-three");
		return $('#'+ id).val();
	}
	
	var hour = InTime.substring(0,2);
	if (hour > 23){
		//dhccBox.alert("我的message","classname");
		dhccBox.alert("小时数不能大于23！","register-one");
		return $('#'+ id).val();
	}
	
	var itme = InTime.substring(2,4);
	if (itme > 59){
		dhccBox.alert("分钟数不能大于59！","register-one");
		return $('#'+ id).val();
	}	
	return hour +":"+ itme;
}

/// 获取焦点后时间栏设置 add 2016-09-23
function SetDHCCTime(id){
		
	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	InTime = InTime.replace(":","");
	return InTime;
}