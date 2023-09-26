/**
 * ģ��:����ҩ��
 * ��ģ��:����ҩ��-�������
 * createdate:2016-08-04
 * creator:yunhaibao
 * others:ȫ�ֱ�����ô��ڶ�����,���� "OA"
 */
DHCPHA_CONSTANT.DEFAULT.PHLOC="";
DHCPHA_CONSTANT.DEFAULT.PHUSER="";
DHCPHA_CONSTANT.DEFAULT.CYFLAG="";
DHCPHA_CONSTANT.URL.THIS_URL=ChangeCspPathToAll("dhcpha.outpha.outmonitor.save.csp");
DHCPHA_CONSTANT.DEFAULT.APPTYPE="OA";
var PatientInfo = {
	adm: 0,
	patientID: 0,
	episodeID: 0,
	admType: "I",
	prescno: 0,
	orditem: 0,
	zcyflag: 0
};
$(function(){
	CheckPermission();
	/* ��ʼ����� start*/
	$("#date-daterange").dhcphaDateRange();
	InitPhaLoc();
	var cardoptions={
		id:"#sel-cardtype"
	}
	InitSelectCardType(cardoptions);
	InitPrescModalTab();
	InitGridPresc();
	InitGirdPrescDetail();	
	/* ��ʼ����� end*/
	/* ��Ԫ���¼� start*/
	//�ǼǺŻس��¼�
	$('#txt-patno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txt-patno").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				QueryGridPresc();
			}	
		}
	});
	//���Żس��¼�
	$('#txt-cardno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var cardno=$.trim($("#txt-cardno").val());
			if (cardno!=""){
				var cardvalue=$("#sel-cardtype").val();
				var cardvaluearr = cardvalue.split("^");
				var cardnolen = cardvaluearr[17];
				var newcardno=NumZeroPadding(cardno,cardnolen);
				$(this).val(newcardno);
				var patinfo=GetPatientBasicInfo(newcardno,"cardno");
				$('#txt-patno').val(patinfo.patno);	
				QueryGridPresc();			
			}	
		}
	});
	//�������лس��¼�
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	/* ��Ԫ���¼� end*/
	
	/* �󶨰�ť�¼� start*/
	$("#btn-find").on("click",QueryGridPresc);
	$("#btn-prepresc").on("click",ViewPrescAddInfo);
	$("#btn-viewlog").on("click",ViewPrescMonitorLog);
	$("#btn-pass").on("click",PassPresc);
	$("#btn-refuse").on("click",RefusePresc);
	$("#btn-analysis").on("click",PrescAnalyse) //��������
	$("#btn-analysistips").on("click",DaTongYDTS) //Ҫ����ʾ
	$("#btn-readcard").on("click",BtnReadCardHandler); //����
	/* �󶨰�ť�¼� end*/;	
})
window.onload=function(){
	if (LoadPatNo!=""){
		$('#txt-patno').val(LoadPatNo);
	}
	QueryGridPresc();
}

