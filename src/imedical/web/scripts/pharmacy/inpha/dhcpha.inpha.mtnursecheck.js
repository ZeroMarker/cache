/*
 *ģ��:�ƶ�סԺҩ��
 *��ģ��:�ƶ�סԺҩ��-��ʿ��ҩ���
 *createdate:2016-10-21
 *creator:dinghongying
*/

$(function(){
	/* ��ʼ����� start*/
	var daterangeoptions={
		timePicker : true, 
		timePickerIncrement:1,
		locale: {
			format: DATEFMT
		}
	}
	$("#date-daterange").dhcphaDateRange(daterangeoptions);
	
	//�����ڿؼ�����ʼ��ֵ��
	var configstr=tkMakeServerCall("web.DHCSTPHALOC","GetPhaflag",gLocId);
	var configarr=configstr.split("^");
	var startdate=configarr[2];
	var enddate=configarr[3] ;
	startdate=FormatDateT(startdate);
	enddate=FormatDateT(enddate);
	$("#date-daterange").data('daterangepicker').setStartDate(startdate);
	$("#date-daterange").data('daterangepicker').setEndDate(enddate);
	
	InitGirdPreList();
	InitGridPreIncList();
	InitGirdPreOrderList();
	
	/* ��Ԫ���¼� start*/
	//����ʧȥ���㴥���¼�
	$('#txt-cardno').on('blur',function(event){
		var cardno=$.trim($("#txt-cardno").val());
		$('#currentnurse').text("");
		$('#currentctloc').text("");
		if (cardno!=""){
			var defaultinfo=tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod","GetUserDefaultInfo",cardno);
			if (defaultinfo==null||defaultinfo==""){
			dhcphaMsgBox.alert("���빤���������ʵ!");
			$('#txt-cardno').val("");
			return;
			}
		var ss=defaultinfo.split("^");
		$('#currentnurse').text(ss[2]);
		$('#currentctloc').text(ss[4]);
		$('#txt-cardno').val("");				
		}
	});

	InitBodyStyle();
})

//��ʼ����ҩ���б�table
function InitGirdPreList(){
	var columns=[
		{header:'ID',index:'TPhdwID',name:'TPhdwID',width:60,hidden:true},
		{header:'��ҩ����',index:'TPhdwNo',name:'TPhdwNo',width:160},
		{header:'��ҩ����',index:'TPhdwDate',name:'TPhdwDate',width:100},
		{header:'��ҩʱ��',index:'TPhdwTime',name:'TPhdwTime',width:100},
		{header:'��ҩ��',index:'TPhdwCompUser',name:'TPhdwCompUser',width:100}
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.MTNurseCheck.NurseCheckQuery&MethodName=GetInPhDrawList',	
	    height: OutFYCanUseHeight()+120,
	    recordtext:"",
	    pgtext:"",
	    shrinkToFit:false,
	    onSelectRow:function(id,status){
			QueryGridPreInc();
		},loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#grid-dispdetail").clearJqGrid();
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
		
	};
	$("#grid-preparelist").dhcphaJqGrid(jqOptions);
}

//��ʼ����ҩ��ҩƷ����table
function InitGridPreIncList(){
	var columns=[
		{header:'TPhdwiID',index:'TPhdwiID',name:'TPhdwiID',width:60,hidden:true},
	    {header:'ҩƷ����',index:'TInciDesc',name:'TInciDesc',width:360},
	    {header:'���',index:'TSpec',name:'TSpec',width:100},
	    {header:'��λ',index:'TPhdwUom',name:'TPhdwUom',width:100},
	    {header:'��ҩ����',index:'TQtyTotal',name:'TQtyTotal',width:80},
	    {header:'ʵ������',index:'TQtyActual',name:'TQtyActual',width:80}
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.MTNurseCheck.NurseCheckQuery&MethodName=GetInPhDrawIncList',		
	    height: OutFYCanUseHeight()*0.5,
	    multiselect: false,
	    pager: "#jqGridPager", //��ҳ�ؼ���id  
	    shrinkToFit:false,
	    onSelectRow:function(id,status){
			QueryGridPreOrder();
		},
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#grid-preorderlist").clearJqGrid();
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
	};
	$("#grid-preinclist").dhcphaJqGrid(jqOptions);
}

