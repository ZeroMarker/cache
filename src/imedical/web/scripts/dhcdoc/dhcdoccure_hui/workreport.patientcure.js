var PageCurePatObj={
	m_PatientCureTabDataGrid:"",
	m_CureDetailDataGrid:"",
	m_SelectArcimID:"",
	PatCondition:[{id:"PatNo",desc:$g("�ǼǺ�")},{id:"PatMedNo",desc:$g("סԺ��")},{id:"PatName",desc:$g("��������")}]
}

$(document).ready(function(){
	var HospIdTdWidth=$("#HospIdTd").width()
	var opt={width:HospIdTdWidth}
	var hospComp = GenUserHospComp(opt);
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		InitArcimDesc();
		InitOrderLoc();
		PatientCureTabDataGridLoad();	
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//PatientCureTabDataGridLoad();
		Init();
	}	
	InitEvent();
});

function Init(){
	InitDate();
	InitOrderLoc();	
	InitOrderDoc();
	InitArcimDesc();
	InitPatCondition();
	InitOthChkCondition();
  	PageCurePatObj.m_PatientCureTabDataGrid=InitPatientCureTabDataGrid();	
}

function InitEvent(){
	$('#btnFind').click(PatientCureTabDataGridLoad);
    $('#btnClear').click(ClearHandle);
	$('#ApplyNo').bind('keydown', function(event){
		if(event.keyCode==13){
			PatientCureTabDataGridLoad();
		}
	});
	$('#PatConditionVal').bind('keydown', function(event){
		if(event.keyCode==13)
		{
			var PatCondition=$("#PatCondition").combobox("getValue");
			if(PatCondition=="PatNo"){
				PatNoHandle(PatientCureTabDataGridLoad,this.id);	
				if ($(this).val()==""){
					$("#PatientID").val("");
				}
			}else{
				PatientCureTabDataGridLoad();
			}
		}
	});
	$('#PatConditionVal').bind('change', function(){
		var PatCondition=$("#PatCondition").combobox("getValue");
		if(PatCondition=="PatNo"){
			if ($(this).val()==""){
				$("#PatientID").val("");
			}
		}
    });
	$HUI.radio("[name='SortType']",{
        onChecked:function(e,value){
            setTimeout("PatientCureTabDataGridLoad();",10)
        }
    });
    $HUI.checkbox("#showByPat",{
		onCheckChange:function(e,value){
			setTimeout("PatientCureTabDataGridLoad();",10)
		}
	})
    //InitPatNoEvent(PatientCureTabDataGridLoad);
	InitCardNoEvent(PatientCureTabDataGridLoad);
}

