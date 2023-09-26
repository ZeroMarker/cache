/*
 *ģ��:����ҩ��
 *��ģ��:�ճ�ҵ��-�������д�ӡ
 *createdate:2016-11-29
 *creator:dinghongying
*/
var QUERYPID="";
var GridSelect="";
$(function(){
	CheckPermission();
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
	InitLoc();
	InitPrescType();
	InitPrescInfoList();
	InitPrescDetailList();
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
	/* �󶨰�ť�¼� start*/
	$("#btn-find").on("click",Query);
	$("#btn-clear").on("click",ClearConditions);
	$("#btn-print").on("click",BPrintHandler);
	$("#btn-export").on("click",function(){
		ExportAllToExcel("locprescdg")
	});
	/* �󶨰�ť�¼� end*/;	
	$("#locprescdg").closest(".panel-body").height(GridCanUseHeight(1)*0.5-20);	
	$("#prescdetaildg").closest(".panel-body").height(GridCanUseHeight(1)*0.5-20);	
	
})

//��ʼ������
function InitLoc(){
	var selectoption={
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+
			"?action=GetCtLocDs&style=select2&custtype=DocLoc",
		allowClear:true
	}
	$("#sel-loc").dhcphaSelect(selectoption)
	$('#sel-loc').on('select2:select', function (event) { 
		//alert(event)
	});
}

//��ʼ����������
function InitPrescType(){
	var selectoption ={
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+
			"?action=GetPrescType&style=select2",
		allowClear:true,
		minimumResultsForSearch: Infinity
	}
	
	$("#sel-presctype").dhcphaSelect(selectoption)
	$('#sel-presctype').on('select2:select', function (event) { 
		//alert(event)
	});
}

//������Ϣ�б�
function InitPrescInfoList(){
	//����columns
	var columns=[[
		{field:'gridSelect', title:"",checkbox: true },
        {field:'prescStat',title:'״̬-todo',width:100,align:'center',hidden:true},
        {field:'docLocDesc',title:'��������',width:140,align:'left'},
        {field:'patNo',title:'�ǼǺ�',width:90,align:'center'}, 
		{field:'patName',title:'����',width:100,align:'left'},   
		{field:'spAmt',title:'ҩ��',width:75,align:'right'},
        {field:'prescNo',title:'������',width:125,align:'center'},
		{field:'prescType',title:'�������',width:75,align:'center'},
		{field:'diagDesc',title:'���',width:200,align:'left'},
		{field:'prtDate',title:'�շ�����',width:90,align:'center'},
		{field:'prtTime',title:'�շ�ʱ��',width:90,align:'center'},
		{field:'fyDate',title:'��ҩ����',width:90,align:'center'},
		{field:'fyTime',title:'��ҩʱ��',width:90,align:'center'},
		{field:'pyUserName',title:'��ҩ��',width:90,align:'left'},
		{field:'fyUserName',title:'��ҩ��',width:90,align:'left'},
		{field:'winDesc',title:'��ҩ����',width:90,align:'left'},
		{field:'encryptLevel',title:'�����ܼ�',width:100,align:'left'},
        {field:'patLevel',title:'���˼���',width:100,align:'left'}
         ]]; 
         
    var dataGridOption={
		url:"/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=PHA.OP.PreBatPrt.Display&MethodName=EuiGetPrescMain",
		columns:columns,
	  	singleSelect:false,
	    checkOnSelect: false,
	  	selectOnCheck: false,
		onSelect:function(rowIndex,rowData){
			if (GridSelect==""){
				GridSelect=1
				$(this).datagrid("unselectAll");
				$(this).datagrid("selectRow",rowIndex);
				GridSelect=""
			}
			QueryDetail();
		},
		onUnselect:function(rowIndex,rowData){
			$('#prescdetaildg').clearEasyUIGrid();
		},
		onLoadSuccess: function () {
         	if ($(this).datagrid("getRows").length>0){
	         	$(this).datagrid("selectRow", 0);
	         	QUERYPID=$(this).datagrid("getRows")[0].pid;
	         	$(this).datagrid("options").queryParams.Pid=QUERYPID ;	
         	}else{
				KillTmpGlobal();	
				$('#prescdetaildg').clearEasyUIGrid();     	 	
	        }
		}
	} 
   //����datagrid	
   $('#locprescdg').dhcphaEasyUIGrid(dataGridOption);
    
}

