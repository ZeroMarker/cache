//全局
var FSReviewMain = FSReviewMain || {
    DateStart : "",
    DateEnd : "",
    TypeCode : "U",
    ReasonSelectID: "",
    Back2Doc: "0",
    Back2Nur: "0",
    FilterLocID: "",

    //公有方法声明
    SearchEpisode: null,
    QCBack: null
};

//配置和静态
FSReviewMain.Config = FSReviewMain.Config || {
    DATESPAN: 7,
    PAGESIZE: 30,
    PAGELIST: [10, 20, 30, 50, 100],
    CTLOC_PAGESIZE: 20,
    CTLOC_PAGELIST: [10, 20, 50, 100],
    ERROR_INFO: "错误",
    ERROR_INFO_REVIEW: "复核失败，请重新尝试或联系管理员",
    ERROR_INFO_NOEPISODESELECTED: "请先选中一条就诊",
    ERROR_INFO_QCBACK: "退回失败，请重新尝试或联系管理员",
    LOADING_INFO: "数据装载中......"
};

(function (win) {
    $(function () {

        //初始化公有方法
        FSReviewMain.SearchEpisode = searchEpisode;
        FSReviewMain.QCBack = qcback;

        //加载调用设置默认日期
        setDefaultDate();
		
		//设置时间轴是否显示
		if(showTimeLine=="N"){
			$("#reviewMainLayout").layout('remove','east');
		}
		
		//设置科室选择是否显示
		if (isSuper=="0") {
			$("#IPLoctd").hide();
		}
		
		//设置是否显示退回按钮
		if (enableAction == "N") {
			$("#back2DocBtn").hide();
			$("#back2NurBtn").hide();
			$("#back2AllBtn").hide();
		}

        //------------------------------------------------------------------------------------------------------------------

		$('#inputDocCommit').combobox({
			valueField:'id',
			textField:'text',
			data: [{
                id: 'a',
                text: '全部'
            }, {
                id: 'y',
                text: '是'
            }, {
                id: 'n',
                text: '否'
            }]
		});

		$('#inputNurCommit').combobox({
			valueField:'id',
			textField:'text',
			data: [{
                id: 'a',
                text: '全部'
            }, {
                id: 'y',
                text: '是'
            }, {
                id: 'n',
                text: '否'
            }]
		});
		
		$('#inputPDFCreated').combobox({
			valueField:'id',
			textField:'text',
			data: [{
                id: 'a',
                text: '全部'
            }, {
                id: 'y',
                text: '是'
            }, {
                id: 'n',
                text: '否'
            }]
		});
		
        //按钮事件
        //查询患者
        $('#searchBtn').on('click', function () {
            searchEpisode();
        });

        $('#inputMedRecord').on('keypress', function (event) {
            if (event.keyCode === "13") {
                searchEpisode();
            }
        });

        $('#inputRegNo').on('keypress', function (event) {
            if (event.keyCode === "13") {
                searchEpisode();
            }
        });
		
		$('#inputName').on('keypress', function (event) {
            if (event.keyCode === "13") {
                searchEpisode();
            }
        });

        //置空
        $('#resetBtn').on('click', function () {
            $('#inputType').combogrid('grid').datagrid('selectRow', 0);
            $('#inputMedRecord').val('');
            $('#inputRegNo').val('');
			$('#inputName').val('');
            FSReviewMain.FilterLocID = "";
            $('#inputPatientLoc').combogrid('clear');
            setDefaultDate();
        });

        //复核通过
        $('#passBtn').on('click', function () {
            getSelectEpisode();
			var reviewUrl = "";
			if (isSuper == "0") {
				reviewUrl = "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=deptreview&EpisodeID=" + FSReviewMain.SelectEpisode + "&UserID=" + userID;
			}
			else {
				reviewUrl = "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=reviewpass&EpisodeID=" + FSReviewMain.SelectEpisode + "&UserID=" + userID;
			}
			var obj = $.ajax({
			url: reviewUrl,
			type: 'post',
			async: false
			});

            FSReviewMain.SelectEpisode = "";
            var ret = obj.responseText;
            if (ret != "1") {
                $.messager.alert(FSReviewMain.Config.ERROR_INFO, FSReviewMain.Config.ERROR_INFO_REVIEW, 'error');
                return;
            }
            else {
                searchEpisode();
            }
        });

        //退回医生
        $('#back2DocBtn').on('click', function () {
            FSReviewMain.Back2Doc = "1";
            FSReviewMain.Back2Nur = "0";
            var ret = getSelectEpisode();
            if (ret !== "-1") {
                FSReviewCommon.OpenBackWin(FSReviewMain.QCBack);
            }
        });

        //退回护士
        $('#back2NurBtn').on('click', function () {
            FSReviewMain.Back2Doc = "0";
            FSReviewMain.Back2Nur = "1";
            var ret = getSelectEpisode();
            if (ret !== "-1") {
                FSReviewCommon.OpenBackWin(FSReviewMain.QCBack);
            }
        });

        //全部退回
        $('#back2AllBtn').on('click', function () {
            FSReviewMain.Back2Doc = "1";
            FSReviewMain.Back2Nur = "1";
            var ret = getSelectEpisode();
            if (ret !== "-1") {
                FSReviewCommon.OpenBackWin(FSReviewMain.QCBack);
            }
        });

          //患者查询列表
        var patientDG = $('#episodeListTable').datagrid({
            //url: '../DHCEPRFS.web.eprajax.AjaxReview.cls',
            queryParams: {
                Action: 'episodelist',
                UserID: userID,
                Type: FSReviewMain.TypeCode,
                StartDate: '',
                EndDate: '',
                MedRecordNo: '',
                RegNo: '',
				Name: '',
                FilterLocID: '',
				DocCommit: '',
				NurCommit: '',
				PDFCreated: ''
            },
            method: 'post',
            loadMsg: FSReviewMain.Config.LOADING_INFO,
            singleSelect: true,
            showHeader: true,
            //fitColumns: true,
            rownumbers: true,
            columns: [[
				{ field: 'ck', checkbox: true },
				{ field: 'ReviewStatus', title: '是否已审核', width: 70, sortable: true, styler: cellStyler },
				{ field: 'DeptStatus', title: '科室审核状态', width: 80, sortable: true, styler: cellStyler, hidden: deptHidden() },
				{ field: 'CheckStatus', title: '校验状态', width: 60, sortable: true, styler: cellStyler },
				{ field: 'EprDocStatus', title: 'EprDocStatus', width: 60, sortable: true, hidden: true },
	            { field: 'EprDocStatusDesc', title: '医生提交', width: 60, sortable: true, styler: cellStyler },
				{ field: 'EprNurStatus', title: 'EprNurStatus', width: 60, sortable: true, hidden: true },
				{ field: 'EprNurStatusDesc', title: '护士提交', width: 60, sortable: true, styler: cellStyler },
				{ field: 'EprPdfStatus', title: 'EprPdfStatus', width: 60, sortable: true, hidden: true },
	            { field: 'EprPdfStatusDesc', title: '是否生成', width: 60, sortable: true, styler: cellStyler },
				{ field: 'SuperURL', title: '三单一致', width: 70, sortable: true, formatter: superURLFormatter },
				{ field: 'EPRURL', title: '电子病历', width: 70, sortable: true, formatter: eprURLFormatter },
				{ field: 'CheckRetURL', title: '校验结果', width: 70, sortable: true, formatter: checkRetURLFormatter },
				{ field: 'PAPMIName', title: '病人姓名', width: 80, sortable: true },
				{ field: 'MedRecordNo', title: '病案号', width: 70, sortable: true, formatter: medRecordNoFormatter },
				{ field: 'DisDateTime', title: '出院日期时间', width: 150, sortable: true },
				{ field: 'PAAdmDepCodeDR', title: '就诊科室', width: 120, sortable: true },
				{ field: 'CheckDateTime', title: '校验日期时间', width: 150, sortable: true },
				{ field: 'CheckUser', title: '提交校验医生', width: 80, sortable: true },
				{ field: 'CheckRule', title: '校验规则', width: 120, sortable: true },
				{ field: 'Warddesc', title: '病区', width: 120, sortable: true },
				{ field: 'RegNo', title: '登记号', width: 80, sortable: true },
				{ field: 'PAPMIDOB', title: '出生日期', width: 100, sortable: true },
	            { field: 'PAPMISex', title: '性别', width: 40, sortable: true },
	            { field: 'AdmDateTime', title: '入院日期时间', width: 150, sortable: true },
				{ field: 'PAAdmDocCodeDR', title: '主治医生', width: 60, sortable: true },          
	            { field: 'EpisodeID', title: '就诊号', width: 70, sortable: true },
	            { field: 'PatientID', title: '病人号', width: 70, sortable: true },
	        ]],
            pagination: true,
            pageSize: FSReviewMain.Config.PAGESIZE,
            pageList: FSReviewMain.Config.PAGELIST,
            pagePosition: 'bottom',
            toolbar: '#episodeListTableTBar',
            onDblClickRow: function (index, row) {
                var episodeID = row.EpisodeID;
                openWin(episodeID);
            },
            onClickRow: function (index, row) {
                var episodeID = row.EpisodeID;
                var url = 'dhc.epr.fs.review.timeline.csp?EpisodeID=' + episodeID;
                $('#iframeTrak').attr("src", url);
            },
            onLoadSuccess:function(data) {
                var i=0;
                var max=data.rows.length
                for (i; i < max; i++) { 
                    var medRecordNo = data.rows[i].MedRecordNo;
                    var barCode = DrawCode39Barcode(medRecordNo,0);
                    var barCodeHTML = '<div id="inputdata-"'+i+'" >'+barCode+'</div>';  
                    //拼写tooltip的内容   
                    var barCodeID = "ToolTipDiv-" + i;
                    addTooltip(barCodeHTML,barCodeID); 
                }
             }
        });

        //列表类型
        $('#inputType').combogrid({
            idField: 'id',
            textField: 'text',
            data: [{
                id: '0',
                text: '未复核',
                code: 'U'
            }, {
                id: '1',
                text: '已复核',
                code: 'F'
            }, {
                id: '2',
                text: '已退回',
                code: 'B'
            }],
            panelWidth: 150,
			fitColumns: true,
            showHeader: false,
            singleSelect: true,
            editable: false,
            columns: [[
                { field: 'id', title: 'id', width: 80, hidden: true },
                { field: 'code', title: 'code', width: 80, hidden: true },
                { field: 'text', title: '列表类型', width: 150 }
            ]],
            onSelect: function () {
                var row = $('#inputType').combogrid('grid').datagrid('getSelected');
                FSReviewMain.TypeCode = row["code"];

                searchEpisode();
            },
            onLoadSuccess: function () {
                $('#inputType').combogrid('grid').datagrid('selectRow', 0);
            }
        });

        //时间过滤 - 起始日期
        $('#inputDateStart').datebox({
            onSelect: function () {
                FSReviewMain.DateStart = $('#inputDateStart').datebox('getValue');
            },
            onChange: function () {
                //避免不选择日期而采用输入的方式
                FSReviewMain.DateStart = $('#inputDateStart').datebox('getValue');
            }
        });

        //时间过滤 - 截止日期
        $('#inputDateEnd').datebox({
            onSelect: function () {
                FSReviewMain.DateEnd = $('#inputDateEnd').datebox('getValue');
            },
            onChange: function () {
                //避免不选择日期而采用输入的方式
                FSReviewMain.DateEnd = $('#inputDateEnd').datebox('getValue');
            }
        });

        //选择患者就诊科室
		 $(function () {  
            setTimeout(function () {  
                var old = '';  
				var query = '';
                var search = true;  
                $('#inputPatientLocText').keyup(function () {  
					//清除所有勾选
					$('#inputPatientLoc').combogrid('grid').datagrid('uncheckAll');
                    var _new = $('#inputPatientLocText').val();  
                    if (_new != old) {  
                        old = _new;  
                        query = old;  
                        setTimeout(function () {  
                            if (query.length > 0) {  
								refreshLoc(query);
                            }  
                        }, 1500);  
                    }  
                });  
 
                $('#inputPatientLocClear').bind('click',function() {  
					$('#inputPatientLoc').combogrid('grid').datagrid('uncheckAll');
                    FSReviewMain.FilterLocID = "";
					$('#inputPatientLoc').val('');
					$('#inputPatientLocText').val('');
					refreshLoc('');
                });
            }, 1000);  
        });  
		
		function refreshLoc(query)
		{
			var url = '../DHCEPRFS.web.eprajax.AjaxDicList.cls';
			$('#inputPatientLoc').combogrid('grid').datagrid('options').url = url;
			var queryParams = $('#inputPatientLoc').combogrid('grid').datagrid('options').queryParams;
			queryParams.Filter = query;
			$('#inputPatientLoc').combogrid('grid').datagrid('options').queryParams = queryParams;
			$('#inputPatientLoc').combogrid('grid').datagrid('reload');
			$('#inputPatientLoc').combogrid('grid').datagrid('getPager').pagination('select',1);		
		}
		
	    $('#inputPatientLoc').combogrid({
	        //url: 'DHCEPRFS.web.eprajax.AjaxDicList.cls',
	        queryParams: {
	            DicCode: 'S07',
	            Filter: ''
	        },
	        panelWidth: 300,
			panelHeight: 600,
			checkOnSelect:true,
			selectOnCheck:true,
            multiple:true,
	        idField: 'ID',
	        textField: 'DicDesc',
	        method: 'get',
	        showHeader: false,
			toolbar:'#inputPatientLocTbar', 
	        fitColumns: true,
	        columns: [[
				{ field: 'ck', checkbox: true },
	            { field: 'ID', title: 'ID', width: 80, hidden: true },
	            { field: 'DicAlias', title: 'DicAlias', width: 80, hidden: true },
	            { field: 'DicCode', title: 'DicCode', width: 80, hidden: true },
	            { field: 'DicDesc', title: 'DicDesc', width: 300 }
	        ]],
	        pagination: true,
			pageSize: FSReviewMain.Config.CTLOC_PAGESIZE,
            pageList: FSReviewMain.Config.CTLOC_PAGELIST,
			onCheck: function(index, row) {  
				//debugger;
				search = false;  
				var idField = row["ID"]; 
				var textField = row["DicDesc"];
 
				var textFieldAll = $('#inputPatientLoc').val();
					
				if ((FSReviewMain.FilterLocID == "") || (typeof(FSReviewMain.FilterLocID) == "undefined"))
				{
					FSReviewMain.FilterLocID = idField; 
					textFieldAll = textField;
				}
				else
				{
					//判读是否已经添加
					var arr = new Array();
					var str = FSReviewMain.FilterLocID;
					arr = str.split(',');
					var flag = false;
					var i=0;
					for (i;i<arr.length;i++)
					{
						if (arr[i] == idField)
						{
							flag = true;
							break;
						}
					}
						
					if (flag)
					{
						return;
					}
					else
					{
						FSReviewMain.FilterLocID = FSReviewMain.FilterLocID+","+idField; 
						textFieldAll = textFieldAll+","+textField; 
					}
				}
					
				$('#inputPatientLoc').val(textFieldAll); 
				setTimeout(function () {  
					search = true;  
				}, 1000);  
			},
			onShowPanel:function () {  
				setTimeout(function(){  
					var url = '../DHCEPRFS.web.eprajax.AjaxDicList.cls';
					$('#inputPatientLoc').combogrid('grid').datagrid('options').url = url;
					var queryParams = $('#inputPatientLoc').combogrid('grid').datagrid('options').queryParams;
					$('#inputPatientLoc').combogrid('grid').datagrid('options').queryParams = queryParams;
					$('#inputPatientLoc').combogrid('grid').datagrid('reload');    
					$('#inputPatientLocText').focus();  
				},100);  
			}  
        });
        
        $('#inputPatientLoc').combogrid('grid').datagrid('getPager').pagination({
            pageSize: FSReviewMain.Config.CTLOC_PAGESIZE,
            pageList: FSReviewMain.Config.CTLOC_PAGELIST,
            beforePageText: '第',
            afterPageText: '页/共{pages}页',
            displayMsg: '{from} - {to},共{total}'
        });
        

        //------------------------------------------------------------------------------------------------------------------

        //获取选中行就诊号
        function getSelectEpisode() {
            FSReviewMain.SelectEpisode = "";
            //取当前选中行
            var rows = $('#episodeListTable').datagrid('getSelections');
            if (rows.length !== 1) {
                $.messager.alert(FSReviewMain.Config.ERROR_INFO, ERROR_INFO_NOEPISODESELECTED, 'error');
                return "-1";
            }
            else {
                var row = rows[0];
                FSReviewMain.SelectEpisode = row.EpisodeID;
            }

        }

        //退回操作
        function qcback(reason) {
            var qcbackurl = "";
			if (isSuper == "0") {
				qcbackurl = "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=deptqcback&EpisodeID=" + FSReviewMain.SelectEpisode + "&UserID=" + userID + "&Reason=" + encodeURI(reason) + "&Back2Nur=" + FSReviewMain.Back2Nur + "&Back2Doc=" + FSReviewMain.Back2Doc;
			}
			else {
				qcbackurl = "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=qcback&EpisodeID=" + FSReviewMain.SelectEpisode + "&UserID=" + userID + "&Reason=" + encodeURI(reason) + "&Back2Nur=" + FSReviewMain.Back2Nur + "&Back2Doc=" + FSReviewMain.Back2Doc;
			}
            var obj = $.ajax({
				url: qcbackurl,
                type: 'post',
                async: false
            });

            FSReviewMain.Back2Doc = "0";
            FSReviewMain.Back2Nur = "0";
            FSReviewMain.SelectEpisode = "";

            var ret = obj.responseText;
            if (ret !== "1") {
                $.messager.alert(FSReviewMain.Config.ERROR_INFO, FSReviewMain.Config.ERROR_INFO_QCBACK, 'error');
                return;
            }
            else {
                searchEpisode();
            }
        } 

        function medRecordNoFormatter(value, row, index){
            var medRecordNo = row.MedRecordNo;
            var content = '<div id="ToolTipDiv-'+index+'" style="width:auto;">' + medRecordNo + '</div>';
            return content;
        }

        function addTooltip(tooltipContentStr,tootipId){  
            //添加相应的tooltip     
            $('#'+tootipId).tooltip({    
                position: 'top',    
                content: tooltipContentStr,    
                onShow: function(){    
                    $(this).tooltip('tip').css({  
                        backgroundColor: 'white',  
                        borderColor: '#97CBFF'    
                    });  
                }       
            });   
        } 

        function get_object(id) {
            var object = null;
            if (document.layers) {
                object = document.layers[id];
            }
            else if (document.all) {
                object = document.all[id];
            } 
            else if (document.getElementById) {
                object = document.getElementById(id);
            }
            return object;
        }

        //三单一致链接
        function superURLFormatter(value, row, index) {
            var episodeID = row.EpisodeID;
            var iWidth = screen.availWidth - 10;                         //弹出窗口的宽度;
            var iHeight = screen.availHeight - 30;                       //弹出窗口的高度;
            var iTop = 0;       //获得窗口的垂直位置;
            var iLeft = 0;
            var url = 'dhc.epr.fs.review.view.csp?EpisodeID=' + episodeID + '&UserID=' + userID;
            var style = 'dialogHeight=' + iHeight + 'px;dialogWidth=' + iWidth + 'px;dialogTop=' + iTop + 'px;dialogLeft=' + iLeft + 'px;center=yes;help=no;resizable=yes;scroll=no;status=no;edge=sunken';

            return '<a href="javascript:void(0)" onclick="window.showModalDialog(\''+url+'\',{ funObj: FSReviewMain.SearchEpisode },\''+style+'\');">三单一致</a>';
        }

        //点击三单一致弹窗
        function openWin(episodeID) {
            var iWidth = screen.availWidth - 10;                         //弹出窗口的宽度;
            var iHeight = screen.availHeight - 30;                       //弹出窗口的高度;
            var iTop = 0;       //获得窗口的垂直位置;
            var iLeft = 0;
            var url = 'dhc.epr.fs.review.view.csp?EpisodeID=' + episodeID + '&UserID=' + userID;
            window.showModalDialog(url, { funObj: FSReviewMain.SearchEpisode }, 'dialogHeight=' + iHeight + 'px;dialogWidth=' + iWidth + 'px;dialogTop=' + iTop + 'px;dialogLeft=' + iLeft + 'px;center=yes;help=no;resizable=yes;scroll=no;status=no;edge=sunken');
        }

        //电子病历链接
        function eprURLFormatter(value, row, index) {
            var episodeID = row.EpisodeID;

            var url = 'epr.newfw.main.csp?EpisodeID=' + episodeID;
            return '<a style="color:blue" target="_blank" href="' + url + '">电子病历</a>';
        }
		
		//完整性校验结果链接
        function checkRetURLFormatter(value, row, index) {
            var episodeID = row.EpisodeID;
            var iWidth = 440;
			var iHeight = 512;
			var iTop = (window.screen.availHeight - iHeight) / 2;
			var iLeft = (window.screen.availWidth - iWidth) / 2;
            var url = 'dhc.epr.fs.integrity.retview.csp?EpisodeID=' + episodeID + '&UserID=' + userID;
            var style = 'dialogHeight=' + iHeight + 'px;dialogWidth=' + iWidth + 'px;dialogTop=' + iTop + 'px;dialogLeft=' + iLeft + 'px;center=yes;help=no;resizable=yes;scroll=no;status=no;edge=sunken';

            return '<a href="javascript:void(0)" onclick="window.showModalDialog(\''+url+'\',{ funObj: FSReviewMain.SearchEpisode },\''+style+'\');">校验结果</a>';
        }

        //医生确认，护士确认，是否生成单元格染色
        function cellStyler(value, row, index) {
            if (value === "否") {
                return 'background-color:red;color:white;';
            }
            else if (value === "是") {
                return 'background-color:darkgreen;color:white;';
            }
            else {
                return 'background-color:darkblue;color:white;';
            }
        }

        //查询就诊
        function searchEpisode() {
            var url = '../DHCEPRFS.web.eprajax.AjaxReview.cls';
            $('#episodeListTable').datagrid('options').url = url;
            var queryParams = $('#episodeListTable').datagrid('options').queryParams;
            queryParams.Type = FSReviewMain.TypeCode;
            queryParams.StartDate = FSReviewMain.DateStart;
            queryParams.EndDate = FSReviewMain.DateEnd;
            queryParams.MedRecordNo = $('#inputMedRecord').val(); 
            queryParams.RegNo = $('#inputRegNo').val(); 
			queryParams.Name = $('#inputName').val(); 
			queryParams.DocCommit = $('#inputDocCommit').combobox('getValue'); 
			queryParams.NurCommit = $('#inputNurCommit').combobox('getValue'); 
			queryParams.PDFCreated = $('#inputPDFCreated').combobox('getValue'); 
			
            if(isSuper=="0")
			{
				queryParams.FilterLocID = userLocID;  //科室用户固定为登陆科室ID
				queryParams.Action = 'deptepisodelist';  //科室用户查询科室患者就诊列表
			}
			else
			{
				queryParams.FilterLocID = FSReviewMain.FilterLocID;
				queryParams.Action = 'episodelist';
			}
            $('#episodeListTable').datagrid('options').queryParams = queryParams;
            $('#episodeListTable').datagrid('reload');
			$('#episodeListTable').datagrid('getPager').pagination('select',1);
        }

        //设置默认时间
        function setDefaultDate() {
            var currDate = new Date();
            $("#inputDateStart").datebox("setValue", myformatter1(currDate, FSReviewMain.Config.DATESPAN));
            $("#inputDateEnd").datebox("setValue", myformatter(currDate));
            FSReviewMain.DateStart = $("#inputDateStart").datebox("getValue");
            FSReviewMain.DateEnd = $("#inputDateEnd").datebox("getValue");
        }

        function myformatter(date) {
            var y = date.getFullYear();
            var m = date.getMonth() + 1;
            var d = date.getDate();
            return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
        }

        function myformatter1(date, span) {
            var d = date.getDate() - span;
            var tmp = new Date();
            tmp.setDate(d);
            var y = tmp.getFullYear();
            var m = tmp.getMonth() + 1;
            d = tmp.getDate();
            return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
        }
		
		//设置科室审核状态是否显示
		function deptHidden(){
			if (isSuper=="0") {
				return true;
			}
			else{
				return false;
			}
		}
    });
}(window));
