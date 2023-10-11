var PageLogicObj={
	m_ordlistDataGrid:"",
	//m_AddItemToListMethod: "LookUp",
	LookupPanelIsShow:0,
	NSHeight:400,
	EplisodeID:"",
	LinkedMasterOrderRowid:""
};
window.onbeforeunload = DocumentUnloadHandler;
$(function(){
	//��ʼ��
	Init();
	//�¼���ʼ��
	InitEvent();
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
});
function Init(){
	InitTempFrame();
	OpenOrdTemplate();
	PageLogicObj.m_ordlistDataGrid=InitOrdListDataGrid();
	InitsearchItemLookUp();
	PageLogicObj.AnaesthesiaID=GetMenuPara("AnaesthesiaID");
	if (PageLogicObj.AnaesthesiaID!="") {
		$.extend(ServerObj, { NotUnSelectPat: "Y"});
	}
}
function PageHandle(){
	//LoadselPatKW([]);
}
$(window).load(function() {
	//��ȡsession����
	//GetSessionData(); 
	$("#searchItem").focus();
	
})
function InitEvent(){
	$("#FindSupplementedOrd").click(FindSupplementedOrdClick);
	$("#searchItem").keydown(searchItemkeydown);
}
var selRowIndex="";
function InitOrdListDataGrid(){
	var toobar=[{
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function() {DelClickHandle(); }
    },'-',{
	    id: 'InsertOrder',
        text: '���ҽ��',
        iconCls: 'icon-paper-stamp',
        handler: function() {UpdateClickHandler();}
    }/*,'-',{
        text: 'ҽ��ģ��',
        iconCls: 'icon-add-note',
        handler: function() { OpenOrdTemplate();}
    }/*,{
        text: '�ݴ�',
        iconCls: 'icon-save',
        handler: function() { DocumentUnloadHandler();}
    },'-',{
        iconCls: 'icon-arrow-top',
        handler: function() { SortRowClick("up");}
    },{
        iconCls: 'icon-arrow-bottom',
        handler: function() { SortRowClick("down");}
    }*/];
	if (ServerObj.GroupCPPFlag=="Y") {
		toobar.push('-');
		toobar.push({
		    text: 'Ԥ�۷�',
	        iconCls: 'icon-paper-money',
	        handler: function() { CardBillClick();}
		});
	}
	// ���տ��ұ༭��
	var rLocEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: '',
			valueField: "id", 
			textField: "text",
			editable:false,
			onSelect:function(option){
				var index = getRowIndex(this);
				var rows = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
				rows[index]["OrderRecDepRowid"]=option.id;
				rows[index]["OrderRecDep"]=option.text;
				ChangeLinkOrderRecDept(index);
			} 
		}

	}
	//�����б�
	var rOperationEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: '',
			valueField: "id", 
			textField: "text",
			onSelect:function(option){
				if (option) {
					var index = getRowIndex(this);
					var rows = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
					rows[index]["OrderOperationCode"]=option.id;
					rows[index]["OrderOperation"]=option.text;
					ChangeLinkOrderOperation(index);
				}
			},
			onChange:function(newValue, oldValue){
				if (newValue=="") {
					 var index = getRowIndex(this);//����ǵ�ǰcombobox������༭�е�����
					 var rows = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
					 rows[index]["OrderOperationCode"]="";
					 rows[index]["OrderOperation"]="";
					 ChangeLinkOrderOperation(index);
				}
			}
		}

	}
	var Columns=[[ 
		{field:'rowid',title:'',checkbox:true},
		{field:'id',title:'���',width:40},
		{field:'OrderMasterSeqNo',title:'����',width:40,hidden:true},
		{field:'OrderName',title:'����',width:200},
		{field:'OrderPackQty',title:'����',width:50,
			editor : {type : 'text',options : {}}
		},
		{field:'OrderPackUOM',title:'��λ',width:70},
		{field:'OrderMaterialBarcodeHiden',title:'����',width:150},
		{field:'OrderPrice',title:'����',width:90,
			editor : {type : 'text',options : {}}
		},
		{field:'OrderSum',title:'�ܽ��',width:90,
			editor : {type : 'text',options : {editable:false}}
		},
		{field:'OrderRecDep',title:'���տ���',width:150,editor:rLocEditor
			/*formatter:function(value,row,index){
				if (row['OrderRecLocStr']){
				   var Len=row['OrderRecLocStr'].split(String.fromCharCode(2)).length;
				   if (Len>1){
					   return '<a class="editcls" id= "' + row['id'] + '" onmouseover="OrdLocChangeShow(this)">'+value+'</a>';
			       }else{
				       return value;
				   }
			   }
			   return value;
            }*/
		},
		{field:'OrderOperation',title:'�����б�',width:90,editor:rOperationEditor},
		{field:'OrderRowID',title:'OrderRowID',hidden:true},
		{field:'OrderOperationStr',hidden:true}
		
    ]]
	var ordlistDataGrid=$("#ordlist").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:false,
		pagination : false,  
		idField:'id',
		columns :Columns,
		toolbar:toobar,
		rowStyler: function(index,row){
			if ((row['CalSeqNo']!="")&&(row['CalSeqNo']!="undefined")){
				if (row['CalSeqNo'].indexOf(".")>=0){
					return 'background-color:#cdf1cd;';
				}else{
					return 'background-color:#94e494;';
				}
			}
		},
		onCheck:function(index, row){
			if (selRowIndex!="") return false;
			var OrderItemInValid=row["OrderItemInValid"];
			if (OrderItemInValid=="1"){return false;}
			var selOrderSeqNo=row["id"];
			var OrderMasterSeqNo=row["OrderMasterSeqNo"];
			if (OrderMasterSeqNo!=""){
				var index=$("#ordlist").datagrid('getRowIndex',OrderMasterSeqNo);
				$("#ordlist").datagrid('checkRow',index);
			}else{
				var GridData=$("#ordlist").datagrid("getData");
				for (var m=index+1;m<GridData.rows.length;m++){
					var OrderMasterSeqNo=GridData.rows[m]["OrderMasterSeqNo"];
					if (OrderMasterSeqNo==selOrderSeqNo) {
						var OrderItemInValid=GridData.rows[m]["OrderItemInValid"];
						if (OrderItemInValid!="1"){
							selRowIndex=m;
							$("#ordlist").datagrid('checkRow',m);
						}
					}
				}
			}
			selRowIndex="";
		},
		onUnselect:function(index, row){
			if (selRowIndex!="") return false;
			var OrderItemInValid=row["OrderItemInValid"];
			if (OrderItemInValid=="1"){return false;}
			var selOrderSeqNo=row["id"];
			var OrderMasterSeqNo=row["OrderMasterSeqNo"];
			if (OrderMasterSeqNo!=""){
				var index=$("#ordlist").datagrid('getRowIndex',OrderMasterSeqNo);
				$("#ordlist").datagrid('uncheckRow',index);
			}else{
				var GridData=$("#ordlist").datagrid("getData");
				for (var m=index+1;m<GridData.rows.length;m++){
					var OrderMasterSeqNo=GridData.rows[m]["OrderMasterSeqNo"];
					if (OrderMasterSeqNo==selOrderSeqNo) {
						var OrderItemInValid=GridData.rows[m]["OrderItemInValid"];
						if (OrderItemInValid!="1"){
							selRowIndex=m;
							$("#ordlist").datagrid('uncheckRow',m);
						}
					}
				}
			}
			selRowIndex="";
		},
		onDblClickRow:function(rowIndex, rowData){
			if ((rowData.OrderRowID)&&(rowData.OrderRowID!="")) return ;
			var rowidArr=GetOrderSeqArr(rowIndex);
			var NeedOpenChangeOrder=false
			for (var i=0;i<rowidArr.length;i++){
				SetBeginEdit(rowidArr[i]);
			}
		}
	});
	if (GetMenuPara("AnaesthesiaID")=="") {
		ordlistDataGrid.datagrid("hideColumn","OrderOperation");
	}
	try {
		$.data($("#ordlist")[0], "datagrid").panel.bind("drop", function(event) {
			console.log("��ֹ��ק");return false;
		});
	} catch (error) {
		
	}
	return ordlistDataGrid;
}
function InitsearchItemLookUp(){
	$("#searchItem").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'ARCIMDesc',
        columns:[[  
           {field:'ARCIMDesc',title:'ҽ������',width:250,sortable:true},
           {field:'subcatdesc',title:'����',width:100,sortable:true},
           {field:'ItemPrice',title:'�۸�',width:80,sortable:true},
           {field:'BasicDrugFlag',title:'����ҩ��',width:90,sortable:true},
           {field:'billuom',title:'�Ƽ۵�λ',width:90,sortable:true},
           {field:'StockQty',title:'�����',width:80,sortable:true},
           {field:'PackedQty',title:'�����',width:80,sortable:true},
           {field:'GenericName',title:'ͨ����',width:120,sortable:true},
           {field:'ResQty',title:'��;��',width:80,sortable:true},
           {field:'DerFeeRules',title:'�շѹ涨',width:90,sortable:true},
           {field:'InsurClass',title:'ҽ�����',width:90,sortable:true},
           {field:'InsurSelfPay',title:'�Ը�����',width:90,sortable:true},
           {field:'Recloc',title:'���տ���',width:100,sortable:true},
           {field:'arcimcode',title:'����',width:90,sortable:true}
        ]],
        pagination:true,
        rownumbers:true,
        panelWidth:1000,
        panelHeight:300,
        isCombo:true,
        minQueryLen:2,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocOrderEntry',QueryName: 'LookUpItem'},
        rowStyler: function(index,row){
	        var ArcimID=row["HIDDEN"]
            var Type=row["HIDDEN2"]
            var OrderType=row["HIDDEN4"]
            var HaveStock=row["HIDDEN16"]
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
		    var OrderPriorRowid = "",OrdCateGoryRowId="",OrdCatGrp="";
			param = $.extend(param,
				{Item:desc,GroupID:GroupID,Category:"",SubCategory:"",TYPE:P5,
				 OrderDepRowId:LogonDep,OrderPriorRowId:OrderPriorRowid,
				 EpisodeID:GetParamAdm(),BillingGrp:P9,BillingSubGrp:P10,UserRowId:session["LOGON.USERID"],
				 OrdCatGrp:OrdCatGrp,NonFormulary:"",Form:CurLogonDep,Strength:"",Route:""
       	   });
	    },onSelect:function(ind,item){
		    var ItemArr=new Array();
		    $.each(item, function(key, val) {
				ItemArr.push(val);
			});
			OrderItemLookupSelect(ItemArr.join("^"));
			ClearSearch();
            $("#searchItem").focus();
		},onHidePanel:function(){
			PageLogicObj.LookupPanelIsShow=0;
		},onShowPanel:function(){
			PageLogicObj.LookupPanelIsShow=1;
		},onBeforeShowPanel:function(){
			if ($("#searchByBarcode").checkbox('getValue')){return false;}
			return true;
		},selectRowRender:function(row){
			if (!row){return "";}
			if (row['Recloc']=="") {return "";}
			if (row['Recloc'].split("/").length==1){
				var OrderMsg=row['Recloc']+":"+row['StockQty'];
			}else{
				var OrderMsg = tkMakeServerCall("web.DHCDocOrderCommon", "GetOrderStockMsg", ServerObj.EpisodeID,row['HIDDEN'],row['Recloc'],session['LOGON.CTLOCID']);
            	if (OrderMsg==""){return "";}
			}
            var innerHTML="<div style='height:100px;background:#FFFFFF'>";
            innerHTML=innerHTML+"<div style='width:1000px;color:red;font-size:18px;'>";
            innerHTML=innerHTML+OrderMsg;
            innerHTML=innerHTML+"</div>";
            innerHTML=innerHTML+"</div>";
            return innerHTML;
		}
    });
}
function OrderItemLookupSelect(text){
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
	var rowid=GetNewrowid();
    if (iordertype == "ARCIM") {
		var OrdParamsArr=new Array();
		OrdParamsArr[OrdParamsArr.length]={
			OrderARCIMRowid:icode,
			ItemDefaultRowId:""
		};
		var RtnObj = AddItemToList(rowid,OrdParamsArr,"data", "");
		var rowid=RtnObj.rowid;
		var returnValue=RtnObj.returnValue;
        DHCDocUseCount(icode, "User.ARCItmMast");
    } else {
        //ҽ����
        if ($.isNumeric(rowid) == false) { return; }
        OSItemListOpen(icode, "", "YES", "", "");
        DHCDocUseCount(icode, "User.ARCOrdSets")
    }
    //������ݳɹ��� ����Footer����
    return true;
}
//��ҽ���׽���
function OSItemListOpen(ARCOSRowid, OSdesc, del, itemtext, OrdRowIdString) {
    if (ARCOSRowid != "") {
	    if (ServerObj.MedNotOpenARCOS=="1"){
		    var ret=tkMakeServerCall("web.DHCDocOrderCommon", "SetARCOSItemDirect","AddCopyItemToList",ARCOSRowid,session['LOGON.HOSPID'],"");
		}else{
        	websys_showModal({
				url:"doc.arcositemlist.hui.csp?EpisodeID=" +GetParamAdm()+ "&ARCOSRowid=" + ARCOSRowid +"&nowOrderPrior=0",
				title:'ҽ����¼��',
				width:1160,height:592,
				AddCopyItemToList:AddCopyItemToList
			});
		}
    }
}
//���ҽ����
function AddCopyItemToList(ParaArr) {
    //GlobalObj.AuditFlag = 0;
	//ParaArr�����ﶪʧ������ĳ�Ա���ԣ����
	var OrdArr = new Array();
	for (var i = 0,ArrLength = ParaArr.length; i < ArrLength; i++){
		OrdArr.push(ParaArr[i]);
	}
	window.setTimeout(function(){
		AddCopyItemToListSub(OrdArr);
	}, 100);
	function AddCopyItemToListSub(OrdArr){
		var OrdParamsArr=new Array();
		//������ҽ����Ϣ�ϲ���һ����������
		for (var i = 0,ArrLength = OrdArr.length; i < ArrLength; i++) {
			var Para1Str=OrdArr[i];
			
			var para1Arr = Para1Str.split("!")
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
			if ((KSSCopyFlag != "undefined") && (KSSCopyFlag == "KSS")) {
				ServerObj.AuditFlag = 1;
			}
			var OrderBodyPartLabel="";
			if (Para != "") {
				var OrderBodyPartLabel=mPiece(Para, "^", 17);
				if (typeof OrderBodyPartLabel=="undefined") OrderBodyPartLabel="";
			}
			var OrderARCOSRowid = para1Arr[8];
			if ((typeof OrderARCOSRowid == "undefined") || (OrderARCOSRowid == "undefined")) {
				OrderARCOSRowid="";
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
				ITMRowId:ITMRowId
			};
		}
		if (OrderARCOSRowid==""){
			var OrderARCOSRowid=mPiece(Para, "^", 6);
		}
		var FastEntryMode=0;
		var	FastEntryName="";
		///�ж��Ƿ����ڿ���ҽ����
		if (OrderARCOSRowid!=""){
			var ARCOSInfo=cspRunServerMethod(ServerObj.GetARCOSInfoMethod,OrderARCOSRowid);
			FastEntryName=mPiece(ARCOSInfo,"^",0)
			if (mPiece(ARCOSInfo,"^",1)=="Y"){
				FastEntryMode=1;
			}
		}
		var ExpStr=CopyType+"^"+FastEntryMode+"^"+FastEntryName+"^"+OrderARCOSRowid;
		var rowid=GetNewrowid();
		var RtnObj = AddItemToList(rowid,OrdParamsArr,"obj", ExpStr);
		var rowid=RtnObj.rowid;
		var returnValue=RtnObj.returnValue;
	}
}
//��ȡ������ID
function GetNewrowid() {
    var rowid = "";
    var rowids = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
    if (rowids.length > 0) {
        rowid = parseInt(rowids[rowids.length-1]['id'])+1;
    } else {
        rowid = 1;
    }
    return rowid;
}
function AddItemToList(rowid,OrdParams,AddMethod,ExpStr) {
	if (PageLogicObj.LinkedMasterOrderRowid==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ��¼��ҽ�����в�¼");
		return RtnObj;
		}
	var RtnObj={
		returnValue:false,
		rowid:rowid
	};
	var AdmStr=PageLogicObj.EplisodeID //GetSelPatKW();
	if (AdmStr!="") {
		var warning=tkMakeServerCall("web.DHCDocNurseBatchSupplementOrd", "ChkOrdEntryLimit",AdmStr);
		if (warning!="") {
			$.messager.alert("��ʾ",warning);
			return RtnObj;
		}
	}
	var CopyType=mPiece(ExpStr, "^", 0);
	var FastEntryMode=mPiece(ExpStr, "^", 1);
	var FastEntryName=mPiece(ExpStr, "^", 2);
	var OrderARCOSRowid=mPiece(ExpStr, "^", 3);
    //�������¼����ȡ���տ���?�Ͱѵ�¼���Ҵ���ȥ session['LOGON.CTLOCID']
    var LogonDep = GetLogonLocByFlag();
    //��Ժ
	var OrderOpenForAllHosp="0";
    var SessionStr = GetSessionStr();
    var BaseParam = {
		///����ҽ����Ϣ-��̨�������ⲿ������
		OrderARCIMRowid:"",
		RelocRowID:"",
		MaterialBarcode:"",
		///rowid��Ҫ�ں�̨�޸�,��ǰ̨��ʵ���кŲ�һ���ܶ���������ԭ��ο�����ҽ����¼�빦��
		rowid:rowid,
		///ȫ�ֱ���
		LogonDep:LogonDep,
		OrderOpenForAllHosp:OrderOpenForAllHosp, 
		SessionStr:SessionStr,
		AnaesthesiaID:GetMenuPara("AnaesthesiaID"), //����ID
		OrderOperationCode:GetMenuPara("AnaestOperationID"), //�����б���ϸID
		OrderARCOSRowid:OrderARCOSRowid,
		LinkedMasterOrderRowid:PageLogicObj.LinkedMasterOrderRowid,
		Adm:GetParamAdm()//GetMenuPara("EpisodeID"),
		
    };
    var ItemOrdsJson=GetItemOrds();
    var NeedAddItemCongeriesObj=GetItemCongeries(OrdParams,BaseParam,ItemOrdsJson);
    if (NeedAddItemCongeriesObj.length==0){
		$.extend(RtnObj, {returnValue:false});
		return RtnObj;
	}
	//����ҽ����
	if (FastEntryMode==1){
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
		rowid=GetNewrowid();
		if (NeedAddSingleRowItem.length<Len){
	    	var ParamObj={};
	    	ParamObj.OrderARCIMRowid="";
	    	ParamObj.rowid=rowid;
	    	ParamObj.OrderName=FastEntryName;
	    	ParamObj.OrderARCOSRowid=OrderARCOSRowid;
	    	ParamObj.OrderSum=ItemCongeriesSum;
	    	ParamObj.OrderMasterSeqNo="";
	    	ParamObj.id=rowid;
	    	ParamObj.CalSeqNo="";
	    	var OrderItemCongeriesJson=JSON.stringify(NeedAddItemCongeriesObj);
	    	ParamObj.OrderItemCongeries=OrderItemCongeriesJson;
	    	ParamObj.OrderRecLocStr=NeedAddItemCongeriesObj[0].OrderRecLocStr
	    	ParamObj.OrderRecDep=NeedAddItemCongeriesObj[0].OrderRecDep
	    	ParamObj.OrderOperation=NeedAddItemCongeriesObj[0].OrderOperation
	    	ParamObj.OrderOperationStr=NeedAddItemCongeriesObj[0].OrderOperationStr
	    	ParamObj.AnaesthesiaID=GetMenuPara("AnaesthesiaID"), //����ID
			ParamObj.OrderOperationCode=GetMenuPara("AnaestOperationID"), //�����б���ϸID
	    	AddItemDataToRow(ParamObj,{});
    	}
		if (NeedAddSingleRowItem.length>0){
			AddItemCongeriesToRow(rowid,AddMethod,NeedAddSingleRowItem);
		}
	}else{
    	var rowid=AddItemCongeriesToRow(rowid,AddMethod,NeedAddItemCongeriesObj);
    }
    if ((rowid!="")&&(NeedAddItemCongeriesObj.length>0)){
		$.extend(RtnObj, {returnValue:true,rowid:rowid});
		SetScreenSum();
	}else{
		$.extend(RtnObj, {returnValue:false});
	}
	return RtnObj;
	function AddItemCongeriesToRow(rowid,AddMethod,NeedAddItemCongeriesObj){
		var seqnoarr = new Array(),GroupSeqNoArr = new Array();
		var SuccessCount=0;
		var ParamObj={},CopyRowDataObj={};
		var Startrowid="";
		///������������ӵ�������
		for (var i=0,Length=NeedAddItemCongeriesObj.length;i<Length;i++) {
			ParamObj={};
			ParamObj=NeedAddItemCongeriesObj[i];
			rowid=GetNewrowid();
			ParamObj.rowid=rowid;
			ParamObj.id=rowid;
			if (Startrowid==""){Startrowid=ParamObj.rowid;}
			var CalSeqNo=ParamObj.CalSeqNo;
			//��¼������ϵ
			var MasterSeqNo="";
			var tempseqnoarr = CalSeqNo.split(".");
			if (tempseqnoarr.length > 1) {
				var masterseqno = tempseqnoarr[0];
				if (seqnoarr[masterseqno]) {
					MasterSeqNo = seqnoarr[masterseqno] //+"."+tempseqnoarr[1];
				}
			}
			ParamObj.OrderMasterSeqNo=MasterSeqNo;
			if (MasterSeqNo!=""){
				GroupSeqNoArr[rowid]=MasterSeqNo;
			}
			CopyRowDataObj={},RowDataObj={};
			CopyRowDataObj=DeepCopyObject(RowDataObj);
			//����������
			var returnValue=AddItemDataToRow(ParamObj,CopyRowDataObj);
			if (returnValue == true) {
				if (tempseqnoarr.length =1) {
					newseqno = CopyRowDataObj.rowid;
					seqnoarr[CalSeqNo] = newseqno;
				}
				if (AddMethod=="data"){
					SetBeginEdit(rowid);
				}
			}
			if ((i+1)<Length){
				rowid="";
			}
			SuccessCount++;
		}
		var Endrowid=rowid;
		return rowid;
	}
    function GetItemCongeries(OrdCongeriesObj,BaseParamObj,ItemOrdsJson){
	    var NeedAddItemCongeriesObj = new Array();
		var OrdCongeriesJson=JSON.stringify(OrdCongeriesObj);
		var BaseParamJson=JSON.stringify(BaseParamObj);
		
		var ItemCongeries = cspRunServerMethod(ServerObj.GetItemCongeriesToListMethod, OrdCongeriesJson,BaseParamJson,ItemOrdsJson);
		var ItemCongeriesObj=eval("("+ItemCongeries+")");
		for (var i=0,Length=ItemCongeriesObj.length;i<Length;i++) {
			var ItemToListDetailObj=ItemCongeriesObj[i];
			if ($.isEmptyObject(ItemToListDetailObj)) {
				continue;
			}
			var CheckBeforeAddObj=CheckItemCongeries(ItemToListDetailObj);
			if ((CheckBeforeAddObj.SuccessFlag==true)&&($.isEmptyObject(ItemToListDetailObj.OrdListInfo)==false)){
				NeedAddItemCongeriesObj[NeedAddItemCongeriesObj.length]=ItemToListDetailObj.OrdListInfo;
			}
		}
		return NeedAddItemCongeriesObj;
	}
	function GetItemOrds(){
		var ItemOrdsObj={
			Length:0,
			ItemOrds:[]	//�ж��󼯺�
		}
		var rows = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
		for (var i = 0; i < rows.length; i++) {
			var OrderRowID = rows[i]["OrderRowID"];
			if (OrderRowID!="") continue;
			var OrderItemRowid = rows[i]["OrderItemRowid"];
			var OrderARCIMRowid = rows[i]["OrderARCIMRowid"];
			if (OrderARCIMRowid=="") continue;
			var OrderSeqNo = rows[i]["id"];
			var OrderMasterSeqNo = rows[i]["OrderMasterSeqNo"];
			var OrderPriorRowid = rows[i]["OrderPriorRowid"];
			var OrderMaterialBarcode= rows[i]["OrderMaterialBarcodeHiden"];
			var ItemOrd={
				OrderItemRowid:'',
				OrderARCIMRowid:OrderARCIMRowid,
				rowid:rows[i]["rowid"],
				OrderSeqNo:OrderSeqNo,
				OrderMasterSeqNo:OrderMasterSeqNo,
				OrderPriorRowid:OrderPriorRowid,
				OrderMaterialBarcode:OrderMaterialBarcode
			};
			ItemOrdsObj.ItemOrds.push(ItemOrd);
			ItemOrdsObj.Length=ItemOrdsObj.Length+1;
		}
		var ItemOrdsJson=JSON.stringify(ItemOrdsObj);
		return ItemOrdsJson;
	}
}
///У���ܷ񽫸���ҽ����ӵ�����
function CheckItemCongeries(ItemToListDetailObj){
	var ErrCode=ItemToListDetailObj.ErrCode; //1
	var ErrMsg=ItemToListDetailObj.ErrMsg;	//2
	var CheckBeforeAddObj={
		SuccessFlag:true,				//�Ƿ���Ҫ�������ҽ��
		StartDateEnbale:true,
		UserOptionObj:new Array()
	}
	///�����ݻ�ȡ
	var ParamObj=ItemToListDetailObj.OrdListInfo;
	///ִ�лص�����
	var StartDateEnbale = true;
	var OrderInsurCatRowId="";
	var OrderInsurSignSymptom="";
	var OrderInsurSignSymptomCode="";
	var CallBakFunS=ItemToListDetailObj.CallBakFunS;
	if (typeof CallBakFunS=="object"){
		///�Ƚ����ж��Ƿ�����Ҫ�ݹ�ĺ���
		for (var i=0,length=CallBakFunS.length;i<length;i++){
			var CallBakFunCode=CallBakFunS[i].CallBakFunCode;
			var CallBakFunParams=CallBakFunS[i].CallBakFunParams;
			var UserOptionObj=ExeItemCongeriesUserOption(CallBakFunCode,CallBakFunParams);
			if (!$.isEmptyObject(UserOptionObj)){
				CheckBeforeAddObj.UserOptionObj.push(UserOptionObj);
			}
		}
		if (CheckBeforeAddObj.UserOptionObj.length>0){
			return CheckBeforeAddObj;
		}
		///�ٽ����ж��Ƿ���Ҫ����������ͨ�ĺ���
		for (var i=0,length=CallBakFunS.length;i<length;i++){
			var CallBakFunCode=CallBakFunS[i].CallBakFunCode;
			var CallBakFunParams=CallBakFunS[i].CallBakFunParams;
			var ReturnObj=ExeItemCongeriesCallBackFun(CallBakFunCode,CallBakFunParams);
			if (ReturnObj.SuccessFlag==false){ //CheckedResult
				CheckBeforeAddObj.SuccessFlag=false;
				break;
			}
		}
	}
	if (CheckBeforeAddObj.SuccessFlag==false){
		return CheckBeforeAddObj;
	}
	if (ErrCode!="0"){
		dhcsys_alert(ErrMsg);
		$.extend(CheckBeforeAddObj, {SuccessFlag:false});
		return CheckBeforeAddObj;
	}
	$.extend(CheckBeforeAddObj, {StartDateEnbale:StartDateEnbale});
	return CheckBeforeAddObj;
	function ExeItemCongeriesUserOption(FunCode ,FunCodeParams){
		///-------
		//��������������̨��ѯ���������ڶԺ���������Ӱ���confirm���㣬
		//ÿ�ζ����ֵ���������Եĸ�ֵ������Ҫ�ں�̨�����м��϶�Ӧ�Ĵ���
		//UserOptionObӦ���ٰ��������̶�����{Type:"",Value:""},���ں�̨����ʶ��
		var UserOptionObj={};
		var ParamsArr=FunCodeParams.split(";");
	    switch(FunCode)
	    {
			default:
				break;
		}
		return UserOptionObj;
		
	}
	/*
	����additemtolist�����Ļص���ע�⣺
	Ϊ���ݿ���ҽ����¼��ģʽ���˷����в���ֱ�Ӷ������ݽ��в�������������ݲ�������ʹ�÷��ض��󣬲���ParamObj
	*/
	function ExeItemCongeriesCallBackFun(FunCode ,FunCodeParams){
		var ReturnObj={
			SuccessFlag:true,
			StartDateEnbale:true,
			//ҽ����Ӧ֢�漰�޸ĵ�����--
			OrderCoverMainIns:"",	//ҽ����ѡ
			OrderInsurCatRowId:"",
			CalPackQtyObj:{}
		}
		var ParamsArr=FunCodeParams.split(";");
		switch(FunCode)
	    {
			case "Alert":
				dhcsys_alert(ParamsArr.join(";"));
				break;
			case "Confirm" :
				ReturnObj.SuccessFlag=dhcsys_confirm(FunCodeParams, true);
				break;		
			default:
				break;
	    }
	    return ReturnObj;
	}
}

