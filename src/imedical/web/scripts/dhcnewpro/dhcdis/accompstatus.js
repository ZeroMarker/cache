/// Creator: lvpeng 
/// CreateDate: 2017-01-25

var createUser=""; //创建人 dws 2017-02-24

$(document).ready(function() {
	//初始化参数
	initParam();
	
	//初始化布局
	//initLayout();
	
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
	        field: 'REQ',
	        align: 'center',
            //title: 'mainRowID',
            hidden: true,
            width: 100
	    },  {
	        field: 'REQTypeID',
	        align: 'center',
	        //hidden: true,
            title: '任务类型ID',
            hidden: true,
            width: 100
	    },{
	        field: 'REQEmFlag',
	        align: 'center',
            title: '加急标志',
            hidden: true,
            width: 70
	    },{
	        field: 'REQCurStatus',
	        align: 'center',
            title: '当前状态',
            width: 70
	    }, {
            field: 'REQConfirmUser',
            align: 'center',
            title: '出科确认人',
            hidden: true,
            width: 50
        },{
            field: 'REQCreateDate',
            align: 'center',
            title: '申请日期',
            width: 80
        }, {
            field: 'REQCreateTime',
            align: 'center',
            title: '申请时间',
            width: 100
        }, {
            field: 'REQLoc',
            align: 'center',
            title: '申请科室',
            width: 80
        }, {
            field: 'REQNo',
            align: 'center',
            title: '验证码',
            width: 100  
        }, {
            field: 'REQRecLoc',
            align: 'center',
            title: '接收科室',
            width: 160
        }, { 
            field: 'REQExeDate',
            align: 'center',
            title: '配送日期',
            width: 100 
        }, { 
            field: 'REQExeTime',
            align: 'center',
            title: '配送时间',
            width: 100 
        }, {
            field: 'REQRemarks',
            align: 'center',
            title: '备注',
            width: 100
        }
        ]]
        
    var param=getParam(); //获取参数
    $('#cspAccompStatusTb').datagrid({
	    url:LINK_CSP+'?ClassName=web.DHCDISAccompStatus&MethodName=listGoodsRequest&param='+param,
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
	$('#cspAccompStatusTb').datagrid({
		rowStyler:function(index,row){
				if(row.REQEmFlag=="Y"){
					return 'color:#EE2C2C'
				}
			}
		
	})
	
	var columnsdetail = [[
		{
	        field: 'ITM',
	        align: 'center',
	        title: '项目名称',
	        width: 250	        
        },/* {
            field: 'RECLOC',
            align: 'center',
            title: '去向',
            width: 200
        }, */{
            field: 'QTY',
            align: 'center',
            title: '数量',
            width: 200
        }
        ]]
		
	$('#cspAccompStatusCarefulTb').datagrid({
		columns:columnsdetail,
	    pageSize:20,
	    pageList:[20,40],
        singleSelect:true,
        loadMsg: '正在加载信息...',
	    pagination:true
    })
    
}

///单击查询明细
function ClickRowDetail(){
	var row =$("#cspAccompStatusTb").datagrid('getSelected');
	DisMainRowId=row.REQ; ///父id
	//alert(DisMainRowId)
	$('#cspAccompStatusCarefulTb').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCDISAccompStatus&MethodName=listGoodsRequestItm&req='+DisMainRowId
	});
	
	}

//初始化combobox
function initCombo(){
	$('#ApplayLoc').combobox({
		//	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo",
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' 
	});
	
	$('#RecLoc').combobox({
		//	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo",
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' 
	});
	
	$('#AffirmStatus').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=StatusComboS&type="+1,// type 0: 陪送 ,1: 配送
		valueField:'id',    
	    textField:'text' 
	});
}

function initMethod(){
	 //回车事件
     $('#RegNo').bind('keypress',RegNoBlur);
     $('#verifiBtn').bind('click',verifiDis); 		//验证确认
     $('#exeBtn').bind('click',exeDis);       		//配送确认
 	 $('#undoBtn').bind('click',Undorequest);      	//撤销申请
 	 $('#printbarcode').bind('click',printbarcode); //打印条码
 	 $('#complete').bind('click',complete);			//完成
 	 $('#GetGoods').bind('click',GetGoods);			//接收
 	 $('#givenconfirm').keydown(function (e) {
     if (e.keyCode == 13) {
        afterconfirm();
     }
 	});
 	 
 	 
 	 $('#searchBtn').bind('click',search) //查找	
 	 
 	 $("#appraiseBtn").on('click',function(){
	 	if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
		}
	 	//dws 2017-02-24 评价权限
		if((($("#cspAccompStatusTb").datagrid('getSelected').REQCurStatus)=="已签收")||(($("#cspAccompStatusTb").datagrid('getSelected').REQCurStatus)=="已评价")){
			runClassMethod("web.DHCDISAppraise","getAccPeo",{mainRowId:DisMainRowId},function(data){
				if(data==LgUserID){
					createUser=data;
					ScorePages(); //打开评价界面
				}
				else{
					$.messager.alert("提示","申请单创建人才可以评价!");
				}
			});
			
		}
		else{
			$.messager.alert("提示","请签收申请单后再评价!");
		}
	 })
	 
	 $("#particulars").on('click',function(){
	 	ParticularsPages();   //详情
	 })
	 
	 
	 $("#unfiniBtn").on('click',function(){
	 	UndonePages();   //未完成                  
	 })
}