//��ҩ��������ϸtable
function InitGirdPreOrderList(){
	var columns=[
		{header:'�ǼǺ�',index:'TPatNo',name:'TPatNo',width:80,align:'left'},
	    {header:'����',index:'TPatName',name:'TPatName',width:150,align:'left'},
		{header:'��λ��',index:'TBed',name:'TBed',width:80,align:'right'},
		{header:'��λ',index:'TDspUom',name:'TDspUom',width:60},
		{header:'Ӧ����',index:'TDspQty',name:'TDspQty',width:100},
		{header:'��ҩ��',index:'TQty',name:'TQty',width:100}
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.MTNurseCheck.NurseCheckQuery&MethodName=GetInPhDrawOrderList',	
	    height: OutFYCanUseHeight()*0.5,
	    shrinkToFit:false
	};
	$("#grid-preorderlist").dhcphaJqGrid(jqOptions);
}

//��ѯ��ҩ���б�
function QueryGridPre(){
	var currentnurse=$.trim($("#currentnurse").text());
	var currentctloc=$.trim($("#currentctloc").text());
	if (currentnurse==null||currentnurse==""||currentctloc==null||currentctloc==""){
	    dhcphaMsgBox.alert("����ˢ��ҩ�˵Ŀ��������빤��!");
	    return;
	}
	var daterange=$("#date-daterange").val(); 
	daterange=FormatDateRangePicker(daterange);                       
 	var stdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];	
	var params=stdate+"^"+enddate+"^"+gLocId;

	$("#grid-preparelist").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

//��ѯ��ҩ��ҩƷ����
function QueryGridPreInc(){
	var selectid = $("#grid-preparelist").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-preparelist").jqGrid('getRowData', selectid);
	var phdwid=selrowdata.TPhdwID;
	var params=phdwid;

	$("#grid-preinclist").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
	$("#grid-preorderlist").clearJqGrid();
}

//��ѯ��ҩ��������ϸ
function QueryGridPreOrder(){
	var selectid = $("#grid-preinclist").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-preinclist").jqGrid('getRowData', selectid);
	var phdwiid=selrowdata.TPhdwiID;
	var params=phdwiid;
	$("#grid-preorderlist").setGridParam({
		postData:{
			'params':params
		}	
	}).trigger("reloadGrid");
}

//���
function ClearConditions(){
	$('#currentnurse').text("");
	$('#currentctloc').text("");
	$("#grid-preparelist").clearJqGrid();
	$("#grid-preinclist").clearJqGrid();
	$("#grid-preorderlist").clearJqGrid();
	var tmpstartdate=FormatDateT("t-2")
	$("#date-daterange").data('daterangepicker').setStartDate(tmpstartdate);
	$("#date-daterange").data('daterangepicker').setEndDate(new Date());
	return
	if ($("#col-right").is(":hidden")==false){
		$("#col-right").hide();
		$("#col-left").removeClass("col-lg-9 col-md-9 col-sm-9")
	}else{
		$("#col-right").show()
		$("#col-left").addClass("col-lg-9 col-md-9 col-sm-9")
	}
	$("#grid-preparelist").setGridWidth("")
	$("#grid-preinclist").setGridWidth("")
	$("#grid-preorderlist").setGridWidth("")
}

//��ҳ��table���ø߶�
function OutFYCanUseHeight(){
	var height1=$("[class='container-fluid dhcpha-condition-container']").height();
	var height3=parseFloat($("[class='panel div_content']").css('margin-top'));
	var height4=parseFloat($("[class='panel div_content']").css('margin-bottom'));
	var height5=parseFloat($("[class='panel-heading']").height());
	var tableheight=$(window).height()-height1*2-2*height3-2*height4-2*height5-125;
	return tableheight;
}

function InitBodyStyle(){
	$("#grid-preparelist").setGridWidth("")
}

