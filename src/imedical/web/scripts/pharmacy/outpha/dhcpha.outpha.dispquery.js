/*
 *ģ��:����ҩ��
 *��ģ��:ҩ��ͳ��-��ҩ��ѯ
 *createdate:2016-12-08
 *creator:dinghongying
*/
DHCPHA_CONSTANT.VAR.INVROWID="";
var QUERYPID="";	
$(function(){
	/* ��ʼ����� start*/
	var daterangeoptions={
		timePicker : true, 
		timePickerIncrement:1,
		timePicker24Hour:true,
		timePickerSeconds:true,
		singleDatePicker:true,
		locale: {
			format: DHCPHA_CONSTANT.PLUGINS.DATEFMT+" HH:mm:ss"
		}
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);
	//�������лس��¼�
		
	
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})

	InitThisLocInci(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
	InitDispStat();
	InitPyUser();
	InitFyUser();
    InitDispMainList();	
	InitDispDetailList();
	InitDispInclbList();
	ClearConditions();
	//�ǼǺŻس��¼�
	$('#txt-patno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txt-patno").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				Query();
			}	
		}
	});
	//���Żس��¼�
	$('#txt-cardno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var cardno = $.trim($("#txt-cardno").val());
			if (cardno != "") {
				BtnReadCardHandler();
			}
		}
	});
	/* �󶨰�ť�¼� start*/
	$("#btn-find").on("click",Query);
	$("#btn-clear").on("click",ClearConditions);
	$("#btn-export").on('click',function(){
		ExportAllToExcel("gird-dispquery")

	});
	$("#btn-exportdetail").on('click',function(){
		if ($("#sp-title").text()=="��ҩ�����б�"){
		   ExportAllToExcel("gird-dispinclbdetail")
		}else{
		   ExportAllToExcel("gird-dispquerydetail")
		}
	});
	$("#btn-readcard").on("click",BtnReadCardHandler); //����
	/* �󶨰�ť�¼� end*/;	
	$("#gird-dispquery").closest(".panel-body").height(GridCanUseHeight(1)*0.5-20);	
	$("#gird-dispquerydetail").closest(".panel-body").height(GridCanUseHeight(1)*0.5-20);
	$("#gird-dispinclbdetail").closest(".panel-body").height(GridCanUseHeight(1)*0.5-20);
	$("#a-change").on("click",ChangeDispQuery);
	$("#div-inclbdetail").hide();
	//setTimeout(function(){$("#div-inclbdetail").hide();},1000)
	
})


//��ʼ����ҩ״̬
function InitDispStat(){
	var data = [
		{ id: 1, text: '�ѷ�ҩ' },
		{ id: 2, text: 'δ��ҩ' },
		{ id: 3, text: 'δ��ҩȷ��' }, 
		{ id: 4, text: '����ҩδȷ��' }, 
		{ id: 0, text: '����ҩδ��ҩ' }
	 ];
	var selectoption={
	  data: data,
      width:'9em',
      allowClear:false,
      minimumResultsForSearch: Infinity
	};
	$("#sel-dispstat").dhcphaSelect(selectoption);
	$('#sel-dispstat').on('select2:select', function (event) { 
		Query();
	})	
		
}

 //��ʼ��ҩƷѡ��
