//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-06-28
// ����:	   �°滤ʿ��¼ҽ��
//===========================================================================================

var EpisodeID = "";      /// ���˾���ID
var TabType="";          /// ��ʿִ��ҳǩ����
var NurMoeori = "";      /// ��ʿѡ����ҽ��ID
var TakOrdMsg = "";      /// ��ʾ��Ϣ
var LgLocID = session['LOGON.CTLOCID'];
var LgGroupID = session['LOGON.GROUPID'];
var LgUserID = session['LOGON.USERID'];
var LgHospID = session['LOGON.HOSPID'];
var LgCtLocID = session['LOGON.CTLOCID'];
var LgLocDesc = session['LOGON.CTLOCDESC'];
var ArcColumns = "";    /// ҽ������grid
var PageFlag = 0;

/// ҳ���ʼ������
function initPageDefault(){
		
	InitPatEpisodeID();   ///  ��ʼ�����ز��˾���ID
	validateIsLock();     ///�жϼ���
	GetPatBaseInfo();     ///  ���ز�����Ϣ
	InitPatOrdList();     ///  ��ʼ��ҽ���б�
	InitWirOrdList();     ///  ��ʼ��ҽ��¼���б�
	InitColumns();        ///  ��ʼ��datagrid��
	InitPatNotTakOrdMsg();  /// ��֤�����Ƿ�����ҽ��
	
	InitBlButton();       /// ҳ�� Button ���¼�
	InitCombobox();       /// ҳ��Combobox��ʼ����
}

///����
function validateIsLock(){
	runClassMethod("web.DHCBillLockAdm","LockOPAdm",{"admStr":EpisodeID,"lockType":""},  //hxy 2017-03-07 ���ڸ�ʽ������
	function(retStr){
		if(retStr=="") return;
		$.messager.alert("��ʾ",retStr,"info",function(){
			window.close();
			return;	
		});
		return;
	},"text");
}


/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){

	EpisodeID = getParam("EpisodeID");
	if (PatPanelFlag == 0){
		$('#MainPanel').layout('hidden','west');  /// ���ξ���ҽ���б�
	}
}

/// ҳ�� Button ���¼�
function InitBlButton(){
	
	/// �����ѡ���¼�
	$("#itemList").on("click",".checkbox",selectExaItem);
}

/// ҳ��Combobox��ʼ����
function InitCombobox(){

	/// ������
	var option = {
        onSelect:function(option){
			
			$HUI.checkbox("#TempCovCK").setValue(false);
			LoadTempItemCovDet(option.value);  /// ����ҽ��������
	    }
	};
	var url = $URL+"?ClassName=web.DHCEMNurAddOrder&MethodName=JsonQryOrderTempCov&LgUserID="+LgUserID+"&LgLocID="+LgLocID+"&LgHospID="+LgHospID;
	new ListCombobox("TempCov",url,'',option).init();
	
	/// ����Ĭ�ϵ�ҽ���׶���
	var initCovObj = LoadTempCovInitObj();
	///  ҽ�������Ʋ�ѯ
	if (typeof initCovObj != "undefined"){
		$HUI.combobox("#TempCov").setValue(initCovObj.value);
		$HUI.combobox("#TempCov").setText(initCovObj.text);
		LoadTempItemCovDet(initCovObj.value);  /// ����ҽ��������
	}
}

/// ���˾�����Ϣ
function GetPatBaseInfo(){
	
	runClassMethod("web.DHCAPPExaReportQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID, "PPFlag":""},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.PatSex == "��"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else{
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
			}
			if (jsonObject.PatBed == ""){
				$("#PatBed").parent().parent().next().hide();
			}
		})
	},'json',false)
}

/// ��ʼ��datagrid��
function InitColumns(){
	
	ArcColumns = [[
		{field:'arcitemId',hidden:true},
		{field:'arcitmdesc',title:'ҽ������',width:320},
		{field:'arcitmcode',title:'ҽ������',width:100},
		{field:'arcitmprice',title:'ҽ���۸�',width:100},
		{field:'recLocID',title:'����id',hidden:true},
		{field:'recLocDesc',title:'���տ���',width:160},
	]];
}

/// ��ʼ��ҽ���б�
function InitPatOrdList(){
	
	///  ����columns
	var columns=[[
		{field:'arcitmdesc',title:'ҽ������',width:240},
		{field:'SeqNo',title:'���',width:40,align:'center'},
		{field:'OrderDate',title:'ҽ������',width:100,align:'center'},
		{field:'OrderTime',title:'ҽ��ʱ��',width:100,align:'center'},
		{field:'OrderDocDesc',title:'ҽ��',width:100,align:'center'},
		{field:'OrderStartDate',title:'��ʼ����',width:100,align:'center'},
		{field:'OrderStartTime',title:'��ʼʱ��',width:100,align:'center'},
		{field:'ordPrior',title:'ҽ������',width:80,align:'center'},
		{field:'OrderFreq',title:'Ƶ��',width:60,align:'center'},
		{field:'OrderInstr',title:'�÷�',width:100,align:'center'},
		{field:'OrderDurt',title:'�Ƴ�',width:60,align:'center'},
		{field:'OrderDoseQty',title:'����',width:80,align:'center'},
		{field:'OrderDepProcNote',title:'��ע',width:100},
		{field:'recLoc',title:'���տ���',width:120},
		{field:'oeori',title:'oeori',width:100,align:'center'},
		{field:'moeori',title:'moeori',width:100,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		singleSelect : true,
		queryParams: {
			EpisodeID:EpisodeID,
    		StartDate:'',
    		EndDate:'',
    		PriorCode:'',
    		TabType:TabType,
    		Moeori:NurMoeori,
    		NurOrd:'',
    		LgLocID:LgLocID,
    		SelDate:0
		},
		onClickRow:function(rowIndex, rowData){

	    }
	};

	var uniturl = $URL +"?ClassName=web.DHCEMNurAddOrder&MethodName=QueryPatOrderItems";
	new ListComponent('dgPatOrdList', columns, uniturl, option).Init(); 
}

/// ��֤�����Ƿ�����ҽ��
function InitPatNotTakOrdMsg(){
	
	TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		$.messager.alert("��ʾ:",TakOrdMsg);
		return;	
	}
}

/// ��֤�����Ƿ�����ҽ��
function GetPatNotTakOrdMsg(){

	var NotTakOrdMsg = "";
	/// ��֤�����Ƿ�����ҽ��
	runClassMethod("web.DHCAPPExaReport","GetPatNotTakOrdMsg",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgLocID,"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != ""){
			NotTakOrdMsg = jsonString;
		}
	},'',false)

	return NotTakOrdMsg;
}

