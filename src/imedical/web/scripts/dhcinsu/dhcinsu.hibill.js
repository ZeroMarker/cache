/*
 * FileName: dhcinsu.hibill.js -4101
 * Author: DingSH
 * Modify: Lxy
 * Date: 2022-03-07
 * Description: ҽ�����������㵥
*/
var chsBill = {};
var GV=
{
	   WindPrtnFlag:'N',
	   Rq:''
}
$(function () {
        var data=getChsBillData();
        chsBill.setlinfo = data.setlinfo;
        //��������Ϣ
        chsBill.dealBase(data.setlinfo);
        //����������ز�������Ϣ
        chsBill.dealSpecial(data.opspdiseinfo);
        //�������б�
        chsBill.dealDiag(data.diseinfo);
        //��������б�
        chsBill.dealOper(data.oprninfo);
        //���ICU�б�
        chsBill.dealICU(data.icuinfo);
        //�����Ѫ�б�
        //chsBill.dealBlood(data.bloodList);
        chsBill.dealBlood(data.bldinfo);
        chsBill.iteminfo = data.iteminfo;
        //�������б�
        chsBill.dealFee(data.iteminfo);
        //������֧�������б�
        chsBill.otherPay(data.payinfo);
        
	   //��ӡ
	   $('#btn-print').bind('click', function(){
	        btnprint();
	    })
});

