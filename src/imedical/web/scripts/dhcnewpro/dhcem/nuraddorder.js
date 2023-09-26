/// Creator: huaxiaoying
/// CreateDate: 2016-10-11
/// Descript: ��ʿ��¼ҽ��
var EpisodeID=""; /// ȫ�ֱ��� Ǩ��ҳ�洫����
var VersionNo=""; /// ҳ��汾��
var TabType="";   /// ��ʿִ��ҳǩ����
var NurMoeori=""; /// ��ʿѡ����ҽ��ID

/// ��ʼ��������ʽ����
function initPageStyle(){
    var myHeight=$(window).height()-389;
    $("#myHeight").css("height",myHeight);
    
    if(getParam("DISPLAY")=="NONE"){ //hxy 2017-03-30 ��ʿִ�н����Ҳ��Ƴ��ý���
		$("#nuraddorder-title").css("display","none");
		//$("#info").css("display","none");
		$("#left").css("display","none");
		$("#right").css("width","100%");
		$("#myHeight").css("height",$(window).height()-353);
	}
    
    $("#showalert").css("width",$(window).width()+17) //alert��
    $("#showalert").css("height",$(window).height()) //alert��
    $("#showalertcontent").css("left",($(window).width()-600)/2) //alert left
    $("#showalertcontent").css("top",($(window).height()-260)/2) //alert top
    
    /// ��ʾ���ȷ��
	$("#yes").click(function(){
		$("#showalert").hide();
		$("#showalertcontent").hide();
	 });
	
	/// ��ʾ��
	$("#alertclose").click(function(){
		$("#showalert").hide();
		$("#showalertcontent").hide();
	 });
	
	/// ������
	$("#leftshow").hide();  /// ��ʼ������this
	changeRightTable();     /// �޸��Ҳ���ȫ��
	
	$(".template").click(function(){
		Id=$(this).attr("id")
		this.style.color ="#42A5F5";
		this.style.fontWeight='bold';
		$(".template").each(function(){
			if($(this).attr("id")!=Id){
				this.style.color = "#100806";
				this.style.fontWeight='normal';
			}
		})
	});
}

///�޸��Ҳ���ȫ��
function changeRightTable(){
	$(".panel").css("width","100%")
	$(".panel-body-noheader").css("width","100%")
	$(".datagrid-body").css("width","100%")
	$(".datagrid-header").css("width","100%")
	$(".datagrid-view").css("width","100%")
	$(".datagrid-view2").css("width","100%")
	//$.parser.parse($('#dgOrdList').parent());
}

///��ʾ���
function leftshow(){
	$("#leftshow").hide();
	$("#left").show();
	$("#right").css("width","60%");
	$.parser.parse($('#dgOrdList'));
    search(); //2017-03-16 ��ʼ����೬��
}

///�������
function lefthide(){
	leftshowHeight=$(window).height()-35
	$("#left").hide();
    $("#leftshow").show();
    $("#leftshow").css("height",leftshowHeight);
    $("#leftshow").css("display","inline");
    $("#right").css("width","98%");
    changeRightTable();
}

///���Ұ�ť
function search(){ 
    var StDate="",EndDate=""
    //�����ڲ�ѯ
    var SelDate =0;
    $("input[type=checkbox][name=SelDate]").each(function(){
		if($(this).is(':checked')){
			SelDate =this.value;	
		}
	})
	if (SelDate==1){
    	StDate=$('#StartDate').getDate(); //��ʼ����
    	EndDate=$('#EndDate').getDate();  //��������

		if ((StDate=="")||(EndDate=="")){
			
			$("#showalert").show();
		    $("#showalertcontent").show();
		    $("#mymessage").html("��ѡ��ʼ�������������");
			return;  
		}
	}
	/// ��ѯ�����б�
  	$('#nuraddorderTb').dhccNurQuery({
		query:{
			EpisodeID:EpisodeID, //$('#admId').val(),
			StartDate:$('#StartDate input').val(),
			EndDate:$('#EndDate input').val(),
			LgLocID:LgCtLocID,
			SelDate:SelDate,
			PriorCode:'',
    		TabType:'',
    		Moeori:'',
    		NurOrd:''

			}
	}) 
}

//˫��ģ������
function addRowByTemp(arcitemId, tempitmCov){
	
	if (GetDocPermission(arcitemId) == 1){
		$.messager.alert("��ʾ:","��û��Ȩ��¼���ҽ����");
		return;
	}
	
	runClassMethod("web.DHCEMNurAddOrder","GetArcItemInfoByArcID",{'EpisodeID':EpisodeID, 'arcitemId':arcitemId},function(jsonString){		   		 
   		
   		if(jsonString != null){
	   		var rowData = jsonString;
	   		insertRowData(rowData, tempitmCov); /// ��������  bianshuai 2017-03-24
	   	}
	},"json",false)
}

/// ҳ���ʼ������
function LoadPageDefault(){
	
    var iframe='<iframe scrolling="yes" width=101% height=305px frameborder="0" src="dhcem.nuraddordertemp.csp?EpisodeID='+EpisodeID+'"></iframe>';
    $("#Cont").html(iframe);
}

///  =================================���·ֿ�����ģ�����==================================
///  bianshuai 2017-01-04
var editRow = "";    /// ��ǰ�༭�к�
var ArcColumns = "";
var ComColumns = ""; /// �÷���Ƶ�Ρ��Ƴ�
var priorCode = "";
var TakOrdMsg = "";  /// ��ʾ��Ϣ
var PatType = "";    /// ��������
var tempindex = "";
var AvaQtyFlag = 0;  /// ����־

