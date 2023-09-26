/*
 *ģ��:			����ҩ��
 *��ģ��:		����ҩ��-��ҩ������ҩ
 *createdate:	2018-07-01
 *creator:		hulihua
*/
DHCPHA_CONSTANT.DEFAULT.PHLOC="";
DHCPHA_CONSTANT.DEFAULT.PHPYUSER="";
DHCPHA_CONSTANT.DEFAULT.PHUSER="";
DHCPHA_CONSTANT.DEFAULT.PHWINDOW="";
DHCPHA_CONSTANT.DEFAULT.CYFLAG="Y";
DHCPHA_CONSTANT.VAR.OUTPHAWAY=tkMakeServerCall("web.DHCSTCNTSCOMMON","GetWayIdByCode","OA")
DHCPHA_CONSTANT.DEFAULT.APPTYPE="OR";
DHCPHA_CONSTANT.URL.THIS_URL=ChangeCspPathToAll("dhcpha.outpha.outmonitor.save.csp");
var COOKTYPEDr = "";
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
$(function(){
	CheckPermission();	
	var ctloc=DHCPHA_CONSTANT.DEFAULT.LOC.text;
	$("#currentctloc").text(ctloc)
	/* ��ʼ����� start*/
	var daterangeoptions={
		singleDatePicker:true
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);
	var tmpstartdate=FormatDateT("t-2")
	//$("#date-start").data('daterangepicker').setStartDate(tmpstartdate);
	//$("#date-start").data('daterangepicker').setStartDate(tmpstartdate);
	
	InitGridDisp();	
	/* ��Ԫ���¼� start*/
	//�ǼǺŻس��¼�
	$('#txt-patno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txt-patno").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				QueryGridDisp();
			}
			ChkUnFyOtherLoc();	
		}
	});
	
	//���Żس��¼�
	$('#txt-cardno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var cardno=$.trim($("#txt-cardno").val());
			if (cardno!=""){
				BtnReadCardHandler();	
			}
			ChkUnFyOtherLoc();
			SetFocus();	
		}
	});
	
	//�������лس��¼�
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	$("#txt-cardno").focus();
	/* ��Ԫ���¼� end*/
	/* �󶨰�ť�¼� start*/
	$("#btn-change").on("click",function(){
		$("#modal-windowinfo").modal('show');
	});
	$("#btn-reffy").on("click",ExecuteRefuseFY);
	$("#btn-cancelreffy").on("click",CancelRefuseFY);
	$("#btn-readcard").on("click",BtnReadCardHandler); //����
	/* �󶨰�ť�¼� end*/
	/*���ش����޸�ģ̬�򼰲����¼� */
	InitPrescModify();
	$("#sel-cmbMakeMedthod").change(function(){
		var PrescConfigId=$("#sel-cmbMakeMedthod").val();
		InitPhcInstruc(PrescConfigId);
	});
	$("#sel-cmbPhcInstruc").change(function(){
		var phcInstr=$("#sel-cmbPhcInstruc").val();
		InitPrescOrderQty(phcInstr);	
	});
	showModifyDeatil();
	showAddMaterial();
	$('#btn-modifySubmit').on("click",savePrescModified);
	$("#btn-modalclose").on("click",closeAddPrescModal);
	InitBodyStyle();
	HotKeyInit("CMPrescDisp","grid-disp");	//��ݼ�
})

//��������
window.onload=function(){
	if (LoadPatNo!=""){
		$('#txt-patno').val(LoadPatNo);
	}
	setTimeout("QueryGridDisp()",500);
}

//��ʼ�������޸�ģ̬��ؼ�
function InitPrescModify(){
	InitPhcInstruc();
	InitPhcDuration();
	InitPHCFreq();
	InitMakeMedthod();
	InitPrescOrderQty();
}
// ҩƷ����巨��ϸ
function showModifyDeatil(){
	$("#grid-dispdetail tr").empty();
	$('#prescModal').on('show.bs.modal', function () {
  		 InitModifyDeatil();
  		//InitPrescModalStyle();
	});
	$('#prescModal').on('hide.bs.modal', function () {
  		closeAddPrescModal();
	});	
}
//��¼��ҩ�ѵĸ��Ӳ���
function showAddMaterial(){
	$("#grid-materialtail tr").empty();
	$('#AddMaterialModal').on('hide.bs.modal', function () {
  		$("#prescModal").removeData('bs.modal');
		$("#grid-materialtail tr").empty();
	});
	
}
//������ҩ
function ReturnDisp(){
	//var lnk="dhcpha/dhcpha.outpha.return.csp";
  
	//var lnk="dhcpha.outpha.return.csp";
	//window.open(lnk,"_target","width="+(window.screen.availWidth-50)+",height="+(window.screen.availHeight-100)+ ",left=0,top=0,menubar=no,status=yes,toolbar=no,resizable=yes") ;
	//�ý����п��ܲ�ҩ��ҩ ��Ҳ������Ϣ�账��Ĳ�ҩ��ҩ���档����csp���ж���β�һ��  ��Ϊ����
	$.ajax({
        type: "GET",
        cache: false,
        url: "dhcpha/dhcpha.outpha.return.csp",
        data: "",
        success: function() {
	        var lnk="dhcpha/dhcpha.outpha.return.csp";
            window.open(lnk,"_target","width="+(window.screen.availWidth-50)+",height="+(window.screen.availHeight-100)+ ",left=0,top=0,menubar=no,status=yes,toolbar=no,resizable=yes") ;

        },
        error: function() {
            var lnk="dhcpha.outpha.return.csp";
            window.open(lnk,"_target","width="+(window.screen.availWidth-50)+",height="+(window.screen.availHeight-100)+ ",left=0,top=0,menubar=no,status=yes,toolbar=no,resizable=yes") ;

        }
    });
}