/// ��֤�����Ƿ�����ҽ�� סԺ��������Ѻ�����
function GetPatArrManage(){

	var PatArrManMsg = "";
	var amount = $("#mypatpay").text(); /// ���
	/// ��֤�����Ƿ�����ҽ��
	runClassMethod("web.DHCAPPExaReport","GetArrearsManage",{"EpisodeID":EpisodeID,"LgGroupID":LgGroupID,"LgLocID":LgLocID,"amount":amount},function(jsonString){

		if (jsonString != ""){
			PatArrManMsg = jsonString;
		}
	},'',false)

	return PatArrManMsg;
}

/// ҳ��DataGrid
function InitWirOrdList(){

	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}

	/// ��װ��λ
	var PUomEditor = {
		type:'combobox',
		options:{
			panelHeight:'auto',
			valueField:'value',
			textField:'text',
			editable:false,
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				///��������ֵ
				var ed=$("#dgWriOrdList").datagrid('getEditor',{index:modRowIndex,field:'PUomID'});
				$(ed.target).val(option.value);
				var ed=$("#dgWriOrdList").datagrid('getEditor',{index:modRowIndex,field:'PUomDesc'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed = $("#dgWriOrdList").datagrid('getEditor', { index: modRowIndex, field: 'ItmID'});
				var arcitemId = $(ed.target).val();
				if(arcitemId != ""){
					var ed = $("#dgWriOrdList").datagrid('getEditor', { index: modRowIndex, field: 'PUomDesc'});
					$(ed.target).combobox('reload','dhcapp.broker.csp?ClassName=web.DHCEMNurAddOrder&MethodName=GetBillUOMList&ArcimRowid='+arcitemId)
				}
			}
		}
	}
	
	/// ���տ���
	var LocEditor = {
		type:'combobox',
		options:{
			panelHeight:'auto',
			valueField:'value',
			textField:'text',
			editable:false,
			enterNullValueClear:false,
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				///��������ֵ
				var ed=$("#dgWriOrdList").datagrid('getEditor',{index:modRowIndex,field:'recLocID'});
				$(ed.target).val(option.value);
				var ed=$("#dgWriOrdList").datagrid('getEditor',{index:modRowIndex,field:'recLoc'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed = $("#dgWriOrdList").datagrid('getEditor', { index: modRowIndex, field: 'ItmID'});
				var arcitemId = $(ed.target).val();
				if(arcitemId != ""){
					var ed = $("#dgWriOrdList").datagrid('getEditor', { index: modRowIndex, field: 'recLoc'});
					$(ed.target).combobox('reload','dhcapp.broker.csp?ClassName=web.DHCEMNurAddOrder&MethodName=jsonExaCatRecLocNew&EpisodeID='+EpisodeID+'&ItmmastID='+arcitemId);
				}
			},
			onLoadSuccess:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed = $("#dgWriOrdList").datagrid('getEditor', { index: modRowIndex, field: 'recLoc'});
				var recLodId=$(ed.target).combobox('getValue');
				var LogonDepStr = GetLogonLocByFlag();
			    if((LogonDepStr.split("!")[0]!="")&(LogonDepStr.split("!")[1]!="")){
				    if(recLodId!=LogonDepStr.split("!")[0]) return;
				    $(ed.target).combobox('setValue',LogonDepStr.split("!")[0]); 
				    $(ed.target).combobox('setText',LogonDepStr.split("!")[1]); 
				}	
			}
		}
	}
	
	/// �ѱ�
	var AdmReaEditor = {
		type:'combobox',
		options:{
			valueField:'value',
			textField:'text',
			editable:false,
			panelHeight:'auto',
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				///��������ֵ
				var ed=$("#dgWriOrdList").datagrid('getEditor',{index:modRowIndex,field:'BillTypeID'});
				$(ed.target).val(option.value);
				var ed=$("#dgWriOrdList").datagrid('getEditor',{index:modRowIndex,field:'BillType'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed = $("#dgWriOrdList").datagrid('getEditor', { index: modRowIndex, field: 'BillType'});
				$(ed.target).combobox('reload','dhcapp.broker.csp?ClassName=web.DHCEMNurAddOrder&MethodName=jsonGetPatBillType&PatType=E&EpisodeID='+EpisodeID);
			}
		}
	}
						
	///  ����columns
	var columns=[[
		{field:'Select',title:'ѡ��',width:40,align:'center',formatter:SetCellCheckBox},
		{field:'ItmSeqNo',title:'����',width:35,align:'center',hidden:true},
	    {field:'ItmPriorID',title:'���ȼ�ID',width:80,editor:textEditor,hidden:true},
		{field:'ItmOeori',title:'ҽ��ID',width:80,hidden:true},
		{field:'ItmID',title:'ҽ����ID',width:80,editor:textEditor,hidden:true},
		{field:'ItmDesc',title:'ҽ������',width:320,editor:textEditor,styler: function (value, rowData, index) {
			var ClassName = "";
			if (rowData.ItmOeori != ""){
               ClassName = 'background-color:#FFC0CB;';
			}
			return ClassName;
         }},
		{field:'PackQty',title:'����',width:60,editor:textEditor},
		{field:'PUomID',title:'��λID',width:80,editor:textEditor,hidden:true},
		{field:'PUomDesc',title:'��λ',width:80,editor:PUomEditor},
		{field:'Sprice',title:'����',width:80,editor:textEditor},
		{field:'recLocID',title:'���տ���id',width:80,editor:textEditor,hidden:true},
		{field:'recLoc',title:'���տ���',width:160,editor:LocEditor},
		{field:'BillTypeID',title:'�ѱ�ID',width:80,editor:textEditor,hidden:true},
		{field:'BillType',title:'�ѱ�',width:100,editor:AdmReaEditor},
		{field:'ItmTotal',title:'���',width:100,editor:textEditor},
		{field:'OrderType',title:'ҽ������',width:40,editor:textEditor,hidden:true},
		{field:'moeori',title:'moeori',width:80,hidden:true}
	]];
	
	///  ����datagrid
	var option = {
		//title : 'ҽ���б�' + '<span id="allPay" style="float:right">�ϼƽ�0.00</span>',
		//
		title : 'ҽ���б�' +'<input type="checkbox" id="FindByLogDep" style="position: relative;top: 3px;margin-top:-4px;margin-left:50px;">����¼ȡ���տ���</input>'+'<span id="allPay" style="float:right">�ϼƽ�0.00</span>',
		border : false,
		rownumbers : true,
		singleSelect : true,
		pagination: false,
		headerCls:'panel-header-gray',
		checkOnSelect:true,
		selectOnCheck:true,
		onLoadSuccess:function(data){
			CalCurPagePatPayed(); /// �����ܷ���
		}
	};

	var params = "rows=50&page=1&EpisodeID="+EpisodeID+"&StartDate=&EndDate=&LgLocID="+session['LOGON.CTLOCID'];
	var uniturl = $URL + "?ClassName=web.DHCEMNurAddOrder&MethodName=QueryPatOrderItmsByLoc&"+params;
	new ListComponent('dgWriOrdList', columns, uniturl, option).Init();

	/// ��½����ȡ���տ������� 18-6-13 lp
	if (RecLocByLogonLocFlag=="1"){
	    $("#FindByLogDep").prop("checked",true);
	}
}

/// ��ѡ��
function SetCellCheckBox(value, rowData, rowIndex){

	var html = '<input name="ItmCheckBox" type="checkbox" value='+rowIndex+'></input>';
    return html;
}

/// �����ÿ���Ƿ��㹻
function GetAvailQtyByArc(arcitmid,recLoc,Qty,uomID){
	
	var retflag = 0;
	runClassMethod("web.DHCEMNurAddOrder","GetAvaQtyByArc",{"arcitmid":arcitmid, "recLoc":recLoc, "bQty":Qty, "uomID":uomID},function(jsonString){
		if(jsonString != ""){
			retflag = jsonString;
		}
	},'',false);
	return retflag;
}

/// ����������
function GetStkLockFlag(arcitmid,recLocID){

	var retflag = "N";
	runClassMethod("web.DHCEMNurAddOrder","GetStkLockFlag",{"arcitmid":arcitmid, "recLoc":recLocID},function(jsonString){
		if(jsonString != ""){
			retflag = jsonString;
		}
	},'',false);
	return retflag;
}

// ��������
function insertRow(){

	if (TakOrdMsg != ""){
		$.messager.alert("��ʾ:",TakOrdMsg);
		return;	
	}
	
	/// ��ǰ���һ���Ƿ���������
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	var LastEditRow = rowsData.length - 1;
	if(LastEditRow >= 0){
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:LastEditRow,field:'ItmDesc'});
		if (ed != null){
			if ($(ed.target).val() == "") return;
		}
	}

	var ItmXuNo = 1;  /// ���
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	if (rowsData != null){
		ItmXuNo = rowsData.length + 1;
	}
	
	/// ��ȡ����ҽ����Ϣ
	var ItmSeqNo = ""; var moeori = "";
	var rowsData = $("#dgPatOrdList").datagrid('getSelected');
	if (rowsData != null){
		ItmSeqNo = rowsData.SeqNo;
		moeori = rowsData.moeori;
	}

	$("#dgWriOrdList").datagrid('appendRow',{ //��ָ����������ݣ�appendRow�������һ���������
		ItmXuNo:ItmXuNo, ItmSeqNo:'', ItmPriorID:'', OrderType:'', ItmID:'',
		ItmDesc:'', Sprice:'', PackQty:'', PUomID:'', moeori:'',  ///moeori, ע�� ȡ������ bianshuai 2018-03-19
		PUomDesc:'', recLocID:'', recLoc:'', BillTypeID:'', BillType:'', ItmOeori:'', ItmTotal:''}
	);

	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	if (rowsData != null){
		$("#dgWriOrdList").datagrid('beginEdit', rowsData.length - 1);//�����༭������Ҫ�༭����
		editRow = rowsData.length - 1;
	
		/// �༭�а��¼�
		dataGridBindEnterEvent(editRow);
	}
}