/*======================================================*/

//登记号回车事件
function RegNoBlur(event){
    if(event.keyCode == "13")    
    {
        var i;
	    var Regno=$('#RegNo').val();
	    var oldLen=Regno.length;
	    if (oldLen>Params.regNoLen){
		    $.messager.alert("提示","登记号长度输入有误！")
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
};

//查询
function search(){
	var Params=getParam(); //获取参数
	$('#cspAccompStatusTb').datagrid({
			queryParams:{param:Params}	
	})
	$('#cspAccompStatusCarefulTb').datagrid('loadData', {total:0,rows:[]})
}

//出库确认&出科确认
function verifiDis(){
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

///出库确认
function afterconfirm()
{
	var StatusCode=13
	
	var EmFlag=rowData.REQEmFlag
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	var UserCode=$('#givenconfirm').val();
	if(UserCode!=LgUserCode)
	{
		$.messager.alert("提示:","工号错误!")
		$('#givenconfirm').val('');
		return;
	}
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":13,"lgUser":LgUserID,"EmFlag":EmFlag,"reason":""},function(jsonString){
		if (jsonString==0){
			$.messager.alert("提示","确认成功！");
			$('#confirmwin').window('close');
		}else{
			$.messager.alert('错误',jsonString);
			return;
		}
	},'text');
	$('#cspAccompStatusTb').datagrid('reload');
	rowData="";
}

//签收确认
function exeDis(){
	if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
		}
	if((rowData.REQCurStatus!="完成")){			//sufan 2018-03-22 控制确认当前状态
			$.messager.alert("提示","非完成状态的申请不允许此操作！")
			return;	
		}
	var statuscode="" ;
	var EmFlag=rowData.REQEmFlag;
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	if(TypeID!="18")       //sufan 2018-03-22 按类型判断状态代码
	{
		statuscode="完成确认";
	}
	var datalist=ReqID+"#"+TypeID+"#"+statuscode+"#"+LgUserID+"#"+EmFlag;
	$.messager.confirm('配送确认','确认将改配送状态置为完成确认吗？',function(r){
		if (r){
			runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":statuscode,"lgUser":LgUserID,"EmFlag":EmFlag,"reason":""},
					function(data){
						if(data!=0){
							$.messager.alert("提示",data);	
						}
						else{
							$.messager.alert("提示","签收成功！");
						}
					},'text',false)
			$('#cspAccompStatusTb').datagrid('reload');
			rowData=""
		}	
	})
}

