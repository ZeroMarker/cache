/*
 *ģ��:����ҩ��
 *��ģ��:����ҩ��-Ƿҩ������
 *createdate:2016-09-18
 *creator:dinghongying
*/
DHCPHA_CONSTANT.DEFAULT.PHLOC="";
DHCPHA_CONSTANT.DEFAULT.PHUSER="";
DHCPHA_CONSTANT.DEFAULT.PHWINDOW="";
DHCPHA_CONSTANT.DEFAULT.CYFLAG="";
DHCPHA_CONSTANT.VAR.TIMER="";
DHCPHA_CONSTANT.DEFAULT.FYFLAG=""
$(function(){
	CheckPermission();	
	/* ��ʼ����� start*/
	var daterangeoptions={
		singleDatePicker:true
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);
	
	InitGridOwe();
	InitGirdOweDetail();	
	/* ��Ԫ���¼� start*/
	//�ǼǺŻس��¼�
	$('#txt-patno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txt-patno").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				QueryGridOwe();
			}	
		}
	});
	//���Żس��¼�
	$('#txt-cardno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var cardno=$.trim($("#txt-cardno").val());
			if (cardno!=""){
				BtnReadCardHandler();
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
	$("#chk-fy").on("ifChanged",function(){
		if($(this).is(':checked')==true){
			$('#chk-return').iCheck('uncheck');		
		}
	})
	$("#chk-return").on("ifChanged",function(){
		if($(this).is(':checked')==true){
			$('#chk-fy').iCheck('uncheck');		
		}
	})
	$("#btn-find").on("click",QueryGridOwe);
	$("#btn-clear").on("click",ClearConditions);
	$("#btn-fy").on("click",function(){
		if(DHCPHA_CONSTANT.DEFAULT.FYFLAG!="Y"){
		dhcphaMsgBox.alert("�û�û�з�ҩȨ�ޣ���ҩʧ�ܣ�");	
		return ;
		}
		ExecuteFY();
	});
	$("#btn-return").on("click",DoReturn);
	$("#btn-readcard").on("click",BtnReadCardHandler); //����
	/* �󶨰�ť�¼� end*/;	
	InitBodyStyle();
})
window.onload=function(){
	QueryGridOwe()
}
//��ʼ��Ƿҩtable
function InitGridOwe(){
	var columns=[
		{header:'ѡ��',index:'TSelect',name:'TSelect',width:70,hidden:true},	
	    {header:'����',index:'TPatName',name:'TPatName',width:100},
	    {header:'�ǼǺ�',index:'TPmiNo',name:'TPmiNo',width:100},
	    {header:'�շ�����',index:'TPrtDate',name:'TPrtDate',width:100},
	    {header:'�վݺ�',index:'TPrtInv',name:'TPrtInv',width:90,hidden:true},
	    {header:'����',index:'TPrescNo',name:'TPrescNo',width:120},
	    {header:'���',index:'TPrescMoney',name:'TPrescMoney',width:70,align:'right'},
	    {header:'�Ա�',index:'TPerSex',name:'TPerSex',width:40},
	    {header:'����',index:'TPerAge',name:'TPerAge',width:40},
		{header:'����',index:'TPerLoc',name:'TPerLoc',width:100},		
	    {header:'�ѱ�',index:'TPrescType',name:'TPrescType',width:70},
	    {header:'�绰',index:'TCallCode',name:'TCallCode',width:100},
	    {header:'Ƿҩʱ��',index:'TOweDate',name:'TOweDate',width:140},
	    {header:'Ƿҩ��',index:'TOweUser',name:'TOweUser',width:100},
		{header:'Ƿҩ״̬',index:'TOweStatusdesc',name:'TOweStatusdesc',width:70},	
	    {header:'��ҩ����',index:'TOweretdate',name:'TOweretdate',width:100},
	    {header:'��ҩ��',index:'TOweretuser',name:'TOweretuser',width:70},
	   	{header:'���',index:'TMR',name:'TMR',width:250,align:'left'},
	    {header:'�����ܼ�',index:'TEncryptLevel',name:'TEncryptLevel',width:100},		
		{header:'���˼���',index:'TPatLevel',name:'TPatLevel',width:100},
	    {header:'TPrt',index:'TPrt',name:'TPrt',width:60,hidden:true},
	    {header:'TOwedr',index:'TOwedr',name:'TOwedr',width:60,hidden:true},
	    {header:'Tphdrowid',index:'Tphdrowid',name:'Tphdrowid',width:80,hidden:true}
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+'?action=QueryOweList', //��ѯ��̨	
	    height: DhcphaJqGridHeight(2,3)*0.5,
	    multiselect: false,
	    datatype:'local',
	    pager: "#jqGridPager", //��ҳ�ؼ���id  
	    shrinkToFit:false,
	    onSelectRow:function(id,status){
			QueryGridOweSub()
		},
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#grid-owedetail").clearJqGrid();
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
	};
	$("#grid-owe").dhcphaJqGrid(jqOptions);
}