/// ����Ŀdatagrid�󶨵���¼�
function dataGridBindEnterEvent(index){

	var editors = $('#dgWriOrdList').datagrid('getEditors', index);
	for(var i=0; i< editors.length; i++){
		var workRateEditor = editors[i];
		if (!workRateEditor.target.next('span').has('input').length){
			workRateEditor.target.bind('click', function(e){
				$('#dgWriOrdList').datagrid('selectRow',index);
			});
		}else{
			workRateEditor.target.next('span').find('input').bind('click', function(e){
				$('#dgWriOrdList').datagrid('selectRow',index);
			});
		}
	}

	var editors = $('#dgWriOrdList').datagrid('getEditors', index);
	/// �����Ŀ����
	var workRateEditor = editors[2];
	workRateEditor.target.focus();  ///���ý���
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var tr = $(this).closest("tr.datagrid-row");
			editRow = tr.attr("datagrid-row-index");
			var ed=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'ItmDesc'});		
			var EntryAlias = $(ed.target).val();
			if (EntryAlias == ""){return;}
			var unitUrl = $URL + '?ClassName=web.DHCEMNurAddOrder&MethodName=JsonQryArcNurAddOrder&EpisodeID='+EpisodeID+'&LgGroupID='+LgGroupID+'&LgUserID='+LgUserID+'&LgLocID='+LgLocID+'&EntryAlias='+EntryAlias;
			/// ����ҽ�����б���
			new ListComponentWin($(ed.target), EntryAlias, "800px", "" , unitUrl, ArcColumns, setCurrArcEditRowCellVal).init();
		}
	});
	
	/// ����
	var workRateEditor = editors[3];
	workRateEditor.target.bind('keyup', function(e){  /// keydown - > keyup
		
		var index = $(this).parents('.datagrid-row').attr('datagrid-row-index');

		/// ȡ¼������	
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:index, field:'PackQty'}); 	
		var pQty = $(ed.target).val();
		
		/// ��ȡ����������
		var rowsData = $('#dgWriOrdList').datagrid('getRows');
		var rowData = rowsData[index];
		
		/// ҽ����ID
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:index, field:'ItmID'}); 	
		var ItmID = $(ed.target).val();
		
		/// ���տ���
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:index, field:'recLocID'}); 	
		var recLocID = $(ed.target).val();
		
		/// ��λID
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:index, field:'PUomID'}); 	
		var PUomID = $(ed.target).val();
		
		/// �����
		if (GetAvailQtyByArc(ItmID, recLocID, pQty, PUomID) == 0){
			alertMsg("����Ŀ��治��,��˶Կ������ԣ�");
			return;
		}
		
		/// �۸�
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:index, field:'Sprice'}); 	
		var Sprice = $(ed.target).val();
		
		/// ��rowsData��ֵ���ڼ���ϼƽ��
		rowsData[index].PackQty=pQty;
		rowsData[index].Sprice=Sprice;
		
		/// ���ºϼƽ��
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:index, field:'ItmTotal'}); 	
		$(ed.target).val(Number(Sprice).mul(pQty));
		
		/// ���¼�����
		CalCurPagePatPayed();
		//}
	});
	
	/// �۸�
	var workRateEditor = editors[6];
	workRateEditor.target.bind('keyup', function(e){  /// keydown - > keyup
			
			/// ����	
			var ed=$("#dgWriOrdList").datagrid('getEditor',{index:index, field:'PackQty'}); 	
			var pQty = $(ed.target).val();
			
			/// �۸�
			var ed=$("#dgWriOrdList").datagrid('getEditor',{index:index, field:'Sprice'}); 	
			var Sprice = $(ed.target).val();
			
			/// ��ȡ����������
			var rowsData = $('#dgWriOrdList').datagrid('getRows');
			var rowData = rowsData[index];
			
			/// ��rowsData��ֵ���ڼ���ϼƽ��
			rowsData[index].PackQty=pQty;
			rowsData[index].Sprice=Sprice;
			
			/// ���ºϼƽ��
			var ed=$("#dgWriOrdList").datagrid('getEditor',{index:index, field:'ItmTotal'}); 	
			$(ed.target).val(Number(Sprice).mul(pQty));
			
			/// ���¼�����
			CalCurPagePatPayed();
	})
}