chsBill.dealDate = function (data,type) {
    //yyyy-MM-dd HH:mm:ss
    var dataArray = data ? data.split("-") : null;
    if(!dataArray || dataArray.length<2){
        //yyyy/MM/dd HH:mm:ss
        dataArray = data ? data.split("/") : null;
        if(!dataArray || dataArray.length<2){
            //yyyyMMdd HH:mm:ss
            if(data && data.length >7){
                dataArray[0] = data.substr(0,4);
                dataArray[1] = data.substr(4,2);
                dataArray[2] = data.substr(6);
            }
        }
    }
    var year = (dataArray && dataArray.length>0) ? dataArray[0]:"";
    var month = (dataArray && dataArray.length>1) ? dataArray[1]:"";
    var day = (dataArray && dataArray.length>2) ? dataArray[2]:"";
    var hour = "";
    if(day && ""!=day){
        var da = day.split(":");
        if(day.indexOf(":")>-1 && day.length>2){
            hour = day.substr(day.indexOf(":")-2,2);
        }
        if(day.length>2){
            day = day.substr(0,2);
        }
    }
    chsBill.setlinfo[type+"Year"] = year;
    chsBill.setlinfo[type+"Month"] = month;
    chsBill.setlinfo[type+"Day"] = day;
    chsBill.setlinfo[type+"Hour"] = hour;
    $('#'+type+'Year').html( year );
    $('#'+type+'Month').html( month );
    $('#'+type+'Day').html( day );
    $('#'+type+'Hour').html( hour );
};
//��������Ϣ
chsBill.dealBase = function (setlinfo) {
    if(setlinfo){
        for (var fieldCode in setlinfo) {
            if (setlinfo.hasOwnProperty(fieldCode)) {
                var baseData = setlinfo[fieldCode];
                if("dcla_time"==fieldCode){//�걨ʱ��
                    chsBill.dealDate(baseData,"dcla_time");
                }else if("brdy"==fieldCode){//��������
                    chsBill.dealDate(baseData,"brdy");
                }else if("adm_time"==fieldCode){//��Ժʱ��
                    chsBill.dealDate(baseData,"adm_time");
                }else if("dscg_time"==fieldCode){//��Ժʱ��
                    chsBill.dealDate(baseData,"dscg_time");
                }else if("setl_begn_date"==fieldCode){//���㿪ʼʱ��
                    chsBill.dealDate(baseData,"setl_begn_date");
                }else if("setl_end_date"==fieldCode){//�������ʱ��
                    chsBill.dealDate(baseData,"setl_end_date");
                }else{
                    $('#' + fieldCode).html(baseData);
                }
            }
        }
    }
};
//����������ز�������Ϣ
chsBill.dealSpecial= function (specialOperAndDiag) {;
    var specialLength = 0;
    if(null != specialOperAndDiag){
        specialLength = specialOperAndDiag.length;
    }
    var specialArray = [];
    for(var i=0;i<specialLength;i++){
        var sa = [];
        (specialOperAndDiag[i] && specialOperAndDiag[i]["diag_name"]) ? sa.push(specialOperAndDiag[i]["diag_name"]) : sa.push("");
        (specialOperAndDiag[i] && specialOperAndDiag[i]["diag_code"]) ? sa.push(specialOperAndDiag[i]["diag_code"]) : sa.push("");
        (specialOperAndDiag[i] && specialOperAndDiag[i]["oprn_oprt_name"]) ? sa.push(specialOperAndDiag[i]["oprn_oprt_name"]) : sa.push("");
        (specialOperAndDiag[i] && specialOperAndDiag[i]["oprn_oprt_code"]) ? sa.push(specialOperAndDiag[i]["oprn_oprt_code"]) : sa.push("");
        specialArray.push(sa);
    }
    // chsBill.specialArray = specialArray;
    var specialTrs = '';
    if(specialArray.length>0){
        $.each(specialArray,function (i,spa) {
            specialTrs += '<tr>';
            $.each(spa,function (j,data) {
                specialTrs += '<td>'+data+'</td>';
            });
            specialTrs += '</tr>';
        });
    }else{
        specialTrs +='<tr><td></td><td></td><td></td><td></td></tr>';
    }
    $('#slowDisease').append(specialTrs);
};
//�������б�
chsBill.dealDiag= function (diseinfo) {
    var diagTrs = '<tr class="title"><td>��Ժ��ҽ���</td><td>��������</td><td>��Ժ����</td><td>��Ժ��ҽ���</td><td>��������</td><td>��Ժ����</td></tr>';
    if (diseinfo && diseinfo.length>0){
        //����������
        var diag1 = [];//��ҽ��Ҫ���
        var diag2 = [];//��ҽ�������
        var diag3 = [];//��ҽ����
        var diag4 = [];//��ҽ��֤
        for (var i=0;i<diseinfo.length;i++){
            var obj = diseinfo[i];
            switch (obj["diag_type"]){
                case '1':
                    diag1.push(obj);
                    break;
                case '2':
                    diag2.push(obj);
                    break;
                case '3':
                    diag3.push(obj);
                    break;
                case '4':
                    diag4.push(obj);
                    break;
            }
        }

        //������Ҫ��Ϻ�������ƴ�ӣ�������û�ж�Ҫƴ��һ�У�
        //��ֹ����Cannot read property 'xxx' of undefined
        if (diag1[0] == undefined) { diag1[0] = {}; }
        if (diag3[0] == undefined) { diag3[0] = {}; }
        diagTrs +='<tr>';
        diagTrs += '<td>'+'��Ҫ��ϣ�'+'<span title="��ҽ���">'+chsBill.dealNumber(diag1[0]["diag_name"])+'</span></td>';
        diagTrs += '<td><span title="��ҽ��������">'+chsBill.dealNumber(diag1[0]["diag_code"])+'</span></td>';
        diagTrs += '<td><span title="��ҽ��Ժ����">'+chsBill.dealNumber(diag1[0]["adm_cond_type"])+'</span></td>';
        diagTrs += '<td>'+'������'+'<span title="��ҽ���">'+chsBill.dealNumber(diag3[0]["diag_name"])+'</span></td>';
        diagTrs += '<td><span title="��ҽ��������">'+chsBill.dealNumber(diag3[0]["diag_code"])+'</span></td>';
        diagTrs += '<td><span title="��ҽ��Ժ����">'+chsBill.dealNumber(diag3[0]["adm_cond_type"])+'</span></td>';
        diagTrs +='</tr>';

        //����������Ϻ���֤��ƴ�ӣ�������û�ж�Ҫƴ��һ�У�
        var length = diag2.length>diag4.length?diag2.length:diag4.length;
        if (diag2.length == 0 && diag4.length == 0){
            length = 1;
        }
        for (var i=0;i<length;i++){
            //��ֹ����Cannot read property 'xxx' of undefined
            if (diag2[i] == undefined) { diag2[i] = {}; }
            if (diag4[i] == undefined) { diag4[i] = {}; }
            diagTrs +='<tr>';
            diagTrs += '<td>'+((i==0)?'������ϣ�':'')+'<span title="��ҽ���">'+chsBill.dealNumber(diag2[i]["diag_name"])+'</span></td>';
            diagTrs += '<td><span title="��ҽ��������">'+chsBill.dealNumber(diag2[i]["diag_code"])+'</span></td>';
            diagTrs += '<td><span title="��ҽ��Ժ����">'+chsBill.dealNumber(diag2[i]["adm_cond_type"])+'</span></td>';
            diagTrs += '<td>'+((i==0)?'��֤��':'')+'<span title="��ҽ���">'+chsBill.dealNumber(diag4[i]===undefined?"":diag4[i]["diag_name"])+'</span></td>';
            diagTrs += '<td><span title="��ҽ��������">'+chsBill.dealNumber(diag4[i]===undefined?"":diag4[i]["diag_code"])+'</span></td>';
            diagTrs += '<td><span title="��ҽ��Ժ����">'+chsBill.dealNumber(diag4[i]===undefined?"":diag4[i]["adm_cond_type"])+'</span></td>';
            diagTrs +='</tr>';
        }
    }else{
        diagTrs +='<tr><td>��Ҫ��ϣ�</td><td></td><td></td><td>������</td><td></td><td></td></tr>';
        diagTrs +='<tr><td>������ϣ�</td><td></td><td></td><td>��֤��</td><td></td><td></td></tr>';
    }

    diagTrs +='<tr><td colspan="6"><div class="field">��ϴ������<span class="field" id="diag_code_cnt">'+chsBill.dealNumber(chsBill.setlinfo["diag_code_cnt"])+'</span></div></td></tr>';
    $('#diseinfo').append(diagTrs);
};
//��������б�
chsBill.dealOper=function(oprninfo){
    var operArray = [];
    //ɸѡ��Ҫ���
    var opera = [];
    var index=-1;
    for(var i=0;i<oprninfo.length;i++){
        var obj = oprninfo[i];
        if(obj && obj["oprn_oprt_type"] && obj["oprn_oprt_type"]=="1"){
            index= i;
            opera = oprninfo.slice(i,i+1);
            break;
        }
    };
    if(index >-1){
        oprninfo.splice(index,1);//ɾ����Ҫ����
    }
    operArray = opera.concat(oprninfo);
    var operTrs = '';
    if(operArray && operArray.length>0){
        var operType = '��Ҫ'
        var operIndex = ''
        for(var i=0;i<operArray.length;i++) {
            if (i>0) {
                operType = '����';
                operIndex = i
            }
            operTrs +='<tr class="title"><td width="30%">'+operType+'��������������'+operIndex+'</td><td width="20%">'+operType+'��������������'+operIndex+'</td><td width="10%">����ʽ</td><td width="10%">����ҽʦ����</td><td width="10%">����ҽʦ����</td><td width="10%">����ҽʦ����</td><td width="10%">����ҽʦ����</td></tr>'
            operTrs +='<tr>';
            operTrs +='<td><span title="��������������" class="field" data-resume id="operName'+operArray[i]["OPER_INDEX"]+'">'+chsBill.dealNumber(operArray[i]["oprn_oprt_name"])+'</span></td>';
            operTrs +='<td><span title="��������������" class="field" data-resume id="operCode'+operArray[i]["OPER_INDEX"]+'">'+chsBill.dealNumber(operArray[i]["oprn_oprt_code"])+'</span></td>';
            operTrs +='<td><span title="����ʽ" class="field" data-resume id="anesthesiaWayDesc'+operArray[i]["OPER_INDEX"]+'">'+chsBill.dealNumber(operArray[i]["anst_way"])+'</span></td>';
            operTrs +='<td><span title="����ҽʦ����" class="field" data-resume id="operDocName'+operArray[i]["OPER_INDEX"]+'">'+chsBill.dealNumber(operArray[i]["oper_dr_name"])+'</span></td>';
            operTrs +='<td><span title="����ҽʦ����" class="field" data-resume id="operDocCode'+operArray[i]["OPER_INDEX"]+'">'+chsBill.dealNumber(operArray[i]["oprn_oprt_code"])+'</span></td>';
            operTrs +='<td><span title="����ҽʦ����" class="field" data-resume id="anesthesiaDocName'+operArray[i]["OPER_INDEX"]+'">'+chsBill.dealNumber(operArray[i]["anst_dr_name"])+'</span></td>';
            operTrs +='<td><span title="����ҽʦ����" class="field" data-resume id="anesthesiaDocCode'+operArray[i]["OPER_INDEX"]+'">'+chsBill.dealNumber(operArray[i]["anst_dr_code"])+'</span></td>';
            operTrs +='</tr>';
            operTrs +='<tr><td colspan="7"><div class="field">������������ֹʱ��<span title="������������ֹʱ��" class="field" data-resume id="operDateStr'+operArray[i]["OPER_INDEX"]+'">'+chsBill.dealNumber(operArray[i]["oprn_oprt_date"])+(chsBill.dealNumber(operArray[i]["oprn_oprt_date"])===''?'':'~')+chsBill.dealNumber(operArray[i]["oprn_oprt_endtime"])+'</span></div>';
            operTrs +='<div class="field">������ֹʱ��<span title="������ֹʱ��" class="field" data-resume id="anesDateStr'+operArray[i]["OPER_INDEX"]+'">'+chsBill.dealNumber(operArray[i]["anst_begntime"])+(chsBill.dealNumber(operArray[i]["anst_begntime"])===''?'':'~')+chsBill.dealNumber(operArray[i]["anst_endtime"])+'</span></div></td></tr>';
        }
        if(operArray.length===1){
            operTrs +='<tr class="title"><td width="30%">������������������</td><td width="20%">������������������</td><td width="10%">����ʽ</td><td width="10%">����ҽʦ����</td><td width="10%">����ҽʦ����</td><td width="10%">����ҽʦ����</td><td width="10%">����ҽʦ����</td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
            operTrs +='<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
            operTrs +='<tr><td colspan="7"><div class="field">������������ֹʱ��<span title="������������ֹʱ��" class="field"></span></div><div class="field">������ֹʱ��<span title="������ֹʱ��" class="field"></span></div></td></tr>';
        }
    } else {
        operTrs +='<tr class="title"><td width="30%">��Ҫ��������������</td><td width="20%">��Ҫ��������������</td><td width="10%">����ʽ</td><td width="10%">����ҽʦ����</td><td width="10%">����ҽʦ����</td><td width="10%">����ҽʦ����</td><td width="10%">����ҽʦ����</td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
        operTrs +='<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
        operTrs +='<tr><td colspan="7"><div class="field">������������ֹʱ��<span title="������������ֹʱ��" class="field"></span></div><div class="field">������ֹʱ��<span title="������ֹʱ��" class="field"></span></div></td></tr>';
        operTrs +='<tr><td colspan="7"><div class="field">�����������������<span class="field"></span></td></tr>';
        operTrs +='<tr class="title"><td width="30%">������������������</td><td width="20%">������������������</td><td width="10%">����ʽ</td><td width="10%">����ҽʦ����</td><td width="10%">����ҽʦ����</td><td width="10%">����ҽʦ����</td><td width="10%">����ҽʦ����</td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
        operTrs +='<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
        operTrs +='<tr><td colspan="7"><div class="field">������������ֹʱ��<span title="������������ֹʱ��" class="field"></span></div><div class="field">������ֹʱ��<span title="������ֹʱ��" class="field"></span></div></td></tr>';
    }
    operTrs +='<tr><td colspan="7"><div class="field">�����������������<span class="field" id="oprn_oprt_code_cnt">'+chsBill.dealNumber(chsBill.setlinfo["oprn_oprt_code_cnt"])+'</span></div></td></tr>';
    $("#oprninfo").append(operTrs);
};
//���ICU�б�
chsBill.dealICU=function(icuinfo){
    var icuTrs = '<tr class="title"><td width="35%"><span>��֢�໤��������</span><br/><span>(CCU��NICU��EICU��SICU��PICU��RICU��ICU(�ۺ�)������)</span></td><td width="20%"><span>����֢�໤��ʱ��</span><br/><span>(_��_��_��_ʱ_��)</span></td><td width="20%"><span>����֢�໤��ʱ��</span><br/><span>(_��_��_��_ʱ_��)</span></td><td width="25%">�ϼƣ�_ʱ_�֣�</td></tr>';
    if(icuinfo && icuinfo.length>0){
        for(var i=0;i<icuinfo.length;i++){
            icuTrs +='<tr>';
            icuTrs +='<td>'+(icuinfo[i]["scs_cutd_ward_type"] ? icuinfo[i]["scs_cutd_ward_type"]:"")+'</td>';
            icuTrs +='<td>'+(icuinfo[i]["scs_cutd_inpool_time"] ? icuinfo[i]["scs_cutd_inpool_time"]:"")+'</td>';
            icuTrs +='<td>'+(icuinfo[i]["scs_cutd_exit_time"] ? icuinfo[i]["scs_cutd_exit_time"]:"")+'</td>';
            icuTrs +='<td>'+(icuinfo[i]["ICU_HOUR"] ? icuinfo[i]["ICU_HOUR"]:"")+'</td>';
            icuTrs +='</tr>';
        }
    }else{
        icuTrs +='<tr><td></td><td></td><td></td><td></td></tr>';
    }
    $("#icuinfo").append(icuTrs);
};

