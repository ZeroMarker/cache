/*
ģ��:		�ƶ�ҩ��
��ģ��:		�ƶ�ҩ��-��ҩ���ҹ���ά��
Creator:	hulihua
CreateDate:	2016-10-07
*/
var currEditRow = "";
var combooption = {
	valueField :'value',    
	textField :'text',
	panelWidth:'230'
}

$(function(){
	InitWardLocList();
	InitSetSendLocList();
	$('#SetSendLoc').datagrid('loadData',{total:0,rows:[]});
	Query();
});

///�����б�
function InitWardLocList(){
	//����columns
	var columns=[[
	    {field:'rowid',title:'ID',width:60,hidden:true},
	    {field:'LocDesc',title:'��������',width:350}
	]];  
    //����datagrid	
    $('#WardList').datagrid({
        url:LINK_CSP+'?ClassName=web.DHCINPHA.MTCommon.CommonUtil&MethodName=GetLocByLocTypeList&LocType=W&params=^'+$('#CombPhaloc').combobox('getValue'),
        fit:true,
	    border:false,
	    singleSelect:true,
	    rownumbers:true,
	    nowrap:false,
        columns:columns,
        pageSize:100,  // ÿҳ��ʾ�ļ�¼����
	    pageList:[100,300,500],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true,
	    onLoadError:function(data){
			$.messager.alert("����","��������ʧ��,��鿴������־!","warning");
			$('#WardList').datagrid('loadData',{total:0,rows:[]});
			$('#WardList').datagrid('options').queryParams.LocType=W; 
		},
		onDblClickRow:function () {
			Save();
		}		
    });
}

///�ѹ�����ҩ�����б�
function InitSetSendLocList(){
	//�ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	//����columns
	var columns=[[
	    {field:'rowid',title:'ID',width:30,hidden:true},
	    {field:'WardLoc',title:'��������',width:200},
	    {field:'Tselect',title:'�Ƿ���ҩ',width:60,align:'center',
			formatter: function(value,row,index){
				if (value=="Y"){
	        		return '<img src="../scripts/dhcpha/img/ok.png" border=0/>';
	        	}
			}
		},
		{field:'TWardQue',title:'��ʾ���',width:60,align:'right',editor:textEditor},
		{field:'TSendFreqDesc',title:'��ҩƵ������',width:150,align:'center',editor:textEditor},
		{field:'TSendFreqFactor',title:'Ƶ��ϵ��',width:60,align:'right',editor:textEditor},
		{field:'TSendFactor',title:'����ϵ��',width:100,align:'right',editor:textEditor}
	]];  
    //����datagrid	
    $('#SetSendLoc').datagrid({    
        url:LINK_CSP+'?ClassName=web.DHCINPHA.MTSendLoc.SendLocQuery&MethodName=GetSendLocList',
        fit:true,
	    border:false,
	    singleSelect:true,
	    rownumbers:true,
	    nowrap:false,
        columns:columns,
        pageSize:100,  // ÿҳ��ʾ�ļ�¼����
	    pageList:[100,300,500],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true,
	    onLoadError:function(data){
			//$.messager.alert("����","��������ʧ��,��鿴������־!","warning")
			$('#SetSendLoc').datagrid('loadData',{total:0,rows:[]});
			$('#SetSendLoc').datagrid('options').queryParams.params = ""; 
		},    
		onLoadSuccess: function(){
			if (currEditRow!=undefined){
				$('#SetSendLoc').datagrid('endEdit', currEditRow);
				currEditRow = undefined
			}
		},
		onDblClickRow:function () {
			Delete();
		},
		onClickCell: function (rowIndex, field, value) {
            if (field=="WardLoc"){return;}
			if(field=="Tselect"){
				//var subrowdata=$("#SetSendLoc").datagrid('getSelected'); //Huxt 2020-02-21
				var rowsData = $('#SetSendLoc').datagrid('getRows');
				var subrowdata = rowsData[rowIndex];
				if((typeof subrowdata == "undefined")||(subrowdata == null)||(subrowdata == "")){
					$.messager.alert("��ʾ","δѡ��Ҫά���ļ�¼!","info")
					return;
				}
				var phslid=subrowdata.rowid;
				var sendflag="Y";
				if (value=="Y"){
					sendflag="N";
				}
				var retValue=tkMakeServerCall("web.DHCINPHA.MTSendLoc.SendLocQuery","UpdateSendFlag",phslid,sendflag);
				if (retValue==-1){
					$.messager.alert("��ʾ","�ò���û�й�����ϵ!","info")
					return;	
				}else if (retValue==-2){
					$.messager.alert("��ʾ","û��ѡ���Ƿ���ҩ!","info")
					return;	
				}else if (retValue==-3){
					$.messager.alert("��ʾ","���±�ṹʧ��!","info")
					return;	
				}
				$('#SetSendLoc').datagrid('updateRow',{
					index: rowIndex,
					row: {Tselect:sendflag}
				});
			}else{
				if (rowIndex != currEditRow) {
		        	if (endEditing(field)) {
						$("#SetSendLoc").datagrid('beginEdit', rowIndex);
						var editor = $('#SetSendLoc').datagrid('getEditor', {index:rowIndex,field:field});
			     	    editor.target.focus();
			     	    editor.target.select();
						$(editor.target).bind("blur",function(){
		                	endEditingdt(field);      
		            	});
						currEditRow=rowIndex;  
		        	}
				} 
			}
		}
    });
}

