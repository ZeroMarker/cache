var PageLogicObj={
	m_selectedMarkListDataGrid:"",
	m_curDayRegListDataGrid:"",
	m_MarkListDataGrid:"",
	m_PreCardNo:"",
	m_PreCardType:"",
	m_PreCardLeaving:"",
	m_DepId:"",
	m_searchDetpt:"",
	dw:$(window).width()-200,
	dh:$(window).height()-100,
	m_DeptStr:""
};
$(function(){
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	//ҳ�����ݳ�ʼ��
	Init();
	//�¼���ʼ��
	InitEvent();
});
function Init(){
	$("#DeptList").css('height',$(window).height()-355);
	PageLogicObj.m_selectedMarkListDataGrid=InitselectedMarkListDataGrid();
	PageLogicObj.m_curDayRegListDataGrid=curDayRegListDataGrid();
	//PageLogicObj.m_MarkListDataGrid=MarkListDataGrid();
}
function PageHandle(){
	//�����б�
	LoadDeptList();
	//ʱ���б�
	LoadTimeRange();
	LoadPayMode();
	//��Ʊ��ˮ��
	GetReceiptNo();
	$("#SelDate").html(ServerObj.CurDate);
	$("#WeekDesc").html(ServerObj.CurWeek);
	$("#CardNo").focus();
	var $btntext=$("#MarkListShowMode .l-btn-text")[0];
	if (ServerObj.OPRegListDefault==1){
		$btntext.innerText="��ͼģʽ";
		var url="opadm.reg.marktable.hui.csp";
	}else{
		$btntext.innerText="�б�ģʽ";
		var url="opadm.reg.markcard.hui.csp";
		$("#MarkListPanel").removeClass('panel-noscroll');
	}
	$.ajax(url, {
		"type" : "GET",
		"async" : false,
		"dataType" : "html",
		"success" : function(data, textStatus) {
			$("#MarkListPanel").empty().append(data);
		}
	});
}
function InitEvent(){
	$("#MarkListShowMode").click(MarkListShowModeClickHandle);
	$("#BClear").click(Clear_click);
	$("#BUpdate").click(UpdateClickHandler);
	$('#DeptList').change(DeptListChange);
	$("#BReadCard").click(ReadCardClickHandler);
	$(".searchbox-text").keyup(function(){ 
		var str = $(".searchbox-text").val(); 
		if(str ==null || str.trim() == PageLogicObj.m_searchDetpt) //|| str.trim()==""
		   return; 
		PageLogicObj.m_searchDetpt =str; 
		FindDeptChange(PageLogicObj.m_searchDetpt); 
	});
	$(document.body).bind("keydown",BodykeydownHandler);
}
function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	//�������Backspace������  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }  
	if (keyCode==115){ //F4
		ReadCardClickHandler();
	}else if(keyCode==118) { //F7
		Clear_click();
	}else if(keyCode==120) { //F9
		UpdateClickHandler();
	}
	var selCardIndex="";
	var $markcard=$(".markcard-select");
	if ($markcard.length>0){
		selCardIndex=$markcard[0]["id"].split("-")[0];
	}
	if (keyCode==37){
		//��
		var nextIndex=parseInt(selCardIndex)-1;
		if (nextIndex<0) return true
		if (selCardIndex!=""){
			$(".markcard-select").removeClass("markcard-select");
			$("#"+nextIndex+"-marklist-card").addClass("markcard-select");
			SetMarkCardFocus(nextIndex+"-marklist-card");
		}
	}else if(keyCode==38){
		//��
		var width=$("#MarkListPanel").width();
		var RowNumber=Math.floor(width/200);
		var nextIndex=parseInt(selCardIndex)-parseInt(RowNumber);
		if (nextIndex<0) return true;
		$(".markcard-select").removeClass("markcard-select");
		$("#"+nextIndex+"-marklist-card").addClass("markcard-select");
		SetMarkCardFocus(nextIndex+"-marklist-card");
	}else if(keyCode==39){
		//��
		var nextIndex=parseInt(selCardIndex)+1;
		if (nextIndex>=($(".marklist-card").length)-1) return true;
		$(".markcard-select").removeClass("markcard-select");
		$("#"+nextIndex+"-marklist-card").addClass("markcard-select");
		SetMarkCardFocus(nextIndex+"-marklist-card");
		
	}else if(keyCode==40){
		//��
		var width=$("#MarkListPanel").width();
		var RowNumber=Math.floor(width/200);
		var nextIndex=parseInt(selCardIndex)+parseInt(RowNumber);
		if (nextIndex>=($(".marklist-card").length)-1) return true;
		$(".markcard-select").removeClass("markcard-select");
		$("#"+nextIndex+"-marklist-card").addClass("markcard-select");
		SetMarkCardFocus(nextIndex+"-marklist-card");
	}
	//�س��¼�����
	if (keyCode==13) {
		if ((SrcObj.tagName=="A")||(SrcObj.tagName=="INPUT")) {
			if (SrcObj.id=="CardNo"){
				CardNoKeydownHandler(e);
				return false;
			}else if(SrcObj.id=="PatientNo"){
				PatientNoKeydownHandler(e);
				return false;
			}
			return true;
		}
		var $id=$(".markcard-select");
		if ($id.length>0){
			var id=$id[0]["id"];
			var dataStr=$($("#"+id).find("div")[8]).html();
			var jsonData=JSON.parse(dataStr);
			MarkListDBClick(jsonData);
		}else{
			if (PageLogicObj.m_MarkListDataGrid!=""){
				var row=PageLogicObj.m_MarkListDataGrid.datagrid('getSelected');
				if (row){
					MarkListDBClick(row);
				}
			}
		}
		return true;
	}
	window.onhelp = function() { return false };
	return true;
}
function InitselectedMarkListDataGrid(){
	var Columns=[[ 
		{field:'Operation',title:'ɾ��',width:50,
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="DelSelMarkListRowByABRS(\'' + row['TabASRowId'] + '\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png"/></a>';
				return btn;
			}
		},
		{field:'TabASRowId',hidden:true,title:''},
		{field:'TabDeptDesc',title:'����',width:140},
		{field:'TabMarkDesc',title:'ҽ��',width:140},
		{field:'TabSeqNo',title:'���',width:50},
		{field:'TabPrice',title:'�۸�',width:50},
		{field:'TabAppDate',title:'��������',width:100},
		{field:'TabDeptRowId',title:'',hidden:true},
		{field:'TabPCLRowID',title:'',hidden:true},
		{field:'TAPPTRowID',title:'',hidden:true},
		{field:'TabFreeRegFlag',title:'',hidden:true},
		{field:'TabFreeCheckFlag',title:'',hidden:true},
		{field:'TabReAdmFeeFlag',title:'',hidden:true},
		{field:'TabHoliFee',title:'',hidden:true},
		{field:'TabAppFee',title:'',hidden:true},
		{field:'TabExamFee',title:'',hidden:true}
    ]]
	var selectedMarkListDataGrid=$("#selectedMarkList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:false,
		pagination : false,  
		idField:'TabASRowId',
		columns :Columns,
		onDblClickRow:function(index, row){
			DelSelMarkListRow(row);
		}
	}); 
	return selectedMarkListDataGrid;
}
function curDayRegListDataGrid(){
	var Columns=[[ 
		{field:'PatDr',title:'�˺�',width:80,
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="BCacelRegHandle(\'' + row["AdmId"] + '\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png"/></a>';
				return btn;
			}
		},
		{field:'AdmId',hidden:true,title:''},
		{field:'Dept',title:'����',width:140},
		{field:'Doctor',title:'�ű�',width:100},
		{field:'Tph',title:'���',width:80}
    ]]
	var curDayRegListDataGrid=$("#curDayRegList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:false,
		pagination : false,  
		idField:'AdmId',
		columns :Columns
	}); 
	return curDayRegListDataGrid;
}
function LoadTimeRange(){
	$.cm({
		ClassName:"web.DHCOPAdmReg", 
		MethodName:"GetTimeRangeStr",
		dataType:"text",
		Flag:1
	},function(Data){
	    var templ=$("#timerange-tmp");
	    var panel=$(".timerange-div");
	    var tool=templ.clone();
		 tool.removeAttr("style");
		 tool.removeAttr("id");
		 var a=$("a",tool).prevObject.attr("id","CUR-TimeRange");
		 $("a",tool).prevObject.find("span").eq(1).text("��ǰ");
		 panel.append(tool); 
	     var tool=templ.clone();
		 tool.removeAttr("style");
		 tool.removeAttr("id");
		 var a=$("a",tool).prevObject.attr("id","ALL-TimeRange");
		 $("a",tool).prevObject.find("span").eq(1).text("ȫ��");
		 panel.append(tool); 
		for(var i=0,len=Data.split("^").length;i<len;++i){
			 var onedata=Data.split("^")[i];
			 var id=onedata.split(String.fromCharCode(1))[0];
			 id=id+"-TimeRange"
			 var text=onedata.split(String.fromCharCode(1))[1].split("-")[0];
			 var tool=templ.clone();
			 tool.removeAttr("style");
			 tool.removeAttr("id");
			 var a=$("a",tool).prevObject.attr("id",id);
			 $("a",tool).prevObject.find("span").eq(1).text(text);
			 panel.append(tool);
	   }
	   SetDefaultTimeRange();
	});
}
function LoadPayMode(){
	$.cm({ 
		ClassName:"web.UDHCOPGSConfig", 
		QueryName:"ReadGSINSPMList",
		GPRowID:session['LOGON.GROUPID'],
		HospID:session['LOGON.HOSPID'],
		TypeFlag:"",
		rows:9999
	},function(Data){
		var cbox = $HUI.combobox("#PayMode", {
				valueField: 'CTPMRowID',
				textField: 'CTPMDesc', 
				editable:false,
				data: Data.rows
		 });
	});
}
function SetDefaultTimeRange(){
	var defaultTimeRange="CUR"; //Ĭ�ϵ�ǰ,�Һſ�ʼʱ��ͽ���ʱ���������ǰ��ʱ����Ű��¼����Ҫ��ѯ����
	/*defaultTimeRange=$.cm({
		ClassName:"web.DHCOPAdmReg", 
		MethodName:"GetCurrentTimeRange",
		dataType:"text"
	},false);*/
	$(".seltimerange").removeClass("seltimerange");
	$("#"+defaultTimeRange+"-TimeRange").addClass("seltimerange");
	$("a[id$='TimeRange']").click(TimeRangeChange);
}
function TimeRangeChange(e){
	$(".seltimerange").removeClass("seltimerange");
	var id=e.currentTarget.id;
	$("#"+id).addClass("seltimerange");
	LoadMarkList();
}
function LoadMarkList(){
	var DepRowId=PageLogicObj.m_DepId;
	var AppDate="";
	var PatientID=$("#PatientID").val();
	var TimeRangeRowId=$(".seltimerange")[0].id.split("-")[0];
	if (TimeRangeRowId=="ALL") TimeRangeRowId="";
	var DocRowId="";
	var ClinicGroupRowId=""; //��רҵ
	var ShowStopScheFlag=""; //������ͣ��
	var RegConDisId="";
	var p1=DepRowId+"^"+session['LOGON.USERID']+"^"+AppDate+"^"+PatientID+"^"+TimeRangeRowId+"^"+DocRowId+"^"+session['LOGON.GROUPID']+"^^^"+TimeRangeRowId+"^"+ClinicGroupRowId+"^"+ShowStopScheFlag+"^"+RegConDisId;
	$.cm({
		ClassName:"web.DHCOPAdmReg", 
		QueryName:"OPDocList",
		Dept:p1,
		rows:99999
	},function(GridData){
		$("#MarkListPanel").removeClass('marklist-card-panel');
		var $btntext=$("#MarkListShowMode .l-btn-text")[0];
		var text=$btntext.innerText;
		if (text.indexOf("��ͼ")>=0){
			if (PageLogicObj.m_MarkListDataGrid==""){
				PageLogicObj.m_MarkListDataGrid=MarkListDataGrid();
			}
			LoadMarkListTabData(GridData);
		}else{
			$("#MarkListPanel").addClass('marklist-card-panel');
			var $card=$("div[id*='-marklist-card']");
			if ($card.length>0) $card.parent().remove();
			LoadMarkListCardData(GridData);
		}
	})
}
function LoadMarkListCardData(GridData){
	var colorIndex=1,timeRangeDesc="";
	var templ=$("#marklist-card-temp");
	var panel=$("#MarkListPanel");
	for(var i=0,len=GridData["total"];i<len;++i){
	    var oneData=GridData["rows"][i];
	    if (oneData["ASRowId"]=="") continue;
		var tool=templ.clone();
		 tool.removeAttr("style");
		 tool.removeAttr("id");
		 var id=i+"-marklist-card"
		 tool.attr("id",id);
		 panel.append(tool);
		 $($(tool).find("div")[0]).html(oneData["MarkDesc"]+"("+oneData["SessionTypeDesc"]+")");
		 $($(tool).find("div")[1]).html(oneData["ScheduleStatus"]);
		 var TotalFee=parseFloat(oneData["HoliFee"])+parseFloat(oneData["ExamFee"])+parseFloat(oneData["RegFee"])+parseFloat(oneData["AppFee"])+parseFloat(oneData["AppFeeDr"]);
		 $($(tool).find("div")[2]).html(oneData["ClinicGroupDesc"]+" "+TotalFee+"Ԫ"+" "+oneData["ScheduleDate"]); //
		 $($(tool).find("div")[4]).html(+oneData["RegedCount"]);
		 $($(tool).find("div")[5]).html(+oneData["AppedCount"]);
		 $($(tool).find("div")[6]).html(+oneData["AppedArriveCount"]);
		 $($(tool).find("div")[7]).html(+oneData["AddedCount"]);
		 $($(tool).find("div")[8]).html(JSON.stringify(oneData));
		 if ((i>=1)&&(oneData["TimeRange"]!=GridData["rows"][i-1]["TimeRange"])){
			 colorIndex=colorIndex+1;
			 if (colorIndex>4) colorIndex=1;
		 }
		 $($(tool).find("span")[0]).addClass("timerange-span-solid-"+colorIndex);
		 $($(tool).find("span")[1]).html(oneData["TimeRange"]).addClass("timerange-span-dotted-"+colorIndex);
		 if (i==0){
			 $("#"+id).addClass("markcard-select");
			 setTimeout(function(){
				 SetMarkCardFocus(id);
			 });
		 }
		var className="marklist-card";
		if (oneData["ScheduleStatus"]=="ͣ��"){
			className="marklist-card-stop";
		}
		if ((oneData["AvailSeqNoStr"]=="")&&(oneData["AvailAddSeqNoStr"]=="")&&(ServerObj.SeqNoMode=='')){
			className="marklist-card-invalid";
		}
		var valbox = $HUI.panel("#"+id,{
			width:200,
			height:137,
			bodyCls:className,
			noheader:true
		});
	}
	var $card=$("div[id*='-marklist-card']");
	$card.mouseenter(function(e){
		var id=e.currentTarget.id;
		$(".markcard-hover").removeClass("markcard-hover");
		$("#"+id).addClass("markcard-hover");
		//20180702
		//��������
		var dataStr=$($("#"+id).find("div")[8]).html();
			var jsonData=JSON.parse(dataStr);
			var HTML=GetPannelHTML(jsonData,id);
			if (HTML.innerHTML==""){return;}
			$("#"+id).popover({
				width:HTML.width,
				height:HTML.height,
				title:HTML.Title,
				content:HTML.innerHTML,
				closeable:HTML.closeable,
				trigger:'hover',
				placement:'auto', //bottom-left
				onShow:function(){
						if (typeof HTML.CallFunction == "function"){
							HTML.CallFunction.call();
						}
				}
			});
			$("#"+id).popover('show');
		//20180702
	}).mouseleave(function(e){
		$(".markcard-hover").removeClass("markcard-hover");
	}).dblclick(function(e){
		var id=e.currentTarget.id;
		$(".markcard-select").removeClass("markcard-select");
		$("#"+id).addClass("markcard-select");
		SetMarkCardFocus(id);
		var dataStr=$($("#"+id).find("div")[8]).html();
		var jsonData=JSON.parse(dataStr);
		MarkListDBClick(jsonData);
	})
}
///��ȡ��̬д���HTML����
/*function GetPannelHTML(jsonData,LinkID){
	var ASRowId=jsonData["ASRowId"];
	var innerHTML="<table border='1' class='diytable' cellspacing='1' cellpadding='0'>";
	var CallFunction={};
	var Title=jsonData["MarkDesc"]+"("+jsonData['SessionTypeDesc']+") "+jsonData["ScheduleDate"];
	var width=400,height=300;
	var warning = $.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"GetTimeRangeStrApp",
	    ASRowid:ASRowId,
	    AppMedthod:"WIN",
		dataType:"text"
	},false);
	warning=eval('(' + warning + ')');
	var Len=warning['row'].length;
	for (var i=0;i<Len;i++){
		var TimeRange=warning['row'][i]['TimeRange'];
		innerHTML=innerHTML+"<tr>";
		innerHTML=innerHTML+"<td>"+TimeRange+"</td>";
		var col=warning['row'][i]['col'];
		for (var j=0;j<col.length;j++){
			var SeqNo=col[j]['SeqNo'];
			var Time=col[j]['Time'];
			var Status=col[j]['Status'];
			if(Status==2){
				innerHTML=innerHTML+"<td>"+"<span style='color:red;font-size:5;'>"+SeqNo+"</span><br>"+Time+"</td>";
			}else{
				innerHTML=innerHTML+"<td onmouseover=mouserover(this) onmouseout=mouserout(this) onclick=tdclick(this) ondblclick=dbtdclick(this) style='text-align:center;' id='"+LinkID+"_table_"+SeqNo+"'>"+"<span style='color:blue;font-size:5;'>"+SeqNo+"</span><br>"+Time+"</td>";
			}
			innerHTML=innerHTML+"</td>";
		}
		innerHTML=innerHTML+"</tr>";
	}
	innerHTML=innerHTML+"</table>";
	if (Len==0){
		innerHTML="";
	}
	return {
		"innerHTML":innerHTML,
		"CallFunction":CallFunction,
		"Title":Title,
		"width":width,
		"height":height
	}
}
function mouserover(){
}
function mouserout(){
}
function tdclick(){
}
function dbtdclick(obj){
	var id=obj.id;
	var MarkCardID=id.split("_table_")[0];
	var SeqNo=id.split("_table_")[1];
	var dataStr=$($("#"+MarkCardID).find("div")[8]).html();
	var jsonData=JSON.parse(dataStr);
	jsonData['SeqNo']=SeqNo;
	MarkListDBClick(jsonData);
	$("#"+MarkCardID).webuiPopover('hide');
}*/
function SetMarkCardFocus(id){
	//$("#"+id).panel().focus();
	$("#"+id).parent().focus();
}
function LoadMarkListTabData(GridData){
	PageLogicObj.m_MarkListDataGrid.datagrid('uncheckAll');
	if ((GridData["total"]==1)&&(GridData["rows"][0]["ASRowId"]=="")){
		PageLogicObj.m_MarkListDataGrid.datagrid('loadData', {"total":0,"rows":[]});
	}else{
		PageLogicObj.m_MarkListDataGrid.datagrid('loadData',GridData);
	}
}
function MarkListShowModeClickHandle(e){
	//�л���ͼģʽʱhtml����գ������ֳ�ʼ�����
	PageLogicObj.m_MarkListDataGrid="";
	var $btntext=$("#MarkListShowMode .l-btn-text")[0];
	var text=$btntext.innerText;
	if (text.indexOf("��ͼ")>=0){
		$btntext.innerText="�б�ģʽ";
		var url="opadm.reg.markcard.hui.csp";
		$("#MarkListPanel").removeClass('panel-noscroll');
	}else{
		$btntext.innerText="��ͼģʽ";
		var url="opadm.reg.marktable.hui.csp";
	}
	$.ajax(url, {
		"type" : "GET",
		"async" : false,
		"dataType" : "html",
		"success" : function(data, textStatus) {
			$("#MarkListPanel").empty().append(data);
		}
	});
	LoadMarkList();
}
$.extend($.fn.datagrid.methods,{
	keyCtr : function (jq) {
	    return jq.each(function () {
	        var grid = $(this);
	        grid.datagrid('getPanel').panel('panel').attr('tabindex', 1).bind('keydown', function (e) {
		    	switch (e.keyCode) {
		            case 38: // up
		                var Selections = grid.datagrid('getSelections');
		                var rows = grid.datagrid('getRows');
		                if (Selections.length>0) {
			                var MaxSelection=null,MinSelection=null;
			                var opts=grid.datagrid('options');
				            $.each(Selections,function(Index,RowData){
				            	if (RowData==null){return true;}
				            	if (RowData[opts.idField]==""){return true;}
				            	if (MaxSelection==null){
				            		MaxSelection=RowData;
				            	}
				            	if (MinSelection==null){
				            		MinSelection=RowData;
				            	}
								var RowIndex=grid.datagrid('getRowIndex',RowData.OrderId);
								var Maxindex=grid.datagrid('getRowIndex',MaxSelection.OrderId);
								var Minindex=grid.datagrid('getRowIndex',MinSelection.OrderId);
								if (Maxindex<RowIndex){
									MaxSelection=RowData;
								}
								if (Minindex>RowIndex){
									MinSelection=RowData;
								}
							});
							if (MinSelection==null){
								var Rows=grid.datagrid('getRows');
								for (var i=Rows.length-1;i>=0;i--) {
									if (Rows[i][opts.idField]!=""){
										MinSelection=Rows[i];
										break;
									}
								}
								var NextIndex=grid.datagrid('getRowIndex', MinSelection);
								var index=NextIndex+1;
							}else{
								var index = grid.datagrid('getRowIndex', MinSelection);
		                    	var NextIndex=index-1;
							}
		                    if (NextIndex<0){
			                	NextIndex=rows.length - 1;
			                }
		                    grid.datagrid('unselectRow',index).datagrid('selectRow', NextIndex);
		                } else {
		                    grid.datagrid('selectRow', rows.length - 1);
		                }
		                break;
		            case 40: // down
		                var Selections = grid.datagrid('getSelections');
		                var rows = grid.datagrid('getRows');
		                if (Selections.length>0) {
		                	var MaxSelection=null,MinSelection=null;
			                var opts=grid.datagrid('options')
				            $.each(Selections,function(Index,RowData){
				            	if (RowData==null){return true;}
				            	if (RowData[opts.idField]==""){return true;}
				            	if (MaxSelection==null){
				            		MaxSelection=RowData;
				            	}
				            	if (MinSelection==null){
				            		MinSelection=RowData;
				            	}
								var RowIndex=grid.datagrid('getRowIndex',RowData.OrderId);
								var Maxindex=grid.datagrid('getRowIndex',MaxSelection.OrderId);
								var Minindex=grid.datagrid('getRowIndex',MinSelection.OrderId);
								if (Maxindex<RowIndex){
									MaxSelection=RowData;
								}
								if (Minindex>RowIndex){
									MinSelection=RowData;
								}
							});
							if (MaxSelection==null){
								grid.datagrid('uncheckAll');
								grid.datagrid('selectRow', 0);
							}else{
			                    var index = grid.datagrid('getRowIndex', MaxSelection);
			                    var NextIndex=index+1;
			                    if (NextIndex>=rows.length){
				                	NextIndex=0;
				                }
				                grid.datagrid('unselectRow',index).datagrid('selectRow', NextIndex);
			                }
		                    
		                } else {
		                    grid.datagrid('selectRow', 0);
		                }
		                break;
		    	}
	    	});
		});
	}
});
function MarkListDataGrid(){
	var Columns=[[ 
		{field:'ASRowId',hidden:true,title:''},
		{field:'MarkDesc',title:'ҽ��',width:120,
			styler: function(value,row,index){
				if ((row["AvailSeqNoStr"]=="")&&(row["AvailAddSeqNoStr"]=="")&&(ServerObj.SeqNoMode=='')){
					return 'color: red;';
				}
			}
		},
		{field:'DepDesc',title:'����',width:120},
		{field:'SessionTypeDesc',title:'�Һ�ְ��',width:80},
		{field:'AvailSeqNoStr',title:'ʣ��',width:80},
		{field:'RegedCount',title:'�ѹҺ���',width:80},
		{field:'AppedCount',title:'��ԤԼ��',width:80},
		{field:'AppedArriveCount',title:'��ȡ����',width:80},
		{field:'ScheduleDate',title:'����',width:100},
		{field:'TimeRange',title:'ʱ��',width:70},
		{field:'RegFee',title:'�Һŷ�',width:70},
		{field:'ExamFee',title:'����',width:70},
		{field:'Load',title:'�����޶�',width:80},
		{field:'AppLoad',title:'ԤԼ�޶�',width:80},
		{field:'AddedCount',title:'�ѼӺ���',width:80},
		{field:'AddLoad',title:'�Ӻ��޶�',width:80},
		{field:'AppFee',title:'ԤԼ��',width:70},
		{field:'AvailAddSeqNoStr',title:'�Ӻ�',width:80},
		{field:'AvailNorSeqNoStr',title:'�ֳ�ʣ��',width:80},
		{field:'ClinicGroupDesc',title:'��רҵ',width:80},
		{field:'HoliFee',title:'���շ�',width:70},
		{field:'AppFeeDr',title:'������',width:70}, //OtherFeeԭ��ȡ���ֶ���AppFeeDr��
		{field:'BorghAlertInfo',title:'��ʾ��Ϣ',width:80,showTip:true},
		{field:'RoomDesc',title:'����',width:80},
		{field:'ScheduleDateWeek',title:'����',width:80},
		{field:'ScheduleStatus',title:'�Ű�״̬',width:80},
		{field:'DepDr',hidden:true,title:''},
		{field:'MarkDr',hidden:true,title:''},
		{field:'RegFeeDr',hidden:true,title:''}
    ]]
	var MarkListDataGrid=$("#MarkList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : false,  
		idField:'ASRowId',
		columns :Columns,
		rowStyler: function(index,row){
			if (row["ScheduleStatus"]=="ͣ��"){
				return 'background-color:red;'
			}
			if ((row["AvailSeqNoStr"]=="")&&(row["AvailAddSeqNoStr"]=="")&&(ServerObj.SeqNoMode=='')){
				return 'font-style: italic;';
			}
			if ((row["AvailNorSeqNoStr"]=="")&&(ServerObj.SeqNoMode=='1')){
				return 'font-style: italic;';
			}
		},
		onDblClickRow:function(index, row){
			MarkListDBClick(row);
		},
		onLoadSuccess:function(data){
			if(data["rows"].length>0){
				//Ĭ��ѡ�е�һ��
				$(this).datagrid('selectRow', 0);  
				//���ý���,������ѡ�е�һ�к�����������¼��¼�
				$("#MarkList").datagrid('getPanel').panel('panel').focus();
			}
			/*$(".datagrid-row").mouseover(function(value){
	            //��ȡ��ǰ�е�Ψһ��ʶfield
	            var uniqueRow = $(this).children("td").eq(0).text();
	            var loadData = PageLogicObj.m_MarkListDataGrid.datagrid("getData").rows;
	            var index = 0;
	            var currentRowData = null,currentRowIndex=null;
	            //��ȡѡ���а󶨵������Լ�index
	            for(index; index < loadData.length; index++){
	                currentRowData = loadData[index];
	                if(currentRowData.ASRowId == uniqueRow){
		                currentRowIndex=index;
	                    break;
	                }
	            }
	            //�ж��Ƿ�Ϊѡ���е�����
	            if(currentRowData.ASRowId != uniqueRow){
	                return;
	            }
	            //������Ը������ݵ���������
	            var HTML=GetPannelHTML(currentRowData,this.id);
				if (HTML.innerHTML==""){return;}
				$("#"+this.id).webuiPopover({
					width:HTML.width,
					height:HTML.height,
					title:HTML.Title,
					content:HTML.innerHTML,
					closeable:true,
					trigger:'hover',
					placement:'bottom-right',
					onShow:function(){
						if (typeof HTML.CallFunction == "function"){
							HTML.CallFunction.call();
						}
					}
				});
				$("#"+this.id).webuiPopover('show');
	        });
	        $(".datagrid-row").mouseout(function(value){
	            //��������������ݵĻ�ȡ��mouseover��ʵ������
	            //$(this).webuiPopover('hide');
	        });*/
		}
	}).datagrid("keyCtr"); 
	return MarkListDataGrid;
}
function CardNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		CheckCardNo();
	}
}
function CheckCardNo(){
	var CardNo=$("#CardNo").val();
	if (CardNo=="") return false;
	var myrtn=DHCACC_GetAccInfo("",CardNo,"","",CardNoKeyDownCallBack);
}
function CardNoKeyDownCallBack(myrtn){
	var myary=myrtn.split("^");
   var rtn=myary[0];
   $("#CardTypeRowID").val(myary[8]);
   var CardLeaving=myary[3];
   $("#CardLeaving").val(CardLeaving);
   $("#AccAmount").val(CardLeaving);
	switch (rtn){
		case "0": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").focus().val(CardNo);
			if(CardLeaving<=0){
				DHCC_SelectOptionByCode("PayMode","CASH");
			}else{
				DHCC_SelectOptionByCode("PayMode","CPP");
			}
			SetPatientInfo(PatientNo,CardNo);
			event.keyCode=13;			
			break;
		case "-200": //����Ч
			$.messager.alert("��ʾ","����Ч","info",function(){
				var CardNo=$("#CardNo").val();
				ClearPatInfo();
				$("#CardNo").val(CardNo).focus();
			});
			break;
		case "-201": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").focus().val(CardNo);
			if (ServerObj.ParaRegType!="APP"){
				DHCC_SelectOptionByCode("PayMode","CASH");
			}
			SetPatientInfo(PatientNo,CardNo);
			event.keyCode=13;
			break;
		default:
	}
}
function ReadCardClickHandler(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}
function SetPatientInfo(PatientNo,CardNo){
	if (!CheckBeforeCardNoChange()) return false;
	if (PatientNo!='') {
		var AccAmount= $("#AccAmount").val();
		var CardTypeNew=$("#CardTypeNew").val();
		var CardTypeRowID=$("#CardTypeRowID").val();
		var CardLeaving=$("#CardLeaving").val();
		ClearPatInfo();
		$("#PatientNo").val(PatientNo);
		$("#CardNo").val(CardNo);
		$("#AccAmount").val(AccAmount);
		$("#CardTypeNew").val(CardTypeNew);
		$("#CardTypeRowID").val(CardTypeRowID);
		$("#CardLeaving").val(CardLeaving);
		var TemporaryCardFlag=CheckTemporaryCard(CardNo, CardTypeRowID);
		var IsTempCard=TemporaryCardFlag.split("^")[0];
		var DiscDate=TemporaryCardFlag.split("^")[1];
		if (IsTempCard=="Y"){
			if (DiscDate>0){
				$.messager.alert("��ʾ","��ʱ���ѹ��ܹҺ���Ч����!")
				return false;
			}
			dhcsys_alert("��ʱ��ֻ�ܹҼ����!")
		}
		var PatInfoStr=$.cm({
		    ClassName : "web.DHCOPAdmReg",
		    MethodName : "GetPatDetailBroker",
		    dataType:"text",
		    itmjs:"",
		    itmjsex:"GetPatDetailToHUI",
		    val:PatientNo,
	    },false);
	    if (PatInfoStr!=""){
		    SetPatient_Sel(PatInfoStr);
		    $("#FindDept").next('span').find('input').focus();
		}else{
			$("#CardNo").addClass("newclsInvalid").focus(); 
			return false();
		}
	} else {
		$('#CardNo').focus();
		return false();
	}
}
function SetPatient_Sel(value){
	try {  
		var Patdetail=value.split("^");
		$("#Name").val(Patdetail[0]);
		$("#Age").val(Patdetail[1]);
		$("#Sex").val(Patdetail[2]);
		//���ﲡ���ź�סԺ������
		$("#OPMRN").val(Patdetail[3]);
		$("#IPMRN").val(Patdetail[4]);
		//ҽ����
		$("#PatYBCode").val(Patdetail[11]);
		$("#TelH").val(Patdetail[21]);
		$("#PAPERCountry").val(Patdetail[22]);
		$("#Address").val(Patdetail[23]);
		var PatCat=Patdetail[5];
		$("#PatCat").val(PatCat);
		if (PatCat==""){
			$.messager.alert("��ʾ","�벹¼�������!","info",function(){
				var CardNo=$("#CardNo").val();
				BClearHandle();
				var lnk = "doc.patientinfoupdate.hui.csp?CardNo="+CardNo;
				var $code ="<iframe width='100%' height='99%' scrolling='auto' frameborder='0' src='"+lnk+"'></iframe>" ;
				createModalDialog("Project","�޸Ļ�����Ϣ", PageLogicObj.dw, PageLogicObj.dh,"icon-write-order","",$code,"");
				$('#CardNo').focus();
				return false();
			})
		}
		$("#PatientID").val(Patdetail[6]);
		$("#IDCardNo").val(Patdetail[7]);
		$("#PatientNo").val(Patdetail[9]);
		$("#AppBreakCount").val(Patdetail[10]);
		if (PageLogicObj.m_PreCardNo==""){
			PageLogicObj.m_PreCardNo=$("#CardNo").val();
			PageLogicObj.m_PreCardType=$("#CardTypeNew").val();
			PageLogicObj.m_PreCardLeaving=$("#CardLeaving").val();
		}
		var PatientID=Patdetail[6];
		//ԤԼ����
		var AppSerialNo=$("#AppSerialNo").val();
		if (AppSerialNo==undefined) AppSerialNo="";
		if (AppSerialNo!="") {
			AppSerialNoBlurHandler();
		}else{
			GetApptInfo(PatientID);
		}
		var rtn=$.cm({
		    ClassName : "web.DHCOPAdmReg",
		    MethodName : "GetAdmRecord",
		    dataType:"text",
		    PatientID:PatientID
	    },false);
	    var o=$HUI.checkbox("#MedicalBook");
		if(rtn==0){
			o.setValue(true);
			$HUI.checkbox("#NeedCardFee").setValue(true);
		}else{
			o.setValue(false);
			$HUI.checkbox("#NeedCardFee").setValue(false);
		}
		$.cm({
			ClassName:"web.DHCOPAdmReg",
			MethodName:"GetBillTypeListBroker",
			dataType:"text",
			JSFunName:"GetBillTypeToHUIJson",
			ListName:"",
			PatientID:PatientID
		},function(Data){
			var cbox = $HUI.combobox("#BillType", {
					valueField: 'id',
					textField: 'text', 
					editable:true,
					data: JSON.parse(Data)
			 });
		});
		//���ӵ����ѹҺż�¼��ѯ
		GetCurDateRegList();
		LoadMarkList();
	} catch(e) {
		$.messager.alert("��ʾ",e.message);
	};
}
function PatientNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		var PatientNo=$("#PatientNo").val();
		if (PatientNo!='') {
			if (PatientNo.length<10) {
				for (var i=(10-PatientNo.length-1); i>=0; i--) {
					PatientNo="0"+PatientNo;
				}
			}
		}
		$("#PatientNo").val(PatientNo);
		CheckPatientNo();
	}
}
function CheckPatientNo(){
    var PatientNo=$("#PatientNo").val();
    var CardNoStr=$.cm({
	    ClassName : "web.DHCOPAdmReg",
	    MethodName : "GetCardNoByPatientNo",
	    dataType:"text",
	    PatientNo:PatientNo
    },false);
    var CardNo=CardNoStr.split("^")[0]
	if (CardNo=="") {
		$.messager.alert("��ʾ","�õǼǺ��޶�Ӧ������Ϣ���뽨����","info",function(){
			$("#PatientNo").val(PatientNo);
			$("#CardNo,#Name,#Sex,#Age").val(""); 
		});
		return false;
	}
	$("#CardNo").val(CardNo);
	$("#BillAmount,#PaySum,#ReturnAmount").val("0.00"); 
	var myCardTypeDR=CardNoStr.split("^")[5];
	var mySecurityNo=CardNoStr.split("^")[6];
	var myrtn=DHCACC_GetAccInfo(myCardTypeDR,CardNo,mySecurityNo,"",CardNoKeyDownCallBack);
	//CheckCardNo();
}
function NeedCardFeeCheck(){
	var o=$HUI.checkbox("#NeedCardFee");
	if (o.getValue()){
		var BillAmount=$('#BillAmount').val();
		if (BillAmount==""){BillAmount=0}
		BillAmount=(parseFloat(BillAmount,10)+parseFloat(ServerObj.CardFee,10)).toFixed(2); 
		$("#BillAmount").val(BillAmount);
	}else{
		var BillAmount=$('#BillAmount').val();
		if (BillAmount==""){BillAmount=0}
		BillAmount=(parseFloat(BillAmount,10)-parseFloat(ServerObj.CardFee,10)).toFixed(2); 
		$("#BillAmount").val(BillAmount);
	}
}
function ClearPatInfo(){
	var $input=$(":input:text");
	for (var i=0;i<$input.length;i++){
		$("#"+$input[i]["id"]).val("");
	}
	$("#Name").removeClass("blackname");
}
function CheckBeforeCardNoChange(){
	//��֤�Ƿ���δ��ɵĹҺ�
	var Data=PageLogicObj.m_selectedMarkListDataGrid.datagrid("getData");
	if (Data["rows"].length>=1){
		$.messager.alert("��ʾ","���������һ�����˵ĹҺ�!","info",function(){
			$("#CardNo").val(PageLogicObj.m_PreCardNo);
			$("#CardTypeNew").val(PageLogicObj.m_PreCardType);
			$("#CardLeaving").val(PageLogicObj.m_PreCardLeaving);
		});
		return false;
	}
	return true;
}
function DHCC_SelectOptionByCode(id,Val){
	if (id=="PayMode") {
		var PayModeData=$("#PayMode").combobox('getData');
		var index=$.hisui.indexOfArray(PayModeData,"CTPMCode",Val);
		if (index>=0){
			$("#PayMode").combobox("select",PayModeData[index].CTPMRowID);
		}
	}else{
		var opts=$("#"+id).combobox("options");
		var ComboData=$("#"+id).combobox('getData');
		for (var i=0;i<ComboData.length;i++){
			var scode=ComboData[i][opts.valueField];
			var pmod=scode.split("^");	
			if (pmod[2]==Val) {
				$("#"+id).combobox('select',scode);
			}
		}
	}
}
function GetCurDateRegList(){
	$.cm({
		ClassName:"web.DHCOPAdmReg",
		QueryName:"DHCOPAdm",
		RegNo:"", nday:"", InvoiceNo:"", PatientID:$("#PatientID").val(), 
		UserRowId:"", QueryCancel:""
	},function(GridData){
		PageLogicObj.m_curDayRegListDataGrid.datagrid('loadData',GridData);
	});
}
function GetReceiptNo(){
	var p1=session['LOGON.USERID']+"^"+"^"+session['LOGON.GROUPID']+"^"+"R";
	var rtn=cspRunServerMethod(ServerObj.GetreceipNO,'SetReceipNO','',p1)
	if (rtn!='0') {
		$.messager.alert("��ʾ","û�з��䷢Ʊ��,���ܽ���!");
		return false;
	}
}
function SetReceipNO(value) {
	var myary=value.split("^");
	var ls_ReceipNo=myary[0];
	var title = myary[4];
	var tipFlag = myary[5];
	var receiptNo = title + ls_ReceipNo;
	$('#ReceiptNo').val(receiptNo);
	//�������С����С��ʾ��change the Txt Color
	if (tipFlag == "1"){	
		$("#ReceiptNo").addClass("newclsInvalid"); 
	}
}
function LoadDeptList(){
	$.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"GetOPDeptStr",
		dataType:"text",
		UserId:session['LOGON.USERID'], AdmType:"", Group:session['LOGON.GROUPID']
	},function(DeptStr){
		PageLogicObj.m_DeptStr=DeptStr;
		if(DeptStr!="") {   
			var DepArr=DeptStr.split("^");
			for (var i=0; i<DepArr.length; i++){
			  var DepID=DepArr[i].split(String.fromCharCode(1))[0];
			  var DepDesc=DepArr[i].split(String.fromCharCode(1))[1];
			  var Obj=document.getElementById('DeptList');
				if (Obj){AddItemSingle(Obj,DepID,DepDesc);}
			}
		}
	});
}
function AddItemSingle(lst,val,txt) {
	lst.options[lst.options.length] = new Option(txt,val);
}
function FindDeptChange(value,name){
	value=value.toUpperCase();
	var matchIndexArr=new Array();
	var matchLocArr=new Array();
	/*$($("#DeptList option")).show();
	var tmp=document.getElementById('DeptList');
	var len=tmp.length
	var DepId=""
	for(var i=0;i<len;i++){
		var selItem=tmp.options[i];		
		var selText=selItem.text
		var selTextArr=selText.split("-")
		var selText=selTextArr[1].toUpperCase();
		var selCode=selTextArr[0].toUpperCase();
		if ((selText.indexOf(value)>=0)||(selCode.indexOf(value)>=0)){
			matchIndexArr.push(i);
			matchLocArr.push(selItem);
		}else{
			$($("#DeptList option")[i]).hide();
		}
	}*/
	var Obj=document.getElementById('DeptList');
	$("#DeptList").empty();
	var DepArr=PageLogicObj.m_DeptStr.split("^");
	for (var i=0; i<DepArr.length; i++){
	  	var DepID=DepArr[i].split(String.fromCharCode(1))[0];
	  	var DepDesc=DepArr[i].split(String.fromCharCode(1))[1];
	  	var selText=DepDesc.split("-")[0].toUpperCase();
		var selCode=DepDesc.split("-")[1].toUpperCase();
		if ((selText.indexOf(value)>=0)||(selCode.indexOf(value)>=0)){
			
			if (Obj){AddItemSingle(Obj,DepID,DepDesc);}
			matchIndexArr.push(i);
			matchLocArr.push({"value":DepID,"text":DepDesc});
		}
	}
	if ((matchIndexArr.length==0)||(matchIndexArr.length>1)){
		Obj.selectedIndex=-1;
		PageLogicObj.m_DepId="";
		$("#SelLoc").html("");
		$("#MarkListPanel").removeClass('marklist-card-panel');
		var $btntext=$("#MarkListShowMode .l-btn-text")[0];
		var text=$btntext.innerText;
		if (text.indexOf("��ͼ")>=0){
			if (PageLogicObj.m_MarkListDataGrid!=""){
				PageLogicObj.m_MarkListDataGrid.datagrid('loadData', {"total":0,"rows":[]});
			}
		}else{
			$("#MarkListPanel").addClass('marklist-card-panel');
			var $card=$("div[id*='-marklist-card']");
			if ($card.length>0) $card.parent().remove();
		}
	}else{
		Obj.selectedIndex=0;
		PageLogicObj.m_DepId=matchLocArr[0].value;
		$("#SelLoc").html(matchLocArr[0].text.split("-")[0]);
		LoadMarkList();
	}
	/*if(PageLogicObj.m_DepId==""){
		tmp.selectedIndex=-1
	}*/
}
function MarkListDBClick(row){
	var dataObj=new Object();
	dataObj={
		TabASRowId:row["ASRowId"],
		DeptDesc:row["DepDesc"],
		MarkDesc:row["MarkDesc"],
		SeqNo:"",
		Price:"",
		AdmDate:row["ScheduleDate"],
		DeptRowId:row["DepDr"],
		TabPCLRowID:"",
		TAPPTRowID:"",
		AvailSeqNoStr:row["AvailSeqNoStr"],
		AvailAddSeqNoStr:row["AvailAddSeqNoStr"],
		HoliFee:row["HoliFee"],
		ExamFee:row["ExamFee"],
		RegFee:row["RegFee"],
		AppFee:row["AppFee"],
		OtherFee:row["AppFeeDr"],
		ReCheckFee:"",
		TabFreeRegFlag:"",
		TabFreeCheckFlag:"",
		TabReAdmFeeFlag:""
	}
	if (AddBeforeUpdate(dataObj)==false) return false;
	AddToSelectedMarkList(dataObj,true);
}
function AddToSelectedMarkList(dataObj,alertFlag){
	if ((ServerObj.ParaRegType!="APP")||(dataObj["TAPPTRowID"]=="")){
		var $tab=PageLogicObj.m_selectedMarkListDataGrid;
	}else{
		var $tab=PageLogicObj.m_curDayAppListDataGrid;
	}
	$tab.datagrid('appendRow',{
		Operation:"",
		TabASRowId: dataObj["TabASRowId"],
		TabDeptDesc:dataObj["DeptDesc"],
		TabMarkDesc: dataObj["MarkDesc"],
		TabSeqNo: dataObj["SeqNo"],
		TabPrice: dataObj["Price"],
		TabAppDate:dataObj["AdmDate"],
		TabDeptRowId: dataObj["DeptRowId"],
		TabPCLRowID:dataObj["TabPCLRowID"],
		TAPPTRowID: dataObj["TAPPTRowID"],
		TabFreeRegFlag: dataObj["TabFreeRegFlag"],
		TabFreeCheckFlag: dataObj["TabFreeCheckFlag"],
		TabReAdmFeeFlag: dataObj["TabReAdmFeeFlag"],
		TabHoliFee: dataObj["HoliFee"],
		TabAppFee: dataObj["AppFee"],
		TabExamFee: dataObj["ExamFee"]
	});
	if (alertFlag) {
		$.messager.popover({msg: '����ӵ��ű��б�!',type:'success',timeout: 2000});
	}
}
function AddBeforeUpdate(dataObj){
	var ASRowId=dataObj["TabASRowId"];
	if (ASRowId=="") return false;
	var PatientID=$('#PatientID').val();
	if (PatientID==""){
		$.messager.alert("��ʾ","����ͨ������ȷ������!","info",function(){
			$('#CardNo').focus();
		});
	   	return false;
	}
	if (!AddBeforeUpdateByASRowId(ASRowId)) return false;
	if (ServerObj.ParaRegType!="APP"){
		if ((dataObj["AvailSeqNoStr"]=="")&&(dataObj["AvailAddSeqNoStr"]=="")){
			$.messager.alert("��ʾ","�úű��ѹ���!");       				
			return false;
		}
		if (dataObj["AvailSeqNoStr"]=="0"){
			$.messager.alert("��ʾ","�úű��ѹ���!");       				
			return false;
		}
	}
	//�жϽ������Ƿ����ظ��Һ�
	if (DuplReg(ASRowId)){
		$.messager.alert("��ʾ","���Һ��ظ�,������ѡ��!");
		return false;
	}
	//��ӵ��м�¼ǰ���м��
	var Rtn=$.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"CheckBeforeReg",
		dataType:"text",
		ResRowId:ASRowId, PatientID:PatientID, APPTRowId:"",
		CardTypeDr:$("#CardTypeRowID").val(),CardNo:$("#CardNo").val()
	},false);
	var RtnArry=Rtn.split("^")
	if (RtnArry[0]!=0){
		$.messager.alert("��ʾ",RtnArry[1]);
		return false;
	}
	//�ж��Ƿ�Ϊ����,����Ǹ���۸���ܻ᲻ͬ
	var ReAdmFeeFlag=GetReAdmFeeFlag(PatientID,ASRowId);
	dataObj["TabReAdmFeeFlag"]=ReAdmFeeFlag;
	if ((ReAdmFeeFlag==1)&&((dataObj["ReCheckFee"]!="")&&(dataObj["ReCheckFee"]!=0))){dataObj["ExamFee"]=ReCheckFee}
	var MRNoteFee=0;CardFee=0;
	//�Ƿ�����Һŷѻ�������� ����checkboxѡ��?�Զ��ı������ 
	var o=$HUI.checkbox('FreeCheck');
	if(o.getValue()) {
		dataObj["ExamFee"]=0;
		dataObj["TabFreeCheckFlag"]="Y";
	}
	var o=$HUI.checkbox('FreeReg');
	if(o.getValue()) {
		dataObj["RegFee"]=0;
		dataObj["TabFreeRegFlag"]="Y";
	}
	var TotalFee=parseFloat(dataObj["HoliFee"])+parseFloat(dataObj["ExamFee"])+parseFloat(dataObj["RegFee"])+parseFloat(dataObj["AppFee"])+parseFloat(dataObj["OtherFee"])+parseFloat(MRNoteFee);
	if (TotalFee==0){
		var ContiuCheck=dhcsys_confirm("�˺�û�ж���۸�,��ȷ�ϼ����Һ���?",false);
		if (ContiuCheck==false) return false;	
	}
	TotalFee=parseFloat(TotalFee).toFixed(2); 
	dataObj["Price"]=TotalFee;
	var BillAmount=+$("#BillAmount").val();
	var ToBillAmount=parseFloat((parseFloat(+BillAmount)+parseFloat(TotalFee))).toFixed(2);
	AccAmount=$('#AccAmount').val();
	//��������ʻ�֧��Ҫ�ж��Ƿ��ʻ�����㹻
	var PayModeCode=GetPayModeCode();
	if (PayModeCode=="CPP") {
 		if (ToBillAmount>parseFloat(AccAmount)) {
	   		$.messager.alert("��ʾ","�ʻ�����");
	   		return false;
 		}
 	} 	
	$("#BillAmount").val(ToBillAmount);
	var PayModeCode=GetPayModeCode()
	if(PayModeCode!="CPP") ReCalculateAmount();
	return dataObj;
}
function AddBeforeUpdateByASRowId(ASRowId){
	var PatientID=$('#PatientID').val();
	var myrtn=$.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"CheckRegDeptAgeSex",
		dataType:"text",
		ASRowId:ASRowId,
		PatientID:PatientID
	},false);
	var Flag=myrtn.split(String.fromCharCode(2))[0];
	if (Flag!="0") {
		var msg="";
		var AllowSexDesc=myrtn.split(String.fromCharCode(2))[1];
		if (AllowSexDesc!="") msg="�˿���֧���Ա�"+AllowSexDesc+"��";
		var AgeRange=myrtn.split(String.fromCharCode(2))[2];
		if (AgeRange!="") {
			if (msg=="") {
				msg="�˿���֧�������:"+AgeRange;
			}else{
				msg=msg+","+"�˿���֧������Ρ�"+AgeRange+"��";
			}
		}
		$.messager.alert("��ʾ","������Ҵ˿���,"+msg);
		return false;
	}
	var myrtn=$.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"CheckScheduleStatus",
		dataType:"text",
		ASRowId:ASRowId
	},false);
	if (myrtn=="S") {
		$.messager.alert("��ʾ","������Ҵ��Ű�,���Ű���ͣ��.");
		return false;
	}
	return true;
}
function GetReAdmFeeFlag(PatientID,ASRowId){
	var ret=$.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"GetReAdmFeeFlag",
		dataType:"text",
		PatientID:PatientID, ASRowId:ASRowId
	},false);
	return ret;
}
function ReCalculateAmount(){
	var BillAmount=$('#BillAmount').val();
	var GetAmount=$('#PaySum').val();
	if ((GetAmount!="")&&(GetAmount!='0.00')){
		var ReturnAmount=parseFloat(GetAmount)-BillAmount;
		var ReturnAmount=ReturnAmount.toFixed(2)
		$("#ReturnAmount").val(ReturnAmount);
		if (ReturnAmount<0){
			$("#ReturnAmount").addClass("newclsInvalid"); 
		}else{
			$("#ReturnAmount").removeClass("newclsInvalid"); 
		}
	}
}
function GetPayModeCode(){
	var PayModeValue=$("#PayMode").combobox("getValue");
	if (PayModeValue!="") {
		var PayModeData=$("#PayMode").combobox('getData');
		var index=$.hisui.indexOfArray(PayModeData,"CTPMRowID",PayModeValue);
		var PayModeCode= PayModeData[index].CTPMCode;
		return PayModeCode;
	}
	return "";
}
function DuplReg(ASRowId)	{
	var RepeatFlag=0;
	var Data=PageLogicObj.m_selectedMarkListDataGrid.datagrid("getData");
	for (var i=0;i<Data["rows"].length;i++){
		if (Data["rows"][i]["TabASRowId"]==ASRowId){
			RepeatFlag=1;
			break;
		}
	}
	if (RepeatFlag==1) return true;
	return false;
}
function Clear_click(){
	PageLogicObj.m_DepId="";
	ClearPatInfo();
	SetDefaultTimeRange();
	$('#FindDept').searchbox('setValue', ""); 
	$("#WeekDesc,#SelLoc").html("");
	PageLogicObj.m_PreCardNo="";
	PageLogicObj.m_PreCardType="";
	PageLogicObj.m_PreCardLeaving="";
	var o=$HUI.checkbox("#FreeReg,#FreeCheck").setValue(false);
	$("#SelDate").html(ServerObj.CurDate);
	$("#WeekDesc").html(ServerObj.CurWeek);
	ClearAllTableData("curDayRegList");
	GetReceiptNo();
	LoadPayMode();
	$("#AccAmount").val("");
	ClearAllTableData("selectedMarkList");
	var $btntext=$("#MarkListShowMode .l-btn-text")[0];
	var text=$btntext.innerText;
	if (text.indexOf("��ͼ")>=0){
		ClearAllTableData("MarkList");	
	}else{
		var $card=$("div[id*='-marklist-card']");
		if ($card.length>0) $card.parent().remove();
	}
	var obj=document.getElementById('DeptList');
	if(obj&&(obj.options.length>0)){
		obj.selectedIndex=-1;
	}
	FindDeptChange("");
}
function ClearPatInfo(){
	var $input=$(":input:text");
	for (var i=0;i<$input.length;i++){
		$("#"+$input[i]["id"]).val("");
	}
	$('#PatientID').val("");
	$("#Name").removeClass("blackname");
}
function ClearAllTableData(id){
	var Data=$("#"+id).datagrid("getData");
	for (var i=Data["rows"].length-1;i>=0;i--){
		$("#"+id).datagrid('deleteRow',i);
	} 
}
function UpdateClickHandler(){
	var PatientID=$('#PatientID').val();
	if (PatientID==""){
		$.messager.alert("��ʾ","����ͨ������ȷ������!","info",function(){
			$('#CardNo').focus();
		});
	   	return false;
	}
	var NeedDelIndexArr=new Array();
	var Data=PageLogicObj.m_selectedMarkListDataGrid.datagrid("getData");
	if (Data["rows"].length==0){
		$.messager.alert("��ʾ","û��ѡ��Һ���Ϣ!");
			return false;
	}
	var BillAmount=$('#BillAmount').val(); 
	var CardNo=$('#CardNo').val(); 
	//�ʻ�RowId
	var AccRowId=""; 
	var PayModeCode=GetPayModeCode();
	if (PayModeCode=="CPP") {
		var CardTypeRowID=$("#CardTypeRowID").val();
		if (CardTypeRowID!=""){
			var myoptval=$.cm({
				ClassName:"web.UDHCOPOtherLB",
				MethodName:"ReadCardTypeDefineListBroker1",
				dataType:"text",
				myTypeID:CardTypeRowID
			},false);
			m_ReadCardMode=myoptval.split("^")[16];
			m_CCMRowID=myoptval.split("^")[14];
		}
		var ren=DHCACC_CheckMCFPay(BillAmount,CardNo,"",CardTypeRowID);
		var myary=ren.split("^");
		if (myary[0]!='0'){
			if (myary[0]=='-204'){$.messager.alert("��ʾ","���û����˻�������,���ܰ���֧��,���ҹ���Ա����!")}
			if (myary[0]=='-205'){$.messager.alert("��ʾ","�ʻ�����!")}
			if (myary[0]=='-206'){$.messager.alert("��ʾ","�����벻һ��,��ʹ��ԭ��!")}
			return false;
		}else{
			var AccRowId=myary[1];
			var AccAmount=$('#AccAmount').val();
			if ((AccRowId!="")&&(AccAmount=="")){
				var AccmLeftBalance=$.cm({
					ClassName:"web.DHCOPAdmReg",
					MethodName:"GetAccmLeftBalance",
					dataType:"text",
					AccRowId:AccRowId
				},false);
				$('#AccAmount').val(AccmLeftBalance);
			}
		}
	}	
	//����ԤԼ�Ƿ�ҪԤ�ȷ����,ȡ�ŵĴ�����ͬһ������
	var AdmReason="";
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];
	var LocID=session['LOGON.CTLOCID'];
	var AdmReason=$('#BillType').combobox('getValue');
	var AdmType="" //DHCC_GetElementData('AdmType');
	var RegConDisId="";
	var DiagnosCatRowId="";
	var RemoveRows=""
  try {
	for (var j=0;j<Data["rows"].length;j++) {
		var TabPrice=Data["rows"][j]["TabPrice"]; 
		var TabASRowId=Data["rows"][j]["TabASRowId"]; 
		//��ʱ�����ѿ����Ǹ�������
		var TabExamFee=Data["rows"][j]["TabExamFee"]; 
		var TabHoliFee=Data["rows"][j]["TabHoliFee"]; 
		var TabAppFee=Data["rows"][j]["TabAppFee"]; 
		var TabQueueNo=Data["rows"][j]["TabSeqNo"];
		if (TabQueueNo==undefined) TabQueueNo="";
		var AppDate=Data["rows"][j]["TabAppDate"]; 
		var TabReAdmFeeFlag=Data["rows"][j]["TabReAdmFeeFlag"]; 
		//�����ϴ���������ҺŷѺ������ѱ��
		var TabFreeRegFlag=Data["rows"][j]["TabFreeRegFlag"]; 
		var TabFreeCheckFlag=Data["rows"][j]["TabFreeCheckFlag"]; 
		//ԤԼID
		var TAPPTRowID=Data["rows"][j]["TAPPTRowID"]; 
		//����ּ���
		var TabPCLRowID=Data["rows"][j]["TabPCLRowID"];  
		//�Ƿ񴫲�����
		var TabMRFee="0";var TabCardFee="0"
		//������������ȡ1��
		var o=$HUI.checkbox('#MedicalBook');
		if ((o.getValue())&&(j==0)){TabMRFee="1"}
		var o=$HUI.checkbox('#NeedCardFee');
		if (o.getValue()){TabCardFee="1"}
		//���Ϊ����,��������,���������ô������ֵ
		var TabReCheckFee=0;
		if ((TabReAdmFeeFlag==1)&&((TabExamFee!="")&&(TabExamFee!=0))){		
			TabReCheckFee=TabExamFee;
			TabExamFee=0;
		}
	    var BLNo=0;     //�Ƿ񴫲����ű�־?0����������?1��������
		var FeeStr=TabPrice+"||"+TabExamFee+"||"+TabHoliFee+"||"+TabAppFee+"||"+TabMRFee+"||"+TabReCheckFee+"||"+TabCardFee;
		var ret=$.cm({
			ClassName:"web.DHCOPAdmReg",
			MethodName:"OPRegistBroker",
			dataType:"text",
			PatientID:PatientID, ASRowId:TabASRowId, AdmReason:AdmReason, QueueNo:TabQueueNo, FeeStr:FeeStr,
			PayModeCode:PayModeCode, AccRowId:AccRowId, user:UserID, group:GroupID,
			AdmType:AdmType, DiagnosCatRowId:DiagnosCatRowId, 
			FreeRegFlag:TabFreeRegFlag,FreeCheckFlag:TabFreeCheckFlag,RegfeeRowId:"", InsuJoinStr:"",
			DiscountFactor:"", TAPPTRowID:TAPPTRowID, 
			UnBillFlag:"", TabPCLRowID:TabPCLRowID, ApptMethodCode:"", SourceType:"", RegConDisId:RegConDisId
		},false);
		var retarr=ret.split("$");	
		if (retarr[0]=="0"){
			//�������ӿں���,��̳ҽԺֻ�ж����ﲡ����  �˴�������,�Ƿ���ò����ӿ�?����ҽ���ӿڲ�һ��?�˴���ӽӿ���Ҫ����  090312
			var PrintArr=retarr[1].split("^");
			var EpisodeID=PrintArr[0];
			var TabASRowId=PrintArr[22];
			var RegfeeRowID=PrintArr[42];
			var MedCodeArr=$.cm({
				ClassName:"web.DHCOPAdmChang",
				MethodName:"GetPatMedCode",
				dataType:"text",
				EpisodeID:EpisodeID
			},false);
			var MedCodeStr=MedCodeArr.split("^");
			var DYOPMRN=MedCodeStr[0];
			var DYIPMRN=MedCodeStr[1];
			var SGMedicareCode1=MedCodeStr[2];
			var SGMedicareCode2=MedCodeStr[3];
			var PatientID=MedCodeStr[4];
			//Ʊ�ݺϼ����� 
			var ReceiptCount=$('#ReceiptCount').val();
			ReceiptCount=parseInt(ReceiptCount)+1;
			$('#ReceiptCount').val(ReceiptCount);
			//��ӡ�Һ�С��
			PrintOut(j,retarr[1]);
			NeedDelIndexArr.push(j);
			$.messager.alert("��ʾ","�Һųɹ�!","info",function(){
				Clear_click();
				SetDefaultTimeRange();
			});
		}else{
			var errmsg="";
			if (retarr[0]=="-201")  errmsg="���ɾ����¼ʧ��!";
			if (retarr[0]=="-202")  errmsg="ȡ�Ų��ɹ�!";
			if (retarr[0]=="-2121")  errmsg="����ԤԼ״̬ʧ��!";
			if (retarr[0]=="-2122")  errmsg="ϵͳæ,���Ժ�����!";
			if (retarr[0]=="-206")  errmsg="����Һŷ�ҽ��ʧ��!";
			if (retarr[0]=="-207")  errmsg="��������ҽ��ʧ��!";
			if (retarr[0]=="-208")  errmsg="������շ�ҽ��ʧ��!";
			if (retarr[0]=="-209")  errmsg="����ԤԼ��ҽ��ʧ��!";
			if (retarr[0]=="-210")  errmsg="�Ʒ�ʧ��!";
			if (retarr[0]=="-211")  errmsg="����Һż�¼ʧ��!";
			if (retarr[0]=="-212")  errmsg="����кŶ���ʧ��!";
			if (retarr[0]=="-301")  errmsg="����ÿ��ÿ��ɹ��޶�,�����ٹҺŻ�ԤԼ!";
			if (retarr[0]=="-302")  errmsg="����ÿ��ÿ��ɹ���ͬ�ŵ��޶�!";
			if (retarr[0]=="-303")  errmsg="����ÿ��ÿ��ɹ���ͬ���Һŵ��޶�!";
			if (retarr[0]=="-304")  errmsg="����ÿ��ÿ��ͬʱ��ͬ����ͬҽ���޶�!";
			if (retarr[0]=="-401")  errmsg="��û�е��Һ�ʱ��!";
			if (retarr[0]=="-402")  errmsg="��δ��ԤԼʱ��!";
			if (retarr[0]=="-403")  errmsg="��δ���Ӻ�ʱ��!";
			if (retarr[0]=="-404")  errmsg="�Ѿ����˴��Ű��¼����ʱ���!";
			if (retarr[0]=="-2010") errmsg="����ҽ���Һ���Ϣʧ��!";
			if(errmsg=="") errmsg=retarr
			var TabDepDesc=Data["rows"][j]["TabDeptDesc"];
			var TabMarkDesc=Data["rows"][j]["TabMarkDesc"];
			var ErrInfo="�Һż�¼����:��"+TabDepDesc+"��,�ű�:��"+TabMarkDesc+"��,��������:��"+AppDate+"��,���:��"+TabQueueNo+"��"
			$.messager.alert("��ʾ",ErrInfo+"�Һ�ʧ��!"+","+errmsg,"info",function(){
				NeedDelIndexArr.push(j);
				if (NeedDelIndexArr.length>0){
					for (var m=NeedDelIndexArr.length-1;m>=0;m--){
						PageLogicObj.m_selectedMarkListDataGrid.datagrid('deleteRow',NeedDelIndexArr[m]);
					}
				}
				$('#CardNo').focus();
				return false;
			})
		}
	}
	if (NeedDelIndexArr.length>0){
		for (var m=NeedDelIndexArr.length-1;m>=0;m--){
			PageLogicObj.m_selectedMarkListDataGrid.datagrid('deleteRow',NeedDelIndexArr[m]);
		}
	}
	var ReceiptSum=$('#ReceiptSum').val();
	ReceiptSum=parseFloat(ReceiptSum)+parseFloat(TabPrice);
	$('#ReceiptSum').val(ReceiptSum);		
  }catch(e){$.messager.alert("��ʾ",e.message+","+e.name)}
}
function PrintOut(RegTblRow,PrintData) {
	//�޸� ͬʱ�Ҷ����ʱ�����ص�xmlģ����ɷ�Ʊģ��
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAdmRegPrint");
	try {
		if (PrintData=="") return;
		var PrintArr=PrintData.split("^");
		var AdmNo=PrintArr[0];
		var PatName=PrintArr[1];
		var RegDep=PrintArr[2];
		var DocDesc=PrintArr[3];
		var SessionType=PrintArr[4];
		var MarkDesc=DocDesc
		var AdmDateStr=PrintArr[5];
		var TimeRange=PrintArr[6];
		var AdmDateStr=AdmDateStr+" "+TimeRange;
		var SeqNo=PrintArr[7];
		var RoomNo=PrintArr[8];
		var RoomFloor=PrintArr[9];
		var UserCode=PrintArr[10];
		var RegDateYear=PrintArr[12];
		var RegDateMonth=PrintArr[13];
		var RegDateDay=PrintArr[14];
		var TransactionNo=PrintArr[15];
		var Total=PrintArr[16];
		var RegFee=PrintArr[17];
		var AppFee=PrintArr[18];
		var OtherFee=PrintArr[19];
		var ClinicGroup=PrintArr[20];
		var RegTime=PrintArr[21];
		var ExabMemo=PrintArr[23];
		var InsuPayCash=PrintArr[24];
		var InsuPayCount=PrintArr[25];
		var InsuPayFund=PrintArr[26];
		var InsuPayOverallPlanning=PrintArr[27];
		var InsuPayOther=PrintArr[28];
		var TotalRMBDX=PrintArr[29];
		var INVPRTNo=PrintArr[30];
		var CardNo=PrintArr[31];
		var Room=PrintArr[32];
		var AdmReason=PrintArr[33];
		var Regitems=PrintArr[34];
		var AccBalance=PrintArr[35];
		var PatNo=PrintArr[36];
		var PoliticalLevel=PrintArr[43];
		var HospName=PrintArr[38];
		var PersonPay=$.trim(PrintArr[39]," ","");
		if (PersonPay!="") {
			PersonPay=PersonPay.replace("Ԫ","");
		}
		var PayModeStr1=PrintArr[46];
		var PayModeStr2=PrintArr[47];
		var MyList="";
		for (var i=0;i<Regitems.split("!").length-1;i++){
			var tempBillStr=Regitems.split("!")[i];
			if (tempBillStr=="") continue;
			var tempBillDesc=tempBillStr.split("[")[0];
			var tempBillAmount=tempBillStr.split("[")[1];
			if (MyList=="") MyList=tempBillDesc+"   "+tempBillAmount;
			else  MyList = MyList + String.fromCharCode(2)+tempBillDesc+"   "+tempBillAmount;
		}
		if (ServerObj.HospitalCode=="SCSFY"){
			Room=Room+"����";
		}
		//�����Ը������ı�ע
		var ProportionNote="";
		var ProportionNote1="";
		var ProportionNote2="";
		if ((ServerObj.HospitalCode=="SHSDFYY")&&((InsuCardType=='0')||(InsuCardType=='1'))){
			InsuPayCash="�ֽ�֧��:"+InsuPayCash;
			InsuPayCount="�ʻ�֧��:"+InsuPayCount;
			InsuPayOverallPlanning="ͳ��֧��:"+InsuPayOverallPlanning;
			InsuPayOther="����֧��:"+InsuPayOther;
			ProportionNote="(�ֽ�֧����,"+RegFee+"Ԫ"+"������ҽ��������Χ)";
			ProportionNote1="ҽ�Ƽ�¼��";
			ProportionNote2="�����ʻ����:  "+ThisYearAmt+"      �����ʻ����:  "+CalendarAmt;
		}else{
			InsuPayCash="";
			InsuPayCount="";
			InsuPayOverallPlanning="";
			InsuPayOther="";
			ProportionNote="���վ���,"+RegFee+"Ԫ"+"������ҽ��������Χ";
			ProportionNote1="";
			ProportionNote2="";
		}
		var o=$HUI.checkbox('#NeedCardFee');
		if (o.getValue()){
			var CardFee="������ "+parseFloat(ServerObj.CardFee)+"Ԫ";
		}else{
			var CardFee="";
		}
		RegTime=RegDateYear+"-"+RegDateMonth+"-"+RegDateDay+" "+RegTime
		AccAmount=$('#AccAmount').val();
		if (GetPayModeCode()=="CPP"){
			var AccTotal=parseFloat(AccAmount)- parseFloat((+PersonPay)) //parseFloat(Total);
		}else {
			var AccTotal=parseFloat(AccAmount);
		}
    	//���Ѻ���
		AccTotal=SaveNumbleFaxed(AccTotal);
		//����ǰ���
    	AccAmount=SaveNumbleFaxed(AccAmount);
		var DYOPMRN=$('#OPMRN').val(); //���ﲡ����
		var DYIPMRN=$('#IPMRN').val(); //סԺ������
		var cardnoprint=$("#CardNo").val();//���濨��		
		if(cardnoprint==""){	
		    var cardnoprint=CardNo ; //��̨����
		}
		var GridData=PageLogicObj.m_selectedMarkListDataGrid.datagrid("getData");
		var ASRowId=GridData["rows"][RegTblRow]["TabASRowId"];
		if (ASRowId==''){
			$.messager.alert("��ʾ","û��ѡ��Һ���Ϣ!");
			return false;
		}
		var TimeD=TimeRange; //$(".seltimerange")[0].id.split("-")[1];
		if (AppFee!=0){AppFee="ԤԼ��:"+AppFee+"Ԫ"}else{AppFee=""}
		if (OtherFee!=0) {OtherFee=OtherFee+"Ԫ"}else{OtherFee=""}
		if (RegFee!=0){RegFee=RegFee+"Ԫ"}else{RegFee=""}
		if (Total==0){Total=""}
		var PDlime=String.fromCharCode(2);
		var MyPara="AdmNo"+PDlime+AdmNo+"^"+"PatName"+PDlime+PatName+"^"+"TransactionNo"+PDlime+TransactionNo+"^"+"AccTotal"+PDlime+AccTotal+"^"+"AccAmount"+PDlime+AccAmount+"^"+"DYOPMRN"+PDlime+DYOPMRN+"^DYIPMRN"+PDlime+DYIPMRN;
		var MyPara=MyPara+"^"+"MarkDesc"+PDlime+MarkDesc+"^"+"AdmDate"+PDlime+AdmDateStr+"^"+"SeqNo"+PDlime+SeqNo+"^RegDep"+PDlime+RegDep;
		var MyPara=MyPara+"^"+"RoomFloor"+PDlime+RoomFloor+"^"+"UserCode"+PDlime+UserCode;
		var MyPara=MyPara+"^"+"RegDateYear"+PDlime+RegDateYear+"^RegDateMonth"+PDlime+RegDateMonth+"^RegDateDay"+PDlime+RegDateDay;
		var MyPara=MyPara+"^"+"Total"+PDlime+Total+"^RegFee"+PDlime+RegFee+"^AppFee"+PDlime+AppFee+"^OtherFee"+PDlime+OtherFee+"^CardFee"+PDlime+CardFee;
		var MyPara=MyPara+"^"+"RoomNo"+PDlime+RoomNo+"^"+"ClinicGroup"+PDlime+ClinicGroup+"^"+"SessionType"+PDlime+SessionType+"^"+"TimeD"+PDlime+TimeD+"^"+"RegTime"+PDlime+RegTime+"^"+"cardnoprint"+PDlime+cardnoprint;
		var MyPara=MyPara+"^"+"ExabMemo"+PDlime+ExabMemo;
		var MyPara=MyPara+"^"+"InsuPayCash"+PDlime+InsuPayCash+"^"+"InsuPayCount"+PDlime+InsuPayCount+"^"+"InsuPayFund"+PDlime+InsuPayFund+"^"+"InsuPayOverallPlanning"+PDlime+InsuPayOverallPlanning+"^"+"InsuPayOther"+PDlime+InsuPayOther;
		var MyPara=MyPara+"^"+"ProportionNote1"+PDlime+ProportionNote1+"^"+"ProportionNote2"+PDlime+ProportionNote2;
		var MyPara=MyPara+"^"+"TotalRMBDX"+PDlime+TotalRMBDX+"^"+"INVPRTNo"+PDlime+INVPRTNo+"^"+"CardNo"+PDlime+CardNo+"^"+"Room"+PDlime+Room;
		var MyPara=MyPara+"^"+"AdmReason"+PDlime+AdmReason+"^"+"PoliticalLevel"+PDlime+PoliticalLevel;;
		var MyPara=MyPara+"^"+"PatNo"+PDlime+PatNo;       //��ӡ�ǼǺ�
		var MyPara=MyPara+"^"+"HospName"+PDlime+HospName+"^"+"paymoderstr1"+PDlime+PayModeStr1+"^"+"paymoderstr2"+PDlime+PayModeStr2;
		var myobj=document.getElementById("ClsBillPrint");
		//PrintFun(myobj,MyPara,"");
		DHC_PrintByLodop(getLodop(),MyPara,"","","");
		$('#AccAmount').val(AccTotal);	
	} catch(e) {alert(e.message)};
}
//DHCPrtComm.js
function PrintFun(PObj,inpara,inlist){
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
		if (rtn){
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
		}
	}catch(e){
		$.messager.alert("��ʾ",e.message);
		return false;
	}
}
function SaveNumbleFaxed(str)
{
	var len,StrTemp;
	if((str=="")||(!str)) return 0;
	if(parseInt(str)==str){
		str=str+".00";
		}else{
		StrTemp=str.toString().split(".")[1];
		len=StrTemp.length;
		if(len==1){
			str=str+"0";
		}else{
			var myAry=str.toString().split(".");
			str=myAry[0]+"."+myAry[1].substring(0,2);
		}
	}
	return str;		
}
function DelSelMarkListRow(){
	var row=PageLogicObj.m_selectedMarkListDataGrid.datagrid('getSelected');
	var BillAmount=$("#BillAmount").val();
	BillAmount=parseFloat(BillAmount)-parseFloat(row["TabPrice"]);
	BillAmount=BillAmount.toFixed(2);
	var index=PageLogicObj.m_selectedMarkListDataGrid.datagrid('getRowIndex',row);
	PageLogicObj.m_selectedMarkListDataGrid.datagrid('deleteRow',index);
	$("#BillAmount").val(BillAmount);
	ReCalculateAmount();
}
function DelSelMarkListRowByABRS(ASRowId){
	var index=PageLogicObj.m_selectedMarkListDataGrid.datagrid('getRowIndex',ASRowId);
	PageLogicObj.m_selectedMarkListDataGrid.datagrid('selectRow',index);
	DelSelMarkListRow();
}
function DeptListChange(){
	var tmp=document.getElementById('DeptList');
	var selItem=tmp.options[tmp.selectedIndex];	
	if (selItem) {
		PageLogicObj.m_DepId=selItem.value;	
		$("#SelLoc").html(selItem.text.split("-")[0]);
		LoadMarkList();
	}
}
function BCacelRegHandle(EpisodeID){
	if (typeof EpisodeID =="undefined"){EpisodeID="";}
	var src="opadm.return.hui.csp?EpisodeID="+EpisodeID+"&PageFrom=Reg";;
	var $code ="<iframe width='99%' height='99%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Project","�˺�", PageLogicObj.dw, PageLogicObj.dh,"icon-exe-order","",$code,"");
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}
function destroyDialog(id){
   //�Ƴ����ڵ�Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
///�жϿ��Ƿ�����ʱ��
function CheckTemporaryCard(CardNo, CardTypeDr) {
	var TemporaryCardFlag=$.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"CheckTempCardEffe",
		CardTypeId:CardTypeDr,
		CardNo:CardNo,
		dataType:"text"
	},false)
	return TemporaryCardFlag
}
///��ȡ��̬д���HTML����
function GetPannelHTML(jsonData,LinkID){
	var Len=0;
	if (ServerObj.ParaRegType=="APP"){
		var ASRowId=jsonData["ASRowId"];
		var innerHTML="<table border='1' class='diytable' cellspacing='1' cellpadding='0'>";
		var CallFunction={};
		var Title=jsonData["MarkDesc"]+"("+jsonData['SessionTypeDesc']+") "+jsonData["ScheduleDate"];
		Title=Title+" �Һ���: "+jsonData['RegedCount']+" ԤԼ��: "+jsonData['AppedCount']+" ȡ����: "+jsonData['AppedArriveCount']+" �Ӻ���: "+jsonData['AddedCount'];
		var width=740,height=250;
		var warning = $.cm({
			ClassName:"web.DHCOPAdmReg",
			MethodName:"GetTimeRangeStrApp",
		    ASRowid:ASRowId,
		    AppMedthod:"WIN",
			dataType:"text"
		},false);
		warning=eval('(' + warning + ')');
		var MaxLen=7;MaxCol=0;
		Len=warning['row'].length;
		for (var i=0;i<Len;i++){
			//����ÿ�кŶ�Ϊ8��,����8���Զ����У���һ�и���ʱ�κ����Զ��ϲ���
			var TimeRange=warning['row'][i]['TimeRange'];
			var col=warning['row'][i]['col'];
			var rowspan=Math.ceil(col.length/MaxLen+1); 
			innerHTML=innerHTML+"<tr>";
			innerHTML=innerHTML+"<td class='td-timerange' rowspan='"+rowspan+"'>"+TimeRange+"</td>";
			var colNum=0
			for (var j=0;j<col.length;j++){
	            if (j%MaxLen==0) {
		            innerHTML=innerHTML+"<tr>";
		        }
				var SeqNo=col[j]['SeqNo'];
				var Time=col[j]['Time'];
				var Status=col[j]['Status'];
				if(Status==2){
					innerHTML=innerHTML+"<td class='td-seqno-invalid'>"+"<span class='td-seqno'>"+SeqNo+"</span><br><span class='td-time'>"+Time+"</span></td>";
				}else{
					innerHTML=innerHTML+"<td onmouseover=mouserover(this) onmouseout=mouserout(this) onclick=tdclick(this) ondblclick=dbtdclick(this) id='"+LinkID+"_table_"+SeqNo+"'>"+"<span class='td-seqno'>"+SeqNo+"</span><br><span class='td-time'>"+Time+"</span></td>";
				}
				innerHTML=innerHTML+"</td>";
				colNum=colNum+1;
				if (colNum==MaxLen) {
					innerHTML=innerHTML+"</tr>";
					colNum=0;
				}
				if (col.length>MaxCol) MaxCol=col.length;
			}
			innerHTML=innerHTML+"</tr>";
		}
		innerHTML=innerHTML+"</table>";
		if (Len==0){
			innerHTML="";
		}
		if (MaxCol<MaxLen){
			width=(85*MaxCol)+115;
		}
		var closeable=true
	}
	if ((Len==0)||(ServerObj.ParaRegType!="APP")){
		var Title="";
		var innerHTML="<table border='1' class='diytable' cellspacing='1' cellpadding='0'>";
		innerHTML=innerHTML+"<tr><td style='width:60px'>�Һ���</td><td style='width:50px'>"+jsonData['RegedCount']+"</td></tr>";
		innerHTML=innerHTML+"<tr><td>ԤԼ��</td><td>"+jsonData['AppedCount']+"</td></tr>";
		innerHTML=innerHTML+"<tr><td>ȡ����</td><td>"+jsonData['AppedArriveCount']+"</td></tr>";
		innerHTML=innerHTML+"<tr><td>�Ӻ���</td><td>"+jsonData['AddedCount']+"</td></tr>";	
		var width=150,height=121;
		var CallFunction="";
		var closeable=false;
	}
	return {
		"innerHTML":innerHTML,
		"CallFunction":CallFunction,
		"Title":Title,
		"width":width,
		"height":height,
		"closeable":closeable
	}
}