//��ʼ��table
function InitGridPresc(){
	var columns=[
	    {header:'������ҩ',index:'druguse',name:'druguse',width:50,formatter: druguseFormatter},
	    {header:'���',index:'result',name:'result',width:50,cellattr: addPassStatCellAttr},
	    {header:'�ǼǺ�',index:'patid',name:'patid',width:150},
	    {header:'����',index:'patname',name:'patname',width:100},
	    {header:'�Ա�',index:'patsex',name:'patsex',width:40},
	    {header:'����',index:'patage',name:'patage',width:40},
	    {header:'���',index:'path',name:'path',width:50},
	    {header:'����',index:'patw',name:'patw',width:50},
	    {header:'�ѱ�',index:'billtype',name:'billtype',width:100},
	    {header:'������',index:'prescno',name:'prescno',width:125},
	    {header:'���',index:'diag',name:'diag',width:200,align:'left'},
	    {header:'adm',index:'adm',name:'adm',width:200,hidden:true},
	    {header:'papmi',index:'papmi',name:'papmi',width:200,hidden:true},
	    {header:'orditem',index:'orditem',name:'orditem',width:200,hidden:true},
	    {header:'zcyflag',index:'zcyflag',name:'zcyflag',width:200,hidden:true},
	    {header:'dspstatus',index:'dspstatus',name:'dspstatus',width:200,hidden:true},
	    {header:'�������',index:'druguseresult',name:'druguseresult',width:100,hidden:true}
	]; 
	var input=GetQueryParams();	
	var jqOptions={
	    colModel: columns, //��
	    url:DHCPHA_CONSTANT.URL.THIS_URL+'?action=GetAdmPrescList&style=jqGrid&input='+input, //��ѯ��̨	
	    height: DhcphaJqGridHeight(2,3)*0.5,
	    multiselect: true,
	    datatype:"local",
	    //shrinkToFit:false,
	    pager: "#jqGridPager", //��ҳ�ؼ���id  
	    onSelectRow:function(id,status){
		    var prescno="";
		    var audit=false;
			var id = $(this).jqGrid('getGridParam', 'selrow');
			if (id) {
				var selrowdata = $(this).jqGrid('getRowData', id);
			    prescno=selrowdata.prescno;
				if($("#chk-audit").is(':checked')){
					audit=true;
				}
				var params=audit;
			}
			$("#grid-prescdetail").setGridParam({
				page:1,
				datatype:'json',
				postData:{
					'PrescNo':prescno,
					'Input':audit
				}	
			}).trigger("reloadGrid");
			PatientInfo.adm = selrowdata.adm;
			PatientInfo.prescno = selrowdata.prescno;
			PatientInfo.zcyflag = selrowdata.zcyflag;
			PatientInfo.patientID=selrowdata.papmi;
		},
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#grid-prescdetail").clearJqGrid();
			}else{
				$(this).jqGrid('setSelection',1);
			}
		},
		onCellSelect:function(rowIndex,iCol,cellcontent,e){
			var field=$(this).jqGrid('getGridParam','colModel')[iCol].index;
			if (field!="druguse"){
				return
			}
			var content =$(this).jqGrid('getRowData',rowIndex).druguseresult;	
			DHCSTPHCMPASS.AnalysisTips({ Content: content })
		}
	};
	$('#grid-presc').dhcphaJqGrid(jqOptions);
}
//��ʼ����ϸtable
function InitGirdPrescDetail(){
	//var prescdetailWidth=$(".div_content").width();
	var columns=[
	    {header:'ҩƷ����',index:'incidesc',name:'incidesc',width:200,align:'left'},
		{header:'����',index:'qty',name:'qty',width:40},
		{header:'��λ',index:'uomdesc',name:'uomdesc',width:60},
		{header:'����',index:'dosage',name:'dosage',width:60},
		{header:'Ƶ��',index:'freq',name:'freq',width:60},
		{header:'���',index:'spec',name:'spec',width:80},
		{header:'�÷�',index:'instruc',name:'instruc',width:80},
		{header:'��ҩ�Ƴ�',index:'dura',name:'dura',width:80},
		{header:'ʵ���Ƴ�',index:'realdura',name:'realdura',width:80,hidden:true},
		{header:'����',index:'form',name:'form',width:80},
		{header:'����ҩ��',index:'basflag',name:'basflag',width:80},
		{header:'ҽ��',index:'doctor',name:'doctor',width:60},
		{header:'ҽ����������',index:'orddate',name:'orddate',width:120},
		{header:'ҽ����ע',index:'remark',name:'remark',width:70,align:'left'},
		{header:'����',index:'manf',name:'manf',width:150,align:'left'},
		{header:'orditm',index:'orditm',name:'orditm',width:150,hidden:true},
	    {header:'ҽ��״̬',index:'ordstat',name:'ordstat',width:150}
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url:DHCPHA_CONSTANT.URL.THIS_URL+'?action=FindOrdDetailData&style=jqGrid',	
	    height: DhcphaJqGridHeight(2,3)*0.5,
	    shrinkToFit:true,
	    datatype:"local"
		
	};
	$('#grid-prescdetail').dhcphaJqGrid(jqOptions);
}
function InitPhaLoc(){
	var selectoption={
		url:DHCPHA_CONSTANT.URL.COMMON_INPHA_URL+
			"?action=GetStockPhlocDs&style=select2&groupId="+
			DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
		allowClear:false
	}
	$("#sel-phaloc").dhcphaSelect(selectoption)
	var select2option = '<option value='+"'"+DHCPHA_CONSTANT.DEFAULT.LOC.id +"'"+'selected>'+DHCPHA_CONSTANT.DEFAULT.LOC.text+'</option>'
	$("#sel-phaloc").append(select2option); //��Ĭ��ֵ,û�뵽�ð취,yunhaibao20160805
	$('#sel-phaloc').on('select2:select', function (event) { 
		//alert(event)
	});
}
//��ѯδ��˴���
function QueryGridPresc(){
	var params=GetQueryParams();
	$("#grid-presc").setGridParam({
		page:1,
		datatype:'json',
		postData:{
			'input':params
		}
	}).trigger("reloadGrid");
	return true
}
function GetQueryParams(){
	var phaloc=$("#sel-phaloc").val();
 	var daterange=$("#date-daterange").val();
 	daterange=FormatDateRangePicker(daterange);
 	var audit=false;
	if($("#chk-audit").is(':checked')){
		audit=true;
	}
	var patno=$("#txt-patno").val();
	var params=daterange+"^"+phaloc+"^"+patno+"^"+audit;
	return params;
}
//���������չ��Ϣmodal
function ViewPrescAddInfo(){
	var grid_records = $("#grid-presc").getGridParam('records');
	if (grid_records==0){
		dhcphaMsgBox.alert("��ǰ����������!");
		return;
	}
  	var selectid=$("#grid-presc").jqGrid('getGridParam','selrow');
  	if (selectid==null){
		dhcphaMsgBox.alert("����ѡ����Ҫ�鿴�Ĵ�����¼!");
		return;  
	}
	//$("#modal-prescinfo").find(".modal-dialog").css({height:"200px"});
	$("#modal-prescinfo").modal('show');
}
//�鿴��־
function ViewPrescMonitorLog(){
	var grid_records = $("#grid-presc").getGridParam('records');
	if (grid_records==0){
		dhcphaMsgBox.alert("��ǰ����������!");
		return;
	}
  	var selectid=$("#grid-presc").jqGrid('getGridParam','selrow');
  	if (selectid==null){
		dhcphaMsgBox.alert("����ѡ����Ҫ�鿴�Ĵ�����¼!");
		return;  
	}
	var selectdata=$('#grid-presc').jqGrid('getRowData',selectid);
	var orditm=selectdata.orditem;
	var logoptions={
		id:"#modal-monitorlog",
		orditm:orditm,
		fromgrid:"#grid-presc",
		fromgridselid:selectid	
	};
	InitOutMonitorLogBody(logoptions);
}
//ע��modaltab�¼�
function InitPrescModalTab(){
	$("#ul-monitoraddinfo a").on('click',function(){
		var adm = PatientInfo.adm;
		var prescno = PatientInfo.prescno;
		var zcyflag = PatientInfo.zcyflag;
		var patientID=PatientInfo.patientID; 	
		var tabId=$(this).attr("id")
		if (tabId=="tab-allergy"){
			$('iframe').attr('src', 'dhcpha.comment.paallergy.csp'+'?PatientID=' + patientID + '&EpisodeID=' + adm); 
		}
		if (tabId=="tab-risquery"){
			$('iframe').attr('src', 'dhcem.inspectrs.csp'+ '?PatientID=' + patientID + '&EpisodeID=' + adm);
		}
		if (tabId=="tab-libquery"){
			$('iframe').attr('src', 'dhcem.seepatlis.csp'+'?PatientID=' + patientID + '&EpisodeID=' + adm+'&NoReaded='+'1'); 
		}
		if (tabId=="tab-eprquery"){
			$('iframe').attr('src', 'emr.interface.browse.episode.csp'+ '?PatientID=' + patientID + '&EpisodeID='+adm+'&EpisodeLocID=' + session['LOGON.CTLOCID']); 
		}		
		if (tabId=="tab-orderquery"){
			$('iframe').attr('src', 'dhcpha.comment.queryorditemds.csp'+'?EpisodeID=' +adm); 
		}
		if (tabId=="tab-viewpresc"){
			var paramsstr=""+"^"+prescno+"^"+""+"^"+DHCPHA_CONSTANT.DEFAULT.PHLOC+"^"+DHCPHA_CONSTANT.DEFAULT.CYFLAG
			$("iframe").attr("src","dhcpha/dhcpha.outpha.prescpreview.csp?paramsstr="+paramsstr)
			//$('iframe').attr('src', 'dhcpha.outpha.prescpreview.csp'+'?prescno=' +prescno+'&cyflag='+DHCPHA_CONSTANT.DEFAULT.CYFLAG+'&phdispid=&prtrowid='+"&phlrowid="+DHCPHA_CONSTANT.DEFAULT.PHLOC); 
		}
	})

	$('#modal-prescinfo').on('show.bs.modal', function () {
		$("#modal-prescinfo .modal-dialog").width($(window).width()*0.9);
		$("#modal-prescinfo .modal-body").height($(window).height()*0.85);
		var tmpiframeheight=$(window).height()*0.85
							-$("#modal-prescinfo .modal-header").height()
							-$("#modal-prescinfo #ul-monitoraddinfo").height()
							-40;
		$("#ifrm-outmonitor").height(tmpiframeheight)
	  	$('iframe').attr('src', "dhcpha.comment.queryorditemds.csp?EpisodeID=" + PatientInfo.adm); 
	  	var selectid=$("#grid-presc").jqGrid('getGridParam','selrow');
	  	var selectdata=$('#grid-presc').jqGrid('getRowData',selectid);
	  	var patoptions={
			id:"#dhcpha-patinfo",
			orditem:selectdata.orditem  
		};
	  	AppendPatientOrdInfo(patoptions);
	  	var tabId=$(this).attr("id");
	  	if(tabId!="tab-viewpresc"){
			$("#tab-viewpresc").click()
		}
	})
	$("#modal-prescinfo").on("hidden.bs.modal", function() {
	    //$(this).removeData("bs.modal");
	});
	$("#tab-beforeindrug").hide();
}
 //���ͨ��
