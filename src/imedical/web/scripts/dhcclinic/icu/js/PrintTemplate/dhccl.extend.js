var canvas = document.getElementById("myCanvas");
var displaySheet = $(canvas).data("displaySheet");


/*  
    ../service/dhcanop/js/PrintTemplate/dhccl.extend.js
*/

$('#zongfen').val("1222")

$('#dt1,#dt2').datetimebox({
	onChange: function(){
        var dt1 = $('#dt1').datetimebox('getValue');
        var dt2 = $('#dt2').datetimebox('getValue');
        $("#textbox").val(calcDuration(dt1, dt2));
	}
});

function calcDuration(dt1, dt2) {
    if(!dt1) return;
    if(!dt2) return;

    var date1 = new Date(dt1);
    var date2 = new Date(dt2);
    var dateDiff = (date2.getTime() - date1.getTime()) / 1000;

    var hours = parseInt(dateDiff / 3600);
    var minutes = parseInt(dateDiff % 3600 / 60);
    return hours + "小时" + minutes + "分";
}