/// ����ǰ�༭�и�ֵ
function setCurrArcEditRowCellVal(rowData){
	
	/*
	/// ����ж�
	if (GetMRDiagnoseCount() == 0){
		$.messager.alert("��ʾ:","����û�����,����¼�룡","");
		return;	
	}
	*/
	
	if (rowData == null){
		var editors = $('#dgWriOrdList').datagrid('getEditors', editRow);
		///ҽ����Ŀ
		var workRateEditor = editors[6];
		return;
	}
	
	/// �Ƿ������ͬ��Ŀ
	if (isExistSameItem(rowData.arcitemId)){
		$.messager.confirm('��ʾ','������ͬ��Ŀ���Ƿ�������?', function(b){
			if (!b){
				var editors = $('#dgWriOrdList').datagrid('getEditors', editRow);
				///ҽ����Ŀ
				var workRateEditor = editors[6];
				return;	
			}else{
				checkItemSprice(rowData); /// �����Ŀ�۸��Ƿ�������
			}
		})
	}else{
		checkItemSprice(rowData);  /// �����Ŀ�۸��Ƿ�������
	}
}

/// �����Ŀ�۸��Ƿ�������
function checkItemSprice(rowData){
	if (Number(rowData.arcitmprice) == 0){
		/// ��������Ļس�keydown�¼�������ͬʱ��confirmĬ�ϻس��������������ʱ���ı�ִ�ж���˳�� lvpeng add 18-2-6
		setTimeout(function(){
			$.messager.confirm('��ʾ','ҽ����Ŀ����Ϊ0���Ƿ�������?', function(b){
				if (!b){
					var editors = $('#dgWriOrdList').datagrid('getEditors', editRow);
					///ҽ����Ŀ
					var workRateEditor = editors[6];
					workRateEditor.target.focus().select();  ///���ý��� ��ѡ������
					return;
				}else{
					setCurrEditRowCellVal(rowData);
				}
			});	
		},0)	
	}else{
		setCurrEditRowCellVal(rowData);
	}
}

/// �Ƿ������ͬ��Ŀ
function isExistSameItem(arcitemId){
	
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	for (var n=0; n<rowsData.length; n++){
		if (arcitemId == rowsData[n].ItmID){
			return true;
		}
	}
	return false;
}

/// �����Ŀ�б�
function setCurrEditRowCellVal(rowData){
	
	/// ҽ����ID
	var ItmID=$("#dgWriOrdList").datagrid('getEditor',{index:editRow,field:'ItmID'});
	$(ItmID.target).val(rowData.arcitemId);
	
	/// ҽ������
	var ItmDesc=$("#dgWriOrdList").datagrid('getEditor',{index:editRow,field:'ItmDesc'});
	$(ItmDesc.target).val(rowData.arcitmdesc);
  
    /// ���տ���ID
    var LogonDepStr = GetLogonLocByFlag();
    var recLocID=$("#dgWriOrdList").datagrid('getEditor',{index:editRow,field:'recLocID'});
    if((LogonDepStr.split("!")[0]!="")&(LogonDepStr.split("!")[1]!="")){
	   $(recLocID.target).val(LogonDepStr.split("!")[0]);
	}else{
		$(recLocID.target).val(rowData.recLocID);
	}
	
	/// ���տ���
    var ed=$("#dgWriOrdList").datagrid('getEditor',{index:editRow,field:'recLoc'});
    if((LogonDepStr.split("!")[0]!="")&(LogonDepStr.split("!")[1]!="")){
	    $(ed.target).combobox('setValue',LogonDepStr.split("!")[0]); 
	    $(ed.target).combobox('setText',LogonDepStr.split("!")[1]); 
	}else{
		$(ed.target).combobox('setValue', rowData.recLocDesc);
	}
	/// ����װ��λid
	var billuomID=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'PUomID'});
	$(billuomID.target).val(rowData.billuomID);
	
	/// ����װ��λ 
	var ed = $('#dgWriOrdList').datagrid('getEditor',{index:editRow, field:'PUomDesc' });
    $(ed.target).combobox('setValue', rowData.billuomDesc);
    
    /// ����
	var OrderPackQty=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'PackQty'});
	$(OrderPackQty.target).val(rowData.pQty);
	
	/// �ѱ�
	var BillTypeRowid=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'BillTypeID'});
	$(BillTypeRowid.target).val(rowData.BillTypeRowid);
	
	/// �ѱ�
	var BillTypeRowid=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'BillType'});
	$(BillTypeRowid.target).combobox('setValue', rowData.BillType);
	
	/// �۸�
	var Price=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'Sprice'});
	$(Price.target).val(rowData.arcitmprice);
	if (rowData.OrderType != "P"){
		$(Price.target).attr("disabled", true);
	}
	
	/// ���
	var Total=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'ItmTotal'});
	$(Total.target).val(Number(rowData.arcitmprice).mul(rowData.pQty));
	if (rowData.OrderType != "P"){
		$(Total.target).attr("disabled", true);
	}
	
	/// ҽ�����ȼ�ID
	var ed=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'ItmPriorID'});
	$(ed.target).val(rowData.ItmPriorID);

	/// ҽ������
	var Price=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'OrderType'});
	$(Price.target).val(rowData.OrderType);
	
	/// ��ȡ����������
	var rowsData = $('#dgWriOrdList').datagrid('getRows');
	/// ��rowsData��ֵ���ڼ���ϼƽ��
	rowsData[editRow].PackQty = rowData.pQty;
	rowsData[editRow].Sprice = rowData.arcitmprice;
			
	/// ���¼�����
	CalCurPagePatPayed();
}

