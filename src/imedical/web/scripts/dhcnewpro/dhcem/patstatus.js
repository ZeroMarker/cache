///CreatDate:  2016-08-01
///Author:    lvpeng 
var editRow = "";
var ActFlagArr = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
$(function(){
	//�Զ���༭���� jquery.easyui.extend.js ���ӣ���Ҫʵ�ֱ༭����4��Ĭ�Ϸ���
	 $.extend($.fn.datagrid.defaults.editors, {
			combogrid: {
				init: function(container, options){
					//options.enterNullValueClear=false;
					var input = $('<select class="hisui-combogrid" id="combogrid" style="width:210px">').appendTo(container); 
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
	
	//�����󶨻س��¼�
     $('#Stdesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //���ò�ѯ
        }
    });
   
   	hospComp = GenHospComp("DHC_EmPatStatusAcc");  //hxy 2020-05-26
    hospComp.options().onSelect = function(){///ѡ���¼�
		//$("#datagrid").datagrid('load');
		//$("#datagrid1").datagrid('loadData',{total:0,rows:[]});
		ClickRowSys();
	}//ed
});

///csp��״̬��Ȩ������ֵ����
function fillValue(rowIndex, rowData){
	$('#datagrid1').datagrid('getRows')[editIndex]['PSAPointer']=rowData.id
}

///�����༭ ��Ʒ��(����) 
function ClickRowSys(){
	var row =$("#datagrid").datagrid('getSelected');
	PVId=row.ID; ///��id
	var HospDr=hospComp.getValue(); //hxy 2020-05-26
	$('#datagrid1').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatStatus&MethodName=ListPstAccItm&PVId='+PVId+'&HospDr='+HospDr //hxy 2020-05-26 +'&HospDr='+HospDr
	});
	
	}


///������ ״̬��Ȩ��(�ӱ�) 
function addRowPsaAcc(){
	 if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','����ѡ�� ����״̬��');
		return;
	 }
	 var row =$("#datagrid").datagrid('getSelected');
	 PVSRowId=row.ID; ///��id  
	 var HospDr=hospComp.getValue(); //hxy 2020-06-02
	commonAddRow({'datagrid':'#datagrid1',value:{'PSAStatusDr':PVSRowId,'HospDr':HospDr}}) //hxy 2020-06-02 HospDr
}
///˫���༭ ״̬��Ȩ��(�ӱ�)
function onClickRowSysItm(index,row){
	CommonRowClick(index,row,"#datagrid1");
	PSAtypeID=row.PSAType;
	var rowIndex=$('#datagrid1').datagrid('getRowIndex',$('#datagrid1').datagrid('getSelected'))
	var varEditor = $('#datagrid1').datagrid('getEditor', { index: rowIndex, field: 'PointerDesc' });
	$(varEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatStatus&MethodName=ListGroup&type='+PSAtypeID
	})
}

///˫���༭ ״̬��Ȩ��(�ӱ�)
function onClickRowSys(rowIndex,row){
	if ((editRow != "")||(editRow == "0")) { 
        $("#datagrid").datagrid('endEdit', editRow); 
    } 
    $("#datagrid").datagrid('beginEdit', rowIndex); 
    editRow = rowIndex;
}


///���� ״̬��Ȩ��(�ӱ�)
function savePsaAcc(){
	saveByDataGrid("web.DHCEMPatStatus","SavePsaAcc","#datagrid1",function(data){
			if(data==0){
				$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid1").datagrid('load')
			}else if(data==1){
				$.messager.alert("��ʾ","ָ��ֵ�Ѵ���,�����ظ�����!"); 
				$("#datagrid1").datagrid('load')
			}else if(data==2){
				$.messager.alert("��ʾ","�ֶ�¼����Ч,������ѡ��!"); 
				$("#datagrid1").datagrid('load')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				$("#datagrid1").datagrid('load')
			}
		});	
}

///ɾ�� ״̬��Ȩ��(�ӱ�)
function cancelPsaAcc(){
	var row =$("#datagrid1").datagrid('getSelected');  

	if (row== null) {
		$.messager.alert('��ʾ','��ѡ��һ�м�¼ɾ��');
		return;
	}
	
	if(row.ID==""||row.ID==undefined){
		$.messager.alert('��ʾ','ѡ�м�¼δ���棡');
		return;
	}
	
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	        
		 runClassMethod("web.DHCEMPatStatus","RemovePsaAcc",{'Id':row.ID},function(data){
			if(data==0){
				$.messager.alert('��ʾ','ɾ���ɹ���');
				$('#datagrid1').datagrid('load'); 
				return;			
			}else{
			$.messager.alert('��ʾ','ɾ��ʧ�ܣ�');	
			}
		 })
    }    
}); 
}


function addRowPsa(){
	
	if(editRow>="0"){
		$("#datagrid").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#datagrid").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#datagrid').datagrid('selectRow',0);
			$("#datagrid").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	$("#datagrid").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {PTCode:'', PTDesc:'', PTProCombo:'', PTProID:'', ID:''}
	});
	$("#datagrid").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;	
}

function savePsa(){
	
	if(editRow>="0"){
		$("#datagrid").datagrid('endEdit', editRow);
	}

	var rowsData = $("#datagrid").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!","warning");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].PTCode=="")||(rowsData[i].PTDesc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!","warning"); 
			return false;
		}
	
		var tmp=rowsData[i].ID +"^"+ rowsData[i].PTCode +"^"+ rowsData[i].PTDesc +"^"+ rowsData[i].PTProID +"^"+ rowsData[i].AutoDis+"^"+ rowsData[i].Active;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCEMPatStatus","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#datagrid').datagrid('reload'); //���¼���
	})	
}



/// ɾ��ѡ����
function cancelPsa(){
	
	var rowsData = $("#datagrid").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCEMPatStatus","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#datagrid').datagrid('reload'); //���¼���
					$('#datagrid1').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
//YNת���Ƿ�
function formatLink(value,row,index){
	if (value=='Y'){
		return '��';
	}else if (value=='N'){
		return '��';
	}
}