function PassPresc(){
	var selectids=$("#grid-presc").jqGrid('getGridParam','selarrrow');
	if (selectids==""){
		dhcphaMsgBox.alert("����ѡ����Ҫ��˵ļ�¼");
		return;
	}
	var canpass=0;canpassi=0;
	var i=0;
	$.each(selectids,function(){
		var rowdata = $('#grid-presc').jqGrid('getRowData',this);
		var rowresult=rowdata.result;
		canpassi=canpassi+1;
		if(rowresult=="ͨ��"){
			canpass="1"
			return false;  //false �˳�ѭ��
		}else if(rowresult=="�ܾ�"){
			canpass="2"
			return false;  //false �˳�ѭ��
		}
	})
	if (canpass==1){
		dhcphaMsgBox.alert("��ѡ��ĵ�" + canpassi + "����ͨ��,�����ٴ����ͨ�� !");
		return;
	}else if (canpass==2){
		dhcphaMsgBox.alert("��ѡ��ĵ�" + canpassi + "���Ѿܾ�,����ֱ�����ͨ�� !");
		return;
	}
	var orditem = "";
	var ret = "Y";
	var reasondr = "";
	var advicetxt = "";
	var factxt = "";
	var phnote = "";
	var guser = session['LOGON.USERID'];
	var ggroup = session['LOGON.GROUPID'];
	var i=0;
	$.each(selectids,function(){
		var rowdata = $('#grid-presc').jqGrid('getRowData',this);
		var orditem=rowdata.orditem;
		var input = ret + "^" + guser + "^" + advicetxt + "^" + factxt + "^" + phnote + "^" + ggroup + "^" + orditem;
		var input = input + "^" + DHCPHA_CONSTANT.DEFAULT.APPTYPE;
		SaveCommontResult(reasondr, input)
	})
	
}
 //��˾ܾ�
