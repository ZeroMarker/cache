/*
 *ģ��:����ҩ��
 *��ģ��:ҩ��ͳ��-����ͳ��
 *createdate:2016-12-02
 *creator:dinghongying
*/
var gNewCatId=""
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
	InitPrescType();
	InitStk();
	/*ҩ����� start*/
	$("#txt-phccat").next().children("i").on('click',function(event){
		ShowPHAINPhcCat({},function(catObj){
			if (catObj){
				$("#txt-phccat").val(catObj.text||'');
				gNewCatId=catObj.id||'';
			}
		})
	});	
	/*ҩ����� end*/
	InitPrescnoTJList();
	ClearConditions();
	/* �󶨰�ť�¼� start*/
	$("#btn-find").on("click",Query);
	$("#btn-clear").on("click",ClearConditions);
	$("#btn-print").on("click",BPrintHandler);
	$("#btn-export").on("click",function(){
		ExportAllToExcel("prescnotjdg")
	});
	/* �󶨰�ť�¼� end*/;	
	$("#prescnotjdg").closest(".panel-body").height(GridCanUseHeight(1));	
	
})

//��ʼ����������
function InitPrescType(){
	var selectoption ={
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+
			"?action=GetOutPrescType&style=select2",
		allowClear:true,
		minimumResultsForSearch: Infinity
	}
	
	$("#sel-presctype").dhcphaSelect(selectoption)
	$('#sel-presctype').on('select2:select', function (event) { 
		//alert(event)
	});
}
//��ʼ��������
function InitStk(){
	var selectoption={
		url:DHCPHA_CONSTANT.URL.COMMON_PHA_URL+
			"?action=GetStkCatDs&style=select2",
		allowClear:true,
		width:'175px'
	}
	$("#sel-stk").dhcphaSelect(selectoption)
	$('#sel-stk').on('select2:select', function (event) { 
		//alert(event)
	});
}

//������Ϣ�б�
function InitPrescnoTJList(){
	//����columns
	var columns=[[
		{field:'TPrescType',title:'�ѱ�',width:100,align:'center'},
	    {field:'TPrescNum',title:'��������',width:100,align:'right'},
	    {field:'TPrescTotal',title:'��������',width:100,align:'right'},
	    {field:'TPrescBL',title:'��������(%)',width:80,align:'right'},
	    {field:'TPrescMax',title:'��ߴ���',width:100,hidden:true},
	    {field:'TPrescMin',title:'��ʹ���',width:100,hidden:true},
	    {field:'TPrescMaxPmi',title:'��߷��ǼǺ�',width:100,align:'center'},
	    {field:'TPrescMinPmi',title:'��ͷ��ǼǺ�',width:100,align:'center'},
	    {field:'TPrescMaxMoney',title:'��߷����',width:80,align:'right'},
	    {field:'TPrescMinMoney',title:'��ͷ����',width:80,align:'right'},
	    {field:'TPrescMoney',title:'�ϼƽ��',width:100,align:'right'},
	    {field:'TPrescPhNum',title:'Ʒ����',width:80,align:'right'},
	    {field:'TCYFS',title:'��ҩ����',width:80,align:'right'},
	    {field:'TJYFS',title:'���帶��',width:80,align:'right'},
	    {field:'TJYCF',title:'���崦������',width:80,align:'right'}
         ]];  
         
    var dataGridOption={
		url:DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
		columns:columns,
		fitColumns:true
	} 
   //����datagrid	
   $('#prescnotjdg').dhcphaEasyUIGrid(dataGridOption);
}

