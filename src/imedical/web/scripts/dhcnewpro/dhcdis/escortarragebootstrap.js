/// Creator: congyue
/// CreateDate: 2017-01-12
/// Descript: 陪送申请查询安排

var TagCode="",CategoryRowId="",Dep=1;
var BPRNSTR="";
var hospitalDesc;
var btOffset; //开始条数
var btLimit;  //一页的行数
var btTotal; //总行数
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
function initParam(){
	/* $.ajax({
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
		}) */
	}

function initLayout(){
	
	}

function initDate(){
    //开始日期
    $('#StDate').dhccDate();
	$("#StDate").setDate(new Date().Format("yyyy-MM-dd"))	
    //结束日期
    $('#EndDate').dhccDate();
	$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))	
}


function initCombo(){
	$('#applyLoc').dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetApplayLoc&HospID="+hosp
	});
	
	$('#Status').dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetAffirmStatus",
		minimumResultsForSearch:-1  
	});
}

function initTable(){
	
	var columns = [
		/* {
	        title: '选择',
            checkbox: true
        }, */ {
			field: 'OerdDate',
			title: '申请日期',
			align: 'center'
		}, {
			field: 'PatNo',
			title: '登记号',
			align: 'center'
		}, {
			field: 'BedNo',
			title: '床号',
			align: 'center'
		}, {
			field: 'Ward',
			title: '病区',
			align: 'center'
		}, {
			field: 'TaskID',
			title: '任务ID',
			align: 'center'
		}, {
			field: 'LocDesc',
			title: '接收科室',
			align: 'center'
		}, {
            field: 'EscDate',
            title: '陪送日期',
            align: 'center'
        }, {
            field: 'EscMode',
            title: '陪送方式',
            align: 'center'
        }, {
            field: 'EscTyoe',
            title: '陪送类型',
            align: 'center'
        }, {
            field: 'Remark',
            title: '备注',
            align: 'center'
        }]
	var param=getParam();
    $('#escortarragetb').dhccTable({
	    height:200,
        //idField: 'id',
	    pageSize:10,
	    pageList:[10,20],
	    striped:true,
       	url: '',//'dhcapp.broker.csp?ClassName=web.DHCEMPhysiOreSheet&MethodName=QueryGetTempOrdInfo', ///"10"
        singleSelect:true,
        columns: columns,
        onClickRow:function (row,$ele){
	        rowData=row;
	        }
    })


//医嘱单列表 
    $('#escortarragetbs').dhccTable({
	    height:100,
	    pageSize:10,
	    pageList:[10,20],
        url: '',//'dhcapp.broker.csp?ClassName=web.DHCEMPhysiOreSheet&MethodName=QueryGetTempOrdInfo', ///"10"
        columns:  [{
			field: 'tt',
			title: '项目名称',
			align: 'center'
		}, {
			field: 'hh',
			title: '去向',
			align: 'center'
		}] ,
		singleSelect:true/* ,
        queryParam:{
	        Symp:$("#Symptom option:selected").text(),  
	        PCLAdmWayNo:$('#from').val(),              
	        NurLevel:$('#level').val(),                 
			regNo:$('#Regno').val(),    
    		fromDate:$('#StartDate input').val(),
    		toDate:$('#EndDate input').val(),
    		MarkNo:$('#Loc').val()
		} */
    })
}	
	
function initMethod(){
	 //回车事件
     $('#Regno').bind('keypress',RegNoBlur)
     //详情点击事件
     $("#particulars").on('click',function(){
		particulars();
	 })
	 $("#appraiseBtn").on('click',function(){
	 	particulars();
	 })
	$("#unfiniBtn").on('click',function(){
	 	particulars();
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

//详情 lvpeng 16-1-7
function particulars(){
	
	var thisID = $(event.target).attr("id");
	//详细界面
	if (thisID=="particulars"){
		var data=$('#cspAffirmStatusTb').dhccTableM("getSelections");
		if((data.length==0)){
			dhccBox.alert("请选择其中一条记录！","affirmdetail")
			return;	
		}
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


function getParam(){
	return "^^^^^";
	}
/// 2016/8/24 11:31:29
/// Title列内容样式修改
function orderName(value,rowData,rowIndex){
	return "<b class='ordertitle'>"+value+"</b>" ;
	}

function InitUIStatus()
{
	var tmpid="";
	$("input[type=checkbox]").click(function(){
		tmpid=this.id;
		if($('#'+tmpid).is(':checked')){
			$("input[type=checkbox][name="+this.name+"]").each(function(){
				if((this.id!=tmpid)&($('#'+this.id).is(':checked'))){
					$('#'+this.id).removeAttr("checked");
				}
			})
		}
	});
}
function StuModel(){
	
   $('#StPage').val("");
   $('#StRow').val("");
   $('#EdPage').val("");
   $('#EdRow').val("");
}
function StModel(){
	
   $('#EdRow').val("");
}

/// add lvpeng 16-12-29
/* function search(){
	if($('#OrdLong').attr('checked')=="checked"){
		findLong();	//长嘱
	}if($('#OrdTemp').attr('checked')=="checked"){
		Temp_click(); //临嘱
	}if($('#SelDate').is(':checked')){
		//开始日期
    	StDate=$('#StDate input').val();
    	//结束日期
    	EndDate=$('#EndDate input').val();
		if ((StDate=="")||(EndDate==""))
		{
			alert("请选择开始日期与结束日期");
			return;   //ssuser
		}
		
	}
} */