function RefusePresc(){
	var grid_records = $("#grid-prescdetail").getGridParam('records');
	if (grid_records==0){
		dhcphaMsgBox.alert("��������ϸ����!");
		return;
	}
	var firstrowdata = $("#grid-prescdetail").jqGrid("getRowData", 1); //��ȡ��һ������
	var orditm=firstrowdata.orditm;
	if (orditm==""){
		dhcphaMsgBox.alert("ҽ������Ϊ��!");
		return;
	}
  	var selectid=$("#grid-presc").jqGrid('getGridParam','selrow');
  	if(selectid==""){
	  	dhcphaMsgBox.alert("����ѡ����Ҫ�ܾ��ļ�¼!");
		return;
	}
  	var selectdata=$('#grid-presc').jqGrid('getRowData',selectid);
  	var dspstatus=selectdata.dspstatus;
	if (dspstatus.indexOf("��")>=0){
		dhcphaMsgBox.alert("��ѡ��ļ�¼״̬Ϊ:"+dspstatus+",�޷��ܾ�!");
		return;
	}
	var oaresult=selectdata.result;
	if ((oaresult=="�ܾ�")||(oaresult=="�ܾ���ҩ")){
		dhcphaMsgBox.alert("��ѡ��ļ�¼�Ѿ��ܾ�!");
		return;
	}
	if (oaresult=="ͨ��"){
		dhcphaMsgBox.alert("��ѡ��ļ�¼�Ѿ�ͨ��!");
		return;
	}
	var waycode = OutPhaWay;
	var selectreason_lnk=ChangeCspPathToAll("dhcpha.comment.selectreason.csp");
	var retstr = showModalDialog(selectreason_lnk+'?orditm=' + orditm + '&waycode=' + waycode, '', 'dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no') 
	if (! (retstr)) {
		return;
	}
	if (retstr == "") {
		return;
	}
	retarr = retstr.split("@");
	var ret = "N";
	var reasondr = retarr[0];
	var advicetxt = retarr[2];
	var factxt = retarr[1];
	var phnote = retarr[3];
	var User = session['LOGON.USERID'];
	var grpdr = session['LOGON.GROUPID'];
	var input = ret + "^" + User + "^" + advicetxt + "^" + factxt + "^" + phnote + "^" + grpdr + "^" + orditm;
	var input = input + "^" + DHCPHA_CONSTANT.DEFAULT.APPTYPE;
	if (reasondr.indexOf("$$$") == "-1") { //reasondr=reasondr+"$$$"+orditm ;
	}
	SaveCommontResult(reasondr, input)
	
}

//���ͨ��/�ܾ�
function SaveCommontResult(reasondr, input){
	$.ajax({
		url:DHCPHA_CONSTANT.URL.THIS_URL + '?action=SaveOPAuditResult&Input=' + encodeURI(input) + '&ReasonDr=' + reasondr,
		type:'post',   
		success:function(data){	
			var retjson=JSON.parse("["+data+"]");
			if (retjson[0].retvalue==0){
				QueryGridPresc();
			}else{
				dhcphaMsgBox.alert(retjson.retinfo);
				return
			} 
		},  
		error:function(){}  
	})
}
//��������
function PrescAnalyse(){
	var passType=tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",DHCPHA_CONSTANT.SESSION.GROUP_ROWID,DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,DHCPHA_CONSTANT.SESSION.GUSER_ROWID);
	if (passType==""){
		dhcphaMsgBox.alert("δ���ô��������ӿڣ����ڲ�������-����ҩ��-������ҩ�����������Ӧ����");
		return;
	}
	if (passType=="DHC"){
		// ����֪ʶ��
		 DHCSTPHCMPASS.PassAnalysis({ 
		 	GridId: "grid-presc", 
		 	MOeori: "orditem",
		 	PrescNo:"prescno", 
		 	GridType: "JqGrid", 
		 	Field: "druguse",
		 	ResultField:"druguseresult"
		 });
	}else if (passType=="DT"){
		// ��ͨ
		// StartDaTongDll(); 
		// DaTongPrescAnalyse();  
	}else if (passType=="MK"){
		// ����
		//MKPrescAnalyse(); 
	}else if (passType=="YY"){
	}
}
function GridOrdItemCellTip(){}
//Ȩ����֤
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
			var permissionmsg="",permissioninfo="";
			if (retdata.phloc==""){
				permissionmsg="ҩ������:"+defaultLocDesc;
				permissioninfo="��δ������ҩ����Ա����ά��!"	
			}else {
				permissionmsg="����:"+DHCPHA_CONSTANT.SESSION.GUSER_CODE+"��������:"+DHCPHA_CONSTANT.SESSION.GUSER_NAME;
				if (retdata.phuser==""){					
					permissioninfo="��δ������ҩ����Ա����ά��!"
				}else if(retdata.phnouse=="Y"){
					permissioninfo="����ҩ����Ա����ά����������Ϊ��Ч!"
				}else if(retdata.phaudit!="Y"){
					permissioninfo="����ҩ����Ա����ά����δ�������Ȩ��!"
				}
			}
			if (permissioninfo!=""){	
				$('#modal-dhcpha-permission').modal({backdrop: 'static', keyboard: false}); //���ɫ���򲻹ر�
				$('#modal-dhcpha-permission').on('show.bs.modal', function () {
					$("#lb-permission").text(permissionmsg)
					$("#lb-permissioninfo").text(permissioninfo)
		
				})
				$("#modal-dhcpha-permission").modal('show');
			}else{
				DHCPHA_CONSTANT.DEFAULT.PHLOC=retdata.phloc;
				DHCPHA_CONSTANT.DEFAULT.PHUSER=retdata.phuser;
				DHCPHA_CONSTANT.DEFAULT.CYFLAG=retdata.phcy;
			}
		},  
		error:function(){}  
	})
}
function addPassStatCellAttr(rowId, val, rawObject, cm, rdata){
	if (val=="ͨ��"){
		return "class=dhcpha-record-passed";
	}else if ((val=="�ܾ�")||((val=="�ܾ���ҩ"))){
		return "class=dhcpha-record-refused";
	}else if (val=="����"){
		return "class=dhcpha-record-appeal";
	}else{
		return "";
	}
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
	QueryGridPresc();
}

