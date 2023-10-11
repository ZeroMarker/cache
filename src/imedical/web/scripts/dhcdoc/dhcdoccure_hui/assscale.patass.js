//===========================================================================================
// 作者：      nk
// 编写日期:   2021-05-26
// 描述:	   assscale.patass.js  评定量表
//===========================================================================================
var PageLogicObj={
	cspName:"doccure.assscale.patass.hui.csp",
	AssScaleApplyListDataGrid:""	
}
$(function(){
	Init();
	InitEvent();
})

window.onload = onload_handler;
/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {
	reloadForm("","","","2");
}

/// 页面初始化函数
function Init(){
	InitComponent();   /// 初始化组件
	InitAssScaleApplyListDataGrid();     /// 初始化列表
	//InitAssScaleListDataGrid();
	//initShowBillType();
	//加载患者信息条
	InitPatInfo(ServerObj.EpisodeID);
}

function InitEvent(){
	InitPatNoEvent(AssScaleApplyListDataGridLoad);
	$('#btnFind').click(AssScaleApplyListDataGridLoad);	
	togglePanelExpand();
}

function InitPatInfo(EpisodeID){
	if(EpisodeID!=""){
		$(".PatInfolabel").css("display","none");
		$(".PatInfoItem").css("display","block");
		if(typeof InitPatInfoBanner){
			InitPatInfoBanner(EpisodeID); 
		}
	}else{
		$(".PatInfolabel").css("display","block");
		$(".PatInfoItem").css("display","none");
	}	
}

function togglePanelExpand(){
	var wp = $("#CenterPanel").layout("panel", "west");
	var cp = $("#CenterPanel").layout("panel", "center");
	$(wp).panel({
		onExpand:function(){
			IFrameReSizeWidth("FormMain",-200)
		},
		onCollapse:function(){
			IFrameReSizeWidth("FormMain",200)
		}	
	})	
}

/// 初始化组件
function InitComponent(){
	/// 开始日期
	$HUI.datebox("#StartDate").setValue(ServerObj.EarlyDate);
	/// 结束日期
	$HUI.datebox("#EndDate").setValue(ServerObj.CurrentDate);
	InitComboAdm();
	$HUI.combobox("#ScaleCat",{
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.AssScaleConfig&MethodName=GetAssScaleCat",
		valueField:'value',
		textField:'text',
		mode:'remote',
		placeholder:$g("请选择评定量表分类"),
		onSelect:function(option){
			AssScaleListDataGridLoad();
	    },onChange:function(n,o){
			if(n==""){
				$(this).combobox("select","");	
				AssScaleListDataGridLoad();
			}
		}	
	})
	
	$("#ApplyAssScale").keywords({
	    singleSelect:true,
	    labelCls:'red',
	    items:[
	    ],
	    onClick:function(o){
		   reloadForm("",o.id,"","1"); 
		}
	});
}

function LoadApplyAssScaleKeyword(AssScoreID){
	var SessionExpID=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+ServerObj.LgHospID+"^"+session['LOGON.LANGID'];
	var ExpStr=PageLogicObj.cspName;
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.AssScale",
		MethodName:"GetAssScoreList",
		AssScoreID:AssScoreID,
		SessionExpID:SessionExpID,
		ExpStr:ExpStr,
		dataType:"text"
	},function(jsonString){
		var itemArr = [];
		if (jsonString != null){
			var jsonArr=JSON.parse(jsonString); 
			for(var i=0;i<jsonArr.length;i++){
				var obj=jsonArr[i];	
				if(obj.selected=="1"){
					obj.selected=true;	
				}else{
					obj.selected=false;		
				}
				itemArr.push(obj)
			}
			
		}
		$("#ApplyAssScale").keywords({
		    items:itemArr
		});	
	})
}

