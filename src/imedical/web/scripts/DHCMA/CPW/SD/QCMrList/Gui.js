//ҳ��Gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
    $.parser.parse(); // ��������ҳ�� 
    var HospID=session['DHCMA.HOSPID']
	obj.HospID=HospID
	$('#winConfirmInfo').dialog({
		title: '�뵥���ֹ�����Ϣ¼�롿',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		isTopZindex:true,	
		height: 400
	})
    $HUI.combobox('#Hospital',
	    {
			url:$URL+'?ClassName=DHCMA.Util.EPS.HospitalSrv&QueryName=QryHospInfo&ResultSetType=Array&aHospID='+HospID,
			valueField:'OID',
			textField:'Desc',
	    	onSelect:function(rd){
		    	HospID=rd.OID;
		    	var url =$URL+'?ClassName=DHCMA.Util.EPS.LocationSrv&QueryName=QryLocInfo&ResultSetType=Array&aHospID='+HospID+'&aType=E&aAdmType=I';
        		$('#DishLoc').combobox('setValue','');
        		$('#DishLoc').combobox('reload', url);
		   },
		   onLoadSuccess:function(){
			   	Common_SetValue('Hospital',HospID);
			   }		    
	    } )	
    $HUI.combobox('#DishLoc',
	    {
			url:$URL+'?ClassName=DHCMA.Util.EPS.LocationSrv&QueryName=QryLocInfo&ResultSetType=Array&aHospID='+HospID+'&aType=E&aAdmType=I',
			valueField:'OID',
			textField:'Desc'		    
	    })	
	 if ((tDHCMedMenuOper['admin'])||(tDHCMedMenuOper['HosAdmin']))
	 {}
	 else {
		Common_SetValue('DishLoc',session['DHCMA.CTLOCID']);
		$("#DishLoc").combobox('disable'); 
		$("#Hospital").combobox('disable'); 
	 }
	 if (session['DHCMA.CTLOCID']==undefined) {
			var InLocID=session['LOGON.CTLOCID']
		}else{
			var InLocID=session['DHCMA.CTLOCID']
	}	
	obj.gridQCMrList = $HUI.datagrid("#gridQCMrList",{
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		singleSelect: true,
		//�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		autoRowHeight: false,
		striped:true,
		rownumbers:true, 
		pageSize: 10,
		pageList : [10,50],
	    url:$URL,
	    nowrap:false,
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDS.QCMrListSrv",
			QueryName:"QryPatientByDate"	
	    },
		columns:[[
			{field:'AdmLocDesc',title:'����',width:120,align:'left'},
			{field:'MrNo',title:'������',width:80,align:'left'},
			{field:'PatName',title:'��������',width:80,sortable:false,align:'left'},
			{field:'AdmDate',title:'��Ժ����',width:100,sortable:true,align:'left'},
			{field:'DisDate',title:'��Ժ����',width:100,sortable:true,align:'left'},		
			{field:'EpisodeID',title:'סԺ����',width:90,align:'left',sortable:true,
				formatter: function(value,rd,index){
						var paadm=rd.EpisodeID.split('!!')[0]
						var patientID=rd.PatientID
						return " <a href='#' class='hisui-linkbutton hover-dark' style='cursor:pointer' onclick='objScreen.DisplayEPRView(\"" + paadm + "\",\"" + patientID + "\");'>"+$g('�������')+"</a>";
				}
			},
			{field:'MrListID',title:'��״̬',width:100,sortable:true,align:'left',
				formatter: function(value,rd,index){
					if (rd.MrListID) {
						var rdModal=JSON.stringify(rd)
						if (rd.QCCurrStatus.indexOf("�ų�")<0) {
							return '<a style="cursor:pointer" class="hisui-linkbutton" onclick=objScreen.layer('+index+')>'+$g(rd.QCCurrStatus)+'</a>';
						}else{
							return '<a style="cursor:pointer" class="hisui-linkbutton" onclick=objScreen.InSDManager('+index+')>'+$g("�ų�������")+'</a>';	
						}
					}else{
						var rdModal=JSON.stringify(rd)
						return '<a style="cursor:pointer" class="hisui-linkbutton" onclick=objScreen.InSDManager('+index+')>'+$g("���鵥����")+'</a>';
						}
				}			
			
			},
			{field:'FPMDiag',title:'��Ŀ�����',width:'150',sortable:true,align:'left'}
			,
			{field:'ClinMDiag',title:'�ٴ������',width:'150',sortable:true,align:'left'}
		]]
	});
	
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