function SearchAppNoClickHandler(){
	setTimeout(function(){SearchAppNoChange();});
}
function SearchAppNoChange(){
	var o=$HUI.checkbox("#SearchAppNo");
	if (o.getValue()){
		var AppSerialNo=$("#AppSerialNo").val();
		if (AppSerialNo!=""){
			AppSerialNoBlurHandler();
		}else{
			var PatientID=$("#PatientID").val();
			if (PatientID!="") {
				GetApptInfo(PatientID);
			}
		}
	}
}
function AppSerialNoBlurHandler(e){
	//�õ��޿�ԤԼ��¼
	GetApptInfo("");
	return true;
}
function GetApptInfo(PatientID){
	var o=$HUI.checkbox("#SearchAppNo");
	if (o.getValue()){
		if (PageLogicObj.m_curDayRegListDataGrid===""){
			PageLogicObj.m_curDayRegListDataGrid=curDayRegListDataGrid();
		}else{
			ClearAllTableData("curDayRegList");
		}
		//ȡ���˵�ԤԼ��Ϣ
		$("#BillAmount").val("0.00")
		var AdmReason=""; //$('#BillType').combobox('getValue');
		var GetAppFlag=1;
		var rtn="";
		ClearAllTableData("selectedMarkList");
		var BillAmount=+$("#BillAmount").val();
		var RegConDisId="";
		
		//RegConDisId=$("#RegConDisList").combobox("getValue");
		if (PatientID=="") {
			var AppSerialNo=$("#AppSerialNo").val();
			var rtn=$.cm({
			    ClassName : "web.DHCRBAppointment",
			    MethodName : "GetAppInfoNoCard",
			    dataType:"text",
			    SystemSess:AppSerialNo, AdmReason:AdmReason,
			    LogonHospID:session['LOGON.HOSPID'],RegConDisId:RegConDisId,
			},false);
		}else{
			var rtn=$.cm({
			    ClassName : "web.DHCRBAppointment",
			    MethodName : "GetAppInfo",
			    dataType:"text",
			    PatientId:PatientID, AdmReason:AdmReason, LogonHospID:session['LOGON.HOSPID'],
			    RegConDisId:RegConDisId,
			},false);
		}
		if(rtn!=""){
		   //û��Ȩ����ʾ���Һ�ҽ����Ϣ
		    if(rtn.indexOf("NoAuthority")!=-1){
			  var tipSplit=rtn.split("NoAuthority");
			  if(tipSplit.length==2){
				  var tip=rtn.split("NoAuthority")[1];
				  if(tip=="CheckCardAssociation"){
					 $.messager.alert("��ʾ","�뻼�߳�ʾ�籣�������򱾴ξ�������޷�ҽ������!");
				  }else{
					$.messager.alert("��ʾ","û��ȡ��Ȩ��:"+tip);
				  }
				  rtn=rtn.split("NoAuthority")[0];
			  }
			  if(tipSplit.length==3){
				  var tip=rtn.split("NoAuthority")[1];
				  $.messager.alert("��ʾ","û��ȡ��Ȩ��:"+tip);
				  //alert("�뻼�߳�ʾ�籣�������򱾴ξ�������޷�ҽ������");
				  rtn=rtn.split("NoAuthority")[0];
			  }
			}
			if(rtn){
				var AppInfos=rtn.split(",")
				for(var i=0;i<AppInfos.length;i++){
					var AppInfo=AppInfos[i]
					var AppInfo1=AppInfo.split("^")
					var BillAmount=parseFloat(BillAmount)+parseFloat(AppInfo1[2]);
					var TAPPTRowID="";
					if (AppInfo1.length>=15){
						TAPPTRowID=AppInfo1[14];
					}
					if(ServerObj.ParaRegType!="APP"){
						var RepeatFlag=CheckRowDataRepeat("TAPPTRowID",TAPPTRowID);
						if (RepeatFlag==1) continue;
					}else{
						//var RepeatFlag=CheckAppRowDataRepeat("TAPPTRowID",TAPPTRowID);
						//if (RepeatFlag==1) continue;
					}
					AddRegToTable(AppInfo);
				}
			}
			$("#BillAmount").val(BillAmount);
		}
	}
}