function InitAssScaleApplyListDataGrid(){
	///  定义columns
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'ScoreLabel',title:'评定量表',width:220,formatter:setCellLabel},
		{field:'OrderBilled',title:'缴费状态',width:70},
		{field:'Date',title:'申请日期',width:100},
		{field:'Time',title:'申请时间',width:80},
		{field:'User',title:'申请医师',width:80},
		{field:'PAAdmLoc',title:'就诊科室',width:150},
		{field:'PAAdmType',title:'就诊类型',width:70},
		{field:'DCASStatus',title:'DCASStatus',width:20,hidden:true},
		{field:'EpisodeID',title:'EpisodeID',width:20,hidden:true},
		{field:'DCASOEORIDR',title:'DCASOEORIDR',width:20,hidden:true},
		{field:'AssScaleID',title:'AssScaleID',width:20,hidden:true}
	]];
	//$("#tabAssScaleList").treegrid({  
	$HUI.datagrid("#bmDetList",{
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : true,
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.AssScale&QueryName=QryAssScoreList",
		loadMsg : '加载中..',  
		pagination : true,  
		pageSize : 20,
		pageList : [10,20,50],
		rownumbers : true, 
		idField:"ID",
		//treeField:'DCASDesc',
		columns :columns,
		onBeforeLoad:function(param){
			var StartDate=$("#StartDate").datebox("getValue");
			var EndDate=$("#EndDate").datebox("getValue");
			var gtext=$HUI.lookup("#ComboAdm").getText();
			if(gtext==""){$("#PAAdmID").val("")};
			var queryAdmID=$("#PAAdmID").val();
			var queryPatID=$("#PatientID").val();
			var AllFlag="";
	        if ($HUI.switchbox("#Check_AllStatus").getValue()) {
				AllFlag="ALL";
			}
			var SessionExpID=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+ServerObj.LgHospID+"^"+session['LOGON.LANGID'];
			var ExpStr=PageLogicObj.cspName;
			$.extend(param,{StartDate:StartDate,EndDate:EndDate,PAAdmID:queryAdmID,PatientID:queryPatID,Status:AllFlag,SessionExpID:SessionExpID,ExpStr:ExpStr});
			$HUI.datagrid("#bmDetList").unselectAll();
		},onLoadSuccess:function(data){
		    ///  隐藏分页图标
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();	
		},
		onClickRow: function (rowIndex, rowData) {
			//opdoc.patinfobar.view.InitPatInfo(rowData.EpisodeID,$(window).width()-390);
			InitPatInfo(rowData.EpisodeID);
			reloadForm(rowData.AssScaleID,rowData.ID,rowData.EpisodeID,"1");
			LoadApplyAssScaleKeyword(rowData.ID);
        }
	});
}

function AssScaleApplyListDataGridLoad(){
	$HUI.datagrid("#bmDetList").reload();
}

/// 申请列表 卡片样式
function setCellLabel(value, rowData, rowIndex){
	if(rowData.ScoreVal!=""){
		var ScoreVal=rowData.ScoreVal +$g('分');
	}else{
		var ScoreVal=$g('未评');		
	}
	if(rowData.DCASStatus=="C"){
		ScoreVal=$g("已取消");
	}
	var color="#000"
	if(rowData.OrderBilled==$g("否")){
		color="rgba(17, 172, 22, 1)";
	}
	var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;color:'+color+'">'+ rowData.AssScaleDesc +'</h3>';
	htmlstr = htmlstr +'<h3 style="position:absolute;right:0;color:red;background-color:transparent;"><span style="font-size:16px;">'+ScoreVal+ '</span></h3><br>';
	htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">'+ rowData.PatName+"【"+rowData.PatNo+" "+rowData.PatInfo +"】"+'</h4>';
	//htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">'+ rowData.Date +" "+ rowData.Time +'</h4>';
	//htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;">'+ rowData.User +'</h4><br>';
	htmlstr = htmlstr +'</div>';
	return htmlstr;
}

/// 评分回调函数
function InvScoreCallBack(ApplyID, EditFlag){
	AssScaleApplyListDataGridLoad();
	LoadApplyAssScaleKeyword(ApplyID);
	SelectPreRow(ApplyID);
	reloadForm("",ApplyID,"",EditFlag);
}

function reloadForm(AssScaleID,AssScaleApplyID,EpisodeID,EditFlag){
	var LinkUrl = "doccure.assscale.view.hui.csp?AssScaleID="+AssScaleID+"&AssScaleApplyID="+AssScaleApplyID+"&EditFlag="+EditFlag+"&EpisodeID="+ EpisodeID;
	if(typeof websys_writeMWToken=='function') LinkUrl=websys_writeMWToken(LinkUrl);
	$("#FormMain").attr("src", LinkUrl);	
}


function InitAssScaleListDataGrid(){
	
	///  定义columns
	var columns=[[
		{field:'ID',title:'ID',width:100,align:'center',hidden:true},
		{field:'DCASDesc',title:'评定量表',width:220,
			formatter: function(value,row,index){
				var myvalue="'"+value+"'"
				return '<a class="editcls-Desc" id= "' + row["ID"] + '"onmouseover="ShowDescDetail(this,'+myvalue+')">'+value+'</a>';
			}},
		{field:'DCASCode',title:'评定量表代码',width:100,hidden:true}
	]];
	$HUI.treegrid("#tabAssScaleList",{
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : true,
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.AssScaleConfig&QueryName=QryAssScaleTree&rows=99999",
		loadMsg : '加载中..',  
		pagination : false,  
		pageSize : 20,
		pageList : [10,20,50],
		rownumbers : false, 
		idField:"ID",
		treeField:'DCASDesc',
		columns :columns,
		onClickRow:function(rowIndex, rowData){
			if(rowData._parentId!=""){
				reloadForm(rowData.ID,"","","2")
			}
	    },
		onBeforeLoad:function(row,param){
			var ScaleCat=$HUI.combobox("#ScaleCat").getValue();
			var ScaleDesc=$("#ScaleDesc").searchbox("getValue");
			$.extend(param,{Desc:ScaleDesc,HospID:ServerObj.LgHospID,ScaleCat:ScaleCat});
			$HUI.treegrid("#tabAssScaleList").unselectAll();
		}
	});
}

