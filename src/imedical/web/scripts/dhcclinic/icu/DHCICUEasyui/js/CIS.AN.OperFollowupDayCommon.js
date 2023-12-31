//20210802
var EpisodeID=getEpisodeByMenu();
var dhc={
    /*
    获取url传递的参数值
    */
    getUrlParam:function(name)
    {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
        var r = window.location.search.substr(1).match(reg);
        if (r != null) return unescape(r[2]);
        return null;
    }	
}
var opsId=dhc.getUrlParam("opsId");

function initPage(){

    $(".spinner-text").each(function(index,item){
        var spinnerWidth=$(item).width();
        $(item).css("width",(spinnerWidth-5)+"px");
    });
    //设置默认值
    dhccl.parseDateFormat();
    initForm();
}

function initForm(){
    setDefaultPatInfo();   //标题栏
}

//标题栏
function setDefaultPatInfo()
{
    var banner=operScheduleBanner.init('#patinfo_banner', {});
     dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: CLCLS.BLL.Admission,
        QueryName: "FindPatient",
        Arg1: EpisodeID,
        ArgCnt: 1
     }, "json", true, function(appDatas) {
        if (appDatas && appDatas.length > 0) {
               banner.loadData(appDatas[0]);
         }
    });
    
}

//获取标题栏内容
function getEpisodeByMenu(){
    var EpisodeID="";
	var dhc={
		/*
		获取url传递的参数值
		*/
		getUrlParam:function(name)
		{
			var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
			var r = window.location.search.substr(1).match(reg);
			if (r != null) return unescape(r[2]);
			return null;
		}	
	}
    EpisodeID=dhc.getUrlParam("EpisodeID");
    return EpisodeID;
}



$(document).ready(initPage);