/// �ܷ���
function CalCurPagePatPayed(){
	
	var total = 0;
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	if (rowsData != null){
		for(var i=0;i<rowsData.length;i++){
			var spamt = Number(rowsData[i].Sprice).mul(rowsData[i].PackQty);
		    total = Number(total).add(spamt);
		}
	    var htmlStr = "�ϼƽ�"+"<span id='mypatpay'>"+total+"</span>"
		$("#allPay").html(htmlStr);
	}
}

// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	for (var index=rowsData.length-1; index >= 0; index--){

		if ($("tr[datagrid-row-index='"+index+"'] input[name='ItmCheckBox']").is(':checked')){
			if (rowsData[index].ItmOeori == ""){
				/// ɾ����
				$("#dgWriOrdList").datagrid('deleteRow',index);
			}else{
				InvStopOrder(rowsData[index].ItmOeori); /// ����ͣҽ���ӿ�
			}
		}
	}
	$('#dgPatOrdList').datagrid('reload'); //���¼���

	/// ����ϼƽ��
	CalCurPagePatPayed();
}

/// ͣҽ������
function InvStopOrder(Oeori){

	runClassMethod("web.DHCEMNurAddOrder","InvStopOrder",{"Oeori":Oeori, "LgUserID":LgUserID},function(jsonString){
		if(jsonString == 0){
			$('#dgWriOrdList').datagrid('reload'); //���¼���
		}else{
			$.messager.alert("��ʾ","ɾ��ʧ��!"); 
		}
	},'',false);
}


/// ������
function saveRow(){
	
	/// ����ǰ���
	if (!beforeSaveCheck()) return;

	/// �����༭
	var rowsData = $("#dgWriOrdList").datagrid('getRows');

	for(var m=0;m<rowsData.length;m++){
		$("#dgWriOrdList").datagrid('endEdit', m);
	}
	
	var rowsData = $("#dgWriOrdList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	
	var dataList = [],validateData=true;
	for(var i=0;i<rowsData.length;i++){
		
		/// �Զ���۸�
		var Sprice = "";
		if (rowsData[i].OrderType == "P"){
			Sprice = rowsData[i].Sprice;
		}
		var tmp = rowsData[i].ItmID +"^"+ rowsData[i].OrderType +"^"+ rowsData[i].ItmPriorID +"^^";
			tmp = tmp +"^"+ rowsData[i].PackQty +"^"+ Sprice +"^"+ rowsData[i].recLocID +"^"+ rowsData[i].BillTypeID +"^";
			tmp = tmp +"^^^^^^";
			tmp = tmp +"^^"+ "" +"^^"+ (i+1) +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "";
			tmp = tmp +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ rowsData[i].moeori;
		
		if(rowsData[i].PackQty==0){
			$.messager.alert("��ʾ","��"+(i+1)+"����������Ϊ0!");
			validateData=false;
			return false;
		}
		
		dataList.push(tmp);
	}
	
	if(!validateData) return false;
	
	
	
	var mListData=dataList.join("&&");

	if(mListData == ""){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	
	/// סԺ��������Ѻ�����
	var PatArrManMsg = GetPatArrManage();
	if (PatArrManMsg != ""){
		$.messager.alert("��ʾ",PatArrManMsg); 
		return;	
	}
	
	//��������
	runClassMethod("web.DHCEMNurAddOrder","SaveOrderItems",{"EpisodeID":EpisodeID, "UserID":LgUserID, "LocID":LgLocID, "mListData":mListData},function(jsonString){
		if(jsonString==0){
			$.messager.alert("��ʾ","����ɹ�!"); 
			$('#dgWriOrdList').datagrid('reload'); //���¼���
			$('#dgPatOrdList').datagrid('reload'); //���¼���
		}else{
			$.messager.alert("��ʾ","����ʧ��!"); 
		}
	},'',false);
}


/// �����Ŀ�Ƿ�������
function beforeSaveCheck(){

	var resFlag = true;
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	
	/// ���һ���հ���ȥ��
	var ed=$("#dgWriOrdList").datagrid('getEditor',{index:rowsData.length-1, field:'ItmID'}); 	
	var ItmID = $(ed.target).val();
	if(ItmID==""){
		/// ɾ����
		$("#dgWriOrdList").datagrid('deleteRow',rowsData.length-1);
	}
	
	
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	for(var m=0;m<rowsData.length;m++){
		

		if (rowsData[m].ItmOeori != "") continue;
	
		/// ȡ¼������	
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:m, field:'PackQty'});
		if (ed == null) continue;	
		var pQty = $(ed.target).val();
		
		/// ҽ����ID
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:m, field:'ItmID'}); 	
		var ItmID = $(ed.target).val();
		
		/// ҽ����
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:m, field:'ItmDesc'}); 	
		var ItmDesc = $(ed.target).val();
		
		/// ���տ���
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:m, field:'recLoc'}); 
		var recLoc = $(ed.target).combobox('getValue');
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:m, field:'recLocID'}); 	
		var recLocID = $(ed.target).val();
		if (recLocID == ""){
			$.messager.alert("��ʾ:","ҽ����"+ ItmDesc + "���տ���Ϊ��,����д���տ��Һ����ԣ�");
			resFlag = false;
			break;	
		}
		
		/// ��λID
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:m, field:'PUomID'}); 	
		var PUomID = $(ed.target).val();

		/// ����������
		if (GetStkLockFlag(ItmID, recLocID) == "Y"){
			$.messager.alert("��ʾ:","ҽ����"+ ItmDesc + " �Ѿ���"+ recLoc +"����������Ҫ����ϵҩ��������Ա��");
			resFlag = false;
			break;	
		}
		
		/// �����
		if (GetAvailQtyByArc(ItmID, recLocID, pQty, PUomID) == 0){
			$.messager.alert("��ʾ:","ҽ����"+ ItmDesc + " ��治��,��˶Կ������ԣ�");
			resFlag = false;
			break;	
		}
		
		/// ��ҽ���Ƿ��Ѿ�ֹͣ
		if (isMoeoriStop(rowsData[m].moeori) != 0){
			$.messager.alert("��ʾ:","ҽ����"+ ItmDesc + " ������ҽ���Ѿ�ֹͣ,���ʵ�����ԣ�");
			resFlag = false;
			break;	
		}
	}
	
	return resFlag;
}

