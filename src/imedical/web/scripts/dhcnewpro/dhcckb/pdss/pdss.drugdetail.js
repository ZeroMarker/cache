/*
 * @Author: qunianpeng
 * @Date: 2022-08-18 10:54:45
 * @Descripttion: ҩƷ˵��������ҳ
 * @version: V1.0
 * @LastEditors: qnp
 * @LastEditTime: 2022-08-18 11:19:59
 */
$(function() {

    var id = '';
    // ��ʼ��ҩƷ��ϸ��Ϣ
    initDrugDetail(id);

    // ��ʼ��ҩƷ�б�
    initDrugList();
   
})

function initDrugDetail(id) {
       //  ��̬����ҩƷ��ϸ
       createDrugDetails(drugdata.data);    
}

/**
 * @description:  ��̬����ҩƷ˵������������
 * @param {*} drugData
 * @return {*}
 */
 function createDrugDetails(drugData) {
    
     var drugDetail = new DrugDetail(drugData);
     var html = drugDetail.init();
     $('body').append(html);

}


