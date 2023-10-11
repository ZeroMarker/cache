//ҳ��Event
function InitHandHyQryWinEvent(obj) {
   obj.LoadEvent = function(args){
	    $('#girdHandHyQry').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0

		//��ѯ��ť
		$("#btnQuery").on('click',function(){
			obj.ReLoadData();
		});
	}
	
	//���¼��ر������
	obj.ShowHandHyReg = function(RegID,ObsLocID,ObsDate,ObsPage,ObsMethod,ObsUser){
		var strUrl = './dhcma.hai.ir.handhy.reg.csp?RegID='+RegID+'&ObsLocID='+ObsLocID+'&ObsDate='+ObsDate+'&ObsPage='+ObsPage+'&ObsMethod='+ObsMethod+'&ObsUser='+ObsUser;
		websys_showModal({
			url:strUrl,
			title:'���������ӵ���',
			iconCls:'icon-w-epr',  
			width:'95%',
			height:'95%',  //8.2���ϰ汾֧�ְٷֱȣ�8.2���µ��þ������أ���height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.ReLoadData();
			} 
		});
	}
	//���¼��ر������
	obj.ReLoadData = function(){
		var HospIDs	    = $('#cboHospital').combobox('getValue');
		var DateFrom	= $('#DateFrom').datebox('getValue');
		var DateTo		= $('#DateTo').datebox('getValue');
		var Loc 		= $("#cboLoc").combobox('getValue');
		var Method 		= $("#cboMethod").combobox('getValue');
		
		if (DateFrom==""){
			$.messager.alert("��ʾ","��ѡ��ʼ���ڣ�", 'info');
			return;
		}
		if (DateTo==""){
			$.messager.alert("��ʾ","��ѡ��������ڣ�", 'info');
			return;
		}
		if(Common_CompareDate(DateFrom,DateTo)==1){
			$.messager.alert("��ʾ","��ʼ���ڲ��ܴ��ڽ������ڣ�", 'info');
			return;
		}
		if(Common_CompareDate(DateFrom,Common_GetDate(new Date()))==1){
			$.messager.alert("��ʾ","��ʼ���ڲ��ܴ��ڵ�ǰ���ڣ�", 'info');
			return;
		}
		
		$("#girdHandHyQry").datagrid("loading");
		$cm ({
			ClassName:"DHCHAI.IRS.HandHyRegSrv",
			QueryName:"HandHyRegQry",
			ResultSetType:"array",
			aHospIDs:HospIDs,
			aLocID:Loc,
			aDateFrom:DateFrom,
			aDateTo:DateTo,
			aMethod:Method,
			page:1,
			rows:99999
		},function(rs){
			$('#girdHandHyQry').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
		
	};
}