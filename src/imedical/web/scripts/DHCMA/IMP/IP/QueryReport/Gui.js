//ҳ��Gui
function InitCheckQueryWin(){
	var obj = new Object();		
    obj.Status="";
    $.parser.parse(); // ��������ҳ��  
    
    //��ʼ��ѯ����
    obj.cboSSHosp=Common_ComboToSSHosp("cboSSHosp",SSHospCode,"IMP");
	//ҽԺ��������
	$HUI.combobox('#cboSSHosp',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    Common_ComboToLoc("cboLoc","E","","I",HospID);
		   
	    }
    });
	
	/*obj.IsAdmin = 0;
	if (tDHCMedMenuOper) {
		if (tDHCMedMenuOper['admin'] == '1') {
			obj.IsAdmin=1;
		}
	}*/
    
	obj.DateTo = $('#DateTo').datebox('setValue', Common_GetDate(new Date()));// ���ڳ�ʼ��ֵ
    obj.DateFrom = $('#DateFrom').datebox('setValue', Common_GetDate(new Date()));
    var cboReportType = $HUI.combobox("#cboReportType",{
		url:$URL+'?ClassName=DHCMA.IMP.IPS.IMPRegisterSrv&QueryName=QryReportTypeList&&aIsActive=1&aIsOper=1&ResultSetType=Array',
		valueField:'BTID',
		textField:'BTDesc'
	});
	var cboSubStatus  = $HUI.combobox("#SubStatus",{
		url:$URL+'?ClassName=DHCMA.IMP.IPS.IMPRegisterSrv&QueryName=QryReportSubType&aTypeCode=IMPRegStatus&ResultSetType=Array',
		valueField:'BTID',
		textField:'BTDesc'
	});
	
   obj.GridCheckQuery = $HUI.datagrid("#GridCheckQuery",{
		fit: true,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		autoRowHeight: true, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{title:'����',width:45,field:'EpisodeID',align:'center',
				formatter: function(value,row,index){
					if (value=="") return "";
					var EpisodeID = row["EpisodeID"];
					var CategoryDR = row["IMPCateDr"];
					var IMPOrdNo = row["IMPOrdNo"];
					var CateDesc = row["IMPCateDesc"];
					var btn = '<a href="#" class="icon-paper-info" onclick="OpenReport(\'' + EpisodeID+'\',\''+CategoryDR+'\',\''+IMPOrdNo+'\',\''+CateDesc+ '\')">&nbsp;&nbsp;&nbsp;&nbsp;</a>';
					return btn;
				}
			}, 
			{field:'MrNo',title:'������',width:'80'},
			{field:'PatientName',title:'��������',width:'80'},
			{field:'LocDesc',title:'����',width:'80'}, 
			{field:'Ward',title:'����',width:'120'},
			{field:'Sex',title:'�Ա�',width:'50'},
			{field:'Age',title:'����',width:'50'},
			{field:'IMPCateDesc',title:'��������',width:'150'},
			{field:'StatusDesc',title:'�״̬',width:'80'},
			{field:'RegDate',title:'�Ǽ�����',width:'150'},
			{field:'RegUserDesc',title:'�Ǽ���',width:'80'},
			{field:'CheckDate',title:'�������',width:'100'},
			{field:'CheckUserDesc',title:'�����',width:'150'}
		]],
		onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
		}
	});
	
	OpenReport = function(EpisodeID,CategoryDR,IMPOrdNo,IMPCateDesc) {
		if (IMPCateDesc=="��������֢"){
			var strUrl= "./dhcma.imp.ip.opercompreg.csp?1=1&EpisodeID=" + EpisodeID +"&CategoryDR="+CategoryDR+"&IMPOrdNo="+IMPOrdNo;
		    websys_showModal({
				url:strUrl,
				title:'��������֢�Ǽ�',
				iconCls:'icon-w-epr',  
				originWindow:window,
		        closable:false,
				width:1150,
				height:'90%',  //8.2���ϰ汾֧�ְٷֱȣ�8.2���µ��þ������أ���height:window.screen.availHeight-80,  
				onBeforeClose:function(){
					obj.CheckQueryLoad(); //ˢ��
				} 
			});
    		//var oWin = window.open(strUrl,'',"height=" + (window.screen.availHeight - 50) + ",width=1150,top=0,left=100,resizable=no");
		}else if(IMPCateDesc=="�Ǽƻ��ط�����"){
			var strUrl= "./dhcma.imp.ip.urtoperreg.csp?1=1&EpisodeID=" + EpisodeID +"&CategoryDR="+CategoryDR+"&IMPOrdNo="+IMPOrdNo ;
	    	websys_showModal({
				url:strUrl,
				title:'�Ǽƻ��ط������Ǽ�',
				iconCls:'icon-w-epr',  
				originWindow:window,
	        	closable:false,
				width:1150,
				height:'90%',  //8.2���ϰ汾֧�ְٷֱȣ�8.2���µ��þ������أ���height:window.screen.availHeight-80,  
				onBeforeClose:function(){
					obj.CheckQueryLoad();//ˢ��
				} 
			});
		}else if(IMPCateDesc=="Σ�ز���"){
			var strUrl= "./dhcma.imp.ip.criticalillreg.csp?1=1&EpisodeID=" + EpisodeID +"&CategoryDR="+CategoryDR+"&IMPOrdNo="+IMPOrdNo ;
	    	websys_showModal({
				url:strUrl,
				title:'Σ�ز�������',
				iconCls:'icon-w-epr',  
				originWindow:window,
	        	closable:false,
				width:1150,
				height:'90%',  //8.2���ϰ汾֧�ְٷֱȣ�8.2���µ��þ������أ���height:window.screen.availHeight-80,  
				onBeforeClose:function(){
					obj.CheckQueryLoad(); //ˢ��
				} 
			});
		}else if (IMPCateDesc=="�Ǽƻ��ط�סԺ"){
			var strUrl= "./dhcma.imp.ip.urthospreg.csp?1=1&EpisodeID=" + EpisodeID +"&CategoryDR="+CategoryDR+"&IMPOrdNo="+IMPOrdNo ;
	    	websys_showModal({
				url:strUrl,
				title:'�Ǽƻ��ط�סԺ�Ǽ�',
				iconCls:'icon-w-epr',  
				originWindow:window,
	        	closable:false,
				width:1150,
				height:'90%',  //8.2���ϰ汾֧�ְٷֱȣ�8.2���µ��þ������أ���height:window.screen.availHeight-80,  
				onBeforeClose:function(){
					obj.CheckQueryLoad(); //ˢ��
				} 
			});
		}else if(IMPCateDesc=="����סԺ"){
			var strUrl= "./dhcma.imp.ip.langhospreg.csp?1=1&EpisodeID=" + EpisodeID +"&CategoryDR="+CategoryDR+"&IMPOrdNo="+IMPOrdNo ;
	    	websys_showModal({
				url:strUrl,
				title:'����סԺ����',
				iconCls:'icon-w-epr',  
				originWindow:window,
	        	closable:false,
				width:1150,
				height:'90%',  //8.2���ϰ汾֧�ְٷֱȣ�8.2���µ��þ������أ���height:window.screen.availHeight-80,  
				onBeforeClose:function(){
					obj.CheckQueryLoad(); //ˢ��
				} 
			});
		}else{
			$.messager.alert("��ʾ", "�÷��໹û�еǼǱ�,���������!",'info');
			return;
		}
		
	}
	
	InitCheckQueryWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