/// ��ҽ���Ƿ��Ѿ�ֹͣ
function isMoeoriStop(moeori){
	
	var retflag = 0;
	runClassMethod("web.DHCEMNurAddOrder","GetOeoriStat",{"oeori":moeori},function(jsonString){
		if(jsonString != ""){
			if ((jsonString == "D")||(jsonString == "C")){
				retflag = 1;
			}
		}
	},'',false);
	return retflag;
}

///���Ұ�ť
function QryPatOrdList(){ 

    var StartDate="",EndDate="";
    //�����ڲ�ѯ
    var SelDate = $HUI.checkbox("#ByDate").getValue()?"1":"0";     /// �Ӽ�
	if (SelDate == 1){
    	StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ����
    	EndDate =$HUI.datebox("#EndDate").getValue();;     /// ��������

		if ((StartDate=="")||(EndDate=="")){
		    $.messager.alert("��ʾ:","��ѡ��ʼ�������������");
			return;  
		}
	}
	
	/// ��ѯ�����б�
	$("#dgPatOrdList").datagrid("load",{"EpisodeID":EpisodeID, "StartDate":StartDate,"EndDate":EndDate, "LgLocID":LgLocID, 
		"SelDate":SelDate, "PriorCode":'', "TabType":'', "Moeori":'', "NurOrd":''});
}

/// ========================================= ҽ��ģ�� ===========================================
/// ����ģ��
function LoadTempItem(ObjectType){
	
	/// ����ģ��
	$("#itemList tbody").html('');
	var QueryParam = {"LgUserID":LgUserID, "LgGroupID":LgGroupID, "LgLocID":LgLocID, "ObjectType":ObjectType, "HospID":LgHospID, "EpisodeID":EpisodeID};
	runClassMethod("web.DHCEMNurAddOrder","JsonQryOrderTemp",QueryParam,function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InitCheckItemRegion(jsonObjArr);
		}
	},'json',false)
}

/// ��鷽���б�
function InitCheckItemRegion(itemArr){	
	/// ������
	var htmlstr = '';

	/// ��Ŀ
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		var itmmaststr = itemArr[j-1].eleid;
		if (itmmaststr.indexOf("ARCIM") != "-1"){
			var itmmastArr = itmmaststr.split("^");
			itmmaststr = itmmastArr[2];
		}
		itemhtmlArr.push('<td style="width:33px"  align="center"><input id="'+ itemArr[j-1].id +'" name="ExaItem" type="checkbox" class="checkbox" value="'+ itmmaststr +'"></input></td><td>'+ itemArr[j-1].name +'</td>');
		if (j % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}

	if ((j-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:33px"></td><td></td></tr>';
		itemhtmlArr = [];
	}

	$("#itemList tbody").append(htmlstr+itemhtmlstr)
}

/// ����ģ��
function LoadTempItemCovDet(ID){
	
	/// ����ģ��
	$("#itemList tbody").html('');
	var QueryParam = {"ID":ID, "LgHospID":LgHospID, "EpisodeID":EpisodeID};
	runClassMethod("web.DHCEMNurAddOrder","JsonQryOrderTempCovDet",QueryParam,function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InitCheckItemRegionCov(jsonObjArr);
		}
	},'json',false)
}