function InitPatientCureTabDataGrid()
{
	var PatientCureToolBar = [{
		id:'BtnDetailView',
			text:'���뵥���', 
			iconCls:'icon-eye',  
			handler:function(){
				OpenApplyDetailDiag();
			}
		},"-",{
			id:'BtnAssessment',
			text:'��������', 
			iconCls:'icon-paper-table',  
			handler:function(){
				UpdateAssessment();
			}
		}
	];
	var PatientCureColumn=[[ 
		{field:'ApplyNo',title:'���뵥��',width:120,align:'left'},  
		{field:'ArcimDesc',title:'������Ŀ',width:180,align:'left',
			formatter: function (value, rowData, rowIndex) {
				var retStr=value;
				if(value!=""){
					retStr = "<a href='#' title='"+$g("ҽ��������Ϣ")+"'  onclick='com_openwin.applyAppenditemShow(\""+rowData.OrderId+"\")'>"+value+"</a>"
				}
				return retStr;
			}
		},
		{field:'OrdOtherInfo',title:'ҽ��������Ϣ',width:160,align:'left',
			formatter: function (value, rowData, rowIndex) {
				if(value==""){
					if(rowData.ArcimDesc==""){
						return "";	
					}else{
						value = $g("ҽ����ϸ��Ϣ");
					}
				}
				return "<a href='javascript:void(0)' title='"+$g("ҽ����ϸ��Ϣ")+"'  onclick='com_openwin.ordDetailInfoShow(\""+rowData.OrderId+"\")'>"+value+"</a>";
			}
		}, 
		{field:'OrdAddLoc',title:'��������',width:120,align:'left'},  
		{field:'OrdUnitPrice',title:'����',width:80,align:'left'}, 
		{field:'OrdQty',title:'����',width:50,align:'left'}, 
		{field:'OrdBillUOM',title:'��λ',width:80,align:'left'}, 
		{field:'OrdPrice',title:'�ܽ��',width:80,align:'left'}, 
		{field:'ApplyExec', title:'�Ƿ��ԤԼ', width: 120, align: 'left',
			formatter:function(value,row,index){
				if (row.ApplyExecFlag=="Y"){
					return "<span class='fillspan-exec'>"+value+"</span>";
				}else if (row.ApplyExecFlag==""){
					return value;
				}else {
					return "<span class='fillspan-app'>"+value+"</span>";
				}
			}
		},
		{field:'ApplyExecFlag', title:'�Ƿ��ԤԼ', width: 80, align: 'left',hidden: true},
		{field:'ApplyStatus',title:'����״̬',width:80,align:'left'},
		{field:'ApplyAppedTimes',title:'��ԤԼ����',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		{field:'ApplyNoAppTimes',title:'δԤԼ����',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		{field:'ApplyFinishTimes',title:'����������',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false,
			formatter:function(value,row,index){
				if(value==""){
					return "";	
				}else{
					return '<a href="###" id= "'+row["TIndex"]+'"'+' onmouseover=ShowCureEexcDetail(this);'+' onclick=ShowCureDetail('+row.TIndex+','+row.DCARowId+');>'+"<span class='fillspan-nosave'>"+value+"</span>"+"</a>"
				}
			},
			styler:function(value,row){
				return "color:blue;text-decoration: underline;"
			}
		},
		{field:'ApplyNoFinishTimes',title:'δ��������',width:80,align:'left',hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		{field:'OrdBilled',title:'�Ƿ�ɷ�',width:70,align:'left',
			formatter:function(value,row,index){
				if (value == $g("��")){
					return "<span class='fillspan-nobilled'>"+value+"</span>";
				}else{
					return "<span class='fillspan'>"+value+"</span>";
				}
			}
		},
		{field:'OrdReLoc',title:'���տ���',width:150,align:'left'},   
		{field:'ServiceGroup',title:'������',width:100,align:'left'}, 
		{field:'ApplyUser',title:'����ҽ��',width:80,align:'left'},
		{field:'ApplyDateTime',title:'����ʱ��',width:100,align:'left'},
		{field:'ApplyStatusCode',title:'ApplyStatusCode',width:80,hidden: true},
		{field:'CureCfgLimit',title:'CureCfgLimit',width:80,hidden: true}
	 ]]

	var PatientCureTabDataGrid=$('#PatientCureTab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		url : $URL+'?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=FindAllCureApplyListHUI&rows=99999',
		loadMsg : '������..',  
		pagination : true,
		rownumbers : true,
		idField:"DCARowId",
		pageSize : 50,
		pageList : [20,50,100],
		frozenColumns : [
			[
				{field:'PatNo',title:'�ǼǺ�',width:100,align:'left'},   
				{field:'PatName',title:'����',width:80,align:'left'},   
				{field:'PatOther',title:'����������Ϣ',width:200,align:'left'},
				{field:'DCARowId',title:'DCARowId',width:30,hidden:true},	
				{field:'DCAAdmID',title:'DCAAdmID',width:50,hidden:true},
				{field:'PatientID',title:'PatientID',width:50,hidden:true}
			]
		],
		columns : PatientCureColumn,
		toolbar : PatientCureToolBar,
		onSelect:function(index, row){
			var frm=dhcsys_getmenuform();
			if (frm){
				var DCARowId=row.DCARowId;
				var EpisodeID=row.DCAAdmID;
				var PatientID=row.PatientID;
				if(EpisodeID!=""){
					frm.PatientID.value=PatientID;
					frm.EpisodeID.value=EpisodeID;
				}
			}
		},
		onBeforeSelect:function(index, row){
			var oldSelRow=$(this).datagrid('getSelected');
			var oldSelIndex=$(this).datagrid('getRowIndex',oldSelRow);
			if (oldSelIndex==index){
				$(this).datagrid('unselectRow',index);
				var frm=dhcsys_getmenuform();
				if (frm){
					frm.PPRowId.value="";
					frm.EpisodeID.value="";
				}
				return false;
			}
		},
		onBeforeLoad:function(param){
			var StartDate=$("#StartDate").datebox("getValue");
			var EndDate=$("#EndDate").datebox("getValue");
			var PatientID=$("#PatientID").val();
			var ApplyNo=$("#ApplyNo").val();
			var queryOrderLoc=$HUI.combobox("#ComboOrderLoc").getValue();
			queryOrderLoc=CheckComboxSelData("ComboOrderLoc",queryOrderLoc);
			var queryOrderDoc=$HUI.combobox("#ComboOrderDoc").getValue();
			queryOrderDoc=CheckComboxSelData("ComboOrderDoc",queryOrderDoc);
			var gtext=$HUI.lookup("#ComboArcim").getText();
			if (gtext=="")PageSizeItemObj.m_SelectArcimID="";
			var queryArcim=PageSizeItemObj.m_SelectArcimID;
			var PatName="",PatMedNo=""; 
			var PatCondition=$("#PatCondition").combobox("getValue");
			var PatConditionVal=$("#PatConditionVal").val();
			if(PatCondition=="PatName"){
				PatName=PatConditionVal;
			}else if(PatCondition=="PatMedNo"){
				PatMedNo=PatConditionVal;
			}
			var SortType="A"; //Ĭ��ʱ������
			var chkRadioJObj = $("input[name='SortType']:checked");
			if(chkRadioJObj.length>0){SortType=chkRadioJObj.val();}
			var CheckAdmType="",ChkCurrLocFlag="";
			if($("#ComboOtherChk").length>0){
				var OtherChkAry=$("#ComboOtherChk").combobox("getValues");
				if($.hisui.indexOfArray(OtherChkAry,"OPCheck")>-1){CheckAdmType="O"}
				if($.hisui.indexOfArray(OtherChkAry,"IPCheck")>-1){CheckAdmType="I"}
				if($.hisui.indexOfArray(OtherChkAry,"ChkCurrLoc")>-1){ChkCurrLocFlag="Y"}
				if($.hisui.indexOfArray(OtherChkAry,"OPCheck")>-1 && $.hisui.indexOfArray(OtherChkAry,"IPCheck")>-1){CheckAdmType=""}
			}
			var showByPatFlag=$HUI.checkbox("#showByPat").getValue()?"Y":"N";
			var QueryExpStr=Util_GetSelUserHospID()+"^"+ChkCurrLocFlag+"^"+queryOrderDoc+"^"+PatMedNo+"^"+SortType+"^"+"doccure.workreport.patientcure.hui.csp";
				QueryExpStr=QueryExpStr+"^^^^"+showByPatFlag
			$.extend(param,{PatientID:PatientID,StartDate:StartDate,EndDate:EndDate,PatName:PatName,
			TriageFlag:"ALL",LogLocID:session['LOGON.CTLOCID'],LogUserID:session['LOGON.USERID'],
			ApplyNo:ApplyNo,CheckAdmType:CheckAdmType,queryArcim:queryArcim,queryOrderLoc:queryOrderLoc,queryExpStr:QueryExpStr});
		},
		onLoadSuccess:function(data){
			if($HUI.checkbox("#showByPat").getValue()){
				PageCurePatObj.m_PatientCureTabDataGrid.datagrid("autoMergeCells",['PatNo','PatName','PatOther']);    //�ϲ���ͬ��
				PageCurePatObj.m_PatientCureTabDataGrid.datagrid("getPanel").find(".datagrid-view1 tr.datagrid-row[datagrid-row-index]").css({"color": "inherit", "background-color": "inherit"}); //�ö�����ǰ��ɫ�ͱ���ɫ�Ӹ�Ԫ�ؼ̳�
			}
			$(this).datagrid("clearSelections");
		}
	});
	return PatientCureTabDataGrid
}
function PatientCureTabDataGridLoad()
{
	PageCurePatObj.m_PatientCureTabDataGrid.datagrid("reload");
}

function ClearHandle(){
	//InitCardType();
	$('.search-table input[class*="cure-box"]').val("");
	$('input[type=checkbox]').checkbox('uncheck');
	$("#ComboOrderLoc,#ComboOrderDoc,#PatCondition").combobox("setValue","");
	PageSizeItemObj.m_SelectArcimID=""; 
	$("#ComboArcim").lookup('setText','');
	$("#ComboOtherChk").combobox('setValues','');
	$HUI.radio('.search-table input[value="A"]').setValue(true);
	InitDate();	
}

function ShowCureDetail(inde,id){
	var dhwid=window.screen.availWidth-60;
	var dhhei=window.screen.availHeight-100;
	$('#add-dialog').window('open').window('resize',{
		width:dhwid,
		height:dhhei,
		top: ($(window).height() - dhhei) * 0.5,
		left:($(window).width() - dhwid) * 0.5
	});
	var CureDetailDataGrid=$('#tabCureDetail').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		checkOnSelect:false,
		fitColumns : false,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:false,    
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.ExecApply&QueryName=FindCureExecList&DCARowId="+id+"&OnlyExcute=Y&rows=9999",
		loadMsg : '������..',  
		pagination : true, 
		rownumbers : true,
		idField:"OEORERowID",
		pageSize : 20,
		pageList : [20,50,100],
		columns :[[ 
			{field:'DCARowId',title:'',width:1,hidden:true}, 
			{field:'PapmiNo',title:'�ǼǺ�',width:100},   
			{field:'PatientName',title:'����',width:100},
			{field:'ArcimDesc',title:'������Ŀ',width:220,align:'left'},  
			//{field:'OEOREExStDate',title:'Ҫ��ִ��ʱ��',width:130,align:'left'},
			{field:'DCRContent',title:'���Ƽ�¼',width:220,align:'left'} ,
			{field:'OEOREQty',title:'ִ������',width:80,align:'left'} ,
			{field:'OEOREStatus',title:'ִ��״̬',width:80,align:'left'},
			{field:'OEOREUpUser',title:'ִ����',width:60,align:'left'},
			{field:'DCRIsPicture',title:'�Ƿ���ͼƬ',width:80,
    			formatter:function(value,row,index){
	    			if(value=="Y"){
						return '<a href="###" id= "'+row["OEORERowID"]+'"'+' onmouseover=workList_RecordListObj.ShowCurePopover(this);'+' onclick=ShowCureRecordPic(\''+row.DCRRowId+'\');>'+$g("�鿴ͼƬ")+"</a>"
	    			}else{
		    			return "";	
		    		}
				},
				styler:function(value,row){
					return "color:blue;text-decoration: underline;"
			}},
			{field:'DCRCureDate',title:'����ʱ��',width:160,align:'left'} ,
			{field:'DCRResponse',title:'���Ʒ�Ӧ',width:220,align:'left'} ,
			{field:'DCREffect',title:'����Ч��',width:220,align:'left'} ,
			{field:'OEOREExDate',title:'����ʱ��',width:160,align:'left'} ,
			{field:'OEORETransType',title:'ҽ������',width:100,align:'left'} ,
			{field:'DCRRowId',title:'DCRRowId',width:100,align:'left',hidden:true} ,
			{field:'OEORERowID',ExecID:'ID',width:50,align:'left',hidden:true}  
	 	]],
	 	onLoadSuccess: function(){
		    PageCurePatObj.m_CureDetailDataGrid.datagrid("clearSelections");
        }
	});
	PageCurePatObj.m_CureDetailDataGrid=CureDetailDataGrid;
	return CureDetailDataGrid;
}

