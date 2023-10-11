//全局
var FSRecallRecord = FSRecallRecord || {
	DateStart: '',
	DateEnd: '',
	TypeCode: 'A',
	SelectEpisode: '',
	ReasonSelectID: '',
	ReasonUserID: ''
};

//配置和静态
FSRecallRecord.Config = FSRecallRecord.Config || {
	DATESPAN: 7,
	PAGESIZE: 30,
	PAGELIST: [10, 20, 30, 50, 100],
	ERROR_INFO: '错误',
	ERROR_INFO_OPERATION: '操作失败，请重新尝试或联系管理员',
	ERROR_INFO_NOREASON: '请填写申请原因',
	ERROR_INFO_NOEPISODESELECTED: '请先选中一条就诊'
};

(function (win) {
	$(function () {
		$g = window.$g || function(a){return a;};
		//召回原因所属用户
		if (reasonFlag == '1') {
			FSRecallRecord.ReasonUserID = 'SYS';
		}
		else {
			FSRecallRecord.ReasonUserID = userID;
		}
		
		$('#dbStartDate').datebox({
			onSelect: function() {
				FSRecallRecord.DateStart = $('#dbStartDate').datebox('getValue');
			},
			onChange: function() {
				FSRecallRecord.DateStart = $('#dbStartDate').datebox('getValue');
			}
		});
		
		$('#dbEndDate').datebox({
			onSelect: function() {
				FSRecallRecord.DateEnd = $('#dbEndDate').datebox('getValue');
			},
			onChange: function() {
				FSRecallRecord.DateEnd = $('#dbEndDate').datebox('getValue');
			}
		});
		setDefaultDate();
		
		$('#cbbDocSubmit').combobox({
			valueField: 'code',
			textField: 'text',
			data: [{
				code: 'a',
				text: $g('全部'),
				selected: true
			}, {
				code: 'y',
				text: $g('是')
			}, {
				code: 'n',
				text: $g('否')
			}]
		});
		
		$('#cbbNurSubmit').combobox({
			valueField: 'code',
			textField: 'text',
			data: [{
				code: 'a',
				text: $g('全部'),
				selected: true
			}, {
				code: 'y',
				text: $g('是')
			}, {
				code: 'n',
				text: $g('否')
			}]
		});
		
		$('#cbbPDFCreated').combobox({
			valueField: 'code',
			textField: 'text',
			data: [{
				code: 'a',
				text: $g('全部'),
				selected: true
			}, {
				code: 'y',
				text: $g('是')
			}, {
				code: 'n',
				text: $g('否')
			}]
		});
		
		//查询
		$('#btnSearch').on('click', function() {
			searchEpisode();
		});
		
		//重置
		$('#btnReset').on('click', function() {
			setDefaultDate();
			$('#cbbDocSubmit').combobox('select','a');
			$('#cbbNurSubmit').combobox('select','a');
			$('#cbbPDFCreated').combobox('select','a');
			$('#tbMRNo').val('');
			$('#tbRegNo').val('');
			$('#tbPatName').val('');
		});
		
		$('#tbMRNo').on('keypress', function(event) {
			if (event.keyCode == '13') {
				searchEpisode();
			}
		});
		
		$('#tbRegNo').on('keypress', function(event) {
			if (event.keyCode == '13') {
				searchEpisode();
			}
		});
		
		$('#tbPatName').on('keypress', function(event) {
			if (event.keyCode == '13') {
				searchEpisode();
			}
		});
		
		//病历列表
		$HUI.datagrid('#mrlist',{
			fit: true,
			border: false,
			toolbar: '#mrtoolbar',
			url: $URL,
			queryParams: {
				ClassName: 'DHCEPRFS.BL.BLReview',
				QueryName: 'GetDeptEpisodeList',
				AType: FSRecallRecord.TypeCode,
				AStartDate: '',
				AEndDate: '',
				AMedRecordNo: '',
				ARegNo: '',
				AName: '',
				ACTLocIDS: userLocID,
				ADocCommit: '',
				ANurCommit: '',
				APDFCreated: ''
			},
			rownumbers: true,
			singleSelect: true,
			pagination: true,
			pageSize: FSRecallRecord.Config.PAGESIZE,
			pageList: FSRecallRecord.Config.PAGELIST,
			columns: [[
				{field:'ck',checkbox:true},
				{field:'EprDocStatus',title:'EprDocStatus',width:60,hidden:true},
				{field:'EprDocStatusDesc',title:'医生提交',width:80,styler:cellStyler},
				{field:'EprNurStatus',title:'EprNurStatus',width:60,hidden:true},
				{field:'EprNurStatusDesc',title:'护士提交',width:80,styler:cellStyler},
				{field:'EprPdfStatus',title:'EprPdfStatus',width:60,hidden:true},
				{field:'EprPdfStatusDesc',title:'是否生成',width:80,styler:cellStyler},
				{field:'EPRURL',title:'电子病历',width:70,formatter:eprURLFormatter,hidden:true},
				{field:'MedRecordNo',title:'病案号',width:100,sortable:true},
				{field:'RegNo',title:'登记号',width:100,sortable:true},
				{field:'PAPMIName',title:'患者姓名',width:80},
				{field:'DisDate',title:'出院日期',width:100,sortable:true},
				{field:'DisTime',title:'出院时间',width:100,sortable:true},
				{field:'PAAdmDepCodeDR',title:'就诊科室',width:120},
				{field:'Warddesc',title:'病区',width:130},
				{field:'PAPMIDOB',title:'出生日期',width:100},
				{field:'PAPMISex',title:'性别',width:60},
				{field:'AdmDate',title:'入院日期',width:100},
				{field:'AdmTime',title:'入院时间',width:100},
				{field:'PAAdmDocCodeDR',title:'主治医生',width:80},
				{field:'EpisodeID',title:'就诊号',width:80,hidden:true},
				{field:'PatientID',title:'病人号',width:80,hidden:true}
			]]
		});
		
		$('#dlgRecall').dialog({
			title: '召回申请',
			iconCls: 'icon-w-back',
			closed: true,
			modal: true,
			buttons: [{
				text: '申请',
				handler: function() {
					applyRecall();
				}
			},{
				text: '取消',
				handler: function() {
					$('#dlgRecall').dialog('close');
				}
			}]
		});
		
		//病历召回
		$('#btnRecall').on('click', function() {
			var row = $('#mrlist').datagrid('getSelected');  //取当前选中行
			if (row == null) {
				$.messager.popover({msg:FSRecallRecord.Config.ERROR_INFO_NOEPISODESELECTED,type:'alert',timeout:2000});
				return;
			}
			else {
				FSRecallRecord.SelectEpisode = row.EpisodeID;
				var obj = $.ajax({
					url: '../DHCEPRFS.web.eprajax.AjaxAuthorizationInfo.cls',
					data: {
						Action: 'recallrecord',
						EpisodeID: FSRecallRecord.SelectEpisode,
						UserID: userID,
						ClinicFlag: clinicFlag
					},
					type: 'post',
					async: false
				});
				var ret = obj.responseText;
				var retArr = ret.split('^');
				if (retArr[0] == '-3') {
					$.messager.alert('提示',retArr[1],'info');
					return;
				}
				else if (retArr[0] == '2') {
					$('#dlgRecall').dialog('open');
					if (reasonFlag == '1') {
						$('#btnAddReason').hide();
						$('#btnSaveReason').hide();
						$('#btnRemoveReason').hide();
					}
				}
				else if (retArr[0] != '1') {
					$.messager.alert(FSRecallRecord.Config.ERROR_INFO,'病历召回操作失败！','error');
					return;
				}
				else {
					$.messager.alert('提示','病历召回操作成功。','info',function() {
						searchEpisode();
					});
				}
			}
		});
		
		//提交
		function applyRecall() {
			var reason = encodeText($('#taReason').val());
			if (reason === '') {
				$.messager.popover({msg:FSRecallRecord.Config.ERROR_INFO_NOREASON,type:'alert',timeout:2000});
				return;
			}
			else {
				var obj = $.ajax({
					url: '../DHCEPRFS.web.eprajax.AjaxAuthorizationInfo.cls',
					data: {
						Action: 'apply',
						RequestAct: 'REVOKE',
						EpisodeID: FSRecallRecord.SelectEpisode,
						UserID: userID,
						UserLocID: userLocID,
						Reason: reason,
						ClinicFlag: clinicFlag
					},
					type: 'post',
					async: false
				});
				FSRecallRecord.SelectEpisode = '';
				var ret = obj.responseText;
				if (ret != '1') {
					$.messager.alert(FSRecallRecord.Config.ERROR_INFO,FSRecallRecord.Config.ERROR_INFO_OPERATION,'error');
					return;
				}
				else {
					$.messager.alert('提示','申请成功！','info',function() {
						$('#dlgRecall').dialog('close');
					});
				}
			}
		}
		
		$('#cbbRecallReason').combobox({
			valueField: 'CategoryID',
			textField: 'CategoryDesc',
			url: '../DHCEPRFS.web.eprajax.AjaxAuthorizationInfo.cls?Action=loadrecallreason&UserID=' + FSRecallRecord.ReasonUserID,
			method: 'get',
			onSelect: function(rec) {
				var reason = decodeText(rec['Reason']);
				$('#taReason').val(reason);
				FSRecallRecord.ReasonSelectID = rec['CategoryID'];
			}
		});
		
		$('#btnAddReason').on('click', function() {
			var inputText = $('#cbbRecallReason').combobox('getText');
			inputText = inputText.replace(/^\s*|\s*$/g,'');  //去除两端空格
			if (inputText === '') {
				return;
			}
			var reason = encodeText($('#taReason').val());
			var obj = $.ajax({
				url: '../DHCEPRFS.web.eprajax.AjaxAuthorizationInfo.cls',
				data: {
					Action: 'addrecallreason',
					UserID: userID,
					CategoryDesc: inputText,
					Reason: reason
				},
				type: 'post',
				async: false
			});
			var ret = obj.responseText;
			if (ret === '1') {
				FSRecallRecord.ReasonSelectID = '';
				$('#cbbRecallReason').combobox('reload');
			}
			else {
				$.messager.alert(FSRecallRecord.Config.ERROR_INFO,FSRecallRecord.Config.ERROR_INFO_OPERATION,'error');
			}
		});
		
		$('#btnSaveReason').on('click', function() {
			if (FSRecallRecord.ReasonSelectID == '') {
				return;
			}
			var reason = encodeText($('#taReason').val());
			var obj = $.ajax({
				url: '../DHCEPRFS.web.eprajax.AjaxAuthorizationInfo.cls',
				data: {
					Action: 'saverecallreason',
					CategoryID: FSRecallRecord.ReasonSelectID,
					Reason: reason
				},
				type: 'post',
				async: false
			});
			var ret = obj.responseText;
			if (ret === '1') {
				FSRecallRecord.ReasonSelectID = '';
				$('#cbbRecallReason').combobox('reload');
			}
			else {
				$.messager.alert(FSRecallRecord.Config.ERROR_INFO,FSRecallRecord.Config.ERROR_INFO_OPERATION,'error');
			}
		});
		
		$('#btnRemoveReason').on('click', function() {
			if (FSRecallRecord.ReasonSelectID == '') {
				return;
			}
			var obj = $.ajax({
				url: '../DHCEPRFS.web.eprajax.AjaxAuthorizationInfo.cls?Action=removerecallreason&CategoryID=' + FSRecallRecord.ReasonSelectID,
				type: 'post',
				async: false
			});
			var ret = obj.responseText;
			if (ret === '1') {
				FSRecallRecord.ReasonSelectID = '';
				$('#cbbRecallReason').combobox('reload');
			}
			else {
				$.messager.alert(FSRecallRecord.Config.ERROR_INFO,FSRecallRecord.Config.ERROR_INFO_OPERATION,'error');
			}
		});
		
		//电子病历链接
		function eprURLFormatter(value,row,index) {
			var episodeID = row.EpisodeID;
			var iWidth = screen.availWidth - 10;
			var iHeight = screen.availHeight - 30;
			var iTop = 0;
			var iLeft = 0;
			var url = 'epr.newfw.main.csp?EpisodeID=' + episodeID;
			var style = 'dialogHeight=' + iHeight + 'px;dialogWidth=' + iWidth + 'px;dialogTop=' + iTop + 'px;dialogLeft=' + iLeft + 'px;center=yes;help=no;resizable=yes;scroll=no;status=no;edge=sunken';
			return '<a href="javascript:void(0)" onclick="window.showModalDialog(\''+url+'\',{},\''+style+'\');">电子病历</a>';
		}
		
		//医生确认，护士确认，是否生成单元格染色
		function cellStyler(value,row,index) {
			if (value === '否') {
				return 'background-color:red;color:white;';
			}
			else if (value === '是') {
				return 'background-color:darkgreen;color:white;';
			}
			else {
				return 'background-color:darkblue;color:white;';
			}
		}
		
		//查询就诊
		function searchEpisode() {
			var queryParams = $('#mrlist').datagrid('options').queryParams;
			queryParams.AType = FSRecallRecord.TypeCode;
			queryParams.AStartDate = FSRecallRecord.DateStart;
			queryParams.AEndDate = FSRecallRecord.DateEnd;
			queryParams.AMedRecordNo = $('#tbMRNo').val();
			queryParams.ARegNo = $('#tbRegNo').val();
			queryParams.AName = $('#tbPatName').val();
			queryParams.ADocCommit = $('#cbbDocSubmit').combobox('getValue');
			queryParams.ANurCommit = $('#cbbNurSubmit').combobox('getValue');
			queryParams.APDFCreated = $('#cbbPDFCreated').combobox('getValue');
			$('#mrlist').datagrid('options').queryParams = queryParams;
			$('#mrlist').datagrid('reload');
			$('#mrlist').datagrid('getPager').pagination('select',1);
		}
		
		//设置默认时间
		function setDefaultDate() {
			var currDate = new Date();
			$('#dbStartDate').datebox('setValue', myformatter1(currDate, FSRecallRecord.Config.DATESPAN));
			$('#dbEndDate').datebox('setValue', myformatter(currDate));
			FSRecallRecord.DateStart = $('#dbStartDate').datebox('getValue');
			FSRecallRecord.DateEnd = $('#dbEndDate').datebox('getValue');
		}
		
		function myformatter(date) {
			var y = date.getFullYear();
			var m = date.getMonth() + 1;
			var d = date.getDate();
			return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
		}
		
		function myformatter1(date,span) {
			var d = date.getDate() - span;
			var tmp = new Date();
			tmp.setDate(d);
			var y = tmp.getFullYear();
			var m = tmp.getMonth() + 1;
			d = tmp.getDate();
			return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
		}
		
		function encodeText(str) {
			var result = str.replace(/\n/g,'<br />');
			return result;
		}
		
		function decodeText(str) {
			var result = str.replace(/<br \/>/g,'\n');
			return result;
		}
	});
}(window));
