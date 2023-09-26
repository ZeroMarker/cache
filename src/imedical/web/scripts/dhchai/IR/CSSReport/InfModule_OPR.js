function InitOper(obj){
	
	/*/ 手术信息
	obj.refreshgridINFOPS = function(){
		if(obj.gridINFOPS==undefined)
		{
			obj.gridINFOPS = $("#gridINFOPS").DataTable({
				dom: 'rt',
				paging:false,
				select: 'single',
				ordering: false,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFOPSSrv";
						d.QueryName = "QryINFOPSByRep";
						d.Arg1 = ReportID;
						d.Arg2 = '';
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "OperName"}
					,{"data": "OperType"}
					,{"data": "OperLoc"}
					,{	
						"data": null,
						render: function ( data, type, row ) {
							var OperDateTime = data.OperDate+' '+data.SttTime
							return OperDateTime;
						}
					},{	
						"data": null,
						render: function ( data, type, row ) {
							var OperDateTime = data.EndDate+' '+data.EndTime
							return OperDateTime;
						}
					}
					,{"data": "OperDocTxt"}
					,{"data": "Anesthesia"}
					,{"data": "CuteType"}
					,{"data": "CuteHealing"}
					,{"data": "IsOperInf", 
						render: function ( data, type, row ) {
							if (data=="1"){
								return '是';
							}else{
								return '否'
							}
						}
					}
					,{"data": "InfType"}
					,{"data": "IsInHospInf", 
						render: function ( data, type, row ) {
							if (data=="1"){
								return '是';
							}else{
								return '否'
							}
						}
					}
				]
			});
		}else{
			obj.gridINFOPS.ajax.reload(function(){});
		}
	}
	//obj.refreshgridINFOPS();
	*/
	function refreshgridINFOPSSync(){
		if(obj.gridINFOPSSync==undefined)
		{
			obj.gridINFOPSSync = $("#gridINFOPSSync").DataTable({
				dom: 'rt',
				paging:false,
				select: 'single',
				ordering: false,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFOPSSrv";
						d.QueryName = "QryINFOPSByRep";
						d.Arg1 = '';
						d.Arg2 = EpisodeID;
						d.Arg3 = 0;//默认不查询历史信息
						d.ArgCnt = 3;
					}
				},
				columns: [
					{"data": "OperName"}
					,{"data": "OperType"}
					,{"data": "OperLoc"}
					,{	
						"data": null,
						render: function ( data, type, row ) {
							var OperDateTime = data.OperDate+' '+data.SttTime
							return OperDateTime;
						}
					},{	
						"data": null,
						render: function ( data, type, row ) {
							var OperDateTime = data.EndDate+' '+data.EndTime
							return OperDateTime;
						}
					}
					,{"data": "OperDocTxt"}
					,{"data": "Anesthesia"}
					,{"data": "CuteType"}
					,{"data": "CuteHealing"}
				]
			});
			obj.gridINFOPSSync.on('dblclick', 'tr', function(e) {
				var data  = obj.gridINFOPSSync.row(this).data();
				if (typeof(data)=='undefined') return;
				//layer.closeAll();
				//OpenINFOPSEdit(data,'');
			});
		}else{
			obj.gridINFOPSSync.ajax.reload(function(){});
		}
	}

	// 弹出手术信息提取框
	function OpenINFOPSSync(){
		/// TODO同步手术
		//$.Tool.RunServerMethod('DHCHAI.DI.DHS.SyncOpsInfo','SyncOperByDateAdm',OPSSCode,EpisodeIDx,ServiceDate,ServiceDate);
		refreshgridINFOPSSync();
	}
	OpenINFOPSSync();
	
	obj.OPRinitset = function(){
		//自动获取手术信息
		if ((obj.gridINFOPSSync!=undefined)&&(obj.gridINFOPSSync.data().length>0)){
			CuteTypeID = obj.gridINFOPSSync.data()[0].CuteTypeID;
			CuteType   = obj.gridINFOPSSync.data()[0].CuteType;
			IROperDate = obj.gridINFOPSSync.data()[0].OperDate;
			IROperName = obj.gridINFOPSSync.data()[0].OperName;
			
			$.form.SetValue("chkCSSIsOpr",true);
			$.form.SetValue("cboCSSIncisionr",CuteTypeID,CuteType);
			$.form.DateTimeRender('OperDate',IROperDate);
			$.form.SetValue("txtOperName",IROperName);
		}
	}
}