/***********************��ͨ��� start****************************/
//��ʼ�� 
function StartDaTongDll(){
	dtywzxUI(0,0,"");
}
//����
function dtywzxUI(nCode,lParam,sXML){
   var result;
   result = CaesarComponent.dtywzxUI(nCode, lParam,sXML);
   return result;
}
//����
function DaTongPrescAnalyse(){
	
	var mainrows=$("#grid-presc").getGridParam('records');
	if (mainrows==0){
	  	dhcphaMsgBox.alert("û����ϸ��¼!");
		return;		
	}
	for (var i=1;i<=mainrows;i++){
		dtywzxUI(3, 0, "");
		var tmprowdata=$('#grid-presc').jqGrid('getRowData',i);
		var orditem = tmprowdata.orditem;
		var myPrescXML = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongOutPresInfo", orditem);
		myrtn = dtywzxUI(28676, 1, myPrescXML);
		var newdata={
			druguse:myrtn
		};	
		$("#grid-presc").jqGrid('setRowData',i,newdata);

	}
}
 ///��ͨҩ����ʾ
function DaTongYDTS(){	
	// �ݲ��ſ�
	return;	  
  	var selectid=$("#grid-presc").jqGrid('getGridParam','selrow');
  	if(selectid==""){
	  	dhcphaMsgBox.alert("����ѡ����ҪҪ����ʾ�Ĵ���!");
		return;
	}
	var detailrows=$("#grid-prescdetail").getGridParam('records');
	if (detailrows==0){
	  	dhcphaMsgBox.alert("������ϸΪ��!");
		return;		
	}
  	var selectdata=$('#grid-prescdetail').jqGrid('getRowData',1);
  	var orditem=selectdata.orditm;
	dtywzxUI(3,0,"");
	var myPrescXML=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDTYDTS", orditem);
	myrtn=dtywzxUI(12,0,myPrescXML);

}
//��ʽ����
function druguseFormatter(cellvalue, options, rowdata){
	if (cellvalue==undefined){
		cellvalue="";
	}
	var imageid="";
	if (cellvalue=="0"){
		imageid="greenlight.gif";
	}else if (cellvalue=="1"){
		imageid="yellowlight.gif";
	}else if (cellvalue=="2"){
		imageid="blacklight.gif"
	}
	if (imageid==""){
		return cellvalue;
	}
	return '<img src="../scripts/pharmacy/images/'+imageid+'" alt="' + cellvalue + '" ></img>'
}
/***********************��ͨ��� end  ****************************/