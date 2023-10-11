$(function(){
	setPageLayout();
	setElementEvent();	
});

function setElementEvent(){
	initStartno()	  	//��ʼ���븳ֵ
	initNumber()	  	//�������븳ֵ
	initCombobox()    	//��ȡ��������Ϣ
	initSearsh()		//����ҳ�淵�ز�����ѯ���ӷ�Ʊ��Ϣ
	initAdd()			//�������
	clearDialog()		//�������
	loadInvConfig()		//���¼�������
	initDelete()		//ɾ������
	initImport()		//���뷢Ʊ������Ϣ
}
//��ʼ���븳ֵ
function initStartno(){
	$("#Startno").blur(function(){
		var Startno = $.trim($('#Startno').val());
		if(Startno != ""){
			$('#Startno').val((Array(8).join("0") + (parseInt(Startno))).slice(-8)); 
		}
	});
}
//�������븳ֵ
function initNumber(){
	$("#number").keyup(function(){
		var Startno = parseInt($.trim($('#Startno').val()));
		var number = parseInt($.trim($('#number').val()));
		var ednnn=number+Startno-1;
		if(Startno != ""){
			if(number != ""){
				ednnn=(Array(8).join(0) + ednnn).slice(-8);
				$('#endno').val(ednnn); 
			}
		}
	})
}
//��ȡ��������Ϣ
function initCombobox(){
	$HUI.combobox("#buyer",{
		valueField:'rowid',
		textField:'usrname',
		panelHeight:"auto",
		url:$URL,
		//editable:false,
    	//method:"GET",
		onBeforeLoad:function(param){
			param.ClassName="web.UDHCJFReceipt";
	    	param.QueryName="FindUser";
	   		param.ResultSetType="array";
	   		param.grp="A";  
	   		param.type="1";
	 		param.UserID="";
	 		param.username="";  
		}
	});
	//��ȡ����Ʊ������	
	$HUI.combobox("#type",{
		valueField:'DicCode', 
		textField:'DicDesc',
		panelHeight:"auto",
		url:$URL,
		editable:false,
    	method:"GET",
    	onBeforeLoad:function(param)
    	{
	   		param.ClassName="BILL.EINV.BL.COM.DicDataCtl"
	    	param.QueryName="QueryDicDataInfo"
	   		param.ResultSetType="array"
	 		param.Type="LogicIUDType"          
	    },
	    onLoadSuccess:function(){
		    //var ty = $('#type').combobox('getValue')
		   // if(ty==""){
		    $('#type').combobox('setValue','EO')
		   // }
	    },
	    onChange:function(){
		    var type = $('#type').combobox('getValue');
		    $cm({
						ClassName:"BILL.EINV.BL.COM.InvPrtBuyCtl",
						MethodName:"invprtgetStartNo",
						type:type,
						HospDr:HOSPID
				},function(value){
						if(value == ""){
							return "";
						}else{
							$('#Startno').val((Array(8).join("0") + (parseInt(value))).slice(-8));
						}
					});
		  	}  
	});
}	
//����ҳ�淵�ز�����ѯ���ӷ�Ʊ��Ϣ
function initSearsh(){
	$('#search').click(function(){
		var type = $('#type').combobox('getValue');
		var stdate = $('#stdate').datebox('getValue');
		var endate = $('#endate').datebox('getValue');
		var buyer = $('#buyer').datebox('getText');
		$('#invbuy').datagrid('load',{
			ClassName:'web.UDHCJFInvprt',
			QueryName:'InvprtBuyList',
			type:type,
			stdate:stdate,
			enddate:endate,
			buyer:buyer
		});	
		clearDialog()
	});
}
function initAdd(){
	$('#add').click(function(){
		var buyer = $('#buyer').combobox('getValue');
		var type = $('#type').combobox('getValue');
		if (buyer==""){
			alert('������Ա����Ϊ��')
		}else if(type==""){
			alert("��Ʊ���Ͳ���Ϊ��")
		}
		else{
			var Startno=$("#Startno").val();
			var endno=$("#endno").val();
			var Title=$("#Title").val();
			var useflag=""
			if((Startno=="")||(endno=="")){
				alert("��ʼ�����������벻��Ϊ��")
			}else{
				var userid=$("#buyer").combobox('getValue');
				var str = "^^" + type + "^" + buyer + "^^" + Startno + "^" + endno + "^^" + userid + "^^" + useflag + "^" + Title;
				if(confirm("��ȷ��Ҫ�����"+Startno+"��"+endno+"�ķ�Ʊ��")){
					$cm({
						ClassName:"web.UDHCJFInvprt",
						MethodName:"dhcamtmaginsert",
						str:str,
						HospDr:HOSPID
					},function(value){
						if(value == 0){
							loadInvConfig();
							clearDialog()
							alert("����ɹ�");
							
						}else{
							alert("����ʧ��")
							return;
							}
					});
				}
			}
		}
	});
}
//�������
function clearDialog(){
	$('#Startno').val("");
	$('#Title').val("");
	$('#number').val("");
	$('#endno').val("");
	var type = $('#type').combobox('getValue');
	$('#type').combobox('setValue',type);
	$('#buyer').combobox('setValue','10207');	
}
//���¼�������
function loadInvConfig(){
	var type = $('#type').combobox('getValue');
	var stdate = $('#stdate').datebox('getValue');
	var endate = $('#endate').datebox('getValue');
	var buyer = $('#buyer').datebox('getText');
	$('#invbuy').datagrid('load',{
			ClassName:"web.UDHCJFInvprt",
			QueryName:"InvprtBuyList",
			type:type,
			stdate:stdate,
			enddate:endate,
			buyer:buyer
		});
}	
//ɾ������
function initDelete(){
	$('#delete').click(function(){
		var selectedRow = $('#invbuy').datagrid('getSelected');
		if(!selectedRow){
		$.messager.alert('��Ϣ','��ѡ����Ҫɾ������');
		return;
		}
		$.messager.confirm('��Ϣ','��ȷ��Ҫɾ��������¼��?',function(r){
			if(!r){
				return;
			}else{
				var ID = selectedRow.TRowid;
				$m({
					ClassName:"web.UDHCJFInvprt",
					MethodName:"getdelete",
					rowid:ID
					},function(value){
						if(value.length != 0){
							if(value==0){
								$.messager.alert('��Ϣ','ɾ���ɹ�')	
							}
							if(value==-2){
								$.messager.alert('��Ϣ','��ǰ�����뿪ʼ���벻һ��')	
							}
							loadInvConfig();
							clearDialog()
						}else{
							$.messager.alert('��Ϣ','����������')
							}
					});	
				}	
		});
		
	});
}
//���뷢Ʊ������Ϣ
function initImport(){
	$('#import').click(function(){
	var UserDr=USERID;
	var GlobalDataFlg="0";                          	 //�Ƿ񱣴浽��ʱglobal�ı�־ 1 ���浽��ʱglobal 0 ���浽����(�����������ͷ�����)
	var ClassName="BILL.EINV.BL.COM.InvPrtBuyCtl";    //���봦������
	var MethodName="ImportAmtmagByExcel";          //���봦������
	var ExtStrPam="";                   			     //���ò���()
	ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam);	
	});	
}
function setPageLayout(){	
	//��ȡ��������
	var EdDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + new Date().getDate();
	//��ȡ��ʼ����
	var StDate = (new Date().getFullYear()-1) + "-" + (new Date().getMonth() + 1) + "-" + new Date().getDate();
	//���ÿ�ʼ����ֵ
	$('#stdate').datebox('setValue', StDate);
	//���ý�������ֵ
	$('#endate').datebox('setValue', EdDate);
	$('#invbuy').datagrid({
		fit:true, 
		pagination:true,  
    	url:$URL, 
    	columns:[[    
        	{field:'TRowid',title:'TRowid',width:120},    
        	{field:'TDate',title:'����',width:120},    
        	{field:'TStartno',title:'��ʼ����',width:120},
        	{field:'TEndno',title:'��������',width:120},    
        	{field:'TBuyer',title:'������',width:120},    
        	{field:'TCurrentno',title:'��ǰ���ú���',width:120}, 
        	{field:'TFlag',title:'���ñ��',width:120},    
        	{field:'TType',title:'��Ʊ����',width:120},    
        	{field:'Ttitle',title:'��ʼ��ĸ',width:120},    
        	{field:'Tjob',title:'Tjob',width:200}
    	]]    
	}); 
	
}