//�����Ѫ�б�
chsBill.dealBlood=function(bloodList){
    var bloodTrs = '<tr class="title"><td width="35%"><span>��ѪƷ��</span></td><td><span>��Ѫ��</span></td><td width="25%">��Ѫ������λ</td></tr>';
    if(bloodList && bloodList.length>0){
        for(var i=0;i<bloodList.length;i++){
            bloodTrs +='<tr>';
            bloodTrs +='<td><span title="��ѪƷ��" class="field" data-resume id="bloodType'+bloodList[i]["bld_cat"]+'">'+bloodList[i]["bld_cat"]+'</span></td>';
            bloodTrs +='<td><span title="��Ѫ��" class="field" data-resume id="bloodValue'+bloodList[i]["bld_amt"]+'">'+chsBill.dealNumber(bloodList[i]["bld_amt"])+'</span></td>';
            bloodTrs +='<td><span title="��Ѫ������λ" class="field" data-resume id="bloodUnit'+bloodList[i]["bld_unt"]+'">'+bloodList[i]["bld_unt"]+'</span></td>';
            bloodTrs +='</tr>';
        }
    }else{
        bloodTrs +='<tr><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td></tr>';
    }
    $("#bloodList").append(bloodTrs);
};

//�������б�
chsBill.dealFee=function(iteminfo){
    var feeTrs = '<tr><td style="width:25%">��Ŀ����</td><td style="width:15%">���</td><td style="width:15%">����</td><td style="width:15%">����</td><td style="width:15%">�Է�</td><td style="width:15%">����</td></tr>';
    if(iteminfo){
        var totalObj = {"med_chrgitm_desc":"���ϼ�","med_chrgitm":"feeTotal","amt":chsBill.dealNumber(chsBill.setlinfo["amt_total"]),
            "claa_sumfee":chsBill.dealNumber(chsBill.setlinfo["claa_sumfee_total"]),
            "clab_amt":chsBill.dealNumber(chsBill.setlinfo["clab_amt_total"]),
            "fulamt_ownpay_amt":chsBill.dealNumber(chsBill.setlinfo["fulamt_ownpay_amt_total"]),
            "oth_amt":chsBill.dealNumber(chsBill.setlinfo["oth_amt_total"])};
        iteminfo.push(totalObj);
        for(var m=0;m<iteminfo.length;m++){
            feeTrs +='<tr>';
            feeTrs +='<td><span title="��Ŀ����">'+chsBill.dealNumber(iteminfo[m]["med_chrgitm_desc"])+'</span></td>';
            feeTrs +='<td><span title="���" class="field" data-resume id="'+iteminfo[m]["med_chrgitm"]+'">'+chsBill.dealNumber(iteminfo[m]["amt"])+'</span></td>';
            feeTrs +='<td><span title="����" class="field" data-resume id="'+iteminfo[m]["med_chrgitm"]+'A">'+chsBill.dealNumber(iteminfo[m]["claa_sumfee"])+'</span></td>';
            feeTrs +='<td><span title="����" class="field" data-resume id="'+iteminfo[m]["med_chrgitm"]+'B">'+chsBill.dealNumber(iteminfo[m]["clab_amt"])+'</span></td>';
            feeTrs +='<td><span title="�Է�" class="field" data-resume id="'+iteminfo[m]["med_chrgitm"]+'C">'+chsBill.dealNumber(iteminfo[m]["fulamt_ownpay_amt"])+'</span></td>';
            feeTrs +='<td><span title="����" class="field" data-resume id="'+iteminfo[m]["med_chrgitm"]+'O">'+chsBill.dealNumber(iteminfo[m]["oth_amt"])+'</span></td>';
            feeTrs +='</tr>';
        }
        $("#feeList").append(feeTrs);
    }
}

//�������֧�������б�
chsBill.otherPay=function(payinfo){
    var fundDataArray = [];
    if(payinfo && payinfo.length>0){
	    var j=0
        for(var i=0;i<payinfo.length;i++){
            var dataArray = [];
            var fee = payinfo[i];
            if (fee["oth_pay_flag"]=="1")  //��������֧�������־
            {
               dataArray.push(fee["fund_pay"]?fee["fund_pay"]:'');
               if(fee["fund_payamt"] || fee["fund_payamt"]==0){
                dataArray.push(fee["fund_payamt"]);
               }else{
                dataArray.push('');
               }
                dataArray.push(fee["fund_pay_type"]);
                fundDataArray.push(dataArray);
                j=j+1;
            }
        }
        //����Ҫ��2������
        if(fundDataArray.length===1){
            fundDataArray.push(['','','']);
        }
        if(fundDataArray.length===0){
            fundDataArray.push(['','','']);
            fundDataArray.push(['','','']);
        }
        
    }else{//����Ҫ��2������
        fundDataArray.push(['','','']);
        fundDataArray.push(['','','']);
    }

    var rows = fundDataArray.length;
    var rowspan1 = Math.round(rows/2);
    var rowspan2 = rows - rowspan1;
    var trs = '';
    for(var i=0; i < rows; i++){
        var feeName = chsBill.dealNumber(fundDataArray[i][0]);
        var feeCode = fundDataArray[i][2];
        var feeValue = chsBill.dealNumber(fundDataArray[i][1]);
        if (i === 0) {
            trs = '<tr>' +
                '<td rowspan="'+rows+'" width="20%" class="font-bold">����֧��</td>' +
                '<td width="20%">'+feeName+'</td>' +
                '<td width="15%"><span class="field" id="'+feeCode+'OtherFee">'+feeValue+'</span></td>' +
                '<td rowspan="'+rows+'" width="15%" class="font-bold">���˸���</td>' +
                '<td rowspan="'+rowspan1+'" width="15%">�����˻�֧��</td>' +
                '<td rowspan="'+rowspan1+'"><span class="field" id="acct_pay">'+chsBill.dealNumber(chsBill.setlinfo.acct_pay)+'</span></td>' +
                '</tr>'
        } else if (i === rowspan1) {
            trs += '<tr><td>'+feeName+'</td><td><span class="field" id="'+feeCode+'OtherFee">'+feeValue+'</span></td><td rowspan="'+rowspan2+'">�����ֽ�֧��</td><td rowspan="'+rowspan2+'"><span class="field" id="psn_cashpay">'+chsBill.dealNumber(chsBill.setlinfo.psn_cashpay)+'</span></td></tr>'
        } else {
            trs += '<tr><td>'+feeName+'</td><td><span class="field" id="'+feeCode+'OtherFee">'+feeValue+'</span></td></tr>'
        }
    }
    $("#payList").append(trs);
};
chsBill.dealNumber=function (data) {
    if(data || data==0){
        return data;
    }else{
        return '';
    }
};

