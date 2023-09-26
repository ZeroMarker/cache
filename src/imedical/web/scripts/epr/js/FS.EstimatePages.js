var FSEstimatePages = new Object();
FSEstimatePages.SelectCardTypeDR = "";

(function($) {
    $(function() {
		//功能-----------------------------------------------------------------------------------------------------------------------------------
		var footerView = $.extend({}, $.fn.datagrid.defaults.view, {
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
		});
		
		//初始化-------------------------------------------------------------------------------------------------------------------------------
		$('#estimatePages').val(0);
		$('#estimatePrice').val(0);
		$('#unitPrice').val(0);
		
		//读就诊卡-------------------------------------------------------------------------------------------------------------------------------
		$('#readCardBtn').on('click', function() {
	        ReadCardHandle();
	    });
		
		function ReadCardHandle()
		{
			var CardInform=GetAccInfo();
			
			var CardSubInform=CardInform.split("^");
			var rtn = CardSubInform[0];
			if (rtn == "-200"){
				alert("卡无效");
			}
			else
			{
				var patientID = CardSubInform[1];
				var regNo = CardSubInform[2];
				var medRecordNo = CardSubInform[3];

				$('#inputRegNo').val(regNo);
				$('#inputMedRecordNo').val(medRecordNo);
				
				searchEpisode();
			}
		}
		
		function GetAccInfo()
		{
			//2为就诊卡
			var myrtn=DHCHardComm_RandomCardEquip("2","R", "23", "", "");
			var myary=myrtn.split("^");
			var rtn=myary[0];
			var myCardNo=myary[1];
			var myCheckNo=myary[2];
			var obj = $.ajax({
				url: "../DHCEPRFS.web.eprajax.AjaxEstimatePages.cls?Action=getpatinfo&CardNo=" + myCardNo,
				type: 'post',
				async: false
			});
			var ret = obj.responseText;
			
			return ret;
		}
		
		//就诊查询-------------------------------------------------------------------------------------------------------------------------------
		var episodeListTableDG = $('#episodeListTable').datagrid({
	        //url: '',
	        queryParams: {
				Action: 'episodelist',
	            RegNo: '',
	            MedRecordID:''
	        },
	        method: 'post',
	        loadMsg: '数据装载中......',
	        singleSelect: true,
	        showHeader: true,
	        fitColumns: true,
			rownumbers:false,
	        columns: [[
	            { field: 'PAStatusType', title: '状态', width: 80, hidden: true },
				{ field: 'PAStatusTypeDesc', title: '状态', width: 80, sortable: true },
	            { field: 'PAAdmType', title: '就诊类型', width: 80, sortable: true },
				{ field: 'PAPMIName', title: '病人姓名', width: 80, sortable: true },
	            { field: 'PAPMINO', title: '登记号', width: 80, sortable: true },
	            { field: 'PAPMIDOB', title: '出生日期', width: 100, sortable: true },
	            { field: 'PAPMIAge', title: '年龄', width: 80, sortable: true },
				{ field: 'PAPMISex', title: '性别', width: 80, sortable: true },
				{ field: 'PAAdmDateTime', title: '入院时间', width: 150, sortable: true },
				{ field: 'PAAdmWard', title: '病区', width: 80, sortable: true },
				{ field: 'PAAdmRoom', title: '病房', width: 80, sortable: true },
				{ field: 'PAAdmBed', title: '病床', width: 80, sortable: true },
				{ field: 'PAAdmLoc', title: '科室', width: 80, sortable: true },
				{ field: 'PADischgeDateTime', title: '出院时间', width: 150, sortable: true },
				{ field: 'PAAdmDoc', title: '医生', width: 80, sortable: true },
				{ field: 'PayMode', title: '付费类型', width: 80, sortable: true },
				{ field: 'EpisodeID', title: '就诊号', width: 80, sortable: true },
				{ field: 'PatientID', title: '病人号', width: 80, sortable: true }
			]],
			sortName: "PAAdmDateTime",
			sortOrder: "asc",
	        toolbar: '#episodeListTableTBar',
	        title: '就诊查询',
			onClickRow: function(rowIndex, rowData){
				loadItemList(rowData.EpisodeID);
			},
			onSelect: function() {
                var row = $('#episodeListTable').datagrid('getSelected');
				loadItemList(row["EpisodeID"]);
			},
			onLoadSuccess: function(data){	
				//加载成功，自动选中最近一条出院就诊
				var rows = $('#episodeListTable').datagrid('getRows');
				for (var i=0;i<rows.length;i++)
				{
					if (rows[i]["PAStatusType"] == "D")
					{
						$('#episodeListTable').datagrid('selectRow',i);
						break;
					}
				}
			}
	    });
		
		$('#searchBtn').on('click', function() {
	        searchEpisode();
	    });
		
		$('#inputMedRecordNo').on('keypress', function(event) {
	        if (event.keyCode == "13") {
	            searchEpisode();
	        }
	    });
		
		$('#inputRegNo').on('keypress', function(event) {
	        if (event.keyCode == "13") {
	            searchEpisode();
	        }
	    });
			
		//查询就诊
	    function searchEpisode() {
			var url = '../DHCEPRFS.web.eprajax.AjaxEstimatePages.cls';
	        $('#episodeListTable').datagrid('options').url = url;
	        var queryParams = $('#episodeListTable').datagrid('options').queryParams;
	        queryParams.RegNo = $('#inputRegNo').val();
	        queryParams.MedRecordID = $('#inputMedRecordNo').val();
	        $('#episodeListTable').datagrid('options').queryParams = queryParams;
	        $('#episodeListTable').datagrid('reload');
	    }
		
		//清空
		$('#clearBtn').on('click', function() {
			$('#inputMedRecordNo').val("");
			$('#inputRegNo').val("");
			$('#estimatePages').val(0);
			$('#estimatePrice').val(0);
	        $('#itemListTable').datagrid('loadData',{total:0,rows:[]});
			$('#episodeListTable').datagrid('loadData',{total:0,rows:[]});
	    });

		//计算表格-------------------------------------------------------------------------------------------------------------------------------
		function loadItemList(episodeID) {
			FSEstimatePages.SelectEpisodeID = episodeID;
			
			var url = '../DHCEPRFS.web.eprajax.AjaxEstimatePages.cls';
	        $('#itemListTable').datagrid('options').url = url;
	        var queryParams = $('#itemListTable').datagrid('options').queryParams;
	        queryParams.EpisodeID = episodeID;
	        $('#itemListTable').datagrid('options').queryParams = queryParams;
	        $('#itemListTable').datagrid('reload');
	    }
		
		$('#itemListTable').datagrid({
            //url: "../DHCEPRFS.web.eprajax.AjaxEstimatePages.cls",
	        queryParams: {
			    Action: 'itemlist',
				EpisodeID: ''
            },
	        method: 'post',
	        loadMsg: '数据装载中......',
		    showHeader: true,
            singleSelect: false,
            fitColumns: true,
			rownumbers:true,
			showFooter: false,
			view:footerView,
			striped:false,
			toolbar: '#itemListTableTBar',
	        title: '项目页数计算',
            columns: [[
				{ field: 'ck', checkbox: true },
				{ field: 'ItemID', title: 'ItemID', width: 80, sortable: true, hidden:true },
                { field: 'ItemCode', title: 'ItemCode', width: 80, sortable: true, hidden:true },
                { field: 'ItemName', title: '项目', width: 100, sortable: true },
                { field: 'ItemDesc', title: 'ItemDesc', width: 80, sortable: true, hidden:true },
                { field: 'TypeParam', title: 'TypeParam', width: 80, sortable: true, hidden:true },
                { field: 'Type', title: 'Type', width: 80, sortable: true, hidden:true },
                { field: 'UnitPrice', title: '单价', width: 100, sortable: true },
                { field: 'Pages', title: '计算页数', width: 100, sortable: true },
                { field: 'SubTotal', title: '计算小计', width: 100, sortable: true, styler: function (value, row, index) {
					if (row.ItemCode != 'Summary'){
						return 'color:#6293BB;';
					}
				}}
            ]],
			rowStyler: function(index,row){
				if (row.ItemCode == 'Summary'){
					return 'background-color:#6293BB;color:white;font-weight:bold;';
				}
            },
			onLoadSuccess: function(data){
				var rows = $('#itemListTable').datagrid('getFooterRows');
				$('#unitPrice').val(rows[0]["UnitPrice"]);

				var rowData = $('#itemListTable').datagrid('getRows');
				for (var i=0;i<rowData.length;i++)
				{
					$("#itemListTable").datagrid("selectRow", i);
				}
			}
		});
		
		$('#appendBtn').on('click', function() {
			var unitPrice = $('#unitPrice').val();
			var inputItemName = $('#inputItemName').val();
			var inputPages = $('#inputPages').val();
			var subTotal = inputPages * unitPrice;
			
			$('#itemListTable').datagrid('appendRow',{ItemID:'###',ItemCode:'###',ItemName:inputItemName,UnitPrice:unitPrice,Pages:inputPages,SubTotal:subTotal});
			var rows = $('#itemListTable').datagrid('getRows');
			var count = rows.length - 1;
			$('#itemListTable').datagrid('selectRow',count);
			$('#inputItemName').val("");
			$('#inputPages').val("");
			
		});
		
		$('#estimateBtn').on('click', function() {
			var rows = $('#itemListTable').datagrid('getSelections');
			var pages = 0;
			var price = 0;
			var detail = "";
	        for (var i=0;i<rows.length;i++)
			{
				var onepages = parseInt(rows[i]["Pages"]);
				var oneprice = parseFloat(rows[i]["SubTotal"]);
				var item = rows[i]["ItemID"];
				var itemName = rows[i]["ItemName"];

				pages = pages + onepages;
				price = price + oneprice;
				if (detail == "")
				{
					detail = item + "|" + itemName + "|" + onepages + "|" + oneprice
				}
				else
				{
					detail = detail + "^" + item + "|" + itemName + "|" + onepages + "|" + oneprice
				}
			}
			
			var rowEpisode = $('#episodeListTable').datagrid('getSelections');
			var episodeID = rowEpisode[0]["EpisodeID"];
			var rowFooter = $('#itemListTable').datagrid('getFooterRows');
			var unitPrice = rows[0]["UnitPrice"];
			
			var obj = $.ajax({
				url: "../DHCEPRFS.web.eprajax.AjaxEstimatePages.cls?Action=savelog&EpisodeID=" + episodeID + "&UserID=" + userID + "&UnitPrice=" + unitPrice + "&TotalPages=" + pages + "&TotalPrice=" + price + "&EstimatePagesDetail=" + encodeURI(detail),
				type: 'post',
				async: false
			});
			var ret = obj.responseText;
			if (ret != "")
			{
				$('#estimatePages').val(pages);
				$('#estimatePrice').val(price);
			}
			else
			{
				alert("记录失败，请重新尝试或联系管理员");
			}
	    });
		
		//最下方注释内容-------------------------------------------------------------------------------------------------------------------------------
		function setComment() {
			$('#commentDiv').html('');
			var splitor = '&nbsp&nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp&nbsp';
			var htmlStr = '&nbsp';
			htmlStr += '<span style="font-family:微软雅黑;color:#008b8b;font-size:16px;">' + comment + '</span>';

			$('#commentDiv').append(htmlStr);
			jQuery("#commentDiv").css("display", "inline-block");
			$('body').layout('resize');
		}
		setComment();
    });
})(jQuery);