//�����Ŀ,��λ���շ������ά��js
//sufan  2016/07/21
var editRow = ""; editTRow = ""; var PartColumns=""; var ArcColumns="";
var PartUrl = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonPart';
var ArcUrl = LINK_CSP+'?ClassName=web.DHCAPPTreeAdd&MethodName=QueryArcItmDetail';

/// ҳ���ʼ������
function initPageDefault(){
	
	initArcItemList();       ///  ��ʼҳ��DataGrid�����Ŀ,��λ�б�
	initBlButton();          ///  ҳ��Button���¼�
	initColumns();
	
}

/// ��ʼ��datagrid��
function initColumns(){
	
	PartColumns = [[
	    {field:'PartDesc',title:'��λ',width:200},
	    {field:'LastPartDesc',title:'����λ',width:200},
		{field:'PartID',title:'PartID',width:100}
	]];
	
	ArcColumns = [[
	    {field:'itmDesc',title:'ҽ��������',width:220},
	    {field:'itmCode',title:'ҽ�������',width:100},
	    {field:'itmPrice',title:'����',width:100},
		{field:'itmID',title:'itmID',width:80}
	]];
}

///�����Ŀ,��λ�б� 
function initArcItemList(){
	
	 // ���Ұ�ť�󶨵����¼�
	$('#find').bind('click',function(event){
         commonQuery(); //���ò�ѯ
    })
    
	//���ð�ť�󶨵����¼�
	$('#reset').bind('click',function(event){
		$('#code').val("");
		$('#desc').val("");
		$('#partdesc').val("");
		commonQuery(); //���ò�ѯ
	})		
	
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	/// ��λ��
	var textTreeEditor={
		type:'combotree',
		options:{
			url:'dhcapp.broker.csp?ClassName=web.DHCAPPPart&MethodName=getTreeCombo',    
	        onSelect:function(record){    
	            var ed=$("#arcItemList").datagrid('getEditor',{index:editRow,field:'ItemPartID'});
				$(ed.target).val(record.id);  // ��鲿λID   
	        }
		}
	}
	
	///  ����columns
	var columns=[[
		{field:'ItemID',title:'�����ĿID',width:100,hidden:true,editor:textEditor},
		{field:'ItemDesc',title:'�����Ŀ',width:200,editor:textEditor},
		{field:'ItemPartID',title:'��λID',width:100,hidden:true,editor:textEditor},
		{field:'ItemPart',title:'��λ',width:150,editor:textEditor},
		{field:"AlRowID",title:'ID',hidden:true,editor:textEditor}
	]];
	
	///  ����datagrid  
	var option = {
		rownumbers : true,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
			$('#arctardatagrid').datagrid('reload',{pointer: rowData.ItemID,PartID:rowData.ItemPartID});
			$('#FindTarItemList').datagrid('reload',{arcimid: rowData.ItemID,PartID:rowData.ItemPartID});
			$('#PostionList').datagrid('reload',{ArcRowId: rowData.ItemID,PartID:rowData.ItemPartID});
	    },
	    onDblClickRow: function (rowIndex, rowData) {// ˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#arcItemList").datagrid('endEdit', editRow); 
            } 
            $("#arcItemList").datagrid('beginEdit', rowIndex); 
            dataArcGridBindEnterEvent(rowIndex);  //���ûس��¼�
            editRow = rowIndex;
        }
	};

	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPArclinkTar&MethodName=QueryArcLink";
	new ListComponent('arcItemList', columns, uniturl, option).Init(); 
}


/// ҳ�� Button ���¼�
function initBlButton(){
	
	///  ���Ӽ����Ŀ,��λ
	$('#arctb a:contains("����")').bind("click",insertArcRow);
	
	///  ��������Ŀ,��λ
	$('#arctb a:contains("����")').bind("click",saveArc);
	
	///  ɾ�������Ŀ,��λ
	$('#arctb a:contains("ɾ��")').bind("click",deleteArcRow);
	
	///�س��¼� sufan   2016/08/03
	$('#desc').bind('keypress',function(event){
		if(event.keyCode == "13"){
			var unitUrl = ArcUrl + "&Input="+$('#desc').val();
			/// ����ҽ�����б�����
			new ListComponentWin($('#desc'), "", "600px", "" , unitUrl, ArcColumns, setCurrEditRowCellVal).init();
		}
	});
}

///��ѯ��ťҽ������Ӧ����
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		$('#desc').focus().select();  ///���ý��� ��ѡ������
		return;
	}
	$('#desc').val(rowObj.itmDesc);  /// ҽ����
}