/*
  ��ȡ��������嵥����
*/
function getChsBillData(){
	GV.Rq="";
	var Rq = INSUGetRequest();  //dhcinsu/common/dhcinsu.common.js
	var InDivDr = Rq["InDivDr"]; 
	var AdmDr = Rq["AdmDr"]; 
	var EId = Rq["EId"];
	var UpFag = Rq["UpFag"]; 
	var Infno = Rq["Infno"]; 
	var CkVal = Rq["CkVal"]; 
	var InputInfo = Rq["InputInfo"]; 
	var InArgType = Rq["InArgType"]; 
	var OutArgType = Rq["OutArgType"]; 
	GV.Rq=Rq ;    
	var options={
		ClassName:"web.DHCINSUEprUl",
		MethodName:"GetEprStr",
		DivDr: InDivDr,
		EId: EId,
		Infno:Infno
	   }
	   
	/*if((UpFag=="�ϴ��ɹ�")||(((UpFag=="�ϴ�ʧ��"))&&(!CkVal)))
	{
		var options={
		ClassName:"web.DHCINSUEprUl",
		//MethodName:"GetErpiInargInfo",
		//DivDr: InDivDr,
		//UploadId: EId,
		MethodName:"GetEprStr",
		DivDr: InDivDr,
		EId: EId,
		Infno:Infno
	   }
	}
    else
	{
	 //ҽ������^�ӿڱ��^ҽԺID^����ԱID^0^102^1^�����^InsuDivID
	 var options={
		ClassName:"INSU.OFFBIZ.BL.BIZ00A",
		MethodName:"InsuSettlementUL",
		InputInfo: InputInfo,
		InArgType: InArgType,
		OutArgType:OutArgType
	 }
	}*/
	var ret=$m(options,false);
	try{
		var data=JSON.parse(ret);
		return  data.input;
		
	}catch(ex){
		 $.messager.alert('��ʾ', '�嵥JSON�����л��쳣ex'+ex.message+","+ret , 'error');
		 return false;
		}
	 return data;
}
function btnprint(){
	/*
     var params = "&DivDr=" +GV.Rq["InDivDr"]+"&EId=" +GV.Rq["EId"]+"&Infno="+GV.Rq["Infno"] ;
	 var fileName = "dhcinsu.hibill-4101.rpx" + params;
	 DHCCPM_RQPrint(fileName, ($(window).width()), $(window).height());
	*/
	
	var params = "DivDr=" + GV.Rq["InDivDr"] + ";" + "EId=" +GV.Rq["EId"] + ";" + "Infno=" + GV.Rq["Infno"]; 
	var fileName = "dhcinsu.hibill-4101.rpx";
	fileName = "{" + fileName + "(" + params + ")}";
	DHCCPM_RQDirectPrint(fileName);
	if(GV.WindPrtnFalg =="Y") {
	   $("#btn-print").hide();
	   preview(1);
	   $("#btn-print").show();
	}
}
function preview(mode)
{
	if (mode < 10){
		buildData()
		var body = window.document.body.innerHTML;
		var form = $("#printdiv").html();
		window.document.title="";
		window.document.body.innerHTML = form;
		window.print();
		window.document.body.innerHTML = body;
		
	} else {
		window.print();
	}
}

function buildData(){
	//�� type=text, ͬʱ���checkbox,radio,select>option��ֵ�б仯, Ҳ��һ��, �������button
	$("input,select option").each(function(){
		$(this).attr('value',$(this).val());
	});
	
	//�� type=checkbox,type=radio ѡ��״̬
	$("input[type='checkbox'],input[type='radio']").each(function(){
		if($(this).attr('checked'))
			$(this).attr('checked',true);
		else
			$(this).removeAttr('checked');
	});
	
	//�� selectѡ��״̬
	$("select option").each(function(){
		if($(this).attr('selected'))
			$(this).attr('selected',true);
		else
			$(this).removeAttr('selected');
	});
	
	//�� textarea
	$("textarea").each(function(){
		$(this).html($(this).val());
	});
	
}