function InitThisLocInci(locrowid){
	var locincioptions={
		id:"#sel-locinci",
		locid:locrowid,
		width:'28em'
	}
	InitLocInci(locincioptions)
}
//��ʼ����ҩ��
function InitPyUser(){
	var selectoption={
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+
			"?action=GetPYUserList&style=select2&gLocId="+
			DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID+"&gUserId="+DHCPHA_CONSTANT.SESSION.GUSER_ROWID+"&flag=PY",
		allowClear:true,
	 	placeholder:'��ҩ��...'
	}
	$("#sel-pyuser").dhcphaSelect(selectoption)
	$('#sel-pyuser').on('select2:select', function (event) { 
		//alert(event)
	});
}
//��ʼ����ҩ��
function InitFyUser(){
	var selectoption={
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+
			"?action=GetPYUserList&gLocId="+
			DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID+"&gUserId="+DHCPHA_CONSTANT.SESSION.GUSER_ROWID+"&style=select2"+"&flag=FY",
		allowClear:true,
		placeholder:'��ҩ��...'
	}
	$("#sel-fyuser").dhcphaSelect(selectoption)
	$("#sel-fyuser").on('select2:select', function (event) { 
		//alert(event)
	});
}
//��ʼ����ҩ��ѯ�б�
function InitDispMainList(){
	//����columns
	var columns=[[
		{field:'pid',title:'���̺�',width:100,align:'left',hidden:true},
        {field:'docLocDesc',title:'��������',width:120},
        {field:'patNo',title:'�ǼǺ�',width:90,align:'center'}, 
        {field:'patName',title:'����',width:100,align:'left'},
        {field:'admReasonDesc',title:'�ѱ�',width:80,align:'center'},
        {field:'prescNo',title:'������',width:120,algin:'center'},
        {field:'spAmt',title:'ҩ��',width:80,align:'right'},
        {field:'prtDate',title:'�շ�����',width:90,align:'center'}, 
        {field:'pyDate',title:'��ҩ����',width:90,align:'center'}, 
        {field:'fyDate',title:'��ҩ����',width:90,align:'center'}, 
        {field:'pyUserName',title:'��ҩ��',width:80},
        {field:'fyUserName',title:'��ҩ��',width:80},
        {field:'prtTime',title:'�շ�ʱ��',width:70,align:'center'}, 
        {field:'pyTime',title:'��ҩʱ��',width:70,align:'center'}, 
        {field:'fyTime',title:'��ҩʱ��',width:70,align:'center'}, 
        {field:'oeoriDateTime',title:'ҽ��ʱ��',width:90},
        {field:'prescRemark',title:'������ע',width:80},
        {field:'diagDesc',title:'���',width:200},
        {field:'rpAmt',title:'���۽��',width:100,align:'right',hidden:true},
        {field:'encryptLevel',title:'�����ܼ�',width:80,hidden:true},
        {field:'patLevel',title:'���˼���',width:80,hidden:true},
        {field:'phdId',title:'��ҩ��Id',width:80,hidden:true},
        {field:'phdOweId',title:'Ƿҩָ��Id',width:80,hidden:true}
  	]];    
         
    var dataGridOption={
		url:"/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=PHA.OP.DispQuery.Display&MethodName=EuiGetDispMain",
		columns:columns,
		fitColumns:false,
		onSelect:function(rowIndex,rowData){
		    QueryDetail();
	    },
	    onLoadSuccess: function () {
         	if ($(this).datagrid("getRows").length>0){
	         	$(this).datagrid("selectRow", 0)
	         	$(this).datagrid('getPanel').panel('panel').focus() ;  // ֱ��Ĭ�Ͽ����¼�
	         	QUERYPID=$(this).datagrid("getRows")[0].pid;
	         	$(this).datagrid("options").queryParams.Pid=QUERYPID ;	
         	}else{
				KillTmpGloal();	
				QueryDetail();        	 	
	        }
		}
	} 
   //����datagrid	
   $('#gird-dispquery').dhcphaEasyUIGrid(dataGridOption);
}

//��ʼ����ҩ��ϸ�б�
function InitDispDetailList(){
	//����columns
	var columns=[[
		{field:'incDesc',title:'ҩƷ����',width:200}, 
		{field:'dspQty',title:'ҽ������',width:60,align:'right'},   
        {field:'qty',title:'����',width:60,align:'right'},
        {field:'uomDesc',title:'��λ',width:80},
        {field:'spAmt',title:'���',width:80,align:'right'},
        {field:'oeoriStatDesc',title:'״̬',width:60},
        {field:'dosage',title:'����',width:70},
        {field:'freqDesc',title:'Ƶ��',width:70},
        {field:'instrucDesc',title:'�÷�',width:70},
        {field:'duraDesc',title:'�Ƴ�',width:70},
        {field:'docName',title:'ҽʦ',width:70,hidden:true},
        {field:'stkBinStr',title:'��λ',width:100},
        {field:'retQty',title:'��ҩ',width:70},
        {field:'oeoriRemark',title:'ҽ����ע',width:100}
         ]];  
         
    var dataGridOption={
		url:"/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=PHA.OP.DispQuery.Display&MethodName=EuiGetDispIncDetail",
		columns:columns,
		fitColumns:true,
		pagination:false
	} 
   //����datagrid	
   $('#gird-dispquerydetail').dhcphaEasyUIGrid(dataGridOption);
}
//��ʼ��������ϸ�б�
function InitDispInclbList(){
	//����columns
	var columns=[[
		{field:'incDesc',title:'ҩƷ����',width:250} ,
		{field:'qty',title:'����',width:60}, 
		{field:'uomDesc',title:'��λ',width:60} ,
		{field:'sp',title:'�ۼ�',width:60,align:"right"} ,
		{field:'spAmt',title:'�ۼ۽��',width:60,align:"right"} ,
		{field:'batNo',title:'����',width:100} ,
		{field:'expDate',title:'Ч��',width:100} ,
		{field:'retQty',title:'��ҩ����',width:100},
		{field:'inclb',title:'inclb',width:100,hidden:true}
         ]];  
         
    var dataGridOption={
		url:"/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=PHA.OP.DispQuery.Display&MethodName=EuiGetDispInclbDetail",
		columns:columns,
		fitColumns:true,
		pagination:false
	} 
   //����datagrid	
   $('#gird-dispinclbdetail').dhcphaEasyUIGrid(dataGridOption);
}


