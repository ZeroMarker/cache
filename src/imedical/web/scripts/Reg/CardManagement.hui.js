var PageLogicObj={
	m_CardListTabDataGrid:"",
	dw:$(window).width()-100,
	dh:$(window).height()-100,
	CardLoss:true,
	CardCancelLoss:true,
	CardExchange:true,
	CardReplace:true,
	CardCancel:true,
	toolbar:""
}
$(function(){
	//��ʼ��
	Init();
	//�¼���ʼ��
	InitEvent();
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	$("#Name").focus();
})
function PageHandle(){
	//������
	//LoadCardType();
}
function InitEvent(){
	$("#BFind").click(RegReturnListTabDataGridLoad);
	$("#BRecharge").click(BRechargeClickHandler);
	$('#RegNo').keydown(RegNoKeydownHandler);
	$('#CardNo').keydown(CardNoKeydownHandler);
	$('#CardNo').change(CardNoChange);
	$('#Name,#CredNo,#OutMedicareNo,#InMedicareNo,#EmMedicare,#InsuranceNo,#Telphone').keydown(FindDocumentOnKeyDownHandler);
	$("#BReadCard").click(ReadCardClickHandle);
	$("#BirthDay").change(BirthDayChange);
}
function Init(){
	PageLogicObj.m_CardListTabDataGrid=InitCardListTabDataGrid();
}
function InitCardListTabDataGrid(){
	PageLogicObj.toolbar=[{
		id:"CardLoss",
		text: '��ʧ',
		iconCls: 'icon-write-order',
		handler: function(){ShowReportLossWin("��ʧ");}
	},{
		id:"CardCancelLoss",
		text: '����',
		iconCls: 'icon-abort-order',
		handler: function(){ShowReportLossWin("����");}
	},'-',{
		id:"CardExchange",
		text: '����',
		iconCls: 'icon-change-loc',
		handler: function(){ShowExchangeWin("����");}
	},'-',{
		id:"CardReplace",
		text: '����',
		iconCls: 'icon-replace-order',
		handler: function(){ShowReportLossWin("����");}
	},'-',{
		id:"CardCancel",
		text: '�˿�',
		iconCls: 'icon-cancel-order',
		handler: function(){ShowCancelCardWin("�˿�");}
	}]
	var Columns=[[ 
		{field:'CardID',hidden:true,title:''},
		{field:'Name',title:'����',width:100},
		{field:'CardNO',title:'����',width:100},
		{field:'ActivedFlag',title:'��״̬',width:80},
		{field:'CardTypeDesc',title:'������',width:80},
		{field:'CredTypeDesc',title:'֤������',width:100},
		{field:'CredNo',title:'֤����',width:160},
		{field:'Ttelphone',title:'�绰',width:105},
		{field:'TBirthday',title:'��������',width:100},
		{field:'TInMedicareNo',title:'סԺ������',width:100},
		{field:'TAddress',title:'סַ',width:120},
		{field:'TCompany',title:'������λ',width:150},
		{field:'TSex',title:'�Ա�',width:50},
		{field:'TPatType',title:'��������',width:80},
		{field:'TPapmiNo',title:'�ǼǺ�',width:100},
		{field:'TOutMedicareNo',title:'���ﲡ����',width:100},
		{field:'TPoliticalLevel',title:'���߼���',width:90},
		{field:'TSecretLevel',title:'�����ܼ�',width:90},
		{field:'TBalance',title:'�˻����',width:90},
		{field:'TPatientId',title:'',hidden:true},
		{field:'myOtherStr',title:'',hidden:true},
		{field:'TCardTypeRowId',title:'',hidden:true}
    ]]
	var CardListTabDataGrid=$("#CardListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'CardID',
		columns :Columns,
		toolbar:PageLogicObj.toolbar,
		onSelect:function(index, row){
			ChangeButtonStatus(row);
		},
		onRowContextMenu:function(e, index, row){
			e.preventDefault(); //��ֹ����������Ҽ��¼�
			PageLogicObj.m_CardListTabDataGrid.datagrid("selectRow",index);
			setTimeout(function(){ShowGridRightMenu(e,index, row);});
		}
	});
	CardListTabDataGrid.datagrid('loadData', { total: 0, rows: [] });  
	return CardListTabDataGrid;
}
function ShowGridRightMenu(e,rowIndex, rowData){
	$("#RightKeyMenu").empty(); //	������еĲ˵�
	for (var i=0;i<PageLogicObj.toolbar.length;i++){
		if (PageLogicObj.toolbar[i]=="-") continue;
		var id=PageLogicObj.toolbar[i]["id"];
		var text=PageLogicObj.toolbar[i]["text"];
		var iconCls=PageLogicObj.toolbar[i]["iconCls"];
		var handler=PageLogicObj.toolbar[i]["handler"];
        $('#RightKeyMenu').menu('appendItem', {
            id:id,
			text:text,
			iconCls: iconCls, 
			onclick: eval(handler)
		});
		if (!PageLogicObj[id]){
			var item = $('#RightKeyMenu').menu('findItem', text);
			$('#RightKeyMenu').menu('disableItem', item.target);
		}
    }
    $('#RightKeyMenu').menu('show', {  
        left: e.pageX,         //�����������ʾ�˵�
        top: e.pageY
    });
}
function RegReturnListTabDataGridLoad(){
	PageLogicObj.m_CardListTabDataGrid.datagrid("uncheckAll");
	$.cm({
	    ClassName : "web.DHCBL.CARD.CardManager",
	    QueryName : "PatientCardQuery",
	    Name:$("#Name").val(),
	    IDCardNo:"", //���֤��
	    CardNo:$("#CardNo").val(),
	    CardStatus:"N",
	    CardTypeID:$("#CardTypeRowID").val(), //GetCardTypeRowId(),
	    SupportFlag:"",
	    CredNo:$("#CredNo").val(),
	    UseStatus:"",
	    BirthDay:$("#BirthDay").val(),
	    Telphone:$("#Telphone").val(),
	    OutMedicareNo:$("#OutMedicareNo").val(),
	    InMedicareNo:$("#InMedicareNo").val(),
	    //NewOutMedicareNo:"",
	    NewInMedicareNo:"",
	    InsuranceNo:$("#InsuranceNo").val(),
	    EmMedicare:$("#EmMedicare").val(),
	    RegNo:$("#RegNo").val(),
	    Pagerows:PageLogicObj.m_CardListTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		// Specific value to compare against
		var specificValue = $("#Name").val();
		var records = GridData.rows;
		var exact = records.filter(record => record.Name == specificValue);
		var mid = records.filter(record => record.Name.startsWith(specificValue) && record.Name !== specificValue);
		var remain = records.filter(record => !record.Name.startsWith(specificValue));

		// Sort the array based on pinyin
		mid.sort((a, b) =>
		a.Name.localeCompare(b.Name, 'zh-Hans-CN', {sensitivity: 'accent'})
		);
		
		remain.sort((a, b) =>
		a.Name.localeCompare(b.Name, 'zh-Hans-CN', {sensitivity: 'accent'})
		);
		
		GridData.rows = exact.concat(mid.concat(remain));
		//GridData.rows.sort((a, b) => a.Name.localeCompare(b.Name));
		//console.log(GridData);
		
		PageLogicObj.m_CardListTabDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function pagerFilter(data){
	if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
		data = {
			total: data.length,
			rows: data
		}
	}
	var dg = $(this);
	var opts = dg.datagrid('options');
	var pager = dg.datagrid('getPager');
	pager.pagination({
		showRefresh:false,
		onSelectPage:function(pageNum, pageSize){
			opts.pageNumber = pageNum;
			opts.pageSize = pageSize;
			pager.pagination('refresh',{
				pageNumber:pageNum,
				pageSize:pageSize
			});
			dg.datagrid('loadData',data);
			dg.datagrid('scrollTo',0); //������ָ������        
		}
	});
	if (!data.originalRows){
		data.originalRows = (data.rows);
	}
	var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
	if ((start+1)>data.originalRows.length){
		//ȡ���������������ҳ��ʼֵ
		start=Math.floor((data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
		opts.pageNumber=opts.pageNumber-1;
	}
	var end = start + parseInt(opts.pageSize);
	data.rows = (data.originalRows.slice(start, end));
	if (data.rows) {
		for (var i = 0; i < data.rows.length; i++) {
			var myOtherStr=data.rows[i].myOtherStr;
			data.rows[i].Ttelphone = myOtherStr.split("^")[0];
			data.rows[i].TBirthday = myOtherStr.split("^")[1];
			data.rows[i].TAddress = myOtherStr.split("^")[2];
			data.rows[i].TCompany = myOtherStr.split("^")[3];
			data.rows[i].TSex = myOtherStr.split("^")[4];
			data.rows[i].TPatType = myOtherStr.split("^")[5];
			data.rows[i].TPapmiNo = myOtherStr.split("^")[6];
			data.rows[i].TInMedicareNo = myOtherStr.split("^")[7];
			data.rows[i].TOutMedicareNo = myOtherStr.split("^")[8];
			data.rows[i].TNewOutMedicareNo = myOtherStr.split("^")[9];
			data.rows[i].TNewInMedicareNo = myOtherStr.split("^")[10];
			data.rows[i].TAccMBalance = myOtherStr.split("^")[11];
			data.rows[i].TCardTypeRowId = myOtherStr.split("^")[12];
		}
	}
	return data;
}
function RegNoKeydownHandler(e){
	var key=websys_getKey(e);
	if(key==13){
		var RegNo=$('#RegNo').val();
		if (RegNo!='') {
			var RegNoLength=10;
			if ((RegNo.length<RegNoLength)&&(RegNoLength!=0)) {
				for (var i=(RegNoLength-RegNo.length-1); i>=0; i--) {
					RegNo="0"+RegNo;
				}
			}
		}
		$(".textbox").val('');
		$('#RegNo').val(RegNo);
		RegReturnListTabDataGridLoad();
	}
}
function CardNoChange(){
	var CardNo=$("#CardNo").val();
	if (CardNo==""){
		$("#CardTypeNew,#CardTypeRowID").val("");
	}
}
function CardNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		var CardNo=$("#CardNo").val();
		if (CardNo=="") return;
		CheckCardNo();
		return false;
	}
}
function CheckCardNo(){
	var CardNo=$("#CardNo").val();
	if (CardNo=="") return false;
	var myrtn=DHCACC_GetAccInfo("",CardNo,"","",CardNoKeyDownCallBack);
}
function CardNoKeyDownCallBack(myrtn){
	var CardNo=$("#CardNo").val();
	var CardTypeNew=$("#CardTypeNew").val();
	$(".textbox").val('');
	$("#CardTypeNew").val(CardTypeNew);
	var myary=myrtn.split("^");
   var rtn=myary[0];
   if ((rtn=="0")||(rtn=="-201")){
		var PatientID=myary[4];
		var PatientNo=myary[5];
		var CardNo=myary[1]
		$("#CardTypeRowID").val(myary[8]);
		$("#CardNo").focus().val(CardNo);
		RegReturnListTabDataGridLoad();
	}else if(rtn=="-200"){
		$.messager.alert("��ʾ","����Ч!","info",function(){
			$("#CardNo").val(CardNo).focus();
		});
		return false;
	}
}
function FindDocumentOnKeyDownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		RegReturnListTabDataGridLoad();
	}
}
function ReadCardClickHandle(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}
function ChangeButtonStatus(row){
	EnableToolbar();
	var status=row["ActivedFlag"];
	//����״̬�Ŀ��ܹ�ʧ���������˿�
	if ((status=="����")||(status=="����")){ 
		PageLogicObj.CardCancelLoss=false,$("#CardCancelLoss").linkbutton("disable");
		PageLogicObj.CardReplace=false,$("#CardReplace").linkbutton("disable");
	}else if(status=="��ʧ"){
		//�����á�����
		PageLogicObj.CardLoss=false,$("#CardLoss").linkbutton("disable");
		PageLogicObj.CardExchange=false,$("#CardExchange").linkbutton("disable");
		PageLogicObj.CardCancel=false,$("#CardCancel").linkbutton("disable");
	}else if(status=="����"){
		//������
		PageLogicObj.CardExchange=false,$("#CardExchange").linkbutton("disable");
		PageLogicObj.CardCancelLoss=false,$("#CardCancelLoss").linkbutton("disable");
		PageLogicObj.CardLoss=false,$("#CardLoss").linkbutton("disable");
		PageLogicObj.CardCancel=false,$("#CardCancel").linkbutton("disable");
		PageLogicObj.CardReplace=false,$("#CardReplace").linkbutton("disable");
	}
	//�жϸÿ������Ƿ�Ϊ��ǰҵ��֧�� L ��ʧ E ���� F ���� B �˿�
	var TCardTypeRowId=row["TCardTypeRowId"];
	var SupportTypeFlag="L^E^F^B";
	for (var i=0;i<SupportTypeFlag.split("^").length;i++){
		var SupportType=SupportTypeFlag.split("^")[i];
		var rtn=$.m({
			ClassName:"web.DHCBL.CARD.CardManager",
			MethodName:"IsSupportCardType",
			dataType:"text",
			SupportFlag:SupportType,
			CardTypeID:TCardTypeRowId
		},false);
		if (rtn!="1"){
			if (SupportType=="L"){
				PageLogicObj.CardLoss=false,$("#CardLoss").linkbutton("disable");
			}else if(SupportType=="E"){
				PageLogicObj.CardReplace=false,$("#CardReplace").linkbutton("disable");
			}else if(SupportType=="F"){
				PageLogicObj.CardExchange=false,$("#CardExchange").linkbutton("disable");
			}else{
				PageLogicObj.CardCancel=false,$("#CardCancel").linkbutton("disable");
			}
		}
	}
}
function EnableToolbar(){
	PageLogicObj.CardLoss=true;
	PageLogicObj.CardExchange=true;
	PageLogicObj.CardCancel=true;
	PageLogicObj.CardCancelLoss=true;
	PageLogicObj.CardReplace=true;
	$('#CardLoss').linkbutton("enable");  
	$('#CardExchange').linkbutton("enable");  
	$('#CardCancel').linkbutton("enable");  
	$('#CardCancelLoss').linkbutton("enable");  
	$('#CardReplace').linkbutton("enable");  
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}
function destroyDialog(id){
   //�Ƴ����ڵ�Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
function ShowReportLossWin(text){
	var row=PageLogicObj.m_CardListTabDataGrid.datagrid("getSelected");
	if (!row){
		$.messager.alert("��ʾ","��ѡ���¼!");
		return false;
	}
	var CardID=row["CardID"];
	var src="reg.reportloss.hui.csp?CardID="+CardID+"&OpertionType="+text;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("CardManager",text, "795", "430","icon-w-edit","",$code,"");
} 
function ShowExchangeWin(text){
	var row=PageLogicObj.m_CardListTabDataGrid.datagrid("getSelected");
	if (!row){
		$.messager.alert("��ʾ","��ѡ���¼!");
		return false;
	}
	var CardID=row["CardID"];
	var src="reg.exchangecard.hui.csp?CardID="+CardID;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("CardManager",text, "795", "400","icon-w-edit","",$code,"");
} 
function ShowCancelCardWin(text){
	var row=PageLogicObj.m_CardListTabDataGrid.datagrid("getSelected");
	if (!row){
		$.messager.alert("��ʾ","��ѡ���¼!");
		return false;
	}
	var CardID=row["CardID"];
	var src="reg.cancelcard.hui.csp?CardID="+CardID;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("CardManager",text, "795", "460","icon-w-edit","",$code,"");
}
function BirthDayChange(){
	var BirthDay=$('#BirthDay').val();
	var BirLen=BirthDay.length
    if (BirLen==0) return true;
	if ((BirLen!=8)&&(BirLen!=10)){
		$("#BirthDay").addClass("newclsInvalid");
		$("#BirthDay").focus();
		return false;
	}
	if (BirLen==8){
		if (ServerObj.sysDateFormat=="4"){
			BirthDay=BirthDay.substring(6,8)+"/"+BirthDay.substring(4,6)+"/"+BirthDay.substring(0,4)
		}else{
			BirthDay=BirthDay.substring(0,4)+"-"+BirthDay.substring(4,6)+"-"+BirthDay.substring(6,8)
		}
	}
	$('#BirthDay').val(BirthDay);
	var myrtn=false
	if (ServerObj.sysDateFormat=="4"){
		var myrtn=DHCWeb_IsDate(BirthDay,"/")
	}else{
		var myrtn=DHCWeb_IsDate(BirthDay,"-")
	}
	if (!myrtn){
		$("#BirthDay").addClass("newclsInvalid");
		$("#BirthDay").focus();
		return false;
	}
	$("#BirthDay").removeClass("newclsInvalid");
}

function BRechargeClickHandler(){
	var src="dhcbill.opbill.accdep.pay.csp"
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Deposit","Ԥ�����ֵ", PageLogicObj.dw, PageLogicObj.dh,"icon-w-inv","",$code,"");
}