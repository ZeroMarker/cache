var e = window.event;
var PageLogicObj = {
    m_version: 8.1,
    m_ObjectTypeS: "",
    //ҽ�����ӵ�ҳ��ķ�ʽ:����¼��(LookUp),ҽ����/����ҽ��(ARCOS),ҽ������(Usage)
    m_AddItemToListMethod: "LookUp",
    defaultDataGridtop: 0,
    //ҽ����ʼ���ڵ�Ĭ�����ڸ�ʽ: "3" ����YYYY-MM-DD ���� "4" ����DD/MM/YYYY;Ĭ��Ϊ:DD/MM/YYYY
    defaultDataCache:"",
    FocusRowIndex: 0,
    isComboEnable: true,
    DefaultPilotProRowid : "",
    DefaultPilotProDesc:"",
    NotEnoughStockFlag:0,
    //�Ƿ�����ҽ��¼��������������ļ������ݿ���ѡ��������
    EntrySelRowFlag:0,
    SearchName:"",
    IsStartOrdSeqLink:0, //0 �������� 1 ��ʼ����
    StartMasterOrdSeq:"",
    LayoutResizeTimeout:0,
    BarcodeEntry:0,
	LookupPanelIsShow:0,
	m_selArcimRowIdStr:"",
	OrderTemplateSelGroup:null,	//ģ������ѡ��ʱ��Ҫ��¼������ƶ��켣
	OrderTemplateMouseStartY:"",
	fpArr:new Array()
}
if (websys_isIE==true) {
	 var script = document.createElement('script');
	 script.type = 'text/javaScript';
	 script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird �ļ���ַ
	 document.getElementsByTagName('head')[0].appendChild(script);
}
$(window).load(function() {
    SetTimeLog("load", "start");
	if ((GlobalObj.RecLocByLogonLocFlag=="1")||(GlobalObj.EmConsultItm)){
	    $("#FindByLogDep").checkbox("setValue",true);
	}
    $(window).resize(function() {
	    if (PageLogicObj.LayoutResizeTimeout && (PageLogicObj.LayoutResizeTimeout!=0)) {
		    clearTimeout(PageLogicObj.LayoutResizeTimeout);
	    }
        PageLogicObj.LayoutResizeTimeout=window.setTimeout(function() { 
        	ResizeGridWidthHeiht("resize"); 
        	
        }, 250);
        setTimeout(function() { 
        	ResizePromptWidth();
        }, 250);
    });
	ResizeGridWidthHeiht("resize");
	ResizePromptWidth();
    SetDefault();
    InitLayOut();
    InitOrderTemp();
    //������2
    AntLoad();
    if (GlobalObj.HLYYInterface==1){
		HLYYY_Init();
    }
    SetTimeLog("load", "end");
});
//���¼�����ŵ�ready��,����easyui���첽����,����ʼ�����߼�����ŵ�ҳ��������֮���window.load()��,������ٶ�
$(document).ready(function() {
    SetTimeLog("ready", "start");
    if ((!UIConfigObj.OrdListScale)||(UIConfigObj.OrdListScale=="")) UIConfigObj.OrdListScale="57";
    if (((GlobalObj.LoginAdmLocFlag=="Y")&&(GlobalObj.PAAdmType=="I"))||((GlobalObj.LoginAdmLocFlag!="Y")&&(GlobalObj.IsShowOrdList=="Y"))){
    //if ((GlobalObj.PAAdmType=="I")||(GlobalObj.IsShowOrdList="Y")){
	    var mainHeight=$('#layout_main').innerHeight();
	    var height=Math.ceil(mainHeight*(UIConfigObj.OrdListScale/100));
	    if (GlobalObj.layoutConfig=="1"){
		    //ҽ��������
		    $('#layout_main').layout('panel', 'south').panel('resize',{height: height});
		    if (GlobalObj.DefaultCloseList=="1"){
			    $('#layout_main').layout('panel', 'south').panel('collapse');
			}
			$('#layout_main').layout('resize',{height: '100%'});
		}else{
			$('#layout_main').layout('panel', 'north').panel('resize',{height: height});
			if (GlobalObj.DefaultCloseList=="1"){
			    $('#layout_main').layout('panel', 'north').panel('collapse');
			}
			$('#layout_main').layout('resize',{height: '100%'});
		}
		
	}
    //************************���ֲ���--��ʼ****************************//
    //���߶ȿ���
    PageLogicObj.defaultDataGridtop = $('#Order_DataGrid').offset().top;
    //����
    $('#layout_main').layout('panel', 'south').panel({
        onCollapse: function() {
            //�۵���Ӧ����
            ResizeGridWidthHeiht("Collapse");
        },
        onExpand: function() {
            //�����б���չ�� ���۵�
            ContrlSouthLayout();
            ResizeGridWidthHeiht("Expand");         
        },
        onResize: function() {
			if ($("#orderListShow").length != 0) {
				if (PageLogicObj.LayoutResizeTimeout && (PageLogicObj.LayoutResizeTimeout!=0)) {
					clearTimeout(PageLogicObj.LayoutResizeTimeout);
				}
				PageLogicObj.LayoutResizeTimeout=window.setTimeout(function() { 
					if (GlobalObj.layoutConfig == 2) { //סԺ ҽ�������� ���� 
					   if ($("#orderListShow")[0].contentWindow.ipdoc){
						   var NorthH=$('#layout_main').layout('panel', 'north').height();
						   $("#orderListShow")[0].contentWindow.ipdoc.patord.view.OrdListResize(NorthH); 
					   }
					}else{
						 var SouthH=$('#layout_main').layout('panel', 'south').height();
						 $("#orderListShow")[0].contentWindow.ipdoc.patord.view.OrdListResize(SouthH);
					}
					ResizeGridWidthHeiht("resize"); 
					 var ActiveWidth=$('#layout_main').width();
				var centernorthpanel=$('#layout_main_center_north').find("div")[1]
        	   $(centernorthpanel).width(parseFloat(ActiveWidth)-23)
        	   $('#layout_main_center_north').width(parseFloat(ActiveWidth)-12)
				}, 250);
			}
            //��С�ı���Ӧ����
        }
    });
    $('#layout_main').layout('panel', 'north').panel({
        onCollapse: function() {
            //�۵���Ӧ����
            ResizeGridWidthHeiht("Collapse");
        },
        onExpand: function() {
            //�����б���չ�� ���۵�
            ContrlSouthLayout();
            ResizeGridWidthHeiht("Expand");         
        },
        onResize: function() {
        	if (PageLogicObj.LayoutResizeTimeout && (PageLogicObj.LayoutResizeTimeout!=0)) {
			    clearTimeout(PageLogicObj.LayoutResizeTimeout);
		    }
        	PageLogicObj.LayoutResizeTimeout=window.setTimeout(function() {
	        	if (GlobalObj.layoutConfig == 2) { //סԺ ҽ�������� ���� 
	        	   if (($("#orderListShow")[0])&&($("#orderListShow")[0].contentWindow.ipdoc)){
		        	   var NorthH=$('#layout_main').layout('panel', 'north').height();
				       $("#orderListShow")[0].contentWindow.ipdoc.patord.view.OrdListResize(NorthH); 
				   }
				 }else{
					 var SouthH=$('#layout_main').layout('panel', 'south').height();
					 if (($("#orderListShow")[0])&&($("#orderListShow")[0].contentWindow.ipdoc)){
				     	$("#orderListShow")[0].contentWindow.ipdoc.patord.view.OrdListResize(SouthH);
				     }
				 }
        	   ResizeGridWidthHeiht("resize"); 
        	    var ActiveWidth=$('#layout_main').width();
        	   var centernorthpanel=$('#layout_main_center_north').find("div")[1]
        	   $(centernorthpanel).width(parseFloat(ActiveWidth)-23)
        	   $('#layout_main_center_north').width(parseFloat(ActiveWidth)-12)
        	}, 250);
            //��С�ı���Ӧ����
        }
    });
	$('#layout_main').layout('panel', 'center').panel({
	    onResize: function() {
		    if (PageLogicObj.LayoutResizeTimeout && (PageLogicObj.LayoutResizeTimeout!=0)) {
			    clearTimeout(PageLogicObj.LayoutResizeTimeout);
		    }
        	PageLogicObj.LayoutResizeTimeout=window.setTimeout(function() {
	        	if (GlobalObj.layoutConfig == 2) { //סԺ ҽ�������� ���� 
	        	   if (($("#orderListShow")[0])&&($("#orderListShow")[0].contentWindow.ipdoc)){
		        	   var NorthH=$('#layout_main').layout('panel', 'north').height();
				       $("#orderListShow")[0].contentWindow.ipdoc.patord.view.OrdListResize(NorthH); 
				   }
				 }else{
					 var SouthH=$('#layout_main').layout('panel', 'south').height();
					 if (($("#orderListShow")[0])&&($("#orderListShow")[0].contentWindow.ipdoc)){
				     	$("#orderListShow")[0].contentWindow.ipdoc.patord.view.OrdListResize(SouthH);
				     }
				 }
        	   ResizeGridWidthHeiht("resize"); 
        	   var ActiveWidth=$('#layout_main').width();
        	   var centernorthpanel=$('#layout_main_center_north').find("div")[1]
        	   $(centernorthpanel).width(parseFloat(ActiveWidth)-23)
        	   $('#layout_main_center_north').width(parseFloat(ActiveWidth)-12)
        	}, 250);
		    }
	    })
    //����ģ��,���뽫����������Ϊtrue,������ع��ܲŻ���Ч
    //$("#OrderTemplate").hide("fast","swing",function (){ResizeGridWidthHeiht("resize");});
    //************************���ֲ���--����****************************//

    //************************��ť����--��ʼ****************************//
    //UI����
    $('#UIConfigImg').click(UIConfigHandler)
        //ҽ������
    $('#Order_copy_btn').click(FindClickHandler);
    //�����鹴ѡ¼��
    $('#Examine_check_btn').click(LnkLabPage_Click);
    //��������¼��
    $('#Cure_check_btn').click(DocCure_Click);
    //ҽ���ֵ��¼��
    $('#Dictionary_check_btn').click(BtnViewArcItemInfoHandler);
    //����ҩ�������б�
    $('#Antibiotics_apply_btn').click(BtnShowViewAnditAnti);
    //����ģ��ά��
    $('#Template_maintain_btn').click(OrgFav_Click);
    //���˳���ģ��ά��
    //$('#OrgFav_User').click(OrgFav_User_Click);
    //���ҳ���ģ��ά��
    //$('#OrgFav_Location').click(OrgFav_Location_Click);
    //���ԤԼ
    $('#Appointment_btn').click(DoctorAppoint_Click);
    //������
    $('#Card_pay_btn').click(CardBillClick);
    $('#PkgOrdEntry_btn').click(PkgOrdEntry_Click);
    //��� �հ��� appendRow
    $('#Add_Order_btn').click(Add_Order_row);
    $("#Add_Order_btn").popover({placement:'top-right',content:'���(F1)',trigger:'hover'});
    //ɾ��
    $('#Delete_Order_btn').click(Delete_Order_row);
    $("#Delete_Order_btn").popover({placement:'top-right',content:'ɾ��(F2)',trigger:'hover'});
    //�����޸�
    //$('#Save_Order_btn').click(Save_Order_row);
    //���ҽ��
    $('#Insert_Order_btn').click(function(){UpdateClickHandler();});
    //����ģ��
    //$('#Personal_Template_Btn').click(OEPrefClickHandler);
    //����ģ��
    //$('#Departments_Template_Btn').click(OEPrefClickHandler);
    //���༭��
    $('#FormEdit_btn').click(FormEditRow);
    //���� ����� ��ť�ϲ� ������ͳһ����
    $('#ChangeOrderSeq_Btn').click(ChangeOrderSeqhandler);
    //���� 
    //$('#SetOrderSeq_Btn').click(SetSeqNohandler);
    //����� 
    //$('#ClearOrderSeq_Btn').click(ClearSeqNohandler);
    //ҽ�����������˵�ѡ��
    $('#ShortOrderPrior').click(ChangeOrderPriorContrl);
    $('#LongOrderPrior').click(ChangeOrderPriorContrl);
    $('#DefaultOrderPrior').click(ChangeOrderPriorContrl);
    $('#OutOrderPrior').click(ChangeOrderPriorContrl);
    //��ӡ���ﵥ
    $('#BtnPrtGuidPat').click(BtnPrtGuidPatHandler);
    //����Ϊҽ����
    $('#SaveToArcos').click(SaveToArcos_Click);
    //���浽ҽ��ģ��
    $('#SaveToTemplate').click(SaveToTemplate_Click);
    //�����û�����
    $('#SetSaveForUser').click(SetSaveForUserClickHandler);
    //����б��ģ�����ͬһ������
    $('#Orderlist_Btn').click(SetLayoutContrlValue);
    $('#OrderTemplate_Btn').click(SetLayoutContrlValue);
    //��ɽ���
    //$('#FinshAdm_btn').click(FinishAdmitClickHandler);
    //�໥����
    $('#XHZY').click(XHZY_Click);
    // ҩƷ˵����
    $('#YDTS').click(YDTS_Click);
    //������ӡ
    $('#PrescriptBtn').click(PrescriptList);
    //���Ƶ���ӡ
    $('#LabPrintBtn').click(LabPrintList);
    //ͣҽ��
    $('#StopOrderBtn').click(StopOrderItem);
    //һ����ӡ
    //$('#BtnPrtClick').click(BtnPrtClickHandler);
    //ͬ������ҽ��ʱ��
    $('#SynBtn').click(SynBtnClickHandler);
    //֪ʶ�⽨��ҽ��
    $('#AdviceOrder').click(AdviceOrder);
    //��������ģ��ҽ��
    $('#Add_TemplOrder_btn').click(MultiTemplOrdEntry);
    $("#Add_TemplOrder_btn").popover({placement:'top-right',content:'���ģ��ҽ��(A)',trigger:'hover'});
    $('#Up_Order_btn').click(SetUpToRowClickHandler);
    $('#Down_Order_btn').click(SetDownToRowClickHandler);
    $('#NurseOrd').checkbox({
	    onCheckChange:function(e,value){
		    NurseOrdClickHandler(value);
		}
	});
    //ͬ����ע
    $('#SynchroOrdNotes_Btn').click(SynchroOrdNotesClickHandler);
    //��ʾδ����ҽ��
    $('#ShowNotPayOrd_Btn').click(ShowNotPayOrdClickHandler);
	$('#Open_CASign_btn').click(OpenOrdCASign);
	//����ٴ�·��ҽ��
	$('#Add_CPWOrd').click(AddCPWOrdClickHandler);
	$('#OrdNotesDetail_Btn').click(function(){OrdNotesDetailOpen('');}).popover({placement:'bottom',content:'ҽ���ע����',trigger:'hover'});;
    //ʵϰ��ҽ������б�
    $('#PracticeDocOrder').click(ShowPracticeOrder);
    $("#changeBigBtn").click(changeBigBtnClick);
    $('#Refresh_Order_btn').click(RefreshOrderList);
    $("#Refresh_Order_btn").popover({placement:'top-right',content:'ˢ��ҽ�����',trigger:'hover'});
    $('#LookOrdPrice_btn').click(PriceDetail);
    //��ʼ����������LookUp
    InitChronicDiagLookUp();
    document.onkeydown = Doc_OnKeyDown;

    //************************��ť����--����****************************//
    //jQuery('#Template_tabs').tabs({ onSelect: function(title, index) { RedrawFavourites(index); } });
    //˫����ͷ�¼�
    jQuery('#Order_DataGrid').closest('.ui-jqgrid-view').find('div.ui-jqgrid-hdiv').bind("dblclick", headerDblClick)
        //,ҽ��¼�����������Ŀ�Ϳ��Ը��ű��Ĺ������ƶ�
    $("#gview_Order_DataGrid .ui-jqgrid-bdiv").scroll(function() {
        if (ItemzLookupGrid && ItemzLookupGrid.store) {
            if (Ext.get(ItemzLookupGrid.lookupName)) ItemzLookupGrid.posiAndSizeResize();
        }
    });
    //GetOperationStr();
    initDivHtml();
	///ҽ��ģ����ʹ���������ѡ��ģ������
	$("#OrderTemplate").mousedown(OrderTemplateMouseDownHandler).mouseup(OrderTemplateMouseUpHandler);
	$("#Prompt").on({
		mouseenter:function(e){
			if ($("#Prompt")[0].innerHTML =="") {
			     e.stopImmediatePropagation();
				return false;
			}
			var thisWidth = $(this).width(); // div �Ŀ��
			if ($("#Prompt font").length>0) {
				var wordWidth = $("#Prompt font").width();
			}else{
				var wordWidth = $(this)[0].scrollWidth; // ��תΪjs����; ���ֵĿ��
			}
			if(wordWidth <= (thisWidth+5)){ // ��5��Ϊ����div��ȶ�һ��,�����ֲ�����ʱ���,��Ϊ���ֲ�����,��ô���Ϊdiv�Ŀ��
				e.stopImmediatePropagation();
				return false;
			}
			$(this).webuiPopover({
				width:$("#Prompt").width(),
				content:function(){ 
					return $("#Prompt")[0].innerHTML
				},
				trigger:'hover',
				placement:(GlobalObj.layoutConfig=="2"?'top':'bottom'),
				cache:false
			});
			$(this).webuiPopover('show');
		}
	});
    SetTimeLog("ready", "end");
});
function ResizeGridWidthHeiht(eventName) {
	//������Ŀ��Ӧ��fastdom�ᵼ�¼���߶�������
	//fastdom.measure(function() {
		var ActiveWidth = CalGridWidth();
		var ActiveHeight = CalGridHeight(eventName);
		var CurrWidth=$('#Order_DataGrid')[0].grid.width;
		var CurrHeight=$('#Order_DataGrid')[0].p.height;
		//fastdom.mutate(function() {
			if (CurrWidth!=ActiveWidth){
				$('#Order_DataGrid').setGridWidth(ActiveWidth)
			}
			if (CurrHeight!=ActiveHeight){
				$('#Order_DataGrid').setGridHeight(parseInt(ActiveHeight));
			}
		//});
	//});
}
function CalGridWidth() {
	var northDIVMax = $("#layout_main_center_north").innerWidth();
	var _$ChgBtnText=$("#changeBigBtn .l-btn-text")[0];
	var text=""
	if (_$ChgBtnText){
		var text=_$ChgBtnText.innerText;
		if (text=="��С"){
			var northDIVMax = $("#layout_main_center").innerWidth();
			}
	}
	if (GlobalObj.PAAdmType=="I"){
		if (GlobalObj.layoutConfig == 2) { //סԺ ҽ�������� ����
			var ButtonListW = northDIVMax
			if (text!="��С"){ButtonListW = $("#layout2_north").outerWidth();}
        	gridWidthMax1 = parseInt(ButtonListW)-30; //-20��ֹ���һ����ʾ��ȫ
	    }else{
		    gridWidthMax1=northDIVMax-30;
		}
	}else{
		gridWidthMax1 = northDIVMax -25;
    	
	}
	gridWidthMin = northDIVMax - 385;
	return gridWidthMax1;
}
function CalGridHeight(eventName) {
	if ((GlobalObj.LoginAdmLocFlag=="Y")||(GlobalObj.IsShowOrdList=="Y")){
		if (GlobalObj.PAAdmType=="I") {
			if (GlobalObj.layoutConfig == 2) { //סԺ ҽ�������� ����
				var centerHeight = $("#layout_main_center").innerHeight();
				var offSetHeight = $('#Order_DataGrid').offset().top - parseFloat(PageLogicObj.defaultDataGridtop);
				var northH=$("#layout2_north").innerHeight();
				var northObj = $('#layout_main').layout('panel', 'north').panel('options');
				var collapsed = northObj.collapsed;
				if (collapsed) {
					gridHeightMax = (parseInt(centerHeight) - 130); //parseInt(northH) - offSetHeight + 195128
			    }else{
				    if (eventName == "Expand") {
					    gridHeightMax = (parseInt(centerHeight) - parseInt(northH) - offSetHeight); 
					}else{
						gridHeightMax = (parseInt(centerHeight) - 130)//(parseInt(centerHeight) - parseInt(northH) -  offSetHeight - 25); //147
				    }
				}
		    }else{
			    //ҽ�������²���
			    //���߶Ȼ���ҳ���ʼ����Ĭ�ϸ߶ȵ�ƫ����,��Ҫ�ڸ߶��м�ȥ
	    		var offSetHeight = $('#Order_DataGrid').offset().top - parseFloat(PageLogicObj.defaultDataGridtop);
			    var centerHeight = $("#layout_main_center").innerHeight();
	    		var northH = $("#layout_main_center_north").innerHeight();
			    var southH = $("#layout_main_south").outerHeight();
			    var SouthObj = $('#layout_main').layout('panel', 'south').panel('options');
			    var collapsed = SouthObj.collapsed;
			    if (collapsed) {
					    gridHeightMax = (parseInt(centerHeight) - parseInt(northH) - offSetHeight -49); //+ 25
				}else{
					if (eventName == "Expand") {
				        gridHeightMax = (parseInt(centerHeight) - parseInt(northH) -  parseInt(southH) - offSetHeight - 18); 
			        } else {
				        gridHeightMax = (parseInt(centerHeight) - parseInt(northH) -  offSetHeight - 50); 
			        }
				}
			}
		}else{
			//�ٴ�����
			gridHeightMax = CalGridHeightOP(eventName);
		}
	}else{
		//ִ�п��Ҳ�¼
		gridHeightMax = CalGridHeightOP(eventName);
	}
	return gridHeightMax;
}
//�����ҽ�������ҽ��¼��ҳ����ģ����ֻ����չ��,����������,�ṩͨ���ָ��������Ĺ���
function CalGridHeightOP(eventName) {
	if ($("#OrderTemplate").length>0) {
		var offSetHeight = $('#Order_DataGrid').offset().top - parseFloat(PageLogicObj.defaultDataGridtop);
		var mainHeight=$('#layout_main').innerHeight()
	    var centerHeight = $("#layout_main_center").innerHeight();
		var northH = $("#layout_main_center_north").outerHeight();
	    var southH = $("#layout_main_south").outerHeight();
	    var SouthObj = $('#layout_main').layout('panel', 'south').panel('options');
	    var collapsed = SouthObj.collapsed;
	    if (collapsed) {
			gridHeightMax = (parseInt(centerHeight) - parseInt(northH) - offSetHeight -49); //+25
		}else{
			if (eventName == "Expand") {
		        gridHeightMax = (parseInt(centerHeight) - parseInt(northH) -  parseInt(southH) - offSetHeight); 
	        } else { 
		        gridHeightMax = parseInt(mainHeight) - parseInt(northH) - parseInt(southH)-53
	        }
		}
	}else{
		var centerHeight = $("#layout_main_center").innerHeight();
		var northH = $("#layout_main_center_north").innerHeight();
		gridHeightMax = (parseInt(centerHeight) - parseInt(northH) + 30 );
	}
	return gridHeightMax;
}
function ordEntryTypechange(e,value){
	DocumentUnloadHandler();
	window.parent.argobj.CONTEXT="W50007";
	window.parent.LoadOrdTemplTree(window.parent.GetOrdTempTypeTabSel(),0);
	window.parent.LoadOrdEntryiFrame("W50007");
}
function GetDefaultPilotPro(){
	PageLogicObj.DefaultPilotProRowid="";
	PageLogicObj.DefaultPilotProDesc="";
    var ArrData = GlobalObj.PilotProStr.split(String.fromCharCode(2));
    for (var i = 0; i < ArrData.length; i++) {
        var ArrData1 = ArrData[i].split(String.fromCharCode(1));
        if (ArrData1[2] == "Y") {
            PageLogicObj.DefaultPilotProRowid = ArrData1[0];
            PageLogicObj.DefaultPilotProDesc = ArrData1[1];
        }
    }
}
function StopOrd(rowids,callBackFun) {
    var OrdList = ""
    for (var i = 0; i < rowids.length; i++) {
        var rowid = rowids[i]

        var OrderItemRowid = GetCellData(rowid, "OrderItemRowid");
        var OrderSeqNo = GetCellData(rowid, "id");
        var OrderStartDateStr = GetCellData(rowid, "OrderStartDate")
        if (OrdList == "") {
            OrdList = OrderItemRowid //+ "&" + OrderStartDateStr.split(" ")[0] + "&" + OrderStartDateStr.split(" ")[1];
        } else {
            OrdList = OrdList + "^" + OrderItemRowid //+ "&" + OrderStartDateStr.split(" ")[0] + "&" + OrderStartDateStr.split(" ")[1];
        }
    }
    if (OrdList == "") {
        $.messager.alert("��ʾ","��ѡ����Ҫֹͣ��ҽ��!");
        return false;
    }
    var ContainerName = "";
	var caIsPass = 0;
   	new Promise(function(resolve,rejected){
	    if (GlobalObj.CAInit == 1) {
	        if (GlobalObj.IsCAWin == "") {
	            $.messager.alert("��ʾ","���Ȳ���KEY!");
	            return false;
	        }
		    var Ret = CASignUpdate("Delete_Order_btn");
		    if (Ret == false) { return websys_cancel(); } else {
		        var CASignObj = Ret;
		        caIsPass = CASignObj.caIsPass;
		        ContainerName = CASignObj.ContainerName;
		    }
		    resolve();
	    }else{
		    resolve();
		}
	}).then(function(){
		var OrdListStr = tkMakeServerCall("web.DHCOEOrdItem", "GetOrdList", OrdList);
	    var rtn=$.m({
		    ClassName:"web.DHCDocInPatPortalCommon",
		    MethodName:"CheckMulOrdDealPermission",
		    OrderItemStr:OrdListStr.replace(/&/g, String.fromCharCode(1)),
		    date:"",
		    time:"",
		    type:"C",
		    ExpStr:session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^^"
		},false);
	    if (rtn!=0){
		   $.messager.alert("��ʾ",rtn);
		   return false;
	    }
	    var rtn = cspRunServerMethod(GlobalObj.StopOrderMethod, OrdListStr, session['LOGON.USERID'], "", "N");
	    var flag=rtn.split("^")[0];
	    if (flag!=0){
		   $.messager.alert("��ʾ","ֹͣʧ�ܣ�"+rtn.split("^")[1]);
		   return false;
	    }
	    if ((flag == "0") && (caIsPass == 1)) var ret = SaveCASign(ContainerName, OrdList, "S");
	    callBackFun(OrdListStr);
	})
}
//��ݼ�����
$(document).keydown(function(e) {
    //e = window.event || e || e.which;
    //����F1��ݼ�
    /*window.onhelp = function() { return false };
    
	//F1 ���
    if (e.which == 112) {
        if (!$("#Add_Order_btn").attr("disabled")) {
            Add_Order_row();
        }
    }
    //F2 ɾ��
    if (e.which == 113) {
        if (!$("#Delete_Order_btn").attr("disabled")) {
            Delete_Order_row();
        }
    }
	*/
    e = window.event || e || e.which;
   	if (e){
        var ctrlKeyFlag=e.ctrlKey;
    }else{
        var ctrlKeyFlag=window.event.ctrlKey;
    }
    if (ctrlKeyFlag){
	    if (event.keyCode == 83){ 
            return false;
        }
	}
});

//����Ĭ��
function SetDefault() {
    if (GlobalObj.CopyPriorCodeRowid) {
        if (GlobalObj.INAdmTypeLoc != "Y") {
		    $("#HiddenOrderPrior").val("ShortOrderPrior");
		}else{
			if (GlobalObj.CopyPriorCodeRowid == GlobalObj.ShortOrderPriorRowid) {
            	$('#ShortOrderPrior').click();
	        } else if (GlobalObj.CopyPriorCodeRowid == GlobalObj.LongOrderPriorRowid) {
	            $('#LongOrderPrior').click();
	        }else if (GlobalObj.CopyPriorCodeRowid == GlobalObj.OutOrderPriorRowid) {
	            $('#OutOrderPrior').click();
	        }
		}
    } else {
        if (GlobalObj.INAdmTypeLoc != "Y") {
            $("#HiddenOrderPrior").val("ShortOrderPrior");
        }else if(GlobalObj.OnlyShortPrior=="Y"){
	        $('#ShortOrderPrior').click();
	    }else{
		    if (GlobalObj.PAAdmType == "I") {
			    var HiddenOrderPrior = $("#HiddenOrderPrior").val();
				if ((UIConfigObj.DefaultShortOrderPrior == true)&&(HiddenOrderPrior!="ShortOrderPrior")){
					$('#ShortOrderPrior').click();
				}else if ((UIConfigObj.DefaultOutOrderPrior == true)&&(HiddenOrderPrior!="OutOrderPrior")){
					$('#OutOrderPrior').click();
				}else if ((UIConfigObj.DefaultLongOrderPrior == true)&&(HiddenOrderPrior!="LongOrderPrior")){
					$('#LongOrderPrior').click();
				}else if((GlobalObj.DefaultOrderPriorRowid==GlobalObj.ShortOrderPriorRowid)&&(HiddenOrderPrior!="ShortOrderPrior")){
					$('#ShortOrderPrior').click();
				}else{
					$('#LongOrderPrior').click();
				}
			}else{
            	$('#LongOrderPrior').click();
            }
        }
    }
    $('#Insert_Order_btn').css({ "color": "#006699", "font-weight": "bold" });
    $('#OrderTemplate_Btn').css({ "color": "#006699", "font-weight": "bold" });
}
//�����ťֻ��չ�������۵�����
function SetLayoutContrlValue(e) {
    var lastLayout = $("#LayoutContrl").val();
    var nowLayout = this.id.split("_")[0];
    //ִ�п���Ĭ���ǵ���ģ��
    if ((GlobalObj.LoginAdmLocFlag!="Y")&&(GlobalObj.IsShowOrdList!="Y")) UIConfigObj.DefaultPopTemplate=true;
    //ҽ��ģ����ʾ��ʽΪ����,�򲻽��а�ť���л�
	var text=$("#OrderTemplate_Btn .l-btn-text")[0].innerText;
	if ((UIConfigObj.DefaultPopTemplate == true)&&(text.indexOf($g('ģ��')) >= 0)&&(lastLayout!="")) {
			var btntext=[{
				text:'�ر�',
				iconCls:'icon-w-close',
				handler:function(){
					$HUI.dialog('#TemplateDetail').close();
				}
			},{
				text:'���ģ��ҽ��',
				iconCls:'icon-w-plus',
				handler:function(){
					if (MultiTemplOrdEntry()==false){
						return false;
					}else{
						clearCheckedNodes();
					}
				}
			}]
			$.ajax('ipdoc.ordtemplat.show.hui.csp', {
				"type" : "GET",
				"dataType" : "html",
				"success" : function(data, textStatus) {
					createModalDialog("TemplateDetail","ҽ��ģ����ϸ", 280, $(window).height()-20,"icon-w-list",btntext,data,"InitOrdTemplTree()");
				}
			});
		return false;
	}
    $('#Orderlist_Btn').css({ "color": "", "font-weight": "" });
    $('#OrderTemplate_Btn').css({ "color": "", "font-weight": "" });
    //�ı���ɫ ��ǰѡ��  red blue
    $('#' + this.id).css({ "color": "#006699", "font-weight": "bold" });
    //��������Ԫ��ֵ
    $("#LayoutContrl").val(nowLayout);
    //�������� layoutConfig
    if (GlobalObj.layoutConfig == "1") { //ҽ��������
        //���ҽ������ʾ���ô�����ʾ
        if (UIConfigObj.ShowList2 == true && nowLayout == "Orderlist") {
            //ȡ���� ҽ�����б���ʾ ���� ������ʾ
            //UIConfigObj.ShowList2==true -> ������ʾ  UIConfigObj.ShowList1==true -> �б���ʾ
            ContrlOrderWindow();
            return ;
        } else {
	        OrdTempBtnTextChange(lastLayout,nowLayout);
            //��ȡsouth������ʾ״̬
            var collapsed = $('#layout_main').layout('panel', 'south').panel('options').collapsed;
            if (collapsed == true) {
                $('#layout_main').layout('expand', 'south');
            } else {
                ContrlSouthLayout();
            }
        }
    } else {
	    OrdTempBtnTextChange(lastLayout,nowLayout);
	    //��ȡnorth������ʾ״̬
        var collapsed = $('#layout_main').layout('panel', 'north').panel('options').collapsed;
        if (collapsed == true) {
            $('#layout_main').layout('expand', 'north');
        } else {
            ContrlSouthLayout();
       }
    } 
}
function OrdTempBtnTextChange(lastLayout,nowLayout){
	if (lastLayout!="") {
        var ShowType = "";
	    var text=$("#OrderTemplate_Btn .l-btn-text")[0].innerText;
	    if (text.indexOf($g('ģ��')) != -1){
	        $("#OrderTemplate_Btn .l-btn-text")[0].innerText=$g("ҽ���б�");
	        ShowType = "OrderTemplate";
	    }else{
		    $("#OrderTemplate_Btn .l-btn-text")[0].innerText=$g("ҽ��ģ��");
		    ShowType = "Orderlist";
		}
		$("#LayoutContrl").val(ShowType);
    }else{
        if (nowLayout=="Orderlist"){
            $("#OrderTemplate_Btn .l-btn-text")[0].innerText=$g("ҽ��ģ��");
        }else{
	        $("#OrderTemplate_Btn .l-btn-text")[0].innerText=$g("ҽ���б�");
	    }
    }
}
//����չ������ʾ����
function ContrlSouthLayout() {
    //ȡ��ʾ����ֵ
    var nowLayout = $("#LayoutContrl").val();
    //ȡȫ��ҽ������
    var nowOrderPrior = $("#HiddenOrderPrior").val();
    //������ʾ���� layoutConfig
    //if (GlobalObj.layoutConfig == "1") {
        if (nowLayout == "Orderlist") {
            //ȡ���� ҽ�����б���ʾ ���� ������ʾ
            //UIConfigObj.ShowList2==true -> ������ʾ  UIConfigObj.ShowList1==true -> �б���ʾ
            if (UIConfigObj.ShowList2 == true) {
				ContrlOrderWindow();
            } else {
                //Ӱ��ģ��
                $('#OrderTemplate').hide("fast","swing",function (){
	                ResizeGridWidthHeiht("resize");
	            });
                //��ʾ�б�
                $('#Orderlist').show("fast","swing",function (){
	                ResizeGridWidthHeiht("resize");
	            });
                if (GlobalObj.layoutConfig == "2") {
	                $('#layout_main').layout('expand', 'north');
		            $.parser.parse('#ListAddTemplate');
		            $.parser.parse('#OrderTemplate');
	                var HiddenOrderPrior = $("#HiddenOrderPrior").val();
		            //ҽ���б�ֻ�г��ں���ʱ,�������ѡ��Ĭ�����ȼ����ǳ���,����ʾ��ʱ
			        ContrlOrderListShow(HiddenOrderPrior);
	            }else{
		            if (nowOrderPrior == "ShortOrderPrior") {
	                    //��ʾ��ʱҽ����
	                    ContrlOrderListShow("ShortOrderPrior");
	                } else if (nowOrderPrior == "LongOrderPrior") {
	                    //��ʾ����ҽ����
	                    ContrlOrderListShow("LongOrderPrior");
	                } else if (nowOrderPrior == "OutOrderPrior") {
	                    //��ʾ��ʱҽ����
	                    ContrlOrderListShow("OutOrderPrior");
	                }else{
		                var HiddenOrderPrior = $("#HiddenOrderPrior").val();
		                ContrlOrderListShow(HiddenOrderPrior);
		            }
		        }
            }
        } else {
            //Ӱ���б�
            $('#Orderlist').hide("fast","swing",function (){
	            ResizeGridWidthHeiht("resize");
	        });
            //��ʾģ��
            $('#OrderTemplate').show("fast","swing",function (){
	            ResizeGridWidthHeiht("resize");
	        });
            //��һ���Ƿ���Ҫ������Ⱦ������ʾ����
            //����չ���ͻ���Ⱦ
            if (GlobalObj.layoutConfig == "1") {
	            $('#layout_main').layout('expand', 'south');
	        }else{
		        $('#layout_main').layout('expand', 'north');
	            $.parser.parse('#ListAddTemplate');
	            $.parser.parse('#OrderTemplate');
	            //����ѡ�����ģ�� ˢ�¼���
	            //$('#Departments_Template_Btn').click();
		    }
        }
    /*} else {
        //������ʾ2 չ����Ӧ
    }*/
}
//����ҽ�������ַ� ����ҽ������ʾ
function ContrlOrderListShow(OrderPrior,Type) {	
    if (typeof Type =="undefined"){Type="";}
    var SelOrdRowIDNext="";
    if (Type=="Next"){
        SelOrdRowIDNext=VerifiedOrderObj.LinkedMasterOrderRowid;
    }
    if (GlobalObj.isNurseLogin == "1") {
	    if ($("#orderListShow").length == 0) {
		 	var src="ipdoc.patorderviewnurse.csp?PageShowFromWay=ShowFromOrdEntry&EpisodeID=" +GlobalObj.EpisodeID+"&DefaultOrderPriorType="+OrderPrior;
			$("#OrderList").append("<iframe id='orderListShow' width='100%' height='100%' src='" + src + "'></iframe>");
	     }else{
		     if ($("#orderListShow")[0].contentWindow.ipdoc){
		     	$("#orderListShow")[0].contentWindow.ipdoc.patord.view.ReLoadGridDataFromOrdEntry(OrderPrior,SelOrdRowIDNext);
		     } 
		 }
	}else{
		if ($("#orderListShow").length == 0) {
		 	var src="ipdoc.patorderview.csp?PageShowFromWay=ShowFromOrdEntry&EpisodeID=" +GlobalObj.EpisodeID+"&DefaultOrderPriorType="+OrderPrior;
			$("#OrderList").append("<iframe id='orderListShow' width='100%' height='100%' src='" + src + "'></iframe>");
	     }else{
		     if ($("#orderListShow")[0].contentWindow.ipdoc){
		     	$("#orderListShow")[0].contentWindow.ipdoc.patord.view.ReLoadGridDataFromOrdEntry(OrderPrior,SelOrdRowIDNext); 
		     }
		 }
	}
}
//����ҽ����������ʾ
function ContrlOrderWindow() {
    //ȡȫ��ҽ������
    var nowOrderPrior = $("#HiddenOrderPrior").val();
    var title = "����";
    var iframe = "";
    var src = "";
    if (GlobalObj.isNurseLogin == "1") {
        src = "ipdoc.patorderviewnurse.csp?PageShowFromWay=ShowFromOrdEntry&PatientID=" + GlobalObj.PatientID + "&EpisodeID=" + GlobalObj.EpisodeID + "&DefaultOrderPriorType=" + nowOrderPrior;
    }else{
	    src="ipdoc.patorderview.csp?PageShowFromWay=ShowFromOrdEntry&EpisodeID=" +GlobalObj.EpisodeID+"&DefaultOrderPriorType="+nowOrderPrior;
    }
    if ((nowOrderPrior == "ShortOrderPrior") || (nowOrderPrior == "OutOrderPrior")) {
        title = "��ʱҽ��";
        if (nowOrderPrior == "OutOrderPrior") {
            title = "��Ժ��ҩ";
        }
        iframe = "<iframe id='sosorderdoctor' width='100%' height='99%' src='" + src + "'></iframe>";
    } else if (nowOrderPrior == "LongOrderPrior") {
        title = "����ҽ��";
        iframe = "<iframe id='prnorderdoctor' width='100%' height='99%' src='" + src + "'></iframe>";
    } else {
    }
    if (iframe != "") {
        $('#OrderListWindow').window({
            title: title,
            width: 900,
            height: 440,
            zIndex: 9999,
            iconCls: 'icon-save',
            inline: false,
            minimizable: false,
            maximizable: true,
            collapsible: true,
            closable: true,
            top: 35,
            left: 300,
            onBeforeClose: function() { //�����ر�֮ǰ�������¼�
                //�رմ���ȥ��ҽ���� 
                $("#sosorderdoctor").remove();
                $("#prnorderdoctor").remove();
            }
        });
        $('#OrderListWindow').window('open');
        $("#sosorderdoctor").remove();
        $("#prnorderdoctor").remove();
        $("#OrderListWindow").append(iframe);
    }
}

//���ҽ����ˢ��ҽ����
function RefreshOderList(Type) {
	if (GlobalObj.PAAdmType != "I")  return false;
	if (GlobalObj.IsShowOrdList!="Y") return false;
    var lastLayout = $("#LayoutContrl").val();
    var nowOrderPrior = $("#HiddenOrderPrior").val();
    if (nowOrderPrior == "DefaultOrderPrior") {
        //�ж�Ĭ�������� ���� ���� ��ʱ  ��ʾ��Ӧҽ����  PriorRowid
        if (GlobalObj.DefaultOrderPriorRowid == GlobalObj.LongOrderPriorRowid) {
            //��ʾ����
            nowOrderPrior="LongOrderPrior";
        } else if (GlobalObj.DefaultOrderPriorRowid == GlobalObj.ShortOrderPriorRowid) {
            //��ʾ��ʱ
            nowOrderPrior="ShortOrderPrior";
        }
    }
    //�������� layoutConfig
    if (GlobalObj.layoutConfig == "1") {
        //ҽ����չ��״̬ʱˢ��  && lastLayout=="Orderlist"
        var collapsed = $('#layout_main').layout('panel', 'south').panel('options').collapsed;
        if (collapsed == false) {
            ContrlOrderListShow(nowOrderPrior,Type);
        }
    } else {
        //ҽ���б�ֻ�г��ں���ʱ,�������ѡ��Ĭ�����ȼ����ǳ���,����ʾ��ʱ
        var HiddenOrderPrior = $("#HiddenOrderPrior").val();
        if (HiddenOrderPrior != "LongOrderPrior") HiddenOrderPrior = "ShortOrderPrior";
        ContrlOrderListShow(nowOrderPrior,Type);
    }
}
function ChangeOrderPriorContrl(e) {
    var OrderPriorID = this.id;
    //����
    var Updateflag = GlobalObj.CFSwithGlobalPriorUpdate;
    new Promise(function(resolve,rejected){
	    var UpdateObj={
		    "callBackFun":resolve
		}
		if (Updateflag==1){
			//����Ƿ����¿�ҽ��
	    	var RowIdArry = GetNewOrderIDS();
	    	if ((RowIdArry.length > 0)&&(GlobalObj.OrderPriorContrlConfig == 1)) {
		    	$.messager.confirm("ȷ�϶Ի���", "��Ҫ�л�ȫ��ҽ������,�Ƿ����δ����ҽ����", function (r) {
					if (r) {
						if (GlobalObj.warning != "") {
							$.messager.alert("����",GlobalObj.warning);
	                		return false;
						}
						UpdateClickHandler(UpdateObj);
					}else{
						resolve();
					}
				});
			    return;
		    }
		}
		resolve();
	}).then(function(){
		//��������Ԫ��ֵ
	    $("#HiddenOrderPrior").val(OrderPriorID);
	    //�ı���ɫ ȫ����ԭĬ��  #000000
	    $(".btnselected").removeClass("btnselected");
	    //�ı���ɫ ��ǰѡ��  red blue #006699
	    $('#' + OrderPriorID).addClass("btnselected")
	    //��ΪID �ж�
	    var HiddenOrderPrior = $("#HiddenOrderPrior").val();
	    //var OrderPrior=$('#PriorType').text();
	    var PriorRowid = "";
	    if (HiddenOrderPrior == "ShortOrderPrior") {

	        $('#PriorType').menubutton({
	            text: "��ʱҽ��"
	        });
	        PriorRowid = GlobalObj.ShortOrderPriorRowid;
	    } else if (HiddenOrderPrior == "LongOrderPrior") {

	        $('#PriorType').menubutton({
	            text: "����ҽ��"
	        });
	        PriorRowid = GlobalObj.LongOrderPriorRowid;
	    } else if (HiddenOrderPrior == "OutOrderPrior") {

	        $('#PriorType').menubutton({
	            text: "��Ժ��ҩ"
	        });
	        PriorRowid = GlobalObj.OutOrderPriorRowid;
	    } else {
	        $('#PriorType').menubutton({
	            text: "ҽ������"
	        });
	        PriorRowid = GlobalObj.DefaultOrderPriorRowid;
	    }
	    //���õ�ǰ���һ��
	    var rowid = GetPreRowId();
	    if (CheckIsClear(rowid) == true) {
	        //����ҽ������
	        SetOrderPrior(rowid, PriorRowid);
	    }
	    //ҽ�����б� ������ʾ---8.3P��û�иĹ���
		if (UIConfigObj.ShowList2 == true) {
			//UIConfigObj.ShowList2==true -> ������ʾ  UIConfigObj.ShowList1==true -> �б���ʾ
			if ($("#sosorderdoctor").length != 0 || $("#prnorderdoctor").length != 0) {
				ContrlOrderWindow();
			}
		}else if ($("#orderListShow").length != 0) {
			///��ҽ�����Ѿ�չʾʱ���Ž�������ˢ�»���ҽ�����Ľ����ʼ��
			///ҽ������ʾ����
			if (GlobalObj.layoutConfig == "1") {
				//��ȡsouth������ʾ״̬
				var collapsed = $('#layout_main').layout('panel', 'south').panel('options').collapsed;
				var lastLayout = $("#LayoutContrl").val();
				//ҽ����Ϊչ��״̬
				if (collapsed == false && lastLayout == "Orderlist") {
					if (OrderPriorID == "ShortOrderPrior") {
						//��ʾ��ʱҽ����
						ContrlOrderListShow("ShortOrderPrior");
					} else if (OrderPriorID == "LongOrderPrior") {
						//��ʾ����ҽ����
						ContrlOrderListShow("LongOrderPrior");
					} else if (HiddenOrderPrior == "DefaultOrderPrior") {
						//�ж�Ĭ�������� ���� ���� ��ʱ  ��ʾ��Ӧҽ����  PriorRowid
						if (PriorRowid == GlobalObj.LongOrderPriorRowid) {
							//��ʾ����
							ContrlOrderListShow("LongOrderPrior");
						} else if (PriorRowid == GlobalObj.ShortOrderPriorRowid) {
							//��ʾ��ʱ
							ContrlOrderListShow("ShortOrderPrior");
						}
					} else {
						//��Ժ��ҩ
						ContrlOrderListShow("OutOrderPrior");
						//ContrlOrderListShow("ShortOrderPrior");
					}
				} else if (collapsed == false && lastLayout == "OrderTemplate") {
					//չ��Ϊģ����ʾ״̬
					//��ʾģ��
					var color = $('#OrderTemplate_Btn').css({ "color": "#006699", "font-weight": "bold" });
					//$('#OrderTemplate_Btn').click();
				}
				
			} else {
				if ($("#OrderList").css("display") == 'none') {
					return;
				}
				if (OrderPriorID == "ShortOrderPrior") {
					//��ʾ��ʱҽ����
					ContrlOrderListShow("ShortOrderPrior");
				} else if (OrderPriorID == "LongOrderPrior") {
					//��ʾ����ҽ����
					ContrlOrderListShow("LongOrderPrior");
				} else if (HiddenOrderPrior == "DefaultOrderPrior") {
					//�ж�Ĭ�������� ���� ���� ��ʱ  ��ʾ��Ӧҽ����  PriorRowid
					if (PriorRowid == GlobalObj.LongOrderPriorRowid) {
						//��ʾ����
						ContrlOrderListShow("LongOrderPrior");
					} else if (PriorRowid == GlobalObj.ShortOrderPriorRowid) {
						//��ʾ��ʱ
						ContrlOrderListShow("ShortOrderPrior");
					}
				} else {
					//ContrlOrderListShow("");
					ContrlOrderListShow("OutOrderPrior");
				}
			}
		}
	})
}
//ҽ�����Ϳ���
function SetOrderPrior(rowid, OrderPriorRowid) {
    var HiddenOrderPrior = $("#HiddenOrderPrior").val()
        //�����½����û�м��뵽����λ����ǿ�Ƹı�Ҳֻ��¼����ʱҽ��
    if (GlobalObj.INAdmTypeLoc == "N") { HiddenOrderPrior = "ShortOrderPrior" }
    var Obj = "";
    if ($.isNumeric(rowid) == true) {
        Obj = document.getElementById(rowid + "_OrderPrior");
    } else {
        Obj = document.getElementById("OrderPrior");
    }
    if ((Obj) && (Obj.type == "select-one")) {
        //��������  ҽ�������Ƿ���޸�  ���޸������ֻ����Ĭ������Ϊ��ǰѡ������
        //ҽ�����Ϳ���  1��ǿ�Ƹı�  2��ֻ����Ĭ��
        if (GlobalObj.OrderPriorContrlConfig == 1) {
            if (HiddenOrderPrior == "ShortOrderPrior") {
                ClearAllList(Obj);
                //ֻ����ʱ
                Obj.options[Obj.length] = new Option("��ʱҽ��", GlobalObj.ShortOrderPriorRowid);
                SetCellData(rowid, "OrderPrior", GlobalObj.ShortOrderPriorRowid);
                SetCellData(rowid, "OrderPriorRowid", GlobalObj.ShortOrderPriorRowid);
                SetCellData(rowid, "OrderPriorStr", GlobalObj.ShortOrderPriorRowid + ":" + "��ʱҽ��");
            } else if (HiddenOrderPrior == "LongOrderPrior") {

                ClearAllList(Obj);
                //ֻ�г���
                Obj.options[Obj.length] = new Option("����ҽ��", GlobalObj.LongOrderPriorRowid);
                SetCellData(rowid, "OrderPrior", GlobalObj.LongOrderPriorRowid);
                SetCellData(rowid, "OrderPriorRowid", GlobalObj.LongOrderPriorRowid);
                SetCellData(rowid, "OrderPriorStr", GlobalObj.LongOrderPriorRowid + ":" + "����ҽ��");
            } else if (HiddenOrderPrior == "OutOrderPrior") {

                ClearAllList(Obj);
                //��Ժ��ҩ
                Obj.options[Obj.length] = new Option("��Ժ��ҩ", GlobalObj.OutOrderPriorRowid);
                SetCellData(rowid, "OrderPrior", GlobalObj.OutOrderPriorRowid);
                SetCellData(rowid, "OrderPriorRowid", GlobalObj.OutOrderPriorRowid);
                SetCellData(rowid, "OrderPriorStr", GlobalObj.OutOrderPriorRowid + ":" + "��Ժ��ҩ");
            } else {
                ClearAllList(Obj);
                //Ĭ������
                var OrderPrior = cspRunServerMethod(GlobalObj.GetOrderPriorMethod, GlobalObj.DefaultOrderPriorRowid);
                Obj.options[Obj.length] = new Option(OrderPrior, GlobalObj.DefaultOrderPriorRowid);
                SetCellData(rowid, "OrderPrior", GlobalObj.DefaultOrderPriorRowid);
                SetCellData(rowid, "OrderPriorRowid", GlobalObj.DefaultOrderPriorRowid);
                SetCellData(rowid, "OrderPriorStr", GlobalObj.DefaultOrderPriorRowid + ":" + OrderPrior);
            }

        } else {
            //ҽ�����Ϳ�ѡ
            //����Ĭ��
            if (HiddenOrderPrior == "ShortOrderPrior") {
                OrderPriorRowid = GlobalObj.ShortOrderPriorRowid;
            } else if (HiddenOrderPrior == "LongOrderPrior") {
                OrderPriorRowid = GlobalObj.LongOrderPriorRowid;
            } else if (HiddenOrderPrior == "OutOrderPrior") {
                OrderPriorRowid = GlobalObj.OutOrderPriorRowid;
            }

            ClearAllList(Obj);
            var ArrData = GlobalObj.OrderPriorStr.split(";");
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(":");
                Obj.options[Obj.length] = new Option(ArrData1[1], ArrData1[0]);
            }
            SetCellData(rowid, "OrderPriorStr", GlobalObj.OrderPriorStr);
            if (OrderPriorRowid == "" || OrderPriorRowid == undefined) {
                SetCellData(rowid, "OrderPrior", GlobalObj.DefaultOrderPriorRowid);
                SetCellData(rowid, "OrderPriorRowid", GlobalObj.DefaultOrderPriorRowid);
            } else {
                SetCellData(rowid, "OrderPrior", OrderPriorRowid);
                SetCellData(rowid, "OrderPriorRowid", OrderPriorRowid);
            }
        }
    }
}
function GetDefaultOrderPrior(OrderPrior) {
    var HiddenOrderPrior = $("#HiddenOrderPrior").val();
    var OrderPriorRowid = "";
    var OrderPriorStr = "";
    if (HiddenOrderPrior == "ShortOrderPrior" || OrderPrior == "ShortOrderPrior") {
        //ֻ����ʱ
        OrderPriorRowid = GlobalObj.ShortOrderPriorRowid;
        OrderPriorStr = GlobalObj.ShortOrderPriorRowid + ":" + "��ʱҽ��";
    } else if (HiddenOrderPrior == "LongOrderPrior" || OrderPrior == "LongOrderPrior") {

        //ֻ�г���  
        OrderPriorRowid = GlobalObj.LongOrderPriorRowid;
        OrderPriorStr = GlobalObj.LongOrderPriorRowid + ":" + "����ҽ��";
    } else if (HiddenOrderPrior == "OutOrderPrior" || OrderPrior == "OutOrderPrior") {

        //��Ժ��ҩ
        OrderPriorRowid = GlobalObj.OutOrderPriorRowid;
        OrderPriorStr = GlobalObj.OutOrderPriorRowid + ":" + "��Ժ��ҩ";
    } else {
        OrderPriorRowid = GlobalObj.DefaultOrderPriorRowid;
        //ȡ����
        OrderPrior = cspRunServerMethod(GlobalObj.GetOrderPriorMethod, OrderPriorRowid);
        OrderPriorStr = GlobalObj.DefaultOrderPriorRowid + ":" + OrderPrior;
    }
    return OrderPriorRowid + "^" + OrderPriorStr;
}

function InitLayOut() {
	var OrderListOrTemplateClickFlag=0;
    if (UIConfigObj.DefaultExpendList == true) {
        jQuery('#Orderlist_Btn').click();
        OrderListOrTemplateClickFlag=1;
    }
    /*if (UIConfigObj.BigFont == true) {
        jQuery("DIV", document.body).css("font-size", "12pt");
    } else if (UIConfigObj.SmallFont == true) {
        jQuery("DIV", document.body).css("font-size", "9pt");
    }*/
    InitBtnDisplay();
    //��������ģ��ģʽ,�������ٵ��ģ��;��Ϊ���ģ���Ѿ��Ǵ�״̬;�������ģ�尴ť,�򽫰�ť����
    if (window.name!="OrdEntryFrame") {
	    if ((UIConfigObj.DefaultExpendTemplate == true)&&(window.name!="iopdoc_ordentrycom_emergency")) {
	        jQuery('#OrderTemplate_Btn').click();
	        OrderListOrTemplateClickFlag=1;
	    }
	    if (window.name=="iopdoc_ordentrycom_emergency") {
		    UIConfigObj.DefaultExpendTemplate=true;
		    UIConfigObj.DefaultPopTemplate=true;
		    OrderListOrTemplateClickFlag=1;
		}
        //ִ�п���Ĭ���ǵ���ģ��
	    if ((GlobalObj.LoginAdmLocFlag!="Y")&&(GlobalObj.IsShowOrdList!="Y")) UIConfigObj.DefaultPopTemplate=true;
	    if (UIConfigObj.DefaultPopTemplate == true){
		    $("#Add_TemplOrder_btn").hide();
		}
	    //ҽ��ģ����ʾ��ʽΪ������Ĭ�ϵ���ģ��
		if ((UIConfigObj.DefaultPopTemplate == true)&&(GlobalObj.DefaultExpendTemplateOnPopTemplate==1)) {
			jQuery('#OrderTemplate_Btn').click();
			OrderListOrTemplateClickFlag=1;
		}
	    //����ҽ��¼�������δ���ò��֣���Ĭ��չ��ҽ��ģ��
	    if (GlobalObj.PAAdmType != "I") {
		    if ((UIConfigObj.DefaultCloseList==false)&& (UIConfigObj.DefaultExpendTemplate==false)){
			    jQuery('#OrderTemplate_Btn').click();
			    OrderListOrTemplateClickFlag=1;
			}
		}else{
			if (UIConfigObj.DefaultCloseList == true){
				$("#LayoutContrl").val("OrderTemplate_Btn");
				OrdTempBtnTextChange("","OrderTemplate");
				OrderListOrTemplateClickFlag=1;
			}
		}
		if (OrderListOrTemplateClickFlag==0){
			jQuery('#OrderTemplate_Btn').click();
		}
    }else{
	    $("#OrderTemplate_Btn,#Template_maintain_btn").hide();
    }
}
//******************** ��Ӧ���� *****************//
//����������֮ǰ ʹ��ID��1��ʼ
/*
function RebuidRowId(id){
    var rowid="";
    $.ajax({
        url: "oeorder.oplistcustom.new.request.csp?action=ReBuidRowId",
        data: {USERID:session['LOGON.USERID'],ADMID:GlobalObj.EpisodeID,id:id},
        async:false,//ͬ��
        success: function(response){        
            rowid=parseInt(response);
            //$.messager.alert("����",rowid);
            if(rowid==0){
                //var rowid=Add_Order_row();//110
                if($.isNumeric(rowid)==true){
                    //EditRowid=rowid;
                }
            }
        }
    })
    return rowid;
}
*/
//�������ݷ�ҳ
/*
function uppage(pgButton){
    var page = jQuery("#Order_DataGrid").jqGrid('getGridParam','page');
    $("#Order_DataGrid").setGridParam({page:page}).trigger("reloadGrid");
    //�����һҳ������
} 
*/
//******************ģ����� ��ʼ**********************//
function OEPrefClickHandler(e) {
    var obj = websys_getSrcElement(e);
    if (!obj) return;
    var ObjectType = "";
    var id=obj.id;
    if (id==""){
    	id=e.currentTarget.id;
    }
    $(".seltemplate_btn").removeClass("seltemplate_btn");
    if (id == 'Personal_Template_Btn') {
        ObjectType = "User.SSUser";
    } else if (id == 'Departments_Template_Btn') {
        ObjectType = "User.CTLoc";
    } else if (id == 'OEPrefHosp') {
        ObjectType = "User.CTHospital";
    }
    $("#"+id).addClass("seltemplate_btn");
    //if (obj.style) obj.style.color = "#006699", obj.style.fontWeight = "bold";
    PageLogicObj.m_ObjectTypeS = ObjectType;
    websys_createWindow(lnkFav + '&TABIDX=0' + '&ObjectType=' + ObjectType + '&PREFTAB=1', 'TRAK_hidden');
}
function OEPrefChangeHandel(Type){
    if (Type=="U"){
        //$('#Personal_Template_Btn').trigger("OEPrefClickHandler");
        $('#Personal_Template_Btn').click();
    }
    if (Type=="L"){
        $('#Departments_Template_Btn').click();
    }
}
function PrefAddItemCustom(tabidx, lstcnt, val, desc, hasdefault, stockqty) {
    var selector = '#ngroup' + lstcnt + 'Z' + tabidx;
    var lstpanel = jQuery(selector);
    var descarr = desc.split(" - ");
    if (descarr.length > 1) { desc = descarr[1] };
    val = val + selector;
    if (!document.getElementById(val)) {
        var Color = "";
        if (hasdefault == "Y") { Color = "blue"; }
        if (stockqty == 0) {
            Color = "red";
        }
        var StyleStr = "style=\"color:" + Color + " \"";
        //var OneLabel="<label "+StyleStr+" id=\""+val+"\" class=\"\" onclick=\"templateItemClickHandler(this)\" ondblclick=\"templateItemdbClickHandler(this)\" onselectstart=\"return false;\" >"+desc+"</label><br>"
        var ItemCustomLabelStr = $("#tempTemplateData").data(selector) || "";
        var length = ItemCustomLabelStr.split("</label>").length || 0;
        var itemid = val.split(String.fromCharCode(4))[2];
        itemid = itemid.replace("||", "_")
        var labelclass = lstcnt + "_" + tabidx + "_" + length;
        var checkvalue = itemid + "_" + labelclass
        var OrderType = val.split("#")[0].split(String.fromCharCode(4))[0] //mPiece(value,String.fromCharCode(4),0);
        var OneLabel = "<label " + StyleStr + " id=\"" + val + "\" class=\"" + labelclass + "\" onclick=\"templateItemClickHandler(this)\" ondblclick=\"templateItemdbClickHandler(this)\" onselectstart=\"return false;\" >" + desc + "</label><br>"
        if (OrderType == "ARCIM") {
            var OneLabel = "<input onclick=\"templateCheckClickHandler(this)\" class=\"ordtemplatecheck\" id=\"" + checkvalue + "\" type='checkbox' style='vertical-align:middle;padding:0px;'>" + OneLabel
        }
		OneLabel="<div>"+OneLabel+"</div>";
        var ItemCustomLabelStr = $("#tempTemplateData").data(selector) || "";
        ItemCustomLabelStr = ItemCustomLabelStr + OneLabel;
        $("#tempTemplateData").data(selector, ItemCustomLabelStr);
        //$HUI.checkbox("input.ordtemplatecheck",{});
    }
}
function OrderTemplateMouseDownHandler(e){
	//�ҵ�OrderTemplateԪ��
	var tagName=$(e.target).prop("tagName")
	if ((tagName=="DIV")&&(e.target.id=="")){
		PageLogicObj.OrderTemplateSelGroup=$(e.target).parent();
	}else if ((tagName=="LABEL")||(tagName=="INPUT")){
		PageLogicObj.OrderTemplateSelGroup=$(e.target).parent().parent();
	}else{
		PageLogicObj.OrderTemplateSelGroup=$(e.target);
	}
	PageLogicObj.OrderTemplateMouseStartY=e.clientY;
}
function OrderTemplateMouseUpHandler(e){
	PageLogicObj.OrderTemplateSelGroup=null;
	PageLogicObj.OrderTemplateMouseStartY="";
}
function PrefAddItemCustomAppend(tabidx, lstcnt) {
    var selector = '#ngroup' + lstcnt + 'Z' + tabidx;
    var lstpanel = jQuery(selector);
    var ItemCustomLabelStr = $("#tempTemplateData").data(selector);
    lstpanel.append(ItemCustomLabelStr);
	//$(lstpanel).find("label").each(function(){
	$(lstpanel).find("div").each(function(){
        $(this).bind("mouseenter mouseleave",function(e){
			if (!PageLogicObj.OrderTemplateSelGroup){
				return;
			}
            if ($(this).parent().attr("id")!=PageLogicObj.OrderTemplateSelGroup.attr("id")){
				return;
			}
			console.log("---"+$(this).text()+";"+e.type.replace("mouse",""))
			var $label=$(this).find("label");
			var $checkBox=$label.prev();
			if ($checkBox.attr("type")!="checkbox"){
				return;
			}
			console.log($label.text()+","+e.type.replace("mouse", ""))
			//Ԫ���ϱ�Ե
			var eleTop=parseInt($(this).offset().top);
			//Ԫ���±�Ե
			var eleDop=parseInt(eleTop+$(this)[0].offsetHeight);
			if (e.type=="mouseenter"){
				$checkBox.prop('checked', true);
				$label.addClass("templateItemSelect");
			}else if (e.type=="mouseleave"){
				///�ж���������ѡ�й켣�Ƿ���뿪�켣һ�£����һ�£��������ô���
				///�����һ�£�˵��������¼��Ҫȡ��ѡ��
				if (PageLogicObj.OrderTemplateMouseStartY>e.clientY){
					//��������ƶ�
					var MoveTrail=true;
				}else{
					var MoveTrail=false;
				}
				//�����Ԫ���·�
				console.log(e.clientY+","+eleDop+","+MoveTrail);
				if (e.clientY>=eleDop){
					if (MoveTrail==true){
						$checkBox.prop('checked', false);
						$label.removeClass("templateItemSelect");
					}
				}else if (e.clientY<=eleTop){
					//�����Ԫ���Ϸ�
					if (MoveTrail==false){
						$checkBox.prop('checked', false);
						$label.removeClass("templateItemSelect");
					}
				}
			}
        });
    });
    $("#tempTemplateData").data(selector, "");
    $("#ngroup" + lstcnt + "Z" + tabidx).click(function() {
        for (var i = 0; i < 5; i++) {
            $("#ngroup" + i + "Z" + tabidx).prev().children(":first").css("background-color", "")
        }
        $("#" + this.id).prev().children(":first").css("background-color", "#87CEFF") //css("color","red")
            //$("#"+this.id).prev().css("background-color","red")
        lstidx = lstcnt
    })
}
function templateCheckClickHandler(e){
    var idstr = e.id
    var labelclassArr=idstr.split("_");
    var labelclass=labelclassArr[2]+"_"+labelclassArr[3]+"_"+labelclassArr[4];
    $("."+labelclass+"").removeClass("templateItemSelect");
    idstr=escapeJquery(idstr);
    if ($("#" + idstr + "").is(":checked")) {
        $("."+labelclass+"").addClass("templateItemSelect");
    }
}
function templateItemClickHandler(e) {
    var idstr = e.id
    var labelclassname = e.className.split(" ")[0];
    var itemid = idstr.split("#")[0].split(String.fromCharCode(4))[2];
    itemid = itemid.replace("||", "_")
    var checkvalue = itemid + "_" + labelclassname;
    checkvalue=escapeJquery(checkvalue);
    if ($("#" + checkvalue + "").length==0){
       if (jQuery(e).hasClass("templateItemSelect")){
          jQuery(e).removeClass("templateItemSelect");
       }else{
           jQuery(e).addClass("templateItemSelect");
       }
       return;
    }
    if ($("#" + checkvalue + "").is(":checked")) {
        $("#" + checkvalue + "").prop('checked', false);
        jQuery(e).removeClass("templateItemSelect");
    } else {
        $("#" + checkvalue + "").prop('checked', true);
        jQuery(e).addClass("templateItemSelect");
    }
}

function templateItemdbClickHandler(e) {
    //��ģ������ҽ��
    var obj = websys_getSrcElement(e);
	addSelectedFav(obj.id,obj.innerText);
}
function RedrawFavourites(tabidx, FocusWindowName) {
    //if (currTab==tabidx) return;
    //Log 54451 PeterC 19/08/05
    var obj = jQuery('#Template_tabs');
    var currTab = obj.tabs('getSelected');
    var currTabIndex = obj.tabs('getTabIndex', currTab);
    if (!document.getElementById('ngroup0Z' + tabidx)) {
        for (var groupI = 0; groupI < 5; groupI++) { //easyui-panel
            currTab.append("<div class='template_div'><div data-options='fit:true' class='hisui-panel' title=' ' id='ngroup" + groupI + 'Z' + tabidx + "'></div></div>");
        }
        jQuery.parser.parse('#Template_tabs');
    }
    var formulary = "";
    var obj = document.getElementById("NonFormulary");
    if (obj) {
        if (obj.checked) formulary = "Y";
        else { formulary = "N"; }
    }

    if (!obj) formulary = "";
    if ((FocusWindowName) && (FocusWindowName != "")) {
        websys_createWindow(lnkFav + '&TABIDX=' + tabidx + '&FocusWindowName=' + FocusWindowName + '&formulary=' + formulary, 'TRAK_hidden');
    } else {
        //���ģ�����ݳ�����?�п��ܴ��ڳ���?���԰ѵڶ�������'TRAK_hidden'��Ϊ��?�Ϳ�����ʾ��������
        websys_createWindow(lnkFav + '&ObjectType=' + PageLogicObj.m_ObjectTypeS + '&TABIDX=' + tabidx, 'TRAK_hidden');
        //��Ĭ�ϵ�list index��Ϊ��
        lstidx = "";
        //���TABҳ�л�������?�������������仹�쿴
        //websys_createWindow(lnkFav+'&TABIDX='+tabidx,'TRAK1');
    }
    //��Ϊ�л�Tabʱ�����ģ����趨����Categor��SubCategory?Ϊ�˲�Ӱ�쿪ҽ��?Ĭ��Ҫ��Ϊ��
    window.setTimeout("ClearCategory()", 1000);
}
function ClearCategory() {

    obj = document.getElementById('catID');
    if (obj) obj.value = '';
    obj = document.getElementById('Category');
    if ((obj) && (obj.tagName == 'INPUT')) { obj.value = ''; };
    obj = document.getElementById('subcatID');
    if (obj) obj.value = '';
    obj = document.getElementById('SubCategory');
    if ((obj) && (obj.tagName == 'INPUT')) obj.value = "";
}
function PrefEditItem(Str) {
    var arr = Str.split("Z");
    var lstcnt = arr[1];
    var tabidx = arr[2];
    var ObjectType = arr[3];
    var selector = '#ngroup' + lstcnt + 'Z' + tabidx;
    var select = jQuery(selector).find(".templateItemSelect")[0];
    //�ж��Ƿ���ڿ���Ȩ��,������Ҫѡ��ά�����˻��ǿ���
    var GroupID = session['LOGON.GROUPID'];
    var MenuName = "System.OEOrder.OrgFav.Save.SetSaveForLocation";
    var ret = cspRunServerMethod(GlobalObj.IsHaveMenuAuthOrderOrgFavMethod, GroupID, MenuName);
    if ((ret != 1) && (ObjectType == "User.CTLoc")) {
        $.messager.alert("����", "û��Ȩ��ά������ģ��")
        return
    }
    var ItemCount=0;
    var $select=jQuery(selector).find(".templateItemSelect")
    var length=$select.length;
    for (var i = 0; i < length; i++) {
        ItemCount=ItemCount+1;
    }
    if (arr[0]=="edit"){
        if (ItemCount>=2){
           $.messager.alert("����", "��ѡ��һ����¼���в���!")
           return false;
        }
    }
    if (arr[0]=="remove"){
        if (ItemCount==0){
            $.messager.alert("����", "������ѡ��һ����¼���в���!")
            return false;
        }
    }
    var value = "",
        OrderType = "",
        itemid = "";
    if (select) {
        value = select.id;
        OrderType = mPiece(value, String.fromCharCode(4), 0);
        itemid = value.split(String.fromCharCode(4))[2];
    }
    switch (arr[0]) {
        case "add":
            {
	            var ItemStr=GetItemStr(lstcnt,tabidx);
	            var URL = "oeorder.orgfav.prefedit.csp?Type=add&OrderType=" + OrderType + "&itemid=" + itemid + "&EpisodeID=" + GlobalObj.EpisodeID+"&ItemStr="+ItemStr; //lstcnt + "Z" + tabidx
	            websys_showModal({
					url:URL,
					title:'����ҽ��',
					width:650,height:400,
					CallBackFunc:function(result){
						if (result=="") {
							return "";
						}
						var NewOrderType = result.NewOrderType;
		                var NewItemID = result.NewItemID;
		                var rtn = cspRunServerMethod(GlobalObj.PrefEditItemMethod, "add", ObjectType, GlobalObj.XCONTEXT, lstcnt + "Z" + tabidx, "", "", NewOrderType, NewItemID);
		                if (rtn != "1") {
		                    $.messager.alert("����", "����ʧ��:" + rtn);
		                    return;
		                }
		                InitOrderTemp(ObjectType);
					}
				})
                break
            }
        case "remove":
            {
                var $select=jQuery(selector).find(".templateItemSelect")
                var length=$select.length;
                for (var i = 0; i < length; i++) {
                    var value = $select[i].id;
                    var OrderType = mPiece(value, String.fromCharCode(4), 0);
                    var itemid = value.split(String.fromCharCode(4))[2];
                    var rtn = cspRunServerMethod(GlobalObj.PrefEditItemMethod, "remove", ObjectType, GlobalObj.XCONTEXT, lstcnt + "Z" + tabidx, OrderType, itemid, "", "");
                    if (rtn != "1") {
                        $.messager.alert("����", "����ʧ��:" + rtn);
                        break;
                    }
                }
                InitOrderTemp(ObjectType);
                break;
            }
        case "edit":
            {
                if (itemid == "") {
                    $.messager.alert("����", "��ѡ����Ҫ�޸ĵ���Ŀ");
                    break;
                }
                var ItemStr=GetItemStr(lstcnt,tabidx)
                var URL = "oeorder.orgfav.prefedit.csp?Type=edit&OrderType=" + OrderType + "&itemid=" + itemid + "&EpisodeID=" + GlobalObj.EpisodeID+"&ItemStr="+ItemStr;
                websys_showModal({
					url:URL,
					title:'�޸�ҽ��',
					width:650,height:400,
					CallBackFunc:function(result){
						if (result=="") {
							return "";
						}
						var NewOrderType = result.NewOrderType;
		                var NewItemID = result.NewItemID;
		                var rtn = cspRunServerMethod(GlobalObj.PrefEditItemMethod, "edit", ObjectType, GlobalObj.XCONTEXT, lstcnt + "Z" + tabidx, OrderType, itemid, NewOrderType, NewItemID);
		                if (rtn != "1") {
		                    $.messager.alert("����", "����ʧ��:" + rtn);
		                    return;
		                }
		                InitOrderTemp(ObjectType);
					}
				})
				break;
            }
            default: {
                $.messager.alert("����", "������Ч!")
            }
    }
}
//******************ģ����� ����**********************//
//������

//ɾ��һ��
function DeleteRow(rowid,delType) {
	var DeleteRowSub=function(rowid){
		//������3
		DeleteAntReason(rowid);
		$('#Order_DataGrid').delRowData(rowid);
	}
	if ($.isNumeric(rowid)){
		if (typeof delType!="undefined"){
			if (delType=="Group"){
				var RowArry = GetSeqNolist(rowid)
				RowArry.push(rowid);
				for (var i = 0; i < RowArry.length; i++) {
	    			DeleteRowSub(RowArry[i]);
				}
			}else{
				DeleteRowSub(rowid);
			}
		}else{
			DeleteRowSub(rowid);
		}
		//��ʾ��Ϣ�ı�
		OrderMsgChange();
	}
}
//���һ������
function ClearRow(rowid) {
    //ɾ����ǰ�� ����ӿհ���  
    if ($.isNumeric(rowid) == true) {
        DeleteRow(rowid);
        Add_Order_row();
    }
    SetScreenSum();
}
//������ҽ��ID��ȡ��ҽ��ID����
function GetMasterSeqNo(rowid) {
    var rowids = new Array();
    var AllRowids = $('#Order_DataGrid').getDataIDs();
    for (var i = 0; i < AllRowids.length; i++) {
	    var OrderType = GetCellData(AllRowids[i], "OrderType");
	    // if (OrderType!="R") continue;
        var OrderMasterSeqNo = GetCellData(AllRowids[i], "OrderMasterSeqNo");
        if (OrderMasterSeqNo == rowid) {
            rowids[rowids.length] = AllRowids[i];
        }
    }
    return rowids;
}
//�����кŻ�ȡ���й���ҽ�� 
function GetSeqNolist(rowid) {
    var OrderSeqNoMain = GetCellData(rowid, "id").replace(/(^\s*)|(\s*$)/g, '');
    var OrderMasterSeqNoMain = GetCellData(rowid, "OrderMasterSeqNo").replace(/(^\s*)|(\s*$)/g, '');
    var rowids = new Array();
    var AllRowids = $('#Order_DataGrid').getDataIDs();
    for (var i = 0; i < AllRowids.length; i++) {
        if (CheckIsItem(rowids[i]) == true) { continue; }
        var OrderMasterSeqNo = GetCellData(AllRowids[i], "OrderMasterSeqNo");
        var Orderid = GetCellData(AllRowids[i], "id");
        if (OrderMasterSeqNoMain == "") {
            if (OrderSeqNoMain == OrderMasterSeqNo) { rowids[rowids.length] = AllRowids[i]; }
        } else {
            if ((OrderMasterSeqNoMain == Orderid) || (OrderMasterSeqNo == OrderMasterSeqNoMain)) { rowids[rowids.length] = AllRowids[i]; }
        }
    }
    return rowids;
}
//ˢ�±������
function ReloadGrid(reloadFlag,NotDisplayNoPayOrd) {
    //reload grid
    //��ֹ�������ݲ���ˢ��
    if (typeof reloadFlag == "undefined") {
        var reloadFlag = "";
    }
    if (typeof NotDisplayNoPayOrd == "undefined") {
        NotDisplayNoPayOrd = GlobalObj.NotDisplayNoPayOrd;
    }
    if (reloadFlag != "") {
        DocumentUnloadHandler()
    } else {
        ClearSessionData();
        $("#ScreenBillSum").val(0.00);
    }
    $("#Order_DataGrid").jqGrid("clearGridData");
    if (GlobalObj.PAAdmType!="I") {
	    var url = "oeorder.oplistcustom.new.request.csp?action=GetOrderList";
	    var postData = { USERID: session['LOGON.USERID'], ADMID: GlobalObj.EpisodeID,NotDisplayNoPayOrd:NotDisplayNoPayOrd };
	    $("#Order_DataGrid").setGridParam({postData:postData}).trigger("reloadGrid");
    }
    if (reloadFlag != "") {
        GetSessionData()
    }
    Add_Order_row();
    ReLoadLabInfo()
}
///tanjishan 2016-03-09 ���½����ϵ�ҽ��������Ϣ
///���ﲡ���л�ҳǩʱ����ô˷���
function ReLoadLabInfo() {}
//˫���༭��     5555
function EditRow(rowid, Flag) {
	if (typeof Flag == "undefined") {
        Flag = 0;
    }
    //������Ƿ�ɱ༭
    if (CheckCanEdit(rowid) == false) { return false; }
    //�Ѿ��Ǳ༭״̬���˳�if($.isNumeric(rowid)==true)
    if (GetEditStatus(rowid) == true || $.isNumeric(rowid) == false) { return false; }
    //1:��ȡ������ʽ����
    var StyleConfigStr = GetCellData(rowid, "StyleConfigStr");
    //2014-04-24
    var StyleConfigObj = {};
    if (StyleConfigStr != "") {
        StyleConfigObj = eval("(" + StyleConfigStr + ")");
    }
    //�ؽ������� ���������� ����ֵ
    //2:ȡ���ݴ�
    var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
    var OrderType = GetCellData(rowid, "OrderType");
    var OrderPHPrescType = GetCellData(rowid, "OrderPHPrescType");
    //ҽ������
    var OrderPriorStr = GetCellData(rowid, "OrderPriorStr");
    if (OrderPriorStr == "") {
        OrderPriorStr = GlobalObj.OrderPriorStr
    }
    //������λ
    var idoseqtystr = GetCellData(rowid, "idoseqtystr");
    //������λ 000000 -Э�鵥λ
    var OrderPackUOMStr = GetCellData(rowid, "OrderPackUOMStr");
    //���տ���
    var CurrentRecLocStr = GetCellData(rowid, "CurrentRecLocStr");
    //�걾
    var OrderLabSpecStr = GetCellData(rowid, "OrderLabSpecStr");
    //ҽ������
    var OrderInsurCatHideen = GetCellData(rowid, "OrderInsurCatHideen");

    //$.messager.alert("����",CurrentRecLocStr);
    //3:ȡ��һ��ѡ��ID�͹������� ��Ϊ�����б����ݻ���Ĭ��ѡ�� �����������б�����֮ǰȡֵ
    //var rowdata=GetRowData(rowid); //������� ��Ϊ�����û�б��� ��ȡ����ǩ
    //ҽ������
    var OrderPrior = GetCellData(rowid, "OrderPrior");
    var OrderPriorRowid = GetCellData(rowid, "OrderPriorRowid");
    //������λ
    var OrderDoseUOM = GetCellData(rowid, "OrderDoseUOM"); //��ʾֵ    
    var OrderDoseUOMRowid = GetCellData(rowid, "OrderDoseUOMRowid");
    var OrderDoseQty = GetCellData(rowid, "OrderDoseQty");
    //���տ���
    var OrderRecDepRowid = GetCellData(rowid, "OrderRecDepRowid");
    //var OrderPackUOM=GetCellData(rowid,"OrderPackUOM"); //��ʾֵ
    //������λ
    var OrderPackUOMRowid = GetCellData(rowid, "OrderPackUOMRowid");
    //�걾
    var OrderLabSpecRowid = GetCellData(rowid, "OrderLabSpecRowid");
    //�ѱ�
    var OrderBillTypeRowid = GetCellData(rowid, "OrderBillTypeRowid");
    //����˵��
    var OrderPriorRemarksRowId = GetCellData(rowid, "OrderPriorRemarksRowId");
    //ҽ������
    var OrderInsurCatRowId = GetCellData(rowid, "OrderInsurCatRowId");
    //������Ŀ
    var OrderPilotProRowid = GetCellData(rowid, "OrderPilotProRowid");
    //������
    var idiagnoscatstr = GetCellData(rowid, "idiagnoscatstr");
    //�ɼ���λ
    var OrderLabSpecCollectionSiteStr = GetCellData(rowid, "OrderLabSpecCollectionSiteStr");
    var OrderLabSpecCollectionSiteRowid = GetCellData(rowid, "OrderLabSpecCollectionSiteRowid");
    var DefaultOrderDIACat = GetCellData(rowid, "OrderDIACat");
    var DefaultOrderDIACatRowId = GetCellData(rowid, "OrderDIACatRowId");
    var OrderName = GetCellData(rowid, "OrderName");
    var OrderPriorRemarksRowId = GetCellData(rowid, "OrderPriorRemarksRowId");
    var OrderOperationCode=GetCellData(rowid,"OrderOperationCode");
    var OrderHiddenPara=GetCellData(rowid,"OrderHiddenPara");
    var OrderItemCatRowid = mPiece(OrderHiddenPara, String.fromCharCode(1), 2);
    var HourFlag = cspRunServerMethod(GlobalObj.IsHourItem, OrderARCIMRowid);
    var OrderOperationStr=GetCellData(rowid,"OrderOperationStr");
    var OrderDocStr=GetCellData(rowid,"OrderDocStr");
    var OrderFreqRowid=GetCellData(rowid,"OrderFreqRowid");
    var InsurCatStr=GetCellData(rowid, "OrderInsurCatHideen");
    var OrderChronicDiagStr=GetCellData(rowid, "OrderChronicDiagStr");
    var OrderChronicDiagCode=GetCellData(rowid, "OrderChronicDiagCode");
    //1:��ȡ������ʽ����
    var StyleConfigObj = {};
    var StyleConfigStr = GetCellData(rowid, "StyleConfigStr");
    if (StyleConfigStr == "") {
	    var OrderRecDepRowid=GetCellData(rowid, "OrderRecDepRowid")
		var OrderMasterARCIMRowid="";
		var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
		if (OrderMasterSeqNo!=""){
			var rowids = GetAllRowId();
	        for (var i = 0; i < rowids.length; i++) {
				var OrderSeqNo = GetCellData(rowids[i], "id")
	            var OrderSeqNoMasterLink = GetCellData(rowids[i], "id");
	            if (OrderSeqNoMasterLink == OrderMasterSeqNo) {
	            	OrderMasterARCIMRowid=GetCellData(rowids[i], "OrderARCIMRowid");
	            	break;
	            }
	        }
		}
        var DefaultParamObj = {
            rowid: rowid,
            OrderARCIMRowid: OrderARCIMRowid,
            OrderType: OrderType,
            OrderPHPrescType: OrderPHPrescType,
            OrderPriorRowid: OrderPriorRowid,
            OrderPriorRemarksRowId: OrderPriorRemarksRowId,
            OrderHiddenPara:"",
            OrderItemCatRowid:OrderItemCatRowid,
            IsHourItem:HourFlag,
            OrderRecDepRowid:OrderRecDepRowid,
			OrderMasterARCIMRowid:OrderMasterARCIMRowid,
			OrderFreqRowid:OrderFreqRowid
        };
        StyleConfigObj = GetStyleConfigObj(DefaultParamObj);
    } else {
        StyleConfigObj = eval("(" + StyleConfigStr + ")");
    }
    StyleConfigObj.OrderName = true
        //$.messager.alert("����",StyleConfigStr);
    
    //�ؽ������� ���������� ����ֵ
    //var OrderItemRowid=GetCellData(rowid,"OrderItemRowid");
    var OrderType = GetCellData(rowid, "OrderType");
    var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
    var OrderPrescNo = GetCellData(rowid, "OrderPrescNo");
    if ((OrderPrescNo != "")||(Flag=="1")) { 
        ///tanjishan 2015-09
        ///���ؽ�ҽ������,���μ���,���μ�����λ,Ƶ��,�Ƴ�,�÷�
        StyleConfigObj.OrderName = false
        //StyleConfigObj.OrderMasterSeqNo = false
        StyleConfigObj.OrderPrior = false
        //StyleConfigObj.OrderLabSpec = false
        //StyleConfigObj.OrderInsurCat = false
        StyleConfigObj.OrderAction = false
        StyleConfigObj.OrderSkinTest = false
        StyleConfigObj.OrderStartDate = false
        StyleConfigObj.OrderPackQty = true
        if (OrderMasterSeqNo != "") {
            StyleConfigObj.OrderDur = false;
            StyleConfigObj.OrderFreq = false;
            StyleConfigObj.OrderInstr = false;
            StyleConfigObj.OrderSpeedFlowRate = false;
            StyleConfigObj.OrderFlowRateUnit = false;
			StyleConfigObj.ExceedReason=false;
			StyleConfigObj.OrderLocalInfusionQty=false;
			if (GlobalObj.CFSameRecDepForGroup == 1){
				StyleConfigObj.OrderRecDep=false;
			}
			StyleConfigObj.OrderStage = false;
        }
		if (GlobalObj.PAAdmType!="I") {
		    var OrderPriorRemarks = GetCellData(rowid, "OrderPriorRemarksRowId");
		    if ((OrderPriorRemarks=="OM")||(OrderPriorRemarks=="ZT")){
			    StyleConfigObj.OrderPackQty = false;
			}
		}
    }
    var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
    var SttIsCanCrossDay = mPiece(OrderHiddenPara, String.fromCharCode(1), 8);
    var OrdDateIsCanCrossDay= mPiece(OrderHiddenPara, String.fromCharCode(1), 22);
    if (GlobalObj.CurrentDischargeStatus == "B") {
	    $.extend(StyleConfigObj, {OrderStartDate:true,OrderDate:true});
	}else{
	    if (!CheckDateTimeModifyFlag(GlobalObj.ModifySttDateTimeAuthority,SttIsCanCrossDay)){
		    $.extend(StyleConfigObj, { OrderStartDate: false});
		}else{
			$.extend(StyleConfigObj, { OrderStartDate: true});
		}
		if (!CheckDateTimeModifyFlag(GlobalObj.ModifyDateTimeAuthority,OrdDateIsCanCrossDay)){
		    $.extend(StyleConfigObj, { OrderDate:false});
		}else{
			$.extend(StyleConfigObj, { OrderDate: true});
		}
	}
    var OrderFreqTimeDoseStr=GetCellData(rowid, "OrderFreqTimeDoseStr");
    if (OrderFreqTimeDoseStr!="") {
	    $.extend(StyleConfigObj, { OrderDoseQty: "readonly"});
	}
    //�����༭
    EditRowCommon(rowid, StyleConfigObj.OrderName);
    InitRowLookUp(rowid);
    //4:�ı���ʽ
    ChangeRowStyle(rowid, StyleConfigObj);
    //5:�����б�����
    SetColumnList(rowid, "OrderPrior", OrderPriorStr);
    SetColumnList(rowid, "OrderDoseUOM", idoseqtystr);
    SetColumnList(rowid, "OrderRecDep", CurrentRecLocStr);
    SetColumnList(rowid, "OrderPackUOM", OrderPackUOMStr);
    SetColumnList(rowid, "OrderLabSpec", OrderLabSpecStr);
    //SetColumnList(rowid, "OrderInsurCat", OrderInsurCatHideen);
    SetColumnList(rowid, "OrderPilotPro", GlobalObj.PilotProStr);
    SetColumnList(rowid, "OrderDIACat", idiagnoscatstr);
    SetColumnList(rowid, "OrderOperation", OrderOperationStr);
    SetColumnList(rowid, "OrderInsurCat", InsurCatStr);
    
    SetColumnList(rowid, "OrderChronicDiag", OrderChronicDiagStr);
    
    if (DefaultOrderDIACat != "") {
        SetCellData(rowid, "OrderDIACat", DefaultOrderDIACatRowId);
        SetCellData(rowid, "OrderDIACatRowId", DefaultOrderDIACatRowId);
    }

    //6:������һ��ѡ��͹�������
    if (StyleConfigObj.OrderDoseUOM != undefined && StyleConfigObj.OrderDoseUOM != false && StyleConfigObj.OrderDoseUOM != true) {
        SetCellData(rowid, "OrderDoseUOM", OrderDoseUOM);
    } else if (StyleConfigObj.OrderDoseUOM == undefined || StyleConfigObj.OrderDoseUOM == true) {
        if (OrderDoseUOMRowid != "") {
            SetCellData(rowid, "OrderDoseUOM", OrderDoseUOMRowid);
            SetCellData(rowid, "OrderDoseUOMRowid", OrderDoseUOMRowid);
        } else {
            if (idoseqtystr != "") {
                var ArrData = idoseqtystr.split(String.fromCharCode(2));
                var ArrData1 = ArrData[0].split(String.fromCharCode(1));
                //DefaultDoseQty=ArrData1[0];
                var DefaultDoseQtyUOM = ArrData1[1];
                var DefaultDoseUOMRowid = ArrData1[2];
                SetCellData(rowid, "OrderDoseUOM", DefaultDoseUOMRowid);
                SetCellData(rowid, "OrderDoseUOMRowid", DefaultDoseUOMRowid);
            }
        }
    }
    SetCellData(rowid, "OrderPrior", OrderPriorRowid);
    SetCellData(rowid, "OrderPriorRowid", OrderPriorRowid);
    SetCellData(rowid, "OrderDoseQty", OrderDoseQty); //�ؽ�������λ�������ʱ�������Ĭ��ֵ ������Ҫ��ԭ 
    SetCellData(rowid, "OrderRecDepRowid", OrderRecDepRowid);  
    SetCellData(rowid, "OrderRecDep", OrderRecDepRowid);
    SetCellData(rowid, "OrderPrior", OrderPriorRowid);
    SetCellData(rowid, "OrderLabSpec", OrderLabSpecRowid);
    SetCellData(rowid, "OrderLabSpecRowid", OrderLabSpecRowid);
    SetCellData(rowid, "OrderBillType", OrderBillTypeRowid);
    SetCellData(rowid, "OrderPriorRemarks", OrderPriorRemarksRowId);
    SetCellData(rowid, "OrderPriorRemarksRowId", OrderPriorRemarksRowId);
    SetCellData(rowid, "OrderPackUOM", OrderPackUOMRowid); //Э�鵥λ
    SetCellData(rowid, "OrderInsurCat", OrderInsurCatRowId); //ҽ������
    SetCellData(rowid, "OrderInsurCatRowId", OrderInsurCatRowId);
    SetCellData(rowid, "OrderPilotPro", OrderPilotProRowid);
    SetCellData(rowid, "OrderOperation",OrderOperationCode);
    SetCellData(rowid, "OrderChronicDiag",OrderChronicDiagCode);
    
    GetCellData(rowid,"OrderHiddenPara",OrderHiddenPara);
    var OrderDocRowid=GetCellData(rowid, "OrderDocRowid");
    //��ҽ����
    SetColumnList(rowid,"OrderDoc",OrderDocStr);
    SetCellData(rowid, "OrderDoc", OrderDocRowid);
    SetCellData(rowid, "OrderDocRowid", OrderDocRowid);    
    //SetOrderPrior(rowid,OrderPriorRowid);//ҽ�����Ϳ���
    SetColumnList(rowid,"OrderLabSpecCollectionSite",OrderLabSpecCollectionSiteStr);
    SetCellData(rowid, "OrderLabSpecCollectionSiteRowid", OrderLabSpecCollectionSiteRowid);
    SetCellData(rowid, "OrderLabSpecCollectionSite", OrderLabSpecCollectionSiteRowid);  
    //����ĳЩ�ֶ�disable
    var RowDisableStr = GetCellData(rowid, "RowDisableStr");
    var RowDisableObj = {};
    if (RowDisableStr != "") {
        RowDisableObj = eval("(" + RowDisableStr + ")");
    }
    ChangeCellDisable(rowid, RowDisableObj);
    //Ƶ���Ƴ̹����¼�
    FreqDurChange(rowid);
    OrdDoseQtyBindClick(rowid);
    initItemInstrDiv(rowid);
    //���ݿ�ҽ��ʱ���÷�,�������ý��տ���
    var ARCIMRowId = GetCellData(rowid, "OrderARCIMRowid");
    if (ARCIMRowId !="") {
		if ((OrderPrescNo != "")||(Flag=="1")) { 
			var CalRecLocStrJson = GetReclocByOrdDate(rowid);
			var CalRecLocStrObj=eval("(" + CalRecLocStrJson + ")");
			if (CalRecLocStrObj.NotChangeRecLocStr =="N") {
				var OldOrderRecDepRowid=GetCellData(rowid, "OrderRecDepRowid");
				var newCurrentRecLocStr=CalRecLocStrObj.CurrentRecLocStr;
				SetColumnList(rowid, "OrderRecDep", newCurrentRecLocStr);
				SetCellData(rowid, "OrderRecLocStr", newCurrentRecLocStr);
				OrderRecDepChangeCom(rowid);
			}
		}
	}
    //֪ʶ��
    CheckLibPhaFunction("Q", rowid, "")
    XHZY_Click();
}
//��ȡ�������� ����д��ڱ༭״̬ �����õ��������ݰ�����ǩ
function GetGirdData() {
    //��������
    //Save_Order_row();
    var DataArry = new Array();
    var rowids = $('#Order_DataGrid').getDataIDs();
    for (var i = 0; i < rowids.length; i++) {
        //��ȡ�Ѿ����ҽ�� �Ϳհ���
        //if(CheckIsItem(rowids[i])==true){continue;}
        var OrderItemRowid = GetCellData(rowids[i], "OrderItemRowid");
        var OrderARCIMRowid = GetCellData(rowids[i], "OrderARCIMRowid");
		var OrderARCOSRowid = GetCellData(rowids[i], "OrderARCOSRowid");
        if (OrderItemRowid != "" || ((OrderARCIMRowid == "")&&(OrderARCOSRowid == ""))) { continue; }
        //������
        EndEditRow(rowids[i]);
        var curRowData = $("#Order_DataGrid").getRowData(rowids[i]);
        DataArry[DataArry.length] = curRowData;
    }
    return DataArry;
}

function GetScreenBillSum() {
    var Sum = 0;
    var rowids = GetAllRowId();
    for (var i = 0; i < rowids.length; i++) {
        if (CheckIsItem(rowids[i]) == true) { continue; }
        var OrderSum = GetCellData(rowids[i], "OrderSum");
        var OrderPriorRemarksRowId = GetCellData(rowids[i], "OrderPriorRemarksRowId");
        if ((OrderPriorRemarksRowId == "OM") || (OrderPriorRemarksRowId == "ZT")) { continue }
        if (OrderSum == "") { continue }
        Sum = parseFloat(Sum) + parseFloat(OrderSum);
    }
    Sum = Sum.toFixed(4);
    return Sum;
}
function GetScreenBillSumNew() {
    ///��ȡҽ��¼�����δ��˺������ҽ�����ܽ��
    var UnSavedSum = 0,SavedSum=0;
    var rowids = GetAllRowId();
    for (var i = 0; i < rowids.length; i++) {
        var OrderSum = GetCellData(rowids[i], "OrderSum");
        var OrderPriorRemarksRowId = GetCellData(rowids[i], "OrderPriorRemarksRowId");
        if ((OrderPriorRemarksRowId == "OM") || (OrderPriorRemarksRowId == "ZT")) { continue }
        if (OrderSum == "") { continue }
        if (CheckIsItem(rowids[i]) == true) { 
        	SavedSum = parseFloat(SavedSum) + parseFloat(OrderSum);
        }else{
	        UnSavedSum = parseFloat(UnSavedSum) + parseFloat(OrderSum);
	    }
    }
    UnSavedSum = fomatFloat(UnSavedSum,2); //UnSavedSum.toFixed(2);
    SavedSum = fomatFloat(SavedSum,2);//SavedSum.toFixed(2);
    return UnSavedSum+"^"+SavedSum;
}
//����ͳ������
function SetScreenSum() {
    var Sum = GetScreenBillSumNew();
    $("#ScreenBillSum").val(Sum.split("^")[0]); //δ����
	$("#SavedScreenBillSum").val(Sum.split("^")[1]); //������
}
//���һ�� �հ���  ����rowid
function Add_Order_row() {
	if ($("#Add_Order_btn").hasClass('l-btn-disabled')){
		return false;
	}
    var rowid = "";
    //ֻ�����һ�п��� 
    var records = $('#Order_DataGrid').getGridParam("records");
    if (records >= 1) {
        //var rowids=$('#Order_DataGrid').getDataIDs();
        //��ȡ��ǰ���һ��ID  GetPreRowId() �������� ���ص�ǰ��ID
        var prerowid = GetPreRowId();
        //���һ���Ƿ�������
        var OrderARCIMRowid = GetCellData(prerowid, "OrderARCIMRowid");
		//����ҽ����
		var OrderARCOSRowid = GetCellData(prerowid, "OrderARCOSRowid");
        //$.messager.alert("����",OrderARCIMRowid);
        if ((OrderARCIMRowid == "" || OrderARCIMRowid == null)&&(OrderARCOSRowid == "" || OrderARCOSRowid == null)) {
            //���ý���
            SetFocusCell(prerowid, "OrderName");
            return prerowid;
        }
    }
    /*
    if(records==0){
        //��ֹ���ҽ����δ�ɹ�
        RebuidRowId();
    }
    */
    rowid = GetNewrowid();
    if (rowid == "" || rowid == 0) { return; }
    //����Ĭ��ֵ     
    var DefaultData = GetDefaultData(rowid);
    DefaultData['id'] = rowid;
    $('#Order_DataGrid').addRowData(rowid, DefaultData);
    var OrdCateGoryRowId = GetCellData(prerowid, "OrdCateGoryRowId");
    var OrdCateGory = GetCellData(prerowid, "OrdCateGory");
    SetCellData(rowid, "OrdCateGoryRowId",OrdCateGoryRowId);
    SetCellData(rowid, "OrdCateGory",OrdCateGory);
    SetNewOrderClass(rowid);
    EditRowCommon(rowid);
    SetOrderPrior(rowid);
    InitRowLookUp(rowid);
    var RowStyleObj={};
    if (GlobalObj.CurrentDischargeStatus == "B") {
	    $.extend(RowStyleObj, {OrderStartDate:true,OrderDate:true});
		
	}else{
	    if (!CheckDateTimeModifyFlag(GlobalObj.ModifySttDateTimeAuthority,"")) {
		    $.extend(RowStyleObj, { OrderStartDate:false});
	    }
	    if (!CheckDateTimeModifyFlag(GlobalObj.ModifyDateTimeAuthority,"")) {
		    $.extend(RowStyleObj, { OrderDate:false});
	    } 
    }  
    if (GlobalObj.UserEMVirtualtLong!="1"){
		 $.extend(RowStyleObj, { OrderVirtualtLong:false});   
	}   
    ChangeRowStyle(rowid, RowStyleObj); 
    if ($("#NurseOrd").checkbox('getValue')) {
	    $("tr.jqgrow").css("background","#FFCCCC");
	}   
    //���ý���
    SetFocusCell(rowid, "OrderName")
    return rowid;
}

//��� �����ݵ�һ��  ����rowid
function Add_Order_row2(newDataObj) {
    var rowid = newDataObj["id"];
    $('#Order_DataGrid').addRowData(rowid, newDataObj);
    //
    var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
    if (OrderMasterSeqNo != "") {
        $("#" + OrderMasterSeqNo).find("td").addClass("OrderMasterM");
        $("#" + rowid).find("td").addClass("OrderMasterS");
    }
    SetNewOrderClass(rowid);
	if ($("#NurseOrd").checkbox('getValue')) {
	    $("tr.jqgrow").css("background","#FFCCCC");
	}
    return rowid;
}
//�����¿�ҽ�������������ʽ 
function SetNewOrderClass(rowid) {
    // setCell(rowid,colname, data, class, properties)
    if (CheckIsItem(rowid) == false) {
        $('#Order_DataGrid').setCell(rowid, "id", rowid, "NewOrder", "");
    }
}
//��ȡsession������ӵ����
function Add_Session_row(newDataObj) {
    //����session���� IDҪ��ԭΪ��һ��
    var rowid = newDataObj["id"];
    $('#Order_DataGrid').addRowData(rowid, newDataObj);
    var OrderName=GetCellData(rowid,"OrderName");
    var OrderHiddenPara=GetCellData(rowid, "OrderHiddenPara");
    var PHCDFCriticalFlag=OrderHiddenPara.split(String.fromCharCode(1))[17];
    if (PHCDFCriticalFlag=="Y"){
    	$('#Order_DataGrid').setCell(rowid,"OrderName",OrderName,"OrderCritical","");
    }
    SetNewOrderClass(rowid);
    return rowid;
}
//����Ĭ������
function GetDefaultData(rowid) {
    //���ٺ͵�λĬ��ֵ
    var OrderSpeedFlowRate = "";
    var OrderFlowRateUnit = "";
    var OrderFlowRateUnitRowId = ""
	var OrderPriorRowid = "";
	var OrderPriorStr = "";
    //Ĭ��ҽ������
    if ($('#PriorType').length>0){
    	var CurrOrderPrior = $('#PriorType').text();
	    if ((CurrOrderPrior.indexOf("��ʱ") != -1)||(GlobalObj.INAdmTypeLoc!="Y")) {
	        //ֻ����ʱ
	        OrderPriorRowid = GlobalObj.ShortOrderPriorRowid;
	        OrderPriorStr = GlobalObj.ShortOrderPriorRowid + ":" + "��ʱҽ��";
	    } else if (CurrOrderPrior.indexOf("����") != -1) {
	        //ֻ�г���  
	        OrderPriorRowid = GlobalObj.LongOrderPriorRowid;
	        OrderPriorStr = GlobalObj.LongOrderPriorRowid + ":" + "����ҽ��";
	    } else if (CurrOrderPrior.indexOf("��Ժ") != -1) {
	        //��Ժ��ҩ
	        OrderPriorRowid = GlobalObj.OutOrderPriorRowid;
	        OrderPriorStr = GlobalObj.OutOrderPriorRowid + ":" + "��Ժ��ҩ";
	    } else {
	        OrderPriorRowid = GlobalObj.DefaultOrderPriorRowid;
	        OrderPriorStr = GlobalObj.OrderPriorStr;
	    }
	}else{
		var DefaultOrderPrior=GetDefaultOrderPrior("");
		OrderPriorStr = mPiece(DefaultOrderPrior, "^", 1);
		OrderPriorRowid = mPiece(DefaultOrderPrior, "^", 0);
	}

    //��ȡ��һ��ID  ��Ϊ��ǰ�л�û����ӻ���ɾ�� ����ȡ��ǰ���һ��
    var prerowid = GetPreRowId(rowid);
    //$.messager.alert("����","prerowid:"+prerowid);
    //��ʼ����  OrderStartDate  2014-03-25 17:34:34
    var Currtime = GetCurr_time();
    var OrderStartDate = Currtime;
    var OrderEndDate = Currtime;
    //��ҽ������  OrderDate  2014-03-25 17:34:34
    var OrderDate = Currtime;
    //��ҽ����
    var OrderDoc = session['LOGON.USERNAME'];
    //¼����
    var OrderUserAdd = session['LOGON.USERNAME'];
    //��ҽ������
    var OrderUserDep = GlobalObj.CTLOC;
    //Ĭ�Ϸѱ�
    var OrderBillTypeRowid = "",
        OrderBillType = "";
    var PreOrderBillTypeRowid = GetCellData(prerowid, "OrderBillTypeRowid");
    var PreOrderBillType = GetCellData(prerowid, "OrderBillType");
    var response=$.cm({
		ClassName:"web.DHCDocOrderCommon",
		MethodName:"GetDefaultPrescriptType",
		dataType:"text",
		EpisodeID:GlobalObj.EpisodeID,
		PreBillTypeID:PreOrderBillTypeRowid,
		PreBillType:PreOrderBillType
	},false);
    response=response.replace(/(^\s*)|(\s*$)/g, '');
    var DefaultPrescriptType = response.split('^')[0];
    OrderBillTypeRowid = DefaultPrescriptType.split(':')[0];
    OrderBillType = DefaultPrescriptType.split(':')[1];
    var PreDIACatRowId = "";
    var PreOrderDIACat = "";
    var PreOrderOperationCode="";
    var PreOrderOperation="";
    //���ͷ�˵����Ѿ�����Ĭ�������б�ѡ����ٸ����н��в���
    var MenuOrderOperationCode=GetMenuPara("AnaestOperationID");
    //������һ�� ȡ��һ������
    //$.messager.alert("����",prerowid+"^"+rowid);
    if ($.isNumeric(prerowid) == true) {
        //OrderPriorRowid=GetCellData(prerowid,"OrderPriorRowid");
        //Ĭ������ǰһ����������
        PreOrderDIACat = GetCellData(prerowid, "OrderDIACat");
        PreDIACatRowId = GetCellData(prerowid, "OrderDIACatRowId");
        PreOrderOperationCode=GetCellData(prerowid,"OrderOperationCode");
        PreOrderOperation=GetCellData(prerowid,"OrderOperation");
    }
    if (MenuOrderOperationCode!=""){
		var PreOrderOperationCode="";
	    var PreOrderOperation="";
	}
    //��װ���ݶ���
    var DfaultData = {
        OrderPriorStr: OrderPriorStr,
        OrderPriorRowid: OrderPriorRowid,
        OrderPrior: OrderPriorRowid,
        OrderStartDate: OrderStartDate,
        //OrderDoc: OrderDoc,
        OrderUserAdd: OrderUserAdd,
        OrderUserDep: OrderUserDep,
        OrderDate: OrderDate,
        OrderBillType: OrderBillType,
        OrderBillTypeRowid: OrderBillTypeRowid,
        OrderDIACat: PreOrderDIACat,
        OrderDIACatRowId: PreDIACatRowId,
        OrderSpeedFlowRate: OrderSpeedFlowRate,
        OrderFlowRateUnit: OrderFlowRateUnit,
        OrderFlowRateUnitRowId: OrderFlowRateUnitRowId,
        OrderOperationCode:PreOrderOperationCode,
        OrderOperation:PreOrderOperation,
        OrderLogDep:GlobalObj.LogLocDesc
    };
    return DfaultData;
}

//����Session����
//document.body.onunload = DocumentUnloadHandler;
//window.onunload=DocumentUnloadHandler;
window.onbeforeunload = DocumentUnloadHandler;
function onBeforeCloseTab(){
	DocumentUnloadHandler();
	return true;
}
function DocumentUnloadHandler(e) {
    //CreateEND();
    //���ҽ������ɹ��Ͳ��ñ�����session��(����)
    //if (StoreUnSaveData!="1"){return}
    ClearSessionData();
	SetVerifiedOrder("");
    SaveSessionData();
    //��ʿ��¼ҽ��ˢ������Ҳ�ѡ�У�����Ѿ������Ĺ�ϵ
    try {
        var par_win = window.parent.parent.parent.left.RPbottom
        if (par_win) {
            par_win.ClearCheck();
            NurseAddMastOrde("^^^^^^", "");
        }
    } catch (e) {
    }
}
function SaveSessionData(){
	var SessionFieldName = "UserUnSaveData" + GlobalObj.EpisodeID;
    //δ��˵�ҽ��
    var GirdData = GetGirdData();
    //�����ַ���
    var UnsaveData = ""
    var UserID = session['LOGON.USERID'];
    var CTLocId = session['LOGON.CTLOCID'];
    var SaveCount = 0;
    for (var i = 0; i < GirdData.length; i++) {
        var oneData = JSON.stringify(GirdData[i]); //JSON.stringify
        if (UnsaveData == "") {
            UnsaveData = oneData;
        } else {
            UnsaveData = UnsaveData + "###" + oneData;
        }
        //����25����¼,��ֿ��洢
        if ((i + 1) % 5 == 0) {
            SaveCount = SaveCount + 1;
            var retDetail = cspRunServerMethod(GlobalObj.SetUserUnSaveDataMethod, GlobalObj.EpisodeID, UserID, CTLocId, SaveCount, UnsaveData);
            UnsaveData = "";
        }
    }
    if (UnsaveData != "") {
        SaveCount = SaveCount + 1;
        var retDetail = cspRunServerMethod(GlobalObj.SetUserUnSaveDataMethod, GlobalObj.EpisodeID, UserID, CTLocId, SaveCount, UnsaveData);
    }
}
//��ȡ��������  2014-04-22
function GetSessionData() {
    //��ȡsession���� 
    var FieldName = "UserUnSaveData" + GlobalObj.EpisodeID;
    //var UserUnSaveData=cspRunServerMethod(GlobalObj.GetSessionDataMethod,FieldName);
    var UserID = session['LOGON.USERID'];
    var CTLocId = session['LOGON.CTLOCID'];
    var UnSaveCount = cspRunServerMethod(GlobalObj.GetUserUnSaveCountMethod, GlobalObj.EpisodeID, UserID, CTLocId);
    //alert("UnSaveCount="+UnSaveCount)
    for (var i = 1; i <= parseInt(UnSaveCount); i++) {
        var UserUnSaveData = cspRunServerMethod(GlobalObj.GetUserUnSaveDataMethod, GlobalObj.EpisodeID, UserID, CTLocId, i);
        //$.messager.alert("����","UserUnSaveData:"+UserUnSaveData);
        if (UserUnSaveData == "") { continue; }
        if (UserUnSaveData.split('@').length == 2) {
            if (UserUnSaveData.split('@')[1] == "%CSP.CharacterStream") {
                $.messager.alert("����", "��һ��ҳ��δ��������ؼ�¼���������ֵ,�����Զ���ȡ.");
                continue;
            }
        }
        //alert("UserUnSaveData"+i+"="+UserUnSaveData)
        //δ��˵�ҽ�������Ž��д���,�����Ѿ���˵�ҽ�����������仯,���¹�����Ŵ���
        var ListOrderSeq = new Array();
        var prerowid = GetPreRowId();
        var Num=prerowid;
        var DataArry = UserUnSaveData.split("###");
        for (var j = 0; j < DataArry.length; j++) {
            var data = DataArry[j];
            var obj = {};
            if (data != "") {
                obj = eval("(" + data + ")");
            }
            var oldid=obj["id"];
            if (Num >= 1) {
                Num=parseInt(+Num) + 1;
            }else{
                Num=1;
            }
            ListOrderSeq[oldid]=Num;
        }
        for (var j = 0; j < DataArry.length; j++) {
            var data = DataArry[j];
            var obj = {};
            if (data != "") {
                obj = eval("(" + data + ")");
            }
            var OrderMasterSeqNo=obj["OrderMasterSeqNo"];
            var records = $('#Order_DataGrid').getGridParam("records");
            if (records >= 1) {
                //var rowids=$('#Order_DataGrid').getDataIDs();
                //��ȡ��ǰ���һ��ID  GetPreRowId() �������� ���ص�ǰ��ID
                var prerowid = GetPreRowId();
                obj["id"] = parseInt(prerowid) + 1
            } else {
                obj["id"] = 1
            }
            if (OrderMasterSeqNo!="") {
                var NewOrderMasterSeqNo=ListOrderSeq[OrderMasterSeqNo];
                if (NewOrderMasterSeqNo){
                    obj["OrderMasterSeqNo"]=NewOrderMasterSeqNo;
                }
            }
            var rowid = Add_Session_row(obj);
            //SetRowData(rowid,data,"");
        }
    }
    //$("#Order_DataGrid").trigger("reloadGrid"); 
}
//���session����
function ClearSessionData() {
    var UserID = session['LOGON.USERID'];
    var CTLocId = session['LOGON.CTLOCID'];
    var UnSaveCount = cspRunServerMethod(GlobalObj.GetUserUnSaveCountMethod, GlobalObj.EpisodeID, UserID, CTLocId);
    for (var i = 1; i <= parseInt(UnSaveCount); i++) {
        var ret = cspRunServerMethod(GlobalObj.SetUserUnSaveDataMethod, GlobalObj.EpisodeID, UserID, CTLocId, i, "");
    }
    //���������
    tkMakeServerCall("web.DHCDocOrderCommon","OrderEntryClearLock");
}
//���� ֹͣ�༭ 99999
function Save_Order_row() {
    var rowids = $('#Order_DataGrid').getDataIDs();
    for (var i = 0; i < rowids.length; i++) {
        //
        if (GetEditStatus(rowids[i]) == true) {
            EndEditRow(rowids[i]);
        }
    }
}
//ɾ������
function Delete_Order_row() {
	if ($("#Delete_Order_btn").hasClass('l-btn-disabled')){
		return false;
	}
    var IsExistVerifyFlag = false;
    var ids = $('#Order_DataGrid').jqGrid("getGridParam", "selarrrow");
    if (ids == null || ids.length == 0) {
        if (PageLogicObj.FocusRowIndex > 0) {
            //����н�����,��ֱ��ɾ��������
            if ($("#jqg_Order_DataGrid_" + PageLogicObj.FocusRowIndex).prop("checked") != true) {
                $("#Order_DataGrid").setSelection(PageLogicObj.FocusRowIndex, true);
            }
        }
    }
    var ids = $('#Order_DataGrid').jqGrid("getGridParam", "selarrrow");
    if (ids == null || ids.length == 0) {
        $.messager.alert("����", "��ѡ��Ҫɾ���ļ�¼");
        return;
    }
    var OrdItemRowStr = "";
    $.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ��ѡ�еļ�¼��', function(r){
		if (r){
		    // �˳�����;
		    var len = ids.length;
	        var DeleteCount = 0;
	        for (var i = 0; i < len; i++) {
	            //�����ҽ������ɾ��
	            if (CheckIsItem(ids[i - DeleteCount]) == false) {
	                //������ ɾ����ҽ�� ȥ����ҽ������
	                var AllIds = GetAllRowId();
	                if(PageLogicObj.StartMasterOrdSeq==AllIds[i]) PageLogicObj.StartMasterOrdSeq="";
	                for (var k = 0; k < AllIds.length; k++) {
	                    //���������
	                    if (CheckIsItem(AllIds[k]) == true) { continue; }
	                    var OrderMasterSeqNo = GetCellData(AllIds[k], "OrderMasterSeqNo");
	                    if (ids[i] == OrderMasterSeqNo) {
	                        SetCellData(AllIds[k], "OrderMasterSeqNo", "");
	                        $("#" + AllIds[k]).find("td").removeClass("OrderMasterS");
	                        var OrdSeqNo=GetCellData(AllIds[k], "id");
			                if (PageLogicObj.StartMasterOrdSeq==OrdSeqNo) {
				                PageLogicObj.StartMasterOrdSeq="";
				            }
	                    }
	                }
	                //������4
	                var OrdSeqNo=GetCellData(ids[i - DeleteCount], "id");
	                if (PageLogicObj.StartMasterOrdSeq==OrdSeqNo) {
		                PageLogicObj.StartMasterOrdSeq="";
		            }
	                DeleteAntReason(ids[i - DeleteCount]);
	                $('#Order_DataGrid').delRowData(ids[i - DeleteCount]);
	                DeleteCount = DeleteCount + 1;
	            } else {
	                IsExistVerifyFlag = true;
	            }
	        }
	        new Promise(function(resolve,rejected){
				if (IsExistVerifyFlag == true) {
					///ɾ����֮���ids�ᷢ���仯������Ҫ��д����һ����Ҫɾ����ҽ��
		            var len = ids.length;
		            for (var i = 0; i < len; i++) {
		                if (CheckIsItem(ids[i]) == true) {
		                    IsExistVerifyFlag = true;
		                    if (OrdItemRowStr == "") { OrdItemRowStr = ids[i] } else { OrdItemRowStr = OrdItemRowStr + "^" + ids[i] }
		                }
		            }
		            if (OrdItemRowStr != "") {
			            (function(callBackFun){
							new Promise(function(resolve,rejected){
								$.messager.confirm('ȷ�϶Ի���', "��������˵�ҽ��,�Ƿ�ȷ��ֹͣ?", function(r){
									if (r) {
										StopOrd(OrdItemRowStr.split("^"),resolve);
									}else{
										callBackFun();
									}
								});
							}).then(function(){
								ReloadGrid("StopOrd")
				                SaveOrderToEMR()
								callBackFun();
							});
							
						})(resolve);
			        }else{
				        resolve();
				    }
				}else{
					resolve();
				}
			}).then(function(){
				var records = $('#Order_DataGrid').getGridParam("records");
		        if (records == 0) {
		            $('#cb_Order_DataGrid').prop('checked', false);
		            Add_Order_row();
		        }
		        //ReloadGrid();���¼������� ���֮���Ѿ�����
		        SetScreenSum();
		        //��ʾ��Ϣ�ı�
		        OrderMsgChange();
			})
		}
	});
    return websys_cancel();
}
//���༭
function FormEditRow() {
    //�Ƿ�ɿ�ҽ���ж�
    //�ж����
    if ((GlobalObj.MRDiagnoseCount == 0)&&(GlobalObj.OrderLimit!=1)) {
        $.messager.alert("����",t['NO_DIAGNOSE']);
        return false;
    }
    var ids = $('#Order_DataGrid').jqGrid("getGridParam", "selarrrow");
    var rowids = $('#Order_DataGrid').getDataIDs();
    var Clen = ids.length;
    var Alen = rowids.length;
    var rowid = "";
    var newrowid = "";
    if (Clen == 1) {
        rowid = ids[0];
        //�ȱ�����
        EndEditRow(rowid);
    } else if (Alen >= 1 && Clen == 0) {
        //�жϵ�ǰ���һ���Ƿ�������
        var lastRowid = GetPreRowId();
        var lastARCIMRowid = GetCellData(lastRowid, "OrderARCIMRowid");
        if (lastARCIMRowid == "") {
            rowid = rowids[Alen - 1]; //lastRowid
            //�ȱ�����
            EndEditRow(rowid);
        } else {
            //���һ�� �༭��һ�� 
            rowid = Add_Order_row();
            EndEditRow(rowid);
            //rowid="new";
            //newrowid=GetNewrowid();
        }
    } else {
        $.messager.alert("����", "��ѡ����Ҫ�༭��");
        return;
    }
    //������Ƿ�ɱ༭
    if (CheckCanEdit(rowid) == false) { return false; }
    //$.messager.alert("����",rowid);
    //������
    $("#Order_DataGrid").jqGrid('editGridRow', rowid, {
        top: 5,
        left: 5,
        height: 480,
        width: 1000,
        dataheight: 410,
        datawidth: 990,
        editCaption: '�༭��',
        beforeShowForm: InitFormStyle(rowid),
        //afterShowForm:InitFormData(ids[0]), 
        //onInitializeForm:InitFormData(ids[0]),
        //modal:true,
        processing: false,
        reloadAfterSubmit: false,
        recreateForm: true,
        closeAfterEdit: true,
        closeOnEscape: true,
        onclickSubmit: GetFormData,
        addedrow: 'last',
        onClose: function() {
            var OrderARCIMRowid = GetCellData("", "OrderARCIMRowid");
            if (OrderARCIMRowid == "" || OrderARCIMRowid == undefined) {
                DeleteRow(rowid);
            } else {
                EditRow(rowid);
                SetScreenSum();
            }
        },
        drag: true,
        viewPagerButtons: false
    });
    //�������
    InitFormData(rowid);
    SetFocusCell("", "OrderName");
}

function GetFormData(e) {
    var OrderARCIMRowid = GetCellData("", "OrderARCIMRowid"); //200
    var idoseqtystr = GetCellData("", "idoseqtystr");
    var OrderName = GetCellData("", "OrderName");
    dhcsys_alert(OrderARCIMRowid + ":" + OrderName);
}
//���Ʊ���ʽ
function InitFormStyle(rowid) {
    //$.messager.alert("����","beforeShowForm");
    //1:��ȡ������ʽ����
    if ($.isNumeric(rowid) == true) {
        var StyleConfigStr = GetCellData(rowid, "StyleConfigStr");
        if (StyleConfigStr != "") {
            var StyleConfigObj = eval("(" + StyleConfigStr + ")");
            ChangeRowStyle(rowid, StyleConfigObj);
        }
    }
}
//���Ʊ��������
function InitFormData(rowid) {
    if ($.isNumeric(rowid) == false) { return; }
    // ���������ݲ��ɹ�  ��Ҫ��������ӵ���
    /*
    var OrderARCIMRowid=GetCellData(rowid,"OrderARCIMRowid");
    if(OrderARCIMRowid == "" || OrderARCIMRowid == undefined){return;}
    */
    //$.messager.alert("����","afterShowForm");
    //1:��ȡ������ʽ����
    var StyleConfigStr = GetCellData(rowid, "StyleConfigStr");
    var StyleConfigObj = {};
    if (StyleConfigStr != "") {
        StyleConfigObj = eval("(" + StyleConfigStr + ")");
    }
    ChangeRowStyle("undefined", StyleConfigObj);
    //����ֹ¼�����ҽ��  StyleConfigObj
    $("#OrderMasterSeqNo").attr('disabled', true);

    //�ؽ������� ���������� ����ֵ
    //2:ȡ���ݴ�
    //ҽ������
    var OrderPriorStr = GetCellData(rowid, "OrderPriorStr");
    //������λ
    var idoseqtystr = GetCellData(rowid, "idoseqtystr");
    //������λ 000000
    var OrderPackUOMStr = GetCellData(rowid, "OrderPackUOMStr");
    //���տ���
    var CurrentRecLocStr = GetCellData(rowid, "CurrentRecLocStr");
    //�걾
    var OrderLabSpecStr = GetCellData(rowid, "OrderLabSpecStr");
    //$.messager.alert("����",CurrentRecLocStr);
    //3:ȡ��һ��ѡ��ID�͹������� ��Ϊ�����б����ݻ���Ĭ��ѡ�� �����������б�����֮ǰȡֵ
    //var rowdata=GetRowData(rowid); //������� ��Ϊ�����û�б��� ��ȡ����ǩ
    //ҽ������
    var OrderPrior = GetCellData(rowid, "OrderPrior");
    var OrderPriorRowid = GetCellData(rowid, "OrderPriorRowid");
    //������λ
    var OrderDoseUOM = GetCellData(rowid, "OrderDoseUOM"); //��ʾֵ    
    var OrderDoseUOMRowid = GetCellData(rowid, "OrderDoseUOMRowid");
    var OrderDoseQty = GetCellData(rowid, "OrderDoseQty");
    //���տ���
    var OrderRecDepRowid = GetCellData(rowid, "OrderRecDepRowid");
    //var OrderPackUOM=GetCellData(rowid,"OrderPackUOM"); //��ʾֵ
    //������λ
    var OrderPackUOMRowid = GetCellData(rowid, "OrderPackUOMRowid");
    //�걾
    var OrderLabSpecRowid = GetCellData(rowid, "OrderLabSpecRowid");
    //�ѱ�
    var OrderBillTypeRowid = GetCellData(rowid, "OrderBillTypeRowid");
    var OrderPriorRemarksRowId = GetCellData(rowid, "OrderPriorRemarksRowId");

    //5:�����б�����
    SetColumnList("undefined", "OrderPrior", OrderPriorStr);
    SetColumnList("undefined", "OrderDoseUOM", idoseqtystr);
    SetColumnList("undefined", "OrderRecDep", CurrentRecLocStr);
    //SetColumnList(rowid,"OrderPackUOM",OrderPackUOMStr);
    SetColumnList("undefined", "OrderLabSpec", OrderLabSpecStr);

    //6:������һ��ѡ��͹�������
    if (StyleConfigObj.OrderDoseUOM != undefined && StyleConfigObj.OrderDoseUOM != false && StyleConfigObj.OrderDoseUOM != true) {
        SetCellData("undefined", "OrderDoseUOM", OrderDoseUOM);
    } else if (StyleConfigObj.OrderDoseUOM == undefined || StyleConfigObj.OrderDoseUOM == true) {
        SetCellData("undefined", "OrderDoseUOM", OrderDoseUOMRowid);
    }
    SetCellData("undefined", "OrderDoseQty", OrderDoseQty); //�ؽ�������λ�������ʱ�������Ĭ��ֵ ������Ҫ��ԭ 
    SetCellData("undefined", "OrderRecDep", OrderRecDepRowid);
    //SetCellData("undefined","OrderPrior",OrderPriorRowid);
    SetCellData("undefined", "OrderLabSpec", OrderLabSpecRowid);
    SetCellData("undefined", "OrderBillType", OrderBillTypeRowid);
    SetCellData("undefined", "OrderPriorRemarks", OrderPriorRemarksRowId);
    SetCellData(rowid, "OrderRecDepRowid", OrderRecDepRowid);
    //ҽ�����Ϳ���
    SetOrderPrior("undefined", OrderPriorRowid);

    //����ĳЩ�ֶ�disable
    var RowDisableStr = GetCellData(rowid, "RowDisableStr");
    var RowDisableObj = {};
    if (RowDisableStr != "") {
        RowDisableObj = eval("(" + RowDisableStr + ")");
    }
    ChangeCellDisable("undefined", RowDisableObj);
}
function CellDataPropertyChange(rowid, colname, olddata, newdata) {
    if (olddata == newdata) return false;
    if (colname == "OrderRecDep") {
        //����ֱ�ӵ���OrderRecDepchangehandler(),��Ϊ�ں����������е��ø�ֵOrderRecDep,�ᵼ����ѭ��;
        CheckCureItemConfig(rowid);
    }
    return true
}
function CheckPoisonUserReason_Update(rowid) {
    //var OrderAntibApplyRowid=GetCellData(Row,"OrderAntibApplyRowid")
    var OrderAntibApplyRowid = GetCellData(rowid, "OrderAntibApplyRowid");
    var UserReasonId = GetCellData(rowid, "UserReasonId");
    var ShowTabStr = GetCellData(rowid, "ShowTabStr");

    var OrderName = GetCellData(rowid, "OrderName");
    if ((ShowTabStr == "UserReason") && (UserReasonId == "")) {
        $.messager.alert("����",OrderName + "  ����дʹ��Ŀ��!","info",function(){
            SetFocusCell(rowid, "UserReason");
        })
        return false;
    }
    if (ShowTabStr == "Apply,UserReason") {
        if (UserReasonId == "") {
            $.messager.alert("����",OrderName + "  ����дʹ��Ŀ��!","info",function(){
	            SetFocusCell(rowid, "UserReason");
	        })
            return false;
        }
        if (OrderAntibApplyRowid == "") {
            $.messager.alert("����",OrderName + "  ����д�ǼǱ�!","info",function(){
	            SetFocusCell(rowid, "UserReason");
	        })
            return false;
        }
    }
    return true;
}
function CheckOrderStartDate(OrderStartDate, CurrDate) {
    if (CurrDate == "") return true;
    if (OrderStartDate == "") return true;
    if (GlobalObj.CurrentDischargeStatus == "B") {
        CurrDate = GlobalObj.DischargeDate
    }
    OrderStartDate = tkMakeServerCall("web.DHCPAAdmSheets", "ConvertDateFormat", OrderStartDate, PageLogicObj.defaultDataCache);
    CurrDate = tkMakeServerCall("web.DHCPAAdmSheets", "ConvertDateFormat", CurrDate, PageLogicObj.defaultDataCache);
    if (OrderStartDate < CurrDate) return false;
    return true;
}
//�����������ӱ�ע
function AddRemarkClickhandler(Row,CallBackFun) {
	new Promise(function(resolve,rejected){
    	if (Row < 1) {
	    	resolve(false);
	 	}else{
		 	var OEOrderNotes = GetCellData(Row, "OrderDepProcNote");
		 	var lnk="doc.ordnotes.hui.csp?FocusRowIndex=" + Row + "&OEOrderNotes=" + unescape(OEOrderNotes);
		 	websys_showModal({
				url:lnk,
				title:'��������ʹ������,����д��ע',
				width:410,height:300,
				closable:false,
				CallBackFunc:function(result){
					websys_showModal("close");
					result=unescape(result);
					if ((result == "") || (result == "undefined")||(result == null)) {
				        $.messager.alert("��ʾ", "����дҽ����ע!","info",function(){
					        resolve(false);
					    });
				    } else {
					    SetCellData(Row, "OrderDepProcNote", result);
				        resolve(true);
				    }
				}
			})
		}
	}).then(function(rtnvalue){
		CallBackFun(rtnvalue);
	})
}
function CheckOrderDoseLimit(Row) {
    var OrderName = GetCellData(Row, "OrderName");
    var OrderHiddenPara = GetCellData(Row, "OrderHiddenPara");
    var OrderDepProcNote = GetCellData(Row, "OrderDepProcNote");
    var OrderMaxDoseQty = mPiece(OrderHiddenPara, String.fromCharCode(1), 3);
    var OrderMaxDoseQtyPerDay = mPiece(OrderHiddenPara, String.fromCharCode(1), 4);
    var OrderLimitDays = mPiece(OrderHiddenPara, String.fromCharCode(1), 5);
    var OrderMaxDoseQtyPerOrder = mPiece(OrderHiddenPara, String.fromCharCode(1), 6);
    //$.messager.alert("����",OrderHiddenPara);
    //�ж�û�����ò����Ͳ����ߺ���Ĵ���
    if ((OrderMaxDoseQty == '') && (OrderMaxDoseQtyPerDay == '') && (OrderLimitDays == '') && (OrderMaxDoseQtyPerOrder == '')) return true;

    var DrugFormRowid = GetCellData(Row, "OrderDrugFormRowid");
    var OrderDoseQty = GetCellData(Row, "OrderDoseQty");
    var OrderDoseUOMRowid = GetCellData(Row, "OrderDoseUOMRowid");
    var freq = GetCellData(Row, "OrderFreqFactor");
    var dur = GetCellData(Row, "OrderDurFactor");
    var Interval = GetCellData(Row, "OrderFreqInterval");

    //ȡ���Ի�����λΪ��׼�ļ�����λ����
    if (GlobalObj.CalEqDoseMethod != '') {
        var BaseDoseQty = cspRunServerMethod(GlobalObj.CalEqDoseMethod, OrderDoseUOMRowid, DrugFormRowid, OrderDoseQty,"BaseUom");
        //$.messager.alert("����","OrderDoseUOMRowid:"+OrderDoseUOMRowid+" DrugFormRowid:"+DrugFormRowid+" OrderDoseQty:"+OrderDoseQty);
        //$.messager.alert("����","BaseDoseQty:"+BaseDoseQty+" OrderMaxDoseQty:"+OrderMaxDoseQty+" OrderMaxDoseQtyPerDay:"+OrderMaxDoseQtyPerDay+" OrderMaxDoseQtyPerOrder:"+OrderMaxDoseQtyPerOrder);
        if ((BaseDoseQty != '') && (BaseDoseQty != 0)) {
            var BaseUomDesc="";
            var idoseqtystr=GetCellData(Row, "idoseqtystr");
            var ArrData = idoseqtystr.split(String.fromCharCode(2));
            if (ArrData.length > 0) {
                var ArrData1 = ArrData[ArrData.length-1].split(String.fromCharCode(1));
                BaseUomDesc = ArrData1[1];
            }
            if ((OrderMaxDoseQty != '') && (OrderMaxDoseQty != 0)) {
                if (parseFloat(BaseDoseQty) > parseFloat(OrderMaxDoseQty)) {
                    $.messager.alert("����",OrderName+t['ExceedPHDoseQtyLimit']+":"+OrderMaxDoseQty+BaseUomDesc,"info",function(){
	                    SetFocusCell(Row, "OrderDoseQty");
	                });
                    return false;
                }
            }
            if ((OrderMaxDoseQtyPerDay != '') && (OrderMaxDoseQtyPerDay != 0)) {
                var BaseDoseQtyPerDay = parseFloat(BaseDoseQty) * parseFloat(freq);
                if ((parseFloat(BaseDoseQtyPerDay) > parseFloat(OrderMaxDoseQtyPerDay))) {
                    $.messager.alert("����",OrderName+t['ExceedPHDoseQtyPerDayLimit']+":"+OrderMaxDoseQtyPerDay+BaseUomDesc,"info",function(){
	                    SetFocusCell(Row, "OrderFreq");
	                });
                    return false;
                }
            }
            if ((OrderMaxDoseQtyPerOrder != '') && (OrderMaxDoseQtyPerOrder != 0)) {
                var BaseDoseQtyPerOrder = parseFloat(BaseDoseQty) * parseFloat(freq) * parseFloat(dur);
                if ((parseFloat(BaseDoseQtyPerOrder) > parseFloat(OrderMaxDoseQtyPerOrder))) {
                    $.messager.alert("����",t['ExceedPHDoseQtyPerOrderLimit'],"info",function(){
	                     SetFocusCell(Row, "OrderDur");
	                });
                    return false;
                }
            }
        }
        if ((OrderLimitDays != '') && (OrderLimitDays != 0)) {
            if ((parseFloat(dur) > parseFloat(OrderLimitDays)) && (OrderDepProcNote == '')) {
                AddRemarkClickhandler(Row);
                //dhcsys_alert(t['ExceedPHDurationLimit']);
                //SetFocusCell(Row, "OrderDepProcNote");
                //return false;
            }
        }
    }
    return true;
    if ((Interval != "") && (Interval != null)) {
        var convert = Number(dur) / Number(Interval)
        var fact = (Number(dur)) % (Number(Interval));
        if (fact > 0) { fact = 1; } else { fact = 0; }
        dur = Math.floor(convert) + fact;
    }
    var NumTimes = parseFloat(freq) * parseFloat(dur);
}
function CheckDrug_Update(Row) {
    //���ý���λ��:SetFocusCell(rowid,colname)
    //��Ԫ��ȡֵ��GetCellData(rowid, colname)//idΪ����ȡ���Ԫ��ֵ ����ȡ ��
    //��Ԫ��ֵ��SetCellData(rowid,colname,data) //����combo data ��value
    var OrderName = GetCellData(Row, "OrderName");
    var OrderMasterSeqNo = GetCellData(Row, "OrderMasterSeqNo");
    var OrderSeqNo = GetCellData(Row, "id");
    var OrderInstrRowid = GetCellData(Row, "OrderInstrRowid");
    var OrderDoseQty = GetCellData(Row, "OrderDoseQty");
    var OrderFreqRowid = GetCellData(Row, "OrderFreqRowid");
    var OrderFreq = GetCellData(Row, "OrderFreq");
    var OrderDoseUOMRowid = GetCellData(Row, "OrderDoseUOMRowid");
    var OrderDoseUOM = GetCellData(Row, "OrderDoseUOM");
    var OrderDurRowid = GetCellData(Row, "OrderDurRowid");
    var OrderDur = GetCellData(Row, "OrderDur");
    var OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
    var OrderInstrRowid = GetCellData(Row, "OrderInstrRowid");
    var OrderInstr = GetCellData(Row, "OrderInstr");
    var OrderPackQty = GetCellData(Row, "OrderPackQty");
    var OrderPHForm = GetCellData(Row, "OrderPHForm");
    var PHPrescType = GetCellData(Row, "OrderPHPrescType");
    var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
    var OrderBillTypeRowid = GetCellData(Row, "OrderBillTypeRowid");
    var OrderType = GetCellData(Row, "OrderType");
    var OrderRecDepRowid = GetCellData(Row, "OrderRecDepRowid");
    var OrderUsableDays = GetCellData(Row, "OrderUsableDays");
    var OrderFirstDayTimes = GetCellData(Row, "OrderFirstDayTimes");
    var OrderPriorDesc = GetCellData(Row, "OrderPrior")

    var CNOrderDur = "";
    var OrderInstrGroupArr = new Array();
    if (OrderMasterSeqNo != "") {
        if (OrderMasterSeqNo == OrderSeqNo) {
            SetCellData(Row, "OrderMasterSeqNo", "");
        } else {
            var ret = CheckMasterSeqNo(OrderMasterSeqNo);
            if (!ret) {
                $.messager.alert("����",OrderName + t['Err_SeqNo'],"info",function(){
	                SetFocusCell(Row, "OrderMasterSeqNo");
	            });
                //EditRow(Row);
                return false;
            }
        }
    }
    var CheckWYInstr = IsWYInstr(OrderInstrRowid);
    if (((OrderDoseQty == '') || (parseFloat(OrderDoseQty) == 0) || (isNumber(OrderDoseQty) == false)) && (!CheckWYInstr)) {
        $.messager.alert("����",OrderName + t['NO_DoseQty'],"info",function(){
	        SetFocusCell(Row, "OrderDoseQty");
	    });
        //EditRow(Row);
        return false;
    }
	if((parseFloat(OrderDoseQty) < 0) && (!CheckWYInstr)) {
        $.messager.alert("����",OrderName + "��������Ϊ����!","info",function(){
	        SetFocusCell(Row, "OrderDoseQty");
	    });
        //EditRow(Row);
        return false;
    }
    //$.messager.alert("����","001");
    if ((OrderFreqRowid == '') || (OrderFreq == "")) {
        //EditRow(Row);
        $.messager.alert("��ʾ��Ϣ", OrderName + t['NO_Frequence'], "warning", function() { SetFocusCell(Row, "OrderFreq"); });
            
        return false;
    }

    if (((OrderDoseUOMRowid == '') || (OrderDoseUOM == "")) && (!CheckWYInstr)) {
        //EditRow(Row);
        $.messager.alert("��ʾ��Ϣ", OrderName + t['NO_DoseUOM'], "warning", function() { SetFocusCell(Row, "OrderDoseUOM"); });
          
        return false;
    }
    if (((OrderDurRowid == '') || (OrderDur == '')) && (!CheckWYInstr) && (OrderPriorRowid != GlobalObj.LongOrderPriorRowid)) {
        //EditRow(Row);
        $.messager.alert("��ʾ��Ϣ", OrderName + t['NO_Duration'], "warning", function() { SetFocusCell(Row, "OrderDur"); });
         
        return false;
    }
    if ((OrderInstrRowid == '') || (OrderInstrRowid == '')) {
        //EditRow(Row);
        $.messager.alert("��ʾ��Ϣ", OrderName + t['NO_Instr'], "warning", function() { SetFocusCell(Row, "OrderInstr"); });
         
        return false;
    }

    //�ж�ҩƷ����
    if (CheckOrderDoseLimit(Row) == false) {
        return false;
    }
    if (GlobalObj.PAAdmType != "I") {
		//���÷��ִ���
		if (GlobalObj.PrescByInstr == 1) {
			var InstrGroupCode = cspRunServerMethod(GlobalObj.GetInstrGroupCodeMethod, OrderInstrRowid);
			if (InstrGroupCode != "") {
				var PrescName = PHPrescType + '^' + OrderBillTypeRowid + '^' + InstrGroupCode + "^" + OrderInstr;
				var FindPresc = false;
				for (var j = 0; j <= OrderInstrGroupArr.length - 1; j++) {
					var TempName = mPiece(OrderInstrGroupArr[j], "!", 0)
					if (TempName == PrescName) {
						PrescCount = eval(mPiece(OrderInstrGroupArr[j], "!", 1)) + 1
						OrderInstrGroupArr[j] = PrescName + "!" + PrescCount;
						FindPresc = true;
					}
				}
				if (!FindPresc) {
					OrderInstrGroupArr[OrderInstrGroupArr.length] = PrescName + "!" + 1;
				}
			}
		}
		if (OrderType == "R") {
			var InsurFlag = cspRunServerMethod(GlobalObj.GetInsurFlagMethod, OrderBillTypeRowid, GlobalObj.PAAdmType);
			if (OrderUsableDays == "") OrderUsableDays = 0;
			if ((InsurFlag == 1) && (parseFloat(OrderUsableDays) > 200)) {
				$.messager.alert("��ʾ��Ϣ", OrderName + t['InsurOPUsableDaysLimit'], "warning", function() { SetFocusCell(Row, "OrderName"); });
	 
				return false;
			}
		}
    }
    return { OrderInstrGroupArr: OrderInstrGroupArr };
}

function CheckMasterSeqNo(MasterSeqNo) {
    try {
        /*//09-04-17 ������ �ĳ���Ӻ�ɾ��ƴ��CheckMasterNoStr���ӿ�����ٶ�
        var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
        var rows=objtbl.rows.length;
        for (var i=1; i<rows; i++){
            var Row=GetRow(i);
            var OrderName=GetCellData("OrderName",Row);
            var OrderItemRowid=GetCellData("OrderItemRowid",Row);
            var OrderARCIMRowid=GetCellData("OrderARCIMRowid",Row);
        var OrderSeqNo=GetCellData("OrderSeqNo",Row);
            if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
                if (OrderSeqNo==MasterSeqNo){return true}
            }
        }
        var MasterSeqNo="!"+MasterSeqNo+"!";
        if (CheckMasterNoStr.indexOf(MasterSeqNo)!=-1) return true;
    */
    } catch (e) { $.messager.alert("����", e.message); }
    return true;
}

function CheckNotDrug_Update(Row) {
    var OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
    var OrderName = GetCellData(Row, "OrderName");
    if ((OrderPriorRowid == GlobalObj.OMOrderPriorRowid) || (OrderPriorRowid == GlobalObj.OMSOrderPriorRowid)) {
        $.messager.alert("��ʾ��Ϣ", OrderName + t['OMOrderPriorNotAllow'], "warning", function() { SetFocusCell(Row, "OrderName"); });
          
        return false;
    }
    //�Զ���ҽ��
    var OrderType = GetCellData(Row, "OrderType");
    if (OrderType == "P") {
        var OrderPrice = GetCellData(Row, "OrderPrice");
        OrderPrice = $.trim(OrderPrice);
        if (OrderPrice == '') {
            EditRow(Row);
            $.messager.alert("��ʾ��Ϣ", OrderName + t['NO_OrderPrice'], "warning", function() { SetFocusCell(Row, "OrderPrice"); });
            var StyleConfigObj = { OrderPrice: true };
            ChangeRowStyle(Row, StyleConfigObj)
            PageLogicObj.FocusRowIndex = Row;
            return false;
        } else {
            if ((!isNumber(OrderPrice)) || (parseFloat(OrderPrice) == 0)) {
                $.messager.alert("��ʾ��Ϣ", "�Զ���۸��ҽ����" + OrderName + "���۸�����Ч����", "warning", function() { SetFocusCell(Row, "OrderPrice"); });
        
                PageLogicObj.FocusRowIndex = Row;
                return false;
            }
        }
    }
    //����ҽ��
    if (OrderType == "L") {
        var OrderLabSpecRowid = GetCellData(Row, "OrderLabSpecRowid");
        if (OrderLabSpecRowid == '') {
            $.messager.alert("����",OrderName + t['NeedLabSpec'],"info",function(){
	            SetFocusCell(Row, "OrderLabSpec");
	        });
            //$.messager.alert("��ʾ��Ϣ", OrderName + t['NeedLabSpec'], "warning", function() { SetFocusCell(Row, "OrderLabSpec"); });
            return false;
        }
    }
	var OrderDoseQty=GetCellData(Row, "OrderDoseQty");
	if ((OrderDoseQty != '')&&(isNumber(OrderDoseQty) == false))  {
        $.messager.alert("����",OrderName + t['NO_DoseQty'],"info",function(){
	         SetFocusCell(Row, "OrderDoseQty");
	    });
        //EditRow(Row);
       
        return false;
    }
    if ((OrderDoseQty!="")&&(parseFloat(OrderDoseQty) < 0) ) {
        $.messager.alert("����",OrderName + "��������Ϊ����!","info",function(){
	        SetFocusCell(Row, "OrderDoseQty");
	    });
        //EditRow(Row);
        return false;
    }
    return true;
}
function CheckKSS_Update(Row) {
    var OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
    var OrderPoisonCode = GetCellData(Row, "OrderPoisonCode");
    var OrderAntibApplyRowid = GetCellData(Row, "OrderAntibApplyRowid");

    if ((OrderPriorRowid == GlobalObj.ShortOrderPriorRowid) && (OrderPoisonCode.indexOf("KSS") > -1)) {
        //��һ�����������뵥Ϊδ��˸�����ʾ��
        if ((OrderAntibApplyRowid != "") && (OrderAntibApplyRowid != "undefined")) {
            var AppStatusFlag = tkMakeServerCall("web.DHCDocAntiCommon", "GetAntibioSta", OrderAntibApplyRowid)
            if (AppStatusFlag == 0) {
                $.messager.alert("����", "���ϼ�ҽʦ24Сʱ�����", "warning", function() { SetFocusCell(Row, "OrderName"); });
            }
        }
    }
    return true;
}
//******************** �������ݴ���ĺ���  �ź��� *****************//
//�����༭  ���ݼ��
//�˴�Ϊҽ�����ʱ�ļ��,��Ҫ�����¼������л���ʱ�仯,��¼���޷���ص�һЩ���
function CheckBeforeUpdate() {
    //֪ʶ��
    var RtnStr = CheckLibPhaFunction("C", "", "Y")
    if (!RtnStr) { return false }
    return true;
}
//����ҩ��������ҩ������������QP
function CheckBeforeSaveToAnti(callBackFun) {
    var rowids = $('#Order_DataGrid').getDataIDs();
    new Promise(function(resolve,rejected){
		//����ҩ�����ÿ���
    	var combinedFlag=tkMakeServerCall("DHCAnt.Base.MainConfigExcute", "GetValueByMCGCode", "SCKJ", session['LOGON.HOSPID']);
    	if (combinedFlag=="1") {
	    	CheckAntCombined(rowids,resolve)
	    }else{
		    resolve(true);
		}
	}).then(function(rtn){
		if (!rtn) {
			callBackFun(false);
		}else{
			//����Խ��ʹ����Ϣ��ʾ QP 20170814
	    	DHCANT.sendEmergencyMsg(rowids);
	    	//����Խ����ʾ���
		    var rowsLength = rowids.length;
		    for (var i = 0; i < rowsLength; i++) {
		        CheckKSS_Update(rowids[i]);
		    }
			callBackFun(true);
		}
	})
}
//�ٴ�·����飬·����ҽ����д����
function CPWCheck(callBackFun) {
	new Promise(function(resolve,rejected){
		if (GlobalObj.SupplementMode==1){
		    resolve(true);
		}else{
			var EpisodeID = GlobalObj.EpisodeID;
		    var ArcimIDs = "";
		    var rowids = $('#Order_DataGrid').getDataIDs();
		    for (var i = 0; i < rowids.length; i++) {
		        var OrderARCIMRowid = GetCellData(rowids[i], "OrderARCIMRowid");
		        ArcimIDs = ArcimIDs + OrderARCIMRowid + "^";
		    }
		    if (!ArcimIDs) {
			    resolve(true);
			}else{
				checkOrdItemToVar(EpisodeID,ArcimIDs,resolve);
			}
		}
	}).then(function(SuccessFlag){
		callBackFun(SuccessFlag);
	})
}
//��ѯҽ��  
var ItemzLookupGrid;
var OrderNameAuto;
function xItem_lookuphandler(e) {
	return false;
}
//Ƶ�β�ѯ
var ShowFreqLookup = 0;
function PHCFRDesc_lookuphandler(e) {
    var obj = websys_getSrcElement(e);
    var key = websys_getKey(e);
    var type = websys_getType(e);
    if (key != 13 && type != 'dblclick') {
        return;
    }
    var rowid = "";
    if (obj.id.indexOf("_") > 0) {
        rowid = obj.id.split("_")[0];
    }
    var OrderPriorRowid=GetCellData(rowid, "OrderPriorRowid");
    var OrderPriorRemarks = GetCellData(rowid, "OrderPriorRemarksRowId");
    if (OrderPriorRemarks=="ONE") {OrderPriorRowid="4"}
	return false;
}
//Ƶ��ѡ��
function FrequencyLookUpSelect(value,rowid,callBackFun) {
	var type = "";
	if (window.event) type = websys_getType(window.event);
	if (typeof rowid=="undefined"){
		rowid = "";
	}
    if (rowid==""){
	    if (this.id.indexOf("_") > 0) {
	        rowid = this.id.split("_")[0];
	    }
	}
    var Id = "";
    if ($.isNumeric(rowid) == true) {
        Id = rowid + '_OrderFreq';
    } else {
        Id = 'OrderFreq';
    }
    $("#"+Id).removeClass("clsInvalid");
    var Split_Value = value.split("^");
    var OrderFreq = Split_Value[0];
    var OrderFreqFactor = Split_Value[2];
    var OrderFreqInterval = Split_Value[3];
    var OrderFreqRowid = Split_Value[4];
    var OrderFreqDispTimeStr = Split_Value[5];
    var WeekFlag = Split_Value[6];
    var NoDelayExe = Split_Value[7];
    var FreeTimeFreqFlag = Split_Value[8];
    var OrderPriorRowid = GetCellData(rowid, "OrderPriorRowid");
    var OldPriorRowid = OrderPriorRowid
    //ԭ��� ����ID
    var OrderSeqNo = GetCellData(rowid, "id");
    SetCellData(rowid, "OrderFreq", OrderFreq);
    SetCellData(rowid, "OrderFreqFactor", OrderFreqFactor);
    SetCellData(rowid, "OrderFreqInterval", OrderFreqInterval);
    SetCellData(rowid, "OrderFreqRowid", OrderFreqRowid);
    SetCellData(rowid, "OrderNurseExecLinkDispTimeStr", "");
    var DurChangeFlag=0;
    DHCDocUseCount(OrderFreqRowid, "User.PHCFreq");
    var OrderName=GetCellData(rowid, "OrderName");
    var LinkedMasterOrderRowid=GetCellData(rowid, "LinkedMasterOrderRowid");
    if (LinkedMasterOrderRowid) {
	    var oneItem = cspRunServerMethod(GlobalObj.GetVerifiedOrder, LinkedMasterOrderRowid);
	    var VerifiedOrderArr = oneItem.split("^");
		var OrderItemVerifiedObj=GetVerifiedOrderObjObj(VerifiedOrderArr);
	}
	var MasterOrderPriorRowid="",MasterOrderPrior="";
    new Promise(function(resolve,rejected){
	    var OrderFreqDispTimeStr="",FreqWeekDesc="";
	    if (WeekFlag=="Y"){
		    (function(callBackFunExec){
			    new Promise(function(resolve,rejected){
					GetOrderFreqWeekStr(OrderFreqRowid,OrderFreqDispTimeStr,OrderName,resolve);
				}).then(function(OrderFreqWeekInfo){
					var OrderFreqDispTimeStr=mPiece(OrderFreqWeekInfo, "^", 0);
					if (OrderFreqDispTimeStr==""){
						ClearOrderFreq(rowid);
			            $.messager.alert("��ʾ","��Ƶ�������ѡ��ʹ������!");
			            return;
					}
					var OrderFreqWeekDesc=mPiece(OrderFreqWeekInfo, "^", 1);
					var CalOrderStartDateStr=mPiece(OrderFreqWeekInfo, "^", 2);
					SetCellData(rowid, "OrderFreqDispTimeStr", OrderFreqDispTimeStr);
					OrderFreq=OrderFreq+" "+OrderFreqWeekDesc;
					SetCellData(rowid,"OrderFreq",OrderFreq)
					SetCellData(rowid,"OrderStartDate",CalOrderStartDateStr);
					callBackFunExec();
				})
			})(resolve);
		}else if (FreeTimeFreqFlag=="Y"){
			(function(callBackFunExec){
				//������ַ�ʱ��
			    new Promise(function(resolve,rejected){
					GetOrderFreqFreeTimeStr(OrderFreqRowid,OrderFreqDispTimeStr,OrderName,resolve,OrderItemVerifiedObj);
				}).then(function(OrderFreqFreeTimeInfo){
					var OrderFreqDispTimeStr=mPiece(OrderFreqFreeTimeInfo, "^", 0);
					if (OrderFreqDispTimeStr==""){
						ClearOrderFreq(rowid);
			            $.messager.alert("��ʾ","������ַ�ʱ��Ƶ�������ѡ��ַ�ʱ��!");
			            return;
					}
					var OrderFreqFactor=OrderFreqDispTimeStr.split(String.fromCharCode(1)).length;
					var OrderFreqWeekDesc=mPiece(OrderFreqFreeTimeInfo, "^", 1);
					SetCellData(rowid, "OrderFreqDispTimeStr", OrderFreqDispTimeStr);
					OrderFreq=OrderFreq+" "+OrderFreqWeekDesc;
					SetCellData(rowid,"OrderFreq",OrderFreq);
					SetCellData(rowid, "OrderFreqFactor", OrderFreqFactor);
					callBackFunExec();
				})
			})(resolve);
		}else{
			SetCellData(rowid, "OrderFreqDispTimeStr", OrderFreqDispTimeStr);
			resolve();
		}
    }).then(function(){
	    return new Promise(function(resolve,rejected){
		    if((OrderItemVerifiedObj)&&(OrderItemVerifiedObj.LinkedMasterOrderFreFactor>1)&&(OrderFreqRowid!="")){
			    (function(callBackFunExec){
					//��ʿ��¼ҽ��������ҽ���ַ�ʱ��
				    new Promise(function(resolve,rejected){
					    var OrderFreqFactor=GetCellData(rowid, "OrderFreqFactor");
					    var OrderFreqDispTimeStr=GetCellData(rowid, "OrderFreqDispTimeStr");
					    if (OrderFreqFactor > OrderItemVerifiedObj.LinkedMasterOrderFreFactor) {
						    ClearOrderFreq(rowid);
				            $.messager.alert("��ʾ","��¼ҽ��Ƶ�ηַ����� "+OrderFreqFactor+" ���ܴ�����ҽ��Ƶ�ηַ�������"+OrderItemVerifiedObj.LinkedMasterOrderFreFactor+" !");
				            return;
						}else if(OrderFreqFactor == OrderItemVerifiedObj.LinkedMasterOrderFreFactor){
							if (OrderItemVerifiedObj.LinkedMasterOrderFreqDispTimeStr) {
								var OrderNurseExecLinkDispTimeInfo=CalOrderFreqExpInfo(OrderItemVerifiedObj.LinkedMasterOrderFreqDispTimeStr);
								OrderNurseExecLinkDispTimeInfo=mPiece(OrderNurseExecLinkDispTimeInfo, "^", 1);
							}else{
								var OrderNurseExecLinkDispTimeInfo=tkMakeServerCall("web.DHCDocOrderCommon","GetIPFreqDispTimeStr",OrderItemVerifiedObj.LinkedMasterOrderFreRowId) 
								OrderNurseExecLinkDispTimeInfo=OrderNurseExecLinkDispTimeInfo.replace(/,/g, "|")
							}
							OrderNurseExecLinkDispTimeInfo=tkMakeServerCall("web.DHCOEOrdItem", "FormFreqFreeTimeHtmlToLogical",OrderNurseExecLinkDispTimeInfo);
							resolve(OrderNurseExecLinkDispTimeInfo);
						}else{
							var OrderNurseLinkOrderRowid = GetCellData(rowid, "LinkedMasterOrderRowid");
					    	GetOrderNurseExecLinkDispTimeStr(OrderName,OrderFreqRowid,OrderFreqDispTimeStr,OrderNurseLinkOrderRowid,resolve)
						}
					}).then(function(OrderNurseExecLinkDispTimeInfo){
						if (OrderNurseExecLinkDispTimeInfo==""){
							ClearOrderFreq(rowid);
				            $.messager.alert("��ʾ","��¼ҽ��Ƶ�κ���ҽ����һ�������ѡ������ַ�ʱ��!");
				            return;
						}
						var OrderNurseExecLinkDispTimeStr=mPiece(OrderNurseExecLinkDispTimeInfo, "^", 0);
						SetCellData(rowid,"OrderNurseExecLinkDispTimeStr",OrderNurseExecLinkDispTimeStr);
						callBackFunExec();
					})
				})(resolve);
			}else{
				resolve();
			}
		})
	}).then(function(){
	    return new Promise(function(resolve,rejected){
			ChangeOrderFreqTimeDoseStr(rowid,resolve);
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
		    var OrderPriorRemarks = GetCellData(rowid, "OrderPriorRemarksRowId");
		    if ((GlobalObj.PAAdmType == "I") && (OrderPriorRowid != GlobalObj.OutOrderPriorRowid)&&(OrderPriorRemarks!="ONE")) {
		        if ((OrderFreqRowid == GlobalObj.STFreqRowid) || (OrderFreqRowid == GlobalObj.ONCEFreqRowid)) {
		            //�жϵ�ǰ���Կ�ҽ��
		            var check = CheckNowOrderPrior(rowid, GlobalObj.ShortOrderPriorRowid);
		            if (check == true) {
		                SetCellData(rowid, "OrderPrior", GlobalObj.ShortOrderPriorRowid);
		                SetCellData(rowid, "OrderPriorRowid", GlobalObj.ShortOrderPriorRowid);
		                MasterOrderPriorRowid = GlobalObj.ShortOrderPriorRowid;
		                MasterOrderPrior = "��ʱҽ��";
		            } else {
		                ClearOrderFreq(rowid)
		                $.messager.alert("��ʾ","��ǰҽ�����Ͳ�����ı�Ƶ��Ϊ" + OrderFreq);
		                return;
		            }

		        } else {
		            var check = CheckNowOrderPrior(rowid, GlobalObj.LongOrderPriorRowid);
		            if (check == true) {
		                SetCellData(rowid, "OrderPrior", GlobalObj.LongOrderPriorRowid);
		                SetCellData(rowid, "OrderPriorRowid", GlobalObj.LongOrderPriorRowid);
		                MasterOrderPriorRowid = GlobalObj.LongOrderPriorRowid;
		                MasterOrderPrior = "����ҽ��";
		            } else {
		                ClearOrderFreq(rowid);
						$.messager.alert("��ʾ","��ǰҽ�����Ͳ�����ı�Ƶ��Ϊ" + OrderFreq)
		                return;
		            }
		        }
		    }

		    if ((OrderPriorRowid == GlobalObj.OMSOrderPriorRowid) && (OrderFreqRowid == GlobalObj.STFreqRowid)) {
		        var check = CheckNowOrderPrior(rowid, GlobalObj.OMOrderPriorRowid);
		        if (check == true) {
		            SetCellData(rowid, "OrderPrior", GlobalObj.OMOrderPriorRowid);
		            SetCellData(rowid, "OrderPriorRowid", GlobalObj.OMOrderPriorRowid);
		            MasterOrderPriorRowid = GlobalObj.OMOrderPriorRowid;
		            MasterOrderPrior = "��ʱҽ��";
		        } else {
		            ClearOrderFreq(rowid);
		            $.messager.alert("��ʾ","��ǰҽ�����Ͳ�����ı�Ƶ��Ϊ" + OrderFreq);
		            return;
		        }
		    }

		    if ((GlobalObj.PAAdmType == "I") && (OrderFreqRowid != GlobalObj.STFreqRowid)) {
		        //����ҽ��ֻ��ST���÷�?A��ST�͸ĳ���ʱҽ��?A��Ϊ�ڼƷ�ʱ����ҽ��ֻ��һ��
		        if (OrderPriorRowid == GlobalObj.STATOrderPriorRowid) {
		            var check = CheckNowOrderPrior(rowid, GlobalObj.ShortOrderPriorRowid);
		            if (check == true) {
		                SetCellData(rowid, "OrderPrior", GlobalObj.ShortOrderPriorRowid);
		                SetCellData(rowid, "OrderPriorRowid", GlobalObj.ShortOrderPriorRowid);
		                MasterOrderPriorRowid = GlobalObj.ShortOrderPriorRowid;
		                MasterOrderPrior = "��ʱҽ��";
		            } else {
		                ClearOrderFreq(rowid);
		                $.messager.alert("��ʾ","��ǰҽ�����Ͳ�����ı�Ƶ��Ϊ" + OrderFreq);
		                return;
		            }
		        }
		    }
		    var OrderVirtualtLong=GetCellData(rowid, "OrderVirtualtLong");
		    if ((+OrderFreqInterval!="0")&&(GlobalObj.PAAdmType != "I")&&(OrderVirtualtLong!="Y")){
		        var rtn=tkMakeServerCall("web.DHCDocOrderCommon", "GetFirstDurByWeekFreq", OrderFreqInterval);
		        var OrderDurRowid=rtn.split(",")[0];
		        var OrderDur=rtn.split(",")[1];
		        var OrderDurFactor=rtn.split(",")[3];
		        var CurrentOrderDurFactor=GetCellData(rowid, "OrderDurFactor");
		        if ((OrderDurRowid!="")&&((+CurrentOrderDurFactor)<(+OrderDurFactor))){
		            SetCellData(rowid, "OrderDur", OrderDur)
		            SetCellData(rowid, "OrderDurRowid", OrderDurRowid);
		            SetCellData(rowid, "OrderDurFactor", OrderDurFactor);
		            DurChangeFlag=1;
		        }
		    }
		    var PriorRowid = GetCellData(rowid, "OrderPriorRowid");
		    if (OldPriorRowid != PriorRowid) {
			    OrderPriorchangeCommon(rowid,OldPriorRowid,PriorRowid,resolve);
			}else{
				resolve();
			}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			var OrderFreqRowid=GetCellData(rowid, "OrderFreqRowid");
			var OrderFreq=GetCellData(rowid, "OrderFreq");
			var OrderFreqFactor=GetCellData(rowid, "OrderFreqFactor");
			var OrderFreqInterval=GetCellData(rowid, "OrderFreqInterval");
			var OrderFreqDispTimeStr=GetCellData(rowid, "OrderFreqDispTimeStr");
			var MasterOrderStartTime = "",
		        MasterOrderStartDate = "";
		    if (OrderFreqRowid == GlobalObj.STFreqRowid) {
		        var CurrDateTime = cspRunServerMethod(GlobalObj.GetCurrentDateTimeMethod, PageLogicObj.defaultDataCache, "1");
		        var CurrDateTimeArr = CurrDateTime.split("^");
		        MasterOrderStartDate = GetCellData(rowid, "OrderStartDate").split(" ")[0];
		        MasterOrderStartTime = CurrDateTimeArr[1];
		        var datetiem = MasterOrderStartDate + " " + MasterOrderStartTime;
		        SetCellData(rowid, "OrderStartDate", datetiem);
		    }
		    //Ƶ��->�Ƴ̼��
		    FreqDurChange(rowid);
		    var MasterOrderStartDateStr = GetCellData(rowid, "OrderStartDate");
		    SetOrderFirstDayTimes(rowid);
		    SetPackQty(rowid);
		    ChangeLinkOrderFreq(OrderSeqNo,MasterOrderPriorRowid,MasterOrderPrior,OrderFreqRowid,OrderFreq,OrderFreqFactor,OrderFreqInterval,OrderFreqDispTimeStr,MasterOrderStartDateStr,resolve);
		})
	}).then(function(){
		if (DurChangeFlag==1){
	        var OrderDurRowid=GetCellData(rowid, "OrderDurRowid");
	        var OrderDur=GetCellData(rowid, "OrderDur");
	        var OrderDurFactor=GetCellData(rowid, "OrderDurFactor");
	        ChangeLinkOrderDur(OrderSeqNo, OrderDurRowid, OrderDur, OrderDurFactor);
	    }
	    SetScreenSum();
	    var type = "";
    	if (window.event) type = websys_getType(window.event);
		if (type != 'change'){
	        var IdOrderDur = rowid + "_" + "OrderDur";
	        var objDur = document.getElementById(IdOrderDur);
	        var IdOrderPackQty = rowid + "_" + "OrderPackQty";
	        var objPackQty = document.getElementById(IdOrderPackQty);
	        if ((objDur.disabled)&&(objPackQty.disabled)){
		        setTimeout(function(){
			        setTimeout(function(){
				        $("#"+rowid+"_OrderFreq").lookup('hidePanel');
				    })
			        var RowNext = GetNextRowId(rowid);
			        if (RowNext==rowid){
				        Add_Order_row();
				        RowNext=parseInt(RowNext)+1;
				    }
			        SetFocusCell(RowNext, "OrderName");
		            return websys_cancel();
			    })
		    }else{
	        	setTimeout(function(){
		        	setTimeout(function(){
				        $("#"+rowid+"_OrderFreq").lookup('hidePanel');
				    })
				    var OrderInstrRowid = GetCellData(rowid, "OrderInstrRowid");
				    var OrderDoseQty=GetCellData(rowid, "OrderDoseQty");
				    if ((OrderDoseQty=="")&&(!IsWYInstr(OrderInstrRowid))) {
			        	var JumpAry = ['OrderDoseQty','OrderDur', 'OrderPackQty'];
			        }else{
				        var JumpAry = ['OrderDur', 'OrderPackQty'];
				    }
	        		var JumpCellName=CellFocusJump(rowid, JumpAry, true);
			    })
			}
	    }else{
	        if (PageLogicObj.LookupPanelIsShow==1) {
		        setTimeout(function(){
			        $("#"+rowid+"_OrderFreq").lookup('hidePanel');
			    })
		    }
		}
	    //ͬ�����մ���
	    ChangeFirstDayTimes(rowid);
	    XHZY_Click();
	    if (callBackFun) callBackFun();
	    else  return websys_cancel();
	})
}
//�÷���ѯ
var ShowInstrLookup = 0;
function PHCINDesc_lookuphandler(e) {
    var obj = websys_getSrcElement(e);
    var key = websys_getKey(e);
    var type = websys_getType(e);
   
    if (key != 13 && type != 'dblclick') {
        return;
    }
    var rowid = "";
    if (obj.id.indexOf("_") > 0) {
        rowid = obj.id.split("_")[0];
    }
	return false;
}
//�÷�ѡ��
function InstrLookUpSelect(value,rowid) {
    try {
	    if (typeof rowid=="undefined"){
			var rowid = "";
		}
		if (rowid==""){
	        if (this.id.indexOf("_") > 0) {
	            rowid = this.id.split("_")[0];
	        }
        }
        var Id = "";
        if ($.isNumeric(rowid) == true) {
            Id = rowid + '_OrderInstr';
        } else {
            Id = 'OrderInstr';
        }
        var obj = document.getElementById(Id);
        $(obj).removeClass("clsInvalid");
        //if (obj) obj.className = '';
        var Split_Value = value.split("^");
        var OrderInstrRowid = Split_Value[0];
        var OrderInstr = unescape(Split_Value[1]);
        var OrderInstrCode = Split_Value[2];
        if (Split_Value.length == 4) { rowid = Split_Value[3] }
        var Split_Value = value.split("^");
        var OrderSeqNo = GetCellData(rowid, "id");
        var OrderInstr = unescape(Split_Value[1]);
        var OrderInstrRowid = Split_Value[0];
        var OrderInstrCode = Split_Value[2];
        if ((GlobalObj.ForbidDosingInstr!="")&&(GlobalObj.ForbidDosingInstr.indexOf("^"+OrderInstrRowid+"^")>-1)) return false;
        var OrderPriorRowid = GetCellData(rowid, "OrderPriorRowid");
        //����ҽ�����ܿ�Ƥ���÷�
        if (GlobalObj.SkinTestInstr != "") {
	        var Instr = "^" + OrderInstrRowid + "^"
            if ((GlobalObj.SkinTestInstr.indexOf(Instr) != "-1")) {
				$(".messager-button a").click();
	            if (OrderPriorRowid == GlobalObj.LongOrderPriorRowid){
		            $.messager.alert("��ʾ","����ҽ������ѡƤ���÷�!","info",function(){
			            SetCellData(rowid, "OrderInstr", "");
		            	SetCellData(rowid, "OrderInstrRowid", "");
		            	SetFocusCell(rowid, "OrderInstr");
			        });
		            return false;
		        }
	        }
	    }
        var obj = document.getElementById('OrderInstrz' + rowid);
        if (obj) {
            obj.value = OrderInstr;
            $(obj).removeClass("clsInvalid");
            //obj.className = '';
        }
        SetCellData(rowid, "OrderInstr", OrderInstr);
        var OrderType = GetCellData(rowid, "OrderType");
        //SetCellData(rowid,"OrderInstrRowid",OrderInstrRowid); 
		var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
    	var NeedSkinTestINCI = mPiece(OrderHiddenPara, String.fromCharCode(1), 7);
    	new Promise(function(resolve,rejected){
	        //�����Ƥ���÷��Զ�ѡ��Ƥ�Ա�־
	        if (GlobalObj.SkinTestInstr != "") {
	            var Instr = "^" + OrderInstrRowid + "^"
	            if ((GlobalObj.SkinTestInstr.indexOf(Instr) != "-1")&&(OrderType =="R")) { //&&(NeedSkinTestINCI=="Y")
	                /*var ActionRowid=GetCellData(rowid, "OrderActionRowid");
	                var ActionCode = GetOrderActionCode(ActionRowid);
	                if ((ActionCode=="YY")||(ActionCode=="")){
	                    SetCellData(rowid, "OrderSkinTest", true);
	                }*/
	                SetCellData(rowid, "OrderActionRowid","");
	                SetCellData(rowid, "OrderAction","");
	                //����ǳ���ҽ����Ƥ���÷���ֻ����ҽ���ĵ�һ����Ƥ�Թ�ѡ��ʣ���߼���ChangeLinkOrderInstr�д���
	                var RowArry = GetSeqNolist(rowid);
	                if (RowArry.length==0){
	               		SetCellData(rowid, "OrderSkinTest", true);
	                }else{
		            	SetCellData(rowid, "OrderSkinTest", false);   
		            }
		            if (GlobalObj.DisableOrdSkinChange!="1"){
		                //OrderSkinTest���Ա༭,��Ҫ�ǳ���ҽ����Ҫҽ���ֹ�ѡ����ý��Ƥ�Ա�ʶ
		                var styleConfigObj = { OrderSkinTest: true, OrderAction: false }
		                ChangeCellDisable(rowid, styleConfigObj);
	                }
	                if ((OrderPriorRowid != GlobalObj.ShortOrderPriorRowid)&&(GlobalObj.CFSkinTestPriorShort == 1)) {
	                    if (GlobalObj.OrderPriorContrlConfig == 1) {
	                        SetColumnList(rowid, "OrderPrior", GlobalObj.ShortOrderPriorRowid + ":" + "��ʱҽ��");
	                        SetCellData(rowid, "OrderPrior", GlobalObj.ShortOrderPriorRowid);
	                        SetCellData(rowid, "OrderPriorRowid", GlobalObj.ShortOrderPriorRowid);
	                        SetCellData(rowid, "OrderPriorStr", GlobalObj.ShortOrderPriorRowid + ":" + "��ʱҽ��");
	                    }
	                    SetCellData(rowid, "OrderPrior", GlobalObj.ShortOrderPriorRowid);
	                    SetCellData(rowid, "OrderPriorRowid", GlobalObj.ShortOrderPriorRowid);
	                    (function(callBackFunExec){
		                    new Promise(function(resolve,rejected){
			                    OrderPriorchangeCommon(rowid,OrderPriorRowid,GlobalObj.ShortOrderPriorRowid,resolve);
			                }).then(function(){
			                    //����OrderPriorchangeCommon������ı��꽹�㵽�÷�λ��
			                    SetFocusCell(rowid, "OrderAction");
			                    callBackFunExec();
				            })
		                })(resolve);
	                }else{
		                resolve();
		            }
	            } else {
	                //�޸��÷� ���ı�Ƥ�Թ�ѡ״̬--tanjishan�ֹ��л��÷�������£������Ƥ���޸�Ϊ���ƣ�Ƥ�Թ�ѡȥ����������
	                /*SetCellData(rowid,"OrderSkinTest",false);*/
	                var ActionRowid=GetCellData(rowid, "OrderActionRowid");
	                var ActionCode = GetOrderActionCode(ActionRowid);
	                /*
	                if ((NeedSkinTestINCI=="Y")||(ActionCode!="")){
		                var styleConfigObj={OrderSkinTest:false,OrderAction:true}
		            }else{
			            var styleConfigObj={OrderSkinTest:true,OrderAction:true}
			        }*/
			        if (GlobalObj.DisableOrdSkinChange=="1"){
				        var styleConfigObj={OrderSkinTest:false,OrderAction:false};
			        }else if (OrderType =="R"){
			        	var styleConfigObj={OrderSkinTest:true,OrderAction:true};
			        }
	                ChangeCellDisable(rowid,styleConfigObj);
	                resolve();
	            }
	        }else{
		        resolve();
		    }
    	}).then(function(){
	    	SetCellData(rowid, "OrderInstr", OrderInstr);
	        SetCellData(rowid, "OrderInstrRowid", OrderInstrRowid);
	        DHCDocUseCount(OrderInstrRowid, "User.PHCInstruc");
	        if ((GlobalObj.DrippingSpeedInstr).indexOf("^"+OrderInstrRowid+"^")>=0) {
		        //�����ٵ�λΪ����ȡҽ��վ����-�÷����á��÷���չ������Һ�÷�Ĭ�����ٵ�λ
		        //var OrderFlowRateUnitRowId=GetCellData(rowid, "OrderFlowRateUnitRowId");
		        //if (OrderFlowRateUnitRowId=="") {
			        $.cm({
					    ClassName:"web.DHCOEOrdItemView",
					    MethodName:"GetInstrDefSpeedRateUnit",
					    InstrRowId:OrderInstrRowid,
					    dataType:"text"
					},function(OrderFlowRateUnitRowId){
						if (OrderFlowRateUnitRowId!=""){
					    	SetCellData(rowid, "OrderFlowRateUnitRowId",OrderFlowRateUnitRowId);
					    	var RowOrderSeqNo = GetCellData(rowid, "id");
						    var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
						    if (OrderMasterSeqNo != "") RowOrderSeqNo = OrderMasterSeqNo;
						    var OrderFlowRateUnit = GetCellData(rowid, "OrderFlowRateUnit");
					    	ChangeLinkOrderFlowRateUnit(RowOrderSeqNo, OrderFlowRateUnitRowId,OrderFlowRateUnit);
					    }
					})
			    //}
		    }
	        var OrderType = GetCellData(rowid, "OrderType");
	        if (OrderType!="R"){
		        if ((GlobalObj.DrippingSpeedInstr).indexOf("^"+OrderInstrRowid+"^")>=0) {
			        ChangeCellDisable(rowid,{OrderSpeedFlowRate:true,OrderFlowRateUnit:true,OrderLocalInfusionQty:true});
			    }else{
				    ChangeCellDisable(rowid,{OrderSpeedFlowRate:false,OrderFlowRateUnit:false,OrderLocalInfusionQty:false});
				    SetCellData(rowid, "OrderSpeedFlowRate", "");
	        		SetCellData(rowid, "OrderFlowRateUnit", "");
	        		SetCellData(rowid, "OrderFlowRateUnitRowId", "");
	        		SetCellData(rowid, "OrderLocalInfusionQty", "");
				}
		    }
	        if ((IsWYInstr(OrderInstrRowid)) && (GlobalObj.PAAdmType != "I")) {
	            /*SetCellData("OrderDur",rowid,"");
	            SetCellData("OrderDurRowid",rowid,"");
	            SetCellData("OrderDoseQty",rowid,"");*/
	            SetCellData(rowid, "OrderDur", "");
	            SetCellData(rowid, "OrderDurRowid", "");
	            SetCellData(rowid, "OrderDoseQty", "");
	            SetCellData(rowid, "OrderDurFactor", 1);
	            SetCellData(rowid, "OrderFreqTimeDoseStr", "");
	        }
	        var OrderPriorRowid = GetCellData(rowid, "OrderPriorRowid");
	        if (GlobalObj.PAAdmType != "I") {
		        var OrdOutPriorRecLocStr=GetCellData(rowid, "OrderOutPriorRecLocStr");
		        if ((OrderPriorRowid==GlobalObj.OutOrderPriorRowid)&&(OrdOutPriorRecLocStr!="")) {
			        ChangeLinkOrderInstr(OrderSeqNo, OrderInstrRowid, OrderInstr);
			    }else{
		        	//�÷�������տ���,δ�����÷����տ���,�򲻴���
		        	var OldOrderRecDepRowid=GetCellData(rowid, "OrderRecDepRowid");
		        	var newReclocStr = GetReclocByInstr(rowid);
			        var InstrReclocStr=newReclocStr.split("^")[0];
			        var OrderRecLocStr=newReclocStr.split("^")[1];
			        if (InstrReclocStr!="") {
				        var OrderRecLocStr = GetRecLocStrByPrior(InstrReclocStr, OrderPriorRowid);
				    }else{
					    var OrderRecLocStr = GetRecLocStrByPrior(OrderRecLocStr, OrderPriorRowid);
					}
					SetColumnList(rowid, "OrderRecDep", OrderRecLocStr);
					if (InstrReclocStr=="") {
						RestoreChangeRecLoc(rowid,OldOrderRecDepRowid,OrderRecLocStr);
					}
					ChangeLinkOrderInstr(OrderSeqNo, OrderInstrRowid, OrderInstr);
			        OrderRecDepChangeCom(rowid);
				}
			}else{
				ChangeLinkOrderInstr(OrderSeqNo, OrderInstrRowid, OrderInstr);
				var OrderPriorRemarks = GetCellData(rowid, "OrderPriorRemarksRowId");
			    SetRecLocStr(rowid, OrderPriorRowid, OrderPriorRemarks);
		    }
	        SetOrderLocalInfusionQty(rowid)
	        var type = "";
	        if (window.event) type = websys_getType(e);
	        //if ((ShowInstrLookup == 1) && (type != 'change')) {
		    if (type != 'change'){
	            var IdOrderFreq = rowid + "_" + "OrderFreq";
		        var objOrderFreq = document.getElementById(IdOrderFreq);
		        
	            var IdOrderDur = rowid + "_" + "OrderDur";
		        var objDur = document.getElementById(IdOrderDur);
		        var IdOrderPackQty = rowid + "_" + "OrderPackQty";
		        var objPackQty = document.getElementById(IdOrderPackQty);
		        if ((objOrderFreq.disabled)&&(objDur.disabled)&&(objPackQty.disabled)){
			        setTimeout(function(){
				        var RowNext = GetNextRowId(rowid);
				        if (RowNext==rowid){
					        Add_Order_row();
					        RowNext=parseInt(RowNext)+1;
					    }
				        SetFocusCell(RowNext, "OrderName");
			            return websys_cancel();
				    })
			    }else{
		        	setTimeout(function(){
				        var JumpAry = ['OrderFreq','OrderDur', 'OrderPackQty'];
	            		var JumpCellName=CellFocusJump(rowid, JumpAry, true);
				    })
				}
	        }
	        XHZY_Click();
	    })
    } catch (e) { alert(e.message) };
}

//�÷��ı�
function InstrChangeHandler(e) {
    var rowid = "";
    var obj = websys_getSrcElement(e);
    var rowid = GetEventRow(e);
    PHCINDesc_lookuphandlerX(rowid);
    return websys_cancel();
}

function PHCINDesc_lookuphandlerX(rowid) {
    SetCellData(rowid, "OrderInstrRowid", "");
    var Id = "";
    if ($.isNumeric(rowid) == true) {
        Id = rowid + '_OrderInstr';
    } else {
        Id = 'OrderInstr';
    }
    var OrderSkinTest=GetCellData(rowid, "OrderSkinTest");
    var OrderActionRowid=GetCellData(rowid, "OrderActionRowid");
    var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
    var OrderInstrRowid=GetCellData(rowid, "OrderInstrRowid");
    var NeedSkinTestINCI = mPiece(OrderHiddenPara, String.fromCharCode(1), 7);
    if ((NeedSkinTestINCI!="Y")&&$("#" + rowid).find("td").hasClass("OrderMasterM")){
		var RowArry = GetSeqNolist(rowid)
        for (var i = 0; i < RowArry.length; i++) {
            var OrderHiddenPara = GetCellData(RowArry[i], "OrderHiddenPara");
            NeedSkinTestINCI = mPiece(OrderHiddenPara, String.fromCharCode(1), 7);
            if (NeedSkinTestINCI=="Y"){
	            OrderSkinTest=GetCellData(RowArry[i], "OrderSkinTest");
    			OrderActionRowid=GetCellData(RowArry[i], "OrderActionRowid");
    			OrderInstrRowid=GetCellData(RowArry[i], "OrderInstrRowid");
	        	break;   
	        }
        }
	}
	
    var SeachSkinInstrFlag="";
    var Instr="^"+OrderInstrRowid+"^";
	//�������ҽ������������ѡ��Ƥ���÷�
	if (NeedSkinTestINCI=="Y"){
		if ((GlobalObj.SkinTestInstr.indexOf(Instr) != "-1")) {
			SeachSkinInstrFlag="OnlySkin";
		}else if ((OrderSkinTest=="Y")||(OrderActionRowid!="")){
			SeachSkinInstrFlag="Remove";
		}
	}else if (GlobalObj.DisableOrdSkinChange=="1"){
		SeachSkinInstrFlag="Remove";
		if ((GlobalObj.SkinTestInstr.indexOf(Instr) != "-1")) {
			SeachSkinInstrFlag="OnlySkin";
		}
	}
	
    var obj = document.getElementById(Id);
    if (obj.value != '') {
        var tmp = document.getElementById(Id);
        if (tmp) { var p1 = tmp.value } else { var p1 = '' };
        var encmeth = GlobalObj.GetOneInstrStrMethod
        var ret = cspRunServerMethod(encmeth, p1,GlobalObj.PAAdmType,session['LOGON.CTLOCID'])
        if ((GlobalObj.SkinTestInstr != "")) {
        	var InstrRowid=mPiece(ret,"^",0);
        	var isSkinInstr=(GlobalObj.SkinTestInstr.indexOf("^"+InstrRowid+"^") != "-1");
        	if ((SeachSkinInstrFlag=="Remove")&&(isSkinInstr==true)){
	        	ret='0';
	        }else if ((SeachSkinInstrFlag=="OnlySkin")&&(isSkinInstr==false)){
	        	ret='0';	
	        }
        }
        if (ret == '0') {
	        $(obj).addClass("clsInvalid");
            SetCellData("OrderInstrRowid", rowid, "");
            websys_setfocus(Id);
            XHZY_Click();
            return "";
        } else {
	        $(obj).removeClass("clsInvalid");
            InstrLookUpSelect(ret + "^" + rowid,rowid);
        }
    } else {
        //�����������
        //ChangeLinkOrderInstr(rowid,"","");
    }
}
//�Ƴ̲�ѯ
var ShowDurLookup = 0;
function PHCDUDesc_lookuphandler(e) {
    var obj = websys_getSrcElement(e);
    var key = websys_getKey(e);
    var type = websys_getType(e);

    if (key != 13 && type != 'dblclick') {
        return;
    }
    var rowid = "";
    if (obj.id.indexOf("_") > 0) {
        rowid = obj.id.split("_")[0];
    }
    return ;
}
//�Ƴ̸ı�
function DurationChangeHandler(e) {
    var rowid = GetEventRow(e)
    PHCDUDesc_changehandlerX(rowid)
    return;
}
function PHCDUDesc_changehandlerX(rowid) {
    SetCellData(rowid, "OrderDurRowid", "");
    var Id = "";
    if ($.isNumeric(rowid) == true) {
        Id = rowid + '_OrderDur';
    } else {
        Id = 'OrderDur';
    }
    var obj = document.getElementById(Id);
    if (obj.value != '') {
        var tmp = document.getElementById(Id);
        if (tmp) { var p1 = tmp.value } else { var p1 = '' };
        var encmeth = GlobalObj.GetOneDurationStrMethod
        var ret = cspRunServerMethod(encmeth, p1)
        if (ret == '0') {
	        $(obj).addClass("clsInvalid");
            SetFocusCell(rowid, "OrderDur");
            return "";
        } else {
	        $(obj).removeClass("clsInvalid");
            DurationLookUpSelect(ret + "^" + rowid,rowid);
        }
    } else {
        //var OrderSeqNo=GetCellData(rowid,"id");
        //ChangeLinkOrderDur(OrderSeqNo,OrderDurRowid,OrderDur,OrderDurFactor)
        ChangeLinkOrderDur(rowid, "", "", "");
    }
    XHZY_Click();
}
function DurationLookUpSelect(value,rowid) {
    var Split_Value = value.split("^");
    //var rowid = "";
    if (typeof rowid == "undefined") { 
    	rowid = "";
    }
    if (rowid == "") {
	    if ((this.id)&&(this.id.indexOf("_") > 0)) {
	        rowid = this.id.split("_")[0];
	    }
    }
    try {
        var OrderDur = unescape(Split_Value[1]);
        var OrderDurRowid = Split_Value[0];
        var OrderDurFactor = Split_Value[3];
        if (Split_Value.length == 5) { rowid = Split_Value[4] }
        var OrderSeqNo = GetCellData(rowid, "id");
        SetCellData(rowid, "OrderDur", OrderDur)
        SetCellData(rowid, "OrderDurRowid", OrderDurRowid);
        SetCellData(rowid, "OrderDurFactor", OrderDurFactor);
        var SetPackQtyConfig={
			///�Ƿ���Ҫ��������װ��
			IsNotNeedChangeFlag:undefined,
			///�Ƿ���Ҫ�������մ���
			IsNotChangeFirstDayTimeFlag:undefined
		};
        var OrderFirstDayTimes=GetCellData(rowid, "OrderFirstDayTimes");
        if (OrderFirstDayTimes!=""){
	        SetPackQtyConfig.IsNotChangeFirstDayTimeFlag="Y";
	    }
        SetPackQty(rowid,SetPackQtyConfig);
        ChangeLinkOrderDur(OrderSeqNo, OrderDurRowid, OrderDur, OrderDurFactor);
        SetScreenSum();
        var OrderPackQty = GetCellData(rowid, "OrderPackQty");
        var OrderType = GetCellData(rowid, "OrderType");
        
        var type = "";
        if (window.event) type = websys_getType(e);
        //if ((ShowDurLookup == 1) && (type != 'change')) {
        if (type != 'change') { 
            setTimeout(function (){
                if (PHCDUDesczLookupGrid) {
                    //PHCDUDesczLookupGrid.hide();
                }
                var JumpAry = ['OrderPackQty'];
                var JumpCellName=CellFocusJump(rowid, JumpAry, true);
            },10);
            return true;
            /*
            //���ʧȥ����,��Ҫ�رղ�ѯ��
            if (PHCDUDesczLookupGrid && (JumpCellName.indexOf("OrderDur")==-1)) {
                setTimeout(function (){PHCDUDesczLookupGrid.hide();},130);
            }
            */
        }

    } catch (e) {};
    return websys_cancel();
}
function ChangeLinkOrderDur(OrderSeqNo, OrderDurRowid, OrderDur, OrderDurFactor) {
    try {
        var rows = $('#Order_DataGrid').getDataIDs();
        for (var i = 0; i < rows.length; i++) {
            var rowid = rows[i];
            var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
            var OrderItemRowid = GetCellData(rowid, "OrderItemRowid");
            var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
            var OrderType = GetCellData(rowid, "OrderType");
            if ((OrderMasterSeqNo != OrderSeqNo) || (OrderARCIMRowid == "") || (OrderItemRowid != "")) { continue; }
            SetCellData(rowid, "OrderDur", OrderDur);
            SetCellData(rowid, "OrderDurRowid", OrderDurRowid);
            SetCellData(rowid, "OrderDurFactor", OrderDurFactor);
            var SetPackQtyConfig={
				///�Ƿ���Ҫ��������װ��
				IsNotNeedChangeFlag:undefined,
				///�Ƿ���Ҫ�������մ���
				IsNotChangeFirstDayTimeFlag:undefined
			};
            var OrderFirstDayTimes=GetCellData(rowid, "OrderFirstDayTimes");
	        if (OrderFirstDayTimes!=""){
		        SetPackQtyConfig.IsNotChangeFirstDayTimeFlag="Y";
		    }
            SetPackQty(rowid,SetPackQtyConfig);
        }
    } catch (e) { $.messager.alert("����", e.message) }
}
function PHCFRDesc_changehandlerX(rowid,callBackFun) {
	var OldOrderFreqRowid=GetCellData(rowid, "OrderFreqRowid");
    SetCellData(rowid, "OrderFreqRowid", "");
    var encmeth = GlobalObj.GetOneFrequencyStrMethod
    var Id = "";
    if ($.isNumeric(rowid) == true) {
        Id = rowid + '_OrderFreq';
    } else {
        Id = 'OrderFreq';
    }
    new Promise(function(resolve,rejected){
	    var obj = document.getElementById(Id);
	    if (obj && obj.value != '') {
	        var tmp = document.getElementById(Id);
	        if (tmp) { var p1 = tmp.value } else { var p1 = '' };
	        var OrderPriorRowid = GetCellData(rowid, "OrderPriorRowid");
	        var ret = cspRunServerMethod(encmeth, p1,GlobalObj.PAAdmType,OrderPriorRowid);
	        if (ret == '0') {
		        $(obj).addClass("clsInvalid");
	            websys_setfocus(Id);
	            if (callBackFun) callBackFun();
	        } else if(ret==1){
				//Ŀǰû���߼����ߵ�����߼��ж���-tanjishan2019.10.29
				$(obj).removeClass("clsInvalid");
	            FrequencyLookUpSelect(ret,rowid,resolve);
	            $(obj).removeClass("clsInvalid");
	        }else if (ret!=""){
				//�Һ��ʵ�Ƶ�Σ������͵�ǰ���ϵ�Ƶ��һֱ������Ҳ���һ�µ����л�
				var FreqArr=ret.split(String.fromCharCode(2));
				var FreqStr="";
				for (var i = 0; i < FreqArr.length; i++) {
					var LoopFreqStr=FreqArr[i];
					var LoopOrderFreqRowid=mPiece(LoopFreqStr, "^", 4);
					if (LoopOrderFreqRowid==OldOrderFreqRowid){
						FreqStr=LoopFreqStr;
					}
				}
				if (FreqStr!=""){
					var OrderFreq = mPiece(FreqStr, "^", 0);
					var OrderFreqFactor = mPiece(FreqStr, "^", 2);
					var OrderFreqInterval = mPiece(FreqStr, "^", 3);
					var OrderFreqRowid = mPiece(FreqStr, "^", 4);
					var WeekFlag = mPiece(FreqStr, "^", 6);
					var FreeTimeFreqFlag = mPiece(FreqStr, "^", 8);
					if ((WeekFlag!="Y")&&(FreeTimeFreqFlag!="Y")) {
						SetCellData(rowid, "OrderFreq", OrderFreq);
					}
					SetCellData(rowid, "OrderFreqRowid", OrderFreqRowid);
					SetCellData(rowid, "OrderFreqFactor", OrderFreqFactor);
					SetCellData(rowid, "OrderFreqInterval", OrderFreqInterval);
					resolve();
				}else if(FreqArr.length==1){
		            FrequencyLookUpSelect(mPiece(ret, String.fromCharCode(2), 0),rowid,resolve);
				}
			}
	    } else {
	        var MasterOrderPriorRowid = GetCellData(rowid, "OrderPriorRowid");
	        var MasterOrderPrior = GetCellData(rowid, "MasterOrderPrior");
	        var OrderFreqRowid = "";
	        var OrderFreq = "";
	        var OrderFreqFactor = "";
	        var OrderFreqInterval = "";
	        SetCellData(rowid, "OrderFreq", OrderFreq);
	        SetCellData(rowid, "OrderFreqRowid", OrderFreqRowid);
	        SetCellData(rowid, "OrderFreqFactor", OrderFreqFactor);
	        SetCellData(rowid, "OrderFreqInterval", OrderFreqInterval);
	        //Ƶ��->�Ƴ̼��
	        FreqDurChange(rowid)
	        
	        var OrderFreqDispTimeStr = GetCellData(rowid, "OrderFreqDispTimeStr");
	        var MasterOrderStartDateStr = GetCellData(rowid, "OrderStartDate");
	        SetPackQty(rowid);
	        ChangeLinkOrderFreq(rowid,MasterOrderPriorRowid,MasterOrderPrior,OrderFreqRowid,OrderFreq,OrderFreqFactor,OrderFreqInterval,OrderFreqDispTimeStr,MasterOrderStartDateStr,resolve);
	    }
	}).then(function(){
		SetScreenSum();
	    //ͬ�����մ���
	    ChangeFirstDayTimes(rowid)
	    XHZY_Click();
		if (callBackFun) callBackFun();
	})
}

function GetOrderSeqArr(rowid) {
    if ($.isNumeric(rowid) == false) { return rowid }
    var rowidArr = {};
    rowidArr[rowid] = rowid;
    var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
    //����Ϊ��ҽ��
    if (OrderMasterSeqNo == "") {
        var rowids = GetAllRowId();
        for (var i = 0; i < rowids.length; i++) {
            var MasterSeqNo = GetCellData(rowids[i], "OrderMasterSeqNo");
            if (MasterSeqNo == rowid) {
                rowidArr[rowids[i]] = rowids[i];
            }
        }
    } else {
        //��ҽ��
        var rowids = GetAllRowId();
        //��ҽ��id:OrderMasterSeqNo
        rowidArr[OrderMasterSeqNo] = OrderMasterSeqNo;
        for (var i = 0; i < rowids.length; i++) {
            var MasterSeqNo = GetCellData(rowids[i], "OrderMasterSeqNo");
            if (MasterSeqNo == OrderMasterSeqNo) {
                rowidArr[rowids[i]] = rowids[i];
            }
        }
    }
    return rowidArr;
}
//ѡ�����
function SelectContrl(rowid) {
    if ($.isNumeric(rowid) == false) { return rowid }
    var stutas = $("#jqg_Order_DataGrid_" + rowid).prop("checked");
    var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
    var rowids = GetAllRowId();
    //�������� ѡ����ҽ���Ƿ�ѡ��ȫ�� 1��ȫѡ
    var configValue = GlobalObj.SelectContrlConfig;
    //---------------�����ҽ���ж� ����ҽ��ʼ������
    if (CheckIsItem(rowid) == true) {
        var FitNum = ""
        FitNum = rowid.split(".")[0]
        for (var i = 0; i < rowids.length; i++) {
            if (CheckIsItem(rowids[i]) != true) { continue; }
            if (rowids[i] == rowid) { continue }
            var subFitNum = rowids[i].split(".")[0]
            if (subFitNum == FitNum) {
                $("#Order_DataGrid").setSelection(rowids[i], false);
            }
        }
    }
    //-----------------δ���ҽ���ж�
    var OrderSeqNo=GetCellData(rowid, "id");
    //����Ϊ��ҽ��
    if (OrderMasterSeqNo == "") {
        var OrderMasterFlag=0;
        for (var i = 0; i < rowids.length; i++) {
	        
            //ȡ��ҽ��
            var MasterSeqNo = GetCellData(rowids[i], "OrderMasterSeqNo");
            if (MasterSeqNo != "" && MasterSeqNo == OrderSeqNo) {
                //ѡ����ҽ�� rowids[i]
                //��ȡѡ��״̬
                if ($("#jqg_Order_DataGrid_" + rowids[i]).prop("checked") != stutas) {
                    $("#Order_DataGrid").setSelection(rowids[i], false);
                }
                if (stutas){
	                $("#ChangeOrderSeq_Btn .l-btn-text")[0].innerText=$g("��������(R)");
	            }else{
		            $("#ChangeOrderSeq_Btn .l-btn-text")[0].innerText=$g("��ʼ����(R)");
		            PageLogicObj.StartMasterOrdSeq="";
		        }
                OrderMasterFlag=OrderMasterFlag+1;
            }
        }
        if (OrderMasterFlag==0){
	        $("#ChangeOrderSeq_Btn .l-btn-text")[0].innerText=$g("��ʼ����(R)");
	        PageLogicObj.StartMasterOrdSeq="";
        }
    } else if (configValue == 1) {
        //ȫѡ
        //��ҽ��ID
        var mainRowid = OrderMasterSeqNo;
        var mainRowData=$('#Order_DataGrid').jqGrid("getRowData",OrderMasterSeqNo);
        if ($.isEmptyObject(mainRowData)) {
	        var mainRowid=GetRowIdByOrdSeqNo(mainRowid);
	    }
        //��ҽ��ѡ��״̬
        if ($("#jqg_Order_DataGrid_" + mainRowid).prop("checked") != stutas) {
            $("#Order_DataGrid").setSelection(mainRowid, false);
        }
        for (var i = 0; i < rowids.length; i++) {
            //ȡ��ҽ��
            var MasterSeqNo = GetCellData(rowids[i], "OrderMasterSeqNo");
            if (MasterSeqNo != "" && MasterSeqNo == mainRowid) {
                //��ȡѡ��״̬
                if ($("#jqg_Order_DataGrid_" + rowids[i]).prop("checked") != stutas) {
                    $("#Order_DataGrid").setSelection(rowids[i], false);
                }
                if (stutas){
	                $("#ChangeOrderSeq_Btn .l-btn-text")[0].innerText=$g("��������(R)");
	            }else{
		            $("#ChangeOrderSeq_Btn .l-btn-text")[0].innerText=$g("��ʼ����(R)");
		            PageLogicObj.StartMasterOrdSeq="";
		        }
            }
        }
    }
    if (stutas) {
        if ((VerifiedOrderObj) && (VerifiedOrderObj.LinkedMasterOrderPriorRowid != "undefined") && (VerifiedOrderObj.LinkedMasterOrderPriorRowid != "")) return false;
        if (GlobalObj.CFOrderMsgAlert != 1) return false;

        var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid")
        var OrderName = GetCellData(rowid, "OrderName")
        var OrderMsg = cspRunServerMethod(GlobalObj.GetOrderMsgMethod, GlobalObj.EpisodeID, OrderARCIMRowid)
        if (OrderMsg != "") {
            $("#Prompt").html("��ʾ��Ϣ:" + OrderName + OrderMsg);
        }else{
	        $("#Prompt").html("��ʾ��Ϣ:");
	    }
    }
}
function ChangeOrderSeqhandler(e){
    var BtnText=$("#ChangeOrderSeq_Btn .l-btn-text")[0].innerText;
    if (BtnText.indexOf($g('��������')) != -1){
        if (!ClearSeqNohandler()) return false;
        PageLogicObj.IsStartOrdSeqLink=0;
        PageLogicObj.StartMasterOrdSeq="";
        $("#ChangeOrderSeq_Btn .l-btn-text")[0].innerText=$g("��ʼ����(R)");
    }else{
        if (!SetSeqNohandler()) {
	        PageLogicObj.IsStartOrdSeqLink="";
	        return false;
	    }
        PageLogicObj.IsStartOrdSeqLink=1;
        $("#ChangeOrderSeq_Btn .l-btn-text")[0].innerText=$g("��������(R)");
    }
}
function checkOrdMasSeqNoIsEdit(row){
	var StyleConfigStr = GetCellData(row, "StyleConfigStr");
    var StyleConfigObj = {};
    if (StyleConfigStr != "") {
        StyleConfigObj = eval("(" + StyleConfigStr + ")");
    }
    if (StyleConfigObj.OrderMasterSeqNo==false){
	    return false;
	}
	return true;
}
////��������  2014-04-17(�ṩ����ť�Ŀ���)
function SetSeqNohandler() {
    //��ȡѡ����ID: GetSelRowId()
    //��ȡ������ID  ���������  ����CheckIsItem(rowid)�ж�
    //�˴�SelTableRowAry��ѡ�е�����,����ں���ĳ����иı�ѡ��״̬Ҳ��Ӱ����������,���õ�ַ����,����ʹ�����¸�ֵ
    var SelTableRowAry = GetSelRowId();
    var Selrowids = SelTableRowAry.join(',').split(',');
    if (Selrowids.length <= 1) {
        return true;
    }
    var MainID = Selrowids[0];
    PageLogicObj.IsStartOrdSeqLink=MainID;
    //���ù���
    var change=false;
    for (var i = 1; i < Selrowids.length; i++) {
        if (Selrowids[i] == "") continue;
        // ��֤�Ƿ�ɹ���
		var rtn=CheckIsCanSetOrdMasSeqNo(MainID,Selrowids[i],function(){
			$("#Order_DataGrid").setSelection(Selrowids[i], false);
		})
		if (rtn) {
			//���ù���
	        var SubID = Selrowids[i];
	        var change = SetMasterSeqNo(MainID, SubID, "S");
		}else{
			return false;
		}
    }
    return change;
}
//�����(�ṩ����ť�Ŀ���)
function ClearSeqNohandler() {
    //��ȡѡ����ID: GetSelRowId()
    //��ȡ������ID  ���������  ����CheckIsItem(rowid)�ж�
    //GetAllRowId()
    var Selrowids = GetSelRowId();
    //$.messager.alert("����",Selrowids);
    if (Selrowids.length < 1) {
        //$.messager.alert("����", "��ѡ�����ҽ��");
        return true;
    }
    //����Ƿ�ѡ������ҽ��  var OrderMasterSeqNo=GetCellData(MainID,"OrderMasterSeqNo");
    for (var i = 0; i < Selrowids.length; i++) {
        if (CheckIsItem(Selrowids[i]) == false) {
            var OrderMasterSeqNo = GetCellData(Selrowids[i], "OrderMasterSeqNo");
             var OrderType = GetCellData(Selrowids[i], "OrderType");
             //if (OrderType!="R") continue;
            //һ��ȫ��,����ѡ�������ҽ��������ҽ��
            if (OrderMasterSeqNo == "") {
                //ѡ������ҽ��  ���ȫ����ҽ��       
                SetMasterSeqNo(Selrowids[i], "", "C");
            } else {
                SetMasterSeqNo(OrderMasterSeqNo, "", "C");
            }
        }
    }
    return true;
}
//���ù��� ���� ��ҽ��ID  ��ҽ��ID type��"S"(����) "C"(�����) 2014-04-18
function SetMasterSeqNo(MainID, SubID, type) {
    if (MainID != "") {
        if (($.isNumeric(MainID) == false)) { return false; }
        //�ж���ҽ���治����     
    }
    if (SubID != "") {
        if (($.isNumeric(SubID) == false)) { return false; }
    }
    if (type == "S") {
	    // ��֤�Ƿ�ɹ���
	    var rtn=CheckIsCanSetOrdMasSeqNo(MainID,SubID,function(){
			SetCellData(SubID, "OrderMasterSeqNo", "");
			$("#" + SubID).find("td").removeClass("OrderMasterS");
            CheckMasterOrdStyle();
		});
		if (rtn) {
			var SubOrdInstrRowid = GetCellData(SubID, "OrderInstrRowid");
			var SubOrdInstr = GetCellData(SubID, "OrderInstr");
			var MainOrdInstrRowid = GetCellData(MainID, "OrderInstrRowid");
			var SubOldOrderRecDepRowid=GetCellData(SubID, "OrderRecDepRowid");
			var SubOrderRecDep=GetCellData(SubID, "OrderRecDep");
			var SubOrderRecLocStr=GetCellData(SubID, "OrderRecLocStr");
			//���ݼ��
	        var ret = CheckLinkOrderRecDep(MainID, SubID);
	        if (ret == true) {
	            SetCellData(SubID, "OrderMasterSeqNo", MainID);
	            $("#" + MainID).find("td").addClass("OrderMasterM");
	            $("#" + SubID).find("td").addClass("OrderMasterS");
	            OrderMasterHandler(SubID, "S");
	        }else{
		        //��ԭ��ҽ���÷�
				if ((!IsNotFollowInstr(SubOrdInstrRowid))&&(SubOrdInstrRowid!=MainOrdInstrRowid)) {
					 SetCellData(SubID, "OrderInstrRowid", SubOrdInstrRowid);
					 SetCellData(SubID, "OrderInstr", SubOrdInstr);
					 SetColumnList(SubID, "OrderRecDep", SubOrderRecLocStr);
					 SetCellData(SubID, "OrderRecDepRowid", SubOldOrderRecDepRowid);
					 var EditStatus = GetEditStatus(SubID);
					 if (EditStatus){
					    SetCellData(SubID, "OrderRecDep", SubOldOrderRecDepRowid);
					 }else{
					    SetCellData(SubID, "OrderRecDep", SubOrderRecDep);
					 }
				}
		        $("#" + SubID).find("td").removeClass("OrderMasterS");
            	CheckMasterOrdStyle();
		    }
		}else{
			return false;
		}
    } else if (type == "C") {
        //�����
        if (MainID != "") {
            //������ҽ�����ȫ����ҽ��
            $("#" + MainID).find("td").removeClass("OrderMasterM");
            var Allrowids = GetAllRowId();
            for (var i = 0; i < Allrowids.length; i++) {
                if (CheckIsItem(Allrowids[i]) == true) { continue; }
                var SMasterSeqNo = GetCellData(Allrowids[i], "OrderMasterSeqNo");
                if (SMasterSeqNo == MainID) {
                    SetCellData(Allrowids[i], "OrderMasterSeqNo", "");
                    $("#" + Allrowids[i]).find("td").removeClass("OrderMasterS");
                    OrderMasterHandler(Allrowids[i], "C");
                }
            }
        } else {
            //������ҽ�� ���������ҽ�� 
            SetCellData(SubID, "OrderMasterSeqNo", "");
            $("#" + SubID).find("td").removeClass("OrderMasterS");
            $("#" + SubID).find("td").removeClass("OrderMasterM");
            OrderMasterHandler(SubID, "C");
        }
    }
    return true;
}
//���ù����Ͳ����������ʽ�����ݵĿ���
function OrderMasterHandler(rowid, type) {
    /* 
    //��ҽ��ʵ���ϲ���Ҫ������
    if($.isNumeric(MainID)==true){
        //��ԭ
        ChangeCellsDisabledStyle(MainID,true);
    }
    */
    var StyleConfigStr = GetCellData(rowid, "StyleConfigStr");
    var StyleConfigObj = {};
    if (StyleConfigStr != "") {
        StyleConfigObj = eval("(" + StyleConfigStr + ")");
    }
    if (GlobalObj.PAAdmType == "I") {
	    var OrderPriorRowid = GetCellData(rowid, "OrderPriorRowid");
	    if (OrderPriorRowid != GlobalObj.OutOrderPriorRowid) {
		    StyleConfigObj.OrderDur=false;
		}
	}
	var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
    var NeedSkinTestINCI = mPiece(OrderHiddenPara, String.fromCharCode(1), 7);
	//Ƥ���÷���Ƥ�Ա�ע�ͱ�־���ɱ༭
    if (GlobalObj.SkinTestInstr != "") {
	    var InstrRowId = GetCellData(rowid, "OrderInstrRowid");
        var Instr = "^" + InstrRowId + "^";
        if (GlobalObj.SkinTestInstr.indexOf(Instr) != "-1") {
	        StyleConfigObj.OrderAction=false;
	    }
	}
	if (NeedSkinTestINCI=="Y"){
		StyleConfigObj.OrderSkinTest=false;
		StyleConfigObj.OrderAction=false;
	}
    //�ؽ������� ���������� ����ֵ
    var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
    var OrderPrescNo = GetCellData(rowid, "OrderPrescNo");
    if ((OrderPrescNo != "") && (type == "C")) {
        ///���ؽ�ҽ������,���μ���,���μ�����λ,Ƶ��,�Ƴ�,�÷�
        StyleConfigObj.OrderDur = true;
        StyleConfigObj.OrderFreq = true;
        StyleConfigObj.OrderInstr = true;
        if ((!StyleConfigObj.OrderRecDep)&&(OrderMasterSeqNo=="")){
	        StyleConfigObj.OrderRecDep = true;
	        StyleConfigObj.OrderFlowRateUnit = true;
	        StyleConfigObj.OrderSpeedFlowRate = true;
	        StyleConfigObj.OrderLocalInfusionQty = true;
	        StyleConfigObj.ExceedReason = true;
	    }
    }
    //Խ��ʹ�õĿ���ҩ�ﲻ�ɲ����� update by shp 20150721
    var SpelAction = GetCellData(rowid, "SpecialAction");
    var SpecialAction = "";
    if (SpelAction.toString().indexOf('||') != -1) SpecialAction = SpelAction.split("||")[0];

    //������ҽ�������ݺ�disable  ���ù���
    if ($.isNumeric(rowid) == true && type == "S") {
        //��ҽ�����ݸı�
        var MainID = GetCellData(rowid, "OrderMasterSeqNo");
        // update by shp 20150721
        //tanjishan ��ͨҩƷ��Ƥ������ҩƷ��������Ƥ������ҩƷ��Ϊ׼
        var MainOrdNumStr=GetMainOrdNumStrInGroup(MainID,rowid);
		var MainDataRow=mPiece(MainOrdNumStr, "^", 1);
		
        if ((SpecialAction != "isEmergency")&&(MainDataRow==MainID)) {
            SyncOrderData(MainID, rowid);
            //��ҽ����ʽ�ı�
            ChangeCellsDisabledStyle(rowid, false);
            //ChangeRowStyle(rowid,StyleConfigObj);
        } else {
            var rowids = GetAllRowId();
            for (var i = 0; i < rowids.length; i++) {
                var Eid = GetCellData(rowids[i], "OrderMasterSeqNo"); //�Ѿ���������ҽ������id
                if (Eid == MainID) {
                    SyncOrderData(rowid, rowids[i])
                }
            }
            SyncOrderData(rowid, MainID) //��ҽ�����ݸ���Խ������ҩ��������ͳһ
            //ChangeCellsDisabledStyle(MainID, false);
            //Խ������ҩ��Ϊ��ҽ��ʱ,��ҽ������ҽ�����Ͳ��ɱ༭
            ChangeCellsDisabledStyle(rowid, false);
            var styleConfigObj = { OrderPrior: false, OrderFreq:false }
            ChangeCellDisable(MainID, styleConfigObj);
            SetCellData(rowid, "SpecialAction", SpecialAction + "||" + MainID);
        }
    }
    //�����
    if ($.isNumeric(rowid) == true && type == "C") {
        //��ҽ����ʽ�ı�
        var MainID = SpelAction.toString().split("||")[1]; //�˴���ȡ��Ϊ�գ�Ӧȡ�ı�ǰ��ֵ�����޸ġ�
        if ((SpecialAction != "isEmergency")) {
            ChangeCellsDisabledStyle(rowid, true);
            //��Ϊ���ù���ʱ���ܶ�ͬһ���ֶ����ظ� ��Ҫ��ԭ��ʽ
            ChangeRowStyle(rowid, StyleConfigObj);
			FreqDurChange(rowid);
            RestoreOrderData(rowid)
            //��ԭ��SyncOrderData������÷���ʽ
            var MainIDStyleConfigStr = GetCellData(MainID, "StyleConfigStr");
		    var MainIDStyleConfigObj = {};
		    if (MainIDStyleConfigStr != "") {
		        MainIDStyleConfigObj = eval("(" + StyleConfigStr + ")");
		    }
            var RowStyleObj = { OrderInstr: MainIDStyleConfigObj.OrderInstr };
            ChangeCellDisable(MainID, RowStyleObj);
        } else {
            ChangeCellsDisabledStyle(rowid, true);
            //��Ϊ���ù���ʱ���ܶ�ͬһ���ֶ����ظ� ��Ҫ��ԭ��ʽ
            //ChangeRowStyle(MainID,StyleConfigObj);

            RestoreOrderData(MainID)
			var styleConfigObj = { OrderPrior: true }
            ChangeCellDisable(MainID, styleConfigObj);
            var styleConfigObj = { OrderPrior: false }
            ChangeCellDisable(rowid, styleConfigObj);
            var rowids = GetAllRowId();
            for (var i = 0; i < rowids.length; i++) {
                var Eid = GetCellData(rowids[i], "OrderMasterSeqNo"); //�Ѿ���������ҽ������id
                if ((Eid == MainID)&&(Eid!="")) {
                    SyncOrderData(MainID, rowids[i])
                }
            }
            SetCellData(rowid, "SpecialAction", "isEmergency||");
        }
    }
    var OrderType = GetCellData(rowid, "OrderType");
    var OrderPHPrescType = GetCellData(rowid, "OrderPHPrescType");
    var OrderPriorRowid=GetCellData(rowid,"OrderPriorRowid");
    if ((OrderType!="R")&&(OrderPHPrescType!="4")){
	    var styleConfigObj={};
	    if (type=="S"){
		    if (OrderPriorRowid == GlobalObj.LongOrderPriorRowid){
			    var MainStyleConfigStr = GetCellData(MainID, "StyleConfigStr");
			    var MainStyleConfigObj = {};
			    if (MainStyleConfigStr != "") {
			        MainStyleConfigObj = eval("(" + MainStyleConfigStr + ")");
			    }
		        if (MainStyleConfigObj.OrderFreq){
		            var styleConfigObj = { OrderPackQty: false, OrderDoseQty:true };
		        }else{
			        var styleConfigObj = { OrderDoseQty:false };
			    }
			    var OrderPackUOMStr=GetCellData(rowid, "OrderPackUOMStr");
			    var OrderPackUOMStrArr=OrderPackUOMStr.split(String.fromCharCode(1));
			    OrderPackUOMStr=""+String.fromCharCode(1)+OrderPackUOMStrArr[1]+String.fromCharCode(1)+OrderPackUOMStrArr[0];
			    SetColumnList(rowid, "OrderDoseUOM", OrderPackUOMStr)
			    SetCellData(rowid, "OrderPackQty","");
		    }
	    }else{
		    var styleConfigObj = { OrderPackQty: true, OrderDoseQty:false };
		    ClearOrderFreq(rowid);
		   if ((IsLongPrior(OrderPriorRowid))||(StyleConfigObj.OrderDur==false)) {
			    ClearOrderDur(rowid);
			}
		    SetCellData(rowid, "OrderDoseQty","");
		    SetCellData(rowid, "OrderFirstDayTimes","");
		    SetColumnList(rowid, "OrderDoseUOM", "");
		}
		ChangeCellDisable(rowid, styleConfigObj);
    }
    if ((OrderPHPrescType=="4")&&(OrderType!="R")&&(OrderPriorRowid != GlobalObj.LongOrderPriorRowid)){
	    var SubStyleConfigStr = GetCellData(rowid, "StyleConfigStr");
	    var SubStyleConfigObj = {};
	    if (SubStyleConfigStr != "") {
	        SubStyleConfigObj = eval("(" + SubStyleConfigStr + ")");
	    }
        if (!SubStyleConfigStr.OrderDoseQty){
            ChangeCellDisable(rowid, {OrderPackQty: true,OrderDoseQty:false});
        }
	}
    var Selrowids = GetSelRowId();
    for (var i = Selrowids.length-1; i >=0; i--) {
        if (CheckIsItem(Selrowids[i]) == false) {
	        var Status=$("#jqg_Order_DataGrid_" + Selrowids[i]).prop("checked");
	        if (Status){
            	$("#Order_DataGrid").setSelection(Selrowids[i], false);
            }
        }
    }
}
//�ṩ���ֶ��ı�����Ŀ���
function OrderMasterChangeHandler(e) {
    var rowid = GetEventRow(e);
    if ($.isNumeric(rowid) == false) { return; }
    var RowIdArry = new Array();
    var MasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
    if (MasterSeqNo == "") {
        //ȡ������
        SetMasterSeqNo("", rowid, "C");
        //�Ƿ�ɷ�װ
        var allrowids = GetAllRowId();
        for (var i = 0; i < allrowids.length; i++) {
            var id1 = allrowids[i];
            var ItemRowid1 = GetCellData(id1, "OrderItemRowid");
            if (ItemRowid1 != "") { continue };
            var MasterSeqNo1 = GetCellData(id1, "OrderMasterSeqNo");
            if (MasterSeqNo1!=""){
	             $("#" + id1).find("td").addClass("OrderMasterS");
	             $("#" + MasterSeqNo1).find("td").addClass("OrderMasterM");
	        }else{
		        $("#" + id1).find("td").removeClass("OrderMasterS");
                $("#" + id1).find("td").removeClass("OrderMasterM");
		    }
        }
    } else {
	    	// ��֤�Ƿ�ɹ���
	    var rtn=CheckIsCanSetOrdMasSeqNo(MasterSeqNo,rowid,function(){
			SetMasterSeqNo("", rowid, "C");
			$("#" + rowid).find("td").removeClass("OrderMasterS");
			CheckMasterOrdStyle();
		});
		if (rtn) {
		    //���ù���
	        SetMasterSeqNo(MasterSeqNo, rowid, "S");
        }else {
	        return;
	    }
    }
    CheckMasterOrdStyle();
}
//��ԭ��ҽ������(��Щ������Ҫ���¼���)
function RestoreOrderData(SubID) {
    //��Һ���
    //SetCellData(SubID,"OrderNeedPIVAFlag",false);
    SetPackQty(SubID);
	var OrderType = GetCellData(SubID, "OrderType");
    if (OrderType!="R") {
	    SetCellData(SubID, "OrderInstrRowid","");
	    SetCellData(SubID, "OrderInstr","");
	    SetCellData(SubID, "OrderSpeedFlowRate","");
	    SetCellData(SubID, "OrderFlowRateUnit","")
    	SetCellData(SubID, "OrderFlowRateUnitRowId","")
    	SetCellData(SubID, "OrderLocalInfusionQty","")
	}
    var OrderPackQtyStyleObj = ContrlOrderPackQty(SubID);
    ChangeCellDisable(SubID, OrderPackQtyStyleObj);
}
//ͬ����ҽ������(��Щ������Ҫ���¼���)--�Ա� web.DHCOEOrdItemView�µ�SyncOrderData
function SyncOrderData(MainID, SubID) {
	var RowStyleObj={};
    //�ж����Ƿ��ڱ༭״̬
    var EditStatus = GetEditStatus(SubID);
    //1.ҽ������
    var OldPriorRowid=GetCellData(SubID, "OrderPriorRowid");
    var OrderPriorRowid = GetCellData(MainID, "OrderPriorRowid");
    var OrderPrior = GetCellData(MainID, "OrderPrior");
    /*var OrderPriorRowid = GetCellData(SubID, "OrderPriorRowid");
    var OrderPriorRemarks = GetCellData(SubID, "OrderPriorRemarks");*/
    if (EditStatus == true) {
        SetCellData(SubID, "OrderPrior", OrderPriorRowid);
    } else {
        SetCellData(SubID, "OrderPrior", OrderPrior);
    }
    SetCellData(SubID, "OrderPriorRowid", OrderPriorRowid);
    if (GlobalObj.OrderPriorContrlConfig == 1) {
        var Obj = "";
        if ($.isNumeric(SubID) == true) {
            Obj = document.getElementById(SubID + "_OrderPrior");
        } else {
            Obj = document.getElementById("OrderPrior");
        }
        var HiddenOrderPrior = $("#HiddenOrderPrior").val();
        if ((OrderPriorRowid == GlobalObj.LongOrderPriorRowid)) {
            //ֻ�г���
            var tempOrderPrior = "����ҽ��";
            var tempOrderPriorRowid = GlobalObj.LongOrderPriorRowid;
        }
        if ((OrderPriorRowid == GlobalObj.ShortOrderPriorRowid)) {
            //ֻ����ʱ
            var tempOrderPrior = "��ʱҽ��";
            var tempOrderPriorRowid = GlobalObj.ShortOrderPriorRowid;
        }
        if ((OrderPriorRowid == GlobalObj.OutOrderPriorRowid)) {
            //��Ժ��ҩ
            var tempOrderPrior = "��Ժ��ҩ";
            var tempOrderPriorRowid = GlobalObj.OutOrderPriorRowid;
        }
        if (Obj) {
            ClearAllList(Obj);
            Obj.options[Obj.length] = new Option(tempOrderPrior, tempOrderPriorRowid);
        }
        SetCellData(SubID, "OrderPriorStr", tempOrderPriorRowid + ":" + tempOrderPrior);
    }
    //����ҽ��Ϊ����/��Ժ��ҩҽ��,��ҽ������˵��Ϊȡҩҽ��,�������ҽ������˵��
    var OrderPriorRemarks = GetCellData(SubID, "OrderPriorRemarksRowId");
    if (((OrderPriorRowid == GlobalObj.LongOrderPriorRowid)||(OrderPriorRowid==GlobalObj.OutOrderPriorRowid))&&(OrderPriorRemarks=="ONE")) {
	    SetCellData(SubID, "OrderPriorRemarks","");
	    SetCellData(SubID, "OrderPriorRemarksRowId","");
	}
	OrderPriorchangeCommon(SubID,OldPriorRowid,OrderPriorRowid)
    //2.Ƶ��
    var OrderFreqRowid = GetCellData(MainID, "OrderFreqRowid");
    var OrderFreq = GetCellData(MainID, "OrderFreq");
    var OrderFreqFactor = GetCellData(MainID, "OrderFreqFactor");
    var OrderFreqInterval = GetCellData(MainID, "OrderFreqInterval");
    var OrderFreqDispTimeStr = GetCellData(MainID, "OrderFreqDispTimeStr");
    var SubOrderFreqRowid= GetCellData(SubID, "OrderFreqRowid");
    SetCellData(SubID, "OrderFreq", OrderFreq);
    SetCellData(SubID, "OrderFreqRowid", OrderFreqRowid);
    SetCellData(SubID, "OrderFreqFactor", OrderFreqFactor);
    SetCellData(SubID, "OrderFreqInterval", OrderFreqInterval);
    SetCellData(SubID, "OrderFreqDispTimeStr", OrderFreqDispTimeStr);
    var obj = document.getElementById(SubID + '_OrderFreq');
    if (obj) {
	    $(obj).removeClass("clsInvalid");
	}
    if (SubOrderFreqRowid!=OrderFreqRowid){
	    ChangeOrderFreqTimeDoseStr(SubID);
	}
    //3.�Ƴ�
    var OrderDurRowid = GetCellData(MainID, "OrderDurRowid");
    var OrderDurFactor = GetCellData(MainID, "OrderDurFactor");
    var OrderDur = GetCellData(MainID, "OrderDur");
    /*SetCellData(SubID,"OrderDur",OrderDur);   
    SetCellData(SubID,"OrderDurRowid",OrderDurRowid);
    SetCellData(SubID,"OrderDurFactor",OrderDurFactor);*/
    //4.�÷�
    var OrderInstrRowid = GetCellData(MainID, "OrderInstrRowid");
    var OrderInstr = GetCellData(MainID, "OrderInstr");
    var InstrRowId = GetCellData(SubID, "OrderInstrRowid");
    if (!IsNotFollowInstr(InstrRowId)) {
        SetCellData(SubID, "OrderInstr", OrderInstr);
        SetCellData(SubID, "OrderInstrRowid", OrderInstrRowid);
    }
    //�����÷� ���μ������Ƴ�ӦΪ��
    var OrderInstrRowid = GetCellData(MainID, "OrderInstrRowid")
    if ((IsWYInstr(OrderInstrRowid)) && (GlobalObj.PAAdmType != "I")) {
        SetCellData(SubID, "OrderDoseQty", "");
    }
    var obj = document.getElementById(SubID + '_OrderInstr');
    if (obj) {
	    $(obj).removeClass("clsInvalid");
	}
    var InstrRowId = GetCellData(SubID, "OrderInstrRowid");
    if (IsWYInstr(InstrRowId)) {
        if (GlobalObj.PAAdmType != "I") {
            SetCellData(SubID, "OrderDur", "");
            SetCellData(SubID, "OrderDurRowid", "");
            SetCellData(SubID, "OrderDurFactor", "");
        }
    } else {
        if (!IsWYInstr(OrderInstrRowid)) {
            SetCellData(SubID, "OrderDur", OrderDur);
            SetCellData(SubID, "OrderDurRowid", OrderDurRowid);
            SetCellData(SubID, "OrderDurFactor", OrderDurFactor);
        }
    }
	var obj = document.getElementById(SubID + '_OrderDur');
    if (obj) {
	    $(obj).removeClass("clsInvalid");
	}
    //5.Ƥ��(�����÷�)
    if ((OrderPriorRowid == GlobalObj.LongOrderPriorRowid)&&(GlobalObj.CFSkinTestPriorShort=="1")) {
        SetCellChecked(SubID, "OrderSkinTest", false)
        SetCellData(SubID, "OrderActionRowid", "");
        SetCellData(SubID, "OrderAction", "");
    }
    //Ƥ���÷�,��ҽ��Ƥ�Ա�ʶȡ����ѡ
    //---�ְ汾�޸�ΪƤ���÷��蹴ѡƤ�Ա�־-20200416
    //---�����÷�ΪƤ��ʱ��ע���ж���ý����Ҫ���б仯
    var OrderHiddenPara = GetCellData(SubID, "OrderHiddenPara");
    var NeedSkinTestINCI = mPiece(OrderHiddenPara, String.fromCharCode(1), 7);
    var MainIDOrderHiddenPara = GetCellData(MainID, "OrderHiddenPara");
    var MainIDNeedSkinTestINCI = mPiece(MainIDOrderHiddenPara, String.fromCharCode(1), 7);
    if (GlobalObj.SkinTestInstr != "") {
	    var InstrRowId=GetCellData(SubID, "OrderInstrRowid");
        var Instr = "^" + InstrRowId + "^";
        if ((GlobalObj.SkinTestInstr.indexOf(Instr) != "-1")&&(NeedSkinTestINCI=="Y")) {
	        //SetCellChecked(SubID, "OrderSkinTest", false);
	        SetCellChecked(SubID, "OrderSkinTest", true);
	    }
	    //���������ҽ����Ƥ������������Ƥ��ҽ����Ҫ�����÷��л�
		if (((NeedSkinTestINCI=="Y")||(MainIDNeedSkinTestINCI=="Y"))&&(GlobalObj.SkinTestInstr.indexOf(Instr) != "-1")){
			///
			$.extend(RowStyleObj, {OrderInstr:false});
			
		}
	}
    //6.��ʼ����
    var OrderStartDate = GetCellData(MainID, "OrderStartDate");
    SetCellData(SubID, "OrderStartDate", OrderStartDate);
    //7.��������
    var OrderEndDate = GetCellData(MainID, "OrderEndDate");
    SetCellData(SubID, "OrderEndDate", OrderEndDate);
    //8.��ҽ������
    var OrderDate = GetCellData(MainID, "OrderDate");
    SetCellData(SubID, "OrderDate", OrderDate);
    //9.���մ���
    var OrderFirstDayTimes = GetCellData(MainID, "OrderFirstDayTimes");
    SetCellData(SubID, "OrderFirstDayTimes", OrderFirstDayTimes);
    //10.���¼�������  ��������մ���.���մ�������ҽ������һ�¼���
    var SetPackQtyConfig={
		///�Ƿ���Ҫ�������մ���
		IsNotChangeFirstDayTimeFlag:"Y"
	};
    SetPackQty(SubID,SetPackQtyConfig);
    //11.���տ���
    //12.ͬ�����ٺ͵��ٵ�λ
    var OrderType = GetCellData(SubID, "OrderType");
    var OrderSpeedFlowRate = GetCellData(MainID, "OrderSpeedFlowRate")
    var OrderFlowRateUnitRowId = GetCellData(MainID, "OrderFlowRateUnitRowId")
    var OrderFlowRateUnit = GetCellData(MainID, "OrderFlowRateUnit")
    SetCellData(SubID, "OrderSpeedFlowRate", OrderSpeedFlowRate);
    if (EditStatus == true) {
        SetCellData(SubID, "OrderFlowRateUnit", OrderFlowRateUnitRowId);
    } else {
        SetCellData(SubID, "OrderFlowRateUnit", OrderFlowRateUnit);
    }
    SetCellData(SubID, "OrderFlowRateUnitRowId", OrderFlowRateUnitRowId);
    //13.ͬ����Һ����
    var OrderLocalInfusionQty=GetCellData(MainID, "OrderLocalInfusionQty");
    SetCellData(SubID, "OrderLocalInfusionQty", OrderLocalInfusionQty);
    //���ⳤ��
    var OrderVirtualtLong = GetCellData(MainID, "OrderVirtualtLong");
    if (EditStatus == true) {
        if (OrderVirtualtLong == "Y") { 
        	OrderVirtualtLong = true; 
        } else { 
        	OrderVirtualtLong = false; 
        }
    }
    SetCellChecked(SubID, "OrderVirtualtLong", OrderVirtualtLong);
    ChangeLinkOrderVirtualtLong(SubID,OrderVirtualtLong);
    // SetCellData(SubID, "OrderVirtualtLong", OrderVirtualtLong);
	if (OrderType=="R"){
	    //��Һ���
	    var OrderNeedPIVAFlag = GetCellData(MainID, "OrderNeedPIVAFlag");
	    if (EditStatus == true) {
	        if (OrderNeedPIVAFlag == "Y") { OrderNeedPIVAFlag = true; } else { OrderNeedPIVAFlag = false; }
	        SetCellChecked(SubID, "OrderNeedPIVAFlag", OrderNeedPIVAFlag);
	    }else{
		    if (OrderNeedPIVAFlag=="false") {
			    SetCellData(SubID, "OrderNeedPIVAFlag", "N");
			}else if (OrderNeedPIVAFlag=="true") {
			    SetCellData(SubID, "OrderNeedPIVAFlag", "Y");
			}else{
				SetCellData(SubID, "OrderNeedPIVAFlag", OrderNeedPIVAFlag);
			}
		}
	    //������Һ��ǿ����Ƿ����¼������װ����
	    if ((OrderNeedPIVAFlag) && (OrderNeedPIVAFlag != "N")) {
	        var OrderPackQtyStyleObj = {};
	        var RowDisableStr = GetCellData(MainID, "RowDisableStr");
			if (RowDisableStr!=""){
				var StyleConfigObj = eval("(" + RowDisableStr + ")");
				if (StyleConfigObj) OrderPackQtyStyleObj = { OrderPackQty: StyleConfigObj.OrderPackQty, OrderPackUOM: StyleConfigObj.OrderPackQty }
				SetCellData(SubID, "OrderPackQty", "");
			}
	    } else {
	        var OrderPackQtyStyleObj = ContrlOrderPackQty(SubID);
	    }
	    $.extend(RowStyleObj, OrderPackQtyStyleObj);
    }
    //��λ˵�� ҽ���׶�
    var OrderBodyPartID = GetCellData(MainID, "OrderBodyPartID");
    var OrderBodyPart = GetCellData(MainID, "OrderBodyPart");
    var OrderStageCode = GetCellData(MainID, "OrderStageCode");
    var OrderStage= GetCellData(MainID, "OrderStage");
    SetCellData(SubID, "OrderBodyPart", OrderBodyPartID);
    SetCellData(SubID, "OrderBodyPartID", OrderBodyPartID);
    //ҽ���׶�
    SetCellData(SubID, "OrderStageCode", OrderStageCode);
    var EditStatus = GetEditStatus(SubID);
    //if (UIConfigObj.isEditCopyItem == true) {
	if (EditStatus){
        SetCellData(SubID, "OrderStage", OrderStageCode);
    }else{
        SetCellData(SubID, "OrderStage", OrderStage);
    }
    //����ԭ��
    var ExceedReasonID = GetCellData(MainID, "ExceedReasonID");
    var ExceedReason = GetCellData(MainID, "ExceedReason");
    SetCellData(SubID, "ExceedReasonID", ExceedReasonID);
    SetCellData(SubID, "ExceedReason", ExceedReasonID);
	//��ҽ����
    var OrderDoc=GetCellData(MainID, "OrderDoc");
    var OrderDocRowid=GetCellData(MainID, "OrderDocRowid");
    if (EditStatus){
        SetCellData(SubID, "OrderDoc", OrderDocRowid);
    }else{
        SetCellData(SubID, "OrderDoc", OrderDoc);
    }
    SetCellData(SubID, "OrderDocRowid",OrderDocRowid);
    //�����б�
    var OrderOperation=GetCellData(MainID, "OrderOperation");
    var OrderOperationCode=GetCellData(MainID, "OrderOperationCode");
    if (EditStatus){
        SetCellData(SubID, "OrderOperation", OrderOperationCode);
    }else{
        SetCellData(SubID, "OrderOperation", OrderOperation);
    }
    SetCellData(SubID, "OrderOperationCode",OrderOperationCode);
    ChangeCellDisable(SubID, RowStyleObj);
}
//�зѱ�ı��¼�
function OrderBillTypechangehandler(e) {
    var rowid = GetEventRow(e);
    var oldOrderBillTypeRowid = GetCellData(rowid, "OrderBillTypeRowid");
    var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
    var OrderBillTypeRowid = websys_getSrcElement(e).value;
    var PrescCheck = SelectPrescriptItem(OrderARCIMRowid, OrderBillTypeRowid);
    var OrderName = GetCellData(rowid, "OrderName");
    if (PrescCheck == "") {
        $.messager.alert("����",OrderName + t['LIMIT_PRESCITEM'],"info",function(){
	         SetCellData(rowid, "OrderBillType", oldOrderBillTypeRowid);
	        // �޸ķѱ�֮����Ҫ���¼���ҽ�����
	        CreaterOrderInsurCat(rowid);
	        // ���¼�����������
    		CreaterOrderChronicDiag(rowid);
    		// ���¼�����Ϸ���
		    if (GlobalObj.PAAdmType !="I") {
			    CreaterOrderDIACat(rowid);
			}
	    });
        return false;
    } else {
        // Ĭ�Ϸѱ�ı�
        SetCellData(rowid, "OrderBillType", PrescCheck);
        SetCellData(rowid, "OrderBillTypeRowid", PrescCheck);
    }
    // �޸ķѱ�֮����Ҫ���¼���ҽ�����
    CreaterOrderInsurCat(rowid);
    // ���¼�����������
    CreaterOrderChronicDiag(rowid);
    // ���¼�����Ϸ���
    if (GlobalObj.PAAdmType !="I") {
	    CreaterOrderDIACat(rowid);
	}
}
function CreaterOrderDIACat(rowid){
	var OrderDIACat =GetCellData(rowid, "OrderDIACat");
	var OrderDIACatRowId = GetCellData(rowid, "OrderDIACatRowId");
	var OrderBillTypeRowid = GetCellData(rowid, "OrderBillTypeRowid");
	var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
	var OrderOrderDIACatStr=$.m({
	    ClassName:"web.DHCOEOrdItemView",
	    MethodName:"GetOrderOrderDIACatStr",
	    EpisodeID:GlobalObj.EpisodeID,
	    ArcimRowid:OrderARCIMRowid,
	    OrderBillTypeRowid:OrderBillTypeRowid
	},false);
	SetColumnList(rowid, "OrderDIACat", OrderOrderDIACatStr);
	SetCellData(rowid, "idiagnoscatstr", OrderOrderDIACatStr);
	if (OrderDIACatRowId !=""){
		var  FindFlag="N"
		for (var i=0;i<OrderOrderDIACatStr.split(String.fromCharCode(2));i++){
			var OneOrderDIACatStr = OrderOrderDIACatStr.split(String.fromCharCode(2))[i];
			var OneOrderDIACatRowId = OneOrderDIACatStr.split(String.fromCharCode(1))[0];
			if (OrderDIACatRowId == OneOrderDIACatRowId){
				FindFlag="Y"
			}
		}
		if (FindFlag == "Y") {
			 SetCellData(rowid, "OrderDIACat",OrderDIACat);
			 SetCellData(rowid, "OrderDIACatRowId",OrderDIACatRowId);
		}else{
			SetCellData(rowid, "OrderDIACat","");
			SetCellData(rowid, "OrderDIACatRowId","");
		
		}
	}
}
function CreaterOrderChronicDiag(rowid){
	var OrderChronicDiagCode = GetCellData(rowid, "OrderChronicDiagCode");
	var OrderChronicDiag = GetCellData(rowid, "OrderChronicDiag");
	var OrderBillTypeRowid = GetCellData(rowid, "OrderBillTypeRowid");
	var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
	var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
	var OrderARCIMCode=OrderHiddenPara.split(String.fromCharCode(1))[11];
	var OrderChronicDiagStr=$.m({
	    ClassName:"web.DHCOEOrdItemView",
	    MethodName:"GetOrderChronicDiagStr",
	    Adm:GlobalObj.EpisodeID,
	    ArcimCode:OrderARCIMCode,
	    OrderBillTypeRowid:OrderBillTypeRowid
	},false);
	SetColumnList(rowid, "OrderChronicDiag", OrderChronicDiagStr);
	SetCellData(rowid, "OrderChronicDiagStr",OrderChronicDiagStr);
	if (OrderChronicDiagCode !="") {
		var  FindFlag="N"
		for (var i=0;i<OrderChronicDiagStr.split(String.fromCharCode(2));i++){
			var OneChronicDiagStr = OrderChronicDiagStr.split(String.fromCharCode(2))[i];
			var OneChronicDiagCode = OneChronicDiagStr.split(String.fromCharCode(1))[0];
			if (OrderChronicDiagCode == OneChronicDiagCode){
				FindFlag="Y"
			}
		}
		if (FindFlag == "Y") {
			 SetCellData(rowid, "OrderChronicDiagCode",OrderChronicDiagCode);
			 SetCellData(rowid, "OrderChronicDiag",OrderChronicDiag);
		}else{
			SetCellData(rowid, "OrderChronicDiagCode","");
			SetCellData(rowid, "OrderChronicDiag","");
		}
	}
}
//Ƶ�θı�
function FrequencyChangeHandler(e) {
    try {
	    //Ϊ�˷�ֹ��chrome�£������lookup�Ľ���ת���¼������������������ظ�����weekѡ����¼�
        if (PageLogicObj.LookupPanelIsShow==1) {
            return
        }
    } catch (e) {}
    
    var rowid = GetEventRow(e);
    PHCFRDesc_changehandlerX(rowid);
    return;
}

//ҽ�����͸ı����  change
function OrderPriorChange(e) {
    //$.messager.alert("����",this.id);
    var rowid = "";
    var obj = websys_getSrcElement(e);
    var rowid = GetEventRow(e);
    //�ı��������  OrderPriorId
    var OldPriorRowid = GetCellData(rowid, "OrderPriorRowid");
    var PriorRowid = obj.value;
    /*
    //�ж��Ѿ����˳�Ժҽ�������Ѿ�ҽ�ƽ���Ĳ��ܿ�����Ժ��ҩ�����ҽ��
    if ((GlobalObj.PAADMMedDischarged=="1")&&(PriorRowid!=GlobalObj.OutOrderPriorRowid)){
        dhcsys_alert(t['IsEstimDischarge']);
        DeleteRow(rowid);
        return false;
    }
    */
    if (GlobalObj.SkinTestInstr != "") {
	    var OrderInstrRowid=GetCellData(rowid, "OrderInstrRowid");
        var Instr = "^" + OrderInstrRowid + "^"
        if ((GlobalObj.SkinTestInstr.indexOf(Instr) != "-1")) {
            if (PriorRowid == GlobalObj.LongOrderPriorRowid){
	            $.messager.alert("��ʾ","Ƥ���÷�����ѡ����ҽ��!","info",function(){
		            SetCellData(rowid, "OrderPriorRowid", OldPriorRowid);
		            SetCellData(rowid, "OrderPrior", OldPriorRowid);
		        });
	            return false;
	        }
        }
    }
    var OrderPriorRemarksRowId=GetCellData(rowid, "OrderPriorRemarksRowId")
    if (OrderPriorRemarksRowId==""){
	    var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
        var PHCDFCQZTFlag = mPiece(OrderHiddenPara, String.fromCharCode(1), 12);
        var PHCDFONEFlag = mPiece(OrderHiddenPara, String.fromCharCode(1), 13);
        if ((PriorRowid==GlobalObj.LongOrderPriorRowid)&&(PHCDFCQZTFlag=="Y")){
	        SetCellData(rowid, "OrderPriorRemarksRowId", "ZT");
	        SetCellData(rowid, "OrderPriorRemarks", "ZT");
	    }
	    if ((PriorRowid==GlobalObj.ShortOrderPriorRowid)&&(PHCDFONEFlag=="Y")&&(GlobalObj.PAAdmType=="I")){
	        SetCellData(rowid, "OrderPriorRemarksRowId", "ONE");
	        SetCellData(rowid, "OrderPriorRemarks", "ONE");
		}
	}
    OrderPriorchangeCommon(rowid,OldPriorRowid,PriorRowid);
}
//TODO �����߼��϶�,�����ٶ���,���Ż�
//�˷���Ϊҽ�����ȼ��ı䷽����������ȼ��ޱ仯����ֱ���˳�;
function OrderPriorchangeCommon(Row,OldPriorRowid,PriorRowid,callBackFun) {
    if (OldPriorRowid==PriorRowid) {
	    if (callBackFun) callBackFun();
	    return;
	}
    var ParaPriorRowid=PriorRowid;
    var OrderItemRowid = GetCellData(Row, "OrderItemRowid");
    var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
    if ((OrderItemRowid != "")) return; //(OrderARCIMRowid == "") || 

    var RowStyleObj = {};
    SetCellData(Row, "OrderPriorRowid", PriorRowid);
    
	//��Ժ��ҩ��ո���˵��
    if (PriorRowid == GlobalObj.OutOrderPriorRowid) {
        SetCellData(Row, "OrderPriorRemarksRowId", "");
        SetCellData(Row, "OrderPriorRemarks", "");
    }
	if (PriorRowid != GlobalObj.ShortOrderPriorRowid) {
        var OrderPriorRemarks = GetCellData(Row, "OrderPriorRemarksRowId");
        if (OrderPriorRemarks == "ONE") {
            var OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
            var OrderMasterSeqNo = GetCellData(Row, "OrderMasterSeqNo");
            SetCellData(Row, "OrderPriorRemarks", "");
            SetCellData(Row, "OrderPriorRemarksRowId", "");
        }
        // ����ʱҽ���Ӽ����ɹ�ѡ
        SetCellChecked(Row, "Urgent", false);
        var obj = { Urgent: false };
        $.extend(RowStyleObj, obj);
    }else{
	    var OrderHiddenPara=GetCellData(Row,"OrderHiddenPara");
	    var EmergencyFlag = mPiece(OrderHiddenPara, String.fromCharCode(1), 25);
	    var ARCIMDefSensitive = mPiece(OrderHiddenPara, String.fromCharCode(1), 26);
	    if (EmergencyFlag =="Y") {
		    var obj = { Urgent: true };
        	$.extend(RowStyleObj, obj);
		}
		if (ARCIMDefSensitive =="Y") SetCellChecked(Row, "Urgent", true);
	}
	var OrderPriorRemarks = GetCellData(Row, "OrderPriorRemarksRowId");
	var OrderPHPrescType = GetCellData(Row, "OrderPHPrescType");
	var OrderType = GetCellData(Row, "OrderType");
    var OrderFreqRowid = GetCellData(Row, "OrderFreqRowid")
    if ((PriorRowid == GlobalObj.LongOrderPriorRowid) && ((OrderFreqRowid == GlobalObj.STFreqRowid) || (OrderFreqRowid == GlobalObj.ONCEFreqRowid))) {
        SetCellData(Row, "OrderFreqRowid", "");
        SetCellData(Row, "OrderFreq", "");
    }
    if (GlobalObj.PAAdmType == "I") {
        if ((PriorRowid != GlobalObj.LongOrderPriorRowid) && (PriorRowid != GlobalObj.OutOrderPriorRowid) && ((OrderFreqRowid != GlobalObj.STFreqRowid) || (OrderFreqRowid == GlobalObj.ONCEFreqRowid))) {
            SetCellData(Row, "OrderFreqRowid", GlobalObj.IPShortOrderPriorDefFreqRowId);
            SetCellData(Row, "OrderFreq", GlobalObj.IPShortOrderPriorDefFreq);
        }
    }

    if (
    	(GlobalObj.PAAdmType == "I")&&
    	((PriorRowid == GlobalObj.ShortOrderPriorRowid) || (PriorRowid == GlobalObj.OMOrderPriorRowid))
    	) {
        if ((OrderFreqRowid != GlobalObj.STFreqRowid) && (OrderFreqRowid != GlobalObj.ONCEFreqRowid)&&
        	((OrderPHPrescType == 4) || (OrderType == "R"))&&(GlobalObj.IPShortOrderPriorDefFreqRowId != "")
        	){
		    SetCellData(Row, "OrderFreqRowid", GlobalObj.IPShortOrderPriorDefFreqRowId);
            SetCellData(Row, "OrderFreq", GlobalObj.IPShortOrderPriorDefFreq);
	    }else{
		    if ((OrderFreqRowid != GlobalObj.STFreqRowid) && (OrderFreqRowid != GlobalObj.ONCEFreqRowid)) {
				ClearOrderFreq(Row);
			}
		}
        
    }else if ((PriorRowid == GlobalObj.STATOrderPriorRowid) && (GlobalObj.PAAdmType == "I")) {
	    if (OrderFreqRowid != GlobalObj.STFreqRowid){
		    ClearOrderFreq(Row);
	        SetCellData(Row, "OrderFreqRowid", GlobalObj.STFreqRowid);
	        SetCellData(Row, "OrderFreq", GlobalObj.STFreq);
	    }
    }
    if ((!IsLongPrior(PriorRowid))&&(PriorRowid != GlobalObj.OutOrderPriorRowid)){
    	SetCellData(Row, "OrderFreqTimeDoseStr","");
    	var DoseQtyStr=GetCellData(Row, "OrderDoseQty");
    	if (DoseQtyStr.split("-").length>1){
	    	SetCellData(Row, "OrderDoseQty",mPiece(DoseQtyStr,"-",0));
	    }
    }
    
    var VerifiedOrderFlag=0;
    //��ʿ��¼ҽ�����й�������
    if ((OrderARCIMRowid!="")&&(VerifiedOrderObj) && (VerifiedOrderObj.LinkedMasterOrderFreRowId != "undefined") && (VerifiedOrderObj.LinkedMasterOrderFreRowId != "")) {
        SetCellData(Row, "OrderFreqRowid", VerifiedOrderObj.LinkedMasterOrderFreRowId);
        SetCellData(Row, "OrderFreq", VerifiedOrderObj.LinkedMasterOrderFreDesc);
        SetCellData(Row, "OrderFreqFactor", VerifiedOrderObj.LinkedMasterOrderFreFactor);
        SetCellData(Row, "OrderFreqInterval", VerifiedOrderObj.LinkedMasterOrderFreInterval);
        VerifiedOrderFlag=1;
    }
    SetRecLocStr(Row, PriorRowid, OrderPriorRemarks);

    if ((PriorRowid == GlobalObj.OutOrderPriorRowid) || (OrderPriorRemarks == "ONE") || (PriorRowid == GlobalObj.OneOrderPriorRowid)) {
        //SetPackQty(Row);
    }
    var OrderMasterSeqNo = GetCellData(Row, "OrderMasterSeqNo")
    var OrderSeqNo = GetCellData(Row, "id");
    var OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
    var OrderMasterPHPrescType="";
    var OrderMasterOrderType="";
    if (OrderMasterSeqNo!=""){
		var rowids = GetAllRowId();
		for (var i = 0; i < rowids.length; i++) {
		    var OrderSeqNoMasterLink = GetCellData(rowids[i], "id");
		    if (OrderSeqNoMasterLink == OrderMasterSeqNo) {
		    	OrderMasterPHPrescType=GetCellData(rowids[i], "OrderPHPrescType");
				OrderMasterOrderType= GetCellData(rowids[i], "OrderType");
		    	break;
		    }
		}
	}
    //�Ƴ������Ϊ����ҽ���������޸��Ƴ�,��������
    if ((OrderARCIMRowid != "") && (OrderItemRowid == "")) {
        
        if (OrderType == "R") {
            var Id = Row + "_OrderFirstDayTimes";
            var obj = document.getElementById(Id);
            if ((PriorRowid == GlobalObj.LongOrderPriorRowid) || (PriorRowid == GlobalObj.OMSOrderPriorRowid)) {
                var obj = { OrderFirstDayTimes: true };
                $.extend(RowStyleObj, obj);
            } else {
                //������մ���
                var obj = { OrderFirstDayTimes: true }; //false
                SetCellData(Row, "OrderFirstDayTimes", "");
                $.extend(RowStyleObj, obj);
            }
        }else{
	        if (IsLongPrior(PriorRowid)) {
		        var StyleConfigStr = GetCellData(Row, "StyleConfigStr");
			    var StyleConfigObj = {};
			    if (StyleConfigStr != "") {
			        StyleConfigObj = eval("(" + StyleConfigStr + ")");
			    }
			    var OrderPHPrescType = GetCellData(Row, "OrderPHPrescType");
		        if ((OrderPHPrescType=="4")||(OrderMasterPHPrescType=="4")||(OrderMasterOrderType=="R")){
			        var obj = { OrderDoseQty: true };
	            }else{
		            SetCellData(Row, "OrderDoseQty", "");
	                var obj = { OrderDoseQty: false };
	            }
	            $.extend(RowStyleObj, obj);
		    }else{
			    SetCellData(Row, "OrderDoseQty", "");
				$.extend(RowStyleObj, { OrderDoseQty: false });
			}
	    }
	    var CureItemStyleObj=CheckCureItemConfig(Row);
		$.extend(RowStyleObj, CureItemStyleObj);
        var Id = Row + "_OrderDur";
        var OrderPriorRemarks = GetCellData(Row, "OrderPriorRemarksRowId");
		if (GlobalObj.PAAdmType == "I"){
			var obj = { OrderDur: false };
			if (IsLongPrior(PriorRowid)){
				ClearOrderDur(Row);
			}else if (PriorRowid==GlobalObj.OutOrderPriorRowid){
				var obj = { OrderDur: true };
			}else{
				var OrderDur = GlobalObj.IPDefaultDur;
	            var OrderDurRowid = GlobalObj.IPDefaultDurRowId;
	            var OrderDurFactor = GlobalObj.IPDefaultDurFactor;
	            SetCellData(Row, "OrderDur", OrderDur);
	            SetCellData(Row, "OrderDurRowid", OrderDurRowid);
	            SetCellData(Row, "OrderDurFactor", OrderDurFactor);
			}
			$.extend(RowStyleObj, obj);
		}
       
		var OrderType = GetCellData(Row, "OrderType");
		var OrderHiddenPara = GetCellData(Row, "OrderHiddenPara");
        var OrderItemCatRowid = mPiece(OrderHiddenPara, String.fromCharCode(1), 2);
		var RecDepRowid = GetCellData(Row, "OrderRecDepRowid");
		///����ҽ����ʼʱ��
		SetDosingDateTime(Row,{OrderPriorRowid:PriorRowid,OrderType:OrderType,OrderItemCatRowid:OrderItemCatRowid},RecDepRowid);
		//��������صĿ��Ƽ���д�������ContrlOrderPackQty�tanjishan2019.10.29
        //������-
        SetPackQty(Row);
        //�������Ʒŵ����
        var OrderPackQtyObj = ContrlOrderPackQty(Row);
        //$.messager.alert("����",OrderPackQtyObj.OrderPackQty);
        $.extend(RowStyleObj, OrderPackQtyObj);
    }
    if (PriorRowid != GlobalObj.ShortOrderPriorRowid) {
        if (GlobalObj.CFSkinTestPriorShort == 1) {
            if (GetEditStatus(Row) == true) {
                SetCellData(Row, "OrderSkinTest", false);
            }else{
                SetCellData(Row, "OrderSkinTest", "N");
            }
            var ActionRowid = GetCellData(Row, "OrderActionRowid");
            var ActionCode = GetOrderActionCode(ActionRowid);
            if (ActionCode == "YY") {
                SetCellData(Row, "OrderActionRowid", "");
                SetCellData(Row, "OrderAction", "");
            }
        }
    }
    OrderMasterSeqNo = GetCellData(Row, "OrderMasterSeqNo");
    if (OrderMasterSeqNo != "") {
	     var obj = { OrderFirstDayTimes: false };
         $.extend(RowStyleObj, obj);
        ChangeCellsDisabledStyle(Row, false);
    }
    var OrderPrior = GetCellData(Row, "OrderPrior");
    var OrderStartDateStr = GetCellData(Row, "OrderStartDate");
    if (OrderStartDateStr != "") {
        OrderStartDate = OrderStartDateStr.split(" ")[0];
        OrderStartTime = OrderStartDateStr.split(" ")[1];
    }
    //�ı䵥Ԫ���Ƿ�ɱ༭
    ChangeRowStyle(Row, RowStyleObj);
    SetFocusCell(Row, "OrderName");
    ChangeLinkOrderPrior(OrderSeqNo, OrderPriorRowid, OrderStartDate, OrderStartTime, OrderPrior);
    new Promise(function(resolve,rejected){
	    //Ƶ�θı�
	    if ((VerifiedOrderFlag==0)&&(ParaPriorRowid!=OldPriorRowid)){
	        PHCFRDesc_changehandlerX(Row,resolve);
	    }else{
	        //ͬ�����մ���
	       SetOrderFirstDayTimes(Row);
	       resolve();
	    }
	}).then(function(){
		var OrderSeqNo = GetCellData(Row, "id");
		var MasterOrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
	    var MasterOrderPrior = GetCellData(Row, "OrderPrior");
	    var OrderFreqRowid = GetCellData(Row, "OrderFreqRowid");
	    var OrderFreq = GetCellData(Row, "OrderFreq");
	    var OrderFreqFactor = GetCellData(Row, "OrderFreqFactor");
	    var OrderFreqDispTimeStr = GetCellData(Row, "OrderFreqDispTimeStr");
	    var OrderFreqInterval = GetCellData(Row, "OrderFreqInterval");
	    //����Ƶ�θı�
	    ChangeLinkOrderFreq(OrderSeqNo,MasterOrderPriorRowid,MasterOrderPrior,OrderFreqRowid,OrderFreq,OrderFreqFactor,OrderFreqInterval,OrderFreqDispTimeStr,OrderStartDateStr,callBackFun);
		//����û��Ҫ���ظ����þ���change�����ܻᵼ���ظ�����SetPackQty-tanjishan2019.10.29
	    //CancelNeedPIVA(Row)
	})
}
//���μ����ı����
function OrderDoseQtychangehandler(e) {
    try {
        var rowid = "";
        var obj = websys_getSrcElement(e);
        if (obj.id.indexOf("_") > 0) {
            rowid = obj.id.split("_")[0];
        }
        var OrderType = GetCellData(rowid, "OrderType");
        var OrderDoseQty = GetCellData(rowid, "OrderDoseQty");
        OrderDoseQty=eval(OrderDoseQty);
        SetCellData(rowid,"OrderDoseQty",OrderDoseQty);
        var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
		var OrderName=GetCellData(rowid, "OrderName");
		if ((OrderDoseQty != '')&&(isNumber(OrderDoseQty) == false))  {
        	$.messager.alert("����",OrderName + t['NO_DoseQty'],"info",function(){
	        	SetFocusCell(rowid, "OrderDoseQty");
	        });
       	 	//EditRow(Row);
        	return false;
    	}
		if ((OrderDoseQty!="")&&(parseFloat(OrderDoseQty) < 0) ) {
			$.messager.alert("����",OrderName + "��������Ϊ����","info",function(){
	        	SetFocusCell(rowid, "OrderDoseQty");
	        });
        	return false;
    	}
        //if ((OrderType=="R")&&(OrderDoseQty!="")&&(OrderARCIMRowid!="")){
        //���ڷ�ҩƷ��������Ŀ
        if ((OrderDoseQty != "") && (OrderARCIMRowid != "")) {
	        var SetPackQtyConfig={
				///�Ƿ���Ҫ��������װ��
				IsNotNeedChangeFlag:undefined,
				///�Ƿ���Ҫ�������մ���
				IsNotChangeFirstDayTimeFlag:undefined
			};
			
			var OrderFirstDayTimes=GetCellData(rowid, "OrderFirstDayTimes");
			if (OrderFirstDayTimes!=""){
				SetPackQtyConfig.IsNotChangeFirstDayTimeFlag="Y";
			}
            SetPackQty(rowid,SetPackQtyConfig);
            //websys_setfocus("OrderMasterSeqNoz"+Row);
        } else {
            //websys_setfocus("OrderPackQtyz"+Row);
        }
        XHZY_Click();
    } catch (e) {}
}
function OrderDoseQtykeyuphandler(e){
	try { keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
	try { 
		var rowid = GetEventRow(e);
		if(keycode == 38){
			var OrderDoseQty = GetCellData(rowid, "OrderDoseQty");
			var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
            var OrderDoseQtyNew = +mPiece(OrderHiddenPara, String.fromCharCode(1), 16);
            if (OrderDoseQty.indexOf("-")>=0) {
	            var OrderFreqTimeDoseStr=GetCellData(rowid, "OrderFreqTimeDoseStr");
	            var OrderFreqTimeDoseArr=OrderFreqTimeDoseStr.split("!");
	            var NewOrderDoseQtyStr="",NewOrderFreqTimeDoseStr="";
	            for (var i=0;i<OrderDoseQty.split("-").length;i++) {
		            var tmpOrderDoseQty=(+OrderDoseQty.split("-")[i])+OrderDoseQtyNew;
		            if (NewOrderDoseQtyStr=="") {
			            NewOrderDoseQtyStr=tmpOrderDoseQty;
			            NewOrderFreqTimeDoseStr=OrderFreqTimeDoseArr[i].split("$")[i]+"$"+tmpOrderDoseQty;
			        }else{
				        NewOrderDoseQtyStr=NewOrderDoseQtyStr+"-"+tmpOrderDoseQty;
				        NewOrderFreqTimeDoseStr=NewOrderFreqTimeDoseStr+"!"+OrderFreqTimeDoseArr[i].split("$")[0]+"$"+tmpOrderDoseQty;
				    }
		        }
		        SetCellData(rowid, "OrderDoseQty",NewOrderDoseQtyStr);
		        SetCellData(rowid, "OrderFreqTimeDoseStr",NewOrderFreqTimeDoseStr);
	        }else{
				//if ((OrderDoseQty+OrderDoseQtyNew)/OrderDoseQtyNew<10){
					SetCellData(rowid, "OrderDoseQty",((+OrderDoseQty)+OrderDoseQtyNew));
					OrderDoseQtychangehandler()
					return false;
				//}else {
					//$.messager.alert("����","���μ������ô���ҩѧ���õ��μ�����10����")
				//}
			}
			return websys_cancel();
	    }else if(keycode == 40){
			var OrderDoseQty = GetCellData(rowid, "OrderDoseQty");
			var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
            var OrderDoseQtyNew = +mPiece(OrderHiddenPara, String.fromCharCode(1), 16);
            if (OrderDoseQty.indexOf("-")>=0) {
	            var OrderFreqTimeDoseStr=GetCellData(rowid, "OrderFreqTimeDoseStr");
	            var OrderFreqTimeDoseArr=OrderFreqTimeDoseStr.split("!");
	            var NewOrderDoseQtyStr="",NewOrderFreqTimeDoseStr="";
	            for (var i=0;i<OrderDoseQty.split("-").length;i++) {
		            if (((+OrderDoseQty.split("-")[i])-OrderDoseQtyNew)<=0) return;
		            var tmpOrderDoseQty=(+OrderDoseQty.split("-")[i])-OrderDoseQtyNew;
		            if (NewOrderDoseQtyStr=="") {
			            NewOrderDoseQtyStr=tmpOrderDoseQty;
			            NewOrderFreqTimeDoseStr=OrderFreqTimeDoseArr[i].split("$")[i]+"$"+tmpOrderDoseQty;
			        }else{
				        NewOrderDoseQtyStr=NewOrderDoseQtyStr+"-"+tmpOrderDoseQty;
				        NewOrderFreqTimeDoseStr=NewOrderFreqTimeDoseStr+"!"+OrderFreqTimeDoseArr[i].split("$")[0]+"$"+tmpOrderDoseQty;
				    }
		        }
		        SetCellData(rowid, "OrderDoseQty",NewOrderDoseQtyStr);
		        SetCellData(rowid, "OrderFreqTimeDoseStr",NewOrderFreqTimeDoseStr);
	        }else{
				if (((+OrderDoseQty)-OrderDoseQtyNew)>0){
					SetCellData(rowid, "OrderDoseQty",(+OrderDoseQty)-OrderDoseQtyNew);
					OrderDoseQtychangehandler();
					return false;
				}else {
					$.messager.alert("��ʾ","���μ�������С�ڵ���0��","info",function(){
						SetFocusCell(rowid, "OrderDoseQty");
					})
					return false;
				}
			}
			return websys_cancel();
	    }
	} catch (e) {}
}
function OrderDoseQtykeydownhandler(e) {
    try { keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
    try {
        if ((keycode == 13) || (keycode == 9)) {
            var rowid = GetEventRow(e);
            var OrderType = GetCellData(rowid, "OrderType");
            var OrderDoseQty = GetCellData(rowid, "OrderDoseQty");
            var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
            if (OrderARCIMRowid != "") {
                if (OrderType == "R") {
                    XHZY_Click();
                    SetFocusCell(rowid, "OrderMasterSeqNo")
                } else {
                    var OrderPHPrescType = GetCellData(rowid, "OrderPHPrescType");
                    if (OrderPHPrescType != "4") {
                        //����ҽ����������¼��,������Ҫ������ת����һ��
                        var type = "";
                        if (window.event) type = websys_getType(e);
                        if (type != 'change') {
                            var JumpAry = ['OrderPackQty'];
                            CellFocusJump(rowid, JumpAry, true);
                        }
                    } else {
                        SetFocusCell(rowid, "OrderFreq")
                    }
                }
            }
            return websys_cancel();
        }else{
            if (((keycode >= 46) && (keycode < 58))||(keycode==42)||(keycode==106)) {} else {
                window.event.keyCode = 0;
                return websys_cancel();
            }
        }
    } catch (e) {}
}

function OrderPricechangehandler(e) {
	var rowid = "";
    var obj = websys_getSrcElement(e);
    if (obj.id.indexOf("_") > 0) {
        rowid = obj.id.split("_")[0];
    }
	var OrderPrice=GetCellData(rowid,"OrderPrice");
	if ($.isNumeric(OrderPrice) == true) {
		OrderPackQtychangehandler(e)
	}else{
		$.messager.alert("��ʾ","����Ϊ������,���޸�!","info",function(){
			SetFocusCell(rowid, "OrderPrice")
		});
		return false;
	}
}
//�����ı����
function OrderPackQtychangehandler(e) {
    var rowid = "";
    var obj = websys_getSrcElement(e);
    if (obj.id.indexOf("_") > 0) {
        rowid = obj.id.split("_")[0];
    }
    OrderPackQtychangeCommon(rowid);
}
function OrderPackQtychangeCommon(rowid) {
    try {
        var OrderPackQty = GetCellData(rowid, "OrderPackQty");
        var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
        var OrderItemRowid = GetCellData(rowid, "OrderItemRowid");
        var OrderPriorRowid = GetCellData(rowid, "OrderPriorRowid");

        if (OrderPackQty == "") { OrderPackQty = 0 }
        if(isNaN(OrderPackQty)){
	        OrderPackQty=0;
	    }
        if ((OrderARCIMRowid != "") && (OrderItemRowid == "")) {
            var OrderPrice = GetCellData(rowid, "OrderPrice");
            var OrderSum = parseFloat(OrderPrice) * parseFloat(OrderPackQty);
            if (OrderPackQty == 0) {
                var BaseDoseQtySum = GetCellData(rowid, "OrderBaseQtySum");
                var OrderConFac = GetCellData(rowid, "OrderConFac");
                var OrderSum = (parseFloat(OrderPrice) / parseFloat(OrderConFac)) * parseFloat(BaseDoseQtySum);
            }
            OrderSum = OrderSum.toFixed(4);
            //��������
            SetOrderUsableDays(rowid)
                //������Ա�ҩҽ�������ټ�����
                //$.messager.alert("����",OrderPriorRowid+","+GlobalObj.OMOrderPriorRowid+","+GlobalObj.OMSOrderPriorRowid);
            if ((OrderPriorRowid != GlobalObj.OMOrderPriorRowid) && (OrderPriorRowid != GlobalObj.OMSOrderPriorRowid)) {
                SetCellData(rowid, "OrderSum", OrderSum);
                SetScreenSum();
                //SetFooterData();
            }
        }
        XHZY_Click();
    } catch (e) {}
}
function OrderPackQtykeydownhandler(e) {
    try { keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
    if ((keycode == 8) || (keycode == 9) || (keycode == 46) || (keycode == 13) || ((keycode > 47) && (keycode < 58)) || ((keycode > 95) && (keycode < 106))) {
        var rowid = "";
        var obj = websys_getSrcElement(e);
        if (obj.id.indexOf("_") > 0) {
            rowid = obj.id.split("_")[0];
        }
        if (keycode==46){
	       var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
	       if (OrderARCIMRowid!=""){
		       var SubCatID = cspRunServerMethod(GlobalObj.GetARCItemSubCatID, '', '', OrderARCIMRowid);
		       var AllowEntryDecimalItemCatStr = "^" + GlobalObj.AllowEntryDecimalItemCat + "^";
			   if ((AllowEntryDecimalItemCatStr.indexOf("^" + SubCatID + "^")) == -1) {
				   return websys_cancel();
			   }
		    } 
	    }
		try {
            if ((keycode == 13) || (keycode == 9)) {
                var OrderARCOSRowId = GetCellData(rowid, "OrderARCOSRowId");
                var rowsobj = $('#Order_DataGrid').getDataIDs();
                var rows = rowsobj.length;
                var RowNext = GetNextRowId();
                if ((GlobalObj.FindARCOSInputByLogonLoc == 1) && (OrderARCOSRowId != '') && (rows != RowNext)) {
                    SetFocusCell(RowNext, "OrderPackQty");
                    return websys_cancel();
                } else {
                    window.event.keyCode = 0;
                    var OrderInstrRowid = GetCellData(rowid, "OrderInstrRowid");
                    var OrderPackQty = GetCellData(rowid, "OrderPackQty");
                    var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
                    var OrderType = GetCellData(rowid, "OrderType");
                    if (OrderARCIMRowid != "") {
                        if ((GlobalObj.DrippingSpeedInstr).indexOf("^"+OrderInstrRowid+"^")>=0) {
	                         SetFocusCell(rowid, "OrderSpeedFlowRate");
                    		 return websys_cancel();
	                    }
                        if ((GlobalObj.PAAdmType == "I") || ((GlobalObj.PAAdmType != "I") && (OrderPackQty != ""))) {
                            window.setTimeout("Add_Order_row()", 200);
                        }
                    }
                }
                return websys_cancel();
            }
        } catch (e) {}
    } else {
        return websys_cancel();
    }
}
//������λ�ı����
function OrderDoseUOMchangehandler(e) {
    //$.messager.alert("����",this.id);
    var rowid = "";
    var obj = websys_getSrcElement(e);
    if (obj.id.indexOf("_") > 0) {
        rowid = obj.id.split("_")[0];
    }
    //�ı��������  OrderPriorId
    SetCellData(rowid, "OrderDoseUOMRowid", obj.value);
    SetCellData(rowid, "OrderDoseUOM", obj.value);
    var SetPackQtyConfig={
		///�Ƿ���Ҫ��������װ��
		IsNotNeedChangeFlag:undefined,
		///�Ƿ���Ҫ�������մ���
		IsNotChangeFirstDayTimeFlag:undefined
	};
	var OrderFirstDayTimes=GetCellData(rowid, "OrderFirstDayTimes");
	if (OrderFirstDayTimes!=""){
		SetPackQtyConfig.IsNotChangeFirstDayTimeFlag="Y";
	}
    SetPackQty(rowid,SetPackQtyConfig);
    var idoseqtystr=GetCellData(rowid, "idoseqtystr");
    if (idoseqtystr!=""){
	    var ArrData = idoseqtystr.split(String.fromCharCode(2));
        for (var i = 0; i < ArrData.length; i++) {
            var ArrData1 = ArrData[i].split(String.fromCharCode(1));
            var DefaultDoseQty = ArrData1[0];
            var DefaultDoseUOMRowid = ArrData1[2];
            if (DefaultDoseUOMRowid==obj.value){
	            var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara"); 
	            var Arr=OrderHiddenPara.split(String.fromCharCode(1));
	            Arr.splice(16,1,DefaultDoseQty);
	            SetCellData(rowid, "OrderHiddenPara",Arr.join(String.fromCharCode(1)));
	            break;
	        }
        }
	}
	SetFocusCell(rowid, "OrderDoseQty");
}
//����˵���ı����
function OrderPriorRemarkschangehandler(e) {
    //$.messager.alert("����",this.id);
    var rowid = "";
    var obj = websys_getSrcElement(e);
    if (obj.id.indexOf("_") > 0) {
        rowid = obj.id.split("_")[0];
    }
    var OldOrderPriorRemarksRowId=GetCellData(rowid, "OrderPriorRemarksRowId");
    var OrderPriorRemarksRowId = obj.value;
    OrderPriorRemarkschangeCommon(rowid,OldOrderPriorRemarksRowId,OrderPriorRemarksRowId);
}
function OrderPriorRemarkschangeCommon(rowid,OldOrderPriorRemarksRowId,OrderPriorRemarksRowId){
    if (OrderPriorRemarksRowId=="ONE"){
	    var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
	    if ((OrderMasterSeqNo != "")||($("#" + rowid).find("td").hasClass("OrderMasterM"))){
		    $.messager.alert("��ʾ","����ҽ������Ϊȡҩҽ��!","info",function(){
			     SetCellData(rowid, "OrderPriorRemarksRowId", OldOrderPriorRemarksRowId);
    			 SetCellData(rowid, "OrderPriorRemarks", OldOrderPriorRemarksRowId);
			})
		    return false;
		}
	}
	var OrderVirtualtLong=GetCellData(rowid, "OrderVirtualtLong");
	var OrderHiddenPara=GetCellData(rowid,"OrderHiddenPara");
	//�ɲ�ַ�ҩ�Ľ��ܿ��Ҵ�
	var NormSplitPackQtyPHRecLocList = mPiece(OrderHiddenPara, String.fromCharCode(1), 24);
	var OrderRecDepRowid = GetCellData(rowid, "OrderRecDepRowid");
	var NormSplitPackQty=0
	if ((NormSplitPackQtyPHRecLocList!="")&&(("!"+NormSplitPackQtyPHRecLocList+"!").indexOf("!"+OrderRecDepRowid+"!")!=-1)){
    	NormSplitPackQty=1;
    }
    if ((NormSplitPackQty==0)&&(OrderVirtualtLong=="Y")){
		if (OrderPriorRemarksRowId==""){
			$.messager.alert("��ʾ","��ҽ��Ϊ���ⳤ���Ҳ��ɲ��װ��ҩ������˵������!","info",function(){
			     SetCellData(rowid, "OrderPriorRemarksRowId", OldOrderPriorRemarksRowId);
    			 SetCellData(rowid, "OrderPriorRemarks", OldOrderPriorRemarksRowId);
			})
		    return false;
		}   
	}
    SetCellData(rowid, "OrderPriorRemarksRowId", OrderPriorRemarksRowId);
    SetCellData(rowid, "OrderPriorRemarks", OrderPriorRemarksRowId);
    var OrderSum=GetCellData(rowid, "OrderSum");
    if (+OrderSum==0){
	    SetPackQty(rowid);
	}
    var ret=CheckOrderPriorRemarks(rowid,OldOrderPriorRemarksRowId);
    if (!ret){
        SetScreenSum();
        return;
    }
    ///ȡҩҽ������Ƶ���Ƴ�
    var PriorRowid = GetCellData(rowid, "OrderPriorRowid"); //(PriorRowid == GlobalObj.LongOrderPriorRowid) || (PriorRowid == GlobalObj.OMSOrderPriorRowid) || 
    if ((GlobalObj.PAAdmType == "I") && ((PriorRowid == GlobalObj.ShortOrderPriorRowid))) {
        if (OrderPriorRemarksRowId=="ONE"){
	        var obj = { OrderDur: true };
	    }else{
		    var OrderDur = GlobalObj.IPDefaultDur;
            var OrderDurRowid = GlobalObj.IPDefaultDurRowId;
            var OrderDurFactor = GlobalObj.IPDefaultDurFactor;
            SetCellData(rowid, "OrderDur", OrderDur);
            SetCellData(rowid, "OrderDurRowid", OrderDurRowid);
            SetCellData(rowid, "OrderDurFactor", OrderDurFactor);
            var OrderFreqRowid = GetCellData(rowid, "OrderFreqRowid");
            //if ((PriorRowid != GlobalObj.LongOrderPriorRowid) && ((OrderFreqRowid != GlobalObj.STFreqRowid) || (OrderFreqRowid == GlobalObj.ONCEFreqRowid))) {
	        if ((PriorRowid != GlobalObj.LongOrderPriorRowid) && ((OrderFreqRowid != GlobalObj.STFreqRowid) && (OrderFreqRowid != GlobalObj.ONCEFreqRowid))) {
	            SetCellData(rowid, "OrderFreqRowid", GlobalObj.STFreqRowid);
	            SetCellData(rowid, "OrderFreq", GlobalObj.STFreq);
       		 }
       		SetCellData(rowid, "OrderPackQty", ""); 
		    var obj = { OrderDur: false };
		}
		ChangeRowStyle(rowid, obj);
    }
}
function CheckOrderPriorRemarksLegal(rowid,OldOrderPriorRemarksRowId){
	if (typeof OldOrderPriorRemarksRowId == "undefined") {
    	OldOrderPriorRemarksRowId = "";
    }
	///�� web.DHCOEOrdItemView�е�CheckOrderPriorRemarks�ظ�����ʱ�����Ǻϲ�
	var rows = $('#Order_DataGrid').getDataIDs();
	var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
    var OrderPriorRemarks = GetCellData(rowid, "OrderPriorRemarksRowId");
    if (OrderPriorRemarks != "OM") { SetCellChecked(rowid, "OrderSelfOMFlag", false); }
    if (OrderPriorRemarks == "ONE") {
        var OrderPriorRowid = GetCellData(rowid, "OrderPriorRowid");
        var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
        if (OrderPriorRowid != GlobalObj.ShortOrderPriorRowid) {
            $.messager.alert("��ʾ", "ȡҩҽ��ֻ������ʱҽ��","info",function(){
	             SetCellData(rowid, "OrderPriorRemarksRowId", OldOrderPriorRemarksRowId);
    			 SetCellData(rowid, "OrderPriorRemarks", OldOrderPriorRemarksRowId);
	        });
            return false;
        }
        if ((OrderMasterSeqNo != "") && (OrderPriorRowid != GlobalObj.ShortOrderPriorRowid)) {
            $.messager.alert("��ʾ", "����ҽ��,������ѡ��ȡҩҽ��","info",function(){
	             SetCellData(rowid, "OrderPriorRemarksRowId", OldOrderPriorRemarksRowId);
    			 SetCellData(rowid, "OrderPriorRemarks", OldOrderPriorRemarksRowId);
	        });
            return false;

            //ȡҩҽ����ʱ�����������
            var OrderSeqNo = GetCellData(rowid, "OrderSeqNo");
            for (i = 0; i < rows.length; i++) {
                var RowGet = rows[i];
                var MasterOrderSeqNo = GetCellData(RowGet, "OrderMasterSeqNo");
                if ((MasterOrderSeqNo != "") && (OrderSeqNo == MasterOrderSeqNo)) {
                    $.messager.alert("��ʾ", "����ҽ��,������ѡ��ȡҩҽ��","info",function(){
			             SetCellData(rowid, "OrderPriorRemarksRowId", OldOrderPriorRemarksRowId);
		    			 SetCellData(rowid, "OrderPriorRemarks", OldOrderPriorRemarksRowId);
			        });
                    return false;
                }
            }
        }
        //ȡҩҽ����ʱ�����������
        for (i = 0; i < rows.length; i++) {
            var RowGet = rows[i];
            var MasterOrderSeqNo = GetCellData(RowGet, "OrderMasterSeqNo");
            var OrderPriorRowid = GetCellData(rowid, "OrderPriorRowid");
            if ((MasterOrderSeqNo != "") && (rowid == MasterOrderSeqNo) && (OrderPriorRowid != GlobalObj.ShortOrderPriorRowid)) {
                $.messager.alert("��ʾ", "����ҽ��,������ѡ��ȡҩҽ��","info",function(){
		             SetCellData(rowid, "OrderPriorRemarksRowId", OldOrderPriorRemarksRowId);
	    			 SetCellData(rowid, "OrderPriorRemarks", OldOrderPriorRemarksRowId);
	        	});
                return false;
            }
        }
        //��ҩƷҽ������ѡ��ȡҩҽ��
        var OrderType = GetCellData(rowid, "OrderType");
        if ((OrderType != "R")&& (OrderARCIMRowid != "")) {
            $.messager.alert("��ʾ", "��ҩƷҽ��,������ѡ��ȡҩҽ��","info",function(){
	             SetCellData(rowid, "OrderPriorRemarksRowId", OldOrderPriorRemarksRowId);
    			 SetCellData(rowid, "OrderPriorRemarks", OldOrderPriorRemarksRowId);
	        });
            return false;
        }
    }
    var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
    if ((OrderPriorRemarks == "OM") && (OrderARCIMRowid != "")) {
        //SetCellChecked(rowid,"OrderSelfOMFlag",true)
        var OrderType = GetCellData(rowid, "OrderType");
        if (OrderType != "R") {
            $.messager.alert("��ʾ", "��ҩƷҽ��,������ѡ���Ա�ҩ","info",function(){
	             SetCellData(rowid, "OrderPriorRemarksRowId", OldOrderPriorRemarksRowId);
    			 SetCellData(rowid, "OrderPriorRemarks", OldOrderPriorRemarksRowId);
    			 SetCellChecked(rowid, "OrderSelfOMFlag", false)
	        });
            return false;
        }
    }
    if ((OrderPriorRemarks == "ZT") && (GlobalObj.PAAdmType == "I")) {
        var OrderPrice = GetCellData(rowid, "OrderPrice");
        var OrderType = GetCellData(rowid, "OrderType");
        if ((OrderType != "R") && (+OrderPrice != 0)) {
            $.messager.alert("��ʾ", "סԺ����ֻ��ҩƷ��0����ҽ������ѡ������","info",function(){
	             SetCellData(rowid, "OrderPriorRemarksRowId", OldOrderPriorRemarksRowId);
    			 SetCellData(rowid, "OrderPriorRemarks", OldOrderPriorRemarksRowId);
	        });
            return false;
        }
    }
	return true;
}
function CheckOrderPriorRemarks(rowid,OldOrderPriorRemarksRowId) {
	if (typeof OldOrderPriorRemarksRowId == "undefined") {
    	OldOrderPriorRemarksRowId = "";
    }
    var PriorRowid = "";
    //----------------------6-9---------------------------
    if (!CheckOrderPriorRemarksLegal(rowid,OldOrderPriorRemarksRowId)){
		return false;
	}
	var OrderPriorRemarks = GetCellData(rowid, "OrderPriorRemarksRowId");
    var SetPackQtyConfig={
		///�Ƿ���Ҫ��������װ��
		IsNotNeedChangeFlag:undefined,
		///�Ƿ���Ҫ�������մ���
		IsNotChangeFirstDayTimeFlag:undefined
	};
    switch (OrderPriorRemarks) {
        case "ONE":
            PriorRowid = GlobalObj.ShortOrderPriorRowid;
            var SetPackQtyConfig={
				///�Ƿ���Ҫ��������װ��
				IsNotNeedChangeFlag:"N",
				///�Ƿ���Ҫ�������մ���
				IsNotChangeFirstDayTimeFlag:undefined
			};
		 	break;
        default:
        	$.extend(SetPackQtyConfig, {IsNotChangeFirstDayTimeFlag:"Y"});
        	break;
    }
    var OldPriorRowid = GetCellData(rowid, "OrderPriorRowid");
    if (PriorRowid == "") {
        PriorRowid = OldPriorRowid;
        //if((OrderPriorRemarks=="OM")||(OrderPriorRemarks=="ZT")) SetScreenSum();
    } else {
        if (UIConfigObj.isEditCopyItem == true) {
            SetCellData(rowid, "OrderPrior", PriorRowid);
        }
        //SetCellData(rowid,"OrderPrior",PriorRowid);
        //TODO �˴����ô˷�����ȷ,���˷����߼��϶�,�ٶ���,���Ż�
        //OrderPriorchangeCommon(rowid, OldPriorRowid, PriorRowid);
    }
	//Ŀǰ������������л�ҽ�����͵������if�߼���Ϊ�˷���鿴-tanjishan2019.10.29
	if (OldPriorRowid!=PriorRowid){
		OrderPriorchangeCommon(rowid,OldPriorRowid,PriorRowid);
	}else{
        if (GlobalObj.PAAdmType=="I"){
            SetRecLocStr(rowid, PriorRowid, OrderPriorRemarks);
        }else{
	        var OldOrderRecDepRowid=GetCellData(rowid, "OrderRecDepRowid");
        	var newReclocStr = GetReclocByInstr(rowid);
	        var InstrReclocStr=newReclocStr.split("^")[0];
	        var OrderRecLocStr=newReclocStr.split("^")[1];
	        if (InstrReclocStr!="") {
		        var OrderRecLocStr = GetRecLocStrByPrior(InstrReclocStr, PriorRowid);
		    }else{
			    var OrderRecLocStr = GetRecLocStrByPrior(OrderRecLocStr, PriorRowid);
			}
			SetColumnList(rowid, "OrderRecDep", OrderRecLocStr);
			if (InstrReclocStr=="") {
				RestoreChangeRecLoc(rowid,OldOrderRecDepRowid,OrderRecLocStr);
			}
	        OrderRecDepChangeCom(rowid);
	    }
        var OrderPackQtyStyleObj = ContrlOrderPackQty(rowid);
        ChangeCellDisable(rowid, OrderPackQtyStyleObj);
        SetPackQty(rowid,SetPackQtyConfig);
    }
    SetScreenSum();
    return true;
}
//���տ��Ҹı����
function OrderRecDepchangehandler(e) {
    //$.messager.alert("����",this.id);
    var rowid = GetEventRow(e);
    var obj = websys_getSrcElement(e);
    if (obj.id.indexOf("_") > 0) {
        rowid = obj.id.split("_")[0];
    }
    SetCellData(rowid, "OrderRecDepRowid", obj.value);
    SetCellData(rowid, "OrderRecDep", obj.value);
    var OrderType = GetCellData(rowid, "OrderType");
    if ((GlobalObj.IPDosingRecLocStr != "")&&(OrderType == "R")) {
        if (("^" + GlobalObj.IPDosingRecLocStr + "^").indexOf("^" + obj.value + "^") >= 0) {
            SetCellChecked(rowid, "OrderNeedPIVAFlag", true);
        } else {
            SetCellChecked(rowid, "OrderNeedPIVAFlag", false);
        }
        CancelNeedPIVA(rowid);
    }
    var OrderType=GetCellData(rowid, "OrderType");
    var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
    var OrderRecDepRowid=GetCellData(rowid, "OrderRecDepRowid");
    if ((OrderType=="R")&&(GlobalObj.CFSameRecDepForGroup!=1)&&(OrderMasterSeqNo!="")) { //δ����ҽ�����տ���һ�£����޸���ҽ�����տ��ҿ���Ϊ���������ͬ����ҽ��
		if ((GlobalObj.IPDosingRecLocStr!="")&&(("^" + GlobalObj.IPDosingRecLocStr + "^").indexOf("^" + OrderRecDepRowid + "^") >= 0)){ 
		    var OrderRecDep=GetCellData(rowid, "OrderRecDep");
		    var MainID=GetRowIdByOrdSeqNo(OrderMasterSeqNo);
		    var EditStatus = GetEditStatus(MainID);
            SetCellData(MainID, "OrderRecDepRowid", OrderRecDepRowid);
            if (EditStatus == true) {
                SetCellData(MainID, "OrderRecDep", OrderRecDepRowid);
            } else {
                SetCellData(MainID, "OrderRecDep", OrderRecDep);
            }
            if ((GlobalObj.IPDosingRecLocStr != "")&&(OrderType == "R")) {
		        if (("^" + GlobalObj.IPDosingRecLocStr + "^").indexOf("^" + OrderRecDepRowid + "^") >= 0) {
		            SetCellChecked(MainID, "OrderNeedPIVAFlag", true);
		        } else {
		            SetCellChecked(MainID, "OrderNeedPIVAFlag", false);
		        }
		        CancelNeedPIVA(MainID);
		    }
			OrderRecDepChangeCom(MainID);
		}else{
			OrderRecDepChangeCom(rowid);
		}
	}else{
    	OrderRecDepChangeCom(rowid);
    }
}
function OrderRecDepChangeCom(rowid) {
    var OrderPriorRowid = GetCellData(rowid, "OrderPriorRowid");
    var OrderStartDate = "";
    var OrderType = GetCellData(rowid, "OrderType");
    var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
    var OrderItemCatRowid = mPiece(OrderHiddenPara, String.fromCharCode(1), 2);
    var RecDepRowid = GetCellData(rowid, "OrderRecDepRowid");
	///����ҽ����ʼʱ��
	SetDosingDateTime(rowid,{OrderPriorRowid:OrderPriorRowid,OrderType:OrderType,OrderItemCatRowid:OrderItemCatRowid},RecDepRowid);
	OrderStartDateStr = GetCellData(rowid, "OrderStartDate"); //OrderStartDateStr
    //Э�鵥λ�л�
    GetBillUOMStr(rowid);
    CellDataPropertyChange(rowid, "OrderRecDep", "olddata", "newdata");
    ChangeLinkOrderRecDep(rowid, RecDepRowid, OrderStartDateStr)
    var OrderRecDepRowid = GetCellData(rowid, "OrderRecDepRowid")
    if ((GlobalObj.IPDosingRecLocStr != "")&&(OrderType == "R")) {
        if (("^" + GlobalObj.IPDosingRecLocStr + "^").indexOf("^" + OrderRecDepRowid + "^") >= 0) {
            SetCellChecked(rowid, "OrderNeedPIVAFlag", true);
        } else {
            SetCellChecked(rowid, "OrderNeedPIVAFlag", false);
        }
        CancelNeedPIVA(rowid);
    }
}
//�걾�ı����
function OrderLabSpecchangehandler(e) {
    //$.messager.alert("����",this.id);
    var rowid = "";
    var obj = websys_getSrcElement(e);
    if (obj.id.indexOf("_") > 0) {
        rowid = obj.id.split("_")[0];
    }
    //$.messager.alert("����",this.value);
    SetCellData(rowid, "OrderLabSpecRowid", obj.value);
    OrderLabSpecCollectionSiteChange(rowid);
}
//Ƥ�Ա�ע�ı����
function OrderActionchangehandler(e) {
    var rowid = "";
    var obj = websys_getSrcElement(e);
    if (obj.id.indexOf("_") > 0) {
        rowid = obj.id.split("_")[0];
    }
    var OldOrderActionRowid=GetCellData(rowid, "OrderActionRowid");
    //$.messager.alert("����",this.value);
    var ActionRowid = obj.value;
    SetCellData(rowid, "OrderActionRowid", ActionRowid);
    SetCellData(rowid, "OrderAction", ActionRowid);
    //$.messager.alert("����",ActionRowid);
    var OrderName=GetCellData(rowid,"OrderName");
    var ActionCode = GetOrderActionCode(ActionRowid);
    var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
    var SkinTestYY = mPiece(OrderHiddenPara, String.fromCharCode(1), 0);
    if ((SkinTestYY=="1")&&(ActionCode=="PSJ")){
	    dhcsys_alert(OrderName + "��ҽ������������Ƥ����ԭҺ��סԺƤ����ԭҺ,Ƥ�����ò���ѡ��Ƥ�Լ�!");
        SetCellData(rowid, "OrderAction", OldOrderActionRowid);
        SetCellData(rowid, "OrderActionRowid", OldOrderActionRowid);
    	return false;
	}
    var styleConfigObj = { OrderSkinTest: false }
    if ((ActionCode == "MS") || (ActionCode == "XZ") || (ActionCode == "TM")) {
		 if (ActionCode == "XZ"){
		    var OrderARCIMRowid = GetCellData(rowid,"OrderARCIMRowid");
		    var Ret = tkMakeServerCall("web.DHCDocOrderCommon", "OrdSkinTestRule", OrderARCIMRowid,GlobalObj.EpisodeID);
		    if (Ret==""){
			    if (!dhcsys_confirm(OrderName + "����72Сʱ����Ƥ�Խ��,�Ƿ������")) {
				    SetCellData(rowid, "OrderActionRowid", "");
    				SetCellData(rowid, "OrderAction", "");
    				var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
            		var NeedSkinTestINCI = mPiece(OrderHiddenPara, String.fromCharCode(1), 7);
            		if (NeedSkinTestINCI=="Y"){
			          	var styleConfigObj = { OrderSkinTest: false }
			        }else{
				        var styleConfigObj = { OrderSkinTest: true }
				    }
			        ChangeCellDisable(rowid, styleConfigObj);
				    return false;
				}
			}else if(Ret=="1"){
				if (!dhcsys_confirm(OrderName + "����72Сʱ����Ƥ�Խ��Ϊ�����ԡ�,�Ƿ������")) {
					SetCellData(rowid, "OrderActionRowid", "");
    				SetCellData(rowid, "OrderAction", "");
    				var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
            		var NeedSkinTestINCI = mPiece(OrderHiddenPara, String.fromCharCode(1), 7);
            		if (NeedSkinTestINCI=="Y"){
			          	var styleConfigObj = { OrderSkinTest: false }
			        }else{
				        var styleConfigObj = { OrderSkinTest: true }
				    }
			        ChangeCellDisable(rowid, styleConfigObj);
					return false;
				}
			}
		}
        SetCellChecked(rowid, "OrderSkinTest", false)
    } else if ((ActionCode == "YY")||(ActionCode == "PSJ")) {
        SetCellChecked(rowid, "OrderSkinTest", true)
    } else if (ActionCode == "YX") {
	    //Ƥ������
	    SetCellChecked(rowid, "OrderSkinTest", false)
	    var styleConfigObj = { OrderSkinTest: false }
    } else {
        //���ѡ��Ϊ�հ���ҩѧ���ϱ�־����Ƥ�Թ�ѡ
        var NeedSkinTestINCI="N"
        if (ActionRowid==""){
            var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
            NeedSkinTestINCI = mPiece(OrderHiddenPara, String.fromCharCode(1), 7);
        }
        if (NeedSkinTestINCI=="Y"){
          SetCellChecked(rowid, "OrderSkinTest", true)
        }else{
          var styleConfigObj = { OrderSkinTest: true }
        }
    }
    var StyleConfigStr=GetCellData(rowid, "StyleConfigStr");
    var oldStyleConfigobj = eval("(" + StyleConfigStr + ")");
    $.extend(oldStyleConfigobj, styleConfigObj);
    var StyleConfigStr = JSON.stringify(oldStyleConfigobj);
    SetCellData(rowid, "StyleConfigStr", StyleConfigStr);
    ChangeCellDisable(rowid, styleConfigObj);
    //�������ú�ҳ���Ƿ�ǿ��ҽ������,�������Ƿ��л�����ʱ
    var OldPriorRowid = GetCellData(rowid, "OrderPriorRowid")
    var OrderSkinTest = GetCellData(rowid, "OrderSkinTest")
    if ((GlobalObj.CFSkinTestPriorShort == 1) && (OrderSkinTest == "Y")) { //&&(GlobalObj.OrderPriorContrlConfig!=1)
        if (GlobalObj.OrderPriorContrlConfig == 1) {
            SetColumnList(rowid, "OrderPrior", GlobalObj.ShortOrderPriorRowid + ":" + "��ʱҽ��");
            SetCellData(rowid, "OrderPriorStr", GlobalObj.ShortOrderPriorRowid + ":" + "��ʱҽ��");
        }
        SetCellData(rowid, "OrderPrior", GlobalObj.ShortOrderPriorRowid);
        SetCellData(rowid, "OrderPriorRowid", GlobalObj.ShortOrderPriorRowid);
        OrderPriorchangeCommon(rowid,OldPriorRowid,GlobalObj.ShortOrderPriorRowid);
    }
}
function GetOrderActionCode(OrderActionRowid) {
    if (GlobalObj.OrderActionStr == "") { return "" }
    var OrderPriorArray = GlobalObj.OrderActionStr.split("^");
    for (var i = 0; i < OrderPriorArray.length; i++) {
        var OrderPrior = OrderPriorArray[i].split(String.fromCharCode(1));
        if (OrderPrior[0] == OrderActionRowid) {
            return OrderPrior[1];
        }
    }
    return "";
}
//������ı����
function OrderDIACatchangehandler(e) {
    //$.messager.alert("����",this.id);
    var rowid = "";
    var obj = websys_getSrcElement(e);
    if (obj.id.indexOf("_") > 0) {
        rowid = obj.id.split("_")[0];
    }
    //$.messager.alert("����",this.value);
    SetCellData(rowid, "OrderDIACatRowId", obj.value);
    SetCellData(rowid, "OrderDIACat", obj.value);
}
function ChangeLinkOrderSpeedFlowRate(OrderSeqNo, OrderSpeedFlowRate) {
    try {
        var objtbl = document.getElementById('tUDHCOEOrder_List_Custom');
        var rows = objtbl.rows.length;
        for (var i = 1; i < rows; i++) {
            var Row = GetRow(i);
            var OrderMasterSeqNo = GetColumnData("OrderMasterSeqNo", Row);
            var OrderItemRowid = GetColumnData("OrderItemRowid", Row);
            var OrderARCIMRowid = GetColumnData("OrderARCIMRowid", Row);

            if ((OrderARCIMRowid != "") && (OrderItemRowid == "") && (OrderMasterSeqNo == OrderSeqNo)) {
	            var OrderType = GetCellData(Row, "OrderType");
    			//if (OrderType!="R") continue;
                SetColumnData("OrderSpeedFlowRate", Row, OrderSpeedFlowRate);
            }
        }
    } catch (e) { $.messager.alert("����", e.message) }
}
function OrderSpeedFlowRate_changehandler(e) {
    var Row = GetEventRow(e);
    var eSrc = websys_getSrcElement(e);
    var OrderSeqNo = GetColumnData("OrderSeqNo", Row);
    var OrderMasterSeqNo = GetColumnData("OrderMasterSeqNo", Row);
    if (OrderMasterSeqNo != "") OrderSeqNo = OrderMasterSeqNo;
    var OrderSpeedFlowRate = GetColumnData("OrderSpeedFlowRate", Row);
    ChangeLinkOrderSpeedFlowRate(OrderSeqNo, OrderSpeedFlowRate);
}
//��Һ���ٵ�λ�ı����
function OrderFlowRateUnitchangehandler(e) {
    var rowid = "";
    var obj = websys_getSrcElement(e);
    if (obj.id.indexOf("_") > 0) {
        rowid = obj.id.split("_")[0];
    }
    //$.messager.alert("����",this.value);
    var OrderSeqNo = GetCellData(rowid, "id");
    var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
    if (OrderMasterSeqNo != "") OrderSeqNo = OrderMasterSeqNo;
    var OrderFlowRateUnit = GetCellData(rowid, "OrderFlowRateUnit");
    SetCellData(rowid, "OrderFlowRateUnitRowId", this.value);
    //SetCellData(rowid,"OrderSpeedFlowRate","");
    ChangeLinkOrderFlowRateUnit(OrderSeqNo, this.value,OrderFlowRateUnit);
}
function ChangeLinkOrderFlowRateUnit(OrderSeqNo, OrderFlowRateUnit,OrderFlowRateUnitDesc) {
    try {
        var rowids = GetAllRowId();
        for (var i = 0; i < rowids.length; i++) {
            var rowid = rowids[i];
            if (CheckIsItem(rowids[i]) == true) { continue; }

            var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
            var OrderItemRowid = GetCellData(rowid, "OrderItemRowid");
            var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");

            var OrderSeqNoMasterLink = GetCellData(rowid, "id");
            if ((OrderARCIMRowid != "") && (OrderItemRowid == "") && ((OrderMasterSeqNo == OrderSeqNo) || (OrderSeqNoMasterLink == OrderSeqNo))) {
               	var OrderType = GetCellData(rowid, "OrderType");
    			//if (OrderType !="R") continue;
                //SetCellData(rowid, "OrderFlowRateUnit", OrderFlowRateUnit);
                SetCellData(rowid, "OrderFlowRateUnitRowId", OrderFlowRateUnit);
                var EditStatus = GetEditStatus(rowid);
			    if (EditStatus == true) {
			        SetCellData(rowid, "OrderFlowRateUnit", OrderFlowRateUnit);
			    } else {
			        SetCellData(rowid, "OrderFlowRateUnit", OrderFlowRateUnitDesc);
			    }
            }
        }
    } catch (e) { $.messager.alert("����", e.message) }
}
function ChangeLinkOrderOrderSpeedFlowRate(OrderSeqNo, OrderSpeedFlowRate) {
    try {
        var rowids = GetAllRowId();
        for (var i = 1; i < rowids.length; i++) {
            var rowid = rowids[i];
            if (CheckIsItem(rowids[i]) == true) { continue; }

            var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
            var OrderItemRowid = GetCellData(rowid, "OrderItemRowid");
            var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");

            var OrderSeqNoMasterLink = GetCellData(rowid, "id");
            if ((OrderARCIMRowid != "") && (OrderItemRowid == "") && ((OrderMasterSeqNo == OrderSeqNo) || (OrderSeqNoMasterLink == OrderSeqNo))) {
                SetCellData(rowid, "OrderSpeedFlowRate", OrderSpeedFlowRate)
            }
        }
    } catch (e) { $.messager.alert("����", e.message) }
}
function OrderItemLookupSelect(text,rowid) {
	if (typeof rowid == "undefined") {
    	rowid = "";
    }
    if (rowid==""){
	    if (this.id.indexOf("_") > 0) {
	        rowid = this.id.split("_")[0];
	    }
    }
	new Promise(function(resolve,rejected){
		var Split_Value = text.split("^");
		var iordertype = Split_Value[3];
		if (iordertype == "ARCIM") {
			CheckDiagnose(Split_Value[1],resolve);
		}else{
			resolve(true);
		}
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			if (!rtn) {
				var itemobj = document.getElementById(rowid + "_OrderName");
		        if (itemobj) {
		            itemobj.value = "";
		            SetFocusCell(rowid, "OrderName")
		            return false;
		        }
			}else{
				resolve();
			}
		});
	    
	}).then(function(){
		return new Promise(function(resolve,rejected){
			var Split_Value = text.split("^");
			var icode = Split_Value[1];
			var iordertype = Split_Value[3];
			if (iordertype == "ARCIM") {
				GetItemDefaultRowId(icode,resolve);
			}else{
				resolve();
			}
		});
	}).then(function(ItemDefaultRowId){
		var Split_Value = text.split("^");
	    var idesc = Split_Value[0];
	    var icode = Split_Value[1];
	    var ifreq = Split_Value[2];
	    var iordertype = Split_Value[3];
	    var ialias = Split_Value[4];
	    var isubcatcode = Split_Value[5];
	    var iorderCatID = Split_Value[6];
	    var iSetID = Split_Value[7];
	    var mes = Split_Value[8];
	    var irangefrom = Split_Value[9];
	    var irangeto = Split_Value[10]
	    var iuom = Split_Value[11];
	    var idur = Split_Value[12];
	    var igeneric = Split_Value[13];
	    var match = "notfound";
	    var SetRef = 1;
	    var OSItemIDs = Split_Value[15];
	    var iorderSubCatID = Split_Value[16];
	    var StockQty = Split_Value[20];
	    var PackedQty = Split_Value[21];
		var OrderMasterSeqNo=GetCellData(rowid, "OrderMasterSeqNo");
		if (OrderMasterSeqNo!=""){
			SetMasterSeqNo("", rowid, "C");
		}else{
			SetMasterSeqNo(rowid, rowid, "C");
		}
		CheckMasterOrdStyle();
	    if (iordertype == "ARCIM") iSetID = "";
	    var Itemids = "";
	    if (OSItemIDs == "") {
	        Itemids = icode;
	    } else {
	        Itemids = icode + String.fromCharCode(12) + OSItemIDs;
	    }
	    var OSItemIDArr = OSItemIDs.split(String.fromCharCode(12))
	    for (var i = 0; i < OSItemIDArr.length; i++) {
	        if (OSItemIDArr[i].split(String.fromCharCode(14)).length > 1) OSItemIDArr[i] = OSItemIDArr[i].split(String.fromCharCode(14))[1];
	    }
	    OSItemIDs = OSItemIDArr.join(String.fromCharCode(12));

	    if (iordertype == "ARCIM") {
	        var ret = "";
	        if ($.isNumeric(rowid) == true) {
				SetCellChecked(rowid, "OrderSkinTest", false);
	        }
			var OrdParamsArr=new Array();
			OrdParamsArr[OrdParamsArr.length]={
				OrderARCIMRowid:icode,
				ItemDefaultRowId:ItemDefaultRowId
			};
			PageLogicObj.EntrySelRowFlag=1;
			new Promise(function(resolve,rejected){
				AddItemToList(rowid,OrdParamsArr,"data","",resolve);
			}).then(function(RtnObj){
				var rowid=RtnObj.rowid;
				var returnValue=RtnObj.returnValue;
		        if (returnValue == false) {
		            //��յ�ǰ��
		            //ClearRow(rowid);
		            if (PageLogicObj.NotEnoughStockFlag==1){
		                SetCellData(rowid, "OrderName",PageLogicObj.SearchName);
		                SetFocusCell(rowid, "OrderName");
		                $("#"+rowid+"_OrderName").lookup('showPanel');
		                return false;
		            }else{
			            ClearRow(rowid);
			            SetFocusCell(rowid, "OrderName");
			            return true;
			        }
		        }
		        var OrderType = GetCellData(rowid, "OrderType");
		        var OrderPHPrescType = GetCellData(rowid, "OrderPHPrescType");
		        var OrderFreqRowid = GetCellData(rowid, "OrderFreqRowid");
		        DHCDocUseCount(icode, "User.ARCItmMast");
				CellFocusJumpAfterOrderName(rowid, OrderType);
				//PageLogicObj.EntrySelRowFlag=0;
		        //������ݳɹ��� ����Footer����
				SetScreenSum();
			    return true;
			})
	    } else {
	        //ҽ����
	        if ($.isNumeric(rowid) == false) { return; }
	        OSItemListOpen(icode, idesc, "YES", "", "");
	        DHCDocUseCount(icode, "User.ARCOrdSets");
	        //������ݳɹ��� ����Footer����
			SetScreenSum();
		    return true;
	    }
	    //1��ȡ���� �Ⱦ����༭������
	    //2���ı�༭������
	    //3�������༭
	    //EditRowCommon(rowid);
	    //4����������
	    //document.getElementById(rowid+"_OrderName").value=idesc;  
	    //5����ԭ�༭��
	    //Change_Row_Editor2();
	})
}
//��ҽ���׽���
function OSItemListOpen(ARCOSRowid, OSdesc, del, itemtext, OrdRowIdString) {
    var Patient = GlobalObj.PatientID
    var nowOrderPrior = $("#HiddenOrderPrior").val();
    if(nowOrderPrior=="LongOrderPrior"){
        nowOrderPrior="1"   
    }else{
        nowOrderPrior="0"   
    }
    if (ARCOSRowid != "") {
	    if (GlobalObj.MedNotOpenARCOS=="1"){
		    var ret=cspRunServerMethod(GlobalObj.SetARCOSItemDirectMethod,'AddCopyItemToList',ARCOSRowid,session['LOGON.HOSPID'],GlobalObj.EpisodeID);
		}else{
			if (OSdesc.indexOf("/img")<0){
				OSdesc="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_group.png' style='vertical-align: sub;'></img>"+OSdesc
				}
        	websys_showModal({
				url:"doc.arcositemlist.hui.csp?EpisodeID=" + GlobalObj.EpisodeID + "&ARCOSRowid=" + ARCOSRowid +"&nowOrderPrior=" +nowOrderPrior,
				title:"<font color=yellow>"+OSdesc+'</font> ҽ����¼��',
				width:1160,height:592,
				AddCopyItemToList:AddCopyItemToList
			});
		}
    }
}
//���ҽ����
function AddCopyItemToList(ParaArr) {
	PageLogicObj.m_selArcimRowIdStr="";
    if (typeof(history.pushState) === 'function') {
        //��ֹ�Ҽ�ˢ�º�ҽ���ظ�����
        var Url=window.location.href;
        var NewUrl=rewriteUrl(Url, {copyOeoris:"",copyTo:""});
        history.pushState("", "", NewUrl);
    }
    if (GlobalObj.warning != "") {
        $.messager.alert("����",GlobalObj.warning);
        return false;
    }
    //ɾ����ǰ���һ�пհ���
    var CruRow = GetPreRowId();
    if (CheckIsClear(CruRow) == true) {
        DeleteRow(CruRow);
    }
    GlobalObj.AuditFlag = 0;
	//ParaArr�����ﶪʧ������ĳ�Ա���ԣ����
	var OrdArr = new Array();
	for (var i = 0,ArrLength = ParaArr.length; i < ArrLength; i++){
		if (!ParaArr.hasOwnProperty(i)) continue;
		OrdArr.push(ParaArr[i]);
	}
	window.setTimeout(function(){
		AddCopyItemToListSub(OrdArr);
	}, 100);
	function AddCopyItemToListSub(OrdArr){
		SetTimeLog("AddCopyItemToList", "Start");
		var OrdParamsArr=new Array();
		var OrderARCOSRowid="";
		new Promise(function(resolve,rejected){
			(function(callBackFun){
				function loop(i){
					new Promise(function(resolve,rejected){
						var Para1Str=OrdArr[i];
						if (!Para1Str) resolve(false);
						var para1Arr = Para1Str.split("!");
						var ItemOrderType = para1Arr[3];
						CheckDiagnose(para1Arr[0],resolve);
					}).then(function(rtn){
						if (rtn) {
							var Para1Str=OrdArr[i];
							if (Para1Str) {
								var para1Arr = Para1Str.split("!");
								var icode = para1Arr[0];
								var seqno = para1Arr[1];
								var Para = para1Arr[2];
								var ItemOrderType = para1Arr[3];
								var CopyBillTypeRowId = para1Arr[4];
								//update by zf 2012-05-14
								var CopyType = para1Arr[5];
								var CPWStepItemRowId = para1Arr[6];
								if ((typeof CPWStepItemRowId == "undefined") || (CPWStepItemRowId == "undefined")) {
									CPWStepItemRowId="";
								}
								//����ҩ������ͨ����ҽ����棬����Ҫ�ٴν��п���ҩ���
								var KSSCopyFlag = para1Arr[7];
								if ((typeof KSSCopyFlag == "undefined")||(KSSCopyFlag == "undefined")){
									KSSCopyFlag="";
								}
								if ((KSSCopyFlag == "KSS")) {
									GlobalObj.AuditFlag = 1;
								}
								var OrderBodyPartLabel="";
								if (Para != "") {
									var OrderBodyPartLabel=mPiece(Para, "^", 17);
									if (typeof OrderBodyPartLabel=="undefined") OrderBodyPartLabel="";
								}
								OrderARCOSRowid = para1Arr[8];
								if ((typeof OrderARCOSRowid == "undefined") || (OrderARCOSRowid == "undefined")) {
									OrderARCOSRowid="";
								}
								////����������Ϣ,�������뵥ID+String.fromCharCode(3)+���տ���ID+String.fromCharCode(3)+���մ���+String.fromCharCode(3)+��Ƶ��ѡ��ִ����Ϣ
								////+String.fromCharCode(3)+ҽ����ʼ����+String.fromCharCode(3)+ҽ����������+String.fromCharCode(3)+ҽ�����
								var DCAInfoStr = para1Arr[9];
								if ((typeof DCAInfoStr == "undefined") || (DCAInfoStr == "undefined")) {
									DCAInfoStr="";
								}else{
									//var DCAInfoArr=DCAInfoStr.split(String.fromCharCode(1))
								}
								var ITMRowId=mPiece(Para, "^", 13);
								//seqno���ڴ�ֵ��������ϵ�������ϵ�SeqNoû��ʵ�ʹ�ϵ
								OrdParamsArr[OrdParamsArr.length]={
									OrderARCIMRowid:icode,
									ParamS:Para,
									OrderBillTypeRowid:CopyBillTypeRowId,
									OrderCPWStepItemRowId:CPWStepItemRowId,
									CopyType:CopyType,
									CalSeqNo:seqno,
									OrderBodyPartLabel:OrderBodyPartLabel,
									ITMRowId:ITMRowId,
									DCAInfoStr:DCAInfoStr,
									KSSCopyFlag:KSSCopyFlag
								};
							}
						}
						i++;
						if ( i < OrdArr.length ) {
							 loop(i);
						}else{
							var paraObj={
								OrdParamsArr:OrdParamsArr,
								Para:Para,
								OrderARCOSRowid:OrderARCOSRowid,
								CopyType:CopyType
							}
							callBackFun(paraObj);
						}
					})
				}
				loop(0)
			})(resolve);			
		}).then(function(paraObj){
			return new Promise(function(resolve,rejected){
				var OrderARCOSRowid=paraObj.OrderARCOSRowid;
				var OrdParamsArr=paraObj.OrdParamsArr;
				var CopyType=paraObj.CopyType;
				if (OrderARCOSRowid==""){
					var Para=paraObj.Para;
					var OrderARCOSRowid=mPiece(Para, "^", 6);
				}
				var FastEntryMode=0;
				var	FastEntryName="";
				///�ж��Ƿ����ڿ���ҽ����
				if (OrderARCOSRowid!=""){
					var ARCOSInfo=cspRunServerMethod(GlobalObj.GetARCOSInfoMethod,OrderARCOSRowid);
					FastEntryName=mPiece(ARCOSInfo,"^",0)
					if (mPiece(ARCOSInfo,"^",1)=="Y"){
						FastEntryMode=1;
					}
				}
				var ExpStr=CopyType+"^"+FastEntryMode+"^"+FastEntryName+"^"+OrderARCOSRowid;
				AddItemToList("",OrdParamsArr,"obj",ExpStr,resolve);
			})
			
		}).then(function(RtnObj){
			var rowid=RtnObj.rowid;
			var returnValue=RtnObj.returnValue;
			if (returnValue==false){
				var rowids = $('#Order_DataGrid').getDataIDs();
				if (rowids.length == 0) Add_Order_row();
			}else{
				var OrderType = GetCellData(rowid, "OrderType");
				if (OrderType == "R") {
					SetFocusCell(rowid, "OrderDoseQty");
				} else {
					if (OrderType == "P") {
						SetFocusCell(rowid, "OrderPrice");
					} else {
						SetFocusCell(rowid, "OrderPackQty");
					}
				}
				SetScreenSum();
			}
			/*if (typeof ItemzLookupGrid == "object") {
		        ItemzLookupGrid.hide();
		    }*/
		    PageLogicObj.m_AddItemToListMethod = "LookUp";
			SetTimeLog("AddCopyItemToList", "Over");
			if (PageLogicObj.m_selArcimRowIdStr.split("^").length>=2){
				OrdNotesDetailOpen(PageLogicObj.m_selArcimRowIdStr);
			}
		})
	}
}
function addOEORIByCPW(StepItemIDS) {
    if (StepItemIDS != '') {
        var ret = cspRunServerMethod(GlobalObj.AddMRCPWItemToListMethod, 'AddCopyItemToList', '', StepItemIDS,session['LOGON.HOSPID'],GlobalObj.EpisodeID);
    }
}
function CheckDiagnose(OrderARCIMRowid,callBackFun) {
	var OrdNeedMMDiag=0;
	var ItemCatRowid=tkMakeServerCall("web.DHCDocOrderCommon", "GetOrderSubCat", OrderARCIMRowid);
	if (GlobalObj.OrdNeedMMDiagCat.indexOf("^"+ItemCatRowid+"^") >=0) {
		OrdNeedMMDiag=1;
	}
	new Promise(function(resolve,rejected){
		if ((GlobalObj.OrderLimit==1)||(GlobalObj.PAADMMotherAdmId!="")||(GlobalObj.PAAdmType=="H")||(GlobalObj.CareProvType != "DOCTOR")) {
			resolve(true);
			return;
		}
		
		var NeedDiagnosFlag = 1,NoDiagnosMsg="";
		if (OrdNeedMMDiag == 1){
		    var Ret=tkMakeServerCall("web.DHCDocOrderEntry", "GetMMDiagnoseCount", GlobalObj.mradm);
		    GlobalObj.MRDiagnoseCount = Ret;
		    NoDiagnosMsg="û����ҽ���,����¼��!";
		}else{
			//�����ﲡ������,¼����ϻ�ɾ����Ϻ�δˢ��ҽ��¼�����,�����������ȡ�Ĵ���
	    	var Ret = tkMakeServerCall("web.DHCDocOrderEntry", "GetMRDiagnoseCount", GlobalObj.mradm);
	    	GlobalObj.MRDiagnoseCount = Ret;
	    	NoDiagnosMsg="û�����,����¼��!";
		}
    	if ((GlobalObj.MRDiagnoseCount == 0) && (NeedDiagnosFlag == 1)) {
	    	if ((t['NO_DIAGNOSE']) && (t['NO_DIAGNOSE'] != "")) {
		    	var iframeName = window.name
	            if (iframeName == "") {
	                iframeName = window.parent.frames("oeordFrame").name
	            }
	            if (iframeName == "oeordFrame") {
	                resolve(true);
	            }else{
			    	(function(callBackFunExec){
					    new Promise(function(resolve,rejected){
							$.messager.alert("��ʾ",NoDiagnosMsg,"info",function(){
								websys_showModal({
									url:"diagnosentry.v8.csp?PatientID=" + GlobalObj.PatientID + "&EpisodeID=" + GlobalObj.EpisodeID + "&mradm=" + GlobalObj.mradm,
									title:'���¼��',
									width:((top.screen.width - 100)),height:(top.screen.height - 120),
									onClose:function(){
										if (OrdNeedMMDiag == 1){
										    var Ret = tkMakeServerCall("web.DHCDocOrderEntry", "GetMMDiagnoseCount", GlobalObj.mradm);
										}else{
									    	var Ret = tkMakeServerCall("web.DHCDocOrderEntry", "GetMRDiagnoseCount", GlobalObj.mradm);
										}
							            GlobalObj.MRDiagnoseCount = Ret;
							            if (Ret == 0) { Ret = false; } else { Ret = true; }
										resolve(Ret);
									}
								})
					    	})
						}).then(function(rtn){
							callBackFunExec(rtn);
						});
				    })(resolve);
	            }
		    }else{
			    resolve(false);  
			}
	    }else{
		    //�������
		    resolve(true);
		}
	}).then(function(rtn){
		callBackFun(rtn);
	})
}
function GetItemDefaultRowId(icode,callBackFun){
	new Promise(function(resolve,rejected){
		var userid = session["LOGON.USERID"];
    	var LogonLocDr=session['LOGON.CTLOCID'];
    	//ѡ��ҽ���Զ��峣���÷�
	    var ItemDefaultRowId = "";
	    var OrderPriorRowid = "";
	    if (GlobalObj.OrderPriorContrlConfig==1){
	        var DefaultOrderPrior = GetDefaultOrderPrior("");
	        OrderPriorRowid = DefaultOrderPrior.split('^')[0];
	    }
	    if (GlobalObj.GetUserItemDefaultSingleMethod != "") {
		    var ItemDefaultRowIds = cspRunServerMethod(GlobalObj.GetUserItemDefaultSingleMethod, icode, userid, GlobalObj.PAAdmType,OrderPriorRowid,LogonLocDr);
	        if (ItemDefaultRowIds != "") {
	            var arr = ItemDefaultRowIds.split("^");
	            if (arr.length > 1) {
		            var IsCallBacked=false;
	                websys_showModal({
						url:"doc.orditemdefault.hui.csp?OrderRowid=" + icode + "&UserID=" + userid + "&LogonLocDr=" + LogonLocDr,
						title:'�����÷�',
						width:1000,height:500,
						CallBackFunc:function(ItemDefaultRowId){
							IsCallBacked=true;
							websys_showModal("close");
							if (typeof ItemDefaultRowId=="undefined"){
								ItemDefaultRowId="";
							}
							resolve(ItemDefaultRowId);
						},
						onClose:function(){
							if (!IsCallBacked) resolve("");
						}
					})
	            } else {
	                ItemDefaultRowId = arr[0];
	                resolve(ItemDefaultRowId);
	            }
	        }else{
		        resolve(ItemDefaultRowId);
		    }
		}else{
			resolve(ItemDefaultRowId);
		}
	}).then(function(ItemDefaultRowId){
		callBackFun(ItemDefaultRowId);
	})
}
function CheckAllowOnlyOnceRepeat(icode){
	var rowids = $('#Order_DataGrid').getDataIDs();
	for (var i = 0; i < rowids.length; i++) {
		var OrderItemRowid = GetCellData(rowids[i], "OrderItemRowid");
        var OrderARCIMRowid = GetCellData(rowids[i], "OrderARCIMRowid");
        if ((OrderItemRowid!="")||(OrderARCIMRowid=="")) continue;
        if (OrderARCIMRowid==icode) {
	        return true;
	    }
	}
	return false;
}
function CheckDateDupOrderItem(CurrentRow, ARCIMRowid, StartDate) {
    if ((GlobalObj.PAAdmType == "I") || (GlobalObj.PAAdmType == "E")) { return false }
    var rowids = $('#Order_DataGrid').getDataIDs();
    for (var i = 0; i < rowids.length; i++) {

        var OrderItemRowid = GetCellData(rowids[i], "OrderItemRowid");
        var OrderARCIMRowid = GetCellData(rowids[i], "OrderARCIMRowid");
        var OrderStartDateStr = GetCellData(rowids[i], "OrderStartDate");
        var OrderStartDate = OrderStartDateStr.split(" ")[0];
        if ((OrderARCIMRowid != "") && (OrderItemRowid == "")) {
            if ((ARCIMRowid == OrderARCIMRowid) && (rowids[i] != CurrentRow) && (OrderStartDate == StartDate)) return true;
        }
    }
    return false;
}
//-------------2014-05-13 ��Ҫ�޸ĵļ�麯�� start-----------------------//
function SelectPrescriptItem(ArcimRowid, BillTypeRowid) {
    if (GlobalObj.PAAdmType == "I") { return true }
    var SubCatID = cspRunServerMethod(GlobalObj.GetARCItemSubCatID, '', '', ArcimRowid)
    if (SubCatID != "") SubCatID = "^" + SubCatID + "^";
    var PrescriptTypes = GlobalObj.PrescriptTypes;
    var PrescriptTypeArr = PrescriptTypes.split("||");
    var BillTypeObj = {};
    for (var i = 0; i < PrescriptTypeArr.length; i++) {
        var BillTypeID2 = PrescriptTypeArr[i].split("!")[4];
        var MainSubID = PrescriptTypeArr[i].split("!")[3];
        if (MainSubID != "") { BillTypeObj[BillTypeID2] = "^" + MainSubID + "^"; } else { BillTypeObj[BillTypeID2] = "" }
    }
    var BillTypeID = "";
    for (var key in BillTypeObj) {
        //�ṩ��ѡ��ѱ���ж�  Ϊ�յĿ��Կ�����
        if (key == BillTypeRowid) {
            if ((BillTypeObj[key].indexOf(SubCatID) != -1) || (BillTypeObj[key] == "")) {
                BillTypeID = key;
                break;
            }
        }
    }
    return BillTypeID;
}
//-------------2014-05-13 ��Ҫ�޸ĵļ�麯�� end-----------------------//
function GetBaseDoseQty(ParamObj, ExtendArcosObj) {
    var InciRowid = ParamObj.InciRowid;
    var OrderPriorRowid = ParamObj.OrderPriorRowid;
    var OrderPackQty = ParamObj.OrderPackQty;
    var idoseqtystr = ParamObj.idoseqtystr;
    var OrderDrugFormRowid = ParamObj.OrderDrugFormRowid;
    var OrderFreqFactor = ParamObj.OrderFreqFactor;
    var OrderDurFactor = ParamObj.OrderDurFactor;
    var OrderConFac = ParamObj.OrderConFac
    var BaseDoseQtyObj = { BaseDoseQty: 1, Qty: 1 };
    var OrderPriorRemarksRowId = ParamObj.OrderPriorRemarksRowId;
    //���Ϊ�ǿ����,�������������ж�
    if (InciRowid != "") {
        //��������ȡҩ�ͳ�Ժ��ҩĬ�ϰ�����װ��
        if (((OrderPriorRowid == GlobalObj.OutOrderPriorRowid) || (OrderPriorRemarksRowId == "ONE") || (OrderPriorRowid == GlobalObj.OneOrderPriorRowid)) && (GlobalObj.CFOutAndOneDefaultPackQty == 1)) OrderPackQty = 1;
		
        var BaseDoseQty = 1;
        if (OrderPackQty != "") {
            Qty = parseFloat(OrderConFac) * parseFloat(OrderPackQty);
        } else {
            var DefaultDoseQty = "";
            var DefaultDoseUOMRowid = "";
            if ($.isEmptyObject(ExtendArcosObj) == false) {
                DefaultDoseQty = ExtendArcosObj.OrderDoseQty;
                DefaultDoseUOMRowid = ExtendArcosObj.OrderDoseUOMRowid;
            } else {
                if (idoseqtystr != "") {
                    var ArrData = idoseqtystr.split(String.fromCharCode(2));
                    if (ArrData.length > 0) {
                        var ArrData1 = ArrData[0].split(String.fromCharCode(1));
                        var DefaultDoseQty = ArrData1[0];
                        var DefaultDoseUOMRowid = ArrData1[2];
                    }
                }
            }
            if (DefaultDoseUOMRowid != "") {
                OrderBaseQty = cspRunServerMethod(GlobalObj.CalDoseMethod, DefaultDoseUOMRowid, OrderDrugFormRowid, DefaultDoseQty);
                if (OrderBaseQty == "") OrderBaseQty = 1;
            } else {
                OrderBaseQty = 1
            }
            Qty = parseFloat(OrderFreqFactor) * parseFloat(OrderDurFactor) * parseFloat(OrderBaseQty);
        }
        BaseDoseQtyObj.BaseDoseQty = BaseDoseQty;
        BaseDoseQtyObj.Qty = Qty;
    }
    return BaseDoseQtyObj
}
function GetConFacByUom(OrderPackQty,ParamObj,OrderRecDepRowid){
    var SpecOrderPackUOMRowid=ParamObj.SpecOrderPackUOMRowid;
    if (SpecOrderPackUOMRowid==undefined) { SpecOrderPackUOMRowid="" }
    var BillUOMStr = cspRunServerMethod(GlobalObj.GetBillUOMStrMethod, ParamObj.OrderARCIMRowid, OrderRecDepRowid, "OrderEntry");
    var DefaultOrderPackUOM = "";
    var FirstOrderPackUOM="";
    var ArrData = BillUOMStr.split(String.fromCharCode(2));
    for (var i = 0; i < ArrData.length; i++) {
        var ArrData1 = ArrData[i].split(String.fromCharCode(1));
        if (SpecOrderPackUOMRowid!=""){
           if (ArrData1[0]==SpecOrderPackUOMRowid){
             var DefaultOrderPackUOM = ArrData1[0];
           }
        }else{
           if (ArrData1[2] == "Y"){
             var DefaultOrderPackUOM = ArrData1[0];
           }
        }
        if (i==0) FirstOrderPackUOM=ArrData1[0];
    }
    if (DefaultOrderPackUOM=="") DefaultOrderPackUOM=FirstOrderPackUOM
    if (DefaultOrderPackUOM != "") {
        if (ParamObj.OrderPackUOMRowid!=DefaultOrderPackUOM){
            OrderPackQty=tkMakeServerCall("web.DHCDocOrderEntry", "GetConFac",ParamObj.OrderARCIMRowid,ParamObj.InciRowid,DefaultOrderPackUOM)
        }
    }
    return OrderPackQty;
}
function SetDosingDateTime(rowid, ParamObj, OrderRecDepRowid) {
    if ((GlobalObj.IPDosingRecLoc == "") || (OrderRecDepRowid == "")) return;
    var OrderPriorRowid = ParamObj.OrderPriorRowid;
    var OrderType = ParamObj.OrderType;
    var OrderItemCatRowid = ParamObj.OrderItemCatRowid;
    if ((OrderPriorRowid == GlobalObj.LongOrderPriorRowid || (OrderPriorRowid == GlobalObj.OMSOrderPriorRowid)) && (OrderType == "R")) {
        var OrderRecDepRowid=GetCellData(rowid, "OrderRecDepRowid");
		if (("^" + GlobalObj.IPDosingRecLocStr + "^").indexOf("^" + OrderRecDepRowid + "^") < 0){
			return;
		}
        var ret = CheckDosingRecLoc(OrderRecDepRowid);
        if (ret) {
            var StartDateTime = cspRunServerMethod(GlobalObj.GetDosingDateTimeMethod, PageLogicObj.defaultDataCache, "2", OrderItemCatRowid);
			if (StartDateTime!="") {
				var StartDateTimeArr = StartDateTime.split("^");
				var OrderStartDate = StartDateTimeArr[0];
				var OrderStartTime = StartDateTimeArr[1];
				var OrderStartDateStr = OrderStartDate + " " + OrderStartTime;
				SetCellData(rowid, "OrderStartDate", OrderStartDateStr);
			}
        } else {
            //����ҽ����ʼʱ��
            var CurrDateTime = cspRunServerMethod(GlobalObj.GetCurrentDateTimeMethod, PageLogicObj.defaultDataCache, "1");
            var CurrDateTimeArr = CurrDateTime.split("^");
            var OrderStartDateStr = CurrDateTimeArr[0] + " " + CurrDateTimeArr[1]
            SetCellData(rowid, "OrderStartDate", OrderStartDateStr);
        }
    }
}
//סԺ��������Ѻ�����
function CheckDeposit(amount, arcim) {
	if (+amount==0) return true;
    if (GlobalObj.VisitStatus=="P") return true;
    if (GlobalObj.NotDoCheckDeposit==1) return true;
    if (GlobalObj.SupplementMode==1){return true;}
    if ((GlobalObj.PAAdmType != "I") && (GlobalObj.GetStayStatusFlag != 1) && (GlobalObj.GetStayStatusFlag != 2)) { return true }
    if (GlobalObj.CheckIPDepositMethod != "") {
        var retDetail = cspRunServerMethod(GlobalObj.CheckIPDepositMethod, GlobalObj.EpisodeID, amount, "OE");
        if (retDetail != 0) {
            var retArray = retDetail.split("^");
            if (retArray[4] == 'C') {
				var AlertAmount=retArray[0];
				if (AlertAmount<0) {
					AlertAmount="-"+FormateNumber(AlertAmount.split("-")[1]);
				}else{
					AlertAmount=FormateNumber(AlertAmount);
				}
                if (retArray[5] == 'N') {
                    $.messager.alert("����",t['ExceedDeposit'] + AlertAmount);
                    return false;
                } else {
                    if (arcim != "") {
                        var retDetail = cspRunServerMethod(GlobalObj.CheckDepositOrderMethod, GlobalObj.EpisodeID,retArray[2], arcim);
                        if (retDetail == 0) {
                            $.messager.alert("����",t['ExceedDeposit'] + AlertAmount);
                            return false;
                        }
                    }
                }
            }
        }
    }
    return true;
}
function CheckPrescriptSum(AddSum, Arcim) {
    var ScreenBillSum = GetScreenBillSum();
    var amount = parseFloat(ScreenBillSum) + parseFloat(AddSum);
    var ret = CheckDeposit(amount, Arcim);
    return ret;
}
/*************************************
 *˵����2014-08-15
 *�������������ʱ ��Ԫ���Ƿ�ɱ༭
 *DefaultStyleConfigObj�е����Ա���ͱ����index��ͬ
 *����StyleConfigObj
 *������Ƿ�ǿ��ģʽ�Ļ���Ӧ������Ҫ��prior��change�¼�������style-tanjishan
 *************************************/
function GetStyleConfigObj(ParamObj) {
    var DefaultStyleConfigObj = {
        OrderDur: true,
        OrderFreq: true,
        OrderPackQty: true,
        OrderPackUOM: true,
        OrderDoseQty: true,
        OrderDoseUOM: true,
        OrderInstr: true,
        OrderPrice: false,
        OrderAction: true,
        OrderMasterSeqNo: false,
        OrderLabSpec: true,
        OrderNotifyClinician: true,
        OrderInsurCat: true,
        OrderSpeedFlowRate: true,
        OrderFlowRateUnit: true,
        OrderNeedPIVAFlag: true,
        AntUseReason: true,
        OrderLabEpisodeNo: false,
        Urgent: false,
        OrderPrior: true,
        IsHourItem: ParamObj.IsHourItem,
        OrderSkinTest: true,
        OrderFirstDayTimes: false,
        OrderLocalInfusionQty:true,
        OrderVirtualtLong:false
    }
    var rowid = ParamObj.rowid;
    var icode = ParamObj.OrderARCIMRowid;
    var OrderType = ParamObj.OrderType;
    var OrderPHPrescType = ParamObj.OrderPHPrescType;
    var OrderPriorRowid = ParamObj.OrderPriorRowid;
    var OrderPriorRemarks = ParamObj.OrderPriorRemarksRowId;
    var OrderFreqRowid = ParamObj.OrderFreqRowid;
	var OrderItemCatRowid=ParamObj.OrderItemCatRowid;
	var OrderRecDepRowid=ParamObj.OrderItemCatRowid;
    //�Ӽ�����      20141127
    var EmergencyFlag = ParamObj.EmergencyFlag;
    if ((EmergencyFlag == "Y")&&(OrderPriorRowid ==GlobalObj.ShortOrderPriorRowid)) {
        DefaultStyleConfigObj.Urgent = true;
    }
    //********** end
    var OrderHiddenPara=ParamObj.OrderHiddenPara;
    var NeedSkinTestINCI = mPiece(OrderHiddenPara, String.fromCharCode(1), 7);
	var IncItmHighValueFlag = mPiece(OrderHiddenPara, String.fromCharCode(1), 9);
    var StyleConfigObj = {};
    //$.extend(StyleConfigObj,DefaultStyleConfigObj);
    var StyleConfigObj = DefaultStyleConfigObj;
    StyleConfigObj.OrderDur = false;
    StyleConfigObj.OrderFreq = false;
    //���ܹ�����ҽ������
    if (("^" + GlobalObj.NotLinkItemCat + "^").indexOf("^" + ParamObj.OrderItemCatRowid + "^") == -1) {
        StyleConfigObj.OrderMasterSeqNo = true;
    } 
    //���ɿ���ʱҽ��������
    if (GlobalObj.UserEMVirtualtLong=="1"){
	    StyleConfigObj.OrderVirtualtLong = true;
		if (GlobalObj.NORMLimitInfo!=""){
			var NORMLimitItemCatStr=mPiece(GlobalObj.NORMLimitInfo, String.fromCharCode(1), 0);
			var NORMLimitArcItemStr=mPiece(GlobalObj.NORMLimitInfo, String.fromCharCode(1), 1);
			
			if ((NORMLimitItemCatStr!="")&&(("^"+NORMLimitItemCatStr+"^").indexOf("^"+OrderItemCatRowid+"^")>=0)){
				StyleConfigObj.OrderVirtualtLong = false;
			}
			if ((NORMLimitArcItemStr!="")&&(("^"+NORMLimitArcItemStr+"^").indexOf("^"+icode+"^")>=0)){
				StyleConfigObj.OrderVirtualtLong = false;
			}
		}   
	}
    if (OrderType != "R") {
        StyleConfigObj.OrderDoseUOM = false;
        /*
        ��ҩƷ����ҽ�������û�е��μ�����λ������д���μ���
        ��ҩƷ����ҽ������������Ƶ�Σ�����¼�뵥�μ���
        ---tanjishan 20191217
        ��ҩƷ����ҽ��,�������ҩƷ,���߱�����ǿ���¼��Ƶ�ε�����,����¼�뵥�μ���
        ��ҩƷ��ʱҽ��,ͳһ��������¼��
        */
        if (OrderPriorRowid == GlobalObj.LongOrderPriorRowid){
            
        }else{
           //if (ParamObj.idoseqtystr == "") {
            StyleConfigObj.OrderDoseQty = false;
            //���ڴ˴�����,����ҽ��Ҳ���жԵ����Ƿ������ж�,�ŵ�����ҽ���ж�֮��
            //ParamObj.OrderDoseQty="";
           //}
        }
        /*if (ParamObj.idoseqtystr == "") {
            StyleConfigObj.OrderDoseQty = false;
        }*/
        if (("^" + GlobalObj.SelectInstrNotDrugCat + "^").indexOf("^" + ParamObj.OrderItemCatRowid + "^") == -1) {
            StyleConfigObj.OrderInstr = false;
        }
        //StyleConfigObj.OrderInstr=false;
        StyleConfigObj.OrderDur = false;
        StyleConfigObj.OrderSkinTest = false;
        StyleConfigObj.OrderAction = false;
        //StyleConfigObj.OrderInsurCat = false;
        StyleConfigObj.OrderSpeedFlowRate = false;
        StyleConfigObj.OrderFlowRateUnit = false;
        StyleConfigObj.OrderNeedPIVAFlag = false;
        StyleConfigObj.AntUseReason = false;
        StyleConfigObj.OrderPackQty = false;
        StyleConfigObj.OrderPackUOM = false;
        StyleConfigObj.OrderLocalInfusionQty = false;
        if (OrderType == "L") {
            StyleConfigObj.OrderLabEpisodeNo = true;
        } else {
            StyleConfigObj.OrderLabEpisodeNo = false;
        }
        //���� ��ҩƷƵ��
        //��MedTrak��ҽ��վ�����еġ�������ơ�->��¼��Ƶ�η�ҩƷ���ࡿ���趨��ҽ������

        if (OrderPHPrescType == "4") {
	        if (GlobalObj.PAAdmType!="I"){
		        StyleConfigObj.OrderDur = true;
		    }
            /*if ((OrderPriorRowid != GlobalObj.LongOrderPriorRowid) && (OrderPriorRowid != GlobalObj.OMSOrderPriorRowid)) {
                StyleConfigObj.OrderDur = true;
            }*/
            StyleConfigObj.OrderFreq = true;
            StyleConfigObj.OrderFirstDayTimes=true;
        }
        //��ҩƷ����ҽ������Ƶ�β���¼����������Ƶ�ο���¼������
        //��ҩƷ����ҽ����Ƶ�β���¼�뵥�μ���
        if (OrderPriorRowid == GlobalObj.LongOrderPriorRowid){
            if ((StyleConfigObj.OrderFreq==false)&&(ParamObj.OrderFreqRowid=="")){
                StyleConfigObj.OrderPackQty = true;
                StyleConfigObj.OrderDoseQty = false;
            }else{
	            StyleConfigObj.OrderFirstDayTimes=true;
                StyleConfigObj.OrderDoseQty = true;
                ParamObj["OrderPackQty"]="";
            }
        }

    } else {
		StyleConfigObj.OrderFirstDayTimes=true;
        //ҩƷ Ƶ��
        StyleConfigObj.OrderFreq = true;
        //StyleConfigObj.OrderMasterSeqNo = true;
        //סԺ�Ĳ�ҩ����Ҫ¼���Ƴ�,������ҽ��
        if (GlobalObj.PAAdmType != "I") {
            StyleConfigObj.OrderDur = true;
        } else {
            if (OrderPHPrescType == "3") {
                StyleConfigObj.OrderDur = true;
            } else {
                if ((((OrderPriorRowid == GlobalObj.LongOrderPriorRowid) || (OrderPriorRowid == GlobalObj.OMSOrderPriorRowid)) || ((OrderPriorRowid == GlobalObj.ShortOrderPriorRowid) && (GlobalObj.PAAdmType == "I")))) {

                    StyleConfigObj.OrderDur = false;
                }
                //��Ժ��ҩ
                if (OrderPriorRowid == GlobalObj.OutOrderPriorRowid) {
                    StyleConfigObj.OrderDur = true;
                }
            }
        }
        if ((NeedSkinTestINCI=="Y")||(GlobalObj.DisableOrdSkinChange=="1")) {
            StyleConfigObj.OrderSkinTest=false;
            StyleConfigObj.OrderAction=false;
        }
        
        if (ParamObj.OrderActionRowid!=""){
	        StyleConfigObj.OrderSkinTest=false;
	        //StyleConfigObj.OrderAction=false;
	    }
	    //Ƥ���÷���Ƥ�Ա�ע�ͱ�־���ɱ༭
	    if (GlobalObj.SkinTestInstr != "") {
		    var InstrRowId=ParamObj.OrderInstrRowid;
	        var Instr = "^" + InstrRowId + "^";
	        if (GlobalObj.SkinTestInstr.indexOf(Instr) != "-1") {
		        StyleConfigObj.OrderAction=false;
		        //StyleConfigObj.OrderSkinTest=false;
		        if ((NeedSkinTestINCI=="Y")||(GlobalObj.DisableOrdSkinChange=="1")) {
		        	StyleConfigObj.OrderInstr=false;
		        }
		    }
		}
		var SameFreqDifferentDosesFlag=ParamObj.OrderHiddenPara.split(String.fromCharCode(1))[19];
		if ((SameFreqDifferentDosesFlag=="Y")&&(ParamObj.OrderFreqTimeDoseStr!="")){
			//StyleConfigObj.OrderDoseQty=false;
			StyleConfigObj.OrderDoseQty="readonly";
		}
		if (OrderPriorRowid == GlobalObj.LongOrderPriorRowid){
			StyleConfigObj.OrderPackQty = false;
		}
    }
    //��ʿ��¼ҽ�����й�������,Ƶ�β��ɱ༭
    if ((VerifiedOrderObj) && (VerifiedOrderObj.LinkedMasterOrderPriorRowid != "undefined") && (VerifiedOrderObj.LinkedMasterOrderPriorRowid != "")) { //&& (VerifiedOrderObj.LinkedMasterOrderFreRowId != "undefined") && (VerifiedOrderObj.LinkedMasterOrderFreRowId != "")
        StyleConfigObj.OrderPrior = false;
        StyleConfigObj.OrderFreq = false;
        StyleConfigObj.OrderDur = false;
        StyleConfigObj.OrderInstr = false;
        //����ʿ��¼��ʱҽ��������ҽ���ϣ��Ҳ�¼��ҽ��Ƶ��Ϊ��,��Ƶ�οɱ༭ ΪʲôҪ�༭?
        if ((OrderFreqRowid=="")&&(OrderPHPrescType=="4")&&(VerifiedOrderObj.LinkedMasterOrderPriorRowid==GlobalObj.LongOrderPriorRowid)&&(OrderPriorRowid==GlobalObj.ShortOrderPriorRowid)){
	        StyleConfigObj.OrderFreq = true;
	    }
	    //����ҽ��Ƶ�ηַ���������1��������ҽ����Ϊ����ҽ��������ҽ������"¼��Ƶ���Ƴ̵ķ�ҩƷ����"����ɱ༭
	    //ʹ�ó���ʾ��:������һ�����죬��ֻ��һ�β��Ϸ�
	    if ((VerifiedOrderObj.LinkedMasterOrderFreFactor>1)&&(VerifiedOrderObj.LinkedMasterOrderPriorRowid==GlobalObj.LongOrderPriorRowid)&&(OrderPriorRowid==GlobalObj.LongOrderPriorRowid)) {
		    StyleConfigObj.OrderFreq = true;
		}
		if ((OrderPriorRowid != GlobalObj.LongOrderPriorRowid)&&(OrderType!="R")) {
	        StyleConfigObj.OrderPackQty = true;
	    }
	    //��ҩƷ����ҽ����Ƶ�ο���¼������
	    if ((OrderPriorRowid == GlobalObj.LongOrderPriorRowid)&&(OrderType!="R")&&(ParamObj.OrderFreqRowid=="")){
		    StyleConfigObj.OrderPackQty = true;
            StyleConfigObj.OrderDoseQty = false;
		}
    }else{
	    //��������
		var ContrlOrderPackQtArg={
			OrderPriorRowid:OrderPriorRowid,
			OrderPriorRemarks:OrderPriorRemarks,
			OrderARCIMRowid:icode,
			OrderFreqRowid:OrderFreqRowid,
			OrderRecDepRowid:ParamObj.OrderRecDepRowid,
			OrderMasterARCIMRowid:ParamObj.OrderMasterARCIMRowid,
			OrderVirtualtLong:(typeof ParamObj.OrderVirtualtLong!="undefined")?ParamObj.OrderVirtualtLong:"N"
		}
	    var OrderPackQtyObj = ContrlOrderPackQty(rowid, ContrlOrderPackQtArg);
	    if (ParamObj.OrderNeedPIVAFlag == "Y") {
	        OrderPackQtyObj = { OrderPackQty: false, OrderPackUOM: false };
	    }
	    $.extend(StyleConfigObj, OrderPackQtyObj);
    }
    //�Զ���ҽ��  �۸���Ա༭
    if (OrderType == "P") {
        StyleConfigObj.OrderPrice = true;
    }
    if (ParamObj.IsHourItem == "1") {
	    if (GlobalObj.AllowHourOrdUsePrn ==1) {
		    StyleConfigObj.OrderFreq = true;
		    if ((ParamObj["OrderFreqRowid"])&&(ParamObj["OrderFreqRowid"]!=GlobalObj.PRNFreqRowid)){
			    //ȥ��Ĭ��ֵ
	    		ParamObj["OrderFreq"] = "";
	    		ParamObj["OrderFreqRowid"] = "";
	    		ParamObj["OrderFreqInterval"] = "";
	    		ParamObj["OrderFreqFactor"] = 1;
	    		ParamObj["OrderFreqDispTimeStr"] = "";
			}
		}else{
			StyleConfigObj.OrderFreq = false;
			ParamObj["OrderFreq"] = "";
			ParamObj["OrderFreqRowid"] = "";
			ParamObj["OrderFreqInterval"] = "";
	    	ParamObj["OrderFreqFactor"] = 1;
	    	ParamObj["OrderFreqDispTimeStr"] = "";
		}			
        StyleConfigObj.OrderDur = false;
        StyleConfigObj.OrderInstr = false;
        //ȥ��Ĭ��ֵ
        ParamObj["OrderDur"] = "";
        ParamObj["OrderInstr"] = "";
        if (OrderPriorRowid == GlobalObj.LongOrderPriorRowid) {
	        StyleConfigObj.OrderPackQty = false;
	    }
    }
    var CureItemConfigArg={
		OrderPriorRowid:OrderPriorRowid,
		OrderPriorRemarks:OrderPriorRemarks,
		OrderARCIMRowid:icode,
		OrderFreqRowid:OrderFreqRowid,
		OrderRecDepRowid:ParamObj.OrderRecDepRowid,
		OrderMasterARCIMRowid:ParamObj.OrderMasterARCIMRowid,
		NotChangeCellFlag:"Y",
		NotResetPackQtyFlag:"Y",
		OrderPHPrescType:OrderPHPrescType,
		OrderType:OrderType,
		OrderHiddenPara:OrderHiddenPara,
		OrderFreqStyle:StyleConfigObj.OrderFreq
	}
	var CureItemStyleObj=CheckCureItemConfig(rowid,CureItemConfigArg);
	$.extend(StyleConfigObj, CureItemStyleObj);
	if(!StyleConfigObj.OrderDoseQty){
		ParamObj.OrderDoseQty="";	
	}
    //���õ�Ԫ�񲻿ɱ༭ ������ֵ  2014-05-16
    //����ʽ���Ƹ�Ϊֻ�����Ƿ�ɱ༭  ����������
    /*
    for(var key in StyleConfigObj){
        var name=key;
        var value=StyleConfigObj[key];
        if(value==false){
            var val=ParamObj[name];
            if(val != undefined && val != ""){
                //$.messager.alert("����",name+":"+val);
                StyleConfigObj[name]=value+"^"+val;
            }
        }
    }
    */
    return StyleConfigObj
}
function SetCalculateValue(ParamObj){
    var OrderARCIMRowid = ParamObj.OrderARCIMRowid;
	var OrderDoseQty = ParamObj.OrderDoseQty;
    var OrderDoseUOMRowid = ParamObj.OrderDoseUOMRowid;
    var OrderFreqRowid = ParamObj.OrderFreqRowid;
    var OrderDurRowid = ParamObj.OrderDurRowid;
    var OrderFreqDispTimeStr = ParamObj.OrderFreqDispTimeStr;
    var OrderPackQty = ParamObj.OrderPackQty;
    var OrderPackUOMRowid = ParamObj.OrderPackUOMRowid;
	var OrderPrice=ParamObj.OrderPrice;
	var OrderPriorRowid=ParamObj.OrderPriorRowid;
	var OrderPriorRemarksRowId=ParamObj.OrderPriorRemarksRowId;
	var OrderConFac=ParamObj.OrderConFac;
	var OrderType=ParamObj.OrderType;
	var Qty=ParamObj.Qty;
	var OrderFreqTimeDoseStr=ParamObj.OrderFreqTimeDoseStr;
	///��������
	if ((OrderPackQty!="")&&(GlobalObj.CalcDurByArcimMethod!="")){
		var UsableDays = cspRunServerMethod(GlobalObj.CalcDurByArcimMethod, OrderARCIMRowid, OrderFreqRowid, OrderDurRowid, OrderPackQty, OrderDoseQty, OrderDoseUOMRowid, OrderPackUOMRowid,OrderFreqDispTimeStr,OrderFreqTimeDoseStr);
		if ((OrderType != "R") && (UsableDays == "0")) {
			UsableDays = ""
		}
		$.extend(ParamObj, { OrderUsableDays: UsableDays});
	}
	///--����ҽ�����
	var Sum=0;
    if (GlobalObj.PAAdmType != "I") {
		Sum = parseFloat(OrderPackQty) * parseFloat(OrderPrice);
        Sum = Sum.toFixed(2);
	}else{
		var Sum = 0;
		if ((OrderPriorRemarksRowId!="OM")&&(OrderPriorRemarksRowId!="ZT")){
			Sum = (parseFloat(OrderPrice)/parseFloat(OrderConFac)) * parseFloat(Qty);
		}
		Sum = Sum.toFixed(4);
	}
	$.extend(ParamObj, { Sum: Sum});
}
///У���ܷ񽫸���ҽ����ӵ�����
function CheckItemCongeries(ItemToListDetailObj){
	var CheckBeforeAddObj={
		SuccessFlag:true,				//�Ƿ���Ҫ�������ҽ��
		StartDateEnbale:true,
		OrderDateEnbale:true,
		UserOptionObj:new Array()
	}
	new Promise(function(resolve,rejected){
		///ItemToListDetailObj.ItemCongeriesObj �ϴ�ǰ��̨�����ķ�������
		///ִ�лص�����
		if (typeof ItemToListDetailObj.CallBakFunS=="object"){
			///�Ƚ����ж��Ƿ�����Ҫ�ݹ�ĺ���
			(function(callBackExecFun){
				function loop(i){
					new Promise(function(resolve,rejected){
						var FunCode=ItemToListDetailObj.CallBakFunS[i].CallBakFunCode;
						var FunCodeParams=ItemToListDetailObj.CallBakFunS[i].CallBakFunParams;
						ExeItemCongeriesUserOption(FunCode,FunCodeParams,resolve);
					}).then(function(UserOptionObj){
						if (!$.isEmptyObject(UserOptionObj)){
							CheckBeforeAddObj.UserOptionObj.push(UserOptionObj);
						}						
						i++;
						if ( i < ItemToListDetailObj.CallBakFunS.length ) {
							 loop(i);
						}else{
							callBackExecFun();
						}
					})
				}
				loop(0);
			})(resolve);
		}else{
			resolve();
		}
	}).then(function(){
		return new Promise(function(resolve,rejected){
			if ((CheckBeforeAddObj.UserOptionObj.length>0)||(ItemToListDetailObj.UserOptionCount>0)){
				resolve();
			}else{
				//ҽ����ErrCode������0������ҽ�����ܱ�¼�뵽ҳ�棬����������ʾ��û�б���Ҫ��ʾ
				if (ItemToListDetailObj.ErrCode=="-100"){
					$.extend(CheckBeforeAddObj, {SuccessFlag:false});
					resolve();
				}else if (ItemToListDetailObj.ErrCode!="0"){
					$.messager.alert("��ʾ",ItemToListDetailObj.ErrMsg,"info",function(){
						$.extend(CheckBeforeAddObj, {SuccessFlag:false});
						resolve();
					});
				}else{
					if (typeof ItemToListDetailObj.CallBakFunS=="object"){
						///�ٽ����ж��Ƿ���Ҫ����������ͨ�ĺ���
						(function(callBackExecFun){
							function loop(i){
								new Promise(function(resolve,rejected){
									var FunCode=ItemToListDetailObj.CallBakFunS[i].CallBakFunCode;
									var FunCodeParams=ItemToListDetailObj.CallBakFunS[i].CallBakFunParams;
									ExeItemCongeriesCallBackFun(FunCode,FunCodeParams,resolve);
								}).then(function(ReturnObj){
									if (ReturnObj.SuccessFlag==false){
										CheckBeforeAddObj.SuccessFlag=false;
										callBackExecFun();
									}else{
										var ParamObj=ItemToListDetailObj.OrdListInfo;
										if (ReturnObj.StartDateEnbale==false) {
											$.extend(CheckBeforeAddObj, {StartDateEnbale:false});
										}
										if (ReturnObj.OrderDateEnbale==false) {
											$.extend(CheckBeforeAddObj, {OrderDateEnbale:false});
										}	
										if ($.isEmptyObject(ParamObj) == false){
											if (ReturnObj.OrderCoverMainIns===true){
												$.extend(ParamObj, { OrderCoverMainIns: "Y"});
											}else if (ReturnObj.OrderCoverMainIns===false){
												$.extend(ParamObj, { OrderCoverMainIns: "N"});
											}
											if (ReturnObj.OrderSkinTest===true){
												$.extend(ParamObj, { OrderSkinTest: "Y"});
											}else if (ReturnObj.OrderSkinTest===false){
												$.extend(ParamObj, { OrderSkinTest: "N"});
												var ActionRowid=ParamObj.OrderActionRowid;
												if (ActionRowid!=""){
								                	var ActionCode = GetOrderActionCode(ActionRowid);
								                	if ((ActionCode=="YY")||(ActionCode=="PSJ")){
									                	$.extend(ParamObj, { OrderActionRowid: "",OrderAction:""});
									                }
								                }
											}
											if (ReturnObj.OrderInsurCatRowId!=""){
												$.extend(ParamObj, { OrderInsurCatRowId: ReturnObj.OrderInsurCatRowId});
											}
											//��������
											if ($.isEmptyObject(ReturnObj.CalPackQtyObj) == false) {
												$.extend(ParamObj, ReturnObj.CalPackQtyObj);
											}
											$.extend(ItemToListDetailObj.OrdListInfo, ParamObj);
										}
															
										i++;
										if ( i < ItemToListDetailObj.CallBakFunS.length ) {
											 loop(i);
										}else{
											callBackExecFun();
										}
									}
								})
							}
							loop(0);
						})(resolve);
					}else{
						resolve();
					}
				}
			}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			if ((CheckBeforeAddObj.SuccessFlag==false)||(ItemToListDetailObj.UserOptionCount>0)){
				resolve();
			}else{
				///��������ֵ��ֵ-�����������ܼ�
				SetCalculateValue(ItemToListDetailObj.OrdListInfo);
				(function(callBackFunExec){
					new Promise(function(resolve,rejected){
						CheckDiagnose(ItemToListDetailObj.OrdListInfo.OrderARCIMRowid,resolve);
					}).then(function(rtn){
						if (!rtn) {
					        $.extend(CheckBeforeAddObj, {SuccessFlag:false});
						}
						callBackFunExec();
					});
				})(resolve);
			}
		})
	}).then(function(){
		ItemToListDetailObj.callBackFun(CheckBeforeAddObj)
	})
	///-------
	//��������������̨��ѯ���������ڶԺ���������Ӱ���confirm���㣬
	//ÿ�ζ����ֵ���������Եĸ�ֵ������Ҫ�ں�̨�����м��϶�Ӧ�Ĵ���
	//UserOptionObӦ���ٰ��������̶�����{Type:"",Value:""},���ں�̨����ʶ��
	function ExeItemCongeriesUserOption(FunCode ,FunCodeParams, CallBackFun){
		var UserOptionObj={};
		new Promise(function(resolve,rejected){
			var ParamsArr=FunCodeParams.split(";");
			switch(FunCode)
			{
				case "SetOrderFreqDispTimeStr":
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							if (ParamsArr[3]=="Week"){
								GetOrderFreqWeekStr(ParamsArr[0],ParamsArr[1],ParamsArr[2],resolve);
							}else if (ParamsArr[3]=="FreeTime"){
								GetOrderFreqFreeTimeStr(ParamsArr[0],ParamsArr[1],ParamsArr[2],resolve);
							}
						}).then(function(OrderFreqWeekInfo){
							var OrderFreqDispTimeStr=mPiece(OrderFreqWeekInfo, "^", 0);
							$.extend(UserOptionObj,{Type:"SetOrderFreqDispTimeStr",Value:OrderFreqDispTimeStr});
							callBackFunExec();
						})
					})(resolve); //�˴���resolveָ����FunObj.CallBackFun(UserOptionObj);
					break;
				case "SetMulDoses": //ͬƵ�β�ͬ����,����������д����
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							ShowFreqQty(ParamsArr[0],ParamsArr[1],"",ParamsArr[2],resolve);
						}).then(function(OrderFreqTimeDoseStr){
							$.extend(UserOptionObj,{Type:"SetMulDoses",Value:OrderFreqTimeDoseStr});
							callBackFunExec();
						})
					})(resolve); //�˴���resolveָ����FunObj.CallBackFun(UserOptionObj);
					break;
				case "GuideAllergy": //Ƥ�Ե�������
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							ShowGuideAllergy(ParamsArr[0],ParamsArr[1],resolve);
						}).then(function(GuideAllergyInfo){
							$.extend(UserOptionObj,{Type:"GuideAllergy",Value:GuideAllergyInfo});
							callBackFunExec();
						})
					})(resolve); //�˴���resolveָ����FunObj.CallBackFun(UserOptionObj);
					break;
				case "AppendAllergyOrder": //Ƥ�Ը���ҽ��ѡ�񴰿�
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							ShowAppendAllergyOrder(ParamsArr[0],ParamsArr[1],ParamsArr[2],resolve);
						}).then(function(AppendAllergyOrderInfo){
							$.extend(UserOptionObj,{Type:"AppendAllergyOrder",Value:AppendAllergyOrderInfo});
							callBackFunExec();
						})
					})(resolve); //�˴���resolveָ����FunObj.CallBackFun(UserOptionObj);
					break;
				default:
					resolve();
					break;
			}
		}).then(function(){
			CallBackFun(UserOptionObj);
		})
	}
	/*
	tanjishan
	����additemtolist�����Ļص���ע�⣺
	Ϊ���ݿ���ҽ����¼��ģʽ���˷����в���ֱ�Ӷ������ݽ��в�������������ݲ�������ʹ�÷��ض��󣬲���ParamObj
	*/
	function ExeItemCongeriesCallBackFun(FunCode ,FunCodeParams, CallBackFun){
		var ReturnObj={
			SuccessFlag:true,
			StartDateEnbale:true,
			OrderDateEnbale:true,
			//ҽ����Ӧ֢�漰�޸ĵ�����--
			OrderCoverMainIns:"",	//ҽ����ѡ
			OrderInsurCatRowId:"",
			CalPackQtyObj:{}
		}
		var ParamsArr=FunCodeParams.split(";");
		new Promise(function(resolve,rejected){
			switch(FunCode)
			{
				case "Alert":
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							$.messager.alert("��ʾ",ParamsArr.join(";"),"info",function(){
								callBackFunExec();
							});
						})
					})(resolve); //�˴���resolveָ����CallBackFun(ReturnObj);
					break;
				case "Confirm" :
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							$.messager.confirm('ȷ�϶Ի���', FunCodeParams, function(r){
								if (!r) {
									ReturnObj.SuccessFlag=false;
								}
								callBackFunExec();
							});
						})
					})(resolve); //�˴���resolveָ����CallBackFun(ReturnObj);
					break;
				case "CheckPoison":
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							websys_showModal({
								url:"dhcdoccheckpoison.csp?PatID=" + GlobalObj.EpisodeID,
								title:'����ҽ�����ھ�1��2��������ҩƷ,����֤������Ϣ', //����ҽ�����ھ�1��2��������ҩƷ,����֤������Ϣ
								width:590,height:290,
								closable:false,
								CallBackFunc:function(retval){
									websys_showModal("close");
									if (typeof retval=="undefined"){
										retval="";
									}
									if (retval!="") {
										var encmeth = GlobalObj.UpdateAgencyInfoMethod;
						                if (encmeth != "") {
						                    var rtn = cspRunServerMethod(encmeth,GlobalObj.EpisodeID , retval);
						                    if (rtn == "-100") {
							                    $.messager.alert("��ʾ",FunCodeParams + t['POISONSAVE_FAILED'],"info",function(){
													ReturnObj.SuccessFlag=false;
													resolve();
												});
						                    }else{
							                    resolve();
							                }
						                }else{
							                resolve();
							            }
									}else{
										$.messager.alert("��ʾ",FunCodeParams + t['POISON_ALERT'],"info",function(){
											ReturnObj.SuccessFlag=false;
											resolve();
										});
									}
								}
							})
						}).then(function(){
							callBackFunExec();
						})
					})(resolve);
					break;
				case "SetEnoughStock":
					PageLogicObj.NotEnoughStockFlag=1;
					resolve();
					break;
				case "SetPrompt":
					$("#Prompt").html(FunCodeParams);
					resolve();
					break;
				case "SetStartDateEnbale":
					if (FunCodeParams=="1"){
						ReturnObj.StartDateEnbale=true;
					}else{
						ReturnObj.StartDateEnbale=false;
					}
					resolve();
					break;
				case "SetOrdDateEnbale":
					if (FunCodeParams=="1"){
						ReturnObj.OrderDateEnbale=true;
					}else{
						ReturnObj.OrderDateEnbale=false;
					}
					resolve();
					break;
				case "SetCoverMainIns":
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							$.messager.confirm('ȷ�϶Ի���', FunCodeParams, function(r){
								if (!r) {
									ReturnObj.OrderCoverMainIns=false;
								}else{
									ReturnObj.OrderCoverMainIns=true;
								}
								callBackFunExec();
							});
						})
					})(resolve); //�˴���resolveָ����CallBackFun(ReturnObj);
					break;
				case "SetOrderSkinTest":
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							$.messager.confirm('ȷ�϶Ի���', FunCodeParams, function(r){
								if (!r) {
									ReturnObj.OrderSkinTest=false;
								}else{
									ReturnObj.OrderSkinTest=true;
								}
								callBackFunExec();
							});
						})
					})(resolve); //�˴���resolveָ����CallBackFun(ReturnObj);
					break;
				case "SetInsurCat":
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							var obj = new Object();
				            obj.name = "Para";
				            obj.value = FunCodeParams;
				            var url =  "../csp/dhcdocindicationschoose.hui.csp";//"websys.default.csp?WEBSYS.TCOMPONENT=DHCDocIndicationsChoose";
				            //ԭ���ǽ�InsuConType�ŵ�OrderHiddenPara�е�4λ?A��ʵӦ�ø�ֵ��OrderInsurCatRowId��������
							websys_showModal({
								url:url,
								title:'��ѡ��ҽ����Ӧ֢',
								width:800,height:600,
								InsurAlertStr:FunCodeParams,
								closable:false,
								CallBackFunc:function(OrderInsurCatRowId){
									websys_showModal("close");
									if (typeof OrderInsurCatRowId=="undefined"){
										OrderInsurCatRowId="";
										ReturnObj.SuccessFlag=false;
									}
									ReturnObj.OrderInsurCatRowId=OrderInsurCatRowId;
									resolve();
								}
							})
						}).then(function(){
							callBackFunExec();
						})
					})(resolve);
					break;
				case "ReSetPackQty1":
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							$.messager.confirm('ȷ�϶Ի���', ParamsArr[0], function(r){
								if (r) {
									var PackQty=ParamsArr[1];
									var OrderSum=ParamsArr[2];
									$.extend(ReturnObj.CalPackQtyObj, { OrderPackQty: PackQty,OrderSum:OrderSum});
								}
								callBackFunExec();
							});
						})
					})(resolve); //�˴���resolveָ����CallBackFun(ReturnObj);
					break;
				case "ReSetPackQty2":
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							$.messager.confirm('ȷ�϶Ի���', ParamsArr[0], function(r){
								if (r) {
									var PackQty=ParamsArr[1];
									var OrderSum=ParamsArr[2];
									var BaseDoseQty=ParamsArr[3];
									var BaseDoseQtySum=ParamsArr[4];
									$.extend(ReturnObj.CalPackQtyObj, { OrderPackQty: PackQty,OrderSum:OrderSum,OrderBaseQty:BaseDoseQty,OrderBaseQtySum:BaseDoseQtySum});
								}
								callBackFunExec();
							});
						})
					})(resolve); //�˴���resolveָ����CallBackFun(ReturnObj);
					break;
				default:
					resolve();
					break;
			}
		}).then(function(){
			CallBackFun(ReturnObj);
		})
	}
}

function AddItemDataToRow(ParamObj,RowDataObj,AddMethod,callBackFun){
    //3.��������
    //���浱ǰ��������ʽ
    //��ȡ����ʽ
	var rowid=ParamObj.rowid;
    var StyleConfigObj = GetStyleConfigObj(ParamObj);
    $.extend(StyleConfigObj, { OrderStartDate: ParamObj.StartDateEnbale,OrderDate:ParamObj.OrderDateEnbale});
    var ActionCode = GetOrderActionCode(RowDataObj.OrderActionRowid);
    if (ActionCode=="TM"){
	    $.extend(StyleConfigObj, { OrderAction: false});
    }
    var StyleConfigStr = JSON.stringify(StyleConfigObj);
    $.extend(ParamObj, { StyleConfigStr: StyleConfigStr });
    ChangeRowStyle(rowid, StyleConfigObj)
	//���������ݶ���	
    RowDataObj = SetRowDataObj(ParamObj.rowid, RowDataObj, ParamObj);
    //4.�������
    //AddMethod obj ��ͳһ���÷Ǳ༭ģʽ����
    var FromCopyAndUnEditFlag=0;
    new Promise(function(resolve,rejected){
	    if (AddMethod == "obj") {
	        //���ÿ�����Ŀ
			rowid = Add_Order_row2(RowDataObj);
	        //SetColumnList(rowid, "OrderPilotPro", GlobalObj.PilotProStr);
			///GetBillUOMStr���Ѿ�������OrderPackUOMchangeCommon
	        ///OrderPackUOMchangeCommon(rowid);
	        //ҽ����¼�� �Ƿ������༭ �û�UI����
	        //��ʼ��ҽ������
			CreaterOrderInsurCat(rowid,"N");
	        if (UIConfigObj.isEditCopyItem == true) {
	            EditRow(rowid);
	            //���ý���λ��
	            SetFocusCell(rowid, "OrderName");
	            //���ÿ�����Ŀ
	            SetColumnList(rowid, "OrderPilotPro", GlobalObj.PilotProStr);
	            //��ҽ��ҽ��
		        SetColumnList(rowid,"OrderDoc",RowDataObj.OrderDocStr);
		        //��ʼ��Э�鵥λ
		        SetColumnList(rowid, "OrderPackUOM", RowDataObj.OrderPackUOMStr);
		        //��ʼ���ɼ���λ
		        SetColumnList(rowid, "OrderLabSpecCollectionSite", RowDataObj.OrderLabSpecCollectionSiteStr);
	        } else {
	            //todo ���Ż�,�����ֱ��¼��,���ⲿ��������(����:Para),����combo������Ҫ��ʾ����,��������ʾ������
	            FromCopyAndUnEditFlag=1;
	            if (RowDataObj.OrderInsurCatRowId) {
					var OrderInsurCat=GetOrderInsurCat(rowid,RowDataObj.OrderInsurCatRowId);
					SetCellData(rowid, "OrderInsurCat", OrderInsurCat);
				}
	        }
	        CheckOrderPriorRemarksLegal(rowid);
	        SetCellData(rowid, "OrderPackQty", RowDataObj.OrderPackQty);
			SetCellData(rowid, "OrderInsurCatRowId", RowDataObj.OrderInsurCatRowId);
			//OrderPackQtychangeCommon(rowid);
	        //SetTimeLog("AddItemDataToRow", "������ķ�ʽ��ֵ������֮��");
	        //SetTimeLog("AddItemDataToRow", "������ķ�ʽ��ֵ�����ݵ��ÿ���ҩ��ּ�����֮ǰ");
	        //*******************������12 �˴�Ϊ����λ��*******************************/
	        //����ҩ��ּ�����
	        (function(callBackExecFun){
		        new Promise(function(resolve,rejected){
			        if (ParamObj.OrderType == "R") {
				        ICheckDoctorTypePoison(ParamObj.OrderPoisonRowid, ParamObj.OrderARCIMRowid, rowid, ParamObj.OrderPoisonCode,resolve);
				    }else{
					    resolve(true);
					}
			    }).then(function(Ret){
				    if (Ret == false) {
					    CheckMasterOrdStyle();
					    callBackFun(false);
					    return;
					}else{
						
						if (UIConfigObj.isEditCopyItem == true) {
					        setTimeout(function(){
						        var OrderType= GetCellData(rowid, "OrderType");
								var OrderPHPrescType = GetCellData(rowid, "OrderPHPrescType");
						        var OrderFreqRowid = GetCellData(rowid, "OrderFreqRowid");
						        if (((OrderPHPrescType == "4")||(OrderType == "R")) && (OrderFreqRowid == "")) {
						            SetFocusCell(rowid, "OrderFreq");
						        }
							})
						}
						callBackExecFun();
					}
				})
		    })(resolve);
	        //**************************************************/
	    } else {
	        //SetTimeLog("AddItemDataToRow", "���������ݸ�ֵ������֮ǰ");
	        //���浱ǰ��������ʽ
	        SetCellData(rowid, "StyleConfigStr", RowDataObj.StyleConfigStr);
			SetCellData(rowid, "OrderMasterSeqNo", RowDataObj.OrderMasterSeqNo);
				        //ҽ������
			if (RowDataObj.ReSetPriorStr!=""){
				SetColumnList(rowid, "OrderPrior", RowDataObj.ReSetPriorStr);
			}
	        SetCellData(rowid, "OrderPrior", RowDataObj.OrderPriorRowid);
	        SetCellData(rowid, "OrderPriorRowid", RowDataObj.OrderPriorRowid);
	        SetCellData(rowid, "OrderPriorStr", RowDataObj.OrderPriorStr);
	        //������λ
	        SetColumnList(rowid, "OrderDoseUOM", RowDataObj.idoseqtystr)
	        SetCellData(rowid, "OrderDoseQty", RowDataObj.OrderDoseQty);
	        SetCellData(rowid, "OrderDoseUOM", RowDataObj.OrderDoseUOMRowid);
	        SetCellData(rowid, "OrderDoseUOMRowid", RowDataObj.OrderDoseUOMRowid);
	        //�洢����������
	        SetCellData(rowid, "idoseqtystr", RowDataObj.idoseqtystr)

	        //�ز�����
	        SetColumnList(rowid, "OrderDIACat", RowDataObj.idiagnoscatstr);
	        SetCellData(rowid, "idiagnoscatstr", RowDataObj.idiagnoscatstr)
	            //Ĭ������ǰһ����������  
	        SetCellData(rowid, "OrderDIACat", RowDataObj.OrderDIACat);
	        SetCellData(rowid, "OrderDIACatRowId", RowDataObj.DIACatRowId);

	        //��ǰ��ĵõ����ý��տ��Ҵ������ý��տ���List
	        SetColumnList(rowid, "OrderRecDep", RowDataObj.CurrentRecLocStr);
	        //�洢����������
	        SetCellData(rowid, "CurrentRecLocStr", RowDataObj.CurrentRecLocStr)

	        //��¼�·ǳ�Ժ��ҩ�Ľ��տ��Һͳ�Ժ��ҩ�Ľ��տ���?���л�ҽ������ʱ��Ҫ��������
	        SetCellData(rowid, "OrderRecLocStr", RowDataObj.OrderRecLocStr);
	        SetCellData(rowid, "OrderOutPriorRecLocStr", RowDataObj.OrderOutPriorRecLocStr);
	        SetCellData(rowid, "OrderOnePriorRecLocStr", RowDataObj.OrderOnePriorRecLocStr);
			SetCellData(rowid, "OrderHolidayRecLocStr", RowDataObj.OrderHolidayRecLocStr);
	        //�趨ǰ��������п����ܿ���
	        if (RowDataObj.OrderRecDepRowid) {
	            SetCellData(rowid, "OrderRecDep", RowDataObj.OrderRecDepRowid);
	            SetCellData(rowid, "OrderRecDepRowid", RowDataObj.OrderRecDepRowid);
	        }

	        //��걾ѡ�������� �걾
	        SetColumnList(rowid, "OrderLabSpec", RowDataObj.OrderLabSpecStr);
	        SetCellData(rowid, "OrderLabSpec", RowDataObj.OrderLabSpecRowid);
	        SetCellData(rowid, "OrderLabSpecRowid", RowDataObj.OrderLabSpecRowid);
	        SetCellData(rowid, "OrderLabSpecStr", RowDataObj.OrderLabSpecStr);
	        //��ʼ���ɼ���λ
		    SetColumnList(rowid, "OrderLabSpecCollectionSite", RowDataObj.OrderLabSpecCollectionSiteStr);
	        //���ÿ�����Ŀ
	        SetColumnList(rowid, "OrderPilotPro", GlobalObj.PilotProStr);

	        //Ƶ��
	        SetCellData(rowid, "OrderFreq", RowDataObj.OrderFreq);
	        //$.messager.alert("����",OrderFreq);
	        SetCellData(rowid, "OrderFreqRowid", RowDataObj.OrderFreqRowid);
	        SetCellData(rowid, "OrderFreqFactor", RowDataObj.OrderFreqFactor);
	        SetCellData(rowid, "OrderFreqInterval", RowDataObj.OrderFreqInterval);
	        SetCellData(rowid, "OrderFreqDispTimeStr", RowDataObj.OrderFreqDispTimeStr);
	        //�÷�
	        SetCellData(rowid, "OrderInstr", RowDataObj.OrderInstr);
	        SetCellData(rowid, "OrderInstrRowid", RowDataObj.OrderInstrRowid);
	        SetCellData(rowid, "OrderHiddenPara", RowDataObj.OrderHiddenPara);
	        //*******************������12 �˴�Ϊ����λ��*******************************/
	        //����ҩ��ּ�����
	        //����ҩ��ּ�����
	        (function(callBackExecFun){
		        new Promise(function(resolve,rejected){
			        if (ParamObj.OrderType == "R") {
				        ICheckDoctorTypePoison(ParamObj.OrderPoisonRowid, ParamObj.OrderARCIMRowid, rowid, ParamObj.OrderPoisonCode,resolve);
				    }else{
					    resolve(true);
					}
			    }).then(function(Ret){
				    if (Ret == false) {
					    callBackFun(false);
					    return;
					}else{
						var OrderPriorRowid=GetCellData(rowid, "OrderPriorRowid");
						if ((GlobalObj.PAAdmType=="I")&&(OrderPriorRowid==GlobalObj.ShortOrderPriorRowid)&&(RowDataObj.OrderDurRowid=="")){
							SetCellData(rowid, "OrderDur", GlobalObj.IPDefaultDur);
					        SetCellData(rowid, "OrderDurRowid", GlobalObj.IPDefaultDurRowId);
					        SetCellData(rowid, "OrderDurFactor", GlobalObj.IPDefaultDurFactor);
						}else{
							//�Ƴ�
					        SetCellData(rowid, "OrderDur", RowDataObj.OrderDur);
					        SetCellData(rowid, "OrderDurRowid", RowDataObj.OrderDurRowid);
					        SetCellData(rowid, "OrderDurFactor", RowDataObj.OrderDurFactor);
						}
				        SetCellData(rowid, "OrderConFac", RowDataObj.OrderConFac);
				        SetCellData(rowid, "OrderPHForm", RowDataObj.OrderPHForm);
				        SetCellData(rowid, "OrderPHPrescType", RowDataObj.OrderPHPrescType);

				        //ҽ����ID
				        SetCellData(rowid, "OrderARCIMRowid", RowDataObj.OrderARCIMRowid);

				        SetCellData(rowid, "OrderDrugFormRowid", RowDataObj.OrderDrugFormRowid);
				        SetCellData(rowid, "OrderName", RowDataObj.OrderName);

				        //����
				        SetCellData(rowid, "OrderPackQty", RowDataObj.OrderPackQty);
						
						SetColumnList(rowid, "OrderPackUOM", RowDataObj.OrderPackUOMStr);
						SetCellData(rowid, "OrderPackUOMStr", RowDataObj.OrderPackUOMStr);
				        SetCellData(rowid, "OrderPackUOM", RowDataObj.OrderPackUOMRowid); //OrderPackUOM
				        SetCellData(rowid, "OrderPackUOMRowid", RowDataObj.OrderPackUOMRowid);
				        SetCellData(rowid, "OrderDepProcNote", RowDataObj.OrderDepProcNote);
				        //����
				        SetCellData(rowid, "OrderSpeedFlowRate", RowDataObj.OrderSpeedFlowRate);
				        SetCellData(rowid, "OrderFlowRateUnit", RowDataObj.OrderFlowRateUnitRowId);
				        SetCellData(rowid, "OrderFlowRateUnitRowId", RowDataObj.OrderFlowRateUnitRowId);
				        SetCellData(rowid, "ExceedReasonID", RowDataObj.DIDExceedReasonDR);
				        SetCellData(rowid, "ExceedReason", RowDataObj.DIDExceedReasonDR);
				        //�۸�
				        SetCellData(rowid, "OrderPrice", RowDataObj.OrderPrice);
				        //���
				        SetCellData(rowid, "OrderSum", RowDataObj.OrderSum);
				        //ҽ������
				        SetCellData(rowid, "OrderType", RowDataObj.OrderType);
				        //�ѱ�
				        //SetCellData(rowid,"OrderBillType",RowDataObj.OrderBillType);
				        SetCellData(rowid, "OrderBillType", RowDataObj.OrderBillTypeRowid);
				        SetCellData(rowid, "OrderBillTypeRowid", RowDataObj.OrderBillTypeRowid);
				        //����˵��
				        SetCellData(rowid, "OrderPriorRemarks", RowDataObj.OrderPriorRemarksRowId);
				        SetCellData(rowid, "OrderPriorRemarksRowId", RowDataObj.OrderPriorRemarksRowId);
				        //��ʼ����
				        SetCellData(rowid, "OrderStartDate", RowDataObj.OrderStartDate);
						//����ʱ��
						SetCellData(rowid, "OrderEndDate", RowDataObj.OrderEndDate);
						SetCellData(rowid, "OrderDate", RowDataObj.OrderDate);
						
				        SetCellData(rowid, "OrderBaseQty", RowDataObj.OrderBaseQty);
				        SetCellData(rowid, "OrderARCOSRowid", RowDataObj.OrderARCOSRowid);
				        SetCellData(rowid, "OrderMaxDurFactor", RowDataObj.OrderMaxDurFactor);
				        SetCellData(rowid, "OrderMaxQty", RowDataObj.OrderMaxQty);
				        SetCellData(rowid, "OrderBaseQtySum", RowDataObj.Qty);
				        SetCellData(rowid, "OrderFile1", RowDataObj.OrderFile1);
				        SetCellData(rowid, "OrderFile2", RowDataObj.OrderFile2);
				        SetCellData(rowid, "OrderFile3", RowDataObj.OrderFile3);
				        SetCellData(rowid, "OrderLabExCode", RowDataObj.OrderLabExCode);
				        SetCellData(rowid, "OrderAlertStockQty", RowDataObj.OrderAlertStockQty);
				        SetCellData(rowid, "OrderPoisonCode", RowDataObj.OrderPoisonCode);
				        SetCellData(rowid, "OrderPoisonRowid", RowDataObj.OrderPoisonRowid);
				        SetCellData(rowid, "LinkedMasterOrderRowid", RowDataObj.LinkedMasterOrderRowid);
				        SetCellData(rowid, "LinkedMasterOrderSeqNo", RowDataObj.LinkedMasterOrderSeqNo);
						SetCellData(rowid, "OrderNurseLinkOrderRowid", RowDataObj.OrderNurseLinkOrderRowid);
						SetCellData(rowid, "OrderCPWStepItemRowId", RowDataObj.OrderCPWStepItemRowId);
						SetCellData(rowid, "OrderMaterialBarcode", RowDataObj.OrderMaterialBarcode);
						SetCellData(rowid, "OrderMaterialBarcodeHiden", RowDataObj.OrderMaterialBarcodeHiden);
						if (RowDataObj.OrderFreqRowid==(GetCellData(rowid, "OrderFreqRowid"))) {
							SetCellData(rowid, "OrderFirstDayTimes",RowDataObj.OrderFirstDayTimes);// ���մ���
						}
				        //�����б� 
				        SetColumnList(rowid,"OrderOperation",RowDataObj.OrderOperationStr);
				        SetCellData(rowid,"OrderOperation",RowDataObj.OrderOperationCode);
				        SetCellData(rowid,"OrderOperationCode",RowDataObj.OrderOperationCode);
				        SetCellData(rowid,"OrderOperationStr",RowDataObj.OrderOperationStr);
				        SetCellData(rowid,"AnaesthesiaID",RowDataObj.AnaesthesiaID);
				        //��ҽ��ҽ��
				        SetColumnList(rowid,"OrderDoc",RowDataObj.OrderDocStr);
				        SetCellData(rowid,"OrderDocStr",RowDataObj.OrderDocStr);
				        SetCellData(rowid,"OrderDoc",RowDataObj.OrderDocRowid);
				        SetCellData(rowid,"OrderDocRowid",RowDataObj.OrderDocRowid);
				        //****************������8********************************/
				        var AntibApplyRowid = GetCellData(rowid, "OrderAntibApplyRowid")
				        if ((AntibApplyRowid == "") && (typeof(OrderAntibApplyRowid) != "undefined")) {
				            SetCellData(rowid, "OrderAntibApplyRowid", RowDataObj.OrderAntibApplyRowid);
				        }
				        var ReasonID = GetCellData(rowid, "UserReasonId")
				        if ((ReasonID == "") && (typeof(UserReasonID) != "undefined")) {
				            SetCellData(rowid, "UserReasonId", RowDataObj.UserReasonId);
				        }
				        //************************************************/
				        //ֻ�б�ע��ԭҺ��տ�����Ƥ�Ա�־
				        if (RowDataObj.OrderSkinTest == "Y") {
				            SetCellChecked(rowid, "OrderSkinTest", true);
				        }else{
							SetCellChecked(rowid, "OrderSkinTest", false);
						}
				        SetCellData(rowid, "OrderActionRowid", RowDataObj.OrderActionRowid);
				        SetCellData(rowid, "OrderAction", RowDataObj.OrderActionRowid);
				        /*
				        �����������е�Ƥ�Ա�־����GetStyleConfigObj�ﴦ��
				        var ActionRowid=GetCellData(rowid, "OrderActionRowid");
				        var ActionCode = GetOrderActionCode(ActionRowid);
				        if ((ActionCode == "MS") || (ActionCode == "XZ") || (ActionCode == "TM")) {
				            var styleConfigObj = { OrderSkinTest: false }
				            ChangeCellDisable(rowid, styleConfigObj);
				        }*/
				        if (RowDataObj.OrderCoverMainIns == "N") {
				            //ҽ��
				            SetCellChecked(rowid, "OrderCoverMainIns", false);
				        } else {
				            SetCellChecked(rowid, "OrderCoverMainIns", true);
				        }
				        SetCellData(rowid, "OrderHiddenPara", RowDataObj.OrderHiddenPara);
				        if (ParamObj.OrderType == "R") {
				            SetCellData(rowid, "OrderGenericName", RowDataObj.OrderGenericName);
				        }
				        if (RowDataObj.OrderNeedPIVAFlag == "N") {
				            SetCellChecked(rowid, "OrderNeedPIVAFlag", false);
				        } else {
				            SetCellChecked(rowid, "OrderNeedPIVAFlag", true);
				        }
						SetCellData(rowid, "OrderBodyPartID", RowDataObj.OrderBodyPartID);
						SetCellData(rowid, "OrderBodyPart", RowDataObj.OrderBodyPart);
						SetCellData(rowid, "ExceedReasonID", RowDataObj.ExceedReasonID);
						SetCellData(rowid, "ExceedReason", RowDataObj.ExceedReasonID);
						SetCellData(rowid, "OrderMaterialBarcode", RowDataObj.OrderMaterialBarcode);
						SetCellData(rowid, "OrderMaterialBarcodeHiden", RowDataObj.OrderMaterialBarcodeHiden);
				        SetCellData(rowid, "OrderBodyPartLabel", RowDataObj.OrderBodyPartLabel);
						SetCellData(rowid, "OrderUsableDays", RowDataObj.OrderUsableDays);
						SetCellData(rowid, "OrderLocalInfusionQty", RowDataObj.OrderLocalInfusionQty);
						SetCellData(rowid, "OrderFreqTimeDoseStr", RowDataObj.OrderFreqTimeDoseStr);
						SetCellData(rowid, "OrderPkgOrderNo", RowDataObj.OrderPkgOrderNo);
						if (RowDataObj.OrderVirtualtLong == "Y") {
				            SetCellChecked(rowid, "OrderVirtualtLong", true);
				        }else{
							SetCellChecked(rowid, "OrderVirtualtLong", false);
                        }
                        SetColumnList(rowid, "OrderChronicDiag", RowDataObj.OrderChronicDiagStr);
                        SetCellData(rowid, "OrderChronicDiagStr", RowDataObj.OrderChronicDiagStr);
                        SetCellData(rowid, "OrderChronicDiag", RowDataObj.OrderChronicDiagCode);
                        SetCellData(rowid, "OrderChronicDiagCode", RowDataObj.OrderChronicDiagCode);
				        //��ʼ��Э�鵥λ---tanjishan,��������̨
				        //GetBillUOMStr(rowid);
				        //��ʼ��ҽ������
				        CreaterOrderInsurCat(rowid,"N");
				        //ҽ���ӷ���
				        SetCellData(rowid, "OrderInsurCat", RowDataObj.OrderInsurCatRowId); //OrderInsurCat
				        SetCellData(rowid, "OrderInsurCatRowId", RowDataObj.OrderInsurCatRowId);
				        //����Ƶ�εķ�ҩƷҽ�����ݿ�ʼʱ��������մ���---tanjishan,��������̨
				        //SetOrderFirstDayTimes(rowid);
				        //�Ӽ���ѡ��Ĭ�ϻ�
				        //$("#" + rowid + "_Urgent").prop("checked", false);
				        if ((RowDataObj.ARCIMDefSensitive == "N")||(RowDataObj.OrderPriorRowid !=GlobalObj.ShortOrderPriorRowid)) {
				            SetCellChecked(rowid, "Urgent", false);
				        } else {
				            SetCellChecked(rowid, "Urgent", true);
				        }
				        //�������֤ҽ�����й�����ϵ��������ټ���
				        CheckOrderPriorRemarksLegal(rowid)
				        //��������
				        //CheckFreqAndPackQty(rowid)--tanjishan,��������̨
				        //��ӿհ���,������סԺҵ����ת��ָ���������������
				        //Add_Order_row();
				        //���ý���λ��
				        //SetFocusCell(rowid,"OrderName")
				        //SetTimeLog("AddItemDataToRow", "���������ݸ�ֵ������֮��");
						callBackExecFun();
					}
				})
		    })(resolve);
	    }
	}).then(function(){
		var OrderFreqTimeDoseStr=RowDataObj.OrderFreqTimeDoseStr;
	    if (OrderFreqTimeDoseStr!=""){
		    var DoseQtyStr=GetDoseQty(OrderFreqTimeDoseStr);
			SetCellData(rowid, "OrderDoseQty",DoseQtyStr);
		}
	    //��Σҩ������ʾ
	    var OrderName=GetCellData(rowid,"OrderName");
	    var OrderHiddenPara=GetCellData(rowid, "OrderHiddenPara");
	    var PHCDFCriticalFlag=OrderHiddenPara.split(String.fromCharCode(1))[17];
	    if (PHCDFCriticalFlag=="Y"){
		    if (GetEditStatus(rowid) == true) {
		    	$("#"+rowid+"_OrderName").parent().parent().addClass('OrderCritical');
		    }else{
			    $('#Order_DataGrid').setCell(rowid,"OrderName",RowDataObj.OrderName,"OrderCritical","");
			}
		}
	    var OrderPriorRemarksRowId=GetCellData(rowid, "OrderPriorRemarksRowId");
	    if (OrderPriorRemarksRowId=="ONE"){
	        var obj = { OrderDur: true };
	        ChangeRowStyle(rowid, obj);
		}
		var OrderFreqTimeDoseStr=GetCellData(rowid,"OrderFreqTimeDoseStr");
	    if (OrderFreqTimeDoseStr!=""){
		     ChangeRowStyle(rowid, {OrderDoseQty:"readonly"});
		}
		SetPoisonOrderStyle(RowDataObj.OrderPoisonCode, RowDataObj.OrderPoisonRowid, rowid);
	    
	    //Ƶ��->�Ƴ̼��
	    FreqDurChange(rowid)
	    var OrdSeqNo=GetCellData(rowid, "id"); //(ParamObj.OrderType == "R")&&
	    if ((StyleConfigObj.OrderMasterSeqNo==true)&&(OrdSeqNo!=PageLogicObj.StartMasterOrdSeq)){
			if ((PageLogicObj.IsStartOrdSeqLink==1)&&(RowDataObj.LinkedMasterOrderRowid=="")){
				if (PageLogicObj.StartMasterOrdSeq==""){
					PageLogicObj.StartMasterOrdSeq=rowid; //�����ʼ������û�����ù�����ʼ��ţ���Ĭ�Ͽ�ʼ������ĵ�һ��Ϊ��ҽ��
				}else{
					var CanLink=1; //�Ƿ�ɹ���
					var subOrderType = GetCellData(rowid, "OrderType");
					var OrderInstrRowid=GetCellData(rowid, "OrderInstrRowid");
					var MainEditStatus=GetEditStatus(PageLogicObj.StartMasterOrdSeq);
					var EditStatus=GetEditStatus(rowid);
					if ((MainEditStatus)&&(EditStatus)) {
						var IdOrderFreq = PageLogicObj.StartMasterOrdSeq + "_" + "OrderFreq";
			            var objFreq = document.getElementById(IdOrderFreq);
					    var subIdOrderFreq = rowid + "_" + "OrderFreq";
		            	var subobjFreq = document.getElementById(subIdOrderFreq);
		            	// ��ҽ��Ƶ�β��ɱ༭,��ҽ���ɱ༭�򲻿ɹ���
		            	// ���ò��ɹ���������,���ɹ���
		            	if (((objFreq.disabled)&&((!subobjFreq.disabled)||(subOrderType=="R")))||(!StyleConfigObj.OrderMasterSeqNo)){ 
			            	CanLink=0;
			            }
			            // ��ҽ���÷����ɱ༭,��ҽ���ɱ༭�򲻿ɹ���
			            var objOrderInstr = document.getElementById(PageLogicObj.StartMasterOrdSeq + "_" + "OrderInstr");
			            var subOrderInstr = document.getElementById(rowid + "_" + "OrderInstr");
			            //if (((objOrderInstr.disabled)&&((!subOrderInstr.disabled)||(subOrderType=="R")))||(!StyleConfigObj.OrderMasterSeqNo)){ 
			            if ((objOrderInstr.disabled)&&(!subOrderInstr.disabled)&&(OrderInstrRowid =="")){ 
			            	CanLink=0;
			            }
		            }else{
			            var MainStyleConfigStr = GetCellData(PageLogicObj.StartMasterOrdSeq, "StyleConfigStr");
			            var MainStyleConfigObj = {};
					    if (MainStyleConfigStr != "") {
					        MainStyleConfigObj = eval("(" + MainStyleConfigStr + ")");
					    }
			            if (((!MainStyleConfigObj.OrderFreq)&&((StyleConfigObj.OrderFreq)||(subOrderType=="R")))||(!StyleConfigObj.OrderMasterSeqNo)){ 
			            	CanLink=0;
			            }
			            if ((!MainStyleConfigObj.OrderInstr)&&(StyleConfigObj.OrderInstr)&&(OrderInstrRowid =="")){ 
			            	CanLink=0;
			            }
			        }
		            if (!StyleConfigObj.OrderMasterSeqNo) {
			            CanLink=0;
			        }
		            // ��ҽ����ҩƷ,��ҽ���ǳ�Ժ��ҩ,���ɹ���
		            var MainOrderPriorRowid=GetCellData(PageLogicObj.StartMasterOrdSeq,"OrderPriorRowid");
			        if ((MainOrderPriorRowid==GlobalObj.OutOrderPriorRowid)&&(subOrderType!="R")){
				        CanLink=0;
				    }
		            if (CanLink=="1"){
						SetCellData(rowid, "OrderMasterSeqNo", PageLogicObj.StartMasterOrdSeq);
						var Status=$("#jqg_Order_DataGrid_" + rowid).prop("checked");
				        if (Status){
			            	$("#Order_DataGrid").setSelection(rowid, false);
			            }
		            }
				}
			}
		}
		//���ù���
	    var MasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
	    if (MasterSeqNo!=""){
		    var Selrowids = GetSelRowId();
	        var selRowLen=Selrowids.length
		    for (var tmpi = selRowLen-1; tmpi >=0; tmpi--) {
		        if (CheckIsItem(Selrowids[tmpi]) == false) {
			        var tmpMasterSeqNo=GetCellData(Selrowids[tmpi], "OrderMasterSeqNo");
			        var Status=$("#jqg_Order_DataGrid_" + Selrowids[tmpi]).prop("checked");
			        if (Status){
		            	$("#Order_DataGrid").setSelection(Selrowids[tmpi], false);
		            }
		        }
		    }
		    if (FromCopyAndUnEditFlag=="1") {
			    EditRow(rowid);
			    SetMasterSeqNo(MasterSeqNo, rowid, "S");
			    EndEditRow(rowid);
			}else{
	        	SetMasterSeqNo(MasterSeqNo, rowid, "S");
	        	if (AddMethod == "obj") {
	        		SetCellData(rowid, "OrderPackQty", RowDataObj.OrderPackQty);
	        	}
	        }
	     }else{
		    var Status=$("#jqg_Order_DataGrid_" + rowid).prop("checked");
	        if (Status){
	        	$("#Order_DataGrid").setSelection(rowid, false);
	        }
		 }
		OrdDoseQtyBindClick(rowid);
	    //֪ʶ��
	    CheckLibPhaFunction("Q", rowid, "")
	    if ((RowDataObj.LinkedMasterOrderRowid!="")||(RowDataObj.OrderNurseLinkOrderRowid!="")) {
		    initItemInstrDiv(rowid);
		}
	    //OrderPackUOMchangeCommon ���ѵ��ú�����ҩ,�˴������ظ�
	    if (AddMethod != "obj") {
	        //XHZY_Click();
	    }
	    callBackFun(true);
	})
}

//��ӵ����  2014-04-23  ��
/*
rowid:�к�
OrdParams:��Ҫ¼���ҽ����Ŀ�ļ��ϣ����ӵ���ҽ�������������������Ӷ������ԣ�
ExpStr:��չ��Ϣ��ȫ�֡��ǵ���ҽ����Ŀ���ԣ���������ֵ���䣩
*/
//
function AddItemToList(rowid,OrdParams, AddMethod,ExpStr,callBackFun){
	//��3��������"data"��ʽ����������ж���ʽ��"obj"��ʽ��������ж���ʽ
    if (AddMethod == "obj") {
		PageLogicObj.m_AddItemToListMethod = "ARCOS";
    }
	
	var RtnObj={
		returnValue:false,
		rowid:rowid
	};
	var CopyType=mPiece(ExpStr, "^", 0);
	var FastEntryMode=mPiece(ExpStr, "^", 1);
	var FastEntryName=mPiece(ExpStr, "^", 2);
	var OrderARCOSRowid=mPiece(ExpStr, "^", 3);
	if (FastEntryMode==1){
		rowid=GetAddRowid(rowid,"data");
	}else{
		rowid=GetAddRowid(rowid,AddMethod);
	}
	var prerowid = GetPreRowId(rowid);
    PageLogicObj.NotEnoughStockFlag=0;
    SetTimeLog("AddItemToList", "start");
	if (typeof ItemExpInfo=="undefined"){
		ItemExpInfo="";
	}
	
    var RowDataObj = {};
    for (var k = 0; k < colModelAry.length; k++) {
        var key = colModelAry[k].name;
        $.extend(RowDataObj, { key: '' });
    }
    //ȡĬ������
    var DefaultParamObj = GetDefaultData(rowid);
    //��װ�ж���
    $.extend(RowDataObj, DefaultParamObj);
	var OrderPriorRemarks=OrderPriorRemarksRowId=RowOrderBillTypeRowid="";
	//if (document.getElementById(rowid + "_OrderARCIMRowid")){
	if (AddMethod == "data") {
		//�����ӣ���ֹ����Ĭ���е�ʱ���������˵��
		OrderPriorRemarks = GetCellData(rowid, "OrderPriorRemarks");
		OrderPriorRemarksRowId = GetCellData(rowid, "OrderPriorRemarksRowId");
		RowOrderBillTypeRowid = GetCellData(rowid, "OrderBillTypeRowid");
	}
	$.extend(RowDataObj, { OrderPriorRemarks: OrderPriorRemarks, OrderPriorRemarksRowId:OrderPriorRemarksRowId });
    
    var OrderBillTypeRowid = parseInt(DefaultParamObj.OrderBillTypeRowid);
    if (RowOrderBillTypeRowid != "") {
        RowOrderBillTypeRowid = RowOrderBillTypeRowid.replace(String.fromCharCode(10), "")
        OrderBillTypeRowid = RowOrderBillTypeRowid
    }
    var OrderActionRowid=GetCellData(rowid, "OrderActionRowid")
    $.extend(RowDataObj, { OrderActionRowid: OrderActionRowid});
    
    //�������¼����ȡ���տ���?�Ͱѵ�¼���Ҵ���ȥ session['LOGON.CTLOCID']
    var LogonDep = GetLogonLocByFlag();
    //��Ժ
	var OrderOpenForAllHosp=$("#OrderOpenForAllHosp").checkbox("getValue")?1:0;
    var SessionStr = GetSessionStr();
    var OrderARCIMRowid=GetCellData(rowid, "OrderARCIMRowid");
    if (OrderARCIMRowid!=""){
	    var GlobalDefaultOrderPriorRowid=GetCellData(rowid, "OrderPriorRowid");
	    var OrderPrior=GetCellData(rowid, "OrderPrior");
	    var PageDefaultOrderPriorStr=GlobalDefaultOrderPriorRowid + "^" + GlobalDefaultOrderPriorRowid+ ":" +OrderPrior;
	}else{
		var PageDefaultOrderPriorStr=GetDefaultOrderPrior("");
		var GlobalDefaultOrderPriorRowid=GlobalObj.DefaultOrderPriorRowid;
	}
    var BaseParam = {
		///����ҽ����Ϣ-��̨�������ⲿ������
		OrderARCIMRowid:"",
		ItemDefaultRowId:"",
		OrderBillTypeRowid:OrderBillTypeRowid,
		RelocRowID:"",
		MaterialBarcode:"",
		ITMRowId:"",
		OrderBodyPartLabel:"",
		MasterSeqNo:PageLogicObj.StartMasterOrdSeq==rowid?"":PageLogicObj.StartMasterOrdSeq,
		///rowid��Ҫ�ں�̨�޸�,��ǰ̨��ʵ���кŲ�һ���ܶ���������ԭ��ο�����ҽ����¼�빦��
		rowid:rowid,
		///ȫ�ֱ���
		Adm:GlobalObj.EpisodeID,
		CopyType:CopyType,
		LogonDep:LogonDep,
		OrderOpenForAllHosp:OrderOpenForAllHosp, 
		SessionStr:SessionStr,
		AddMethod:AddMethod,
		PPRowId:GlobalObj.PPRowId,
		OrderPriorContrlConfig:GlobalObj.OrderPriorContrlConfig,
		PageDefaultOrderPriorStr:PageDefaultOrderPriorStr,
		GlobalDefaultOrderPriorRowid:GlobalDefaultOrderPriorRowid,
		VerifiedOrderObj:VerifiedOrderObj,
		isEditCopyItem:(function(){if (UIConfigObj.isEditCopyItem){return 1;}else{return 0;}})(),
		AnaesthesiaID:GetMenuPara("AnaesthesiaID"),
		OrderOperationCode:GetMenuPara("AnaestOperationID"),
        OrderARCOSRowid:OrderARCOSRowid,
        OrderChronicDiagCode:GetChronicDiagCode()
    };
    if (($.isNumeric(prerowid) == true)&&(!BaseParam.OrderOperationCode)) {
	    var PreOrderOperationCode=GetCellData(prerowid,"OrderOperationCode");
	    BaseParam.OrderOperationCode=PreOrderOperationCode;
	}
    if (FastEntryMode==1) BaseParam.MasterSeqNo="";
    var ItemOrdsJson=GetItemOrds();
	//��Ҫ�󶨵����ϵ�ҽ��
	var UserOptionsArr=new Array();
	var NeedAddItemCongeriesArr=new Array();
	/*
	���ڿ���ҽ�����еĵ�����Ŀ���жϻ�����Ҫ����ҩ�ﴦ���Ƿ��ܹ���ҽ��¼���У�����ܣ������óɶ�����¼�루�����������¼�룬ֱ��callback����
	TODO:
	*/
	new Promise(function(resolve,rejected){
		GetItemCongeries(OrdParams,BaseParam,ItemOrdsJson,RowDataObj,UserOptionsArr,resolve);
	}).then(function(NeedAddItemCongeriesObj){
		return new Promise(function(resolve,rejected){
			NeedAddItemCongeriesObjArr=NeedAddItemCongeriesObj;
			if (NeedAddItemCongeriesObj.length==0){
				$.extend(RtnObj, {returnValue:false});
				if (callBackFun) callBackFun(RtnObj);
				return;
			}
			PageLogicObj.NotEnoughStockFlag=0;
			if (FastEntryMode==1){
				//ҽ���׿���¼��
				var StyleConfigObj={
					OrderDur: false,
					OrderFreq: false,
					OrderPackQty: false,
					OrderPackUOM: false,
					OrderDoseQty: false,
					OrderDoseUOM: false,
					OrderInstr: false,
					OrderPrice: false,
					OrderAction: false,
					OrderMasterSeqNo: false,
					OrderLabSpec: false,
					OrderNotifyClinician: false,
					OrderInsurCat: false,
					OrderSpeedFlowRate: false,
					OrderFlowRateUnit: false,
					OrderNeedPIVAFlag: false,
					AntUseReason: false,
					OrderLabEpisodeNo: false,
					Urgent: false,
					OrderPrior: false,
					OrderSkinTest: false,
					OrderFirstDayTimes: false,
					OrderStartDate:true
				}
				//����ҽ���׿�ʼʱ���ж�,ֻ�жϿ���Ȩ��
				StyleConfigObj.OrderStartDate=CheckDateTimeModifyFlag(GlobalObj.ModifySttDateTimeAuthority,"") 

				var StyleConfigStr = JSON.stringify(StyleConfigObj);
				var ItemCongeriesSum=0;
				var NeedAddSingleRowItem=[];
				var Len=NeedAddItemCongeriesObj.length;
				for (var i=0;i<NeedAddItemCongeriesObj.length;i++) {
					/*
					���ڿ���ҽ�����еĵ�����Ŀ���жϻ����ڴ˴�����
					������ҩ������ҽ������ϸά����������
					*/
					if (NeedAddItemCongeriesObj[i].SingleRowFlag=="Y"){
						NeedAddSingleRowItem.push(NeedAddItemCongeriesObj[i]);
						NeedAddItemCongeriesObj.splice(i,1);
						i=i-1;
						continue;
					}
					ItemCongeriesSum=parseFloat(ItemCongeriesSum)+parseFloat(NeedAddItemCongeriesObj[i].OrderSum);
				}
				rowid=GetAddRowid(rowid,"data");
		    	ChangeRowStyle(rowid, StyleConfigObj);
		    	if (NeedAddSingleRowItem.length<Len){
					SetCellData(rowid, "OrderName", FastEntryName);
					SetCellData(rowid, "OrderARCOSRowid", OrderARCOSRowid);
					SetCellData(rowid, "OrderSum", ItemCongeriesSum);
					var OrderItemCongeriesJson=JSON.stringify(NeedAddItemCongeriesObj);
			    	SetCellData(rowid, "OrderItemCongeries", OrderItemCongeriesJson);
			    	//var OrderCoverMainIns=NeedAddItemCongeriesObj[i].OrderCoverMainIns;
			    	if (NeedAddItemCongeriesObj[0].OrderCoverMainIns == "N") {
			            //ҽ��
			            SetCellChecked(rowid, "OrderCoverMainIns", false);
			        } else {
			            SetCellChecked(rowid, "OrderCoverMainIns", true);
			        }
		    	}
				if (NeedAddSingleRowItem.length>0){
					rowid=GetAddRowid("",AddMethod);
					AddItemCongeriesToRow(rowid,AddMethod,NeedAddSingleRowItem,resolve);
				}
			}else{
				AddItemCongeriesToRow(rowid,AddMethod,NeedAddItemCongeriesObj,resolve);
			}
			
		})
	}).then(function(){
		//��Ϊ�����������ҩ��п����ֻ�ɾ���У��������ٻ�ȡһ�������к�
		rowid = GetPreRowId();
		if (PageLogicObj.m_AddItemToListMethod != "ARCOS") SetScreenSum();
		XHZY_Click();
		SetTimeLog("AddItemToList", "end");
		if ((rowid!="")&&(NeedAddItemCongeriesObjArr.length>0)){
			$.extend(RtnObj, {returnValue:true,rowid:rowid});
		}else{
			$.extend(RtnObj, {returnValue:false});
		}
		if (callBackFun) callBackFun(RtnObj);
	})
	//�����󼯺���ӵ�����
	function AddItemCongeriesToRow(rowid,AddMethod,NeedAddItemCongeriesObj,callBackFun){
		var seqnoarr = new Array(),GroupSeqNoArr = new Array(),tempseqnoarr= new Array();
		var SuccessCount=0;
		var ParamObj={},CopyRowDataObj={};
		var Startrowid="",CalSeqNo="";
		function loop(i){
			new Promise(function(resolve,rejected){
				ParamObj={};
				ParamObj=NeedAddItemCongeriesObj[i];
				rowid=GetAddRowid(rowid,AddMethod);
				ParamObj.rowid=rowid;
				if (Startrowid==""){Startrowid=ParamObj.rowid;}
				CalSeqNo=ParamObj.CalSeqNo;
				//��¼������ϵ
				var MasterSeqNo="";
				tempseqnoarr = CalSeqNo.split(".");
				if (tempseqnoarr.length > 1) {
					var masterseqno = tempseqnoarr[0];
					if (seqnoarr[masterseqno]) {
						MasterSeqNo = seqnoarr[masterseqno];
					}
				}
				ParamObj.OrderMasterSeqNo=MasterSeqNo;
				if (MasterSeqNo!=""){
					GroupSeqNoArr[rowid]=MasterSeqNo;
				}
				CopyRowDataObj={};
				CopyRowDataObj=DeepCopyObject(RowDataObj);
				//����������
				AddItemDataToRow(ParamObj,CopyRowDataObj,AddMethod,resolve);
			}).then(function(returnValue){
				if (returnValue == true) {
					if (tempseqnoarr.length =1) {
						newseqno = CopyRowDataObj.id;
						seqnoarr[CalSeqNo] = newseqno;
					}
					if (PageLogicObj.m_selArcimRowIdStr=="") PageLogicObj.m_selArcimRowIdStr=ParamObj.OrderARCIMRowid;
					else  PageLogicObj.m_selArcimRowIdStr=PageLogicObj.m_selArcimRowIdStr+"^"+ParamObj.OrderARCIMRowid;
				}
				if ((i+1)<NeedAddItemCongeriesObj.length){
					rowid="";
				}
				SuccessCount++;
				i++;
				if ( i < NeedAddItemCongeriesObj.length ) {
					 loop(i);
				}else{
					callBackFun(rowid);
				}
			})
		}
		loop(0);
	}
	function GetItemOrds(){
		var ItemOrdsObj={
			Length:0,
			ItemOrds:[]	//�ж��󼯺�
		}
		var rowids = $('#Order_DataGrid').getDataIDs();
		for (var i = 0; i < rowids.length; i++) {
			var OrderItemRowid = GetCellData(rowids[i], "OrderItemRowid");
			var OrderARCIMRowid = GetCellData(rowids[i], "OrderARCIMRowid");
			var OrderARCOSRowid = GetCellData(rowids[i], "OrderARCOSRowid");
			if ((OrderItemRowid!="")||((OrderARCIMRowid=="")&&(OrderARCOSRowid==""))) continue;
			var OrderSeqNo = GetCellData(rowids[i], "id").replace(/(^\s*)|(\s*$)/g, '');
			var OrderMasterSeqNo = GetCellData(rowids[i], "OrderMasterSeqNo").replace(/(^\s*)|(\s*$)/g, '');
			var OrderItemCongeriesJson = GetCellData(rowids[i], "OrderItemCongeries");
			if (OrderItemCongeriesJson!=""){
				var OrderItemCongeriesObj=eval("("+OrderItemCongeriesJson+")")
				for (var j=0;j<OrderItemCongeriesObj.length;j++) {
					var OrderARCIMRowid=OrderItemCongeriesObj[j].OrderARCIMRowid;
					var OrderPriorRowid=OrderItemCongeriesObj[j].SpecOrderPriorRowid;
					var OrderBillTypeRowid=OrderItemCongeriesObj[j].OrderBillTypeRowid;
					var OrderFreqDispTimeStr = OrderItemCongeriesObj[j]["OrderFreqDispTimeStr"]; 
					if (OrderFreqDispTimeStr!="") {
						var OrderStartDate = OrderItemCongeriesObj[j]["OrderStartDate"];
					}else{
						var OrderStartDate=GetCellData(rowids[i],"OrderStartDate");
					}
					var OrderEndDate="";
					var OrderDate = GetCellData(rowids[i], "OrderDate");
					var OrderLabSpecRowid=OrderItemCongeriesObj[j].OrderLabSpecRowid;
					var OrderFreqRowid=OrderItemCongeriesObj[j].OrderFreqRowid;
					var OrderDurRowid=OrderItemCongeriesObj[j].OrderDurRowid;
					var OrderInstrRowid=OrderItemCongeriesObj[j].OrderInstrRowid;
					var OrderRecDepRowid=OrderItemCongeriesObj[j].OrderRecDepRowid;
					var OrderFirstDayTimes=OrderItemCongeriesObj[j].OrderFirstDayTimes;
					var OrderNeedPIVAFlag=OrderItemCongeriesObj[j].OrderNeedPIVAFlag;
					var OrderSpeedFlowRate=OrderItemCongeriesObj[j].OrderSpeedFlowRate;
					var OrderFlowRateUnitRowId=OrderItemCongeriesObj[j].OrderFlowRateUnitRowId;
					var OrderBodyPartID="";
					var OrderStageCode = GetCellData(rowids[i], "OrderStageCode");
					var ExceedReasonID="",OrderMaterialBarcode="";
					var OrderSkinTest=OrderItemCongeriesObj[j].OrderSkinTest;
					var OrderActionRowid=OrderItemCongeriesObj[j].OrderActionRowid;
					var ItemOrd={
						OrderItemRowid:'',
						rowid:rowids[i],
						OrderSeqNo:OrderSeqNo,
						OrderMasterSeqNo:OrderMasterSeqNo,
						OrderPriorRowid:OrderPriorRowid,
						OrderARCIMRowid:OrderARCIMRowid,
						OrderBillTypeRowid:OrderBillTypeRowid,
						OrderStartDate:OrderStartDate,
						OrderEndDate:OrderEndDate,
						OrderDate:OrderDate,
						OrderLabSpecRowid:OrderLabSpecRowid,
						OrderFreqRowid:OrderFreqRowid,
						OrderDurRowid:OrderDurRowid,
						OrderInstrRowid:OrderInstrRowid,
						OrderRecDepRowid:OrderRecDepRowid,
						OrderFirstDayTimes:OrderFirstDayTimes,
						OrderNeedPIVAFlag:OrderNeedPIVAFlag,
						OrderSpeedFlowRate:OrderSpeedFlowRate,
						OrderFlowRateUnitRowId:OrderFlowRateUnitRowId,
						OrderBodyPartID:OrderBodyPartID,
						OrderStageCode:OrderStageCode,
						ExceedReasonID:ExceedReasonID,
						OrderMaterialBarcode:OrderMaterialBarcode,
						OrderSkinTest:OrderSkinTest,
						OrderActionRowid:OrderActionRowid,
						OrderFreqDispTimeStr:OrderFreqDispTimeStr
					};
					ItemOrdsObj.ItemOrds.push(ItemOrd);
					ItemOrdsObj.Length=ItemOrdsObj.Length+1;
				}
				continue;
			}
			var OrderPriorRowid = GetCellData(rowids[i], "OrderPriorRowid");
			var OrderPriorRemarks = GetCellData(rowids[i], "OrderPriorRemarksRowId");
            OrderPriorRowid = ReSetOrderPriorRowid(OrderPriorRowid, OrderPriorRemarks);
			var OrderBillTypeRowid=GetCellData(rowids[i], "OrderBillTypeRowid");
			var OrderStartDate=GetCellData(rowids[i], "OrderStartDate");
			var OrderEndDate=GetCellData(rowids[i], "OrderEndDate");
			var OrderDate=GetCellData(rowids[i], "OrderDate");
			
			var OrderLabSpecRowid=GetCellData(rowids[i], "OrderLabSpecRowid");
			var OrderFreqRowid=GetCellData(rowids[i], "OrderFreqRowid");
			var OrderDurRowid=GetCellData(rowids[i], "OrderDurRowid");
			var OrderInstrRowid=GetCellData(rowids[i], "OrderInstrRowid");
			var OrderRecDepRowid=GetCellData(rowids[i], "OrderRecDepRowid");
			var OrderFirstDayTimes=GetCellData(rowids[i], "OrderFirstDayTimes");
			var OrderNeedPIVAFlag=GetCellData(rowids[i], "OrderNeedPIVAFlag");
			var OrderSpeedFlowRate=GetCellData(rowids[i], "OrderSpeedFlowRate");
			var OrderFlowRateUnitRowId=GetCellData(rowids[i], "OrderFlowRateUnitRowId");
			var OrderBodyPartID=GetCellData(rowids[i], "OrderBodyPartID");
			var OrderStageCode=GetCellData(rowids[i], "OrderStageCode");
			var ExceedReasonID=GetCellData(rowids[i], "ExceedReasonID");
			var OrderMaterialBarcode=GetCellData(rowids[i], "OrderMaterialBarcodeHiden");
			var OrderSkinTest=GetCellData(rowids[i], "OrderSkinTest");
			var OrderActionRowid=GetCellData(rowids[i], "OrderActionRowid");
			var OrderFreqDispTimeStr=GetCellData(rowids[i], "OrderFreqDispTimeStr");
			var ItemOrd={
				OrderItemRowid:'',
				rowid:rowids[i],
				OrderSeqNo:OrderSeqNo,
				OrderMasterSeqNo:OrderMasterSeqNo,
				OrderPriorRowid:OrderPriorRowid,
				OrderARCIMRowid:OrderARCIMRowid,
				OrderBillTypeRowid:OrderBillTypeRowid,
				OrderStartDate:OrderStartDate,
				OrderEndDate:OrderEndDate,
				OrderDate:OrderDate,
				OrderLabSpecRowid:OrderLabSpecRowid,
				OrderFreqRowid:OrderFreqRowid,
				OrderDurRowid:OrderDurRowid,
				OrderInstrRowid:OrderInstrRowid,
				OrderRecDepRowid:OrderRecDepRowid,
				OrderFirstDayTimes:OrderFirstDayTimes,
				OrderNeedPIVAFlag:OrderNeedPIVAFlag,
				OrderSpeedFlowRate:OrderSpeedFlowRate,
				OrderFlowRateUnitRowId:OrderFlowRateUnitRowId,
				OrderBodyPartID:OrderBodyPartID,
				OrderStageCode:OrderStageCode,
				ExceedReasonID:ExceedReasonID,
				OrderMaterialBarcode:OrderMaterialBarcode,
				OrderSkinTest:OrderSkinTest,
				OrderActionRowid:OrderActionRowid,
				OrderFreqDispTimeStr:OrderFreqDispTimeStr
			};
			ItemOrdsObj.ItemOrds.push(ItemOrd);
			ItemOrdsObj.Length=ItemOrdsObj.Length+1;
		}
		var ItemOrdsJson=JSON.stringify(ItemOrdsObj);
		return ItemOrdsJson;
	}
	//��ȡ��,��ƴ¼�롢��ֵ�ᴫ��rowid
	function GetAddRowid(rowid,AddMethod){
		if (rowid==""){
			var CruRow = GetPreRowId();
			if ((CruRow!="")&&(CheckIsClear(CruRow) == true)) {
				if (AddMethod=="obj"){
					DeleteRow(CruRow);
					var rowid = GetNewrowid();
				}else{
					var rowid = CruRow;
				}
			}else{
				if (AddMethod=="obj"){
					var rowid = GetNewrowid();
				}else{
					var rowid = Add_Order_row();
				}
			}
		}
		return rowid;
	}
	/*
	OrdCongeriesObj:ҽ����Ϣ\����ҽ�����ƻ�ҽ���ף�����ҽ����Ϣ����
	BaseParamObj:�������������Ϣ
	ItemOrdsJson:��������ӵ����ϵ�δ��˵�ҽ��������Ϣ
	RowDataObj����ǰ���ϵ���Ϣ��δ����ʱΪĬ����Ϣ��
	UserOptionsArr��������Ҫ�û��ж�ѡ�����Ϣ������confirmѡ���Ƶ�Σ��ò�����ֵ�����û���������������仯����ᴥ���ݹ���������µ��ú�̨������ȡ�µ�ҽ�����ݴ�
	*/
	//ItemCongeriesParamObj
	function GetItemCongeries(OrdCongeriesObj,BaseParamObj,ItemOrdsJson,RowDataObj,UserOptionsArr,callBackFun){
		var NeedAddItemCongeriesObj=new Array();
		var OrdCongeriesJson=JSON.stringify(OrdCongeriesObj);
		var BaseParamJson=JSON.stringify(BaseParamObj);
		var RowDataJson=JSON.stringify(RowDataObj);
		var UserOptionsJson=JSON.stringify(UserOptionsArr);
		
		var ItemCongeries = cspRunServerMethod(GlobalObj.GetItemCongeriesToListMethod, OrdCongeriesJson,BaseParamJson,ItemOrdsJson,RowDataJson,UserOptionsJson);
		var ItemCongeriesObj=eval("("+ItemCongeries+")");
		/***
		  UserOptionCount ��Ҫ���ж���ǰ��̨������callbacks����,����ҽ����/ҽ�����Ƶ�һ��¼�������,
		  ��һ��ֻ������Ҫ��������ʾ���ڶ��ν���ȫ��ҽ����callbacks������ʾ����ֹ��ʾ�ظ���
		***/
		var UserOptionCount=0;
		for (var i=0;i<ItemCongeriesObj.length;i++){
			if (typeof ItemCongeriesObj[i].CallBakFunS=="object"){
				var ItemToListDetailObj=ItemCongeriesObj[i];
				if (!$.isEmptyObject(ItemToListDetailObj)) {
					for (var j=0;j<ItemToListDetailObj.CallBakFunS.length;j++){
						var FunCode=ItemToListDetailObj.CallBakFunS[j].CallBakFunCode;
						if ((FunCode=="SetOrderFreqDispTimeStr")||(FunCode=="SetMulDoses")||(FunCode=="GuideAllergy")||(FunCode=="AppendAllergyOrder")) {
							UserOptionCount++;
						}
					}
				}				
			}
		}
		var RecursionFlag=false,Sum=0;
		new Promise(function(resolve,rejected){
			(function(callBackExecFun){
				function loop(i){
					new Promise(function(resolve,rejected){
						var ItemToListDetailObj=ItemCongeriesObj[i];
						if ($.isEmptyObject(ItemToListDetailObj)) {
							resolve();
						}
						///ע��:js�ж�����ָ����
						///У���̨��ȡ���������Ƿ���û��Ƿ���Ҫ�޸�
						$.extend(ItemToListDetailObj, {ItemCongeriesObj:ItemCongeriesObj,UserOptionCount:UserOptionCount,callBackFun:resolve});
						CheckItemCongeries(ItemToListDetailObj);
					}).then(function(CheckBeforeAddObj){
						var ItemToListDetailObj=ItemCongeriesObj[i];
						if (typeof CheckBeforeAddObj!="undefined"){
							if (CheckBeforeAddObj.UserOptionObj.length>0){
								UserOptionsArr.push({rowid:ItemToListDetailObj.OrdListInfo.rowid,UserOption:CheckBeforeAddObj.UserOptionObj});
								RecursionFlag=true;
							}
							if (!RecursionFlag) {
								//���ÿ���
								var OrderPriorRowid=ItemToListDetailObj.OrdListInfo.OrderPriorRowid;
								var OrderPriorRemarksRowId=ItemToListDetailObj.OrdListInfo.OrderPriorRemarksRowId;
								var OrderPrice=ItemToListDetailObj.OrdListInfo.OrderPrice;
								if ((OrderPriorRowid != GlobalObj.OMOrderPriorRowid) && (OrderPriorRowid != GlobalObj.OMSOrderPriorRowid) && (OrderPrice != 0) && (OrderPriorRemarksRowId != "OM") && (OrderPriorRemarksRowId != "ZT")) {
									Sum=parseFloat(Sum)+parseFloat(ItemToListDetailObj.OrdListInfo.OrderSum);
									var PrescCheck = CheckPrescriptSum(Sum, ItemToListDetailObj.OrdListInfo.OrderARCIMRowid);
									if (PrescCheck == false) {
										$.extend(CheckBeforeAddObj, {SuccessFlag:false});
									}
								}
							}
							if ((CheckBeforeAddObj.SuccessFlag==true)&&($.isEmptyObject(ItemToListDetailObj.OrdListInfo)==false)){
								$.extend(ItemToListDetailObj.OrdListInfo, {StartDateEnbale:CheckBeforeAddObj.StartDateEnbale,OrderDateEnbale:CheckBeforeAddObj.OrderDateEnbale});
								NeedAddItemCongeriesObj[NeedAddItemCongeriesObj.length]=ItemToListDetailObj.OrdListInfo;
							}
						}
						i++;
						if ( i < ItemCongeriesObj.length ) {
							 loop(i);
						}else{
							if (RecursionFlag==true){
								GetItemCongeries(OrdCongeriesObj,BaseParamObj,ItemOrdsJson,RowDataObj,UserOptionsArr,callBackFun);
								return;
							}else{
								callBackExecFun();
							}
						}
					})
				}
				loop(0)
			})(resolve); //�˴���resolve��ָcallBackFun(NeedAddItemCongeriesObj)
		}).then(function(){
			SetTimeLog("AddItemToList", "GetItemCongeries over");
			callBackFun(NeedAddItemCongeriesObj);
		});
	}
}
function SetRecLocStr(Row, PriorRowid, OrderPriorRemarks) {
	var SpecOrderPriorRowid=ReSetOrderPriorRowid(PriorRowid, OrderPriorRemarks);
    if (GlobalObj.PAAdmType == "I") {
	    var OutLocFlag=0;
        //ѡ���Ժ��ҩʱ,���ϳ�Ժ��Ժ���տ���ֵ
        if (PriorRowid == GlobalObj.OutOrderPriorRowid) {
            var OrderOutPriorRecLocStr = GetCellData(Row, "OrderOutPriorRecLocStr");
            if (OrderOutPriorRecLocStr != "") {
	            OutLocFlag=1;
                SetColumnList(Row, "OrderRecDep", OrderOutPriorRecLocStr);
                OrderRecDepChangeCom(Row);
            }
        }
        var OneLocFlag=0;
        //ѡ��ȡҩҽ��ʱ,����ȡҩҽ�����տ���ֵ
        if ((PriorRowid == GlobalObj.OneOrderPriorRowid) || (OrderPriorRemarks == "ONE")) {
            var OrderOnePriorRecLocStr = GetCellData(Row, "OrderOnePriorRecLocStr");
            if (OrderOnePriorRecLocStr != "") {
	            OneLocFlag=1;
                SetColumnList(Row, "OrderRecDep", OrderOnePriorRecLocStr);
                OrderRecDepChangeCom(Row);
            }
        }
		var HolidayLocFlag=0;
        if ((OutLocFlag==0)&&(OneLocFlag==0)){
	        //�ǳ���ҩƷҽ��,���Ͻڼ��ս��տ���ֵ
		    var OrderType = GetCellData(Row, "OrderType");
	        if ((PriorRowid!=GlobalObj.LongOrderPriorRowid)&&(OrderType=="R")) { //&&(OrderPriorRemarks!="ONE")
		        var OrderHolidayRecLocStr = GetCellData(Row, "OrderHolidayRecLocStr");
		        if (OrderHolidayRecLocStr != "") {
			        HolidayLocFlag=1;
	                SetColumnList(Row, "OrderRecDep", OrderHolidayRecLocStr);
	                OrderRecDepChangeCom(Row);
	            }
		    }
	    }
        //��ȡҩҽ��,��Ժ��ҩ�л����ǳ�Ժ��ҩ,ҩƷҽ�������Ͻڼ��ս��տ�������ʱ,������ͨ���տ���ֵ
        // (OrderPriorRemarks != "ONE") && (PriorRowid != GlobalObj.OneOrderPriorRowid) && (PriorRowid != GlobalObj.OutOrderPriorRowid) &&
        if ((HolidayLocFlag==0) && (OutLocFlag==0) &&(OneLocFlag==0)) {
			var OrderRecLocStr = GetCellData(Row, "OrderRecLocStr");
			//OrderRecLocStr = GetRecLocStrByPrior(OrderRecLocStr, PriorRowid);
			//SetColumnList(Row, "OrderRecDep", OrderRecLocStr)
			//�÷�������տ���,δ�����÷����տ���,��ȡԭ���տ��Ҵ�
			/*var InstrReclocStr = GetReclocByInstr(Row);
			var OrderRecLocStr = GetRecLocStrByPrior(InstrReclocStr, PriorRowid);
			SetColumnList(Row, "OrderRecDep", OrderRecLocStr);*/
			var OldOrderRecDepRowid=GetCellData(Row, "OrderRecDepRowid");
			var newReclocStr = GetReclocByInstr(Row);
			var InstrReclocStr=newReclocStr.split("^")[0];
			var OrderRecLocStr=newReclocStr.split("^")[1];
			if (InstrReclocStr!=""){
				var OrderRecLocStr = GetRecLocStrByPrior(InstrReclocStr, SpecOrderPriorRowid);
			}else{
				var OrderRecLocStr = GetRecLocStrByPrior(OrderRecLocStr, SpecOrderPriorRowid);
			}
			SetColumnList(Row, "OrderRecDep", OrderRecLocStr);
			if (InstrReclocStr=="") {
				RestoreChangeRecLoc(Row,OldOrderRecDepRowid,OrderRecLocStr);
			}
			var NewOrderRecDepRowid=GetCellData(Row, "OrderRecDepRowid");
			if (NewOrderRecDepRowid!=OldOrderRecDepRowid){
				OrderRecDepChangeCom(Row);
			}
        }
    }
    var retPrice = GetRecPrice(Row)
    if (retPrice==undefined) retPrice="0^0^0^0^0";
    var ArrPrice = retPrice.split("^");
    var Price = ArrPrice[0];
    var OrderConFac = ArrPrice[4];
    if (Price < 0) {
        var Price = ""
    }
    SetCellData(Row, "OrderPrice", Price);
    SetCellData(Row, "OrderConFac", OrderConFac)
}
//������������ݶ���
function SetRowDataObj(rowid, RowDataObj, ParamObj) {
    var dataObj = RowDataObj;
    //OrderPriorRemarks:OrderPriorRemarks,OrderPriorRemarksRowId:OrderPriorRemarksRowId
    $.extend(dataObj, {
        //��ID
        id: rowid,
        //����ʽ
        StyleConfigStr: ParamObj.StyleConfigStr,
        OrderItemRowid: '',
		OrderMasterSeqNo: ParamObj.OrderMasterSeqNo,
        OrderItemCatRowid: ParamObj.OrderItemCatRowid,
        OrderARCIMRowid: ParamObj.OrderARCIMRowid,
        OrderName: ParamObj.OrderName,
        //ҽ���ӷ���
        OrderInsurCat: ParamObj.OrderInsurCat,
        OrderInsurCatRowId: ParamObj.OrderInsurCatRowId,
        //ҽ������
        OrderPrior: ParamObj.OrderPrior,
        OrderPriorRowid: ParamObj.OrderPriorRowid,
        OrderPriorStr: ParamObj.OrderPriorStr,
		//����ҽ������
		ReSetPriorStr:ParamObj.ReSetPriorStr,
        //���μ���
        OrderDoseQty: ParamObj.OrderDoseQty,
        //������λ
        OrderDoseUOM: ParamObj.OrderDoseUOM,
        OrderDoseUOMRowid: ParamObj.OrderDoseUOMRowid,
        //�洢����������
        idoseqtystr: ParamObj.idoseqtystr,
        //�ز�����
        idiagnoscatstr: ParamObj.idiagnoscatstr,
        //Ĭ������ǰһ����������  
        OrderDIACat: ParamObj.OrderDIACat,
        OrderDIACatRowId: ParamObj.OrderDIACatRowId,
        //��¼�·ǳ�Ժ��ҩ�Ľ��տ��Һͳ�Ժ��ҩ�Ľ��տ���?���л�ҽ������ʱ��Ҫ��������
        OrderRecLocStr: ParamObj.OrderRecLocStr,
        OrderOutPriorRecLocStr: ParamObj.OrderOutPriorRecLocStr,
        OrderOnePriorRecLocStr: ParamObj.OrderOnePriorRecLocStr,
        OrderHolidayRecLocStr: ParamObj.OrderHolidayRecLocStr,
        //�趨ǰ��������п����ܿ���
        OrderRecDep: ParamObj.OrderRecDep,
        OrderRecDepRowid: ParamObj.OrderRecDepRowid,
        //�洢����������
        CurrentRecLocStr: ParamObj.CurrentRecLocStr,
        //�걾
        OrderLabSpec: ParamObj.OrderLabSpec,
        OrderLabSpecRowid: ParamObj.OrderLabSpecRowid,
        OrderLabSpecStr: ParamObj.OrderLabSpecStr,
        //Ƶ��
        OrderFreq: ParamObj.OrderFreq,
        OrderFreqRowid: ParamObj.OrderFreqRowid,
        OrderFreqFactor: ParamObj.OrderFreqFactor,
        OrderFreqInterval: ParamObj.OrderFreqInterval,
        OrderFreqDispTimeStr: ParamObj.OrderFreqDispTimeStr,
        //�÷�
        OrderInstr: ParamObj.OrderInstr,
        OrderInstrRowid: ParamObj.OrderInstrRowid,
        //�Ƴ�
        OrderDur: ParamObj.OrderDur,
        OrderDurRowid: ParamObj.OrderDurRowid,
        OrderDurFactor: ParamObj.OrderDurFactor,

        OrderConFac: ParamObj.OrderConFac,
        OrderPHForm: ParamObj.OrderPHForm,
        OrderPHPrescType: ParamObj.OrderPHPrescType,
        OrderDrugFormRowid: ParamObj.OrderDrugFormRowid,
        //����
        OrderPackQty: ParamObj.OrderPackQty,
        OrderPackUOM: ParamObj.OrderPackUOM,
        OrderPackUOMRowid: ParamObj.OrderPackUOMRowid,
        SpecOrderPackUOMRowid:ParamObj.SpecOrderPackUOMRowid,
        //����˵��
        OrderPriorRemarks: ParamObj.OrderPriorRemarks,
        OrderPriorRemarksRowId: ParamObj.OrderPriorRemarksRowId,
        //�۸�
        OrderPrice: ParamObj.OrderPrice,
        //���
        OrderSum: ParamObj.OrderSum,
        //ҽ������
        OrderType: ParamObj.OrderType,
        //�ѱ�
        OrderBillType: ParamObj.OrderBillType,
        OrderBillTypeRowid: ParamObj.OrderBillTypeRowid,
        OrderStartDate: ParamObj.OrderStartDate,
		OrderEndDate: ParamObj.OrderEndDate,
		OrderDate: ParamObj.OrderDate,
        OrderBaseQty: ParamObj.OrderBaseQty,
        OrderARCOSRowid: ParamObj.OrderARCOSRowid,
        OrderMaxDurFactor: ParamObj.OrderMaxDurFactor,
        OrderMaxQty: ParamObj.OrderMaxQty,
        
        OrderFile1: ParamObj.OrderFile1,
        OrderFile2: ParamObj.OrderFile2,
        OrderFile3: ParamObj.OrderFile3,
        OrderLabExCode: ParamObj.OrderLabExCode,
        OrderAlertStockQty: ParamObj.OrderAlertStockQty,
        OrderPoisonCode: ParamObj.OrderPoisonCode,
        OrderPoisonRowid: ParamObj.OrderPoisonRowid,
		OrderMaterialBarcode: ParamObj.OrderMaterialBarcode,
        OrderMaterialBarcodeHiden: ParamObj.OrderMaterialBarcodeHiden,
        // Ƥ�Ա�־ 
        OrderSkinTest: ParamObj.OrderSkinTest,
        //Ƥ��ԭҺ
        skintestyy: ParamObj.skintestyy,
        // Ƥ�Ա�ע
        OrderActionRowid: ParamObj.OrderActionRowid,
        OrderAction: ParamObj.OrderAction,
        //�Ӽ�
        Urgent: ParamObj.Urgent,
        //ҽ��
        OrderCoverMainIns: ParamObj.OrderCoverMainIns,
        OrderHiddenPara: ParamObj.OrderHiddenPara,
        OrderGenericName: ParamObj.OrderGenericName,
        LinkedMasterOrderRowid: ParamObj.LinkedMasterOrderRowid,
        LinkedMasterOrderSeqNo: ParamObj.LinkedMasterOrderSeqNo,
		OrderNurseLinkOrderRowid: ParamObj.OrderNurseLinkOrderRowid,
        OrderNeedPIVAFlag: ParamObj.OrderNeedPIVAFlag,
        OrderStage: ParamObj.OrderStage,
        OrderStageCode: ParamObj.OrderStageCode,
		//-
		OrderBodyPartID: ParamObj.OrderBodyPartID,
		OrderBodyPart: ParamObj.OrderBodyPart,
		ExceedReasonID: ParamObj.ExceedReasonID,
		ExceedReason: ParamObj.ExceedReason,
        //****************������9********��һ�����һ��,************************/
        OrderAntibApplyRowid: ParamObj.OrderAntibApplyRowid,
        UserReasonId: ParamObj.UserReasonId,
        SpecialAction: ParamObj.SpecialAction, //update by shp 20150714
        OrderDepProcNote: ParamObj.OrderDepProcNote,
        OrderSpeedFlowRate: ParamObj.OrderSpeedFlowRate,
        OrderFlowRateUnit: ParamObj.OrderFlowRateUnit,
        OrderFlowRateUnitRowId: ParamObj.OrderFlowRateUnitRowId,
        DIDExceedReasonDR:ParamObj.DIDExceedReasonDR,
        OrderPilotPro: PageLogicObj.DefaultPilotProDesc,
        OrderPilotProRowid:PageLogicObj.DefaultPilotProRowid,
        OrderPackUOMStr: ParamObj.OrderPackUOMStr,
		OrderBaseQtySum: ParamObj.Qty,
		BaseDoseQty:ParamObj.BaseDoseQty,
		Qty:ParamObj.Qty,
		OrderBodyPartLabel:ParamObj.OrderBodyPartLabel,
		OrderUsableDays:ParamObj.OrderUsableDays,
		//�ٴ�·��ʵʩ��¼
		OrderCPWStepItemRowId:ParamObj.OrderCPWStepItemRowId,
		OrderFirstDayTimes:ParamObj.OrderFirstDayTimes,
		///�����Ű༰̨��
		AnaesthesiaID:ParamObj.AnaesthesiaID,
		OrderOperationStr:ParamObj.OrderOperationStr,
		OrderOperation:ParamObj.OrderOperation,
		OrderOperationCode:ParamObj.OrderOperationCode,
		OrderLocalInfusionQty:ParamObj.OrderLocalInfusionQty,
		ARCIMDefSensitive:ParamObj.ARCIMDefSensitive,
		OrderFreqTimeDoseStr:ParamObj.OrderFreqTimeDoseStr,
		OrderPkgOrderNo:ParamObj.OrderPkgOrderNo,
		OrderDoc:ParamObj.OrderDoc,
		OrderDocRowid:ParamObj.OrderDocRowid,
		OrderDocStr:ParamObj.OrderDocStr,
        OrderVirtualtLong:ParamObj.OrderVirtualtLong,
        OrderChronicDiagStr: ParamObj.OrderChronicDiagStr,
        OrderChronicDiagCode: ParamObj.OrderChronicDiagCode,
        OrderLabSpecCollectionSiteStr: ParamObj.OrderLabSpecCollectionSiteStr
    });
    return dataObj;
}
function SetColumnList(rowid, ColumnName, str) {
    //ppppppp
    var Id = "";
    if ($.isNumeric(rowid) == true) {
        var Id = rowid + "_" + ColumnName;
    } else {
        var Id = ColumnName;
    }
    if (typeof str == "undefined") { return }
    var obj = document.getElementById(Id);
    if ((obj) && (obj.type == "select-one")) {
        ClearAllList(obj);
        if (ColumnName == "OrderRecDep") {
            var DefaultRecLocRowid = "";
            var DefaultRecLocDesc = "";
            var ArrData = str.split(String.fromCharCode(2));
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                if (((ArrData1[2] == "Y") && (DefaultRecLocRowid == "")) || (ArrData.length == 1)) {
                    var DefaultRecLocRowid = ArrData1[0];
                    var DefaultRecLocDesc = ArrData1[1];
                }
                obj.options[obj.length] = new Option(ArrData1[1], ArrData1[0]);
            }
            if (DefaultRecLocRowid=="") {
	            var ArrData1=ArrData[0].split(String.fromCharCode(1));
	            DefaultRecLocRowid=ArrData1[0];
	            DefaultRecLocDesc=ArrData1[1];
	        }
            SetCellData(rowid, "OrderRecDep", DefaultRecLocRowid);
            SetCellData(rowid, "OrderRecDepRowid", DefaultRecLocRowid);
            SetCellData(rowid, "CurrentRecLocStr", str);
        }
        if (ColumnName == "OrderDoseUOM") {

            var DefaultDoseQty = "";
            var DefaultDoseQtyUOM = ""
            var DefaultDoseUOMRowid = "";
            if (str != "") {

                var ArrData = str.split(String.fromCharCode(2));
                for (var i = 0; i < ArrData.length; i++) {
                    var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                    obj.options[obj.length] = new Option(ArrData1[1], ArrData1[2]);
                    if (i == 0) {
                        var DefaultDoseQty = ArrData1[0];
                        var DefaultDoseQtyUOM = RowidData = ArrData1[1];
                        var DefaultDoseUOMRowid = RowidData = ArrData1[2];
                    }
                }
            }
            SetCellData(rowid, "OrderDoseQty", DefaultDoseQty);
            SetCellData(rowid, "OrderDoseUOM", DefaultDoseUOMRowid);
            SetCellData(rowid, "OrderDoseUOMRowid", DefaultDoseUOMRowid);
            SetCellData(rowid, "idoseqtystr", str);
        }
        if (ColumnName == "OrderLabSpec") {
            var DefaultSpecRowid = "";
            var DefaultSpecDesc = "";
            var ArrData = str.split(String.fromCharCode(2));
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(String.fromCharCode(3));
                if ((ArrData1[4] == "Y") || (ArrData.length == 1)) {
                    var DefaultSpecRowid = ArrData1[0];
                    var DefaultSpecDesc = ArrData1[1];
                }
                obj.options[obj.length] = new Option(ArrData1[1], ArrData1[0]);
            }
            SetCellData(rowid, "OrderLabSpec", DefaultSpecRowid);
            SetCellData(rowid, "OrderLabSpecRowid", DefaultSpecRowid);
            SetCellData(rowid, "OrderLabSpecStr", str);
        }
        if ((ColumnName == "OrderDIACat")&&(str !="")) {
            var DefaultDIACatRowId = "";
            var DefaultDIACatDesc = "";
            var ArrData = str.split(String.fromCharCode(2));
            obj.options[obj.length] = new Option("", "");
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                obj.options[obj.length] = new Option(ArrData1[1], ArrData1[0]);
            }
            SetCellData(rowid, "OrderDIACat", DefaultDIACatRowId);
            SetCellData(rowid, "OrderDIACatRowId", DefaultDIACatRowId);
            SetCellData(rowid, "idiagnoscatstr", str)
        }
        //���岿λ
        if (ColumnName == "OrderBodyPart") {
            var ArrData = str.split(String.fromCharCode(2));
            obj.options[obj.length] = new Option("", "");
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                obj.options[obj.length] = new Option(ArrData1[2], ArrData1[2]);
            }
        }
        //ҽ������
        if (ColumnName == "OrderPrior") {
            var ArrData = str.split(";");
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(":");
                obj.options[obj.length] = new Option(ArrData1[1], ArrData1[0]);
            }
        }
        //�ٴ�ҩ��
        if (ColumnName == "OrderPilotPro") {
            var DefaultPilotProRowid = "";
            var DefaultPilotProDesc = "";

            var ArrData = str.split(String.fromCharCode(2));
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                if (ArrData1[2] == "Y") {
                    var DefaultPilotProRowid = ArrData1[0];
                    var DefaultPilotProDesc = ArrData1[1];
                }
                obj.options[obj.length] = new Option(ArrData1[1], ArrData1[0]);
            }
            if (DefaultPilotProRowid != "") {
                SetCellData(rowid, "OrderPilotProRowid", DefaultPilotProRowid);
                SetCellData(rowid, "OrderPilotPro", DefaultPilotProRowid);
            }
        }
        //�����б� 
         if (ColumnName=="OrderOperation"){
		   if ((str==false)||(str=="")) return;
           var ArrData=str.split("^");
           for (var i=0;i<ArrData.length;i++) {
                var ArrData1=ArrData[i].split(String.fromCharCode(1));
                obj.options[obj.length] = new Option(ArrData1[0],ArrData1[1]);
           }
         }
        //Э�鵥λ
        if (ColumnName == "OrderPackUOM") {
            var DefaultOrderPackUOM = "";
            var DefaultOrderPackUOMDesc = "";
            var ArrData = str.split(String.fromCharCode(2));
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                if (ArrData1[2] == "Y") {
                    var DefaultOrderPackUOM = ArrData1[0];
                    var DefaultOrderPackUOMDesc = ArrData1[1];
                }
                obj.options[obj.length] = new Option(ArrData1[1], ArrData1[0]);
            }
            if (DefaultOrderPackUOM != "") {

                SetCellData(rowid, "OrderPackUOMRowid", DefaultOrderPackUOM);
                SetCellData(rowid, "OrderPackUOM", DefaultOrderPackUOM);
            }
        }
        //ҽ������
        if (ColumnName == "OrderInsurCat") {
            var ArrData = str.split(String.fromCharCode(2));
            //obj.options[obj.length] = new Option("", "");
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                obj.options[obj.length] = new Option(ArrData1[1], ArrData1[0]);
            }
        }
        //��ҽ��ҽ��
        if (ColumnName == "OrderDoc") {
	        var DefaultDocRowId = "";
            var DefaultDoc = "";
            var ArrData = str.split("^");
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                if (ArrData1[2] == "Y") {
                    var DefaultDoc = ArrData1[0];
                    var DefaultDocRowId = ArrData1[1];
                }
                obj.options[obj.length] = new Option(ArrData1[0], ArrData1[1]);
            }
            if (DefaultDocRowId != "") {
                SetCellData(rowid, "OrderDocRowid", DefaultDocRowId);
                SetCellData(rowid, "OrderDoc", DefaultDocRowId);
            }
	    }
	    //ҽ������
        if (ColumnName == "OrderChronicDiag") {
            var ArrData = str.split(String.fromCharCode(2));
            //obj.options[obj.length] = new Option("", "");
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                obj.options[obj.length] = new Option(ArrData1[1], ArrData1[0]);
            }
        }
        //�걾�ɼ���λ
        if (ColumnName == "OrderLabSpecCollectionSite") {
            var DefaultSpecCSiteRowid = "";
            var DefaultSpecCSiteDesc = "";
            var ArrData = str.split(String.fromCharCode(3));
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(String.fromCharCode(2));
                if ((ArrData.length == 1)||(i == 0)){
                    var DefaultSpecCSiteRowid = ArrData1[0];
                    var DefaultSpecCSiteDesc = ArrData1[1];
                }
                obj.options[obj.length] = new Option(ArrData1[1], ArrData1[0]);
            }
            SetCellData(rowid, "OrderLabSpecCollectionSite", DefaultSpecCSiteRowid);
            SetCellData(rowid, "OrderLabSpecCollectionSiteRowid", DefaultSpecCSiteRowid);
            SetCellData(rowid, "OrderLabSpecCollectionSiteStr", str);
        }
    }
}

function GetRecLocStrByPrior(str, PriorRowId) {
    //ֻ���������ҽ�����͵Ľ��ܿ���?A������ȫ��
    var Find = 0;
    var arr = new Array();
    var ArrData = str.split(String.fromCharCode(2));
    for (var i = 0; i < ArrData.length; i++) {
        var ArrData1 = ArrData[i].split(String.fromCharCode(1));
        if (ArrData1[3] == PriorRowId) {
            Find = 1
        }
    }
    //$.messager.alert("����","Find:"+Find+" str:"+str+" PriorRowId:"+PriorRowId);
    for (var i = 0; i < ArrData.length; i++) {
        var ArrData1 = ArrData[i].split(String.fromCharCode(1));
		//���Ƴ���ҽ�����߽ڼ��ս��տ�������
        var IsHolidayLocFlag=ArrData1[4];
        if ((PriorRowId!="")&&(IsLongPrior(PriorRowId))&&(IsHolidayLocFlag==1)) continue
        if (ArrData1[3] == "") {
            if ((Find == 0)||(IsHolidayLocFlag==1)) {
	            if (IsHolidayLocFlag==1) ArrData1[2]="Y";ArrData[i]=ArrData1.join(String.fromCharCode(1));
	            arr[arr.length] = ArrData[i];
	        }
        } else {
            if (ArrData1[3] == PriorRowId) {
                arr[arr.length] = ArrData[i];
            }
        }
    }
    return arr.join(String.fromCharCode(2));
}
function GetPrescBillTypeID() {
    //���Ӱ�� input ���� PrescBillTypeID
    var obj_PrescBillTypeID = document.getElementById('PrescBillTypeID');
    if (obj_PrescBillTypeID) { return obj_PrescBillTypeID.value; } else { return ""; }
}
function SetOrderFirstDayTimes(rowid) {
	var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
    var OrderPriorRowid = GetCellData(rowid, "OrderPriorRowid");
    var OrderFreqRowid = GetCellData(rowid, "OrderFreqRowid");
	var OrderStartDate = GetCellData(rowid, "OrderStartDate");
	var OrderFreqDispTimeStr = GetCellData(rowid, "OrderFreqDispTimeStr");
	var LinkedMasterOrderPriorRowid="";
	if ((VerifiedOrderObj) && (VerifiedOrderObj.LinkedMasterOrderPriorRowid != "undefined") && (VerifiedOrderObj.LinkedMasterOrderPriorRowid != "")){
		LinkedMasterOrderPriorRowid=VerifiedOrderObj.LinkedMasterOrderPriorRowid;
	}
	var OrderFirstDayTimes=cspRunServerMethod(GlobalObj.GetOrderFirstDayTimesMethod,GlobalObj.EpisodeID, OrderARCIMRowid, OrderFreqRowid, OrderPriorRowid, OrderStartDate, LinkedMasterOrderPriorRowid,OrderFreqDispTimeStr);
	SetCellData(rowid, "OrderFirstDayTimes", OrderFirstDayTimes);
}
//ҽ������
function FindClickHandler(e) {
    if (GlobalObj.EpisodeID) {
        var sttdate = "";
        var enddate = "";
        var prior = "";
        if (GlobalObj.PAAdmType == "I") {
            var CurrDateTime = cspRunServerMethod(GlobalObj.GetCurrentDateTimeMethod, PageLogicObj.defaultDataCache, "1");
            var CurrDateTimeArr = CurrDateTime.split("^");
            sttdate = CurrDateTimeArr[0];
            enddate = CurrDateTimeArr[0];
            var retprior = tkMakeServerCall("web.DHCDocOrderItemList", "GetOrderPrior", "S");
            prior = retprior.split("^")[0];
        } else {
            var retprior = tkMakeServerCall("web.DHCDocOrderItemList", "GetOrderPrior", "NORM");
            prior = retprior.split("^")[0];
        }
        if (GlobalObj.HospitalCode != 'ZJQZRMYY') {
            var posn = "height=" + (screen.availHeight - 40) + ",width=" + (screen.availWidth - 10) + ",top=0,left=0,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes";
        } else {
            var posn = "height=" + (screen.availHeight - 340) + ",width=" + (screen.availWidth - 180) + ",top=0,left=0,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes";
        }
        websys_showModal({
			url:"doc.ordcopy.hui.csp?EpisodeID=" + GlobalObj.EpisodeID + "&SttDate=" + sttdate + "&EndDate=" + enddate + "&PriorID=" + prior,
			title:'ҽ������',
			width:screen.availWidth-100,height:screen.availHeight-200,
			AddCopyItemToList:AddCopyItemToList
		});
    }

}
//����������ҳ
function LnkLabPage_Click() {
    //�����²�Ʒ�з���ļ���������
    //CloseFlag=1 �ر�ʱ����ˢ�½��淽��
    var SendFlag="";
    var lnk = "dhcapp.mainframe.csp?PatientID=" + GlobalObj.PatientID + "&EpisodeID=" + GlobalObj.EpisodeID + "&mradm=" + GlobalObj.mradm+"&CloseFlag=1&PPRowId="+GlobalObj.PPRowId+"&EmConsultItm="+GlobalObj.EmConsultItm;
    websys_showModal({
		url:lnk,
		title:'����������',
		width:'95%',height:'95%',
		CallBackFunc:function(rtn){
			SendFlag=rtn;
		},
		onClose:function(){
			if (SendFlag=="1"){
				ReloadGrid("Ord");
				SaveOrderToEMR();
			}
		}
	})   
}
//�ṩ�����ѡ�񴰿ڻص�����
function PACSArcimFun(itemArr,OrdParamsArr) {
	websys_showModal("close");
	if (GlobalObj.warning != "") {
        $.messager.alert("����",GlobalObj.warning);
        return false;
    }
    var str=itemArr;
    if (str == '') return;
    if (typeof str == 'undefined') return;
    if (typeof str != 'string') return;
    if (str.indexOf("||")<0) {
	    var Arr = str.split('^')[0].split(String.fromCharCode(1))
		var icode = Arr[0];
		var itext = Arr[1];
	    OSItemListOpen(icode, itext, "YES", "", "");
	    return;
	}
	var OrdParamsArr=new Array();
    var strArray = str.split('^');
    var AddSuss = "N"
	new Promise(function(resolve,rejected){
		(function(callBackFun){
			function loop(i){
				new Promise(function(resolve,rejected){
					var Arr = strArray[i].split(String.fromCharCode(1))
					var icode = Arr[0];
					GetItemDefaultRowId(icode,resolve);
				}).then(function(ItemDefaultRowId){
					var OrderLabSpecRowid = "";
					var Arr = strArray[i].split(String.fromCharCode(1))
					var icode = Arr[0];
					if (Arr.length == 2) OrderLabSpecRowid = Arr[1];
					OrdParamsArr[OrdParamsArr.length]={
						OrderARCIMRowid:icode,
						ItemDefaultRowId:ItemDefaultRowId
					};
					i++;
					if ( i < strArray.length ) {
						 loop(i);
					}else{
						callBackFun();
					}
				})
				
			}
			loop(0);
		})(resolve);
	}).then(function(){
		return new Promise(function(resolve,rejected){
			AddItemToList("",OrdParamsArr,"obj","",resolve);
		})
	}).then(function(RtnObj){
		if (RtnObj.returnValue==false){
			var rowids = $('#Order_DataGrid').getDataIDs();
	        if (rowids.length == 0) Add_Order_row();
		}else{
			XHZY_Click();
			SetScreenSum();
		}
	})
}
//�鿴��ģ����ѯҽ����Ŀ
function BtnViewArcItemInfoHandler() {
    var iWidth=1200;                          //�������ڵĿ��; 
    var iHeight=680;                         //�������ڵĸ߶�; 
    //��ô��ڵĴ�ֱλ�� 
    var iTop = (window.screen.availHeight - 30 - iHeight) / 2; 
    //��ô��ڵ�ˮƽλ�� 
    var iLeft = (window.screen.availWidth - 10 - iWidth) / 2; 
    var lnk = "doc.arcimquery.hui.csp";
	websys_showModal({
		url:lnk,
		title:'ҽ���ֵ�¼��',
		width:screen.availWidth-200,height:screen.availHeight-200,
		PACSArcimFun:PACSArcimFun,
		OSItemListOpen:OSItemListOpen
	});
}
//���ԤԼ
function DoctorAppoint_Click() {
	websys_showModal({
		url:"dhcdoc.appointment.hui.csp?PatientID="+GlobalObj.PatientID+"&EpisodeID="+GlobalObj.EpisodeID, //"dhcdoc.appointment.app.hui.csp?AppMethCodeStr=DOC&PatientID="+GlobalObj.PatientID,
		title:'���ԤԼ',
		iconCls:'icon-w-edit',
		width:screen.availWidth-50,height:screen.availHeight-100
	});
}
//������
function CardBillClick() {
    var EpisodeID = GlobalObj.EpisodeID;
    var PatientID = GlobalObj.PatientID;
    if (EpisodeID == "") { $.messager.alert("��ʾ", "ȱ�ٻ�����Ϣ!"); return; }
    DHCACC_GetCardBillInfo(PatientID,function(CardInfo){
		var CardNo=CardInfo.split("^")[0];
		var CardTypeRowId=CardInfo.split("^")[1];
		if (CardNo==""){
			$.messager.alert("��ʾ", "��Ч�Ŀ���Ϣ!"); return; 
		}
		if (GlobalObj.CheckOutMode == 1) {
		    $.messager.confirm('��ʾ', '�Ƿ�ȷ�Ͽ۷�?', function(r){
				if (r){
					var CardTypeDefine = tkMakeServerCall("web.UDHCOPOtherLB","ReadCardTypeDefineListBroker1",CardTypeRowId);
					$("#CardBillCardTypeValue").val(CardTypeDefine);
				    var insType = GetPrescBillTypeID();
			        var oeoriIDStr = "";
			        var guser = session['LOGON.USERID'];
			        var groupDR = session['LOGON.GROUPID'];
			        var locDR = session['LOGON.CTLOCID'];
			        var hospDR = session['LOGON.HOSPID'];
			        var rtn = checkOut(CardNo, PatientID, EpisodeID, insType, oeoriIDStr, guser, groupDR, locDR, hospDR,CardBillAfterReload);
			        //CardBillAfterReload();
				}
			});
	    }else{
		 	var url = "dhcbill.opbill.charge.main.csp?ReloadFlag=3&CardNo=" + CardNo + "&SelectAdmRowId=" +  GlobalObj.EpisodeID + "&SelectPatRowId=" + GlobalObj.PatientID + "&CardTypeRowId=" + CardTypeRowId;
			websys_showModal({
				url: url,
				title: 'Ԥ�۷�',
				iconCls: 'icon-w-inv',
				width: '97%',
				height: '85%',
				onClose: function() {
					CardBillAfterReload();
				}
			});
		}
	});
    return;
}
function CardBillAfterReload(){
    ReloadGrid("Bill");
    if (GlobalObj.PAAdmType!="I"){
	    if (parent.refreshBar){
        	parent.refreshBar();
        }else if(parent.parent.refreshBar){
	        parent.parent.refreshBar();
	    }else{
        	parent.parent.opdoc.patinfobar.view.InitPatInfo(GlobalObj.EpisodeID);
        }
    }
}
function OrgFav_Click() {
    var lnk = "oeorder.template.maintenancev8.csp?CTLOC=" + GlobalObj.CTLOC + "&XCONTEXT=" + GlobalObj.XCONTEXT + "&EpisodeID=" + GlobalObj.EpisodeID + "&PreftabType=User.SSUser";
	websys_showModal({
		url:lnk,
		title:'ҽ��ģ��ά��',
		width:window.screen.width-100,height:window.screen.height-220,
		onClose: function() {
			if (UIConfigObj.DefaultPopTemplate) {
				if ($("#TemplateDetail").length==1){
					LoadOrdTemplTree();
				}
			}else{
				InitOrderTemp();
			}
		}
	});
}
function CASignUpdate(BtnId) {
    var caIsPass = 0;
    var ContainerName = "";
    if (GlobalObj.CAInit == 1) {
        if (GlobalObj.IsCAWin == "") {
            $.messager.alert("����", "���Ȳ���KEY!","info",function(){
	            DisableBtn(BtnId,false);
	        });
            return false;
        }
        //�жϵ�ǰkey�Ƿ��ǵ�½ʱ���key
        var resultObj = dhcsys_getcacert();
        result = resultObj.ContainerName;
        if ((result == "") || (result == "undefined") || (result == null)) {
           DisableBtn(BtnId,false);
            return false;
        }
        ContainerName = result;
        caIsPass = 1;
    }
    return { caIsPass: caIsPass, ContainerName: ContainerName }
}
function CheckBeforeSaveToServer(OrderItemStr,callBackFun) {
    var UserAddRowid = session['LOGON.USERID'];
    var UserAddDepRowid = session['LOGON.CTLOCID'];
    var DoctorRowid = GetEntryDoctorId();
    var LogonDep = ""
    var obj = document.getElementById("FindByLogDep");
    if (obj) {
        if (obj.checked) { FindRecLocByLogonLoc = 1 } else { FindRecLocByLogonLoc = 0 }
    }
    if (FindRecLocByLogonLoc == "1") { LogonDep = session['LOGON.CTLOCID'] }
    var OrderOpenForAllHosp = $("#OrderOpenForAllHosp").val();
    var ExpStr = GlobalObj.PPRowId +"^"+LogonDep+"^"+OrderOpenForAllHosp;
    
    var ret = cspRunServerMethod(GlobalObj.CheckBeforeSaveMethod, GlobalObj.EpisodeID, OrderItemStr, UserAddRowid, UserAddDepRowid, DoctorRowid, ExpStr,1)
    var CheckResultObj=jQuery.parseJSON(ret);
    
	/*var ErrCode=CheckResultObj.ErrCode; //1
	var ErrMsg=CheckResultObj.ErrMsg;	//2
    var ErrRowID=CheckResultObj.OrdRowIndex;	//3
    var FocusCol=CheckResultObj.FocusCol;//4
    var NeedCheckDeposit=CheckResultObj.NeedCheckDeposit;//4*/
	var CheckBeforeSaveObj={
		StopConflictFlag:"0",			//�Ƿ���Ҫ�Զ�ֹͣ����ҽ��
		isAfterCheckLoadDataFlag:false,	//ǰ̨�Ƿ���Ҫ��������
		SuccessFlag:true,				//�Ƿ���Ҫ�������ҽ��
		UpdateOrderItemStr:OrderItemStr
	}
	new Promise(function(resolve,rejected){
		//ִ�лص�����
		var CallBakFunS=CheckResultObj.CallBakFunS;
		if (typeof CallBakFunS=="object"){
			(function(callBackExecFun){
				function loop(i){
					new Promise(function(resolve,rejected){
						var FunCode=CallBakFunS[i].CallBakFunCode;
						var FunCodeParams=CallBakFunS[i].CallBakFunParams;
						var Row=CheckResultObj.ErrCode;
						CheckAfterCheckMethod(FunCode,FunCodeParams,Row,resolve);
					}).then(function(ReturnObj){
						if (ReturnObj.isAfterCheckLoadDataFlag){
							CheckBeforeSaveObj.isAfterCheckLoadDataFlag=true;
						}
						if (ReturnObj.SuccessFlag==false){
							CheckBeforeSaveObj.SuccessFlag=false;
							callBackExecFun();
							return;
						}
						if (ReturnObj.StopConflictFlag=="1"){
							CheckBeforeSaveObj.StopConflictFlag="1";
							callBackExecFun();
							return;
						}
						if (ReturnObj.LongOrdStopDateTimeStr!="") {
							var UpdateOrderItemStr="";
							var LongOrdStopDateTimeArr=ReturnObj.LongOrdStopDateTimeStr.split(" ");
							var updateIndex=CallBakFunS[i].CallBakFunParams.split(",")[0];
							var OrderItemAry=OrderItemStr.split(String.fromCharCode(1));
				            for (var itemIndex=0;itemIndex<OrderItemAry.length;itemIndex++) {
				                var oneOrderItemAry=OrderItemAry[itemIndex].split('^');
				                if (oneOrderItemAry[65]==updateIndex) {
					                oneOrderItemAry[3]=LongOrdStopDateTimeArr[0];
					                oneOrderItemAry[4]=LongOrdStopDateTimeArr[1];
					            }
				                var oneOrderItemStr=oneOrderItemAry.join('^');
				                if (UpdateOrderItemStr=="") {UpdateOrderItemStr=oneOrderItemStr;}else{UpdateOrderItemStr=UpdateOrderItemStr+String.fromCharCode(1)+oneOrderItemStr}
				            }
				            $.extend(CheckBeforeSaveObj, { UpdateOrderItemStr: UpdateOrderItemStr});
						}
						i++;
						if ( i < CheckResultObj.CallBakFunS.length ) {
							 loop(i);
						}else{
							callBackExecFun();
						}
					})
				}
				loop(0);
			})(resolve);
		}else{
			resolve();
		}
	}).then(function(){
		return new Promise(function(resolve,rejected){
			var ErrMsg=CheckResultObj.ErrMsg;
			var ErrRowID=CheckResultObj.OrdRowIndex;
			var FocusCol=CheckResultObj.FocusCol;
			if (ErrMsg!=""){
				$.messager.alert("��ʾ", ErrMsg, "info", function() {
					if ((ErrRowID!="")&&(FocusCol!="")){
						//EditRow ���е��ú�����ҩ����,�����ݴ���
						try{
							EditRow(ErrRowID);
							SetFocusCell(ErrRowID, FocusCol);
							if (FocusCol == "OrderDoseQty") {
								$("#"+ErrRowID+"_OrderDoseQty").click();
							}
						}catch(e){
							SetFocusCell(ErrRowID, FocusCol);
						}
					}
					resolve();
				})
		    }else{
			    resolve();
			}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			var ErrCode=CheckResultObj.ErrCode;
			if ((parseInt(ErrCode)<0)){
				CheckBeforeSaveObj.SuccessFlag=false;
			}
			if (CheckResultObj.NeedCheckDeposit) {
		        var amount = $("#ScreenBillSum").val();
		        if (!CheckDeposit(amount, "")) {
		            CheckBeforeSaveObj.SuccessFlag=false;
		        }
		    }
		    resolve();
	    })
	}).then(function(){
		callBackFun(CheckBeforeSaveObj);
	})
}
function CheckAfterCheckMethod(FunCode,FunCodeParams,Row,CallBackFun){
	var ReturnObj={
		StopConflictFlag:"0",
		isAfterCheckLoadDataFlag:false,
		LongOrdStopDateTimeStr:"",
		SuccessFlag:true,
	}
	var ParamsArr=FunCodeParams.split(",");
	new Promise(function(resolve,rejected){
		switch(FunCode)
		{
			case "NeedDischgCond":
				(function(callBackFunExec){
					new Promise(function(resolve,rejected){
						OpenDischgCond(FunCodeParams,resolve);
					}).then(function(returnObj){
						//ReturnObj.SuccessFlag=SuccessFlag;
						$.extend(ReturnObj, returnObj);
						callBackFunExec();
					})
				})(resolve);
				break;
			case "NeedDeathDate":
				(function(callBackFunExec){
					new Promise(function(resolve,rejected){
						OpenDeathDate(FunCodeParams,resolve);
					}).then(function(returnObj){
						//ReturnObj.SuccessFlag=SuccessFlag;
						$.extend(ReturnObj, returnObj);
						callBackFunExec();
					})
				})(resolve);
				break;
			case "NeedTransDate":
				(function(callBackFunExec){
					new Promise(function(resolve,rejected){
						OpenStopAfterLongOrder("ת��ҽ����ʼ����","NeedTransDate",FunCodeParams,resolve);
					}).then(function(returnObj){
						//ReturnObj.SuccessFlag=SuccessFlag;
						$.extend(ReturnObj, returnObj);
						callBackFunExec();
					})
				})(resolve);
				break;
			case "NeedDischgDiagnos":
				(function(callBackFunExec){
					new Promise(function(resolve,rejected){
						OpenDischgDiagnos(ParamsArr,resolve);
					}).then(function(SuccessFlag){
						ReturnObj.SuccessFlag=SuccessFlag;
						callBackFunExec();
					})
				})(resolve);
				break;
			case "NeedDiagnose":
				(function(callBackFunExec){
					new Promise(function(resolve,rejected){
						OpenDiagnose(ParamsArr,resolve);
					}).then(function(SuccessFlag){
						ReturnObj.SuccessFlag=SuccessFlag;
						callBackFunExec();
					})
				})(resolve);
				break;
			case"SetPageLogicFocusRow": 
				PageLogicObj.FocusRowIndex = Row;
				resolve();
				break;
			case "Confirm" :
				(function(callBackFunExec){
					new Promise(function(resolve,rejected){
						$.messager.confirm('ȷ�϶Ի���', FunCodeParams, function(r){
							if (r) {
								ReturnObj.SuccessFlag=true;
							}else{
								ReturnObj.SuccessFlag=false;
							}
							callBackFunExec();
						});
					})
				})(resolve); //�˴���resolveָ����CheckAfterCheckObj.CallBackFun(FunObj.ReturnObj);
				break;
			case "ReSetMasterSeqNo" :
				SetCellData(Row, "OrderMasterSeqNo", "");
				ReturnObj.isAfterCheckLoadDataFlag=true;
				resolve();
				break;
			case "AddRemarkClickhandler" :
				(function(callBackFunExec){
					new Promise(function(resolve,rejected){
						AddRemarkClickhandler(ParamsArr[0],resolve);
					}).then(function(SuccessFlag){
						ReturnObj.SuccessFlag=SuccessFlag;
						ReturnObj.isAfterCheckLoadDataFlag=true;
						callBackFunExec();
					})
				})(resolve);
				break;
			case "NeedInputOrderPrice" :
				EditRow(Row);
				(function(callBackFunExec){
					new Promise(function(resolve,rejected){
						$.messager.alert('��ʾ��Ϣ', OrderName + t['NO_OrderPrice'], "info",function(){
							SetFocusCell(Row, "OrderPrice");
							var StyleConfigObj = { OrderPrice: true };
				            ChangeRowStyle(Row, StyleConfigObj)
				            PageLogicObj.FocusRowIndex = Row;
				            ReturnObj.SuccessFlag=false;
							callBackFunExec();
						});
					})
				})(resolve); //�˴���resolveָ����CheckAfterCheckObj.CallBackFun(FunObj.ReturnObj);
				break;
			case "EmptyPackQty" :
				SetCellData(Row, "OrderPackQty", "");
	            ReturnObj.SuccessFlag=true;
	            resolve();
				break;
			case "StopConflict" :
				(function(callBackFunExec){
					new Promise(function(resolve,rejected){
						/*$.messager.confirm('ȷ�϶Ի���', "�������»���ҽ����" + ParamsArr + " ��ȷ���Ƿ��Զ�ֹͣ����ҽ��?", function(r){
							if (r) {
								ReturnObj.StopConflictFlag = "1";
							}
							callBackFunExec();
						});*/
						$.messager.alert('��ʾ��Ϣ', "�������»���ҽ����" + ParamsArr + " ��˺��Զ�ֹͣ����ҽ����", "info",function(){
							ReturnObj.StopConflictFlag = "1";
							callBackFunExec();
						});
					})
				})(resolve);
				break;
			case "ExceedReasonConfirm" :
				(function(callBackFunExec){
					new Promise(function(resolve,rejected){
						$.messager.confirm('ȷ�϶Ի���', ParamsArr.slice(0, ParamsArr.length-3), function(r){
							Row=ParamsArr[ParamsArr.length-3];
							if (r) {
								ReturnObj.SuccessFlag = true;
								var LastExceedReasonID=ParamsArr[ParamsArr.length-2];
								var LastExceedReason=ParamsArr[ParamsArr.length-1];
								SetCellData(Row, "ExceedReasonID", LastExceedReasonID);
								SetCellData(Row, "ExceedReason", LastExceedReason);
								ChangeLinkOrderExceedReason(Row);
								ReturnObj.isAfterCheckLoadDataFlag=true;	
							}else{
								ReturnObj.SuccessFlag = false;
								PageLogicObj.FocusRowIndex = Row;
								EditRow(Row);
								SetFocusCell(Row, "ExceedReason");
							}
							callBackFunExec();
						});
					})
				})(resolve);
				break;
			case "NeedCareOrd":
				(function(callBackFunExec){
					var TypeCode=ParamsArr[ParamsArr.length-1];
					new Promise(function(resolve,rejected){
						$.messager.confirm('ȷ�϶Ի���', ParamsArr.slice(0, ParamsArr.length-1), function(r){
							ReturnObj.SuccessFlag=true;
							if (r) {
								var url="../csp/nur.hisui.orderNeedCare.csp?EpisodeID="+GlobalObj.EpisodeID+"&defaultTypeCode="+TypeCode;
								websys_showModal({
									url:url,
									title:'���עҽ��',
									width:1360,height:650,
									onClose:function(retval){
										callBackFunExec();
									}
								})
							}else{
								callBackFunExec();
							}
						});
					})
				})(resolve);
				break;
			case "NeedFirstDelWithCareOrd":
				var TypeCode=ParamsArr[ParamsArr.length-1];
				(function(callBackFunExec){
					$.messager.alert("��ʾ",ParamsArr.slice(0, ParamsArr.length-1),"info",function(){
						var url="../csp/nur.hisui.orderNeedCare.csp?EpisodeID="+GlobalObj.EpisodeID+"&defaultTypeCode="+TypeCode;
						websys_showModal({
							url:url,
							title:'���עҽ��',
							width:1360,height:650,
							onClose:function(retval){
								//var Rtn=tkMakeServerCall("Nur.HISUI.NeedCareOrder", "getAbnormalOrder", GlobalObj.EpisodeID,GlobalObj.LogonDoctorType,TypeCode);
							    var Rtn=tkMakeServerCall("Nur.Interface.OutSide.Order", "GetAbnormalOrder", GlobalObj.EpisodeID,GlobalObj.LogonDoctorType,TypeCode);
							    if ((Rtn!="")&&((Rtn.split("^")[0])==1)) ReturnObj.SuccessFlag=false;
							    else ReturnObj.SuccessFlag=true;
							    callBackFunExec();
							}
						})
					})
				})(resolve);	
				break;
			case "NeedDeathTypeDiagnos":
				(function(callBackFunExec){
					new Promise(function(resolve,rejected){
						$.messager.alert("��ʾ",ParamsArr,"info",function(){
							new Promise(function(resolve,rejected){
								OpenDeathTypeDiagnos(resolve);
							}).then(function(SuccessFlag){
								ReturnObj.SuccessFlag=SuccessFlag;
								callBackFunExec();
							})
						});
					})
				})(resolve); //�˴���resolveָ����FunObj.CallBackFun(FunObj.ReturnObj);
				break;
			case "CheckPatCount":
				ReturnObj.SuccessFlag=true;
				resolve();
				break;
			default:
				resolve();
				break;
		}
	}).then(function(){
		CallBackFun(ReturnObj);
	})
}
function OpenDiagnose(ParamsArr,CallBackFun){
	$.messager.alert("��ʾ", ParamsArr[0],"info",function(){
	    var DiagnosURL = "diagnosentry.v8.csp?PatientID=" + GlobalObj.PatientID + "&EpisodeID=" + GlobalObj.EpisodeID + "&mradm=" + GlobalObj.mradm +"&OutDisFlag=1";
	    websys_showModal({
			url:DiagnosURL,
			title:'���¼��',
			width:top.screen.width - 100,height:top.screen.height - 130,
			onClose:function(){
				if (ParamsArr[ParamsArr.length-1] == 1){
				    var Ret = tkMakeServerCall("web.DHCDocOrderEntry", "GetMMDiagnoseCount", GlobalObj.mradm);
				}else{
			    	var Ret = tkMakeServerCall("web.DHCDocOrderEntry", "GetMRDiagnoseCount", GlobalObj.mradm);
				}
	            if (Ret == 0) { Ret = false; } else { Ret = true; }
				CallBackFun(Ret);
			}
		})
	});
}
function OpenDischgDiagnos(ParamsArr,CallBackFun){
    var iframeName = window.name
    if (iframeName == "") {
        iframeName = window.parent.frames("oeordFrame").name
    }
    if (iframeName == "oeordFrame") {
	    CallBackFun(false);
    } else {
        if (GlobalObj.CareProvType == "DOCTOR") {
	        $.messager.alert("��ʾ", ParamsArr[0],"info",function(){
			    var DiagnosURL = "diagnosentry.v8.csp?PatientID=" + GlobalObj.PatientID + "&EpisodeID=" + GlobalObj.EpisodeID + "&mradm=" + GlobalObj.mradm +"&OutDisFlag=1";
			    websys_showModal({
					url:DiagnosURL,
					title:'���¼��',
					width:top.screen.width - 100,height:top.screen.height - 130,
					onClose:function(){
						var checkNeedDiagTypeRtn=tkMakeServerCall("web.DHCOEOrdItem", "checkNeedDiagType", GlobalObj.EpisodeID);
			            if (+checkNeedDiagTypeRtn!=0){
			                CallBackFun(false);
			            }else{
			                CallBackFun(true);
			            }
					}
				})
			});
        }else{
	        CallBackFun(true);
	    }
    }
}
function OpenStopAfterLongOrder(title,type,rowIndex,CallBackFun){
	var rowid=(+rowIndex)-1;
	var oneOrdItemArr=[];
	var DataArry = GetGirdData();
	var OrderARCIMRowid = DataArry[rowid]["OrderARCIMRowid"];
	var OrderPriorRowid = DataArry[rowid]["OrderPriorRowid"];
	var OrderPriorRemarks = DataArry[rowid]["OrderPriorRemarksRowId"];
	OrderPriorRowid = ReSetOrderPriorRowid(OrderPriorRowid, OrderPriorRemarks);
	var OrderStartDateStr = DataArry[rowid]["OrderStartDate"];
	var OrderStartDate = "";
    var OrderStartTime = "";
    if (OrderStartDateStr != "") {
        OrderStartDate = OrderStartDateStr.split(" ")[0];
        OrderStartTime = OrderStartDateStr.split(" ")[1];
    }
	var OrderEndDateStr = DataArry[rowid]["OrderEndDate"];
	var OrderEndDate = "";
    var OrderEndTime = "";
    if (OrderEndDateStr != "") {
        OrderEndDate = OrderEndDateStr.split(" ")[0];
        OrderEndTime = OrderEndDateStr.split(" ")[1];
    }
    var VerifiedOrderMasterRowid="";
    var OrderDate ="",OrderTime = "";
    var OrderDateStr = DataArry[rowid]["OrderDate"];
    if (OrderDateStr != "") {
        OrderDate = OrderDateStr.split(" ")[0];
        OrderTime = OrderDateStr.split(" ")[1];
    }
    var VerifiedOrderMasterRowid="",OrderNurseLinkOrderRowid="",OrderNurseBatchAdd="";
    oneOrdItemArr[0]=OrderARCIMRowid;
    oneOrdItemArr[2]=OrderPriorRowid;
    oneOrdItemArr[3]=OrderStartDate;
    oneOrdItemArr[4]=OrderStartTime;
    oneOrdItemArr[25]=OrderEndDate;
    oneOrdItemArr[26]=OrderEndTime;
    oneOrdItemArr[38]=VerifiedOrderMasterRowid;
    oneOrdItemArr[45]=OrderDate;
    oneOrdItemArr[46]=OrderTime;
    oneOrdItemArr[62]=OrderNurseLinkOrderRowid;
    oneOrdItemArr[70]=OrderNurseBatchAdd;
    var StyleConfigStr = DataArry[rowid]["StyleConfigStr"];
	var StyleConfigObj = {};
	if (StyleConfigStr != "") {
		StyleConfigObj = eval("(" + StyleConfigStr + ")");
	}
	if ((type=="NeedTransDate")&&(!StyleConfigObj.OrderStartDate)) {
		var returnObj={
			SuccessFlag:true,
			LongOrdStopDateTimeStr:""
		}
		$.messager.confirm('ȷ�϶Ի���', DataArry[rowid]["OrderName"]+" �������г���ֹͣ��"+OrderStartDate+" "+OrderStartTime+",�Ƿ����?", function(r){
			if (!r){
				returnObj.SuccessFlag=false;
			}
			CallBackFun(returnObj);
		})
		return;
	}
    var paraObj={
	    OrdItemArr:oneOrdItemArr,
	    EpisodeID:GlobalObj.EpisodeID,
	    StartDateEnbale: StyleConfigObj.OrderStartDate
	}
	websys_showModal({
		url:"../csp/dhcdoc.stopafterlongordcondition.csp?type="+type,
		title:title,
		width:400,height:330,
		paraObj:paraObj,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			var returnObj={
				SuccessFlag:false,
				LongOrdStopDateTimeStr:""
			}
			if ((result == "") || (result == "undefined")||(result == null)) {
			    CallBackFun(returnObj);
		    } else {
			    var resultArr=result.split("^");
			    if (type == "NeedDischgCond") {
		        	GlobalObj.DischargeConditionRowId = resultArr[0];
		        }else if (type == "NeedDeathDate"){
			        GlobalObj.DeceasedDateTimeStr = resultArr[0];
					GlobalObj.DischargeConditionRowId="";
			    }
			    $.extend(returnObj, { SuccessFlag: true,LongOrdStopDateTimeStr:resultArr[1]});
		        CallBackFun(returnObj);
		    }
		}
	})
}
function OpenDischgCond(rowIndex,CallBackFun){
	OpenStopAfterLongOrder("��ѡ���Ժ����","NeedDischgCond",rowIndex,CallBackFun);
	/*websys_showModal({
		url:"../csp/dhcdoc.dischargecondition.csp",
		title:'��ѡ���Ժ����',
		width:400,height:330,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if ((result == "") || (result == "undefined")||(result == null)) {
		        $.messager.alert("��ʾ", "��ѡ���Ժ����!","info",function(){
			        CallBackFun(false);
			    });
		    } else {
		        GlobalObj.DischargeConditionRowId = result;
		        CallBackFun(true);
		    }
		}
	})*/
}
function OpenDeathDate(rowIndex,CallBackFun){
	OpenStopAfterLongOrder("����д��������","NeedDeathDate",rowIndex,CallBackFun);
	/*websys_showModal({
		url:"../csp/dhcdoc.deathdatetime.csp",
		title:'����д��������',
		width:400,height:300,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if ((result == "") || (result == "undefined")||(result == null)) {
		        $.messager.alert("��ʾ", "����д�������ں�ʱ��!","info",function(){
			        CallBackFun(false);
			    });
		    } else {
		        GlobalObj.DeceasedDateTimeStr = result;
				GlobalObj.DischargeConditionRowId="";
		        CallBackFun(true);
		    }
		}
	})*/
}
function UpdateClickHandler(UpdateObj){
	 SetTimeLog("UpdateClickHandler", "start");
	 if ($("#Insert_Order_btn").hasClass('l-btn-disabled')){
		return false;
	 }
	 $("#itro_win").hide().remove();
	 if (typeof UpdateObj=="undefined"){
		 UpdateObj={};
     }
	 $.extend(UpdateObj, { SUCCESS: false});
	 DisableBtn("Insert_Order_btn",true);
     //ҽ����ҩ����
     //if (!CheckInsuCostControl()){
        //return false
     //}
     //����ǩ��
    var caIsPass = 0;
    var ContainerName = "";
    var Ret = CASignUpdate("Insert_Order_btn");
    if (Ret == false) {
    	return websys_cancel();
    } else {
        var CASignObj = Ret;
        caIsPass = CASignObj.caIsPass;
        ContainerName = CASignObj.ContainerName;
    }
    $.extend(UpdateObj, { caIsPass: caIsPass,ContainerName:ContainerName});
	new Promise(function(resolve,rejected){
		var ret = CheckBeforeUpdate();
	     if (ret == false) {
		    DisableBtn("Insert_Order_btn",false);
	        return websys_cancel();
	     }
	     resolve();
	}).then(function(){
		return new Promise(function(resolve,rejected){
			GetOrderDataOnAdd(resolve);
		})
	}).then(function(OrderItemStr){
		return new Promise(function(resolve,rejected){
			if (OrderItemStr === "") {
			    $.messager.alert("��ʾ", t['NO_NewOrders'],"info",function(){
				    DisableBtn("Insert_Order_btn",false);
				});
			    return websys_cancel();
		    }
			if (OrderItemStr==false) {
				DisableBtn("Insert_Order_btn",false);
				return websys_cancel();
			}
		    $.extend(UpdateObj, { OrderItemStr: OrderItemStr});
			//����ǰ�ĺ�̨���,����ҽ��¼��Ǳ���ǰ�˴�����ж��߼������ڴ˴���
			CheckBeforeSaveToServer(UpdateObj.OrderItemStr,resolve);
		})
	}).then(function(ret){
		 return new Promise(function(resolve,rejected){
			 if (ret.SuccessFlag == false) {
		        DisableBtn("Insert_Order_btn",false);
		        return websys_cancel();
		     }
		     $.extend(UpdateObj, { StopConflictFlag: ret.StopConflictFlag,OrderItemStr:ret.UpdateOrderItemStr});
		     if (ret.isAfterCheckLoadDataFlag== true){
			     (function(callBackFunExec){
				     new Promise(function(resolve,rejected){
						GetOrderDataOnAdd(resolve);
					}).then(function(OrderItemStr){
						if (OrderItemStr==false) {
							DisableBtn("Insert_Order_btn",false);
							return websys_cancel();
						}
						if (OrderItemStr == "") {
						    $.messager.alert("��ʾ", t['NO_NewOrders'],"info",function(){
							    DisableBtn("Insert_Order_btn",false);
							});
						    return websys_cancel();
					    }
					    $.extend(UpdateObj, { OrderItemStr: OrderItemStr});
					    callBackFunExec();
					})
				 })(resolve)
			 }else{
			 	resolve();
			 }
		 })
	}).then(function(){
		return new Promise(function(resolve,rejected){
			if (GlobalObj.HLYYInterface==1){
				try{
					HYLLUpdateClick_HLYY(resolve,UpdateObj.OrderItemStr,"Check");
				}catch(e){
					$.messager.confirm('ȷ�϶Ի���', "������ҩϵͳ�쳣:"+e.message+"<br/>����ϵ��Ϣ��!��ȷ�����ҽ��������ȷ����", function(r){
						if (r) {
							resolve(true);
						}else{
							DisableBtn("Insert_Order_btn",false);
						}
					})
				}
			}else{
				resolve(true);
			}
		})
	}).then(function(ret){
		return new Promise(function(resolve,rejected){
			if (!ret) {
				DisableBtn("Insert_Order_btn",false);
		        return websys_cancel();
			}
			//�������÷��ں�����
			(function(callBackFunExec){
				new Promise(function(resolve,rejected){
					CheckBeforeSaveToAnti(resolve);
				}).then(function(mResult){
					if (mResult == false) {
					    DisableBtn("Insert_Order_btn",false);
				        return websys_cancel();
				    }
				    callBackFunExec();
				})
			})(resolve)
	    })
	}).then(function(){
		return new Promise(function(resolve,rejected){
			(function(callBackFunExec){
				new Promise(function(resolve,rejected){
					//�ٴ�·���������������֮��
					CPWCheck(resolve);
				}).then(function(CPWCheckRtn){
					if (CPWCheckRtn !== true) {
						DisableBtn("Insert_Order_btn",false);
					    return false;
					}
					callBackFunExec();
				});
			})(resolve)
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
	    	// ʵϰ�����ҽ��
		    if (GlobalObj.practiceFlag=="1"){
			    var UpdatePracticeRtn=InsertPriceAdd();
			    if (UpdatePracticeRtn){
				    AfterInsertOrd();
				    DisableBtn("Insert_Order_btn",false);
		    		ReloadGridData("Update");
		    		return SUCCESS;
				}else{
					DisableBtn("Insert_Order_btn",false);
				    return websys_cancel();
				}
			}
			resolve();
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			//���ü�����뵥����ҳ��
			$.extend(UpdateObj, { NeedMatchAry: new Array()});
		    ApplyReport(UpdateObj.OrderItemStr,UpdateObj.NeedMatchAry,resolve);
	    })
	}).then(function(UpdateOrderItemStr){
		return new Promise(function(resolve,rejected){
			if (UpdateOrderItemStr!="") {
		        $.extend(UpdateObj, { OrderItemStr: UpdateOrderItemStr});
		    }else{
			    DisableBtn("Insert_Order_btn",false);
		        return websys_cancel();
		    }
		    resolve();
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			//�����������뵥����ҳ��
		    var CureNeedMatchAry=new Array();
		    CureApplyReport(UpdateObj.OrderItemStr,CureNeedMatchAry,resolve);
	    })
	}).then(function(UpdateOrderItemStr){
		return new Promise(function(resolve,rejected){
			if (UpdateOrderItemStr!="") {
		        $.extend(UpdateObj, { OrderItemStr: UpdateOrderItemStr});
		    }else{
			    DisableBtn("Insert_Order_btn",false);
		        return websys_cancel();
		    }
		    resolve();
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			SetTimeLog("UpdateClickHandler", "����SaveOrderItems֮ǰ");
			var ExpStr = UpdateObj.StopConflictFlag + '^' + GlobalObj.DischargeConditionRowId + '^' + GlobalObj.DeceasedDateTimeStr + '^^^^^' + GlobalObj.LongOrdStopDateTime;
			if (GlobalObj.DirectSave != "1") {
		        if (UpdateObj.OrderItemStr != "") {
		            var OEOrdItemIDs = InsertOrderItem(UpdateObj.OrderItemStr, ExpStr);
		            if (OEOrdItemIDs == "0") {
		                $.messager.alert("��ʾ",t['Fail_SaveOrder'],"info",function(){
			                DisableBtn("Insert_Order_btn",false);
			            });
		                return websys_cancel();
		            } else {
		                $.extend(UpdateObj, { SUCCESS: true,OEOrdItemIDs:OEOrdItemIDs});
		            }
		        }
		    } else {
		        var PinNumberobj = document.getElementById("PinNumber");
		        if (PinNumberobj) {
		            var PinNumber = PinNumberobj.value;
		            if (PinNumber == "") {
		                $.messager.alert("��ʾ",t['Input_PinNumber'],"info",function(){
			                DisableBtn("Insert_Order_btn",false);
			                websys_setfocus('PinNumber');
			            });
		                return websys_cancel();
		            } else {
		                var ret = cspRunServerMethod(GlobalObj.PinNumberMethod, session['LOGON.USERID'], PinNumber)
		                if (ret == "-4") {
		                    $.messager.alert("��ʾ",t['Wrong_PinNumber'],"info",function(){
			                    DisableBtn("Insert_Order_btn",false);
			                    websys_setfocus('PinNumber');
			                });
		                    return websys_cancel();
		                }
		            }
		        }
		        var OEOrdItemIDs = SaveOrderItems(UpdateObj.OrderItemStr, XHZYRetCode, ExpStr);
		        if (OEOrdItemIDs == "100") {
		            $.messager.alert("��ʾ",t['Fail_SaveOrder'],"info",function(){
		                DisableBtn("Insert_Order_btn",false);
		                websys_setfocus('PinNumber');
		            });
		        } else {
		            $.extend(UpdateObj, { SUCCESS: true,OEOrdItemIDs: OEOrdItemIDs});
		        }
		    }
		    SetTimeLog("UpdateClickHandler", "����SaveOrderItems֮��");
		    resolve();
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			if (UpdateObj.caIsPass==1) SaveCASign(UpdateObj.ContainerName, UpdateObj.OEOrdItemIDs, "A");
			resolve();
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			GlobalObj.UnloadUpdateFlag = true;
			//��ӡ���뵥
			if (UpdateObj.NeedMatchAry.length>0) {
		        var ApplyOrdIdAllStr="";
		        var TempIDs = UpdateObj.OEOrdItemIDs.split("^");
		        var IDsLen = TempIDs.length;
		        for (var k = 0; k < IDsLen; k++) {
		            var TempNewOrdDR = TempIDs[k].split("*");
		            if (TempNewOrdDR.length < 2) continue;
		            var newOrdIdDR = TempNewOrdDR[1];
		            if (ApplyOrdIdAllStr == "") ApplyOrdIdAllStr = newOrdIdDR;
		            else ApplyOrdIdAllStr = ApplyOrdIdAllStr + "^" + newOrdIdDR;
		        }
		        if (ApplyOrdIdAllStr!="") print(ApplyOrdIdAllStr);
		    }
		    resolve();
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			//���ҽ���Ƿ��Զ�����һ����ӡ����,ҽ��վ��ȫ������������
		    if (GlobalObj.OnePrintFlag == 1) {
		        BtnPrtClickHandler();
		    }
		    resolve();
	    })
	}).then(function(){
		return new Promise(function(resolve,rejected){
			//¼��ҽ����ʱ���жϵ���״̬;��δ��������Ϊ����
		    if ((GlobalObj.LogonDoctorID != "") && (GlobalObj.SetArriveByOrder == 1) && (GlobalObj.SetArrivedStatusMethod != "")) {
		        var DocID = GlobalObj.LogonDoctorID;
		        if (cspRunServerMethod(GlobalObj.SetArrivedStatusMethod, GlobalObj.EpisodeID, DocID, session['LOGON.CTLOCID'], session['LOGON.USERID']) != '1') {
		        }
		    }
		    //ǰ��ҽ�������ɺ�Ľӿڵ�������,Ҫ��:�����õĽӿ�ʹ�ö���js��װ(����Զ���ķ�ʽ��װ),��csp������
		    if (GlobalObj.PAAdmType == "I") {
				//if (GlobalObj.HospitalCode == "ZGYKDFSYY") DHCDOCCallCs(); 
			}else{
			}
			//�����ͨ������ҩ���
			if ((GlobalObj.HLYYInterface==1)&&(GlobalObj.CurrCompanyCode=="DT")&&(DTDepNotDoUpLoad==1)){
			    var myrtn =DaTongXHZYSave();
			}
			//���溼�����׺�����ҩ���
			if ((GlobalObj.HLYYInterface==1)&&(GlobalObj.CurrCompanyCode=="HZYY")){
			    var myrtn=HYLLUpdateClick_HLYY(resolve,UpdateObj.OEOrdItemIDs,"Save");
			}
			//update by zf 2012-05-14
		    if (typeof window.parent.objControlArry != "undefined") {
		        window.parent.objControlArry['FormNewWin'].objFormShow.formShowData("", 0);
		    } else if (typeof window.parent.parent.objControlArry != "undefined") {
		        window.parent.parent.objControlArry['FormNewWin'].objFormShow.formShowData("", 0);
		    }
		    resolve();
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			DisableBtn("Insert_Order_btn",false);
			//ˢ��ҽ���б�ҽ����
		    ReloadGridData("Update");
		    //��˳ɹ���ˢ��ҽ����
		    if (UpdateObj.SUCCESS == true) {
			    AfterInsertOrd();
		    }
		    SetTimeLog("UpdateClickHandler", "end");
		    if (UpdateObj.callBackFun) UpdateObj.callBackFun();
		    resolve();	
	    })	
	}).then(function(){
		return new Promise(function(resolve,rejected){
			//�����ԴԤԼ���桢�����������ҳ����·�ͬ��ҽ����Ϣ���첽����.����ҳ�治��ͬʱ����
			(function(callBackFunExec){
				new Promise(function(resolve,rejected){
					//�Զ����������ԴԤԼ����
		    		var ExamItemBookFlag = cspRunServerMethod(GlobalObj.GetExamItemBookMethod, UpdateObj.OEOrdItemIDs);
		    		if (ExamItemBookFlag == "1") {
			    		var lnk = "dhc.ris.appointment.csp?a=a&EpisodeID=" + GlobalObj.EpisodeID;
			    		websys_showModal({
							url:lnk,
							title:'���ԤԼ��Դ',
							width:1000,height:630,
							onClose: function() {
								resolve(); //�˴�resolve�ǵ���������Ϲ���ҳ��
							}
						});
			    	}else{
				    	resolve();
				    }
				    callBackFunExec();
				}).then(function(){
					//ѡ����ϴ���������Ϣ
					OpenSelectDia(GlobalObj.EpisodeID,UpdateObj.OEOrdItemIDs)
				})
			})(resolve);
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			///�����໼���б����ˢ�����Ļ�����Ϣ
		    var FlagBF=HavZFOrderStr(UpdateObj.OrderItemStr)
		    if ((GlobalObj.PAAdmType=="I")&&(FlagBF=="Y")) {
			    if (window.parent.patientTreePanel) {
				    window.parent.patientTreePanel.store.load();
				}
				if (window.parent.GetGridData) {
					window.parent.GetGridData();
				}
			}
			SaveOrderToEMR();
		})
	})
 }
function AfterInsertOrd(){
    $('#PinNumber').val('');
    $("#Prompt").html("��ʾ��Ϣ:");
    var EpisPatInfo = tkMakeServerCall("web.DHCDocViewDataInit", "InitPatOrderViewGlobal", GlobalObj.EpisodeID,"",GlobalObj.EmConsultItm);
    InitPatOrderViewGlobal(EpisPatInfo);
    var warning=GetPromptHtml();
	$("#Prompt").html(warning);
    PageLogicObj.IsStartOrdSeqLink=0; //0 �������� 1 ��ʼ����
    PageLogicObj.StartMasterOrdSeq="";
    //�ŵ�ReloadGridDataȥ��գ���ֹ�򿪿ؼ������ҽ�����޷��ٴδ򿪿ؼ�������
    //PageLogicObj.fpArr=[];
    $("#ChangeOrderSeq_Btn .l-btn-text")[0].innerText=$g("��ʼ����(R)");
}
 function ApplyReport(OrderItemStr,NeedMatchAry,callBackFun) {
	var UpdateOrderItemStr="",result="",AutoGenARCIMStr="";;
    var LocID=session['LOGON.CTLOCID']; 
    var DoctorID=session['LOGON.USERID'];
    var ARCIMStrInfo=cspRunServerMethod(GlobalObj.GetItemServiceARCIMStrMethod,GlobalObj.EpisodeID,OrderItemStr,DoctorID,LocID);
    if (ARCIMStrInfo!=""){
	    new Promise(function(resolve,rejected){
	        var ARCIMStr=mPiece(ARCIMStrInfo,String.fromCharCode(2),0);
	        AutoGenARCIMStr=mPiece(ARCIMStrInfo,String.fromCharCode(2),1);
	        if (ARCIMStr!="") {
	            var lnk=encodeURI("dhcapp.docpopwin.csp?ARCIMStr="+ARCIMStr+"&EpisodeID="+GlobalObj.EpisodeID); 
	            websys_showModal({
					url:lnk,
					title:'����������',
					width:screen.availWidth-100,height:screen.availHeight-150,
					closable:false,
					CallBackFunc:function(rtnStr){
						websys_showModal("close");
						if (typeof rtnStr=="undefined"){
							rtnStr="";
						}
						if (rtnStr=="") {
							$.messager.alert("��ʾ","���δ��д���뵥,���ٴε�������ҽ���������ɾ�����ҽ��.","info",function(){
								callBackFun("");
							});  
						}else{
							result=rtnStr;
							resolve();
						}
					}
				});
	        }else{
		       resolve();
		    }
		}).then(function(){
			return new Promise(function(resolve,rejected){
				//�Զ��������뵥
		        if (AutoGenARCIMStr!="") {
		            var AutoGenresult=cspRunServerMethod(GlobalObj.InsExaReqNoMethod,AutoGenARCIMStr);
		            if (AutoGenresult!="") {
		                if (result=="") result=AutoGenresult;
		                else result=result+'@'+AutoGenresult;
		            } 
		        }
		        resolve();
	        })
		}).then(function(){
			if (result!="") {
				var UpdateOrderItemStr="";
				//��Ҫ������֯δ���ҽ���ַ���,ƴ���ϼ�������¼�ӱ�Rowid
	            //����:�����¼�ӱ�RowId^ҽ����ID^��¼Ψһ��ʶ@�����¼�ӱ�RowId^ҽ����ID^��¼Ψһ��ʶ@�����¼�ӱ�RowId^ҽ����ID^��¼Ψһ��ʶ
	            var resultAry=result.split('@');
	            for (var i=0;i<resultAry.length;i++) {
	                var oneResultAry=resultAry[i].split('^');
	                var ApplyArcId=oneResultAry[0];
	                var OrderSeqNo=oneResultAry[2];
	                NeedMatchAry[OrderSeqNo]=ApplyArcId;
	            }
	            var OrderItemAry=OrderItemStr.split(String.fromCharCode(1));
	            for (var i=0;i<OrderItemAry.length;i++) {
	                var oneOrderItemAry=OrderItemAry[i].split('^');
	                var ArcimId=oneOrderItemAry[0];
	                var OrderSeqNo=oneOrderItemAry[19];
	                if (NeedMatchAry[OrderSeqNo]) {
	                    oneOrderItemAry[58]=NeedMatchAry[OrderSeqNo];
	                }
	                var oneOrderItemStr=oneOrderItemAry.join('^');
	                if (UpdateOrderItemStr=="") {UpdateOrderItemStr=oneOrderItemStr;}else{UpdateOrderItemStr=UpdateOrderItemStr+String.fromCharCode(1)+oneOrderItemStr}
	            }
				callBackFun(UpdateOrderItemStr);
			}else{
				callBackFun(OrderItemStr);
			}
		})
    }else{
        callBackFun(OrderItemStr);
    }
}
function GetEntryDoctorId() {
    var DoctorRowid = "";
    //�����½��Ϊҽ��?�ͼ���ҽ��?�����½��Ϊ��ʿ?����ҽ��¼��?���Ǽ���ҽ��
    //�����½��Ϊ��ʿ?����û��ѡ��ҽ��?�ͼ��뻤ʿ
    if (GlobalObj.LogonDoctorType == "DOCTOR") {
        DoctorRowid = GlobalObj.LogonDoctorID;
    } else {
        var obj = document.getElementById('DoctorID');
        if (obj) DoctorRowid = obj.value;
        if (DoctorRowid == "") { DoctorRowid = GlobalObj.LogonDoctorID; }
    }
    return DoctorRowid;
}
function SaveOrderItems(OrderItemStr, XHZYRetCode, ExpStr) {
    var UserAddRowid = "";
    var UserAddDepRowid = "";
    UserAddRowid = session['LOGON.USERID'];
    UserAddDepRowid = session['LOGON.CTLOCID'];
    var DoctorRowid = GetEntryDoctorId();
    var ret = cspRunServerMethod(GlobalObj.SaveOrderItemsMethod, GlobalObj.EpisodeID, OrderItemStr, UserAddRowid, UserAddDepRowid, DoctorRowid, XHZYRetCode, ExpStr)
    return ret;
}
function InsertOrderItem(OrderItemStr, ExpStr) {
    var UserAddRowid = "";
    var UserAddDepRowid = "";
    UserAddRowid = session['LOGON.USERID'];
    UserAddDepRowid = session['LOGON.CTLOCID'];
    var DoctorRowid = GetEntryDoctorId();
    //$.messager.alert("����",OrderItemStr+"----"+UserAddRowid+"^"+UserAddDepRowid+"^"+DoctorRowid);
    var ret = cspRunServerMethod(GlobalObj.InsertOrderItemMethod, GlobalObj.EpisodeID, OrderItemStr, UserAddRowid, UserAddDepRowid, DoctorRowid, ExpStr)
    return ret;
}
//��ȡ¼��ҽ����Ϣ ��֯�ύ�ַ���
function GetOrderDataOnAdd(callBackFun) {
    var OrderItemStr = "";
    var OrderItem = "";
    var OneOrderItem = "";
   
	//����ҽ�����а�����ҽ������
	var OrderItemCongeriesNum=0;
    //try {
	var EmConsultItm=GlobalObj.EmConsultItm;	///�����ӱ�ID
	
    var DataArry = GetGirdData();
    if (DataArry.length==0) {
	    callBackFun("");
	    return;
	}
	var OrderSeqNoArr = new Array();
    new Promise(function(resolve,rejected){
	    (function(callBackFunExec){
		    function loop(i){
			    new Promise(function(resolve,rejected){
				    var OrderARCIMRowid = DataArry[i]["OrderARCIMRowid"];
					var OrderARCOSRowid = DataArry[i]["OrderARCOSRowid"];
					if ((OrderARCIMRowid != "")||(OrderARCOSRowid!="")) {
						var OrderName=DataArry[i]["OrderName"];
						var OrderDepProcNotes = DataArry[i]["OrderDepProcNote"];
					    if ((OrderDepProcNotes!="")&&(OrderDepProcNotes.indexOf("^")>=0)) {
						    $.messager.confirm('ȷ�϶Ի���', OrderName+" ҽ����ע����ϵͳ�����ַ�^,��ȷ���Ƿ��滻���ַ�~?", function(r){
								if (r) {
									EditRow(DataArry[i]["id"]);
									SetCellData(DataArry[i]["id"], "OrderDepProcNote",OrderDepProcNotes.replace(/\^/g, "~"));
									DataArry = GetGirdData();
									resolve();
								}else{
									callBackFun(false);
								}
							})
							return;
						}
					}
					resolve();
				}).then(function(){
					return new Promise(function(resolve,rejected){
						var OrderItemRowid = DataArry[i]["OrderItemRowid"];
				        var OrderARCIMRowid = DataArry[i]["OrderARCIMRowid"];
						var OrderARCOSRowid = DataArry[i]["OrderARCOSRowid"];
				        ///tanjishan 2015-09    
				        //if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
				        var StyleConfigStr = DataArry[i]["StyleConfigStr"];
				        var StyleConfigObj = {};
				        if (StyleConfigStr != "") {
				            StyleConfigObj = eval("(" + StyleConfigStr + ")");
				        }
				        if ((GlobalObj.PAAdmType != "I") && (StyleConfigObj.OrderPackQty != true) && (OrderItemRowid != "")) { 
				        	resolve(); 
				        	return; 
				        }
				        if ((OrderARCIMRowid == "")&&(OrderARCOSRowid=="")) { 
				        	resolve(); 
				        	return;
				        }
						//ԭ���  ����ID
				        var OrderSeqNo = DataArry[i]["id"];
						var OrderItemCongeriesJson = DataArry[i]["OrderItemCongeries"];
						if (OrderItemCongeriesJson!=""){
							var OrderItemObj=GetOrderItemByItemCongeries(OrderSeqNo,OrderItemCongeriesJson);
							if (OrderItemObj.OrderItemStr!=""){
								if (OrderItemStr == "") {
									OrderItemStr = OrderItemObj.OrderItemStr;
								} else {
									OrderItemStr = OrderItemStr + String.fromCharCode(1) + OrderItemObj.OrderItemStr;
								}
							}
							if (parseFloat(OrderItemObj.OrderItemCount)==0){
								OrderItemObj.OrderItemCount=1;
							}
							OrderItemCongeriesNum=parseFloat(OrderItemCongeriesNum)+parseFloat(OrderItemObj.OrderItemCount);
							resolve(); 
				        	return;
						}
						var OldOrderSeqNo=OrderSeqNo;
						if (parseFloat(OrderItemCongeriesNum)>0){
							OrderSeqNo=parseFloat(OrderItemCongeriesNum)+parseFloat(OrderSeqNo);
						}
						OrderSeqNoArr[OldOrderSeqNo]=OrderSeqNo;
				        var OrderName = DataArry[i]["OrderName"];
				        var OrderType = DataArry[i]["OrderType"];
				        var OrderPriorRowid = DataArry[i]["OrderPriorRowid"];
				        var OrderRecDepRowid = DataArry[i]["OrderRecDepRowid"];
				        var OrderFreqRowid = DataArry[i]["OrderFreqRowid"];
				        var OrderDurRowid = DataArry[i]["OrderDurRowid"];
				        var OrderInstrRowid = DataArry[i]["OrderInstrRowid"];
				        var OrderDoseQty = DataArry[i]["OrderDoseQty"];
				        var OrderDoseQty = FormateNumber(OrderDoseQty);
				        var OrderDoseUOMRowid = DataArry[i]["OrderDoseUOMRowid"];
				        var OrderPackQty = DataArry[i]["OrderPackQty"];
				        var OrderPrice = DataArry[i]["OrderPrice"];
				        var PHPrescType = DataArry[i]["OrderPHPrescType"];
				        var BillTypeRowid = DataArry[i]["OrderBillTypeRowid"];
				        var OrderSkinTest = DataArry[i]["OrderSkinTest"];
				        var OrderARCOSRowid = DataArry[i]["OrderARCOSRowid"];
				        var OrderDrugFormRowid = DataArry[i]["OrderDrugFormRowid"];
				        var OrderStartDateStr = DataArry[i]["OrderStartDate"];
				        var OrderStartDate = "";
				        var OrderStartTime = "";
				        if (OrderStartDateStr != "") {
				            OrderStartDate = OrderStartDateStr.split(" ")[0];
				            OrderStartTime = OrderStartDateStr.split(" ")[1];
				        }
				        //����
				        var OrderMasterSeqNo = DataArry[i]["OrderMasterSeqNo"];
						if ((parseFloat(OrderItemCongeriesNum)>0)&&(OrderMasterSeqNo!="")){
							if (OrderSeqNoArr[OrderMasterSeqNo]) {
								OrderMasterSeqNo=OrderSeqNoArr[OrderMasterSeqNo];
							}else{
								OrderMasterSeqNo=parseFloat(OrderItemCongeriesNum)+parseFloat(OrderMasterSeqNo);
							}
						}
				        var OrderDepProcNotes = DataArry[i]["OrderDepProcNote"];
				        var OrderPhSpecInstr = ""; //DataArry[i]["OrderPhSpecInstr"];
				        var OrderCoverMainIns = DataArry[i]["OrderCoverMainIns"];
				        var OrderActionRowid = DataArry[i]["OrderActionRowid"];
				        var OrderEndDateStr = DataArry[i]["OrderEndDate"];
				        var OrderEndDate = "";
				        var OrderEndTime = "";
				        if (OrderEndDateStr != "") {
				            OrderEndDate = OrderEndDateStr.split(" ")[0];
				            OrderEndTime = OrderEndDateStr.split(" ")[1];
				        }
				        var OrderLabSpecRowid = DataArry[i]["OrderLabSpecRowid"];
				        var OrderMultiDate = ""; //DataArry[i]["OrderMultiDate"];
				        var OrderNotifyClinician = ""; //DataArry[i]["OrderNotifyClinician"];
				        //if (OrderNotifyClinician==true){OrderNotifyClinician="Y"}else{OrderNotifyClinician="N"}
				        var OrderDIACatRowId = DataArry[i]["OrderDIACatRowId"];
				        //ҽ�����
				        var OrderInsurCatRowId = DataArry[i]["OrderInsurCatRowId"];
				        //ҽ�����մ���
				        var OrderFirstDayTimes = DataArry[i]["OrderFirstDayTimes"];
				        //���������ȡҩҽ��,�Ա�ҩ����ֻ����ִ�м�¼,������Ա�ҩ����
				        if (((OrderPriorRowid == GlobalObj.LongOrderPriorRowid) || (OrderPriorRowid == GlobalObj.OMSOrderPriorRowid)) && (GlobalObj.PAAdmType == "I")) OrderFirstDayTimes = DataArry[i]["OrderFirstDayTimes"];
				        //ҽ����Ӧ֢
				        var OrderInsurSignSymptomCode = ""; //DataArry[i]["OrderInsurSignSymptomCode"];
				        //���岿λ
				        var OrderBodyPart = DataArry[i]["OrderBodyPart"];
				        if (OrderBodyPart != "") {
				            if (OrderDepProcNotes != "") {
				                OrderDepProcNotes = OrderDepProcNotes + "," + OrderBodyPart;
				            } else {
				                OrderDepProcNotes = OrderBodyPart;
				            }
				        }
				        //ҽ���׶�
				        var OrderStageCode = DataArry[i]["OrderStageCode"];
				        //��Һ����
				        var OrderSpeedFlowRate = DataArry[i]["OrderSpeedFlowRate"];
				        OrderSpeedFlowRate = FormateNumber(OrderSpeedFlowRate);
				        //GetMenuPara("AnaesthesiaID");
				        var AnaesthesiaID = DataArry[i]["AnaesthesiaID"];
				        var OrderLabEpisodeNo = DataArry[i]["OrderLabEpisodeNo"];

				        var VerifiedOrderMasterRowid = "";
				        //Ӫ��ҩ��־
				        var OrderNutritionDrugFlag = ""; //DataArry[i]["OrderNutritionDrugFlag"];
				        //��¼������ҽ����Ϣ 
				        var LinkedMasterOrderRowid = DataArry[i]["LinkedMasterOrderRowid"];
				        var LinkedMasterOrderSeqNo = DataArry[i]["LinkedMasterOrderSeqNo"];
				        if ((LinkedMasterOrderSeqNo != "") && (OrderMasterSeqNo == "")) {
				            OrderMasterSeqNo = DataArry[i]["LinkedMasterOrderSeqNo"];
				        }
				        //if ((VerifiedOrderMasterRowid!="")&&(LinkedMasterOrderRowid=="")) LinkedMasterOrderRowid=VerifiedOrderMasterRowid;
				        //��������
				        var OrderInsurApproveType = ""; //DataArry[i]["OrderInsurApproveType"];
				        //�ٴ�·������
				        var OrderCPWStepItemRowId = DataArry[i]["OrderCPWStepItemRowId"];
				        //��ֵ��������
				        var OrderMaterialBarCode = DataArry[i]["OrderMaterialBarcodeHiden"];
				        //��Һ���ٵ�λ
				        var OrderFlowRateUnit = DataArry[i]["OrderFlowRateUnit"];
				        var OrderFlowRateUnitRowId = DataArry[i]["OrderFlowRateUnitRowId"];
				        //��ҽ������
				        var OrderDate = "";
				        var OrderTime = "";
				        var OrderDateStr = DataArry[i]["OrderDate"];
				        if (OrderDateStr != "") {
				            OrderDate = OrderDateStr.split(" ")[0];
				            OrderTime = OrderDateStr.split(" ")[1];
				        }
				        //��Ҫ��Һ
				        var OrderNeedPIVAFlag = DataArry[i]["OrderNeedPIVAFlag"];
				        //****************������10********************************/
				        // ����ҩƷ����
				        var OrderAntibApplyRowid = DataArry[i]["OrderAntibApplyRowid"];
				        //������ʹ��ԭ��
				        var AntUseReason = DataArry[i]["AntUseReason"];
				        //ʹ��Ŀ��
				        var UserReasonId = DataArry[i]["UserReasonId"];
				        var ShowTabStr = DataArry[i]["ShowTabStr"];
				        //************************************************/
				        //��Һ����
				        var OrderLocalInfusionQty = DataArry[i]["OrderLocalInfusionQty"];
				        //�����Ա�
				        var OrderBySelfOMFlag = "";
				        if (DataArry[i]["OrderSelfOMFlag"]) OrderBySelfOMFlag = DataArry[i]["OrderSelfOMFlag"];
				        var OrderOutsourcingFlag = "";
				        if (DataArry[i]["OrderOutsourcingFlag"]) OrderOutsourcingFlag = DataArry[i]["OrderOutsourcingFlag"];
				        //�����Ƴ�ԭ��
				        var ExceedReasonID = DataArry[i]["ExceedReasonID"];
				        //�Ƿ�Ӽ�
				        var OrderNotifyClinician = DataArry[i]["Urgent"];
				        //����װ��λ
				        var OrderPackUOMRowid = DataArry[i]["OrderPackUOMRowid"];
				        var OrderOperationCode=DataArry[i]["OrderOperationCode"];
						var OrderFreqDispTimeStr = DataArry[i]["OrderFreqDispTimeStr"]; 
						var OrderFreqInfo=DataArry[i]["OrderFreqFactor"]+"^"+DataArry[i]["OrderFreqInterval"]+"^"+OrderFreqDispTimeStr;
						var OrderDurFactor=DataArry[i]["OrderDurFactor"];
						var OrderHiddenPara=DataArry[i]["OrderHiddenPara"];
						var OrderQtyInfo=GetOrderQtyInfo(OrderType,OrderDoseQty,OrderFreqInfo,OrderDurFactor,OrderStartDateStr,OrderFirstDayTimes,OrderPackQty,OrderHiddenPara);
						var OrderQtySum=mPiece(OrderQtyInfo, "^", 0)
						var OrderPackQty=mPiece(OrderQtyInfo, "^",1)
				        
				        var OrderPriorRemarks = DataArry[i]["OrderPriorRemarksRowId"];
				        OrderPriorRowid = ReSetOrderPriorRowid(OrderPriorRowid, OrderPriorRemarks);
				        //ҩ����Ŀ
				        var OrderPilotProRowid = DataArry[i]["OrderPilotProRowid"];
						if (OrderPilotProRowid!="") {
							if (GlobalObj.PAAdmType == "I") {
								if (GlobalObj.CFIPPilotPatAdmReason != "") BillTypeRowid = GlobalObj.CFIPPilotPatAdmReason;
							} else {
								if (GlobalObj.CFPilotPatAdmReason != "") BillTypeRowid = GlobalObj.CFPilotPatAdmReason;
							}
						}
				        if (OrderDoseQty == "") { OrderDoseUOMRowid = "" }
				        //��������ӱ��¼Id
				        var ApplyArcId="";
				        //��������ԤԼID
				        var DCAARowId= mPiece(OrderHiddenPara, String.fromCharCode(1), 20); //GlobalObj.DCAARowId
				        //�ٴ�֪ʶ�����id
				        var OrderMonitorId=DataArry[i]["OrderMonitorId"];
				        var OrderNurseLinkOrderRowid=DataArry[i]["OrderNurseLinkOrderRowid"];;
						var OrderBodyPartLabel=DataArry[i]["OrderBodyPartLabel"];
						if (typeof OrderBodyPartLabel=="undefined"){OrderBodyPartLabel="";}
						var CelerType="N";	//����ҽ���ױ�ʶ
						var OrdRowIndex=DataArry[i]["id"];
						var OrderFreqExpInfo=CalOrderFreqExpInfo(OrderFreqDispTimeStr);
						var OrderFreqWeekStr=mPiece(OrderFreqExpInfo, "^", 0);
						var OrderFreqFreeTimeStr=mPiece(OrderFreqExpInfo, "^", 1);
						
						var OrderHiddenPara=DataArry[i]["OrderHiddenPara"];
				    	var OrderOpenForAllHosp=OrderHiddenPara.split(String.fromCharCode(1))[18];
				    	var OrderFreqTimeDoseStr=DataArry[i]["OrderFreqTimeDoseStr"];
				    	if (OrderFreqTimeDoseStr!="") OrderDoseQty="";
				    	var OrderNurseBatchAdd=""; //��ʿ������¼��־,������¼ҽ�����洫��
				    	var OrderSum = DataArry[i]["OrderSum"];
				    	var AntCVID=GlobalObj.AntCVID; //Σ��ֵID
				    	var OrderPkgOrderNo = DataArry[i]["OrderPkgOrderNo"];
				    	var OrderDocRowid=DataArry[i]["OrderDocRowid"];
				    	///
				    	var OrderPracticePreRowid=OrderHiddenPara.split(String.fromCharCode(1))[23];
				    	///���ⳤ�ڱ�־
				    	var OrderVirtualtLong=DataArry[i]["OrderVirtualtLong"];
				    	var OrderFillterNo="";
                        var OrderChronicDiagCode = DataArry[i]["OrderChronicDiagCode"];
				    	if (GlobalObj.InsurBillStr.indexOf("^"+BillTypeRowid+"^")==-1){
					    	OrderChronicDiagCode="";
					    }
					    /// �ɼ���λ
					    var OrderLabSpecCollectionSiteRowid = DataArry[i]["OrderLabSpecCollectionSiteRowid"];
					    //��ʿ��¼ҽ��������ҽ���ַ�ʱ��
					    var OrderNurseExecLinkDispTimeStr = DataArry[i]["OrderNurseExecLinkDispTimeStr"];
					    if (!OrderNurseExecLinkDispTimeStr) OrderNurseExecLinkDispTimeStr="";
				        OrderItem = OrderARCIMRowid + "^" + OrderType + "^" + OrderPriorRowid + "^" + OrderStartDate + "^" + OrderStartTime + "^" + OrderPackQty + "^" + OrderPrice;
				        OrderItem = OrderItem + "^" + OrderRecDepRowid + "^" + BillTypeRowid + "^" + OrderDrugFormRowid + "^" + OrderDepProcNotes;
				        OrderItem = OrderItem + "^" + OrderDoseQty + "^" + OrderDoseUOMRowid + "^" + OrderQtySum + "^" + OrderFreqRowid + "^" + OrderDurRowid + "^" + OrderInstrRowid;
				        OrderItem = OrderItem + "^" + PHPrescType + "^" + OrderMasterSeqNo + "^" + OrderSeqNo + "^" + OrderSkinTest + "^" + OrderPhSpecInstr + "^" + OrderCoverMainIns;
				        OrderItem = OrderItem + "^" + OrderActionRowid + "^" + OrderARCOSRowid + "^" + OrderEndDate + "^" + OrderEndTime + "^" + OrderLabSpecRowid + "^" + OrderMultiDate;
				        OrderItem = OrderItem + "^" + OrderNotifyClinician + "^" + OrderDIACatRowId + "^" + OrderInsurCatRowId + "^" + OrderFirstDayTimes + "^" + OrderInsurSignSymptomCode;
				        OrderItem = OrderItem + "^" + OrderStageCode + "^" + OrderSpeedFlowRate + "^" + AnaesthesiaID + "^" + OrderLabEpisodeNo;
				        OrderItem = OrderItem + "^" + LinkedMasterOrderRowid + "^" + OrderNutritionDrugFlag;
				        OrderItem = OrderItem + "^" + OrderMaterialBarCode + "^^" + OrderCPWStepItemRowId + "^" + OrderInsurApproveType;
				        OrderItem = OrderItem + "^" + OrderFlowRateUnitRowId + "^" + OrderDate + "^" + OrderTime + "^" + OrderNeedPIVAFlag + "^" + OrderAntibApplyRowid + "^" + AntUseReason + "^" + UserReasonId;
				        OrderItem = OrderItem + "^" + OrderLocalInfusionQty + "^" + OrderBySelfOMFlag + "^" + ExceedReasonID + "^" + OrderPackUOMRowid + "^" + OrderPilotProRowid + "^" + OrderOutsourcingFlag;
				        OrderItem = OrderItem + "^" + OrderItemRowid + "^" + ApplyArcId + "^" + DCAARowId + "^" + OrderOperationCode;
				        OrderItem = OrderItem + "^" + OrderMonitorId + "^" + OrderNurseLinkOrderRowid + "^" + OrderBodyPartLabel + "^" + CelerType + "^" + OrdRowIndex + "^" + OrderFreqWeekStr +"^"+ OrderOpenForAllHosp+"^"+OrderPracticePreRowid;
				        OrderItem = OrderItem + "^" + OrderFreqTimeDoseStr+ "^"+OrderNurseBatchAdd+"^" +OrderSum+"^"+AntCVID+"^"+OrderPkgOrderNo+"^^^^"+OrderDocRowid+"^"+OrderVirtualtLong+"^"+OrderFillterNo;
				        OrderItem = OrderItem + "^" + EmConsultItm + "^" + OrderChronicDiagCode + "^" + OrderFreqFreeTimeStr+"^"+OrderLabSpecCollectionSiteRowid +"^"+ OrderNurseExecLinkDispTimeStr;
				        if (OrderItemStr == "") { OrderItemStr = OrderItem } else { OrderItemStr = OrderItemStr + String.fromCharCode(1) + OrderItem }
				        resolve();
					})
				}).then(function(){
					i++;
					if ( i < DataArry.length ) {
						 loop(i);
					}else{
						if (OrderItemStr!="") {
							//��ȡ������˰�ҽ����׷�ӵ�OrdItemStr
							var OrdAddCongeriesArr=new Array();
							var OrdAddCongeriesJson=JSON.stringify(OrdAddCongeriesArr);
							var OrdAddCongeries = cspRunServerMethod(GlobalObj.GetGetAppendOrdItemListMethod, GlobalObj.EpisodeID,OrderItemStr,session['LOGON.CTLOCID'],OrdAddCongeriesJson);
							var OrdAddCongeriesObj=eval("("+OrdAddCongeries+")");
							for (var k=0;k<OrdAddCongeriesObj.length;k++){
								var OrderItem=OrdAddCongeriesObj[k].OrdListInfo;
								OrderItemStr = OrderItemStr + String.fromCharCode(1) + OrderItem;
							}
						}
						callBackFunExec();
					}
				})
			}
		    loop(0)
		})(resolve);
	}).then(function(){
		 callBackFun(OrderItemStr)
	})
	function GetOrderItemByItemCongeries(Startid,OrderItemCongeriesJson){
		var OrderItemCongeriesObj=eval("("+OrderItemCongeriesJson+")");
		var seqnoarr = new Array();
		var id=Startid;
		var OrderItemCount=0;
		//�ȼ�������־
		for (var i=0,Length=OrderItemCongeriesObj.length;i<Length;i++) {
			OrderItemCongeriesObj[i].id=id;
			var CalSeqNo=OrderItemCongeriesObj[i].CalSeqNo;
			//��¼������ϵ
			var MasterSeqNo="";
			var tempseqnoarr = CalSeqNo.split(".");
			if (tempseqnoarr.length > 1) {
				var masterseqno = tempseqnoarr[0];
				if (seqnoarr[masterseqno]) {
					MasterSeqNo = seqnoarr[masterseqno];
				}
			}
			OrderItemCongeriesObj[i].OrderMasterSeqNo=MasterSeqNo;
			
			if (tempseqnoarr.length =1) {
				seqnoarr[CalSeqNo] = id;
			}
			OrderItemCount++;
			id++;
		}
		/*
		��ȡҽ���б���Ϣ,���ݶ�Ӧ�ĺ�̨
		##Class(web.DHCOEOrdItemView).GetItemToList��InitParamArr
		*/
    	var EmConsultItm=GlobalObj.EmConsultItm;	///�����ӱ�ID
    	
		
		var OrderItemStr="";
		for (var i=0,Length=OrderItemCongeriesObj.length;i<Length;i++) {
			var OrderARCIMRowid=OrderItemCongeriesObj[i].OrderARCIMRowid;
			var OrderType=OrderItemCongeriesObj[i].OrderType;
			var OrderPriorRowid=OrderItemCongeriesObj[i].SpecOrderPriorRowid;
			var OrderFreqDispTimeStr = OrderItemCongeriesObj[i]["OrderFreqDispTimeStr"]; 
			if (OrderFreqDispTimeStr!="") {
				var OrderStartDateStr = OrderItemCongeriesObj[i]["OrderStartDate"];
			}else{
				var OrderStartDateStr=GetCellData(Startid,"OrderStartDate");
			}
			var OrderStartDate = OrderStartDateStr.split(" ")[0];
            var OrderStartTime = OrderStartDateStr.split(" ")[1];
			
			var OrderPackQty=OrderItemCongeriesObj[i].OrderPackQty;
			var OrderPrice=OrderItemCongeriesObj[i].OrderPrice;
			var OrderRecDepRowid=OrderItemCongeriesObj[i].OrderRecDepRowid;
			var BillTypeRowid=OrderItemCongeriesObj[i].OrderBillTypeRowid;
			var OrderDrugFormRowid=OrderItemCongeriesObj[i].OrderDrugFormRowid;
			var OrderDepProcNote=OrderItemCongeriesObj[i].OrderDepProcNote;
			
			var OrderDoseQty=OrderItemCongeriesObj[i].OrderDoseQty;
			var OrderDoseUOMRowid=OrderItemCongeriesObj[i].OrderDoseUOMRowid;
			var OrderFreqFactor=OrderItemCongeriesObj[i].OrderFreqFactor;
			var OrderFreqInterval=OrderItemCongeriesObj[i].OrderFreqInterval;
			var OrderFreqDispTimeStr=OrderItemCongeriesObj[i].OrderFreqDispTimeStr;
			var OrderDurFactor=OrderItemCongeriesObj[i].OrderDurFactor;
			var OrderFirstDayTimes=OrderItemCongeriesObj[i].OrderFirstDayTimes;
			var OrderFreqRowid=OrderItemCongeriesObj[i].OrderFreqRowid;
			var OrderDurRowid=OrderItemCongeriesObj[i].OrderDurRowid;
			var OrderInstrRowid=OrderItemCongeriesObj[i].OrderInstrRowid;
			var OrderPHPrescType=OrderItemCongeriesObj[i].OrderPHPrescType;
			var OrderMasterSeqNo=OrderItemCongeriesObj[i].OrderMasterSeqNo;
			var OrderSeqNo=OrderItemCongeriesObj[i].id;
			var OrderSkinTest=OrderItemCongeriesObj[i].OrderSkinTest;
			var OrderPhSpecInstr = "";
			var OrderCoverMainIns = GetCellData(Startid, "OrderCoverMainIns");
			var OrderActionRowid=OrderItemCongeriesObj[i].OrderActionRowid;
			var OrderARCOSRowid=OrderItemCongeriesObj[i].OrderARCOSRowid;
			var OrderHiddenPara = OrderItemCongeriesObj[i].OrderHiddenPara;
			var OrderEndDate="",OrderEndTime="";
			var OrderLabSpecRowid=OrderItemCongeriesObj[i].OrderLabSpecRowid;
			var OrderMultiDate="";
			var OrderNotifyClinician=OrderItemCongeriesObj[i].Urgent;//�Ƿ�Ӽ�
			var OrderDIACatRowId=GetCellData(Startid, "OrderDIACatRowId");
			var OrderInsurCatRowId=OrderItemCongeriesObj[i].OrderInsurCatRowId;
			var OrderInsurSignSymptomCode="";
			var OrderStageCode = OrderItemCongeriesObj[i].OrderStageCode; //GetCellData(Startid, "OrderStageCode");
			var OrderSpeedFlowRate=OrderItemCongeriesObj[i].OrderSpeedFlowRate;
			//var AnaesthesiaID = GetMenuPara("AnaesthesiaID");
			var AnaesthesiaID = OrderItemCongeriesObj[i].AnaesthesiaID;
			var OrderLabEpisodeNo="";
			var LinkedMasterOrderRowid=OrderItemCongeriesObj[i].LinkedMasterOrderRowid;
			var OrderNutritionDrugFlag = "";
			var OrderMaterialBarCode="";
			var OrderCPWStepItemRowId=OrderItemCongeriesObj[i].OrderCPWStepItemRowId;
			var OrderInsurApproveType="";
			var OrderFlowRateUnitRowId=OrderItemCongeriesObj[i].OrderFlowRateUnitRowId;
			
			var OrderDate = "";
            var OrderTime = "";
            var OrderDateStr = GetCellData(Startid, "OrderDate");
            if (OrderDateStr != "") {
                OrderDate = OrderDateStr.split(" ")[0];
                OrderTime = OrderDateStr.split(" ")[1];
            }
			var OrderNeedPIVAFlag=OrderItemCongeriesObj[i].OrderNeedPIVAFlag;
			//****************������********************************/
			// ����ҩƷ����-TODO����ǰ����ҽ���׻���֧�ֿ�����
            var OrderAntibApplyRowid = "";
            //������ʹ��ԭ��
            var AntUseReason = "";
            //ʹ��Ŀ��
            var UserReasonId = GetCellData(Startid, "UserReasonId");
            //************************************************/
			var OrderLocalInfusionQty="";//��Һ����           
			var OrderBySelfOMFlag=""; //�����Ա�
            var ExceedReasonID = "";//�����Ƴ�ԭ��
			var OrderPackUOMRowid=OrderItemCongeriesObj[i].OrderPackUOMRowid;
			//ҩ����Ŀ
            var OrderPilotProRowid = GetCellData(Startid, "OrderPilotProRowid");
            if (GlobalObj.PAAdmType == "I") {
                if (GlobalObj.CFIPPilotPatAdmReason != "") BillTypeRowid = GlobalObj.CFIPPilotPatAdmReason;
            } else {
                if (GlobalObj.CFPilotPatAdmReason != "") BillTypeRowid = GlobalObj.CFPilotPatAdmReason;
            }			
			var OrderOutsourcingFlag="N";	//�⹺
			var OrderItemRowid="";
            var ApplyArcId="";	//��������ӱ��¼Id
            var DCAARowId=GlobalObj.DCAARowId;	//��������ԤԼID
			var OrderOperationCode=GetCellData(Startid, "OrderOperationCode");	//�����б�
            var OrderMonitorId="";	//�ٴ�֪ʶ�����id TODO:����ҽ����û�к��ٴ�֪ʶ��Խ�
            var OrderNurseLinkOrderRowid=OrderItemCongeriesObj[i].OrderNurseLinkOrderRowid;
			var OrderBodyPartLabel=OrderItemCongeriesObj[i].OrderBodyPartLabel;
			if (typeof OrderBodyPartLabel=="undefined"){OrderBodyPartLabel="";}
			var OrderFreqInfo=OrderFreqFactor+"^"+OrderFreqInterval+"^"+OrderFreqDispTimeStr;
			var OrderQtyInfo=GetOrderQtyInfo(OrderType,OrderDoseQty,OrderFreqInfo,OrderDurFactor,OrderStartDateStr,OrderFirstDayTimes,OrderPackQty,OrderHiddenPara)
			var OrderQtySum=mPiece(OrderQtyInfo, "^", 0)
			var OrderPackQty=mPiece(OrderQtyInfo, "^",1)
			var CelerType="Y";
			var OrdRowIndex=Startid;
			var OrderFreqExpInfo=CalOrderFreqExpInfo(OrderFreqDispTimeStr);
			var OrderFreqWeekStr=mPiece(OrderFreqExpInfo, "^", 0);
			var OrderFreqFreeTimeStr=mPiece(OrderFreqExpInfo, "^", 1);
			
	    	var OrderOpenForAllHosp=OrderHiddenPara.split(String.fromCharCode(1))[18];
	    	var OrderPracticePreRowid=OrderHiddenPara.split(String.fromCharCode(1))[23];
			var OrderFreqTimeDoseStr=OrderItemCongeriesObj[i].OrderFreqTimeDoseStr;
	    	if (OrderFreqTimeDoseStr!="") OrderDoseQty="";
	    	var OrderNurseBatchAdd=""; //��ʿ������¼��־,������¼ҽ�����洫��
	    	var OrderSum = OrderItemCongeriesObj[i].OrderSum;
	    	var AntCVID=GlobalObj.AntCVID; //Σ��ֵID
	    	var OrderPkgOrderNo=OrderItemCongeriesObj[i].OrderPkgOrderNo;
	    	var OrderDocRowid=OrderItemCongeriesObj[i].OrderDocRowid;
			var OrderVirtualtLong="";
	    	var OrderFillterNo="";
            var OrderChronicDiagCode = OrderItemCongeriesObj[i].OrderChronicDiagCode;
			if (GlobalObj.InsurBillStr.indexOf("^"+BillTypeRowid+"^")==-1){
		    	OrderChronicDiagCode="";
	    	}
	    	var OrderLabSpecCollectionSiteRowid = OrderItemCongeriesObj[i].OrderLabSpecCollectionSiteRowid;
	    	//��ʿ��¼ҽ��������ҽ���ַ�ʱ��
			var OrderNurseExecLinkDispTimeStr = OrderItemCongeriesObj[i]["OrderNurseExecLinkDispTimeStr"];
			if (!OrderNurseExecLinkDispTimeStr) OrderNurseExecLinkDispTimeStr="";
			OrderItem = OrderARCIMRowid + "^" + OrderType + "^" + OrderPriorRowid + "^" + OrderStartDate + "^" + OrderStartTime + "^" + OrderPackQty + "^" + OrderPrice;
            OrderItem = OrderItem + "^" + OrderRecDepRowid + "^" + BillTypeRowid + "^" + OrderDrugFormRowid + "^" + OrderDepProcNote;
            OrderItem = OrderItem + "^" + OrderDoseQty + "^" + OrderDoseUOMRowid + "^" + OrderQtySum + "^" + OrderFreqRowid + "^" + OrderDurRowid + "^" + OrderInstrRowid;
            OrderItem = OrderItem + "^" + OrderPHPrescType + "^" + OrderMasterSeqNo + "^" + OrderSeqNo + "^" + OrderSkinTest + "^" + OrderPhSpecInstr + "^" + OrderCoverMainIns;
            OrderItem = OrderItem + "^" + OrderActionRowid + "^" + OrderARCOSRowid + "^" + OrderEndDate + "^" + OrderEndTime + "^" + OrderLabSpecRowid + "^" + OrderMultiDate;
            OrderItem = OrderItem + "^" + OrderNotifyClinician + "^" + OrderDIACatRowId + "^" + OrderInsurCatRowId + "^" + OrderFirstDayTimes + "^" + OrderInsurSignSymptomCode;
            OrderItem = OrderItem + "^" + OrderStageCode + "^" + OrderSpeedFlowRate + "^" + AnaesthesiaID + "^" + OrderLabEpisodeNo;
            OrderItem = OrderItem + "^" + LinkedMasterOrderRowid + "^" + OrderNutritionDrugFlag;
            OrderItem = OrderItem + "^" + OrderMaterialBarCode + "^^" + OrderCPWStepItemRowId + "^" + OrderInsurApproveType;
            OrderItem = OrderItem + "^" + OrderFlowRateUnitRowId + "^" + OrderDate + "^" + OrderTime + "^" + OrderNeedPIVAFlag + "^" + OrderAntibApplyRowid + "^" + AntUseReason + "^" + UserReasonId;
            OrderItem = OrderItem + "^" + OrderLocalInfusionQty + "^" + OrderBySelfOMFlag + "^" + ExceedReasonID + "^" + OrderPackUOMRowid + "^" + OrderPilotProRowid + "^" + OrderOutsourcingFlag;
            OrderItem = OrderItem + "^" + OrderItemRowid + "^" + ApplyArcId + "^" + DCAARowId + "^" + OrderOperationCode;
            OrderItem = OrderItem + "^" + OrderMonitorId + "^" + OrderNurseLinkOrderRowid + "^" + OrderBodyPartLabel + "^" + CelerType + "^" + OrdRowIndex + "^" + OrderFreqWeekStr;
            
            OrderItem = OrderItem +"^"+ OrderOpenForAllHosp+"^"+OrderPracticePreRowid;
            OrderItem = OrderItem + "^" + OrderFreqTimeDoseStr+ "^"+OrderNurseBatchAdd+"^" +OrderSum+"^"+AntCVID+"^"+OrderPkgOrderNo+"^^^^"+OrderDocRowid+"^"+OrderVirtualtLong+"^"+OrderFillterNo;
            OrderItem = OrderItem + "^" + EmConsultItm + "^" + OrderChronicDiagCode+ "^" + OrderFreqFreeTimeStr +"^"+OrderLabSpecCollectionSiteRowid +"^"+ OrderNurseExecLinkDispTimeStr;
            if (OrderItemStr == "") { OrderItemStr = OrderItem } else { OrderItemStr = OrderItemStr + String.fromCharCode(1) + OrderItem }
		}
		
		return {
			OrderItemStr:OrderItemStr,
			OrderItemCount:OrderItemCount
		};
		
	}
	///����OrderQtySum
	function GetOrderQtyInfo(OrderType,OrderDoseQty,OrderFreqInfo,OrderDurFactor,OrderStartDateStr,OrderFirstDayTimes,OrderPackQty,OrderHiddenPara){
		var OrderFreqFactor=mPiece(OrderFreqInfo, "^", 0);
		if (OrderFreqFactor == "") OrderFreqFactor = 1;
		var OrderFreqInterval=mPiece(OrderFreqInfo, "^", 1);
		var OrderFreqDispTimeStr=mPiece(OrderFreqInfo, "^", 2);
		var OrderQtySum = "";
		if (OrderType == "R") {
			OrderDoseQty=OrderDoseQty.toString();
			var MulOrderDoseQty=0;
			if (OrderDoseQty.indexOf("-")>=0) {
				MulOrderDoseQty=1;
				var OneDayDoseQtySum=0;
				var OrdDoseQtyArry = new Array();
				for (var OrdDoseQtyIndex=0;OrdDoseQtyIndex<OrderDoseQty.split("-").length;OrdDoseQtyIndex++){
					var oneOrdDoseQty=OrderDoseQty.split("-")[OrdDoseQtyIndex];
					OrdDoseQtyArry[OrdDoseQtyIndex]=oneOrdDoseQty;
					OneDayDoseQtySum=parseFloat(OneDayDoseQtySum)+parseFloat(oneOrdDoseQty);
				}
				var FirstDayDoseQtySum=0;
				if (+OrderFirstDayTimes>0) {
					for (var FirstDayIndex=0;FirstDayIndex<OrderFirstDayTimes;FirstDayIndex++){
						var tmpindex=OrdDoseQtyArry.length-OrderFirstDayTimes+FirstDayIndex;
						FirstDayDoseQtySum=parseFloat(FirstDayDoseQtySum)+parseFloat(OrdDoseQtyArry[tmpindex]);
					}
				}else{
					FirstDayDoseQtySum=OneDayDoseQtySum;
				}
			}
			if (OrderFreqDispTimeStr!=""){
				var NumTimes = cspRunServerMethod(GlobalObj.GetCountByFreqDispTimeMethod, OrderFreqDispTimeStr, OrderStartDateStr, OrderDurFactor,OrderFirstDayTimes);
				OrderQtySum = parseFloat(OrderDoseQty) * parseFloat(NumTimes);
			}else{
				if ((OrderFreqInterval != "") && (OrderFreqInterval != null)) {
					var convert = Number(OrderDurFactor) / Number(OrderFreqInterval)
					var fact = (Number(OrderDurFactor)) % (Number(OrderFreqInterval));
					if (fact > 0) {
						fact = 1;
					} else {
						fact = 0;
					}
					OrderDurFactor = Math.floor(convert) + fact;
					//��Ƶ��OrderFreqFactorӦ�ö���1
					//OrderFreqFactor=1;
				}
				if (MulOrderDoseQty==1) {
					OrderQtySum=parseFloat(FirstDayDoseQtySum)+(parseFloat(OneDayDoseQtySum)*(parseFloat(OrderDurFactor)-1))
				}else{
					if((OrderFirstDayTimes>0)&&(GlobalObj.PAAdmType != "I")){
						NumTimes=parseFloat(OrderFreqFactor) * (parseFloat(OrderDurFactor)-1)+parseFloat(OrderFirstDayTimes);
					}else{
						NumTimes=parseFloat(OrderFreqFactor) * parseFloat(OrderDurFactor);
					}
					OrderQtySum = parseFloat(OrderDoseQty) * NumTimes;
				}
			}
			OrderQtySum = OrderQtySum.toFixed(4);
		} else {
			if ((OrderType == "L") && (OrderPackQty == "")) { OrderPackQty = 1 }
			OrderQtySum = OrderPackQty;
			var InciRowid = mPiece(OrderHiddenPara, String.fromCharCode(1), 10);
			if ((InciRowid=="")||(GlobalObj.PAAdmType == "I"))OrderPackQty = "";
		}
		return OrderQtySum+"^"+OrderPackQty;
	}
}
//ģ��ѡ��ҽ��
function addSelectedFav(value,text,callBackFun) {
	$("#z-q-container").hide();
	if (GlobalObj.warning != "") {
        $.messager.alert("����",GlobalObj.warning);
        return false;
    }
	new Promise(function(resolve,rejected){
		var OrderType = mPiece(value, String.fromCharCode(4), 0);
		if (OrderType =="ARCIM") {
			var itemrowidInfo = value.split(String.fromCharCode(4))[2];
			var reppartArr=itemrowidInfo.split("*");
	    	var itemid=reppartArr[0];
			CheckDiagnose(itemid,resolve);
		}else{
			resolve(true);
		}
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			if (!rtn) {
		        return false;
			}else{
				resolve();
			}
		});
	    
	}).then(function(){
		return new Promise(function(resolve,rejected){
			var itemrowidInfo = value.split(String.fromCharCode(4))[2];
			var reppartArr=itemrowidInfo.split("*");
	    	var itemid=reppartArr[0];
	    	var OrderType = mPiece(value, String.fromCharCode(4), 0);
			if (OrderType == "ARCIM") {
				GetItemDefaultRowId(itemid,resolve);
			}else{
				resolve();
			}
		});
	}).then(function(ItemDefaultRowId){
		return new Promise(function(resolve,rejected){
			var desc = "";
		    var selItmid = "";
		    var selItmDesc = "";
		    var selItmDur = "";
		    var isubcatcode = "";
		    var obj1 = "";
		    var objLinkedOrder = "";
		    var orderValue = "";
		    var orderType = "";
		    var bCanCopy = "";
		    var CatID = "";
		    var SubCatID = "";
		    var OrderType = "";
		    var setid = "";
		    //Log 48858 PeterC 31/03/05
		    var Freq = "";
		    var Dur = "";
		    var Priority = "";
		    var DosageQty = "";
		    var Status = "";
		    var ProcNote = "";
		    var PrescItemCats = "";

		    Freq = value.split(String.fromCharCode(4))[10];
		    Dur = value.split(String.fromCharCode(4))[11];
		    Priority = value.split(String.fromCharCode(4))[12];
		    DosageQty = value.split(String.fromCharCode(4))[13];
		    Status = value.split(String.fromCharCode(4))[14];
		    ProcNote = value.split(String.fromCharCode(4))[15];
		    //if(ProcNote!="") ProcNote=unescape(ProcNote);
		    if (ProcNote) {
			    //ģ��ǵ���ģʽʱ,valueƴ���и�group��������Ϣ����Ҫȥ��
			    ProcNote=ProcNote.split("#")[0];
			}
		    OrderType = mPiece(value, String.fromCharCode(4), 0);
		    isubcatcode = mPiece(value, String.fromCharCode(4), 8)
		    var itemrowidInfo = value.split(String.fromCharCode(4))[2];
		    if (OrderType == "ARCIM") {
			    var reppartArr=itemrowidInfo.split("*");
			    var itemid=reppartArr[0];
				var OrderBodyPartLabel="";
				if ((typeof reppartArr[1]!="undefined")&&(reppartArr[1]=="S")){
					OrderBodyPartLabel=reppartArr.slice(2).join("*");
				}
				
				var OrdParamsArr=new Array();
				OrdParamsArr[OrdParamsArr.length]={
					OrderARCIMRowid:itemid,
					ItemDefaultRowId:ItemDefaultRowId,
					OrderBodyPartLabel:OrderBodyPartLabel,
					OrderDepProcNote:ProcNote
				};
				new Promise(function(resolve,rejected){
					AddItemToList("",OrdParamsArr,"data","",resolve);
				}).then(function(RtnObj){
					var rowid=RtnObj.rowid;
					var returnValue=RtnObj.returnValue;
			        if (returnValue == false) {
			            //��յ�ǰ��
			            ClearRow(rowid);
			            if (callBackFun) callBackFun();
			            return;
			        }
					SetCellData(rowid, "OrdCateGoryRowId","");
					SetCellData(rowid, "OrdCateGory","");
					SetScreenSum();
			        CellFocusJumpAfterOrderName(rowid, OrderType);
			        if (callBackFun) callBackFun();
				})
		    } else {
		        //ҽ����
		        var itemid=itemrowidInfo;
		        OSItemListOpen(itemid, text, "YES", "", "");
		        //������ݳɹ��� ����Footer����
			    SetScreenSum();
			    if (callBackFun) callBackFun();
		    }
		 });
	})
}

/*******************************************
 *˵��:
 *�޸�һ�е�Ԫ�������Ƿ�ɲ���
 *ֻ���ڹ���ҽ������ʽ����
 * 
 ********************************************/

function ChangeCellsDisabledStyle(Row, Disabled) {
    /*var OrderPrior=GetCellData(Row,"OrderPrior");
    var OrderFreq=GetCellData(Row,"OrderFreq");
    var OrderDur=GetCellData(Row,"OrderDur");
    var OrderInstr=GetCellData(Row,"OrderInstr");
    var OrderStartDate=GetCellData(Row,"OrderStartDate");
    var OrderStartTime=GetCellData(Row,"OrderStartTime");
    var OrderEndDate=GetCellData(Row,"OrderEndDate");
    var OrderEndTime=GetCellData(Row,"OrderEndTime");
    var OrderMultiDate=GetCellData(Row,"OrderMultiDate");
    var OrderFirstDayTimes=GetCellData(Row,"OrderFirstDayTimes");
    var OrderBodyPart=GetCellData(Row,"OrderBodyPart");
    var OrderStage=GetCellData(Row,"OrderStage");
    var OrderSpeedFlowRate=GetCellData(Row,"OrderSpeedFlowRate");
    var OrderFlowRateUnit=GetCellData(Row,"OrderFlowRateUnit");
    var OrderDate=GetCellData(Row,"OrderDate");
    var OrderTime=GetCellData(Row,"OrderTime");
    var OrderNeedPIVAFlag=GetCellData(Row,"OrderNeedPIVAFlag");*/
    var OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
    var OrderSkinTest=GetCellData(Row,"OrderSkinTest");
    var OrderSkinTestabled = "";
    var OrderActiontabled = ""
    var OrderHiddenPara = GetCellData(Row, "OrderHiddenPara");
    var NeedSkinTestINCI = mPiece(OrderHiddenPara, String.fromCharCode(1), 7);
    if ((OrderPriorRowid == GlobalObj.ShortOrderPriorRowid)||((OrderPriorRowid == GlobalObj.LongOrderPriorRowid)&&(GlobalObj.CFSkinTestPriorShort == 0))) {
        var OrderActiontabled = true;
        if ((NeedSkinTestINCI=="Y")||(GlobalObj.DisableOrdSkinChange=="1")){
	        var OrderActiontabled = false
        	var OrderSkinTestabled = false;
        }else{
	    	var OrderSkinTestabled = true;
	    }
        
    } else {
        var OrderSkinTestabled = false;
        var OrderActiontabled = false;
    }
    var OrderActionRowid=GetCellData(Row, "OrderActionRowid"); 
    if (OrderActionRowid!=""){
	    var OrderSkinTestabled = false;
	}
	if (GlobalObj.SkinTestInstr != "") {
	    var OrderInstrRowid = GetCellData(Row, "OrderInstrRowid");
	    var Instr = "^" + OrderInstrRowid + "^";
	    if ((GlobalObj.SkinTestInstr.indexOf(Instr) != "-1")) {  
	    	var OrderActiontabled = false;
	    }
    }
    //��ѡ��"����"��¼���ҽ��Ƥ�Ա�ע���ɱ༭
    var OrderActionRowid=GetCellData(Row, "OrderActionRowid");
    var StyleConfigStr = GetCellData(Row, "StyleConfigStr");
    var StyleConfigObj = {};
    if (StyleConfigStr != "") {
        StyleConfigObj = eval("(" + StyleConfigStr + ")");
    }
    var OrderActionCode = GetOrderActionCode(OrderActionRowid);
	if ((OrderActionCode=="TM")&&(!StyleConfigObj.OrderAction)) {
		var OrderActiontabled = false;
	}
	var OrderType = GetCellData(Row, "OrderType");
	if (OrderType !="R") {
		OrderSkinTestabled=false;
		OrderActiontabled = false;
	}
    var OrderRecDeptabled = true;
    if ((GlobalObj.CFSameRecDepForGroup == 1) && (Disabled == false)) {
        OrderRecDeptabled = Disabled;
    }
    //��ҽ���Ǿ�����տ���,����ҽ���Ľ��տ���һ��
    var SubOrderRecDepRowid=GetCellData(Row, "OrderRecDepRowid");
    var OrderType=GetCellData(Row, "OrderType");
    if ((Disabled == false)&&(GlobalObj.IPDosingRecLocStr != "")&&(OrderType == "R")) {
	    if (("^" + GlobalObj.IPDosingRecLocStr + "^").indexOf("^" + SubOrderRecDepRowid + "^") >= 0) {
		    OrderRecDeptabled = Disabled;
		}
	}  
    var OrderDurabled=Disabled;
    if (GlobalObj.PAAdmType == "I") {
	    if ((OrderPriorRowid != GlobalObj.OutOrderPriorRowid)&&(Disabled==true)) {
		    OrderDurabled=false;
		}
	}
    var obj = {
        OrderPrior: Disabled,
        OrderFreq: Disabled,
        OrderDur: OrderDurabled,
        OrderInstr: Disabled,
        OrderSkinTest: OrderSkinTestabled,
        OrderStartDate: Disabled,
        OrderEndDate: Disabled,
        OrderMultiDate: Disabled,
        OrderFirstDayTimes: Disabled,
        OrderBodyPart: Disabled,
        OrderStage: Disabled,
        OrderSpeedFlowRate: Disabled,
        OrderDate: Disabled,
        OrderTime: Disabled,
        OrderNeedPIVAFlag: Disabled,
        OrderFlowRateUnit: Disabled,
        OrderAction: OrderActiontabled,
        OrderRecDep: OrderRecDeptabled,
        ExceedReason:Disabled,
        OrderLocalInfusionQty: Disabled,
        OrderDoc:Disabled,
        OrderOperation:Disabled
    }
    if (OrderPriorRowid != GlobalObj.ShortOrderPriorRowid) {
		// ����ʱҽ���Ӽ����ɹ�ѡ
        SetCellChecked(Row, "Urgent", false);
        $.extend(obj, { Urgent: false });
	}else{
		var OrderHiddenPara=GetCellData(Row,"OrderHiddenPara");
	    var EmergencyFlag = mPiece(OrderHiddenPara, String.fromCharCode(1), 25);
	    var ARCIMDefSensitive = mPiece(OrderHiddenPara, String.fromCharCode(1), 26);
	    if (EmergencyFlag =="Y") {
        	$.extend(obj, { Urgent: true });
		}
		if (ARCIMDefSensitive =="Y") SetCellChecked(Row, "Urgent", true);
	}
    ChangeCellDisable(Row, obj);
    /*
    var oldRowDisableStr=GetCellData(Row,"RowDisableStr");
    if(oldRowDisableStr !=""){
        var oldObj=eval("("+oldRowDisableStr+")");
        $.extend(oldObj,obj);
        var RowDisableStr = JSON.stringify(oldObj);
        SetCellData(Row,"RowDisableStr",RowDisableStr);
    }else{
        var RowDisableStr = JSON.stringify(obj);
        SetCellData(Row,"RowDisableStr",RowDisableStr); 
    }
    */
}
function GetReclocByInstr(Row) {
    //�÷�������տ���
    var InstrReclocStr = "";
    var OrderInstrRowid = GetCellData(Row, "OrderInstrRowid");
    var InstrOrderType = GetCellData(Row, "OrderType");
    var OrderHiddenPara = GetCellData(Row, "OrderHiddenPara");
    var OrderItemCatRowid = mPiece(OrderHiddenPara, String.fromCharCode(1), 2);
    var InstrPriorRowid = GetCellData(Row, "OrderPriorRowid");
    var OrderPriorRemarks = GetCellData(Row, "OrderPriorRemarksRowId");
    var InstrPriorRowid=ReSetOrderPriorRowid(InstrPriorRowid, OrderPriorRemarks);
    var PreInstrRecLocStr = GetCellData(Row, "OrderRecLocStr");
    if ((InstrOrderType == "R") && (GlobalObj.ReclocByInstr == "1") && (GlobalObj.GetInstrReclocMethod != "")) {
        var OrdDept = GetLogonLocByFlag();
        var HOSPID = session['LOGON.HOSPID'];
        var InstrReclocStr = cspRunServerMethod(GlobalObj.GetInstrReclocMethod, GlobalObj.EpisodeID, OrderInstrRowid, OrdDept, OrderItemCatRowid, InstrPriorRowid, "", HOSPID) //PreInstrRecLocStr
    }
    // if (InstrReclocStr != "") { return InstrReclocStr; } else { return PreInstrRecLocStr; }
    return InstrReclocStr+"^"+PreInstrRecLocStr;
}
function SetPackQty(Row,SetPackQtyConfig) {
	var SetPackQtyConfigObj=$.extend({
			IsNotChangeFirstDayTimeFlag:"",
			IsNotNeedChangeFlag:""
	},SetPackQtyConfig);
	var OrderType = GetCellData(Row, "OrderType");
	var OrderNeedPIVAFlag = GetCellData(Row, "OrderNeedPIVAFlag");
	var OrderRecDepRowid = GetCellData(Row, "OrderRecDepRowid")
	/*
    if ((GlobalObj.IPDosingRecLocStr != "")&&(OrderType == "R")&&(OrderNeedPIVAFlag=="Y")) {
	    if (("^" + GlobalObj.IPDosingRecLocStr + "^").indexOf("^" + OrderRecDepRowid + "^") >= 0) {
			return true;
		}
	}
	*/
	var OrderPackQty = GetCellData(Row, "OrderPackQty");
	//tanjishan ��������Һ����ʱҽ���������װ��ҩ�ȹ���
	if (($("#" + Row + "_OrderPackQty").attr("disabled")=="disabled")&&(OrderPackQty=="")){
		///2020.03.12��Ȼ����Ҫ�������������ǵ��μ����ĸı仹����Ҫ������
		//return true;
		$.extend(SetPackQtyConfigObj, { IsNotNeedChangeFlag: "Y"});
	}	
	/*if ((GlobalObj.PAAdmType!="I")&&(PageLogicObj.m_AddItemToListMethod == "ARCOS")){ 
		$.extend(SetPackQtyConfigObj, { IsNotNeedChangeFlag: "Y"});
	}*/
    var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
    if (OrderARCIMRowid == "") return true;
    
    var OrderType = GetCellData(Row, "OrderType");
    var OrderConFac = GetCellData(Row, "OrderConFac");
    var OrderPrice = GetCellData(Row, "OrderPrice");
    OrderPrice = OrderPrice.replace(/(^\s*)|(\s*$)/g, '');
    //if (OrderPrice=="") OrderPrice=0;
    var retPrice = GetRecPrice(Row)
    if (retPrice==undefined) retPrice="0^0^0^0^0";
    var ArrPrice = retPrice.split("^");
    var Price = ArrPrice[0];
    if ((OrderPrice == "") && ((Price = "") || (Price >= 0))) OrderPrice = 0;
    
    if(SetPackQtyConfigObj.IsNotChangeFirstDayTimeFlag!="Y") SetOrderFirstDayTimes(Row);
    var OrderFirstDayTimes=GetCellData(Row,"OrderFirstDayTimes");
	//if(OrderFirstDayTimes=="")OrderFirstDayTimes=0; //2021-02-22�ᵼ�������������
	//OrderFirstDayTimes=parseFloat(OrderFirstDayTimes);
	
    var OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
	var OrderDoseQty = GetCellData(Row, "OrderDoseQty");
	var OrderDoseUOMRowid = GetCellData(Row, "OrderDoseUOMRowid");
	var OrderFreqRowid = GetCellData(Row, "OrderFreqRowid");
	var OrderDurRowid = GetCellData(Row, "OrderDurRowid");
	var OrderPackQty = GetCellData(Row, "OrderPackQty");
	var OrderPackUOMRowid = GetCellData(Row, "OrderPackUOMRowid");
    var OrderStartDate = GetCellData(Row, "OrderStartDate");
    var OrderMultiDate = GetCellData(Row, "OrderMultiDate");
    var OrderPriorRemarks = GetCellData(Row, "OrderPriorRemarksRowId");
	var PriorRowid = ReSetOrderPriorRowid(OrderPriorRowid, OrderPriorRemarks);
	var LinkedMasterOrderPriorRowid="";
	if ((VerifiedOrderObj) && (VerifiedOrderObj.LinkedMasterOrderPriorRowid != "undefined") && (VerifiedOrderObj.LinkedMasterOrderPriorRowid != "")) {
		LinkedMasterOrderPriorRowid=VerifiedOrderObj.LinkedMasterOrderPriorRowid;
	}
	var OrderFreqDispTimeStr= GetCellData(Row, "OrderFreqDispTimeStr");
	var OrderARCOSRowid= GetCellData(Row, "OrderARCOSRowid");
	/*
	//pb by tanjishan 20200514Ϊʲôҽ���׿�����ҽ������������������ʱ����
	if ((OrderARCOSRowid!="")&&(+OrderPackQty!=0)){
		$.extend(SetPackQtyConfigObj, { IsNotNeedChangeFlag: "Y"});
	}
	*/
	var OrderFreqTimeDoseStr= GetCellData(Row, "OrderFreqTimeDoseStr");
	var OrderRecDepRowid= GetCellData(Row, "OrderRecDepRowid");
	var SessionStr = GetSessionStr();
	var OrderMasterARCIMRowid="";
	var OrderMasterSeqNo = GetCellData(Row, "OrderMasterSeqNo");
	if (OrderMasterSeqNo!=""){
		var rowids = GetAllRowId();
        for (var i = 0; i < rowids.length; i++) {
			var OrderSeqNo = GetCellData(rowids[i], "id")
            var OrderSeqNoMasterLink = GetCellData(rowids[i], "id");
            if (OrderSeqNoMasterLink == OrderMasterSeqNo) {
            	OrderMasterARCIMRowid=GetCellData(rowids[i], "OrderARCIMRowid");
            	break;
            }
        }
	}
    /*��̨��ȡ�������������������ȼ���ֵ*/
	var OrdParamObj={
		EpisodeID:GlobalObj.EpisodeID,
		OrderPriorRowid:PriorRowid,
		OrderARCIMRowid:OrderARCIMRowid,
		OrderDoseQty:OrderDoseQty,
		OrderDoseUOMRowid:OrderDoseUOMRowid,
		OrderFreqRowid:OrderFreqRowid,
		OrderDurRowid:OrderDurRowid,
		OrderPackQty:OrderPackQty,
		OrderPackUOMRowid:OrderPackUOMRowid,
		OrderStartDate:OrderStartDate,
		OrderMultiDate:OrderMultiDate,
		OrderPrice:OrderPrice,
		LinkedMasterOrderPriorRowid:LinkedMasterOrderPriorRowid,
		OrderFreqDispTimeStr:OrderFreqDispTimeStr,
		OrderFirstDayTimes:OrderFirstDayTimes,
		IsNotChangeFirstDayTimeFlag:SetPackQtyConfigObj.IsNotChangeFirstDayTimeFlag,
		IsNotNeedChangeFlag:SetPackQtyConfigObj.IsNotNeedChangeFlag,
		OrderFreqTimeDoseStr:OrderFreqTimeDoseStr,
		
		OrderRecDepRowid:OrderRecDepRowid,
		SessionStr:SessionStr,
		OrderMasterARCIMRowid:OrderMasterARCIMRowid
	};
	
	var OrdParamJson=JSON.stringify(OrdParamObj);
	var CalPackQtyJson = cspRunServerMethod(GlobalObj.CalPackQtyMethod,OrdParamJson);
	var CalPackQtyObj=jQuery.parseJSON(CalPackQtyJson);
	//�������������ǰ̨�ű�����
	if ((typeof CalPackQtyObj.CallBackFunStr !="undefined")&&(CalPackQtyObj.CallBackFunStr !="")){
		var CallBackFunArr=CalPackQtyObj.CallBackFunStr.split(String.fromCharCode(2));
		for (var i = 0; i < CallBackFunArr.length; i++) {
			var SingleCallBackFun=CallBackFunArr[i];
			if (SingleCallBackFun==""){continue;}
			var CallBakFunCode=mPiece(SingleCallBackFun,"^",0)
			var CallBakFunParams=mPiece(SingleCallBackFun,"^",1)
			if (CallBakFunCode=="ReSetPackQty1"){
				var CallBakFunParamsArr=CallBakFunParams.split(";");
				if (dhcsys_confirm(CallBakFunParamsArr[0], false)) {
					var PackQty=CallBakFunParamsArr[1];
					var OrderSum=CallBakFunParamsArr[2];
					$.extend(CalPackQtyObj, { OrderPackQty: PackQty,OrderSum:OrderSum});
				}
			}else if (CallBakFunCode=="ReSetPackQty2"){
				var CallBakFunParamsArr=CallBakFunParams.split(";");
				if (dhcsys_confirm(CallBakFunParamsArr[0], false)) {
					var PackQty=CallBakFunParamsArr[1];
					var OrderSum=CallBakFunParamsArr[2];
					var BaseDoseQty=CallBakFunParamsArr[3];
					var BaseDoseQtySum=CallBakFunParamsArr[4];
					$.extend(CalPackQtyObj, { OrderPackQty: PackQty,OrderSum:OrderSum,OrderBaseQty:BaseDoseQty,OrderBaseQtySum:BaseDoseQtySum});
				}
			}
		}
	}
	if (typeof CalPackQtyObj.OrderPackQty !="undefined"){
		SetCellData(Row, "OrderPackQty", CalPackQtyObj.OrderPackQty);
	}
	if (typeof CalPackQtyObj.OrderBaseQty !="undefined"){
		SetCellData(Row, "OrderBaseQty", CalPackQtyObj.OrderBaseQty);
	}
	if (typeof CalPackQtyObj.OrderBaseQtySum !="undefined"){
		SetCellData(Row, "OrderBaseQtySum", CalPackQtyObj.OrderBaseQtySum);
	}
	if (typeof CalPackQtyObj.OrderSum !="undefined"){
		SetCellData(Row, "OrderSum", CalPackQtyObj.OrderSum);
	}
    //������Һ����
    SetOrderLocalInfusionQty(Row);
	//�����������
	SetOrderUsableDays(Row);
    CheckFreqAndPackQty(Row);
    if (PageLogicObj.m_AddItemToListMethod != "ARCOS") SetScreenSum();
	//��Ҫ�ڴ˴���,һ��Ҫ�ж�ҽ���ף����򽫻ᵼ��������Խ��Խ��
	//SetScreenSum();
    return true;
}
function SetOrderLocalInfusionQty(Row) {
	var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
    var OrderFreqRowid = GetCellData(Row, "OrderFreqRowid");
    var OrderDurRowid = GetCellData(Row, "OrderDurRowid");
    var OrderInstrRowid = GetCellData(Row, "OrderInstrRowid");
	var OrderFirstDayTimes=GetCellData(Row, "OrderFirstDayTimes");
	var OrderFreqDispTimeStr=GetCellData(Row, "OrderFreqDispTimeStr");
	var OrderStartDateStr = GetCellData(Row, "OrderStartDate");
    var OrderStartDate = "";
    if (OrderStartDateStr != "") {
        OrderStartDate = OrderStartDateStr.split(" ")[0];
    }
	var InfusionQty = cspRunServerMethod(GlobalObj.GetOrderLocalInfusionQtyMethod,OrderARCIMRowid, OrderFreqRowid, OrderInstrRowid, OrderDurRowid,OrderFirstDayTimes,OrderFreqDispTimeStr,OrderStartDate);
	SetCellData(Row, "OrderLocalInfusionQty", InfusionQty);
}
function SetOrderUsableDays(Row) {
	var OrderVirtualtLong=GetCellData(Row, "OrderVirtualtLong");
	if (OrderVirtualtLong=="Y"){
		SetCellData(Row, "OrderUsableDays", "");
		return;
	}
	var OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
	if (GlobalObj.PAAdmType=="I"){
        if (OrderPriorRowid != GlobalObj.OutOrderPriorRowid) {
            SetCellData(Row, "OrderUsableDays", "");
			return;
        }
	}
    if (GlobalObj.CalcDurByArcimMethod == "") return;
    var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
    var OrderFreqRowid = GetCellData(Row, "OrderFreqRowid");
    var OrderDurRowid = GetCellData(Row, "OrderDurRowid");
    var OrderPackQty = GetCellData(Row, "OrderPackQty");
    if (OrderPackQty == "") return;
    var OrderDoseQty = GetCellData(Row, "OrderDoseQty");
    var OrderDoseUOMRowid = GetCellData(Row, "OrderDoseUOMRowid");
    var OrderPackUOMRowid = GetCellData(Row, "OrderPackUOMRowid");
    var OrderFreqDispTimeStr = GetCellData(Row, "OrderFreqDispTimeStr");
	var OrderFreqTimeDoseStr= GetCellData(Row, "OrderFreqTimeDoseStr");
    var OrderHiddenPara=GetCellData(Row, "OrderHiddenPara");
    var SameFreqDifferentDosesFlag=OrderHiddenPara.split(String.fromCharCode(1))[19];
    if ((OrderFreqTimeDoseStr!="")&&(SameFreqDifferentDosesFlag=="Y")) OrderDoseQty="";
    var UsableDays = cspRunServerMethod(GlobalObj.CalcDurByArcimMethod, OrderARCIMRowid, OrderFreqRowid, OrderDurRowid, OrderPackQty, OrderDoseQty, OrderDoseUOMRowid, OrderPackUOMRowid, OrderFreqDispTimeStr,OrderFreqTimeDoseStr);
    var OrderType = GetCellData(Row, "OrderDoseUOMRowid");
    if ((OrderType != "R") && (UsableDays == "0")) {
        UsableDays = ""
    }
    SetCellData(Row, "OrderUsableDays", UsableDays);
}
//���Ƶ�κ�����װ�����Ƿ�Ӧ���ǿ��õ�
function CheckFreqAndPackQty(Row) {
    var RowStyleObj = {};
    var OrderType = GetCellData(Row, "OrderType");
    var IdPackQty = Row + "_" + "OrderPackQty"
    var objPackQty = document.getElementById(IdPackQty);
    var IdOrderFreq = Row + "_" + "OrderFreq"
    var objFreq = document.getElementById(IdOrderFreq);
    var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
    var OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
    /*
    if (OrderPriorRowid==GlobalObj.LongOrderPriorRowid){
        if (objFreq){
            var obj={OrderPackQty:false}
            $.extend(RowStyleObj,obj);
        }   
    }
    */
    //Сʱҽ��
    var HourFlag = cspRunServerMethod(GlobalObj.IsHourItem, OrderARCIMRowid);
    if (HourFlag == "1") {
	    if (GlobalObj.AllowHourOrdUsePrn !=1) {
	        //Сʱҽ������¼��Ƶ��
	        var obj = { OrderFreq: false }
	        $.extend(RowStyleObj, obj);
	        ClearOrderFreq(Row);
        }
        if (OrderPriorRowid == GlobalObj.LongOrderPriorRowid) {
            //Сʱҽ�������ڵ�Ҳ����¼������
            var obj = { OrderPackQty: false }
            $.extend(RowStyleObj, obj);
        }
    }
    //��ֵ����
    if (GlobalObj.HighValueControl == 1) {
        //var IncItmHighValueFlag = cspRunServerMethod(GlobalObj.GetIncItmHighValueFlag, OrderARCIMRowid)
        var OrderHiddenPara = GetCellData(Row, "OrderHiddenPara");
        var IncItmHighValueFlag = mPiece(OrderHiddenPara, String.fromCharCode(1), 9);
        var OrderMaterialBarCode = GetCellData(Row, "OrderMaterialBarcodeHiden");
        if (IncItmHighValueFlag == "Y") {
            //��ֵ����Ϊ1���ɸ�
            SetCellData(Row, "OrderPackQty", 1);
            //��ֵҽ������¼��Ƶ��
            SetCellData(Row, "OrderFreq", "");
            SetCellData(Row, "OrderFreqRowid", "");
            SetCellData(Row, "OrderFreqFactor", 1);
            //���μ���
            SetCellData(Row, "OrderDoseQty", "");
            //�Ƴ�
            SetCellData(Row, "OrderDur", "");
            SetCellData(Row, "OrderDurRowid", "");
            SetCellData(Row, "OrderDurFactor", 1);
            var obj = { OrderPackQty: false, OrderFreq: false, OrderDoseQty: false, OrderDur: false }
            $.extend(RowStyleObj, obj);
        }
    }
    //�����鵥�μ���������д
    var ItemServiceFlag = cspRunServerMethod(GlobalObj.GetItemServiceFlagMethod, OrderARCIMRowid);
    if ((ItemServiceFlag == "1") || (OrderType == "L")) {
        var obj = { OrderDoseQty: false }
        $.extend(RowStyleObj, obj);

    }
    //ChangeCellDisable(Row,RowStyleObj);
    ChangeRowStyle(Row, RowStyleObj);
}
function ChangeLinkOrderPrior(OrderSeqNo, OrderPriorRowid, OrderStartDate, OrderStartTime, OrderPrior) {
    try {
        var rows = $('#Order_DataGrid').getDataIDs();
        for (var i = 0; i < rows.length; i++) {
            var Row = rows[i];
            var OrderMasterSeqNo = GetCellData(Row, "OrderMasterSeqNo");
            var OrderItemRowid = GetCellData(Row, "OrderItemRowid");
            var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
            var OrderType = GetCellData(Row, "OrderType");
            if ((OrderARCIMRowid != "") && (OrderItemRowid == "") && (OrderMasterSeqNo == OrderSeqNo)) {
                var OldOrderPriorRowid = GetCellData("OrderPriorRowid", Row)
                var obj = document.getElementById(Row + "_OrderPrior");
                if (GlobalObj.OrderPriorContrlConfig == 1) {
                    var Obj = "";
                    if ($.isNumeric(Row) == true) {
                        Obj = document.getElementById(Row + "_OrderPrior");
                    } else {
                        Obj = document.getElementById("OrderPrior");
                    }
                    ClearAllList(Obj);
                    if ((OrderPriorRowid == GlobalObj.LongOrderPriorRowid)) {
                        //ֻ�г���
                        Obj.options[Obj.length] = new Option("����ҽ��", GlobalObj.LongOrderPriorRowid);
                        SetCellData(Row, "OrderPriorStr", GlobalObj.LongOrderPriorRowid + ":" + "����ҽ��");
                    }
                    if ((OrderPriorRowid == GlobalObj.ShortOrderPriorRowid)) {
                        //ֻ����ʱ
                        Obj.options[Obj.length] = new Option("��ʱҽ��", GlobalObj.ShortOrderPriorRowid);
                        SetCellData(Row, "OrderPriorStr", GlobalObj.ShortOrderPriorRowid + ":" + "��ʱҽ��");
                    }
                    if ((OrderPriorRowid == GlobalObj.OutOrderPriorRowid)) {
                        //��Ժ��ҩ
                        Obj.options[Obj.length] = new Option("��Ժ��ҩ", GlobalObj.OutOrderPriorRowid);
                        SetCellData(Row, "OrderPriorStr", GlobalObj.OutOrderPriorRowid + ":" + "��Ժ��ҩ");
                    }

                }
                if (obj) {
                    //�ɱ༭״̬
                    SetCellData(Row, "OrderPrior", OrderPriorRowid);
                    SetCellData(Row, "OrderPriorRowid", OrderPriorRowid);
                } else {
                    SetCellData(Row, "OrderPrior", OrderPrior);
                    SetCellData(Row, "OrderPriorRowid", OrderPriorRowid);
                }
                OrderPriorchangeCommon(Row,OldOrderPriorRowid,OrderPriorRowid);
                if (OrderStartDate != "" && OrderStartTime != "") {
                    SetCellData(Row, "OrderStartDate", OrderStartDate + " " + OrderStartTime);
                }
            }
        }
    } catch (e) { $.messager.alert("����", e.message) }
}
function ChangeLinkOrderFreq(OrderSeqNo,OrderPriorRowid,OrderPrior,OrderFreqRowid,OrderFreq,OrderFreqFactor,OrderFreqInterval,OrderFreqDispTimeStr,OrderStartDateStr,callBackFun) {
	var rows = $('#Order_DataGrid').getDataIDs();
	new Promise(function(resolve,rejected){
		(function(callBackFun){
			function loop(i){
				new Promise(function(resolve,rejected){
					var Row = rows[i];
		            var OrderMasterSeqNo = GetCellData(Row, "OrderMasterSeqNo");
		            var OrderItemRowid = GetCellData(Row, "OrderItemRowid");
		            var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
		            var OrderType = GetCellData(Row, "OrderType");
		            if ((OrderARCIMRowid != "") && (OrderItemRowid == "") && (OrderMasterSeqNo == OrderSeqNo) && (OrderMasterSeqNo != "")) {
			        	var OldOrderFreqRowid=GetCellData(Row, "OrderFreqRowid");
		                SetCellData(Row, "OrderFreq", OrderFreq);
		                SetCellData(Row, "OrderFreqRowid", OrderFreqRowid);
		                SetCellData(Row, "OrderFreqFactor", OrderFreqFactor);
		                SetCellData(Row, "OrderFreqInterval", OrderFreqInterval);
		                SetCellData(Row, "OrderFreqDispTimeStr", OrderFreqDispTimeStr);
		                var OldOrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
		                if (OrderPriorRowid != "") {
		                    var obj = document.getElementById(Row + "_OrderPrior");
		                    if (obj) {
		                        //�ɱ༭״̬
		                        SetCellData(Row, "OrderPrior", OrderPriorRowid);
		                        SetCellData(Row, "OrderPriorRowid", OrderPriorRowid);
		                    } else {
		                        SetCellData(Row, "OrderPrior", OrderPrior);
		                        SetCellData(Row, "OrderPriorRowid", OrderPriorRowid);
		                    }
		                }
		                OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
				        (function(callBackFunExec){
					        new Promise(function(resolve,rejected){
						        if (OldOrderPriorRowid != OrderPriorRowid) {
							        OrderPriorchangeCommon(Row,OldOrderPriorRowid,OrderPriorRowid,resolve);
							    }else {
								    resolve();
								}
						    }).then(function(){
							    return new Promise(function(resolve,rejected){
								    var Row = rows[i];
								    if (OrderStartDateStr != "") {
					                    SetCellData(Row, "OrderStartDate", OrderStartDateStr);
					                }
					                if (OldOrderFreqRowid!=OrderFreqFactor) {
						                ChangeOrderFreqTimeDoseStr(Row,resolve);
						            }else{
							            resolve();
							        }
						        })
							}).then(function(){
								var Row = rows[i];
						        //Ƶ��->�Ƴ̼��
				                FreqDurChange(Row)
				                SetPackQty(Row);
				                callBackFunExec();
							})
					        
					    })(resolve);
			        }else{
				        resolve();
				    }
				}).then(function(){
					i++;
					if ( i < rows.length ) {
						 loop(i);
					}else{
						callBackFun();
					}
				})
			}
			loop(0)
		})(resolve);
	}).then(function(){
		if (callBackFun) callBackFun();
	})
}

function ChangeLinkOrderInstr(OrderSeqNo, OrderInstrRowid, OrderInstr) {
    try {
	    var Count=0;
        var rows = $('#Order_DataGrid').getDataIDs();
        for (var i = 0; i < rows.length; i++) {
            var Row = rows[i];
            var OrderMasterSeqNo = GetCellData(Row, "OrderMasterSeqNo");
            var OrderItemRowid = GetCellData(Row, "OrderItemRowid");
            var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
            var OrderType = GetCellData(Row, "OrderType");
            if ((OrderARCIMRowid != "") && (OrderItemRowid == "") && (OrderMasterSeqNo != "") && (OrderMasterSeqNo == OrderSeqNo)) {
                var InstrRowId = GetCellData(Row, "OrderInstrRowid");
                Count=Count+1;
                if (!IsNotFollowInstr(InstrRowId)) {
                    SetCellData(Row, "OrderInstr", OrderInstr);
                    SetCellData(Row, "OrderInstrRowid", OrderInstrRowid);
                    var OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
                    var OrdOutPriorRecLocStr=GetCellData(Row, "OrderOutPriorRecLocStr");
        			if ((OrderPriorRowid==GlobalObj.OutOrderPriorRowid)&&(OrdOutPriorRecLocStr!="")) {
	        		}else{
		        		/* //�÷�������տ���,δ�����÷����տ���,��ȡԭ���տ��Ҵ�
	                    var InstrReclocStr = GetReclocByInstr(Row);
	                    var OrderRecLocStr = GetRecLocStrByPrior(InstrReclocStr, OrderPriorRowid);
	                    SetColumnList(Row, "OrderRecDep", OrderRecLocStr);
	                    OrderRecDepChangeCom(Row);*/ 
	                    // �÷�������տ���,δ�����÷����տ���,�򲻽��д���
	                    var OldOrderRecDepRowid=GetCellData(Row, "OrderRecDepRowid");
	                    var newReclocStr = GetReclocByInstr(Row);
	                    var InstrReclocStr=newReclocStr.split("^")[0];
	                     var OrderRecLocStr=newReclocStr.split("^")[1];
	                    if (InstrReclocStr!="") {
		                    var OrderRecLocStr = GetRecLocStrByPrior(InstrReclocStr, OrderPriorRowid);
		                }else{
							var OrderRecLocStr = GetRecLocStrByPrior(OrderRecLocStr, OrderPriorRowid);
						}
						SetColumnList(Row, "OrderRecDep", OrderRecLocStr);
						if (InstrReclocStr=="") {
							RestoreChangeRecLoc(Row,OldOrderRecDepRowid,OrderRecLocStr);
						}
		                OrderRecDepChangeCom(Row);
		        	}                    
                    //���������� 
                    //PHCINDesc_lookuphandlerX(Row); 
                    SetPackQty(Row);
                }
                var InstrRowId = GetCellData(Row, "OrderInstrRowid");
                if (IsWYInstr(InstrRowId)) {
                    if (GlobalObj.PAAdmType != "I") {
                        SetCellData(Row, "OrderDoseQty", "");
                        SetCellData(Row, "OrderDur", "");
                        SetCellData(Row, "OrderDurRowid", "");
                        SetCellData(Row, "OrderDurFactor", "");
                    }
                }
                var OrderType = GetCellData(Row, "OrderType");
                //��ҽ���÷�ΪƤ���÷�
                var OrderHiddenPara = GetCellData(Row, "OrderHiddenPara");
    			var NeedSkinTestINCI = mPiece(OrderHiddenPara, String.fromCharCode(1), 7);
                if (GlobalObj.SkinTestInstr != "") {
	                var Instr = "^" + InstrRowId + "^";
	                if ((GlobalObj.SkinTestInstr.indexOf(Instr) != "-1")&&(OrderType =="R")) {  //&&(NeedSkinTestINCI=="Y")
		                /*var ActionRowid=GetCellData(Row, "OrderActionRowid");
		                var ActionCode = GetOrderActionCode(ActionRowid);
		                if ((ActionCode=="YY")||(ActionCode=="")){
		                    SetCellData(Row, "OrderSkinTest", true);
		                }
		                var styleConfigObj = { OrderSkinTest: false, OrderAction: true }
		                ChangeCellDisable(Row, styleConfigObj);*/
		                SetCellData(Row, "OrderActionRowid","");
		                SetCellData(Row, "OrderAction","");
		                //����ǳ���ҽ����Ƥ���÷���ֻ����ҽ���ĵ�һ����Ƥ�Թ�ѡ
		                if (Count==1){
		                	SetCellData(Row, "OrderSkinTest", true);
		                }else{
			            	SetCellData(Row, "OrderSkinTest", false);   
			            }
		                
	                	//OrderSkinTest���Ա༭,��Ҫ�ǳ���ҽ����Ҫҽ���ֹ�ѡ����ý��Ƥ�Ա�ʶ
		                var styleConfigObj = { OrderSkinTest: true, OrderAction: false }
		                ChangeCellDisable(Row, styleConfigObj);
		            }else {
		                var ActionRowid=GetCellData(Row, "OrderActionRowid");
		                var ActionCode = GetOrderActionCode(ActionRowid);
		                if ((NeedSkinTestINCI=="Y")||(ActionCode!="")){
			                var styleConfigObj={OrderSkinTest:false,OrderAction:true}
			            }else if (OrderType =="R"){
				            var styleConfigObj={OrderSkinTest:true,OrderAction:true}
				        }
		                ChangeCellDisable(Row,styleConfigObj);
		            }
	            }
            }
        }
    } catch (e) { $.messager.alert("����", e.message) }
}
//��ʼ����ʱ��ı�
function OEORISttDatchangehandler(e) {
    var Row = GetEventRow(e)
    var OrderStartDateStr = GetCellData(Row, "OrderStartDate");
    OEORISttDat_lookupSelect(Row, OrderStartDateStr);
    SetOrderFirstDayTimes(Row);
    $("#"+Row+"_OrderStartDate").parent()[0].title=OrderStartDateStr;
	//�޸Ŀ�ʼ���ڼ�������
	SetPackQty(Row);
}
function OEORISttDat_lookupSelect(Row, OrderStartDateStr) {
    var OrderSeqNo = GetCellData(Row, "id");
    ChangeLinkOrderStartDate(OrderSeqNo, OrderStartDateStr)
}
function ChangeLinkOrderStartDate(OrderSeqNo, OrderStartDateStr) {
    var rows = $('#Order_DataGrid').getDataIDs();
    for (var i = 0; i < rows.length; i++) {
        var Row = rows[i];
        var OrderMasterSeqNo = GetCellData(Row, "OrderMasterSeqNo");
        var OrderItemRowid = GetCellData(Row, "OrderItemRowid");
        var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
        if ((OrderARCIMRowid != "") && (OrderItemRowid == "") && (OrderMasterSeqNo == OrderSeqNo)) {
            SetCellData(Row, "OrderStartDate", OrderStartDateStr);
            SetOrderFirstDayTimes(Row);
            if (GetEditStatus(Row) == true) {
            	$("#"+Row+"_OrderStartDate").parent()[0].title=OrderStartDateStr;
            }
			//�޸Ŀ�ʼ���ڼ�������
			SetPackQty(Row);
        }
    }
}
//Ƥ�Ըı��¼�
function OrderSkinTestChangehandler(e) {
    var ActionRowid = "";
    var Row = GetEventRow(e);
    var OrderHiddenPara = GetCellData(Row, "OrderHiddenPara");
    var eSrc = websys_getSrcElement(e);
    var SkinTestYY = mPiece(OrderHiddenPara, String.fromCharCode(1), 0);
    if (eSrc.checked) {
        if (SkinTestYY == 1) {
            var OrderPriorArray = GlobalObj.OrderActionStr.split("^");
            for (var i = 0; i < OrderPriorArray.length; i++) {
                var OrderPrior = OrderPriorArray[i].split(String.fromCharCode(1));
                if (OrderPrior[1] == "YY") { ActionRowid = OrderPrior[0]; }
            }
            SetCellData(Row, "OrderAction", ActionRowid);
            SetCellData(Row, "OrderActionRowid", ActionRowid);
        }
        var OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
        if ((OrderPriorRowid != GlobalObj.ShortOrderPriorRowid)&&(GlobalObj.CFSkinTestPriorShort == 1)) {
            if (GlobalObj.OrderPriorContrlConfig == 1) {
                SetColumnList(Row, "OrderPrior", GlobalObj.ShortOrderPriorRowid + ":" + "��ʱҽ��");
                SetCellData(Row, "OrderPrior", GlobalObj.ShortOrderPriorRowid);
                SetCellData(Row, "OrderPriorRowid", GlobalObj.ShortOrderPriorRowid);
                SetCellData(Row, "OrderPriorStr", GlobalObj.ShortOrderPriorRowid + ":" + "��ʱҽ��");
            }
            SetCellData(Row, "OrderPrior", GlobalObj.ShortOrderPriorRowid);
            SetCellData(Row, "OrderPriorRowid", GlobalObj.ShortOrderPriorRowid);
			OrderPriorchangeCommon(Row,OrderPriorRowid,GlobalObj.ShortOrderPriorRowid);
            //����OrderPriorchangeCommon������ı��꽹�㵽�÷�λ��
            SetFocusCell(Row, "OrderAction");
        }
    } else {
        SetCellData(Row, "OrderAction", "");
        SetCellData(Row, "OrderActionRowid", "");
    }
}
function OrderSeqNokeydownhandler(e) {
    var rowid = GetEventRow(e);
    try { keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
    try {
        if ((keycode == 13) || (keycode == 9)) {
            var OrderPackQty = GetCellData(rowid, "OrderPackQty");
            var obj = websys_getSrcElement(e);
            if (obj.value == "") {
                SetFocusCell(rowid, "OrderInstr");
                
            } else {
                if ((GlobalObj.PAAdmType == "I") || ((GlobalObj.PAAdmType != "I") && (OrderPackQty != ""))) {
                    window.setTimeout("Add_Order_row()", 200);
                } else {
                    var JumpAry = ['OrderPackQty'];
                    CellFocusJump(rowid, JumpAry, true);
                }
            }
        }
    } catch (e) {}
}
function ChangeLinkOrderRecDep(OrderSeqNo, OrderRecDepRowid, OrderStartDateStr) {
	//if (GlobalObj.CFSameRecDepForGroup != 1) return false;
    try {
	    var FindSubOrd=false;
        var rows = $('#Order_DataGrid').getDataIDs();
        for (var i = 0; i < rows.length; i++) {
            var rowid = rows[i];
            var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
            var OrderItemRowid = GetCellData(rowid, "OrderItemRowid");
            var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
            var OrderType = GetCellData(rowid, "OrderType");
            var OrderName = GetCellData(rowid, "OrderName");
            if ((OrderARCIMRowid != "") && (OrderItemRowid == "") && (OrderMasterSeqNo == OrderSeqNo)) {
	            //��ҽ���Ǿ�����տ���,����ҽ���Ľ��տ���һ��
	            var CFSameRecDepForGroup=GlobalObj.CFSameRecDepForGroup;
	            if (CFSameRecDepForGroup!=1) {
		            var SubOrderRecDepRowid=GetCellData(rowid, "OrderRecDepRowid");
				    if ((GlobalObj.IPDosingRecLocStr != "")&&(OrderType == "R")) {
					    if (("^" + GlobalObj.IPDosingRecLocStr + "^").indexOf("^" + SubOrderRecDepRowid + "^") >= 0) {
						    CFSameRecDepForGroup=1;
						}
						if (("^" + GlobalObj.IPDosingRecLocStr + "^").indexOf("^" + OrderRecDepRowid + "^") >= 0) {
							CFSameRecDepForGroup=1;
						}
					}
				}else{
					ChangeCellDisable(rowid, { OrderRecDep: false });
				}
				if (CFSameRecDepForGroup != 1) {
					FindSubOrd=true;
					ChangeCellDisable(rowid, { OrderRecDep: true });
					continue;
				}
                //��֤��ҽ�����ܿ��Ҵ����Ƿ������ҽ�����տ���
                var FindSubRecDep = false;
                var CurrentRecLocStr = GetCellData(rowid, "CurrentRecLocStr")
                var ArrData = CurrentRecLocStr.split(String.fromCharCode(2));
                for (var m = 0; m < ArrData.length; m++) {
                    var ArrData1 = ArrData[m].split(String.fromCharCode(1));
                    if (ArrData1[0] == OrderRecDepRowid) { FindSubRecDep = true };
                }
                if (FindSubRecDep == false) {
                    $.messager.alert("����",OrderName+t['SubOrderRecDepNotDefine']);
                    //��չ���
                    SetCellData(rowid, "OrderMasterSeqNo", "")
                    $("#" + rowid).find("td").removeClass("OrderMasterS");
                    OrderMasterHandler(rowid, "C");
                    //return false;
                }else{
	                var EditStatus = GetEditStatus(rowid);
	                if (EditStatus == true) {
		                SetCellData(rowid, "OrderRecDep", OrderRecDepRowid);
		            }else{
			            var OrderRecDepDesc = GetCellData(OrderMasterSeqNo, "OrderRecDep");
			            SetCellData(rowid, "OrderRecDep", OrderRecDepDesc);
			        }
	                SetCellData(rowid, "OrderRecDepRowid", OrderRecDepRowid);
	                //Э�鵥λ�л�
					GetBillUOMStr(rowid);
	                FindSubOrd=true;
	                if (GlobalObj.CFSameRecDepForGroup!=1) {
		                if (("^" + GlobalObj.IPDosingRecLocStr + "^").indexOf("^" + OrderRecDepRowid + "^") >= 0) {
						    ChangeCellDisable(rowid, { OrderRecDep: false });
						}else{
							ChangeCellDisable(rowid, { OrderRecDep: true });
						}
	                }
                }
                if (OrderStartDateStr != "") {
                    SetCellData(rowid, "OrderStartDate", OrderStartDateStr);
                }
            }
        }
        if (FindSubOrd==false){
	        $("#" + OrderSeqNo).find("td").removeClass("OrderMasterM");
	    }
    } catch (e) { $.messager.alert("����", e.message) }
}
function CheckLinkOrderRecDep(MainID, SubID) {
	//�ж�����ҽ�����÷��Ƿ�һ��,�����һ��,���ȸı���ҽ�����÷�,��ͬʱ�޸Ľ��տ���
	var MainOrdInstr = GetCellData(MainID, "OrderInstr");
	var MainOrdInstrRowid = GetCellData(MainID, "OrderInstrRowid");
	var SubOrdInstr = GetCellData(SubID, "OrderInstr");
	var SubOrdInstrRowid = GetCellData(SubID, "OrderInstrRowid");
	if ((!IsNotFollowInstr(SubOrdInstrRowid))){   ///&&(SubOrdInstrRowid!=MainOrdInstrRowid)) {
		//�����ҽ���Ǿ���Ƥ������ѡ�񴰿�ȷ�����÷�������Ҫ����ҽ���÷�Ϊ׼
		var MainOrdNumStr=GetMainOrdNumStrInGroup(MainID,SubID);
		var MainDataRow=mPiece(MainOrdNumStr, "^", 1);
		var NeedChangeRow=mPiece(MainOrdNumStr, "^", 2);
		var NeedChangeInstr=GetCellData(MainDataRow, "OrderInstr");
		var NeedChangeInstrRowid=GetCellData(MainDataRow, "OrderInstrRowid");
		
		
		SetCellData(NeedChangeRow, "OrderInstr", NeedChangeInstr);
        SetCellData(NeedChangeRow, "OrderInstrRowid", NeedChangeInstrRowid);
        var OldOrderPriorRowid = GetCellData(NeedChangeRow, "OrderPriorRowid");
        /* //�÷�������տ���,δ�����÷����տ���,��ȡԭ���տ��Ҵ�
        var InstrReclocStr = GetReclocByInstr(NeedChangeRow);
        var OrderRecLocStr = GetRecLocStrByPrior(InstrReclocStr, SubOrderPriorRowid);
        SetColumnList(NeedChangeRow, "OrderRecDep", OrderRecLocStr);*/
        //�÷�������տ���,δ�����÷����տ���,�򲻴���
        var OldOrderRecDepRowid=GetCellData(NeedChangeRow, "OrderRecDepRowid");
        var newReclocStr = GetReclocByInstr(NeedChangeRow);
	    var InstrReclocStr=newReclocStr.split("^")[0];
	    var OrderRecLocStr=newReclocStr.split("^")[1];
	    if (InstrReclocStr!="") {
		    var OrderRecLocStr = GetRecLocStrByPrior(InstrReclocStr, OldOrderPriorRowid);
		}else{
		    var OrderRecLocStr = GetRecLocStrByPrior(OrderRecLocStr, OrderPriorRowid);
		}
		SetColumnList(NeedChangeRow, "OrderRecDep", OrderRecLocStr);
		if (InstrReclocStr=="") {
			RestoreChangeRecLoc(NeedChangeRow,OldOrderRecDepRowid,OrderRecLocStr);
		}
	}
	var OrderName = GetCellData(SubID, "OrderName");
	var MainOrderName = GetCellData(MainID, "OrderName");
    var OrderType = GetCellData(SubID, "OrderType");
    var MasterOrderRecDepRowid = GetCellData(MainID, "OrderRecDepRowid");
    var SubOrderRecDepRowid = GetCellData(SubID, "OrderRecDepRowid");
    var OrderPriorRemarks = GetCellData(SubID, "OrderPriorRemarksRowId");
    var OrderPriorRowid = GetCellData(SubID, "OrderPriorRowid");
    var ExpStr=GlobalObj.EpisodeID+"^"+session['LOGON.CTLOCID']+"^0";
    var CFSameRecDepForGroup=GlobalObj.CFSameRecDepForGroup;
	//��ҽ���Ǿ�����տ���,����ҽ���Ľ��տ���һ������ҽ��������ҽ�����տ�����
	var SubOrdIPDosingRecLoc=0,MasterOrdIPDosingRecLoc=0;
    if ((GlobalObj.IPDosingRecLocStr != "")&&(OrderType == "R")) {
	    if (("^" + GlobalObj.IPDosingRecLocStr + "^").indexOf("^" + SubOrderRecDepRowid + "^") >= 0) {
		    SubOrdIPDosingRecLoc=1;
		}
		if (("^" + GlobalObj.IPDosingRecLocStr + "^").indexOf("^" + MasterOrderRecDepRowid + "^") >= 0) {
			CFSameRecDepForGroup=1;
			var FindSubRecDep = false;
		    var CurrentRecLocStr = GetCellData(SubID, "CurrentRecLocStr")
            var ArrData = CurrentRecLocStr.split(String.fromCharCode(2));
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                if (ArrData1[0] == MasterOrderRecDepRowid) { FindSubRecDep = true };
            }
            if (FindSubRecDep == false) {
                $.messager.alert("����","��ҽ��"+OrderName+"δ�ҵ�����ҽ��һ�µľ�����տ���!","info",function(){
	                //��չ���
                	SetCellData(SubID, "OrderMasterSeqNo", "");
	            });
                return false;
            }
		}
	}
	if (SubOrdIPDosingRecLoc == 1){
		 if ((OrderPriorRowid != GlobalObj.OMOrderPriorRowid) && (OrderPriorRowid != GlobalObj.OMSOrderPriorRowid) && (OrderPriorRemarks != "OM") && (OrderPriorRemarks != "ZT")) {
		 	var MainOrderARCIMRowid = GetCellData(MainID, "OrderARCIMRowid");
            var SubOrderRecDepDesc = GetCellData(SubID, "OrderRecDep");
            var Check = cspRunServerMethod(GlobalObj.CheckStockEnoughMethod, MainOrderARCIMRowid, 1, SubOrderRecDepRowid, GlobalObj.PAAdmType,ExpStr);
            var CheckArr=Check.split("^");
            if (Check == '0') {
	            $.messager.alert("����",MainOrderName + SubOrderRecDepDesc + t['QTY_NOTENOUGH']);
                SetCellData(SubID, "OrderMasterSeqNo", "");
                return false;
	        }else if (Check == '-1') {
                $.messager.alert("����",MainOrderName + SubOrderRecDepDesc + t['QTY_INCItemLocked']);
                return false;
            } else {
                if (Check == "-2"){
                    $.messager.alert("����",MainOrderName + "ͨ��ҽ��������󶨵�"+CheckArr[1] + t['QTY_INCItemLocked']);
                    return false;
                    
                } else if (Check == "-3"){
                    $.messager.alert("����",MainOrderName + "ͨ��ҽ��������󶨵�"+CheckArr[1] + t['QTY_NOTENOUGH']);
                    return false;
                }
                var FindMainRecDep = false;
                var CurrentRecLocStr = GetCellData(MainID, "CurrentRecLocStr")
                var ArrData = CurrentRecLocStr.split(String.fromCharCode(2));
                for (var i = 0; i < ArrData.length; i++) {
                    var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                    if (ArrData1[0] == SubOrderRecDepRowid) { FindMainRecDep = true };
                }
                if (FindMainRecDep == false) {
                    $.messager.alert("����","��ҽ��"+MainOrderName+"δ�ҵ�����ҽ��һ�µľ�����տ���!","info",function(){
	                    //��չ���
                    	SetCellData(SubID, "OrderMasterSeqNo", "");
	                });
                    return false;
                }
                if (FindMainRecDep != false) {
                    var EditStatus = GetEditStatus(MainID);
                    SetCellData(MainID, "OrderRecDepRowid", SubOrderRecDepRowid);
                    if (EditStatus == true) {
                        SetCellData(MainID, "OrderRecDep", SubOrderRecDepRowid);
                    } else {
                        SetCellData(MainID, "OrderRecDep", SubOrderRecDepDesc);
                    }
                    OrderRecDepChangeCom(MainID);
                }
            }
		 }
		 return true;
	}
	
    if (CFSameRecDepForGroup == 1) { //&& (OrderType == 'R')
        if ((OrderPriorRowid != GlobalObj.OMOrderPriorRowid) && (OrderPriorRowid != GlobalObj.OMSOrderPriorRowid) && (OrderPriorRemarks != "OM") && (OrderPriorRemarks != "ZT")) {
            var OrderARCIMRowid = GetCellData(SubID, "OrderARCIMRowid");
            var OrderName = GetCellData(SubID, "OrderName");
            var OrderRecDepDesc = GetCellData(MainID, "OrderRecDep");
            var Check = cspRunServerMethod(GlobalObj.CheckStockEnoughMethod, OrderARCIMRowid, 1, MasterOrderRecDepRowid, GlobalObj.PAAdmType,ExpStr);
            var CheckArr=Check.split("^");
            Check=CheckArr[0];
            if (Check == '0') {
                $.messager.alert("����",OrderName + OrderRecDepDesc + t['QTY_NOTENOUGH']);
                SetCellData(SubID, "OrderMasterSeqNo", "");

                return false;
            } else if (Check == '-1') {
                $.messager.alert("����",OrderName + OrderRecDepDesc + t['QTY_INCItemLocked']);
                return false;
            } else {
                if (Check == "-2"){
                    $.messager.alert("����",OrderName + "ͨ��ҽ��������󶨵�"+CheckArr[1] + t['QTY_INCItemLocked']);
                    return false;
                    
                } else if (Check == "-3"){
                    $.messager.alert("����",OrderName + "ͨ��ҽ��������󶨵�"+CheckArr[1] + t['QTY_NOTENOUGH']);
                    return false;
                }
                var OrderType = GetCellData(MainID, "OrderType");
                // if (OrderType != "R") return false;
                var FindSubRecDep = false;
                var CurrentRecLocStr = GetCellData(SubID, "CurrentRecLocStr")
                var ArrData = CurrentRecLocStr.split(String.fromCharCode(2));
                for (var i = 0; i < ArrData.length; i++) {
                    var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                    if (ArrData1[0] == MasterOrderRecDepRowid) { FindSubRecDep = true };
                }
                if (FindSubRecDep == false) {
                    $.messager.alert("����",OrderName + OrderRecDepDesc + t['SubOrderRecDepNotDefine']);
                    //��չ���
                    SetCellData(SubID, "OrderMasterSeqNo", "");
                    return false;
                }
                if (FindSubRecDep != false) {
                    var EditStatus = GetEditStatus(SubID);
                    SetCellData(SubID, "OrderRecDepRowid", MasterOrderRecDepRowid);
                    if (EditStatus == true) {
                        SetCellData(SubID, "OrderRecDep", MasterOrderRecDepRowid);
                    } else {
                        SetCellData(SubID, "OrderRecDep", OrderRecDepDesc);
                    }
                }
            }
        }
    }
    return true;
}
///������ҽ���а�����Ƥ��������ѡ����������ʱ����Ƥ������������һ�е�����Ϊ׼
function GetMainOrdNumStrInGroup(MainID,SubID){
	//�ж�����ҽ�����÷��Ƿ�һ��,�����һ��,���ȸı���ҽ�����÷�,��ͬʱ�޸Ľ��տ���
	var MainOrdInstr = GetCellData(MainID, "OrderInstr");
	var MainOrdInstrRowid = GetCellData(MainID, "OrderInstrRowid");
	var MainOrderPriorRowid = GetCellData(MainID, "OrderPriorRowid");
	var MainIDOrderHiddenPara = GetCellData(MainID, "OrderHiddenPara");
	var SubOrdInstr = GetCellData(SubID, "OrderInstr");
	var SubOrdInstrRowid = GetCellData(SubID, "OrderInstrRowid");
	var SubOrderHiddenPara = GetCellData(SubID, "OrderHiddenPara");
	var SubOrderPriorRowid = GetCellData(SubID, "OrderPriorRowid");
	
	var MainNeedSkinTestINCI = mPiece(MainIDOrderHiddenPara, String.fromCharCode(1), 7);
	var SubNeedSkinTestINCI = mPiece(SubOrderHiddenPara, String.fromCharCode(1), 7);
	var MainOrderPriorFlag = IsLongPrior(MainOrderPriorRowid);
	var SubOrderPriorFlag = IsLongPrior(SubOrderPriorRowid);
	var MainSkinFlag="N";
	var SubSkinFlag="N";
	if ((GlobalObj.SkinTestInstr != "")&&(GlobalObj.SkinTestInstr.indexOf("^" + MainOrdInstrRowid + "^") != "-1")&&(!MainOrderPriorFlag)){
		MainSkinFlag="Y";
	}
	if ((GlobalObj.SkinTestInstr != "")&&(GlobalObj.SkinTestInstr.indexOf("^" + SubOrdInstrRowid + "^") != "-1")&&(!SubOrderPriorFlag)){
		SubSkinFlag="Y";
	}
	var Flag="0";
	if ((MainNeedSkinTestINCI=="Y")&&(SubNeedSkinTestINCI=="Y")&&(MainSkinFlag!=SubSkinFlag)){
		Flag="-100";
	}
	if (MainSkinFlag==SubSkinFlag){
		return Flag+"^"+MainID+"^"+SubID;
	}else{
		if (MainNeedSkinTestINCI=="Y"){
			return Flag+"^"+MainID+"^"+SubID;
		}else if(SubNeedSkinTestINCI=="Y"){
			return Flag+"^"+SubID+"^"+MainID;
		}else{
			return Flag+"^"+MainID+"^"+SubID;
		}
	}
	
}
//-------------��ֵ����
//��ֵ����
function OrderMaterialBarcodeContrl(rowid,callBackFun) {
    var label = GetCellData(rowid, "OrderMaterialBarcode");
    var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
    if ((label == "")||(OrderARCIMRowid!="")) { 
    	return false; 
    }
    var AricmStr = cspRunServerMethod(GlobalObj.GetArcimByLabel, label)
    var ArcimArr = AricmStr.split("^")
    var arcimRowid = ArcimArr[0];
    if (arcimRowid == "") {
        $.messager.alert("��ʾ","�������Ӧ��ҽ����Ŀ������,���ʵ!")
        return false;
    }
    if (ArcimArr[1] == "Enable") {
        var IncItmHighValueFlag = ArcimArr[7]
        if (IncItmHighValueFlag == "N") {
			
			var OrdParamsArr=new Array();
			OrdParamsArr[OrdParamsArr.length]={
				OrderARCIMRowid:arcimRowid,
				MaterialBarcode:label
			};
			new Promise(function(resolve,rejected){
				AddItemToList(rowid,OrdParamsArr,"data","",resolve);
			}).then(function(RtnObj){
				var rowid=RtnObj.rowid;
				var returnValue=RtnObj.returnValue;
				
	            if (!returnValue) {
	                ClearRow(rowid);
	            }else{
		             Add_Order_row();
		             setTimeout(function(){ 
		             	SetFocusCell(parseInt(rowid)+1, "OrderMaterialBarcode");
				     },100); 
		        }
			})
        } else {
	        var OriginalStatusFlag=ArcimArr[9]
	        if (OriginalStatusFlag="Y"){
		        var ReLocIdFlag = "N";
                
				var OrdParamsArr=new Array();
				OrdParamsArr[OrdParamsArr.length]={
					OrderARCIMRowid:arcimRowid,
					MaterialBarcode:label
				};
				new Promise(function(resolve,rejected){
					AddItemToList(rowid,OrdParamsArr,"data","",resolve);
				}).then(function(RtnObj){
					var rowid=RtnObj.rowid;
					var returnValue=RtnObj.returnValue;
					
	                if (returnValue == true) {
	                        SetCellData(rowid, "OrderMaterialBarcodeHiden", label); //������ŵ�һ�����ص�������
	                        SetCellData(rowid, "OrderMaterialBarcode", label);
	                        Add_Order_row();
	                        setTimeout(function(){ 
				             	SetFocusCell(parseInt(rowid)+1, "OrderMaterialBarcode");
						     },100); 
	                    
	                } else {
	                    ClearRow(rowid);
	                }
		        })
		        }else{
            if (GlobalObj.HighValueControl != 1) {
                $.messager.alert("��ʾ","������¼�Ŀ���û��¼���ֵ���ϵ�Ȩ��,����ϵ��Ϣ��ȷ��!")
                return false;
            }
            //���ص���ʵ�����������ʵ������ͳһ�Ŀ���жϲ����������ж�

            var avaQty = ArcimArr[4]
            if (avaQty <= 0) {
                $.messager.alert("��ʾ","�������Ӧ��ҽ����治��.")
                return false;
            }
            var ReLocId = ArcimArr[5] //���Ͽ��ý��տ���
            if (arcimRowid != "") {
                var ReLocIdFlag = "N";
                
				var OrdParamsArr=new Array();
				OrdParamsArr[OrdParamsArr.length]={
					OrderARCIMRowid:arcimRowid,
					MaterialBarcode:label
				};
				new Promise(function(resolve,rejected){
					AddItemToList(rowid,OrdParamsArr,"data","",resolve);
				}).then(function(RtnObj){
					var rowid=RtnObj.rowid;
					var returnValue=RtnObj.returnValue;
					
	                if (returnValue == true) {
	                    var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
	                    if (OrderARCIMRowid != "") {
	                        var OrderRecLocStr = GetCellData(rowid, "CurrentRecLocStr");
	                        var ArrData = OrderRecLocStr.split(String.fromCharCode(2));
	                        for (var i = 0; i < ArrData.length; i++) {
	                            var ArrData1 = ArrData[i].split(String.fromCharCode(1));
	                            if ((ArrData1[0] == ReLocId) && (ReLocIdFlag != "Y")) { ReLocIdFlag = "Y" };
	                        }
	                        if (ReLocIdFlag == "N") {
	                            $.messager.alert("��ʾ","�����벻���ڸÿ���ʹ��!","info",function(){
		                            ClearRow(rowid);
		                        })
	                            return false;
	                        }
	                        SetCellData(rowid, "OrderMaterialBarcodeHiden", label); //������ŵ�һ�����ص�������
	                        SetCellData(rowid, "OrderMaterialBarcode", label);
	                        Add_Order_row();
	                        setTimeout(function(){ 
				             	SetFocusCell(parseInt(rowid)+1, "OrderMaterialBarcode");
						     },100); 
	                    }
	                } else {
	                    ClearRow(rowid);
	                }
				})
            }
	        }
        }

    } else {
        $.messager.alert("��ʾ","�����벻���ڻ����ѱ�ʹ��!","info",function(){
	        if (callBackFun) callBackFun();
        })
        return false;
    }
}

function OrderMaterialBarcode_changehandler(e) {
    var rowid = GetEventRow(e);
    if (PageLogicObj.BarcodeEntry==0) {
    	OrderMaterialBarcodeContrl(rowid);
    }
}
function OrderMaterialBarcode_Keypresshandler(e) {
    var type = websys_getType(e);
    var key = websys_getKey(e);
    var rowid = GetEventRow(e);
    if (key == 13) {
	    PageLogicObj.BarcodeEntry=1;
        OrderMaterialBarcodeContrl(rowid,function(){
			    PageLogicObj.BarcodeEntry=0;
		});
    }
}
//�Ƴ̳���ԭ��
function ExceedReasonChange(e) {
    var rowid = "";
    var obj = websys_getSrcElement(e);
    var rowid = GetEventRow(e);
    SetCellData(rowid, "ExceedReasonID", obj.value);
    ChangeLinkOrderExceedReason(rowid);
}
function ChangeLinkOrderExceedReason(Row) {
    try {
        var ExceedReasonID = GetCellData(Row, "ExceedReasonID");
        var ExceedReason = GetCellData(Row, "ExceedReason");
        var RowArry = GetSeqNolist(Row)
        for (var i = 0; i < RowArry.length; i++) {
	        var obj = document.getElementById(RowArry[i] + "_ExceedReason");
            if (obj) {
                //�ɱ༭״̬
                SetCellData(RowArry[i], "ExceedReason", ExceedReasonID);
            } else {
                SetCellData(RowArry[i], "ExceedReason", ExceedReason);
            }
            SetCellData(RowArry[i], "ExceedReasonID", ExceedReasonID);
        }
    } catch (e) { dhcsys_alert(e.message) }
}
//��ӡ���ﵼ�ﵥ
function BtnPrtGuidPatHandler(RepeatFlag) {
    var url = "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocPatGuideDocumentsPrt&EpisodeID=" + GlobalObj.EpisodeID + "&mradm=" + GlobalObj.mradm + "&PatientID=" + GlobalObj.PatientID;
    var ConfirmPrintAll = dhcsys_confirm("�Ƿ��ӡȫ�����ﵥ��Ŀ?");
    if (ConfirmPrintAll) {
        window.open(url, "DHCDocPatGuideDocumentsPrtPrintAll", "top=0,left=0,width=1,height=1,alwaysLowered=yes");
    } else {
        websys_createWindow(url, "DHCDocPatGuideDocumentsPrt", "top=100,left=200,width=1000,height=600,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
    }
}
//���´�ӡ���ﵼ�ﵥ
function BtnRePrtGuidPat_Click() {
    //�����ﵥ ȫ����ӡ
    var RepeatFlag = 1;
    BtnPrtGuidPatHandler(RepeatFlag);
}
//����Ϊҽ����
function SaveToArcos_Click() {
    var SelIds = $('#Order_DataGrid').jqGrid("getGridParam", "selarrrow");
    if (SelIds == null || SelIds.length == 0) {
        $.messager.alert("��ʾ", "��ѡ��Ҫ���浽ҽ���׵ļ�¼");
        return;
    }
    var ValidCount=0;
    for (var i = 0; i < SelIds.length; i++) {
        var OrderItemRowid = GetCellData(SelIds[i], "OrderItemRowid");
        var OrderARCIMRowid = GetCellData(SelIds[i], "OrderARCIMRowid");
        if (OrderARCIMRowid!="") ValidCount=ValidCount+1;
    }
    if (ValidCount==0){
	    $.messager.alert("��ʾ", "��ѡ��Ҫ���浽ҽ���׵���Ч��¼");
        return false;
	}
    UDHCOEOrderDescSetLink(function(RtnStr){
	    var ArcosRowid = RtnStr.split("^")[0];
	    if (ArcosRowid != "") { 
	    	AddTOArcosARCIM(ArcosRowid, SelIds); 
	    } else { 
	    	$.messager.alert("����", "����ʧ��!"); 
	    	return websys_cancel(); 
	    }
	});
}
//����ҽ��������
function UDHCOEOrderDescSetLink(callback) {
    var lnk = "udhcfavitem.edit.hui.csp?TDis=1&CMFlag=N&HospARCOSAuthority=1"; //udhcfavitem.edit.new.csp
    websys_showModal({
		url:lnk,
		title:'ҽ����ά�� <font color=yellow>��ʾ��������ҽ�������Ҽ������������;�豣�浽�Ѵ��ڵ�ҽ������,��˫����Ӧ��</font>',
		width:760,height:(top.screen.height - 300),
		CallBackFunc:function(rtn){
			if (callback) callback(rtn);
		}
	})
}
//��Ӧ��ҽ����ҽ������
var OrderMasterSeqNoArr =new Array();
var OrderSubSeqNoArr =new Array();
function AddTOArcosARCIM(Arcosrowid, rowids) {
    if (Arcosrowid == "") { return websys_cancel(); }
    OrderSubSeqNoArr = new Array();
	OrderMasterSeqNoArr = new Array();
    var len = rowids.length;
    for (var i = 0; i < rowids.length; i++) {
        //������Ѿ���˵�δ�շѲ�����¼���ҽ������
        var OrderItemRowid = GetCellData(rowids[i], "OrderItemRowid");
        var OrderARCIMRowid = GetCellData(rowids[i], "OrderARCIMRowid");
        if (OrderARCIMRowid=="") continue;
	        var OrderType = GetCellData(rowids[i], "OrderType");
            var OrderMasterSeqNo = GetCellData(rowids[i], "OrderMasterSeqNo");
            //if ((OrderType!="R")&&(OrderMasterSeqNo!="")) continue;
            var OrderSeqNo = GetCellData(rowids[i], "id");
            var OrderPriorRowid = GetCellData(rowids[i], "OrderPriorRowid");
            OrderMasterSeqNo=GetLinkMasterNoForArcos(rowids[i], Arcosrowid)
            var OrderDoseQty = GetCellData(rowids[i], "OrderDoseQty"); //����
            if ((OrderDoseQty!="")&&(OrderDoseQty.indexOf("-")>=0)) {
	            OrderDoseQty=OrderDoseQty.split("-")[0];
	        }
            var OrderDoseUOM = GetCellData(rowids[i], "OrderDoseUOMRowid"); //������λ
            var OrderFreqRowID = GetCellData(rowids[i], "OrderFreqRowid"); //Ƶ��
            var OrderInstrRowID = GetCellData(rowids[i], "OrderInstrRowid"); //�÷�
            var OrderDurRowid = GetCellData(rowids[i], "OrderDurRowid"); //�Ƴ�
            var OrderPackQty = GetCellData(rowids[i], "OrderPackQty"); //����װ
            var OrderPackUOM = GetCellData(rowids[i], "OrderPackUOMRowid"); //����װ��λ
            var OrderRecDepRowid = GetCellData(rowids[i], "OrderRecDepRowid");
            var FindFlag=0;
            var BillUOMStr=GetCellData(rowids[i], "OrderPackUOMStr");
            var ArrData = BillUOMStr.split(String.fromCharCode(2));
            if (ArrData.length<=1){
	            OrderRecDepRowid="";
	        }else{
		        for (var m = 0; m < ArrData.length-1; m++) {
			        var ArrData1 = ArrData[m].split(String.fromCharCode(1));
			        if ((ArrData1[0] == OrderPackUOM)&&(OrderPackUOM!="")&&(OrderPackUOM!=undefined)) {
			            FindFlag=1;
			        }
			    }
			    if (FindFlag==0) OrderRecDepRowid="";
		    }
            var OrderDepProcNote = GetCellData(rowids[i], "OrderDepProcNote"); //ҽ����ע
            var OrderPriorRemarks = GetCellData(rowids[i], "OrderPriorRemarksRowId"); //����˵��
            if (OrderPriorRemarks == "false") OrderPriorRemarks = "";
            var SampleId = GetCellData(rowids[i], "OrderLabSpecRowid");
            //SampleId �걾ID,ARCOSItemNO  ����ָ��λ��(ҽ��¼�벻��), OrderPriorRemarksDR As %String
            var OrderStageCode = GetCellData(rowids[i], "OrderStageCode");
            var OrderSpeedFlowRate=GetCellData(rowids[i],"OrderSpeedFlowRate");//��Һ����
            var OrderFlowRateUnitRowId=GetCellData(rowids[i],"OrderFlowRateUnitRowId"); //���ٵ�λ
            var OrderBodyPartLabel=GetCellData(rowids[i], "OrderBodyPartLabel");
            var Urgent=GetCellData(rowids[i], "Urgent");
            var MustEnter="N";
            var OrderSkinTest=GetCellData(rowids[i], "OrderSkinTest");
            var OrderActionRowid=GetCellData(rowids[i], "OrderActionRowid");
            var OrderFreqTimeDoseStr=GetCellData(rowids[i], "OrderFreqTimeDoseStr");//ͬƵ�β�ͬ����
            var OrderFreqWeekStr=GetCellData(rowids[i], "OrderFreqDispTimeStr"); //��Ƶ��
            
            var ExpStr=OrderStageCode+"^"+MustEnter+"^"+OrderPackUOM;
	        ExpStr=ExpStr+"^"+OrderSpeedFlowRate+"^"+OrderFlowRateUnitRowId+"^"+OrderBodyPartLabel+"^"+OrderSkinTest+"^"+OrderActionRowid+"^"+Urgent;
	        ExpStr=ExpStr+"^"; //�Ʒ����ײ���ϸ���
			ExpStr=ExpStr+"^"+OrderFreqTimeDoseStr+"^"+OrderFreqWeekStr; //ͬƵ�β�ͬ��������Ƶ��
	        
            var ret = tkMakeServerCall('web.DHCARCOrdSets', 'InsertItem', Arcosrowid, OrderARCIMRowid, OrderPackQty, OrderDoseQty, OrderDoseUOM, OrderFreqRowID, OrderDurRowid, OrderInstrRowID, OrderMasterSeqNo, OrderDepProcNote, OrderPriorRowid, SampleId, "", OrderPriorRemarks,OrderRecDepRowid,ExpStr);
        
    }
    return websys_cancel();
}
function SetSaveForUserClickHandler() {
    var rowids = $('#Order_DataGrid').jqGrid("getGridParam", "selarrrow");
    if (rowids == null || rowids.length == 0) {
        $.messager.alert("����", "��ѡ����");
        return;
    }
    var SuccessCount = 0;
    var len = rowids.length;
    for (var i = 0; i < len; i++) {
        var OrderType = GetCellData(rowids[i], "OrderType");
        var OrderName = GetCellData(rowids[i], "OrderName");
        if (OrderType != "R") {
            $.messager.alert("����", "ҽ����:[" + OrderName + "]����ҩƷ,���������!");
            continue;
        }
        var ret = OtherMenuUpdate("User", session["LOGON.USERID"], rowids[i]);
        if (parseFloat(ret) > 0) {
            SuccessCount = SuccessCount + 1
        }
    }
    if (parseFloat(SuccessCount) > 0) {
        $.messager.alert("��ʾ", "��" + SuccessCount + "����¼����ɹ�.");
    }
    return websys_cancel();
}
function OtherMenuUpdate(ContralType, ContralKey, rowid) {
    try {
        var SeccessCount = 0;
        var ContralStr = "";
        ContralStr = GetContralStr(ContralType, ContralKey, rowid);
        if (ContralStr == "") return "";
        var OrderName = GetCellData(rowid, "OrderName");
        var UserID = session["LOGON.USERID"];
        var ret = cspRunServerMethod(GlobalObj.SaveItemDefaultMethod, ContralStr, UserID);
        var TempArr = ret.split("^");
        if (TempArr[0] == '0') { SeccessCount = SeccessCount + 1; 
        } else if (TempArr[0] == '-100') {
            $.messager.alert("����", "ҽ����:[" + OrderName + "],����ʧ��,�������:-100!") 
        } else if (TempArr[0] == '-101') {
            $.messager.alert("����", "ҽ����:[" + OrderName + "],����ʧ��,������ͬ�ļ�¼") 
        } else {}

    } catch (e) { $.messager.alert("����", e.message) }
    return SeccessCount;
}

function GetContralStr(ContralType, ContralKey, rowid) {
    var OrderName = GetCellData(rowid, "OrderName");
    var OrderItemRowid = GetCellData(rowid, "OrderItemRowid");
    var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
    var OrderType = GetCellData(rowid, "OrderType");
    var OrderRecDepRowid = GetCellData(rowid, "OrderRecDepRowid");
    var OrderPriorRowid = GetCellData(rowid, "OrderPriorRowid");
    var OrderPriorRemarks = GetCellData(rowid, "OrderPriorRemarksRowId");
    OrderPriorRowid = ReSetOrderPriorRowid(OrderPriorRowid, OrderPriorRemarks);
    var OrderFreqRowid = GetCellData(rowid, "OrderFreqRowid");
    var OrderFreq = GetCellData(rowid, "OrderFreq");
    var OrderFreqFactor = GetCellData(rowid, "OrderFreqFactor");
    var OrderDurRowid = GetCellData(rowid, "OrderDurRowid");
    var OrderDur = GetCellData(rowid, "OrderDur");
    var OrderDurFactor = GetCellData(rowid, "OrderDurFactor");
    var OrderInstrRowid = GetCellData(rowid, "OrderInstrRowid");
    var OrderInstr = GetCellData(rowid, "OrderInstr");
    var OrderDoseQty = GetCellData(rowid, "OrderDoseQty");
    var OrderDoseUOMRowid = GetCellData(rowid, "OrderDoseUOMRowid");
    var OrderDoseUOM = GetCellData(rowid, "OrderDoseUOM");

    var OrderPackQty = GetCellData(rowid, "OrderPackQty");
    var OrderPackUOMRowid = GetCellData(rowid, "OrderPackUOMRowid");
    var OrderSeqNo = GetCellData(rowid, "id");
    var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
    var PHPrescType = GetCellData(rowid, "OrderPHPrescType");
    var OrderConFac = GetCellData(rowid, "OrderConFac");
    var OrderBaseQty = GetCellData(rowid, "OrderBaseQty");
    var OrderPrice = GetCellData(rowid, "OrderPrice");
    var OrderStartDateStr = GetCellData(rowid, "OrderStartDate");
    var OrderStartDate = "";
    if (OrderStartDateStr != "") {
        OrderStartDate = OrderStartDateStr.split(" ")[0];
    }
    var OrderPHForm = GetCellData(rowid, "OrderPHForm");
    var OrderItemSum = GetCellData(rowid, "OrderSum");
    var OrderEndDateStr = GetCellData(rowid, "OrderEndDate");
    var OrderEndDate = "";
    if (OrderStartDateStr != "") {
        OrderEndDate = OrderEndDateStr.split(" ")[0];
    }
    var OrderAlertStockQty = GetCellData(rowid, "OrderAlertStockQty");
    var OrderBillTypeRowid = GetCellData(rowid, "OrderBillTypeRowid");
    var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
    var OrderPackUOM = GetCellData(rowid, "OrderPackUOMRowid");
    var OrderFirstDayTimes = GetCellData(rowid, "OrderFirstDayTimes");
    var OrderSkinTest = GetCellData(rowid, "OrderSkinTest");
    var OrderActionRowid = GetCellData(rowid, "OrderActionRowid");
    var OrderAction = GetCellData(rowid, "OrderAction");
    var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
    var OrderItemCatRowid = mPiece(OrderHiddenPara, String.fromCharCode(1), 2);
    var Notes = GetCellData(rowid, "OrderDepProcNote");
    var OrderSpeedFlowRate = GetCellData(rowid, "OrderSpeedFlowRate");
    var OrderFlowRateUnit = GetCellData(rowid, "OrderFlowRateUnitRowId");
    var ExceedReasonID = GetCellData(rowid, "ExceedReasonID");
    var OrderFreqTimeDoseStr= GetCellData(rowid, "OrderFreqTimeDoseStr");
    if (OrderFreqTimeDoseStr!="") OrderDoseQty="";
    var OrderFreqDispTimeStr= GetCellData(rowid, "OrderFreqDispTimeStr");
    
    //����ж�
    if (OrderARCIMRowid == "") {
        $.messager.alert("��ʾ",t["NoItem"]);
        return "";
    }
    if (ContralKey == "") {
        $.messager.alert("��ʾ",t["NoContralType"]);
        return "";
    }

    var ContralStr = OrderARCIMRowid + "^" + ContralType + "^" + ContralKey + "^" + OrderPriorRowid + "^" + OrderDoseQty + "^" + OrderDoseUOMRowid;
    ContralStr = ContralStr + "^" + OrderInstrRowid + "^" + OrderFreqRowid + "^" + OrderDurRowid + "^" + OrderPackQty + "^" + OrderSkinTest;
    ContralStr = ContralStr + "^" + OrderActionRowid + "^" + OrderMasterSeqNo + "^" + OrderSeqNo + "^" + Notes + "^" + GlobalObj.PAAdmType;
    ContralStr = ContralStr + "^" + ExceedReasonID +"^"+ OrderSpeedFlowRate + "^" + OrderFlowRateUnit;
    ContralStr = ContralStr + "^" + OrderFreqTimeDoseStr +"^"+ OrderFreqDispTimeStr +"^"+ OrderPackUOMRowid;
    return ContralStr;
}
//ͬ����ҽ�����մ���
function OrderFirstDayTimeschangehandler(e) {
    var rowid = GetEventRow(e);
    ChangeFirstDayTimes(rowid);
    SetPackQty(rowid,{
		IsNotChangeFirstDayTimeFlag:"Y"
	});
}
function ChangeFirstDayTimes(rowid) {
    var OrderFirstDayTimes = GetCellData(rowid, "OrderFirstDayTimes");
    var rowids = GetMasterSeqNo(rowid);
    for (var i = 0; i < rowids.length; i++) {
        SetCellData(rowids[i], "OrderFirstDayTimes", OrderFirstDayTimes);
        SetPackQty(rowids[i],{
			IsNotChangeFirstDayTimeFlag:"Y"
		});
    }
}
function OrderFirstDayTimeskeypresshandler(e) {
    try { keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
    if (keycode == 45) { window.event.keyCode = 0; return websys_cancel(); }

    if ((keycode > 47) && (keycode < 58)) {} else if (keycode == 13) {
        OrderFirstDayTimeschangehandler(e);
    } else {
        window.event.keyCode = 0;
        return websys_cancel();
    }
}
//��Ҫ��Һ
function OrderNeedPIVAFlagChangehandler(e) {
    try {
        var rowid = GetEventRow(e);
        CancelNeedPIVA(rowid)
    } catch (e) { $.messager.alert("����", e.message) }
}
//��λ˵���ı�
function OrderBodyPartchangehandler(e) {
    try {
        var rowid = GetEventRow(e);
        var obj = websys_getSrcElement(e);
        var OrderBodyPartID = obj.value;

        SetCellData(rowid, "OrderBodyPartID", OrderBodyPartID);

        ChangeLinkOrderBodyPart(rowid);
    } catch (e) { $.messager.alert("����", e.message) }
}

function CancelNeedPIVA(rowid) {
    var OrderNeedPIVAFlag = GetCellData(rowid, "OrderNeedPIVAFlag");
    var OrderFreqRowid = GetCellData(rowid, "OrderFreqRowid");
    if (OrderNeedPIVAFlag == "Y") {
        OrderNeedPIVAFlag = true;
        var OrderPackQtyStyleObj = { OrderPackQty: false, OrderPackUOM: false }
    } else {
        OrderNeedPIVAFlag = false;
        var OrderPackQtyStyleObj = ContrlOrderPackQty(rowid);
    }
    if (OrderNeedPIVAFlag) { SetCellData(rowid, "OrderPackQty", ""); } else { 
        var OrderPackQty = GetCellData(rowid, "OrderPackQty");
        if ((OrderPackQtyStyleObj.OrderPackQty)&&(OrderPackQty!="")){
	    }else{
		    SetPackQty(rowid);
		}
    }
    ChangeCellDisable(rowid, OrderPackQtyStyleObj);
    var RowArry = GetSeqNolist(rowid);
    
    for (var i = 0; i < RowArry.length; i++) {
	    var OrderType = GetCellData(RowArry[i], "OrderType");
    	if (OrderType!="R") continue;
    	var EditStatus = GetEditStatus(RowArry[i]);
		if (EditStatus){
			var OrderNeedPIVAFlagVal=OrderNeedPIVAFlag;
		}else{
			var OrderNeedPIVAFlagVal=OrderNeedPIVAFlag?"Y":"N";
		}
        SetCellData(RowArry[i], "OrderNeedPIVAFlag", OrderNeedPIVAFlagVal);
        if (OrderNeedPIVAFlag) { 
        	SetCellData(RowArry[i], "OrderPackQty", ""); 
        } else { 
        	SetPackQty(RowArry[i]); 
        	var OrderPackQtyStyleObj = ContrlOrderPackQty(RowArry[i]);
        }
        ChangeCellDisable(RowArry[i], OrderPackQtyStyleObj);
    }
}
function ChangeLinkOrderBodyPart(Row) {
    try {
        var OrderBodyPart = GetCellData(Row, "OrderBodyPart");
        var OrderBodyPartID = GetCellData(Row, "OrderBodyPartID");
        var RowArry = GetSeqNolist(Row);
        for (var i = 0; i < RowArry.length; i++) {
            SetCellData(RowArry[i], "OrderBodyPart", OrderBodyPartID);
            SetCellData(RowArry[i], "OrderBodyPartID", OrderBodyPartID);
        }
    } catch (e) { dhcsys_alert(e.message) }
}
//ҽ���׶θı�
function OrderStagechangehandler(e) {
    try {
        var rowid = GetEventRow(e);
        var obj = websys_getSrcElement(e);
        var OrderStageCode = obj.value;

        SetCellData(rowid, "OrderStageCode", OrderStageCode);

        ChangeLinkOrderStage(rowid);
    } catch (e) { $.messager.alert("����", e.message) }
}
function ChangeLinkOrderStage(Row) {
    try {
        var OrderStage = GetCellData(Row, "OrderStage");
        var OrderStageCode = GetCellData(Row, "OrderStageCode");
        var RowArry = GetSeqNolist(Row)
        for (var i = 0; i < RowArry.length; i++) {
	        var EditStatus = GetEditStatus(RowArry[i]);
            if (EditStatus == true) {
                SetCellData(RowArry[i], "OrderStage", OrderStageCode);
            }else{
	            var OrderStage = GetCellData(Row, "OrderStage");
	            SetCellData(RowArry[i], "OrderStage", OrderStage);
	        }
            //SetCellData(RowArry[i], "OrderStage", OrderStageCode);
            SetCellData(RowArry[i], "OrderStageCode", OrderStageCode);
        }
    } catch (e) { dhcsys_alert(e.message) }
}
function AntUseReasonchangehandler(e) {
    try {
        var rowid = GetEventRow(e);
        var obj = websys_getSrcElement(e);
        var AntUseReasonRowid = obj.value;
        SetCellData(rowid, "AntUseReasonRowid", AntUseReasonRowid);
    } catch (e) { $.messager.alert("����", e.message) }
}
// ��������  ���� OrderPackQty{} 
function ContrlOrderPackQty(rowid,ContrlOrderPackQtArg) {
	var OrderMasterARCIMRowid="";
	if (typeof ContrlOrderPackQtArg=="object"){
		var PriorRowid=ContrlOrderPackQtArg.OrderPriorRowid;
		var OrderPriorRemarks = ContrlOrderPackQtArg.OrderPriorRemarks;
		var OrderFreqRowid = ContrlOrderPackQtArg.OrderFreqRowid;
		var OrderARCIMRowid = ContrlOrderPackQtArg.OrderARCIMRowid;
		var OrderRecDepRowid = ContrlOrderPackQtArg.OrderRecDepRowid;
		var OrderMasterARCIMRowid=ContrlOrderPackQtArg.OrderMasterARCIMRowid;
		var OrderVirtualtLong=(typeof ContrlOrderPackQtArg.OrderVirtualtLong!="undefined")?ContrlOrderPackQtArg.OrderVirtualtLong:"N";
		var ContrlOrderPackQtArg=null;
	}else{
		var PriorRowid = GetCellData(rowid, "OrderPriorRowid");
		var OrderPriorRemarks = GetCellData(rowid, "OrderPriorRemarksRowId"); //OrderPriorRemarks
		var OrderFreqRowid = GetCellData(rowid, "OrderFreqRowid");
		var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
		var OrderRecDepRowid = GetCellData(rowid, "OrderRecDepRowid");
		var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
		if (OrderMasterSeqNo!=""){
			var rowids = GetAllRowId();
	        for (var i = 0; i < rowids.length; i++) {
				var OrderSeqNo = GetCellData(rowids[i], "id")
	            var OrderSeqNoMasterLink = GetCellData(rowids[i], "id");
	            if (OrderSeqNoMasterLink == OrderMasterSeqNo) {
	            	OrderMasterARCIMRowid=GetCellData(rowids[i], "OrderARCIMRowid");
	            	break;
	            }
	        }
		}
		var OrderVirtualtLong=GetCellData(rowid, "OrderVirtualtLong");
	}
	if (OrderARCIMRowid==""){
		return {};
	}
    var OrderPackQtyObj = { OrderPackQty: true, OrderPackUOM: true };
	var EpisodeID=GlobalObj.EpisodeID;
    var OrderPriorRowid = ReSetOrderPriorRowid(PriorRowid, OrderPriorRemarks);
	
	var ret = cspRunServerMethod(GlobalObj.ContrlOrderPackQtyMethod, EpisodeID, OrderPriorRowid, session['LOGON.CTLOCID'], OrderARCIMRowid, OrderMasterARCIMRowid, OrderRecDepRowid,OrderVirtualtLong);
	var OrderPackQtyStyle = mPiece(ret, "^", 0);
	var OrderPackUOMStyle = mPiece(ret, "^", 1);
	var SetOrderPackQtyValue = mPiece(ret, "^", 2);
	if (OrderPackQtyStyle=="0"){
		OrderPackQtyObj.OrderPackQty = false;
	}
	if (OrderPackUOMStyle=="0"){
		OrderPackQtyObj.OrderPackUOM = false;
	}
	if ((SetOrderPackQtyValue!="false")&&(SetOrderPackQtyValue!="true")){
		SetCellData(rowid, "OrderPackQty", SetOrderPackQtyValue)
	}
    return OrderPackQtyObj
}
//�໥����
function XHZY_Click() {
	if (GlobalObj.HLYYInterface==1){
		XHZYClickHandler_HLYY();
	}else{
	   //֪ʶ��
       var rtnZSK =CheckLibPhaFunction("C", "", "")
	}
}
// ҩƷ˵����
function YDTS_Click() {
	if(GlobalObj.HLYYInterface==1){
		HLYYYDTS_Click();
	}else{
		var ids =$('#Order_DataGrid').jqGrid("getGridParam", "selarrrow");
		if (ids.length >1) {
			$.messager.alert("����", "��ѡ��һ��ҽ��");
			return;
		}else if (ids ==null ||ids.length ==0) {
			websys_showModal({
				url:"dhc.bdp.kb.dhchisinstructions.csp",
				title:'˵����',
				width:screen.availWidth-200,height:screen.availHeight-200
			});
		}
		//֪ʶ��
	    LinkMesageZSQ(ids[0])
	}
}
//��¼����ҽ��
function SetVerifiedOrder(itemids) {
    $("#Prompt").html("");
    if (!VerifiedOrderObj) return;
    if ((VerifiedOrderObj.LinkedMasterOrderRowid==itemids)&&(itemids=="")){
		return;
	}
	var LinkMastStr = "^^^^^^";
	// "����"��ѡ,������ѽ��в�¼��ҽ��
	if ($("#NurseOrd").checkbox('getValue')) {
		for (key in VerifiedOrderObj) {
	        VerifiedOrderObj[key] = "";
	    }
		// �ÿչ���
    	NurseAddMastOrde(LinkMastStr);
    	LoadLinkedMasterOrdInfo();
    	window.setTimeout(function(){
            $("tr.jqgrow").css("background","#FFCCCC");
        }, 0);
    	return;
	}else{
		if (itemids=="") {
			for (key in VerifiedOrderObj) {
		        VerifiedOrderObj[key] = "";
		    }
			// �ÿչ���
			NurseAddMastOrde(LinkMastStr);
		}
		var itemArr = itemids.split("^");
		// ȡ��һ�� ��ҽ��
	    var itemid = itemArr[0];
	    var oneItem = cspRunServerMethod(GlobalObj.GetVerifiedOrder, itemid);
	    var VerifiedOrderArr = oneItem.split("^");
	    var Flag = VerifiedOrderArr[0];
	    if (Flag != "0") {
	        $("#Prompt").html("��ʾ��Ϣ:" + Flag);
	        for (key in VerifiedOrderObj) {
		        VerifiedOrderObj[key] = "";
		    }
	        // �ÿչ���
			NurseAddMastOrde(LinkMastStr);
	        return;
	    }
	    if (VerifiedOrderArr.length==1){
		    for (key in VerifiedOrderObj) {
		        VerifiedOrderObj[key] = "";
		    }
		    // �ÿչ���
    		NurseAddMastOrde(LinkMastStr);
    		return;
		}
		var OrderObj=GetVerifiedOrderObjObj(VerifiedOrderArr);
	    /*var OrderObj = {
            LinkedMasterOrderName: "",
            LinkedMasterOrderRowid: "",
            LinkedMasterOrderSeqNo: "",
            LinkedMasterOrderPriorRowid: "",
            LinkedMasterOrderFreRowId: "",
            LinkedMasterOrderFreFactor: "",
            LinkedMasterOrderFreInterval: "",
            LinkedMasterOrderFreDesc: "",
            LinkedMasterOrderFreqDispTimeStr:""
        }
        OrderObj.LinkedMasterOrderName = VerifiedOrderArr[1];
	    OrderObj.LinkedMasterOrderRowid = VerifiedOrderArr[2];
	    OrderObj.LinkedMasterOrderSeqNo = VerifiedOrderArr[3];
	    OrderObj.LinkedMasterOrderPriorRowid = VerifiedOrderArr[4];
	    var OrderFreStr = VerifiedOrderArr[5];
	    OrderObj.LinkedMasterOrderFreRowId = mPiece(OrderFreStr, String.fromCharCode(1), 0);
	    OrderObj.LinkedMasterOrderFreFactor = mPiece(OrderFreStr, String.fromCharCode(1), 1);
	    OrderObj.LinkedMasterOrderFreInterval = mPiece(OrderFreStr, String.fromCharCode(1), 2);
	    OrderObj.LinkedMasterOrderFreDesc = mPiece(OrderFreStr, String.fromCharCode(1), 3);
	    OrderObj.LinkedMasterOrderFreqDispTimeStr = mPiece(OrderFreStr, String.fromCharCode(1), 4);
	    OrderObj.LinkedMasterOrderFreqDispTimeStr=OrderObj.LinkedMasterOrderFreqDispTimeStr.split(String.fromCharCode(13)).join(String.fromCharCode(1));
	    OrderObj.LinkedMasterOrderSttDate = VerifiedOrderArr[6];*/
	    var OrderFreStr = VerifiedOrderArr[5];
	    var LessCurDateMsg="";
	    var SttDateLessCurDateFlag=VerifiedOrderArr[7];
	    if (SttDateLessCurDateFlag =="Y") {
		    LessCurDateMsg="�ǽ��ճ�����ע���ֹ���¼"+OrderObj.LinkedMasterOrderSttDate.split(" ")[0]+"ǰ����ʱҽ����";
		}
	    LinkMastStr = OrderObj.LinkedMasterOrderRowid + "^" + OrderObj.LinkedMasterOrderSeqNo + "^" + OrderObj.LinkedMasterOrderPriorRowid + "^" + OrderFreStr+ "^"+ OrderObj.LinkedMasterOrderSttDate;
	    LinkMastStr = LinkMastStr+ "^" + OrderObj.LinkedMasterOrderInstr+ "^" + OrderObj.LinkedMasterOrderInstrRowid;
	    $("#Prompt").html("<font COLOR=RED>��ǰ��ҽ��: " + OrderObj.LinkedMasterOrderName + "   ҽ��ID:" + OrderObj.LinkedMasterOrderRowid + " "+LessCurDateMsg + "</font>"); //"   ҽ��ID:" + OrderObj.LinkedMasterOrderRowid +
		$.extend(VerifiedOrderObj, OrderObj);
	    //��֤�Ѿ�¼�뵽�����ҽ�����й���
	    NurseAddMastOrde(LinkMastStr);
	    Add_Order_row();
	    var rowidsSub = $('#Order_DataGrid').getDataIDs();
        for (var Sub = 0; Sub < rowidsSub.length; Sub++) {
            var OrderARCIMRowid = GetCellData(rowidsSub[Sub], "OrderARCIMRowid");
            var OrderPriorRowid=GetCellData(rowidsSub[Sub], "OrderPriorRowid");
            if (OrderARCIMRowid =="") {
	            var LinkedMasterOrderPriorLongFlag=IsLongPrior(VerifiedOrderObj.LinkedMasterOrderPriorRowid);
	            // ��ҽ���ǳ���ҽ��,��¼����ҽ�������ǳ���
	            if ((LinkedMasterOrderPriorLongFlag)&&(!IsLongPrior(OrderPriorRowid))&&(OrderPriorRowid!=GlobalObj.OutOrderPriorRowid)) continue;
	        	var EditStatus = GetEditStatus(rowidsSub[Sub]);
	        	//ǿ��ģʽ
                if (GlobalObj.OrderPriorContrlConfig == 1) {
	                if (LinkedMasterOrderPriorLongFlag) {
		                if (EditStatus) {
			                SetCellData(rowidsSub[Sub], "OrderPrior", GlobalObj.LongOrderPriorRowid);
			            }else{
				            SetCellData(rowidsSub[Sub], "OrderPrior", "����ҽ��");
				        }
		                SetCellData(rowidsSub[Sub], "OrderPriorRowid", GlobalObj.LongOrderPriorRowid);
		                SetCellData(rowidsSub[Sub], "OrderPriorStr", GlobalObj.LongOrderPriorRowid + ":����ҽ��");
		            }else{
			            if (EditStatus) {
			                SetCellData(rowidsSub[Sub], "OrderPrior", GlobalObj.ShortOrderPriorRowid);
			            }else{
				            SetCellData(rowidsSub[Sub], "OrderPrior", "��ʱҽ��");
				        }
			            SetCellData(rowidsSub[Sub], "OrderPriorRowid", GlobalObj.ShortOrderPriorRowid);
		                SetCellData(rowidsSub[Sub], "OrderPriorStr", GlobalObj.ShortOrderPriorRowid + "��ʱҽ��");
			        }
	            }else{
		            if (LinkedMasterOrderPriorLongFlag) {
			            SetCellData(rowidsSub[Sub], "OrderPrior", GlobalObj.LongOrderPriorRowid);
			            SetCellData(rowidsSub[Sub], "OrderPriorRowid", GlobalObj.LongOrderPriorRowid);
			        }else{
				        SetCellData(rowidsSub[Sub], "OrderPrior", GlobalObj.ShortOrderPriorRowid);
				        SetCellData(rowidsSub[Sub], "OrderPriorRowid", GlobalObj.ShortOrderPriorRowid);
				    }
		        }
		        
	        }
         }
	}
}
function NurseOrdClickHandler(value){
    if (value) {
        SetVerifiedOrder("");
        window.setTimeout(function(){
            $("tr.jqgrow").css("background","#FFCCCC");
        }, 0);
    }else{
         $("#orderListShow")[0].contentWindow.ipdoc.patord.view.SetVerifiedOrder(true);
         window.setTimeout(function(){
            $("tr.jqgrow").css("background","");
        }, 0);
    }
}
function SynchroOrdNotesClickHandler(){
	var ids = $('#Order_DataGrid').jqGrid("getGridParam", "selarrrow");
    if (ids == null || ids.length == 0 || ids.length == 1) {
        $.messager.alert("����", "��ѡ����Ҫͬ����ע�Ķ��м�¼��");
        return;
    }
    var Find=0;
    //ids = ids.sort();
    var FirstOrdNotes=GetCellData(ids[0], "OrderDepProcNote");
    var len = ids.length;
    for (var i = 1; i < len; i++) {
	    var OrderARCIMRowid = GetCellData(ids[i], "OrderARCIMRowid");
	    //�հ��к�����˵Ĳ���ͬ��
	    if ((OrderARCIMRowid!="")&&(CheckIsItem(ids[i]) == false)) {
		    SetCellData(ids[i], "OrderDepProcNote",FirstOrdNotes);
		    Find=1;
		}
	}
	if (Find=="0"){
		$.messager.alert("����", "û����Ҫͬ���ļ�¼!");
        return;
	}
}
function ShowNotPayOrdClickHandler(){
	ReloadGrid("update","");
}
function LoadLinkedMasterOrdInfo(){
    ReloadGrid("LoadLinked");
}
/// ��ʿ�����ҽ�����Զ�ѡ��ҽ���б��е���һ��ҽ���б�
function ReloadGridData(Progress){
	/*
	ExaReport:�������������ر�ʱ�ص�
	Update:���ҽ����ص�
	*/
	PageLogicObj.fpArr=[];
	if (VerifiedOrderObj) {
		var LinkedMasterOrderRowid=VerifiedOrderObj.LinkedMasterOrderRowid;
	}else{
		var LinkedMasterOrderRowid=""
	}
    var NurseOrd=$("#NurseOrd").is(":checked");
    var functionExist=typeof $("#orderListShow")[0]=='object'?(typeof $("#orderListShow")[0].contentWindow.ipdoc.patord.view.SelNextDocOrd):("");
    if ((LinkedMasterOrderRowid!="")
        &&(!NurseOrd)
        &&(functionExist=="function")){
        /*
        ��˺������һ���������������˵���;
        LoadLinkedMasterOrdInfo��󻹻��ߵ�ReloadGrid����ȥ���ᵼ������˵�ҽ���浽session��ȥ
        */
        if (Progress=="Update"){
            ClearSessionData();
            var rowids = $('#Order_DataGrid').getDataIDs();
            for (var i = 0; i < rowids.length; i++) {
                var OrderItemRowid = GetCellData(rowids[i], "OrderItemRowid");
                var OrderARCIMRowid = GetCellData(rowids[i], "OrderARCIMRowid");
                if ((OrderItemRowid == "") || (OrderARCIMRowid != "")) {
                    $('#Order_DataGrid').delRowData(rowids[i]);
                }
            }
			$("#ScreenBillSum").val(0.00);
        }
        var text=$("#OrderTemplate_Btn .l-btn-text")[0].innerText;
        var lastLayout = $("#LayoutContrl").val();
        if ((UIConfigObj.DefaultPopTemplate == true)&&(text.indexOf('ģ��') >= 0)&&(lastLayout!="")) {
	        RefreshOderList("Next");
	    }else{
	        var text=$("#OrderTemplate_Btn .l-btn-text")[0].innerText;
	        if (text.indexOf('�б�') >=0){
		        $("#OrderTemplate").hide("fast","swing");
	        	OrdTempBtnTextChange(lastLayout,"ҽ��ģ��");
	        	$("#OrderList").show("fast","swing",setTimeout(function(){
		        	RefreshOderList("Next");
		        }));
		        
	        }else{
		        RefreshOderList("Next");
		    }
        }
        //ѡ����һ��ҽ��
        //RefreshOderList("Next");
    }else{
        ReloadGrid();
        RefreshOderList();
    }
}

function ClearVerifiedOrder() {
    $("#Prompt").html("");
    for (key in VerifiedOrderObj) {
        VerifiedOrderObj[key] = "";
    }
    //��ʿ��¼ҽ��ˢ������Ҳ�ѡ�У�����Ѿ������Ĺ�ϵ
    try {
        var par_win = window.parent.parent.parent.left.RPbottom
        if (par_win) {
            par_win.ClearCheck();
            NurseAddMastOrde("^^^^^^", "");
        }
    } catch (e) {

    }
}
//����ҩ�����ӿ����
function ICheckDoctorTypePoison(OrderPoisonRowid, icode, Row, OrderPoisonCode, callBackFun) {
	new Promise(function(resolve,rejected){
		CheckDoctorTypePoison_7(OrderPoisonRowid, icode, Row, OrderPoisonCode,resolve);
	}).then(function(PrescCheck){
		callBackFun(PrescCheck);
	})
    /*var PrescCheck = CheckDoctorTypePoison_7(OrderPoisonRowid, icode, Row, OrderPoisonCode);
    if (PrescCheck == false) { return false; }*/
}
function DeleteAntReason(CurrentRow) {
    var UserReasonId = GetCellData(CurrentRow, "UserReasonId");
    if ((UserReasonId != "") && (GlobalObj.ReasonCanBeDeletedMethod != "")) {
        var rtn = cspRunServerMethod(GlobalObj.ReasonCanBeDeletedMethod, UserReasonId);
        if ((rtn == 1) && (GlobalObj.DeleteAntReasonMethod != "")) {
            var ret = cspRunServerMethod(GlobalObj.DeleteAntReasonMethod, UserReasonId);
        }
    }
}
//��� ����ҩ���鷽����
function CheckAuditItem() {
    if (GlobalObj.AuditFlag == 1) { GlobalObj.AuditFlag = ""; return true; } else { return false; }
}
function CheckSuscept(episodeid, arcim) {
    var ret = 0;
    if (GlobalObj.CheckSusceptMethod != "") {
        var ret = cspRunServerMethod(GlobalObj.CheckSusceptMethod, episodeid, arcim);
        return ret;
    }
    return ret
}
function CheckInDurSameIM(ImRowid, Row) {
    var EpisodeID = GlobalObj.EpisodeID
    var flag = false;
    if (GlobalObj.CheckInDurSameIMMethod != "") {
        var ret = cspRunServerMethod(GlobalObj.CheckInDurSameIMMethod, EpisodeID, ImRowid);
        var retArr = ret.split("^")
        var ret1 = retArr[0];
        if (ret1 == 2) {
            var UserReasonID = retArr[1];
            SetCellData(Row, "UserReasonId", UserReasonID)
            flag = true
        }
    }
    return flag;
}
function CheckCMMRDiagnos(itemCatRowID) {
    //$.messager.alert("����",itemCatRowID);
    var flag = false;
    var ret = tkMakeServerCall("web.DHCDocIPBookingCtl", "GetCMMRDiagnosByEpisode", GlobalObj.EpisodeID);
    //û����ҽ���
    if (ret == "N") {
        var MedItemCat = MedItemCatStr.split("^")
        for (var i = 0; i < MedItemCat.length; i++) {
            if (MedItemCat[i] == itemCatRowID) {
                flag = true;
            }
        }
    } else {
        flag = true;
    }
    return flag;
}

//�򿪴�����ӡ����--20150108--lrf
function PrescriptList() {
    var posn = "height=" + (screen.availHeight - 40) + ",width=" + (screen.availWidth - 10) + ",top=0,left=0,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes";
    var path = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCPrescript.Print&PatientID=" + GlobalObj.PatientID + "&EpisodeID=" + GlobalObj.EpisodeID + "&mradm=" + GlobalObj.mradm + "&WardID=";
    websys_createWindow(path, false, posn);
}
//�����Ƶ�����--20150108--lrf
function LabPrintList() {
    var posn = "height=" + (screen.availHeight - 40) + ",width=" + (screen.availWidth - 10) + ",top=0,left=0,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes";
    var path = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCOrderItem.Lab.Print&PatientID=" + GlobalObj.PatientID + "&EpisodeID=" + GlobalObj.EpisodeID + "&mradm=" + GlobalObj.mradm + "&WardID=";
    websys_createWindow(path, false, posn);
}
function CheckPermissionByARC(icode, OrderDesc) {
    return true;
    try {
        var ret = tkMakeServerCall("web.DHCST.Common.DrugInfoCommon", "GetMangerDrugByARC", icode);
        if ((ret == "") || (ret == null)) return true;
        ret = ret.split("^");
        var UserID = session['LOGON.USERID'];

        var MangerDrug = MangerDrugStr.split("^");

        for (var i = 0; i < MangerDrugStr.length; i++) {
            if (ret[1] == MangerDrug[i]) {
                var flag = tkMakeServerCall("web.DHCDocCommon", "GetPermissionsByUserID", UserID);
                if (flag != 1) {
                    $.messager.alert("����",OrderDesc + ",��Ȩ�޿���ҩ")
                    return false;
                }
            }
        }
    } catch (e) {}
    return true;
}

function StopOrderItem() {
    var OrdList = "";
    var MastRowId = "";
    var NeedStopOrdArr = new Array();
    var rowids = GetAllRowId();
    for (var i = 0; i < rowids.length; i++) {
        //ȡ��ҽ��
        if ((document.getElementById("jqg_Order_DataGrid_" + rowids[i]).checked != true))
            continue;
        if (CheckIsItem(rowids[i]) == false) { continue; }
        var OEORIRowId = GetCellData(rowids[i], "OrderItemRowid");
        if (OEORIRowId==""){continue;}
        NeedStopOrdArr.push(rowids[i]);
    }

    if (NeedStopOrdArr.length>0) {
	    new Promise(function(resolve,rejected){
			StopOrd(NeedStopOrdArr,resolve);
		}).then(function(){
			ReloadGrid("StopOrd");
		    OrderMsgChange();
		    SaveOrderToEMR();
		})
    } else {
        $.messager.alert("����", "�����������Ŀ�Ϲ�ѡҪֹͣ����Ŀ");
        return true;
    }
}
//������ʹ��tab����ת��,�س�����Ϊ����Ĳ�ȷ����(�����е�����)����Ӧ�Ĵ����¼��д�����ת
function Doc_OnKeyDown(e) {
    if (GlobalObj.warning != "") {
	    $(".messager-button a").click(); //�Զ��ر���һ��alert����
        $.messager.alert("����",GlobalObj.warning);
        return false;
    }
	//��ֹ�ڿհ״����˸���������Զ����˵���һ������
	if (!websys_cancelBackspace(e)) return false;
	//�������Backspace������  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;   
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }  
    if(keyEvent){   
        e.preventDefault();   
    }   
	
	var nowLayout=$("#LayoutContrl").val();
	if (nowLayout=="" )nowLayout="Orderlist";
    var rowid = GetEventRow(e);

    var nextRowid = parseInt(rowid) + 1;
    var obj = websys_getSrcElement(e);
    var name = obj.name;
    var keycode = websys_getKey(e);
    /*
    if(name=="OrderDepProcNote"&&(keycode==9||keycode==13)){
       Add_Order_row();
       SetFocusCell(nextRowid,"OrderName");  
    }
    */
    if (keycode == 9) {
	    var OrderFreqObj = document.getElementById(rowid + "_OrderFreq");
        var OrderDurObj = document.getElementById(rowid + "_OrderDur");
        var OrderPackQtyObj = document.getElementById(rowid + "_OrderPackQty");
        if (obj.id == (rowid + "_OrderInstr")) {
            if (OrderFreqObj && (OrderFreqObj.disabled == false)) {
                SetFocusCell(rowid, "OrderFreq");
            } else if (OrderDurObj && (OrderDurObj.disabled == false)) {
                SetFocusCell(rowid, "OrderDur");
            } else if (OrderPackQtyObj && (OrderPackQtyObj.disabled == false)) {
                SetFocusCell(rowid, "OrderPackQty");
            } else {
                window.setTimeout("Add_Order_row()", 200);
            }
        }
        if (obj.id == (rowid + "_OrderDoseUOM")) {
            var OrderInstrObj = document.getElementById(rowid + "_OrderInstr");
            if (OrderInstrObj && (OrderInstrObj.disabled == false)) {
                SetFocusCell(rowid, "OrderInstr");
            } else {
                SetFocusCell(rowid, "OrderFreq");
            }
        }
        if (obj.id == (rowid + "_OrderDepProcNote")) {
            window.setTimeout("Add_Order_row()", 200);
        }
        if (obj.id == (rowid + "_OrderFreq")) {
	        if (OrderDurObj && (OrderDurObj.disabled == false)) {
                SetFocusCell(rowid, "OrderDur");
            } else if (OrderPackQtyObj && (OrderPackQtyObj.disabled == false)) {
                SetFocusCell(rowid, "OrderPackQty");
            } else {
                window.setTimeout("Add_Order_row()", 200);
            }
        }
        
    }/*else if(keycode == 13){
	    var d=e.srcElement||e.target;   
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            return false;   
        }else{   
            return true;  
        }
	}*/
    if (e){
        var ctrlKeyFlag=e.ctrlKey;
    }else{
        var ctrlKeyFlag=window.event.ctrlKey;
    }
    if (ctrlKeyFlag){
        if (event.keyCode == 83){ //����ҽ��
            UpdateClickHandler();
        }else if(event.keyCode == 65){ //���ģ��ҽ��
            MultiTemplOrdEntry(e);
            return false;
        }else if(event.keyCode == 82){ //���� �����
            ChangeOrderSeqhandler(e);
            return false;
        }else if(event.keyCode == 90){ //����ҽ�� 67
            if (GlobalObj.PAAdmType != "I") {
                StopOrderItem(e);
            }
        }else if(event.keyCode == 80){ //һ����ӡ
           /*if (GlobalObj.PAAdmType != "I") {
               BtnPrtClickHandler(e);
           }*/
        }/*else if(event.keyCode == 86){ //ctrl +v;�����������ճ�������ݵ�����
            var rowid = Add_Order_row();
            var text=window.clipboardData.getData("Text");
            jQuery('#'+rowid+"_OrderName").val(text);
        }*/
        //return false;
    }
    if ((((e.target)&&(e.target.id.indexOf("OrderDoseQty")>=0))||(PageLogicObj.LookupPanelIsShow==1))&&((keycode==40)||(keycode==38))) return;
    if(keycode==40){    //���·����
		if ((("#orderListShow").length>0)&&(nowLayout=="Orderlist")&&(!HaveLookupGrid())){
			var e = jQuery.Event("keydown");
            e.keyCode=keycode;
            e.which=keycode;
			$("#orderListShow")[0].contentWindow.ipdoc.patord.view.BubbleKeyDown(e);
		}	
	}
	if(keycode==38){    //���Ϸ����
		if ((("#orderListShow").length>0)&&(nowLayout=="Orderlist")&&(!HaveLookupGrid())){
			var e = jQuery.Event("keydown");
            e.keyCode=keycode;
            e.which=keycode;
			$("#orderListShow")[0].contentWindow.ipdoc.patord.view.BubbleKeyDown(e);
		}	
	}
	if ((e.keyCode==13)&&($(".window-mask").is(":visible"))){
	    return false;   
    }
}
function HaveLookupGrid(){
	//return false;
	if ((ItemzLookupGrid && ItemzLookupGrid.store)
		||(PHCFRDesczLookupGrid && PHCFRDesczLookupGrid.store)
		||(PHCDUDesczLookupGrid && PHCDUDesczLookupGrid.store)
		||(PHCINDesczLookupGrid && PHCINDesczLookupGrid.store)){
			return true;
	}else{
		return false;
	}
}
//��Һ����change�¼�
function OrderLocalInfusionQty_changehandler(e) {
    var Row = GetEventRow(e);
    ChangeLinkOrderLocalInfusionQty(Row);
}

//��Һ����ͬ��  
function ChangeLinkOrderLocalInfusionQty(Row) {
    try {
        var OrderLocalInfusionQtyMain = GetCellData(Row, "OrderLocalInfusionQty").replace(/(^\s*)|(\s*$)/g, '');
        var RowArry = GetSeqNolist(Row)
        for (var i = 0; i < RowArry.length; i++) {
	        var OrderType = GetCellData(RowArry[i], "OrderType");
    		if (OrderType!="R") continue;
            SetCellData(RowArry[i], "OrderLocalInfusionQty", OrderLocalInfusionQtyMain)
        }
    } catch (e) { dhcsys_alert(e.message) }
}

//��Һ����
function OrderSpeedFlowRate_changehandler(e) {
    var Row = GetEventRow(e);
    ChangeOrderSpeedFlowRate(Row)
}
//��Һ����ͬ��  
function ChangeOrderSpeedFlowRate(Row) {
    try {
        var OrderSpeedFlowRatemain = GetCellData(Row, "OrderSpeedFlowRate").replace(/(^\s*)|(\s*$)/g, '');
        var RowArry = GetSeqNolist(Row)
        for (var i = 0; i < RowArry.length; i++) {
	        var OrderType = GetCellData(RowArry[i], "OrderType");
    		//if (OrderType!="R") continue;
            SetCellData(RowArry[i], "OrderSpeedFlowRate", OrderSpeedFlowRatemain)
        }
    } catch (e) { dhcsys_alert(e.message) }
}

function OrderEndDate_changehandler(e) {
    var Row = GetEventRow(e);
    ChangeLinkOrderEndDate(Row)
}

function ChangeLinkOrderEndDate(Row) {
    try {
        var OrderEndDate = GetCellData(Row, "OrderEndDate")
        var RowArry = GetSeqNolist(Row)
        for (var i = 0; i < RowArry.length; i++) {
            SetCellData(RowArry[i], "OrderEndDate", OrderEndDate)
        }
    } catch (e) { dhcsys_alert(e.message) }
}

function OrderDate_changehandler(e) {
    var Row = GetEventRow(e);
    ChangeLinkOrderDate(Row);
    //var OrderStartDate=GetCellData(Row, "OrderDate");
    var OrderDate = GetCellData(Row, "OrderDate");
    if (OrderDate!="") {
	    var CurDate=new Date();
	    var tmpOrderDate=OrderDate.split(" ")[0];
	    if (PageLogicObj.defaultDataCache=="4"){
		    var tmpOrderDate=tmpOrderDate.split("/")[2]+"/"+tmpOrderDate.split("/")[1]+"/"+tmpOrderDate.split("/")[0]
		    var tmpOrderDate = new Date(tmpOrderDate+" "+OrderDate.split(" ")[1]);
		}else{
			var tmpOrderDate = new Date(tmpOrderDate.replace(/-/g, "/")+" "+OrderDate.split(" ")[1]);
		}
		if (tmpOrderDate>CurDate) {
			SetCellData(Row, "OrderStartDate",OrderDate);
			OEORISttDatchangehandler(e);
		}
	}
    $("#"+Row+"_OrderDate").parent()[0].title=OrderDate;
    //���ݿ�ҽ�������л����տ���
    var ARCIMRowId = GetCellData(Row, "OrderARCIMRowid");
    if (ARCIMRowId !="") {
	    var CalRecLocStrJson = GetReclocByOrdDate(Row);
	    var CalRecLocStrObj=eval("(" + CalRecLocStrJson + ")");
	    if (CalRecLocStrObj.NotChangeRecLocStr =="N") {
		    var OldOrderRecDepRowid=GetCellData(Row, "OrderRecDepRowid");
		    var newCurrentRecLocStr=CalRecLocStrObj.CurrentRecLocStr;
	        SetColumnList(Row, "OrderRecDep", newCurrentRecLocStr);
	        OrderRecDepChangeCom(Row);
		}
	}
}
function GetReclocByOrdDate(Row) {
    // ���ݿ�ҽ��ʱ���л����տ���
    var OrdDateReclocStr = "";
    var OrderInstrRowid = GetCellData(Row, "OrderInstrRowid");
    var InstrOrderType = GetCellData(Row, "OrderType");
    var OrderHiddenPara = GetCellData(Row, "OrderHiddenPara");
    var OrderItemCatRowid = mPiece(OrderHiddenPara, String.fromCharCode(1), 2);
    var InstrPriorRowid = GetCellData(Row, "OrderPriorRowid");
    var ARCIMRowId = GetCellData(Row, "OrderARCIMRowid");
    var OrderPriorRemarksRowId = GetCellData(Row, "OrderPriorRemarksRowId");
    var OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
    var OrdOutPriorRecLocStr=GetCellData(Row, "OrderOutPriorRecLocStr");
    var OrderOnePriorRecLocStr = GetCellData(Row, "OrderOnePriorRecLocStr");
    var CurrentRecLocStr = GetCellData(Row, "CurrentRecLocStr")
    //��ҽ������
    var OrderDateStr = GetCellData(Row,"OrderDate");
    //�������¼����ȡ���տ���?�Ͱѵ�¼���Ҵ���ȥ session['LOGON.CTLOCID']
    var LogonDep = GetLogonLocByFlag();
    //��Ժ
    var OrderOpenForAllHosp=$("#OrderOpenForAllHosp").checkbox('getValue')?1:0;
    var OrdDepRowId = GetLogonLocByFlag();
    var HOSPID = session['LOGON.HOSPID'];
    var CurLogonDep=session['LOGON.CTLOCID'];
    
    var OrdParamObj={
	    EpisodeID:GlobalObj.EpisodeID,
	    ARCIMRowId:ARCIMRowId,
	    OrderPriorRowid:OrderPriorRowid,
	    OrderPriorRemarksRowId:OrderPriorRemarksRowId,
	    OrderInstrRowid:OrderInstrRowid, 
	    OrdDepRowId:OrdDepRowId, 
	    CurLogonDep:CurLogonDep,
	    OrderDateStr:OrderDateStr,
	    OrderOpenForAllHosp:OrderOpenForAllHosp,
	    OrdOutPriorRecLocStr:OrdOutPriorRecLocStr,
	    OrderOnePriorRecLocStr:OrderOnePriorRecLocStr,
	    CurrentRecLocStr:CurrentRecLocStr
	}
	var OrdParamJson=JSON.stringify(OrdParamObj);
    var CalRecLocStrJson = tkMakeServerCall("web.DHCDocOrderCommon","GetRecLocStrByOrdDate", OrdParamJson)
    return CalRecLocStrJson;
}
function ChangeLinkOrderDate(Row) {
    try {
        var OrderDate = GetCellData(Row, "OrderDate")
        var RowArry = GetSeqNolist(Row)
        for (var i = 0; i < RowArry.length; i++) {
            SetCellData(RowArry[i], "OrderDate", OrderDate);
            var obj = document.getElementById(RowArry[i]+"_OrderDate");
            if (obj) {
	            $("#"+RowArry[i]+"_OrderDate").parent()[0].title=OrderDate;
	        }else{
		        $("#"+RowArry[i]+"_OrderDate")[0].title=OrderDate;
		    }
        }
    } catch (e) { dhcsys_alert(e.message) }
}

//һ����ӡ
function BtnPrtClickHandler() {
    var PatientID = GlobalObj.PatientID;
    var MRADMID = GlobalObj.mradm;
    var EpisodeID = GlobalObj.EpisodeID;
    var userid = session['LOGON.USERID'];
    var ctlocid = session['LOGON.CTLOCID'];
    //var PrtClick=new PrtClickInfo(EpisodeID,PatientID,MRADMID,ctlocid,userid)
    var lnk = "oeorder.printall.csp?PatientID=" + PatientID + "&EpisodeID=" + EpisodeID
    window.open(lnk, true, "status=1,scrollbars=1,top=20,left=10,width=1300,height=690");

}

function UpdateClickHandlerFinish() {
    /*var Url=window.location.href
    var HeadUrl=Url.split("?")[0]
    var BackUrl=Url.split("?")[1]
    var strArr=BackUrl.split("&")
    var strArrNew=strArr.slice(0,strArr.length-2)
    ////���ͨ��ҽ����ҽ������ҽ�����֮��ҽ���ظ�����
    var NewStr=strArrNew.join("&")+"&copyOeoris=&copyTo="; 
    var Url=HeadUrl+"?"+NewStr
    window.location.href=Url*/
    window.location.href = window.location.href;
}
//��ѡ�еĵ�һ��ҽ��Ϊ׼�� ͬ��ѡ��ҽ��ʱ������
function SynBtnClickHandler() {
    try {
        var ids = $('#Order_DataGrid').jqGrid("getGridParam", "selarrrow");
        if (ids == null || ids.length == 0 || ids.length == 1) {
            $.messager.alert("����", "��ѡ����Ҫͬ���Ķ��м�¼");
            return;
        }
        ids = ids.sort();
        var OrderStartDateMain = GetCellData(ids[0], "OrderStartDate")
        var OrderDateMain = GetCellData(ids[0], "OrderDate")
        var len = ids.length;
        for (var i = 1; i < len; i++) {
            //�����ҽ������ͬ��
            if (CheckIsItem(ids[i]) == false) {
                SetCellData(ids[i], "OrderStartDate", OrderStartDateMain);
                SetCellData(ids[i], "OrderDate", OrderDateMain);
				SetOrderFirstDayTimes(ids[i]);
            }
        }
        $.messager.alert("����", "ҽ��ʱ��ͬ����ɡ���ȷ��!");
    } catch (e) {};
}
//�ж������Ƿ����޸�Ȩ��
//1 �������ò������޸�����ʱ��,ҽ������չ�趨������գ����ж�
//2 ������չ�����޸ģ�ҽ���������޸� ���ж�
//3 �������������޸ģ�ҽ������չ����������Ҫ�ж�
//4 �������ò������޸ģ�ҽ������չ����������Ҫ�ж�
//5 ҽ������չ�趨δά�����߿���Ȩ��
// true ��Ҫ�ж� ����Ҫ�ж�
function CheckDateTimeModifyFlag(ModifyDateTimeAuthority,IsCanCrossDay){
	if (IsCanCrossDay=="N") {
		return false;
	}else if (IsCanCrossDay=="Y") {
		return true;
	}else{
		//δ����ҽ������չ�趨,�߿���Ȩ��
		if (ModifyDateTimeAuthority!="1") return false;
	}
	return true;
}
//���÷��ֶ���¼ҽ������
function AddLinkItemToList(ParaArr, MasterOrderItemRowId, MasterOrderSeqNo, MasterOrderPriorRowid, MasterOrderFreqStr, MasterOrderStartDate, MasterOrderStartTime) {
	
	var OrdParamsArr=new Array();
	for (var i = 0,length = ParaArr.length; i < length; i++) {
		var para1 = ParaArr[i].split("!")
        var icode = para1[0];
        var seqno = para1[1];
        var ItemOrderType = para1[2];
        var linkqty = para1[4];
		if (CheckDiagnose(icode)) {
			OrdParamsArr[OrdParamsArr.length]={
				OrderARCIMRowid:icode
			};
		}
	}
	var RtnObj = AddItemToList("",OrdParamsArr, "obj", "");
	var rowid=RtnObj.rowid;
	var returnValue=RtnObj.returnValue;
	if (returnValue == true) { Add_Order_row() }
    SetVerifiedOrder(MasterOrderItemRowId);
}

//Э���װ,2014-05-30,by xp,Start
//��ʼ����Ҫ���տ��һ���ҽ����ID,ע���ʼ��λ����ǰ������֮����и�ֵ
function GetBillUOMStr(rowid,SpecOrderPackUOMRowid) {
    if (typeof SpecOrderPackUOMRowid == "undefined") { SpecOrderPackUOMRowid="" }
    var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
    var OrderRecDepRowid = GetCellData(rowid, "OrderRecDepRowid");
    //ȡЭ���װ��λ
    if (OrderRecDepRowid != "") {
        var BillUOMStr = cspRunServerMethod(GlobalObj.GetBillUOMStrMethod, OrderARCIMRowid, OrderRecDepRowid, "OrderEntry","",GlobalObj.PAAdmType);
        if (SpecOrderPackUOMRowid==""){
            SetColumnList(rowid, "OrderPackUOM", BillUOMStr);
            SetCellData(rowid, "OrderPackUOMStr", BillUOMStr);
        }else{
            ReSetBillUomBySpecPackUOM(rowid,BillUOMStr,SpecOrderPackUOMRowid);
            SetCellData(rowid, "OrderPackUOMStr", BillUOMStr);
        }
        OrderPackUOMchangeCommon(rowid);
    }
}
function ReSetBillUomBySpecPackUOM(rowid,BillUOMStr,SpecOrderPackUOMRowid){
    var DefaultOrderPackUOM = "";
    var DefaultOrderPackUOMDesc = "";
    var ArrData = BillUOMStr.split(String.fromCharCode(2));
    for (var i = 0; i < ArrData.length; i++) {
        var ArrData1 = ArrData[i].split(String.fromCharCode(1));
        if ((ArrData1[0] == SpecOrderPackUOMRowid)&&(SpecOrderPackUOMRowid!="")&&(SpecOrderPackUOMRowid!=undefined)) {
            var DefaultOrderPackUOM = ArrData1[0];
            var DefaultOrderPackUOMDesc = ArrData1[1];
        }
    }
    if (DefaultOrderPackUOM != "") {
        SetCellData(rowid, "OrderPackUOMRowid", DefaultOrderPackUOM);
        if (UIConfigObj.isEditCopyItem == true) {
            SetCellData(rowid, "OrderPackUOM", DefaultOrderPackUOM);
        }else{
            SetCellData(rowid, "OrderPackUOM", DefaultOrderPackUOMDesc);
        }
        
    }
}
function OrderPackUOMchangehandler(e) {
    var Row = GetEventRow(e);
    OrderPackUOMchangeCommon(Row);
    SetPackQty(Row);
    SetScreenSum();
}
function OrderPackUOMchangeCommon(Row) {
    var Id = Row + "_" + "OrderPackUOM";
    var obj = document.getElementById(Id);
    if ((obj) && (obj.type == "select-one")) {
        var selIndex = obj.selectedIndex;
        var PackUOMRowid = ""
        if (selIndex != -1) { PackUOMRowid = obj.options[selIndex].value; }
        SetCellData(Row, "OrderPackUOMRowid", PackUOMRowid);
        SetCellData(Row, "OrderPackUOM", PackUOMRowid);
    }
    GetOrderPriceConUom(Row);
    XHZY_Click();
}
// ���ݵ�λ�仯,ȡҽ������װ�۸�-----���¼���ÿ�к��ܼ۸�
function GetOrderPriceConUom(Row) {
    var LogonDep = GetLogonLocByFlag();
    if (GlobalObj.PAAdmType != "I") {
        OrderBillTypeRowid = GetPrescBillTypeID();
    } else {
        OrderBillTypeRowid = GlobalObj.BillTypeID;
    }
    var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
    if ($("#OrderOpenForAllHosp").checkbox("getValue")){
	    var OrderOpenForAllHosp="1";
	}else{
		var OrderOpenForAllHosp="0";
	}
    var OrderPackUOMRowid = GetCellData(Row, "OrderPackUOMRowid");
    if (OrderPackUOMRowid == "") return;
    var OrderRecDepRowid = GetCellData(Row, "OrderRecDepRowid");
    var OrderMaterialBarCode = GetCellData(Row, "OrderMaterialBarcodeHiden");
    var ExpStr = OrderMaterialBarCode
    var retPrice = cspRunServerMethod(GlobalObj.GetOrderPriceConUomMethod, GlobalObj.EpisodeID, OrderBillTypeRowid, LogonDep, OrderARCIMRowid, OrderOpenForAllHosp, OrderPackUOMRowid, OrderRecDepRowid, ExpStr);
    var ArrPrice = retPrice.split("^");
    var Price = ArrPrice[0];
    var OrderConFac = ArrPrice[4];
    if (Price < 0) {
        $.messager.alert("����","�˽��տ���������Чҽ����,���л����տ��һ���ϵ�����Ա����")
        websys_setfocus('OrderRecDep');
        var Price = ""
    }
    SetCellData(Row, "OrderPrice", Price);
    SetCellData(Row, "OrderConFac", OrderConFac);
    //------------�޸�Э�鵥λ���ı�ÿ�м۸���ܼ�
    var OrderPackQty = GetCellData(Row, "OrderPackQty");
    OrderPackQty = OrderPackQty.replace(/(^\s*)|(\s*$)/g, '');
    if (!isNumber(OrderPackQty) || (OrderPackQty == "")) {
        OrderPackQty = 1
    }
    var OrderSum = parseFloat(Price) * OrderPackQty;
    SetCellData(Row, "OrderSum", OrderSum);
    //SetScreenSum();
    //�����������¼���
    SetOrderUsableDays(Row)
    //ת����λ������װ�����޹�
    //SetPackQty(Row);
}
//Э���װ-----------end---------

//-------------ҽ������ begin------------
function CreaterOrderInsurCat(rowid,ReSetInsurCatFlag) {
	if (typeof ReSetInsurCatFlag=="undefined"){
		ReSetInsurCatFlag="Y";
	}
    //ҽ����
    var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
    //�ѱ�
    var OrderBillTypeRowid = GetCellData(rowid, "OrderBillTypeRowid");
    //ҽ������
    var InsurCatStr = cspRunServerMethod(GlobalObj.GetArcimInsurCat, OrderARCIMRowid, OrderBillTypeRowid,session['LOGON.HOSPID']);
    if (InsurCatStr!=""){
	    if ((InsurCatStr.split(String.fromCharCode(2)).length>1)&&(ReSetInsurCatFlag=="Y")) {
		    SetColumnList(rowid, "OrderInsurCat", InsurCatStr);
		    SetCellData(rowid, "OrderInsurCatHideen", InsurCatStr);
		    var InsurAlertStr=tkMakeServerCall("web.DHCINSUPort","ArcimLinkTarStr",OrderARCIMRowid,OrderBillTypeRowid,session['LOGON.HOSPID']);
			websys_showModal({
				url:"../csp/dhcdocindicationschoose.hui.csp",
				title:'��ѡ��ҽ����Ӧ֢',
				width:800,height:600,
				InsurAlertStr:InsurAlertStr.split("^").join("!"),
				showCancelBtnFlag:"N",
				closable:false,
				CallBackFunc:function(OrderInsurCatRowId){
					websys_showModal("close");
					if (typeof OrderInsurCatRowId=="undefined"){
						OrderInsurCatRowId="";
					}
					SetCellData(rowid, "OrderInsurCat", OrderInsurCatRowId);
        			SetCellData(rowid, "OrderInsurCatRowId", OrderInsurCatRowId);
        			OrderInsurCatchangeCommon(rowid);
				}
			})
		}else{
		    SetColumnList(rowid, "OrderInsurCat", InsurCatStr);
		    SetCellData(rowid, "OrderInsurCatHideen", InsurCatStr);
		    OrderInsurCatchangeCommon(rowid);
	    }
    }
}
function OrderInsurchangehandler(e) {
    var Row = GetEventRow(e);
    OrderInsurCatchangeCommon(Row)
}
function OrderInsurCatchangeCommon(Row) {
    var Id = Row + "_" + "OrderInsurCat";
    var obj = document.getElementById(Id);
    if ((obj) && (obj.type == "select-one")) {
        var selIndex = obj.selectedIndex;
        var OrderInsurCatRowId = ""
        if (selIndex != -1) { OrderInsurCatRowId = obj.options[selIndex].value; }
        SetCellData(Row, "OrderInsurCat", OrderInsurCatRowId);
        SetCellData(Row, "OrderInsurCatRowId", OrderInsurCatRowId);
    }
}
//-------------ҽ������  end--------------

//-----------------------֪ʶ��ӿ�  begin-----------------------------
//֪ʶ��ӿ�
//Active C ���� Q ��ѯ  A ҽ������
//RowIn  ������(��ʼ����ע) Update���ҽ����־
//RowIn ����ĳһ��ҩƷ��Ϣ
function CheckLibPhaFunction(Active, RowIn, Update) {
	
    //if (Active=="C") return true;
    //C "",""
    //Q 1 ""
    //�Ƿ���֪ʶ��
    if (GlobalObj.ZSKOpen != 1) { return true }
    var Type = ""
    var OrderMesage = GetCheckLibPhaOrder(RowIn)
    if ((OrderMesage == "") && (Active != "A")) { return true; }

    var UserInfo = session['LOGON.USERID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'];
    var OrderItem = ""
    if (Active == "C") {
        OrderItem = tkMakeServerCall('web.DHCDocService', 'GetAdmOrdStr', GlobalObj.EpisodeID)
    }
    var ReturnStr = cspRunServerMethod(GlobalObj.CheckLibPha, GlobalObj.EpisodeID, Active, OrderItem, OrderMesage, UserInfo)
    var ReturnStrArry = ReturnStr.split("^")
    if (Active=="C"){
       var rtn = "0"; //ͨ�� 0 1 ��
       var ControlLev = ""; //���Ƽ��� 0 1 ��
       var Mesage = "";
        if (ReturnStrArry[0]!=""){
            var rtnObj=eval("("+ReturnStrArry[0]+")");
            if (typeof rtnObj=="object"){
                var rtn=rtnObj[0].passFlag;
                var ControlLev=rtnObj[0].manLevel;
                var Mesage=rtnObj[0].retMsg;
                var tmpMesageStr="";
                if (Mesage.length>0){
                    for (var i=0;i<Mesage.length;i++){
                        var tmpMesage="";
                        var geneDesc=Mesage[i].geneDesc;
                        var arci=Mesage[i].arci;
                        var seqNo=Mesage[i].seqNo;
                        var oeori=Mesage[i].oeori;
                        var MonitorLogId=Mesage[i].PhMRId; //��־��id��һ������ҽ��һ��id
                        var alertMsg="",ZSKLinkItemStr="";
                        for (var j=0;j<Mesage[i].chlidren.length;j++){
                            var onealertMsg=Mesage[i].chlidren[j].alertMsg;
                            var labelDesc=Mesage[i].chlidren[j].labelDesc;
                            if (alertMsg=="") alertMsg=labelDesc+"@"+onealertMsg;
                            else  alertMsg=alertMsg+"!"+labelDesc+"@"+onealertMsg; //
                            
                            var onelinkArci=Mesage[i].chlidren[j].linkArci;
                            var onelinkOeori=Mesage[i].chlidren[j].linkOeori;
                            if (ZSKLinkItemStr="") ZSKLinkItemStr=onelinkArci+String.fromCharCode(13)+onelinkOeori;
                            else ZSKLinkItemStr=ZSKLinkItemStr+String.fromCharCode(14)+onelinkArci+String.fromCharCode(13)+onelinkOeori;
                        }
                        MonitorLogId=MonitorLogId+String.fromCharCode(15)+ZSKLinkItemStr;
                        SetCellData(seqNo,"OrderMonitorId",MonitorLogId);
                        var tmpMesage=geneDesc+"��"+alertMsg;  //geneDesc+String.fromCharCode(14)+arci+"-"+seqNo+"-"+oeori+String.fromCharCode(15)+
                        var blank="&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"
                        if (tmpMesageStr=="") tmpMesageStr=blank+tmpMesage
                        //else tmpMesageStr=tmpMesageStr+String.fromCharCode(1)+tmpMesage;
                        else tmpMesageStr=tmpMesageStr+"!<br/>"+blank+tmpMesage;
                    }
                    Mesage=tmpMesageStr;
                }
            }
      }
    }else{
        var rtn = ReturnStrArry[0]; //ͨ�� 0 1 ��
        var ControlLev = ReturnStrArry[1]; //���Ƽ��� 0 1 ��
        var Mesage = ReturnStrArry[2];
    }
    if (Mesage != "") {
        Mesage = ChangeMesage(Mesage)
    }
    //��֤
    if ((rtn != 1) && (Active == "C")) {
	    //alert(ControlLev) //"C"����  "W"��ʾ "S"��ʾ
	    //alert(rtn) //ͨ��Ч��passFlag����ֵΪ1 ����ͨ��passFlag����ֵΪ0
        //if ((Update == "Y") && (ControlLev == 1)) {
	    if ((Update=="Y")&&(ControlLev=="C")&&(rtn=="0")){
		    
            if (Mesage == "") { 
               $.messager.alert("����", "֪ʶ����֤����!"); 
               return false; 
            } else { 
               CreaterTooltip("", Mesage, 3, 1); return false; 
            }
        }
        if (Update != "Y") {
            //ͨ����֤�����о�ʾ������˵�ʱ����ʾ
            if (Mesage != "") { CreaterTooltip("", Mesage, 2, 1); return true }
        }
    }
    
    //��ѯ
    if ((Active == "Q") && (RowIn != "")) {
        if (Mesage != "") { CreaterTooltip(RowIn, ReturnStrArry[2], "", 2) } else { CreaterTooltip(RowIn, "", "", 4) }
    }
    //����ҽ��
    if (Active == "A") {
        if (Mesage != "") {
            AdviceOrderShow(ReturnStrArry[2])
        } else {
            $.messager.alert("����", 'û�н���ҽ��!')
        }
    }
    return true;
}
//չʾ��ʾ����ҽ����Ϣ
function AdviceOrder(Mesage) {
    CheckLibPhaFunction("A", "", "")
}
function AdviceOrderShow(ContenStr) {
    CreaterTooltip("", ContenStr, "", 3)
}
///��ȡ֪ʶ��ҽ����Ϣ
function GetCheckLibPhaOrder(RowIn) {
    var OrdMesage = ""
    var OrdMesageSub = ""
        ///��ȡһ����Ϣ
    if (RowIn != "") {
        var OrderItemRowid = GetCellData(RowIn, "OrderItemRowid");
        var OrderARCIMRowid = GetCellData(RowIn, "OrderARCIMRowid");
        var OrderType = GetCellData(RowIn, "OrderType");
        if ((OrderARCIMRowid != "") && (OrderItemRowid == "")) {
            OrdMesage = GetRowMesage(RowIn)
        }
    } else {
        ///�������Ҫ��ҽ����ͻ���
        var rowidsSub = $('#Order_DataGrid').getDataIDs();
        for (var Sub = 0; Sub < rowidsSub.length; Sub++) {
            //���������
            var OrderItemRowid = GetCellData(rowidsSub[Sub], "OrderItemRowid");
            var OrderARCIMRowid = GetCellData(rowidsSub[Sub], "OrderARCIMRowid");
            if ((OrderItemRowid != "") || (OrderARCIMRowid == "")) { continue; }

            var OrderName = GetCellData(rowidsSub[Sub], "OrderName");
            var OrderType = GetCellData(rowidsSub[Sub], "OrderType");
            OrdMesageSub = ""
            if ((OrderARCIMRowid != "") && (OrderItemRowid == "")) { //ҩƷ����顢����
                //var ItemServiceFlag = cspRunServerMethod(GlobalObj.GetItemServiceFlagMethod, OrderARCIMRowid);
                //if ((OrderType == "R") || (OrderType == "L") || (ItemServiceFlag == 1)) {
                    OrdMesageSub = GetRowMesage(rowidsSub[Sub])
                //}
                if (OrdMesageSub != "") {
                    if (OrdMesage == "") OrdMesage = OrdMesageSub;
                    else OrdMesage = OrdMesage + String.fromCharCode(2) + OrdMesageSub;
                }
            }
        }
    }
    return OrdMesage;
}
///��ȡһ��ҽ����Ϣ
function GetRowMesage(RowSub) {
    var RowMesgaeGte = ""
    var OrderItemRowid = GetCellData(RowSub, "OrderItemRowid");
    var OrderARCIMRowid = GetCellData(RowSub, "OrderARCIMRowid");
    if (OrderARCIMRowid == "") { return "" }
    var OrderDurRowid = GetCellData(RowSub, "OrderDurRowid");
    var OrderFreqRowid = GetCellData(RowSub, "OrderFreqRowid");
    var OrderInstrRowid = GetCellData(RowSub, "OrderInstrRowid");
    var OrderDoseQty = GetCellData(RowSub, "OrderDoseQty");
    var OrderDoseUOMRowid = GetCellData(RowSub, "OrderDoseUOMRowid");
    var OrderDrugFormRowid = GetCellData(RowSub, "OrderDrugFormRowid");
    var OrderPHPrescType = GetCellData(RowSub, "OrderPHPrescType");

    var OrderStartDate = "";
    var OrderStartTime = "";
    var OrderStartDateStr = GetCellData(RowSub, "OrderStartDate");
    if (OrderStartDateStr != "") {
        OrderStartDate = OrderStartDateStr.split(" ")[0];
        OrderStartTime = OrderStartDateStr.split(" ")[1];
    }
    var OrderPriorRowid = GetCellData(RowSub, "OrderPriorRowid");
    var OrderPackQty = GetCellData(RowSub, "OrderPackQty");
    var OrderPackUOMDr = GetCellData(RowSub, "OrderPackUOMRowid");
    var OrderLabSpecRowid = GetCellData(RowSub, "OrderLabSpecRowid"); //�걾
    var OrderOrderBodyPart = GetCellData(RowSub, "OrderBodyPartID");
    var OrderRecDepRowid = GetCellData(RowSub, "OrderRecDepRowid"); //���տ���ID
    var MasterSeqNo = ""; //������
    var OrderSeqNo = GetCellData(RowSub, "id"); //GetCellData(RowSub, "OrderSeqNo");
    var OrderMasterSeqNo = GetCellData(RowSub, "OrderMasterSeqNo");
    if (OrderMasterSeqNo==""){
        //���������ҽ����ֵ,�������򲻸�ֵ
        var SubRowidsAry = GetMasterSeqNo(RowSub);
        if (SubRowidsAry.length > 0) {
            MasterSeqNo = "1"+String.fromCharCode(1)+OrderSeqNo;
        }else{
            MasterSeqNo = "0"+String.fromCharCode(1)+OrderSeqNo;
        }
    }else{
        MasterSeqNo="1"+String.fromCharCode(1)+OrderMasterSeqNo+"."+OrderSeqNo;
    }
    //if (OrderMasterSeqNo != "") { MasterSeqNo = "1"+String.fromCharCode(1)+OrderMasterSeqNo; } else { MasterSeqNo = OrderSeqNo; }
    RowMesgaeGte = OrderARCIMRowid + "^" + OrderInstrRowid + "^" + OrderFreqRowid + "^" + OrderDoseQty + "^" + OrderDoseUOMRowid + "^" + OrderPackQty + "^" + OrderPackUOMDr + "^" + OrderDurRowid + "^" + MasterSeqNo + "^" + OrderLabSpecRowid + "^" + OrderOrderBodyPart + "^" + OrderRecDepRowid
    return RowMesgaeGte
}
//ת����ʾ��Ϣ
function ChangeMesage(InMesage) {
    /*
    var InMessageAry=InMesage.split(String.fromCharCode(1));
    //alert("12222"+InMesage)
    InMesage=InMessageAry.join("<br>");
    //��������:��ҩ;��@��ҩ;������<br>�װ�����:��ҩ;��@��ҩ;������<br>���ǰ���:��ҩ;��@��ҩ;������!��ҩƵ��@Ƶ�ʽ���!�÷�����@����������ÿ�β�����2mg���������65���ߣ����ÿ��1mg����������ÿ�β�����2mg��
    InMesage=InMesage.replace(/@/g,'--');
    InMesage=InMesage.replace(/!/g,',');
    var Message=InMesage;
    */
    if (InMesage==undefined) return "";
    InMesage = InMesage.replace(String.fromCharCode(1), '�� ');
    var MesageArry = InMesage.split("!");
    var MesageLen = MesageArry.length;
    var Mesage = ""
    for (var LenMes = 0; LenMes < MesageLen; LenMes++) {
        if (MesageArry[LenMes].indexOf("@") >= 0) {
            var MesageTitle = MesageArry[LenMes].split("@")[0];
            var MesageTxt = MesageArry[LenMes].split("@")[1];
            if (MesageTxt == "") continue;
            if (Mesage == "") {
                Mesage = MesageTitle + "����" + MesageTxt;
            } else {
                Mesage = Mesage + "��" + MesageTitle + "����" + MesageTxt;
            }
        }
    }
    return Mesage
}
function LinkMesageZSQ(Row) {
    var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
   
    if (OrderARCIMRowid != "") {
	    var OrderItemRowid = GetCellData(Row, "OrderItemRowid");
	    var OrderLabSpecRowid = GetCellData(Row, "OrderLabSpecRowid"); //�걾
	    var OrderBodyPartID = GetCellData(Row, "OrderBodyPartID");
	    var ExtStr=OrderItemRowid+"^"+OrderLabSpecRowid+"^"+OrderBodyPartID;
		$cm({
			ClassName:"web.DHCDocService",
			MethodName:"GetLinkMesageZSQ",
			OrderARCIMRowid:OrderARCIMRowid,
			ExtStr:ExtStr,
			dataType:"text"
		},function(Data){
			var DataArr=Data.split("^");
			if (DataArr[0]!="0"){
				$.messager.alert("����",DataArr[1]);
                return false;
			}else{
				var Url=DataArr[2];
				websys_showModal({
					url:Url,
					title:'˵����',
					width:screen.availWidth-200,height:screen.availHeight-200
				});
			}
		});
	     
    }
}
///��ʾ��Ϣ
/// Row ��
/// ContenStr��Ϣ
/// timeOut ͣ��ʱ��
/// Type ��ʾģʽ
function CreaterTooltip(Row, ContenStr, timeOut, Type) {
    if (Type == 1) {
        if (ContenStr == "") return;
        //��ʾ���Ͻǿ��Զ�������Ϣ��ʾ timeOut ����ʱ�� �����Զ�ƥ���� left:0,
        timeOut = (timeOut * 1000)
        $.messager.show({
            title: '֪ʶ������Ϣ',
            msg: ContenStr,
            showType: 'show',
            width: 650,
			height:'auto',
            top: 0,
            maximizable: true,
            timeout: timeOut,
            style: {
                right: '',
                top: window.document.body.scrollTop + window.document.documentElement.scrollTop,
                bottom: ''
            },
            disabled: false
        });
    } else if (Type == 2) {
        if (ContenStr == "") return;
        //��ʼ����ʾ��ҽ����ע����Ϣ����ʾ������ҩ��Ϣ---ע����Ϣ
        //ContenStr="��Ӧ֤@ͷ������/����/$���о���Ⱦ!����֤@ͷ������/����/$��ͷ���࿹���ع����߽���!������Ӧ@ͷ������/����/$������ҩ���¾�Ⱥʧ����ά����B�塣ά����Kȱ�������ظ�Ⱦ�Ȳ�����Ӧ!ע������@ͷ������/����/$����ù�ع������й������ʼ������ܲ�ȫ������/n��ͯ����Ӧ�ñ�ƷӦ�������ڼ������ҩ!!"
        //ContenStr���ܳ�������url��Ч,��ContenStr�ݴ浽��̨��ȡ��ʱID
        var Len = Math.ceil(ContenStr.length / 1000);
        var tempContentIndex = Math.random();
        for (var i = 0; i < Len; i++) {
            var SplitItemStr = ContenStr.substr(i * 1000, 1000)
            var ret = tkMakeServerCall('web.DHCDocService', 'SettempContentIndex', tempContentIndex, session['LOGON.USERID'], i + 1, SplitItemStr);
        }
        tempContentIndex = session['LOGON.USERID'] + "^" + tempContentIndex;
        var url = "dhcdoczsk.csp?Mesage=" + "" + "&MesageType=2" + "&tempContentIndex=" + tempContentIndex;
        initItemInstrDiv(Row,url);
    } else if (Type == 3) {
        if (ContenStr == "") return;
        var Len = Math.ceil(ContenStr.length / 1000);
        var tempContentIndex = Math.random();
        for (var i = 0; i < Len; i++) {
            var SplitItemStr = ContenStr.substr(i * 1000, 1000)
            var ret = tkMakeServerCall('web.DHCDocService', 'SettempContentIndex', tempContentIndex, session['LOGON.USERID'], i + 1, SplitItemStr);
        }
        tempContentIndex = session['LOGON.USERID'] + "^" + tempContentIndex;
        var url = "dhcdoczsk.csp?Mesage=" + "" + "&MesageType=3" + "&tempContentIndex=" + tempContentIndex;

        $('#dd').dialog({
            title: '����ҽ��',
            width: 600,
            height: 400,
            maximizable: true,
            closed: false,
            cache: false,
            href: url,
            modal: false
        })
    } else if (Type == 4) {
        try {
            $("#" + Row + "_" + "OrderName").tooltip("destroy");
        } catch (e) { alert(e) }
    }
}
function initDivHtml(){
	var html  = "<div id='itro_win'  class='div-notes' style='border-radius:3px; display:none; border:2px solid #20A0FF; background:#FFF; position:absolute; width:700px; height:315px;'>";
	    /// ������
		html += "	<div id='itro_title_bar' style='width:100%; height:35px; background:#20A0FF;color:#fff;font-weight:bold;'>";
		html += "		<div id='itro_title' style='padding:8px;text-align:center'></span></div>";
		html += "	</div>"
		/// ������
		html += "	<div id='itro_content' style='width:100%; height:275px; overflow:auto;'>";
		html += "	</div>"
		html += "</div>"
	$('body').append(html);
}
/// �����Ŀ˵����
function initItemInstrDiv(Row){
	if ($("#itro_win").length==0) initDivHtml();
    $("#" + Row + "_" + "OrderName").on('mousemove',function(){ //����
	    $("#"+Row+"_OrderName").removeClass("hover1");
	    var OrderName = GetCellData(Row, "OrderName");
	    var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
	    var OrderNurseLinkOrderRowid = GetCellData(Row, "LinkedMasterOrderRowid");
	    if (OrderNurseLinkOrderRowid=="") {
		    //��ʿ��ʱ�󶨳�����ҽ��
	    	var OrderNurseLinkOrderRowid= GetCellData(Row, "OrderNurseLinkOrderRowid");
	    }
	    var itemPartID="";
	    var dh=$(window).height();
		var nameTop=$(this).parent().offset().top;
	    if (OrderNurseLinkOrderRowid!=""){
		    $("#itro_title").text(OrderName+" - "+ "��Ӧ��ҽ����Ϣ");  /// div�� ����
		    $("#itro_win").css('width',400);
		    $("#itro_win").css('height',100);
		    if (nameTop<100){
			    var top=nameTop + $(this).outerHeight() - 10;
			}else{
				var top=nameTop - 100;
			}
		}else{
			$("#itro_title").text(OrderName+" - "+ "˵����");  /// div�� ����
		    if (nameTop<315){
			    var top=nameTop + $(this).outerHeight() - 10;
			}else{
				var top=nameTop - 315;
			}
		}
		var OrderLabSpecRowid = GetCellData(Row, "OrderLabSpecRowid"); //�걾
	    var itemHtml = GetItemInstr(OrderARCIMRowid, itemPartID, OrderNurseLinkOrderRowid,OrderLabSpecRowid);
	    if (itemHtml == "") return;
		
		$("#itro_content").html(itemHtml); 		   /// div�� ����
		$(".div-notes").css({
			top : top + 'px',
			left : (event.clientX + 10) + 'px',
			'z-index' : 99999
		}).show();
	})
    $("#" + Row + "_" + "OrderName").on('mouseleave',function(){ 
		var divThis = $(".div-notes"); 
		setTimeout(function(){ 
			if (divThis.hasClass("hover0")) {//˵��û�дӰ�ť����div
				divThis.hide(); 
			}
	     }, 100); 
		$("#"+Row+"_OrderName").addClass("hover1");	
	});
	/// div ������ʽ���
	$(".div-notes").hover(function(){//div
		$(this).removeClass("hover0");
	},function(){
		$(this).addClass("hover0"); 
		var anniu = $("#"+Row+"_OrderName")//$('td[field="ItemLabel"]'); 
		var tthis = $(this); 
		setTimeout(function(){ 
			if(anniu.hasClass("hover1")){//˵��û�д�div�ص���ť
				tthis.hide(); 
			}
		},100); 
	})
}
/// ��ȡ�����Ŀ˵����
function GetItemInstr(itmmastid, itemPartID, OrderNurseLinkOrderRowid,OrderLabSpecRowid){
	var html = '';
	if (OrderNurseLinkOrderRowid!="") {
		var rtn=tkMakeServerCall("web.DHCDocOrderCommon","GetVerifiedOrder",OrderNurseLinkOrderRowid);
		var VerifiedOrdInfo=rtn.split("^")[1]+",ҽ��ID:"+rtn.split("^")[2];
		html = html + "<table  cellpadding='0' cellspacing='0' class='itro_content'>";
		html = html + "<tr><td style='border-right:solid #E3E3E3 1px; font-size:14px; padding-left: 10px;'>"+VerifiedOrdInfo+"</td></tr>";
		html = html + "</table>";
	}else{
		// ��ȡ��ʾ����
		runClassMethod("web.DHCAPPExaReportQuery","GetItemInstr",{"itmmastid":itmmastid, "itemPartID":itemPartID,"OrderLabSpecRowid":OrderLabSpecRowid},function(jsonString){

			if (jsonString != ""){
				var jsonObject = jsonString;
				html = initMedIntrTip(jsonObject);
			}else{
				html = "";
			}
		},'json',false)
	}
	return html;
}
/// ��ʼ��֪ʶ����Ϣ����
function initMedIntrTip(itmArr){
	var htmlstr = '';
	for(var i=0; i<itmArr.length; i++){
		htmlstr = htmlstr + "<table  cellpadding='0' cellspacing='0' class='itro_content'>" //<tr><td style='background-color:#F6F6F6;width:120px' >�������Ŀ��</td><td colspan='2'  style='border-right:solid #E3E3E3 1px'>"+itmArr[i].geneDesc+"["+itmArr[i].pointer+"]</td></tr>";
		htmlstr = htmlstr + "<tr><td style='background-color:#F6F6F6;font-weight:bold; font-size:14px;'>"+itmArr[i].itemTile+"</td></tr>";
		htmlstr = htmlstr + "<tr><td style='border-right:solid #E3E3E3 1px; font-size:14px; padding-left: 10px;'>"+itmArr[i].itemContent+"</td></tr>";
		htmlstr = htmlstr + "</table>";
	}
   return htmlstr;
}
///-----------------------֪ʶ��ӿ�  end-----------------------------
//��ʿ��¼ҽ��--��ѡ��ʱ�����ù�����ҽ��
function NurseAddMastOrde(MastLinkStr) {
    try {
        var MastLinkStrArry = MastLinkStr.split("^")
        var LinkedMasterOrderRowid = MastLinkStrArry[0];
        var LinkedMasterOrderSeqNo = MastLinkStrArry[1];
        var LinkedMasterOrderPriorRowid = MastLinkStrArry[2];
        var OrderFreStr = MastLinkStrArry[3];
        var LinkedMasterOrderSttDate=MastLinkStrArry[4];
        var LinkedMasterOrderInstr=MastLinkStrArry[5];
        var LinkedMasterOrderInstrRowid=MastLinkStrArry[6];
        var LinkedMasterOrderFreRowId = "";
        var LinkedMasterOrderFreFactor = "";
        var LinkedMasterOrderFreInterval = ""
        var LinkedMasterOrderFreDesc = "";
        var LinkedMasterOrderFreqDispTimeStr="";
        if (OrderFreStr != "") {
            LinkedMasterOrderFreRowId = mPiece(OrderFreStr, String.fromCharCode(1), 0);
            LinkedMasterOrderFreFactor = mPiece(OrderFreStr, String.fromCharCode(1), 1);
            LinkedMasterOrderFreInterval = mPiece(OrderFreStr, String.fromCharCode(1), 2);
            LinkedMasterOrderFreDesc = mPiece(OrderFreStr, String.fromCharCode(1), 3);
            LinkedMasterOrderFreqDispTimeStr = mPiece(OrderFreStr, String.fromCharCode(1),4);
            LinkedMasterOrderFreqDispTimeStr=LinkedMasterOrderFreqDispTimeStr.split(String.fromCharCode(13)).join(String.fromCharCode(1));
        }
        //�������Ҫ��ҽ��
        var rowidsSub = $('#Order_DataGrid').getDataIDs();
        for (var Sub = 0; Sub < rowidsSub.length; Sub++) {
            //���������
            var OrderItemRowid = GetCellData(rowidsSub[Sub], "OrderItemRowid");
            var OrderARCIMRowid = GetCellData(rowidsSub[Sub], "OrderARCIMRowid");
            if ((OrderItemRowid != "") || (OrderARCIMRowid == "")) { continue; }
            var OrderPHPrescType = GetCellData(rowidsSub[Sub], "OrderPHPrescType");
            var OrderType = GetCellData(rowidsSub[Sub], "OrderType");
            var OrderDate = GetCellData(rowidsSub[Sub], "OrderDate");
            //�����Ѳ�¼ҽ����������
            var OldLinkedMasterOrderRowid=GetCellData(rowidsSub[Sub], "LinkedMasterOrderRowid");
            if ((OldLinkedMasterOrderRowid!="")&&(LinkedMasterOrderRowid!="")) {
	            continue;
	        }
            //��¼������ҽ����Ϣ
            SetCellData(rowidsSub[Sub], "LinkedMasterOrderRowid", LinkedMasterOrderRowid);
            SetCellData(rowidsSub[Sub], "LinkedMasterOrderSeqNo", LinkedMasterOrderSeqNo);
            var StyleConfigObj={};
            var StyleConfigStr=GetCellData(rowidsSub[Sub], "StyleConfigStr");
		    var oldStyleConfigobj = eval("(" + StyleConfigStr + ")");
            //������ɾ��ԭ����ʽ��EditRowʱ���¼�����ʽ
            SetCellData(rowidsSub[Sub], "StyleConfigStr", "");
            if(LinkedMasterOrderSttDate!=""){
	            if (OrderDate!="") {
		            if (tkMakeServerCall("web.DHCOEOrdItem","CompareDateTime",LinkedMasterOrderSttDate.split(" ")[0],LinkedMasterOrderSttDate.split(" ")[1],OrderDate.split(" ")[0],OrderDate.split(" ")[1])==1) {
			        	SetCellData(rowidsSub[Sub], "OrderStartDate", LinkedMasterOrderSttDate);
			        }
		        }else{
			        SetCellData(rowidsSub[Sub], "OrderStartDate", LinkedMasterOrderSttDate);
			    }
            }
            if (LinkedMasterOrderPriorRowid != "") {
	            var CurRowOrderPriorRowid=GetCellData(rowidsSub[Sub], "OrderPriorRowid");
	            var SubOrderInstr=GetCellData(rowidsSub[Sub], "OrderInstr");
	            var SubOrderInstrRowid=GetCellData(rowidsSub[Sub], "OrderInstrRowid");
	            if (OrderType =="R") {
		            if ((!IsNotFollowInstr(SubOrderInstrRowid))||(SubOrderInstrRowid=="")) {
			            SetCellData(rowidsSub[Sub], "OrderInstr", LinkedMasterOrderInstr);
	        			SetCellData(rowidsSub[Sub], "OrderInstrRowid", LinkedMasterOrderInstrRowid);
			        }
		        }else{
		            SetCellData(rowidsSub[Sub], "OrderInstr", "");
	        		SetCellData(rowidsSub[Sub], "OrderInstrRowid", "");
        		}
	            var NurseLinkFlag=tkMakeServerCall("web.DHCOEOrdItem","CheckNurseLinkFlag",LinkedMasterOrderRowid,CurRowOrderPriorRowid);
	            if (NurseLinkFlag=="1"){
		            SetCellData(rowidsSub[Sub], "OrderFreq", "");
	                SetCellData(rowidsSub[Sub], "OrderFreqRowid", "");
	                SetCellData(rowidsSub[Sub], "OrderFreqFactor", 1);
					SetCellData(rowidsSub[Sub], "OrderFreqDispTimeStr", "");
		            var HourFlag = cspRunServerMethod(GlobalObj.IsHourItem, OrderARCIMRowid);
		            if ((LinkedMasterOrderFreRowId != "")&&(HourFlag!=1)) {
		                SetCellData(rowidsSub[Sub], "OrderFreq", LinkedMasterOrderFreDesc);
		                SetCellData(rowidsSub[Sub], "OrderFreqRowid", LinkedMasterOrderFreRowId);
		                SetCellData(rowidsSub[Sub], "OrderFreqFactor", LinkedMasterOrderFreFactor);
						SetCellData(rowidsSub[Sub], "OrderFreqDispTimeStr", LinkedMasterOrderFreqDispTimeStr);
		            }
	                var PriorStr = cspRunServerMethod(GlobalObj.GetPrioCodeAndDesc, LinkedMasterOrderPriorRowid)
	                var LinkedMasterOrderPriorDesc = PriorStr.split("^")[1];
	                //ǿ��ģʽ
	                if (GlobalObj.OrderPriorContrlConfig == 1) {
	                    if ((LinkedMasterOrderPriorRowid == GlobalObj.OMSOrderPriorRowid) || (LinkedMasterOrderPriorRowid == GlobalObj.LongOrderPriorRowid)) {
	                        var OrderPriorStr = GlobalObj.LongOrderPriorRowid + ":" + "����ҽ��";
	                        SetColumnList(rowidsSub[Sub], "OrderPrior", OrderPriorStr);
	                        SetCellData(rowidsSub[Sub], "OrderPriorStr", OrderPriorStr);
	                    }
	                    if ((LinkedMasterOrderPriorRowid == GlobalObj.OMOrderPriorRowid) || (LinkedMasterOrderPriorRowid == GlobalObj.ShortOrderPriorRowid)) {
	                        var OrderPriorStr = GlobalObj.ShortOrderPriorRowid + ":" + "��ʱҽ��";
	                        SetColumnList(rowidsSub[Sub], "OrderPrior", OrderPriorStr);
	                         SetCellData(rowidsSub[Sub], "OrderPriorStr", OrderPriorStr);
	                    }
	                }
	                var obj = document.getElementById(rowidsSub[Sub] + "_OrderPrior");
	                if (obj) {
	                    //�ɱ༭״̬
	                    SetCellData(rowidsSub[Sub], "OrderPrior", LinkedMasterOrderPriorRowid);
	                } else {
	                    SetCellData(rowidsSub[Sub], "OrderPrior", LinkedMasterOrderPriorDesc);
	                }
	                
	                SetCellData(rowidsSub[Sub], "OrderPriorRowid", LinkedMasterOrderPriorRowid);
					SetOrderFirstDayTimes(rowidsSub[Sub]);
					StyleConfigObj.OrderFreq=false;
					//��ҩƷ����ҽ������Ƶ�β���¼����������Ƶ�ο���¼������
			        //��ҩƷ����ҽ����Ƶ�β���¼�뵥�μ���
			        var OrderFreqRowid=GetCellData(rowidsSub[Sub], "OrderFreqRowid");
			        if (LinkedMasterOrderPriorRowid == GlobalObj.LongOrderPriorRowid){
			            if (OrderFreqRowid==""){
				            if (HourFlag!="1") {
			                	StyleConfigObj.OrderPackQty = true;
			                }
			                StyleConfigObj.OrderDoseQty = false;
			                SetCellData(rowidsSub[Sub], "OrderDoseQty", "");
			            }else{
				            StyleConfigObj.OrderFirstDayTimes=true;
			                StyleConfigObj.OrderDoseQty = true;
			                StyleConfigObj.OrderPackQty = false;
			                SetCellData(rowidsSub[Sub], "OrderPackQty","");
			            }
			            if (VerifiedOrderObj.LinkedMasterOrderFreFactor>1) {
				            StyleConfigObj.OrderFreq = true;
				        }
			        }
			        var OrderPriorRowid=GetCellData(rowidsSub[Sub], "OrderPriorRowid");
			        var OrderPHPrescType = GetCellData(rowidsSub[Sub], "OrderPHPrescType");
			        //����ʿ��¼��ʱҽ��������ҽ���ϣ��Ҳ�¼��ҽ��Ƶ��Ϊ��,��Ƶ�οɱ༭ ΪʲôҪ�༭?
			        if ((OrderFreqRowid=="")&&(OrderPHPrescType=="4")&&(LinkedMasterOrderPriorRowid==GlobalObj.LongOrderPriorRowid)&&(OrderPriorRowid==GlobalObj.ShortOrderPriorRowid)){
				        StyleConfigObj.OrderFreq = true;
				    }
			        StyleConfigObj.OrderInstr = false;
			        StyleConfigObj.OrderPrior = false;
			        ChangeCellDisable(rowidsSub[Sub],StyleConfigObj)
                }else{
	                SetCellData(rowidsSub[Sub],"LinkedMasterOrderRowid","");
					SetCellData(rowidsSub[Sub],"LinkedMasterOrderSeqNo","");
			        SetCellData(rowidsSub[Sub],"OrderNurseLinkOrderRowid",VerifiedOrderObj.LinkedMasterOrderRowid);
			        StyleConfigObj.OrderPrior = false;
			        StyleConfigObj.OrderFreq=false;
			        StyleConfigObj.OrderInstr = false;
			        var OrderFreqRowid=GetCellData(rowidsSub[Sub], "OrderFreqRowid");
			        var OrderPriorRowid=GetCellData(rowidsSub[Sub], "OrderPriorRowid");
			        var OrderPHPrescType = GetCellData(rowidsSub[Sub], "OrderPHPrescType");
			        //����ʿ��¼��ʱҽ��������ҽ���ϣ��Ҳ�¼��ҽ��Ƶ��Ϊ��,��Ƶ�οɱ༭ ΪʲôҪ�༭?
			        if ((OrderFreqRowid=="")&&(OrderPHPrescType=="4")&&(LinkedMasterOrderPriorRowid==GlobalObj.LongOrderPriorRowid)&&(OrderPriorRowid==GlobalObj.ShortOrderPriorRowid)){
				        StyleConfigObj.OrderFreq = true;
				    }
			        ChangeCellDisable(rowidsSub[Sub],StyleConfigObj)
	            }
            }else{
	            var StyleConfigObj={};
	            if ((OrderType!="R")&&(OrderPHPrescType != "4")) {
	            	SetCellData(rowidsSub[Sub], "OrderFreq", "");
		            SetCellData(rowidsSub[Sub], "OrderFreqRowid", "");
		            SetCellData(rowidsSub[Sub], "OrderFreqFactor", "1");
					SetCellData(rowidsSub[Sub], "OrderFreqDispTimeStr", "");
					SetOrderFirstDayTimes(rowidsSub[Sub]);
					$.extend(StyleConfigObj, {OrderFreq:false,OrderDoseQty:false,OrderPackQty:true});
	            }
	            var OrderPriorRowid=GetCellData(rowidsSub[Sub], "OrderPriorRowid");
	            if ((OrderType!="R")&&(OrderPHPrescType=="4")) {
		            StyleConfigObj.OrderFreq = true;
		            if (OrderPriorRowid == GlobalObj.LongOrderPriorRowid){
			            StyleConfigObj.OrderDoseQty = true;
			            StyleConfigObj.OrderPackQty = false;
			        }else{
				        StyleConfigObj.OrderDoseQty = false;
			            StyleConfigObj.OrderPackQty = true;
				    }
		        }  
	            var OrderHiddenPara = GetCellData(rowidsSub[Sub], "OrderHiddenPara");
    			var OrderItemCatRowid = mPiece(OrderHiddenPara, String.fromCharCode(1), 2);
	            if ((OrderType!="R")&&(("^" + GlobalObj.SelectInstrNotDrugCat + "^").indexOf("^" + OrderItemCatRowid + "^") >= 0)) {
		            StyleConfigObj.OrderInstr = true;
		        }
	            $.extend(StyleConfigObj, {OrderPrior:true});
			    ChangeCellDisable(rowidsSub[Sub],StyleConfigObj)
            }
            $.extend(oldStyleConfigobj, StyleConfigObj);
            var StyleConfigStr = JSON.stringify(oldStyleConfigobj);
    		SetCellData(rowidsSub[Sub], "StyleConfigStr", StyleConfigStr);
            initItemInstrDiv(rowidsSub[Sub]);
            CheckFreqAndPackQty(rowidsSub[Sub]);
        }
    } catch (e) {}
}
//�����Ա�
function OrderSelfOMFlagChangehandler(e) {
    var Row = GetEventRow(e);
    var OrderSelfOMFlag = GetCellData(Row, "OrderSelfOMFlag");
    if (OrderSelfOMFlag == "Y") {
        SetCellData(Row, "OrderPriorRemarks", "OM");
        SetCellData(Row, "OrderPriorRemarksRowId", "OM");
        CheckOrderPriorRemarks(Row);
    }
}
//OperationType="A" ��ҽ��,OrdList ��ʽ��arcimID*oeitmID*status^arcimID*oeitmID*status
//OperationType="S" ͣҽ��,OrdList ��ʽ��oeitmID^oeitmID
function SaveCASign(ContainerName, OrdList, OperationType) {
    try {
        if (ContainerName == "") return false;
        //1.������֤
        var CASignOrdStr = "";
        var TempIDs = OrdList.split("^");
        var IDsLen = TempIDs.length;
        for (var k = 0; k < IDsLen; k++) {
	        if (OperationType=="A") {
		        var TempNewOrdDR = TempIDs[k].split("*");
                if (TempNewOrdDR.length < 2) continue;
                var newOrdIdDR = TempNewOrdDR[1];
	        }
	        if (OperationType=="S") {
		        var newOrdIdDR = TempIDs[k];
	        }
            
            if (CASignOrdStr == "") CASignOrdStr = newOrdIdDR;
            else CASignOrdStr = CASignOrdStr + "^" + newOrdIdDR;
        }
        var SignOrdHashStr = "",
            SignedOrdStr = "",
            CASignOrdValStr = "";
        var CASignOrdArr = CASignOrdStr.split("^");
        for (var count = 0; count < CASignOrdArr.length; count++) {
            var CASignOrdId = CASignOrdArr[count];
            var OEORIItemXML = cspRunServerMethod(GlobalObj.GetOEORIItemXMLMethod, CASignOrdId, OperationType);
            var OEORIItemXMLArr = OEORIItemXML.split(String.fromCharCode(2));
            for (var ordcount = 0; ordcount < OEORIItemXMLArr.length; ordcount++) {
                if (OEORIItemXMLArr[ordcount] == "") continue;
                var OEORIItemXML = OEORIItemXMLArr[ordcount].split(String.fromCharCode(1))[1];
                var OEORIOperationType = OEORIItemXMLArr[ordcount].split(String.fromCharCode(1))[0];
                //$.messager.alert("����","OEORIItemXML:"+OEORIItemXML);
                var OEORIItemXMLHash = HashData(OEORIItemXML);
                //$.messager.alert("����","HashOEORIItemXML:"+OEORIItemXMLHash);
                if (SignOrdHashStr == "") SignOrdHashStr = OEORIItemXMLHash;
                else SignOrdHashStr = SignOrdHashStr + "&&&&&&&&&&" + OEORIItemXMLHash;
                //$.messager.alert("����",ContainerName);
                var SignedData = SignedOrdData(OEORIItemXMLHash, ContainerName);
                if (SignedOrdStr == "") SignedOrdStr = SignedData;
                else SignedOrdStr = SignedOrdStr + "&&&&&&&&&&" + SignedData;


                if (CASignOrdValStr == "") CASignOrdValStr = OEORIOperationType + String.fromCharCode(1) + CASignOrdId;
                else CASignOrdValStr = CASignOrdValStr + "^" + OEORIOperationType + String.fromCharCode(1) + CASignOrdId;
            }

        }
        if (SignOrdHashStr != "") SignOrdHashStr = SignOrdHashStr + "&&&&&&&&&&";
        if (SignedOrdStr != "") SignedOrdStr = SignedOrdStr + "&&&&&&&&&&";
        //��ȡ�ͻ���֤��
        var varCert = GetSignCert(ContainerName);
        var varCertCode = GetUniqueID(varCert);
        /*
        alert("CASignOrdStr:"+CASignOrdStr);
        alert("SignOrdHashStr:"+SignOrdHashStr);
        alert("varCert:"+varCert);
        alert("SignedData:"+SignedOrdStr);
      */
        if ((CASignOrdValStr != "") && (SignOrdHashStr != "") && (varCert != "") && (SignedOrdStr != "")) {
            //3.����ǩ����Ϣ��¼
            ////                                                                                                                CASignOrdValStr,session['LOGON.USERID'],"A",                    SignOrdHashStr,varCertCode,SignedOrdStr,""
            var ret = cspRunServerMethod(GlobalObj.InsertCASignInfoMethod, CASignOrdValStr, session['LOGON.USERID'], OperationType, SignOrdHashStr, varCertCode, SignedOrdStr, "");
            if (ret != "0") { $.messager.alert("����","����ǩ��û�ɹ�"); return false; }
        } else {
            $.messager.alert("����","����ǩ������");
            return false;
        }
        return true;
    } catch (e) { alert(e.message); return false; }
}
function OrderMsgChange() {
    if (GlobalObj.CFOrderMsgAlert != 1) return false;
    if ((VerifiedOrderObj) && (VerifiedOrderObj.LinkedMasterOrderPriorRowid != "undefined") && (VerifiedOrderObj.LinkedMasterOrderPriorRowid != "")) return false;

    var Find = 0
    try {
        var rowid = "";
        var rowids = $('#Order_DataGrid').getDataIDs();
        if (rowids == "") {
            $("#Prompt").html("��ʾ��Ϣ:")
            //return false;
        }
        if (rowids.length > 0) {
            for (var i = rowids.length; i >= 0; i--) {
                if (Find == 1) continue;
                var rowid = rowids[i];
                var OrderItemRowid = GetCellData(rowid, "OrderItemRowid")
                var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid")
                var OrderName = GetCellData(rowid, "OrderName")
                if ((rowids.length == 1) && (OrderARCIMRowid == "")) $("#Prompt").html("��ʾ��Ϣ:")
                if ((OrderARCIMRowid != "") && (OrderItemRowid == "")) {
                    var OrderMsg = cspRunServerMethod(GlobalObj.GetOrderMsgMethod, GlobalObj.EpisodeID, OrderARCIMRowid)
                    if (OrderMsg != "") {
                        $("#Prompt").html("��ʾ��Ϣ:" + OrderName + OrderMsg)
                        Find = 1
                    } else {
                        $("#Prompt").html("��ʾ��Ϣ:")
                    }
                } else {
                    $("#Prompt").html("��ʾ��Ϣ:")
                }
            }

        }
        if (Find==0){
	        var IPNecessaryCatMsg=tkMakeServerCall("web.DHCDocOrderCommon", "GetIPNecessaryCat", GlobalObj.EpisodeID);
	        if (IPNecessaryCatMsg!=""){
	            $("#Prompt").html("��ʾ��Ϣ:�û�����δ¼��" +IPNecessaryCatMsg +"��ҽ��.");
	        }
            if (GlobalObj.PPRowId != "") {
                GlobalObj.PilotProWarning=tkMakeServerCall("web.PilotProject.DHCDocPilotProject","ifWarning",GlobalObj.PPRowId,session['LOGON.USERID']);
                $("#Prompt").html(GlobalObj.PilotProWarning);
            }
        }
    } catch (e) { $.messager.alert("����", e.message) }
}
function CheckCureItemConfig(rowid,CureItemConfigArg) {
	return DHCDocCure_Service.CheckCureItemConfig(rowid,CureItemConfigArg);
}
//ѡ��������ʾ��Ϣ������ʾҽ�������ʾ��Ϣ
function OrderDataGirdclick(e) {
    if ((VerifiedOrderObj) && (VerifiedOrderObj.LinkedMasterOrderPriorRowid != "undefined") && (VerifiedOrderObj.LinkedMasterOrderPriorRowid != "")) return false;
    if (GlobalObj.CFOrderMsgAlert != 1) return false;
    var rowid = GetEventRow(e)
    if (rowid == "") return false;
    var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid")
    var OrderName = GetCellData(rowid, "OrderName")
    var OrderMsg = cspRunServerMethod(GlobalObj.GetOrderMsgMethod, GlobalObj.EpisodeID, OrderARCIMRowid)
    if (OrderMsg != "") {
        $("#Prompt").html("��ʾ��Ϣ:" + OrderName + OrderMsg);
    }
}
function OpenChangeOrderClick() {
    DiaUpdateClick()
}
function DiaUpdateClick() {
    var rowids = GetSelRowId();
    new Promise(function(resolve,rejected){
		StopOrd(rowids,resolve);
	}).then(function(OrdList){
	    var rowids = $('#Order_DataGrid').getDataIDs();
	    var NewOrdList = "";
	    for (var i = 0; i < OrdList.split("^").length; i++) {
	        if (NewOrdList == "") NewOrdList = OrdList.split("^")[i].split("&")[0];
	        else NewOrdList = NewOrdList + "^" + OrdList.split("^")[i].split("&")[0];
	    }
	    NewOrdList = "^" + NewOrdList + "^";
	    for (var k = 0; k < rowids.length; k++) {
	        //���������
	        var OrderItemRowid = GetCellData(rowids[k], "OrderItemRowid");
	        //if(OrdList.indexOf(OrderItemRowid+"&")==-1){continue}
	        if (NewOrdList.indexOf("^" + OrderItemRowid + "^") == -1) { continue }
	        SetCellData(rowids[k], "OrderItemRowid", "");
	        SetCellData(rowids[k], "OrderLabEpisodeNo", "");
	        var OrderBindSource = GetCellData(rowids[k], "OrderBindSource")
	        if (OrderBindSource != "") {
	            DeleteAntReason(rowids[k]);
	            $('#Order_DataGrid').delRowData(rowids[k]);
	        }
	        var OrderName = GetCellData(rowids[k], "OrderItemRowid");
			var OrderARCIMRowid = GetCellData(rowids[k], "OrderARCIMRowid");
	        if (OrderARCIMRowid=="") continue;
	        SetNewOrderClass(rowids[k]);
	        EditRow(rowids[k], "1");
	        //�趨���鴦������ɫ
	        var OrderPoisonCode=GetCellData(rowids[k], "OrderPoisonCode");
	        var OrderPoisonRowid=GetCellData(rowids[k], "OrderPoisonRowid");
	        SetPoisonOrderStyle(OrderPoisonCode, OrderPoisonRowid, rowids[k])
	        //�趨����ҽ���ı���ɫ
	        var OrderMasterSeqNo = GetCellData(rowids[k], "OrderMasterSeqNo");
	        if (OrderMasterSeqNo!=""){
		        $("#" + OrderMasterSeqNo).find("td").addClass("OrderMasterM");
				$("#" + rowids[k]).find("td").addClass("OrderMasterS");
		    }
	        $('#Order_DataGrid').setCell(rowids[k],"OrderName",OrderName,"OrderUnSaved","");
	        var CureItemStyleObj=CheckCureItemConfig(rowids[k]);
			ChangeRowStyle(rowids[k], CureItemStyleObj)
	    }
	    SetScreenSum();
	    CheckMasterOrdStyle();
	})
}
//��ҽ��¼�����������ѡ��ҽ����Ľ�����ת
function CellFocusJumpAfterOrderName(rowid, OrderType) {
    if (OrderType == "R") {
        SetFocusCell(rowid, "OrderDoseQty");
    } else {
        if (OrderType == "P") {
            SetFocusCell(rowid, "OrderPrice");
        } else {
	        var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
    		var OrderItemCatRowid = mPiece(OrderHiddenPara, String.fromCharCode(1), 2);
    		var RequireNote = mPiece(OrderHiddenPara, String.fromCharCode(1), 21);
    		var SelectInstrNotDrugCatFlag=0;
	        if (("^" + GlobalObj.SelectInstrNotDrugCat + "^").indexOf("^" + OrderItemCatRowid + "^") >=0) {
	            SelectInstrNotDrugCatFlag=1;
	        }
	        var OrderInstrRowid = GetCellData(rowid, "OrderInstrRowid");
            var OrderPHPrescType = GetCellData(rowid, "OrderPHPrescType");
            var OrderFreqRowid = GetCellData(rowid, "OrderFreqRowid");
            if (OrderType == "P") {
                SetFocusCell(rowid, "OrderPrice");
            } else if ((OrderPHPrescType == "4") && (OrderFreqRowid == "")) {
                SetFocusCell(rowid, "OrderFreq");
            } else if ((SelectInstrNotDrugCatFlag==1)&&(OrderInstrRowid == "")){
	            //��ѡ���÷��ķ�ҩƷ�ӷ��࣬���÷�Ϊ��,����ת���÷���
	            SetFocusCell(rowid, "OrderInstr");
	        } else if (RequireNote == "Y") {
		        //�Զ�������ҽ��
                SetFocusCell(rowid, "OrderDepProcNote");
	        }else {
                var OrderPackQtyObj = document.getElementById(rowid + "_OrderPackQty");
                if (OrderPackQtyObj && (OrderPackQtyObj.disabled == false)) {
                    SetFocusCell(rowid, "OrderPackQty");
                } else {
                    //�ж��������װ�����ǿ�,��ת�����μ���
                    var OrderPackQty = GetCellData(rowid, "OrderPackQty");
                    if (OrderPackQty != "") { window.setTimeout("Add_Order_row()", 200); } else {
                        SetFocusCell(rowid, "OrderDoseQty");
                    }

                }
            }
        }
    }
}
function CheckInsuCostControl() {
    try {
        var InputOrderInfo = ""
        var rowids = $('#Order_DataGrid').getDataIDs();
        for (var i = 0; i < rowids.length; i++) {
            var Row = rowids[i]
            var OrderItemRowid = GetCellData(Row, "OrderItemRowid");
            var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
            var StyleConfigStr = GetCellData(Row, "StyleConfigStr");
            var StyleConfigObj = {};
            if (StyleConfigStr != "") {
                StyleConfigObj = eval("(" + StyleConfigStr + ")");
            }
            if ((GlobalObj.PAAdmType != "I") && (StyleConfigObj.OrderPackQty != true) && (OrderItemRowid != "")) { continue }
            if (OrderARCIMRowid == "") { continue; }

            var OrderName = GetCellData(Row, "OrderName");
            ///1ҽ�������
            var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
            ///2��ҽ������
            var OrderDepCode = session['LOGON.CTLOCID'];
            var OrderStartDate = "";
            var OrderStartTime = "";
            var OrderStartDateStr = GetCellData(Row, "OrderStartDate");
            if (OrderStartDateStr != "") {
                //3ҽ������
                OrderStartDate = OrderStartDateStr.split(" ")[0];
                //4ҽ��ʱ��
                OrderStartTime = OrderStartDateStr.split(" ")[1];
            }
            //5ҽ��ҽ������
            var OrderDocCode = GlobalObj.LogonDoctorID;
            //6ҽ��ҽ��ְ��CTPCP_CarPrvTp_DR->CTCPT_Desc
            var OrderCarPrvTp = ""
                //7Ӥ����������
            var BabyBrithDay = ""
                //8Ӥ������ʱ��
            var BabyBrithTime = ""
                //9Ӥ���ѱ�־    1:Ӥ���� 0��������
            var BabyFeeFlag = ""
                //10�Ƿ�ҩƷ Y:ҩƷ N:��ҩƷ
            var OrderType = GetCellData(Row, "OrderType");
            var DurgFlag = "Y"
            if (OrderType != "R") var DurgFlag = "N"
                //11����������־  1������ 0������
            var SDFlag = ""
                //12��ҩ����
            var CMQty = ""
                //13��ҩ����
            var CMDoseQty = ""
                //14ҽ�����ȼ�����
            var OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
            var OrderPriorRemarks = GetCellData(Row, "OrderPriorRemarks");
            OrderPriorRowid = ReSetOrderPriorRowid(OrderPriorRowid, OrderPriorRemarks);
            //15��ҩ;��    
            var OrderInstrRowid = GetCellData(Row, "OrderInstrRowid");
            //16Ƶ��
            var OrderFreqRowid = GetCellData(Row, "OrderFreqRowid");
            //17�Ƴ�
            var OrderDurRowid = GetCellData(Row, "OrderDurRowid");
            var OrderFreqFactor = GetCellData(Row, "OrderFreqFactor");
            //18��������
            var OrderDoseQty = GetCellData(Row, "OrderDoseQty");
            //19ÿ������
            var OrderPDQty = parseFloat(OrderDoseQty) * parseFloat(OrderFreqFactor)
                //20�״η�ҩ��
                //var OrderFirstDayTimes=GetColumnData("OrderFirstDayTimes",Row);
            var OrderFirstDayTimes = OrderDoseQty
                //21������Ӧ�ĵ�λ
            var OrderDoseUOM = GetCellData(Row, "OrderDoseUOM");
            var OrderDoseUOMRowid = GetCellData(Row, "OrderDoseUOMRowid");
            //22������λ
            var OrderPackUOMRowid = GetCellData(Row, "OrderPackUOMRowid");
            //23������λ��������λ��ϵ
            var CalDose = ""
                //24����
            var OrderPackQty = GetCellData(Row, "OrderPackQty");
            //25����
            var OrderPrice = GetCellData(Row, "OrderPrice");
            //26���
            var OrderSum = GetCellData(Row, "OrderSum");
            //27�û�ID
            var UserID = session['LOGON.USERID'];
            //28���ܿ���
            var OrderRecDepRowid = GetCellData(Row, "OrderRecDepRowid");
            var OrdStr = OrderARCIMRowid + "^" + OrderDepCode + "^" + OrderStartDate + "^" + OrderStartTime + "^" + OrderDocCode
                //6
            var OrdStr = OrdStr + "^" + OrderCarPrvTp + "^" + BabyBrithDay + "^" + BabyBrithTime + "^" + BabyFeeFlag + "^" + DurgFlag
                //11
            var OrdStr = OrdStr + "^" + SDFlag + "^" + CMQty + "^" + CMDoseQty + "^" + OrderPriorRowid + "^" + OrderInstrRowid
                //16
            var OrdStr = OrdStr + "^" + OrderFreqRowid + "^" + OrderDurRowid + "^" + OrderDoseQty + "^" + OrderPDQty + "^" + OrderFirstDayTimes
                //21
            var OrdStr = OrdStr + "^" + OrderDoseUOMRowid + "^" + OrderPackUOMRowid + "^" + CalDose + "^" + OrderPackQty + "^" + OrderPrice
                //26
            var OrdStr = OrdStr + "^" + OrderSum + "^" + UserID + "^" + OrderRecDepRowid

            if (InputOrderInfo == "") {
                InputOrderInfo = OrdStr
            } else {
                InputOrderInfo = InputOrderInfo + String.fromCharCode(2) + OrdStr
            }

        }
        //alert(GlobalObj.EpisodeID+"!!!"+InputOrderInfo)
        var Rtn = cspRunServerMethod(GlobalObj.CheckInsuCostControlMethod, GlobalObj.EpisodeID, InputOrderInfo)

        if (Rtn != "") {
            var ErrType = Rtn.split("^")[0]
            var ErrMsg = Rtn.split("^")[1]
            if (ErrType == "0") {
                $.messager.alert("����ҽ���ط�����", ErrMsg)
            } else if (ErrType == "1") {
                return dhcsys_confirm("����ҽ���ط�����:" + ErrMsg + "���Ƿ����?")
            } else if (ErrType == "2") {
                $.messager.alert("����ҽ���ط�����", ErrMsg + ".��������ˣ�")
                return false
            }
        }
        return true
    } catch (e) {
        alert(e.message);
    }
    return true
}
function GetRecPrice(Row) {
    if (GlobalObj.PAAdmType != "I") {
        OrderBillTypeRowid = GetPrescBillTypeID();
    } else {
        OrderBillTypeRowid = GlobalObj.BillTypeID;
    }
    var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
    var OrderOpenForAllHosp = ""; //$("#OrderOpenForAllHosp").val();
    var OrderPackUOMRowid = GetCellData(Row, "OrderPackUOMRowid");
    if (OrderPackUOMRowid == "") return;
    var OrderRecDepRowid = GetCellData(Row, "OrderRecDepRowid");
    var LogonDep = GetLogonLocByFlag();
    var retPrice = cspRunServerMethod(GlobalObj.GetOrderPriceConUomMethod, GlobalObj.EpisodeID, OrderBillTypeRowid, LogonDep, OrderARCIMRowid, OrderOpenForAllHosp, OrderPackUOMRowid, OrderRecDepRowid);
    if (retPrice==undefined) retPrice="0^0^0^0^0";
    var ArrPrice = retPrice.split("^");
    var Price = ArrPrice[0];
    if (Price < 0) {
        $.messager.alert("����","�˽���������Чҽ����,���л����տ��һ�����ϵ�����Ա����")
        websys_setfocus('OrderRecDep');
    }
    return retPrice
}
function SaveOrderToEMR() {
    if (GlobalObj.PAAdmType == "I") {
        return true;
    }
    var OrdList = tkMakeServerCall("EMRservice.BL.opInterface", "getOeordXH", GlobalObj.EpisodeID)
	if ((typeof(parent.invokeChartFun) === 'function')||(typeof(parent.parent.invokeChartFun) === 'function')) {
	    if (typeof(parent.invokeChartFun) === 'function'){
		    parent.invokeChartFun('���ﲡ��', 'updateEMRInstanceData', "oeord", OrdList, "", GlobalObj.EpisodeID);
		    parent.invokeChartFun('�ż��ﲡ����¼', 'updateEMRInstanceData', "oeord", OrdList, "", GlobalObj.EpisodeID);
		}else{
			parent.parent.invokeChartFun('���ﲡ��', 'updateEMRInstanceData', "oeord", OrdList, "", GlobalObj.EpisodeID);
			parent.parent.invokeChartFun('�ż��ﲡ����¼', 'updateEMRInstanceData', "oeord", OrdList, "", GlobalObj.EpisodeID);
		}
	}
    return OrdList
}
var PHCINDesczLookupGrid;
function InstrFocusHandler(e) {
	//$(this).select();
	if (typeof e.bubbles != "undefined") {
		$(this).select();
	}
	return false;
}
function OrdDoseQtyFocusHandler(e){
	$(this).select();
	var obj = websys_getSrcElement(e);
    var rowid = "";
    if (obj.id.indexOf("_") > 0) {
        rowid = obj.id.split("_")[0];
    }
	return false;
}
function OrderFirstDayTimesFocusHandler(e){
	$(this).select();
	return false;
}
function OrderPackQtyFocusHandler(e){
	$(this).select();
	return false;
}
var PHCFRDesczLookupGrid;
function FrequencyFocusHandler(e) {
	if (typeof e.bubbles != "undefined") {
		$(this).select();
	}
	return false;
}
var PHCDUDesczLookupGrid;
function DurationFocusHandler(e) {
	if (typeof e.bubbles != "undefined") {
		$(this).select();
	}
	return;
}
function MultiTemplOrdEntry() {
    var ItemCount=0;
    if (((typeof(getCheckedNodes) === 'function')&&(UIConfigObj.DefaultPopTemplate == true))||((window.parent)&&(window.parent.getCheckedNodes))){
	    if ((window.parent)&&(window.parent.getCheckedNodes)){
		    var nodeArr=window.parent.getCheckedNodes();
		}else{
			//סԺ
			var nodeArr=getCheckedNodes();
		}
		new Promise(function(resolve,rejected){
			(function(callBackFun){
				function loop(i){
					new Promise(function(resolve,rejected){
						ItemCount=ItemCount+1;
						addSelectedFav(nodeArr[i],"",resolve);
					}).then(function(){
						i++;
						if ( i < nodeArr.length ) {
							 loop(i);
						}else{
							callBackFun();
						}
					})
				}
				loop(0);
			})(resolve);
		}).then(function(){
			if (ItemCount==0){
		        $.messager.alert("����","��ѡ����Ҫ��ӵ�ģ��ҽ��!")
		        return false;
		    }
			if(window.parent.unCheckedNodes)window.parent.unCheckedNodes();
		})
	}else{
	    var _$OrdTempCheck=$(".ordtemplatecheck");
	    new Promise(function(resolve,rejected){
			(function(callBackFun){
				function loop(i){
					new Promise(function(resolve,rejected){
						var checkboxid = _$OrdTempCheck[i].id;
						if ($("#" + escapeJquery(checkboxid) + "").is(":checked")) {
							ItemCount=ItemCount+1;
				            var checkidArr = checkboxid.split("_");
				            var checkidlength = checkidArr.length;
				            var itemclass = checkidArr[checkidlength - 3] + "_" + checkidArr[checkidlength - 2] + "_" + checkidArr[checkidlength - 1];
				            var itemid = $("." + itemclass + "").attr("id");
							addSelectedFav(itemid,"",resolve);
							$("#" + checkboxid + "").prop('checked', false);
							$("#" + checkboxid + "").next().removeClass("templateItemSelect");
						}else{
							resolve();
						}
					}).then(function(){
						i++;
						if ( i < _$OrdTempCheck.length ) {
							 loop(i);
						}else{
							callBackFun();
						}
					})
					
				}
				loop(0);
			})(resolve);
		}).then(function(){
			if (ItemCount==0){
		        $.messager.alert("����","��ѡ����Ҫ��ӵ�ģ��ҽ��!")
		        return false;
		    }
			if(window.parent.unCheckedNodes)window.parent.unCheckedNodes();
		})
    }
}
function OrdCateGoryChange(e) {
    var rowid = "";
    var obj = websys_getSrcElement(e);
    var rowid = GetEventRow(e);
    var OrdCateGoryid = obj.value;
    var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
    if (OrderARCIMRowid != "") {
	    var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
	    if (OrderMasterSeqNo!=""){
		    SetMasterSeqNo("", rowid, "C");
		}else{
			var SubRowidsAry=GetMasterSeqNo(rowid);
			var len=SubRowidsAry.length;
			if (len>0){
				for (var i=0;i<len;i++){
					SetMasterSeqNo("", SubRowidsAry[i], "C");
				}
			}
		}
        DeleteAntReason(rowid);
        $('#Order_DataGrid').delRowData(rowid);
        var rowid = Add_Order_row();
        SetCellData(rowid, "OrdCateGory", OrdCateGoryid);
    }
    SetCellData(rowid, "OrdCateGoryRowId", OrdCateGoryid);
    SetCellData(rowid, "OrderName", "");
    if (typeof ItemzLookupGrid == "object") {
        ItemzLookupGrid.hide();
    }
    SetFocusCell(rowid, "OrderName");
}
function SortRowClick(type){
    var SelIds=$('#Order_DataGrid').jqGrid("getGridParam", "selarrrow"); 
    if (SelIds == null || SelIds.length == 0) {
        if (PageLogicObj.FocusRowIndex > 0) {
            if ($("#jqg_Order_DataGrid_" + PageLogicObj.FocusRowIndex).prop("checked") != true) {
                $("#Order_DataGrid").setSelection(PageLogicObj.FocusRowIndex, true);
            }
        }
        SelIds = $('#Order_DataGrid').jqGrid("getGridParam", "selarrrow");
    }
    SelIds=SelIds.slice(0);
    //�޳�������˵�������
    GetUnSaveRows(SelIds);
    if (SelIds.length==0){
		return false;   
	}
	SelIds.sort(function(a, b){ return a - b; });
	/*
	var MinRowid="",MaxRowid="";
	$.each(SelIds, function(i, item){
		if ((item>MaxRowid)&&(MaxRowid!="")){
			MaxRowid=item;
		}
		if ((item<MinRowid)&&(MaxRowid!="")){
			MinRowid=item;
		}
	});
	*/
	var MinRowid=SelIds[0];
	var MaxRowid=SelIds[SelIds.length-1];
	var rowids = $('#Order_DataGrid').getDataIDs().slice(0);
	///�����к�����˵���ɾ��
	GetUnSaveRows(rowids);
	var EnableSort=true;
	var CheckStart=0;
	for (var i = 0; i<rowids.length; i++){
		var LoopIndex=$.inArray(rowids[i],SelIds);
		if (LoopIndex!=-1){
			CheckStart=1;
		}
		if ((CheckStart==1)&&(LoopIndex==-1)&&(parseInt(SelIds[SelIds.length-1])>parseInt(rowids[i]))){
			EnableSort=false;
			break;
		}
	}
	if (EnableSort==false){
		$.messager.alert("����","��ѡ�����ڵĿ�����ƶ�!");
		return false;
	}
	
	var RecentlyRowid="";
	if (type=="up"){
		//���ҵ�ѡ���ҽ���������һ��ҽ����id
		for (var i = rowids.length-1; i >=0; i--) {
			if (parseInt(rowids[i])<parseInt(SelIds[0])){
				RecentlyRowid=rowids[i];
				break;
			}
		}
	}else{
		for (var i = 0; i <rowids.length; i++) {
			if (parseInt(rowids[i])>parseInt(SelIds[SelIds.length-1])){
				RecentlyRowid=rowids[i];
				break;
			}
		}
	}
	if (RecentlyRowid==""){return;}
	//�ҵ���Ҫ������������
	var NeedMoveRowids = new Array();
	//��¼��Ȼ������δ����,���ǹ��������ݵ�����,��Ҫ���������ʶ
	var NeedChangeMasterRowids = new Array();
	///�����߼���Ϊ���ҳ���Ҫ����ƶ�����
	//����ҽ��Ҳ��һ��������ҽ�����ϣ���ҽ�����£�����ͳһѰ����Ҫ�ƶ��ĳ�����
	var RecentlyOrderMasterSeqNo=GetCellData(RecentlyRowid, "OrderMasterSeqNo");
	var RecentlyOrderSeqNo=GetCellData(RecentlyRowid, "id");
	if (RecentlyOrderMasterSeqNo!=""){
		RecentlyOrderSeqNo=RecentlyOrderMasterSeqNo
	}
	var RecentlyLinkRowidList=GetSeqNolist(RecentlyRowid);
	if (RecentlyOrderMasterSeqNo==""){
		RecentlyLinkRowidList.push(RecentlyRowid);
	}
	RecentlyLinkRowidList.sort(function(a, b){ return a - b; });
	
	
	for (var i = 0; i < rowids.length; i++) {
        var OrderMasterSeqNo = GetCellData(rowids[i], "OrderMasterSeqNo");
        var OrderSeqNo = GetCellData(rowids[i], "id");
        var OrderItemRowid = GetCellData(rowids[i], "OrderItemRowid");
        var OrderARCIMRowid = GetCellData(rowids[i], "OrderARCIMRowid");
        var OrderType = GetCellData(rowids[i], "OrderType");
		
        if ((parseInt(rowids[i])>=parseInt(RecentlyLinkRowidList[0]))&&(parseInt(rowids[i])<=parseInt(RecentlyLinkRowidList[RecentlyLinkRowidList.length-1]))) {
	        /*
			//�����ƶ�ʱ�����ƶ�������������ݲ���Ҫ����
			//��Ȼ����������ݲ���Ҫ���ģ���������������°벿�ֵ�ҽ����������е����ݵ�������Ҫ�����޸ģ���ӵ�NeedChangeMasterRowids��
			if (((type=="down")&&(rowids[i]<=MaxRowid))||((type=="up")&&(rowids[i]>=MinRowid))){
				if ((OrderSeqNo == RecentlyOrderSeqNo)||(OrderMasterSeqNo == RecentlyOrderSeqNo)){
					NeedChangeMasterRowids.push(rowids[i]); 
				}
				continue;
			}
			*/
			if ($.inArray(rowids[i],SelIds)<0){
	    		NeedMoveRowids.push(rowids[i]);
			}
	    }
    }
    if (NeedMoveRowids.length==0){return;}
    ///����������Ҫ���ĵĶ���
    var MoveList = new Array();
    if (type=="up"){
		MoveList=SelIds.concat(NeedMoveRowids);
	}else{
		MoveList=NeedMoveRowids.concat(SelIds);
	}
	///��һ���������кţ�����¼���к������֮ǰ�кŵ�ƫ�ơ�
	var SortSeqList=new Array();
	var SortSeqList=MoveList.concat().sort(function(a, b){ return a - b; });
	var MoveRecordList=new Array();
	var DataArry=new Array();
	for (var i=0;i<MoveList.length;i++){
		var rowid=MoveList[i];
		EndEditRow(rowid);
		var curRowData = $("#Order_DataGrid").getRowData(rowid);
		var OrderMasterSeqNo=curRowData["OrderMasterSeqNo"];
		var OrderSeqNo=curRowData["id"];
        var NewSeqNo=SortSeqList[i];
		curRowData["id"]=NewSeqNo;
		MoveRecordList.push({
			OldSeqNo:OrderSeqNo,
			NewSeqNo:NewSeqNo
		});
        DataArry[DataArry.length]=curRowData;
	}
	//�ڶ����������кŵ�ƫ���������ù����ŵ�ƫ����
	for (var i=0;i<DataArry.length;i++){
		var OrderMasterSeqNo=DataArry[i].OrderMasterSeqNo;
		if (OrderMasterSeqNo==""){
			continue;
		}
		$.each(MoveRecordList,function(j,data){
			if (data.OldSeqNo==OrderMasterSeqNo){
				OrderMasterSeqNo=data.NewSeqNo;
				return false;
			}
		});
		$.extend(DataArry[i],{OrderMasterSeqNo:OrderMasterSeqNo});
		
	}
	///��������ִ�и�ֵ����
	$.each(SortSeqList,function(i,rowid){
        var NeedChangeData=DataArry[i];
        SetRowData(rowid,NeedChangeData,"");
        EditRow(rowid);
        
        //��Σҩ������ʾ
	    var OrderName=GetCellData(rowid,"OrderName");
	    var OrderHiddenPara=GetCellData(rowid, "OrderHiddenPara");
	    var PHCDFCriticalFlag=OrderHiddenPara.split(String.fromCharCode(1))[17];
	    if (PHCDFCriticalFlag=="Y"){
		    $("#"+rowid+"_OrderName").parent().parent().addClass('OrderCritical');
		}else{
			$("#"+rowid+"_OrderName").parent().parent().removeClass('OrderCritical');
		}
        
        var OrderPoisonCode=GetCellData(rowid, "OrderPoisonCode");
        var OrderPoisonRowid=GetCellData(rowid, "OrderPoisonRowid");
        $("#" + rowid).find("td").removeClass("SkinTest");
        SetPoisonOrderStyle(OrderPoisonCode, OrderPoisonRowid, rowid)
        var Status=$("#jqg_Order_DataGrid_" + rowid).prop("checked")
        if (type=="up"){
			//ǰ������
			if (i<SelIds.length){
			    if (!Status) $("#Order_DataGrid").setSelection(rowid,false);
			}else{
				if (Status) $("#Order_DataGrid").setSelection(rowid,false);
			}
		}else{
			if (i<NeedMoveRowids.length){
				if (Status) $("#Order_DataGrid").setSelection(rowid,false);
			}else{
				if (!Status) $("#Order_DataGrid").setSelection(rowid,false);
			}
		}
		var LinkedMasterOrderRowid = GetCellData(rowid, "LinkedMasterOrderRowid");
		var OrderNurseLinkOrderRowid=GetCellData(rowid, "OrderNurseLinkOrderRowid");
		if ((LinkedMasterOrderRowid!="")||(OrderNurseLinkOrderRowid!="")) {
		    initItemInstrDiv(rowid);
		}
	});
	ReSetLinkOrdClass();
}
function GetUnSaveRows(rowids){
	loop();
	function loop(){
		for (var i = 0; i < rowids.length; i++) {
	        var OrderMasterSeqNo = GetCellData(rowids[i], "OrderMasterSeqNo");
	        var OrderItemRowid = GetCellData(rowids[i], "OrderItemRowid");
	        var OrderARCIMRowid = GetCellData(rowids[i], "OrderARCIMRowid");
	        var OrderARCOSRowid = GetCellData(rowids[i], "OrderARCOSRowid");
	        var OrderType = GetCellData(rowids[i], "OrderType");
	        if (((OrderARCIMRowid == "")&&(OrderARCOSRowid=="")) || (OrderItemRowid != "")) {
		    	rowids.splice(i,1);
		    	loop();
		    	break;
		    }
	    }
	}
    return;
}

function SetUpToRowClickHandler(){
	SortRowClick("up");
}
function ReSetLinkOrdClass(){
	var MaterOrderSeqNo=new Array();
	var rowids = $('#Order_DataGrid').getDataIDs();
    for (var k = 0; k < rowids.length; k++) {
	    $("#" + rowids[k]).find("td").removeClass("OrderMasterM OrderMasterS");
	    var OrderItemRowid = GetCellData(rowids[k], "OrderItemRowid");
	    var OrderARCIMRowid = GetCellData(rowids[k], "OrderARCIMRowid");
	    if ((OrderARCIMRowid != "") && (OrderItemRowid == "")) {
		    var OrderMasterSeqNo = GetCellData(rowids[k], "OrderMasterSeqNo");
		    var OrderSeqNo=GetCellData(rowids[k],"id");
		    if (OrderMasterSeqNo!=""){
		        var mainRowData=$('#Order_DataGrid').jqGrid("getRowData",OrderMasterSeqNo);
		        if ($.isEmptyObject(mainRowData)) {
			        var OrderMasterSeqNo=GetRowIdByOrdSeqNo(OrderMasterSeqNo);
			    }
				MaterOrderSeqNo[OrderMasterSeqNo]=OrderMasterSeqNo;
			    $("#" + OrderMasterSeqNo).find("td").addClass("OrderMasterM");
			    $("#" + rowids[k]).find("td").addClass("OrderMasterS");
			}else if(MaterOrderSeqNo[OrderSeqNo]){
				$("#" + OrderSeqNo).find("td").addClass("OrderMasterM");
			}
		}
	}
}
function SetDownToRowClickHandler(){
	SortRowClick("down");
}
//���浽ģ��
function SaveToTemplate_Click()
{ 
    var SelIds=$('#Order_DataGrid').jqGrid("getGridParam", "selarrrow");            
    if(SelIds==null || SelIds.length==0) {  
        $.messager.alert("����","��ѡ��Ҫ���浽ҽ���ļ�¼");  
        return;  
    }
    var HasNosave=0
    for(var i=0;i<SelIds.length;i++){
         var OrderItemRowid=GetCellData(SelIds[i],"OrderItemRowid");
         var OrderARCIMRowid=GetCellData(SelIds[i],"OrderARCIMRowid");
         if(OrderItemRowid=="" && OrderARCIMRowid!=""){ 
            var HasNosave=1;
            break;
          }      
     }
     var AddTOArcosARCIMDatas=GetAddTOArcosARCIMDatas(SelIds)
	 if (AddTOArcosARCIMDatas=="") {
		$.messager.alert("��ʾ", "��ѡ��Ҫ���浽ҽ��ģ�����Ч��¼");
        return false;
	 }
     UDHCOEOrderSaveToTemplate(AddTOArcosARCIMDatas,function(RtnStr){
	     var ObjectType=RtnStr.split("^")[13];
	     InitOrderTemp(ObjectType);
	 });
     return websys_cancel();
}
function UDHCOEOrderSaveToTemplate(AddTOArcosARCIMDatas,callback){
    var XCONTEXT=GlobalObj.XCONTEXT
    var lnk="doc.ordsavetotemplate.hui.csp?Type="+"��ҩ"+"&AddTOArcosARCIMDatas="+escape(AddTOArcosARCIMDatas)+"&XCONTEXT="+escape(XCONTEXT);
    var obj=new Object();  
    obj.name=AddTOArcosARCIMDatas; 
    websys_showModal({
		url:lnk,
		title:'������ҽ��ģ��',
		width:810,height:440,
		paraObj:obj,
		CallBackFunc:function(CallBackData){
			if (callback) callback(CallBackData);
		}
	})
}
function GetAddTOArcosARCIMDatas(rowids){
	var ArcosMaxLinkSeqNo=1;
	OrderSubSeqNoArr = new Array();
	OrderMasterSeqNoArr = new Array();
    var retstring=""
    var len=rowids.length;
     for(var i=0;i<rowids.length;i++){ 
        //������Ѿ���˵�δ�շѲ�����¼���ҽ������
        var OrderItemRowid=GetCellData(rowids[i],"OrderItemRowid");
        var OrderARCIMRowid=GetCellData(rowids[i],"OrderARCIMRowid");
        if (OrderARCIMRowid=="") continue;
        var OrderMasterSeqNo=GetCellData(rowids[i],"OrderMasterSeqNo");
        var OrderSeqNo=GetCellData(rowids[i],"id");
        var OrderPriorRowid=GetCellData(rowids[i],"OrderPriorRowid");
        //���ڹ�����Ϊ��,Ҳ��ֵ�˹����ŵ�ҽ����ά������,��AddCopyItemToList���жϲ�Ӱ��ʹ��
        if(OrderMasterSeqNo=="") {
			//���������ҽ����ֵ,�������򲻸�ֵ
			var SubRowidsAry = GetMasterSeqNo(rowids[i]);
			if (SubRowidsAry.length > 0) {
				if (OrderMasterSeqNoArr[OrderSeqNo]) {
					OrderMasterSeqNo = OrderMasterSeqNoArr[OrderSeqNo];
				} else {
					OrderMasterSeqNo =ArcosMaxLinkSeqNo;
					OrderMasterSeqNoArr[OrderSeqNo]=ArcosMaxLinkSeqNo
				}
				ArcosMaxLinkSeqNo=ArcosMaxLinkSeqNo+1;
			}
		}else {
			if (OrderMasterSeqNoArr[OrderMasterSeqNo]) {
				var OrderMasterSeqNo=GetSubSeqNoForArcos(OrderMasterSeqNoArr[OrderMasterSeqNo])
			}else {
				OrderMasterSeqNoArr[OrderMasterSeqNo]=ArcosMaxLinkSeqNo
				var OrderMasterSeqNo=GetSubSeqNoForArcos(OrderMasterSeqNoArr[OrderMasterSeqNo])
			}
		}
        var OrderDoseQty=GetCellData(rowids[i],"OrderDoseQty");//����
        if ((OrderDoseQty!="")&&(OrderDoseQty.indexOf("-")>=0)) {
            OrderDoseQty=OrderDoseQty.split("-")[0];
        }
        var OrderDoseUOM=GetCellData(rowids[i],"OrderDoseUOMRowid");//������λ
        var OrderFreqRowID=GetCellData(rowids[i],"OrderFreqRowid"); //Ƶ��
        var OrderInstrRowID=GetCellData(rowids[i],"OrderInstrRowid"); //�÷�
        var OrderDurRowid=GetCellData(rowids[i],"OrderDurRowid");     //�Ƴ�
        var OrderPackQty=GetCellData(rowids[i],"OrderPackQty"); //����װ
        var OrderPackUOM=GetCellData(rowids[i],"OrderPackUOMRowid"); //����װ��λ
        var OrderRecDepRowid = GetCellData(rowids[i], "OrderRecDepRowid");
        var FindFlag=0;
        var BillUOMStr=GetCellData(rowids[i], "OrderPackUOMStr");
        var ArrData = BillUOMStr.split(String.fromCharCode(2));
        if (ArrData.length<=1){
            OrderRecDepRowid="";
        }else{
	        for (var k = 0; k < ArrData.length-1; k++) {
		        var ArrData1 = ArrData[k].split(String.fromCharCode(1));
		        if ((ArrData1[0] == OrderPackUOM)&&(OrderPackUOM!="")&&(OrderPackUOM!=undefined)) {
		            FindFlag=1;
		        }
		    }
		    if (FindFlag==0) OrderRecDepRowid="";
	    }
        var OrderDepProcNote=GetCellData(rowids[i],"OrderDepProcNote"); //ҽ����ע
        var OrderPriorRemarks=GetCellData(rowids[i],"OrderPriorRemarksRowId"); //����˵��
        if (OrderPriorRemarks=="false") OrderPriorRemarks="";
        var SampleId=GetCellData(rowids[i],"OrderLabSpecRowid");
        var OrderStageCode = GetCellData(rowids[i], "OrderStageCode");
        
        var OrderSpeedFlowRate=GetCellData(rowids[i],"OrderSpeedFlowRate");//��Һ����
        var OrderFlowRateUnitRowId=GetCellData(rowids[i],"OrderFlowRateUnitRowId"); //���ٵ�λ
        var OrderBodyPartLabel=GetCellData(rowids[i], "OrderBodyPartLabel");
        var OrderFreqTimeDoseStr=GetCellData(rowids[i], "OrderFreqTimeDoseStr");//ͬƵ�β�ͬ����
        var OrderFreqWeekStr=GetCellData(rowids[i], "OrderFreqDispTimeStr"); //��Ƶ��
        var OrderSkinTest=GetCellData(rowids[i], "OrderSkinTest");
        var OrderActionRowid=GetCellData(rowids[i], "OrderActionRowid");
        var Urgent=GetCellData(rowids[i], "Urgent");
        //SampleId �걾ID,ARCOSItemNO  ����ָ��λ��(ҽ��¼�벻��), OrderPriorRemarksDR As %String
        if (retstring==""){
            retstring=OrderARCIMRowid+"^"+OrderPackQty+"^"+OrderDoseQty+"^"+OrderDoseUOM+"^"+OrderFreqRowID+"^"+OrderDurRowid+"^"+OrderInstrRowID+"^"+OrderMasterSeqNo+"^"+OrderDepProcNote+"^"+OrderPriorRowid+"^"+SampleId+"^"+""+"^"+OrderPriorRemarks+"^"+OrderStageCode+"^"+OrderSpeedFlowRate+"^"+OrderFlowRateUnitRowId+"^"+OrderPackUOM+"^"+OrderRecDepRowid+"^"+OrderBodyPartLabel+"^"+OrderFreqTimeDoseStr+"^"+OrderFreqWeekStr+"^"+OrderSkinTest+"^"+OrderActionRowid+"^"+Urgent;
        }else{
            retstring=retstring+String.fromCharCode(3)+OrderARCIMRowid+"^"+OrderPackQty+"^"+OrderDoseQty+"^"+OrderDoseUOM+"^"+OrderFreqRowID+"^"+OrderDurRowid+"^"+OrderInstrRowID+"^"+OrderMasterSeqNo+"^"+OrderDepProcNote+"^"+OrderPriorRowid+"^"+SampleId+"^"+""+"^"+OrderPriorRemarks+"^"+OrderStageCode+"^"+OrderSpeedFlowRate+"^"+OrderFlowRateUnitRowId+"^"+OrderPackUOM+"^"+OrderRecDepRowid+"^"+OrderBodyPartLabel+"^"+OrderFreqTimeDoseStr+"^"+OrderFreqWeekStr+"^"+OrderSkinTest+"^"+OrderActionRowid+"^"+Urgent;
        }
    }
    return retstring
}
function OrderOperationchangehandler(e){
    try{
        var rowid=GetEventRow(e);
        var obj=websys_getSrcElement(e);
        var OrderOperationCode=obj.value;
        SetCellData(rowid,"OrderOperationCode",OrderOperationCode);
        var OrderOperation=GetCellData(rowid, "OrderOperation");
    	var OrderOperationCode=GetCellData(rowid, "OrderOperationCode");
        var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
        if (OrderMasterSeqNo!="") {
		    rowid=OrderMasterSeqNo;
		    if (GetEditStatus(rowid) == true) {
            	SetCellData(rowid, "OrderOperation", OrderOperationCode);
            }else{
	            SetCellData(rowid, "OrderOperation", OrderOperation);
	        }
            SetCellData(rowid, "OrderOperationCode", OrderOperationCode);
	    }
        ChangeLinkOrderOperation(rowid,OrderOperation,OrderOperationCode);
    }catch(e){$.messager.alert("����",e.message)}
}

function ChangeLinkOrderOperation(Row,OrderOperation,OrderOperationCode){
    var OrderSeqNo=GetCellData(Row, "id");
    try {
        var rows = $('#Order_DataGrid').getDataIDs();
        for (var i = 0; i < rows.length; i++) {
            var rowid = rows[i];
            var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
            var OrderItemRowid = GetCellData(rowid, "OrderItemRowid");
            var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
            var OrderType = GetCellData(rowid, "OrderType");
            if ((OrderMasterSeqNo != OrderSeqNo) || (OrderARCIMRowid == "") || (OrderItemRowid != "")) { continue; }
            if (GetEditStatus(rowid) == true) {
            	SetCellData(rowid, "OrderOperation", OrderOperationCode);
            }else{
	            SetCellData(rowid, "OrderOperation", OrderOperation);
	        }
            SetCellData(rowid, "OrderOperationCode", OrderOperationCode);
        }
    } catch (e) { $.messager.alert("����", e.message) }
}
function GetOperationStr(){
    var AnaesthesiaID=GetMenuPara("AnaesthesiaID");
    var OperationStr = cspRunServerMethod(GlobalObj.GetOperInfoMethod,AnaesthesiaID);
    $.extend(GlobalObj,{OperationStr:OperationStr});
    return true
}
///Ƶ���Ƴ̹����¼�
function FreqDurChange(rowid)
{
    //ST����ҽ��������¼�������Ƴ�ֻ����1��
    var OrderFreqRowid=GetCellData(rowid,"OrderFreqRowid");
    var OrderVirtualtLong=GetCellData(rowid, "OrderVirtualtLong");
    if (GlobalObj.PAAdmType != "I")
    {
	    if (OrderVirtualtLong=="Y"){
			var styleConfigObj = { OrderDur: false }
			ChangeCellDisable(rowid, styleConfigObj);
			
		}else if (OrderFreqRowid == GlobalObj.STFreqRowid) 
        {
            var rtn=tkMakeServerCall("web.DHCDocOrderCommon", "GetFirstDurByWeekFreq", 1);
            if (rtn!=""){
                var OrderDurRowid=rtn.split(",")[0];
                var OrderDur=rtn.split(",")[1];
                var OrderDurFactor=rtn.split(",")[3];
                SetCellData(rowid, "OrderDur", OrderDur)
                SetCellData(rowid, "OrderDurRowid", OrderDurRowid);
                SetCellData(rowid, "OrderDurFactor", OrderDurFactor);
                var styleConfigObj = { OrderDur: false }
                ChangeCellDisable(rowid, styleConfigObj);
                DurChangeFlag=1;
            }
            
        }else{
            var OrderARCIMRowid = GetCellData(rowid,"OrderARCIMRowid");
			if (OrderARCIMRowid!=""){
				var rtn=tkMakeServerCall("web.DHCDocOrderCommon","CanFrequenc",OrderARCIMRowid);
				if (rtn=="Y"){
					var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
					if (OrderMasterSeqNo==""){
						var styleConfigObj = { OrderDur: true }
						ChangeCellDisable(rowid, styleConfigObj);
					}
				}else{
					var styleConfigObj = { OrderDur: false }
					ChangeCellDisable(rowid, styleConfigObj);
					DurChangeFlag=1;
				
				}
			}
            
        }
    }
}
///��ʾ����ʾ�ơ���
function OrderMKLightShow(value,rowData,rowIndex){
	var str="<label id=\""+"_"+rowIndex.id+"_"+"OrderMKLight"+"\" name=\""+"_"+rowIndex.id+"_"+"OrderMKLight"+ "\"><div id=\"McRecipeScreenLight_" + rowIndex.id + "\"  class=\"mcScreenLight_null\" onclick = \"MDC_ShowWarningHint("+rowIndex.id+")\" WIDTH=80></div></label>";
	return str;
}
function OpenOrdCASign(){
	var lnk = "docorder.casign.hui.csp?EpisodeID=" + GlobalObj.EpisodeID + "&ViewAll=ALL";
    window.open(lnk, true, "status=1,scrollbars=1,top=20,left=10,width=1300,height=690");
}
function ClearNameTabs(){
	$("#mmedit div").remove();
	var _$tab=$('#templName_tabs');
	var tabs=_$tab.tabs('tabs');
	for (var i=tabs.length-1;i>=0;i--){
		_$tab.tabs('close',i);
	}
}
function ClearTree(){
    var tbox=$HUI.tree("#OrdTemplTree");
    var roots=tbox.getRoots();
    for (var i=roots.length-1;i>=0;i--){
	  var node = tbox.find(roots[i].id);
	  tbox.remove(node.target);
    }
}
function getCheckedNodes(){
	var nodeArr=new Array();
	var nodes = $("#OrdTemplTree").tree('getChecked');
	for (var i=0;i<nodes.length;i++){
		var eleid=nodes[i]['value'];
		if (eleid=="") continue;
		var isLeaf=$("#OrdTemplTree").tree('isLeaf',nodes[i].target);
		if (isLeaf) {
			nodeArr.push(eleid.replace(/\^/g,String.fromCharCode(4)));
		}
	}
	return nodeArr;
}
function clearCheckedNodes(){
	var nodes = $("#OrdTemplTree").tree('getChecked');
	for (var i=0;i<nodes.length;i++){
		var eleid=nodes[i]['eleid'];
		if (eleid=="") continue;
		var node = $('#OrdTemplTree').tree('find', nodes[i]['id']);
		$("#OrdTemplTree").tree('uncheck',node.target);
	}
}
function Changebiggrid(statusheight){
	var layout = $("#layout_main");
	var center = layout.layout('panel', 'center');
	if (GlobalObj.layoutConfig == 2) { //סԺ ҽ�������� ����
		var north=layout.layout('panel', 'north');
		if (statusheight==1){
			center.panel('minimize');
			north.panel('maximize');			
		}else{
			center.panel('restore').panel("open");
			north.panel('restore');
		}
	}else{
		var south=layout.layout('panel', 'south');
		if (statusheight==1){
			center.panel('minimize');
			south.panel('maximize');
		}else{
			center.panel('restore').panel("open");
			south.panel('restore');
		}
	}
	$('#layout_main').layout('resize');
	ResizeGridWidthHeiht("resize");
	ResizePromptWidth();
}
/**
* @description: ���û�ѡ����Ƶ��ִ�������������û���ѡ��
* @param {String} 
* @return: {String} 
*/
function GetOrderFreqWeekStr(OrderFreqRowid,OrderFreqDispTimeStr,OrderName,callBackFun){
	var OrderFreqDispTimeStr=OrderFreqDispTimeStr.split(String.fromCharCode(1)).join("A");
	OrderFreqDispTimeStr=OrderFreqDispTimeStr.split(String.fromCharCode(2)).join("B");
	OrderFreqDispTimeStr=OrderFreqDispTimeStr.replace(/:/g,"C");
	websys_showModal({
		url:"doc.weekfreqselector.csp?OrderFreqDispTimeStr=" + OrderFreqDispTimeStr+"&OrderFreqRowid="+OrderFreqRowid,
		title:OrderName+' ��Ƶ��ѡ��',
		width:300,height:410,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if (typeof result=="undefined"){
				result="";
			}
			callBackFun(result);
		}
	})
}
/// ��Ƶ����չ�ַ���ת��Ϊ�洢��ҽ��������ݴ�
function CalOrderFreqExpInfo(OrderFreqDispTimeStr)
{
	var OrderFreqWeekStr="",OrderFreqFreeTimeStr="";
	if (OrderFreqDispTimeStr==""){
		return OrderFreqWeekStr+"^"+OrderFreqFreeTimeStr;
	}
	var ArrData = OrderFreqDispTimeStr.split(String.fromCharCode(1));
    for (var i = 0; i < ArrData.length; i++) {
        var ArrData1 = ArrData[i].split(String.fromCharCode(2));
        var DispTime = ArrData1[0];
        var DispWeek = ArrData1[1];
        var PHCDTRowID = ArrData1[2];
        if (DispWeek!=""){
	        //��Ƶ��
	        if (OrderFreqWeekStr.indexOf(DispWeek)>=0){
		    	continue;
		    }
	        if (OrderFreqWeekStr==""){
		    	OrderFreqWeekStr=DispWeek; 
		    }else{
				OrderFreqWeekStr=OrderFreqWeekStr+"|"+DispWeek; 
			}
        }else if ((DispTime!="")&&(PHCDTRowID!="")){
	    	//������ַ�ʱ��Ƶ��
	    	if (OrderFreqFreeTimeStr.indexOf(DispTime)>=0){
		    	continue;
		    }
			if (OrderFreqFreeTimeStr==""){
		    	OrderFreqFreeTimeStr=DispTime; 
		    }else{
				OrderFreqFreeTimeStr=OrderFreqFreeTimeStr+"|"+DispTime; 
			}
	    }
    }
    return OrderFreqWeekStr+"^"+OrderFreqFreeTimeStr;
}
/**
* @description: ���û�ѡ�񲻹���ַ�ʱ��Ƶ�εķַ�ʱ�䲢����
* @param {String} 
* @return: {String} 
*/
function GetOrderFreqFreeTimeStr(OrderFreqRowid,OrderFreqDispTimeStr,OrderName,callBackFun,OrderItemVerifiedObj){
	var OrderFreqDispTimeStr=OrderFreqDispTimeStr.split(String.fromCharCode(1)).join("A");
	OrderFreqDispTimeStr=OrderFreqDispTimeStr.split(String.fromCharCode(2)).join("B");
	OrderFreqDispTimeStr=OrderFreqDispTimeStr.replace(/:/g,"C");
	var LinkedMasterOrderFreFactor="";
	if (OrderItemVerifiedObj) {
		LinkedMasterOrderFreFactor=OrderItemVerifiedObj.LinkedMasterOrderFreFactor;
	}
	websys_showModal({
		url:"dhcdoc.freq.disptime.csp?OrderFreqDispTimeStr=" + OrderFreqDispTimeStr+"&OrderFreqRowid="+OrderFreqRowid+"&LinkedMasterOrderFreFactor="+LinkedMasterOrderFreFactor,
		title:OrderName+' �ַ�ʱ��ѡ��',
		width:370,height:410,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if (typeof result=="undefined"){
				result="";
			}
			callBackFun(result);
		}
	})
	
}

function AddCPWOrdClickHandler(){
	// \scripts\DHCMA\SS\interface\ToDoctor.js ҽ����ӿ�
	addOrdItemToDoc(GlobalObj.EpisodeID,"W",addOEORIByCPW,GlobalObj.PAAdmType);
}
function menuHandler(item){
	var tab = $('#templName_tabs').tabs('getSelected');
	if (tab){
		$('#templName_tabs').tabs('unselect',$('#templName_tabs').tabs('getTabIndex',tab));
	}
	templNameTabSelect(+item['id']-1);
}
function CheckMasterOrdStyle()
{
    var allrowids = GetAllRowId();
    for (var i = 0; i < allrowids.length; i++) {
        var id1 = allrowids[i];
        var ItemRowid1 = GetCellData(id1, "OrderItemRowid");
        if (ItemRowid1 != "") { continue }
        var OrderSeqNo1 = GetCellData(id1, "id");
        var MasterSeqNo1 = GetCellData(id1, "OrderMasterSeqNo");
        if (MasterSeqNo1!="") continue;
        var isMasterOrdFlag=0;
        for (var j = 0; j < allrowids.length; j++) {
	        var id2 = allrowids[j];
	        var ItemRowid2 = GetCellData(id2, "OrderItemRowid");
	        if (ItemRowid2 != "") { continue }
	        var OrderSeqNo2 = GetCellData(id2, "id");
	        var MasterSeqNo2 = GetCellData(id2, "OrderMasterSeqNo");
	        if (MasterSeqNo2=="") continue;
	        if (OrderSeqNo1==MasterSeqNo2) isMasterOrdFlag=1;break;
	    }
	    if (isMasterOrdFlag==0){
		    $("#" + id1).find("td").removeClass("OrderMasterM");
		}else{
			$("#" + id1).find("td").addClass("OrderMasterM");
		}
    }
}

//ʹ�þֲ�ˢ��,��������һ����Ⱦ�����ظ�ʹ�ýϿ�
function xhrRefresh(Args){
	$(".messager-button a").click(); //�Զ��ر���һ�����ߵ�alert����
	//�п��������ƽ���û������CheckLinkDetails,��������ط��л�ʧ�ܣ����ⲻ�ֲܾ�ˢ���ˣ�Ҫ����url
	if (typeof GlobalObj=="undefined"){
		ReloadUrl(Args.adm,Args.papmi,Args.madm)
		return;
	}
	CopyOeoriDataArr = new Array();
	if ((typeof Args.copyOeoris !="undefined")&&(typeof Args.copyTo !="undefined")&&(Args.copyOeoris !="")){
		var copyOeorisArr=Args.copyOeoris.split("^");
		var CopyPriorCodeRowid = cspRunServerMethod(GlobalObj.GetOrderPriorByCodeMethod, Args.copyTo);
		for (var i = 0; i < copyOeorisArr.length; i++) {
			var dataItem = tkMakeServerCall("web.DHCDocMain", "CreateCopyItem", copyOeorisArr[i],CopyPriorCodeRowid);
			if (dataItem=="") continue
			CopyOeoriDataArr.push(dataItem);
		}
	}
	var papmi=GetMenuPara("PatientID");
	var adm=GetMenuPara("EpisodeID");
	var EpisPatObj={EpisodeID:Args.adm};
	var FixedEpisodeID=GetFixedEpisodeID(EpisPatObj);
	if (FixedEpisodeID!="") adm=FixedEpisodeID;
	if ((adm==GlobalObj.EpisodeID)||(adm=="")){
		if (CopyOeoriDataArr.length>0){
			AddCopyItemToList(CopyOeoriDataArr);
			CopyOeoriDataArr=undefined;
		}
		//HideWindowMask();
		return
	}
	DocumentUnloadHandler(); //�˷����ڵ�ClearSessionData��ɾ���������ݣ�����ں�̨��������֮ǰ����ֹ�����л��Ļ��ߵļ�����¼�����
	var EpisPatInfo = tkMakeServerCall("web.DHCDocViewDataInit", "InitPatOrderViewGlobal", adm,"",GlobalObj.EmConsultItm);
	var EpisPatObj=eval("("+EpisPatInfo+")");
	///������������ǿ��ˢ�£���֤������ʽ��ȷ�仯
	if (
		(EpisPatObj.OnlyShortPrior!=GlobalObj.OnlyShortPrior)||
		(EpisPatObj.LoginAdmLocFlag!=GlobalObj.LoginAdmLocFlag)||
		(EpisPatObj.PAAdmType!=GlobalObj.PAAdmType)||
		(EpisPatObj.IsShowOrdList!=GlobalObj.IsShowOrdList)||
		(EpisPatObj.INAdmTypeLoc!=GlobalObj.INAdmTypeLoc)||
		((GlobalObj.DoctorType=="DOCTOR")&&(EpisPatObj.CPWOrdFlag!=GlobalObj.CPWOrdFlag))
	){
		ReloadUrl(EpisPatObj.EpisodeID,EpisPatObj.PatientID,EpisPatObj.mradm);
		return;
	}
	$(".window-mask.alldom").show();
	
	InitPatOrderViewGlobal(EpisPatInfo);
	//�Ƶ���ջ����֤��������չʾ--PB by tanjishan ���ĳ��ֶ������α�������ⲽ
	//window.requestAnimationFrame(function(){
		
		$('#Order_DataGrid').jqGrid('clearGridData');
		var postData=$('#Order_DataGrid').jqGrid("getGridParam", "postData");
		$.extend(postData,{ADMID:GlobalObj.EpisodeID});
		///ˢ�����ϵĲ���������ݣ�����ѱ�
		var colModel=$('#Order_DataGrid').jqGrid("getGridParam", "colModel");
		colModel=colModel.slice(0,1).concat(ListConfigObj.colModel)
		$('#Order_DataGrid').jqGrid("setGridParam", {colModel:colModel,postData:postData}).trigger('reloadGrid');
		if (CopyOeoriDataArr.length>0){
			AddCopyItemToList(CopyOeoriDataArr);
			CopyOeoriDataArr=undefined;
		}
		if ($("#ChronicDiag").length>0){
			$("#ChronicDiag").lookup("setValue","").lookup("setText","");
		}
		if (($("#orderListShow").length > 0)&&($("#orderListShow")[0].contentWindow.ipdoc)&&(typeof $("#orderListShow")[0].contentWindow.ipdoc.patord.view.xhrRefresh=="function")){
			$("#orderListShow")[0].contentWindow.ipdoc.patord.view.xhrRefresh(GlobalObj.EpisodeID,HideWindowMask);
		}else{
			HideWindowMask();
		}
	//});
	function ReloadUrl(EpisodeID,PatientID,mradm){
		if (typeof(history.pushState) === 'function') {
	        var Url=window.location.href;
	        Url=rewriteUrl(Url, {
		        EpisodeID:EpisodeID,
	        	PatientID:PatientID,
	        	mradm:mradm,
	        	EpisodeIDs:"",
	        	copyOeoris:"",
	        	copyTo:""});
	        history.pushState("", "", Url);
	        window.location.reload();
	        return;
	    }
		return;
	}
}
function GetFixedEpisodeID(EpisPatObj){
	var FixedEpisodeID="";
	if ((parent)&&((parent.FixedEpisodeID)&&(typeof parent.FixedEpisodeID!="undefined"))){
		FixedEpisodeID=parent.FixedEpisodeID;
	}
	if ((parent.parent.FixedEpisodeID)&&(typeof parent.parent.FixedEpisodeID!="undefined")){
		FixedEpisodeID=parent.parent.FixedEpisodeID;
	}
	// ����ʶswitchSysPatΪN,�õ���request�ڵĲ���,�Ҳ����л�����
	if ((parent.switchSysPat)&&(parent.switchSysPat=="N")) {
		FixedEpisodeID=EpisPatObj.EpisodeID;
	}
	return FixedEpisodeID;
}
function InitPatOrderViewGlobal(EpisPatInfo){
	try {
		var EpisPatObj=eval("("+EpisPatInfo+")");
		var AnaesthesiaID=GetMenuPara("AnaesthesiaID");
		var PPRowId=GetMenuPara("PPRowId");
		
		$.extend(EpisPatObj,{
			AnaesthesiaID:AnaesthesiaID,
			PPRowId:PPRowId
		});
		var adm=GetMenuPara("EpisodeID");
		var FixedEpisodeID=GetFixedEpisodeID(EpisPatObj);
		if ((adm!="")&&(adm!=EpisPatObj.EpisodeID)&&(FixedEpisodeID!=EpisPatObj.EpisodeID)){
			xhrRefresh({adm:adm});
			return;
		}
		$.extend(GlobalObj,EpisPatObj);
		for (key in VerifiedOrderObj) {
			VerifiedOrderObj[key] = "";
		}
		//f12����ģʽ���п��ܻ���alert���ֻ�ڱ�frame��ǰ������frame�µĲ˵����ǿ����л��������ǲ����б�,����һ����������������
		if (GlobalObj.PilotProCareFlag=="-1") {
			$.messager.alert("����","�û������ڲ���һ��Ŀ�ٴ����飬�����˽���ϸ��Ϣ�������о�ҽ��:"+GlobalObj.PilotProCare+" ��ϵ.","info");
		}
		if ((GlobalObj.PatInIPAdmission==1)&&(GlobalObj.PAAdmType!="I")){
			$.messager.alert("����",'��������סԺ!');
		}
		if (GlobalObj.IsDeceased=="Y"){
			 $.messager.alert("����",'�����ѹ�!')
		}
		
		var warning=GetPromptHtml();
		$("#Prompt").html(warning);
		///�����ڲ���Ʒ�鸴�ƹ�����ҽ����Ϣ
		if (GlobalObj.CopyItemJson!=""){
			var CopyItemObj=eval("("+GlobalObj.CopyItemJson+")");
			if (CopyItemObj.length>0){
				if (typeof CopyOeoriDataArr=="undefined"){
					CopyOeoriDataArr=new Array();
				}
				for (var i = 0; i < CopyItemObj.length; i++) {
					CopyOeoriDataArr.push(CopyItemObj[i].Data);
				}
			}
		}
		var Index=$.inArray($g("�ѱ�"),ListConfigObj.colNames);
		if (Index>=0){
			ListConfigObj.colModel[Index].editoptions.value=GlobalObj.PrescriptTypeStr;
		}
		if ($("#Order_DataGrid").jqGrid('getGridParam','colNames')) {
			var Index=$.inArray("�ѱ�",$("#Order_DataGrid").jqGrid('getGridParam','colNames'))
			if (Index>=0){
				$("#Order_DataGrid").jqGrid('getGridParam',"colModel")[Index].editoptions.value=GlobalObj.PrescriptTypeStr;
			}
		}
		GetDefaultPilotPro();
		if (GlobalObj.OnlyShortPrior=="Y"){
			$('#ShortOrderPrior').click();
			$("#LongOrderPrior").hide()
			$("#OutOrderPrior").hide()
		}else{
			$("#LongOrderPrior").show()
			$("#OutOrderPrior").show()
		}
		InitBtnDisplay();
		if (GlobalObj.CPWOrdFlag=="1") {
			$("#Add_CPWOrd").show();
		}else{
			$("#Add_CPWOrd").hide();
		}
		 if (EpisPatObj.PracticeShowFlag>0){
			ShowPracticeOrder();
		}
	}catch(e) {
		//�˷����ֲ�ˢ�º�ҳ���ʼ��ʱ�����,���������ܵ��´������Ų�,��Ӵ�����ʾ����Ϣ
		$.messager.alert("��ʾ��Ϣ","����InitPatOrderViewGlobal�����쳣,������Ϣ��"+e.message); 
		return false;
	}
}
function InitBtnDisplay(){
	try{
		//�Ҽ�ˢ�»��߳��ν������ʱ������Ԫ�ػ�δ��ʼ����ϣ�����hui��������InitLayOut����
	    if (GlobalObj.EnableButton == 0) {
		    DisableBtn("Insert_Order_btn",true);
		    DisableBtn("Delete_Order_btn",true);
		    DisableBtn("Add_Order_btn",true);
	    }else{
			DisableBtn("Insert_Order_btn",false);
		    DisableBtn("Delete_Order_btn",false);
		    DisableBtn("Add_Order_btn",false);
		}
	}catch(e){}
}
function ReSetPilotDefaultData(){
	GlobalObj.PilotProStr="";
	GlobalObj.CFPilotPatAdmReason="";
	GlobalObj.CFIPPilotPatAdmReason="";
	GlobalObj.PilotProWarning="";
}
function InitRowLookUp(rowid){
	InitOrderNameLookup(rowid);
	InitOrderInstrLookup(rowid);
	InitOrderFreqLookup(rowid);
	InitOrderDurLookup(rowid);
	InitDateFlatpickr(rowid);
}
function InitOrderNameLookup(rowid){ 
	$("#"+rowid+"_OrderName").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'ARCIMDesc',
        columns:[[  
           {field:'ARCIMDesc',title:'ҽ������',width:250,sortable:false},
           {field:'subcatdesc',title:'����',width:100,sortable:false},
           {field:'ItemPrice',title:'�۸�',width:80,sortable:false},
           {field:'BasicDrugFlag',title:'����ҩ��',width:90,sortable:false},
           {field:'billuom',title:'�Ƽ۵�λ',width:90,sortable:false},
           {field:'StockQty',title:'�����',width:80,sortable:false},
           {field:'PackedQty',title:'�����',width:80,sortable:false},
           {field:'GenericName',title:'ͨ����',width:120,sortable:false},
           {field:'FormDesc',title:'����',width:90,sortable:false},
           {field:'ResQty',title:'��;��',width:80,sortable:false},
           {field:'DerFeeRules',title:'�շѹ涨',width:90,sortable:false},
           {field:'InsurClass',title:'ҽ�����',width:90,sortable:false},
           {field:'InsurSelfPay',title:'�Ը�����',width:90,sortable:false},
           {field:'Recloc',title:'���տ���',width:100,sortable:false},
           {field:'arcimcode',title:'����',width:90,sortable:false}
        ]],
		enableNumberEvent:true,
        pagination:true,
        rownumbers:true,
        panelWidth:1000,
        panelHeight:330,
        isCombo:GlobalObj.OEORIRealTimeQuery==1?true:false,
        minQueryLen:2,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocOrderEntry',QueryName: 'LookUpItem'},
        rowStyler: function(index,row){
	        var ArcimID=row["HIDDEN"];
            var Type=row["HIDDEN2"];
            var OrderType=row["HIDDEN4"];
            var HaveStock=row["HIDDEN16"];
            var INCIItemLocked=row["INCIItemLocked"];
            if (INCIItemLocked=="Y") {
	            return 'background-color:#FF8C00;';
	        }
            if ((OrderType=="R")&&(Type="ARCIM")&&(HaveStock!="Y")){
	            return 'background-color:#DDA0DD;';
            }
	    },
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
	        PageLogicObj.SearchName=desc;
		    var CurLogonDep = session['LOGON.CTLOCID'];
		    var GroupID = session['LOGON.GROUPID'];
		    var catID = "",subCatID="",OrdCatGrp="";
		    var LogonDep = GetLogonLocByFlag();
		    var P5 = "",P9 = "",P10 = "";
		    var OrderPriorRowid = GetCellData(rowid, "OrderPriorRowid");
		    var OrderPriorRemarks = GetCellData(rowid, "OrderPriorRemarksRowId");
		    OrderPriorRowid = ReSetOrderPriorRowid(OrderPriorRowid, OrderPriorRemarks);
		    // ҽ�����ͷ�ǿ��ģʽʱ����ҽ�����ж�ҽ������
		    if (GlobalObj.OrderPriorContrlConfig=="2"){
			    OrderPriorRowid="";
			}
		    var OrdCateGoryRowId = GetCellData(rowid, "OrdCateGoryRowId")
		    var OrdCateGoryObj = document.getElementById(rowid + "_OrdCateGory");
		    if (OrdCateGoryObj){
		       if (+OrdCateGoryObj.scrollWidth != "0") OrdCatGrp = OrdCateGoryRowId
		    }
			param = $.extend(param,
				{Item:desc,GroupID:GroupID,Category:"",SubCategory:"",TYPE:P5,
				 OrderDepRowId:LogonDep,OrderPriorRowId:OrderPriorRowid,
				 EpisodeID:GlobalObj.EpisodeID,BillingGrp:P9,BillingSubGrp:P10,UserRowId:session["LOGON.USERID"],
				 OrdCatGrp:OrdCatGrp,NonFormulary:"",Form:CurLogonDep,Strength:"",Route:""
       	   });
	    },onSelect:function(ind,item){
			if (!item) return;
		    var ItemArr=new Array();
		    $.each(item, function(key, val) {
				ItemArr.push(val);
			});
			$("#"+rowid+"_OrderName").parent().parent().removeClass('OrderCritical');
			$("#" + rowid).find("td").removeClass("SkinTest");
			SetCellData(rowid, "OrderARCIMRowid","");
    		SetCellData(rowid, "OrderARCOSRowid","");
			OrderItemLookupSelect(ItemArr.join("^"),rowid);
		},onHidePanel:function(){
			PageLogicObj.LookupPanelIsShow=0;
		},onShowPanel:function(){
			PageLogicObj.LookupPanelIsShow=1;
		},onBeforeShowPanel:function(){
			if ($(".window-mask").is(":visible")){
				//$(".messager-button a").click();
				return false;
			}
			$(this).lookup('panel').panel('resize',{width:1000});
		},selectRowRender:function(row){
			var OrderMsg="";
			if ((row)&&(row['Recloc'])) {
				var INCIItemLocked=row["INCIItemLocked"];
				var CFNotAutoChangeRecloc=GlobalObj.CFNotAutoChangeRecloc;
				if ((row['Recloc'].split("/").length==1)&&(INCIItemLocked!="Y")&&(CFNotAutoChangeRecloc==1)){
					OrderMsg=row['Recloc']+":"+row['StockQty'];
				}else{
					var OrderDepRowId= "";
					if ($("#FindByLogDep").checkbox("getValue")){
						OrderDepRowId= session['LOGON.CTLOCID'];
					}
					OrderMsg = tkMakeServerCall("web.DHCDocOrderCommon", "GetOrderStockMsg", GlobalObj.EpisodeID,row['HIDDEN'],row['Recloc'],OrderDepRowId);
				}
			}
            var innerHTML="<div style='height:100px;background:#FFFFFF'>";
            innerHTML=innerHTML+"<div style='width:1000px;color:red;font-size:18px;'>";
            innerHTML=innerHTML+OrderMsg;
            innerHTML=innerHTML+"</div>";
            innerHTML=innerHTML+"</div>";
            return innerHTML;
		}
    });
    $("#"+rowid+"_OrderName").change(OrderNameChangeHandle);
}
function OrderNameChangeHandle(e){
	var id=e.currentTarget.id;
	var Row=id.split("_")[0];
	var OrderName = GetCellData(Row, "OrderName");
	if (OrderName=="") {
		var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
		var OrderARCOSRowid = GetCellData(Row, "OrderARCOSRowid");
		if ((OrderARCIMRowid!="")||(OrderARCOSRowid!="")){
			$.messager.confirm("ȷ�϶Ի���", "ҽ����������գ��Ƿ�ɾ�����У�", function (r) {
				if (r) {
					DeleteRow(Row);
					var records = $('#Order_DataGrid').getGridParam("records");
			        if (records == 0) {
			            $('#cb_Order_DataGrid').prop('checked', false);
			            Add_Order_row();
			        }
				}else{
					if (OrderARCIMRowid!="") {
						$.cm({
						    ClassName:"web.DHCDocOrderCommon",
						    MethodName:"GetFormateOrderName",
						    ArcimRowid:OrderARCIMRowid,
						    CurLogonHosp:session['LOGON.HOSPID'],
						    dataType:"text"
						},function(OrderName){
							SetCellData(Row, "OrderName",OrderName);
						})
					}else{
						$.cm({
						    ClassName:"web.DHCDocOrderCommon",
						    MethodName:"GetARCOSName",
						    ARCOSRowid:OrderARCOSRowid,
						    dataType:"text"
						},function(ARCOSName){
							SetCellData(Row, "OrderName",ARCOSName);
						})
					}
				}
			});
		}
	}
}
function InitDateFlatpickr(rowid){
	var dateFormate="d/m/Y H:i:S"; //d-m-Y H:i:S
    if (PageLogicObj.defaultDataCache==3){
        dateFormate="Y-m-d H:i:S"
    }
    PageLogicObj.fpArr.push({"rowid":rowid});
    var index=$.hisui.indexOfArray(PageLogicObj.fpArr,"rowid",rowid);
	PageLogicObj.fpArr[index].OrderStartDate=$("#"+rowid+"_OrderStartDate").flatpickr({
    	enableTime: true,
    	enableSeconds:true,
    	dateFormat: dateFormate,
    	time_24hr: true,
    	onOpen:function(pa1,ap2){
	    	var index=$.hisui.indexOfArray(PageLogicObj.fpArr,"rowid",rowid);
	        PageLogicObj.fpArr[index]["OrderStartDate"].setDate(ap2,true);
	    }
    })
    PageLogicObj.fpArr[index].OrderDate=$("#"+rowid+"_OrderDate").flatpickr({
    	enableTime: true,
    	enableSeconds:true,
    	dateFormat: dateFormate,
    	time_24hr: true,
    	onOpen:function(pa1,ap2){
	    	var index=$.hisui.indexOfArray(PageLogicObj.fpArr,"rowid",rowid);
	        PageLogicObj.fpArr[index]["OrderDate"].setDate(ap2,true);
	    }
 
    })
    PageLogicObj.fpArr[index].OrderEndDate=$("#"+rowid+"_OrderEndDate").flatpickr({
    	enableTime: true,
    	enableSeconds:true,
    	dateFormat: dateFormate,
    	time_24hr: true,
    	onOpen:function(pa1,ap2){
	    	var index=$.hisui.indexOfArray(PageLogicObj.fpArr,"rowid",rowid);
	        PageLogicObj.fpArr[index]["OrderEndDate"].setDate(ap2,true);
	    }
 
    })
}

function InitOrderInstrLookup(rowid){
	$("#"+rowid+"_OrderInstr").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'Desc',
        columns:[[  
           {field:'Desc',title:'�÷�����',width:130,sortable:false},
           {field:'Code',title:'�÷�����',width:130,sortable:false}
        ]],
        pagination:true,
        panelWidth:300,
        panelHeight:300,
        isCombo:true,
        minQueryLen:0,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocOrderCommon',QueryName: 'LookUpInstr'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
		    var ARCIMRowId = GetCellData(rowid, "OrderARCIMRowid");
		    var OrderSkinTest=GetCellData(rowid, "OrderSkinTest");
    		var OrderActionRowid=GetCellData(rowid, "OrderActionRowid");
    		var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
    		var OrderInstrRowid=GetCellData(rowid, "OrderInstrRowid");
    		
    		var NeedSkinTestINCI = mPiece(OrderHiddenPara, String.fromCharCode(1), 7);
    		if ((NeedSkinTestINCI!="Y")&&$("#" + rowid).find("td").hasClass("OrderMasterM")){
				var RowArry = GetSeqNolist(rowid)
		        for (var i = 0; i < RowArry.length; i++) {
		            var OrderHiddenPara = GetCellData(RowArry[i], "OrderHiddenPara");
		            NeedSkinTestINCI = mPiece(OrderHiddenPara, String.fromCharCode(1), 7);
		            if (NeedSkinTestINCI=="Y"){
			            OrderSkinTest=GetCellData(RowArry[i], "OrderSkinTest");
    					OrderActionRowid=GetCellData(RowArry[i], "OrderActionRowid");
    					OrderInstrRowid=GetCellData(RowArry[i], "OrderInstrRowid");
			        	break;   
			        }
		        }
			}
		    var SeachSkinInstrFlag="";
		    var Instr="^"+OrderInstrRowid+"^";
			//�������ҽ������������ѡ��Ƥ���÷�
			if (NeedSkinTestINCI=="Y"){
				if ((GlobalObj.SkinTestInstr.indexOf(Instr) != "-1")) {
					SeachSkinInstrFlag="OnlySkin";
				}else if ((OrderSkinTest=="Y")||(OrderActionRowid!="")){
					SeachSkinInstrFlag="Remove";
				}
			}else if (GlobalObj.DisableOrdSkinChange=="1"){
				SeachSkinInstrFlag="Remove";
				if ((GlobalObj.SkinTestInstr.indexOf(Instr) != "-1")) {
					SeachSkinInstrFlag="OnlySkin";
				}
			}
			
			var ExtInfo=SeachSkinInstrFlag;
			param = $.extend(param,{instrdesc:desc,paadmtype:GlobalObj.PAAdmType,arcimrowid:ARCIMRowId,LocRowId:session['LOGON.CTLOCID'],UserID:session["LOGON.USERID"],ExtInfo:ExtInfo});
	    },onSelect:function(ind,item){
		    var DataLen=$("#"+rowid+"_OrderInstr").lookup("grid").datagrid("getRows").length;
		    //if (DataLen>1) {
			    //��ѯ���ֻ��һ����¼ʱ,���Զ�����PHCINDesc_lookuphandlerX���InstrLookUpSelect,�����ظ�����
			    var ItemArr=new Array();
			    $.each(item, function(key, val) {
					ItemArr.push(val);
				});
				InstrLookUpSelect(ItemArr.join("^"),rowid);
			//}
		},onHidePanel:function(){
			PageLogicObj.LookupPanelIsShow=0;
		},onShowPanel:function(){
			PageLogicObj.LookupPanelIsShow=1;
		},onBeforeShowPanel:function(){
			if ($(".window-mask").is(":visible")){
				//$(".messager-button a").click();
				return false;
			}
			$(this).lookup('panel').panel('resize',{width:300});
		}
    });
}
function InitOrderFreqLookup(rowid){
	$("#"+rowid+"_OrderFreq").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'Desc',
        columns:[[  
           {field:'Desc',title:'Ƶ������',width:130,sortable:false},
           {field:'Code',title:'Ƶ�α���',width:130,sortable:false}
        ]],
        pagination:true,
        panelWidth:300,
        panelHeight:300,
        isCombo:true,
        minQueryLen:0,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocOrderCommon',QueryName: 'LookUpFrequency'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
		    var OrderPriorRowid=GetCellData(rowid, "OrderPriorRowid");
		    var OrderPriorRemarks = GetCellData(rowid, "OrderPriorRemarksRowId");
		    if (OrderPriorRemarks=="ONE") {OrderPriorRowid="4"};
		    var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
			param = $.extend(param,{desc:desc,PAAdmType:GlobalObj.PAAdmType,UserID:session["LOGON.USERID"],OrderPriorRowid:OrderPriorRowid,OrderARCIMRowid:OrderARCIMRowid});
	    },onSelect:function(ind,item){
		    if (top.$(".window-mask").is(":visible")&&(!websys_showModal("options"))){
				return false;
			}
		    var ItemArr=new Array();
		    $.each(item, function(key, val) {
				ItemArr.push(val);
			});
			FrequencyLookUpSelect(ItemArr.join("^"),rowid);
		},onHidePanel:function(){
			PageLogicObj.LookupPanelIsShow=0;
		},onShowPanel:function(){
			PageLogicObj.LookupPanelIsShow=1;
		},onBeforeShowPanel:function(){
			if ($(".window-mask").is(":visible")){
				//$(".messager-button a").click();
				return false;
			}
			$(this).lookup('panel').panel('resize',{width:300});
		}
    });
}
function InitOrderDurLookup(rowid){
	$("#"+rowid+"_OrderDur").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'CTPCPDesc',
        columns:[[  
           {field:'CTPCPDesc',title:'�Ƴ�',width:130,sortable:false},
           {field:'CTPCPCode',title:'����',width:130,sortable:false}
        ]],
        width:80,
        pagination:true,
        panelWidth:300,
        panelHeight:300,
        isCombo:true,
        minQueryLen:0,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocOrderCommon',QueryName: 'LookUpDuration'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{desc:desc});
	    },onSelect:function(ind,item){
		    var ItemArr=new Array();
		    $.each(item, function(key, val) {
				ItemArr.push(val);
			});
			DurationLookUpSelect(ItemArr.join("^"),rowid);
		},onHidePanel:function(){
			PageLogicObj.LookupPanelIsShow=0;
		},onShowPanel:function(){
			PageLogicObj.LookupPanelIsShow=1;
		},onBeforeShowPanel:function(){
			if ($(".window-mask").is(":visible")){
				//$(".messager-button a").click();
				return false;
			}
			$(this).lookup('panel').panel('resize',{width:300});
		}
    });
}
function RestoreChangeRecLoc(rowid,OldRecLocRowid,RecLocStr){
    var ArrData = RecLocStr.split(String.fromCharCode(2));
    for (var i = 0; i < ArrData.length; i++) {
        var ArrData1 = ArrData[i].split(String.fromCharCode(1));
        if (ArrData1[0]==OldRecLocRowid){  //&&(ArrData1[2] != "Y")){
	        SetCellData(rowid, "OrderRecDep", OldRecLocRowid);
    		SetCellData(rowid, "OrderRecDepRowid", OldRecLocRowid);
    		break;
	    }
    }
}
// ��֤�����Ƿ�ɹ���
function CheckIsCanSetOrdMasSeqNo(MasterItemSeqNo,SubItemSeqNo,callback)
{
	var OrderARCIMRowid=GetCellData(SubItemSeqNo, "OrderARCIMRowid");
	if (OrderARCIMRowid=="") {
		$.messager.alert("��ʾ", "��ҽ�����ܹ���","info",function(){
	        if (callback) callback();
	    });
        return false;
	}
	var MasOrderName=GetCellData(MasterItemSeqNo, "OrderName");
	var SubOrderName=GetCellData(SubItemSeqNo, "OrderName");
    //��֤�Ƿ�δ���
    if ((CheckIsItem(MasterItemSeqNo) == true) || (CheckIsItem(SubItemSeqNo) == true)) {
        $.messager.alert("��ʾ", "�����ҽ�����ܹ���","info",function(){
	        if (callback) callback();
	    });
        return false;
    }
    //��֤������ҽ���Ƿ����
    var MasOrderARCIMRowid = GetCellData(MasterItemSeqNo, "OrderARCIMRowid");
    if (MasOrderARCIMRowid == "") {
	   $.messager.alert("��ʾ", "������ҽ��������!","info",function(){
	        if (callback) callback();
	    });
        return false; 
    }
    //��֤��ҽ���Ƿ����������ҽ���Ƿ��ѱ�����
    if ($.isNumeric(MasterItemSeqNo) == true) {
        var MasterSeqNo = GetCellData(MasterItemSeqNo, "OrderMasterSeqNo");
        if (MasterSeqNo == MasterItemSeqNo) {
            $.messager.alert("����", "ҽ�����ܹ�������","info",function(){
		        if (callback) callback();
		    });
            return false;
        }
        if (MasterSeqNo != "") {
            $.messager.alert("����", "ѡ����ҽ���Ѿ���������ҽ��","info",function(){
		        if (callback) callback();
		    });
            return false;
        }
    }
    //��֤����ҽ������˵���Ƿ���ȡҩҽ��
    var MasOrderPriorRemarksRowId=GetCellData(MasterItemSeqNo, "OrderPriorRemarksRowId");
    var SubOrderPriorRemarksRowId=GetCellData(SubItemSeqNo, "OrderPriorRemarksRowId");
    if ((MasOrderPriorRemarksRowId=="ONE")||(SubOrderPriorRemarksRowId=="ONE")){
        $.messager.alert("����", "ȡҩҽ�����ܹ���!","info",function(){
	        if (callback) callback();
	    });
    	return false;
    }
    //��֤��ҽ���ǳ�Ժ��ҩ,��ҽ��ҽ������
    var MainOrderPriorRowid=GetCellData(MasterItemSeqNo,"OrderPriorRowid");
    var subOrderType = GetCellData(SubItemSeqNo, "OrderType");
    if ((MainOrderPriorRowid==GlobalObj.OutOrderPriorRowid)&&(subOrderType!="R")){
        $.messager.alert("��ʾ", SubOrderName+" ��ҽ����ҩƷҽ��,���ܺͳ�Ժ��ҩҽ������!","info",function(){
	        if (callback) callback();
	    });
        return false;
    }
    //�����ҽ���Ǿ���Ƥ������ѡ�񴰿�ȷ�����÷�������Ҫ����ҽ���÷�Ϊ׼
	var MainOrdNumStr=GetMainOrdNumStrInGroup(MasterItemSeqNo,SubItemSeqNo);
	var MainOrdNumErrCode=mPiece(MainOrdNumStr, "^", 0);
    
	//����Ǿ���Ƥ������ѡ�񴰿�ȷ�����÷��������÷���ʹ��Ŀ�Ĳ���ͬ�����������
	if (MainOrdNumErrCode!="0") {
		 $.messager.alert("��ʾ", SubOrderName+" ��ҽ��Ƥ��ʹ��Ŀ������ҽ����ͬ�����������!","info",function(){
	        if (callback) callback();
	    });
        return false;
	}
    
    /*var SpelAction = GetCellData(SubItemSeqNo, "SpecialAction");
    var SpecialAction = "";
    if (SpelAction.toString().indexOf('||') != -1) SpecialAction = SpelAction.split("||")[0];
	if (SpecialAction != "isEmergency") {*/
	    //��֤��ҽ���Ƿ�ҩƷ�Ҳ���¼��Ƶ���Ƴ�,��ҽ���Ƿ���ҩƷ/����¼��Ƶ���Ƴ̵ķ�ҩƷ����
	    var MainStyleConfigStr = GetCellData(MasterItemSeqNo, "StyleConfigStr");
	    var MainStyleConfigObj = {};
	    if (MainStyleConfigStr != "") {
	        MainStyleConfigObj = eval("(" + MainStyleConfigStr + ")");
	    }
	    var MainOrderFreqRowid=GetCellData(MasterItemSeqNo, "OrderFreqRowid");
	    var subOrderPHPrescType = GetCellData(SubItemSeqNo, "OrderPHPrescType");
	    if ((subOrderPHPrescType=="4")||(subOrderType=="R")) {
	        if ((!MainStyleConfigObj.OrderFreq)&&(MainOrderFreqRowid=="")){
	            $.messager.alert("��ʾ", SubOrderName+" ��ҽ��������Ƶ�κ��Ƴ�,���ܹ���!","info",function(){
			        if (callback) callback();
			    });
	            return false;
	        }
	    }
	    var MainOrderInstrRowid=GetCellData(MasterItemSeqNo, "OrderInstrRowid");
	    //��֤��ҽ���Ƿ�ҩƷ�Ҳ���¼���÷�,��ҽ����ҩƷ/����¼���÷��ķ�ҩƷ����
	    var OrderHiddenPara = GetCellData(SubItemSeqNo, "OrderHiddenPara");
	    var SubOrderItemCatRowid = mPiece(OrderHiddenPara, String.fromCharCode(1), 2);
	    if (((("^" + GlobalObj.SelectInstrNotDrugCat + "^").indexOf("^" + SubOrderItemCatRowid + "^") >= 0))||(subOrderType=="R")) {
		    if ((!MainStyleConfigObj.OrderInstr)&&(MainOrderInstrRowid=="")){
	            $.messager.alert("��ʾ", SubOrderName+" ��ҽ������¼���÷�,���ܹ���!","info",function(){
			        if (callback) callback();
			    });
	            return false;
	        }
		}
	//}
    //��֤��ҽ���������Ƿ�ɱ༭
    if (!checkOrdMasSeqNoIsEdit(MasterItemSeqNo)){
        $.messager.alert("��ʾ", MasOrderName+" ҽ�����ܹ���!","info",function(){
	        if (callback) callback();
	    });
        return false;
    }
    //��֤��ҽ���������Ƿ�ɱ༭
    if (!checkOrdMasSeqNoIsEdit(SubItemSeqNo)){
         var OrderName=GetCellData(SubItemSeqNo, "OrderName");
        $.messager.alert("��ʾ", SubOrderName+" ҽ�����ܹ���!","info",function(){
	        if (callback) callback();
	    });
        return false;
    }
    //��֤�������������Ӧ��ҽ���Ƿ�����ҽ��,��֤�����Ƿ�����ҽ��
    var IsOtherMasOrd = 0; //�Ƿ�������ҽ������ҽ��
    var LinkMasOrdIsOtherSubOrd = 0; //����������ҽ���Ƿ�������ҽ������ҽ��
    var IsSelfLink=0;
    var CurrentOrderSeqNo = GetCellData(SubItemSeqNo, "id");
    var allrowids = GetAllRowId();
    for (var i = 0; i < allrowids.length; i++) {
        var id1 = allrowids[i];
        var ItemRowid1 = GetCellData(id1, "OrderItemRowid");
        if (ItemRowid1 != "") { continue }
        var OrderSeqNo1 = GetCellData(id1, "id");
        var MasterSeqNo1 = GetCellData(id1, "OrderMasterSeqNo");
        if (MasterSeqNo1==OrderSeqNo1){
            IsSelfLink=1;
            break;
        }
        if ((MasterItemSeqNo == OrderSeqNo1) && (MasterSeqNo1 != "")) {
            LinkMasOrdIsOtherSubOrd = 1;
            break;
        }
        if (MasterSeqNo1 == CurrentOrderSeqNo) {
            IsOtherMasOrd = 1;
            break;
        }
    }
    if (IsSelfLink==1){
        $.messager.alert("��ʾ","ҽ�����ܹ�������!","info",function(){
	        if (callback) callback();
	    });
        return false;
    }
    if (IsOtherMasOrd == 1) {
        $.messager.alert("��ʾ","��ҽ��������ҽ������ҽ��,���ܹ���!���ʵ!","info",function(){
	        if (callback) callback();
	    });
        return false;
    }
    if (LinkMasOrdIsOtherSubOrd == 1) {
        $.messager.alert("��ʾ","��ҽ����������ҽ��������ҽ������ҽ��,���ܹ���!���ʵ!","info",function(){
	        if (callback) callback();
	    });
        return false;
    }
    return true;
}
function OpenDeathTypeDiagnos(CallBackFun){
    websys_showModal({
		url:"../csp/dhcdoc.deathtypediag.csp?EpisodeID="+GlobalObj.EpisodeID,
		title:'��ѡ���������',
		width:500,height:500,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if ((result == "") || (result == "undefined")||(result == null)) {
		        $.messager.alert("��ʾ", "��ѡ���������!","info",function(){
			        CallBackFun(false);
			    });
		    } else {
		        CallBackFun(true);
		    }
		}
	})
}
///ʵϰ�����ҽ��
function InsertPriceAdd() {
    var OrderItemStr = "";
    var OrderItem = "";
    var OneOrderItem = "";
	var OrderItemCongeriesNum=0;
	var DataArry = GetGirdData();
	var Count=0; 
	for (var i = 0; i < DataArry.length; i++) {
		var OrderItemRowid = DataArry[i]["OrderItemRowid"];
		var OrderARCIMRowid = DataArry[i]["OrderARCIMRowid"];
		var OrderARCOSRowid = DataArry[i]["OrderARCOSRowid"];
		var StyleConfigStr = DataArry[i]["StyleConfigStr"];
		var StyleConfigObj = {};
		if (StyleConfigStr != "") {
			StyleConfigObj = eval("(" + StyleConfigStr + ")");
		}
		if ((GlobalObj.PAAdmType != "I") && (StyleConfigObj.OrderPackQty != true) && (OrderItemRowid != "")) { continue }
		if ((OrderARCIMRowid == "")&&(OrderARCOSRowid=="")) { continue; }
		var RowDataJson=JSON.stringify(DataArry[i]);
		if (OrderItemStr == "") { OrderItemStr = RowDataJson } else { OrderItemStr = OrderItemStr + String.fromCharCode(1) + RowDataJson }
		//����һ��¼��20-30������ʱ�����ݴ����ͻ��Ϊ����ÿ�β���10��
		if (Count>10){
			var Rtn = cspRunServerMethod(GlobalObj.InsertPrcaticeDocMethod,GlobalObj.EpisodeID,OrderItemStr,session["LOGON.USERID"]);
			OrderItemStr="";
			Count=0;
		}
		Count=Count+1;
	}
	if (OrderItemStr!=""){
		var Rtn = cspRunServerMethod(GlobalObj.InsertPrcaticeDocMethod,GlobalObj.EpisodeID,OrderItemStr,session["LOGON.USERID"])
	}
	return true;
}
//չʾʵϰ��ҳ��
function ShowPracticeOrder() {
    if (GlobalObj.EpisodeID) {
        websys_showModal({
			url:"ipdoc.practicedocpreorder.hui.csp?EpisodeID=" + GlobalObj.EpisodeID+"&PPRowId="+GlobalObj.PPRowId ,
			title:'ʵϰ��ҽ������',
			width:'95%',height:'95%',
			AddPracticeOrder:AddPracticeOrder,
			GetPreRowId:GetPreRowId,
			CheckIsClear:CheckIsClear
		});
    }
}
//���ʵϰ��ҽ��
function AddPracticeOrder(PracticePreary,RowidStr){
	var RowidStrAry=RowidStr.split("^")
	//ɾ����ǰ���һ�пհ���
    var CruRow = GetPreRowId();
    if (CheckIsClear(CruRow) == true) {
        DeleteRow(CruRow);
		CruRow=parseFloat(CruRow)-1;
    }
    function loop(i){
	    new Promise(function(resolve,rejected){
		    var ArrStr=new Array();
			ArrStr=PracticePreary[i]
			$.extend(ArrStr, { "rowid": parseFloat(CruRow)+i+1});
			AddItemDataToRow(ArrStr,ArrStr,"obj",resolve);
		}).then(function(){
			var rowid = GetPreRowId();
			var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara"); 
	        var Arr=OrderHiddenPara.split(String.fromCharCode(1));
	        Arr.splice(23,1,RowidStrAry[i]);
	        SetCellData(rowid, "OrderHiddenPara",Arr.join(String.fromCharCode(1)));
	        i++;
			if ( i < PracticePreary.length ) {
				 loop(i);
			}else{
				Add_Order_row();
			}
		})
	}
    loop(0);
}
function OrdNotesDetailOpen(ArcimRowIdStr){
	var autoHide=10000;
	if (ArcimRowIdStr==""){
		var Selrowids = GetSelRowId();
        var selRowLen=Selrowids.length
	    for (var i = 0; i <Selrowids.length; i++) {
	        //if (CheckIsItem(Selrowids[i]) == false) {
		        var OrderARCIMRowid=GetCellData(Selrowids[i], "OrderARCIMRowid");
		        if (OrderARCIMRowid=="") continue;
		        if (ArcimRowIdStr=="") ArcimRowIdStr=OrderARCIMRowid;
		        else  ArcimRowIdStr=ArcimRowIdStr+"^"+OrderARCIMRowid;
	        //}
	    }
	    if (ArcimRowIdStr=="") {
		    $.messager.alert("��ʾ","�빴ѡ��Ҫ��ѯ��ע��ҽ����Ŀ!");
	        return false;
		}
		autoHide=0;
	}
	PageLogicObj.m_selArcimRowIdStr=ArcimRowIdStr;
	var HTML=GetPannelHTML("OrdNotestDetail");
	if (HTML.innerHTML==""){return;}
	var maxHeight=ArcimRowIdStr.split("^").length*35+40;
	if (maxHeight>400){
		maxHeight=400;
	}
	$("body").append( '<a id="manualpp"></a>');
	$("#manualpp").popover({
		trigger:'manual',
		placement:'horizontal',
		title:HTML.Title,
		width:HTML.width,
		height:ArcimRowIdStr.split("^").length*35+40,
		content:HTML.innerHTML,
		autoHide:autoHide,
		closeable:true,
		animated:'fade',
		arrow:false,
		//offsetTop:$(window).height()-933,
		offsetLeft:($(window).width()-500)/2-10,
		style:'inverse-opacity',
		onShow:function(e,value){
			//if (HTML.CallFunction!="") eval(HTML.CallFunction)();
		},
		onHide:function(e,value){
			$("#manualpp").popover('destroy');
			$("body").remove("#manualpp"); 
			PageLogicObj.m_selArcimRowIdStr="";
		}
	});
	$("#manualpp").popover('show');
}
///��ȡ��̬д���HTML����
function GetPannelHTML(LinkID){
	var innerHTML="";
	var CallFunction={};
	var Title="";
	var width=200,height=150;
	if (LinkID=="OrdNotestDetail"){
		//innerHTML+='<table id="OrdNotestDetailGrid"></table>'
		innerHTML=LoadOrdNotestDetailGrid();
		width=500,height=300;
		Title="ҽ����ע�б�";
	}
	return {
		"innerHTML":innerHTML,
		//"CallFunction":CallFunction,
		"Title":Title,
		"width":width,
		"height":height
	}
}
function LoadOrdNotestDetailGrid(){
	var Columns=[[    
        {title:'ҽ��������',field:'ArcimDesc',width:200},
        {title:'��ע',field:'OrderMsg',width:250}
    ]];
    var GridData=$.cm({
	    ClassName:"web.DHCDocOrderEntry",
	    QueryName:"GetArcimNotesList",
	    ArcimRowIdStr:PageLogicObj.m_selArcimRowIdStr,
	    rows:99999
	},false);
	var innerHTML='<table id="HisAdmGrid" class="norm-table">';
	innerHTML=innerHTML+'<thead><tr><th class="td-norm">ҽ��������</th><th class="td-norm">��ע</th></tr></thead>';
	innerHTML=innerHTML+'<tbody>';
	for (var i=0;i<GridData['rows'].length;i++){
		innerHTML=innerHTML+'<tr><td class="td-norm">'+GridData['rows'][i]['ArcimDesc']+'</td><td class="td-norm">'+GridData['rows'][i]['OrderMsg']+'</td></tr>';
	}
	innerHTML=innerHTML+'</tbody></table>';
	return innerHTML;
}
///���д����������Ϣ�Ĺ���
function OpenSelectDia(EpisodeID,OEOrdItemIDs){
  var precnum=tkMakeServerCall("web.DHCDocDiagLinkToPrse","getAllCheckDiaPrce",EpisodeID,session['LOGON.USERID'],OEOrdItemIDs) 
  if (precnum!=""){
	  //���������Ϊ1,��ֱ�ӽ�������봦������
	  var GridData=$.cm({
			ClassName:"web.DHCDocDiagLinkToPrse",
			QueryName:"GetDiaQuery",
			Adm:EpisodeID,
			Type:"ALL",
			rows:99999
	  },false);
	  var total=GridData['total'];
	  if (total==1){
		  var rtn=$.cm({
				ClassName:"web.DHCDocDiagLinkToPrse",
				MethodName:"Insert",
				dataType:"text",
				PrescNoStr:precnum,
				DiagIdStr:GridData['rows'][0]['diaid'],
				UserDr:session['LOGON.USERID'],
		   },false);
	  }else{
		  if (total==0) return;
		  var url="dhcdocdiagnoseselect.hui.csp?EpisodeID="+EpisodeID+"&PrescNoStr="+precnum; //+"&ExitFlag="+"Y"
		  var winName="SelectDia"; 
		  var awidth=screen.availWidth/6*5; 
		  var aheight=screen.availHeight/5*4; 
		  var atop=(screen.availHeight - aheight)/2;
		  var aleft=(screen.availWidth - awidth)/2;
		  websys_showModal({
			url:url,
			title:'�����������',
			width:awidth,height:aheight
		})
	  }
   }
}
function ShowFreqQty(FreqDispTimeStr,OrderName,FreqDispTimeDoseQtyStr,OrderDoseUOM,callBackFun) {
	if (FreqDispTimeDoseQtyStr!=""){
		FreqDispTimeDoseQtyStr=FreqDispTimeDoseQtyStr.replace("/||/g","_");	
	}
	var lnk = "dhcdocshowfreq.csp?FreqDispTimeStr=" + FreqDispTimeStr+"&FreqDispTimeDoseQtyStr="+FreqDispTimeDoseQtyStr+"&OrderDoseUOM="+OrderDoseUOM;
	websys_showModal({
		url:lnk,
		title:OrderName+' ������д',
		width:400,height:300,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if (typeof result=="undefined"){
				result="";
			}
			callBackFun(result);
		}
	})
 }
 function ChangeOrderFreqTimeDoseStr(rowid,callBackFun){
	var OrderInstrRowid = GetCellData(rowid, "OrderInstrRowid");
	if (IsWYInstr(OrderInstrRowid)) {
		SetCellData(rowid, "OrderFreqTimeDoseStr","");
		var StyleConfigObj={};
		$.extend(StyleConfigObj, { OrderDoseQty: true});
		ChangeRowStyle(rowid, StyleConfigObj);
		if (callBackFun) callBackFun();
		return;
	}
	var OrderFreqRowid=GetCellData(rowid, "OrderFreqRowid");
	var OrderHiddenPara=GetCellData(rowid, "OrderHiddenPara");
	var OrderFreqDispTimeStr=GetCellData(rowid, "OrderFreqDispTimeStr");
    var SameFreqDifferentDosesFlag=OrderHiddenPara.split(String.fromCharCode(1))[19];
    if (SameFreqDifferentDosesFlag=="Y"){
	    var FreqDispTimeDoseQtyStr=GetCellData(rowid, "OrderFreqTimeDoseStr");
	    var FreqDispTimeStr=$.m({
		    ClassName:"web.DHCOEOrdItemView",
		    MethodName:"GetFreqFreqDispTimeStr",
		    OrderFreqRowid:OrderFreqRowid,
		    OrderFreqDispTimeStr:OrderFreqDispTimeStr,
		    type:"text"
		},false);
		//if ((FreqDispTimeStr=="")||((FreqDispTimeDoseQtyStr=="")&&(FreqDispTimeStr.split("!").length==1))) {
		if (FreqDispTimeStr.split("!").length==1) {
			SetCellData(rowid, "OrderFreqTimeDoseStr","");
			var OrderDoseQty=GetCellData(rowid, "OrderDoseQty");
			if (OrderDoseQty!="") {
				SetCellData(rowid, "OrderDoseQty",OrderDoseQty.split("-")[0]);
			}
			var StyleConfigObj={};
			$.extend(StyleConfigObj, { OrderDoseQty: true});
			ChangeRowStyle(rowid, StyleConfigObj);
			if (callBackFun) callBackFun();
			return;
		}
		var OrderARCIMRowid=GetCellData(rowid, "OrderARCIMRowid");
		var OrderName=GetCellData(rowid, "OrderName");
		var OrderDoseUOM=GetCellData(rowid, "OrderDoseUOM");
		new Promise(function(resolve,rejected){
		    ShowFreqQty(FreqDispTimeStr,OrderName,FreqDispTimeDoseQtyStr,OrderDoseUOM,resolve);
		}).then(function(OrderFreqTimeDoseStr){
			if (OrderFreqTimeDoseStr!=""){
			    SetCellData(rowid, "OrderFreqTimeDoseStr",OrderFreqTimeDoseStr);
			    var DoseQtyStr=GetDoseQty(OrderFreqTimeDoseStr);
			    SetCellData(rowid, "OrderDoseQty",DoseQtyStr);
			    var StyleConfigObj={};
			    //$.extend(StyleConfigObj, { OrderDoseQty: false});
			    $.extend(StyleConfigObj, { OrderDoseQty: "readonly"});
			    ChangeRowStyle(rowid, StyleConfigObj);
			}else{
				SetCellData(rowid, "OrderFreqTimeDoseStr","");
				SetCellData(rowid, "OrderDoseQty","");
				var OrderName=GetCellData(rowid, "OrderName");
				$.messager.alert("��ʾ"," ͬƵ�β�ͬ����ҽ������ذ��շַ�ʱ����д����!","info",function(){
					var StyleConfigObj={};
				    $.extend(StyleConfigObj, { OrderDoseQty: true});
				    ChangeRowStyle(rowid, StyleConfigObj);
				})
			}
			if (callBackFun) callBackFun();
		})
	}else{
		if (callBackFun) callBackFun();
	}
}
function GetDoseQty(OrderFreqTimeDoseStr){
	var DoseQtyStr="";
	if (OrderFreqTimeDoseStr=="") return "";
	for (var i=0;i<OrderFreqTimeDoseStr.split("!").length;i++){
		var DoseQty=OrderFreqTimeDoseStr.split("!")[i].split("$")[1];
		if (DoseQtyStr=="") DoseQtyStr=DoseQty;
		else  DoseQtyStr=DoseQtyStr+"-"+DoseQty;
	}
	return DoseQtyStr;
}
function DocCure_Click(){
    DHCDocCure_Service.DocCureTreeShow();
}

function CureApplyReport(OrderItemStr,CureNeedMatchAry,callBackFun) {
	DHCDocCure_Service.CureApplyReport(OrderItemStr,CureNeedMatchAry,callBackFun)
}

function changeBigBtnClick(e){
	var _$ChgBtnText=$("#changeBigBtn .l-btn-text")[0];
	var text=_$ChgBtnText.innerText;
	var layout = $("#layout_main");
	var center = layout.layout('panel', 'center');
	if (GlobalObj.layoutConfig == 2) { //סԺ ҽ�������� ����
		var north=layout.layout('panel', 'north');
		if (text==$g("�Ŵ�")){
			_$ChgBtnText.innerText=$g("��С");
			north.panel('minimize');
			center.panel('maximize').panel("resize",{top:5});			
		}else{
			_$ChgBtnText.innerText=$g("�Ŵ�");
			north.panel('restore').panel("open");
			center.panel('restore');
		}
	}else{
		var south=layout.layout('panel', 'south');
		if (text==$g("�Ŵ�")){
			_$ChgBtnText.innerText=$g("��С");
			south.panel('minimize');
			center.panel('maximize');
		}else{
			_$ChgBtnText.innerText=$g("�Ŵ�");
			south.panel('restore').panel("open");
			center.panel('restore');
		}
	}
	ResizeGridWidthHeiht("resize");
	$('#layout_main').layout('resize');
}
function GetLinkMasterNoForArcos(row, Arcosrowid) {
	var OrderSeqNo =GetCellData(row, "id");
	var OrderMasterSeqNo = GetCellData(row, "OrderMasterSeqNo");
	var ArcosMaxLinkSeqNo=tkMakeServerCall("web.DHCARCOrdSets", "GetArcosMaxLinkSeqNo", Arcosrowid) //��ȡ���ظ���LinkNo
	if (ArcosMaxLinkSeqNo<0) {
		ArcosMaxLinkSeqNo=1
	}else {
		ArcosMaxLinkSeqNo++
	}
	if(OrderMasterSeqNo=="") {
		//���������ҽ����ֵ,�������򲻸�ֵ
		var SubRowidsAry = GetMasterSeqNo(row);
		if (SubRowidsAry.length > 0) {
			if (OrderMasterSeqNoArr[OrderSeqNo]) {
				OrderMasterSeqNo = OrderMasterSeqNoArr[OrderSeqNo];
			} else {
				OrderMasterSeqNo =ArcosMaxLinkSeqNo;
				OrderMasterSeqNoArr[OrderSeqNo]=ArcosMaxLinkSeqNo
			}
		}
	}else {
		if (OrderMasterSeqNoArr[OrderMasterSeqNo]) {
			var OrderMasterSeqNo=GetSubSeqNoForArcos(OrderMasterSeqNoArr[OrderMasterSeqNo])
		}else {
			OrderMasterSeqNoArr[OrderMasterSeqNo]=ArcosMaxLinkSeqNo
			var OrderMasterSeqNo=GetSubSeqNoForArcos(OrderMasterSeqNoArr[OrderMasterSeqNo])
		}
	}
	return OrderMasterSeqNo
}
function GetSubSeqNoForArcos(OrderMasterSeqNo){
	var StSubSeqNo=1
	var SubSeqNo=OrderMasterSeqNo+"."+StSubSeqNo
	if(OrderSubSeqNoArr[SubSeqNo]) {
		while (OrderSubSeqNoArr[SubSeqNo]) {
			StSubSeqNo=StSubSeqNo+1
			SubSeqNo=OrderMasterSeqNo+"."+StSubSeqNo
		}
	}
	OrderSubSeqNoArr[SubSeqNo]=SubSeqNo
	return SubSeqNo
}
function OrdDoseQtyBindClick(rowid){
	//�Ƚ���󶨷�ʽclick��ֹ�ظ���
	$("#"+rowid+"_OrderDoseQty").unbind('click');
	$("#"+rowid+"_OrderDoseQty").click(function(){
		new Promise(function(resolve,rejected){
			ChangeOrderFreqTimeDoseStr(rowid,resolve);
		}).then(function(){
			SetPackQty(rowid,{
				IsNotChangeFirstDayTimeFlag:"Y"
			});
		})
	});
}
 // �ײ�¼�밴ť����¼�
function PkgOrdEntry_Click() {
	var arcimId = "";
	if (!CheckPatPkg(arcimId)) {
		$.messager.alert('��ʾ', '����û�й����ײ�', 'info');
		return false;
	}
	return PkgOrdEntry(arcimId);
}
/**
 * �ײ�ҽ��¼��
 * @method PkgOrdEntry
 * @param {String} ͨ��"�ײ�¼��"��ť¼ʱ������Ҫ������; ����ҽ��ʱ����Ҫ��ҽ����ID
 * PkgOrdEntry("111||2")
 */
function PkgOrdEntry(arcimId) {
	var hospitalId = session['LOGON.HOSPID'];
	var episodeId = GlobalObj.EpisodeID;
	var patientId = GlobalObj.PatientID;
	var lnk = 'dhcbill.pkg.patpkg.csp?PatientID=' + patientId + '&ARCIMID=' + arcimId;
	websys_showModal({
		url:URL,
		title:'�ײ�ѡ��',
		width:900,height:550,
		CallBackFunc:function(rtnValue){
			AddCopyItemToList(rtnValue.split(','));
		}
	})
}

/**
 * �ж��Ƿ��й����ײ�
 * @method CheckPatPkg
 * @param {String} ҽ����ID
 * CheckPatPkg("111||2")
 */
function CheckPatPkg(arcimId) {
	var hospitalId = session['LOGON.HOSPID'];
	var episodeId = GlobalObj.EpisodeID;
	if (!episodeId) {
    	return false;
    }
	var pkgList = $.m({
		ClassName: 'BILL.PKG.BL.PkgPackage',
		MethodName: 'IsDeductPkg',
		episodeId: episodeId,
		arcimId: arcimId,
		useDate: "",
		hospitalId: hospitalId
	}, false);
	var myAry = pkgList.split('^');
	if (myAry[0] == '0') {
		return false;
	}
	return true;
}
function GetPromptHtml(){
	if (GlobalObj.PPRowId=="") {
		ReSetPilotDefaultData();
	}else{
		//�ж�ҩ�����Ƿ�����
		var PPPatStatus=tkMakeServerCall("web.PilotProject.DHCDocPilotProject","isNormalStatus",GlobalObj.PatientID,GlobalObj.PPRowId)
		if (PPPatStatus!="N"){
			GlobalObj.PPRowId="";
			ReSetPilotDefaultData();
		}else{
			GlobalObj.PilotProWarning=tkMakeServerCall("web.PilotProject.DHCDocPilotProject","ifWarning",GlobalObj.PPRowId,session['LOGON.USERID']);
		}
	}
	var warning="";
	if (GlobalObj.warning != ""){
		warning=GlobalObj.warning;
	}
	if ((GlobalObj.AnaesthesiaID!="")&&(GlobalObj.AnaesthesiaID.split("||")[0]!=GlobalObj.EpisodeID)){
		var AnaesthesiaErrMsg="�����б��Ӧ���߾���ID�ͱ�ҳ�����ID��ͬ,��ͨ�������б�����ѡ��!"
		if (warning!=""){
			warning=warning+";"+AnaesthesiaErrMsg;
		}else{
			warning=AnaesthesiaErrMsg;
		}
	}
	if (GlobalObj.IPNecessaryCatMsg!=""){
		if (warning!=""){
			warning=warning+";"+GlobalObj.IPNecessaryCatMsg;
		}else{
			warning=GlobalObj.IPNecessaryCatMsg;
		}
	}
	if (GlobalObj.PilotProWarning!=""){
		if (warning!=""){
			warning=warning+";"+GlobalObj.PilotProWarning;
		}else{
			warning=GlobalObj.PilotProWarning;
		}
	}
	if (GlobalObj.LogonDoctorID==""){
		if (warning!=""){
			warning=warning+";";
		}
		warning=warning+"���û�δ������Ч��ҽ����Ա,���������";
		GlobalObj.EnableButton=0;
	}
	return warning;
}
function OrderDocchangehandler(e){
    var rowid = GetEventRow(e);
    var obj = websys_getSrcElement(e);
    if (obj.id.indexOf("_") > 0) {
        rowid = obj.id.split("_")[0];
    }
    SetCellData(rowid, "OrderDocRowid", obj.value);
    SetCellData(rowid, "OrderDoc", obj.value);
    ChangeLinkOrderDoc(rowid);
}
function ChangeLinkOrderDoc(OrderSeqNo) {
	var OrderDocRowid=GetCellData(OrderSeqNo, "OrderDocRowid");
	var OrderDoc=GetCellData(OrderSeqNo, "OrderDoc");
    try {
        var rows = $('#Order_DataGrid').getDataIDs();
        for (var i = 0; i < rows.length; i++) {
            var rowid = rows[i];
            var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
            var OrderItemRowid = GetCellData(rowid, "OrderItemRowid");
            var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
            var OrderType = GetCellData(rowid, "OrderType");
            if ((OrderMasterSeqNo != OrderSeqNo) || (OrderARCIMRowid == "") || (OrderItemRowid != "")) { continue; }
            var EditStatus = GetEditStatus(rowid);
            if (EditStatus) {
	            SetCellData(rowid, "OrderDoc", OrderDocRowid);
	        }else{
		        SetCellData(rowid, "OrderDoc", OrderDoc);
		    }
            SetCellData(rowid, "OrderDocRowid", OrderDocRowid);
        }
    } catch (e) { $.messager.alert("����", e.message) }
}

///���ⳤ�ڹ�ѡ����¼�
function OrderVirtualtLongClickhandler(e){
	var rowid = GetEventRow(e);
	var OrderVirtualtLong=GetCellData(rowid, "OrderVirtualtLong");
	//if (OrderVirtualtLong==false){SetOrderItemPrior(Row,OMLSZTOrderPriorRowid);}else{SetOrderItemPrior(Row,ShortOrderPriorRowid);}
	ChangeLinkOrderVirtualtLong(rowid,OrderVirtualtLong);
}
///���ⳤ��ҽ���޸Ĺ����¼�
function ChangeLinkOrderVirtualtLong(Row){
	try {
		if (GlobalObj.UserEMVirtualtLong!="1"){
			return true;
		}
		var OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
		if (IsLongPrior(OrderPriorRowid)){
			return true;
		}
		var OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
		var OrderPriorRemarks = GetCellData(Row, "OrderPriorRemarksRowId");
		var OldPriorRowid = ReSetOrderPriorRowid(OrderPriorRowid, OrderPriorRemarks);
		var OrderType = GetCellData(Row, "OrderType");
		var OrderVirtualtLong=GetCellData(Row, "OrderVirtualtLong");
		if (OrderVirtualtLong == "Y") {
		    SetCellData(Row, "OrderDur", GlobalObj.IPDefaultDur);
			SetCellData(Row, "OrderDurRowid", GlobalObj.IPDefaultDurRowId);
			SetCellData(Row, "OrderDurFactor", GlobalObj.IPDefaultDurFactor);
	    }
		if (OrderVirtualtLong == "Y") {
	        OrderVirtualtLong = true;
	    } else {
	        OrderVirtualtLong = false;
	    }
		var OrderHiddenPara=GetCellData(Row,"OrderHiddenPara");
		//�ɲ�ַ�ҩ�Ľ��ܿ��Ҵ�
    	var NormSplitPackQtyPHRecLocList = mPiece(OrderHiddenPara, String.fromCharCode(1), 24);
    	var OrderRecDepRowid = GetCellData(Row, "OrderRecDepRowid");
    	var NormSplitPackQty=0;
    	if ((NormSplitPackQtyPHRecLocList!="")&&(("!"+NormSplitPackQtyPHRecLocList+"!").indexOf("!"+OrderRecDepRowid+"!")!=-1)){
	    	NormSplitPackQty=1;
	    }
    	
		var RowStyleObj = {};
	    if (OrderVirtualtLong){
			$.extend(RowStyleObj, { OrderDur: false});
		}else{
			$.extend(RowStyleObj, { OrderDur: true});
		}
		if ((NormSplitPackQty=="0")&&(OrderType=="R")){
			if (OrderVirtualtLong){
				OrderPriorRemarkschangeCommon(Row,"","ZT");
			}else{
				if (OrderPriorRemarks=="ZT"){
					OrderPriorRemarkschangeCommon(Row,"ZT","");
				}
			}
		}
		var OrderPackQtyStyleObj = ContrlOrderPackQty(Row);
    	$.extend(RowStyleObj, OrderPackQtyStyleObj);
	    ChangeRowStyle(Row, RowStyleObj);
	    ChangeCellDisable(Row, RowStyleObj);
		SetOrderUsableDays(Row);
		//������Һ����
    	SetOrderLocalInfusionQty(Row);
        var RowArry = GetSeqNolist(Row)
        for (var i = 0; i < RowArry.length; i++) {
	        var EditStatus = GetEditStatus(RowArry[i]);
			if (EditStatus){
				var OrderVirtualtLongValue=OrderVirtualtLong;
			}else{
				var OrderVirtualtLongValue=OrderVirtualtLong?"Y":"N";
			}
	        var SubRowStyleObj={};
            SetCellData(RowArry[i], "OrderVirtualtLong", OrderVirtualtLongValue);
            if (OrderVirtualtLong) {
				SetCellData(RowArry[i], "OrderDur", GlobalObj.IPDefaultDur);
				SetCellData(RowArry[i], "OrderDurRowid", GlobalObj.IPDefaultDurRowId);
				SetCellData(RowArry[i], "OrderDurFactor", GlobalObj.IPDefaultDurFactor);
			}
			var SubPriorRowid = GetCellData(RowArry[i], "OrderPriorRowid");
			var SubPriorRemarks = GetCellData(RowArry[i], "OrderPriorRemarksRowId");
			var OldPriorRowid = ReSetOrderPriorRowid(SubPriorRowid, SubPriorRemarks);
			var OrderType = GetCellData(RowArry[i], "OrderType");
			var SubHiddenPara=GetCellData(RowArry[i],"OrderHiddenPara");
	    	var SubItemCatRowid = mPiece(SubHiddenPara, String.fromCharCode(1), 2);
	    	var SubRecDepRowid = GetCellData(RowArry[i], "OrderRecDepRowid");
			//�ɲ�ַ�ҩ�Ľ��ܿ��Ҵ�
	    	var NormSplitPackQtyPHRecLocList = mPiece(SubHiddenPara, String.fromCharCode(1), 24);
	    	var NormSplitPackQty=0;
	    	if ((NormSplitPackQtyPHRecLocList!="")&&(("!"+NormSplitPackQtyPHRecLocList+"!").indexOf("!"+SubRecDepRowid+"!")!=-1)){
		    	NormSplitPackQty=1;
		    }
			if ((NormSplitPackQty=="0")&&(OrderType=="R")){
				if (OrderVirtualtLong){
					OrderPriorRemarkschangeCommon(RowArry[i],"","ZT");
				}else{
					if (SubPriorRemarks=="ZT"){
						OrderPriorRemarkschangeCommon(RowArry[i],"ZT","");
					}
				}
			}
			var OrderMasterSeqNo=GetCellData(RowArry[i], "OrderMasterSeqNo");
			var RowStyleObj = {};
			if (OrderVirtualtLong){
				$.extend(RowStyleObj, { OrderDur: false});
			}else{
				if(OrderMasterSeqNo == "") {
					$.extend(RowStyleObj, { OrderDur: true});
				}else{
					$.extend(RowStyleObj, { OrderDur: false});
				}
			}
			var OrderPackQtyStyleObj = ContrlOrderPackQty(RowArry[i]);
			$.extend(RowStyleObj, OrderPackQtyStyleObj);
    		ChangeCellDisable(RowArry[i], RowStyleObj);
			SetOrderUsableDays(RowArry[i]);
			//������Һ����
    		SetOrderLocalInfusionQty(RowArry[i]);
        }
    } catch (e) { alert( e.message) }
}

function InitChronicDiagLookUp(){
	if ($("#ChronicDiag").length==0){return}
	$("#ChronicDiag").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'Code',
        textField:'Desc',
        columns:[[  
       		{field:'Desc',title:'����',width:130,sortable:false}
        	,{field:'Code',title:'����',hidden:false}
        	,{field:'Type',title:'����',width:80,sortable:false}
        ]],
        width:95,
        pagination:true,
        panelWidth:300,
        panelHeight:300,
        isCombo:true,
        minQueryLen:0,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocQryOEOrder',QueryName: 'LookUpChronicDiag'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{desc:desc,EpisodeID:GlobalObj.EpisodeID});
	    },onSelect:function(ind,item){
		},onHidePanel:function(){
			PageLogicObj.LookupPanelIsShow=0;
		},onShowPanel:function(){
			PageLogicObj.LookupPanelIsShow=1;
		},onBeforeShowPanel:function(){
			$(this).lookup('panel').panel('resize',{width:300});
		}
	});
	$("#ChronicDiag").keyup(function(){
		if ($(this).val()==""){
			$(this).lookup("setValue","").lookup("setText","");
		}
	});
}
function GetChronicDiagCode(){
	var ChronicDiagCode="";
	if ($("#ChronicDiag").length>0){
		if ($("#ChronicDiag").lookup("getText")!=""){
			ChronicDiagCode=$("#ChronicDiag").lookup("getValue")
		}
	}
	if (typeof ChronicDiagCode=="undefined"){
		ChronicDiagCode="";
	}
	return ChronicDiagCode;
}
function InitOrderTemp(ObjectType){
	if (typeof ObjectType =="undefined"){ObjectType="User.SSUser";}
	$.cm({
        ClassName:'DHCDoc.DocCom.Preferences',
        MethodName:'GetAllPref',
        EpisodeID:GlobalObj.EpisodeID,
        XCONTEXT:XCONTEXT, LocID:session['LOGON.CTLOCID'],UserID:session['LOGON.USERID']
    },function(data){
	    if (data["User.SSUser"].length==0) ObjectType="User.CTLoc";
        var BtnObj=new Object();
        BtnObj['Personal_Template_Btn']="User.SSUser";
        BtnObj['Departments_Template_Btn']="User.CTLoc";
        BtnObj['Hospital_Template_Btn']="User.CTHospital";  //Ԥ��ȫԺģ��
        var Selector="";
        for(var key in BtnObj){
            if(Selector=="") Selector='#'+key;
            else Selector=Selector+',#'+key;
        }
        $(Selector).click(function(){
            var id=$(this).attr('id');
            var Type=BtnObj[id];
            $(this).addClass("seltemplate_btn");
            $.each(BtnObj,function(key,value){
                if(key!=id) $('#'+key).removeClass('seltemplate_btn');
            });
            for(var i=($('#Template_tabs').tabs('tabs').length);i>0;i--) $('#Template_tabs').tabs('close',i-1);
            var tabData=data[Type];
            for(var i=0;i<tabData.length;i++){
                $('#Template_tabs').tabs('add',{
                    title:tabData[i].name,
                    selected:i==0,
                });
                var tab=$('#Template_tabs').tabs('getTab',i);
                var panels=tabData[i].panels;
                for(var j=0;j<panels.length;j++){
	                (function(j){
	                    var index=j+'Z'+i;
	                    var id="ngroup"+index;
	                    tab.append("<div class='template_div'><div data-options='fit:true' class='hisui-panel' title='"+panels[j].name+"' id='"+id+"'></div></div>");
	                    $('#'+id).panel({
	                        tools:[
	                            {iconCls:'icon-add', handler:function(){PrefEditItem('addZ'+index+'Z'+Type);}},
	                            {iconCls:'icon-remove',handler:function(){ PrefEditItem('removeZ'+index+'Z'+Type);}},
	                            {iconCls:'icon-edit',handler:function(){PrefEditItem('editZ'+index+'Z'+Type);}}
	                        ]
	                    });
	                    var items=panels[j].items;
	                    for(var k=0;k<items.length;k++){
	                        PrefAddItemCustom(i,j,items[k].value,items[k].text,'',items[k].stock);
	                    }
	                    PrefAddItemCustomAppend(i,j);
	                 })(j)
                }
            }
            $.parser.parse('#Template_tabs');
        });
        if (ObjectType=="User.SSUser") {
        	$('#Personal_Template_Btn').click();
        }else{
	        $('#Departments_Template_Btn').click();
	    }
    });
}
//////
function InitOrdTemplTree(){
	InitTree();
	$("#OrdTempTypeKW").keywords({
	    singleSelect:true,
	    items:[
		        {text:'����',id:'SSUser',selected:false},
		        {text:'����',id:'CTLoc',selected:false}
		    ],
	    onClick:function(v){
		    LoadTemplNameTab();
		}
	});
    //ģ�����л�
    $('#templName_tabs').tabs({    
	    onSelect:function(title,index){
		    templNameTabSelect(index);
	    }    
    }); 
    LoadOrdTemplTree();
    $("#TemplateDetail").dialog('expand');
}
function InitTree(){
	var tbox=$HUI.tree("#OrdTemplTree",{
		checkbox:true,
		cascadeCheck:false,
		//onlyLeafCheck:true,
		onDblClick:function(node){
			var value=node.value.replace(/\^/g,String.fromCharCode(4));
			if ((value=="")||(value==undefined)) return false;
			addSelectedFav(value,node.text);
		},
		formatter:function(node){
			if (node.eleid=="") return node.text;
			else {
				if (+node.RealStock=="0"){
					return '<span style="color:red">'+node.text+'</span>';
				}else{
					return node.text;
				}
			}
		},
		onClick: function(node){
			var isLeaf=$(this).tree('isLeaf',node.target)
			if (!isLeaf){
				$(this).tree('toggle',node.target)
			}else{
				var curId=$(this).tree('getNode',node.target).id;
				var isChecked=false;
				var nodes = $(this).tree('getChecked');
				for (var i=0;i<nodes.length;i++){
					if (nodes[i]['id']==curId){
						$(this).tree('uncheck',node.target);
						isChecked=true;
						break;
					}
				}
				if (!isChecked){
					$(this).tree('check',node.target);
				}else{
					var parentNode=$(this).tree('getParent',node.target);
					//$(this).tree('uncheck',parentNode.target);
					if (!$($(parentNode.target).children()[2]).hasClass("tree-checkbox1")) return;
					var isLeafCheck=false;
					for (var i=0;i<childList.length;i++){
						var curNode=childList[i];
						var eleid=curNode.value;
		    			if (eleid !="") {
			    			var type=eleid.split(String.fromCharCode(4))[0];
			    			if (type=="ARCIM"){
			    				if ($($(curNode.target).children()[3]).hasClass("tree-checkbox1")) {
				    				isLeafCheck=true;
				    				break;
				    			}
			    			}
		    			}
					}
					if (!isLeafCheck)$(this).tree('uncheck',parentNode.target);
				}
			}
		},
		onBeforeCheck:function(node, checked){
			var isLeaf=$(this).tree('isLeaf',node.target);
			if (isLeaf){
				var eleid=node.value;
				if ((typeof eleid=="undefined")||(eleid=="")) return false;
				var type=eleid.split(String.fromCharCode(4))[0];
				if (type=="ARCIM"){
					$(this).tree('select',node.target);
				}else{
					return false;
				}
			}else{
				return true;
			}
		},
		onCheck:function(node, checked){
			var isLeaf=$(this).tree('isLeaf',node.target);
			if (!isLeaf){
				var childList = $(this).tree('getChildren',node.target);
				var checkedTrue = function(){
	    			childList.map(function(curNode){
		    			var eleid=curNode.value;
		    			if (eleid !="") {
			    			var type=eleid.split(String.fromCharCode(4))[0];
			    			if (type=="ARCIM"){
			    				$("#OrdTemplTree").tree('check', curNode.target);
			    			}
		    			}
	    			})
	    		};
				var checkedFalse = function(){
	    			$.each(childList,function(index,curNode){
		    			var eleid=curNode.value;
		    			if (eleid !="") {
			    			var type=eleid.split(String.fromCharCode(4))[0];
			    			if (type=="ARCIM"){	
						    	$("#OrdTemplTree").tree('uncheck', curNode.target);
						    }
					    }
	    			})
				};
				var checkChangeProperties = checked==true ? checkedTrue() : checkedFalse();
			}else{
				var parentNode=$(this).tree('getParent',node.target);
				var childList = $(this).tree('getChildren',parentNode.target);
				if (checked) {
					if ($($(parentNode.target).children()[2]).hasClass("tree-checkbox1")) return;
					var isLeafUnCheck=false;
					for (var i=0;i<childList.length;i++){
						var curNode=childList[i];
						var eleid=curNode.value;
		    			if (eleid !="") {
			    			var type=eleid.split(String.fromCharCode(4))[0];
			    			if (type=="ARCIM"){
			    				if (!$($(curNode.target).children()[3]).hasClass("tree-checkbox1")) {
				    				isLeafUnCheck=true;
				    				break;
				    			}
			    			}
		    			}
					}
					if (!isLeafUnCheck) $(this).tree('check',parentNode.target);
				}else{
					if (!$($(parentNode.target).children()[2]).hasClass("tree-checkbox1")) return;
					var isLeafCheck=false;
					for (var i=0;i<childList.length;i++){
						var curNode=childList[i];
						var eleid=curNode.value;
		    			if (eleid !="") {
			    			var type=eleid.split(String.fromCharCode(4))[0];
			    			if (type=="ARCIM"){
			    				if ($($(curNode.target).children()[3]).hasClass("tree-checkbox1")) {
				    				isLeafCheck=true;
				    				break;
				    			}
			    			}
		    			}
					}
					if (!isLeafCheck)$(this).tree('uncheck',parentNode.target);
				}
			}
		}
	});
}
function LoadOrdTemplTree(){
	$.cm({
	    ClassName:"DHCDoc.OPDoc.OrderTemplateCommmon",
	    MethodName:"GetOEPrefTabsTreesJson",
		EpisodeID:GlobalObj.EpisodeID,
		XCONTEXT:GlobalObj.XCONTEXT,
		LocID:session['LOGON.CTLOCID'], 
	    UserID:session['LOGON.USERID']
	},function(jsonData){
		treeData=jsonData;
		var kwSelId="SSUser";
		if (jsonData["User.SSUser"].length==0) kwSelId="CTLoc";
		$("#OrdTempTypeKW").keywords("select",kwSelId);
		LoadTemplNameTab();
	})
}
function LoadTemplNameTab(){
	$("#BMore,#templName_tabs").show();
	ClearTree();
	ClearNameTabs();
	var kwsel=$("#OrdTempTypeKW").keywords('getSelected');
	var ObjectType="User."+kwsel[0].id;
	var treeShowData=treeData[ObjectType];
	var LasTabNameIndex=-1,showMoreBtnFlag=0;
	var _$scroller=$("#templName_tabs .tabs-scroller-left");
	for (var i=0;i<treeShowData.length;i++){
		var id=treeShowData[i]["id"];
		var name=treeShowData[i]["text"];
		var pId=treeShowData[i]["pId"];
		if (pId==0){
			if ((_$scroller.is(':hidden'))&&(showMoreBtnFlag==0)){
				$('#templName_tabs').tabs('add',{
					title: name,
					index: id,
					selected: i==0
				});
				LasTabNameIndex=LasTabNameIndex+1;
				if (!_$scroller.is(':hidden')){
					AddMoreMenu();
				}
			}else{
				AddMoreMenu();
			}
		}
	}
	if (showMoreBtnFlag==0){
		$("#BMore").hide();
	}
	function AddMoreMenu(){
		showMoreBtnFlag=1;
		if (LasTabNameIndex>-1){
			var closeTab=$('#templName_tabs').tabs('getTab',LasTabNameIndex);
			var closeTabTitle=closeTab.panel("options").title;
			var closeTabid=closeTab.panel("options").index;
			$("#mmedit").menu('appendItem', {
				id:closeTabid,
				text: closeTabTitle
			});
			$('#templName_tabs').tabs('close',LasTabNameIndex);
			LasTabNameIndex=-1;
		}else{
			$("#mmedit").menu('appendItem', {
				id:id,
				text: name
			});
		}
	}
}
function templNameTabSelect(index){
	var kwsel=$("#OrdTempTypeKW").keywords('getSelected');
	var ObjectType="User."+kwsel[0].id;
	var data=treeData[ObjectType][index]["children"];
	var treeDataArr=new Array();
	var OpenFlag=0;
	for (var i=0;i<data.length;i++){
		var id=data[i]["id"];
		var name=data[i]["text"];
		var children=data[i]["children"];
		//var state=(i==0)?"open":"closed";  
		var state="closed"; 
		if ((children.length>0)&&(OpenFlag==0)){
			state="open";
			OpenFlag=1;
		}
		treeDataArr.push({"id":id,"text":name,"state":state,"children":children});
	}
	$("#OrdTemplTree").tree("loadData",treeDataArr)
}

function ShowGuideAllergy(ArcimRowid,OrderName,callBackFun){
	var lnk = "oeorder.guideallergy.csp?EpisodeID="+GlobalObj.EpisodeID+"&ArcimRowId="+ArcimRowid+"&GuideAllergyType=Guide";
	websys_showModal({
		url:lnk,
		title:OrderName+' Ƥ��ҽ������',
		width:800,height:560,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if (typeof result=="undefined"){
				result="Exit";
			}
			callBackFun(result);
		}
	})
}
function ShowAppendAllergyOrder(ArcimRowid,OrderName,OrderStartDate,callBackFun){
	var lnk = "oeorder.guideallergy.csp?EpisodeID="+GlobalObj.EpisodeID+"&ArcimRowId="+ArcimRowid+"&OrderStartDate="+OrderStartDate+"&GuideAllergyType=Append";
	websys_showModal({
		url:lnk,
		title:OrderName+' Ƥ��ҽ��ѡ��',
		width:700,height:300,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if (typeof result=="undefined"){
				result="";
			}
			callBackFun(result);
		}
	})
}
function ResizePromptWidth(){
	var northDIVMax = $("#layout_main_center_north").innerWidth();
	var northRightDivMax=$("#north-right-div").innerWidth();
	if (northRightDivMax==0) northRightDivMax=305;
	if (GlobalObj.INAdmTypeLoc!="Y"){
		$("#Prompt").css("width",parseInt(northDIVMax)-parseInt(northRightDivMax)-60); //580
	}else{
		if (GlobalObj.OrderPriorConfig=="1"){
			$("#Prompt").css("width",parseInt(northDIVMax)-northRightDivMax-173); //474
		}else{
			//ҽ�����ͺ���չʾ
			$("#Prompt").css("width",parseInt(northDIVMax)-northRightDivMax-300); //610
		}
	}
	$('#OrdNotesDetail_Btn').css('right',$(window).width()-($("#Prompt").offset().left+$("#Prompt").width())-5);
}
function RefreshOrderList(){
	ClearSessionData();
	SaveSessionData();
    $("#Order_DataGrid").jqGrid("clearGridData");
    var url = "oeorder.oplistcustom.new.request.csp?action=GetOrderList";
    var postData = { USERID: session['LOGON.USERID'], ADMID: GlobalObj.EpisodeID,NotDisplayNoPayOrd:GlobalObj.NotDisplayNoPayOrd };
    $("#Order_DataGrid").setGridParam({postData:postData}).trigger("reloadGrid");
    ReLoadLabInfo()
}
function SetOrdNurseBindOrd(){
	var winlocation=top.window.location;		            
    var VerfiOeordID=GetUrlParam(winlocation,"OeordID");
    if (VerfiOeordID){
        $.m({
		    ClassName:"web.DHCDocOrderCommon",
		    MethodName:"GetVerifiedOrder",
		    itemid:VerfiOeordID
		},function(LinkOrderStr){
			var VerifiedOrderArr = LinkOrderStr.split("^");
			var LinkedMasterOrderPriorRowid=VerifiedOrderArr[4];
			var HiddenOrderPrior = $("#HiddenOrderPrior").val();
			if ((HiddenOrderPrior=="ShortOrderPrior")&&(IsLongPrior(LinkedMasterOrderPriorRowid))) {
				$('#LongOrderPrior').click();
			}
			if ((HiddenOrderPrior=="LongOrderPrior")&&(!IsLongPrior(LinkedMasterOrderPriorRowid))) {
				$('#ShortOrderPrior').click();
			}
			SetVerifiedOrder(VerfiOeordID);
		});
    }
}
function GetOrderInsurCat(rowid,OrderInsurCatRowId){
	var InsurCatStr=GetCellData(rowid, "OrderInsurCatHideen");
	var ArrData = InsurCatStr.split(String.fromCharCode(2));
	for (var i = 0; i < ArrData.length; i++) {
        var ArrData1 = ArrData[i].split(String.fromCharCode(1));
        if (ArrData1[0]==OrderInsurCatRowId) return ArrData1[1];
    }
    return "";
}

function OrderChronicDiagchangehandler(e){
	try{
		var rowid=GetEventRow(e);
		var obj=websys_getSrcElement(e);
        var OrderChronicDiagCode=obj.value;
        SetCellData(rowid, "OrderChronicDiagCode", OrderChronicDiagCode);
	}catch(e){
        alert(e.message);
	}
}
function PriceDetail(){
	var ids =$('#Order_DataGrid').jqGrid("getGridParam", "selarrrow");
	if ((ids.length >1)||((ids ==null ||ids.length ==0))) {
		$.messager.alert("��ʾ", "��ѡ��һ��ҽ����");
		return;
	}
	var OrderARCIMRowid = GetCellData(ids[0], "OrderARCIMRowid");
	websys_showModal({
		url:"dhcdoc.arcimlinktar.hui.csp?ARCIMRowId=" + OrderARCIMRowid,
		title:'�շ���ϸ',
		width:1005,height:520
	});
}
function OrderLabSpecCollectionSitechangehandler(e){
    var rowid = "";
    var obj = websys_getSrcElement(e);
    if (obj.id.indexOf("_") > 0) {
        rowid = obj.id.split("_")[0];
    }
    SetCellData(rowid, "OrderLabSpecCollectionSiteRowid", obj.value);
}
function OrderLabSpecCollectionSiteChange(rowid){
	var OldOrderLabSpecCollectionSiteRowid=GetCellData(rowid, "OrderLabSpecCollectionSiteRowid");
	var OrderLabSpecRowid=GetCellData(rowid, "OrderLabSpecRowid");
	var OrderARCIMRowid=GetCellData(rowid, "OrderARCIMRowid");
	$.m({
	    ClassName:"web.DHCDocOrderCommon",
	    MethodName:"GetExCode",
	    ArcimRowid:OrderARCIMRowid
	},function(excode){
		if (excode) {
			var OrderLabSpecCollectionSiteStr=$.m({
			    ClassName:"DHCLIS.DHCCommon",
			    MethodName:"GetTestSetSpecimenSite",
			    TSCode:excode, 
			    SpecimenCode:OrderLabSpecRowid, 
			    HospitalCode:tkMakeServerCall("web.DHCDocOrderCommon", "GetCurrentSYSHospitalCode", session['LOGON.HOSPID'])
			},false);
			SetColumnList(rowid, "OrderLabSpecCollectionSite", OrderLabSpecCollectionSiteStr);
			if ((OrderLabSpecCollectionSiteStr!="")&&(OldOrderLabSpecCollectionSiteRowid!="")){
	            var ArrData = OrderLabSpecCollectionSiteStr.split(String.fromCharCode(3));
	            for (var i = 0; i < ArrData.length; i++) {
	                var ArrData1 = ArrData[i].split(String.fromCharCode(2));
	                if (ArrData1[0] == OldOrderLabSpecCollectionSiteRowid){
		                SetCellData(rowid, "OrderLabSpecCollectionSite", OldOrderLabSpecCollectionSiteRowid);
           				SetCellData(rowid, "OrderLabSpecCollectionSiteRowid", OldOrderLabSpecCollectionSiteRowid);
	                    break;
	                }
	            }
			}
		}
	});
}
/**
* @description: �û�ʿѡ��¼Ƶ�ι�������ҽ��ִ�м�¼�ַ�ʱ��
* @param {String} 
* @return: {String} 
*/
function GetOrderNurseExecLinkDispTimeStr(OrderName,OrderFreqRowid,OrderFreqDispTimeStr,OrderNurseLinkOrderRowid,callBackFun){
	websys_showModal({
		url:encodeURI("dhcdoc.ordernursexeclinkdisptime.csp?OrderNurseLinkOrderRowid=" + OrderNurseLinkOrderRowid+"&OrderFreqRowid="+OrderFreqRowid+"&OrderFreqDispTimeStr="+OrderFreqDispTimeStr),
		title:OrderName+' ������ҽ���ַ�ʱ��ѡ��',
		width:370,height:410,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if (typeof result=="undefined"){
				result="";
			}
			callBackFun(result);
		}
	})
}
function GetVerifiedOrderObjObj(VerifiedOrderArr){
	var OrderObj = {
        LinkedMasterOrderName: "",
        LinkedMasterOrderRowid: "",
        LinkedMasterOrderSeqNo: "",
        LinkedMasterOrderPriorRowid: "",
        LinkedMasterOrderFreRowId: "",
        LinkedMasterOrderFreFactor: "",
        LinkedMasterOrderFreInterval: "",
        LinkedMasterOrderFreDesc: "",
        LinkedMasterOrderFreqDispTimeStr:"",
        LinkedMasterOrderInstr:"",
        LinkedMasterOrderInstrRowid:""
    }
    OrderObj.LinkedMasterOrderName = VerifiedOrderArr[1];
    OrderObj.LinkedMasterOrderRowid = VerifiedOrderArr[2];
    OrderObj.LinkedMasterOrderSeqNo = VerifiedOrderArr[3];
    OrderObj.LinkedMasterOrderPriorRowid = VerifiedOrderArr[4];
    var OrderFreStr = VerifiedOrderArr[5];
    OrderObj.LinkedMasterOrderFreRowId = mPiece(OrderFreStr, String.fromCharCode(1), 0);
    OrderObj.LinkedMasterOrderFreFactor = mPiece(OrderFreStr, String.fromCharCode(1), 1);
    OrderObj.LinkedMasterOrderFreInterval = mPiece(OrderFreStr, String.fromCharCode(1), 2);
    OrderObj.LinkedMasterOrderFreDesc = mPiece(OrderFreStr, String.fromCharCode(1), 3);
    OrderObj.LinkedMasterOrderFreqDispTimeStr = mPiece(OrderFreStr, String.fromCharCode(1), 4);
    OrderObj.LinkedMasterOrderFreqDispTimeStr=OrderObj.LinkedMasterOrderFreqDispTimeStr.split(String.fromCharCode(13)).join(String.fromCharCode(1));
    OrderObj.LinkedMasterOrderSttDate = VerifiedOrderArr[6]; 
    OrderObj.LinkedMasterOrderInstr=VerifiedOrderArr[8];
    OrderObj.LinkedMasterOrderInstrRowid=VerifiedOrderArr[9];
    return OrderObj;
}