/// ҳ���ʼ������
function initPageDefault(){

	initPageStyle(); 	  /// ��ʼ��������ʽ����
		
	InitPatEpisodeID();   /// ��ʼ�����ز��˾���ID
	GetPatBaseInfo();     /// ���ز�����Ϣ
	
	initVersion(); 	      /// ��ʼ������汾��ʾ

	initPageDatePicker(); /// ��ʼ��ҳ�����ڿؼ�
	initPatOrderList();   /// ��ʼ������ҽ���б�
	initPageTemp();       /// ��ʼ��ҳ��ģ������
	runClassMethod("web.DHCEMCommonUtil","DateFormat",{},  //hxy 2017-03-07 ���ڸ�ʽ������
	function(data){
			initItemList(data); 	  /// ҳ��DataGrid
	});
	//initItemList(); 	  /// ҳ��DataGrid
	initColumns();        /// ��ʼ��datagrid��
	
	initPatNotTakOrdMsg(); /// ��֤�����Ƿ�����ҽ��

	validateIsLock();
	
}
//����ر�ȡ����
window.onbeforeunload = function(){
  	runClassMethod("web.DHCBillLockAdm","UnLockOPAdm",{"admStr":EpisodeID,"lockType":""},  //hxy 2017-03-07 ���ڸ�ʽ������
	function(retStr){},"text",false);
}

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
	VersionNo = getParam("VersionNo");
	TabType = getParam("TabType");	/// ��ʿִ��ҳǩ����
	NurMoeori = getParam("Moeori"); /// ��ʿѡ����ҽ��ID
}

/// ��ʼ������汾��ʾ
function initVersion(){
	
	if (VersionNo == 1){
		lefthide();
	}
	priorCode = "NORM";
}

/// ��ʼ��datagrid��
function initColumns(){
	
	ArcColumns = [[
		{field:'arcitemId',hidden:true},
		{field:'arcitmdesc',title:'ҽ������',width:220},
		{field:'arcitmcode',title:'ҽ������',width:100},
		{field:'arcitmprice',title:'ҽ���۸�',width:100},
		{field:'recLocID',title:'����id',hidden:true},
		{field:'recLocDesc',title:'���տ���',width:120},
	]];
	
	ComColumns = [[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Desc',title:'����',width:200},
		{field:'Code',title:'����',width:100}
	]];
}


///  ���ز�����Ϣ
function GetPatBaseInfo(){
	
	runClassMethod("web.DHCEMNurAddOrder","GetPatEssInfo",{'EpisodeID':EpisodeID},function(data){

		if (data != null){
	   		var htmlstr = "";
	   		htmlstr = htmlstr + '<span id="PatientID" style="display:none;">' + data.PatientID + '</span>';
	   		htmlstr = htmlstr + '<span id="mradm" style="display:none;">' + data.mradm + '</span>';
	   		htmlstr = htmlstr + '<span id="PatType" style="display:none;">' + data.PatType + '</span>';
			htmlstr = htmlstr + "���ǼǺ�:" + data.PatNo + '<span class="patother">|</span>';
			htmlstr = htmlstr + "����:" + data.PatBed + '<span class="patother">|</span>';
			htmlstr = htmlstr + "����:" + data.PatName + '<span class="patother">|</span>';
			htmlstr = htmlstr + "�Ա�:" + data.PatSex + '<span class="patother">|</span>';
			htmlstr = htmlstr + "�������ڣ�" + data.PatBDay + '<span class="patother">|</span>';
			htmlstr = htmlstr + "����:" + data.PatAge + '<span class="patother">|</span>';
			htmlstr = htmlstr + "������:" + data.PatMedNo + '<span class="patother">|</span>';
		    htmlstr = htmlstr + "��" + "<b style='color:red;font-size:15px;padding-right:20px;'>" + data.BillType + "</b>";
			$("#info span").html(htmlstr);
			PatType = data.PatType;  /// ��������
		}
		
	},"json",false)
}

/// ��ʼ��ҳ�����ڿؼ�
function initPageDatePicker(){
	
	/// ��������
	$("#EndDate").dhccDate();
	//$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))	
	/// ��ʼ����
	$("#StartDate").dhccDate();
	runClassMethod("web.DHCEMCommonUtil","DateFormat",{},  //hxy 2017-03-07 ���ڸ�ʽ������
				function(data){
					//data=3
					if(data==3){
						$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))
						$("#StartDate").setDate(new Date().Format("yyyy-MM-dd"))   
				    }else if(data==4){
					    $("#StartDate").setDate(new Date().Format("dd/MM/yyyy"));
					    $("#EndDate").setDate(new Date().Format("dd/MM/yyyy"));	
					}else{
						return;
					}
				});
	//$("#StartDate").setDate(new Date().Format("yyyy-MM-dd"))
}

/// ��ʼ��ҳ��ģ������
function initPageTemp(){
	
	LoadPageDefault(); //��ʼ��,��ʼ���ظ���ģ��
}