function ShowDescDetail(that,content){
	var contentFlag=0; //为0 代表显示的是医嘱列信息 为1代表无论长度都要显示
	if ((contentFlag==0)&&($(that).width()<160)) return false;
	var MaxHeight=20;
	MaxHeight='auto',placement="top";
	$(that).webuiPopover({
		title:'',
		content:content,
		trigger:'hover',
		placement:placement,
		style:'inverse',
		height:MaxHeight
		
	});
	$(that).webuiPopover('show');
}

function AssScaleListDataGridLoad(){
	//$("#tabAssScaleList").datagrid("load");
	$HUI.treegrid("#tabAssScaleList").reload();
}

function toggleMoreInfo(ele){
	if ($(ele).hasClass('expanded')){  //已经展开 隐藏
		$(ele).removeClass('expanded');
		$("#moreBtn")[0].innerText=$g("更多");
    	$("tr.display-more-tr").slideUp("fast", setHeight(-80));
	}else{
		$(ele).addClass('expanded');
		$("#moreBtn")[0].innerText=$g("隐藏");
    	$("tr.display-more-tr").slideDown("'normal", setHeight(80));
	}
	

	function setHeight(num) {
		var l = $("#west-layout");
		var n = l.layout("panel", "north");
		var nh = parseInt(n.outerHeight()) + parseInt(num);
		n.panel("resize", {
			height: nh
		});
		if (num > 0) {
			$("tr.display-more-tr").show();
		} else {
			$("tr.display-more-tr").hide();
		}
		var c = l.layout("panel", "center");
		var ch = parseInt(c.panel("panel").outerHeight()) - parseInt(num);
		c.panel("resize", {
			height: ch,
			top: nh
		});
	}
}

function InitComboAdm()
{
	$("#ComboAdm").lookup({
       	url:$URL,
        mode:'remote',
        method:"Get",
        idField:'PaadmRowid',
        textField:'PaadmNo',
        columns:[[  
        	{field:'PaadmRowid',title:'',width:100,hidden:true},
			{field:'PatNo',title:'登记号',width:100},
			{field:'PatName',title:'患者姓名',width:100,sortable:true},
			{field:'Birth',title:'出生日期',width:95,sortable:true},
			{field:'PatSex',title:'性别',width:40,sortable:true},
			{field:'PaadmNo',title:'就诊号',width:120,sortable:true},
			{field:'AdmTypeDesc',title:'就诊类型',width:80,sortable:true},
			{field:'PaadmDate',title:'就诊日期',width:120,sortable:true},
			{field:'InPatFlag',title:'状态',width:80,sortable:true},
			{field:'InPatLoc',title:'就诊科室',width:120,sortable:true}
        ]], 
        pagination:true,
        panelWidth:600,
        isCombo:true,
        minQueryLen:1,
        delay:'500',
        placeholder:$g("请输入姓名检索就诊"),
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.DHCDocCure.WordReport',QueryName: 'patnamelookup'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
			param = $.extend(param,{PatID:"",PatName:desc,HospDr:ServerObj.LgHospID});
	    },
	    onSelect:function(index, row){
		    $("#PAAdmID").val(row['PaadmRowid']);
		    AssScaleApplyListDataGridLoad();
		},onHidePanel:function(){
            var gtext=$HUI.lookup("#ComboAdm").getText();
            if((gtext=="")){
	        	$("#PAAdmID").val("");
	        }
		}
    });  
};

//iframe宽度自适应
function IFrameReSizeWidth(iframename,width) {
	var pTar = document.getElementById(iframename);
	if (pTar) { //ff
		if (pTar.contentDocument && pTar.contentDocument.body.offsetWidth) {
			pTar.width = pTar.contentDocument.body.offsetWidth+width;
		} //ie
		else if (pTar.Document && pTar.Document.body.scrollWidth) {
			pTar.width = pTar.Document.body.scrollWidth+width;
		}
	}
}

function SelectPreRow(ID){
	if(ID!=""){
		var ListData = $("#bmDetList").datagrid('getData');
		var opts = $("#bmDetList").datagrid('options');
		var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
		var end = start + parseInt(opts.pageSize);

		for (i=0;i<ListData.rows.length;i++){
			var RowID=ListData.rows[i].ID;
			if(RowID==ID){
				var NextRowIndex=i;
				var NeedPageNum=Math.ceil((NextRowIndex+1)/parseInt(opts.pageSize));
				if (opts.pageNumber!=NeedPageNum){
					$("#bmDetList").datagrid('getPager').pagination('select',NeedPageNum);
				}
				NextRowIndex=(NextRowIndex)%parseInt(opts.pageSize);
				$("#bmDetList").datagrid('checkRow',NextRowIndex);
				break;
			}
		}
	}
}

function CheckQueryAll(e,obj){
	AssScaleApplyListDataGridLoad();
}