//��ʼ����ҩ��ϸtable
function InitGirdOweDetail(){
	var columns=[
	    {header:'ҩƷ����',index:'TInciDesc',name:'TInciDesc',width:250,align:'left'},
		{header:'��λ',index:'TPhUom',name:'TPhUom',width:60},
		{header:'Ƿҩ����',index:'TPhQty',name:'TPhQty',width:70,align:'right'},
		{header:'Ԥ��',index:'TRealQty',name:'TRealQty',width:70,
			editable:true,
			cellattr:addTextCellAttr			
		},
		{header:'�ѷ�',index:'TDispedqty',name:'TDispedqty',width:70},
		{header:'����',index:'TPrice',name:'TPrice',width:80,align:'right'},
		{header:'���',index:'TMoney',name:'TMoney',width:80,align:'right'},
		{header:'״̬',index:'TOrdStatus',name:'TOrdStatus',width:50},
		{header:'����',index:'TDoseQty',name:'TDoseQty',width:50},
		{header:'Ƶ��',index:'TPC',name:'TPC',width:60},
		{header:'�÷�',index:'TYF',name:'TYF',width:40},
		{header:'�Ƴ�',index:'TLC',name:'TLC',width:40},
		{header:'ҽʦ',index:'TDoctor',name:'TDoctor',width:70,hidden:true},
		{header:'ҽ�����',index:'TInsuCode',name:'TInsuCode',width:70},
		{header:'��λ',index:'TIncHW',name:'TIncHW',width:70},
		{header:'���',index:'TSpec',name:'TSpec',width:70},
		{header:'��ע',index:'TPhbz',name:'TPhbz',width:80},
		{header:'����',index:'TManfDesc',name:'TManfDesc',width:200,align:'left'},
		{header:'���',index:'TKCFlag',name:'TKCFlag',width:50},
		{header:'�������',index:'TKCQty',name:'TKCQty',width:80},
		{header:'TOrditm',index:'TOrditm',name:'TOrditm',width:80,hidden:true},
		{header:'TUnit',index:'TUnit',name:'TUnit',width:80,hidden:true},
		{header:'TDoctCode',index:'TDoctCode',name:'TDoctCode',width:80,hidden:true},
		{header:'TInci',index:'TInci',name:'TInci',width:80,hidden:true}
		
	]; 
	var jqOptions={
		datatype:'local',
	    colModel: columns, //��
	    url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+'?action=QueryOweListDetail',	
	    height: DhcphaJqGridHeight(2,3)*0.5,
	    shrinkToFit:false,
	    onSelectRow:function(id,status){
		    if ((JqGridCanEdit==false)&&(LastEditSel!="")&&(LastEditSel!=id)){
			    $("#grid-owedetail").jqGrid('setSelection',LastEditSel);
			    return
			}
			if ((LastEditSel!="")&&(LastEditSel!=id)){
				$(this).jqGrid('saveRow', LastEditSel);
			}			
			$(this).jqGrid("editRow", id,{
				oneditfunc:function(){
					$editinput = $(event.target).find("input");
					$editinput.focus(); 
					$editinput.select();
                    $editinput.unbind().on("keyup",function(e){
						$editinput.val(ParseToNum($editinput.val()))
					});					
					$("#"+id+"_TRealQty").on("focusout || mouseout",function(){
						var reg = /^[0-9]\d*$/;
						if (!reg.test(this.value)) {
							dhcphaMsgBox.message("��"+id+"�е�Ԥ������ֻ��Ϊ����!")
							$("#grid-owedetail").jqGrid('restoreRow',id);
							return false
						}	
						var iddata=$('#grid-owedetail').jqGrid('getRowData',id);
						var oeoriqty=iddata.TPhQty;								
						if (parseFloat(this.value*1000)>parseFloat(oeoriqty*1000)) {
							dhcphaMsgBox.message("��"+id+"��Ԥ���������ڴ�������!")
							$("#grid-owedetail").jqGrid('restoreRow',id);
							return false
						}else{
							JqGridCanEdit=true
							return true
						}
					});
				}
			});
			LastEditSel=id;
		}
	    
	};
	$("#grid-owedetail").dhcphaJqGrid(jqOptions);
	PhaGridFocusOut("grid-owedetail");
}