function CureDetailDataGridLoad(){
	PageCurePatObj.m_CureDetailDataGrid.datagrid("reload");
}

function ShowCureRecordPic(DCRRowId){
	workList_RecordListObj.ShowCureRecordPic(DCRRowId,CureDetailDataGridLoad);	
}
	
function ShowCureEexcDetail(that){
	var title=""
	var content="��������ϸ��Ϣ"
	$(that).webuiPopover({
		title:title,
		content:content,
		trigger:'hover',
		placement:'top',
		style:'inverse'
	});
	$(that).webuiPopover('show');
}
function OpenApplyDetailDiag()
{
	var row = PageCurePatObj.m_PatientCureTabDataGrid.datagrid("getSelected");
	if (row) {
		var DCARowId=row.DCARowId;
		if(DCARowId==""){
			$.messager.alert('��ʾ','��ȡ���뵥��Ϣ����!',"warning");
			return false;
		}
		com_openwin.ShowApplyDetail(DCARowId,ServerObj.DHCDocCureLinkPage,PatientCureTabDataGridLoad);
	}else{
		$.messager.alert('��ʾ','��ѡ��һ�����뵥!',"warning");
		return false;
	}
	
}
function UpdateAssessment(){
	var row = PageCurePatObj.m_PatientCureTabDataGrid.datagrid("getSelected");
	if (row) {
		var DCARowId=row.DCARowId;
		var OrdBilled=row.OrdBilled;
		var ApplyStatusCode=row.ApplyStatusCode;
		var CureCfgLimit=row.CureCfgLimit;
		if(DCARowId==""){
			$.messager.alert('��ʾ','��ȡ���뵥��Ϣ����!',"warning");
			return false;
		}
		if((OrdBilled==$g("��"))||(ApplyStatusCode=="C")){
			$.messager.alert('��ʾ','δ�пɽ�����������������,��ȷ�������Ƿ��ѽɷѻ��Ƿ��ѳ���!',"warning");
			return false;	
		}
		var myTitle=$g('��������');
		if(CureCfgLimit=="0"){
			var PageShowFromWay="ShowFromEmrList";
			var myTitle=$g('��������')+'<span style="color:red">('+$g('�������Ȩ��')+')</span>';
		}else{
			var PageShowFromWay="";	
		}
		var href="doccure.cureassessmentlist.csp?OperateType=&DCARowIdStr="+DCARowId+"&PageShowFromWay="+PageShowFromWay;
	    websys_showModal({
			url:href,
			iconCls:"icon-w-paper",
			title:myTitle,
			width:"80%",height:"80%"
		});
	} else {
		$.messager.alert("��ʾ","��ѡ��һ�����뵥!","warning");
		return false;
	}
}

function InitOrderLoc(){
	var obj=com_withLocDocFun.InitComboDoc("ComboOrderDoc");
	com_withLocDocFun.InitComboLoc("ComboOrderLoc",obj);
}
function InitOrderDoc(LocID){
}

function InitPatCondition(){
	$HUI.combobox("#PatCondition", {
		valueField: 'id',
		textField: 'desc', 
		editable:false,
		data: PageCurePatObj.PatCondition,
		onSelect:function(){
	    	$("#PatConditionVal").val("");
	    	$("#PatientID").val("");
	    }
	});
}
function InitOthChkCondition(){
	var OthChkConditionAry=[{id:"OPCheck",desc:$g("��������-�ż���")},{id:"IPCheck",desc:$g("��������-סԺ")},{id:"ChkCurrLoc",desc:$g("���ƾ��ﻼ��")}]
	$HUI.combobox("#ComboOtherChk", {
		valueField: 'id',
		textField: 'desc', 
		editable:false,
		multiple:true,
		rowStyle:'checkbox',
		selectOnNavigation:false,
		panelHeight:"auto",
		data: OthChkConditionAry
	});
}