/// ��ʼ������ҽ���б�
function initPatOrderList(){

	var columns = [
		{title:'ѡ��',checkbox:true},
		{field:'arcitmdesc',title:'ҽ������'},
		{field:'SeqNo',title:'���',align:'center'},
		{field:'OrderDate',title:'ҽ������',align:'center'},
		{field:'OrderTime',title:'ҽ��ʱ��',align:'center'},
		{field:'OrderDocDesc',title:'��ҽ��ҽ��',align:'center'},
		{field:'OrderStartDate',title:'��ʼ����',align:'center'},
		{field:'OrderStartTime',title:'��ʼʱ��',align:'left'},
		{field:'ordPrior',title:'ҽ������',align:'center'},
		{field:'OrderFreq',title:'Ƶ��',align:'center'},
		{field:'OrderInstr',title:'�÷�',align:'center'},
		{field:'OrderDurt',title:'�Ƴ�',align:'center'},
		{field:'OrderDoseQty',title:'����',align:'center'},
		{field:'OrderDepProcNote',title:'��ע',align:'center'},
		{field:'recLoc',title:'���տ���',align:'center'},
		{field:'arcimid',title:'ҽ����ID'},
		{field:'moeori',title:'moeori'},
		{field:'oeori',title:'oeori'}
		];
		
    $('#nuraddorderTb').dhccTable({
	    formatShowingRows:function(pageFrom, pageTo, totalRows){
		    return "�� "+pageFrom+" ���� "+pageTo+" ����¼���� "+totalRows+" ����¼"
		},
	    formatRecordsPerPage:function(pageNumber){return ''},
	    height:$(window).height()-121, //202, //-122,2017-03-16
	    singleSelect: false,
	    clickToSelect:false,
	    //pageSize:11,
	    //pageList:[50,100],
        url: 'dhcapp.broker.csp?ClassName=web.DHCEMNurAddOrder&MethodName=QueryPatOrderItems',
        columns: columns,
        queryParam:{
			EpisodeID:EpisodeID,
    		StartDate:'',
    		EndDate:'',
    		PriorCode:'',
    		TabType:TabType,
    		Moeori:NurMoeori,
    		NurOrd:'',
    		LgLocID:LgCtLocID,
    		SelDate:0
		},
		onCheck:function(row, $element){
			var curIndex=$element.attr("data-index");
			if (tempindex != ""){
				return;
			}else{
				tempindex = curIndex;
			}
			CheckLinkOrd(curIndex, row,0);
		},
		onUncheck:function(row, $element){
			/// ��ǰ������
			var curIndex=$element.attr("data-index");
			if (tempindex != ""){
				return;
			}else{
				tempindex = curIndex;
			}
			CheckLinkOrd(curIndex, row,1);
		},
		onClickRow:function(row, $element){
			/// ��ǰ������
			var curIndex=$element.attr("data-index");
			var flag = 0;
			/// �������ѡ��/ȡ��
			if ($element.hasClass("selected")){
				flag = 1;
				$('#nuraddorderTb').dhccTableM('uncheck',curIndex);
			}else{
				$('#nuraddorderTb').dhccTableM('check',curIndex);
			}
			tempindex = curIndex;
			CheckLinkOrd(curIndex, row, flag);
		}
    })
}

/// ����ѡ�й���
function CheckLinkOrd(rowIndex, rowData,check){
	
	var rowsData = $("#nuraddorderTb").dhccTableM('getData');
	for(var m=0;m<rowsData.length;m++){

		if(m==rowIndex){
			continue;
		}
		if (rowData.moeori == rowsData[m].moeori){
			var selects= $("#nuraddorderTb").dhccTableM('getSelections');
			var selectFlag=0;
			for(j=0;j<selects.length;j++){
				if(selects[j].oeori==rowsData[m].oeori){selectFlag=1}
			}
			if(check==1){
				if (selectFlag == 1){
					$('#nuraddorderTb').dhccTableM('uncheck',m);
				}
			}else{
				if (selectFlag == 0){
					$('#nuraddorderTb').dhccTableM('check',m);
					moeori = rowsData[m].moeori;
				}
			}
		}else{
			if(check==0){
				$('#nuraddorderTb').dhccTableM('uncheck',m);
			}
		}
	}
	//if (check == 0){
		tempindex = "";
	//}
}

