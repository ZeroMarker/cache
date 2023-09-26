function InitCtlBactResultWinEvent(obj){
	CheckSpecificKey();
	
    layer.config({  
		extend: 'layerskin/style.css' 
	});
	var CheckFlg = 0;  
	if (tDHCMedMenuOper['Admin']==1) {
		CheckFlg = 1; //审核权限
	}

	/*****搜索功能*****/
	$("#btnsearch").on('click', function(){
	   $('#gridCtlResult').DataTable().search($('#search').val(),true,true).draw();
	   
	});

	$("#search").keyup(function(event){
	    if (event.keyCode == 13) {
	        obj.gridCtlResult.search(this.value).draw();
	    }
	});
	/****************/
    //查询按钮
    $("#btnQuery").on('click', function(){
		var DateFrom 	= $("#DateFrom").val();
		var DateTo 		= $("#DateTo").val();
		obj.gridCtlResult.clear().draw();
		if(DateFrom > DateTo){
			layer.msg('开始日期应小于或等于结束日期！',{time: 2000,icon: 2});
			return;
		}
	    var mylayer = layer.load(1);
		obj.gridCtlResult.ajax.reload(function ( json ){
			setTimeout(function(){
			  	layer.closeAll('loading');
			}, 100);
		    if (json.data.length==0){
				layer.msg('没有找到相关数据！',{time: 2000,icon: 2});
				return;
			}
		});
	});
     //导出
    $("#btnExport").on('click', function(){
		obj.gridCtlResult.buttons(0,null)[1].node.click();
	});
    /*
 	//打印
    $("#btnPrint").on('click', function(){
	    obj.gridCtlResult.buttons(0,null)[2].node.click();
		
	});
	*/
	new $.fn.dataTable.Buttons(obj.gridCtlResult, {
		buttons: [
			{
				extend: 'csv',
				text:'导出'
			},
			{
				extend: 'excel',
				text:'导出',
				title:"病原体监测"
				,footer: true
				,exportOptions: {
					columns: ':visible'
					,width:50
					,orthogonal: 'export'
				},
				customize: function( xlsx ) {
					var sheet = xlsx.xl.worksheets['sheet.xml'];
					
				}
			},
			{
				extend: 'print',
				text:'打印'
				,title:""
				,footer: true
			}
		]
	});

    //药敏结果链接选中方式
    $('#gridCtlResult').on('click','a.btnLabSen', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridCtlResult.row(tr);
		var rowData = row.data();
	    obj.ResultID=rowData["ResultID"];
	    var PatName=rowData["PatName"];
	    var Sex=rowData["Sex"];
	    switch (Sex){
			case '女':
				var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-girl.png"></img>';
				break;
			case '男':
				var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-boy.png"></img>'
				break;
			default:
				var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-boy.png"></img>'
				break;
		}
	    obj.gridIRDrugSen.ajax.reload();
		layer.open({
			type: 1,
			zIndex: 100,
			offset: '80px',
			area: '600px',
			title:[imgHtml+' '+PatName]+'  药敏结果',
			content: $('#layer_one')			
		});
	
    });
    
}
			
function getContentSize() {
    var wh = document.documentElement.clientHeight; 
    var eh = 166;
    var ch = (wh - eh) + "px";
    obj = document.getElementById("mCSB_1");
    var dh=$('div.dataTables_scrollHead').height();
    var sh=(wh - eh + dh )+ "px"; 
    if (obj){  
   		obj.style.height = ch;
    }else {
	   $('div.dataTables_scrollBody').css('height',sh);
    }
}
/*
//Chrome在窗口改变大小时会执行两次       
var isResizing = false;
window.onresize =function(){	
	if (!isResizing) {
		getContentSize();   
		setTimeout(function () {
			isResizing = false;
		}, 100);
	}
	isResizing = true;
}
window.onload = function(){
	 setTimeout(function () {
     	getContentSize();
    }, 100);
}
*/