///��ѯ
function Query()
{	
	var startdatetime=$("#date-start").val();
	var enddatetime=$("#date-end").val();
	var startdate=startdatetime.split(" ")[0];
	var starttime=startdatetime.split(" ")[1];
	var enddate=enddatetime.split(" ")[0];
	var endtime=enddatetime.split(" ")[1];
	var ctloc=DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var prescType="";
	var stkCatId=$("#sel-stk").val();
	if (stkCatId==null){
		stkCatId="";
	}
	var presctype=$("#sel-presctype").val();
	if (presctype==null){
		dhcphaMsgBox.alert("��ѡ����Ҫͳ�ƵĴ�������!");
		return;
	}
	/*var chkop="";
	if($("#chk-OP").is(':checked')){
		chkop="Y";
	}
	var chkem="";
	if($("#chk-EM").is(':checked')){
		chkem="Y";
	}
	if ((chkem=="")&&(chkop=="")){
		dhcphaMsgBox.alert("�빴ѡ��Ҫͳ�Ƶ��ż��ﴦ������!");
		return;
	}*/
	var phNum=$("#txt-phnum").val();
	var tmpSplit=DHCPHA_CONSTANT.VAR.SPLIT;
	gNewCatId=$("#txt-phccat").val()==""?"":gNewCatId;
	var FYFlag=1
	var params=startdate+tmpSplit+enddate+tmpSplit+starttime+tmpSplit+endtime+tmpSplit+ctloc+tmpSplit+prescType+tmpSplit+phNum+tmpSplit+stkCatId+tmpSplit+gNewCatId+tmpSplit+presctype+tmpSplit+"EasyUI"+tmpSplit+FYFlag;
	$('#prescnotjdg').datagrid({
     	queryParams:{
	     	ClassName:"PHA.OP.PreStat.Query",
	     	QueryName:"GLocPresc",
			Params:params //�˴�params�����ָ�,���Ӳ�ָ����Լ�˳��ͬ��Ӧquery
		}
	});
		
}


//���
function ClearConditions(){
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("T")+" "+"00:00:00");
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("T")+" "+"00:00:00");
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("T")+" "+"23:59:59");
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("T")+" "+"23:59:59");

	$("#txt-phnum").val("");
	$("#sel-stk").empty();
	gNewCatId="";
	$("#sel-presctype").empty();
	$("#txt-phccat").val("");
	//$("#chk-OP").iCheck('uncheck');
	//$("#chk-EM").iCheck('uncheck');
	$('#prescnotjdg').clearEasyUIGrid();
}


//��ӡ
function BPrintHandler(){	
	if($('#prescnotjdg').datagrid('getData').rows.length == 0) //��ȡ���������������
	{
		dhcphaMsgBox.alert("ҳ��û������");
		return ;
	}
	var PrescNotjdgOption=$("#prescnotjdg").datagrid("options")
	var PrescNotjdgparams=encodeURIComponent(PrescNotjdgOption.queryParams.Params);
	var PrescNotjdgUrl=PrescNotjdgOption.url;
	var classname="PHA.OP.PreStat.Query";
	var queryname="GLocPresc";
	$.ajax({
		type: "GET",
		url: PrescNotjdgUrl+"?page=1&rows=9999&ClassName="+classname+"&QueryName="+queryname+"&Params="+PrescNotjdgparams,
		async:false,
		dataType: "json",
		success: function(prescnotjdata){
			var HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID']);
			var startdatetime=$("#date-start").val();
			var enddatetime=$("#date-end").val();
			var datetimerange=startdatetime+" �� "+enddatetime;
			PRINTCOM.XML({
				printBy: 'lodop',
				XMLTemplate: 'PHAOPPrescStat',
				data:{
					Para: {
						titlemain:HospitalDesc+"����ͳ��",
						titlesecond: "ҩ��:"+DHCPHA_CONSTANT.DEFAULT.LOC.text+"     ͳ�Ʒ�Χ:"+datetimerange,
						lasttitle:"��ӡ��:"+DHCPHA_CONSTANT.SESSION.GUSER_NAME+"      ��ӡʱ��:"+getPrintDateTime()
					},
					List: prescnotjdata.rows
				},
				aptListFields: ["lasttitle"],
				listBorder: {style:4, startX:1, endX:195,space:1},
			})

			
		}
	});
}
	
