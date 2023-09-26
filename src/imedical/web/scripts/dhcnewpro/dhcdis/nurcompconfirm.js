/// Descript: 陪送工作量完成
/// Creator : sufan
/// Date    : 2017-02-22
var editRow = ""; var AdmNo = "";
/// 页面初始化函数
function initPageDefault(){
	
	initButton();          ///  页面Button绑定事件	
	initItmlist();       	/// 初始页面DataGrid检查分类表
	
}
///检查分类 
function initItmlist(){
	
	
	var columns = [[
		
		{
	        field: 'ck',
	        checkbox:'true',
            
	    },{
	        field: 'patname',
	        //align: 'center',
            title: '姓名'
	    },
	    {
	        field: 'hosno',
	        //align: 'center',
            title: '住院号'
	    },
     	{
	        field: 'mainRowID',
	        //align: 'center',
	        hidden: true,
            title: '申请单ID'
	    },{
	        field: 'newStatus',
	        //align: 'center',
            title: '当前状态'
	    },{
	        field: 'TypeID',
	        //align: 'center',
	        hidden: true,
            title: '类型ID'
	    },{
            field: 'applyDate',
            //align: 'center',
            title: '申请日期'
        }, /* {
            field: 'applyTime',
            align: 'center',
            title: '申请时间',
            width: 80
        },  */ {
            field: 'currregNo',
            //align: 'center',
            title: '登记号'
        }, {
            field: 'bedNo',
            //align: 'center',
            title: '床号'
        }, {
            field: 'endemicArea',
            //align: 'center',
            title: '病区'
        }, {
            field: 'taskID',
            //align: 'center',
            title: '验证码',
            hidden: 'true'
        },{
            field: 'acceptLoc',
            //align: 'center',
            title: '接收科室',
            hidden: true
        },{ 
            field: 'deliveryDate',
            //align: 'center',
            title: '陪送日期'
        }, /* { 
            field: 'deliveryTime',
            align: 'center',
            title: '陪送时间',
            width: 60 
        }, */ {
            field: 'deliveryWay',  
            //align: 'center',
            title: '陪送方式'
        }, {
            field: 'deliveryType',
            //align: 'center',
            title: '陪送类型'
        }, {
            field: 'remarkDesc',
            //align: 'center',
            title: '备注'
        }, 
        {
            field: 'dispeople',
            //align: 'center',
            title: '陪送人员'
        }, {
            field: 'nullFlag',
            //align: 'center',
            title: '空趟',
            hidden: true
        },{
            field: 'ConfirDate',
            //align: 'center',
            title: '确认日期',
            hidden: false
        },{
            field: 'ConfirUser',
            //align: 'center',
            title: '确认人员',
            hidden: false
        }, {
            field: 'AssNumber',
            //align: 'center',
            title: '评分',
        }, {
            field: 'AssRemarks',
            //align: 'center',
            title: '评价',
           
        }
        ]]
    var param=getinParam(); //获取参数
	///  定义datagrid  
	var option = {
	    	rownumbers:true,
	    	//fitColumns:true,
	    	columns:columns,
	   		pageSize:50,
	    	pageList:[50],
	    	//singleSelect:true,
	    	loadMsg: '正在加载信息...',
	   	 	pagination:true,
			onClickRow:function(Index, row){
			//ClickRowDetail();
			},
			onLoadSuccess: function (data) {
      			$('#reqdislist').datagrid('clearSelections');
			}
	};
	var uniturl = $URL+'?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisListOrdEscort&param='+param+'&PatLoc='+""+'&AdmNo='+""+'&HospID='+LgHospID;
	new ListComponent('reqdislist', columns, uniturl, option).Init(); 
	
}
/// 页面 Button 绑定事件
function initButton(){
	
	$('#StrDateS').datebox("setValue",formatDate(0));
	$('#EndDateS').datebox("setValue",formatDate(0));
	$('#AffirmStatusS').combobox({
		url:$URL+"?ClassName=web.DHCDISCommonDS&MethodName=StatusCombo&type="+0,// type 0: 陪送 ,1: 配送
		valueField:'id',
	    textField:'text',
	    mode:'remote'
	});
	runClassMethod("web.DHCDISRequest","getStatusValue",{'code':11},function(data){
		$('#AffirmStatusS').combobox("setValue",data);
	},'text',false)
	///初始化陪送人员下拉框
	$('#Escortper').combobox({
		url:$URL+"?ClassName=web.DHCDISEscortArrage&MethodName=GetSSUser",
		valueField:'value',
	    textField:'text',
	    mode:'remote'
	});
    ///  增加检查分类
	$('#Complete').bind("click",Complete);
	$('#searchBtn').bind('click',search) 			//查找
	
}
//查询
function search(){
	
	var Params=getinParam(); //获取参数
	$('#reqdislist').datagrid('load',{param:Params,PatLoc:"",AdmNo:"",HospID:LgHospID}); 
	
}
function getinParam(){
	var stDate = $('#StrDateS').datebox('getValue');
	var endDate=$('#EndDateS').datebox('getValue');
	var affirmStatus = $('#AffirmStatusS').combobox('getValue');
	if(affirmStatus==undefined){
		affirmStatus=""		
	}
	var Escortper = $("#Escortper").combobox('getValue');
	if(Escortper==undefined){
		Escortper=""		
	}
	return stDate+"^"+endDate+"^"+""+"^"+""+"^"+""+"^"+affirmStatus+"^"+""+"^"+Escortper;
}
///sufan 2017-12-20
///PC端处理已安排的陪送申请    
function Complete()
{
	var statuText=$("#AffirmStatusS").combobox("getText")
	if(statuText!="已安排")
	{
		$.messager.alert("提示","请根据查询条件“已安排”查询出已安排的申请，再确认完成！")
		return;	
	}
	var selItems = $('#reqdislist').datagrid('getSelections');  /// sufan 2017-12-15 修改批量确认
	if(selItems.length==0){
		$.messager.alert("提示","请选择其中一条申请单！")
		return;	
	}
	
	var ReqIDArr= new Array();
	var ReqTypeArr= new Array();
	var count=0
	for(i = 0;i < selItems.length; i++)
	{
		var ReqID = selItems[i].mainRowID ;
		var ReqType = selItems[i].TypeID ;
		var newStatus = selItems[i].newStatus;
		if(newStatus.indexOf("安排")<0){continue;}
		count=count+1
		ReqIDArr.push(ReqID);
		ReqTypeArr.push(ReqType);
	}
	if(count==0){
		$.messager.alert("提示","不包含已安排状态的申请！")
		return;	
	}
	updEscAppCompletstaArray(ReqIDArr.toString(),ReqTypeArr.toString());
}

///更新陪送申请完成状态
function updEscAppCompletstaArray(reqIDStr,reqTypeStr){

	var statusCode=12;
	runClassMethod("web.DHCDISAffirmStatus","CancelApplicaionArray",{'ReqIDStr':reqIDStr,'ReqTypeStr':reqTypeStr,'StatusCode':statusCode,'LgUser':LgUserID},function(data){
		
		if(data!=0){
			$.messager.alert("提示",data)
		}else{
			
			
		}
	})
	$('#reqdislist').datagrid('reload');
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
