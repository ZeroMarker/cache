/// 删除弹窗
function removePopUpWin(){
	if($("#PopUpWin_Table").length>0){
		$("#PopUpWin_Table").remove(); 
		$("#PopUpWin").remove(); 
	}
} 

/// 增加弹出div的样式设置
var style1 = document.createElement('style');
style1.innerHTML = '#PopUpWin .fixed-table-container thead th .th-inner, #PopUpWin .fixed-table-container tbody td .th-inner{line-height:14px;}';
document.head.appendChild(style1);
 
var PopUpWin = function(tarobj, width, height, url, columns, fn){
	this.tarobj = tarobj;
	this.width = width;
	this.height = height;
	this.url = url;
	this.columns = columns;
	this.fn = fn;
}

PopUpWin.prototype.init=function(){
	var fn = this.fn;
	var option = {
		height: this.height,
		url: this.url,
		singleSelect: true,
		columns: this.columns,
		formatRecordsPerPage: function(pageNumber){return ''},
		onLoadSuccess: function(data){
			/// 添加关闭按钮
			var html = '<a class="btn btn-small btn-primary" style="margin-left:10px;" href="javascript:removePopUpWin()"><i class="fa fa-close"></i> 关闭</a>'
			$("#PopUpWin .pagination-info").append(html);
			$("#PopUpWin .fixed-table-container").attr("style","height: 222px; padding-bottom: 31px;");
			$("#PopUpWin .fixed-table-pagination").attr("style","display:''");
			if (data.total > 0){
				/// 默认选中第一行
				$('#PopUpWin_Table').bootstrapTable('check',0); 
			}
		},
	    onClickRow: function (row, $element) {
			removePopUpWin();
			fn(row);
        }
	};	

	///创建弹出窗体
	$(document.body).append('<div id="PopUpWin" style="width:'+ this.width +'px;height:'+ this.height +'px;border:1px solid #E6F1FA;position:absolute;z-index:9999;background-color:#fff;"></div>') 
	$("#PopUpWin").append('<table id="PopUpWin_Table"></table>');	
	$("#PopUpWin").show();
	$("#PopUpWin").css("left",this.tarobj.offset().left);
	$("#PopUpWin").css("top",this.tarobj.offset().top+ this.tarobj.outerHeight());
	
	$('#PopUpWin_Table').dhccTable(option);

	$(window).bind('keydown', function (e){
		if($("#PopUpWin_Table").length == 0){
			return;
		}
		switch (e.keyCode){
			
			case 13: // enter
			    var rowData = $('#PopUpWin_Table').bootstrapTable('getSelections');
		   		removePopUpWin();
		   		fn(rowData[0]);
		   		break ;
        	case 27:  //Esc
		   		removePopUpWin();
		   		break;
		   	case 33:  //Page Up
		   		var currRowIndex = $("#PopUpWin_Table tr.selected").attr("data-index");
		   		var nextRowIndex = parseInt(currRowIndex) - 1;
		   		if (nextRowIndex >= 0){
		   			$('#PopUpWin_Table').bootstrapTable('uncheck',currRowIndex);
		   			$('#PopUpWin_Table').bootstrapTable('check',nextRowIndex);
		   			if (parseInt(nextRowIndex) - 1 >= 0){
		   				$("input[data-index="+(parseInt(nextRowIndex) - 1)+"]").focus();
		   			}
		   		}
		   		break;
		   	case 34:  //Page Down
		   		var rowsData = $('#PopUpWin_Table').bootstrapTable('getData');
		   	    var currRowIndex = $("#PopUpWin_Table tr.selected").attr("data-index");  /// 当前选中行
		   	    var nextRowIndex = parseInt(currRowIndex) + 1;
		   		if (nextRowIndex <= rowsData.length){
		   			$('#PopUpWin_Table').bootstrapTable('uncheck',currRowIndex);
		   			$('#PopUpWin_Table').bootstrapTable('check',parseInt(currRowIndex) + 1);
		   			if (parseInt(nextRowIndex) + 1 <= rowsData.length){
		   				$("input[data-index="+(parseInt(nextRowIndex) + 1)+"]").focus();
		   			}
		   		}
		   		break;
		   	case 38:  //Page Up
		   		var currRowIndex = $("#PopUpWin_Table tr.selected").attr("data-index");
		   		var nextRowIndex = parseInt(currRowIndex) - 1;
		   		if (nextRowIndex >= 0){
		   			$('#PopUpWin_Table').bootstrapTable('uncheck',currRowIndex);
		   			$('#PopUpWin_Table').bootstrapTable('check',nextRowIndex);
		   			if (parseInt(nextRowIndex) - 1 >= 0){
		   				$("input[data-index="+(parseInt(nextRowIndex) - 1)+"]").focus();
		   			}
		   		}
		   		break;
		   	case 40:  //Page Down
		   		var rowsData = $('#PopUpWin_Table').bootstrapTable('getData');
		   	    var currRowIndex = $("#PopUpWin_Table tr.selected").attr("data-index");  /// 当前选中行
		   	    var nextRowIndex = parseInt(currRowIndex) + 1;
		   		if (nextRowIndex < rowsData.length){
		   			$('#PopUpWin_Table').bootstrapTable('uncheck',currRowIndex);
		   			$('#PopUpWin_Table').bootstrapTable('check',parseInt(currRowIndex) + 1);
		   			if (parseInt(nextRowIndex) + 1 <= rowsData.length){
		   				$("input[data-index="+(parseInt(nextRowIndex) + 1)+"]").focus();
		   			}
		   		}
		   		break;
		}
	})
}