/// ��鷽���б�
function InitCheckItemRegionCov(itemArr){	
	/// ������
	var htmlstr = '';
		//htmlstr = '<tr style="height:30px"><td colspan="4" class=" tb_td_required" style="border:1px solid #ccc;"></td></tr>';

	/// ��Ŀ
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		var itemValue = itemArr[j-1].ItemRowid +"^"+ itemArr[j-1].ItemQty +"^"+ itemArr[j-1].ItemBillUomID +"^"+ itemArr[j-1].ItemBillUOM;
		itemhtmlArr.push('<td style="width:33px"  align="center"><input id="'+ itemArr[j-1].ItemRowid +'" name="ExaItemCov" type="checkbox" class="checkbox" value="'+ itemValue +'"></input></td><td>'+ itemArr[j-1].Item +'</td><td align="center">'+ itemArr[j-1].ItemQty +'</td><td>'+ itemArr[j-1].ItemBillUOM +'</td>');
		if (j % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}

	if ((j-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:33px"></td><td></td><td></td><td></td></tr>';
		itemhtmlArr = [];
	}

	$("#itemList tbody").append(htmlstr+itemhtmlstr)
}

/// ����Ĭ�ϵ�ҽ����
function LoadTempCovInitObj(){
	
	var initCovObj = {};
	/// ҽ�������Ʋ�ѯ
	var QueryParam = {"LgUserID":LgUserID, "LgLocID":LgLocID, "LgHospID":LgHospID};
	runClassMethod("web.DHCEMNurAddOrder","JsonQryOrderTempCov",QueryParam,function(jsonString){

		if (jsonString != null){
			var jsonObjArr = jsonString;
			initCovObj = jsonObjArr[0];
		}
	},'json',false)
	return initCovObj;
}

/// ���ظ���ģ��
function LoadUserTemp(){
	
	$(".con_div").hide();
	$(".item_div").addClass("item_top");
	$("#itemList th:contains('����')").hide();
	$("#itemList th:contains('��λ')").hide();
	LoadTempItem("User.SSUser"); /// ����ģ��
}

/// ���ؿ���ģ��
function LoadLocTemp(){
	
	$(".con_div").hide();
	$(".item_div").addClass("item_top");
	$("#itemList th:contains('����')").hide();
	$("#itemList th:contains('��λ')").hide();
	LoadTempItem("User.CTLoc"); /// ����ģ��
}

/// ����ҽ����ģ��
function LoadTempCov(){
	
	$(".con_div").show();
	$(".item_div").removeClass("item_top");
	$("#itemList th:contains('����')").show();
	$("#itemList th:contains('��λ')").show();
	$("#itemList tbody").html('');
	
	/// ��Ŀ����ѡ������ʱ,���²�ѯ
	if (PageFlag == 1){
		var TempCov = $HUI.combobox("#TempCov").getValue();
		if (TempCov != ""){
			LoadTempItemCovDet(TempCov);
		}
	}
}

/// ѡ���¼�
function selectExaItem(){
	
	/// ��鷽����ҽ����ID��ҽ�������ơ�
	var arcitmid = ""; var tempitmCov = "";
	var itmmaststr = this.value;    /// ��Ŀ���ݴ�
	if (itmmaststr == "") return;
	var arcitmdesc = "";
		
	if ($(this).is(':checked')){
		/// ѡ�е���
		if (this.name == "ExaItemCov"){
			var itmmastArr = itmmaststr.split("^");
			arcitmid = itmmastArr[0];
			tempitmCov = itmmaststr;
		}else{
			if (itmmaststr.indexOf("ARCOS") != "-1"){
				var itmmastArr = itmmaststr.split("^");
				GetOrderTempCov(itmmastArr[2],1);  /// ȡҽ������ϸ��Ŀ
				return;
			}else{
				arcitmid = itmmaststr;
			}
		}
		$(this).attr('checked',false); /// ��ȡ��Ŀ��,��ѡ��ȡ��ѡ��״̬
		arcitmdesc = $(this).parent().next().text(); /// ��鷽��
		InsOrderByTemp(arcitmid, tempitmCov, arcitmdesc);
	}
}

/// ȡҽ������ϸ��Ŀ
function GetOrderTempCov(arccosid, flag){
	
	/// ����ģ��
	var QueryParam = {"ID":arccosid, "LgHospID":LgHospID};
	runClassMethod("web.DHCEMNurAddOrder","JsonQryOrderTempCovDet",QueryParam,function(jsonString){
		if ((jsonString != null)&(jsonString !="")){
			var jsonObjArr = jsonString;
			InsItemCovDet(jsonObjArr, flag);
		}else{
			$.messager.alert("��ʾ","ҽ���׶�Ӧҽ����ϸΪ��,���ʵ�����ԣ�");
		}
	},'json',false)
}

/// ����ҽ������ϸ����
function InsItemCovDet(itemArr, flag){
	
	/// ��Ŀ
	for (var j=1; j<=itemArr.length; j++){
		if (flag == 1){
			var tempitmCov = itemArr[j-1].ItemRowid +"^"+ itemArr[j-1].ItemQty +"^"+ itemArr[j-1].ItemBillUomID +"^"+ itemArr[j-1].ItemBillUOM;
			InsOrderByTemp(itemArr[j-1].ItemRowid, tempitmCov, "");
		}else{
			DelRowByTemp(itemArr[j-1].ItemRowid);
		}
	}
}

/// ȫѡ/ȫ��
function TempCovCKItem(value){
	
	var TempCovCKFlag = false;
	if (value){
		TempCovCKFlag = true;
	}
	//$(this).attr('checked',false);
	
	/// ѡ�л�ȡ��ҽ���׶�Ӧ��ϸ��Ŀ
	$("input[name='ExaItemCov']").each(function(){
		$(this).attr('checked',TempCovCKFlag);
		
		/// ��鷽����ҽ����ID��ҽ�������ơ�
		var arcitmid = ""; var tempitmCov = ""; var arcitmdesc = "";
		var itmmaststr = this.value;    /// ��Ŀ���ݴ�
		if (itmmaststr == "") return;
		var itmmastArr = itmmaststr.split("^");
		arcitmid = itmmastArr[0];
		tempitmCov = itmmaststr;
		arcitmdesc = $(this).parent().next().text(); /// ��鷽��
		if (TempCovCKFlag == true){
			InsOrderByTemp(arcitmid, tempitmCov, arcitmdesc);
		}else{
			//DelRowByTemp(arcitmid);
		}
		$(this).attr('checked',false);
	})
}

/// tab��ǩ����¼�
function TabsOnSelect(title){
	
	if (title == "����ģ��"){
		LoadUserTemp();
	}else if (title == "����ģ��"){
		LoadLocTemp();
	}else if (title == "ҽ����"){
		LoadTempCov();
	}
}

/// ���ģ������
function InsOrderByTemp(arcitemId, tempitmCov, arcitmdesc){
	
	if (TakOrdMsg != ""){
		$.messager.alert("��ʾ:",TakOrdMsg);
		return;	
	}
	
	if (GetDocPermission(arcitemId) == 1){
		$.messager.alert("��ʾ:","��û��Ȩ��¼��ҽ��:"+arcitmdesc);
		return;
	}
	
	runClassMethod("web.DHCEMNurAddOrder","GetArcItemInfoByArcID",{'EpisodeID':EpisodeID, 'arcitemId':arcitemId},function(jsonString){		   		 
   		
   		if(jsonString != null){
	   		var rowData = jsonString;
	   		insertRowData(rowData, tempitmCov); /// ��������  bianshuai 2017-03-24
	   	}
	},"json",false)
}

/// ��̬ɾ��ѡ����Ŀ
function DelRowByTemp(arcitmid){
	
	var rowsData = $("#dgOrdList").datagrid('getRows');
	for (var index=rowsData.length-1; index >= 0; index--){
		if ((rowsData[index].ItmID == arcitmid)&(rowsData[index].ItmOeori == "")){
			/// ɾ����
			$("#dgWriOrdList").datagrid('deleteRow',index);
		}
	}
	/// ����ϼƽ��
	CalCurPagePatPayed(); 
}

// ��������
function insertRowData(rowData, tempitmCov){

	/// ȡҽ������ϸ���ݸ�ֵ�������
	if (tempitmCov != ""){
		var tempitmCovArr = tempitmCov.split("^");
		rowData.pQty = tempitmCovArr[1];
		rowData.billuomID = tempitmCovArr[2];
		rowData.billuomDesc = tempitmCovArr[3];
	}

	/// �����
	if (GetAvailQtyByArc(rowData.arcitemId, rowData.recLocID, rowData.pQty, rowData.billuomID) == 0){
		$.messager.confirm('��ʾ:','����ĿĬ�Ͻ��տ��ҿ�治��,�Ƿ�������?', function(r){
			if (r){
				insertRowCon(rowData);
			}
		})
	}else{
		insertRowCon(rowData);
	}
}

/// ������
function insertRowCon(rowData){

	var ItmXuNo = 1;  /// ���
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	if (rowsData != null){
		ItmXuNo = rowsData.length + 1;
	}

	/// ��ȡ����ҽ����Ϣ
	var ItmSeqNo = ""; var moeori = "";
	var rowsData = $("#dgPatOrdList").datagrid('getSelected');
	if (rowsData != null){
		ItmSeqNo = rowsData.SeqNo;
		moeori = rowsData.moeori;
	}
	
	/// ���
	var ItmTotal = (Number(rowData.pQty)*Number(rowData.arcitmprice)).toFixed(2); 
	
	/// 18-6-13 update lp ���տ���������ȡ��½���� start
	var LogonDepStr = GetLogonLocByFlag();
	var ByTempLocID="",ByTempLocDesc="";
	    
    /// ���տ���ID
    if((LogonDepStr.split("!")[0]!="")&(LogonDepStr.split("!")[1]!="")){
	  	ByTempLocID = LogonDepStr.split("!")[0]; 
	}else{
		ByTempLocID = rowData.recLocID;
	}
	
	/// ���տ���
    if((LogonDepStr.split("!")[0]!="")&(LogonDepStr.split("!")[1]!="")){
	    ByTempLocDesc = LogonDepStr.split("!")[1];
	}else{
		ByTempLocDesc = rowData.recLocDesc;
	}
	
	/// ��ǰ���һ���Ƿ���������
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	var LastEditRow = rowsData.length - 1;
	if(LastEditRow >= 0){
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:LastEditRow,field:'ItmDesc'});
		if (ed != null){
			if ($(ed.target).val() == "") $("#dgWriOrdList").datagrid('deleteRow', LastEditRow);
		}
	}
	
	$("#dgWriOrdList").datagrid('appendRow',{ //��ָ����������ݣ�appendRow�������һ���������
		ItmXuNo:ItmXuNo, ItmSeqNo:'', ItmPriorID:rowData.ItmPriorID, OrderType:rowData.OrderType, ItmID:rowData.arcitemId,
		ItmDesc:rowData.arcitmdesc, Sprice:rowData.arcitmprice, PackQty:rowData.pQty, PUomID:rowData.billuomID, moeori:'', /// moeori, ע�� ȡ������ bianshuai 2018-03-19
		PUomDesc:rowData.billuomDesc, recLocID:ByTempLocID, recLoc:ByTempLocDesc, BillTypeID:rowData.BillTypeID, BillType:rowData.BillType, ItmOeori:'', ItmTotal:ItmTotal}
	);
	
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	if (rowsData != null){
		$("#dgWriOrdList").datagrid('beginEdit', rowsData.length - 1);//�����༭������Ҫ�༭����
		editRow = rowsData.length - 1;
		
		if (rowData.OrderType != "P"){
			/// �������÷Ǳ༭״̬
			var Ed=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'Sprice'});
		    $(Ed.target).attr("disabled", true);
		    /// �ܽ�����÷Ǳ༭״̬
		    var Ed=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'ItmTotal'});
		    $(Ed.target).attr("disabled", true);
		}
	
		/// �༭�а��¼�
		dataGridBindEnterEvent(editRow);
	}
	
	/// ����ϼƽ��
	CalCurPagePatPayed(); 
}

