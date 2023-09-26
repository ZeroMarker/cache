/// Creator: huaxiaoying
/// CreateDate: 2017-01-05
$(document).ready(function() {
     
	initform(); //初始化表单录入框
	inittable(); //初始化table
	refreshTableHeader()
    $("#left").css("height",$(window).height()-107);
	
	$('#regNo').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            regNoBlur()
        }
    });
	//$("#save").click(function(){
	//	$("#save").css("background","#c7ddf2");	
	//});

	
})
///补零方法
function regNoBlur()
{
	var i;
    var regNo=$('#regNo').val();
    var oldLen=regNo.length;
    if (oldLen==10) return;
	if (regNo!="") {  //add 0 before regno
	    for (i=0;i<10-oldLen;i++)
	    //for (i=0;i<8-oldLen;i++)
	    {
	    	regNo="0"+regNo 
	    }
	}
    $("#regNo").val(regNo);
}
///保存
function save(){
	regNo=$('#regNo').val();
	bedNo=$('#bedNo').val();
	ward=$('#ward').val();
	jobId=$('#jobId').val();
	RecLoc=$('#RecLoc').val();
	StartDate=$('#StartDate input').val(),
	startTime=$('#startTime input').val(),
	ReqType=$('#ReqType').val(),
	ReqWay=$('#ReqWay').val(),
	ReqNum=$('#ReqNum').val(),
	note=$('#note').val();
	if(regNo==""){
		dhccBox.alert("请填写登记号！","request-one");
	}else if(bedNo==""){
		dhccBox.alert("请填写床号！","request-two");
	}else if(ward==""){
		dhccBox.alert("请填写所在病区！","request-three");
	}else if(jobId==""){
		dhccBox.alert("请填写任务ID！","request-four");
	}else if(RecLoc==null){
		dhccBox.alert("请填写接收科室！","request-five");
	}else if(StartDate==""){
		dhccBox.alert("请选择陪送时间的日期！","request-six");
	}else if(startTime==""){
		dhccBox.alert("请选择或填写陪送时间！","request-seven");
	}else if(ReqType==null){
		dhccBox.alert("请选择陪送类型！","request-eight");
	}else if(ReqWay==null){
		dhccBox.alert("请选择陪送方式！","request-nine");
	}else if(ReqNum==null){
		dhccBox.alert("请选择陪送人数！","request-ten");
	}
	alert(regNo+bedNo+ward+jobId+RecLoc+StartDate+startTime+ReqType+ReqWay+ReqNum+note)
	
}
///  效验时间栏录入数据合法性 
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
		dhccBox.alert("小时数不能大于23！","register-one");
		return $('#'+ id).val();
	}
	
	var itme = InTime.substring(2,4);
	if (itme > 59){
		dhccBox.alert("分钟数不能大于59！","register-two");
		return $('#'+ id).val();
	}	
	return hour +":"+ itme;
}
/// 获取焦点后时间栏设置 add
function SetDHCCTime(id){
		
	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	InTime = InTime.replace(":","");
	return InTime;
}
///隐藏左侧
function lefthide(){
	leftshowHeight=$(window).height()-118
	$("#leftshow").show();
	$("#leftshow").css("height",leftshowHeight);
	//$("#goright").show();
	$("#left").hide();
	$("#goleft").hide();
	$("#right").css("left","31px");
}
///显示左侧
function leftshow(){
	$("#left").show();
	$("#goleft").show();
	$("#goright").hide();
	$("#leftshow").hide();
	$("#right").css("left","228px");
}
///表格header的重置
function refreshTableHeader(){
    var rtime = new Date();
    var timeout = false;
    var delta = 66;
    $(window).resize(function(){
        rtime = new Date();
        if(timeout == false){
            timeout = true;
            setTimeout(resizeend, delta);
        }
    });
    function resizeend(){
        if(new Date() - rtime < delta){
            setTimeout(resizeend, delta);
        }else{
            timeout = false;
            $('#DisReqOrdTb').dhccTableM("resetWidth");
            //$('#DisReqOthTb').dhccTableM("resetWidth");
        }
    }
    
}
//初始化表单录入框
function initform(){
	$('#RecLoc').dhccSelect({  //接收科室
		url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetApplayLoc&HospID="+hosp
	});
	$('#ReqType').dhccSelect({ //陪送类型
		url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisTypeList"
	});
	$('#ReqWay').dhccSelect({ //陪送方式
		url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisToolList"
	});
	$('#ReqNum').dhccSelect({ //陪送人数
		url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisNumlList",
		minimumResultsForSearch:-1 
	});
	$('#StartDate').dhccDate();
	$("#StartDate").setDate(new Date().Format("yyyy-MM-dd"))	
}
//初始化table
function inittable(){
	//患者列表
	$('#DisReqPatTable').dhccTable({
		formatLoadingMessage:function() {return "";},
	    formatRecordsPerPage:function(pageNumber){return ''},
	    formatShowingRows:function(pageFrom, pageTo, totalRows){return ''},
	    showHeader:false,
		pageSize:6,
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSkinTest&MethodName=GetSkinTestPat',
        columns: [
        {
            field: 'ff',
            formatter:'testFormater'
        }],
        
        onLoadSuccess:function(data){
	        total=data.total
			$("#patTestTitle").html("皮试("+total+")")
			if($("#EpisodeID").val()==""){
				if(total>0){
					$("#content-main").height(tabHeight);
					$("#EpisodeID").val(data.rows[0].EpisodeID);
					selectTest(data.rows[0].EpisodeID)   ;
				}
			}
	    },
	    onClickRow:function(row, $element, field){
		    $("#EpisodeID").val(row.EpisodeID)
		    selectTest(row.EpisodeID)
		}
    });
    
    //已申请列表
	$('#patReqedTable').dhccTable({
		formatLoadingMessage:function() {return "";},
	    formatRecordsPerPage:function(pageNumber){return ''},
	    formatShowingRows:function(pageFrom, pageTo, totalRows){return ''},
	    showHeader:false,
		pageSize:6,
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSkinTest&MethodName=GetSkinTestPat',
        columns: [
        {
            field: 'ff',
            formatter:'testFormater'
        }],
        
        onLoadSuccess:function(data){
	        total=data.total
			$("#patTestTitle").html("皮试("+total+")")
			if($("#EpisodeID").val()==""){
				if(total>0){
					$("#content-main").height(tabHeight);
					$("#EpisodeID").val(data.rows[0].EpisodeID);
					selectTest(data.rows[0].EpisodeID)   ;
				}
			}
	    },
	    onClickRow:function(row, $element, field){
		    $("#EpisodeID").val(row.EpisodeID)
		    selectTest(row.EpisodeID)
		}
    });
    //已选项目
	$('#DisReqSelectedProjectTb').dhccTable({
	    height:$(window).height()-262,
	    //sidePagination:'side',
	    pageSize:1000,
	    pageList:[1000,2000],
	    striped:true,
        url: 'dhcapp.broker.csp?ClassName=web.DHCEMRegister&MethodName=ListRegisterNewBySetting',
        singleSelect:true,
        columns: [
        //{title: '选择',checkbox: true},
        {
            field: 'num',
            title: '已选项目'
        }, {
            field: 'NurseLevel',
            align: 'center',
            title: '去向'
        }
        ],
        queryParam:{
			regNo:$('#Regno').val(),    
    		fromDate:$('#StartDate input').val(),
    		MarkNo:$('#Loc').val()
		},
		onDblClickRow:function(row){
			window.location.href="dhcem.patchecklev.csp?regNo="+row.currregno+"&ChekLevId="+row.EpisodeIDYY+"&StartTimeQ="+$('#StartDate input').val()+"&EndTimeQ="+$('#EndDate input').val();	
			}
    })
    
    //医嘱
    $('#DisReqOrdTb').dhccTable({
	    height:$(window).height()-317,
	    pageSize:10,
	    pageList:[50,80],
	    striped:true,
        url: 'dhcapp.broker.csp?ClassName=web.DHCEMRegister&MethodName=ListRegisterNewBySetting',
        singleSelect:true,
        columns: [
        //{title: '选择',checkbox: true},
        {
            field: 'num',
            title: '未选项目'
        },{
            field: 'VeerLocDesc',
            align: 'center',
            title: '检查时间'
        }, {
            field: 'NurseLevel',
            align: 'center',
            title: '检查科室'
        }
        ],
        queryParam:{
    		fromDate:$('#StartDate input').val()
		},
		onDblClickRow:function(row){
			}
    })
    //其他
    $('#DisReqOthTb').dhccTable({
	    height:$(window).height()-317,
	    pageSize:10,
	    pageList:[50,80],
	    striped:true,
        url: 'dhcapp.broker.csp?ClassName=web.DHCEMRegister&MethodName=ListRegisterNewBySetting',
        singleSelect:true,
        columns: [
        //{title: '选择',checkbox: true},
        {
            field: 'num',
            title: '未选项目'
        },{
            field: 'VeerLocDesc',
            align: 'center',
            title: '检查时间'
        }, {
            field: 'NurseLevel',
            align: 'center',
            title: '检查科室'
        }
        ],
        queryParam:{
    		fromDate:$('#StartDate input').val()
		},
		onDblClickRow:function(row){
			}
    })
     
}