function AddItemDataToRow(ParamObj,RowDataObj){
	RowDataObj = SetRowDataObj(ParamObj.rowid, RowDataObj, ParamObj);
	PageLogicObj.m_ordlistDataGrid.datagrid("appendRow",RowDataObj);
	return true;
}
function SetRowDataObj(rowid, RowDataObj, ParamObj){
    var dataObj=$.extend(RowDataObj, ParamObj); //{index:rowid-1,row:RowDataObj}
    return dataObj;
}
function ClearSearch(){
	$("#searchItem").lookup('setText','');
}
//��¼������������ʹ�ô���
function DHCDocUseCount(ValueId, TableName) {
    var rtn = tkMakeServerCall("DHCDoc.Log.DHCDocCTUseCount", "Save", TableName, ValueId, session["LOGON.USERID"], "U", session["LOGON.USERID"])
}
function GetLogonLocByFlag() {
    var FindRecLocByLogonLoc=$("#FindByLogDep").checkbox("getValue")?"1":"0";
    var LogonDep = ""
    if (FindRecLocByLogonLoc == "1") { LogonDep = session['LOGON.CTLOCID'] }
    return LogonDep;
}
function LoadselPatKW(itemsArr){
	$("#selPatKW").keywords({
	    singleSelect:false,
	    labelCls:'red',
	    items:itemsArr,
	    onUnselect:function(v){
		    if (ServerObj.NotUnSelectPat!="Y") { //(GetMenuPara("AnaesthesiaID")=="")&&
		    	UnselPatKWClick(v);
		    }else{
			    $("#selPatKW").keywords('select',v.id);
			}
		}
	});
	ChgFindByLogDepCheckStatus();
}
function UnselPatKWClick(v){
	var amdId=v.id;
	var ItemArr=$("#selPatKW").keywords('options').items;
	var find=ItemArr.contains(v);
	if (find>=0){
		ItemArr.splice(ItemArr.contains(v),1); 
	}
	LoadselPatKW(ItemArr);
	if (parent.DataGridUnSelectRow) {
		parent.DataGridUnSelectRow(amdId);
	}
}
/// ѡ��/ȡ��ѡ����໼���б�ʱ,�ֲ�ˢ���Ҳಹ¼ҳ������� 
// adm ����ID type(Add ����ѡ�л���,Del ȡ��ѡ�л���,Ĭ��Add)
function xhrRefresh(obj){
	PageLogicObj.EplisodeID=obj.adm
	PageLogicObj.LinkedMasterOrderRowid=obj.LinkedMasterOrderRowid
	 
	var JsonData=tkMakeServerCall("web.DHCDocNurseBatchSupplementOrd","GetLinkMasterOrdList",PageLogicObj.LinkedMasterOrderRowid);
	var JsonData=eval("("+JsonData+")");
	if (JsonData.length>0){
		$("#selPatKW").html($g("��ҽ��:")+JsonData[0].OrdName+$g(",ҽ��ID")+JsonData[0].OrderId);
	}
	LoadOrdListData();
	//��"��ʾ�Ѳ�¼"���ڴ�,��ˢ���б�
	if ($("#tabSupplementedOrd").length>0){
		LoadSupplementedOrd();
	}
}
function LoadOrdListData(){
	$.q({
	    ClassName :"web.DHCDocNurseBatchSupplementOrd",
	    QueryName:"GetNurseBatchLinkOrder",
	    LinkedMasterOrderRowid:PageLogicObj.LinkedMasterOrderRowid,
	    EpisodeID:PageLogicObj.EplisodeID,
	    Pagerows:PageLogicObj.m_ordlistDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ordlistDataGrid.datagrid("uncheckAll");
		PageLogicObj.m_ordlistDataGrid.datagrid('loadData',GridData);
	}); 
	}
