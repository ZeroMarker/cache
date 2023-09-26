/*
模块:		草药房
子模块:		草药房-处方追踪
Creator:	hulihua
CreateDate:	2018-01-08
*/
var NowTAB="#div-presc-condition"; // 记录当前tab

$(function(){
	InitPhaWard(); 				//病区
	InitGridPrescList();		//初始化处方列表
	InitGridAdm();				//初始化病人就诊列表
	InitGridAdmPrescList();		//初始化病人就诊处方表
	InitTrialDispTab();  		//主页面tab
	$("#monitor-condition").children().not("#div-presc-condition").hide();
	
	/* 表单元素事件 start*/
	//登记号回车事件
	$('#txt-patno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txt-patno").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				QueryInPhDispList();
			}	
		}
	});
	
	//住院号回车事件
	$('#txt-pameno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txt-pameno").val());
			if (patno!=""){
				QueryInPhDispList();
			}	
		}
	});
	
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	/* 表单元素事件 end*/
	
	InitBodyStyle();
})

window.onload=function(){
	if(LoadPrescNo==""){
		setTimeout("QueryInPhDispList()",1000);
	}else{
		QueryInPhDispList();
		//getSummary(LoadPrescNo);
	}
}

//初始化处方列表table
function InitGridPrescList(){
		var columns=[	
		{name:"TBedNo",index:"TBedNo",header:'床号',width:60},
		{name:"TPatNo",index:"TPatNo",header:'登记号',width:100},
		{name:"TPameNo",index:"TPameNo",header:'住院号',width:80},
		{name:"TPatName",index:"TPatName",header:'姓名',width:80},
		{name:"TAddOrdDate",index:"TAddOrdDate",header:'下医嘱日期',width:150},
		{name:"TPrescNo",index:"TPrescNo",header:'处方号',width:120,
			formatter:function(cellvalue, options, rowObject){
			    return "<a onclick=\"ViewMedBrothDisp()\" style='text-decoration:underline;'>"+cellvalue+"</a>";
			}
		},
		{name:"TPreFormType",index:"TPreFormType",header:'处方剂型',width:80},
		{name:"TFactor",index:"TFactor",header:'付数',width:50},
		{name:"TWardDesc",index:"TWardDesc",header:'病区',width:150,align:'left',formatter:splitFormatter},
		{name:"TAdmDate",index:"TAdmDate",header:'就诊时间',width:100}					
	];
	var jqOptions={
	    colModel: columns, //列
	    url: ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCINPHA.HMPresTrack.PresTrackQuery&MethodName=jsGetWardPatPresList', //查询后台	
	    height: DhcphaJqGridHeight(2,1),
	    fit:true,
	    multiselect: false,
	    shrinkToFit:false,
	    pager: "#jqGridPager", 	//分页控件的id
	    rownumbers: true,
	    datatype:"local",
	    onSelectRow:function(id,status){
			QueryGridDispSub()
		},
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				//$("#container").attr("src","");
				$('#container').empty();
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
	};
	$('#grid-wardpatprelist').dhcphaJqGrid(jqOptions);
}

//初始病人就诊table
function InitGridAdm(){
	var columns=[
		{name:"TAdm",index:"TAdm",header:'TAdm',width:10,hidden:true},	
		{name:"TCurrWard",index:"TCurrWard",header:'病区',width:120,align:'left',formatter:splitFormatter},
		{name:"TCurrentBed",index:"TCurrentBed",header:'床号',width:60},
		{name:"TPatNo",index:"TPatNo",header:'登记号',width:100},
		{name:"TPameNo",index:"TPameNo",header:'住院号',width:80},
		{name:"TDoctor",index:"TDoctor",header:'医生',width:60},
		{name:"TAdmDate",index:"TAdmDate",header:'就诊日期',width:80},
		{name:"TAdmTime",index:"TAdmTime",header:'就诊时间',width:80},
		{name:"TAdmLoc",index:"TAdmLoc",header:'就诊科室',width:120,align:'left',formatter:splitFormatter}					
	];
	 
	var jqOptions={
	    colModel: columns, //列
	    url: ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery&MethodName=jsQueryDispAdmList', //查询后台
	    height: DhcphaJqGridHeight(2,3)*0.4,
	    multiselect: false,
	    onSelectRow:function(id,status){
			var id = $(this).jqGrid('getGridParam', 'selrow');
			if (id) {
				$('#container').empty();
				var selrowdata = $(this).jqGrid('getRowData', id);
				var adm=selrowdata.TAdm;
				$("#grid-admpresclist").jqGrid("clearGridData");
				var params="^"+adm;
				$("#grid-admpresclist").setGridParam({
					datatype:'json',
					page:1,
					postData:{
						'params':params
					}
				}).trigger("reloadGrid"); 
			}
		},
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#grid-admpresclist").jqGrid("clearGridData");
				$('#container').empty();
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
	};
	$('#grid-admlist').dhcphaJqGrid(jqOptions);
}

//初始化病人就诊处方列表table
function InitGridAdmPrescList(){
		var columns=[
		{name:"TBedNo",index:"TBedNo",header:'床号',width:60},
		{name:"TPatName",index:"TPatName",header:'姓名',width:80},	
		{name:"TAddOrdDate",index:"TAddOrdDate",header:'下医嘱日期',width:150},
		{name:"TPrescNo",index:"TPrescNo",header:'处方号',width:120,
			formatter:function(cellvalue, options, rowObject){
			    return "<a onclick=\"ViewMedBrothDisp()\" style='text-decoration:underline;'>"+cellvalue+"</a>";
			}
		},
		{name:"TFactor",index:"TFactor",header:'付数',width:50},
		{name:"TPreFormType",index:"TPreFormType",header:'处方剂型',width:60},
		{name:"TSeekUserName",index:"TSeekUserName",header:'提交护士',width:100},
		{name:"TSeekDate",index:"TSeekDate",header:'提交日期',width:150},
		{name:"TPhaUserName",index:"TPhaUserName",header:'审方人',width:80},
		{name:"TPhaDate",index:"TPhaDate",header:'审方日期',width:150}					
	];
	var jqOptions={
	    colModel: columns, //列
	    url: ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCINPHA.HMPresTrack.PresTrackQuery&MethodName=jsGetWardPatPresList', //查询后台	
	    height: DhcphaJqGridHeight(2,3)*0.52,
	    fit:true,
	    multiselect: false,
	    shrinkToFit:false,
	    datatype:"local",
	    pager: "#jqGridPager1", 	//分页控件的id
	    onSelectRow:function(id,status){
			QueryGridDispSub()
		},
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				//$("#container").attr("src","");
				$('#container').empty();
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
	};
	$('#grid-admpresclist').dhcphaJqGrid(jqOptions);
}

function ClearConditons(){ 
	$('#grid-wardpatprelist').clearJqGrid();  	
}

function InitBodyStyle(){
	$('#container').empty();
	var wardtitleheight=$("#gview_grid-presclist .ui-jqgrid-hbox").height();
	var wardheight=DhcphaJqGridHeight(1,2)-wardtitleheight-50;
	var prescheight=DhcphaJqGridHeight(1,1)+60;
	$("#grid-wardpatprelist").setGridHeight(wardheight);
	$("#container").height(prescheight);
}

function InitTrialDispTab(){
	$("#tab-ipmonitor a").on('click',function(){	
		var tabId=$(this).attr("id");
		var tmpTabId="#div-"+tabId.split("-")[1]+"-condition";
		$(tmpTabId).show();
		$("#monitor-condition").children().not(tmpTabId).hide();
		NowTAB=tmpTabId;
		$('#container').empty();
		QueryInPhDispList();
	})
}

function QueryInPhDispList(){
	if (NowTAB=="#div-presc-condition"){
		var wardloc=$('#sel-phaward').val();
		if ((wardloc==null)||(wardloc=="")){wardloc=gLocId};
		if(LoadPrescNo&&LoadAdm){
			var params=wardloc+"^"+LoadAdm+"^"+LoadPrescNo;
		}else{
			var params=wardloc;
		}
		$("#grid-wardpatprelist").setGridParam({
			datatype:'json',
			page:1,
			postData:{
				'params':params
			}
		}).trigger("reloadGrid");
	}else{
		var patno=$("#txt-patno").val();
		if((patno=="")||(patno==null)){
			patno=$("#txt-pameno").val();
		}
		$("#grid-admlist").setGridParam({
			page:1,
			datatype:'json',
			postData:{
				'params':patno,
				'logonLocId':DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID
			}
		}).trigger("reloadGrid");
	}
	
	$("#txt-patno").val("");
	$("#txt-pameno").val("");
	return true;
}

//查询发药明细
function QueryGridDispSub(){
	var prescno=GetPrescNo();
	$('#container').empty();
    getSummary(prescno);
}

function getSummary(prescno)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: ChangeCspPathToAll(LINK_CSP)+"?ClassName=web.DHCINPHA.HMPresTrack.PresTrackQuery&MethodName=GetPresTrackJsonByPres&prescno="+prescno,
		async: true,
		data:"",
		success: function(d) {
			setSummary(eval("["+d+"]"));
		},
		error : function(d) { alert("获取追踪信息错误!");}
	});	
}

//显示追踪完成情况
function setSummary(data)
{
	var style = '<h2 class="first"><a class="more-history" href="#">处方时间轴</a></h2>';
	$('#container').append(style); 
	for (var i=0;i<data.length;i++)
	{
		var detial = '<h3><span class="fl">'+data[i].TPhaPreStatue+'</span><span class="fr"></b>'+data[i].TExecuteUser+'&nbsp;&nbsp;&nbsp;&nbsp;</b>'+data[i].TExeLoc+'</span></h3>'
		var content = $('<a href="#"></a>');
		$(content).append(detial);
		var tmpData ='<li class="green">'
		               +'<h3>'+data[i].TExecuteDate+'<span>'+data[i].TExecuteTime+'</span></h3>'
		               	+ $(content)[0].outerHTML
		            +'</li>';         
		$('#container').append(tmpData);           
	}
	systole();	
}

