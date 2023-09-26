//页面Event
function InitOEDRTListWinEvent(obj){
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridOEItemList').DataTable().search($('#search').val(),true,true).draw();
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridOEItemList.search(this.value).draw();
        }
    });
    /****************/
}

