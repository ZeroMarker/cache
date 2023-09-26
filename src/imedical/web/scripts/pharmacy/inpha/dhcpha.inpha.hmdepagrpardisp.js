/*
ģ��:		��ҩ��
��ģ��:		��ҩ��-����Э������ҩ
Creator:	hulihua
CreateDate:	2017-11-15
*/
DHCPHA_CONSTANT.VAR.PARAMS="";
$(function(){
	/* ��ʼ����� start*/
	$("#date-daterange").dhcphaDateRange();
	InitPhaLoc(); 				//ҩ������
	InitPhaLocWard(); 			//��������
	InitGridDispWard(); 		//�����б�
	InitGridOrdTotal();			//Э��������
	InitGridOrdDetail();		//Э������ϸ
	$("#monitor-condition").children().not("#div-ward-condition").hide();	
	/* ��ʼ����� end*/
	
	/* ��Ԫ���¼� start*/
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	/* ��Ԫ���¼� end*/
	
	InitBodyStyle();
})

window.onload=function(){
	setTimeout("QueryDispWardList()",500);
}

//��ʼ������ҩ���table
function InitGridDispWard(){
	var columns=[
		{name:"TPhaAprId",index:"TPhaAprId",header:'TPhaAprId',width:10,hidden:true},
		{name:"TPhaAprWard",index:"TPhaAprWard",header:'TPhaAprWard',width:10,hidden:true},
		{name:"TFromWardLoc",index:"TFromWardLoc",header:'TFromWardLoc',width:10,hidden:true},
		{name:"TAgrReqDate",index:"TAgrReqDate",header:'��������',width:150},		
		{name:"TWardLoc",index:"TWardLoc",header:'����',width:200,align:'left',formatter:splitFormatter},
		{name:"TFromWardDesc",index:"TFromWardDesc",header:'��Դ����',width:160},
		{name:"TAgrReqNo",index:"TAgrReqNo",header:'���뵥��',width:140},
		{name:"TAgrReqUser",index:"TAgrReqUser",header:'������',width:80}						
	];
	var jqOptions={
	    colModel: columns, //��
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery&MethodName=jsQueryAgrParReqList',	//��ѯ��̨
	    height:DhcphaJqGridHeight(1,1)-35,
	    multiselect: false,
	    shrinkToFit:false,
	    multiboxonly :false,
	    rownumbers: true,
	    datatype:"local", 
	    onSelectRow:function(id,status){
			var id = $(this).jqGrid('getGridParam', 'selrow');
			KillDetailTmp();
			$("#grid-dispdetail").jqGrid("clearGridData");
			if (id==null){
				$('#grid-disptotal').clearJqGrid();
				$('#grid-dispdetail').clearJqGrid();
			}else{
				QueryInDispTotal();
			}
		},
		loadComplete: function(){
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#grid-wardlist").clearJqGrid();
			}else{
				$(this).jqGrid('setSelection',1);
			} 		
			$(this).on("click",function(){
				if (this.name==""){
					KillDetailTmp();
					QueryInDispTotal();
				}
			})
		}
	};
	$('#grid-wardlist').dhcphaJqGrid(jqOptions);
}