/// ����Ŀdatagrid�󶨵���¼�
function dataGridBindEnterEvent(index){

	var editors = $('#dgOrdList').datagrid('getEditors', index);
	for(var i=0; i< editors.length; i++){
		var workRateEditor = editors[i];
		if (!workRateEditor.target.next('span').has('input').length){
			workRateEditor.target.bind('click', function(e){
				$('#dgOrdList').datagrid('selectRow',index);
			});
		}else{
			workRateEditor.target.next('span').find('input').bind('click', function(e){
				$('#dgOrdList').datagrid('selectRow',index);
			});
		}
	}

	var editors = $('#dgOrdList').datagrid('getEditors', index);
	/// �����Ŀ����
	var workRateEditor = editors[2];
	workRateEditor.target.focus();  ///���ý���
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var tr = $(this).closest("tr.datagrid-row");
			editRow = tr.attr("datagrid-row-index");
			var ed=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'ItmDesc'});		
			var EntryAlias = $(ed.target).val();
			if (EntryAlias == ""){return;}
			var unitUrl = 'dhcapp.broker.csp?ClassName=web.DHCEMNurAddOrder&MethodName=JsonQryArcNurAddOrder&EpisodeID='+EpisodeID+'&LgGroupID='+LgGroupID+'&LgUserID='+LgUserID+'&LgLocID='+LgCtLocID+'&EntryAlias='+EntryAlias;
			/// ����ҽ�����б���
			new ListComponentWin($(ed.target), EntryAlias, "600px", "" , unitUrl, ArcColumns, setCurrArcEditRowCellVal).init();
		}
	});
	
	/// ����
	var workRateEditor = editors[3];
	workRateEditor.target.bind('keyup', function(e){  /// keydown - > keyup
		
		//if (e.keyCode == 13) {
			
			/// ȡ¼������	
			var ed=$("#dgOrdList").datagrid('getEditor',{index:index, field:'PackQty'}); 	
			var pQty = $(ed.target).val();
			
			/// ��ȡ����������
			var rowsData = $('#dgOrdList').datagrid('getRows');
			var rowData = rowsData[index];
			
			/// ҽ����ID
			var ed=$("#dgOrdList").datagrid('getEditor',{index:index, field:'ItmID'}); 	
			var ItmID = $(ed.target).val();
			
			/// ���տ���
			var ed=$("#dgOrdList").datagrid('getEditor',{index:index, field:'recLocID'}); 	
			var recLocID = $(ed.target).val();
			
			/// ��λID
			var ed=$("#dgOrdList").datagrid('getEditor',{index:index, field:'PUomID'}); 	
			var PUomID = $(ed.target).val();
			
			/// �����
			if (GetAvailQtyByArc(ItmID, recLocID, pQty, PUomID) == 0){
				alertMsg("����Ŀ��治��,��˶Կ������ԣ�");
				return;
			}
			
			/// �۸�
			var ed=$("#dgOrdList").datagrid('getEditor',{index:index, field:'Sprice'}); 	
			var Sprice = $(ed.target).val();
			
			/// ��rowsData��ֵ���ڼ���ϼƽ��
			rowsData[index].PackQty=pQty;
			rowsData[index].Sprice=Sprice;
			
			/// ���ºϼƽ��
			var ed=$("#dgOrdList").datagrid('getEditor',{index:index, field:'ItmTotal'}); 	
			$(ed.target).val(Number(Sprice).mul(pQty));
			
			/// ���¼�����
			CalCurPagePatPayed();
		//}
	});
	
	/// �۸�
	var workRateEditor = editors[6];
	workRateEditor.target.bind('keyup', function(e){  /// keydown - > keyup
			
			/// ����	
			var ed=$("#dgOrdList").datagrid('getEditor',{index:index, field:'PackQty'}); 	
			var pQty = $(ed.target).val();
			
			/// �۸�
			var ed=$("#dgOrdList").datagrid('getEditor',{index:index, field:'Sprice'}); 	
			var Sprice = $(ed.target).val();
			
			/// ��ȡ����������
			var rowsData = $('#dgOrdList').datagrid('getRows');
			var rowData = rowsData[index];
			
			/// ��rowsData��ֵ���ڼ���ϼƽ��
			rowsData[index].PackQty=pQty;
			rowsData[index].Sprice=Sprice;
			
			/// ���ºϼƽ��
			var ed=$("#dgOrdList").datagrid('getEditor',{index:index, field:'ItmTotal'}); 	
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
		var editors = $('#dgOrdList').datagrid('getEditors', editRow);
		///ҽ����Ŀ
		var workRateEditor = editors[6];
		return;
	}
	
	/// �Ƿ������ͬ��Ŀ
	if (isExistSameItem(rowData.arcitemId)){
		$.messager.confirm('��ʾ','������ͬ��Ŀ���Ƿ�������?', function(b){
			if (!b){
				var editors = $('#dgOrdList').datagrid('getEditors', editRow);
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
					var editors = $('#dgOrdList').datagrid('getEditors', editRow);
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
	
	var rowsData = $("#dgOrdList").datagrid('getRows');
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
	var ItmID=$("#dgOrdList").datagrid('getEditor',{index:editRow,field:'ItmID'});
	$(ItmID.target).val(rowData.arcitemId);
	
	/// ҽ������
	var ItmDesc=$("#dgOrdList").datagrid('getEditor',{index:editRow,field:'ItmDesc'});
	$(ItmDesc.target).val(rowData.arcitmdesc);
	    
    /// ���տ���ID
    var recLocID=$("#dgOrdList").datagrid('getEditor',{index:editRow,field:'recLocID'});
	$(recLocID.target).val(rowData.recLocID);
	
	/// ���տ���
    var ed=$("#dgOrdList").datagrid('getEditor',{index:editRow,field:'recLoc'});
	$(ed.target).combobox('setValue', rowData.recLocDesc);
	
	/// ����װ��λid
	var billuomID=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'PUomID'});
	$(billuomID.target).val(rowData.billuomID);
	
	/// ����װ��λ 
	var ed = $('#dgOrdList').datagrid('getEditor',{index:editRow, field:'PUomDesc' });
    $(ed.target).combobox('setValue', rowData.billuomDesc);
    
    /// ����
	var OrderPackQty=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'PackQty'});
	$(OrderPackQty.target).val(rowData.pQty);
	
	/// �ѱ�
	var BillTypeRowid=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'BillTypeID'});
	$(BillTypeRowid.target).val(rowData.BillTypeRowid);
	
	/// �ѱ�
	var BillTypeRowid=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'BillType'});
	$(BillTypeRowid.target).combobox('setValue', rowData.BillType);
	
	/// �۸�
	var Price=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'Sprice'});
	$(Price.target).val(rowData.arcitmprice);
	if (rowData.OrderType != "P"){
		$(Price.target).attr("disabled", true);
	}
	
	/// ���
	var Total=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'ItmTotal'});
	$(Total.target).val(Number(rowData.arcitmprice).mul(rowData.pQty));
	if (rowData.OrderType != "P"){
		$(Total.target).attr("disabled", true);
	}
	
	/// ҽ�����ȼ�ID
	var ed=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'ItmPriorID'});
	$(ed.target).val(rowData.ItmPriorID);

	/// ҽ������
	var Price=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'OrderType'});
	$(Price.target).val(rowData.OrderType);
	
	/// ��ȡ����������
	var rowsData = $('#dgOrdList').datagrid('getRows');
	/// ��rowsData��ֵ���ڼ���ϼƽ��
	rowsData[editRow].PackQty = rowData.pQty;
	rowsData[editRow].Sprice = rowData.arcitmprice;
			
	/// ���¼�����
	CalCurPagePatPayed();
}

/// ҳ��DataGrid
function initItemList(recdata){

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
				var ed=$("#dgOrdList").datagrid('getEditor',{index:modRowIndex,field:'PUomID'});
				$(ed.target).val(option.value);
				var ed=$("#dgOrdList").datagrid('getEditor',{index:modRowIndex,field:'PUomDesc'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed = $("#dgOrdList").datagrid('getEditor', { index: modRowIndex, field: 'ItmID'});
				var arcitemId = $(ed.target).val();
				if(arcitemId != ""){
					var ed = $("#dgOrdList").datagrid('getEditor', { index: modRowIndex, field: 'PUomDesc'});
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
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				///��������ֵ
				var ed=$("#dgOrdList").datagrid('getEditor',{index:modRowIndex,field:'recLocID'});
				$(ed.target).val(option.value);
				var ed=$("#dgOrdList").datagrid('getEditor',{index:modRowIndex,field:'recLoc'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed = $("#dgOrdList").datagrid('getEditor', { index: modRowIndex, field: 'ItmID'});
				var arcitemId = $(ed.target).val();
				if(arcitemId != ""){
					var ed = $("#dgOrdList").datagrid('getEditor', { index: modRowIndex, field: 'recLoc'});
					$(ed.target).combobox('reload','dhcapp.broker.csp?ClassName=web.DHCEMNurAddOrder&MethodName=jsonExaCatRecLocNew&EpisodeID='+EpisodeID+'&ItmmastID='+arcitemId);
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
				var ed=$("#dgOrdList").datagrid('getEditor',{index:modRowIndex,field:'BillTypeID'});
				$(ed.target).val(option.value);
				var ed=$("#dgOrdList").datagrid('getEditor',{index:modRowIndex,field:'BillType'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed = $("#dgOrdList").datagrid('getEditor', { index: modRowIndex, field: 'BillType'});
				$(ed.target).combobox('reload','dhcapp.broker.csp?ClassName=web.DHCEMNurAddOrder&MethodName=jsonGetPatBillType&PatType=E&EpisodeID='+EpisodeID);
			}
		}
	}
						
	///  ����columns
	var columns=[[
		{field:'Select',title:'ѡ��',width:40,align:'center',formatter:SetCellCheckBox},
		//{field:'ItmXuNo',title:'���',width:35,align:'center'},
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
		title : 'ҽ���б�' + '<span id="allPay" style="float:right">�ϼƽ�0.00</span>',
		border : false,
		rownumbers : true,
		singleSelect : true,
		pagination: false,
		checkOnSelect:true,
		selectOnCheck:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    	/*
	    	/// �Ѿ���˵�ҽ���������ٴα༭
	    	if (rowData.ItmOeori != "") return;
	    	
            if (editRow != ""||editRow == 0) { 
                $("#dgOrdList").datagrid('endEdit', editRow); 
            }
            $("#dgOrdList").datagrid('beginEdit', rowIndex); 
                
            editRow = rowIndex;
            */
        },
		onLoadSuccess:function(data){
			CalCurPagePatPayed(); /// �����ܷ���
		}
	};

	var params = "rows=50&page=1&EpisodeID="+EpisodeID+"&StartDate=&EndDate=&LgLocID="+LgCtLocID;
	var uniturl = "dhcapp.broker.csp?ClassName=web.DHCEMNurAddOrder&MethodName=QueryPatOrderItmsByLoc&"+params;
	new ListComponent('dgOrdList', columns, uniturl, option).Init();
}

/// ��ѡ��
function SetCellCheckBox(value, rowData, rowIndex){

	var html = '<input name="ItmCheckBox" type="checkbox" value='+rowIndex+'></input>';
    return html;
}

// ��������
function insertRow(){

	/// ��ǰ���һ���Ƿ���������
	var rowsData = $("#dgOrdList").datagrid('getRows');
	var LastEditRow = rowsData.length - 1;
	if(LastEditRow >= 0){
		var ed=$("#dgOrdList").datagrid('getEditor',{index:LastEditRow,field:'ItmDesc'});
		if (ed != null){
			if ($(ed.target).val() == "") return;
		}
	}

	var ItmXuNo = 1;  /// ���
	var rowsData = $("#dgOrdList").datagrid('getRows');
	if (rowsData != null){
		ItmXuNo = rowsData.length + 1;
	}
	
	/// ��ȡ����ҽ����Ϣ
	var ItmSeqNo = ""; var moeori = "";
	var selects= $("#nuraddorderTb").dhccTableM('getSelections');
	if (selects.length > 0){
		ItmSeqNo = selects[0].SeqNo;
		moeori = selects[0].moeori;
	}

	$("#dgOrdList").datagrid('appendRow',{ //��ָ����������ݣ�appendRow�������һ���������
		ItmXuNo:ItmXuNo, ItmSeqNo:'', ItmPriorID:'', OrderType:'', ItmID:'',
		ItmDesc:'', Sprice:'', PackQty:'', PUomID:'', moeori:'',  ///moeori, ע�� ȡ������ bianshuai 2018-03-19
		PUomDesc:'', recLocID:'', recLoc:'', BillTypeID:'', BillType:'', ItmOeori:'', ItmTotal:''}
	);

	var rowsData = $("#dgOrdList").datagrid('getRows');
	if (rowsData != null){
		$("#dgOrdList").datagrid('beginEdit', rowsData.length - 1);//�����༭������Ҫ�༭����
		editRow = rowsData.length - 1;

		//$('#dgOrdList').datagrid('selectRow',editRow);
	
		/// �༭�а��¼�
		dataGridBindEnterEvent(editRow);
	}
}

// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#dgOrdList").datagrid('getRows');
	for (var index=rowsData.length-1; index >= 0; index--){
		//if ($("[name='ItmCheckBox'][value='"+ index+"']").is(':checked')){
		if ($("tr[datagrid-row-index='"+index+"'] input[name='ItmCheckBox']").is(':checked')){
			if (rowsData[index].ItmOeori == ""){
				/// ɾ����
				$("#dgOrdList").datagrid('deleteRow',index);
			}else{
				InvStopOrder(rowsData[index].ItmOeori); /// ����ͣҽ���ӿ�
			}
		}
	}
	/*
	/// ˢ���б�����
	var selItems=$("#dgOrdList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		$('#dgOrdList').datagrid('refreshRow', index);
		/// �����༭������Ҫ�༭����
		//$("#dgOrdList").datagrid('beginEdit', index);
		/// �༭�а��¼�
		//dataGridBindEnterEvent(index);
	})
	*/
	/// ����ϼƽ��
	CalCurPagePatPayed();
}

/// ͣҽ������
function InvStopOrder(Oeori){

	runClassMethod("web.DHCEMNurAddOrder","InvStopOrder",{"Oeori":Oeori, "LgUserID":LgUserID},function(jsonString){
		if(jsonString == 0){
			$('#dgOrdList').datagrid('reload'); //���¼���
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
	var rowsData = $("#dgOrdList").datagrid('getRows');
	for(var m=0;m<rowsData.length;m++){
		$("#dgOrdList").datagrid('endEdit', m);
	}
	
	var rowsData = $("#dgOrdList").datagrid('getChanges');
	if(rowsData.length<=0){
		$("#showalert").show();
		$("#showalertcontent").show();
		$("#mymessage").html("û�д���������!");
		return;
	}

	var dataList = [];

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
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("&&");

	if(mListData == ""){
		$("#showalert").show();
		$("#showalertcontent").show();
		$("#mymessage").html("û�д���������!");
		return;
	}
	
	/// סԺ��������Ѻ�����
	var PatArrManMsg = GetPatArrManage();
	if (PatArrManMsg != ""){
		$("#showalert").show();
		$("#showalertcontent").show();
		$("#mymessage").html(PatArrManMsg);
		return;	
	}
	
	//��������
	runClassMethod("web.DHCEMNurAddOrder","SaveOrderItems",{"EpisodeID":EpisodeID, "UserID":LgUserID, "LocID":LgCtLocID, "mListData":mListData},function(jsonString){
		if(jsonString==0){
			$.messager.alert("��ʾ","����ɹ�!"); 
			$('#dgOrdList').datagrid('reload'); //���¼���
		}else{
			$.messager.alert("��ʾ","����ʧ��!"); 
		}
	});
}

/// �ܷ���
function CalCurPagePatPayed(){
	
	var total = 0;
	var rowsData = $("#dgOrdList").datagrid('getRows');
	if (rowsData != null){
		for(var i=0;i<rowsData.length;i++){
			var spamt = Number(rowsData[i].Sprice).mul(rowsData[i].PackQty);
		    total = Number(total).add(spamt);
		}
	    var htmlStr = "�ϼƽ�"+"<span id='mypatpay'>"+total+"</span>"
		$("#allPay").html(htmlStr);
	}
}

/// ����ҽ��
function copyRow(){

	/// ѡ��ҽ��
	var rowsData = $('#nuraddorderTb').bootstrapTable('getSelections');
	for (var m=0; m < rowsData.length; m++ ){
		if (rowsData[m].arcimid != ""){
			if (GetDocPermission(rowsData[m].arcimid) == 1){
				$.messager.alert("��ʾ:","��û��Ȩ��¼���ҽ����");
				continue;
			}
	 		insertCopyRow(rowsData[m].oeori);
		}
	}
}

/// ��ȡҽ��¼ҽ��Ȩ��
function GetDocPermission(arcitemId){

	var DocPerFlag = 0;
	/// ����ҽ��¼ҽ��Ȩ��
	runClassMethod("web.DHCAPPExaReport","GetDocPermission",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgCtLocID,"EpisodeID":EpisodeID,"arcitemId":arcitemId},function(jsonString){

		if (jsonString == 1){
			DocPerFlag = jsonString;
		}
	},'',false)

	return DocPerFlag;
}

/// ���븴����
function insertCopyRow(oeori){

	runClassMethod("web.DHCEMNurAddOrder","GetPatOeoriInfo",{'EpisodeID':EpisodeID, 'oeori':oeori},function(jsonString){		   		 
   		
   		if(jsonString != null){
	   		var rowData = jsonString;
	   		insertRow();					   /// ���ӿ��� bianshuai 2017-01-06
	   		setCurrArcEditRowCellVal(rowData); /// ����ͳһ������ݺ��� bianshuai 2017-01-06
	   	}
	},"json")
}

/// ����ҽ��
function linkRow(){
	
	var rowsData = $('#nuraddorderTb').bootstrapTable('getSelections');
	if (rowsData == null){
		$.messager.alert("��ʾ","����ѡ�����ҽ��!"); 
		return;
	}

	var moeori = rowsData[0].moeori;
	var rowsData = $("#dgOrdList").datagrid('getRows');
	for (var index=0; index < rowsData.length; index++){
		if ($("[name='ItmCheckBox'][value='"+ index+"']").is(':checked')){
			if (rowsData[index].ItmOeori == ""){
				/// ɾ����
				rowsData[index].moeori = moeori;
			}
		}
	}
	$.messager.alert("��ʾ","�����ɹ�!"); 
	return;
}

/// ��ȡ���˵���ϼ�¼��
function GetMRDiagnoseCount(){

	var Count = 0;
	/// ����ҽ��վ���ж�
	runClassMethod("web.DHCAPPExaReport","GetMRDCount",{"EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonString != ""){
			Count = jsonString;
		}
	},'',false)

	return Count;
}

/// ������ϴ���
function DiagPopWin(){
	
	var PatientID = $("#PatientID").text();  /// ����ID
	var mradm = $("#mradm").text();			 /// �������ID

	var lnk = "diagnosentry.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
	//window.open(lnk,"_blank","top=100,left=100,width=700,height=350,menubar=yes,scrollbars=no,toolbar=no,status=no");
	window.showModalDialog(lnk, "_blank", "dialogHeight: " + (top.screen.height - 100) + "px; dialogWidth: " + (top.screen.width - 100) + "px");
}

/// ��֤�����Ƿ�����ҽ��
function initPatNotTakOrdMsg(){
	
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
	runClassMethod("web.DHCAPPExaReport","GetPatNotTakOrdMsg",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgCtLocID,"EpisodeID":EpisodeID},function(jsonString){

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
	runClassMethod("web.DHCAPPExaReport","GetArrearsManage",{"EpisodeID":EpisodeID,"LgGroupID":LgGroupID,"LgLocID":LgCtLocID,"amount":amount},function(jsonString){

		if (jsonString != ""){
			PatArrManMsg = jsonString;
		}
	},'',false)

	return PatArrManMsg;
}

/// ���¼�������
function CalPackQty(index){
	
	var editors = $('#dgOrdList').datagrid('getEditors', index);
	if (editors != null){
		var dosQty = 0;    /// ����
		var uomID = $(editors[8].target).val();     /// ��λ
		var freqID = $(editors[10].target).val();   /// Ƶ��
		var DurID = $(editors[14].target).val();    /// �Ƴ�
		var PUomID = $(editors[18].target).val();   /// ����װ��λ
		var ListData = dosQty +"^"+ uomID +"^"+ freqID +"^"+ DurID +"^"+ PUomID;
		runClassMethod("web.DHCEMNurAddOrder","GetPackQty",{"ListData":ListData},function(resValue){
			if (resValue != ""){
				$(editors[17].target).val(resValue);
			}
		},'',false)
	}
}

/// ȡHis����ά����ʾ��ʽ bianshuai 2017-03-10
function GetSysDateToHtml(HtDate){

	runClassMethod("web.DHCAPPExaRepCom","GetSysDateToHtml",{"HtDate":HtDate},function(jsonString){
		HtDate = jsonString;
	},'',false)
	return HtDate;
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
	/*
	/// ���
	var ItmTotal = (Number(rowData.pQty)*Number(rowData.arcitmprice)).toFixed(2); 
	
	$("#dgOrdList").datagrid('appendRow',{ //��ָ����������ݣ�appendRow�������һ���������
		ItmXuNo:ItmXuNo, ItmSeqNo:ItmSeqNo, ItmPriorID:rowData.ItmPriorID, OrderType:rowData.OrderType, ItmID:rowData.arcitemId,
		ItmDesc:rowData.arcitmdesc, Sprice:rowData.arcitmprice, PackQty:rowData.pQty, PUomID:rowData.billuomID, moeori:moeori,
		PUomDesc:rowData.billuomDesc, recLocID:rowData.recLocID, recLoc:rowData.recLocDesc, BillTypeID:rowData.BillTypeID, BillType:rowData.BillType, ItmOeori:'', ItmTotal:ItmTotal}
	);
	
	var rowsData = $("#dgOrdList").datagrid('getRows');
	if (rowsData != null){
		$("#dgOrdList").datagrid('beginEdit', rowsData.length - 1);//�����༭������Ҫ�༭����
		editRow = rowsData.length - 1;
	
		/// �༭�а��¼�
		dataGridBindEnterEvent(editRow);
	}
	
	/// ����ϼƽ��
	CalCurPagePatPayed(); 
	*/
}

/// ������
function insertRowCon(rowData){

	var ItmXuNo = 1;  /// ���
	var rowsData = $("#dgOrdList").datagrid('getRows');
	if (rowsData != null){
		ItmXuNo = rowsData.length + 1;
	}

	/// ��ȡ����ҽ����Ϣ
	var ItmSeqNo = ""; var moeori = "";
	var selects= $("#nuraddorderTb").dhccTableM('getSelections');
	if (selects.length > 0){
		ItmSeqNo = selects[0].SeqNo;
		moeori = selects[0].moeori;
	}
	
	/// ���
	var ItmTotal = (Number(rowData.pQty)*Number(rowData.arcitmprice)).toFixed(2); 
	
	$("#dgOrdList").datagrid('appendRow',{ //��ָ����������ݣ�appendRow�������һ���������
		ItmXuNo:ItmXuNo, ItmSeqNo:'', ItmPriorID:rowData.ItmPriorID, OrderType:rowData.OrderType, ItmID:rowData.arcitemId,
		ItmDesc:rowData.arcitmdesc, Sprice:rowData.arcitmprice, PackQty:rowData.pQty, PUomID:rowData.billuomID, moeori:'', /// moeori, ע�� ȡ������ bianshuai 2018-03-19
		PUomDesc:rowData.billuomDesc, recLocID:rowData.recLocID, recLoc:rowData.recLocDesc, BillTypeID:rowData.BillTypeID, BillType:rowData.BillType, ItmOeori:'', ItmTotal:ItmTotal}
	);
	
	var rowsData = $("#dgOrdList").datagrid('getRows');
	if (rowsData != null){
		$("#dgOrdList").datagrid('beginEdit', rowsData.length - 1);//�����༭������Ҫ�༭����
		editRow = rowsData.length - 1;
		
		if (rowData.OrderType != "P"){
			/// �������÷Ǳ༭״̬
			var Ed=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'Sprice'});
		    $(Ed.target).attr("disabled", true);
		    /// �ܽ�����÷Ǳ༭״̬
		    var Ed=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'ItmTotal'});
		    $(Ed.target).attr("disabled", true);
		}
	
		/// �༭�а��¼�
		dataGridBindEnterEvent(editRow);
	}
	
	/// ����ϼƽ��
	CalCurPagePatPayed(); 
}

/// ��̬ɾ��ѡ����Ŀ
function delRowByTemp(arcitmid){
	
	var rowsData = $("#dgOrdList").datagrid('getRows');
	for (var index=rowsData.length-1; index >= 0; index--){
		if ((rowsData[index].ItmID == arcitmid)&(rowsData[index].ItmOeori == "")){
			/// ɾ����
			$("#dgOrdList").datagrid('deleteRow',index);
		}
	}
	/// ����ϼƽ��
	CalCurPagePatPayed(); 
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

/// �����Ŀ�Ƿ�������
function beforeSaveCheck(){
	
	var resFlag = true;
	var rowsData = $("#dgOrdList").datagrid('getRows');
	for(var m=0;m<rowsData.length;m++){
		if (rowsData[m].ItmOeori != "") continue;
		
		/// ȡ¼������	
		var ed=$("#dgOrdList").datagrid('getEditor',{index:m, field:'PackQty'}); 	
		var pQty = $(ed.target).val();
		
		/// ҽ����ID
		var ed=$("#dgOrdList").datagrid('getEditor',{index:m, field:'ItmID'}); 	
		var ItmID = $(ed.target).val();
		
		/// ҽ����
		var ed=$("#dgOrdList").datagrid('getEditor',{index:m, field:'ItmDesc'}); 	
		var ItmDesc = $(ed.target).val();
		
		/// ���տ���
		var ed=$("#dgOrdList").datagrid('getEditor',{index:m, field:'recLoc'}); 
		var recLoc = $(ed.target).combobox('getValue');
		var ed=$("#dgOrdList").datagrid('getEditor',{index:m, field:'recLocID'}); 	
		var recLocID = $(ed.target).val();
		if (recLocID == ""){
			alertMsg("ҽ����"+ ItmDesc + "���տ���Ϊ��,����д���տ��Һ����ԣ�");
			resFlag = false;
			break;	
		}
		
		/// ��λID
		var ed=$("#dgOrdList").datagrid('getEditor',{index:m, field:'PUomID'}); 	
		var PUomID = $(ed.target).val();

		/// ����������
		if (GetStkLockFlag(ItmID, recLocID) == "Y"){
			alertMsg("ҽ����"+ ItmDesc + " �Ѿ���"+ recLoc +"����������Ҫ����ϵҩ��������Ա��");
			resFlag = false;
			break;	
		}
		
		/// �����
		if (GetAvailQtyByArc(ItmID, recLocID, pQty, PUomID) == 0){
			alertMsg("ҽ����"+ ItmDesc + " ��治��,��˶Կ������ԣ�");
			resFlag = false;
			break;	
		}
		
		/// ��ҽ���Ƿ��Ѿ�ֹͣ
		if (isMoeoriStop(rowsData[m].moeori) != 0){
			alertMsg("ҽ����"+ ItmDesc + " ������ҽ���Ѿ�ֹͣ,���ʵ�����ԣ�");
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

//�ж��Ƿ������ҽ�� (����OrderItemRowid)
function CheckIsItem(rowid){
	var id=parseInt(rowid);
	if($.isNumeric(id)==true){
		var OrderItemRowid=id.ItmOeori
		if(OrderItemRowid != ""){
			return true;
		}else{
			return false;
		}
	}else{
		return false;
	}
}
/// ҳ��alert��ʽ�������ù���alert,���ӽ������
function alertMsg(msg){
	$("#showalert").show();
	$("#showalertcontent").show();
	$("#mymessage").html(msg);
}

$.fn.dhccNurQuery=function(_options){
	$(this).bootstrapTable('refresh',_options);
	$(this).bootstrapTable('getOptions').queryParams=function(params){
		   	tmp={
				limit: params.limit,   //ҳ���С  
  				offset: params.offset,  //
  				page:params.pageNumber
		   	}
		   	
		   	if(_options){
			   	try{
				   	if(_options.hasOwnProperty('query')){
					   	tmp=$.extend(tmp,_options.query)
					}
			   	}catch(e){}
		   	}
		   	return tmp;  
	}
	try{
		$(this).bootstrapTable('refreshOptions',{pageNumber:1,pageSize:15});
	}catch(e){}
}
	
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
