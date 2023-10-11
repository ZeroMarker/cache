 var tb;
	$(function(){
		//alert("regist")
		loadEnsWebServiceClient();
		
	})
	
	//��ʾ����ģ̬��
	function showAddModal(){
		alert("show")
		$('#addServiceDialog').css('display','block');
		$('#addServiceDialog').window('open')
	}
	
	//��������������Ϣ
	function addService(){
		var serCode="";
		var sername=$('input[name="sername"]').val();//��������
		var serdesc=$('input[name="serdesc"]').val();//��������
		var serflag=$('#serflag').switchbox("getValue");//����״̬
		serflag = serflag==true?"Y":"N"
		var serhost=$('input[name="serhost"]').val();//����IP
		var busCode=$('input[name="busCode"]').val();//���ߴ���
		var serport=$('input[name="serport"]').val();//����˿�
		var busCode=$('input[name="busCode"]').val();//���ߴ���
		var input=serCode+"^"+sername+"^"+serdesc+"^"+serhost+"^"+serflag+"^"+busCode+"^"+serport;
		input = encodeURI(input);
		
		//��������
		$.ajax({ 
			type: "POST",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=addService&input="+input,
			dateType: "json",
			success: function(data){
				var dataArr=data.split("^");		
				if (dataArr[0]=="1") {  
					$.messager.alert('��ʾ','�����ɹ�','info');
					//���ط����б�
					loadEnsWebServiceClient();
				}else{  
					$.messager.alert('��ʾ','����ʧ��','error');
				}
			}
		}) 
	}
	
	
	function cancel(){
		$('#addServiceDialog').window('close');
	}


	/*��ʼ�������б��ѯ*/
	function initSearchbox(){
		$("#serviceBar").appendTo(".datagrid-toolbar table tbody tr");
		$("#serviceBar").css("display","inline-block");
	}
		
	//���ط����б�
	function loadEnsWebServiceClient() {
	    tb=$HUI.datagrid('#ServiceGrid', {
	        //title:'WSDL�����б�',
	        height:500,
	        pagination:true,
	        afterPageText:'ҳ,��{pages}ҳ', beforePageText:'��', displayMsg:'��ʾ{from}��{to}������{total}��',
	        nowrap: false,        
	        fitCloumns: true,
	        minimized:false,
	        striped:true,
	        cache:false, 
	        method:'get',
	        url:'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=ServiceList',
	        singleSelect:true,
			columns:[[ 
			    {field:'rowId',title:'���',sortable:true,width:40},   
			    {field:'serCode',title:'�������',sortable:true,width:120}, 
			    {field:'serDesc',title:'��������',width:300},  
			    {field:'serNote',title:'��������',width:230},
			    {field:'serFlag',title:'����״̬',sortable:true,width:100,align:"center",
			    	formatter:function(v,rec){
				    	var status="";
			    		if (rec.serFlag=="Y") {
				    		status='<a href="#" name="run" class="status">����</a>';
			    		}
			    	 	else {
				    		status='<a href="#" name="stop" class="status">ֹͣ</a>';
			    		} 
			    		return status;
				 	}   
			    },
			    {field:'serType',title:'��������',width:80},  
			    {field:'productionName',title:'����',sortable:true,width:200,
			    	formatter:function(value,rowData,rowIndex){ 
			    		var editBtn = '<a href="#this" class="editSer" onclick="editRow('+rowIndex+')">�༭</a>';
		               	return editBtn
					}
			    }, 
			]],
		    onLoadSuccess:function(data){  
		        $('.editSer').linkbutton({text:'�༭',plain:true,iconCls:'icon-edit'});
		        $('a[name="run"]').addClass('run');
		        $('a[name="stop"]').addClass('stop');
		    }
	    })
	    $(initSearchbox());	
	}
	
	//��ѯ
	function findService(){
		var busCode = "";
		var serCode = $("#serCode").val();    
		var serDesc = $("#serDesc").val();
		var serStatus = $("#serStatus").combobox("getValue");
		var serType = $("#serType").combobox("getValue");
		var seachPar = busCode+"^"+serCode+"^"+serDesc+"^"+serStatus+"^"+serType;
		$("#ServiceGrid").datagrid("load",{input:seachPar});
	   	$(initSearchbox());
	}

	
	//ˢ��
	function reloadService(){
		tb.reload();
	}
	
	
	//�༭
	function editRow(rowindex) {
		tb.selectRow(rowindex);
		var row = tb.getSelected();
		
		//��ʾ�༭����
		var ServObj={};
		ServObj.serCode=row['serCode'];//�������
		ServObj.serDesc=row['serDesc'];//��������
		ServObj.serNote=row['serNote'];//��������
		ServObj.serType = row['serType'];//��������
		ServObj.serFlag=row['serFlag'];//����״̬
		ServObj.serWsdl=row['serWsdl'];//�����ַ
		ServObj.host=row['host'];//����IP
		ServObj.port=row['port'];//����˿�
		ServObj.busCode=row['serBusCode'];//���ߴ���
		var url="enswebserviceedit.csp"
		$("body.service").empty();
		$("body.service").load(url,ServObj);
	} 
