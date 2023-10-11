/*
 * @Author: qunianpeng
 * @Date: 2022-08-18 10:54:45
 * @Descripttion: 药品说明书详情页
 * @version: V1.0
 * @LastEditors: qnp
 * @LastEditTime: 2022-08-18 11:19:59
 */
$(function() {

    //var id = '';
    // 初始化药品明细信息
    initDrugDetail(IncId);

   
})

function initDrugDetail(IncId) {
	
	var drugData = ""
	runClassMethod("web.DHCCKBPdssIndex","queryDrugDetail",{"drugId":IncId,"userInfo":LoginInfo},function(res){
		drugData = res;
		//  动态创建药品明细
    	createDrugDetails(drugData);   
	},'json',false);
 
}

/**
 * @description:  动态创建药品说明书详情内容
 * @param {*} drugData
 * @return {*}
 */
 function createDrugDetails(drugData) {
	 
     $(".details").show();
     $('.details').empty();
     //drugData.state = -104;
     var html = "";
     if ((drugData== "")||(drugData.state < 0)||(drugData.data=="")||(drugData.data==undefined)||(drugData.data.instru=="")){
	    html = '<div class="detail_notdata"><div class="detail_notdata-tips">暂无记录，去其他地方看看吧~</div></div>';	 
     }
     else{
	    var drugDetail = new DrugDetail(drugData.data);
     	html = drugDetail.init();      
	 }
	 $('.details').append(html);
     

}