function UpdateselPatKWItem(obj,type){
	var ItemArr=$("#selPatKW").keywords('options').items;
	if (obj['adm']!="") {
		var newobj={"text":obj['patname'],id:obj['adm'],selected:true};
		var find=ItemArr.contains(newobj);
		if (find>=0){
			ItemArr.splice(ItemArr.contains(newobj),1); //��ɾ���ظ���
		}
	}
	var LinkedMasterOrderRowid=obj['LinkedMasterOrderRowid'];
	if (typeof LinkedMasterOrderRowid=="undefined") LinkedMasterOrderRowid=""
	if ((obj['type']=="Add")&&(obj['adm']!="")) {
		ItemArr.push({"text":obj['patname'],id:obj['adm'],LinkedMasterOrderRowid:LinkedMasterOrderRowid,selected:true});
	}
	LoadselPatKW(ItemArr);
	InitKWPopover();
}
Array.prototype.contains = function(obj) {
	 var i = this.length;
	 while (i--) {
	   if (this[i].id == obj.id) {
	      return i; // ���ص���� i ����Ԫ�ص������±꣬
	   }
	 }
	 return -1;
}
function GetCurr_time() {
    //ȡ��ǰ���ں�ʱ��(������)
    var CurrDateTime = tkMakeServerCall("web.DHCDocOrderCommon","GetCurrentDateTime", ServerObj.defaultDataCache, "1");
    var CurrDateTimeArr = CurrDateTime.split("^");
    var CurrDate = CurrDateTimeArr[0];
    var CurrTime = CurrDateTimeArr[1];
    var CurrDateTime = CurrDate + " " + CurrTime;
    return CurrDateTime;
}

