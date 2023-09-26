function InitAnt(obj){
	
	obj.refreshgridINFAnti = function(){
		if(obj.gridINFAnti==undefined)
		{
			// 抗菌药物信息
			obj.gridINFAnti = $("#gridINFAnti").DataTable({
				dom: 'rt',
				paging:false,
				select: 'single',
				ordering: false,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFAntiSrv";
						d.QueryName = "QryINFAntiByRep";
						d.Arg1 = ReportID;
						d.Arg2 = '';
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "AntiDesc"}
					,{"data": "SttDate"}
					,{"data": "EndDate"}
					,{"data": "DoseQty"}
					,{"data": "DoseUnit"}
					,{"data": "PhcFreq"}
					,{"data": "MedUsePurpose"}
					,{"data": "AdminRoute"}
					,{"data": "MedPurpose"}
					,{"data": "TreatmentMode"}
					,{"data": "PreMedEffect"}
					,{"data": "PreMedIndicat"}
					,{"data": "CombinedMed"}
					,{"data": "PreMedTime"}
					,{"data": "PostMedDays"}
					,{"data": "SenAna"}
				]
			});
		}else{
			obj.gridINFAnti.ajax.reload(function(){});
		}
	}
	//obj.refreshgridINFAnti();
	OpenINFAntiSync();
	function refreshgridINFAntiSync(){
		if(obj.gridINFAntiSync==undefined)
		{
			obj.gridINFAntiSync = $("#gridINFAntiSync").DataTable({
				dom: 'rt',
				paging:false,
				select: 'single',
				ordering: false,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFAntiSrv";
						d.QueryName = "QryINFAntiByRep1";
						d.Arg1 = '';
						d.Arg2 = EpisodeID;
						d.Arg3 = SurvNumber;
						d.ArgCnt = 3;
					}
				},
				columns: [
					{"data": "AntiDesc"}
					,{"data": "SttDate"}
					,{"data": "EndDate"}
					,{"data": "DoseQty"}
					,{"data": "DoseUnit"}
					,{"data": "PhcFreq"}
					,{"data": "AdminRoute"}
					,{"data": "MedPurpose"}
					
				]
			});
			obj.gridINFAntiSync.on('dblclick', 'tr', function(e) {
				var data  = obj.gridINFAntiSync.row(this).data();
				if (typeof(data)=='undefined') return;
				//layer.closeAll();
				//OpenINFAntiEdit(data,'');
			});
		}else{
			obj.gridINFAntiSync.ajax.reload(function(){});
		}
	}
	// 弹出抗菌药物提取框
	function OpenINFAntiSync(){
		// TODO同步医嘱
		//$.Tool.RunServerMethod('DHCHAI.DI.DHS.SyncHisInfo','SyncAdmOEOrdItem',HISCode,EpisodeIDx,ServiceDate,ServiceDate);
		refreshgridINFAntiSync();
		
	}
	

	obj.ANT_Save = function(){
		// 抗菌药物
    	var InputAnti = '';	
    	
    	return InputAnti;
	}
}