/// Creator: sufan
/// CreateDate: 2016-4-13
//  Descript:�����ֵ�ά��
var TYPE="";
var POINTER="";
var editRow="";editparamRow="";  //��ǰ�༭�к�
var dataArray = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];

$(function(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("DHC_AppPosition",hospStr);
	hospComp.jdata.options.onSelect= function(){
		 findAdrStatus(); 
		} 
	var Eventeditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#positionlist").datagrid('getEditor',{index:editRow,field:'hospdesc'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#positionlist").datagrid('getEditor',{index:editRow,field:'aphospdr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	var Flageditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:dataArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#positionlist").datagrid('getEditor',{index:editRow,field:'apactiveflag'});
				$(ed.target).combobox('setValue', option.value);  //�����Ƿ����
			} 
		}

	}

	// ����columns
	var columns=[[
		{field:"apcode",title:'����',width:100,editor:texteditor},
		{field:"apdesc",title:'����',width:100,editor:texteditor},
	    {field:'apactiveflag',title:'�Ƿ����',width:120,align:'center',editor:Flageditor},
	    {field:"aphospdr",title:'aphospdr',width:100,align:'center',hidden:true},//editor:texteditor,hidden:true},
		{field:'hospdesc',title:'ҽԺ',width:220},//editor:Eventeditor},
		{field:"aprowid",title:'ID',width:70,align:'center',hidden:true}
	]];
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
	/*
	// ����datagrid
	$('#positionlist').datagrid({
		title:'��λ�ֵ�ά��',
		url:LINK_CSP+'?ClassName=web.DHCAPPPosition&MethodName=QueryPosition' ,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:5,  // ÿҳ��ʾ�ļ�¼����
		pageList:[30,60],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != ""||editRow == 0) { 
                $("#positionlist").datagrid('endEdit', editRow); 
            } 
            $("#positionlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	});
	*/
	
	/// bianshuai 2017-01-01 �޸ģ�����1.3.6��ҳ��ˢ���쳣
 	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow === 0)) { 
                $("#positionlist").datagrid('endEdit', editRow); 
            } 
            $("#positionlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        },
        onClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            onClickRowPos(rowIndex,rowData)
        }
	};
	var HospID=$HUI.combogrid('#_HospList').getValue();
 	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPPosition&MethodName=QueryPosition&HospID="+HospID;
	new ListComponent('positionlist', columns, uniturl, option).Init();
	
 	//��ť���¼�
	$('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    $('#translateword').bind("click",function(){
		var SelectedRow = $("#positionlist").datagrid('getSelected');
		if (!SelectedRow){
		$.messager.alert("��ʾ","��ѡ����Ҫ�������!","info");
		return false;
		}
		CreatTranLate("User.DHCAppPosition","APDesc",SelectedRow["apdesc"])
		
		});
    //ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            //findAdrStatus(this.id+"^"+$('#'+this.id).val()); //���ò�ѯ
            findAdrStatus(); //���ò�ѯ
        }
    });
    
    // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findAdrStatus(); //���ò�ѯ
    });
    

})

// ��������
function insertRow(){
	
	if(editRow>="0"){
		$("#positionlist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#positionlist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {aprowid:'', apcode:'', apdesc:'', apactiveflag:'Y',aphospdr:'',hospdesc:''}
	});
	$("#positionlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}
// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#positionlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPPosition","DelPosition",{"params":rowsData.aprowid},function(jsonString){
					$('#positionlist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// ����༭��
function saveRow(){
	if(editRow>="0"){
		$("#positionlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#positionlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].apcode=="")||(rowsData[i].apdesc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}
		/*if (rowsData[i].aphospdr==""){
			$.messager.alert("��ʾ","ҽԺ����Ϊ��!"); 
			return false;
		}*/
		var tmp=rowsData[i].aprowid +"^"+ rowsData[i].apcode +"^"+ rowsData[i].apdesc +"^"+ rowsData[i].apactiveflag +"^"+ HospID;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCAPPPosition","SavePosition",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#positionlist').datagrid('reload'); //���¼���
	});
}

// �༭��
var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

// ��ѯ
function findAdrStatus()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$('#positionlist').datagrid('load',{params:params,HospID:HospID}); 
}


function onClickRowTar(index,row){
	var e = $("#tardatagrid").datagrid('getColumnOption', 'TarDesc');
	e.editor = {};
	var e = $("#tardatagrid").datagrid('getColumnOption', 'PartNum');
	e.editor = {};
	var e = $("#tardatagrid").datagrid('getColumnOption', 'TarStart');
	e.editor = {};
	CommonRowClick(index,row,"#tardatagrid");
}

function addRow(){
	if((TYPE=="")||(POINTER=="")){
		$.messager.alert('��ʾ','����ѡ��')
		return
	}
	var HospID=$HUI.combogrid('#_HospList').getValue();
	// sufan ����˫��ʱ���رգ��ٵ����ӣ����ɱ༭
	var e = $("#tardatagrid").datagrid('getColumnOption', 'PartNum');
	e.editor = {type:'numberbox',options:{required:true}};
	var e = $("#tardatagrid").datagrid('getColumnOption', 'TarStart');
	e.editor = {type:'datebox',options:{required:true}};
	var e = $("#tardatagrid").datagrid('getColumnOption', 'TarDesc');
	e.editor = {type:'combogrid',options:{
										required : true,
										id:'AORowId',
										fitColumns:true,
										fit: true,//�Զ���С
										pagination : true,
										panelWidth:600,
										textField:'desc', 
										mode:'remote',
										url:'dhcapp.broker.csp?ClassName=web.DHCAPPPosLinkTar&MethodName=QueryTar&HospID='+HospID,
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
	commonAddRow({'datagrid':'#tardatagrid',value:{'Pointer':POINTER,'Type':TYPE,'PartNum':1,'TarStart':new Date().Format("yyyy-MM-dd")}})
}

function save(){
	saveByDataGrid("web.DHCAPPPosLinkTar","save","#tardatagrid",function(data){
		if(data==0){
			$.messager.alert('��ʾ','����ɹ�')
			$('#tardatagrid').datagrid('reload')
		}else if(data==-10){//�޸�
			$.messager.alert('��ʾ','���շ����Ѵ���')
			$('#tardatagrid').datagrid('reload'); //���¼���
		}else if(data==-11){//�޸�
			$.messager.alert('��ʾ','��ʼʱ����ڽ���ʱ��')
			$('#tardatagrid').datagrid('reload'); //���¼���
		}else if(data==-12){
			$.messager.alert('��ʾ','�����������ڽ���')
			$('#tardatagrid').datagrid('reload'); //���¼���
		}else{
			$.messager.alert('��ʾ','����ʧ��:'+data)
		}
	})
}
function fillValue(rowIndex, rowData){
	$('#tardatagrid').datagrid('getRows')[editIndex]['APLTarDr']=rowData.tarId
	$('#tardatagrid').datagrid('getRows')[editIndex]['TarCode']=rowData.code
	$('#tardatagrid').datagrid('getRows')[editIndex]['TarPrice']=rowData.price
}
function onClickRowPos(index,row){
	TYPE="POS";
	POINTER=row.aprowid
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$('#tardatagrid').datagrid('load',{type:TYPE,pointer:POINTER,hospid:HospID});
}

function onClickRowMed(index,row){
	TYPE="MED";
	POINTER=row.adrowid
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$('#tardatagrid').datagrid('load',{type:TYPE,pointer:POINTER,hospid:HospID});
}