function mPiece(s1, sep, n) {
    var delimArray = s1.split(sep);
    if ((n <= delimArray.length - 1) && (n >= 0)) return delimArray[n];
	return "";
}
function DeepCopyObject(source) { 
	var result={};
	for (var key in source) {
      result[key] = typeof source[key]==='object'?deepCoyp(source[key]): source[key];
   } 
   return result; 
}
function DelClickHandle(){
	var SelIds=[];
	var OrderID=[];
	var rows=PageLogicObj.m_ordlistDataGrid.datagrid("getSelections");
	for (var i=0;i<rows.length;i++){
		SelIds[i]=rows[i]['id'];
		OrderID[i]=rows[i]['OrderRowID'];
		
	}
	SelIds.sort(function(a, b){ return a - b; });
	for (var i=SelIds.length-1;i>=0;i--){
		var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",SelIds[i]);
		var OrderID=PageLogicObj.m_ordlistDataGrid.datagrid('getData').rows[index]["OrderRowID"]
		
		
		if ((OrderID)&&(OrderID!="")){
			DelOrdItem(OrderID,SelIds[i])
		}else{
			PageLogicObj.m_ordlistDataGrid.datagrid("deleteRow",index);
			}
		
	}
	PageLogicObj.m_ordlistDataGrid.datagrid("unselectAll");
	SetScreenSum();
	return ;
	var delCount=0;
	
	var OrderSeqNoArr=new Array();
	var rowids = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	for (var i=0;i<rowids.length;i++) {
		var id=parseInt(rowids[i].id);
		delCount=0;
		for (var j=0;j<SelIds.length;j++){
			if (id > parseInt(SelIds[j])){
				delCount++;
			}
		}
		//if ( id < parseInt(SelIds[SelIds.length-1])) continue;
		var rowid=parseInt(rowids[i].rowid);
		var curRowData=rowids[i];
		var curIndex=i; //PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
		var newId=id-delCount;
		curRowData["id"]=newId;
		curRowData["rowid"]=newId;
		var OrderMasterSeqNo=curRowData["OrderMasterSeqNo"];
		if (OrderMasterSeqNo) {
			curRowData["OrderMasterSeqNo"]=OrderSeqNoArr[OrderMasterSeqNo];
		}else{
			OrderSeqNoArr[rowid]=newId;
		}
		var editors = PageLogicObj.m_ordlistDataGrid.datagrid('getEditors', curIndex);
		if (editors.length>0){
			curRowData['OrderPackQty']=editors[0].target.val();
			curRowData['OrderPrice']=editors[1].target.val();
			curRowData['OrderSum']=editors[2].target.val();
		}
		PageLogicObj.m_ordlistDataGrid.datagrid('getData').rows[i] = curRowData;
		PageLogicObj.m_ordlistDataGrid.datagrid('refreshRow', i);
		if (editors.length>0){
			//�����ε����ӿ��ٶ�
			SetBeginEdit(newId);
		}
	}
	SetScreenSum();
}
function DelOrdItem(OEOrdItem,ID){
	var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",ID);
	var rows=PageLogicObj.m_ordlistDataGrid.datagrid('getRows');

	var rtn=MulOrdDealWithComDe(OEOrdItem)
	
	var rytneAry=rtn.split("^")
	if (rytneAry[0]!=0){
		
	}else{
		if (index>=0){
			PageLogicObj.m_ordlistDataGrid.datagrid("deleteRow",index);	
			SetScreenSum();
		}
	}
}
function MulOrdDealWithComDe(OEOrdItem){
	//OrderItemStr As %String, date As %String, time As %String, type As %String, ExpStr
	var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID'];
	var OrderAuth=tkMakeServerCall("web.DHCDocNurseBatchSupplementOrd","GetDealWithType",OEOrdItem,GetSessionStr());
	var OrderAuthAry=OrderAuth.split("^")
	//����ִ������
	if (OrderAuthAry[0]!=="0"){
		$.messager.alert("����ʧ��", OrderAuth);
		return OrderAuth
	}
	var type=OrderAuthAry[1];
	var SelOrdRowStr=OEOrdItem;
	var date="",time="";
	var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID'];
	var rtn=$.m({
		ClassName:"web.DHCDocInPatPortalCommon",
		MethodName:"MulOrdDealWithCom",
		OrderItemStr:SelOrdRowStr,
		date:"",
		time:"",
		type:type,
		pinNum:"",
		PWFlag:"N",
		ExpStr:ExpStr
	},false)
	var rytneAry=rtn.split("^")
	if (rytneAry[0]!=0){
		$.messager.alert("����ʧ��", rytneAry[0]);
	}else{
		$.messager.popover({msg: '����ɹ���',type:'success'});
	}
	return rtn;
}
function SetBeginEdit(rowid){
	var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
    PageLogicObj.m_ordlistDataGrid.datagrid("beginEdit",index);
    var rows=PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	var OrderARCIMRowid=rows[index]["OrderARCIMRowid"];
	var OrderItemCongeriesJson = rows[index]["OrderItemCongeries"];
	if (OrderItemCongeriesJson!=""){
		//����ҽ��,����/���۲��ɱ༭
		var OrderPackQtyObj=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor', {index:index,field:'OrderPackQty'});
		$(OrderPackQtyObj.target[0]).addClass('disabled')
		OrderPackQtyObj.target[0].disabled=true;
	}
	if (rows[index]['OrderType']!="P"){
		//�Զ���۸�ҽ��,���ۿɱ༭
		var OrderPriceObj=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor', {index:index,field:'OrderPrice'});
		$(OrderPriceObj.target[0]).addClass('disabled')
		OrderPriceObj.target[0].disabled=true;
	}
	var OrderSumObj=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor', {index:index,field:'OrderSum'});
	$(OrderSumObj.target[0]).addClass('disabled')
	OrderSumObj.target[0].disabled=true;
	
	if ((OrderARCIMRowid!="")||(OrderItemCongeriesJson!="")) {
		var OrderRecDepObj=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor', {index:index,field:'OrderRecDep'});
		$(OrderRecDepObj.target).combobox('loadData',GetColumnList("OrderRecDep",rows[index]["OrderRecLocStr"],rows[index].OrderRecDepRowid));
		var OrderOperationObj=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor', {index:index,field:'OrderOperation'});
		$(OrderOperationObj.target).combobox('loadData',GetColumnList("OrderOperation",rows[index]["OrderOperationStr"],rows[index].OrderRecDepRowid));
	}	
	if (rows[index].OrderMasterSeqNo!="") {
		$(OrderRecDepObj.target).combobox('disable');
		$(OrderOperationObj.target).combobox('disable');
	}
	GridBindEnterEvent(rowid);
}
function GetColumnList(ColumnName, str, defaultId){
	var dataArr=[];
	if (ColumnName == "OrderRecDep") {
		var DefaultRecLocRowid = "";
	    var ArrData = str.split(String.fromCharCode(2));
	    for (var i = 0; i < ArrData.length; i++) {
		    var selected=false;
	        var ArrData1 = ArrData[i].split(String.fromCharCode(1));
	        if (defaultId!="") {
		        if (ArrData1[0]==defaultId){
		            var DefaultRecLocRowid = ArrData1[0];
		            selected=true;
		        }
	        }else{
		        if (((ArrData1[2] == "Y") && (DefaultRecLocRowid == "")) || (ArrData.length == 1)) {
		            var DefaultRecLocRowid = ArrData1[0];
		            selected=true;
		        }
		    }
	        dataArr[dataArr.length]={"id":ArrData1[0],"text":ArrData1[1],"selected":selected};
	    }
	}
	//�����б� 
	if (ColumnName=="OrderOperation"){
	   if ((str==false)||(str=="")) return dataArr;
	   var ArrData=str.split("^");
	   for (var i=0;i<ArrData.length;i++) {
		   var ArrData1=ArrData[i].split(String.fromCharCode(1));
	       dataArr[dataArr.length]={"id":ArrData1[1],"text":ArrData1[0]};
	   }
	}
	return dataArr;
}
//�����༭�����ӻس��¼�
function GridBindEnterEvent(rowid){
	var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
	var rows=PageLogicObj.m_ordlistDataGrid.datagrid('getRows');
	var editors = PageLogicObj.m_ordlistDataGrid.datagrid('getEditors', index);
	///����
	var OrderPackQtyEditor = editors[0];
	OrderPackQtyEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
			var ed=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor',{index:index, field:'OrderPackQty'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var rows=PageLogicObj.m_ordlistDataGrid.datagrid('getRows');
			for (var i=parseInt(index)+1;i<rows.length;i++){
				var Nexteditors = PageLogicObj.m_ordlistDataGrid.datagrid('getEditors', i);
				var NextOrderPriceEditor= Nexteditors[0];
				NextOrderPriceEditor.target.focus().select();  ///���ý��㲢ѡ��
				break;
			}
		}
	});
	var ed=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor',{index:index, field:'OrderPackQty'});
	ed.target.change(function (e) {
		var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
		var qty=e.target.value;
		var OrderPrice=editors[1].target.val();
		OrderSum=(qty*OrderPrice).toFixed(4);
		rows[index]['OrderSum']=OrderSum;
		var obj=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor',{index:index, field:'OrderSum'});
		obj.target[0].value=OrderSum;
		SetScreenSum();
	});
	 
	//����
	var OrderPriceEditor = editors[1];
	OrderPriceEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
			var ed=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor',{index:index, field:'OrderPrice'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var rows=PageLogicObj.m_ordlistDataGrid.datagrid('getRows');
			for (var i=parseInt(index)+1;i<rows.length;i++){
				if (rows[i]['OrderType']=="P"){
					var Nexteditors = PageLogicObj.m_ordlistDataGrid.datagrid('getEditors', i);
					var NextOrderPriceEditor= Nexteditors[1];
					NextOrderPriceEditor.target.focus().select();  ///���ý��㲢ѡ��
					break;
				}
			}
		}
	});
	var ed=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor',{index:index, field:'OrderPrice'});
	ed.target.change(function (e) {
		var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
		var OrderPrice=e.target.value;
		var qty=editors[0].target.val();
		OrderSum=(qty*OrderPrice).toFixed(4);
		rows[index]['OrderSum']=OrderSum;
		var obj=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor',{index:index, field:'OrderSum'});
		obj.target[0].value=OrderSum;
	});
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class=''></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    if(_btntext==""){
		   var buttons="" 
	   }else{
		   if ($.isArray(_btntext)) {
			   var buttons=_btntext;
		   }else {
			   var buttons=[{
					text:_btntext,
					iconCls:_icon,
					handler:function(){
						if(_event!="") eval(_event);
					}
				}]
		  }
	}
    var collapsed=false,collapsible=false;
    var left=null,closable=true;
    $("#"+id).dialog({
	    zIndex:99999,
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        collapsible: collapsible,
        minimizable:false,
        maximizable: false,
        collapsed:collapsed,
        modal: false,
        closed: false,
        closable: closable,
        content:_content,
        buttons:buttons,
        inline:true,
        resizable:false,
        isTopZindex:true,
        left:left,
	    onBeforeOpen:function(){
		    if ((_btntext=="")||($.isArray(_btntext))) {
			    if (_event!="") eval(_event);
			}
		    return true;
		}
    });
}
function destroyDialog(id){
   //�Ƴ����ڵ�Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
function DocumentUnloadHandler(e) {
    /*if (GetMenuPara("AnaesthesiaID")!="") {
		ClearSessionData();
		return;
	}
    */
	var AdmStr=GetSelPatKW();
    //���ҽ������ɹ��Ͳ��ñ�����session��(����)
    ClearSessionData();
    //δ��˵�ҽ��
    var rows = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
    //�����ַ���
    var UnsaveData = ""
    var UserID = session['LOGON.USERID'];
    var CTLocId = session['LOGON.CTLOCID'];
    var SaveCount = 0;
    for (var i = 0; i < rows.length; i++) {
	    var editors = PageLogicObj.m_ordlistDataGrid.datagrid('getEditors', i);
	    if (editors.length>0){
		    rows[i]["OrderPackQty"]=editors[0].target.val();
		    if (editors.length>1) {
			    rows[i]["OrderPrice"]=editors[1].target.val();
			}
		}
		var OrderRowID = rows[i]["OrderRowID"];
	    if ((OrderRowID)&&(OrderRowID!="")) continue;
        var oneData = JSON.stringify(rows[i]);
        if (UnsaveData == "") {
            UnsaveData = oneData;
        } else {
            UnsaveData = UnsaveData + "###" + oneData;
        }
        //����25����¼,��ֿ��洢
        if ((i + 1) % 5 == 0) {
            SaveCount = SaveCount + 1;
            var retDetail = cspRunServerMethod(ServerObj.SetUserUnSaveDataMethod, UserID, CTLocId, SaveCount, UnsaveData,AdmStr);
            UnsaveData = "";
        }
    }
    if ((UnsaveData != "")||(AdmStr!="")) {
        SaveCount = SaveCount + 1;
        var retDetail = cspRunServerMethod(ServerObj.SetUserUnSaveDataMethod,UserID, CTLocId, SaveCount, UnsaveData,AdmStr);
    }
}
//���session����
function ClearSessionData(AdmStr) {
    var UserID = session['LOGON.USERID'];
    var CTLocId = session['LOGON.CTLOCID'];
    var UnSaveCount = cspRunServerMethod(ServerObj.GetUserUnSaveCountMethod,UserID, CTLocId);
    for (var i = 1; i <= parseInt(UnSaveCount); i++) {
        var ret = cspRunServerMethod(ServerObj.SetUserUnSaveDataMethod,UserID, CTLocId, i, "","");
    }
    //���������
    //tkMakeServerCall("web.DHCDocOrderCommon","OrderEntryClearLock");
}
function GetSelPatKW(){
	return PageLogicObj.EplisodeID;
	var AdmStr="";
	var ItemArr=$("#selPatKW").keywords('options').items;
	for (var i=0;i<ItemArr.length;i++){
		var adm=ItemArr[i]['id'];
		if (AdmStr=="") AdmStr=adm;
		else  AdmStr=AdmStr+"!"+adm;
	}
	return AdmStr.toString();
}
function SwitchNewSelPat(adm,OEOrdItemID){
	var EpisPatInfo=tkMakeServerCall("web.DHCDocNurseBatchSupplementOrd","InitPatOrderViewGlobal","","",adm);
	$.extend(ServerObj, { EpisPatInfo: EpisPatInfo});
	var EpisPatInfoArr=eval("("+ServerObj.EpisPatInfo+")");
	xhrRefresh({adm: EpisPatInfoArr[0].id, patname: EpisPatInfoArr[0].text, LinkedMasterOrderRowid: OEOrdItemID, type: ""});
	
	
	}
function GetSelPat(){
	var AdmStr="";
	var ItemArr=$("#selPatKW").keywords('options').items;
	for (var i=0;i<ItemArr.length;i++){
		var adm=ItemArr[i]['id'];
		var LinkedMasterOrderRowid=ItemArr[i]['LinkedMasterOrderRowid'];
		if (typeof LinkedMasterOrderRowid=="undefined"){LinkedMasterOrderRowid="";}
		if (AdmStr=="") AdmStr=adm+String.fromCharCode(1)+LinkedMasterOrderRowid;
		else  AdmStr=AdmStr+"!"+adm+String.fromCharCode(1)+LinkedMasterOrderRowid;
	}
	return AdmStr;
}
function GetSessionData(){
	var AdmStr="";
	var UnSaveDataArr=new Array();
	//��ȡsession���� 
    var UserID = session['LOGON.USERID'];
    var CTLocId = session['LOGON.CTLOCID'];
    var UnSaveCount = cspRunServerMethod(ServerObj.GetUserUnSaveCountMethod, UserID, CTLocId);
    for (var i = 1; i <= parseInt(UnSaveCount); i++) {
        var UserUnSaveDataStr = cspRunServerMethod(ServerObj.GetUserUnSaveDataMethod, UserID, CTLocId, i);
        if (UserUnSaveDataStr == "") { continue; }
        var UserUnSaveData=UserUnSaveDataStr.split("^")[0];
        var AdmStr=UserUnSaveDataStr.split("^")[3];
        if ((ServerObj.NotUnSelectPat=="Y")&&(AdmStr!=GetMenuPara("EpisodeID"))) AdmStr="",UserUnSaveData="";
        if (UserUnSaveData =="" ) { continue; }
        if (UserUnSaveData.split('@').length == 2) {
            if (UserUnSaveData.split('@')[1] == "%CSP.CharacterStream") {
                $.messager.alert("��ʾ", "��һ��ҳ��δ��������ؼ�¼���������ֵ,�����Զ���ȡ.");
                continue;
            }
        }
        var DataArry = UserUnSaveData.split("###");
        for (var j = 0; j < DataArry.length; j++) {
            var data = DataArry[j];
            var obj = {};
            if (data != "") {
                obj = eval("(" + data + ")");
            }
            UnSaveDataArr.push(obj);
            //AddItemDataToRow(obj,{});
            //SetBeginEdit(obj['id']);
        }
    }
    
    if (AdmStr!=""){
	    for (var i=0;i<AdmStr.split("!").length;i++){
		    var admInfo=AdmStr.split("!")[i];
		    var admId=admInfo.split(String.fromCharCode(1))[0];
		    var LinkedMasterOrderRowid=admInfo.split(String.fromCharCode(1))[1];
		    if (typeof LinkedMasterOrderRowid=="undefined"){LinkedMasterOrderRowid="";}
			if (((parent.DataGridSelectRow)&&(!parent.DataGridSelectRow(admId)))||(ServerObj.NotUnSelectPat=="Y")){
				var patname=tkMakeServerCall("web.DHCDocNurseBatchSupplementOrd", "GetPatNameByAdm",admId);
				var objParam = {adm: admId, patname: patname,LinkedMasterOrderRowid:LinkedMasterOrderRowid, type: "Add"};
				xhrRefresh(objParam);
			}
		}
	}
	var EpisPatInfoArr=eval("("+ServerObj.EpisPatInfo+")");
	if ((PageLogicObj.AnaesthesiaID!="")&&(EpisPatInfoArr.length==0)) {
		var EpisPatInfo=tkMakeServerCall("web.DHCDocNurseBatchSupplementOrd","InitPatOrderViewGlobal","","",GetMenuPara("EpisodeID"));
		$.extend(ServerObj, { EpisPatInfo: EpisPatInfo});
		var EpisPatInfoArr=eval("("+ServerObj.EpisPatInfo+")");
	}
	for (var i=0;i<EpisPatInfoArr.length;i++) {
		xhrRefresh({adm: EpisPatInfoArr[i].id, patname: EpisPatInfoArr[i].text, LinkedMasterOrderRowid: EpisPatInfoArr[i].LinkedMasterOrderRowid, type: "Add"});
	}
	for (var i=0;i<UnSaveDataArr.length;i++){
		AddItemDataToRow(UnSaveDataArr[i],{});
	}
	if (EpisPatInfoArr.length>0) {
		if (typeof(history.pushState) === 'function') {
	        //��ֹ�Ҽ�ˢ�º�ҽ���ظ�����
	        var Url=window.location.href;
	        var NewUrl=rewriteUrl(Url, {EpisodeID:"",OEOrdItemIDs:"",OEOrdItemID:""});
	        history.pushState("", "", NewUrl);
	    }
    }
    //SetScreenSum();
}
function UpdateClickHandler(){
	var AdmStr=PageLogicObj.EplisodeID;
	if (AdmStr=="") {
		//$.messager.alert("��ʾ", "���ȹ�ѡ��Ҫ����������¼�Ļ���!");
	    return websys_cancel();
	}
	var DataArry = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	if (DataArry.length==0) {
		//$.messager.alert("��ʾ", "û����Ҫ���������!");
	    return websys_cancel();
	}
	var OrderItemStr = GetOrderDataOnAdd();
    if (OrderItemStr == "") {
	    //$.messager.alert("��ʾ", "û����Ҫ���������!");
	    return websys_cancel();
    }
    var patname=tkMakeServerCall("web.DHCDocNurseBatchSupplementOrd", "GetPatNameByAdm",PageLogicObj.EplisodeID);
 	var ret = CheckBeforeSaveToServer(PageLogicObj.EplisodeID,patname,OrderItemStr);
    if (ret.SuccessFlag == false) {
        return websys_cancel();
    }
    if (ret.isAfterCheckLoadDataFlag== true){
		var OrderItemStr = GetOrderDataOnAdd();
    	if (OrderItemStr == "") {
		    $.messager.alert("��ʾ", "û����Ҫ���������!");
		    return websys_cancel();
	    }
    }
    
	var ExpStr = "N^^";
	var SUCCESS=InsertOrderItem(PageLogicObj.EplisodeID,OrderItemStr, ExpStr);
	//��˳ɹ���ˢ��ҽ����
    if (SUCCESS == true) {
	    $.messager.popover({msg: '����ɹ���',type:'success'});
	    ClearData();
	    LoadOrdListData();
	}
}
function InsertOrderItem(AdmStr,OrderItemStr, ExpStr) {
	var SUCCESS = false;
	//var ItemArr=$("#selPatKW").keywords('options').items;
    var UserAddRowid = "";
    var UserAddDepRowid = "";
    UserAddRowid = session['LOGON.USERID'];
    UserAddDepRowid = session['LOGON.CTLOCID'];
    var DoctorRowid = GetEntryDoctorId();
    var ExpStr=1;
    var ret = cspRunServerMethod(ServerObj.InsertContinuousOrder, AdmStr, OrderItemStr, UserAddRowid, UserAddDepRowid, DoctorRowid, ExpStr);
    if (ret != "0") {
        $.messager.alert("��ʾ","ҽ������ʧ��!"+ret);
        return websys_cancel();
    }else{
	    SUCCESS = true;
	}
    return SUCCESS;
}
function CheckBeforeSaveToServer(EpisodeID,PatName,OrderItemStr) {
    var UserAddRowid = session['LOGON.USERID'];
    var UserAddDepRowid = session['LOGON.CTLOCID'];
    var DoctorRowid = GetEntryDoctorId();
    var LogonDep = GetLogonLocByFlag();
    var OrderOpenForAllHosp = 0,PPRowId="";
    var ExpStr = PPRowId +"^"+LogonDep+"^"+OrderOpenForAllHosp;
    var ret = cspRunServerMethod(ServerObj.CheckBeforeSaveMethod, EpisodeID, OrderItemStr, UserAddRowid, UserAddDepRowid, DoctorRowid, ExpStr,1)
    var CheckResultObj=jQuery.parseJSON(ret);
    
	var ErrCode=CheckResultObj.ErrCode; //1
	var ErrMsg=CheckResultObj.ErrMsg;	//2
    var ErrRowID=CheckResultObj.OrdRowIndex;	//3
    var FocusCol=CheckResultObj.FocusCol;//4
    var NeedCheckDeposit=CheckResultObj.NeedCheckDeposit;//4
	var CheckBeforeSaveObj={
		StopConflictFlag:"0",			//�Ƿ���Ҫ�Զ�ֹͣ����ҽ��
		isAfterCheckLoadDataFlag:false,	//ǰ̨�Ƿ���Ҫ��������
		SuccessFlag:true				//�Ƿ���Ҫ�������ҽ��
	}
	//ִ�лص�����
	var CallBakFunS=CheckResultObj.CallBakFunS;
	if (typeof CallBakFunS=="object"){
		for (var i=0,length=CallBakFunS.length;i<length;i++){
			var CallBakFunCode=CallBakFunS[i].CallBakFunCode;
			var CallBakFunParams=CallBakFunS[i].CallBakFunParams;
			var ReturnObj=CheckAfterCheckMethod(CallBakFunCode,CallBakFunParams,ErrRowID);
			if (ReturnObj.isAfterCheckLoadDataFlag){
				CheckBeforeSaveObj.isAfterCheckLoadDataFlag=true;
			}
			if (ReturnObj.SuccessFlag==false){
				CheckBeforeSaveObj.SuccessFlag=false;
				break;
			}
			if (ReturnObj.StopConflictFlag=="1"){
				CheckBeforeSaveObj.StopConflictFlag="1";
				break;
			}
		}
	}
    if (ErrMsg!=""){
	    if ((ErrRowID!="")&&(FocusCol!="")){
			$.messager.alert("����", "���ߡ�"+PatName+"��"+ ErrMsg, "warning", function() {
				SetFocusCell(ErrRowID, FocusCol);
		    });
		}else{
			$.messager.alert("����","���ߡ�"+PatName+"��"+ ErrMsg);
		}
    }
	if ((parseInt(ErrCode)<0)){
		CheckBeforeSaveObj.SuccessFlag=false;
	}
	/*if (NeedCheckDeposit) {
        var amount = 0;
        var obj_ScreenBillSum = document.getElementById('ScreenBillSum');
        if (obj_ScreenBillSum) { amount = obj_ScreenBillSum.value; }
        if (!CheckDeposit(amount, "")) {
            CheckBeforeSaveObj.SuccessFlag=false;
        }
    }*/
	return CheckBeforeSaveObj;
}
function CheckAfterCheckMethod(FunCode ,FunCodeParams,Row){
	var ReturnObj={
		StopConflictFlag:"0",
		isAfterCheckLoadDataFlag:false,
		SuccessFlag:true
	}
	var ParamsArr=FunCodeParams.split(",");
    switch(FunCode)
    {
		case"SetPageLogicFocusRow": 
			PageLogicObj.FocusRowIndex = Row;
			break;
		case "Confirm" :
			ReturnObj.SuccessFlag=dhcsys_confirm(FunCodeParams, true);
			break;
		case "ReSetMasterSeqNo" :
			SetCellData(Row, "OrderMasterSeqNo", "");
			PageLogicObj.LinkedMasterOrderRowid="";
			ReturnObj.isAfterCheckLoadDataFlag=true;
			break;
		case "AddRemarkClickhandler" :
			ReturnObj.SuccessFlag=AddRemarkClickhandler(ParamsArr[0]); //Row
			ReturnObj.isAfterCheckLoadDataFlag=true;
			break;
		case "NeedInputOrderPrice" :
			EditRow(Row);
            $.messager.alert("��ʾ��Ϣ", OrderName + t['NO_OrderPrice'], "warning", function() { SetFocusCell(Row, "OrderPrice"); });
            var StyleConfigObj = { OrderPrice: true };
            ChangeRowStyle(Row, StyleConfigObj)
            PageLogicObj.FocusRowIndex = Row;
            ReturnObj.SuccessFlag=false;
			break;
		case "EmptyPackQty" :
			SetCellData(Row, "OrderPackQty", "");
            ReturnObj.SuccessFlag=true;
			break;
		case "StopConflict" :
			var StopConflictItems = dhcsys_confirm("�������»���ҽ����" + ParamsArr + " ��ȷ���Ƿ��Զ�ֹͣ����ҽ��");
			if (StopConflictItems) ReturnObj.StopConflictFlag = "1";
			break;
		case "CheckPatCount":
			var AdmStr=GetSelPatKW();
			ReturnObj.SuccessFlag=true;
			/*if ((AdmStr!="")&&(AdmStr.split("!").length>1)){
				$.messager.alert("��ʾ", "��ֵ���� "+ParamsArr[0]+"ֻ��һ��ʹ��!");
				ReturnObj.SuccessFlag=false;
			}else{
				ReturnObj.SuccessFlag=true;
			}*/
			break;
		case "Alert":
			$.messager.alert("��ʾ",ParamsArr,"info",function(){});
			break;
		default:
			break;
	}
    return ReturnObj;

}
function GetEntryDoctorId() {
    var DoctorRowid = "";
    //�����½��Ϊҽ��?�ͼ���ҽ��?�����½��Ϊ��ʿ?����ҽ��¼��?���Ǽ���ҽ��
    //�����½��Ϊ��ʿ?����û��ѡ��ҽ��?�ͼ��뻤ʿ
    if (ServerObj.LogonDoctorType == "DOCTOR") {
        DoctorRowid = ServerObj.LogonDoctorID;
    } else {
        var obj = document.getElementById('DoctorID');
        if (obj) DoctorRowid = obj.value;
        if (DoctorRowid == "") { DoctorRowid = ServerObj.LogonDoctorID; }
    }
    return DoctorRowid;
}
//��ȡ¼��ҽ����Ϣ ��֯�ύ�ַ���
function GetOrderDataOnAdd() {
    var OrderItemStr = "";
    var OrderItem = "";
    var OneOrderItem = "";
	//����ҽ�����а�����ҽ������
	var OrderItemCongeriesNum=0;
	var Count=0;
	var Currtime = GetCurr_time();
    //try {
	    var DataArry = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
        for (var i = 0; i < DataArry.length; i++) {
	        var OrderRowID = DataArry[i]["OrderRowID"];
	        if ((OrderRowID)&&(OrderRowID!="")) continue;
	        var editors = PageLogicObj.m_ordlistDataGrid.datagrid('getEditors', i);
	        var editLen=editors.length;
            var OrderItemRowid = DataArry[i]["OrderItemRowid"];
            var OrderARCIMRowid = DataArry[i]["OrderARCIMRowid"];
			var OrderARCOSRowid = DataArry[i]["OrderARCOSRowid"];
            if ((OrderARCIMRowid == "")&&(OrderARCOSRowid=="")) { continue; }
			//ԭ���  ����ID
            var OrderSeqNo = DataArry[i]["id"];
			var OrderItemCongeriesJson = DataArry[i]["OrderItemCongeries"];
			var AnaesthesiaID = DataArry[i]["AnaesthesiaID"]
			var OrderOperationCode=DataArry[i]["OrderOperationCode"]
			if (OrderItemCongeriesJson!=""){
				var OrderItemObj=GetOrderItemByItemCongeries(OrderSeqNo,OrderItemCongeriesJson,Count,AnaesthesiaID,OrderOperationCode);
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
				Count=Count+OrderItemCongeriesNum;
				continue;
			}
			Count=Count+1;
			if (parseFloat(OrderItemCongeriesNum)>0){
				OrderSeqNo=parseFloat(OrderItemCongeriesNum)+OrderSeqNo;
			}
			
            var OrderName = DataArry[i]["OrderName"];
            var OrderType = DataArry[i]["OrderType"];
            var OrderPriorRowid = DataArry[i]["OrderPriorRowid"];
            var OrderRecDepRowid = DataArry[i]["OrderRecDepRowid"];
            var OrderFreqRowid = DataArry[i]["OrderFreqRowid"];
            var OrderDurRowid = DataArry[i]["OrderDurRowid"];
            var OrderInstrRowid = DataArry[i]["OrderInstrRowid"];
            var OrderDoseQty = DataArry[i]["OrderDoseQty"];
            var OrderDoseUOMRowid = DataArry[i]["OrderDoseUOMRowid"];
            var OrderPackQty = DataArry[i]["OrderPackQty"];
            if (editLen>0) {
	            OrderPackQty= editors[0].target.val();
	        }
            var OrderPrice = DataArry[i]["OrderPrice"];
            if (editLen>0) {
	            OrderPrice= editors[1].target.val();
	        }
            var PHPrescType = DataArry[i]["OrderPHPrescType"];
            var BillTypeRowid = DataArry[i]["OrderBillTypeRowid"];
            var OrderSkinTest = DataArry[i]["OrderSkinTest"];
            var OrderARCOSRowid = DataArry[i]["OrderARCOSRowid"];
            var OrderDrugFormRowid = DataArry[i]["OrderDrugFormRowid"];
            var OrderStartDateStr = Currtime; //DataArry[i]["OrderStartDate"];
            if (DataArry[i]["OrderStartDate"]!=""){var OrderStartDateStr =DataArry[i]["OrderStartDate"];}
            var OrderStartDate = "";
            var OrderStartTime = "";
            if (OrderStartDateStr != "") {
                OrderStartDate = OrderStartDateStr.split(" ")[0];
                OrderStartTime = OrderStartDateStr.split(" ")[1];
            }
            //����
            var OrderMasterSeqNo = DataArry[i]["OrderMasterSeqNo"];
			if ((parseFloat(OrderItemCongeriesNum)>0)&&(OrderMasterSeqNo!="")){
				OrderMasterSeqNo=parseFloat(OrderItemCongeriesNum)+OrderMasterSeqNo;
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
            var OrderMultiDate = "";
            var OrderNotifyClinician = "";
            var OrderDIACatRowId = DataArry[i]["OrderDIACatRowId"];
            //ҽ�����
            var OrderInsurCatRowId = DataArry[i]["OrderInsurCatRowId"];
            //ҽ�����մ���
            var OrderFirstDayTimes = DataArry[i]["OrderFirstDayTimes"];
            //ҽ����Ӧ֢
            var OrderInsurSignSymptomCode = "";
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
            var AnaesthesiaID = DataArry[i]["AnaesthesiaID"];
            var OrderLabEpisodeNo = DataArry[i]["OrderLabEpisodeNo"];
            var VerifiedOrderMasterRowid = "";
            //Ӫ��ҩ��־
            var OrderNutritionDrugFlag = ""; //DataArry[i]["OrderNutritionDrugFlag"];
            //��¼������ҽ����Ϣ 
            var LinkedMasterOrderRowid = PageLogicObj.LinkedMasterOrderRowid //DataArry[i]["LinkedMasterOrderRowid"];
            
            var LinkedMasterOrderSeqNo = DataArry[i]["LinkedMasterOrderSeqNo"];
            if ((LinkedMasterOrderSeqNo != "") && (OrderMasterSeqNo == "")) {
                OrderMasterSeqNo = DataArry[i]["LinkedMasterOrderSeqNo"];
            }
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
            var OrderDateStr = Currtime; //DataArry[i]["OrderDate"];
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
			var OrderQtySum=OrderPackQty;
            var OrderPriorRemarks = DataArry[i]["OrderPriorRemarksRowId"];
            //ҩ����Ŀ
            var OrderPilotProRowid = DataArry[i]["OrderPilotProRowid"];
            if (OrderDoseQty == "") { OrderDoseUOMRowid = "" }
            //��������ӱ��¼Id
            var ApplyArcId="";
            //��������ԤԼID
            var DCAARowId=""; //ServerObj.DCAARowId
            //�ٴ�֪ʶ�����id
            var OrderMonitorId=DataArry[i]["OrderMonitorId"];
            var OrderNurseLinkOrderRowid=PageLogicObj.LinkedMasterOrderRowid;;
			var OrderBodyPartLabel=DataArry[i]["OrderBodyPartLabel"];
			if (typeof OrderBodyPartLabel=="undefined"){OrderBodyPartLabel="";}
			var CelerType="N";	//����ҽ���ױ�ʶ
			var OrdRowIndex=DataArry[i]["id"];
			var OrderFreqWeekStr="";
	    	var OrderOpenForAllHosp=0;
	    	var OrderFreqTimeDoseStr=DataArry[i]["OrderFreqTimeDoseStr"];
	    	if (OrderFreqTimeDoseStr!="") OrderDoseQty="";
	    	var OrderNurseBatchAdd="Y";
	    	var OrderFreqExpInfo=CalOrderFreqExpInfo(OrderFreqDispTimeStr);
			var OrderFreqWeekStr=mPiece(OrderFreqExpInfo, "^", 0);
			var OrderFreqFreeTimeStr=mPiece(OrderFreqExpInfo, "^", 1);
	    	///
	    	var OrderPracticePreRowid="" //OrderHiddenPara.split(String.fromCharCode(1))[19];
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
            
            OrderItem = OrderItem + "^" + OrderFreqTimeDoseStr + "^" + OrderNurseBatchAdd+"^" +""+"^"+""+"^"+""+"^^^^"+""+"^"+""+"^"+"";
			OrderItem = OrderItem + "^" + "" + "^" + "" + "^" + OrderFreqFreeTimeStr+"^"+"" +"^"+ "";
			OrderItem = OrderItem + "^" + ""+ "^" + ""+ "^" + "" + "^" + "" ;
		    if (OrderItemStr == "") { OrderItemStr = OrderItem } else { OrderItemStr = OrderItemStr + String.fromCharCode(1) + OrderItem }
        }
    //} catch (e) { $.messager.alert("����", e.message) }
    return OrderItemStr;
	function GetOrderItemByItemCongeries(Startid,OrderItemCongeriesJson,Count,AnaesthesiaID){
		var OrderItemCongeriesObj=eval("("+OrderItemCongeriesJson+")");
		var seqnoarr = new Array();
		var id=Count+1; //Startid;
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
		var OrderItemStr="";
		for (var j=0,Length=OrderItemCongeriesObj.length;j<Length;j++) {
			var OrderARCIMRowid=OrderItemCongeriesObj[j].OrderARCIMRowid;
			var OrderType=OrderItemCongeriesObj[j].OrderType;
			var OrderPriorRowid=OrderItemCongeriesObj[j].OrderPriorRowid;
			var OrderStartDateStr=Currtime; //OrderItemCongeriesObj[j].OrderStartDate;
			if (OrderItemCongeriesObj[j].OrderStartDate!="") {OrderStartDateStr=OrderItemCongeriesObj[j].OrderStartDate;}
			var OrderStartDate="",OrderStartTime="";
			if (OrderStartDateStr!=""){
				var OrderStartDate = OrderStartDateStr.split(" ")[0];
	            var OrderStartTime = OrderStartDateStr.split(" ")[1];
            }
			var OrderPackQty=OrderItemCongeriesObj[j].OrderPackQty;
            var OrderPrice=OrderItemCongeriesObj[j].OrderPrice;
			var OrderRecDepRowid=OrderItemCongeriesObj[j].OrderRecDepRowid;
			var BillTypeRowid=OrderItemCongeriesObj[j].OrderBillTypeRowid;
			var OrderDrugFormRowid=OrderItemCongeriesObj[j].OrderDrugFormRowid;
			var OrderDepProcNote=OrderItemCongeriesObj[j].OrderDepProcNote;
			
			var OrderDoseQty=OrderItemCongeriesObj[j].OrderDoseQty;
			var OrderDoseUOMRowid=OrderItemCongeriesObj[j].OrderDoseUOMRowid;
			var OrderFreqFactor=OrderItemCongeriesObj[j].OrderFreqFactor;
			var OrderFreqInterval=OrderItemCongeriesObj[j].OrderFreqInterval;
			var OrderFreqDispTimeStr=OrderItemCongeriesObj[j].OrderFreqDispTimeStr;
			var OrderDurFactor=OrderItemCongeriesObj[j].OrderDurFactor;
			var OrderFirstDayTimes=OrderItemCongeriesObj[j].OrderFirstDayTimes;
			var OrderFreqRowid=OrderItemCongeriesObj[j].OrderFreqRowid;
			var OrderDurRowid=OrderItemCongeriesObj[j].OrderDurRowid;
			var OrderInstrRowid=OrderItemCongeriesObj[j].OrderInstrRowid;
			var OrderPHPrescType=OrderItemCongeriesObj[j].OrderPHPrescType;
			var OrderMasterSeqNo=OrderItemCongeriesObj[j].OrderMasterSeqNo;
			var OrderSeqNo=OrderItemCongeriesObj[j].id;
			var OrderSkinTest=OrderItemCongeriesObj[j].OrderSkinTest;
			var OrderPhSpecInstr = "";
			var OrderCoverMainIns = OrderItemCongeriesObj[j].OrderCoverMainIns;
			var OrderActionRowid=OrderItemCongeriesObj[j].OrderActionRowid;
			var OrderARCOSRowid=OrderItemCongeriesObj[j].OrderARCOSRowid;
			var OrderHiddenPara = OrderItemCongeriesObj[j].OrderHiddenPara;
			var OrderEndDate="",OrderEndTime="";
			var OrderLabSpecRowid=OrderItemCongeriesObj[j].OrderLabSpecRowid;
			var OrderMultiDate="";
			var OrderNotifyClinician=OrderItemCongeriesObj[j].Urgent;//�Ƿ�Ӽ�
			var OrderDIACatRowId=OrderItemCongeriesObj[j].OrderDIACatRowId;
			var OrderInsurCatRowId=OrderItemCongeriesObj[j].OrderInsurCatRowId;
			var OrderInsurSignSymptomCode="";
			var OrderStageCode = OrderItemCongeriesObj[j].OrderStageCode;
			var OrderSpeedFlowRate=OrderItemCongeriesObj[j].OrderSpeedFlowRate;
			var AnaesthesiaID =AnaesthesiaID //OrderItemCongeriesObj[j].AnaesthesiaID;
			var OrderLabEpisodeNo="";
			var LinkedMasterOrderRowid=OrderItemCongeriesObj[j].LinkedMasterOrderRowid;
			var OrderNutritionDrugFlag = "";
			var OrderMaterialBarCode="";
			var OrderCPWStepItemRowId=OrderItemCongeriesObj[j].OrderCPWStepItemRowId;
			var OrderInsurApproveType="";
			var OrderFlowRateUnitRowId=OrderItemCongeriesObj[j].OrderFlowRateUnitRowId;
			
			var OrderDate = "";
            var OrderTime = "";
            var OrderDateStr = Currtime; //OrderItemCongeriesObj[j].OrderDate;
            if (OrderDateStr != "") {
                OrderDate = OrderDateStr.split(" ")[0];
                OrderTime = OrderDateStr.split(" ")[1];
            }
			var OrderNeedPIVAFlag=OrderItemCongeriesObj[j].OrderNeedPIVAFlag;
			//****************������********************************/
			// ����ҩƷ����-TODO����ǰ����ҽ���׻���֧�ֿ�����
            var OrderAntibApplyRowid = "";
            //������ʹ��ԭ��
            var AntUseReason = "";
            //ʹ��Ŀ��
            var UserReasonId = OrderItemCongeriesObj[j].UserReasonId; //GetCellData(Startid, "UserReasonId");
            //************************************************/
			var OrderLocalInfusionQty="";//��Һ����           
			var OrderBySelfOMFlag=""; //�����Ա�
            var ExceedReasonID = "";//�����Ƴ�ԭ��
			var OrderPackUOMRowid=OrderItemCongeriesObj[j].OrderPackUOMRowid;
			//ҩ����Ŀ
            var OrderPilotProRowid = OrderItemCongeriesObj[j].OrderPilotProRowid; //GetCellData(Startid, "OrderPilotProRowid");
			var OrderOutsourcingFlag="N";	//�⹺
			var OrderItemRowid="";
            var ApplyArcId="";	//��������ӱ��¼Id
            var DCAARowId="";	// GlobalObj.DCAARowId ��������ԤԼID
			var OrderOperationCode=OrderOperationCode; //GetCellData(Startid, "OrderOperationCode");	//�����б�
            var OrderMonitorId="";	//�ٴ�֪ʶ�����id TODO:����ҽ����û�к��ٴ�֪ʶ��Խ�
            var OrderNurseLinkOrderRowid=PageLogicObj.LinkedMasterOrderRowid
			var OrderBodyPartLabel=OrderItemCongeriesObj[j].OrderBodyPartLabel;
			if (typeof OrderBodyPartLabel=="undefined"){OrderBodyPartLabel="";}
			var OrderFreqInfo=OrderFreqFactor+"^"+OrderFreqInterval+"^"+OrderFreqDispTimeStr;
			
			var OrderQtySum=OrderPackQty;
			var CelerType="Y";
			var OrdRowIndex=Startid;
			var OrderFreqWeekStr="",OrderOpenForAllHosp=0,OrderPracticePreRowid="",OrderFreqTimeDoseStr="",OrderNurseBatchAdd="Y";
			var OrderFreqExpInfo=CalOrderFreqExpInfo(OrderFreqDispTimeStr);
			var OrderFreqWeekStr=mPiece(OrderFreqExpInfo, "^", 0);
			var OrderFreqFreeTimeStr=mPiece(OrderFreqExpInfo, "^", 1);
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
            OrderItem = OrderItem + "^" + OrderMonitorId + "^" + OrderNurseLinkOrderRowid + "^" + OrderBodyPartLabel + "^" + CelerType + "^" + OrdRowIndex + "^" + OrderFreqWeekStr +"^"+ OrderOpenForAllHosp+"^"+OrderPracticePreRowid;
            OrderItem = OrderItem + "^" + OrderFreqTimeDoseStr + "^" + OrderNurseBatchAdd+"^" +""+"^"+""+"^"+""+"^^^^"+""+"^"+""+"^"+"";
			OrderItem = OrderItem + "^" + "" + "^" + "" + "^" + OrderFreqFreeTimeStr+"^"+"" +"^"+ "";
			OrderItem = OrderItem + "^" + ""+ "^" + ""+ "^" + "" + "^" + "" ;
            
            if (OrderItemStr == "") { OrderItemStr = OrderItem } else { OrderItemStr = OrderItemStr + String.fromCharCode(1) + OrderItem }
		}
		return {
			OrderItemStr:OrderItemStr,
			OrderItemCount:OrderItemCount
		};
		
	}
}
function SetFocusCell(ErrRowID, FocusCol){
	var index=ErrRowID-1;
    var rows=PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	
	var OrderItemCongeriesJson = rows[index]["OrderItemCongeries"];
	if (OrderItemCongeriesJson!=""){
		var ed=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor', {index:index,field:'OrderPackQty'});
		$(ed.target).focus().select();
	}
}
function ClearData(){
	ClearSessionData();
    ClearGridData();
    //ClearPatKW();
    //���������
    tkMakeServerCall("web.DHCDocOrderCommon","OrderEntryClearLock");
}
function ClearGridData(){
	PageLogicObj.m_ordlistDataGrid.datagrid("loadData",{'total':0,rows:[]});
	$("#ScreenBillSum").val("");
}
function ClearPatKW(){
	if (parent.DataGridUnSelectAll) {
		parent.DataGridUnSelectAll();
		$("#selPatKW").keywords('clearAllSelected');
		LoadselPatKW([]);
	}
}
function OrdLocChangeShow(that){
	$(that).popover('destroy');
	var rowid=that.id;
	var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
	var rows=PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	var data=rows[index];
	var OrderRecLocStr=data['OrderRecLocStr'];
	var innerHTML='<ul class="loclist">';;
	var Arr=data['OrderRecLocStr'].split(String.fromCharCode(2));
	for (var i=0;i<Arr.length;i++){
		var id=Arr[i].split(String.fromCharCode(1))[0];
		if (id==data['OrderRecDepRowid']) continue;
		var text=Arr[i].split(String.fromCharCode(1))[1];
		innerHTML+='<li>';
		innerHTML+='<a href="#" id="'+id+'" onclick="ChangeRowLoc(\''+rowid+'\',\''+Arr[i]+'\')">'+text+'</a>';
		innerHTML+='</li>';
	}
	innerHTML+='</ul>'; 
	$(that).popover({
		width:190,
		height:100,
		title:"��ѡ����Ҫ�л��Ľ��տ���",
		content:innerHTML,
		trigger:'hover',
		placement:'bottom'
	});
	$(that).popover('show');
}
function ChangeRowLoc(rowid,str){
	var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
	var rows=PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	var data=rows[index];
	var id=str.split(String.fromCharCode(1))[0];
	var text=str.split(String.fromCharCode(1))[1];
	data['OrderRecDepRowid']=id;
	data['OrderRecDep']=text;
	//������ʹ��updateRow �ᵼ�������쳣
	$("#"+rowid)[0].text=text;
}
function SortRowClick(type){
	var SelIds=[];
	var rows=PageLogicObj.m_ordlistDataGrid.datagrid("getSelections");
	for (var i=0;i<rows.length;i++){
		SelIds[i]=rows[i]['id'];
	}
	if (SelIds.length==0){
		return false;   
	}
	SelIds.sort(function(a, b){ return a - b; });
	var MinRowid=SelIds[0];
	var MaxRowid=SelIds[SelIds.length-1];
	var rowids = PageLogicObj.m_ordlistDataGrid.datagrid("getRows") //.slice(0);
	var EnableSort=true;
	var CheckStart=0;
	for (var i = 0; i<rowids.length; i++){
		var LoopIndex=$.inArray(rowids[i]['id'],SelIds);
		if (LoopIndex!=-1){
			CheckStart=1;
		}
		if ((CheckStart==1)&&(LoopIndex==-1)&&(SelIds[SelIds.length-1]>rowids[i]['id'])){
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
			if (parseInt(rowids[i]['id'])<parseInt(SelIds[0])){
				RecentlyRowid=rowids[i]['id'];
				break;
			}
		}
	}else{
		for (var i = 0; i <rowids.length; i++) {
			if (parseInt(rowids[i]['id'])>parseInt(SelIds[SelIds.length-1])){
				RecentlyRowid=rowids[i]['id'];
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
	var RecentlyIndex=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",RecentlyRowid);
	
	var RecentlyOrderMasterSeqNo=rowids[RecentlyIndex].OrderMasterSeqNo; 
	var RecentlyOrderSeqNo=RecentlyRowid;
	if (RecentlyOrderMasterSeqNo!=""){
		RecentlyOrderSeqNo=RecentlyOrderMasterSeqNo
	}
	var RecentlyLinkRowidList=GetSeqNolist(RecentlyRowid);
	if (RecentlyOrderMasterSeqNo==""){
		RecentlyLinkRowidList.push(RecentlyRowid);
	}
	RecentlyLinkRowidList.sort(function(a, b){ return a - b; });
	
	for (var i = 0; i < rowids.length; i++) {
        var OrderMasterSeqNo = rowids[i]['OrderMasterSeqNo']; 
        var OrderSeqNo = rowids[i]['id']; 
        var OrderItemRowid = rowids[i]['OrderItemRowid'];
        var OrderARCIMRowid = rowids[i]['OrderARCIMRowid']; 
        var OrderType = rowids[i]['OrderType'];
		
        if ((parseInt(rowids[i]['id'])>=parseInt(RecentlyLinkRowidList[0]))&&(parseInt(rowids[i]['id'])<=parseInt(RecentlyLinkRowidList[RecentlyLinkRowidList.length-1]))) {
			//�����ƶ�ʱ�����ƶ�������������ݲ���Ҫ����
			//��Ȼ����������ݲ���Ҫ���ģ���������������°벿�ֵ�ҽ����������е����ݵ�������Ҫ�����޸ģ���ӵ�NeedChangeMasterRowids��
			if (((type=="down")&&(parseInt(rowids[i]['id'])<=parseInt(MaxRowid)))||((type=="up")&&(parseInt(rowids[i]['id'])>=parseInt(MinRowid)))){
				if ((OrderSeqNo == RecentlyOrderSeqNo)||(OrderMasterSeqNo == RecentlyOrderSeqNo)){
					NeedChangeMasterRowids.push(rowids[i]['id']); 
				}
				continue;
			}
	    	NeedMoveRowids.push(rowids[i]["id"]);
	    }
    }
    if (NeedMoveRowids.length==0){return;}
    ///����������Ҫ���ĵĶ���
    var MoveList = new Array();
    if (type=="up"){
	    //���������Ϊ�˷�ֹ�ƶ��кͱ��ƶ���֮�������ɾ�������ݣ�����һ����ʼ��ƫ�Ʊ���
	    var BaseMoveLength=parseInt(SelIds[0])-parseInt(NeedMoveRowids[NeedMoveRowids.length-1])-1;
		var NeedMoveLength=parseInt(SelIds[0])-parseInt(NeedMoveRowids[0]);
		MoveList=SelIds.concat(NeedMoveRowids);
	}else{
		var BaseMoveLength=parseInt(NeedMoveRowids[0])-parseInt(SelIds[SelIds.length-1])-1;
		var NeedMoveLength=parseInt(NeedMoveRowids[NeedMoveRowids.length-1])-parseInt(SelIds[SelIds.length-1]);
		MoveList=NeedMoveRowids.concat(SelIds);
	}
	var MoveIndexList=new Array();
	$.each(MoveList,function(i,rowid){
		MoveIndexList[i]=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
	})
	var DataArry=new Array();
	for (var i=0;i<MoveList.length;i++){
		//var rowid=MoveList[i];
		var curIndex=  MoveIndexList[i]; //PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid); //parseInt(rowid)-1; //
		var curRowData = rowids[curIndex];
		var OrderMasterSeqNo=curRowData["OrderMasterSeqNo"].toString();
		var OrderSeqNo=curRowData["id"];
        if (type=="up"){
			//ǰ��������Ҫ�����ƶ�����
			if (i<SelIds.length){
				curRowData["id"]=(parseInt(curIndex)+1)-parseInt(NeedMoveLength); //parseInt(curRowData["id"])-parseInt(NeedMoveLength);
				curRowData["OrderMasterSeqNo"]=parseInt(OrderMasterSeqNo)-parseInt(NeedMoveLength);
			}else{
				var NeedMoveLength=0;
		        for (var j=0;j<SelIds.length;j++){
			    	if (parseInt(curRowData["id"])<parseInt(SelIds[j])){
				    	NeedMoveLength++;
				    }
			    }
				curRowData["id"]=(parseInt(curIndex)+1)+parseInt(NeedMoveLength); //parseInt(curRowData["id"])+parseInt(NeedMoveLength);
				curRowData["OrderMasterSeqNo"]=parseInt(OrderMasterSeqNo)+parseInt(SelIds.length);
			}
		}else{
			//ǰ��������Ҫ�����ƶ�����
			if (i<NeedMoveRowids.length){
				curRowData["id"]=(parseInt(curIndex)+1)-parseInt(SelIds.length)-parseInt(BaseMoveLength); //parseInt(curRowData["id"])-parseInt(SelIds.length)-parseInt(BaseMoveLength);
				if ($.inArray(parseInt(OrderMasterSeqNo), MoveList)>=0){
					curRowData["OrderMasterSeqNo"]=parseInt(OrderMasterSeqNo)-parseInt(SelIds.length)-parseInt(BaseMoveLength);
				}
			}else{
				curRowData["id"]=(parseInt(curIndex)+1)+parseInt(NeedMoveLength); //parseInt(curRowData["id"])+parseInt(NeedMoveLength);
				if (OrderMasterSeqNo!=""){
					curRowData["OrderMasterSeqNo"]=parseInt(OrderMasterSeqNo)+parseInt(NeedMoveLength);
				}
			}
		}
		if (($.isNumeric(curRowData["OrderMasterSeqNo"])==false)||(curRowData["OrderMasterSeqNo"]==0)){
			curRowData["OrderMasterSeqNo"]="";
		}
		var editors = PageLogicObj.m_ordlistDataGrid.datagrid('getEditors', curIndex);
		if (editors.length>0){
			curRowData['OrderPackQty']=editors[0].target.val();
			curRowData['OrderPrice']=editors[1].target.val();
			curRowData['OrderSum']=editors[2].target.val();
			curRowData['OrderRecDepRowid']=editors[3].target.combobox('getValue');
			curRowData['OrderRecDep']=editors[3].target.combobox('getText');
		}
		//curRowData["rowid"]=curRowData["id"];
        DataArry[DataArry.length]=curRowData;
	}
	///�����ȡ������Ҫ�༭���ж���
	var SortList=MoveIndexList.slice(0);
	SortList.sort(function(a, b){return a - b;});
	$.each(SortList,function(k,rowid){ //
		var index=rowid;
        var NeedChangeData=DataArry[k];
		PageLogicObj.m_ordlistDataGrid.datagrid('getData').rows[index] = NeedChangeData;
		PageLogicObj.m_ordlistDataGrid.datagrid('refreshRow', index);
		SetBeginEdit(DataArry[k]['id']);
        if (type=="up"){
			//ǰ������
			if (k<SelIds.length){
				PageLogicObj.m_ordlistDataGrid.datagrid('checkRow', index);
			}else{
				PageLogicObj.m_ordlistDataGrid.datagrid('uncheckRow', index);
			}
		}else{
			if (k<NeedMoveRowids.length){
				PageLogicObj.m_ordlistDataGrid.datagrid('uncheckRow', index);
			}else{
				PageLogicObj.m_ordlistDataGrid.datagrid('checkRow', index);
			}
		}
	});
}
//�����кŻ�ȡ���й���ҽ�� 
function GetSeqNolist(rowid) {
	var allrows = PageLogicObj.m_ordlistDataGrid.datagrid("getRows") //.slice(0);
	var dataidex=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
	
    var OrderSeqNoMain = allrows[dataidex]['id'];
    var OrderMasterSeqNoMain = allrows[dataidex]['OrderMasterSeqNo'];
    var tmprowids = new Array();
    
    for (var i = 0; i < allrows.length; i++) {
	    
        var OrderMasterSeqNo = allrows[i]['OrderMasterSeqNo'];// GetCellData(AllRowids[i], "OrderMasterSeqNo");
        var Orderid = allrows[i]['id']; //GetCellData(AllRowids[i], "id");
        if (OrderMasterSeqNoMain == "") {
            if (OrderSeqNoMain == OrderMasterSeqNo) { tmprowids[tmprowids.length] = allrows[i]['id']; }
        } else {
            if ((OrderMasterSeqNoMain == Orderid) || (OrderMasterSeqNo == OrderMasterSeqNoMain)) { tmprowids[tmprowids.length] = allrows[i]['id']; }
        }
    }
    return tmprowids;
}
function FindSupplementedOrdClick(){
	var AdmStr=GetSelPatKW();
	if (AdmStr=="") {
		$.messager.alert("��ʾ", "���ȹ�ѡ����!");
	    return websys_cancel();
	}
	var Content="<div id='Win' style='border-bottom:1px solid #ccc;'>"
		   Content +="	<table class='search-table'>"
		       
		       Content +="	 <tr>"
		       	Content +="	 <td class='r-label'>"
		       		Content +="	 ��ʼ����"
		       	Content +="	 </td>"
		       	Content +="	 <td>"
		       		Content +="	 <input id='winSttDate' class='hisui-datebox textbox'></input>"
		       	Content +="	 </td>"
		       	Content +="	 <td class='r-label'>"
		       		Content +="	 ��������"
		       	Content +="	 </td>"
		       	Content +="	 <td>"
		       		Content +="	 <input id='winEndDate' class='hisui-datebox textbox'></input>"
		       	Content +="	 </td>"
		       	Content +="	 <td class='r-label'>"
		       		Content +="	 <a href='#' onClick='LoadSupplementedOrd()'class='hisui-linkbutton' data-options="+"iconCls:'icon-w-find'"+">��ѯ</a>"
		       	Content +="	 </td>"
		       Content +="	 </tr>"
		       
		   Content +="	</table>"
	   Content += "</div>"
	Content +="<div><table id='tabSupplementedOrd' style='margin:5px;border:none;'></table></div>";
	var iconCls="icon-w-list";
	createModalDialog("OrdList","��������¼ҽ����ϸ", 800, 500,iconCls,"",Content,"InitSupplementedOrd()");
}
var selOrdRowIndex="";
function InitSupplementedOrd(){
	var o=$HUI.datebox('#winSttDate,#winEndDate');
	o.setValue(ServerObj.CurrentDate);
	var OrdToolBar=[{
            text: '����',
            iconCls: 'icon-cancel-order',
            handler: function() {ShowCancelMulOrdWin();}
        },{
            text: '����',
            iconCls: 'icon-abort-order',
            handler: function() {ShowUnUseMulOrdWin();}
        }];
	var Columns=[[ 
		{field:'OEORIRowId',checkbox:true},
		{field:'TStDate',title:'��¼����',width:135},
		{field:'OrderName',title:'ҽ������',width:120},
		{field:'PackQty',title:'����',width:40},
		{field:'BillUOMDesc',title:'��λ',width:40},
		{field:'TDoctor',title:'��¼��',width:90},
		{field:'ReLoc',title:'���տ���',width:100},
		{field:'MaterialBarCode',title:'����',width:80}
    ]]
	$("#tabSupplementedOrd").datagrid({  
		height:410,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : true,
		autoRowHeight : true,
		autoSizeColumn : true,
		rownumbers:false,
		pagination : true,
		pageSize: 20,
		pageList : [20,100,200], 
		idField:'OEORIRowId',
		columns:Columns,
		toolbar:OrdToolBar,
		rowStyler: function(index,row){
			if (row['OEORIRowId'].indexOf("||")<0){
				return 'background-color:#cdf1cd;';
			}
		},
		onSelect:function(index, row){
			if (selOrdRowIndex!="") return false;
			var OEORIRowId=row["OEORIRowId"];
			if (OEORIRowId.indexOf("||")<0) {
				var GridData=$("#tabSupplementedOrd").datagrid("getData");
				for (var m=index+1;m<GridData.rows.length;m++){
					if (GridData.rows[m]["OEORIRowId"].split("||")[0]==OEORIRowId) {
						$("#tabSupplementedOrd").datagrid('checkRow',m);
					}
				}
			}else{
				var TOeoriOeori=row["TOeoriOeori"];
				if (TOeoriOeori!=""){
					var index=$("#tabSupplementedOrd").datagrid('getRowIndex',TOeoriOeori);
					$("#tabSupplementedOrd").datagrid('checkRow',index);
				}else{
					var GridData=$("#tabSupplementedOrd").datagrid("getData");
					for (var m=index+1;m<GridData.rows.length;m++){
						var TOeoriOeori=GridData.rows[m]["TOeoriOeori"];
						if (TOeoriOeori==OEORIRowId) {
							selOrdRowIndex=m;
							$("#tabSupplementedOrd").datagrid('checkRow',m);
						}
					}
				}
				selOrdRowIndex="";
			}
		},
		onUnselect:function(index, row){
			if (selOrdRowIndex!="") return false;
			var OEORIRowId=row["OEORIRowId"];
			if (OEORIRowId.indexOf("||")<0) {
				var GridData=$("#tabSupplementedOrd").datagrid("getData");
				for (var m=index+1;m<GridData.rows.length;m++){
					if (GridData.rows[m]["OEORIRowId"].split("||")[0]==OEORIRowId) {
						$("#tabSupplementedOrd").datagrid('uncheckRow',m);
					}
				}
			}else{
				var TOeoriOeori=row["TOeoriOeori"];
				if (TOeoriOeori!=""){
					var index=$("#tabSupplementedOrd").datagrid('getRowIndex',TOeoriOeori);
					$("#tabSupplementedOrd").datagrid('uncheckRow',index);
				}else{
					var GridData=$("#tabSupplementedOrd").datagrid("getData");
					for (var m=index+1;m<GridData.rows.length;m++){
						var TOeoriOeori=GridData.rows[m]["TOeoriOeori"];
						if (TOeoriOeori==OEORIRowId) {
							selOrdRowIndex=m;
							$("#tabSupplementedOrd").datagrid('uncheckRow',m);
						}
					}
				}
				selOrdRowIndex="";
			}
		},
		onLoadSuccess:function(data){
			$("#tabSupplementedOrd").datagrid("clearChecked")
		}
	});
	LoadSupplementedOrd();
}
function LoadSupplementedOrd(){
	var AdmStr=GetSelPatKW();
	$.q({
	    ClassName : "web.DHCDocNurseBatchSupplementOrd",
	    QueryName : "GetNurseBatchOrdList",
	    AdmStr : AdmStr,
	    SttDate:$("#winSttDate").datebox('getValue'),
	    EndDate:$("#winEndDate").datebox('getValue'),
	    LocId:session['LOGON.CTLOCID'],
	    Pagerows:$("#tabSupplementedOrd").datagrid("options").pageSize,rows:99999
	},function(GridData){
		$("#tabSupplementedOrd").datagrid("clearChecked").datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
}
function searchItemkeydown(e){
	if (e.keyCode == 13) {
		if ($("#searchByBarcode").checkbox('getValue')){
			setTimeout(function(){
				OrderMaterialBarcodeContrl();
			})
		}
	}
}
function OrderMaterialBarcodeContrl(){
	var label=$("#searchItem").lookup('getText');
	if (label=="") return false;
	var AricmStr = cspRunServerMethod(ServerObj.GetArcimByLabel, label)
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
			var rowid=GetNewrowid();
			var RtnObj = AddItemToList(rowid,OrdParamsArr, "data","");
			var rowid=RtnObj.rowid;
			var returnValue=RtnObj.returnValue;
            if (returnValue) {
                ClearSearch();
            }
            $("#searchItem").focus().select();
        } else {
	        var AdmStr=GetSelPatKW();
	        if ((AdmStr="")){
		        $.messager.alert("��ʾ", "���ȹ�ѡ����!");
                return false;
		    }
            if (ServerObj.HighValueControl != 1) {
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
				var rowid=GetNewrowid();
				var RtnObj = AddItemToList(rowid,OrdParamsArr, "data","");
				var rowid=RtnObj.rowid;
				var returnValue=RtnObj.returnValue;
                if (returnValue == true) {
	                var data=PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	                var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
	                var OrderRecLocStr=data[index]['OrderRecLocStr']
                    var ArrData = OrderRecLocStr.split(String.fromCharCode(2));
                    for (var i = 0; i < ArrData.length; i++) {
                        var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                        if ((ArrData1[0] == ReLocId) && (ReLocIdFlag != "Y")) { ReLocIdFlag = "Y" };
                    }
                    if (ReLocIdFlag == "N") {
                        $.messager.alert("��ʾ","�����벻���ڸÿ���ʹ��!")
                        PageLogicObj.m_ordlistDataGrid.datagrid("deleteRow",index);
                    }
                    ClearSearch();
        			$("#searchItem").focus();
                }
            }
        }
    } else {
        $.messager.alert("��ʾ","�����벻���ڻ����ѱ�ʹ��!")
        return false;
    }
}
function InitKWPopover(){
	$("#selPatKW li").each(function(){
		var that=$(this);
		var ID=that.attr('id');
		that.on({
			mouseenter:function(){
				if (LoadPopover("Load",that.attr('id'))){
					//��������
					var HTML=GetPannelHTML(that.attr('id'));
					if (HTML.innerHTML==""){return;}
					that.webuiPopover({
						width:HTML.width,
						height:HTML.height,
						title:HTML.Title,
						content:HTML.innerHTML,
						trigger:'hover',
						placement:'auto-bottom',
						onShow:function(){
							if (LoadPopover("Show",that.attr('id'))){
								if (typeof HTML.CallFunction == "function"){
									HTML.CallFunction.call();
								}
							}
						}
					});
					that.webuiPopover('show');
				}
			}
		});
	});
}
var LoadPopover=(function(){
	///��ֹ��γ�ʼ������
	var AlreadLoadObj={};	//��ʼ��Ԫ��
	var AlreadShowObj={};	//��ʼ����ʾ����
	return function(Type,ID){
		if (Type=="Load"){
			if (typeof AlreadLoadObj[ID] =="undefined"){
				AlreadLoadObj[ID] ="1";
				return true;
			}else{
				return false;
			}
		}else if (Type=="Show"){
			if (typeof AlreadShowObj[ID] =="undefined"){
				AlreadShowObj[ID] ="1";
				return true;
			}else{
				return false;
			}
		}else if (Type=="Clear"){
			 AlreadLoadObj={};	//��ʼ��Ԫ��
			 AlreadShowObj={};
		}
		
	}
})();
///��ȡ��̬д���HTML����
function GetPannelHTML(LinkID){
	var innerHTML="";
	var CallFunction={};
	var Title="";
	var width=280,height=150
	var Title="��¼��ҽ����Ϣ";
	
	var LinkedMasterOrderRowid="";
	var ItemArr=$("#selPatKW").keywords('options').items;
	for (var i=0;i<ItemArr.length;i++){
		if (ItemArr[i]['id']==LinkID) {
			var LinkedMasterOrderRowid=ItemArr[i]['LinkedMasterOrderRowid'];
			if (typeof LinkedMasterOrderRowid=="undefined"){LinkedMasterOrderRowid="";}
		}
	}
	if (LinkedMasterOrderRowid=="") {
		return {
			"innerHTML":innerHTML,
			"CallFunction":CallFunction,
			"Title":Title,
			"width":width,
			"height":height
		}
	}
	var JsonData=tkMakeServerCall("web.DHCDocNurseBatchSupplementOrd","GetLinkMasterOrdList",LinkedMasterOrderRowid);
	var JsonData=eval("("+JsonData+")");
	innerHTML+='<ul class="loclist" style="list-style-type:none">';
	var CurrArcimDR="",OrdItem="";
	if (JsonData.length>0){
		for (var i=0,length=JsonData.length;i<length;i++) {
			var OrdName=JsonData[i].OrdName;
			var OrderId=JsonData[i].OrderId;
			OrdName=OrdName+" ҽ��ID:"+OrderId;
			innerHTML+='<li>';
			innerHTML+='<a href="#" id="'+OrderId+'" onclick="DelLinkMasterOrd(\''+OrderId+'\',\''+LinkID+'\')">'+OrdName+'</a>';
			innerHTML+='</li>'
		}
	}
	innerHTML+='</ul>'; 
	height=(JsonData.length)*40;
	return {
		"innerHTML":innerHTML,
		"CallFunction":CallFunction,
		"Title":Title,
		"width":width,
		"height":height
	}
}
function DelLinkMasterOrd(OrderId,AdmId){
	
}
//������
function CardBillClick() {
	var AdmStr=GetSelPatKW();
	if (AdmStr == "") { 
		$.messager.alert("��ʾ", "ȱ�ٻ�����Ϣ!"); 
		return false; 
	}
	if ((AdmStr!="")&&(AdmStr.split("!").length>1)){
		$.messager.alert("��ʾ", "ֻ�ܵ������߽��п�����!");
		return false;
	}
    var EpisodeID = AdmStr;
    //tkMakeServerCall("web.DHCDocOrderListCommon","ComonItemWinte",EpisodeID)
	var ret=tkMakeServerCall("web.DHCDocNurseBatchSupplementOrd","GetCardBillNeedInfo",EpisodeID);
    var PatientID = ret.split(String.fromCharCode(1))[0];
    //var CardNo = ret.split(String.fromCharCode(1))[1];
    var PAAdmType= ret.split(String.fromCharCode(1))[4];
    if (PAAdmType=="I") {
	    $.messager.alert("��ʾ", "סԺ���߲��ܽ���Ԥ�۷�!");
		return false;
	}
	
    DHCACC_GetCardBillInfo(PatientID,function(CardInfo){
		var CardNo=CardInfo.split("^")[0];
		var CardTypeRowId=CardInfo.split("^")[1];
		if (CardNo==""){
			$.messager.alert("��ʾ", "��Ч�Ŀ���Ϣ!"); return; 
		}
		if (ServerObj.CheckOutMode == 1) {
		    $.messager.confirm('��ʾ', '�Ƿ�ȷ�Ͽ۷�?', function(r){
				if (r){
					var CardTypeDefine = tkMakeServerCall("web.UDHCOPOtherLB","ReadCardTypeDefineListBroker1",CardTypeRowId);
					if ($("#CardBillCardTypeValue").length==0) {
						$('body').append("<input id='CardBillCardTypeValue' name='CardBillCardTypeValue' type='hidden' value='"+CardTypeDefine+"'>");
					}else{
						$("#CardBillCardTypeValue").val(CardTypeDefine);
					}
					
				     //var insType = GetPrescBillTypeID();
				    var insType = tkMakeServerCall("DHCDoc.Common.pa","GetDefaultBillTypeByPa",PatientID)
			        var oeoriIDStr = "";
			        var guser = session['LOGON.USERID'];
			        var groupDR = session['LOGON.GROUPID'];
			        var locDR = session['LOGON.CTLOCID'];
			        var hospDR = session['LOGON.HOSPID'];
			        var rtn = checkOut(CardNo, PatientID, EpisodeID, insType, oeoriIDStr, guser, groupDR, locDR, hospDR);
			        CardBillAfterReload();
				}
			});
	    }else{
		 	var url = "dhcbill.opbill.charge.main.csp?ReloadFlag=3&CardNo=" + CardNo + "&SelectAdmRowId=" +  EpisodeID + "&SelectPatRowId=" + PatientID + "&CardTypeRowId=" + CardTypeRowId;
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
    if (parent.refreshBar){
    	parent.refreshBar();
    }else if(parent.parent.refreshBar){
        parent.parent.refreshBar();
    }
}
function ShowCancelMulOrdWin(){
   if (!CheckIsCheckOrd()) return false;
   var SelOrdRowStr=GetSelOrdRowStr();
   if (!CheckOrdDealPermission(SelOrdRowStr,"C")) return false;
   var title="����(DC)ҽ��";
   destroyDialog("OrdDiag");
   var Content=initDiagDivHtml("C");
   var iconCls="icon-w-edit";
   createModalDialog("OrdDiag",title, 380, 190,iconCls,"����(DC)",Content,"MulOrdDealWithCom('C')");
   InitOECStatusChReason();
   $('#OECStatusChReason').next('span').find('input').focus();
}
function ShowUnUseMulOrdWin(){
   if (!CheckIsCheckOrd()) return false;
   var SelOrdRowStr=GetSelOrdRowStr();
   if (!CheckOrdDealPermission(SelOrdRowStr,"U")) return false;
   var title="����ҽ��";
   destroyDialog("OrdDiag");
   var Content=initDiagDivHtml("U")
   var iconCls="icon-w-edit";
   createModalDialog("OrdDiag",title, 380, 190,iconCls,"����",Content,"MulOrdDealWithCom('U')");
   InitOECStatusChReason();
   $('#OECStatusChReason').next('span').find('input').focus();
}
function InitOECStatusChReason(){
	 var cbox = $HUI.combobox("#OECStatusChReason", {
		required:true,
		editable: true,
		multiple:false,
		mode:"remote",
		method: "GET",
		selectOnNavigation:true,
	  	valueField:'id',
	  	textField:'text',
	  	data:eval("("+ServerObj.OECStatusChReasonJson+")")
	});
}
//ҽ������������,��type���ֲ�ͬ����
function MulOrdDealWithCom(type){
   /*
   type���˵��
   ---����ҽ��
   C:����ҽ��
   U:����ҽ��
   */
   var date="",time="";
   var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID'];
   var pinNum="";
   var ReasonId="",Reasoncomment="";
   if ((type=="C")||(type=="U")){
	   ReasonId=$("#OECStatusChReason").combobox("getValue");
	   Reasoncomment=$("#OECStatusChReason").combobox("getText");
	   if (ReasonId==Reasoncomment) ReasonId="";
	   else if (ReasonId!="") Reasoncomment="";
	   if ((ReasonId=="")&&(Reasoncomment=="")){
		   $.messager.alert("��ʾ","��ѡ�������дԭ��!","info",function(){
			   $('#OECStatusChReason').next('span').find('input').focus();
		   });
		   return false;
	   }
	   if ((Reasoncomment!="")&&(Reasoncomment.indexOf("^")>=0)){
			$.messager.alert("��ʾ","����ԭ��ָ���^��ϵͳ��������,���������������!",function(){
				$('#OECStatusChReason').next('span').find('input').focus();
			});
			return false;
	   }
   }
   /*if ((type=="C")||(type=="U")){
		if (ExeCASigin("")==false){
			return false;
		} 
   }*/
   ExpStr=ExpStr+"^"+ReasonId+"^"+Reasoncomment;
   if ($("#winPinNum").length>0){
	   pinNum=$("#winPinNum").val();
	   if (pinNum==""){
		   $.messager.alert("��ʾ","���벻��Ϊ��!","info",function(){
			   $("#winPinNum").focus();
		   });
		   return false;
	   }
   }
   var SelOrdRowStr=GetSelOrdRowStr();
   $.m({
	    ClassName:"web.DHCDocInPatPortalCommon",
	    MethodName:"MulOrdDealWithCom",
	    OrderItemStr:SelOrdRowStr,
	    date:date,
	    time:time,
	    type:type,
	    pinNum:pinNum,
	    ExpStr:ExpStr
	},function(val){
		var alertCode=val.split("^")[0];
		if ((type=="U")&&(alertCode=="-901")){
			$.messager.alert("��ʾ",val.split("^")[1]);
			alertCode="0";
		}
		if (alertCode=="0"){
			/*if ((type=="S")||(type=="C")||(type=="U")){             //2018-9-4 fxn caǩ��
				ExeCASigin(SelOrdRowStr);  
			}*/
			LoadSupplementedOrd();
			destroyDialog("OrdDiag");
		}else{
			$.messager.alert("��ʾ",val);
			return false;
		}
	});
}
function initDiagDivHtml(type){
   if((type=="C")||(type=="U")){
	   var html="<div id='DiagWin' style='margin-top: 5px;'>"
		   html +="	<table class='search-table' style='margin:0 auto;border:none;'>"
		   		html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 ��ѡ��ԭ��"
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='OECStatusChReason' class='textbox'></input>"
			       	html +="	 </td>"
		        html +="	 </tr>"
		       
		   		html +="	 <tr>"
		       		html +="	 <td class='r-label'>"
		       			html +="	 ����"
		       		html +="	 </td>"
		       		html +="	 <td>"
		       			html +="	 <input type='password' id='winPinNum' class='hisui-validatebox textbox' data-options='required:true' onkeydown='DiagDivKeyDownHandle(\"Confirm\",\""+type+"\")' />"
		       		html +="	 </td>"
		       	html +="	 </tr>"
		       	
		   html +="	</table>"
	   html += "</div>"
   }
   return html;
}
function CheckIsCheckOrd(){
   var SelOrdRowArr=$("#tabSupplementedOrd").datagrid('getChecked'); //ҽ�������Թ�ѡΪ׼,δ��ѡ��������
   if (SelOrdRowArr.length==0){
	   $.messager.alert("��ʾ","û�й�ѡҽ��!")
	   return false;
   }
   var Length=0
   $.each(SelOrdRowArr,function(Index,RowData){
	    var OEORIRowId=RowData.OEORIRowId;
	    if ((OEORIRowId!="")&&(OEORIRowId.indexOf("||")>=0)){
			++Length;
		}
   });
   if (Length==0){
	   $.messager.alert("��ʾ","û�й�ѡҽ��!");
	   return false;
   }
   return true;
}
function GetSelOrdRowStr(){
   var SelOrdRowStr=""
   var SelOrdRowArr=$("#tabSupplementedOrd").datagrid('getChecked');
   for (var i=0;i<SelOrdRowArr.length;i++){
	   var OEORIRowId=SelOrdRowArr[i].OEORIRowId;
	   if ((OEORIRowId=="")||(OEORIRowId.indexOf("||")<0)){
		    continue;  
	   }
	   if (SelOrdRowStr=="") SelOrdRowStr=SelOrdRowArr[i].OEORIRowId;
	   else SelOrdRowStr=SelOrdRowStr+"^"+SelOrdRowArr[i].OEORIRowId;
   }
   return SelOrdRowStr;
}
function CheckOrdDealPermission(SelOrdRowStr,type){
   var rtn=$.m({
	    ClassName:"web.DHCDocInPatPortalCommon",
	    MethodName:"CheckMulOrdDealPermission",
	    OrderItemStr:SelOrdRowStr,
	    date:"",
	    time:"",
	    type:type,
	    ExpStr:session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^^"
	},false);
   if (rtn!=0){
	   $.messager.alert("��ʾ",rtn);
	   return false;
   }else{
	   return true;
   }
}
function DiagDivKeyDownHandle(HandleType,EventType){
  if (HandleType=="Confirm"){
     if (window.event.keyCode=="13"){
        MulOrdDealWithCom(EventType);
        return false;
     }
  }
}
///�õ��˵�����
function GetMenuPara(ParaName) {
    var myrtn = "";
    var frm = dhcsys_getmenuform();
    if (frm) {
	    if (eval("frm." + ParaName)){
        	myrtn = eval("frm." + ParaName + ".value");
        }
    }
    return myrtn;
}
function getRowIndex(target){
	var tr =$(target).closest("tr.datagrid-row");
	return parseInt(tr.attr("datagrid-row-index")); 
}
function ChangeLinkOrderOperation(index){
	var rows = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	var OrderSeqNoMain=rows[index]["rowid"];
	var OrderOperationCode=rows[index]["OrderOperationCode"];
	for (var i=index+1;i<rows.length;i++) {
		var OrderMasterSeqNo=rows[i]["OrderMasterSeqNo"];
		if (OrderMasterSeqNo==OrderSeqNoMain) {
			var OrderRecDepObj=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor', {index:i,field:'OrderOperation'});
			$(OrderRecDepObj.target).combobox('select',OrderOperationCode);
		}
		if (OrderMasterSeqNo=="") return;
	}
}
function ChangeLinkOrderRecDept(index){
	var rows = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	var OrderSeqNoMain=rows[index]["rowid"];
	var OrderRecDepRowid=rows[index]["OrderRecDepRowid"];
	for (var i=index+1;i<rows.length;i++) {
		var OrderMasterSeqNo=rows[i]["OrderMasterSeqNo"];
		if (OrderMasterSeqNo==OrderSeqNoMain) {
			var OrderRecDepObj=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor', {index:i,field:'OrderRecDep'});
			$(OrderRecDepObj.target).combobox('select',OrderRecDepRowid);
		}
		if (OrderMasterSeqNo=="") return;
	}
}

function GetOrderSeqArr(rowid){
	var rowids = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	var selOrderSeqNo=rowids[rowid]["id"];
	var selOrderMasterSeqNo=rowids[rowid]["OrderMasterSeqNo"];
	
	var rowidArr = [];
    rowidArr.push(selOrderSeqNo);
	for (var i=0;i<rowids.length;i++) {
		var OrderSeqNo=rowids[i]["id"];
		if ( selOrderSeqNo == OrderSeqNo) continue;
		var OrderMasterSeqNo=rowids[i]["OrderMasterSeqNo"];
		if ((selOrderSeqNo == OrderMasterSeqNo) || (selOrderMasterSeqNo==OrderSeqNo) ||((selOrderMasterSeqNo!="")&&(selOrderMasterSeqNo==OrderMasterSeqNo))){
			rowidArr.push(OrderSeqNo);
		}
	}
	return rowidArr;
}
function GetUnSaveOrdCount(){
	var DataArry = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	return DataArry.length;
}
function FindByLogDepCheckChange(e){
	var itemsArr=$("#selPatKW").keywords('options').items;
	if ((itemsArr.length>1)&&(GetUnSaveOrdCount()>0)){
		$.messager.confirm('ȷ��','�л�ȡ���տ���ģʽ�����µ�ǰδ��˼�¼�Ľ��տ��Ҳ���ȷ���Ƿ����δ��˼�¼?',function(r){    
		    if (r){    
		        ClearGridData();
		    }
		    $("#searchItem").focus();  
		}); 
	}
}
function ChgFindByLogDepCheckStatus(){
	var itemsArr=$("#selPatKW").keywords('options').items;
	var _$FindByLogDep=$("#FindByLogDep");
	_$FindByLogDep.checkbox('enable');
	if (itemsArr.length>1) {
		if (!_$FindByLogDep.checkbox('getValue')) {
			_$FindByLogDep.checkbox('check')
		}
		_$FindByLogDep.checkbox('disable');
	}
}
function GetParamAdm(){
	return PageLogicObj.EplisodeID;
	var Adm="";
	var AdmStr=GetSelPatKW();
	var AdmStrArr=AdmStr.split("!");
	if ((AdmStr!="")&&(AdmStrArr.length==1)) Adm=AdmStrArr[0];
	return Adm;
}
function SetScreenSum() {
	var UnSavedSum = 0
	var rows=PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	for (var i=0;i<rows.length;i++){
		var OrderRowID = rows[i]["OrderRowID"];
	      if ((OrderRowID)&&(OrderRowID!="")) continue;
		var editors = PageLogicObj.m_ordlistDataGrid.datagrid('getEditors', i);
		if (editors.length >0) {
			UnSavedSum=parseFloat(UnSavedSum) + parseFloat(editors[2].target.val());
		}else{
			UnSavedSum=parseFloat(UnSavedSum) + parseFloat(rows[i].OrderSum);
		}
	}
	$("#ScreenBillSum").val(fomatFloat(UnSavedSum,2));
}
// numΪ�����ֵ��nΪ������С��λ
function fomatFloat(num,n){   
    var f = parseFloat(num);
    if(isNaN(f)){
        return false;
    }   
    f = Math.round(num*Math.pow(10, n))/Math.pow(10, n); // n ��   
    var s = f.toString();
    var rs = s.indexOf('.');
    //�ж����������������С�����ٲ�0
    if(rs < 0){
        rs = s.length;
        s += '.'; 
    }
    while(s.length <= rs + n){
        s += '0';
    }
    return s;
} 
function OpenOrdTemplate(){
	var btntext=[{
			text:'�ر�',
			iconCls:'icon-w-close',
			handler:function(){
				window.parent.$HUI.dialog('#TemplateDetail').close();
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
		$.ajax('ipdoc.ordtemplatnew.show.hui.csp'+((typeof websys_getMWToken=='function')?("?MWToken="+websys_getMWToken()):""), {
			"type" : "GET",
			"dataType" : "html",
			"success" : function(data, textStatus) {
				createModalDialogParent("TemplateDetail","ҽ��ģ����ϸ", 280, 700,"icon-w-list",btntext,data,"InitOrdTemplTree()");
				
			}
		});
}
function createModalDialogParent(id, _title, _width, _height, _icon,_btntext,_content,_event){
    window.parent.$("body").append("<div id='"+id+"' class=''></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    if(_btntext==""){
		   var buttons="" 
	   }else{
		   if ($.isArray(_btntext)) {
			   var buttons=_btntext;
		   }else {
			   var buttons=[{
					text:_btntext,
					iconCls:_icon,
					handler:function(){
						if(_event!="") eval(_event);
					}
				}]
		  }
	}
    var collapsed=false,collapsible=false;
    var left=null,closable=true;
    if (id=="TemplateDetail") left=$(window).width()-300,closable=false,collapsed=true,collapsible=true;
    window.parent.$("#"+id).dialog({
	    zIndex:99999,
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        collapsible: collapsible,
        minimizable:false,
        maximizable: false,
        collapsed:collapsed,
        modal: false,
        closed: false,
        closable: closable,
        content:_content,
        buttons:buttons,
        inline:true,
        resizable:false,
        isTopZindex:true,
        left:left,
	    onBeforeOpen:function(){
		    if ((_btntext=="")||($.isArray(_btntext))) {
			    if (_event!="") eval(_event);
			}
		    return true;
		}
    });
}
function destroyDialogParent(id){
   //�Ƴ����ڵ�Dialog
   window.parent.$("body").remove("#"+id); 
   window.parent.$("#"+id).dialog('destroy');
}
function InitTempFrame()
{
	var src="oeorder.entry.template.csp?TemplateRegion="+ServerObj.TemplateRegion+"&EditMode=0";
    if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
    var content="<iframe id='templateFrame' name='templateFrame' width='100%' height='100%' frameborder='0' src='"+src+"'></iframe>"
    if(ServerObj.TemplateRegion=='window'){
        $('<div id="templateWin"></div>').appendTo('body').window({
            title:'ҽ��ģ��',
            minimizable:false,
            maximizable:false,
            closable:false,
            closed:false,
            modal:false,
            width:300,
            height:$(window).height()-20,
            content:content,
            onCollapse:function(){
                $(this).window('resize',{
                    width: 100
                }).window('move',{
                    top:$(window).height()-100,
                    left:$(window).width()-150
                });
            },
            onExpand:function(){
                $(this).window('resize',{
                    width: 300
                }).window('move',{
                    top:10,
                    left:$(window).width()-350
                });
            }
        }).window('move',{left:$(window).width()-330});
        if(ServerObj.DefCollapseTemplate=='on') $('#templateWin').window('collapse');
    }else{
        $('body').layout('add',{
            region:ServerObj.TemplateRegion,
            border:false,
            collapsible:false,
            split:true,
            width:300,
            height:PageLogicObj.NSHeight,
            style:{'padding':'5px 4px','overflow':'hidden'},
            content:content
        });
    }
    $('#templateFrame').parent().css({'overflow':'hidden'});
}
//ģ��༭ģʽ�л�
function TemplateModeChange(mode)
{
    var width=mode?300:800;
    if(ServerObj.TemplateRegion=='window'){
       	$('#templateWin').window('resize',{
            width: width
        }).window('move',{
            //top:100,
            left:$(window).width()-width-10
        });
    }else if(['north','south'].indexOf(ServerObj.TemplateRegion)>-1){
    }else{
        $('body').layout('panel',ServerObj.TemplateRegion).panel('resize',{width:width});
        $('body').layout('resize');
        return;
    }
}
//ģ��ѡ��ҽ��
function addSelectedFav(itemid,text,note,partInfo,callBackFun) {
	var ItemType=itemid.indexOf("||")>-1?'ARCIM':'ARCOS';
	var ProcNote=note||'';
    var OrderBodyPartLabel=partInfo||'';
    if (ItemType == "ARCIM") {
		var OrdParamsArr=new Array();
		OrdParamsArr.push({
			OrderARCIMRowid:itemid,
			ItemDefaultRowId:"",
			OrderBodyPartLabel:OrderBodyPartLabel,
			OrderDepProcNote:ProcNote
		});
		var rowid=GetNewrowid();
		var RtnObj = AddItemToList(rowid,OrdParamsArr,"obj", "");
		var rowid=RtnObj.rowid;
		SetBeginEdit(rowid);
		var returnValue=RtnObj.returnValue;
		if(callBackFun) callBackFun();
    } else {
        OSItemListOpen(itemid, "", "YES", "", "");
        if(callBackFun) callBackFun();
    }
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