//��ʼ����ҩtable
function InitGridDisp(){
	var columns=[
		{header:'��ҩ״̬',index:'TDspStatus',name:'TDspStatus',width:65,cellattr: addPhDispStatCellAttr},
		{header:'�Ƿ�Ӽ�',name:"TEmergFlag",index:"TEmergFlag",width:70,
			formatter: function(value, options, rowdata){
				if(value == "Y"){
					return "��";	
				}else{
					return "��";	
				}
			}
		},
		{header:'����',index:'TPatName',name:'TPatName',width:100},
		{header:'�ǼǺ�',index:'TPmiNo',name:'TPmiNo',width:100},
		{header:'��ҩ',index:'TFyFlag',name:'TFyFlag',width:40,hidden:true},
		{header:'������',index:'TPrescNo',name:'TPrescNo',width:120},
		{header:'��������',index:"TPrescType",name:"TPrescType",width:80},
		{header:'����',index:"TDuration",name:"TDuration",width:80,hidden:true},
		{header:'��ҩ��ʽ',index:"TCookType",name:"TCookType",width:60},
		{header:'��ҩ��/����״̬',index:"TCookCost",name:"TCookCost",width:110,align:'left'},
		{header:'�ѱ�',index:"TBillType",name:"TBillType",width:60},
		{header:'���',index:'TMR',name:'TMR',width:300,align:'left'},
		//�������ڱ���ϻ�û���������¼��ĵط�����������鹵ͨ����ʱ�����ش�����Ϣ MaYuqiang 20200320
		{header:'�������',index:'TMBDiagnos',name:'TMBDiagnos',width:150,align:'left',hidden:true},
		{header:'�Ա�',index:'TPatSex',name:'TPatSex',width:40},
		{header:'����',index:'TPatAge',name:'TPatAge',width:40},
		{header:'����',index:'TPatLoc',name:'TPatLoc',width:100},
		{header:'�ȷ���־',index:'TPayDispFlag',name:'TPayDispFlag',width:70,
			formatter: function(value, options, rowdata){
				if(value == "Y"){
					return "��";	
				}else{
					return "��";	
				}
			}
		},
		{header:'�ֹ���',name:"THandMadeFlag",index:"THandMadeFlag",width:80,hidden:true},
		{header:'����',name:"TDuration",index:"TDuration",width:70,hidden:true},
		{header:'�ܾ���ҩ����',name:"TRefResult",index:"TRefResult",width:300,align:'left'},
		{header:'�ܾ���ҩ��������',name:"TDocNote",index:"TDocNote",width:300,align:'left'},
		{header:'TAdm',index:'TAdm',name:'TAdm',width:60,hidden:true},
		{header:'TPapmi',index:'TPapmi',name:'TPapmi',width:60,hidden:true},
		{header:'TPatLoc',index:'TPatLoc',name:'TPatLoc',width:60,hidden:true},
		{header:'Tphd',index:'Tphd',name:'Tphd',width:60,hidden:true},
		{header:'TOeori',index:'TOeori',name:'TOeori',width:60,hidden:true},
		{header:'�����ܼ�',index:'TEncryptLevel',name:'TEncryptLevel',width:70,hidden:true},
		{header:'���˼���',index:'TPatLevel',name:'TPatLevel',width:70,hidden:true}
	]; 
	var jqOptions={
		datatype:'local',
		colModel: columns, //��
		url:ChangeCspPathToAll(LINK_CSP)+'?ClassName=PHA.OP.HMDisp.Query&MethodName=jsQueryPrecsCheckDispList&style=jqGrid', //��ѯ��̨	
		height: DhcphaJqGridHeight(1,3)+26,
		shrinkToFit: false,
		pager: "#jqGridPager", 	//��ҳ�ؼ���id
		rownumbers: true,
		viewrecords: true,
		onSelectRow:function(id,status){
			QueryGridDispSub();
			/**
			�ֹ�����¼���ڱ��δ���ã���ע��
			var selrowdata = $("#grid-disp").jqGrid('getRowData', id);
			var handmadeflag=selrowdata.THandMadeFlag;
			var dispstatus=selrowdata.TDspStatus; 
			if(handmadeflag=="1"){			//&&((dispstatus=="")||(dispstatus==null)))
				$("#grid-dispdetail").empty();	//���ģ̬��table 
				InitPrescModify();
				$('#prescModal').modal('show');
			}**/
	},
	loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#ifrm-presc").attr("src","");
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
	};
	$("#grid-disp").dhcphaJqGrid(jqOptions);
}