/// ��������Ŀ��λ��
function insertArcRow(){
	if(editRow>="0"){
		$("#arcItemList").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#arcItemList").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {}
	});
	$("#arcItemList").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
	
	var rows = $("#arcItemList").datagrid('getRows');
	if (rows.length != "0"){
		dataArcGridBindEnterEvent(0);  //���ûس��¼�
	}
}
///��������Ŀ��λ
function saveArc(){
	
	if(editRow>="0"){
		$("#arcItemList").datagrid('endEdit', editRow);
	}
	var rowsData = $("#arcItemList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].ItemID=="")||(rowsData[i].ItemDesc=="")){
			$.messager.alert("��ʾ","�����Ŀ����Ϊ�գ�"); 
			return false;
		}
		if ((rowsData[i].ItemPartID=="")||(rowsData[i].ItemPart=="")){
			$.messager.alert("��ʾ","��λ����Ϊ�գ�"); 
			return false;
			}  //sufan  2017-1-23
		var tmp=rowsData[i].AlRowID+"^"+rowsData[i].ItemID+"^"+rowsData[i].ItemDesc+"^"+rowsData[i].ItemPartID+"^"+ rowsData[i].ItemPart;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCAPPArclinkTar","SaveArcLink",{"params":params},function(jsonString){
		if(jsonString==0){
			$.messager.alert("��ʾ","����ɹ�!"); 
			$('#arcItemList').datagrid('reload'); //���¼���
		}
		if(jsonString==-10){
			$.messager.alert("��ʾ","�����ظ�!"); 
			$('#arcItemList').datagrid('reload'); //���¼���
		}
	});
}

/// ɾ�������Ŀ,��λѡ����
function deleteArcRow(){
	
	var rowsData = $("#arcItemList").datagrid('getSelected'); //ѡ��Ҫɾ������
	var rowsTarData=$("#arctardatagrid").datagrid("getRows"); // �ж��շ���datagrid�Ƿ�������  sufan  2017-1-23
	if (rowsTarData.length>1){
		$.messager.alert('��ʾ','����ɾ���������շ���','warning');
		return false;
		}
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPArclinkTar","DeleteArcLink",{"AlRowID":rowsData.AlRowID},function(jsonString){
					$('#arcItemList').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}	 
///�����շ����б�
function addRow(){
	var rowsMData = $("#arcItemList").datagrid('getSelected'); //ѡ����ߵļ����Ŀ����λ��
	if (rowsMData == null){
		$.messager.alert("��ʾ", "��ѡ������Ŀ&��λ��");
		return;
	}
	// sufan ����˫��ʱ���رգ��ٵ����ӣ����ɱ༭
	var e = $("#arctardatagrid").datagrid('getColumnOption', 'PartNum');
	e.editor = {type:'numberbox',options:{required:true}};
	var e = $("#arctardatagrid").datagrid('getColumnOption', 'TarStart');
	e.editor = {type:'datebox',options:{required:true}};
	var e = $("#arctardatagrid").datagrid('getColumnOption', 'TarDesc');
	e.editor = {type:'combogrid',options:{
										required : true,
										id:'AORowId',
										fitColumns:true,
										fit: true,//�Զ���С
										pagination : true,
										panelWidth:600,
										textField:'desc', 
										mode:'remote',
										url:'dhcapp.broker.csp?ClassName=web.DHCAPPPosLinkTar&MethodName=QueryTar',
										columns:[[
												{field:'tarId',hidden:true},
												{field:'code',title:'����',width:60},
												{field:'desc',title:'����',width:100},
												{field:'price',title:'�շ���۸�',width:40}
												]],
												onSelect:function(rowIndex, rowData) {
			                   					fillValue(rowIndex, rowData);
			                				}	
										}
									};

	commonAddRow({'datagrid':'#arctardatagrid',value:{'ArcId':rowsMData.ItemID,'BaseFlag':'Y','PartNum':1,'TarStart':new Date().Format("yyyy-MM-dd"),'PartID':rowsMData.ItemPartID}})
}

///����Ǻϼ���,���ܱ༭
function onClickRowDisc(index,row){
	if(row.TarCode=="�ϼ�:") return;
	var e = $("#arctardatagrid").datagrid('getColumnOption', 'TarDesc');
	e.editor = {};
	var e = $("#arctardatagrid").datagrid('getColumnOption', 'PartNum');
	e.editor = {};
	var e = $("#arctardatagrid").datagrid('getColumnOption', 'TarStart');
	e.editor = {};
	CommonRowClick(index,row,"#arctardatagrid");
}

///�б༭
function onClickRow(index,row){
	
	 CommonRowClick(index,row,"#PostionList");
}

///�������
function addRowPos(){
	
	var rowsMData = $("#arcItemList").datagrid('getSelected'); //ѡ����ߵļ����Ŀ����λ��
	if (rowsMData == null){
		$.messager.alert("��ʾ", "��ѡ������Ŀ&��λ��","warning");
		return;
	}
	commonAddRow({'datagrid':'#PostionList',value:{'ArcDr':rowsMData.ItemID,'PartID':rowsMData.ItemPartID}})  
}

///ɾ�� 
function cancelPos(){
	
	if ($("#PostionList").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
	    if (r){
		    var row =$("#PostionList").datagrid('getSelected');     
			 runClassMethod("web.DHCAppArcLinkPos","remove",{'Id':row.ID},function(data){ $('#PostionList').datagrid('load'); })
	    }    
	}); 
}

/// ����
function savePos(){
	
	saveByDataGrid("web.DHCAppArcLinkPos","save","#PostionList",function(data){
			if(data==0){
				$("#PostionList").datagrid('reload')
			}else if(data == -1){
				$.messager.alert('��ʾ','�����ظ�����:'+data)
				$("#PostionList").datagrid('reload')
			}else{
				$.messager.alert('��ʾ','����ʧ�ܣ�'+data)
			}
		});	
}

///�����շ����б�
function save(){
	saveByDataGrid("web.DHCAPPArclinkTar","save","#arctardatagrid",function(data){
		if(data==0){
			$.messager.alert('��ʾ','����ɹ�')
			$('#arctardatagrid').datagrid('reload')
			$('#FindTarItemList').datagrid('reload')
		}else if(data==-11){
			$.messager.alert('��ʾ','��ʼʱ����ڽ���ʱ��')
			$('#arctardatagrid').datagrid('reload')
		}else if(data==-12){
			$.messager.alert('��ʾ','�����������ڽ���')
			$('#arctardatagrid').datagrid('reload')
		}else{
			$.messager.alert('��ʾ','����ʧ��:'+data)
			$('#arctardatagrid').datagrid('reload')
		}
	})
}
/// ɾ���շ���ѡ����
function deleteTarRow(){
	
	var rowsData = $("#arctardatagrid").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPArclinkTar","DeleteArclinkTar",{"AltRowID":rowsData.ID},function(jsonString){
					$('#arctardatagrid').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
///����ȡֵ����
function fillValue(rowIndex, rowData){
	$('#arctardatagrid').datagrid('getRows')[editIndex]['TarDr']=rowData.tarId
	$('#arctardatagrid').datagrid('getRows')[editIndex]['TarCode']=rowData.code
	$('#arctardatagrid').datagrid('getRows')[editIndex]['TarPrice']=rowData.price
}
 
/// �������Ŀ,��λdatagrid�󶨻س��¼�
function dataArcGridBindEnterEvent(index){
	
	var editors = $('#arcItemList').datagrid('getEditors', index);
	/// �����Ŀ����
	var workRateEditor = editors[1];
	workRateEditor.target.focus();  ///���ý���
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#arcItemList").datagrid('getEditor',{index:index, field:'ItemDesc'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var unitUrl = ArcUrl + "&Input="+$(ed.target).val();
			/// ����ҽ�����б�����
			new ListComponentWin($(ed.target), input, "600px", "" , unitUrl, ArcColumns, setCurrArcEditRowCellVal).init();
		}
	});
	
	/// ��鲿λ����
	var workRateEditor = editors[3];
	//workRateEditor.target.focus();  ///���ý���
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#arcItemList").datagrid('getEditor',{index:index, field:'ItemPart'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var unitUrl = PartUrl + "&PartName="+$(ed.target).val();
			/// ���ò�λ�б�����
			new ListComponentWin($(ed.target), input, "600px", "" , unitUrl, PartColumns, setCurrArcEditRowCellVal).init();
		}
	});
}

/// ����ǰ�༭�и�ֵ(�����Ŀ)
function setCurrArcEditRowCellVal(rowObj){
	if (rowObj == null){
		var editors = $('#arcItemList').datagrid('getEditors', editRow);
		///�����Ŀ
		var workRateEditor = editors[1];
		workRateEditor.target.focus().select();  ///���ý��� ��ѡ������
		return;
	}
	if (typeof rowObj.itmDesc != "undefined"){
		/// ��Ŀ����
		var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'ItemDesc'});
		$(ed.target).val(rowObj.itmDesc);
		/// ��Ŀ����ID
		var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'ItemID'});		
		$(ed.target).val(rowObj.itmID);
	}else{
		/// ��λ����
		var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'ItemPart'});
		$(ed.target).val(rowObj.PartDesc);
		/// ��λID
		var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'ItemPartID'});		
		$(ed.target).val(rowObj.PartID);
	}
}

//��չ datagrid combogrid ���Ե�editor 2016-07-24
$(function(){
	 $.extend($.fn.datagrid.defaults.editors, {
			combogrid: {
				init: function(container, options){
					var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container); 
					input.combogrid(options);
					return input;
				},
				destroy: function(target){
					$(target).combogrid('destroy');
				},
				getValue: function(target){
					return $(target).combogrid('getText');
				},
				setValue: function(target, value){
					$(target).combogrid('setValue', value);
					
				},
				resize: function(target, width){
					$(target).combogrid('resize',width);
				}
			}
	});
})
/// ��ҽ���������ѯ����
function commonQuery() 
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var part=$('#partdesc').val();
	var param=code+"^"+desc+"^"+part;
	$('#arcItemList').datagrid('load',{params:param}); 
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })