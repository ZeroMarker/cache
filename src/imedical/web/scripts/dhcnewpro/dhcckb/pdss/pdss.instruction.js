/*
 * @Author: qunianpeng
 * @Date: 2022-08-18 10:54:45
 * @Descripttion: ҩƷ˵��������ҳ
 * @version: V1.0
 * @LastEditors: qnp
 * @LastEditTime: 2022-08-18 11:19:59
 */
$(function() {

    //var id = '';
    // ��ʼ��ҩƷ��ϸ��Ϣ
    initDrugDetail(IncId);

   
})

function initDrugDetail(IncId) {
	
	var drugData = ""
	runClassMethod("web.DHCCKBPdssIndex","queryDrugDetail",{"drugId":IncId,"userInfo":LoginInfo},function(res){
		drugData = res;
		//  ��̬����ҩƷ��ϸ
    	createDrugDetails(drugData);   
	},'json',false);
 
}

/**
 * @description:  ��̬����ҩƷ˵������������
 * @param {*} drugData
 * @return {*}
 */
 function createDrugDetails(drugData) {
	 
     $(".details").show();
     $('.details').empty();
     //drugData.state = -104;
     var html = "";
     if ((drugData== "")||(drugData.state < 0)||(drugData.data=="")||(drugData.data==undefined)||(drugData.data.instru=="")){
	    html = '<div class="detail_notdata"><div class="detail_notdata-tips">���޼�¼��ȥ�����ط�������~</div></div>';	 
     }
     else{
	    var drugDetail = new DrugDetail(drugData.data);
     	html = drugDetail.init();      
	 }
	 $('.details').append(html);
     

}