//��ʼ����ҩ����table
function InitGridOrdTotal(){
	var columns=[
		{name:"TPID",index:"TPID",header:'TPID',width:100,align:'left',hidden:true},
		{name:"TPhaApriId",index:"TPhaApriId",header:'TPhaApriId',width:60,align:'left',hidden:true},
		{name:"TArcimDr",index:"TArcimDr",header:'TArcimDr',width:60,align:'left',hidden:true},	
		{name:"TDesc",index:"TDesc",header:'Э��������',width:160,align:'left'},
		{name:"TAccQty",name:"TAccQty",header:'��������',width:60,align:'right'},
		{name:"TReqQty",name:"TReqQty",header:'��������',width:60,align:'right'},
		{name:'TDspQty',index:'TDspQty',header:'ʵ������',width:60,align:'right'},
		{name:"TUom",name:"TUom",header:'��λ',width:60}
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery&MethodName=jsQueryInDisp&querytype=total', //��ѯ��̨	
	    height: DhcphaJqGridHeight(2,1)-$("#panel div_content .panel-heading").height(),
	    multiselect: false,
	    shrinkToFit:false,
	    rownumbers: true,
	    datatype:'local',   
		onSelectRow:function(id,status){
			if ((JqGridCanEdit==false)&&(LastEditSel!="")&&(LastEditSel!=id)){
			    $("#grid-disptotal").jqGrid('setSelection',LastEditSel);
			    return
			}
			if ((LastEditSel!="")&&(LastEditSel!=id)){
				$(this).jqGrid('saveRow', LastEditSel);
			}			
			$(this).jqGrid("editRow", id,{oneditfunc:function(){
				$editinput = $(event.target).find("input");
				$editinput.focus(); 
				$editinput.select();
				$("#"+id+"_TDspQty").on("focusout || mouseout",function(){	
					var iddata=$('#grid-disptotal').jqGrid('getRowData',id);
					var accqty=iddata.TAccQty;								
					if (parseFloat(this.value*1000)>parseFloat(accqty*1000)) {
						dhcphaMsgBox.message("��"+id+"��ʵ���������ڻ�������!")
						$("#grid-disptotal").jqGrid('restoreRow',id);
						JqGridCanEdit=false
						return false
					}else{
						JqGridCanEdit=true
						return true
					}
				});
			}});
			LastEditSel=id;
		}
	};
	$('#grid-disptotal').dhcphaJqGrid(jqOptions);
	PhaGridFocusOut('grid-disptotal');
}
function splitFormatter(cellvalue, options, rowObject){ 
	if(cellvalue.indexOf("-")>=0){
		cellvalue=cellvalue.split("-")[1];
	} 
	return cellvalue;  
};  
//��ʼ����ҩ��ϸtable
function InitGridOrdDetail(){
	var columns=[
		{name:"TPID",index:"TPID",header:'TPID',width:80,hidden:true},		
		{name:"TAdmLoc",index:"TAdmLoc",header:'����',width:125,formatter:splitFormatter},	
		{name:"TBedNo",index:"TBedNo",header:'����',width:80},
		{name:"TRegNo",index:"TRegNo",header:'�ǼǺ�',width:100},
		{name:"TPaName",index:"TPaName",header:'����',width:80},
		{name:"TAge",index:"TAge",header:'����',width:60},			
		{name:"Tsex",index:"Tsex",header:'�Ա�',width:60},
		{name:"TDesc",index:"TDesc",header:'Э��������',width:200,align:'left'},		
		{name:"TQty",index:"TQty",header:'����',width:50,align:'right'},		
		{name:"TPrescNo",index:"TPrescNo",header:'������',width:100},	
		{name:"TDispIdStr",index:"TDispIdStr",header:'TDispIdStr',width:80,hidden:true},
		{name:"Toedis",index:"Toedis",header:'Toedis',width:80,hidden:true}						
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery&MethodName=jsQueryInDisp&querytype=detail&style=jqGrid', //��ѯ��̨	
	    height: DhcphaJqGridHeight(2,1)-$("#panel div_content .panel-heading").height()+5,
	    multiselect: false,
	    shrinkToFit:false,
	    datatype:'local',
	    rownumbers: true,
	    pager: "#jqGridPager1", //��ҳ�ؼ���id  
		onPaging:function(pgButton){
			ReLoadAddPid();
		}
	};
	$('#grid-dispdetail').dhcphaJqGrid(jqOptions);
	$("#refresh_grid-dispdetail").hide(); //�˴�ˢ��������
}


function ReLoadAddPid(){
	if ($("#grid-dispdetail").getGridParam('records')>0){
		var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
		var Pid= firstrowdata.TPID
		$("#grid-dispdetail").setGridParam({
			datatype:'json',
			page:1,
			postData:{
				Pid:Pid
			}
		})				
	}
}