//������ϸ�б�
function InitPrescDetailList(){
	//����columns
	var columns=[[
        {field:'oeoriStatDesc',title:'״̬',width:60,align:'center',
	        styler: function(value, row, index) {
	            var colorStyle = "";
	            if ((value.indexOf("ֹͣ") >= 0)||(value.indexOf("����") >= 0)) {
	                colorStyle = "background:#F4868E;color:white;"
	            }
	            return colorStyle;
	        }
        }, 
	    {field:'arcItmDesc',title:'ҩƷ',width:200,align:'left'},  
        {field:'oeoriQty',title:'ҽ������',width:65,align:'right'},     
        {field:'uomDesc',title:'��λ',width:80,align:'center'},    
        {field:'sp',title:'�۸�',width:80,align:'right'},
        {field:'spAmt',title:'���',width:80,align:'right'},
        {field:'dosage',title:'����',width:80,align:'left'},    
        {field:'freqDesc',title:'Ƶ��',width:80,align:'left'},
        {field:'instrucDesc',title:'�÷�',width:80,align:'left'},    
        {field:'duraDesc',title:'�Ƴ�',width:80,align:'left'},
		{field:'dispQty',title:'�ѷ�ҩ',width:50,align:'left'}, 
        {field:'retQty',title:'����ҩ',width:50,align:'left'},    
        {field:'oeoriRemark',title:'ҽ����ע',width:120,align:'left'}
    ]];  
    var dataGridOption={
		url:"/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=PHA.OP.PreBatPrt.Display&MethodName=EuiGetPrescItm",
		columns:columns,
		fitColumns:true,
		pagination:false
	}
   //����datagrid
   $('#prescdetaildg').dhcphaEasyUIGrid(dataGridOption);	
   
}

///������ѯ
function Query(){
	var startdatetime=$("#date-start").val();
	var enddatetime=$("#date-end").val();
	var startdate=startdatetime.split(" ")[0];
	var starttime=startdatetime.split(" ")[1];
	var enddate=enddatetime.split(" ")[0];
	var endtime=enddatetime.split(" ")[1];
	var ctloc=DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var admlocdata=$("#sel-loc").select2("data");
	var admloc=(admlocdata=="")?"":admlocdata[0].id;
	var presctypedata=$("#sel-presctype").select2("data");
	var presctype=(presctypedata=="")?"":presctypedata[0].text;
	var pmino=$("#txt-patno").val();;
	var tmpSplit=DHCPHA_CONSTANT.VAR.SPLIT;	
	KillTmpGlobal();
	var params=startdate+tmpSplit+enddate+tmpSplit+ctloc+tmpSplit+pmino+tmpSplit+starttime+tmpSplit+endtime+tmpSplit+admloc+tmpSplit+presctype;
	$('#locprescdg').datagrid({
     	queryParams:{
			InputStr:params,
			Pid:""
		}
	});
		
}

//��ѯ��ϸ
function QueryDetail(){
	var selectdata=$("#locprescdg").datagrid("getSelected")
	if (selectdata==null){
		dhcphaMsgBox.alert("ѡ�������쳣!");
		return;
	}
	var prescno=selectdata.prescNo;	
	$('#prescdetaildg').datagrid({
     	queryParams:{
	     	InputStr:prescno
		}
	});
}

//���
function ClearConditions(){
	KillTmpGlobal();
	$("#sel-loc").empty();
	$("#sel-presctype").empty();
	$("#txt-patno").val("");
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("T")+" "+"00:00:00");
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("T")+" "+"00:00:00");
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("T")+" "+"23:59:59");
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("T")+" "+"23:59:59");
	$('#locprescdg').clearEasyUIGrid();
	$('#prescdetaildg').clearEasyUIGrid();
}


//��ӡ
function BPrintHandler(){
    var gridChecked = $('#locprescdg').datagrid('getChecked');
    if (gridChecked == "") {
        dhcphaMsgBox.alert("�빴ѡ��Ҫ��ӡ������!","info");
        return;
    }
    var cLen = gridChecked.length
    for (var cI = 0; cI < cLen; cI++) {
        var prescNo = gridChecked[cI].prescNo;
	    OUTPHA_PRINTCOM.Presc(prescNo,"����","");  
    }
}
function CheckPermission(){
	$.ajax({
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=CheckPermission'+
			'&groupId='+DHCPHA_CONSTANT.SESSION.GROUP_ROWID+
			'&gUserId='+DHCPHA_CONSTANT.SESSION.GUSER_ROWID+
			'&gLocId='+DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
		type:'post',   
		success:function(data){ 
			var retjson=JSON.parse(data);
			var retdata= retjson[0];
			DHCPHA_CONSTANT.DEFAULT.CYFLAG=retdata.phcy;
		},  
		error:function(){}  
	})
}
// �����ʱglobal
function KillTmpGlobal(){
	tkMakeServerCall("PHA.OP.PreBatPrt.Global","Kill",QUERYPID);
}

window.onbeforeunload = function (){
	KillTmpGlobal();
}