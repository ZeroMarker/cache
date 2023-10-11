(function($) {
	$(function() {
		$('#inputNurseSubitFlag').combobox({
			valueField: 'id',
			textField: 'text',
			panelHeight: 'auto',
			data: [{
				id: 'A',
				text: $g('全部')
			}, {
				id: 'Y',
				text: $g('已提交')
			}, {
				id: 'N',
				text: $g('未提交'),
				selected: true
			}, {
				id: 'B',
				text: $g('退回')
			}]
		});
		
		$('#nurseSubmitTable').datagrid({
			iconCls: 'icon-paper',
			fit: true,
			border: false,
			toolbar: '#nurseSubmitToolbar',
			queryParams: {
				Action:'nursubmitepisodeinfolist',
				StartDate:'',
				EndDate:'',
				LocID:'',
				WardID:'',
				EpisodeID:'',
				RegNo:'',
				MedRecordNo:'',
				PatName:'',
				NurSubmitFlag:''
			},
			rownumbers: true,
			singleSelect: false,
			pagination: true,
			pageSize: 20,
			pageList: [10, 20, 50],
			columns: [[
				{field:'ck',title:'sel',checkbox:true},
				{field:'PAPMIName',title:$g('患者姓名'),width:100},
				{field:'NurSubmit',title:$g('护士提交'),width:80},
				{field:'DocSubmit',title:$g('医生提交'),width:80},
				{field:'ScanFlag',title:$g('是否扫描'),width:80},
				{field:'SubmitTime',title:$g('时效性'),width:80},
				{field:'PADischgeDateTime',title:$g('出院时间'),width:180},
				{field:'PAAdmLoc',title:$g('科室'),width:120},
				{field:'PAAdmWard',title:$g('病区'),width:160},
				{field:'PAAdmBed',title:$g('病床'),width:80},
				{field:'PAAdmDoc',title:$g('主治医生'),width:80},
				{field:'PAPMIAge',title:$g('年龄'),width:80},
				{field:'PAPMISex',title:$g('性别'),width:80},
				{field:'PAAdmDateTime',title:$g('入院日期'),width:180}
			]],
			rowStyler: function(index,row) {
				if(row.DeathFlag=='y')
				{
					return 'background-color:pink;color:blue;font-weight:bold;';
				}
			},
			onClickRow: function(rowIndex,rowData) {
				
			}
		});
		
		$("#nurseSubmitSearchBtn").on('click', function() {
			var url = '../DHCEPRFS.web.eprajax.AjaxEpisodeView.cls';
			$('#nurseSubmitTable').datagrid('options').url = url;
			var queryParams = $('#nurseSubmitTable').datagrid('options').queryParams;
			queryParams.StartDate = $('#inputStartDate').datebox('getValue');
			queryParams.EndDate = $('#inputEndDate').datebox('getValue');
			queryParams.LocID = LocID;
			queryParams.WardID = WardID;
			queryParams.RegNo = $('#inputRegNo').val();
			queryParams.MedRecordNo = $('#inputMedRecordNo').val();
			queryParams.PatName = $('#inputPatName').val();
			queryParams.EpisodeID = $('#inputEpisodeID').val();
			queryParams.NurSubmitFlag = $('#inputNurseSubitFlag').combobox("getValue");
			$('#nurseSubmitTable').datagrid('options').queryParams = queryParams;
			$('#nurseSubmitTable').datagrid('reload');
		});
		
		$("#nurseSubmitBtn").on('click',function(){
			var rows = $("#nurseSubmitTable").datagrid("getSelections");
			var episodeIds = "";
			console.log(rows[0])
			for(var i=0;i<rows.length;i++)
			{
				if(rows[i].NurSubmit!="y")
				{
					episodeIds = episodeIds+rows[i].EpisodeID+"^";
				}
			}
			if(episodeIds!="")
			{
				episodeIds = episodeIds.substring(0,episodeIds.length-1)
			}
			if(episodeIds!="")
			{
				var obj = $.ajax({
					url: '../DHCEPRFS.web.eprajax.AdmMRStatusMgr.cls',
					data: {
						ActionType: 'nurSubmitBatch',
						UserID: UserID,
						EpisodeID: episodeIds
					},
					type: 'post',
					async: false
				});
				var ret = obj.responseText;
				if (parseInt(ret) > 0) {
					$.messager.alert($g('完成'),$g('申请成功！'),'info',function(){
						for(var i=0;i<rows.length;i++){
							var data=rows[i];
							var index=$('#nurseSubmitTable').datagrid('getRowIndex',data);
							$('#nurseSubmitTable').datagrid('deleteRow',index);
						}
					});
				}
				else {
					$.messager.alert($g('错误'),$g('申请失败，请再次尝试！')+ret,'error');
					return;
				}
			}
		});
		
		$('#inputStartDate').datebox('setValue', formatterDate(new Date(new Date().setDate(new Date().getDate()-7))));
		$('#inputEndDate').datebox('setValue', formatterDate(new Date()));
	})
})(jQuery);

function formatterDate(date) {
	var day = date.getDate() > 9 ? date.getDate() : "0" + date.getDate();
	var month = (date.getMonth() + 1) > 9 ? (date.getMonth() + 1) : "0"
		+ (date.getMonth() + 1);
	return date.getFullYear() + '-' + month + '-' + day;
}