/// Creator: qiaoqingao
/// CreateDate: 2017-01-05

$(document).ready(function() {
	//初始化参数
	initParam();
	
	//初始化布局
	initLayout();
	
	//初始化时间控件
	initDate();
	
	//初始化combo
	initCombo();
	
	//初始化bootstrap table
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
		
	rowData="";                 //选中行数据全局变量
}

function initLayout(){
	
	}

function initDate(){
	//结束开始日期
	$('#EndDate').dhccDate();
	$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))	

	$('#StartDate').dhccDate();
	$("#StartDate").setDate(new Date().Format("yyyy-MM-dd"))
	}


function initCombo(){
	
	
	$('#ApplayLoc').dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetApplayLoc&HospID="+hosp
	});
	
	$('#AffirmStatus').dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetAffirmStatus",
		minimumResultsForSearch:-1  
	});
	}

function initTable(){
	
	var columns = [
        {
	        title: '选择',
            checkbox: true
        }, {
	        field: 'newStatus',
            title: '当前状态'
	       },{
            field: 'applyDate',
            title: '申请日期'
        }, {
            field: 'applyTime',
            title: '申请时间'
        },  {
            field: 'currregNo',
            title: '登记号'
        }, {
            field: 'bedNo',
            align: 'center',
            title: '床号'
        }, {
            field: 'endemicArea',
            align: 'center',
            title: '病区'
        }, {
            field: 'taskID',
            align: 'center',
            title: '任务ID'  
        }, {
            field: 'acceptLoc',
            align: 'center',
            title: '接受科室'
        }, { 
            field: 'deliveryDate',
            align: 'center',
            title: '配送日期' //意识状态
        }, { 
            field: 'deliveryTime',
            align: 'center',
            title: '配送时间' //意识状态
        }, {
            field: 'deliveryWay',  //体温T 2016-09-03 congyue
            align: 'center',
            title: '配送方式'
        }, {
            field: 'deliveryType',
            align: 'center',
            title: '配送类型'
        }, {
            field: 'remarkDesc',
            align: 'center',
            title: '备注'
        }]
	var param=getParam();                                 //获取参数
	//data=$("#execTable").dhccTableM("getSelections");
    $('#cspAffirmStatusTb').dhccTable({
	    height:$(window).height()-300,
	    pageSize:1000,
	    pageList:[1000,2000],
	    striped:true,
		url: LINK_CSP+'?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisListOrd&param='+param,
        singleSelect:true,
        columns: columns,
        onCheck:function(row, $ele){
	        rowData= row;
	        
	    },
	    onUncheck:function (row, $ele){
			rowData= "";
		}
    })

var columns = [
		{
            field: 'projectName',
            align: 'center',
            title: '项目名称'
        },{
            field: 'toBourn',
            align: 'center',
            title: '去向'
        },
	]

$('#cspAffirmStatusCarefulTb').dhccTable({
	    height:$(window).height()-500,
	    pageSize:1000,
	    pageList:[1000,2000],
	    striped:true,
        //url: 'dhcapp.broker.csp?ClassName=web.DHCEMRegister&MethodName=ListRegisterNewBySetting',
        data:[
        ],
        singleSelect:true,
        columns: columns,
        queryParam:{
	        
		}
    })
}	
	
function initMethod(){
	 //回车事件
     $('#Regno').bind('keypress',RegNoBlur);
     
     $('#verifiBtn').bind('click',verifiDis); //验证确认
     $('#exeBtn').bind('click',exeDis);       //配送确认
 	
 	 $('#searchBtn').bind('click',search)	
 
     //详情点击事件
     $("#particulars").on('click',function(){
		particulars();   //详情
	 })
	 $("#appraiseBtn").on('click',function(){
	 	particulars();   //
	 })
	$("#unfiniBtn").on('click',function(){
	 	particulars();   //未完成                  
	 })
	 
	 
	 
}	



/*======================================================*/

//登记号回车事件
function RegNoBlur(event){
    if(event.keyCode == "13")    
    {
        var i;
	    var Regno=$('#Regno').val();
	    var oldLen=Regno.length;
	    if (oldLen>Params.regNoLen){
		    dhccBox.alert("登记号长度输入有误！","affirm");
		    $('#Regno').val("");
		    return;
		    }
		if (Regno!="") {  //add 0 before regno
		    for (i=0;i<Params.regNoLen-oldLen;i++)
		    //for (i=0;i<8-oldLen;i++)
		    {
		    	Regno="0"+Regno 
		    }
		}
	    $("#Regno").val(Regno);
    }
};

//验证确认
function verifiDis(){
	if((rowData=="")){
			dhccBox.alert("请选择其中一条记录！","affirmdetail")
			return;	
		}
		
	var param = {
		mainID:rowData.mainRowID
		}
	runClassMethod("web.DHCDISAffirmStatus","insetNewStatus","",
		function(data){ 
			alert(data);
		},'text',false)
	}

//配送确认
function exeDis(){
	if((rowData=="")){
			dhccBox.alert("请选择其中一条记录！","affirmdetail")
			return;	
		}
	dhccBox.confirm("配送确认","确认将改配送状态置为完成吗？","affirmDis",
		function(){
			//确定当前状态是否能置成完成
			//调用后台方法置状态
			//返回给前台置状态结果
		}
	)
}

//查询
function search(){
	
}

//详情 lvpeng 16-1-7
function particulars(){
	if((rowData=="")){
			dhccBox.alert("请选择其中一条记录！","affirmdetail")
			return;	
		}
		
	var thisID = $(event.target).attr("id");
	//详细界面
	if (thisID=="particulars"){
		//alert(rowData.mainRowID)
		option={
			title:'详情明细',
	  		type: 2,
	  		shadeClose: true,
	  		shade: 0.8,
	  		area: ['650px','400px'],
	  		content: 'dhcdis.disdetail.csp?mainRowID='+rowData.mainRowID
		}
	}
	//评分界面
	if (thisID=="appraiseBtn"){
		option={
			title:'评分',
	  		type: 2,
	  		shadeClose: true,
	  		shade: 0.8,
	  		area: ['650px','500px'],
	  		content: 'dhcdis.disappraise.csp?mainRowID='+rowData.mainRowID
		}	
	}
	
	//未完成原因
	if (thisID=="unfiniBtn"){
		option={
			title:'未完成原因',
	  		type: 2,
	  		shadeClose: true,
	  		shade: 0.8,
	  		area: ['650px','500px'],
	  		content: 'dhcdis.failreason.csp?mainRowID='+rowData.mainRowID
		}	
	}
	
	layer.open(option);	
}

//Table请求参数
//return ：开始时间^结束时间^任务ID^登记号^申请科室^状态
function getParam(){
	var stDate = $('#StartDate').getDate();
	var endDate=$('#EndDate').getDate();
	var taskID= $('#TaskID').val();
	var regno = $('#Regno').val();
	var applayLocDr= $('#ApplayLoc').val();
	var affirmStatus = $('#AffirmStatus').val();
	return stDate+"^"+endDate+"^"+taskID+"^"+applayLocDr+"^"+applayLocDr+"^"+affirmStatus
	}