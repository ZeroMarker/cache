function InitScreenScoreWinEvent(obj){
	CheckSpecificKey();
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	
    //��ѯ��ť
    $("#btnQuery").on('click', function(){
		var txtDateFrom 	= $("#txtDateFrom").val();
		var txtDateTo 		= $("#txtDateTo").val();
		obj.gridScreenSoreList.clear().draw();
		if(txtDateFrom > txtDateTo){
			layer.msg('��ʼ����ӦС�ڻ���ڽ������ڣ�',{time: 2000,icon: 2});
			return;
		}
	    var mylayer = layer.load(1);
		obj.gridScreenSoreList.ajax.reload(function ( json ){
			setTimeout(function(){
			  	layer.closeAll('loading');
			}, 100);
		    if (json.data.length==0){
				layer.msg('û���ҵ�������ݣ�',{time: 2000,icon: 2});
				return;
			}
		});
	});
	
	// ժҪ���
    $('#gridScreenSoreList').on('click','a.zy', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridScreenSoreList.row(tr);
		var rowData = row.data();
		
		var EpisodeID = rowData.EpisodeDr;
		var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&1=1';
		/*parent.layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:false,
			  closeBtn:0,
			  fixed: false, //���̶�
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});*/
		showFullScreenDiag(url,"");
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