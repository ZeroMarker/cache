/*
ģ��:		��ҩ��
��ģ��:		��ҩ��-����Э��������
Creator:	hulihua
CreateDate:	2017-12-12
*/
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
$(function(){
	/* ��ʼ����� start*/
	$("#date-daterange").dhcphaDateRange();
	InitPhaLoc(); 				//ҩ������
	InitPhaWard(); 				//����
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
	
	SetDefaultDate();
	SetLogPhaLoc();				//��ҩ�����Ҹ�Ĭ��ֵ��
	InitBodyStyle();
})

window.onload=function(){
	setTimeout("QueryReqDspTotal()",500);
}

//���뵥�޸�
function UpdateAgrParReq(){
	var lnk="dhcpha/dhcpha.inpha.hmdepagrparupreq.csp";
	window.open(lnk,"_target","width="+(window.screen.availWidth-10)+",height="+(window.screen.availHeight-10)+ ",menubar=no,status=yes,toolbar=no,resizable=yes,top='0',left='110',location=no");	
}

//��ʼ����ҩ����table
function InitGridOrdTotal(){
	var columns=[
		{name:"TPID",index:"TPID",header:'TPID',width:100,align:'left',hidden:true},
		{name:"TArcimDr",index:"TArcimDr",header:'TArcimDr',width:60,align:'left',hidden:true},	
		{name:"TDesc",index:"TDesc",header:'Э��������',width:120,align:'left'},
		{name:"TQty",index:"TQty",header:'��������',width:60,align:'right'},
		{name:'TReqQty',index:'TReqQty',header:'��������',width:60,
			editable:true,
			cellattr:addTextCellAttr,
			inputlimit:{
	           	number:true,
	        	negative:false
	        }
		},
		{name:"TUom",index:"TUom",header:'��λ',width:60}
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.HMDepartDisp.AgrPartyDispReq&MethodName=jsQueryAgrPartyReq&querytype=total', //��ѯ��̨	
	    height: DhcphaJqGridHeight(1,1)-$("#panel div_content .panel-heading").height()-10,
	    multiselect: false,
	    shrinkToFit:false,
	    rownumbers: true,	
	    datatype:'local',   
		onSelectRow:function(id,status){
			if ((JqGridCanEdit==false)&&(LastEditSel!="")&&(LastEditSel!=id)){
			    $("#grid-depagrptotal").jqGrid('setSelection',LastEditSel);
			    return
			}
			if ((LastEditSel!="")&&(LastEditSel!=id)){
				$(this).jqGrid('saveRow', LastEditSel);
			}			
			$(this).jqGrid("editRow", id,{oneditfunc:function(){
				$editinput = $(event.target).find("input");
				$editinput.focus(); 
				$editinput.select();
				$("#"+id+"_TReqQty").on("focusout || mouseout",function(){	
					var iddata=$('#grid-depagrptotal').jqGrid('getRowData',id);
					var dspqty=iddata.TQty;								
					if (parseFloat(this.value*1000)>parseFloat(dspqty*1000)) {
						dhcphaMsgBox.message("��"+id+"�������������ڻ�������!")
						$("#grid-depagrptotal").jqGrid('restoreRow',id);
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
	$('#grid-depagrptotal').dhcphaJqGrid(jqOptions);
	PhaGridFocusOut('grid-depagrptotal');
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
		{name:"TRegNo",index:"TRegNo",header:'�ǼǺ�',width:80},	
		{name:"TBedNo",index:"TBedNo",header:'����',width:60},
		{name:"TPaName",index:"TPaName",header:'����',width:100},
		{name:"TAge",index:"TAge",header:'����',width:60},			
		{name:"Tsex",index:"Tsex",header:'�Ա�',width:40},
		{name:"TDesc",index:"TDesc",header:'Э��������',width:120,align:'left'},		
		{name:"TQty",index:"TQty",header:'����',width:50,align:'right'},		
		{name:"TPrescNo",index:"TPrescNo",header:'������',width:90},	
		{name:"TDispIdStr",index:"TDispIdStr",header:'TDispIdStr',width:80,hidden:true},
		{name:"Toedis",index:"Toedis",header:'Toedis',width:80,hidden:true}						
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.HMDepartDisp.AgrPartyDispReq&MethodName=jsQueryAgrPartyReq&querytype=detail&style=jqGrid', //��ѯ��̨	
	    height: DhcphaJqGridHeight(1,1)-$("#panel div_content .panel-heading").height()-45,
	    multiselect: false,
	    shrinkToFit:false,
	    datatype:'local',
	    rownumbers: true,
	    pager: "#jqGridPager1", //��ҳ�ؼ���id  
		onPaging:function(pgButton){
			ReLoadAddPid();
		}
	};
	$('#grid-depagrpdetail').dhcphaJqGrid(jqOptions);
	$("#refresh_grid-depagrpdetail").hide(); //�˴�ˢ��������
}

function ReLoadAddPid(){
	if ($("#grid-depagrpdetail").getGridParam('records')>0){
		var firstrowdata = $("#grid-depagrpdetail").jqGrid("getRowData", 1);
		var Pid= firstrowdata.TPID
		$("#grid-depagrpdetail").setGridParam({
			datatype:'json',
			page:1,
			postData:{
				Pid:Pid
			}
		})				
	}
}

//��ѯ����ҩ�б�
function QueryReqDspTotal(Pid){
	if (Pid==undefined){Pid="";}
	var params=GetQueryDispParams();
	if(params!=""){
		if ($("#div-detail").is(":hidden")==false){
			$("#grid-depagrpdetail").setGridParam({
				datatype:'json',
				page:1,
				postData:{
					params:params,
					Pid:Pid
				}
			}).trigger("reloadGrid");
		}else{
			$("#grid-depagrptotal").setGridParam({
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
	var phaloc=$('#sel-phaloc').val();
	if (phaloc==null){phaloc=""}
	if (phaloc==""){
		dhcphaMsgBox.alert("ҩ��������Ϊ��!");
		return "";
	}
	var wardloc=$('#sel-phaward').val();
	if (wardloc==null){wardloc=""};
	var reqstatus="R";
	var params=phaloc+"!!"+gLocId+"!!"+gUserID+"!!"+reqstatus+"!!"+wardloc;
	return 	params;
}

//�������뵥
function SaveAgrParReq(){
	if ($("#sp-title").text()=="Э������ϸ"){
		if (DhcphaGridIsEmpty("#grid-depagrpdetail")==true){
			return;
		}
	}else if ($("#sp-title").text()=="Э��������"){
		if (DhcphaGridIsEmpty("#grid-depagrptotal")==true){
			return;
		}
	}
	dhcphaMsgBox.confirm("�Ƿ�ȷ������?",DoReq);
}
function DoReq(result){
	if (result==true){
		var pid="";
		if ($("#sp-title").text()=="Э������ϸ"){
			var firstrowdata = $("#grid-depagrpdetail").jqGrid("getRowData", 1);
			pid= firstrowdata.TPID
		}else if ($("#sp-title").text()=="Э��������"){
			var firstrowdata = $("#grid-depagrptotal").jqGrid("getRowData", 1);
			pid= firstrowdata.TPID
		}
		var reqtotalrowdata = $("#grid-depagrptotal").jqGrid('getRowData');
	    var reqtotalgridrows=reqtotalrowdata.length;
		if (reqtotalgridrows<=0){
			dhcphaMsgBox.alert("û����������!");
			return;
		}

		var reqQtyString="";	
		for(var rowi=0;rowi<reqtotalgridrows;rowi++){
			var arcimDr=reqtotalrowdata[rowi].TArcimDr
			var dspQty=reqtotalrowdata[rowi].TQty
			var reqQty=reqtotalrowdata[rowi].TReqQty
			dspQty=$.trim(dspQty);
			reqQty=$.trim(reqQty);
			if(parseFloat(reqQty)>parseFloat(dspQty)){
				dhcphaMsgBox.alert("��"+parseFloat(rowi+1)+"�������������ܴ��ڻ�������!");
				return;
			}
			if (parseFloat(reqQty)<0){
				dhcphaMsgBox.alert("��"+parseFloat(rowi+1)+"��������������С��0!");
				return;
			}
			if ((reqQty=="")||(reqQty==null)){
				dhcphaMsgBox.alert("��"+parseFloat(rowi+1)+"����������Ϊ�յ���Ϊ0!");
				return;
			}

			var tmpreqstring=arcimDr+"^"+dspQty+"^"+reqQty;
			if (reqQtyString==""){
				reqQtyString=tmpreqstring;
			}
			else{
				reqQtyString=reqQtyString+"!!"+tmpreqstring;
			}
			
		} 
		if((tmpreqstring=="")||(tmpreqstring==null)){
			dhcphaMsgBox.alert("������ϢΪ�գ����ʵ!");
			return;
		}
		var params=GetQueryDispParams();
		
		var PhaAprRowid=tkMakeServerCall("web.DHCINPHA.HMDepartDisp.AgrPartyDispReq","SaveReqData",params,reqQtyString);
		if(PhaAprRowid=="-1"){
			dhcphaMsgBox.alert("���뵥��ϢΪ��!") ;
	 		return;
		}else if(PhaAprRowid=="-2"){
			dhcphaMsgBox.alert("����ʧ��!") ;
	 		return;
		}else if(PhaAprRowid=="-3"){
			dhcphaMsgBox.alert("�������뵥��ʧ��!") ;
	 		return;
		}else if(PhaAprRowid=="-4"){
			dhcphaMsgBox.alert("��������δ��������뵥�������ȴ���!") ;
	 		return;
		}else if(PhaAprRowid=="-5"){
			dhcphaMsgBox.alert("������������ʧ��!") ;
	 		return;
		}else if(PhaAprRowid=="-6"){
			dhcphaMsgBox.alert("��������IDΪ��!") ;
	 		return;
		}else if(PhaAprRowid=="-7"){
			dhcphaMsgBox.alert("�п���Э������ҽ����IDΪ�գ����ʵ!") ;
	 		return;
		}else if(PhaAprRowid=="-8"){
			dhcphaMsgBox.alert("�п���Э�������������������˻�������!") ;
	 		return;
		}else if(PhaAprRowid=="-9"){
			dhcphaMsgBox.alert("�������뵥�ӱ�ʧ��!") ;
	 		return;
		}else if ((PhaAprRowid<0)||(PhaAprRowid=="")||(PhaAprRowid==0)){
			dhcphaMsgBox.alert("�������Э����ʧ�ܣ�"+PhaAprRowid) ;
	 		return;
		}else{
			dhcphaMsgBox.alert("����ɹ���") ;
			$("#grid-depagrptotal").jqGrid("clearGridData");
			$("#grid-depagrpdetail").jqGrid("clearGridData");
			KillDetailTmp();
			QueryReqDspTotal();
		}
	}
}

//��ϸ�ͻ����л����ò�ѯ
function ChangeDispQuery(){
	var Pid="";
	if ($("#sp-title").text()=="Э��������"){
		$("#sp-title").text("Э������ϸ");
		$("#div-total").hide();
		$("#div-detail").show();
		if ($("#grid-depagrpdetail").getGridParam('records')==0){
			if ($("#grid-depagrptotal").getGridParam('records')>0){
				var firstrowdata = $("#grid-depagrptotal").jqGrid("getRowData", 1);
				Pid= firstrowdata.TPID
			}
			QueryReqDspTotal(Pid);
		}
	}else{
		$("#sp-title").text("Э��������")
		$("#div-detail").hide();
		$("#div-total").show(); //ÿ�ε�����ܶ�Ҫ���»���
		if ($("#grid-depagrpdetail").getGridParam('records')>0){
			var firstrowdata = $("#grid-depagrpdetail").jqGrid("getRowData", 1);
			Pid= firstrowdata.TPID
		}
		QueryReqDspTotal(Pid);
	}
}

//�ѷ�ҩ��ѯ����
function DispQuery(){
	var daterange=$("#date-daterange").val(); 
	daterange=FormatDateRangePicker(daterange);                       
 	var startdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];
	var phaloc="96";
	var wardloc=gLocId;
	if (wardloc==null){wardloc=""}
	var aprstatus="R,D,C";
	var locdesc=gLocDesc;
	//Ԥ����ӡ	
	fileName="DHCINPHA_DispStat_AgrPartyWardReq&StartDate="+startdate+"&EndDate="+enddate+"&AprStatusStr="+aprstatus+"&PhaLocId="+phaloc+"&WardLocId="+wardloc+"&LocDesc="+locdesc+"&StatType=2";
	DHCST_RQPrint(fileName);
}

//��������С
function InitBodyStyle(){
	var tmpheight=DhcphaJqGridHeight(1,1)-$("#panel div_content .panel-heading").height()-10;
	$("#grid-depagrptotal").setGridHeight(tmpheight);
	$("#grid-depagrpdetail").setGridWidth("");
	$("#div-detail").hide();
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

//�����ڿؼ�Ĭ��ֵ
function SetDefaultDate(){
	var phaloc=$('#sel-phaloc').val();
	if (phaloc==null){phaloc=""}
	if (phaloc==""){
		dhcphaMsgBox.alert("ҩ��������Ϊ��!");
		return "";
	}
	var wardloc=$('#sel-phaward').val();
	if (wardloc==null){wardloc=gLocId};
	return false;		
}

//ҩ�����Ҹ�Ĭ��ֵ��
function SetLogPhaLoc(){
	var LogLocid=""
	if (gHospID=="1"){
		LogLocid="96";		//��ҽԺԺ��Ĭ��Ϊ�ƺ�·�е���
	}
	if((LogLocid=="")||(LogLocid==gLocId)){
		return;
	}
	var LogLocArr=tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod","GetLocInfoById",LogLocid);
	var LogLocDesc=LogLocArr.split("^")[1];
	var select2option = '<option value='+"'"+LogLocid +"'"+'selected>'+LogLocDesc+'</option>'
	$("#sel-phaloc").append(select2option);
}

function KillDetailTmp(){
	var Pid="";
	if ($("#sp-title").text()=="Э��������"){
		if ($("#grid-depagrptotal").getGridParam('records')>0){
			var firstrowdata = $("#grid-depagrptotal").jqGrid("getRowData", 1);
			Pid=firstrowdata.TPID;
		}			
	}else{
		if ($("#grid-depagrpdetail").getGridParam('records')>0){
			var firstrowdata = $("#grid-depagrpdetail").jqGrid("getRowData", 1);
			Pid= firstrowdata.TPID
		}
	}
	KillInDispTmp(Pid)
}
function KillInDispTmp(pid){
	if (pid!=""){
		tkMakeServerCall("web.DHCINPHA.HMDepartDisp.AgrPartyDispReq","KillTmp",pid);
	}
}

window.onbeforeunload = function (){
	KillDetailTmp();
}