// 撤销申请
function Undorequest(){
	if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
	}
	var ReqID=rowData.REQ
	var StatusCode=100
	var ReqType=rowData.REQTypeID
	var CurStatus=rowData.REQCurStatus;
	if((CurStatus!="待处理")&&(CurStatus!=("撤销安排"))){
		$.messager.alert("提示","待处理或撤销安排的申请单才可以撤销！");
		return;	
		}
	//var ss=ReqID+"^"+StatusCode+"^"+ReqType+"^"+LgUserID
	//alert(ss)
	$.messager.confirm('确认','您确认要撤销该条申请单吗？',function(r){
			if(r){
				runClassMethod("web.DHCDISRequestCom","CancelApplicaion",{'disreqID':ReqID,'statuscode':StatusCode,'type':ReqType,'lgUser':LgUserID},function(data){
					if(data!=0){
						$.messager.alert("提示",data)
					}else{
						$.messager.alert("提示","撤销成功！")
					}
				},'text',false)
				$('#cspAccompStatusTb').datagrid('reload');
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

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcdis.accompdetail.csp?mainRowID='+rowData.REQ+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}


//评分弹出层界面
function ScorePages(){
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
			title:'评价',
			border:true,
			closed:"true",
			width:600,
			height:420,
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
	var iframe='<iframe scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.disappraise.csp?mainRowID='+DisMainRowId+'&createUser='+createUser+'&type='+rowData.REQTypeID+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');	
}

//未完成界面窗口
function UndonePages(){
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
		onClose:function(){
			$('#win').remove();  //窗口关闭时移除win的DIV标签
			}
	}); 

	//iframe 定义
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcdis.failreason.csp"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');	
}

//Table请求参数
//return ：开始时间^结束时间^任务ID^接收科室^申请科室^状态
function getParam(){
	var stDate = $('#StrDate').datebox('getValue');
	var endDate=$('#EndDate').datebox('getValue');
	var taskID= $('#TaskID').val();
	var regno = $('#RegNo').val();
	var recLoc = $('#RecLoc').combobox('getValue');
	if(recLoc==undefined){
		recLoc=""
	}
	var applayLocDr= $('#ApplayLoc').combobox('getValue');
	if(applayLocDr==undefined){
		applayLocDr=""		
	}
	var affirmStatus = $('#AffirmStatus').combobox('getValue');
	if(affirmStatus==undefined){
		affirmStatus=""		
	}
	return stDate+"^"+endDate+"^"+taskID+"^"+recLoc+"^"+applayLocDr+"^"+affirmStatus
}

function printbarcode()
{	
	if((rowData=="")){
		$.messager.alert("提示","请选择其中一条申请单！")
		return;	
	}
	var ReqID=rowData.REQ;
		runClassMethod("web.DHCDISAccompStatus","PrintBarCode",{"ReqID":ReqID},function(data){
						if((data==-1)||(data==-2)||(data=="")){
							$.messager.alert("提示:","条码有误!");
							return;
						}else {
								Print(data);
							}
					},'text',false)
}
///常规
function Print(data){	
		       
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCDIS_PC"); 
	
	var MyPara="RegNo"+String.fromCharCode(2)+data;
	//var MyPara="RegNo"+String.fromCharCode(2)+ExaReqObj.PatNo;

	//var myobj=document.getElementById("ClsBillPrint");
	DHCSTPrintFun(MyPara,"")	
}

function complete()
{
	if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
		}
	var EmFlag=rowData.REQEmFlag;
	if(EmFlag=="Y")
	{
		$.messager.alert("提示:","加急任务不允许此操作!");
		return;
	}
	if(rowData.REQCurStatus!="已安排"){			//sufan 2018-03-22 控制确认当前状态
		$.messager.alert("提示:","非已安排状态不允许此操作!");
		return;
	}
	var statuscode=""
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	if(TypeID!="18")
	{
		statuscode="完成"
	}
	var datastr=ReqID+"#"+TypeID+"#"+statuscode+"#"+LgUserID;
	//alert(datastr)
	runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":statuscode,"lgUser":LgUserID,"reason":""},function(jsonString){
		if (jsonString==0){
			$.messager.alert("提示","保存成功！");

		}else{
			$.messager.alert('错误',jsonString);
			return;
		}
	},'text');
	$('#cspAccompStatusTb').datagrid('reload');
	rowData="";
				
}
function GetGoods()
{
	if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
		}
	var EmFlag=rowData.REQEmFlag;
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":14,"lgUser":LgUserID,"EmFlag":EmFlag,"reason":""},function(jsonString){
		if (jsonString==0){
			$.messager.alert("提示","保存成功！");

		}else{
			$.messager.alert('错误',jsonString);
			return;
		}
	},'text');
	$('#cspAccompStatusTb').datagrid('reload');
	rowData="";
}

///打印程序
PrtAryData=new Array();
function DHCP_GetXMLConfig(encName,PFlag){
	////
	/////InvPrintEncrypt
	try{		
		PrtAryData.length=0
		runClassMethod("web.DHCXMLIO",
					   "ReadXML",
					   {'JSFunName':'DHCP_RecConStr',"CFlag":PFlag},
					    function(ret){ret},
					   "script",
					   false	
		)
		for (var i= 0; i<PrtAryData.length;i++){
			PrtAryData[i]=DHCP_TextEncoder(PrtAryData[i]) ;
		}
	}catch(e){
		alert(e.message);
		return;
	}
}

function DHCP_TextEncoder(transtr){
	if (transtr.length==0){
		return "";
	}
	var dst=transtr;
	try{
		dst = DHCWeb_replaceAll(dst, '\\"', '\"');
		dst = DHCWeb_replaceAll(dst, "\\r\\n", "\r\t");
		dst = DHCWeb_replaceAll(dst, "\\r", "\r");
		dst = DHCWeb_replaceAll(dst, "\\n", "\n");
		dst = DHCWeb_replaceAll(dst, "\\t", "\t");
	}catch(e){
		alert(e.message);
		return "";
	}
	return dst;
}

function DHCWeb_replaceAll(src,fnd,rep) 
{ 
	//rep:replace
	//src:source
	//fnd:find
	if (src.length==0) 
	{ 
		return ""; 
	} 
	try{
		var myary=src.split(fnd);
		var dst=myary.join(rep);
	}catch(e){
		alert(e.message);
		return ""
	}
	return dst; 
} 
function DHCP_RecConStr(ConStr){
	
	PrtAryData[PrtAryData.length]=ConStr;
	
}
//公共打印函数
function DHCSTPrintFun(inpara,inlist){
	
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
			
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false; 
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
			var PObj=new ActiveXObject("DHCOPPrint.ClsBillPrint")
			alert(PObj)
			var rtn=PObj.ToPrintDoc(inpara,inlist,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}

}