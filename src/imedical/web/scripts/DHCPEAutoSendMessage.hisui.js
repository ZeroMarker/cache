

//����	DHCPEAutoSendMessage.hisui.js
//����	���Ų�ѯhisui
//����	2021.01.20
//������  xy

$(function(){
		
	InitCombobox();

	Info();

	InitSendMessageGrid();
	    
     //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
           
     //����
	$("#BClear").click(function() {	
		BClear_click();		
        });  
          
        

   $("#RegNo").keydown(function(e) {	
		if(e.keyCode==13){
			BFind_click();
		}
	});
		
})


function BClear_click()
{
	
	$("#RegNo,#Name").val("");
	$("#StartDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	$(".hisui-combobox").combobox('select','');
	Info();
	BFind_click();
}

function Info()
{
	$("#NoSend").combobox('setValue',"2")
}


//��ѯ
function BFind_click(){
	
	
	var iRegNo=$("#RegNo").val(); 
	if(iRegNo!="") {
	 	var iRegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":iRegNo
		}, false);
		
			$("#RegNo").val(iRegNo)
		}	
	$("#SendMessageGrid").datagrid('load',{
			ClassName:"web.DHCPE.SendMessage",
			QueryName:"FindMessage",
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			Type:$("#Type").combobox('getValue'),
			NoSend:$("#NoSend").combobox('getValue'),
			LocID:session['LOGON.CTLOCID']
			})
	
}


function InitSendMessageGrid()
{
	$HUI.datagrid("#SendMessageGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.SendMessage",
			QueryName:"FindMessage",
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			Type:$("#Type").combobox('getValue'),
			NoSend:$("#NoSend").combobox('getValue'),
			LocID:session['LOGON.CTLOCID']
			
		},
	
		columns:[[
	
		    {field:'TID',title:'ReportID',hidden: true},
		    {field:'TRegNo',width:120,title:'�ǼǺ�'},
			{field:'TName',width:120,title:'����'},
			{field:'TSex',width:60,title:'�Ա�'},
			{field:'TBirth',width:120,title:'��������'},
			{field:'TTel',width:120,title:'�绰'},
			{field:'TContent',width:460,title:'����'},
			{field:'TSend',width:60,title:'����',align:'center',
			formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
					if(value!=""){
	   					if (value=="1") {checked="checked=checked"}
						else{checked=""}
						var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
						return rvalue;
					}
				
			}},
			{field:'TType',width:100,title:'����'},
			{field:'TSendDate',width:120,title:'����ʱ��'},
			{field:'TSendStatus',width:80,title:'״̬'}
		
			
		]],
		onSelect: function (rowIndex, rowData) {
			  						
		}
		
			
	})
}

function InitCombobox()
{
	 
	
	//����
	var TypeObj = $HUI.combobox("#Type",{
		valueField:'id',
		textField:'text',
		panelHeight:'200',
		data:[
            {id:'RP',text:$g('����֪ͨ')},
            {id:'HR',text:$g('�ϱ���Σ')},
            {id:'RR',text:$g('��Σ���')},
            {id:'RC',text:$g('��Σ����')},
            {id:'FS',text:$g('���ɷ���')},
            {id:'PAADM',text:$g('��������')},
            {id:'NetPre',text:$g('����ԤԼ')},
            {id:'HisPre',text:$g('HisԤԼ')},
            {id:'VC',text:$g('��֤��')}
               
        ]

	}); 
	
	
	//����״̬
	var NoSendObj = $HUI.combobox("#NoSend",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'2',text:$g('���ͳɹ�')},
            {id:'3',text:$g('����ʧ��')},
            {id:'0',text:$g('������')}
           
        ]

	}); 
		
	
}
