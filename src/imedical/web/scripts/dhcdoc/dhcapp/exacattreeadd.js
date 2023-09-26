var GV={}  ;//���ȫ�ֱ���
var editRow = ""; var arcColumns=""; var PartColumns=""; var nodeArr=[]; var count = 0; var partEditRow="";
var ItemTypeArr = [{"value":"E","text":'���'}, {"value":"L","text":'����'}, {"value":"P","text":'����'}];;

/// ҳ���ʼ������
function InitHosp(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_APP_Exacattreeadd",hospStr);
	hospComp.jdata.options.onSelect= function(){
		initPageDefault()
	} 
	initPageDefault();
	initBlButton();      /// ҳ�� Button ���¼�
}
function initPageDefault(){
	GV.maxHeight=$(window).height()||550;
	GV.maxWidth=$(window).width()||1366;
	
	initColumns();       /// ��ʼ��datagrid�б�
	initSymLevTree();    /// ��ʼ����������
	initDataGrid();      /// ҳ��DataGrid��ʼ����
	
    LoadPageBaseInfo();  /// ��ʼ�����ػ�������  

    initPartDataGrid();  /// ҳ��DataGrid��ʼ����
    initCombobox();      /// ҳ��Combobox��ʼ����
    initMenuSecurityWin();
    <!-- �¾ɰ汾�������� -->
    if (version != 1){
	    /// �ɰ�ʱ,���ز�λ�б���
		$('#mainpanel').layout('hidden','east');
		/// ��ʾ���Ӳ�λѡ��˵�
		$("div[onclick='newCreatePart()']").attr("style","");
		///�ɰ�ʱ,�ı��Ҽ����ĸ߶�
		$("#right").attr("style","height:200px;");
	}
}
/// ��ʼ��datagrid�б�
function initColumns(){
	
	arcColumns = [[
	    {field:'itmDesc',title:'ҽ��������',width:220},
	    {field:'itmCode',title:'ҽ�������',width:100},
	    //{field:'itmPrice',title:'����',width:100},
		{field:'itmID',title:'itmID',width:80,hidden:true}
	]];
	
	PartColumns = [[
	    {field:'PartDesc',title:'��λ����',width:100},
	    {field:'LastPartDesc',title:'�ϼ���λ',width:80},
		{field:'PartID',title:'PartID',width:100,hidden:true}
	]];
}

///  ��ʼ�����ػ�������
function LoadPageBaseInfo(){

	/// �������б�
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryCheckItemList";
	$("#itemlist").datagrid({url:uniturl});
}

/// ��������
function initSymLevTree(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	<!-- �¾ɰ汾�������� -->
	var uniturl = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeID&id=0&HospID='+HospID;
	if (version == 1){
		uniturl = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeIDNew&id=0&HospID='+HospID;
	}
	var option = {
		multiple:true,
		lines:true,
		animate:true,
		dnd:true,
        onClick:function(node, checked){
	        var isLeaf = $("#itemCat").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
		        var itemCatID = node.id; 		/// ������ID
				var params = itemCatID;
				$("#itemlist").datagrid("load",{"params":params});
				$("#partlist").datagrid("loadData",{"total":0,"rows":[]});
	        }else{
		    	//$("#itemCat").tree('toggle',node.target);   /// �����Ŀʱ,ֱ��չ��/�ر�
		    }
	    }, 
		onContextMenu: function(e, node){
			
			e.preventDefault();
			var node = $("#itemCat").tree('getSelected');
			if (node == null){
				$.messager.alert("��ʾ","��ѡ�нڵ������!"); 
				return;
			}
			// ��ʾ��ݲ˵�
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
		onLoadSuccess: function(node, data){
			
			for (var i=0;i<nodeArr.length;i++){
				var node = $('#itemCat').tree('find', nodeArr[i]);
				if (node != null){
					$('#itemCat').tree('expand', node.target);
					count = count + 1;
				}
			}
			if (count == nodeArr.length+1){
				nodeArr=[];
			}
		},
		onBeforeDrop: function(target, source, point){
			
			if (point == "append") return false;
			var id = $('#itemCat').tree("getNode",target).id;
			if (!moveTree(id +"^"+ source.id+"^"+point)){
				return false;
			}
			//console.log("onDragEnter"+$('#itemCat').tree("getNode",target).id+"-"+source.id+"-"+point)
			
		},
		onStopDrag: function(node){
			
			//console.log("onStopDrag"+node.id)
			
		}
	};
	new CusTreeUX("itemCat", uniturl, option).Init();
}

/// ҳ��DataGrid��ʼ����
function initDataGrid(){
	
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	/// ҽ����
	var boxArcEditor = {
		type:'combogrid',
		options:{
		    id:'itmID',
		    fitColumns:true,
		    fit: true,//�Զ���С  
			pagination : true,
			panelWidth:500,
			textField:'itmDesc',
			mode:'remote',
			url:LINK_CSP+'?ClassName=web.DHCAPPTreeAdd&MethodName=QueryArcItmDetail&HospID='+$HUI.combogrid('#_HospList').getValue(),
			columns:arcColumns,
				onSelect:function(rowIndex, rowData) {
   					setCurrArcEditRowCellVal(rowData);
				}		   
			}
		}
		
	///  ����columns
	var columns=[[
		{field:'ItemCode',title:'����',width:100,editor:textEditor},
		{field:'ItemDesc',title:'ҽ����',width:260,editor:boxArcEditor},
		{field:'ItemID',title:'ItemID',width:100,hidden:true,editor:textEditor},
		{field:'ItemPartID',title:'ItemPartID',width:100,editor:textEditor,hidden:true},
		{field:'TraID',title:'TraID',width:100,hidden:true},
		{field:'TraItmID',title:'TraItmID',width:100,hidden:true},
		{field:'ItemPriority',title:'���ȼ�',width:160,align:'center',formatter:SetCellUrl},
		{field:'ItemOrdNum',title:'˳���',width:100,hidden:true}
	]];
	
	///  ����datagrid
	var option = {
		rownumbers : false,
		singleSelect : true,
		showPageList : false,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != "") {  //||editRow == 0
                $("#itemlist").datagrid('endEdit', editRow); 
            } 
            $("#itemlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex;
            dataArcGridBindEnterEvent(rowIndex);  //���ûس��¼�
            
        },
        onClickRow: function(rowIndex, rowData){
	        var TraID = rowData.TraID;
	        var ItemID = rowData.ItemID;
			/// �������б�
			var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryCheckPartList&TraID="+TraID+"&ItemID="+ItemID;
			$("#partlist").datagrid({url:uniturl});
	    },
	    onBeginEdit: function(rowIndex, rowData){
		    var ItemCodeObj=$(this).datagrid('getEditor', {index:rowIndex,field:'ItemCode'});
			ItemCodeObj.target[0].disabled=true;
		}
	};
	
	var uniturl = "";
	new ListComponent('itemlist', columns, uniturl, option).Init();
}

/// ���ƺ�����
function SetCellUrl(value,row,index){
	
	if(value==undefined){   //2016-07-18 qunianpeng
		value="" ;
	}	
	html="<a class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveUp("+index+")'>"
	html=html+"<span class='l-btn-left'><span class='l-btn-text icon-up l-btn-icon-left'>����</span></span>"
	html=html+"</a><span style='margin:0px 10px;'> </span>"
	html=html+"<a class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveDown("+index+")'>"
	html=html+"<span class='l-btn-left'><span class='l-btn-text icon-down l-btn-icon-left'>����</span></span>"
	html=html+"</a>"
	html=html+"<span style='display:none;'>"+value+"</span>"
	return html;
}

/// ����
function moveUp(index){
	move(true,index)
}

/// ����
function moveDown(index){
	move(false,index)
}

/// �ƶ�
function move(isUp,index) {

	var newrow = "";
	if(isUp){
		var newrow=parseInt(index)-1;  /// ����
	}else{
		var newrow=parseInt(index)+1;  /// ����
	}
	var TrsRow = $("#itemlist").datagrid('getData').rows[index];
	var TrsID = TrsRow.TraItmID;
	var LastRow =$("#itemlist").datagrid('getData').rows[newrow];
	var LastID = LastRow.TraItmID;
	var mListData = TrsID +"^"+ LastID;
    runClassMethod("web.DHCAPPTreeAdd","moveTreeLink",{'mListData':mListData},function(jsonString){
		if (jsonString != 0){
			$.messager.alert("��ʾ","�ƶ�����!"); 
			return;
		}else{
			moveTreeLink(isUp, index, 'itemlist'); /// �ƶ�������
		}
 	})
}

/// �ƶ�������
function moveTreeLink(isUp, index, gridname){
	
    if (isUp) {

        if (index != 0) {
			var nextrow=parseInt(index)-1 ;
			var lastrow=parseInt(index);
            var toup = $('#' + gridname).datagrid('getData').rows[lastrow];
            var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
            $('#' + gridname).datagrid('getData').rows[lastrow] = todown;
            $('#' + gridname).datagrid('getData').rows[nextrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    }else{
        var rows = $('#' + gridname).datagrid('getRows').length;
        if (index != rows - 1) {
		    var nextrow=parseInt(index)+1 ;
			var lastrow=parseInt(index);
            var todown = $('#' + gridname).datagrid('getData').rows[lastrow];
            var toup = $('#' + gridname).datagrid('getData').rows[nextrow];
            $('#' + gridname).datagrid('getData').rows[nextrow] = todown;              
            $('#' + gridname).datagrid('getData').rows[lastrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    }
}

/// ҳ��DataGrid��ʼ����
function initPartDataGrid(){
	
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	/// ��λ
	var boxPartEditor = {
		type:'combogrid',
		options:{
		    id:'PartID',
		    fitColumns:true,
		    fit: true,//�Զ���С  
			pagination : true,
			panelWidth:460,
			textField:'PartDesc',
			mode:'remote',
			url:LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonPart&ShowAllPart=1',
			columns:PartColumns,
				onSelect:function(rowIndex, rowData) {
   					setCurrPartEditRowCellVal(rowData);
				}		   
			}
		}
		
	///  ����columns
	var columns=[[
		{field:'ItemPart',title:'��λ',width:320,editor:boxPartEditor},
		{field:'ItemPartID',title:'ItemPartID',width:100,editor:textEditor,hidden:true},
		{field:'ItemID',title:'ItemID',width:100,hidden:true},
		{field:'TraID',title:'TraID',width:100,hidden:true},
		{field:'TraItmID',title:'TraItmID',width:100,hidden:true}
	]];
	
	///  ����datagrid
	var option = {
		rownumbers : false,
		singleSelect : true,
		showPageList : false,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (partEditRow != "") { //||partEditRow == 0
                $("#partlist").datagrid('endEdit', partEditRow); 
            } 
            $("#partlist").datagrid('beginEdit', rowIndex); 
            
            partEditRow = rowIndex;
            dataPartGridBindEnterEvent(rowIndex);  //���ûس��¼�
        }
	};
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryCheckPartList&TraID=&ItemID=";;
	new ListComponent('partlist', columns, uniturl, option).Init();
}

/// ҳ�� Button ���¼�
function initBlButton(){
	
	///  ���Ӽ����Ŀ,��λ
	$('#arctb a:contains("����")').bind("click",insertRow);
	
	///  ��������Ŀ,��λ
	$('#arctb a:contains("����")').bind("click",saveRow);
	
	///  ɾ�������Ŀ,��λ
	$('#arctb a:contains("ɾ��")').bind("click",deleteRow);
	
	///  ��ȫ����Ȩ
	$('#arctb a:contains("��Ȩ")').bind("click",openAuth);
	
	///  ���Ӽ����Ŀ,��λ
	$('#parttb a:contains("����")').bind("click",insPartRow);
	
	///  ��������Ŀ,��λ
	$('#parttb a:contains("����")').bind("click",savePartRow);
	
	///  ɾ�������Ŀ,��λ
	$('#parttb a:contains("ɾ��")').bind("click",delPartRow);
	
	///  ƴ����
	//$("#ExaCatCode").bind("keyup",findExaItmTree);
	$('#ExaCatCode').searchbox({
		searcher : function (value, name) {
			var PyCode=$.trim(value);
			findExaItmTree(PyCode);
		}
	});
	
	///  ����
	$('#icw_bt a:contains("����")').bind("click",saveCat);
	
	///  ȡ��
	$('#icw_bt a:contains("ȡ��")').bind("click",closeWin);
	
	///  ����
	$('#pw_bt a:contains("����")').bind("click",savePart);
	
	///  ȡ��
	$('#pw_bt a:contains("ȡ��")').bind("click",closePartWin);
	
	///  ����
	$('#uicw_bt a:contains("����")').bind("click",updTreeCat);
	
	///  ȡ��
	$('#uicw_bt a:contains("ȡ��")').bind("click",closeItmCatWin);
	
	///  ��λ����
	$('#PartDesc').bind('keypress',function(event){
		if(event.keyCode == "13"){
			if ($('#PartDesc').val() == "") return;
			var unitUrl = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonPart&PartName='+$('#PartDesc').val()+"&ShowAllPart=1";
			/// ���ò�λ�б���
			new ListComponentWin($('#PartDesc'), "", "600px", "" , unitUrl, PartColumns, setCurrEditRowCellVal).init();
		}
	});
	
	///  ��������
	$('#ItemDesc,#TraItmDesc').bind('keypress',function(event){
		if(event.keyCode == "13"){
			//if ($('#ItemDesc').val() == "") return;
			//GetTreeCatAlias(this.id);
		}
	});
	
	///  ��������
	$('#ItemDesc,#TraItmDesc').bind('blur',function(event){
		//GetTreeCatAlias(this.id);
	});
	
	///  ҽ��������
	$('#ItmmastDesc').bind('keypress',function(event){
		if(event.keyCode == "13"){
			if ($('#ItmmastDesc').val() == "") return;
			var HospID=$HUI.combogrid('#_HospList').getValue();
			var unitUrl = LINK_CSP+'?ClassName=web.DHCAPPTreeAdd&MethodName=QueryArcItmDetail&Input='+$('#ItmmastDesc').val()+"&HospID="+HospID;
			/// ���ò�λ�б���
			new ListComponentWin($('#ItmmastDesc'), "", "600px", "" , unitUrl, arcColumns, setArcCurrEditRowCellVal).init();
		}
	});
}

/// ���Ҽ����Ŀ��
function findExaItmTree(PyCode){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if (PyCode == ""){
		<!-- �¾ɰ汾�������� -->
	    if (version != 1){
			/// �ɰ�
			var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeID&id=0&HospID='+HospID;
	    }else{
			/// �°�
			var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeIDNew&id=0&HospID='+HospID;
		}
	}else{
		<!-- �¾ɰ汾�������� -->
	    if (version != 1){
		    /// �ɰ�
			var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByPyCode&PyCode='+PyCode+'&HospID='+HospID;
		}else{
			/// �°�
			var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByPyCodeNew&PyCode='+PyCode+'&HospID='+HospID;
		}
	}
	
	$("#itemCat").tree('options').url =encodeURI(url);
	$("#itemCat").tree('reload');
}

/// ��������Ŀ��λ��
function insertRow(){
	
	var node = $("#itemCat").tree('getSelected');
	if (!node){
		$.messager.alert("��ʾ","��ѡ��������Ŀ��������Ӳ���!"); 
        return;
    }
	var isLeaf = $("#itemCat").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
    if (!isLeaf){
		$.messager.alert("��ʾ","��ѡ��������Ŀ��������Ӳ���!"); 
        return;
    }
    if (node.id.indexOf("^") != "-1"){
    	var TraID = node.id.split("^")[0];
    	var PartID = node.id.split("^")[1];
    }else{
		var TraID = node.id;
		var PartID = "";
	}
	
	if(editRow>="0"){
		$("#itemlist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#itemlist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ItemPartID:PartID, TraID:TraID, TraItmID:""}
	});
	$("#itemlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
	
	var rows = $("#itemlist").datagrid('getRows');
	if (rows.length != "0"){
		dataArcGridBindEnterEvent(0);  //���ûس��¼�
	}
}

/// �������Ŀ,��λdatagrid�󶨻س��¼�
function dataArcGridBindEnterEvent(index){
	
	var editors = $('#itemlist').datagrid('getEditors', index);
	/// �����Ŀ����
	var workRateEditor = editors[1];
	workRateEditor.target.focus();  ///���ý���
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var HospID=$HUI.combogrid('#_HospList').getValue();
			var ed=$("#itemlist").datagrid('getEditor',{index:index, field:'ItemDesc'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var unitUrl = LINK_CSP+'?ClassName=web.DHCAPPTreeAdd&MethodName=QueryArcItmDetail&Input='+$(ed.target).val()+"&HospID="+HospID;
			/// ����ҽ�����б���
			new ListComponentWin($(ed.target), input, "600px", "" , unitUrl, arcColumns, setCurrArcEditRowCellVal).init();
		}
	});
	/*
	/// ��鲿λ����
	var workRateEditor = editors[2];
	//workRateEditor.target.focus();  ///���ý���
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#itemlist").datagrid('getEditor',{index:index, field:'ItemPart'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var unitUrl = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonPart&PartName='+$(ed.target).val();
			/// ���ò�λ�б���
			new ListComponentWin($(ed.target), input, "600px", "" , unitUrl, PartColumns, setCurrArcEditRowCellVal).init();
		}
	});
	*/
}


/// �������Ŀ,��λdatagrid�󶨻س��¼�
function dataPartGridBindEnterEvent(index){
	
	var editors = $('#partlist').datagrid('getEditors', index);
	/// ��鲿λ����
	var workRateEditor = editors[0];
	workRateEditor.target.focus();  ///���ý���
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#partlist").datagrid('getEditor',{index:index, field:'ItemPart'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var unitUrl = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonPart&PartName='+$(ed.target).val()+"&ShowAllPart=1";
			/// ���ò�λ�б���
			new ListComponentWin($(ed.target), input, "450px", "" , unitUrl, PartColumns, setCurrPartEditRowCellVal).init();
		}
	});
}

/// ����ǰ�༭�и�ֵ(�����Ŀ)
function setCurrArcEditRowCellVal(rowObj){
	if (rowObj == null){
		var editors = $('#itemlist').datagrid('getEditors', editRow);
		///�����Ŀ
		var workRateEditor = editors[1];
		workRateEditor.target.focus().select();  ///���ý��� ��ѡ������
		return;
	}

	if (typeof rowObj.itmDesc != "undefined"){
		/// ��Ŀ����
		//var ed=$("#itemlist").datagrid('getEditor',{index:editRow, field:'ItemDesc'});
		//$(ed.target).val(rowObj.itmDesc);
		/// ��Ŀ����
		var ed=$("#itemlist").datagrid('getEditor',{index:editRow, field:'ItemCode'});		
		$(ed.target).val(rowObj.itmCode);
		/// ��Ŀ����ID
		var ed=$("#itemlist").datagrid('getEditor',{index:editRow, field:'ItemID'});		
		$(ed.target).val(rowObj.itmID);

		/// ������һ����
		//var ed=$("#itemlist").datagrid('getEditor',{index:editRow, field:'ItemPart'});
		//ed.target.focus();  ///���ý���;
	}else{
		/// ��λ����
		var ed=$("#itemlist").datagrid('getEditor',{index:editRow, field:'ItemPart'});
		$(ed.target).val(rowObj.PartDesc);
		/// ��λID
		var ed=$("#itemlist").datagrid('getEditor',{index:editRow, field:'ItemPartID'});		
		$(ed.target).val(rowObj.PartID);
	}
}

/// ����ǰ�༭�и�ֵ(��鲿λ)
function setCurrPartEditRowCellVal(rowObj){
	if (rowObj == null){
		var editors = $('#partlist').datagrid('getEditors', partEditRow);
		///�����Ŀ
		var workRateEditor = editors[0];
		workRateEditor.target.focus().select();  ///���ý��� ��ѡ������
		return;
	}

	/// ��λ����
	var ed=$("#partlist").datagrid('getEditor',{index:partEditRow, field:'ItemPart'});
	$(ed.target).val(rowObj.PartDesc);
	/// ��λID
	var ed=$("#partlist").datagrid('getEditor',{index:partEditRow, field:'ItemPartID'});		
	$(ed.target).val(rowObj.PartID);
}

///��������Ŀ��λ
function saveRow(){
	
	if(editRow>="0"){
		$("#itemlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#itemlist").datagrid('getChanges');
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
		var tmp=rowsData[i].TraID+"^"+rowsData[i].ItemID+"^"+rowsData[i].ItemPartID+"^"+rowsData[i].TraItmID;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");

	//��������
	runClassMethod("web.DHCAPPTreeAdd","SaveTraTreeLink",{"version":version, "params":params},function(jsonString){
		if(jsonString==0){
			$.messager.alert("��ʾ","����ɹ�!"); 
			$('#itemlist').datagrid('reload'); //���¼���
		}
		if(jsonString==-1){
			$.messager.alert("��ʾ","�����ظ�!"); 
			$('#itemlist').datagrid('reload'); //���¼���
		}
		if(jsonString==-2){
			$.messager.alert("��ʾ","ҽ�����Ѿ���Ӧ��λ������ɾ����λ!"); 
			$('#itemlist').datagrid('reload'); //���¼���
		}
	});
}

///��Ȩ
function openAuth () {
	var selected = $("#itemlist").datagrid('getSelected');
	if (!selected) {
		$.messager.alert('��ʾ','��ѡ��һ�м�¼��','warning');
		 return;
	}
	var caption = selected.ItemDesc;
	var name = selected.ItemCode;
	var id = selected.TraItmID;
	$('#menu-security-win-search').searchbox('setValue','');
    //$('#menu-security-win').find('.i-searchbox tr').eq(0).find('input').val(caption);
    $('#menu-security-win-caption').text(caption);
    //$('#menu-security-win').find('.i-searchbox tr').eq(1).find('input').val(name);
    $('#menu-security-win-name').text(name);
    $('#menu-security-win-id').val(id);
    $('#menu-security-win-list').datagrid('options').url='websys.Broker.cls';
    //alert(id)
    $('#menu-security-win-list').datagrid('unselectAll').datagrid('load',{ClassName:'web.DHCAppTreeGroup',QueryName:'QryArcimAuth',MenuID:id,GroupDesc:''});
    $('#menu-security-win').dialog('open');
	
	
}

/// ɾ�������Ŀ,��λѡ����
function deleteRow(){

	var rowsData = $("#itemlist").datagrid('getSelected'); /// ѡ��Ҫɾ������
	if (rowsData != null) {
		var TarID = rowsData.TraID;
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����", function (res) {
			/// ��ʾ�Ƿ�ɾ��
			if (res) {
				if (rowsData.TraItmID != ""){
					runClassMethod("web.DHCAPPTreeAdd","DelTreeLink",{"version":version, "TraItmID":rowsData.TraItmID},function(jsonString){
						if (jsonString == "-1"){
							$.messager.alert("��ʾ","����ɾ����λ,��ɾ����Ŀ!"); 
						}else if(jsonString = "0"){
							var rows = $("#itemlist").datagrid('getRows');   ///ֻ��һ����Ŀ��ͬʱˢ����ߵ���  sufan  2017-05-26
							if((rows.length == "1")&&(version != "1")){
									refreshItmCat(TarID);
									$('#itemlist').datagrid('reload');    /// ���¼���
								}else{
										$('#itemlist').datagrid('reload');    /// ���¼���
										}
							}else{
							$('#itemlist').datagrid('reload');    /// ���¼���
						}
					})
				}else{
					var index = $("#itemlist").datagrid('getRowIndex',rowsData); /// ������
					$("#itemlist").datagrid('deleteRow',index);
				}
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// �½����ര��
function newCreateItmCat(type){
	
	var node = $("#itemCat").tree('getSelected');
	if (node.id.indexOf("^") != "-1"){
		$.messager.alert("��ʾ","��ǰ�ڵ�Ϊ��λ�ڵ�,������ӷ���!"); 
        return;
	}
	
	if ((type == "C")&(!isAllowItmCat(node.id))){
		$.messager.alert("��ʾ","�¼��������Ͳ�һ��,'�ǲ�λ����'!"); 
        return;
	}
	
	newCreateItmCatWin(type);      // �½���ѯ����
	InitItmCatDefault(type);   // ��ʼ������Ĭ����Ϣ
}

/// Window ����
function newCreateItmCatWin(type){
	
	/// ���ര��
	var option = {
		modal:false,
		collapsible:false,
		border:true,
		closed:false,
		minimizable:false,
		maximizable:false
	};
	
	var title = "�����ӷ���";
	if (type == "S"){
		title = "����ͬ������";
	}
	
	new WindowUX(title, 'itmCatWin', '400', '280', option).Init();
}

/// ��ʼ������Ĭ����Ϣ
function InitItmCatDefault(type){
	
	$("#ItemDesc").val("");    /// ��������
	$("#ItemAlias").val("");   /// ����
	$("#ItemType").combobox({disabled: false});
	$("#ItemType").combobox('setValue',"");   /// ��������
	var node = $("#itemCat").tree('getSelected');
	
	if (type == "C"){
	    if (node.id.indexOf("^") != "-1"){
			$.messager.alert("��ʾ","��ǰ�ڵ��Ѿ���ĩ���ڵ�,���ܽ������!"); 
	        return;
		}
		$("#LastItmID").val(node.id);
		$("#LastItmDesc").val(node.text);
	}else{
		var node = $("#itemCat").tree('getParent',node.target);
		if (node != null){
			$("#LastItmID").val(node.id);
			$("#LastItmDesc").val(node.text);
		}else{
			$("#LastItmID").val(0);
			$("#LastItmDesc").val(0);
		}
	}
	if(node==null) return false;
	var ItemType = GetNodeType(node.id);
	if (ItemType != ""){
		$HUI.combobox("#ItemType").setValue(ItemType);   /// ��������
		$HUI.combobox("#ItemType").disable(true);
	}
}

/// �½��Ӳ�λ
function newCreatePart(){
	
	var node = $("#itemCat").tree('getSelected');
	if (node.id.indexOf("^") != "-1"){
		$.messager.alert("��ʾ","��ǰ�ڵ�Ϊ��λ�ڵ�,��������¼���λ!"); 
        return;
	}
	
	/*if (!isAllowPart(node.id)){
		$.messager.alert("��ʾ","�¼��������Ͳ�һ��,'�ǲ�λ����'!"); 
        return;
	}*/
	
	newCreatePartWin(); 	// �½���ѯ����
	InitItmPartDefault();   // ��ʼ������Ĭ����Ϣ
}

/// Window ����
function newCreatePartWin(){
	
	/// ��λ��������
	var option = {
		modal:false,
		collapsible:true,
		border:true,
		closed:"true"
	};
	
	new WindowUX('���Ӳ�λ', 'PartWin', '400', '240', option).Init();
}

/// ��ʼ������Ĭ����Ϣ
function InitItmPartDefault(){
	
	$("#PartID").val("");     /// ��λID
	$("#PartDesc").val("");   /// ��λ
	$("#ItmmastID").val("");    /// ҽ����ID
	$("#ItmmastDesc").val("");  /// ҽ����
	var node = $("#itemCat").tree('getSelected');
	$("#LastNodeID").val(node.id);
	$("#LastNodeDesc").val(node.text);
}

/// �½����ര��
function newCreateUpdItmCat(){
	
	var node = $("#itemCat").tree('getSelected');
	if (node.id.indexOf("^") != "-1"){
		$.messager.alert("��ʾ","��ǰ�ڵ�Ϊ��λ�ڵ�,����ʹ�ø���!"); 
        return;
	}
	newCreateUpdItmCatWin();      // �½���ѯ����
	InitUpdItmCatDefault();   // ��ʼ������Ĭ����Ϣ
}

/// Window ����
function newCreateUpdItmCatWin(){
	
	/// ���ര��
	var option = {
		modal:false,
		collapsible:false,
		border:true,
		closed:false,
		minimizable:false,
		maximizable:false
	};
	
	new WindowUX('���·���', 'uItmCatWin', '400', '240', option).Init();
}

/// ��ʼ������Ĭ����Ϣ
function InitUpdItmCatDefault(){
	
	var node = $("#itemCat").tree('getSelected');

	$("#TraItmID").val(node.id);
	$("#TraItmDesc").val(node.text);
	$("#TraItmAlias").val(GetTreeAlise(node.id));
	var ItemType = GetNodeType(node.id);
	if (ItemType != ""){
		$("#TraItmType").combobox('setValue',ItemType);   /// ��������
	}
}

/// �رմ���
function closeWin(){
	$('#itmCatWin').window('close');
}

/// �رմ���
function closePartWin(){
	$('#PartWin').window('close');
}

/// �رմ���
function closeItmCatWin(){
	$('#uItmCatWin').window('close');
}

/// �������
function saveCat(){
	
	var ItemDesc = $("#ItemDesc").val();    /// ��������
	if (ItemDesc == ""){
		$.messager.alert("��ʾ","�������Ʋ���Ϊ��,��ѡ��!"); 
        return;
	}
	var LastItmID = $("#LastItmID").val();  /// �ϼ�����
	if (LastItmID == ""){
		$.messager.alert("��ʾ","�ϼ����಻��Ϊ��,��ѡ��!"); 
        return;
	}
	var ItemAlias = $("#ItemAlias").val();  /// ����
	var ItemType = $("#ItemType").combobox('getValue');  /// ��������
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var mListData =ItemDesc +"^"+ ItemDesc +"^"+ LastItmID +"^"+ ItemAlias +"^"+ HospID +"^"+ ItemType;

	/// ��������
	runClassMethod("web.DHCAPPTreeAdd","InsTraTreeAdd",{"mListData":mListData},function(jsonString){
		if (jsonString == 0){
			//$.messager.alert("��ʾ","����ɹ�!");
			refreshItmCat(LastItmID); /// ˢ�¼�������
			closeWin();  /// �رմ���
		} 
		if(jsonString == "-1"){
		     $.messager.alert("��ʾ","�Ѵ�����ͬ��Ŀ,���ʵ!");
		}

     },'',false)
}

/// �����Ӳ�λ
function savePart(){
	
	var PartID = $("#PartID").val();
	if (PartID == ""){
		$.messager.alert("��ʾ","��λ����Ϊ��,��ѡ��!"); 
        return;
	}
	var ItmmastID = $("#ItmmastID").val();
	if (ItmmastID == ""){
		$.messager.alert("��ʾ","ҽ�����Ϊ��,��ѡ��!"); 
        return;
	}
	var LastNodeID = $("#LastNodeID").val();
	if (LastNodeID == ""){
		$.messager.alert("��ʾ","�ϼ����಻��Ϊ��,��ѡ��!"); 
        return;
	}
	
	var mListData =LastNodeID +"^"+ ItmmastID +"^"+ PartID;

	/// ��������
	runClassMethod("web.DHCAPPTreeAdd","InsTraTreeLink",{"mListData":mListData},function(jsonString){
		if (jsonString == 0){
			//$.messager.alert("��ʾ","����ɹ�!");
			refreshItmCat(LastNodeID); /// ˢ�¼�������
			closePartWin();  /// �رմ���
		} 
		if(jsonString == "-2"){
		     $.messager.alert("��ʾ","�Ѵ�����ͬ��Ŀ,���ʵ!");
		}

     },'',false)
}

///��ѯ��ť��λ����Ӧ����
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		$("#PartDesc").focus().select();  /// ���ý��� ��ѡ������
		return;
	}
	$("#PartID").val(rowObj.PartID);      /// ҽ����
	$("#PartDesc").val(rowObj.PartDesc);  /// ҽ����
	$("#ItmmastDesc").val("");
	$("#ItmmastDesc").focus();   		  /// ���ý���
}

///��ѯ��ťҽ������Ӧ����
function setArcCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		$("#ItmmastDesc").focus().select();  /// ���ý��� ��ѡ������
		return;
	}
	$("#ItmmastID").val(rowObj.itmID);      /// ҽ����ID
	$("#ItmmastDesc").val(rowObj.itmDesc);  /// ҽ����
}

/// ɾ������
function delTreeCat(){

	var node = $("#itemCat").tree('getSelected');
	if (node.id.indexOf("^") != "-1"){
		$.messager.alert("��ʾ","��ǰ�ڵ�Ϊ��λ�ڵ�,����ɾ��!"); 
        return;
	}
	
	$.messager.confirm('ȷ�϶Ի���','ȷ��Ҫɾ���÷�����Ŀ��', function(r){
		if (r){
			/// ɾ������
			runClassMethod("web.DHCAPPTreeAdd","DelTreeAdd",{"TraID":node.id},function(jsonString){
				if (jsonString == 0){
					$('#itemCat').tree('reload');
				}else{
					
				}

		     },'',false)
		}
	});
}

/// ɾ����λ
function delPart(){
	
	var node = $("#itemCat").tree('getSelected');
	var lastnode = $("#itemCat").tree('getParent',node.target);
	$.messager.confirm('ȷ�϶Ի���','ȷ��Ҫɾ���÷�����Ŀ��', function(r){
		if (r){
			/// ɾ������
			runClassMethod("web.DHCAPPTreeAdd","DelTreeAdd",{"TraID":node.id},function(jsonString){
				if (jsonString == 0){
					refreshItmCat(lastnode.id);  /// ˢ�¼�������
				}else{
					
				}

		     },'',false)
		}
	});
}

/// ���½ڵ�����
function updTreeCat(){
	
	var TraID = $("#TraItmID").val();    /// ����ID
	if (TraID == ""){
		$.messager.alert("��ʾ","�������Ʋ���Ϊ��,��ѡ��!"); 
        return;
	}
	
	var TraItmDesc = $("#TraItmDesc").val();    /// ��������
	if (TraItmDesc == ""){
		$.messager.alert("��ʾ","�������Ʋ���Ϊ��,��ѡ��!"); 
        return;
	}
	var TraItmAlias = $("#TraItmAlias").val();  /// ����
	
	var TraItmType = $("#TraItmType").combobox("getValue");  /// ��������  sufan 2018-03-05  
	
	var mListData =TraItmDesc +"^"+ TraItmDesc +"^"+ TraItmAlias +"^"+ TraItmType;

	/// ��������
	runClassMethod("web.DHCAPPTreeAdd","UpdTraTreeAdd",{"TraID":TraID, "mListData":mListData},function(jsonString){
		if (jsonString == 0){
			//$.messager.alert("��ʾ","���³ɹ�!");
			closeItmCatWin();      /// �رո��´���
			refreshItmCat(TraID);  /// ˢ�¼�������
		} 
		if(jsonString == "-2"){
		     $.messager.alert("��ʾ","�Ѵ�����ͬ��Ŀ,���ʵ!");
		}

     },'',false)
}

/// ��ȡ����
function GetTreeCatAlias(id){
	
	var ItemDesc = "";
	if (id == "ItemDesc"){
		ItemDesc = $("#ItemDesc").val();    /// ��������
	}
	if (id == "TraItmDesc"){
		ItemDesc = $("#TraItmDesc").val();    /// ��������
	}
	/// ��������
	runClassMethod("web.DHCAPPTreeAdd","GetTreeCatAlias",{"ItemDesc":ItemDesc},function(jsonString){
		if (jsonString != ""){
			if (id == "ItemDesc"){
				$("#ItemAlias").val(jsonString); 
			}
			if (id == "TraItmDesc"){
				$("#TraItmAlias").val(jsonString); 
			}
		}

    },'',false)
	
}

/// ˢ�¼�������
function refreshItmCat(TraID){

	runClassMethod("web.DHCAPPTreeAdd","GetTarILevCon",{"TraID":TraID},function(jsonString){
		if(jsonString){
			nodeArr = jsonString.split("^");
			count = 0;
		}
	},'',false);
	$('#itemCat').tree('reload');
	return;
}

/// �Ƿ�������Ӳ�λ��Ŀ
/// ��ǰ��Ŀ����Ѿ������¼�����,��������Ӳ�λ
function isAllowPart(TraID){
	
	var retflag = true;
	runClassMethod("web.DHCAPPTreeAdd","isAllowAddPartItem",{"TraID":TraID},function(jsonString){
		if(jsonString == 0){
			retflag = false;
		}
	},'',false);
	return retflag;
}

/// �Ƿ�������ӷ���
/// ��ǰ��Ŀ����Ѿ������¼�����,���´η����ǲ�λ����ʱ��������ӷ�������
function isAllowItmCat(TraID){
	
	var retflag = true;
	runClassMethod("web.DHCAPPTreeAdd","isAllowAddCatItem",{"TraID":TraID},function(jsonString){
		if(jsonString == 1){
			retflag = false;
		}
	},'',false);
	return retflag;
}

/// ɾ������
function delItmCat(){
	
	/// ��ȡ��ǰ�ڵ�
	var node = $("#itemCat").tree('getSelected');
	if (node.id.indexOf("^") != "-1"){
		$.messager.alert("��ʾ","��ǰ�ڵ�Ϊ��λ�ڵ�,����ʹ��ɾ��!"); 
        return;
	}
	
	/// ��ȡ��ǰ�ڵ�ĸ��ڵ�
	var parNode = $("#itemCat").tree('getParent',node.target);

	$.messager.confirm('ȷ�϶Ի���','ȷ��Ҫɾ��������', function(r){
		if (r){
			/// ��������
			runClassMethod("web.DHCAPPTreeAdd","delTraTreeAdd",{"TraID":node.id},function(jsonString){
				if (jsonString == 0){
					if (!parNode){
						$('#itemCat').tree('reload');
					}else{
						refreshItmCat(parNode.id);  /// ˢ�¼�������
					}
				} 
				if(jsonString != "0"){
				     $.messager.alert("��ʾ","ɾ��ʧ��!");
				}

		     },'',false)
		}
	});
}


/// �����鲿λ��
function insPartRow(){

	var rowData = $("#itemlist").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ���鷽��!");
		return;
	}
	var TraID = rowData.TraID;   /// �����ID
	var ItemID = rowData.ItemID; /// ҽ����ID

	if(partEditRow>="0"){
		$("#partlist").datagrid('endEdit', partEditRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#partlist").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].ItemPartID == ""){
			$('#partlist').datagrid('selectRow',0);
			$("#partlist").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			dataPartGridBindEnterEvent(0);  //���ûس��¼�
			return;
		}
	}
	
	$("#partlist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ItemPartID:'', ItemPart:'', ItemID:ItemID, TraID:TraID, TraItmID:''}
	});
	$("#partlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	partEditRow=0;
	
	var rows = $("#partlist").datagrid('getRows');
	if (rows.length != "0"){
		dataPartGridBindEnterEvent(0);  //���ûس��¼�
	}
}

/// ɾ�������Ŀ,��λѡ����
function delPartRow(){
	
	var rowsData = $("#partlist").datagrid('getSelected'); /// ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����", function (res) {
			/// ��ʾ�Ƿ�ɾ��
			if (res) {
				if (rowsData.TraItmID != ""){
					runClassMethod("web.DHCAPPTreeAdd","DelTreeLink",{"TraItmID":rowsData.TraItmID},function(jsonString){
						$('#partlist').datagrid('reload');    /// ���¼���
					})
				}else{
					var index = $("#partlist").datagrid('getRowIndex',rowsData); /// ������
					$("#partlist").datagrid('deleteRow',index);
				}
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

///��������Ŀ��λ
function savePartRow(){
	
	if(partEditRow>="0"){
		$("#partlist").datagrid('endEdit', partEditRow);
	}

	var rowsData = $("#partlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].ItemPartID==""){
			$.messager.alert("��ʾ","��λ����Ϊ�գ�"); 
			return false;
		}
		var tmp=rowsData[i].TraID+"^"+rowsData[i].ItemID+"^"+rowsData[i].ItemPartID+"^"+rowsData[i].TraItmID;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");

	//��������
	runClassMethod("web.DHCAPPTreeAdd","insPartTreeLink",{"params":params},function(jsonString){
		if(jsonString==0){
			$.messager.alert("��ʾ","����ɹ�!"); 
			$('#partlist').datagrid('reload'); //���¼���
		}
		if(jsonString==-1){
			$.messager.alert("��ʾ","�����ظ�!"); 
			$('#partlist').datagrid('reload'); //���¼���
		}
	});
}

/// ҳ��Combobox��ʼ����
function initCombobox(){

	/// ��������
	var option = {
		panelHeight:"auto",
        onSelect:function(option){
	    }
	};
	new ListCombobox("ItemType",'',ItemTypeArr,option).init();
	
	/// ��������  sufan ����ʱʹ��
	var option = {
		panelHeight:"auto",
        onSelect:function(option){
	    }
	};
	new ListCombobox("TraItmType",'',ItemTypeArr,option).init();
}

/// ��ȡ�ڵ�����
function GetNodeType(ID){
	
	var nodeType = "";
	runClassMethod("web.DHCAPPExaReportQuery","GetNodeType",{"ID":ID},function(jsonString){
		nodeType = jsonString;
	},'',false)
	return nodeType;
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

/// ��ȡ������������
function GetTreeAlise(TraID){

	var Tra = "";
	runClassMethod("web.DHCAPPTreeAdd","GetTreeAlise",{"TraID":TraID},function(val){
		if (val != ""){
			TreeAlise = val;
		}
	},'',false)
	return TreeAlise;
}


///��Ȩ����
var initMenuSecurityWin=function(){
	var winH=GV.maxHeight-100;
	var winW=430;
	$('#menu-security-win').dialog({
		height:winH,
		width:winW,
		title:'��Ŀ��Ȩ',
		buttons:[
			{
				text:'����',
				handler:saveMenuSecurity
			},
			{
				text:'�ر�',
				handler:function(){
					$('#menu-security-win').dialog('close');
				}	
			}
		]
	});
	$('#menu-security-win-search').searchbox({
		width:winW-20-10,
		searcher:function(value){
			var MenuID=$('#menu-security-win-id').val();
			$('#menu-security-win-list').datagrid('load',{ClassName:'web.DHCAppTreeGroup',QueryName:'QryArcimAuth',MenuID:MenuID,GroupDesc:value});
		}
	})
	$('#menu-security-win-list').datagrid({
		width:winW-20,
		height:winH-207+50,
		bodyCls:'panel-header-gray',
		singleSelect:true,
		pagination:true,
		pageSize:30,
		columns:[[
			{field:'SSGroupDesc',title:'��ȫ��',width:300},
			
			{field:'HasMenuAccess',title:'�˵���Ȩ',width:80,align:'center',formatter:function(value,row,index){
				return "<label class='checkbox-label'><input type='checkbox' data-id='"+row.SSGroupID+"'  "+(value=="1"?"checked":"")+"/> </label>";
			}},
			{field:'SSGroupID',title:'ID',hidden:true}
		]],
		idField:'SSGroupID',
		url:"",
		lazy:true,
		toolbar:'#menu-security-win-list-tb'
	})
	function saveMenuSecurity(){
		var MenuID=$('#menu-security-win-id').val();
		if (MenuID == "") {
			return false;
		}
		var data={ClassName:'web.DHCAppTreeGroup',MethodName:'SaveTreeGroup',MenuID:MenuID,Length:0,IdStr:""};
		
		$('#menu-security-win .checkbox-label>input').each(function(i){
			var cid = $(this).data('id');
			data["Length"] = data["Length"] + 1;
			if($(this).is(':checked')){      //������attr('checked')=='checked' �ж�
				cid = cid + "-1";
				if (data["IdStr"] == "") data["IdStr"] = cid
				else  data["IdStr"] = data["IdStr"] + "," + cid;
			} else {
				cid = cid + "-0";
				if (data["IdStr"] == "") data["IdStr"] = cid
				else  data["IdStr"] = data["IdStr"] + "," + cid;
			}
		})
		$.m(data,function(rtn){
			if(rtn == 0){
				$.messager.popover({msg:'��Ȩ����ɹ�',type:'success',timeout:1000});
				//$.messager.alert("�ɹ�","������Ȩ�ɹ�");
				//$('#menu-security-win').dialog('close');
			} else {
				$.messager.popover({msg:'��Ȩ����ʧ��',type:'error',timeout:1000});
			}
		})
	}
	GV.showMenuSecurityWin=function(id,name,caption){
		
		$('#menu-security-win-search').searchbox('setValue','');
		//$('#menu-security-win').find('.i-searchbox tr').eq(0).find('input').val(caption);
		$('#menu-security-win-caption').text(caption);
		//$('#menu-security-win').find('.i-searchbox tr').eq(1).find('input').val(name);
		$('#menu-security-win-name').text(name);
		$('#menu-security-win-id').val(id);
		$('#menu-security-win-list').datagrid('options').url='websys.Broker.cls';
		//alert(id)
		$('#menu-security-win-list').datagrid('unselectAll').datagrid('load',{ClassName:'web.DHCAppTreeGroup',QueryName:'QryArcimAuth',MenuID:id,GroupDesc:''});
		$('#menu-security-win').dialog('open');
	}
	
};
/// �ƶ���������
function moveTree(mListData){
	
	var InsFlag = false;
	runClassMethod("web.DHCAPPTreeAdd","moveTreeNew",{'mListData':mListData},function(jsonString){
		if (jsonString != 0){
			$.messager.alert("��ʾ","�ƶ�����!","warning"); 
		}else{
			InsFlag = true;
		}
 	},'json',false)
 	return InsFlag;
}
/// JQuery ��ʼ��ҳ��
$(function(){ InitHosp(); })