//��ѯ����ҩ����
function QueryDispWardList(){
	var daterange=$("#date-daterange").val(); 
	daterange=FormatDateRangePicker(daterange);                       
 	var startdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];
	var phaloc=$('#sel-phaloc').val();
	if (phaloc==null){phaLoc=""}
	if (phaloc==""){
		dhcphaMsgBox.alert("ҩ��������Ϊ��!");
		return;
	}
	var wardloc=$('#sel-phaward').val();
	if (wardloc==null){wardloc=""}
	
	var params=startdate+"!!"+enddate+"!!"+phaloc+"!!"+wardloc;
	$("#grid-wardlist").setGridParam({
		datatype:'json',
		page:1,
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
	KillDetailTmp();
	$('#grid-disptotal').clearJqGrid();
	$('#grid-dispdetail').clearJqGrid();
}

//��ѯ����ҩ�б�
function QueryInDispTotal(Pid){
	if (Pid==undefined){Pid="";}
	var params=GetQueryDispParams();
	if(params!=""){
		if ($("#div-detail").is(":hidden")==false){
			$("#grid-dispdetail").setGridParam({
				datatype:'json',
				page:1,
				postData:{
					params:params,
					Pid:Pid
				}
			}).trigger("reloadGrid");
		}else{
			$("#grid-disptotal").setGridParam({
				datatype:'json',
				page:1,
				postData:{
					params:params,
					Pid:Pid
				}
			}).trigger("reloadGrid");
		}	
	}
}

function GetQueryDispParams(){
	if($("#div-ward-condition").is(":hidden")==false){
		var selectid = $("#grid-wardlist").jqGrid('getGridParam', 'selrow');
		if ((selectid=="")||(selectid==null)){
			dhcphaMsgBox.alert("����ѡ����Ҫ��ҩ�����뵥!");
			$('#grid-disptotal').clearJqGrid();
			$('#grid-dispdetail').clearJqGrid();
			return "";
		}
		var selrowdata = $("#grid-wardlist").jqGrid('getRowData', selectid);
		var dispWard=selrowdata.TPhaAprWard;
		var phaaprid=selrowdata.TPhaAprId;
		var fromwardloc=selrowdata.TFromWardLoc;
	}else{
		dhcphaMsgBox.alert("��ˢ�½��������!");
		return "";
	}
	var phaloc=$('#sel-phaloc').val();
	if (phaloc==null){phaloc=""}
	if (phaloc==""){
		dhcphaMsgBox.alert("ҩ��������Ϊ��!");
		return "";
	}
	var dispCats="XDCF";
	var params=phaloc+"!!"+dispWard+"!!"+gUserID+"!!"+dispCats+"!!"+phaaprid+"!!"+fromwardloc;
	return 	params;
}

//��ҩ
function ConfirmDisp(){
	if ($("#sp-title").text()=="Э������ϸ"){
		if (DhcphaGridIsEmpty("#grid-dispdetail")==true){
			return;
		}
	}else if ($("#sp-title").text()=="Э��������"){
		if (DhcphaGridIsEmpty("#grid-disptotal")==true){
			return;
		}
	}
	dhcphaMsgBox.confirm("�Ƿ�ȷ�Ϸ�ҩ?",DoDisp);
}
function DoDisp(result){
	if (result==true){
		var dispflag="";
		//ȡ�Ƿ�¼�뷢ҩ������
		if (DHCPHA_CONSTANT.VAR.PARAMS!=""){
			var paramsarr=DHCPHA_CONSTANT.VAR.PARAMS.split("^");
			var dispuserflag=paramsarr[17];
			var operaterflag=paramsarr[21];
			if ((dispuserflag=="Y")||(operaterflag=="Y")){
				dispflag=1;
				$('#modal-inphaphauser').modal('show');
			}
		}
		if (dispflag==""){
			ExecuteDisp({});
		}
	}
}
function ExecuteDisp(dispoptions){
	var pid="";
	if ($("#sp-title").text()=="Э������ϸ"){
		var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
		pid= firstrowdata.TPID
	}else if ($("#sp-title").text()=="Э��������"){
		var firstrowdata = $("#grid-disptotal").jqGrid("getRowData", 1);
		pid= firstrowdata.TPID
	}
	if (dispoptions.operateuser==undefined){
		dispoptions.operateuser="";
	}
	if (dispoptions.phauser==undefined){
		dispoptions.phauser=gUserID;
	}
	var phaloc=$("#sel-phaloc").val();
	//������ҩ
	var selectid = $("#grid-wardlist").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-wardlist").jqGrid('getRowData', selectid);
	var wardid=selrowdata.TPhaAprWard;
	var phaaprid=selrowdata.TPhaAprId;
	var cat="XDCF";
	var MainInfo=phaloc+"^"+wardid+"^"+phaaprid+"^"+dispoptions.phauser;
	
	var disptotalrowdata = $("#grid-disptotal").jqGrid('getRowData');
    var disptotalgridrows=disptotalrowdata.length;
	if (disptotalgridrows<=0){
		dhcphaMsgBox.alert("û����������!");
		return;
	}

	var DispString="";	
	for(var rowi=0;rowi<disptotalgridrows;rowi++){
		var phaApriId=disptotalrowdata[rowi].TPhaApriId;
		var arcimDr=disptotalrowdata[rowi].TArcimDr;
		var accQty=disptotalrowdata[rowi].TAccQty;
		var reqQty=disptotalrowdata[rowi].TReqQty;
		var dispQty=disptotalrowdata[rowi].TDspQty;
		phaApriId=$.trim(phaApriId);
		accQty=$.trim(accQty);
		reqQty=$.trim(reqQty);
		dispQty=$.trim(dispQty);
		if(parseFloat(dispQty)>parseFloat(accQty)){
			dhcphaMsgBox.alert("ʵ���������ܴ��ڻ�������!");
			return;
		}
		if (parseFloat(dispQty)<0){
			dhcphaMsgBox.alert("ʵ����������С��0!");
			return;
		}

		var tmpdispstring=phaApriId+"^"+arcimDr+"^"+reqQty+"^"+dispQty;
		if (DispString==""){
			DispString=tmpdispstring;
		}
		else{
			DispString=DispString+"!!"+tmpdispstring;
		}
		
	} 
	if((DispString=="")||(DispString==null)){
		dhcphaMsgBox.alert("����Э������ϸΪ�գ����ʵ��") ;
 		return;
	}
	var Ret=tkMakeServerCall("web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery","SaveAgrParDisp",pid,MainInfo,DispString);
	if (Ret!=0){
		if (Ret=="-10"){
			dhcphaMsgBox.alert("Э����������ϸ��治�㣬���ʵ��");
			return;
		}else if(Ret=="-99"){
			dhcphaMsgBox.alert("����ʧ�ܣ�����ϵϵͳ����Ա!") ;
			return;
		}else{
			dhcphaMsgBox.alert("���ſ���Э����ʧ��,"+Ret) ;
			return;
		}		
	}
	KillDetailTmp();
	QueryDispWardList();
}

function ChangeDispQuery(){
	var Pid="";
	if ($("#sp-title").text()=="Э��������"){
		$("#sp-title").text("Э������ϸ");
		$("#div-total").hide();
		$("#div-detail").show();
		if ($("#grid-dispdetail").getGridParam('records')==0){
			if ($("#grid-disptotal").getGridParam('records')>0){
				var firstrowdata = $("#grid-disptotal").jqGrid("getRowData", 1);
				Pid= firstrowdata.TPID
			}
			QueryInDispTotal(Pid);
		}
	}else{
		$("#sp-title").text("Э��������")
		$("#div-detail").hide();
		$("#div-total").show(); //ÿ�ε�����ܶ�Ҫ���»���
		if ($("#grid-dispdetail").getGridParam('records')>0){
			var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
			Pid= firstrowdata.TPID
		}
		QueryInDispTotal(Pid);
	}
}

//�ѷ�ҩ��ѯ����
function DispQuery(){
	var daterange=$("#date-daterange").val(); 
	daterange=FormatDateRangePicker(daterange);                       
 	var startdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];
	var phaloc=$('#sel-phaloc').val();
	if (phaloc==null){phaLoc=""}
	if (phaloc==""){
		dhcphaMsgBox.alert("ҩ��������Ϊ��!");
		return;
	}
	var wardloc=$('#sel-phaward').val();
	if (wardloc==null){wardloc=""}
	var aprstatus="D";
	var locdesc=$.trim($('#sel-phaloc option:checked').text());
	//Ԥ����ӡ	
	fileName="DHCINPHA_DispStat_AgrPartyHerMed.raq&StartDate="+startdate+"&EndDate="+enddate+"&AprStatusStr="+aprstatus+"&PhaLocId="+phaloc+"&WardLocId="+wardloc+"&LocDesc="+locdesc+"&StatType=1";
	DHCST_RQPrint(fileName,"");
}

//�༭����������֮����꽻���뿪���浱ǰ����
function PhaGridFocusOut(gridid){
	$("#"+gridid).focusout(function(e){
		if (e.relatedTarget) {
	        var $related = $("#"+gridid).find(e.relatedTarget);
	        if ($related.length <= 0 && LastEditSel!="") {
	            $("#"+gridid).jqGrid('saveRow', LastEditSel);
	        }
	    }
	})
}

function KillDetailTmp(){
	var Pid="";
	if ($("#sp-title").text()=="Э��������"){
		if ($("#grid-disptotal").getGridParam('records')>0){
			var firstrowdata = $("#grid-disptotal").jqGrid("getRowData", 1);
			Pid=firstrowdata.TPID;
		}			
	}else{
		if ($("#grid-dispdetail").getGridParam('records')>0){
			var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
			Pid= firstrowdata.TPID
		}
	}
	KillInDispTmp(Pid)
}
function KillInDispTmp(pid){
	if (pid!=""){
		tkMakeServerCall("web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery","KillTmp",pid);
	}
}

function InitBodyStyle(){
	var tmpheight=DhcphaJqGridHeight(1,1)-$("#div-ward-condition .panel-heading").height()+10;
	$("#grid-disptotal").setGridHeight(tmpheight);
	$("#grid-dispdetail").setGridWidth("");
	$("#div-detail").hide();
	var wardtitleheight=$("#gview_grid-wardlist .ui-jqgrid-hbox").height();
	var wardheight=DhcphaJqGridHeight(1,0)-wardtitleheight-16;
	$("#grid-wardlist").setGridHeight(wardheight);
	
}

window.onbeforeunload = function (){
	KillDetailTmp();
}