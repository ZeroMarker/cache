/**
 * ģ��:     ����̨ά��
 * ��д����: 2018-03-01
 * ��д��:   QianHuanjuan
 */

$(function() {
    $("#aNext").on("click",function(){
	    var curLeft=parseInt($("#atimeline").css("left"))
	    if(curLeft<0){
			return;   
		}
		$("#atimeline").animate({ "left" : -500 },500);
	})
    $("#aPrev").on("click",function(){
	    var curLeft=parseInt($("#atimeline").css("left"))
		$("#atimeline").animate({ "left" : 25 },500);
	})
});
function MoveNext(){
	}