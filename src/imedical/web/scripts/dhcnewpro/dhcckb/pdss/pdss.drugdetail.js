/*
 * @Author: qunianpeng
 * @Date: 2022-08-18 10:54:45
 * @Descripttion: 药品说明书详情页
 * @version: V1.0
 * @LastEditors: qnp
 * @LastEditTime: 2022-08-18 11:19:59
 */
$(function() {

    var id = '';
    // 初始化药品明细信息
    initDrugDetail(id);

    // 初始化药品列表
    initDrugList();
   
})

function initDrugDetail(id) {
       //  动态创建药品明细
       createDrugDetails(drugdata.data);    
}

/**
 * @description:  动态创建药品说明书详情内容
 * @param {*} drugData
 * @return {*}
 */
 function createDrugDetails(drugData) {
    
     var drugDetail = new DrugDetail(drugData);
     var html = drugDetail.init();
     $('body').append(html);

}


