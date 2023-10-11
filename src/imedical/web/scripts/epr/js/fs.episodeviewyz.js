//全局
var FSEpisodeViewYZ = FSEpisodeViewYZ || {
	DateStart: "",
	DateEnd: "",
	AdmTypeID: "",
	AdmLocID: "",
	SelectEpisode: ""
};

//配置和静态
FSEpisodeViewYZ.Config = FSEpisodeViewYZ.Config || {
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

(function(win) {
    $(function() {
		function searchBtnHandle() {
			var episodeListTableDG = $('#episodeListTable').datagrid({
	        url: '../DHCEPRFS.web.eprajax.AjaxEpisodeViewYZ.cls',
	        queryParams: {
				Action: 'episodelist',
	            RegNo: RegNo,
				IDCard: IDCard,
				StartDate: '',
				EndDate: '',
				AdmTypeID: FSEpisodeViewYZ.AdmTypeID,
				LocID: FSEpisodeViewYZ.AdmLocID
	        },
	        method: 'post',
	        loadMsg: '数据装载中......',
	        singleSelect: true,
	        showHeader: true,
	        fitColumns: false,
			rownumbers:false,
	        columns: [[
				{ field: 'AdmDate', title: '就诊时间', width: 80, sortable: true },
				{ field: 'AdmTime', title: '就诊时间', width: 80, sortable: true },
				{ field: 'AdmType', title: '就诊类型', width: 80, sortable: true },
				{ field: 'AdmLoc', title: '就诊科室', width: 80, sortable: true },
				{ field: 'EpisodeID', title: '就诊号', width: 80, sortable: true },			
				{ field: 'Name', title: '病人姓名', width: 80, sortable: true },			
				{ field: 'Gender', title: '性别', width: 80, sortable: true },
	            { field: 'Birthday', title: '出生日期', width: 80, sortable: true },           
	            { field: 'Age', title: '年龄', width: 100, sortable: true },
	            { field: 'DisDate', title: '出院日期', width: 80, sortable: true },
				{ field: 'DisTime', title: '出院时间', width: 80, sortable: true },
				{ field: 'DisLoc', title: '出院科室', width: 80, sortable: true },
				{ field: 'MainDoctor', title: '主治医生', width: 80, sortable: true },
				{ field: 'InHospitlDoc', title: '住院医生', width: 80, sortable: true },
				{ field: 'RegNo', title: '登记号', width: 80, sortable: true },
				{ field: 'IDCard', title: '身份证', width: 160, sortable: true }
			]],
			pagination: true,
            pageSize: FSEpisodeViewYZ.Config.PAGESIZE,
            pageList: FSEpisodeViewYZ.Config.PAGELIST,
            pagePosition: 'bottom',
			sortName: "AdmDate",
			sortOrder: "desc",
	        toolbar: '#episodeListTableTBar',
			onClickRow: function(index, rowData){
				 var rowEpisodeID = rowData["EpisodeID"];
				 //var htmlStr = '<iframe src="./dhc.epr.fs.bscheckrecord.csp?EpisodeID=';
			     //htmlStr += rowEpisodeID;
			     //htmlStr += '&SchemeID=';
			     //htmlStr += SchemeID;
				 //htmlStr += '&Count=1';
			     //htmlStr += '" frameBorder=0 scrolling=no style="z-index:-1;height:100%;width:100%;"></iframe>';
			     //$('#iframeDIV').append(htmlStr);	
			 	var url = "dhc.epr.fs.bscheckrecord.csp?EpisodeID="+rowEpisodeID+"&SchemeID="+SchemeID+"&Count=1&MrItemID=";
				$('#contentIFrame').attr("src",url);				 
			},
			onLoadSuccess: function(data){	
				//加载成功，自动选中最近一条出院就诊
				$('#episodeListTable').datagrid('selectRow',0);
			}
	    });
		var c =  $('#episodeDiv');
		var high = $(window).height()
		c.layout('resize',{
				height:high
			});
		
	    $('#episodeListTable').datagrid('reload');
		}
		
		$('#inputStartDate').datebox ({
			onSelect: function() {
				FSEpisodeViewYZ.DateStart = $('#inputStartDate').datebox('getValue');
			},
			onChange: function() {
				FSEpisodeViewYZ.DateStart = $('#inputStartDate').datebox('getValue');
			}
		});
		
		
		$('#inputEndDate').datebox ({
			onSelect: function() {
				FSEpisodeViewYZ.DateEnd = $('#inputEndDate').datebox('getValue');
			},
			onChange: function() {
				FSEpisodeViewYZ.DateEnd = $('#inputEndDate').datebox('getValue');
			}
		});
		
		
		$('#inputAdmType').combobox({
			valueField:'id',
			textField:'text',
			data: [{
                id: 'I',
                text: '住院'
            }, {
                id: 'O',
                text: '门诊'
            }, {
                id: 'E',
                text: '急诊'
            }]
		});
		
		//设置默认时间
        function setDefaultDate() {
            var currDate = new Date();
            $("#inputStartDate").datebox("setValue", myformatter1(currDate, 7));
            $("#inputEndDate").datebox("setValue", myformatter(currDate));
            FSEpisodeViewYZ.DateStart = $("#inputStartDate").datebox("getValue");
            FSEpisodeViewYZ.DateEnd = $("#inputEndDate").datebox("getValue");
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
                    FSEpisodeViewYZ.FilterLocID = "";
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
			pageSize: FSEpisodeViewYZ.Config.CTLOC_PAGESIZE,
            pageList: FSEpisodeViewYZ.Config.CTLOC_PAGELIST,
			onCheck: function(index, row) {  
				//debugger;
				search = false;  
				var idField = row["ID"]; 
				var textField = row["DicDesc"];
 
				var textFieldAll = $('#inputPatientLoc').val();
					
				if ((FSEpisodeViewYZ.AdmLocID == "") || (typeof(FSEpisodeViewYZ.AdmLocID) == "undefined"))
				{
					FSEpisodeViewYZ.AdmLocID = idField; 
					textFieldAll = textField;
				}
				else
				{
					//判读是否已经添加
					var arr = new Array();
					var str = FSEpisodeViewYZ.AdmLocID;
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
						FSEpisodeViewYZ.AdmLocID = FSEpisodeViewYZ.AdmLocID+","+idField; 
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
            pageSize: FSEpisodeViewYZ.Config.CTLOC_PAGESIZE,
            pageList: FSEpisodeViewYZ.Config.CTLOC_PAGELIST,
            beforePageText: '第',
            afterPageText: '页/共{pages}页',
            displayMsg: '{from} - {to},共{total}'
        });
		
		
		setDefaultDate();
		searchBtnHandle();
		
		
		//功能-----------------------------------------------------------------------------------------------------------------------------------
		/*var footerView = $.extend({}, $.fn.datagrid.defaults.view, {
			renderFooter: function(target, container, frozen){
				var opts = $.data(target, 'datagrid').options;
				var rows = $.data(target, 'datagrid').footer || [];
				var fields = $(target).datagrid('getColumnFields', frozen);
				var table = ['<table class="datagrid-ftable" cellspacing="0" cellpadding="0" border="0"><tbody>'];
         
				for(var i=0; i<rows.length; i++){
					var styleValue = opts.rowStyler ? opts.rowStyler.call(target, i, rows[i]) : '';
					var style = styleValue ? 'style="' + styleValue + '"' : '';
					table.push('<tr class="datagrid-row" datagrid-row-index="' + i + '"' + style + '>');
					table.push(this.renderRow.call(this, target, fields, frozen, i, rows[i]));
					table.push('</tr>');
				}
         
				table.push('</tbody></table>');
				$(container).html(table.join(''));
			}
		});*/
		
		//初始化---------------------------------------------------------------------------------------------------------------------------------
		//就诊查询-------------------------------------------------------------------------------------------------------------------------------
		
		$('#btnSearch').on('click', function(){
			searchEpisode();
		});	

		function searchEpisode() {
			var url = '../DHCEPRFS.web.eprajax.AjaxEpisodeViewYZ.cls';
			$('#episodeListTable').datagrid('options').url = url;
			var queryParams = $('#episodeListTable').datagrid('options').queryParams;
			queryParams.RegNo = RegNo;
			queryParams.IDCard = IDCard;
			queryParams.StartDate = FSEpisodeViewYZ.DateStart;
			queryParams.EndDate = FSEpisodeViewYZ.DateEnd;
			queryParams.AdmTypeID =$('#inputAdmType').combobox('getValue');
			queryParams.AdmTypeID =$('#inputAdmType').combobox('getValue');
			$('#episodeListTable').datagrid('options').queryParams = queryParams;
			$('#episodeListTable').datagrid('reload');
		}
		
	});
}(window));