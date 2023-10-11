//��ں���
$(function(){
	setPageLayout(); //����ҳ�沼��
	setElementEvent();	//����ҳ��Ԫ���¼�
});
//����ҳ�沼��
function setPageLayout(){
	initloginfoGV();//��ʼ����־�б�
	initDate();//��ʼ������
	initIPAddrCombo();//��ʼ��IP��ַ������
}
//����ҳ��Ԫ���¼�
function setElementEvent(){
	initQueryBtn();//��ʼ����ѯ��ť�¼�
	initCheckBox();//��ʼ����ѡ���¼�
}
//��ʼ����ѯ��ť�¼�
function initQueryBtn(){
	$('#QueryBtn').click(function(){
		loadLogInfo();	
	});
}
//��ʼ����ѡ���¼�
function initCheckBox(){
	$('#ErrFlag').checkbox({
		onChecked: function(){
			loadLogInfo();
		},
		onUnchecked: function(){
			loadLogInfo();
		}	
	});
}
//��ʼ��IP��ַ������
function initIPAddrCombo(){
	var StDate=tkMakeServerCall("BILL.EINV.BL.COM.LogInfoCtl","FormatDate",$('#StDate').datebox('getValue'));
	var EdDate=tkMakeServerCall("BILL.EINV.BL.COM.LogInfoCtl","FormatDate",$('#EdDate').datebox('getValue'));
	$HUI.combobox("#IPAddr",{
		url:$URL,
		mode:'remote',
		valueField:'IPAdress', 
		textField:'IPAdress',
		panelHeight:"auto",
		onBeforeLoad:function(param)
		{
			param.ClassName="BILL.EINV.BL.COM.LogInfoCtl"
			param.QueryName="SQLQueryList"
			param.ResultSetType="array"
			param.StDate=StDate
			param.EdDate=EdDate
		},
	});
}
//��ʼ����־�б�
function initloginfoGV(){
	$('#loginfoGV').datagrid({
		url:$URL,
		fit:true,
		border:false,
		striped:true,
		pagination:true,
		//sortName:'CreateDate',
		pageSize:20,
		pageList:[20,40,60],
    	columns:[[   
        	{field:'IPAdress',title:'�ͻ���IP',width:125,align:'center'},    
        	{field:'LogType',title:'��־����',width:100,align:'center',
        		formatter: function(value,row,index){
					if(value == "Debug"){
						value="������־";
					}else if(value == "Info"){
						value="������־";
					}else{
						value="������־";
					}
					return value
				}
        	},    
        	{field:'CreateDate',title:'��־����',width:100,align:'center',sortable:true}, 
        	{field:'CreateTime',title:'��־ʱ��',width:100,align:'center'},    
        	{field:'LogMsg',title:'��־��Ϣ',width:1000,align:'left',showTip:true,
				styler: function(value,row,index){
					if(row.LogType == 'Error'){
						return 'background-color:#ffee00;color:red;';
					}
				}
        	},    
        	{field:'LogLevel',title:'��־����',width:100},
        	{field:'UserCode',title:'����Ա����',width:100,align:'center'},
        	{field:'MacAdress',title:'�ͻ���MAC��ַ',width:120,align:'center'},
        	{field:'PayAdmType',title:'Ʊ��ҵ������',width:100,align:'center'},
        	{field:'HISPrtRowID',title:'��Ʊ��Dr',width:100,align:'center'}, 
        	{field:'OrgHISPrtRowID',title:'ԭ��ƱID',width:100,align:'center'},
        	{field:'PathCode',title:'ҵ����·��',width:100,align:'center'}, 
        	{field:'ExpStr',title:'�����չ����',width:100,align:'center'},
        	{field:'XStr1',title:'��չ����1',width:100,align:'center'},
        	{field:'XStr2',title:'��չ����2',width:100,align:'center'},
        	{field:'XStr3',title:'��չ����3',width:100,align:'center'},
        	{field:'XStr4',title:'��չ����4',width:100,align:'center'},
        	{field:'XStr5',title:'��չ����5',width:100,align:'center'},  
    	]]
	});	
}
//��ʼ������
function initDate(){
	$('#StDate').datebox({
    	onSelect: function(){
        	loadIPAddrInfo();
   		}
	});
	$('#EdDate').datebox({
    	onSelect: function(){
        	loadIPAddrInfo();
   		}
	});
	//��ȡ��ǰ����
	var nowDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + new Date().getDate();
	//���ÿ�ʼ����ֵ
	$('#StDate').datebox('setValue', nowDate);
	//���ý�������ֵ
	$('#EdDate').datebox('setValue', nowDate);
}
//����datagrid����
function loadLogInfo(){
	var StDate = $('#StDate').datebox('getValue');
	var EdDate = $('#EdDate').datebox('getValue');
	var IPAddr = $('#IPAddr').combobox('getValue');
	if($('#ErrFlag').is(':checked')){
		var ErrFlag = 'ON';
	}else{
		var ErrFlag = 'OFF';	
	}
	$('#loginfoGV').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.LogInfoCtl",
		QueryName:"QueryLogInfo",
		StDate:StDate,
		EdDate:EdDate,
		IPAddr:IPAddr,
		ErrFlag:ErrFlag
	});		
}
//����IP����������
function loadIPAddrInfo(){
	var StDate=tkMakeServerCall("BILL.EINV.BL.COM.LogInfoCtl","FormatDate",$('#StDate').datebox('getValue'));
	var EdDate=tkMakeServerCall("BILL.EINV.BL.COM.LogInfoCtl","FormatDate",$('#EdDate').datebox('getValue'));
	$cm({
		ClassName:"BILL.EINV.BL.COM.LogInfoCtl",
		QueryName:"SQLQueryList",
		ResultSetType:"array",
		StDate:StDate,
		EdDate:EdDate
	},function(Data){
		if(Data.length > 0){
			$('#IPAddr').combobox('loadData', Data);
		}
	});
}