/// ��ȡҽ��¼ҽ��Ȩ��
function GetDocPermission(arcitemId){

	var DocPerFlag = 0;
	/// ����ҽ��¼ҽ��Ȩ��
	runClassMethod("web.DHCAPPExaReport","GetDocPermission",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgLocID,"EpisodeID":EpisodeID,"arcitemId":arcitemId},function(jsonString){

		if (jsonString == 1){
			DocPerFlag = jsonString;
		}
	},'',false)

	return DocPerFlag;
}

/// ����Ĭ�ϵ�ҽ����
function LoadTempCovInitObj(){
	
	var initCovObj = {};
	/// ҽ�������Ʋ�ѯ
	var QueryParam = {"LgUserID":LgUserID, "LgLocID":LgLocID, "LgHospID":LgHospID};
	runClassMethod("web.DHCEMNurAddOrder","JsonQryOrderTempCov",QueryParam,function(jsonString){

		if (jsonString != null){
			var jsonObjArr = jsonString;
			initCovObj = jsonObjArr[0];
		}
	},'json',false)
	return initCovObj;
}


//����ر�ȡ����
window.onbeforeunload = function(){
  	runClassMethod("web.DHCBillLockAdm","UnLockOPAdm",{"admStr":EpisodeID,"lockType":""},  //hxy 2017-03-07 ���ڸ�ʽ������
	function(retStr){},"text",false);
}

function GetLogonLocByFlag() {
	
    var FindRecLocByLogonLoc;
    //�������¼����ȡ���տ���?�Ͱѵ�¼���Ҵ���ȥ
    var obj = document.getElementById("FindByLogDep");
    if (obj) {
        if (obj.checked) { FindRecLocByLogonLoc = 1 } else { FindRecLocByLogonLoc = 0 }
    }
    var LogonDep = "",LogonDepDesc="";
    if (FindRecLocByLogonLoc == "1") { 
    	LogonDep = LgCtLocID;
    	LogonDepDesc = LgLocDesc;
     }
    return LogonDep+"!"+LogonDepDesc;
}


/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {
	PageFlag = 1;
}

window.onload = onload_handler;

/// ========================================= ҽ��ģ�� ===========================================

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })