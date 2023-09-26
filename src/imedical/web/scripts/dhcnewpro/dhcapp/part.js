var curnode=0
var curselect=0
var partItmUrl='dhcapp.broker.csp?ClassName=web.DHCAPPPartItm&MethodName=list';
var partUrl='dhcapp.broker.csp?ClassName=web.DHCAPPPart&MethodName=list';
var editRow="",PartID="";
$(function(){ 
	//��߲�λ������ʾ
	$('#partTree').tree({    
    	//url: LINK_CSP+"?ClassName=web.DHCAPPPart&MethodName=getTreeCombo",
    	//url: LINK_CSP+"?ClassName=web.DHCAPPPart&MethodName=jsonCheckPartByNodeID&id=0",  ///�𼶼��� bianshuai 2016-09-09
    	url: LINK_CSP+"?ClassName=web.DHCAPPPart&MethodName=jsonCheckPartByOrdnum&id=0",  ///��˳����𼶼��� sufan 2017-02-04
    	lines:true,
    	onClick: function(node){
			$("#datagrid").datagrid(
			{
				url:partUrl+"&parentId="+node.id	
			})
			$("#subdatagrid").datagrid('loadData',{total:0,rows:[]});
			curnode=node.id;
		},
		onContextMenu: function(e, node){
			e.preventDefault();
			// ���ҽڵ�
			$('#partTree').tree('select', node.target);
			//$("#datagrid").datagrid('load',{'parentId':node.id});
			curnode=node.id;
			// ��ʾ��ݲ˵�
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		}

	});
	
	/*$("input[name='root']").bind("click", function () {
		alert($('input[name="root"]:checked').val())
		$("#datagrid").datagrid(
		{
			url:partUrl,
			queryParams:{rootflag:$('input[name="root"]:checked').val()}	
		})
	});*/
	$HUI.checkbox("input[name='root']",{
		onCheckChange:function(e,value){
			$("#datagrid").datagrid(
			{
				url:partUrl,
				queryParams:{rootflag:$('input[name="root"]:checked').val()}	
			})
		}	
	});
	
	InitWidListener();  /// ���¼� bianshuai 2016-08-10
});
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}
function save(){
	saveByDataGrid("web.DHCAPPPart","save","#datagrid",function(data){
		//�޸�
		if(data==0){
			$.messager.alert('��ʾ','����ɹ�','success')
		}else if(data==-10){
			$.messager.alert('��ʾ','����ʧ�ܣ�ʧ��ԭ�򣺲�λ����������ظ�','warning');
			return;
		}else{
			$.messager.alert('��ʾ','����ʧ��','warning')
			return;
		}
		$("#datagrid").datagrid('reload'); $('#partTree').tree('reload'); 
	});	
}


function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'APActiveFlag':'Y','APParPDr':curnode}})
}

function addCurRow(){
	 runClassMethod(
	 				"web.DHCAPPPart",
	 				"find",
	 				{'Id':curnode},
	 				function(data){
	 					commonAddRow({'datagrid':'#datagrid',value:{'APActiveFlag':'Y','APParPDr':data}}) 
	 				})
}


function selectRow(index,row){
	curselect=row.ID;	
	$("#subdatagrid").datagrid({
		url:partItmUrl,
		queryParams:{partId:row.ID}	
	});	
}
function addRowSub(){
	if(curselect==0){
		$.messager.alert("��ʾ","��ѡ��λ!");
		return;
	}
	commonAddRow({'datagrid':'#subdatagrid',value:{ParRefDr:curselect}})
}
function saveSub(){
	saveByDataGrid("web.DHCAPPPartItm","save","#subdatagrid",function(data){
		//�޸�
		if(data==0){
			$.messager.alert('��ʾ','����ɹ�')
		}else if(data==-10){
			$.messager.alert('��ʾ', '��Ϲ�����λ�ظ���¼');
		}else{
			$.messager.alert('��ʾ','����ʧ��')
		}
		$("#subdatagrid").datagrid('reload'); 
	});	
}

function onClickRowSub(index,row){
	CommonRowClick(index,row,"#subdatagrid");
}

function selectPart(p){
	if(p.id==curselect){
		$.messager.alert('��ʾ','���ܺ��Լ�����')
		return;
	}	
}

function deleteSub(){
	
	var row=$("#subdatagrid").datagrid('getSelected')
	if (row){
		$.messager.confirm('��ʾ', '��ȷ��Ҫɾ����?', function(r){
				if (r){
					runClassMethod(
	 				"web.DHCAPPPart",
	 				"remove",
	 				{'Id':row.ID},
	 				function(data){
	 					$("#subdatagrid").datagrid('reload')
	 				})
				}
		});
		
	}else{
		$.messager.alert('��ʾ','����ѡ��')
	}
	
}

function move(isUp,index) {

		var rows=$('#datagrid').datagrid('getData')

		if((isUp)&&(index==0)){
			return;
		}
		if(!(isUp)&&(index==rows.length)){
			return;
		}
		var nextId;
		if(isUp){
			nextId=rows.rows[index-1].ID
		}else{
			nextId=rows.rows[index+1].ID
		}
		var $view = $('div.datagrid-view');
		var $row = $view.find('tr[datagrid-row-index=' + index + ']');		
	    if (isUp) {
	            $row.each(function(){
	                    var prev = $(this).prev();
	                    prev.length && $(this).insertBefore(prev);
	    });
	    } else {
	            $row.each(function(){
	                    var next = $(this).next();
	                   next.length && $(this).insertAfter(next);
	            });
	    }
        runClassMethod(
	 				"web.DHCAPPPart",
	 				"move",
	 				{'Id':rows.rows[index].ID,isUp:isUp,nextId:nextId},
	 				function(data){
   						$("#datagrid").datagrid('reload');
   						$("#partTree").tree('reload');   ///sufan 2017-02-04  ˢ�²�λ�� 
	 	            })

}
function moveUp(index){move(true,index)}
function moveDown(index){move(false,index)}
function cellStyler(value,row,index){
	if(value==undefined){   //2016-07-18 qunianpeng
		value="" ;
	}	
	html="<a class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveUp("+index+")'>"
	html=html+"<span class='l-btn-left'><span class='l-btn-text icon-up l-btn-icon-left'>����</span></span>"
	html=html+"</a>"
	html=html+"<a class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveDown("+index+")'>"
	html=html+"<span class='l-btn-left'><span class='l-btn-text icon-down l-btn-icon-left'>����</span></span>"
	html=html+"</a>"
	html=html+"<span style='display:none;'>"+value+"</span>"   //sufan 2017-1-24  ����value ֵ
	return html;
}

/// �����Ҽ��˵� bianshuai 2016-08-10
function showRowContextMenu(e, rowIndex, rowData){
	e.preventDefault();
	$("#datagrid").datagrid("selectRow",rowIndex);
	$('#menu').menu('show', {    
	    left: e.pageX,
	    top: e.pageY
	}); 
}

/// ��ʾ��λ��������
function showPartWin(){
	
	var rowsData = $("#datagrid").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		PartID = rowsData.ID;
		initPartWin();	
		initPartList();	
	}
}

/// Window ����
function initPartWin(){
	
	/// ��λ��������
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	
	new WindowUX('��������', 'PartWin', '600', '300', option).Init();
}

/// DataGrid ����
function initPartList(){
	
	///  �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	///  ����columns
	var columns=[[
		{field:'ItemLabel',title:'����',width:320,editor:textEditor}
		
	]];
	
	///  ����datagrid
	var option = {
		rownumbers : true,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgPartList").datagrid('endEdit', editRow); 
            } 
            $("#dgPartList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        }
	};

	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPPart&MethodName=QueryPartAlias&PartID="+PartID;;
	new ListComponent('dgPartList', columns, uniturl, option).Init(); 
}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){

	$("div#tb a:contains('���')").bind("click",insertRow);
	$("div#tb a:contains('ɾ��')").bind("click",deleteRow);
	$("div#tb a:contains('����')").bind("click",saveRow);
	
	///  ƴ����
	//$("#ExaCatCode").bind("keyup",findPartItemTree);
	
	$('#ExaCatCode').searchbox({
		searcher : function (value, name) {
			var PyCode=$.trim(value);
			findPartItemTree(PyCode);
		}
	});
}

/// ��������
function insertRow(){

	if(editRow>="0"){
		$("#dgPartList").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#dgPartList").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ItemLabel:''}
	});
	$("#dgPartList").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// ɾ��ѡ����
function deleteRow(){

	var rowsData = $("#dgPartList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		var rowIndex = $("#dgPartList").datagrid('getRowIndex',rowsData);
		/// ɾ����
		$("#dgPartList").datagrid('deleteRow',rowIndex);
			
		var selItems=$("#dgPartList").datagrid('getRows');
		$.each(selItems, function(index, selItem){
			$('#dgPartList').datagrid('refreshRow', index); /// ˢ�µ���
		})
		updateAlias();  //sufan  2017-05-23
	}
}
/// ɾ�������󣬸��±������� sufan  2017-05-23
function updateAlias(){

	var rowsData = $("#dgPartList").datagrid('getRows');
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if($.trim(rowsData[i].ItemLabel) == "") continue;
		dataList.push(rowsData[i].ItemLabel.toUpperCase());
	} 
	var params=dataList.join("/");
	//��������
	runClassMethod("web.DHCAPPPart","UpdPartAlias",{"PartID":PartID,"PartAlias":params},function(jsonString){

		if (jsonString != 0){
			return;	
		}
		$("#datagrid").datagrid(
			{
				url:partUrl+"&parentId="+PartID	
			});//sufan  2017-05-23  ����󣬼��ر����ı�������
	})
}
/// ����
function saveRow(){

	if(editRow>="0"){
		$("#dgPartList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#dgPartList").datagrid('getRows');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if($.trim(rowsData[i].ItemLabel) == "") continue;
		dataList.push(rowsData[i].ItemLabel.toUpperCase());
	} 
	var params=dataList.join("/");

	//��������
	runClassMethod("web.DHCAPPPart","SavePartAlias",{"PartID":PartID,"PartAlias":params},function(jsonString){

		if (jsonString != 0){
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
			return;	
		}
		$("#datagrid").datagrid(
			{
				url:partUrl+"&parentId="+PartID	
			});    //sufan  2017-05-23  ����󣬼��ر����ı�������
	})
}

/// ������鲿λ��Ŀ
function findPartItemTree(PyCode){

	if (PyCode == ""){
		var url = LINK_CSP+'?ClassName=web.DHCAPPPart&MethodName=jsonCheckPartByNodeID&id=0';
	}else{
		var url = LINK_CSP+'?ClassName=web.DHCAPPPart&MethodName=jsonCheckPartByPyCode&PyCode='+PyCode;
	}
	
	$('#partTree').tree('options').url =encodeURI(url);
	$('#partTree').tree('reload');
}


//����ļ��ϴ���·�� 
function clearFiles (){
     var file = $("#filepath");
      file.after(file.clone().val(""));      
      file.remove();   
	
	}


// ���벿λ�е�����
function ImportDataPart() {
    var efilepath = $("input[name=filepath]").val();
    //alert(efilepath)
    if (efilepath.indexOf("fakepath") > 0) {alert("����IE��ִ�е��룡"); return; }
    if (efilepath.indexOf(".xls") <= 0) { alert("��ѡ��excel����ļ���"); return; }
    //var kbclassname = ""  //����
    var sheetcount = 1  //ģ���б�ĸ���
    var file = efilepath.split("\\");
    var filename = file[file.length - 1];
    if ((filename != "part.xlsx")&&(filename != "part.xls")) {
	    clearFiles ()
        $.messager.alert('��ʾ', '�ļ�ѡ��Ĳ���ȷ��');
        return;
    }

  try {
        var oXL = new ActiveXObject("Excel.application");
        var oWB = oXL.Workbooks.open(efilepath);   //xlBook = xlApp.Workbooks.add(ImportFile);		
  }catch (e) {
        $.messager.alert('����[internetѡ��]-[��ȫ]-[�����ε�վ��]-[վ��]����ӿ�ʼ���浽�����ε�վ�㣬Ȼ����[�Զ��弶��]�ж�[û�б��Ϊ��ȫ��ActiveX�ؼ����г�ʼ���ͽű�����]��һ������Ϊ����!');

        return;
  }
    var sheet_id = 1
    var errorRow = "";//û�в������
    var errorMsg = "";//������Ϣ
    oWB.worksheets(sheet_id).select();
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(sheet_id).UsedRange.Cells.Rows.Count;
    var colcount = oXL.Worksheets(sheet_id).UsedRange.Cells.Columns.Count;
    
    $.messager.progress({   //���ݵ�����ʾ
		title:'���Ժ�', 
		msg:'�������ڵ�����...' 
	}); 
    
    var inserToDB = function (i) { 
        if (i == rowcount+1) {
            //if (errorRow != "") {
               // errorMsg = oSheet.name + "������ɣ���" + errorRow + "�в���ʧ��!";
            //} else {
	            clearFiles ()
                errorMsg = oSheet.name + "�������!"
                $.messager.progress('close')//���ݵ�����ɹرռ��ؿ�
           // }
            alert(errorMsg)

            oWB.Close(savechanges = false);
            CollectGarbage();
            oXL.Quit();
            oXL = null;
            oSheet = null;
        }else {
			var tempStr = ""; //ÿ�����ݣ���һ��[next]�ڶ���[next]...��
			var row=i
            for (var j = 1; j <= colcount; j++) {
                var cellValue = ""
                if (typeof (oSheet.Cells(i, j).value) == "undefined") {
                    cellValue = ""
                } else {
                    cellValue = oSheet.Cells(i, j).value
                }

                tempStr += (cellValue + "[next]")
               
            }
              runClassMethod(
                    "web.DHCEMImpTools",
                    "SaveData",
                    { "dataStr": tempStr, "sheetid": sheet_id, "row": row, "HospID": LgHospID},
                    function (Flag) {
                             //alert(Flag)
                        if (Flag == true) {  
                            errorRow = errorRow             

                        } else {
                            if (errorRow != "") {
                                errorRow = errorRow + "," + i
                            } else {
                                errorRow = i
                            }
                            
                        }
                           i=i+1;
                           inserToDB(i);    
         
                });

        }
       
    } 
       inserToDB(1);
  
}



/*
// ���벿λ�е�����
function  ImportData(){
	
	var pid=0;
	var filePath=$("input[name=filepath]").val();
	var fileName=filePath.substr(filePath.lastIndexOf('\\')+1);

	

    //��������
	runClassMethod("web.DHCEMImpTools","ImportLabItems",{"filepath":filePath},function(jsonString){
         
        if (jsonString == "-2"){
			$.messager.alert('��ʾ','�ļ�·������Ϊ�գ�');
			return;	
		}
		
		if(fileName!="part.txt"){
	       $.messager.alert('��ʾ','�ļ�·��ѡ��Ĳ���ȷ��');
			return;	
		}
         
		if (jsonString =="-1"){
			clearFiles ()
			$.messager.alert('��ʾ','���ݲ����ظ����룡');
			return;	
		}
		
		
		if (jsonString == "1"){
			clearFiles ()
			$.messager.alert('��ʾ','�������ݳɹ���');
			//$('#partTree').datagrid('reload'); //���¼���
			$('#partTree').tree('reload'); //���¼���
			return;	
		}
		
		if(jsonString){
			clearFiles ()

		$('#PreSent').window({
			title:'�б���Ϣ',
			collapsible:false,
			border:false,
			closed:false,
			width:500,
			height:350
		});
	
	
		var columns=[[
        {field:'PartCode',title:'Code',width:80},
		{field:'PartDesc',title:'����',width:150},
		{field:'LastRowid',title:'��һ��ID',width:100},
		{field:'PartNum',title:'����',width:50}

	
	]];
	
  // ����datagrid
	$('#win').datagrid({
		//title:'�б���Ϣ',
		url:LINK_CSP+"?ClassName=web.DHCEMImpTools&MethodName=GetImpWarnData&pid="+jsonString,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:5,  // ÿҳ��ʾ�ļ�¼����
		pageList:[30,60],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	
   });
		
  }
		
	$('#dgPartList').datagrid('reload'); //���¼���
})	
}

*/

/// ���ƶ�
function moveup()
{
	runClassMethod("web.DHCAPPPart","MoveUp",{"Id":curnode},function(jsonString){

		if (jsonString == 0){
			
			$('#partTree').tree('reload'); //���¼���
			
			$('#datagrid').datagrid('reload'); //���¼���
			
			$('#subdatagrid').datagrid('reload'); //���¼���
		}
		
	})
}
///����
function movedown()
{
	runClassMethod("web.DHCAPPPart","MoveDown",{"Id":curnode},function(jsonString){

		if (jsonString == 0){
			
			$('#partTree').tree('reload'); //���¼���
			
			$('#datagrid').datagrid('reload'); //���¼���
			
			$('#subdatagrid').datagrid('reload'); //���¼���
		}
	})
}