function systole(){
	if(!$(".history").length){
		return;
	}
	var $warpEle = $(".history-date"),
		parentH,
		eleTop = [];
	parentH = $warpEle.parent().height();
	$warpEle.parent().css({"height":parentH});
	setTimeout(function(){
		$warpEle.find("ul").children(":not('h2')").each(function(idx){
			eleTop.push($(this).position().top);
			$(this).css({"margin-top":-eleTop[idx]}).children().hide();
		}).animate({"margin-top":0}, 1600).children().fadeIn();
		$("html,body").animate({"scrollTop":parentH}, 2600);
		$warpEle.parent().animate({"height":parentH}, 2600);
		$warpEle.find("ul").children(":not('h2')").addClass("bounceInDown").css({"-webkit-animation-duration":"2s","-webkit-animation-delay":"0","-webkit-animation-timing-function":"ease","-webkit-animation-fill-mode":"both"}).end().children("h2").css({"position":"relative"});	
	}, 500);
};

//揭药信息追踪
function ViewMedBrothDisp(){
	$td = $(event.target).closest("td");
	var rowid=$td.closest("tr.jqgrow").attr("id");
	if (NowTAB=="#div-presc-condition"){
		var selectdata=$('#grid-wardpatprelist').jqGrid('getRowData',rowid);
	}else{
		var selectdata=$('#grid-admpresclist').jqGrid('getRowData',rowid);
	}
	var prescNo=selectdata.TPrescNo;
	var prescNo=$.jgrid.stripHtml(prescNo);
	ShowMedBrothDispWindow(prescNo);	
}

function ShowMedBrothDispWindow(prescNo){
	var columns=[
		{header:'应揭药日期',index:'TBrothDate',name:'TBrothDate'},
	    {header:'实际揭药日期',index:'TActBrothDate',name:'TActBrothDate'},
		{header:'揭药人',index:'TBrothName',name:'TBrothName'},
		{header:'应揭袋数',index:'TUnPocNum',name:'TUnPocNum'},
		{header:'实揭袋数',index:'TActUnPocNum',name:'TActUnPocNum'},
		{header:'揭药状态',index:'TBrothStatue',name:'TBrothStatue'},
		{header:'备注',index:'TBrothRemark',name:'TBrothRemark'},
		{header:'封箱日期',index:'TBoxCreateDate',name:'TBoxCreateDate'},
		{header:'封箱人',index:'TBoxCreateName',name:'TBoxCreateName'},
		{header:'发放日期',index:'TBoxPhHandDate',name:'TBoxPhHandDate'},
		{header:'发放人',index:'TBoxPhHandName',name:'TBoxPhHandName'},
		{header:'配送人',index:'TBoxLogisticsName',name:'TBoxLogisticsName'},
		{header:'签收日期',index:'TBoxWardHandDate',name:'TBoxWardHandDate'},
		{header:'签收人',index:'TBoxWardHandName',name:'TBoxWardHandName'},
		{header:'核对日期',index:'TNurCheckDate',name:'TNurCheckDate'},
		{header:'核对人',index:'TNurCheckUser',name:'TNurCheckUser'}
	]; 
	var jqOptions={
	    colModel: columns, //列
	    url: ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCINPHA.HMMedBroth.MedBrothDispQuery&MethodName=GetBroDispListByPresc', //查询后台
	    height: '100%',
	    autowidth:true,
	    datatype:'local'
	};
	$("#grid-medbrodisp").dhcphaJqGrid(jqOptions);
	$("#modal-getmedbrodisp").on('shown.bs.modal', function () {
		$("#grid-medbrodisp").setGridWidth($("#modal-getmedbrodisp .modal-body").width())
		$("#grid-medbrodisp").HideJqGridScroll({hideType:"X"});		
	});
	$("#grid-medbrodisp").setGridParam({
		datatype:'json',
		page:1,
		postData:{
			params:prescNo
		}
	}).trigger("reloadGrid")
	$('#modal-getmedbrodisp').modal('show');
}

//获取选中列的处方号
function GetPrescNo(){
	if (NowTAB=="#div-presc-condition"){
		var selectid = $("#grid-wardpatprelist").jqGrid('getGridParam', 'selrow');
		var selrowdata = $("#grid-wardpatprelist").jqGrid('getRowData', selectid);
	}else{
		var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
		var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
	}
	var prescNo=selrowdata.TPrescNo;
	var prescNo=$.jgrid.stripHtml(prescNo);
	return prescNo;
}	

function splitFormatter(cellvalue, options, rowObject){ 
	if(cellvalue.indexOf("-")>=0){
		cellvalue=cellvalue.split("-")[1];
	} 
	return cellvalue;  
}; 