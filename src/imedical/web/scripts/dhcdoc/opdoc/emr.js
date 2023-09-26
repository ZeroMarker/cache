var SearchName="";
var SelEpisodeID="";
function Init(){
	LoadPatAdmTimeLine("All");
	/*$HUI.searchbox("#TreeSearch",{
		searcher:function(value,name){
			FilterTreeData(value);
		}
	});*/
}
function LoadPatAdmTimeLine(type){
	$.q({
	    ClassName:"DHCDoc.OPDoc.EMR",
	    QueryName:"GetPatHistoryAdmList",
	    EpisodeID:ServerObj.EpisodeID, 
	    PatientID:ServerObj.PatientID, 
	    OrderBy:type, 
	    ExpString:"",
	    page:1,  
	    rows:99999
	},function(jsonData){ 
		createPatAdmTimeLine(jsonData);
	});
}
function createPatAdmTimeLine(data){
	/*if ($(".adm-list li").length>=1){
		$(".end-circle,.opadm-a,.ipadm-a,.start-circle").parent().remove();
	}
	if (data.length==0) {
		removeTable();
		return false;
	}
	var panel=$(".adm-list");
	var template=$("#admlineTemplate");
	for (var i=0;i<data.rows.length;i++){
		var AdmType=data.rows[i].AdmType; 
        var MainDiagnos=data.rows[i].MainDiagnos;
		var mode=(i+1)%5;
        if (mode==0) mode=5;
		var colorclass="color-"+mode;
		var id=data.rows[i].AdmRowId+"_"+mode;
		var tool=template.clone();
		tool.removeAttr("style");
		tool.removeAttr("id");
		$("a",tool).attr("id",id);
		var aclass="";
		if (AdmType=="I"){
			aclass=aclass+" ipadm-a";
		}else{
			aclass=aclass+" opadm-a";
		}
		if (i==0){
			panel.append('<li><div class="start-circle"></div></li>');
		}
		if (i<(data.total-1)){
			aclass=aclass+" line-a";
		}
		$("a",tool).addClass(aclass);
		var content="";
		if (MainDiagnos!="") content="<span>"+MainDiagnos+"</span></br>";
		content=content+"<span>"+data.rows[i].AdmDate+"</span><span>|</span><span>"+data.rows[i].AdmLoc+"</span><span>|</span><span>"+data.rows[i].AdmDoc+"</span>"
		$(".content",tool).append(content);
		panel.append(tool);
		if (i==(data.total-1)){
			panel.append('<li><div class="end-circle"></div></li>');
		}
	}
	if (($("a[id^='"+ServerObj.EpisodeID+"']").length<0)||(ServerObj.EpisodeID=="")){
		SelEpisodeID=$(".adm-list li a")[1].id.split("_")[0];
		$($(".adm-list li a")[1]).addClass("seleted-a");
	}else{
		$("a[id^='"+ServerObj.EpisodeID+"']").addClass("seleted-a");
		SelEpisodeID=ServerObj.EpisodeID;
	}
	if (SelEpisodeID!="") {
		InitOrdTemplTree();
		opdoc.patinfobar.view.InitPatInfo(SelEpisodeID);
	}
	$(".adm-list li a").click(function(e){
	    AdmChange(e);
	});*/
	if ($(".adm-list li").length>=1){
		$(".head,.foot").remove();
	}
	if (data.length==0) {
		removeTable();
		return false;
	}
	var panel=$(".adm-list");
	var template=$("#admlineTemplate");
	for (var i=0;i<data.rows.length;i++){
		var AdmType=data.rows[i].AdmType; 
        var MainDiagnos=data.rows[i].MainDiagnos;
		var mode=(i+1)%5;
        if (mode==0) mode=5;
		//var colorclass="color-"+mode;
		var id=data.rows[i].AdmRowId+"_"+mode;
		var tool=template.clone();
		tool.removeAttr("style");
		tool.removeAttr("id");
		$("a",tool).attr("id",id);
		if (i==0){
			panel.append('<div class="head"></div>');
		}
		var content="";
		$(".first",tool).text("").append(data.rows[i].MainDiagnos);
		$(".second .operator",tool).text("").append(data.rows[i].AdmDate);
		$($(".second span",tool)[1]).text("").append(data.rows[i].AdmLoc);
		$(".third",tool).text("").append(data.rows[i].AdmDoc);
		panel.append(tool);
		if (i==(data.total-1)){
			panel.append('<div class="foot"></div>');
		}
	}
	if (($("a[id^='"+ServerObj.EpisodeID+"']").length<0)||(ServerObj.EpisodeID=="")){
		SelEpisodeID=$(".adm-list li a")[1].id.split("_")[0];
		$($(".adm-list li a")[1]).addClass("seleted-a");
		$($(".adm-list li a")[1]).prev().addClass('selectdot');
	}else{
		$("a[id^='"+ServerObj.EpisodeID+"']").addClass("seleted-a");
		SelEpisodeID=ServerObj.EpisodeID;
		$(".seleted-a").prev().addClass('selectdot');
	}
	if (SelEpisodeID!="") {
		InitOrdTemplTree();
		opdoc.patinfobar.view.InitPatInfo(SelEpisodeID);
	}
	$(".adm-list li a").click(function(e){
	    AdmChange(e);
	});
}
function AdmChange(e){
	var id=e.target.id;
	if (id==""){
		id=$($(e.target).parents("a"))[0].id;
	}
	$(".seleted-a").removeClass("seleted-a");
	$(".selectdot").removeClass("selectdot");
	$("#"+id).addClass("seleted-a");
	$("#"+id).prev().addClass('selectdot');
	SelEpisodeID=id.split("_")[0];
	$("#TreeSearch").searchbox('setValue','');
	InitOrdTemplTree();
	/*var tbox=$HUI.tree("#OrdDataTree");
	var Roots=tbox.getRoots();
	for (var i=0;i<Roots.length;i++){
		var node = tbox.find(Roots[i]["id"]);
		tbox.collapse(node.target);
		var newId=node.id.split("_")[0]+"_"+SelEpisodeID;
		tbox.update({
			target:node.target,
			id:newId
		});
	}
	removeTable();
	var node=tbox.find(Roots[0].id);
	tbox.select(node.target);*/
}
function InitOrdTemplTree(){
	$.q({
	    ClassName:"DHCDoc.OPDoc.EMR",
	    QueryName:"EMRZTreeConfig",
	    EpisodeID:SelEpisodeID,
	    page:1,  
	    rows:99999
	},function(jsonData){
		var tbox=$HUI.tree("#OrdDataTree",{
			data:jsonData.rows,
			onBeforeSelect:function(node){
				if (node["id"].indexOf("_")<0) return true;
				if (node["id"].split("_")[0]=="Exam") return true;
				LoadChildTreeData(node);
				return true;
			},
			onSelect:function(node){
				if (node.id.indexOf("_")>=0){
					$("#"+node.id).toggle(node.target);
				}
				if ((node.urlObject)&&(node.urlObject!="")){
					//iframe
					loadIframe(node,true);
				}else{
					if (node.expandMethodForLoadingTable){
						$("#TemplFrame").parent().hide();
						var NodeId=node.id;
						eval(node["expandMethodForLoadingTable"]+"('"+NodeId+"')");
					}
				}
			},
			onLoadSuccess:function(node, data){
				for (var i=0;i<data.length;i++){
					if (data[i]["pId"]==""){
						$("#"+data[i]["domId"]).addClass("RootsNodes");
						if (i>=1){
							var node=$HUI.tree("#OrdDataTree").find(jsonData.rows[i].id);
							if (node["id"].indexOf("_")<0) return true;
							if (node["id"].split("_")[0]=="Exam") return true;
							LoadChildTreeData(node);
							//$('#OrdDataTree').tree("expand",node.target);
						}
					}
				}
			}
		})
		var node=tbox.find(jsonData.rows[0].id);
		tbox.select(node.target);
	});
	$HUI.checkbox("#selAll",{
        onCheckChange:function(e,value){
	       CheckChange(e,value);
        }
    });
    $("#CopyToCurAdm").click(CopyOrd);
}
function loadIframe(node, isReplacePanelBody, callback) {
	if (isReplacePanelBody) {
		removeTable();
		$("#OrdTableListTempl").hide(); 
	}
	$("#TemplFrame").parent().show();
	var lnk=replaceLinkParams(node["urlObject"],node);
	$("#TemplFrame").attr("src",lnk);
	if (callback) callback();
}
function replaceLinkParams(lnk,node){
	var ret = lnk.replace('@patientID', ServerObj.PatientID);
    ret = ret.replace('@episodeID', node["id"].split("_")[1]);
    ret = ret.replace('@mradm', ServerObj.mradm);
    return ret;
}
function LoadChildTreeData(node){
	RemoveChildTree(node);
	var jsonData = $.cm({
		ClassName:"DHCDoc.OPDoc.EMR",
		QueryName:"EMRZTreeChildNode",
		parentNode:node.id,
	    SearchName:SearchName,
	    page:1,  
	    rows:99999
	},false);
	var tbox=$HUI.tree("#OrdDataTree");
	tbox.append({
		parent: node.target,
		data:jsonData.rows
	});
}
function RemoveChildTree(node){
	if (node.children!=undefined){
		var tbox=$HUI.tree("#OrdDataTree");
	    var roots=tbox.getChildren(node.target);
	    for (var i=roots.length-1;i>=0;i--){
		  var tmpnode = tbox.find(roots[i].id);
		  tbox.remove(tmpnode.target);
	    }
	}
}
function loadOrdTableData(NodeId){
	var EpisodeID=NodeId.split("_")[1];
	$.cm({
		ClassName:"web.DHCDocOrderEntry",
		MethodName:"GetPAAdmType",
		dataType:'text',
		EpisodeID:EpisodeID
	},function(AdmType){ 
		if (AdmType=="I"){
			$(".ipord-search-div").removeAttr("style");
			InitIPSearchCombo();
			$('#OrdDesc').bind('keypress',function(event){
                if(event.keyCode == "13"){
				    OrdTableArgs.inputOrderDesc=$('#OrdDesc').val();
				    loadTableData(SelEpisodeID);
			    }
            });
		}
	});
	loadTableData(EpisodeID);
}
function LoadExamOrdTable(NodeId){
	var EpisodeID=NodeId.split("_")[1];
	$.cm({
		ClassName:"DHCDoc.OPDoc.EMR",
		MethodName:"GetExamOrdList",
		EpisodeID:EpisodeID
	},function(jsonData){ 
		removeTable();
		buildTable(jsonData,"");
	});
}
function LoadLabOrdTable(NodeId){
	var EpisodeID=NodeId.split("_")[1];
	$.cm({
		ClassName:"DHCDoc.OPDoc.EMR",
		MethodName:"GetLabOrdList",
		EpisodeID:EpisodeID
	},function(jsonData){ 
		removeTable();
		buildTable(jsonData,"");
	});
}
function InitIPSearchCombo(){
	var cbox = $HUI.combobox("#AddLocList", {
		valueField: 'id',
		textField: 'text',
		editable:false, 
		data: [
		  {"id":"1","text":"本科室与病区"}
		 ,{"id":"2","text":"其它科室"}
		 ,{"id":"3","text":"全部","selected":true}
		],
		onSelect: function (rec) {
			OrdTableArgs.stloc=rec.id;
			loadTableData(SelEpisodeID);
		}
   });
   //医嘱范围
	var cbox = $HUI.combobox("#OrdRange", {
		valueField: 'id',
		textField: 'text',
		editable:false, 
		data: [
		  {"id":"ALL","text":"全部","selected":true}
		 ,{"id":"N","text":"医嘱单"}
		]  ,
		onSelect: function (rec) {
			OrdTableArgs.nursebill=rec.id;
			loadTableData(SelEpisodeID);
		}
   });
   //获取下医嘱人列表
   $.cm({
		ClassName:"web.DHCDocInPatUICommon",
		MethodName:"GetAdmInfoJson",
		EpisodeID:SelEpisodeID,
		dataType:"text"
	},function(jsonData){ 
		//开医嘱人
	   var cbox = $HUI.combobox("#AddUserList", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			data: eval("("+jsonData+")"),
			onSelect: function (rec) {
				OrdTableArgs.doctor=rec.id;
				loadTableData(SelEpisodeID);
			}
	   });
	});
}
var OrdTableArgs={"Arg1":"","currLocId":session['LOGON.CTLOCID'],"inputOrderDesc":"","doctor":"","stloc":"","nursebill":""};
function loadTableData(EpisodeID){
	$.cm({
		ClassName:"DHCDoc.OPDoc.EMR",
		MethodName:"QueryOEForEMRJson",
		episodeID:EpisodeID,
		currLocId:OrdTableArgs["currLocId"],
		inputOrderDesc:OrdTableArgs["inputOrderDesc"],
		doctor:OrdTableArgs["doctor"],
		stloc:OrdTableArgs["stloc"],
		nursebill:OrdTableArgs["nursebill"]
	},function(jsonData){ 
		removeTable();
		for (var i=0;i<jsonData.length;i++){
			buildTable(jsonData[i],"");
		}
	});
}
function buildTable(data,OEORIRowId){
	var temp=$("#OneTableListTempl");
	var panel=$("#OrdTableListTempl");
	panel.removeAttr("style");
	var tool=temp.clone();
	tool.removeAttr("style").removeAttr("id");
	tool.attr("id",data["id"]+"Panle");
	panel.append(tool);
	var oneHeight=40; 
	var dataLen=data["rows"].length;
	if (dataLen<=1){
		var PanelMaxHeight=oneHeight*3;
	}else{
		var PanelMaxHeight=oneHeight*(data["rows"].length-1)+100;  //oneHeight*(data["rows"].length+1);
	}
	tool.height(PanelMaxHeight);
	var config=data["config"];
	var columns=new Array();
	var head=data["head"];	
	for(var i=0,len=head.length;i<len;++i){
		var field=data["rowCols"][i].data;
		var title=head[i];
		if ((field=="ExamDirection")||(field=="LabDirection")){
			columns.push({"field":field,"title":title,formatter:function(value,row,index){
				return renderWorkStatusCols(OEORIRowId,index,field);
			}})
		}else{
			if (config["checkHeaders"] && config["checkHeaders"][i]){
				columns.push({"field":field,"title":title,"checkbox":true})
			}else{
				if (field==title){
					columns.push({"field":field,"title":title,"hidden":true});
				}else{
					columns.push({"field":field,"title":title});
				}
			}
		}
	}
	var newcolumns=new Array();
	newcolumns.push(columns);
	var content='<table class="hisui-datagrid" data-options="headerCls:'+"'panel-header-gray'"+'" id="'+data["id"]+'"></table> '
	tool.append(content);
	if (data["titleClass"]=="") data["titleClass"]="panel-header-gray";
	$("#"+data["id"]).datagrid({
		title:data["title"],
		headerCls:data["titleClass"],
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : true,
		autoRowHeight : true,
		autoSizeColumn : true,
		rownumbers:false,
		pagination : false,  
		rownumbers : false,  
		idField:'OrderItemRowid',
		columns :newcolumns,
		data:data["rows"],
		onCheck:function(index, row){
			var OrderItemInValid=row["OrderItemInValid"];
			if (OrderItemInValid=="1"){return false;}
			var selOrderSeqNo=row["OrderSeqNo"];
			if (selOrderSeqNo.indexOf(".")>=0) selOrderSeqNo=selOrderSeqNo.split(".")[0];
			var GridData=$("#"+data["id"]).datagrid("getData");
			for (var i=0;i<GridData.rows.length;i++){
				var OrderSeqNo=GridData.rows[i]["OrderSeqNo"];
				if (OrderSeqNo.indexOf(".")>=0) OrderSeqNo=OrderSeqNo.split(".")[0];
				if (OrderSeqNo==selOrderSeqNo){
					var OrderItemInValid=GridData.rows[i]["OrderItemInValid"];
					if (OrderItemInValid!="1"){
						$("#"+data["id"]).datagrid('selectRow',i);
					}
				}
			}
		},
		onLoadSuccess:function(data){
			if (OEORIRowId!=""){
				$("[id$='-TTP']").each(function(){
					var that=$(this);
					var ID=that.attr('id');
					that.parent().on({
						mouseenter:function(){
							if (LoadPopover("Load",that.attr('id'))){
								var HTML=GetPannelHTML(that.attr('id'));
								if (HTML.innerHTML==""){return;}
								that.webuiPopover({
									title:HTML.Title,
									content:HTML.innerHTML,
									trigger:'hover',
									placement:'left',
									onShow:function(){
										if (ID.indexOf("Lab")>=0){
											LoadLabeChart();
										}
										if (LoadPopover("Show",that.attr('id'))){
											if (typeof HTML.CallFunction == "function"){
												HTML.CallFunction.call();
											}
										}
									}
								});
								that.webuiPopover('show');
							}
						}
					});
				});
			}
		}
	});
}
function LoadPopover(Type,ID){
	var AlreadLoadObj={};	//初始化元素
	var AlreadShowObj={};	//初始化显示数据
	if (Type=="Load"){
		if (typeof AlreadLoadObj[ID] =="undefined"){
			AlreadLoadObj[ID] ="1";
			return true;
		}else{
			return false;
		}
	}else if (Type=="Show"){
		if (typeof AlreadShowObj[ID] =="undefined"){
			AlreadShowObj[ID] ="1";
			return true;
		}else{
			return false;
		}
	}
}
///获取动态写入的HTML代码
function GetPannelHTML(LinkID){
	var OEORIRowId=LinkID.split("-")[0];
	var renderType=LinkID.split("-")[2];
	var innerHTML="";
	var Title="";
	var CallFunction={};
	if (renderType=="ExamDirection"){
		innerHTML+='<table id="ExamDirectionGrid"></table>';
		CallFunction=function(){
			LoadExamDirectionTable(OEORIRowId);
		};
	}else if(renderType=="LabDirection"){
		innerHTML+='<div><div id="echartsTemp" style="width: 600px;height:250px;"></div><table id="LabDirectionGrid"></table></div>'
		CallFunction=function(){
			LoadLabDirectionTable(OEORIRowId);
		};
	}
	return {
		"innerHTML":innerHTML,
		"CallFunction":CallFunction,
		"Title":Title
	}
}
function LoadLabeChart(){
	var myChart
    if (myChart && myChart.dispose) { 
       myChart.dispose(); 
    }

    myChart = echarts.init(document.getElementById("echartsTemp"));
	option = {
		title: {
			text: '堆叠区域图'
		},
		tooltip : {
			trigger: 'axis'
		},
		legend: {
			data:['邮件营销','联盟广告','视频广告','直接访问','搜索引擎']
		},
		toolbox: {
			feature: {
				saveAsImage: {}
			}
		},
		grid: {
			left: '3%',
			right: '4%',
			bottom: '3%',
			containLabel: true
		},
		xAxis : [
			{
				type : 'category',
				boundaryGap : false,
				data : ['周一','周二','周三','周四','周五','周六','周日']
			}
		],
		yAxis : [
			{
				type : 'value'
			}
		],
		series : [
			{
				name:'邮件营销',
				type:'line',
				stack: '总量',
				areaStyle: {normal: {}},
				data:[120, 132, 101, 134, 90, 230, 210]
			},
			{
				name:'联盟广告',
				type:'line',
				stack: '总量',
				areaStyle: {normal: {}},
				data:[220, 182, 191, 234, 290, 330, 310]
			},
			{
				name:'视频广告',
				type:'line',
				stack: '总量',
				areaStyle: {normal: {}},
				data:[150, 232, 201, 154, 190, 330, 410]
			},
			{
				name:'直接访问',
				type:'line',
				stack: '总量',
				areaStyle: {normal: {}},
				data:[320, 332, 301, 334, 390, 330, 320]
			},
			{
				name:'搜索引擎',
				type:'line',
				stack: '总量',
				label: {
					normal: {
						show: true,
						position: 'top'
					}
				},
				areaStyle: {normal: {}},
				data:[820, 932, 901, 934, 1290, 1330, 1320]
			}
		]
	};
	myChart.setOption(option);
}
function removeTable(){
	var $table=$("[id$='_TablePanle']");
		$table.remove();
}
function LoadExamOrdResultTable(NodeId){
	var OEORIRowId=NodeId.split("$")[0];
	$.cm({
		ClassName:"DHCDoc.OPDoc.EMR",
		MethodName:"GetExamOrdResult",
		OEORIRowID:OEORIRowId
	},function(jsonData){ 
		removeTable();
		buildTable(jsonData,OEORIRowId); 
	});
}
function LoadLabOrdResultTable(NodeId){
	var OEORIRowId=NodeId.split("$")[0];
	$.cm({
		ClassName:"DHCDoc.OPDoc.EMR",
		MethodName:"GetLabOrdResult",
		OEORIRowID:OEORIRowId
	},function(jsonData){ 
		removeTable();
		buildTable(jsonData,OEORIRowId); 
	});
}
function CheckChange(e,value){
	var $table=$("[id$='_TablePanle']");
	for (var i=0;i<$table.length;i++){
		var oneId=$table[i].id;
		var tableId=oneId.split("_")[0];
		if (value){
			$("#"+tableId+"_Table").datagrid('selectAll');
		}else{
			$("#"+tableId+"_Table").datagrid('unselectAll');
		}
	}
}
//引用 todo
function CopyOrd(){
	var selOEOrdRowIdArr=new Array();
	var $table=$("[id$='_TablePanle']");
	for (var i=0;i<$table.length;i++){
		var oneId=$table[i].id;
		var tableId=oneId.split("_")[0];
		var OneSelOEOrdRowIdArr=$("#"+tableId+"_Table").datagrid('getSelections');
		for (var j=0;j<OneSelOEOrdRowIdArr.length;j++){
			selOEOrdRowIdArr.push(OneSelOEOrdRowIdArr[0]["OEItemID"]);
		}
	}
	if (selOEOrdRowIdArr.length==0){
		$.messager.alert("提示","请选择需要引用到本次的医嘱!");
		return false;
	}
	//selOEOrdRowIdArr.join("^")
}
function FilterTreeData(value){
	SearchName=value;
	var tbox=$HUI.tree("#OrdDataTree");
	var Roots=tbox.getRoots();
	for (var i=1;i<Roots.length;i++){
		var node = tbox.find(Roots[i]["id"]) ;//$('#tt').tree('find', 12);
		//tbox.expand(node.target);
		LoadChildTreeData(node);
	}
}
function renderWorkStatusCols(OEORIRowId,index,field){ //onmouseover="ShowTipMessage(this)"
	var ic='<a href="#" class="icon-copy-prn" data-options="plain:true">&nbsp;&nbsp;&nbsp;&nbsp;</a>';
	return '<span id="'+OEORIRowId+'-'+index+"-"+field+'-TTP">'+ic+'</span>'
}
function ShowTipMessage(that){
	var id=$($(that).parent())[0].id;
	if (id=="") return false;
	var OEORIRowId=id.split("-")[0];
	var renderType=id.split("-")[1];
	if (renderType=="ExamDirection"){
		ExamDirectionTable(OEORIRowId);
	}else if(renderType=="LabDirection"){
		LabDirectionTable(OEORIRowId);	
	}
}
function LoadLabDirectionTable(OEORIRowId){
	$.cm({
		ClassName:"DHCDoc.OPDoc.EMR",
		QueryName:"GetExamOrdDirectionByOrd",
		OEORIRowID:OEORIRowId
	},function(jsonData){ 
		var Columns=[[    
			{title:'申请日期',field:'ExamOrdApplyDate'},  
	        {title:'申请科室',field:'ExamOrdApplyLoc'},
	        {field:'申请医生',field:'ExamOrdApplyDoc'},
	        {title:'检查所见',field:'SeeDescEx'},
	        {title:'诊断意见',field:'DiagDescEx'},
	        {title:'检查方法',field:'MethodDescEx'}
	    ]];
		$HUI.datagrid('#LabDirectionGrid',{
		    data:jsonData.rows,
		    idField:'ExamOrdApplyDate',
		    title:'检验结果趋势',
		    headerCls:'panel-header-gray',
		    fit : false,
		    width:600,
		    height:250,
		    columns:Columns
		});
	});
}
function LoadExamDirectionTable(OEORIRowId){
	$.cm({
		ClassName:"DHCDoc.OPDoc.EMR",
		QueryName:"GetExamOrdDirectionByOrd",
		OEORIRowID:OEORIRowId
	},function(jsonData){ 
		var Columns=[[    
			{title:'申请日期',field:'ExamOrdApplyDate'},  
	        {title:'申请科室',field:'ExamOrdApplyLoc'},
	        {field:'申请医生',field:'ExamOrdApplyDoc'},
	        {title:'检查所见',field:'SeeDescEx'},
	        {title:'诊断意见',field:'DiagDescEx'},
	        {title:'检查方法',field:'MethodDescEx'}
	    ]];
		$HUI.datagrid('#ExamDirectionGrid',{
		    data:jsonData.rows,
		    idField:'ExamOrdApplyDate',
		    title:'检查结果趋势',
		    headerCls:'panel-header-gray',
		    fit : false,
		    width:600,
		    height:300,
		    columns:Columns
		});
	});
}
//$("iframe",temp).attr("src",node["urlObject"]);