///��֤������ֵ�ĺϷ���
var endEditingdt = function (field) {
    if (currEditRow == undefined) { return true };
    if ($('#SetSendLoc').datagrid('validateRow', currEditRow)) {
        var ed = $('#SetSendLoc').datagrid('getEditor', { 
        	index: currEditRow, 
        	field: field
        });
        
		var selecteddata = $('#SetSendLoc').datagrid('getRows')[currEditRow]; 
		var phslid=selecteddata["rowid"];
		
		var wardque=selecteddata["TWardQue"];
		if (wardque == undefined) {wardque=""};
		
		var sendfreqdesc=selecteddata["TSendFreqDesc"];
		if (sendfreqdesc == undefined) {sendfreqdesc=""};
		
		var sendfreqfac=selecteddata["TSendFreqFactor"];
		if (sendfreqfac == undefined) {
			sendfreqfac="";
		}else if(sendfreqdesc == "ȫ��"){
			sendfreqfac=1000;
		};
		var sendfactorfac=selecteddata["TSendFactor"];
		if (sendfactorfac == undefined) {sendfactorfac=""};
		
        var inputtxt=$(ed.target).val();
        $('#SetSendLoc').filter(":contains('2')").addClass("promoted")
        var detaildata="";
        if (field=="TSendFreqFactor"){
		    if (inputtxt<0){ 
		    	$.messager.alert('������ʾ',"�� "+'<span style="color:red;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ (currEditRow+1)+'</span>'+" ��Ƶ��ϵ������С��0!","info");
		    	return false;
		    }
			$('#SetSendLoc').datagrid('updateRow',{
				index: currEditRow,
				row: {TSendFreqFactor:inputtxt}
			});
			detaildata=phslid+"^"+sendfreqdesc+"^"+inputtxt+"^"+sendfactorfac+"^"+wardque;
        }else if(field=="TSendFreqDesc"){
	       	if ((inputtxt=="")||((inputtxt==null))){ 
		    	$.messager.alert('������ʾ',"�� "+'<span style="color:red;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ (currEditRow+1)+'</span>'+" ����ҩƵ����������Ϊ��!","info");
		    	return false;
		    }
			$('#SetSendLoc').datagrid('updateRow',{
				index: currEditRow,
				row: {TSendFreqDesc:inputtxt}
			});
	        detaildata=phslid+"^"+inputtxt+"^"+sendfreqfac+"^"+sendfactorfac+"^"+wardque;
	    }else if(field=="TWardQue"){
	       	if (inputtxt<0){ 
		    	$.messager.alert('������ʾ',"�� "+'<span style="color:red;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ (currEditRow+1)+'</span>'+" ����ʾ��Ų���С��0!","info");
		    	return false;
		    }
			$('#SetSendLoc').datagrid('updateRow',{
				index: currEditRow,
				row: {TWardQue:inputtxt}
			});
	        detaildata=phslid+"^"+sendfreqdesc+"^"+sendfreqfac+"^"+sendfactorfac+"^"+inputtxt;
	    }else{
			$('#SetSendLoc').datagrid('updateRow',{
				index: currEditRow,
				row: {TSendFactor:inputtxt}
			});
	        detaildata=phslid+"^"+sendfreqdesc+"^"+sendfreqfac+"^"+inputtxt+"^"+wardque;
	    }
		savedata(detaildata);
        $('#SetSendLoc').datagrid('endEdit', currEditRow);
        currEditRow = undefined;
        Query();
        return true;
    } else {
        return false;
    }
}

///��ҩƵ�κ�Ƶ��ϵ��ά��
function savedata(detaildata){
	var retValue=tkMakeServerCall("web.DHCINPHA.MTSendLoc.SendLocQuery","UpdateSendFreqInfo",detaildata);
	if (retValue==-1){
		$.messager.alert("��ʾ","�ò���û�й�����ϵ!","info")
		return;	
	}else if (retValue==-2){
		$.messager.alert("��ʾ","û�и���������Ϣ!","info")
		return;	
	}else if (retValue==-3){
		$.messager.alert("��ʾ","���±�ṹʧ��!","info")
		return;	
	}
}

///ҩ����ҩ���ұ���
function Save(){
	var phlocdr=$('#CombPhaloc').combobox('getValue');
	var row =$("#WardList").datagrid('getSelected');
	var wardid=row.rowid;
	var input=phlocdr+"^"+wardid;
	var data=tkMakeServerCall("web.DHCINPHA.MTSendLoc.SendLocQuery","Save","",input);
	if(data>0){
		$.messager.alert('��ʾ','����ɹ�');			
	}else if(data==-1){
		$.messager.alert('��ʾ','ҩ������Ϊ��');	
	}else if(data==-2){
		$.messager.alert('��ʾ','��������Ϊ��');	
	}else if(data==-3){
		$.messager.alert('��ʾ','�Ѿ�������ҩ��ϵ');	
	}else if(data==-4){
		$.messager.alert('��ʾ','������ʧ��');	
	}else{
		$.messager.alert('��ʾ','����ʧ��:'+data);
	}
	$("#SetSendLoc").datagrid('reload');
	Query();	
}

///ҩ����ҩ���Ҳ�ѯ (�����б�ͬʱ��ѯ Huxt 2020-02-19)
function Query(){
	var phlocdr = $('#CombPhaloc').combobox('getValue');
	if (phlocdr==""||phlocdr==null){
		//$.messager.alert('��ʾ',"��ѯʱҩ������Ϊ��!","info");
		return;
	}
	var params = phlocdr;
	$('#SetSendLoc').datagrid('load',{params:params});
	InitWardLocList(); //��ѯ����
}

///ҩ����ҩ����ɾ��
function Delete(){
	if ($("#SetSendLoc").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��������ϸɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
		if (r){
			var row =$("#SetSendLoc").datagrid('getSelected');     
			runClassMethod("web.DHCINPHA.MTSendLoc.SqlDbSendLoc","Delete",{'Input':row.rowid},function(data){ $('#SetSendLoc').datagrid('load'); })
		}
		Query();
	});
}