///��ѯ
function Query(){
	var startdatetime=$("#date-start").val();
	var enddatetime=$("#date-end").val();
	var startdate=startdatetime.split(" ")[0];
	var starttime=startdatetime.split(" ")[1];
	var enddate=enddatetime.split(" ")[0];
	var endtime=enddatetime.split(" ")[1];
	
	var ctloc=DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var patNo=$("#txt-patno").val();
	var patName=$("#txt-patname").val();
	var prescNo=$("#txt-prescno").val();
	var inciRowId=$("#sel-locinci").val();
	if (inciRowId==null){
		inciRowId="";
	}
	var pyUser=$("#sel-pyuser").val();
	if (pyUser==null){
		pyUser="";
	}
	var fyUser=$("#sel-fyuser").val();
	if (fyUser==null){
		fyUser="";
	}
	var manaFlag="";
	if($("#chk-mana").is(':checked')){
		manaFlag="Y";
	}
	var dispStat=$("#sel-dispstat").val();
	if (dispStat==""){
		dhcphaMsgBox.alert("��ѡ��ҩ״̬!");
		return;
	}
	var depcode="";
	var doctor="";
	var tmpSplit=DHCPHA_CONSTANT.VAR.SPLIT;	
	KillTmpGloal();
	var params=startdate+tmpSplit+enddate+tmpSplit+ctloc+tmpSplit+patNo+tmpSplit+patName+tmpSplit+prescNo+tmpSplit+inciRowId+tmpSplit+pyUser+tmpSplit+fyUser+tmpSplit+dispStat+tmpSplit+starttime+tmpSplit+endtime+tmpSplit+manaFlag+tmpSplit+depcode+tmpSplit+doctor;
	$('#gird-dispquery').datagrid({
     	queryParams:{
			InputStr:params,
			Pid:""
		}
	});
		
}

///��ҩ��ϸ��ѯ
function QueryDetail(){
	var selecteddata = $('#gird-dispquery').datagrid('getSelected');
	if(selecteddata==null){
		var params="";
	}else{
		var phdRowId=selecteddata["phdId"];
		var prescNo=selecteddata["prescNo"];
		var tmpSplit=DHCPHA_CONSTANT.VAR.SPLIT;
		var params=phdRowId+tmpSplit+prescNo+tmpSplit+DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	}
	if ($("#sp-title").text()=="��ҩ�����б�"){
		$('#gird-dispinclbdetail').datagrid({
	     	queryParams:{
				InputStr:params 
			}
		});
	}else{
		$('#gird-dispquerydetail').datagrid({
	     	queryParams:{
				InputStr:params 
			}
		});
	}
}

//���
function ClearConditions(){
	KillTmpGloal();
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("T")+" "+"00:00:00");
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("T")+" "+"00:00:00");
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("T")+" "+"23:59:59");
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("T")+" "+"23:59:59");
	
	
	
	$("#txt-prescno").val("");
	$("#txt-patname").val("");
	$("#txt-patno").val("");
	$("#txt-cardno").val("");
	DHCPHA_CONSTANT.VAR.INVROWID="";
	$("#sel-pyuser").empty();
	$("#sel-fyuser").empty();
	$("#sel-locinci").empty();
	$("#sel-dispstat").select2('val','1')
	$("#chk-mana").iCheck("uncheck");
	$('#gird-dispquery').clearEasyUIGrid();
	$('#gird-dispquerydetail').clearEasyUIGrid();
	$('#gird-dispinclbdetail').clearEasyUIGrid();

}

//����
function BtnReadCardHandler(){
	var readcardoptions={
		CardTypeId:"sel-cardtype",
		CardNoId:"txt-cardno",
		PatNoId:"txt-patno"		
	}
	DhcphaReadCardCommon(readcardoptions,ReadCardReturn)
}
//�������ز���
function ReadCardReturn(){
	Query();
}

function ChangeDispQuery(){
	if ($("#sp-title").text()=="ҩƷ�б�"){
		$("#sp-title").text("��ҩ�����б�");
		$("#div-incdetail").hide();
		$("#div-inclbdetail").show();
	}else{
		$("#sp-title").text("ҩƷ�б�")
		$("#div-inclbdetail").hide();
		$("#div-incdetail").show(); 
	}
	QueryDetail();
}

// �����ʱglobal
function KillTmpGloal(){
	tkMakeServerCall("PHA.OP.DispQuery.Global","Kill",QUERYPID);
}

window.onbeforeunload = function (){
	KillTmpGloal();
}