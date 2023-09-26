/*
ģ��:		��ҩ��
��ģ��:		��ҩ��-����׷��
Creator:	hulihua
CreateDate:	2018-01-08
*/
var NowTAB="#div-presc-condition"; // ��¼��ǰtab

$(function(){
	InitPhaWard(); 				//����
	InitGridPrescList();		//��ʼ�������б�
	InitGridAdm();				//��ʼ�����˾����б�
	InitGridAdmPrescList();		//��ʼ�����˾��ﴦ����
	InitTrialDispTab();  		//��ҳ��tab
	$("#monitor-condition").children().not("#div-presc-condition").hide();
	
	/* ��Ԫ���¼� start*/
	//�ǼǺŻس��¼�
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
	
	//סԺ�Żس��¼�
	$('#txt-pameno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txt-pameno").val());
			if (patno!=""){
				QueryInPhDispList();
			}	
		}
	});
	
	//�������лس��¼�
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	/* ��Ԫ���¼� end*/
	
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

//��ʼ�������б�table
function InitGridPrescList(){
		var columns=[	
		{name:"TBedNo",index:"TBedNo",header:'����',width:60},
		{name:"TPatNo",index:"TPatNo",header:'�ǼǺ�',width:100},
		{name:"TPameNo",index:"TPameNo",header:'סԺ��',width:80},
		{name:"TPatName",index:"TPatName",header:'����',width:80},
		{name:"TAddOrdDate",index:"TAddOrdDate",header:'��ҽ������',width:150},
		{name:"TPrescNo",index:"TPrescNo",header:'������',width:120,
			formatter:function(cellvalue, options, rowObject){
			    return "<a onclick=\"ViewMedBrothDisp()\" style='text-decoration:underline;'>"+cellvalue+"</a>";
			}
		},
		{name:"TPreFormType",index:"TPreFormType",header:'��������',width:80},
		{name:"TFactor",index:"TFactor",header:'����',width:50},
		{name:"TWardDesc",index:"TWardDesc",header:'����',width:150,align:'left',formatter:splitFormatter},
		{name:"TAdmDate",index:"TAdmDate",header:'����ʱ��',width:100}					
	];
	var jqOptions={
	    colModel: columns, //��
	    url: ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCINPHA.HMPresTrack.PresTrackQuery&MethodName=jsGetWardPatPresList', //��ѯ��̨	
	    height: DhcphaJqGridHeight(2,1),
	    fit:true,
	    multiselect: false,
	    shrinkToFit:false,
	    pager: "#jqGridPager", 	//��ҳ�ؼ���id
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

//��ʼ���˾���table
function InitGridAdm(){
	var columns=[
		{name:"TAdm",index:"TAdm",header:'TAdm',width:10,hidden:true},	
		{name:"TCurrWard",index:"TCurrWard",header:'����',width:120,align:'left',formatter:splitFormatter},
		{name:"TCurrentBed",index:"TCurrentBed",header:'����',width:60},
		{name:"TPatNo",index:"TPatNo",header:'�ǼǺ�',width:100},
		{name:"TPameNo",index:"TPameNo",header:'סԺ��',width:80},
		{name:"TDoctor",index:"TDoctor",header:'ҽ��',width:60},
		{name:"TAdmDate",index:"TAdmDate",header:'��������',width:80},
		{name:"TAdmTime",index:"TAdmTime",header:'����ʱ��',width:80},
		{name:"TAdmLoc",index:"TAdmLoc",header:'�������',width:120,align:'left',formatter:splitFormatter}					
	];
	 
	var jqOptions={
	    colModel: columns, //��
	    url: ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery&MethodName=jsQueryDispAdmList', //��ѯ��̨
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

//��ʼ�����˾��ﴦ���б�table
function InitGridAdmPrescList(){
		var columns=[
		{name:"TBedNo",index:"TBedNo",header:'����',width:60},
		{name:"TPatName",index:"TPatName",header:'����',width:80},	
		{name:"TAddOrdDate",index:"TAddOrdDate",header:'��ҽ������',width:150},
		{name:"TPrescNo",index:"TPrescNo",header:'������',width:120,
			formatter:function(cellvalue, options, rowObject){
			    return "<a onclick=\"ViewMedBrothDisp()\" style='text-decoration:underline;'>"+cellvalue+"</a>";
			}
		},
		{name:"TFactor",index:"TFactor",header:'����',width:50},
		{name:"TPreFormType",index:"TPreFormType",header:'��������',width:60},
		{name:"TSeekUserName",index:"TSeekUserName",header:'�ύ��ʿ',width:100},
		{name:"TSeekDate",index:"TSeekDate",header:'�ύ����',width:150},
		{name:"TPhaUserName",index:"TPhaUserName",header:'����',width:80},
		{name:"TPhaDate",index:"TPhaDate",header:'������',width:150}					
	];
	var jqOptions={
	    colModel: columns, //��
	    url: ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCINPHA.HMPresTrack.PresTrackQuery&MethodName=jsGetWardPatPresList', //��ѯ��̨	
	    height: DhcphaJqGridHeight(2,3)*0.52,
	    fit:true,
	    multiselect: false,
	    shrinkToFit:false,
	    datatype:"local",
	    pager: "#jqGridPager1", 	//��ҳ�ؼ���id
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

//��ѯ��ҩ��ϸ
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
		error : function(d) { alert("��ȡ׷����Ϣ����!");}
	});	
}

//��ʾ׷��������
function setSummary(data)
{
	var style = '<h2 class="first"><a class="more-history" href="#">����ʱ����</a></h2>';
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

//��ҩ��Ϣ׷��
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
		{header:'Ӧ��ҩ����',index:'TBrothDate',name:'TBrothDate'},
	    {header:'ʵ�ʽ�ҩ����',index:'TActBrothDate',name:'TActBrothDate'},
		{header:'��ҩ��',index:'TBrothName',name:'TBrothName'},
		{header:'Ӧ�Ҵ���',index:'TUnPocNum',name:'TUnPocNum'},
		{header:'ʵ�Ҵ���',index:'TActUnPocNum',name:'TActUnPocNum'},
		{header:'��ҩ״̬',index:'TBrothStatue',name:'TBrothStatue'},
		{header:'��ע',index:'TBrothRemark',name:'TBrothRemark'},
		{header:'��������',index:'TBoxCreateDate',name:'TBoxCreateDate'},
		{header:'������',index:'TBoxCreateName',name:'TBoxCreateName'},
		{header:'��������',index:'TBoxPhHandDate',name:'TBoxPhHandDate'},
		{header:'������',index:'TBoxPhHandName',name:'TBoxPhHandName'},
		{header:'������',index:'TBoxLogisticsName',name:'TBoxLogisticsName'},
		{header:'ǩ������',index:'TBoxWardHandDate',name:'TBoxWardHandDate'},
		{header:'ǩ����',index:'TBoxWardHandName',name:'TBoxWardHandName'},
		{header:'�˶�����',index:'TNurCheckDate',name:'TNurCheckDate'},
		{header:'�˶���',index:'TNurCheckUser',name:'TNurCheckUser'}
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url: ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCINPHA.HMMedBroth.MedBrothDispQuery&MethodName=GetBroDispListByPresc', //��ѯ��̨
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

//��ȡѡ���еĴ�����
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