function AddRegToTable(val) {
	try {
		var valueAry=val.split("^");
		var TabASRowId=valueAry[0];
		var TabMarkDesc=valueAry[1];
		var TabPrice=valueAry[2];
		var TabExamFee=valueAry[3];
		var TabHoliFee=valueAry[4];
		var TabAppFee=valueAry[5];
		var TabDepDesc=valueAry[6];
		var TabAppDate=valueAry[7];
		var TabSeqNo=valueAry[8];
		var TabReAdmFeeFlag=valueAry[9];
        //����ѡ���������  +20100629  guo
		var TabFreeRegFlag=valueAry[10];
		var TabFreeCheckFlag=valueAry[11];
		var TabTimeRange=valueAry[12];
		var TAPPTRowID=""
		if (valueAry.length>=15){
			TAPPTRowID=valueAry[14];
		}
		var PCLRowID=""
		if (valueAry.length>=16){
			PCLRowID=valueAry[15];
		}
		var dataObj=new Object();
		dataObj={
			TabASRowId:TabASRowId,
			DeptDesc:TabDepDesc,
			MarkDesc:TabMarkDesc,
			SeqNo:TabSeqNo,
			Price:TabPrice,
			AdmDate:TabAppDate,
			DeptRowId:"",
			TabPCLRowID:PCLRowID,
			TAPPTRowID:TAPPTRowID,
			AvailSeqNoStr:"",
			AvailAddSeqNoStr:"",
			HoliFee:TabHoliFee,
			ExamFee:TabExamFee,
			RegFee:"",
			AppFee:"",
			OtherFee:"",
			ReCheckFee:"",
			TabFreeRegFlag:TabFreeRegFlag,
			TabFreeCheckFlag:TabFreeCheckFlag,
			TabReAdmFeeFlag:TabReAdmFeeFlag,
			TabTimeRange:TabTimeRange
		}
		AddToSelectedMarkList(dataObj,false);
	} catch(e) {$.messager.alert("��ʾ",e.message)};
}

function CheckRowDataRepeat(CellName,ChecKValue) {
	var RepeatFlag=0;
	if (ChecKValue=="") return RepeatFlag;
	//�ж��ظ����������
	var Data=PageLogicObj.m_selectedMarkListDataGrid.datagrid("getData");
	for (var i = 0; i < Data["rows"].length; i++) { 
		var CellNameVal=Data["rows"][i][CellName];
		if (CellNameVal=="") continue;
		if (CellNameVal==ChecKValue) {
			RepeatFlag=1;
			break;
		}
	}
	return RepeatFlag;
}