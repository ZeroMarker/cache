var PageLogicObj={
	m_selectedMarkListDataGrid:"",
	m_curDayRegListDataGrid:"",
	m_curDayAppListDataGrid:"",
	m_MarkListDataGrid:"",
	m_PreCardNo:"",
	m_PreCardType:"",
	m_PreCardLeaving:"",
	m_deptRowId:"",
	m_DocRowId:"",
	CommonCardrow:"",
	m_IDCredTypePlate:"01", //���֤�����ֶ�
	dw:$(window).width()-200,
	dh:$(window).height()-80,
	m_TrShowFlag: 1,			// 1 ��ʾ����ʱ�Σ�0 ��ʾ����ʱ��
	m_ApptTypeCode:"WIN", 		// ԤԼ����
	m_MouseoverId: "",			// ��ǰ show popover �� mouseover id
	m_MarkPopoverTrigger:"click",			//��ʱ�θ�������չʾģʽ,click:���������hover:�������ʱ������ʹ��Ч����̫�ã�
	m_PopoverId: "",				// ��ǰ show popover �� id
	m_RegJumpFlag:""			//�Һ���ת��־
};
if (websys_isIE==true) {
	 var script = document.createElement('script');
	 script.type = 'text/javaScript';
	 script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird �ļ���ַ
	 document.getElementsByTagName('head')[0].appendChild(script);
}
$(function(){
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	//ҳ�����ݳ�ʼ��
	//Init();
	//�¼���ʼ��
	InitEvent();
});
function Init(){
	PageLogicObj.m_selectedMarkListDataGrid=InitselectedMarkListDataGrid();
	if (ServerObj.ParaRegType=="APP"){
		//��ԤԼ��¼
		PageLogicObj.m_curDayAppListDataGrid=curDayAppListDataGrid();
	}else{
		//�����ѹҺż�¼
		PageLogicObj.m_curDayRegListDataGrid=curDayRegListDataGrid();
	}
}
function PageHandle(){
	//ʱ���б�
	LoadTimeRange();
	//����
	LoadDeptList();
	//ҽ��
	LoadMarkCode();
	//֧����ʽ
	LoadPayMode();
	//�Ż�����
	LoadRegConDisList();
	//��Ʊ��ˮ��
	GetReceiptNo();
	InitReceiptCount();
	//������
	LoadClinicServiceGroup("");
	//ԤԼ����
	InitAppPatType();
	//֤������
	LoadCredType()
	setTimeout(function() { 
    	if (ServerObj.ParaRegType=="APP"){
			$("#SelDate").html(ServerObj.DefaultAppDate);
			$("#WeekDesc").html(ServerObj.DefaultAppWeek);
			$("#AppDate").datebox('setValue',ServerObj.DefaultAppDate);
			if (ServerObj.ChangePatientNo!=""){
				$("#PatientNo").val(ServerObj.ChangePatientNo);
				CheckPatientNo();
			}
			if (ServerObj.ChangeOtherInfo!=""){
				var OtherInfoAry=ServerObj.ChangeOtherInfo.split("^")
				$('#AppPatCredNo').val(OtherInfoAry[1]);
				$('#AppPatName').val(OtherInfoAry[0]);
				$('#AppPatTel').val(OtherInfoAry[2]);
				$('#AppPatAddress').val(OtherInfoAry[3]);
				if (OtherInfoAry[4]!="") $('#AppPatType').combobox('setValue',OtherInfoAry[4]);
				if (OtherInfoAry[5]!="") $('#AppPatCredType').combobox('setValue',OtherInfoAry[5].replace("$","^"));
			}
		}else{
			$("#SelDate").html(ServerObj.CurDate);
			$("#WeekDesc").html(ServerObj.CurWeek);
		}
    },600);
	setTimeout(function() { 
		var frm = dhcsys_getmenuform();
		if (frm) {	
	    	var PatientID = frm.PatientID.value;
			frm.PatientID.value="";
	    	if ((typeof PatientID != "undefined") && (PatientID != "")) {
		    	PageLogicObj.m_RegJumpFlag="Y"
				var RegNo=$.cm({
					ClassName:"web.DHCOPAdmReg",
					MethodName:"GetPatNoByID",
					dataType:"text",
					PAPMIDR:PatientID
				},false);
		    	$("#PatientNo").val(RegNo);
				CheckPatientNo();
	    	}else {
		    	PageLogicObj.m_RegJumpFlag=""	
	    	}
	    }
    },600);
	$('#CardNo').focus();
	var $btntext=$("#MarkListShowMode .l-btn-text")[0];
	if (ServerObj.OPRegListDefault==1){
		$btntext.innerText="��ͼģʽ";
		var url="opadm.reg.marktable.hui.csp";
	}else{
		$btntext.innerText="�б�ģʽ";
		var url="opadm.reg.markcard.hui.csp";
		$("#MarkListPanel").removeClass('panel-noscroll');
	}
    url=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(url):url;
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
	//ע�Ὠ��
	$("#BRegExp").click(function(){BRegExpClickHandle("")});
	//����ֵ
	$("#BCardRecharge").click(BCardRechargeHandle);
	//�˺�
	$("#BCacelReg").click(function(){BCacelRegHandle("")});
	//�޸Ļ��߻�����Ϣ
	$("#BUpdatePatInfo").click(BUpdatePatInfoHandle);
	//��ѯ����
	$("#BFindPat").click(BFindPatHandle);
	//����
	$("#BClear").click(BClearHandle);
	//���߻�����Ϣչ��/����
	$("#BPatInfoCollaps").click(BPatInfoCollapsHandle);
	$("#BReadCard").click(ReadCardClickHandler);
	//ʵ��
	$("#PaySum").keydown(PaySumKeydown);
	$("#PaySum").keypress(PaySumKeyPress);
	$("#PaySum").blur(ReCalculateAmount);
	//�Һ�
	$("#Update").click(UpdateClickHandler);
	$("#Find").click(function(){LoadMarkList()});
	$("#CloseDeptTreeDiv").click(function(){
		$("#DeptTreeList-div").hide();
	});
	//ԤԼ
	$("#Appoint").click(AppointClickHandler);
	$("#PreAppDay").click(PreAppDayClickHandler);
	$("#NextAppDay").click(NextAppDayClickHandler);
	$("#AllAppDays").click(AllAppDaysClickHandler);
	$("#BeforeWeekAppDay").click(function(){ChangeWeekAppDayClickHandler("Before");});
	$("#ThisWeekAppDay").click(function(){ChangeWeekAppDayClickHandler("Now");});
	$("#NextWeekAppDay").click(function(){ChangeWeekAppDayClickHandler("Next");});
	$("#DeptTreeList").click(DeptTreeListClickHandle);
	$("#MarkListShowMode").click(MarkListShowModeClickHandle);
	$("#DeptList").change(DeptListChangeHanlde);
	/*$("#AppDate").prev().prev().blur(function(){
		debugger;
	})*/
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
    if(keyCode==120) { 
		if ($("#Update").length>0){
			UpdateClickHandler();
		}
		if ($("#Appoint").length>0){
			AppointClickHandler();
		}
	}
	if (document.activeElement.parentElement.id=="MarkListPanel"){
		var FroceRow=""
		if ((keyCode==49)||(keyCode==97)) FroceRow=0
		if ((keyCode==50)||(keyCode==98)) FroceRow=1
		if ((keyCode==51)||(keyCode==99)) FroceRow=2
		if ((keyCode==52)||(keyCode==100)) FroceRow=3
		if ((keyCode==53)||(keyCode==101)) FroceRow=4
		if ((keyCode==54)||(keyCode==102)) FroceRow=5
		if ((keyCode==55)||(keyCode==103)) FroceRow=6
		if ((keyCode==56)||(keyCode==104)) FroceRow=7
		if ((keyCode==57)||(keyCode==105)) FroceRow=8
		if (FroceRow!==""){
			var $btntext=$("#MarkListShowMode .l-btn-text")[0];
			var text=$btntext.innerText;
			if (text.indexOf("��ͼ")>=0){
				var gridData=PageLogicObj.m_MarkListDataGrid.datagrid('getRows');
				if (FroceRow < gridData.length){
					PageLogicObj.m_MarkListDataGrid.datagrid('selectRow', FroceRow);
				}
			}
		}
	}
	/*
	if (keyCode==115){ //F4
		ReadCardClickHandler();
	}else if (keyCode==117) { 
		BUpdatePatInfoHandle();
	}else if(keyCode==118) { 
		BClearHandle();
	}else if(keyCode==119) { 
		//BFindPatHandle();
		LoadMarkList();
	}else if(keyCode==120) { 
		if ($("#Update").length>0){
			UpdateClickHandler();
		}
		if ($("#Appoint").length>0){
			AppointClickHandler();
		}
	}else if(keyCode==121){ 
		BCacelRegHandle("");
  	}else if(keyCode==113){
		BRegExpClickHandle();
		return false;
	}*/
	var selCardIndex="";
	var $markcard=$(".markcard-select");
	if ($markcard.length>0){
		selCardIndex=$markcard[0]["id"].split("-")[0];
	}
	if (keyCode==37){
		//��
		var nextIndex=parseInt(selCardIndex)-1;
		if (isNaN(nextIndex)||(nextIndex<0)) return true
		if (selCardIndex!=""){
			$(".markcard-select").removeClass("markcard-select");
			$("#"+nextIndex+"-marklist-card").addClass("markcard-select");
			SetMarkCardFocus(nextIndex+"-marklist-card");
		}
	}else if(keyCode==38){
		if (document.activeElement.tagName=="INPUT"){
			return false;
		}
		//��
		var width=$("#MarkListPanel").width();
		var RowNumber=Math.floor(width/200);
		var nextIndex=parseInt(selCardIndex)-parseInt(RowNumber);
		if (isNaN(nextIndex)||(nextIndex<0)) return true;
		$(".markcard-select").removeClass("markcard-select");
		$("#"+nextIndex+"-marklist-card").addClass("markcard-select");
		SetMarkCardFocus(nextIndex+"-marklist-card");
	}else if(keyCode==39){
		//��
		var nextIndex=parseInt(selCardIndex)+1;
		if (isNaN(nextIndex)||(nextIndex<0)) return true
		if (nextIndex>=($(".marklist-card").length)-1) return true;
		$(".markcard-select").removeClass("markcard-select");
		$("#"+nextIndex+"-marklist-card").addClass("markcard-select");
		SetMarkCardFocus(nextIndex+"-marklist-card");
		
	}else if(keyCode==40){
		if (document.activeElement.tagName=="INPUT"){
			return false;
		}
		//��
		var width=$("#MarkListPanel").width();
		var RowNumber=Math.floor(width/200);
		var nextIndex=parseInt(selCardIndex)+parseInt(RowNumber);
		if (isNaN(nextIndex)||(nextIndex<0)) return true
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
function curDayAppListDataGrid(){
	var Columns=[[ 
		{field:'Operation',title:'����',width:50,
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="CancelApp(\'' + row["TAPPTRowID"] + '\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"/></a>';
				return btn;
			}
		},
		{field:'TabDeptDesc',title:'����',width:140},
		{field:'TabMarkDesc',title:'�ű�',width:140},
		{field:'TabSeqNo',title:'���',width:50},
		{field:'TabPrice',title:'�۸�',width:50},
		{field:'TabAppDate',title:'��������',width:100},
		{field:'TAPPTRowID',title:'',hidden:true},
    ]]
	var curDayAppListDataGrid=$("#curDayAppList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:false,
		pagination : false,  
		idField:'TAPPTRowID',
		columns :Columns,
		onDblClickRow:function(index, row){
			//DelSelMarkListRow(row);
		}
	}); 
	return curDayAppListDataGrid;
}
function InitselectedMarkListDataGrid(){
	var Columns=[[ 
		{field:'Operation',title:'����',width:50,
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="DelSelMarkListRowByABRS(\'' + row['TabASRowId'] + '\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"/></a>';
				return btn;
			}
		},
		{field:'TabASRowId',hidden:true,title:''},
		{field:'TabDeptDesc',title:'����',width:140,styler:function(value,row,index){
			return "font-weight:bold;"
		}},
		{field:'TabMarkDesc',title:'ҽ��',width:140,
			formatter: function(value,row,index){
				var btn = value
				if ((row.TabClinicGroupDesc!="")&&(row.TabClinicGroupDr!="")&&(btn.indexOf(row.TabClinicGroupDesc)<0)) btn=btn+"<span style='color:red'>("+row.TabClinicGroupDesc+")</span>"
				return btn;
			},
			styler:function(value,row,index){
			return "font-weight:bold;"
		}},
		{field:'TabTimeRange',title:'ʱ��',width:100,styler:function(value,row,index){
			return "font-weight:bold;"
		}},
		{field:'TabAppDate',title:'��������',width:100},
		{field:'TabPrice',title:'�۸�',width:50},
		{field:'TabSeqNo',title:'���',width:50},
		{field:'TabClinicGroupDesc',title:'רҵ��',width:80},
		{field:'TabClinicGroupDr',title:'ClinicGroupDr',width:80,hidden:true},
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
function DelSelMarkListRow(){
	var row=PageLogicObj.m_selectedMarkListDataGrid.datagrid('getSelected');
	var BillAmount=$("#BillAmount").val();
	if (BillAmount!="") {
		BillAmount=parseFloat(BillAmount)-parseFloat(row["TabPrice"]);
		BillAmount=BillAmount.toFixed(2);
		var index=PageLogicObj.m_selectedMarkListDataGrid.datagrid('getRowIndex',row);
		PageLogicObj.m_selectedMarkListDataGrid.datagrid('deleteRow',index);
		$("#BillAmount").val(BillAmount);
		ReCalculateAmount();
	}
}
function DelSelMarkListRowByABRS(ASRowId){
	var index=PageLogicObj.m_selectedMarkListDataGrid.datagrid('getRowIndex',ASRowId);
	PageLogicObj.m_selectedMarkListDataGrid.datagrid('selectRow',index);
	DelSelMarkListRow();
}
function curDayRegListDataGrid(){
	var Columns=[[ 
		{field:'PatDr',title:'����',width:50,
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="BCacelRegHandle(\'' + row["AdmId"] + '\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"/></a>';
				return btn;
			}
		},
		{field:'AdmId',hidden:true,title:''},
		{field:'Dept',title:'����',width:140},
		{field:'Doctor',title:'�ű�',width:100},
		{field:'Tph',title:'���',width:80},
		{field:'RegfeeDate',title:'�Һ�����',width:120},
		{field:'UserName',title:'����Ա',width:80}
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
/*
�������
ҽ��������ɫ 			����Ű�
ҽ�������ɫ 			�����Ű�
ҽ�������ɫ��б�� 		�����Ű��Һ��ѹ���
�б���ɫ��ɫ 			��ͣ��
*/
function MarkListDataGrid(){
	var Columns=[[ 
		{field:'ASRowId',hidden:true,title:''},
		{field:'ClinicGroupDr',hidden:true,title:''},
		{field:'MarkDesc',title:'ҽ��',width:210,
			formatter: function(value,row,index){
				var btn = value
				if ((row.ClinicGroupDr!="")&&(row.ClinicGroupDesc!="")) {btn=value+"<span style='color:red'>("+row.ClinicGroupDesc+")</span>"}
				if ((row.ClinicGroupDr!="")&&(row.ClinicGroupDesc!="")&&(row.ScheduleStatus=="ͣ��")) {btn=value+"<span style='color:#ffffff'>("+row.ClinicGroupDesc+")</span>"}
				return btn;
			},
			styler: function(value,row,index){
				if ((+row["AvailSeqNoStr"]==0)&&(+row["AvailAddSeqNoStr"]==0)&&(ServerObj.SeqNoMode=='')){
					return 'color: red;';
				}else if(row["NoLimitLoadFlag"]=="Y"){
					return 'color: green;';
				}
			}
		},
		{field:'DepDesc',title:'����',width:120},
		{field:'SessionTypeDesc',title:'�Һ�ְ��',width:80},
		{field:'AvailSeqNoStr',title:'ʣ��',width:80},
		{field:'RegedCount',title:'�ѹҺ���',width:80},
		{field:'AppedCount',title:'��ԤԼ��',width:80},
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
		{field:'AppedArriveCount',title:'��ȡ����',width:80},
		{field:'AvailNorSeqNoStr',title:'�ֳ�ʣ��',width:80},
		{field:'ClinicGroupDesc',title:'רҵ��',width:80},
		{field:'HoliFee',title:'���շ�',width:70},
		{field:'AppFeeDr',title:'������',width:70,hidden:true}, //OtherFeeԭ��ȡ���ֶ���AppFeeDr��
		{field:'ReCheckFee',title:'�����',width:70},
		{field:'BorghAlertInfo',title:'��ʾ��Ϣ',width:80,showTip:true}, //RoomCode
		{field:'RoomDesc',title:'����',width:80},
		{field:'ScheduleDateWeek',title:'����',width:80},
		{field:'ScheduleStatus',title:'�Ű�״̬',width:80},
		{field:'AdmWaitSum',title:'��ǰ��������',width:95},
		{field:'NoLimitLoadFlag',title:'����Ű��ʶ',hidden:true},
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
		idField:'ID',
		rownumbers:true,
		columns :Columns,
		rowStyler: function(index,row){
			if (row["ScheduleStatus"]=="ͣ��"){
				return 'background-color:red;'
			}
			var AvailSeqNoStr=+row["AvailSeqNoStr"];
			var AvailAddSeqNoStr=+row["AvailAddSeqNoStr"];
			var AvailNorSeqNoStr=+row["AvailNorSeqNoStr"]
			if ((AvailSeqNoStr==0)&&(AvailAddSeqNoStr==0)&&(ServerObj.SeqNoMode=='')){
				return 'font-style: italic;';
			}
			if ((AvailSeqNoStr==0)&&(ServerObj.ParaRegType=="APP")&&(ServerObj.SeqNoMode=='')){
				return 'font-style: italic;';
			}
			if ((AvailNorSeqNoStr==0)&&(ServerObj.SeqNoMode=='1')){
				return 'font-style: italic;';
			}
		},
		onDblClickRow:function(index, row){
			MarkListDBClick(row);
		},
		onSelect:function(index, row){
			if (ServerObj.ParaRegType=="APP"){
				$("#SelDate").html(row.ScheduleDate);
				$("#WeekDesc").html(row.ScheduleDateWeek);
			}
			if (PageLogicObj.m_MarkPopoverTrigger=="click"){
				DestoryPannelPopover();
				try{
					InitMarkListRowPopover({rowIndex:index,markCardID:"",Show:true})
				}catch(e){}
			}
			
		},
		onLoadSuccess:function(data){
			if(data["rows"].length>0){
				//Ĭ��ѡ�е�һ��
				$(this).datagrid('selectRow', 0);  
				//���ý���,������ѡ�е�һ�к�����������¼��¼�
				$("#MarkList").datagrid('getPanel').panel('panel').focus();
			}
			if (PageLogicObj.m_MarkPopoverTrigger=="hover"){
				//��껬������������
				InitMarkListRowMouseHandle();
			}
		}
	}).datagrid("keyCtr"); 
	return MarkListDataGrid;
}
// ��ʼ���е���긡���¼�������չʾ��ʱ�λ�Һ�������Ϣ
function InitMarkListRowMouseHandle() {
	if ((ServerObj.ParaRegType!="APP")&&(ServerObj.OPRegistShowTimeRange!="1")){
		return false;
	}
	
	var _datagridRow=$("#MarkList").datagrid("options").finder.getTr($("#MarkList")[0],"","allbody",2)
	_datagridRow.mouseover(function(e,value){
		DestoryPannelPopover();
		var _rowIndex=parseInt($(this).attr("datagrid-row-index"));
		InitMarkListRowPopover({rowIndex:_rowIndex,markCardID:"",Show:true});
	}).mouseout(function(value){
		//��������������ݵĻ�ȡ��mouseover��ʵ������
		//$(this).popover('hide');
	});
	if (PageLogicObj.m_MouseoverId != "") {
		// �л� popover switch ��ťʱ���ֶ����� mouseover
		$("#" + PageLogicObj.m_MouseoverId).mouseover()
	}
	
}
/// �����б�\��Ƭģʽ�������������е���
function DestoryPannelPopover(){
	try{$("#switch-btn").tooltip("destroy");}catch(e){}
	//�б�ģʽ�µĵ���
	try{
		var _datagridRow=$("#MarkList").datagrid("options").finder.getTr($("#MarkList")[0],"","allbody",2);
		_datagridRow.each(function(index,obj){
			var popoverID=$(obj).attr("id");
			try{
				//$("#"+popoverID).popover("hide");
				$("#"+popoverID).popover("destroy");
			}catch(e){}
		})
	}catch(e){}
	try{
		$("[id$=-marklist-card]").each(function(index,obj){
			var popoverID=$(obj).attr("id");
			try{
				//$("#"+popoverID).popover("hide");
				$("#"+popoverID).popover("destroy");
			}catch(e){}
		})
	}catch(e){}
}
// ��ʼ���б�\��Ƭģʽ�ĸ�����
function InitMarkListRowPopover(param) {
	var rowIndex=param.rowIndex;
	var markCardID=param.markCardID;
	var Show=param.Show;		//������ʾ
	if ((rowIndex!=="")){
		//�б�ģʽ
		var popoverID=$("#MarkList").datagrid("options").finder.getTr($("#MarkList")[0],rowIndex,"body",2).attr("id");
		var jsonData=$("#MarkList").datagrid("options").finder.getRow($("#MarkList")[0], rowIndex);
		if (!jsonData){ return false; }
		var MarkListShowMode="�б�";
		$("#MarkList").datagrid('getPanel').panel('panel').focus();	//��ֹ��ʧ��񽹵�
	}else if (markCardID!=""){
		//��Ƭģʽ
		var popoverID=markCardID;
		var dataStr=$($("#"+markCardID).find("div")[8]).html();
		var jsonData=JSON.parse(dataStr);
		var MarkListShowMode="��ͼ";
		$("#"+markCardID).parent().focus();
	}else{
		return false;
	}
	//������Ը������ݵ���������
	var HTML=GetPannelHTML(jsonData,popoverID);
	if (HTML.innerHTML==""){return;}
	
	$("#"+popoverID).popover({
		width:HTML.width,
		height:HTML.height,
		title:HTML.Title,
		content:HTML.innerHTML,
		closeable:HTML.closeable,
		trigger:'manual',
		placement:'auto', 
		container:MarkListShowMode=="��ͼ"?$("body"):$("#MarkInfoPanel"),
		cache:false,
		onShow:function(){
			if (MarkListShowMode=="�б�"){
				if (HTML.closeable) {
					$(".webui-popover").css({
						'left':'250px'
					});
				}else{
					$(".webui-popover").css({
						//'left':'700px'
						'left':'470px'
					});
				}
			}
			if (typeof HTML.CallFunction == "function"){
				HTML.CallFunction.call();
			}
			var curPopoverId = $("#"+this.id).attr("data-target")
			$.parser.parse($("#switch-btn").parent())
			
			PageLogicObj.m_PopoverId = curPopoverId
			PageLogicObj.m_MouseoverId = this.id
		},
		onHide: function(e, value) {
			PageLogicObj.m_MouseoverId = ""
		}
	});
	if (Show){
		$("#"+popoverID).popover("show");
	}
}
function MarkListDBClick(row){
	var dataObj=new Object();
	var MarkDesc=row["MarkDesc"]
	if (row["ClinicGroupDesc"]!="" && row["ClinicGroupDr"]!=""){var MarkDesc=row["MarkDesc"]+"<span style='color:red'>("+row["ClinicGroupDesc"]+")</span>"}
	dataObj={
		TabASRowId:row["ASRowId"],
		DeptDesc:row["DepDesc"],
		MarkDesc:MarkDesc,
		SeqNo:row['SeqNo'],
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
		ReCheckFee:row["ReCheckFee"],
		TabFreeRegFlag:"",
		TabFreeCheckFlag:"",
		TabReAdmFeeFlag:"",
		TabTimeRange:row["TimeRange"],
		StopRegFlag:row["StopRegFlag"],
		TabClinicGroupDesc:row["ClinicGroupDesc"],
		TabClinicGroupDr:row["ClinicGroupDr"],
		CurrentMarkDesc:row["MarkDesc"]
	}
	PageLogicObj.CommonCardrow=row
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
		TabExamFee: dataObj["ExamFee"],
		TabTimeRange:dataObj["TabTimeRange"],
		TabClinicGroupDesc:dataObj["TabClinicGroupDesc"],
		TabClinicGroupDr:dataObj["TabClinicGroupDr"]
	});
	if (alertFlag) {
		$.messager.popover({msg: '����ӵ��ű��б�!',type:'success',timeout: 2000});
	}
	// DTS�������-ѡ���Դ
	DTSLog.AddOnelog("1635895983521009664",PatientID,PatientID,"",session['LOGON.USERCODE'])
}
var m_ReadCardMode="";
var m_CCMRowID="";
function UpdateClickHandler(){
	// ��ֹ���ٵ���ظ��Һ�
	if ($("#Update").hasClass('l-btn-disabled')){
		return false;
	}
	$("#Update").addClass('l-btn-disabled')
	//��ʼ����ӡģ��--�����ӡ��Ʊ��ˢ��ģ�����³�ʼ��
	if (ServerObj.ParaRegType!="APP"){
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAdmRegPrint");
	}
	var NeedDelIndexArr=new Array();
	var Data=PageLogicObj.m_selectedMarkListDataGrid.datagrid("getData");
	if (Data["rows"].length==0){
		$.messager.alert("��ʾ","û��ѡ��Һ���Ϣ!");
		$("#Update").removeClass('l-btn-disabled')
		return false;
	}
	var BillAmount=$('#BillAmount').val(); 
	var CardTypeRowID=$("#CardTypeRowID").val();
	var CardNo=$('#CardNo').val(); 
	//�ʻ�RowId
	var AccRowId=""; 
	var PayModeCode=GetPayModeCode();
	if (PayModeCode=="") {
		$.messager.alert("��ʾ","��ѡ��֧����ʽ!");
		$("#Update").removeClass('l-btn-disabled')
		return false;
	}
	//����ԤԼ�Ƿ�ҪԤ�ȷ����,ȡ�ŵĴ�����ͬһ������
	var PatientID=$('#PatientID').val();
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];
	var LocID=session['LOGON.CTLOCID'];
	var AdmReason=$('#BillType').combobox('getValue');
	if (AdmReason=="") {
		$.messager.alert("��ʾ","�ѱ�Ϊ��,��ѡ���߷ѱ�!");
		$("#Update").removeClass('l-btn-disabled')
		return false;
	}
	var AdmType="" //DHCC_GetElementData('AdmType');
	var RegConDisId=$("#RegConDisList").combobox('getValue');
	var DiagnosCatRowId="";
	var RemoveRows=""
	var UseInsuFlag="N",InsuReadCardInfo=""
	var LoopDataObj={};
	var ETPRowID="";
	var RegExpStr=CardTypeRowID+"^"+CardNo
	//var EnableInsuBillFlag=IsEnableInsuBill(PatientID,Data["rows"][0].TabASRowId,UseInsuFlag,AdmReason,InsuReadCardInfo);
	try{
		new Promise(function(resolve,rejected){
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
				(function(callBackFun){
					new Promise(function(resolve,rejected){
						DHCACC_CheckMCFPay(BillAmount,CardNo,"",CardTypeRowID,"",resolve);
					}).then(function(ren){
						var myary=ren.split("^");
						if (myary[0]!='0'){
							if (myary[0]=='-204'){
								$.messager.alert("��ʾ","���û����˻�������,���ܰ���֧��,���ҹ���Ա����!")
								$("#Update").removeClass('l-btn-disabled')
								return false;
							}else if (myary[0]=='-205'){
								var ret=ChangePayMode();
								if(!ret){
									$("#Update").removeClass('l-btn-disabled')
									return false;	
								}
								PayModeCode=GetPayModeCode();
							}else if (myary[0]=='-206'){
								$.messager.alert("��ʾ","�����벻һ��,��ʹ��ԭ��!")
								$("#Update").removeClass('l-btn-disabled')
								return false;
							}else if(myary[0]=='-201'){
								$.messager.alert("��ʾ","�û��߲�������Ч�˻�������ʹ��Ԥ����֧��!")
								$("#Update").removeClass('l-btn-disabled')
								return false;
							}
						}else{
							AccRowId=myary[1];
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
						callBackFun();
					})
				})(resolve);
			}else{
				resolve();
			}
		}).then(function(){
			return new Promise(function(resolve,rejected){
				//��ʵ�ս��С��Ӧ�ս�����Һ�,������
				var CFNotNullRealAmount=GetDHCOPRegConfig("NotNullRealAmount");
				if (CFNotNullRealAmount==1) {
					var EnableInsuBillFlag=false;
					for (var j=0;j<Data["rows"].length;j++) {
						EnableInsuBillFlag=IsEnableInsuBill(PatientID,Data["rows"][j].TabASRowId,UseInsuFlag,AdmReason,InsuReadCardInfo);
						if (EnableInsuBillFlag==true) break;
					}
					if (EnableInsuBillFlag==false) {
						var GetAmountPrice=$('#PaySum').val();
						if (GetAmountPrice==""){GetAmountPrice=0} 
						if ((PayModeCode=='CASH')&((parseFloat(GetAmountPrice))<BillAmount)){
							$.messager.alert("��ʾ","ʵ�ս��С��Ӧ�ս��!","info",function(){
								$('#PaySum').focus();
							});
							$("#Update").removeClass('l-btn-disabled')
							return false;
						}
						if ((parseFloat(GetAmountPrice)=="0")&(PayModeCode=="CASH")){
							$.messager.confirm('ȷ�϶Ի���', "ʵ�ս��Ϊ���Ƿ�����Ҵ˺�?", function(r){
								if (!r) {
									$("#GetAmount").focus(); 
									$("#Update").removeClass('l-btn-disabled')
									return false;
								}
								resolve();
							});
							return;
						}
					}
				}
				resolve();
			})
		}).then(function(){
			return new Promise(function(resolve,rejected){
				(function(callBackFun){
					function loop(j){
						new Promise(function(resolve,rejected){
							var TabPrice=Data["rows"][j]["TabPrice"];
							var TabExamFee=Data["rows"][j]["TabExamFee"]; 
							var TabHoliFee=Data["rows"][j]["TabHoliFee"]; 
							var TabAppFee=Data["rows"][j]["TabAppFee"];  
							var TabQueueNo=Data["rows"][j]["TabSeqNo"];
							if (!TabQueueNo) TabQueueNo="";
							var TabReAdmFeeFlag=Data["rows"][j]["TabReAdmFeeFlag"];
							RegExpStr=CardTypeRowID+"^"+CardNo+"^"+Data["rows"][j]["TabClinicGroupDr"]+"^"+PageLogicObj.m_ApptTypeCode;
							//�Ƿ񴫲�����
							var TabMRFee="0";
							//������������ȡ1��
							var o=$HUI.checkbox('#MedicalBook');
							if ((o.getValue())&&(j==0)){
								TabMRFee="1";
								TabPrice=parseFloat(TabPrice)+parseFloat(ServerObj.MRNoteFee);
							}
							//var TabCardFee=$("#NeedCardFee").checkbox('getValue')?1:0;
							var TabCardFee=0;
							var o=$HUI.checkbox('#NeedCardFee');
							if ((o.getValue())&&(j==0)){
								TabCardFee="1";
								TabPrice=parseFloat(TabPrice)+parseFloat(ServerObj.CardFee);
							}
							//���Ϊ����,��������,���������ô������ֵ
							var TabReCheckFee=0;
							if ((TabReAdmFeeFlag==1)&&((TabExamFee!="")&&(TabExamFee!=0))){		
								TabReCheckFee=TabExamFee;
								TabExamFee=0;
							}
							var TimeRangeStr=Data["rows"][j]["TabTimeRange"];
							LoopDataObj={
								TabPrice:TabPrice,
								TabASRowId:Data["rows"][j]["TabASRowId"], 
								//��ʱ�����ѿ����Ǹ�������
								TabExamFee:TabExamFee,
								TabHoliFee:TabHoliFee,
								TabAppFee:TabAppFee, 
								TabQueueNo:TabQueueNo,
								AppDate:Data["rows"][j]["TabAppDate"],
								TabReAdmFeeFlag:Data["rows"][j]["TabReAdmFeeFlag"],
								//�����ϴ���������ҺŷѺ������ѱ��
								TabFreeRegFlag:Data["rows"][j]["TabFreeRegFlag"],
								TabFreeCheckFlag:Data["rows"][j]["TabFreeCheckFlag"],
								//ԤԼID
								TAPPTRowID:Data["rows"][j]["TAPPTRowID"],
								//����ּ���
								TabPCLRowID:Data["rows"][j]["TabPCLRowID"],
								TabMRFee:TabMRFee,
								TabCardFee:TabCardFee,
							    BLNo:0,     //�Ƿ񴫲����ű�־?0����������?1��������
								FeeStr:TabPrice+"||"+TabExamFee+"||"+TabHoliFee+"||"+TabAppFee+"||"+TabMRFee+"||"+TabReCheckFee+"||"+TabCardFee,
								TimeRangeStr:TimeRangeStr
							}
							//ҽ��ʵʱ����
							var InsuJoinStr="";
							var InsuAdmInfoDr="",InsuDivDr="";
							var InsuPayFeeStr="";
							var UseInsuFlag="N",UPatientName="",RegType="",FreeRegFeeFlag="",InsuReadCardInfo="",RetInsuGSInfo="";
							$.extend(LoopDataObj, { InsuJoinStr: InsuJoinStr,InsuAdmInfoDr:InsuAdmInfoDr});
							//��ʼ�Һ�ǰ�������Ų������ݲ��ж��Ƿ�����쳣����
							//����
							var PatientNo=$('#PatientNo').val();
							var OPRegLockInfo=LoopDataObj.TabASRowId+"^"+LoopDataObj.TabQueueNo+"^"+UserID+"^"+"Y"+"^"+PatientNo;
							/*var CTLSRowId=$.cm({
								ClassName:"web.DHCOPAdmReg",
								MethodName:"OPRegLockSepNo",
								dataType:"text",
								LockSepNoInfo:OPRegLockInfo
							},false);
							if (CTLSRowId<0){
								$.messager.alert("��ʾ","����ʧ��!");
								return false;
							}*/
							var EnableInsuBillFlag=IsEnableInsuBill(PatientID,LoopDataObj.TabASRowId,UseInsuFlag,AdmReason,InsuReadCardInfo)
							if (EnableInsuBillFlag==true) {
								var InsuBillParamsObj={};
								InsuBillParamsObj.PatientID=PatientID;
								InsuBillParamsObj.UPatientName=UPatientName;
								InsuBillParamsObj.UserID=UserID;
								InsuBillParamsObj.ASRowId=LoopDataObj.TabASRowId;
								InsuBillParamsObj.AdmReasonId=AdmReason;
								//[��ѡ]�Һ���֯�ķ��ô���Ĭ��Ϊ"1||1||||||||"
								InsuBillParamsObj.FeeStr=LoopDataObj.FeeStr;
								//[��ѡ]�Һ����Ĭ��Ϊ��
								InsuBillParamsObj.RegType=RegType;
								//[��ѡ]�Һŷ���ѱ�ʶ��Ĭ��Ϊ��
								InsuBillParamsObj.FreeRegFeeFlag=LoopDataObj.FreeRegFeeFlag;
								//[��ѡ]��ҽ����������Ϣ��Ĭ��Ϊ��
								InsuBillParamsObj.InsuReadCardInfo=InsuReadCardInfo;
								//[��ѡ]����ҽ����Ϣ��Ĭ��Ϊ��
								InsuBillParamsObj.RetInsuGSInfo=RetInsuGSInfo;
								//�˻�ID
								InsuBillParamsObj.AccRowId=AccRowId;
								//�����Ը�֧����ʽ����
								InsuBillParamsObj.PayModeCode=PayModeCode;
								InsuJoinStr=CallInsuBill(InsuBillParamsObj);
								$.extend(LoopDataObj, { InsuJoinStr: InsuJoinStr});
								if (InsuJoinStr!="") {
									var myAry=InsuJoinStr.split("^");
									var ConFlag=myAry[0];
									if (ConFlag==0){
										InsuAdmInfoDr=myAry[1];
										InsuDivDr=myAry[2];
										InsuPayFeeStr=InsuJoinStr.split("!")[1];
										$.extend(LoopDataObj, { InsuAdmInfoDr: InsuAdmInfoDr});
									}else{
										//ҽ���Һ�ʧ�ܽ���
										/*var ret=$.cm({
											ClassName:"web.DHCOPAdmReg",
											MethodName:"OPRegUnLockSepNo",
											dataType:"text",
											CTLSRowId:CTLSRowId
										},false);*/
										var row=PageLogicObj.m_selectedMarkListDataGrid.datagrid('getRows')[j];
										var delTabPrice=row["TabPrice"];
										PageLogicObj.m_selectedMarkListDataGrid.datagrid('deleteRow',j);
										// ɾ�������¼���ϼƽ��
										var BillAmount=$("#BillAmount").val();
										BillAmount=parseFloat(BillAmount)-parseFloat(delTabPrice);
										BillAmount=BillAmount.toFixed(2);
										$("#BillAmount").val(BillAmount);
										ReCalculateAmount();
										$("#Update").removeClass('l-btn-disabled')
										return false;
									}
						
									if (InsuPayFeeStr!=""){
										var InsuTotalAmount=GetInsuTotalAmount(InsuPayFeeStr);
										var TotalAmount=InsuTotalAmount.split("^")[0];
										var CashFee=InsuTotalAmount.split("^")[1];
										if(parseFloat(TotalAmount)!=parseFloat(TabPrice)){
											//$.messager.alert("��ʾ","��ǰ�۸���ʵʱ�����ϴ��ܼ۸�һ��?��ȷ��ҽ���۸�!");
											//return false;
										}
									}
								}
							}
							//���������׽ӿڲ���
							RegPayObj.RegPay(TabPrice,PatientID,"",LoopDataObj.InsuJoinStr,"","","","","","","OP",resolve)
						}).then(function(rtnPay){
							return new Promise(function(resolve,rejected){
								PayModeCode=RegPayObj.PayModeCode;
								if (!rtnPay){
									//����ʧ�������ҽ������Ҫ����
									ReturnInsuOPReg(PatientID,LoopDataObj.InsuAdmInfoDr,LoopDataObj.TabASRowId,AdmReason)
									$("#Update").removeClass('l-btn-disabled')
									return false;
								}
								if ((typeof RegPayObj.PayRtnJsonObj!="undefined")&&(typeof RegPayObj.PayRtnJsonObj.ETPRowID!="undefined")&&(RegPayObj.PayRtnJsonObj.ETPRowID!="")) {
									ETPRowID=RegPayObj.PayRtnJsonObj.ETPRowID;
								}
								resolve();
							})
						}).then(function(){
							return new Promise(function(resolve,rejected){
								var ret=$.cm({
									ClassName:"web.DHCOPAdmReg",
									MethodName:"OPRegistBroker",
									dataType:"text",
									PatientID:PatientID, ASRowId:LoopDataObj.TabASRowId, AdmReason:AdmReason, QueueNo:LoopDataObj.TabQueueNo, FeeStr:LoopDataObj.FeeStr,
									PayModeCode:PayModeCode, AccRowId:AccRowId, user:UserID, group:GroupID,
									AdmType:AdmType, DiagnosCatRowId:DiagnosCatRowId, 
									FreeRegFlag:LoopDataObj.TabFreeRegFlag,FreeCheckFlag:LoopDataObj.TabFreeCheckFlag,RegfeeRowId:"", InsuJoinStr:LoopDataObj.InsuJoinStr,
									DiscountFactor:"", TAPPTRowID:LoopDataObj.TAPPTRowID, 
									UnBillFlag:"", TabPCLRowID:LoopDataObj.TabPCLRowID, ApptMethodCode:"", SourceType:"", RegConDisId:RegConDisId,
									ETPRowID:ETPRowID,TimeRangeStr:LoopDataObj.TimeRangeStr,RegExpStr:RegExpStr
								},false);
								var retarr=ret.split("$");	
								if (retarr[0]=="0"){
									var PrintArr=retarr[1].split("^");
									var EpisodeID="";
									var TabASRowId="";
									var RegfeeRowID="";
									var AdmType="";
									var PrintDataArySum=eval(retarr[1])
									var PrintDataAry=PrintDataArySum[0]
									for (Element in PrintDataAry){
										if (Element=="AdmNo"){EpisodeID=PrintDataAry[Element]}
										if (Element=="RBASDr"){TabASRowId=PrintDataAry[Element]}
										if (Element=="RegfeeRowId"){RegfeeRowID=PrintDataAry[Element]}								
										if (Element=="AdmType"){AdmType=PrintDataAry[Element]}								
									}
									//lxz ���������׽ӿ���Ϣ����--tanjishan 20210712�ŵ�OPBillChargeȥ����
									//RegPayObj.Relation(RegfeeRowID);
									//Ʊ�ݺϼ����� 
									var ReceiptCount=+$('#ReceiptCount').val();
									ReceiptCount=parseInt(ReceiptCount)+1;
									$('#ReceiptCount').val(ReceiptCount);
									//��ӡ�Һ�С��
									PrintOut(j,retarr[1]);
									//��ӡ��Ʊ --�������ҽ����Ҫ�ж��ǵ���ҽ���ӿڴ�ӡ��Ʊ���ǵ���HIS��ӡ��Ʊ-ҽ���޸İ�����Ŀ���������޸�
									PrintInv(RegfeeRowID)
									//����ӿڵ���(ҽ���������)
									if (typeof Common_ControlObj == "object") {
										var argObj={
											EpisodeID:EpisodeID,
											PAAdmType:AdmType
										}
										Common_ControlObj.AfterUpdate("Interface",argObj)
									}
									//��־���� ԭ��������������,��ʱ����
									//SavePrescEventLog(EpisodeID);
									NeedDelIndexArr.push(j);
									//DTS����ύ
									DTSLog.Submitlog();
									//���ûص�����
									resolve();
								}else{
									//HIS�Һ�ʧ�ܽ���
									/*var ret=$.cm({
										ClassName:"web.DHCOPAdmReg",
										MethodName:"OPRegUnLockSepNo",
										dataType:"text",
										CTLSRowId:CTLSRowId
									},false);*/
									//����ҽ���ҺŽ���,���ʧ��������쳣����
									ReturnInsuOPReg(PatientID,LoopDataObj.InsuAdmInfoDr,LoopDataObj.TabASRowId,AdmReason)
									//lxz ������֧�����׽ӿ��˻�
									RegPayObj.ErrReg();
									var errmsg=GetErrMsg(retarr[0]);
									if(errmsg=="") errmsg=retarr[0];
									var TabDepDesc=Data["rows"][j]["TabDeptDesc"];
									var TabMarkDesc=Data["rows"][j]["TabMarkDesc"];
									var ErrInfo="�Һż�¼����:��"+TabDepDesc+"��,�ű�:��"+TabMarkDesc+"��,��������:��"+LoopDataObj.AppDate+"��,���:��"+LoopDataObj.TabQueueNo+"��"
									$.messager.alert("��ʾ",ErrInfo+"�Һ�ʧ�ܣ�"+errmsg,"info",function(){
										NeedDelIndexArr.push(j);
										if (NeedDelIndexArr.length>0){
											for (var m=NeedDelIndexArr.length-1;m>=0;m--){
												var row=PageLogicObj.m_selectedMarkListDataGrid.datagrid('getRows')[NeedDelIndexArr[m]];
												var delTabPrice=row["TabPrice"];
												PageLogicObj.m_selectedMarkListDataGrid.datagrid('deleteRow',NeedDelIndexArr[m]);
												// ɾ�������¼���ϼƽ��
												var BillAmount=$("#BillAmount").val();
												BillAmount=parseFloat(BillAmount)-parseFloat(delTabPrice);
												BillAmount=BillAmount.toFixed(2);
												$("#BillAmount").val(BillAmount);
												ReCalculateAmount();
											}
										}
										$('#CardNo').focus();
									})
									$("#Update").removeClass('l-btn-disabled')
									return false;
								}
							})
						}).then(function(){
							j++;
							if ( j < Data["rows"].length ) {
								 loop(j);
							}else{
								callBackFun();
							}
						})
					}
					loop(0)
				})(resolve);
			})
		}).then(function(){
			if (NeedDelIndexArr.length>0){
				for (var m=NeedDelIndexArr.length-1;m>=0;m--){
					PageLogicObj.m_selectedMarkListDataGrid.datagrid('deleteRow',NeedDelIndexArr[m]);
				}
			}
			$.messager.popover({msg: '�Һųɹ�!',type:'success',timeout: 1000});		
			BClearHandle();
			$("#Update").removeClass('l-btn-disabled')
			if (ServerObj.ParaRegType!="APP"){
			   SetDefaultTimeRange();
		    }
		})
	}catch(e){
		$.messager.alert("��ʾ",e.message+","+e.name);
	}
}
function PrintOut(RegTblRow,PrintData) {
	//�޸� ͬʱ�Ҷ����ʱ�����ص�xmlģ����ɷ�Ʊģ��
	try {
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAdmRegPrint");
		var GridData=PageLogicObj.m_selectedMarkListDataGrid.datagrid("getData");
		var ASRowId=GridData["rows"][RegTblRow]["TabASRowId"];
		if (ASRowId==''){
			$.messager.alert("��ʾ","û��ѡ��Һ���Ϣ!");
			return false;
		}
		var PrintDataArySum=eval(PrintData)
		var PrintDataAry=PrintDataArySum[0]
		var MyPara = "" + String.fromCharCode(2);
		var PersonPay="",Regitems="";
		for (Element in PrintDataAry){
			if (Element=="PersonPay"){
				PersonPay=PrintDataAry[Element];
				if (PersonPay!="") {
					PersonPay=PersonPay.replace("Ԫ","");
				}
			}
			if (Element=="AppFee"){
				if (PrintDataAry[Element]!=0){PrintDataAry[Element]="ԤԼ��:"+PrintDataAry[Element]+"Ԫ"}else{PrintDataAry[Element]=""}
			}
			if (Element=="OtherFee"){
				if (PrintDataAry[Element]!=0) {PrintDataAry[Element]=PrintDataAry[Element]+"Ԫ"}else{PrintDataAry[Element]=""}
			}
			if (Element=="RegFee"){
				if (PrintDataAry[Element]!=0){PrintDataAry[Element]=PrintDataAry[Element]+"Ԫ"}else{PrintDataAry[Element]=""}
			}
			MyPara=MyPara +"^"+ Element + String.fromCharCode(2) + PrintDataAry[Element];
		}
		var o=$HUI.checkbox('#NeedCardFee');
		if (o.getValue()){
			var CardFee="������ "+parseFloat(ServerObj.CardFee)+"Ԫ";
		}else{
			var CardFee="";
		}
		AccAmount=$('#CardLeaving').val();
		if (GetPayModeCode()=="CPP"){
			var AccTotal=parseFloat(AccAmount)- parseFloat((+PersonPay)) //parseFloat(Total);
		}else {
			var AccTotal=parseFloat(AccAmount);
		}
		$('#CardLeaving').val(AccTotal);
		//���Ѻ���
		AccTotal=SaveNumbleFaxed(AccTotal);
		//����ǰ���
		AccAmount=SaveNumbleFaxed(AccAmount);
		var DYOPMRN=$('#OPMRN').val(); //���ﲡ����
		var DYIPMRN=$('#IPMRN').val(); //סԺ������
		MyPara=MyPara +"^"+ "CardFee" + String.fromCharCode(2) +CardFee;
		MyPara=MyPara +"^"+ "CardFee" + String.fromCharCode(2) +CardFee;
		MyPara=MyPara +"^"+ "AccAmount" + String.fromCharCode(2) +AccAmount;
		MyPara=MyPara +"^"+ "AccTotal" + String.fromCharCode(2) +AccTotal;
		MyPara=MyPara +"^"+ "DYOPMRN" + String.fromCharCode(2) +DYOPMRN;
		MyPara=MyPara +"^"+ "DYIPMRN" + String.fromCharCode(2) +DYIPMRN;
		DHC_PrintByLodop(getLodop(),MyPara,"","","");
	} catch(e) {alert(e.message)};
	/*try {
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
		RegTime=RegDateYear+"-"+RegDateMonth+"-"+RegDateDay+" "+RegTime;
		AccAmount=$('#CardLeaving').val();
		if (GetPayModeCode()=="CPP"){
			var AccTotal=parseFloat(AccAmount)- parseFloat((+PersonPay)) //parseFloat(Total);
		}else {
			var AccTotal=parseFloat(AccAmount);
		}
		$('#CardLeaving').val(AccTotal);
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
		var TimeD=TimeRange //$(".seltimerange")[0].id.split("-")[1];
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
		//var myobj=document.getElementById("ClsBillPrint");
		//PrintFun(myobj,MyPara,"");
		DHC_PrintByLodop(getLodop(),MyPara,"","","");
		$('#AccAmount').val(AccTotal);	
	} catch(e) {alert(e.message)};*/
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
//�Һŷ�Ʊ��ӡ
function PrintInv(RegFeeID)
{   
	var UserID=session['LOGON.USERID'];
	var Return=tkMakeServerCall("web.DHCOPAdmReg","GetPrintInvInfo","InvPrintNew","INVPrtFlag2007",RegFeeID, UserID, "","");
}
function InvPrintNew(TxtInfo,ListInfo)
{   
	DHCP_GetXMLConfig("InvPrintEncrypt","INVPrtFlag2007");
	var myobj=document.getElementById("ClsBillPrint");
	var tmpListInfo="";
	var tmpListAry=ListInfo.split(String.fromCharCode(2));
	var ListLen=tmpListAry.length;
	for (var i = 0; i < ListLen; i++) {
		if (i>7) break;
		if (tmpListInfo=="") {
			tmpListInfo=tmpListAry[i];
		}else{
			tmpListInfo=tmpListInfo+String.fromCharCode(2)+tmpListAry[i];
		}	
	}
	ListInfo=tmpListInfo;
	DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","");
	//PrintFun(myobj,TxtInfo,ListInfo);	
}

function GetDHCOPRegConfig(NodeName){
	return $.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"GetSpecConfigNode",
		dataType:"text",
		NodeName:NodeName
	},false);
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
function AddBeforeUpdate(dataObj){
	var ASRowId=dataObj["TabASRowId"];
	if (ASRowId=="") return false;
	var PatientID=$('#PatientID').val();
	if (PatientID==""){
		if (ServerObj.ParaRegType!="APP"){
			$.messager.alert("��ʾ","����ͨ������ȷ������!","info",function(){
				$('#CardNo').focus();
			});
		   	return false;
	   	}else{
		   	CommonCardRegCheck=dhcsys_confirm("�Ƿ�ѡ���޿�ԤԼ����ԤԼ?",true);
		   	if (CommonCardRegCheck==true){
			   	if ((ServerObj.CommonCardNoStr.split("&").length)>1){
				   $('#CommonCardWin').window('open');	
				   InitCommonCardWin();
				   return false;
				}else{
				   	var PatientNomyrtn=$.cm({
						ClassName:"web.DHCOPAdmReg",
						MethodName:"GetCommonCardNoandPatientNo",
						dataType:"text",
						ChoseCommonCardNo:ServerObj.CommonCardNoStr
					},false);
					if (PatientNomyrtn==""){
						$.messager.alert("��ʾ","��ά��������.");       				
						return false;
					}else{
						var CardNo=PatientNomyrtn.split("^")[0]
						var PatientNo=PatientNomyrtn.split("^")[1];
						var CardTypeNew=PatientNomyrtn.split("^")[2];
						var PatInfoStr=$.cm({
						    ClassName : "web.DHCOPAdmReg",
						    MethodName : "GetPatDetailBroker",
						    dataType:"text",
						    itmjs:"",
						    itmjsex:"GetPatDetailToHUI",
						    val:PatientNo,
					    },false);
					    var Patdetail=PatInfoStr.split("^");
					    $("#CardNo").val(CardNo);
					    $("#CardTypeNew").val(CardTypeNew);
						$("#Name").val(Patdetail[0]);
						$("#Age").val(Patdetail[1]);
						$("#Sex").val(Patdetail[2]);
						//���ﲡ���ź�סԺ������
						$("#OPMRN").val(Patdetail[3]);
						$("#IPMRN").val(Patdetail[4]);
						//ҽ����
						$("#PatYBCode").val(Patdetail[11]);
						//ҽ������
						//$("YBType",Patdetail[12]);
						$("#PoliticalLevel").val(Patdetail[19]);
						$("#SecretLevel").val(Patdetail[20]);
						$("#TelH").val(Patdetail[21]);
						$("#PAPERCountry").val(Patdetail[22]);
						$("#Address").val(Patdetail[23]);
						var PatCat=Patdetail[5];
						$("#PatCat").val(PatCat);
						$("#PatientID").val(Patdetail[6]);
						$("#IDCardNo").val(Patdetail[7]);
						$("#PatientNo").val(Patdetail[9]);
						$("#AppBreakCount").val(Patdetail[10]);
						PatientID=Patdetail[6]
						if (PageLogicObj.m_curDayAppListDataGrid==""){
							PageLogicObj.m_curDayAppListDataGrid=curDayAppListDataGrid();
						}else{
							ClearAllTableData("curDayAppList");
						}
						PageLogicObj.m_selectedMarkListDataGrid=InitselectedMarkListDataGrid();
					}
			   	}
			}else{
				$('#CardNo').focus();
				return false;
			}
		}
	}else{
		if (dataObj["TAPPTRowID"]==""){
			var myoptval=$.cm({
				ClassName:"web.DHCOPAdmReg",
				MethodName:"CheckPatientAppionment",
				dataType:"text",
				ASRowId:dataObj["TabASRowId"],
				PatientID:PatientID
			},false);
			if (myoptval==1){
				var ContinueReg=dhcsys_confirm(("������"+dataObj["CurrentMarkDesc"]+"��δȡ��ԤԼ��¼,�Ƿ��������"),false);
				if (ContinueReg==false) {
					 return false;
				}
			}
		}
	}
	if ((dataObj["StopRegFlag"]=="Y")&&(ServerObj.ParaRegType!="APP")) {
		$.messager.alert("��ʾ","�úű���ֹͣ�Һţ�");       				
		return false;
	}
	if (!AddBeforeUpdateByASRowId(ASRowId)) return false;
	if (ServerObj.ParaRegType!="APP"){
		if (((+dataObj["AvailSeqNoStr"])==0)&&((+dataObj["AvailAddSeqNoStr"])==0)){
			$.messager.alert("��ʾ","�úű��ѹ���!");       				
			return false;
		}
		/*if (dataObj["AvailSeqNoStr"]=="0"){
			$.messager.alert("��ʾ","�úű��ѹ���!");       				
			return false;
		}*/
	}
	//�жϽ������Ƿ����ظ��Һ�
	if (DuplReg(ASRowId)){
		$.messager.alert("��ʾ","���Һ��ظ�,������ѡ��!");
		return false;
	}
	//��ӵ��м�¼ǰ���м��
	var ASRowIDStr=ASRowId
	var Data=PageLogicObj.m_selectedMarkListDataGrid.datagrid("getData");
	for (var j=0;j<Data["rows"].length;j++) {
		var TabASRowId=Data["rows"][j]["TabASRowId"]; 
		var TAPPTRowID=Data["rows"][j]["TAPPTRowID"];
		if (TAPPTRowID==""){
			ASRowIDStr=ASRowIDStr+"^"+TabASRowId
		} 
	}
	var Rtn=$.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"CheckBeforeReg",
		dataType:"text",
		ResRowId:ASRowId, PatientID:PatientID, APPTRowId:"",
		CardTypeDr:$("#CardTypeRowID").val(),CardNo:$("#CardNo").val(),ASRowIdStr:ASRowIDStr
	},false);
	var RtnArry=Rtn.split("^")
	if (RtnArry[0]!=0){
		$.messager.alert("��ʾ",RtnArry[1]);
		return false;
	}
	//�ж��Ƿ�Ϊ����,����Ǹ���۸���ܻ᲻ͬ
	var ReAdmFeeFlag=GetReAdmFeeFlag(PatientID,ASRowId);
	dataObj["TabReAdmFeeFlag"]=ReAdmFeeFlag;
	if ((ReAdmFeeFlag==1)&&((dataObj["ReCheckFee"]!="")&&(dataObj["ReCheckFee"]!=0))){dataObj["ExamFee"]=dataObj["ReCheckFee"]}
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
		$.messager.confirm("��ʾ", "�˺�û�ж���۸�,��ȷ�ϼ����Һ���?", function (r) {
				if (r) {
					if (ServerObj.OPRegInsertOrder=="1"){
						dataObj["HoliFee"].HoliFee=0
						dataObj["ExamFee"].ExamFee=0
						dataObj["RegFee"].RegFee=0
						dataObj["AppFee"].AppFee=0
						dataObj["OtherFee"].OtherFee=0
						TotalFee=0
						}
					TotalFee=parseFloat(TotalFee).toFixed(2); 
					dataObj["Price"]=TotalFee;
					var BillAmount=$("#BillAmount").val();
					var ToBillAmount=parseFloat((parseFloat(+BillAmount)+parseFloat(TotalFee))).toFixed(2);
					AccAmount=$('#AccAmount').val();
					//��������ʻ�֧��Ҫ�ж��Ƿ��ʻ�����㹻
					var PayModeCode=GetPayModeCode();
					if (PayModeCode=="CPP") {
				 		if (ToBillAmount>parseFloat(AccAmount)) {
					   		//$.messager.alert("��ʾ","�ʻ�����");
					   		//return false;
					   		var ret=ChangePayMode();
							if(!ret){
								return false;	
							}
				 		}
				 	} 	
					$("#BillAmount").val(ToBillAmount);
					var PayModeCode=GetPayModeCode()
					if(PayModeCode!="CPP") ReCalculateAmount();
					AddToSelectedMarkList(dataObj,true);
				} else {
					
				}
			});
		return false;
		
	}else{
		if (ServerObj.OPRegInsertOrder=="1"){
			dataObj["HoliFee"].HoliFee=0
			dataObj["ExamFee"].ExamFee=0
			dataObj["RegFee"].RegFee=0
			dataObj["AppFee"].AppFee=0
			dataObj["OtherFee"].OtherFee=0
			TotalFee=0
			}
		TotalFee=parseFloat(TotalFee).toFixed(2); 
		dataObj["Price"]=TotalFee;
		var BillAmount=$("#BillAmount").val();
		var ToBillAmount=parseFloat((parseFloat(+BillAmount)+parseFloat(TotalFee))).toFixed(2);
		AccAmount=$('#AccAmount').val();
		//��������ʻ�֧��Ҫ�ж��Ƿ��ʻ�����㹻
		var PayModeCode=GetPayModeCode();
		if (PayModeCode=="CPP") {
	 		if (ToBillAmount>parseFloat(AccAmount)) {
		   		//$.messager.alert("��ʾ","�ʻ�����");
		   		//return false;
		   		var ret=ChangePayMode();
				if(!ret){
					return false;	
				}
	 		}
	 	} 	
		$("#BillAmount").val(ToBillAmount);
		var PayModeCode=GetPayModeCode()
		if(PayModeCode!="CPP") ReCalculateAmount();
		return dataObj;
	}
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
	if (ServerObj.ParaRegType!="APP"){
		var PayModeValue=$("#PayMode").combobox("getValue");
		if (PayModeValue!="") {
			var PayModeData=$("#PayMode").combobox('getData');
			var index=$.hisui.indexOfArray(PayModeData,"CTPMRowID",PayModeValue);
			var PayModeCode= PayModeData[index].CTPMCode;
			return PayModeCode;
		}
	}
	return "";
}
function DeptListChangeHanlde(){
	var desc=$("#DeptList").lookup('getText');
	if (desc==""){
		PageLogicObj.m_deptRowId="";
		PageLogicObj.m_DocRowId="";
		DestoryPannelPopover();
		$("#SelLoc").html("");
		$("#MarkCode").lookup('setText','');
		LoadClinicServiceGroup("");
		var $card=$("div[id*='-marklist-card']");
		if ($card.length>0) $card.parent().remove();
		
		if (PageLogicObj.m_selectedMarkListDataGrid!=""){
			ClearAllTableData("selectedMarkList");
		}
		$("#BillAmount").val('');
	}
}
function LoadDeptList(){
	$("#DeptList").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'CTCode',
        textField:'CTDesc',
        columns:[[  
            {field:'CTCode',title:'',hidden:true},
			{field:'CTDesc',title:'��������',width:410}
        ]], 
        pagination:true,
        panelWidth:460,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCOPAdmReg',QueryName: 'OPDeptList'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;
	        var OutStatus=$("#cOutStatus").checkbox('getValue')?'1':'';
		    var InStatus=$("#cInStatus").checkbox('getValue')?'1':'';
		    var DisInStatus=$("#cDisInStatus").checkbox('getValue')?'1':'';
			param = $.extend(param,{UserId:session['LOGON.USERCODE'], AdmType:"", paradesc:desc});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				if (rec!=undefined){
					PageLogicObj.m_deptRowId=rec["CTCode"];
					$("#SelLoc").html(rec["CTDesc"]);
					PageLogicObj.m_DocRowId="";  
					$("#MarkCode").lookup('setText','');
					LoadClinicServiceGroup(rec["CTCode"]);
					$("#ClinicServiceGroup").combobox('setValue','');
					LoadMarkList();
					$("#DeptList").blur();
				}else{
					$("#ClinicServiceGroup").combobox('select',"");
					PageLogicObj.m_DocRowId="";  
					$("#MarkCode").lookup('setText','');
				}
			});
		}
    });
}
function LoadMarkCode(){
	$("#MarkCode").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'Hidden1',
        textField:'Desc',
        columns:[[  
            {field:'Hidden1',title:'',hidden:true},
			{field:'Desc',title:'����',width:410}
        ]], 
        pagination:true,
        panelWidth:460,
        isCombo:true,
        //minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCRBResSession',QueryName: 'FindResDoc'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{DepID:PageLogicObj.m_deptRowId, Type:"", UserID:"", Group:"", MarkCodeName:desc});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				if (rec!=undefined){
					PageLogicObj.m_DocRowId=rec['Hidden1'];
					LoadMarkList();
					$("#MarkCode").blur();
				}
			});
		}
    });
	/*$.cm({ 
		ClassName:"web.DHCRBResSession", 
		QueryName:"FindResDoc",
		DepID:DepID,
		Type:"",UserID:"",Group:"",MarkCodeName:"",
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#MarkCode", {
				valueField: 'Hidden1',
				textField: 'Desc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					q=q.toUpperCase();
					return (row["Desc"].toUpperCase().indexOf(q) >= 0)||(row["Code"].toUpperCase().indexOf(q) >= 0);
				},
				onSelect:function(rec){
					if (rec!=undefined){
						LoadMarkList();
					}
				},onChange:function(newValue,OldValue){
					if (newValue==""){
						$("#MarkCode").combobox('select',"");
						LoadMarkList();
					}
				}
		 });
	})*/
}
function LoadClinicServiceGroup(DepID){
	if(ServerObj.QryScheduleByClinicGroup=="1"){
		$.cm({ 
			ClassName:"web.DHCRBResSession", 
			QueryName:"GetClinicGroupByLocNew",
			LocRowId:DepID,
			rows:99999 
		},function(GridData){
			var cbox = $HUI.combobox("#ClinicServiceGroup", {
					valueField: 'CLGRPRowId',
					textField: 'CLGRPDesc', 
					editable:true,
					data: GridData["rows"],
					filter: function(q, row){
						q=q.toUpperCase();
						return (row["CLGRPDesc"].toUpperCase().indexOf(q) >= 0);
					},
					onSelect:function(rec){
						if (rec!=undefined){
							LoadMarkList();
						}
					},onChange:function(newValue,OldValue){
						if (newValue==""){
							$("#ClinicServiceGroup").combobox('select',"");
							LoadMarkList();
						}
					}
			 });
		})
	}else{
		$.cm({ 
			ClassName:"web.DHCRBResSession", 
			QueryName:"GetClinicServiceGroupByLocNew",
			LocRowId:DepID,
			rows:99999 
		},function(GridData){
			var cbox = $HUI.combobox("#ClinicServiceGroup", {
					valueField: 'CLSGRPRowId',
					textField: 'CLSGRPDesc', 
					editable:true,
					data: GridData["rows"],
					filter: function(q, row){
						q=q.toUpperCase();
						return (row["CLSGRPDesc"].toUpperCase().indexOf(q) >= 0);
					},
					onSelect:function(rec){
						if (rec!=undefined){
							LoadMarkList();
						}
					},onChange:function(newValue,OldValue){
						if (newValue==""){
							$("#ClinicServiceGroup").combobox('select',"");
							LoadMarkList();
						}
					}
			 });
		})
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
	if ((o.getValue())||(ServerObj.ParaRegType=="APP")){
		if (ServerObj.ParaRegType=="APP"){
			if (PageLogicObj.m_curDayAppListDataGrid==""){
				PageLogicObj.m_curDayAppListDataGrid=curDayAppListDataGrid();
			}else{
				ClearAllTableData("curDayAppList");
			}
		}/*else{
			if (PageLogicObj.m_curDayRegListDataGrid===""){
				PageLogicObj.m_curDayRegListDataGrid=curDayRegListDataGrid();
			}else{
				ClearAllTableData("curDayRegList");
			}
		}*/
		//ȡ���˵�ԤԼ��Ϣ
		$("#BillAmount").val("0.00")
		var AdmReason=$('#BillType').combobox('getValue');
		var GetAppFlag=1;
		var rtn="";
		ClearAllTableData("selectedMarkList");
		var BillAmount=+$("#BillAmount").val();
		var RegConDisId="";
		if(ServerObj.ParaRegType!="APP"){
			RegConDisId=$("#RegConDisList").combobox("getValue");
		}
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
			    RegConDisId:RegConDisId,RegType:ServerObj.ParaRegType
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
						var RepeatFlag=CheckAppRowDataRepeat("TAPPTRowID",TAPPTRowID);
						if (RepeatFlag==1) continue;
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
		var TabClinicGroupDr=valueAry[16];
		var TabClinicGroupDesc=valueAry[17];
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
			AppFee:TabAppFee,
			OtherFee:"",
			ReCheckFee:"",
			TabFreeRegFlag:TabFreeRegFlag,
			TabFreeCheckFlag:TabFreeCheckFlag,
			TabReAdmFeeFlag:TabReAdmFeeFlag,
			TabTimeRange:TabTimeRange,
			TabClinicGroupDesc:TabClinicGroupDesc,
			TabClinicGroupDr:TabClinicGroupDr
		}
		if (ServerObj.OPRegInsertOrder=="1"){
			dataObj["Price"]=0
			dataObj["HoliFee"]=0
			dataObj["ExamFee"]=0
			dataObj["RegFee"]=0
			dataObj["AppFee"]=0
			dataObj["OtherFee"]=0
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
function CheckAppRowDataRepeat(CellName,ChecKValue){
	var RepeatFlag=0;
	if (ChecKValue=="") return RepeatFlag;
	//�ж��ظ����������
	var Data=PageLogicObj.m_curDayAppListDataGrid.datagrid("getData");
	for (var i = 0; i < Data["rows"].length; i++) { 
		var CellNameVal=Data["rows"][i][CellName];
		if (CellNameVal=="") continue;
		if (CellNameVal==ChecKValue) RepeatFlag=1;break;
	}
	return RepeatFlag;
}
function AppDateonSelect(date){
	date=myformatter(date);
	AppDateChange(date);
}
function AppDateChange(date){
	$("#SelDate").html(date);
	if ((ServerObj.ParaRegType !="APP")){
		if (date !=ServerObj.CurDate) {
			$("#WeekDesc").prev().html("ԤԼ���� : ");
		}else{
			$("#WeekDesc").prev().html("������ : ");
		}
	}
	$.cm({
		ClassName:"web.DHCOPAdmReg", 
		MethodName:"ConvertToWeek",
		dataType:"text",
		DateStr:date
	},function(Week){
		$("#WeekDesc").html(Week);
	})
	LoadMarkList();
}
function PreAppDayClickHandler(){
	var date=$("#AppDate").datebox('getValue');
	var date=addDay(-1,myparser(date));
	date=myformatter(date);
	$("#AppDate").datebox('setValue',date);
	AppDateChange(date);
}
function NextAppDayClickHandler(){
	var date=$("#AppDate").datebox('getValue');
	var date=addDay(1,myparser(date));
	date=myformatter(date);
	$("#AppDate").datebox('setValue',date);
	AppDateChange(date);
}
function AllAppDaysClickHandler(){
	LoadMarkList(0);
}
function ChangeWeekAppDayClickHandler(Type){
	var date=$("#AppDate").datebox('getValue');
	$.cm({
		ClassName:"web.DHCOPAdmReg", 
		MethodName:"GetnextWeekDate",
		dataType:"text",
		AppDate:date,
		Type:Type
	},function(Str){
		var NowDate=Str.split("^")[0]
		$("#AppDate").datebox('setValue',NowDate);
		$("#SelDate").html(NowDate);
		var strdate=Str.split("^")[1]+"||"+Str.split("^")[2];
		LoadMarkList(NowDate);
	})
}
function addDay(dayNumber, date) {
    date = date ? date : new Date();
    var ms = dayNumber * (1000 * 60 * 60 * 24)
    var newDate = new Date(date.getTime() + ms);
    return newDate;
}
function DeptTreeListClickHandle(){
	//$("#DeptList").lookup('hidePanel');
	if ($("#DeptTreeList-div").css("display")=="none"){
		$("#SearhDeptTree").searchbox('setValue','');
		$("#DeptTreeList-div").show();
		$('#SearhDeptTree').next('span').find('input').focus();
		$.cm({ 
			ClassName:"web.DHCOPAdmReg", 
			MethodName:"GetDeptTreeList"
		},function(Data){
			var tree=$("#DeptTree").tree({
				lines:true,
				multiple:false,
				data:Data,
				onSelect:function(node){
					if ($(this).tree('isLeaf', node.target)){
						PageLogicObj.m_deptRowId=node["id"];
						$("#SelLoc").html(node['text']);
						$("#DeptList").lookup('setText',node['text']);
						$("#DeptTreeList-div").hide();
						PageLogicObj.m_DocRowId="";  
						$("#MarkCode").lookup('setText','');
						$("#ClinicServiceGroup").combobox('setValue','');
						LoadClinicServiceGroup(PageLogicObj.m_deptRowId);
						LoadMarkList();
					}

				}
			})
		})
	}else{
		return false;
	}
}
function SearchDeptTree(value,name){
	value=value.toUpperCase();
	var roots=$HUI.tree("#DeptTree").getRoots();
	for (var i=0;i<roots.length;i++){
		var id=roots[i]["id"];
		var text=roots[i]["text"].toUpperCase();
		var code=roots[i]["attributes"]["code"].toUpperCase();
		var rootNode=$('#DeptTree').tree('find', id);
		var chiddata=roots[i]["children"];
		var childFindFlag=0;
		for (var j=0;j<chiddata.length;j++){
			var childid=chiddata[j]["id"];
			var childText=chiddata[j]["text"].toUpperCase();
			var childCode=chiddata[j]["attributes"]["code"].toUpperCase();
			var childNode=$('#DeptTree').tree('find', childid);
			if ((childCode.indexOf(value)>=0)||(childText.indexOf(value)>=0)){
				childFindFlag=1;
				$(childNode.target).show();
			}else{
				$(childNode.target).hide();
			}
		}
		if ((code.indexOf(value)>=0)||(text.indexOf(value)>=0)){
			$(rootNode.target).show();
		}else{
			if (childFindFlag==0){
				$(rootNode.target).hide();
			}else{
				$(rootNode.target).show();
			}
		}
	}
}
function MarkListShowModeClickHandle(e){
	DestoryPannelPopover()
	$("#MarkListShowMode").blur();
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
    url=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(url):url;
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
function LoadMarkList(AppDate){
	var DepRowId=GetDeptRowId();
	if (typeof AppDate =="undefined"){
		var AppDate=$('#AppDate').datebox('getValue');
	}
	
	var PatientID=$("#PatientID").val();
	var TimeRangeRowId=$(".seltimerange")[0].id.split("-")[0];
	if (TimeRangeRowId=="ALL") TimeRangeRowId="";
	var DocRowId=PageLogicObj.m_DocRowId; //$("#MarkCode").combobox("getValue");
	if ($("#MarkCode").lookup("getText")==""){
		PageLogicObj.m_DocRowId="";
		DocRowId="";
	}
	//if (DocRowId==undefined) DocRowId="";
	var ClinicServiceGroupRowId=$("#ClinicServiceGroup").combobox('getValue') //��רҵ
	if (ClinicServiceGroupRowId==undefined) ClinicServiceGroupRowId="";
	var ShowStopScheFlag=""; //������ͣ��
	var RegConDisId="";
	if(ServerObj.ParaRegType!="APP"){
		if (AppDate) {
			if (!CheckOrderStartDate(AppDate,ServerObj.CurDate)){
				$.messager.alert("��ʾ","ԤԼ����Ӧ�ô��ڵ��ڱ���!","info",function(){
					$('#AppDate').next('span').find('input').focus();
				});
				return false;
			}
		}
		var o=$HUI.checkbox("#ShowStopSche");
		if (o.getValue()){
			ShowStopScheFlag=1;
		}
		RegConDisId=$("#RegConDisList").combobox("getValue");
		if (!RegConDisId) RegConDisId="";
	}else{
		if (AppDate=="") {
			AppDate="0";
		}else{
			if (!CheckOrderStartDate(AppDate,ServerObj.DefaultAppDate)){
				$.messager.alert("��ʾ","ԤԼ����Ӧ�ô��ڱ���!","info",function(){
					SetDefaultAppDate();
					//$('#AppDate').datebox();
				});
				return false;
			}
		}
	}
	var AdmReason=$("#BillType").combobox('getValue');
	var p1=DepRowId+"^"+session['LOGON.USERID']+"^"+AppDate+"^"+PatientID+"^"+TimeRangeRowId+"^"+DocRowId+"^"+session['LOGON.GROUPID']+"^"+AdmReason+"^^"+TimeRangeRowId+"^"+ClinicServiceGroupRowId+"^"+ShowStopScheFlag+"^"+RegConDisId+"^"+session['LOGON.HOSPID'];
	$.cm({
		ClassName:"web.DHCOPAdmReg", 
		QueryName:"OPDocList",
		Dept:p1,
		rows:99999
	},function(GridData){
		$("#MarkListPanel").removeClass('marklist-card-panel');
		DestoryPannelPopover();
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
		 $($(tool).find("div")[1]).html(oneData["ScheduleStatus"]+" "+oneData["ScheduleDate"]);
		 var TotalFee=parseFloat(oneData["HoliFee"])+parseFloat(oneData["ExamFee"])+parseFloat(oneData["RegFee"])+parseFloat(oneData["AppFee"])+parseFloat(oneData["AppFeeDr"]);
		 $($(tool).find("div")[2]).html(oneData["ClinicGroupDesc"]+" "+TotalFee+"Ԫ"); //
		 $($(tool).find("div")[4]).html(+oneData["RegedCount"]); //�ѹҺ���
		 $($(tool).find("div")[5]).html(+oneData["AppedCount"]); //��ԤԼ��
		 $($(tool).find("div")[6]).html(+oneData["AppedArriveCount"]); //��ȡ����
		 $($(tool).find("div")[7]).html(+oneData["AddedCount"]); //�Ӻ���
		 $($(tool).find("div")[8]).html(JSON.stringify(oneData));
		 if ((i>=1)&&(oneData["TimeRange"]!=GridData["rows"][i-1]["TimeRange"])){
			 colorIndex=colorIndex+1;
			 if (colorIndex>4) colorIndex=1;
		 }
		 $($(tool).find("span")[0]).addClass("timerange-span-solid-"+colorIndex);
		 $($(tool).find("span")[1]).html(oneData["TimeRange"]).addClass("timerange-span-dotted-"+colorIndex);
		 if (i==0){
			(function (id) {
				$("#"+id).addClass("markcard-select");
				setTimeout(function(){
					SetMarkCardFocus(id);
				});
			})(id);
		 }
		/*
		�������
		ҽ��������ɫ 			����Ű�
		ҽ�������ɫ 			�����Ű�
		ҽ�������ɫ��б�� 		�����Ű��Һ��ѹ���
		��Ƭ����ɫ��ɫ 			��ͣ��
		*/
		var className="marklist-card";
		if(oneData["NoLimitLoadFlag"]=="Y"){
			className="marklist-card-fastsche";
			if ((+oneData["AvailSeqNoStr"]==0)&&(+oneData["AvailAddSeqNoStr"]==0)&&(ServerObj.SeqNoMode=='')){
				className="marklist-card-invalid";
			}
		}else{
			if ((+oneData["AvailSeqNoStr"]==0)&&(+oneData["AvailAddSeqNoStr"]==0)&&(ServerObj.SeqNoMode=='')){
				className="marklist-card-invalid";
			}
		}
		if (oneData["ScheduleStatus"]=="ͣ��"){
			className="marklist-card-stop";
		}
		var valbox = $HUI.panel("#"+id,{
			width:200,
			height:137,
			//style:{"border":"1px solid red"},
			bodyCls:className,
			noheader:true
		});
	}
	
	var $card=$("div[id*='-marklist-card']");
	$card.mouseenter(function(e){
		var id=e.currentTarget.id;
		$(".markcard-hover").removeClass("markcard-hover");
		$("#"+id).addClass("markcard-hover");
		if (PageLogicObj.m_MarkPopoverTrigger=="hover"){
			DestoryPannelPopover();
			try{
				InitMarkListRowPopover({rowIndex:"",markCardID:id,Show:true})
			}catch(e){}
		}
	}).mouseleave(function(e){
		$(".markcard-hover").removeClass("markcard-hover");
	}).dblclick(function(e){
		var id=e.currentTarget.id;
		var dataStr=$($("#"+id).find("div")[8]).html();
		var jsonData=JSON.parse(dataStr);
		MarkListDBClick(jsonData);
	}).click(function(e){
		var id=e.currentTarget.id;
		$(".markcard-select").removeClass("markcard-select");
		$("#"+id).addClass("markcard-select");
		SetMarkCardFocus(id);
	})
	if (PageLogicObj.m_MouseoverId != "") {
		// �л� popover switch ��ťʱ���ֶ����� mouseover
		$("#" + PageLogicObj.m_MouseoverId).mouseover()
	}
}
///��ȡ��̬д���HTML����
function GetPannelHTML(jsonData,LinkID){
	var Len=0;
	if ((ServerObj.ParaRegType=="APP")||(ServerObj.OPRegistShowTimeRange=="1")){
		var ASRowId=jsonData["ASRowId"];
		var ClinicGroupDr=jsonData["ClinicGroupDr"];
		var width=628,height=250;
		var CallFunction={};
		var innerHTML="<table border='1' class='diytable' cellspacing='1' cellpadding='0'>";
		var Title = "<font style='font-weight:bold'>" + jsonData["MarkDesc"] + "(" + jsonData['SessionTypeDesc'] + ") " + jsonData["TimeRange"] + "</font>"
		Title = Title + "<font style='margin-left:10px;'>�Һ�: " + jsonData['RegedCount'] + "</font><font style='margin-left:10px;'>ԤԼ: " + jsonData['AppedCount'] + "</font><font style='margin-left:10px;'>ȡ��: " + jsonData['AppedArriveCount'] + "</font><font style='margin-left:10px;'>�Ӻ�: " + jsonData['AddedCount'] + "</font>"
		var RegType="APP"
		if (ServerObj.ParaRegType != "APP") { RegType="NOR" }
		var curtDate = new Date()
		var schdDate = new Date(jsonData["ScheduleDate"])
		if (schdDate > curtDate) { RegType = "APP" }
		if (RegType=="APP") {
			Title = Title + "<font style='margin-left:10px;'>��ԤԼ: " + jsonData["AvailSeqNoStr"] + "</font>"
		} else {
			Title = Title + "<font style='margin-left:10px;'>ʣ��: " + jsonData["AvailSeqNoStr"] + "</font>"
		}
		//ԤԼ�ҺŽ��涼��ʾ��ǰ��������
		Title = Title + "<font style='margin-left:10px;'>��ǰ����: " + jsonData['AdmWaitSum'] + "</font>"
		var warning = $.cm({
			ClassName:"web.DHCOPAdmReg",
			MethodName:"GetTimeRangeStrApp",
		    ASRowid:ASRowId,
		    AppMedthod:"WIN",
		    RegType :RegType,
			TRShowFlag: PageLogicObj.m_TrShowFlag,
			ClinicGroupDr:ClinicGroupDr,
			dataType:"text"
		},false);
		warning=eval('(' + warning + ')');
		// ���5���������п��
		var MaxRow = 5; MaxCol = 5; colNum = 0; colCnt = 0;
		Len = warning['row'].length;
		if (Math.ceil(Len / MaxRow) > MaxCol) {
			colCnt = Math.ceil(Len / MaxRow)
		} else {
			colCnt = MaxCol
		}
		var col = warning['row']
		for (var j = 0; j < Len; j++) {
			if (j % colCnt == 0) {
				innerHTML = innerHTML + "<tr>";
			}
			var SeqNo = col[j]['SeqNo'];
			var Time = col[j]['Time'];
			var Status = col[j]['Status'];
			if (Status == 0) {
				innerHTML = innerHTML + "<td class='td-seqno-invalid'>" + "<span class='td-seqno'>����:��" + "</span><br><span class='td-time'>" + Time + "</span></td>";
			} else {
				innerHTML = innerHTML + "<td onmouseover=mouserover(this) onmouseout=mouserout(this) onclick=tdclick(this) ondblclick=dbtdclick(this) id='" + LinkID + "_table_" + Time + "'>" + "<span class='td-seqno'>����:��" + "</span><br><span class='td-time'>" + Time + "</span></td>";
			}
			innerHTML = innerHTML + "</td>";
			colNum = colNum + 1;
			if (colNum == colCnt) {
				innerHTML = innerHTML + "</tr>";
				colNum = 0;
			}
		}
		if (colNum != 0) innerHTML = innerHTML + "</tr>";
		innerHTML = innerHTML + "</table>";
		if (Len == 0) {
			innerHTML = "";
		}
		// ����5�е������
		if (colCnt > MaxCol) {
			width = width + ((colCnt - MaxCol) * 121)
		}
		var closeable=true
	}
	if ((Len==0)||((ServerObj.ParaRegType!="APP")&&(ServerObj.OPRegistShowTimeRange!="1"))){
		var Title="";
		var innerHTML="<table border='1' class='diytable' cellspacing='1' cellpadding='0'>";
		innerHTML=innerHTML+"<tr><td style='width:70px'>�Һ���</td><td style='width:55px'>"+jsonData['RegedCount']+"</td></tr>";
		innerHTML=innerHTML+"<tr><td>ԤԼ��</td><td>"+jsonData['AppedCount']+"</td></tr>";
		innerHTML=innerHTML+"<tr><td>ȡ����</td><td>"+jsonData['AppedArriveCount']+"</td></tr>";
		innerHTML=innerHTML+"<tr><td>�Ӻ���</td><td>"+jsonData['AddedCount']+"</td></tr>";	
		innerHTML=innerHTML+"<tr><td>��ǰ��������</td><td>"+jsonData['AdmWaitSum']+"</td></tr>";	
		var width=180,height=151;
		var CallFunction="";
		var closeable=false;
	}
	// ���� switchbox
	if (Title != "") {
		Title = "<span>" + Title + "</span>"
		Title += "<div id=\"switch-btn\" class=\"hisui-switchbox hisui-tooltip\""
		Title += 		"style=\"float:right;margin-left:5px;margin-right:5px;padding:0.5px 0px;\""
		Title += 		"title=\"���ò���ʾ�޺�ʱ��\""
		Title += 		"data-options=\"onText:'ȫ��',offText:'����',size:'mini',animated:true,"
		if (PageLogicObj.m_TrShowFlag == 1) {
			Title += "checked:true,"
		} else {
			Title += "checked:false,"
		}
		Title += 			"onClass:'primary',offClass:'success',position:'right',"
		// Title +=			"onSwitchChange:function(event,obj){"
		// Title +=			"	if (obj.value) {"
		// Title +=			"		PageLogicObj.m_TrShowFlag = 1;"
		// Title +=			"	} else {"
		// Title +=			"		PageLogicObj.m_TrShowFlag = 0;"
		// Title +=			"	}"
		// Title +=			"	LoadMarkList() "
		// Title +=			"}"

		var RowIndex="",markCardID="";
		var text=$("#MarkListShowMode .l-btn-text")[0].innerText;
		if (text.indexOf("��ͼ")>=0){
			RowIndex=PageLogicObj.m_MarkListDataGrid.datagrid('getRowIndex',jsonData);
		}else{
			markCardID=LinkID;
		}
		//var param={rowIndex:RowIndex,markCardID:markCardID};
		
		Title +=			"onSwitchChange:(function(param){"
		Title +=			"	return function(event,obj){"
		Title +=			"		if (obj.value) {"
		Title +=			"			PageLogicObj.m_TrShowFlag = 1;"
		Title +=			"		} else {"
		Title +=			"			PageLogicObj.m_TrShowFlag = 0;"
		Title +=			"		}"
		Title +=			"		DestoryPannelPopover();"
		Title +=			"		InitMarkListRowPopover(param);"
		Title +=			"	}"
		Title +=			"})({rowIndex:'"+RowIndex+"',markCardID:'"+markCardID+"',Show:true})"
		Title +=			"\">"
		Title += "</div>"
		Title += "<div style=\"clear:both;\"></div>"
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
function mouserover(){
}
function mouserout(){
}
function tdclick(){
}
function dbtdclick(obj){
	var id=obj.id;
	var $btntext=$("#MarkListShowMode .l-btn-text")[0];
	var MarkCardID=id.split("_table_")[0];
	var text=$btntext.innerText;
	if (text.indexOf("��ͼ")>=0){
		var tabTRId=id.split("_table_")[0];
		var index=tabTRId.split("-")[tabTRId.split("-").length-1];
		var jsonData=$.extend({},$("#MarkList").datagrid('getRows')[index]);
		var Time=id.split("_table_")[1];
		jsonData['TimeRange']=Time;
	}else{
		//var SeqNo=id.split("_table_")[1];
		var dataStr=$($("#"+MarkCardID).find("div")[8]).html();
		var jsonData=JSON.parse(dataStr);
		var Time=id.split("_table_")[1];
		jsonData['TimeRange']=Time;
	}
	//jsonData['SeqNo']=SeqNo;
	MarkListDBClick(jsonData);
	$("#"+MarkCardID).popover('hide');
}
function SetMarkCardFocus(id){
	//$("#"+id).panel().focus();
	DestoryPannelPopover();
	$("#"+id).parent().focus();
	if (ServerObj.ParaRegType=="APP"){
		var MarkCardID=id.split("_table_")[0];
		var dataStr=$($("#"+MarkCardID).find("div")[8]).html();
		var jsonData=JSON.parse(dataStr);
		$("#SelDate").html(jsonData.ScheduleDate);
		$("#WeekDesc").html(jsonData.ScheduleDateWeek);
	}
	InitMarkListRowPopover({rowIndex:"",markCardID:id,Show:true});
}
function LoadMarkListTabData(GridData){
	PageLogicObj.m_MarkListDataGrid.datagrid('uncheckAll');
	if ((GridData["total"]==1)&&(GridData["rows"][0]["ASRowId"]=="")){
		PageLogicObj.m_MarkListDataGrid.datagrid('loadData', {"total":0,"rows":[]});
	}else{
		PageLogicObj.m_MarkListDataGrid.datagrid('loadData',GridData);
	}
}
function LoadPayMode(){
	$.cm({ 
		ClassName:"web.UDHCOPGSConfig", 
		QueryName:"ReadGSINSPMList",
		GPRowID:session['LOGON.GROUPID'],
		HospID:session['LOGON.HOSPID'],
		TypeFlag:"REG",
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
function InitAppPatType(){
	var Patdata=[{"id":"1","text":"����"},{"id":"2","text":"��ĸ����Ů"},{"id":"3","text":"������ϵ"}]
	var cbox = $HUI.combobox("#AppPatType", {
				valueField: 'id',
				textField: 'text', 
				editable:false,
				data: Patdata,
				onLoadSuccess:function(data){
					$HUI.combobox("#AppPatType").setValue(1);
				}
		 });
	}
function LoadRegConDisList(){
	if($("#RegConDisList").length==0){
		return	
	}
	$.m({
		ClassName:"web.DHCRegConDisCount", 
		MethodName:"ReadDHCRegConDisCountBroker",
		JSFunName:"GetRegConToHUIJson",
		ListName:"",
		PatientID:$('#PatientID').val(),
		BillTypeID:$('#BillType').combobox('getValue')
	},function(Data){
		var cbox = $HUI.combobox("#RegConDisList", {
				valueField: 'id',
				textField: 'text', 
				editable:true,
				data: JSON.parse(Data),
				onSelect:function(rec){
					if (rec!=undefined){
						if (PageLogicObj.m_selectedMarkListDataGrid!=""){
							$("#selectedMarkList").datagrid("uncheckAll");
							var Data=$("#selectedMarkList").datagrid("getRows");
							for (var i=Data.length-1;i>=0;i--){
								$("#selectedMarkList").datagrid("selectRow",i);
								DelSelMarkListRow();
							}
							LoadMarkList();
							// ԤԼȡ��ѡ���Ż����ͻ��ԤԼ��Ϣ���
							var PatientID=$("#PatientID").val();
							var AppSerialNo=$("#AppSerialNo").val();
							if (AppSerialNo==undefined) AppSerialNo="";
							if (AppSerialNo!="") {
								AppSerialNoBlurHandler();
							}else{
								GetApptInfo(PatientID);
							}
							MedicalBookChange()
						}
					}
				},
				onChange:function(newValue,OldValue){
					if (newValue==""){
						$("#RegConDisList").combobox('select',"");
						if (PageLogicObj.m_selectedMarkListDataGrid!=""){
							$("#selectedMarkList").datagrid("uncheckAll");
							var Data=$("#selectedMarkList").datagrid("getRows");
							for (var i=Data.length-1;i>=0;i--){
								$("#selectedMarkList").datagrid("selectRow",i);
								DelSelMarkListRow();
							}
							LoadMarkList();
						}
					}
				}
		 });
	});
}
function BRegExpClickHandle(PatientNo){
	if (typeof PatientNo ==undefined){PatientNo="";}
	if ((PatientNo=="undefined")||(PatientNo==undefined)) {PatientNo="";}
	var src="reg.cardreg.hui.csp?PatientNoReg="+PatientNo;
    src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("CardReg","����", PageLogicObj.dw+160, PageLogicObj.dh+200,"icon-w-edit","",$code,"");
}
function BCardRechargeHandle(){
	var src="dhcbill.opbill.accdep.pay.csp";
    src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Project","Ԥ�����ֵ", PageLogicObj.dw, PageLogicObj.dh,"icon-w-inv","",$code,"");
}
function BCacelRegHandle(EpisodeID){
	if (typeof EpisodeID == "undefined"){EpisodeID="";}
	var CardNo=$("#CardNo").val()
	var src="opadm.return.hui.csp?EpisodeID="+EpisodeID+"&PageFrom=Reg&CardNo="+CardNo;
    src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Project","�˺�", 1250, 620,"icon-w-back","",$code,"");
}
function BUpdatePatInfoHandle(){
	var src="doc.patientinfoupdate.hui.csp";   
    src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Project","�޸Ļ�����Ϣ", PageLogicObj.dw+200, PageLogicObj.dh,"icon-w-edit","",$code,"");
}
function BFindPatHandle(){
	var src="reg.cardsearchquery.hui.csp"; 
    src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("FindPatReg","���߲�ѯ", PageLogicObj.dw, PageLogicObj.dh,"icon-w-find","",$code,"");
}
function ClearAllTableData(id){
	var Data=$("#"+id).datagrid("getData");
	for (var i=Data["rows"].length-1;i>=0;i--){
		$("#"+id).datagrid('deleteRow',i);
	} 
}
function BClearHandle(){
	ClearPatInfo();
	SetDefaultTimeRange();
	$('#AppPatType').combobox('select',1);
	$("#SearhDeptTree").searchbox('setValue','');
	$("#DeptTreeList-div").hide();
	$(".newclsInvalid").removeClass('newclsInvalid');
	$("#WeekDesc,#SelLoc").html("");
	$("#RegConDisList,#ClinicServiceGroupRowId,#BillType").combobox('select',"");
	$("#BillType").combobox("loadData",[])
	$("#MedicalBook,#ShowStopSche").checkbox('setValue',false); 
	$("#SearchAppNo").checkbox('setValue',true); 
	$('#CardNo,#DeptList').val("");
	PageLogicObj.m_PreCardNo="";
	PageLogicObj.m_PreCardType="";
	PageLogicObj.m_PreCardLeaving="";
	PageLogicObj.m_DocRowId="";  
	PageLogicObj.m_deptRowId=""; 
	$("#MarkCode").lookup('setText','');
	var o=$HUI.checkbox("#FreeReg,#FreeCheck,#MedicalBook").setValue(false);
	if(ServerObj.ParaRegType!="APP"){
		$("#AppDate").datebox("setValue","");
		$("#SelDate").html(ServerObj.CurDate);
		$("#WeekDesc").html(ServerObj.CurWeek);
		$("#WeekDesc").prev().html("������ : ");
		if (PageLogicObj.m_curDayRegListDataGrid!=""){
			ClearAllTableData("curDayRegList");
		}
		GetReceiptNo();
		LoadPayMode();
		InitReceiptCount();
		$("#AccAmount").val("");
	}else{
		$("#AppDate").datebox("setValue",ServerObj.DefaultAppDate);
		$("#WeekDesc").html(ServerObj.DefaultAppWeek);
		if (PageLogicObj.m_curDayAppListDataGrid!=""){
			ClearAllTableData("curDayAppList");
		}
		LoadCredType();
	}
	if (PageLogicObj.m_selectedMarkListDataGrid!=""){
		ClearAllTableData("selectedMarkList");
	}
	var $btntext=$("#MarkListShowMode .l-btn-text")[0];
	var text=$btntext.innerText;
	DestoryPannelPopover();
	if (text.indexOf("��ͼ")>=0){
		if (PageLogicObj.m_MarkListDataGrid !=""){
			setTimeout(function(){
				 ClearAllTableData("MarkList");
			});	
		}
	}else{
		var $card=$("div[id*='-marklist-card']");
		if ($card.length>0) $card.parent().remove();
	}
	LoadClinicServiceGroup("");
	$("#CardNo").focus();
}
function MedicalBookClickHandler(){
	setTimeout(function(){
		MedicalBookChange();
	});
}
function MedicalBookChange(){
	var Amount=0;
	if (!PageLogicObj.m_selectedMarkListDataGrid.datagrid) return;
	var Data=PageLogicObj.m_selectedMarkListDataGrid.datagrid("getData");
	for (var j=0;j<Data["rows"].length;j++) {
		var TabPrice=Data["rows"][j]["TabPrice"]; 
		Amount=Amount+(+TabPrice);
	}
	$('#BillAmount').val(Amount);
	var MRFee=ServerObj.MRNoteFee;
	var o=$HUI.checkbox("#MedicalBook");
	if (o.getValue()){
		var BillAmount=$('#BillAmount').val();
		if (BillAmount==""){BillAmount=0}
		BillAmount=(parseFloat(BillAmount)+parseFloat(MRFee)).toFixed(2);
		$("#BillAmount").val(BillAmount);
	}
	var BillAmount=$("#BillAmount").val();
	var PaySum=$("#PaySum").val();
	if (+PaySum>0){
		var ReturnAmount=parseFloat((+PaySum)-BillAmount).toFixed(2); 
		$("#ReturnAmount").val(ReturnAmount);
	}
}
function BPatInfoCollapsHandle(){
	if ($(".extendinfo").css("display")=="none"){
		$(".patinfo-div").removeClass("min-patinfo").addClass("max-patinfo");
		$(".extendinfo").show();
		$("#BPatInfoCollaps .l-btn-text")[0].innerText="����ȫ��";
	}else{
		$(".patinfo-div").removeClass("max-patinfo").addClass("min-patinfo");
		$(".extendinfo").hide();
		$("#BPatInfoCollaps .l-btn-text")[0].innerText="չ��ȫ��";
	}
}
function PaySumKeydown(e){
	var key=websys_getKey(e);
	if (key==13) {
		ReCalculateAmount();
	}
}
function PaySumKeyPress(){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==45){window.event.keyCode=0;return websys_cancel();}
	if (((keycode>47)&&(keycode<58))||(keycode==46)){
		//���������������������������
		if ($("#PaySum").val().length>11) {
			window.event.keyCode=0;
			return websys_cancel();
		}
	}else{
		window.event.keyCode=0;return websys_cancel();
	}
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
			 var text=onedata.split(String.fromCharCode(1))[1].split(String.fromCharCode(2))[0];
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
function SetDefaultTimeRange(){
	var defaultTimeRange="CUR"; //Ĭ�ϵ�ǰ,�Һſ�ʼʱ��ͽ���ʱ���������ǰ��ʱ����Ű��¼����Ҫ��ѯ����
	/*if (ServerObj.ParaRegType!="APP"){
		defaultTimeRange=$.cm({
			ClassName:"web.DHCOPAdmReg", 
			MethodName:"GetCurrentTimeRange",
			dataType:"text"
		},false);
	}*/
	$(".seltimerange").removeClass("seltimerange");
	$("#"+defaultTimeRange+"-TimeRange").addClass("seltimerange");
	$("a[id$='TimeRange']").click(TimeRangeChange);
}
function InitReceiptCount(){
	$.cm({
		ClassName:"web.DHCOPAdmReg", 
		MethodName:"GetReceiptStr",
		RegDate:"", UserRowId:session['LOGON.USERID'],
		dataType:"text"
	},function(ReceiptStr){
		var arr=ReceiptStr.split('^');
		$('#ReceiptCount').val(arr[0]);
	})
}
function GetReceiptNo(){
	var insType = "";
	var p1 = session['LOGON.USERID'] + "^" + "^" + session['LOGON.GROUPID'] + "^" + "R" + "^" + insType + "^" + session['LOGON.HOSPID'];
	var rtn=cspRunServerMethod(ServerObj.GetreceipNO,'SetReceipNO','',p1);
	if (rtn!='0') {
		$.messager.alert("��ʾ","û�з��䷢Ʊ��,���ܽ���!");
		return false;
	}
}
function SetReceipNO(value) {
	var myAry = value.split("^");
	var currNo = myAry[0];
	var title = myAry[4];
	var tipFlag = myAry[5];
	var receiptNo = title + currNo;
	$('#ReceiptNo').val(receiptNo);
	///�������С����С��ʾ��change the Txt Color
	if (tipFlag == "1"){	
		$("#ReceiptNo").addClass("newclsInvalid"); 
	}
}
function CardSearchCallBack(CardNo){
	$("#CardNo").val(CardNo);
	CheckCardNo();
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

function CardNoKeyDownCallBack(myrtn, errMsg){
	if (typeof errMsg == "undefined") errMsg="����Ч";
	$(".newclsInvalid").removeClass('newclsInvalid');
	var myary=myrtn.split("^");
    var rtn=myary[0];
	switch (rtn){
		case "0": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").val(CardNo);
			$("#CardTypeRowID").val(myary[8]);
		    var CardLeaving=myary[3];
		    $("#CardLeaving").val(parseFloat(CardLeaving).toFixed(2));
		    $("#AccAmount").val(parseFloat(CardLeaving).toFixed(2));
			if (ServerObj.ParaRegType!="APP"){
				if(CardLeaving<=0){
					DHCC_SelectOptionByCode("PayMode","CASH");
				}else{
					DHCC_SelectOptionByCode("PayMode","CPP");
				}
			}
			
				SetPatientInfo(PatientNo,CardNo);
			event.keyCode=13;			
			break;
		case "-200": //����Ч
			$.messager.confirm("��ʾ", errMsg+"�Ƿ���ҪΪ�����½�����", function (r) {
				if (r) {
					BRegExpClickHandle();
				} else {
					$("#CardNo").focus();
				}
			});
			return false;
			break;
		case "-201": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").focus().val(CardNo);
			$("#CardTypeRowID").val(myary[8]);
		    var CardLeaving=myary[3];
		    $("#CardLeaving").val(parseFloat(CardLeaving).toFixed(2));
		    $("#AccAmount").val(parseFloat(CardLeaving).toFixed(2));
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
	setTimeout(function(){
		AfterReadCardCheck();
	},500);
}
function AfterReadCardCheck(){
	var CardTypeNew=$("#CardTypeNew").val();
	if (CardTypeNew.indexOf("���֤")>=0){
		var myInfo=DHCWCOM_PersonInfoRead("1");
		var myary=myInfo.split("^");
		if (myary[0]=="0"){
			var ReadName=myary[1].split("<Name>")[1].split("</Name>")[0]
			var Name=$("#Name").val();
			if (ReadName!=Name){
				$.messager.alert("��ʾ","֤������<font style='color:red'>"+ReadName+"</font>��ϵͳ����<font style='color:blue'>"+Name+"</font>����!","info",function(){
					var CardNo=$("#CardNo").val();
					BClearHandle();
					var lnk = "doc.patientinfoupdate.hui.csp?CardNo="+CardNo;
	                lnk=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(lnk):lnk;
					var $code ="<iframe width='99%' height='99%' scrolling='auto' frameborder='0' src='"+lnk+"'></iframe>" ;
					createModalDialog("Project","�޸Ļ�����Ϣ", PageLogicObj.dw+200, PageLogicObj.dh,"icon-write-order","",$code,"");
					$('#CardNo').focus();	
				});
			}
		}
	}
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
	if (!CheckBeforeCardNoChange()) return false;
    var PatientNo=$("#PatientNo").val();
	
	//�жϵǼǺ��Ƿ������Ч��,�������Ч���������ʾ
    var CardNoStr=$.cm({
	    ClassName : "web.DHCOPAdmReg",
	    MethodName : "GetCardNoByPatientNo",
	    dataType:"text",
	    PatientNo:PatientNo,
	    HospId:session['LOGON.HOSPID']
    },false);
    var CardNo=CardNoStr.split("^")[0];
	if (CardNo=="") {
		var PatientID=CardNoStr.split("^")[3];
		if (PatientID=="") {
			$.messager.alert("��ʾ",PatientNo+" �õǼǺ��޶�Ӧ����!","info",function(){
				$("#PatientNo").val("").focus();
			})
		}else{
			var UnitRegNo=$.cm({
			    ClassName : "web.DHCOPAdmReg",
			    MethodName : "GetUnitedRegNo",
			    dataType:"text",
			    PatientID:PatientID,
		    },false);
			if (UnitRegNo!=""){
				$.messager.alert("��ʾ",PatientNo+" �õǼǺ��ѱ��ϲ��������ǼǺ�Ϊ<font style='color:red'>"+UnitRegNo+"</font>!","info",function(){
					$("#PatientNo").val("").focus();
				})
				return false;
			}
			$.messager.confirm("ȷ�ϵ�����",PatientNo+" �õǼǺ��޶�Ӧ������Ϣ,�Ƿ��½���?",function(r){
				if (r) {
					$("#PatientNo").val(PatientNo);
					$("#CardNo,#Name,#Sex,#Age").val(""); 
					BRegExpClickHandle(PatientNo);
				}else{
					$("#PatientNo").focus();
				}
			});
		}
		return false;
	}
	var NewCardTypeRowId=CardNoStr.split("^")[1];
	$("#CardTypeNew").val(CardNoStr.split("^")[2]);
	$("#CardTypeRowID").val(NewCardTypeRowId);
	$("#CardNo").val(CardNo);
	$("#CardLeaving").val(CardNoStr.split("^")[8]);
	SetPatientInfo(PatientNo,CardNo);
	//$("#BillAmount,#PaySum,#ReturnAmount").val("0.00");
	if ((PageLogicObj.m_RegJumpFlag=="")||(CardNo=="")) return true;
	//������ת���ҺŽ���ʱУ��һ�¿���Ϣ�������ظ���ֵ������Ϣ
	var myrtn=DHCACC_GetAccInfo("",CardNo,"","",CardNoKeyDownNotSetPatientInfoCallBack);
	return true;
}
function CardNoKeyDownNotSetPatientInfoCallBack(myrtn, errMsg){
	if (typeof errMsg == "undefined") errMsg="����Ч";
	$(".newclsInvalid").removeClass('newclsInvalid');
	var myary=myrtn.split("^");
    var rtn=myary[0];
	switch (rtn){
		case "0": //����Ч���ʻ�
		    var CardLeaving=myary[3];
		    $("#CardLeaving").val(parseFloat(CardLeaving).toFixed(2));
		    $("#AccAmount").val(parseFloat(CardLeaving).toFixed(2));
			if (ServerObj.ParaRegType!="APP"){
				if(CardLeaving<=0){
					DHCC_SelectOptionByCode("PayMode","CASH");
				}else{
					DHCC_SelectOptionByCode("PayMode","CPP");
				}
			}
			//SetPatientInfo(PatientNo,CardNo);
			event.keyCode=13;			
			break;
		case "-200": //����Ч
			$.messager.confirm("��ʾ", errMsg+"�Ƿ���ҪΪ�����½�����", function (r) {
				if (r) {
					BRegExpClickHandle();
				} else {
					$("#CardNo").focus();
				}
			});
			return false;
			break;
		case "-201": //����Ч���ʻ�
		    var CardLeaving=myary[3];
		    $("#CardLeaving").val(parseFloat(CardLeaving).toFixed(2));
		    $("#AccAmount").val(parseFloat(CardLeaving).toFixed(2));
			if (ServerObj.ParaRegType!="APP"){
				DHCC_SelectOptionByCode("PayMode","CASH");
			}
			//SetPatientInfo(PatientNo,CardNo);
			event.keyCode=13;
			break;
		default:
	}
}
function TimeRangeChange(e){
	$(".seltimerange").removeClass("seltimerange");
	var id=e.currentTarget.id;
	$("#"+id).addClass("seltimerange");
	LoadMarkList();
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
function SetPatientInfo(PatientNo,CardNo){
	if (!CheckBeforeCardNoChange()) return false;
	if (PatientNo!='') {
		var AccAmount= $("#AccAmount").val();
		var CardTypeNew=$("#CardTypeNew").val();
		var CardTypeRowID=$("#CardTypeRowID").val();
		var CardLeaving=$("#CardLeaving").val();
		var ReceiptNo=$("#ReceiptNo").val();
		var ReceiptCount=$("#ReceiptCount").val();
		var PatientID=$("#PatientID").val();
		ClearPatInfo();
		$("#SelLoc").html("");
		var TemporaryCardFlag=CheckTemporaryCard(CardNo, CardTypeRowID);
		var IsTempCard=TemporaryCardFlag.split("^")[0];
		var DiscDate=TemporaryCardFlag.split("^")[1];
		if (IsTempCard=="Y"){
			if (ServerObj.ParaRegType=="APP") {
				$.messager.alert("��ʾ","��ʱ�����ܽ���ԤԼ!")
				return false;
			}
			if (DiscDate>0){
				$.messager.alert("��ʾ","��ʱ���ѹ��ܹҺ���Ч����!","info",function(){
					$("#CardNo").focus();
				})
				return false;
			}
			if (ServerObj.ParaRegType=="Reg") {
				dhcsys_alert("��ʱ��ֻ�ܹҼ����!")
			}
		}
		/*var IsDeceased=$.cm({
		    ClassName : "web.PAPerson",
		    MethodName : "CheckDeceased",
		    dataType:"text",
		    PatientID:PatientID,
	    },false);
	    if (IsDeceased=="Y"){
		    $.messager.alert("��ʾ","�����ѹ�,������Һ�!")
			return false;
		}*/
		$("#PatientNo").val(PatientNo);
		$("#CardNo").val(CardNo);
		$("#AccAmount").val(AccAmount);
		$("#CardTypeNew").val(CardTypeNew);
		$("#CardTypeRowID").val(CardTypeRowID);
		$("#CardLeaving").val(CardLeaving);
		$("#ReceiptNo").val(ReceiptNo);
		$("#ReceiptCount").val(ReceiptCount);
		$("#PatientID").val(PatientID);
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
		var NeedAddPatInfo=Patdetail[32]
		if (NeedAddPatInfo!=""){
			$.messager.alert("��ʾ","����<font style='color:red'>"+NeedAddPatInfo+"</font>����Ϊ�գ������ƣ�","info",function(){
				var CardNo=$("#CardNo").val();
				BClearHandle();
				var lnk = "doc.patientinfoupdate.hui.csp?CardNo="+CardNo;
                lnk=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(lnk):lnk;
				var $code ="<iframe width='99%' height='99%' scrolling='auto' frameborder='0' src='"+lnk+"'></iframe>" ;
				createModalDialog("Project","�޸Ļ�����Ϣ", PageLogicObj.dw+200, PageLogicObj.dh,"icon-write-order","",$code,"");
				$('#CardNo').focus();
			})
			return false;
		}
		$("#Name").val(Patdetail[0]);
		$("#Age").val(Patdetail[1]);
		$("#Sex").val(Patdetail[2]);
		//���ﲡ���ź�סԺ������
		$("#OPMRN").val(Patdetail[3]);
		$("#IPMRN").val(Patdetail[4]);
		$("#PatCat").val(Patdetail[5]);
		$("#PatientID").val(Patdetail[6]);
		$("#IDCardNo").val(Patdetail[7]);
		$("#PatientNo").val(Patdetail[9]);
		$("#AppBreakCount").val(Patdetail[10]);
		//ҽ����
		$("#PatYBCode").val(Patdetail[11]);
		//ҽ������
		//$("YBType",Patdetail[12]);
		$("#PoliticalLevel").val(Patdetail[19]);
		$("#SecretLevel").val(Patdetail[20]);		
		$("#TelH").val(Patdetail[21]);
		$("#PAPERCountry").val(Patdetail[22]);
		$("#Address").val(Patdetail[23]);
		$("#CredType").val(Patdetail[24]);
		$("#CredNo").val(Patdetail[25]);
		var PatInIPAdmission=Patdetail[26];
		var IsDeceased=Patdetail[27];
		if (IsDeceased =="Y") {
			$.messager.alert("��ʾ","�����ѹ�!","info",function(){
				ClearPatInfo();
				$("#CardNo").focus();
			})
			return false;
		}
		var AgeLimitInfo=Patdetail[28];
		var CheckObj={"TelNo":Patdetail[21],"IDTypeID":Patdetail[30],"IDCardNo":Patdetail[25]};
		var RetObj=DHCWeb_IsTelOrMobile(CheckObj);
		if ((AgeLimitInfo!="")||(RetObj.Flag!="0")){
			AgeLimitInfo=AgeLimitInfo||RetObj.Desc;
			$.messager.alert("��ʾ",AgeLimitInfo,"info",function(){
				var CardNo=$("#CardNo").val();
				BClearHandle();
				var lnk = "doc.patientinfoupdate.hui.csp?CardNo="+CardNo;
                lnk=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(lnk):lnk;
				var $code ="<iframe width='99%' height='99%' scrolling='auto' frameborder='0' src='"+lnk+"'></iframe>" ;
				createModalDialog("Project","�޸Ļ�����Ϣ", PageLogicObj.dw+200, PageLogicObj.dh,"icon-write-order","",$code,"");
				$('#CardNo').focus();
			})
			return false;
		}
		var HasPendPayOrdFlag=Patdetail[29];
		new Promise(function(resolve,rejected){
			if (PatInIPAdmission==1){
				$.messager.alert("��ʾ","��������סԺ!","",function(){
					resolve();
				});
			}else {
				resolve();
			}
		}).then(function(){
			return new Promise(function(resolve,rejected){
	            if (HasPendPayOrdFlag==1){
		            $.messager.alert("��ʾ","�û�����δ�����������ƺ󸶷ѷ��ã�����©�ѷ���!","",function(){
			            resolve();
		            })
		        }else {
			        resolve();
		        }
			})
		}).then(function(){		
			PageLogicObj.m_PreCardNo=$("#CardNo").val();
			PageLogicObj.m_PreCardType=$("#CardTypeNew").val();
			PageLogicObj.m_PreCardLeaving=$("#CardLeaving").val();
			//if (PageLogicObj.m_PreCardNo==""){PageLogicObj.m_PreCardNo=$("#CardNo").val();}
			var PatientID=Patdetail[6];
			var BillTypeData=$.cm({
				ClassName:"web.DHCOPAdmReg",
				MethodName:"GetBillTypeListBroker",
				dataType:"text",
				JSFunName:"GetBillTypeToHUIJson",
				ListName:"",
				PatientID:PatientID
			},false);
			var cbox = $HUI.combobox("#BillType", {
					valueField: 'id',
					textField: 'text', 
					editable:true,
					data: JSON.parse(BillTypeData),
					onSelect:function(record){
						LoadRegConDisList();
						$("#selectedMarkList").datagrid("uncheckAll");
						var Data=$("#selectedMarkList").datagrid("getRows");
						for (var i=Data.length-1;i>=0;i--){
							$("#selectedMarkList").datagrid("selectRow",i);
							DelSelMarkListRow();
						}
						LoadMarkList();
						GetApptInfo(PatientID);
						MedicalBookClickHandler();
					}
			 });
			if (ServerObj.ParaRegType=="APP"){
				var BlackFlag=$.cm({
					ClassName:"web.DHCRBAppointment",
					MethodName:"GetLimitAppFlag",
					dataType:"text",
					PatientId:PatientID,
					IDCardNo:""
				},false);
				var BlackFlag=BlackFlag.split("^")[0];
				//var PBTypeExeResult=BlackFlag.split("^")[2]; //�ܿش���ִ�н��
				if (BlackFlag==1){
				      $.messager.alert("��ʾ","������Ч��������¼,������ԤԼ","info",function(){
					      $("#Name").addClass("blackname");
					  })
				      return false;
				}else{
					$("#Name").removeClass("blackname");
				}
			}
			/*
			//���⻼�߹��� ����ֵ�����ܿش���ִ�н��
			var SpecPatType=$.cm({
				ClassName:"web.DHCSpecPat",
				MethodName:"GetSpecPatTypeByCredNo",
				dataType:"text",
				PatientId:PatientID
			},false);*/
			//ˬԼ����
			if (ServerObj.ParaRegType!="APP"){
				var AppBreakInfo=$.cm({
					ClassName:"web.DHCRBAppointment",
					MethodName:"GetAppBreakInfo",
					dataType:"text",
					PatientID:PatientID,
				},false);
				if (AppBreakInfo!=""){
					$.messager.alert("��ʾ",AppBreakInfo);
				}
			}
			//ԤԼ����
			var AppSerialNo=$("#AppSerialNo").val();
			if (AppSerialNo==undefined) AppSerialNo="";
			if (AppSerialNo!="") {
				AppSerialNoBlurHandler();
			}else{
				GetApptInfo(PatientID);
			}
			if (ServerObj.ParaRegType!="APP"){
				if (PageLogicObj.m_selectedMarkListDataGrid==""){
					PageLogicObj.m_selectedMarkListDataGrid=InitselectedMarkListDataGrid();
				}
				if (PageLogicObj.m_curDayRegListDataGrid==""){
					PageLogicObj.m_curDayRegListDataGrid=curDayRegListDataGrid();
				}else{
					ClearAllTableData("curDayRegList");
				}
				//���Ӽ���ּ�
				GetEmChkInfo(PatientID);
				//���ӵ����ѹҺż�¼��ѯ
				GetCurDateRegList();
			}
			var rtn=$.cm({
			    ClassName : "web.DHCOPAdmReg",
			    MethodName : "GetAdmRecord",
			    dataType:"text",
			    PatientID:PatientID
		    },false);
		    var o=$HUI.checkbox("#MedicalBook");
			if(rtn==0){
				if (!o.getValue()){
					o.setValue(true);
				}else{
					MedicalBookChange();
				}
				$HUI.checkbox("#NeedCardFee").setValue(true);
			}else{
				if (o.getValue()){
					o.setValue(false);
				}else{
					MedicalBookChange();
				}
				$HUI.checkbox("#NeedCardFee").setValue(false);
			}
			LoadMarkList();
			if(PatientID!=""){
				LoadRegConDisList()
			}
			$("#DeptList").focus();
			///dts���
			DTSLog.AddOnelog("1633642142285041664",PatientID,PatientID,"",session['LOGON.USERCODE'])
		})
	} catch(e) {
		$.messager.alert("��ʾ",e.message);
	};
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
function GetEmChkInfo(PatientID){
	var TimeRangeRowId=$(".seltimerange")[0].id.split("-")[0];
	if (TimeRangeRowId=="ALL") TimeRangeRowId="";
	var AdmReason=$('#BillType').combobox('getValue');
	var RegConDisId="";
	if(ServerObj.ParaRegType!="APP"){
		RegConDisId=$("#RegConDisList").combobox("getValue");
	}
	var EmChkInfoRtn=$.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"GetEmChkInfo",
		dataType:"text",
		PatientID:PatientID, TimeRangeRowId:TimeRangeRowId, AdmReason:AdmReason, GroupRowId:session['LOGON.GROUPID'],
		RegConDisId:RegConDisId,
		dataType:"text"
	},false);
	if (EmChkInfoRtn!=""){
		var BillAmount=$("#BillAmount").val();
		var InfoArr=EmChkInfoRtn.split("#")
		for(var i=0;i<InfoArr.length;i++){
			var OneListInfo=InfoArr[i];
			var InfoArr1=OneListInfo.split("^")
			var BillAmount=parseFloat(BillAmount)+parseFloat(InfoArr1[2]);
			var PCLRowID="";
			if (OneListInfo.split('^').length>=16){
				PCLRowID=OneListInfo.split('^')[15];
			}
			var RepeatFlag=CheckRowDataRepeat("TabPCLRowID",PCLRowID);
			if (RepeatFlag==1) continue;
			AddRegToTable(OneListInfo)
		}
		$("#BillAmount").val(BillAmount);
	}
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
function CheckBeforeCardNoChange(){
	if (PageLogicObj.m_selectedMarkListDataGrid==""){
		PageLogicObj.m_selectedMarkListDataGrid=InitselectedMarkListDataGrid();
	}
	//��֤�Ƿ���δ��ɵĹҺ�
	var Data=PageLogicObj.m_selectedMarkListDataGrid.datagrid("getData");
	if (Data["rows"].length>=1){
		$.messager.alert("��ʾ","���������һ�����ߵĹҺ�!","info",function(){
			$("#CardNo").val(PageLogicObj.m_PreCardNo);
			$("#CardTypeNew").val(PageLogicObj.m_PreCardType);
			$("#CardLeaving").val(PageLogicObj.m_PreCardLeaving);
		});
		return false;
	}
	return true;
}
function ClearPatInfo(){
	var $input=$(":input:text");
	for (var i=0;i<$input.length;i++){
		$("#"+$input[i]["id"]).val("");
	}
	$("#PatientID,#CardTypeRowID").val('');
	$("#Name").removeClass("blackname");
	SetDefaultAppDate();
}
function SetDefaultAppDate(){
	if ((ServerObj.DefaultAppDate!="")&&(ServerObj.ParaRegType=="APP")){
		$('#AppDate').datebox('setValue',ServerObj.DefaultAppDate);
		$("#SelDate").html(ServerObj.DefaultAppDate);
		$("#WeekDesc").html(ServerObj.DefaultAppWeek);
	}	
}
function AppointClickHandler(){
	var AppStFlag=ChekAppSatrtTime();
	if (AppStFlag!="Y") return;
	var Data=PageLogicObj.m_selectedMarkListDataGrid.datagrid("getData");
	if (Data["rows"].length==0){
		$.messager.alert("��ʾ","û��ѡ��Һ���Ϣ!");
		return false;
	}
	//����ԤԼ�Ƿ�ҪԤ�ȷ����,ȡ�ŵĴ�����ͬһ������
	var PatientID=$('#PatientID').val();
	var AdmReason="";
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];
	//�ж��Ƿ������Ч�ĺ�������¼
	if(!CheckHaveBlack(PatientID,"")) return false;
	var AppPatCredNo=$('#AppPatCredNo').val();
	var AppPatName=$('#AppPatName').val();
	var AppPatTel=$('#AppPatTel').val();
	var AppPatAddress=$('#AppPatAddress').val();
	var AppPatInfo="";
	var AppPatType=$('#AppPatType').combobox('getValue');
	var AppPatCredType=$('#AppPatCredType').combobox('getValue').split("^")[0];
	var CommonPatientID=$.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"GetCommonPatientID",
		dataType:"text"
	},false);
	var CommonPatientID="^"+CommonPatientID+"^"
	if(CommonPatientID.indexOf("^"+PatientID+"^")!="-1"){
		if((AppPatName=="")||(AppPatCredNo=="")||(AppPatTel=="")){
		  	$.messager.alert("��ʾ","�޿�ԤԼ�Ĳ��˱�����д����ԤԼ��Ϣ!");
		  	return false;
	  	}else{
		  	if(!CheckHaveBlack("",AppPatCredNo)) return false;
		  	if(AppPatCredNo!=""){
			  	var myIDrtn=IsCredTypeID();
				if (myIDrtn){
				    var myIsID=DHCWeb_IsIdCardNo(AppPatCredNo);
					if (!myIsID){
						$("#AppPatCredNo").focus();
						return false;
					}
				}
		  	}
		  	if (!CheckTelOrMobile(AppPatTel,"AppPatTel","ԤԼ��")) return false;
		  	AppPatInfo=AppPatName+"$"+AppPatCredNo+"$"+AppPatTel+"$"+AppPatAddress+"$"+AppPatType+"$"+AppPatCredType
	    }
  	}else{
	  	AppPatInfo=AppPatName+"$"+AppPatCredNo+"$"+AppPatTel+"$"+AppPatAddress+"$"+AppPatType+"$"+AppPatCredType
	}
	var ExpStr=PageLogicObj.m_ApptTypeCode;
	try {
		for (var loop=0;loop<Data["rows"].length;loop++) {
			var TabASRowId=Data["rows"][loop]["TabASRowId"];
			var TabQueueNo=Data["rows"][loop]["TabSeqNo"];
			var TimeRangeStr=Data["rows"][loop]["TabTimeRange"];
			var TabClinicGroupDr=Data["rows"][loop]["TabClinicGroupDr"];
			var retstr=$.cm({
				ClassName:"web.DHCOPAdmReg",
				MethodName:"OPAppBroker", 
				dataType:"text",
				itmjs:"", itmjsex:"", PatientID:PatientID,ASRowId:TabASRowId,
				QueueNo:TabQueueNo, UserRowId:UserID, AppPatInfo:AppPatInfo, MethodCode:"",TimeRangeStr:TimeRangeStr,
				HospitalID:session['LOGON.HOSPID'],ClinicGroupId:TabClinicGroupDr,ExpStr:ExpStr
			},false);
			var retArr=retstr.split("^")
			var ret=retArr[0]
			var AppARowid=retArr[1]
			if (ret=="0"){
				var AppRowid=retArr[1];
                AppPrintOut(AppRowid);
			}else{
				if(ret=="-201"){ret="���˺���ԤԼ��"}
				else if(ret=="-202"){ret="���˺�û���Ű��¼"}
				else if(ret=="-203"){ret="���˺���ֹͣ���߱�����"}
				else if(ret=="-204"){ret="��ԤԼ������Ϣ����Ϊ��!"}
				else if(ret=="-301"){ret="���˲��˳���ÿ��Һ��޶�"}
				else if(ret=="-302"){ret="���˲��˳���ÿ���һ��ҽ�����޶�"}
				else if(ret=="-303"){ret="���˲��˳���ÿ��ÿ�����ͬ�����޶�"}	
				$.messager.alert("��ʾ","ԤԼʧ��!"+ret,"info",function(){
					PageLogicObj.m_selectedMarkListDataGrid.datagrid('deleteRow',loop);
					$('#CardNo').focus();
				});
				return false;
			}
		}
		$.messager.popover({msg: 'ԤԼ�ɹ�!',type:'success',timeout: 1000});
		BClearHandle();
		$('#CardNo').focus();
	}catch(e){$.messager.alert("��ʾ",e.message)}			
}
function CheckTelOrMobile(telephone,Name,Type){
	if (DHCC_IsTelOrMobile(telephone)) return true;
	if (telephone.indexOf('-')>=0){
			$.messager.alert("��ʾ",Type+"�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,�������ӷ���-������,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
			websys_setfocus(Name);
	        return false;
	}else{
		if(telephone.length!=11){
			$.messager.alert("��ʾ",Type+"��ϵ�绰�绰����ӦΪ��11��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+"�����ڸúŶε��ֻ���,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}
	return true;
}
function CancelApp(APPTRowId){
	if (APPTRowId==''){return false();}
	var UserRowId=session['LOGON.USERID']
	var ret=$.cm({ 
		ClassName:"web.DHCRBAppointment",
		MethodName:"CancelAppointment", 
		dataType:"text",
		APPTRowId:APPTRowId, UserRowId:UserRowId
	},false);	
	if (ret=="0"){
		$.messager.alert("��ʾ","ȡ��ԤԼ�ɹ�!","info",function(){
			var index=PageLogicObj.m_curDayAppListDataGrid.datagrid('getRowIndex',APPTRowId);
			PageLogicObj.m_curDayAppListDataGrid.datagrid('deleteRow',index);
		});
	}else{
		if (ret=="-201") {
			$.messager.alert("��ʾ","��ԤԼ��ȡ��!");
			return false;
		}
		if (ret=="-202") {
			$.messager.alert("��ʾ","��ԤԼ��ȡ��!");
			return false;
		}
		$.messager.alert("��ʾ","ȡ��ԤԼʧ��!"+"ErrCode:"+ret);
		return false;
	}
}
function ChekAppSatrtTime(){
	var RtnAppFlag=$.cm({ 
		ClassName:"web.DHCOPAdmReg",
		MethodName:"CheckAppRegTime", 
		dataType:"text"
	},false);	
	if (RtnAppFlag=="N"){
		$.messager.alert("��ʾ","��δ��ԤԼ��ʼʱ��!");
	}
	return RtnAppFlag
}
function SetPassCardNo(CardNo,CardType){
	$("#CardNo").val(CardNo);
	$("#CardTypeNew").val(CardType);
	//combo_CardType.setComboValue(CardType);
	CheckCardNo();
}
///��־����
function SavePrescEventLog(EpisodeID){
	try{
		var EventLogData=$.cm({ 
			ClassName:"web.DHCDocPrescript",
			MethodName:"GetPrescEventLogInfo", 
			dataType:"text",
			EpisodeID:EpisodeID
		},false);
		var infoarr=EventLogData.split("^");
		var ModelName="DHCOPADMREG";
		var Condition="{RegNo:"+infoarr[0]+"}";
    	var Content="{EpisodeId:"+infoarr[1]+"}";
		var SecretCode=infoarr[2];
		if (SecretCode!="") {
			var EventLogRowId=$.cm({ 
				ClassName:"web.DHCEventLog",
				MethodName:"EventLog", 
				dataType:"text",
				ModelName:ModelName, Condition:Condition, Content:Content, SecretCode:SecretCode
			},false);
		}
	} catch (e) { $.messager.alert("��ʾ",e.message);}
    return 0;
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function RemClickHandle(){
	var row=PageLogicObj.m_PilotProListTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ŀ!");
		return false;
	}
	var PPRowId=row["TPPRowId"];
	var PPDesc=row["TPPDesc"];
	var src="docpilotpro.rem.hui.csp?PPRowId="+PPRowId;
    src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
	var $code ="<iframe width='99%' height='99%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Project","ҩ����Ŀ:"+PPDesc, PageLogicObj.dw, PageLogicObj.dh,"icon-write-order","",$code,"");
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
	        if (_title=="Ԥ�����ֵ"){
		        PatientNo=$("#PatientNo").val();
		        if (PatientNo!=""){
					CheckPatientNo();
					PageLogicObj.m_PreCardNo=$("#CardNo").val();
					PageLogicObj.m_PreCardType=$("#CardTypeNew").val();
					PageLogicObj.m_PreCardLeaving=$("#CardLeaving").val();
		        }
		    }
	    }
    });
}
function GetDeptRowId(){
	var id=PageLogicObj.m_deptRowId;;
	if ($("#DeptList").lookup('getText')==""){
		return "";
	}
	if (id==undefined) id="";
	return id;
}
function destroyDialog(id){
   //�Ƴ����ڵ�Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
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
function ChangePayMode(){
	var PayModeData=$("#PayMode").combobox('getData');
	var index=$.hisui.indexOfArray(PayModeData,"CTPMRowID",ServerObj.CashPayModeID);
	if (index>=0){
		var sureflag=dhcsys_confirm("�ʻ�����,�Ƿ��л����ֽ�֧����ʽ����������?")
		if(sureflag){
			$("#PayMode").combobox("select",ServerObj.CashPayModeID);
		}else{
			return false;	
		}
	}else{
		$.messager.alert("��ʾ","�ʻ�����,��ѡ������֧����ʽ!");
		return false;
	}
	return true;
}
function AppPrintOut(AppRowid)
{
	try{
		var AppPrintData=tkMakeServerCall('DHCDoc.Common.pa','GetAppPrintData',AppRowid)
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAppointPrint");
		var PrintDataArySum=eval(AppPrintData)
		var PrintDataAry=PrintDataArySum[0]
		var MyPara = "" + String.fromCharCode(2);
		for (Element in PrintDataAry){
			MyPara=MyPara +"^"+ Element + String.fromCharCode(2) + PrintDataAry[Element];
		}
		DHC_PrintByLodop(getLodop(),MyPara,"","","");	
	}catch(e){alert(e.message);}
	/*try{
        var AppPrintData=tkMakeServerCall('web.DHCOPAdmReg','GetAppPrintData',AppRowid)
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAppointPrint");
		var AppPrintArr=AppPrintData.split("^");
		var CardNo=AppPrintArr[0];
		var PapmiDr=AppPrintArr[1];
		var PapmiName=AppPrintArr[2];
		var PapmiNo=AppPrintArr[13];
		//var PapmiDOB=AppPrintArr[3];
		var PamiSex=AppPrintArr[3];
		var QueueNo=AppPrintArr[4];
		var Locdesc=AppPrintArr[6];
		var Docdesc=AppPrintArr[7];
		var AppDate=AppPrintArr[8];
		var AppTime=AppPrintArr[9];
		AppTime=AppDate+" "+AppTime
		var AdmDate=AppPrintArr[10];
		var TimeRangeInfo=AppPrintArr[14];
		var UserSS=AppPrintArr[15];
		var Price=AppPrintArr[17];
		var SessionTypeDesc=AppPrintArr[18];
		var ASDateWeek=AppPrintArr[19];
        var ArriveEndDate=AppPrintArr[20];
        var ArriveEndTime=AppPrintArr[21];
        var listitem1=AppPrintArr[22];
		var PDlime=String.fromCharCode(2);
		var MyPara="CardNo"+PDlime+CardNo+"^"+"PatNo"+PDlime+PapmiNo+"^"+"PatName"+PDlime+PapmiName+"^"+"RegDep"+PDlime+Locdesc;
		var MyPara=MyPara+"^"+"MarkDesc"+PDlime+Docdesc+"^"+"PatSex"+PDlime+PamiSex+"^"+"SeqNo"+PDlime+QueueNo+"^"+"APPDate"+PDlime+AppTime;
		var MyPara=MyPara+"^"+"AdmDate"+PDlime+AdmDate+"^"+"UserCode"+PDlime+UserSS+"^"+"AdmTimeRange"+PDlime+TimeRangeInfo;
		var MyPara=MyPara+"^"+"APPCompDate"+PDlime+AppTime+"^"+"SessionType"+PDlime+SessionTypeDesc+"^Total"+PDlime+Price+"^ArriveEndDateTime"+PDlime+ArriveEndDate+" "+ArriveEndTime;
		var MyPara=MyPara+"^"+"listitem2"+PDlime+listitem1
		//var myobj=document.getElementById("ClsBillPrint");
		//PrintFun(myobj,MyPara,"");
		DHC_PrintByLodop(getLodop(),MyPara,"","","");	
	}catch(e){alert(e.message);}*/
}
function GetErrMsg(ErrCode){
	var errmsg="";
	if (ErrCode=="-201")  errmsg="���ɾ����¼ʧ��!";
	else if (ErrCode=="-202")  errmsg="ȡ�Ų��ɹ�!";
	else if (ErrCode=="-204")  errmsg="ԤԼ������Ϣ����Ϊ��!";
	else if (ErrCode=="-2121") errmsg="����ԤԼ״̬ʧ��!";
	else if (ErrCode=="-2122") errmsg="ϵͳæ,���Ժ�����!";
	else if (ErrCode=="-206")  errmsg="����Һŷ�ҽ��ʧ��!";
	else if (ErrCode=="-207")  errmsg="��������ҽ��ʧ��!";
	else if (ErrCode=="-208")  errmsg="������շ�ҽ��ʧ��!";
	else if (ErrCode=="-209")  errmsg="����ԤԼ��ҽ��ʧ��!";
	else if (ErrCode=="-210")  errmsg="�Ʒ�ʧ��!";
	else if (ErrCode=="-211")  errmsg="����Һż�¼ʧ��!";
	else if (ErrCode=="-212")  errmsg="����кŶ���ʧ��!";
	else if (ErrCode=="-301")  errmsg="����ÿ��ÿ��ɹ��޶�,�����ٹҺŻ�ԤԼ!";
	else if (ErrCode=="-302")  errmsg="����ÿ��ÿ��ɹ���ͬ�ŵ��޶�!";
	else if (ErrCode=="-303")  errmsg="����ÿ��ÿ��ɹ���ͬ���Һŵ��޶�!";
	else if (ErrCode=="-401")  errmsg="��û�е��Һ�ʱ��!";
	else if (ErrCode=="-402")  errmsg="��δ��ԤԼʱ��!";
	else if (ErrCode=="-403")  errmsg="��δ���Ӻ�ʱ��!";
	else if (ErrCode=="-404")  errmsg="�Ѿ����˴��Ű��¼����ʱ���!";
	else if (ErrCode=="-2010") errmsg="����ҽ���Һ���Ϣʧ��!";
	else if (ErrCode=="-304")  errmsg="����ÿ��ÿ����ͬʱ��ͬ����ͬҽ���޶�!";
	else if (ErrCode=="-405")  errmsg="��ȥ�Һ����ý���ά�����ҽ��!";
	else if (ErrCode=="-406")  errmsg="�ѹ��ҺŽ���ʱ��!";
	else if (ErrCode=="-213")  errmsg="�Ѿ�����ֹͣ�Һ�,������Һż�ȡ��";
	else if (ErrCode=="-214")  errmsg="û����Ҫ�����ҽ�������ʵ�Ƿ����������û�ά���Һ����ҽ��";
	return errmsg;
}
function LoadCredType(){
	$.m({
		ClassName:"web.UDHCOPOtherLB",
		MethodName:"ReadCredTypeExp",
		JSFunName:"GetCredTypeToHUIJson",
		ListName:""
	},function(Data){
		var cbox = $HUI.combobox("#AppPatCredType", {
				valueField: 'id',
				textField: 'text', 
				editable:false,
				blurValidValue:true,
				data: JSON.parse(Data)
		 });
	});
}
function IsCredTypeID()
{
	var myval=$("#AppPatCredType").combobox("getValue");
	var myary = myval.split("^");
	if (myary[1]==PageLogicObj.m_IDCredTypePlate){
		return true;
	}else{
		return false;
	}
}
function InitCommonCardWin(){
	$("#CommonCardChoose").empty();
	retArry=ServerObj.CommonCardNoStr.split("&");
	htmlstr='<table class="search-table">';
	for (var i=0; i<retArry.length; i++){
		var CommoncardCardNo="'"+retArry[i]+"'"
		htmlstr=htmlstr+'<tr><td colSpan="" style="padding-left:10px;" ><a class="hisui-linkbutton" id="Commoncard'+retArry[i]+'" onclick="CommonCardclickRadio('+CommoncardCardNo+')" data-options="iconCls:\'icon-w-card\'" group="">'+retArry[i]+'</a></td></tr>'
	}
	htmlstr=htmlstr+'</table>';
	$("#CommonCardChoose").append(htmlstr);
	for (var i=0; i<retArry.length; i++) {
		$.parser.parse($("#Commoncard"+retArry[i]).parent())
	}
}
function CommonCardclickRadio(ChoseCommonCardNo){
		$('#CommonCardWin').window('close');	
		var PatientNomyrtn=$.cm({
			ClassName:"web.DHCOPAdmReg",
			MethodName:"GetCommonCardNoandPatientNo",
			dataType:"text",
			ChoseCommonCardNo:ChoseCommonCardNo
		},false);
		if (PatientNomyrtn==""){
			$.messager.alert("��ʾ","��ά��������.");       				
			return false;
		}else{
			var CardNo=PatientNomyrtn.split("^")[0]
			var PatientNo=PatientNomyrtn.split("^")[1];
			var CardTypeNew=PatientNomyrtn.split("^")[2];
			var PatInfoStr=$.cm({
			    ClassName : "web.DHCOPAdmReg",
			    MethodName : "GetPatDetailBroker",
			    dataType:"text",
			    itmjs:"",
			    itmjsex:"GetPatDetailToHUI",
			    val:PatientNo,
		    },false);
		    var Patdetail=PatInfoStr.split("^");
		    $("#CardNo").val(CardNo);
		    $("#CardTypeNew").val(CardTypeNew);
			$("#Name").val(Patdetail[0]);
			$("#Age").val(Patdetail[1]);
			$("#Sex").val(Patdetail[2]);
			//���ﲡ���ź�סԺ������
			$("#OPMRN").val(Patdetail[3]);
			$("#IPMRN").val(Patdetail[4]);
			//ҽ����
			$("#PatYBCode").val(Patdetail[11]);
			//ҽ������
			//$("YBType",Patdetail[12]);
			$("#PoliticalLevel").val(Patdetail[19]);
			$("#SecretLevel").val(Patdetail[20]);
			$("#TelH").val(Patdetail[21]);
			$("#PAPERCountry").val(Patdetail[22]);
			$("#Address").val(Patdetail[23]);
			var PatCat=Patdetail[5];
			$("#PatCat").val(PatCat);
			$("#PatientID").val(Patdetail[6]);
			$("#IDCardNo").val(Patdetail[7]);
			$("#PatientNo").val(Patdetail[9]);
			$("#AppBreakCount").val(Patdetail[10]);
			PatientID=Patdetail[6]
			if (PageLogicObj.m_curDayAppListDataGrid==""){
				PageLogicObj.m_curDayAppListDataGrid=curDayAppListDataGrid();
			}else{
				ClearAllTableData("curDayAppList");
			}
			PageLogicObj.m_PreCardNo=$("#CardNo").val();
			PageLogicObj.m_PreCardType=$("#CardTypeNew").val();
			PageLogicObj.m_PreCardLeaving=$("#CardLeaving").val();
			PageLogicObj.m_selectedMarkListDataGrid=InitselectedMarkListDataGrid();
			MarkListDBClick(PageLogicObj.CommonCardrow)
		}
	}
function CheckHaveBlack(PatientID,IDCardNo){
	var BlackFlag=$.cm({
		ClassName:"web.DHCRBAppointment",
		MethodName:"GetLimitAppFlag",
		dataType:"text",
		PatientId:PatientID, IDCardNo:IDCardNo
	},false);
	var BlackFlag=BlackFlag.split("^")[0] //BlackFlag.split("^")[1]Ϊ��Ч���� ����ά����Ч���� ���ڴ�������ʾ��Ϣ
	if (BlackFlag==1){
		 if (IDCardNo!="") $.messager.alert("��ʾ","��֤���������ΥԼ��¼,�ѱ�����������С�������ԤԼ!")
		 else $.messager.alert("��ʾ","������Ч��������¼,������ԤԼ!")
		 return false
	}
	return true	
}
