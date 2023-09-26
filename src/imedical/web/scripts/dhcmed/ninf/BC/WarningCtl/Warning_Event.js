function InitWarningCtlEvent(obj){
	obj.LoadEvent = function(args)
	{
		Common_SetValue('cbgViewType','1');
		/*var curDate = new Date();
		var preDate = new Date(curDate.getTime() - 24*60*60*1000);
		var timeYesterday = preDate.format("Y") +"-" +preDate.format("m") + "-"+(preDate.format("d"));
		Common_SetValue('txtWarningDate',timeYesterday);*/
		obj.txtWarningDate.setValue(new Date().add(Date.DAY,-1));
		obj.btnQuery.on("click",obj.btnQuery_onClick,obj);
		
		//����ҳ��ʱ�Զ�����Ԥ��
    	obj.btnQuery_onClick();
  	};
	
	//ɸ�鲡����ѯ
	obj.btnQuery_onClick = function()
	{
		//Add By LiYang 2014-07-09 FixBug:2075 ҽԺ��Ⱦ����-��Ⱦ�ۺϼ��-��Ⱦ����Ԥ��������ѡ���С���ʾ��ʽ��Ҳ���Բ�ѯ��Ԥ������
		var type1 = Ext.getCmp("cbgViewType-1").getValue();
		var type2 = Ext.getCmp("cbgViewType-2").getValue();
		if((type1 == false)&&(type2 == false))
		{
			ExtTool.alert("������ʾ","��ѡ��һ����ʾ��ʽ��");
			return;
		}
	
	
		obj.QueryArgs.ViewType = Common_GetValue('cbgViewType');
		obj.QueryArgs.WarningDate = Common_GetValue('txtWarningDate');
		obj.QueryArgs.HospitalID = Common_GetValue('cboSSHosp');
		
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.NINFService.BC.WarningSrv',
				QueryName : 'QryWarningCnt',
				Arg1 : SubjectCode,
				Arg2 : obj.QueryArgs.WarningDate,
				Arg3 : obj.QueryArgs.HospitalID,
				ArgCnt : 3
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				
				//��ʼ������������(obj.LocGrpData)
				obj.LocGrpData = new Object();
				
				//��ʼ��Ԥ����������(obj.LocGrpData.WarningDays)
				obj.LocGrpData.WarningDays = new Array();
				var strDateList = ExtTool.RunServerMethod("DHCMed.NINFService.BC.WarningSrv", "GetWarningDays", obj.QueryArgs.WarningDate);
				obj.LocGrpData.WarningDays = strDateList.split(',');
				
				//�������������(obj.LocGrpData)
				obj.ProcLocGrpData(objData,obj.QueryArgs.ViewType);
				
				if (obj.LocGrpData.LocGrpList.length<1) {
					var objLocGroup = {
						LocGroup : "",
						LocList : new Array(),
						LocListI : new Array()
					};
					obj.LocXTemplate.overwrite("LocXTemplateDIV", [objLocGroup]);
				} else {
					obj.LocXTemplate.overwrite("LocXTemplateDIV", obj.LocGrpData.LocGrpList);
				}
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById("LocXTemplateDIV");
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	//�������������(obj.LocGrpData)
	obj.ProcLocGrpData = function(objData,aViewType)
	{
		obj.LocGrpData.LocGrpList = new Array();
		obj.LocGrpData.LocGrpListI = new Array();
		
		var objItem = null;
		for(var i = 0; i < objData.total; i ++)
		{
			objItem = objData.record[i];
			if (!objItem) continue;
			
			var LocID = objItem.LocID;
			var LocDesc = objItem.LocDesc;
			var LocType = objItem.LocType;
			var LocGroup = objItem.LocGroup;
			if (aViewType == '1') {
				if (objItem.LocType != 'E') continue;
			} else {
				if (objItem.LocType != 'W') continue;
			}
			var DataValue = objItem.DataValue;
			if (!DataValue) continue;
			
			if (typeof(obj.LocGrpData.LocGrpListI[LocGroup]) != 'undefined') {
				var ind = obj.LocGrpData.LocGrpListI[LocGroup];
				var objLocGroup = obj.LocGrpData.LocGrpList[ind];
				
				if (typeof(objLocGroup.LocListI[LocID]) != 'undefined') {
					var ind = objLocGroup.LocListI[LocID];
					var objLoc = objLocGroup.LocList[ind];
					
					if (typeof(objLoc.WarningListI[DataValue]) != 'undefined') {
						var ind = objLoc.WarningListI[DataValue];
						var objWarning = objLoc.WarningList[ind];
					} else {
						var objWarning = objItem;
						var ind = objLoc.WarningList.length;
						objLoc.WarningList[ind] = objItem;
						objLoc.WarningListI[DataValue] = ind;
					}
				} else {
					var objLoc = {
						LocID : LocID,
						LocDesc : LocDesc,
						LocType : LocType,
						LocGroup : LocGroup,
						WarningList : new Array(),
						WarningListI : new Array()
					};
					var objWarning = objItem;
					var ind = objLoc.WarningList.length;
					objLoc.WarningList[ind] = objWarning;
					objLoc.WarningListI[DataValue] = ind;
					var ind = objLocGroup.LocList.length;
					objLocGroup.LocList[ind] = objLoc;
					objLocGroup.LocListI[LocID] = ind;
				}
			} else {
				var objLocGroup = {
					LocGroup : LocGroup,
					LocList : new Array(),
					LocListI : new Array()
				};
				var objLoc = {
					LocID : LocID,
					LocDesc : LocDesc,
					LocType : LocType,
					LocGroup : LocGroup,
					WarningList : new Array(),
					WarningListI : new Array()
				};
				var objWarning = objItem;
				var ind = objLoc.WarningList.length;
				objLoc.WarningList[ind] = objWarning;
				objLoc.WarningListI[DataValue] = ind;
				var ind = objLocGroup.LocList.length;
				objLocGroup.LocList[ind] = objLoc;
				objLocGroup.LocListI[LocID] = ind;
				var ind = obj.LocGrpData.LocGrpList.length;
				obj.LocGrpData.LocGrpList[ind] =objLocGroup;
				obj.LocGrpData.LocGrpListI[LocGroup] = ind;
			}
			var ind = objLoc.WarningListI[DataValue];
			objLoc.WarningList[ind] = objWarning;
			var ind = objLocGroup.LocListI[LocID];
			objLocGroup.LocList[ind] = objLoc;
			var ind = obj.LocGrpData.LocGrpListI[LocGroup];
			obj.LocGrpData.LocGrpList[ind] = objLocGroup;
		}
	}
	
	obj.LoadWarningList = function(aLocID,aDataValue,aDayCode)
	{
		//�鿴��ϸ����
		WarningDtlLookUpHeader(SubjectCode, obj.QueryArgs.WarningDate, obj.QueryArgs.HospitalID, aDayCode, aLocID, aDataValue)
	}
}