//��ѯ��ҩ�б�
function QueryGridDisp(){
 	var stdate = $("#date-start").val();
	var enddate = $("#date-end").val();
 	var phalocid=DHCPHA_CONSTANT.DEFAULT.LOC.id;
	var chkdisp="";
	if($("#chk-disp").is(':checked')){
		chkdisp="Y";
	}else{
	    chkdisp="";
	}
	var patno=$("#txt-patno").val();
	var params=stdate+"^"+enddate+"^"+phalocid+"^"+patno+"^"+chkdisp+"^"+DHCPHA_CONSTANT.DEFAULT.PHLOC;		
	$("#grid-disp").setGridParam({
		datatype:'json',
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
	$("#ifrm-presc").attr("src","");
}
//��ѯ��ҩ��ϸ
function QueryGridDispSub(){
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	var prescno=selrowdata.TPrescNo;
	var cyflag=DHCPHA_CONSTANT.DEFAULT.CYFLAG;
	var phartype="DHCOUTPHA";
	var paramsstr=phartype+"^"+prescno+"^"+cyflag;
	$("#ifrm-presc").attr("src",ChangeCspPathToAll("dhcpha/dhcpha.common.prescpreview.csp")+"?paramsstr="+paramsstr+"&PrtType=DISPPREVIEW");
}

//ִ��ȫ��
function ExecuteAllFY(){	
    var fyrowdata = $("#grid-disp").jqGrid('getRowData');
	var fygridrows=fyrowdata.length;
	if (fygridrows<=0){
		dhcphaMsgBox.alert("�����б�û������!");
		return;
	}
	dhcphaMsgBox.confirm("ȷ��ȫ����?ϵͳ��ȫ�����Ų�ѯ�������д���!",ConfirmDispAll);
}

function ConfirmDispAll(result){
	if (result==true){
		var chkdisp="";
		if($("#chk-disp").is(':checked')){
			chkdisp="Y";
		}else{
		    chkdisp="";
		}
		if(chkdisp=="Y"){
			dhcphaMsgBox.alert("����Ϊ�ѷ�ҩ����,���ܷ�ҩ!");
	    	return;
		}
		var fyrowdata = $("#grid-disp").jqGrid('getRowData');
		var fygridrows=fyrowdata.length;
		for(var rowi=1;rowi<=fygridrows;rowi++){
			DispensingMonitor(rowi);		
		} 
	}
	QueryGridDisp();
}

// ִ�з�ҩ
function ExecuteFY(){
	if (DhcphaGridIsEmpty("#grid-disp")==true){
		return;
	}
	var selectid=$("#grid-disp").jqGrid('getGridParam','selrow');
	if (selectid==null){
	    dhcphaMsgBox.alert("û��ѡ������,���ܷ�ҩ!");
	    return;
	}
	DispensingMonitor(selectid);
	//ˢ�²�ѯ
	QueryGridDisp();
}

function DispensingMonitor(rowid){
	
	var selrowdata = $("#grid-disp").jqGrid('getRowData', rowid);
	var prescno=selrowdata.TPrescNo;
	var fyflag=selrowdata.TFyFlag;
	var patname=selrowdata.TPatName;
	var warnmsgtitle="��������:"+patname+"\t"+"������:"+prescno+"\n"
	if (fyflag=="OK"){
		dhcphaMsgBox.alert(warnmsgtitle+"�ü�¼�Ѿ���ҩ!");
		return;
	}
	var checkprescref=GetOrdRefResultByPresc(prescno)
	if (checkprescref=="N"){
		dhcphaMsgBox.alert(warnmsgtitle+"�ô����ѱ��ܾ�,��ֹ��ҩ!");
		return;
    }else if (checkprescref=="A"){
		dhcphaMsgBox.alert(warnmsgtitle+"�ô����ѱ��ܾ�,��ֹ��ҩ!");
		return;
	}else if (checkprescref=="S"){
		if(!confirm(warnmsgtitle+"�ô���ҽ�����ύ����\n���'ȷ��'��ͬ�����߼�����ҩ�����'ȡ��'��������ҩ������")){
			return;
		}
		var cancelrefuseret=tkMakeServerCall("web.DHCSTCNTSOUTMONITOR","CancelRefuse",DHCPHA_CONSTANT.SESSION.GUSER_ROWID,prescno,"OR"); //���ߺ�ҩӦ�ȳ����ܾ�
	}
	var params=DHCPHA_CONSTANT.DEFAULT.PHLOC+tmpSplit+DHCPHA_CONSTANT.DEFAULT.PHWINDOW+tmpSplit+DHCPHA_CONSTANT.DEFAULT.PHPYUSER+tmpSplit+DHCPHA_CONSTANT.DEFAULT.PHUSER+tmpSplit+prescno;                                       
	var retval=tkMakeServerCall("PHA.OP.HMDisp.OperTab","SaveData",params)
	var retcode=retval.split("^")[0];
	var retmessage=retval.split("^")[1];
	if ((retcode<0)||((retcode==0))){
		dhcphaMsgBox.alert("��ҩʧ��,"+retmessage)
		return;
	}else if (retval>0){  
		var bgcolor=$(".dhcpha-record-disped").css("background-color");
		var cssprop = {  
			background: bgcolor,
			color:'black'
		}; 
		$("#grid-disp").setCell(rowid,'TFyFlag','OK');
		$("#grid-disp").setCell(rowid,'Tphd',retval);
		$("#grid-disp").setCell(rowid,'TDspStatus','�ѷ�ҩ',cssprop); 
		if (top && top.HideExecMsgWin) {
            top.HideExecMsgWin();
        }
        /// ��ӡ��ǩ
        PrintOutphaCom(prescno, retval)
    }
    //SendOrderToMachine(retval);
}

// ִ�оܾ���ҩ
function ExecuteRefuseFY(){
	if (DhcphaGridIsEmpty("#grid-disp")==true){
		return;
	}
	var selectid=$("#grid-disp").jqGrid('getGridParam','selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	if (selectid==null){
	    dhcphaMsgBox.alert("û��ѡ������,���ܾܾ���ҩ!");
	    return;
	}
	var fyflag=selrowdata.TFyFlag;
	if (fyflag=="OK"){
		dhcphaMsgBox.alert("�����ѷ�ҩ�����ܾܾ�!");
		return;
	}
	var prescno=selrowdata.TPrescNo;
	if(prescno==""){
		dhcphaMsgBox.alert("��ѡ��Ҫ�ܾ��Ĵ���");
		return;
	}
	var checkprescref = GetOrdRefResultByPresc(prescno);���� //LiangQiang 2014-12-22  �����ܾ�
	if (checkprescref=="N"){
		dhcphaMsgBox.alert("�ô����ѱ��ܾ�,�����ظ�����!")
		return;
	}else if (checkprescref=="A"){
		dhcphaMsgBox.alert("�ô����ѱ��ܾ�,�����ظ�����!")
		return;
	} 
	var waycode =DHCPHA_CONSTANT.VAR.OUTPHAWAY;
	
	
	var orditm=selrowdata.TOeori;
	ShowPHAPRASelReason({
		wayId:waycode,
		oeori:"",
		prescNo:prescno,
		selType:"PRESCNO"
	},SaveCommontResultEX,{orditm:orditm}); 
	
}


function SaveCommontResultEX(reasonStr,origOpts){
	if (reasonStr==""){
		return "";
	}
	var retarr = reasonStr.split("@");
	var ret = "N";
	var reasondr = retarr[0];
	var advicetxt = retarr[2];
	var factxt = retarr[1];
	var phnote = retarr[3];
	var User = session['LOGON.USERID'];
	var grpdr = session['LOGON.GROUPID'];
	var input = ret + tmpSplit + User + tmpSplit + advicetxt + tmpSplit + factxt + tmpSplit + phnote + tmpSplit + grpdr + tmpSplit + origOpts.orditm;
	var input = input + tmpSplit + DHCPHA_CONSTANT.DEFAULT.APPTYPE;
	SaveCommontResult(reasondr, input)
}

//��˾ܾ�
function SaveCommontResult(reasondr, input){
	$.ajax({
		url:DHCPHA_CONSTANT.URL.THIS_URL + '?action=SaveOPAuditResult&Input=' + encodeURI(input) + '&ReasonDr=' + reasondr,
		type:'post',   
		success:function(data){	
			var retjson=JSON.parse("["+data+"]");
			if (retjson[0].retvalue==0){
				QueryGridDisp();
				if (top && top.HideExecMsgWin) {
		            top.HideExecMsgWin();
		        }
			}else{
				dhcphaMsgBox.alert(retjson.retinfo);
				return
			} 
		},  
		error:function(){}  
	})
}

// �����ܾ���ҩ
function CancelRefuseFY(){
	if (DhcphaGridIsEmpty("#grid-disp")==true){
		return;
	}
	var selectid=$("#grid-disp").jqGrid('getGridParam','selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	if (selectid==null){
	    dhcphaMsgBox.alert("û��ѡ������,���ܳ����ܾ���ҩ!");
	    return;
	}
	var fyflag=selrowdata.TFyFlag;
	var prescno=selrowdata.TPrescNo;
	if (fyflag=="OK"){
		dhcphaMsgBox.alert("�ü�¼�Ѿ���ҩ!");
		return;
	}
	if(prescno==""){
		dhcphaMsgBox.alert("��ѡ��Ҫ�����ܾ��Ĵ���");
		return;
	}
	var checkprescref = GetOrdRefResultByPresc(prescno);���� //LiangQiang 2014-12-22  �����ܾ�
	if ((checkprescref!="N")&&(checkprescref!="A")){
		if (checkprescref=="S"){
			dhcphaMsgBox.alert("�ô���ҽ�����ύ����,����Ҫ����!")
			return;
		}else{
			dhcphaMsgBox.alert("�ô���δ���ܾ�,���ܳ�������!")
			return;
		}
	}
	var cancelrefuseret=tkMakeServerCall("web.DHCSTCNTSOUTMONITOR","CancelRefuse",DHCPHA_CONSTANT.SESSION.GUSER_ROWID,prescno,"OR");
	if (cancelrefuseret == "0"){
		var newdata={
			TDspStatus:''
		};	
		$("#grid-disp").jqGrid('setRowData',selectid,newdata,"");
		dhcphaMsgBox.alert("�����ɹ�!","success");
		QueryGridDisp();
	}else if (cancelrefuseret == "-2"){
		dhcphaMsgBox.alert("�ô���δ���ܾ�,���ܳ�������!");
	}else if (retval == "-3"){
		dhcphaMsgBox.alert("�ô����ѳ���,�����ٴγ���!");
	}
}
 //��ȡ�����ܾ���� 
function GetOrdRefResultByPresc(prescno){
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdRefResultByPresc",prescno);
	return ref;
}

//��ȡ��������δ��ҩ��¼,��������ҩʱ
function ChkUnFyOtherLoc(){
 	var startdate = $("#date-start").val();
	var enddate = $("#date-end").val();
	var patno=$("#txt-patno").val();
	if((patno=="")||(patno==null)){
		return;
	}
	var ret=tkMakeServerCall("web.DHCOUTPHA.Common.CommonDisp","ChkUnFyOtherLoc",startdate,enddate,patno,DHCPHA_CONSTANT.DEFAULT.PHLOC,"")
	if(ret==-1){
		//alert("����Ϊ��,�����")
	}
	else if(ret==-2){
		dhcphaMsgBox.alert("û�ҵ��ǼǺ�Ϊ"+patno+"�Ĳ���");
		return;
		
	}else if((ret!="")&&(ret!=null)){
		dhcphaMsgBox.message(ret);
	}
}

//���
function ClearConditions(){
	var cardoptions={
		id:"#sel-cardtype"
	}
	InitSelectCardType(cardoptions);
	$("#txt-patno").val("");
	$("#txt-cardno").val("");
	$('#chk-disp').iCheck('uncheck');
	$("#grid-disp").clearJqGrid();
	$("#ifrm-presc").attr("src","");
	var tmpstartdate=FormatDateT("t-2")
	$("#date-start").data('daterangepicker').setStartDate(new Date());
	$("#date-start").data('daterangepicker').setEndDate(new Date());
	$("#date-end").data('daterangepicker').setStartDate(new Date());
	$("#date-end").data('daterangepicker').setEndDate(new Date());
	SetFocus();
}

//Ȩ����֤
function CheckPermission(){
	$.ajax({
		url:ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCOUTPHA.InfoCommon&MethodName=CheckPermission'+
			'&groupid='+DHCPHA_CONSTANT.SESSION.GROUP_ROWID+
			'&userid='+DHCPHA_CONSTANT.SESSION.GUSER_ROWID+
			'&locid='+DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
		type:'post',   
		success:function(data){
			var retjson=eval("(" + data + ")");
			var retdata= retjson[0];
			var permissionmsg="",permissioninfo="";
			if (retdata.phloc==""){
				permissionmsg="ҩ������:"+gLocDesc;
				permissioninfo="��δ������ҩ������ά����ά��!"	
			}else {
				permissionmsg="����:"+DHCPHA_CONSTANT.SESSION.GUSER_CODE+"��������:"+DHCPHA_CONSTANT.SESSION.GUSER_NAME;
				if (retdata.phuser==""){					
					permissioninfo="��δ������ҩ����Ա����ά��!"
				}else if(retdata.phnouse=="Y"){
					permissioninfo="����ҩ����Ա����ά����������Ϊ��Ч!"
				}else if(retdata.phfy!="Y"){
					permissioninfo="����ҩ����Ա����ά����δ���÷�ҩȨ��!"
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
				DHCPHA_CONSTANT.DEFAULT.PHPYUSER=retdata.phuser;
				DHCPHA_CONSTANT.DEFAULT.PHUSER=retdata.phuser;
			}
		},  
		error:function(){}  
	})
}

function InitBodyStyle(){
	var height1=$("[class='container-fluid dhcpha-condition-container']").height();
	var height3=parseFloat($("[class='panel div_content']").css('margin-top'));
	var height4=parseFloat($("[class='panel div_content']").css('margin-bottom'));
	var height5=parseFloat($("[class='panel-heading']").height());
	var height6=parseFloat($("[class='container-fluid presccontainer']").height());
	var tableheight=$(window).height()-height1*2-height3-height4-height5-12;
	var dbLayoutWidth=$("[class='panel div_content']").width();
	if (!(!!window.ActiveXObject || "ActiveXObject" in window))  {
		dbLayoutWidth = dbLayoutWidth-7;
	}
	var dbLayoutCss={
		width:dbLayoutWidth,
		height:tableheight
	};
	$("#ifrm-presc").css(dbLayoutCss);
}
function addPhDispStatCellAttr(rowId, val, rawObject, cm, rdata){
	if (val=="����ҩ"){
		return "class=dhcpha-record-pyed";
	}else if (val=="�Ѵ�ӡ"){
		return "class=dhcpha-record-printed";
	}else if (val=="�ѷ�ҩ"){
		return "class=dhcpha-record-disped";
	}else if (val=="�ܾ���ҩ"){
		return "class=dhcpha-record-refused";
	}else if (val=="����(�ܾ���ҩ)"){
		return "class=dhcpha-record-appeal";
	}else if (val=="����(�ܾ���ҩ)"){
		return "class=dhcpha-record-owefee";
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
	QueryGridDisp();
}
/*@ ��ʼ����¼����ģ̬����Ϣ
  @ pushuangcai
  @ 2018/08/28   */
function InitModifyDeatil(){
	var selrowdata=getSelectRowData();
	var phdprescno=selrowdata.TPrescNo;
	var prescForm=selrowdata.TPrescType;
	var duration=selrowdata.TDuration;
	
	$("#lab-prescno").text(phdprescno);		//������
	$("#lab-prescform").text(prescForm);	//�������
	$("#lab-duration").text(duration);		//����
	$(".lab").css({
	  "color":"red",
	  "font-family":"Arial",
	  "font-size":"26px"
	});
	var ret=tkMakeServerCall("PHA.OP.HMDisp.Query","GetPrescDetailList",phdprescno);
	var jsonobj = JSON.parse(ret);
	var tdHtml1 = "";
	var tdHtml2 = "";
	var count = 0;
	var PrescConfigId = jsonobj.TPrescConfigId;
	var PrescConfig = jsonobj.TPrescConfig;
	var OrderQty = jsonobj.TOrderQty;
	var OrderQtyDesc = jsonobj.TOrderQtyDesc;
	var FreqDr = jsonobj.TFreqDr;
	var FreqDesc = jsonobj.TFreqDesc;
	var Insdr = jsonobj.TInsdr;
	var Instruc = jsonobj.TInstruc;
	var cookType = jsonobj.TCoookType;
	var Efficacy = jsonobj.TEfficacy;
	var PrescTypedr = jsonobj.TPrescTypedr;
	//���ݴ������ͼ������Ʒ������÷�
	InitMakeMedthod(PrescTypedr);
	// ����Ĭ��ֵ
	$("input:radio[name=Efficacy][value="+Efficacy+"]").attr("checked",true); 
	if(PrescConfig!=""){
		$("#sel-cmbMakeMedthod").append('<option value="'+PrescConfigId+'" selected="selected">'+PrescConfig+'</option>')
	}
	if(OrderQtyDesc!=""){
		$("#sel-cmbPrescOrderQty").append('<option value="'+OrderQty+'" selected="selected">'+OrderQtyDesc+'</option>')
	}
	if(FreqDesc!=""){
		$("#sel-cmbInitPHCFreq").append('<option value="'+FreqDr+'" selected="selected">'+FreqDesc+'</option>')
	}
	if(OrderQtyDesc!=""){
		$("#sel-cmbPhcInstruc").append('<option value="'+Insdr+'" selected="selected">'+Instruc+'</option>')
	}
	$.each(jsonobj["TDetail"],function(i){	
		var oeori = jsonobj["TDetail"][i].TOeori;
		var inciDesc = jsonobj["TDetail"][i].TInciDesc.trim();
		var boilType = jsonobj["TDetail"][i].TBoilType;
		var dose = jsonobj["TDetail"][i].TDose.trim();
		var oeoriTmpHtml='<td class="text-right" style="display: none;">'+oeori+'</td>';
		var inciTmpHtml='<td class="text-right">'+inciDesc+"&nbsp;&nbsp;"+dose+'</td>';
		var selTmpHtml="";
		if(boilType!=""){	//��ʾ�ѱ���ļ巨
			selTmpHtml='<td>'+'<select class="form-control" id="sel-cmbBoil'+i+'"><option value="'+boilType+'">'+boilType+'</option></select></td>';
		}else{
			selTmpHtml='<td>'+'<select class="form-control in_select" id="sel-cmbBoil'+i+'"></select></td>';
		}
		var tmpHtml=oeoriTmpHtml+inciTmpHtml+selTmpHtml;
		tdHtml1=tdHtml1+tmpHtml;
		count++;
		if(count%4==0){		//����һ��4��ҩƷ
			tdHtml2=tdHtml2+'<tr>'+tdHtml1+'</tr>';
			tdHtml1="";
		}
	});
	if(tdHtml1!=""){		
			tdHtml2=tdHtml2+'<tr>'+tdHtml1+'</tr>';
		}
	//console.log(tdHtml2)
	$('#grid-dispdetail').append(tdHtml2);
	InitPhSpecInst(count);		//���ؼ巨
}

/* ���油¼������Ϣ */
function savePrescModified(){
	var selrowdata = getSelectRowData();
	var phdrowid = selrowdata.Tphd;
	var prescno = selrowdata.TPrescNo;
	var paramStr = getPrescModifyParam();
	var detailStr = getPrescModifyDetail();
	var ret=tkMakeServerCall("PHA.OP.HMDisp.OperTab","SavePrescModified",prescno,paramStr,detailStr);
	if(ret==0){
		dhcphaMsgBox.message("����ɹ���")
		$('#prescModal').modal('hide');
		return;
	}else{
		dhcphaMsgBox.message("����ʧ�ܣ�")
	}
}
//����֮��ˢ��
function closeAddPrescModal(){
	$("#prescModal").removeData('bs.modal');
	$("#grid-dispdetail tr").empty();
	$("#sel-cmbMakeMedthod").val("");
    $("#sel-cmbPhcInstruc").val("");
    QueryGridDispSub();
}
/* ��ȡ��¼����ģ̬����Ϣ */
function getPrescModifyParam(){
	var phcMakeMethod = $("#sel-cmbMakeMedthod").val(); 			//���Ʒ���
	if (phcMakeMethod==null) phcMakeMethod="";
	var phcInstruc = $("#sel-cmbPhcInstruc").val();					//�÷�
	if (phcInstruc==null) phcInstruc="";
	var PhcFreq = $("#sel-cmbInitPHCFreq").val();					//Ƶ��
	if (PhcFreq==null) PhcFreq="";
	var PrescOrderQty = $("#sel-cmbPrescOrderQty").val();			//����
	if (PrescOrderQty==null) PrescOrderQty="";
	var Efficacy = $("input[name='Efficacy']:checked").val(); 		//��Ч
	paramStr=phcInstruc+"^"+phcMakeMethod+"^"+PhcFreq+"^"+PrescOrderQty+"^"+Efficacy;
	return paramStr;		
}
/* ��ȡ��¼������ϸ��Ϣ */
function getPrescModifyDetail(){
	var detailStr = "";
	$('#grid-dispdetail').each(function(index) {
		$(this).find('tr').each(function() {
			var n = 0;
			var tmpStr = "";
		    $(this).find('td').each(function() {
			    n = n+1;
			    var tmp = $(this).text().trim();
			    if($(this).children().length>0){
				   tmp = $(this).children().val();
				   if(tmp==null) tmp="";
				}
			    tmpStr = tmpStr+"^"+tmp;  
			    if(n%3==0){
				    detailStr = detailStr+"&"+tmpStr;
			    	tmpStr = "";
				}
			});
		});
	})
	return detailStr;
}
// ��ȡѡ��������
function getSelectRowData(){
	var selectid=$("#grid-disp").jqGrid('getGridParam','selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	return selrowdata;
}
//��ʼ����ҩ����
function InitCookType(cookType){
	$.ajax({  
		type: 'POST',
		url: encodeURI(LINK_CSP+'?ClassName=PHA.OP.COM.Store&MethodName=jsGetCookType&params='+cookType+'&gLocId='+ session['LOGON.CTLOCID']),
		data: "json",
		success:function(data){   
			var jsondata=JSON.parse(data);
			var selectoption={
				data:jsondata,	
				minimumResultsForSearch: Infinity
			}
			$("#sel-cook").dhcphaSelect(selectoption);
		}
	})
}
//��ҩ������
function RequstCookType(){
	if (DhcphaGridIsEmpty("#grid-disp")==true){
		return;
	}
	var selrowdata = getSelectRowData();
	var CookType=selrowdata.TCookType;
	if(CookType=="") {
		dhcphaMsgBox.message("��ҩ��ʽΪ�ղ����������ҩ�ѣ�");
		return;
	};
	var htmlStr = '<div class="input-group">'
		htmlStr += '<span  class="input-group-addon dhcpha-input-group-addon-in"><strong>ת��ҩ��ʽΪ</strong></span>'                         
	    htmlStr += '<select class="form-control in_select" id="sel-cook"></select>'
	    htmlStr += '</div>';
	dhcphaMsgBox.confirm(htmlStr,function(result){
		if(!result) {return};
		var cookTypeDr = $("#sel-cook").val();
		if(!cookTypeDr) {
			dhcphaMsgBox.message("��ҩ��ʽΪ�ղ��������ҩ�ѣ�");
			return;
		};
		COOKTYPEDr = cookTypeDr;
		var PrescNo=selrowdata.TPrescNo;
		var ReqCookStr=tkMakeServerCall("PHA.OP.HMDisp.Query","CheckIfInsertCookFee",PrescNo,DHCPHA_CONSTANT.DEFAULT.PHLOC,cookTypeDr);
		var ReqCookCode=ReqCookStr.split("^")[0];
		var ReqCookMessage=ReqCookStr.split("^")[1];
		if(ReqCookCode!=0){
			dhcphaMsgBox.alert(ReqCookMessage);
			return;
		}
		$('#AddMaterialModal').modal('show');
		var appendArcimArr = ReqCookMessage.split(",");
		//alert("appendArcimArr:"+appendArcimArr)
		var trHtml = "";
		for(var i = 0; i < appendArcimArr.length; i++){
			var arcimArr = appendArcimArr[i].split("&");
			var PresAppendItem = arcimArr[0];
			var PresAppendDesc = arcimArr[1];
			var PresAppendQty = arcimArr[2];
			var AricmIdHtml='<td class="text-right" style="display: none;">'+PresAppendItem+'</td>';
			var AricmDescHtml='<td class="text-left" style="font-size:16px">'+PresAppendDesc+"  /  "+PresAppendQty+'</td>';
			var tdHtml='<tr>'+AricmIdHtml+AricmDescHtml+'</tr>'
			trHtml += tdHtml;
		}
		$('#grid-materialtail').html(trHtml);
	});
	InitCookType(CookType);
}
//���渽�����Ϸ�
function SaveMaterInfo(){
	var selrowdata = getSelectRowData();
	var PrescNo = selrowdata.TPrescNo;
	var AdmDr=selrowdata.TAdm;
	$('#AddMaterialModal').modal('hide');
	SaveCookFee(AdmDr,PrescNo,COOKTYPEDr);
	COOKTYPEDr = "";
}

function SaveCookFee(AdmDr,PrescNo,cookTypeDr){
	var InputDate=AdmDr+"^"+PrescNo+"^"+gUserID+"^"+gLocId+"^"+cookTypeDr+"^"+gGroupId;
	var RetStr=tkMakeServerCall("PHA.OP.HMDisp.Query","SaveCookFee",InputDate);
	var RetCode=RetStr.split("^")[0];
	var RetMessage=RetStr.split("^")[1];
	if(RetCode!=0){
		var message=RetStr.split("^")[1];
		dhcphaMsgBox.alert(RetMessage);
	}else{
		var newcookcost="��ҩ������";
		var newdata={
	    	TCookCost:newcookcost 
	    };
	    var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	    $("#grid-disp").jqGrid('setRowData',selectid,newdata);
		//dhcphaMsgBox.message("��ҩ������ɹ������֮ǰ�Ѿ������˼�ҩ���뵽�շѴ��˷ѣ�Ȼ���ٽ����µļ�ҩ�ѣ�")
		dhcphaMsgBox.alert("��ҩ������ɹ������֮ǰ�Ѿ������˼�ҩ���뵽�շѴ��˷ѣ�Ȼ���ٽ����µļ�ҩ�ѣ�")
	}
	return;
}

//ת����ҩ����
function ExchangeCookType(){
	var prescrowdata = $("#grid-disp").jqGrid('getRowData');
	var prescridrows=prescrowdata.length;
	if(prescridrows<=0){
	    dhcphaMsgBox.alert("�󷽷�ҩ�б�������!");
	    return;
	}
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	var CookType=selrowdata.TCookType;
	if(CookType=="") {
		dhcphaMsgBox.message("��ҩ��ʽΪ�ղ�����ת����ҩ��ʽ��");
		return;
	};
	var htmlStr = '<div class="input-group">'
		htmlStr += '<span  class="input-group-addon dhcpha-input-group-addon-in"><strong>ת��ҩ��ʽΪ</strong></span>'                         
	    htmlStr += '<select class="form-control in_select" id="sel-cook"></select>'
	    htmlStr += '</div>';
	dhcphaMsgBox.confirm(htmlStr,function(result){
		if(!result) {return};
		var cookTypeDr = $("#sel-cook").val();
		if(!cookTypeDr) {
			dhcphaMsgBox.message("��������ҩ��ʽת��Ϊ�գ�");
			return;
		};
		
		Exchange(cookTypeDr);
	})
	InitCookType(CookType);
}

function Exchange(CookType){
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	//var CookType=selrowdata.TCookType;
	var PrescNo=selrowdata.TPrescNo;
	var DspStatus=selrowdata.TDspStatus;
	var Ret=tkMakeServerCall("PHA.OP.HMDisp.OperTab","SavePrescCookType",PrescNo,CookType,DHCPHA_CONSTANT.DEFAULT.PHLOC);
	var RetCode=Ret.split("^")[0];
	var RetMessage=Ret.split("^")[1];
	if(RetCode==0){
		dhcphaMsgBox.message("ת���ɹ���");
	}else{
		dhcphaMsgBox.alert("ת��ʧ�ܣ�"+RetMessage);
		return;
	}
	if (CookType!==""){
		var newdata={
	    	TCookType:$("#sel-cook").select2('data')[0].text
	    };
	}
	else{
		var newdata={
	    	TCookType:''
	    };
	}
    $("#grid-disp").jqGrid('setRowData',selectid,newdata);
    QueryGridDispSub();
    if (DspStatus.indexOf("�ѷ�ҩ")>-1){
		//AfreshSend();
	}
	return;
}

//���ƴ���
function AfreshSend(){
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	var dspstatus=selrowdata.TDspStatus;
	if (dspstatus.indexOf("�ѷ�ҩ")<0){
		dhcphaMsgBox.alert("�ô�����δ��ҩ,�޷�����!");
		return;
	}
	var phd=selrowdata.Tphd;
	//SendOrderToMachine(phd);
}

//����������������
function SendOrderToMachine(phd){
	var sendret=tkMakeServerCall("web.DHCSTInterfacePH","SendPhlDataToMechine",phd);
	if (sendret!="0"){
		var retString=sendret.split("^")[1];
		dhcphaMsgBox.alert("��������ʧ��,�������:"+retString,"error");
		return;  
	}
}	

function SetFocus()
{
	$("#txt-cardno").focus();
}				
