//ҳ��Event
function InitCheckQueryWinEvent(obj){	
    
	obj.LoadEvent = function(args){
		//��ѯ
		$('#btnQuery').on('click', function(){
			obj.CheckQueryLoad();
		});
		//����ѡ���ж�
		$HUI.datebox("#DateFrom", {
			onSelect:function(){
				var ret=Common_CompareDate(Common_GetValue("DateFrom"),Common_GetValue("DateTo"));				
				if (ret>0) {
					$.messager.popover({msg: '��ʼ���ڲ��ܴ��ڽ������ڣ�',type:'error',timeout: 1000})
					Common_SetValue("DateFrom",'');
					}
			}
		});
		$HUI.datebox("#DateTo", {
			onSelect:function(){
				var ret=Common_CompareDate(Common_GetValue("DateFrom"),Common_GetValue("DateTo"));
				if (ret>0) {
					$.messager.popover({msg: '�������ڲ���С�ڿ�ʼ���ڣ�',type:'error',timeout: 1000})
					Common_SetValue("DateTo",'');
					}
			}
		});
		//����ѡ���¼�
		$HUI.combobox("#cboLoc", {
			onSelect:function(){
				obj.CheckQueryLoad();
			}
		});
		//ҽԺ��������
		$HUI.combobox('#cboSSHosp',{
		    onSelect:function(rows){
			    var HospID=rows["CTHospID"];
			    obj.cboLoc = Common_ComboToLoc("cboLoc","E","","",HospID);
		    }
	    });

		obj.DateFrom = Common_SetValue('DateFrom',Common_GetDate(new Date())); // ���ڳ�ʼ��ֵ
		obj.DateTo = Common_SetValue('DateTo',Common_GetDate(new Date()));
		obj.CheckQueryLoad();
	}
	obj.CheckQueryLoad = function(){
    	obj.LocID=Common_GetValue('cboLoc');
    	//if(obj.IsAdmin<1) obj.LocID=session['DHCMA.CTLOCID'].split("!!")[0];
	    $cm ({
			 ClassName:"DHCMA.IMP.IPS.IMPRegisterSrv",
			QueryName:"QryReportList",
			aReportType: Common_GetValue('cboReportType'),
			aSubType:Common_GetValue('SubStatus'),
			aLodID:obj.LocID,
			aHospID:Common_GetValue('cboSSHosp'),
			aDateFrom: Common_GetValue('DateFrom'), 
			aDateTo:Common_GetValue('DateTo'),
			page:1,
			rows:999
		},function(rs){
			$('#GridCheckQuery').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }
}