//��ѯǷҩ�б�
function QueryGridOwe(){
 	var stdate = $("#date-start").val();
	var enddate = $("#date-end").val();
 	var chkfy=0;
	if($("#chk-fy").is(':checked')){
		chkfy="1";
	}
	var chkreturn=0;
	if($("#chk-return").is(':checked')){
		chkreturn="1";
	}
	var patno=$("#txt-patno").val();
	var prescno=$("#txt-prescno").val();;
	var ctloc=DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID; 
	var patname="";
	var CPrint=0;
	var inci="";
	var params=stdate+"^"+enddate+"^"+ctloc+"^"+patno+"^"+CPrint+"^"+chkfy+"^"+chkreturn+"^"+prescno+"^"+patname+"^"+inci;	
	$("#grid-owe").setGridParam({
		datatype:'json',
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
	JqGridCanEdit=true;
	$("#grid-owedetail").jqGrid("clearGridData");
	//$("#grid-owedetail").clearJqGrid();
}
//��ѯǷҩ��ϸ
function QueryGridOweSub(){
	var selectid = $("#grid-owe").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-owe").jqGrid('getRowData', selectid);
	var phdowerow=selrowdata.TOwedr;
	var params=phdowerow;
	$("#grid-owedetail").setGridParam({
		datatype:'json',
		postData:{
			'params':params
		}	
	}).trigger("reloadGrid");
	JqGridCanEdit=true;
}
// ִ�з�ҩ
function ExecuteFY(){
	if (DhcphaGridIsEmpty("#grid-owe")==true){
		return;
	}
	if(DhcphaGridIsEmpty("#grid-owedetail")==true){
		 dhcphaMsgBox.alert("Ƿҩ��û����ϸ,���ܷ�ҩ!");
		 return;
	}
	var selectid=$("#grid-owe").jqGrid('getGridParam','selrow');
	if (selectid==null){
	    dhcphaMsgBox.alert("û��ѡ������,���ܷ�ҩ!");
	    return;
	}
	if(JqGridCanEdit==false){
		return;
	}
	OweDispMonitor(selectid);
}

function OweDispMonitor(rowid){
	var oweselrowdata=$("#grid-owe").jqGrid('getRowData', rowid);
	var prescno=oweselrowdata.TPrescNo;
	var owestat=oweselrowdata.TOweStatusdesc;
	var patname=oweselrowdata.TPatName;
	var warnmsgtitle="��������:"+patname+"</br>"+"������:"+prescno+"</br>";
	if ((owestat=="�ѷ�ҩ")||(owestat=="����ҩ")){
		dhcphaMsgBox.alert(warnmsgtitle+"�ü�¼"+owestat+"!");
		return;
	}
	var dispQtyString="";
	var owedetailrowdata = $("#grid-owedetail").jqGrid('getRowData');
    var owedetailgridrows=owedetailrowdata.length;
	if (owedetailgridrows<=0){
		dhcphaMsgBox.alert("û����ϸ����!");
		return;
	}
	var chkflag=0,allowe=1,zeroFlag=0
	var dispQtyString=0
	for(var rowi=0;rowi<owedetailgridrows;rowi++){
		var oeoriQty=owedetailrowdata[rowi].TPhQty
		var realQty=owedetailrowdata[rowi].TRealQty
		oeoriQty=$.trim(oeoriQty);
		realQty=$.trim(realQty);
		if(parseFloat(realQty)!=0){
			var zeroFlag=1;
		}
		if(parseFloat(realQty)>parseFloat(oeoriQty)){
			dhcphaMsgBox.alert("Ԥ���������ܴ���ҽ������!");
			return;
		}
		if (parseFloat(realQty)<0){
			dhcphaMsgBox.alert("Ԥ����������С��0!");
			return;
		}
		if (parseFloat(realQty)!=parseFloat(oeoriQty)){
			chkflag="1";
		}
		if (allowe!=0) {allowe=0}
		var oeori=owedetailrowdata[rowi].TOrditm
		var unit=owedetailrowdata[rowi].TUnit
		var Inci=owedetailrowdata[rowi].TInci
		var tmpdispstring=oeori+"^"+realQty+"^"+oeoriQty+"^"+unit+"^"+Inci
		if (dispQtyString==0){
			dispQtyString=tmpdispstring
		}
		else{
			dispQtyString=dispQtyString+"!!"+tmpdispstring
		}
		
	} 	
	if(zeroFlag!=1){
		dhcphaMsgBox.alert("Ԥ���������ܶ�Ϊ0!");
		return;
	}
	dispQtyString=chkflag+"&&"+allowe+"&&"+dispQtyString ;
	var tmpordstr=dispQtyString.split("&&") 
	var chkord=tmpordstr[0] ;
	ChkAllOweFlag=tmpordstr[1] ;  //�Ƿ�ȫ��Ƿҩ
	ChkOweFlag=chkord;
	var owedr=oweselrowdata.TOwedr;
	dispQtyString=dispQtyString+"&&"+owedr;
	var prescno=oweselrowdata.TPrescNo;
	if (chkflag=="1"){
		dhcphaMsgBox.confirm("�Ƿ���Ҫ����Ƿҩ�������[ȷ��]���ɣ����[ȡ��]�˳���",function(r){
			if(r==true){
				DispMonitor(prescno,dispQtyString,rowid);
			}else{
				return;
			}
		});  
	}else{
		DispMonitor(prescno,dispQtyString,rowid);
	}			
}

function DispMonitor(prescno,dispQtyString,rowid){                                       
	var RetInfo=tkMakeServerCall("PHA.OP.DirDisp.OperTab","SaveDispData",DHCPHA_CONSTANT.DEFAULT.PHLOC,DHCPHA_CONSTANT.DEFAULT.PHWINDOW,DHCPHA_CONSTANT.DEFAULT.PHUSER,DHCPHA_CONSTANT.DEFAULT.PHUSER,prescno,dispQtyString);
	var retarr=RetInfo.split("^");
	var retval=retarr[0];
	var retmessage=retarr[1];
	var warnmsgtitle="������:"+prescno+"</br>"
	if (!(retval>0)){
		dhcphaMsgBox.alert(warnmsgtitle+"��ҩʧ��,�������: "+retmessage);
		return;
	}
	var newdata={
		TOweStatusdesc:'�ѷ�ҩ'
	};	
	$("#grid-owe").jqGrid('setRowData',rowid,newdata);
	dhcphaMsgBox.alert("Ƿҩ��ҩ�ɹ�","success");
	var phOweId=tkMakeServerCall("PHA.OP.COM.Print","GetPhOweByPhd",retval);
	PrintPhdOwe(phOweId);
	QueryGridOweSub();
}
//ִ����ҩ
function DoReturn(){	
	if (DhcphaGridIsEmpty("#grid-owe")==true){
		return;
	}
	if(DhcphaGridIsEmpty("#grid-owedetail")==true){
		 dhcphaMsgBox.alert("Ƿҩ��û����ϸ,������ҩ!");
		 return;
	}
	var selectid=$("#grid-owe").jqGrid('getGridParam','selrow');
	var selrowdata = $("#grid-owe").jqGrid('getRowData', selectid);
	var prescno=selrowdata.TPrescNo;
	var owedr=selrowdata.TOwedr;
	var retval=tkMakeServerCall("PHA.OP.Owe.OperTab","ExcRetrun",DHCPHA_CONSTANT.DEFAULT.PHUSER,prescno,owedr);
	if (retval==-1){
		dhcphaMsgBox.alert("��Ƿҩ��״̬�Ѵ���,������ҩ!");
		return;
	}else if (retval==-2){
		dhcphaMsgBox.alert("��Ƿҩ��״̬�Ѵ���,�����ظ���ҩ!")
		return;
	}else if (retval==-4){
		dhcphaMsgBox.alert("�ô�����δ��ҩ,��ȡ����ҩ��,����ִ����ҩ!")
		return;
	}else if (retval<0){
		dhcphaMsgBox.alert("��ҩʧ��:"+retval)
		return;
	} 
	dhcphaMsgBox.alert("Ƿҩ��ҩ�ɹ�,�뵽�շѴ��˷�!"); 
	var RetData=tkMakeServerCall("PHA.OP.COM.Method","GetPhOweInfo",owedr);
	var RetOweDate=RetData.split("^")[2];
	var RetOweUser=RetData.split("^")[3];
	var newdata={
		TOweStatusdesc:'����ҩ',
		TOweretdate:RetOweDate,
		TOweretuser:RetOweUser
	};	
	$("#grid-owe").jqGrid('setRowData',selectid,newdata);
	
}
//���
function ClearConditions(){
	$("#txt-patno").val("");
	$("#txt-cardno").val("");
	$("#txt-patname").val("");
	$("#txt-prescno").val("");
	$('#chk-fy').iCheck('uncheck');
	$('#chk-return').iCheck('uncheck');
	$("#grid-owe").clearJqGrid();
	$("#grid-owedetail").clearJqGrid();
	$("#date-start").data('daterangepicker').setEndDate(new Date());
	$("#date-start").data('daterangepicker').setStartDate(new Date());
	$("#date-end").data('daterangepicker').setEndDate(new Date());
	$("#date-end").data('daterangepicker').setStartDate(new Date());
	JqGridCanEdit=true;
}
//Ȩ����֤
function CheckPermission(){
	$.ajax({
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=CheckPermission'+
			'&groupId='+DHCPHA_CONSTANT.SESSION.GROUP_ROWID+
			'&gUserId='+DHCPHA_CONSTANT.SESSION.GUSER_ROWID+
			'&gLocId='+DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
		type:'post',   
		success:function(data){ 
			var retjson=eval("(" + data + ")");
			var retdata= retjson[0];
			var permissionmsg="",permissioninfo="";
			if (retdata.phloc==""){
				permissionmsg="ҩ������:"+defaultLocDesc;
				permissioninfo="��δ������ҩ����Ա����ά��!"	
			}else {
				permissionmsg="����:"+DHCPHA_CONSTANT.SESSION.GUSER_CODE+"��������:"+DHCPHA_CONSTANT.SESSION.GUSER_NAME;
				if (retdata.phuser==""){					
					permissioninfo="��δ������ҩ����Ա����ά��!";
				}else if(retdata.phnouse=="Y"){
					permissioninfo="����ҩ����Ա����ά����������Ϊ��Ч!";
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
				DHCPHA_CONSTANT.DEFAULT.FYFLAG=retdata.phfy;
			}
		},  
		error:function(){}  
	})
}

function InitBodyStyle(){
	//$("#btn-fy").dhcphaImageBtn({image:"disp-red"});
	//$("#btn-return").dhcphaImageBtn({image:"return"});
}
function PhaGridFocusOut(gridid){
	$("#"+gridid).on("mouseleave",function (e) {
		if (e.relatedTarget) {
	        var $related = $("#"+gridid).find(e.relatedTarget);
	        if ($related.length <= 0 && LastEditSel!="") {
	            $("#"+gridid).jqGrid('saveRow', LastEditSel);
	        }
	    }
	})
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
	QueryGridOwe();
}